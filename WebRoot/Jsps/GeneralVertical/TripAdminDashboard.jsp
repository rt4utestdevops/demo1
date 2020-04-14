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

      <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
      <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
      <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-multiselect/0.9.13/js/bootstrap-multiselect.min.js"></script>
      <script src="../../Main/sweetAlert/sweetalert.min.js"></script>

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
            height: 24px;
            padding: 6px 12px;
            font-size: 14px;
            line-height: 1.42857143;
            color: #555;
            background-color: #fff;
            background-image: none;
            border: 1px solid #aaa;
            border-radius: 4px;
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
            border-radius: 4px;
        }
        .middleCard{
            width: 20.7% !important;
            border: 1px solid;
            height: 146px;
            margin-left: 6px;
            border-radius: 4px;
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
            /*border: solid 1px rgba(0, 0, 0, .25);
            padding: 1%;
            box-shadow: 0 1px 1px rgba(0, 0, 0, .25);
            width: 100.1%;
            padding-left: 0px;
            margin-bottom:32px;*/
            border:0px;
            padding:0px;
            /*overflow-y: scroll;
            overflow-x: hidden;*/
margin-top:8px;
         }
         .col-sm-4,.col-sm-12 {padding:0px;}
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
            -webkit-border-radius: 6px;
            -moz-border-radius: 6px;
            border-radius: 6px;
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
            -webkit-border-radius: 6px;
            -moz-border-radius: 6px;
            border-radius: 6px;
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
                /*box-shadow: 0 1px 3px rgba(0,0,0,0.12), 0 1px 2px rgba(0,0,0,0.24);*/
                box-shadow:0 4px 10px 0 rgba(0,0,0,0.2),0 4px 20px 0 rgba(0,0,0,0.19);
                /*transition: all 0.3s cubic-bezier(.25,.8,.25,1);*/
                padding: 10px;
                margin:4px 8px 16px 0px;

                }
                .cardSmall {
                  box-shadow:0 4px 10px 0 rgba(0,0,0,0.2),0 4px 20px 0 rgba(0,0,0,0.19);
                  transition: all 0.3s cubic-bezier(.25,.8,.25,1);


               }

                 .caret {display: none;}

                 @media only screen and (min-width: 768px) {
                   .card {height:160px;}
                 }
                 .tabs-container{width:100%;margin:auto;}
                 .tab-content{width:98.5%;margin:auto;}
                 .row {margin-right:0px !important;margin:auto;width:100%;}
                 .col-md-4{padding:0px;}
                 .col-sm-2, .col-md-2, .col-md-1, .col-lg-2, .col-lg-1{padding: 0px;}

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
#viewBtn {height: 28px;
    padding-top: 3px;}
    .col-lg-12 {padding:0px;}
    .center-view{
      top:40%;
      left:50%;
      position:fixed;
      height:200px;
      width:200px;
   }
   .dataTables_filter {
     margin-top:-32px;
   }
    #columnContainer{
    	margin-top: 8px;
	}

      </style>

      <!-- content -->
      <div class="row" id="columnContainer">
        <div class="col-lg-2" id="leftColumn">
          <div class="row">
            <div class="col-lg-12 card">
               <div class="count outer-count" onclick="getCountsBasedOnStatus('enrouteId')">
                  <a href="#" >
                     <h3 id="enrouteId" style="font-weight: 600;color:#7f8fa4">0</h3>
                  </a>
                  <p>Enroute Placement</p>
               </div>
               <div class="row" style="border-top: 1px solid;">
                  <div class="col-lg-6 col-md-6 col-sm-12">
                     <div class="count outer-count padTop" onclick="getCountsBasedOnStatus('enrouteId-Ontime')">
                        <a href="#" >
                           <h3 id="enrouteId-Ontime" style="font-weight: 600;margin-top: -9px;color:#7f8fa4">0</h3>
                        </a>
                        <p>On-Time</p>
                     </div>
                  </div>
                  <div class="col-lg-6 col-md-6 col-sm-12">
                     <div class="count outer-count padTop" onclick="getCountsBasedOnStatus('enrouteId-delay')">
                        <a href="#" >
                           <h3 id="enrouteId-delay" style="font-weight: 600;margin-top: -9px;color:#7f8fa4">0</h3>
                        </a>
                        <p>Delayed</p>
                     </div>
                  </div>
               </div>
            </div>
          </div>
          <div class="row">
            <div class="col-lg-12 card">
               <div class="count main-count outer-count" onclick="getCountsBasedOnStatus('onTimeId')">
                  <a href="#" >
                     <h3 style="color: #67cc67 !important;font-weight: 600;margin-top: -19px;" id="onTimeId">0</h3>
                  </a>
                  <p style="font-weight: 300;">On Time</p>
               </div>
               <div class="row inner-row-card">
                  <div class="col-md-4">
                     <div class="count outer-count inner-row" style="border: 1px solid;" onclick="getCountsBasedOnStatus('onTimeId-stoppage')">
                        <a href="#" >
                           <h3 id="onTimeId-stoppage" style="color: #67cc67 !important;font-weight: 600;">0</h3>
                        </a>
                        <p class="inner-text">Unplanned Stoppage</p>
                     </div>
                  </div>
                  <div class="col-md-4">
                     <div class="count outer-count inner-row" style="border: 1px solid;" onclick="getCountsBasedOnStatus('onTimeId-hubhetention')">
                        <a href="#" >
                           <h3 id="onTimeId-hubhetention" style="color: #67cc67 !important;font-weight: 600;">0</h3>
                        </a>
                        <p class="inner-text">SmartHub Detention</p>
                     </div>
                  </div>
                  <div class="col-md-4">
                     <div class="count outer-count inner-row"  style="border: 1px solid;" onclick="getCountsBasedOnStatus('onTimeId-deviation')">
                        <a href="#" >
                           <h3 id="onTimeId-deviation" style="color: #67cc67 !important;font-weight: 600;">0</h3>
                        </a>
                        <p class="inner-text">Unplanned Deviation</p>
                     </div>
                  </div>
               </div>
            </div>
          </div>
          <div class="row">
            <div class="col-lg-12 card">
              <div class="count main-count outer-count" onclick="getCountsBasedOnStatus('delayedless1')">
                 <a href="#" >
                    <h3 style="color: orange !important; margin-top: -19px;" id="delayedless1">0</h3>
                 </a>
                 <p style="font-weight: 300;">Delayed < 1hour</p>
              </div>
              <div class="row inner-row-card">
                 <div class="col-md-4">
                    <div class="count outer-count inner-row" style="border: 1px solid;" onclick="getCountsBasedOnStatus('delayedless1-stoppage')">
                       <a href="#" >
                          <h3 id="delayedless1-stoppage" style="color: orange !important;font-weight: 600;">0</h3>
                       </a>
                       <p class="inner-text">Unplanned Stoppage</p>
                    </div>
                 </div>
                 <div class="col-md-4">
                    <div class="count outer-count inner-row" style="border: 1px solid;" onclick="getCountsBasedOnStatus('delayedless1-detention')">
                       <a href="#" >
                          <h3 id="delayedless1-detention" style="color: orange !important;font-weight: 600;">0</h3>
                       </a>
                       <p class="inner-text">SmartHub Detention</p>
                    </div>
                 </div>
                 <div class="col-md-4">
                    <div class="count outer-count inner-row" style="border: 1px solid;" onclick="getCountsBasedOnStatus('delayedless1-deviation')">
                       <a href="#" >
                          <h3 id="delayedless1-deviation" style="color: orange !important;font-weight: 600;">0</h3>
                       </a>
                       <p class="inner-text">Unplanned Deviation</p>
                    </div>
                 </div>
              </div>
           </div>
          </div>
        </div>
        <div class="col-lg-8" id="midColumn">
          <div class="row" id="tripWise" style="margin-bottom:8px;">
              <div class="col-sm-12">
              <label>Route Name:&nbsp;&nbsp;</label>
                <select class="form-control" id="route_names" >
                   <option value="ALL" selected="selected">ALL</option>
                </select>&nbsp;&nbsp;
                <label>Customer:&nbsp;&nbsp;</label>
                <select class="form-control" id="cust_names" >
                   <option value="ALL" selected="selected">ALL</option>
                </select>&nbsp;&nbsp;
                <button id="viewBtn" name="reset" type="button" class="btn btn-primary" onclick="ResetData()">Reset</button>


                     </div>
          </div>
          <div class="tabs-container">
                 <ul class="nav nav-tabs">
                    <li><a href="#mapViewId" data-toggle="tab" active style="font-size: 15px;font-weight: 600;height:32px;padding-top:4px;">Map View</a></li>
                    <li><a href="#listViewId" onclick="$('#tableDiv').css('visibility','hidden');loadTable(custId, routeId, tripStatus);" data-toggle="tab" style="font-size: 15px;font-weight: 600;height:32px;padding-top:4px;">List View</a></li>
                    <li class="dropdown">
                         <a class="dropdown-toggle" style="height:32px;padding-top:4px;" data-toggle="dropdown" href="#">Legend
                         <span class="caret"></span></a>
                            <ul class ="dropdown-menu" style="margin-top:4px;">
                                <li style="line-height: 48px;"><img src="/ApplicationImages/VehicleImages/ontime.svg"> On Time</li>
                                <li style="line-height: 48px;"><img src="/ApplicationImages/VehicleImages/enroute.svg"> EnRoute Placement</li>
                                <li style="line-height: 48px;"><img src="/ApplicationImages/VehicleImages/delayed1hr.svg"> Delayed < 1 hr </li>
                                <li style="line-height: 48px;"><img src="/ApplicationImages/VehicleImages/delayed1hr2.svg"> Delayed > 1 hr </li>
                                <li style="line-height: 48px;"><img src="/ApplicationImages/VehicleImages/EnroutePlacement.svg"> Loading Detention</li>
                                <li style="line-height: 48px;"><img src="/ApplicationImages/VehicleImages/detention.svg"> UnLoading Detention</li>
              <li style="line-height: 48px;"><img src="/ApplicationImages/VehicleImages/Pink.svg"> Delayed - Late Departure</li>
                            </ul>
                    </li>
                 </ul>
              </div>
              <div class="tab-content" id="tabs">
                 <div class="tab-pane" id="mapViewId">
                    <div class="col-md-12" style="margin-top: -3px;">
                       <div id="map" style="width: 102%;margin-top:5px;margin-left: -10px;position: relative;overflow: hidden;border: solid 1px rgba(0, 0, 0, .25);box-shadow: 0 1px 1px rgba(0, 0, 0, .25);"></div>
                    </div>
                 </div>
                 <div class="tab-pane" id="listViewId" style="padding-top:8px;" >
                 <i class="fas fa-info-circle"></i> Trip Information
                 <span id="disclimer" > (click on the below hyperlink  to view the trip details)</span>
                 <input type="button" id="legbtn" class="btn btn-primary" value="Leg Wise Export">
                   <div class="center-view" style="display:none;" id="loading-div">
                     <img src="../../Main/images/loading.gif" alt="">
                   </div>
                   <div class="toolbar"></div>
                   <div id="tableDiv">
                 <table id="tripSumaryTable"  class="table table-striped table-bordered" cellspacing="0">
                       <thead style="background:#337AB7;color:white;">
                          <tr>
                            <th>Sl No</th>
                            <th>Trip No</th>
                            <th>Trip ID</th>
                            <th>Route ID</th>
                            <th>Vehicle No</th>
                            <th>Vehicle Make</th>
                            <th>Trip LR No.</th>
                            <th>Customer Ref. ID</th>
                            <th>Customer Name</th>
                            <th>Driver Name</th>
                            <th>Driver Contact</th>
                            <th>Current Location</th>
                            <th>Origin</th>
                            <th>Destination</th>
                            <th>Trip Status</th>
                            <th>STP</th>
                            <th>ATP</th>
                            <th>STD</th>
                            <th>ATD</th>
                            <th>Nearest Hub</th>
                            <th nowrap>ETA to Next <br/>Hub</th>
                            <th nowrap>Distance to Next <br/> Hub (<%=unit%>)</th>
                            <th>Next Leg</th>
                            <th>Next Leg ETA</th>
                            <th>ETA</th>
                            <th>STA (WRT STD)</th>
                            <th>ATA</th>
                            <th nowrap>Total Delay <br/> (HH:mm)</th>
                            <th nowrap>Average Speed <br/>(<%=unit%>/h)</th>
                            <th nowrap>Total Stoppage <br/> (HH:mm)</th>
                            <th nowrap>Total Distance <br/> (<%=unit%>)</th>
                            <th nowrap>Placement Delay <br/>(HH:mm)</th>
                            <th nowrap>Customer Detention <br/>(HH:mm)</th>
                            <th nowrap>Loading Detention <br/> (HH:mm)</th>
                            <th nowrap>Unloading Detention <br/> (HH:mm)</th>
                            <th>Flag</th>
                            <th>Weather</th>
                            <th>End Date</th>
                            <th>routeId</th>
                            <th>Panic Alert</th>
                            <th>Door Alert</th>
                            <th nowrap>Non-Communicating <br/>Alert</th>
                            <th>Fuel Consumed(L)</th>
                            <th>Mileage (<%=unit%>/L)</th>
                            <th nowrap>OBD Mileage <br/> (<%=unit%>/L)</th>
                          </tr>
                       </thead>
                    </table>
</div>
                 </div>
              </div>

        </div>
        <div class="col-lg-2" id="rightColumn">

                                      <div class="row">
                                        <div class="col-lg-12 card">
                                           <div class="count main-count outer-count" onclick="getCountsBasedOnStatus('delayedgreater1')">
                                              <a href="#" >
                                                 <h3 style="color: #c30119 !important;font-weight: 600; margin-top: -19px;margin-top: -19px;" id="delayedgreater1">0</h3>
                                              </a>
                                              <p style="font-weight: 300;">Delayed > 1hour</p>
                                           </div>
                                           <div class="row inner-row-card">
                                              <div class="col-md-4">
                                                 <div class="count outer-count inner-row" style="border: 1px solid;" onclick="getCountsBasedOnStatus('delayedgreater1-stoppage')">
                                                    <a href="#" >
                                                       <h3 id="delayedgreater1-stoppage" style="color: #c30119 !important;font-weight: 600;">0</h3>
                                                    </a>
                                                    <p class="inner-text">Unplanned Stoppage</p>
                                                 </div>
                                              </div>
                                              <div class="col-md-4">
                                                 <div class="count outer-count inner-row" style="border: 1px solid;" onclick="getCountsBasedOnStatus('delayedgreater1-detention')">
                                                    <a href="#" >
                                                       <h3 id="delayedgreater1-detention" style="color: #c30119 !important;font-weight: 600;">0</h3>
                                                    </a>
                                                    <p class="inner-text">SmartHub Detention</p>
                                                 </div>
                                              </div>
                                              <div class="col-md-4">
                                                 <div class="count outer-count inner-row" style="border: 1px solid;" onclick="getCountsBasedOnStatus('delayedgreater1-deviation')">
                                                    <a href="#" >
                                                       <h3 id="delayedgreater1-deviation" style="color: #c30119 !important;font-weight: 600;">0</h3>
                                                    </a>
                                                    <p class="inner-text">Unplanned Deviation</p>
                                                 </div>
                                              </div>
                                           </div>
                                        </div>
                                      </div>
                                      <div class="row">
                                        <div class="col-lg-12 card">
                                          <div class="count outer-count" style="margin-top:-8px" onclick="getCountsBasedOnStatus('unloading-detention')">
                                             <a href="#" >
                                                <h3 class="highlight" id="unloading-detention" style="height:58px; color:#653f84;font-weight: 600;">0</h3>
                                             </a>
                                             <p style="margin-top: -40px;">Unloading Detention</p>
                                          </div>
                                           <div class="row inner-row-card">
                                              <div class="col-md-12" style="padding:0px;margin-top:-8px">
                                                <div class="count outer-count padTop" onclick="getCountsBasedOnStatus('loading-detention')">
                                                   <a href="#" >
                                                      <h3 class="highlight" id="loading-detention" style="color:#337ab7;font-weight: 600;margin-top: -9px;">0</h3>
                                                   </a>
                                                   <p style="margin-top: -8px;">Loading Detention</p>
                                                </div>
                                              </div>
                                           </div>
                                           <div class="row  inner-row-card">
                                             <div class="col-md-12" style="padding:4px 0px 0px 0px;">
                                              <div class="count outer-count" onclick="getCountsBasedOnStatus('delay-late-departure')">
                                                 <a href="#" >
                                                    <h3 class="highlight" id="delay-late-departure" style="color:#ed0bc7;font-weight: 600;margin-top: -10px;">0</h3>
                                                 </a>
                                                 <p style="margin-top: -8px;">Delayed -Late Departure</p>
                                              </div>
                                            </div>
                                           </div>
                                        </div>
                                      </div>
                                      <div class="row">
                                        <div class="col-lg-12 card">
                                          <div style="text-align:center; color:white;width:100%;background:#337AB7;">Alerts</div>
                                                 <div class="row">
                                                    <div class="col-md-4">
                                                       <div class="count outer-count" onclick="loadEvents('38','Door Alert')">
                                                          <a href="#" >
                                                             <h3 class="alert-count" id="doorAlertId">0/0</h3>
                                                          </a>
                                                          <p>Door</p>
                                                       </div>
                                                       <div class="row alert-row">
                                                          <div class="col-md-12">
                                                             <div class="count outer-count" onclick="loadEvents('999','Temperature Alert')">
                                                                <a href="#" >
                                                                   <h3 class="alert-count" id="tempAlertId">0/0</h3>
                                                                </a>
                                                                <p>Temp</p>
                                                             </div>
                                                          </div>
                                                       </div>
                                                    </div>
                                                    <div class="col-md-4">
                                                       <div class="count outer-count" onclick="loadEvents('3','Panic Alert')">
                                                          <a href="#" >
                                                             <h3 class="alert-count" id="panicAlertId">0/0</h3>
                                                          </a>
                                                          <p>Panic</p>
                                                       </div>
                                                       <div class="row alert-row">
                                                          <div class="col-md-12">
                                                             <div class="count outer-count" onclick="loadEvents('190','Reefer Off Alert')">
                                                                <a href="#" >
                                                                   <h3 class="alert-count" id="reeferOffAlertId">0/0</h3>
                                                                </a>
                                                                <p>ReeferOff</p>
                                                             </div>
                                                          </div>
                                                       </div>
                                                    </div>
                                                    <div class="col-md-4">
                                                       <div class="count outer-count" onclick="loadEvents('186','Humidity Alert')">
                                                          <a href="#" >
                                                             <h3 class="alert-count" id="humidityAlertId">0/0</h3>
                                                          </a>
                                                          <p>Humidity</p>
                                                       </div>
                                                       <div class="row alert-row">
                                                          <div class="col-md-12">
                                                             <div class="count outer-count" onclick="loadEvents('85','Non Communication Alert')">
                                                                <a href="#" >
                                                                   <h3 class="alert-count" id="nonReportingAlertId">0/0</h3>
                                                                </a>
                                                                <p>NotComm</p>
                                                             </div>
                                                          </div>
                                                       </div>
                                                    </div>
                                                 </div>
                                               </div>
                                      </div>
        </div>
      </div>




      <div  class="">
         <div id="add" class="modal-content modal fade" style="margin-top:1%">
            <div class="modal-header" >
               <div class="secondLine" style="display:flex; justify-content:space-between; align-items:baseline;">
                  <h4 id="tripEventsTitle" class="modal-title" style="text-align:left; margin-left:10px;">Panic Alert</h4>
               </div>
			   <div style="margin-left: 70%;">
                  <button type="button" class="close" style="align:right;" data-dismiss="modal">×</button>
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
      <script src='<%=GoogleApiKey%>&region=IN'></script>

<script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>

<script>

    var map;
    var mcOptions = {
        gridSize: 20,
        maxZoom: 50
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
    //var custName = "ALL";
    var custId = "ALL";
    var routeId = "ALL";
    var tripStatus = "";
    var flag = false;
	var x="";
	var buttonname="";
	var count=0;
    function ResetData(){
        //custName = "ALL";
        x = document.getElementById("groupName").name;
        buttonname=document.getElementById("viewBtn").name;
        custId = "ALL";
        routeId = "ALL";
        tripStatus = "";
        loadData(custId, routeId);
        loadMap(custId, routeId, tripStatus);
        loadTable(custId, routeId, tripStatus);
        getRouteNames(routeId);
        getCustNames(custId);
    }

    $( document ).ready(function() {

        $("#map").css("height", $("#rightColumn").height() - 88);


    });

    function activaTab(tab) {
        $('.nav-tabs a[href="#' + tab + '"]').tab('show');
    };
    activaTab('mapViewId');
    loadData(custId, routeId);

    function loadData(custId, routeId) {
        $.ajax({
            url: "<%=request.getContextPath()%>/tripDashBoardAction.do?param=getDashBoardCounts",
            data: {
                //custName: custName,
                custId: custId,
                routeId: routeId,
                custType: 'ALL',
                tripType: 'ALL'
            },
            "dataSrc": "vehicleCounts",
            success: function(result) {
                results = JSON.parse(result);

                $("#enrouteId").text(results["vehicleCounts"][0].enroutePlacement);
                $("#enrouteId-Ontime").text(results["vehicleCounts"][0].enrouteOntime);
                $("#enrouteId-delay").text(results["vehicleCounts"][0].enrouteDelay);
                $("#onTimeId").text(results["vehicleCounts"][0].ontimeCount);
                $("#delayedless1").text(results["vehicleCounts"][0].delayLess);
                $("#delayedgreater1").text(results["vehicleCounts"][0].delayGreater);

                $("#unloading-detention").text(results["vehicleCounts"][0].unloadingDetention);
                $("#loading-detention").text(results["vehicleCounts"][0].loadingDetention);
                $("#delay-late-departure").text(results["vehicleCounts"][0].delayLateDeparture);

                $("#delayedless1-stoppage").text(results["vehicleCounts"][0].stoppageDelayLess);
                $("#delayedless1-detention").text(results["vehicleCounts"][0].detentionDelayLess);
                $("#delayedless1-deviation").text(results["vehicleCounts"][0].deviationDelayless);
                $("#delayedgreater1-stoppage").text(results["vehicleCounts"][0].stoppagedelayGreater);
                $("#delayedgreater1-deviation").text(results["vehicleCounts"][0].deviationDelayGreater);
                $("#delayedgreater1-detention").text(results["vehicleCounts"][0].detentionDelayedGreater);

                $("#onTimeId-stoppage").text(results["vehicleCounts"][0].ontimeStoopage);
                $("#onTimeId-hubhetention").text(results["vehicleCounts"][0].ontimeDetention);
                $("#onTimeId-deviation").text(results["vehicleCounts"][0].ontimeDeviation);

            }
        });

        $.ajax({
            url: "<%=request.getContextPath()%>/tripDashBoardAction.do?param=getAlertCounts",
            data: {
                //custName: custName,
                custId: custId,
                routeId: routeId,
                custType: 'ALL',
                tripType: 'ALL'
            },
            "dataSrc": "alertCounts",
            success: function(result) {
                results = JSON.parse(result);
                $("#doorAlertId").text(results["alertCounts"][0].doorCount);
                $("#panicAlertId").text(results["alertCounts"][0].panicCount);
                $("#nonReportingAlertId").text(results["alertCounts"][0].nonReportingCount);
                $("#tempAlertId").text(results["alertCounts"][0].tempCount);
                $("#humidityAlertId").text(results["alertCounts"][0].humidityCount);
                $("#reeferOffAlertId").text(results["alertCounts"][0].reeferCount);


            }
        });
    }
    // ************* Map Details
    function initialize() {
        var mapOptions = {
            zoom: 3.8,
            center: new google.maps.LatLng(<%=latitudeLongitude%>), //23.524681, 77.810561),,
            mapTypeId: google.maps.MapTypeId.ROADMAP,
            mapTypeControl: false,
            gestureHandling: 'greedy'
        };
        map = new google.maps.Map(document.getElementById('map'), mapOptions);
        var trafficLayer = new google.maps.TrafficLayer();
        trafficLayer.setMap(map);
    }
    initialize();
    var markerCluster;
    function loadMap(custId, routeId, tripStatus) {
        $.ajax({
            url: '<%=request.getContextPath()%>/tripDashBoardAction.do?param=getVehiclesForMap',
            data: {
                //custName: custName,
                custId: custId,
                routeId: routeId,
                status: tripStatus,
                custType: 'ALL',
                tripType: 'ALL'
            },
            "dataSrc": "MapViewVehicles",
            success: function(result) {
                var bounds = new google.maps.LatLngBounds();

                results = JSON.parse(result);
                var count = 0;
                markerClusterArray.length=0;
                if (markerCluster) {
                    markerCluster.clearMarkers();
                }
                for (var i = 0; i < results["MapViewVehicles"].length; i++) {
                    if (!results["MapViewVehicles"][i].lat == 0 && !results["MapViewVehicles"][i].lon == 0) {
                        count++;
                        plotSingleVehicle(results["MapViewVehicles"][i].vehicleNo, results["MapViewVehicles"][i].lat, results["MapViewVehicles"][i].lon,
                            results["MapViewVehicles"][i].location, results["MapViewVehicles"][i].gmt,
                            results["MapViewVehicles"][i].tripStatus, results["MapViewVehicles"][i].custName, results["MapViewVehicles"][i].shipmentId,
                            results["MapViewVehicles"][i].delay, results["MapViewVehicles"][i].weather, results["MapViewVehicles"][i].driverName,
                            results["MapViewVehicles"][i].etaDest, results["MapViewVehicles"][i].etaNextPt, results["MapViewVehicles"][i].routeIdHidden,
                            results["MapViewVehicles"][i].ATD, results["MapViewVehicles"][i].status, results["MapViewVehicles"][i].tripId,
                            results["MapViewVehicles"][i].endDateHidden,results["MapViewVehicles"][i].STD,results["MapViewVehicles"][i].T1,
                            results["MapViewVehicles"][i].T2,results["MapViewVehicles"][i].T3,results["MapViewVehicles"][i].productLine,results["MapViewVehicles"][i].Humidity,results["MapViewVehicles"][i].tripNo,
                            results["MapViewVehicles"][i].routeName,results["MapViewVehicles"][i].currentStoppageTime,results["MapViewVehicles"][i].currentIdlingTime,
                            results["MapViewVehicles"][i].speed,results["MapViewVehicles"][i].LRNO);
                        var mylatLong = new google.maps.LatLng(results["MapViewVehicles"][i].lat, results["MapViewVehicles"][i].lon);
                    }
                }
                markerCluster = new MarkerClusterer(map, markerClusterArray, mcOptions);
            }
        });
    }
    loadMap(custId, routeId, tripStatus);

    function plotSingleVehicle(vehicleNo, latitude, longtitude, location, gmt, tripStatus, custName, shipmentId, delay, weather,
     driverName, etaDest, etaNextPt,routeId,ATD,status,tripId,endDate,startDate,T1,T2,T3,productLine,Humidity,tripNo,routeName,currentStoppageTime,currentIdlingTime,speed,LRNO) {
        var tempContent='';
        var humidityContent='';
        var Humidity;
        if(productLine != 'Chiller' && productLine != 'Freezer' && productLine != 'TCL')
 //       if(productLine != 'TCL' )
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
            url: imageurl, // This marker is 20 pixels wide by 32 pixels tall.
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
        var content = '<div id="myInfoDiv" seamless="seamless" scrolling="no" style="overflow:hidden; width:100%; height: 100%; float: left; color: #000; background:#ffffff; line-height:100%; font-size:11px; font-family: sans-serif;">' +
            '<table>' +
            '<tr><td><b>Vehicle No:</b></td><td>' + vehicleNo + '</td></tr>' +
            '<tr><td><b>Trip No:</b></td><td>' + tripNo + '</td></tr>' +
            '<tr><td><b>LR No:</b></td><td>' + LRNO + '</td></tr>' +
            '<tr><td><b>Route Name:</b></td><td>' + routeName + '</td></tr>' +
            '<tr><td><b>Location:</b></td><td>' + location + '</td></tr>' +
            '<tr><td><b>Last Comm:</b></td><td>' + gmt + '</td></tr>' +
            '<tr><td><b>Customer :</b></td><td>' + custName + '</td></tr>' +
            '<tr><td><b>Delay:</b></td><td>' + delay + '</td></tr>' +
            '<tr><td><b>weather:</b></td><td>' + weather + '</td></tr>' +
            '<tr><td><b>Driver Name:</b></td><td>' + driverName + '</td></tr>' +
            '<tr><td><b>ETA to Next Hub:</b></td><td>' + etaNextPt + '</td></tr>' +
            '<tr><td><b>ETA to Destination:</b></td><td>' + etaDest + '</td></tr>' +
            '<tr><td><b>LatLong:</b></td><td>' + coordinate + '</td></tr>' +
            '<tr><td><b>Current Stoppage Time(HH.mm) :</b></td><td>' + currentStoppageTime + '</td></tr>' +
            '<tr><td><b>Current Idling Time(HH.mm):</b></td><td>' + currentIdlingTime + '</td></tr>' +
            '<tr><td><b>Speed(km/h):</b></td><td>' + speed + '</td></tr>' +
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

        var parameterStr="tripNo=" + tripId + "&vehicleNo=" + vehicleNo + "&startDate=" + startDate + "&endDate=" + endDate + "&pageId=3&status=" + status + "&actual=" + ATD + "&routeId=" + routeId;

        google.maps.event.addListener(marker, 'dblclick', (function(marker, parameterStr) {
            return function() {
                window.open("<%=request.getContextPath()%>/Jsps/GeneralVertical/TripAndAlertDetails.jsp?"+parameterStr, '_blank');
            };
        })(marker, parameterStr));

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
        //custName = $('#cust_names option:selected').val();
        custId = $('#cust_names option:selected').val();
        loadTable(custId, routeId, tripStatus);
    });
    var table;


    function loadTable(custId, routeId, tripStatus) {
        groupId = $('#groupName option:selected').attr('id');
        grouplabel = $('#groupName option:selected').attr('value');
        if(typeof groupId ==='undefined'){
            groupId=0;
            grouplabel="On Trip";
        }
        if(buttonname=='reset'){
        groupId=0;
        grouplabel="On Trip";
        buttonname="";
        }
        $('#tableDiv').css('visibility','hidden');
        $('#loading-div').show();
        if ($.fn.DataTable.isDataTable("#tripSumaryTable")) {
          $('#tripSumaryTable').DataTable().clear().destroy();
        }
        $.ajax({
             type: "POST",
             url: '<%=request.getContextPath()%>/tripDashBoardAction.do?param=getTripSummaryDetailsDHL',
             "data": {
                 groupId: groupId,
                 unit: '<%=unit%>',
                 custId: custId,
                 routeId: routeId,
                 status: tripStatus,
				 custType: 'ALL',
				 tripType: 'ALL' 
             },
             success: function(result) {
             //alert(result);
               console.log("Result JSON", result);
              if(result == undefined || result == null)
              {
              result = {"tripSummaryDetails":""};
              }
              result = JSON.parse(result).tripSummaryDetails;              
              let rows = [];
              if(result !=''){
              	$.each(result, function(i, item) {              
                  let row = {
                    "0":item.slNo,
                    "1":item.tripNo,
                    "2":item.ShipmentId,
                    "3":item.routeName,
                    "4":item.vehicleNo,
                    "5":item.make,
                    "6":item.lrNo,
                    "7":item.custRefId,
                    "8":item.customerName,
                    "9":item.driverName,
                    "10":item.driverContact,
                    "11":item.Location,
                    "12":item.origin,
                    "13":item.Destination,
                    "14":item.status,
                    "15":item.STP,
                    "16":item.ATP,
                    "17":item.STD,
                    "18":item.ATD,
                    "19":item.nearestHub,
                    "20":item.ETHA,
                    "21":item.distanceToNextHub,
                    "22":item.nextLeg,
                    "23":item.nextLegETA,
                    "24":item.ETA,
                    "25":item["STA (WRT STD)"],
                    "26":item.ATA,
                    "27":item.delay,
                    "28":item.avgSpeed,
                    "29":item.stoppageTime,
                    "30":item.totalDist,
                    "31":item.placementDelay,
                    "32":item.customerDetentionTime,
                    "33":item.loadingDetentionTime,
                    "34":item.unloadingDetentionTime,
                    "35":item.flag,
                    "36":item.weather,
                    "37":item.endDateHidden,
                    "38":item.routeIdHidden,
                    "39":item.panicAlert,
                    "40":item.doorAlert,
                    "41":item.nonReporting,
                    "42":item.fuelConsumed,
                    "43":item.mileage,
                    "44":item.mileageOBD,
                    "legdetails":item.legdetails
                  }
                  rows.push(row);
                });
              }
              

                table = $('#tripSumaryTable').DataTable({
                  "scrollY": "272px",
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
                $('#tripSumaryTable td:first-child').addClass('details-control');
                if(x=='size')
                {
                $('#groupName').hide();
                }
                $("div.dataTables_filter").prepend('<select name="size" id="groupName" onchange="loadAjax();" style="height:35px;width:150px;border-radius: 4px;margin-right:24px;">'+
                                  ' <option value="On Trip" id="0">On Trip</option>'+
                                  ' <option value="Last 2 day" id="1">Last 2 days</option>'+
                                  ' <option value="Last 1 week" id="2">Last 1 week</option>'+
                                  ' <option value="Last 15 days" id="3">Last 15 days</option>'+
                                  ' <option value="Last 1 month" id="4">Last 1 month</option>'+
                                  ' </select>');
                $('#groupName').val(grouplabel).attr("selected", "selected");
                $('#loading-div').hide();
                $('#tableDiv').css('visibility','');

         }
         });

        /*table = $('#tripSumaryTable').DataTable({
            "ajax": {
                "url": "<%=request.getContextPath()%>/tripDashBoardAction.do?param=getTripSummaryDetailsDHL",
                "dataSrc": "tripSummaryDetails",
                "data": {
                    groupId: groupId,
                    unit: '<%=unit%>',
                    custId: custId+' , ',
                    routeId: routeId+' , ',
                    status: tripStatus,
					custType: 'ALL',
					tripType: 'ALL' 
                }
            },
            "scrollY":"350px",
            "scrollX": true,
            "bDestroy": true,
            "oLanguage": {
                "sEmptyTable": "No data available"
            },
            buttons: [ 'excel', 'pdf'],
            "buttons": [{extend:'pageLength'},
	      	 			{extend:'excel',
	      	 				text: 'Export to Excel',
	      	 				className: 'btn btn-primary',
	      	 				title: 'SLA dashboard Trip Details',
	      	 				exportOptions: {
			                 columns: ':visible'
			            }
			        }
	      	 ],
           "columns": [{
                "data": "slNo",//0
                "orderable": true,
                "defaultContent": '',
                "className": 'details-control'
            }, {
                "data": "tripNo",//1
                "visible" : false
            }, {
                "data": "ShipmentId"//2
            }, {
                "data": "routeName"//3
            }, {
                "data": "vehicleNo"//4
            }, {
                "data": "make"//5
            }, {
                "data": "lrNo"//6
            }, {
                "data": "custRefId"//7
            }, {
                "data": "customerName"//8
            }, {
                "data": "driverName"//9,
            }, {
                "data": "driverContact"//10
            }, {
                "data": "Location"//11
            }, {
                "data": "origin"//12
            }, {
                "data": "Destination"//13
            }, {
                "data": "status"//14
            }, {
                "data": "STP"//15
            }, {
                "data": "ATP"//16
            }, {
                "data": "STD"//17
            }, {
                "data": "ATD"//18
            }, {
                "data": "nearestHub"//19
            }, {
                "data": "ETHA"//20
            }, {
                "data": "distanceToNextHub"//21
            }, {
                "data": "nextLeg",//22
                "visible" : false
            },{
                "data": "nextLegETA",//23
                "visible" : false
            }, {
                "data": "ETA"//24
            }, {
                "data": "STA (WRT STD)"//25
            }, {
                "data": "ATA"//26
            }, {
                "data": "delay"//27
            }, {
                "data": "avgSpeed"//28
            }, {
                "data": "stoppageTime"//29
            }, {
                "data": "totalDist"//30
            }, {
                "data": "placementDelay"//31
            }, {
                "data": "customerDetentionTime"//32
            }, {
                "data": "loadingDetentionTime"//33
            }, {
                "data": "unloadingDetentionTime"//34
            }, {
                "data": "flag"//35
            }, {
                "data": "weather"//36
            }, {
                "data": "endDateHidden",//37
                "visible" : false
            }, {
                "data": "routeIdHidden",//38
                "visible" : false
            }, {
                "data": "panicAlert"//39
            }, {
                "data": "doorAlert"//40
            }, {
                "data": "nonReporting"//41
            }, {
                "data": "fuelConsumed"//42
            }, {
                "data": "mileage"//43
            },{
                "data": "mileageOBD"//44
            }],
            "order": [[0, 'asc']]

        });*/
<!--        table.column(1).visible(false);  -->
<!--        table.column(37).visible(false);  // endDateHidden-->
<!--        table.column(38).visible(false);  // routeIdHidden-->
<!--        table.column(22).visible(false);  // next leg-->
<!--        table.column(23).visible(false);  // next leg ETA-->

        jQuery('.dataTable').wrap('<div class="dataTables_scroll" />');
    }
    setInterval(function() {
        loadMap(custId, routeId, tripStatus);
        loadData(custId, routeId);
        loadTable(custId, routeId, tripStatus);
        //table.ajax.reload();
    }, 60000);

     $('#tripSumaryTable').on('click', 'td.details-control', function () {
	       var tr = $(this).closest('tr');
	       var row = table.row( tr );
         console.log("Row Data",row.data());

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

    function loadEvents(alertId, alertName, tripId) {
        $(".modal-header #tripEventsTitle").text(alertName);
        $('#add').modal('show');
        tableNew = $('#alertEventsTable').DataTable({
            "ajax": {
                "url": "<%=request.getContextPath()%>/tripDashBoardAction.do?param=getAlertDetails",
                "dataSrc": "alertDetails",
                "data": {
                    alertId: alertId,
                    tripId: tripId,
                    //custName: custName,
                    custId: custId,
                    routeId: routeId,
                    custType: 'ALL',
					tripType: 'ALL' 
                }
            },
            "bDestroy": true,
            "processing": true,
            //"scrollY": '50vh',
            dom: 'Bfrtip',
           "buttons": [{
                    extend: 'pageLength'
                }, {
                    extend: 'excel',
                    text: 'Export to Excel',
                    className: 'btn btn-primary'
                }, {
                    extend: 'pdf',
                    text: 'Export to PDF',
                    className: 'btn btn-primary'
                } ],
            "oLanguage": {
                "sEmptyTable": "No data available"
            },
            "columns": [{
                "data": "slNoIndex"
            }, {
                "data": "vehicleNoIndex"
            }, {
                "data": "locationIndex"
            }, {
                "data": "dateTimeIndex"
            }, {
                "data": "remarksIndex"
            }, {
                "data": "button"
            }]
        });
        $('#alertEventsTable').closest('.dataTables_scrollBody').css('max-height', '400px');
    }
    var routeId;
    getRouteNames();

    function getRouteNames(route) {
    	for (var i = document.getElementById("route_names").length - 1; i >= 1; i--) {
            document.getElementById("route_names").remove(i);
        }
        $.ajax({
            url: '<%=request.getContextPath()%>/tripDashBoardAction.do?param=getRouteNames',
            success: function(response) {
                routeList = JSON.parse(response);
                var $routeName = $('#route_names');
                var output = '';
                $.each(routeList, function() {
                    $('<option value=' + this.routeId + '>' + this.routeName + '</option>').appendTo($routeName);
                });
                $('#route_names').select2();
                if(route=='ALL'){
                    $("#route_names").val('ALL').trigger('change');
                }
            }
        });
    }
    $('#route_names').change(function() {
        routeId = $('#route_names option:selected').val();
        //custName = $('#cust_names option:selected').val();
        custId = $('#cust_names option:selected').val();
        loadData(custId, routeId);
        loadMap(custId, routeId, tripStatus);
        loadTable(custId, routeId, tripStatus);
    });
    var custName;
    getCustNames();

    function getCustNames(cust) {
    //alert("custId inside fun : " + custId);
    	for (var i = document.getElementById("cust_names").length - 1; i >= 1; i--) {
            document.getElementById("cust_names").remove(i);
        }
        $.ajax({

            url: '<%=request.getContextPath()%>/tripDashBoardAction.do?param=getCustNamesForSLA',
            success: function(response) {
                custList = JSON.parse(response);
                var $custName = $('#cust_names');
                var output = '';
                //$.each(custList, function() {
                  //  $('<option value=' + this.custName + '>' + this.custName + '</option>').appendTo($custName);
                //});
                 for (var i = 0; i < custList["customerRoot"].length; i++) {
                    $('#cust_names').append($("<option></option>").attr("value", custList["customerRoot"][i].CustId).text(custList["customerRoot"][i].CustName));
                }
                $('#cust_names').select2();
                if(cust=='ALL'){
                    $("#cust_names").val('ALL').trigger('change');
                }
            }
        });
    }
    $('#cust_names').change(function() {
        //custName = $('#cust_names option:selected').val();
        custId = $('#cust_names option:selected').val();
        //alert("custId inside onchange : " + custId);
        routeId = $('#route_names option:selected').val();
        loadData(custId, routeId);
        loadMap(custId, routeId, tripStatus);
        loadTable(custId, routeId, tripStatus);
    });

    function getCountsBasedOnStatus(tripStatus1) {
        flag = true;
        tripStatus=tripStatus1;
        loadMap(custId, routeId, tripStatus);
        loadTable(custId, routeId, tripStatus);
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
                        }
                    })
                }
            },
            function() {
            })
    }
    function loadAjax(){
        loadTable(custId, routeId, tripStatus);
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

function showTripAndAlertDetails() {
count++;
 $('#tripSumaryTable tbody').on('click', 'td', function() {
     var data = table.row(this).data();
     var columnIndex = table.cell(this).index().column;
     tripNo = (data[1]);
     vehicleNo = (data[4]);
     startDate = (data[17]);
     endDate = (data[37]);
     actualDate = (data[18]);
     status = (data[14]);
     var routeId1 = (data[38]);
   if (columnIndex == 2 && count==1) {
   count=0;
   window.open("<%=request.getContextPath()%>/Jsps/GeneralVertical/TripAndAlertDetails.jsp?tripNo=" + tripNo + "&vehicleNo=" + vehicleNo + "&startDate=" + startDate + "&endDate=" + endDate + "&pageId=3&status=" + status + "&actual=" + actualDate + "&routeId1=" + routeId, '_blank');
   }
                            });
                            }

  $('#legbtn').click(function() {
		$.ajax({
			url : '<%=request.getContextPath()%>/LegDetailsExportAction.do?param=createLegExcel',
			//type:"POST",
			data : {
					groupId: groupId,
                    unit: '<%=unit%>',
                    //custName: custName,
                    custId: custId,
                    routeId: routeId,
                    status: tripStatus
			},
			success : function(responseText) {
				//$('#ajaxGetUserServletResponse').text(responseText);
				//alert(responseText);
				//window.location="<%=request.getContextPath()%>/LegDetailsExport?relativePath="+responseText;
				window.open("<%=request.getContextPath()%>/LegDetailsExport?relativePath="+responseText);
			}
		});
	});

// }
  
</script>

  <jsp:include page="../Common/footer.jsp" />
