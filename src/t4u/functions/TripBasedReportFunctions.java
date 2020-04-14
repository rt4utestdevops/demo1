package t4u.functions;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.text.DateFormat;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.LinkedList;
import java.util.Vector;

import javax.servlet.http.HttpSession;

import org.json.JSONArray;
import org.json.JSONObject;

import t4u.beans.ReportHelper;
import t4u.common.DBConnection;
import t4u.statements.CommonStatements;
import t4u.statements.TripBasedReportStatements;

import com.t4u.activity.VehicleActivity;
import com.t4u.activity.VehicleActivity.DataListBean;


@SuppressWarnings("unchecked")
public class TripBasedReportFunctions {
	SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
	SimpleDateFormat sdfDB = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	SimpleDateFormat sdf1 = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
	DecimalFormat df = new DecimalFormat("00.00");
	CommonFunctions cf = new CommonFunctions();

	public ArrayList<Object> getTripBasedReportDetails(String startDate, String endDate, String tripStatus, int offset, String distUnits, String vehicleNo, String routeId, int systemId, int clientId) {
		JSONArray JsonArray = new JSONArray();
		JSONObject JsonObject = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		ArrayList<Object> finlist = new ArrayList<Object>();
		double distance = 0;
		String cond = "";
		String condition = "";
		try {
			int count = 0;
			con = DBConnection.getConnectionToDB("AMS");
			if (!vehicleNo.equals("-- ALL --")) {
				condition = "and td.ASSET_NUMBER = '" + vehicleNo + "'";
			} else {
				if (Integer.parseInt(routeId) != 0) {
					condition = "and td.ROUTE_ID = " + routeId;
				}
			}
			if (tripStatus.equals("0")) {
				cond = "  and  td.INSERTED_TIME between dateadd(mi,-?,?) and dateadd(mi,-?,?) ";
			} else if (tripStatus.equals("1")) {
				cond = "  and td.STATUS='OPEN' and  td.INSERTED_TIME between dateadd(mi,-?,?) and dateadd(mi,-?,?) ";
			} else if (tripStatus.equals("2")) {
				cond = " and td.STATUS='CLOSED' and  td.ACTUAL_TRIP_END_TIME between dateadd(mi,-?,?) and dateadd(mi,-?,?) ";
			} else if (tripStatus.equals("3")) {
				cond = " and td.STATUS='CANCEL' and  td.INSERTED_TIME between dateadd(mi,-?,?) and dateadd(mi,-?,?) ";
			}
			pstmt = con.prepareStatement(TripBasedReportStatements.GET_REPORT_DATA.replace("#", cond).replace("$", condition));
			pstmt.setInt(1, offset);
			pstmt.setInt(2, offset);
			pstmt.setInt(3, offset);
			pstmt.setInt(4, offset);
			pstmt.setInt(5, offset);
			pstmt.setInt(6, systemId);
			pstmt.setInt(7, clientId);
			pstmt.setInt(8, offset);
			pstmt.setString(9, startDate);
			pstmt.setInt(10, offset);
			pstmt.setString(11, endDate);
			rs = pstmt.executeQuery();
			while (rs.next()) {

				JsonObject = new JSONObject();
				count++;

				String tripStartDate = "";
				if (!rs.getString("TRIP_START").contains("1900")) {
					tripStartDate = sdf.format(rs.getTimestamp("TRIP_START"));
				}

				String tripEndDate = "";
				if (!rs.getString("TRIP_END").contains("1900")) {
					tripEndDate = sdf.format(rs.getTimestamp("TRIP_END"));
				}

				JsonObject.put("slnoIndex", count);
				JsonObject.put("tripIdIndex", rs.getInt("TRIP_ID"));
				JsonObject.put("tripNumberIndex", rs.getString("TRIP_NO"));// shipment
				JsonObject.put("vehicleNoIndex", rs.getString("VEHICLE_NO"));
				JsonObject.put("startPointIndex", rs.getString("START_POINT"));
				JsonObject.put("endPointIndex", rs.getString("END_POINT"));
				JsonObject.put("currentLocationIndex", rs.getString("CURRENT_LOCATION"));
				JsonObject.put("startDate", tripStartDate);
				JsonObject.put("endDate", tripEndDate);

				if (distUnits.equals("Miles")) {
					distance = rs.getDouble("TRAVELLED_DISTANCE") * 0.621371;
					JsonObject.put("distanceIndex", df.format(distance));
				} else {
					distance = rs.getDouble("TRAVELLED_DISTANCE");
					JsonObject.put("distanceIndex", distance);
				}

				JsonObject.put("durationIndex", cf.convertMinutesToHHMMFormat(rs.getInt("DURATION")));

				JsonObject.put("routeName", rs.getString("ROUTE_NAME"));

				JsonObject.put("tripStatusIndex", rs.getString("STATUS"));

				if (!rs.getString("TRIP_PLANNED_DATE").contains("1900")) {
					JsonObject.put("tripPlannedIndex", sdf.format(rs.getTimestamp("TRIP_PLANNED_DATE")));
				} else {
					JsonObject.put("tripPlannedIndex", "");
				}

				if (rs.getString("LOAD_START_TIME") != null && !rs.getString("LOAD_START_TIME").contains("1900")) {
					JsonObject.put("loadStartTime", sdf.format(rs.getTimestamp("LOAD_START_TIME")));
				} else {
					JsonObject.put("loadStartTime", "");
				}

				if (rs.getString("LOAD_END_TIME") != null && !rs.getString("LOAD_END_TIME").contains("1900")) {
					JsonObject.put("loadEndTime", sdf.format(rs.getTimestamp("LOAD_END_TIME")));
				} else {
					JsonObject.put("loadEndTime", "");
				}
				JsonArray.put(JsonObject);
			}

			finlist.add(JsonArray);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return finlist;
	}

	public JSONArray getRegistrationNoBasedOnUser(int custId, int ltspId, int userId) {
		JSONArray jsonArray = null;
		JSONObject jsonObject = null;

		Connection conAms = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {

			jsonArray = new JSONArray();
			jsonObject = new JSONObject();
			conAms = DBConnection.getConnectionToDB("AMS");
			pstmt = conAms.prepareStatement(CommonStatements.GET_REGISTRATION_NO_BASED_ON_USER);
			pstmt.setInt(1, custId);
			pstmt.setInt(2, ltspId);
			pstmt.setInt(3, userId);
			rs = pstmt.executeQuery();
			jsonObject = new JSONObject();
			jsonObject.put("VehicleNo", "-- ALL --");
			jsonArray.put(jsonObject);
			while (rs.next()) {
				jsonObject = new JSONObject();
				jsonObject.put("VehicleNo", rs.getString("REGISTRATION_NUMBER"));
				jsonArray.put(jsonObject);
			}

		} catch (Exception e) {
			System.out.println("Error in TripBasedFunctions:-getRegistrationNoBasedOnUser " + e.toString());
		} finally {
			DBConnection.releaseConnectionToDB(conAms, pstmt, rs);
		}
		return jsonArray;
	}

	public JSONArray getRouteDetails(int custId, int systemId) {
		JSONArray jsonArray = null;
		JSONObject jsonObject = null;

		Connection conAms = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {

			jsonArray = new JSONArray();
			jsonObject = new JSONObject();
			conAms = DBConnection.getConnectionToDB("AMS");
			pstmt = conAms.prepareStatement(TripBasedReportStatements.GET_ROUTE_DETAILS);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, custId);
			rs = pstmt.executeQuery();
			jsonObject = new JSONObject();
			jsonObject.put("routeId", 0);
			jsonObject.put("routeName", "-- ALL --");
			jsonArray.put(jsonObject);
			while (rs.next()) {
				jsonObject = new JSONObject();
				jsonObject.put("routeId", rs.getString("RouteID"));
				jsonObject.put("routeName", rs.getString("RouteName"));
				jsonArray.put(jsonObject);
			}
		} catch (Exception e) {
			System.out.println("Error in TripBasedFunctions:-getRouteDetails " + e.toString());
		} finally {
			DBConnection.releaseConnectionToDB(conAms, pstmt, rs);
		}
		return jsonArray;
	}

	public ArrayList<Object> getDoorAlertReportDetails(String startDate, String endDate, int offset, String distUnits, String vehicleNo, int systemId, int clientId) {
		JSONArray JsonArray = new JSONArray();
		JSONObject JsonObject = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		ArrayList<Object> finlist = new ArrayList<Object>();
		try {
			int count = 0;
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(TripBasedReportStatements.GET_DOOR_ALERT_REPORT_DATA);
			pstmt.setInt(1, offset);
			pstmt.setInt(2, offset);
			pstmt.setInt(3, offset);
			pstmt.setInt(4, systemId);
			pstmt.setInt(5, clientId);
			pstmt.setInt(6, offset);
			pstmt.setString(7, startDate);
			pstmt.setInt(8, offset);
			pstmt.setString(9, endDate);
			pstmt.setString(10, vehicleNo);
			rs = pstmt.executeQuery();
			while (rs.next()) {

				JsonObject = new JSONObject();
				count++;
				String startDateTime = "";
				if (!rs.getString("START_GMT").contains("1900")) {
					startDateTime = sdf.format(rs.getTimestamp("START_GMT"));
				}
				String endDateTime = "";
				if (!rs.getString("END_GMT").contains("1900")) {
					endDateTime = sdf.format(rs.getTimestamp("END_GMT"));
				}
				String ackDateTime = "";
				if (!rs.getString("ACK_DATETIME").contains("1900")) {
					ackDateTime = sdf.format(rs.getTimestamp("ACK_DATETIME"));
				}
				JsonObject.put("slnoIndex", count);

				JsonObject.put("vehicleNoIndex", rs.getString("VEHICLE_NO"));

				JsonObject.put("doorNoIndex", rs.getString("DOOR_NO"));

				JsonObject.put("startTimeIndex", startDateTime);

				JsonObject.put("endTimeIndex", endDateTime);

				JsonObject.put("startLocIndex", rs.getString("START_LOCATION"));

				JsonObject.put("endLocIndex", rs.getString("END_LOCATION"));

				JsonObject.put("alertTypeIndex", rs.getString("ALERT_TYPE"));

				JsonObject.put("durationIndex", rs.getString("DURATION"));

				JsonObject.put("statusIndex", rs.getString("STATUS"));

				JsonObject.put("ackByIndex", rs.getString("FIRSTNAME") + " " + rs.getString("LASTNAME"));

				JsonObject.put("ackDateTimeIndex", ackDateTime);

				JsonArray.put(JsonObject);
			}

			finlist.add(JsonArray);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return finlist;
	}

	public ArrayList<Object> getTemperatureAlertReportDetails(String startDate, String endDate, int offset, String distUnits, String vehicleNo, int systemId, int clientId) {
		JSONArray JsonArray = new JSONArray();
		JSONObject JsonObject = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		ArrayList<Object> finlist = new ArrayList<Object>();
		try {
			int count = 0;
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(TripBasedReportStatements.GET_TEMP_ALERT_REPORT_DATA);
			pstmt.setInt(1, offset);
			pstmt.setInt(2, offset);
			pstmt.setInt(3, systemId);
			pstmt.setInt(4, clientId);
			pstmt.setInt(5, offset);
			pstmt.setString(6, startDate);
			pstmt.setInt(7, offset);
			pstmt.setString(8, endDate);
			pstmt.setString(9, vehicleNo);
			rs = pstmt.executeQuery();
			while (rs.next()) {

				JsonObject = new JSONObject();
				count++;
				String dateTime = "";
				if (!rs.getString("DATETIME").contains("1900")) {
					dateTime = sdf.format(rs.getTimestamp("DATETIME"));
				}
				String ackDateTime = "";
				if (!rs.getString("ACK_DATETIME").contains("1900")) {
					ackDateTime = sdf.format(rs.getTimestamp("ACK_DATETIME"));
				}
				JsonObject.put("slnoIndex", count);

				JsonObject.put("vehicleNoIndex", rs.getString("VEHICLE_NO"));

				JsonObject.put("alertNameIndex", rs.getString("ALERT_NAME"));

				JsonObject.put("dateTimeIndex", dateTime);

				JsonObject.put("locationIndex", rs.getString("LOCATION"));

				JsonObject.put("tempIndex", rs.getString("TEMP_VALUE"));

				JsonObject.put("descriptionIndex", rs.getString("DESCRIPTION"));

				JsonObject.put("remarksIndex", rs.getString("REMARKS"));

				JsonObject.put("ackByIndex", rs.getString("FIRSTNAME") + " " + rs.getString("LASTNAME"));

				JsonObject.put("ackDateTimeIndex", ackDateTime);

				JsonArray.put(JsonObject);
			}

			finlist.add(JsonArray);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return finlist;
	}

	/**
	 * To get Vehicles Combined with Vehicle Id.
	 * 
	 * @param systemId
	 * @param cid
	 * @param userId
	 * @return
	 */
	public JSONArray getVehiclesandUnitforClientAndVid(String systemId, String cid, int userId) {

		JSONArray list2 = new JSONArray();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			con = DBConnection.getConnectionToDB("AMS");
			String stmt = TripBasedReportStatements.SELECT_VEHICLE_ADN_UNIT_LIST_AND_VID;
			pstmt = con.prepareStatement(stmt);
			pstmt.setString(1, systemId);
			pstmt.setString(2, cid);
			pstmt.setInt(3, userId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				JSONObject obj1 = new JSONObject();
				obj1.put("VehId", rs.getString("REGISTRATION_NUMBER"));
				list2.put(obj1);
			}
		} catch (Exception e) {
			System.out.println("Error when getClientList.." + e);
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return list2;

	}

	public String initializeDistanceUnitNameofVehicle(int SystemId, Connection con, String registrationNo) {
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String distanceUnitName;
		@SuppressWarnings("unused")
		double distanceConversionFactor;
		distanceConversionFactor = 1.0;
		distanceUnitName = "kms";
		try {
			pstmt = con.prepareStatement("select UnitName,ConversionFactor from tblDistanceUnitMaster where UnitId = (select DistanceUnitId from System_Master where System_id=?)");
			pstmt.setInt(1, SystemId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				distanceUnitName = rs.getString("UnitName");
				distanceConversionFactor = rs.getDouble("ConversionFactor");
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(null, pstmt, rs);
		}
		return distanceUnitName;
	}

	public JSONArray getVehicleListWithId(int systemid, int clientid, int userId) {
		JSONArray jsonArray = new JSONArray();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String stmt = "";
		try {
			con = DBConnection.getConnectionToDB("AMS");
			stmt = TripBasedReportStatements.GET_VEHICLE_USING_CLIENTID_VEHICLE_ID;
			pstmt = con.prepareStatement(stmt);
			pstmt.setInt(1, clientid);
			pstmt.setInt(2, systemid);
			pstmt.setInt(3, userId);
			rs = pstmt.executeQuery();
			JSONObject jsonObject = null;
			while (rs.next()) {
				jsonObject = new JSONObject();
				if (rs.getString("VehicleAlias") != null && !rs.getString("VehicleAlias").equals("")) {
					jsonObject.put("VehicleName", rs.getString("REGISTRATION_NUMBER") + "(" + rs.getString("VehicleAlias") + ")");
				} else {
					jsonObject.put("VehicleName", rs.getString("REGISTRATION_NUMBER"));
				}
				jsonObject.put("VehicleId", rs.getString("REGISTRATION_NUMBER"));
				jsonArray.put(jsonObject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jsonArray;
	}

	public String ConvertLOCALtoGMT(String dateFormatOldInLOCAL, int offset) {
		String newDateFormattedInGMT = "";
		try {

			if (dateFormatOldInLOCAL.contains("T")) {
				dateFormatOldInLOCAL = dateFormatOldInLOCAL.substring(0, dateFormatOldInLOCAL.indexOf("T")) + " "
						+ dateFormatOldInLOCAL.substring(dateFormatOldInLOCAL.indexOf("T") + 1, dateFormatOldInLOCAL.length());
				dateFormatOldInLOCAL = getFormattedDateStartingFromMonth(dateFormatOldInLOCAL);
				newDateFormattedInGMT = getLocalDateTime(dateFormatOldInLOCAL, offset);
			}

			else {
				dateFormatOldInLOCAL = getFormattedDateStartingFromMonth(dateFormatOldInLOCAL);
				newDateFormattedInGMT = getLocalDateTime(dateFormatOldInLOCAL, offset);
			}

		} catch (Exception e) {
			e.printStackTrace();
		}
		return newDateFormattedInGMT;
	}

	public String getFormattedDateStartingFromMonth(String inputDate) {
		String formattedDate = "";
		SimpleDateFormat sdfFormatDate = new SimpleDateFormat("MM/dd/yyyy HH:mm:ss");
		SimpleDateFormat sdfFormatDate1 = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
		try {
			if (inputDate != null && !inputDate.equals("")) {
				java.util.Date d = sdfFormatDate1.parse(inputDate);
				formattedDate = sdfFormatDate.format(d);
			}
		} catch (Exception e) {
			System.out.println("Error in getFormattedDateStartingFromMonth() method" + e);
			e.printStackTrace();
		}
		return formattedDate;
	}

	public String getLocalDateTime(String inputDate, int offSet) {
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
			String month = String.valueOf(m > 9 ? String.valueOf(m) : "0" + String.valueOf(m));
			String date = String.valueOf(day > 9 ? String.valueOf(day) : "0" + String.valueOf(day));
			String hour = String.valueOf(h > 9 ? String.valueOf(h) : "0" + String.valueOf(h));
			String minute = String.valueOf(mi > 9 ? String.valueOf(mi) : "0" + String.valueOf(mi));
			String second = String.valueOf(s > 9 ? String.valueOf(s) : "0" + String.valueOf(s));

			retValue = month + "/" + date + "/" + yyyy + " " + hour + ":" + minute + ":" + second;
		}
		return retValue;
	}

	public Date convertStringToDate(String inputDate) {
		Date dDateTime = null;
		SimpleDateFormat sdfFormatDate = new SimpleDateFormat("MM/dd/yyyy HH:mm:ss");
		try {
			if (inputDate != null && !inputDate.equals("")) {
				dDateTime = sdfFormatDate.parse(inputDate);
				java.sql.Timestamp timest = new java.sql.Timestamp(dDateTime.getTime());
				dDateTime = timest;
			}
		} catch (Exception e) {
			System.out.println("Error in convertStringToDate method" + e);
			e.printStackTrace();
		}
		return dDateTime;
	}

	public Vector getStopReport(Date startDateTime, Date endDateTime, String regno, String clientName, String systemId, int offset, HttpSession session) {
		String StartDate = "Start Date";
		String Location = "Location";
		String EndDate = "End Date";
		String Duration = "Duration(DD:HH:MM)";

		JSONArray list2 = new JSONArray();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		ReportHelper finalReportHelper = new ReportHelper();
		ArrayList reportsList = new ArrayList();
		Vector vector = new Vector();
		ArrayList headersList = new ArrayList();

		String localdate1 = "";
		String localdate2 = "";
		String loc = "";
		String TotalHrs1 = "";
		Double latitude = null;
		Double longitude = null;
		LinkedList<DataListBean> activityReportList = new LinkedList<DataListBean>();
		SimpleDateFormat sdfDDmmyyyy = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
		try {

			con = DBConnection.getConnectionToDB("AMS");

			VehicleActivity vi = new VehicleActivity(con, regno, startDateTime, endDateTime, offset, Integer.parseInt(systemId), Integer.parseInt(clientName), 0);
			activityReportList = vi.getFinalList();
			int k = 0;
			ArrayList informationList = new ArrayList();
			for (int i = 0; i < activityReportList.size(); i++) {

				DataListBean dlbcur = activityReportList.get(i);
				DataListBean dlbnext = null;
				if (i + 1 < activityReportList.size()) {
					dlbnext = activityReportList.get(i + 1);
				}

				String cat = dlbcur.getCategory();
				if (cat.equals("STOPPAGE")) {
					if (i == activityReportList.size() - 1) {
						DataListBean dlbprev = activityReportList.get(i - 1);
						String cat1 = dlbprev.getCategory();
						if (cat1.equals("STOPPAGE")) {
							break;
						}
					}
					k++;
					informationList = new ArrayList();
					JSONObject obj1 = new JSONObject();
					obj1.put("slno", k);
					informationList.add(String.valueOf(k));

					Date dd = dlbcur.getGmtDateTime();
					localdate1 = sdfDDmmyyyy.format(getLocalDateTime(dd, offset));
					localdate1 = localdate1.substring(0, 19);
					loc = dlbcur.getLocation();
					latitude = dlbcur.getLatitude();
					longitude = dlbcur.getLongitude();
					long ms = dlbcur.getStopTime();

					TotalHrs1 = formattedDaysHoursMinutes(ms);
					String TotalHrs1NEW = formattedDaysHoursMinutesNEW(ms);

					if (dlbnext == null) {
						localdate2 = "";
					} else {
						Date dd1 = dlbnext.getGmtDateTime();
						localdate2 = sdfDDmmyyyy.format(getLocalDateTime(dd1, offset));
						localdate2 = localdate2.substring(0, 19);
					}
					obj1.put("location", loc);
					informationList.add(loc);

					obj1.put("startdate", localdate1);
					informationList.add(localdate1);

					obj1.put("enddate", localdate2);
					informationList.add(localdate2);

					obj1.put("duration", TotalHrs1);
					informationList.add(TotalHrs1);
					obj1.put("durationNEW", TotalHrs1NEW);
					informationList.add(TotalHrs1NEW);

					obj1.put("latitude", latitude);
					informationList.add(latitude);

					obj1.put("longitude", longitude);
					informationList.add(longitude);

					list2.put(obj1);
					ReportHelper reporthelper = new ReportHelper();
					reporthelper.setInformationList(informationList);
					reportsList.add(reporthelper);
					if (k >= 5000) {
						break;
					}
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
			System.out.println("Error .." + e);
		} finally {
			finalReportHelper.setReportsList(reportsList);
			headersList.add("SLNo");
			headersList.add(Location);
			headersList.add(StartDate);
			headersList.add(EndDate);
			headersList.add(Duration);
			headersList.add("DurationNEw (DD:HH:MM)");
			headersList.add("Longitude");
			headersList.add("Longitude");
			finalReportHelper.setHeadersList(headersList);
			vector.add(list2);
			vector.add(finalReportHelper);

			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return vector;
	}

   public String formattedDaysHoursMinutes(long fromDateMillisec) {
		String formateddaysHoursMinutes = "";
		try {
			long d = fromDateMillisec;
			long dD = d / (24 * 60 * 60 * 1000);
			long hours = (d % (24 * 60 * 60 * 1000)) / (60 * 60 * 1000);
			long minutes = ((d % (24 * 60 * 60 * 1000)) % (60 * 60 * 1000)) / (60 * 1000);
			String min = String.valueOf(minutes);
			String hr = String.valueOf(hours);
			String dd = String.valueOf(dD);
			if (String.valueOf(minutes).length() == 1) {
				min = "0" + minutes;
			}
			if (String.valueOf(hours).length() == 1) {
				hr = "0" + hours;
			}
			if (String.valueOf(dD).length() == 1) {
				dd = "0" + dD;
			}
			formateddaysHoursMinutes = dd + ":" + hr + ":" + min;

		} catch (Exception e) {
			e.printStackTrace();
		}
		return formateddaysHoursMinutes;
	}

	public Date getLocalDateTime(Date dateTimeGMT, int offset) {
		Calendar cal = Calendar.getInstance();
		cal.setTime(dateTimeGMT);
		cal.add(Calendar.MINUTE, offset);
		return cal.getTime();
	}

	private String formattedDaysHoursMinutesNEW(long ms) {
		String formateddaysHoursMinutes = "";
		try {
			long d = ms;

			long dSeconds = d / 1000;
			long min = 0;
			long hrs = 0;
			long days = 0;
			if (dSeconds >= 60) {
				min = dSeconds / 60;
				dSeconds = dSeconds % 60;
			}
			if (min >= 60) {
				hrs = min / 60;
				min = min % 60;
			}
			if (hrs >= 24) {
				days = hrs / 24;
				hrs = hrs % 24;
			}
			formateddaysHoursMinutes = days + ":" + hrs + ":" + min + ":" + dSeconds;
		} catch (Exception e) {
			e.printStackTrace();
		}
		return formateddaysHoursMinutes;
	}
	public JSONArray getTripNames(int systemid, int clientid,int offset, String startDate, String endDate1) 
 {
		JSONArray jsonArray = new JSONArray();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String stmt = "";
		SimpleDateFormat sdfDB = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		SimpleDateFormat ddmmyyyy = new SimpleDateFormat("dd/MM/yyyy");
		SimpleDateFormat sdf1 = new SimpleDateFormat("MM/dd/yyyy HH:mm:ss");
		try {
			con = DBConnection.getConnectionToDB("AMS");
			stmt = TripBasedReportStatements.GET_TRIP_NAME;
			pstmt = con.prepareStatement(stmt);
			pstmt.setInt(1, offset);
			pstmt.setInt(2, offset);
			pstmt.setInt(3, offset);
			pstmt.setInt(4, offset);
			pstmt.setInt(5, systemid);
			pstmt.setInt(6, clientid);
			pstmt.setInt(7, offset);
			pstmt.setString(8, sdfDB.format(ddmmyyyy.parse(startDate)));
			pstmt.setInt(9, offset);
			pstmt.setString(10, sdfDB.format(ddmmyyyy.parse(endDate1)));
			
			rs = pstmt.executeQuery();
			JSONObject obj1 = new JSONObject();
			while (rs.next()) {
				obj1 = new JSONObject();
				String STD = "";
				String endDate = "";
				if (!rs.getString("STD").contains("1900")) {
					STD = sdf1.format(sdfDB.parse(rs.getString("STD")));
				}
				if (!rs.getString("END_DATE").contains("1900")) {
					endDate = sdf1.format(sdfDB.parse(rs.getString("END_DATE")));
				}
				obj1.put("tripId", rs.getString("TRIP_ID"));
				obj1.put("tripName", rs.getString("TRIP_NAME") + "-" + rs.getString("ASSET_NUMBER"));
				obj1.put("assetNo", rs.getString("ASSET_NUMBER"));
				obj1.put("VehicleId", rs.getString("ASSET_NUMBER"));
				obj1.put("startDate", STD);
				obj1.put("endDate", endDate);
				obj1.put("vehicleType", rs.getString("MAKE"));
				jsonArray.put(obj1);
			}

		} catch (Exception e) {
			System.out.println("Error While Getting trip Names.");
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jsonArray;
	}

	public boolean CheckImpreciseSetting(int userId, int systemId) {
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		PreparedStatement pstmt2 = null;
		ResultSet rs2 = null;
		boolean isimprecise = false;
		boolean locset = false;
		Connection con = null;
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(TripBasedReportStatements.CHECK_SYSTEM_MASTER_FOR_PRECISE_SETTING);
			pstmt.setInt(1, systemId);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				if (rs.getString("Location_Setting").equals("1")) {
					locset = true;
				} else {
					locset = false;
				}
				if (locset == true) {

					pstmt2 = con.prepareStatement(TripBasedReportStatements.CHECK_USERS_FOR_PRECISE_SETTING);
					pstmt2.setInt(1, systemId);
					pstmt2.setInt(2, userId);
					rs2 = pstmt2.executeQuery();
					if (rs2.next()) {
						if (rs2.getString("Location_Setting").equals("1")) {
							isimprecise = true;
						} else {
							isimprecise = false;
						}
					}
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(null, pstmt2, rs2);
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return isimprecise;
	}

	public JSONArray getActivityReport(String startDateTime, String endDateTime, String regno, int clientId, int systemId, int offset, int userId,String category) {

		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		ArrayList reportsList = new ArrayList();

		SimpleDateFormat sdfFormatDate = new SimpleDateFormat("MM/dd/yyyy HH:mm:ss");
		JSONArray jsonArray = new JSONArray();
		boolean impreciseSetting = false;
		impreciseSetting = CheckImpreciseSetting(userId, systemId);
		int timeBandInt = 0;
		timeBandInt = timeBandInt * 60 * 1000;
		try {
			con = DBConnection.getConnectionToDB("AMS");
			double ConversionFactor = 0;
			ConversionFactor = initializedistanceConversionFactorofVehicle(systemId, con, "");
			startDateTime = getFormattedDateStartingFromMonth(startDateTime);
			endDateTime = getFormattedDateStartingFromMonth(endDateTime);

			startDateTime = getLocalDateTime(startDateTime, offset);
			endDateTime = getLocalDateTime(endDateTime, offset);

			if (regno != null && startDateTime != null && endDateTime != null) {

				LinkedList<DataListBean> activityReportList = new LinkedList<DataListBean>();
				VehicleActivity vi = null;
				if (impreciseSetting == true) {
					System.out.println(" imprecise true!!!!!!!!!!!");
					vi = new VehicleActivity(con, regno, sdfFormatDate.parse(startDateTime), sdfFormatDate.parse(endDateTime), offset, systemId, clientId, timeBandInt, userId);
				} else {
					vi = new VehicleActivity(con, regno, sdfFormatDate.parse(startDateTime), sdfFormatDate.parse(endDateTime), offset, systemId, clientId, timeBandInt);
				}
				activityReportList = vi.getFinalList();
				try {
					jsonArray = new JSONArray();

					for (int i = 0; i < activityReportList.size(); i++) {
						String stopstr = "0";
						String idlestr = "0";
						String DisTrav = "0";
						String speeddetails = "0";
						long stoptime = 0;
						long idletime = 0;
						DataListBean dlb = activityReportList.get(i);
						
						String Cat = dlb.getCategory();
						if((!category.equalsIgnoreCase("All")) && (!category.equalsIgnoreCase(Cat))){
							continue;
						}
						

						JSONObject obj = new JSONObject();
						ArrayList informationList = new ArrayList();
						ReportHelper reporthelper = new ReportHelper();
						
						informationList.add(i + 1);
						obj.put("slno", i + 1);
						obj.put("dateTimeDataIndex", sdf.format(dlb.getGpsDateTime()));
						//obj.put("locationDataIndex", dlb.getLocation().toString());
						obj.put("locationDataIndex", dlb.getLocation() == null ? "" : dlb.getLocation().toString());
						speeddetails = df.format(dlb.getSpeed() * ConversionFactor);
						obj.put("speedDataIndex", speeddetails);
						obj.put("latitudeIndex", dlb.getLatitude());
						obj.put("longitudeIndex", dlb.getLongitude());
						

						try {
							stoptime = dlb.getStopTime();
							stoptime = stoptime / (60 * 1000);
							stopstr = HrsMinsFormat(stoptime);
							obj.put("stoppageTimeDataIndex", stopstr);
						} catch (Exception e) {
							stopstr = "0";
							obj.put("stoppageTimeDataIndex", stopstr);
						}

						try {
							idletime = dlb.getIdleTime();
							idletime = idletime / (60 * 1000);
							idlestr = HrsMinsFormat(idletime);
							obj.put("idleTimeDataIndex", idlestr);
						} catch (Exception e) {
							idlestr = "0";
							obj.put("idleTimeDataIndex", idlestr);
						}

						
						obj.put("categoryDataIndex", Cat);

						try {
							DisTrav = df.format(dlb.getDistanceTravelled() * ConversionFactor);
							obj.put("distanceTravelledDataIndex", DisTrav);
						} catch (Exception e) {
							DisTrav = "0";
							obj.put("distanceTravelledDataIndex", DisTrav);
						}
						obj.put("cumuOdoDataIndex", df.format(dlb.getCumuOdometer() * ConversionFactor));
						jsonArray.put(obj);
						reportsList.add(reporthelper);

					}

				} catch (Exception e) {
					e.printStackTrace();
					System.out.println("Error .." + e);
				} finally {
					DBConnection.releaseConnectionToDB(con, pstmt, rs);
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return jsonArray;
	}
		public double initializedistanceConversionFactorofVehicle(int SystemId,Connection con, String registrationNo) {
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			String distanceUnitName;
			double distanceConversionFactor;
			distanceConversionFactor = 1.0;
			distanceUnitName = "kms";
			try {
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
				DBConnection.releaseConnectionToDB(null, pstmt, rs);
			}
			
			return distanceConversionFactor;
		}
		public String initializeDistanceUnitName(int SystemId, Connection con,String registrationNo) {
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			String distanceUnitName;
			double distanceConversionFactor;
			distanceConversionFactor = 1.0;
			distanceUnitName = "kms";
			try {
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
				DBConnection.releaseConnectionToDB(null, pstmt, rs);
			}
			return distanceUnitName;
		}
		String HrsMinsFormat(long stopIdleMinute) {
			String stopDura = "0.0";
			String minstr = "0";
			try {
				if (stopIdleMinute > 0) {
					long hour = stopIdleMinute / 60;
					long min = stopIdleMinute % 60;

					if (min < 10) {
						minstr = "0" + min;
					} else {
						minstr = String.valueOf(min);
					}
					stopDura = String.valueOf(hour) + "." + minstr;
				}
			} catch (Exception e) {
				System.out.println("Exception in daysHrsMinsFormat(): " + e);
			}
			return stopDura;
		}

		public ArrayList getTripStartEndTime(String tripId, String regNo,
			int systemId, int offset) {
		ArrayList aList = new ArrayList();
	
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm");
		try {
			
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(TripBasedReportStatements.GET_TRIP_START_END_DATE);
			pstmt.setString(1, tripId);
			pstmt.setString(2, regNo);
			pstmt.setInt(3, systemId);
			pstmt.setString(4, tripId);
			pstmt.setString(5, regNo);
			pstmt.setInt(6, systemId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				/*
				 * trip dates are GMT, conver them to GPS date time, as activity
				 * report will use
				 */

				Date stDate = rs.getTimestamp("StartDate");
				String startDate = sdf.format(getGPSDateTime(stDate, offset));
				// System.out.println("trip start gmt : " + sdf.format(stDate));

				Date curGMT = new Date();
				String sCurGMT = curGMT.toGMTString();
				SimpleDateFormat sdf1 = new SimpleDateFormat(
						"dd MMM yyyy HH:mm:ss ");
				curGMT = sdf1.parse(sCurGMT);
				String endDate = sdf.format(getGPSDateTime(curGMT, offset));
				if (rs.getTimestamp("EndDate") != null) {
					Date enDate = rs.getTimestamp("EndDate");
					endDate = sdf.format(getGPSDateTime(enDate, offset));
				}
				/* start date */
				int idx = startDate.indexOf(" ");
				aList.add(startDate.substring(0, idx));
				/* start time */
				aList.add(startDate.substring(idx + 1));
				/* end date */
				aList.add(endDate.substring(0, idx));
				/* end time */
				aList.add(endDate.substring(idx + 1));
			}
			// System.out.println("aList : + " + aList);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return aList;
	}

	public Date getGPSDateTime(Date gmtDateTime, int offset) {
		Calendar cal = Calendar.getInstance();
		cal.setTime(gmtDateTime);
		cal.add(Calendar.MINUTE, offset);
		return cal.getTime();
	}

	public ArrayList getTripList(String regNo, int systemId) {
		ArrayList finalList = new ArrayList();
		ArrayList tempList = new ArrayList();
		
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(TripBasedReportStatements.SELECT_ALL_TRIP_VEHICLE);
			pstmt.setString(1, regNo);
			pstmt.setInt(2, systemId);
			pstmt.setString(3, regNo);
			pstmt.setInt(4, systemId);
			rs = pstmt.executeQuery();
			tempList.add(0);
			tempList.add("Select Trip Name");
			finalList.add(tempList);
			while (rs.next()) {
				tempList = new ArrayList();
				tempList.add(rs.getString("Trip_Allocation_id"));

				Date startDate = rs.getDate("StartDate");

				Calendar cal = Calendar.getInstance();
				cal.setTime(startDate);
				int monthDay = cal.get(Calendar.DAY_OF_MONTH);
				String formatedDate = DateFormat.getDateTimeInstance().format(
						startDate);
				int idx = monthDay > 9 ? 6 : 5;
				tempList.add(rs.getString("Trip_Name") + " / "
						+ formatedDate.substring(0, idx));
				finalList.add(tempList);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return finalList;
		}

	public double getApproxMileage(String vehicleNumber, int systemId) {
		double fuel = 0.00;
		
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
		
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement("select Approx_Mileage_With_Load from tblVehicleMaster where  VehicleNo = ? and System_id=? ");
			pstmt.setString(1, vehicleNumber);
			pstmt.setInt(2, systemId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				fuel = rs.getDouble("Approx_Mileage_With_Load");
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return fuel;
	}
	
	public JSONArray getSmartHubDetails(int systemId, int clientId) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		JSONArray jsonArr = new JSONArray();
		JSONObject jsonObj = null;
		
		try{
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement("select NAME as hubName,convert(varchar,HUBID) as hubId from AMS.dbo.LOCATION_ZONE_A(nolock) where SYSTEMID=? and CLIENTID=? and OPERATION_ID=33 and NAME like 'SH_%' ");
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, clientId);
			rs = pstmt.executeQuery();
			while(rs.next()){
				jsonObj = new JSONObject();
				jsonObj.put("smartHubId",rs.getString("hubId"));
				jsonObj.put("smartHubName",rs.getString("hubName"));
				jsonArr.put(jsonObj);
			}
			
		}catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		
		return jsonArr;
	}

	public JSONArray getHubVehicleDetailsForReport(String startDate, String endDate,int offset,String hubId, int systemId) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		JSONArray jsonArr = new JSONArray();
		JSONObject jsonObj = null;
		String vehclSeg = "";
		String stoppageHM = "";
		String status = "";
		String agening= "";
		try{
			String newHubIdList = (hubId.substring(0, hubId.length() - 1));
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(TripBasedReportStatements.GET_HUB_VEHICLE_DETAILS.replace("$", ("AND hb.HUB_ID IN ("+ newHubIdList +")")));
			pstmt.setInt(1, offset);
			pstmt.setInt(2, offset);
			pstmt.setInt(3, offset);
			pstmt.setInt(4, systemId);
			//pstmt.setString(5, endDate);
			pstmt.setString(5, startDate);
			pstmt.setString(6, endDate);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				if (!rs.getString("HUB ARRIVAL DATETIME").equals(rs.getString("HUB DEPARTURE DATETIME"))) {
					if (rs.getString("STOPPAGE TIME") != null) {
						stoppageHM = cf.convertMinutesToHHMMFormat(Integer.parseInt(rs.getString("STOPPAGE TIME")));
					} else {
						stoppageHM = "00:00";
					}
					status = rs.getString("STATUS");
					jsonObj = new JSONObject();
					jsonObj.put("hubName", rs.getString("HUB NAME"));
					if (status.equals("OPEN")) {
						jsonObj.put("tripId", rs.getString("TRIP ID"));
						jsonObj.put("customerName", rs.getString("CUSTOMER NAME"));
					} else {
						jsonObj.put("tripId", "");
						jsonObj.put("customerName", "");
					}
					jsonObj.put("vehicleNo", rs.getString("VEHICLE NO"));
					jsonObj.put("vehicleType", rs.getString("VEHICLE TYPE"));
					if (rs.getString("VEHICLE TYPE").contains("DC")) {
						vehclSeg = "Dry";
					} else {
						vehclSeg = "TCL";
					}
					jsonObj.put("currentODO", rs.getString("CURRENT ODO"));
					jsonObj.put("vehicleSeg", vehclSeg);
					jsonObj.put("lastCommDtm", sdf1.format(sdfDB.parse(rs.getString("LAST COMMUNICATION DATETIME"))));
					jsonObj.put("hubArivDatm", sdf1.format(sdfDB.parse(rs.getString("HUB ARRIVAL DATETIME"))));
					if (rs.getString("HUB DEPARTURE DATETIME") != null) {
						jsonObj.put("hubDeparDatm", sdf1.format(sdfDB.parse(rs.getString("HUB DEPARTURE DATETIME"))));
					} else {
						jsonObj.put("hubDeparDatm", "NA");
					}
					jsonObj.put("stpgTme", stoppageHM);
					if (!status.equals("OPEN") && !stoppageHM.equals("00:00")) {
						String hhmm[] = stoppageHM.split(":");
						int day = (Integer.parseInt(hhmm[0]) * 60 + Integer.parseInt(hhmm[1])) / 1440;
						agening = checkingDayCase(day);
					} else {
						agening = "NA";
					}
					jsonObj.put("agening", agening);
					jsonArr.put(jsonObj);
				}
			}
		}catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		
		
		return jsonArr;
	}

	private String checkingDayCase(int day) {
		String result="";
		switch(day){
		case 0: result="0 - 1 Day";
			break;
		case 1: result="1 - 2 Day";
			break;
		case 2: result="2 - 3 Day";
			break;
		case 3: result="3 - 4 Day";
			break;
		case 4: result="4 - 5 Day";
			break;
		case 5: result="5 - 6 Day";
			break;
		case 6: result="6 - 7 Day";
			break;
		case 7: result="1 Week";
		    break;
		case 8: result="More than 1 Week";
			break;
		default : result = "NA";
		}
		return result;
	}
	
	public JSONArray getUnRegisterdVehicles(Integer systemid, Integer clientid) {
		JSONArray jsonArray = new JSONArray();
		JSONObject obj1 = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(TripBasedReportStatements.GET_UNREGISTRED_VEHICLES);
			pstmt.setInt(1, systemid);
			pstmt.setInt(2, clientid);

			rs = pstmt.executeQuery();
			while (rs.next()) {
				obj1 = new JSONObject();
				obj1.put("vehicleNo", rs.getString("REGISTRATION_NUMBER"));
				jsonArray.put(obj1);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jsonArray;
	}
}
