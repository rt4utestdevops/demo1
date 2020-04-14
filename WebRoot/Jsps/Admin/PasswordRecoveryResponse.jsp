<%@ page language="java" pageEncoding="ISO-8859-1"%>
<%

 String status = "";
 if(request.getParameter("Status") !=null){
   status = request.getParameter("Status");
  }
String message = "";
if(status.equalsIgnoreCase("success")){
message = "Password created successfully. Please check your mail for login link.";
}else{
message = "Password could not created. Please contact your admin to continue further.";
}
 %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    
    
    <title>Password Recovery Response</title>
    <script language="javascript" type="text/javascript">
    window.history.forward();
 </script> 
    
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	<!--
	<link rel="stylesheet" type="text/css" href="styles.css">
	-->
<style>
.headerforflase{

color: #14149c;
margin-left: 1%;
font-family:sans-serif;

}
</style>

  </head>
  
  <body>
  <span class = "headerforflase" ><h3><%=message%></h3></span>
   <script>
   window.oncontextmenu = function () {return false;}
     		document.onkeydown = function(e) {
		    if (event.keyCode == 123) {
		        return false;
		    }
		    if (e.ctrlKey && e.shiftKey && e.keyCode == 'I'.charCodeAt(0)) {
		        return false;
		    }
		    if (e.ctrlKey && e.shiftKey && e.keyCode == 'J'.charCodeAt(0)) {
		        return false;
		    }
		    if (e.ctrlKey && e.keyCode == 'U'.charCodeAt(0)) {
		        return false;
		    }
		}
   
   </script>
   
  </body>
</html>
