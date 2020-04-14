<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib uri="http://packtag.sf.net" prefix="pack" %>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<jsp:include page="../Common/header.jsp" />
    <base href="<%=basePath%>">
    
    <title>Cancel Ticket</title>
    
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	<!--
	<link rel="stylesheet" type="text/css" href="styles.css">
	-->
	<pack:script src="../../Main/adapter/ext/ext-base.js"></pack:script>
	<pack:script src="../../Main/Js/ext-all-debug.js"></pack:script>
	
   <pack:style src="../../Main/resources/css/ext-all.css" />
	<link rel="stylesheet" href="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/css/bootstrap.min.css">
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script>
  	<script src="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/js/bootstrap.min.js"></script>
  	<pack:script src="../../Main/Js/examples1.js"></pack:script>
    <pack:style src="../../Main/resources/css/examples1.css" />
  	
  	
<style type="text/css">
.valBtn{
	padding-top: 30px;
}
body {
  font-family: 'Open Sas' sans-serif !important;
  font-size: 13px;
    
}
.mainDiv{	
	overflow:hidden;
	
}
.divBackgroundColor{	
	 font-family: 'Open Sas' sans-serif !important;
	 font-size: 12px;
	 padding-top:8px;
	 padding-bottom:5px;
}
.divHeading{
    font-family: 'Open Sas' sans-serif !important;
	background-color:#e24648 !Important;
	height: 30px;
	font-size: 16px;
	color: white;
	font-weight:300;
	padding-top:5px;
}

@media screen and (max-width: 1024px)  {
 .search {   
	width:15% !Important;
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
	
	.cancleSearch{
	width:80% !Important;
    text-indent: 0;
    padding: 5px 20px;
    color: #fff !Important;
    background-color: #e24648;
    border: 0;
    border-radius: 9px;
    cursor: pointer;
    background-repeat: no-repeat;
    font-family: 'Open Sas' sans-serif !important;
}
 }

.search {   
	width:14%;
    text-indent: 0;
    padding: 5px 20px;
    color: #fff !Important;
    background-color: #e24648;
    border: 0;
    border-radius: 9px;
    cursor: pointer;
    background-repeat: no-repeat;
    font-family: 'Open Sas' sans-serif !important;
}

.cancleSearch{
	width:60%;
    text-indent: 0;
    padding: 5px 20px;
    color: #fff !Important;
    background-color: #e24648;
    border: 0;
    border-radius: 9px;
    cursor: pointer;
    background-repeat: no-repeat;
    font-family: 'Open Sas' sans-serif !important;
}
button:hover{
background-color: #d0100c !Important;
color: #fff !Important;	
}

input[type="checkbox"] {
	position: absolute;
	width:1px;
	height:1px;
	display:none;
	
}

input[type="checkbox"]+label {
	color: #5eb9f9;
	font-family: Arial, sans-serif;
	font-size: 14px;
	float: left;
}

input[type="checkbox"]+label span {
	display: inline-block;
	width: 33px;
	height: 30px;
	margin: 2px 4px 0 0;
	vertical-align: middle;
	background: url(/ApplicationImages/ApplicationButtonIcons/check.png) left top
		no-repeat;
	cursor: pointer;
}

input[type="checkbox"]:checked+label span {
	background: url(/ApplicationImages/ApplicationButtonIcons/check.png) 0px top
		no-repeat;
		background-position: 0 -30px;
}

</style>

  
  <div class="container-fluid mainDiv">
  <div class="row panel">
      <div class="divHeading">Cancel Trip</div>
  </div>
    <div class="row">
    <div class="col-md-2 divBackgroundColor">
    	<label for="usr">* Enter Your Transaction ID</label>
      	<input type="text" class="form-control" placeholder="Enter Your Transaction ID" id="tripId">
    </div>
     <div class="col-md-2 divBackgroundColor">
    	<label for="usr">* Enter Your Mobile Number</label>
      	<input type="text" class="form-control" placeholder="Enter Your Mobile Number" id="mobileId" maxlength="15">
    </div>
    <div class="col-md-2 divBackgroundColor">
    	<label for="usr">* Enter Your Email ID</label>
      	<input type="text" class="form-control" placeholder="Enter Your Email ID" id="emailId">
    </div>
     <div class="col-md-6 valBtn">
    	<button type="button" class="btn search" id="validate">Validate</button>
    </div>
    <div class="row">
    	<div class="col-md-12 divBackgroundColor" style="height: 25px"></div>
  	</div>
  </div>  
  <div class="row panel">
      <div class="divHeading">Journey Details</div>
  </div>
  <div class="row">
  <div class="col-md-12 divBackgroundColor">
  <label for="usr">Onward Journey Details</label>
  </div>
    <div class="col-md-2 divBackgroundColor">
    	<label for="usr">Journey Date</label>
      	<input type="text" class="form-control" id="DateOfJourney" placeholder="Onward Journey Date" disabled/>
    </div>
    <div class="col-md-2 divBackgroundColor">
    	<label for="usr">Terminal </label>
      	<input type="text" class="form-control" id="terminalId" placeholder="Terminal" disabled/>
    </div>    
    <div class="col-md-2 divBackgroundColor">
    	<label for="usr">From </label>
      	<input type="text" class="form-control" id="fromId" placeholder="From" disabled/>
    </div>
    <div class="col-md-2 divBackgroundColor">
    	<label for="usr">Destination </label>
      	<input type="text" class="form-control" id="destinationId" placeholder="Destination" disabled/>
    </div>   
    <div class="col-md-2 divBackgroundColor">
    	<label for="usr">Vehicle type </label>
      	<input type="text" class="form-control" id="vehicleType" placeholder="Vehicle type" disabled/>
    </div> 
    <div class="row" id="onword-cancel">     
        
  </div>
  </div>  
  <div class="row" id="return">
   <div class="col-md-12 divBackgroundColor">
  <label for="usr">Return Journey Details</label>
  </div>
    <div class="col-md-2 divBackgroundColor">
    	<label for="usr">Journey Date</label>
      	<input type="text" class="form-control" id="returnOfJourney" placeholder="Return Journey Date" disabled/>
    </div>
    <div class="col-md-2 divBackgroundColor">
    	<label for="usr">Terminal </label>
      	<input type="text" class="form-control" id="returnTerminalId" placeholder="Terminal" disabled/>
    </div>    
    <div class="col-md-2 divBackgroundColor">
    	<label for="usr">From </label>
      	<input type="text" class="form-control" id="returnFromId" placeholder="From" disabled/>
    </div>
    <div class="col-md-2 divBackgroundColor">
    	<label for="usr">Destination </label>
      	<input type="text" class="form-control" id="returnDestinationId" placeholder="Destination" disabled/>
    </div>   
    <div class="col-md-2 divBackgroundColor">
    	<label for="usr">Vehicle type </label>
      	<input type="text" class="form-control" id="returnVehicleType" placeholder="Vehicle type" disabled/>
    </div>     
    <div class="row" id="return-cancel">     
        
  	</div>
  </div>   
  
</div>
<script type="text/javascript">
var tripID;
var totalOnWordJourney;
var totalReturnJourney;
var onwordServiceID;
var returnServiceID;
var isRoundTrip;
var totalPassenger;
$(document).ready(function(){	
	 function ValidateEmail(email) {
        var expr = /^([\w-\.]+)@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.)|(([\w-]+\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\]?)$/;
        return expr.test(email);
    };
    function validatePhone(txtPhone) {
    	var filter = /^[0-9-+]+$/;
   	 		if (filter.test(txtPhone)) {
        	return true;
   	 		}  else {
        	return false;
   	 		}
		}
	
	$("#validate").click(function(){
		tripID = $("#tripId").val().toUpperCase();		
		if(tripID=="" && tripID!=null){
			Ext.example.msg("Please enter Transaction ID");
			return;
		}
		var mobileNum = $("#mobileId").val();
		
		if(mobileNum.trim()=="" && mobileNum!=null){
		Ext.example.msg("Please enter mobile number");
		return;
		}		
		
        if (!validatePhone(mobileNum)) {
           	Ext.example.msg("Please enter valid mobile number");
           	return;
        }
        var emailId= $("#emailId").val(); 
		if(!ValidateEmail(emailId)){
			Ext.example.msg("Please enter valid email address");
			return;
		}
		$.ajax({
		url: "<%=request.getContextPath()%>/CancelTicketAction.do?param=getPassangerTripInfo",
		data:{tripID:tripID,mobileNum:mobileNum,emailId:emailId},
	    type: 'POST',
	    dataType: "json",
	    success: function(response,data) { 
	    	   if(response.cancelInfo == "" || response.cancelInfo == null){
	    	   		Ext.example.msg("Transaction ID does not exist");
	    	   }else{
	    	   	var responsedata=response.cancelInfo;		    	  
	    	   	var countObject=0;
	    	   	 $.each(responsedata, function(k, v) {
	    	   	 countObject++;
	    	   	 });  	
	    	   	 if(countObject<2){
	    	   	  $("#return").remove();    					 
	    	   	 }	
	    		$.each(responsedata, function(k, v) {	    			
    					if(k==1){
    					 $("#returnOfJourney").val(v.journeydate);
    					 $("#returnTerminalId").val(v.terminalname);
    					 $("#returnVehicleType").val(v.vehiclemodel);
    					 $("#returnDestinationId").val(v.destination);
    					 $("#returnFromId").val(v.source);					
    					}else{    					
    					 $("#DateOfJourney").val(v.journeydate);
    					 $("#terminalId").val(v.terminalname);
    					 $("#vehicleType").val(v.vehiclemodel);
    					 $("#destinationId").val(v.destination);
    					 $("#fromId").val(v.source); 
    					}
				});
				if(tripID){				
				}else{
				Ext.example.msg("Please enter Transaction ID");
				return;
				}
				var currentServiceID=0;
				var previousServiceID=0;
				var count=0;
				$.ajax({
					url: "<%=request.getContextPath()%>/CancelTicketAction.do?param=getPassengerDetails",
					data:{transactionID:tripID},
	    			type: 'POST',
	    			dataType: "json",
	    			success: function(response,data) {	    			
	    			totalOnWordJourney=response.onwordCount;
	    			totalReturnJourney=response.returnCount;
	    			onwordServiceID=response.onwordService;
	    			returnServiceID=response.returnService;
	    			isRoundTrip=response.isRoundTrip;	
	    			totalPassenger=response.count;    				    				
	    				if(isRoundTrip==1){
	    					$('#onword-cancel').html(response.onwordStructure);
	    					$('#return-cancel').html(response.returnStructure);
	    					$('#service-'+response.count).after('<div class="col-md-3"><button type="button" class="btn cancleSearch" id="btnCancelTrip" onclick="cancelTrip()">Cancel Trip</button></div>');
	    				}else{
	    				$('#onword-cancel').html(response.onwordStructure);
	    				$('#service-'+response.count).after('<div class="col-md-3"><button type="button" class="btn cancleSearch" id="btnCancelTrip" onclick="cancelTrip()">Cancel Trip</button></div>');
	    				}	    				
						
	    			}
	    			});
	    			
               
			   }	   
              }
		});
	
	});
	
});

function cancelTrip(){
	var countOnword=0;
	var countReturn=0;
	var onwordArray=[];
	var returnArray=[];
	var cluster=0;
	var roundTrip='false';
	var totalSelected=0;
	var onwordDate="";
	var returnDate="";
	var onwordseats="";
	var returnseats="";
	var email=$("#emailId").val();
	var mobileNum = $("#mobileId").val();
	var totalCancellation=0;
	if(isRoundTrip==1){
	$("#onword-cancel input:checked").each(function () {
	        var id = $(this).attr("id");     
        countOnword++;
        var seatNumber=$('#seat-'+id).attr("value");
        onwordArray.push(seatNumber);
    	});
    	
    	$("#return-cancel input:checked").each(function () {
        var id = $(this).attr("id");
        var seatNumber=$('#seat-'+id).attr("value");
        countReturn++;
        returnArray.push(seatNumber);
    	});
    	onwordseats=onwordArray.toString();
    	returnseats=returnArray.toString();
    	if(countOnword==0 && countReturn==0){
    	Ext.example.msg("Please Select Seat");
				return;
    	}
    	$("#btnCancelTrip").attr("disabled", "disabled");  	
    	if(countOnword!=0 && countReturn!=0){
    		if(totalPassenger==(countOnword+countReturn))
    		{
    		totalCancellation=1;
    		}
    	cluster=1;
    	}
    	totalSelected=countOnword+countReturn;
    	if((countOnword+countReturn)>totalOnWordJourney){
    			
    	}else if((countOnword<totalOnWordJourney && countReturn==totalReturnJourney) || (countReturn<totalReturnJourney && countOnword==totalOnWordJourney)){
    			
    	}else{
    	
    			roundTrip='true';
    	}
    	onwordDate=$("#DateOfJourney").val();
    	returnDate=$("#returnOfJourney").val();    
    	$.ajax({
		url: "<%=request.getContextPath()%>/CancelTicketAction.do?param=getCancelTripInfoRound",
		data:{		
		tripID:tripID,
		onwordSeat:onwordseats,
		emailId:email,
		returnSeat:returnseats,
		roundTrip:roundTrip,
		onwordSelected:countOnword,
		returnSelected:countReturn,
		totalSelected:totalSelected,
		clusterType:cluster,
		onwordDate:onwordDate,
		returnDate:returnDate,
		onwordServiceId:onwordServiceID,
		returnServiceId:returnServiceID,
		totalCancel:totalCancellation
		},
	    type: 'POST',
	    success: function(response,data) {
	    	if(response.trim()){
	    	var responseList=response.split("$");
	    	var name = responseList[0];
            var isRoundTrip = responseList[1];
	    	window.location="<%=request.getContextPath()%>/Jsps/PassengerBusTransportation/CancellationInfo.jsp?name="+name+"&tripId="+tripID+"&isRoundTrip="+isRoundTrip
	    	}
	    }

	});
	}else{
	var countOnword=0;
	var onwordArray=[];
	var roundTrip='false';
	var totalSelected=0;
	var onwordDate="";
	var onwordseats="";
	$("#onword-cancel input:checked").each(function () {
	
       var id = $(this).attr("id");
      
        countOnword++;
        var seatNumber=$('#seat-'+id).attr("value");
        onwordArray.push(seatNumber);
    	});
    	if(countOnword==0){
    	Ext.example.msg("Please Select Seat");
				return;
    	} 
      $("#btnCancelTrip").attr("disabled", "disabled"); 
    	onwordseats=onwordArray.toString();
    	if(countOnword!=0){
    		if(totalPassenger==(countOnword))
    		{
    		totalCancellation=1;
    		}
    	
    	}
    	onwordDate=$("#DateOfJourney").val();
    	$.ajax({
		url: "<%=request.getContextPath()%>/CancelTicketAction.do?param=getCancelTripInfoSingle",
		data:{		
		tripID:tripID,
		onwordSeat:onwordseats,
		emailId:email,
		onwordSelected:countOnword,		
		onwordDate:onwordDate,		
		onwordServiceId:onwordServiceID,		
		totalCancel:totalCancellation,
		phoneNo:mobileNum
		},
	    type: 'POST',
	    success: function(response,data) {
	    	if(response.trim()){
	    	var responseList=response.split("$");
	    	var name = responseList[0];
            var isRoundTrip = responseList[1];
	    	window.location="<%=request.getContextPath()%>/Jsps/PassengerBusTransportation/CancellationInfo.jsp?name="+name+"&tripId="+tripID+"&isRoundTrip="+isRoundTrip
	    	}
	    }

	});
	}
		
	}


</script>
 <jsp:include page="../Common/footer.jsp" />
 <!-- </body>   -->
 <!-- </html> -->
