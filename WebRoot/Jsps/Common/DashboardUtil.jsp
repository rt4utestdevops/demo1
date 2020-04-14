<%@page language="java" import="java.util.*,t4u.functions.HomeScreenFunctions,t4u.functions.CommonFunctions,t4u.beans.*,t4u.common.*" pageEncoding="utf-8"%>
<%@ taglib uri="http://packtag.sf.net" prefix="pack" %>
<%@page import="t4u.functions.AlertFunctions"%>

<%	
	
	String basePath = request.getScheme() + "://"+ request.getServerName() + ":" + request.getServerPort()+"/";
	CommonFunctions cf=new CommonFunctions();
	cf.checkLoginInfo((LoginInfoBean)session.getAttribute("loginInfoDetails"),session,request,response);
	LoginInfoBean loginInfo=(LoginInfoBean)session.getAttribute("loginInfoDetails");
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
	
	String userAuthority = cf.getUserAuthority(systemId,userId);
	if(request.getParameter("id")!=null)
	{
		totalVehicles=Integer.parseInt((String)request.getParameter("id"));
	} else if(request.getParameter("id") == null && systemId == 261 && isLTSP == -1){
		totalVehicles = cf.getVehicleCount(customerId,systemId,userId);
	}
	String language=loginInfo.getLanguage();
	String userName=(String)session.getAttribute("userName");
	HomeScreenFunctions homeScreenFunctions = new HomeScreenFunctions();
	AlertFunctions alertFunctions=new AlertFunctions();
	int distressCount=alertFunctions.getDistrssAlertCount(loginInfo.getOffsetMinutes(),customerId,systemId,userId);
	String path = request.getContextPath();
	HashMap<Object, Object> verticalMenus = homeScreenFunctions.getVerticalMenus(path, systemId, customerId, userId,processId,language,totalVehicles);
	HashMap<Object, Object> horizontalMenus = homeScreenFunctions.getHorizontalMenus(systemId, customerId, userId,processId,language);
	ArrayList<Integer> horizontalMenusSubId = (ArrayList<Integer>)horizontalMenus.get("horizontalMenusSubId");

%>
<!DOCTYPE html>
<html lang="en" class="no-js">
	<head>
		<meta charset="UTF-8" />
		<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1"> 
		<meta name="viewport" content="width=device-width, initial-scale=1.0"> 
		<title><%= verticalMenus.get("verticalName")%></title>
		
		
	
		<script src="../../Main/Js/modernizr.custom.js"></script>
		<script src="../../Main/modules/common/homeScreen/js/digitalTimer.js"></script>
		
		<script src="../../Main/Js/jquery.js"></script>
        <script src="../../Main/Js/jquery-ui.js"></script>
        <style>
        #jspPageId{
			width: 100%;
			height: 656px !important;
			padding-top:63px !important;
		}


        </style>
		</head>	
	<body>		
		<script src="../../Main/modules/common/homeScreen/js/classie.js"></script>
		
		<script>		
		//Code to load default image.
		var changepassword = false;	
 
		function getVerticalMenus(menu, processId){
				//closeSearchPopUp();
				var subProcessId="#"+processId;
				var menuId="'"+menu+"'";
				if(firstLoad>0) {
				
				if(processId==<%=verticalMenus.get("defaultLinkId")%>){
				firstLoad=0;															
				getJSPPage('<%=verticalMenus.get("defaultLink")%>', '#list1');
				   $(subProcessId).removeAttr('onclick');
				   setTimeout(function(){				   			   		
				     $(subProcessId).attr('onclick',"getVerticalMenus("+menuId+","+processId+")");
				      }, 6000);
				}			
				
				if(processId == <%=verticalMenus.get("liveVisionProcessId")%>){
					firstLoad=0;
					var systemId = '<%=systemId%>';
					var totalVeh = <%=totalVehicles%>;
					var userId = <%=userId%>;
					if(totalVeh > 4000 && systemId == 261){
						$('#jspPageId').attr('src','/Telematics4uApp/Jsps/Common/LiveVisionWithTableData.jsp');
					}
					else if(systemId == 257 && userId == 198){
						$('#jspPageId').attr('src','/Telematics4uApp/Jsps/Common/HistoryAnalysis.jsp');
					}
					else{
						$('#jspPageId').attr('src','<%=verticalMenus.get("liveVisionPath")%>');
					}
				}
				}
					
			if('<%=horizontalMenusSubId.size() > 0%>') {
				$(menu).addClass('active');
				for(var i = 1; i<='<%=horizontalMenusSubId.size()%>'; i++) {
					if(menu != '#menu'+i)	
						$('#menu'+i).removeClass('active');
				}
			
				for(var i = 1; i<='<%=verticalMenus.get("verticalMenusCount")%>'; i++) {	
					$('#list'+i).removeClass('active');
				}
				
				var j=<%=horizontalMenusSubId.get(0)%>;
				for(var i=j;i<='<%=horizontalMenusSubId.get(horizontalMenusSubId.size()-1)%>' ;i++){				
					if(processId == i){	
						$('#div'+i).show();
					}  else {
						$('#div'+i).hide();
					}
				}
			}
			
			if(firstLoad>0) {
				var hideTimer=null;	
				$('#gn-menu-wrapper-id').removeClass('gn-menu-wrapper');
				$('#gn-menu-wrapper-id').addClass('gn-menu-wrapper gn-open-all');
					hideTimer = setTimeout(function() { 
    		    	  	$('#gn-menu-wrapper-id').removeClass('gn-menu-wrapper gn-open-all');
       					$('#gn-menu-wrapper-id').addClass('gn-menu-wrapper');
       					}, 4000);			
				
				$("#gn-menu-wrapper-id").bind({mouseenter:function() {
					if (hideTimer !== null) {
        				clearTimeout(hideTimer);
    			       }  
                  	},mouseleave:function(){
	                    $('#gn-menu-wrapper-id').removeClass('gn-menu-wrapper gn-open-all');
						$('#gn-menu-wrapper-id').addClass('gn-menu-wrapper');
						           
                  	 }
                 });	
			}
			firstLoad=1;	
		}




		</script>		
	</body>
</html>