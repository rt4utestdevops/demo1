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
            <div class="slim-scroll" data-height="auto" data-disable-fade-out="true" data-distance="0" data-size="5px" data-color="#333333">

              <!-- nav 
              <nav class="nav-primary hidden-xs" style="margin-top:56px;> -->
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


            <!--  </nav>
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
                    <h3 class="m-b-none m-t-smHead" id="h3Header">Route Wise Analysis</h3>
                    <small id="lastsixmonths">Last 6 months</small>
                  </div>
                </div>
                </div>
                <div class="col-sm-6">
                  <div class="text-right text-left-xs">
                    <div class="sparkline m-l m-r-lg pull-right" data-type="bar" data-height="35" data-bar-width="6" data-bar-spacing="2" data-bar-color="#fb6b5b">5,8,9,12,8,10,8,9,7,8,6</div>
                    <div class="m-t-sm">
                      
                    </div>
                  </div>
                </div>
              </div>
            </div>
			<section class="panel panel-default">
              <header class="panel-heading font-bold">
			    <div style="height: 30px !important;">
					Delay Attribution
					<button class="btn" onclick="downloadExcel('ROUTE_WISE_DELAY_ATTR_REPORT')" title="DELAY ATTRIBUTION EXCEL DOWNLOAD" style="margin-left: 84% !important;font-size: 23px !important;margin-top: -8px !important;"><i class="fa fa-file-excel-o"></i></button>
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
            <section class="panel panel-default">
			  <header class="panel-heading font-bold">
			    <div style="height: 30px !important;">
					Customer TAT
					<button class="btn" onclick="downloadExcel('ROUTE_WISE_CUST_TAT_REPORT')" title="CUSTOMER TAT EXCEL DOWNLOAD" style="margin-left: 86% !important;font-size: 23px !important;margin-top: -8px !important;"><i class="fa fa-file-excel-o"></i></button>
				</div>
              </header>
              <div class="panel-body" style="height:230px;">
                <div id="customer-tat" class="hoverFloat"  style="height:150px"></div>
			<!--	<div id="cSelectedText" class="detailsBoard multiFloat" style="display:none;"></div>  -->
              </div>
            </section>
            <section class="panel panel-default">
			 <header class="panel-heading font-bold">
			    <div style="height: 30px !important;">
					Aggressive TAT
					<button class="btn" onclick="downloadExcel('ROUTE_WISE_AGG_TAT_REPORT')" title="AGGRESSIVE TAT EXCEL DOWNLOAD" style="margin-left: 85% !important;font-size: 24px !important;margin-top: -8px !important;"><i class="fa fa-file-excel-o"></i></button>
				</div>
              </header>
              <div class="panel-body" style="height:230px;">
                <div id="aggressive-tat" class="hoverFloatAgg" style="height:150px"></div>
				<div id="aSelectedText" class="detailsBoard multiFloatAgg" style="display:none;"></div>
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

function validate(){
	let valid = true;
	if($("#customerName").val().length === 0){sweetAlert("Please select a customer"); valid = false;}
	else{if($("#routeName").val().length === 0){sweetAlert("Please select a route"); valid = false;}}
	return valid;
}

function showAnalysis(){ 
//console.log("val ", $("#regionName").val());
console.log("length ", $("#regionName").val().length);
console.log("length route ", $("#routeName").val().length);

let isValid = validate();
	if(!isValid){return false;}
errorList = "";
	$("#loading-div").show();
     let noData = "";
	 let noDataCntr = 0;
	let customerVal = $("#customerName").val().length=== custLength ? "0" : $("#customerName").val();
	 let routeVal =  $("#routeName").val().length === routeLength ? "all" : $("#routeName").val();
	 
//	$.ajax({
//	 url: url+"routewiseanalysis/"+formatDate($("#startDate").val())+" 00:00:00/"+formatDate($("#endDate").val())+" 23:59:59/"+ customerVal + "/" + routeVal
//   }).done(function(json) {
    $.ajax({
      url: url + '/routewiseanalysis',
      type: "POST",
      contentType: "application/json",
      data: JSON.stringify({
         startDate: formatDate($("#startDate").val()).toString(),
         endDate: formatDate($("#endDate").val()).toString(),
         regionName:$("#regionName").val().toString(),//'South' $("#regionName").val().length === regionNameLength || $("#regionName").val() == '' ? 'all' : $("#regionName").val().toString(),
         routeKey: $("#routeName").val().length === routeNameLength || $("#routeName").val() == '' ? 'all' : $("#routeName").val().toString(),
         hubName: $("#hubName").val().toString(),
         product:  $("#productName").val().length === prodLength || $("#productName").val() == '' ? 'all' : $("#productName").val().toString(),
         tripCustomerId: $("#customerName").val().toString(),
         routeKeySelected: $("#routeName").val().length// === routeOnchangeLength ? 'true' : 'false'
      }),
   success: function (json) { 
	 $("#loading-div").hide();
	  noData += (json.code === 209) ? "No Records for Customer TAT\n": "" ;
	  json = json.responseBody;
	  console.log("json ", json);
	   let selectedText = [];
	  $("#customerName option:selected").each(function() {
        selectedText.push(this.text);
	  });
	  $('#cSelectedText').html(selectedText.join(", "));
	  $('#aSelectedText').html(selectedText.join(", "));
	  let labels = [];
	  
		let dataGSL = [];
		let dataNSL=[];
		let yellow = "#FFCC00";
		let red = "#D40511";
		let green = "#7DCB51";
		let dataAggNSL=[];
		let dataAggGSL=[];
		
		let donutChartData = [];
		let donut = [];
		
		let labelsForCustTAT = [];
		let labelsForAggTAT = [];
		
		json.forEach(function (item) {
			if(item.name === "nsl")  //gsl
			{
				item.routeWisePercentageCounts.forEach(function (it) {
					donutMonths.push(it.routeKey || "All");
					let donutData= {};
					donutData.routeKey = it.routeKey || "All";
				    donutData.dhlFailure= 0;
					donutData.forceMajeure= 0;
					donutData.tbd= 0;
					donutData.onTime= 0;
					donutData.customerDelay= 0;
					donut.push(donutData);
				})
			}
		})
		
		json.forEach(function (item) {
			//console.log("Route Wise is", item.routeWisePercentageCounts);
			if(item.name === "gsl")
			{
			//console.log("Length ::::: ", item.routeWisePercentageCounts.length);
				item.routeWisePercentageCounts.forEach(function (it) {
					//console.log("IT", it);
					labelsForCustTAT.push({label:it.routeKey || "All"});
					dataGSL.push({
					  value: it.percentage,
					  color: it.percentage > 90 ? green : (it.percentage >= 80 && it.percentage <= 90) ? yellow : red,
					  displayValue: it.percentage.toFixed(2) + "%"
					});
				}) 
			}
			if(item.name === "nsl")
			{
				item.routeWisePercentageCounts.forEach(function (it) {
					dataNSL.push({
					  value: it.percentage,
					  color: it.percentage > 90 ? green : (it.percentage >= 80 && it.percentage <= 90) ? yellow : red,
					  displayValue: it.percentage.toFixed(2) + "%"
					});
					//console.log("Inside dataNSL");
				})
			}
			if(item.name === "aggTatGsl")
			{
				item.routeWisePercentageCounts.forEach(function (it) {
					dataAggGSL.push({
					  value: it.percentage,
					  color: it.percentage > 90 ? green : (it.percentage >= 80 && it.percentage <= 90) ? yellow : red,
					  displayValue: it.percentage.toFixed(2) + "%"
					});
				})
			}
			//console.log(" dataAggGSL :: " , dataAggGSL);
			if(item.name === "aggTatNsl")
			{
				//labels = [];
				item.routeWisePercentageCounts.forEach(function (it) {
					//labels.push({label:it.routeKey || "All"});
					dataAggNSL.push({
					  value: it.percentage,
					  color: it.percentage > 90 ? green : (it.percentage >= 80 && it.percentage <= 90) ? yellow : red,
					  displayValue: it.percentage.toFixed(2) + "%"
					});
				})
			}
			if(item.name === "dhlFailure")
			{
				item.routeWisePercentageCounts.forEach(function (it) {
					let key = it.routeKey || "All";
					donut.forEach(function(d){ 
						if(d.routeKey === key)
						{
							d.dhlFailure = it.percentage
						}
					})
				})
			}
			if(item.name === "forceMajeure")
			{
				item.routeWisePercentageCounts.forEach(function (it) {
					let key = it.routeKey || "All";
					//console.log("key ", key);
					labels.push({label:it.routeKey || "All"});
					donut.forEach(function(d){ 
						if(d.routeKey === key)
						{
							d.forceMajeure = it.percentage
						}
					})
				})
			}
			if(item.name === "onTime")
			{
				item.routeWisePercentageCounts.forEach(function (it) {
					let key = it.routeKey || "All";
					donut.forEach(function(d){ 
						if(d.routeKey === key)
						{
							d.onTime = it.percentage
						}
					})
				})
			}
			if(item.name === "tbd")
			{
				item.routeWisePercentageCounts.forEach(function (it) {
					let key = it.routeKey || "All";
					donut.forEach(function(d){ 
						if(d.routeKey === key)
						{
							d.tbd = it.percentage
						}
					})
				})
			}
			if(item.name === "customerDelay")
			{
				item.routeWisePercentageCounts.forEach(function (it) {
					let key = it.routeKey || "All";
					donut.forEach(function(d){ 
						if(d.routeKey === key)
						{
							d.customerDelay = it.percentage
						}
					})
				})
			}

		});
		$("#donutRow").html("");
		donut.forEach(function(d){ 
				let da = [{
			   label: "DHL Failure",
			   data: d.dhlFailure
			   }, {
				   label: "Force Majeure",
				   data: d.forceMajeure
			   }, {
				   label: "TBD",
				   data: d.tbd
			   }, {
				   label: "On Time",
				   data: d.onTime
			   }, {
				   label: "Customer Delay",
				   data: d.customerDelay
			   }];
			
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
			
			let c = plot.getCanvas();
			let canvas=c.getContext("2d");
			let cx = c.width / 2.0;
			topPosTitle = c.height/2.0;
			let text=donutMonths[donutId];
			canvas.font=" 11px sans-serif";
			canvas.textAlign = 'center';
			canvas.fillText(text,cx,topPosTitle);
			
			donutId++;
		})
		
//		console.log("Labels are", labels);
//		console.log("labelsForCustTAT are", labelsForCustTAT);
		$("#customer-tat").html("");

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
           category: labelsForCustTAT
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
				   showValues: "1",
				   rotateValues: "0",
			     plotbordercolor: "#ffffff",
                 formatnumberscale: "1",
                 plottooltext:
                 "<b>$seriesName</b>: <b>$dataValue</b>",
                 theme: "fusion",
                 showLegend: "0",
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
		topPosTitle = c.height/2.0;		
		let text=donutMonths[b];
		canvas.font=" 11px sans-serif";
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


<jsp:include page="../Common/footer.jsp" />
