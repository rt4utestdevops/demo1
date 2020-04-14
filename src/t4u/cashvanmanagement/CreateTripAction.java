package t4u.cashvanmanagement;

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
import t4u.functions.CashVanManagementFunctions;

public class CreateTripAction extends Action {

	public ActionForward execute(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) throws Exception {

		String param = "";
		HttpSession session = request.getSession();
		LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
		JSONArray jsonArray = null;
		JSONObject jsonObject = null;
		int systemId = 0;
		int userID = 0;
		CashVanManagementFunctions cashVanfunc = new CashVanManagementFunctions();
		if (loginInfo != null) {
			systemId = loginInfo.getSystemId();
			userID = loginInfo.getUserId();
		}

		if (request.getParameter("param") != null) {
			param = request.getParameter("param").toString();
		}
		if (param.equals("getRouteNames")) {
			try {
				String clientIdSelected = request.getParameter("CustId");
				jsonObject = new JSONObject();
				if (clientIdSelected != null && !clientIdSelected.equals("")) {
					jsonArray = cashVanfunc.getRoutenames(Integer.parseInt(clientIdSelected), systemId);
					jsonObject.put("RouteNameRoot", jsonArray);
				} else {
					jsonObject.put("RouteNameRoot", "");
				}
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}

		} else if (param.equals("getGroupNames")) {

			try {
				String clientIdSelected = request.getParameter("clientid");
				jsonObject = new JSONObject();
				if (clientIdSelected != null && !clientIdSelected.equals("")) {
					jsonArray = cashVanfunc.getgroupnamesForAlert(Integer.parseInt(clientIdSelected), systemId, userID);
					jsonObject.put("GroupStoreList", jsonArray);
				} else {
					jsonObject.put("GroupStoreList", "");
				}
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		}

		else if (param.equals("getvehiclesandgroupforclients")) {
			try {

				String clientId = request.getParameter("clientId");
				String groupId = request.getParameter("groupId");
				jsonObject = new JSONObject();
				if (clientId != null) {
					jsonArray = cashVanfunc.getVehiclesAndGroupForClient(systemId, Integer.parseInt(clientId), userID, Integer.parseInt(groupId));
					jsonObject.put("clientVehicles", jsonArray);
				} else {
					jsonObject.put("clientVehicles", "");
				}
				response.getWriter().print(jsonObject.toString());
			}

			catch (Exception e) {
				e.printStackTrace();
			}
		}

		else if (param.equalsIgnoreCase("createTripAddAndModify")) {
			try {
				int returnRouteId = 0;
				int groupId = 0;
				int autoval = 0;
				int daysval = 0;
				String buttonValue = request.getParameter("buttonValue");
				String custId = request.getParameter("custId");
				String routeName = request.getParameter("routeName");
				//   String returnTrip=request.getParameter("returnTrip");
				String returnRouteName = request.getParameter("returnRouteName");
				String assignTo = request.getParameter("assignTo");
				String groupName = request.getParameter("groupName");
				String vehicleNo = request.getParameter("vehicleNo");
				String guestAlert = request.getParameter("guestAlert");
				String mobileNo = request.getParameter("mobileNo");
				String emailId = request.getParameter("emailId");
				String status = request.getParameter("status");
				String uniqueNo = request.getParameter("uniqueNo");
				String groupIdvehicle = request.getParameter("groupId");
				String tripType = request.getParameter("tripType");
				String days = request.getParameter("days");
				String alertname = request.getParameter("alertname");
				String auto = request.getParameter("auto");
				String superMobileNo = request.getParameter("superMobileNo");
				String superEmailId = request.getParameter("superEmailId");
				if (auto != "") {
					autoval = Integer.parseInt(auto);
				}
				if (days != "") {
					daysval = Integer.parseInt(days);
				}
				String message = "";

				if (buttonValue.equals("add") && custId != null && !custId.equals("")) {

					if (assignTo.equalsIgnoreCase("Group")) {
						int uniqueId = cashVanfunc.getUniqueId();
						uniqueId++;
						if (returnRouteName != "") {
							returnRouteId = Integer.parseInt(returnRouteName);
						}
						String groupids[] = groupName.split(",");
						for (int i = 0; i < groupids.length; i++) {

							message = cashVanfunc.insertTripDetails(Integer.parseInt(custId), Integer.parseInt(routeName), returnRouteId, assignTo, Integer.parseInt(groupids[i]), " ", guestAlert,
									mobileNo, emailId, status, userID, systemId, uniqueId, tripType, daysval, autoval, alertname, superEmailId, superMobileNo);
						}

					} else {

						String vehicleNo1[] = vehicleNo.split(",");
						String groupids[] = groupIdvehicle.split(",");
						int uniqueId = cashVanfunc.getUniqueId();
						uniqueId++;
						if (returnRouteName != "") {
							returnRouteId = Integer.parseInt(returnRouteName);
						}

						for (int i = 0; i < vehicleNo1.length; i++) {
							if (assignTo.equalsIgnoreCase("vehicle")) {
								groupId = Integer.parseInt(groupids[i]);
							}
							message = cashVanfunc.insertTripDetails(Integer.parseInt(custId), Integer.parseInt(routeName), returnRouteId, assignTo, groupId, vehicleNo1[i], guestAlert, mobileNo,
									emailId, status, userID, systemId, uniqueId, tripType, daysval, autoval, alertname, superEmailId, superMobileNo);
						}

					}
				} else if (buttonValue.equals("Modify") && custId != null && !custId.equals("")) {
					message = cashVanfunc.modifyTripDetails(Integer.parseInt(custId), guestAlert, mobileNo, emailId, userID, systemId, Integer.parseInt(uniqueNo), status, superEmailId, superMobileNo);
				}

				response.getWriter().print(message);
			} catch (Exception e) {
				e.printStackTrace();
			}
		}

		else if (param.equalsIgnoreCase("getTripDetails")) {
			try {
				String customerId = request.getParameter("CustId");
				String startDate = request.getParameter("startdate");
				String endDate = request.getParameter("enddate");
				jsonObject = new JSONObject();
				jsonArray = new JSONArray();
				if (customerId != null && !customerId.equals("")) {
					startDate = startDate.replaceAll("T", " ");
					endDate = endDate.replaceAll("T", " ");
					ArrayList<Object> list1 = cashVanfunc.getTripDetails(systemId, Integer.parseInt(customerId), startDate, endDate);
					jsonArray = (JSONArray) list1.get(0);
					if (jsonArray.length() > 0) {
						jsonObject.put("ticketDetailsRoot", jsonArray);
					} else {
						jsonObject.put("ticketDetailsRoot", "");
					}
					response.getWriter().print(jsonObject.toString());
				} else {
					jsonObject.put("ticketDetailsRoot", "");
					response.getWriter().print(jsonObject.toString());
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
		}

		else if (param.equals("closeTrip")) {
			try {

				String clientId = request.getParameter("custId");
				String remark = request.getParameter("remark");
				String uniqueId = request.getParameter("uniqueNo");
				String message = "";

				if (clientId != null) {
					message = cashVanfunc.closeTrip(systemId, Integer.parseInt(clientId), userID, Integer.parseInt(uniqueId), remark);

				}

				response.getWriter().print(message);
			}

			catch (Exception e) {
				e.printStackTrace();
			}
		}

		else if (param.equals("getVehicledetailsForModify")) {
			try {

				String clientId = request.getParameter("custId");

				String uniqueId = request.getParameter("uniqueId");

				jsonObject = new JSONObject();
				if (clientId != null) {
					jsonArray = cashVanfunc.getVehiclesForModify(systemId, Integer.parseInt(clientId), userID, Integer.parseInt(uniqueId));
					jsonObject.put("clientVehiclesForModify", jsonArray);
				} else {
					jsonObject.put("clientVehiclesForModify", "");
				}
				response.getWriter().print(jsonObject.toString());
			}

			catch (Exception e) {
				e.printStackTrace();
			}
		}

		else if (param.equals("getGroupdetailsForModify")) {
			try {

				String clientId = request.getParameter("custId");

				String uniqueId = request.getParameter("uniqueId");

				jsonObject = new JSONObject();
				if (clientId != null) {
					jsonArray = cashVanfunc.getGroupForModify(systemId, Integer.parseInt(clientId), userID, Integer.parseInt(uniqueId));
					jsonObject.put("clientGroupsForModify", jsonArray);
				} else {
					jsonObject.put("clientGroupsForModify", "");
				}
				response.getWriter().print(jsonObject.toString());
			}

			catch (Exception e) {
				e.printStackTrace();
			}
		} else if (param.equals("getAlert")) {

			try {

				jsonObject = new JSONObject();
				jsonArray = cashVanfunc.getAlerts(systemId);
				if (jsonArray.length() > 0) {
					jsonObject.put("alertStoreList", jsonArray);
				} else {
					jsonObject.put("alertStoreList", "");
				}
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		} else if (param.equals("getalertNameForModify")) {
			try {

				String clientId = request.getParameter("custId");

				String uniqueId = request.getParameter("uniqueId");

				jsonObject = new JSONObject();
				if (clientId != null) {
					jsonArray = cashVanfunc.getAlertsForModify(systemId, Integer.parseInt(clientId), userID, Integer.parseInt(uniqueId));
					jsonObject.put("alertnamesForModify", jsonArray);
				} else {
					jsonObject.put("alertnamesForModify", "");
				}
				response.getWriter().print(jsonObject.toString());
			}

			catch (Exception e) {
				e.printStackTrace();
			}
		}

		return null;

	}

}
