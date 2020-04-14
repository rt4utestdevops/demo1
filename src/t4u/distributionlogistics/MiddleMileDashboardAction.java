package t4u.distributionlogistics;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
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
import t4u.beans.ReportHelper;
import t4u.functions.CashVanManagementFunctions;
import t4u.functions.CommonFunctions;
import t4u.functions.CreateTripFunction;
import t4u.functions.DistributionLogisticsFunctions;

public class MiddleMileDashboardAction extends Action {
	public ActionForward execute(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		HttpSession session = request.getSession();
		String param = "";
		String zone = "";
		int systemId = 0;
		int userId = 0;
		int offset = 0;
		int custId = 0;
		String distUnits = "";
		SimpleDateFormat ddmmyyyy = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
		SimpleDateFormat yyyymmdd = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		LoginInfoBean loginInfo = (LoginInfoBean) session
				.getAttribute("loginInfoDetails");
		systemId = loginInfo.getSystemId();
		custId = loginInfo.getCustomerId();
		zone = loginInfo.getZone();
		userId = loginInfo.getUserId();
		offset = loginInfo.getOffsetMinutes();
		String lang = loginInfo.getLanguage();
		zone = loginInfo.getZone();
		CommonFunctions cf = new CommonFunctions();
		distUnits = cf.getUnitOfMeasure(systemId);
		DistributionLogisticsFunctions dlf = new DistributionLogisticsFunctions();
		JSONArray jsonArray = null;
		JSONObject jsonObject = new JSONObject();
		if (request.getParameter("param") != null) {
			param = request.getParameter("param").toString();
		}
		if (param.equals("getHubDetails")) {
			try {
				jsonObject = new JSONObject();
				if (custId != 0) {
					jsonArray = dlf.getHubDetails(custId, systemId, zone,userId);
					jsonObject.put("HubDetailsRoot", jsonArray);
				} else {
					jsonObject.put("HubDetailsRoot", "");
				}
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}

		}
		else if (param.equals("getHubs")) {
			try {
				jsonObject = new JSONObject();
				if (custId != 0) {
					
					jsonArray = dlf.getAllHubs(custId, systemId, zone,userId);
					jsonObject.put("HubDetailsRoot", jsonArray);
				} else {
					jsonObject.put("HubDetailsRoot", "");
				}
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}

		}
		else if (param.equals("getAlertDetails")) {
			try {
				String hubId = request.getParameter("hubId");
				jsonObject = new JSONObject();
				if (custId != 0) {
					jsonArray = dlf.getAlertDetails(custId, systemId,userId,offset,Integer.parseInt(hubId));
					jsonObject.put("AlertDetailsRoot", jsonArray);
				} else {
					jsonObject.put("AlertDetailsRoot", "");
				}
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}

		} 
		else if(param.equals("getTripSummaryDetailsForMLLReport")){
			String CustId = request.getParameter("CustId");
			String unit = cf.getUnitOfMeasure(systemId);
			String startDate = request.getParameter("startdate");
            String endDate = request.getParameter("enddate");
            String tripCustomerName = request.getParameter("tripCustomerName");
			try{
				jsonObject = new JSONObject();
				jsonArray = dlf.getTripSummaryDetailsForMLLReport(systemId,Integer.parseInt(CustId),offset,unit,userId,startDate,endDate,tripCustomerName);
					if(jsonArray.length() > 0){
						jsonObject.put("tripSummaryMLLDetailsgrid", jsonArray);
					}else{
						jsonObject.put("tripSummaryMLLDetailsgrid", "");
					}
				response.getWriter().print(jsonObject.toString());
			}catch(Exception e){
				e.printStackTrace();
			}
		}
		else if (param.equalsIgnoreCase("getGridDetails")) {
			try {
				String tripStatus = request.getParameter("tripType");
				String startDate = request.getParameter("startdate");
				String endDate = request.getParameter("enddate") + " "
						+ "23:59:59";
				String hubId = request.getParameter("hubId");
				jsonObject = new JSONObject();
				jsonArray = new JSONArray();
				if (custId != 0) {
					startDate = startDate.replaceAll("T", " ");
					endDate = endDate.replaceAll("T", " ");
					ArrayList<Object> list1 = dlf.getDashBoardGridDetails(
							systemId, custId, offset, startDate, endDate,
							distUnits, tripStatus,Integer.parseInt(hubId),userId);
					jsonArray = (JSONArray) list1.get(0);
					// System.out.println(jsonArray);
					if (jsonArray.length() > 0) {
						jsonObject.put("gridDetailsRoot", jsonArray);
					} else {
						jsonObject.put("gridDetailsRoot", "");
					}
					// reportHelper = (ReportHelper) list1.get(1);
					// request.getSession().setAttribute(jspName, reportHelper);
					// request.getSession().setAttribute("customerId",
					// custName);
					response.getWriter().print(jsonObject.toString());
				} 
			} catch (Exception e) {
				e.printStackTrace();
			}
		}

		else if (param.equals("getVehiclePlacementChartDashBoard")) {
			try {
				String hubId = request.getParameter("hubId");
				// System.out.println("HUBID : "+hubId);
				String startDate = request.getParameter("startDate");
				String endDate = request.getParameter("endDate") + " "+ "23:59:59";
				jsonObject = new JSONObject();
				jsonArray = dlf.getVehiclePlacementChartData(systemId, custId,
						offset, startDate, endDate, Integer.parseInt(hubId),userId);
				if (jsonArray.length() > 0) {
					jsonObject.put("vehiclePlacementDetailsRoot", jsonArray);
				} else {
					jsonObject.put("vehiclePlacementDetailsRoot", "");
				}
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		}

		else if (param.equals("getOnTimePlacementDashBoard")) {
			try {
				jsonObject = new JSONObject();
				String hubId = request.getParameter("hubId");
				String startDate = request.getParameter("startDate");
				String endDate = request.getParameter("endDate") + " "+ "23:59:59";
				String finacialYear = request.getParameter("financialYear");
				
				jsonArray = dlf.getOnTimePlacement(systemId, custId, Integer.parseInt(hubId), startDate, endDate, offset,userId);
				//System.out.println(jsonArray);
				if (jsonArray.length() > 0) {
					jsonObject.put("onTimePlacementDetailsRoot", jsonArray);
				} else {
					jsonObject.put("onTimePlacementDetailsRoot", "");
				}
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		else if (param.equalsIgnoreCase("getAlertTableDetails")) {
			try {
				int alertId = Integer.parseInt(request.getParameter("alertId"));
				String hubId = request.getParameter("hubId");
				jsonObject = new JSONObject();
				jsonArray = new JSONArray();
				if (custId != 0) {
					ArrayList<Object> list1 = dlf.getAlertTableDetails(
							systemId, custId, offset,alertId,userId,Integer.parseInt(hubId) );
					jsonArray = (JSONArray) list1.get(0);
					// System.out.println(jsonArray);
					if (jsonArray.length() > 0) {
						jsonObject.put("alertTableRoot", jsonArray);
					} else {
						jsonObject.put("alertTableRoot", "");
					}
					// reportHelper = (ReportHelper) list1.get(1);
					// request.getSession().setAttribute(jspName, reportHelper);
					// request.getSession().setAttribute("customerId",
					// custName);
					response.getWriter().print(jsonObject.toString());
				} 
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		else if (param.equalsIgnoreCase("getVehiclePlacementTableDetails")) {
			try {
				String selectionType = request.getParameter("selectionType");
				String hubId = request.getParameter("hubId");
				String date = request.getParameter("date");
				jsonObject = new JSONObject();
				jsonArray = new JSONArray();
				if (custId != 0) {
					ArrayList<Object> list1 = dlf.getVehiclePlacementTableDetails(
							systemId, custId, offset,selectionType,userId,Integer.parseInt(hubId),date );
					jsonArray = (JSONArray) list1.get(0);
					// System.out.println(jsonArray);
					if (jsonArray.length() > 0) {
						jsonObject.put("vehiclePlacementTableRoot", jsonArray);
					} else {
						jsonObject.put("vehiclePlacementTableRoot", "");
					}
					// reportHelper = (ReportHelper) list1.get(1);
					// request.getSession().setAttribute(jspName, reportHelper);
					// request.getSession().setAttribute("customerId",
					// custName);
					response.getWriter().print(jsonObject.toString());
				} 
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		else if (param.equalsIgnoreCase("getOnTimePlacementTableDetails")) {
			try {
				String selectionType = request.getParameter("selectionType");
				String hubId = request.getParameter("hubId");
				String date = request.getParameter("date");
				jsonObject = new JSONObject();
				jsonArray = new JSONArray();
				if (custId != 0) {
					ArrayList<Object> list1 = dlf.getOnTimePlacementTableDetails(
							systemId, custId, offset,selectionType,userId,Integer.parseInt(hubId),date );
					jsonArray = (JSONArray) list1.get(0);
					// System.out.println(jsonArray);
					if (jsonArray.length() > 0) {
						jsonObject.put("onTimePlacementTableRoot", jsonArray);
					} else {
						jsonObject.put("onTimePlacementTableRoot", "");
					}
					// reportHelper = (ReportHelper) list1.get(1);
					// request.getSession().setAttribute(jspName, reportHelper);
					// request.getSession().setAttribute("customerId",
					// custName);
					response.getWriter().print(jsonObject.toString());
				} 
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		else if (param.equals("saveunloadingvehicle")) {
			try {
				String Date=request.getParameter("Date");
				String destination=request.getParameter("dest");
			    //Dates=Date+" "+hours+":"+minutes;
				int tripId = Integer.parseInt(request.getParameter("tripId"));
				String vehicleNo = request.getParameter("vehicleNo");
				int alertType = 0;
				String alertName =request.getParameter("alert");
				String location = request.getParameter("currentLocation");
				String message="";				
				message = dlf.insertunloadingdetails(systemId,userId,tripId,offset,custId,Date,vehicleNo,alertType,alertName,location,destination);				
				response.getWriter().print(message.toString());
			}

			catch (Exception e) {
				e.printStackTrace();
			}
		}
		
		else if(param.equalsIgnoreCase("saveTripRemarks")){
			try{				
				int tripId = Integer.parseInt(request.getParameter("tripId"));
				String vehicleNo = request.getParameter("vehicleNo");
				int alertType = 0;
				String remarks = request.getParameter("remarks");
				String alertName = "RAMARKS";
				int hubId = Integer.parseInt(request.getParameter("hubId"));
				String location = request.getParameter("currentLocation");
				String message = dlf.insertTripRemarks(tripId, vehicleNo, alertType,location, alertName, remarks, hubId, systemId, custId) ;
				
				response.getWriter().print(message.toString());
			}catch (Exception e) {
				response.getWriter().print(e.toString());
				e.printStackTrace();
			}
		}else if(param.equalsIgnoreCase("getTripRemarks")){
			try {
				int tripId = Integer.parseInt(request.getParameter("tripId"));
				String remarks = dlf.getTripRemarksByTripId(tripId);
				jsonObject.put("tripRemarks", remarks);
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		}else if(param.equals("getVehicleSummaryReport")){
			String CustId = request.getParameter("CustId");
			String unit = cf.getUnitOfMeasure(systemId);
			String startDate = request.getParameter("startdate");
            String endDate = request.getParameter("enddate");
            endDate = endDate + " 23:59:59";
			try{
				jsonObject = new JSONObject();
				jsonArray = dlf.getVehicleSummaryReport(systemId,Integer.parseInt(CustId),offset,unit,userId,startDate,endDate);
					if(jsonArray.length() > 0){
						jsonObject.put("vehicleSummaryGrid", jsonArray);
					}else{
						jsonObject.put("vehicleSummaryGrid", "");
					}
				response.getWriter().print(jsonObject.toString());
			}catch(Exception e){
				e.printStackTrace();
			}
		}else if (param.equals("getVehiclesFromAssetReporting")) {
			try {
				jsonObject = new JSONObject();
				String startDate = request.getParameter("startdate");
	            String endDate = request.getParameter("enddate");
	            
				jsonArray = dlf.getVehiclesFromAssetReporting(systemId,custId, userId,startDate,endDate);
				jsonObject.put("VehiclesRoot", jsonArray);
				response.getWriter().print(jsonObject.toString());
			}
			catch (Exception e) {
				e.printStackTrace();
			}
		}else if(param.equals("getVehicleTripReport")){
			String CustId = request.getParameter("CustId");
			String unit = cf.getUnitOfMeasure(systemId);
			String startDate = request.getParameter("startdate");
            String endDate = request.getParameter("enddate");
            endDate = endDate + " 23:59:59";
            String hubId = request.getParameter("hubId");
            String vehicleNumber = request.getParameter("vehicleNumber");
			try{
				jsonObject = new JSONObject();
				jsonArray = dlf.getVehicleTripReport(systemId,Integer.parseInt(CustId),offset,unit,userId,startDate,endDate,hubId,vehicleNumber);
					if(jsonArray.length() > 0){
						jsonObject.put("vehicleTripGrid", jsonArray);
					}else{
						jsonObject.put("vehicleTripGrid", "");
					}
				response.getWriter().print(jsonObject.toString());
			}catch(Exception e){
				e.printStackTrace();
			}
		}
		return null;
	}
}
