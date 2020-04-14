<%@ page  language="java" 
import="java.util.*,t4u.functions.*,t4u.beans.*,t4u.common.*" pageEncoding="utf-8"%>
<%@ taglib uri="http://packtag.sf.net" prefix="pack" %>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";


String Status = "";
String Transaction="";
String status = "";
String transaction="";
String MailNotifications ="";	
String passengername="";
String reason="";
int customerId = 0;
int systemId = 0;
String payresponse  = "";
PassengerBusTransportationFunctions func = new PassengerBusTransportationFunctions();
session = request.getSession();
LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");	
if(loginInfo != null ){
customerId = loginInfo.getCustomerId();
systemId = loginInfo.getSystemId();
}else{
Properties properties = ApplicationListener.prop;
customerId =Integer.parseInt(properties.getProperty("customerID").trim());
systemId = Integer.parseInt(properties.getProperty("systemID").trim());
}
if(request.getParameter("status") != null && !request.getParameter("status").equals("")){	
status = request.getParameter("status"); 
}
if(request.getParameter("txnref")!=null && !request.getParameter("txnref").equals("") ){
transaction=request.getParameter("txnref"); 
}

if(request.getParameter("refRef")!=null && !request.getParameter("refRef").equals("") ){
payresponse=request.getParameter("refRef"); 
}
System.out.println("payresponse == "+payresponse);

if(status == null || status.equals("") ){
status  = func.getTransactionDetails(transaction);
}
if(status!=null && !status.equals("") && transaction!=null && !transaction.equals(""))
{
 if(status.equals("00"))
{
status="success";
passengername  = func.getMailNotification(transaction,customerId,systemId);
}
else
{
status="failed";
}
reason = func.UpdateTransactionStatus(status,transaction); 
reason=reason.substring(0,reason.indexOf("|"));
}

	
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
  <link rel="stylesheet" href="//code.jquery.com/ui/1.11.4/themes/smoothness/jquery-ui.css">
<script src="../../Main/Js/jquery.js"></script>
<script src="../../Main/Js/jquery-ui.js"></script>
<pack:script src="../../Main/adapter/ext/ext-base.js"></pack:script>
<pack:script src="../../Main/Js/ext-all-debug.js"></pack:script>                          
<pack:style src="../../Main/resources/css/ext-all.css" />
<pack:script src="../../Main/Js/examples1.js"></pack:script>
<pack:style src="../../Main/resources/css/examples1.css" />
<pack:script src="../../Main/Js/jquery.min.js"></pack:script>
<pack:script src="../../Main/Js/jquery-ui.js"></pack:script>
  <base href="<%=basePath%>">
 <style>

.ticketBooked{
background-color:#e24648 !Important;
width:100%; 
border-bottom: 5px solid white;
color:white; 
font-family: 'Open Sas', sans-serif !important;
}
.ticketBooked h2{
font-family: 'Open Sas', sans-serif !important;
    font-size: 16px;
    color: #ffffff;
    font-weight: 300;
    margin: 10px 0;
    padding-top: 8px;
}
.outerdiv{
background-color:white;
height:200px;
width:100%;
float:left;
border:1px solid #e24648 !Important;
border-top:white;
font-family: 'Open Sas', sans-serif !important;
}
.innerdiv{
background-color:#E9E9EB; 
height:160px;
width:95%;
 margin-left:18px;
 font-family: 'Open Sas', sans-serif !important;
}
.ticketFailed{
background-color:#e24648 !Important;
width:100%;
border-bottom: 5px solid white; 
color:white; 
}

.ticketFailed h2{
font-family: 'Open Sas', sans-serif !important;
    font-size: 16px;
    color: #ffffff;
    font-weight: 300;
    margin: 10px 0;
    padding-top: 8px;
}
.outerdiv1{
background-color:white;
height:200px;
width:100%;
float:left;
border:1px solid #e24648 !Important;
border-top:white;
}
.innerdiv1{
background-color:#E9E9EB; 
height:160px;
width:95%;
 margin-left:18px;
 font-family: 'Open Sas', sans-serif !important;
}
.center {
    margin: auto;
    width: 50%;
    padding: 0px;
    background-color:skyblue;
}
 </style>

  </head>
  
  <body >
  

 <div  class="center" > 
<div   id="successMsz" style="display:none";>
<div class= 'ticketBooked' >
    <h2>Ticket Booking Confirmation</h2>
</div>
  <div class= 'outerdiv' >
  <div class= 'innerdiv'>
    <p><b><br>Dear  <span class="PassengerName" id="passengerName"></span> ,your payment was successfully processed and the tickets details has been sent to the registered mobile number and email-ID of primary passenger.</b></p>
<p style="allign:left">Please make a note of the Transaction ID for the future reference</p><br/>
<b><i>Transaction ID :</i> <span class="transaction" id="TransactionID"></span></b>

  </div>
</div>
 
</div>

<div id="FailedMsz" style="display:none";>
  <div class= 'ticketFailed'> 
      <h2>Ticket Booking Failed</h2>
  </div>

  <div class= 'outerdiv1'>
  
  <div class= 'innerdiv1'>

    <p><b> Your payment was not successfully processed .</b></p>
    
    <b><i>Reason :</i> <span class="reason" id="Reason"></span></b><br/><br/>

<b><i>Transaction ID :</i> <span class="transaction" id="TransactionID2"></span></b>

  </div>   
</div>
 
</div>
</div>
<script>
     var  status = '<%=status%>';
     var  transaction='<%=transaction%>';
     var passenger='<%=passengername%>';
     var clientId = '<%=customerId%>';
     var systemId = '<%=systemId%>';
     var reason = '<%=reason%>';
     if(status=="success"){
document.getElementById('successMsz').style.display='block'; 
document.getElementById('TransactionID').innerHTML=transaction;
document.getElementById('passengerName').innerHTML=passenger.toUpperCase();

  window.open("<%=request.getContextPath()%>/TicketConfirmationPdf?clientId="+clientId+"&systemId="+systemId+"&transaction="+transaction+"");

 }
else {
document.getElementById('FailedMsz').style.display='block'; 
document.getElementById('TransactionID2').innerHTML=transaction;
document.getElementById('Reason').innerHTML=reason;
}
   


window.location.hash="no-back-button";
window.location.hash="Again-No-back-button";//again because google chrome don't insert first hash into history
window.onhashchange=function(){window.location.hash="no-back-button";}

</script>
  </body>
</html>
