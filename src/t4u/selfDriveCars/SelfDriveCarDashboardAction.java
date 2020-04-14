package t4u.selfDriveCars;

import java.text.SimpleDateFormat;
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
import t4u.functions.CommonFunctions;
import t4u.functions.SelfDriveCarsFunctions;

public class SelfDriveCarDashboardAction extends Action {

	@SuppressWarnings("unused")
	public ActionForward execute(ActionMapping map, ActionForm form, HttpServletRequest req, HttpServletResponse resp) {
		try {
			HttpSession session = req.getSession();
			LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
			CommonFunctions commonfunc = new CommonFunctions();
			SimpleDateFormat yyyyMMdd = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			SimpleDateFormat ddmmyyyy = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
			SimpleDateFormat ddmmyyyy1 = new SimpleDateFormat("dd/MM/yyyy");
			SimpleDateFormat ddmmyyyy2 = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
			int systemId = 0;
			int customerId = 0;
			int offset = 0;
			int userId = 0;
			int isLtsp = 0;
			int nonCommHrs = 0;
			String lang = "";
			String zone = "";
			if (loginInfo != null) {
				systemId = loginInfo.getSystemId();
				customerId = loginInfo.getCustomerId();
				offset = loginInfo.getOffsetMinutes();
				userId = loginInfo.getUserId();
				isLtsp = loginInfo.getIsLtsp();
				nonCommHrs = loginInfo.getNonCommHrs();
				lang = loginInfo.getLanguage();
				zone = loginInfo.getZone();
			}

			String param = "";
			if (req.getParameter("param") != null) {
				param = req.getParameter("param");
			}
			JSONArray jArr = new JSONArray();
			JSONObject obj = null, obj2 = null, obj3 = null, finalobj = null;
			SelfDriveCarsFunctions sdcf = new SelfDriveCarsFunctions();

			if (param.equals("getDashboardCountsRow0")) {
				String startDate = req.getParameter("startDate");
				String endDate = req.getParameter("endDate");
				try {
					obj = new JSONObject();
					obj = sdcf.getDashboardCountsRow0(systemId, customerId, startDate, endDate, offset, userId);
					resp.getWriter().print(obj.toString());
				} catch (Exception e) {
					e.printStackTrace();
				}
			} else if (param.equals("getDashboardCountsRow1")) {
				String startDate = req.getParameter("startDate");
				String endDate = req.getParameter("endDate");
				String groupName = "";
				try {
					obj = new JSONObject();
					obj = sdcf.getDashboardCountsRow1(systemId, customerId, startDate, endDate, offset, userId, groupName);
					resp.getWriter().print(obj.toString());
				} catch (Exception e) {
					e.printStackTrace();
				}
			} else if (param.equals("getDashboardCountsRow2")) {
				String startDate = req.getParameter("startDate");
				String endDate = req.getParameter("endDate");
				String groupName = "";
				try {
					obj = new JSONObject();
					obj = sdcf.getDashboardCountsRow2(systemId, customerId, startDate, endDate, offset, userId, groupName);
					resp.getWriter().print(obj.toString());
				} catch (Exception e) {
					e.printStackTrace();
				}
			} else if (param.equals("getDashboardCountsRow3")) {
				String startDate = req.getParameter("startDate");
				String endDate = req.getParameter("endDate");
				String groupName = "";
				try {
					obj = new JSONObject();
					obj = sdcf.getDashboardCountsRow3(systemId, customerId, startDate, endDate, offset, userId, groupName);
					resp.getWriter().print(obj.toString());
				} catch (Exception e) {
					e.printStackTrace();
				}
			} else if (param.equalsIgnoreCase("getDataByType")) {
				String type = req.getParameter("type");
				String startDate = req.getParameter("startDate");
				String endDate = req.getParameter("endDate");
				String groupName = req.getParameter("groupName");
				try {

					System.out.println(" type :: " + type + "  START :: " + startDate + " END :: " + endDate + " GROUP NAME :: " + groupName);
					obj = new JSONObject();
					jArr = sdcf.getDataByType(systemId, customerId, type, startDate, endDate, offset, userId, zone, groupName);
					obj.put("tableDataByType", jArr);
					resp.getWriter().print(obj);
				} catch (Exception e) {
					e.printStackTrace();
				}
			} else if (param.equalsIgnoreCase("getVehicleCurrentPositions")) {
				String vehicles = req.getParameter("vehicles").toString();

				try {
					obj = new JSONObject();
					jArr = sdcf.getVehicleCurrentPositions(vehicles, systemId, customerId);
					obj.put("vehicleCurrPos", jArr);
					resp.getWriter().print(obj);
				} catch (Exception e) {
					e.printStackTrace();
				}
			} else if (param.equalsIgnoreCase("getGroupNames")) {
				try {
					obj = new JSONObject();
					jArr = sdcf.getGroupNames(systemId, customerId);
					obj.put("groupNameListRoot", jArr);
					resp.getWriter().print(obj);
				} catch (Exception e) {
					e.printStackTrace();
				}
			} else if (param.equalsIgnoreCase("getDataThroughEmail")) {
				String type = req.getParameter("type");
				String groupName = req.getParameter("groupName");
				String startDate = req.getParameter("startDate");
				String endDate = req.getParameter("endDate");
				try {
					obj = new JSONObject();
					 sdcf.sendMail(systemId, customerId, type, startDate, endDate, offset, userId, zone, groupName);
					obj.put("groupNameListRoot", jArr);
					resp.getWriter().print(obj);
				} catch (Exception e) {
					e.printStackTrace();
				}
			} else if (param.equals("getGroupNameBasedCounts")) {
				String groupName = req.getParameter("groupName");
				System.out.println(groupName);
				String startDate = req.getParameter("startDateNew");
				String endDate = req.getParameter("endDateNew");

				try {
					obj = new JSONObject();
					obj2 = new JSONObject();
					obj3 = new JSONObject();
					finalobj = new JSONObject();

					obj = sdcf.getDashboardCountsRow1(systemId, customerId, startDate, endDate, offset, userId, groupName);
					obj2 = sdcf.getDashboardCountsRow2(systemId, customerId, startDate, endDate, offset, userId, groupName);
					obj3 = sdcf.getDashboardCountsRow3(systemId, customerId, startDate, endDate, offset, userId, groupName);

					finalobj.put("row1", obj);
					finalobj.put("row2", obj2);
					finalobj.put("row3", obj3);
					System.out.println(finalobj);
					resp.getWriter().print(finalobj);
				} catch (Exception e) {
					e.printStackTrace();
				}
			}else if (param.equals("sendAuditLog")) {
				String reqStartTime = commonfunc.getGMT(new Date(), offset);
			    String serverName = req.getServerName();
				String sessionId = req.getParameter("sessionId");
				String startDate = req.getParameter("startDate");
				String endDate = req.getParameter("endDate");
				
				try{
					String reqEndTime = commonfunc.getGMT(new Date(), offset);
					commonfunc.insertDataIntoAuditLogReportMaps(sessionId, null,"Operations Dashboard", "View", userId, serverName,
					systemId, customerId, "Viewed the Operation Dashboard Details " + "@" + " startDate " + startDate+ "@" + " endDate " + endDate,reqStartTime,reqEndTime);
				}catch (Exception e) {
					e.printStackTrace();
				}
				
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}

}
