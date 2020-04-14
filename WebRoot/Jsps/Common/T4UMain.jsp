<%@ page language="java" import="java.util.*,t4u.beans.*" pageEncoding="utf-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
LoginInfoBean loginInfo=new LoginInfoBean();
loginInfo.setSystemId(12);//2
loginInfo.setUserId(3);//101
loginInfo.setLanguage("en");
loginInfo.setZone("A");//B
loginInfo.setOffsetMinutes(330);//240
loginInfo.setCategory("India");
loginInfo.setCategoryType("South India");
loginInfo.setSystemName("T4U");
loginInfo.setCustomerId(0);
loginInfo.setUserName("vinayak");
loginInfo.setStyleSheetOverride("N");
if(loginInfo==null){
	response.sendRedirect(request.getContextPath()+ "/Jsps/Common/SessionDestroy.html");
}
else
{
session.setAttribute("loginInfoDetails",loginInfo);	

%>

<!DOCTYPE HTML>
<html>
 <head>
		<title>T4U Main</title>
			<style>
				#menu {
				margin:50px auto;
				width:600px;
				}
				#menu nav {
				height:300px;
				overflow:visible !important;
				position:relative;
				}
				
				#menu nav ul {
				margin:0 0;
				padding:0 0;
				list-style:none;
				}
				
				#menu nav li {
				margin:3px 3px;
				padding:0 0;
				float:left;
				display:inline;
				-webkit-box-shadow:-650px 500px 0 #BC0036,200px -100px 0 #6CBC00,300px 100px 0 #0A40EA, 700px -500px 0 #EAC60A;
				-moz-box-shadow:-650px 500px 0 #BC0036,200px -100px 0 #6CBC00,300px 100px 0 #0A40EA, 700px -500px 0 #EAC60A;
				box-shadow:-650px 500px 0 #BC0036,200px -100px 0 #6CBC00,300px 100px 0 #0A40EA, 700px -500px 0 #EAC60A;
				}
				
				#menu nav a {
				padding-top:40px;
				display:block;
				background-color:#D7460D;
				color:gold;
				text-decoration:none;
				width:100px;
				height:85px;
				font:bold 14px/20px 'Arial Narrow',Arial,Sans-Serif;
				text-align:center;
				text-vertical-align:middle;
				}
				
				#menu nav {
				-webkit-transition:all 2s ease-out;
				-moz-transition:all 2s ease-out;
				-ms-transition:all 2s ease-out;
				-o-transition:all 2s ease-out;
				transition:all 2s ease-out;
				}
				
				#menu nav ul {
				-webkit-transform:scale(0.2);
				-moz-transform:scale(0.2);
				-ms-transform:scale(0.2);
				-o-transform:scale(0.2);
				transform:scale(0.2);
				-webkit-transition:all 10s ease-in-out;
				-moz-transition:all 10s ease-in-out;
				-ms-transition:all 10s ease-in-out;
				-o-transition:all 10s ease-in-out;
				transition:all 10s ease-in-out;
				}
				
				#menu nav li {
				-webkit-transition:all 10s ease-in-out;
				-moz-transition:all 10s ease-in-out;
				-ms-transition:all 10s ease-in-out;
				-o-transition:all 10s ease-in-out;
				transition:all 10s ease-in-out;
				opacity:0.4;
				}
				
				#menu nav ul {
				-webkit-transform:scale(1) translate(0px,0px);
				-moz-transform:scale(1) translate(0px,0px);
				-ms-transform:scale(1) translate(0px,0px);
				-o-transform:scale(1) translate(0px,0px);
				transform:scale(1) translate(0px,0px);
				}
				
				#menu nav li {
				opacity:1;
				-webkit-box-shadow:0 0 0 #BC0036,0 0 0 #6CBC00,0 0 0 #0A40EA, 0 0 0 #EAC60A;
				-moz-box-shadow:0 0 0 #BC0036,0 0 0 #6CBC00,0 0 0 #0A40EA, 0 0 0 #EAC60A;
				box-shadow:0 0 0 #BC0036,0 0 0 #6CBC00,0 0 0 #0A40EA, 0 0 0 #EAC60A;
				-webkit-transform:rotate(0deg) translate(0px,0px);
				-moz-transform:rotate(0deg) translate(0px,0px);
				-ms-transform:rotate(0deg) translate(0px,0px);
				-o-transform:rotate(0deg) translate(0px,0px);
				transform:rotate(0deg) translate(0px,0px);
				}
				
				#menu nav a {
				width:100px; /* 98px + border = 100px */
				height:83px; /* 98px + border = 100px */
				background-color:white;
				background-image:-webkit-linear-gradient(top,#ccc,white);
				background-image:-moz-linear-gradient(top,#ccc,white);
				background-image:-ms-linear-gradient(top,#ccc,white);
				background-image:-o-linear-gradient(top,#ccc,white);
				background-image:linear-gradient(top,#ccc,white);
				filter: progid:DXImageTransform.Microsoft.gradient(startColorstr='#cccccc', endColorstr='#ffffff');
				text-shadow:0 1px 0 rgba(255,255,255,0.2);
				border:1px solid transparent;
				border-color:rgba(255,255,255,0.2) rgba(0,0,0,0.2) rgba(0,0,0,0.2) rgba(255,255,255,0.2);
				color:#D7460D;
				}
				
				#menu nav:hover a {
				-webkit-transform:scale(0.8);
				-moz-transform:scale(0.8) rotate(360deg);
				-ms-transform:scale(0.8) rotate(360deg);
				-o-transform:scale(0.8) rotate(360deg);
				transform:scale(0.8) rotate(360deg);
				}
				
				#menu nav:hover a:hover {
				background-color:#D7460D;
				background-image:-webkit-linear-gradient(top,#D7460D,#AF390D);
				background-image:-moz-linear-gradient(top,#D7460D,#AF390D);
				background-image:-ms-linear-gradient(top,#D7460D,#AF390D);
				background-image:-o-linear-gradient(top,#D7460D,#AF390D);
				background-image:linear-gradient(top,#D7460D,#AF390D);
				filter: progid:DXImageTransform.Microsoft.gradient(startColorstr='#D7460D', endColorstr='#AF390D');
				color:gold;
				text-shadow:0 -1px 0 rgba(0,0,0,0.4);
				position:relative;
				z-index:77;
				-webkit-transform:scale(1.1) rotate(360deg);
				-moz-transform:scale(1.1) rotate(360deg);
				-ms-transform:scale(1.1) rotate(360deg);
				-o-transform:scale(1.1) rotate(360deg);
				transform:scale(1.1) rotate(360deg);
				}
				</style>
		
	</head>	    
  
  <body >
  <table align="center" style="width:900px;" >
   <tr style="width:900px;height:90px;BACKGROUND-POSITION: center top; BORDER-COLLAPSE: collapse; BACKGROUND-REPEAT: no-repeat; BACKGROUND-IMAGE: url(/ApplicationImages/AdminJspsTop.png)">
  	<td style="padding-top:60px;font-size:20px;font-family:Arial;color:#ffffff;" >&nbsp;T4U</td></tr>
  <tr valign="top" style="background-color:#F0F0F0" >
  <td align="center">
  <table>
  <tr valign="top" >
  <td>
  <div id="menu"><nav>
	<ul>
		<li><a href="#" title="Administration" onclick="getwindow('custimaster')" >Administration</a></li>
		<li><a href="#" title="WasteManagement" onclick="getwindow('WasteManagement')" >Waste Management</a></li>
		<li><a href="#" title="EmployeeTracking" onclick="getwindow('EmployeeTracking')" >Employee Tracking</a></li>
		<li><a href="#" title="CargoManagement" onclick="getwindow('CargoManagement')" >Cargo Management</a></li>
		<li><a href="#" title="DemoorLeaseCarManagement" onclick="getwindow('DemoorLease')" >Demo or Lease Car Management</a></li>
		<li><a href="#" title="RMC" onclick="getwindow('RMC')" >RMC</a></li>
	</ul>
	</nav></div>
  </td>
  </tr>  
  </table>
  </td></tr>
  <tr style="width:900px;height:30px;BACKGROUND-POSITION: center top; BORDER-COLLAPSE: collapse; BACKGROUND-REPEAT: no-repeat; BACKGROUND-IMAGE: url(/ApplicationImages/AdminJspsBottom.png)">
  <td>&nbsp;
  </td></tr>
    </table>
    <script>
 function getwindow(win){
if(win=='custimaster'){
window.location.href="../Admin/AdminTab.jsp";
 }
 else if(win=='WasteManagement'){
 window.location.href="../WasteManagement/WasteManagement_Tab.jsp?feature=2";
 }
 else if(win=='EmployeeTracking'){
  window.location.href="../EmployeeTracking/EmployeeTracking_Tab.jsp?feature=3";
 }
 else if(win=='CargoManagement'){
  window.location.href="../CargoManagement/Cargo_Tab.jsp?feature=5";
 }
 else if(win=='DemoorLease'){
  window.location.href="../DemoCar/DemoCar_Tab.jsp?feature=6";
 }
 else if(win=='RMC'){
  window.location.href="../RMC/RMC_Tab.jsp";
 }
 }
 </script>
 
  
   
  </body>
</html>
<%}%>