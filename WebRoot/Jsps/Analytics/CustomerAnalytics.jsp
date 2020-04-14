<%@ page language="java" import="java.util.*,t4u.functions.CommonFunctions,t4u.beans.*,t4u.common.*" pageEncoding="ISO-8859-1"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";

Properties properties = ApplicationListener.prop;
   String t4uspringappURL = properties.getProperty("t4uspringappURL").trim();
%>

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
            ANALYTICS
          </h3>
          </header>
          <section class="w-f scrollable">
            <div class="slim-scroll" data-height="auto" data-disable-fade-out="true" data-distance="0" data-size="5px" data-color="#333333" style="margin-top:53px !important;">

              <!-- nav   -->
           <!--   <nav class="nav-primary hidden-xs" style="margin-top:56px;> -->
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
                    <!--<div class="form-group">
                      <div class="col-sm-10">
                        <div class="checkbox">
                          <label>
                            <input type="checkbox" disabled> Aggregate
                          </label>
                        </div>
                      </div>
                    </div>-->
                    <label class="col-sm-6 control-label" style="margin-top:8px;"></label>
                    <div class="form-group" >
                      <div class="col-sm-10">
                        <button type="submit" class="btn btn-primary" onclick="$('#h3Header').removeClass('m-t-smHead');$('#lastsixmonths').hide();showAnalysis()" style="background:#46A4EC !important;cursor:pointer;">Show Analysis</button>
                      </div>
                    </div>


            <!--   </nav>
              / nav -->
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
                <div class="col-sm-6">
                  <div style="display:flex">
                    <div><i class="fa fa-2x fa-bars" id="angleArrow" style="margin-top:20px;margin-right:16px;cursor:pointer;"></i></div>
                    <div>
                    <h3 class="m-b-none m-t-smHead" id="h3Header">Customer Wise Analysis</h3>
                    <small id="lastsixmonths">Last 6 months</small>
                  </div>
                </div>
                </div>
                <div class="col-sm-6">
                  <div class="text-right text-left-xs">
                    <div class="sparkline m-l m-r-lg pull-right" data-type="bar" data-height="35" data-bar-width="6" data-bar-spacing="2" data-bar-color="#fb6b5b">5,8,9,12,8,10,8,9,7,8,6</div>
                    <div class="m-t-sm">
                      <!-- <span class="text-uc">Best NSL</span>
                      <div class="h4"><strong>90% MAY</strong></div> -->
                    </div>
                  </div>
                </div>
              </div>
            </div>
            <section class="panel panel-default">
			  <header class="panel-heading font-bold">
			    <div style="height: 30px !important;">
					Customer TAT
					<button class="btn" onclick="downloadExcel('CUST_WISE_TAT_REPORT')" title="CUSTOMER TAT EXCEL DOWNLOAD" style="margin-left: 86% !important;font-size: 23px !important;margin-top: -8px !important;"><i class="fa fa-file-excel-o"></i></button>
				</div>
              </header>
              <div class="panel-body" style="height:230px;">
                <div class="row">
                  <div class="col-lg-6">
                    <div id="customer-tat" class="hoverFloat"  style="height:200px"></div>
					          <div id="cSelectedText" class="detailsBoard multiFloat" style="display:none;"></div>
                  </div>
                  <div class="col-lg-3">
                    <div id="flot-pie-donut0"  style="height:200px"></div>
                  </div>
                  <div class="col-lg-3">
                    <div id="flot-pie-donut1"  style="height:200px"></div>
                  </div>
                </div>
              </div>
            </section>
            <section class="panel panel-default">
			   <header class="panel-heading font-bold">
			    <div style="height: 30px !important;">
					Aggressive TAT
					<button class="btn" onclick="downloadExcel('AGG_TAT_REPORT_CUST_WISE')" title="AGGRESSIVE TAT EXCEL DOWNLOAD" style="margin-left: 85% !important;font-size: 23px !important;margin-top: -8px !important;"><i class="fa fa-file-excel-o"></i></button>
				</div>
              </header>
              <div class="panel-body" style="height:230px;">
              <div class="row">
                <div class="col-lg-6">
                  <div id="aggressive-tat" class="hoverFloatAgg"  style="height:200px"></div>
				          <div id="aSelectedText" class="detailsBoard multiFloatAgg" style="display:none;"></div>
				        </div>
                <div class="col-lg-3">
                  <div id="flot-pie-donut2"  style="height:200px"></div>
                </div>
                <div class="col-lg-3">
                  <div id="flot-pie-donut3"  style="height:200px"></div>
                </div>
              </div>
              </div>
            </section>
            <section class="panel panel-default">
			  <header class="panel-heading font-bold">
			    <div style="height: 30px !important;">
					Delay Reasons
					<button class="btn" onclick="downloadExcel('DELAY_REASON_OTP_OTD_REPORT')" title="DELAY REASON TAT EXCEL DOWNLOAD" style="margin-left: 85% !important;font-size: 23px !important;margin-top: -8px !important;"><i class="fa fa-file-excel-o"></i></button>
				</div>
              </header>
              <div class="panel-body">
                <div class="row" id="donutRow">
                    <div class="col-lg-6">
                      <div id="flot-pie-donut4"  style="height:200px"></div>
					           </div>
          					<div class="col-lg-6">
          					  <div id="flot-pie-donut5"  style="height:200px"></div>
          					</div>
                </div>
              </div>
            </section>
            <section class="panel panel-default">
			    <header class="panel-heading font-bold">
			    <div style="height: 30px !important;">
					Delay Reasons
					<button class="btn" onclick="downloadExcel('DELAY_REASON_REPORT')" title="DELAY REASON TAT EXCEL DOWNLOAD" style="margin-left: 85% !important;font-size: 24px !important;margin-top: -8px !important;"><i class="fa fa-file-excel-o"></i></button>
				</div>
              </header>
              <div class="panel-body" style="height:550px;">
                <div class="row">
                  <div class="col-lg-12">
                    <div id="delayReasonsBar" class="hoverFloat" style="height: 500px;" ></div>
                  </div>
                </div>
              </div>
            </section>
          </section>
        </section>
      </section>
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
let url = '<%= t4uspringappURL %>';
let font = " 11px sans-serif";
let dividebythree = 2.5;

function validate(){
	let valid = true;
	if($("#customerName").val().length === 0){sweetAlert("Please select a customer"); valid = false;}
	else{if($("#routeName").val().length === 0){sweetAlert("Please select a route"); valid = false;}}
	return valid;
}

function showAnalysis(){
	let isValid = validate();
	if(!isValid){return false;}
     errorList = "";
     let noData = "";
	 let noDataCntr = 0;
	 donutId = 0;
	 plots = [];
		donutMonths = [];
	$("#loading-div").show();
	let customerVal = $("#customerName").val().length=== custLength ? "0" : $("#customerName").val();
	 let routeVal =  $("#routeName").val().length === routeLength ? "all" : $("#routeName").val();

//	$.ajax({
//	 url: url+"customerwiseanalysis/"+formatDate($("#startDate").val())+" 00:00:00/"+formatDate($("#endDate").val())+" 23:59:59/"+ customerVal + "/" + routeVal
//   }).done(function(json) {
    $.ajax({
      url: url + '/customerwiseanalysis',
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
	  noData += (json.code === 209) ? "No Records for Customer TAT\n": "" ;
	  json = json.responseBody;
	  console.log("json " , json);
	  let labels = [];
	  let selectedText = [];
	  $("#customerName option:selected").each(function() {
        selectedText.push(this.text);
	  });
	  $('#cSelectedText').html(selectedText.join(", "));
	  $('#aSelectedText').html(selectedText.join(", "));

	  labels.push({label: $("#customerName").val().length=== custNewLength ? "All" : $("#customerName").val().length === 1 ? $("#customerName option:selected").text(): "Multiple Customers"});

	 let yellow = "#FFCC00";
		let red = "#D40511";
		let green = "#7DCB51";
		 let dataGSL = [];
	  let dataNSL=[];
	  let dataAggNSL=[];
		let dataAggGSL=[];


		let donutChartData = [];


		json.forEach(function (item) {



			let da = [
			{
				   label: "On Time",
				   data: item.tripStatusOnTime
			   }, {
				   label: "Delayed",
				   data: item.tripStatusDelayed
			   }];

			 let plot = $("#flot-pie-donut"+donutId).length && $.plot($("#flot-pie-donut"+donutId), da, {
			  series: {
				pie: {
				  innerRadius: innerRadius,
				  show: true,
				  label:{show:false}
				}
			  },
			  legend:{show:true},

			  colors: tripStatus,
			  grid: {
				  hoverable: true,
				  clickable: false
			  },
			  tooltip: true,
			  tooltipOpts: {
				   cssClass: "flotTip",
				content: "%s: %p.0%"
			  }
			});
			 plots.push(plot);
			 donutMonths.push("Trip Status");
			 let c = plot.getCanvas();
			let canvas=c.getContext("2d");
			let cx = c.width / dividebythree;
			topPosTitle = c.height / 2.0;
			let text=donutMonths[donutId];
			canvas.font=font;
			canvas.textAlign = 'center';
			canvas.fillText(text,cx,topPosTitle);
			donutId++;

			da = [{
			   label: "No Delay",
			   data: item.noDelayBrackets
			   }, {
				   label: "Less Than 1 Hour",
				   data: item.lessThan1HRDelayBrackets
			   }, {
				   label: "One to Two Hours ",
				   data: item.oneToTwoHRSDelayBrackets
			   }, {
				   label: "Two to Three Hours",
				   data: item.twoToThreeHRSDelayBrackets
			   }, {
				   label: "Three to Four Hours",
				   data: item.threeToFourHRSDelayBrackets
			   }, {
				   label: "Greater than Four Hours",
				   data: item.greaterThanFourHRSDelayBrackets
			   }];




              plot = $("#flot-pie-donut"+donutId).length && $.plot($("#flot-pie-donut"+donutId), da, {
			  series: {
				pie: {
				  innerRadius: innerRadius,
				  show: true,
				  label:{show:false}
				}
			  },
			  legend:{show:false},

			  colors: delayBracketsColors,
			  grid: {
				  hoverable: true,
				  clickable: false
			  },
			  tooltip: true,
			  tooltipOpts: {
				   cssClass: "flotTip",
				content: "%s: %p.0%"
			  }
			});
			plots.push(plot);
			donutMonths.push("Delay Brackets");

			c = plot.getCanvas();
			canvas=c.getContext("2d");
			cx = c.width / 2.0;
			topPosTitle = c.height / 2.0;
			text=donutMonths[donutId];
			canvas.font=font;
			canvas.textAlign = 'center';
			canvas.fillText(text,cx,topPosTitle);

			donutId++;


			da = [
			{
				   label: "On Time",
				   data: item.tripStatusOnTimeAT
			   }, {
				   label: "Delayed",
				   data: item.tripStatusDelayedAT
			   }];
			plot = $("#flot-pie-donut"+donutId).length && $.plot($("#flot-pie-donut"+donutId), da, {
			  series: {
				pie: {
				  innerRadius: innerRadius,
				  show: true,
				  label:{show:false}
				}
			  },
			  legend:{show:true},

			  colors: tripStatus,
			  grid: {
				  hoverable: true,
				  clickable: false
			  },
			  tooltip: true,
			  tooltipOpts: {
				   cssClass: "flotTip",
				content: "%s: %p.0%"
			  }
			});
			 plots.push(plot);
			 donutMonths.push("Trip Status");
			  c = plot.getCanvas();
			 canvas=c.getContext("2d");
			 cx = c.width / dividebythree;
			topPosTitle = c.height / 2.0;
			 text=donutMonths[donutId];
			canvas.font=font;
			canvas.textAlign = 'center';
			canvas.fillText(text,cx,topPosTitle);
			donutId++;

			 da = [{
			   label: "No Delay",
			   data: item.noDelayBracketsAT
			   }, {
				   label: "Less Than 1 Hour",
				   data: item.lessThan1HRDelayBracketsAT
			   }, {
				   label: "One to Two Hours ",
				   data: item.oneToTwoHRSDelayBracketsAT
			   }, {
				   label: "Two to Three Hours",
				   data: item.twoToThreeHRSDelayBracketsAT
			   }, {
				   label: "Three to Four Hours",
				   data: item.threeToFourHRSDelayBracketsAT
			   }, {
				   label: "Greater than Four Hours",
				   data: item.greaterThanFourHRSDelayBracketsAT
			   }];


              plot = $("#flot-pie-donut"+donutId).length && $.plot($("#flot-pie-donut"+donutId), da, {
			  series: {
				pie: {
				  innerRadius: innerRadius,
				  show: true,
				  label:{show:false}
				}
			  },
			  legend:{show:false},

			  colors: delayBracketsColors,
			  grid: {
				  hoverable: true,
				  clickable: false
			  },
			  tooltip: true,
			  tooltipOpts: {
				   cssClass: "flotTip",
				content: "%s: %p.0%"
			  }
			});
			plots.push(plot);
			donutMonths.push("Delay Brackets");

			c = plot.getCanvas();
			canvas=c.getContext("2d");
			cx = c.width / 2.0;
			topPosTitle = c.height / 2.0;
			text=donutMonths[donutId];
			canvas.font=font;
			canvas.textAlign = 'center';
			canvas.fillText(text,cx,topPosTitle);

			donutId++;


			da = [
			{
				   label: "OTP",
				   data: item.otpStatus
			   }, {
				   label: "Delayed Placement",
				   data: item.delayedPlacement
			   }];
			plot = $("#flot-pie-donut"+donutId).length && $.plot($("#flot-pie-donut"+donutId), da, {
			  series: {
				pie: {
				  innerRadius: innerRadius,
				  show: true,
				  label:{show:false}
				}
			  },
			  legend:{show:true},

			  colors: otpDelay,
			  grid: {
				  hoverable: true,
				  clickable: false
			  },
			  tooltip: true,
			  tooltipOpts: {
				   cssClass: "flotTip",
				content: "%s: %p.0%"
			  }
			});
			plots.push(plot);
			donutMonths.push("OTP Delay");
			c = plot.getCanvas();
			canvas=c.getContext("2d");
			cx = c.width / dividebythree;
			topPosTitle = c.height / 2.0;
			text=donutMonths[donutId];
			canvas.font=font;
			canvas.textAlign = 'center';
			canvas.fillText(text,cx,topPosTitle);
			donutId++;

			 da = [
			{
				   label: "OTD",
				   data: item.otdStatus
			   }, {
				   label: "Delayed Departure",
				   data: item.delayedDeparture
			   }];

              plot = $("#flot-pie-donut"+donutId).length && $.plot($("#flot-pie-donut"+donutId), da, {
			  series: {
				pie: {
				  innerRadius: innerRadius,
				  show: true,
				  label:{show:false}
				}
			  },
			  legend:{show:true},

			  colors: otdDelay,
			  grid: {
				  hoverable: true,
				  clickable: false
			  },
			  tooltip: true,
			  tooltipOpts: {
				   cssClass: "flotTip",
				content: "%s: %p.0%"
			  }
			});
			plots.push(plot);
			donutMonths.push("OTD Delay");

			c = plot.getCanvas();
			canvas=c.getContext("2d");
			cx = c.width / dividebythree;
			topPosTitle = c.height / 2.0;
			text=donutMonths[donutId];
			canvas.font=font;
			canvas.textAlign = 'center';
			canvas.fillText(text,cx,topPosTitle);

			donutId++;

			//$.ajax({
			//	 url: url+"customerwiseanalysisdelayreason/"+formatDate($("#startDate").val())+" 00:00:00/"+formatDate($("#endDate").val())+" 23:59:59/"+ $("#customerName").val() + "/" + $("#routeName").val()
			//   }).done(function(jsonDelay) {
			  $.ajax({
    			 url: url + '/customerwiseanalysisdelayreason',
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
   				success: function (jsonDelay) { 
				  
		     	let dataDelay = [];
		
			    jsonDelay = jsonDelay.responseBody;
				    let trenColorCount = 0;				
				 	jsonDelay.forEach(function(item) {
						if(item.delayReason != "TOTAL_DELAY" && item.delayReason != "UNKNOWN" && item.description!="TO_BE_DETERMINED"  && item.description!="TOTAL DELAY MINS" && item.description!="TO BE DETERMINED"){
							if(trenColorCount < 10)
							{
								dataDelay.push({
									value: item.percentage,
									label: item.description,
									color: trendColors[trenColorCount],
									displayValue: item.percentage.toFixed(2) + "%"
								});
								trenColorCount++;
							}
						}
					})
					
      			    $("#delayReasonsBar").insertFusionCharts({
			  			type: "bar2d",
			  			width: "100%",
			  			height: "100%",
			  			dataFormat: "json",
			  			dataSource: {
						 chart: {
				  			caption: "",
				  			yaxisname: "",
				  			aligncaptionwithcanvas: "0",
				  			plottooltext: "<b>$dataValue</b> %",
				  			theme: "fusion",
			   				showValues: "1",
			   				rotateValues: "0"
						},
						data: dataDelay
			  		  }
				   });
				}
			  });
			//);
			errorList += item.gsl == "NaN" ? "No Data for Customer TAT GSL\n" : "";
			errorList += item.nsl == "NaN" ? "No Data for Customer TAT NSL\n" : "";
			dataGSL.push({
					  value: item.gsl,
					  color: item.gsl > 90 ? green : (item.gsl >= 80 && item.gsl <= 90) ? yellow : red,
					  displayValue: item.gsl.toFixed(2) + "%"
					});
			dataNSL.push({
					  value: item.nsl,
					  color: item.nsl > 90 ? green : (item.nsl >= 80 && item.nsl <= 90) ? yellow : red,
					  displayValue: item.nsl.toFixed(2) + "%"
					});
			errorList += item.aggTatGsl == "NaN" ? "No Data for Aggressive TAT GSL\n" : "";
			errorList += item.aggTatNsl == "NaN" ? "No Data for Aggressive TAT NSL\n" : "";
			//console.log("item.aggTatGsl " , item.aggTatGsl);
			//console.log("item.aggTatNsl.toFixed(2) " , item.aggTatNsl.toFixed(2));
			if(item.aggTatGsl === "NaN") {
				dataAggGSL.push({
					  value: item.aggTatGsl,
					  color: item.aggTatGsl > 90 ? green : (item.aggTatGsl >= 80 && item.aggTatGsl <= 90) ? yellow : red,
					  displayValue: 0
					});
			}
			else {
				dataAggGSL.push({
					  value: item.aggTatGsl,
					  color: item.aggTatGsl > 90 ? green : (item.aggTatGsl >= 80 && item.aggTatGsl <= 90) ? yellow : red,
					  displayValue: item.aggTatGsl.toFixed(2) + "%"
					});
			}
			if(item.aggTatNsl === "NaN") {
				    dataAggNSL.push({	
					  value: item.aggTatNsl,
					  color: item.aggTatNsl > 90 ? green : (item.aggTatNsl >= 80 && item.aggTatNsl <= 90) ? yellow : red,
					  displayValue: 0
					});
			}else {
					dataAggNSL.push({	
					  value: item.aggTatNsl,
					  color: item.aggTatNsl > 90 ? green : (item.aggTatNsl >= 80 && item.aggTatNsl <= 90) ? yellow : red,
					  displayValue: item.aggTatNsl.toFixed(2) + "%"
					});
			}		

		});


     $("#customer-tat").insertFusionCharts({
           type: "mscolumn2d",
           width: "100%",
           height: "200",
           dataFormat: "json",
           dataSource: {
           chart: {
			   xaxisname: "",
			   yaxisname: "",
			   yAxisMaxValue: "100",
			   yAxisMinValue: "0",
			   divLineColor: "#6699cc",
			   divLineAlpha: "60",
			   divLineDashed: "0",
			   formatnumberscale: "1",
			   showPlotBorder: "1",
			   plotbordercolor: "#ffffff",
			   plottooltext:
			   "<b>$seriesName</b>: <b>$dataValue</b>",
			   dataEmptyMessage: "No Records Found",
			   theme: "fusion",
			   showLegend: "0",
			   drawcrossline: "1",
			   showValues: "1",
			   rotateValues: "0"
           },
           categories: [
           {
           category: labels
           }
           ],
           dataset: [
           {
           seriesname: "GSL",
           data: dataGSL
           },
           {
           seriesname: "NSL",
           data: dataNSL
           }

           ]
           }

           });
		   $("#aggressive-tat").insertFusionCharts({
                 type: "mscolumn2d",
                 width: "100%",
                 height: "200",
                 dataFormat: "json",
                 dataSource: {
                 chart: {
                 xaxisname: "",
                 yaxisname: "",
				 yAxisMaxValue: "100",
			     yAxisMinValue: "0",
				 divLineColor: "#6699cc",
				 divLineAlpha: "60",
				 divLineDashed: "0",
				 showPlotBorder: "1",
			     plotbordercolor: "#ffffff",
                 formatnumberscale: "1",
                 plottooltext:
                 "<b>$seriesName</b>: <b>$dataValue</b>",
                 theme: "fusion",
                 showLegend: "0",
                 drawcrossline: "1",
			   showValues: "1",
			   rotateValues: "0"
                 },
                 categories: [
                 {
                   category: labels
                 }
                 ],
                 dataset: [
                 {
                   seriesname: "GSL",
					data: dataAggGSL
				 },
				 {
					seriesname: "NSL",
					data: dataAggNSL
				 }

                 ]
                 }
                 });

			errorList != "" ? sweetAlert(errorList): "";

         }
         //);
});
}

$("#angleArrow").on("click", function(){
  if($("#nav").width() === 219)
  { $("#nav").width(0);$("#secTop").hide(500);$("#contentChild").width($(window).width()-32);}else{$("#nav").width(219);$("#secTop").show(500);$("#contentChild").width($("#content").width()-220)}
  setTimeout( function(){hideLegend()},1100);
})

function hideLegend(){
    for(let b=0; b < donutId;b++)
	{
		let c = plots[b].getCanvas();
		let canvas=c.getContext("2d");
		let cx = c.width / dividebythree;
		if(b == 1 || b== 3)
		{
			cx = c.width / 2;
		}		
		topPosTitle = c.height / 2.0;
		let text=donutMonths[b];
		canvas.font=font;
		canvas.textAlign = 'center';
		canvas.fillText(text,cx,topPosTitle);
	}

}


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
					 custNewLength = $("#customerName").val().length;
				 
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


<jsp:include page="../Common/footer.jsp" />
