package t4u.wastemanagement;

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
import t4u.functions.PenaltySystemFunction;

public class PenaltySystemAction extends Action {
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
		int offset = loginInfo.getOffsetMinutes();
		String language=loginInfo.getLanguage();
		
		JSONArray jsonArray = null;
		JSONObject jsonObject = null;
		
		PenaltySystemFunction psFunction = new PenaltySystemFunction();
		
		if (request.getParameter("param") != null) {
			param = request.getParameter("param").toString();
		}

		if (param.equalsIgnoreCase("getPenalty")) {
			
			jsonObject = new JSONObject();
			jsonArray = new JSONArray();
			
			clientId = Integer.parseInt(request.getParameter("CustId"));
			
			try {
				jsonArray = psFunction.getPenaltyDetails(systemId, clientId);
				if(jsonArray.length()>0){
					jsonObject.put("PenaltyDetails",jsonArray);
				}else{
					jsonObject.put("PenaltyDetails","");
				}
				response.getWriter().print(jsonObject.toString());	
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		
		if (param.equalsIgnoreCase("getVehicles")) {
			
			jsonObject = new JSONObject();
			jsonArray = new JSONArray();
			
			clientId = Integer.parseInt(request.getParameter("CustId"));
			
			try {
				jsonArray = psFunction.getVehicleDetails(systemId, clientId);
				if(jsonArray.length()>0){
					jsonObject.put("VehicleDetails",jsonArray);
				}else{
					jsonObject.put("VehicleDetails","");
				}
				response.getWriter().print(jsonObject.toString());	
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		
		if (param.equalsIgnoreCase("savePenaltySystem")) {
			
			clientId = Integer.parseInt(request.getParameter("CustId"));
			String date = request.getParameter("date");
			int assetId = Integer.parseInt(request.getParameter("assetId"));
			int penaltyId = Integer.parseInt(request.getParameter("penaltyId"));
			String buttonValue = request.getParameter("buttonValue");
			int id = Integer.parseInt(request.getParameter("id"));
			String message = "";
			
			try {
				if(buttonValue.equalsIgnoreCase("Add")){
					message = psFunction.savePenaltySystemDetails(date, assetId, penaltyId, userId, systemId, clientId,offset);
				}else{
					message = psFunction.updatePenaltySystemDetails(id,penaltyId, userId, systemId, clientId);
				}
				response.getWriter().print(message);
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		
		if (param.equalsIgnoreCase("getPenaltySystemDetails")) {
			
			jsonObject = new JSONObject();
			jsonArray = new JSONArray();
			CommonFunctions cf = new CommonFunctions(); 
			clientId = Integer.parseInt(request.getParameter("CustId"));
			String startDate = request.getParameter("startdate");
			String endDate = request.getParameter("enddate");
			String jspName = request.getParameter("jspName");
			
			if(startDate!=null && endDate!=null ){
				startDate = startDate.replace("T", " ");
				endDate = endDate.replace("T", " ");
			}
			try {
				 ArrayList<Object> penaltyDetails = psFunction.getPenaltySystemDetails(startDate, endDate, systemId, clientId, offset, language);
				 jsonArray = (JSONArray) penaltyDetails.get(0);
				if(jsonArray.length()>0){
					jsonObject.put("PenaltySystemRoot",jsonArray);
				}else{
					jsonObject.put("PenaltySystemRoot","");
				}
				
				ReportHelper reportHelper = (ReportHelper) penaltyDetails.get(1);
				request.getSession().setAttribute(jspName, reportHelper);
				request.getSession().setAttribute("startdate",startDate);
				request.getSession().setAttribute("enddate",endDate);
				request.getSession().setAttribute("customerName",cf.getCustomerName(String.valueOf(clientId), systemId));
				response.getWriter().print(jsonObject.toString());
				
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		
		if (param.equalsIgnoreCase("modifyPenaltySystem")) {
			try {
				
			} catch (Exception e) {
				e.printStackTrace();
			}
		}

		return null;
	}
}
