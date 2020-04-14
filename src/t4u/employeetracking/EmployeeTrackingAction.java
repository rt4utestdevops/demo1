package t4u.employeetracking;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.struts.action.Action;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.json.JSONArray;
import org.json.JSONObject;

import t4u.functions.CommonFunctions;
import t4u.functions.EmployeetrackingFunctions;

/**
 * 
 * @author Administrator this class is used to getting the records of
 *         ltsp,user,customers,vehicles and employee tracking records
 * 
 */

public class EmployeeTrackingAction extends Action {

	public ActionForward execute(ActionMapping mapping, ActionForm form,HttpServletRequest request, HttpServletResponse response)throws Exception {
		String param = "";
		String message = "";		
		HttpSession session = request.getSession();
		EmployeetrackingFunctions etf = new EmployeetrackingFunctions();
		CommonFunctions cfuncs = new CommonFunctions();
		JSONArray jsonArray = null;
		JSONObject jsonObject = new JSONObject();
		if (request.getParameter("param") != null) {
			param = request.getParameter("param").toString();
		}

		/**
		 * fetching all facilitydailytaskupdate list
		 */

		if (param.equals("getFacilityDailyTaskListUpdate")) {

			try {

				jsonArray = new JSONArray();
				jsonObject = new JSONObject();

				String customerId = "0";
				if (request.getParameter("CustId") != null
						&& !request.getParameter("CustId").equals("")) {
					customerId = request.getParameter("CustId").toString();
				}
				String ltspId = "0";
				if (request.getParameter("LTSPId") != null
						&& !request.getParameter("LTSPId").equals("")) {
					ltspId = request.getParameter("LTSPId").toString();
				}
				String vehicleId = "0";
				if (request.getParameter("VehicleId") != null
						&& !request.getParameter("VehicleId").equals("")) {
					vehicleId = request.getParameter("VehicleId").toString();
				}

				if (Integer.parseInt(customerId) > 0) {
					jsonArray = etf.getFacilityDailyTaskListUpdate(ltspId,
							customerId, vehicleId);
				}
				if (jsonArray.length() > 0) {
					jsonObject.put("FacilityTaskList", jsonArray);
				} else {
					jsonObject.put("FacilityTaskList", "");
				}
				response.getWriter().print(jsonObject.toString());

			} catch (Exception e) {
				e.printStackTrace();
				System.out
						.println("Error in EmployeeTrackingAction:-getFacilityDailyTaskListUpdate"
								+ e);
			}
		}

		/**
		 * getting all LTSP records
		 */

		if (param.equals("getLTSP")) {

			try {
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();

				jsonArray = etf.getLTSP();
				if (jsonArray.length() > 0) {
					jsonObject.put("LTSPRoot", jsonArray);
				} else {
					jsonObject.put("LTSPRoot", "");
				}
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {
				System.out.println("Error in EmployeeTrackingAction:-getLTSP"
						+ e);
			}
		}

		/**
		 * getting all users records
		 */
		if (param.equals("getUser")) {

			try {
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				jsonArray = etf.getUser();
				if (jsonArray.length() > 0) {
					jsonObject.put("UserRoot", jsonArray);
				} else {
					jsonObject.put("UserRoot", "");
				}
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {
				System.out.println("Error in EmployeeTrackingAction:-getUser"
						+ e);
			}
		}

		/**
		 * getting vehicles details on the basis of selected customer and ltsp
		 */
		if (param.equals("getVehicleDetails")) {

			try {
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				String custId = request.getParameter("CustId");
				String ltspId = request.getParameter("LTSPId");

				if (custId != null && ltspId != null) {
					jsonArray = etf.getVehicleDetails(custId, ltspId);
				}
				if (jsonArray.length() > 0) {
					jsonObject.put("VehicleRoot", jsonArray);
				} else {
					jsonObject.put("VehicleRoot", "");
				}
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {
				System.out
						.println("Error in EmployeeTrackingAction:-getVehicleDetails"
								+ e);
			}

		}

		/**
		 * getting customer on the basis of ltsp
		 */
		if (param.equals("getCustomer")) {

			try {
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();

				String ltspId = request.getParameter("LtspId");

				jsonArray = cfuncs.getCustomer(Integer.parseInt(ltspId.trim()),"no", 0);
				if (jsonArray.length() > 0) {
					jsonObject.put("CustomerRoot", jsonArray);
				} else {
					jsonObject.put("CustomerRoot", "");
				}
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		}

		/**
		 * saving employee tracking details into db
		 */

		if (param.equals("saveEmployeeTrackingDetails")) {

			try {
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();

				JSONArray editorGridData = new JSONArray("["+ request.getParameter("jasondata").toString() + "]");
				String ltsp = request.getParameter("LTSP");
				String user = request.getParameter("User");
				String customer = request.getParameter("Customer");
				String vehicleNo = request.getParameter("VehicleNo");
				String reptime = request.getParameter("Reptime");
				String exitTime = request.getParameter("ExitTime");
				String newReInstall = request.getParameter("NewReInstall");
				String unInstall = request.getParameter("UnInstall");
				String upkeep = request.getParameter("Upkeep");
				String software = request.getParameter("Software");
				String imei = request.getParameter("IMEINo");
				String devType = request.getParameter("DevType");

				String GPS_TIME_REMARKS = "";
				String LOCATION_REMARKS = "";
				String LAST_SWIPE_REMARKS = "";
				String LAST_PANIC_REMARKS = "";
				String LAST_OS_REMARKS = "";
				String LAST_TRIP_SHEET_REMARKS = "";
				String LAST_OS_EMAIL_REMARKS = "";
				String LAST_OS_SMS_REMARKS = "";
				String LAST_PANIC_EMAIL_REMARKS = "";
				String LAST_PANIC_SMS_REMARKS = "";

				for (int i = 0; i < editorGridData.length(); i++) {
					JSONObject obj1 = editorGridData.getJSONObject(i);
					String remarks = obj1.getString("REMARKS");
					String items = obj1.getString("ITEMS");
					if (items.equals("Last Packet Date Time")
							&& remarks != null) {
						GPS_TIME_REMARKS = remarks;
					} else if (items.equals("Location") && remarks != null) {
						LOCATION_REMARKS = remarks;
					} else if (items.equals("HID") && remarks != null) {
						LAST_SWIPE_REMARKS = remarks;
					} else if (items.equals("Panic") && remarks != null) {
						LAST_PANIC_REMARKS = remarks;
					} else if (items.equals("Overspeed") && remarks != null) {
						LAST_OS_REMARKS = remarks;
					} else if (items.equals("Tripsheet Data")
							&& remarks != null) {
						LAST_TRIP_SHEET_REMARKS = remarks;
					} else if (items.equals("Over speed Email Alerts")
							&& remarks != null) {
						LAST_OS_EMAIL_REMARKS = remarks;
					} else if (items.equals("Over speed SMS Alerts")
							&& remarks != null) {
						LAST_OS_SMS_REMARKS = remarks;
					} else if (items.equals("Distress Email Alerts")
							&& remarks != null) {
						LAST_PANIC_EMAIL_REMARKS = remarks;
					} else if (items.equals("Distress SMS Alerts")
							&& remarks != null) {
						LAST_PANIC_SMS_REMARKS = remarks;
					}
				}
				message = etf.saveEmployeeTrackingDetails(ltsp, customer, user,
						vehicleNo, reptime, exitTime, newReInstall, unInstall,
						upkeep, software, imei, devType, GPS_TIME_REMARKS,
						LOCATION_REMARKS, LAST_SWIPE_REMARKS,
						LAST_PANIC_REMARKS, LAST_OS_REMARKS,
						LAST_TRIP_SHEET_REMARKS, LAST_OS_EMAIL_REMARKS,
						LAST_OS_SMS_REMARKS, LAST_PANIC_EMAIL_REMARKS,
						LAST_PANIC_SMS_REMARKS);

				response.getWriter().print(message);

			} catch (Exception e) {
				e.printStackTrace();
				System.out
						.println("Error in EmployeeTrackingAction:-saveEmployeeTrackingDetails"
								+ e);
			}

		}

		/**
		 * getting reporting time and exit time
		 */
		if (param.equals("getreportExitTime")) {

			try {
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();

				String ltspId = "0";
				if (request.getParameter("LTSPId") != null
						&& !request.getParameter("LTSPId").equals("")) {
					ltspId = request.getParameter("LTSPId").toString();
				}

				String userId = "0";
				if (request.getParameter("UserId") != null
						&& !request.getParameter("UserId").equals("")) {
					userId = request.getParameter("UserId").toString();
				}

				if (Integer.parseInt(ltspId) > 0) {
					jsonArray = etf.getReportingExittime(ltspId, userId);
				}
				if (jsonArray.length() > 0) {
					jsonObject.put("ReportExitStore", jsonArray);

				} else {
					jsonObject.put("ReportExitStore", "");
				}
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {
				System.out.println("Error in EmployeeTrackingAction:-getreportExitTime"+ e);
			}
		}
		return null;
	}
}
