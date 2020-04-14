package t4u.marineVessel;

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
import t4u.beans.ReportHelper;
import t4u.functions.CommonFunctions;
import t4u.functions.MarineVesselFunctions;

public class MarineVesselAction extends Action{
	
	SimpleDateFormat yyyyMMddHHMMSS = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	
	@Override
	public ActionForward execute(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) throws Exception {
		HttpSession session = request.getSession();
		
		LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
		int systemId = loginInfo.getSystemId();
		int offset = loginInfo.getOffsetMinutes();
		String language = loginInfo.getLanguage();
		int userId = loginInfo.getUserId();
				
		MarineVesselFunctions marineVesselFunction = new MarineVesselFunctions();
		CommonFunctions commFunctions = new CommonFunctions();
		
		JSONArray jsonArray = null;
		JSONObject jsonObject = new JSONObject();
		
		String param = "";
		if (request.getParameter("param") != null) {
			param = request.getParameter("param").toString();
		}

		/*******************************************************************************************************************************
		 * Getting Marine Vessel Information based on Customer Name
		 ********************************************************************************************************************************/
		if (param.equalsIgnoreCase("getMarineVessel")) {
			try {				
				String customerId = request.getParameter("CustId");
								
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				if(customerId!= null && !customerId.equals("")){
					
					jsonArray = marineVesselFunction.getMarineVesselDetails(systemId, Integer.parseInt(customerId), userId);
										
					if (jsonArray.length() > 0) {
						jsonObject.put("MarineVesselRoot", jsonArray);
					} else {
						jsonObject.put("MarineVesselRoot", "");
					}
					response.getWriter().print(jsonObject.toString());
				} else {
					jsonObject.put("MarineVesselRoot", "");
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		
		else if (param.equalsIgnoreCase("getMarineLiveInformation")) {
			try {				
				String customerId = request.getParameter("CustId");
				String assetNumber = request.getParameter("AssetNumber");

				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				if(customerId!= null && !customerId.equals("") && assetNumber!= null && !assetNumber.equals("")){
					
					jsonArray = marineVesselFunction.getMarineLiveInformation(systemId, Integer.parseInt(customerId), userId, assetNumber);
										
					if (jsonArray.length() > 0) {
						jsonObject.put("MarineLiveInformationRoot", jsonArray);
					} else {
						jsonObject.put("MarineLiveInformationRoot", "");
					}
					response.getWriter().print(jsonObject.toString());
				} else {
					jsonObject.put("MarineLiveInformationRoot", "");
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		
		else if (param.equalsIgnoreCase("getMarineLiveGrid")) {
			try {				
				String customerId = request.getParameter("CustId");
				String assetNumber = request.getParameter("AssetNumber");
				String proximityValue = request.getParameter("ProximityValue");
				String groupName = request.getParameter("GroupName");
				String latitude = request.getParameter("Latitude");
				String longitude = request.getParameter("Longitude");
				String driverName = request.getParameter("DriverName");
				String driverNumber = request.getParameter("DriverNumber");
				String ownerName = request.getParameter("OwnerName");
				String ownerNumber = request.getParameter("OwnerNumber");
				String lastCommunicated = request.getParameter("LastCommunicated");
				String communicationStatus = request.getParameter("CommunicationStatus");
				
				String jspName = request.getParameter("jspName");
	
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				if(customerId!= null && !customerId.equals("") && assetNumber!= null && !assetNumber.equals("") && proximityValue!= null && !proximityValue.equals("")){
					
					ArrayList<Object> marineLiveList = marineVesselFunction.getMarineLiveDetailsBasedOnProximity(systemId, Integer.parseInt(customerId), assetNumber, Integer.parseInt(proximityValue), userId, language);
					jsonArray = (JSONArray) marineLiveList.get(0);					
					if (jsonArray.length() > 0) {
						jsonObject.put("MarineLiveGridRoot", jsonArray);
					} else {
						jsonObject.put("MarineLiveGridRoot", "");
					}
					ReportHelper reportHelper = (ReportHelper)marineLiveList.get(1);
		    		request.getSession().setAttribute(jspName, reportHelper);
		    		request.getSession().setAttribute("assetNumber", assetNumber);
		    		request.getSession().setAttribute("proximityValue", proximityValue);
		    		request.getSession().setAttribute("groupName", groupName);
		    		request.getSession().setAttribute("latitude", latitude);
		    		request.getSession().setAttribute("longitude", longitude);
		    		request.getSession().setAttribute("driverName", driverName);
		    		request.getSession().setAttribute("driverNumber", driverNumber);
		    		request.getSession().setAttribute("ownerName", ownerName);
		    		request.getSession().setAttribute("ownerNumber", ownerNumber);
		    		request.getSession().setAttribute("lastCommunicated", lastCommunicated);
		    		request.getSession().setAttribute("communicationStatus", communicationStatus);
					
					response.getWriter().print(jsonObject.toString());
				} else {
					jsonObject.put("MarineLiveGridRoot", "");
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		
		else if (param.equalsIgnoreCase("getMarineHistoryGrid")) {
			try {				
				String customerId = request.getParameter("CustId");
				String assetNumber = request.getParameter("AssetNumber");
				String StartDate = request.getParameter("StartDate");
				String EndDate = request.getParameter("EndDate");
				String groupName = request.getParameter("GroupName");
				String latitude = request.getParameter("Latitude");
				String longitude = request.getParameter("Longitude");
				String driverName = request.getParameter("DriverName");
				String driverNumber = request.getParameter("DriverNumber");
				String ownerName = request.getParameter("OwnerName");
				String ownerNumber = request.getParameter("OwnerNumber");
				String jspName = request.getParameter("jspName");
	
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				if(customerId!= null && !customerId.equals("") && assetNumber!= null && !assetNumber.equals("") && StartDate!= null && !StartDate.equals("") && EndDate!= null && !EndDate.equals("")){
					
					ArrayList<Object> marineHistoryList = marineVesselFunction.getMarineHistoryDetails(systemId, Integer.parseInt(customerId), assetNumber, StartDate, EndDate, offset, language);
					jsonArray = (JSONArray) marineHistoryList.get(0);					
					if (jsonArray.length() > 0) {
						jsonObject.put("MarineHistoryGridRoot", jsonArray);
					} else {
						jsonObject.put("MarineHistoryGridRoot", "");
					}
					ReportHelper reportHelper = (ReportHelper)marineHistoryList.get(1);
		    		request.getSession().setAttribute(jspName, reportHelper);
		    		request.getSession().setAttribute("assetNumber", assetNumber);
		    		request.getSession().setAttribute("startdate", commFunctions.getFormattedDateddMMYYYY(StartDate.replaceAll("T", " ")));
		    		request.getSession().setAttribute("enddate", commFunctions.getFormattedDateddMMYYYY(EndDate.replaceAll("T", " ")));
		    		request.getSession().setAttribute("groupName", groupName);
		    		request.getSession().setAttribute("latitude", latitude);
		    		request.getSession().setAttribute("longitude", longitude);
		    		request.getSession().setAttribute("driverName", driverName);
		    		request.getSession().setAttribute("driverNumber", driverNumber);
		    		request.getSession().setAttribute("ownerName", ownerName);
		    		request.getSession().setAttribute("ownerNumber", ownerNumber);
		    		response.getWriter().print(jsonObject.toString());
				} else {
					jsonObject.put("MarineHistoryGridRoot", "");
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		
		else if (param.equalsIgnoreCase("getMarineLocationGrid")) {
			try {				
				String customerId = request.getParameter("CustId");
				String customerName = request.getParameter("CustName");
				String latitude = request.getParameter("Latitude");
				String longitude = request.getParameter("Longitude");
				String proximity = request.getParameter("Proximity");
				String date = request.getParameter("Date");
				String jspName = request.getParameter("jspName");

				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				if(customerId!= null && !customerId.equals("") && latitude!= null && !latitude.equals("") && longitude!= null && !longitude.equals("") && date!= null && !date.equals("") && proximity!= null && !proximity.equals("")){
					if (date.contains("T")) {
						date = date.substring(0, date.indexOf("T")) + " "+ date.substring(date.indexOf("T") + 1, date.length());
					} 
										
					ArrayList<Object> marineHistoryList = marineVesselFunction.getMarineLocationDetails(systemId, Integer.parseInt(customerId), userId,  Double.parseDouble(latitude), Double.parseDouble(longitude), date, Integer.parseInt(proximity), offset, language);
					jsonArray = (JSONArray) marineHistoryList.get(0);					
					if (jsonArray.length() > 0) {
						jsonObject.put("MarineLocationGridRoot", jsonArray);
					} else {
						jsonObject.put("MarineLocationGridRoot", "");
					}
					ReportHelper reportHelper = (ReportHelper)marineHistoryList.get(1);
		    		request.getSession().setAttribute(jspName, reportHelper);
		    		request.getSession().setAttribute("customerName", customerName);
		    		request.getSession().setAttribute("latitude", latitude);
		    		request.getSession().setAttribute("longitude", longitude);
		    		request.getSession().setAttribute("proximity", proximity);
		    		request.getSession().setAttribute("date", commFunctions.getFormattedDateddMMYYYY(date));
		    		response.getWriter().print(jsonObject.toString());
				} else {
					jsonObject.put("MarineHistoryGridRoot", "");
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		
		else if (param.equalsIgnoreCase("postFindByLocation")) {
			try {

				String customerId = request.getParameter("FindByCustomerId");
				String latitude = request.getParameter("FindByLatitude");
				String longitude = request.getParameter("FindByLongitude");
				String dateTime = request.getParameter("FindByDateTime");

				if (customerId != null && !customerId.equals("") && latitude != null && !latitude.equals("") && longitude != null && !longitude.equals("") && dateTime != null && !dateTime.equals("")) {
					marineVesselFunction.setFindByLocation(systemId, customerId, latitude, longitude, dateTime);				
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		
		else if (param.equalsIgnoreCase("getFindByLocation")) {
			jsonArray = new JSONArray();
			jsonObject = new JSONObject();
			try {

				jsonArray = marineVesselFunction.getFindByLocation(systemId);
				if (jsonArray.length() > 0) {
					jsonObject.put("FindByLocationRoot", jsonArray);
				} else {
					jsonObject.put("FindByLocationRoot", "");
				}
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		return null;
	}	
}
