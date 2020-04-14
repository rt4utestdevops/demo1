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
    String ipAddress = "http://localhost:9010";
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
      <script src="https://cdn.datatables.net/1.10.19/js/jquery.dataTables.min.js"></script>
    <link rel="stylesheet" href="https://cdn.datatables.net/1.10.19/css/jquery.dataTables.min.css"/>
    <script src="https://cdn.datatables.net/buttons/1.5.6/js/dataTables.buttons.min.js"></script>
    <script src="https://cdn.datatables.net/buttons/1.5.6/js/buttons.flash.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jszip/3.1.3/jszip.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.53/pdfmake.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.53/vfs_fonts.js"></script>
    <script src="https://cdn.datatables.net/buttons/1.5.6/js/buttons.html5.min.js"></script>
    <script src="https://cdn.datatables.net/buttons/1.5.6/js/buttons.print.min.js"></script>

      <link href="../../Main/custom.css" rel="stylesheet" type="text/css">
      <link href="../../Main/bootstrap.css" rel="stylesheet" type="text/css">
        <link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/smoothness/jquery-ui.css">

    		<link rel="stylesheet" href="https://www.jqwidgets.com/public/jqwidgets/styles/jqx.base.css">
            <link rel="stylesheet" href="https://www.jqwidgets.com/public/jqwidgets/styles/jqx.energyblue.css">
            <link rel="stylesheet" href="https://www.jqwidgets.com/public/jqwidgets/styles/jqx.arctic.css">

      <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
      <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
      <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-multiselect/0.9.13/js/bootstrap-multiselect.min.js"></script>
      <script src="../../Main/sweetAlert/sweetalert.min.js"></script>
      
    <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.8.1/css/all.css"/>
      
       <script src="https://www.jqwidgets.com/public/jqwidgets/jqx-all.js"></script>
            <script src="https://www.jqwidgets.com/public/jqwidgets/globalization/globalize.js"></script>
            
            
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
            padding-right: 0px !important;
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
                    margin-right : 2px !important;
                    font-size: 30px !important;
                    margin-top: -13px !important;
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
  text-align:left !important;
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

.margin16{
  margin-left:16px;
}

.lightGrey{
  background: #ECEFF1;
}

.alignPad{
  text-align:center;padding:0px 0px;
}

.col-lg-3{
  padding:1px 0px;
}
.tableTop{
  margin-top:12px;
}

#datatable1,#datatable2,#datatable3, #datatable4,#datatable5,#datatable6
{
 height: 0;
padding-left:4px;
overflow: hidden;
-webkit-transition: all .8s ease;
-moz-transition: all .8s ease;
-ms-transition: all .8s ease;
-o-transition: all .8s ease;
transition: all .8s ease;
}

.close{
  color:red !important;
  padding:0px 4px;
  font-size:20px;
  cursor: pointer;
  opacity: 1;

}

.datatableHeader{
  width:100%;
  height:40px;
  text-align: left;
  font-size:18px;
  padding:2px 4px;
  border-radius:8px;
  text-transform:uppercase;
}
.dataTables_filter label{
  display:flex !important;
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

#datatable1Header, #datatable2Header, #datatable3Header,#datatable4Header, #datatable5Header, #datatable6Header
{
  background-color: #1ABB9C;
  color:white;
  margin-left:-4px;
  padding:4px 8px 4px 8px;

}

.datatableHeader input{
  border-radius: 8px;
  height:24px;
  font-size:14px;
  float:right;
  margin-right:8px;
  padding-left:8px;
}

.datatableHeader button{
  border-radius: 8px;
  height:24px;
  font-size:14px;
  margin-right:24px;
  float:right;

}

.dataTables_filter input{
  border-radius: 8px;
}

.col-lg-3 span{

  cursor:pointer;
}
div#onlineSaleTableId_wrapper {
	top : 2%;
}

.jqx-widget-content{
   z-index:20000 !important;
}

.dataTables_wrapper .dataTables_paginate .paginate_button {
	padding : 0px !important;
}

td{
	font-size : smaller !important;
}

.labelClass {
	font-weight : inherit !important;
}
#footSpan {
bottom: -150px !important;
right: 30px !important;
}
      </style>
      

      <div class="center-view" style="display:none;" id="loading-div">
        <img src="../../Main/images/loading.gif" alt="">
      </div>


      <!-- content -->

      <div class="row" id="columnContainer">
        <div class="col-lg-5" id="midColumn">
          <div class="row" style="margin-bottom:8px;">
            <div class="col-md-6" style="padding:0px;">
              <select id="districtDropDownId" name="selectStatus" onchange="getJSMDCStockyard()">
               <option disabled selected>Select District</option>
               <option value="0">All Districts</option>
                <!-- <option value="0">District 1</option>
                <option value="1">District 2</option>
                <option value="2">District 3</option>
              --></select>
            </div>
            <div class="col-md-6" style="padding:0px;text-align:right;">
              <select id="stockyardDropDownId" name="selectStatus" onchange="getJSMDCStockyardInfo()">
                <option disabled selected>Select Stockyard</option>
                <option value="0">All Stockyards</option>
                <!--<option value="0">Stockyard 1</option>
                <option value="1">Stockyard 2</option>
                <option value="2">Stockyard 3</option>
              --></select>
            </div>
          </div>
          <div class="col-md-12" style="margin-bottom:32px;">
              <div id="map" style="width: 100%;position: relative;overflow: hidden;border: solid 1px rgba(0, 0, 0, .25);box-shadow: 0 1px 1px rgba(0, 0, 0, .25);"></div>
          </div>
        </div>
        <div class="col-lg-7" id="rightColumn">
          <div class="row" style="width:100%;">
                        <div class="col-lg-12 card">
                          <div class="row" style="height:100%;">
                             <div class="col-lg-12">
                                 <div class="headerText blueGrey"><span class="margin16" >Online Sand Sales (INR)</span>
                                 	 <span  class="btn btn-default btn-sm" onclick ="openModal()" style="margin-left: 420px;background-color:#ccc;">Report</span>
                                 </div>
                                 <div class="row alignPad">
                                   <div class="col-lg-3">
                                     Sold & Dispatched<br/>
                                     <span id="totalAmount" >0</span>
                                   </div>
                                   <div class="col-lg-3">
                                     Royalty Collected<br/>
                                     <span id="onlineRoyalty" >0</span>
                                   </div>
                                   <div class="col-lg-3 lightGrey">
                                     GST<br/>
                                      <span id="onlineGST" >0</span>
                                   </div>
                                   <div class="col-lg-3 lightGrey">
                                     Booked & Open<br/>
                                      <span id="onlineBooked" >0</span>
                                   </div>
                                 </div>
                             </div>
                           </div>
                        </div>
            </div>
            
       
            <div class="row" style="width:100%;">
                          <div class="col-lg-12 card">
                            <div class="row" style="height:100%;">
                               <div class="col-lg-12">
                                   <div class="headerText blueGrey"><span class="margin16" >Sand Stock (CFT)</span>
                                   		<span  class="btn btn-default btn-sm" onclick ="openSandStockModal()" style="margin-left:469px;background-color:#ccc;">Report</span>
                                   </div>
                                   <div class="row alignPad">
                                     <div class="col-lg-3">
                                       Total Available<br/>
                                       <span id="sandStockTotal" >0</span>
                                     </div>
                                     <div class="col-lg-3 lightGrey">
                                       Booked Qty.<br/>
                                       <span id="sandStockBooked" >0</span>
                                     </div>
                                     <div class="col-lg-3">
                                       Available For Booking<br/>
                                       <span id="sandStockAvailable" >0</span>
                                     </div>
                                     <div class="col-lg-3 lightGrey">
                                       Dispatched Qty.<br/>
                                       <span id="sandStockDispatched" >0</span>
                                     </div>
                                   </div>
                               </div>
                             </div>
                          </div>
              </div>
              
              <div class="row" style="width:100%;">
                            <div class="col-lg-12 card">
                              <div class="row" style="height:100%;">
                                 <div class="col-lg-12">
                                     <div class="headerText blueGrey"><span class="margin16" >Vehicles</span>
                                      <span  class="btn btn-default btn-sm" onclick ="openVehicleModal()" style="margin-left:540px;background-color:#ccc;">Report</span>
                                     </div>
                                     <div class="row alignPad">
                                       <div class="col-lg-3">
                                         Total<br/>
                                         <span id="totalVehicle" >0</span>
                                       </div>
                                       <div class="col-lg-3 lightGrey">
                                         Non-Communicating<br/>
                                        <span id="nonCommunicating" >0</span>
                                       </div>
                                       <div class="col-lg-3">
                                         Communicating<br/>
                                        <span id="communicating" >0</span>
                                       </div>
                                       <div class="col-lg-3 lightGrey">
                                         On-Trip<br/>
                                         <span id="onTrip" >0</span>
                                       </div>
                                     </div>
                                 </div>
                               </div>
                            </div>
                </div>
               
                <div class="row" style="width:100%;">
                              <div class="col-lg-12 card">
                                <div class="row" style="height:100%;">
                                   <div class="col-lg-12">
                                       <div class="headerText blueGrey"><span class="margin16" >Trips</span>
                                           <span  class="btn btn-default btn-sm" onclick ="openTripModal()" style="margin-left:566px;background-color:#ccc;">Report</span>
                                     	</div>
                                       <div class="row alignPad">
                                         <div class="col-lg-3">
                                           Total<br/>
                                           <span id="tripTotal" >0</span>
                                         </div>
                                         <div class="col-lg-3 lightGrey">
                                           Deviation<br/>
                                           0
                                         </div>
                                         <div class="col-lg-3">
                                           Manual Trip<br/>
                                           0
                                         </div>
                                         <div class="col-lg-3 lightGrey">
                                           Manual Sand<br/>
                                           0
                                         </div>
                                       </div>
                                   </div>
                                 </div>
                              </div>
                  </div>
                  
                  <div class="row" style="width:100%;">
                                <div class="col-lg-12 card">
                                  <div class="row" style="height:100%;">
                                     <div class="col-lg-12">
                                         <div class="headerText blueGrey"><span class="margin16" >Stockyard Operations</span>
                                             <span  class="btn btn-default btn-sm" onclick ="openStockyardModal()" style="margin-left:438px;background-color:#ccc;">Report</span>
                                     	  </div>
                                         <div class="row alignPad">
                                           <div class="col-lg-3">
                                             Entry Tokens<br/>
                                             <span id="tokens" >0</span>
                                           </div>
                                           <div class="col-lg-3 lightGrey">
                                             Delivery Challans<br/>
                                            <span id="delivery" >0</span>
                                           </div>
                                           <div class="col-lg-3">
                                             Loading Vehicles<br/>
                                             <span id="loadingVehicles" >0</span>
                                           </div>
                                           <div class="col-lg-3 lightGrey">
                                             Reprints<br/>
                                             <span id="reprints" >0</span>
                                           </div>
                                         </div>
                                     </div>
                                   </div>
                                </div>
                    </div>
                    
                    <div class="row" style="width:100%;">
                                  <div class="col-lg-12 card">
                                    <div class="row" style="height:100%;">
                                       <div class="col-lg-12">
                                           <div class="headerText blueGrey"><span class="margin16" >Active Sand Operations</span>
                                               <span  class="btn btn-default btn-sm" onclick ="openActiveSandModal()" style="margin-left: 420px;background-color:#ccc;">Report</span>
                                     	   </div>
                                           <div class="row alignPad">
                                             <div class="col-lg-3">
                                               Active Stockyards<br/>
                                               <span id="activeSandCount">0</span>
                                             </div>
                                             <div class="col-lg-3 lightGrey">
                                               Inactive Stockyards<br/>
                                               0
                                             </div>
                                             <div class="col-lg-3">
                                               MDOs<br/>
                                               0
                                             </div>
                                             <div class="col-lg-3 lightGrey">
                                               MDO Vehicles<br/>
                                               0
                                             </div>
                                           </div>
                                       </div>
                                     </div>
                                  </div>
                      </div>
            </div>   
          </div>
  <div id="openOnlineSale" class="modal" data-backdrop="static" data-keyboard="false"><!--   class="modal fade" 12345  --> 
	<div class=""><!-- style="position: absolute; left: 2%; top: 52%; margin-top: -275px; width: 95%;"> --> 
		<div class="modal-content">
			<div class="modal-header" style="padding: 1px;">
				<h4 id="nome" class="modal-title">
					Online Sand Sales Report
				</h4>
				<button type="button" class="close" onclick="cancel()"  data-dismiss="modal">
					&times;
				</button>
			</div>
			<div class="modal-body" style="height: 500px; margin-bottom: 0px;overflow-y : auto;">
           <!--    <div id="datatable1" >  -->
        
	<!-- 	  <div class="col-md-12">
            <div class="col-md-5" style="display: inherit;">
               <div class="col-md-12">
                 <div class="col-md-3">
					<label for="staticEmail2" class="labelClass">
						Start Date
					</label>
				</div>
				<div class="col-md-6"
					style="margin-left: -4% !important;">
					<input type='text' id="dateInput1" />
				</div>
				</div>
			</div>

			<div class="col-md-5" style="display: inherit;">
			 <div class="col-md-12">
			    <div class="col-md-3">
					<label for="staticEmail2" class="labelClass">
						End Date
					</label>
				</div>	
				<div class="col-md-6"
					style="margin-left: -4% !important;">
					<input type='text' id="dateInput2" />
				</div>
				</div>
			</div>
			<div class="col-md-2" style="display: inherit;">
				<button type="button" class="btn btn-primary btn-sm" onclick="getReportDetails()">View</button>
			</div>
		 </div>  -->
		 <p></p>
      			 <table id = "onlineSaleTableId" class="table table-sm table-bordered table-striped" style="margin-bottom: 0px;">
						<thead>
							<tr>
								<th>
									Booking No
								</th>
								<th>
									Consumer Mobile No 
								</th>
								<th>
									From Place
								</th>
								<th>
									To Place
								</th>
								<th>
									Booked Sand Qty
								</th>
								<th>
									Dispatched Sand Qty
								</th>
								<th>
									Royalty
								</th>
								<th>
									GST
								</th>
								<th>
									Total Amount
								</th>
								<th>
									Remaining Sand Qty
								</th>
							</tr>
						</thead>
					</table>
	<!-- 		</div>  -->
			</div>
			<div class="modal-footer" style="text-align: center; padding: 8px;">
				<button type="reset" onclick="cancel()" class="btn btn-warning"
					style="background-color: #da2618 !important; border-color: #da2618 !important;"
					data-dismiss="modal">
					Cancel
				</button>
			</div>
		</div>
	</div>
</div>      

 <div id="sandStock" class="modal" data-backdrop="static" data-keyboard="false"><!--   class="modal fade" 12345  --> 
	<div class=""><!-- style="position: absolute; left: 2%; top: 52%; margin-top: -275px; width: 95%;"> --> 
		<div class="modal-content">
			<div class="modal-header" style="padding: 1px;">
				<h4 id="nome" class="modal-title">
					Sand Stock Report
				</h4>
				<button type="button" class="close" onclick="cancel()"  data-dismiss="modal">
					&times;
				</button>
			</div>
		 <div class="modal-body" style="height: 500px; margin-bottom: 0px;overflow-y : auto;">
		  <div class="col-md-12">
     <!--    <div class="col-md-5" style="display: inherit;">
               <div class="col-md-12">
				<div class="col-md-3">
					<label for="staticEmail2" class="labelClass">
						Start Date
					</label>
				</div>
				<div class="col-md-6"
					style="margin-left: -4% !important;">
					<input type='text' id="sandStockDateInput1" />
				</div>
				</div>
			</div>

			<div class="col-md-5" style="display: inherit;">
			 <div class="col-md-12">
				<div class="col-md-3">
					<label for="staticEmail2" class="labelClass">
						End Date
					</label>
				</div>
				<div class="col-md-6"
					style="margin-left: -4% !important;">
					<input type='text' id="sandStockDateInput2" />
				</div>
				</div>
			</div>  
			<div class="col-md-2" style="display: inherit;">
				<button type="button" class="btn btn-primary btn-sm" onclick="getSandStockReportDetails()">View</button>
			</div> -->
		 </div> 
		 <p></p>
      			 <table id = "sandStockTableId" class="table table-sm table-bordered table-striped" style="margin-bottom: 0px;">
						<thead>
							<tr>
								<th>
									Name
								</th>
								<th>
									Available Sand Qty
								</th>
								<th>
									Dispatched Sand Qty 
								</th>
								<th>
									Reserved Sand Qty
								</th>
							</tr>
						</thead>
					</table>
			</div>
			<div class="modal-footer" style="text-align: center; padding: 8px;">
				<button type="reset" onclick="cancel()" class="btn btn-warning"
					style="background-color: #da2618 !important; border-color: #da2618 !important;"
					data-dismiss="modal">
					Cancel
				</button>
			</div>
		</div>
	</div>
</div>   


 <div id="vehicleModal" class="modal" data-backdrop="static" data-keyboard="false"><!--   class="modal fade" 12345  --> 
	<div class=""><!-- style="position: absolute; left: 2%; top: 52%; margin-top: -275px; width: 95%;"> --> 
		<div class="modal-content">
			<div class="modal-header" style="padding: 1px;">
				<h4 id="nome" class="modal-title">
					Vehicles Report
				</h4>
				<button type="button" class="close" onclick="cancel()"  data-dismiss="modal">
					&times;
				</button>
			</div>
		 <div class="modal-body" style="height: 500px; margin-bottom: 0px;overflow-y : auto;">
	<!-- 	  <div class="col-md-12">
            <div class="col-md-5" style="display: inherit;">
               <div class="col-md-12">
				<div class="col-md-3">
					<label for="staticEmail2" class="labelClass">
						Start Date
					</label>
				</div>
				<div class="col-md-6"
					style="margin-left: -4% !important;">
					<input type='text' id="vehicleDateInput1" />
				</div>
				</div>
			</div>

			<div class="col-md-5" style="display: inherit;">
			 <div class="col-md-12">
				<div class="col-md-3">
					<label for="staticEmail2" class="labelClass">
						End Date
					</label>
				</div>
				<div class="col-md-6"
					style="margin-left: -4% !important;">
					<input type='text' id="vehicleDateInput2" />
				</div>
				</div>
			</div>
			<div class="col-md-2" style="display: inherit;">
				<button type="button" class="btn btn-primary btn-sm" onclick="getVehicleReportDetails()">View</button>
			</div>
		 </div>  -->
		 <p></p>
      			 <table id = "vehicleTableId" class="table table-sm table-bordered table-striped" style="margin-bottom: 0px;">
						<thead>
							<tr>
								<th>
									Vehicle No
								</th>
								<th>
									GPS Date Time
								</th>
						  		<th>
									GMT 
								</th>
								<th>
									Ignition
								</th>
								<th>
									Location 
								</th>
							</tr>
						</thead>
					</table>
			</div>
			<div class="modal-footer" style="text-align: center; padding: 8px;">
				<button type="reset" onclick="cancel()" class="btn btn-warning"
					style="background-color: #da2618 !important; border-color: #da2618 !important;"
					data-dismiss="modal">
					Cancel
				</button>
			</div>
		</div>
	</div>
</div>     


 <div id="tripModal" class="modal" data-backdrop="static" data-keyboard="false"><!--   class="modal fade" 12345  --> 
	<div class=""><!-- style="position: absolute; left: 2%; top: 52%; margin-top: -275px; width: 95%;"> --> 
		<div class="modal-content">
			<div class="modal-header" style="padding: 1px;">
				<h4 id="nome" class="modal-title">
					Trips Report
				</h4>
				<button type="button" class="close" onclick="cancel()"  data-dismiss="modal">
					&times;
				</button>
			</div>
		 <div class="modal-body" style="height: 500px; margin-bottom: 0px;overflow-y : auto;">
	<!-- 	  <div class="col-md-12">
            <div class="col-md-5" style="display: inherit;">
               <div class="col-md-12">
				<div class="col-md-3">
					<label for="staticEmail2" class="labelClass">
						Start Date
					</label>
				</div>
				<div class="col-md-6"
					style="margin-left: -4% !important;">
					<input type='text' id="tripDateInput1" />
				</div>
				</div>
			</div>

			<div class="col-md-5" style="display: inherit;">
			 <div class="col-md-12">
				<div class="col-md-3">
					<label for="staticEmail2" class="labelClass">
						End Date
					</label>
				</div>
				<div class="col-md-6"
					style="margin-left: -4% !important;">
					<input type='text' id="tripDateInput2" />
				</div>
				</div>
			</div>
			<div class="col-md-2" style="display: inherit;">
				<button type="button" class="btn btn-primary btn-sm" onclick="getTripReportDetails()">View</button>
			</div>
		 </div>   -->
		 <p></p>
      			 <table id = "tripTableId" class="table table-sm table-bordered table-striped" style="margin-bottom: 0px;">
						<thead>
							<tr>
								<th>
									Vehicle No
								</th>
								<th>
									Hub 
								</th>
								<th>
									Location
								</th>
							</tr>
						</thead>
					</table>
			</div>
			<div class="modal-footer" style="text-align: center; padding: 8px;">
				<button type="reset" onclick="cancel()" class="btn btn-warning"
					style="background-color: #da2618 !important; border-color: #da2618 !important;"
					data-dismiss="modal">
					Cancel
				</button>
			</div>
		</div>
	</div>
</div>      


 <div id="stockyardOperationModal" class="modal" data-backdrop="static" data-keyboard="false"><!--   class="modal fade" 12345  --> 
	<div class=""><!-- style="position: absolute; left: 2%; top: 52%; margin-top: -275px; width: 95%;"> --> 
		<div class="modal-content">
			<div class="modal-header" style="padding: 1px;">
				<h4 id="nome" class="modal-title">
					Stockyard Operations Report
				</h4>
				<button type="button" class="close" onclick="cancel()"  data-dismiss="modal">
					&times;
				</button>
			</div>
		 <div class="modal-body" style="height: 500px; margin-bottom: 0px;overflow-y : auto;">
		<!--   <div class="col-md-12">
            <div class="col-md-5" style="display: inherit;">
               <div class="col-md-12">
				<div class="col-md-3">
					<label for="staticEmail2" class="labelClass">
						Start Date
					</label>
				</div>
				<div class="col-md-6"
					style="margin-left: -4% !important;">
					<input type='text' id="stockyardDateInput1" />
				</div>
				</div>
			</div>

			<div class="col-md-5" style="display: inherit;">
			 <div class="col-md-12">
				<div class="col-md-3">
					<label for="staticEmail2" class="labelClass">
						End Date
					</label>
				</div>
				<div class="col-md-6"
					style="margin-left: -4% !important;">
					<input type='text' id="stockyardDateInput2" />
				</div>
				</div>
			</div>
			<div class="col-md-2" style="display: inherit;">
				<button type="button" class="btn btn-primary btn-sm" onclick="getStockyardReportDetails()">View</button>
			</div>
		 </div>  -->
		 <p></p>
      			 <table id = "stockyardTableId" class="table table-sm table-bordered table-striped" style="margin-bottom: 0px;">
						<thead>
							<tr>
								<th>
									Token No
								</th>
								<th>
									Vehicle No 
								</th>
								<th>
									Quantity Taken
								</th>
								<th>
								    Vehicle Type
								</th>
								<th>
								    Status
								</th>
							</tr>
						</thead>
					</table>
			</div>
			<div class="modal-footer" style="text-align: center; padding: 8px;">
				<button type="reset" onclick="cancel()" class="btn btn-warning"
					style="background-color: #da2618 !important; border-color: #da2618 !important;"
					data-dismiss="modal">
					Cancel
				</button>
			</div>
		</div>
	</div>
</div>   


 <div id="activeSandModal" class="modal" data-backdrop="static" data-keyboard="false"><!--   class="modal fade" 12345  --> 
	<div class=""><!-- style="position: absolute; left: 2%; top: 52%; margin-top: -275px; width: 95%;"> --> 
		<div class="modal-content">
			<div class="modal-header" style="padding: 1px;">
				<h4 id="nome" class="modal-title">
					Active Sand Operations Report
				</h4>
				<button type="button" class="close" onclick="cancel()"  data-dismiss="modal">
					&times;
				</button>
			</div>
		 <div class="modal-body" style="height: 500px; margin-bottom: 0px;overflow-y : auto;">
<!-- 		  <div class="col-md-12">
            <div class="col-md-5" style="display: inherit;">
               <div class="col-md-12">
				<div class="col-md-3">
					<label for="staticEmail2" class="labelClass">
						Start Date
					</label>
				</div>
				<div class="col-md-6"
					style="margin-left: -4% !important;">
					<input type='text' id="activeSandDateInput1" />
				</div>
				</div>
			</div>

			<div class="col-md-5" style="display: inherit;">
			 <div class="col-md-12">
				<div class="col-md-3">
					<label for="staticEmail2" class="labelClass">
						End Date
					</label>
				</div>
				<div class="col-md-6"
					style="margin-left: -4% !important;">
					<input type='text' id="activeSandDateInput2" />
				</div>
				</div>
			</div>
			<div class="col-md-2" style="display: inherit;">
				<button type="button" class="btn btn-primary btn-sm" onclick="getActiveSandReportDetails()">View</button>
			</div>    
		 </div>-->
		 <p></p>
      			 <table id = "activeSandTableId" class="table table-sm table-bordered table-striped" style="margin-bottom: 0px;">
						<thead>
							<tr>
								<th>
									Hub Name
								</th>
								<th>
									Address 
								</th>
								<th>
									Available Sand Qty
								</th>
								<th>
									Reserved Sand Qty
								</th>
								<th>
									Dispatched Sand Qty
								</th>
							</tr>
						</thead>
					</table>
			</div>
			<div class="modal-footer" style="text-align: center; padding: 8px;">
				<button type="reset" onclick="cancel()" class="btn btn-warning"
					style="background-color: #da2618 !important; border-color: #da2618 !important;"
					data-dismiss="modal">
					Cancel
				</button>
			</div>
		</div>
	</div>
</div>      

<!--<script src="https://maps.googleapis.com/maps/api/js?v=3.exp&libraries=places,geometry&key=AIzaSyCyYEUU6pc21YSjckg3bB41p2EFLCDARGg&region=IN">-->
<!--</script>-->
<script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
<script src="//code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
<script><!--

var status = 0;
var data;
var currentInfoWin = null;
getJSMDCDistrict();

function openModal(){
	if(document.getElementById("districtDropDownId").value == "Select District"){
		sweetAlert("Please Select District");
		return;
	}
	if(document.getElementById("stockyardDropDownId").value == "Select Stockyard"){
		sweetAlert("Please Select Stockyard");
		return;
	}
	getReportDetails();
	$("#openOnlineSale").modal('show');
	
}
function openSandStockModal(){
	if(document.getElementById("districtDropDownId").value == "Select District"){
		sweetAlert("Please Select District");
		return;
	}
	if(document.getElementById("stockyardDropDownId").value == "Select Stockyard"){
		sweetAlert("Please Select Stockyard");
		return;
	}
	getSandStockReportDetails();
	$("#sandStock").modal('show');
	
}
function openVehicleModal(){
	if(document.getElementById("districtDropDownId").value == "Select District"){
		sweetAlert("Please Select District");
		return;
	}
	if(document.getElementById("stockyardDropDownId").value == "Select Stockyard"){
		sweetAlert("Please Select Stockyard");
		return;
	}
	$("#vehicleModal").modal('show');
	getVehicleReportDetails();
}
function openTripModal(){
	if(document.getElementById("districtDropDownId").value == "Select District"){
		sweetAlert("Please Select District");
		return;
	}
	if(document.getElementById("stockyardDropDownId").value == "Select Stockyard"){
		sweetAlert("Please Select Stockyard");
		return;
	}
	getTripReportDetails();
	$("#tripModal").modal('show');
}
function openStockyardModal(){
	if(document.getElementById("districtDropDownId").value == "Select District"){
		sweetAlert("Please Select District");
		return;
	}
	if(document.getElementById("stockyardDropDownId").value == "Select Stockyard"){
		sweetAlert("Please Select Stockyard");
		return;
	}
	getStockyardReportDetails();
	$("#stockyardOperationModal").modal('show');
	
}
function openActiveSandModal(){
	if(document.getElementById("districtDropDownId").value == "Select District"){
		sweetAlert("Please Select District");
		return;
	}
	if(document.getElementById("stockyardDropDownId").value == "Select Stockyard"){
		sweetAlert("Please Select Stockyard");
		return;
	}
	getActiveSandReportDetails();
	$("#activeSandModal").modal('show');
}
function getJSMDCDistrict()
{
          $.ajax({
             type: "GET",
              url: '<%=request.getContextPath()%>/JSMDCDashboardAction.do?param=getJSMDCDistict',
             "dataSrc": "getJSMDCDistrict",
             success: function(result) {
              data =  JSON.parse(result);
				for(var i=0;i<data.districts.length;i++)
				{
				$("#districtDropDownId").append('<option value="'+data.districts[i].id+'">'+data.districts[i].districtName+'</option>');
				}
         }
         });
       }
       
function getJSMDCStockyard()
{
		resetDashboard();
		var districtId = document.getElementById("districtDropDownId").value;
			$("#stockyardDropDownId").empty();
			$("#stockyardDropDownId").append('<option selected disabled>Select Stockyard</option>');
		//	$("#stockyardDropDownId").append('<option value="0">All Stockyards</option>');
          $.ajax({
             type: "POST",
              url: '<%=request.getContextPath()%>/JSMDCDashboardAction.do?param=getJSMDCStockyard&districtId='+districtId,
             "dataSrc": "getJSMDCStockyard",
             success: function(result) {
              data =  JSON.parse(result);
				for(var i=0;i<data.stockyards.length;i++)
				{
				$("#stockyardDropDownId").append('<option value="'+data.stockyards[i].id+'" hubId="'+data.stockyards[i].hubId+'">'+data.stockyards[i].stockyard+'</option>');
				}
         }
         });
       } 
       var customerIds="";
function getJSMDCStockyardInfo()
{
	resetDashboard();
	var stockyardId = document.getElementById("stockyardDropDownId").value;
          $.ajax({
             type: "POST",
              url: '<%=request.getContextPath()%>/JSMDCDashboardAction.do?param=getJSMDCStockyardInfo&stockyardId='+stockyardId,
             "dataSrc": "getJSMDCStockyardInfo",
             success: function(result) {
              data =  JSON.parse(result);
              console.log(data);
				$("#sandStockTotal").html((data.stockyardInfo[0].ReservedSandQuantity+data.stockyardInfo[0].AvailableSandQuantity));				
				$("#sandStockBooked").html(data.stockyardInfo[0].ReservedSandQuantity);				
				$("#sandStockAvailable").html(data.stockyardInfo[0].AvailableSandQuantity);
				$("#sandStockDispatched").html(data.stockyardInfo[0].DispatchedSandQuantity);
				$("#tripTotal").html(data.stockyardInfo[0].tripCount);
				$("#totalAmount").html(data.stockyardInfo[0].totalAmmount);				
				$("#onlineBooked").html(data.stockyardInfo[0].totalDispatchedSandQuantity);				
				$("#onlineRoyalty").html(data.stockyardInfo[0].Royalty);
				$("#onlineGST").html(data.stockyardInfo[0].GSTFee);
				$("#totalVehicle").html(data.stockyardInfo[1].totalVehicle);				
				$("#nonCommunicating").html(data.stockyardInfo[1].NonCommunicating);				
				$("#communicating").html(data.stockyardInfo[1].communicating);
				$("#onTrip").html(data.stockyardInfo[1].onTrip);
				$("#tokens").html(data.stockyardInfo[2].tokens);				
				$("#delivery").html(data.stockyardInfo[2].delivery);				
				$("#loadingVehicles").html(data.stockyardInfo[2].loadingVehicles);
				$("#reprints").html(data.stockyardInfo[3].reprintTokenHistory);
				$("#activeSandCount").html(data.stockyardInfo[0].activeSandCount);
				customerIds=data.stockyardInfo[1].customersIds;
         }
         });
       }       
function resetDashboard()
{
				$("#sandStockTotal").html(0);				
				$("#sandStockBooked").html(0);				
				$("#sandStockAvailable").html(0);
				$("#sandStockDispatched").html(0);
				$("#tripTotal").html(0);
				$("#totalAmount").html(0);				
				$("#onlineBooked").html(0);				
				$("#onlineRoyalty").html(0);
				$("#onlineGST").html(0);
				$("#totalVehicle").html(0);				
				$("#nonCommunicating").html(0);				
				$("#communicating").html(0);
				$("#onTrip").html(0);
				$("#tokens").html(0);				
				$("#delivery").html(0);				
				$("#loadingVehicles").html(0);
				$("#reprints").html(0);
				$("#activeSandCount").html(0);
}

      var map;
      var info;
      var initial = true;
    var markerClusterArray = [];
    var markerClusterArray1 = [];
    var infowindow;
    var table;
    var $mpContainer = $('#map');
      var startDate="";
    var endDate = "";

  var currentDate = new Date();
    var yesterdayDate = new Date();
         yesterdayDate.setDate(yesterdayDate.getDate() - 1);
         yesterdayDate.setHours(00);
		 yesterdayDate.setMinutes(00);
		 yesterdayDate.setSeconds(00);
		 currentDate.setHours(23);
		 currentDate.setMinutes(59);
		 currentDate.setSeconds(59);
    $( document ).ready(function() {
    $('#onlineSaleTableId').DataTable({
        fixedHeader: true
    });  
    $('#sandStockTableId').DataTable({
    	fixedHeader: true
	});
	$('#vehicleTableId').DataTable({
    	fixedHeader: true
	});
	$('#tripTableId').DataTable({
    	fixedHeader: true
	});
	$('#stockyardTableId').DataTable({
    	fixedHeader: true
	});
	$('#activeSandTableId').DataTable({
    	fixedHeader: true
	}); 
    $("#openOnlineSale").modal('hide');
    $("#sandStock").modal('hide');
    $("#vehicleModal").modal('hide');
    $("#tripModal").modal('hide');
    $("#stockyardOperationModal").modal('hide');
    $("#activeSandModal").modal('hide');
    
        $("#map").css("height", $(window).height()-220);
        var heightVal = ($("#map").height())/1.8;
        $("#columnContainer").css("height", $(window).height()-200);
        $('#districtDropDownId').select2();
        $('#stockyardDropDownId').select2();
     /*   
   		$("#dateInput1").jqxDateTimeInput({ theme: "arctic", formatString: "dd/MM/yyyy HH:mm:ss", showTimeButton: true, width: '100%', height: '25px', max: new Date()});
   		$('#dateInput1 ').jqxDateTimeInput('setDate', yesterdayDate);
   		$("#dateInput2").jqxDateTimeInput({ theme: "arctic", formatString: "dd/MM/yyyy HH:mm:ss", showTimeButton: true, width: '100%', height: '25px', max: currentDate});
   		$('#dateInput2 ').jqxDateTimeInput('setDate', currentDate);  
   		
   		$("#sandStockDateInput1").jqxDateTimeInput({ theme: "arctic", formatString: "dd/MM/yyyy HH:mm:ss", showTimeButton: true, width: '100%', height: '25px', max: new Date()});
   		$('#sandStockDateInput1 ').jqxDateTimeInput('setDate', yesterdayDate);
   		$("#sandStockDateInput2").jqxDateTimeInput({ theme: "arctic", formatString: "dd/MM/yyyy HH:mm:ss", showTimeButton: true, width: '100%', height: '25px', max: currentDate});
   		$('#sandStockDateInput2 ').jqxDateTimeInput('setDate', currentDate);    
   		
   		$("#vehicleDateInput1").jqxDateTimeInput({ theme: "arctic", formatString: "dd/MM/yyyy HH:mm:ss", showTimeButton: true, width: '100%', height: '25px', max: new Date()});
   		$('#vehicleDateInput1 ').jqxDateTimeInput('setDate', yesterdayDate);
   		$("#vehicleDateInput2").jqxDateTimeInput({ theme: "arctic", formatString: "dd/MM/yyyy HH:mm:ss", showTimeButton: true, width: '100%', height: '25px', max: currentDate});
   		$('#vehicleDateInput2 ').jqxDateTimeInput('setDate', currentDate);     
   		
   		$("#tripDateInput1").jqxDateTimeInput({ theme: "arctic", formatString: "dd/MM/yyyy HH:mm:ss", showTimeButton: true, width: '100%', height: '25px', max: new Date()});
   		$('#tripDateInput1 ').jqxDateTimeInput('setDate', yesterdayDate);
   		$("#tripDateInput2").jqxDateTimeInput({ theme: "arctic", formatString: "dd/MM/yyyy HH:mm:ss", showTimeButton: true, width: '100%', height: '25px', max: currentDate});
   		$('#tripDateInput2 ').jqxDateTimeInput('setDate', currentDate);  
   		
   	/*	$("#stockyardDateInput1").jqxDateTimeInput({ theme: "arctic", formatString: "dd/MM/yyyy HH:mm:ss", showTimeButton: true, width: '100%', height: '25px', max: new Date()});
   		$('#stockyardDateInput1 ').jqxDateTimeInput('setDate', yesterdayDate);
   		$("#stockyardDateInput2").jqxDateTimeInput({ theme: "arctic", formatString: "dd/MM/yyyy HH:mm:ss", showTimeButton: true, width: '100%', height: '25px', max: currentDate});
   		$('#stockyardDateInput2 ').jqxDateTimeInput('setDate', currentDate);      
   		 
   		$("#activeSandDateInput1").jqxDateTimeInput({ theme: "arctic", formatString: "dd/MM/yyyy HH:mm:ss", showTimeButton: true, width: '100%', height: '25px', max: new Date()});
   		$('#activeSandDateInput1 ').jqxDateTimeInput('setDate', yesterdayDate);
   		$("#activeSandDateInput2").jqxDateTimeInput({ theme: "arctic", formatString: "dd/MM/yyyy HH:mm:ss", showTimeButton: true, width: '100%', height: '25px', max: currentDate});
   		$('#activeSandDateInput2 ').jqxDateTimeInput('setDate', currentDate);   */  		
    });

    function refreshNumbers(){
	var stockyardId = document.getElementById("stockyardDropDownId").value;
      $.ajax({
              type: "POST",
              url: '<%=request.getContextPath()%>/JSMDCDashboardAction.do?param=getJSMDCStockyardInfo&stockyardId='+stockyardId,
             "dataSrc": "vehicleCounts",
             success: function(result) {
              data =  JSON.parse(result);
            $("#sandStockTotal").html(data.stockyardInfo[0].capacityOfStockyard);				
		 	$("#sandStockBooked").html(data.stockyardInfo[0].reservedSandQuantity);				
		 	$("#sandStockAvailable").html(data.stockyardInfo[0].availableSandQuantity);tripTotal
			$("#sandStockDispatched").html(data.stockyardInfo[0].dispatchedSandQuantity);
			$("#tripTotal").html(data.stockyardInfo[0].tripCount);
          }
      })
    }



    // ************* Map Details

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
        zoom: 7
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
        //var trafficLayer = new L.TrafficLayer();
        //trafficLayer.setMap(map);
       /* var geocoder = new L.Geocoder();


        geocoder.geocode( {'address' : "India"}, function(results, status) {
            if (status == L.GeocoderStatus.OK) {
                map.setCenter(results[0].geometry.location);
            }
        });*/

	
	$.ajax({
            url: '<%=request.getContextPath()%>/JSMDCDashboardAction.do?param=getJSMDCStockyardDetails',
            type:'get',
              success: function(result) {
              result=JSON.parse(result);
              result=result.stockyardInfo;
                for (var i = 0; i < result.length; i++) {
                 //   $('#select-menu').append($("<option></option>").attr("value", result[i].id).text(result[i].Name).attr("available", result[i].availableSandQuantity).attr("latitude", result[i].latitude).attr("longitude", result[i].longitude));
                    $('#stockyardDropDownId').append($("<option></option>").attr("value", result[i].Id).text(result[i].Name).attr("available", result[i].AvailableSandQuantity).attr("latitude", result[i].Latitude).attr("longitude", result[i].Longitude));

                        
                var pos = new L.LatLng(result[i].Latitude,result[i].Longitude);
                var marker = new L.Marker(pos,{
                }).addTo(map);
               
                    // marker.setMap(map)
                    
                     var content = '<div id="myInfoDiv" class="blueGreyLight" seamless="seamless" scrolling="no" style="border: 1px solid #37474F;overflow:hidden;color: #000; line-height:100%; font-size:11px; font-family: sans-serif;padding:8px;">' +
                         '<table class="infoDiv">' +
                         '<tr><td style="padding:4px;" nowrap><b>Stockyard Name:&nbsp;&nbsp;</b></td><td>' + result[i].Name + '</td></tr>' +
                         '<tr><td style="padding:4px;" nowrap><b>District:&nbsp;&nbsp;</b></td><td>' + result[i].DistrictName + '</td></tr>' +
                         '<tr><td style="padding:4px;" nowrap><b>Available Stock:&nbsp;&nbsp;</b></td><td>' + result[i].AvailableSandQuantity + '</td></tr>' +                         
                         '<tr><td style="padding:4px;" nowrap><b>Reserved Quantity:&nbsp;&nbsp;</b></td><td>' + result[i].ReservedSandQuantity + '</td></tr>' +
                         '</table>' +
                         '</div>';
                         
                           marker.bindPopup(content);    
					      // markerCluster.addLayer(marker);
					       markerClusterArray.push(marker);
					
                  }
                  // map.addLayer(markerCluster);
                  $('#districtDropDownId').select2();
           }
        })
    }

    initialize();
    var markerCluster;
    
    
         
function getReportDetails()
{
  //alert("inside getReportDetails()");
  var stockyardId = document.getElementById("stockyardDropDownId").value;
  
     /*    if (document.getElementById("dateInput1").value == ""){
			sweetAlert("Please select Start Date");
		    return;
		}else if(document.getElementById("dateInput2").value == ""){
			sweetAlert("Please select End Date");
		    return;
		}else{
			startDate = document.getElementById("dateInput1").value;
			endDate = document.getElementById("dateInput2").value;
			var dd = startDate.split("/");
	        var ed = endDate.split("/");
	        var parsedStartDate = new Date(dd[1] + "/" + dd[0] + "/" + dd[2]);
	        var parsedEndDate = new Date(ed[1] + "/" + ed[0] + "/" + ed[2]);
				if (parsedStartDate > parsedEndDate) {
		        	sweetAlert("End date should be greater than Start date");
		       	    document.getElementById("dateInput2").value = currentDate;
		       	    return;
		   		}
		}		
	
	
	 startDate = document.getElementById("dateInput1").value;
	 endDate = document.getElementById("dateInput2").value;  */
        if ($.fn.DataTable.isDataTable('#onlineSaleTableId')) {
            $('#onlineSaleTableId').DataTable().clear().destroy();
        }
       var table = $('#onlineSaleTableId').DataTable({
         "ajax": {
               url: '<%=request.getContextPath()%>/JSMDCDashboardAction.do?param=getReportDetails&stockyardId='+stockyardId,
             "data": {
               //  startDate: startDate,
				// endDate: endDate
             },
             "dataSrc": "reportDetails"
         },
         "bLengthChange": false,
         "dom": 'Bfrtip',
         "scrollY": 200,
         
         "fixedHeader": true,
         "buttons": [{extend:'pageLength'},
        	 				{extend:'excel',
        	 				text: 'Export to Excel',
        	 				title: 'Online Sand Sales Report  ',
                            className: 'btn btn-primary',
                            exportOptions: {
			                 columns: ':visible'
			            }
        	 		}
        	 	],
         "columns": [{
             "data": "bookingId"
         },{
             "data": "consumerMobileNo"
         },{
             "data": "fromPlace"
         },{
             "data": "toPlace" 
         },{
             "data": "bookedSandQty"
         },{
             "data": "dispatchedSandQty" 
         },{
         	 "data": "royalty"
         },{
         	 "data": "gstFee"
         },{
         	 "data": "totalAmount"
         },{
         	 "data": "remainingSandQuantity"
         }]
     });
    // jQuery('.dataTable').wrap('<div class="dataTables_scroll" />');
         
         
       }       
       
              
function getSandStockReportDetails()
{
  		var stockyardId = document.getElementById("stockyardDropDownId").value;
      /*  if (document.getElementById("sandStockDateInput1").value == ""){
			sweetAlert("Please select Start Date");
		    return;
		}else if(document.getElementById("sandStockDateInput2").value == ""){
			sweetAlert("Please select End Date");
		    return;
		}else{
			startDate = document.getElementById("sandStockDateInput1").value;
			endDate = document.getElementById("sandStockDateInput2").value;
			var dd = startDate.split("/");
	        var ed = endDate.split("/");
	        var parsedStartDate = new Date(dd[1] + "/" + dd[0] + "/" + dd[2]);
	        var parsedEndDate = new Date(ed[1] + "/" + ed[0] + "/" + ed[2]);
				if (parsedStartDate > parsedEndDate) {
		        	sweetAlert("End date should be greater than Start date");
		       	    document.getElementById("sandStockDateInput2").value = currentDate;
		       	    return;
		   		}
		}	
	
		startDate = document.getElementById("sandStockDateInput1").value;
	    endDate = document.getElementById("sandStockDateInput2").value;  */
			//alert("sd : " + document.getElementById("dateInput1").value + ", ed " + document.getElementById("dateInput2").value);
          if ($.fn.DataTable.isDataTable('#sandStockTableId')) {
            $('#sandStockTableId').DataTable().destroy();
          }
       
     	 var table = $('#sandStockTableId').DataTable({
    
         "ajax": {
               url: '<%=request.getContextPath()%>/JSMDCDashboardAction.do?param=getSandStockReportDetails&stockyardId='+stockyardId,
             "data": {
                 //startDate: startDate,
				 //endDate: endDate
             },
             "dataSrc": "sandReportDetails"
         },
         "bLengthChange": false,
         "dom": 'Bfrtip',
         "scrollY": 200,
         "fixedHeader": true, 
         "buttons": [{extend:'pageLength'},
        	 				{extend:'excel',
        	 				text: 'Export to Excel',
        	 				title: 'Sand Stock Report  ',
                            className: 'btn btn-primary',
                            exportOptions: {
			                 columns: ':visible'
			            }
        	 		}
        	 	],
         "columns": [{
             "data": "name" 
         },{
             "data": "availableSandQty"
         },{
             "data": "dispatchedSandQty"
         },{
             "data": "reservedSandQty"
         }]
     });
    // jQuery('.dataTable').wrap('<div class="dataTables_scroll" />');
    }       
    
             
function getVehicleReportDetails()
{
  		var stockyardId = document.getElementById("stockyardDropDownId").value;
      /*  if (document.getElementById("vehicleDateInput1").value == ""){
			sweetAlert("Please select Start Date");
		    return;
		}else if(document.getElementById("vehicleDateInput2").value == ""){
			sweetAlert("Please select End Date");
		    return;
		}else{
			startDate = document.getElementById("vehicleDateInput1").value;
			endDate = document.getElementById("vehicleDateInput2").value;
			var dd = startDate.split("/");
	        var ed = endDate.split("/");
	        var parsedStartDate = new Date(dd[1] + "/" + dd[0] + "/" + dd[2]);
	        var parsedEndDate = new Date(ed[1] + "/" + ed[0] + "/" + ed[2]);
				if (parsedStartDate > parsedEndDate) {
		        	sweetAlert("End date should be greater than Start date");
		       	    document.getElementById("vehicleDateInput2").value = currentDate;
		       	    return;
		   		}
		}	
	
		startDate = document.getElementById("vehicleDateInput1").value;
	    endDate = document.getElementById("vehicleDateInput2").value;  */
          if ($.fn.DataTable.isDataTable('#vehicleTableId')) {
            $('#vehicleTableId').DataTable().destroy();
          }
    // setTimeout(function(){ 
     	 var table = $('#vehicleTableId').DataTable({
    
         "ajax": {
               url: '<%=request.getContextPath()%>/JSMDCDashboardAction.do?param=getVehicleReportDetails&stockyardId='+stockyardId+'&customerIds='+customerIds,
             "data": {
                // startDate: startDate,
				// endDate: endDate
             },
             "dataSrc": "vehicleReportDetails"
         },
         "bLengthChange": false,
         "dom": 'Bfrtip',
         "scrollY": 200,
         "fixedHeader": true,
         "buttons": [{extend:'pageLength'},
        	 				{extend:'excel',
        	 				text: 'Export to Excel',
        	 				title: 'Vehicles Report  ',
                            className: 'btn btn-primary',
                            exportOptions: {
			                 columns: ':visible'
			            }
        	 		}
        	 	],
         "columns": [{
             "data": "registrationNo"
         },{
             "data": "gpsDateTime"
         },{
             "data": "gmt"		
         },{
             "data": "ignition"
         },{
             "data": "location"		
         }]
     });
    // jQuery('.dataTable').wrap('<div class="dataTables_scroll" />');
     //},1000);
    }  
    
    function getTripReportDetails()
	{
  		var stockyardId = document.getElementById("stockyardDropDownId").value;
  /*      if (document.getElementById("tripDateInput1").value == ""){
			sweetAlert("Please select Start Date");
		    return;
		}else if(document.getElementById("tripDateInput2").value == ""){
			sweetAlert("Please select End Date");
		    return;
		}else{
			startDate = document.getElementById("tripDateInput1").value;
			endDate = document.getElementById("tripDateInput2").value;
			var dd = startDate.split("/");
	        var ed = endDate.split("/");
	        var parsedStartDate = new Date(dd[1] + "/" + dd[0] + "/" + dd[2]);
	        var parsedEndDate = new Date(ed[1] + "/" + ed[0] + "/" + ed[2]);
				if (parsedStartDate > parsedEndDate) {
		        	sweetAlert("End date should be greater than Start date");
		       	    document.getElementById("tripDateInput2").value = currentDate;
		       	    return;
		   		}
		}	
	
		startDate = document.getElementById("tripDateInput1").value;
	    endDate = document.getElementById("tripDateInput2").value;  */
          if ($.fn.DataTable.isDataTable('#tripTableId')) {
            $('#tripTableId').DataTable().destroy();
          }
       
     	 var table = $('#tripTableId').DataTable({
    
         "ajax": {
               url: '<%=request.getContextPath()%>/JSMDCDashboardAction.do?param=getTripReportDetails&stockyardId='+stockyardId,
             "data": {
                 startDate: startDate,
				 endDate: endDate
             },
             "dataSrc": "tripReportDetails"
         },
         "bLengthChange": false,
         "dom": 'Bfrtip',
         "scrollY": 200,
         "fixedHeader": true, 
         "buttons": [{extend:'pageLength'},
        	 				{extend:'excel',
        	 				text: 'Export to Excel',
        	 				title: 'Trips Report  ',
                            className: 'btn btn-primary',
                            exportOptions: {
			                 columns: ':visible'
			            }
        	 		}
        	 	],
         "columns": [{
             "data": "registrationNo"
         },{
             "data": "hubId"
         },{
             "data": "location"
         }]
     });
     //jQuery('.dataTable').wrap('<div class="dataTables_scroll" />');
    }           
    
    function getStockyardReportDetails()
	{
  		var stockyardId = document.getElementById("stockyardDropDownId").value;
   /*     if (document.getElementById("stockyardDateInput1").value == ""){
			sweetAlert("Please select Start Date");
		    return;
		}else if(document.getElementById("stockyardDateInput2").value == ""){
			sweetAlert("Please select End Date");
		    return;
		}else{
			startDate = document.getElementById("stockyardDateInput1").value;
			endDate = document.getElementById("stockyardDateInput2").value;
			var dd = startDate.split("/");
	        var ed = endDate.split("/");
	        var parsedStartDate = new Date(dd[1] + "/" + dd[0] + "/" + dd[2]);
	        var parsedEndDate = new Date(ed[1] + "/" + ed[0] + "/" + ed[2]);
				if (parsedStartDate > parsedEndDate) {
		        	sweetAlert("End date should be greater than Start date");
		       	    document.getElementById("stockyardDateInput2").value = currentDate;
		       	    return;
		   		}
		}	
	
		startDate = document.getElementById("stockyardDateInput1").value;
	    endDate = document.getElementById("stockyardDateInput2").value; */
          if ($.fn.DataTable.isDataTable('#stockyardTableId')) {
            $('#stockyardTableId').DataTable().destroy();
          }
      
     	 var table = $('#stockyardTableId').DataTable({
    
         "ajax": {
               url: '<%=request.getContextPath()%>/JSMDCDashboardAction.do?param=getStockyardReportDetails&stockyardId='+stockyardId,
             "data": {
                 //startDate: startDate,
				 //endDate: endDate
             },
             "dataSrc": "stockyardReportDetails"
         },
         "bLengthChange": false,
         "dom": 'Bfrtip',
         "scrollY": 200,
         "fixedHeader": true, 
         "buttons": [{extend:'pageLength'},
        	 				{extend:'excel',
        	 				text: 'Export to Excel',
        	 				title: 'Stockyard Operations Report  ',
                            className: 'btn btn-primary',
                            exportOptions: {
			                 columns: ':visible'
			            }
        	 		}
        	 	],
         "columns": [{
             "data": "tokenNumber"
         },{
             "data": "vehicleNumber"
         },{
             "data": "qtyTaken"
         },{
             "data": "vehicleType" 
         },{
             "data": "status" 
         }]
     });
     //jQuery('.dataTable').wrap('<div class="dataTables_scroll" />');
    }         
    
    
    function getActiveSandReportDetails()
	{
  		var stockyardId = document.getElementById("stockyardDropDownId").value;
     /*   if (document.getElementById("activeSandDateInput1").value == ""){
			sweetAlert("Please select Start Date");
		    return;
		}else if(document.getElementById("activeSandDateInput2").value == ""){
			sweetAlert("Please select End Date");
		    return;
		}else{
			startDate = document.getElementById("activeSandDateInput1").value;
			endDate = document.getElementById("activeSandDateInput2").value;
			var dd = startDate.split("/");
	        var ed = endDate.split("/");
	        var parsedStartDate = new Date(dd[1] + "/" + dd[0] + "/" + dd[2]);
	        var parsedEndDate = new Date(ed[1] + "/" + ed[0] + "/" + ed[2]);
				if (parsedStartDate > parsedEndDate) {
		        	sweetAlert("End date should be greater than Start date");
		       	    document.getElementById("activeSandDateInput2").value = currentDate;
		       	    return;
		   		}
		}	
	
		startDate = document.getElementById("activeSandDateInput1").value;
	    endDate = document.getElementById("activeSandDateInput2").value;  */
           if ($.fn.DataTable.isDataTable('#activeSandTableId')) {
            $('#activeSandTableId').DataTable().destroy();
          }
      
     	 var table = $('#activeSandTableId').DataTable({
    
         "ajax": {
               url: '<%=request.getContextPath()%>/JSMDCDashboardAction.do?param=getActiveSandReportDetails&stockyardId='+stockyardId,
             "data": {
                 //startDate: startDate,
				 //endDate: endDate
             },
             "dataSrc": "activeSandReportDetails"
         },
         "bLengthChange": false,
         "dom": 'Bfrtip',
         "scrollY": 200,
         "fixedHeader": true, 
         "buttons": [{extend:'pageLength'},
        	 				{extend:'excel',
        	 				text: 'Export to Excel',
        	 				title: 'Active Sand Operations Report  ',
                            className: 'btn btn-primary',
                            exportOptions: {
			                 columns: ':visible'
			            }
        	 		}
        	 	],
         "columns": [{
             "data": "hubName"
         },{
             "data": "address"
         },{
             "data": "availableSandQty"
         },{
             "data": "reservedSandQty" 
         },{
             "data": "dispatchedSandQty"
         }]
     });
     //jQuery('.dataTable').wrap('<div class="dataTables_scroll" />');
    }           
     function cancel(){
  /*   	 $('#dateInput1 ').jqxDateTimeInput('setDate', yesterdayDate);
         $('#dateInput2 ').jqxDateTimeInput('setDate', currentDate);
         
         $('#sandStockDateInput1 ').jqxDateTimeInput('setDate', yesterdayDate);
         $('#sandStockDateInput2 ').jqxDateTimeInput('setDate', currentDate);
         
         $('#vehicleDateInput1 ').jqxDateTimeInput('setDate', yesterdayDate);
         $('#vehicleDateInput2 ').jqxDateTimeInput('setDate', currentDate);
         
         $('#tripDateInput1 ').jqxDateTimeInput('setDate', yesterdayDate);
         $('#tripDateInput2 ').jqxDateTimeInput('setDate', currentDate);
         
         $('#stockyardDateInput1 ').jqxDateTimeInput('setDate', yesterdayDate);
         $('#stockyardDateInput2 ').jqxDateTimeInput('setDate', currentDate);
         
         $('#activeSandDateInput1 ').jqxDateTimeInput('setDate', yesterdayDate);
         $('#activeSandDateInput2 ').jqxDateTimeInput('setDate', currentDate);  */
     }
 	
--></script>

  <jsp:include page="../Common/footer.jsp" />
