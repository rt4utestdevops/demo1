<%@ page language="java" pageEncoding="utf-8"%>
<%@page import="java.util.HashMap"%>
<%@page import="t4u.functions.ContainerCargoManagementFunctions"%>
<%@page import="t4u.functions.CommonFunctions"%>
<%@page import="t4u.beans.LoginInfoBean"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.Map"%>
<%@ taglib uri="http://packtag.sf.net" prefix="pack"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme() + "://"
		+ request.getServerName() + ":" + request.getServerPort()
		+ path + "/";

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
	loginInfo.setStyleSheetOverride("N");
	if(str.length>8){
	loginInfo.setCustomerName(str[8].trim());
	}
	session.setAttribute("loginInfoDetails",loginInfo);
}

CommonFunctions cf=new CommonFunctions();
cf.checkLoginInfo((LoginInfoBean)session.getAttribute("loginInfoDetails"),session,request,response);
LoginInfoBean loginInfo=(LoginInfoBean)session.getAttribute("loginInfoDetails");
session.setAttribute("loginInfoDetails", loginInfo);
String language = loginInfo.getLanguage();
int systemId=loginInfo.getSystemId();
String systemID=Integer.toString(systemId);
int customerId=loginInfo.getCustomerId();
int offset = loginInfo.getOffsetMinutes();
int custidpassed=0;
if(request.getParameter("cutomerIDPassed")!= null)
{
	customerId=Integer.parseInt(request.getParameter("cutomerIDPassed"));
}

ContainerCargoManagementFunctions ccmFun = new ContainerCargoManagementFunctions();
HashMap<String, Integer> listOfVehicles =  ccmFun.getVehicleCountWithStatus(systemId, customerId, offset);
int countOfIdleVehicles = listOfVehicles.get("Idle Vehicle");
int countOfAssignedVehicles = listOfVehicles.get("Assigned Vehicle"); 
int countOfOnTripVehicles = listOfVehicles.get("On Trip");
int countOfReachedConsigneeVehicles = listOfVehicles.get("Reached Consignee");
int underMaintenance = listOfVehicles.get("Under Repair");
int repaired = listOfVehicles.get("Repaired");
int countOfMaintenance = underMaintenance + repaired;

ArrayList<String> idleVehDetails =  ccmFun.getIdleVehicleDetails(systemId, customerId, offset);

Map<String, ArrayList<String>> listOfAssignedVehiclesDetails =  ccmFun.getAssignedVehicleDetails(systemId, customerId, offset);

ArrayList<String> onTripVehDetails =  ccmFun.getOnTripVehicleDetails(systemId, customerId, offset);

ArrayList<String> reachedConsigneeVehDetails =  ccmFun.getReachedConsigneeVehicleDetails(systemId, customerId, offset);
ArrayList<String> underMaintenanceVehDetails = ccmFun.getUnderMaintenanceVehicleDetails(systemId, customerId, offset);
ArrayList<String> repairedVehDetails = ccmFun.getRepairedVehicleDetails(systemId, customerId, offset);
%>
<jsp:include page="../Common/header.jsp" />
    <title>Dashboard</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="">
    <meta name="author" content="Carlos Alvarez - Alvarez.is">
	
	<link rel="stylesheet" href="../../Main/modules/ContainerCargoManagement/dashBoard/bootstrap.min.css" type="text/css"></link>
    <link rel="stylesheet" href="../../Main/modules/ContainerCargoManagement/dashBoard/css/main.css"></link> 
	
    <script src="../../Main/Js/jquery.js"></script>
	<script type="text/javascript" src="../../Main/Js/bootstrap.min.js"></script>   
	<pack:script src="../../Main/Js/jQueryMask.js"></pack:script>
    <pack:style src="../../Main/modules/common/jquery.loadmask.css" />
    <style type="text/css">
      body {
        padding-top: 60px;
      }
	  @media (min-width: 1200px){
		.col-lg-2 {
			width: 20%;
		}
	}
    </style>
    <!-- Le HTML5 shim, for IE6-8 support of HTML5 elements -->
    <!--[if lt IE 9]>
      <script src="http://html5shim.googlecode.com/svn/trunk/html5.js"></script>
    <![endif]-->   
 
    <div class="container-fluid" id="container-fluid">
	  <!-- FIRST ROW OF BLOCKS -->     
      <div class="row">
        <div class="col-sm-2 col-lg-2">
      		<div class="first-row-dash-unit">
				<div class="textCenter">
					<h1>Unassigned Vehicles</h1>
				</div>
				<hr/>
				<div class="textCenter">
					<h2 id="countOfIdleVehicles"></h2>
				</div>
			</div>
        </div>
        <div class="col-sm-2 col-lg-2">
      		<div class="first-row-dash-unit">
				<div class="textCenter">
					<h1>Assigned Vehicles</h1>
				</div>
				<hr/>
				<div class="textCenter">
					<h2 id="countOfAssignedVehicles"></h2>
				</div>
			</div>
        </div>
        <div class="col-sm-2 col-lg-2">
      		<div class="first-row-dash-unit">
				<div class="textCenter">
					<h1>On Trips Vehicles</h1>
				</div>
				<hr/>
				<div class="textCenter">
					<h2 id="countOfOnTripVehicles"></h2>
				</div>
			</div>
        </div>        
        <div class="col-sm-2 col-lg-2">
      		<div class="first-row-dash-unit">
				<div class="textCenter">
					<h1>Reached Consignee</h1>
				</div>
				<hr/>
				<div class="textCenter">
					<h2 id="countOfReachedConsigneeVehicles"></h2>
				</div>
			</div>
        </div>
		<div class="col-sm-2 col-lg-2">
      		<div class="first-row-dash-unit">
				<div class="textCenter">
					<h1>Maintenance</h1>
				</div>
				<hr/>
				<div class="textCenter">
					<h2 id="maintenance"></h2>
				</div>
			</div>
        </div>
      </div>
	  <!-- /row -->
      <!-- SECOND ROW OF BLOCKS -->      
      <div class="row">
        <div class="col-sm-2 col-lg-2">
      		<div class="dash-unit" id="dash-unit-x">
		  		
			</div>
        </div>
        <div class="col-sm-2 col-lg-2">
      		<div class="dash-unit" id="dash-unit-y">
		  		
			</div>
        </div>
        <div class="col-sm-2 col-lg-2">
      		<div class="dash-unit" id="dash-unit-z">
		  		
			</div>
        </div>
        <div class="col-sm-2 col-lg-2">
      		<div class="dash-unit" id="dash-unit-a">
		  		
			</div>
        </div>
		<div class="col-sm-2 col-lg-2">
      		<div class="dash-unit" id="dash-unit-b">
		  		
			</div>
        </div>
      </div>
	  <!-- /row -->
	</div> 
	<!-- /container -->    
	<script>
		
	setInterval(
		function(){ 
		$("#container-fluid").mask();
		location.reload();
		$("#container-fluid").unmask();
		}, 
	300000);
	    
		var countOfIdleVehicles = '<%=countOfIdleVehicles%>';
		var countOfAssignedVehicles = '<%=countOfAssignedVehicles%>';
		var countOfOnTripVehicles = '<%=countOfOnTripVehicles%>';
		var countOfReachedConsigneeVehicles = '<%=countOfReachedConsigneeVehicles%>';
		var maintenance = '<%=countOfMaintenance%>';
		var smb = "";
		var urv = "";
		var rv = "";
		var count = 0;
	
		document.getElementById('countOfIdleVehicles').innerHTML = countOfIdleVehicles;
		document.getElementById('countOfAssignedVehicles').innerHTML = countOfAssignedVehicles;
		document.getElementById('countOfOnTripVehicles').innerHTML = countOfOnTripVehicles;
		document.getElementById('countOfReachedConsigneeVehicles').innerHTML = countOfReachedConsigneeVehicles;
		document.getElementById('maintenance').innerHTML = maintenance;
				
		<% for(int i = 0; i < idleVehDetails.size(); i++) { %>
			$("#dash-unit-x").append('<div class="dynaimic_div_x" style="font-size: 11px; font-weight: bold;" id=padma_x_<%=i%>><%=idleVehDetails.get(i)%></div>');
		<%}%>
		
		//Assigned Vehicles
		<%
			for (Map.Entry<String, ArrayList<String>> entry : listOfAssignedVehiclesDetails.entrySet())
			{
				 String compCode = entry.getKey().split(",")[1];
				 ArrayList<String> assignedVeh = entry.getValue();
		%>
				 smb = "";
		<%		 for(int avi = 0; avi < assignedVeh.size(); avi++) {
		%>
			    smb = smb + '<div class="small-box-message" style="font-size: 11px; font-weight: bold;"><strong><%=assignedVeh.get(avi)%></strong></div>';
			    //alert(smb);
		<%
				 }
		%>
			$("#dash-unit-y").append('<div class="dynaimic_div_y" id=padma_y_'+(count++)+'><div class="small-box_y" id="small-box_y"><div class="small-box-name"><%=compCode%></div><div class="small-box-ul">'+smb+'</div></div></div>');
		<%	}
		
		%>
		//On Trip Vehicles
		<% for(int i = 0; i < onTripVehDetails.size(); i++) { %>
			$("#dash-unit-z").append('<div class="dynaimic_div_z" style="font-size: 11px; font-weight: bold;" id=padma_z_<%=i%>><%=onTripVehDetails.get(i)%></div>');
		<%}%>
		
		//Reached Consignee
		<% for(int i = 0; i < reachedConsigneeVehDetails.size(); i++) { %>
			$("#dash-unit-a").append('<div class="dynaimic_div_a" style="font-size: 11px; font-weight: bold;" id=padma_a_<%=i%>><%=reachedConsigneeVehDetails.get(i)%></div>');
		<%}%>
		
		//Under maintenance
		<% for(int i = 0; i < underMaintenanceVehDetails.size(); i++) { %>
			 urv = urv + '<div class="small-box-message" style="font-size: 11px; font-weight: bold;"><strong><%=underMaintenanceVehDetails.get(i)%></strong></div>';
		<%}%>	
		
		//Repaired
		<% for(int i = 0; i < repairedVehDetails.size(); i++) { %>
			 rv = rv + '<div class="small-box-message" style="font-size: 11px; font-weight: bold;"><strong><%=repairedVehDetails.get(i)%></strong></div>';
		<%}%>
		
		$("#dash-unit-b").append('<div class="dynaimic_div_b" id=padma_b_1><div class="small-box_b" id="small-box_b">'+urv+'</div></div>');
		$("#dash-unit-b").append('<div class="dynaimic_div_b" id=padma_b_2><div class="small-box_b" id="small-box_b">'+rv+'</div></div>');

	</script>
 <jsp:include page="../Common/footer.jsp" />
 <!-- </body>   -->
 <!-- </html> -->