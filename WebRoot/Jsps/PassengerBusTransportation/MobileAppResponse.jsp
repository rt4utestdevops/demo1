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
if( transaction!=null && !transaction.equals("") ){
status  = func.getTransactionDetails(transaction);
}
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
  <base href="<%=basePath%>">
 <style>

.center {
    margin: auto;
    width: 100%;
    padding: 0px;
    background-color:skyblue;
}
 </style>

  </head>
  
  <body  onload = "showAndroidToast('android')" >
  

<div  class="center" > 

</div>
<script>
var  status = '<%=status%>';
var reason = '<%=reason%>';
    
 function showAndroidToast(toast) {
 if(status == "success"){
       ResponseViewer.book(toast);
       }else{
       ResponseViewer.failure(toast);       
       }
   }
window.location.hash="no-back-button";
window.location.hash="Again-No-back-button";//again because google chrome don't insert first hash into history
window.onhashchange=function(){window.location.hash="no-back-button";}

</script>
  </body>
</html>
