<%@ page  language="java" import="java.util.*,t4u.functions.*,t4u.beans.*,t4u.common.*" pageEncoding="utf-8"%>
<%@ taglib uri="http://packtag.sf.net" prefix="pack" %>
<%
    CommonFunctions cf = new CommonFunctions();
    LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
    int countryId = loginInfo.getCountryCode();
    int systemId = loginInfo.getSystemId();
    int clientId = loginInfo.getCustomerId();
    String countryName = cf.getCountryName(countryId);
    Properties properties = ApplicationListener.prop;
    String vehicleImagePath = properties.getProperty("vehicleImagePath");
    String unit = cf.getUnitOfMeasure(systemId);
    String latitudeLongitude = cf.getCoordinates(systemId);
    String ipAddress = properties.getProperty("tclIpAaddress");
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

              .greenMid {
                background: green ;
                border-left:1px solid black;

              }

              .danger {
                background: red ;

              }

              .yellow {
                background: yellow ;
                border-left:1px solid #A9A9A9;

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
                border: 1px solid red;
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
                color: #E9681B !important;
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

     input[type=text] {
       margin:2px 0px 2px 0px;
       width:100%;
     }
     #custName, #vehicleType {
       margin:2px 0px 2px 0px;
     }
     .col-md-6, .col-md-7, .col-md-1, .col-md-4{
       padding:16px;
       text-align:left;
     }

     .temps {
       border:1px solid #BEC1C4;
       margin-top:8px;
       margin-right:16px;
       padding:8px;
     }

     .doorsLeft {
       border:1px solid #8D33AA;
       margin-top:8px;
       margin-right:16px;
       padding:8px;
     }
     .doorsRight{
       border:1px solid #E9681B;
       margin-top:8px;
       margin-right:16px;
       padding:8px;
     }
     .doorsBack {
       border:1px solid #EABC00;
       margin-top:8px;
       margin-right:16px;
       padding:8px;
     }

     .dispNone
     {
       display:none;
     }



.leftDoor {
  text-align:center;
  text-transform: uppercase;
  color: #8D33AA ;
  font-weight:bold;
}

.rightDoor {
  text-align:center;
  text-transform: uppercase;
  color: #E9681B;
  font-weight:bold;
}

.backDoor {
  text-align:center;
  text-transform: uppercase;
  color: #EABC00;
  font-weight:bold;
}
     #leftDoors .col-md-4, #rightDoors .col-md-4, #backDoors .col-md-4 {padding:0px;}

     #backDoors {margin-top:24px;}
  .col-md-8{
    text-align: left;
  }

  select {
    width: 100%;
  }

  .inputWidth {
    width:40px;
  }

  .padNone {
    padding:0px;
  }

  .padNoneTop
  {
    padding:0px;
    text-align:center;
    font-weight:bold;
    color: green;
  }

      </style>

      <!-- content -->
      <div class="dispNone" id="loading" style="position: absolute; top: 40%; left: 50%; display: none; z-index: 1000000;">
        <img src="../../Main/images/loading.gif" alt="">
      </div>
      <div class="row" id="columnContainer">
        <div class="col-lg-12" id="midColumn">
           <div class="tabs-container blueGrey" style="color:white;">
                  <ul class="nav nav-tabs">
                     <li class="active"><a href="#mapViewId" data-toggle="tab" onclick="changeTab('mapViewId')" style="margin:0px;border-radius: 0px;font-size: 15px;font-weight: 600;height:32px;padding-top:4px;">Settings</a></li>
                     <li><a href="#listViewId" data-toggle="tab" onclick="changeTab('listViewId')" style="border-radius: 0px;font-size: 15px;font-weight: 600;height:32px;padding-top:4px;margin:0px">Configuration</a></li>
                  </ul>
              </div>
               <div class="tab-content" id="tabs" style="margin-top:16px;margin-left:16px;">
                  <div class="tab-pane active" id="mapViewId">

                    <div class="row">
                      <div class="col-md-1" style="padding:0px">
                        Customer Name:<span id="custNameRequired" style="color:red;display:none;"><br/>(* Required)</span>
                      </div>
                      <div class="col-md-2">
                        <select id="custName" style="width:150px;">
                        </select>
                      </div>
                      <div class="col-md-1" style="padding:0px">
                        Vehicle Type:<span id="vehicleTypeRequired" style="color:red;display:none;"><br/>(* Required)</span>
                      </div>
                      <div class="col-md-2">
                        <select id="vehicleType" onchange="reset();" style="width:150px;">
                        </select>
                      </div>
                      <div class="col-md-3">
                         <button class="btn btn-generate btn-md btn-primary btn-block" style="background:#18519E;width:150px" type="submit" value="Submit" onClick="getSettings()">GET SETTINGS</button>
                      </div>
                    </div><br/>
                    <div class="row dispNone" id="settingsBox">
                      <div class="col-md-6 card">
                        <div class="row" >
                          <div class="col-md-12" style="text-align:right;">
                            <div class="col-md-6 greenFont" style="text-transform: uppercase;" id="msg"></div>
                            <div class="col-md-6" id="clearSave"  style="text-align:right;">
                              <button class="btn btn-generate btn-md btn-primary green" style="width:75px" type="submit" value="Submit" onClick="$('#settingsBox').addClass('dispNone');">CLOSE</button>
                              <button class="btn btn-generate btn-md btn-primary" style="margin-top:0px;background:#18519E;width:75px" type="submit" value="Submit" onClick="sendConfigInfo()">SAVE</button>
                            </div>
                          </div>
                        </div>
                        <div class="row" >
                          <div class="col-md-12 greenFont" style="font-weight:bold;">
                            DOORS<br/><br/>
                          </div>
                        </div>
                        <div class="row">
                          <div class="col-md-3">
                            Doors Left:
                          </div>
                          <div class="col-md-9">
                            <input type="text" id="leftCount" name="leftCount"/>
                          </div>
                        </div>
                        <div class="row">
                          <div class="col-md-3">
                            Doors Right:
                          </div>
                          <div class="col-md-9">
                            <input type="text" id="rightCount" name="rightCount"/>
                          </div>
                        </div>
                        <div class="row">
                          <div class="col-md-3">
                            Doors Back:
                          </div>
                          <div class="col-md-9">
                            <input type="text" id="backCount" name="backCount"/>
                          </div>
                        </div>
                        <div class="row" >
                          <div class="col-md-12 greenFont" style="font-weight:bold;">
                            <br/>TEMPERATURE<br/><br/> 
                          </div>
                        </div>
                        <div class="row">
                          <div class="col-md-3">
                            Temperature Front:
                          </div>
                          <div class="col-md-9">
                            <input type="checkbox" id="temperatureFront" name="temperatureFront"/>
                          </div>
                        </div>
                        <div class="row">
                          <div class="col-md-12" style="padding-left:16px;">
                            <br/>Temperature Middle:
                          </div>
                        </div>
                       <div class="row">
                          <div class="col-md-3"  style="padding-left:48px;">
                            Sensor Count:<br/><br/>
                          </div>
                          <div class="col-md-9">
                            <input type="number" id="sensorCount" name="sensorCount"/><br/><br/>
                          </div>
                        </div>
                        <div class="row">
                          <div class="col-md-3">
                            Temperature Back:
                          </div>
                          <div class="col-md-9">
                            <input type="checkbox" id="temperatureBack" name="temperatureBack"/>
                          </div>
                        </div><br/>
                      </div>
                    </div>
               </div>
              <div class="tab-pane" style="border:none;" id="listViewId" >
                <div class="row">

                  <div class="col-md-12" style="padding:0px 0px 16px 0px">
                    <div class="col-md-1" style="padding:0px">
                       Action:<span id="actionRequired" style="color:red;display:none;"><br/>(* Required)</span>
                    </div>
                    <div class="col-md-2">
                      <select id="action" style="width:150px;">
                        <option value="0">SELECT ACTION</option>
                        <option value="get">Get Configuration</option>
                        <option value="set">Set Configuration</option>
                      </select>
                    </div>
                    <div class="col-md-1" style="padding:0px">
                      Customer Name:<span id="custNameConfigRequired" style="color:red;display:none;"><br/>(* Required)</span>
                    </div>
                    <div class="col-md-2">
                      <select id="custNameConfig" style="width:150px;">
                      </select>
                    </div>
                      <div class="col-md-1" style="padding:0px">
                        Vehicle Type:<span id="vehicleTypeConfigRequired" style="color:red;display:none;"><br/>(* Required)</span>
                      </div>
                      <div class="col-md-1" style="padding:0px">
                        <select id="vehicleTypeConfig" style="width:75px;">
                        </select>
                      </div>
                      <div class="col-md-1" style="padding:0px">
                        Registration No:<span id="registrationNoRequired" style="color:red;display:none;"><br/>(* Required)</span>
                      </div>
                      <div class="col-md-2">
                        <select id="registrationNo" style="width:150px;height: 24px;" required multiple>
                        </select>
                      </div>
                      <div class="col-md-1" style="padding:0px"><button class="btn btn-generate btn-md btn-primary btn-block" style="background:#18519E;width:70px" type="submit" value="Submit" onClick="getConfiguration('go')">GO</button>
</div>


                  </div>
                </div><br/>
                <div class="row dispNone" id="resetSave" style="width:100%">
                  <div class="col-md-9"></div>
                  <div class="col-md-1">
                    <button class="btn btn-generate btn-md btn-primary btn-block" style="background:#18519E;width:75px;margin-top: -38px;margin-left: 85px;" type="submit" tabindex="201" value="Submit" onClick="getConfiguration('clear')">RESET</button>
                  </div>
                  <div class="col-md-1">
                    <button class="btn btn-generate btn-md btn-primary btn-block" style="background:#00897B;width:100px;margin-left: 66px;margin-top: -38px;" type="submit" tabindex="200" value="Submit" onClick="saveConfig()">SAVE</button>
                  </div>
                </div>
                <div class="row dispNone" id="doorConfig">
                  <div class="col-md-7 card" id="leftConfig" style="margin-right:16px;">
                    <div class="row" style="margin-bottom: 0px;"><div class="col-md-10 greenFont" style="padding:0px;margin:0px;"><strong>DOOR CONFIGURATION</strong> (<span style="color:red">* All fields are mandatory</span>)</div>
                    <!--<div class="col-md-2" style="padding:0px;"> <button class="btn btn-generate btn-md btn-primary btn-block" style="background:#18519E;width:75px" type="submit" tabindex="100" value="Submit" onClick="saveDoorConfig()">SAVE</button></div>--></div>
                    <div class="row" style="margin-bottom:0px;"><div class="col-md-1" style="padding:0px;">Unit:</div><div class="col-md-3"> <select id="doorUnit">
                      <option value="1">minutes</option>
                      <option value="2">seconds</option>
                    </select></div>
                  </div>
                  <div class="row" style="margin-bottom:0px;"><div class="col-md-12 dispNone" style="border:1px solid red;margin-top:16px;padding:16px;"  id="msgDoor"></div>
                  </div>
                    <div class="row" style="margin-bottom:0px;">
                      <div class="col-md-5" style="text-align:center;">
                        <div id="leftDoors">
                        </div>
                        
                      </div>
                      <div class="col-md-2" style="text-align:center;"><div style="margin-top:124px;margin-bottom:24px;">TRUCK FRONT </div>
                        <img src="/ApplicationImages/truck_ORC.png" style="width:90%;"/>
                        <div  style="margin-top:24px;">TRUCK BACK</div>
                      </div>
                      <div class="col-md-5" style="text-align:center;">
                      <div id="rightDoors"></div>
                      </div>
                    </div>
                    <div class="row">
                      <div class="col-md-12" style="text-align:center;">
                        <div id="backDoors" class="row">
                          <div class="col-md-1"></div>
                        </div>
                      </div>
                    </div>
                  </div>
                  <div class="col-md-4 card">
                    <div class="row" style="margin-bottom:0px;"><div class="col-md-10 greenFont" style="padding:0px;margin:0px;"><strong>TEMPERATURE CONFIGURATION</strong> (<span style="color:red">* All fields are mandatory</span>)</div>
                    </div>
                    <div class="row"><div class="col-md-2">Unit:</div><div class="col-md-3"><select tabIndex="203" id="tempUnit" style="width:150px;">
                      <option value="1">Centigrade</option>
                      <option value="1">Fahrenheit</option>
                    </select></div>
                  </div>
                  <div class="row" style="margin-bottom:0px;"><div class="col-md-12 dispNone" style="border:1px solid red;padding:16px;" id="msgTemp"></div>
                  </div>
                    <div class="row dispNone" id="tempConfig">
                      <div class="col-md-12">
                        <br/><strong>TEMPERATURE FRONT</strong>
                        <div id="frontTemp">
                        </div>
                      </div>
                    </div>
                    <div class="row">
                      <div class="col-md-12">
                        <div id="middleTemp">

                        </div>
                      </div>
                    </div>
                    <div class="row">
                      <div class="col-md-12">
                        <div  id="backTemp">
                        </div>
                      </div>
                    </div>
                  </div>
                </div>
              </div>

               </div>
        </div>

      </div>








<script src="//code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
<script>

var sysId = 0;
var custId = <%=clientId%>;
var sensorNames = "";
var countLeft = 0;
var countRight = 0;
var countBack = 0;
var countFront = 0;
var countMiddle = 0;
var countTempBack = 0;

var l = 0;
var r = 0;
var b = 0;
var tm = 0;

 function reset(){
	    $('#settingsBox').addClass('dispNone');
	    $("#clearSave").addClass("dispNone");
		
	}
 function resetConfig(){
      //$('#doorConfig').addClass('dispNone');
      //$('#resetSave').addClass('dispNone');
      //$("#vehicleTypeConfig").val("0");
      $("#action").val("get");
      getVehiclesNow1();
      
      //$("#doorConfig").prop("disabled", true);
  }
  function changeTab(tab) {
console.log(tab);
        $('#settingsBox').addClass('dispNone');
        $("#vehicleType").val("0");
        
	if(tab=='listViewId'){
            $('#mapViewId').addClass('dispNone');
        }else{
            $('#mapViewId').removeClass('dispNone');
        }
        
    };
 
$(document).ready(function() {
  
  $.ajax({
       type: "GET",
       url: '<%=ipAddress%>/getCustomerNames',
       datatype:'json',
       contentType: "application/json",
       data: {
           systemId: <%=systemId%>
       },
       success: function(result) {
         $("#custName").append("<option value='0'>SELECT CUSTOMER</option>")
         $("#custNameConfig").append("<option value='0'>SELECT CUSTOMER</option>")
         $.each(result.responseBody, function (key, item) {
            if(custId == item.id)
            {
              $("#custName").append("<option value="+item.id+">"+item.customerName+"</option>")
              $("#custNameConfig").append("<option value="+item.id+">"+item.customerName+"</option>")
            }
            if(custId==0){
                $("#custName").append("<option value="+item.id+">"+item.customerName+"</option>")
                $("#custNameConfig").append("<option value="+item.id+">"+item.customerName+"</option>")
            }
           })
          
         }
       }
   );

   $.ajax({
        type: "GET",
        url: '<%=ipAddress%>/getVehicleTypes',
        datatype:'json',
        contentType: "application/json",
        data: {
            systemId: <%=systemId%>
        },
        success: function(result) {
          $("#vehicleType").append("<option value='0'>SELECT VEHICLE</option>")
          $("#vehicleTypeConfig").append("<option value='0'>SELECT VEHICLE</option>")
          $.each(result.responseBody, function (key, item) {
               $("#vehicleType").append("<option value="+item.categoryCode+">"+item.categoryName+"</option>")
               $("#vehicleTypeConfig").append("<option value="+item.categoryCode+">"+item.categoryName+"</option>")

                })
            }
    });

    $("#vehicleTypeConfig").on("change", function(){
      getVehiclesNow();
    })

    $("#action").on("change", function(){
      $("#vehicleTypeConfig").val("0");
      $("#custNameConfig").val("0");

      if( $("#vehicleTypeConfig").val() != "")
      {
            getVehiclesNow();
      }
    })

    function getVehiclesNow()
    {
      if($("#action").val() == "")
      {
        $("#actionRequired").show();
        return;
      }
      else {
        $("#actionRequired").hide();
        if($("#action").val() == "get") { $("#registrationNo").prop("multiple", "") }
        if($("#action").val() == "set") { $("#registrationNo").prop("multiple", "multiple") }
      }
      $.ajax({
           type: "GET",
           url: '<%=ipAddress%>/getVehicleNo',
           datatype:'json',
           contentType: "application/json",
           data: {
               customerId: $("#custNameConfig").val(),
               systemId: <%=systemId%>,
               vehicleType: $("#vehicleTypeConfig").val(),
               action: $("#action").val()
           },
           success: function(result) {
             $("#registrationNo").find('option').remove();
            $.each(result.responseBody, function (key, item) {
                  $("#registrationNo").append("<option value="+item+">"+item+"</option>")
               })
               $("#registrationNo").multiselect({
                  enableFiltering: true,
                  includeSelectAllOption: true,
                  maxHeight: 200,
                  maxWidth: 300,
                  dropUp: false
                });
                $("#registrationNo").multiselect('rebuild');
               }
       });


    }



     $.ajax({
          type: "GET",
          url: '<%=ipAddress%>/getSensorNames',
          datatype:'json',
          contentType: "application/json",
          data: {
          },
          success: function(result) {
            sensorNames += "<option value=''>SELECT SENSOR</option>"
            $.each(result.responseBody, function (key, item) {
              sensorNames += "<option value="+item.sensorName+">"+item.sensorName+"</option>"

              })

              }
      });
});

function getSettings()
{

   if($("#custName").val() == "0")
   {
   sweetAlert("Please Select customer name");
   return;
   }
   
   if($("#vehicleType").val() == "0")
   {
   sweetAlert("Please Select vehicleType");
   return;
   }

   document.getElementById('leftCount').disabled = false;
   document.getElementById('rightCount').disabled = false;
   document.getElementById('backCount').disabled = false;
   document.getElementById('sensorCount').disabled = false;
  $("#temperatureFront" ).prop( "disabled", false );
  $("#temperatureBack" ).prop( "disabled", false );
  $('#settingsBox').addClass('dispNone');
   $("#clearSave").removeClass("dispNone");
  $("#loading").show();

  if($("#custName").val() == "")
  {
   system.out.println("please select customer name");
    $("#custNameRequired").show();
  }
  else {
    $("#custNameRequired").hide();
  }

  if($("#vehicleType").val() == "")
  {
    $("#vehicleTypeRequired").show();
  }
  else {
    $("#vehicleTypeRequired").hide();
  }

  if( $("#vehicleType").val() == "" || $("#custName").val() == "")
  {
    return;
  }
  
  $("#leftCount").val("");
  $("#rightCount").val("");
  $("#backCount").val("");
  $("#temperatureFront").prop('checked', false);
  $("#temperatureBack").prop('checked', false);
  $("#sensorCount").val("");
  $("#msg").html("");
  $.ajax({
       type: "GET",
       url: '<%=ipAddress%>/getTemperatureSettings',
       datatype:'json',
       contentType: "application/json",
       data: {
           systemId: <%=systemId%>,
           customerId: $("#custName").val(),
           vehicleType: $("#vehicleType").val()
       },
       success: function(result) {
         console.log("result", result);
         $("#settingsBox").removeClass("dispNone");
         $("#loading").hide();
         if(result.responseBody != "No records found")
         {
	         if(result.message=='true'){
	         
		        document.getElementById('leftCount').disabled = true;
		        document.getElementById('rightCount').disabled = true;
		        document.getElementById('backCount').disabled = true;
		        document.getElementById('sensorCount').disabled = true;
	        
	            $("#temperatureFront" ).prop( "disabled", true );
	            $("#temperatureBack" ).prop( "disabled", true );
	             $("#clearSave").addClass("dispNone");
	         }else{
	            document.getElementById('leftCount').disabled = false;
                document.getElementById('rightCount').disabled = false;
                document.getElementById('backCount').disabled = false;
                document.getElementById('sensorCount').disabled = false;
                
                $("#temperatureFront" ).prop( "disabled", false );
                $("#temperatureBack" ).prop( "disabled", false );
                 $("#clearSave").removeClass("dispNone");
	         }

	          var doorSensorSettings = result.responseBody.doorSensorSettings;
              var temperatureSettings = result.responseBody.temperatureSettings;
              $("#leftCount").val(doorSensorSettings.leftCount);
              $("#rightCount").val(doorSensorSettings.rightCount);
              $("#backCount").val(doorSensorSettings.backCount);
              (temperatureSettings.temperatureFront == "TF")?  $("#temperatureFront").prop('checked', true) :"";
              (temperatureSettings.temperatureBack == "TB")?  $("#temperatureBack").prop('checked', true):"";
              $("#sensorCount").val(temperatureSettings.temperatureMiddle.sensorCount);
           
         }

         }
       }
   );




}

function getConfiguration(type)
{
	if(type == 'clear') {
		$("input[type=text]").val("");
		$("input[type=number]").val("");
	} else {

  if($("#action").val() == "0")
  {
    $("#actionRequired").show();
  }
  else {
    $("#actionRequired").hide();
  }

  if($("#custNameConfig").val() == "0")
  {
    $("#custNameConfigRequired").show();
  }
  else {
    $("#custNameConfigRequired").hide();
  }

  if($("#vehicleTypeConfig").val() == "0")
  {
    $("#vehicleTypeConfigRequired").show();
  }
  else {
    $("#vehicleTypeConfigRequired").hide();
  }

  if($("#registrationNo").val() == "0")
  {
    $("#registrationNoRequired").show();
  }
  else {
    $("#registrationNoRequired").hide();
  }

  if( $("#action").val() == "" || $("#vehicleTypeConfig").val() == "" || $("#custNameConfig").val() == "" || $("#registrationNo").val() == "")
  {
    return;
  }
  $("#loading").show();

  $.ajax({
       type: "GET",
       url: '<%=ipAddress%>/getTemperatureSettings',
       datatype:'json',
       contentType: "application/json",
       data: {
           systemId: <%=systemId%>,
           customerId: $("#custNameConfig").val(),
           vehicleType: $("#vehicleTypeConfig").val()
       },
       success: function(result) {
        // $("#settingsBox").removeClass("dispNone");
        $("#loading").hide();

         if(result.responseBody != "No records found")
         {
           $("#tempConfig").removeClass("dispNone");
           $("#doorConfig").removeClass("dispNone");
           $("#resetSave").removeClass("dispNone");
           console.log("Actual Data", result);
           var doorSensorSettings = result.responseBody.doorSensorSettings;
           var temperatureSettings = result.responseBody.temperatureSettings;
           l = doorSensorSettings.leftCount;
           r = doorSensorSettings.rightCount;
           b = doorSensorSettings.backCount;
           tm = temperatureSettings.temperatureMiddle.sensorCount;
           if( l == "0" && r == "0" && b == "0")
           {
           	$("#leftConfig").addClass("dispNone");
           }
           else
           {
           	$("#leftConfig").removeClass("dispNone");
           }
           $.ajax({
                type: "GET",
                url: '<%=ipAddress%>/getConfigurationDetails',
                datatype:'json',
                contentType: "application/json",
                data: {
                    systemId: <%=systemId%>,
                    customerId: $("#custNameConfig").val(),
                    vehicleType: $("#vehicleTypeConfig").val(),
                    registrationNo: $("#registrationNo").val().toString()

                },
                success: function(result) {
                    countLeft = 0;
                    countRight = 0;
                    countBack = 0;
                    countFront = 0;
                    countMiddle = 0;
                    countTempBack = 0;
                    $("#frontTemp").html("");
                    $("#middleTemp").html("");
                    $("#backTemp").html("");
                    $("#leftDoors").html("");
                    $("#backDoors").html("<div class='col-md-1'></div>");
                    $("#rightDoors").html("");
                    var tabindex = 1;
                     $.each(result.responseBody.doorSensorConfiguration, function (key, item) {
                       $("#doorUnit").val(item.timeLimitUnit);

                       if(item.type == "left")
                       {
                         var html = "<div class='col-md-4'>Name:</div><div class='col-md-8'> <input tabindex='"+(tabindex++)+"' type='text' value='"+item.name+"' id='ld"+countLeft+"name' /></div>"
                         html += "<div class='col-md-4'>Time Limit:</div><div class='col-md-8'> <input tabindex='"+(tabindex++)+"'  value='"+item.timeLimit+"' type='text' id='ld"+countLeft+"timeLimit' /></div>"
                         html += "<div class='col-md-4'>Sensor Name: </div><div class='col-md-8'><select tabindex='"+(tabindex++)+"'  id='ld"+countLeft+"sensorName'>"+sensorNames+"</select></div>";
                         countLeft++;
                         $("#leftDoors").append("<br/><div class='leftDoor'>Left Door "+countLeft+"</div><div class='row doorsLeft'>"+html+"</div>");
                         $("#ld"+(countLeft-1)+"sensorName").val(item.sensorName);

                       }
                       if(item.type == "right")
                       {
                         var html = "<div class='col-md-4'>Name:</div> <div class='col-md-8'><input tabindex='"+(tabindex++)+"'  value='"+item.name+"' type='text' id='rd"+countRight+"name' /></div>"
                         html += "<div class='col-md-4'>Time Limit:</div><div class='col-md-8'> <input tabindex='"+(tabindex++)+"'  value='"+item.timeLimit+"' type='text' id='rd"+countRight+"timeLimit' /></div>"
                         html += "<div class='col-md-4'>Sensor Name: </div><div class='col-md-8'><select tabindex='"+(tabindex++)+"'  id='rd"+countRight+"sensorName'>"+sensorNames+"</select></div>";
                         countRight++;
                         $("#rightDoors").append("<br/><div class='rightDoor'>Right Door "+countRight+"</div><div class='row doorsRight'>"+html+"</div>");
                         $("#rd"+(countRight-1)+"sensorName").val(item.sensorName);

                       }
                       if(item.type == "back")
                       {
                         var html = "<div class='col-md-4'>Name:</div><div class='col-md-8'> <input tabindex='"+(tabindex++)+"'  value='"+item.name+"' type='text' id='bd"+countBack+"name' /></div>"
                         html += "<div class='col-md-4'>Time Limit:</div><div class='col-md-8'> <input tabindex='"+(tabindex++)+"'  value='"+item.timeLimit+"'  type='text' id='bd"+countBack+"timeLimit' /></div>"
                         html += "<div class='col-md-4'>Sensor Name:</div><div class='col-md-8'><select tabindex='"+(tabindex++)+"'  id='bd"+countBack+"sensorName'>"+sensorNames+"</select></div>";
                           countBack++;
                           $("#backDoors").append("<div class='col-md-5'><div class='backDoor'>Back Door "+countBack+"</div><div class='row doorsBack'>"+html+"</div></div>");
                           $("#bd"+(countBack-1)+"sensorName").val(item.sensorName);
                         }




                     })

                    for (var i = countLeft; i < l; i++) {
                       var html = "<div class='col-md-4'>Name:</div><div class='col-md-8'> <input tabindex='"+(tabindex++)+"' type='text' id='ld"+i+"name' /></div>"
                       html += "<div class='col-md-4'>Time Limit:</div><div class='col-md-8'> <input tabindex='"+(tabindex++)+"' type='text' id='ld"+i+"timeLimit' /></div>"
                       html += "<div class='col-md-4'>Sensor Name:</div><div class='col-md-8'><select tabindex='"+(tabindex++)+"' id='ld"+i+"sensorName'>"+sensorNames+"</select></div>";
                       $("#leftDoors").append("<br/><div class='leftDoor'>Left Door "+(i+1)+"</div><div class='row doorsLeft'>"+html+"</div>");

                     }
                     for (var i = countRight; i < r; i++) {
                       var html = "<div class='col-md-4'>Name:</div> <div class='col-md-8'><input tabindex='"+(tabindex++)+"' type='text' id='rd"+i+"name' /></div>"
                       html += "<div class='col-md-4'>Time Limit:</div><div class='col-md-8'> <input tabindex='"+(tabindex++)+"' type='text' id='rd"+i+"timeLimit' /></div>"
                       html += "<div class='col-md-4'>Sensor Name:</div><div class='col-md-8'><select tabindex='"+(tabindex++)+"' id='rd"+i+"sensorName'>"+sensorNames+"</select></div>";
                       $("#rightDoors").append("<br/><div class='rightDoor'>Right Door "+(i+1)+"</div><div class='row doorsRight'>"+html+"</div>");

                     }
                     for (var i = countBack; i < b; i++) {
                       var html = "<div class='col-md-4'>Name:</div><div class='col-md-8'> <input tabindex='"+(tabindex++)+"' type='text' id='bd"+i+"name' /></div>"
                       html += "<div class='col-md-4'>Time Limit:</div><div class='col-md-8'> <input tabindex='"+(tabindex++)+"' type='text' id='bd"+i+"timeLimit' /></div>"
                       html += "<div class='col-md-4'>Sensor Name:</div><div class='col-md-8'><select tabindex='"+(tabindex++)+"' id='bd"+i+"sensorName'>"+sensorNames+"</select></div>";
                       $("#backDoors").append("<div class='col-md-5'><div class='backDoor'>Back Door "+(i+1)+"</div><div class='row doorsBack'>"+html+"</div></div>");

                     }
                     
                     var tfDone = false;
                     var tbDone = false;
                     tabindex = 101;
                     $.each(result.responseBody.temperatureConfiguration, function (key, item) {
                       $("#tempUnit").val(item.unit);
                       if(item.type == "front" && item.name)
                       {
                         var htmlTemp = "Name:<br/> <input tabindex='"+(tabindex++)+"' value='"+item.name+"' type='text' id='tfName' /><br/>";
                         htmlTemp += "Sensor Name:<br/> <select tabindex='"+(tabindex++)+"' id='tfSensorName' style='height:28px;'>"+sensorNames+"</select><br/>"
                         htmlTemp += "<br/><div class='row'><div class='col-xs-2 padNoneTop orangeFont'>Abnormal<br/>Alert</div><div class='col-xs-1 '></div><div class='col-xs-1 padNoneTop'>Min<br/>Temp</div><div class='col-xs-3'></div><div class='col-xs-2 padNoneTop' style='padding-left: 32px;'>Smart<br/>Alert</div><div class='col-xs-1'></div><div class='col-xs-2 padNoneTop orangeFont'>Max Temp<br/>Alert</div></div>"
                         htmlTemp += "<div class='row'><div class='col-xs-1 padNone danger'></div>";
                         htmlTemp += "<div class='col-xs-1 padNone'><input class='inputWidth' tabindex='"+(tabindex++)+"' value='"+item.minNegativeTemp+"' type='number' id='tfMinNegTemp' /></div>";
                         htmlTemp += "<div class='col-xs-1 padNone yellow'></div>";
                         htmlTemp += "<div class='col-xs-1 padNone'><input class='inputWidth' tabindex='"+(tabindex++)+"' value='"+item.maxNegativeTemp+"' type='number' id='tfMaxNegTemp' /></div>";
                         htmlTemp += "<div class='col-xs-4 padNone greenMid'></div>";
                         htmlTemp += "<div class='col-xs-1 padNone'><input class='inputWidth' tabindex='"+(tabindex++)+"' value='"+item.minPositiveTemp+"' type='number' id='tfMinPosTemp' /></div>"
                         htmlTemp += "<div class='col-xs-1 padNone yellow'></div>";
                         htmlTemp += "<div class='col-xs-1 padNone'><input class='inputWidth' tabindex='"+(tabindex++)+"' value='"+item.maxPositiveTemp+"' type='number' id='tfMaxPosTemp' /></div>";
                         htmlTemp += "<div class='col-xs-1 padNone danger'></div></div><br/>";
                         $("#frontTemp").append("<div class='row'><div class='col-md-12 temps'>"+htmlTemp+"</div></div>");
                         $("#tfSensorName").val(item.sensorName);

                         tfDone = true;

                       }
                       if(item.type == "middle" && item.name)
                       {
                         var htmlTemp = "Name: <br/><input tabindex='"+(tabindex++)+"' value='"+item.name+"' type='text' id='tm"+countMiddle+"Name' /><br/>";
                         htmlTemp += "Sensor Name:<br/><select id='tm"+countMiddle+"sensorName' tabindex='"+(tabindex++)+"' style='height:28px;'>"+sensorNames+"</select><br/>"
                         htmlTemp += "<br/><div class='row'><div class='col-xs-2 padNoneTop orangeFont'>Abnormal<br/>Alert</div><div class='col-xs-1 '></div><div class='col-xs-1 padNoneTop'>Min<br/>Temp</div><div class='col-xs-3'></div><div class='col-xs-2 padNoneTop' style='padding-left: 32px;'>Smart<br/>Alert</div><div class='col-xs-1'></div><div class='col-xs-2 padNoneTop orangeFont'>Max Temp<br/>Alert</div></div>"
                         htmlTemp += "<div class='row'><div class='col-xs-1 padNone danger'></div>";
                         htmlTemp += "<div class='col-xs-1 padNone'><input class='inputWidth' tabindex='"+(tabindex++)+"' value='"+item.minNegativeTemp+"' type='number' id='tm"+countMiddle+"MinNegTemp' /></div>";
                          htmlTemp += "<div class='col-xs-1 padNone yellow'></div>";
                         htmlTemp += "<div class='col-xs-1 padNone'><input class='inputWidth' tabindex='"+(tabindex++)+"' value='"+item.maxNegativeTemp+"' type='number' id='tm"+countMiddle+"MaxNegTemp' /></div>";
                          htmlTemp += "<div class='col-xs-4 padNone greenMid'></div>";
                         htmlTemp += "<div class='col-xs-1 padNone'><input class='inputWidth' tabindex='"+(tabindex++)+"' value='"+item.minPositiveTemp+"' type='number' id='tm"+countMiddle+"MinPosTemp' /></div>"
                          htmlTemp += "<div class='col-xs-1 padNone yellow'></div>";
                         htmlTemp += "<div class='col-xs-1 padNone'><input class='inputWidth' tabindex='"+(tabindex++)+"' value='"+item.maxPositiveTemp+"' type='number' id='tm"+countMiddle+"MaxPosTemp' /></div>";
                         htmlTemp += "<div class='col-xs-1 padNone danger'></div></div><br/>";
                         $("#middleTemp").append("<br/><strong>TEMPERATURE MIDDLE</strong><br/><div class='col-md-12 temps'>"+htmlTemp+"</div>");
                         $("#tm"+countMiddle+"sensorName").val(item.sensorName);
                         countMiddle++;

                       }
                       if(item.type == "back" && item.name)
                       {
                         var htmlTemp = "Name: <br/><input tabindex='"+(tabindex++)+"' value='"+item.name+"' type='text' id='tbName' /><br/>";
                         htmlTemp += "Sensor Name:<br/><select id='tbSensorName' tabindex='"+(tabindex++)+"' style='height:28px;'>"+sensorNames+"</select><br/>"
                         htmlTemp += "<br/><div class='row'><div class='col-xs-2 padNoneTop orangeFont'>Abnormal<br/>Alert</div><div class='col-xs-1 '></div><div class='col-xs-1 padNoneTop'>Min<br/>Temp</div><div class='col-xs-3'></div><div class='col-xs-2 padNoneTop' style='padding-left: 32px;'>Smart<br/>Alert</div><div class='col-xs-1'></div><div class='col-xs-2 padNoneTop orangeFont'>Max Temp<br/>Alert</div></div>"
                         htmlTemp += "<div class='row'><div class='col-xs-1 padNone danger'></div>";
                         htmlTemp += "<div class='col-xs-1 padNone'><input class='inputWidth' tabindex='"+(tabindex++)+"' value='"+item.minNegativeTemp+"' type='number' id='tbMinNegTemp' /></div>";
                          htmlTemp += "<div class='col-xs-1 padNone yellow'></div>";
                         htmlTemp += "<div class='col-xs-1 padNone'><input class='inputWidth' tabindex='"+(tabindex++)+"' value='"+item.maxNegativeTemp+"' type='number' id='tbMaxNegTemp' /></div>";
                          htmlTemp += "<div class='col-xs-4 padNone greenMid'></div>";
                         htmlTemp += "<div class='col-xs-1 padNone'><input class='inputWidth' tabindex='"+(tabindex++)+"' value='"+item.minPositiveTemp+"' type='number' id='tbMinPosTemp' /></div>"
                          htmlTemp += "<div class='col-xs-1 padNone yellow'></div>";
                         htmlTemp += "<div class='col-xs-1 padNone'><input class='inputWidth' tabindex='"+(tabindex++)+"' value='"+item.maxPositiveTemp+"' type='number' id='tbMaxPosTemp' /></div>";
                         htmlTemp += "<div class='col-xs-1 padNone danger'></div></div><br/>";
                         $("#backTemp").append("<br/><strong>TEMPERATURE BACK</strong><div class='row'><div class='col-md-12 temps'>"+htmlTemp+"</div></div>");
                         $("#tbSensorName").val(item.sensorName);
                         tbDone = true;

                       }

                     })



                     if(!tfDone && temperatureSettings.temperatureFront != ""){
                         var htmlTemp = "Name:<br/> <input tabindex='"+(tabindex++)+"' type='text' id='tfName' /><br/>";
                         htmlTemp += "Sensor Name:<br/> <select tabindex='"+(tabindex++)+"' id='tfSensorName' style='height:28px;'>"+sensorNames+"</select><br/>"
                         htmlTemp += "<br/><div class='row'><div class='col-xs-2 padNoneTop orangeFont'>Abnormal<br/>Alert</div><div class='col-xs-1 '></div><div class='col-xs-1 padNoneTop'>Min<br/>Temp</div><div class='col-xs-3'></div><div class='col-xs-2 padNoneTop' style='padding-left: 32px;'>Smart<br/>Alert</div><div class='col-xs-1'></div><div class='col-xs-2 padNoneTop orangeFont'>Max Temp<br/>Alert</div></div>"
                         htmlTemp += "<div class='row'><div class='col-xs-1 padNone danger'></div>";
                         htmlTemp += "<div class='col-xs-1 padNone'><input tabindex='"+(tabindex++)+"' class='inputWidth' type='number' id='tfMinNegTemp' /></div>";
                          htmlTemp += "<div class='col-xs-1 padNone yellow'></div>";
                         htmlTemp += "<div class='col-xs-1 padNone'><input tabindex='"+(tabindex++)+"' class='inputWidth' type='number' id='tfMaxNegTemp' /></div>";
                          htmlTemp += "<div class='col-xs-4 padNone greenMid'></div>";
                         htmlTemp += "<div class='col-xs-1 padNone'><input tabindex='"+(tabindex++)+"' class='inputWidth' type='number' id='tfMinPosTemp' /></div>"
                          htmlTemp += "<div class='col-xs-1 padNone yellow'></div>";
                         htmlTemp += "<div class='col-xs-1 padNone'><input tabindex='"+(tabindex++)+"' class='inputWidth' type='number' id='tfMaxPosTemp' /></div>";
                         htmlTemp += "<div class='col-xs-1 padNone danger'></div></div><br/>";
                         $("#frontTemp").append("<div class='row'><div class='col-md-12 temps'>"+htmlTemp+"</div></div>");
                       }

                     var countm = 0;
                     for (var i = countMiddle; i < tm; i++) {
                       var htmlTemp = "Name: <br/><input tabindex='"+(tabindex++)+"'  type='text' id='tm"+i+"Name' /><br/>";
                       htmlTemp += "Sensor Name:<br/><select tabindex='"+(tabindex++)+"'  id='tm"+i+"SensorName' style='height:28px;'>"+sensorNames+"</select><br/>"
                       htmlTemp += "<br/><div class='row'><div class='col-xs-2 padNoneTop orangeFont'>Abnormal<br/>Alert</div><div class='col-xs-1 '></div><div class='col-xs-1 padNoneTop'>Min<br/>Temp</div><div class='col-xs-3'></div><div class='col-xs-2 padNoneTop' style='padding-left: 32px;'>Smart<br/>Alert</div><div class='col-xs-1'></div><div class='col-xs-2 padNoneTop orangeFont'>Max Temp<br/>Alert</div></div>"
                       htmlTemp += "<div class='row'><div class='col-xs-1 padNone danger'></div>";
                        htmlTemp += "<div class='col-xs-1 padNone'><input tabindex='"+(tabindex++)+"' class='inputWidth' type='number' id='tm"+i+"MinNegTemp' /></div>";
                         htmlTemp += "<div class='col-xs-1 padNone yellow'></div>";
                        htmlTemp += "<div class='col-xs-1 padNone'><input tabindex='"+(tabindex++)+"' class='inputWidth' type='number' id='tm"+i+"MaxNegTemp' /></div>";
                         htmlTemp += "<div class='col-xs-4 padNone greenMid'></div>";
                       htmlTemp += "<div class='col-xs-1 padNone'><input tabindex='"+(tabindex++)+"' class='inputWidth' type='number' id='tm"+i+"MinPosTemp' /></div>"
                        htmlTemp += "<div class='col-xs-1 padNone yellow'></div>";
                       htmlTemp += "<div class='col-xs-1 padNone'><input tabindex='"+(tabindex++)+"' class='inputWidth' type='number' id='tm"+i+"MaxPosTemp' /></div>";
                       htmlTemp += "<div class='col-xs-1 padNone danger'></div></div><br/>";


                       if(countMiddle == 0 && countm == 0){
                         countm = 1;
                         $("#middleTemp").append("<br/><strong>TEMPERATURE MIDDLE:</strong><br/><div class='col-md-12 temps'>"+htmlTemp+"</div>");
                       }
                       else {
                         $("#middleTemp").append("<div class='col-md-12 temps'>"+htmlTemp+"</div>");
                       }


                     }

                     if(!tbDone && temperatureSettings.temperatureBack != "")
                     {
                       var htmlTemp = "Name: <br/><input tabindex='"+(tabindex++)+"' type='text' id='tbName' /><br/>";
                       htmlTemp += "Sensor Name:<br/> <select tabindex='"+(tabindex++)+"' id='tbSensorName' style='height:28px;'>"+sensorNames+"</select><br/>"
                       htmlTemp += "<br/><div class='row'><div class='col-xs-2 padNoneTop orangeFont'>Abnormal<br/>Alert</div><div class='col-xs-1 '></div><div class='col-xs-1 padNoneTop'>Min<br/>Temp</div><div class='col-xs-3'></div><div class='col-xs-2 padNoneTop' style='padding-left: 32px;'>Smart<br/>Alert</div><div class='col-xs-1'></div><div class='col-xs-2 padNoneTop orangeFont'>Max Temp<br/>Alert</div></div>"
                       htmlTemp += "<div class='row'><div class='col-xs-1 padNone danger'></div>";
                       htmlTemp += "<div class='col-xs-1 padNone'><input tabindex='"+(tabindex++)+"' class='inputWidth' type='number' id='tbMinNegTemp' /></div>";
                        htmlTemp += "<div class='col-xs-1 padNone yellow'></div>";
                       htmlTemp += "<div class='col-xs-1 padNone'><input tabindex='"+(tabindex++)+"' class='inputWidth' type='number' id='tbMaxNegTemp' /></div>";
                        htmlTemp += "<div class='col-xs-4 padNone greenMid'></div>";
                       htmlTemp += "<div class='col-xs-1 padNone'><input tabindex='"+(tabindex++)+"' class='inputWidth' type='number' id='tbMinPosTemp' /></div>"
                        htmlTemp += "<div class='col-xs-1 padNone yellow'></div>";
                       htmlTemp += "<div class='col-xs-1 padNone'><input tabindex='"+(tabindex++)+"' class='inputWidth' type='number' id='tbMaxPosTemp' /></div>";
                       htmlTemp += "<div class='col-xs-1 padNone danger'></div></div><br/>";
                       $("#backTemp").append("<br/><strong>TEMPERATURE BACK</strong><div class='row'><div class='col-md-12 temps'>"+htmlTemp+"</div></div>");
                     }


                  }
                }
            );
         }

         }
       }
   );

}

}

function saveConfig(){
  
  let doorConfig = [];
  let errorLeft = "";
  let errorRight = "";
  let errorBack = "";
  var doors=[];

  //l is number of left Doors, r is number of right doors
  for(var i = 0; i < l; i++)
  {
      if($("#doorUnit").val() == "")
      {
      errorLeft = "Please enter details for all doors on the left";
      $("#doorUnit").addClass("red");
      return;
      }
      else {
        $("#doorUnit").removeClass("red");
      }
      if($("#ld"+i+"name").val()== "")
      {
        errorLeft = "Please enter details for all doors on the left";
        $("#ld"+i+"name").addClass("red");
        return;
      }
      else {
        $("#ld"+i+"name").removeClass("red");
      }
      if($("#ld"+i+"timeLimit").val()== "")
      {
        errorLeft = "Please enter details for all doors on the left";
          $("#ld"+i+"timeLimit").addClass("red");
          return;
      }
      else {
        $("#ld"+i+"timeLimit").removeClass("red");
      }
      if($("#ld"+i+"sensorName").val()== "")
      {
        errorLeft = "Please enter details for all doors on the left";
        $("#ld"+i+"sensorName").addClass("red");
        return;
      }
      else {
        $("#ld"+i+"sensorName").removeClass("red");
      }
    var toPush =   {
        timeLimitUnit:$("#doorUnit").val(),
        name:$("#ld"+i+"name").val(),
        timeLimit:$("#ld"+i+"timeLimit").val(),
        sensorName:$("#ld"+i+"sensorName").val(),
        type:"left"
      }
      doorConfig.push(toPush);
	  doors.push($("#ld"+i+"sensorName").val());
  }

  for(var i = 0; i < r; i++)
  {
    if($("#doorUnit").val() == "")
    {
      errorRight = "Please enter details for all doors on the right";
      $("#doorUnit").addClass("red");
      return;
    }
    else {
      $("#doorUnit").removeClass("red");
    }
    if($("#rd"+i+"name").val()== "")
    {
      errorRight = "Please enter details for all doors on the right";
      $("#rd"+i+"name").addClass("red");
      return;
    }
    else {
      $("#rd"+i+"name").removeClass("red");
    }
    if($("#rd"+i+"timeLimit").val()== "")
    {
      errorRight = "Please enter details for all doors on the right";
        $("#rd"+i+"timeLimit").addClass("red");
        return;
    }
    else {
      $("#rd"+i+"timeLimit").removeClass("red");
    }
    if($("#rd"+i+"sensorName").val()== "")
    {
      errorRight = "Please enter details for all doors on the right";
      $("#rd"+i+"sensorName").addClass("red");
      return;
    }
    else {
      $("#rd"+i+"sensorName").removeClass("red");
    }
    var toPush =   {
        timeLimitUnit:$("#doorUnit").val(),
        name:$("#rd"+i+"name").val(),
        timeLimit:$("#rd"+i+"timeLimit").val(),
        sensorName:$("#rd"+i+"sensorName").val(),
        type:"right"
      }
      doorConfig.push(toPush);
	  doors.push($("#rd"+i+"sensorName").val());
  }

  for(var i = 0; i < b; i++)
  {
    if($("#doorUnit").val() == "")
    {
      errorBack = "Please enter details for all doors on the back";
      $("#doorUnit").addClass("red");
      return;
    }
    else {
      $("#doorUnit").removeClass("red");
    }
    if($("#bd"+i+"name").val()== "")
    {
      errorBack = "Please enter details for all doors on the back";
      $("#bd"+i+"name").addClass("red");
      return;
    }
    else {
      $("#bd"+i+"name").removeClass("red");
    }
    if($("#bd"+i+"timeLimit").val()== "")
    {
      errorBack = "Please enter details for all doors on the back";
        $("#bd"+i+"timeLimit").addClass("red");
        return;
    }
    else {
      $("#bd"+i+"timeLimit").removeClass("red");
    }
    if($("#bd"+i+"sensorName").val()== "")
    {
      errorBack = "Please enter details for all doors on the back";
      $("#bd"+i+"sensorName").addClass("red");
      return;
    }
    else {
      $("#bd"+i+"sensorName").removeClass("red");
    }
    var toPush =   {
        timeLimitUnit:$("#doorUnit").val(),
        name:$("#bd"+i+"name").val(),
        timeLimit:$("#bd"+i+"timeLimit").val(),
        sensorName:$("#bd"+i+"sensorName").val(),
        type:"back"
      }
      doorConfig.push(toPush);
	  doors.push($("#bd"+i+"sensorName").val());
  }
  console.log(doors.length);
  	const unique_doors = Array.from(new Set(doors));
    if(doors.length>unique_doors.length){
        sweetAlert("Door sensor names are duplicate");
        return;
    }
  if (errorLeft != "" || errorRight != "" || errorBack != "" )
  {
    $("#msgDoor").removeClass("dispNone");
    $("#msgDoor").html("* Please enter all the door details")
    return;
  }
  else {
    $("#msgDoor").addClass("dispNone");
  }

  let tempConfig = [];
  let errorTemp = "";
  let errorMinMax = "";
  $("#msgTemp").html("");

      if(parseFloat($("#tfMinPosTemp").val()) >parseFloat($("#tfMaxPosTemp").val()))
      {
        errorMinMax += "Temperature Front: <br/>Smart Alert temperature should be less than Max Alert Temperature."
      }
      if(parseFloat($("#tfMinNegTemp").val()) >parseFloat($("#tfMaxNegTemp").val()))
      {
        errorMinMax += "<br/>Temperature Front: Abnormal Temperature should be less than Min Temperature."
      }

      if(parseFloat($("#tfMaxNegTemp").val()) > parseFloat($("#tfMinPosTemp").val()))
      {
        errorMinMax += "<br/>Temperature Front: Min Temperature should be less than Smart Alert Temperature."
      }

console.log("Error Min Max", errorMinMax);
      if($("#tfName").val() == "")
      {
        errorTemp = "* Please enter all the details";
        $("#tfName").addClass("red");
      }
      else {
        $("#tfName").removeClass("red");
      }
      if($("#tfMinPosTemp").val() == "")
      {
        errorTemp = "* Please enter all the details";
        $("#tfMinPosTemp").addClass("red");
      }
      else {
        $("#tfMinPosTemp").removeClass("red");
      }
      if($("#tfMinNegTemp").val() == "")
      {
        errorTemp = "* Please enter all the details";
        $("#tfMinNegTemp").addClass("red");
      }
      else {
        $("#tfMinNegTemp").removeClass("red");
      }
      if($("#tfMaxPosTemp").val() == "")
      {
        errorTemp = "* Please enter all the details";
        $("#tfMaxPosTemp").addClass("red");
      }
      else {
        $("#tfMaxPosTemp").removeClass("red");
      }
      if($("#tfMaxNegTemp").val() == "")
      {
        errorTemp = "* Please enter all the details";
        $("#tfMaxNegTemp").addClass("red");
      }
      else {
        $("#tfMaxNegTemp").removeClass("red");
      }
      if($("#tempUnit").val() == "")
      {
        errorTemp = "* Please enter all the details";
        $("#tempUnit").addClass("red");
      }
      else {
        $("#tempUnit").removeClass("red");
      }
      if($("#tfSensorName").val() == "")
      {
        errorTemp = "* Please enter all the details";
        $("#tfSensorName").addClass("red");
      }
      else {
        $("#tfSensorName").removeClass("red");
      }


      var toPush =   {
       name:$("#tfName").val(),
       minPositiveTemp:$("#tfMinPosTemp").val(),
       minNegativeTemp:$("#tfMinNegTemp").val(),
       maxPositiveTemp:$("#tfMaxPosTemp").val(),
       maxNegativeTemp:$("#tfMaxNegTemp").val(),
       unit:$("#tempUnit").val(),
       sensorName:$("#tfSensorName").val(),
       type:"front"
      }
      tempConfig.push(toPush);
const temps = [];

  for(var i = 0; i < tm; i++)
  {
    if(parseFloat($("#tm"+i+"MinPosTemp").val()) > parseFloat($("#tm"+i+"MaxPosTemp").val()))
    {
      errorMinMax += "<br/>Temperature Middle: <br/>Smart Alert temperature should be less than Max Alert Temperature."
    }
    if(parseFloat($("#tm"+i+"MinNegTemp").val()) > parseFloat($("#tm"+i+"MaxNegTemp").val()))
    {
      errorMinMax += "<br/>Temperature Middle: Abnormal Temperature should be less than Min Temperature."
    }

    if(parseFloat($("#tm"+i+"MaxNegTemp").val()) > parseFloat($("#tm"+i+"MinPosTemp").val()))
    {
      errorMinMax += "<br/>Temperature Middle: Min Temperature should be less than Smart Alert Temperature."
    }
    if($("#tm"+i+"Name").val() == "")
    {
      errorTemp = "* Please enter all the details";
      $("#tm"+i+"Name").addClass("red");
    }
    else {
      $("#tm"+i+"Name").removeClass("red");
    }
    if($("#tm"+i+"MinPosTemp").val() == "")
    {
      errorTemp = "* Please enter all the details";
      $("#tm"+i+"MinPosTemp").addClass("red");
    }
    else {
      $("#tm"+i+"MinPosTemp").removeClass("red");
    }
    if($("#tm"+i+"MinNegTemp").val() == "")
    {
      errorTemp = "* Please enter all the details";
      $("#tm"+i+"MinNegTemp").addClass("red");
    }
    else {
      $("#tm"+i+"MinNegTemp").removeClass("red");
    }
    if($("#tm"+i+"MaxPosTemp").val() == "")
    {
      errorTemp = "* Please enter all the details";
      $("#tm"+i+"MaxPosTemp").addClass("red");
    }
    else {
      $("#tm"+i+"MaxPosTemp").removeClass("red");
    }
    if($("#tm"+i+"MaxNegTemp").val() == "")
    {
      errorTemp = "* Please enter all the details";
      $("#tm"+i+"MaxNegTemp").addClass("red");
    }
    else {
      $("#tm"+i+"MaxNegTemp").removeClass("red");
    }
    if($("#tempUnit").val() == "")
    {
      errorTemp = "* Please enter all the details";
      $("#tempUnit").addClass("red");
    }
    else {
      $("#tempUnit").removeClass("red");
    }
    if($("#tm"+i+"SensorName").val() == "")
    {
      errorTemp = "* Please enter all the details";
      $("#tm"+i+"SensorName").addClass("red");
    }
    else {
      $("#tm"+i+"SensorName").removeClass("red");
    }
     toPush =   {
     name:$("#tm"+i+"Name").val(),
     minPositiveTemp:$("#tm"+i+"MinPosTemp").val(),
     minNegativeTemp:$("#tm"+i+"MinNegTemp").val(),
     maxPositiveTemp:$("#tm"+i+"MaxPosTemp").val(),
     maxNegativeTemp:$("#tm"+i+"MaxNegTemp").val(),
     unit:$("#tempUnit").val(),
     sensorName:$("#tm"+i+"SensorName").val(),
     type:"middle"
    }
      tempConfig.push(toPush);
      temps.push($("#tm"+i+"SensorName").val());
  }
  if(parseFloat($("#tbMinPosTemp").val()) > parseFloat($("#tbMaxPosTemp").val()))
  {
    errorMinMax += "<br/>Temperature Back: Smart Alert temperature should be less than Max Alert Temperature."
  }
  if(parseFloat($("#tbMinNegTemp").val()) > parseFloat($("#tbMaxNegTemp").val()))
  {
    errorMinMax += "<br/>Temperature Back: Abnormal Temperature should be less than Min Temperature."
  }

  if(parseFloat($("#tbMaxNegTemp").val()) > parseFloat($("#tbMinPosTemp").val()))
  {
    errorMinMax += "<br/>Temperature Back: Min Temperature should be less than Smart Alert Temperature."
  }
  if($("#tbName").val() == "")
  {
    errorTemp = "* Please enter all the details";
    $("#tbName").addClass("red");
  }
  else {
    $("#tbName").removeClass("red");
  }
  if($("#tbMinPosTemp").val() == "")
  {
    errorTemp = "* Please enter all the details";
    $("#tbMinPosTemp").addClass("red");
  }
  else {
    $("#tbMinPosTemp").removeClass("red");
  }
  if($("#tbMinNegTemp").val() == "")
  {
    errorTemp = "* Please enter all the details";
    $("#tbMinNegTemp").addClass("red");
  }
  else {
    $("#tbMinNegTemp").removeClass("red");
  }
  if($("#tbMaxPosTemp").val() == "")
  {
    errorTemp = "* Please enter all the details";
    $("#tbMaxPosTemp").addClass("red");
  }
  else {
    $("#tbMaxPosTemp").removeClass("red");
  }
  if($("#tbMaxNegTemp").val() == "")
  {
    errorTemp = "* Please enter all the details";
    $("#tbMaxNegTemp").addClass("red");
  }
  else {
    $("#tbMaxNegTemp").removeClass("red");
  }
  if($("#tempUnit").val() == "")
  {
    errorTemp = "* Please enter all the details";
    $("#tempUnit").addClass("red");
  }
  else {
    $("#tempUnit").removeClass("red");
  }
  if($("#tbSensorName").val() == "")
  {
    errorTemp = "* Please enter all the details";
    $("#tbSensorName").addClass("red");
  }
  else {
    $("#tbSensorName").removeClass("red");
  }

   toPush =   {
   name:$("#tbName").val(),
   minPositiveTemp:$("#tbMinPosTemp").val(),
   minNegativeTemp:$("#tbMinNegTemp").val(),
   maxPositiveTemp:$("#tbMaxPosTemp").val(),
   maxNegativeTemp:$("#tbMaxNegTemp").val(),
   unit:$("#tempUnit").val(),
   sensorName:$("#tbSensorName").val(),
   type:"back"
  }
      tempConfig.push(toPush);

      if (errorTemp != "")
      {
        $("#msgTemp").removeClass("dispNone");
        $("#msgTemp").html("* Please enter all the temperature details")
        return;
      }
      else {
        $("#msgTemp").addClass("dispNone");
      }

      if(errorMinMax != "")
      {
        $("#msgTemp").removeClass("dispNone");
        $("#msgTemp").append(errorMinMax)
        return;
      }
      else {
          $("#msgTemp").addClass("dispNone");
      }

    temps.push($("#tfSensorName").val());
    temps.push($("#tbSensorName").val());
    const unique_temps = Array.from(new Set(temps));
    if(temps.length>unique_temps.length){
        sweetAlert("Sensor names are duplicate");
        return;
    }
  let configInput = {
       systemId:<%=systemId%>,
       customerId:$("#custNameConfig").val(),
       registrationNo:$("#registrationNo").val().toString(),
       doorSensorConfiguration: doorConfig,
       temperatureConfiguration: tempConfig,
       categoryCode:$("#vehicleTypeConfig").val()
    }
    console.log("nfirnfig Input", configInput);
	$("#loading").show();
     $.ajax({
        url: '<%=ipAddress%>/saveConfigurationDetails',
        type : 'POST',
        data: JSON.stringify(configInput),
        datatype:'json',
        contentType: "application/json",
        success: function(result) {
          $("#loading").hide();
          console.log("Success", result);
          sweetAlert("Saved successfully");
          resetConfig();
        },
        error: function (xhr, status, error) {
          console.log(xhr, status, error);
        }
    });
}

function sendConfigInfo()
{
var sensorCount = document.getElementById("sensorCount").value;

	if($("#temperatureFront").prop('checked') !=true && sensorCount=='' && $("#temperatureBack").prop('checked') !=true)
	{
		sweetAlert("Please Select Atleast One Temperature");
		return;
	}
    $("#loading").show();
    console.log($("#vehicleType").val());
          let configInput = {
               systemId:<%=systemId%>,
               customerId:$("#custName").val(),
               categoryId: $("#vehicleType").val(),
               doorSensorSettings:
                  {
                     leftCount:parseInt($("#leftCount").val()),
                     rightCount:parseInt($("#rightCount").val()),
                     backCount:parseInt($("#backCount").val()),
                     totalCount:parseInt($("#leftCount").val()) +parseInt($("#rightCount").val()) + parseInt($("#backCount").val())
                  },
               temperatureSettings:
                  {
            	      temperatureFront:$("#temperatureFront").is(':checked')? "TF": "",
            	      temperatureMiddle: {
            	          sensorCount:$("#sensorCount").val(),
            	          sensorName: ""
            	      },
            	      temperatureBack:$("#temperatureBack").is(':checked')? "TB": ""
                  }

            }
           $.ajax({
              url: '<%=ipAddress%>/saveTemperatureSettings',
              type : 'POST',
              data: JSON.stringify(configInput),
              datatype:'json',
              contentType: "application/json",
              success: function(result) {
                $("#loading").hide();
                sweetAlert("Saved successfully");
                //$("#msg").html("Saved successfully");
              },
              error: function (xhr, status, error) {
                console.log(xhr, status, error);
              }
          });


}
function getVehiclesNow1()
    {
      if($("#action").val() == "")
      {
        $("#actionRequired").show();
        return;
      }
      else {
        $("#actionRequired").hide();
        if($("#action").val() == "get") { $("#registrationNo").prop("multiple", "") }
        if($("#action").val() == "set") { $("#registrationNo").prop("multiple", "multiple") }
      }
      $.ajax({
           type: "GET",
           url: '<%=ipAddress%>/getVehicleNo',
           datatype:'json',
           contentType: "application/json",
           data: {
               customerId: $("#custNameConfig").val(),
               systemId: <%=systemId%>,
               vehicleType: $("#vehicleTypeConfig").val(),
               action: $("#action").val()
           },
           success: function(result) {
             $("#registrationNo").find('option').remove();
            $.each(result.responseBody, function (key, item) {
                  $("#registrationNo").append("<option value="+item+">"+item+"</option>")
               })
               $("#registrationNo").multiselect({
                  enableFiltering: true,
                  includeSelectAllOption: true,
                  maxHeight: 200,
                  maxWidth: 300,
                  dropUp: false
                });
                $("#registrationNo").multiselect('rebuild');
               }
       });


    }


</script>

  <jsp:include page="../Common/footer.jsp" />
