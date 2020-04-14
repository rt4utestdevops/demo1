package t4u.GeneralVertical;

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
import t4u.functions.CommonFunctions;
import t4u.functions.DTSReportsFunctions;

public class DTSReportsAction extends Action {
	public ActionForward execute(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response) {
		HttpSession session  = request.getSession();
		String param = "";
		int systemId = 0;
		int userId = 0;
		int offset = 0;
		int clientId = 0;
		String distUnits = "";
		LoginInfoBean loginInfo = (LoginInfoBean) session
				.getAttribute("loginInfoDetails");
		DTSReportsFunctions drf = new DTSReportsFunctions();
		CommonFunctions cf = new CommonFunctions();
		distUnits = cf.getUnitOfMeasure(systemId);
		systemId = loginInfo.getSystemId();
		clientId = loginInfo.getCustomerId();
		userId = loginInfo.getUserId();
		offset = loginInfo.getOffsetMinutes();
		JSONArray jsonArray = null;
		SimpleDateFormat yyyyMMdd = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		SimpleDateFormat ddmmyyyy = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
		JSONObject jsonObject = new JSONObject();
		if (request.getParameter("param") != null) {
			param = request.getParameter("param").toString();
		}

		if (param.equals("getPendingDeliveriesReport")) {
			try {
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				String startDate = yyyyMMdd.format(ddmmyyyy.parse(request.getParameter("startDate")));
				String endDate = yyyyMMdd.format(ddmmyyyy.parse(request.getParameter("endDate"))); 
				String tripCust = request.getParameter("tripCust");
				String orderNo = request.getParameter("orderNo");
				
					ArrayList<Object> list1 = drf.getPendingDeliveriesReport(startDate,endDate,tripCust,offset,distUnits,orderNo,systemId, clientId);
					if(list1.size()!=0)
					jsonArray = (JSONArray) list1.get(0);
					if (jsonArray.length() > 0) {
						jsonObject.put("pendingDeliveriesRoot", jsonArray);
					} else {
						jsonObject.put("pendingDeliveriesRoot", "");
					}
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		} 
		
		else if (param.equals("getDriverEfficiencyReport")) {
			try {
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				String startDate = yyyyMMdd.format(ddmmyyyy.parse(request.getParameter("startDate")));
				String endDate = yyyyMMdd.format(ddmmyyyy.parse(request.getParameter("endDate"))); 
				String vehicleNo = request.getParameter("vehicleNo");
					ArrayList<Object> list1 = drf.getDriverEfficiencyReport(startDate, endDate, offset, distUnits, vehicleNo, systemId, clientId,userId);
					jsonArray = (JSONArray) list1.get(0);
					if (jsonArray.length() > 0) {
						jsonObject.put("driverEffRoot", jsonArray);
					} else {
						jsonObject.put("driverEffRoot", "");
					}
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		} 
		
		else if (param.equals("getOrderDetailReport")) {
			try {
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				String startDate = yyyyMMdd.format(ddmmyyyy.parse(request.getParameter("startDate")));
				String endDate = yyyyMMdd.format(ddmmyyyy.parse(request.getParameter("endDate"))); 
				String tripCust = request.getParameter("tripCust");
				String orderNo = request.getParameter("orderNo");
				String status = request.getParameter("status");
					ArrayList<Object> list1 = drf.getOrderDetailReport(startDate,endDate,status,tripCust,offset,distUnits,orderNo,systemId, clientId);
					jsonArray = (JSONArray) list1.get(0);
					if (jsonArray.length() > 0) {
						jsonObject.put("orderDetailRoot", jsonArray);
					} else {
						jsonObject.put("orderDetailRoot", "");
					}
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		} 
		else if (param.equals("getDriverAndVehicle")) {
			try {
				jsonObject = new JSONObject();
				
					jsonObject.put("VehicleNoRoot", jsonArray);
				
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {
				System.out.println("Error in TripBasedAction:-getVehicleNo "+ e.toString());
			}
		}
		else if (param.equals("getOrderNo")) {
			try {
				String startDate = yyyyMMdd.format(ddmmyyyy.parse(request.getParameter("startDate")));
				String endDate = yyyyMMdd.format(ddmmyyyy.parse(request.getParameter("endDate")));
				jsonObject = new JSONObject();
					jsonArray = drf.getOrderNo(systemId,clientId,startDate,endDate);
					jsonObject.put("orderRoot", jsonArray);
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {
				System.out.println("Error in DTSReportsAction:-getOrderNo "+ e.toString());
			}
		}
		else if (param.equals("getDriverNames")) {
			try {
				jsonObject = new JSONObject();
					jsonArray = drf.getDriverNames(systemId,clientId,userId);
					jsonObject.put("driverRoot", jsonArray);
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {
				System.out.println("Error in DTSReportsAction:-getDriverNames "+ e.toString());
			}
		}
		return null;
	}
}