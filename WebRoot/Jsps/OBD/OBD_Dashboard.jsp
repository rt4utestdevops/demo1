<%@ page language="java" import="java.util.*,java.text.SimpleDateFormat,t4u.functions.*,t4u.beans.*,t4u.common.*" pageEncoding="utf-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
	LoginInfoBean loginInfoBean = (LoginInfoBean) session.getAttribute("loginInfoDetails");
	if(loginInfoBean != null){
	  //Do nothing
	}
	else 
	{
	response.sendRedirect(request.getContextPath()+ "/Jsps/Common/SessionDestroy.html");
	
	}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
  <head>
    <title>Bootstrap Example</title>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
    <style>

  .panel{
   font-size: 5em;
   width:300px;
   float: left;
  }
  .panel-left{  
align-items: center;
}
  .panel-right{
border-left-color:blue;
float:left;
}

.col-sm-4{
float:left;
}
  </style>
  <link rel="stylesheet" href="../../Main/resources/css/obd/circle.css" type="text/css"></link>
  <link rel="stylesheet" href="../../Main/resources/css/obd/custom.css" type="text/css"></link>
  <link href="../../Main/Js/bootstrap.min.css" rel="stylesheet"></link>
	<script src="../../Main/Js/jquery.min.js"></script>
	<script src="../../Main/Js/bootstrap.min.js"></script>
    <script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
    <script>
     var interval = setInterval(function () { 
    	if(flag==1){
    		showDashboard();
    } }, 2*60*1000);
    google.charts.load('current', {'packages':['corechart','bar']});
    google.charts.setOnLoadCallback(showDashboard);
	
    var data,options,data1,options1,data2,options2,chart,chart1,chart2,view,view1,view2;
    function resizeHandler () {
        chart.draw(view, options);
        chart1.draw(view1, options1);
        chart2.draw(view2, options2);
    }
    if (window.addEventListener) {
        window.addEventListener('resize', resizeHandler, false);
    }
    else if (window.attachEvent) {
        window.attachEvent('onresize', resizeHandler);
    }
    
    function showDashboard(){
    	communicationDetail();
    	drawErrorCodeChart();
    	drawPrimaryAlert();
    	drawSecondaryAlert();
    }
    function communicationDetail(){
    	var jsonData = $.ajax({
            url: '<%=basePath%>'+'/OBDAction.do?param=getCommNonCommunicatingVehicles',
            dataType: "json",
            async: false
            }).responseText;
    	var json = JSON.parse(jsonData);
    	
    	var  total=json.CommNoncommroot[0].totalAssets;
    	var count,value,valueInt;
    	 if(total==0){
    	    count=0;
    	    value=0;
    	    valueInt=0;
    	 }else{
    	 	count=json.CommNoncommroot[0].communicating;
    	 	value=(count/total*100).toFixed(1);
    	 	valueInt=Math.round(count/total*100);
    	 }
    	 
    	document.getElementById("progressComm").className ="c100 p"+valueInt;
    	document.getElementById("commPercent").innerHTML=value+"%";
    	document.getElementById("commValue").innerHTML=count;
    	if(total==0){
    	    count=0;
    	    value=0;
    	    valueInt=0;
    	 }else{
	    	count=json.CommNoncommroot[0].noncommunicating;
	    	value=(count/total*100).toFixed(1);
	    	valueInt=Math.round(count/total*100);
    	}
    	document.getElementById("progressNonComm").className ="c100 p"+valueInt;
    	document.getElementById("nonCommPercent").innerHTML=value+"%";
    	document.getElementById("nonCommValue").innerHTML=count;
    	
    	if(total==0){
    	    count=0;
    	    value=0;
    	    valueInt=0;
    	 }else{
	    	count=json.CommNoncommroot[0].noGpsConnected;
	    	value=(count/total*100).toFixed(1);
	    	valueInt=Math.round(count/total*100);
    	}
    	document.getElementById("progressNoGPS").className ="c100 p"+valueInt;
    	document.getElementById("noGPSPercent").innerHTML=value+"%";
    	document.getElementById("noGPSValue").innerHTML=count;
    }
    
	  function drawErrorCodeChart() {
		  var jsonData = $.ajax({
	             url: '<%=basePath%>'+'/OBDAction.do?param=getErrorCodeCount',
	             dataType: "json",
	             async: false
	             }).responseText;
	    	 
	    	  data = new google.visualization.DataTable();
	    	 data.addColumn('string', 'Task');
	    	 data.addColumn('number', 'Hours per Day');
	    	 data.addRows(JSON.parse(jsonData));

	    	   
	       options = {
	        title: 'Total Error Codes Received',
	        annotations: {
          		alwaysOutside: true
          	},
          	vAxis: {title: 'Count'},
      		hAxis: {title: 'Error Type'},
	       series: {
      0: {
        type: 'bars'
      },
      1: {
        type: 'line',
        color: 'grey',
        lineWidth: 0,
        pointSize: 0,
        visibleInLegend: false
      }
	      } };
			
			 view = new google.visualization.DataView(data);
      		view.setColumns([0, 1,
                       { calc: "stringify",
                         sourceColumn: 1,
                         type: "string",
                         role: "annotation" }]);
      
       chart = new google.visualization.ComboChart(document.getElementById('dtc_chart'));
    	chart.draw(view,options);
    	
	      google.visualization.events.addListener(chart, 'select', function() {
	           // grab a few details before redirecting
	         var selectedItem = chart.getSelection()[0];
			    if (selectedItem) {
			      var value = data.getValue(selectedItem.row, 0);
			      	$("#errorType").val(value);
				    $("#errorCodeForm").submit();
			    }
	         });
	    }
    function drawPrimaryAlert(){
      
       options1 =  {
	        title: 'Primary Alerts',
	        width: '100%',
	        chartArea:{left:60,top:20,width:'60%',height:'65%'},
	        vAxis: {title: 'Count'},
      		hAxis: {title: 'AlertType'},
	       series: {
      0: {
        type: 'bars'
      },
      1: {
        type: 'line',
        color: 'grey',
        lineWidth: 0,
        pointSize: 0,
        visibleInLegend: false
      }
    },
	        annotations: {
          		alwaysOutside: true
          	},
          	displayAnnotations: true
	      };
      
      
      var jsonData = $.ajax({
          url: '<%=basePath%>'+'/OBDAction.do?param=getAlertCount',
          dataType: "json",
          async: false
          }).responseText;
      var json = JSON.parse(jsonData);
      var alertInfo=json.AlertCountRoot[0];
      var result = [];

      for(var i in alertInfo)
          result.push([i, alertInfo [i]]);
      
 	 data1 = new google.visualization.DataTable();
 	 data1.addColumn('string', 'AlertType');
 	 data1.addColumn('number', 'Count');
 	 data1.addRows(result);
 	 
 	   view1 = new google.visualization.DataView(data1);
      view1.setColumns([0, 1,
                       { calc: "stringify",
                         sourceColumn: 1,
                         type: "string",
                         role: "annotation" }]);
      
       chart1 = new google.visualization.ComboChart(document.getElementById('prim_alert_chart'));
    	chart1.draw(view1,options1);
    	 google.visualization.events.addListener(chart1, 'select', function() {

	           // grab a few details before redirecting
	         var selectedItem = chart1.getSelection()[0];
			    if (selectedItem) {
			    	
			      var value = data1.getValue(selectedItem.row, 0);
			      	$("#alertParam").val(value);
				    $("#alertForm").submit();
			    }
	         });
    }
    function drawSecondaryAlert() { 
    	  options2 = {
 	        title: 'Secondary Alerts',
 	         width: '100%',
 	        chartArea:{left:60,top:20,width:'60%',height:'65%'},
 	        annotations: {
          		alwaysOutside: true
          	},vAxis: {title: 'Count'},
      		hAxis: {title: 'AlertType'},
	       series: {
      0: {
        type: 'bars'
      },
      1: {
        type: 'line',
        color: 'grey',
        lineWidth: 0,
        pointSize: 0,
        visibleInLegend: false
      }
 	    }  };
     
        var jsonData1 = $.ajax({
            url: '<%=basePath%>'+'/OBDAction.do?param=getAlertCountSecondary',
            dataType: "json",
            async: false
            }).responseText;
        var json1 = JSON.parse(jsonData1);
        var alertSecInfo=json1.AlertCountSecRoot[0];
        var resultSec = [];

        for(var i in alertSecInfo)
        	resultSec.push([i, alertSecInfo [i]]);
        
   	 	data2 = new google.visualization.DataTable();
   	 	data2.addColumn('string', 'AlertType');
   	 	data2.addColumn('number', 'Count');
   	 	data2.addRows(resultSec);
   	 	
   	 	view2 = new google.visualization.DataView(data2);
      		view2.setColumns([0, 1,
                       { calc: "stringify",
                         sourceColumn: 1,
                         type: "string",
                         role: "annotation" }]);
      
       chart2 = new google.visualization.ComboChart(document.getElementById('sec_alert_chart'));
    	chart2.draw(view2,options2);
   	 	
   	 google.visualization.events.addListener(chart2, 'select', function() {
         // grab a few details before redirecting
       var selectedItem = chart2.getSelection()[0];
		    if (selectedItem) {
		    	
		      var value = data2.getValue(selectedItem.row, 0);
		      	$("#alertParam").val(value);
			    $("#alertForm").submit();
		    }
       });
    }
	
   </script>
</head>
  <body>
  <form style="display: hidden" action="<%=basePath+"Jsps/OBD/ErrorCodeDetails.jsp"%>" method="POST" id="errorCodeForm">
  <input type="hidden" id="errorType" name="errorType" value=""/>
</form>
<form style="display: hidden" action="<%=basePath+"Jsps/OBD/OBDAlertDetails.jsp"%>" method="POST" id="alertForm">
  <input type="hidden" id="alertParam" name="alertParam" value=""/>
</form>
  <div class="container-fluid">
		<div class="col-sm-8 errorCodeClass"><h3>OBD Dashboard</h3><div id="dtc_chart"></div></div>
  		<div class="col-sm-4"><h5>Vehicle Status With Count</h5> 
                  <div class="panel panel-primary text-center">
                  <div class="col-sm-4">
                            <div class="panel-left pull-left" >
                            <div class="c100 p1" id="progressComm">

							  <span id="commPercent"></span>
							
							  <div class="slice">
							
							    <div class="bar"></div>
							
							    <div class="fill"></div>
							
							  </div>
							
							</div>
                            
                            
                            </div>
                        </div>
                         <div class="col-sm-8">
                            <div class="panel-right pull-right">
								<h4 style="font-size:0.4em" id="commValue"></h4>
                               <h4 style="font-size:0.35em"><small>Communicating  </small></h4>
                            </div>
                        </div>
                    </div>
                       <div class="panel panel-primary text-center">
                  <div class="col-sm-4">
                            <div class="panel-left pull-left" >
                            <div class="c100 p1" id="progressNonComm">

							  <span id="nonCommPercent"></span>
							
							  <div class="slice">
							
							    <div class="bar"></div>
							
							    <div class="fill"></div>
							
							  </div>
							
							</div>
                            
                            
                            </div>
                        </div>
                         <div class="col-sm-8">
                            <div class="panel-right pull-right">
								<h4 style="font-size:0.4em" id="nonCommValue"></h4>
                               <h4 style="font-size:0.35em"><small>Non Communicating  </small></h4>
                            </div>
                        </div>
                    </div>
                     <div class="panel panel-primary text-center">
                  <div class="col-sm-4">
                            <div class="panel-left pull-left" >
                            <div class="c100 p1" id="progressNoGPS">

							  <span id="noGPSPercent"></span>
							
							  <div class="slice">
							
							    <div class="bar"></div>
							
							    <div class="fill"></div>
							
							  </div>
							
							</div>
                            </div>
                        </div>
                         <div class="col-sm-8">
                            <div class="panel-right pull-right">
								<h4 style="font-size:0.4em" id="noGPSValue"></h4>
                               <h4 style="font-size:0.35em"><small>No GPS Connected  </small></h4>
                            </div>
                        </div>
                    </div>
  		
	  </div>
			  <div class="col-sm-6" >
			  <div class="chart1-class" style="border: 1px solid #ccc; margin-top: 1em">
				   <div id="prim_alert_chart" >
				  </div>
			  </div>
			  </div>
			   <div class="col-sm-6">
			   <div class="chart1-class" style="border: 1px solid #ccc; margin-top: 1em">
				    <div id="sec_alert_chart">
				  </div>
			  </div>
		</div>
   </div>
  </body>
</html>