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
 	.divClass{
    	margin-bottom: -15px !important;
    	padding-top: 16px !important;
    	margin-left: 78px !important;
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
           <section class="panel panel-default" style="height: 410px;">
			 <header class="panel-heading font-bold">BY EVENTS
              <div style="height: 1px !important;">
				<button class="btn" onclick="downloadExcel('OTP_REPORT')" title="OTP REPORT EXCEL DOWNLOAD"  style="margin-left: 42% !important;font-size: 24px !important;margin-top: -31px !important;"><i class="fa fa-file-excel-o"></i></button>
				<button class="btn" onclick="downloadExcel('SRC_DETENTION_REPORT')" title="SOURCE DETENTION REPORT EXCEL DOWNLOAD"  style="margin-left: 96% !important;font-size: 24px !important;margin-top: -38px !important;"><i class="fa fa-file-excel-o"></i></button>
			 </div>
            </header>
              <div class="panel-body" style="margin-top: -18px !important;">
               <div class="row">
				<div class="col-md-6" style="padding-top:16px;">
                      <h7><strong>OTP - IMPACT ON TRANSIT DELAY</strong></h7><br>
					  <div style="display:flex">
				       <div class="divClass">
					     <div style="height:10px;width:10px;background:#ffa600"></div>
						 <div style="margin-top: -10px !important;margin-left: 16px !important;font-size: 68% !important;">DELAYED</div>
						 <div style="height:10px;width:10px;background:#003f5c;margin-top: -14px !important;margin-left: 102px !important;"></div>
						 <div style="margin-top: -10px !important;margin-left: 118px !important;font-size: 64% !important;">ON TIME</div>
					   </div>
					  </div>
            		  <div class="panel-body" style="height:230px;display:flex;">
                		<div id="otp-status-dry"  style="height:150px"></div>
						<div id="otp-status-tcl"  style="height:150px"></div>
              		  </div>
				</div>
				<div class="col-md-6" style="padding-top:16px;">
					<h7 class="h7Pad"><strong>SOURCE DETENTION - IMPACT ON TRANSIT DELAY</strong></h7>
					<div style="display:flex">
				       <div class="divClass">
					     <div style="height:10px;width:10px;background:#ffa600"></div>
						 <div style="margin-top: -10px !important;margin-left: 16px !important;font-size: 68% !important;">DELAYED</div>
						 <div style="height:10px;width:10px;background:#003f5c;margin-top: -14px !important;margin-left: 102px !important;"></div>
						 <div style="margin-top: -10px !important;margin-left: 118px !important;font-size: 64% !important;">ON TIME</div>
					   </div>
					  </div>
					<div class="panel-body" style="height:230px;display:flex;">
                		<div id="src-detention-dry"  style="height:150px"></div>
                		<div id="src-detention-tcl"  style="height:150px"></div>
              			</div>
              		</div>
				</div>
				</div>
              </div>
            </section>
			<section class="panel panel-default" style="height: 401px;margin-left: 234px !important;margin-top: -118px !important;margin-right: 45px !important;">
			  <header class="panel-heading font-bold">
				<div style="height: 18px !important;">
					<button class="btn" onclick="downloadExcel('OTD_REPORT')" title="OTD REPORT EXCEL DOWNLOAD"  style="margin-left: 42% !important;font-size: 24px !important;margin-top: -10px !important;cursor:pointer !important;    position: relative;"><i class="fa fa-file-excel-o"></i></button> <!-- z-index: 190000000; -->
					<button class="btn" onclick="downloadExcel('SHUB_DEP_REPORT')" title="SHUB DEPARTURE REPORT EXCEL DOWNLOAD"  style="margin-left: 96% !important;font-size: 24px !important;margin-top: -39px !important;cursor:pointer !important;    position: relative;"><i class="fa fa-file-excel-o"></i></button><!-- z-index: 190000000; -->
				</div>
			  </header>            
			<div class="panel-body" style="margin-top: -18px !important;">
			
               <div class="row">
				<div class="col-md-6" style="padding-top:16px;">
                      <h7><strong>OTD - IMPACT ON TRANSIT DELAY</strong></h7><br>
					   <div style="display:flex">
				       <div class="divClass">
					     <div style="height:10px;width:10px;background:#ffa600"></div>
						 <div style="margin-top: -10px !important;margin-left: 16px !important;font-size: 68% !important;">DELAYED</div>
						 <div style="height:10px;width:10px;background:#003f5c;margin-top: -14px !important;margin-left: 102px !important;"></div>
						 <div style="margin-top: -10px !important;margin-left: 118px !important;font-size: 64% !important;">ON TIME</div>
					   </div>
					  </div>
            		  <div class="panel-body" style="height:230px;display:flex;">
                		<div id="otd-status-dry"  style="height:150px"></div>
						<div id="otd-status-tcl"  style="height:150px"></div>
              		  </div>
				</div>
				<div class="col-md-6" style="padding-top:16px;">
					<h7 class="h7Pad"><strong>SHUB DEPARTURE - IMPACT ON TRANSIT DELAY</strong></h7>
					 <div style="display:flex">
				       <div class="divClass">
					     <div style="height:10px;width:10px;background:#ffa600"></div>
						 <div style="margin-top: -10px !important;margin-left: 16px !important;font-size: 68% !important;">DELAYED</div>
						 <div style="height:10px;width:10px;background:#003f5c;margin-top: -14px !important;margin-left: 102px !important;"></div>
						 <div style="margin-top: -10px !important;margin-left: 118px !important;font-size: 64% !important;">ON TIME</div>
					   </div>
					  </div>
					<div class="panel-body" style="height:230px;display:flex;">
                		<div id="shub-departure-dry"  style="height:150px"></div>
                		<div id="shub-departure-tcl"  style="height:150px"></div>
              			</div>
              		</div>
				</div>
				</div>
              </div>
            </section>
			<section class="panel panel-default" style="height: 404px;margin-left: 234px !important;margin-right: 45px !important;">
			  <header class="panel-heading font-bold">
				<div style="height: 18px !important;">
					<button class="btn" onclick="downloadExcel('ENROUTE_CHUB_DEP_REPORT')" title="ENROUTE CHUB DEPARTURE REPORT EXCEL DOWNLOAD"  style="margin-left: 42% !important;font-size: 24px !important;margin-top: -10px !important;"><i class="fa fa-file-excel-o"></i></button>
					<button class="btn" onclick="downloadExcel('UNAUTH_REPORT')" title="UNAUTH STOPPAGE REPORT EXCEL DOWNLOAD"  style="margin-left: 96% !important;font-size: 24px !important;margin-top: -39px !important;"><i class="fa fa-file-excel-o"></i></button>
				</div>
			  </header> 
              <div class="panel-body" style="margin-top: -18px !important;">
               <div class="row">
				<div class="col-md-6" style="padding-top:16px;">
                      <h7><strong>ENROUTE CHUB DEPARTURE- IMPACT ON TRANSIT DELAY</strong></h7><br>
					   <div style="display:flex">
				       <div class="divClass">
					     <div style="height:10px;width:10px;background:#ffa600"></div>
						 <div style="margin-top: -10px !important;margin-left: 16px !important;font-size: 68% !important;">DELAYED</div>
						 <div style="height:10px;width:10px;background:#003f5c;margin-top: -14px !important;margin-left: 102px !important;"></div>
						 <div style="margin-top: -10px !important;margin-left: 118px !important;font-size: 64% !important;">ON TIME</div>
					   </div>
					  </div>
            		  <div class="panel-body" style="height:230px;display:flex;">
                		<div id="enroute-chub-departure-dry"  style="height:150px"></div>
						<div id="enroute-chub-departure-tcl"  style="height:150px"></div>
              		  </div>
				</div>
				<div class="col-md-6" style="padding-top:16px;">
					<h7 class="h7Pad"><strong>UNAUTH STOPPAGE - IMPACT ON TRANSIT DELAY</strong></h7>
					 <div style="display:flex">
				       <div class="divClass">
					     <div style="height:10px;width:10px;background:#ffa600"></div>
						 <div style="margin-top: -10px !important;margin-left: 16px !important;font-size: 68% !important;">DELAYED</div>
						 <div style="height:10px;width:10px;background:#003f5c;margin-top: -14px !important;margin-left: 102px !important;"></div>
						 <div style="margin-top: -10px !important;margin-left: 118px !important;font-size: 64% !important;">ON TIME</div>
					   </div>
					  </div>
					<div class="panel-body" style="height:230px;display:flex;">
                		<div id="unauth-stoppage-dry"  style="height:150px"></div>
                		<div id="unauth-stoppage-tcl"  style="height:150px"></div>
              			</div>
              		</div>
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

function showAnalysis(){ 
	let dateRangeValidation =  validateDate();
    if(!dateRangeValidation) {
   	  return false;
    }
    let isValid = validate();
	if(!isValid){return false;}
	$("#loading-div").show();
     let noData = "";
	 let noDataCntr = 0; 
	 let orange = "#ffa600";
		let blue = "#003f5c";
	 
	  let customerVal = $("#customerName").val();
	 let routeVal =  $("#routeName").val();
	 let productVal = $("#productName").val();
	 //console.log(" customerVal ", customerVal + " routeVal " + routeVal + ",productVal " + productVal); 
	
	$.ajax({
	 url: url + '/eventDelayAnalysis',
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
	 success: function(json) {
	  $("#loading-div").hide();
	  noData += (json.code === 200) ? "No Records for Customer TAT\n": "" ;
	  let tempJSON = json.responseBody;
	  console.log("temp json is", tempJSON);
	 
	           $("#otp-status-dry").insertFusionCharts({
						 type: "stackedcolumn2d",
						  width: "40%",
						  height: "290",
						  dataFormat: "json",
						  dataSource: {
							chart: {
							  xaxisname: "OTP STATUS",
                              yaxisname: "% OF TRIPS",			
							  caption: "",
							  subcaption: "DRY",
							  numbersuffix: "",
							  showYAxisValues:'',
							  showsum: "0",
							  baseFontSize: "11",
							  rotateLabels: "0",
							  plottooltext:
								"<b>$dataValue</b> $seriesName",
							  theme: "fusion",
							  drawcrossline: "1",
							  xAxisNameFontSize: "10",
							  xAxisNameFontBold: "1",
							  xAxisNameFontColor: "#993300",
							  labelFontSize: "8",
							  yAxisNameFontSize: "10",
							  yAxisNameFontBold: "1",
							  yAxisNameFontColor: "#993300",
							  subcaptionFontSize: "10",
							  subcaptionFontBold: "1",
							  subcaptionFontColor: "#993300"
							},
							categories: [
							  {
								category:  [
       								 {
          								label: "DELAYED"
        							 },
        						     {
          								label: "ON TIME"
        							 }]
							  }
							],
							dataset: [
							  {
								color: "#003f5c",
								data:[
        							{
          								value: tempJSON.otp.delayedOntimeDry,
        							},{
          								value: tempJSON.otp.ontimeOntimeDry,
        							}]
							  },
							  {
								color: "#ffa600",
								data:[
        							{
          								value: tempJSON.otp.delayedDelayedDry
        							},{
          								value: tempJSON.otp.ontimeDelayedDry
        							}]
							  }
							  ]
						  }
				  });
				  
			      $("#otp-status-tcl").insertFusionCharts({
						 type: "stackedcolumn2d",
						  width: "38%",
						  height: "290",
						  dataFormat: "json",
						  dataSource: {
							chart: {
							   xaxisname: "OTP STATUS",
                              yaxisname: "% OF TRIPS",	
							  caption: "",
							  subcaption: "TCL",
							  numbersuffix: "",
							  showYAxisValues:'0',
							  showsum: "0",
							  baseFontSize: "11",
							  rotateLabels: "0",
							  plottooltext:
								"<b>$dataValue</b> $seriesName",
							  theme: "fusion",
							  drawcrossline: "1",
							  xAxisNameFontSize: "10",
							  xAxisNameFontBold: "1",
							  xAxisNameFontColor: "#993300",
							  labelFontSize: "8",
							  yAxisNameFontSize: "10",
							  yAxisNameFontBold: "1",
							  yAxisNameFontColor: "#993300",
							  subcaptionFontSize: "10",
							  subcaptionFontBold: "1",
							  subcaptionFontColor: "#993300"
							},
							categories: [
							  {
								category:  [
       								 {
          								label: "DELAYED"
        							 },
        						     {
          								label: "ON TIME"
        							 }]
							  }
							],
							dataset: [
							  {
								color: "#003f5c",
								data:[
        							{
          								value: tempJSON.otp.ontimeDelayedTcl,
        							},{
          								value: tempJSON.otp.ontimeOntimeTcl
        							}]
							  },
							  {
								color: "#ffa600",
								data:[
        							{
          								value: tempJSON.otp.delayedDelayedTcl,
        							},{
          								value: tempJSON.otp.delayedOntimeTcl
        							}]
							  }
							  ]
						  }
				  });
				  
				   $("#src-detention-dry").insertFusionCharts({
						  type: "stackedcolumn2d",
						  width: "40%",
						  height: "290",
						  dataFormat: "json",
						  dataSource: {
							chart: {
							  xaxisname: "SOURCE DETENTION STATUS",
                              yaxisname: "% OF TRIPS",		
							  caption: "",
							  subcaption: "DRY",
							  numbersuffix: "",
							  showYAxisValues:'',
							  showsum: "0",
							  baseFontSize: "11",
							  rotateLabels: "0",
							  plottooltext:
								"<b>$dataValue</b> $seriesName",
							  theme: "fusion",
							  drawcrossline: "1",
							  xAxisNameFontSize: "10",
							  xAxisNameFontBold: "1",
							  xAxisNameFontColor: "#993300",
							  labelFontSize: "8",
							  yAxisNameFontSize: "10",
							  yAxisNameFontBold: "1",
							  yAxisNameFontColor: "#993300",
							  subcaptionFontSize: "9",
							  subcaptionFontBold: "1",
							  subcaptionFontColor: "#993300",
							  subcaptionFontSize: "10",
							  subcaptionFontBold: "1",
							  subcaptionFontColor: "#993300"
							},
							categories: [
							  {
								category:  [
       								 {
          								label: "AS PLANNED"
        							 },
        						     {
          								label: "EXCESS"
        							 }]
							  }
							],
							dataset: [
							  {
								color: "#003f5c",
								data:[
        							{
          								value: tempJSON.srcDetention.asPlannedOntimeDry,
        							},{
          								value: tempJSON.srcDetention.excessOntimeDry
        							}]
							  },
							  {
								color: "#ffa600",
								data:[
        							{
          								value: tempJSON.srcDetention.asPlannedDelayedDry,
        							},{
          								value: tempJSON.srcDetention.excessDelayedDry
        							}]
							  }
							  ]
						  }
				  });
				  
				  $("#src-detention-tcl").insertFusionCharts({
						  type: "stackedcolumn2d",
						  width: "35%",
						  height: "290",
						  dataFormat: "json",
						  dataSource: {
							chart: {
							  xaxisname: "SOURCE DETENTION STATUS",
                              yaxisname: "% OF TRIPS",		
							  caption: "",
							  subcaption: "TCL",
							  numbersuffix: "",
							  showYAxisValues:'0',
							  showsum: "0",
							  baseFontSize: "11",
							  rotateLabels: "0",
							  plottooltext:
								"<b>$dataValue</b> $seriesName",
							  theme: "fusion",
							  drawcrossline: "1",
							  xAxisNameFontSize: "10",
							  xAxisNameFontBold: "1",
							  xAxisNameFontColor: "#993300",
							  labelFontSize: "8",
							  yAxisNameFontSize: "10",
							  yAxisNameFontBold: "1",
							  yAxisNameFontColor: "#993300",
							  subcaptionFontSize: "10",
							  subcaptionFontBold: "1",
							  subcaptionFontColor: "#993300"
							},
							categories: [
							  {
								category:  [
       								 {
          								label: "AS PLANNED"
        							 },
        						     {
          								label: "EXCESS"
        							 }]
							  }
							],
							dataset: [
							  {
								color: "#003f5c",
								data:[
        							{
          								value: tempJSON.srcDetention.asPlannedOntimeTcl,
        							},{
          								value: tempJSON.srcDetention.excessOntimeTcl
        							}]
							  },
							  {
								color: "#ffa600",
								data:[
        							{
          								value: tempJSON.srcDetention.asPlannedDelayedTcl,
        							},{
          								value: tempJSON.srcDetention.excessDelayedTcl
        							}]
							  }
							  ]
						  }
				  });
				 $("#otd-status-dry").insertFusionCharts({
						type: "stackedcolumn2d",
						  width: "40%",
						  height: "290",
						  dataFormat: "json",
						  dataSource: {
							chart: {
							  xaxisname: "OTD STATUS",
                              yaxisname: "% OF TRIPS",			
							  caption: "",
							  subcaption: "DRY",
							  numbersuffix: "",
							  showYAxisValues:'',
							  showsum: "0",
							  baseFontSize: "11",
							  rotateLabels: "0",
							  plottooltext:
								"<b>$dataValue</b> $seriesName",
							  theme: "fusion",
							  drawcrossline: "1",
							  xAxisNameFontSize: "10",
							  xAxisNameFontBold: "1",
							  xAxisNameFontColor: "#993300",
							  labelFontSize: "8",
							  yAxisNameFontSize: "10",
							  yAxisNameFontBold: "1",
							  yAxisNameFontColor: "#993300",
							  subcaptionFontSize: "10",
							  subcaptionFontBold: "1",
							  subcaptionFontColor: "#993300"
							},
							categories: [
							  {
								category:  [
       								 {
          								label: "DELAYED"
        							 },
        						     {
          								label: "ON TIME"
        							 }]
							  }
							],
							dataset: [
							  {
								color: "#003f5c",
								data:[
        							{
          								value: tempJSON.otd.otdDelayedOntimeDry,
        							},{
          								value: tempJSON.otd.otdOntimeOntimeDry,
        							}]
							  },
							  {
								color: "#ffa600",
								data:[
        							{
          								value: tempJSON.otd.otdDelayedDelayedDry
        							},{
          								value: tempJSON.otd.otdOnTimeDelayedDry
        							}]
							  }
							  ]
						  }
				  });
				  
			      $("#otd-status-tcl").insertFusionCharts({
						  type: "stackedcolumn2d",
						  width: "38%",
						  height: "290",
						  dataFormat: "json",
						  dataSource: {
							chart: {
							   xaxisname: "OTD STATUS",
                              yaxisname: "% OF TRIPS",	
							  caption: "",
							  subcaption: "TCL",
							  numbersuffix: "",
							  showYAxisValues:'0',
							  showsum: "0",
							  baseFontSize: "11",
							  rotateLabels: "0",
							  plottooltext:
								"<b>$dataValue</b> $seriesName",
							  theme: "fusion",
							  drawcrossline: "1",
							  xAxisNameFontSize: "10",
							  xAxisNameFontBold: "1",
							  xAxisNameFontColor: "#993300",
							  labelFontSize: "8",
							  yAxisNameFontSize: "10",
							  yAxisNameFontBold: "1",
							  yAxisNameFontColor: "#993300",
							  subcaptionFontSize: "10",
							  subcaptionFontBold: "1",
							  subcaptionFontColor: "#993300"
							},
							categories: [
							  {
								category:  [
       								 {
          								label: "DELAYED"
        							 },
        						     {
          								label: "ON TIME"
        							 }]
							  }
							],
							dataset: [
							  {
								color: "#003f5c",
								data:[
        							{
          								value: tempJSON.otd.otdDelayedOntimeTcl,
        							},{
          								value: tempJSON.otd.otdOntimeOntimeTcl
        							}]
							  },
							  {
								color: "#ffa600",
								data:[
        							{
          								value: tempJSON.otd.otdDelayedDelayedTcl,
        							},{
          								value: tempJSON.otd.otdOnTimeDelayedTcl
        							}]
							  }
							  ]
						  }
				  });
				  
				 $("#shub-departure-dry").insertFusionCharts({
						  type: "stackedcolumn2d",
						  width: "39%",
						  height: "300",
						  dataFormat: "json",
						  dataSource: {
							chart: {
							  xaxisname: "SHUB DEPARTURE STATUS",
                              yaxisname: "% OF TRIPS",		
							  caption: "",
							  subcaption: "DRY",
							  numbersuffix: "",
							  showsum: "0",
							  baseFontSize: "11",
							  rotateLabels: "0",
							  plottooltext:
								"<b>$dataValue</b> $seriesName",
							  theme: "fusion",
							  drawcrossline: "1",
							   xAxisNameFontSize: "10",
							  xAxisNameFontBold: "1",
							  xAxisNameFontColor: "#993300",
							  labelFontSize: "8",
							  yAxisNameFontSize: "10",
							  yAxisNameFontBold: "1",
							  yAxisNameFontColor: "#993300",
							  subcaptionFontSize: "10",
							  subcaptionFontBold: "1",
							  subcaptionFontColor: "#993300"
							},
							categories: [
							  {
								category:  [
       								 {
          								label: "DELAYED"
        							 },
        						     {
          								label: "ON TIME"
        							 }]
							  }
							],
							dataset: [
							  {
								color: "#003f5c",
								data:[
        							{
          								value: tempJSON.shubDeparture.shubDepDelayedOntimeDry,
        							},{
          								value: tempJSON.shubDeparture.shubDepOntimeOntimeDry,
        							}]
							  },
							  {
								color: "#ffa600",
								data:[
        							{
          								value: tempJSON.shubDeparture.shubDepDelayedDelayedDry
        							},{
          								value: tempJSON.shubDeparture.shubDepOnTimeDelayedDry
        							}]
							  }
							  ]
						  }
				  });
				  
			      $("#shub-departure-tcl").insertFusionCharts({
						  type: "stackedcolumn2d",
						  width: "39%",
						  height: "300",
						  dataFormat: "json",
						  dataSource: {
							chart: {
							  xaxisname: "SHUB DEPARTURE STATUS",
                              yaxisname: "% OF TRIPS",		
							  caption: "",
							  subcaption: "TCL",
							  numbersuffix: "",
							  showYAxisValues:'0',
							  showsum: "0",
							  baseFontSize: "11",
							  rotateLabels: "0",
							  plottooltext:
								"<b>$dataValue</b> $seriesName",
							  theme: "fusion",
							  drawcrossline: "1",
							   xAxisNameFontSize: "10",
							  xAxisNameFontBold: "1",
							  xAxisNameFontColor: "#993300",
							  labelFontSize: "8",
							  yAxisNameFontSize: "10",
							  yAxisNameFontBold: "1",
							  yAxisNameFontColor: "#993300",
							  subcaptionFontSize: "10",
							  subcaptionFontBold: "1",
							  subcaptionFontColor: "#993300"
							},
							categories: [
							  {
								category:  [
       								 {
          								label: "DELAYED"
        							 },
        						     {
          								label: "ON TIME"
        							 }]
							  }
							],
							dataset: [
							  {
								color: "#003f5c",
								data:[
        							{
          								value: tempJSON.shubDeparture.shubDepDelayedOntimeTcl,
        							},{
          								value: tempJSON.shubDeparture.shubDepOntimeOntimeTcl
        							}]
							  },
							  {
								color: "#ffa600",
								data:[
        							{
          								value: tempJSON.shubDeparture.shubDepDelayedDelayedTcl,
        							},{
          								value: tempJSON.shubDeparture.shubDepOnTimeDelayedTcl
        							}]
							  }
							  ]
						  }
				  });
				  
				  $("#enroute-chub-departure-dry").insertFusionCharts({
						  type: "stackedcolumn2d",
						  width: "39%",
						  height: "300",
						  dataFormat: "json",
						  dataSource: {
							chart: {
							  xaxisname: "CHUB DEPARTURE STATUS",
                              yaxisname: "% OF TRIPS",		
							  caption: "",
							  subcaption: "DRY",
							  numbersuffix: "",
							  showsum: "0",
							  baseFontSize: "11",
							  rotateLabels: "0",
							  plottooltext:
								"<b>$dataValue</b> $seriesName",
							  theme: "fusion",
							  drawcrossline: "1",
							   xAxisNameFontSize: "10",
							  xAxisNameFontBold: "1",
							  xAxisNameFontColor: "#993300",
							  labelFontSize: "8",
							  yAxisNameFontSize: "10",
							  yAxisNameFontBold: "1",
							  yAxisNameFontColor: "#993300",
							  subcaptionFontSize: "10",
							  subcaptionFontBold: "1",
							  subcaptionFontColor: "#993300"
							},
							categories: [
							  {
								category:  [
       								 {
          								label: "DELAYED"
        							 },
        						     {
          								label: "ON TIME"
        							 }]
							  }
							],
							dataset: [
							  {
								color: "#003f5c",
								data:[
        							{
          								value: tempJSON.enrouteChubDeparture.enrouteChubDepDelayedOntimeDry,
        							},{
          								value: tempJSON.enrouteChubDeparture.enrouteChubDepOntimeOntimeDry,
        							}]
							  },
							  {
								color: "#ffa600",
								data:[
        							{
          								value: tempJSON.enrouteChubDeparture.enrouteChubDepDelayedDelayedDry
        							},{
          								value: tempJSON.enrouteChubDeparture.enrouteChubDepOnTimeDelayedDry
        							}]
							  }
							  ]
						  }
				  });
				  
			      $("#enroute-chub-departure-tcl").insertFusionCharts({
						  type: "stackedcolumn2d",
						  width: "39%",
						  height: "300",
						  dataFormat: "json",
						  dataSource: {
							chart: {
							  xaxisname: "CHUB DEPARTURE STATUS",
                              yaxisname: "% OF TRIPS",	
							  caption: "",
							  subcaption: "TCL",
							  numbersuffix: "",
							  showYAxisValues:'0',
							  showsum: "0",
							  baseFontSize: "11",
							  rotateLabels: "0",
							  plottooltext:
								"<b>$dataValue</b> $seriesName",
							  theme: "fusion",
							  drawcrossline: "1",
							   xAxisNameFontSize: "10",
							  xAxisNameFontBold: "1",
							  xAxisNameFontColor: "#993300",
							  labelFontSize: "8",
							  yAxisNameFontSize: "10",
							  yAxisNameFontBold: "1",
							  yAxisNameFontColor: "#993300",
							  subcaptionFontSize: "10",
							  subcaptionFontBold: "1",
							  subcaptionFontColor: "#993300"
							},
							categories: [
							  {
								category:  [
       								 {
          								label: "DELAYED"
        							 },
        						     {
          								label: "ON TIME"
        							 }]
							  }
							],
							dataset: [
							  {
								color: "#003f5c",
								data:[
        							{
          								value: tempJSON.enrouteChubDeparture.enrouteChubDepDelayedOntimeTcl,
        							},{
          								value: tempJSON.enrouteChubDeparture.enrouteChubDepOntimeOntimeTcl
        							}]
							  },
							  {
								color: "#ffa600",
								data:[
        							{
          								value: tempJSON.enrouteChubDeparture.enrouteChubDepDelayedDelayedTcl,
        							},{
          								value: tempJSON.enrouteChubDeparture.enrouteChubDepOnTimeDelayedTcl
        							}]
							  }
							  ]
						  }
				  });
				  
				  $("#unauth-stoppage-dry").insertFusionCharts({
						  type: "stackedcolumn2d",
						  width: "39%",
						  height: "300",
						  dataFormat: "json",
						  dataSource: {
							chart: {
							  xaxisname: "UNAUTH STOPPAGES",
                              yaxisname: "% OF TRIPS",	
							  caption: "",
							  subcaption: "DRY",
							  numbersuffix: "",
							  showsum: "0",
							  baseFontSize: "11",
							  rotateLabels: "0",
							  plottooltext:
								"<b>$dataValue</b> $seriesName",
							  theme: "fusion",
							  drawcrossline: "1",
							   xAxisNameFontSize: "10",
							  xAxisNameFontBold: "1",
							  xAxisNameFontColor: "#993300",
							  labelFontSize: "8",
							  yAxisNameFontSize: "10",
							  yAxisNameFontBold: "1",
							  yAxisNameFontColor: "#993300",
							  subcaptionFontSize: "10",
							  subcaptionFontBold: "1",
							  subcaptionFontColor: "#993300"
							},
							categories: [
							  {
								category:  [
       								 {
          								label: "N"
        							 },
        						     {
          								label: "Y"
        							 }]
							  }
							],
							dataset: [
							  {
								color: "#003f5c",
								data:[
        							{
          								value: tempJSON.unauthStoppage.unauthStoppageNOntimeDry,
        							},{
          								value: tempJSON.unauthStoppage.unauthStoppageYOntimeDry,
        							}]
							  },
							  {
								color: "#ffa600",
								data:[
        							{
          								value: tempJSON.unauthStoppage.unauthStoppageNDelayedDry
        							},{
          								value: tempJSON.unauthStoppage.unauthStoppageYDelayedDry
        							}]
							  }
							  ]
						  }
				  });
				  
			      $("#unauth-stoppage-tcl").insertFusionCharts({
						  type: "stackedcolumn2d",
						  width: "39%",
						  height: "300",
						  dataFormat: "json",
						  dataSource: {
							chart: {
							  xaxisname: "UNAUTH STOPPAGES",
                              yaxisname: "% OF TRIPS",	
							  caption: "",
							  subcaption: "TCL",
							  numbersuffix: "",
							  showYAxisValues:'0',
							  showsum: "0",
							  baseFontSize: "11",
							  rotateLabels: "0",
							  plottooltext:
								"<b>$dataValue</b> $seriesName",
							  theme: "fusion",
							  drawcrossline: "1",
							   xAxisNameFontSize: "10",
							  xAxisNameFontBold: "1",
							  xAxisNameFontColor: "#993300",
							  labelFontSize: "8",
							  yAxisNameFontSize: "10",
							  yAxisNameFontBold: "1",
							  yAxisNameFontColor: "#993300",
							  subcaptionFontSize: "10",
							  subcaptionFontBold: "1",
							  subcaptionFontColor: "#993300"
							},
							categories: [
							  {
								category:  [
       								 {
          								label: "N"
        							 },
        						     {
          								label: "Y"
        							 }]
							  }
							],
							dataset: [
							  {
								color: "#003f5c",
								data:[
        							{
          								value: tempJSON.unauthStoppage.unauthStoppageNOntimeTcl,
        							},{
          								value: tempJSON.unauthStoppage.unauthStoppageYOntimeTcl
        							}]
							  },
							  {
								color: "#ffa600",
								data:[
        							{
          								value: tempJSON.unauthStoppage.unauthStoppageNDelayedTcl,
        							},{
          								value: tempJSON.unauthStoppage.unauthStoppageYDelayedTcl
        							}]
							  }
							  ]
						  }
				  });
				  
			}	 
						
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
		let cx = c.width / 2.0;
		topPosTitle = c.height / 2.0;
		let text=donutDryTCL[b];
		canvas.font=font;
		canvas.textAlign = 'center';
		canvas.fillText(text,cx,topPosTitle);
	}    
    
}
/*
$('#endDate').on("blur", function(){
	 dateChangeRefresh();
})
$('#startDate').on("blur", function(){
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
