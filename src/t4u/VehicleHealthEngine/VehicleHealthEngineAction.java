package t4u.VehicleHealthEngine;

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
import t4u.functions.VehicleHealthEngineFunction;

public class VehicleHealthEngineAction extends Action {
	public ActionForward execute(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
        HttpSession session = request.getSession();
        String param = "";
        String zone = "";
        int systemId = 0;
        int userId = 0;
        int offset = 0;
    	SimpleDateFormat ddmmyyyy = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
    	SimpleDateFormat yyyymmdd = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
        systemId = loginInfo.getSystemId();
        int custId= loginInfo.getCustomerId();
        zone = loginInfo.getZone();
        userId = loginInfo.getUserId();
        offset = loginInfo.getOffsetMinutes();
        String lang = loginInfo.getLanguage();
        zone = loginInfo.getZone();
        VehicleHealthEngineFunction vehHealthFunc = new VehicleHealthEngineFunction();
        JSONArray jsonArray = null;
        JSONObject jsonObject = new JSONObject();
        if (request.getParameter("param") != null) {
            param = request.getParameter("param").toString();
        }
		
		if (param.equals("getVehicle")) {
			try {
				String reportId = request.getParameter("reportId");
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();

				jsonArray = vehHealthFunc.getOBDVehicle(systemId, custId,Integer.parseInt(reportId));
				if (jsonArray.length() > 0) {
					jsonObject.put("VehicleRoot", jsonArray);
				} else {
					jsonObject.put("VehicleRoot", "");
				}
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {
				System.out.println("Error in Common Action:-getVehicle "
						+ e.toString());
			}
		}
		else if (param.equalsIgnoreCase("getCoolentTempDetails")) {
	        try {
	            String vehicleNo = request.getParameter("vehicleNo");
	            String startDate = request.getParameter("startDate");
	            String endDate = request.getParameter("endDate")+" "+ "23:59:59";
	            jsonObject = new JSONObject();
	            jsonArray = new JSONArray();
	            	
	                ArrayList < Object > list1 = vehHealthFunc.getCoolentTempDetails(systemId,custId,offset,vehicleNo,startDate,endDate);
	                jsonArray = (JSONArray) list1.get(0);
	                if (jsonArray.length() > 0) {
	                    jsonObject.put("coolentTempDetailsRoot",jsonArray);
	                } else {
	                    jsonObject.put("coolentTempDetailsRoot", "");
	                }
	                //reportHelper = (ReportHelper) list1.get(1);
	                //request.getSession().setAttribute(jspName, reportHelper);
	                //request.getSession().setAttribute("customerId", custName);
	             	response.getWriter().print(jsonObject.toString());
	            
	        } catch (Exception e) {
	            e.printStackTrace();
	        }
	    }
		else if (param.equalsIgnoreCase("getEngineErrorCodeDetails")) {
	        try {
	            String vehicleNo = request.getParameter("vehicleNo");
	            String startDate = request.getParameter("startDate");
	            String endDate = request.getParameter("endDate")+" "+ "23:59:59";
	            jsonObject = new JSONObject();
	            jsonArray = new JSONArray();
	            	
	                ArrayList < Object > list1 = vehHealthFunc.getEngineErrorCodeDetails(systemId,custId,offset,vehicleNo,startDate,endDate);
	                jsonArray = (JSONArray) list1.get(0);
	                if (jsonArray.length() > 0) {
	                    jsonObject.put("engineErrorCodeDetailsRoot",jsonArray);
	                } else {
	                    jsonObject.put("engineErrorCodeDetailsRoot", "");
	                }
	                //reportHelper = (ReportHelper) list1.get(1);
	                //request.getSession().setAttribute(jspName, reportHelper);
	                //request.getSession().setAttribute("customerId", custName);
	             	response.getWriter().print(jsonObject.toString());
	            
	        } catch (Exception e) {
	            e.printStackTrace();
	        }
	    }
		else if (param.equalsIgnoreCase("getMileageDetails")) {
	        try {
	            String vehicleNo = request.getParameter("vehicleNo");
	            String startDate = request.getParameter("startDate");
	            String endDate = request.getParameter("endDate")+" "+ "23:59:59";
	            jsonObject = new JSONObject();
	            jsonArray = new JSONArray();
	            	
	                ArrayList < Object > list1 = vehHealthFunc.getMileageDetails(systemId,custId,offset,vehicleNo,startDate,endDate);
	                jsonArray = (JSONArray) list1.get(0);
	                if (jsonArray.length() > 0) {
	                    jsonObject.put("mileageDetailsRoot",jsonArray);
	                } else {
	                    jsonObject.put("mileageDetailsRoot", "");
	                }
	                //reportHelper = (ReportHelper) list1.get(1);
	                //request.getSession().setAttribute(jspName, reportHelper);
	                //request.getSession().setAttribute("customerId", custName);
	             	response.getWriter().print(jsonObject.toString());
	            
	        } catch (Exception e) {
	            e.printStackTrace();
	        }
	    }
		else if (param.equalsIgnoreCase("getElectricalHealthDetails")) {
	        try {
	            String vehicleNo = request.getParameter("vehicleNo");
	            String startDate = request.getParameter("startDate");
	            String endDate = request.getParameter("endDate")+" "+ "23:59:59";
	            jsonObject = new JSONObject();
	            jsonArray = new JSONArray();
	            	
	                ArrayList < Object > list1 = vehHealthFunc.getElectricalHealthDetails(systemId,custId,offset,vehicleNo,startDate,endDate);
	                jsonArray = (JSONArray) list1.get(0);
	                if (jsonArray.length() > 0) {
	                    jsonObject.put("electricalHealthDetailsRoot",jsonArray);
	                } else {
	                    jsonObject.put("electricalHealthDetailsRoot", "");
	                }
	                //reportHelper = (ReportHelper) list1.get(1);
	                //request.getSession().setAttribute(jspName, reportHelper);
	                //request.getSession().setAttribute("customerId", custName);
	             	response.getWriter().print(jsonObject.toString());
	            
	        } catch (Exception e) {
	            e.printStackTrace();
	        }
	    }
		else if (param.equalsIgnoreCase("getBatteryHealthDetails")) {
	        try {
	            String vehicleNo = request.getParameter("vehicleNo");
	            String startDate = request.getParameter("startDate");
	            String endDate = request.getParameter("endDate")+" "+ "23:59:59";
	            jsonObject = new JSONObject();
	            jsonArray = new JSONArray();
	            	
	                ArrayList < Object > list1 = vehHealthFunc.getBatteryHealthDetails(systemId,custId,offset,vehicleNo,startDate,endDate);
	                jsonArray = (JSONArray) list1.get(0);
	                if (jsonArray.length() > 0) {
	                    jsonObject.put("batteryHealthDetailsRoot",jsonArray);
	                } else {
	                    jsonObject.put("batteryHealthDetailsRoot", "");
	                }
	                //reportHelper = (ReportHelper) list1.get(1);
	                //request.getSession().setAttribute(jspName, reportHelper);
	                //request.getSession().setAttribute("customerId", custName);
	             	response.getWriter().print(jsonObject.toString());
	            
	        } catch (Exception e) {
	            e.printStackTrace();
	        }
	    }
		else if (param.equalsIgnoreCase("getAccidentDetails")) {
	        try {
	            String vehicleNo = request.getParameter("vehicleNo");
	            String startDate = request.getParameter("startDate");
	            String endDate = request.getParameter("endDate")+" "+ "23:59:59";
	            jsonObject = new JSONObject();
	            jsonArray = new JSONArray();
	            	
	                ArrayList < Object > list1 = vehHealthFunc.getAccidentDetails(systemId,custId,offset,vehicleNo,startDate,endDate);
	                jsonArray = (JSONArray) list1.get(0);
	                if (jsonArray.length() > 0) {
	                    jsonObject.put("accidentDetailsRoot",jsonArray);
	                } else {
	                    jsonObject.put("accidentDetailsRoot", "");
	                }
	                //reportHelper = (ReportHelper) list1.get(1);
	                //request.getSession().setAttribute(jspName, reportHelper);
	                //request.getSession().setAttribute("customerId", custName);
	             	response.getWriter().print(jsonObject.toString());
	            
	        } catch (Exception e) {
	            e.printStackTrace();
	        }
	    }
		
		return null;

	}
}
