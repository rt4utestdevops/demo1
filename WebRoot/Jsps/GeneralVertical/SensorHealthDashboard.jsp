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
    int custId= loginInfo.getCustomerId();
    int loginUserId=loginInfo.getUserId();
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
      <script defer src="https://use.fontawesome.com/releases/v5.3.1/js/all.js" integrity="sha384-kW+oWsYx3YpxvjtZjFXqazFpA7UP/MbiY4jvs+RWZo2+N94PFZ36T6TFkc9O3qoB" crossorigin="anonymous"></script>
      <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.3.1/css/all.css" integrity="sha384-mzrmE5qonljUremFsqc01SB46JvROS7bZs3IO2EmfFsd15uHvIt+Y8vEf7N7fWAU" crossorigin="anonymous">
      <script src="https://cdn.datatables.net/1.10.16/js/jquery.dataTables.min.js"></script>
      <script src="https://cdn.datatables.net/1.10.16/js/dataTables.bootstrap4.min.js"></script>
      <script src="https://cdn.datatables.net/buttons/1.4.2/js/dataTables.buttons.min.js"></script>
      <script src="https://cdnjs.cloudflare.com/ajax/libs/jszip/3.1.3/jszip.min.js"></script>
      <script src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.32/pdfmake.min.js"></script>
      <script src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.32/vfs_fonts.js"></script>
      <script src="https://cdn.datatables.net/buttons/1.4.2/js/buttons.html5.min.js"></script>
      <script src = "https://cdn.datatables.net/select/1.2.3/js/dataTables.select.min.js"></script>
      <script src="https://cdn.datatables.net/fixedcolumns/3.2.3/js/dataTables.fixedColumns.min.js"></script>
      
      <script type="text/javascript" src="//cdn.datatables.net/plug-ins/1.10.19/sorting/time.js"></script>

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

         .modal {
            position: fixed;
            top: 10%;
            left: 30%;
            z-index: 1050;
            width: 800px;
            margin-left: -280px;
            margin-top:80px;
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
                background: #D32F2F; color: white !important; font-weight:bold !important ;
              }

              .mustard {
                background: #EABC00;

              }

              .blueGrey {
              /*background: #607D8B*/
            /* background: #37474F; */
            background: #ECEFF1;
            color:black !important;
          }
              .blueGreyLight {
                /* background: #ECEFF1; */
                background: #90A4AE;
              }

              .blueGreyDark {
                /* background: #ECEFF1; */
                background: #37474F;
              }



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
                font-weight:normal !important;
              }


              .centerText {
                text-align:center;
                position: relative;
                float: left;
                top: 50%;
                left: 50%;
                font-size:16px;
                color: white !important;
                transform: translate(-50%, -50%);
              }

              .centerTextRed {
                text-align:center;
                position: relative;
                cursor:pointer;
                float: left;
                top: 50%;
                left: 50%;
                font-size:20px;
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

.col-lg-4{padding: 1px;margin:0px;}
.col-lg-8{padding: 0px;margin:0px;}
.col-lg-6{padding: 1px;margin:0px;}

.center-view{
  top:40%;
  left:50%;
  position:fixed;
  height:200px;
  width:200px;
  z-index: 10000;

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

.green {
  background: #00897B ;
  color:white;
  border: 1px solid #00897B

}

.blue{
  background: #18519E;
  color:white;
  height:32px;
  width:200px;
  border-radius: 4px;
  border: 1px solid #18519E

}
.centerText{
	font-weight:700;
}
body{
	overflow-y:hidden;
}
.table {
    width: 100%;
    max-width: 100%;
    margin-bottom: 1rem;
    background-color: transparent;
    font-size: 12px;
}

      </style>

      <div class="center-view" style="display:none;" id="loading-div">
        <img src="../../Main/images/loading.gif" alt="">
      </div>

      <div class="row" id="columnContainer" style="margin-top:-18px;background: #37474F;color: white;padding: 8px;height: 34px;" >
        <div class="col-lg-3" style="padding-left:32px;">
             <i class="fas fa-broadcast-tower" style="font-size:20px;margin-right:16px;color:white;"></i>SENSOR
        </div>
        <div class="col-lg-3" style="text-align:center;font-weight: 600;">
             TOTAL COUNT
        </div>
        <div class="col-lg-3" style="text-align:center;font-weight: 600;">
             WORKING
        </div>
        <div class="col-lg-3" style="text-align:center;font-weight: 600;">
             NOT-WORKING
        </div>
      </div>

      <div class="row" id="columnContainer1">
        <div class="col-lg-3" style="margin-top:60px;padding-left:40px;font-weight: 700;">
            <i class="fas fa-map-marker-alt" style="font-size:24px;margin-right:16px;"></i> GPS/GPRS
        </div>
        <div class="col-lg-3">
          <div class="row" style="width:100%;padding:8px 16px 0px 16px;height:133px;">
                        <div class="col-lg-12 card" style="background:#90A4AE;">
                          <div class="row" style="height:42%;border-bottom:1px solid #ECEFF1;">
                             <div class="col-lg-12">
                               <div class="centerText" title="Total GPRS" id="totalGPRS">0</div>
                              </div>
                             </div>
                           <div class="row" style="height:58%;">
                              <div class="col-lg-6 blueGreyLight" style="border-right:1px solid white;">
                                <div class="row" style="height:100%;">
                                   <div class="col-lg-12">
                                      <div class="centerText" style="padding-top:24px;" id="totalDryGPRS" title="Dry GPRS">0</div>
                                      <div class="headerText blueGrey"><span style="margin-left:-16px;font-weight: 500;">DRY</span></div>
                                   </div>
                                 </div>
                              </div>
                              <div class="col-lg-6 ">
                                <div class="row" style="height:100%;">
                                   <div class="col-lg-12">
                                     <div class="centerText" style="padding-top:24px;left:53%" id="totalTCLGPRS" title="TCL GPRS">0</div>
                                         <div class="headerText blueGrey"><span style="margin-left:-16px;font-weight: 500;">TCL</span></div>
                                   </div>
                                 </div>
                              </div>
                            </div>
                        </div>
            </div>
        </div>
        <div class="col-lg-3">
          <div class="row" style="width:100%;padding:8px 16px 0px 16px;height:133px;">
                        <div class="col-lg-12 card" style="background: #92D050;">
                          <div class="row" style="height:42%;border-bottom:1px solid #ECEFF1;">
                             <div class="col-lg-12">
                               <div class="centerText" title="Total GPRS" id="workingGPRS">0</div>
                              </div>
                             </div>
                           <div class="row" style="height:58%;">
                              <div class="col-lg-6" style="border-right:1px solid white;">
                                <div class="row" style="height:100%;">
                                   <div class="col-lg-12">
                                      <div class="centerText" style="padding-top:24px;" id="workingDryGPRS" title="Dry GPRS">0</div>
                                      <div class="headerText blueGrey"><span style="margin-left:-16px;font-weight: 500;">DRY</span></div>
                                   </div>
                                 </div>
                              </div>
                              <div class="col-lg-6 ">
                                <div class="row" style="height:100%;">
                                   <div class="col-lg-12">
                                     <div class="centerText" style="padding-top:24px;left:53%" id="workingTCLGPRS" title="TCL GPRS">0</div>
                                         <div class="headerText blueGrey"><span style="margin-left:-16px;font-weight: 500;">TCL</span></div>
                                   </div>
                                 </div>
                              </div>
                            </div>
                        </div>
            </div>
        </div>
        <div class="col-lg-3">
          <div class="row" style="width:100%;padding:8px 16px 0px 16px;height:133px;">
                        <div class="col-lg-12 card" style="background: #D32F2F; color: white !important; font-weight:bold !important ;">
                          <div class="row" style="height:42%;border-bottom:1px solid #ECEFF1;">
                             <div class="col-lg-12">
                               <div class="centerTextRed" title="Total GPRS" onClick="javascript:alertOnClick(1,'TOTAL','GPS Total Alert')" id="notWorkingGPRS">0</div>
                              </div>
                             </div>
                           <div class="row" style="height:58%;">
                              <div class="col-lg-6" style="border-right:1px solid white;">
                                <div class="row" style="height:100%;">
                                   <div class="col-lg-12">
                                      <div class="centerTextRed" style="padding-top:24px;" onClick="javascript:alertOnClick(1,'DRY','GPS Dry Alert')" id="notWorkingDryGPRS" title="Dry GPRS">0</div>
                                      <div class="headerText blueGrey"><span style="margin-left:-16px;font-weight: 500;">DRY</span></div>
                                   </div>
                                 </div>
                              </div>
                              <div class="col-lg-6 ">
                                <div class="row" style="height:100%;">
                                   <div class="col-lg-12">
                                     <div class="centerTextRed" style="padding-top:24px;left:53%" onClick="javascript:alertOnClick(1,'TCL','GPS TCL Alert')" id="notWorkingTCLGPRS" title="TCL GPRS">0</div>
                                         <div class="headerText blueGrey"><span style="margin-left:-16px;font-weight: 500;">TCL</span></div>
                                   </div>
                                 </div>
                              </div>
                            </div>
                        </div>
            </div>
        </div>
      </div>

      <div class="row" id="columnContainer2">
        <div class="col-lg-3" style="margin-top:60px;padding-left:40px;font-weight: 700;">
            <i class="fas fa-door-open" style="font-size:24px;margin-right:16px;"></i> DOOR SENSOR
        </div>
        <div class="col-lg-3">
          <div class="row" style="width:100%;padding:0px 16px;height:133px;">
                        <div class="col-lg-12 card" style="background:#90A4AE;">
                          <div class="row" style="height:42%;border-bottom:1px solid #ECEFF1;">
                             <div class="col-lg-12">
                               <div class="centerText" title="Total DOOR" id="totalDOOR">0</div>
                              </div>
                             </div>
                           <div class="row" style="height:58%;">
                              <div class="col-lg-6 blueGreyLight" style="border-right:1px solid white;">
                                <div class="row" style="height:100%;">
                                   <div class="col-lg-12">
                                      <div class="centerText" style="padding-top:24px;" id="totalDryDOOR" title="Dry DOOR">0</div>
                                      <div class="headerText blueGrey" style="border-right:1px solid white;"><span style="margin-left:-16px;font-weight: 500;">DRY</span></div>
                                   </div>
                                 </div>
                              </div>
                              <div class="col-lg-6 ">
                                <div class="row" style="height:100%;">
                                   <div class="col-lg-12">
                                     <div class="centerText" style="padding-top:24px;left:53%" id="totalTCLDOOR" title="TCL DOOR">0</div>
                                         <div class="headerText blueGrey"><span style="margin-left:-16px;font-weight: 500;">TCL</span></div>
                                   </div>
                                 </div>
                              </div>
                            </div>
                        </div>
            </div>
        </div>
        <div class="col-lg-3">
          <div class="row" style="width:100%;padding:0px 16px;height:133px;">
                        <div class="col-lg-12 card" style="background: #92D050;">
                          <div class="row" style="height:42%;border-bottom:1px solid #ECEFF1;">
                             <div class="col-lg-12">
                               <div class="centerText" title="Total DOOR" id="workingDOOR">0</div>
                              </div>
                             </div>
                           <div class="row" style="height:58%;">
                              <div class="col-lg-6" style="border-right:1px solid white;">
                                <div class="row" style="height:100%;">
                                   <div class="col-lg-12">
                                      <div class="centerText" style="padding-top:24px;" id="workingDryDOOR" title="Dry DOOR">0</div>
                                      <div class="headerText blueGrey"><span style="margin-left:-16px;font-weight: 500;">DRY</span></div>
                                   </div>
                                 </div>
                              </div>
                              <div class="col-lg-6 ">
                                <div class="row" style="height:100%;">
                                   <div class="col-lg-12">
                                     <div class="centerText" style="padding-top:24px;left:53%" id="workingTCLDOOR" title="TCL DOOR">0</div>
                                         <div class="headerText blueGrey"><span style="margin-left:-16px;font-weight: 500;">TCL</span></div>
                                   </div>
                                 </div>
                              </div>
                            </div>
                        </div>
            </div>
        </div>
        <div class="col-lg-3">
          <div class="row" style="width:100%;padding:0px 16px;height:133px;">
                        <div class="col-lg-12 card" style="background: #D32F2F; color: white !important; font-weight:bold !important ;">
                          <div class="row" style="height:42%;border-bottom:1px solid #ECEFF1;">
                             <div class="col-lg-12">
                               <div class="centerTextRed" title="Total DOOR" onClick="javascript:alertOnClick(2,'TOTAL','Door Total Alert')" id="notWorkingDOOR">0</div>
                              </div>
                             </div>
                           <div class="row" style="height:58%;">
                              <div class="col-lg-6" style="border-right:1px solid white;">
                                <div class="row" style="height:100%;">
                                   <div class="col-lg-12">
                                      <div class="centerTextRed" style="padding-top:24px;" onClick="javascript:alertOnClick(2,'DRY','Door Dry Alert')" id="notWorkingDryDOOR" title="Dry DOOR">0</div>
                                      <div class="headerText blueGrey"><span style="margin-left:-16px;font-weight: 500;">DRY</span></div>
                                   </div>
                                 </div>
                              </div>
                              <div class="col-lg-6 ">
                                <div class="row" style="height:100%;">
                                   <div class="col-lg-12">
                                     <div class="centerTextRed" style="padding-top:24px;left:53%" onClick="javascript:alertOnClick(2,'TCL','Door TCL Alert')" id="notWorkingTCLDOOR" title="TCL DOOR">0</div>
                                         <div class="headerText blueGrey"><span style="margin-left:-16px;font-weight: 500;">TCL</span></div>
                                   </div>
                                 </div>
                              </div>
                            </div>
                        </div>
            </div>
        </div>
      </div>

      <div class="row" id="columnContainer3">
        <div class="col-lg-3" style="margin-top:60px;padding-left:40px;font-weight: 700;">
            <i class="fas fa-table" style="font-size:24px;margin-right:16px;"></i> OBD DATA
        </div>
        <div class="col-lg-3">
          <div class="row" style="width:100%;padding:0px 16px;height:133px;">
                        <div class="col-lg-12 card" style="background:#90A4AE;">
                          <div class="row" style="height:42%;border-bottom:1px solid #ECEFF1;">
                             <div class="col-lg-12">
                               <div class="centerText" title="Total OBD" id="totalOBD">0</div>
                              </div>
                             </div>
                           <div class="row" style="height:58%;">
                              <div class="col-lg-6 blueGreyLight" style="border-right:1px solid white;">
                                <div class="row" style="height:100%;">
                                   <div class="col-lg-12">
                                      <div class="centerText" style="padding-top:24px;" id="totalDryOBD" title="Dry OBD">0</div>
                                      <div class="headerText blueGrey" style="border-right:1px solid white;"><span style="margin-left:-16px;font-weight: 500;">DRY</span></div>
                                   </div>
                                 </div>
                              </div>
                              <div class="col-lg-6 ">
                                <div class="row" style="height:100%;">
                                   <div class="col-lg-12">
                                     <div class="centerText" style="padding-top:24px;left:53%" id="totalTCLOBD" title="TCL OBD">0</div>
                                         <div class="headerText blueGrey"><span style="margin-left:-16px;font-weight: 500;">TCL</span></div>
                                   </div>
                                 </div>
                              </div>
                            </div>
                        </div>
            </div>
        </div>
        <div class="col-lg-3">
          <div class="row" style="width:100%;padding:0px 16px;height:133px;">
                        <div class="col-lg-12 card" style="background: #92D050;">
                          <div class="row" style="height:42%;border-bottom:1px solid #ECEFF1;">
                             <div class="col-lg-12">
                               <div class="centerText" title="Total OBD" id="workingOBD">0</div>
                              </div>
                             </div>
                           <div class="row" style="height:58%;">
                              <div class="col-lg-6" style="border-right:1px solid white;">
                                <div class="row" style="height:100%;">
                                   <div class="col-lg-12">
                                      <div class="centerText" style="padding-top:24px;" id="workingDryOBD" title="Dry OBD">0</div>
                                      <div class="headerText blueGrey"><span style="margin-left:-16px;font-weight: 500;">DRY</span></div>
                                   </div>
                                 </div>
                              </div>
                              <div class="col-lg-6 ">
                                <div class="row" style="height:100%;">
                                   <div class="col-lg-12">
                                     <div class="centerText" style="padding-top:24px;left:53%" id="workingTCLOBD" title="TCL OBD">0</div>
                                         <div class="headerText blueGrey"><span style="margin-left:-16px;font-weight: 500;">TCL</span></div>
                                   </div>
                                 </div>
                              </div>
                            </div>
                        </div>
            </div>
        </div>
        <div class="col-lg-3">
          <div class="row" style="width:100%;padding:0px 16px;height:133px;">
                        <div class="col-lg-12 card" style="background: #D32F2F; color: white !important; font-weight:bold !important ;">
                          <div class="row" style="height:42%;border-bottom:1px solid #ECEFF1;">
                             <div class="col-lg-12">
                               <div class="centerTextRed" title="Total OBD" onClick="javascript:alertOnClick(3,'TOTAL','OBD Total Alert')" id="notWorkingOBD">0</div>
                              </div>
                             </div>
                           <div class="row" style="height:58%;">
                              <div class="col-lg-6" style="border-right:1px solid white;">
                                <div class="row" style="height:100%;">
                                   <div class="col-lg-12">
                                      <div class="centerTextRed" style="padding-top:24px;" onClick="javascript:alertOnClick(3,'DRY','OBD Dry Alert')" id="notWorkingDryOBD" title="Dry OBD">0</div>
                                      <div class="headerText blueGrey"><span style="margin-left:-16px;font-weight: 500;">DRY</span></div>
                                   </div>
                                 </div>
                              </div>
                              <div class="col-lg-6 ">
                                <div class="row" style="height:100%;">
                                   <div class="col-lg-12">
                                     <div class="centerTextRed" style="padding-top:24px;left:53%" onClick="javascript:alertOnClick(3,'TCL','OBD TCL Alert')" id="notWorkingTCLOBD" title="TCL OBD">0</div>
                                         <div class="headerText blueGrey"><span style="margin-left:-16px;font-weight: 500;">TCL</span></div>
                                   </div>
                                 </div>
                              </div>
                            </div>
                        </div>
            </div>
        </div>
      </div>

      <div class="row" id="columnContainer4">
        <div class="col-lg-3" style="margin-top:24px;padding-left:40px;font-weight: 700;">
            <img src="../../Main/resources/images/dhl/Engine coolant temprature.svg" style="height:32px;margin-right:16px;" alt="Temperature"> TEMPERATURE
        </div>
        <div class="col-lg-3">
          <div class="row" style="width:100%;padding:16px 0px 0px 0px;height:100px;margin-top: -14px;">
                        <div class="col-lg-12 card" style="background:#90A4AE;">
                           <div class="row" style="height:100%;">
                              <div class="col-lg-4 blueGreyLight" style="border-right:1px solid white;">
                                <div class="row" style="height:100%;">
                                   <div class="col-lg-12">
								
										<div class="centerText" style="padding-top:24px;" id="totalTReefer" title="Total T@Reefer">0</div>
							     
                                      <div class="headerText blueGrey" style="border-right:1px solid white;"><span style="margin-left:-16px;font-weight: 500;">T@Reefer</span></div>
                                   </div>
                                 </div>
                              </div>
                              <div class="col-lg-4 " style="border-right:1px solid white;">
                                <div class="row" style="height:100%;">
                                   <div class="col-lg-12">
                                      <div class="centerText" style="padding-top:24px;" id="totalTMiddle" title="Total T@Middle">0</div>
                                      <div class="headerText blueGrey" style="border-right:1px solid white;"><span style="margin-left:-16px;font-weight: 500;">T@Middle</span></div>
                                   </div>
                                 </div>
                              </div>
                              <div class="col-lg-4 blueGreyLight">
                                <div class="row" style="height:100%;">
                                   <div class="col-lg-12">
                                     <div class="centerText" style="padding-top:24px;left:53%" id="totalTDoor" title="Total T@Door">0</div>
                                         <div class="headerText blueGrey"><span style="margin-left:-16px;font-weight: 500;">T@Door</span></div>
                                   </div>
                                 </div>
                              </div>
                            </div>
                        </div>
            </div>
        </div>
        <div class="col-lg-3">
          <div class="row" style="width:100%;padding:16px 0px 0px 0px;height:100px;margin-top: -14px;">
                        <div class="col-lg-12 card" style="background:#92D050;">
                           <div class="row" style="height:100%;">
                              <div class="col-lg-4" style="border-right:1px solid white;">
                                <div class="row" style="height:100%;">
                                   <div class="col-lg-12">
                                      <div class="centerText" style="padding-top:24px;" id="workingTReefer" title="working T@Reefer">0</div>
                                      <div class="headerText blueGrey"><span style="margin-left:-16px;font-weight: 500;">T@Reefer</span></div>
                                   </div>
                                 </div>
                              </div>
                              <div class="col-lg-4 " style="border-right:1px solid white;">
                                <div class="row" style="height:100%;">
                                   <div class="col-lg-12">
                                      <div class="centerText" style="padding-top:24px;" id="workingTMiddle" title="working T@Middle">0</div>
                                      <div class="headerText blueGrey"><span style="margin-left:-16px;font-weight: 500;">T@Middle</span></div>
                                   </div>
                                 </div>
                              </div>
                              <div class="col-lg-4">
                                <div class="row" style="height:100%;">
                                   <div class="col-lg-12">
                                     <div class="centerText" style="padding-top:24px;left:53%" id="workingTDoor" title="working T@Door">0</div>
                                         <div class="headerText blueGrey"><span style="margin-left:-16px;font-weight: 500;">T@Door</span></div>
                                   </div>
                                 </div>
                              </div>
                            </div>
                        </div>
            </div>
        </div>
        <div class="col-lg-3">
          <div class="row" style="width:100%;padding:16px 0px 0px 0px;height:100px;margin-top: -14px;">
                        <div class="col-lg-12 card" style="background:#D32F2F; color: white !important; font-weight:bold !important ;">
                           <div class="row" style="height:100%;">
                              <div class="col-lg-4" style="border-right:1px solid white;">
                                <div class="row" style="height:100%;">
                                   <div class="col-lg-12">
                                      <div class="centerTextRed" style="padding-top:24px;" onClick="javascript:alertOnClick(4,'T@reefer','T@Reefer')" id="notWorkingTReefer" title="notWorking T@Reefer">0</div>
                                      <div class="headerText blueGrey"><span style="margin-left:-16px;font-weight: 500;">T@Reefer</span></div>
                                   </div>
                                 </div>
                              </div>
                              <div class="col-lg-4 " style="border-right:1px solid white;">
                                <div class="row" style="height:100%;">
                                   <div class="col-lg-12">
                                      <div class="centerTextRed" style="padding-top:24px;" onClick="javascript:alertOnClick(4,'T@middle','T@Middle')" id="notWorkingTMiddle" title="notWorking T@Middle">0</div>
                                      <div class="headerText blueGrey"><span style="margin-left:-16px;font-weight: 500;">T@Middle</span></div>
                                   </div>
                                 </div>
                              </div>
                              <div class="col-lg-4">
                                <div class="row" style="height:100%;">
                                   <div class="col-lg-12">
                                     <div class="centerTextRed" style="padding-top:24px;left:53%" onClick="javascript:alertOnClick(4,'T@door','T@Door')" id="notWorkingTDoor" title="notWorking T@Door">0</div>
                                         <div class="headerText blueGrey"><span style="margin-left:-16px;font-weight: 500;">T@Door</span></div>
                                   </div>
                                 </div>
                              </div>
                            </div>
                        </div>
            </div>
        </div>
      </div>

      <div class="row" id="columnContainer5" style="background: #37474F;color: white;padding: 8px;margin-top: -4px;" >
        <div class="col-lg-4" style="padding-left:32px;">

        </div>
        <div class="col-lg-4" style="text-align:center;font-weight: 600;">
             HISTORY REPORT
        </div>
        <div class="col-lg-4" style="text-align:center;">

        </div>

      </div>

      <div class="row" style="width:100%;height:80px;">
                    <div class="col-lg-12 card" style="padding:12px 16px 0px 16px;height: 55px;">
                      <div class="row">
                        <div class="col-lg-2">
                        </div>
                        <div class="col-lg-3" style="font-weight: 500;">
                          Start Date:&nbsp;&nbsp; <input type="date" id="startDate"/>
                        </div>
                        <div class="col-lg-3" style="font-weight: 500;">
                          End Date:&nbsp;&nbsp; <input type="date" id="endDate"/>
                        </div>
                        <div class="col-lg-2">
                          <button id='exportHistory'  class='blue' onClick="exportHistory()">EXPORT TO EXCEL</button>
                        </div>
                        <div class="col-lg-2">
                        </div>
                      </div>

                    </div>
        </div>
<div id="div1" style="display:none;"></div>
<div id="div2" style="display:none;"></div>
<div id="div3" style="display:none;"></div>
<div id="div4" style="display:none;"></div>
      <div id="add" class="modal fade" style="margin-top: 18px;">
             <div class="row blueGreyDark" style="width:100%;padding-top:8px;height:40px;border-bottom:1px solid black" >
               <div  class="col-md-10">
                  <h4 id="tripEventsTitle" class="modal-title" style="text-align:left; margin-left:10px;color: white;"></h4>
               </div>
                <div class="col-md-1 fa fa-window-close" data-dismiss="modal" style="cursor: pointer; color: white; text-align: right; padding-right: 10px;    margin-left: 92px;height: 20px;">
      			</div>
             </div>
             <div class="modal-body" style="margin-top:8px;height: 100%; overflow-y: hidden;padding:0px;">
                <div class="row">
                      <div class="col-lg-12" >
                         <table id="alertEventsTable"  class="table table-striped table-bordered" cellspacing="0" style="width:100%;">
                            <thead>
                               <tr>
                                  <th>Sl No</th>
                                  <th>Alert Date</th>
                                  <th>VehicleNo</th>
                                  <th>Vehicle Make</th>
                                  <th>Last Communication</th>
                                  <th>Ageing(HH:mm:ss)</th>
                                  <th>Updated Date</th>
                                  <th>Updated By</th>
                                  <th>TripNo</th>
                                  <th>TripType</th>
                                  <th>Remarks</th>
                                  <th>Acknowledge</th>
                                  <th>AlertId</th>
                                  <th>UniqueId</th>            
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


  <script>
	//history.pushState({ foo: 'fake' }, 'Fake Url', 'SensorHealthDashboard#');
  var baseUrl = "http://104.211.155.173:9095/";
  var custId = <%=custId%>

  function exportHistory(){
    var d1 = new Date($("#startDate").val());
	var d2 = new Date($("#endDate").val());
    var timeDiff = d2.getTime() - d1.getTime();
	var DaysDiff = timeDiff / (1000 * 3600 * 24);
	if(DaysDiff > 7){
		sweetAlert("Date Range should not exceeds 7 days");
		return;
	}
    $.ajax({
         type: "GET",
         url: "<%=request.getContextPath()%>/SensorHealthDashboardAction.do?param=getHistoryDataDetails",
         data: {
             startDate: $("#startDate").val(),
             endDate:$("#endDate").val()
         },
         "dataSrc": "historyDetails",
         success: function(results) {
           let obj = JSON.parse(results).historyDetails;

           var tableHeader ="<td>Alert DateTime</td>";
           tableHeader +="<td>Vehicle No.</td>";
           tableHeader +="<td>Make</td>";
           tableHeader +="<td>Updated Date</td>";
           tableHeader +="<td>Updated By</td>";
           tableHeader +="<td>Trip No.</td>";
           tableHeader +="<td>Trip Type</td>";
           tableHeader +="<td>Remarks</td>";
           tableHeader +="<td>Ageing(HH:mm)</td>";

           var tbl1="<table id='tbl1'><tr>" + tableHeader + "</tr>";
           var tbl2="<table id='tbl2'><tr>" + tableHeader + "</tr>";
           var tbl3="<table id='tbl3'><tr>" + tableHeader + "</tr>";
           var tbl4="<table id='tbl4'><tr>" + tableHeader + "</tr>";

            for(var i=0;i<obj.length;i++)
            {
            	var updatedDate = '';
				if(obj[i]["updatedDate"]=='01-01-1900 00:00:00'){
					updatedDate = '';
				} else{
					updatedDate = obj[i]["updatedDate"];
				}
                var tbl = "";
                tbl+="<tr>";
                tbl+="<td>"+obj[i]["alertDatetime"]+"</td>";
                tbl+="<td>"+obj[i]["vehicleNo"]+"</td>";
                tbl+="<td>"+obj[i]["make"]+"</td>";
                tbl+="<td>"+obj[i]["updatedDate"]+"</td>";
                tbl+="<td>"+obj[i]["+updatedBy"]+"</td>";
                tbl+="<td>"+obj[i]["tripNo"]+"</td>";
                tbl+="<td>"+obj[i]["tripType"]+"</td>";
                tbl+="<td>"+obj[i]["remarks"]+"</td>";
                tbl+="<td>"+obj[i]["ageing"]+"</td></tr>";

                if(obj[i]["alertId"] == 1)
                {
                  tbl1 += tbl;
                }
                else if(obj[i]["alertId"] == 2)
                {
                  tbl2 += tbl;
                }
                else if(obj[i]["alertId"] == 3)
                {
                  tbl3 += tbl;
                }
                else if(obj[i]["alertId"] == 4)
                {
                  tbl4 += tbl;
                }
            }

            tbl1 += "</table>";
              tbl2 += "</table>";
                tbl3 += "</table>";
                  tbl4 += "</table>";

            $("#div1").append(tbl1);
            $("#div2").append(tbl2);
            $("#div3").append(tbl3);
            $("#div4").append(tbl4);


            tablesToExcel(['tbl1','tbl2','tbl3','tbl4'], ['Non Communicating','Door Sensor','OBD Data','Temperature'], 'Alert History Report.xls', 'Excel')


         }
 })

  }

  var tablesToExcel = (function() {
   var uri = 'data:application/vnd.ms-excel;base64,'
   , tmplWorkbookXML = '<?xml version="1.0"?><?mso-application progid="Excel.Sheet"?><Workbook xmlns="urn:schemas-microsoft-com:office:spreadsheet" xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet">'
     + '<DocumentProperties xmlns="urn:schemas-microsoft-com:office:office"><Author>Axel Richter</Author><Created>{created}</Created></DocumentProperties>'
     + '<Styles>'
     + '<Style ss:ID="Currency"><NumberFormat ss:Format="Currency"></NumberFormat></Style>'
     + '<Style ss:ID="Date"><NumberFormat ss:Format="Medium Date"></NumberFormat></Style>'
     + '</Styles>'
     + '{worksheets}</Workbook>'
   , tmplWorksheetXML = '<Worksheet ss:Name="{nameWS}"><Table>{rows}</Table></Worksheet>'
   , tmplCellXML = '<Cell{attributeStyleID}{attributeFormula}><Data ss:Type="{nameType}">{data}</Data></Cell>'
   , base64 = function(s) { return window.btoa(unescape(encodeURIComponent(s))) }
   , format = function(s, c) { return s.replace(/{(\w+)}/g, function(m, p) { return c[p]; }) }
   return function(tables, wsnames, wbname, appname) {
     var ctx = "";
     var workbookXML = "";
     var worksheetsXML = "";
     var rowsXML = "";

     for (var i = 0; i < tables.length; i++) {
       if (!tables[i].nodeType) tables[i] = document.getElementById(tables[i]);
       for (var j = 0; j < tables[i].rows.length; j++) {
         rowsXML += '<Row>'
         for (var k = 0; k < tables[i].rows[j].cells.length; k++) {
           var dataType = tables[i].rows[j].cells[k].getAttribute("data-type");
           var dataStyle = tables[i].rows[j].cells[k].getAttribute("data-style");
           var dataValue = tables[i].rows[j].cells[k].getAttribute("data-value");
           dataValue = (dataValue)?dataValue:tables[i].rows[j].cells[k].innerHTML;
           if(dataValue=='undefined')
           {
           dataValue='';
           }
           var dataFormula = tables[i].rows[j].cells[k].getAttribute("data-formula");
           dataFormula = (dataFormula)?dataFormula:(appname=='Calc' && dataType=='DateTime')?dataValue:null;
           ctx = {  attributeStyleID: (dataStyle=='Currency' || dataStyle=='Date')?' ss:StyleID="'+dataStyle+'"':''
                  , nameType: (dataType=='Number' || dataType=='DateTime' || dataType=='Boolean' || dataType=='Error')?dataType:'String'
                  , data: (dataFormula)?'':dataValue
                  , attributeFormula: (dataFormula)?' ss:Formula="'+dataFormula+'"':''
                 };
           rowsXML += format(tmplCellXML, ctx);
         }
         rowsXML += '</Row>'
       }
       ctx = {rows: rowsXML, nameWS: wsnames[i] || 'Sheet' + i};
       worksheetsXML += format(tmplWorksheetXML, ctx);
       rowsXML = "";
     }

     ctx = {created: (new Date()).getTime(), worksheets: worksheetsXML};
     workbookXML = format(tmplWorkbookXML, ctx);


     var link = document.createElement("A");
     link.href = uri + base64(workbookXML);
     link.download = wbname || 'Workbook.xls';
     link.target = '_blank';
     document.body.appendChild(link);
     link.click();
     document.body.removeChild(link);
   }
 })();
var alertIdNew = 0;
var typeNew = '';

  function alertOnClick(alertId,type,action){
	   
	   alertIdNew = alertId;
	   typeNew = type;
	   if(action != 'reload')
	   {
	   		$('#loading-div').show();
        	$('#add').modal('show');
	   }
	   
        $('#loading-div').show();
        $('#add').modal('show');
        $('#tripEventsTitle').text(action);
        $.ajax({
             type: "GET",
             url: "<%=request.getContextPath()%>/SensorHealthDashboardAction.do?param=getDashboardDetails",
             data: {
                 systemId: <%=systemId%>,
                 customerId: custId,
                 alertId: alertId,
                 type:type
             },
             "dataSrc": "dashboardDetails",
             success: function(results) {
               var result = JSON.parse(results).dashboardDetails;
               
               let rows = [];
               let rowCounter = 1;
               $.each(result, function(i, item) {
                    var ack = "";
                    var remarks = "";
                    if(item.remarks == "" || item.remarks == null)
                    {
                      ack = "<button id='btn"+item.uniqueId+"'  class='green' onClick='Acknowledge("+item.uniqueId+")'>Acknowledge</button>";
                      remarks = "<div id='div"+item.uniqueId+"'><input style='width:300px;' id='txt"+item.uniqueId+"' type='text'/></div>";
                    }
                    else {
                      remarks = item.remarks
                    }

				 var updatedDate = '';
					if(item.updatedDate=='01-01-1900 00:00:00'){
						updatedDate = '';
					} else{
						updatedDate = item.updatedDate;
					}
                 let row = {
                       "0":rowCounter,
                       "1":item.alertDatetime,
                       "2":item.vehicleNo,
                       "3":item.make,
                       "4":item.lastCommunication,
                       "5":item.ageing,
                       "6":item.updatedDate,
                       "7":item.updatedBy,
                       "8":item.tripNo,
                       "9":item.tripType,
                       "10":remarks,
                       "11":ack,
                       "12":item.alertId,
                       "13":item.uniqueId

                  }
                  
                  rows.push(row);
                  rowCounter++;
                })
				
jQuery.extend(jQuery.fn.dataTableExt.oSort, {
    "time-uni-pre": function (a) {
        var uniTime;
 
        if (a.toLowerCase().indexOf("am") > -1 || (a.toLowerCase().indexOf("pm") > -1 && Number(a.split(":")[0]) === 12)) {
            uniTime = a.toLowerCase().split("pm")[0].split("am")[0];
            while (uniTime.indexOf(":") > -1) {
                uniTime = uniTime.replace(":", "");
            }
        } else if (a.toLowerCase().indexOf("pm") > -1 || (a.toLowerCase().indexOf("am") > -1 && Number(a.split(":")[0]) === 12)) {
            uniTime = Number(a.split(":")[0]) + 12;
            var leftTime = a.toLowerCase().split("pm")[0].split("am")[0].split(":");
            for (var i = 1; i < leftTime.length; i++) {
                uniTime = uniTime + leftTime[i].trim().toString();
            }
        } else {
            uniTime = a.replace(":", "");
            while (uniTime.indexOf(":") > -1) {
                uniTime = uniTime.replace(":", "");
            }
        }
        return Number(uniTime);
    },
 
    "time-uni-asc": function (a, b) {
        return ((a < b) ? -1 : ((a > b) ? 1 : 0));
    },
 
    "time-uni-desc": function (a, b) {
        return ((a < b) ? 1 : ((a > b) ? -1 : 0));
    }
});
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
                  "autowidth":true,
                  "columnDefs": [
			            { width: '100px', targets: 3 },
			            {type: 'time-uni', targets: 5 }
			        ],
			        
                  buttons:[{
                             extend: 'excel',
                             text:'Export to Excel',
                             class: "btn btn-primary",
                             title: 'Alert Details',
                             customData: function (exceldata) {
                                         exportExtension = 'Excel';
                                         return exceldata;
                             },exportOptions: {
			              			  columns: [0,2,3,4,5,6,7,8,9,10] //':visible'
			           			    }
                            }]
                });
                table.columns( [1,12,13] ).visible( false );
                setTimeout(function() {
					if(result.length > 0){
                  table.rows.add(rows).draw();}
                  $('#loading-div').hide();
                }, 2000);
             }
     })

  }

  function Acknowledge(uniqueId) {
    if($("#txt"+uniqueId).val() == "")
    {
      alert("Please enter remarks for this alert.");
      return;
    }
     $("#loading-div").show();
     var remarks = $("#txt"+uniqueId).val();
     $.ajax({
        url: "<%=request.getContextPath()%>/SensorHealthDashboardAction.do?param=updateAcknowledgement",
        //url: baseUrl + 'updateAcknowledgement',
        type : 'GET',
        data: {
            uniqueId: uniqueId,
            remarks: $("#txt"+uniqueId).val()
            },
        datatype:'json',
        contentType: "application/json",
        success: function(result) {
          $("#loading-div").hide();
          $("#div"+uniqueId).html(remarks);
          $("#btn"+uniqueId).hide();
		  alertOnClick(alertIdNew,typeNew,'reload');
		  //table.ajax.reload();
        }
    });
  }

  $(document).ready(function () {
    $.ajax({
         type: "GET",
         url: "<%=request.getContextPath()%>/SensorHealthDashboardAction.do?param=getDashboardCounts",
         "dataSrc": "sensorHealthAlertCount",
         success: function(results) {
         	var res = JSON.parse(results);
           var result = res["sensorHealthAlertCount"][0];
           $("#totalGPRS").text(parseInt(result.gpsTotalDryCount) + parseInt(result.gpsTotalTclCount));
           $("#totalDryGPRS").text(result.gpsTotalDryCount);
           $("#totalTCLGPRS").text(result.gpsTotalTclCount);
           $("#workingGPRS").text(parseInt(result.gpsWorkingDryCount) + parseInt(result.gpsWorkingTclCount));
           $("#workingDryGPRS").text(result.gpsWorkingDryCount);
           $("#workingTCLGPRS").text(result.gpsWorkingTclCount);
           $("#notWorkingGPRS").text(parseInt(result.gpsNotWorkingDryCount) + parseInt(result.gpsNotWorkingTclCount));
           $("#notWorkingDryGPRS").text(result.gpsNotWorkingDryCount);
           $("#notWorkingTCLGPRS").text(result.gpsNotWorkingTclCount);

           $("#totalDOOR").text(parseInt(result.doorTotalDryCount) + parseInt(result.doorTotalTclCount));
           $("#totalDryDOOR").text(result.doorTotalDryCount);
           $("#totalTCLDOOR").text(result.doorTotalTclCount);
           $("#workingDOOR").text(parseInt(result.doorWorkingDryCount) + parseInt(result.doorWorkingTclCount));
           $("#workingDryDOOR").text(result.doorWorkingDryCount);
           $("#workingTCLDOOR").text(result.doorWorkingTclCount);
           $("#notWorkingDOOR").text(parseInt(result.doorNotWorkingDryCount) + parseInt(result.doorNotWorkingTclCount));
           $("#notWorkingDryDOOR").text(result.doorNotWorkingDryCount);
           $("#notWorkingTCLDOOR").text(result.doorNotWorkingTclCount);


           $("#totalOBD").text(parseInt(result.obdtotalDryCount) + parseInt(result.obdtotalTclCount));
           $("#totalDryOBD").text(result.obdtotalDryCount);
           $("#totalTCLOBD").text(result.obdtotalTclCount);
           $("#workingOBD").text(parseInt(result.obdworkingDryCount) + parseInt(result.obdworkingTclCount));
           $("#workingDryOBD").text(result.obdworkingDryCount);
           $("#workingTCLOBD").text(result.obdworkingTclCount);
           $("#notWorkingOBD").text(parseInt(result.obdnotWorkingDryCount) + parseInt(result.obdnotWorkingTclCount));
           $("#notWorkingDryOBD").text(result.obdnotWorkingDryCount);
           $("#notWorkingTCLOBD").text(result.obdnotWorkingTclCount);

           $("#totalTReefer").text(result.reeferTotalCount);
           $("#totalTMiddle").text(result.middleTotalCount);
           $("#totalTDoor").text(result.doorTotalCount);
           $("#workingTReefer").text(result.reeferWorkingCount);
           $("#workingTMiddle").text(result.middleWorkingCount);
           $("#workingTDoor").text(result.doorWorkingCount);
           $("#notWorkingTReefer").text(result.reeferNotWorkingCount);
           $("#notWorkingTMiddle").text(result.middleNotWorkingCount);
           $("#notWorkingTDoor").text(result.doorNotWorkingCount);

         }
    })
  })
  </script>
      <jsp:include page="../Common/footer.jsp" />
