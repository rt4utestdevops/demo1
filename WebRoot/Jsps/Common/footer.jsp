<%@ page language="java"
   import="java.util.*,t4u.functions.CommonFunctions,t4u.beans.*,t4u.common.*"
   pageEncoding="UTF-8"%>
<%@ taglib uri="http://packtag.sf.net" prefix="pack"%>
<%
   String path = request.getContextPath();
   String basePath = request.getScheme() + "://"+ request.getServerName() + ":" + request.getServerPort()+ path + "/";
   CommonFunctions cf = new CommonFunctions();
   LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
   int systemId=0;
   int customerId=0;
   int userId=0;
   String lang="";
   String newMenuStyle="";
   if (loginInfo != null) {
   systemId=loginInfo.getSystemId();
   customerId=loginInfo.getCustomerId();
   lang=loginInfo.getLanguage();
   userId=loginInfo.getUserId();
   newMenuStyle=loginInfo.getNewMenuStyle();
   } else {
   	response.sendRedirect(request.getContextPath()+ "/Jsps/Common/SessionDestroy.html");
   }
   String userName=(String)session.getAttribute("userName");
   String userAuthority = cf.getUserAuthority(systemId,userId);
   %>
   <%if(newMenuStyle.equalsIgnoreCase("YES")){%>
  <br/><br/>
    </div>
    <!--<footer class="footer">
      <div class="container">

      </div>
    </footer>-->
    <div style="position:absolute;bottom:8px;right:16px;color:black;" id="footSpan"></div>
   <!--  <link rel="stylesheet" href="https://code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
    <script src="https://code.jquery.com/jquery-1.12.4.js"></script>
    <script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.6-rc.0/css/select2.min.css" rel="stylesheet" />
    <script src="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.6-rc.0/js/select2.min.js"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-multiselect/0.9.13/css/bootstrap-multiselect.css">      
    <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-multiselect/0.9.13/js/bootstrap-multiselect.min.js"></script>-->
    <script>
    document.getElementById("footSpan").innerHTML =  "&copy; "+(new Date()).getFullYear()+" telematics4u";
   // $("#footSpan").html("&copy; "+(new Date()).getFullYear()+" telematics4u");
/*
     $.ajax({
     url: "<%=request.getContextPath()%>/CommonAction.do?param=getVehicleList",
     type: 'POST',
     success: function(response,data) {
         var text = response;
         var list=text.split(",");     
        $("#searchId").autocomplete({
         source: list,
         select: function( event, ui ) {
             $.ajax({
              url: "<%=request.getContextPath()%>/CommonAction.do?param=getVehicleDetails",
              type: 'POST',
              data: { vehicleNo:ui.item.value},
              success: function(response,data) {
              var details=response;        
              if(details){
               detail=details.split("!");
               document.getElementById('vehicle-No').innerHTML=detail[0];
       		   document.getElementById('Date-Time').innerHTML=detail[1];
       		   document.getElementById('Driver-Id').innerHTML=detail[2];
       		   document.getElementById('Driver-Mobile').innerHTML=detail[3];
       		   document.getElementById('Owner-Name').innerHTML=detail[4];
       		   document.getElementById('Location').innerHTML=detail[5];
       		   document.getElementById('Vehicle-Capacity').innerHTML=detail[6];
       		   }       
              }
             });
           }
       });
     }      
 });  */
	

    </script>
  </body>
</html>

<%} else {%>

<br/><br/>


  </body>
</html>


	<%}%>
