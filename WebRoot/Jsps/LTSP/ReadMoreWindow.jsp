<%@ page language="java" import="java.util.*,t4u.functions.*" pageEncoding="ISO-8859-1"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://"+ request.getServerName() + ":" + request.getServerPort()+ path + "/";
	
	int processID = Integer.parseInt(request.getParameter("processId"));
	int value=Integer.parseInt(request.getParameter("value"));
	String wrapper="";
	String firstBanner = "";
	String secondBanner = "";
	String thirdBanner = "";
	String fourthBanner = "";
	String contents="";
	
	LTSPFunctions ltspfunc=new LTSPFunctions();
	
	Map<String, String> map = new HashMap<String, String>();
	map = ltspfunc.getReadMoreInfo(processID);
		wrapper=map.get("wrapper").toString();
		firstBanner = map.get("firstBanner").toString();
		secondBanner = map.get("secondBanner").toString();
		thirdBanner = map.get("thirdBanner").toString();
		fourthBanner = map.get("fourthBanner").toString();
		contents=map.get("contents").toString();
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
	<head>
	<title>Test</title>
	<link rel="stylesheet" href="../../Main/modules/LTSP/css/inline.css" type="text/css"/>	
	<style type="text/css">
	.newvertical-details {
		border-right: 0px solid #bdbdbd;
	}
	</style>
	</head>
	<body>
			<%=wrapper%>
			<%if (value == 1 ) {%>
			<%=firstBanner%>
			<%} else if (value == 2) {%>
			<%=secondBanner%>
			<%} else if (value == 3) {%>
			<%=thirdBanner%>
			<%} else {%>
			<%=fourthBanner%>
			<%}%>
			<%=contents%>	
	</body>
</html>