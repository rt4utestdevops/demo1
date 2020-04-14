<%@ page language="java" import="java.util.*" pageEncoding="ISO-8859-1"%>
<%@ taglib uri="http://packtag.sf.net" prefix="pack" %>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <base href="<%=basePath%>">
    <title>Error</title>
	<pack:script src="/js/cancelbackspacenew.js"></pack:script>
  </head>
  
  <body >
    <table  align="center">
    	<tr align="center">
    		<td>
    			<font color="8B0000" style="font-family: sans-serif; font-size: 16px; font-weight: bolder">
    			.
    			</font>
    		</td>
    	</tr>
    </table>
  </body>
</html>
