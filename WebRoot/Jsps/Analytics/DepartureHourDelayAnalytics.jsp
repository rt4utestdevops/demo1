<%@ page language="java" import="java.util.*,t4u.functions.CommonFunctions,t4u.beans.*,t4u.common.*" pageEncoding="ISO-8859-1"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";

Properties properties = ApplicationListener.prop;
   String t4uspringappURL = properties.getProperty("t4uspringappURL").trim();
%>

<head>
   <jsp:include page="../Common/header.jsp" />
   <link rel="stylesheet" href="css/bootstrap.css" type="text/css" />
   <link rel="stylesheet" href="css/animate.css" type="text/css" />
   <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css" type="text/css" />
   <link rel="stylesheet" href="css/font.css" type="text/css" />
   <link rel="stylesheet" href="css/app.css" type="text/css" />
   <link rel="stylesheet" href="js/datepicker/datepicker.css" type="text/css" />
   <link rel="stylesheet" href="../../Main/sweetAlert/sweetalert.css">
   <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-multiselect/0.9.15/css/bootstrap-multiselect.css" type="text/css"/>
   <link rel="stylesheet" href="css/analytics.css" type="text/css"/>
   
   <link href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-1q8mTJOASx8j1Au+a5WDVnPi2lkFfwwEAa8hDDdjZlpLegxhjVME1fgjWPGmkzs7" crossorigin="anonymous"> 
   <style>
      .h7Pad{
     	 padding:16px;
      }
      .multiselect-container{
		max-width : 108% !important;
      }
      label.checkbox {
		color : black !important;
		padding: 1px 4px 0px 4px !important;
		padding-left : 26px !important;
	  }
	  .dropdown-toggle::after {
    	display: inline-block !important;
    	width: 0 !important;
    	height: 0 !important;
	    margin-left: .255em !important;
    	vertical-align: .255em !important;
    	content: "";
    	border-top: .3em solid !important;
    	border-right: .3em solid transparent !important;
    	border-bottom: 0 !important;
    	border-left: .3em solid transparent !important;
	}
	.caret {
		display : none !important;
	}
   </style>
</head>
<body>
   <div class="center-view" style="display:none;" id="loading-div">
      <img src="../../Main/images/loading.gif" alt="">
   </div>
   <section class="vbox" style="margin-top:-24px;margin-left:-16px">
      <section class="hbox stretch">
         <!-- .aside -->
         <aside class="bg-light lter b-r aside-md hidden-print" id="nav" >
            <section class="vbox" id="secTop">
               <header class="header bg-primary lter clearfix" style="background:#2977B6 !important;top:0px;    border-top: 1px solid white;
                  height: 40px;
                  color: white !important;">
                  <h3 style="font-size:20px;">
                     DELAY ANALYSIS
                  </h3>
               </header>
               <section class="w-f scrollable">
                  <div class="slim-scroll" data-height="auto" data-disable-fade-out="true" data-distance="0" data-size="5px" data-color="#333333" style="margin-top:53px !important;">
                     <!-- nav -->
                     <label class="col-sm-6 control-label startDateClass">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Start Date</label>
                     <div class="form-group">
                        <div class="col-sm-10">
                           <input class="input-sm input-s datepicker-input form-control" id="startDate" size="16" type="text" value="" data-date-format="yyyy-mm-dd" >
                        </div>
                     </div>
                     <label class="col-sm-6 control-label" style="margin-top:8px;">End Date</label><br/>
                     <div class="form-group">
                        <div class="col-sm-10">
                           <input class="input-sm input-s datepicker-input form-control" id="endDate" size="16" type="text" value="" data-date-format="yyyy-mm-dd" >
                        </div>
                     </div>
                     
                     <label class="col-sm-6 control-label routeLabelClass">Region</label><br/>
                     <div class="form-group">
                        <div class="col-sm-10"  id="regionNameCol">
                           <select id="regionName" multiple="multiple" class="input-s" name="state">
                           </select>
                        </div>
                     </div>
                     <label class="col-sm-6 control-label routeLabelClass">Route</label><br/>
                     <div class="form-group">
                        <div class="col-sm-10"  id="routeNameCol">
                           <select id="routeName" multiple="multiple" class="input-s" name="state">
                           </select>
                        </div>
                     </div>
                      <label class="col-sm-6 control-label routeLabelClass">Hub</label><br/>
                     <div class="form-group">
                        <div class="col-sm-10"  id="hubNameCol">
                           <select id="hubName" multiple="multiple" class="input-s" name="state">
                           </select>
                        </div>
                     </div>
                     <label class="col-sm-6 control-label" style="margin-top:8px;">Customer</label><br/>
                     <div class="form-group">
                        <div class="col-sm-10" id="custNameCol">
                           <select  id="customerName" multiple="multiple" class="input-s" name="state">
                           </select>
                        </div>
                     </div>
                     <label class="col-sm-6 control-label" style="margin-top:8px;">Product</label><br/>
                     <div class="form-group">
                        <div class="col-sm-10" id="productNameCol">
                           <select  id="productName" multiple="multiple" class="input-s" name="state">
                           </select>
                        </div>
                     </div>
                     <label class="col-sm-6 control-label" style="margin-top:8px;">Day</label><br/>
                     <div class="form-group">
                        <div class="col-sm-10" id="dayNameCol">
                           <select  id="dayName" multiple="multiple" class="input-s" name="state">
                              <option value="1"> Mon </option>
                              <option value="2"> Tue </option>
                              <option value="3"> Wed </option>
                              <option value="4"> Thu </option>
                              <option value="5"> Fri </option>
                              <option value="6"> Sat </option>
                              <option value="7"> Sun </option>
                           </select>
                        </div>
                     </div>
                     <label class="col-sm-6 control-label" style="margin-top:8px;"></label>
                     <div class="form-group" >
                        <div class="col-sm-10">
                           <button type="submit" class="btn btn-primary" onclick="$('#h3Header').removeClass('m-t-smHead');$('#lastsixmonths').hide();showAnalysis()" style="background:#46A4EC !important;cursor:pointer;" data-toggle="tooltip" title="Click here to get the Charts!">Show Analysis</button>
                        </div>
                     </div>
                     <!-- / nav -->
                  </div>
               </section>
            </section>
         </aside>
         <!-- /.aside -->
         <section id="content">
            <section class="vbox" >
               <section class="scrollable padder" id="contentChild">
                  <div class="m-b-md">
                     <div class="row">
                     </div>
                  </div>
                  <section class="panel panel-default">
                     <header class="panel-heading font-bold">
                      <div style="height: 18px !important;">
						BY DEPARTURE HOUR
						<button class="btn" onclick="downloadExcel('DEP_HOUR_AVG_COUNT_REPORT')" title="DEPARTURE HOUR REPORT EXCEL DOWNLOAD"  style="margin-left: 96% !important;font-size: 24px !important;margin-top: -29px !important;"><i class="fa fa-file-excel-o"></i></button>
					 </div>
              	    </header>
                     <div class="panel-body">
                        <div class="row">
                           <div class="col-md-6">
                              <h7>
                              <strong>AVG DELAY BY DEPARTURE HOUR</strong></h1>
                              <div class="panel-body" style="height:230px;">
                                 <div id="avg-delay-hour"  style="height:150px"></div>
                              </div>
                           </div>
                           <div class="col-md-6">
                              <h7><strong>TRIP COUNT BY DEPARTURE HOUR</strong></h7>
                              <div class="panel-body" style="height:230px;">
                                 <div id="trip-count-hour"  style="height:150px"></div>
                              </div>
                           </div>
                        </div>
                     </div>
                  </section>
                  <section class="panel panel-default" style="height: 392px;">
                  
                     <header class="panel-heading font-bold">
                      <div style="height: 18px !important;">
						<button class="btn" onclick="downloadExcel('DEP_HOUR_TRIP_STATUS_REPORT')" title="DEPARTURE HOUR REPORT EXCEL DOWNLOAD"  style="margin-left: 96% !important;font-size: 24px !important;margin-top: -9px !important;"><i class="fa fa-file-excel-o"></i></button>
					 </div>
              	    </header>
                     <div class="row">
                        <div class="col-md-6" style="padding-top:16px;">
                           <h7 class="h7Pad"><strong>TRIP STATUS BY DEPARTURE HOUR</strong></h7>
                           <div class="panel-body" style="height:230px;">
                              <div id="trip-status-dry-hour"  style="height:150px"></div>
                           </div>
                        </div>
                        <div class="col-md-6" style="padding-top:16px;">
                           <h7 class="h7Pad"><strong></strong></h7>
                           <div class="panel-body" style="height:230px;">
                              <div id="trip-status-tcl-hour"  style="height:150px"></div>
                           </div>
                        </div>
                     </div>
                  </section>
               </section>
            </section>
            <a href="#" class="hide nav-off-screen-block" data-toggle="class:nav-off-screen" data-target="#nav"></a>
         </section>
         <aside class="bg-light lter b-l aside-md hide" id="notes">
            <div class="wrapper">Notification</div>
         </aside>
      </section>
   </section>
   </section>

<!-- App -->
<script src="js/app.plugin.js"></script>
<script src="js/slimscroll/jquery.slimscroll.min.js"></script>
<script src="js/charts/sparkline/jquery.sparkline.min.js"></script>
<script src="js/charts/easypiechart/jquery.easy-pie-chart.js"></script>
<script src="js/charts/flot/jquery.flot.min.js"></script>
<script src="js/charts/flot/jquery.flot.tooltip.min.js"></script>
<script src="js/charts/flot/jquery.flot.resize.js"></script>
<script src="js/charts/flot/jquery.flot.orderBars.js"></script>
<script src="js/charts/flot/jquery.flot.pie.min.js"></script>
<script src="js/charts/flot/jquery.flot.grow.js"></script>
<script src="js/datepicker/bootstrap-datepicker.js"></script>
<script type="text/javascript" src="js/charts/flot/fusioncharts/fusioncharts.js"></script>
<script type="text/javascript" src="https://rawgit.com/fusioncharts/fusioncharts-jquery-plugin/develop/dist/fusioncharts.jqueryplugin.min.js"></script>
<script type="text/javascript" src="https://cdn.fusioncharts.com/fusioncharts/latest/themes/fusioncharts.theme.fusion.js"></script>
<script src="../../Main/sweetAlert/sweetalert.min.js"></script>
<script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-multiselect/0.9.15/js/bootstrap-multiselect.js"></script>
<script src="js/delayAnalytics.js"></script>
<script>

let url = '<%=t4uspringappURL%>';
let font = " 11px sans-serif";
var hourArray = ['0','1','2','3','4','5','6','7','8','9','10','11','12','13','14','15','16','17','18','19','20','21','22','23'];

function validate() {
   let valid = true;
   if ($("#regionName").val().length === 0) {
      sweetAlert("Please Select a Region");
      valid = false;
   } else if ($("#routeName").val().length === 0) {
         sweetAlert("Please Select a Route");
         valid = false;
   } else if($("#hubName").val().length === 0){
         sweetAlert("Please Select a Hub");
         valid = false;
   } else if($("#customerName").val().length === 0) {
         sweetAlert("Please Select a Customer");
         valid = false;
   } else {
	  if($("#productName").val().length === 0) {
         sweetAlert("Please Select a Product");
         valid = false;
	  }
   }
   return valid;
}
function validateDate() {
	var dateValid = true;
	var startDateRange = "";
    var endDateRange = "";
    startDateRange = document.getElementById("startDate").value;
    endDateRange = document.getElementById("endDate").value;	
    if (startDateRange == '') {
        sweetAlert("Please select Start Date");
        dateValid = false;
    }
    if (endDateRange == '') {
        sweetAlert("Please select End Date");
        dateValid = false;
    }
    if (startDateRange > endDateRange) {
        sweetAlert("End date should be greater than Start date");
        dateValid = false;
    }
	return dateValid;
}

function showAnalysis() {
   let dateRangeValidation =  validateDate();
   if(!dateRangeValidation) {
   	  return false;
   }
   let isValid = validate();
   if (!isValid) {
      return false;
   }
   $("#loading-div").show();
   let noData = "";
   let noDataCntr = 0;
   let orange = "#ffa600";
   let blue = "#003f5c";

   let customerVal = $("#customerName").val();
   let routeVal = $("#routeName").val();
   let productVal = $("#productName").val();
   
   $.ajax({
      url: url + '/departureHourDelayAnalysis',
      type: "POST",
      contentType: "application/json",
      data: JSON.stringify({
         startDate: formatDate($("#startDate").val()).toString(),
         endDate: formatDate($("#endDate").val()).toString(),
         regionName: $("#regionName").val().length === regionNameLength || $("#regionName").val() == '' ? 'all' : $("#regionName").val().toString(),
         routeKey: $("#routeName").val().length === routeNameLength || $("#routeName").val() == '' ? 'all' : $("#routeName").val().toString(),
         hubName: $("#hubName").val().toString(),
         product:  $("#productName").val().length === prodLength || $("#productName").val() == '' ? 'all' : $("#productName").val().toString(),
         tripCustomerId: $("#customerName").val().toString(),
		 dayId: $("#dayName").val().toString()
      }),
      success: function (json) {
         $("#loading-div").hide();
         noData += (json.code === 200) ? "No Records for Customer TAT\n" : "";
         let tempJSON = json.responseBody;
		 console.log("tempJSON " , tempJSON);
         
		 var dataAvgDryCount = [];
         var dataAvgTclCount = [];
		 var avgLabelArray = [];
		 var j= 0;
		 var k= 0;
		 for (var i = 0; i < hourArray.length; i++) {
            avgLabelArray.push({
               label: i.toString()
            });
			if(tempJSON.dryAvgDelayHourCount.length > 0) {
				if(j==tempJSON.dryAvgDelayHourCount.length) {
					dataAvgDryCount.push({
						value: "",
						color: "#ffb6c1",
						displayValue: ""
					 });
				}
				else {
					if(hourArray[i] == tempJSON.dryAvgDelayHourCount[j].hour) {
						dataAvgDryCount.push({
							value: tempJSON.dryAvgDelayHourCount[j].count,
							color: "#ffb6c1",
							displayValue: tempJSON.dryAvgDelayHourCount[j].count
						 });
						 j++;
					} else{
						dataAvgDryCount.push({
							value: "",
							color: "#ffb6c1",
							displayValue: ""
						 });
					}
			   }
			}
			
			if(tempJSON.tclAvgDelayHourCount.length > 0) {
				if(k==tempJSON.tclAvgDelayHourCount.length) {
					dataAvgTclCount.push({
						value: "",
						color: "#add8e6",
						displayValue: ""
					 });
				} else {
					if(hourArray[i] == tempJSON.tclAvgDelayHourCount[k].hour) {
						dataAvgTclCount.push({
							value: tempJSON.tclAvgDelayHourCount[k].count,
							color: "#add8e6",
							displayValue: tempJSON.tclAvgDelayHourCount[k].count
						 });
						 k++;
					} else{
						dataAvgTclCount.push({
							value: "",
							color: "#add8e6",
							displayValue: ""
						 });
					}
				}
			}
		 }	
		 //console.log("dataAvgDryCount " , dataAvgDryCount);

         $("#avg-delay-hour").insertFusionCharts({
            type: "mscolumn2d",
            width: "100%",
            height: "230",
            dataFormat: "json",
            dataSource: {
               chart: {
                  xaxisname: "HOUR OF THE DAY",
                  yaxisname: "AVG DELAY MINS",
                  yAxisMaxValue: "100",
                  yAxisMinValue: "0",
                  divLineColor: "#6699cc",
                  divLineAlpha: "60",
                  divLineDashed: "0",
                  formatnumberscale: "1",
                  showPlotBorder: "1",
                  plotbordercolor: "#ffffff",
                  plottooltext: "<b>$seriesName</b>: <b>$dataValue</b>",
                  dataEmptyMessage: "No Records Found",
                  theme: "fusion",
                  showLegend: "0",
                  showValues: "0",
                  rotateValues: "0",
                  rotateLabels: "0",
                  baseFontSize: "8",
                  drawcrossline: "1"
               },
               categories: [{
                  category: avgLabelArray
               }],
               dataset: [{
                     seriesname: "DRY",
                     data: dataAvgDryCount
                  },
                  {
                     seriesname: "TCL",
                     data: dataAvgTclCount
                  }

               ]
            }

         });


     
		 
		 var dataTripDryCount = [];
         var dataTripTclCount = [];
		 var tripCountLabelArray = [];
		 var m= 0;
		 var n= 0;
		 for (var i = 0; i < hourArray.length; i++) {
            tripCountLabelArray.push({
               label: i.toString()
            });
			if(tempJSON.dryTripHourCount.length > 0) {
				if(m==tempJSON.dryTripHourCount.length) {
					dataTripDryCount.push({
						value: "",
						color: "#ffb6c1",
						displayValue: ""
					 });
				}
				else {
					if(hourArray[i] == tempJSON.dryTripHourCount[m].hour) {
						dataTripDryCount.push({
							value: tempJSON.dryTripHourCount[m].count,
							color: "#ffb6c1",
							displayValue: tempJSON.dryTripHourCount[m].count
						 });
						 m++;
					} else{
						dataTripDryCount.push({
							value: "",
							color: "#ffb6c1",
							displayValue: ""
						 });
					}
			   }
			}
			
			if(tempJSON.tclTripHourCount.length > 0) {
				if(n==tempJSON.tclTripHourCount.length) {
					dataTripTclCount.push({
						value: "",
						color: "#add8e6",
						displayValue: ""
					 });
				} else {
					if(hourArray[i] == tempJSON.tclTripHourCount[n].hour) {
						dataTripTclCount.push({
							value: tempJSON.tclTripHourCount[n].count,
							color: "#add8e6",
							displayValue: tempJSON.tclTripHourCount[n].count
						 });
						 n++;
					} else{
						dataTripTclCount.push({
							value: "",
							color: "#add8e6",
							displayValue: ""
						 });
					}
				}
			}
		 }	

         $("#trip-count-hour").insertFusionCharts({
            type: "mscolumn2d",
            width: "100%",
            height: "230",
            dataFormat: "json",
            dataSource: {
               chart: {
                  xaxisname: "HOUR OF THE DAY",
                  yaxisname: "TRIP COUNT",
                  yAxisMaxValue: "1",
                  yAxisMinValue: "0",
                  divLineColor: "#6699cc",
                  divLineAlpha: "60",
                  divLineDashed: "0",
                  formatnumberscale: "1",
                  showPlotBorder: "1",
                  plotbordercolor: "#ffffff",
                  plottooltext: "<b>$seriesName</b>: <b>$dataValue</b>",
                  dataEmptyMessage: "No Records Found",
                  theme: "fusion",
                  showLegend: "0",
                  showValues: "0",
                  rotateValues: "0",
                  rotateLabels: "0",
                  baseFontSize: "8",
                  drawcrossline: "1"
               },
               categories: [{
                  category: tripCountLabelArray
               }],
               dataset: [{
                     seriesname: "DRY",
                     data: dataTripDryCount
                  },
                  {
                     seriesname: "TCL",
                     data: dataTripTclCount
                  }

               ]
            }

         });
         var totalDryCount = tempJSON.dryTripHourCount;
         var totalTclCount = tempJSON.tclTripHourCount;

		 var tripStatusDryCountArray = [];
		 var a1 = 0;
		 for (var j = 0; j < hourArray.length; j++) {
			if(tempJSON.dryTripHourCount.length > 0) {
				if(a1==tempJSON.dryTripHourCount.length) {
					 tripStatusDryCountArray.push(0);
				}
				else {
					if(hourArray[j] == tempJSON.dryTripHourCount[a1].hour) {
						tripStatusDryCountArray.push(tempJSON.dryTripHourCount[a1].count);
						 a1++;
					} else{
						 tripStatusDryCountArray.push(0);
					}
			   }
			}
		 }	
		 
		 var tripStatusTclCountArray = [];
		 var b1 = 0;
		 for (var j = 0; j < hourArray.length; j++) {
			if(tempJSON.tclTripHourCount.length > 0) {
				if(b1==tempJSON.tclTripHourCount.length) {
					 tripStatusTclCountArray.push(0);
				}
				else {
					if(hourArray[j] == tempJSON.tclTripHourCount[b1].hour) {
						tripStatusTclCountArray.push(tempJSON.tclTripHourCount[b1].count);
						 b1++;
					} else{
						 tripStatusTclCountArray.push(0);
					}
			   }
			}
		 }	
		 
		 var dataTripDryStatusDelayedCount = [];
         var dataTripDryStatusOntimeCount = [];
		 var dryTripStatusLabelArray = [];
		 var a= 0;
		 var b= 0;
		 for (var i = 0; i < hourArray.length; i++) {
            dryTripStatusLabelArray.push({
               label: i.toString()
            });
			if(tempJSON.delayedStatusDryHourCount.length > 0) {
				if(a==tempJSON.delayedStatusDryHourCount.length) {
					dataTripDryStatusDelayedCount.push({
						value: "",
						color: "#ff6361",
						displayValue: ""
					 });
				}
				else {
					if(hourArray[i] == tempJSON.delayedStatusDryHourCount[a].hour) {
						dataTripDryStatusDelayedCount.push({
							value: ((tempJSON.delayedStatusDryHourCount[a].count * 100) / tripStatusDryCountArray[i]),//totalDryCount[a].count),
							color: "#ff6361",
							displayValue: ((tempJSON.delayedStatusDryHourCount[a].count * 100) / tripStatusDryCountArray[i])//totalDryCount[a].count)
						 });
						 a++;
					} else{
						dataTripDryStatusDelayedCount.push({
							value: "",
							color: "#ff6361",
							displayValue: ""
						 });
					}
			   }
			}
			
			if(tempJSON.ontimeStatusDryHourCount.length > 0) {
				if(b==tempJSON.ontimeStatusDryHourCount.length) {
					dataTripDryStatusOntimeCount.push({
						value: "",
						color: "#58508d",
						displayValue: ""
					 });
				} else {
					if(hourArray[i] == tempJSON.ontimeStatusDryHourCount[b].hour) {
						dataTripDryStatusOntimeCount.push({
							value: ((tempJSON.ontimeStatusDryHourCount[b].count * 100) / tripStatusDryCountArray[i]),//totalDryCount[b].count),
							color: "#58508d",
							displayValue: ((tempJSON.ontimeStatusDryHourCount[b].count * 100) / tripStatusDryCountArray[i])//totalDryCount[b].count)
						 });
						 b++;
					} else{
						dataTripDryStatusOntimeCount.push({
							value: "",
							color: "#58508d",
							displayValue: ""
						 });
					}
				}
			}
		 }	
		 
		 var dataTripTclStatusDelayedCount = [];
         var dataTripTclStatusOntimeCount = [];
		 var tclTripStatusLabelArray = [];
		 var p = 0;
		 var q = 0;
		 for (var i = 0; i < hourArray.length; i++) {
            tclTripStatusLabelArray.push({
               label: i.toString()
            });
			if(tempJSON.delayedStatusTclHourCount.length > 0) {
				if(p==tempJSON.delayedStatusTclHourCount.length) {
					dataTripTclStatusDelayedCount.push({
						value: "",
						color: "#ff6361",
						displayValue: ""
					 });
				}
				else {
					if(hourArray[i] == tempJSON.delayedStatusTclHourCount[p].hour) {
						dataTripTclStatusDelayedCount.push({
							value: ((tempJSON.delayedStatusTclHourCount[p].count * 100) / tripStatusTclCountArray[i]),//totalTclCount[p].count),
							color: "#ff6361",
							displayValue: ((tempJSON.delayedStatusTclHourCount[p].count * 100) / tripStatusTclCountArray[i])//totalTclCount[p].count)
						 });
						 p++;
					} else{
						dataTripTclStatusDelayedCount.push({
							value: "",
							color: "#ff6361",
							displayValue: ""
						 });
					}
			   }
			}
			
			if(tempJSON.ontimeStatusTclHourCount.length > 0) {
				if(q==tempJSON.ontimeStatusTclHourCount.length) {
					dataTripTclStatusOntimeCount.push({
						value: "",
						color: "#58508d",
						displayValue: ""
					 });
				} else {
					if(hourArray[i] == tempJSON.ontimeStatusTclHourCount[q].hour) {
						dataTripTclStatusOntimeCount.push({
							value: ((tempJSON.ontimeStatusTclHourCount[q].count * 100) / tripStatusTclCountArray[i]),//totalTclCount[q].count),
							color: "#58508d",
							displayValue: ((tempJSON.ontimeStatusTclHourCount[q].count * 100) / tripStatusTclCountArray[i])//totalTclCount[q].count)
						 });
						 q++;
					} else{
						dataTripTclStatusOntimeCount.push({
							value: "",
							color: "#58508d",
							displayValue: ""
						 });
					}
				}
			}
		 }	
	
         $("#trip-status-dry-hour").insertFusionCharts({
            type: "stackedcolumn2d",
            width: "100%",
            height: "300",
            dataFormat: "json",
            dataSource: {
               chart: {
				  xAxisname: "HOUR OF THE DAY",
                  yaxisname: "% OF TRIPS",
                  caption: "",
                  subcaption: "DRY",
                  numbersuffix: "",
                  showsum: "0",
                  baseFontSize: "8",
                  rotateLabels: "0",
                  plottooltext: "<b>$dataValue</b> $seriesName",
                  theme: "fusion",
                  drawcrossline: "1"
               },
               categories: [{
                  category: dryTripStatusLabelArray
               }],
               dataset: [{
                     seriesname: "ON TIME",
                     color: "#58508d",
                     data: dataTripDryStatusOntimeCount
                  },
                  {
                     seriesname: "DELAYED",
                     color: "#ff6361",
                     data: dataTripDryStatusDelayedCount
                  }
               ]
            }
         });

         $("#trip-status-tcl-hour").insertFusionCharts({
            type: "stackedcolumn2d",
            width: "100%",
            height: "300",
            dataFormat: "json",
            dataSource: {
               chart: {
				  xAxisname: "HOUR OF THE DAY",
                  yaxisname: "",
                  caption: "",
                  subcaption: "TCL",
                  numbersuffix: "",
                  showsum: "0",
                  baseFontSize: "9",
                  rotateLabels: "0",
                  plottooltext: "<b>$dataValue</b> $seriesName",
                  theme: "fusion",
                  drawcrossline: "1"
               },
               categories: [{
                  category: tclTripStatusLabelArray
               }],
               dataset: [{
                     seriesname: "ON TIME",
                     color: "#58508d",
                     data: dataTripTclStatusOntimeCount
                  },
                  {
                     seriesname: "DELAYED",
                     color: "#ff6361",
                     data: dataTripTclStatusDelayedCount
                  }
               ]
            }
         });

         
      }
   });


}

$("#angleArrow").on("click", function () {
   if ($("#nav").width() === 219) {
      $("#nav").width(0);
      $("#secTop").hide(500);
      $("#contentChild").width($(window).width() - 32);
   } else {
      $("#nav").width(219);
      $("#secTop").show(500);
      $("#contentChild").width($("#content").width() - 220)
   }
   setTimeout(function () {
      hideLegend()
   }, 1100);
})

function hideLegend() {
   for (let b = 0; b < donutId; b++) {
      let c = plots[b].getCanvas();
      let canvas = c.getContext("2d");
      let cx = c.width / 2.0;
      topPosTitle = c.height / 2.0;
      let text = donutDryTCL[b];
      canvas.font = font;
      canvas.textAlign = 'center';
      canvas.fillText(text, cx, topPosTitle);
   }

}

/*$('#endDate').on("blur", function () {
   dateChangeRefresh();
})

$('#startDate').on("blur", function () {
   dateChangeRefresh();
})  */

$("#startDate").datepicker().on('changeDate', function (ev) {   
	$(".datepicker").hide();
	dateChangeRefresh();
});
$("#endDate").datepicker().on('changeDate', function (ev) {   
	$(".datepicker").hide();
	dateChangeRefresh();
});


function dateChangeRefresh() {
   setTimeout(function () {
   $("#regionName").html("");
   $("#regionName").multiselect('destroy'); 
   
   $.ajax({
		url: url + '/getDelayRegions',
		type: "POST",
		contentType: "application/json",
		data: JSON.stringify({
		    startDate: formatDate($("#startDate").val()).toString(),
		    endDate: formatDate($("#endDate").val()).toString()
	  }),  
	   success: function (regions) {	      
	   regions = regions.responseBody;
	   console.log("regions " + JSON.stringify(regions)); 
	   regionNameLength = regions.length;
	   regions.forEach(function (item) {
		   $('#regionName').append($("<option></option>").attr("value", "'" + item.regionName + "'").text(item.regionName));
	   });
	   $('#regionName').multiselect({
		 maxHeight: 200,  
		 buttonWidth: '186px',
		 enableFiltering: true,
		 allSelectedText: 'All',
		 enableCaseInsensitiveFiltering: true,
		 includeSelectAllOption: true,
		 onSelectAll: function () {
		  regionAllSelected= true;
         }
		 }).multiselect('selectAll', false)
		   .multiselect('updateButtonText');
   
        $("#routeName").html("");
   		$("#routeName").multiselect('destroy'); 
   		$.ajax({
	  		url: url + '/getDelayRoutes',
	  		type: "POST",
	  		contentType: "application/json",
	  		data: JSON.stringify({
		 	   startDate: formatDate($("#startDate").val()).toString(),
		 	   endDate: formatDate($("#endDate").val()).toString(),
		 	   regionName: $("#regionName").val().length === regionNameLength || $("#regionName").val() == '' ? 'all' : $("#regionName").val().toString()//newly added
	  		}),  
	  		success: function (routes) {	
	   		routes = routes.responseBody;
	   		//console.log("routes " + JSON.stringify(routes)); 
	   		routes.forEach(function (item) {
		   		$('#routeName').append($("<option></option>").attr("value", "'" + item.routeKey + "'").text(item.routeKey));
	   		}); 
	       $('#routeName').multiselect({
         	 maxHeight: 200,   
		  	 buttonWidth: '186px',
		  	 enableFiltering: true,
		  	 allSelectedText: 'All',
		  	 enableCaseInsensitiveFiltering: true,
		  	 includeSelectAllOption: true,
		  	 onSelectAll: function () {
		   	   routeAllSelected= true;
          	}
		  }).multiselect('selectAll', false)
			.multiselect('updateButtonText');
	      routeLength = $("#routeName").val().length;
		  
		$("#hubName").html("");
		$("#hubName").multiselect('destroy');  
		$.ajax({
			url: url + '/getDelayHubs',
			type: "POST",
			contentType: "application/json",
			data: JSON.stringify({
				startDate: formatDate($("#startDate").val()).toString(),
				endDate: formatDate($("#endDate").val()).toString(),
				regionName: $("#regionName").val().length === regionNameLength || $("#regionName").val() == '' ? 'all' : $("#regionName").val().toString(),//newly added
				routeKey: $("#routeName").val().length === routeNameLength || $("#routeName").val() == '' ? 'all' : $("#routeName").val().toString()
			}),  
			success: function (hubs) {	      
			  hubs = hubs.responseBody;
			  //console.log("hubs " + JSON.stringify(hubs)); 
			  hubNameLength = hubs.length;
			  hubs.forEach(function (item) {
				$('#hubName').append($("<option></option>").attr("value", "'" + item.hubId + "'").text(item.hubName));
			  });
	       	$('#hubName').multiselect({
			maxHeight: 200,  
			buttonWidth: '186px',
			enableFiltering: true,
			allSelectedText: 'All',
			enableCaseInsensitiveFiltering: true,
			includeSelectAllOption: true,
			onSelectAll: function () {
		  	  hubAllSelected= true;
        	}
	   		}).multiselect('selectAll', false)
		   .multiselect('updateButtonText');  
		  
		   $("#customerName").html("");
		   $("#customerName").multiselect('destroy'); 	   
			   $.ajax({
				  url: url + '/getDelayCustomer',
				  type: "POST",
				  contentType: "application/json",
				  data: JSON.stringify({
					  startDate: formatDate($("#startDate").val()).toString(),
					  endDate: formatDate($("#endDate").val()).toString(),
		  			  regionName: $("#regionName").val().length === regionNameLength || $("#regionName").val() == '' ? 'all' : $("#regionName").val().toString(),//newly added
		  			  routeKey: $("#routeName").val().length === routeNameLength || $("#routeName").val() == '' ? 'all' : $("#routeName").val().toString(),//$("#routeName").val().toString(),
		  			  hubName:  $("#hubName").val().toString()
				  }),
				  success: function (customers) {
					customers = customers.responseBody;
					//console.log("customers " + JSON.stringify(customers)); 
					customers.forEach(function (item) {
						//$('#customerName').append("<option value='"+item.tripCustomerId+"'>"+item.customer+"</option>");
						$('#customerName').append($("<option></option>").attr("value", "'" + item.tripCustomerId + "'").text(item.customer));
					 });
					 $('#customerName').multiselect({
					 maxHeight: 200, 	 
					 buttonWidth: '186px',
					 enableFiltering: true,
					 allSelectedText: 'All',
					 enableCaseInsensitiveFiltering: true,
					 includeSelectAllOption: true,
					 onSelectAll: function () {
						 //customerAllSelected= true;
					 }
					 }).multiselect('selectAll', false)
					 .multiselect('updateButtonText');
					 //custLength = $("#customerName").val().length;
				 
		    $("#productName").html("");
            $("#productName").multiselect('destroy'); 
		    $.ajax({
			  url: url + '/getDelayProduct',
			  type: "POST",
			  contentType: "application/json",
			  data: JSON.stringify({
				 startDate: formatDate($("#startDate").val()).toString(),
			     endDate: formatDate($("#endDate").val()).toString(),
			 	  //routeKey: $("#routeName").val().toString()
			 	 regionName: $("#regionName").val().length === regionNameLength || $("#regionName").val() == '' ? 'all' : $("#regionName").val().toString(),//newly added
			 	 routeKey: $("#routeName").val().length === routeNameLength || $("#routeName").val() == '' ? 'all' : $("#routeName").val().toString(),//"all"
			 	 hubName: $("#hubName").val().toString(),
			 	 tripCustomerId:  $("#customerName").val().toString()//$("#customerName").val().length === custLength || $("#customerName").val() == '' ? 'all' : $("#customerName").val().toString()
			  }),   
			   success: function (product) {			      
			   product = product.responseBody;
			   //console.log("product " + JSON.stringify(product));
			   product.forEach(function (item) {
					$('#productName').append($("<option></option>").attr("value", "'" + item.product + "'").text(item.product));
			   });
			   $('#productName').multiselect({
				 maxHeight: 200,  
				 buttonWidth: '186px',
				 enableFiltering: true,
				 enableCaseInsensitiveFiltering: true,
				 allSelectedText: 'All',
				 includeSelectAllOption: true,
				 onSelectAll: function () {
				    productAllSelected= true;
				 }
			  }).multiselect('selectAll', false)
				.multiselect('updateButtonText');
			   productLength = $("#productName").val().length;
		    }
	      });  
        }
     });	 
		  
    }
  });
  
  }
  });
  
  }
  });
  
 }, 500);
} 
function downloadExcel(type) {
    window.open("<%=request.getContextPath()%>/AnalyticsServlet?type="+type);
}
</script>
</body>

<jsp:include page="../Common/footer.jsp" />
