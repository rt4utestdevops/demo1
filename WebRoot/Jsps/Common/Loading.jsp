<%@ page language="java" pageEncoding="utf-8" import="t4u.beans.*,t4u.functions.CommonFunctions"%>
<%@ taglib uri="http://struts.apache.org/tags-bean" prefix="bean" %>
<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html" %>
<%@ taglib uri="http://struts.apache.org/tags-logic" prefix="logic" %>
<% 
CommonFunctions cf=new CommonFunctions();
LoginInfoBean loginInfo=(LoginInfoBean)session.getAttribute("loginInfoDetails");
int customerId=loginInfo.getCustomerId();
int systemId=loginInfo.getSystemId();
String language=null;
String newMenuStyle="";
 language=loginInfo.getLanguage();
String loading=cf.getLabelFromDB("Loading",language);
 newMenuStyle=loginInfo.getNewMenuStyle();
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
		<meta charset="UTF-8" />
		<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1"> 
		<meta name="viewport" content="width=device-width, initial-scale=1.0"> 
</head>
<style>
#loadingMessage {
width: 100%;
height: 100%;
z-index: 3;
background: #fff;
top: 0px;
left: 0px;
position: absolute;
line-height: 670px;
text-align:center;
opacity: .5;
background-repeat: no-repeat;
background-position-x: 50%;
background-position-y: 44%;
background-position: 50% 44%;
font-family:'Open Sans', sans-serif;
display:block;
}
</style>
<body onload="load()">
<img alt="" src="/ApplicationImages/ApplicationButtonIcons/loader.gif" style="padding-left: 48%;margin-top: 20%;">
<div id="loadingMessage"><%=loading %>...</div>
<script src="../../Main/Js/Jquery-min.js"></script>
<script>

<!--	<%if(customerId >0 ){%>-->
<!--	window.location="/Telematics4uApp/Jsps/Common/HomeScreenNew.jsp";-->
<!--		<%} else {%>-->
<!--	window.location="/Telematics4uApp/Jsps/LTSP/LTSPMenu.jsp";-->
<!--	<%}%>-->

 <%if(newMenuStyle.equalsIgnoreCase("YES")){%>
				<%if(customerId >0 ){%>
				window.location="/Telematics4uApp/Jsps/Common/HomeScreenNew.jsp";
					<%} else {%>
				window.location="/Telematics4uApp/Jsps/LTSP/LTSPMenu.jsp";
				<%}%>

<%} else {%>
		<%if(customerId >0 ){%>
		window.location="/Telematics4uApp/Jsps/Common/HomeScreen.jsp";
			<%} else {%>
		window.location="/Telematics4uApp/Jsps/LTSP/LTSPMenu.jsp";
		<%}%>

<%}%>
	

		function load(){
				$('#loadingMessage').ready(function () {
    			$('#loadingMessage').css('display', 'block');
				});
				$('#loadingMessage').load(function () {
    			$('#loadingMessage').css('display', 'none');
				});	
		}
</script>

</body>
</html>
