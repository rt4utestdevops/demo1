<%@ page language="java" import="java.util.*,java.text.SimpleDateFormat,t4u.functions.*,t4u.beans.*,t4u.common.*" pageEncoding="utf-8"%>
<%@ taglib uri="http://packtag.sf.net" prefix="pack" %> 
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<jsp:include page="../Common/header.jsp" />
	<title>Update Trip</title>
		<meta charset="UTF-8" />
		<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1"> 
		<meta name="viewport" content="width=device-width, initial-scale=1.0">
		<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script>
		<script src="../../Main/adapter/ext/ext-base.js"></script>
		<script src="../../Main/Js/ext-all-debug.js"></script>
  		<script src="../../Main/Js/examples1.js"></script>
  		 
		<link rel="stylesheet" href="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/css/bootstrap.min.css">
  		<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script>
  		<script src="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/js/bootstrap.min.js"></script>
		<link rel="stylesheet" type="text/css" href="../../Main/resources/css/ext-all.css" />
		<link rel="stylesheet" type="text/css" href="../../Main/resources/css/examples1.css" />
  		
		
  		<style>
.valBtn{
	padding-top: 30px;
}

body {
  font-family: 'Open Sas' ,sans-serif !important;
  font-size: 13px;
    
}
.mainDiv{	
	overflow:hidden;
	
}
.divBackgroundColor{	
	 font-family: 'Open Sas' ,sans-serif !important;
	 font-size: 12px;
	 padding-top:8px;
	 padding-bottom:5px;
}
.divHeading{
    font-family: 'Open Sas', sans-serif !important;
	background-color:#e24648 !Important;
	height: 30px;
	font-size: 16px;
	color: white;
	font-weight:300;
	padding-top:5px;
}

@media screen and (max-width: 1024px)  {
 .search {   
	width:18% !Important;
    text-indent: 0 !Important;
    padding: 5px 20px !Important;
    color: #fff !Important;
    background-color: #e24648 !Important;
    border: 0 !Important;
    border-radius: 9px !Important;
    cursor: pointer !Important;
    background-repeat: no-repeat !Important;
    font-family: 'Open Sas' sans-serif !Important;
	}
 }
 
.search {   
	width:12%;
    text-indent: 0;
    padding: 5px 20px;
    color: #fff !Important;
    background-color: #e24648;
    border: 0;
    border-radius: 9px;
    cursor: pointer;
    background-repeat: no-repeat;
    font-family: 'Open Sas' ,sans-serif !important;
}
button:hover{
background-color: #d0100c !Important;
color: #fff !Important;	
}

  		</style>
	<body>		
	 <div class="container-fluid mainDiv">
	  <div class="row panel">
      <div class="divHeading">Update trip</div>
  	</div>
  	<div class="row">
    <div class="col-md-3 divBackgroundColor">
    	<label for="usr">* Enter Your Transaction ID</label>
      	<input type="text" id="tripId" class="form-control" placeholder="Enter Your Transaction ID"/>
    </div>
  </div>
  <div class="row">
    <div class="col-md-3 divBackgroundColor">
    	<label for="usr">* Enter Your Mobile Number</label>      	
      	<input type="text" id="mobileNo" class="form-control" placeholder="Enter Your Mobile No" maxlength="15"/>
    </div>
  </div>
  <div class="row">
    <div class="col-md-3 divBackgroundColor">
    	<label for="usr">* Enter Your Email ID</label>
      	<input type="text" id="emailId" class="form-control" placeholder="Enter Your Email Id"/>
    </div>
    <div class="col-md-9 valBtn">    	
    	<button type="button" id="validate" class="btn search" size=20>Validate</button>
    </div>
    <div class="row">
    	<div class="col-md-12 divBackgroundColor" style="height: 25px"></div>
  	</div>
  </div>
  
   <div class="row panel">
      <div class="divHeading">Contact Details</div>
  </div>
  <div class="row">
    <div class="col-md-3 divBackgroundColor">
    	<label for="usr">* Enter New Mobile Number</label>      	
      	<input type="text" id="validMobileNo" class="form-control" placeholder="Enter Your Mobile No" maxlength="15"/>
    </div>
  </div>  
  <div class="row">
    <div class="col-md-3 divBackgroundColor">
    	<label for="usr">* Enter New Email ID</label>      	
      	<input type="text" id="validEmailId" class="form-control" placeholder="Enter Your Email ID"/>
    </div>
    <div class="col-md-9 valBtn">    	
    	
    	<button type="button"  id="updateDetails" class="btn search" disabled="disabled">Update Details</button>
    </div>
    <div class="row">
    	<div class="col-md-12 divBackgroundColor" style="height: 25px"></div>
  	</div>
  </div>
  </div>  
    
    <script type="text/javascript">	
    
     $( "#validate" ).click(function() {
     var inp = $("#tripId").val().toUpperCase();
     var mobileNum = $("#mobileNo").val();
     var emailId = $("#emailId").val();
	if(jQuery.trim(inp).length == 0)
	{	
   		 Ext.example.msg("Enter Transaction ID");
   		 return;
	}
	 if(jQuery.trim(mobileNum).length == 0)
	{
		Ext.example.msg("Enter mobile number");
		return;
	}
	  if(jQuery.trim(emailId).length == 0)
	{
		Ext.example.msg("Enter email Id");
		return;
	}
	
   if(!isValidPhone(mobileNum))
    {
        Ext.example.msg("Invalid Mobile No");
        $('#mobileNo').val('');
        $('#mobileNo').focus();
        return;
    }
       
    
    if(!isValidEmailAddress(emailId))
    {
        Ext.example.msg("Invalid email Id");
        $('#emailId').val('');
        $('#emailId').focus();
        return;
    }
    
	
	 $.ajax({
               url: "<%=request.getContextPath()%>/UpdateTripDetailsAction.do?param=checkTripId",
               type: 'POST',
               data: { tripId:inp.trim(),mobileNo:mobileNum.trim(),emailId:emailId.trim()},
               success: function(response,data) {
               var details=response;
               if(details=='Trip Exists')
               {
               	$("#updateDetails").removeAttr("disabled")
               }else{
                Ext.example.msg("Invalid Details");
               }
               }
              });
		});
    
    $( "#updateDetails" ).click(function() {
     var inp = $("#tripId").val().toUpperCase();
     var validMobileNum = $("#validMobileNo").val();
     var validEmailId = $("#validEmailId").val();
     var mobileNum = $("#mobileNo").val();
     var emailId = $("#emailId").val();
     if(jQuery.trim(validMobileNum).length == 0)
	 {
		Ext.example.msg("Enter mobile number");
		return;
	 }
	 if(jQuery.trim(validEmailId).length == 0)
	 {
		Ext.example.msg("Enter email Id");
		return;
	 }
     if(!isValidPhone(validMobileNum))
     {
        Ext.example.msg("Invalid Mobile No");
        $('#validMobileNo').val('');
        $('#validMobileNo').focus();
        return;
     }
     if(!isValidEmailAddress(validEmailId))
     {
        Ext.example.msg("Invalid email Id");
        $('#validEmailId').val('');
        $('#validEmailId').focus();
        return;
     }
     $.ajax({
               url: "<%=request.getContextPath()%>/UpdateTripDetailsAction.do?param=updateDetails",
               type: 'POST',
               data: { tripId:inp,validMobileNo:validMobileNum,validEmailId:validEmailId,mobileNo:mobileNum,emailId:emailId},
               success: function(response,data) {
               if(response.trim()){
	    		window.location="<%=request.getContextPath()%>/Jsps/PassengerBusTransportation/CancellationInfo.jsp?name="+response+"&tripId="+inp+"&updateTrip="+'Update'
               }
               $('#validEmailId').val('');
               $('#validMobileNo').val('');
               $('#emailId').val('');
               $('#mobileNo').val('');
               $("#tripId").val('');
               }
              });
    
      });

	function isValidPhone(mobileNum) {
   		 var pattern = /^[0-9-+]+$/;
    	 return pattern.test(mobileNum);
	}
	function isValidEmailAddress(emailAddress) {
    	var pattern = new RegExp(/^(("[\w-\s]+")|([\w-]+(?:\.[\w-]+)*)|("[\w-\s]+")([\w-]+(?:\.[\w-]+)*))(@((?:[\w-]+\.)*\w[\w-]{0,66})\.([a-z]{2,6}(?:\.[a-z]{2})?)$)|(@\[?((25[0-5]\.|2[0-4][0-9]\.|1[0-9]{2}\.|[0-9]{1,2}\.))((25[0-5]|2[0-4][0-9]|1[0-9]{2}|[0-9]{1,2})\.){2}(25[0-5]|2[0-4][0-9]|1[0-9]{2}|[0-9]{1,2})\]?$)/i);
    	return pattern.test(emailAddress);
	}
      
  
 </script>
 <jsp:include page="../Common/footer.jsp" />
 <!-- </body>   -->
 <!-- </html> -->
