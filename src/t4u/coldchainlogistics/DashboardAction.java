package t4u.coldchainlogistics;

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
import t4u.functions.ColdChainLogisticsFunctions;

public class DashboardAction extends Action{
	public ActionForward execute(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) throws Exception {
		HttpSession session = request.getSession();
		int systemId = 0;
		int userId = 0;
		int custId = 0;
		int offset = 0;
		LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
		ColdChainLogisticsFunctions chainLogisticsFunctions = new ColdChainLogisticsFunctions();
		systemId = loginInfo.getSystemId();
		userId = loginInfo.getUserId();
		custId = loginInfo.getCustomerId();
		offset = loginInfo.getOffsetMinutes();
		JSONArray jsonArray = null;
		JSONObject jsonObject = new JSONObject();
		String param = "";
		if (request.getParameter("param") != null) {
			param = request.getParameter("param").toString();
		}
		if  (param.equalsIgnoreCase("getDashboardCount")) {
			try {
				jsonArray = new JSONArray();
				ArrayList < Object > list = chainLogisticsFunctions.getDastboardCount(userId,custId,systemId,offset);
				jsonArray = (JSONArray) list.get(0);
				if (jsonArray.length() > 0) {
					jsonObject.put("clientList", jsonArray); 
				} else {
					jsonObject.put("clientList", "");
				}
				response.getWriter().print(jsonObject.toString());   
				
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		if  (param.equalsIgnoreCase("getAllVehiclesBasedOnGroupId")) {
			try {
				jsonArray = new JSONArray();
				String gropId = request.getParameter("groupId");
				if (gropId != null && !gropId.equals("")) {
					int groupId = Integer.parseInt(gropId);
					ArrayList < Object > list = chainLogisticsFunctions.getAllVehiclesBasedOnGroupId(groupId,userId,custId,systemId);
					jsonArray = (JSONArray) list.get(0);
					if (jsonArray.length() > 0) {
						jsonObject.put("allVehicles", jsonArray); 
					} else {
						jsonObject.put("allVehicles", "");
					}
				}else{
					jsonObject.put("allVehicles", "");
				}
				response.getWriter().print(jsonObject.toString());   
				
			} catch (Exception e) {
				e.printStackTrace();
			}
	 	}
		if  (param.equalsIgnoreCase("getCommVehiclesCount")) {
			try {
				jsonArray = new JSONArray();					
				jsonArray = chainLogisticsFunctions.getCommVehiclesCount(userId,custId,systemId);				
				if (jsonArray.length() > 0) {
					jsonObject.put("commVehicles", jsonArray); 
				} else {
					jsonObject.put("commVehicles", "");
				}
				response.getWriter().print(jsonObject.toString());   
				
			} catch (Exception e) {
				e.printStackTrace();
			}
	 	}
		if  (param.equalsIgnoreCase("getNonCommVehiclesCount")) {
			try {
				jsonArray = new JSONArray();					
				jsonArray = chainLogisticsFunctions.getNonCommVehiclesCount(userId,custId,systemId);
				if (jsonArray.length() > 0) {
					jsonObject.put("nonCommVehicles", jsonArray); 
				} else {
					jsonObject.put("monCommVehicles", "");
				}
				response.getWriter().print(jsonObject.toString());   
				
			} catch (Exception e) {
				e.printStackTrace();
			}
	 	}
		if  (param.equalsIgnoreCase("getMovingVehiclesCount")) {
			try {
				jsonArray = new JSONArray();					
				jsonArray = chainLogisticsFunctions.getMovingVehiclesCount(userId,custId,systemId,offset);
				if (jsonArray.length() > 0) {
					jsonObject.put("movingVehicles", jsonArray); 
				} else {
					jsonObject.put("movingVehicles", "");
				}
				response.getWriter().print(jsonObject.toString());   
				
			} catch (Exception e) {
				e.printStackTrace();
			}
	 	}
		if  (param.equalsIgnoreCase("getAlertVehiclesCount")) {
			try {
				jsonArray = new JSONArray();					
				jsonArray = chainLogisticsFunctions.getAlertVehiclesCount(userId,custId,systemId,offset);
				if (jsonArray.length() > 0) {
					jsonObject.put("alertVehicles", jsonArray); 
				} else {
					jsonObject.put("alertVehicles", "");
				}
				response.getWriter().print(jsonObject.toString());   
				
			} catch (Exception e) {
				e.printStackTrace();
			}
	 	}
		return null;
	}
	
}
