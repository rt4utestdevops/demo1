<%@ page language="java" import="java.util.*" pageEncoding="ISO-8859-1"%>
<%@page import="t4u.functions.CommonFunctions"%>
<%@page import="t4u.beans.LoginInfoBean"%>
<%@page import="t4u.functions.ContainerCargoManagementFunctions"%>
<%@page import="t4u.beans.PTDashboardVehicleBean"%>
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
ArrayList<PTDashboardVehicleBean> idleVehDetails =  ccmFun.getDAIdleVehicleDetailsWithDuration(systemId, customerId, offset);
ArrayList<Object> listOfAssignedVehiclesDetails =  ccmFun.getDAAssignedVehicleDetails(systemId, customerId, offset);
ArrayList<PTDashboardVehicleBean> reachedConsigneeVehDetails =  ccmFun.getDAReachedConsigneeVehicleDetails(systemId, customerId, offset);
ArrayList<PTDashboardVehicleBean> onTripVehDetails =  ccmFun.getDAOnTripVehicleDetails(systemId, customerId, offset);
ArrayList<String> dateWiseNoOfTrips =  ccmFun.getNumberOfTripsInLastMonths(systemId, customerId, offset);

String noOfTrips0 = "0";
String noOfTrips1 = "0"; 
String noOfTrips2 = "0"; 

String date0 = "";
String date1 = ""; 
String date2 = ""; 

for(int i=0; i<dateWiseNoOfTrips.size(); i=i+2){
	if(i == 0) {
		noOfTrips0 = dateWiseNoOfTrips.get(i);
		date0 = dateWiseNoOfTrips.get(i+1);
	}
	if(i == 2) {
		noOfTrips1 = dateWiseNoOfTrips.get(i);
		date1 = dateWiseNoOfTrips.get(i+1);
	}
	if(i == 4) {
		noOfTrips2 = dateWiseNoOfTrips.get(i);
		date2 = dateWiseNoOfTrips.get(i+1);
	}
}
%>

<jsp:include page="../Common/header.jsp" /> 
	<title>Dashboard Analytics</title>
	<style>
		//.footer {bottom : -15px !important;}
	</style>
  <script type="text/javascript">

	setInterval(
		function(){ 
		$("#container-fluid").mask();
		location.reload();
		$("#container-fluid").unmask();
		}, 
	300000);
	
  window.onload = function () {
  	CanvasJS.addColorSet("colorShades",
                [//colorSet Array

               "#FF0000","#00CC00","#3333FF","#B32D00","#000080","#008000","#008FB3","#2E5CB8","#0059B3","#FFFF00","#800000","#993366","#862D86","#9900CC","#666633","#B32D00","#2D8659","#006699","#B38600","#CC7A00","#B30086","#E60073","#0086B3","#862D59"              
                ]);
  	var idledps;
  	var assignedVehdps ;
  	var reaConsdps ;
  	var onTripdps;
 
  	<%
  	 String idlePoints = "";
  	 for(int i=0; i<idleVehDetails.size(); i++){
  	 	PTDashboardVehicleBean bean = idleVehDetails.get(i);
  		idlePoints = idlePoints + "{label:" + "\"" + bean.getAssetNo() + "\"" + ",y:" + bean.getDuration() + ",indexLabel:" +"\""+ bean.getDuration()+"\"" + ",indexLabelPlacement:" + "\""+"inside"+"\"" + "}," ;
  	}
  	if(idlePoints.length() > 0) {
		idlePoints = idlePoints.substring(0,idlePoints.lastIndexOf(","));
	}
  	%>
  	idledps = [<%=idlePoints%>];
  	
  	//---------------------------------assigned vehicle points--------------------------------------------
  	<%
  	String assignedVehPoints = "";
  	for(int i=0; i<listOfAssignedVehiclesDetails.size(); i++){
  		assignedVehPoints = assignedVehPoints + "{name:" + "\"" + listOfAssignedVehiclesDetails.get(i) + "\"" + ",y:" + listOfAssignedVehiclesDetails.get(++i) + ",indexLabelPlacement:" + "\"" + listOfAssignedVehiclesDetails.get(i) + "\"" + "}," ;
	}
	if(assignedVehPoints.length() > 0) {
		assignedVehPoints = assignedVehPoints.substring(0,assignedVehPoints.lastIndexOf(","));
	}
  	%>
  	assignedVehdps = [<%=assignedVehPoints%>];
  	
    var chartUnassignedVehicles = new CanvasJS.Chart("unassignedVehicles",
    {
      colorSet: "colorShades",
      width:520,
      title:{
      text: "Unassigned Vehicles(Hrs)"  //**Change the title here
      },
      data: [
		  {        
			type: "column",
			dataPoints : idledps     
		  }
      ]
    });

    chartUnassignedVehicles.render();

	var chartAssignedVehicles = new CanvasJS.Chart("assignedVehicles",
    {
      colorSet: "colorShades",
      title:{
        text: "Assigned Vehicles"
      },
      data: [
      {
       showInLegend: true,
       indexLabelPlacement: "outside",
       type: "doughnut",
       dataPoints: assignedVehdps
     }
     ]
   });

    chartAssignedVehicles.render();
    
    <% String reaConsPoints = "";
    	for(int i=0; i<reachedConsigneeVehDetails.size(); i++){
    		PTDashboardVehicleBean bean = reachedConsigneeVehDetails.get(i);
		    reaConsPoints = reaConsPoints + "{label:" + "\"" + bean.getAssetNo() + "\"" + ",y:" + bean.getDuration() +" ,indexLabel:" +"\""+ bean.getDuration()+"\"" + ",indexLabelPlacement:" + "\""+"inside"+"\"" + "}," ;
    	}
    	if(reaConsPoints.length() > 0) {
			reaConsPoints = reaConsPoints.substring(0,reaConsPoints.lastIndexOf(","));
		}
    %>
    
	reaConsdps = [<%=reaConsPoints%>];
	var chartReachedConsignee = new CanvasJS.Chart("reachedConsignee",
    {
      colorSet: "colorShades",
      title:{
      text: "Reached Consignee(Hrs)"  //**Change the title here
      },
      data: [
		  {        
			type: "column",
			//color: "#80bfff",
			dataPoints : reaConsdps      
		  }
      ]
    });
	chartReachedConsignee.render();
	
    <% String onTripPoints = "";
   	for(int i=0; i<onTripVehDetails.size(); i++){
   	PTDashboardVehicleBean bean = onTripVehDetails.get(i);
	    onTripPoints = onTripPoints + "{label:" + "\"" + bean.getAssetNo() + "\"" + ",y:" + bean.getDuration() + " ,indexLabel:" +"\""+ bean.getDuration()+"\"" + ",indexLabelPlacement:" + "\""+"inside"+"\"" + "}," ;
   	}
   	if(onTripPoints.length() > 0) {
		onTripPoints = onTripPoints.substring(0,onTripPoints.lastIndexOf(","));
	}
    %>
	onTripdps = [<%=onTripPoints%>];
	var chartTransitDuration = new CanvasJS.Chart("transitDuration",
    {
      colorSet: "colorShades",
      title:{
        text: "Transit Duration(Hrs)"
      },
      data: [
      {
        type: "bar",
        dataPoints: onTripdps
      }
      ]
    });

	chartTransitDuration.render();
	
  }
  
  </script>

	<link rel="stylesheet" href="../../Main/modules/ContainerCargoManagement/dashBoard/bootstrap.min.css" type="text/css"></link>
    <link rel="stylesheet" href="../../Main/modules/ContainerCargoManagement/dashBoard/css/main.css"></link> 
	
	<script type="text/javascript" src="../../Main/Js/jquery.min.js"></script>
	<script type="text/javascript" src="../../Main/Js/bootstrap.min.js"></script>  
	<script type="text/javascript" src="https://canvasjs.com/assets/script/canvasjs.min.js"></script>   
	<script src="../../Main/Js/jquery.js"></script>

 
   
<div class="analyticsBody">
	<div class="container-fluid" id="container-fluid">
		<div class="row">
			<div class="col-sm-6" style="right">
				<div id="unassignedVehicles" style="height: 300px; width: 100%;"></div>
			</div>
			
			<div class="col-sm-6">
				<div id="assignedVehicles" style="height: 300px; width: 100%;"></div>
			</div>
		</div>

		<div class="row">
			<div class="col-sm-6">
				<div id="reachedConsignee" style="height: 300px; width: 100%;"></div>
			</div>

			<div class="col-sm-6">
					<div id="transitDuration" style="height: 300px; width: 100%;"></div>
			</div>
		</div>
		
		<table class="table borderless">    
			<tbody>
				<tr><td class="blank_row"></td></tr>
				<tr>
					<td>
						<table class="t1">
						<thead><tr><th>Date</th><th>No. Of Trips</th></tr></thead>
						<tbody><tr><td><%=date0%></td><td><%=noOfTrips0%></td></tr></tbody>				
						</table>
					</td>
					<td> </td>
					<td>
						<table class="t1">
						<thead><tr><th>Date</th><th>No. Of Trips</th></tr></thead>
						<tbody><tr><td><%=date1%></td><td><%=noOfTrips1%></td></tr></tbody>				
						</table>
					</td>
					<td> </td>
					<td>
						<table class="t1">
						<thead><tr><th>Date</th><th>No. Of Trips</th></tr></thead>
						<tbody><tr><td><%=date2%></td><td><%=noOfTrips2%></td></tr></tbody>				
						</table>
					</td>
				</tr>
			</tbody>
		</table>
  </div>
</div>
 <jsp:include page="../Common/footer.jsp" />
 <!-- </body>   -->
 <!-- </html> -->