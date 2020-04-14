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

import t4u.functions.PassengerBusTransportationFunctions;

public class TripPlannerAction extends Action {

	public ActionForward execute(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) throws Exception {
		String param = "";
		HttpSession session = request.getSession();
		PassengerBusTransportationFunctions tripPlanner = new PassengerBusTransportationFunctions();
		LoginInfoBean logininfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
		int systemId = logininfo.getSystemId();
		int userId = logininfo.getUserId();
		String lang = logininfo.getLanguage();
		JSONArray jsonArray = null;
		JSONObject jsonObject = new JSONObject();
		if (request.getParameter("param") != null) {
			param = request.getParameter("param").toString();
		}

		if (param.equals("getTerminalName")) {
			try {
				String CustId = request.getParameter("CustId");
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				if (CustId != null && !CustId.equals("")) {
					jsonArray = tripPlanner.getTerminalName(systemId, Integer.parseInt(CustId));
					if (jsonArray.length() > 0) {
						jsonObject.put("getTerminalName", jsonArray);
					} else {
						jsonObject.put("getTerminalName", "");
					}
					response.getWriter().print(jsonObject.toString());
				} else {
					jsonObject.put("getTerminalName", "");
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
		} else if (param.equals("getRouteNames")) {
			try {
				String custId = request.getParameter("CustId");
				String terminalName = request.getParameter("TerminalName");
				String dayType = request.getParameter("WeekdayHolidayValue");

				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				if (custId != null && !custId.equals("")) {
					jsonArray = tripPlanner.getRouteNames(systemId, Integer.parseInt(custId), Integer.parseInt(terminalName), dayType);
					if (jsonArray.length() > 0) {
						jsonObject.put("getRouteName", jsonArray);
					} else {
						jsonObject.put("getRouteName", "");
					}
					response.getWriter().print(jsonObject.toString());
				} else {
					jsonObject.put("getRouteName", "");
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
		} else if (param.equals("getRateDetails")) {
			try {

				String custId = request.getParameter("CustId");
				String terminalName = request.getParameter("TerminalName");
				//String routeName = request.getParameter("RouteName");
				String dayType = request.getParameter("DayType");
				String rateID = request.getParameter("RateID");

				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				if (custId != null && !custId.equals("")) {
					jsonArray = tripPlanner.getRateDetails(systemId, Integer.parseInt(custId), Integer.parseInt(terminalName), dayType,Integer.parseInt(rateID));
					if (jsonArray.length() > 0) {
						jsonObject.put("getRateDetails", jsonArray);
					} else {
						jsonObject.put("getRateDetails", "");
					}
					response.getWriter().print(jsonObject.toString());
				} else {
					jsonObject.put("getRateDetails", "");
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
		} else if (param.equals("TripPlannerDetailsAddAndModify")) {
			try {

				String messsage = "";
				String custId = request.getParameter("CustId");
				String buttonValue = request.getParameter("ButtonValue");
				String serviceName = request.getParameter("ServiceName");
				String rateName = request.getParameter("RateName");
				String terminalName = request.getParameter("TerminalName");
				String routeName = request.getParameter("RouteName");
				String dayType = request.getParameter("DayType");
				String status = request.getParameter("Status");
				String serviceId = request.getParameter("ServiceId");

				if (custId != null && !custId.equals("")) {
					if (buttonValue.equalsIgnoreCase("Add")) {
						messsage = tripPlanner.tripPlannerDetailsAddFunction(systemId, Integer.parseInt(custId), Integer.parseInt(terminalName), Integer.parseInt(routeName), dayType, buttonValue, serviceName, Integer.parseInt(rateName), status, userId, Integer.parseInt(serviceId));
					} else if (buttonValue.equalsIgnoreCase("Modify")) {
						messsage = tripPlanner.tripPlannerDetailsModifyFunction(systemId, Integer.parseInt(custId), Integer.parseInt(terminalName), Integer.parseInt(routeName), dayType, buttonValue, serviceName, Integer.parseInt(rateName), status, userId, Integer.parseInt(serviceId));
					}
					response.getWriter().print(messsage);
				}

			} catch (Exception e) {
				e.printStackTrace();
			}
		}

		if (param.equals("getServiceMasterDetails")) {
			try {
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				String jspName = request.getParameter("jspName");
				String custName = request.getParameter("custname");
				String CustId = request.getParameter("CustId");

				if (request.getParameter("CustId") != null && !request.getParameter("CustId").equals("")) {
					ArrayList < Object > list1 = tripPlanner.getServiceMasterDetails(Integer.parseInt(CustId), systemId, lang);
					jsonArray = (JSONArray) list1.get(0);

					if (jsonArray.length() > 0) {
						jsonObject.put("getServiceMasterDetails", jsonArray);
					} else {
						jsonObject.put("getServiceMasterDetails", "");
					}
					ReportHelper reportHelper = (ReportHelper) list1.get(1);
					request.getSession().setAttribute(jspName, reportHelper);
					request.getSession().setAttribute("customerId", custName);
				} else {
					jsonObject.put("getServiceMasterDetails", "");
				}
				response.getWriter().print(jsonObject.toString());

			} catch (Exception e) {
				e.printStackTrace();
			}
		}

		return null;
	}

}