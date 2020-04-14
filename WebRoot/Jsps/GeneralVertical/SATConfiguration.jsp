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
.col-lg-6{padding: 4px;margin:0px;}

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

      </style>

      <div class="center-view" style="display:none;" id="loading-div">
        <img src="../../Main/images/loading.gif" alt="">
      </div>

      <div class="row" style="margin-bottom:16px;margin-left:8px;">
        <div class="col-lg-12" style="text-align:center">
          <h3 style="margin-top:0px !important;">Semi-automated Trip Configuration</h3>
        </div>
      </div>

      <div class="row" style="margin-bottom:16px;margin-left:8px;">
        <div class="col-lg-1">
          Customer:
        </div>
        <div class="col-lg-9">
          <select id="custDropDownId" style="width:200px;height:24px;">
          </select>
        </div>
        <div class="col-lg-2" style="text-align:right;padding-right:24px;">
          <button class="btn btn-generate btn-md btn-primary" style="margin-top:0px;background:#18519E;width:75px" type="submit" value="Submit" onClick="saveConfigurations()">SAVE</button>
        </div>

      </div>


      <div class="row">
        <div class="col-lg-6">
          <div class="row" id="columnContainer5" style="background: #37474F;color: white;padding: 8px;" >
              <div class="col-lg-4" style="padding-left:32px;">
                </div>
              <div class="col-lg-4" id="tripStart" style="text-align:center;">
                   TRIP START
              </div>
              <div class="col-lg-4" style="text-align:center;">
                </div>
          </div>
          <div class="row" style="width:100%;">
                        <div class="col-lg-12 card" style="padding:16px 16px 16px 32px;">
                          <div class="row" style="padding-bottom:16px;">
                            <div class="col-lg-2">
                              Hub Departure:
                            </div>
                            <div class="col-lg-4">
                              <select id="hubDepartureId" style="width:200px;height:24px;">
                              </select>
                            </div>
                            <div class="col-lg-1" style="margin-left:10%;">
<!--                              <input type="checkbox" id="hubDepartureCheckBox">-->
                              <input name="hubDeparture" type="radio" id="hubDeparture" value="HUB_DEPARTURE">
                            </div>
                          </div>
                          <div class="row">
                            <div class="col-lg-2">
                              Time Basis:
                            </div>
                            <div class="col-lg-4">
                            </div>
                            <div class="col-lg-1" style="margin-left:10%;">
                              <input name="hubDeparture" type="radio" id="timeBasis" value="TIME_BASIS">
                            </div>
                          </div>
                        </div>
            </div>
        </div>
        <div class="col-lg-6">
          <div class="row" id="columnContainer5" style="background: #37474F;color: white;padding: 8px;" >
              <div class="col-lg-4" style="padding-left:32px;">
                </div>
              <div class="col-lg-4" id="tripEnd" style="text-align:center;">
                   TRIP END
              </div>
              <div class="col-lg-4" style="text-align:center;">
                </div>
          </div>
          <div class="row" style="width:100%;">
                        <div class="col-lg-12 card" style="padding:16px 16px 16px 32px;">
                          <div class="row" style="padding-bottom:16px;">
                            <div class="col-lg-2">
                              Check Point:
                            </div>
                            <div class="col-lg-4">
                              <select id="checkPointId" style="width:200px;height:24px;">
                              </select>
                            </div>
                            <div class="col-lg-1" style="margin-left:10%;">
                             <input name="hubArrival" type="radio" id="hubArrival" value="CHECK_POINT">
                            </div>
                          </div>
                          <div class="row">
                            <div class="col-lg-2">
                              Time Basis:
                            </div>
                            <div class="col-lg-4">
                            </div>
                            <div class="col-lg-1" style="margin-left:10%;">
                              <input name="hubArrival" type="radio" id="timeBasis" value="TIME_BASIS">
                            </div>
                          </div>

                        </div>
            </div>
        </div>
      </div>

      <div class="row">
        <div class="col-lg-6">
          <div class="row" id="columnContainer5" style="background: #37474F;color: white;padding: 8px;" >
              <div class="col-lg-4" style="padding-left:32px;">
                </div>
              <div class="col-lg-4" id="event" style="text-align:center;">
                   EVENTS
              </div>
              <div class="col-lg-4" style="text-align:center;">
                </div>
          </div>
          <div class="row" style="width:100%;">
                        <div class="col-lg-12 card" style="padding:16px 16px 16px 32px;">
                          <div class="row" style="padding-bottom:16px;">
                            <div class="col-lg-4">
<!--                              <div class="row" style="padding-bottom:16px;">-->
<!--                                <div class="col-lg-1">-->
<!--                                   <input type="checkbox" id="plannedRoute">-->
<!--                                </div>-->
<!--                                <div class="col-lg-11">-->
<!--                                   ALL-->
<!--                                </div>-->
<!--                              </div>-->
 <!--                             <div class="row" style="padding-bottom:16px;">
                                <div class="col-lg-1">
                                   <input type="checkbox" id ="checkBox1" value="105=Harsh Driving">
                                </div>
                                <div class="col-lg-11">
                                   Harsh Driving
                                </div>
                              </div>
                              <div class="row" style="padding-bottom:16px;">
                                <div class="col-lg-1">
                                   <input type="checkbox" id ="checkBox2" value="17=Hub Arrival">
                                </div>
                                <div class="col-lg-11">
                                   Hub Arrival
                                </div>
                              </div>
                              <div class="row" style="padding-bottom:16px;">
                                <div class="col-lg-1">
                                   <input type="checkbox" id ="checkBox3" value="135=Trip Start">
                                </div>
                                <div class="col-lg-11">
                                   Trip Start
                                </div>
                              </div>
                              <div class="row" style="padding-bottom:16px;">
                                <div class="col-lg-1">
                                   <input type="checkbox" id ="checkBox4" value="18=Hub Departure">
                                </div>
                                <div class="col-lg-11">
                                   Hub Departure
                                </div>
                              </div>
                              <div class="row" style="padding-bottom:16px;">
                                <div class="col-lg-1">
                                   <input type="checkbox" id ="checkBox5" value="136=Trip End">
                                </div>
                                <div class="col-lg-11">
                                   Trip End
                                </div>
                              </div>
                              <div class="row" style="padding-bottom:16px;">
                                <div class="col-lg-1">
                                   <input type="checkbox" id ="checkBox6" value="38=Door Sensor">
                                </div>
                                <div class="col-lg-11">
                                   Door Sensor
                                </div>
                              </div>
                            </div>
                            <div class="col-lg-4">
                              <div class="row" style="padding-bottom:16px;">
                                <div class="col-lg-1">
                                   <input type="checkbox" id ="checkBox7" value="38=Idle">
                                </div>
                                <div class="col-lg-11">
                                   Idle
                                </div>
                              </div>
                              <div class="row" style="padding-bottom:16px;">
                                <div class="col-lg-1">
                                   <input type="checkbox" id ="checkBox8" value="1=Vehicle Stoppage">
                                </div>
                                <div class="col-lg-11">
                                   Vehicle Stoppage
                                </div>
                              </div>
                              <div class="row" style="padding-bottom:16px;">
                                <div class="col-lg-1">
                                   <input type="checkbox" id ="checkBox9" value="37=Seat Belt">
                                </div>
                                <div class="col-lg-11">
                                   Seat Belt
                                </div>
                              </div>
                              <div class="row" style="padding-bottom:16px;">
                                <div class="col-lg-1">
                                   <input type="checkbox" id ="checkBox10" value="85=Non-Communicating">
                                </div>
                                <div class="col-lg-11">
                                   Non-Communicating
                                </div>
                              </div>
                              <div class="row" style="padding-bottom:16px;">
                                <div class="col-lg-1">
                                   <input type="checkbox" id ="checkBox11" value="134=Route Re-Join">
                                </div>
                                <div class="col-lg-11">
                                   Route Re-Join
                                </div>
                              </div>
                            </div>
                            <div class="col-lg-4">
                              <div class="row" style="padding-bottom:16px;">
                                <div class="col-lg-1">
                                   <input type="checkbox" id ="checkBox12" value="5=Route Deviation">
                                </div>
                                <div class="col-lg-11">
                                   Route Deviation
                                </div>
                              </div>
                              <div class="row" style="padding-bottom:16px;">
                                <div class="col-lg-1">
                                   <input type="checkbox" id ="checkBox13" value="2=Overspeed">
                                </div>
                                <div class="col-lg-11">
                                   Overspeed
                                </div>
                              </div>
                              <div class="row" style="padding-bottom:16px;">
                                <div class="col-lg-1">
                                   <input type="checkbox" id ="checkBox14" value="194=High/Low RPM">
                                </div>
                                <div class="col-lg-11">
                                   High/Low RPM
                                </div>
                              </div>
                              <div class="row" style="padding-bottom:16px;">
                                <div class="col-lg-1">
                                   <input type="checkbox" id ="checkBox15" value="193=Low Fuel">
                                </div>
                                <div class="col-lg-11">
                                   Low Fuel
                                </div>
                              </div>
                              <div class="row" style="padding-bottom:16px;">
                                <div class="col-lg-1">
                                   <input type="checkbox" id ="checkBox16" value="195=Mileage">
                                </div>
                                <div class="col-lg-11">
                                   Mileage
                                </div>
                              </div> --> 
                               <div class="row" style="padding-bottom:16px;">
                                <div class="col-lg-1">
                                   <input type="checkbox" id ="checkBox12" value="189=Temperature">
                                </div>
                                <div class="col-lg-11">
                                   Temperature
                                </div>
                              </div>
                              <div class="row" style="padding-bottom:16px;">
                                <div class="col-lg-1">
                                   <input type="checkbox" id ="checkBox16" value="201=Pre-loading Achived">
                                </div>
                                <div class="col-lg-11">
                                   Pre-loading Achived
                                </div>
                              </div>
                            </div>
                          </div>
                        </div>
            </div>
        </div>
        <div class="col-lg-6">
          <div class="row" id="columnContainer5" style="background: #37474F;color: white;padding: 8px;" >
              <div class="col-lg-4" style="padding-left:32px;">
                </div>
              <div class="col-lg-4" id="rType" style="text-align:center;">
                   ROUTE TYPE
              </div>
              <div class="col-lg-4" style="text-align:center;">
                </div>
          </div>
          <div class="row" style="width:100%;">
                        <div class="col-lg-12 card" style="padding:16px 16px 16px 32px;">
                          <div class="row" style="padding-bottom:16px;">
                            <div class="col-lg-1">
                               <input name="routeGroup" type="radio" id="plannedRoute" value="PLANNED">
                            </div>
                            <div class="col-lg-4">
                               Planned
                            </div>
                            <div class="col-lg-1">
                            </div>
                          </div>
                          <div class="row" style="padding-bottom:16px;">
                            <div class="col-lg-1">
                               <input name="routeGroup" type="radio" id="unplannedRoute" value="UNPLANNED">
                            </div>
                            <div class="col-lg-4">
                               Unplanned
                            </div>
                            <div class="col-lg-1">
                            </div>
                          </div>
                          <div class="row" style="padding-bottom:16px;">
                            <div class="col-lg-1">
                               <input name="routeGroup" type="radio" id="withoutDestination" value="UNPLANNED_WITHOUT_DESTI">
                            </div>
                            <div class="col-lg-4">
                               Unplanned without destination
                            </div>
                            <div class="col-lg-1">
                            </div>
                          </div>
                        </div>
            </div>
        </div>
      </div>

      <div class="row" id="columnContainer5" style="background: #37474F;color: white;padding: 8px;" >
          <div class="col-lg-4" style="padding-left:32px;">
            </div>
          <div class="col-lg-4" style="text-align:center;">
               CUSTOM ATTRIBUTES
          </div>
          <div class="col-lg-4" style="text-align:center;">
            </div>
      </div>
      <div class="row" style="width:100%;height:80px;">
                    <div class="col-lg-12 card" style="padding:16px 16px 0px 16px;">
                      <div class="row" style="width:100%;">
                        <div class="col-lg-4">
                        </div>
                        <div class="col-lg-4" style="text-align:center;">
                          <i>Coming Soon...</i>
                        </div>
                        <div class="col-lg-4">
                        </div>
                      </div>

                    </div>
        </div>
<script>
 
  	 window.onload = function () { 
		getCustomerAndHubTypes();
	}

  $(document).ready(function () {
  })
  
   var custId = <%=custId%>;
   
   $(document).ready(function(){
 $("#custDropDownId").change(function(){
    //$("#hubDepartureId").empty();
    $('input[name="routeGroup"]').prop('checked', false);
    $('input[name="hubDeparture"]').prop('checked', false);
     $('input[name="hubArrival"]').prop('checked', false);
     $('input[type="checkbox" ]').prop('checked', false);
     //$("#checkPointId option:selected").removeAttr("selected");
    $('#hubDepartureId').prop('selectedIndex',0);
    $('#checkPointId option:eq(1)').prop('selected', true);
  });
});
   
   /*function myFunction() {
  alert("You have selected some text!");
}*/

/*function resetForm() {
    //document.getElementById("hubArrival").reset();
    $("#hubArrival").reset();
}*/

/*$(document).ready(function(){
  $("#custDropDownId").change(function(){
    //alert("The text has been changed.");
    //saveConfigurations();
    $("#hubDeparture").val();
     $("#hubArrival").val(); 
       $("#hubDepartureId").val(); 
         $("#checkPointId").val(); 
  });
});*/
  
  function getCustomerAndHubTypes(){
	var custName;
	var custarray=[];
	var hubTypeList=[];
	 $.ajax({
       type: "GET",
       url: '<%=request.getContextPath()%>/SemiAutoTripAction.do?param=getCustomers',
       data: {
           systemId: <%=systemId%>
       },
       success: function(result) {
       var customerStore = JSON.parse(result);
           var customerStore = JSON.parse(result);
            for (var i = 0; i < customerStore["customerRoot"].length; i++) {
                   $('#custDropDownId').append($("<option></option>").attr("value", customerStore	["customerRoot"][i].id)
                   .text( customerStore["customerRoot"][i].name));                   
            }
            $('#custDropDownId').select2();
         }
       }
   );

$.ajax({
            url: '<%=request.getContextPath()%>/createLandmarkAction.do?param=getGeoFenceType',
            success: function(response) {
                $("#hubDepartureId").empty().select2();
                $("#checkPointId").empty().select2();
	            var hubTypeStore = JSON.parse(response);
	            for (var i = 0; i < hubTypeStore["geofenceRoot"].length; i++) {
	                   $('#hubDepartureId').append($("<option></option>").attr("value", hubTypeStore["geofenceRoot"][i].operationId)
	                   .text( hubTypeStore["geofenceRoot"][i].operationType)); 
	                    $('#checkPointId').append($("<option></option>").attr("value", hubTypeStore["geofenceRoot"][i].operationId)
	                   .text( hubTypeStore["geofenceRoot"][i].operationType));                  
	            }
	            $("#hubDepartureId").select2();
                $("#checkPointId").select2();
	         }
        });

}

/*if ($('#custDropDownId').select2()){

}*/

function saveConfigurations(){
var checkbox='';
var val = [];
 var jsonArray = [];
 	 var eventsArray = [];
   var eventData = {};
   var nameVal = [];
 $(':checkbox:checked').each(function(i){
	  val[i] = $(this).val();  
	  checkbox = checkbox + val[i] +",";
	  eventData = {};
	  nameVal = val[i].split("=");
      eventData.alertId=nameVal[0];
      eventData.alertName = nameVal[1];
      eventsArray.push(eventData);
	}); 
	var tripStartCriteria = $("input[name=hubDeparture]:checked").val();//timeBasis
	var tripEndCriteria = $("input[name=hubArrival]:checked").val();//timeBasis
	var tripStartCriteriaParam = $('#hubDepartureId').val();//HubDeparture
	var tripEndCriteriaParam = $('#checkPointId').val();//CheckPoint
	var routeCriteria = $("input[name=routeGroup]:checked").val();//RouteType

	let input = {
           systemId: <%=systemId%>,
           customerId:<%=custId%>,
			tripStartCriteria:tripStartCriteria,
			tripEndCriteria:tripEndCriteria,
			tripStartCriteriaParam:tripStartCriteriaParam,
			tripEndCriteriaParam:tripEndCriteriaParam,
			routeType:routeCriteria,
			tripConfigEvents:eventsArray
			}
	
	 $.ajax({
       url: '<%=request.getContextPath()%>/SemiAutoTripAction.do?param=saveTripConfig',
        type: 'POST',
          data: {
            tripStartCriteria:tripStartCriteria,
			tripEndCriteria:tripEndCriteria,
			tripStartCriteriaParam:tripStartCriteriaParam,
			tripEndCriteriaParam:tripEndCriteriaParam,
			routeType:routeCriteria,
			tripConfigEvents:eventsArray
                        
                            },
       //datatype:'json',
       //contentType: "application/json",
       //data: JSON.stringify(input),
       success: function(result) {
       if (result == "success") {
         sweetAlert("saved Successfully");
         }
         else {
                     sweetAlert(result.message);
                     }
                     }
       });
	
}
  </script>
      <jsp:include page="../Common/footer.jsp" />
