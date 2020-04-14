<%@ page language="java"
	import="java.util.*,t4u.functions.CommonFunctions,t4u.beans.*,t4u.common.*"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://packtag.sf.net" prefix="pack"%>


<!doctype html>
<html>
 <head>
    <title>Mileage Chart</title>
   <script src="../../Main/Js/jquery.js"></script>
	<script src="../../Main/Js/jquery.min.js"></script>
	<script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
	
 </head>
 <body onload="loadData()">
  
  <br><br>
  <div id="chart_div"></div>
  <script>
  var data1;
  var model;
    function loadData(){
    var mileageDetails;
       $.ajax({
        url: '<%=request.getContextPath()%>/HBAnalysisGraphAction.do?param=getModelWiseMileage',
          success: function(result) {
                   mileageDetails = JSON.parse(result);
          //alert(JSON.parse(result));
           // for (var i = 0; i < mileageDetails["getModelWiseMileage"].length; i++) {
			model = mileageDetails["getModelWiseMileage"][0].models;
            data1 = mileageDetails["getModelWiseMileage"][0].data;
           // alert(data1);
		//	}
		google.charts.load('current', {'packages':['line']});
      google.charts.setOnLoadCallback(drawChart);
			}
			 });
    
    }
	
	  

    function drawChart() {
  
			
    //alert([[2017-08-29, 14.07], [2017-08-30, 13.35]]);
      var data = new google.visualization.DataTable();
     
      data.addColumn('number', 'Mileage');
      data.addColumn('number', "Average Milage of Hundai");
     
	  var arr=[];
      arr.push(mileageDetails["getModelWiseMileage"][0].models);
      arr.push(mileageDetails["getModelWiseMileage"][0].data);
    
      data.addRows([arr]);
	  

      var options = {
        chart: {
          title: 'ModelWise Mileage Chart',
          
        },
        width: 900,
        height: 500,
		series: {
          0: {axis: 'Temps'}
        },
        axes: {
          y: {
            Temps: {label: 'KM/L'}
          }
        }
      };

      var chart = new google.charts.Line(document.getElementById('chart_div'));

      chart.draw(data, google.charts.Line.convertOptions(options));
     
    }
  </script>
  
 </body>
</html>
