package t4u.GeneralVertical;

import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Properties;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

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
import t4u.common.ApplicationListener;
import t4u.functions.DashBoardFunctions;
import t4u.functions.LogWriter;
import t4u.statements.DashBoardStatements;

import com.google.gson.Gson;
import com.google.gson.internal.LinkedTreeMap;

// Added for Mckinsey
public class DashboardAction extends Action {

	static HashMap<String, String> statusCodesMap = new HashMap<String, String>();

	static {
		statusCodesMap.put("ON_TIME", "1");
		statusCodesMap.put("DELAYED_LESS", "2");
		statusCodesMap.put("UNPLANNED_STOP_DELAYED_LESS", "3");
		statusCodesMap.put("ROUTEDEV_DELAYED_LESS", "4");
		statusCodesMap.put("DELAYED_GREATER", "5");
		statusCodesMap.put("UNPLANNED_STOP_DELAYED_GREATER", "6");
		statusCodesMap.put("ROUTEDEV_DELAYED_GREATER", "7");
		statusCodesMap.put("LOADING_UNLOADING", "8");
		statusCodesMap.put("LOADUNLOAD_ONTIME", "9");
		statusCodesMap.put("LOADUNLOAD_LESS", "10");
		statusCodesMap.put("LOADUNLOAD_GREATER", "11");
		statusCodesMap.put("SPEED_ALERT", "12");
	}

	@SuppressWarnings("unchecked")
	public ActionForward execute(ActionMapping map, ActionForm form, HttpServletRequest request, HttpServletResponse response) {
		try {
			HttpSession session = request.getSession();
			LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
			SimpleDateFormat sdfLog = new SimpleDateFormat("dd-MM-yyyy");
			int systemId = 0;
			int clientId = 0;
			int offset = 0;
			int userId = 0;
			@SuppressWarnings("unused")
			int isLtsp = 0;
			int nonCommHrs = 0;
			@SuppressWarnings("unused")
			String lang = "";
			String zone = "";
			DashBoardFunctions dashFunc = new DashBoardFunctions();
			JSONArray jsonArray = new JSONArray();
			JSONObject jsonObject = null;
			String param = "";
			LogWriter logWriter = null;
			Properties properties = ApplicationListener.prop;
			String logFile = properties.getProperty("LogFileJotun");
			String logFileName = logFile.substring(0, logFile.lastIndexOf("."));
			String logFileExt = logFile.substring(logFile.lastIndexOf(".") + 1, logFile.length());
			logFile = logFileName + "-" + sdfLog.format(new Date()) + "." + logFileExt;
			PrintWriter pw;
			if (logFile != null) {
				try {
					pw = new PrintWriter(new FileWriter(logFile, true), true);
					logWriter = new LogWriter("Inside DashboardAction " + "param : " + param + "-- " + session.getId() + "--" + userId, LogWriter.INFO, pw);
					logWriter.setPrintWriter(pw);
				} catch (IOException e) {
					//logWriter.log("Can't open the log file: " + logFile + ". Using System.err instead",LogWriter.ERROR);
				}
			}
			if (request.getParameter("param") != null) {
				param = request.getParameter("param");
			}
			if (loginInfo != null) {
				systemId = loginInfo.getSystemId();
				clientId = loginInfo.getCustomerId();
				offset = loginInfo.getOffsetMinutes();
				userId = loginInfo.getUserId();
				isLtsp = loginInfo.getIsLtsp();
				nonCommHrs = loginInfo.getNonCommHrs();
				lang = loginInfo.getLanguage();
				zone = loginInfo.getZone();
			}
			if (param.equalsIgnoreCase("getDashBoardCounts")) {
				try {
					jsonObject = new JSONObject();
					jsonArray = dashFunc.getDashBoardCounts(clientId, systemId, userId);
					if (jsonArray.length() > 0) {
						jsonObject.put("vehicleCounts", jsonArray);
					} else {
						jsonObject.put("vehicleCounts", "");
					}
					response.getWriter().print(jsonObject.toString());
				} catch (Exception e) {

				}
			} else if (param.equalsIgnoreCase("getAllVehiclesForMap")) {
				try {
					ArrayList<String> statusId = new ArrayList(statusCodesMap.keySet());
					jsonArray = new JSONArray();
					jsonObject = new JSONObject();
					jsonArray = dashFunc.getAlertDetailsForDashboard(clientId, systemId, statusId);
					if (jsonArray.length() > 0) {
						jsonObject.put("inTransitRoot", jsonArray);
					} else {
						jsonObject.put("inTransitRoot", "");
					}
					response.getWriter().print(jsonObject.toString());
				} catch (Exception e) {

				}
			} else if (param.equalsIgnoreCase("getVehiclesForMapByStatus")) {
				try {
					String statusName = request.getParameter("");
					ArrayList<String> statusId = new ArrayList<String>();
					statusId.add(statusCodesMap.get(statusName));
					jsonArray = new JSONArray();
					jsonObject = new JSONObject();
					jsonArray = dashFunc.getAlertDetailsForDashboard(clientId, systemId, statusId);
					if (jsonArray.length() > 0) {
						jsonObject.put("inTransitRoot", jsonArray);
					} else {
						jsonObject.put("inTransitRoot", "");
					}
					response.getWriter().print(jsonObject.toString());
				} catch (Exception e) {

				}
			}
			if (param.equals("getInTransitDetails")) {
				try {
					ArrayList<String> statusId = new ArrayList<String>();
					statusId.add("7");
					statusId.add("8");
					statusId.add("9");
					statusId.add("10");
					jsonArray = new JSONArray();
					jsonObject = new JSONObject();
					jsonArray = dashFunc.getAlertDetailsIntransitTrips(clientId, systemId, statusId);
					if (jsonArray.length() > 0) {
						jsonObject.put("inTransitRoot", jsonArray);
					} else {
						jsonObject.put("inTransitRoot", "");
					}
					response.getWriter().print(jsonObject.toString());
				} catch (Exception e) {
					e.printStackTrace();
				}

			}
			if (param.equals("getTruckDetentionDetails")) {
				try {
					ArrayList<String> statusId = new ArrayList<String>();
					statusId.add("12");
					statusId.add("13");
					jsonArray = new JSONArray();
					jsonObject = new JSONObject();
					jsonArray = dashFunc.getAlertDetailsForDashboard(clientId, systemId, statusId);
					if (jsonArray.length() > 0) {
						jsonObject.put("truckDetentionRoot", jsonArray);
					} else {
						jsonObject.put("truckDetentionRoot", "");
					}
					response.getWriter().print(jsonObject.toString());
				} catch (Exception e) {
					e.printStackTrace();
				}

			}
			if (param.equals("getVehicleSafety")) {
				try {
					ArrayList<String> statusId = new ArrayList<String>();
					statusId.add("2682");
					statusId.add("2683");
					jsonArray = new JSONArray();
					jsonObject = new JSONObject();
					if (jsonArray.length() > 0) {
						jsonObject.put("vehicleSafetyRoot", jsonArray);
					} else {
						jsonObject.put("vehicleSafetyRoot", "");
					}
					response.getWriter().print(jsonObject.toString());
				} catch (Exception e) {
					e.printStackTrace();
				}

			}
			if (param.equals("saveDashboardRemarks")) {
				try {
					String dashboardRemarks = request.getParameter("remarks");
					String tripId = request.getParameter("tripId");
					String alertType = "";// request.getParameter("alertType");
					String message = dashFunc.saveRemarksForDashboard(clientId, systemId, userId, dashboardRemarks, tripId, alertType);
					response.getWriter().print(message.toString());
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
			if (param.equals("getMapData")) {
				String mapStatus = request.getParameter("statusId");
				try {
					ArrayList<String> statusId = new ArrayList<String>();
					if (mapStatus.equals("all")) {
						statusId.add("2");
						statusId.add("30");
					} else if (mapStatus.equals("2,3,4")) {
						statusId.add("2");
						statusId.add("3");
						statusId.add("4");
					} else if (mapStatus.equals("2")) {
						statusId.add("2"); // in transit on time 
					} else if (mapStatus.equals("3")) {
						statusId.add("3"); // delayed < 1 hr
					} else if (mapStatus.equals("4")) {
						statusId.add("4"); // delayed > 1 hr
					} else if (mapStatus.equals("7")) {
						statusId.add("7"); // delayed < 1 hr unplanned stoppage
					} else if (mapStatus.equals("8")) {
						statusId.add("8"); // delayed < 1 hr route deviation
					} else if (mapStatus.equals("9")) {
						statusId.add("9"); //  delayed > 1 hr unplanned stoppage
					} else if (mapStatus.equals("10")) {
						statusId.add("10"); // delayed > 1 hr route deviation
					} else if (mapStatus.equals("11,12,13")) {
						statusId.add("11");
						statusId.add("12");
						statusId.add("13");
					} else if (mapStatus.equals("11")) {
						statusId.add("11"); // on time loading unloading 
					} else if (mapStatus.equals("12")) {
						statusId.add("12"); // delayed < 1 load/unload
					} else if (mapStatus.equals("13")) {
						statusId.add("13"); // delayed > 1 load/unload 
					} else if (mapStatus.equals("30")) {
						statusId.add("30"); // delayed late departure
					} else if (mapStatus.equals("0,1")) {
						statusId.add("0");
						statusId.add("1");
					} else if (mapStatus.equals("")) {

					}
					jsonArray = new JSONArray();
					jsonObject = new JSONObject();
					if (mapStatus.equals("4") || mapStatus.equals("3")) {
						jsonArray = dashFunc.getMapDataDelay(clientId, systemId, mapStatus);
					} else if (mapStatus.equals("all")) {
						JSONArray jsonArrayDelayLess = dashFunc.getMapDataDelay(clientId, systemId, "3");
						JSONArray jsonArrayDelayGreater = dashFunc.getMapDataDelay(clientId, systemId, "4");
						jsonArray = dashFunc.getMapData(clientId, systemId, statusId);
						jsonArray.put(jsonArrayDelayLess);
						for (int i = 0; i < jsonArrayDelayGreater.length(); i++) {
							jsonArray.put(jsonArrayDelayGreater.get(i));
						}

					} else if (mapStatus.equals("33")) {
						jsonArray = dashFunc.getUnUtilizedVehicles(clientId, systemId, mapStatus);
					} else if (mapStatus.equals("44")) {
						jsonArray = dashFunc.getUnUtilizedVehicles(clientId, systemId, mapStatus);
					} else if (mapStatus.equals("LOW_FUEL")) {
						jsonArray = dashFunc.getVehicleSafteyAlertDetails(clientId, systemId, DashBoardStatements.LOW_FUEL_ALERT_ID);
					} else if (mapStatus.equals("LOW_BAT")) {
						jsonArray = dashFunc.getVehicleSafteyAlertDetails(clientId, systemId, DashBoardStatements.LOW_BATTERY_ALERT_ID);
					} else if (mapStatus.equals("OVER_SPEED")) {
						jsonArray = dashFunc.getOverSpeedAlertDetails(clientId, systemId, DashBoardStatements.OVER_SPEED_ALERT_ID);
					} else if (mapStatus.equals("COOLANT_TEMP")) {
						jsonArray = dashFunc.getVehicleSafteyAlertDetails(clientId, systemId, DashBoardStatements.COOLANT_TEMP_ALERT_ID);
					} else {
						jsonArray = dashFunc.getMapData(clientId, systemId, statusId);
					}
					if (jsonArray.length() > 0) {
						jsonObject.put("mapDataRoot", jsonArray);
					} else {
						jsonObject.put("mapDataRoot", "");
					}
					response.getWriter().print(jsonObject.toString());
				} catch (Exception e) {
					e.printStackTrace();
				}
			} else if (param.equals("getVehicleNoAndShipmentIdOnTrip")) {
				try {
					jsonArray = new JSONArray();
					jsonObject = new JSONObject();
					jsonArray = dashFunc.getVehicleNoDetailsForOpenTrips(clientId, systemId, offset);
					if (jsonArray.length() > 0) {
						jsonObject.put("vehicleListRoot", jsonArray);
					} else {
						jsonObject.put("vehicleListRoot", "");
					}
					response.getWriter().print(jsonObject.toString());
				} catch (Exception e) {
					e.printStackTrace();
				}
			} else if (param.equals("getShipmentDetails")) {
				try {
					jsonArray = new JSONArray();
					jsonObject = new JSONObject();
					String tripId = "";
					if (request.getParameter("tripId") != null && !request.getParameter("tripId").equals("")) {
						tripId = request.getParameter("tripId");
					}
					if (!tripId.equals("")) {
						jsonArray = dashFunc.getShipmentDetails(clientId, systemId, tripId, offset);
						if (jsonArray.length() > 0) {
							jsonObject.put("shipmentRoot", jsonArray);
						} else {
							jsonObject.put("shipmentRoot", "");
						}
					} else {
						jsonObject.put("shipmentRoot", "");
					}
					response.getWriter().print(jsonObject.toString());
				} catch (Exception e) {
					e.printStackTrace();
				}
			} else if (param.equalsIgnoreCase("getAlertGrid")) {
				try {
					String tripId = request.getParameter("tripId");
					jsonArray = new JSONArray();
					jsonObject = new JSONObject();
					jsonArray = dashFunc.getAlertsOnTrip(clientId, Integer.parseInt(tripId), systemId, offset);
					if (jsonArray.length() > 0) {
						jsonObject.put("alertGridRoot", jsonArray);
					} else {
						jsonObject.put("alertGridRoot", "");
					}
					response.getWriter().print(jsonObject.toString());
				} catch (Exception e) {

				}
			} else if (param.equals("getVehicleHealthCounts")) {
				String tripStartTime = "";
				String tripId = "";
				if (request.getParameter("tripStartTime") != null && !request.getParameter("tripStartTime").equals("")) {
					tripStartTime = request.getParameter("tripStartTime");
				}
				if (request.getParameter("tripId") != null && !request.getParameter("tripId").equals("")) {
					tripId = request.getParameter("tripId");
				}

				try {
					jsonObject = new JSONObject();
					if (request.getParameter("tripStartTime") != "" && !request.getParameter("tripId").equals("")) {
						jsonArray = dashFunc.getVehicleHealthCounts(systemId, clientId, tripStartTime, offset, Integer.parseInt(tripId));
						if (jsonArray.length() > 0) {
							jsonObject.put("getVehicleHealthCountsRoot", jsonArray);
						} else {
							jsonObject.put("getVehicleHealthCountsRoot", "");
						}
					} else {
						jsonObject.put("getVehicleHealthCountsRoot", "");
					}
					response.getWriter().print(jsonObject.toString());
				} catch (Exception e) {
					e.printStackTrace();
				}
			} else if (param.equals("getVehicleHealthGridDetails")) {
				String tripStartTime = request.getParameter("tripStartTime");
				String tripId = request.getParameter("tripId");
				String alertKey = request.getParameter("alertKey");

				try {
					jsonObject = new JSONObject();
					jsonArray = dashFunc.getVehicleHealthGridDetails(clientId, Integer.parseInt(tripId), systemId, offset, tripStartTime, Integer.parseInt(alertKey));
					if (jsonArray.length() > 0) {
						jsonObject.put("vehicleHealthGridDetailsRoot", jsonArray);
					} else {
						jsonObject.put("vehicleHealthGridDetailsRoot", "");
					}
					response.getWriter().print(jsonObject.toString());
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
			if (param.equals("getVehicleSafteyAlertActionDetails")) {
				try {
					jsonArray = new JSONArray();
					jsonObject = new JSONObject();
					jsonArray = dashFunc.getVehicleSafteyAlertActionDetails(clientId, systemId);
					if (jsonArray.length() > 0) {
						jsonObject.put("vehicleSafteyRoot", jsonArray);
					} else {
						jsonObject.put("vehicleSafteyRoot", "");
					}
					response.getWriter().print(jsonObject.toString());
				} catch (Exception e) {
					e.printStackTrace();
				}
			} else if (param.equalsIgnoreCase("getSATDashBoardCounts")) {
				try {
					jsonObject = new JSONObject();
					jsonArray = dashFunc.getSATDashBoardCounts(clientId, systemId, userId, nonCommHrs);
					if (jsonArray.length() > 0) {
						jsonObject.put("vehicleCounts", jsonArray);
					} else {
						jsonObject.put("vehicleCounts", "");
					}
					response.getWriter().print(jsonObject.toString());
				} catch (Exception e) {

				}
			}

			else if (param.equals("getVehiclesMapDetails")) {
				String mapStatus = request.getParameter("statusId");
				if (mapStatus.equals("ALL")) {
					mapStatus = "onTrip";
				}
				try {
					jsonArray = new JSONArray();
					jsonObject = new JSONObject();
					jsonArray = dashFunc.getSATDashboardMapDetails(clientId, systemId, userId, mapStatus);

					if (jsonArray.length() > 0) {
						jsonObject.put("MapViewIndex", jsonArray);
					} else {
						jsonObject.put("MapViewIndex", "");
					}
					response.getWriter().print(jsonObject.toString());
				} catch (Exception e) {
					e.printStackTrace();
				}
			} else if (param.equals("getVehicleNoList")) {
				try {
					jsonArray = new JSONArray();
					jsonObject = new JSONObject();
					jsonArray = dashFunc.getVehicleNoList(clientId, systemId, offset, userId);
					if (jsonArray.length() > 0) {
						jsonObject.put("vehicleListRoot", jsonArray);
					} else {
						jsonObject.put("vehicleListRoot", "");
					}
					response.getWriter().print(jsonObject.toString());
				} catch (Exception e) {
					e.printStackTrace();
				}
			} else if (param.equals("getTempAlertDetails")) {
				try {
					jsonArray = new JSONArray();
					jsonObject = new JSONObject();
					ArrayList<Object> list1 = dashFunc.getTempAlertDetails(systemId, clientId);
					jsonArray = (JSONArray) list1.get(0);
					if (jsonArray.length() > 0) {
						jsonObject.put("tempAlertRoot", jsonArray);
					} else {
						jsonObject.put("tempAlertRoot", "");
					}
					response.getWriter().print(jsonObject.toString());
				} catch (Exception e) {
					e.printStackTrace();
				}
			} else if (param.equals("getDriversByStatus")) {
				try {
					jsonArray = new JSONArray();
					jsonObject = new JSONObject();
					String status = request.getParameter("status");
					jsonArray = dashFunc.getDriversByStatus(systemId, clientId, status,userId);
					if (jsonArray.length() > 0) {
						jsonObject.put("vehiclesRoot", jsonArray);
					} else {
						jsonObject.put("vehiclesRoot", "");
					}
					response.getWriter().print(jsonObject.toString());
				} catch (Exception e) {
					e.printStackTrace();
				}
			} else if (param.equals("getLoadingPartners")) {
				try {
					jsonArray = new JSONArray();
					jsonObject = new JSONObject();
					jsonArray = dashFunc.getLoadingPartners(systemId, clientId);
					if (jsonArray.length() > 0) {
						jsonObject.put("loadingPartnerRoot", jsonArray);
					} else {
						jsonObject.put("loadingPartnerRoot", "");
					}
					response.getWriter().print(jsonObject.toString());
				} catch (Exception e) {
					e.printStackTrace();
				}
			} else if (param.equals("getHubsByTripCustomer")) {
				try {
					jsonArray = new JSONArray();
					jsonObject = new JSONObject();
					String tripCustomerId = request.getParameter("tripCustomerId");
					jsonArray = dashFunc.getHubsByTripCustomer(systemId, clientId, tripCustomerId, zone);
					if (jsonArray.length() > 0) {
						jsonObject.put("hubsRoot", jsonArray);
					} else {
						jsonObject.put("hubsRoot", "");
					}
					response.getWriter().print(jsonObject.toString());
				} catch (Exception e) {
					e.printStackTrace();
				}
			} else if (param.equalsIgnoreCase("getJotunDashBoardCounts")) {
				try {

					String regionsId=request.getParameter("regionsId");
					if(regionsId==null)
						regionsId="0";
					jsonObject = new JSONObject();
					jsonArray = dashFunc.getDashBoardCountsForJotun(clientId, systemId, userId, nonCommHrs, zone,regionsId);
					if (jsonArray.length() > 0) {
						jsonObject.put("vehicleCounts", jsonArray);
					} else {
						jsonObject.put("vehicleCounts", "");
					}
					response.getWriter().print(jsonObject.toString());
				} catch (Exception e) {

				}
			} else if (param.equals("getJotunVehiclesMapDetails")) {
				String mapStatus = request.getParameter("statusId");
				String regionsId=request.getParameter("regionsId");
				if(regionsId==null)
					regionsId="0";
				try {
					jsonArray = new JSONArray();
					jsonObject = new JSONObject();
					if (mapStatus.equals("ALL")) {
						jsonArray = dashFunc.getDashboardMapAllForJotun(clientId, systemId, userId, mapStatus,regionsId);
					} else {
						jsonArray = dashFunc.getDashboardMapForJotun(clientId, systemId, userId, mapStatus,zone,regionsId);
					}
					if (jsonArray.length() > 0) {
						jsonObject.put("MapViewIndex", jsonArray);
					} else {
						jsonObject.put("MapViewIndex", "");
					}
					response.getWriter().print(jsonObject.toString());
				} catch (Exception e) {
					e.printStackTrace();
				}
			} else if (param.equals("getJotunDriverDetention")) {
				try {
					String regionsId=request.getParameter("regionsId");
					if(regionsId==null)
						regionsId="0";
					//System.out.println("RegionsId:"+request.getParameter("regionsId"));
					jsonArray = new JSONArray();
					jsonObject = new JSONObject();
					jsonArray = dashFunc.getDriverDetentionDetailsForJotun(clientId, systemId, userId, regionsId);
					if (jsonArray.length() > 0) {
						jsonObject.put("driverDetentionIndex", jsonArray);
					} else {
						jsonObject.put("driverDetentionIndex", "");
					}
					response.getWriter().print(jsonObject.toString());
				} catch (Exception e) {
					e.printStackTrace();
				}
			} else if (param.equalsIgnoreCase("saveTrip")) {
				String assetNumber = request.getParameter("assetNumber");
				String productLine = "Dry";
				String desTripDetails = request.getParameter("desTripDetails");
				String trackTripSub = request.getParameter("trackTripDetailsSub");
				String tripType = request.getParameter("tripType");
				List desTripDetailsList = null;
				String missedTripData = request.getParameter("mtmJSONData");
				Integer tripDestination = 0;
				
				if (request.getParameter("tripDestination") != null){
					tripDestination = Integer.parseInt(request.getParameter("tripDestination")); 
					logWriter.log("Inside saveTrip :: tripDestination " + tripDestination, LogWriter.INFO);
				}else{
					response.getWriter().print("Trip Destination cannot be null");
				}
				
				JSONObject missedTripJSON = null;
				logWriter.log("Inside saveTrip ::assetNumber" + assetNumber, LogWriter.INFO);
				Gson gson = new Gson();
				if (desTripDetails != null) {
					desTripDetailsList = gson.fromJson(desTripDetails, List.class);

				}
				if (missedTripData !=null){
					missedTripJSON = new JSONObject(missedTripData);
				}
				LinkedTreeMap trackTripSubMap = null;
				if (trackTripSub != null) {
					trackTripSubMap = gson.fromJson(trackTripSub, LinkedTreeMap.class);
				}
				boolean isScanVaild = true;
				for (int i = 0; i < desTripDetailsList.size(); i++) {
					LinkedTreeMap desTripDetailMap = (LinkedTreeMap) desTripDetailsList.get(i);
					LinkedTreeMap tripOrderDetails = (LinkedTreeMap) desTripDetailMap.get("tripOrderDetails");
					if (tripOrderDetails != null) {
						Pattern pattern = Pattern.compile("[a-zA-Z0-9-]*");
						String scanId = (String) tripOrderDetails.get("scanId");
						Matcher matcher = pattern.matcher(scanId);
						if (!matcher.matches()) {
							logWriter.log("Inside saveTrip :'" + scanId + "' contains special character", LogWriter.INFO);
							isScanVaild = false;
						}
					}
				}
				if (isScanVaild) {
					String message = dashFunc.saveTripJotun(assetNumber, productLine, desTripDetailsList, trackTripSubMap, systemId, 
															clientId, userId, tripType,logWriter,missedTripJSON,offset,tripDestination);
					logWriter.log("End of saveTrip ::assetNumber" + assetNumber + "::message: " + message, LogWriter.INFO);
					response.getWriter().print(message);

				} else {
					response.getWriter().print("Invalid scan Id");
				}
			} else if (param.equalsIgnoreCase("modifyTrip")) {
				String tripId = request.getParameter("tripId");
				logWriter.log("Inside saveTrip ::tripId" + tripId, LogWriter.INFO);
				String desTripDetails = request.getParameter("desTripDetails");
				String trackTripSub = request.getParameter("trackTripDetailsSub");
				List desTripDetailsList = null;
				
				Integer tripDestination = 0;
				
				if (request.getParameter("tripDestination") != null){
					tripDestination = Integer.parseInt(request.getParameter("tripDestination")); 
					logWriter.log("Inside modify :: tripDestination " + tripDestination, LogWriter.INFO);
				}else{
					response.getWriter().print("Trip Destination cannot be null");
				}
				Gson gson = new Gson();
				if (desTripDetails != null) {
					desTripDetailsList = gson.fromJson(desTripDetails, List.class);
				}
				LinkedTreeMap trackTripSubMap = null;
				if (trackTripSub != null) {
					trackTripSubMap = gson.fromJson(trackTripSub, LinkedTreeMap.class);
				}
				String message = dashFunc.modifyTripJotun(Integer.parseInt(tripId), desTripDetailsList, trackTripSubMap, systemId, clientId, userId, logWriter,tripDestination);
				logWriter.log("End of modifyTrip ::tripId" + tripId + "::message: " + message, LogWriter.INFO);
				response.getWriter().print(message);

			} else if (param.equalsIgnoreCase("closeTrip")) {
				String remarks = request.getParameter("remarks");
				String tripId = request.getParameter("tripId");
				logWriter.log("Inside closeTrip ::tripId" + tripId, LogWriter.INFO);
				String desTripDetails = request.getParameter("desTripDetails");
				List desTripDetailsList = null;
				Gson gson = new Gson();
				if (desTripDetails != null) {
					desTripDetailsList = gson.fromJson(desTripDetails, List.class);
				}
				String message = dashFunc.closeTripJotun(remarks, Integer.parseInt(tripId), desTripDetailsList, systemId, clientId, userId, logWriter);
				logWriter.log("End of closeTrip ::tripId" + tripId + "::message::" + message, LogWriter.INFO);
				response.getWriter().print(message);

			} else if (param.equals("getTripDetailById")) {
				try {
					jsonArray = new JSONArray();
					jsonObject = new JSONObject();
					String tripId = request.getParameter("tripId");
					JSONObject jsonObjectRes = dashFunc.getTripDetailsByTripId(Integer.parseInt(tripId), offset, zone);
					jsonObject.put("responseBody", jsonObjectRes);

					response.getWriter().print(jsonObject.toString());
				} catch (Exception e) {
					e.printStackTrace();
				}
			} else if (param.equalsIgnoreCase("getHubsByOperationId")) {
				try {
					String operationId = request.getParameter("hubType");
					jsonObject = new JSONObject();
					jsonArray = dashFunc.getHubsByOperationId(systemId, clientId, Integer.parseInt(operationId), zone);
					if (jsonArray.length() > 0) {
						jsonObject.put("hubDetailsRoot", jsonArray);
					} else {
						jsonObject.put("hubDetailsRoot", "");
					}
					response.getWriter().print(jsonObject.toString());
				} catch (Exception e) {

				}
			} else if (param.equals("getAllDrivers")) {
				try {
					jsonArray = new JSONArray();
					jsonObject = new JSONObject();
					jsonArray = dashFunc.getAllDrivers(systemId, clientId);
					if (jsonArray.length() > 0) {
						jsonObject.put("driversRoot", jsonArray);
					} else {
						jsonObject.put("driversRoot", "");
					}
					response.getWriter().print(jsonObject.toString());
				} catch (Exception e) {
					e.printStackTrace();
				}
			} else if (param.equals("getOrderDetailsForAcknowledge")) {
				try {
					jsonArray = new JSONArray();
					jsonObject = new JSONObject();
					String assetNo = request.getParameter("assetNumber");
					jsonArray = dashFunc.getOrderDetailsForAcknowledge(systemId, clientId, assetNo, offset);
					if (jsonArray.length() > 0) {
						jsonObject.put("orderDetailsRoot", jsonArray);
					} else {
						jsonObject.put("orderDetailsRoot", "");
					}
					response.getWriter().print(jsonObject.toString());
				} catch (Exception e) {
					e.printStackTrace();
				} //getOrderDetailsForDriver
			} else if (param.equals("saveAcknowlegdedOrders")) {
				try {
					String scanId = request.getParameter("newScanId");
					String gridData = request.getParameter("gridData");
					String remarksForAck = request.getParameter("remarksForAck");

					Gson gson = new Gson();
					List gridDataList = gson.fromJson(gridData, List.class);
					String message = dashFunc.saveAcknowlegdedOrders(systemId, clientId, scanId, gridDataList, remarksForAck);
					response.getWriter().print(message);

				} catch (Exception e) {
					e.printStackTrace();
				}
			}else if (param.equals("getDashboardCountsForNTC")) {
				try {
					jsonObject = new JSONObject();
					jsonArray = dashFunc.getDashboardCountsForNTC(clientId, systemId, userId,nonCommHrs);
					if (jsonArray.length() > 0) {
						jsonObject.put("vehicleCounts", jsonArray);
					} else {
						jsonObject.put("vehicleCounts", "");
					}
					response.getWriter().print(jsonObject.toString());
				} catch (Exception e) {
					e.printStackTrace();
				}
			}else if (param.equals("getMapViewDataForNTCByStatus")) {
				try {
					jsonObject = new JSONObject();
					String status = request.getParameter("status");
					jsonArray = dashFunc.getMapViewDataForNTCByStatus(clientId, systemId, userId,nonCommHrs, status);
					if (jsonArray.length() > 0) {
						jsonObject.put("vehicleDetailsRoot", jsonArray);
					} else {
						jsonObject.put("vehicleDetailsRoot", "");
					}
					response.getWriter().print(jsonObject.toString());
				} catch (Exception e) {
					e.printStackTrace();
				}
			}else if (param.equals("getPieChartData")) {
				try {
					jsonObject = new JSONObject();
					String piechartName = request.getParameter("chartName");
					jsonArray = dashFunc.getPieChartsDataForNTC(clientId, systemId, userId,nonCommHrs, piechartName,isLtsp);
					if (jsonArray.length() > 0) {
						jsonObject.put("chartData", jsonArray);
					} else {
						jsonObject.put("chartData", "");
					}
					response.getWriter().print(jsonObject.toString());
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
			else if (param.equals("getTripDetailsByStatus")) {
				try {
					jsonObject = new JSONObject();
					jsonArray = dashFunc.getDashBoardCounts(clientId, systemId, userId);
					if (jsonArray.length() > 0) {
						jsonObject.put("vehicleDetailsRoot", jsonArray);
					} else {
						jsonObject.put("vehicleDetailsRoot", "");
					}
					response.getWriter().print(jsonObject.toString());
				} catch (Exception e) {
					e.printStackTrace();
				}
			}else if (param.equals("getPieChartsByName")) {
				try {
					jsonObject = new JSONObject();
					jsonArray = dashFunc.getDashBoardCounts(clientId, systemId, userId);
					if (jsonArray.length() > 0) {
						jsonObject.put("vehicleDetailsRoot", jsonArray);
					} else {
						jsonObject.put("vehicleDetailsRoot", "");
					}
					response.getWriter().print(jsonObject.toString());
				} catch (Exception e) {
					e.printStackTrace();
				}
			}else if (param.equals("getOpenTrips")) {
				try {
					
					jsonObject = new JSONObject();
					jsonArray = dashFunc.getOpenTrips(clientId, systemId);
					if (jsonArray.length() > 0) {
						jsonObject.put("openTripsDetailRoot", jsonArray);
					} else {
						jsonObject.put("openTripsDetailRoot", "");
					}
					response.getWriter().print(jsonObject.toString());
				} catch (Exception e) {
					e.printStackTrace();
				}
			}else if (param.equals("saveHighPrioritySetting")) {
				try {
					jsonObject = new JSONObject();
					String priorityList = request.getParameter("priorityList");
					Gson gson = new Gson();
					List priority = gson.fromJson(priorityList, List.class);
					List<String> priorityListString = new ArrayList<String>();
					for(int i=0 ; i<priority.size() ;i++){
						priorityListString.add(Long.toString(Math.round((Double)priority.get(i))));
					}
					jsonArray = dashFunc.saveHighPrioritySetting(priorityListString);
					if (jsonArray.length() > 0) {
						jsonObject.put("openTripsDetailRoot", jsonArray);
					} else {
						jsonObject.put("openTripsDetailRoot", "");
					}
					response.getWriter().print(jsonObject.toString());
				} catch (Exception e) {
					e.printStackTrace();
				}
			}else if (param.equals("getCurrentLocationsForVehicles")) {
				try {
					jsonObject = new JSONObject();
					String vehicleNos = request.getParameter("vehicleNos");
					
					jsonArray = dashFunc.getCurrentLocationsForVehicles(vehicleNos);
					if (jsonArray.length() > 0) {
						jsonObject.put("vehicleDetailsRoot", jsonArray);
					} else {
						jsonObject.put("vehicleDetailsRoot", "");
					}
					response.getWriter().print(jsonObject.toString());
				} catch (Exception e) {
					e.printStackTrace();
				}
			}else if (param.equalsIgnoreCase("manualTripStart")) {
				String actualTripStartTime = request.getParameter("actualTripStartTime");
				String tripId = request.getParameter("tripId");
				logWriter.log("Inside manualTripStart ::tripId :: " + tripId, LogWriter.INFO);
				 
				String message = dashFunc.manualTripStart(actualTripStartTime, Integer.parseInt(tripId), userId, logWriter, offset,systemId,clientId);
				logWriter.log("End of manualTripStart ::tripId" + tripId + "::message::" + message, LogWriter.INFO);
				response.getWriter().print(message);

			}else if (param.equalsIgnoreCase("getHubDepartures")) {
				String approxTripDate = request.getParameter("approxTripDate");
				String assetNumber = request.getParameter("assetNumber");
				Integer hubId = Integer.parseInt(request.getParameter("hubId"));
				

				try {
					jsonObject = new JSONObject();
					jsonArray = dashFunc.getHubDepartures(approxTripDate,assetNumber,hubId,offset,systemId,clientId,logWriter);
					if (jsonArray.length() > 0) {
						jsonObject.put("vehicleDetailsRoot", jsonArray);
					} else {
						jsonObject.put("vehicleDetailsRoot", "");
					}
					logWriter.log("Missed Trips :: " + jsonArray.toString(), LogWriter.INFO);
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