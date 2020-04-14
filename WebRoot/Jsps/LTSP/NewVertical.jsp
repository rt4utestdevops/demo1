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
	String verticals="";
	LTSPFunctions ltspfunc=new LTSPFunctions();
	String verticalComponents=ltspfunc.getLTSPNewVerticals(systemId,language); 	 
	String newVerticals=cf.getLabelFromDB("New_Vertical",language).toUpperCase();
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html class="no-js" lang="en">
	<head>
		<meta charset="UTF-8" />
		<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
		<title>New Verticals</title>
		<link rel="stylesheet" type="text/css" href="../../Main/modules/LTSP/css/component.css" />
		<pack:script src="../../Main/adapter/ext/ext-base.js"></pack:script>
		<pack:script src="../../Main/Js/ext-all-debug.js"></pack:script>
		<pack:script src="../../Main/Js/jquery.min.js"></pack:script>
		<pack:script src="../../Main/resources/ux/gridfilters/menu/RangeMenu.js"></pack:script>
		<pack:script src="../../Main/resources/ux/gridfilters/menu/ListMenu.js"></pack:script>
		<pack:script src="../../Main/resources/ux/gridfilters/GridFilters.js"></pack:script>
		<pack:script src="../../Main/resources/ux/gridfilters/filter/Filter.js"></pack:script>
		<pack:script src="../../Main/resources/ux/gridfilters/filter/StringFilter.js"></pack:script>
		<pack:script src="../../Main/resources/ux/gridfilters/filter/DateFilter.js"></pack:script>
		<pack:script src="../../Main/resources/ux/gridfilters/filter/ListFilter.js"></pack:script>
		<pack:script src="../../Main/resources/ux/gridfilters/filter/NumericFilter.js"></pack:script>
		<pack:script src="../../Main/resources/ux/gridfilters/filter/BooleanFilter.js"></pack:script>
		<pack:style src="../../Main/resources/ux/gridfilters/css/GridFilters.css" />
		<pack:style src="../../Main/resources/ux/gridfilters/css/RangeMenu.css" />
		<pack:style src="../../Main/resources/css/ext-all.css" />
		<pack:style src="../../Main/resources/css/chooser.css" />
		<link rel="stylesheet" type="text/css" href="../../Main/modules/LTSP/theme/css/EXTJSExtn.css" /> 
	</head>
	<body>	
	<div class="container">
	<div class="header" id="header">
	<h1>
				<span><%= newVerticals %></span>
			</h1>
	</div>
	<div class="main-pannel" id="main-pannel">
		<div class="newveritcal-panel" id="vertical-panel">
		<div class="newvertical-details" id="vertical-details">
			<%=verticalComponents%>
		</div>				
		</div>
		</div>
		</div>

	<script type="text/javascript">
	
	if('<%=language%>'=='ar'){
	document.documentElement.setAttribute("dir", "rtl");
	}else if('<%=language%>'=='en'){
	document.documentElement.setAttribute("dir", "ltr");
	}
	
	 function showDetails(processId,processName,index)
	 {
	 var value = index % 4;	
    var  myWin = new Ext.Window({			        
			        closable: true,
			        modal: true,
			        resizable:true,
			        closeAction:'close',
			        autoScroll: true,
			        height: 500,
        			width: '68%',	
			        id     : 'myWin',
			        items  : [
								{xtype: 'panel',
								 id:'panelId',
								 height:450,
								 html : "<iframe width ='99%' height='470px' src='<%=request.getContextPath()%>/Jsps/LTSP/ReadMoreWindow.jsp?value="+value+"&processId="+processId+"'></iframe>"
								}
					]
			    });
			    
     myWin.show();	
     }
     
     function getVerticalDetails(processId,processName,index)
     {			   
     	
     }		    
	</script>

</body>
</html>