package t4u.CarRental;

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
import t4u.functions.AdminFunctions;
import t4u.functions.CarRentalFunctions;

public class FieldTamperingAction extends Action {
	public ActionForward execute(ActionMapping mapping, ActionForm form,HttpServletRequest request, HttpServletResponse response) throws Exception {
		try {
			HttpSession session = request.getSession();
			LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
			int systemId = loginInfo.getSystemId();
			int customerId = loginInfo.getCustomerId();
			int userId = loginInfo.getUserId();
			int offmin = loginInfo.getOffsetMinutes();
			String lang = loginInfo.getLanguage();
			String zone=loginInfo.getZone();
			CarRentalFunctions cfunc=new CarRentalFunctions();
			AdminFunctions adfunc=new AdminFunctions();
			JSONObject jsonObject = new JSONObject();
			JSONArray jsonArray = null;
			String param = "";
			if (request.getParameter("param") != null) {
				param = request.getParameter("param").toString();
			}
			if (param.equalsIgnoreCase("addFieldTamperingDetails")) {
				try {
					String cityId = request.getParameter("cityId") != null && !request.getParameter("cityId").equals("") ? request.getParameter("cityId") : "0";
					String reason = request.getParameter("reason");
					String vehicleNo = request.getParameter("vehicleNo");
					String resolution = request.getParameter("resolution");
					String attendanceDate = request.getParameter("attendanceDate");
					String RealFilePath = request.getParameter("filePath");
					//String[] RealFilePath=filePath.split("fakepath");
					String message = "";
					message = cfunc.addFieldTamperingDetails(systemId,customerId,userId,Integer.parseInt(cityId),reason,vehicleNo,resolution,attendanceDate,RealFilePath);
					response.getWriter().print(message);
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
			else if (param.equalsIgnoreCase("getFieldTamperingDetails")) {
				try {
					String cityId = request.getParameter("cityId") != null && !request.getParameter("cityId").equals("") && !request.getParameter("cityId").equals("null") ? request.getParameter("cityId") : "0";
					String CustName = request.getParameter("custName");
					String jspName = request.getParameter("jspName");
					String startDate = request.getParameter("startDate");
					String endDate = request.getParameter("endDate");
					jsonArray = new JSONArray();
					ArrayList<Object> list = cfunc.getFieldTamperingDetails(customerId, systemId, userId,startDate,endDate,Integer.parseInt(cityId));
					jsonArray = (JSONArray) list.get(0);
					if (jsonArray.length() > 0) {
						jsonObject.put("TamperingDetailsRoot", jsonArray);
					} else {
						jsonObject.put("TamperingDetailsRoot", "");
					}
					ReportHelper reportHelper = (ReportHelper) list.get(1);
					request.getSession().setAttribute(jspName, reportHelper);
					request.getSession().setAttribute("custName", CustName);
					response.getWriter().print(jsonObject.toString());
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
			else if (param.equalsIgnoreCase("getCityName")) {
				try {
					jsonArray = new JSONArray();
					jsonObject = new JSONObject();
					jsonArray = cfunc.getCityDetails();
					if (jsonArray.length() > 0) {
						jsonObject.put("cityRoot", jsonArray);
					} else {
						jsonObject.put("cityRoot", "");
					}
					response.getWriter().print(jsonObject.toString());
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
			else if (param.equalsIgnoreCase("getVehicleNo")) {
				try {
					String cityId = request.getParameter("cityId") != null && !request.getParameter("cityId").equals("") ? request.getParameter("cityId") : "0";
					jsonArray = new JSONArray();
					jsonObject = new JSONObject();
					jsonArray = cfunc.getVehicleNo(customerId,systemId,Integer.parseInt(cityId));
					if (jsonArray.length() > 0) {
						jsonObject.put("vehicleNoRoot", jsonArray);
					} else {
						jsonObject.put("vehicleNoRoot", "");
					}
					response.getWriter().print(jsonObject.toString());
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
			else if (param.equalsIgnoreCase("getTamperedDeviceDetails")) {
			try {
		           
		            jsonArray = new JSONArray();
		            jsonObject= new JSONObject();
	            	jsonArray = cfunc.getTamperedDeviceDetails(customerId, systemId);
	                if (jsonArray.length() > 0) {
	                    jsonObject.put("DeviceTamperingDetailsRoot", jsonArray);
	                } else {
	                    jsonObject.put("DeviceTamperingDetailsRoot", "");
	                }
	                response.getWriter().print(jsonObject.toString());
		        } catch (Exception e) {
		            e.printStackTrace();
		        }
			}
		}catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}
}
