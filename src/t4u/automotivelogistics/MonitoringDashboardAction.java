package t4u.automotivelogistics;


import java.text.SimpleDateFormat;
import java.util.ArrayList;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.struts.action.Action;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.json.JSONArray;
import org.json.JSONObject;

import t4u.beans.LoginInfoBean;
import t4u.beans.ReportHelper;
import t4u.functions.AutomotiveLogisticsFunction;

public class MonitoringDashboardAction extends Action{
	public ActionForward execute(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) {
		HttpSession session = request.getSession();
		String param = "";
		int systemId = 0;
		int userId = 0;
		int clientId = 0;
		String zone = "";	
		String  message="";
		LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");		
		systemId = loginInfo.getSystemId();
		userId = loginInfo.getUserId();
		clientId = loginInfo.getCustomerId();
		int offset = loginInfo.getOffsetMinutes();
		zone = loginInfo.getZone();	
		JSONArray jsonArray = null;
		JSONObject jsonObject = null;
		AutomotiveLogisticsFunction logisticsFunction = new AutomotiveLogisticsFunction();
		
		if (request.getParameter("param") != null) {
			param = request.getParameter("param").toString();
		}
		if (param.equalsIgnoreCase("getSourceDestination")) {
			jsonObject = new JSONObject();
			jsonArray = new JSONArray();
			try {
				jsonArray = logisticsFunction.getSourdeDestination(clientId, systemId, zone);				
				if(jsonArray.length()>0){
					jsonObject.put("locationRoot",jsonArray);
				}else{
					jsonObject.put("locationRoot","");
				}
				response.getWriter().print(jsonObject.toString());	
			} catch (Exception e) {
				e.printStackTrace();
			}
		}	
		else if (param.equalsIgnoreCase("getDashboardCount")) {
			try {
				String fromLocation = "";
				String toLocation = "";	
				String fromDate = request.getParameter("fromDate");			
				fromDate = fromDate.replace('T', ' ');
				String toDate = request.getParameter("toDate");
				toDate = toDate.replace('T', ' ');			
				String type = request.getParameter("type");
				if(request.getParameter("fromLocationId") != null && !request.getParameter("fromLocationId").equals("") && request.getParameter("toLocationId")!=null && !request.getParameter("toLocationId").equals("")){
					fromLocation = request.getParameter("fromLocationId");
					toLocation = request.getParameter("toLocationId");
				}else{
					fromLocation = request.getParameter("fromLocation");
					toLocation = request.getParameter("toLocation");
				}				
				jsonObject = new JSONObject();
				jsonArray = new JSONArray();
				if(!fromDate.equals("") && fromDate !=null && !toDate.equals("") && toDate !=null && !type.equals("") && type != null && fromLocation != null && toLocation != null){
					int fromLocationId = Integer.parseInt(fromLocation);
					int toLocationId = Integer.parseInt(toLocation);
					jsonArray = logisticsFunction.getDashboardCount(fromDate,toDate,type,fromLocationId,toLocationId,clientId, systemId,userId);	
					if(jsonArray.length()>0){
						jsonObject.put("dashboardCountRoot",jsonArray);
					}else{
						jsonObject.put("dashboardCountRoot","");
					}
				}else{
					jsonObject.put("dashboardCountRoot","");
				}
					response.getWriter().print(jsonObject.toString());	
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		
		else if (param.equalsIgnoreCase("getDashboardOverspeedCount")) {
			try {
				String fromDate = request.getParameter("fromDate");			
				fromDate = fromDate.replace('T', ' ');
				String toDate = request.getParameter("toDate");
				toDate = toDate.replace('T', ' ');			
				jsonObject = new JSONObject();
				jsonArray = new JSONArray();
				if(!fromDate.equals("") && fromDate !=null && !toDate.equals("") && toDate !=null){
					jsonArray = logisticsFunction.getDashboardCountOverspeed(fromDate,toDate,clientId, systemId,userId);	
					if(jsonArray.length()>0){
						jsonObject.put("dashboardCountOverSpeed",jsonArray);
					}else{
						jsonObject.put("dashboardCountOverSpeed","");
					}
				}else{
					jsonObject.put("dashboardCountOverSpeed","");
				}
					response.getWriter().print(jsonObject.toString());	
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		
		else if (param.equalsIgnoreCase("getDashboardStoppageCount")) {
			try {
				String fromDate = request.getParameter("fromDate");			
				fromDate = fromDate.replace('T', ' ');
				String toDate = request.getParameter("toDate");
				toDate = toDate.replace('T', ' ');			
				jsonObject = new JSONObject();
				jsonArray = new JSONArray();
				if(!fromDate.equals("") && fromDate !=null && !toDate.equals("") && toDate !=null){
					jsonArray = logisticsFunction.getDashboardStoppageCount(fromDate,toDate,clientId, systemId,userId);	
					if(jsonArray.length()>0){
						jsonObject.put("dashboardCountStoppage",jsonArray);
					}else{
						jsonObject.put("dashboardCountStoppage","");
					}
				}
				else{
					jsonObject.put("dashboardCountStoppage","");
				}
					response.getWriter().print(jsonObject.toString());	
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		else if (param.equalsIgnoreCase("getVehicleDetailsForDashboard")) {
			try {

				ArrayList list=null;
				String jspName = request.getParameter("jspName");
			jsonObject = new JSONObject();
			jsonArray = new JSONArray();
			SimpleDateFormat yyyymmdd = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			SimpleDateFormat ddmmyyyy = new SimpleDateFormat("dd-MM-yyyy");
			String fromDate = request.getParameter("fromDate");			
			String toDate = request.getParameter("toDate");
			String type = request.getParameter("type");
			String fromLocation = "";
			String toLocation = "";
			String fromLocation1=request.getParameter("fromLocationName");
			String toLocation1=request.getParameter("toLocationName");
			String FromLocation=request.getParameter("FromLocation");
			String ToLocation=request.getParameter("ToLocation");
			if(request.getParameter("fromLocationId") != null && !request.getParameter("fromLocationId").equals("") && request.getParameter("toLocationId") != null && !request.getParameter("toLocationId").equals("")){
				fromLocation = request.getParameter("fromLocationId");
				toLocation = request.getParameter("toLocationId");
			}else{
				fromLocation = request.getParameter("fromLocation");
				toLocation = request.getParameter("toLocation");
			}
			if(request.getParameter("fromLocationName") != null && !request.getParameter("fromLocationName").equals("") && request.getParameter("toLocationName") != null && !request.getParameter("toLocationName").equals("")){
				fromLocation1 = request.getParameter("fromLocationName");
				toLocation1 = request.getParameter("toLocationName");
			}else{
				fromLocation1 = request.getParameter("FromLocation");
				toLocation1 = request.getParameter("ToLocation");
			}
			String tripStatus = request.getParameter("tripStatus");
			if(fromDate !=null && toDate !=null && type != null && fromLocation !=null && toLocation !=null && fromLocation1 != null && toLocation1 !=null ){
				fromDate = fromDate.replace('T', ' ');
				toDate = toDate.replace('T', ' ');
				int fromLocationId = Integer.parseInt(fromLocation);
				int toLocationId = Integer.parseInt(toLocation);
				fromLocation1 = fromLocation1;
				toLocation1 = toLocation1;
				list = logisticsFunction.getVehicleDetailsForDashboard(fromDate,toDate,type,fromLocationId,toLocationId,clientId, systemId,userId,tripStatus);
				jsonArray = (JSONArray) list.get(0);
				if(jsonArray.length()>0){
					jsonObject.put("detailsRoot",jsonArray);
				}else{
					jsonObject.put("detailsRoot","");
				}
				ReportHelper reportHelper = (ReportHelper) list.get(1);
				request.getSession().setAttribute(jspName,reportHelper);
				request.getSession().setAttribute("FromDate", ddmmyyyy.format(yyyymmdd.parse(fromDate)));
		     	request.getSession().setAttribute("ToDate",ddmmyyyy.format(yyyymmdd.parse(toDate)));
		     	request.getSession().setAttribute("FromLocation", fromLocation1);
		     	request.getSession().setAttribute("ToLocation", toLocation1);
		     	request.getSession().setAttribute("Type", type);
		     	request.getSession().setAttribute("TripStatus", tripStatus);

			}else{
				jsonObject.put("detailsRoot","");
			}
				response.getWriter().print(jsonObject.toString());	
			} catch (Exception e) {
				e.printStackTrace();
			}
		}		
		else if (param.equalsIgnoreCase("getTransitPointForTrip")) {
			try {
			jsonObject = new JSONObject();
			jsonArray = new JSONArray();
			if(request.getParameter("vehicleNo") != null && !request.getParameter("vehicleNo").equals("") && request.getParameter("shipmentId") != null && !request.getParameter("shipmentId").equals("")){
				String vehicleNo = request.getParameter("vehicleNo");
				String shipmentId = request.getParameter("shipmentId");
				jsonArray = logisticsFunction.getTransitPointForTrip(vehicleNo,shipmentId,systemId,clientId,offset);		
				if(jsonArray.length()>0){
					jsonObject.put("TransitPointForTripRoot",jsonArray);
				}else{
					jsonObject.put("TransitPointForTripRoot","");
				}
			}else{
				jsonObject.put("TransitPointForTripRoot","");
			}
				response.getWriter().print(jsonObject.toString());	
			} catch (Exception e) {
				e.printStackTrace();
			}
		}else if(param.equalsIgnoreCase("insertRemarks")){
			try{
			if(request.getParameter("ID") != null && request.getParameter("remarks") != null && request.getParameter("actionStatus") != null && request.getParameter("tripid") != null && request.getParameter("issues") != null){
				int ID = Integer.parseInt(request.getParameter("ID"));
				int tripid = Integer.parseInt(request.getParameter("tripid"));
				String remarks = request.getParameter("remarks");
				String actionStatus = request.getParameter("actionStatus");	
				String issues = request.getParameter("issues");
				message = logisticsFunction.insertRemarks(ID,remarks,actionStatus,tripid,issues);				
			}
			response.getWriter().print(message);	
			}catch(Exception e){
				e.printStackTrace();
			}
		}
		else if(param.equalsIgnoreCase("getIssuesList")){
			jsonObject = new JSONObject();
			jsonArray = new JSONArray();
			try {
				jsonArray = logisticsFunction.getIssueList();				
				if(jsonArray.length()>0){
					jsonObject.put("issuesRoot",jsonArray);
				}else{
					jsonObject.put("issuesRoot","");
				}
				response.getWriter().print(jsonObject.toString());					
			}catch(Exception e){
				e.printStackTrace();
			}
		}
		

		else if (param.equals("getAlertDetails")) {
			try {
				String alertId = request.getParameter("alertId");
				String fromdate= request.getParameter("fromdate");
				String todate= request.getParameter("todate");
				String fromDashboard= request.getParameter("fromDashboard");
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				jsonArray = logisticsFunction.getAlertDetails(offset, alertId,systemId, clientId, userId,fromdate,todate,fromDashboard);
				if (jsonArray.length() > 0) {
					jsonObject.put("AlertDetailsRoot", jsonArray);
				} else {
					jsonObject.put("AlertDetailsRoot", "");
				}
				response.getWriter().print(jsonObject.toString());
			}
			catch (Exception e) {
				e.printStackTrace();
			}
		}
		else if (param.equals("getCloseTrip")) {
			message= "Trip not closed" ;
			try {
				String shipmentId = request.getParameter("shipmentId");
				String tripId = request.getParameter("tripId");
				String vehicleNo = request.getParameter("vehicleNo");
				if(tripId!=null && !tripId.equals("") && shipmentId!=null && !shipmentId.equals("")){
				message = logisticsFunction.getCloseTrip(offset,systemId, clientId, userId,shipmentId,tripId,vehicleNo);
				}
				response.getWriter().print(message);
			}
			catch (Exception e) {
				e.printStackTrace();
			}
		}
		
		
		return null;
	}

}
