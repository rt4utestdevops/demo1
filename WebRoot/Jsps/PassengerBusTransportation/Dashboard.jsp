<%@ page language="java" import="java.util.*,java.util.*,java.util.*,java.text.SimpleDateFormat" pageEncoding="utf-8"%>
<%@ taglib uri="http://packtag.sf.net" prefix="pack" %>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";

String[] strDays = new String[]{
                     "Sun",
                     "Mon",
                     "Tue",
                     "Wed",
                     "Thu",
                     "Fri",
                     "Sat"
                   };

Calendar  cal = Calendar.getInstance();
String  dt1=strDays[cal.get(Calendar.DAY_OF_WEEK) - 1];
int d1 = cal.get(Calendar.DAY_OF_WEEK) - 1;
cal.add(Calendar.DATE,-1);
String  dt2=strDays[cal.get(Calendar.DAY_OF_WEEK) - 1];
cal.add(Calendar.DATE,-1);
String  dt3=strDays[cal.get(Calendar.DAY_OF_WEEK) - 1];
cal.add(Calendar.DATE,-1);
String  dt4=strDays[cal.get(Calendar.DAY_OF_WEEK) - 1];
cal.add(Calendar.DATE,-1);
String  dt5=strDays[cal.get(Calendar.DAY_OF_WEEK) - 1];
cal.add(Calendar.DATE,-1);
String  dt6=strDays[cal.get(Calendar.DAY_OF_WEEK) - 1];
cal.add(Calendar.DATE,-1);
String  dt7=strDays[cal.get(Calendar.DAY_OF_WEEK) - 1];

%>

<jsp:include page="../Common/header.jsp" />
    <base href="<%=basePath%>">
    
    <title>Dashboard</title>
    
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">

	<pack:script src="../../Main/adapter/ext/ext-base.js"></pack:script>
	<pack:script src="../../Main/Js/ext-all-debug.js"></pack:script>
	
    <pack:style src="../../Main/resources/css/ext-all.css" />
    
	<link rel="stylesheet" href="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/css/bootstrap.min.css">
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script>
  	<script src="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/js/bootstrap.min.js"></script>
  	
<!--  	<link rel="stylesheet" href="../../Main/Js/bootstrap.min.css">-->
<!--	<script src="../../Main/Js/jquery.min.js"></script>-->
<!--  	<script src="../../Main/Js/bootstrap.min.js"></script>-->
  	<pack:script src="../../Main/Js/examples1.js"></pack:script>
    <pack:style src="../../Main/resources/css/examples1.css" />
    <pack:script src="../../Main/Js/jsapi.js"> </pack:script>
    
<style type="text/css">
    

	.mainDiv{
		height:100%;
		width:100%;
		overflow: y:hidden;
	}
	.divRow {
	    margin-left: 67px;
	}
	.div{
		width:50%;
		height:45%;
		margin-left: -30px;
	}
	
	.headerbox {
		font-family: 'Lato', Calibri, Arial, sans-serif;
	    padding: 6px 6px;
	    background-color: #f8f8f8;
	    height: 40px;
	    border-top: 1px solid #bdbdbd;
	    border-bottom: 1px solid #bdbdbd;
	    box-shadow: 4px 0px 6px #bdbdbd;
	    margin-bottom: 4px;
	    display: block;
	    font-size: 24px;
	    color: #5eb9f9;
	    padding: 2px 2px;
	    font-weight: 300;
}

</style>    


    <div class="container-fluid mainDiv">
		
    	<div class="row headerbox">
    		<p>DASHBOARD</p>
    	</div>

    	<div class="row divRow">
    		<div class="col-md-6 div" id="1">
    		</div>
    		<!--<div class="col-md-6 div" id="2">
    		</div>-->
    	</div>
		<div class="row divRow">
			<div class="col-md-6 div" id="2">
    		</div>
    	</div>
		
    	<div class="row divRow">
    		<div class="col-md-6 div" id="3">
    		</div>
<!--    		<div class="col-md-6 div" id="4">
    		</div>  -->
    	</div>
		<div class="row divRow">    		
    		<div class="col-md-6 div" id="4">
    		</div>
    	</div>
    </div>
    
  
  
   <script type="text/javascript">
    google.load("visualization", "1", {packages:["corechart"]});
   google.setOnLoadCallback(drawStuff);
   
   var dashBoardWeekBarChartStore = new Ext.data.JsonStore({
				url: '<%=request.getContextPath()%>/DashboardChartsAction.do?param=getDashboardCharts1',
				root: 'DashBoardChartRoot1',
				autoLoad: false,
				remoteSort: true,
				fields: ['Sun','Mon','Tue','Wed','Thu','Fri','Sat']
   });
   
   var dashBoardYearBarChartStore = new Ext.data.JsonStore({
				url: '<%=request.getContextPath()%>/DashboardChartsAction.do?param=getDashboardCharts2',
				root: 'DashBoardChartRoot2',
				autoLoad: false,
				remoteSort: true,
				fields: ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec']
   });
   
   var dashBoardYearLineChartStore = new Ext.data.JsonStore({
				url: '<%=request.getContextPath()%>/DashboardChartsAction.do?param=getDashboardCharts3',
				root: 'DashBoardChartRoot3',
				autoLoad: false,
				remoteSort: true,
				fields: ['Sun','Mon','Tue','Wed','Thu','Fri','Sat','Sunweb','Monweb','Tueweb','Wedweb','Thuweb','Friweb','Satweb','Sunmob','Monmob','Tuemob','Wedmob','Thumob','Frimob','Satmob']
   });
   
   var dashBoardRouteBarChartStore = new Ext.data.JsonStore({
				url: '<%=request.getContextPath()%>/DashboardChartsAction.do?param=getDashboardCharts4',
				root: 'DashBoardChartRoot4',
				autoLoad: false,
				remoteSort: true,
				fields: ['R1','R2','R3','R4','R5','T1','T2','T3','T4','T5']
   });
   
   
   
    

      function drawStuff() {      
        
        dashBoardWeekBarChartStore.load({
				callback: function(){
					var barchartgraph1 = new google.visualization.ColumnChart(document.getElementById('1'));
					var rec = dashBoardWeekBarChartStore.getAt(0);
            		var barchartdata1 = google.visualization.arrayToDataTable([
    					['DAYS', 'No of Tickets'],
    					['<%=dt7%>',  parseInt(rec.data['<%=dt7%>'])],
    					['<%=dt6%>',  parseInt(rec.data['<%=dt6%>'])],
    					['<%=dt5%>',  parseInt(rec.data['<%=dt5%>'])],
    					['<%=dt4%>',  parseInt(rec.data['<%=dt4%>'])],
    					['<%=dt3%>',  parseInt(rec.data['<%=dt3%>'])],
    					['<%=dt2%>',  parseInt(rec.data['<%=dt2%>'])],
    					['<%=dt1%>',  parseInt(rec.data['<%=dt1%>'])]
  					]);
  					
  					var options1 = {
          							titleTextStyle:{color:'#686262',fontSize:13,align:'center',fontName:'sans-serif'},
  									backgroundColor: '#E4E4E4',
  									//width:259,
									height:250,
  									pieSliceText: "value",
          							sliceVisibilityThreshold:0,          							
          							legend:{position: 'bottom'},
          							colors:['#6495ED'],
          							title: 'Total Tickets Sold On A Day',  
          							vAxis:{title:'No Of Tickets',titleTextStyle: { italic: false,fontSize:13,fontName:'sans-serif'} }       
          
        };
            		barchartgraph1.draw(barchartdata1, options1);
				}
		});
		
		
		dashBoardYearBarChartStore.load({
				callback: function(){
					var barchartgraph2 = new google.visualization.LineChart(document.getElementById('2'));
            		var rec = dashBoardYearBarChartStore.getAt(0);
            		var barchartdata2 = google.visualization.arrayToDataTable([
    					['DAYS', 'No of Tickets'],
    					['Jan',  parseInt(rec.data['Jan'])],
    					['Feb',  parseInt(rec.data['Feb'])],
    					['Mar',  parseInt(rec.data['Mar'])],
    					['Apr',  parseInt(rec.data['Apr'])],
    					['May',  parseInt(rec.data['May'])],
    					['Jun',  parseInt(rec.data['Jun'])],
    					['Jul',  parseInt(rec.data['Jul'])],
    					['Aug',  parseInt(rec.data['Aug'])],
    					['Sep',  parseInt(rec.data['Sep'])],
    					['Oct',  parseInt(rec.data['Oct'])],
    					['Nov',  parseInt(rec.data['Nov'])],
    					['Dec',  parseInt(rec.data['Dec'])]
  					]);
  					
  					    var options2 = {	
          							titleTextStyle:{color:'#686262',fontSize:13,align:'center',fontName:'sans-serif'},
  									backgroundColor: '#E4E4E4',
  									//width:259,
									height:250,
  									pieSliceText: "value",
          							sliceVisibilityThreshold:0,          							
          							legend:{position: 'bottom'},
          							colors:['#e24648'],
          							title: 'Total Tickets Sold On A Month',  
          							vAxis:{title:'No Of Tickets',titleTextStyle: { italic: false,fontSize:13,fontName:'sans-serif'} } 
        
         
        };
            		barchartgraph2.draw(barchartdata2, options2);
				}
		});
		
		
		dashBoardYearLineChartStore.load({
				callback: function(){
					var barchartgraph3 = new google.visualization.LineChart(document.getElementById('3'));
            		var rec = dashBoardYearLineChartStore.getAt(0);
            		var barchartdata3 = google.visualization.arrayToDataTable([
    					['DAYS', 'Web' , 'Mobile'],
    					['<%=dt7%>',  parseInt(rec.data['<%=dt7%>'+'web']),parseInt(rec.data['<%=dt7%>'+'mob'])],
    					['<%=dt6%>',  parseInt(rec.data['<%=dt6%>'+'web']),parseInt(rec.data['<%=dt6%>'+'mob'])],
    					['<%=dt5%>',  parseInt(rec.data['<%=dt5%>'+'web']),parseInt(rec.data['<%=dt5%>'+'mob'])],
    					['<%=dt4%>',  parseInt(rec.data['<%=dt4%>'+'web']),parseInt(rec.data['<%=dt4%>'+'mob'])],
    					['<%=dt3%>',  parseInt(rec.data['<%=dt3%>'+'web']),parseInt(rec.data['<%=dt3%>'+'mob'])],
    					['<%=dt2%>',  parseInt(rec.data['<%=dt2%>'+'web']),parseInt(rec.data['<%=dt2%>'+'mob'])],
    					['<%=dt1%>',  parseInt(rec.data['<%=dt1%>'+'web']),parseInt(rec.data['<%=dt1%>'+'mob'])]
  					]);
  					
  					  
        var options3 = {       
          							titleTextStyle:{color:'#686262',fontSize:13,align:'center',fontName:'sans-serif'},
  									backgroundColor: '#E4E4E4',
  									//width:259,
									height:250,
  									pieSliceText: "value",
          							sliceVisibilityThreshold:0,          							
          							legend:{position: 'bottom'},
          							colors:['#e24648','#6495ED'],
          							title: 'Total Tickets Sold On A Day By Mobile And Web',  
          							vAxis:{title:'No Of Tickets',titleTextStyle: { italic: false,fontSize:13,fontName:'sans-serif'} } 
        };
            		barchartgraph3.draw(barchartdata3, options3);
				}
		});
        
        
        
        dashBoardRouteBarChartStore.load({
				callback: function(){
					var barchartgraph4 = new google.visualization.ColumnChart(document.getElementById('4'));
            		var rec = dashBoardRouteBarChartStore.getAt(0);
            		var barchartdata4 = google.visualization.arrayToDataTable([
    					['RouteName', 'No of Tickets'],
    					[rec.data['R1'],  parseInt(rec.data['T1'])],
    					[rec.data['R2'],  parseInt(rec.data['T2'])],
    					[rec.data['R3'],  parseInt(rec.data['T3'])],
    					[rec.data['R4'],  parseInt(rec.data['T4'])],
    					[rec.data['R5'],  parseInt(rec.data['T5'])]
  					]);
  					 var options4 = {
  					           		titleTextStyle:{color:'#686262',fontSize:13,align:'center',fontName:'sans-serif'},
  									backgroundColor: '#E4E4E4',
  									//width:259,
									height:250,
  									pieSliceText: "value",
          							sliceVisibilityThreshold:0,          							
          							legend:{position: 'bottom'},
          							colors:['#6495ED'],
          							title: 'Best Selling Route',  
          							 bar: {groupWidth: "50%"},
          							 hAxis:{textStyle:{fontSize: 10},showTextEvery:1},
          							 vAxis:{title:'No Of Tickets',titleTextStyle: { italic: false,fontSize:13,fontName:'sans-serif'} }          							 
        };
            		barchartgraph4.draw(barchartdata4, options4);
				}
		});


      };
  </script>
  <jsp:include page="../Common/footer.jsp" />
 <!-- </body>   -->
 <!-- </html> -->
