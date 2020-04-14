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
	String ipAddress = properties.getProperty("semiAutoTripURL");
    String serviceUserName = properties.getProperty("semiAutoTripUserName");
    String servicePassword = properties.getProperty("semiAutoTripPassword");
	
	String roleModuleAPIurl = "";
	try{
		//roleModuleAPIurl = "https://telematics4u.in/t4uspringapp/";//properties.getProperty("roleModuleAPIAddress").trim();
		roleModuleAPIurl = properties.getProperty("roleModuleAPIAddress").trim();
	}catch(Exception e){
		e.printStackTrace();
	}
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
<script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-multiselect/0.9.15/js/bootstrap-multiselect.js"></script>
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
	   <link rel="stylesheet" href="https://www.jqwidgets.com/public/jqwidgets/styles/jqx.base.css">
       <link rel="stylesheet" href="https://www.jqwidgets.com/public/jqwidgets/styles/jqx.energyblue.css">
		<link rel="stylesheet" href="https://www.jqwidgets.com/public/jqwidgets/styles/jqx.arctic.css">

    <script src="https://www.jqwidgets.com/public/jqwidgets/jqx-all.js"></script>
    <script src="https://www.jqwidgets.com/public/jqwidgets/globalization/globalize.js"></script>	
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
  display:none !important;
}

.red {
  color:red;
  background:white;
}

.highlight{
  color:white !important;
  background: #00A0D6 !important;
}

#driverList .col-lg-6{padding:0px;font-size:14px;}

#driverDetention {font-size:14px;}

.jqx-widget-content {
            z-index: 1000000 !important;
        }
		
.jqx-icon-time {
            z-index: 10000000 !important;
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
<!--      <div class="row" style="margin-bottom:8px;margin-left:0px; display: block; height: 25px; text-align:center; line-height:25px; font-weight: bolder;">-->
<!--      	<span>Jotun Smart Delivery System (JSDS)</span>-->
<!--      </div>-->
      <div class="row" style="margin-bottom:5px;margin-left:8px;margin-top: 15px;">
        <div class="col-md-2" style="padding:0px;">
          <select id="statusDropDownId" name="selectStatus">
            <option value = "0">Select Status</option>
            <option value="AVAILABLE">Available</option>
            <option value="ON_TRIP">On Trip</option>
            <option value="TRIP_ASSIGNED">Trip Assigned</option>
          </select>
        </div>
        <div class="col-md-2" >

              <select id="driverDropDownId" name="selectStatus">
                <option>Driver Name</option>
              </select>
              <div id="driverDropDownIdDiv" class="dispNone"><span class="red">* Required</span>
              </div>

        </div>
        <div class="col-md-8" style="justify-content:space-between;">
 		<button id="btnCustomerColl" class="btn btn-generate btn-md  btn-primary btnScreen dispNone" enabled onClick="btnCustomerColl()">Collections</button>
          <button id="btnCreateTrip" class="btn btn-generate btn-md  btn-basic btnScreen dispNone" disabled onClick="btnCreateTrip()">Create Trip</button>
          <button id="btnModifyTrip" class="btn btn-generate btn-md btn-basic btnScreen dispNone" disabled onClick="btnModifyTrip()">Modify Trip</button>
          <button id="btnCloseTrip" class="btn btn-generate btn-md btn-basic btnScreen dispNone" disabled onClick="btnCloseTrip()">Close Trip</button>
          <button id="btnAcknowledgeTrip" class="btn btn-generate btn-md btn-primary btnScreen dispNone" enabled onClick="acknowledgeTrip()">Acknowledge</button>
		  <button id="mtm" class="btn btn-generate btn-md btn-primary btnScreen dispNone" enabled onClick="btnMissedTripManagent()">MTM</button>
        </div>
      </div>
      <div class="row" id="columnContainer">
        <div class="col-lg-3" id="leftColumn">
          <div class="row" style="width:100%;" id="box1">
                        <div class="col-lg-12 card">
                          <div class="row" style="height:100%;">
                             <div class="col-lg-12">
<!--                                 <div class="headerText blueGrey"><img src="/ApplicationImages/VehicleImages/delivery-van.png" style="width:30px;margin-left:16px;"/><span style="margin-left:12px;">Available Vehicles</span></div>-->
									<div class="headerText blueGrey"><img src="/ApplicationImages/VehicleImages/delivery-van.png" style="width:30px;margin-left:16px;"/><span style="margin-left:12px;">Available Vehicles</span><span class="pointer" id="totalAvailable" style="float: right;margin-right: 16%;"></span></div>

                                 <ul class="list-group" style="border-bottom:0px !important;margin-bottom:0px;font-size:14px;">
                                   <li class="list-group-item">
                                     <div class="col-lg-10" style="padding:2px;"><img src="/ApplicationImages/VehicleImages/delivery-van-black.png" style="width:30px;margin-right:16px;"/>Available (< 30 min)</div>
                                     <div class="col-lg-2" id="availableLessThan30Min"></div>
                                   </li>
                                   <li class="list-group-item">
                                     <div class="col-lg-10" style="padding:2px;"><img src="/ApplicationImages/VehicleImages/delivery-van-grey.png" style="width:30px;margin-right:16px;"/>Available (> 30 min)</div>
                                     <div class="col-lg-2" id="availableGreaterThan30Min"></div>
                                   </li>
                                 </ul>
                             </div>
                           </div>
                        </div>
            </div>

            <div class="row" style="width:100%;" id="box1">
                          <div class="col-lg-12 card">
                            <div class="row" style="height:100%;">
                               <div class="col-lg-12">
                                   <div class="headerText blueGrey"><img src="/ApplicationImages/VehicleImages/delivery-van.png" style="width:30px;margin-left:16px;"/><span style="margin-left:12px;">Vehicle Status</span></div>
                                   <ul class="list-group" style="border-bottom:0px !important;margin-bottom:0px;font-size:14px;">
                                     <li class="list-group-item">
                                       <div class="col-lg-10"  style="padding:2px;">On-Trip</div>
                                       <div class="col-lg-2 pointer" id="onTrip"></div>
                                     </li>
                                     <li class="list-group-item" style="background:#ECEFF1;">
                                       <div class="col-lg-10"  style="padding:2px;">Trip Assigned</div>
                                       <div class="col-lg-2 pointer" id="tripAssigned">0</div>
                                     </li>
                                     <li class="list-group-item">
                                       <div class="col-lg-10"  style="padding:2px;">Inside HQ</div>
                                       <div class="col-lg-2" id="insideHQ">0</div>
                                     </li>
                                   </ul>
                               </div>
                             </div>
                          </div>
              </div>
			  
			<div class="row" style="width:100%;" id="box1">
                          <div class="col-lg-12 card  dispNone" id="atBorderPanel">
                            <div class="row" style="height:100%;">
                               <div class="col-lg-12">
                                   <div class="headerText blueGrey"><img src="/ApplicationImages/AlertIcons/Distress2.png" style="width:30px;margin-left:16px;"/><span style="margin-left:12px;">Alerts</span></div>
                                   <ul class="list-group" style="border-bottom:0px !important;margin-bottom:0px;font-size:14px;">
                                     <li class="list-group-item">
                                       <div class="col-lg-10"  style="padding:2px;">At Border</div>
                                       <div class="col-lg-2 pointer" id="atBorder">0</div>
                                     </li>
                                     <li class="list-group-item" style="background:#ECEFF1;">
                                       <div class="col-lg-10"  style="padding:2px;">Stopped</div>
                                       <div class="col-lg-2 pointer" id="stopped">0</div>
                                     </li>
                                   </ul>
                               </div>
                             </div>
                          </div>
            </div>	  
        </div>

       <div class="col-lg-5" id="midColumn">
          <div class="row" style="width:100%;" id="box1">
                        <div class="col-lg-12 card">
                          <div class="row" style="height:80vh;">
                             <div class="col-lg-12">
                                 <div class="headerText blueGrey"><img src="/ApplicationImages/VehicleImages/delivery-van.png" style="width:30px;margin-left:16px;"/><span id = "driverListHeader" style="margin-left:12px;">Available</span></div>
                                 <ul id="driverList" class="list-group" style="overflow-y:auto;height:70vh;border-bottom:0px !important;margin-bottom:0px;">
                                 </ul>
                             </div>
                           </div>
                        </div>
            </div>
        </div>

<!--        <div class="col-lg-4" id="midColumn">-->
<!--           <div class="tabs-container blueGrey" style="color:white;">-->
<!--                  <ul class="nav nav-tabs">-->
<!--                     <li><a href="#mapViewId" data-toggle="tab" active style="margin:0px;border-radius: 0px;font-size: 15px;font-weight: 600;height:32px;padding-top:4px;"><i class="fas fa-globe"></i></a></li>-->
<!--                     <%-- <li><a href="#listViewId" onclick="$('#tableDiv').css('visibility','hidden');loadTable(custName, routeId, tripStatus);" data-toggle="tab" style="border-radius: 0px;font-size: 15px;font-weight: 600;height:32px;padding-top:4px;margin:0px"><i class="far fa-list-alt"></i></a></li> --%>-->
<!--                  </ul>-->
<!--            </div>-->
<!--               <div class="tab-content" id="tabs">-->
<!--                  <div class="tab-pane" id="mapViewId">-->
<!--                     <div class="col-md-12" style="margin-bottom:32px;">-->
<!--                        <div id="map" style="width: 100%;position: relative;overflow: hidden;border: solid 1px rgba(0, 0, 0, .25);box-shadow: 0 1px 1px rgba(0, 0, 0, .25);"></div>-->
<!---->
<!--                     </div>-->
<!--                  </div>-->
<!--                  <div class="tab-pane" style="border:none;" id="listViewId" >-->
<!---->
<!--                    <div id="tableDiv">-->
<!--                  <table id="tripSumaryTable"  class="table table-striped table-bordered" cellspacing="0">-->
<!--                        <thead style="background:#37474F;color:white;">-->
<!--                           <tr>-->
<!--                             <th>Serial Number</th>-->
<!--                             <th>Comm Status</th>-->
<!--                             <th>Distance</th>-->
<!--                             <th>Driver Name</th>-->
<!--                             <th>Driver Number</th>-->
<!--                             <th>LR No.</th>-->
<!--                             <th>Reg. No.</th>-->
<!--                             <th>Shipment</th>-->
<!--                             <th>Tamper Count</th>-->
<!--                             <th>Location Name</th>-->
<!--                             </tr>-->
<!--                        </thead>-->
<!--                     </table>-->
<!--                   </div>-->
<!--                  </div>-->
<!--                  <div class="tab-pane" id="settingsViewId">-->
<!--                     <div class="col-lg-12" style="margin-bottom:32px;">-->
<!--                       <input type="checkbox" id="box1check" onChange="checkBox('box1')" name="box1check" value="box1check" checked> Box 1<br>-->
<!--                       <input type="checkbox" id="box2check" onChange="checkBox('box2')" name="box2check" value="box2check" checked> Box 2<br>-->
<!--                       <input type="checkbox" id="box3check" onChange="checkBox('box3')" name="box3check" value="box3check" checked> Box 3<br>-->
<!--                       <input type="checkbox" id="box4check" onChange="checkBox('box4')" name="box4check" value="box4check" checked> Box 4<br>-->
<!--                       <input type="checkbox" id="box5check" onChange="checkBox('box5')" name="box5check" value="box5check" checked> Box 5<br>-->
<!--                       <input type="checkbox" id="box6check" onChange="checkBox('box6')" name="box6check" value="box6check" checked> Box 6<br>-->
<!--                     </div>-->
<!--                  </div>-->
<!--               </div>-->
<!--        </div>-->
        <div class="col-lg-4" id="rightColumn">
          <div class="row" style="width:100%;" id="box2">
                        <div class="col-lg-12 card">
                          <div class="row" style="height:80vh;">
                             <div class="col-lg-12">
                                 <div class="headerText blueGrey"><i class="fas fa-truck-loading" style="margin-left:24px;"></i><span style="margin-left:12px;">Detention</span></div>
                                 <ul id="driverDetention" class="list-group" style="overflow-y:auto;height:70vh;border-bottom:0px !important;margin-bottom:0px;">

                                 </ul>
                             </div>
                           </div>
                        </div>
            </div>
        </div>


      </div>
</div>




      <div id="createTripModal" class="modal fade createTrip">
             <div class="row blueGreyDark" style="border-radius: 4px;width:100%;padding-top:8px;height:40px;border-bottom:1px solid black" >
               <div  class="col-md-6">
                  <h4 id="createTitle" class="modal-title" style="text-align:left; margin-left:10px;color:white;">CREATE TRIP</h4>
               </div>
                <div class="col-md-6" style="text-align:right;padding-right:24px;">
                   <button type="button" class="close" style="align:right;cursor:pointer;color:white;" data-dismiss="modal">&times;</button>
                </div>
             </div>
             <div class="modal-body" style="margin-top:8px;height: 80vh; overflow-y: auto;padding:0px;">
                <div class="row" style="padding:16px 16px 16px 24px 18px">
			        &nbsp;
                    <div class="col-lg-2.5" ><strong>Source:</strong>&nbsp;
                    <select id="source" name="selectStatus" style = " width :100px !important;">
                    </select>
                    </div>
					&nbsp;
                    <div class="col-lg-3.5">
                       <strong>Driver Name:</strong>&nbsp;
                       <select id="driverName" name="selectStatus">
                         <option value="0">Pick Driver</option>
                       </select>
                    </div>
					&nbsp;
                    <div class="col-lg-3.2">
                       <strong>Loading Partner:</strong>&nbsp;
                       <select id="loadingPartner" name="selectStatus">
                       </select>

                     </div>
					 &nbsp;
					 <div  class="col-lg-2.8">
                       <strong>Region:</strong>&nbsp;
                       <select id="region" name="selectStatus" style = " width :100px !important;>
					   <option value="0" selected="true" >Select Region</option>
                       </select>

                     </div>
               </div>
               <hr style="margin:8px"/>
			   
			   
			    <div class="row dispNone" style="padding:16px 16px 16px 24px" id="mtmDiv">
                    <div class="col-lg-4" style="padding:0px;"><strong >Approx Trip Start Time</strong>
                    <input id="approxTripStartTime" />
					
                    </div>
                    <div class="col-lg-4" style="padding:0px;">
                       <strong>Possible Trip Start Time stamps</strong> 
                       <select id="possibleTripStartTime" name="possibleTripStartTime">
                         <option value="11111111">--Select--</option>
                       </select>
                    </div>
                    <div class="col-lg-4" style="padding:0px;">
                       <strong>Trip Start Time</strong> 
                       <input id="tripStartTimeInput"  name="na" />
                       

                     </div>
               </div> 
               <hr style="margin:8px"/>
			   
			   

               <div class="row" style="padding:16px 16px 0px 16px">
                 <div class="col-lg-3" style="padding:0px;" id="nameDiv">
                   <select id="customerName" name="selectStatus" >
                   </select>
                   <div id="customerNameDiv" class="dispNone"><span class="red">* Required</span>
                   </div>
                 </div>
                 <div class="col-lg-3" style="padding:0px;" id="locationDiv">
                   <select id="customerLocation" name="selectStatus">
                     <option> Select Location</option>
                   </select>
                   <div id="customerLocationDiv" class="dispNone"><span class="red">* Required</span>
                   </div>
                 </div>
                     <div class="col-lg-6"  style="padding:0px"><strong>Scan Id:</strong>&nbsp;&nbsp;&nbsp;<input type="text" style="width:70%;border-radius:4px;" id="scan"/></div>

               </div>
               <div class="row">
                     <div class="col-lg-12" style="padding-top:8px;" >
                        <table id="scanTableCreate"  class="table table-striped table-bordered" cellspacing="0" style="width:100%;">
                           <thead>
                              <tr>
                                <th>Sl No</th>
                               <th>Scan Id</th>
                               <th>Order No.</th>
                               <th>Delivery Ticket No.</th>
                               <th>Delivery Note No.</th>
                               <th>Customer Name</th>
                               <th>Customer Loc</th>
                               <th>Scanned By</th>
                               <th>Scanned Date</th>
                               <th id="removeDelivery">Remove</th>
                              </tr>
                           </thead>
                        </table>
                     </div>
               </div>
               <div class="row" id="remarksDiv">
                 <div class="col-lg-12" style="padding:16px;" >
                   <strong>Remarks:</strong><br/> <input type="textarea" rows="4" style="width:100%" id="remarks"/>
                 </div>
               </div>
             </div>
             <div class="modal-footer"  style="text-align: right; height:52px;" >
		<button type="reset" id="manualTripStart" style="width: 160px;" class="btn btn-success btnScreen dispNone" onclick="manualTripStart()">Manual Trip Start</button>
                <button type="reset" id="closeTrip" class="btn btn-success btnScreen dispNone" onclick="closeTrip()">Close Trip</button>
                <button type="reset" id="modifyTrip" class="btn btn-success btnScreen dispNone" onclick="modifyTrip()">Modify Trip</button>
                <button type="reset" id="cancelTrip" class="btn btn-success btnScreen dispNone" onclick="btnCancelTrip()">Cancel Trip</button>
                <button type="reset" id="saveTrip" class="btn btn-success btnScreen dispNone" onclick="saveTrip()">Save</button>
				<button type="reset" id="saveMTMTrip" class="btn btn-success btnScreen dispNone" onclick="saveMTMTrip()">Save MTM</button>
                <button type="reset" onclick="discard()" class="btn btn-danger btnScreen">Discard</button>
             </div>
      </div>
      <div id="customerCollectionModal" class="modal fade customerCollectio">
             <div class="row blueGreyDark" style="border-radius: 4px;width:100%;padding-top:8px;height:40px;border-bottom:1px solid black" >
               <div  class="col-md-6">
                  <h4 id="createTitle" class="modal-title" style="text-align:left; margin-left:10px;color:white;">CUSTOMER COLLECTION</h4>
               </div>
                <div class="col-md-6" style="text-align:right;padding-right:24px;">
                   <button type="button" class="close" style="align:right;cursor:pointer;color:white;" data-dismiss="modal">&times;</button>
                </div>
             </div>
             <div class="modal-body" style="margin-top:8px;height: 80vh; overflow-y: auto;padding:0px;">
                <div class="row" style="padding:16px 16px 16px 24px">
				    <div class="col-lg-4" style="padding:0px;"><strong>Source:</strong>&nbsp;&nbsp;&nbsp;
                    <select id="sourceCustColl" name="selectStatus">
                    </select>
                    </div>
					 <div class="col-lg-8"  style="padding:0px"><strong>Scan Id:</strong>&nbsp;&nbsp;&nbsp;
						<input type="text" style="width:70%;border-radius:4px;" id="scanCustColl"/>
					</div>
				  </div>
                 <div class="row">
                     <div class="col-lg-12" style="padding-top:8px;" >
                        <table id="scanTableCustColl"  class="table table-striped table-bordered" cellspacing="0" style="width:100%;">
                           <thead>
                              <tr>
                               <th>Sl No</th>
                               <th>Scan Id</th>                            
							   <th>Customer Name</th>
							   <th>Loading Partner</th>
							   <th>Collected By</th>
							   <th>Mobile Number</th>
							   <th>Vehicle Number</th>
							   <th>Remarks</th>
							   <th>Order No.</th>
                               <th>Delivery Ticket No.</th>
                               <th>Delivery Note No.</th>                            
                               <th>Scanned By</th>
                               <th>Scanned Date</th>
                               <th id="removeCustColl">Remove</th>
                              </tr>
                           </thead>
                        </table>
                     </div>
               </div>
             </div>
             <div class="modal-footer"  style="text-align: right; height:52px;" >
                <button type="reset" id="saveTrip" class="btn btn-success btnScreen" onclick="saveCustCollection()">Save</button>
                <button type="reset" onclick="discard()" class="btn btn-danger btnScreen">Discard</button>
             </div>
      </div>




	<div id="acknowledgeTripModal" class="modal fade createTrip">
             <div class="row blueGreyDark" style="border-radius: 4px;width:100%;padding-top:8px;height:40px;border-bottom:1px solid black" >
               <div  class="col-md-6">
                  <h4 id="createTitle" class="modal-title" style="text-align:left; margin-left:10px;color:white;">ACKNOWLEDGE TRIP</h4>
               </div>
                <div class="col-md-6" style="text-align:right;padding-right:24px;">
                   <button type="button" class="close" style="align:right;cursor:pointer;color:white;" data-dismiss="modal">&times;</button>
                </div>
             </div>
             <div class="modal-body" style="margin-top:8px;height: 80vh; overflow-y: auto;padding:0px;">
         <!--      <div class="row" style="padding:16px 16px 16px 24px">

                    <div class="col-lg-4" style="padding:0px;">
                       <strong>Driver Name:</strong>&nbsp;&nbsp;&nbsp;
                       <select id="driverAckName" name="selectStatus" >
                         <option value="0">Pick Driver</option>
                       </select>
                    </div>

               </div>
               <hr style="margin:8px"/>  -->

               <div class="row" style="padding:16px 16px 0px 16px">

               <div class="col-lg-4" style="padding:0px;">
                       <strong>Driver Name:</strong>&nbsp;&nbsp;&nbsp;
                       <select id="driverAckName" name="selectStatus" >
                         <option value="0">Pick Driver</option>
                       </select>
                    </div>

                 <div class="col-lg-6"  style="padding:0px"><strong>Scan Id:</strong>&nbsp;&nbsp;&nbsp;
                 <input type="text" style="width:70%;border-radius:4px;" id="scanAck"/></div>
                 <div class="col-lg-3" style="padding:0px;" id="nameDiv">

                 </div>
                 <div class="col-lg-3" style="padding:0px;" id="locationDiv">

                 </div>


               </div>
               <div class="row">
                     <div class="col-lg-12" style="padding-top:8px;" >
                        <table id="ackTable"  class="table table-striped table-bordered" cellspacing="0" style="width:100%;">
                           <thead>
                              <tr>
                                <th>Sl No</th>
                               <th>Scan Id</th>
                               <th>Order No.</th>
                               <th>Delivery Ticket No.</th>
                               <th>Delivery Note No.</th>
                               <th>Customer Name</th>
                               <th>Customer Loc</th>
                               <th>Acknowledge Date</th>
                               <th>Delivery Status</th>
                              </tr>
                           </thead>
                        </table>
                     </div>
               </div>
                <div class="row" id="remarksDivForAck"> <!-- style="position:absolute;bottom:8px;" -->
                 <div class="col-lg-12" style="padding:16px;" >
                   <strong>Remarks:</strong><br/> <input type="textarea" rows="4" style="width:100%" id="remarksForAck"/>
                 </div>
               </div>
             </div>
             <div class="modal-footer"  style="text-align: right; height:52px;" >
                <button type="reset" id="ackSaveTrip" class="btn btn-success btnScreen" onclick="acknowledgeOrders()">Acknowledge</button>
                <button type="reset" onclick="discard()" class="btn btn-danger btnScreen">Discard</button>
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
		  
		  
	 
		
		<div id="manualTripStartModal" style="height:100vh;width:100%;background:none;z-index: 999999;" class="modal fade" data-backdrop="static" data-keyboard="false">
			<div class="modal-content" style="width:50%;top:30%;left:25%">
				<div class="row blueGreyDark" style="width:100%;padding-top:8px;height:40px;border-bottom:1px solid black" >
					<div  class="col-md-6">
						<h4 id="tripEventsTitle" class="modal-title" style="text-align:left; margin-left:10px;color:white;">Manual Trip Start</h4>
				</div>
                <div class="col-md-6" style="text-align:right;padding-right:24px;">
                   <button type="button" class="close" style="align:right;cursor:pointer;color:white;" onclick="closeManualTripModal()" data-dismiss="modal">&times;</button>
                </div>
             </div>
				
				<div class="col-lg-12 col-md-12 col-sm-12 col-xs-12 text-center">
					<div id="page-loader1" style="margin-top: 10px; display: none;">
						<img src="../../Main/images/loading.gif" alt="loader" />
					</div>
				</div>
				<div class="modal-body" style="max-height: 50%; margin-bottom: 0px;">
					<div class="col-md-12">
						<table class="table table-sm table-bordered table-striped">
							<tbody>
								
								<tr>
									<td>Trip Created Time</td>
									<td><input type="text" id="tripInsertedTime" class='form-control comboClass' disabled ></td>
								</tr>
								
								<tr>
									<td>Actual Trip Departure</label></td>
									<td><input class="form-control comboClass" id="atdDateTimeInput"/></td>
								</tr>
							</tbody>
						</table>
					</div>
				</div>
				
				<div class="modal-footer"  style="text-align: right; height:52px;" >
					<button type="reset" id="btnManualTripStart" class="btn btn-success btnScreen" onclick="saveManualTripStart()">Save</button>
					<button type="reset" onclick="closeManualTripModal()" class="btn btn-danger btnScreen">Cancel</button>
				</div>
				
			</div>
	</div>



<script src="https://maps.googleapis.com/maps/api/js?v=3.exp&libraries=places,geometry&key=AIzaSyCyYEUU6pc21YSjckg3bB41p2EFLCDARGg&region=IN">
</script>
<script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
<script src="//code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
<script>

var status = 0;
var noncommveh = false;
var unassignedVehtype = "";
var data;
var scanJSONCreate = [];
var scanJSONClose = [];
var scanJSONCustColl = [];
var deliveryPointsArray = [];
var ackJSONTable = [];
var idSelected = 1;
//getSATDashBoardCounts();

<!--function getSATDashBoardCounts()-->
<!--{-->
<!--          $.ajax({-->
<!--             type: "POST",-->
<!--              url: '<%=request.getContextPath()%>/GeneralVerticalDashboardAction.do?param=getSATDashBoardCounts',-->
<!--             "dataSrc": "vehicleCounts",-->
<!--             success: function(result) {-->
<!--               console.log(result)-->
<!--              data =  JSON.parse(result);-->
<!---->
<!--               $("#availableLessThan30Min").html(data["vehicleCounts"][0].available);-->
<!--               $("#availableGreaterThan30Min").html(data["vehicleCounts"][0].enroute);-->
<!--               $("#onTrip").html(data["vehicleCounts"][0].onTrip);-->
<!--               $("#waiting").html(data["vehicleCounts"][0].waitingForLoading);-->
<!--               $("#notReady").html(data["vehicleCounts"][0].notReadyForLoading);-->
<!--               $("#temperatureAlert").html(data["vehicleCounts"][0].tempAlert);-->
<!--               $("#nonComm").html(data["vehicleCounts"][0].nonCommVehicles);-->
<!---->
<!--         }-->
<!--         });-->
<!--       }-->


      var map;
      var info;
      var initial = true;
      var tripType = "create";
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
	var tableCustColl;
    var endDatehid;
    var countryName = '<%=countryName%>';
    var $mpContainer = $('#map');
    var custName = "ALL";
    var routeId = "ALL";
    var tripStatus = "ALL";
    var flag = false;
    var toggle = "hide";
   // var tripStat = "All";
	var newScanId = '';
	var tempScanId = '';
	var lengthOfRec = '';
	var addcustList = [];
	var customerHTML = "";
	var loadingPartnerHTML = "";
		
    $( document ).ready(function() {
		
		

        $("#map").css("height", $(window).height()-200);
        var heightVal = ($("#map").height())/1.8;
        $("#columnContainer").css("height", $(window).height()-200);
        $('#statusDropDownId').select2();
        $('#driverDropDownId').select2();
		getSemiAutoConfig();
		checkAccess();
        refreshNumbers();
		 tableCustColl = $('#scanTableCustColl').DataTable({
                    "scrollY": "300px",
                    "scrollX": true,
                    paging : false,
                    "oLanguage": {
                        "sEmptyTable": "No data available"
                    }
                  });
				  
		   

    });
    function getSemiAutoConfig(){
		$.ajax({
          url: '<%=request.getContextPath()%>/SemiAutoTripAction.do?param=getTripConfiguration',
          type : 'GET',
		  async: false,
		  contentType: 'application/json',
          success: function(result) {
					console.log(result);
					result = JSON.parse(result);
					tripConfiguration = result.tripDetails[0];
				}
			})
		
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
					//console.log(result);
					if(result.roleType=="0")
					{
						if (result.roleName == "Admin" && tripConfiguration.enableBorderAlert == "Y")
							$("#regionDiv").removeClass("dispNone");
					}
					if (result.roleName == "Admin"){
						(tripConfiguration.enableCustCollection =="Y") ?  $("#btnCustomerColl").removeClass("dispNone"):"";
						$("#btnCreateTrip").removeClass("dispNone");
						$("#btnModifyTrip").removeClass("dispNone");
						$("#btnCloseTrip").removeClass("dispNone");
						$("#btnAcknowledgeTrip").removeClass("dispNone");
					    (tripConfiguration.enableMTM =="Y") ?  $("#mtm").removeClass("dispNone"):"";					
					}else{
						for (var r=0;r<result.roleMenus.length;r++){
							if (result.roleMenus[r].menuId === 935){ // menu id from ADMINISTRATOR.dbo.MENU_MASTER
								// console.log(result.roleMenus[r]);
								 (result.roleMenus[r].permissionAdd =="Y" && tripConfiguration.enableCustCollection =="Y") ?  $("#btnCustomerColl").removeClass("dispNone"):"";
								 result.roleMenus[r].permissionAdd =="Y" ?  $("#btnCreateTrip").removeClass("dispNone"):"";
								 result.roleMenus[r].permissionUpdate =="Y" ?  $("#btnModifyTrip").removeClass("dispNone"):"";
								 result.roleMenus[r].permissionUpdate =="Y" ?  $("#btnCloseTrip").removeClass("dispNone"):"";
								 result.roleMenus[r].permissionUpdate =="Y" ?  $("#btnAcknowledgeTrip").removeClass("dispNone"):"";
								 (result.roleMenus[r].permissionAdd =="Y" && tripConfiguration.enableMTM =="Y") ?  $("#mtm").removeClass("dispNone"):"";
							}
						}
					}
					if(tripConfiguration.enableBorderAlert == "Y"){
						    $("#atBorderPanel").removeClass("dispNone");
					}
				}
			})
		}

    function refreshNumbers(){
		
			var arr = [];
			$("#regionDropDownId > option:selected").each(function(){
			   arr.push(this.value);
			});
			var regionsId="";
			if(arr.length==0)
				 regionsId="0";
			 else
			 regionsId= arr.join(', ');

		var regionsIdObj={'regionsId':regionsId};
		//console.log(regionsIdObj);
    loadDriversByStatus($('#statusDropDownId').val());
      $.ajax({
           url: '<%=request.getContextPath()%>/GeneralVerticalDashboardAction.do?param=getJotunDriverDetention&regionsId='+regionsId,
          "dataSrc": "driverDetentionIndex",
          type : 'GET',
          success: function(result) {
          data =  JSON.parse(result);
            var html = "";
            html = '<li class="list-group-item"><div class="col-lg-7" style="font-weight: bold;padding-left:8px;">Driver (Vehicle No.)</div><div class="col-lg-5 pointer" style="font-weight: bold;">Time (HH:MM)</div></li>';
            for (var i = 0; i < data["driverDetentionIndex"].length; i++) {
<!--              var status = "redStatus";-->
<!--              if(parseInt(data["driverDetentionIndex"][i].detention) >=15 && parseInt(data["driverDetentionIndex"][i].detention) <= 45 )-->
<!--              {-->
<!--                  status = "orangeStatus"-->
<!--              } else if (parseInt(data["driverDetentionIndex"][i].detention) <15){-->
<!--                  status = "greenStatus"-->
<!--              }-->
              html +='<li class="list-group-item '+data["driverDetentionIndex"][i].status+'" >';
              html +='<div class="col-lg-8">'+data["driverDetentionIndex"][i].driverName+'</div>';
              html +='<div class="col-lg-4 pointer">'+data["driverDetentionIndex"][i].detention+'</div></li>';
            }

            $("#driverDetention").html(html);
 			$("#insideHQ").html(data["driverDetentionIndex"].length);
          }
      })


      $.ajax({
              type: "POST",
              url: '<%=request.getContextPath()%>/GeneralVerticalDashboardAction.do?param=getJotunDashBoardCounts&regionsId='+regionsId,
             "dataSrc": "vehicleCounts",
             success: function(result) {
              data =  JSON.parse(result);
            $("#availableLessThan30Min").html(data["vehicleCounts"][0].availableLess);
            $("#availableGreaterThan30Min").html(data["vehicleCounts"][0].availableGreater);
            $("#onTrip").html(data["vehicleCounts"][0].onTrip);
            $("#tripAssigned").html(data["vehicleCounts"][0].tripAssigned);
           // $("#insideHQ").html("");
            $("#totalAvailable").html(data["vehicleCounts"][0].totalAvailable);
             $("#atBorder").html(data["vehicleCounts"][0].atBorder);
              $("#stopped").html(data["vehicleCounts"][0].stopped);


          }
      })

<!--      $.ajax({-->
<!--          url: 'map.json',-->
<!--          type : 'GET',-->
<!--          success: function(response) {-->
<!---->
<!---->
<!--          }-->
<!--      })-->


    }
	
	
	function onRegionChanges()
	{
		
		var arr = [];
		$("#regionDropDownId > option:selected").each(function(){
		   arr.push(this.value);
		});
		var regionsId="";
		if(arr.length==0)
			 regionsId="0";
		 else
		 regionsId= arr.join(', ');

		var regionsIdObj={'regionsId':regionsId};
		//console.log(regionsIdObj);
		    loadDriversByStatus($('#statusDropDownId').val());
      $.ajax({
           url: '<%=request.getContextPath()%>/GeneralVerticalDashboardAction.do?param=getJotunDriverDetention&regionsId='+regionsId,
          "dataSrc": "driverDetentionIndex",
          type : 'POST',
          success: function(result) {
          data =  JSON.parse(result);
            var html = "";
            html = '<li class="list-group-item"><div class="col-lg-7" style="font-weight: bold;padding-left:8px;">Driver (Vehicle No.)</div><div class="col-lg-5 pointer" style="font-weight: bold;">Time (HH:MM)</div></li>';
            for (var i = 0; i < data["driverDetentionIndex"].length; i++) {
<!--              var status = "redStatus";-->
<!--              if(parseInt(data["driverDetentionIndex"][i].detention) >=15 && parseInt(data["driverDetentionIndex"][i].detention) <= 45 )-->
<!--              {-->
<!--                  status = "orangeStatus"-->
<!--              } else if (parseInt(data["driverDetentionIndex"][i].detention) <15){-->
<!--                  status = "greenStatus"-->
<!--              }-->
              html +='<li class="list-group-item '+data["driverDetentionIndex"][i].status+'" >';
              html +='<div class="col-lg-8">'+data["driverDetentionIndex"][i].driverName+'</div>';
              html +='<div class="col-lg-4 pointer">'+data["driverDetentionIndex"][i].detention+'</div></li>';
            }

            $("#driverDetention").html(html);
 			$("#insideHQ").html(data["driverDetentionIndex"].length);
          }
      })


      $.ajax({
              type: "POST",
              url: '<%=request.getContextPath()%>/GeneralVerticalDashboardAction.do?param=getJotunDashBoardCounts&regionsId='+regionsId,
             "dataSrc": "vehicleCounts",
             success: function(result) {
              data =  JSON.parse(result);
            $("#availableLessThan30Min").html(data["vehicleCounts"][0].availableLess);
            $("#availableGreaterThan30Min").html(data["vehicleCounts"][0].availableGreater);
            $("#onTrip").html(data["vehicleCounts"][0].onTrip);
            $("#tripAssigned").html(data["vehicleCounts"][0].tripAssigned);
           // $("#insideHQ").html("");
            $("#totalAvailable").html(data["vehicleCounts"][0].totalAvailable);
             $("#atBorder").html(data["vehicleCounts"][0].atBorder);
              $("#stopped").html(data["vehicleCounts"][0].stopped);

			$("#totalAvailable").trigger("click");
          }
      })
	}

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
//  loadMap(custName, tripStatus);
        loadTable(custName, tripStatus);
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
<!--        var mapOptions = {-->
<!--            zoom: 7,-->
<!--            center: new google.maps.LatLng(<%=latitudeLongitude%>), //23.524681, 77.810561),,-->
<!--            mapTypeId: google.maps.MapTypeId.ROADMAP,-->
<!--            mapTypeControl: false,-->
<!--            gestureHandling: 'greedy',-->
<!--            styles: [-->
<!--                    {-->
<!--                        "featureType": "all",-->
<!--                        "elementType": "labels.text.fill",-->
<!--                        "stylers": [-->
<!--                            {-->
<!--                                "color": "#7c93a3"-->
<!--                            },-->
<!--                            {-->
<!--                                "lightness": "-10"-->
<!--                            }-->
<!--                        ]-->
<!--                    },-->
<!--                    {-->
<!--                        "featureType": "water",-->
<!--                        "elementType": "geometry.fill",-->
<!--                        "stylers": [-->
<!--                            {-->
<!--                                "color": "#7CC7DF"-->
<!--                            }-->
<!--                        ]-->
<!--                    }-->
<!--                ]-->
<!---->
<!--        };-->
<!--        map = new google.maps.Map(document.getElementById('map'), mapOptions);-->
<!--        var trafficLayer = new google.maps.TrafficLayer();-->
<!--        trafficLayer.setMap(map);-->
<!--        var geocoder = new google.maps.Geocoder();-->
<!---->
<!---->
<!--        geocoder.geocode( {'address' : "Dubai"}, function(results, status) {-->
<!--            if (status == google.maps.GeocoderStatus.OK) {-->
<!--                map.setCenter(results[0].geometry.location);-->
<!--            }-->
<!--        });-->

		loadLoadingPartners();
  		loadTripCustomer();
		getSource();
		getRegions();
	
		
    }

    function btnGo()
    {
      buffer_circle = new google.maps.Circle({
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

    function discard(){
                      swal({
                        title: "Are you sure you want to discard?",
                        text: "",
                        type: "warning",
                        showCancelButton: true,
                        confirmButtonClass: "btn-danger",
                        confirmButtonText: "Yes, Discard",
                        closeOnConfirm: true
                           },
                        function(){
								$('#customerCollectionModal').modal('hide');
                                $('#createTripModal').modal('hide');
                                $('#acknowledgeTripModal').modal('hide');
								idSelected = 1;
                         });

    }

    $('#scan').on("propertychange change click keyup input paste", function(e) {
      if($("#scan").val().trim().length == 0)
      {
        return;
      }
      var scanValue = $("#scan").val().trim();
      scanValue = scanValue.split(' ').join('');
      scanValue = scanValue.split('-').join('');

      if(scanValue.length >36){
        sweetAlert("Invalid Scan Id");
        $("#scan").val("");
        return;
      }
       var str = $('#scan').val();
       if(/^[a-zA-Z0-9-]*$/.test(str) == false) {
    		sweetAlert('Your scan id contains illegal characters.');
    		return;
	   }
		
		// let scanIdPattern = /^[a-zA-Z0-9\.\-]*/;
		 //if(!scanIdPattern.test(scanValue)){
           //  sweetAlert("Invalid scan Id");
         //}
      // if(scanValue.length < 35) {
      //   sweetAlert("Scan Id is not in the correct format.");
      //   $("#scan").val("");
      //   return;}

      if (scanValue.length ==36){



        if(tripType  == "close")
        {
          loadScanTableClose();
          $("#scan").val("");
        }
        else {

                    //if($("#loadingPartner").val() == 0 || $("#loadingPartner").val() == null || $("#loadingPartner").val() == "")
                    //{
                       //$("#loadingPartnerDiv").removeClass("dispNone");
                       //sweetAlert("Please choose a loading partner");
                       //$("#scan").val("");
                      // return;
                   // }
                   // else {
                    //  $("#loadingPartnerDiv").addClass("dispNone");
                    //}
          if($("#customerName").val() == 0|| $("#customerName").val() == null || $("#customerName").val() == "")
          {
             $("#customerNameDiv").removeClass("dispNone");
             sweetAlert("Please choose a customer");
             $("#scan").val("");
             return;
          }
          else {
            $("#customerNameDiv").addClass("dispNone");
          }

          if($("#customerLocation").val() == 0 || $("#customerLocation").val() == null || $("#customerLocation").val() == "")
          {
             $("#customerLocationDiv").removeClass("dispNone");
             sweetAlert("Please choose a customer  location");
             $("#scan").val("");
             return;
          }
          else {
            $("#customerLocationDiv").addClass("dispNone");
          }



            // 55555646298 4667927 -1- W4317158-W4317158
            // First 4 digits � Company Code (5555)
            // Next 7 digits � Delivery Ticket # (5646298)
            // Next 7 digits � Delivery Note # (4667927)
            // Last 8 alpha numeric � Order # (W4317158)
            scanValue =  $("#scan").val().trim();
            var result = scanJSONCreate;
            var scanned  = false;
            $.each(result, function(i, item) {
               if(item.scanId === scanValue)
               {
                 sweetAlert("Already scanned!");
                 scanned = true;
               }
            })

            if(scanned){
              $("#scan").val("");
              return;
            }

            let today = new Date();
            let dd = today.getDate();

            let mm = today.getMonth()+1;
            const yyyy = today.getFullYear();
            let hh = today.getHours();
            let min = today.getMinutes();

            today = dd + "/" + mm + "/" + yyyy + " " + hh + ":" + min;

            var node = {
              scanId: scanValue ,
              orderNo: scanValue.substr(scanValue.length - 8, scanValue.length),
              deliveryTicketNo:scanValue.substr(4,7),
              deliveryNoteNo:scanValue.substr(11,8),
              tripCustomerId: $('#customerName option:selected').attr("value"),
              tripCustomerName: $('#customerName option:selected').text(),
              customerLoc : $('#customerLocation option:selected').text(),
              scannedBy: '<%=username%>',
              scannedDate: today
            }
			var deliveryPointData ={
				hubId : $('#customerLocation option:selected').attr("value"),
				latitude : $('#customerLocation option:selected').attr("latitude"),
				longitude :  $('#customerLocation option:selected').attr("longitude"),
				radius : $('#customerLocation option:selected').attr("radius"),
				detentionTime : $('#customerLocation option:selected').attr("detention"),
				name :  $('#customerLocation option:selected').text(),
				tripOrderDetails : node
			}
            scanJSONCreate.push(node);
            deliveryPointsArray.push(deliveryPointData);
            loadScanTableCreate();
            $("#scan").val("");
        }
      }
    });
	
	 $('#scanCustColl').on("input paste", function(e) {
      if($("#scanCustColl").val().trim().length == 0)
      {
        return;
      }
      var scanValue = $("#scanCustColl").val().trim();
      scanValue = scanValue.split(' ').join('');
      scanValue = scanValue.split('-').join('');
      if(scanValue.length >36){
        sweetAlert("Invalid Scan Id");
        $("#scanCustColl").val("");
        return;
      }
       var str = $('#scanCustColl').val();
       if(/^[a-zA-Z0-9-]*$/.test(str) == false) {
    		sweetAlert('Your scan id contains illegal characters.');
    		return;
	   }
      if (scanValue.length ==36){
            scanValue =  $("#scanCustColl").val().trim();
            var result = scanJSONCreate;
            var scanned  = false;//TODO PRAT
			var data = tableCustColl.rows().data();
			data.each(function (value, index) {
			   let scanId = value[1];
			   if(scanId === scanValue)
               {
                 sweetAlert("Already scanned!");
                 scanned = true;
               }
			});
            if(scanned){
              $("#scanCustColl").val("");
              return;
            }
            let today = new Date();
            let dd = today.getDate();
            let mm = today.getMonth()+1;
            const yyyy = today.getFullYear();
            let hh = today.getHours();
            let min = today.getMinutes();
            today = dd + "/" + mm + "/" + yyyy + " " + hh + ":" + min;
		  
           var node = {
              scanId: scanValue ,
              orderNo: scanValue.substr(scanValue.length - 8, scanValue.length),
              deliveryTicketNo:scanValue.substr(4,7),
              deliveryNoteNo:scanValue.substr(11,8),
              tripCustomerId: $('#customerName option:selected').attr("value"),
              tripCustomerName: $('#customerName option:selected').text(),
              customerLoc : $('#customerLocation option:selected').text(),
              scannedBy: '<%=username%>',
              scannedDate: today
            }
            scanJSONCustColl.push(node);
 			$("#scanCustColl").val("");
            loadScanTableCustCollNew(node);
      }
    });
	
	
	function watchCustChange(id,assignedId) {
			let data = tableCustColl.rows().data();
			//data.each(function (value, index) {
			for (var g=1;g <=idSelected; g++){
				
				//let orderNoVal = value[8];
				if(($("#"+ id).val() === $('#custName'+g+' option:selected').attr("value"))){
					$("#loadPartner"+ (assignedId)).val($("#loadPartner"+ g).val()).trigger('change');
					$("#collectedBy"+ (assignedId)).val($("#collectedBy"+ g).val());
					$("#mobileNo"+ (assignedId)).val($("#mobileNo"+ g).val());
					$("#vehicleNo"+ (assignedId)).val($("#vehicleNo"+ g).val());
					$("#remarks"+ (assignedId)).val($("#remarks"+ g).val());
				}
			}//)		 
	}	 
	 
	function loadScanTableCustCollNew(item){
					 
                   let row = {
                         "0": tableCustColl.rows().count() + 1,
                         "1":item.scanId,
						 "2": "<select id='custName"+idSelected+"' onChange=watchCustChange(this.id,"+idSelected+"); ></select>",
						 "3":"<select id='loadPartner"+idSelected+"' ></select>",
						 "4":"<input id='collectedBy"+idSelected+"' type='text' maxLength='50'></input>",
						 "5":"<input id='mobileNo"+idSelected+"' type='text'    maxLength='10' onkeypress='return event.charCode >= 48 && event.charCode <= 57' pattern='/^\d{10}$/'></input>",
						 "6":"<input id='vehicleNo"+idSelected+"' type='text' maxLength='20' ></input>",
						 "7":"<input id=remarks"+idSelected+" type='text' maxLength='255'></input>",
						 "8":item.orderNo,
                         "9":item.deliveryTicketNo,
                         "10":item.deliveryNoteNo,
                         "11":item.scannedBy,
                         "12":item.scannedDate,
						 "13":'<i style="cursor:pointer;" onclick="splice(\''+item.scanId+'\')" class="far fa-window-close"></i>',
						 "14": idSelected
                    }
					
                  tableCustColl.row.add(row).draw(false);
					  $("#custName"+idSelected).append($("<option></option>").attr("value", 0).text("--Select Customer--"));
				  	 	   $("#custName"+idSelected).html(customerHTML);
						   $("#custName"+idSelected).select2({
										dropdownParent: $("#customerCollectionModal")
							  });
						    $("#loadPartner"+idSelected).append($("<option></option>").attr("value", 0).text("--Pick Loading Partner--"));
											 
							$("#loadPartner"+idSelected).select2({
									dropdownParent: $("#customerCollectionModal")
							});
						
							$("#loadPartner"+idSelected).html(loadingPartnerHTML);
								tableCustColl.columns.adjust().draw();
								$("#custName"+idSelected).select2('open');
								
								idSelected++;
						   
						   
    }


     function loadScanTableCreate(){

               var result = scanJSONCreate;
               let rows = [];
                $.each(result, function(i, item) {
                   let row = {
                         "0":i+1,
                         "1":item.scanId,
                         "2":item.orderNo,
                         "3":item.deliveryTicketNo,
                         "4":item.deliveryNoteNo,
                         "5":item.tripCustomerName,
                         "6":item.customerLoc,
                         "7":item.scannedBy,
                         "8":item.scannedDate,
                         "9":'<i style="cursor:pointer;" onclick="splice(\''+item.scanId+'\')" class="far fa-window-close"></i>'

                    }
                    rows.push(row);
                  })

                  if ($.fn.DataTable.isDataTable("#scanTableCreate")) {
                    $('#scanTableCreate').DataTable().clear().destroy();
                  }
                  table = $('#scanTableCreate').DataTable({
                    "scrollY": "300px",
                    "scrollX": true,
                    paging : false,
                    "oLanguage": {
                        "sEmptyTable": "No data available"
                    }
                  });

                  table.rows.add(rows).draw();


    }

    function splice(scanId){

      var result = scanJSONCreate;
      let rows = [];
       $.each(result, function(i, item) {
       if(typeof item !== 'undefined')
       {
         if(item.scanId === scanId)
         {
           scanJSONCreate.splice(i,1);
           deliveryPointsArray.splice(i+1,1);
           loadScanTableCreate();
         }
        }
      })

    }

    var closeJSON = [];
    var closeJSONTable = [];
    var tripId;
    function btnCloseTrip()
    {
      //$("#removeDelivery").html("Delivery Status");
      closeJSONTable = [];
      if($("#driverDropDownId").val() == null || $("#driverDropDownId").val() == "" || $("#driverDropDownId").val() == 0)
      {
        $("#driverDropDownIdDiv").removeClass("dispNone");
        return;
      }
      else {
        $("#driverDropDownIdDiv").addClass("dispNone");
      }
      tripType = "close";

      $("#saveTrip").addClass("dispNone");
      $("#modifyTrip").addClass("dispNone");
      $("#cancelTrip").addClass("dispNone");
      $("#remarksDiv").removeClass("dispNone");
      $("#nameDiv").addClass("dispNone");
      $("#locationDiv").addClass("dispNone");
      $("#closeTrip").removeClass("dispNone");
      $('#createTripModal').modal('show');
	  $("#mtmDiv").addClass("dispNone");
      $('#manualTripStart').addClass("dispNone");
      $('#acknowledgeTripModal').modal('hide');
	  $("#createTitle").html("CLOSE TRIP");
	  $("#saveMTMTrip").addClass("dispNone");
	    getTripDetails();
	  loadModalDriverByStatus("ON_TRIP");
	  $("#scan").val("");

	}

	function getTripDetails(){

      closeJSONTable = [];
            $.ajax({
                url: '<%=request.getContextPath()%>/GeneralVerticalDashboardAction.do?param=getTripDetailById',
                data :{
                	systemId : <%=systemId%>,
                	customerId : <%=customerId%>,
                	tripId : $('#driverDropDownId option:selected').attr('tripId')

                },
                //beforeSend: function (xhr) {
   				// xhr.setRequestHeader ("Authorization", "Basic " + btoa('<%=serviceUserName%>' + ":" + '<%=servicePassword%>'));
				//},
                type : 'GET',
                contentType: "application/json",
                success: function(response) {
	 	response = JSON.parse(response);
                  closeJSON = response;
                  tripId = response.responseBody.tripId;
                  var insertedBy = response.responseBody.insertedByUser;
                  var insertedDate = response.responseBody.insertedDate;
                  var updatedDate = response.responseBody.updatedDate;
                  var scannedDate = "";
                  if(updatedDate != null && updatedDate !=""){
                  	scannedDate = updatedDate;
                  }else{
                  	scannedDate = insertedDate;
                  }
                  $("#region").val(response.responseBody.desTripDetails[0].tripDestination).trigger('change');
                  $("#loadingPartner").val(response.responseBody.trackTripDetailsSub.loadingPartner).trigger('change');
                  $.each(response.responseBody.desTripDetails, function(i, item) {
                  if(item.tripOrderDetails != null){
                    var itemTrip = item.tripOrderDetails;
                    var location = item.name;
                    var node = {
                      scanId: itemTrip.scanId ,
                      desTripId : itemTrip.desTripId,
                      orderNo: itemTrip.orderNo,
                      deliveryTicketNo:itemTrip.deliveryTicketNo,
                      deliveryNoteNo:itemTrip.deliveryNoteNo,
                      tripCustomerId: itemTrip.tripCustomerId,
                      tripCustomerName: itemTrip.tripCustomerName,
                      customerLoc : item.name,
                      scannedBy: insertedBy,
                      scannedDate:scannedDate,
                      //deliveryStatus:itemTrip.deliveryStatus
                    }
                    closeJSONTable.push(node);
                    }
                  })
                   if(tripType  == "close"){
                   		loadScanTableClose();
                   }else{
                   		scanJSONCreate = closeJSONTable;
                   		deliveryPointsArray = response.responseBody.desTripDetails;
                   		loadScanTableCreate();
                   }
                }
            })
    }

    function loadScanTableClose(){

               var result = closeJSONTable;
               let rows = [];
               let rowHighlight = [];
                $.each(result, function(i, item) {
                   var selectedyes = ''
                   item.deliveryStatus == "Y" ? selectedyes = 'selected' : ''
                   var selectedno = ''
                   item.deliveryStatus == "N" ? selectedno = '' : ''
                   let row = {
                        "0":i+1,
                        "1":item.scanId,
                        "2":item.orderNo,
                        "3":item.deliveryTicketNo,
                        "4":item.deliveryNoteNo,
                        "5":item.tripCustomerName,
                        "6":item.customerLoc,
                        "7":item.scannedBy,
                        "8":item.scannedDate,
                        "9":'<select id="yesNoDropDown" style="color:black !important;" onchange="yesNo(\''+item.scanId+'\',value)"><option value selected="Y" '+ selectedyes +'>Y</option><option value="N"'+ selectedno +'>N</option></select>'
                    }
                    rows.push(row);
                  })


                  var tempRows = [];
                  for(var x=0;x < rows.length ; x++)
                  {

                    if(rows[x][1]  == $("#scan").val()){
                      tempRows.unshift(rows[x]);
                    }
                    else{
                      tempRows.push(rows[x]);
                    }
                  }
                  rows = tempRows;

                  for(var x=0;x < rows.length ; x++)
                  {
                    if(rows[x][1]  == $("#scan").val()){
                      rowHighlight.push(x);
                    }
                  }

                  if ($.fn.DataTable.isDataTable("#scanTableCreate")) {
                    $('#scanTableCreate').DataTable().clear().destroy();
                  }
                  table = $('#scanTableCreate').DataTable({
                    "scrollY": "300px",
                    "scrollX": true,
                    paging : false,
                    "oLanguage": {
                        "sEmptyTable": "No data available"
                    }
                  });
                       var column = table.column(9);
                  column.visible(!column.visible());
                  table.rows.add(rows).draw();
                  table.rows( rowHighlight )
                      .nodes()
                      .to$()
                      .addClass( 'highlight' );


    }

    function yesNo(scanId, value){
        $.each(closeJSON.responseBody.desTripDetails, function(i, item) {
       	 if(item.tripOrderDetails != null){
         	 if(item.tripOrderDetails.scanId == scanId)
          	 {
            	item.tripOrderDetails.deliveryStatus = value;
          	 }
          }
        })
 

    }

function yes(scanId, value){
/*        $.each(closeJSON.responseBody.desTripDetails, function(i, item) {
       	 if(item.tripOrderDetails != null){
         	 if(item.tripOrderDetails.scanId == scanId)
          	 {
            	item.tripOrderDetails.deliveryStatus = value;
          	 }
          }
        })
        console.log("close JSON", closeJSON)  */

    }
	function btnCustomerColl(){
		idSelected = 1;
		$('#customerCollectionModal').modal('show');
		$('#scanTableCustColl').DataTable().rows().remove().draw();
		$("#scanCustColl").val("");
	}
    function btnCreateTrip()
    {
		 $("#region").show();
     if($("#driverDropDownId").val() == null || $("#driverDropDownId").val() == "" || $("#driverDropDownId").val() == 0)
      {
        $("#driverDropDownIdDiv").removeClass("dispNone");
        return;
      }
      else {
        $("#driverDropDownIdDiv").addClass("dispNone");
      }
      $("#customerLocation").val("0").trigger('change');
      $("#customerName").val("0").trigger('change');
      $("#loadingPartner").val("0").trigger('change');

      $("#remarksDiv").addClass("dispNone");
      $("#removeDelivery").html("Remove");
      tripType = "open";
      $("#nameDiv").removeClass("dispNone");
      $("#locationDiv").removeClass("dispNone");
      $("#closeTrip").addClass("dispNone");
      $("#cancelTrip").addClass("dispNone");
      $("#saveTrip").removeClass("dispNone");
      $("#modifyTrip").addClass("dispNone");
      $("#createTitle").html("CREATE TRIP");
      $('#createTripModal').modal('show');
	  $("#mtmDiv").addClass("dispNone");
	  $('#manualTripStart').addClass("dispNone");
      $('#acknowledgeTripModal').modal('hide');
	  $("#saveMTMTrip").addClass("dispNone");
	  
      document.getElementById("saveTrip").disabled=false;
      scanJSONCreate = [];
      deliveryPointsArray = [];
      setTimeout(function() {
        loadScanTableCreate();
      }, 500);
  	  scanJSONClose = [];
  	  deliveryPointsArray = [];
  		loadAvailableDrivers();
  		clearModalFields();
    }
    function clearModalFields(){
    	$("#loadingPartner").val(0).trigger('change');

		$("#customerName").val(0).trigger('change');
		$("#customerLocation").val(0).trigger('change');
		 $("#scan").val("");
    }
    function getSource() {
        $.ajax({
            url: '<%=request.getContextPath()%>/GeneralVerticalDashboardAction.do?param=getHubsByOperationId',
            data:{
<!--            	systemId : <%=systemId%>,-->
<!--            	customerId : <%=customerId%>,-->
            	hubType : 34 //TODO read this from trip configuration
            },
<!--            beforeSend: function (xhr) {-->
<!--   				 xhr.setRequestHeader ("Authorization", "Basic " + btoa('<%=serviceUserName%>' + ":" + '<%=servicePassword%>'));-->
<!--				},-->
            success: function(result) {
            $("#source").empty().select2();
			$("#sourceCustColl").empty().select2();
	            hubList = JSON.parse(result);
                for (var i = 0; i < hubList["hubDetailsRoot"].length; i++) {
                    $('#source').append($("<option></option>").attr("value", hubList["hubDetailsRoot"][i].hubid).attr("latitude", hubList["hubDetailsRoot"][i].latitude)
                        .attr("longitude", hubList["hubDetailsRoot"][i].longitude).attr("radius", hubList["hubDetailsRoot"][i].radius).attr("detention", hubList["hubDetailsRoot"][i].standard_Duration).attr("hubAddress",
                        hubList["hubDetailsRoot"][i].address).text(hubList["hubDetailsRoot"][i].name));
					$('#sourceCustColl').append($("<option></option>").attr("value", hubList["hubDetailsRoot"][i].hubid).attr("latitude", hubList["hubDetailsRoot"][i].latitude)
                        .attr("longitude", hubList["hubDetailsRoot"][i].longitude).attr("radius", hubList["hubDetailsRoot"][i].radius).attr("detention", hubList["hubDetailsRoot"][i].standard_Duration).attr("hubAddress",
                        hubList["hubDetailsRoot"][i].address).text(hubList["hubDetailsRoot"][i].name));
                }
                $("#source").select2({
	    			dropdownParent: $("#createTripModal")
				});
				 $("#sourceCustColl").select2({
	    			dropdownParent: $("#customerCollectionModal")
				});
            }
        });
    }
	
	
	 function getRegions() {
    
      $.ajax({
            url: '<%=request.getContextPath()%>/GeneralVerticalDashboardAction.do?param=getHubsByOperationId',
            data:{
            	hubType : 42 //TODO read this from trip configuration
            },
            success: function(result) {
            $("#region").empty().select2();
			
	            regionList = JSON.parse(result);
				$('#region').append($("<option></option>").attr("value", 0).text("--Select Region--"));				
				//$('#regionDropDownId').append($("<option></option>").attr("value", 0).text("--Select Region--"));
               for (var i = 0; i < regionList["hubDetailsRoot"].length; i++) {
                    $('#region').append($("<option></option>").attr("value", regionList["hubDetailsRoot"][i].hubid).attr("latitude", regionList["hubDetailsRoot"][i].latitude)
                        .attr("longitude", regionList["hubDetailsRoot"][i].longitude).attr("radius", regionList["hubDetailsRoot"][i].radius).attr("detention", regionList["hubDetailsRoot"][i].standard_Duration).attr("hubAddress",
                        regionList["hubDetailsRoot"][i].address).text(regionList["hubDetailsRoot"][i].name));
						
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
					
						$("#region").select2({
							dropdownParent: $("#createTripModal")
						});
					}
				});
    }
	
   function loadDriversByStatus(statusStr)
	{
		$("#driverDropDownId").empty().select2();
		var statusVal = $('#statusDropDownId').val();
		if(  statusVal=="0"){
			return;
		}
		$.ajax({
	        url: '<%=request.getContextPath()%>/GeneralVerticalDashboardAction.do?param=getDriversByStatus',
	        data: {
	        	status : statusStr
	        },
	        success: function(result) {
	            vehicleList = JSON.parse(result);
				$('#driverDropDownId').append($("<option></option>").attr("value", 0).text("--Pick Driver--"));
	            for (var i = 0; i < vehicleList["vehiclesRoot"].length; i++) {
                    $('#driverDropDownId').append($("<option></option>").attr("value", vehicleList["vehiclesRoot"][i].vehicleNo).attr("tripId", vehicleList["vehiclesRoot"][i].tripId).text(vehicleList["vehiclesRoot"][i].driverName));
	            }
	            $('#driverDropDownId').select2();
	        }
	    });
	}
	function loadModalDriverByStatus(status)
	{
		$("#driverName").empty().select2({
	    	dropdownParent: $("#createTripModal")
		});
		$.ajax({
	        url: '<%=request.getContextPath()%>/GeneralVerticalDashboardAction.do?param=getDriversByStatus',
	        data: {
	        	status : status
	        },
	        success: function(result) {
	            vehicleList = JSON.parse(result);
				$('#driverName').append($("<option></option>").attr("value", 0).text("--Pick Driver--"));
	            for (var i = 0; i < vehicleList["vehiclesRoot"].length; i++) {
                    $('#driverName').append($("<option></option>").attr("value", vehicleList["vehiclesRoot"][i].vehicleNo).attr("vehiclesRoot", vehicleList["vehiclesRoot"][i].driverContact)
                    .attr("driverId", vehicleList["vehiclesRoot"][i].driverId).text(vehicleList["vehiclesRoot"][i].driverName));
	            }
	            $('#driverName').select2({
	    			dropdownParent: $("#createTripModal")
				});
          		$("#driverName").val($("#driverDropDownId").val()).trigger('change');
	        }
	    });
	}
	function loadAvailableDrivers()
	{
		$("#driverName").empty().select2({
	    	dropdownParent: $("#createTripModal")
		});
		$.ajax({
	        url: '<%=request.getContextPath()%>/GeneralVerticalDashboardAction.do?param=getDriversByStatus',
	        data: {
	        	status : "AVAILABLE"
	        },
	        success: function(result) {
	            vehicleList = JSON.parse(result);
				$('#driverName').append($("<option></option>").attr("value", 0).text("--Pick Driver--"));
	            for (var i = 0; i < vehicleList["vehiclesRoot"].length; i++) {
                  $('#driverName').append($("<option></option>").attr("value", vehicleList["vehiclesRoot"][i].vehicleNo).attr("driverContact", vehicleList["vehiclesRoot"][i].driverContact)
                    .attr("driverId", vehicleList["vehiclesRoot"][i].driverId).text(vehicleList["vehiclesRoot"][i].driverName));
	            }
	            $('#driverName').select2({
	    			dropdownParent: $("#createTripModal")
				});
          $("#driverName").val($("#driverDropDownId").val()).trigger('change');
	        }
	    });
	}
	function loadLoadingPartners()
	{
		loadingPartnerHTML = "";
		$("#loadingPartner").empty().select2();
		$('#loadingPartner').select2({
	    	dropdownParent: $("#createTripModal")
		});
		$.ajax({
	        url: '<%=request.getContextPath()%>/GeneralVerticalDashboardAction.do?param=getLoadingPartners',
	        data: {

	        },
	        success: function(result) {
	            loadingPartnerList = JSON.parse(result);
	            $('#loadingPartner').append($("<option></option>").attr("value", 0).text("--Pick Loading Partner--"));
	            for (var i = 0; i < loadingPartnerList["loadingPartnerRoot"].length; i++) {
                    $('#loadingPartner').append($("<option></option>").attr("value", loadingPartnerList["loadingPartnerRoot"][i].name).text(loadingPartnerList["loadingPartnerRoot"][i].name));
	            }
				loadingPartnerHTML = $('#loadingPartner').html();
	            $('#loadingPartner').select2({
	    			dropdownParent: $("#createTripModal")
				});
				
	        }
	    });
	}
	
	function loadTripCustomer(){
		customerHTML = "";
		$("#customerName").empty().select2();
   		$.ajax({
	        url: '<%=request.getContextPath()%>/SemiAutoTripAction.do?param=getTripCustomers',
	        success: function(result) {
	            addcustList = JSON.parse(result);
	            $('#customerName').append($("<option></option>").attr("value", 0).text("--Select Customer--"));
	            for (var i = 0; i < addcustList["customerRoot"].length; i++) {
                    $('#customerName').append($("<option></option>").attr("value", addcustList["customerRoot"][i].CustId).text(addcustList["customerRoot"][i].CustName));
					 $('#customerNameCustColl').append($("<option></option>").attr("value", addcustList["customerRoot"][i].CustId).text(addcustList["customerRoot"][i].CustName));
	            }
				customerHTML = $('#customerName').html();
	            $('#customerName').select2({
	    			dropdownParent: $("#createTripModal")
				});
			}
		});
	}
	function loadTripCustomerToSelect(selectBoxId){
		 
		  $("#"+selectBoxId+"").empty().select2();
		   for (var i = 0; i < addcustList["customerRoot"].length; i++) {
			 $("#"+selectBoxId+"").append($("<option></option>").attr("value", addcustList["customerRoot"][i].CustId).text(addcustList["customerRoot"][i].CustName));
			$('#'+selectBoxId+'').select2({
						dropdownParent: $("#customerCollectionModal")
					});
					 
		   }
		
	}
	$("#customerName").change(function() {
		loadHubsByTripCustomer();
	})
	function loadHubsByTripCustomer(){
		$("#customerLocation").empty().select2();
   		$.ajax({
	        url: '<%=request.getContextPath()%>/GeneralVerticalDashboardAction.do?param=getHubsByTripCustomer',
	        data: {
	        	tripCustomerId : $('#customerName option:selected').attr("value")
	        },
	        success: function(result) {
	            $("#customerLocation").empty().select2();
                hubList = JSON.parse(result)["hubsRoot"];
                $('#customerLocation').append($("<option></option>").attr("value", 0).text("--Select Location--"));
                for (var i = 0; i < hubList.length; i++) {
                    $('#customerLocation').append($("<option></option>").attr("value", hubList[i].hubId).attr("latitude", hubList[i].latitude)
                        .attr("longitude", hubList[i].longitude).attr("radius", hubList[i].radius).attr("detention", hubList[i].standard_Duration).attr("hubAddress",
                        hubList[i].address).text(hubList[i].name));
                }
                $("#customerLocation").select2({
	    			dropdownParent: $("#createTripModal")
				});
			}
		});
	}
   function btnModifyTrip(){
 
     $("#region").show();
	$("#removeDelivery").html("Remove");
      closeJSONTable = [];
      if($("#driverDropDownId").val() == null || $("#driverDropDownId").val() == "" || $("#driverDropDownId").val() == 0){
        $("#driverDropDownIdDiv").removeClass("dispNone");
        return;
      }
      else {
        $("#driverDropDownIdDiv").addClass("dispNone");
      }
      tripType = "open";

      $("#saveTrip").addClass("dispNone");
      $("#modifyTrip").removeClass("dispNone");
      $("#remarksDiv").addClass("dispNone");
      $("#nameDiv").removeClass("dispNone");
      $("#locationDiv").removeClass("dispNone");
      $("#cancelTrip").removeClass("dispNone");
      $("#closeTrip").addClass("dispNone");
      $('#createTripModal').modal('show');
	  $("#mtmDiv").addClass("dispNone");
      $('#acknowledgeTripModal').modal('hide');
	  $("#createTitle").html("MODIFY TRIP");
	  $("#manualTripStart").removeClass("dispNone");
	  $("#saveMTMTrip").addClass("dispNone");
	  getTripDetails();
      loadModalDriverByStatus("TRIP_ASSIGNED");
       clearModalFields();

	}
    function btnCancelTrip()
    {
      if($("#driverDropDownId").val() == null || $("#driverDropDownId").val() == "" || $("#driverDropDownId").val() == 0)
      {
        $("#driverDropDownIdDiv").removeClass("dispNone");
        return;
      }
      else {
        $("#driverDropDownIdDiv").addClass("dispNone");
      }

      var cancelJSON = {
        tripId:$('#driverDropDownId option:selected').attr('tripId')
      }
      swal({
                               title: "",
                               text: "Enter Remarks:",
                               type: "input",
                               showCancelButton: true,
                               closeOnConfirm: false,
                               animation: "slide-from-top",
                               inputPlaceholder: "Enter Remarks",
                               confirmButtonText: 'Cancel Trip',
            				   cancelButtonText: "Discard"
                           },
                           function(inputValue) {
                               if (inputValue === "") {
                                   swal.showInputError("Enter Remarks!");
                                   return false;
                               } else if (inputValue === true) {

                               } else if (typeof(inputValue) == "string") {
							        	$.ajax({
	        url: '<%=request.getContextPath()%>/TripCreatAction.do?param=cancelTrip',
	        data: {
	        	uniqueId:$('#driverDropDownId option:selected').attr('tripId'),
	        	vehicleNo: $('#driverName option:selected').attr("value"),
	       		remarks: inputValue,
	        	reasonId : ''
	        },
	        success: function(result) {
	        	if (result == "Trip Closed") {
	                     sweetAlert("Trip Cancelled ");
	                      $('#createTripModal').modal('hide');
	                      $('#acknowledgeTripModal').modal('hide');
			      refreshNumbers();
	                 } else {
	                    sweetAlert(result);
	                 }
	        }
		});
      }
    },
    function() {})
    }
    initialize();
    var markerCluster;
    var truckJSON = null;

    $("#driverDropDownId").on("change", function(e){

      if($("#driverDropDownId").val() == null || $("#driverDropDownId").val() == "" || $("#driverDropDownId").val() == 0)
      {
        $("#driverDropDownIdDiv").removeClass("dispNone");
      }
      else {
        $("#driverDropDownIdDiv").addClass("dispNone");
      }

    })

    $("#customerName").on("change", function(e){

      if($("#customerName").val() == null || $("#customerName").val() == "" || $("#customerName").val() == 0)
      {
        $("#customerNameDiv").removeClass("dispNone");
      }
      else {
        $("#customerNameDiv").addClass("dispNone");
      }

    })

    $("#customerLocation").on("change", function(e){

      if($("#customerLocation").val() == null || $("#customerLocation").val() == "" || $("#customerLocation").val() == 0)
      {
        $("#customerLocationDiv").removeClass("dispNone");
      }
      else {
        $("#customerLocationDiv").addClass("dispNone");
      }

    })

    $("#loadingPartner").on("change", function(e){

      if($("#loadingPartner").val() == null || $("#loadingPartner").val() == "" || $("#loadingPartner").val() == 0)
      {
        $("#loadingPartnerDiv").removeClass("dispNone");
      }
      else {
        $("#loadingPartnerDiv").addClass("dispNone");
      }

    })

    $('#statusDropDownId').on('change', function (e) {
      if($('#statusDropDownId').val() == "AVAILABLE")
      {
        $('#btnCreateTrip').prop('disabled', false);
        $('#btnModifyTrip').prop('disabled', true);
        $('#btnCloseTrip').prop('disabled', true);
        $('#btnAcknowledgeTrip').prop('disabled', false);
        $('#btnCreateTrip').addClass('btn-primary');
        $('#btnCreateTrip').removeClass('btn-basic');
        $('#btnModifyTrip').addClass('btn-basic');
        $('#btnModifyTrip').removeClass('btn-primary');
        $('#btnCloseTrip').addClass('btn-basic');
        $('#btnCloseTrip').removeClass('btn-primary');
         $('#btnAcknowledgeTrip').addClass('btn-primary');
         $('#btnAcknowledgeTrip').removeClass('btn-basic');
        loadDriversByStatus("AVAILABLE");
      }else if($('#statusDropDownId').val() == "ON_TRIP"){
        $('#btnCreateTrip').prop('disabled', true);
        $('#btnModifyTrip').prop('disabled', true);
        $('#btnCloseTrip').prop('disabled', false);
        $('#btnCloseTrip').addClass('btn-primary');
        $('#btnCloseTrip').removeClass('btn-basic');
        $('#btnModifyTrip').addClass('btn-basic');
        $('#btnModifyTrip').removeClass('btn-primary');
        $('#btnCreateTrip').addClass('btn-basic');
        $('#btnCreateTrip').removeClass('btn-primary');
        $('#btnAcknowledgeTrip').prop('disabled', false);
         $('#btnAcknowledgeTrip').addClass('btn-primary');
        $('#btnAcknowledgeTrip').removeClass('btn-basic');
        loadDriversByStatus("ON_TRIP");
      }else if($('#statusDropDownId').val() == "TRIP_ASSIGNED"){
        $('#btnCreateTrip').prop('disabled', true);
        $('#btnModifyTrip').prop('disabled', false);
        $('#btnCloseTrip').prop('disabled', true);
        $('#btnModifyTrip').addClass('btn-primary');
        $('#btnModifyTrip').removeClass('btn-basic');
        $('#btnCreateTrip').addClass('btn-basic');
        $('#btnCreateTrip').removeClass('btn-primary');
        $('#btnCloseTrip').addClass('btn-basic');
        $('#btnCloseTrip').removeClass('btn-primary');
         $('#btnAcknowledgeTrip').prop('disabled', false);
        $('#btnAcknowledgeTrip').addClass('btn-primary');
        $('#btnAcknowledgeTrip').removeClass('btn-basic');
        loadDriversByStatus("TRIP_ASSIGNED");
      }else if($('#statusDropDownId').val() == "CUSTOMER_COLLECTION"){
		 $('#btnCreateTrip').prop('disabled', false);
        $('#btnModifyTrip').prop('disabled', true);
        $('#btnCloseTrip').prop('disabled', true);
        $('#btnAcknowledgeTrip').prop('disabled', false);
        $('#btnCreateTrip').addClass('btn-primary');
        $('#btnCreateTrip').removeClass('btn-basic');
        $('#btnModifyTrip').addClass('btn-basic');
        $('#btnModifyTrip').removeClass('btn-primary');
        $('#btnCloseTrip').addClass('btn-basic');
        $('#btnCloseTrip').removeClass('btn-primary');
         $('#btnAcknowledgeTrip').addClass('btn-primary');
         $('#btnAcknowledgeTrip').removeClass('btn-basic');
	  }
    })

<!--    $('#vehicleNoDropDownId').on('select2:select', function (e) {-->
<!---->
<!--        var truck = null;-->
<!--        for (var i = 0; i < markerClusterArray.length; i++ ) {-->
<!--           markerClusterArray[i].setMap(null);-->
<!--        }-->
<!--        markerClusterArray.length = 0;-->
<!--        console.log("Truck JSON", truckJSON)-->
<!--        for (var i = 0; i < truckJSON.length; i++) {-->
<!--            if(truckJSON[i].vehicleNo == e.params.data.id ){-->
<!--              truck = truckJSON[i];-->
<!--            }-->
<!--         }-->
<!--         plotSingleVehicle(truck.vehicleNo, truck.lat, truck.lon,-->
<!--           truck.location, truck.driverName,truck.status);-->
<!---->
<!---->
<!--         var mylatLong = new google.maps.LatLng(truck.latitude, truck.longitude);-->
<!---->
<!---->
<!--         // Add a marker clusterer to manage the markers.-->
<!--         if(markerCluster != null)-->
<!--         {-->
<!--           markerCluster.clearMarkers();-->
<!--         }-->
<!--         markerCluster = new MarkerClusterer(map, markerClusterArray,-->
<!--              {imagePath: 'https://developers.google.com/maps/documentation/javascript/examples/markerclusterer/m'});-->
<!--    });-->


    function loadVehicleStatusList(custName,tripStatus) {
    //was load map initially. was changed to a list for vehicle status and map was removed
		var arr = [];
		$("#regionDropDownId > option:selected").each(function(){
		   arr.push(this.value);
		});
		var regionsId="";
		if(arr.length==0)
			 regionsId="0";
		 else
		 regionsId= arr.join(', ');
		 
		// console.log(regionsId);
        $.ajax({
          url: '<%=request.getContextPath()%>/GeneralVerticalDashboardAction.do?param=getJotunVehiclesMapDetails&regionsId='+regionsId,
             data: {
                   statusId: tripStatus,
               },
            "dataSrc": "MapViewIndex",
            success: function(result) {

              //  var bounds = new google.maps.LatLngBounds();


                results = JSON.parse(result);
                //console.log("Map",results);
                truckJSON = results["MapViewIndex"];
                var count = 0;
			console.log(results);

            var html1 = "";
            if(tripStatus == "available"){
	             html1 = '<li class="list-group-item"><div class="col-lg-4" style="font-weight: bold;">Driver (Vehicle No.)</div>'+
						' <div class="col-lg-4" style="font-weight: bold;">Location</div>'+
	            		'<div class="col-lg-4 pointer" style="font-weight: bold;text-align: center;">ETA To HQ (HH:MM)</div></li>';
	            htmlReachedHq = "";
	            for (var i = 0; i < results["MapViewIndex"].length; i++) {
	             if(results["MapViewIndex"][i].etaSourceHub == "Reached HQ"){
	             	  htmlReachedHq +='<li class="list-group-item" >';
		              htmlReachedHq +='<div class="col-lg-4">'+results["MapViewIndex"][i].driverName+'('+results["MapViewIndex"][i].vehicleNo+')</div>';
					  htmlReachedHq +='<div class="col-lg-4">'+results["MapViewIndex"][i].location+'</div>';
		              htmlReachedHq +='<div class="col-lg-4 pointer" style="text-align: center;">'+results["MapViewIndex"][i].etaSourceHub+'</div></li>';
	             }else{
		              html1 +='<li class="list-group-item" >';
		              html1 +='<div class="col-lg-4">'+results["MapViewIndex"][i].driverName+'('+results["MapViewIndex"][i].vehicleNo+')</div>';
					  html1 +='<div class="col-lg-4">'+results["MapViewIndex"][i].location+'</div>';
		              html1 +='<div class="col-lg-4 pointer" style="text-align: center;">'+results["MapViewIndex"][i].etaSourceHub+'</div></li>';
	              }
	            }
	            html1 = html1 + htmlReachedHq;
	          }else{
				  if(tripStatus=="atBorder")
				  {
					html1 = '<li class="list-group-item"><div class="col-lg-4" style="font-weight: bold;">Driver (Vehicle No.)</div>'+		
						'<div class="col-lg-4" style="font-weight: bold;">Location</div>'+
						'<div class="col-lg-4 pointer" style="font-weight: bold;">Detention(HH:MM)</div></li>';
					for (var i = 0; i < results["MapViewIndex"].length; i++) {
					  html1 +='<li class="list-group-item" >';
 					  html1 +='<div class="col-lg-4">'+results["MapViewIndex"][i].driverName+'('+results["MapViewIndex"][i].vehicleNo+')</div>';
					  html1 +='<div class="col-lg-4 pointer">'+results["MapViewIndex"][i].location+'</div>'
					  html1 +='<div class="col-lg-4 pointer">'+results["MapViewIndex"][i].detention+'</div></li>';
					}  
				  }
				   else if(tripStatus=="stopped")
				  {
					html1 = '<li class="list-group-item"><div class="col-lg-4" style="font-weight: bold;">Driver(Vehicle No.)</div><div class="col-lg-4 pointer" style="font-weight: bold;">Location</div><div class="col-lg-4" style="font-weight: bold;">Waiting Hours(HH:MM)</div></li>';
					for (var i = 0; i < results["MapViewIndex"].length; i++) {
					  html1 +='<li class="list-group-item" >';
					  html1 +='<div class="col-lg-4">'+results["MapViewIndex"][i].driverName+'('+results["MapViewIndex"][i].vehicleNo+')</div>';
					  html1 +='<div class="col-lg-4 pointer">'+results["MapViewIndex"][i].location+'</div>';
					  html1 +='<div class="col-lg-4 pointer">'+results["MapViewIndex"][i].duration+'</div></li>';
					}  
				  }
				  else
				  {
					html1 = '<li class="list-group-item"><div class="col-lg-6" style="font-weight: bold;">Driver(Vehicle No.)</div><div class="col-lg-6 pointer" style="font-weight: bold;">Location</div></li>';
					for (var i = 0; i < results["MapViewIndex"].length; i++) {
					  html1 +='<li class="list-group-item" >';
					  html1 +='<div class="col-lg-6">'+results["MapViewIndex"][i].driverName+'('+results["MapViewIndex"][i].vehicleNo+')</div>';
					  html1 +='<div class="col-lg-6">'+results["MapViewIndex"][i].location+'</div></li>';
					}
				  }
	          }
            $("#driverList").html(html1);

            }
        });
    }
//    loadMap(custName, tripStatus);
	loadVehicleStatusList(custName, "available");

<!--    function plotSingleVehicle(vehicleNo, latitude, longtitude, location, driverName,tripStatus) {-->
<!--        var tempContent='';-->
<!--        var humidityContent='';-->
<!--        var Humidity;-->
<!--        var imageurl = '/ApplicationImages/VehicleImages/delivery-van-blue.png';-->
<!--        if(tripStatus == "availableLess")-->
<!--        {-->
<!--          imageurl = '/ApplicationImages/VehicleImages/delivery-van-black.png';-->
<!--        }-->
<!--        if(tripStatus == "availableGreater")-->
<!--        {-->
<!--          imageurl = '/ApplicationImages/VehicleImages/delivery-van-grey.png';-->
<!--        }-->
<!---->
<!--        image = {-->
<!--            url: imageurl, // This marker is 20 pixels wide by 32 pixels tall.-->
<!--            scaledSize: new google.maps.Size(40, 40), // The origin for this image is 0,0.-->
<!--            origin: new google.maps.Point(0, 0), // The anchor for this image is the base of the flagpole at 0,32.-->
<!--            anchor: new google.maps.Point(0, 32),-->
<!--            labelOrigin: new google.maps.Point(16, 0)-->
<!--        };-->
<!--        var pos = new google.maps.LatLng(latitude, longtitude);-->
<!--        var marker = new google.maps.Marker({-->
<!--            position: pos,-->
<!--            map: map,-->
<!--            label: {-->
<!--               // text: temperature + " C",-->
<!--                color: '#37474F',-->
<!--                fontSize: "12px",-->
<!--                fontWeight: "bold"-->
<!--            },-->
<!--            icon: image-->
<!--        });-->
<!---->
<!---->
<!--        markerClusterArray.push(marker);-->
<!--        var coordinate=latitude+','+longtitude;-->
<!---->
<!---->
<!--        // alert(shipmentId);-->
<!--        var content = '<div id="myInfoDiv" class="blueGreyLight" seamless="seamless" scrolling="no" style="border: 1px solid #37474F;overflow:hidden; width:100%; height: 100%; float: left; color: #000; line-height:100%; font-size:11px; font-family: sans-serif;padding:4px;">' +-->
<!--            '<table class="infoDiv">' +-->
<!--            '<tr><td nowrap><b>Vehicle No:&nbsp;&nbsp;</b></td><td>' + vehicleNo + '</td></tr>' +-->
<!--            '<tr><td nowrap><b>Driver Name:&nbsp;&nbsp;</b></td><td>' + driverName + '</td></tr>' +-->
<!--            '<tr><td nowrap><b>Curr Location:&nbsp;&nbsp;</b></td><td>' + location + ' (HH.mm)</td></tr>' +-->
<!--            '</table>' +-->
<!--            '</div>';-->
<!---->
<!---->
<!--        infowindow = new google.maps.InfoWindow({-->
<!--            content: content,-->
<!--            marker: marker,-->
<!--            maxWidth: 300,-->
<!--            id: vehicleNo-->
<!--        });-->
<!---->
<!---->
<!--        google.maps.event.addListener(marker, 'click', (function(marker, contents, infowindow) {-->
<!--            return function() {-->
<!--                firstLoadDetails = 1;-->
<!--                info = false;-->
<!--                var imageurl = '/ApplicationImages/VehicleImages/delivery-van-blue.png';-->
<!---->
<!--                if(tripStatus == "availableLess")-->
<!--                {-->
<!--                  imageurl = '/ApplicationImages/VehicleImages/delivery-van-black.png';-->
<!--                }-->
<!--                if(tripStatus == "availableGreater")-->
<!--                {-->
<!--                  imageurl = '/ApplicationImages/VehicleImages/delivery-van-grey.png';-->
<!--                }-->
<!--                image = {-->
<!--                    url: imageurl, // This marker is 20 pixels wide by 32 pixels tall.-->
<!--                    scaledSize: new google.maps.Size(40, 40), // The origin for this image is 0,0.-->
<!--                    origin: new google.maps.Point(0, 0), // The anchor for this image is the base of the flagpole at 0,32.-->
<!--                    anchor: new google.maps.Point(0, 32)-->
<!--                };-->
<!--                marker.setIcon(image)-->
<!--                infowindow.setContent(content);-->
<!--                infowindow.open(map, marker);-->
<!--            };-->
<!--        })(marker, content, infowindow));-->
<!---->
<!---->
<!--        google.maps.event.addListener(marker, 'mouseout', (function(marker, contents, infowindow) {-->
<!--            return function() {-->
<!--                if(info){-->
<!--                  info = false;-->
<!--                infowindow.close();}-->
<!--            };-->
<!--        })(marker, content, infowindow));-->
<!---->
<!--        google.maps.event.addListener(infowindow, 'closeclick', function() {-->
<!--          var imageurl = '/ApplicationImages/VehicleImages/delivery-van-blue.png';-->
<!---->
<!--          if(tripStatus == "availableLess")-->
<!--          {-->
<!--            imageurl = '/ApplicationImages/VehicleImages/delivery-van-black.png';-->
<!--          }-->
<!--          if(tripStatus == "availableGreater")-->
<!--          {-->
<!--            imageurl = '/ApplicationImages/VehicleImages/delivery-van-grey.png';-->
<!--          }-->
<!--          image = {-->
<!--              url: imageurl, // This marker is 20 pixels wide by 32 pixels tall.-->
<!--              scaledSize: new google.maps.Size(40, 40), // The origin for this image is 0,0.-->
<!--              origin: new google.maps.Point(0, 0), // The anchor for this image is the base of the flagpole at 0,32.-->
<!--              anchor: new google.maps.Point(0, 32)-->
<!--          };-->
<!--          marker.setIcon(image)-->
<!--        });-->
<!---->
<!---->
<!--        if (animate == "true") {-->
<!--            marker.setAnimation(google.maps.Animation.DROP);-->
<!--        }-->
<!--        if (location != 'No GPS Device Connected') {-->
<!--            bounds.extend(pos);-->
<!--        }-->
<!---->
<!--    }-->

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
//         loadMap(custName,  tripStatus);
         loadTable(custName, routeId, tripStatus);
    }

    setInterval(function() {
//        loadMap(custName, tripStatus);
		loadVehicleStatusList(custName, "available");
        refreshNumbers();
        $("#driverListHeader").html("Available");
        //loadData(custName, routeId);
        //loadTable(custName, routeId, tripStatus);
    }, 180000);//300000


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

function closeTrip()
{
  // variable closeJSON has the final JSON
<!--  if(document.getElementById("remarks").value == ""){-->
<!--  	sweetAlert("Please enter remarks");-->
<!--  	return;-->
<!--  }-->
  closeJSON.responseBody.remarks = document.getElementById("remarks").value;
  var jsonToUpdate = closeJSON.responseBody;
  var param = {
  	remarks : document.getElementById("remarks").value,
  	tripId : closeJSON.responseBody.tripId,
    desTripDetails : JSON.stringify(closeJSON.responseBody.desTripDetails)
  }
  	$.ajax({
	        url: '<%=request.getContextPath()%>/GeneralVerticalDashboardAction.do?param=closeTrip',
	        data: param,
	        type: 'POST',
	       // beforeSend: function (xhr) {
   			//	 xhr.setRequestHeader ("Authorization", "Basic " + btoa('<%=serviceUserName%>' + ":" + '<%=servicePassword%>'));
			//	},
		//type: 'POST',
	        success: function(result) {
	        	if (result == "success") {
               		setTimeout(function(){
		               	 sweetAlert("Trip Closed");
		               	 document.getElementById("remarks").value = "";
		               	 $('#createTripModal').modal('hide');
		               	 $('#acknowledgeTripModal').modal('hide');
                    	refreshNumbers();
               		}, 1000);

                 } else {
                     sweetAlert(result.message);
                 }
	        }
		});

}
function modifyTrip(){
  if(scanJSONCreate.length == 0){
    sweetAlert("No Order Scans! Please check again!");
    return;
  }
  
  if (($('#region option:selected').attr("value") == 0) || ($('#region option:selected').attr("value") === undefined)){
	   sweetAlert("Select Region");
		return;
  }
	var trackTripDetailsSub ={
	    loadingPartner : $('#loadingPartner option:selected').text()
	    };
	var paramboot = {
		tripId : tripId,
		assetNumber : $('#driverName option:selected').attr("value"),
		customerId : <%=customerId%>,
		//tripCustomerId :0,
		//customerName : $('#addcustNameDownID option:selected').text(),
		//customerRefId : custReference,
		insertedBy : <%=userId%>,
		productLine : 'Dry',
		//routeName : routeName,
		systemId : <%=systemId%>,
		desTripDetails : JSON.stringify(deliveryPointsArray),
		trackTripDetailsSub : JSON.stringify(trackTripDetailsSub),
		tripDestination : $('#region option:selected').attr("value")

	}
    $.ajax({
        url : '<%=request.getContextPath()%>/GeneralVerticalDashboardAction.do?param=modifyTrip',
        data: paramboot,
        type: 'POST',
		//beforeSend: function (xhr) {
   		//		 xhr.setRequestHeader ("Authorization", "Basic " + btoa('<%=serviceUserName%>' + ":" + '<%=servicePassword%>'));
		//		},
		//type: 'POST',
        success: function(result) {
        	if (result == "success") {
               		setTimeout(function(){
		               	sweetAlert("Trip modified");
                    $('#createTripModal').modal('hide');
                    $('#acknowledgeTripModal').modal('hide');
                    refreshNumbers();
               		}, 1000);

                 } else {
                     sweetAlert(result);
                     deliveryPointsArray.splice(0,1);//remove source hub details
                 }
        }
	});
}
function saveTrip(){
  if(scanJSONCreate.length == 0){
    sweetAlert("No Order Scans! Please check again!");
    return;
  }
  
  if (($('#region option:selected').attr("value") == 0) || ($('#region option:selected').attr("value") === undefined)){
	   sweetAlert("Select Region");
		return;
  }
  
	var sourceHubDetails = {};
	    sourceHubDetails.hubId = $('#source option:selected').attr("value");
	    sourceHubDetails.name = $('#source option:selected').text();
	    sourceHubDetails.latitude =   $('#source option:selected').attr("latitude");
	    sourceHubDetails.longitude =   $('#source option:selected').attr("longitude");
	    sourceHubDetails.detention = $('#source option:selected').attr("detention");
	    sourceHubDetails.radius = $('#source option:selected').attr("radius");
	    deliveryPointsArray.unshift(sourceHubDetails);

	var trackTripDetailsSub ={
		    loadingPartner : $('#loadingPartner option:selected').text(),
		    driverId : $('#driverName option:selected').attr("driverId"),
			driverName : $('#driverName option:selected').text(),
			driverContact : $('#driverName option:selected').attr("driverContact")
	    };
		
	
	var paramboot = {
		assetNumber : $('#driverName option:selected').attr("value"),
		customerId : <%=customerId%>,
		insertedBy : <%=userId%>,
		productLine : 'Dry',
		systemId : <%=systemId%>,
		desTripDetails : JSON.stringify(deliveryPointsArray),
		trackTripDetailsSub : JSON.stringify(trackTripDetailsSub),
		tripDestination : $('#region option:selected').attr("value")

	}
   document.getElementById("saveTrip").disabled=true;
    $.ajax({
        url : '<%=request.getContextPath()%>/GeneralVerticalDashboardAction.do?param=saveTrip',
        data: paramboot,
		type: 'POST',
        success: function(result) {
        	if (result == "success") {
               		setTimeout(function(){
		               	sweetAlert("Trip saved");
                    $('#createTripModal').modal('hide');
                    $('#acknowledgeTripModal').modal('hide');
                    refreshNumbers();
               		}, 1000);

                 } else {
                     sweetAlert(result);
                     deliveryPointsArray.splice(0,1);//remove source hub details
                    document.getElementById("saveTrip").disabled=false;
                 }
        }
	});
}

function saveCustCollection()
{
	var data = tableCustColl.rows().data();
	var deliveryPointsArrayCustColl = [];
	var isCustomerSelected = true;
	var isMobileNoCorrect = true;
	if(data.length == 0){
		sweetAlert("No orders to save");
	}
	 let selId = "";
	 data.each(function (value, index) {
		 let orderNo = value[8];
		  selId = value[14];
		 let tripCustomerId = $('#custName'+selId+' option:selected').attr("value");
		 if(tripCustomerId == 0){
			 isCustomerSelected= false;
			 $("#select2-custName"+selId+"-container").parent().css("border-color","red");
			 return;			 
		 }else{
			 $("#select2-custName"+selId+"-container").parent().css("border-color","black");
		 }
		 
		 if (($("#mobileNo"+selId).val() != undefined) && ($("#mobileNo"+selId).val() != "") && ($("#mobileNo"+selId).val().length < 10)){
			 sweetAlert("Enter 10 Digit Mobile No for Scan id "+ value[1]);
				isMobileNoCorrect = false;
		    	return;
				
		 }
		 
		  var node = {
              scanId: value[1] ,
              orderNo: orderNo,
              deliveryTicketNo:value[9],
              deliveryNoteNo:value[10],
              tripCustomerId: $('#custName'+selId+' option:selected').attr("value"),
              tripCustomerName: $('#custName'+selId+' option:selected').text(),
			  collectionOrderLoadPartner : $('#loadPartner'+selId+' option:selected').attr("value"),
			  collectedBy :  $("#collectedBy"+selId).val(),
              mobileNumber : $("#mobileNo"+selId).val(),
			  vehicleNumber : $("#vehicleNo"+selId).val(),
			  remarks : $("#remarks"+selId).val(),
              scannedBy: '<%=username%>'
            }
			var deliveryPointData ={
				hubId : 'NA',
				latitude : 'NA',
				longitude : 'NA',
				radius : 'NA',
				detentionTime : 'NA' ,
				name :  'NA',
				tripOrderDetails : node
			}
			deliveryPointsArrayCustColl.push(deliveryPointData);
			
			 
			
	 });
	 
	 
	 if(isCustomerSelected == false){
		sweetAlert("Choose Customer");
		
		return;
	 }
	
	 if(isMobileNoCorrect == false){
			
		return;
	 }
		var sourceHubDetails = {};
	    sourceHubDetails.hubId = $('#source option:selected').attr("value");
	    sourceHubDetails.name = $('#source option:selected').text();
	    sourceHubDetails.latitude =   $('#source option:selected').attr("latitude");
	    sourceHubDetails.longitude =   $('#source option:selected').attr("longitude");
	    sourceHubDetails.detention = $('#source option:selected').attr("detention");
	    sourceHubDetails.radius = $('#source option:selected').attr("radius");
	    deliveryPointsArrayCustColl.unshift(sourceHubDetails);

	var trackTripDetailsSub ={
	    loadingPartner : $('#loadingPartner option:selected').text()
	    };
		
	 
		
	var paramboot = {
		assetNumber : 'NA',
		customerId : <%=customerId%>,
		insertedBy : <%=userId%>,
		productLine : 'Dry',
		systemId : <%=systemId%>,
		desTripDetails : JSON.stringify(deliveryPointsArrayCustColl),
		trackTripDetailsSub : JSON.stringify(trackTripDetailsSub),
		tripType : 'COLLECTIONS',
		tripDestination : 0
		 
	}
    $.ajax({
        url : '<%=request.getContextPath()%>/GeneralVerticalDashboardAction.do?param=saveTrip',
        data: paramboot,
		type: 'POST',
        success: function(result) {
			
        	if (result == "success") {
					idSelected = 1;
	               	sweetAlert("Collection Orders saved");
					$('#scanTableCustColl').DataTable().rows().remove().draw();
                 } else {
                     sweetAlert(result);
                 }
        }
	});
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
				sweetAlert(responseText);
				//window.location="<%=request.getContextPath()%>/LegDetailsExport?relativePath="+responseText;
				window.open("<%=request.getContextPath()%>/LegDetailsExport?relativePath="+responseText);
			}
		});
	});

		$("#totalAvailable").on("click", function(){ loadVehicleStatusList("2", "available");   $("#driverListHeader").html("Available");});
		$("#tripAssigned").on("click", function(){ loadVehicleStatusList("2", "tripAssigned"); $("#driverListHeader").html("Trip Assigned");});
		$("#onTrip").on("click", function(){ loadVehicleStatusList("2", "onTrip"); $("#driverListHeader").html("On-Trip");});
		$("#atBorder").on("click", function(){ loadVehicleStatusList("2", "atBorder"); $("#driverListHeader").html("At Border");});
		$("#stopped").on("click", function(){ loadVehicleStatusList("2", "stopped"); $("#driverListHeader").html("Stopped");});




	 $('#scanAck').on("propertychange change click keyup input paste", function(e) {
	// alert("inside ack");
      if($("#scanAck").val().trim().length == 0)
      {
        return;
      }
      var fullscanValue = $("#scanAck").val().trim();
      var scanValue = $("#scanAck").val().trim();
      scanValue = scanValue.split(' ').join('');
      scanValue = scanValue.split('-').join('');
	//alert("scanValue " + scanValue);
      if(scanValue.length >36){
        sweetAlert("Invalid Scan Id");
        $("#scanAck").val("");
        return;
      }

      if (scanValue.length ==36){

      	var splittedArr = [];
      	tempScanId=tempScanId.replace("'",'');

      	splittedArr = tempScanId.split(',');

      	for(i=0; i < splittedArr.length; i++){
       		splittedArr[i]=splittedArr[i].replace("'","");
      	 		if(fullscanValue == splittedArr[i]){
      	 			$("#scanAck").val("");
      	 			sweetAlert("Already Scanned!");
      	 			return;
      	 		}
      	}
      	tempScanId = tempScanId+",'"+$("#scanAck").val()+"'";
      	newScanId = newScanId+",'"+$("#scanAck").val()+"'";

      	var result = ackJSONTable;
      //	alert("result :: " + result);
      	/*
      	 var result = ackJSONTable;//scanJSONCreate;
      	let today = new Date();
            let dd = today.getDate();

            let mm = today.getMonth()+1;
            const yyyy = today.getFullYear();
            let hh = today.getHours();
            let min = today.getMinutes();

            today = dd + "/" + mm + "/" + yyyy + " " + hh + ":" + min;

            var node = {
              ackDate: today
            }
			var deliveryPointData ={
				tripOrderDetails : node
			}
           // ackJSONTable.push(node);
          //deliveryPointsArray.push(deliveryPointData);
      	*/




          loadScanTableForAckClose();
          $("#scanAck").val("");
            scanValue =  $("#scanAck").val().trim();

            $("#scanAck").val("");
        //}
      }
    });

function acknowledgeTrip()
    {
     $('#ackTable').DataTable().clear().destroy();
     $('#driverAckName').empty().select2();
      		$.ajax({
	        url: '<%=request.getContextPath()%>/GeneralVerticalDashboardAction.do?param=getAllDrivers',
	        data: {
	        	//status : status
	        },
	        success: function(result) {
	            vehicleList = JSON.parse(result);
				$('#driverAckName').append($("<option></option>").attr("value", 0).text("--Pick Driver--"));
	            for (var i = 0; i < vehicleList["driversRoot"].length; i++) {
                    $('#driverAckName').append($("<option></option>").attr("value", vehicleList["driversRoot"][i].vehicleNo).attr("driverContact", vehicleList["driversRoot"][i].driverContact)
                    .attr("driverId", vehicleList["driversRoot"][i].driverId).text(vehicleList["driversRoot"][i].driverName));
	            }
	            $('#driverAckName').select2({
	    			dropdownParent: $("#acknowledgeTripModal")
				});
          		//$("#driverName1").val($("#driverDropDownId1").val()).trigger('change');
	        }
	    });
      closeJSONTable = [];
      $("#saveTrip").addClass("dispNone");
      $("#modifyTrip").addClass("dispNone");
      $("#cancelTrip").addClass("dispNone");
      $("#remarksDiv").removeClass("dispNone");
      $("#nameDiv").addClass("dispNone");
      $("#locationDiv").addClass("dispNone");
      $("#closeTrip").removeClass("dispNone");
      $('#createTripModal').modal('hide');
      $('#acknowledgeTripModal').modal('show');
	  $("#createTitle").html("ACKNOWLEDGE TRIP");
   	  //getTripDetails();
	  //loadAckModalDriver();
	  $("#scanAck").val("");
	}

	$('#driverAckName').change(function() {
		ackJSONTable=[];
		assetNumber = $('#driverAckName option:selected').attr("value")
		$.ajax({
	        url: '<%=request.getContextPath()%>/GeneralVerticalDashboardAction.do?param=getOrderDetailsForAcknowledge',
	        data: {
	        	assetNumber:assetNumber
	        },
	        success: function(result) {
	        var ackDate = "";
	        $('#ackTable').DataTable().clear().destroy();
 			//var result = scanJSONCreate;
            let rows = [];
            var results=JSON.parse(result).orderDetailsRoot;
            lengthOfRec = results.length;

                $.each(results, function(i, item) {
                if(item.scanId != undefined)
                {
                //alert("item.deliveryStatus ;; " + item.deliveryStatus);

                 var selectedyes =( item.deliveryStatus == "Y") ? 'selected' : '';
                  var selectedno = ( item.deliveryStatus == "N") ? 'selected' : ''

                   let row = {
                         "0":item.slNoIndex,
                         "1":item.scanId,
                         "2":item.orderNo,
                         "3":item.deliveryTicketNo,
                         "4":item.deliveryNoteNo,
                         "5":item.tripCustomerName,
                         "6":item.customerLoc,
                         "7":item.ackDate !=null? item.ackDate : "",
                         //"8":item.deliveryStatus,
                         //"8":'<select id="'+item.scanId+'" style="color:black !important;" onchange="yes(\''+item.scanId+'\',value)"><option value="N"'+ selectedno +'>N</option><option value ="Y" '+ selectedyes +'>Y</option></select>'
                         "8":'<select id="'+item.scanId+'" style="color:black !important;" onchange="yes(\''+item.scanId+'\',value)"><option value ="Y" '+ selectedyes +'>Y</option><option value="N"'+ selectedno +'>N</option></select>'

                    }

                    var node={
                    scanId:item.scanId,
                    orderNo:item.orderNo,
                    deliveryTicketNo:item.deliveryTicketNo,
                    deliveryNoteNo:item.deliveryNoteNo,
                    tripCustomerName:item.tripCustomerName,
                    customerLoc:item.customerLoc,
                    //ackDate:item.ackDate
                    ackDate:ackDate,
                    deliveryStatus:'<select id="'+item.scanId+'" style="color:black !important;" onchange="yes(\''+item.scanId+'\',value)"><option value ="Y" '+ selectedyes +'>Y</option><option value="N"'+ selectedno +'>N</option></select>' //onchange="yes(\''+item.scanId+'\',value)"><option value="N"'+ selectedno +'>N</option><option value ="Y" '+ selectedyes +'>Y</option></select>'
                    }
                    rows.push(row);
                    ackJSONTable.push(node);
                    }
                  })

                  if ($.fn.DataTable.isDataTable("#ackTable")) {
                    $('#ackTable').DataTable().clear().destroy();
                  }
                  table = $('#ackTable').DataTable({
                    "scrollY": "300px",
                    "scrollX": true,
                    paging : false,
                    "searching": false,
                    "oLanguage": {
                        "sEmptyTable": "No data available"
                    }
                  });
                  table.rows.add(rows).draw();
	        }
	    });



});
     var scannedOrdersArray = [];
     function loadScanTableForAckClose(){

               var result = ackJSONTable;

//alert("result :::::**** " + result)

               let rows = [];
               let rowHighlight = [];
             //  alert("sasas" + $("#scanAck").val());

                $.each(result, function(i, item) {

            let today = new Date();
            let dd = today.getDate();

            let mm = today.getMonth()+1;
            const yyyy = today.getFullYear();
            let hh = today.getHours();
            let min = today.getMinutes();
            let sec = today.getSeconds();

            //today = dd + "/" + mm + "/" + yyyy + " " + hh + ":" + min + ":" + sec;

			let formattedDay = ( '0' + dd ).substr( -2 );
			let formattedMonth = ( '0' + mm ).substr( -2 );
			let formattedHour = ( '0' + hh ).substr( -2 );
			let formattedMin = ( '0' + min ).substr( -2 );
			let formattedSec = ( '0' + sec ).substr( -2 );
			today = formattedDay + "/" + formattedMonth + "/" + yyyy + " " + formattedHour + ":" + formattedMin + ":" + formattedSec;

                var scannedDate = "";
                  if($("#scanAck").val() == item.scanId) {
                  var scannedOrder = {"scanId":item.scanId,"status":$("#"+item.scanId).val()};
                  	 scannedOrdersArray.push(scannedOrder);
                  	item.ackDate = today;
                  }
                  let currentSelectValue = $("#"+item.scanId).val();
                       var selectedyes = ''
                   currentSelectValue == "Y" ? selectedyes = 'selected' : ''
                   var selectedno = ''
                   currentSelectValue == "N" ? selectedno = 'selected' : ''

                   let row = {
                        "0":i+1,
                        "1":item.scanId,
                        "2":item.orderNo,
                        "3":item.deliveryTicketNo,
                        "4":item.deliveryNoteNo,
                        "5":item.tripCustomerName,
                        "6":item.customerLoc,
                        "7":item.ackDate !=null? item.ackDate : "", //ackDate
                        "8":'<select id="'+item.scanId+'" style="color:black !important;" onchange="yes(\''+item.scanId+'\',value)"><option value="N" '+ selectedno +'>N</option><option value ="Y" '+ selectedyes +'>Y</option></select>'

                    }

                    rows.push(row);
                  })

                  var tempRows = [];
                  for(var x=0;x < rows.length ; x++)
                  {

                    if(rows[x][1]  == $("#scanAck").val()){
                      tempRows.unshift(rows[x]);
                    }
                    else{
                      tempRows.push(rows[x]);
                    }
                  }
                  rows = tempRows;

                  for(var x=0;x < rows.length ; x++)
                  {
                    if(rows[x][1]  == $("#scanAck").val()){
                      rowHighlight.push(x);
                    }
                  }

                  if ($.fn.DataTable.isDataTable("#ackTable")) {
                    $('#ackTable').DataTable().clear().destroy();
                  };
                  table = $('#ackTable').DataTable({
                    "scrollY": "300px",
                    "scrollX": true,
                    paging : false,
                    "searching": false,
                    "oLanguage": {
                        "sEmptyTable": "No data available"
                    }
                  });
                  table.rows.add(rows).draw();
                  table.rows( rowHighlight )
                      .nodes()
                      .to$()
                      .addClass( 'highlight' );
    }

  	var  wordsWithQuotes = [];

	function acknowledgeOrders() {

     // alert("newScanId " + newScanId);

      wordsWithQuotes = newScanId.split(',');
      var counts = wordsWithQuotes.length-1;

      //$('#ackTable').rows().every(function(){ console.log(this.data()); });
    //  console.log($('#ackTable').data().toArray());

      var table = $('#ackTable').DataTable().rows().data();

	table.rows().every( function ( rowIdx, tableLoop, rowLoop ) {
	 var data = this.data();
	 console.log("data :: " + JSON.stringify(data));
	 });
	 var scanStatus = '';
	 var remarkReqd = false;
     for (var j=0;j<scannedOrdersArray.length;j++){
      var scannedId = scannedOrdersArray[j].scanId;
       scanStatus = $('#'+scannedId).val();
        if(scanStatus == "N") {
         remarkReqd = true;
        }
    //  console.log("scannedId :: "+scannedId);
    //  console.log("scanStatus :: "+scanStatus);
      scannedOrdersArray[j].status = scanStatus;
     }
        if(remarkReqd) {
        	if(document.getElementById("remarksForAck").value.length == 0){
        		sweetAlert("Please Enter Remarks");
        		return;
        	}
        }
     var scannedCounts = scannedOrdersArray.length;
     // console.log("scannedOrdersArray :: "+JSON.stringify(scannedOrdersArray));
      var gridData = JSON.stringify(scannedOrdersArray);
      if(newScanId.length >= 1) {
      $.ajax({
	        url: '<%=request.getContextPath()%>/GeneralVerticalDashboardAction.do?param=saveAcknowlegdedOrders',
	        data: {
	        	newScanId : newScanId,
	        	gridData : gridData,
	        	remarksForAck : document.getElementById("remarksForAck").value
	        },
	         success: function(result) {
	        	if (result == "Orders Acknowledged") {
	        	    var resultNew = "Orders Acknowledged " + lengthOfRec;
	        	//    console.log("result New :::: " + resultNew + "counts " + counts);
               		setTimeout(function(){
		               	 sweetAlert(scannedCounts + " Out Of " + lengthOfRec + " Orders Acknowledged!");
		               	// $('#createTripModal').modal('hide');
		               	// $('#acknowledgeTripModal').modal('show');
		                 $('#ackTable').DataTable().clear().destroy();
		               	 $('#driverAckName').empty().select2();
		               	 acknowledgeTrip();
		               	 newScanId = '';
		               	 tempScanId = '';
		               	 document.getElementById("remarksForAck").value = '';
		               	 scannedOrdersArray = [];
               		}, 1000);

                 } else {
                     sweetAlert(result);
                     acknowledgeTrip();
                     $('#ackTable').DataTable().clear().destroy();
     				 $('#driverAckName').empty().select2();
     				 newScanId = '';
     				 tempScanId = '';
     				 document.getElementById("remarksForAck").value = '';
     				 scannedOrdersArray = [];
                 }
	        }

	    });
	   }
	   else {
	   	//alert(":: :: " + $('#driverAckName option:selected').attr("value"));
			if($('#driverAckName option:selected').attr("value") == 0){
				sweetAlert("Please Select Driver");
			}else {
	   			sweetAlert("Please Scan atleast one order!");
	   		}
	   }
	}

	$('#scanTableCustColl').unbind().on('click', 'td', function(event) {
		var table = $('#scanTableCustColl').DataTable();
		var columnIndex = table.cell(this).index().column;
		if(columnIndex == 13){
			$('#scanTableCustColl').DataTable().row( this ).remove().draw();
		}
	});

	function manualTripStart(){
			
		   $.ajax({
                url: '<%=request.getContextPath()%>/GeneralVerticalDashboardAction.do?param=getTripDetailById',
                data :{
                	systemId : <%=systemId%>,
                	customerId : <%=customerId%>,
                	tripId : $('#driverDropDownId option:selected').attr('tripId')

                },
                type : 'GET',
                contentType: "application/json",
                success: function(response) {
					var resp =  JSON.parse(response);
                $('#tripInsertedTime').val(resp.responseBody.insertedDate);
				console.log("closeJSON :: "+resp.responseBody.tripId + "------" + resp.responseBody.insertedDate);
				}
                 
            })
		 
		
		$('#manualTripStartModal').modal('show');
		$(".modal-backdrop").css("z-index","99999");
		$('#tripInsertedTime').val(closeJSON.responseBody.insertedDate);
		$("#atdDateTimeInput").jqxDateTimeInput({ theme: "arctic", formatString: "dd/MM/yyyy HH:mm",  showTimeButton: true, width: '200px', height: '25px' });
		$('#atdDateTimeInput').jqxDateTimeInput('setDate', new Date());
		
	}
	
	function closeManualTripModal(){
		$('#manualTripStartModal').modal('hide');
		$(".modal-backdrop").css("z-index","1040");
		$('#tripInsertedTime').val("");
		$('#atdDateTimeInput').val("");
	}
	
	function dateValidation(date1, date2) {
		var d1 = date1.split("/");
		var d2 = date2.split("/");
		var d3 = new Date();
		var fromDate = new Date(d1[1] + "/" + d1[0] + "/" + d1[2]);
		var inputDate = new Date(d2[1] + "/" + d2[0] + "/" + d2[2]);
		//var maxDate = new 
		if (fromDate >= inputDate) {
			return true;
		} else {
			return false;
		}
	}
	
	function saveManualTripStart(){
		
		$('#btnManualTripStart').prop('disabled', true);
		 		
		var inRange = false;
		var insertedDate = getDateObject($('#tripInsertedTime').val()+":00");
		var inputDate = getDateObject($('#atdDateTimeInput').val()+":00");
		var maxDate = new Date();
		
		if (insertedDate < inputDate && inputDate < maxDate) {
			inRange = true;
		}
		if(inRange){
			var params = {
				tripId : $('#driverDropDownId option:selected').attr('tripId'),
				actualTripStartTime : getDateString($('#atdDateTimeInput').val()+":00")
			}
			console.log("params :: "+params);
		 $.ajax({
	        url: '<%=request.getContextPath()%>/GeneralVerticalDashboardAction.do?param=manualTripStart',
	        data: params,
	         success: function(result) {
	        	sweetAlert(result);
				$('#btnManualTripStart').prop('disabled', false);
				closeManualTripModal();
				$('#createTripModal').modal('hide');
				refreshNumbers();
	        }

	    });
		}else{
			sweetAlert("ATD must be within Inserted Time and Current time");
			$('#btnManualTripStart').prop('disabled', false);
		}
	}
	
	function getDateObject(datestr) {
		var parts = datestr.split(' ');
		var dateparts = parts[0].split('/');
		var day = dateparts[0];
		var month = parseInt(dateparts[1]) - 1;
		var year = dateparts[2];
		var timeparts = parts[1].split(':')
		var hh = timeparts[0];
		var mm = timeparts[1];
		var ss = timeparts[2];
		var date = new Date(year, month, day, hh, mm, ss, 00);
		return date;
	}
	
	function getDateString(datestr) {
		var parts = datestr.split(' ');
		var dateparts = parts[0].split('/');
		var day = dateparts[0];
		var month = parseInt(dateparts[1]);
		var year = dateparts[2];
		var timeparts = parts[1].split(':')
		var hh = timeparts[0];
		var mm = timeparts[1];
		var ss = timeparts[2];
		var datestring = year+"-"+month+"-"+day+" "+hh+":"+mm+":"+ss;
		return datestring;
	}
	
	$(document).on("change","#approxTripStartTime", function(e){
		 	if($('#driverName option:selected').attr("value") == 0){
					sweetAlert("Please Select Driver");
					return;
			}
			getHubDepartures();
	});
	
	
	function btnMissedTripManagent(){
		   $("#region").hide();
		$("#approxTripStartTime").jqxDateTimeInput({ theme: "arctic", formatString: "dd/MM/yyyy HH:mm",  showTimeButton: true, width: '200px', height: '25px' });
		//$('#approxTripStartTime').jqxDateTimeInput('setDate', '');
		
		$("#tripStartTimeInput").jqxDateTimeInput({ theme: "arctic", formatString: "dd/MM/yyyy HH:mm",  showTimeButton: true, width: '200px', height: '25px',disabled: true });
		$('#tripStartTimeInput').jqxDateTimeInput('setDate', '');
		
     
      $("#customerLocation").val("0").trigger('change');
      $("#customerName").val("0").trigger('change');
      $("#loadingPartner").val("0").trigger('change');

      $("#remarksDiv").addClass("dispNone");
      $("#removeDelivery").html("Remove");
      tripType = "open";
      $("#nameDiv").removeClass("dispNone");
      $("#locationDiv").removeClass("dispNone");
      $("#closeTrip").addClass("dispNone");
      $("#cancelTrip").addClass("dispNone");
      $("#saveMTMTrip").removeClass("dispNone");
      $("#modifyTrip").addClass("dispNone");
      $("#createTitle").html("MISSED TRIP MANAGEMENT");
      $('#createTripModal').modal('show');
	  $('#manualTripStart').addClass("dispNone");
      $('#acknowledgeTripModal').modal('hide');
	  $("#mtmDiv").removeClass("dispNone");
	  $("#saveTrip").addClass("dispNone");
	  document.getElementById("saveMTMTrip").disabled=false;
      scanJSONCreate = [];
      deliveryPointsArray = [];
      setTimeout(function() {
			loadScanTableCreate();
      }, 500);
  	  scanJSONClose = [];
  	  deliveryPointsArray = [];
  		getAllDrivers();
  		clearModalFields();
		
	}
	
	function getHubDepartures(){
		 $('#possibleTripStartTime').empty().select2();
		 var approxTripDate = $('#approxTripStartTime').val()+":00";
		 var paramData = {
			 approxTripDate : approxTripDate,
			 assetNumber : $('#driverName option:selected').attr("value"),
			 hubId : $('#source option:selected').attr("value")
		 }
		 $.ajax({
	        url: '<%=request.getContextPath()%>/GeneralVerticalDashboardAction.do?param=getHubDepartures',
	        data: paramData,
	         success: function(result) {
				data =  JSON.parse(result);
	        	console.log(data.vehicleDetailsRoot);
				$('#possibleTripStartTime').append($("<option></option>").attr("value", 11111111).text("--Select--"));
	            for (var i = 0; i < data["vehicleDetailsRoot"].length; i++) {
                    $('#possibleTripStartTime').append($("<option></option>").attr("value", i).text(data["vehicleDetailsRoot"][i]));
	            }
				$('#possibleTripStartTime').append($("<option></option>").attr("value", 99999999).text("--Others--"));
				$('#possibleTripStartTime').select2({
	    			dropdownParent: $("#createTripModal")
				});
	        }
	    });
	}
	 
	 $("#possibleTripStartTime").change(function() {
		if (parseInt($('#possibleTripStartTime').val()) === 99999999){
			$('#tripStartTimeInput').jqxDateTimeInput({disabled: false});
			$('#tripStartTimeInput').jqxDateTimeInput('setDate', '');
		}else if (parseInt($('#possibleTripStartTime').val()) === 11111111){
			$('#tripStartTimeInput').jqxDateTimeInput({disabled: true});
			$('#tripStartTimeInput').jqxDateTimeInput('setDate', '');
		}else{
			$('#tripStartTimeInput').jqxDateTimeInput({disabled: true});
			$('#tripStartTimeInput').jqxDateTimeInput('setDate', new Date(getDateString($('#possibleTripStartTime option:selected').text())));
		}
	})
	 
	function getAllDrivers(){
		      $('#driverName').empty().select2();
      		$.ajax({
	        url: '<%=request.getContextPath()%>/GeneralVerticalDashboardAction.do?param=getAllDrivers',
	        data: {
	        	//status : status
	        },
	        success: function(result) {
	        	console.log(result);
	            vehicleList = JSON.parse(result);
				$('#driverName').append($("<option></option>").attr("value", 0).text("--Pick Driver--"));
	            for (var i = 0; i < vehicleList["driversRoot"].length; i++) {
                    $('#driverName').append($("<option></option>").attr("value", vehicleList["driversRoot"][i].vehicleNo).attr("driverContact", vehicleList["driversRoot"][i].driverContact)
                    .attr("driverId", vehicleList["driversRoot"][i].driverId).text(vehicleList["driversRoot"][i].driverName));
	            }
	            $('#driverName').select2({
	    			dropdownParent: $("#createTripModal"),width: '1px'
				});
          		$("#driverName").val(0).trigger('change');
	        }
	    });
	 }
	 
	function saveMTMTrip(){
		
		if (parseInt($('#possibleTripStartTime').val()) === 11111111){
				sweetAlert("Select a Possible Trip Start Time");
				return;
		}	
	
		if ($('#tripStartTimeInput').val() === ''){
			sweetAlert("There must be a trip start time ");
			return;
		}
		if(scanJSONCreate.length == 0){
			sweetAlert("No Order Scans! Please check again!");
			return;
		}
		var sourceHubDetails = {};
			sourceHubDetails.hubId = $('#source option:selected').attr("value");
			sourceHubDetails.name = $('#source option:selected').text();
			sourceHubDetails.latitude =   $('#source option:selected').attr("latitude");
			sourceHubDetails.longitude =   $('#source option:selected').attr("longitude");
			sourceHubDetails.detention = $('#source option:selected').attr("detention");
			sourceHubDetails.radius = $('#source option:selected').attr("radius");
			deliveryPointsArray.unshift(sourceHubDetails);
		
		var mtmJSON = {
			tripStartTime : getDateString($('#tripStartTimeInput').val()+":00"),
			selectedType : $('#possibleTripStartTime').val()
		}

		var trackTripDetailsSub ={
			loadingPartner : $('#loadingPartner option:selected').text(),
	   		 driverId : $('#driverName option:selected').attr("driverId"),
	    		driverName : $('#driverName option:selected').text(),
			driverContact : $('#driverName option:selected').attr("driverContact")

	    };
		var paramboot = {
			assetNumber : $('#driverName option:selected').attr("value"),
			customerId : <%=customerId%>,
			insertedBy : <%=userId%>,
			productLine : 'Dry',
			systemId : <%=systemId%>,
			desTripDetails : JSON.stringify(deliveryPointsArray),
			trackTripDetailsSub : JSON.stringify(trackTripDetailsSub),
			mtmJSONData : JSON.stringify(mtmJSON),
			tripType : 'MTM',
			tripDestination : 0
		}
		console.log(JSON.stringify(paramboot));
		document.getElementById("saveMTMTrip").disabled=true;
		$.ajax({
			url : '<%=request.getContextPath()%>/GeneralVerticalDashboardAction.do?param=saveTrip',
			data: paramboot,
			type: 'POST',
			success: function(result) {
				if (result == "success") {
						setTimeout(function(){
							sweetAlert("Trip saved");
						$('#createTripModal').modal('hide');
						$('#acknowledgeTripModal').modal('hide');
						refreshNumbers();
						}, 1000);

					 } else {
						 sweetAlert(result);
						 deliveryPointsArray.splice(0,1);//remove source hub details
						document.getElementById("saveTrip").disabled=false;
					 }
			}
		});
	}


</script>
<style>
.jqx-popup, .jqx-popup-arctic, .jqx-fill-state-focus,.jqx-fill-state-focus-arctic{
	z-index:2000000 !important;
}

.jqx-fill-state-focus, .sweet-alert{
	z-index:2000000 !important;
}
</style>

  <jsp:include page="../Common/footer.jsp" />
