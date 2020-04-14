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
              <!-- nav -->
           <!--   <nav class="nav-primary hidden-xs" style="margin-top:56px;>     -->
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
                        <button type="submit" class="btn btn-primary" onclick="$('#h3Header').removeClass('m-t-smHead');$('#lastsixmonths').hide();showAnalysis()" style="background:#46A4EC !important;cursor:pointer;">Show Analysis</button>
                      </div>
                    </div>


       <!--        </nav>  -->
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
                <div class="col-sm-6">
                  <div style="display:flex">
                    <div><i class="fa fa-2x fa-bars" id="angleArrow" style="margin-top:20px;margin-right:16px;cursor:pointer;"></i></div>
                    <div>
                    <h3 class="m-b-none m-t-smHead" id="h3Header">Overall Trends</h3>
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
              <footer class="panel-footer bg-white">
                <div class="row text-center no-gutter">
                  <div class="col-xs-2 b-r b-light">
                    <p class="h3 font-bold m-t" id="totalNsl"><i class="fa fa-spinner fa-spin"></i></p>
                    <p class="text-muted">NSL (%)</p>
                  </div>
                  <div class="col-xs-2 b-r b-light">
                    <p class="h3 font-bold m-t"  id="totalGsl"><i class="fa fa-spinner fa-spin"></i></p>
                    <p class="text-muted">GSL (%)</p>
                  </div>
                  <div class="col-xs-2 b-r b-light">
                    <p class="h3 font-bold m-t"  id="totalFailures"><i class="fa fa-spinner fa-spin"></i></p>
                    <p class="text-muted">DHL Failure (%)</p>
                  </div>
                  <div class="col-xs-3 b-r b-light">
                    <p class="h3 font-bold m-t"  id="totalLD"><i class="fa fa-spinner fa-spin"></i></p>
                    <p class="text-muted">Loading Detention (%)</p>
                  </div>
				  <div class="col-xs-3">
                    <p class="h3 font-bold m-t"  id="totalULD"><i class="fa fa-spinner fa-spin"></i></p>
                    <p class="text-muted">Unloading Detention (%)</p>
                  </div>
                </div>
              </footer>
           
                  <header class="panel-heading font-bold">
			    	<div style="height: 30px !important;">
						Customer TAT
						<button class="btn" onclick="downloadExcel('CUST_TAT_REPORT')" title="CUSTOMER TAT EXCEL DOWNLOAD"  style="margin-left: 86% !important;font-size: 24px !important;margin-top: -8px !important;"><i class="fa fa-file-excel-o"></i></button>
					</div>
              	  </header>
              <div class="panel-body" style="height:230px;">
                <div id="customer-tat"  style="height:150px"></div>
              </div>
            </section>
            <section class="panel panel-default">
               <header class="panel-heading font-bold">
			    	<div style="height: 30px !important;">
						Aggressive TAT
						<button class="btn" onclick="downloadExcel('AGG_TAT_REPORT')" title="AGGRESSIVE TAT EXCEL DOWNLOAD"  style="margin-left: 85% !important;font-size: 24px !important;margin-top: -8px !important;"><i class="fa fa-file-excel-o"></i></button>
					</div>
              	  </header>
              <div class="panel-body" style="height:230px;">
                <div id="aggressive-tat"  style="height:150px"></div>
              </div>
            </section>
            <section class="panel panel-default">
               <header class="panel-heading font-bold">
			    	<div style="height: 30px !important;">
						Delay Attribution
						<button class="btn" onclick="downloadExcel('DELAY_ATTR_REPORT')" title="DELAY ATTRIBUTION EXCEL DOWNLOAD" style="margin-left: 84% !important;font-size: 24px !important;margin-top: -8px !important;"><i class="fa fa-file-excel-o"></i></button>
					</div>
              	  </header>
              <div class="panel-body">
                <div class="row" id="donutRow">
                  
				  
                </div>
				<div class="row">
                     <div class="col-lg-12" style="display:flex;justify-content:center">
                         <div class="legendColorBox" style="height: 14px;margin-top: 2px;margin-right: 4px;border:1px solid #ccc;padding:1px">
                           <div style="width:4px;height:0;border:5px solid rgb(192,202,51);overflow:hidden"></div>
                         </div>
                         <div class="legendLabel">DHL Failure</div>
                       <div class="legendColorBox" style="height: 14px;margin-top: 2px;margin-right: 4px;margin-left:16px;border:1px solid #ccc;padding:1px">
                         <div style="width:4px;height:0;border:5px solid rgb(59,0,237);overflow:hidden"></div></div>
                       <div class="legendLabel">Force Majeure</div>
                       <div class="legendColorBox" style="height: 14px;margin-top: 2px;margin-right: 4px;margin-left:16px;border:1px solid #ccc;padding:1px">
                         <div style="width:4px;height:0;border:5px solid rgb(156,39,176);overflow:hidden"></div></div>
                       <div class="legendLabel">TBD</div>
                       <div class="legendColorBox" style="height: 14px;margin-top: 2px;margin-right: 4px;margin-left:16px;border:1px solid #ccc;padding:1px">
                         <div style="width:4px;height:0;border:5px solid rgb(216,27,96);overflow:hidden"></div></div>
                       <div class="legendLabel">On Time</div>
                       <div class="legendColorBox" style="height: 14px;margin-top: 2px;margin-right: 4px;margin-left:16px;border:1px solid #ccc;padding:1px">
                         <div style="width:4px;height:0;border:5px solid rgb(255,152,0);overflow:hidden"></div>
                       </div>
                       <div class="legendLabel">Customer Delay</div>
                     </div>
                  </div>
              </div>
            </section>

            <div class="row">
              <div class="col-md-12">
                <section class="panel panel-default">
                  <header class="panel-heading font-bold">
			    	<div style="height: 30px !important;">
						Month-wise Trend
						<button class="btn" onclick="downloadExcel('MONTH_WISE_TREND_REPORT')" title="MONTH WISE TREND EXCEL DOWNLOAD" style="margin-left: 83% !important;font-size: 24px !important;margin-top: -8px !important;"><i class="fa fa-file-excel-o"></i></button>
					</div>
              	  </header>
                  <div class="panel-body" style="height:320px;">
                    <div id="flot-chart"  style="height:240px"></div>
                  </div>
                </section>
              </div>
            </div>




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
<!--<script src="js/analytics.js"></script>-->
<script src="js/delayAnalytics.js"></script>
<script>
let url = '<%= t4uspringappURL %>';
let font = " 11px sans-serif";

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
         valid = false;let
   } else {
	  if($("#productName").val().length === 0) {
         sweetAlert("Please Select a Product");
         valid = false;
	  }
   }
   return valid;
}


function showAnalysis(){ 
    let isValid = validate();
	if(!isValid){return false;}
	$("#loading-div").show();
     let noData = "";
	 let noDataCntr = 0; 
	 
	 let customerVal = $("#customerName").val().length=== custLength ? "0" : $("#customerName").val();
	 let routeVal =  $("#routeName").val().length === routeLength ? "all" : $("#routeName").val();
	 //console.log(url+"overalltrend/"+formatDate($("#startDate").val())+" 00:00:00/"+formatDate($("#endDate").val())+" 23:59:59/"+ customerVal + "/" + routeVal);
//	$.ajax({
//	 url: url+"overalltrend/"+formatDate($("#startDate").val())+" 00:00:00/"+formatDate($("#endDate").val())+" 23:59:59/"+ customerVal + "/" + routeVal
//   }).done(function(json) { 
   $.ajax({
      url: url + '/overalltrend',
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
	  let tempJSON = json.responseBody;
	  let formedData = [];
	  tempJSON.forEach(function (item) {
			if(item.name === "gsl")
			{
				item.percentageCount.forEach(function (it) {
					let data= {};
					data.month=it.monthAtet;
					data.gsl=0;
					data.nsl=0;
					data.aggTatGsl=0;
					data.aggTatNsl=0;
					data.dhlFailure=0;
					//data.forceMajuere=0;
					data.forceMajeure=0;
					data.customerDelay=0;
					data.tbd=0;
					data.onTime=0;
					data.loadingDetention=0;
					data.unloadingDetention=0;
					data.otpStatus=0;
					data.otdStatus=0;
					data.year = it.yearAtet;
					formedData.push(data);
				})
			}
		})
		
		tempJSON.forEach(function (item) {
			if(item.name === "gsl")
			{
				item.percentageCount.forEach(function (it) {
					formedData.forEach(function(d){ 
						if(d.month === it.monthAtet)
						{
							d.gsl = it.percentage
						}
					})
				})
			}
			if(item.name === "nsl")
			{
				item.percentageCount.forEach(function (it) {
					formedData.forEach(function(d){ 
						if(d.month === it.monthAtet)
						{
							d.nsl = it.percentage
						}
					})
				})
			}
			if(item.name === "aggTatGsl")
			{
				item.percentageCount.forEach(function (it) {
					formedData.forEach(function(d){ 
						if(d.month === it.monthAtet)
						{
							d.aggTatGsl = it.percentage
						}
					})
				})
			}
			if(item.name === "aggTatNsl")
			{
				item.percentageCount.forEach(function (it) {
					formedData.forEach(function(d){ 
						if(d.month === it.monthAtet)
						{
							d.aggTatNsl = it.percentage
						}
					})
				})
			}
			if(item.name === "dhlFailure")
			{
				item.percentageCount.forEach(function (it) {
					formedData.forEach(function(d){ 
						if(d.month === it.monthAtet)
						{
							d.dhlFailure = it.percentage
						}
					})
				})
			}
			if(item.name === "forceMajeure")
			{
				item.percentageCount.forEach(function (it) {
					formedData.forEach(function(d){ 
						if(d.month === it.monthAtet)
						{
							d.forceMajeure = it.percentage
						}
					})
				})
			}
			if(item.name === "customerDelay")
			{
				item.percentageCount.forEach(function (it) {
					formedData.forEach(function(d){ 
						if(d.month === it.monthAtet)
						{
							d.customerDelay = it.percentage
						}
					})
				})
			}
			if(item.name === "tbd")
			{
				item.percentageCount.forEach(function (it) {
					formedData.forEach(function(d){ 
						if(d.month === it.monthAtet)
						{
							d.tbd = it.percentage
						}
					})
				})
			}
			if(item.name === "onTime")
			{
				item.percentageCount.forEach(function (it) {
					formedData.forEach(function(d){ 
						if(d.month === it.monthAtet)
						{
							d.onTime = it.percentage
						}
					})
				})
			}
			if(item.name === "loadingDetention")
			{
				item.percentageCount.forEach(function (it) {
					formedData.forEach(function(d){ 
						if(d.month === it.monthAtet)
						{
							d.loadingDetention = it.percentage
						}
					})
				})
			}
			if(item.name === "unloadingDetention")
			{
				item.percentageCount.forEach(function (it) {
					formedData.forEach(function(d){ 
						if(d.month === it.monthAtet)
						{
							d.unloadingDetention = it.percentage
						}
					})
				})
			}
			if(item.name === "otpStatus")
			{
				item.percentageCount.forEach(function (it) {
					formedData.forEach(function(d){ 
						if(d.month === it.monthAtet)
						{
							d.otpStatus = it.percentage
						}
					})
				})
			}
			if(item.name === "otdStatus")
			{
				item.percentageCount.forEach(function (it) {
					formedData.forEach(function(d){ 
						if(d.month === it.monthAtet)
						{
							d.otdStatus = it.percentage
						}
					})
				})
			}
		})
		
		console.log("Formed Dta", formedData);
	
	  
	  json = formedData;
	  
	  
	  let labels = [];
		let dataGSL = [];
		let dataNSL=[];
		let yellow = "#FFCC00";
		let red = "#D40511";
		let green = "#7DCB51";
		let dataAggNSL=[];
		let dataAggGSL=[];
		let dataLoadingDetention = [];
		let dataUnLoadingDetention = [];
		let dataOTD = [];
		let dataOTP = [];
		let averageGsl = 0;
		let averageNsl = 0;
		let averageLD = 0;
		let averageULD = 0;
		let averageFailure = 0;
		let donutChartData = [];
		
		$("#donutRow").html("");
		
		json.forEach(function (item) {
			labels.push({label:monthNames[item.month -1] + " " + item.year.toString().substring(2,4)});
			averageGsl += item.gsl;
			averageNsl += item.nsl;
			averageLD += item.loadingDetention;
			averageULD += item.unloadingDetention;
			averageFailure += item.dhlFailure;
			
			let da = [{
			   label: "DHL Failure",
			   data: item.dhlFailure
			   }, {
				   label: "Force Majeure",
				   data: item.forceMajeure//forceMajuere
			   }, {
				   label: "TBD",
				   data: item.tbd
			   }, {
				   label: "On Time",
				   data: item.onTime
			   }, {
				   label: "Customer Delay",
				   data: item.customerDelay
			   }];
			
			donutChartData.push(da);
			  $("#donutRow").append('<div class="col-md-2"><div id="flot-pie-donut'+donutId+'"  style="height:200px"></div></div>');
                 
             let plot = $("#flot-pie-donut"+donutId).length && $.plot($("#flot-pie-donut"+donutId), da, {
			  series: {
				pie: {
				  innerRadius: innerRadius,
				  show: true,
				  label:{show:false}
				}
			  },
			  legend:{show:false},
			  
			  colors: donutColors,
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
			donutMonths.push(monthNames[item.month - 1]);
			
			let c = plot.getCanvas();
			let canvas=c.getContext("2d");
			let cx = c.width / 2.0;
			topPosTitle = c.height / 2.0;
			let text=monthNames[item.month - 1] + " " + item.year.toString().substring(2,4);
			canvas.font=font;
			canvas.textAlign = 'center';
			canvas.fillText(text,cx,topPosTitle);
			
			donutId++;
			
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
			dataAggGSL.push({
					  value: item.aggTatGsl,
					  color: item.aggTatGsl > 90 ? green : (item.aggTatGsl >= 80 && item.aggTatGsl <= 90) ? yellow : red,
					  displayValue: item.aggTatGsl.toFixed(2) + "%"
					});
			dataAggNSL.push({
					  value: item.aggTatNsl,
					  color: item.aggTatNsl > 90 ? green : (item.aggTatNsl >= 80 && item.aggTatNsl <= 90) ? yellow : red,
					  displayValue: item.aggTatNsl.toFixed(2) + "%"
					});
			dataLoadingDetention.push({
				  value: item.loadingDetention
			});
			dataUnLoadingDetention.push({
			  value: item.unloadingDetention
				 
			});
			dataOTD.push({
			  value: item.otdStatus
					 
			});
			dataOTP.push({
			  value: item.otpStatus
					 
			});
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
			   showValues: "1",
			   rotateValues: "0",
			   drawcrossline: "1"
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
					showValues: "1",
					rotateValues: "0",
                 drawcrossline: "1"
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
				 
		FusionCharts.ready(function() {
          var visitChart = new FusionCharts({
            type: 'msline',
            renderAt: 'flot-chart',
            width: "100%",
            height: 300,
            dataFormat: 'json',
			
            dataSource: {				
              "chart": {
                "theme": "fusion",
                "caption": "",
                "subCaption": "",
				divLineColor: "#6699cc",
				divLineAlpha: "60",
				divLineDashed: "0",
		        yAxisMaxValue: "100",
			    yAxisMinValue: "0",
                "xAxisName": "Month"
				
              },
              "categories": [{
                "category": labels
              }],
              "dataset": [{
                "seriesname": "Loading Detention",
                "data": dataLoadingDetention
              },
                {
                  "seriesname": "Unloading Detention",
                  "data": dataUnLoadingDetention
                },
                {
                  "seriesname": "OTD Trend",
                  "data": dataOTD
                },
                {
                  "seriesname": "OTP Trend",
                  "data": dataOTP
                }
              ]
            }
          }).render();
        });

		   averageGsl = averageGsl/json.length;
		   averageNsl = averageNsl/json.length;
		   averageLD = averageLD/json.length;
		   averageULD = averageULD/json.length;
		   averageFailure = averageFailure/json.length;
		  
		   
		   $("#totalFailures").html(Math.round(averageFailure));
		   let color = averageFailure > 90 ? green : (averageFailure >= 80 && averageFailure <= 90) ? yellow : red;
		   $("#totalFailures").css({color: color});
		   
		   $("#totalGsl").html(Math.round(averageGsl));
		   color = averageGsl > 90 ? green : (averageGsl >= 80 && averageGsl <= 90) ? yellow : red;
		   $("#totalGsl").css({color: color});
		   
		   $("#totalNsl").html(Math.round(averageNsl));
		   color = averageNsl > 90 ? green : (averageNsl >= 80 && averageNsl <= 90) ? yellow : red;
		   $("#totalNsl").css({color: color});
		   
		   
		   $("#totalLD").html(Math.round(averageLD));
		   color = averageLD > 90 ? green : (averageLD >= 80 && averageLD <= 90) ? yellow : red;
		   $("#totalLD").css({color: color});
		   
		    $("#totalULD").html(Math.round(averageULD));
		   color = averageULD > 90 ? green : (averageULD >= 80 && averageULD <= 90) ? yellow : red;
		   $("#totalULD").css({color: color});
		   
         }
         });
         //);
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
		let cx = c.width / 2.0;
		topPosTitle = c.height / 2.0;
		let text=donutMonths[b];
		canvas.font=font;
		canvas.textAlign = 'center';
		canvas.fillText(text,cx,topPosTitle);
	}    
    
}

function downloadExcel(type) {
    window.open("<%=request.getContextPath()%>/AnalyticsServlet?type="+type);
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
     </script>


<jsp:include page="../Common/footer.jsp" />
