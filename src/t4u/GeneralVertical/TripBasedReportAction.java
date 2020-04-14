package t4u.GeneralVertical;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.StringTokenizer;
import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.struts.action.Action;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.json.JSONArray;
import org.json.JSONObject;


import com.t4u.activity.VehicleActivity;
import com.t4u.activity.VehicleSummaryBean;


import t4u.beans.LoginInfoBean;
import t4u.common.DBConnection;
import t4u.functions.CommonFunctions;
import t4u.functions.GeneralVerticalFunctions;
import t4u.functions.TripBasedReportFunctions;
import t4u.statements.TripBasedReportStatements;

public class TripBasedReportAction extends Action {
	@SuppressWarnings("unchecked")
	public ActionForward execute(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) {
		HttpSession session = request.getSession();
		String param = "";
		String zone = "";
		int systemId = 0;
		int userId = 0;
		int offset = 0;
		int clientId = 0;
		Connection con = null;
		String distUnits = "";
		TripBasedReportFunctions tbrFunc = new TripBasedReportFunctions();
		
		DecimalFormat df = new DecimalFormat("#.##");
		LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
		TripBasedReportFunctions trf = new TripBasedReportFunctions();
		CommonFunctions cf = new CommonFunctions();
		String serverName=request.getServerName();
		String sessionId = request.getSession().getId();
		distUnits = cf.getUnitOfMeasure(systemId);
		systemId = loginInfo.getSystemId();
		clientId = loginInfo.getCustomerId();
		zone = loginInfo.getZone();
		userId = loginInfo.getUserId();
		offset = loginInfo.getOffsetMinutes();
		JSONArray jsonArray = null;
		SimpleDateFormat yyyyMMdd = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		SimpleDateFormat ddmmyyyy = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
		SimpleDateFormat sdfFormatDate = new SimpleDateFormat("MM/dd/yyyy HH:mm:ss");
		GeneralVerticalFunctions gf = new GeneralVerticalFunctions();
		JSONObject jsonObject = new JSONObject();
		
		if (request.getParameter("param") != null) {
			param = request.getParameter("param").toString();
		}

		if (param.equals("getTripBasedReport")) {
			try {
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				String startDate = yyyyMMdd.format(ddmmyyyy.parse(request.getParameter("startDate")));
				String endDate = yyyyMMdd.format(ddmmyyyy.parse(request.getParameter("endDate")));
				String tripStatus = request.getParameter("tripStatus");
				String vehicleNo = request.getParameter("vehicleNo");
				String routeId = request.getParameter("routeId");
				ArrayList<Object> list1 = trf.getTripBasedReportDetails(startDate, endDate, tripStatus, offset, distUnits, vehicleNo, routeId, systemId, clientId);
				jsonArray = (JSONArray) list1.get(0);
				if (jsonArray.length() > 0) {
					jsonObject.put("tripBasedRoot", jsonArray);
				} else {
					jsonObject.put("tripBasedRoot", "");
				}
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		} else if (param.equals("getVehicleNo")) {
			try {
				jsonObject = new JSONObject();
				jsonArray = trf.getRegistrationNoBasedOnUser(clientId, systemId, userId);
				jsonObject.put("VehicleNoRoot", jsonArray);

				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {
				System.out.println("Error in TripBasedAction:-getVehicleNo " + e.toString());
			}
		} else if (param.equals("getRoutes")) {
			try {
				jsonObject = new JSONObject();
				jsonArray = trf.getRouteDetails(clientId, systemId);
				jsonObject.put("routesRoot", jsonArray);

				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {
				System.out.println("Error in TripBasedAction:-getVehicleNo " + e.toString());
			}
		} else if (param.equals("getDoorAlertReport")) {
			try {
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				String startDate = yyyyMMdd.format(ddmmyyyy.parse(request.getParameter("startdate")));
				String endDate = yyyyMMdd.format(ddmmyyyy.parse(request.getParameter("enddate")));
				String vehicleNo = request.getParameter("vehicleNo");
				ArrayList<Object> list1 = trf.getDoorAlertReportDetails(startDate, endDate, offset, distUnits, vehicleNo, systemId, clientId);
				jsonArray = (JSONArray) list1.get(0);
				if (jsonArray.length() > 0) {
					jsonObject.put("doorReportRoot", jsonArray);
				} else {
					jsonObject.put("doorReportRoot", "");
				}
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		} else if (param.equals("getTemperatureAlertReport")) {
			try {
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				String startDate = yyyyMMdd.format(ddmmyyyy.parse(request.getParameter("startdate")));
				String endDate = yyyyMMdd.format(ddmmyyyy.parse(request.getParameter("enddate")));
				String vehicleNo = request.getParameter("vehicleNo");
				ArrayList<Object> list1 = trf.getTemperatureAlertReportDetails(startDate, endDate, offset, distUnits, vehicleNo, systemId, clientId);
				jsonArray = (JSONArray) list1.get(0);
				if (jsonArray.length() > 0) {
					jsonObject.put("tempReportRoot", jsonArray);
				} else {
					jsonObject.put("tempReportRoot", "");
				}
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		} else if (param.equals("getGeofenceCorrectionData")) {
			try {
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				String startDate = yyyyMMdd.format(ddmmyyyy.parse(request.getParameter("startDate")));
				String endDate = yyyyMMdd.format(ddmmyyyy.parse(request.getParameter("endDate")));
				String tripCustId = request.getParameter("tripCustId");
				ArrayList<Object> list1 = gf.getGeofenceCorrectionData(startDate, endDate, offset, systemId, clientId, tripCustId, zone);
				jsonArray = (JSONArray) list1.get(0);
				if (jsonArray.length() > 0) {
					jsonObject.put("geofenceCorrectionRoot", jsonArray);
				} else {
					jsonObject.put("geofenceCorrectionRoot", "");
				}
				response.getWriter().print(jsonObject.toString());
				
				cf.insertDataIntoAuditLogReport(sessionId, null, "Geofence Correction Report", "View", userId, serverName, systemId, clientId,
				"Visited This Page");
				
			} catch (Exception e) {
				e.printStackTrace();
			}
		} else if (param.equals("getTripAuditLogReport")) {
			try {
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				String startDate = yyyyMMdd.format(ddmmyyyy.parse(request.getParameter("startDate")));
				String endDate = yyyyMMdd.format(ddmmyyyy.parse(request.getParameter("endDate")));
				jsonArray = gf.getTripAuditLogDetails(startDate, endDate, systemId, clientId ,offset);
				if (jsonArray.length() > 0) {
					jsonObject.put("tripAuditLogDetails", jsonArray);
				} else {
					jsonObject.put("tripAuditLogDetails", "");
				}
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		else if (param.equals("getRegNosVId")) {
			try {
				JSONArray vehicleJsonArr = new JSONArray();
				JSONObject vehicleJsonObj = new JSONObject();
				vehicleJsonArr = trf.getVehiclesandUnitforClientAndVid(String.valueOf(systemId), String.valueOf(clientId), userId);
				vehicleJsonObj.put("RegNos", vehicleJsonArr);
				response.getWriter().print(vehicleJsonObj.toString());

			} catch (Exception e) {
				e.printStackTrace();
			}
		} else if (param.equals("getVehicleStoreId")) {
			try {
				jsonArray = trf.getVehicleListWithId(systemId, clientId, userId);
				jsonObject = new JSONObject();
				if (jsonArray != null && jsonArray.length() != 0) {
					jsonObject.put("VehicleRoot", jsonArray);
				} else {
					jsonObject.put("VehicleRoot", "");
				}
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		} else if(param.equals("getstopReport")) {
			String startDateFormated = "";
			String endDateFormated = "";

			try {
				JSONArray list = new JSONArray();
				JSONObject rslt = new JSONObject();
				if (request.getParameter("startdate") != null && request.getParameter("enddate") != null && request.getParameter("regno") != null) {
					String startdate = request.getParameter("startdate");
					String enddate = request.getParameter("enddate");
					String clientName = request.getParameter("clientname");
					String regno = request.getParameter("regno");
					try {
						cf.insertDataIntoAuditLogReport(sessionId, null, "Stop Report", "View", userId, serverName, systemId, Integer.parseInt(clientName == null || clientName.equals("") ? "5560" : clientName), "Stop Report for " + regno + " startdate " + startdate + " enddate " + enddate);
					} catch (Exception e) {
						e.printStackTrace();
					}
					startDateFormated = trf.ConvertLOCALtoGMT(startdate, offset);
					endDateFormated = trf.ConvertLOCALtoGMT(enddate, offset);
					Date startDateFormated1 = sdfFormatDate.parse(startDateFormated);
					Date endDateFormated1 = sdfFormatDate.parse(endDateFormated);
					Vector v = trf.getStopReport(startDateFormated1, endDateFormated1, regno, String.valueOf(clientId), String.valueOf(systemId), offset, session);
					list = (JSONArray) v.get(0);
					rslt.put("StopReport", list);
				} else {
					rslt.put("StopReport", "");
				}
				response.getWriter().print(rslt.toString());
			} catch (Exception e) {
				e.printStackTrace();
				System.out.println("Error.." + e);
			}
		}		
		else if (param.equals("getTripNames")) {
			try {
				String startDate = request.getParameter("startDate");
				String endDate = request.getParameter("endDate");
				jsonArray = trf.getTripNames(systemId, clientId, offset, startDate, endDate);
				jsonObject = new JSONObject();
				if (jsonArray != null && jsonArray.length() != 0) {
					jsonObject.put("tripRoot", jsonArray);
				} else {
					jsonObject.put("tripRoot", "");
				}
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		else if (param.equals("getActivityReportData")) {
			try {
				String startdate = request.getParameter("startdate");
				String enddate = request.getParameter("enddate");
				String regno = request.getParameter("regno");
				String category=request.getParameter("category");
				jsonArray = trf.getActivityReport(startdate, enddate, regno, clientId, systemId, offset, userId,category);
				jsonObject = new JSONObject();
				jsonObject.put("ActivityReportDetailsRoot", jsonArray);
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		}else if (param.equals("getSummaryDetailsStore")) {

			String clientFromJsp = request.getParameter("globalClientId");
			String vehicleNumber = request.getParameter("globalVehicleId");
			double ConversionFactor = 0;
			String unitname="";
			
			ConversionFactor =initializedistanceConversionFactorofVehicle(systemId,  "");
			unitname = initializeDistanceUnitNameofVehicle(systemId, con,"");
			if(vehicleNumber != null)
			{
//				session.setAttribute("vehicleNumber", vehicleNumber);
//				if(request.getParameter("globalVehicleRawValue").contains("("))
//				{
//					session.setAttribute("VehicleId", request.getParameter("globalVehicleRawValue").substring(request.getParameter("globalVehicleRawValue").indexOf("(")+1, request.getParameter("globalVehicleRawValue").lastIndexOf(")")));
//				} else {
//					session.setAttribute("VehicleId", "");
//				}
			}
			String tripId = request.getParameter("globalTripId");
			String vehicleType = request.getParameter("vehicleType");
			String timeBand = request.getParameter("timeBand");
			String startDateTime = request.getParameter("startDateTime");
			String endDateTime = request.getParameter("endDateTime");
			
			String serviceRecieverNew = request.getParameter("SelectedClientName");
			
			if (clientFromJsp != null && !clientFromJsp.equals("")) {
				clientId = Integer.parseInt(clientFromJsp);
			}
			try {
				//CommonFunctions cf1=new CommonFunctions();
				if(vehicleNumber != null){
					cf.insertDataIntoAuditLogReport(sessionId, null, "Activity Report", "View", userId, serverName, systemId, clientId,
							"Searched Activity Report for "+vehicleNumber +" from "+startDateTime+" to "+endDateTime);
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
			int timeBandInt = 0;
			if (timeBand != null && !timeBand.equals("") && !timeBand.equals("null")) {
				timeBandInt = Integer.parseInt(timeBand);
				timeBandInt = timeBandInt * 60 * 1000;
			} else {
				timeBandInt = 0;
			}

			if (tripId != null && !tripId.equals("0") && !tripId.equals("")) {
				
				ArrayList tripDateList = tbrFunc.getTripStartEndTime(
						tripId, vehicleNumber, systemId, offset);
				String stdate1 = tripDateList.get(0).toString();
				String timeStr[] = tripDateList.get(1).toString().split(":");
				int startHr = Integer.parseInt(timeStr[0]);
				int startMin = Integer.parseInt(timeStr[1]);
				String enddate1 = tripDateList.get(2).toString();
				timeStr = tripDateList.get(3).toString().split(":");
				int endHr = Integer.parseInt(timeStr[0]);
				int endMin = Integer.parseInt(timeStr[1]);
				startDateTime = stdate1 + " "+ startHr + ":" + startMin + ":00";
				endDateTime = enddate1 + " "+ endHr + ":" + endMin + ":00";

			}

			if (vehicleNumber != null && startDateTime != null
					&& endDateTime != null) {
				try {
					String avgspeedex = "0.00";
					String avgspeedinc = "0.00";
					String diswithoverspeed = "0.00";
					String maxspeed = "0.00";
					String totdistravelled = "0.00";
					String fuelcal = "0.00";

					session.setAttribute("startDateTime", startDateTime);
					session.setAttribute("endDateTime", endDateTime);

					startDateTime = getFormattedDateStartingFromMonth(startDateTime);
					startDateTime = getLocalDateTime(startDateTime,
							offset);

					endDateTime = getFormattedDateStartingFromMonth(endDateTime);
					endDateTime = getLocalDateTime(endDateTime,
							offset);
					// System.out.println("@@@@@@@@@@"+sdfFormatDate.parse(startDateTime)+"   "+sdfFormatDate.parse(endDateTime)+"   "+timeBandInt);
					con = DBConnection.getConnectionToDB("AMS");
					System.out.println("con in Try block:"+con);
					VehicleActivity vi = new VehicleActivity(con,
							vehicleNumber, sdfFormatDate.parse(startDateTime),
							sdfFormatDate.parse(endDateTime), offset, systemId,
							clientId, timeBandInt);
					VehicleSummaryBean vsb = vi.getVehicleSummaryBean();
					VehicleSummaryBean exp = vi.getVehicleSummaryBean();
					
					jsonArray = new JSONArray();
					jsonObject = new JSONObject();
					
					if(systemId == 15){
						 ConversionFactor =initializedistanceConversionFactor(systemId, con, vehicleNumber);
						 unitname = initializeDistanceUnitName(systemId, con,vehicleNumber);
					}

					double fuel = tbrFunc.getApproxMileage(vehicleNumber,
							systemId);

					jsonObject.put("unitNumber", vsb.getUnitNumber());
					exp.setUnitNumber(vsb.getUnitNumber());

					jsonObject.put("durationSelected", vsb
							.getDurationSelectedFormated());
					exp.setDurationSelectedFormated(vsb
							.getDurationSelectedFormated());

					jsonObject.put("totalStopDuration", vsb
							.getTotalStopDurationFormated());
					exp.setTotalStopDurationFormated(vsb
							.getTotalStopDurationFormated());

					jsonObject.put("totalNoOfStops", vsb
							.getTotalNumberOfStops());
					exp.setTotalNumberOfStops(vsb.getTotalNumberOfStops());

					jsonObject.put("totalIdleDuration", vsb
							.getTotalIdleDurationFormated());
					exp.setTotalIdleDurationFormated(vsb
							.getTotalIdleDurationFormated());

					jsonObject
							.put("totalNoOfIdle", vsb.getTotalNumberOfIdles());
					exp.setTotalNumberOfIdles(vsb.getTotalNumberOfIdles());

					try {
						avgspeedex = df.format(vsb
								.getAverageSpeedExcludingStoppageInKMPH()
								* ConversionFactor);
						jsonObject.put("averageSpeedExcludingStop", avgspeedex);
						exp.setAverageSpeedExcludingStoppageInKMPH(Double
								.parseDouble(avgspeedex));
					} catch (Exception e) {
						avgspeedex = "0.00";
						jsonObject.put("averageSpeedExcludingStop", avgspeedex);
						exp.setAverageSpeedExcludingStoppageInKMPH(Double
								.parseDouble(avgspeedex));
					}

					try {
						avgspeedinc = df.format(vsb
								.getAverageSpeedIncludingStoppageInKMPH()
								* ConversionFactor);
						jsonObject
								.put("averageSpeedIncludingStop", avgspeedinc);
						exp.setAverageSpeedIncludingStoppageInKMPH(Double
								.parseDouble(avgspeedinc));
					} catch (Exception e) {
						avgspeedinc = "0.00";
						jsonObject
								.put("averageSpeedIncludingStop", avgspeedinc);
						exp.setAverageSpeedIncludingStoppageInKMPH(Double
								.parseDouble(avgspeedinc));
					}

					jsonObject.put("numberOfOverSpeed", vsb
							.getTotalNumberOfOverSpeeds());
					exp.setTotalNumberOfOverSpeeds(vsb
							.getTotalNumberOfOverSpeeds());

					try {
						diswithoverspeed = df.format(vsb
								.getDistanceTravelledWithOverSpeeds()
								* ConversionFactor);
						jsonObject.put("distanceTravelledWithOverSpeed",
								diswithoverspeed);
						exp.setDistanceTravelledWithOverSpeeds(Double
								.parseDouble(diswithoverspeed));
					} catch (Exception e) {
						diswithoverspeed = "0.00";
						jsonObject.put("distanceTravelledWithOverSpeed",
								diswithoverspeed);
						exp.setDistanceTravelledWithOverSpeeds(Double
								.parseDouble(diswithoverspeed));
					}

					try {
						maxspeed = df.format(vsb.getMaxSpeedInKMPH()
								* ConversionFactor);
						jsonObject.put("maxSpeed", maxspeed);
						exp.setMaxSpeedInKMPH(Double.parseDouble(maxspeed));
					} catch (Exception e) {
						maxspeed = "0.00";
						jsonObject.put("maxSpeed", maxspeed);
						exp.setMaxSpeedInKMPH(Double.parseDouble(maxspeed));
					}

					jsonObject.put("travelTime", vsb.getTravelTimeFormated());
					exp.setTravelTimeFormated(vsb.getTravelTimeFormated());

					double idlehrs = getHrsFromDaysHrsMins(vsb.getTotalIdleDurationFormated());

					double runninghr = getHrsFromDaysHrsMins(vsb.getTravelTimeFormated());

					double stoppagehr = getHrsFromDaysHrsMins(vsb.getTotalStopDurationFormated());
					
					double totalduration = getHrsFromDaysHrsMins(vsb.getDurationSelectedFormated());
					double nwloss = (totalduration - (idlehrs + runninghr + stoppagehr)) * 60;

					String nwstring = daysHrsMinsFormat((long) nwloss);

					double enginepmh = (idlehrs + runninghr) * 60;// min

					String engineHrsFormated = enginepmh > 0 ? daysHrsMinsFormat((long) enginepmh)
							: "N/A";

					jsonObject.put("engineHours", engineHrsFormated);
					session.setAttribute("enginehours", engineHrsFormated);

					jsonObject.put("nwloss", nwstring);
					session.setAttribute("nwloss", nwstring);

					/*
					 * long engineMinute =
					 * (long)(getTotalEngineHours(vehicleNumber) * 60); String
					 * engineHrsFormated = engineMinute > 0 ?
					 * daysHrsMinsFormat(engineMinute):"N/A";
					 * jsonObject.put("engineHours",engineHrsFormated);
					 * session.setAttribute("enginehours",engineHrsFormated);
					 */

					try {
						totdistravelled = df.format(vsb
								.getTotalDistanceTravelled()
								* ConversionFactor);
						jsonObject.put("totalDistanceTravelled",
								totdistravelled);
						exp.setTotalDistanceTravelled(Double
								.parseDouble(totdistravelled));
					} catch (Exception e) {
						totdistravelled = "0.00";
						jsonObject.put("totalDistanceTravelled",
								totdistravelled);
						exp.setTotalDistanceTravelled(Double
								.parseDouble(totdistravelled));
					}

					jsonObject.put("distanceUnitName", unitname);
					session.setAttribute("unitname", unitname);
					if (vsb.getDistlabel()!= null && vsb.getDistlabel().toLowerCase().equals("odometer")) {
						if (vsb.getCumuOdometerLabel().toLowerCase().equals(
								"yes")) {
							jsonObject.put("cumdisable", "yes");
							session.setAttribute("cumdisable", "yes");
						} else {
							jsonObject.put("cumdisable", "no");
							session.setAttribute("cumdisable", "no");
						}
					} else {
						jsonObject.put("cumdisable", "no");
						session.setAttribute("cumdisable", "no");
					}

					jsonArray.put(jsonObject);
					session.setAttribute("summarySession", exp);

					if (fuel > 0) {
						try {
							fuelcal = df.format((Double
									.parseDouble(totdistravelled) / fuel));
							jsonObject.put("FuelConsumed", fuelcal);
							session.setAttribute("FuelConsumed", fuelcal);
						} catch (Exception e) {
							fuelcal = "0.00";
							jsonObject.put("FuelConsumed", fuelcal);
							session.setAttribute("FuelConsumed", fuelcal);
						}
					} else {
						jsonObject.put("FuelConsumed", "0");
						session.setAttribute("FuelConsumed", "0");
					}
					jsonObject.put("msgforunittypechange",vsb.getMessageForChangeDistFactor());
					jsonObject = new JSONObject();
					if (jsonArray != null) {
						jsonObject.put("SummaryDetailsRoot", jsonArray);
					} else {
						jsonObject.put("SummaryDetailsRoot", "");
					}
					response.getWriter().print(jsonObject.toString());
				} catch (Exception e) {
					e.printStackTrace();
				} finally {
					System.out.println("con: "+ con);
					DBConnection.releaseConnectionToDB(con, null, null);
				}
			} else {
				try {
					jsonObject = new JSONObject();
					jsonObject.put("SummaryDetailsRoot", "");
					response.getWriter().print(jsonObject.toString());
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		}else if (param.equals("getSmartHubNames")) {
		
			try {
				jsonArray = trf.getSmartHubDetails(systemId, clientId);
				jsonObject = new JSONObject();
				if (jsonArray != null && jsonArray.length() != 0) {
					jsonObject.put("SmartHubNamesRoot", jsonArray);
				} else {
					jsonObject.put("SmartHubNamesRoot", "");
				}
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		}else if (param.equals("getHubVehicleDetailsForReport")) {
		
			try {
				String startDate = yyyyMMdd.format(ddmmyyyy.parse(request.getParameter("startdate")));
				String endDate = yyyyMMdd.format(ddmmyyyy.parse(request.getParameter("enddate")));
				String hubId = request.getParameter("hubId");
				jsonArray = trf.getHubVehicleDetailsForReport(startDate, endDate,offset,hubId,systemId);
				jsonObject = new JSONObject();
				if (jsonArray != null && jsonArray.length() != 0) {
					jsonObject.put("hubSummaryDetailsgrid", jsonArray);
				} else {
					jsonObject.put("hubSummaryDetailsgrid", new JSONArray());
				}
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		}else if (param.equals("getUnRegisterdVehicles")) {
			try {				 
				jsonArray = trf.getUnRegisterdVehicles(systemId,clientId);
				jsonObject = new JSONObject();
				jsonObject.put("UnRegisterdVehiclesRoot", jsonArray);
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		return null;
	}

	
	private String daysHrsMinsFormat(long stopIdleMinute) {
		String stopDura = "0 days 0hrs 0 mins";
		try {
			if (stopIdleMinute > 0) {
				long days = stopIdleMinute / (60 * 24);
				long hour = (stopIdleMinute - (60 * 24 * days)) / 60;
				long min = stopIdleMinute - (days * 24 * 60) - hour * 60;
				stopDura = days + "days " + hour + "hrs " + min + " mins";
			}
		} catch (Exception e) {
			System.out.println("Exception in daysHrsMinsFormat(): " + e);
		}
		return stopDura;
	}


	private double getHrsFromDaysHrsMins(String daysHrsMins) {
		double hrs = 0.0;
		if (daysHrsMins != null && !daysHrsMins.equals("N/A")) {
			StringTokenizer st = new StringTokenizer(daysHrsMins, " ");
			String str[] = new String[3];
			int k = 0;
			while (st.hasMoreTokens()) {
				str[k] = (String) st.nextElement();
				k++;
			}
			int day = Integer.parseInt(str[0].replace("days", "").trim());
			int hour = Integer.parseInt(str[1].replace("hrs", "").trim());
			int min = Integer.parseInt(str[2].replace("mins", "").trim());
			hrs = (day * 24) + hour + (min / 60.0);
		}
		return hrs;
	}

	private String getLocalDateTime(String inputDate, int offSet) {
		String retValue = inputDate;
		Date convDate = null;
		convDate = convertStringToDate(inputDate);
		if (convDate != null) {
			Calendar cal = Calendar.getInstance();
			cal.setTime(convDate);
			cal.add(Calendar.MINUTE, -offSet);

			int day = cal.get(Calendar.DATE);
			int y = cal.get(Calendar.YEAR);
			int m = cal.get(Calendar.MONTH) + 1;
			int h = cal.get(Calendar.HOUR_OF_DAY);
			int mi = cal.get(Calendar.MINUTE);
			int s = cal.get(Calendar.SECOND);

			String yyyy = String.valueOf(y);
			String month = String.valueOf(m > 9 ? String.valueOf(m) : "0"
					+ String.valueOf(m));
			String date = String.valueOf(day > 9 ? String.valueOf(day) : "0"
					+ String.valueOf(day));
			String hour = String.valueOf(h > 9 ? String.valueOf(h) : "0"
					+ String.valueOf(h));
			String minute = String.valueOf(mi > 9 ? String.valueOf(mi) : "0"
					+ String.valueOf(mi));
			String second = String.valueOf(s > 9 ? String.valueOf(s) : "0"
					+ String.valueOf(s));

			retValue = month + "/" + date + "/" + yyyy + " " + hour + ":"
					+ minute + ":" + second;
			// System.out.println("New Date:::"+retValue);

		}
		return retValue;
	}

	private Date convertStringToDate(String inputDate) {
		Date dDateTime = null;
		// String pDate="";

		SimpleDateFormat sdfFormatDate = new SimpleDateFormat(
				"MM/dd/yyyy HH:mm:ss");
		// SimpleDateFormat sdfFormatDate = new SimpleDateFormat(format);

		try {
			if (inputDate != null && !inputDate.equals("")) {
				dDateTime = sdfFormatDate.parse(inputDate);
				java.sql.Timestamp timest = new java.sql.Timestamp(dDateTime
						.getTime());
				dDateTime = timest;
			}

		} catch (Exception e) {
			System.out.println("Error in convertStringToDate method" + e);
			e.printStackTrace();
		}
		// System.out.println("dDateTime:"+dDateTime);
		return dDateTime;
	}

	private String initializeDistanceUnitName(int SystemId, Connection con,String registrationNo) {
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String distanceUnitName;
		double distanceConversionFactor;
		distanceConversionFactor = 1.0;
		distanceUnitName = "kms";
		try {
			 con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(TripBasedReportStatements.GET_DISTANCE_CONVERSION_FACTOR_FROM_VEHICLE_TYPE);
			pstmt.setInt(1, SystemId);
			pstmt.setString(2, registrationNo);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				distanceUnitName = rs.getString("UnitName");
				distanceConversionFactor = rs.getDouble("ConversionFactor");
			}		
		} catch (Exception e) {			
			e.printStackTrace();
		}finally{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return distanceUnitName;
	}
	

	private double initializedistanceConversionFactor(int SystemId,Connection con, String registrationNo) {
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String distanceUnitName;
		double distanceConversionFactor;
		distanceConversionFactor = 1.0;
		distanceUnitName = "kms";
		try {
			 con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(TripBasedReportStatements.GET_DISTANCE_CONVERSION_FACTOR_FROM_VEHICLE_TYPE);
			pstmt.setInt(1, SystemId);
			pstmt.setString(2, registrationNo);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				distanceUnitName = rs.getString("UnitName");
				distanceConversionFactor = rs.getDouble("ConversionFactor");
				}			
		} catch (Exception e) {
			e.printStackTrace();
		}finally{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return distanceConversionFactor;
	}

	private String getFormattedDateStartingFromMonth(String inputDate) {
		String formattedDate = "";
		SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
		SimpleDateFormat sdfFormatDate = new SimpleDateFormat(
				"MM/dd/yyyy HH:mm:ss");
		try {
			if (inputDate != null && !inputDate.equals("")) {
				java.util.Date d = sdf.parse(inputDate);
				formattedDate = sdfFormatDate.format(d);
			}
		} catch (Exception e) {
			System.out
					.println("Error in getFormattedDateStartingFromMonth() method"
							+ e);
			e.printStackTrace();
		}
		return formattedDate;
	
	}
	private String initializeDistanceUnitNameofVehicle(int SystemId, Connection con,String registrationNo) {
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String distanceUnitName;
		double distanceConversionFactor;
		distanceConversionFactor = 1.0;
		distanceUnitName = "kms";
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement("select UnitName,ConversionFactor from tblDistanceUnitMaster where UnitId = (select DistanceUnitId from System_Master where System_id=?)");
			pstmt.setInt(1, SystemId);
			rs = pstmt.executeQuery();
			while (rs.next()) {				
				distanceUnitName = rs.getString("UnitName");
				distanceConversionFactor = rs.getDouble("ConversionFactor");
			}			
		} catch (Exception e) {			
			e.printStackTrace();
		}finally{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return distanceUnitName;
	}
	private double initializedistanceConversionFactorofVehicle(int SystemId, String registrationNo) {
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Connection con = null;
		String distanceUnitName;
		double distanceConversionFactor;
		distanceConversionFactor = 1.0;
		distanceUnitName = "kms";
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement("select UnitName,ConversionFactor from tblDistanceUnitMaster where UnitId = (select DistanceUnitId from System_Master where System_id=?)");
			pstmt.setInt(1, SystemId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				distanceUnitName = rs.getString("UnitName");
				distanceConversionFactor = rs.getDouble("ConversionFactor");
			}			
		} catch (Exception e) {			
			e.printStackTrace();
		}finally{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return distanceConversionFactor;
	}
	}

