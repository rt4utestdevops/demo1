<%@ page  language="java" import="java.util.*,t4u.functions.CommonFunctions,t4u.beans.*,t4u.common.*" pageEncoding="utf-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
if(request.getParameter("list")!=null){
	String list=request.getParameter("list").toString().trim();
	String[] str=list.split(",");
	int systemid=Integer.parseInt(str[0].trim());
	int customerid=Integer.parseInt(str[1].trim());
	int userid=Integer.parseInt(str[2].trim());
	String language=str[3].trim();
	LoginInfoBean loginInfo=new LoginInfoBean();
	loginInfo.setSystemId(systemid);
	loginInfo.setCustomerId(customerid);
	loginInfo.setUserId(userid);
	loginInfo.setLanguage(language);
	loginInfo.setZone(str[4].trim());
	loginInfo.setOffsetMinutes(Integer.parseInt(str[5].trim()));
	loginInfo.setSystemName(str[6].trim());
	loginInfo.setCategory(str[7].trim());
	if(str.length>8){
	loginInfo.setCustomerName(str[8].trim());
	}
	session.setAttribute("loginInfoDetails",loginInfo);
}
CommonFunctions cf=new CommonFunctions();
cf.checkLoginInfo((LoginInfoBean)session.getAttribute("loginInfoDetails"),session,request,response);
LoginInfoBean loginInfo=(LoginInfoBean)session.getAttribute("loginInfoDetails");
String language=loginInfo.getLanguage();
int systemid=loginInfo.getSystemId();
String systemID=Integer.toString(systemid);
int customeridlogged=loginInfo.getCustomerId();
%>

<jsp:include page="../Common/header.jsp" />
        <style type="text/css">
		body {
 			margin-top: 0px;
 			margin-right: 0px;
 			margin-bottom: 0px;
 			margin-left: 0px;
			}
		</style>
         <script type="text/javascript"> 
          top.visible_id = 'DashBoardMap'; 
		  var pageSwitchingInterval=20000;
          function toggle_visibility() { 
             var right_e = document.getElementById('DashBoardMap'); 
             var left_e = document.getElementById('DashBoard'); 
            if (top.visible_id == 'DashBoardMap') {
              right_e.style.display = 'none'; 
              left_e.style.display = 'block'; 
              top.visible_id = 'DashBoard';
            } else {
              right_e.style.display = 'block'; 
              left_e.style.display = 'none'; 
              top.visible_id = 'DashBoardMap';
            }
            var t = setTimeout("toggle_visibility()",pageSwitchingInterval);
          } 
window.onload = function () { 
		toggle_visibility();
	}
          </script> 
        
        

         <div id="DashBoard" style="width:100%;height:100%;overflow:hidden"> 
            <iframe src="/Telematics4uApp/Jsps/EmployeeTracking/DashBoard.jsp?ipVal=true" width="100%" height=610px></iframe>
         </div> 

         <div id="DashBoardMap" style="width:100%;height:100%;overflow:hidden"> 
            <iframe src="/Telematics4uApp/Jsps/EmployeeTracking/DashBoardMap.jsp?ipVal=true" width="100%" height=650px></iframe>
         </div> 

         <jsp:include page="../Common/footer.jsp" />
 <!-- </body>   -->
 <!-- </html> -->
