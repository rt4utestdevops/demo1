<%@page language="java" import="java.util.*,t4u.functions.HomeScreenFunctions,t4u.functions.CommonFunctions,t4u.functions.AdminFunctions,t4u.beans.*,t4u.common.*" pageEncoding="utf-8"%>
<%@ taglib uri="http://packtag.sf.net" prefix="pack" %>
<%@page import="t4u.functions.AlertFunctions"%>

<%	
	
	String basePath = request.getScheme() + "://"+ request.getServerName() + ":" + request.getServerPort()+"/";
	CommonFunctions cf=new CommonFunctions();
	AdminFunctions af=new AdminFunctions();
	cf.checkLoginInfo((LoginInfoBean)session.getAttribute("loginInfoDetails"),session,request,response);
	LoginInfoBean loginInfo=(LoginInfoBean)session.getAttribute("loginInfoDetails");
	HttpSession sessionPassMsg = request.getSession(true);
	if(request.getParameter("ltspCustomer")!=null){
	loginInfo.setCustomerId(Integer.parseInt(request.getParameter("ltspCustomer")));
	}
	String processId=null;
	if(request.getParameter("processId")!=null){
	processId=request.getParameter("processId").trim();
	}
	session.setAttribute("processId",processId);
	int totalVehicles=-1;
	int systemId = loginInfo.getSystemId();
	int customerId = loginInfo.getCustomerId();
	int userId = loginInfo.getUserId();
	int isLTSP = loginInfo.getIsLtsp();
	int offset = loginInfo.getOffsetMinutes();
	
	String userAuthority = cf.getUserAuthority(systemId,userId);
	if(request.getParameter("id")!=null)
	{
		totalVehicles=Integer.parseInt((String)request.getParameter("id"));
	} else if(request.getParameter("id") == null && systemId == 261 && isLTSP == -1){
		totalVehicles = cf.getVehicleCount(customerId,systemId,userId);
	}
	String language=loginInfo.getLanguage();
	String userName=(String)session.getAttribute("userName");
	
	String home=cf.getLabelFromDB("Home",language);
	String logout=cf.getLabelFromDB("Logout",language);
	String wlecome=cf.getLabelFromDB("Welcome",language);
	/*
	int dayDiff=af.getPasswordModifiedDate(offset,userId,systemId);
	int dayDiffToDisplay=0;
	if(dayDiff >= 40 && dayDiff <= 45)
	{
		dayDiffToDisplay = 45-dayDiff;
	}
	*/
	int dayDiff = 0;
	int dayDiffToDisplay = 0;
	boolean allow = true;
	String str = "223,259,134,194,183,165,184,182,199,178,150,216,153,300,296,204,185,332,323,337,327";
	String[] sandSystemId = str.split(",");
	for (String s : sandSystemId) {
		if (String.valueOf(systemId).equals(s)) {
			allow = false;
			break;
		}
	}
	if (allow) {
		dayDiff = af.getPasswordModifiedDate(offset, userId, systemId);
		if (dayDiff >= 40 && dayDiff <= 45) {
			dayDiffToDisplay = 45 - dayDiff;
		}
	}
	sessionPassMsg.setAttribute("PassExpMsg",true);
%>

<!DOCTYPE html>
<html lang="en" class="no-js">
	<head>
		<meta charset="UTF-8" />
		<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1"> 
		<meta name="viewport" content="width=device-width, initial-scale=1.0"> 
		<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
		
		</head>	
	<body onload="getDigitalTimer('<%=cf.getCurrentDateTime(loginInfo.getOffsetMinutes())%>'); " oncontextmenu="return false;">		
		
		
		<script>
		
		    $( document ).ready(function() {
  				if(<%=isLTSP%> > 0 || <%=isLTSP%> == -1 ){
     			   if(<%=dayDiff%> >= 40 && <%=dayDiff%> <= 45)
    				{ 
    					if(<%=dayDiffToDisplay%>!=0)
    						alert("Your Password Will Expire in "+<%=dayDiffToDisplay%>+" Day(s) Change Your Password through Update Profile");
    						else
    						alert("Your Password Will Expire Today Change Your Password through Update Profile ");
    				}
     			}
			});	
		
		 var defaultLink="";
		 var MenuList;
		 function getDefaultLink(){
       	$.ajax({
	         type: "POST",
	         url: '<%=request.getContextPath()%>/CommonAction.do?param=getMenuList',
	         success: function(result) {
	             	MenuList = JSON.parse(result);
	          		defaultLink=MenuList.defaultLink;
	          		window.location=defaultLink;
	         }
	     });
		}
	
		function logOut() {				
			window.location="<%=request.getContextPath()%>/LogOut.do?username=<%=loginInfo.getUserName()%>";
		}
		
		function home() {
		window.location="/jsps/LTSPScreen.jsp?CustomerId=0";		
		}	
		
 
		if(<%=customerId%>>0)
		{
		getDefaultLink();
		
		}
		else
		{
		window.location="/Telematics4uApp/Jsps/LTSP/LTSPMenu.jsp";
		}
    	
		</script>		
	</body>
</html>