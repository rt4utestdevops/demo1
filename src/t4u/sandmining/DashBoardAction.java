package t4u.sandmining;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;

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
import t4u.functions.SandMiningFunctions;

public class DashBoardAction extends Action {
	public ActionForward execute(ActionMapping mapping, ActionForm form,HttpServletRequest request, HttpServletResponse response) throws Exception {
		try {
			HttpSession session = request.getSession();
			LoginInfoBean loginInfo =(LoginInfoBean)session.getAttribute("loginInfoDetails");
			int systemId = loginInfo.getSystemId();
			int customerId = loginInfo.getCustomerId();
			int userId = loginInfo.getUserId();
			int offmin = loginInfo.getOffsetMinutes();
			int isLtsp = loginInfo.getIsLtsp();
			String zone=loginInfo.getZone();
			SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
			SandMiningFunctions sandfunc = new SandMiningFunctions();
			JSONArray jsonArray = null;
			String param = "";
			if (request.getParameter("param") != null) {
				param = request.getParameter("param").toString();
			}
			
			if(param.equals("getDashboardElementsCount")){
				try {
					JSONObject jsonObject = new JSONObject();
					jsonArray = sandfunc.getDashboardElementsCount(systemId, customerId, userId,offmin ,isLtsp,zone);
					if (jsonArray.length() > 0) {
						jsonObject.put("DashBoardElementCountRoot", jsonArray);
					} else {
						jsonObject.put("DashBoardElementCountRoot", "");
					}
					response.getWriter().print(jsonObject.toString());
				} catch (Exception e) {
					e.printStackTrace();
				}
			} else if (param.equals("getDashboardRevenueChart")) {
				try {

					Calendar startDateOfWeek = Calendar.getInstance();
					startDateOfWeek.setFirstDayOfWeek(Calendar.SUNDAY);
					startDateOfWeek.setTime(new Date());
					int dayFirst = startDateOfWeek.get(Calendar.DAY_OF_WEEK);
					startDateOfWeek.add(Calendar.DAY_OF_WEEK, - dayFirst + Calendar.SUNDAY);
					
					Calendar endDateOfWeek = Calendar.getInstance();
					endDateOfWeek.setFirstDayOfWeek(Calendar.SATURDAY);
					endDateOfWeek.setTime(new Date());
					int dayLast = endDateOfWeek.get(Calendar.DAY_OF_WEEK);
					endDateOfWeek.add(Calendar.DAY_OF_WEEK, - dayLast + Calendar.SATURDAY);
					
					JSONObject jsonObject = new JSONObject();
					jsonArray = sandfunc.getWeeklyRevenue(customerId, dateFormat.format(startDateOfWeek.getTime()), dateFormat.format(endDateOfWeek.getTime()), systemId, offmin);

					if (jsonArray.length() > 0) {
						jsonObject.put("DashBoardRevenueChartRoot", jsonArray);
					} else {
						jsonObject.put("DashBoardRevenueChartRoot", "");
					}
					response.getWriter().print(jsonObject.toString());
				} catch (Exception e) {
					e.printStackTrace();
				}
			} else if (param.equals("getDashboardPermitChart")) {
				
				try {

					Calendar startDateOfWeek = Calendar.getInstance();
					startDateOfWeek.setFirstDayOfWeek(Calendar.SUNDAY);
					startDateOfWeek.setTime(new Date());
					int dayFirst = startDateOfWeek.get(Calendar.DAY_OF_WEEK);
					startDateOfWeek.add(Calendar.DAY_OF_WEEK, - dayFirst + Calendar.SUNDAY);
					
					Calendar endDateOfWeek = Calendar.getInstance();
					endDateOfWeek.setFirstDayOfWeek(Calendar.SATURDAY);
					endDateOfWeek.setTime(new Date());
					int dayLast = endDateOfWeek.get(Calendar.DAY_OF_WEEK);
					endDateOfWeek.add(Calendar.DAY_OF_WEEK, - dayLast + Calendar.SATURDAY);
					
					JSONObject jsonObject = new JSONObject();
					jsonArray = sandfunc.getWeeklyPermit(customerId, dateFormat.format(startDateOfWeek.getTime()), dateFormat.format(endDateOfWeek.getTime()), systemId, offmin);

					if (jsonArray.length() > 0) {
						jsonObject.put("DashBoardPermitChartRoot", jsonArray);
					} else {
						jsonObject.put("DashBoardPermitChartRoot", "");
					}
					response.getWriter().print(jsonObject.toString());
				} catch (Exception e) {
					e.printStackTrace();
				}
			}	
			
else if (param.equals("serpDashboardElements")) {
				
				try {

					JSONObject jsonObject = new JSONObject();
					jsonArray = sandfunc.getSerpDashboardElements(systemId, customerId, userId,offmin ,isLtsp,zone);
					if (jsonArray.length() > 0) {
						jsonObject.put("serpDashboardElementsRoot", jsonArray);
					} else {
						jsonObject.put("serpDashboardElementsRoot", "");
					}
					response.getWriter().print(jsonObject.toString());
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
			
else if (param.equals("waitingLoadingTime")) {
	
	try {

		JSONObject jsonObject = new JSONObject();
		jsonArray = sandfunc.waitingLoadingTime();
		if (jsonArray.length() > 0) {
			jsonObject.put("waitingLoadingTimeRoot", jsonArray);
		} else {
			jsonObject.put("waitingLoadingTimeRoot", "");
		}
		response.getWriter().print(jsonObject.toString());
	} catch (Exception e) {
		e.printStackTrace();
	}
}	
	
else if (param.equals("reachwaitingLoadingTime")) {
	
	try {

		JSONObject jsonObject = new JSONObject();
		String customerName=request.getParameter("custName");
		jsonArray = sandfunc.reachwaitingLoadingTime(customerName);
		if (jsonArray.length() > 0) {
			jsonObject.put("reachwaitingLoadingTimeRoot", jsonArray);
		} else {
			jsonObject.put("reachwaitingLoadingTimeRoot", "");
		}
		response.getWriter().print(jsonObject.toString());
	} catch (Exception e) {
		e.printStackTrace();
	}
}	
	
else if (param.equals("unAuthourizedReachEntry")) {
	
	try {

		JSONObject jsonObject = new JSONObject();
		String customerName=request.getParameter("custName");
		jsonArray = sandfunc.unAuthourizedReachEntry();
		if (jsonArray.length() > 0) {
			jsonObject.put("unAuthourizedReachEntryRoot", jsonArray);
		} else {
			jsonObject.put("unAuthourizedReachEntryRoot", "");
		}
		response.getWriter().print(jsonObject.toString());
	} catch (Exception e) {
		e.printStackTrace();
	}
}				
			
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		
		return null;
	}
}
