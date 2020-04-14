<%@ page language="java" import="java.util.*,t4u.beans.*" pageEncoding="ISO-8859-1" session="false"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
		HttpSession session = request.getSession(false);
	try {
		String userNameToLogout = "";
		if (request.getParameter("username") != null) {
			userNameToLogout = request.getParameter("username").toString();
		}
		
		Hashtable<String, ArrayList<Object>> loggedInUserTable = new Hashtable<String, ArrayList<Object>>();
		ServletContext servletContext = session.getServletContext();
		loggedInUserTable = (Hashtable) servletContext.getAttribute("loggedUsersTable");
		LoginInfoBean loginInfo= (LoginInfoBean) session.getAttribute("loginInfoDetails");
		if (loggedInUserTable != null && loginInfo!=null) {			
			ArrayList<Object> loggedUsersDetails = (ArrayList<Object>) loggedInUserTable.get(userNameToLogout.trim().toUpperCase());			
			if (loggedUsersDetails != null) {
				response.setHeader("Cache-Control", "no-cache");
				response.setHeader("Cache-Control", "no-store");
				response.setHeader("Pragma", "no-cache");
				response.setDateHeader("Expires", 0);
				System.out.println("SessionId " + session.getId());
				HttpSession sessionToInvalidate = (HttpSession) loggedUsersDetails.get(5);
				loggedInUserTable.remove(userNameToLogout.trim().toUpperCase());
				session.removeAttribute("loginInfoDetails");
				sessionToInvalidate.invalidate();
				servletContext.setAttribute("loggedUsersTable",	loggedInUserTable);
			}
		} else {
			if(session!=null)
			{
			response.setHeader("Cache-Control", "no-cache");
			response.setHeader("Cache-Control", "no-store");
			response.setHeader("Pragma", "no-cache");
			response.setDateHeader("Expires", 0);
			System.out.println("SessionId " + session.getId());			
			session.invalidate();
			}
		}		
		
	} catch (Exception e) {
		e.printStackTrace();
	}	
%>

<!DOCTYPE html>
<html>
<head>	
    <!-- Basic Page Needs -->
    <meta charset="utf-8">
    <title>Log Out</title>
    <meta name="description" content="">
    <meta name="author" content="">

    <!-- Mobile Specific Metas -->
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">

    <!-- Google Web Font -->
    <link href='https://fonts.googleapis.com/css?family=Open+Sans:300,400,300,600,700,800' rel='stylesheet' type='text/css'>

    <!-- CSS -->
    <link rel="stylesheet" href="../../Main/modules/common/error/css/component.css">
<script type="text/javascript">
function preventbackspacebutton(){
				window.location.hash="no-back-button";
				window.location.hash="no-back-button";
				window.onhashchange=function(){window.location.hash="";}
}
    </script>	
</head>
<body onload="preventbackspacebutton()">


    <!-- Page Header Section
    ================================================== -->
    <div id="header">

        <div class="container clearfix">

            <div id="branding" class="row">
                <p class="tagline">Logged Out Page</p>
            </div>

            <div id="error-wrapper" class="row">
                <h2 class="errorSeessionDestroy">Successfully logged out from application.</h2>
                <div class="error-human">
                    <p>Please close this window. This will ensure that any information that is cached (stored) on your browser is erased and will not allow others to view it later.</p>
                </div>
            </div><!-- error-wrapper -->

        </div><!-- container -->

    </div><!-- #header section -->
</body>
</html>