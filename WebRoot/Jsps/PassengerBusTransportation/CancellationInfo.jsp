<%@ page language="java" import="java.util.*" pageEncoding="ISO-8859-1"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
String name = "";
String tripId = "";
String isRoundTrip = "";
String updateTrip = "";
String openTicket = "";
if(request.getParameter("name") != null && !request.getParameter("name").trim().equals("")){
	name = request.getParameter("name").toUpperCase();
}

if(request.getParameter("tripId") != null && !request.getParameter("tripId").trim().equals("")){
	tripId = request.getParameter("tripId");
}

if(request.getParameter("isRoundTrip") != null && !request.getParameter("isRoundTrip").trim().equals("") ){
	isRoundTrip = request.getParameter("isRoundTrip");
}
if(request.getParameter("updateTrip") != null && !request.getParameter("updateTrip").trim().equals("") ){
	updateTrip = request.getParameter("updateTrip");
}else{
updateTrip="false";
}

if(request.getParameter("openTicket") != null && !request.getParameter("openTicket").trim().equals("") ){
	openTicket = request.getParameter("openTicket");
}else{
	openTicket = "false";
}


%>

<!DOCTYPE HTML>
<html>
  <head>
    <base href="<%=basePath%>">
    
    <title>Information</title>
    
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	<!--
	<link rel="stylesheet" type="text/css" href="styles.css">
	-->
	<link rel="stylesheet" href="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/css/bootstrap.min.css">
  	<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script>
  	<script src="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/js/bootstrap.min.js"></script>
  	<style>
  .content{
		border: 1px solid black;  		
  		font-size: 12px;
  		font-weight: bold;
  		text-align: center;
  		background-color:#eee;
  		margin-left: 10px;
		margin-right: 10px;
		margin-bottom: 10px;
		margin-top: 30px;
		text-align: left;
		font-family: 'Open Sas', sans-serif !important;
  	}
 .divHeading{
 	padding-top: 4px;
 	font-family: 'Open Sas', sans-serif !important;
	background-color:#e24648 !Important;
	height: 30px;
	font-size: 16px;
	color: white;
	font-weight: 300;
}

.divWhite{ 
	background-color:white;
}

.panel {   
    background-color: #e24648 !Important;
   
}

#div1{
	display: none;
}

#div2{
	display: none;
}

#div3{
	display: none;
}
#div4{
	display: none;
}
#div5{
	display: none;
}

.content1 {
    border: 1px solid black;
    font-size: 12px;
    font-weight: bold;
    text-align: center;   
    margin-left: 10px;
    margin-right: 10px;
    margin-bottom: 10px;
    margin-top: 30px;
    text-align: left;
    font-family: 'Open Sas', sans-serif !important;
    height: 190px;
}
label {
    display: inline-block;
    max-width: 100%;
    margin-bottom: 5px;
    font-weight: 700;
    position: absolute;
    right: 101px;
    top: 162px;
}

@media screen and (max-width: 1024px)  {
 .search {   
	width:13% !Important;
    text-indent: 0 !Important;
    padding: 5px 20px !Important;
    color: #fff !Important;
    background-color: #e24648 !Important;
    border: 0 !Important;
    border-radius: 9px !Important;
    cursor: pointer !Important;
    background-repeat: no-repeat !Important;
    font-family: 'Open Sas' sans-serif !Important;
    margin-top:-3%!Important;
	}
	
	.nowSearch{
	width:11%;
    text-indent: 0;
    padding: 5px 20px;
    color: #fff !Important;
    background-color: #e24648;
    border: 0;
    border-radius: 9px;
    cursor: pointer;
    background-repeat: no-repeat;
    font-family: 'Open Sas' sans-serif !important;
    float: right;   
	}
 }
 
.search {   
	width:11%;
    text-indent: 0;
    padding: 5px 20px;
    color: #fff !Important;
    background-color: #e24648;
    border: 0;
    border-radius: 9px;
    cursor: pointer;
    background-repeat: no-repeat;
    font-family: 'Open Sas' sans-serif !important;
    float: right;
}

.nowSearch{
width:11%;
    text-indent: 0;
    padding: 5px 20px;
    color: #fff !Important;
    background-color: #e24648;
    border: 0;
    border-radius: 9px;
    cursor: pointer;
    background-repeat: no-repeat;
    font-family: 'Open Sas' sans-serif !important;
    float: right;
    margin-top: 18px;
}
button:hover{
background-color: #d0100c !Important;
color: #fff !Important;	
}


  	</style>
  	<script type="text/javascript">
	
	$(document).ready(function(){
	if('<%=isRoundTrip%>'=="true"){
		$("#div2").css('display','block');
	}else if('<%=updateTrip%>'=="Update"){
		$("#div3").css('display','block');
	}else if('<%=isRoundTrip%>'=="false"){
		$("#div1").css('display','block');
	}else if('<%=openTicket%>'=="Open"){
		$("#div4").css('display','block');
	}else if('<%=openTicket%>'=="OpenTicket"){
	$("#div5").css('display','block');
	}
	
	});
	function preventbackspacebutton(){
        window.location.hash="no-back-button";
        window.onhashchange=function(){window.location.hash="";}
	}
	
	function now(){
	window.location="<%=request.getContextPath()%>/Jsps/PassengerBusTransportation/SeatSelection.jsp"
	}

    </script>
  </head>
  
  <body onload="preventbackspacebutton();">
    <div class="container-fluid mainDiv">
  		
  		<div id="div1" class="row">
  			<div class="col-md-3 divWhite">
  				
  			</div>
    		<div class="col-md-6 content">
    			<div class="row panel">
      				<div class="divHeading">Cancellation Information</div>
  				</div>
    			<br>
    			<p>Dear <%=name%>, your Transaction ID- <%=tripId%> has been cancelled   
    			 as per your request. A coupon code with the refund 
    			 amount has been sent to your registered mobile number 
    			 for future use.</p>
    			<br>
    			<p>                 Thank you for using YSG Services. </p>
    		</div>
    		<div class="col-md-3 divWhite">
    			
  			</div>
  		</div>
  		
  		<div id="div2" class="row">
  			<div class="col-md-3 divWhite">
  				
  			</div>
    		<div class="col-md-6 content">
    			<div class="row panel">
    				<div class="divHeading">Cancellation Information</div>
  				</div>
    			<br><br>
    			<p>Dear <%=name%>, your Transaction ID- <%=tripId%> has been cancelled   
    			 as per your request.</p>
    			<br>
    			<p>                 Thank you for using YSG Services. </p>
    		</div>
    		<div class="col-md-3 divWhite">
    			
  			</div>
  		</div>
  		
  		<div id="div3" class="row">
  			<div class="col-md-3 divWhite">
  				
  			</div>
    		<div class="col-md-6 content">
    			<div class="row panel">
    				<div class="divHeading">Update Trip Information</div>
  				</div>
    			<br><br>
    			<p>Dear <%=name%>, your Transaction ID- <%=tripId%> has been updated   
    			 as per your request. Request you to take the print out of the updated ticket which has been sent to your mail.</p>
    			<br>
    			<p>                 Thank you for using YSG Services. </p>
    		</div>
    		<div class="col-md-3 divWhite">
    			
  			</div>
  		</div>
  		
  		<div id="div4" class="row">
  			<div class="col-md-3 divWhite">
  				
  			</div>
    		<div class="col-md-6 content1">
    			<div class="row">
    				<div class="col-md-12 divHeading">Open Trip Information</div>
  				</div>
    			<br><br>
    			<p>Dear <%=name%>, your Transaction ID- <%=tripId%> has been Pre/Postpned as per your request. 
    			A coupon code and the amount has been sent to your registered mobile number for future use.</p>
    			<br>
    			<p>                 Thank you for using YSG Services. </p>
    			<div><label>Reschedule</label>
    			<button type="button" class="btn search" id="btnNow" onclick="now()">Now</button>
    			</div>
    		</div>
    		<div class="col-md-3 divWhite">
    			
  			</div>
  		</div>
  		<div id="div5" class="row">
  			<div class="col-md-3 divWhite">
  				
  			</div>
    		<div class="col-md-6 content1">
    			<div class="row">
    				<div class="col-md-12 divHeading">Open Trip Information</div>
  				</div>
    			<br><br>
    			<p>Dear <%=name%>, your Transaction ID- <%=tripId%> has been Pre/Postpned as per your request. </p>
    			<br>
    			<p>                 Thank you for using YSG Services. </p>
    			<div><label>Reschedule</label>
    			<button type="button" class="btn nowSearch" id="btnNow" onclick="now()">Now</button>
    			</div>
    		</div>
    		<div class="col-md-3 divWhite">
    			
  			</div>
  		</div>
  		
  		
  </div>
  
  
  
  </body>
</html>
