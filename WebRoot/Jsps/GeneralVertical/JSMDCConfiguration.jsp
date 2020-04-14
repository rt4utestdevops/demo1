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
                padding: 4px;
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
  border: 1px solid #18519E}

  .slidecontainer {
  width: 100%;
}

.slider {
  -webkit-appearance: none;
  width: 100%;
  height: 15px;
  border-radius: 5px;
  background: #d3d3d3;
  outline: none;
  opacity: 0.7;
  margin-top:8px;
  -webkit-transition: .2s;
  transition: opacity .2s;
}

.slider:hover {
  opacity: 1;
}

.slider::-webkit-slider-thumb {
  -webkit-appearance: none;
  appearance: none;
  width: 25px;
  height: 25px;
  border-radius: 50%;
  background: #4CAF50;
  cursor: pointer;
}

.slider::-moz-range-thumb {
  width: 25px;
  height: 25px;
  border-radius: 50%;
  background: #4CAF50;
  cursor: pointer;
}


.flex-container {
  display: flex;
  flex-wrap: nowrap;
  width:100%;
}
.flex-container > div {
  width: 30%;
  margin: 8px 0px;
  text-align: left;
  line-height: 32px;
}


.dropdown1{
	position: relative;
	display: inline-block;
}

.dropdown2{
	position: relative;
	display: inline-block;
}

#input1,#input2,#input3,#input4,#input5,#input6,#input7,#input8,#input9,#input10,#input11{
	 width: 10%;
	 height: 20px;
	 margin: 10px 0px;
}


      </style>

      <div class="center-view" style="display:none;" id="loading-div">
        <img src="../../Main/images/loading.gif" alt="">
      </div>

      <div class="row" style="margin-bottom:8px;margin-left:8px;">
        <div class="col-lg-2">
          <strong>JSMDC Stockyard Configuration</strong>
        </div>
        <div id="dropdown1" class="col-lg-2" style="text-align:left">
          <select id="districtDropDownId" style="display:inline-block" name="selectSmartHub" onchange="getJSMDCStockyard()">
              <option disabled selected value="-1">Select District</option>
               <option value="0">All Districts</option>
                <!-- <option value="0">District 1</option>
				
                <option value="1">District 2</option>
                <option value="2">District 3</option>
              --></select>
        </div>
        <div id="dropdown2" class="col-lg-2" style="text-align:left;">
          <select id="stockyardDropDownId" style="display:inline-block" name="selectSmartHub" onchange="getStockyardInfoForConfiguration()">
              <option disabled selected value="-1">Select Stockyard</option>
                <!--<option value="0">All Stockyards</option>
                --><!--<option value="0">Stockyard 1</option>
                <option value="1">Stockyard 2</option>
                <option value="2">Stockyard 3</option>
              -->
          </select>
        </div>
      </div>

      <div class="row" style="">
        <div class="col-lg-12">
          <div class="row" id="columnContainer5" style="background: #37474F;color: white;padding: 8px; width:100%;" >
              <div class="col-lg-4" style="padding-left:32px;">
                </div>
              <div class="col-lg-4" style="text-align:center;">
                   Stockyard Configuration
              </div>
              <div class="col-lg-4" style="text-align:center;">
                </div>
          </div>
          <div class="row" style="width:100%;">
                        <div class="col-lg-12 card" style="padding:4px 20px;">
                          <div class="flex-container">
                            <div >
                              Stockyard Total permit(<i>cft</i>) 
                            </div>
							<input type="text" id="input1" onchange="DisplayChange()" onkeypress="return isNumberKey(event)"  /> <!-- onclick="updateTotalPermit()" -->
							
							<div style="text-align:right !important;width:2%;">0&nbsp;
                            </div>
							  
							  <br>
                            <div class="slidecontainer">
                              <input type="range" min="0" onchange="mouseUp('stockyardPermit','slider1','input1')"  onmouseup="updateTotalPermit()"  max="100000" value="0"  class="slider" id="stockyardPermit">
								
								<p>Value: <span id="slider1"></span></p>
                            
                            </div>
                            <div class="slidecontainer" class="col-sm-1" >100K&nbsp;&nbsp;
							<span >1000</span>for years (1 to 5)
                            </div>
							
							<input type="text" id="input2" onchange="DisplayChange2()" onkeypress="return isNumberKey(event)"  style="margin-right:2%"  />
							
                            <div  class="slidecontainer">
                              <input type="range" onchange="mouseUp('slider2ranger','slider2','input2')" min="1" max="5" value="50" class="slider" id="slider2ranger" >
                            <p>Value: <span id="slider2"></span></p>
                            </div>
                            
                          </div>
                          <div class="flex-container">
                            <div>
                              Booking Limit (<i>cft</i>)
                            </div>
							
							<input type="text" id="input3" onchange="DisplayChange3()"  onkeypress="return isNumberKey(event)"  />
							
                            <div style="text-align:right !important;width:2%;">0&nbsp;
                            </div>
                            <div class="slidecontainer">
                              <input type="range" onchange="mouseUp('bookingLimit','slider3','input3')" onmouseup="updateBookingLimit()" min="1" max="50000" value="0" class="slider" id="bookingLimit">
                            <p>Value: <span id="slider3"></span></p>
                            </div>
							
							
                            <div class="slidecontainer">50K&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;for weeks (1 to 5)
                            </div>
							<input type="text" id="input4" onchange="DisplayChange4()" onkeypress="return isNumberKey(event)"  style="margin-right:2%"/>
							
                            <div class="slidecontainer">
                              <input type="range" onchange="mouseUp('slider4ranger','slider4','input4')" min="1" max="5" value="50" class="slider" id="slider4ranger">
                              <p>Value: <span id="slider4"></span></p>
                            </div>
                          </div>
                          <div class="flex-container">
                            <div class="col-sm-2">
                              No. of consumer trips
                            </div>
							
							<input type="text" id="input5" onchange="DisplayChange5()" onkeypress="return isNumberKey(event)"  style="margin-left: 4.5%;"/>
							
							
                            <div style="text-align:right !important;width:2%;">&nbsp;&nbsp;
                            </div>
                            <div class="slidecontainer" >
                              <input type="range" onchange="mouseUp('noOfTrips','slider5','input5')" onmouseup="updateNoOfconsumerTrips()" min="0" max="1000" value="0" class="slider" id="noOfTrips" style="width:88%">
                            <p>Value: <span id="slider5"></span></p>
                            </div>
                            <div class="slidecontainer">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;for one day
                            </div>
                            <div class="slidecontainer">
                            </div>
                          </div>

                        </div>
            </div>
        </div>
      </div>  
        <div class="row" style="">
        <div class="col-lg-12">
          <div class="row" id="columnContainer5" style="background: #37474F;color: white;padding: 8px; width:100%;" >
              <div class="col-lg-4" style="padding-left:32px;">
                </div>
              <div class="col-lg-4" style="text-align:center;">
                   Booking Configuration
              </div>
              <div class="col-lg-4" style="text-align:center;">
                </div>
          </div>
          <div class="row" style="width:100%;">
              <div class="col-lg-12 card" style="padding:4px 16px;">
                <div class="flex-container">
                  <div class="col-lg-3">User Type: Individual(<i>cft</i>Limit)</div>
				  
				  <input type="text" id="input6" onchange="DisplayChange6()" onkeypress="return isNumberKey(event)"   style="margin-right:4%;"/>
                
                  <div class="slidecontainer">
                    <input type="range" min="0" onchange="mouseUp('indPerDaylimitId','slider6','input6')" onmouseup="updateUserTypePerDay()" max="1000" value="0" class="slider" id="indPerDaylimitId">
                  <p>Value: <span id="slider6"></span></p>
                  </div>
                  
                  <div class="slidecontainer">&nbsp;per day 
                  </div>
                </div>
                <div class="flex-container">
                  <div class="col-lg-3">
                  </div>
                 <input type="text" id="input7" onchange="DisplayChange7()" onkeypress="return isNumberKey(event)"  style="margin-right:4%;"/>
				 
                  <div class="slidecontainer">
                    <input type="range" min="0" onchange="mouseUp('indPerWeekLimitId','slider7','input7')" onmouseup="updateUserTypePerWeek()" max="1000" value="" class="slider" id="indPerWeekLimitId">
                  <p>Value: <span id="slider7"></span></p>
                  </div>
                  
                  <div class="slidecontainer">&nbsp;per week
                  </div>
                </div>
                <div class="flex-container">
                  <div class="col-lg-3">
                  </div>
                  
				  <input type="text" id="input8" onchange="DisplayChange8()" onkeypress="return isNumberKey(event)"  style="margin-right:4%;" />
				  
                  <div class="slidecontainer">
                    <input type="range" min="0" onchange="mouseUp('indPerMonthLimitId','slider8','input8')" onmouseup="updateUserTypePerMonth()" max="1000" value="0"" class="slider" id="indPerMonthLimitId">
                  <p>Value: <span id="slider8"></span></p>
                  </div>
                
                  <div class="slidecontainer">&nbsp;per month
                  </div>
                </div>
        <!--          <div class="flex-container">
                    <div>
                      User Type : Dealer (<i>cft</i> Limit)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    </div>
                    <div class="slidecontainer">
                      <input type="range" min="1" max="100" value="50" class="slider" id="">
                    </div>
                    <div class="slidecontainer">&nbsp;&nbsp;per day
                    </div>
                  </div>
                  <div class="flex-container">
                    <div>
                    </div>
                    <div class="slidecontainer">
                      <input type="range" min="1" max="100" value="50" class="slider" id="">
                    </div>
                    <div class="slidecontainer">&nbsp;&nbsp;per week
                    </div>
                  </div>
                  <div class="flex-container">
                    <div>
                    </div>
                    <div class="slidecontainer">
                      <input type="range" min="1" max="100" value="50" class="slider" id="">
                    </div>
                    <div class="slidecontainer">&nbsp;&nbsp;per month
                    </div>
                  </div>  -->
                  <div class="flex-container">
                    <div class="col-lg-3">User Type : Corporate/Govt (<i>cft</i> Limit)</div>
					
					  <input type="text" id="input9" onchange="DisplayChange9()" onkeypress="return isNumberKey(event)"  style="margin-right:4%;"/>
                     <div class="slidecontainer">
                      <!-- <input type="range" min="1" max="100" value="50" class="slider" id="">789 -->
					  
					
					  
                      <input type="range" min="0" onchange="mouseUp('govtPerDaylimitId','slider9','input9')" onmouseup="updateGovtTypePerDay()" max="1000" value="0" class="slider" id="govtPerDaylimitId">
                    <p>Value: <span id="slider9"></span></p>
                    </div>
                    <div class="slidecontainer">&nbsp;per day
                    </div>
                  </div>
                  <div class="flex-container">
                    <div class="col-lg-3">
                    </div>
                   <input type="text" id="input10" onchange="DisplayChange10()" onkeypress="return isNumberKey(event)"  style="margin-right:4%;" />
				   
                    <div class="slidecontainer">
                      <input type="range" min="0" onchange="mouseUp('govtPerWeeklimitId','slider10','input10')" onmouseup="updateGovtTypePerWeek()" max="1000" value="0" class="slider" id="govtPerWeeklimitId">
                    <p>Value: <span id="slider10"></span></p>
                    </div>
                    <div class="slidecontainer">&nbsp;per week
                    </div>
                  </div>
                  <div class="flex-container">
                    <div class="col-lg-3">
                    </div>
                  <input type="text" id="input11" onchange="DisplayChange11()" onkeypress="return isNumberKey(event)"  style="margin-right:4%;"/>
                    <div class="slidecontainer">
                      <input type="range" min="0" onchange="mouseUp('govtPerMonthlimitId','slider11','input11')" onmouseup="updateGovtTypePerMonth()" max="1000" value="1000" class="slider" id="govtPerMonthlimitId">
                    <p>Value: <span id="slider11"></span></p>
                    </div>
                    <div class="slidecontainer">&nbsp;per month
                    </div>
                  </div>
                </div>
            </div>
        </div>
      </div>
      
      <table id="stockyardTable" class="table table-striped table-bordered dt-responsive nowrap" style="width:100%">
    <thead>
        <tr>
            <th>Sl No.</th>
            <th>Activate/Deactivate</th>
            <th>Stockyard Id</th>
            <th>Hub Name</th>
            <th>Address</th>
            <th>Geo Fence Id</th>
            <th>Associated Geofence</th>
            <th>Stockyard Total</th>
            <th>Booking Limit</th>
            <th>Reserved Sand Qty</th>
            <th>Dispatched Sand Qty</th>
        </tr>
    </thead>

  </table>

      <script>
       
      function getStockyardInfoForConfiguration() {
      
	var stockyardId = document.getElementById("stockyardDropDownId").value;
    let rows = [];
    $.ajax({
        url: '<%=request.getContextPath()%>/JSMDCDashboardAction.do?param=getStockyardInfoForConfiguration&stockyardId='+stockyardId,
        datatype : "application/json",
        success: function(result) {
          $.each(JSON.parse(result),function(i, item){
            let buttonName = (item.IsActive)? "Deactivate" : "Activate";
            let row = {
                          "0": item.Id != null ? item.Id : "",
                          "1": '<button type="button" class="btn btn-primary" id="editsaveBtn'+item.Id+'" onclick="editSave('+item.Id+')">Edit</button>&nbsp;<button type="button" class="btn btn-primary" onclick="activateDeactivate('+item.Id+','+item.IsActive+')">'+buttonName+'</button>',
                          "2": item.HubId != null ? item.HubId : "",
                          "3": item.HubName != null ? item.HubName : "",
                          "4" : item.Address != null ? item.Address : "",
                          "5" : item.GeoFenceId != null ? item.GeoFenceId : "",
                          "6" : '<input type="text" id="associated'+item.Id+'" value="'+item.AssociatedGeofence+'" disabled=true/>',
                          "7" : '<input type="text" id="capacity'+item.Id+'" value="'+item.CapacityOfStockyard+'" disabled=true/>',
                          "8" : '<input type="text" id="available'+item.Id+'" value="'+item.AvailableSandQuantity+'" disabled=true/>',
                          "9" : item.ReservedSandQuantity != null ? item.ReservedSandQuantity : "",
                          "10" : item.DispatchedSandQuantity != null ? item.DispatchedSandQuantity : "",

          }
			$('#stockyardPermit').prop('title', item.CapacityOfStockyard);
				$("#stockyardPermit").val(item.CapacityOfStockyard);
				$("#slider1").html(item.CapacityOfStockyard);
				$('#bookingLimit').prop('title', item.AvailableSandQuantity);
				$("#bookingLimit").val(item.AvailableSandQuantity);
				$("#slider3").html(item.AvailableSandQuantity);
				$('#noOfTrips').prop('title', item.AssociatedGeofence);
				$("#noOfTrips").val(item.AssociatedGeofence);
				$("#slider5").html(item.AssociatedGeofence);
				// to fetch value from db
				$("#input1").val(item.CapacityOfStockyard);
				$("#input3").val(item.AvailableSandQuantity);
				$("#input5").val(item.AssociatedGeofence);	
				
				// $('#indPerDaylimitId').prop('title', item.CapacityOfStockyard);
				// $("#slider6").html(item.indPerDaylimitId);
				// $("input6").val(item.indPerDaylimitId);
				// //$("slider2").val(item.slider2ranger);
				
				// $('#indPerWeekLimitId').prop('title', item.CapacityOfStockyard);
				// $("#slider7").html(item.indPerDaylimitId);
				// $("input7").val(item.indPerDaylimitId);
				
				// $('#indPerMonthLimitId').prop('title', item.CapacityOfStockyard);
				// $("#slider8").html(item.indPerDaylimitId);
				// $("input8").val(item.indPerDaylimitId);
				
				// $('#govtPerDaylimitId').prop('title', item.CapacityOfStockyard);
				// $("#slider9").html(item.indPerDaylimitId);
				// $("input9").val(item.indPerDaylimitId);
				
				// $('#govtPerWeeklimitId').prop('title', item.CapacityOfStockyard);
				// $("#slider10").html(item.indPerDaylimitId);
				// $("input10").val(item.indPerDaylimitId);
				
				// $('#govtPerMonthlimitId').prop('title', item.CapacityOfStockyard);
				// $("#slider11").html(item.indPerDaylimitId);
				// $("input11").val(item.indPerDaylimitId);
				
				
				
          rows.push(row);
        });
          if ($.fn.DataTable.isDataTable("#stockyardTable")) {
  									$('#stockyardTable').DataTable().clear()
  											.destroy();
  								}

           let stockyardTable =  $('#stockyardTable').DataTable({
           scrollX: true,
           dom: 'Bfrtip',
           buttons: ['excel', 'pdf']
         });
         stockyardTable.rows.add(rows).draw();
        }
      });
		getIndividualUserTypePerDayForConfiguration();
		getIndividualUserTypePerWeekForConfiguration();
		getIndividualUserTypePerMonthForConfiguration();
	  
		getGovtUserTypePerDayForConfiguration();
		getGovtUserTypePerWeekForConfiguration();
		getGovtUserTypePerMonthForConfiguration();
	  
	  
    }

     function activateDeactivate(hubId,value){
            $.ajax({
              type: "POST",
              url: '<%=request.getContextPath()%>/JSMDCDashboardAction.do?param=activeInactiveStockyardOrUser&type=HUB&id='+hubId+'&value='+!value,
             "dataSrc": "vehicleCounts",
             success: function(result) {
           	if(result=='Updated')
           	{
           		sweetAlert("Updated Successfully");
           	}
           	else
           	{
           		sweetAlert("Error To Update");
           	}
           	getStockyardInfoForConfiguration();
          }
      })
        }

    function editSave(id){
      if($("#editsaveBtn"+id).html() == "Edit")
      {
          $("#editsaveBtn"+id).html('Save');
          $("#associated"+id).prop("disabled",false)
          $("#capacity"+id).prop("disabled",false)
          $("#available"+id).prop("disabled",false)
      }
      else {
        $("#editsaveBtn"+id).html('Edit');
        let associated = $("#associated"+id).val() ;
        let capacity =  $("#capacity"+id).val();
        let available = $("#available"+id).val() ;
        $("#associated"+id).prop("disabled",true)
        $("#capacity"+id).prop("disabled",true)
        $("#available"+id).prop("disabled",true)
        var stockyardId = document.getElementById("stockyardDropDownId").value;
          $.ajax({
             type: "POST",
              url: '<%=request.getContextPath()%>/JSMDCDashboardAction.do?param=configureStockyard&totalPermit='+capacity+'&bookingLimit='+available+'&noOfTripsForDay='+associated+'&id='+stockyardId,
             "dataSrc": "getJSMDCStockyard",
             success: function(result) {
				sweetAlert(result);
         getStockyardInfoForConfiguration();
         }
         });
      }

    }
     
function mouseUp(sliderId,lableId,inputId)
{
	sliderFun(sliderId,lableId,inputId);
	//console.log(document.getElementById("stockyardPermit").value);bookingLimit,noOfTrips 
	   $('#stockyardPermit').prop('title',document.getElementById("stockyardPermit").value);
	   $('#bookingLimit').prop('title',document.getElementById("bookingLimit").value);
	   $('#noOfTrips').prop('title',document.getElementById("noOfTrips").value);
	   $('#indPerDaylimitId').prop('title',document.getElementById("indPerDaylimitId").value);
	   $('#indPerWeekLimitId').prop('title',document.getElementById("indPerWeekLimitId").value);
	   $('#indPerMonthLimitId').prop('title',document.getElementById("indPerMonthLimitId").value);
	   $('#govtPerDaylimitId').prop('title',document.getElementById("govtPerDaylimitId").value);
	   $('#govtPerWeeklimitId').prop('title',document.getElementById("govtPerWeeklimitId").value);
	   $('#govtPerMonthlimitId').prop('title',document.getElementById("govtPerMonthlimitId").value);
	   $('#slider2ranger').prop('title',document.getElementById("slider2ranger").value);
	   $('#slider4ranger').prop('title',document.getElementById("slider4ranger").value);
	   
}

        $(document).ready(function () {
            $('#selectSmartHub').select2();
            $('#selectSmartHub1').select2();
            $('#indPerDaylimitId').prop('title','0');
		    $("#indPerDaylimitId").val('0');
		    $('#indPerWeekLimitId').prop('title','0');
		    $("#indPerWeekLimitId").val('0');
		    $('#indPerMonthLimitId').prop('title','0');
		    $("#indPerMonthLimitId").val('0');
			//getIndividualUserTypePerDayForConfiguration();
			//getIndividualUserTypePerWeekForConfiguration();
			//getIndividualUserTypePerMonthForConfiguration();
			$('#govtPerDaylimitId').prop('title','0');
		    $("#govtPerDaylimitId").val('0');
		    $('#govtPerWeeklimitId').prop('title','0');
		    $("#govtPerWeeklimitId").val('0');
		    $('#govtPerMonthlimitId').prop('title','0');
		    $("#govtPerMonthlimitId").val('0');
			//getGovtUserTypePerDayForConfiguration();
			//getGovtUserTypePerWeekForConfiguration();
			//getGovtUserTypePerMonthForConfiguration();
        })

getJSMDCDistrict();

function getJSMDCDistrict()
{
				$('#stockyardPermit').prop('title','0');
				$("#stockyardPermit").val('0');
				$('#bookingLimit').prop('title', '0');
				$("#bookingLimit").val('0');
				$('#noOfTrips').prop('title','0');
				$("#noOfTrips").val('0');
				//1234
				$('#indPerDaylimitId').prop('title','0');
				$("#indPerDaylimitId").val('0');
				//alert();
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
		
		var districtId = document.getElementById("districtDropDownId").value;
			$("#stockyardDropDownId").empty();
			$("#stockyardDropDownId").append('<option selected disabled value="-1">Select Stockyard</option>');
			//$("#stockyardDropDownId").append('<option value="0">All Stockyards</option>');
          $.ajax({
             type: "POST",
              url: '<%=request.getContextPath()%>/JSMDCDashboardAction.do?param=getJSMDCStockyard&districtId='+districtId,
             "dataSrc": "getJSMDCStockyard",
             success: function(result) {
              data =  JSON.parse(result);
				for(var i=0;i<data.stockyards.length;i++)
				{
				$("#stockyardDropDownId").append('<option value="'+data.stockyards[i].id+'">'+data.stockyards[i].stockyard+'</option>');
				}
         }
         });
       } 
/*function getStockyardInfoForConfiguration()
{
				$('#stockyardPermit').prop('title','0');
				$("#stockyardPermit").val('0');
				$('#bookingLimit').prop('title', '0');
				$("#bookingLimit").val('0');
				$('#noOfTrips').prop('title','0');
				$("#noOfTrips").val('0');
		var stockyardId = document.getElementById("stockyardDropDownId").value;
          $.ajax({
             type: "POST",
              url: '<%=request.getContextPath()%>/JSMDCDashboardAction.do?param=getStockyardInfoForConfiguration&stockyardId='+stockyardId,
             "dataSrc": "getJSMDCStockyard",
             success: function(result) {
              data =  JSON.parse(result);
				console.log(data);
				if(data.length==1)
				{
				$('#stockyardPermit').prop('title', data[0].CapacityOfStockyard);
				$("#stockyardPermit").val(data[0].CapacityOfStockyard);
				$('#bookingLimit').prop('title', data[0].AvailableSandQuantity);
				$("#bookingLimit").val(data[0].AvailableSandQuantity);
				$('#noOfTrips').prop('title', data[0].AssociatedGeofence);
				$("#noOfTrips").val(data[0].AssociatedGeofence);
				}
         }
         });
  } */
  var permitRangeCount=0;
  function updateTotalPermit()
  {
  	var districtId = document.getElementById("districtDropDownId").value;
  	if(districtId=="-1")
  	{
  		sweetAlert("Please Select District");
  		return;
  	}
  	var stockyardId = document.getElementById("stockyardDropDownId").value;
  	  	if(stockyardId=="-1")
  	{
  		sweetAlert("Please Select Stockyard");
  		return;
  	}
  	
  		var value = document.getElementById("stockyardPermit").value;
  	/*          $.ajax({
             type: "POST",
              url: '<%=request.getContextPath()%>/JSMDCDashboardAction.do?param=updateStockyardTotalPermit&id='+stockyardId+'&totalpermit='+value,
             "dataSrc": "getJSMDCStockyard",
             success: function(result) {    
				sweetAlert(result);
         }
         });*/
        
		if(permitRangeCount==0)
		{
			editSave(stockyardId);
		}
		 var table = $('#stockyardTable').DataTable({retrieve: true,
    paging: false, sorting : false});
		var row = table.row(0).node();  
		table.cell(row, 7).data('<input type="text" id="capacity'+stockyardId+'" value="'+value+'"/>').draw();
		permitRangeCount++;
  }
  
  function updateBookingLimit()
  {
  	  	var districtId = document.getElementById("districtDropDownId").value;
  	if(districtId=="-1")
  	{
  		sweetAlert("Please Select District");
  		return;
  	}
  	var stockyardId = document.getElementById("stockyardDropDownId").value;
  	  	if(stockyardId=="-1")
  	{
  		sweetAlert("Please Select Stockyard");
  		return;
  	}
  		var value = document.getElementById("bookingLimit").value;
  	 /*         $.ajax({
             type: "POST",
              url: '<%=request.getContextPath()%>/JSMDCDashboardAction.do?param=updateStockyardBookingLimit&id='+stockyardId+'&bookingLimit='+value,
             "dataSrc": "getJSMDCStockyard",
             success: function(result) {
             
				sweetAlert(result);
         }
         });*/
         if(permitRangeCount==0)
		{
			editSave(stockyardId);
		}
		 var table = $('#stockyardTable').DataTable({retrieve: true,
    paging: false, sorting : false});
		var row = table.row(0).node();  
		table.cell(row, 8).data('<input type="text" id="available'+stockyardId+'" value="'+value+'"/>').draw();
		permitRangeCount++;
  }
  
  function updateNoOfconsumerTrips()
  {
  	var districtId = document.getElementById("districtDropDownId").value;
  	if(districtId=="-1")
  	{
  		sweetAlert("Please Select District");
  		return;
  	}
  	var stockyardId = document.getElementById("stockyardDropDownId").value;
  	  	if(stockyardId=="-1")
  	{
  		sweetAlert("Please Select Stockyard");
  		return;
  	}
  		var value = document.getElementById("noOfTrips").value;
  	 /*         $.ajax({
             type: "POST",
              url: '<%=request.getContextPath()%>/JSMDCDashboardAction.do?param=updateStockyardNoOfTripsForDay&id='+stockyardId+'&noOfTripsForDay='+value,
             "dataSrc": "getJSMDCStockyard",
             success: function(result) {
              
				sweetAlert(result);
         }
         });*/
         if(permitRangeCount==0)
		{
			editSave(stockyardId);
		}
		 var table = $('#stockyardTable').DataTable({retrieve: true,
    paging: false, sorting : false});
		var row = table.row(0).node();  
		table.cell(row, 6).data('<input type="text" id="associated'+stockyardId+'" value="'+value+'"/>').draw();
		permitRangeCount++;
  }
  
  function updateUserTypePerDay()
  {
  		var value = document.getElementById("indPerDaylimitId").value;
  	    $.ajax({
             type: "POST",
              url: '<%=request.getContextPath()%>/JSMDCDashboardAction.do?param=updateIndiUserTypePerDay&noOfTripsForPerDay='+value,
             "dataSrc": "getJSMDCStockyard",
             success: function(result) {
				sweetAlert(result);
	         }
         });
  }
  function updateUserTypePerWeek()
  {
  		 var value = document.getElementById("indPerWeekLimitId").value;
  	     $.ajax({
             type: "POST",
             url: '<%=request.getContextPath()%>/JSMDCDashboardAction.do?param=updateIndiUserTypePerWeek&noOfTripsForPerWeek='+value,
             "dataSrc": "getJSMDCStockyard",
             success: function(result) {
				sweetAlert(result);
         	 }
         });
  }
  function updateUserTypePerMonth()
  {
  		var value = document.getElementById("indPerMonthLimitId").value;
  	    $.ajax({
             type: "POST",
             url: '<%=request.getContextPath()%>/JSMDCDashboardAction.do?param=updateIndiUserTypePerMonth&noOfTripsForPerMonth='+value,
             "dataSrc": "getJSMDCStockyard",
             success: function(result) {
				sweetAlert(result);
         	 }
         });
  }
  
    function getIndividualUserTypePerDayForConfiguration() {
    	$.ajax({
        	url: '<%=request.getContextPath()%>/JSMDCDashboardAction.do?param=getIndividualUserTypePerDayForConfiguration',
        	datatype : "application/json",
        	success: function(result) {
        	//console.log("result ::  " + result + " result[0]::  " + result[0].KeyValue);
        		results = JSON.parse(result);
        		console.log("results Value: " + results[0].KeyValue);
        		$('#indPerDaylimitId').prop('title', results[0].KeyValue);
				$("#indPerDaylimitId").val(results[0].KeyValue);
				//$("#slider6").html(item.indPerDaylimitId);
				
				document.getElementById( 
                  	"input6").value = document.getElementById( 
                 	 "indPerDaylimitId").value; 
					$("#slider6").html($("#input6").val()); 
					$('#indPerDaylimitId').prop('title',document.getElementById("indPerDaylimitId").value);
				
				
				
				
				
            }
      });
    }
    function getIndividualUserTypePerWeekForConfiguration() {
    	$.ajax({
        	url: '<%=request.getContextPath()%>/JSMDCDashboardAction.do?param=getIndividualUserTypePerWeekForConfiguration',
        	datatype : "application/json",
        	success: function(result) {
        		results = JSON.parse(result)
        		console.log(" results[0].KeyValue " + results[0].KeyValue);
        		$('#indPerWeekLimitId').prop('title', results[0].KeyValue);
				$("#indPerWeekLimitId").val(results[0].KeyValue);
				//$("#slider7").html(item.indPerWeekLimitId);
				
				//from db
				
				document.getElementById( 
                  	"input7").value = document.getElementById( 
                 	 "indPerWeekLimitId").value; 
					$("#slider7").html($("#input7").val()); 
					$('#indPerWeekLimitId').prop('title',document.getElementById("indPerWeekLimitId").value);
        	}
      });
    }
    function getIndividualUserTypePerMonthForConfiguration() {
    	$.ajax({
        	url: '<%=request.getContextPath()%>/JSMDCDashboardAction.do?param=getIndividualUserTypePerMonthForConfiguration',
        	datatype : "application/json",
        	success: function(result) {
        		results = JSON.parse(result);
        		console.log(" results[0].KeyValue " + results[0].KeyValue); 
        		$('#indPerMonthLimitId').prop('title', results[0].KeyValue);
				$("#indPerMonthLimitId").val(results[0].KeyValue);
				//$("#slider8").html(item.indPerMonthLimitId);
				
				document.getElementById( 
                  	"input8").value = document.getElementById( 
                 	 "indPerMonthLimitId").value; 
					$("#slider8").html($("#input8").val()); 
					$('#indPerMonthLimitId').prop('title',document.getElementById("indPerMonthLimitId").value);
				
				
				
        }
      });
    }
    
    function updateGovtTypePerDay()
    {
  		var value = document.getElementById("govtPerDaylimitId").value;
  	    $.ajax({
             type: "POST",
             url: '<%=request.getContextPath()%>/JSMDCDashboardAction.do?param=updateGovtUserTypePerDay&noOfValuesForPerDay='+value,
             "dataSrc": "getJSMDCStockyard",
             success: function(result) {
				sweetAlert(result);
	         }
         });
   }
   function updateGovtTypePerWeek()
   {
  		var value = document.getElementById("govtPerWeeklimitId").value;
  	    $.ajax({
             type: "POST",
             url: '<%=request.getContextPath()%>/JSMDCDashboardAction.do?param=updateGovtUserTypePerWeek&noOfValuesForPerWeek='+value,
             "dataSrc": "getJSMDCStockyard",
             success: function(result) {
				sweetAlert(result);
	         }
         });
   } 
   function updateGovtTypePerMonth()
   {
  		var value = document.getElementById("govtPerMonthlimitId").value;
  	    $.ajax({
             type: "POST",
             url: '<%=request.getContextPath()%>/JSMDCDashboardAction.do?param=updateGovtUserTypePerMonth&noOfValuesForPerMonth='+value,
             "dataSrc": "getJSMDCStockyard",
             success: function(result) {
				sweetAlert(result);
	         }
         });
   }
   function getGovtUserTypePerDayForConfiguration() {
    	$.ajax({
        	url: '<%=request.getContextPath()%>/JSMDCDashboardAction.do?param=getGovtUserTypePerDayForConfiguration',
        	datatype : "application/json",
        	success: function(result) {
        		results = JSON.parse(result);
        		console.log("results Value: " + results[0].KeyValue);
        		$('#govtPerDaylimitId').prop('title', results[0].KeyValue);
				$("#govtPerDaylimitId").val(results[0].KeyValue);
				//$("#slider9").html(item.govtPerDaylimitId);
				
				document.getElementById( 
                  	"input9").value = document.getElementById( 
                 	 "govtPerDaylimitId").value; 
					$("#slider9").html($("#input9").val()); 
					$('#govtPerDaylimitId').prop('title',document.getElementById("govtPerDaylimitId").value);
				
            }
      });
    }
    function getGovtUserTypePerWeekForConfiguration() {
    	$.ajax({
        	url: '<%=request.getContextPath()%>/JSMDCDashboardAction.do?param=getGovtUserTypePerWeekForConfiguration',
        	datatype : "application/json",
        	success: function(result) {
        		results = JSON.parse(result);
        		console.log("results Value: " + results[0].KeyValue);
        		$('#govtPerWeeklimitId').prop('title', results[0].KeyValue);
				$("#govtPerWeeklimitId").val(results[0].KeyValue);
				//$("#slider10").html(item.govtPerWeeklimitId);
				
				document.getElementById( 
                  	"input10").value = document.getElementById( 
                 	 "govtPerWeeklimitId").value; 
					$("#slider10").html($("#input10").val()); 
					$('#govtPerWeeklimitId').prop('title',document.getElementById("govtPerWeeklimitId").value);
            }
      });
    }
    function getGovtUserTypePerMonthForConfiguration() {
    	$.ajax({
        	url: '<%=request.getContextPath()%>/JSMDCDashboardAction.do?param=getGovtUserTypePerMonthForConfiguration',
        	datatype : "application/json",
        	success: function(result) {
        		results = JSON.parse(result);
        		console.log("results Value: " + results[0].KeyValue);
        		$('#govtPerMonthlimitId').prop('title', results[0].KeyValue);
				$("#govtPerMonthlimitId").val(results[0].KeyValue);
				//$("#slider11").html(item.govtPerMonthlimitId);
				
				document.getElementById( 
                  	"input11").value = document.getElementById( 
                 	 "govtPerMonthlimitId").value; 
					$("#slider11").html($("#input11").val()); 
					$('#govtPerMonthlimitId').prop('title',document.getElementById("govtPerMonthlimitId").value);
            }
      });
    }
	

		
		function sliderFun(sliderId,lableId,inputId)
		{
			var slider = document.getElementById(sliderId);
		var output = document.getElementById(lableId);
		var output1 = document.getElementById(inputId);
											
		output.innerHTML = slider.value;
	
		//to display into textbox from slider value
		if(inputId==="input1"){
		document.getElementById( "input1").value = document.getElementById("stockyardPermit").value;
		}else if(inputId==="input3"){
		document.getElementById( "input3").value = document.getElementById("bookingLimit").value; 
		} else if(inputId==="input5"){
		document.getElementById( "input5").value = document.getElementById("noOfTrips").value;
		}else if(inputId==="input6"){
		document.getElementById( "input6").value = document.getElementById("indPerDaylimitId").value; 
		}else if(inputId==="input7"){
		document.getElementById( "input7").value = document.getElementById("indPerWeekLimitId").value;
		} else if(inputId==="input8"){
		document.getElementById( "input8").value = document.getElementById("indPerMonthLimitId").value;
		} else if(inputId==="input9") {
		document.getElementById( "input9").value = document.getElementById("govtPerDaylimitId").value;
		} else if(inputId==="input10") {
		document.getElementById( "input10").value = document.getElementById("govtPerWeeklimitId").value;
		} else {
		document.getElementById( "input11").value = document.getElementById("govtPerMonthlimitId").value;
		}	
	}
		
	function DisplayChange() {
	alertsForSelection();
	if((document.getElementById( 
                  "input1").value>100000))
                  {
                  		sweetAlert("Enter upto 100K");
						document.getElementById("input1").value = "";
                  }
                else{
                	document.getElementById( 
                  	"stockyardPermit").value = document.getElementById( 
                 	 "input1").value; 
					$("#slider1").html($("#input1").val()); 
					$('#stockyardPermit').prop('title',document.getElementById("stockyardPermit").value);
				}         	  
				
				var stockyardId = document.getElementById("stockyardDropDownId").value;
  	  	if(stockyardId=="-1")
  	{
  		sweetAlert("Please Select Stockyard");
  		return;
  	}
  	
  		var value = document.getElementById("stockyardPermit").value;
  	/*          $.ajax({
             type: "POST",
              url: '<%=request.getContextPath()%>/JSMDCDashboardAction.do?param=updateStockyardTotalPermit&id='+stockyardId+'&totalpermit='+value,
             "dataSrc": "getJSMDCStockyard",
             success: function(result) {    
				sweetAlert(result);
         }
         });*/
        
		if(permitRangeCount==0)
		{
			editSave(stockyardId);
		}
		 var table = $('#stockyardTable').DataTable({retrieve: true,
		paging: false, sorting : false});
		var row = table.row(0).node();  
		table.cell(row, 7).data('<input type="text" id="capacity'+stockyardId+'" value="'+value+'"/>').draw();
		permitRangeCount++;
                  
		
	}
	
	function DisplayChange2() { 
		alertsForSelection();
	
		if((document.getElementById( 
                  "input2").value>5))
                  {
                  		sweetAlert("Enter upto 5");
						document.getElementById("input2").value = "";
                  }
                else{
                	document.getElementById( 
                  	"slider2ranger").value = document.getElementById( 
                 	 "input2").value; 
					$("#slider2").html($("#input2").val()); 
					$('#slider2ranger').prop('title',document.getElementById("slider2ranger").value);
					}
		
	}
	
	
	function DisplayChange3() { 
		alertsForSelection();
	
		if((document.getElementById( 
                  "input3").value>50000))
                  {
                  		sweetAlert("Enter upto 50k");
						document.getElementById("input3").value = "";
                  }
                else{
                	document.getElementById( 
                  	"bookingLimit").value = document.getElementById( 
                 	 "input3").value; 
					$("#slider3").html($("#input3").val()); 
					$('#bookingLimit').prop('title',document.getElementById("bookingLimit").value);
					
					
					
					}
					
					var stockyardId = document.getElementById("stockyardDropDownId").value;
  	  	if(stockyardId=="-1")
  	{
  		sweetAlert("Please Select Stockyard");
  		return;
  	}
  		var value = document.getElementById("bookingLimit").value;
  	
         if(permitRangeCount==0)
		{
			editSave(stockyardId);
		}
		 var table = $('#stockyardTable').DataTable({retrieve: true,
    paging: false, sorting : false});
		var row = table.row(0).node();  
		table.cell(row, 8).data('<input type="text" id="available'+stockyardId+'" value="'+value+'"/>').draw();
		permitRangeCount++;
		
	}
	
	function DisplayChange4() { 
	alertsForSelection();
	
	if((document.getElementById( 
                  "input4").value>5))
                  {
                  		sweetAlert("Enter upto 5");
						document.getElementById("input4").value = "";
                  }
                else{
                	document.getElementById( 
                  	"slider4ranger").value = document.getElementById( 
                 	 "input4").value; 
					$("#slider4").html($("#input4").val()); 
					$('#slider4ranger').prop('title',document.getElementById("slider4ranger").value);
					}
		
	}
	
	function DisplayChange5() { 
	alertsForSelection();
	
	if((document.getElementById( 
                  "input5").value>1000))
                  {
                  		sweetAlert("Enter upto 1000");
						document.getElementById("input5").value = "";
                  }
                else{
                	document.getElementById( 
                  	"noOfTrips").value = document.getElementById( 
                 	 "input5").value; 
					$("#slider5").html($("#input5").val()); 
					$('#noOfTrips').prop('title',document.getElementById("noOfTrips").value);
					}
		var stockyardId = document.getElementById("stockyardDropDownId").value;
  	  	if(stockyardId=="-1")
  	{
  		sweetAlert("Please Select Stockyard");
  		return;
  	}
  		var value = document.getElementById("noOfTrips").value;
  	 /*         $.ajax({
             type: "POST",
              url: '<%=request.getContextPath()%>/JSMDCDashboardAction.do?param=updateStockyardNoOfTripsForDay&id='+stockyardId+'&noOfTripsForDay='+value,
             "dataSrc": "getJSMDCStockyard",
             success: function(result) {
              
				sweetAlert(result);
         }
         });*/
         if(permitRangeCount==0)
		{
			editSave(stockyardId);
		}
		 var table = $('#stockyardTable').DataTable({retrieve: true,
    paging: false, sorting : false});
		var row = table.row(0).node();  
		table.cell(row, 6).data('<input type="text" id="associated'+stockyardId+'" value="'+value+'"/>').draw();
		permitRangeCount++;
	}
	
	function DisplayChange6() { 
	alertsForSelection();
	//updateUserTypePerDay();
	
	if((document.getElementById( 
                  "input6").value>1000))
                  {
                  		sweetAlert("Enter upto 1000");
						document.getElementById("input6").value = "";
                  }
                else{
					
                	document.getElementById( 
                  	"indPerDaylimitId").value = document.getElementById( 
                 	 "input6").value; 
					 updateUserTypePerDay();
					$("#slider6").html($("#input6").val()); 
					$('#indPerDaylimitId').prop('title',document.getElementById("indPerDaylimitId").value);
					
					
					}
					
		
	}
	
	
	function DisplayChange7() { 
	alertsForSelection();
	
	if((document.getElementById( 
                  "input7").value>1000))
                  {
                  		sweetAlert("Enter upto 1000");
						document.getElementById("input7").value = "";
                  }
                else{
                	document.getElementById( 
                  	"indPerWeekLimitId").value = document.getElementById( 
                 	 "input7").value; 
					 updateUserTypePerWeek();
					$("#slider7").html($("#input7").val()); 
					$('#indPerWeekLimitId').prop('title',document.getElementById("indPerWeekLimitId").value);
					}
		
	}
	
	
	function DisplayChange8() { 
	alertsForSelection();
	
	if((document.getElementById( 
                  "input8").value>1000))
                  {
                  		sweetAlert("Enter upto 1000");
						document.getElementById("input8").value = "";
                  }
                else{
                	document.getElementById( 
                  	"indPerMonthLimitId").value = document.getElementById( 
                 	 "input8").value; 
					 updateUserTypePerMonth();
					$("#slider8").html($("#input8").val()); 
					$('#indPerMonthLimitId').prop('title',document.getElementById("indPerMonthLimitId").value);
					}
		
	}
	
	
	function DisplayChange9() { 
	alertsForSelection();
	
	if((document.getElementById( 
                  "input9").value>1000))
                  {
                  		sweetAlert("Enter upto 1000");
						document.getElementById("input9").value = "";
                  }
                else{
                	document.getElementById( 
                  	"govtPerDaylimitId").value = document.getElementById( 
                 	 "input9").value; 
					 updateGovtTypePerDay();
					$("#slider9").html($("#input9").val()); 
					$('#govtPerDaylimitId').prop('title',document.getElementById("govtPerDaylimitId").value);
					}
		
	}
	
	
	function DisplayChange10() { 
	alertsForSelection();
	
	if((document.getElementById( 
                  "input10").value>1000))
                  {
                  		sweetAlert("Enter upto 1000");
						document.getElementById("input10").value = "";
                  }
                else{
                	document.getElementById( 
                  	"govtPerWeeklimitId").value = document.getElementById( 
                 	 "input10").value; 
					 updateGovtTypePerWeek();
					$("#slider10").html($("#input10").val()); 
					$('#govtPerWeeklimitId').prop('title',document.getElementById("govtPerWeeklimitId").value);
				}
	}			
	
function DisplayChange11() { 
	alertsForSelection();
	
	if((document.getElementById( 
                  "input11").value>1000))
                  {
                  		sweetAlert("Enter upto 1000");
						document.getElementById("input11").value = "";
                  }
                else{
                	document.getElementById( 
                  	"govtPerMonthlimitId").value = document.getElementById( 
                 	 "input11").value; 
					 updateGovtTypePerMonth();
					$("#slider11").html($("#input11").val()); 
					$('#govtPerMonthlimitId').prop('title',document.getElementById("govtPerMonthlimitId").value);
					}
		
	}		
		
	function isNumberKey(evt)
      {
         var charCode = (evt.which) ? evt.which : event.keyCode
         if (charCode > 31 && (charCode < 48 || charCode > 57))
            return false;

         return true;
      }
	
  function alertsForSelection(){
	  
	  var districtId = document.getElementById("districtDropDownId").value;
	
			if(districtId=="-1")
			{
				sweetAlert("Please Select District");
				document.getElementById("input1").value = "";
				document.getElementById("input2").value = "";
				document.getElementById("input3").value = "";
				document.getElementById("input4").value = "";
				document.getElementById("input5").value = "";
				document.getElementById("input6").value = "";
				document.getElementById("input7").value = "";
				document.getElementById("input8").value = "";
				document.getElementById("input9").value = "";
				document.getElementById("input10").value = "";
				document.getElementById("input11").value = "";
				return;
				
			}
		var stockyardId = document.getElementById("stockyardDropDownId").value;
			if(stockyardId=="-1")
			{
				sweetAlert("Please Select Stockyard");
				document.getElementById("input1").value = "";
				document.getElementById("input2").value = "";
				document.getElementById("input3").value = "";
				document.getElementById("input4").value = "";
				document.getElementById("input5").value = "";
				document.getElementById("input6").value = "";
				document.getElementById("input7").value = "";
				document.getElementById("input8").value = "";
				document.getElementById("input9").value = "";
				document.getElementById("input10").value = "";
				document.getElementById("input11").value = "";
				return;
			}
  }
  
  </script>

  <jsp:include page="../Common/footer.jsp" />
