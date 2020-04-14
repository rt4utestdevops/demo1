package t4u.passengerbustransportation;

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
import t4u.functions.CommonFunctions;
import t4u.functions.PassengerBusTransportationFunctions;

public class RateMasterAction extends Action{
	public ActionForward execute(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) {
		HttpSession session = request.getSession();
		String param = "";
		int systemId = 0;
		int userId = 0;
		int clientId = 0;
		
		LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
		
		systemId = loginInfo.getSystemId();
		userId = loginInfo.getUserId();
		clientId = loginInfo.getCustomerId();
		String language=loginInfo.getLanguage();
		
		JSONArray jsonArray = null;
		JSONObject jsonObject = null;
		
		PassengerBusTransportationFunctions func = new PassengerBusTransportationFunctions();
		
		if (request.getParameter("param") != null) {
			param = request.getParameter("param").toString();
		}

		if (param.equalsIgnoreCase("getTerminal")) {
			
			jsonObject = new JSONObject();
			jsonArray = new JSONArray();
			
			clientId = Integer.parseInt(request.getParameter("CustId"));
			
			try {
				jsonArray = func.getTerminalName(systemId, clientId);
				if(jsonArray.length()>0){
					jsonObject.put("TerminalRoot",jsonArray);
				}else{
					jsonObject.put("TerminalRoot","");
				}
				response.getWriter().print(jsonObject.toString());	
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		
		if (param.equalsIgnoreCase("getRouteName")) {
			
			jsonObject = new JSONObject();
			jsonArray = new JSONArray();
			
			clientId = Integer.parseInt(request.getParameter("CustId"));
			int terminalId = Integer.parseInt(request.getParameter("TerminalId"));
			
			try {
				jsonArray = func.getRouteName(systemId, clientId,terminalId);
				if(jsonArray.length()>0){
					jsonObject.put("RouteRoot",jsonArray);
				}else{
					jsonObject.put("RouteRoot","");
				}
				response.getWriter().print(jsonObject.toString());	
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		
		if (param.equalsIgnoreCase("getVehicleModel")) {
			
			jsonObject = new JSONObject();
			jsonArray = new JSONArray();
			
			clientId = Integer.parseInt(request.getParameter("CustId"));
			
			try {
				jsonArray = func.getVehicleModel(systemId, clientId);
				if(jsonArray.length()>0){
					jsonObject.put("VehicleModelRoot",jsonArray);
				}else{
					jsonObject.put("VehicleModelRoot","");
				}
				response.getWriter().print(jsonObject.toString());	
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		
		if (param.equalsIgnoreCase("getSeatingCapacity")) {
			
			jsonObject = new JSONObject();
			jsonArray = new JSONArray();
			
			clientId = Integer.parseInt(request.getParameter("CustId"));
			
			try {
				jsonArray = func.getSeatingCapacity(systemId, clientId);
				if(jsonArray.length()>0){
					jsonObject.put("SeatingCapacityRoot",jsonArray);
				}else{
					jsonObject.put("SeatingCapacityRoot","");
				}
				response.getWriter().print(jsonObject.toString());	
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		
		if (param.equalsIgnoreCase("saveRateMaster")) {
			
			jsonObject = new JSONObject();
			jsonArray = new JSONArray();
			
			String buttonValue = request.getParameter("buttonValue");
			double amount =  Double.parseDouble(request.getParameter("Amount"));
			int terminalId = Integer.parseInt(request.getParameter("TerminalId"));
			int routeId = Integer.parseInt(request.getParameter("RouteId"));
			double distance = Double.parseDouble(request.getParameter("Distance"));
			double duration = Double.parseDouble(request.getParameter("Duration").replace(':', '.'));
			double departureTime = Double.parseDouble(request.getParameter("DepartureTime").replace(':', '.'));
			double arrivalTime = Double.parseDouble(request.getParameter("ArrivalTime").replace(':', '.'));
			int vehicleModelId = Integer.parseInt(request.getParameter("VehicleModelId"));
			int seatingStructureId = Integer.parseInt(request.getParameter("SeatingStructureId"));
			String dayType =  request.getParameter("DayType");
			String status = request.getParameter("Status");
			clientId = Integer.parseInt(request.getParameter("CustId"));
			int id =  Integer.parseInt(request.getParameter("Id"));
			String message = "";
			
			try {
				if(buttonValue.equals("Add"))
					message = func.saveRateMasterDetails(amount, terminalId, routeId, distance, duration, departureTime, arrivalTime, vehicleModelId, seatingStructureId, dayType, status, systemId, clientId, userId);
				else
					message = func.updateRateMasterDetails(id,amount, terminalId, routeId, distance, duration, departureTime, arrivalTime, vehicleModelId, seatingStructureId, dayType, status, systemId, clientId, userId);
				response.getWriter().print(message);	
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		
		if (param.equalsIgnoreCase("getRateMasterDetails")) {
			
			jsonObject = new JSONObject();
			jsonArray = new JSONArray();
			
			clientId = Integer.parseInt(request.getParameter("CustId"));
			String jspName = request.getParameter("jspName");
			CommonFunctions cf = new CommonFunctions();
			
			try {
				ArrayList<Object> rateMasterDetails = func.getRateMasterDetails(systemId, clientId,language);
				jsonArray = (JSONArray) rateMasterDetails.get(0);
				if(jsonArray.length()>0){
					jsonObject.put("RateMasterRoot",jsonArray);
				}else{
					jsonObject.put("RateMasterRoot","");
				}
				ReportHelper reportHelper = (ReportHelper) rateMasterDetails.get(1);
				request.getSession().setAttribute(jspName, reportHelper);
				request.getSession().setAttribute("customerName",cf.getCustomerName(String.valueOf(clientId), systemId));
				response.getWriter().print(jsonObject.toString());	
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		return null;
	}
}
