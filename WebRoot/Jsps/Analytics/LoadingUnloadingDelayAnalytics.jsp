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
<!--              <nav class="nav-primary hidden-xs" style="margin-top:56px;>-->
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
                    
                    <label class="col-sm-6 control-label" style="margin-top:8px;"></label>
                    <div class="form-group" >
                      <div class="col-sm-10">
                        <button type="submit" class="btn btn-primary" onclick="$('#h3Header').removeClass('m-t-smHead');$('#lastsixmonths').hide();showAnalysis()" style="background:#46A4EC !important;cursor:pointer;" data-toggle="tooltip" title="Click here to get the Charts!">Show Analysis</button>
                      </div>
                    </div>


<!--              </nav>-->
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
            <section class="panel panel-default" style="height: 401px;">
			<header class="panel-heading font-bold">LOADING UNLOADING
             <div style="height: 1px !important;">
				<button class="btn" onclick="downloadExcel('SRC_DETN_LOADING_UNLOADING_REPORT')" title="SOURCE DETENTION STATUS REPORT EXCEL DOWNLOAD"  style="margin-left: 96% !important;font-size: 24px !important;margin-top: -31px !important;"><i class="fa fa-file-excel-o"></i></button>
			 </div>
            </header>
            <div class="row">
				 <div class="col-md-6" style="padding-top:16px;">
                     <h7 class="h7Pad"><strong>SOURCE DETENTION BY MONTH</strong></h7>
              			<div class="panel-body" style="height:230px;">
                		<div id="source-detention-dry-month"  style="height:150px"></div>
              			</div>
                     </div>
					 <div class="col-md-6" style="padding-top:16px;">
					 <h7 class="h7Pad"><strong></strong></h7>
              			<div class="panel-body" style="height:230px;">
                		<div id="source-detention-tcl-month"  style="height:150px"></div>
              			</div>
                     </div>
              </div>
            </section>
            
            <section class="panel panel-default" style="height: 392px;">
			<header class="panel-heading font-bold">
             <div style="height: 18px !important;">
				<button class="btn" onclick="downloadExcel('DEST_DETN_LOADING_UNLOADING_REPORT')" title="DESTINATION DETENTION STATUS REPORT EXCEL DOWNLOAD"  style="margin-left: 96% !important;font-size: 24px !important;margin-top: -9px !important;"><i class="fa fa-file-excel-o"></i></button>
			 </div>
            </header>
            <div class="row">
				 <div class="col-md-6" style="padding-top:16px;">
                     <h7 class="h7Pad"><strong>DESTINATION DETENTION BY MONTH</strong></h7>
              			<div class="panel-body" style="height:230px;">
                		<div id="destination-detention-dry-month"  style="height:150px"></div>
              			</div>
                     </div>
					 <div class="col-md-6" style="padding-top:16px;">
					 <h7 class="h7Pad"><strong></strong></h7>
              			<div class="panel-body" style="height:230px;">
                		<div id="destination-detention-tcl-month"  style="height:150px"></div>
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
var monthArray = ['1','2','3','4','5','6','7','8','9','10','11','12'];

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
      url: url + '/loadingUnloadingDelayAnalysis',
      type: "POST",
      contentType: "application/json",
      data: JSON.stringify({
         startDate: formatDate($("#startDate").val()).toString(),
         endDate: formatDate($("#endDate").val()).toString(),
         regionName: $("#regionName").val().length === regionNameLength || $("#regionName").val() == '' ? 'all' : $("#regionName").val().toString(),
         routeKey: $("#routeName").val().length === routeNameLength || $("#routeName").val() == '' ? 'all' : $("#routeName").val().toString(),
         hubName: $("#hubName").val().toString(),
         product:  $("#productName").val().length === prodLength || $("#productName").val() == '' ? 'all' : $("#productName").val().toString(),
         tripCustomerId: $("#customerName").val().toString()
      }),
      success: function (json) {
         $("#loading-div").hide();
         noData += (json.code === 200) ? "No Records for Customer TAT\n" : "";
         let tempJSON = json.responseBody;
         console.log("temp json is", tempJSON);

		 
		 var totalDryCount = tempJSON.totalDryCount;
         var totalTclCount = tempJSON.totalTclCount;
		 
		 var dryCountMonthArray = [];
		 var a1 = 0;
		  for (var j = 0; j < monthArray.length; j++) {
			if(tempJSON.totalDryCount.length > 0) {
				if(a1==tempJSON.totalDryCount.length) {
					 dryCountMonthArray.push(0);
				}
				else {
					if(monthArray[j] == tempJSON.totalDryCount[a1].month) {
						dryCountMonthArray.push(tempJSON.totalDryCount[a1].count);
						 a1++;
					} else{
						 dryCountMonthArray.push(0);
					}
			   }
			}
		  }
		  
		 var tclCountMonthArray = [];
		 var b1 = 0;
		  for (var j = 0; j < monthArray.length; j++) {
			if(tempJSON.totalTclCount.length > 0) {
				if(b1==tempJSON.totalTclCount.length) {
					 tclCountMonthArray.push(0);
				}
				else {
					if(monthArray[j] == tempJSON.totalTclCount[b1].month) {
						tclCountMonthArray.push(tempJSON.totalTclCount[b1].count);
						 b1++;
					} else{
						 tclCountMonthArray.push(0);
					}
			   }
			}
		  }
		 
		 var dataSrcDetnAsPlannedMonthDryCount = [];
         var dataSrcDetnExcessMonthDryCount = [];
		 var srcDetnMonthDryLabelArray = [];
		 var p = 0;
		 var q = 0;
		 for (var i = 0; i < monthArray.length; i++) {
            srcDetnMonthDryLabelArray.push({
               label: (i+1).toString()
            });
			if(tempJSON.srcAsplannedMonthDry.length > 0) {
				if(p==tempJSON.srcAsplannedMonthDry.length) {
					dataSrcDetnAsPlannedMonthDryCount.push({
						value: "",
						color: "#527525",
						displayValue: ""
					 });
				}
				else {
					if(monthArray[i] == tempJSON.srcAsplannedMonthDry[p].month) {
						dataSrcDetnAsPlannedMonthDryCount.push({
							value: ((tempJSON.srcAsplannedMonthDry[p].count * 100) / dryCountMonthArray[i]),//totalDryCount[p].count),
							color: "#527525",
							displayValue: ((tempJSON.srcAsplannedMonthDry[p].count * 100) / dryCountMonthArray[i])//totalDryCount[p].count)
						 });
						 p++;
					} else{
						dataSrcDetnAsPlannedMonthDryCount.push({
							value: "",
							color: "#527525",
							displayValue: ""
						 });
					}
			   }
			}
			
			if(tempJSON.srcExcessMonthDry.length > 0) {
				if(q==tempJSON.srcExcessMonthDry.length) {
					dataSrcDetnExcessMonthDryCount.push({
						value: "",
						color: "#BA48AA",
						displayValue: ""
					 });
				} else {
					if(monthArray[i] == tempJSON.srcExcessMonthDry[q].month) {
						dataSrcDetnExcessMonthDryCount.push({
							value: ((tempJSON.srcExcessMonthDry[q].count * 100) / dryCountMonthArray[i]),//totalDryCount[q].count),
							color: "#BA48AA",
							displayValue: ((tempJSON.srcExcessMonthDry[q].count * 100) / dryCountMonthArray[i])//totalDryCount[q].count)
						 });
						 q++;
					} else{
						dataSrcDetnExcessMonthDryCount.push({
							value: "",
							color: "#BA48AA",
							displayValue: ""
						 });
					}
				}
			}
		 }	
         $("#source-detention-dry-month").insertFusionCharts({
            type: "stackedcolumn2d",
            width: "100%",
            height: "300",
            dataFormat: "json",
            dataSource: {
               chart: {
				  xaxisname: "MONTH",
                  yaxisname: "% OF TRIPS",   
                  caption: "",
                  subcaption: "DRY",
                  numbersuffix: "",
                  showsum: "0",
                  baseFontSize: "10",
                  rotateLabels: "0",
                  plottooltext: "<b>$dataValue</b> $seriesName",
                  theme: "fusion",
                  drawcrossline: "1"
               },
               categories: [{
                  category: srcDetnMonthDryLabelArray
               }],
               dataset: [{
                     seriesname: "AS PLANNED",
                     color: "#527525",
                     data: dataSrcDetnAsPlannedMonthDryCount
                  },
                  {
                     seriesname: "EXCESS",
                     color: "#BA48AA",
                     data: dataSrcDetnExcessMonthDryCount
                  }
               ]
            }
         });

		 var dataSrcDetnAsPlannedMonthTclCount = [];
         var dataSrcDetnExcessMonthTclCount = [];
		 var tclDetnMonthDryLabelArray = [];
		 var a = 0;
		 var b = 0;
		 for (var i = 0; i < monthArray.length; i++) {
            tclDetnMonthDryLabelArray.push({
               label: (i+1).toString()
            });
			if(tempJSON.srcAsplannedMonthTcl.length > 0) {
				if(a==tempJSON.srcAsplannedMonthTcl.length) {
					dataSrcDetnAsPlannedMonthTclCount.push({
						value: "",
						color: "#527525",
						displayValue: ""
					 });
				}
				else {
					if(monthArray[i] == tempJSON.srcAsplannedMonthTcl[a].month) {
						dataSrcDetnAsPlannedMonthTclCount.push({
							value: ((tempJSON.srcAsplannedMonthTcl[a].count * 100) / tclCountMonthArray[i]),//totalTclCount[a].count),
							color: "#527525",
							displayValue: ((tempJSON.srcAsplannedMonthTcl[a].count * 100) / tclCountMonthArray[i])//totalTclCount[a].count)
						 });
						 a++;
					} else{
						dataSrcDetnAsPlannedMonthTclCount.push({
							value: "",
							color: "#527525",
							displayValue: ""
						 });
					}
			   }
			}
			
			if(tempJSON.srcExcessMonthTcl.length > 0) {
				if(b==tempJSON.srcExcessMonthTcl.length) {
					dataSrcDetnExcessMonthTclCount.push({
						value: "",
						color: "#BA48AA",
						displayValue: ""
					 });
				} else {
					if(monthArray[i] == tempJSON.srcExcessMonthTcl[b].month) {
						dataSrcDetnExcessMonthTclCount.push({
							value: ((tempJSON.srcExcessMonthTcl[b].count * 100) / tclCountMonthArray[i]),//totalTclCount[b].count),
							color: "#BA48AA",
							displayValue: ((tempJSON.srcExcessMonthTcl[b].count * 100) / tclCountMonthArray[i])//totalTclCount[b].count)
						 });
						 b++;
					} else{
						dataSrcDetnExcessMonthTclCount.push({
							value: "",
							color: "#BA48AA",
							displayValue: ""
						 });
					}
				}
			}
		 }	
         $("#source-detention-tcl-month").insertFusionCharts({
            type: "stackedcolumn2d",
            width: "100%",
            height: "300",
            dataFormat: "json",
            dataSource: {
               chart: {
				  xaxisname: "MONTH",
                  yaxisname: "% OF TRIPS",   
                  caption: "",
                  subcaption: "TCL",
                  numbersuffix: "",
                  showsum: "0",
                  baseFontSize: "10",
                  rotateLabels: "0",
                  plottooltext: "<b>$dataValue</b> $seriesName",
                  theme: "fusion",
                  drawcrossline: "1"
               },
               categories: [{
                  category: tclDetnMonthDryLabelArray
               }],
               dataset: [{
                     seriesname: "AS PLANNED",
                     color: "#527525",
                     data: dataSrcDetnAsPlannedMonthTclCount
                  },
                  {
                     seriesname: "EXCESS",
                     color: "#BA48AA",
                     data: dataSrcDetnExcessMonthTclCount
                  }
               ]
            }
         });

		 var dataDestDetnAsPlannedMonthDryCount = [];
         var dataDestDetnExcessMonthDryCount = [];
		 var destDetnMonthDryLabelArray = [];
		 var m = 0;
		 var n = 0;
		 for (var i = 0; i < monthArray.length; i++) {
            destDetnMonthDryLabelArray.push({
               label: (i+1).toString()
            });
			if(tempJSON.destAsplannedMonthDry.length > 0) {
				if(m==tempJSON.destAsplannedMonthDry.length) {
					dataDestDetnAsPlannedMonthDryCount.push({
						value: "",
						color: "#527525",
						displayValue: ""
					 });
				}
				else {
					if(monthArray[i] == tempJSON.destAsplannedMonthDry[m].month) {
						dataDestDetnAsPlannedMonthDryCount.push({
							value: ((tempJSON.destAsplannedMonthDry[m].count * 100) / dryCountMonthArray[i]),//totalDryCount[m].count),
							color: "#527525",
							displayValue: ((tempJSON.destAsplannedMonthDry[m].count * 100) / dryCountMonthArray[i])//totalDryCount[m].count)
						 });
						 m++;
					} else{
						dataDestDetnAsPlannedMonthDryCount.push({
							value: "",
							color: "#527525",
							displayValue: ""
						 });
					}
			   }
			}
			
			if(tempJSON.destExcessMonthDry.length > 0) {
				if(n==tempJSON.destExcessMonthDry.length) {
					dataDestDetnExcessMonthDryCount.push({
						value: "",
						color: "#BA48AA",
						displayValue: ""
					 });
				} else {
					if(monthArray[i] == tempJSON.destExcessMonthDry[n].month) {
						dataDestDetnExcessMonthDryCount.push({
							value: ((tempJSON.destExcessMonthDry[n].count * 100) / dryCountMonthArray[i]),//totalDryCount[n].count),
							color: "#BA48AA",
							displayValue: ((tempJSON.destExcessMonthDry[n].count * 100) / dryCountMonthArray[i])//totalDryCount[n].count)
						 });
						 n++;
					} else{
						dataDestDetnExcessMonthDryCount.push({
							value: "",
							color: "#BA48AA",
							displayValue: ""
						 });
					}
				}
			}
		 }	

         $("#destination-detention-dry-month").insertFusionCharts({
            type: "stackedcolumn2d",
            width: "100%",
            height: "300",
            dataFormat: "json",
            dataSource: {
               chart: {
				  xaxisname: "MONTH",
                  yaxisname: "% OF TRIPS",  
                  caption: "",
                  subcaption: "DRY",
                  numbersuffix: "",
                  showsum: "0",
                  baseFontSize: "10",
                  rotateLabels: "0",
                  plottooltext: "<b>$dataValue</b> $seriesName",
                  theme: "fusion",
                  drawcrossline: "1"
               },
               categories: [{
                  category: destDetnMonthDryLabelArray
               }],
               dataset: [{
                     seriesname: "AS PLANNED",
                     color: "#527525",
                     data: dataDestDetnAsPlannedMonthDryCount
                  },
                  {
                     seriesname: "EXCESS",
                     color: "#BA48AA",
                     data: dataDestDetnExcessMonthDryCount
                  }
               ]
            }
         });
		 
		 var dataDestDetnAsPlannedMonthTclCount = [];
         var dataDestDetnExcessMonthTclCount = [];
		 var tclDetnMonthLabelArray = [];
		 var x = 0;
		 var y = 0;
		 for (var i = 0; i < monthArray.length; i++) {
            tclDetnMonthLabelArray.push({
               label: (i+1).toString()
            });
			if(tempJSON.destAsplannedMonthTcl.length > 0) {
				if(x==tempJSON.destAsplannedMonthTcl.length) {
					dataDestDetnAsPlannedMonthTclCount.push({
						value: "",
						color: "#527525",
						displayValue: ""
					 });
				}
				else {
					if(monthArray[i] == tempJSON.destAsplannedMonthTcl[x].month) {
						dataDestDetnAsPlannedMonthTclCount.push({
							value: ((tempJSON.destAsplannedMonthTcl[x].count * 100) / tclCountMonthArray[i]),//totalTclCount[x].count),
							color: "#527525",
							displayValue: ((tempJSON.destAsplannedMonthTcl[x].count * 100) / tclCountMonthArray[i])//totalTclCount[x].count)
						 });
						 x++;
					} else{
						dataDestDetnAsPlannedMonthTclCount.push({
							value: "",
							color: "#527525",
							displayValue: ""
						 });
					}
			   }
			}
			
			if(tempJSON.destExcessMonthTcl.length > 0) {
				if(y==tempJSON.destExcessMonthTcl.length) {
					dataDestDetnExcessMonthTclCount.push({
						value: "",
						color: "#BA48AA",
						displayValue: ""
					 });
				} else {
					if(monthArray[i] == tempJSON.destExcessMonthTcl[y].month) {
						dataDestDetnExcessMonthTclCount.push({
							value: ((tempJSON.destExcessMonthTcl[y].count * 100) / tclCountMonthArray[i]),//totalTclCount[y].count),
							color: "#BA48AA",
							displayValue: ((tempJSON.destExcessMonthTcl[y].count * 100) / tclCountMonthArray[i])//totalTclCount[y].count)
						 });
						 y++;
					} else{
						dataDestDetnExcessMonthTclCount.push({
							value: "",
							color: "#BA48AA",
							displayValue: ""
						 });
					}
				}
			}
		 }	

         $("#destination-detention-tcl-month").insertFusionCharts({
            type: "stackedcolumn2d",
            width: "100%",
            height: "300",
            dataFormat: "json",
            dataSource: {
               chart: {
				  xaxisname: "MONTH",
                  yaxisname: "% OF TRIPS", 
                  caption: "",
                  subcaption: "TCL",
                  numbersuffix: "",
                  showsum: "0",
                  baseFontSize: "10",
                  rotateLabels: "0",
                  plottooltext: "<b>$dataValue</b> $seriesName",
                  theme: "fusion",
                  drawcrossline: "1"
               },
               categories: [{
                  category: tclDetnMonthLabelArray
               }],
               dataset: [{
                     seriesname: "AS PLANNED",
                     color: "#527525",
                     data: dataDestDetnAsPlannedMonthTclCount
                  },
                  {
                     seriesname: "EXCESS",
                     color: "#BA48AA",
                     data: dataDestDetnExcessMonthTclCount
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
/*
$('#endDate').on("blur", function () {
   dateChangeRefresh();
})
$('#startDate').on("blur", function () {
   dateChangeRefresh();
}) */

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
