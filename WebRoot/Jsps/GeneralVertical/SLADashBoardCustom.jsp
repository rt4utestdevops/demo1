<%@ page  language="java" import="java.util.*,t4u.functions.*,t4u.beans.*,t4u.common.*" pageEncoding="utf-8"%>
<%@ taglib uri="http://packtag.sf.net" prefix="pack" %>
<%
	CommonFunctions cf = new CommonFunctions();
	GeneralVerticalFunctions gvf = new GeneralVerticalFunctions();

	LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
	int countryId = loginInfo.getCountryCode();
	int systemId = loginInfo.getSystemId();
	int loginUserId=loginInfo.getUserId();
	int clientId = loginInfo.getCustomerId();
	String countryName = cf.getCountryName(countryId);
	Properties properties = ApplicationListener.prop;
	String vehicleImagePath = properties.getProperty("vehicleImagePath");
	String GoogleApiKey = properties.getProperty("GoogleMapApiKeyen").trim();
	String userId=properties.getProperty("SLADashboardUserId");
//	String custName=properties.getProperty("custname");
	String custName= gvf.getUserAssociatedCustomer(loginUserId,systemId).replaceAll("'","");
	int custId= gvf.getUserAssociatedCustomerID(loginUserId,systemId);
	String unit = cf.getUnitOfMeasure(systemId);
	String latitudeLongitude = cf.getCoordinates(systemId);
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
      <script src="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.1/js/select2.min.js"></script>
      <link href="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.1/css/select2.min.css" rel="stylesheet" />

      <style>
			.navbar-brand { padding: 5px 0px 0px 0px !important;}
			.mr-auto, .mx-auto {
			margin-top: 8px !important;
			}
			.navbar{border-radius: 0px !important;}

        .form-control {
            display: block;
            width: 100%;
            height: 28px;
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
        .outer-count{
           text-align: center;
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
        #tripSumaryTable_filter{
            margin-top: -42px;
        }
        #tripSumaryTable_wrapper {
            border: solid 1px rgba(0, 0, 0, .25);
            padding: 1%;
            box-shadow: 0 1px 1px rgba(0, 0, 0, .25);
            width: 100.1%;
            overflow-x: scroll;
						margin-bottom:32px;
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
            border: none !important;
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
        }
        #viewBtn{
          float:right;
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
        .btn-group, .btn-group-vertical{
            margin-top : -54px !important;
        }
        .toolbar{
            margin-left: 186px;
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
								        .card {height:180px;}
								      }
								      .tabs-container{width:100%;margin:auto;}
											.tab-content{width:98.5%;margin:auto;}
								      .row {margin-right:0px !important;margin:auto;width:100%;}
								      .col-md-4{padding:0px;}
								      .col-sm-2, .col-md-2, .col-md-1, .col-lg-2, .col-lg-1{padding: 0px;}

				      .inner-row-card{border-top:1px solid black !important;}
				      .inner-row-card .col-md-6 {margin-top:16px;padding: 4px;}
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
							 .panel-body{padding:0px !important;}

							 .col-md-12 {padding: 0px;}
							 #viewBtn {height: 28px;
							     padding-top: 3px;}

									 .inner-textTop{
										 margin-top: -10px;
										 font-size: 10px !important;
									 }
									 p{
									 font-weight:bold !important;
									 }
									 
									 .loader{
									     margin-top: 10px;
									    display: none; 
									    position: fixed;
									    width: 100%;
									    height: 100vh;    
									    z-index: 100;
									    top: 0px;
									 }
      </style>


             <div class="row" id="tripWise" style="/*margin-bottom: 8px;*/">
                   <div class="col-xs-12 col-md-1 col-lg-1 col-sm-12" style="display:none;">
                   <label>Route Name</label>
                     <select class="form-control" id="route_names" >
                        <option value="ALL" selected="selected">ALL</option>
                     </select>
                   </div>
                   <div class="col-xs-12 col-md-1 col-lg-1 col-sm-12" style="display:none;" >
                    <label>Customer</label>
                     <select class="form-control" id="cust_names" >
                        <option value="ALL" selected="selected">ALL</option>
                     </select>
                   </div>
               </div>
                 <div class="row">
                              <div class="col-lg-2 card">
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
                              <div class="col-lg-2 card">
                                 <div class="count main-count outer-count" onclick="getCountsBasedOnStatus('onTimeId')">
                                    <a href="#" >
                                       <h3 style="color: #67cc67 !important;font-weight: 600;margin-top: -19px;" id="onTimeId">0</h3>
                                    </a>
                                    <p style="font-weight: 300;">On Time</p>
                                 </div>
                                 <div class="row inner-row-card">
                                    <div class="col-md-6">
                                       <div class="count outer-count inner-row" style="border: 1px solid;border-radius:8px;" onclick="getCountsBasedOnStatus('onTimeId-stoppage')">
                                          <a href="#" >
                                             <h3 id="onTimeId-stoppage" style="color: #67cc67 !important;font-weight: 600;">0</h3>
                                          </a>
                                          <p class="inner-text">Unplanned Stoppage</p>
                                       </div>
                                    </div>
                                    <div class="col-md-6">
                                       <div class="count outer-count inner-row"  style="border: 1px solid;border-radius:8px;" onclick="getCountsBasedOnStatus('onTimeId-deviation')">
                                          <a href="#" >
                                             <h3 id="onTimeId-deviation" style="color: #67cc67 !important;font-weight: 600;">0</h3>
                                          </a>
                                          <p class="inner-text">Unplanned Deviation</p>
                                       </div>
                                    </div>
                                 </div>
                              </div>
                              <div class="col-lg-1 card">
  <div class="count outer-count" onclick="getCountsBasedOnStatus('delayedonetotwohour')">
     <a href="#">
        <h3 class="highlight" id="delayedonetotwohour" style="height:58px; color:#FFA500;font-weight: 600;">0</h3>
     </a>
     <p style="margin-top: -40px;font-weight:500;">Delayed 1 - 2 hrs</p>
  </div>
   <div class="row inner-row-card">
      <div class="col-md-12" style="padding:0px;margin-top:-4px">
        <div class="count outer-count padTop" onclick="getCountsBasedOnStatus('delayedonetotwohour-stoppage')">
           <a href="#">
              <h3 class="highlight" id="delayedonetotwohour-stoppage" style="color:#FFA500;font-weight: 600;margin-top: -9px;">0</h3>
           </a>
           <p class="inner-text" style="margin-top: -8px;">Unplanned Stoppage</p>
        </div>
      </div>
   </div>
   <div class="row  inner-row-card">
     <div class="col-md-12" style="padding:4px 0px 0px 0px;">
      <div class="count outer-count" onclick="getCountsBasedOnStatus('delayedonetotwohour-deviation')">
         <a href="#">
            <h3 class="highlight" id="delayedonetotwohour-deviation" style="color:#FFA500;font-weight: 600;margin-top: -10px;">0</h3>
         </a>
         <p class="inner-text" style="margin-top: -8px;">Unplanned Deviation</p>
      </div>
    </div>
   </div>
</div>

<div class="col-lg-1 card">
  <div class="count outer-count"  onclick="getCountsBasedOnStatus('delayedtwotothreehour')">
     <a href="#">
        <h3 class="highlight" id="delayedtwotothreehour" style="height:58px; color:#FF6347;font-weight: 600;">0</h3>
     </a>
     <p style="margin-top: -40px;font-weight:500;">Delayed 2 - 3 hrs</p>
  </div>
   <div class="row inner-row-card">
      <div class="col-md-12" style="padding:0px;margin-top:-4px">
        <div class="count outer-count padTop" onclick="getCountsBasedOnStatus('delayedtwotothreehour-stoppage')">
           <a href="#">
              <h3 class="highlight" id="delayedtwotothreehour-stoppage" style="color:#FF6347;font-weight: 600;margin-top: -9px;">0</h3>
           </a>
           <p class="inner-text" style="margin-top: -8px;">Unplanned Stoppage</p>
        </div>
      </div>
   </div>
   <div class="row  inner-row-card">
     <div class="col-md-12" style="padding:4px 0px 0px 0px;">
      <div class="count outer-count" onclick="getCountsBasedOnStatus('delayedtwotothreehour-deviation')">
         <a href="#">
            <h3 class="highlight" id="delayedtwotothreehour-deviation" style="color:#FF6347;font-weight: 600;margin-top: -10px;">0</h3>
         </a>
         <p class="inner-text" style="margin-top: -8px;">Unplanned Deviation</p>
      </div>
    </div>
   </div>
</div>

<div class="col-lg-1 card">
  <div class="count outer-count"  onclick="getCountsBasedOnStatus('delayedthreetofivehour')">
     <a href="#">
        <h3 class="highlight" id="delayedthreetofivehour" style="height:58px; color:#FF4500;font-weight: 600;">0</h3>
     </a>
     <p style="margin-top: -40px;font-weight:500;">Delayed 3 - 5 hrs</p>
  </div>
   <div class="row inner-row-card">
      <div class="col-md-12" style="padding:0px;margin-top:-4px">
        <div class="count outer-count padTop" onclick="getCountsBasedOnStatus('delayedthreetofivehour-stoppage')">
           <a href="#">
              <h3 class="highlight" id="delayedthreetofivehour-stoppage" style="color:#FF4500;font-weight: 600;margin-top: -9px;">0</h3>
           </a>
           <p class="inner-text" style="margin-top: -8px;">Unplanned Stoppage</p>
        </div>
      </div>
   </div>
   <div class="row  inner-row-card">
     <div class="col-md-12" style="padding:4px 0px 0px 0px;">
      <div class="count outer-count" onclick="getCountsBasedOnStatus('delayedthreetofivehour-deviation')">
         <a href="#">
            <h3 class="highlight" id="delayedthreetofivehour-deviation" style="color:#FF4500;font-weight: 600;margin-top: -10px;">0</h3>
         </a>
         <p class="inner-text" style="margin-top: -8px;">Unplanned Deviation</p>
      </div>
    </div>
   </div>
</div>

<div class="col-lg-1 card">
  <div class="count outer-count"  onclick="getCountsBasedOnStatus('delayedmorethanfivehour')">
     <a href="#">
        <h3 class="highlight" id="delayedmorethanfivehour" style="height:58px; color:#ff0000;font-weight: 600;">0</h3>
     </a>
     <p style="margin-top: -40px;font-weight:500;">Delayed >5 hrs</p>
  </div>
   <div class="row inner-row-card">
      <div class="col-md-12" style="padding:0px;margin-top:-4px">
        <div class="count outer-count padTop" onclick="getCountsBasedOnStatus('delayedmorethanfivehour-stoppage')">
           <a href="#">
              <h3 class="highlight" id="delayedmorethanfivehour-stoppage" style="color:#ff0000;font-weight: 600;margin-top: -9px;">0</h3>
           </a>
           <p class="inner-text" style="margin-top: -8px;">Unplanned Stoppage</p>
        </div>
      </div>
   </div>
   <div class="row  inner-row-card">
     <div class="col-md-12" style="padding:4px 0px 0px 0px;">
      <div class="count outer-count" onclick="getCountsBasedOnStatus('delayedmorethanfivehour-deviation')">
         <a href="#">
            <h3 class="highlight" id="delayedmorethanfivehour-deviation" style="color:#ff0000;font-weight: 600;margin-top: -10px;">0</h3>
         </a>
         <p class="inner-text" style="margin-top: -8px;">Unplanned Deviation</p>
      </div>
    </div>
   </div>
</div>
                              <div class="col-lg-1 card">
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
                              <div class="col-lg-2 card">
                                       <div class="row">
                                          <div class="col-md-4">
                                             <div class="count outer-count" onclick="loadEvents('38','Door Alert')">
                                                <a href="#" >
                                                   <h3 class="alert-count" id="doorAlertId">0/0</h3>
                                                </a>
                                                <p>Door&nbsp;&nbsp;Alert</p>
                                             </div>
                                             <div class="row alert-row">
                                                <div class="col-md-12">
                                                   <div class="count outer-count" onclick="loadEvents('999','Temperature Alert')">
                                                      <a href="#" >
                                                         <h3 class="alert-count" id="tempAlertId">0/0</h3>
                                                      </a>
                                                      <p>Temp Alert</p>
                                                   </div>
                                                </div>
                                             </div>
                                          </div>
                                          <div class="col-md-4">
                                             <div class="count outer-count" onclick="loadEvents('3','Panic Alert')">
                                                <a href="#" >
                                                   <h3 class="alert-count" id="panicAlertId">0/0</h3>
                                                </a>
                                                <p>Panic Alert</p>
                                             </div>
                                             <div class="row alert-row">
                                                <div class="col-md-12">
                                                   <div class="count outer-count" onclick="loadEvents('190','Reefer Off Alert')">
                                                      <a href="#" >
                                                         <h3 class="alert-count" id="reeferOffAlertId">0/0</h3>
                                                      </a>
                                                      <p>ReeferOff Alert</p>
                                                   </div>
                                                </div>
                                             </div>
                                          </div>
                                          <div class="col-md-4">
                                             <div class="count outer-count" onclick="loadEvents('186','Humidity Alert')">
                                                <a href="#" >
                                                   <h3 class="alert-count" id="humidityAlertId">0/0</h3>
                                                </a>
                                                <p>Humidity Alert</p>
                                             </div>
                                             <div class="row alert-row">
                                                <div class="col-md-12">
                                                   <div class="count outer-count" onclick="loadEvents('85','NotReporting Alert')">
                                                      <a href="#" >
                                                         <h3 class="alert-count" id="nonReportingAlertId">0/0</h3>
                                                      </a>
                                                      <p>NotComm Alert</p>
                                                   </div>
                                                </div>
                                             </div>
                                          </div>
                                       </div>
                                     </div>
                           </div>
                 <div class="tabs-container">
                        <ul class="nav nav-tabs">
                           <li><a href="#mapViewId" data-toggle="tab" active style="font-size: 15px;font-weight: 600;height:32px;padding-top:4px;">Map View</a></li>
                           <li><a href="#listViewId" data-toggle="tab" style="font-size: 15px;font-weight: 600;height:32px;padding-top:4px;">List View</a></li>
                           <li class="dropdown">
                                <a class="dropdown-toggle" data-toggle="dropdown" href="#" style="height:32px;padding-top:4px;">Legend
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
													 <li><button id="viewBtn" type="button" class="btn btn-primary" onclick="ResetData()">Reset</button></li>
                        </ul>
                     </div>
                      <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12 text-center">
       			<div id="page-loader" class="loader" >
				 <img src="../../Main/images/loading.gif" style="margin-top:25%" alt="loader" />
				</div>
       		</div>
                     <div class="tab-content" id="tabs">
                        <div class="tab-pane" id="mapViewId">
                           <div class="col-md-12" style="padding:0px 8px 10px 0px !important;margin-top: -3px;margin-bottom:32px;">
                              <div id="map" style="width: 102%;height: 424px;margin-top:5px;margin-left: -10px;position: relative;overflow: hidden;border: solid 1px rgba(0, 0, 0, .25);box-shadow: 0 1px 1px rgba(0, 0, 0, .25);"></div>
                           </div>
                        </div>
                        <div class="tab-pane" id="listViewId">
                        <i class="fa fa-fw"></i> Trip Information
                        <span id="disclimer"> (Double click on the records to view the trip details) &nbsp;&nbsp;</span>
                         <input type="button" id="expBtn" class="btn btn-primary" title="Make sure pop-up is not blocked for this Browser" value="Export to Excel">
                        <table id="tripSumaryTable"  class="table table-striped table-bordered" cellspacing="0">
                              <thead>
                                 <tr>
                                   <th>S.No.</th>
								   <th>TripID</th>
								   <th>Trip ID</th>
                                   <th>Trip No</th>
									<th>Route ID</th>
								   <th>Trip Type</th>
                                   <th>Vehicle Number</th>
								   <th>Make of Vehicle</th>
								   <th>Customer Name</th>
                                   <th>Customer Reference ID</th>
                                   <th>Location</th>

								   <th>Route Key</th>
								   <th>Origin City</th>
								   <th>Destination City</th>

                                   <th>Driver Name</th>
                                   <th>Driver Contact</th>
                                   <th>Origin</th>
                                   <th>Destination</th>


								   <th>STP</th>
                                   <th>ATP</th>
								   <th>Placement Delay(HH:mm)</th>
								   <th>STD</th>
                                   <th>ATD</th>
								   <th>Departure Delay wrt STD</th>
								   <th>STA(WRT STD)</th>
								   <th>STA(WRT ATD)</th>
                                   <th>ETA</th>
                                   <th>ATA</th>
								   <th>Actual Transit Time incl.planned and unplanned stoppages</th>
								   <th>Transit Delay</th>
                                   <th>Trip Status</th>
								   <th>Reason for Delay</th>
								   <th>Reason for Cancellation</th>
								   <th>Last Communication Stamp</th>
                                   <th>Nearest Hub</th>
                                   <th>ETA to Next Hub</th>
                                   <th>Distance to Next Hub(<%=unit%>)</th>
                                   <th>Next Leg</th>
                                   <th>Next Leg ETA</th>
                                   <th>Average Speed(<%=unit%>/Hr)</th>
                                   <th>Total Stoppage Time(HH:mm)</th>
                                   <th>Total Distance(<%=unit%>)</th>
                                   <th>Customer Detention Time(HH:mm)</th>
                                   <th>Loading Detention Time(HH:mm)</th>
                                   <th>Unloading Detention Time(HH:mm)</th>
                                   <th>Flag</th>
                                   <th>Weather</th>
                                   <th>End Date</th>
                                   <th>routeId</th>
                                   <th>Panic Alert</th>
                                   <th>Door Alert</th>
                                   <th>Non-Communicating Alert</th>
                                   <th>Remarks</th>
                                 </tr>
                              </thead>
                           </table>
                        </div>
                     </div>


      <div id="add" class="modal fade">
         <div class="modal-content">
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
               <button type="reset" class="btn btn-warning" data-dismiss="modal">Close</button>
            </div>
         </div>
      </div>

      <div  class="">
         <div id="viewModal" class="modal-content modal fade" style="margin-top:1%">
            <div class="modal-header" >
               <div class="secondLine" style="display:flex; justify-content:space-between; align-items:baseline;">
                  <h4 id="tripEventsTitle" class="modal-title" style="text-align:left; margin-left:0px;">View Remarks</h4>
               </div>
			   <div style="margin-left: 87%;">
                  <button type="button" class="close" style="align:right;" data-dismiss="modal">×</button>
               </div>
            </div>
            <div class="modal-body" style="height: 100%; overflow-y: auto;">
               <div class="row">
                  <div class="col-lg-12">
                     <div class="col-lg-12" style="border: solid  1px lightgray;">
                        <table id="viewGrid"  class="table table-striped table-bordered" cellspacing="0" style="width:-1px;">
                           <thead>
                              <tr>
                                <th>Sl No</th>
                                 <th>USER</th>
                                 <th>DATE & TIME</th>
                                 <th>LOCATION OF DELAY</th>
                                 <th>DELAY STARTTIME</th>
                                 <th>DELAY ENDTIME</th>
                                 <th>DURATION OF DELAY(HH:mm:ss)</th>
                                 <th>ISSUE TYPE</th>
                                 <th>SUB-ISSUE TYPE</th>
                                 <th>REMARKS</th>
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
      <script src='<%=GoogleApiKey%>'></script>

<script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>

<script>
    var map;
    var mcOptions = {
        gridSize: 20,
        maxZoom: 100
    };
    var markerClusterArray = [];
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
    var custName = '<%=custName%>';
    var custId = '<%=custId%>';
    var routeId = "ALL";
    var custType = "ALL";
    var tripType = "ALL";
    var tripStatus = "";
    var flag = false;
    function ResetData(){
        custName = "";
        custId = '<%=custId%>';
        routeId = "ALL";
        tripStatus = "";
        custType = "ALL";
        tripType = "ALL";
        loadData(custId, routeId,custType,tripType,1);
        loadMap(custId, routeId, tripStatus,custType,tripType);
        loadTable(custId, routeId, tripStatus,custType,tripType);

    }
    function activaTab(tab) {
        $('.nav-tabs a[href="#' + tab + '"]').tab('show');
    };
    activaTab('mapViewId');
    loadData(custId, routeId,custType,tripType,1);

    function loadData(custId, routeId,custType,tripType,count) {

        $.ajax({
            url: "<%=request.getContextPath()%>/tripDashBoardAction.do?param=getDashBoardCounts",
            data: {
                //custName: custName,
                custId: custId+',',
                routeId: routeId,
				custType: custType,
                tripType: tripType,
                count:1
            },
            "dataSrc": "vehicleCounts",
            success: function(result) {
                results = JSON.parse(result);
				//console.log(results);
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
                
                //dhl blue dart req
                $("#delayedonetotwohour").text(results["vehicleCounts"][0].delayOneToTwoHour);
                $("#delayedtwotothreehour").text(results["vehicleCounts"][0].delayTwoToThreeHour);
                $("#delayedthreetofivehour").text(results["vehicleCounts"][0].delayThreeToFiveHour);
                $("#delayedmorethanfivehour").text(results["vehicleCounts"][0].delayMoreThanFiveHour);
                
                
                $("#delayedonetotwohour-stoppage").text(results["vehicleCounts"][0].stoppageDelayOneToTwoHour);
                $("#delayedtwotothreehour-stoppage").text(results["vehicleCounts"][0].stoppageDelayTwoToThreeHour);
                $("#delayedthreetofivehour-stoppage").text(results["vehicleCounts"][0].stoppageDelayThreeToFiveHour);
                $("#delayedmorethanfivehour-stoppage").text(results["vehicleCounts"][0].stoppageDelayMoreThanFiveHour);
                
                $("#delayedonetotwohour-deviation").text(results["vehicleCounts"][0].deviationDelayOneToTwoHour);
                $("#delayedtwotothreehour-deviation").text(results["vehicleCounts"][0].deviationDelayTwoToThreeHour);
                $("#delayedthreetofivehour-deviation").text(results["vehicleCounts"][0].deviationDelayThreeToFiveHour);
                $("#delayedmorethanfivehour-deviation").text(results["vehicleCounts"][0].deviationDelayMoreThanFiveHour);
                

            }
        });

        $.ajax({
            url: "<%=request.getContextPath()%>/tripDashBoardAction.do?param=getAlertCounts",
            data: {
                //custName: custName,
                custId: custId+',',
                routeId: routeId,
				custType: custType,
                tripType: tripType,
				count:1
            },
            "dataSrc": "alertCounts",
            success: function(result) {
                results = JSON.parse(result);
                $("#doorAlertId").text(results["alertCounts"][0].doorCount);
                $("#tempAlertId").text(results["alertCounts"][0].tempCount);
                $("#humidityAlertId").text(results["alertCounts"][0].humidityCount);
                $("#reeferOffAlertId").text(results["alertCounts"][0].reeferCount);
            }
        });
    }
    // ************* Map Details
    function initialize() {
        var mapOptions = {
            zoom: 3,
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

    function loadMap(custId, routeId, tripStatus,custType,tripType) {

        $.ajax({
            url: '<%=request.getContextPath()%>/tripDashBoardAction.do?param=getVehiclesForMap',
            data: {
                //custName: custName,
                custId:custId+',',
                routeId: routeId,
                status: tripStatus,
				custType: custType,
                tripType: tripType
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
                            results["MapViewVehicles"][i].ATD, results["MapViewVehicles"][i].status, results["MapViewVehicles"][i].tripId,results["MapViewVehicles"][i].endDateHidden,
                            results["MapViewVehicles"][i].STD,results["MapViewVehicles"][i].temperatureSensorsData,results["MapViewVehicles"][i].productLine,
                            results["MapViewVehicles"][i].tripNo, results["MapViewVehicles"][i].routeName,results["MapViewVehicles"][i].LRNO);
                        var mylatLong = new google.maps.LatLng(results["MapViewVehicles"][i].lat, results["MapViewVehicles"][i].lon);
                    }
                }
                 markerCluster = new MarkerClusterer(map, markerClusterArray, mcOptions);
            }
        });
    }
    loadMap(custId, routeId, tripStatus,custType,tripType);

    function plotSingleVehicle(vehicleNo, latitude, longtitude, location, gmt, tripStatus, custName, shipmentId, delay1, weather, driverName, etaDest, etaNextPt,routeId,ATD,
    	status,tripId,endDate,startDate,temeratureSensorData,productLine,tripNo,routeName,LRNO) {
		var tempContent='';
        var humidityContent='';
        var Humidity;
        var temperatureSensorsDataArray ;
        var delay = delay1.split(':')[0];
        if(productLine == 'Chiller' || productLine == 'Freezer' || productLine == 'TCL')
        //if(productLine != 'Dry')
		{
				temperatureSensorsDataArray = temeratureSensorData.split(',');
				//console.log(temperatureSensorsDataArray);
				for(var i=0;i <temperatureSensorsDataArray.length;i++)
				{
					temperatureSensorNameValue = temperatureSensorsDataArray[i].split('=');
					tempContent= tempContent+ '<tr><td><b>'+temperatureSensorNameValue[0]+':</b></td><td>' +  temperatureSensorNameValue[1] + '</td></tr>'
				}
		}
        var x;
        var y;
        var imageurl;
        //alert(tripStatus);
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

		var delayFormat = delay1;

        var content = '<div id="myInfoDiv" seamless="seamless" scrolling="no" style="overflow:hidden; width:100%; height: 100%; float: left; color: #000; background:#ffffff; line-height:100%; font-size:11px; font-family: sans-serif;">' +
            '<table>' +
            '<tr><td><b>Vehicle No:</b></td><td>' + vehicleNo + '</td></tr>' +
            '<tr><td><b>Trip Id:</b></td><td>' + tripNo + '</td></tr>' +
			  '<tr><td><b>Trip No:</b></td><td>' + LRNO + '</td></tr>' +
            '<tr><td><b>Route Name:</b></td><td>' + routeName + '</td></tr>' +
            '<tr><td><b>Location:</b></td><td>' + location + '</td></tr>' +
            '<tr><td><b>Last Comm:</b></td><td>' + gmt + '</td></tr>' +
            '<tr><td><b>Customer :</b></td><td>' + custName + '</td></tr>' +
            //'<tr><td><b>Delay:</b></td><td>' + convertMinutesToHHMM(delay) + '</td></tr>' +
            '<tr><td><b>Delay:</b></td><td>' + delayFormat + '</td></tr>' +
            '<tr><td><b>weather:</b></td><td>' + weather + '</td></tr>' +
            '<tr><td><b>Driver Name:</b></td><td>' + driverName + '</td></tr>' +
            '<tr><td><b>ETA to Next Hub:</b></td><td>' + etaNextPt + '</td></tr>' +
            '<tr><td><b>ETA to Destination:</b></td><td>' + etaDest + '</td></tr>' +
            '<tr><td><b>LatLong:</b></td><td>' + coordinate + '</td></tr>' +
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
 			/*var ddmmyyyyStrDate = startDate.slice(0, 10).split('/');
			ddmmyyyyStrDate = ddmmyyyyStrDate[1] +'/'+ ddmmyyyyStrDate[0] +'/'+ ddmmyyyyStrDate[2]+' '+startDate.slice(11, startDate.length);
			var ddmmyyyyEndDate = endDate.slice(0, 10).split('/');
			ddmmyyyyEndDate = ddmmyyyyEndDate[1] +'/'+ ddmmyyyyEndDate[0] +'/'+ ddmmyyyyEndDate[2]+' '+endDate.slice(11,endDate.length);
        var parameterStr="tripNo=" + tripId + "&vehicleNo=" + vehicleNo + "&startDate=" + ddmmyyyyStrDate + "&endDate=" + ddmmyyyyEndDate + "&pageId=3&status=" + status + "&actual=" + ATD + "&routeId=" + routeId;
		*/
		var parameterStr="tripNo=" + tripId + "&vehicleNo=" + vehicleNo + "&startDate=" + startDate + "&endDate=" + endDate + "&pageId=3&status=" + status + "&actual=" + ATD + "&routeId=" + routeId;
        google.maps.event.addListener(marker, 'dblclick', (function(marker, parameterStr) {
            return function() {
                window.location.href = "<%=request.getContextPath()%>/Jsps/GeneralVertical/TripAndAlertDetails.jsp?"+parameterStr
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
        //routeId = $('#route_names option:selected').val();
        //custName = $('#cust_names option:selected').val();
  //loadTable(custName, routeId, tripStatus);
        loadTable(custId, routeId, tripStatus,custType,tripType);
    });
    var table;
    loadTable(custId, routeId, tripStatus,custType,tripType);

    function loadTable(custId, routeId, tripStatus) {
        groupId = $('#groupName option:selected').attr('id');
        grouplabel = $('#groupName option:selected').attr('value');
        if(typeof groupId ==='undefined'){
            groupId=0;
            grouplabel="On Trip";
        }
        
        $("#page-loader").show();
        setTimeout(function(){$("#page-loader").hide();},5000);
        table = $('#tripSumaryTable').DataTable({
            "ajax": {
                "url": "<%=request.getContextPath()%>/tripDashBoardAction.do?param=getTripSummaryDetailsDHL",
                "dataSrc": "tripSummaryDetails",
                "data": {
                    groupId: groupId,
                    unit: '<%=unit%>',
                   // custName: custName,
                    custId: custId+',',
                    routeId: routeId,
                    status: tripStatus,
					custType: custType,
                    tripType: tripType,
					count:1
                }
            },
            "bDestroy": true,
			"scrollY": "300px",
			"scrollX": true,
            "dom": '<"toolbar">Bfrtip',
        	//buttons: [ 'excel', 'pdf'],
            "oLanguage": {
                "sEmptyTable": "No data available"
            },
             "buttons": [{extend:'pageLength'}],
            columnDefs: [
		            { width: 100, targets: 2 },  	// <th>Trip ID</th>
		            { width: 50,  targets: 3 },		// <th>Route ID</th>
		            { width: 100, targets: 4 },		// <th>Vehicle No</th>
		            { width: 200, targets: 11 },	// <th>Current Location</th>
		            { width: 200, targets: 12 },	// <th>Origin</th>
		            { width: 300, targets: 13 }		// <th>Destination</th>
		        ],
             "columns": [{
                "data": "slNo"//0
            }, {
                "data": "tripNo",//1
                "visible" : false
            }, {
                "data": "ShipmentId"//2
            }, {
                "data": "lrNo"//3
            }, {
                "data": "routeName",//  4
                "visible" : false
            }, {
                "data": "tripType"//   5
            }, {
                "data": "vehicleNo"//	6
            }, {
                "data": "make",//	7
				"visible" : false
            }, {
                "data": "customerName"//	8
            }, {
                "data": "custRefId"//	9
            }, {
                "data": "Location"//	10
            }, {
                "data": "routeKey"//	11
            }, {
                "data": "originCity"//	12
            }, {
                "data": "destinationCity"//	13
            }, {
                "data": "driverName",//	14
				"visible" : false
            }, {
                "data": "driverContact",//	15
                "visible" : false
            }, {
                "data": "origin",//	16
                "visible" : false
            }, {
                "data": "Destination",//	17
                "visible" : false
            }, {
                "data": "STP"//	18
                //"visible" : false
            }, {
                "data": "ATP"//	19
                //"visible" : false
            }, {
                "data": "placementDelay"//	20
                //"visible" : false
            }, {
                "data": "STD"//	21
            }, {
                "data": "ATD"//	22
            },{
                "data": "departureDelayWrtSTD"//	23
            }, {
                "data": "STA (WRT STD)",//	24
                "visible" : false

            },{
                "data": "STA (WRT ATD)",//	25
            },{
                "data": "ETA"//	26
            },  {
                "data": "ATA"//	27
            },  {
                "data": "totalTripTimeATAATD"//	 28
            }, {
                "data": "delay"//	 29
                
            }, {
                "data": "status"//	30
            }, {
                 "data": "viewbutton", // remarks	31
                 "visible": false
            }, {
                 "data": "reasonForCancel" //   32
            }, {
                 "data": "lastCommunicationStamp" //   32  //Last Communication Stamp
            }, {
                "data": "nearestHub", //	33
				"visible": false
            }, {
                "data": "ETHA", //	34
				"visible" : false
            }, {
                "data": "distanceToNextHub", //	35
				"visible" : false
            },{
                "data": "nextLeg",//	36
                "visible" : false
            },{
                "data": "nextLegETA",//	37
                "visible" : false
            }, {
                "data": "avgSpeed", //	38
				"visible" : false
            }, {
                "data": "stoppageTime",//	  39
				"visible" : false
            }, {
                "data": "totalDist",//	40
				"visible" : false
            }, {
                "data": "customerDetentionTime",//	41
				"visible" : false
            }, {
                "data": "loadingDetentionTime",//	   42
				"visible" : false
            }, {
                "data": "unloadingDetentionTime",//	43
				"visible" : false
            }, {
                "data": "flag",//	   44
				"visible" : false
            }, {
                "data": "weather",//	45
				"visible" : false
            }, {
                "data": "endDateHidden",//	46
                "visible" : false
            }, {
                "data": "routeIdHidden",//	47
                "visible" : false
            }, {
                "data": "panicAlert",//	48
				"visible" : false
            }, {
                "data": "doorAlert",//	49
				"visible" : false
            }, {
                "data": "nonReporting",//	   50
				"visible" : false
            }, {
                "data": "viewbutton",//	51
				"visible" : false
            }]
        });
<!--     	table.column(1).visible(false);			// <th>Trip No</th>		-->
<!--     	table.column(10).visible(false);		// <th>Driver Contact</th>						-->
<!--        table.column(15).visible(false);		//  <th>STP</th>							                                 -->
<!--        table.column(16).visible(false);		//  <th>ATP</th>							-->
<!--        table.column(31).visible(false);		// <th>Placement Delay Time</th>			-->
<!--        table.column(37).visible(false);		// <th>End Date</th>						                                  -->
<!--        table.column(38).visible(false);		//  <th>routeId</th>	-->
<!--        table.column(22).visible(false);		// <th>Next leg</th>						                                  -->
<!--        table.column(23).visible(false);		//  <th>Next leg ETA</th>		-->
        $("div.toolbar").html('<select name="size" id="groupName" onchange="loadAjax();" style="height:35px;width:150px;border-radius: 4px;">'+
                           ' <option value="On Trip" id="0">On Trip</option>'+
                           ' <option value="Last 2 day" id="1">Last 2 days</option>'+
                           ' <option value="Last 1 week" id="2">Last 1 week</option>'+
                           ' <option value="Last 15 days" id="3">Last 15 days</option>'+
                           ' <option value="Last 1 month" id="4">Last 1 month</option>'+
                           ' </select>');
         $('#groupName').val(grouplabel).attr("selected", "selected");
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
	     tripId=tripNo;
            if (columnIndex == 2) {
                window.open("<%=request.getContextPath()%>/Jsps/GeneralVertical/TripAndAlertDetails.jsp?tripNo=" + tripNo + "&vehicleNo=" + vehicleNo + "&startDate=" + startDate + "&endDate=" + endDate + "&pageId=3&status=" + status + "&actual=" + actualDate + "&routeId=" + routeId, '_blank');
            }
            event.preventDefault();
        });
    }

    				$('#expBtn').click(function() {
							   groupId = $('#groupName option:selected').attr('id');
								grouplabel = $('#groupName option:selected').attr('value');
								if(typeof groupId ==='undefined'){
									groupId=0;
									grouplabel="On Trip";
								}
						 var data = table.rows().data();
							 if(data.length){
							 document.getElementById("page-loader").style.display="block";
							    $.ajax({
							        url: '<%=request.getContextPath()%>/tripDashBoardAction.do?param=GenerateCustomerExportExcel',
							        //type:"POST",
							        data: {
							            groupId: groupId,
							            unit: '<%=unit%>',
							            //custName: custName,
							            custId: custId,
							            routeId: routeId,
							            status: tripStatus
							        },
							        success: function(responseText) {
							          if (responseText != "Failed to Download Report") {
											//?cameraNo="+cameraNo+"
							               window.open("<%=request.getContextPath()%>/LegDetailsExport?relativePath=" + responseText);
							               document.getElementById("page-loader").style.display="none";
							            }else{
											sweetAlert(responseText);
											document.getElementById("page-loader").style.display="none";
										}
							        }
							    });
							    }else{
							      sweetAlert("No Data Found to Export");
							    }
							});


    setInterval(function() {

        loadMap(custId, routeId, tripStatus,custType,tripType);
        loadTable(custId, routeId, tripStatus,custType,tripType);
        loadData(custId, routeId,custType,tripType,1);
    }, 300000); // 5 minute interval
    var tableNew;

function view(tripId) {
        $('#viewModal').modal('show');
        $.ajax({
                                    	type: "POST",
                                        url: '<%=request.getContextPath()%>/tripDashBoardAction.do?param=viewDetails',
                                        "data": {
                                            tripId: tripId
                                        },
                                    success: function(result) {
             						result = JSON.parse(result).Root;
						            if ($.fn.DataTable.isDataTable('#viewGrid')) {
						                 $('#viewGrid').DataTable().clear().destroy();
						             }
						         	var rows = new Array();
						           $.each(result, function(i, item) {
						           var row = { 	 "0" : item.slno,
						                         "1" : item.user,
						                         "2" : item.datetime,
						                         "3" : item.locationdelay,
						                         "4" : item.startdate,
						                         "5" : item.enddate,
						                         "6" : item.durationdelay,
						                         "7" : item.issuetype,
						                         "8" : item.subissuetype,
						                         "9" : item.remarks
						                         }
						                          rows.push(row);
             									});
             						var prntTable = $('#viewGrid').DataTable({
                                    "bLengthChange": false,
                                    "scrollY": '50vh',
                                    "scrollX": true,
                                    "oLanguage": {
                       				"sEmptyTable": "No data available"
                   						},
                                    "buttons": [{
                                        // extend: 'pageLength'
                                    }],
                               });
                 			prntTable.rows.add(rows).draw();
                            }
                            });
                            $('#viewGrid').closest('.dataTables_scrollBody').css('max-height', '200px');
							}


    function loadEvents(alertId, alertName, tripId,custType,tripType) {

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
                    custId: custId+',',
                    routeId: routeId,
					custType: custType,
                    tripType: tripType
                }
            },
            "bDestroy": true,
            "processing": true,
            //"scrollY": '50vh',
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

    function getRouteNames() {
        $.ajax({
            url: '<%=request.getContextPath()%>/tripDashBoardAction.do?param=getRouteNames',
            success: function(response) {
                routeList = JSON.parse(response);
                var $routeName = $('#route_names');
                var output = '';
                $.each(routeList, function() {
                    $('<option value=' + this.routeId + '>' + this.routeName + '</option>').appendTo($routeName);
                });
            }
        });
    }
    $('#route_names').change(function() {
        routeId = $('#route_names option:selected').val();
        custName = $('#cust_names option:selected').val();
        loadData(custId, routeId,custType,tripType);
        loadMap(custId, routeId, tripStatus,custType,tripType);
        loadTable(custId, routeId, tripStatus,custType,tripType);
    });

    function loadAjax(){
        loadTable(custId, routeId, tripStatus,custType,tripType);
    }
    var custName;

    function getCustNames() {
        $.ajax({
            url: '<%=request.getContextPath()%>/tripDashBoardAction.do?param=getCustNamesSLA',
            success: function(response) {
                custList = JSON.parse(response);
           for (var i = 0; i < custList["customeList"].length; i++) {
          // alert(truckTypeList["truckTypeList"][i].VehicleType);
			var custName1=custList["customeList"][i].custName;
			$('#cust_names').append($("<option></option>").attr("value",custName1).text(custName1));
            }
            }
        });
    }
    $('#cust_names').change(function() {
        //custName = $('#cust_names option:selected').val();
        custId = $('#cust_names option:selected').val();
        routeId = $('#route_names option:selected').val();
        loadData(custId, routeId,custType,tripType);
        loadMap(custId, routeId, tripStatus,custType,tripType);
        loadTable(custId, routeId, tripStatus,custType,tripType);
    });

    function getCountsBasedOnStatus(tripStatus1) {
        flag = true;
        tripStatus=tripStatus1;
        loadMap(custId, routeId, tripStatus,custType,tripType);
        loadTable(custId, routeId, tripStatus,custType,tripType);
    }

    function Acknowledge(uniqueId) {
        swal({
                title: "An input!",
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
        loadTable(custId, routeId, tripStatus,custType,tripType);
    }
</script>
  <jsp:include page="../Common/footer.jsp" />
