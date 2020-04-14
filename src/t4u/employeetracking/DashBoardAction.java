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

import t4u.beans.LoginInfoBean;
import t4u.functions.DashBoardFunctions;

public class DashBoardAction extends Action {
	public ActionForward execute(ActionMapping mapping, ActionForm form,HttpServletRequest request, HttpServletResponse response)throws Exception {
		
		String param = "";
		HttpSession session = request.getSession();
		LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
		if(loginInfo!=null)
		{
		int isLtsp=2;		
		int systemId = loginInfo.getSystemId();
		int clientIdd = loginInfo.getCustomerId();
		isLtsp=loginInfo.getIsLtsp();
		int userId=loginInfo.getUserId();
		int offset=loginInfo.getOffsetMinutes();
		DashBoardFunctions dashfunc = new DashBoardFunctions();
		JSONArray jsonArray = null;
		JSONObject jsonObject = new JSONObject();
		if (request.getParameter("param") != null) {
			param = request.getParameter("param").toString();
		}

		/***************************************************************************************************************************************************
		 * Gets Total No of Distress Alerts
		 ***************************************************************************************************************************************************/
		if (param.equalsIgnoreCase("getDistressCount")) {
			try {
				String customerid = request.getParameter("custID");
				String prevDistressCount = request.getParameter("prevDistressCount");
				String prevClientID = request.getParameter("prevClientID");
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				jsonArray = dashfunc.getDistressAlert(customerid, systemId,prevDistressCount, prevClientID,userId,offset);
				if (jsonArray.length() > 0) {
					jsonObject.put("DistressDetails", jsonArray);
				} else {
					jsonObject.put("DistressDetails", "");
				}
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {
				response.getWriter().print("error");
			}
		}

		/***************************************************************************************************************************************************
		 * Gets Total No of OverSpeed Alerts
		 ***************************************************************************************************************************************************/
		if (param.equalsIgnoreCase("getOverSpeedCount")) {
			try {
				String customerid = request.getParameter("custID");
				int overspeedCount = dashfunc.getOverSpeedAlert(customerid,systemId);
				response.getWriter().print(Integer.toString(overspeedCount));
			} catch (Exception e) {
				response.getWriter().print("error");
			}
		}

		/***************************************************************************************************************************************************
		 * Gets Total No of Vehicle Stoppage
		 **************************************************************************************************************************************************/
		if (param.equalsIgnoreCase("getIdleAlert")) {
			try {
				String customerid = request.getParameter("custID");
				int vehicleStoppage = dashfunc.getVehicleIdleeAlert(customerid,systemId);
				response.getWriter().print(Integer.toString(vehicleStoppage));
			} catch (Exception e) {
				response.getWriter().print("error");
			}
		}
		/***************************************************************************************************************************************************
		 * Gets Total No of Vehicles
		 **************************************************************************************************************************************************/
		if (param.equalsIgnoreCase("getTotalVehicles")) {
			try {
				String customerid = request.getParameter("custID");
				int userid = Integer.parseInt(request.getParameter("userid"));
				int vehicecount = dashfunc.getTotalVehicles(customerid,systemId,userid,isLtsp);
				response.getWriter().print(Integer.toString(vehicecount));
			} catch (Exception e) {
				response.getWriter().print("error");
			}
		}
		/***************************************************************************************************************************************************
		 * Gets Total No of Non Communicating Vehicles
		 **************************************************************************************************************************************************/
		if (param.equalsIgnoreCase("getNonCommunicatingVehicles")) {
			try {
				String customerid = request.getParameter("custID");
				int userid = Integer.parseInt(request.getParameter("userid"));
				int nonCommunicatingVehicecount = dashfunc.getNonCommunicatinVehicles(customerid, systemId,userid,isLtsp);
				response.getWriter().print(Integer.toString(nonCommunicatingVehicecount));
			} catch (Exception e) {
				response.getWriter().print("error");
			}
		}
		/***************************************************************************************************************************************************
		 * First Lady Pickup
		 **************************************************************************************************************************************************/
		if (param.equalsIgnoreCase("getFirstLadyPickup")) {
			try {
				String customerid = request.getParameter("custID");
				int firstLadyPickupcount = dashfunc.getFirstLadyPickup(customerid, systemId);
				response.getWriter().print(Integer.toString(firstLadyPickupcount));
			} catch (Exception e) {
				response.getWriter().print("error");
			}
		}
		/***************************************************************************************************************************************************
		 * HID not Swiped
		 **************************************************************************************************************************************************/
		if (param.equalsIgnoreCase("getHIDnotswiped")) {
			try {
				String customerid = request.getParameter("custID");
				int firstLadyPickupcount = dashfunc.getHIDnotSwiped(customerid,systemId);
				response.getWriter().print(Integer.toString(firstLadyPickupcount));
			} catch (Exception e) {
				response.getWriter().print("error");
			}
		}
		/***************************************************************************************************************************************************
		 * Get Trip Details
		 ****************************************************************************************************************************************************/
		if (param.equalsIgnoreCase("getTripDetails")) {
			try {
				String customerid = request.getParameter("custID");
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				jsonArray = dashfunc.getTripDetails(customerid, systemId);
				if (jsonArray.length() > 0) {
					jsonObject.put("TripDetails", jsonArray);
				} else {
					jsonObject.put("TripDetails", "");
				}
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {

			}
		}
		/*************************************************************************************************************************************************
		 * * Get Customer Lat Long for Google Map
		 ************************************************************************************************************************************************/
		if (param.equalsIgnoreCase("getcustomerLatLong")) {
			try {
				String facility = request.getParameter("facility");
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				jsonArray = dashfunc.getcustomerLatLong(facility, systemId);
				if (jsonArray.length() > 0) {
					jsonObject.put("CustomerLatLong", jsonArray);
				} else {
					jsonObject.put("CustomerLatLong", "");
				}
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {

			}
		}
		
		/*************************************************************************************************************************************************
		 * * Get vehicle for Google Map
		 ************************************************************************************************************************************************/
		if (param.equalsIgnoreCase("getMapVehicles")) {
			try {
				String facility = request.getParameter("facility");
				String customerid = request.getParameter("custID");
				String shifttime= request.getParameter("shifttime");
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				jsonArray = dashfunc.getMapVehicleDetails(customerid,facility, systemId,shifttime);
				if (jsonArray.length() > 0) {
					jsonObject.put("MapVehicles", jsonArray);
				} else {
					jsonObject.put("MapVehicles", "");
				}
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {

			}
		}
		
		/*************************************************************************************************************************************************
		 * * Get Shift for Facility
		 ************************************************************************************************************************************************/
		if (param.equalsIgnoreCase("getshift")) {
			try {
				String facility = request.getParameter("facility");
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				jsonArray = dashfunc.getShifts(facility, systemId);
				if (jsonArray.length() > 0) {
					jsonObject.put("Shift", jsonArray);
				} else {
					jsonObject.put("Shift", "");
				}
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {

			}
		}
		
		
		if (param.equalsIgnoreCase("getAssetMapDetails")) {
			try {
				String routeName = request.getParameter("routeName");
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				jsonArray = dashfunc.getMapVehicleDetails(routeName);
				if (jsonArray.length() > 0) {
					jsonObject.put("MapVehicles", jsonArray);
				} else {
					jsonObject.put("MapVehicles", "");
				}
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {

			}
		}
		
		if (param.equalsIgnoreCase("getRouteDetails")) {
			try {
				String routeName = request.getParameter("routeName");
				String vehicleNo = request.getParameter("vehNo");
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				jsonArray = dashfunc.getRouteDetails(routeName,vehicleNo,systemId,offset);
				if (jsonArray.length() > 0) {
					jsonObject.put("routeId", jsonArray);
				} else {
					jsonObject.put("routeId", "");
				}
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {

			}
		}
		if (param.equalsIgnoreCase("getLatlongs")) {
			try {
				String routeName = request.getParameter("routeName");
				String vehicleNo = request.getParameter("vehNo");
				String startDate=request.getParameter("startDate");
				String clientId=request.getParameter("clientId");
				String lon=request.getParameter("lon");
				String lat=request.getParameter("lat");
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				jsonArray = dashfunc.getLatlongs(routeName,vehicleNo,startDate,offset,Integer.parseInt(clientId),lon,lat);
				if (jsonArray.length() > 0) {
					jsonObject.put("latlongId", jsonArray);
				} else {
					jsonObject.put("latlongId", "");
				}
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {

			}
		}
		//*********************************************For McKinsey********************************************************************************
		else if(param.equalsIgnoreCase("getDashBoardCounts")){
			String routeId = request.getParameter("routeId");
			String custId = request.getParameter("custId");
			try {
				jsonObject = new JSONObject();
				jsonArray = dashfunc.getDashBoardCounts(clientIdd,systemId,userId);
				if (jsonArray.length() > 0) {
					jsonObject.put("vehicleCounts", jsonArray);
				} else {
					jsonObject.put("vehicleCounts", "");
				}
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {

			}
		}
		//*********************************************For McKinsey********************************************************************************
		}
		else{
			
			if (request.getParameter("param").equals("checkSession")){	
				
        	response.getWriter().print("InvalidSession");
        	}
		}
		
		return null;
	}
}
