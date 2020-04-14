package t4u.common;

import java.nio.charset.*;
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
import t4u.functions.HistoryAnalysisFunction;

public class HistoryAnalysisAction extends Action {

	public ActionForward execute(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response) {

		HttpSession session = ((HttpServletRequest) request).getSession();
		LoginInfoBean logininfo = (LoginInfoBean) session
				.getAttribute("loginInfoDetails");
		HistoryAnalysisFunction historyTrackingFunctions = new HistoryAnalysisFunction();
		CommonFunctions cf = new CommonFunctions();
		String param = "";
		if (request.getParameter("param") != null) {
			param = request.getParameter("param").toString();
		}
		int ltsp = 2;
		int customerid = 0;
		int ClientId = 0;
		int systemid = 0;
		int offset = 0;
		int userid = 0;
		String zone = "";
		String serverName = request.getServerName();
		String sessionId = request.getSession().getId();
		if (logininfo != null) {
			customerid = logininfo.getCustomerId();
			ltsp = logininfo.getIsLtsp();
			ClientId = logininfo.getCustomerId();
			systemid = logininfo.getSystemId();
			userid = logininfo.getUserId();
			offset = logininfo.getOffsetMinutes();
			zone = logininfo.getZone();
		}
		/*****************************************************************************************************
		 * Get Vehicles Tracking History
		 *****************************************************************************************************/
		if (param.equals("getVehicleTrackingHistory") || param.equals("submit")
				|| param.equals("sandReport")
				|| param.equals("shiftWiseTripReport")) {
			try {
			
				//t4u506 start
				SimpleDateFormat sdfFormatDate = new SimpleDateFormat(
						"MM/dd/yyyy HH:mm:ss");
				String reqStartTime = cf.getGMT(new Date(), offset);
				System.out.println("Requested time is " + reqStartTime);
					//t4u506 end
				
				JSONArray jsonArray = null;
				JSONObject jsonObject = null;

				String vehicleNo = "";
				String startDate = "";
				String endDate = "";
				String startHour = "";
				String EndHour = "";
				String StartMin = "";
				String EndMin = "";
				int tBandValueInt = 0;
				String recordForTwoMin = "";
				String recordForSixhrs = "";
				if (request.getParameter("vehicleNo") != null
						&& !request.getParameter("vehicleNo").equals("")) {
					vehicleNo = request.getParameter("vehicleNo");
					byte[] bytes = vehicleNo.getBytes(Charset
							.forName("ISO-8859-1"));
					vehicleNo = new String(bytes, Charset.forName("UTF-8"));
				}
				if (request.getParameter("startdate") != null
						&& !request.getParameter("startdate").equals("")) {
					startDate = request.getParameter("startdate");
				}
				if (request.getParameter("enddate") != null
						&& !request.getParameter("enddate").equals("")) {
					endDate = request.getParameter("enddate");
				}
				if (request.getParameter("startdatetimehr") != null
						&& !request.getParameter("startdatetimehr").equals("")) {
					startHour = request.getParameter("startdatetimehr");
				}
				if (request.getParameter("endtimehr") != null
						&& !request.getParameter("endtimehr").equals("")) {
					EndHour = request.getParameter("endtimehr");
				}
				if (request.getParameter("startdatetimemin") != null
						&& !request.getParameter("startdatetimemin").equals("")) {
					StartMin = request.getParameter("startdatetimemin");
				}
				if (request.getParameter("endtimemin") != null
						&& !request.getParameter("endtimemin").equals("")) {
					EndMin = request.getParameter("endtimemin");
				}
				if (request.getParameter("timeband") != null
						&& !request.getParameter("timeband").equals("")) {
					tBandValueInt = Integer.parseInt(request
							.getParameter("timeband"));
				}
				if (request.getParameter("recordForTwoMin") != null
						&& !request.getParameter("recordForTwoMin").equals("")) {
					recordForTwoMin = request.getParameter("recordForTwoMin");
				}
				if (request.getParameter("recordForSixhrs") != null
						&& !request.getParameter("recordForSixhrs").equals("")) {
					recordForSixhrs = request.getParameter("recordForSixhrs");
				}
				String startDateTime = startDate + " " + startHour + ":"
						+ StartMin + ":" + "00";
				String endDateTime = endDate + " " + EndHour + ":" + EndMin
						+ ":" + "00";

				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				
				jsonArray = historyTrackingFunctions.getVehicleTrackingHistory(
						vehicleNo, startDateTime, endDateTime, offset,
						systemid, ClientId, tBandValueInt, recordForTwoMin,
						recordForSixhrs, userid);

							
				if (jsonArray.length() > 0) {
					jsonObject.put("vehiclesTrackingRoot", jsonArray);
				} else {
					jsonObject.put("vehiclesTrackingRoot", "");
				}
				
				response.getWriter().print(jsonObject.toString());
				
					//			t4u506 start
				
				String reqEndTime = cf.getGMT(new Date(), offset);
				System.out.println("Responded time is " + reqEndTime);
				
			//	jsonObject.put("reqStartTime", reqStartTime);
			//	jsonObject.put("reqEndTime", reqEndTime);
				
				try {
				/*	cf.insertDataIntoAuditLogReport(sessionId, null,
							"History Analysis", "View", userid, serverName,
							systemid, ClientId, "History Analysis for "
									+ vehicleNo + " startDate " + startDateTime
									+ " endDate " + endDateTime
								);
					*/
					cf.insertDataIntoAuditLogReportMaps(sessionId, null,
							"History Analysis", "View", userid, serverName,
							systemid, ClientId, "History Analysis for "
									+ vehicleNo + " startDate " + startDateTime
									+ " endDate " + endDateTime,reqStartTime,reqEndTime
								);
					
				} 	
				catch (Exception e) {
					e.printStackTrace();
				}

			} catch (Exception e) {

			}
			

			
		}
		

		/*****************************************************************************************************
		 * Get Vehicles for History Analysis Combo
		 *****************************************************************************************************/
		if (param.equalsIgnoreCase("getVehicles")) {
			try {
				JSONArray jsonArray = null;
				JSONObject jsonObject = null;
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				jsonArray = historyTrackingFunctions.getVehicles(userid,
						customerid, systemid, ltsp);
				if (jsonArray.length() > 0) {
					jsonObject.put("vehiclesRoot", jsonArray);
				} else {
					jsonObject.put("vehiclesRoot", "");
				}
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {

			}
		} else if (param.equalsIgnoreCase("getOptionNames")) {
			try {
				JSONArray jsonArray = null;
				JSONObject jsonObject = null;
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				jsonArray = historyTrackingFunctions.getOptionNames();
				if (jsonArray.length() > 0) {
					jsonObject.put("optionsDetailsRoot", jsonArray);
				} else {
					jsonObject.put("optionsDetailsRoot", "");
				}
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {

			}
		}
		return null;
	}
	

}
