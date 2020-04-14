<%@ page language="java" import="java.util.*,t4u.beans.LoginInfoBean,t4u.functions.*" pageEncoding="utf-8"%>
<%@ taglib uri="http://packtag.sf.net" prefix="pack" %>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://"+ request.getServerName() + ":" + request.getServerPort()+ path + "/";
	CommonFunctions cf=new CommonFunctions();
	LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
	int systemId = loginInfo.getSystemId();
	int customerId=loginInfo.getCustomerId();
	int userId=loginInfo.getUserId();
	int offset=loginInfo.getOffsetMinutes();
	String language=loginInfo.getLanguage();
	String alertDiv="";
	String alertID="";
	String alert="";
	String userAuthority = cf.getUserAuthority(systemId,userId);
	if(systemId == 268 && userAuthority.equals("User")){
		response.sendRedirect(request.getContextPath()+"/Jsps/Common/EmptyPage.jsp");
	}else{

	AlertFunctions alertFunctions = new AlertFunctions();
	HashMap<Object, Object> alertComponents = alertFunctions.getAlertComponents(systemId,customerId,userId,offset,language);
	for (Object value : alertComponents.values()) {
    alertDiv=value.toString();
    for ( Map.Entry<Object, Object> entry : alertComponents.entrySet()) {
    alertID= entry.getKey().toString();
    alertDiv = entry.getValue().toString();
	}
	 alert=cf.getLabelFromDB("Alerts",language).toUpperCase();
	}
	
%>

 <jsp:include page="../Common/header.jsp" />
		<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
		<title>Alerts</title>
		<link rel="stylesheet" type="text/css" href="../../Main/modules/common/alerts/css/layout.css" />
		<link rel="stylesheet" type="text/css" href="../../Main/modules/common/alerts/css/component.css" />
		<pack:script src="../../Main/adapter/ext/ext-base.js"></pack:script>
		<pack:script src="../../Main/Js/ext-all-debug.js"></pack:script>
	<style>
	.alertdetails{
		border-top: 9px solid rgba(173, 72, 72, 0) !important;
	}
	.footer {
		//bottom : -16px !important;
	}
	.alertsElements {
    	height: 170px !important;
    }
	</style>
	
	
<!-- 	<body onload="refresh();", oncontextmenu="return false;">  -->
	 	
		<script type="text/javascript">
			window.onload = function () { 
				refresh();
			}
			window.oncontextmenu=function()
			{
				return false;
			}

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

		var alertCount = new Ext.data.JsonStore({
				url: '<%=request.getContextPath()%>/AlertComponent.do?param=getAlertCount',
				id:'AlertCountRoot',
				root: 'AlertCountRoot',
				autoLoad: false,
				remoteSort: true,
				fields: ['alertId','alertCount']
		});
		
		function refresh(){
		alertCount.load({
		params:{alertList:'<%=alertID%>'},
		callback:function()
		{
		for(var i=0;i<alertCount.getCount();i++)
		{
			var rec=alertCount.getAt(i);
			if(document.getElementById('alertId'+rec.data['alertId'])!=null)
			{
			document.getElementById('alertId'+rec.data['alertId']).innerHTML=rec.data['alertCount'];
			}
		}
		var el = document.getElementById('loadImage');
		el.style.display='none';
		var el1 = document.getElementById('alert-mask-id');
		el1.style.display='none';
		}
		});		
		setInterval('getAlertCount()',180000);
		}
		
		function getAlertCount(){			
		var e = document.getElementById('loadImage');
		e.style.display = 'block'; 
		var e1 = document.getElementById('alert-mask-id');
		e1.style.display = 'block'; 
		alertCount.load({
		params:{alertList:'<%=alertID%>'},
		callback:function()
		{
		e.style.display = 'none'; 
		e1.style.display = 'none'; 
		for(var i=0;i<alertCount.getCount();i++)
		{
			var rec=alertCount.getAt(i);
			if(document.getElementById('alertId'+rec.data['alertId'])!=null)
			{
			document.getElementById('alertId'+rec.data['alertId']).innerHTML=rec.data['alertCount'];
			}
		}
		
		}
		});
		}
		
		Ext.Ajax.timeout = 360000;
		function gotoAlertReport(alertId,alertName)
		{
		window.location ="<%=request.getContextPath()%>/Jsps/Common/AlertReport.jsp?AlertId="+alertId+"&AlertName="+alertName;
		}

		</script>
		<div class="container">
		<header>
			<h1>
				<span><%=alert%></span>
			</h1>
			</header>
			<img id="loadImage" src="/ApplicationImages/ApplicationButtonIcons/loader.gif" style="position: absolute;z-index: 4;left: 50%;top: 50%;">
						<div class="alert-mask" id="alert-mask-id">
			</div>
			<div id="container_buttons" class="main clearfix" style="position: relative;margin-bottom: 190px;">
				<%=alertDiv%>
			</div>
		</div>
		<!-- <jsp:include page="../Common/footer.jsp" /> -->
		</div>
	  <jsp:include page="../Common/footer.jsp" />
 <!-- </body>   -->
 <!-- </html> -->
<%} %>