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
import t4u.functions.GeneralVerticalFunctions;

public class IButtonReportAction extends Action {
	public ActionForward execute(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response) {
		HttpSession session  = request.getSession();
		String param = "";
		
		int systemId = 0;
		int clientId = 0;
		String vehcileNo = "";
		String vehicleGroup = "";
		String vehcileNo1 = "";
		String vehicleGroup1 = "";
		
		LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
		
		systemId = loginInfo.getSystemId();
		clientId = loginInfo.getCustomerId();
		int offset = loginInfo.getOffsetMinutes();
		JSONArray jsonArray = null;
		SimpleDateFormat yyyyMMdd = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		SimpleDateFormat ddmmyyyy = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
		GeneralVerticalFunctions gf = new GeneralVerticalFunctions();
		JSONObject jsonObject = new JSONObject();
		if (request.getParameter("param") != null) {
			param = request.getParameter("param").toString();
		}
		
		if(param.equals("getSwipedData")) {
			try {
				 jsonObject = new JSONObject();
				String startDate = yyyyMMdd.format(ddmmyyyy.parse(request.getParameter("startDate")));
				String endDate = yyyyMMdd.format(ddmmyyyy.parse(request.getParameter("endDate")));
				
				ArrayList<Object> list1 = gf.getSwipedReportData(clientId,systemId,offset,startDate,endDate);
				jsonArray = (JSONArray) list1.get(0);
				if (jsonArray.length() > 0) {
					jsonObject.put("swipedReportRoot", jsonArray);
				} else {
					jsonObject.put("swipedReportRoot", "");
				}
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		
		if(param.equals("getTripDetailData")) {
			try {
				 jsonObject = new JSONObject();
				String startDate = yyyyMMdd.format(ddmmyyyy.parse(request.getParameter("startDate")));
				String endDate = yyyyMMdd.format(ddmmyyyy.parse(request.getParameter("endDate")));
				vehcileNo = request.getParameter("vehicleNo");
				vehicleGroup = request.getParameter("vehicleGroup");
				
				ArrayList<Object> list1 = gf.getVehicleTripDetailsData(clientId,systemId,offset,startDate,endDate,vehcileNo,vehicleGroup);
				jsonArray = (JSONArray) list1.get(0);
				if (jsonArray.length() > 0) {
					jsonObject.put("tripDetailsRoot", jsonArray);
				} else {
					jsonObject.put("tripDetailsRoot", "");
				}
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		
		if(param.equals("getTripSummaryData")) {
			try {
				 jsonObject = new JSONObject();
				String startDate = yyyyMMdd.format(ddmmyyyy.parse(request.getParameter("startDate")));
				String endDate = yyyyMMdd.format(ddmmyyyy.parse(request.getParameter("endDate")));
				vehcileNo1 = request.getParameter("vehicleNo1");
				vehicleGroup1 = request.getParameter("vehicleGroup1");
				ArrayList<Object> list1 = gf.getVehicleTripSummaryData(clientId,systemId,offset,startDate,endDate,vehcileNo1,vehicleGroup1);
				jsonArray = (JSONArray) list1.get(0);
				if (jsonArray.length() > 0) {
					jsonObject.put("tripSummaryRoot", jsonArray);
				} else {
					jsonObject.put("tripSummaryRoot", "");
				}
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		
		
	
		return null;
	}
}
