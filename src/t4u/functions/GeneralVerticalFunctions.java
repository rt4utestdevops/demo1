package t4u.functions;

import java.io.File;
import java.io.FileOutputStream;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Calendar;
import java.util.Collections;
import java.util.Comparator;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.LinkedHashSet;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.Properties;
import java.util.Set;

import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFFont;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.hssf.util.Region;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.DataFormat;
import org.apache.poi.ss.usermodel.Font;
import org.apache.poi.ss.usermodel.IndexedColors;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import t4u.GeneralVertical.CommonUtil;
import t4u.GeneralVertical.LegDetailsBean;
import t4u.GeneralVertical.LegInfoBean;
import t4u.GeneralVertical.TemperatureBean;
import t4u.common.ApplicationListener;
import t4u.common.DBConnection;
import t4u.common.LocationLocalization;
import t4u.statements.AdminStatements;
import t4u.statements.CommonStatements;
import t4u.statements.CreateTripStatement;
import t4u.statements.GeneralVerticalStatements;
import t4u.statements.MapViewStatements;
import t4u.util.TemperatureConfiguration;

import com.google.gson.internal.LinkedTreeMap;
import com.mongodb.BasicDBList;
import com.mongodb.BasicDBObject;
import com.mongodb.DBCollection;
import com.mongodb.DBCursor;
import com.mongodb.DBObject;
import com.mongodb.MongoClient;

@SuppressWarnings("deprecation")
public class GeneralVerticalFunctions {
	SimpleDateFormat sdfDB = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
	SimpleDateFormat sdf1 = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
	SimpleDateFormat sdfDBMMDD = new SimpleDateFormat("yyyy-MM-dd");
	SimpleDateFormat mmddyyy = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
	SimpleDateFormat timef = new SimpleDateFormat("HH:mm");
	SimpleDateFormat timenew = new SimpleDateFormat("HH:mm:ss");
	DecimalFormat df = new DecimalFormat("00.00");
	DecimalFormat df1 = new DecimalFormat("#.##");
	DecimalFormat df2 = new DecimalFormat("0.00");
	DecimalFormat df3 = new DecimalFormat("00");
	CommonFunctions cf = new CommonFunctions();
	public static Object lock = new Object();
	AdminFunctions adFunc = new AdminFunctions();
	SimpleDateFormat ddmmyyyy = new SimpleDateFormat("dd/MM/yyyy");

	enum sName {
		ONEWIRE1, ONEWIRE2, ONEWIRE3
	}
	
	public JSONArray getTripSummaryDetails(int systemId, int clientId, int offset, String groupId, String unit, int userId) {
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonobject = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int count = 0;
		String plannedDate = "";
		String actualDate = "";
		String condition = "";
		double distance = 0;
		String endDate = "";
		try {
			jsonArray = new JSONArray();
			con = DBConnection.getConnectionToDB("AMS");
			if (groupId.equals("0")) {
				condition = "and td.STATUS='OPEN' and td.TRIP_STATUS <> 'NEW'";
			} else if (groupId.equals("1")) {
				condition = "and td.TRIP_START_TIME between dateadd(dd,-2,getutcdate()) and getutcdate()";
			} else if (groupId.equals("2")) {
				condition = "and td.TRIP_START_TIME between dateadd(dd,-7,getutcdate()) and getutcdate()";
			} else if (groupId.equals("3")) {
				condition = "and td.TRIP_START_TIME between dateadd(dd,-15,getutcdate()) and getutcdate()";
			} else if (groupId.equals("4")) {
				condition = "and td.TRIP_START_TIME between dateadd(dd,-30,getutcdate()) and getutcdate()";
			}

			pstmt = con.prepareStatement(GeneralVerticalStatements.GET_TRIP_SUMMARY_DETAILS.replace("#", condition));
			pstmt.setInt(1, offset);
			pstmt.setInt(2, offset);
			pstmt.setInt(3, offset);
			pstmt.setInt(4, offset);
			pstmt.setInt(5, offset);
			pstmt.setInt(6, offset);
			pstmt.setInt(7, userId);
			pstmt.setInt(8, systemId);
			pstmt.setInt(9, clientId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				plannedDate = "";
				actualDate = "";
				endDate = "";
				count++;
				jsonobject = new JSONObject();
				jsonobject.put("slNo", count);
				jsonobject.put("tripNo", rs.getString("tripId"));
				jsonobject.put("tripName", rs.getString("tripName"));
				jsonobject.put("vehicleNo", rs.getString("vehicleNo"));
				jsonobject.put("routeName", rs.getString("routeName"));
				jsonobject.put("startLocation", rs.getString("ORIGIN"));
				jsonobject.put("destination", rs.getString("DESTINATION"));
				if (rs.getInt("DELAY") < 0) {
					jsonobject.put("delayed", 0);
				} else {
					jsonobject.put("delayed", rs.getString("DELAY"));
				}
				jsonobject.put("nextHub", rs.getString("NEAREST_HUB"));
				String etha = "";
				if (!rs.getString("ETHA").contains("1900")) {
					etha = sdf.format(sdfDB.parse(rs.getString("ETHA")));
				}
				String eta = "";
				if (!rs.getString("ETA").contains("1900")) {
					eta = sdf.format(sdfDB.parse(rs.getString("ETA")));
				}
				jsonobject.put("etaNextHub", etha);
				jsonobject.put("etaToDestination", eta);
				jsonobject.put("currentLocation", rs.getString("currentLocation"));
				if (!rs.getString("plannedDate").contains("1900")) {
					plannedDate = sdf.format(sdfDB.parse(rs.getString("plannedDate")));
				}
				if (!rs.getString("actualDate").contains("1900")) {
					actualDate = sdf.format(sdfDB.parse(rs.getString("actualDate")));
				}
				jsonobject.put("plannedDate", plannedDate);
				jsonobject.put("actualDate", actualDate);
				distance = rs.getDouble("actualDuration");
				if (unit.equals("Miles")) {
					distance = rs.getDouble("actualDuration") * 0.621371;
				}
				jsonobject.put("distanceTravelled", df.format(distance));
				jsonobject.put("events", rs.getInt("eventsCount"));
				jsonobject.put("status", rs.getString("status"));
				if (!rs.getString("endDate").contains("1900")) {
					endDate = sdf.format(sdfDB.parse(rs.getString("endDate")));
				}
				jsonobject.put("endDateHidden", endDate);
				jsonArray.put(jsonobject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jsonArray;
	}

	public JSONArray getVehicleCount(int systemId, int clientId, int userId) {
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonobject = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int onTrip = 0;
		int assigned = 0;
		int totalVehicle = 0;
		try {
			jsonArray = new JSONArray();
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(GeneralVerticalStatements.VEHICLE_COUNT);
			pstmt.setInt(1, userId);
			pstmt.setInt(2, systemId);
			pstmt.setInt(3, clientId);
			pstmt.setInt(4, userId);
			pstmt.setInt(5, systemId);
			pstmt.setInt(6, clientId);
			pstmt.setInt(7, userId);
			pstmt.setInt(8, systemId);
			pstmt.setInt(9, clientId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				jsonobject = new JSONObject();
				if (rs.getString("type").equals("On Trip")) {
					onTrip = rs.getInt("vehicleCount");
				} else if (rs.getString("type").equals("Assigned")) {
					assigned = rs.getInt("vehicleCount");
				} else {
					totalVehicle = rs.getInt("vehicleCount");
				}
			}

			pstmt = con.prepareStatement(GeneralVerticalStatements.GET_COUNTS_FOR_DASHBOARD);
			pstmt.setInt(1, userId);
			pstmt.setInt(2, systemId);
			pstmt.setInt(3, clientId);
			pstmt.setInt(4, userId);
			pstmt.setInt(5, systemId);
			pstmt.setInt(6, clientId);
			pstmt.setInt(7, userId);
			pstmt.setInt(8, systemId);
			pstmt.setInt(9, clientId);
			pstmt.setInt(10, userId);
			pstmt.setInt(11, systemId);
			pstmt.setInt(12, clientId);
			rs = pstmt.executeQuery();
			int ontime = 0;
			int delayed = 0;
			int loading = 0;
			int unloading = 0;
			while (rs.next()) {
				jsonobject = new JSONObject();
				if (rs.getString("STATUS").equals("ONTIME")) {
					ontime = rs.getInt("COUNT");
				} else if (rs.getString("STATUS").equals("DELAYED")) {
					delayed = rs.getInt("COUNT");
				} else if (rs.getString("STATUS").equals("LOADING_DETENTION")) {
					loading = rs.getInt("COUNT");
				} else if (rs.getString("STATUS").equals("UNLOADING_DETENTION")) {
					unloading = rs.getInt("COUNT");
				}
			}

			jsonobject.put("onTrip", onTrip);
			jsonobject.put("assigned", assigned);
			jsonobject.put("total", totalVehicle);

			jsonobject.put("ontime", ontime);
			jsonobject.put("delayed", delayed);
			jsonobject.put("loading", loading);
			jsonobject.put("unloading", unloading);
			jsonArray.put(jsonobject);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jsonArray;
	}

	public JSONArray getCriticalEventCout(int clientId, int systemId, int userId) {
		JSONArray jsonArray = new JSONArray();
		JSONObject obj = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int mainPower = 0;
		int restrictive = 0;
		int panic = 0;
		int harshBrake = 0;
		int overspeed = 0;
		int engineError = 0;
		int stateOfChargeLessCount = 0;
		int acStatusCount = 0;
		int boostModeCount = 0;
		try {
			con = DBConnection.getConnectionToDB("AMS");

			// Query to get MainPower and Restrictive Hours Alert
			pstmt = con.prepareStatement(GeneralVerticalStatements.GET_MAIN_POWER_RESTRICTIVE_ALERT_COUNT);
			pstmt.setInt(1, userId);
			pstmt.setInt(2, systemId);
			pstmt.setInt(3, clientId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				if (rs.getInt("TYPE_OF_ALERT") == 7) {
					mainPower = rs.getInt("alertCount");
				} else if (rs.getInt("TYPE_OF_ALERT") == 45) {
					restrictive = rs.getInt("alertCount");
				}
			}
			pstmt.close();
			rs.close();
			// Query to get Panic Details
			pstmt = con.prepareStatement(GeneralVerticalStatements.GET_PANIC_ALERT_COUNT);
			pstmt.setInt(1, userId);
			pstmt.setInt(2, systemId);
			pstmt.setInt(3, clientId);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				panic = rs.getInt("alertCount");
			}
			pstmt.close();
			rs.close();
			// Query to get Harsh Alerts
			pstmt = con.prepareStatement(GeneralVerticalStatements.GET_HARSH_ALERT_COUNT);
			pstmt.setInt(1, userId);
			pstmt.setInt(2, systemId);
			pstmt.setInt(3, clientId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				harshBrake = rs.getInt("alertCount");
			}
			pstmt.close();
			rs.close();
			// Query to get OBD error codes
			pstmt = con.prepareStatement(GeneralVerticalStatements.GET_ENGINE_ERROR_CODE);
			pstmt.setInt(1, userId);
			pstmt.setInt(2, systemId);
			pstmt.setInt(3, clientId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				engineError = rs.getInt("alertCount");
			}

			// Query to get OBD error codes
			pstmt = con.prepareStatement(GeneralVerticalStatements.GET_OVERSPEED_ALERT);
			pstmt.setInt(1, userId);
			pstmt.setInt(2, systemId);
			pstmt.setInt(3, clientId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				overspeed = rs.getInt("alertCount");
			}

			// Query to get State of charge count
			pstmt = con.prepareStatement(GeneralVerticalStatements.GET_STATE_OF_CHARGE_COUNT);
			pstmt.setInt(1, userId);
			pstmt.setInt(2, systemId);
			pstmt.setInt(3, clientId);
			pstmt.setInt(4, userId);
			pstmt.setInt(5, systemId);
			pstmt.setInt(6, clientId);
			pstmt.setInt(7, userId);
			pstmt.setInt(8, systemId);
			pstmt.setInt(9, clientId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				if (rs.getString("STATUS").equals("SOC"))
					stateOfChargeLessCount = rs.getInt("COUNT");
				if (rs.getString("STATUS").equals("AC_COUNT"))
					acStatusCount = rs.getInt("COUNT");
				if (rs.getString("STATUS").equals("BOOST"))
					boostModeCount = rs.getInt("COUNT");
			}
			obj = new JSONObject();
			obj.put("mainPower", mainPower);
			obj.put("panic", panic);
			obj.put("harshBrake", harshBrake);
			obj.put("harshCurve", overspeed);
			obj.put("restrictive", restrictive);
			obj.put("engineError", engineError);
			obj.put("stateOfChargeLessCount", stateOfChargeLessCount);
			obj.put("acOnCount", acStatusCount);
			obj.put("boostCount", boostModeCount);
			jsonArray.put(obj);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jsonArray;
	}

	public JSONArray getTripEvenDetails(int clientId, int systemId, String tripNo, int offset) {
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonobject = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int count = 0;
		String dateTime = "";
		try {
			jsonArray = new JSONArray();
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(GeneralVerticalStatements.GET_TRIP_EVENT_DETAILS);
			pstmt.setInt(1, offset);
			pstmt.setInt(2, systemId);
			pstmt.setInt(3, clientId);
			pstmt.setString(4, tripNo);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				dateTime = "";
				count++;
				jsonobject = new JSONObject();
				jsonobject.put("slNoIndex", count);
				jsonobject.put("vehicleNoIndex", rs.getString("vehicleNo"));
				if (!rs.getString("dateTime").equals("")) {
					dateTime = sdf.format(sdfDB.parse(rs.getString("dateTime")));
				}
				jsonobject.put("dateTimeIndex", dateTime);
				jsonobject.put("locationIndex", rs.getString("location"));
				jsonobject.put("alertTypeIndex", rs.getString("alertName"));
				jsonArray.put(jsonobject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jsonArray;
	}

	public JSONArray getSummaryDetails(int clientId, int systemId, String tripNo, int offset, String alertId) {
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonobject = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int count = 0;
		String actualDate = "";
		String plannedDate = "";
		String location = "";
		double overspeed = 0;
		try {
			jsonArray = new JSONArray();
			con = DBConnection.getConnectionToDB("AMS");

			String unit = cf.getUnitOfMeasure(systemId);
			if (alertId.equals("-1")) {
				pstmt = con.prepareStatement(GeneralVerticalStatements.GET_SUMMARY_DETAILS.replace("#", "where t.alertId not in (2,7,3,45,58,174,0)"));
			} else if (alertId.equals("")) {
				pstmt = con.prepareStatement(GeneralVerticalStatements.GET_SUMMARY_DETAILS.replace("#", ""));
			} else {
				pstmt = con.prepareStatement(GeneralVerticalStatements.GET_SUMMARY_DETAILS.replace("#", "where t.alertId =" + alertId));
			}

			pstmt.setInt(1, offset);
			pstmt.setInt(2, offset);
			pstmt.setInt(3, offset);
			pstmt.setInt(4, offset);
			pstmt.setInt(5, systemId);
			pstmt.setInt(6, clientId);
			pstmt.setString(7, tripNo);
			pstmt.setInt(8, offset);
			pstmt.setInt(9, systemId);
			pstmt.setInt(10, clientId);
			pstmt.setString(11, tripNo);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				actualDate = "";
				plannedDate = "";
				location = "";
				overspeed = 0;
				count++;
				jsonobject = new JSONObject();
				jsonobject.put("slNoIndex", count);
				jsonobject.put("vehicleNoIndex", rs.getString("vehicleNo"));
				if (unit.equals("Miles")) {
					overspeed = rs.getDouble("speed") * 0.621371;
				} else {
					overspeed = rs.getDouble("speed");
				}
				if (rs.getInt("alertId") == 2) {
					location = df.format(overspeed) + " " + unit + "/Hr overspeed " + rs.getString("location");
				} else if (rs.getInt("alertId") == 1) {
					String stpphrs = rs.getString("stoppagetime");
					if (stpphrs.contains(".")) {
						stpphrs = df.format(rs.getDouble("stoppagetime"));
					}
					location = stpphrs.replace('.', ':') + "(HH:mm) stoppage, " + rs.getString("location");
				} else {
					location = rs.getString("location");
				}
				jsonobject.put("sourceIndex", location);
				if (!rs.getString("plannedDate").contains("1900")) {
					plannedDate = sdf.format(sdfDB.parse(rs.getString("plannedDate")));
				}
				jsonobject.put("plannedDateIndex", plannedDate);
				if (!rs.getString("occuredTime").contains("1900")) {
					actualDate = sdf.format(sdfDB.parse(rs.getString("occuredTime")));
				}
				jsonobject.put("actualDateIndex", actualDate);
				jsonobject.put("statusIndex", rs.getString("status"));
				jsonobject.put("alertIndex", rs.getString("alertName"));
				jsonobject.put("lat", rs.getString("lat"));
				jsonobject.put("lon", rs.getString("lon"));
				jsonobject.put("seq", rs.getString("sequence"));
				jsonobject.put("type", rs.getString("typename"));
				jsonobject.put("alertId", rs.getInt("alertId"));
				String exitDate = "";
				if (!rs.getString("occuredTime").contains("1900")) {
					exitDate = sdf.format(sdfDB.parse(rs.getString("VEHICLE_EXIT")));
				}
				jsonobject.put("vehicleExitTime", exitDate);

				jsonArray.put(jsonobject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jsonArray;
	}

	public JSONArray getCriticalEventsDetails(int clientId, int systemId, String alertId, int offset, int userId, String groupId) {
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonobject = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int count = 0;
		String dateTime = "";
		String stmt = "";
		try {
			jsonArray = new JSONArray();
			con = DBConnection.getConnectionToDB("AMS");

			if (groupId.equals("0")) {
				if (alertId.equals("7") || alertId.equals("45")) {
					stmt = GeneralVerticalStatements.GET_ALERT_DETAILS_FOR_DASHBOARD.replace("#", " and a.TYPE_OF_ALERT=" + alertId + " and a.GMT >= dateadd(dd,-1,getutcdate())");
				} else if (alertId.equals("3")) {
					stmt = GeneralVerticalStatements.GET_PANIC_ALERT_DETAILS_FOR_DASHBOARD.replace("#", " and a.TYPE_OF_ALERT=3 and a.GMT >= dateadd(dd,-1,getutcdate())");
				} else if (alertId.equals("58")) {
					stmt = GeneralVerticalStatements.GET_HARSH_ALERT_DETAILS_FOR_DASHBOARD.replace("#", " and a.TYPE_OF_ALERT=" + alertId + " and a.GMT >= dateadd(dd,-1,getutcdate()) ");
				} else if (alertId.equals("2")) {
					stmt = GeneralVerticalStatements.GET_BOOSTER_MODE_DETAILS;
				} else if (alertId.equals("soc")) {
					stmt = GeneralVerticalStatements.GET_STATE_OF_CHARGE_DETAILS;

				} else if (alertId.equals("acStatus")) {
					stmt = GeneralVerticalStatements.GET_AC_ON_STATUS_DETAILS;

				} else {
					stmt = GeneralVerticalStatements.GET_OBD_ALERT_DETAILS_FOR_DASHBOARD.replace("#", " and a.GMT >= dateadd(dd,-1,getutcdate())");
				}
			} else if (groupId.equals("1")) {
				if (alertId.equals("7") || alertId.equals("45")) {
					stmt = GeneralVerticalStatements.GET_ALERT_DETAILS_FOR_DASHBOARD.replace("#", " and a.TYPE_OF_ALERT=" + alertId + " and a.GMT >= dateadd(dd,-7,getutcdate())");
				} else if (alertId.equals("3") || alertId.equals("182")) {
					stmt = GeneralVerticalStatements.GET_PANIC_ALERT_DETAILS_FOR_DASHBOARD.replace("#", " and a.TYPE_OF_ALERT in(3,182) and a.GMT >= dateadd(dd,-7,getutcdate())");
				} else if (alertId.equals("58") || alertId.equals("106")) {
					stmt = GeneralVerticalStatements.GET_HARSH_ALERT_DETAILS_FOR_DASHBOARD.replace("#", " and a.TYPE_OF_ALERT=" + alertId + " and a.GMT >= dateadd(dd,-7,getutcdate())");
				} else {
					stmt = GeneralVerticalStatements.GET_OBD_ALERT_DETAILS_FOR_DASHBOARD.replace("#", " and a.GMT >= dateadd(dd,-7,getutcdate())");
				}
			} else if (groupId.equals("2")) {
				if (alertId.equals("7") || alertId.equals("45")) {
					stmt = GeneralVerticalStatements.GET_ALERT_DETAILS_FOR_DASHBOARD.replace("#", " and a.TYPE_OF_ALERT=" + alertId + " and a.GMT >= dateadd(dd,-15,getutcdate())");
				} else if (alertId.equals("3") || alertId.equals("182")) {
					stmt = GeneralVerticalStatements.GET_PANIC_ALERT_DETAILS_FOR_DASHBOARD.replace("#", " and a.TYPE_OF_ALERT in(3,182) and a.GMT >= dateadd(dd,-15,getutcdate())");
				} else if (alertId.equals("58") || alertId.equals("106")) {
					stmt = GeneralVerticalStatements.GET_HARSH_ALERT_DETAILS_FOR_DASHBOARD.replace("#", " and a.TYPE_OF_ALERT=" + alertId + " and a.GMT >= dateadd(dd,-15,getutcdate())");
				} else {
					stmt = GeneralVerticalStatements.GET_OBD_ALERT_DETAILS_FOR_DASHBOARD.replace("#", " and a.GMT >= dateadd(dd,-15,getutcdate())");
				}
			} else if (groupId.equals("3")) {
				if (alertId.equals("7") || alertId.equals("45")) {
					stmt = GeneralVerticalStatements.GET_ALERT_DETAILS_FOR_DASHBOARD.replace("#", " and a.TYPE_OF_ALERT=" + alertId + " and a.GMT >= dateadd(dd,-30,getutcdate())");
				} else if (alertId.equals("3") || alertId.equals("182")) {
					stmt = GeneralVerticalStatements.GET_PANIC_ALERT_DETAILS_FOR_DASHBOARD.replace("#", " and a.TYPE_OF_ALERT in(3,182) and a.GMT >= dateadd(dd,-30,getutcdate())");
				} else if (alertId.equals("58") || alertId.equals("106")) {
					stmt = GeneralVerticalStatements.GET_HARSH_ALERT_DETAILS_FOR_DASHBOARD.replace("#", " and a.TYPE_OF_ALERT=" + alertId + " and a.GMT >= dateadd(dd,-30,getutcdate())");
				} else {
					stmt = GeneralVerticalStatements.GET_OBD_ALERT_DETAILS_FOR_DASHBOARD.replace("#", " and a.GMT >= dateadd(dd,-30,getutcdate())");
				}
			}

			pstmt = con.prepareStatement(stmt);
			pstmt.setInt(1, offset);
			pstmt.setInt(2, userId);
			pstmt.setInt(3, systemId);
			pstmt.setInt(4, clientId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				dateTime = "";
				count++;
				jsonobject = new JSONObject();
				jsonobject.put("slNoIndex", count);
				jsonobject.put("vehicleNoIndex", rs.getString("registrationNo"));
				jsonobject.put("locationIndex", rs.getString("location"));
				if (!rs.getString("alretDate").contains("1900")) {
					dateTime = sdf.format(sdfDB.parse(rs.getString("alretDate")));
				}
				jsonobject.put("dateTimeIndex", dateTime);
				if (alertId.equals("soc")) {
					jsonobject.put("CommStatusIndex", rs.getString("COMM"));
				} else {
					jsonobject.put("CommStatusIndex", "");
				}
				jsonArray.put(jsonobject);
			}

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jsonArray;
	}

	public JSONArray getMapViewVehicles(int offset, int userId, int clientId, int systemId, int isLtsp, String lang, int nonCommHrs) {
		;
		boolean impreciseSetting = false;
		JSONArray VehicleDetailsArray = new JSONArray();
		JSONObject VehicleDetailsObject = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		CommonFunctions cf = new CommonFunctions();

		try {
			Properties properties = ApplicationListener.prop;
			String vehicleImagePath = properties.getProperty("vehicleImagePath");
			VehicleDetailsArray = new JSONArray();
			con = DBConnection.getConnectionToDB("AMS");

			impreciseSetting = cf.CheckImpreciseSetting(userId, systemId);

			if (isLtsp == 0 || clientId == 0) {
				pstmt = con.prepareStatement(MapViewStatements.GET_REGISTERED_VEHICLE_LIST_TYPE_FOR_CLIENT);
				pstmt.setInt(1, userId);
				pstmt.setInt(2, systemId);
				pstmt.setInt(3, systemId);
				pstmt.setInt(4, clientId);
			} else {
				pstmt = con.prepareStatement(MapViewStatements.SELECT_REGISTRATION_NO_FROM_USER_VEHICLE_TYPE_WITH_ACTIVE);
				pstmt.setInt(1, userId);
				pstmt.setInt(2, systemId);
				pstmt.setInt(3, systemId);
				pstmt.setInt(4, clientId);
			}
			rs = pstmt.executeQuery();
			StringBuffer sb = new StringBuffer();
			int a = 0;
			while (rs.next()) {
				String vehicleNo1 = rs.getString("VehicleNo");

				if (a == 0) {
					sb.append("'" + vehicleNo1 + "'");
					a = 1;
				} else {
					sb.append(",'" + vehicleNo1 + "'");
				}
			}
			String regList = sb.toString();
			if (regList.equals("")) {
				regList = "''";
			}
			if (isLtsp == 0 && clientId == 0) {
				if (impreciseSetting == true) {
					pstmt = con.prepareStatement(MapViewStatements.GET_LTSP_MAP_VIEW_DETAILS_NEW_FOR_IMPRECISE_LOCATION.concat(" order by a.REGISTRATION_NO "));
				} else {
					pstmt = con.prepareStatement(MapViewStatements.GET_LTSP_MAP_VIEW_DETAILS_NEW.concat(" order by a.REGISTRATION_NO "));
				}
				if (impreciseSetting == true) {
					pstmt = con.prepareStatement(MapViewStatements.GET_LTSP_MAP_VIEW_DETAILS_NEW_FOR_IMPRECISE_LOCATION.concat(" and DATEDIFF(hh,a.GMT,getutcdate()) >= " + nonCommHrs
							+ " and a.LOCATION !='No GPS Device Connected' order by a.REGISTRATION_NO "));
				} else {
					pstmt = con.prepareStatement(MapViewStatements.GET_LTSP_MAP_VIEW_DETAILS_NEW.concat(" and DATEDIFF(hh,a.GMT,getutcdate()) >= " + nonCommHrs
							+ " and a.LOCATION !='No GPS Device Connected' order by a.REGISTRATION_NO "));
				}
				pstmt.setInt(1, systemId);
				pstmt.setInt(2, userId);
			} else {
				if (impreciseSetting == true) {
					pstmt = con.prepareStatement(MapViewStatements.GET_MAP_VIEW_DETAILS_FOR_IMPRECISE_LOCATION.concat(" where a.REGISTRATION_NO in (" + regList + ")  order by a.REGISTRATION_NO"));
				} else {
					pstmt = con.prepareStatement(MapViewStatements.GET_MAP_VIEW_DETAILS.concat(" where a.REGISTRATION_NO in (" + regList + ")  order by a.REGISTRATION_NO"));
				}
			}
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, userId);
			// ///pstmt.setInt(3, offset);
			// ///pstmt.setInt(4, offset);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				VehicleDetailsObject = new JSONObject();
				String location = null;
				if (lang.equals("ar") && !rs.getString("LOCATION").equals("")) {
					location = LocationLocalization.getAppendLocationLocalization(rs.getString("LOCATION"), lang);
				} else {
					location = rs.getString("LOCATION");
				}
				if (!rs.getString("VEHICLE_ID").equals("")) {
					VehicleDetailsObject.put("assetNo", rs.getString("REGISTRATION_NO") + " [" + rs.getString("VEHICLE_ID") + "]");
				} else {
					VehicleDetailsObject.put("assetNo", rs.getString("REGISTRATION_NO"));
				}
				VehicleDetailsObject.put("vehicleNo", rs.getString("REGISTRATION_NO"));
				VehicleDetailsObject.put("latitude", rs.getString("LATITUDE"));
				VehicleDetailsObject.put("longitude", rs.getString("LONGITUDE"));
				VehicleDetailsObject.put("location", location);
				VehicleDetailsObject.put("gmt", sdf.format(sdfDB.parse(rs.getString("GPS_DATETIME"))));
				VehicleDetailsObject.put("drivername", "");
				VehicleDetailsObject.put("groupname", rs.getString("GROUP_NAME"));
				VehicleDetailsObject.put("groupId", rs.getString("GROUP_ID"));
				VehicleDetailsObject.put("ignition", "");
				VehicleDetailsObject.put("category", rs.getString("CATEGORY"));
				VehicleDetailsObject.put("prevlat", rs.getString("PREV_LAT"));
				VehicleDetailsObject.put("prevlong", rs.getString("PREV_LONG"));
				String path = rs.getString("IMAGE_NAME");
				String vehicleImage = "";
				String vehicleImage1 = "";
				String imagePath = "";
				if (path == null || path.equals("")) {
					vehicleImage = "default";
				} else {
					if (!path.contains("default")) {
						vehicleImage = path.substring(path.lastIndexOf("/") + 1, path.lastIndexOf("_"));
					} else {
						vehicleImage = path.substring(path.lastIndexOf("/") + 1, path.indexOf("_"));
					}
				}
				VehicleDetailsObject.put("imagePath", vehicleImage);
				if (path == null || path.equals("")) {
					if (rs.getString("IGNITION").equals("1") && rs.getFloat("SPEED") > 10) {
						vehicleImage1 = "<img src='" + vehicleImagePath + "default_BG.png' width='20' height='20' style='margin-top: -3px;'></img>";
					} else if (rs.getString("IGNITION").equals("0") && rs.getFloat("SPEED") == 0) {
						vehicleImage1 = "<img src='" + vehicleImagePath + "default_BR.png' width='20' height='20' style='margin-top: -3px;'></img>";
					} else if (rs.getString("IGNITION").equals("1") && rs.getFloat("SPEED") <= 10) {
						vehicleImage1 = "<img src='" + vehicleImagePath + "default_BL.png' width='20' height='20' style='margin-top: -3px;'></img>";
					} else {
						vehicleImage1 = "<img src='" + vehicleImagePath + "default_BG.png' width='20' height='20' style='margin-top: -3px;'></img>";
					}
				} else {
					imagePath = path.substring(path.lastIndexOf("/") + 1, path.lastIndexOf("_"));
					if (imagePath.contains("default")) {
						if (rs.getString("IGNITION").equals("1") && rs.getFloat("SPEED") > 10) {
							vehicleImage1 = "<img src='" + vehicleImagePath + "" + imagePath + "_BG.png" + "' width='20' height='20' style='margin-top: -3px;'></img>";
						} else if (rs.getString("IGNITION").equals("0") && rs.getFloat("SPEED") == 0) {
							vehicleImage1 = "<img src='" + vehicleImagePath + "" + imagePath + "_BR.png" + "' width='20' height='20' style='margin-top: -3px;'></img>";
						} else if (rs.getString("IGNITION").equals("1") && rs.getFloat("SPEED") <= 10) {
							vehicleImage1 = "<img src='" + vehicleImagePath + "" + imagePath + "_BL.png" + "' width='20' height='20' style='margin-top: -3px;'></img>";
						} else {
							vehicleImage1 = "<img src='" + vehicleImagePath + "" + imagePath + "_BG.png" + "' width='20' height='20' style='margin-top: -3px;'></img>";
						}
					} else {
						if (rs.getString("IGNITION").equals("1") && rs.getFloat("SPEED") > 10) {
							vehicleImage1 = "<img src='" + vehicleImagePath + "" + imagePath + "_BG.png" + "' width='20' height='20' style='margin-top: -3px;'></img>";
						} else if (rs.getString("IGNITION").equals("0") && rs.getFloat("SPEED") == 0) {
							vehicleImage1 = "<img src='" + vehicleImagePath + "" + imagePath + "_BR.png" + "' width='20' height='20' style='margin-top: -3px;'></img>";
						} else if (rs.getString("IGNITION").equals("1") && rs.getFloat("SPEED") <= 10) {
							vehicleImage1 = "<img src='" + vehicleImagePath + "" + imagePath + "_BL.png" + "' width='20' height='20' style='margin-top: -3px;'></img>";
						} else {
							vehicleImage1 = "<img src='" + vehicleImagePath + "" + imagePath + "_BG.png" + "' width='20' height='20' style='margin-top: -3px;'></img>";
						}
					}
				}
				if (rs.getString("IGNITION") != null && rs.getString("IGNITION").equals("1")) {
					VehicleDetailsObject.put("ignitionValue", "ON");
				} else {
					VehicleDetailsObject.put("ignitionValue", "OFF");
				}
				VehicleDetailsObject.put("speedValue", rs.getFloat("SPEED"));
				VehicleDetailsObject.put("ignition", vehicleImage1);
				VehicleDetailsObject.put("speed", vehicleImage1);
				VehicleDetailsObject.put("imageIcon", vehicleImage1);
				VehicleDetailsObject.put("vehicleMake", rs.getString("Vehicle_Make"));
				VehicleDetailsArray.put(VehicleDetailsObject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return VehicleDetailsArray;
	}

	public JSONArray getTripSummaryDetailsAmazon(int systemId, int clientId, int offset, String groupId, String unit, int userId) {
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonobject = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int count = 0;
		String plannedDate = "";
		String actualDate = "";
		String condition = "";
		double distance = 0;
		String endDate = "";
		String originTime = "";
		try {
			jsonArray = new JSONArray();
			con = DBConnection.getConnectionToDB("AMS");
			if (groupId.equals("0")) {
				condition = "and td.STATUS='OPEN' and td.TRIP_STATUS <> 'NEW'";
			} else if (groupId.equals("1")) {
				condition = "and td.TRIP_START_TIME between dateadd(dd,-2,getutcdate()) and getutcdate()";
			} else if (groupId.equals("2")) {
				condition = "and td.TRIP_START_TIME between dateadd(dd,-7,getutcdate()) and getutcdate()";
			} else if (groupId.equals("3")) {
				condition = "and td.TRIP_START_TIME between dateadd(dd,-15,getutcdate()) and getutcdate()";
			} else if (groupId.equals("4")) {
				condition = "and td.TRIP_START_TIME between dateadd(dd,-30,getutcdate()) and getutcdate()";
			}

			pstmt = con.prepareStatement(GeneralVerticalStatements.GET_TRIP_SUMMARY_DETAILS_AMAZON.replace("#", condition));
			pstmt.setInt(1, offset);
			pstmt.setInt(2, offset);
			pstmt.setInt(3, offset);
			pstmt.setInt(4, offset);
			pstmt.setInt(5, offset);
			pstmt.setInt(6, userId);
			pstmt.setInt(7, systemId);
			pstmt.setInt(8, clientId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				plannedDate = "";
				actualDate = "";
				endDate = "";
				count++;
				jsonobject = new JSONObject();
				jsonobject.put("slNo", count);
				jsonobject.put("tripNo", rs.getString("tripId"));
				jsonobject.put("vehicleNo", rs.getString("vehicleNo"));
				jsonobject.put("startLocation", rs.getString("startLocation"));
				jsonobject.put("currentLocation", rs.getString("currentLocation"));
				if (!rs.getString("plannedDate").contains("1900")) {
					plannedDate = sdf.format(sdfDB.parse(rs.getString("plannedDate")));
				}
				if (!rs.getString("actualDate").contains("1900")) {
					actualDate = sdf.format(sdfDB.parse(rs.getString("actualDate")));
				}
				jsonobject.put("plannedDate", plannedDate);
				jsonobject.put("actualDate", actualDate);
				distance = rs.getDouble("actualDuration");
				if (unit.equals("Miles")) {
					distance = rs.getDouble("actualDuration") * 0.621371;
				}
				jsonobject.put("distanceTravelled", df.format(distance));
				jsonobject.put("events", rs.getInt("eventsCount"));
				jsonobject.put("status", rs.getString("status"));
				if (!rs.getString("endDate").contains("1900")) {
					endDate = sdf.format(sdfDB.parse(rs.getString("endDate")));
				}
				if (!rs.getString("ORIGIN").contains("1900")) {
					originTime = sdf.format(sdfDB.parse(rs.getString("ORIGIN")));
				}
				jsonobject.put("endDateHidden", endDate);
				jsonobject.put("originLocation", originTime);
				jsonobject.put("estimatedNextPoint", rs.getString("NEXT_LOCATION"));
				jsonobject.put("StartDate", actualDate);
				jsonobject.put("checkPoint1", rs.getString("CHECKPOINT_1"));
				jsonobject.put("checkPoint2", rs.getString("CHECKPOINT_2"));
				jsonobject.put("checkPoint3", rs.getString("CHECKPOINT_3"));
				jsonobject.put("checkPoint4", rs.getString("CHECKPOINT_4"));
				jsonobject.put("checkPoint5", rs.getString("CHECKPOINT_5"));
				if (rs.getString("status").contains("OPEN")) {
					jsonobject.put("button", "<button onclick=closeTrip(" + rs.getString("tripId") + "); class='btn btn-warning'>Close Trip</button> ");
				} else {
					jsonobject.put("button", "");
				}
				jsonArray.put(jsonobject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jsonArray;
	}

	public JSONArray getCustomerDetails(int systemId, int clientId) {
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonobject = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			jsonArray = new JSONArray();
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(GeneralVerticalStatements.GET_CUSTOMER_DETAILS);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, clientId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				jsonobject = new JSONObject();
				jsonobject.put("customerName", rs.getString("CUSTOMER_NAME"));
				jsonobject.put("customerId", rs.getString("CUSTOMER_ID"));
				jsonArray.put(jsonobject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jsonArray;
	}

	public JSONArray getRouteDetails(int systemId, int clientId, String CustomerName) {
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonobject = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			jsonArray = new JSONArray();
			con = DBConnection.getConnectionToDB("AMS");
			if (CustomerName.equalsIgnoreCase("All")) {
				pstmt = con.prepareStatement(GeneralVerticalStatements.GET_ROUTE_DETAILS.replace("#", ""));
			} else {
				String array2 = (CustomerName.substring(0, CustomerName.length() - 1));
				String newCustomerList = "'" + array2.toString().replace(",", "','") + "'";
				pstmt = con.prepareStatement(GeneralVerticalStatements.GET_ROUTE_DETAILS.replace("#", " and TRIP_CUSTOMER_ID in (" + newCustomerList + ")"));
			}
			pstmt.setInt(1, systemId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				jsonobject = new JSONObject();
				jsonobject.put("routeId", rs.getString("ROUTE_ID"));
				jsonobject.put("routeName", rs.getString("RouteName"));
				jsonArray.put(jsonobject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jsonArray;
	}

	public JSONArray getTruckDetails(int systemId, int clientId, String customerData, String routeList, int range, int comaparsion, int offset) {
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonobject = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		// ArrayList<ArrayList<String>> json = new
		// ArrayList<ArrayList<String>>();

		try {
			ArrayList<Integer> rangeList = new ArrayList<Integer>();
			ArrayList<Integer> relativeRangeList = new ArrayList<Integer>();
			con = DBConnection.getConnectionToDB("AMS");
			switch (range) {
			case 1:
				rangeList.add(7);
				rangeList.add(0);
				relativeRangeList.add(14);
				relativeRangeList.add(8);
				break;
			case 2:
				if (comaparsion == 1) {
					rangeList.add(30);
					rangeList.add(0);
					relativeRangeList.add(60);
					relativeRangeList.add(31);
				} else {
					rangeList.add(30);
					rangeList.add(0);
					relativeRangeList.add(395);
					relativeRangeList.add(366);

				}
				break;
			case 3:
				if (comaparsion == 1) {
					rangeList.add(90);
					rangeList.add(0);
					relativeRangeList.add(180);
					relativeRangeList.add(91);
				} else {
					rangeList.add(90);
					rangeList.add(0);
					relativeRangeList.add(455);
					relativeRangeList.add(366);
				}
				break;
			case 4:
				rangeList.add(365);
				rangeList.add(0);
				relativeRangeList.add(730);
				relativeRangeList.add(366);
				break;
			default:
				break;
			}

			ArrayList<Integer> timePercentage = getTimePerformance(con, systemId, clientId, rangeList, relativeRangeList, customerData, routeList, offset);
			String ontimecolor = (timePercentage.get(0) >= timePercentage.get(1)) ? "red" : "green";
			jsonobject.put("ontimePercentage", timePercentage.get(0));
			jsonobject.put("relativePercentage", timePercentage.get(1));
			jsonobject.put("relativePercentageColor", ontimecolor);

			//ArrayList<Integer> deleyedPercentage = getDelayPerformance(con, systemId, clientId, rangeList, relativeRangeList, customerData, routeList, offset);
			//String delayedcolor = (deleyedPercentage.get(0) >= deleyedPercentage.get(1)) ? "red" : "green";
			//jsonobject.put("delayPercentage", deleyedPercentage.get(0));
			//jsonobject.put("relativedelayPercentage", deleyedPercentage.get(1));
			//jsonobject.put("delayPercentageColor", delayedcolor);
			
			//changed by Guru (Praveen C has suggested a new logic where all the vehicles other than on-time will be considered as delayed and the same will be displayed on screen)
			//09-11-2019
			String delayedcolor = ((100 - timePercentage.get(0)) >= (100 - timePercentage.get(1))) ? "red" : "green";
			jsonobject.put("delayPercentage", (100 - timePercentage.get(0)));
			jsonobject.put("relativedelayPercentage", (100 - timePercentage.get(1)));
			jsonobject.put("delayPercentageColor", delayedcolor);

			ArrayList<Integer> backHaulPercentage = getBackHaulPerformance(con, systemId, clientId, rangeList, relativeRangeList, customerData, routeList, offset);
			String backHaulcolor = (backHaulPercentage.get(0) >= backHaulPercentage.get(1)) ? "red" : "green";
			jsonobject.put("backHaulPercentage", backHaulPercentage.get(0));
			jsonobject.put("relativebackHaulPercentage", backHaulPercentage.get(1));
			jsonobject.put("backHaulPercentageColor", backHaulcolor);

			// GET_SMART_TRUCK_DETAILS

			ArrayList<Double> smartTruck = GET_SMART_TRUCK_DETAILS(con, systemId, clientId, rangeList, relativeRangeList, customerData, routeList, offset);
			String smartTruckcolor = (smartTruck.get(0) >= smartTruck.get(1)) ? "red" : "green";
			jsonobject.put("smartTruck", smartTruck.get(0));
			jsonobject.put("relativesmartTruck", smartTruck.get(1));
			jsonobject.put("smartTruckColor", smartTruckcolor);

			ArrayList<Double> getMileage22ft = getMileage(con, systemId, clientId, rangeList, relativeRangeList, "22 FEET", offset);
			String color22feet = (getMileage22ft.get(0) >= getMileage22ft.get(1)) ? "red" : "green";
			jsonobject.put("mileage22ft", getMileage22ft.get(0));
			jsonobject.put("realtivemileage22ft", getMileage22ft.get(1));
			jsonobject.put("color22feet", color22feet);

			ArrayList<Double> getMileage24ft = getMileage(con, systemId, clientId, rangeList, relativeRangeList, "24 FEET", offset);
			String color24feet = (getMileage24ft.get(0) >= getMileage24ft.get(1)) ? "red" : "green";
			jsonobject.put("mileage24ft", getMileage24ft.get(0));
			jsonobject.put("realtivemileage24ft", getMileage24ft.get(1));
			jsonobject.put("color24feet", color24feet);

			ArrayList<Double> getMileage32Ft = getMileage(con, systemId, clientId, rangeList, relativeRangeList, "32 FEET", offset);
			String color32feet = (getMileage32Ft.get(0) >= getMileage32Ft.get(1)) ? "red" : "green";
			jsonobject.put("mileage32ft", getMileage32Ft.get(0));
			jsonobject.put("realtivemileage32ft", getMileage32Ft.get(1));
			jsonobject.put("color32feet", color32feet);

			ArrayList<Double> smartTrucker = GET_SMART_TRUCKER_TRUCK_DETAILS(con, systemId, clientId, rangeList, relativeRangeList, customerData, routeList);
			String smartTruckercolor = (smartTrucker.get(0) >= smartTrucker.get(1)) ? "red" : "green";
			jsonobject.put("smartTrckerPerTruck", smartTrucker.get(0));
			jsonobject.put("relativesmartTrckerPerTruck", smartTrucker.get(1));
			jsonobject.put("smartTrckerPerTruckColor", smartTruckercolor);

			ArrayList<Integer> smartTruckerTop = GET_SMART_TOP_TRUCKER_TRUCK_DETAILS(con, systemId, clientId, rangeList, relativeRangeList, customerData, routeList, offset);
			String smartTruckTopcolor = (smartTruckerTop.get(0) >= smartTruckerTop.get(1)) ? "red" : "green";
			jsonobject.put("smartTruckTop", smartTruckerTop.get(0));
			jsonobject.put("realativesmartTruckTop", smartTruckerTop.get(1));
			jsonobject.put("smartTruckTopColor", smartTruckTopcolor);

			jsonArray.put(jsonobject);

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jsonArray;
	}

	public JSONArray getOntimeTruckDetails(int systemId, int clientId, String customerData, String routeList, int range, int comaparsion, int offset) {
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonobject = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		try {
			ArrayList<Integer> rangeList = new ArrayList<Integer>();
			ArrayList<Integer> relativeRangeList = new ArrayList<Integer>();
			con = DBConnection.getConnectionToDB("AMS");
			switch (range) {
			case 1:
				rangeList.add(7);
				rangeList.add(0);
				relativeRangeList.add(14);
				relativeRangeList.add(8);
				break;
			case 2:
				if (comaparsion == 1) {
					rangeList.add(30);
					rangeList.add(0);
					relativeRangeList.add(60);
					relativeRangeList.add(31);
				} else {
					rangeList.add(30);
					rangeList.add(0);
					relativeRangeList.add(395);
					relativeRangeList.add(366);

				}
				break;
			case 3:
				if (comaparsion == 1) {
					rangeList.add(90);
					rangeList.add(0);
					relativeRangeList.add(180);
					relativeRangeList.add(91);
				} else {
					rangeList.add(90);
					rangeList.add(0);
					relativeRangeList.add(455);
					relativeRangeList.add(366);
				}
				break;
			case 4:
				rangeList.add(365);
				rangeList.add(0);
				relativeRangeList.add(730);
				relativeRangeList.add(366);
				break;
			default:
				break;
			}

			ArrayList<Integer> ontimePercentage = getOnTimePerformance(con, systemId, clientId, rangeList, relativeRangeList, customerData, routeList, offset);
			jsonobject.put("ontimePlacedPercentage", ontimePercentage.get(0));
			jsonobject.put("ontimeDepart", ontimePercentage.get(1));
			jsonobject.put("ontimeLoad", ontimePercentage.get(2));
			jsonobject.put("ontimeUnload", ontimePercentage.get(3));

			jsonArray.put(jsonobject);

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jsonArray;
	}

	public JSONArray getDelayTruckDetails(int systemId, int clientId, String customerData, String routeList, int range, int comaparsion, int offset) {
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonobject = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		try {
			ArrayList<Integer> rangeList = new ArrayList<Integer>();
			ArrayList<Integer> relativeRangeList = new ArrayList<Integer>();
			con = DBConnection.getConnectionToDB("AMS");
			switch (range) {
			case 1:
				rangeList.add(7);
				rangeList.add(0);
				relativeRangeList.add(14);
				relativeRangeList.add(8);
				break;
			case 2:
				if (comaparsion == 1) {
					rangeList.add(30);
					rangeList.add(0);
					relativeRangeList.add(60);
					relativeRangeList.add(31);
				} else {
					rangeList.add(30);
					rangeList.add(0);
					relativeRangeList.add(395);
					relativeRangeList.add(366);

				}
				break;
			case 3:
				if (comaparsion == 1) {
					rangeList.add(90);
					rangeList.add(0);
					relativeRangeList.add(180);
					relativeRangeList.add(91);
				} else {
					rangeList.add(90);
					rangeList.add(0);
					relativeRangeList.add(455);
					relativeRangeList.add(366);
				}
				break;
			case 4:
				rangeList.add(365);
				rangeList.add(0);
				relativeRangeList.add(730);
				relativeRangeList.add(366);
				break;
			default:
				break;
			}

			ArrayList<Integer> DelayPercentage = getDelayhrsPerformance(con, systemId, clientId, rangeList, relativeRangeList, customerData, routeList, offset);
			jsonobject.put("onehrDelay", DelayPercentage.get(0));
			jsonobject.put("threehrDelay", DelayPercentage.get(1));
			jsonobject.put("fivehrDelay", DelayPercentage.get(2));
			jsonobject.put("abovefivehrDelay", DelayPercentage.get(3));

			jsonArray.put(jsonobject);

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jsonArray;
	}

	public JSONArray getSmartTruckDetails(int systemId, int clientId, String customerData, String routeList, int range, int comaparsion, int offset) {
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonobject = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		try {
			ArrayList<Integer> rangeList = new ArrayList<Integer>();
			ArrayList<Integer> relativeRangeList = new ArrayList<Integer>();
			con = DBConnection.getConnectionToDB("AMS");
			switch (range) {
			case 1:
				rangeList.add(7);
				rangeList.add(0);
				relativeRangeList.add(14);
				relativeRangeList.add(8);
				break;
			case 2:
				if (comaparsion == 1) {
					rangeList.add(30);
					rangeList.add(0);
					relativeRangeList.add(60);
					relativeRangeList.add(31);
				} else {
					rangeList.add(30);
					rangeList.add(0);
					relativeRangeList.add(395);
					relativeRangeList.add(366);

				}
				break;
			case 3:
				if (comaparsion == 1) {
					rangeList.add(90);
					rangeList.add(0);
					relativeRangeList.add(180);
					relativeRangeList.add(91);
				} else {
					rangeList.add(90);
					rangeList.add(0);
					relativeRangeList.add(455);
					relativeRangeList.add(366);
				}
				break;
			case 4:
				rangeList.add(365);
				rangeList.add(0);
				relativeRangeList.add(730);
				relativeRangeList.add(366);
				break;
			default:
				break;
			}

			ArrayList<Integer> ontimePercentage = getSmartTruckPerformance(con, systemId, clientId, rangeList, relativeRangeList, customerData, routeList, offset);
			jsonobject.put("greater15kTruck", ontimePercentage.get(0));
			jsonobject.put("between15kTruck", ontimePercentage.get(1));
			jsonobject.put("lesser12kTruck", ontimePercentage.get(2));

			jsonArray.put(jsonobject);

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jsonArray;
	}

	public ArrayList<Integer> getTimePerformance(Connection con, int systemId, int clientId, ArrayList<Integer> rangeList, ArrayList<Integer> relativeRangeList, String customerData, String routeList,
			int offset) {
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		ArrayList<Integer> perList = null;
		routeList = routeList.substring(0, routeList.length() - 1);
		//customerData = customerData.replaceAll(",", "','");
		customerData = customerData.substring(0, customerData.length() - 1);
		// int routeId = Integer.parseInt(routeList);
		try {

			String Statement = GeneralVerticalStatements.GET_TIME_PERFORMACE;
			// if(routeId==1){
			// Statement=Statement.replace("$", "");
			// }else{
			Statement = Statement.replace("$", " and ROUTE_ID in (" + routeList + ")");
			// }
			// if(customerData.equalsIgnoreCase("All")){
			// Statement=Statement.replace("#", "");
			// }else{
			Statement = Statement.replace("#", " and TRIP_CUSTOMER_ID in (" + customerData + ")");
			// }

			pstmt = con.prepareStatement(Statement);
			// System.out.println(Statement);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, clientId);
			pstmt.setInt(3, offset);
			pstmt.setInt(4, rangeList.get(0));
			pstmt.setInt(5, offset);
			pstmt.setInt(6, rangeList.get(1));
			pstmt.setInt(7, systemId);
			pstmt.setInt(8, clientId);
			pstmt.setInt(9, offset);
			pstmt.setInt(10, rangeList.get(0));
			pstmt.setInt(11, offset);
			pstmt.setInt(12, rangeList.get(1));
			pstmt.setInt(13, systemId);
			pstmt.setInt(14, clientId);
			pstmt.setInt(15, offset);
			pstmt.setInt(16, relativeRangeList.get(0));
			pstmt.setInt(17, offset);
			pstmt.setInt(18, relativeRangeList.get(1));
			pstmt.setInt(19, systemId);
			pstmt.setInt(20, clientId);
			pstmt.setInt(21, offset);
			pstmt.setInt(22, relativeRangeList.get(0));
			pstmt.setInt(23, offset);
			pstmt.setInt(24, relativeRangeList.get(1));
			rs = pstmt.executeQuery();
			int onTimePercentage = 0;
			int relativePercentage = 0;
			if (rs.next()) {
				int totalTrip = rs.getInt("TIME_TOATL_TRIP");
				double OnTimeTrip = rs.getInt("TIME_ON_TRIP");
				int RTotalTrip = rs.getInt("R_TIME_TOATL_TRIP");
				double ROnTimeTrip = rs.getInt("R_TIME_ON_TRIP");

				if (totalTrip != 0) {
					double total = (OnTimeTrip / totalTrip);
					onTimePercentage = (int) Math.round(total * 100);
				} else {
					onTimePercentage = (int) OnTimeTrip;
				}
				if (RTotalTrip != 0) {
					double total = (ROnTimeTrip / RTotalTrip);
					relativePercentage = (int) Math.round(total * 100);
				} else {
					relativePercentage = (int) ROnTimeTrip;
				}
				perList = new ArrayList<Integer>();
				perList.add(onTimePercentage);
				perList.add(relativePercentage);

			}

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(null, pstmt, rs);
		}

		return perList;

	}

	public ArrayList<Integer> getDelayPerformance(Connection con, int systemId, int clientId, ArrayList<Integer> rangeList, ArrayList<Integer> relativeRangeList, String customerData,
			String routeList, int offset) {
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		ArrayList<Integer> perList = null;
		routeList = routeList.substring(0, routeList.length() - 1);
		//customerData = customerData.replaceAll(",", "','");
		customerData = customerData.substring(0, customerData.length() - 1);
		// int routeId = Integer.parseInt(routeList);
		try {

			String Statement = GeneralVerticalStatements.GET_DELEYED_PERCENTAGE;
			// if(routeId==1){
			// Statement=Statement.replace("$", "");
			// }else{
			Statement = Statement.replace("$", " and ROUTE_ID in (" + routeList + ")");
			// }
			// if(customerData.equalsIgnoreCase("All")){
			// Statement=Statement.replace("#", "");
			// }else{
			Statement = Statement.replace("#", " and TRIP_CUSTOMER_ID in (" + customerData + ")");
			// }

			pstmt = con.prepareStatement(Statement);
			// System.out.println("delay : "+Statement);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, clientId);
			pstmt.setInt(3, offset);
			pstmt.setInt(4, rangeList.get(0));
			pstmt.setInt(5, offset);
			pstmt.setInt(6, rangeList.get(1));
			pstmt.setInt(7, systemId);
			pstmt.setInt(8, clientId);
			pstmt.setInt(9, offset);
			pstmt.setInt(10, rangeList.get(0));
			pstmt.setInt(11, offset);
			pstmt.setInt(12, rangeList.get(1));
			pstmt.setInt(13, systemId);
			pstmt.setInt(14, clientId);
			pstmt.setInt(15, offset);
			pstmt.setInt(16, relativeRangeList.get(0));
			pstmt.setInt(17, offset);
			pstmt.setInt(18, relativeRangeList.get(1));
			pstmt.setInt(19, systemId);
			pstmt.setInt(20, clientId);
			pstmt.setInt(21, offset);
			pstmt.setInt(22, relativeRangeList.get(0));
			pstmt.setInt(23, offset);
			pstmt.setInt(24, relativeRangeList.get(1));
			rs = pstmt.executeQuery();
			int deleyedPercentage = 0;
			int relativeDelayedPercentage = 0;
			if (rs.next()) {
				int totalTrip = rs.getInt("TOTAL_DELIVERY");
				double delayedTrip = rs.getInt("DELAYED_DELIVERY");
				int RTotalTrip = rs.getInt("R_TOTAL_DELIVERY");
				double RdelayedTrip = rs.getInt("R_DELAYED_DELIVERY");

				if (totalTrip != 0) {
					double total = (delayedTrip / totalTrip);
					deleyedPercentage = (int) Math.round(total * 100);
				} else {
					deleyedPercentage = (int) delayedTrip;
				}
				if (RTotalTrip != 0) {
					double total = (RdelayedTrip / RTotalTrip);
					relativeDelayedPercentage = (int) Math.round(total * 100);
				} else {
					relativeDelayedPercentage = (int) RdelayedTrip;
				}
				perList = new ArrayList<Integer>();
				perList.add(deleyedPercentage);
				perList.add(relativeDelayedPercentage);

			}

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(null, pstmt, rs);
		}

		return perList;

	}

	public ArrayList<Integer> getBackHaulPerformance(Connection con, int systemId, int clientId, ArrayList<Integer> rangeList, ArrayList<Integer> relativeRangeList, String customerData,
			String routeList, int offset) {
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		ArrayList<Integer> perList = null;
		// int routeId = Integer.parseInt(routeList);
		try {

			/*
			 * String Statement =
			 * GeneralVerticalStatements.GET_BACKHAUL_PERCENTAGE;
			 * if(routeId==1){ Statement=Statement.replace("$", ""); }else{
			 * Statement= Statement.replace("$", " and ROUTE_ID="+routeId ); }
			 * if(customerData.equalsIgnoreCase("All")){
			 * Statement=Statement.replace("#", ""); }else{
			 * Statement=Statement.replace("#",
			 * " and CUSTOMER_NAME='"+customerData+"'" ); }
			 * System.out.println(Statement);
			 */

			pstmt = con.prepareStatement(GeneralVerticalStatements.GET_BACKHAUL_PERCENTAGE);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, clientId);
			pstmt.setInt(3, offset);
			pstmt.setInt(4, rangeList.get(0));
			pstmt.setInt(5, offset);
			pstmt.setInt(6, rangeList.get(1));
			pstmt.setInt(7, systemId);
			pstmt.setInt(8, clientId);
			pstmt.setInt(9, offset);
			pstmt.setInt(10, rangeList.get(0));
			pstmt.setInt(11, offset);
			pstmt.setInt(12, rangeList.get(1));
			pstmt.setInt(13, systemId);
			pstmt.setInt(14, clientId);
			pstmt.setInt(15, offset);
			pstmt.setInt(16, relativeRangeList.get(0));
			pstmt.setInt(17, offset);
			pstmt.setInt(18, relativeRangeList.get(1));
			pstmt.setInt(19, systemId);
			pstmt.setInt(20, clientId);
			pstmt.setInt(21, offset);
			pstmt.setInt(22, relativeRangeList.get(0));
			pstmt.setInt(23, offset);
			pstmt.setInt(24, relativeRangeList.get(1));
			rs = pstmt.executeQuery();
			int backHaulPercentage = 0;
			int relativebackHaulPercentage = 0;
			if (rs.next()) {
				double actualDistance = rs.getInt("ACTUAL_DISTANCE");
				double totalDistance = rs.getInt("TotalDistanceTravelled");
				double RactualDistance = rs.getInt("R_ACTUAL_DISTANCE");
				double RtotalDistance = rs.getInt("R_TotalDistanceTravelled");

				if (totalDistance != 0) {
					double total = (actualDistance / totalDistance);
					backHaulPercentage = (int) Math.round(total * 100);
				} else {
					backHaulPercentage = (int) actualDistance;
				}
				if (RtotalDistance != 0) {
					double total = (RactualDistance / RtotalDistance);
					relativebackHaulPercentage = (int) Math.round(total * 100);
				} else {
					relativebackHaulPercentage = (int) RactualDistance;
				}
				perList = new ArrayList<Integer>();
				perList.add(backHaulPercentage);
				perList.add(relativebackHaulPercentage);

			}

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(null, pstmt, rs);
		}

		return perList;

	}

	public ArrayList<Double> getMileage(Connection con, int systemId, int clientId, ArrayList<Integer> rangeList, ArrayList<Integer> relativeRangeList, String VehType, int offset) {
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		ArrayList<Double> mileageList = null;
		try {
			String stmt = GeneralVerticalStatements.GET_MILEAGE_ON_VEH_TYPE_NEW;
			pstmt = con.prepareStatement(stmt.replaceAll("_#", "_" + systemId));
			// System.out.println(stmt);
			pstmt.setInt(1, clientId);
			pstmt.setString(2, VehType);
			pstmt.setInt(3, offset);
			pstmt.setInt(4, rangeList.get(0));
			pstmt.setInt(5, offset);
			pstmt.setInt(6, rangeList.get(1));
			pstmt.setInt(7, clientId);
			pstmt.setString(8, VehType);
			pstmt.setInt(9, offset);
			pstmt.setInt(10, rangeList.get(0));
			pstmt.setInt(11, offset);
			pstmt.setInt(12, rangeList.get(1));
			rs = pstmt.executeQuery();
			double mileage = 0.0;
			double Rmileage = 0.0;
			mileageList = new ArrayList<Double>();
			if (rs.next()) {
				String Mileage = df.format(rs.getDouble("MILEAGE"));
				mileage = Double.parseDouble(Mileage);
			}

			stmt = GeneralVerticalStatements.GET_MILEAGE_ON_VEH_TYPE_NEW_REL;

			pstmt = con.prepareStatement(stmt.replaceAll("_#", "_" + systemId));

			pstmt.setInt(1, clientId);
			pstmt.setString(2, VehType);
			pstmt.setInt(3, offset);
			pstmt.setInt(4, relativeRangeList.get(0));
			pstmt.setInt(5, offset);
			pstmt.setInt(6, relativeRangeList.get(1));
			pstmt.setInt(7, clientId);
			pstmt.setString(8, VehType);
			pstmt.setInt(9, offset);
			pstmt.setInt(10, relativeRangeList.get(0));
			pstmt.setInt(11, offset);
			pstmt.setInt(12, relativeRangeList.get(1));
			rs = pstmt.executeQuery();
			if (rs.next()) {
				String RMileage = df.format(rs.getDouble("RMILEAGE"));
				Rmileage = Double.parseDouble(RMileage);
			}

			mileageList.add(mileage);
			mileageList.add(Rmileage);

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(null, pstmt, rs);
		}

		return mileageList;

	}

	public JSONArray getDashBoardDetails(int systemId, int customerId, String customerList, String routeList, String productList) {
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonobject = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {

			String array1 = (routeList.substring(0, routeList.length() - 1));
			String array2 = (customerList.substring(0, customerList.length() - 1));
			String array3 = (productList.substring(0, productList.length() - 1));

			String newRouteList = "'" + array1.toString().replace(",", "','") + "'";

			String newProductList = "'" + array3.toString().replace(",", "','") + "'";
			con = DBConnection.getConnectionToDB("AMS");
			String Statement = GeneralVerticalStatements.GET_DASHBOARD_DETAIL_COUNT;
			Statement = Statement.replace("$", " and td.ROUTE_ID in (" + newRouteList + ")");
			Statement = Statement.replace("#", " and td.TRIP_CUSTOMER_ID in (" + array2 + ")");
			Statement = Statement.replace("^", " and td.PRODUCT_LINE in (" + newProductList + ")");
			pstmt = con.prepareStatement(Statement);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, customerId);
			pstmt.setInt(3, systemId);
			pstmt.setInt(4, customerId);
			pstmt.setInt(5, systemId);
			pstmt.setInt(6, customerId);
			pstmt.setInt(7, systemId);
			pstmt.setInt(8, customerId);
			pstmt.setInt(9, systemId);
			pstmt.setInt(10, customerId);
			pstmt.setInt(11, systemId);
			pstmt.setInt(12, customerId);
			pstmt.setInt(13, systemId);
			pstmt.setInt(14, customerId);
			pstmt.setInt(15, systemId);
			pstmt.setInt(16, customerId);

			rs = pstmt.executeQuery();
			if (rs.next()) {
				jsonobject = new JSONObject();
				jsonobject.put("UnAssignedCount", rs.getInt(1));
				jsonobject.put("IdleCount", rs.getInt(2));
				jsonobject.put("UnderMaintainanceCount", rs.getInt(3));
				jsonobject.put("EnroutementCount", rs.getInt(4));
				jsonobject.put("assignedplacementcount", rs.getInt(5));
				jsonobject.put("OntimeCount", rs.getInt(6));
				jsonobject.put("DelayedCount", rs.getInt(7));
				jsonobject.put("DetentionCount", rs.getInt(8));

				jsonArray.put(jsonobject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jsonArray;
	}

	public JSONArray getPanalDetails(String uniqueId, int systemId, int customerId) {
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonobject = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int count = 0;
		try {
			con = DBConnection.getConnectionToDB("AMS");
			if (uniqueId.equals("1")) {
				pstmt = con.prepareStatement(GeneralVerticalStatements.GET_PANEL_TABLE_DETAILS);
			} else if (uniqueId.equals("2")) {
				pstmt = con.prepareStatement(GeneralVerticalStatements.GET_PANEL_IDLE_TABLE_DETAILS);
			} else if (uniqueId.equals("3")) {
				pstmt = con.prepareStatement(GeneralVerticalStatements.GET_UNDERMAINTENANCE_DETAILS_AT_CONTROL_TOWER);
			}

			pstmt.setInt(1, systemId);
			pstmt.setInt(2, customerId);

			rs = pstmt.executeQuery();

			while (rs.next()) {
				count++;
				jsonobject = new JSONObject();

				jsonobject.put("slNoIndex", count);
				jsonobject.put("Vehicle_No", rs.getString("VEHICLE_NO"));
				jsonobject.put("Gps_Date", rs.getString("GPS_DATETIME").equals("") ? "" : sdf.format(sdfDB.parse(rs.getString("GPS_DATETIME"))));
				jsonobject.put("Location", rs.getString("LOCATION"));
				if (uniqueId.equals("3")) {
					String id = rs.getString("ID");
					String startDate = sdf.format(sdfDB.parse(rs.getString("START_DATE")));
					startDate = startDate.replace(" ", "#");
					String vehicleNumber = rs.getString("VEHICLE_NO").replace(" ", "^");
					String remarks = rs.getString("REMARKS");
					remarks = remarks.replace(" ", "^");
					remarks = remarks.replace("\n", "").replace("\r", "");

					jsonobject.put("startDate", rs.getString("START_DATE").equals("") ? "" : sdf.format(sdfDB.parse(rs.getString("START_DATE"))));
					jsonobject.put("remarks", rs.getString("REMARKS"));
					jsonobject.put("button", "<button onclick=openModal1('" + id + "','" + vehicleNumber + "','" + startDate + "','" + remarks
							+ "','+0+'); class='btn btn-success btn-sm text-center'>Ready For Placement</button>");
				}

				jsonArray.put(jsonobject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jsonArray;
	}

	public JSONArray getAssignedEnroutePlaceDetails(String uniqueId, int systemId, int clientId, String customerName, String routeId, String productLine) {
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonobject = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int count = 0;
		// int r=Integer.parseInt(routeId);
		try {
			con = DBConnection.getConnectionToDB("AMS");

			// String Statement =
			// GeneralVerticalStatements.GET_ASSIGNED_ENROUTE_PLACED_DETAILS;
			String Statement = GeneralVerticalStatements.GET_ASSIGNED_ENROUTE_PLACED_DETAILS_FOR_LIST_VIEW;

			String array1 = (routeId.substring(0, routeId.length() - 1));
			String array2 = (customerName.substring(0, customerName.length() - 1));
			String array3 = (productLine.substring(0, productLine.length() - 1));

			// String newRouteList
			// ="'"+array1.toString().replace("[","").replace("]",
			// "").replace(" ","").replace(",","','")+"'";
			String newRouteList = "'" + array1.toString().replace(",", "','") + "'";

			// String newCustomerList
			// ="'"+array2.toString().replace("[","").replace("]",
			// "").replace(" ","").replace(",","','")+"'";
			// String newCustomerList
			// ="'"+array2.toString().replace(",","','")+"'";

			// String newProductList
			// ="'"+array3.toString().replace("[","").replace("]",
			// "").replace(" ","").replace(",","','")+"'";
			String newProductList = "'" + array3.toString().replace(",", "','") + "'";

			Statement = Statement.replace("$", " and ROUTE_ID in (" + newRouteList + ")");
			Statement = Statement.replace("#", " and TRIP_CUSTOMER_ID in (" + array2 + ")");
			Statement = Statement.replace("^", " and PRODUCT_LINE in (" + newProductList + ")");

			// if(r==1){
			// Statement=Statement.replace("$", "");
			// }else{
			// Statement= Statement.replace("$", " and ROUTE_ID="+routeId );
			// }
			// if(customerName.equalsIgnoreCase("All")){
			// Statement=Statement.replace("#", "");
			// }else{
			// Statement=Statement.replace("#",
			// " and CUSTOMER_NAME='"+customerName+"'" );
			// }
			// if(productLine.equalsIgnoreCase("All")){
			// Statement=Statement.replace("^", "");
			// }else{
			// if (productLine.equalsIgnoreCase("DRY")) {
			// Statement=Statement.replace("^",
			// " and (PRODUCT_LINE='"+productLine+"' or PRODUCT_LINE is null)"
			// );
			// }else{
			// Statement=Statement.replace("^",
			// " and PRODUCT_LINE='"+productLine+"'" );
			// }
			//			
			// }

			if (uniqueId.equals("4")) {
				pstmt = con.prepareStatement(Statement + " and TRIP_STATUS like 'ENROUTE PLACEMENT%'");
			} else if (uniqueId.equals("5")) {
				pstmt = con.prepareStatement(Statement + " and TRIP_STATUS not like 'ENROUTE PLACEMENT%'");
			} else if (uniqueId.equals("6")) {
				pstmt = con.prepareStatement(Statement + " and TRIP_STATUS like 'ON TIME'");
			} else if (uniqueId.equals("7")) {
				pstmt = con.prepareStatement(Statement + " and TRIP_STATUS like 'DELAYED'");
			} else if (uniqueId.equals("8")) {
				pstmt = con.prepareStatement(Statement + " and TRIP_STATUS like '%DETENTION%'");
			}

			pstmt.setInt(1, systemId);
			pstmt.setInt(2, clientId);

			rs = pstmt.executeQuery();

			while (rs.next()) {
				count++;

				jsonobject = new JSONObject();

				jsonobject.put("slNoIndex", count);
				jsonobject.put("Customer_Name", rs.getString("Customer_Name"));
				jsonobject.put("Route_Name", rs.getString("Route_Name"));
				jsonobject.put("Vehicle_No", rs.getString("VEHICLE_NO"));
				jsonobject.put("Gps_Date", rs.getString("GPS_DATETIME").equals("") ? "" : sdf.format(sdfDB.parse(rs.getString("GPS_DATETIME"))));
				// jsonobject.put("Gps_Date", rs.getString("GPS_DATETIME"));
				jsonobject.put("Location", rs.getString("LOCATION"));
				jsonArray.put(jsonobject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jsonArray;
	}

	public JSONArray getLatLongs(int routeId, int systemId) {

		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			con = DBConnection.getConnectionToDB("AMS");
			jsonArray = new JSONArray();
			jsonObject = new JSONObject();
			pstmt = con.prepareStatement(GeneralVerticalStatements.GET_LAT_LONG_DHL);
			pstmt.setInt(1, routeId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				jsonObject = new JSONObject();
				jsonObject.put("sequence", rs.getString("Route_sequence"));
				jsonObject.put("lat", rs.getString("Latitude"));
				jsonObject.put("lon", rs.getString("Longitude"));
				jsonObject.put("type", rs.getString("TYPE"));
				jsonArray.put(jsonObject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jsonArray;

	}

	public JSONArray getHistoryInfo(String vehicleNo, String startDateTime, String endDateTime, int offset, int systemId) {

		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			con = DBConnection.getConnectionToDB("AMS");
			jsonArray = new JSONArray();
			jsonObject = new JSONObject();
			pstmt = con.prepareStatement(GeneralVerticalStatements.GET_HISTORY_TRACK_INFO.replace("HISTORY_DATA", "HISTORY_DATA_" + systemId).replace("GE_DATA", "GE_DATA_" + systemId));

			pstmt.setString(1, vehicleNo);
			pstmt.setInt(2, offset);
			pstmt.setString(3, sdfDB.format(sdf.parse(startDateTime)));
			pstmt.setInt(4, offset);
			pstmt.setString(5, sdfDB.format(sdf.parse(endDateTime)));

			pstmt.setString(6, vehicleNo);
			pstmt.setInt(7, offset);
			pstmt.setString(8, sdfDB.format(sdf.parse(startDateTime)));
			pstmt.setInt(9, offset);
			pstmt.setString(10, sdfDB.format(sdf.parse(endDateTime)));

			pstmt.setString(11, vehicleNo);
			pstmt.setInt(12, offset);
			pstmt.setString(13, sdfDB.format(sdf.parse(startDateTime)));
			pstmt.setInt(14, offset);
			pstmt.setString(15, sdfDB.format(sdf.parse(endDateTime)));
			rs = pstmt.executeQuery();
			while (rs.next()) {
				jsonObject = new JSONObject();
				jsonObject.put("lat", rs.getString("LATITUDE"));
				jsonObject.put("lon", rs.getString("LONGITUDE"));
				jsonObject.put("gmt", rs.getString("GMT"));
				jsonObject.put("type", rs.getString("TYPE"));
				jsonArray.put(jsonObject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jsonArray;
	}

	public String getFormattedDateStartingFromMonth(String inputDate) {
		String formattedDate = "";
		SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
		SimpleDateFormat sdfFormatDate = new SimpleDateFormat("MM/dd/yyyy HH:mm:ss");
		try {
			if (inputDate != null && !inputDate.equals("")) {
				java.util.Date d = sdf.parse(inputDate);
				formattedDate = sdfFormatDate.format(d);
			}
		} catch (Exception e) {
			System.out.println("Error in getFormattedDateStartingFromMonth() method" + e);
			e.printStackTrace();
		}
		return formattedDate;
	}

	public JSONArray getTripSummaryDetailsDHL(int systemId, int clientId, int offset, String groupId, String unit, int userId, String custId, String routeId, String tripStatus, String userAuthority,
			String startDateRange, String endDateRange, String custType, String tripType, String countFromJsp, String zone) {
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonobject = new JSONObject();

		Connection con = null;
		PreparedStatement pstmt = null, pstmt1 = null;
		ResultSet rs = null, rs1 = null;
		int count = 0;
		String condition = "";
		double distance = 0;
		double distanceNext = 0;
		String endDate = "";
		String closeDate = "";
		String tripStr = "", tripStrs = "";
		String Delay = "";
		String loadingD = "";
		String unloadingD = "";
		String custD = "";
		boolean isAdmin = ("Admin".equals(userAuthority)) ? true : false;
		try {
			jsonArray = new JSONArray();
			con = DBConnection.getConnectionToDB("AMS");
			String groupBy = " group by CUSTOMER_REF_ID,NEXT_POINT_DISTANCE,AVG_SPEED,STOPPAGE_DURATION,td.ROUTE_ID,td.TRIP_ID,td.SHIPMENT_ID,td.ASSET_NUMBER,td.CUSTOMER_NAME,td.DEST_ARR_TIME_ON_ATD,"
					+ "	 td.DRIVER_NAME,td.DRIVER_NUMBER,gps.LOCATION,NEXT_POINT,td.TRIP_START_TIME,td.ACTUAL_TRIP_START_TIME,td.NEXT_POINT_ETA,td.DESTINATION_ETA,ds.PLANNED_ARR_DATETIME,"
					+ "	 td.ACTUAL_DISTANCE,ds1.NAME,ds.NAME,td.STATUS,td.TRIP_STATUS,td.DELAY,ACTUAL_TRIP_END_TIME,ds.PLANNED_ARR_DATETIME,DESTINATION_ETA,ACTUAL_TRIP_START_TIME,ACT_SRC_ARR_DATETIME,"
					+ "	 ORDER_ID,vm.ModelName,td.ROUTE_NAME,ds1.PLANNED_ARR_DATETIME,ds1.ACT_ARR_DATETIME,ds.ACT_ARR_DATETIME,td.ACTUAL_DISTANCE,ds.ACT_DEP_DATETIME,"
					+ "	 td.FUEL_CONSUMED,td.MILEAGE,td.OBD_MILEAGE,td.NEXT_LEG,td.NEXT_LEG_ETA,ll0.HUB_CITY, ll1.HUB_CITY, ll0.HUB_STATE, ll1.HUB_STATE, u.Firstname,u.Lastname,vm.VehType,td.REMARKS,"
					+ "td.PRODUCT_LINE,td.TRIP_CATEGORY,trd.ROUTE_KEY,UNSCHEDULED_STOP_DUR,PLANNED_DURATION,ds1.DISTANCE_FLAG,ds1.DETENTION_TIME,ds.DETENTION_TIME,td.END_LOCATION,RED_DUR_T1,RED_DUR_T2,RED_DUR_T3,DISTANCE_TRAVELLED "
					+ " ,td.INSERTED_TIME,c.VehicleType,ACTUAL_DURATION,trd.TAT, rd.TRAVEL_TIME, td.TRIP_CUSTOMER_TYPE,gps.DRIVER_NAME,gps.DRIVER_MOBILE,custd.CUSTOMER_REFERENCE_ID, gps.GMT";

			String eventStrHubDetention = " and td.TRIP_ID in (select distinct TRIP_ID from DES_TRIP_DETAILS where  ACT_ARR_DATETIME is not null and SEQUENCE not in (0,100) and ACT_DEP_DATETIME is null "
					+ " and datediff(mi,ACT_ARR_DATETIME,isnull(ACT_DEP_DATETIME,getutcdate()))>isnull(DETENTION_TIME,0))";
			String eventQueryStoppage = " and td.TRIP_ID in (select distinct TRIP_ID from TRIP_EVENT_DETAILS where ALERT_TYPE=1) and gps.CATEGORY='stoppage' ";
			String eventQueryroutedEviation = "and td.TRIP_ID in (select distinct TRIP_ID from TRIP_EVENT_DETAILS a where ALERT_TYPE=5 and TRIP_ID not in (select TRIP_ID from TRIP_EVENT_DETAILS b where b.TRIP_ID=td.TRIP_ID and ALERT_TYPE=134 and b.GMT>a.GMT))";
			String eventQuerydelayedLateDeparture = " and td.STATUS='OPEN' and TRIP_STATUS='DELAYED' and ds.SEQUENCE=100 and (ACTUAL_TRIP_START_TIME>td.TRIP_START_TIME and (DATEDIFF(mi,isnull(td.DEST_ARR_TIME_ON_ATD,ds.PLANNED_ARR_DATETIME),DESTINATION_ETA) < DATEDIFF(mi,td.TRIP_START_TIME,ACTUAL_TRIP_START_TIME)))";
			String additionalconditionfordelay = " and td.TRIP_ID not in(  select td.TRIP_ID from AMS.dbo.TRACK_TRIP_DETAILS td "
					+ " inner join AMS.dbo.DES_TRIP_DETAILS dt  on td.TRIP_ID=dt.TRIP_ID where td.STATUS='OPEN' and td.TRIP_STATUS='DELAYED' and SEQUENCE=100 "
					+ " and (ACTUAL_TRIP_START_TIME>td.TRIP_START_TIME and DATEDIFF(mi,isnull(DEST_ARR_TIME_ON_ATD,PLANNED_ARR_DATETIME),DESTINATION_ETA) < DATEDIFF(mi,td.TRIP_START_TIME,ACTUAL_TRIP_START_TIME))) ";

			if (groupId.equals("0")) {
				condition = "and td.STATUS='OPEN'";
			} else if (groupId.equals("1")) {
				condition = "and td.TRIP_START_TIME between dateadd(dd,-2,getutcdate()) and getutcdate()";
			} else if (groupId.equals("2")) {
				condition = "and td.TRIP_START_TIME between dateadd(dd,-7,getutcdate()) and getutcdate()";
			} else if (groupId.equals("3")) {
				condition = "and td.TRIP_START_TIME between dateadd(dd,-15,getutcdate()) and getutcdate()";
			} else if (groupId.equals("4")) {
				condition = "and td.TRIP_START_TIME between dateadd(dd,-30,getutcdate()) and getutcdate()";
			} else if (groupId.equals("5")) {
				condition = "and td.TRIP_START_TIME between dateadd(mi,-330,'" + startDateRange + " 00:00:00') and dateadd(mi,-330,'" + endDateRange + " 23:59:59')";
			}

			if (tripStatus.equalsIgnoreCase("enrouteId")) {
				Delay = "";
				tripStatus = "ENROUTE PLACEMENT%";
				tripStr = "and td.TRIP_STATUS like '" + tripStatus + "'";
			} else if (tripStatus.equalsIgnoreCase("onTimeId")) {
				Delay = "";
				tripStatus = "ON TIME";
				tripStr = "and td.TRIP_STATUS = '" + tripStatus + "'";
			} else
			//Dhl BlueDart start table
			if (tripStatus.equalsIgnoreCase("delayedonetotwohour")) {
				Delay = "True";
				tripStatus = "DELAYED";
				tripStr = "and td.TRIP_STATUS = '" + tripStatus + "'" + " and isnull(DELAY,0)>60 and isnull(DELAY,0)<120 " + additionalconditionfordelay;
			} else if (tripStatus.equalsIgnoreCase("delayedtwotothreehour")) {
				Delay = "True";
				tripStatus = "DELAYED";
				tripStr = "and td.TRIP_STATUS = '" + tripStatus + "'" + " and isnull(DELAY,0)>120 and isnull(DELAY,0)<180 " + additionalconditionfordelay;
			} else if (tripStatus.equalsIgnoreCase("delayedthreetofivehour")) {
				Delay = "True";
				tripStatus = "DELAYED";
				tripStr = "and td.TRIP_STATUS = '" + tripStatus + "'" + " and isnull(DELAY,0)>180 and isnull(DELAY,0)<300 " + additionalconditionfordelay;
			} else if (tripStatus.equalsIgnoreCase("delayedmorethanfivehour")) {
				Delay = "True";
				tripStatus = "DELAYED";
				tripStr = "and td.TRIP_STATUS = '" + tripStatus + "'" + " and isnull(DELAY,0)>300 " + additionalconditionfordelay;
			} else ////////////
			if (tripStatus.equalsIgnoreCase("delayedonetotwohour-deviation")) {
				Delay = "";
				tripStatus = "DELAYED";
				tripStr = " and td.TRIP_STATUS = '" + tripStatus + "'" + " and isnull(DELAY,0)>60 and isnull(DELAY,0)<120 " + additionalconditionfordelay + eventQueryroutedEviation;
			} else if (tripStatus.equalsIgnoreCase("delayedonetotwohour-stoppage")) {
				Delay = "";
				tripStatus = "DELAYED";
				tripStr = " and td.TRIP_STATUS = '" + tripStatus + "'" + " and isnull(DELAY,0)>60 and isnull(DELAY,0)<120" + additionalconditionfordelay + eventQueryStoppage;
			} else if (tripStatus.equalsIgnoreCase("delayedtwotothreehour-deviation")) {
				Delay = "";
				tripStatus = "DELAYED";
				tripStr = " and td.TRIP_STATUS = '" + tripStatus + "'" + " and isnull(DELAY,0)>120 and isnull(DELAY,0)<180 " + additionalconditionfordelay + eventQueryroutedEviation;
			} else if (tripStatus.equalsIgnoreCase("delayedtwotothreehour-stoppage")) {
				Delay = "";
				tripStatus = "DELAYED";
				tripStr = " and td.TRIP_STATUS = '" + tripStatus + "'" + " and isnull(DELAY,0)>120 and isnull(DELAY,0)<180 " + additionalconditionfordelay + eventQueryStoppage;
			} else if (tripStatus.equalsIgnoreCase("delayedthreetofivehour-deviation")) {
				Delay = "";
				tripStatus = "DELAYED";
				tripStr = " and td.TRIP_STATUS = '" + tripStatus + "'" + " and isnull(DELAY,0)>180  and isnull(DELAY,0)<300" + additionalconditionfordelay + eventQueryroutedEviation;
			} else if (tripStatus.equalsIgnoreCase("delayedthreetofivehour-stoppage")) {
				Delay = "";
				tripStatus = "DELAYED";
				tripStr = " and td.TRIP_STATUS = '" + tripStatus + "'" + " and isnull(DELAY,0)>180 and isnull(DELAY,0)<300" + additionalconditionfordelay + eventQueryStoppage;
			} else if (tripStatus.equalsIgnoreCase("delayedmorethanfivehour-deviation")) {
				Delay = "";
				tripStatus = "DELAYED";
				tripStr = " and td.TRIP_STATUS = '" + tripStatus + "'" + " and isnull(DELAY,0)>300 " + additionalconditionfordelay + eventQueryroutedEviation;
			} else if (tripStatus.equalsIgnoreCase("delayedmorethanfivehour-stoppage")) {
				Delay = "";
				tripStatus = "DELAYED";
				tripStr = " and td.TRIP_STATUS = '" + tripStatus + "'" + " and isnull(DELAY,0)>300" + additionalconditionfordelay + eventQueryStoppage;
			} else

			//Dhl bluedart end table
			if (tripStatus.equalsIgnoreCase("delayedless1")) {
				Delay = "True";
				tripStatus = "DELAYED";
				tripStr = "and td.TRIP_STATUS = '" + tripStatus + "'" + "and isnull(DELAY,0)<60 " + additionalconditionfordelay;
			} else if (tripStatus.equalsIgnoreCase("delayedgreater1")) {
				Delay = "True";
				tripStatus = "DELAYED";
				tripStr = "and td.TRIP_STATUS = '" + tripStatus + "'" + "and isnull(DELAY,0)>60 " + additionalconditionfordelay;
			} else if (tripStatus.equalsIgnoreCase("enrouteId-Ontime")) {
				Delay = "";
				tripStatus = "ENROUTE PLACEMENT ON TIME";
				tripStr = "and td.TRIP_STATUS = '" + tripStatus + "'";
			} else if (tripStatus.equalsIgnoreCase("enrouteId-delay")) {
				Delay = "";
				tripStatus = "ENROUTE PLACEMENT DELAYED";
				tripStr = "and td.TRIP_STATUS = '" + tripStatus + "'";
			} else if (tripStatus.equalsIgnoreCase("loading-detention")) {
				Delay = "";
				tripStatus = "LOADING DETENTION";
				tripStr = "and td.TRIP_STATUS = '" + tripStatus + "'";
			} else if (tripStatus.equalsIgnoreCase("unloading-detention")) {
				Delay = "";
				tripStatus = "UNLOADING DETENTION";
				tripStr = "and TRIP_STATUS = '" + tripStatus + "'";
			} else if (tripStatus.equalsIgnoreCase("delay-late-departure")) {
				Delay = "True";
				tripStatus = "DELAYED LATE DEPARTURE";
				tripStrs = " " + eventQuerydelayedLateDeparture;
			} // EVENT QUERIES
			// ONTIME
			else if (tripStatus.equalsIgnoreCase("onTimeId-hubhetention")) {
				Delay = "";
				tripStatus = "ON TIME";
				tripStr = " and td.TRIP_STATUS = '" + tripStatus + "'" + eventStrHubDetention;
			} else if (tripStatus.equalsIgnoreCase("onTimeId-stoppage")) {
				Delay = "";
				tripStatus = "ON TIME";
				tripStr = " and td.TRIP_STATUS = '" + tripStatus + "'" + eventQueryStoppage;
			} else if (tripStatus.equalsIgnoreCase("onTimeId-deviation")) {
				Delay = "";
				tripStatus = "ON TIME";
				tripStr = " and td.TRIP_STATUS = '" + tripStatus + "'" + eventQueryroutedEviation;
			}
			// DELAYED<1HR
			else if (tripStatus.equalsIgnoreCase("delayedless1-detention")) {
				Delay = "";
				tripStatus = "DELAYED";
				tripStr = " and td.TRIP_STATUS = '" + tripStatus + "'" + "and isnull(DELAY,0)<60" + additionalconditionfordelay + eventStrHubDetention;
			} else if (tripStatus.equalsIgnoreCase("delayedless1-stoppage")) {
				Delay = "";
				tripStatus = "DELAYED";
				tripStr = " and td.TRIP_STATUS = '" + tripStatus + "'" + "and isnull(DELAY,0)<60" + additionalconditionfordelay + eventQueryStoppage;
			} else if (tripStatus.equalsIgnoreCase("delayedless1-deviation")) {
				Delay = "";
				tripStatus = "DELAYED";
				tripStr = " and td.TRIP_STATUS = '" + tripStatus + "'" + "and isnull(DELAY,0)<60" + additionalconditionfordelay + eventQueryroutedEviation;
			}
			// DELAYED>1HR
			else if (tripStatus.equalsIgnoreCase("delayedgreater1-detention")) {
				Delay = "";
				tripStatus = "DELAYED";
				tripStr = " and td.TRIP_STATUS = '" + tripStatus + "'" + "and isnull(DELAY,0)>60" + additionalconditionfordelay + eventStrHubDetention;
			} else if (tripStatus.equalsIgnoreCase("delayedgreater1-stoppage")) {
				Delay = "";
				tripStatus = "DELAYED";
				tripStr = " and td.TRIP_STATUS = '" + tripStatus + "'" + "and isnull(DELAY,0)>60" + additionalconditionfordelay + eventQueryStoppage;
			} else if (tripStatus.equalsIgnoreCase("delayedgreater1-deviation")) {
				Delay = "";
				tripStatus = "DELAYED";
				tripStr = " and td.TRIP_STATUS = '" + tripStatus + "'" + "and isnull(DELAY,0)>60" + additionalconditionfordelay + eventQueryroutedEviation;
			} else {
				Delay = "";
				// tripStr="and td.TRIP_STATUS <> 'NEW'";
				tripStr = "";
			}
			String stmt = "";

			if (tripStatus.equalsIgnoreCase("DELAYED") && Delay.equalsIgnoreCase("True")) {
				stmt = GeneralVerticalStatements.GET_TRIP_SUMMARY_DETAILS_DHL_DELAY.replace("&", condition).concat(tripStr).replaceAll("330", "" + offset).replaceAll("AMS.dbo.LOCATION",
						"AMS.dbo.LOCATION_ZONE_" + zone);

			} else if (tripStatus.equalsIgnoreCase("DELAYED LATE DEPARTURE")) {
				stmt = GeneralVerticalStatements.GET_TRIP_SUMMARY_DETAILS_DHL.replace("&", condition).concat(tripStr).concat(tripStrs).replaceAll("330", "" + offset).replaceAll("AMS.dbo.LOCATION",
						"AMS.dbo.LOCATION_ZONE_" + zone);
			} else {
				stmt = GeneralVerticalStatements.GET_TRIP_SUMMARY_DETAILS_DHL.replace("&", condition).concat(tripStr).replaceAll("330", "" + offset).replaceAll("AMS.dbo.LOCATION",
						"AMS.dbo.LOCATION_ZONE_" + zone);
			}

			if (routeId.equals("ALL")) {
				stmt = stmt.replace("#", "");
			} else {
				routeId = routeId.substring(0, routeId.length() - 1);
				stmt = stmt.replace("#", "and td.ROUTE_ID in (" + routeId + ")");
			}
			if (custId.equals("ALL")) {
				stmt = stmt.replace("$", "");
			} else {
				custId = custId.substring(0, custId.length() - 1);
				stmt = stmt.replace("$", "and td.TRIP_CUSTOMER_ID in (" + custId + ")");
			}
			if (custType.equals("ALL")) {
				stmt = stmt.replace("custTypeCondition", "");
			} else {
				custType = custType.substring(0, custType.length() - 1);
				stmt = stmt.replace("custTypeCondition", "and td.TRIP_CUSTOMER_TYPE in (" + custType + ")");
			}
			if (tripType.equals("ALL")) {
				stmt = stmt.replace("tripTypeCondition", "");
			} else {
				tripType = tripType.substring(0, tripType.length() - 1);
				stmt = stmt.replace("tripTypeCondition", "and td.PRODUCT_LINE in (" + tripType + ")");
			}
			if (countFromJsp != null && Integer.parseInt(countFromJsp) > 0) {
				pstmt = con.prepareStatement(stmt + " " + groupBy + " order by td.TRIP_ID desc");
				pstmt.setInt(1, offset);
				pstmt.setInt(2, offset);
				pstmt.setInt(3, offset);
				pstmt.setInt(4, offset);
				pstmt.setInt(5, offset);
				pstmt.setInt(6, offset);
				pstmt.setInt(7, offset);
				pstmt.setInt(8, offset);
				pstmt.setInt(9, offset);
				pstmt.setInt(10, offset);
				pstmt.setInt(11, offset);
				pstmt.setInt(12, offset);
				pstmt.setInt(13, offset);
				pstmt.setInt(14, offset);
				pstmt.setInt(15, offset);
				pstmt.setInt(16, systemId);
				pstmt.setInt(17, clientId);
			} else {
				pstmt = con.prepareStatement(GeneralVerticalStatements.GET_LISTVIEW_TRIP_DETAILS);
			}
			rs = pstmt.executeQuery();
			while (rs.next()) {

				endDate = "";
				closeDate = "";
				count++;
				String STD = "";
				if (!rs.getString("STD").contains("1900")) {
					// System.out.println(rs.getInt("ID"));
					STD = mmddyyy.format(sdfDB.parse(rs.getString("STD")));
				}
				String ATD = "";
				if (!rs.getString("ATD").contains("1900")) {
					ATD = mmddyyy.format(sdfDB.parse(rs.getString("ATD")));
				}
				String ETHA = "";
				if (!rs.getString("ETHA").contains("1900")) {
					ETHA = mmddyyy.format(sdfDB.parse(rs.getString("ETHA")));
				}
				String ETA = "";
				if (!rs.getString("ETA").contains("1900")) {
					ETA = mmddyyy.format(sdfDB.parse(rs.getString("ETA")));
				}
				String STA = "";
				if (!rs.getString("STA").contains("1900")) {
					STA = mmddyyy.format(sdfDB.parse(rs.getString("STA")));
				}
				String STA_ON_ATD = STA;
				if (!rs.getString("STA_ON_ATD").contains("1900")) {
					STA_ON_ATD = mmddyyy.format(sdfDB.parse(rs.getString("STA_ON_ATD")));
				}

				String ATP = "";
				if (!rs.getString("ATP").contains("1900")) {
					ATP = mmddyyy.format(sdfDB.parse(rs.getString("ATP")));
				}

				String STP = "";
				if (!rs.getString("STP").contains("1900")) {
					STP = mmddyyy.format(sdfDB.parse(rs.getString("STP")));
				}

				String ATA = "";
				if (!rs.getString("ATA").contains("1900")) {
					ATA = mmddyyy.format(sdfDB.parse(rs.getString("ATA")));
				}
				String InsertedTime = "";
				if (!rs.getString("INSERTED_TIME").contains("1900")) {
					InsertedTime = mmddyyy.format(sdfDB.parse(rs.getString("INSERTED_TIME")));
				}
				int tripNO = Integer.parseInt(rs.getString("TRIP_NO"));

				String driver1 = "";
				String driver2 = "";
				String driverNumber1 = "";
				String driverNumber2 = "";
				
				String driverString = rs.getString("DRIVER_NAME").trim();
				String driverNumberString = rs.getString("DRIVER_NUMBER").trim();
				try {
					if (!driverString.equals("") && driverString.length() > 1 && driverString.contains("/")) {
						String[] drivers = {};
						drivers = driverString.split("/");
						driver1 = drivers[0];
						if(driverString.substring(driverString.indexOf("/"),driverString.length()).trim().length() > 1){
							driver2 = drivers[1];
						}
					}
				} catch (Exception e) {
				}
				try{
					if (!driverNumberString.equals("") && driverNumberString.length() > 1 && driverNumberString.contains("/")) {
						String[] driverNumbers = {};
						driverNumbers = driverNumberString.split("/");
						driverNumber1 = driverNumbers[0];
						if(driverString.substring(driverString.indexOf("/"),driverString.length()).trim().length() > 1){
							driverNumber2 = driverNumbers[1];
						}	
					}
				} catch (Exception e) {
				}

				jsonobject = new JSONObject();
				jsonobject.put("slNo", count);
				jsonobject.put("tripNo", tripNO);
				jsonobject.put("ShipmentId", "<p><a href=\"#\"  onclick='javascript:showTripAndAlertDetails()'>" + rs.getString("TRIP_ID") + "</a></p>");
				jsonobject.put("tripType", rs.getString("PRODUCT_LINE"));
				jsonobject.put("tripCategory", rs.getString("TRIP_CATEGORY"));
				jsonobject.put("tripCreationTime", InsertedTime);
				jsonobject.put("tripCreationMonth", new SimpleDateFormat("MMMM").format(sdfDB.parse(rs.getString("INSERTED_TIME"))));
				jsonobject.put("routeName", rs.getString("ROUTE_NAME"));
				jsonobject.put("vehicleNo", rs.getString("VEHICLE_NO"));
				jsonobject.put("make", rs.getString("MAKE"));
				jsonobject.put("typeOfVehicle", rs.getString("VehicleType"));
				String param = tripNO+",'"+rs.getString("STATUS").replace(" ", "")+"'";
				jsonobject.put("lrNo", "<p><a href=\"#\" onclick=javascript:showCEDashboard("+param+")>"+rs.getString("LR_NO")+"</a></p>");
				jsonobject.put("custRefId", rs.getString("CUSTOMER_REF_ID"));
				jsonobject.put("customerName", rs.getString("CUSTOMER_NAME"));
				jsonobject.put("customerType", rs.getString("TRIP_CUSTOMER_TYPE"));
				jsonobject.put("driverName", rs.getString("DRIVER_NAME"));
				jsonobject.put("driverContact", rs.getString("DRIVER_NUMBER"));
				jsonobject.put("driver1Name", driver1);
				jsonobject.put("driver1Contact", driverNumber1);
				jsonobject.put("driver2Name", driver2);
				jsonobject.put("driver2Contact", driverNumber2);
				jsonobject.put("Location", rs.getString("LOCATION"));
				jsonobject.put("routeKey", rs.getString("RouteKey"));
				jsonobject.put("originCity", rs.getString("OriginCity"));
				jsonobject.put("destinationCity", rs.getString("DestinationCity"));
				jsonobject.put("origin", rs.getString("ORIGIN"));
				jsonobject.put("Destination", rs.getString("DESTINATION"));
				jsonobject.put("origin", rs.getString("ORIGIN"));
				jsonobject.put("Destination", rs.getString("DESTINATION"));
				jsonobject.put("OriginCity", rs.getString("ORG_City").toUpperCase());
				jsonobject.put("OriginState", rs.getString("ORG_STATE").toUpperCase());
				jsonobject.put("DestCity", rs.getString("DEST_CITY").toUpperCase());
				jsonobject.put("DestState", rs.getString("DEST_STATE").toUpperCase());
				jsonobject.put("status", rs.getString("STATUS"));
				jsonobject.put("vehicleLength", rs.getString("VEHICLE_LENGTH"));

				jsonobject.put("STP", STP);
				jsonobject.put("ATP", ATP);
				jsonobject.put("STD", STD);
				jsonobject.put("ATD", ATD);

				if (rs.getString("delayedDepartureATD_STD") != null && !rs.getString("delayedDepartureATD_STD").equals("")) {
					if (rs.getInt("delayedDepartureATD_STD") < 0) {
						jsonobject.put("departureDelayWrtSTD", "-" + cf.convertMinutesToHHMMSSFormat(-Integer.parseInt(rs.getString("delayedDepartureATD_STD"))));// Departure
						// Delay
						// wrt
						// STD(ATD-STD)
						// New
						// field
					} else {
						jsonobject.put("departureDelayWrtSTD", cf.convertMinutesToHHMMSSFormat(Integer.parseInt(rs.getString("delayedDepartureATD_STD"))));// Departure
						// Delay
						// wrt
						// STD(ATD-STD)
						// New
						// field
					}
				} else {
					jsonobject.put("departureDelayWrtSTD", "");
				}

				jsonobject.put("nearestHub", rs.getString("NEAREST_HUB"));
				distanceNext = rs.getDouble("DISTANCE_TO_NEXTHUB");
				if (unit.equals("Miles")) {
					distanceNext = rs.getDouble("DISTANCE_TO_NEXTHUB") * 0.621371;
				}
				jsonobject.put("distanceToNextHub", df.format(distanceNext));
				jsonobject.put("ETHA", ETHA);
				jsonobject.put("ETA", ETA);
				jsonobject.put("STA (WRT STD)", STA);
				jsonobject.put("STA (WRT ATD)", STA_ON_ATD);
				jsonobject.put("ATA", ATA);
				String delayS = cf.convertMinutesToHHMMSSFormat(rs.getInt("transitDelay"));
				String delayE = "-" + cf.convertMinutesToHHMMSSFormat(-rs.getInt("transitDelay"));

				if (rs.getString("STATUS").contains("OPEN")) {
					String td = getTransitDealy(tripStatus, ETA, STA_ON_ATD);
					jsonobject.put("delay", td);

				} else {
					if (rs.getInt("transitDelay") < 0) {
						jsonobject.put("delay", delayE);

					} else {
						jsonobject.put("delay", delayS);
					}
				}
				double avgSpped = rs.getDouble("AVG_SPEED");
				if (unit.equals("Miles")) {
					avgSpped = rs.getDouble("AVG_SPEED") * 0.621371;
				}
				jsonobject.put("avgSpeed", df.format(avgSpped));
				String stoppageTime = cf.convertMinutesToHHMMSSFormat(rs.getInt("STOPPAGE_TIME"));
				jsonobject.put("stoppageTime", stoppageTime);

				distance = rs.getDouble("TOTAL_DISTANCE");
				if (unit.equals("Miles")) {
					distance = rs.getDouble("TOTAL_DISTANCE") * 0.621371;
				}
				jsonobject.put("totalDist", df.format(distance));
				if (rs.getInt("PLACEMENT_DELAY") < 0) {
					jsonobject.put("placementDelay", "-" + cf.convertMinutesToHHMMSSFormat(-rs.getInt("PLACEMENT_DELAY")));
				} else {
					jsonobject.put("placementDelay", cf.convertMinutesToHHMMSSFormat(rs.getInt("PLACEMENT_DELAY")));
				}
				if (rs.getInt("LOADING_DETENTION") < 0) {
					loadingD = "-" + cf.convertMinutesToHHMMSSFormat(-rs.getInt("LOADING_DETENTION"));
				} else {
					loadingD = cf.convertMinutesToHHMMSSFormat(rs.getInt("LOADING_DETENTION"));
				}
				if (rs.getInt("UNLOADING_DETENTION") < 0) {
					unloadingD = "-" + cf.convertMinutesToHHMMSSFormat(-rs.getInt("UNLOADING_DETENTION"));
				} else {
					unloadingD = cf.convertMinutesToHHMMSSFormat(rs.getInt("UNLOADING_DETENTION"));
				}
				int custDete = rs.getInt("LOADING_DETENTION") + rs.getInt("UNLOADING_DETENTION");
				if (custDete < 0) {
					custD = "00:00";
				} else {
					custD = cf.convertMinutesToHHMMSSFormat(custDete);
				}
				jsonobject.put("reasonForCancel", rs.getString("CANCELLED_REMARKS"));// New field
				jsonobject.put("customerDetentionTime", custD);
				jsonobject.put("loadingDetentionTime", loadingD);
				jsonobject.put("unloadingDetentionTime", unloadingD);

				if (rs.getString("UNSCHEDULED_STOP_DUR") == null || rs.getString("UNSCHEDULED_STOP_DUR").equals("") || rs.getInt("UNSCHEDULED_STOP_DUR") < 0) {
					jsonobject.put("unplannedStoppage", "00:00:00");
				} else {
					jsonobject.put("unplannedStoppage", cf.convertMinutesToHHMMSSFormat(rs.getInt("UNSCHEDULED_STOP_DUR")));// new
					// field
				}
				if (rs.getString("totalTruckRunningTime") != null && !rs.getString("totalTruckRunningTime").equals("")) {
					if (rs.getInt("totalTruckRunningTime") < 0) {
						jsonobject.put("totalTruckRunningTime", "");
					} else {
						jsonobject.put("totalTruckRunningTime", cf.convertMinutesToHHMMSSFormat(rs.getInt("totalTruckRunningTime")));
					}
				} else {
					jsonobject.put("totalTruckRunningTime", "");
				}

				String flag = "";
				if (rs.getString("FLAG").equalsIgnoreCase("GREEN")) {
					flag = " <div class='location-icon'><img src='/ApplicationImages/VehicleImages/startflag.png'></div> ";
				} else if (rs.getString("FLAG").equalsIgnoreCase("RED")) {
					flag = " <div class='location-icon'><img src='/ApplicationImages/VehicleImages/endflag.png'></div> ";
				}
				jsonobject.put("flag", flag);
				jsonobject.put("weather", "");
				if (!rs.getString("endDate").contains("1900")) {
					endDate = mmddyyy.format(sdfDB.parse(rs.getString("endDate")));
				}
				if (!rs.getString("endDate1").contains("1900")) {
					closeDate = mmddyyy.format(sdfDB.parse(rs.getString("endDate1")));
				}
				String RouteId = rs.getString("ROUTE_ID");
				jsonobject.put("endDateHidden", endDate);
				jsonobject.put("closeDate", closeDate);
				jsonobject.put("routeIdHidden", RouteId);
				jsonobject.put("panicAlert", "<p><a href=\"#\" onclick=loadEvents('3','Panic'," + rs.getString("TRIP_NO") + ");>" + rs.getInt("PANIC_COUNT") + "</a></p>");
				jsonobject.put("doorAlert", "<p><a href=\"#\" onclick=loadEvents('38','Door'," + rs.getString("TRIP_NO") + ");>" + rs.getInt("DOOR_COUNT") + "</a></p>");
				jsonobject.put("nonReporting", "<p><a href=\"#\" onclick=loadEvents('85','Non-Reporting'," + rs.getString("TRIP_NO") + ");>" + rs.getInt("NON_REPORTING_COUNT") + "</a></p>");
				jsonobject.put("fuelConsumed", df.format(rs.getDouble("fuelConsumed")));
				jsonobject.put("insertedby", rs.getString("INSERTED_BY"));
				if (rs.getString("TEMP_REEFER_PERCENT") != null && !rs.getString("TEMP_REEFER_PERCENT").equals("0.00")) {
					jsonobject.put("tempT1", rs.getString("TEMP_REEFER_PERCENT"));
				} else {
					jsonobject.put("tempT1", "");
				}
				if (rs.getString("TEMP_MIDDLE_PERCENT") != null && !rs.getString("TEMP_MIDDLE_PERCENT").equals("0.00")) {
					jsonobject.put("tempT2", rs.getString("TEMP_MIDDLE_PERCENT"));
				} else {
					jsonobject.put("tempT2", "");
				}
				if (rs.getString("TEMP_DOOR_PERCENT") != null && !rs.getString("TEMP_DOOR_PERCENT").equals("0.00")) {
					jsonobject.put("tempT3", rs.getString("TEMP_DOOR_PERCENT"));
				} else {
					jsonobject.put("tempT3", "");
				}
				Integer totalTripTimeATAATD = 0;
				if ((!ATA.equals("")) && (!ATD.equals(""))) {
					totalTripTimeATAATD = rs.getInt("TOTAL_TRIP_TIME_ATA_ATD");
					totalTripTimeATAATD = totalTripTimeATAATD < 0 ? 0 : totalTripTimeATAATD;
				}
				jsonobject.put("totalTripTimeATAATD", cf.convertMinutesToHHMMSSFormat(totalTripTimeATAATD));
				jsonobject.put("mileage", df.format(rs.getDouble("MILEAGE")));
				jsonobject.put("mileageOBD", df.format(rs.getDouble("OBD_MILEAGE")));
				if (isAdmin) {
					jsonobject.put("remarks", "<div class='col-lg-1 col-md-1 col-xs-1' style='white-space: nowrap'><button id='addBtnId' onclick=addRemarks(" + rs.getString("TRIP_CUSTOMER_REF_ID")
							+ "); class='btn btn-info btn-sm text-center'>Add Remarks</button><button id='viewBtnId' onclick=viewRemarks(" + rs.getString("TRIP_NO")
							+ "); class='btn btn-info btn-sm text-center' style='margin-left:6px;width:86px;'>View</button></div>");
				} else {
					jsonobject.put("remarks", "<div></div>");
				}
				String nextLegETA = "";
				if (!rs.getString("NEXT_LEG_ETA").contains("1900")) {
					nextLegETA = sdf.format(sdfDB.parse(rs.getString("NEXT_LEG_ETA")));
				}
				jsonobject.put("nextLeg", rs.getString("NEXT_LEG"));
				jsonobject.put("nextLegETA", nextLegETA);
				jsonobject.put("viewbutton", "<button id='viewBtnId' onclick=view(" + rs.getString("TRIP_NO") + "); class='btn btn-info btn-sm text-center'>View Remarks</button>");
				jsonobject.put("distanceFlag", rs.getString("DISTANCE_FLAG"));

				String atS = cf.convertMinutesToHHMMSSFormat(rs.getInt("ACTUAL_TRANSIT_TIME"));
				String atE = "-" + cf.convertMinutesToHHMMSSFormat(-rs.getInt("ACTUAL_TRANSIT_TIME"));
				if (rs.getInt("ACTUAL_TRANSIT_TIME") < 0) {
					jsonobject.put("actualTT", atE);
				} else {
					jsonobject.put("actualTT", atS);
				}

				String ptS = cf.convertMinutesToHHMMSSFormat(rs.getInt("PLANNED_TRANSIT_TIME"));
				String ptE = "-" + cf.convertMinutesToHHMMSSFormat(-rs.getInt("PLANNED_TRANSIT_TIME"));
				if (rs.getInt("PLANNED_TRANSIT_TIME") < 0) {
					jsonobject.put("plannedTT", ptE);
				} else {
					jsonobject.put("plannedTT", ptS);
				}

				// getLegDetailsForTrip(offset, jsonobject, rs, tripNO);

				//LASTCOMMUNICATIONSTAMP		
				String LAST_COMMUNICATION_STAMP = "";

				//String LEGSTD = "";
				if (!rs.getString("LAST_COMMUNICATION_STAMP").contains("1900")) {
					LAST_COMMUNICATION_STAMP = mmddyyy.format(sdfDB.parse(rs.getString("LAST_COMMUNICATION_STAMP")));
				}

				//LAST_COMMUNICATION_STAMP = mmddyyy.format(sdfDB.parse(rs.getString("LAST_COMMUNICATION_STAMP")));

				jsonobject.put("lastCommunicationStamp", LAST_COMMUNICATION_STAMP);

				jsonArray.put(jsonobject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
			DBConnection.releaseConnectionToDB(con, pstmt1, rs1);
		}
		return jsonArray;
	}

	public JSONArray getLegDetailsForTrip(int offset, String tripNO, String tripStatus, String delay, String zone) {
		JSONArray legDetailsArray = new JSONArray();
		JSONObject legDetailsObject = null;
		Connection con = null;
		PreparedStatement pstmt1 = null;
		ResultSet rs1 = null;
		String legGroupBy = " group by tl.LEG_ID , LEG_NAME, lz.NAME,lz1.NAME ,STD ,STA ,ACTUAL_ARRIVAL,ACTUAL_DEPARTURE,tl.TOTAL_DISTANCE ,tl.AVG_SPEED,tl.FUEL_CONSUMED,tl.MILEAGE, "
				+ " tl.OBD_MILEAGE,ACTUAL_ARRIVAL,ACTUAL_DEPARTURE,d.Fullname,d1.Fullname,ETA,tdd.GREEN_BAND_SPEED_PERC,tdd.GREEN_RPM_PERC,d.Mobile,d1.Mobile,tl.ID,lm.TAT "
				+ " ,lm.DISTANCE,lz.Standard_Duration,lz1.Standard_Duration ";

		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt1 = con.prepareStatement(GeneralVerticalStatements.GET_TRIP_SUMMARY_REPORT_LEG_DETAILS.replaceAll("AMS.dbo.LOCATION", "AMS.dbo.LOCATION_ZONE_" + zone)

			+ legGroupBy + " order by tl.ID ");
			pstmt1.setInt(1, offset);
			pstmt1.setInt(2, offset);
			pstmt1.setInt(3, offset);
			pstmt1.setInt(4, offset);
			pstmt1.setInt(5, offset);
			pstmt1.setInt(6, Integer.parseInt(tripNO));
			rs1 = pstmt1.executeQuery();
			int legsequence = 0;
			while (rs1.next()) {

				long plannedTransitTime = rs1.getInt("plannedTransitTime");
				long actualTransitTime = rs1.getInt("actualTransitTime");
				long Legdistance = rs1.getLong("DISTANCE");
				long transitDealy = (actualTransitTime != 0) ? (actualTransitTime - plannedTransitTime) : 0;

				legsequence++;
				legDetailsObject = new JSONObject();
				legDetailsObject.put("LegName", rs1.getString("LEG_NAME"));
				legDetailsObject.put("Source", rs1.getString("SOURCE"));
				legDetailsObject.put("Destination", rs1.getString("DESTIANTION"));
				String STAwrtATD = "";

				String LEGSTD = "";
				if (!rs1.getString("STD").contains("1900")) {
					LEGSTD = mmddyyy.format(sdfDB.parse(rs1.getString("STD")));
				}
				String LEGSTA = "";
				if (!rs1.getString("STA").contains("1900")) {
					LEGSTA = mmddyyy.format(sdfDB.parse(rs1.getString("STA")));
				}
				String LEGATD = "";
				if (!rs1.getString("ATD").contains("1900")) {
					LEGATD = mmddyyy.format(sdfDB.parse(rs1.getString("ATD")));
					STAwrtATD = getDate(rs1.getString("ATD"), plannedTransitTime);
				}
				String LEGATA = "";
				if (!rs1.getString("ATA").contains("1900")) {
					LEGATA = mmddyyy.format(sdfDB.parse(rs1.getString("ATA")));
				}

				legDetailsObject.put("STD", LEGSTD);
				legDetailsObject.put("STA", LEGSTA);
				legDetailsObject.put("ATA", LEGATA);
				legDetailsObject.put("ATD", LEGATD);
				legDetailsObject.put("TotalDistance", rs1.getString("TOTAL_DISTANCE"));
				legDetailsObject.put("AvgSpeed", rs1.getString("AVG_SPEED"));
				legDetailsObject.put("FuelConsumed", rs1.getString("FUEL_CONSUMED"));
				legDetailsObject.put("Mileage", rs1.getString("MILEAGE"));
				legDetailsObject.put("OBDMileage", rs1.getString("OBD_MILEAGE"));
				legDetailsObject.put("TravelDuration", cf.convertMinutesToHHMMSSFormat(rs1.getInt("TRAVEL_DURATION")));
				legDetailsObject.put("Driver1", rs1.getString("DRIVER1"));
				legDetailsObject.put("Driver2", rs1.getString("DRIVER2"));
				legDetailsObject.put("driver1Contact", rs1.getString("DRIVER1_CONTACT"));
				legDetailsObject.put("driver2Contact", rs1.getString("DRIVER2_CONTACT"));
				legDetailsObject.put("DepartureDelaywrtSTD", delay);
				String LEGETA = "";
				if (!rs1.getString("ETA").contains("1900")) {
					LEGETA = mmddyyy.format(sdfDB.parse(rs1.getString("ETA")));
				}
				legDetailsObject.put("ETA", LEGETA);
				legDetailsObject.put("PlannedTransitTime", (plannedTransitTime != 0) ? formattedHoursMinutesSeconds(plannedTransitTime) : "");
				legDetailsObject.put("ActualTransitTime", (actualTransitTime != 0) ? formattedHoursMinutesSeconds(actualTransitTime) : "");
				legDetailsObject.put("STAwrtATD", STAwrtATD);
				legDetailsObject.put("TransitDelay", (transitDealy != 0) ? formattedHoursMinutesSeconds(transitDealy) : "");
				legDetailsObject.put("LegDistance", (Legdistance != 0) ? Legdistance : "");
				legDetailsObject.put("Tripstatus", tripStatus);

				legDetailsArray.put(legDetailsObject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt1, rs1);
		}
		return legDetailsArray;
	}
	public Map<ArrayList<Integer>, ArrayList<String>> getList(Connection con, int systemId, int customerId, int userId,String pageName) {
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		ArrayList<Integer> arrayList = null;
		ArrayList<String> colList = null;
		Map<ArrayList<Integer>, ArrayList<String>> hiddenMapping = null;
		boolean isUserSet = false;
		try {
			arrayList = new ArrayList<Integer>();
			colList = new ArrayList<String>();
			pstmt = con
					.prepareStatement(" select COLUMN_NAME,VISIBILITY from LIST_VIEW_COLUMN_SETTING  WHERE PAGE_NAME=? and SYSTEM_ID=? and CUSTOMER_ID=?  and USER_ID=? ORDER BY DISPLAY_ORDER ");
			pstmt.setString(1, pageName);
			pstmt.setInt(2, systemId);
			pstmt.setInt(3, customerId);
			pstmt.setInt(4, userId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				isUserSet = true;
				int visiblity = rs.getInt("VISIBILITY");
				arrayList.add(visiblity);
				if (visiblity == 1) {
					colList.add(rs.getString("COLUMN_NAME"));
				}
			}
			if (isUserSet) {
				hiddenMapping = new HashMap<ArrayList<Integer>, ArrayList<String>>();
				hiddenMapping.put(arrayList, colList);
			}

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(null, pstmt, rs);
		}
		return hiddenMapping;
	}
	private String getConditionForTripQuery(String type, int range, String startDate, String endDate) {
		String condition = " and td.STATUS='OPEN'";
		if ("enrouteTotal".equalsIgnoreCase(type)) {
			condition = " and td.TRIP_STATUS like 'ENROUTE PLACEMENT%' ";
		} else if ("enrouteOntime".equalsIgnoreCase(type)) {
			condition = " and td.TRIP_STATUS = 'ENROUTE PLACEMENT ON TIME' ";
		} else if ("enrouteDelayed".equalsIgnoreCase(type)) {
			condition = " and td.TRIP_STATUS  = 'ENROUTE PLACEMENT DELAYED' ";
		} else if ("onTimeLoading".equalsIgnoreCase(type)) {
			condition = " and td.TRIP_STATUS='ON TIME' and td.ACT_SRC_ARR_DATETIME is not null and ACTUAL_TRIP_START_TIME is null ";
		} else if ("onTimeIntransit".equalsIgnoreCase(type)) {
			condition = " and td.TRIP_STATUS='ON TIME' and td.ACTUAL_TRIP_START_TIME is not null and ds.ACT_ARR_DATETIME is null ";
		} else if ("onTimeUnLoading".equalsIgnoreCase(type)) {
			condition = " and td.TRIP_STATUS='ON TIME' and ds.ACT_ARR_DATETIME is not null and td.ACTUAL_TRIP_END_TIME is null ";
		} else if ("delayedLessLoading".equalsIgnoreCase(type)) {
			condition = " and td.TRIP_STATUS='DELAYED' and td.DELAY <= 60 and td.ACT_SRC_ARR_DATETIME is not null and ACTUAL_TRIP_START_TIME is null ";
		} else if ("delayedLessIntransit".equalsIgnoreCase(type)) {
			condition = " and td.TRIP_STATUS='DELAYED' and td.DELAY <= 60 and td.ACTUAL_TRIP_START_TIME is not null and ds.ACT_ARR_DATETIME is null ";
		} else if ("delayedLessUnLoading".equalsIgnoreCase(type)) {
			condition = " and td.TRIP_STATUS='DELAYED' and td.DELAY <= 60 and ds.ACT_ARR_DATETIME is not null and td.ACTUAL_TRIP_END_TIME is null ";
		} else if ("delayedGreaterLoading".equalsIgnoreCase(type)) {
			condition = " and td.TRIP_STATUS='DELAYED' and td.DELAY > 60 and td.ACT_SRC_ARR_DATETIME is not null and ACTUAL_TRIP_START_TIME is null ";
		} else if ("delayedGreaterIntransit".equalsIgnoreCase(type)) {
			condition = " and td.TRIP_STATUS='DELAYED' and td.DELAY > 60 and td.ACTUAL_TRIP_START_TIME is not null and ds.ACT_ARR_DATETIME is null ";
		} else if ("delayedGreaterUnloading".equalsIgnoreCase(type)) {
			condition = " and td.TRIP_STATUS='DELAYED' and td.DELAY > 60 and ds.ACT_ARR_DATETIME is not null and td.ACTUAL_TRIP_END_TIME is null ";
		} else if ("loadingDetention".equalsIgnoreCase(type)) {
			condition = " and td.TRIP_STATUS='LOADING DETENTION' ";
		} else if ("unloadingDetention".equalsIgnoreCase(type)) {
			condition = " and td.TRIP_STATUS='UNLOADING DETENTION' ";
		} else if ("departureLateDelay".equalsIgnoreCase(type)) {
			condition = " and td.TRIP_STATUS='DELAYED LATE DEPARTURE' ";
		} else if ("totalOntime".equalsIgnoreCase(type)) {
			condition = " and td.TRIP_STATUS='ON TIME' ";
		} else if ("totalDelayedLess".equalsIgnoreCase(type)) {
			condition = " and td.TRIP_STATUS='DELAYED' and td.DELAY <= 60 ";
		} else if ("totalDelayedGreater".equalsIgnoreCase(type)) {
			condition = " and td.TRIP_STATUS='DELAYED' and td.DELAY > 60 ";
		} else if ("detentionTotal".equalsIgnoreCase(type)) {
			condition = " and td.TRIP_STATUS in ('LOADING DETENTION','UNLOADING DETENTION') ";
		} else if ("ontimeDeviation".equalsIgnoreCase(type)) {
			condition = " and TRIP_STATUS= 'ON TIME' and td.TRIP_ID in (select distinct TRIP_ID from Alert(nolock) where TYPE_OF_ALERT=5 and REMARKS is null) ";
		} else if ("ontimeDetention".equalsIgnoreCase(type)) {
			condition = " and TRIP_STATUS= 'ON TIME' and td.TRIP_ID in (select distinct TRIP_ID from Alert(nolock) where TYPE_OF_ALERT=204 and REMARKS is null) ";
		} else if ("ontimeStoppage".equalsIgnoreCase(type)) {
			condition = " and TRIP_STATUS= 'ON TIME' and td.TRIP_ID in (select distinct TRIP_ID from Alert(nolock) where TYPE_OF_ALERT=202 and REMARKS is null) ";
		} else if ("delayedLessDeviation".equalsIgnoreCase(type)) {
			condition = " and TRIP_STATUS= 'DELAYED' and DELAY <= 60 and td.TRIP_ID in (select distinct TRIP_ID from Alert(nolock) where TYPE_OF_ALERT=5 and REMARKS is null) ";
		} else if ("delayedLessDetention".equalsIgnoreCase(type)) {
			condition = " and TRIP_STATUS= 'DELAYED' and DELAY <= 60 and td.TRIP_ID in (select distinct TRIP_ID from Alert(nolock) where TYPE_OF_ALERT=204 and REMARKS is null) ";
		} else if ("delayedLessStoppage".equalsIgnoreCase(type)) {
			condition = " and TRIP_STATUS= 'DELAYED' and DELAY <= 60 and td.TRIP_ID in (select distinct TRIP_ID from Alert(nolock) where TYPE_OF_ALERT=202 and REMARKS is null) ";
		} else if ("delayedGreaterDeviation".equalsIgnoreCase(type)) {
			condition = " and TRIP_STATUS= 'DELAYED' and DELAY > 60 and td.TRIP_ID in (select distinct TRIP_ID from Alert(nolock) where TYPE_OF_ALERT=5 and REMARKS is null) ";
		} else if ("delayedGreaterDetention".equalsIgnoreCase(type)) {
			condition = " and TRIP_STATUS= 'DELAYED' and DELAY > 60 and td.TRIP_ID in (select distinct TRIP_ID from Alert(nolock) where TYPE_OF_ALERT=204 and REMARKS is null) ";
		} else if ("delayedGreaterStoppage".equalsIgnoreCase(type)) {
			condition = " and TRIP_STATUS= 'DELAYED' and DELAY > 60 and td.TRIP_ID in (select distinct TRIP_ID from Alert(nolock) where TYPE_OF_ALERT=202 and REMARKS is null) ";
		} else if ("chMissed".equalsIgnoreCase(type)) {
			condition = " and td.TRIP_ID in (select distinct TRIP_ID from Alert(nolock) where TYPE_OF_ALERT=206 and REMARKS is null) ";
		} else if ("shMissed".equalsIgnoreCase(type)) {
			condition = " and td.TRIP_ID in (select distinct TRIP_ID from Alert(nolock) where TYPE_OF_ALERT=205 and REMARKS is null) ";
		} else if ("nonComm".equalsIgnoreCase(type)) {
			condition = " and td.ASSET_NUMBER in (select distinct REGISTRATION_NO from Alert(nolock) where TYPE_OF_ALERT=85 and REMARKS is null) and datediff(mi,gps.GPS_DATETIME,getdate()) > 5 ";
		} else if ("idle".equalsIgnoreCase(type)) {
			condition = " and td.TRIP_ID in (select distinct TRIP_ID from Alert(nolock) where TYPE_OF_ALERT=39 and REMARKS is null and gps.CATEGORY='idle') ";
		} else if ("tempDeviation".equalsIgnoreCase(type)) {
			condition = " and td.TRIP_ID in (select distinct TRIP_ID from Alert(nolock) where TYPE_OF_ALERT=216 and REMARKS is null) ";
		} else if (range > 0) {
			if (range == 999) {
				condition = " and td.TRIP_START_TIME between dateadd(mi,-330,'" + startDate
						+ " 00:00:00') and dateadd(mi,-330,'" + endDate + " 23:59:59')";
			} else {
				condition = " and td.TRIP_START_TIME between dateadd(dd," + -range + ",getutcdate()) and getutcdate()";
			}
		}
		return condition;
	}

	private String getFilteredCondition(String custType, String tripType, String routeId, String tripCustId, String hubName, String hubDirection) {
		String routeCondition = routeId.equals("ALL") ? "" : " and td.ROUTE_ID in (" + routeId + ")";
		String tripCustCondition = tripCustId.equals("ALL") ? "" : " and td.TRIP_CUSTOMER_ID in (" + tripCustId + ")";
		String custTypeCondition = custType.equals("ALL") ? "" : " and TRIP_CUSTOMER_TYPE in (" + custType + ")";
		String tripTypeCondition = tripType.equals("ALL") ? "" : " and PRODUCT_LINE in (" + tripType + ")";
		String hubNameCondition = "";
		String directionCond = " select HUBID from AMS.dbo.LOCATION_ZONE_A where PINCODE in (select PINCODE from SMARTHUB_PINCODE_DETAILS where HUB_ID in ("+ hubName + "))";
		if (!hubName.equals("ALL")) {
			hubNameCondition = " and td.TRIP_ID in (select TRIP_ID from AMS.dbo.DES_TRIP_DETAILS where HUB_ID in (##) && )".replace("*", hubName);
			if (hubDirection.equalsIgnoreCase("Incoming")) {
				hubNameCondition = hubNameCondition.replace("&&", " and ACT_ARR_DATETIME is null ").replace("##", directionCond);
			} else if (hubDirection.equalsIgnoreCase("Outgoing")) {
				hubNameCondition = hubNameCondition.replace("&&", " and ACT_ARR_DATETIME is not null and SEQUENCE!=100").replace("##", directionCond);
			} else if(hubDirection.equalsIgnoreCase("All") || hubDirection.equalsIgnoreCase("Incoming,Outgoing")){
				hubNameCondition = hubNameCondition.replace("&&", "  ").replace("##", directionCond);
			}else {
				hubNameCondition = hubNameCondition.replace("&&", "").replace("##", hubName);
			}
		}
		return custTypeCondition.concat(tripTypeCondition).concat(routeCondition).concat(tripCustCondition).concat(hubNameCondition);
	}
	public String getLegwiseDetailsForSLA(int offset,int range,int customerId,String startDate,String endDate,String zone,int userId,String Route,String tripCustId,String custType,String tripType,String hubType,String hubDirection,String type) {
		Connection con = null;
		JSONArray legDetailsArray = new JSONArray();
		JSONObject tripDetailsObject = null;
		int count = 0;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		PreparedStatement pstmt1 = null;
		ResultSet rs1 = null;
		String customername = "DHL";
		String completePath = null;
		ArrayList<String> arrayList = null;
		ArrayList<String> formatList = null;
		Date d1 = new Date();
		final String[] headers = { "Sl. No.", "Trip No", "Leg ID","Driver1Name", "Driver1Contact","Driver2Name", 
				"Driver2Contact", "Origin", "Destination", "STD", "ATD", "Departure Delay wrt STD","Planned Transit Time","STA wrt ATD",
				"ETA", "ATA","Actual Transit Time","TransitDelay","LegDistance"};

		final String[] formatter = { "int", "default", "default", "default", "default", "default", "default", "default", "default", "default", "default", "default", "default", "default",
			"default", "default", "default", "default", "int"};
		
		String filteredCondition = getFilteredCondition(custType, tripType, Route, tripCustId, hubType, hubDirection);
		String tripStatusCondition = getConditionForTripQuery(type, range, startDate, endDate);
		String statusCondition = range > 0 ? "" : " and td.STATUS='OPEN' ";
		
		String legGroupBy = " group by td.ORDER_ID,tl.TRIP_ID,tl.LEG_ID , LEG_NAME, lz.NAME,lz1.NAME ,STD ,STA ,ACTUAL_ARRIVAL,ACTUAL_DEPARTURE,tl.TOTAL_DISTANCE ,tl.AVG_SPEED,tl.FUEL_CONSUMED,tl.MILEAGE, "
			+ " tl.OBD_MILEAGE,ACTUAL_ARRIVAL,ACTUAL_DEPARTURE,d.Fullname,d1.Fullname,ETA,tdd.GREEN_BAND_SPEED_PERC,tdd.GREEN_RPM_PERC,d.Mobile,d1.Mobile,tl.ID,lm.TAT "
			+ " ,lm.DISTANCE,lz.Standard_Duration,lz1.Standard_Duration ";


		try {
			Properties properties = ApplicationListener.prop;
			String rootPath = properties.getProperty("slaDashBoardExcelExport");
			completePath = rootPath + "//" + customername + "_SLALEGWISE_REPORT_" + Calendar.getInstance().getTimeInMillis() + ".xlsx";

			File f = new File(rootPath);
			if (!f.exists()) {
				f.mkdir();
			}
			con = DBConnection.getConnectionToDB("AMS");
			Workbook workbook = new XSSFWorkbook();// new HSSFWorkbook(); // for
			CellStyle my_style = workbook.createCellStyle();
			my_style.setBorderBottom(HSSFCellStyle.BORDER_MEDIUM);
			my_style.setBorderTop(HSSFCellStyle.BORDER_MEDIUM);
			my_style.setBorderRight(HSSFCellStyle.BORDER_MEDIUM);
			my_style.setBorderLeft(HSSFCellStyle.BORDER_MEDIUM);
			my_style.setFillPattern(CellStyle.SOLID_FOREGROUND);
			my_style.setFillForegroundColor(IndexedColors.ORANGE.getIndex());
			// Create a Font for styling header cells
			Font headerFont = workbook.createFont();
			headerFont.setFontHeightInPoints((short) 14);
			headerFont.setColor(IndexedColors.BLACK.getIndex());
			my_style.setFont(headerFont);

			CellStyle blankOrNAStyle = workbook.createCellStyle();

			Sheet sheet = workbook.createSheet("Trip Level");
			sheet.createFreezePane(0, 6);

			CellStyle headingStyle = workbook.createCellStyle();
			Font headingFont = workbook.createFont();
			headingFont.setFontHeightInPoints((short) 16);
			headingFont.setColor(IndexedColors.DARK_BLUE.getIndex());
			headingStyle.setFont(headingFont);

			Row row1 = sheet.createRow(1);
			Cell cellA = row1.createCell(0);
			cellA.setCellValue("SLALEGWISE REPORT");
			cellA.setCellStyle(headingStyle);

			Row row2 = sheet.createRow(3);
			Cell cell0 = row2.createCell(0);
			cell0.setCellValue("TripStart Date: ");
			cell0.setCellStyle(headingStyle);
			Cell cellB = row2.createCell(1);
			if(startDate!="")
			{
			cellB.setCellValue(sdfDBMMDD.format(sdfDBMMDD.parse(startDate)));	
			}
			cellB.setCellStyle(headingStyle);
			Cell cell2 = row2.createCell(2);
			cell2.setCellValue("TripEnd Date: ");
			cell2.setCellStyle(headingStyle);
			Cell cell3 = row2.createCell(3);
			if(endDate!="")
			{
			cell3.setCellValue(sdfDBMMDD.format(sdfDBMMDD.parse(endDate)));	
			}
			cell3.setCellStyle(headingStyle);
			Row headerRow = sheet.createRow(5);
			int systemId=268;
			arrayList = new ArrayList<String>(Arrays.asList(headers));
			formatList = new ArrayList<String>(Arrays.asList(formatter));
			for (int i = 0; i < arrayList.size(); i++) {
				Cell cell = headerRow.createCell(i);
			    cell.setCellValue(arrayList.get(i));
				cell.setCellStyle(my_style);
			}
			CellStyle summaryStyle = workbook.createCellStyle();
			summaryStyle.setFillForegroundColor(IndexedColors.LIGHT_YELLOW.index);
			summaryStyle.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
			summaryStyle.setAlignment(HSSFCellStyle.ALIGN_LEFT);
			summaryStyle.setBorderTop((short) 1); // single line border
			summaryStyle.setBorderBottom((short) 1); // single line border
			int rowNum = 6;
			Row row = null;
				pstmt1 = con.prepareStatement(GeneralVerticalStatements.GET_TRIP_DETAILS_SLA.concat(statusCondition).concat(filteredCondition).concat(tripStatusCondition).concat(" order by td.TRIP_ID desc").replace("$", "330"));
				pstmt1.setInt(1, systemId);
				pstmt1.setInt(2, customerId);
					rs1 = pstmt1.executeQuery();
					while(rs1.next())
					{
					row = sheet.createRow(rowNum++);
					tripDetailsObject = new JSONObject();
					tripDetailsObject.put("Sl. No.", ++count);
					tripDetailsObject.put("Trip No", rs1.getString("tripNumber"));
					tripDetailsObject.put("Leg ID", "");
					tripDetailsObject.put("Driver1Name", rs1.getString("DriverName1"));
					tripDetailsObject.put("Driver1Contact",rs1.getString("DriverMob1"));
					tripDetailsObject.put("Driver2Name",rs1.getString("DriverName2"));
					tripDetailsObject.put("Driver2Contact",rs1.getString("DriverMob2"));		
					tripDetailsObject.put("Origin", rs1.getString("SOURCE"));
					tripDetailsObject.put("Destination", rs1.getString("DESTIANTION"));
					String STD = "";
					if (!rs1.getString("STD").contains("1900")) {
						STD = mmddyyy.format(sdfDB.parse(rs1.getString("STD")));
					}
					String ATD = "";
					if (!rs1.getString("ATD").contains("1900")) {
						ATD = mmddyyy.format(sdfDB.parse(rs1.getString("ATD")));
					}
					String ETA = "";
					if (!rs1.getString("eta").contains("1900")) {
						ETA = mmddyyy.format(sdfDB.parse(rs1.getString("eta")));
					}
					String ATA = "";
					if (!rs1.getString("ata").contains("1900")) {
						ATA = mmddyyy.format(sdfDB.parse(rs1.getString("ata")));
					}

					tripDetailsObject.put("STD", STD);
					tripDetailsObject.put("ATD", ATD);
					tripDetailsObject.put("Departure Delay wrt STD",ATD);
					tripDetailsObject.put("Planned Transit Time", (rs1.getLong("plannedTransitTime") != 0) ? formattedHoursMinutesSeconds(rs1.getLong("plannedTransitTime")) : "00:00:00");
					tripDetailsObject.put("STA wrt ATD", mmddyyy.format(sdfDB.parse(rs1.getString("staOnAtd"))));
					tripDetailsObject.put("ETA", ETA);
					tripDetailsObject.put("ATA", ATA);
					tripDetailsObject.put("Actual Transit Time", (rs1.getInt("actualTransitTime") != 0) ? formattedHoursMinutesSeconds(rs1.getInt("actualTransitTime")) : "00:00:00");
					tripDetailsObject.put("TransitDelay", (ATD != null) || (ATD != "") ? convertMinutesToHHMMSSFormat(rs1.getString("transitDelay")): "00:00:00");
					tripDetailsObject.put("LegDistance", "");
					for (int i = 0; i < arrayList.size(); i++) {
						try {

							Cell cell = row.createCell(i);
							String format = formatList.get(i);
							String val = tripDetailsObject.getString(arrayList.get(i)).trim();
							val = (val == null) ? "" : val;
							cell.setCellStyle(summaryStyle);
							if (val.equalsIgnoreCase("") || val.equalsIgnoreCase("NA")) {
								cell.setCellValue(val);
								cell.setCellStyle(summaryStyle);
							} else {
								if (format.equalsIgnoreCase("datetime")) {
									if (val.contains("1900")) {
										cell.setCellValue(val);
										cell.setCellStyle(summaryStyle);
									} else {
										cell.setCellValue(val);
										cell.setCellStyle(summaryStyle);
									}

								} else if (format.equalsIgnoreCase("int")) {
									cell.setCellValue(Integer.valueOf(val));
									cell.setCellStyle(summaryStyle);
								} else if (format.equalsIgnoreCase("timeformat")) {
									cell.setCellValue(val);
									cell.setCellStyle(summaryStyle);
								} else if (format.equalsIgnoreCase("default")) {
									cell.setCellValue(val);
									cell.setCellStyle(summaryStyle);
								} else {
									boolean numeric = true;
									try {
										@SuppressWarnings("unused")
										Double num = Double.parseDouble(val);
									} catch (NumberFormatException e) {
										numeric = false;
									}
									double nval = (numeric) ? Double.valueOf(val) : 0;
									cell.setCellValue(nval);
									cell.setCellStyle(summaryStyle);
								}
							}
						} catch (JSONException e) {
						} catch (Exception e) {
						}
					}
				legDetailsArray.put(tripDetailsObject);
			    pstmt = con.prepareStatement(GeneralVerticalStatements.GET_LEG_DETAILS_SLA.replaceAll("AMS.dbo.LOCATION", "AMS.dbo.LOCATION_ZONE_" + zone)
					+ legGroupBy + " order by tl.ID ");
					pstmt.setInt(1, offset);
					pstmt.setInt(2, offset);
					pstmt.setInt(3, offset);
					pstmt.setInt(4, offset);
					pstmt.setInt(5, offset);
					pstmt.setInt(6, rs1.getInt("Tripno"));
					rs = pstmt.executeQuery();
					int legsequence = 0;
				while (rs.next()) {
				long plannedTransitTime = rs.getInt("plannedTransitTime");
				long actualTransitTime = rs.getInt("actualTransitTime");
				long Legdistance = rs.getLong("DISTANCE");
				long transitDealy = (actualTransitTime != 0) ? (actualTransitTime - plannedTransitTime) : 0;
				legsequence++;
				tripDetailsObject = new JSONObject();
				row = sheet.createRow(rowNum++);
				tripDetailsObject.put("Trip No", rs.getString("tripNumber"));
				tripDetailsObject.put("Leg ID", rs.getString("LEG_NAME"));
				tripDetailsObject.put("Driver1Name", rs.getString("DRIVER1"));
				tripDetailsObject.put("Driver1Contact", rs.getString("DRIVER1_CONTACT"));
				tripDetailsObject.put("Driver2Name", rs.getString("DRIVER2"));
				tripDetailsObject.put("Driver2Contact", rs.getString("DRIVER2_CONTACT"));
				tripDetailsObject.put("Origin", rs.getString("SOURCE"));
				tripDetailsObject.put("Destination", rs.getString("DESTIANTION"));
				String STAwrtATD = "";

				String LEGSTD = "";
				if (!rs.getString("STD").contains("1900")) {
					LEGSTD = mmddyyy.format(sdfDB.parse(rs.getString("STD")));
				}
				String LEGATD = "";
				if (!rs.getString("ATD").contains("1900")) {
					LEGATD = mmddyyy.format(sdfDB.parse(rs.getString("ATD")));
					STAwrtATD = getDate(rs.getString("ATD"), plannedTransitTime);
				}
				String LEGATA = "";
				if (!rs.getString("ATA").contains("1900")) {
					LEGATA = mmddyyy.format(sdfDB.parse(rs.getString("ATA")));
				}

				tripDetailsObject.put("STD", LEGSTD);
				tripDetailsObject.put("ATD", LEGATD);
				tripDetailsObject.put("Departure Delay wrt STD", ATD);
				tripDetailsObject.put("Planned Transit Time", (plannedTransitTime != 0) ? formattedHoursMinutesSeconds(plannedTransitTime) : "00:00:00");
				tripDetailsObject.put("STA wrt ATD", STAwrtATD);
				String LEGETA = "";
				if (!rs.getString("ETA").contains("1900")) {
					LEGETA = mmddyyy.format(sdfDB.parse(rs.getString("ETA")));
				}
				tripDetailsObject.put("ETA", LEGETA);
				tripDetailsObject.put("ATA", LEGATA);
				tripDetailsObject.put("Actual Transit Time", (actualTransitTime != 0) ? formattedHoursMinutesSeconds(actualTransitTime) : "00:00:00");
				tripDetailsObject.put("TransitDelay", (transitDealy != 0) ? formattedHoursMinutesSeconds(transitDealy) : "00:00:00");
				tripDetailsObject.put("LegDistance", (Legdistance != 0) ? Legdistance : "");
				for (int i = 0; i < arrayList.size(); i++) {
						try {

							Cell cell = row.createCell(i);
							String format = formatList.get(i);
							String val = tripDetailsObject.getString(arrayList.get(i)).trim();
							val = (val == null) ? "" : val;
							if (val.equalsIgnoreCase("") || val.equalsIgnoreCase("NA")) {
								cell.setCellValue(val);
								cell.setCellStyle(blankOrNAStyle);
							} else {
								if (format.equalsIgnoreCase("datetime")) {
									if (val.contains("1900")) {
										cell.setCellValue(val);
									} else {
										cell.setCellValue(val);
									}

								} else if (format.equalsIgnoreCase("int")) {
									cell.setCellValue(Integer.valueOf(val));
								} else if (format.equalsIgnoreCase("timeformat")) {
									cell.setCellValue(val);
								} else if (format.equalsIgnoreCase("default")) {
									cell.setCellValue(val);
								} else {
									boolean numeric = true;
									try {
										@SuppressWarnings("unused")
										Double num = Double.parseDouble(val);
									} catch (NumberFormatException e) {
										numeric = false;
									}
									double nval = (numeric) ? Double.valueOf(val) : 0;
									cell.setCellValue(nval);
								}
							}
						} catch (JSONException e) {
						} catch (Exception e) {
						}
					}
				legDetailsArray.put(tripDetailsObject);		
			}
				
		}
			FileOutputStream fileOut = new FileOutputStream(completePath);
			workbook.write(fileOut);
			fileOut.flush();
			fileOut.close();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			Date d2 = new Date();
			long diff = d2.getTime() - d1.getTime();
			System.out.println("time taken to complete the cycle :::" + diff + "\t" + formattedHoursMinutesSeconds((diff / 1000) / 60));
			DBConnection.releaseConnectionToDB(con, pstmt, rs);

		}
		return completePath;
	}
	public JSONArray getVehiclesForMap(int offset, int userId, int clientId, int systemId, int isLtsp, String lang, int nonCommHrs, String custId, String routeId, String tripStatus, String custType,
			String tripType) {
		JSONArray VehicleDetailsArray = new JSONArray();
		JSONObject VehicleDetailsObject = new JSONObject();

		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String status = "OPEN";
		String tripStr = "", tripStrs = "";
		String STD = "";
		String ETHA = "";
		String ETA = "";
		String ATD = "";
		String endDate = "";
		String Delay = "";
		// Properties prop = ApplicationListener.prop;
		try {
			con = DBConnection.getConnectionToDB("AMS");
			String eventStrHubDetention = " and td.TRIP_ID in (select distinct TRIP_ID from DES_TRIP_DETAILS where  ACT_ARR_DATETIME is not null and SEQUENCE not in (0,100) and ACT_DEP_DATETIME is null "
					+ " and datediff(mi,ACT_ARR_DATETIME,isnull(ACT_DEP_DATETIME,getutcdate()))>isnull(DETENTION_TIME,0))";
			String eventQueryStoppage = " and td.TRIP_ID in (select distinct TRIP_ID from TRIP_EVENT_DETAILS where ALERT_TYPE=1) and gps.CATEGORY='stoppage' ";
			String eventQueryroutedEviation = " and td.TRIP_ID in (select distinct TRIP_ID from TRIP_EVENT_DETAILS a where ALERT_TYPE=5 and TRIP_ID not in (select TRIP_ID from TRIP_EVENT_DETAILS b where b.TRIP_ID=td.TRIP_ID and ALERT_TYPE=134 and b.GMT>a.GMT))";
			String eventQuerydelayedLateDeparture = " and td.STATUS='OPEN' and td.TRIP_STATUS='DELAYED' and SEQUENCE=100 and (ACTUAL_TRIP_START_TIME>TRIP_START_TIME and (DATEDIFF(mi,isnull(td.DEST_ARR_TIME_ON_ATD,PLANNED_ARR_DATETIME),DESTINATION_ETA) < DATEDIFF(mi,TRIP_START_TIME,ACTUAL_TRIP_START_TIME)))";
			String additionalconditionfordelay = " and td.TRIP_ID not in(  select td.TRIP_ID from AMS.dbo.TRACK_TRIP_DETAILS td "
					+ " inner join AMS.dbo.DES_TRIP_DETAILS dt  on td.TRIP_ID=dt.TRIP_ID where td.STATUS='OPEN' and td.TRIP_STATUS='DELAYED' and SEQUENCE=100 "
					+ " and (ACTUAL_TRIP_START_TIME>TRIP_START_TIME and DATEDIFF(mi,isnull(DEST_ARR_TIME_ON_ATD,PLANNED_ARR_DATETIME),DESTINATION_ETA) < DATEDIFF(mi,TRIP_START_TIME,ACTUAL_TRIP_START_TIME))) ";

			//Dhl BlueDart start map
			if (tripStatus.equalsIgnoreCase("delayedonetotwohour")) {
				Delay = "True";
				tripStatus = "DELAYED";
				tripStr = " and td.TRIP_STATUS = '" + tripStatus + "'" + " and isnull(DELAY,0)>60 and isnull(DELAY,0)<120 " + additionalconditionfordelay;
			} else if (tripStatus.equalsIgnoreCase("delayedtwotothreehour")) {
				Delay = "True";
				tripStatus = "DELAYED";
				tripStr = "and td.TRIP_STATUS = '" + tripStatus + "'" + " and isnull(DELAY,0)>120 and isnull(DELAY,0)<180 " + additionalconditionfordelay;
			} else if (tripStatus.equalsIgnoreCase("delayedthreetofivehour")) {
				Delay = "True";
				tripStatus = "DELAYED";
				tripStr = "and td.TRIP_STATUS = '" + tripStatus + "'" + " and isnull(DELAY,0)>180 and isnull(DELAY,0)<300 " + additionalconditionfordelay;
			} else if (tripStatus.equalsIgnoreCase("delayedmorethanfivehour")) {
				Delay = "True";
				tripStatus = "DELAYED";
				tripStr = "and td.TRIP_STATUS = '" + tripStatus + "'" + " and isnull(DELAY,0)>300 " + additionalconditionfordelay;
			} else ////////////
			if (tripStatus.equalsIgnoreCase("delayedonetotwohour-deviation")) {
				Delay = "";
				tripStatus = "DELAYED";
				tripStr = " and td.TRIP_STATUS = '" + tripStatus + "'" + " and isnull(DELAY,0)>60 and isnull(DELAY,0)<120 " + additionalconditionfordelay + eventQueryroutedEviation;
			} else if (tripStatus.equalsIgnoreCase("delayedonetotwohour-stoppage")) {
				Delay = "";
				tripStatus = "DELAYED";
				tripStr = " and td.TRIP_STATUS = '" + tripStatus + "'" + " and isnull(DELAY,0)>60 and isnull(DELAY,0)<120" + additionalconditionfordelay + eventQueryStoppage;
			} else if (tripStatus.equalsIgnoreCase("delayedtwotothreehour-deviation")) {
				Delay = "";
				tripStatus = "DELAYED";
				tripStr = " and td.TRIP_STATUS = '" + tripStatus + "'" + " and isnull(DELAY,0)>120 and isnull(DELAY,0)<180 " + additionalconditionfordelay + eventQueryroutedEviation;
			} else if (tripStatus.equalsIgnoreCase("delayedtwotothreehour-stoppage")) {
				Delay = "";
				tripStatus = "DELAYED";
				tripStr = " and td.TRIP_STATUS = '" + tripStatus + "'" + " and isnull(DELAY,0)>120 and isnull(DELAY,0)<180 " + additionalconditionfordelay + eventQueryStoppage;
			} else if (tripStatus.equalsIgnoreCase("delayedthreetofivehour-deviation")) {
				Delay = "";
				tripStatus = "DELAYED";
				tripStr = " and td.TRIP_STATUS = '" + tripStatus + "'" + " and isnull(DELAY,0)>180 and isnull(DELAY,0)<300 " + additionalconditionfordelay + eventQueryroutedEviation;
			} else if (tripStatus.equalsIgnoreCase("delayedthreetofivehour-stoppage")) {
				Delay = "";
				tripStatus = "DELAYED";
				tripStr = " and td.TRIP_STATUS = '" + tripStatus + "'" + " and isnull(DELAY,0)>180 and isnull(DELAY,0)<300" + additionalconditionfordelay + eventQueryStoppage;
			} else if (tripStatus.equalsIgnoreCase("delayedmorethanfivehour-deviation")) {
				Delay = "";
				tripStatus = "DELAYED";
				tripStr = " and td.TRIP_STATUS = '" + tripStatus + "'" + " and isnull(DELAY,0)>300 " + additionalconditionfordelay + eventQueryroutedEviation;
			} else if (tripStatus.equalsIgnoreCase("delayedmorethanfivehour-stoppage")) {
				Delay = "";
				tripStatus = "DELAYED";
				tripStr = " and td.TRIP_STATUS = '" + tripStatus + "'" + " and isnull(DELAY,0)>300" + additionalconditionfordelay + eventQueryStoppage;
			} else

			//Dhl bluedart end map
			if (tripStatus.equalsIgnoreCase("enrouteId")) {
				Delay = "";
				tripStatus = "ENROUTE PLACEMENT%";
				tripStr = "and td.TRIP_STATUS like '" + tripStatus + "'";
			} else if (tripStatus.equalsIgnoreCase("onTimeId")) {
				Delay = "";
				tripStatus = "ON TIME";
				tripStr = "and td.TRIP_STATUS = '" + tripStatus + "'";
			} else if (tripStatus.equalsIgnoreCase("delayedless1")) {
				Delay = "True";
				tripStatus = "DELAYED";
				tripStr = "and td.TRIP_STATUS = '" + tripStatus + "'" + " and isnull(DELAY,0)<60 " + additionalconditionfordelay;
			} else if (tripStatus.equalsIgnoreCase("delayedgreater1")) {
				Delay = "True";
				tripStatus = "DELAYED";
				tripStr = "and td.TRIP_STATUS = '" + tripStatus + "'" + " and isnull(DELAY,0)>60 " + additionalconditionfordelay;
			} else if (tripStatus.equalsIgnoreCase("enrouteId-Ontime")) {
				Delay = "";
				tripStatus = "ENROUTE PLACEMENT ON TIME";
				tripStr = "and td.TRIP_STATUS = '" + tripStatus + "'";
			} else if (tripStatus.equalsIgnoreCase("enrouteId-delay")) {
				Delay = "";
				tripStatus = "ENROUTE PLACEMENT DELAYED";
				tripStr = "and td.TRIP_STATUS = '" + tripStatus + "'";
			} else if (tripStatus.equalsIgnoreCase("loading-detention")) {
				Delay = "";
				tripStatus = "LOADING DETENTION";
				tripStr = "and td.TRIP_STATUS = '" + tripStatus + "'";
			} else if (tripStatus.equalsIgnoreCase("unloading-detention")) {
				Delay = "";
				tripStatus = "UNLOADING DETENTION";
				tripStr = "and td.TRIP_STATUS = '" + tripStatus + "'";
			} else if (tripStatus.equalsIgnoreCase("delay-late-departure")) {
				Delay = "True";
				tripStatus = "DELAYED LATE DEPARTURE";
				tripStrs = " " + eventQuerydelayedLateDeparture;
			} // EVENT QUERIES
			// ONTIME
			else if (tripStatus.equalsIgnoreCase("onTimeId-hubhetention")) {
				Delay = "";
				tripStatus = "ON TIME";
				tripStr = " and td.TRIP_STATUS = '" + tripStatus + "'" + eventStrHubDetention;
			} else if (tripStatus.equalsIgnoreCase("onTimeId-stoppage")) {
				Delay = "";
				tripStatus = "ON TIME";
				tripStr = " and td.TRIP_STATUS = '" + tripStatus + "'" + eventQueryStoppage;
			} else if (tripStatus.equalsIgnoreCase("onTimeId-deviation")) {
				Delay = "";
				tripStatus = "ON TIME";
				tripStr = " and td.TRIP_STATUS = '" + tripStatus + "'" + eventQueryroutedEviation;
			}
			// DELAYED<1HR
			else if (tripStatus.equalsIgnoreCase("delayedless1-detention")) {
				Delay = "";
				tripStatus = "DELAYED";
				tripStr = " and td.TRIP_STATUS = '" + tripStatus + "'" + " and isnull(DELAY,0)<60 " + additionalconditionfordelay + eventStrHubDetention;
			} else if (tripStatus.equalsIgnoreCase("delayedless1-stoppage")) {
				Delay = "";
				tripStatus = "DELAYED";
				tripStr = " and td.TRIP_STATUS = '" + tripStatus + "'" + " and isnull(DELAY,0)<60" + additionalconditionfordelay + eventQueryStoppage;
			} else if (tripStatus.equalsIgnoreCase("delayedless1-deviation")) {
				Delay = "";
				tripStatus = "DELAYED";
				tripStr = " and td.TRIP_STATUS = '" + tripStatus + "'" + " and isnull(DELAY,0)<60" + additionalconditionfordelay + eventQueryroutedEviation;
			}
			// DELAYED>1HR
			else if (tripStatus.equalsIgnoreCase("delayedgreater1-detention")) {
				Delay = "";
				tripStatus = "DELAYED";
				tripStr = " and td.TRIP_STATUS = '" + tripStatus + "'" + " and isnull(DELAY,0)>60" + additionalconditionfordelay + eventStrHubDetention;
			} else if (tripStatus.equalsIgnoreCase("delayedgreater1-stoppage")) {
				Delay = "";
				tripStatus = "DELAYED";
				tripStr = " and td.TRIP_STATUS = '" + tripStatus + "'" + " and isnull(DELAY,0)>60" + additionalconditionfordelay + eventQueryStoppage;
			} else if (tripStatus.equalsIgnoreCase("delayedgreater1-deviation")) {
				Delay = "";
				tripStatus = "DELAYED";
				tripStr = " and td.TRIP_STATUS = '" + tripStatus + "'" + " and isnull(DELAY,0)>60" + additionalconditionfordelay + eventQueryroutedEviation;
			} else {
				Delay = "";
				tripStr = "and td.TRIP_STATUS <> 'NEW'";
			}
			String stmt = "";
			if (tripStatus.equalsIgnoreCase("DELAYED") && Delay.equalsIgnoreCase("True")) {
				// System.out.println("i am in !! ");
				stmt = GeneralVerticalStatements.GET_VEHICLES_FOR_MAP_DELAY.concat(tripStr);
			} else if (tripStatus.equalsIgnoreCase("DELAYED LATE DEPARTURE")) {
				// System.out.println("i am in !!!");
				stmt = GeneralVerticalStatements.GET_VEHICLES_FOR_MAP.concat(tripStr).concat(tripStrs);
				stmt = stmt.replace("td.TRIP_STATUS,", "'DELAYED LATE DEPARTURE' as TRIP_STATUS,");
			} else {
				// System.out.println("i am in !!!!");
				stmt = GeneralVerticalStatements.GET_VEHICLES_FOR_MAP.concat(tripStr);
			}
			if (routeId.equals("ALL")) {
				stmt = stmt.replace("#", "");
			} else {
				routeId = routeId.substring(0, routeId.length() - 1);
				stmt = stmt.replace("#", "and td.ROUTE_ID in (" + routeId + ")");
			}

			// if(custName.equals("ALL")){
			// stmt = stmt.replace("$", "");
			// }else{
			// stmt=stmt.replace("$","and CUSTOMER_NAME='"+custName+"'");
			// }
			if (custId.equals("ALL")) {
				stmt = stmt.replace("$", "");
			} else {
				custId = custId.substring(0, custId.length() - 1);
				stmt = stmt.replace("$", "and TRIP_CUSTOMER_ID in (" + custId + ")");
			}
			if (custType.equals("ALL")) {
				stmt = stmt.replace("custTypeCondition", "");
			} else {
				custType = custType.substring(0, custType.length() - 1);
				stmt = stmt.replace("custTypeCondition", "and td.TRIP_CUSTOMER_TYPE in (" + custType + ")");
			}
			if (tripType.equals("ALL")) {
				stmt = stmt.replace("tripTypeCondition", "");
			} else {
				tripType = tripType.substring(0, tripType.length() - 1);
				stmt = stmt.replace("tripTypeCondition", "and td.PRODUCT_LINE in (" + tripType + ")");
			}
			// System.out.println("getVehiclesForMap  "+stmt);
			pstmt = con.prepareStatement(stmt);
			pstmt.setInt(1, offset);
			pstmt.setInt(2, offset);
			pstmt.setInt(3, offset);
			pstmt.setInt(4, offset);
			pstmt.setInt(5, offset);
			pstmt.setInt(6, offset);
			pstmt.setInt(7, offset);
			pstmt.setString(8, status);
			pstmt.setInt(9, systemId);
			pstmt.setInt(10, clientId);
			rs = pstmt.executeQuery();
			String TripId = "";
			String RouteId = "";
			while (rs.next()) {
				VehicleDetailsObject = new JSONObject();
				VehicleDetailsObject.put("vehicleNo", rs.getString("ASSET_NUMBER"));
				VehicleDetailsObject.put("lat", rs.getString("LATITUDE"));
				VehicleDetailsObject.put("lon", rs.getString("LONGITUDE"));
				VehicleDetailsObject.put("location", rs.getString("LOCATION"));
				if (!rs.getString("GMT").contains("1900")) {
					VehicleDetailsObject.put("gmt", sdf.format(sdfDB.parse(rs.getString("GMT"))));
				} else {
					VehicleDetailsObject.put("gmt", "");
				}
				VehicleDetailsObject.put("tripStatus", rs.getString("TRIP_STATUS"));
				VehicleDetailsObject.put("custName", rs.getString("CUSTOMER_NAME"));
				VehicleDetailsObject.put("shipmentId", rs.getString("SHIPMENT_ID"));
				VehicleDetailsObject.put("LRNO", rs.getString("LR_NO"));
				String delayE = cf.convertMinutesToHHMMFormatNegative(rs.getInt("DELAY"));
				String delayS = cf.convertMinutesToHHMMFormat(rs.getInt("DELAY"));
				if (rs.getInt("DELAY") < 0) {
					VehicleDetailsObject.put("delay", delayE);
				} else {
					VehicleDetailsObject.put("delay", delayS);
				}
				VehicleDetailsObject.put("weather", "");
				VehicleDetailsObject.put("driverName", rs.getString("DRIVER_NAME"));
				VehicleDetailsObject.put("driverMobile", rs.getString("DRIVER_MOBILE"));
				VehicleDetailsObject.put("routeKey", rs.getString("ROUTE_KEY"));

				if (!rs.getString("ETHA").contains("1900")) {
					ETHA = sdf.format(sdfDB.parse(rs.getString("ETHA")));
				}
				if (!rs.getString("ETA").contains("1900")) {
					ETA = sdf.format(sdfDB.parse(rs.getString("ETA")));
				}
				VehicleDetailsObject.put("etaDest", ETA);
				VehicleDetailsObject.put("etaNextPt", ETHA);
				if (!rs.getString("ATD").contains("1900")) {
					ATD = sdf.format(sdfDB.parse(rs.getString("ATD")));
				}
				RouteId = rs.getString("ROUTE_ID");
				VehicleDetailsObject.put("ATD", ATD);
				VehicleDetailsObject.put("routeIdHidden", RouteId);
				VehicleDetailsObject.put("status", rs.getString("STATUS"));

				TripId = rs.getString("TRIP_ID");
				VehicleDetailsObject.put("tripId", TripId);
				if (!rs.getString("endDate").contains("1900")) {
					endDate = sdf.format(sdfDB.parse(rs.getString("endDate")));
				}
				VehicleDetailsObject.put("endDateHidden", endDate);
				if (!rs.getString("STD").contains("1900")) {
					STD = sdf.format(sdfDB.parse(rs.getString("STD")));
				}
				VehicleDetailsObject.put("STD", STD);
				if (rs.getString("TEMPERATURE_DATA") != null) {
					VehicleDetailsObject.put("temperatureSensorsData", rs.getString("TEMPERATURE_DATA"));
				} else {
					VehicleDetailsObject.put("temperatureSensorsData", "");
				}
				VehicleDetailsObject.put("productLine", rs.getString("PRODUCT_LINE"));
				if (rs.getString("Humidity").equals("99999.0")) {
					VehicleDetailsObject.put("Humidity", "NA");
				} else {
					VehicleDetailsObject.put("Humidity", rs.getString("Humidity"));
				}
				VehicleDetailsObject.put("tripNo", rs.getString("TRIP_NO"));
				VehicleDetailsObject.put("routeName", rs.getString("ROUTE_NAME"));
				VehicleDetailsObject.put("currentStoppageTime", stoppageTime(rs.getString("STOPPAGE_TIME")));
				VehicleDetailsObject.put("currentIdlingTime", stoppageTime(rs.getString("IDLE_TIME")));
				VehicleDetailsObject.put("speed", rs.getString("SPEED"));
				VehicleDetailsArray.put(VehicleDetailsObject);

			}

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return VehicleDetailsArray;
	}

	public JSONArray getDashBoardCounts(int clientId, int systemId, int userId, String custId, String routeId, String custType, String tripType) {
		JSONArray jsonArray = new JSONArray();
		JSONObject obj = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int ontime = 0;
		int delayLess = 0;
		int delayGreater = 0;
		int enroute = 0;
		int enrouteOntime = 0;
		int enrouteDelayed = 0;

		int delayOneToTwoHour = 0;
		int delayTwoToThreeHour = 0;
		int delayThreeToFiveHour = 0;
		int delayMoreThanFiveHour = 0;

		int stoppageDelayLess = 0;
		int detentionDelayLess = 0;
		int deviationDelayless = 0;
		int stoppagedelayGreater = 0;
		int deviationDelayGreater = 0;
		int detentionDelayedGreater = 0;
		int ontimeStoopage = 0;
		int ontimeDetention = 0;
		int ontimeDeviation = 0;
		int loadingDetention = 0;
		int unloadingDetention = 0;
		int delayLateDeparture = 0;

		//blue dart req
		int stoppageDelayOneToTwoHour = 0;
		int stoppageDelayTwoToThreeHour = 0;
		int stoppageDelayThreeToFiveHour = 0;
		int stoppageDelayMoreThanFiveHour = 0;

		int deviationDelayOneToTwoHour = 0;
		int deviationDelayTwoToThreeHour = 0;
		int deviationDelayThreeToFiveHour = 0;
		int deviationDelayMoreThanFiveHour = 0;

		try {
			con = DBConnection.getConnectionToDB("AMS");
			String stmt = "";//GeneralVerticalStatements.GET_ONTIME_COUNT;

			stmt = GeneralVerticalStatements.GET_ONTIME_COUNT_BLUEDART;

			if (routeId.equals("ALL")) {
				stmt = stmt.replace("#", "");
			} else {
				routeId = routeId.substring(0, routeId.length() - 1);
				stmt = stmt.replace("#", " and ROUTE_ID in (" + routeId + ")");
			}
			if (custId.equals("ALL")) {
				stmt = stmt.replace("$", "");
			} else {
				custId = custId.substring(0, custId.length() - 1);
				stmt = stmt.replace("$", " and TRIP_CUSTOMER_ID in (" + custId + ")");
			}
			if (custType.equals("ALL")) {
				stmt = stmt.replace("custTypeCondition", "");
			} else {
				custType = custType.substring(0, custType.length() - 1);
				stmt = stmt.replace("custTypeCondition", "and TRIP_CUSTOMER_TYPE in (" + custType + ")");
			}
			if (tripType.equals("ALL")) {
				stmt = stmt.replace("tripTypeCondition", "");
			} else {
				tripType = tripType.substring(0, tripType.length() - 1);
				stmt = stmt.replace("tripTypeCondition", "and PRODUCT_LINE in (" + tripType + ")");
			}
			pstmt = con.prepareStatement(stmt);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, clientId);
			pstmt.setInt(3, systemId);
			pstmt.setInt(4, clientId);
			pstmt.setInt(5, systemId);
			pstmt.setInt(6, clientId);
			pstmt.setInt(7, systemId);
			pstmt.setInt(8, clientId);
			pstmt.setInt(9, systemId);
			pstmt.setInt(10, clientId);
			pstmt.setInt(11, systemId);
			pstmt.setInt(12, clientId);
			pstmt.setInt(13, systemId);
			pstmt.setInt(14, clientId);
			pstmt.setInt(15, systemId);
			pstmt.setInt(16, clientId);
			pstmt.setInt(17, systemId);
			pstmt.setInt(18, clientId);
			pstmt.setInt(19, systemId);
			pstmt.setInt(20, clientId);
			pstmt.setInt(21, systemId);
			pstmt.setInt(22, clientId);
			pstmt.setInt(23, systemId);
			pstmt.setInt(24, clientId);
			pstmt.setInt(25, systemId);
			pstmt.setInt(26, clientId);
			rs = pstmt.executeQuery();

			while (rs.next()) {

				if (rs.getString("STATUS").equals("ONTIME")) {
					ontime = rs.getInt("COUNT");
				}
				if (rs.getString("STATUS").equals("DELAY_LESS")) {
					delayLess = rs.getInt("COUNT");
				}
				if (rs.getString("STATUS").equals("DELAY_GREATER")) {
					delayGreater = rs.getInt("COUNT");
				}
				if (rs.getString("STATUS").equals("DELAY_ONE_TO_TWO_HOUR")) {
					delayOneToTwoHour = rs.getInt("COUNT");
				}
				if (rs.getString("STATUS").equals("DELAY_TWO_TO_THREE_HOUR")) {
					delayTwoToThreeHour = rs.getInt("COUNT");
				}
				if (rs.getString("STATUS").equals("DELAY_THREE_TO_FIVE_HOUR")) {
					delayThreeToFiveHour = rs.getInt("COUNT");
				}
				if (rs.getString("STATUS").equals("DELAY_MORE_THAN_FIVE_HOUR")) {
					delayMoreThanFiveHour = rs.getInt("COUNT");
				}
				if (rs.getString("STATUS").equals("ENROUTE")) {
					enroute = rs.getInt("COUNT");
				}
				if (rs.getString("STATUS").equals("ENROUTE_ONTIME")) {
					enrouteOntime = rs.getInt("COUNT");
				}
				if (rs.getString("STATUS").equals("ENROUTE_DELAYED")) {
					enrouteDelayed = rs.getInt("COUNT");
				}
				if (rs.getString("STATUS").equals("LOADING_DETENTION")) {
					loadingDetention = rs.getInt("COUNT");
				}
				if (rs.getString("STATUS").equals("UNLOADING_DETENTION")) {
					unloadingDetention = rs.getInt("COUNT");
				}
				if (rs.getString("STATUS").equals("DELYED_LATE_DEPARTURE")) {
					delayLateDeparture = rs.getInt("COUNT");
				}
			}

			String stmt2 = GeneralVerticalStatements.GET_ALERT_EVENT_COUNT;
			if (routeId.equals("ALL")) {
				stmt2 = stmt2.replace("#", "");
			} else {
				stmt2 = stmt2.replace("#", " and ROUTE_ID in (" + routeId + ")");
			}
			if (custId.equals("ALL")) {
				stmt2 = stmt2.replace("$", "");
			} else {
				stmt2 = stmt2.replace("$", " and TRIP_CUSTOMER_ID in (" + custId + ")");
			}
			if (custType.equals("ALL")) {
				stmt2 = stmt2.replace("custTypeCondition", "");
			} else {
				stmt2 = stmt2.replace("custTypeCondition", "and TRIP_CUSTOMER_TYPE in (" + custType + ")");
			}
			if (tripType.equals("ALL")) {
				stmt2 = stmt2.replace("tripTypeCondition", "");
			} else {
				stmt2 = stmt2.replace("tripTypeCondition", "and PRODUCT_LINE in (" + tripType + ")");
			}
			pstmt = con.prepareStatement(stmt2);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, clientId);
			pstmt.setInt(3, systemId);
			pstmt.setInt(4, clientId);

			pstmt.setInt(5, systemId);
			pstmt.setInt(6, clientId);
			pstmt.setInt(7, systemId);
			pstmt.setInt(8, clientId);
			pstmt.setInt(9, systemId);
			pstmt.setInt(10, clientId);

			pstmt.setInt(11, systemId);
			pstmt.setInt(12, clientId);
			pstmt.setInt(13, systemId);
			pstmt.setInt(14, clientId);
			pstmt.setInt(15, systemId);
			pstmt.setInt(16, clientId);

			pstmt.setInt(17, systemId);
			pstmt.setInt(18, clientId);

			//new dhl bluedart
			pstmt.setInt(19, systemId);
			pstmt.setInt(20, clientId);
			pstmt.setInt(21, systemId);
			pstmt.setInt(22, clientId);
			pstmt.setInt(23, systemId);
			pstmt.setInt(24, clientId);
			pstmt.setInt(25, systemId);
			pstmt.setInt(26, clientId);

			pstmt.setInt(27, systemId);
			pstmt.setInt(28, clientId);
			pstmt.setInt(29, systemId);
			pstmt.setInt(30, clientId);
			pstmt.setInt(31, systemId);
			pstmt.setInt(32, clientId);
			pstmt.setInt(33, systemId);
			pstmt.setInt(34, clientId);

			rs = pstmt.executeQuery();
			while (rs.next()) {

				//blue dart req
				if (rs.getString("STATUS").equals("STOPPAGE_DELAYED_ONE_TO_TWO_HOUR")) {
					stoppageDelayOneToTwoHour = rs.getInt("COUNT");
				}
				if (rs.getString("STATUS").equals("STOPPAGE_DELAYED_TWO_TO_THREE_HOUR")) {
					stoppageDelayTwoToThreeHour = rs.getInt("COUNT");
				}
				if (rs.getString("STATUS").equals("STOPPAGE_DELAYED_THREE_TO_FIVE_HOUR")) {
					stoppageDelayThreeToFiveHour = rs.getInt("COUNT");
				}
				if (rs.getString("STATUS").equals("STOPPAGE_DELAYED_MORE_THAN_FIVE_HOUR")) {
					stoppageDelayMoreThanFiveHour = rs.getInt("COUNT");
				}

				if (rs.getString("STATUS").equals("DEVIATION_DELAYED_ONE_TO_TWO_HOUR")) {
					deviationDelayOneToTwoHour = rs.getInt("COUNT");
				}
				if (rs.getString("STATUS").equals("DEVIATION_DELAYED_TWO_TO_THREE_HOUR")) {
					deviationDelayTwoToThreeHour = rs.getInt("COUNT");
				}
				if (rs.getString("STATUS").equals("DEVIATION_DELAYED_THREE_TO_FIVE_HOUR")) {
					deviationDelayThreeToFiveHour = rs.getInt("COUNT");
				}
				if (rs.getString("STATUS").equals("DEVIATION_DELAYED_MORE_THAN_FIVE_HOUR")) {
					deviationDelayMoreThanFiveHour = rs.getInt("COUNT");
				}

				if (rs.getString("STATUS").equals("STOPPAGE_DELAYED_LESS")) {
					stoppageDelayLess = rs.getInt("COUNT");
				}
				if (rs.getString("STATUS").equals("DETENTION_DELAYED_LESS")) {
					detentionDelayLess = rs.getInt("COUNT");
				}
				if (rs.getString("STATUS").equals("DEVIATION_DELAYED_LESS")) {
					deviationDelayless = rs.getInt("COUNT");
				}
				if (rs.getString("STATUS").equals("STOPPAGE_DELAYED_GREATER")) {
					stoppagedelayGreater = rs.getInt("COUNT");
				}
				if (rs.getString("STATUS").equals("DEVIATION_DELAYED_GREATER")) {
					deviationDelayGreater = rs.getInt("COUNT");
				}
				if (rs.getString("STATUS").equals("DETENTION_DELAYED_GREATER")) {
					detentionDelayedGreater = rs.getInt("COUNT");
				}
				if (rs.getString("STATUS").equals("ONTIME_STOPPAGE")) {
					ontimeStoopage = rs.getInt("COUNT");
				}
				if (rs.getString("STATUS").equals("ONTIME_DETENTION")) {
					ontimeDetention = rs.getInt("COUNT");
				}
				if (rs.getString("STATUS").equals("ONTIME_DEVIATION")) {
					ontimeDeviation = rs.getInt("COUNT");
				}
			}

			obj = new JSONObject();
			obj.put("ontimeCount", ontime);

			//DHL blueDart req
			obj.put("delayOneToTwoHour", delayOneToTwoHour);
			obj.put("delayTwoToThreeHour", delayTwoToThreeHour);
			obj.put("delayThreeToFiveHour", delayThreeToFiveHour);
			obj.put("delayMoreThanFiveHour", delayMoreThanFiveHour);

			obj.put("stoppageDelayOneToTwoHour", stoppageDelayOneToTwoHour);
			obj.put("stoppageDelayTwoToThreeHour", stoppageDelayTwoToThreeHour);
			obj.put("stoppageDelayThreeToFiveHour", stoppageDelayThreeToFiveHour);
			obj.put("stoppageDelayMoreThanFiveHour", stoppageDelayMoreThanFiveHour);

			obj.put("deviationDelayOneToTwoHour", deviationDelayOneToTwoHour);
			obj.put("deviationDelayTwoToThreeHour", deviationDelayTwoToThreeHour);
			obj.put("deviationDelayThreeToFiveHour", deviationDelayThreeToFiveHour);
			obj.put("deviationDelayMoreThanFiveHour", deviationDelayMoreThanFiveHour);

			obj.put("delayLess", delayLess);
			obj.put("delayGreater", delayGreater);

			obj.put("enroutePlacement", enroute);
			obj.put("enrouteOntime", enrouteOntime);
			obj.put("enrouteDelay", enrouteDelayed);
			obj.put("loadingDetention", loadingDetention);
			obj.put("unloadingDetention", unloadingDetention);
			obj.put("delayLateDeparture", delayLateDeparture);

			obj.put("stoppageDelayLess", stoppageDelayLess);
			obj.put("detentionDelayLess", detentionDelayLess);
			obj.put("deviationDelayless", deviationDelayless);
			obj.put("stoppagedelayGreater", stoppagedelayGreater);
			obj.put("deviationDelayGreater", deviationDelayGreater);
			obj.put("detentionDelayedGreater", detentionDelayedGreater);
			obj.put("ontimeStoopage", ontimeStoopage);
			obj.put("ontimeDetention", ontimeDetention);
			obj.put("ontimeDeviation", ontimeDeviation);

			jsonArray.put(obj);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jsonArray;
	}

	public JSONArray getIssues(int clientId) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject = null;
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(GeneralVerticalStatements.GET_REMARK_ISSUES);
			rs = pstmt.executeQuery();
			jsonObject = new JSONObject();
			jsonObject.put("issuevalue", "--select issue--");
			jsonArray.put(jsonObject);
			while (rs.next()) {
				jsonObject = new JSONObject();
				jsonObject.put("issuevalue", rs.getString("VALUE"));
				jsonArray.put(jsonObject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jsonArray;
	}

	public JSONArray getsubIssues(int clientId, String issueType) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject = null;
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(GeneralVerticalStatements.GET_REMARK_SUBISSUES);
			pstmt.setString(1, issueType);
			rs = pstmt.executeQuery();
			jsonObject = new JSONObject();
			jsonObject.put("subissuevalue", "--select sub-issue--");
			jsonArray.put(jsonObject);
			while (rs.next()) {
				jsonObject = new JSONObject();
				jsonObject.put("subissuevalue", rs.getString("SUBISSUE"));
				jsonArray.put(jsonObject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jsonArray;
	}

	public String insertRemarksDetails(int systemId, int userId, String custName, String Remarks, String tripId, String checked, String locationdelay, String startdate, String enddate,
			String delaytime, String issue, String subissue, String customerId) {
		Connection con = null;
		PreparedStatement pstmt = null;
		PreparedStatement pstmt1 = null;
		ResultSet rs = null;
		String message = "";
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(GeneralVerticalStatements.INSERT_REMARK_DETAILS);
			pstmt.setString(1, custName);
			pstmt.setString(2, checked);
			pstmt.setString(3, Remarks);
			pstmt.setString(4, locationdelay);
			pstmt.setString(5, sdfDB.format(sdf.parse(startdate)));
			pstmt.setString(6, sdfDB.format(sdf.parse(enddate)));
			pstmt.setString(7, delaytime);
			pstmt.setString(8, issue);
			pstmt.setString(9, subissue);
			pstmt.setInt(10, systemId);
			pstmt.setInt(11, userId);
			pstmt.setString(12, tripId);
			pstmt.setString(13, "");
			int inserted = pstmt.executeUpdate();
			if (inserted > 0) {
				message = "success";
				try {
					if ("Yes".equals(checked)) {
						String shipmentId = "";
						pstmt1 = con.prepareStatement("select SHIPMENT_ID from AMS.dbo.TRACK_TRIP_DETAILS where TRIP_ID=?");
						pstmt1.setString(1, tripId);
						rs = pstmt1.executeQuery();
						if (rs.next()) {
							shipmentId = rs.getString("SHIPMENT_ID");
						}
						JSONObject obj = new JSONObject();
						JSONObject finalObj = new JSONObject();
						obj.put("tripId", shipmentId);
						obj.put("locationOfDelay", locationdelay);
						obj.put("duration", delaytime);
						obj.put("issueType", issue);
						obj.put("subIssueType", subissue);
						obj.put("remarks", Remarks);
						obj.put("CustomerID", customerId);
						finalObj.put("Remarks", obj);
						// cf.pushData(finalObj,0,null,con);
					}
				} catch (Exception e) {
					e.printStackTrace();
				}
			} else {
				message = "error";
			}

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
			DBConnection.releaseConnectionToDB(null, pstmt1, null);
		}

		return message;
	}

	public String updateRemarksDetails(int systemId, int userId, String custName, String Remarks, String tripId, String checked, int uniqueId, String locationdelay, String startdate, String enddate,
			String delaytime, String issue, String subissue, String customerId) {
		Connection con = null;
		PreparedStatement pstmt = null;
		PreparedStatement pstmt1 = null;
		ResultSet rs = null;
		String message = "";
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(GeneralVerticalStatements.UPDATE_REMARK_DETAILS);
			pstmt.setString(1, custName);
			pstmt.setString(2, checked);
			pstmt.setString(3, Remarks);
			pstmt.setString(4, locationdelay);
			pstmt.setString(5, sdfDB.format(sdf.parse(startdate)));
			pstmt.setString(6, sdfDB.format(sdf.parse(enddate)));
			pstmt.setString(7, delaytime);
			pstmt.setString(8, issue);
			pstmt.setString(9, subissue);
			pstmt.setString(10, tripId);
			pstmt.setInt(11, uniqueId);
			int inserted = pstmt.executeUpdate();
			if (inserted > 0) {
				message = "success";
				try {
					if ("Yes".equals(checked)) {
						String shipmentId = "";
						pstmt1 = con.prepareStatement("select SHIPMENT_ID from AMS.dbo.TRACK_TRIP_DETAILS where TRIP_ID=?");
						pstmt1.setString(1, tripId);
						rs = pstmt1.executeQuery();
						if (rs.next()) {
							shipmentId = rs.getString("SHIPMENT_ID");
						}
						JSONObject obj = new JSONObject();
						JSONObject finalObj = new JSONObject();
						obj.put("tripId", shipmentId);
						obj.put("locationOfDelay", locationdelay);
						obj.put("duration", delaytime);
						obj.put("issueType", issue);
						obj.put("subIssueType", subissue);
						obj.put("remarks", Remarks);
						obj.put("CustomerID", customerId);
						finalObj.put("Remarks", obj);
						// cf.pushData(js, 0, connection, properties, logWriter,
						// url, authorization);
					}
				} catch (Exception e) {
					e.printStackTrace();
				}
			} else {
				message = "error";
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
			DBConnection.releaseConnectionToDB(null, pstmt1, null);
		}

		return message;
	}

	public JSONArray getRemarksDetails(int systemId, String tripId, int userId, int offset) {
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonobject = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;
		// PreparedStatement pstmt1 = null;
		ResultSet rs = null;
		int count = 0;
		String insertedDate = null;
		// String TripId=null;
		String startdate = null;
		String enddate = null;
		try {
			jsonArray = new JSONArray();
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(GeneralVerticalStatements.GET_TRIP_REMARKS_DETAILS.replace("#", ""));
			pstmt.setInt(1, offset);
			pstmt.setString(2, tripId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				count++;
				jsonobject = new JSONObject();
				jsonobject.put("slno", count);
				jsonobject.put("user", rs.getString("USER_NAME"));
				jsonobject.put("customertype", rs.getString("CUSTOMER_TYPE"));
				if (!rs.getString("INSERTEDDATE").contains("1900")) {
					insertedDate = sdf1.format(sdfDB.parse(rs.getString("INSERTEDDATE")));
				}
				jsonobject.put("datetime", insertedDate);
				jsonobject.put("remarks", rs.getString("REMARKS"));
				jsonobject.put("locationdelay", rs.getString("LOCATION_DELAY"));
				startdate = sdf.format(sdfDB.parse(rs.getString("STARTDATE")));
				enddate = sdf.format(sdfDB.parse(rs.getString("ENDDATE")));
				jsonobject.put("startdate", startdate);
				jsonobject.put("enddate", enddate);
				jsonobject.put("durationdelay", rs.getString("DELAYTIME"));
				jsonobject.put("issuetype", rs.getString("ISSUETYPE"));
				jsonobject.put("subissuetype", rs.getString("SUBISSUE_TYPE"));
				int uniqueid = rs.getInt("ID");
				jsonobject.put("action", "<button onclick=openModal(" + "'" + rs.getString("CUSTOMER_TYPE") + "'" + "," + "'" + rs.getString("REMARKS").replace(" ", "$") + "'" + "," + "'"
						+ rs.getString("LOCATION_DELAY").replace(" ", "$") + "'" + "," + "'" + startdate.replace(" ", "$") + "'" + "," + "'" + enddate.replace(" ", "$") + "'" + "," + "'"
						+ rs.getString("DELAYTIME").replace(" ", "$") + "'" + "," + "'" + rs.getString("ISSUETYPE").replace(" ", "$") + "'" + "," + "'"
						+ rs.getString("SUBISSUE_TYPE").replace(" ", "$") + "'" + "," + uniqueid + "); class='btn btn-info btn-md text-center'>Edit</button>");
				jsonArray.put(jsonobject);
			}
			if (count == 0) {
				jsonobject = new JSONObject();
				jsonobject.put("slno", "");
				jsonobject.put("user", "");
				jsonobject.put("customertype", "");
				jsonobject.put("datetime", "");
				jsonobject.put("remarks", "");
				jsonobject.put("locationdelay", "");
				jsonobject.put("startdate", "");
				jsonobject.put("enddate", "");
				jsonobject.put("durationdelay", "");
				jsonobject.put("issuetype", "");
				jsonobject.put("subissuetype", "");
				jsonobject.put("action", "");
				jsonArray.put(jsonobject);
			}
			// }
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jsonArray;
	}
	public String convertMinutesToHHMMSSFormat(String time) 
	{
		String duration="00:00:00";
		if(time!=null) {
			int minutes  = (int)Double.parseDouble(time);
			if(minutes < 0) {
				long seconds = (-minutes) * 60;
				long s = seconds % 60;
				long m = (seconds / 60) % 60;
				long h = (seconds / (60 * 60));
				duration = String.format("%02d:%02d:%02d", h, m, s);
				duration = "-"+duration;
			} else {
				long seconds = (minutes) * 60;
				long s = seconds % 60;
				long m = (seconds / 60) % 60;
				long h = (seconds / (60 * 60));
				duration = String.format("%02d:%02d:%02d", h, m, s);
			}
		} 
		return duration;
	}
	public JSONArray getViewDetails(int systemId, String tripId, int userId, int offset) {
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonobject = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;
		// PreparedStatement pstmt1 = null;
		ResultSet rs = null;
		int count = 0;
		String insertedDate = null;
		try {
			jsonArray = new JSONArray();
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(GeneralVerticalStatements.GET_TRIP_REMARKS_DETAILS.replace("#", "and CUSTOMER_TYPE='Yes' "));
			pstmt.setInt(1, offset);
			pstmt.setString(2, tripId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				count++;
				jsonobject = new JSONObject();
				jsonobject.put("slno", count);
				jsonobject.put("user", rs.getString("USER_NAME"));
				if (!rs.getString("INSERTEDDATE").contains("1900")) {
					insertedDate = sdf1.format(sdfDB.parse(rs.getString("INSERTEDDATE")));
				}
				jsonobject.put("datetime", insertedDate);
				jsonobject.put("remarks", rs.getString("REMARKS"));
				jsonobject.put("locationdelay", rs.getString("LOCATION_DELAY"));
				jsonobject.put("startdate", sdf.format(sdfDB.parse(rs.getString("STARTDATE"))));
				jsonobject.put("enddate", sdf.format(sdfDB.parse(rs.getString("ENDDATE"))));
				jsonobject.put("durationdelay", rs.getString("DELAYTIME"));
				jsonobject.put("issuetype", rs.getString("ISSUETYPE"));
				jsonobject.put("subissuetype", rs.getString("SUBISSUE_TYPE"));
				jsonArray.put(jsonobject);
			}
			if (count == 0) {
				jsonobject = new JSONObject();
				jsonobject.put("slno", "");
				jsonobject.put("user", "");
				jsonobject.put("datetime", "");
				jsonobject.put("remarks", "");
				jsonobject.put("locationdelay", "");
				jsonobject.put("startdate", "");
				jsonobject.put("enddate", "");
				jsonobject.put("durationdelay", "");
				jsonobject.put("issuetype", "");
				jsonobject.put("subissuetype", "");
				jsonArray.put(jsonobject);
			}
			// }
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jsonArray;
	}

	public JSONArray getAlertCounts(int clientId, int systemId, int userId, String custId, String routeId, String custType, String tripType) {
		JSONArray jsonArray = new JSONArray();
		JSONObject obj = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		int dooractionTaken = 0;
		int doortotal = 0;
		int panicactionTaken = 0;
		int panictotal = 0;
		int reportingtotal = 0;
		int reportingactionTaken = 0;
		int tempactionTaken = 0;
		int temptotal = 0;
		int humidityactionTaken = 0;
		int humiditytotal = 0;
		int reeferactionTaken = 0;
		int reefertotal = 0;
		try {
			con = DBConnection.getConnectionToDB("AMS");
			String stmt = GeneralVerticalStatements.GET_ALERT_COUNTS;
			if (routeId.equals("ALL")) {
				stmt = stmt.replace("#", "");
			} else {
				routeId = routeId.substring(0, routeId.length() - 1);
				stmt = stmt.replace("#", " and ROUTE_ID in (" + routeId + ")");
			}

			if (custId.equals("ALL")) {
				stmt = stmt.replace("$", "");
			} else {
				custId = custId.substring(0, custId.length() - 1);
				stmt = stmt.replace("$", " and TRIP_CUSTOMER_ID in (" + custId + ")");
			}
			if (custType.equals("ALL")) {
				stmt = stmt.replace("custTypeCondition", "");
			} else {
				custType = custType.substring(0, custType.length() - 1);
				stmt = stmt.replace("custTypeCondition", "and TRIP_CUSTOMER_TYPE in (" + custType + ")");
			}
			if (tripType.equals("ALL")) {
				stmt = stmt.replace("tripTypeCondition", "");
			} else {
				tripType = tripType.substring(0, tripType.length() - 1);
				stmt = stmt.replace("tripTypeCondition", "and PRODUCT_LINE in (" + tripType + ")");
			}

			pstmt = con.prepareStatement(stmt);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, clientId);
			pstmt.setInt(3, systemId);
			pstmt.setInt(4, clientId);

			pstmt.setInt(5, systemId);
			pstmt.setInt(6, clientId);
			pstmt.setInt(7, systemId);
			pstmt.setInt(8, clientId);

			pstmt.setInt(9, systemId);
			pstmt.setInt(10, clientId);
			pstmt.setInt(11, systemId);
			pstmt.setInt(12, clientId);

			pstmt.setInt(13, systemId);
			pstmt.setInt(14, clientId);
			pstmt.setInt(15, systemId);
			pstmt.setInt(16, clientId);

			pstmt.setInt(17, systemId);
			pstmt.setInt(18, clientId);
			pstmt.setInt(19, systemId);
			pstmt.setInt(20, clientId);

			pstmt.setInt(21, systemId);
			pstmt.setInt(22, clientId);
			pstmt.setInt(23, systemId);
			pstmt.setInt(24, clientId);
			rs = pstmt.executeQuery();

			while (rs.next()) {
				if (rs.getString("TYPE").equals("ACKNOWLEDGE_DOOR")) {
					dooractionTaken = rs.getInt("COUNT");
				}
				if (rs.getString("TYPE").equals("TOTAL_DOOR")) {
					doortotal = rs.getInt("COUNT");
				}

				if (rs.getString("TYPE").equals("ACKNOWLEDGE_PANIC")) {
					panicactionTaken = rs.getInt("COUNT");
				}
				if (rs.getString("TYPE").equals("TOTAL_PANIC")) {
					panictotal = rs.getInt("COUNT");
				}

				if (rs.getString("TYPE").equals("ACKNOWLEDGE_REPORTING")) {
					reportingactionTaken = rs.getInt("COUNT");
				}
				if (rs.getString("TYPE").equals("TOTAL_REPORTING")) {
					reportingtotal = rs.getInt("COUNT");
				}

				if (rs.getString("TYPE").equals("ACKNOWLEDGE_TEMP")) {
					tempactionTaken = rs.getInt("COUNT");
				}
				if (rs.getString("TYPE").equals("TOTAL_TEMP")) {
					temptotal = rs.getInt("COUNT");
				}

				if (rs.getString("TYPE").equals("ACKNOWLEDGE_HUMIDITY")) {
					humidityactionTaken = rs.getInt("COUNT");
				}
				if (rs.getString("TYPE").equals("TOTAL_HUMIDITY")) {
					humiditytotal = rs.getInt("COUNT");
				}

				if (rs.getString("TYPE").equals("ACKNOWLEDGE_REEFER")) {
					reeferactionTaken = rs.getInt("COUNT");
				}
				if (rs.getString("TYPE").equals("TOTAL_REEFER")) {
					reefertotal = rs.getInt("COUNT");
				}

			}
			obj = new JSONObject();
			obj.put("doorCount", dooractionTaken + "/" + doortotal);
			obj.put("panicCount", panicactionTaken + "/" + panictotal);
			obj.put("nonReportingCount", reportingactionTaken + "/" + reportingtotal);
			obj.put("tempCount", tempactionTaken + "/" + temptotal);
			obj.put("humidityCount", humidityactionTaken + "/" + humiditytotal);
			obj.put("reeferCount", reeferactionTaken + "/" + reefertotal);
			jsonArray.put(obj);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jsonArray;
	}

	public JSONArray getAlertDetails(int clientId, int systemId, int userId, String alertId, String tripId, int offset, String custId, String routeId, String custType, String tripType) {
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonobject = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int count = 0;
		String loc = "";
		try {
			jsonArray = new JSONArray();
			con = DBConnection.getConnectionToDB("AMS");
			if (alertId.equalsIgnoreCase("999")) {
				alertId = "187,188,189";
			}
			if (tripId == null) {
				String stmt = GeneralVerticalStatements.GET_ALERT_DETAILS;
				stmt = stmt.replace("&", " TRIP_ID in (select TRIP_ID from AMS.dbo.TRACK_TRIP_DETAILS where STATUS='OPEN' "
						+ " and SYSTEM_ID=? and CUSTOMER_ID=?  # $ custTypeCondition tripTypeCondition)");
				if (routeId.equals("ALL")) {
					stmt = stmt.replace("#", "");
				} else {
					routeId = routeId.substring(0, routeId.length() - 1);
					stmt = stmt.replace("#", " and ROUTE_ID in (" + routeId + ")");
				}
				// if(custName.equals("ALL")){
				// stmt = stmt.replace("$", "");
				// }else{
				// stmt = stmt.replace("$",
				// " and CUSTOMER_NAME='"+custName+"'");
				// }
				if (custId.equals("ALL")) {
					stmt = stmt.replace("$", "");
				} else {
					custId = custId.substring(0, custId.length() - 1);
					// stmt = stmt.replace("$",
					// " and CUSTOMER_ID='"+custId+"'");
					stmt = stmt.replace("$", " and TRIP_CUSTOMER_ID in (" + custId + ")");
				}
				if (custType.equals("ALL")) {
					stmt = stmt.replace("custTypeCondition", "");
				} else {
					custType = custType.substring(0, custType.length() - 1);
					stmt = stmt.replace("custTypeCondition", "and TRIP_CUSTOMER_TYPE in (" + custType + ")");
				}
				if (tripType.equals("ALL")) {
					stmt = stmt.replace("tripTypeCondition", "");
				} else {
					tripType = tripType.substring(0, tripType.length() - 1);
					stmt = stmt.replace("tripTypeCondition", "and PRODUCT_LINE in (" + tripType + ")");
				}
				pstmt = con.prepareStatement(stmt.replace("^^^", alertId));
				pstmt.setInt(1, offset);
				pstmt.setInt(2, systemId);
				pstmt.setInt(3, clientId);
			} else {
				pstmt = con.prepareStatement(GeneralVerticalStatements.GET_ALERT_DETAILS.replace("&", "TRIP_ID =?").replace("^^^", alertId));
				pstmt.setInt(1, offset);
				pstmt.setString(2, tripId);
			}
			rs = pstmt.executeQuery();
			while (rs.next()) {
				count++;
				jsonobject = new JSONObject();
				jsonobject.put("slNoIndex", count);
				jsonobject.put("vehicleNoIndex", rs.getString("VEHICLE_NO"));
				if (rs.getInt("ALERT_TYPE") == 187 || rs.getInt("ALERT_TYPE") == 188 || rs.getInt("ALERT_TYPE") == 189) {
					loc = rs.getString("TEMP_VALUES") + " °C temperature," + rs.getString("LOCATION");
				} else if (rs.getInt("ALERT_TYPE") == 186) {
					loc = rs.getString("TEMP_VALUES") + " % humidity," + rs.getString("LOCATION");
				} else {
					loc = rs.getString("LOCATION");
				}
				jsonobject.put("locationIndex", loc);
				if (!rs.getString("GMT").contains("1900")) {
					jsonobject.put("dateTimeIndex", mmddyyy.format(sdfDB.parse(rs.getString("GMT"))));
				} else {
					jsonobject.put("dateTimeIndex", "");
				}
				jsonobject.put("remarksIndex", rs.getString("REMARKS"));
				if (rs.getString("REMARKS").equals("")) {
					jsonobject.put("button", "<button onclick=Acknowledge(" + rs.getString("ID") + "); class='btn btn-success'>Acknowledge</button> ");
				} else {
					jsonobject.put("button", "");
				}
				jsonArray.put(jsonobject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jsonArray;
	}

	public JSONArray getRoutes(int systemId, int custId) {

		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			jsonArray = new JSONArray();
			jsonObject = new JSONObject();

			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(GeneralVerticalStatements.GET_ROUTES);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, custId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				jsonObject = new JSONObject();
				jsonObject.put("routeId", rs.getString("ROUTE_ID"));
				jsonObject.put("routeName", rs.getString("ROUTE_NAME"));
				jsonArray.put(jsonObject);
			}
		} catch (Exception e) {
			System.out.println("Error in getRoutes " + e.toString());
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jsonArray;

	}

	public JSONArray getCustNames(int custId, int systemId) {

		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			jsonArray = new JSONArray();
			jsonObject = new JSONObject();

			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(GeneralVerticalStatements.GET_CUSTOMERS);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, custId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				jsonObject = new JSONObject();
				jsonObject.put("custName", rs.getString("CUSTOMER_NAME"));

				jsonArray.put(jsonObject);
			}
		} catch (Exception e) {
			System.out.println("Error in getCustNames " + e.toString());
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jsonArray;

	}

	public String updateRemarks(int systemId, String tripId, String remarks, int userId) {
		Connection con = null;
		PreparedStatement pstmt = null;
		String message = "";
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(GeneralVerticalStatements.UPDATE_EVENT);
			pstmt.setString(1, remarks);
			pstmt.setInt(2, userId);
			pstmt.setString(3, tripId);
			int updated = pstmt.executeUpdate();
			if (updated > 0) {
				message = "Acknowledge Saved";
			} else {
				message = "Error.";
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, null);
		}
		return message;
	}

	public JSONArray getSmartTruckAlert(int systemId, int clientId) {
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonobject = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			jsonArray = new JSONArray();
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(GeneralVerticalStatements.GET_SAMRT_TRUCK_ALERT_COUNT);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, clientId);
			pstmt.setInt(3, systemId);
			pstmt.setInt(4, clientId);
			pstmt.setInt(5, systemId);
			pstmt.setInt(6, clientId);
			pstmt.setInt(7, systemId);
			pstmt.setInt(8, clientId);
			pstmt.setInt(9, systemId);
			pstmt.setInt(10, clientId);
			pstmt.setInt(11, systemId);
			pstmt.setInt(12, clientId);
			pstmt.setInt(13, systemId);
			pstmt.setInt(14, clientId);
			pstmt.setInt(15, systemId);
			pstmt.setInt(16, clientId);
			pstmt.setInt(17, systemId);
			pstmt.setInt(18, clientId);
			pstmt.setInt(19, systemId);
			pstmt.setInt(20, clientId);
			pstmt.setInt(21, systemId);
			pstmt.setInt(22, clientId);
			pstmt.setInt(23, systemId);
			pstmt.setInt(24, clientId);
			pstmt.setInt(25, systemId);
			pstmt.setInt(26, clientId);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				jsonobject = new JSONObject();
				int onTrip = rs.getInt("ON_TRIP");
				int totalTrip = rs.getInt("TOTAL_TRIP");
				int onTripAlert = rs.getInt("ON_TRIP_ALERT");
				int totalTripAlert = rs.getInt("TOTAL_TRIP_ALERT");
				jsonobject.put("incentiveCount", onTrip);
				jsonobject.put("onTimeCount1", onTrip);
				jsonobject.put("totalTrip1", totalTrip);
				// jsonobject.put("mileageCount", rs.getInt(""));
				jsonobject.put("mileageCount", 0);
				jsonobject.put("overSpeedCount", rs.getInt("OVER_SPEED"));
				jsonobject.put("hbCount", rs.getInt("HB"));
				jsonobject.put("haCount", rs.getInt("HA"));
				jsonobject.put("hcCount", rs.getInt("HC"));
				// jsonobject.put("freeWheelCount", rs.getInt(""));
				// jsonobject.put("incorrectCount", rs.getInt(""));
				jsonobject.put("freeWheelCount", rs.getString("FREE_WHEELING")); // freewheeling
				jsonobject.put("incorrectCount", rs.getString("LOW_HIGH_RPM")); // low
				// high
				// rpm
				jsonobject.put("routeDeviatonCount", rs.getInt("ROUTE_DEVIATION"));
				jsonobject.put("stoppageCount", rs.getInt("STOPPAGE"));
				jsonobject.put("totalTrip2", totalTripAlert);
				jsonobject.put("onTimeCount2", onTripAlert);
				jsonobject.put("lowMileage", rs.getString("LOW_MILEAGE")); // low
				// kmpl
				// or
				// mileage
				// jsonobject.put("lowMileage", 0);
				jsonArray.put(jsonobject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jsonArray;
	}

	public JSONArray getSmartTruckAlertRemarked(int systemId, int clientId) {
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonobject = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			jsonArray = new JSONArray();
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(GeneralVerticalStatements.GET_SAMRT_TRUCK_REMARKED_ALERT_COUNT);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, clientId);
			pstmt.setInt(3, systemId);
			pstmt.setInt(4, clientId);
			pstmt.setInt(5, systemId);
			pstmt.setInt(6, clientId);
			pstmt.setInt(7, systemId);
			pstmt.setInt(8, clientId);
			pstmt.setInt(9, systemId);
			pstmt.setInt(10, clientId);
			pstmt.setInt(11, systemId);
			pstmt.setInt(12, clientId);
			pstmt.setInt(13, systemId);
			pstmt.setInt(14, clientId);
			pstmt.setInt(15, systemId);
			pstmt.setInt(16, clientId);
			pstmt.setInt(17, systemId);
			pstmt.setInt(18, clientId);
			pstmt.setInt(19, systemId);
			pstmt.setInt(20, clientId);
			pstmt.setInt(21, systemId);
			pstmt.setInt(22, clientId);
			pstmt.setInt(23, systemId);
			pstmt.setInt(24, clientId);
			pstmt.setInt(25, systemId);
			pstmt.setInt(26, clientId);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				jsonobject = new JSONObject();
				int onTrip = rs.getInt("ON_TRIP");
				int totalTrip = rs.getInt("TOTAL_TRIP");
				int onTripAlert = rs.getInt("ON_TRIP_ALERT");
				int totalTripAlert = rs.getInt("TOTAL_TRIP_ALERT");
				jsonobject.put("incentiveCount", onTrip);
				jsonobject.put("onTimeCount1", onTrip);
				jsonobject.put("totalTrip1", totalTrip);
				// jsonobject.put("mileageCount", rs.getInt(""));
				jsonobject.put("mileageCount", 0);
				jsonobject.put("overSpeedCount", rs.getInt("OVER_SPEED"));
				jsonobject.put("hbCount", rs.getInt("HB"));
				jsonobject.put("haCount", rs.getInt("HA"));
				jsonobject.put("hcCount", rs.getInt("HC"));
				// jsonobject.put("freeWheelCount", rs.getInt(""));
				// jsonobject.put("incorrectCount", rs.getInt(""));
				jsonobject.put("freeWheelCount", rs.getString("FREE_WHEELING")); // free
				// wheeling
				jsonobject.put("incorrectCount", rs.getString("LOW_HIGH_RPM")); // low
				// high
				// rpm
				jsonobject.put("routeDeviatonCount", rs.getInt("ROUTE_DEVIATION"));
				jsonobject.put("stoppageCount", rs.getInt("STOPPAGE"));
				jsonobject.put("totalTrip2", totalTripAlert);
				jsonobject.put("onTimeCount2", onTripAlert);
				jsonobject.put("lowMileage", rs.getString("LOW_MILEAGE")); // low
				// mileage
				// or
				// low
				// kmpl
				// jsonobject.put("lowMileage", 0);
				jsonArray.put(jsonobject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jsonArray;
	}

	/* */
	public JSONArray getSamartTruckerAlertDetails(int systemId, int clientId, int userId, String alertId, int offset, String vehicleNo) {
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonobject = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int count = 0;
		try {
			jsonArray = new JSONArray();
			con = DBConnection.getConnectionToDB("AMS");
			String stmt = GeneralVerticalStatements.GET_SAMRT_TRUCK_ALERT_DETAILS;
			if (vehicleNo.equalsIgnoreCase("ALL")) {
				stmt = stmt.replace("#", "");
			} else {
				stmt = stmt.replace("#", " and VEHICLE_NO='" + vehicleNo + "'");
			}
			pstmt = con.prepareStatement(stmt);
			pstmt.setInt(1, offset);
			pstmt.setString(2, alertId);
			pstmt.setInt(3, systemId);
			pstmt.setInt(4, clientId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				count++;
				jsonobject = new JSONObject();
				jsonobject.put("slNoIndex", count);
				jsonobject.put("vehicleNoIndex", rs.getString("VEHICLE_NO"));
				jsonobject.put("locationIndex", rs.getString("LOCATION"));
				if (!rs.getString("GMT").contains("1900")) {
					jsonobject.put("dateTimeIndex", sdf.format(sdfDB.parse(rs.getString("GMT"))));
				} else {
					jsonobject.put("dateTimeIndex", "");
				}
				jsonobject.put("remarksIndex", rs.getString("REMARKS"));
				if (rs.getString("REMARKS").equals("")) {
					jsonobject.put("button", "<button onclick=Acknowledge(" + rs.getString("ID") + "); class='btn btn-success'>Acknowledge</button> ");
				} else {
					jsonobject.put("button", "");
				}
				jsonArray.put(jsonobject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jsonArray;
	}

	public JSONArray getSamartTruckerDriverAlertDetails(int systemId, int clientId, int userId, String alertId, int offset, int driverId, String groupId) {

		JSONArray jsonArray = new JSONArray();
		JSONObject jsonobject = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		PreparedStatement pstmt1 = null;
		ResultSet rs1 = null;
		int count = 0;
		int condition = 0;
		try {
			jsonArray = new JSONArray();
			if (groupId.equals("0")) {
				condition = 2;
			} else if (groupId.equals("1")) {
				condition = 7;
			} else if (groupId.equals("2")) {
				condition = 30;
			}

			con = DBConnection.getConnectionToDB("AMS");
			pstmt1 = con.prepareStatement(GeneralVerticalStatements.GET_VEHICLE_DETAILS);
			pstmt1.setInt(1, condition);
			pstmt1.setInt(2, systemId);
			pstmt1.setInt(3, driverId);
			pstmt1.setInt(4, condition);
			pstmt1.setInt(5, condition);
			pstmt1.setInt(6, systemId);
			pstmt1.setInt(7, driverId);
			rs1 = pstmt1.executeQuery();
			while (rs1.next()) {
				String vehicleNo = rs1.getString("VEHICLE_NO");
				String startTime = rs1.getString("STARTTIME");
				String endTime = rs1.getString("END_TIME");
				pstmt = con.prepareStatement(GeneralVerticalStatements.GET_SAMRT_TRUCK_ALERT_DETAILS_FOR_TABLE);
				pstmt.setInt(1, offset);
				pstmt.setString(2, alertId);
				pstmt.setString(3, startTime);
				pstmt.setString(4, endTime);
				pstmt.setInt(5, systemId);
				pstmt.setInt(6, clientId);
				pstmt.setString(7, vehicleNo);
				rs = pstmt.executeQuery();

				while (rs.next()) {
					jsonobject = new JSONObject();
					jsonobject.put("slNoIndex", ++count);
					jsonobject.put("vehicleNoIndex", rs.getString("VEHICLE_NO"));
					jsonobject.put("locationIndex", rs.getString("LOCATION"));
					if (!rs.getString("GMT").contains("1900")) {
						jsonobject.put("dateTimeIndex", sdf.format(sdfDB.parse(rs.getString("GMT"))));
					} else {
						jsonobject.put("dateTimeIndex", "");
					}
					jsonobject.put("remarksIndex", rs.getString("REMARKS"));
					if (rs.getString("REMARKS").equals("")) {
						jsonobject.put("button", "<button onclick=Acknowledge(" + rs.getString("ID") + "); class='btn btn-warning'>Acknowledge</button> ");
					} else {
						jsonobject.put("button", "");
					}
					jsonArray.put(jsonobject);
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
			DBConnection.releaseConnectionToDB(null, pstmt1, rs1);
		}

		return jsonArray;
	}

	/* */
	public JSONArray getSamartTruckerAlertDetailsNonRemark(int systemId, int clientId, int offset) {
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonobject = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int count = 0;
		try {
			jsonArray = new JSONArray();
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(GeneralVerticalStatements.GET_SAMRT_TRUCK_ALERT_DETAILS_NON_REMARK);
			pstmt.setInt(1, offset);
			pstmt.setInt(2, systemId);
			pstmt.setInt(3, clientId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				count++;
				jsonobject = new JSONObject();
				jsonobject.put("slNoIndex", count);
				jsonobject.put("vehicleNoIndex", rs.getString("VEHICLE_NO"));
				jsonobject.put("locationIndex", rs.getString("LOCATION"));
				if (!rs.getString("GMT").contains("1900")) {
					jsonobject.put("dateTimeIndex", sdf.format(sdfDB.parse(rs.getString("GMT"))));
				} else {
					jsonobject.put("dateTimeIndex", "");
				}
				jsonobject.put("remarksIndex", "");
				jsonobject.put("button", "");
				jsonArray.put(jsonobject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jsonArray;
	}

	public JSONArray getSmartTruckTableDetails(int systemId, int clientId, int offset, String groupId) {
		JSONArray jsonArray = new JSONArray();
		// JSONObject jsonobject = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		PreparedStatement pstmt1 = null;
		ResultSet rs1 = null;
		// int count = 0;
		try {
			jsonArray = new JSONArray();
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(GeneralVerticalStatements.GET_DRIVER_DETAILS);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, clientId);
			rs = pstmt.executeQuery();
			ArrayList<String> vehicleList = null;
			boolean vehicleExist = false;
			Map<Integer, ArrayList<String>> vehicleMap = new HashMap<Integer, ArrayList<String>>();
			int condition = 0;
			while (rs.next()) {

				if (groupId.equals("0")) {
					condition = 2;
				} else if (groupId.equals("1")) {
					condition = 7;
				} else if (groupId.equals("2")) {
					condition = 30;
				}
				vehicleExist = false;
				vehicleList = new ArrayList<String>();
				int driverid = rs.getInt("Driver_id");
				String driverName = rs.getString("fullname");
				String contact = rs.getString("Contact_No");
				pstmt1 = con.prepareStatement(GeneralVerticalStatements.GET_VEHICLE_DETAILS);
				pstmt1.setInt(1, condition);
				pstmt1.setInt(2, systemId);
				pstmt1.setInt(3, driverid);
				pstmt1.setInt(4, condition);
				pstmt1.setInt(5, condition);
				pstmt1.setInt(6, systemId);
				pstmt1.setInt(7, driverid);
				rs1 = pstmt1.executeQuery();
				while (rs1.next()) {
					vehicleExist = true;
					String driverInfo = rs1.getString("VEHICLE_NO") + "#" + driverName + "#" + contact + "#" + rs1.getString("STARTTIME") + "#" + rs1.getString("END_TIME");
					vehicleList.add(driverInfo);
				}
				if (vehicleExist) {
					vehicleMap.put(driverid, vehicleList);
				}
			}
			jsonArray = getDriverAlerCounts(con, systemId, clientId, offset, vehicleMap);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jsonArray;
	}

	public JSONArray getDriverAlerCounts(Connection con, int systemId, int clientId, int offset, Map<Integer, ArrayList<String>> vehicleMap) {
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		JSONArray jsonArray = null;
		JSONObject jsonobject = null;
		try {
			jsonArray = new JSONArray();
			con = DBConnection.getConnectionToDB("AMS");

			Set<Integer> driverIdSet = vehicleMap.keySet();

			Iterator<Integer> driverId = driverIdSet.iterator();
			int slno = 0;
			while (driverId.hasNext()) {
				int driverID = driverId.next();
				++slno;
				int totalCount = 0;
				int overSpeedCount = 0;
				int hbCount = 0;
				int haCount = 0;
				int hcCount = 0;
				int routeDeviatonCount = 0;
				int stoppageCount = 0;
				String vehNum = null;
				ArrayList<String> vehicleNoList = vehicleMap.get(driverID);
				String driverName = "";
				String contactNo = "";
				String startDate = "";
				String endDate = "";
				ArrayList<String> vehList = new ArrayList<String>();
				for (String vehicleNO : vehicleNoList) {
					String[] driverInfo = vehicleNO.split("#");

					vehNum = driverInfo[0];
					vehList.add(vehNum.trim());
					driverName = driverInfo[1];
					contactNo = driverInfo[2];
					startDate = driverInfo[3];
					endDate = driverInfo[4];
					pstmt = con.prepareStatement(GeneralVerticalStatements.GET_DRIVER_ALERT_COUNTS);
					pstmt.setString(1, vehNum);
					pstmt.setString(2, startDate);
					pstmt.setString(3, endDate);
					pstmt.setInt(4, systemId);
					pstmt.setInt(5, clientId);
					rs = pstmt.executeQuery();

					int vechileAlertCount = 0;
					while (rs.next()) {
						int alertType = rs.getInt("ALERT_TYPE");
						int alertCount = rs.getInt("Total_ALERT_COUNT");
						vechileAlertCount += alertCount;
						switch (alertType) {
						case 1:
							stoppageCount += alertCount;
							break;
						case 2:
							overSpeedCount += alertCount;
							break;
						case 5:
							routeDeviatonCount += alertCount;
							break;
						case 58:
							hbCount += alertCount;
							break;
						case 105:
							haCount += alertCount;
							break;
						case 106:
							hcCount += alertCount;
							break;
						}

						// alertMap.put(alertType, alertCount);
					}
					totalCount += vechileAlertCount;
					// alertMap.put(0, totalCount);
				}

				jsonobject = new JSONObject();
				jsonobject.put("slno", slno);
				jsonobject.put("vehicleNumber", vehList.toString());
				jsonobject.put("driverName", driverName);
				jsonobject.put("contact", contactNo);
				jsonobject.put("totalAlert", totalCount);
				jsonobject.put("overSpeedCount", overSpeedCount);
				jsonobject.put("hbCount", hbCount);
				jsonobject.put("haCount", haCount);
				jsonobject.put("hcCount", hcCount);
				jsonobject.put("freeWheelCount", 0);
				jsonobject.put("incorrectCount", 0);
				jsonobject.put("routeDeviatonCount", routeDeviatonCount);
				jsonobject.put("stoppageCount", stoppageCount);
				jsonobject.put("onTimeCount2", 0);
				jsonobject.put("lowMileage", 0);
				jsonobject.put("driverId", driverID);
				jsonArray.put(jsonobject);
			}

			// alertMap.put(0, totalCount);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(null, pstmt, rs);
		}
		return jsonArray;
	}

	/*
	 * public Map<Integer, Integer> getDriverAlerCounts(Connection con ,int
	 * systemId,int clientId,int offset,String vehicleNo,String startDate,String
	 * endDate ){ PreparedStatement pstmt = null; ResultSet rs = null;
	 * Map<Integer, Integer> alertMap=null; try { alertMap = new
	 * HashMap<Integer, Integer>(); con = DBConnection.getConnectionToDB("AMS");
	 * pstmt =
	 * con.prepareStatement(GeneralVerticalStatements.GET_DRIVER_ALERT_COUNTS);
	 * pstmt.setString(1, vehicleNo); pstmt.setString(2, startDate);
	 * pstmt.setString(3, endDate); pstmt.setInt(4, systemId); pstmt.setInt(5,
	 * clientId); rs = pstmt.executeQuery(); int totalCount=0; while (rs.next())
	 * { int alertType=rs.getInt("ALERT_TYPE"); int
	 * alertCount=rs.getInt("Total_ALERT_COUNT"); totalCount+=alertCount;
	 * alertMap.put(alertType, alertCount); } alertMap.put(0, totalCount); }
	 * catch (Exception e) { e.printStackTrace(); }finally {
	 * DBConnection.releaseConnectionToDB(null, pstmt, rs); } return alertMap; }
	 */

	public JSONArray getOEMMakeDetails(int systemId, int clientId) {
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonobject = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			jsonArray = new JSONArray();
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(GeneralVerticalStatements.GET_OEM_MAKE_DETAILS);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, clientId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				jsonobject = new JSONObject();
				jsonobject.put("OEMMakeName", rs.getString("ModelName"));
				jsonobject.put("OEMMakeId", rs.getString("Model"));
				jsonArray.put(jsonobject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jsonArray;
	}

	public JSONArray getOEMVehicleDetails(int systemId, int clientId, String OEMMake) {
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonobject = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = GeneralVerticalStatements.GET_OEM_BASED_VEHICLE_DETAILs;
		try {
			jsonArray = new JSONArray();

			String array1 = (OEMMake.substring(0, OEMMake.length() - 1));

			// String newMakeList
			// ="'"+array1.toString().replace("[","").replace("]",
			// "").replace(" ","").replace(",","','")+"'";
			String newMakeList = "'" + array1.toString().replace(",", "','") + "'";
			con = DBConnection.getConnectionToDB("AMS");

			// query= query.replace("#",
			// " and vm.Model in ("+Integer.parseInt(OEMMake) +")");
			query = query.replace("#", " and vm.Model in (" + newMakeList + ")");
			// if(OEMMake.equalsIgnoreCase("All"))
			// {
			// query=query.replace("#","");
			// }
			// else
			// {
			// query=query.replace("#",
			// "and vm.Model="+Integer.parseInt(OEMMake));
			// }
			pstmt = con.prepareStatement(query);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, clientId);
			// pstmt.setString(3, OEMMake);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				jsonobject = new JSONObject();
				jsonobject.put("vehicleId", rs.getString("VehicleNo"));
				jsonobject.put("vehicleName", rs.getString("VehicleNo"));
				jsonArray.put(jsonobject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jsonArray;
	}

	public JSONArray getTruckTypeList(int systemId, int clientId, String TruckType) {
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonobject = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = GeneralVerticalStatements.GET_TRUCK_TYPE_DETAILS;
		try {
			jsonArray = new JSONArray();
			con = DBConnection.getConnectionToDB("AMS");

			String array1 = (TruckType.substring(0, TruckType.length() - 1));

			// String newtypeList
			// ="'"+array1.toString().replace("[","").replace("]",
			// "").replace(" ","").replace(",","','")+"'";
			String newtypeList = "'" + array1.toString().replace(",", "','") + "'";

			query = query.replace("#", " and VehicleNo in (" + newtypeList + ")");

			// if(TruckType.equalsIgnoreCase("All"))
			// {
			// query=query.replace("#", "");
			// }
			// else
			// {
			// query=query.replace("#", "and VehicleNo='"+TruckType+"'");
			// }
			pstmt = con.prepareStatement(query);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, clientId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				jsonobject = new JSONObject();
				jsonobject.put("VehicleType", rs.getString("VehicleType"));
				jsonobject.put("VehicleTypeId", rs.getString("VehicleAlias"));
				jsonArray.put(jsonobject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jsonArray;
	}

	public JSONArray getCustNamesSLA(int custId, int systemId, int userId) {

		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			jsonArray = new JSONArray();
			jsonObject = new JSONObject();

			// while(rs.next()){
			Properties properties = ApplicationListener.prop;
			String userName = properties.getProperty("SLADashboardUserId");
			if (Integer.parseInt(userName) == userId) {
				jsonObject = new JSONObject();
				jsonObject.put("custName", "BLUE DART");
				jsonArray.put(jsonObject);
			}
			// }
		} catch (Exception e) {
			System.out.println("Error in getCustNamesSLA " + e.toString());
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jsonArray;
	}

	public JSONArray getSmartTruckHealthDBDetails(int systemId, int clientId, String makeList, String vehicleList, String truckTypeList) {
		JSONObject jsonobject = new JSONObject();
		JSONArray jsonArray = null;
		Connection con = null;
		try {
			jsonArray = new JSONArray();
			con = DBConnection.getConnectionToDB("AMS");
			ArrayList<Integer> topcount = getSmartTruckHealthDBDetails1(con, systemId, clientId, makeList, vehicleList, truckTypeList, "and ACTION_TAKEN is null");
			if (topcount.size() > 0) {
				jsonobject = new JSONObject();
				jsonobject.put("topPowerTrain", topcount.get(0));
				jsonobject.put("topChasis", topcount.get(1));
				jsonobject.put("topBody", topcount.get(2));
				jsonArray.put(jsonobject);
			} else {
				jsonobject = new JSONObject();
				jsonobject.put("topPowerTrain", 0);
				jsonobject.put("topChasis", 0);
				jsonobject.put("topBody", 0);
				jsonArray.put(jsonobject);
			}
			ArrayList<Integer> totalCount = getSmartTruckHealthDBDetails1(con, systemId, clientId, makeList, vehicleList, truckTypeList, "");
			if (totalCount.size() > 0) {
				jsonobject = new JSONObject();
				jsonobject.put("totalPowerTrain", totalCount.get(0));
				jsonobject.put("totalChasis", totalCount.get(1));
				jsonobject.put("totalBody", totalCount.get(2));
				jsonArray.put(jsonobject);
			} else {
				jsonobject = new JSONObject();
				jsonobject.put("totalPowerTrain", 0);
				jsonobject.put("totalChasis", 0);
				jsonobject.put("totalBody", 0);
				jsonArray.put(jsonobject);
			}
			ArrayList<Integer> topbatteryCount = getSmartTruckHealthDBDetails2(con, systemId, clientId, makeList, vehicleList, truckTypeList, " and TYPE_OF_ALERT=183 and ACTION_TAKEN is null");
			if (topbatteryCount.size() > 0) {
				jsonobject = new JSONObject();
				jsonobject.put("topBatteryVoltageCount", topbatteryCount.get(0));
				jsonArray.put(jsonobject);
			} else {
				jsonobject = new JSONObject();
				jsonobject.put("topBatteryVoltageCount", 0);
				jsonArray.put(jsonobject);
			}
			ArrayList<Integer> totalpowerCount = getSmartTruckHealthDBDetails2(con, systemId, clientId, makeList, vehicleList, truckTypeList, " and TYPE_OF_ALERT=183");
			if (totalpowerCount.size() > 0) {
				jsonobject = new JSONObject();
				jsonobject.put("totalBatteryVoltageCount", totalpowerCount.get(0));
				jsonArray.put(jsonobject);
			} else {
				jsonobject = new JSONObject();
				jsonobject.put("totalBatteryVoltageCount", 0);
				jsonArray.put(jsonobject);
			}
			ArrayList<Integer> toppowerCoolantCount = getSmartTruckHealthDBDetails2(con, systemId, clientId, makeList, vehicleList, truckTypeList, " and TYPE_OF_ALERT=159 and ACTION_TAKEN is null");
			if (toppowerCoolantCount.size() > 0) {
				jsonobject = new JSONObject();
				jsonobject.put("toppowerCoolantCount", toppowerCoolantCount.get(0));
				jsonArray.put(jsonobject);
			} else {
				jsonobject = new JSONObject();
				jsonobject.put("toppowerCoolantCount", 0);
				jsonArray.put(jsonobject);
			}
			ArrayList<Integer> totalpowerCoolantCount = getSmartTruckHealthDBDetails2(con, systemId, clientId, makeList, vehicleList, truckTypeList, " and TYPE_OF_ALERT=159");
			if (totalpowerCoolantCount.size() > 0) {
				jsonobject = new JSONObject();
				jsonobject.put("totalpowerCoolantCount", totalpowerCoolantCount.get(0));
				jsonArray.put(jsonobject);
			} else {
				jsonobject = new JSONObject();
				jsonobject.put("totalpowerCoolantCount", 0);
				jsonArray.put(jsonobject);
			}

			// for low fuel alert count
			ArrayList<Integer> toplowFuelCount = getSmartTruckHealthDBDetailsFuel(con, systemId, clientId, makeList, vehicleList, truckTypeList, " and TYPE_OF_ALERT=193 and ACTION_TAKEN is null");
			if (toplowFuelCount.size() > 0) {
				jsonobject = new JSONObject();
				jsonobject.put("toplowFuelCount", toplowFuelCount.get(0));
				jsonArray.put(jsonobject);
			} else {
				jsonobject = new JSONObject();
				jsonobject.put("toplowFuelCount", 0);
				jsonArray.put(jsonobject);
			}
			ArrayList<Integer> totallowFuelCount = getSmartTruckHealthDBDetailsFuel(con, systemId, clientId, makeList, vehicleList, truckTypeList, " and TYPE_OF_ALERT=193");
			if (totallowFuelCount.size() > 0) {
				jsonobject = new JSONObject();
				jsonobject.put("totallowFuelCount", totallowFuelCount.get(0));
				jsonArray.put(jsonobject);
			} else {
				jsonobject = new JSONObject();
				jsonobject.put("totallowFuelCount", 0);
				jsonArray.put(jsonobject);
			}

			// for ABS EBS alerts
			ArrayList<Integer> topABSEBSCount = getSmartTruckHealthDBDetailsFuel(con, systemId, clientId, makeList, vehicleList, truckTypeList, " and TYPE_OF_ALERT=196 and ACTION_TAKEN is null");
			if (topABSEBSCount.size() > 0) {
				jsonobject = new JSONObject();
				jsonobject.put("topABSEBSCount", topABSEBSCount.get(0));
				jsonArray.put(jsonobject);
			} else {
				jsonobject = new JSONObject();
				jsonobject.put("topABSEBSCount", 0);
				jsonArray.put(jsonobject);
			}
			ArrayList<Integer> totalABSEBSCount = getSmartTruckHealthDBDetailsFuel(con, systemId, clientId, makeList, vehicleList, truckTypeList, " and TYPE_OF_ALERT=196");
			if (totalABSEBSCount.size() > 0) {
				jsonobject = new JSONObject();
				jsonobject.put("totalABSEBSCount", totalABSEBSCount.get(0));
				jsonArray.put(jsonobject);
			} else {
				jsonobject = new JSONObject();
				jsonobject.put("totalABSEBSCount", 0);
				jsonArray.put(jsonobject);
			}
			// for low kmpl alerts
			ArrayList<Integer> toplowKmplCount = getSmartTruckHealthDBDetailsFuel(con, systemId, clientId, makeList, vehicleList, truckTypeList, " and TYPE_OF_ALERT=195 and ACTION_TAKEN is null");
			if (toplowKmplCount.size() > 0) {
				jsonobject = new JSONObject();
				jsonobject.put("toplowKmplCount", toplowKmplCount.get(0));
				jsonArray.put(jsonobject);
			} else {
				jsonobject = new JSONObject();
				jsonobject.put("toplowKmplCount", 0);
				jsonArray.put(jsonobject);
			}
			ArrayList<Integer> totallowKmplCount = getSmartTruckHealthDBDetailsFuel(con, systemId, clientId, makeList, vehicleList, truckTypeList, " and TYPE_OF_ALERT=195");
			if (totallowKmplCount.size() > 0) {
				jsonobject = new JSONObject();
				jsonobject.put("totallowKmplCount", totallowKmplCount.get(0));
				jsonArray.put(jsonobject);
			} else {
				jsonobject = new JSONObject();
				jsonobject.put("totallowKmplCount", 0);
				jsonArray.put(jsonobject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, null, null);
		}
		return jsonArray;
	}

	public ArrayList<Integer> getSmartTruckHealthDBDetails1(Connection con, int systemId, int clientId, String makeList, String vehicleList, String truckTypeList, String replaceString) {
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		ArrayList<Integer> alert = null;
		String sql = null;
		try {
			alert = new ArrayList<Integer>();

			String array1 = (makeList.substring(0, makeList.length() - 1));
			String array2 = (vehicleList.substring(0, vehicleList.length() - 1));
			String array3 = (truckTypeList.substring(0, truckTypeList.length() - 1));

			String newMakeList = "'" + array1.toString().replace(",", "','") + "'";
			// String newMakeList
			// ="'"+array1.toString().replace("[","").replace("]",
			// "").replace(" ","").replace(",","','")+"'";

			String newVehicleList = "'" + array2.toString().replace(",", "','") + "'";
			// String newVehicleList
			// ="'"+array2.toString().replace("[","").replace("]",
			// "").replace(" ","").replace(",","','")+"'";

			String newTruckList = "'" + array3.toString().replace(",", "','") + "'";
			// String newTruckList
			// ="'"+array3.toString().replace("[","").replace("]",
			// "").replace(" ","").replace(",","','")+"'";
			con = DBConnection.getConnectionToDB("AMS");

			sql = GeneralVerticalStatements.GET_ERROR_ALERT_DETAILS;

			// sql= sql.replace("#", " and b.Model in ("+newMakeList +")");
			// sql=sql.replace("#",
			// " and REGISTRATION_NO in ("+newVehicleList+")");

			// sql=sql.replace("#", " and VehicleType in ("+newTruckList+")");

			sql = sql + " and b.Model in (" + newMakeList + ")";
			sql = sql + " and REGISTRATION_NO in (" + newVehicleList + ")";

			sql = sql + " and VehicleType in (" + newTruckList + ")";

			// if(!OEMMakeId.equalsIgnoreCase("ALL"))
			// {
			// sql=sql+" and b.Model="+OEMMakeId;
			// }
			// if(!vehicleId.equalsIgnoreCase("ALL"))
			// {
			// sql=sql+" and REGISTRATION_NO='"+vehicleId+"'";
			// }
			// if(!typeId.equalsIgnoreCase("ALL"))
			// {
			// sql=sql+" and VehicleType='"+typeId+"'";
			// }
			sql = sql.replace("#", replaceString);
			pstmt = con.prepareStatement(sql);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, clientId);

			rs = pstmt.executeQuery();
			while (rs.next()) {
				alert.add(rs.getInt("PowerTrain"));
				alert.add(rs.getInt("Chasis"));
				alert.add(rs.getInt("Body"));
			}

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(null, pstmt, rs);
		}
		return alert;
	}

	public ArrayList<Integer> getSmartTruckHealthDBDetails2(Connection con, int systemId, int clientId, String makeList, String vehicleList, String truckTypeList, String replaceString) {
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		ArrayList<Integer> alert = null;
		String sql = null;
		try {
			alert = new ArrayList<Integer>();

			String array1 = (makeList.substring(0, makeList.length() - 1));
			String array2 = (vehicleList.substring(0, vehicleList.length() - 1));
			String array3 = (truckTypeList.substring(0, truckTypeList.length() - 1));

			// String newMakeList
			// ="'"+array1.toString().replace("[","").replace("]",
			// "").replace(" ","").replace(",","','")+"'";
			String newMakeList = "'" + array1.toString().replace(",", "','") + "'";

			// String newVehicleList
			// ="'"+array2.toString().replace("[","").replace("]",
			// "").replace(" ","").replace(",","','")+"'";
			String newVehicleList = "'" + array2.toString().replace(",", "','") + "'";

			// String newTruckList
			// ="'"+array3.toString().replace("[","").replace("]",
			// "").replace(" ","").replace(",","','")+"'";
			String newTruckList = "'" + array3.toString().replace(",", "','") + "'";

			con = DBConnection.getConnectionToDB("AMS");
			sql = GeneralVerticalStatements.GET_POWER_COOLANT_COUNT;

			// sql= sql.replace("#", " and b.Model in ("+newMakeList +")");
			// sql=sql.replace("#",
			// " and REGISTRATION_NO in ("+newVehicleList+")");

			// sql=sql.replace("#", " and VehicleType in ("+newTruckList+")");

			sql = sql + " and b.Model in (" + newMakeList + ")";
			sql = sql + " and REGISTRATION_NO in (" + newVehicleList + ")";

			sql = sql + " and VehicleType in (" + newTruckList + ")";

			// if(!OEMMakeId.equalsIgnoreCase("ALL"))
			// {
			// sql=sql+" and b.Model="+OEMMakeId;
			// }
			// if(!vehicleId.equalsIgnoreCase("ALL"))
			// {
			// sql=sql+" and REGISTRATION_NO='"+vehicleId+"'";
			// }
			// if(!typeId.equalsIgnoreCase("ALL"))
			// {
			// sql=sql+" and VehicleType='"+typeId+"'";
			// }
			sql = sql.replace("#", replaceString);
			pstmt = con.prepareStatement(sql);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, clientId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				alert.add(rs.getInt("CoolantCount"));
			}

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(null, pstmt, rs);
		}
		return alert;
	}

	public JSONArray getSmartTruckHealthAlertDetails(int systemId, int clientId, String alertId, String oemMake, String vehicleId, String vehicleType, int offset) {
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonobject = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int count = 0;
		String query = GeneralVerticalStatements.GET_ERROR_ALERT_DETAILS_DESCRIPTION;
		try {
			jsonArray = new JSONArray();
			con = DBConnection.getConnectionToDB("AMS");

			if (alertId.equalsIgnoreCase("Power Train")) {
				query = query + " and ERROR_CODE like 'P%'";
			} else if (alertId.equalsIgnoreCase("Chasis")) {
				query = query + " and ERROR_CODE like 'C%'";
			} else if (alertId.equalsIgnoreCase("Body")) {
				query = query + " and ERROR_CODE like 'B%'";
			} else if (alertId.equalsIgnoreCase("Engine Coolant")) {
				query = GeneralVerticalStatements.GET_POWER_COOLANT_COUNT_DETAILS + " and TYPE_OF_ALERT=159";
			} else if (alertId.equalsIgnoreCase("Battery Voltage")) {
				query = GeneralVerticalStatements.GET_POWER_COOLANT_COUNT_DETAILS + " and TYPE_OF_ALERT=183";
			} else if (alertId.equalsIgnoreCase("Low Fuel Alert")) {
				query = GeneralVerticalStatements.GET_POWER_COOLANT_COUNT_DETAILS + " and TYPE_OF_ALERT=193";
			} else if (alertId.equalsIgnoreCase("ABSEBS")) {
				query = GeneralVerticalStatements.GET_POWER_COOLANT_COUNT_DETAILS + " and TYPE_OF_ALERT=196";
			} else if (alertId.equalsIgnoreCase("lowKmpl")) {
				query = GeneralVerticalStatements.GET_POWER_COOLANT_COUNT_DETAILS + " and TYPE_OF_ALERT=195";
			}

			String array1 = (oemMake.substring(0, oemMake.length() - 1));

			// String newMakeList
			// ="'"+array1.toString().replace("[","").replace("]",
			// "").replace(" ","").replace(",","','")+"'";
			String newMakeList = "'" + array1.toString().replace(",", "','") + "'";

			// query= query.replace("#", " and b.Model in ("+newMakeList +")");
			query = query + " and b.Model in (" + newMakeList + ")";
			// query= query.replace("#", " and b.Model in ("+newMakeList +")");

			String array2 = (vehicleId.substring(0, vehicleId.length() - 1));
			String newVehicleIdList = "'" + array2.toString().replace(",", "','") + "'";

			// String newVehicleIdList
			// ="'"+array2.toString().replace("[","").replace("]",
			// "").replace(" ","").replace(",","','")+"'";

			query = query + " and REGISTRATION_NO in (" + newVehicleIdList + ")";

			String array3 = (vehicleType.substring(0, vehicleType.length() - 1));

			String newVehicleType = "'" + array3.toString().replace(",", "','") + "'";
			// String newVehicleType
			// ="'"+array3.toString().replace("[","").replace("]",
			// "").replace(" ","").replace(",","','")+"'";
			query = query + " and VehicleType in (" + newVehicleType + ")";

			// if(!oemMake.equalsIgnoreCase("ALL"))
			// {
			// query=query+" and b.Model="+oemMake;
			// }
			// if(!vehicleId.equalsIgnoreCase("ALL"))
			// {
			// query=query+" and REGISTRATION_NO='"+vehicleId+"'";
			// }
			// if(!vehicleType.equalsIgnoreCase("ALL"))
			// {
			// query=query+" and VehicleType='"+vehicleType+"'";
			// }
			pstmt = con.prepareStatement(query);
			pstmt.setInt(1, offset);
			pstmt.setInt(2, systemId);
			pstmt.setInt(3, clientId);

			rs = pstmt.executeQuery();
			while (rs.next()) {
				count++;
				jsonobject = new JSONObject();
				jsonobject.put("slNoIndex", count);
				jsonobject.put("vehicleNoIndex", rs.getString("vehicleNo"));
				jsonobject.put("locationIndex", rs.getString("LOCATION"));
				if (!rs.getString("Datevalue").contains("1900")) {
					jsonobject.put("dateTimeIndex", sdf.format(sdfDB.parse(rs.getString("Datevalue"))));
				} else {
					jsonobject.put("dateTimeIndex", "");
				}
				jsonobject.put("remarksIndex", rs.getString("REMARKS"));

				if (alertId.equalsIgnoreCase("Engine Coolant")) {
					int SLNO = rs.getInt("SLNO");
					if (rs.getString("REMARKS").equals("")) {
						jsonobject.put("button", "<button onclick=Acknowledge2('" + SLNO + "',159); class='btn btn-success'>Acknowledge</button>");
					} else {
						jsonobject.put("button", "");
					}
				} else if (alertId.equalsIgnoreCase("Battery Voltage")) {
					int SLNO = rs.getInt("SLNO");
					if (rs.getString("REMARKS").equals("")) {
						jsonobject.put("button", "<button onclick=Acknowledge2('" + SLNO + "',183); class='btn btn-success'>Acknowledge</button>");
					} else {
						jsonobject.put("button", "");
					}
				} else if (alertId.equalsIgnoreCase("Low Fuel Alert")) {
					int SLNO = rs.getInt("SLNO");
					if (rs.getString("REMARKS").equals("")) {
						jsonobject.put("button", "<button onclick=Acknowledge2('" + SLNO + "',193); class='btn btn-success'>Acknowledge</button>");
					} else {
						jsonobject.put("button", "");
					}
				} else if (alertId.equalsIgnoreCase("ABSEBS")) {
					int SLNO = rs.getInt("SLNO");
					if (rs.getString("REMARKS").equals("")) {
						jsonobject.put("button", "<button onclick=Acknowledge2('" + SLNO + "',196); class='btn btn-success'>Acknowledge</button>");
					} else {
						jsonobject.put("button", "");
					}
				} else if (alertId.equalsIgnoreCase("lowKmpl")) {
					int SLNO = rs.getInt("SLNO");
					if (rs.getString("REMARKS").equals("")) {
						jsonobject.put("button", "<button onclick=Acknowledge2('" + SLNO + "',195); class='btn btn-success'>Acknowledge</button>");
					} else {
						jsonobject.put("button", "");
					}
				} else {

					int SLNO = Integer.parseInt(rs.getString("serial"));
					if (rs.getString("REMARKS").equals("")) {
						jsonobject.put("button", "<button onclick=Acknowledge('" + SLNO + "'); class='btn btn-success'>Acknowledge</button>");
					} else {
						jsonobject.put("button", "");
					}
				}
				jsonArray.put(jsonobject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jsonArray;
	}

	public String updateActionTaken(int systemId, int clientId, String remarks, int SLNO) {
		Connection con = null;
		PreparedStatement pstmt = null;
		String message = "";
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(GeneralVerticalStatements.UPDATE_ACTION_TAKEN);
			pstmt.setString(1, remarks);
			pstmt.setInt(2, SLNO);
			pstmt.setInt(3, systemId);
			pstmt.setInt(4, clientId);

			int updated = pstmt.executeUpdate();
			if (updated > 0) {
				message = "Acknowledge Saved";
			} else {
				message = "Error.";
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, null);
		}
		return message;
	}

	public String updateActionTakenEngineCoolant(int systemId, int clientId, String remarks, String SLNO, int errorCode) {
		Connection con = null;
		PreparedStatement pstmt = null;
		String message = "";
		try {
			con = DBConnection.getConnectionToDB("AMS");
			if (errorCode == 159) {
				pstmt = con.prepareStatement(GeneralVerticalStatements.UPDATE_ACTION_TAKEN_POWER + " and TYPE_OF_ALERT=159 ");
			} else if (errorCode == 183) {
				pstmt = con.prepareStatement(GeneralVerticalStatements.UPDATE_ACTION_TAKEN_POWER + " and TYPE_OF_ALERT=183 ");
			} else if (errorCode == 193) {
				pstmt = con.prepareStatement(GeneralVerticalStatements.UPDATE_ACTION_TAKEN_POWER + " and TYPE_OF_ALERT=193 ");
			} else if (errorCode == 196) {
				pstmt = con.prepareStatement(GeneralVerticalStatements.UPDATE_ACTION_TAKEN_POWER + " and TYPE_OF_ALERT=196 ");
			} else if (errorCode == 195) {
				pstmt = con.prepareStatement(GeneralVerticalStatements.UPDATE_ACTION_TAKEN_POWER + " and TYPE_OF_ALERT=195 ");
			}
			pstmt.setString(1, remarks);
			pstmt.setString(2, SLNO);
			pstmt.setInt(3, systemId);
			pstmt.setInt(4, clientId);

			int updated = pstmt.executeUpdate();
			if (updated > 0) {
				message = "Acknowledge Saved";
			} else {
				message = "Error.";
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, null);
		}
		return message;
	}

	public JSONArray getVehiclesForAdminDashboard(int offset, int userId, int clientId, int systemId, String tripStatus) {
		JSONArray VehicleDetailsArray = new JSONArray();
		JSONObject VehicleDetailsObject = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String status = "OPEN";
		String tripStr = "";
		try {
			con = DBConnection.getConnectionToDB("AMS");

			if (tripStatus.equalsIgnoreCase("ontime")) {
				tripStatus = "ON TIME";
				tripStr = "and TRIP_STATUS = '" + tripStatus + "'";
			} else if (tripStatus.equalsIgnoreCase("delayed")) {
				tripStatus = "DELAYED";
				tripStr = "and TRIP_STATUS = '" + tripStatus + "'";
			} else if (tripStatus.equalsIgnoreCase("loading")) {
				tripStatus = "LOADING DETENTION";
				tripStr = "and TRIP_STATUS = '" + tripStatus + "'";
			} else if (tripStatus.equalsIgnoreCase("unloading")) {
				tripStatus = "UNLOADING DETENTION";
				tripStr = "and TRIP_STATUS = '" + tripStatus + "'";
			} else {
				tripStr = "and TRIP_STATUS != 'NEW'";
			}
			String stmt = GeneralVerticalStatements.GET_VEHICLES.concat(tripStr);

			pstmt = con.prepareStatement(stmt);
			pstmt.setInt(1, offset);
			pstmt.setInt(2, userId);
			pstmt.setString(3, status);
			pstmt.setInt(4, systemId);
			pstmt.setInt(5, clientId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				VehicleDetailsObject = new JSONObject();
				VehicleDetailsObject.put("vehicleNo", rs.getString("ASSET_NUMBER"));
				VehicleDetailsObject.put("lat", rs.getString("LATITUDE"));
				VehicleDetailsObject.put("lon", rs.getString("LONGITUDE"));
				VehicleDetailsObject.put("location", rs.getString("LOCATION"));
				if (!rs.getString("GMT").contains("1900")) {
					VehicleDetailsObject.put("gmt", sdf.format(sdfDB.parse(rs.getString("GMT"))));
				} else {
					VehicleDetailsObject.put("gmt", "");
				}
				VehicleDetailsObject.put("tripStatus", rs.getString("TRIP_STATUS"));
				VehicleDetailsArray.put(VehicleDetailsObject);
			}

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return VehicleDetailsArray;
	}

	public JSONArray getTripSummaryDetailsForReport(int systemId, int clientId, int offset, String unit, int userId, String startDate, String endDateJsp, String tripCustomerName, String zone) {
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonobject = new JSONObject();

		JSONArray legDetailsArray;
		JSONObject legDetailsObject;
		Connection con = null;
		PreparedStatement pstmt = null, pstmt1 = null;
		ResultSet rs = null, rs1 = null;
		int count = 0;
		String condition = "";
		double distance = 0;
		double distanceNext = 0;
		String endDate = "";
		Properties prop = ApplicationListener.prop;
		int allowedDetention = Integer.parseInt(prop.getProperty("AllowedDetention"));
		String loadingD = "";
		String unloadingD = "";
		String custD = "";
		try {
			jsonArray = new JSONArray();
			String groupBy = " group by CUSTOMER_REF_ID,NEXT_POINT_DISTANCE,AVG_SPEED,STOPPAGE_DURATION,td.ROUTE_ID,td.TRIP_ID,td.SHIPMENT_ID,td.ASSET_NUMBER,td.CUSTOMER_NAME,td.DEST_ARR_TIME_ON_ATD,"
					+ "	 td.DRIVER_NAME,td.DRIVER_NUMBER,gps.LOCATION,NEXT_POINT,td.TRIP_START_TIME,td.ACTUAL_TRIP_START_TIME,td.NEXT_POINT_ETA,td.DESTINATION_ETA,ds.PLANNED_ARR_DATETIME,"
					+ "	 td.ACTUAL_DISTANCE,ds1.NAME,ds.NAME,td.STATUS,td.TRIP_STATUS,td.DELAY,ACTUAL_TRIP_END_TIME,ds.PLANNED_ARR_DATETIME,DESTINATION_ETA,ACTUAL_TRIP_START_TIME,ACT_SRC_ARR_DATETIME,"
					+ "	 ORDER_ID,vm.ModelName,td.ROUTE_NAME,ds1.PLANNED_ARR_DATETIME,ds1.ACT_ARR_DATETIME,ds.ACT_ARR_DATETIME,td.ACTUAL_DISTANCE,ds.ACT_DEP_DATETIME,"
					+ "	 td.FUEL_CONSUMED,td.MILEAGE,td.OBD_MILEAGE,td.NEXT_LEG,td.NEXT_LEG_ETA,ll0.HUB_CITY, ll1.HUB_CITY, ll0.HUB_STATE, ll1.HUB_STATE,u.Firstname,u.Lastname,vm.VehType,td.REMARKS,"
					+ " td.PRODUCT_LINE,td.TRIP_CATEGORY,trd.ROUTE_KEY,UNSCHEDULED_STOP_DUR,PLANNED_DURATION,ds1.DISTANCE_FLAG,ds1.DETENTION_TIME,ds.DETENTION_TIME,td.END_LOCATION,RED_DUR_T1,RED_DUR_T2,RED_DUR_T3,DISTANCE_TRAVELLED "
					+ " ,td.INSERTED_TIME,c.VehicleType,ACTUAL_DURATION,trd.TAT, rd.TRAVEL_TIME,td.TRIP_CUSTOMER_TYPE,gps.DRIVER_NAME,gps.DRIVER_MOBILE,custd.CUSTOMER_REFERENCE_ID,gps.GMT ";

			con = DBConnection.getConnectionToDB("AMS");
			condition = " and td.TRIP_START_TIME between dateadd(mi,-?,?) and dateadd(mi,-?,?)";
			if (tripCustomerName.equals("All")) {
				pstmt = con.prepareStatement(GeneralVerticalStatements.GET_TRIP_SUMMARY_DETAILS_DHL.replace("&", condition).replace("#", "").replaceAll("330", "" + offset).replace("$", "").replace(
						"custTypeCondition", "").replace("tripTypeCondition", "").replaceAll("AMS.dbo.LOCATION", "AMS.dbo.LOCATION_ZONE_" + zone)
						+ groupBy);
			} else {
				pstmt = con.prepareStatement(GeneralVerticalStatements.GET_TRIP_SUMMARY_DETAILS_DHL.replace("&", "and CUSTOMER_NAME='" + tripCustomerName + "'").replace("#", condition).replace("$",
						"").replaceAll("330", "" + offset).replace("custTypeCondition", "").replace("tripTypeCondition", "").replaceAll("AMS.dbo.LOCATION", "AMS.dbo.LOCATION_ZONE_" + zone)
						+ groupBy);
			}
			pstmt.setInt(1, offset);
			pstmt.setInt(2, offset);
			pstmt.setInt(3, offset);
			pstmt.setInt(4, offset);
			pstmt.setInt(5, offset);
			pstmt.setInt(6, offset);
			pstmt.setInt(7, offset);
			pstmt.setInt(8, allowedDetention);
			pstmt.setInt(9, offset);
			pstmt.setInt(10, offset);
			pstmt.setInt(11, offset);
			// pstmt.setInt(12, allowedDetention);
			pstmt.setInt(12, offset);
			pstmt.setInt(13, offset);
			pstmt.setInt(14, offset);
			pstmt.setInt(15, offset);
			pstmt.setInt(16, systemId);
			pstmt.setInt(17, clientId);
			pstmt.setInt(18, offset);
			pstmt.setString(19, startDate);
			pstmt.setInt(20, offset);
			pstmt.setString(21, endDateJsp);

			rs = pstmt.executeQuery();
			while (rs.next()) {
				legDetailsArray = new JSONArray();
				endDate = "";
				count++;
				String STD = "";
				if (!rs.getString("STD").contains("1900")) {
					STD = sdf.format(sdfDB.parse(rs.getString("STD")));
				}
				String ATD = "";
				if (!rs.getString("ATD").contains("1900")) {
					ATD = sdf.format(sdfDB.parse(rs.getString("ATD")));
				}
				String ETHA = "";
				if (!rs.getString("ETHA").contains("1900")) {
					ETHA = sdf.format(sdfDB.parse(rs.getString("ETHA")));
				}
				String ETA = "";
				if (!rs.getString("ETA").contains("1900")) {
					ETA = sdf.format(sdfDB.parse(rs.getString("ETA")));
				}
				String STA = "";
				if (!rs.getString("STA").contains("1900")) {
					STA = sdf.format(sdfDB.parse(rs.getString("STA")));
				}
				String ATP = "";
				if (!rs.getString("ATP").contains("1900")) {
					ATP = sdf.format(sdfDB.parse(rs.getString("ATP")));
				}
				String STP = "";
				if (!rs.getString("STP").contains("1900")) {
					STP = sdf.format(sdfDB.parse(rs.getString("STP")));
				}
				String ATA = "";
				if (!rs.getString("ATA").contains("1900")) {
					ATA = sdf.format(sdfDB.parse(rs.getString("ATA")));
				}
				jsonobject = new JSONObject();

				int tripNo = rs.getInt("TRIP_NO");
				jsonobject.put("slNo", count);
				jsonobject.put("tripNo", rs.getString("TRIP_NO"));
				jsonobject.put("ShipmentId", rs.getString("TRIP_ID"));
				jsonobject.put("routeName", rs.getString("ROUTE_NAME"));
				jsonobject.put("vehicleNo", rs.getString("VEHICLE_NO"));
				jsonobject.put("make", rs.getString("MAKE"));
				jsonobject.put("lrNo", rs.getString("LR_NO"));
				jsonobject.put("custRefId", rs.getString("CUSTOMER_REF_ID"));
				jsonobject.put("customerName", rs.getString("CUSTOMER_NAME"));
				jsonobject.put("driverName", rs.getString("DRIVER_NAME"));
				jsonobject.put("driverContact", rs.getString("DRIVER_NUMBER"));
				jsonobject.put("Location", rs.getString("LOCATION"));
				jsonobject.put("origin", rs.getString("ORIGIN"));
				jsonobject.put("Destination", rs.getString("DESTINATION").toUpperCase());
				jsonobject.put("OriginCity", rs.getString("ORG_City").toUpperCase());
				jsonobject.put("OriginState", rs.getString("ORG_STATE").toUpperCase());
				jsonobject.put("DestCity", rs.getString("DEST_CITY").toUpperCase());
				jsonobject.put("DestState", rs.getString("DEST_STATE").toUpperCase());
				jsonobject.put("Destination", rs.getString("DESTINATION"));
				jsonobject.put("OriginCity", rs.getString("ORG_City").toUpperCase());
				jsonobject.put("OriginState", rs.getString("ORG_STATE").toUpperCase());
				jsonobject.put("DestCity", rs.getString("DEST_CITY").toUpperCase());
				jsonobject.put("DestState", rs.getString("DEST_STATE").toUpperCase());

				jsonobject.put("status", rs.getString("STATUS"));

				jsonobject.put("STP", STP);
				jsonobject.put("ATP", ATP);
				jsonobject.put("STD", STD);
				jsonobject.put("ATD", ATD);
				jsonobject.put("nearestHub", rs.getString("NEAREST_HUB"));
				distanceNext = rs.getDouble("DISTANCE_TO_NEXTHUB");
				if (unit.equals("Miles")) {
					distanceNext = rs.getDouble("DISTANCE_TO_NEXTHUB") * 0.621371;
				}
				jsonobject.put("distanceToNextHub", df.format(distanceNext));
				jsonobject.put("ETHA", ETHA);
				jsonobject.put("ETA", ETA);
				jsonobject.put("STA", STA);
				jsonobject.put("ATA", ATA);

				String beforeTime = rs.getInt("beforeTime") > 0 ? cf.convertMinutesToHHMMFormat(rs.getInt("beforeTime")) : "00:00";
				// System.out.println("beforeTime : " + beforeTime);
				jsonobject.put("beforeTime", beforeTime);
				String delayS = cf.convertMinutesToHHMMFormat(rs.getInt("transitDelay"));
				String delayE = cf.convertMinutesToHHMMFormatNegative(rs.getInt("transitDelay"));
				if (rs.getInt("transitDelay") < 0) {
					jsonobject.put("delay", delayE);
				} else {
					jsonobject.put("delay", delayS);
				}
				double avgSpped = rs.getDouble("AVG_SPEED");
				if (unit.equals("Miles")) {
					avgSpped = rs.getDouble("AVG_SPEED") * 0.621371;
				}
				jsonobject.put("avgSpeed", df.format(avgSpped));
				String stoppageTime = cf.convertMinutesToHHMMFormat(rs.getInt("STOPPAGE_TIME"));
				jsonobject.put("stoppageTime", stoppageTime);

				distance = rs.getDouble("TOTAL_DISTANCE");
				if (unit.equals("Miles")) {
					distance = rs.getDouble("TOTAL_DISTANCE") * 0.621371;
				}
				jsonobject.put("totalDist", df.format(distance));
				if (rs.getInt("PLACEMENT_DELAY") < 0) {
					jsonobject.put("placementDelay", cf.convertMinutesToHHMMFormatNegative(rs.getInt("PLACEMENT_DELAY")));
				} else {
					jsonobject.put("placementDelay", cf.convertMinutesToHHMMFormat(rs.getInt("PLACEMENT_DELAY")));
				}
				if (rs.getInt("LOADING_DETENTION") < 0) {
					loadingD = "00:00";
				} else {
					loadingD = cf.convertMinutesToHHMMFormat(rs.getInt("LOADING_DETENTION"));
				}
				if (rs.getInt("UNLOADING_DETENTION") < 0) {
					unloadingD = "00:00";
				} else {
					unloadingD = cf.convertMinutesToHHMMFormat(rs.getInt("UNLOADING_DETENTION"));
				}
				int custDete = rs.getInt("LOADING_DETENTION") + rs.getInt("UNLOADING_DETENTION");
				if (custDete < 0) {
					custD = "00:00";
				} else {
					custD = cf.convertMinutesToHHMMFormat(custDete);
				}
				jsonobject.put("customerDetentionTime", custD);
				jsonobject.put("loadingDetentionTime", loadingD);
				jsonobject.put("unloadingDetentionTime", unloadingD);
				String flag = "";
				if (rs.getString("FLAG").equalsIgnoreCase("GREEN")) {
					flag = " <div class='location-icon'><img src='/ApplicationImages/VehicleImages/startflag.png'></div> ";
				} else if (rs.getString("FLAG").equalsIgnoreCase("RED")) {
					flag = " <div class='location-icon'><img src='/ApplicationImages/VehicleImages/endflag.png'></div> ";
				}
				jsonobject.put("flag", flag);
				jsonobject.put("weather", "");
				if (!rs.getString("endDate").contains("1900")) {
					endDate = sdf.format(sdfDB.parse(rs.getString("endDate")));
				}
				int RouteId = rs.getInt("ROUTE_ID");
				jsonobject.put("endDateHidden", endDate);
				jsonobject.put("routeIdHidden", RouteId);
				jsonobject.put("panicAlert", rs.getInt("PANIC_COUNT"));
				jsonobject.put("doorAlert", rs.getInt("DOOR_COUNT"));
				jsonobject.put("nonReporting", rs.getInt("NON_REPORTING_COUNT"));
				jsonobject.put("remarks", rs.getString("REMARKS"));
				jsonobject.put("reason", rs.getString("REASON"));
				jsonobject.put("cancelremarks", rs.getString("CANCELLED_REMARKS"));
				Integer delayedDepartureATDSTD = 0;
				Integer totalTripTimeATAATD = 0;
				Integer TriptravelTime = 0;
				if ((!ATD.equals("")) && (!STD.equals(""))) {
					delayedDepartureATDSTD = rs.getInt("DELAYED_DEPARTURE_ATD_STD");
					delayedDepartureATDSTD = delayedDepartureATDSTD < 0 ? 0 : delayedDepartureATDSTD;
				}
				if ((!ATA.equals("")) && (!ATD.equals(""))) {
					totalTripTimeATAATD = rs.getInt("TOTAL_TRIP_TIME_ATA_ATD");
					totalTripTimeATAATD = totalTripTimeATAATD < 0 ? 0 : totalTripTimeATAATD;
				}
				if ((!ATA.equals("")) && (!ATD.equals(""))) {
					TriptravelTime = rs.getInt("TOTAL_TRIP_TIME_ATA_ATD") - rs.getInt("STOPPAGE_TIME");
					TriptravelTime = TriptravelTime < 0 ? 0 : TriptravelTime;
				}
				double greenBandRPMDuration = rs.getDouble("SUM_GBRD");
				double freewheelduration = rs.getDouble("SUM_FWD");

				double lowRPMDuration = Double.parseDouble(rs.getString("LOW_RPM_DUR"));
				double highRPMDuration = Double.parseDouble(rs.getString("HIGH_RPM_DUR"));
				String greenbandRPMPercentage = "";

				String greenbandSpeedPercentage = df.format(rs.getDouble("greenBandSpeedPerc"));

				if ((lowRPMDuration == 0.0) && (highRPMDuration == 0.0) && (greenBandRPMDuration == 0.0) && (freewheelduration == 0.0)) {
					greenbandRPMPercentage = "NA";
				} else {
					greenbandRPMPercentage = df.format(rs.getDouble("greenRPMPerc")) + "";

				}

				jsonobject.put("delayedDepartureATDSTD", cf.convertMinutesToHHMMFormat(delayedDepartureATDSTD));
				jsonobject.put("totalTripTimeATAATD", cf.convertMinutesToHHMMFormat(totalTripTimeATAATD));
				jsonobject.put("TripTravelTime", cf.convertMinutesToHHMMFormat(TriptravelTime));
				jsonobject.put("fuelConsumed", df.format(rs.getDouble("fuelConsumed")));
				jsonobject.put("mileageFuelSensor", df.format(rs.getDouble("MILEAGE")));
				jsonobject.put("mileageOBD", df.format(rs.getDouble("OBD_MILEAGE")));

				jsonobject.put("greenBandRPM", greenbandRPMPercentage);
				jsonobject.put("greenBandSpeed", greenbandSpeedPercentage);

				// String legGroupBy =
				// " group by LEG_NAME, lz.NAME,lz1.NAME ,STD ,STA ,ACTUAL_ARRIVAL,ACTUAL_DEPARTURE,tl.TOTAL_DISTANCE ,tl.AVG_SPEED,tl.FUEL_CONSUMED,tl.MILEAGE,"
				// +
				// " tl.OBD_MILEAGE,ACTUAL_ARRIVAL,ACTUAL_DEPARTURE,d.Fullname,d1.Fullname,ETA,tdd.GREEN_BAND_SPEED_PERC,tdd.GREEN_RPM_PERC,d.Mobile,d1.Mobile,tl.ID,lm.TAT order by tl.LEG_ID ";
				String legGroupBy = " group by tl.LEG_ID , LEG_NAME, lz.NAME,lz1.NAME ,STD ,STA ,ACTUAL_ARRIVAL,ACTUAL_DEPARTURE,tl.TOTAL_DISTANCE ,tl.AVG_SPEED,tl.FUEL_CONSUMED,tl.MILEAGE, "
						+ " tl.OBD_MILEAGE,ACTUAL_ARRIVAL,ACTUAL_DEPARTURE,d.Fullname,d1.Fullname,ETA,tdd.GREEN_BAND_SPEED_PERC,tdd.GREEN_RPM_PERC,d.Mobile,d1.Mobile,tl.ID,lm.TAT "
						+ " ,lm.DISTANCE,lz.Standard_Duration,lz1.Standard_Duration ";

				try {
					pstmt1 = con.prepareStatement(GeneralVerticalStatements.GET_TRIP_SUMMARY_REPORT_LEG_DETAILS.replaceAll("AMS.dbo.LOCATION", "AMS.dbo.LOCATION_ZONE_" + zone) + legGroupBy
							+ " order by tl.ID ");
					pstmt1.setInt(1, offset);
					pstmt1.setInt(2, offset);
					pstmt1.setInt(3, offset);
					pstmt1.setInt(4, offset);
					pstmt1.setInt(5, offset);
					// pstmt1.setInt(6,RouteId);
					pstmt1.setInt(6, tripNo);

					rs1 = pstmt1.executeQuery();
					legDetailsArray = new JSONArray();

					while (rs1.next()) {
						legDetailsObject = new JSONObject();
						legDetailsObject.put("LegName", rs1.getString("LEG_NAME"));
						legDetailsObject.put("Source", rs1.getString("SOURCE"));
						legDetailsObject.put("Destination", rs1.getString("DESTIANTION"));

						String LEGSTD = "";
						if (!rs1.getString("STD").contains("1900")) {
							LEGSTD = sdf.format(sdfDB.parse(rs1.getString("STD")));
						}
						String LEGSTA = "";
						if (!rs1.getString("STA").contains("1900")) {
							LEGSTA = sdf.format(sdfDB.parse(rs1.getString("STA")));
						}

						String LEGATD = "";
						if (!rs1.getString("ATD").contains("1900")) {
							LEGATD = sdf.format(sdfDB.parse(rs1.getString("ATD")));
						}
						String LEGATA = "";
						if (!rs1.getString("ATA").contains("1900")) {
							LEGATA = sdf.format(sdfDB.parse(rs1.getString("ATA")));
						}

						legDetailsObject.put("STD", LEGSTD);
						legDetailsObject.put("STA", LEGSTA);
						legDetailsObject.put("ATA", LEGATA);
						legDetailsObject.put("ATD", LEGATD);

						double legGreenBandRPMDuration = rs1.getDouble("SUM_GBRD");

						String legGreenBandRPM = "NA";
						String legGreenbandSpeedPercentage = df.format(rs.getDouble("greenBandSpeedPerc"));
						double lowRPMDurationLeg = Double.parseDouble(rs.getString("LOW_RPM_DUR"));
						double highRPMDurationLeg = Double.parseDouble(rs.getString("HIGH_RPM_DUR"));
						double freewheeldurationLeg = Double.parseDouble(rs.getString("SUM_FWD"));
						if (!(lowRPMDurationLeg == 0.0 && highRPMDurationLeg == 0.0 && legGreenBandRPMDuration == 0.0 && freewheeldurationLeg == 0.0)) {
							legGreenBandRPM = df.format(rs.getDouble("greenRPMPerc"));
						}

						legDetailsObject.put("TotalDistance", rs1.getString("TOTAL_DISTANCE"));
						legDetailsObject.put("AvgSpeed", rs1.getString("AVG_SPEED"));
						legDetailsObject.put("FuelConsumed", rs1.getString("FUEL_CONSUMED"));
						legDetailsObject.put("Mileage", rs1.getString("MILEAGE"));
						legDetailsObject.put("OBDMileage", rs1.getString("OBD_MILEAGE"));
						legDetailsObject.put("TravelDuration", cf.convertMinutesToHHMMFormat(rs1.getInt("TRAVEL_DURATION")));
						legDetailsObject.put("Driver1", rs1.getString("DRIVER1"));
						legDetailsObject.put("Driver2", rs1.getString("DRIVER2"));
						legDetailsObject.put("LegGreenBandSpeed", legGreenbandSpeedPercentage);
						legDetailsObject.put("LegGreenBandRPM", legGreenBandRPM);

						String LEGETA = "";
						if (!rs1.getString("ETA").contains("1900")) {
							LEGETA = sdf.format(sdfDB.parse(rs1.getString("ETA")));
						}
						legDetailsObject.put("ETA", LEGETA);
						legDetailsArray.put(legDetailsObject);
					}
					jsonobject.put("legdetails", legDetailsArray);
				} catch (Exception e) {
					e.printStackTrace();
				}
				jsonArray.put(jsonobject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
			DBConnection.releaseConnectionToDB(null, pstmt1, rs1);
		}
		return jsonArray;
	}

	public JSONArray getAssociationDetails(int systemId, int clientId, int offset, String vehicleNo, int userId, String unitTypeCode) {
		JSONArray jArr = new JSONArray();
		JSONObject obj = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int digitalCount = 0;
		int analogCount = 0;
		int buttnCount = 0;
		int digitalA = 0;
		int analogA = 0;
		int buttonA = 0;
		int onewireA = 0;
		int onewireCount = 0;
		int zangA = 0;

		PreparedStatement pstmt1 = null;
		ResultSet rs1 = null;
		String recordInfo = "";
		HashMap<String, String> hm = new HashMap<String, String>();
		ArrayList<String> list = new ArrayList<String>();
		// boolean isPresent=false;
		try {
			con = DBConnection.getConnectionToDB("AMS");

			pstmt1 = con.prepareStatement(GeneralVerticalStatements.CHECK_ZANG_RECORD_EXIST);
			rs1 = pstmt1.executeQuery();
			while (rs1.next()) {
				recordInfo = recordInfo + "'" + rs1.getString("VALUE") + "',";
				list.add(rs1.getString("VALUE"));
				hm.put(rs1.getString("VALUE"), "NA");
			}

			pstmt = con.prepareStatement(GeneralVerticalStatements.CHECK_RECORD_EXIST.replace("#", recordInfo.substring(0, recordInfo.length() - 1) == "" ? "notavailable" : recordInfo.substring(0,
					recordInfo.length() - 1)));
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, clientId);
			pstmt.setString(3, vehicleNo);
			pstmt.setInt(4, systemId);
			pstmt.setInt(5, clientId);
			pstmt.setString(6, vehicleNo);
			pstmt.setInt(7, systemId);
			pstmt.setInt(8, clientId);
			pstmt.setString(9, vehicleNo);
			pstmt.setInt(10, systemId);
			pstmt.setInt(11, clientId);
			pstmt.setString(12, vehicleNo);
			pstmt.setInt(13, systemId);
			pstmt.setInt(14, clientId);
			pstmt.setString(15, vehicleNo);
			//			if (recordInfo.isEmpty()) {
			//				pstmt.setString(16, "dsfsfsfdsfsfdsfsfdsfdfsfs");
			//			} else {
			//				pstmt.setString(16, recordInfo.substring(0,
			//						recordInfo.length() - 1));
			//			}
			rs = pstmt.executeQuery();
			while (rs.next()) {
				// if(rs.getInt("counta")>0){
				// isPresent=true;
				// }
				if (rs.getString("type").equals("digital")) {
					digitalA = rs.getInt("counta");
				} else if (rs.getString("type").equals("analog")) {
					analogA = rs.getInt("counta");
				} else if (rs.getString("type").equals("onewire")) {
					onewireA = rs.getInt("counta");
				} else if (rs.getString("type").equals("zang")) {
					zangA = rs.getInt("counta");
				} else {
					buttonA = rs.getInt("counta");
				}
			}
			if (digitalA > 0 || analogA > 0 || buttonA > 0 || onewireA > 0 || zangA > 0) {
				pstmt = con.prepareStatement(GeneralVerticalStatements.GET_ASSOCIATION_DETAILS);
				pstmt.setInt(1, systemId);
				pstmt.setInt(2, clientId);
				pstmt.setString(3, vehicleNo);
				rs = pstmt.executeQuery();
				while (rs.next()) {
					obj = new JSONObject();
					hm.put(rs.getString("ioId"), rs.getString("category"));
					list.remove(rs.getString("ioId"));
					obj.put("UIDDI", rs.getInt("ID"));
					obj.put("inputDI", rs.getString("ioId"));
					obj.put("categoryDI", rs.getString("category"));
					obj.put("ioTYPE", rs.getString("ioType"));
					obj.put("sensorDI", rs.getString("sensorId"));
					jArr.put(obj);
				}
			}
			pstmt = con.prepareStatement(GeneralVerticalStatements.GET_PORT_COUNT);
			pstmt.setString(1, unitTypeCode);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				digitalCount = rs.getInt("digital");
				analogCount = rs.getInt("analog");
				buttnCount = rs.getInt("button");
				onewireCount = rs.getInt("onewire");
			}
			// Compare counts with the associated one. If count is lesser
			// greater than associated one , add the inputs
			if (digitalA < digitalCount) {
				for (int i = digitalA + 1; i <= digitalCount; i++) {
					obj = new JSONObject();
					obj.put("UIDDI", 0);
					obj.put("inputDI", "INP" + i);
					obj.put("categoryDI", "NA");
					obj.put("ioTYPE", "NA");
					jArr.put(obj);
				}
			}
			if (analogA < analogCount) {
				for (int i = analogA + 1; i <= analogCount; i++) {
					obj = new JSONObject();
					obj.put("UIDDI", 0);
					obj.put("inputDI", "ANG" + i);
					obj.put("categoryDI", "NA");
					obj.put("ioTYPE", "NA");
					jArr.put(obj);
				}
			}
			if (buttonA < buttnCount) {
				for (int i = buttonA + 1; i <= buttnCount; i++) {
					obj = new JSONObject();
					obj.put("UIDDI", 0);
					obj.put("inputDI", "IBUTTON" + i);
					obj.put("categoryDI", "NA");
					obj.put("ioTYPE", "NA");
					jArr.put(obj);
				}
			}
			if (onewireA < onewireCount) {
				for (int i = onewireA + 1; i <= onewireCount; i++) {
					obj = new JSONObject();
					obj.put("UIDDI", 0);
					obj.put("inputDI", "ONEWIRE" + i);
					obj.put("categoryDI", "NA");
					obj.put("ioTYPE", "NA");
					jArr.put(obj);
				}
			}

			Set<String> hmParams = hm.keySet();
			// if(isPresent){
			for (String key : hmParams) {
				if (list.contains(key)) {
					obj = new JSONObject();
					obj.put("UIDDI", 0);
					obj.put("inputDI", key);
					obj.put("categoryDI", hm.get(key));

					obj.put("ioTYPE", hm.get(key));
					jArr.put(obj);
				}
			}
			// }

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
			DBConnection.releaseConnectionToDB(null, pstmt1, rs1);
		}
		return jArr;
	}

	public JSONArray getVehicleList(int systemId, int clientId, int userId) {
		JSONArray jArr = new JSONArray();
		JSONObject obj = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			jArr = new JSONArray();
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(GeneralVerticalStatements.CHECK_USER_VEHICLE);
			pstmt.setInt(1, userId);
			pstmt.setInt(2, systemId);
			pstmt.setInt(3, clientId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				obj = new JSONObject();
				obj.put("vehicleNo", rs.getString("vehicleNo"));
				obj.put("unitType", rs.getString("unitType"));
				obj.put("unitNo", rs.getString("unitNo"));
				jArr.put(obj);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jArr;
	}

	public JSONArray getCategoryList(String type) {
		JSONArray jArr = new JSONArray();
		JSONObject obj = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String vertical = "";
		try {
			if (type.contains("INP")) {
				vertical = "RS232_DIGITAL";
			} else if (type.startsWith("ANG") || type.contains("ONEWIRE")) {
				vertical = "RS232_ANALOG";
			} else if (type.contains("BUTTON")) {
				vertical = "RS232_BUTTON";
			} else {
				vertical = "RS232_COMBO";
			}
			jArr = new JSONArray();
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(GeneralVerticalStatements.CHECK_CATEGOTY_LIST);
			pstmt.setString(1, vertical);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				obj = new JSONObject();
				obj.put("typeName", rs.getString("VALUE"));
				jArr.put(obj);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jArr;
	}

	public String insertAssociationDetails(int systemId, int clientId, int userId, JSONArray js, String vehicleNo, String unitNo) {
		JSONObject obj = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String message = "";
		int insert = 0;
		int update = 0;
		try {
			con = DBConnection.getConnectionToDB("AMS");
			for (int i = 0; i < js.length(); i++) {
				obj = js.getJSONObject(i);
				if (obj.getString("UIDDI").equals("0")) {
					// insert a new record
					pstmt = con.prepareStatement(GeneralVerticalStatements.INSERT_ASSOCIATION_DETAILS);
					pstmt.setString(1, vehicleNo);
					pstmt.setString(2, obj.getString("inputDI"));
					pstmt.setString(3, obj.getString("categoryDI"));
					pstmt.setInt(4, systemId);
					pstmt.setInt(5, clientId);
					pstmt.setInt(6, userId);
					pstmt.setString(7, obj.getString("ioTYPE"));// ch
					pstmt.setString(8, obj.getString("sensorDI"));
					insert = pstmt.executeUpdate();
				} else {
					// move to history and update that record.
					pstmt = con.prepareStatement(GeneralVerticalStatements.MOVE_TO_ASSOCIATION_HISTORY);
					pstmt.setInt(1, obj.getInt("UIDDI"));
					pstmt.executeUpdate();

					pstmt = con.prepareStatement(GeneralVerticalStatements.UPDATE_ASSOCIATED_DATA);
					pstmt.setString(1, obj.getString("inputDI"));
					pstmt.setString(2, obj.getString("categoryDI"));
					pstmt.setString(3, obj.getString("ioTYPE"));// ch
					pstmt.setInt(4, userId);
					pstmt.setString(5, obj.getString("sensorDI"));
					pstmt.setString(6, vehicleNo);
					pstmt.setInt(7, obj.getInt("UIDDI"));
					insert = pstmt.executeUpdate();
				}
			}
			if (insert > 0) {
				// delete old records in Live table and inert a fresh new
				// records
				pstmt = con.prepareStatement(GeneralVerticalStatements.DELETE_OLD_RECORDS);
				pstmt.setString(1, vehicleNo);
				pstmt.executeUpdate();
				for (int i = 0; i < js.length(); i++) {
					obj = js.getJSONObject(i);
					pstmt = con.prepareStatement(GeneralVerticalStatements.INERT_INTO_LIVE_TABLE);
					pstmt.setString(1, vehicleNo);
					pstmt.setString(2, unitNo);
					pstmt.setInt(3, 0);
					pstmt.setString(4, obj.getString("categoryDI"));
					pstmt.setString(5, "NA");
					pstmt.setString(6, obj.getString("inputDI"));
					pstmt.setInt(7, systemId);
					pstmt.setInt(8, clientId);
					pstmt.setString(9, obj.getString("sensorDI"));
					update = pstmt.executeUpdate();
				}
			}
			if (update > 0) {
				message = "Success";
			} else {
				message = "Error";
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return message;
	}

	/* Driver Performance Report */

	public JSONArray getDriverPerformaceInformation(int clientId, int systemId, int offset, String startDate, String endDate) {
		JSONArray jsonArray = null;
		try {
			jsonArray = new JSONArray();
			DriverPerformanceReport dpr = new DriverPerformanceReport();
			jsonArray = dpr.GetDriverPerformance(clientId, systemId, offset, startDate, endDate);

		} catch (Exception e) {
			e.printStackTrace();
		}
		return jsonArray;
	}

	public JSONArray getTempDetails(int systemId, int clientId, int offset, int userId, String startDate, String endDate, String regNo, String category) {

		JSONArray JsonArray = new JSONArray();
		JSONObject JsonObject = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		MongoClient mongo = null;
		try {
			JsonArray = new JSONArray();
			JsonObject = new JSONObject();
			mongo = TemperatureConfiguration.getMongoConnection();
			DBCollection collection = mongo.getDB("temperature_module").getCollection("temperature_details");
			BasicDBObject andQuery = new BasicDBObject();
			List<BasicDBObject> obj = new ArrayList<BasicDBObject>();
			obj.add(new BasicDBObject("systemId", systemId));
			obj.add(new BasicDBObject("customerId", clientId));
			obj.add(new BasicDBObject("registrationNo", regNo));
			obj.add(new BasicDBObject("gmt", new BasicDBObject("$gte", sdfDB.parse(cf.getGMT(sdfDB.parse(startDate), offset))).append("$lt", sdfDB.parse(cf.getGMT(sdfDB.parse(endDate), offset)))));
			andQuery.put("$and", obj);
			DBCursor cursor = collection.find(andQuery).sort(new BasicDBObject("gmt", 1));

			String cat[] = category.split(",");
			while (cursor.hasNext()) {

				DBObject theObj = cursor.next();
				BasicDBList tempList = (BasicDBList) theObj.get("temperatureSensorDetails");

				if (cat.length == 1) {
					if (cat[0].equals("T@Container")) {
						JsonObject = new JSONObject();
						JsonObject.put("DATE", timef.format(theObj.get("gpsDatetime")));
						if (theObj.get("meanTemp") != null) {
							JsonObject.put("TEMP", theObj.get("meanTemp"));
						} else {
							JsonObject.put("TEMP", 0);
						}
					} else {
						JsonObject = new JSONObject();
						JsonObject.put("DATE", timef.format(theObj.get("gpsDatetime")));
						for (int j = 0; j < tempList.size(); j++) {
							BasicDBObject tempObj = (BasicDBObject) tempList.get(j);
							if (cat[0].equals(tempObj.getString("name"))) {
								JsonObject.put("TEMP", tempObj.getString("value"));
							}
						}
					}
				} else if (cat.length == 2) {
					JsonObject = new JSONObject();
					JsonObject.put("DATE", timef.format(theObj.get("gpsDatetime")));
					if (cat[1].equals("T@Container")) {
						if (theObj.get("meanTemp") != null) {
							JsonObject.put("TEMP1", theObj.get("meanTemp"));
						} else {
							JsonObject.put("TEMP1", 0);
						}
					}

					if (cat[0].equals("T@Container")) {
						if (theObj.get("meanTemp") != null) {
							JsonObject.put("TEMP", theObj.get("meanTemp"));
						} else {
							JsonObject.put("TEMP", 0);
						}
					}

					for (int j = 0; j < tempList.size(); j++) {
						BasicDBObject tempObj = (BasicDBObject) tempList.get(j);

						if (cat[0].equals(tempObj.getString("name"))) {
							JsonObject.put("TEMP", tempObj.getString("value"));
						}
						if (cat[1].equals(tempObj.getString("name"))) {
							JsonObject.put("TEMP1", tempObj.getString("value"));
						}

					}
				} else if (cat.length == 3) {

					JsonObject = new JSONObject();
					JsonObject.put("DATE", timef.format(theObj.get("gpsDatetime")));
					for (int j = 0; j < tempList.size(); j++) {
						BasicDBObject tempObj = (BasicDBObject) tempList.get(j);

						if (cat[0].equals(tempObj.getString("name"))) {
							JsonObject.put("TEMP", tempObj.getString("value"));
						}
						if (cat[1].equals(tempObj.getString("name"))) {
							JsonObject.put("TEMP1", tempObj.getString("value"));
						}
						if (cat[2].equals(tempObj.getString("name"))) {
							JsonObject.put("TEMP2", tempObj.getString("value"));
						}
					}

					if (cat[0].equals("T@Container")) {
						if (theObj.get("meanTemp") != null) {
							JsonObject.put("TEMP", theObj.get("meanTemp"));
						} else {
							JsonObject.put("TEMP", 0);
						}
					}

					if (cat[1].equals("T@Container")) {
						if (theObj.get("meanTemp") != null) {
							JsonObject.put("TEMP1", theObj.get("meanTemp"));
						} else {
							JsonObject.put("TEMP1", 0);
						}
					}
					if (cat[2].equals("T@Container")) {
						if (theObj.get("meanTemp") != null) {
							JsonObject.put("TEMP2", theObj.get("meanTemp"));
						} else {
							JsonObject.put("TEMP2", 0);
						}
					}
				}
				JsonArray.put(JsonObject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
			mongo.close();
		}
		return JsonArray;
	}

	public JSONArray getTempCount(String regNo, int offset, String startdate, String enddate, String tripId, int sytsemId, int clientId) {
		JSONArray jsonArray = new JSONArray();
		JSONObject obj = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		PreparedStatement pstmt1 = null;
		ResultSet rs1 = null;
		String ref = "";
		String time4 = "";
		String time5 = "";
		String humidity = "NA";
		try {
			con = DBConnection.getConnectionToDB("AMS");
			String stmt = GeneralVerticalStatements.GET_ALL_TEMP_COUNT;
			pstmt = con.prepareStatement(stmt);
			pstmt.setInt(1, offset);
			pstmt.setInt(2, Integer.parseInt(tripId));
			pstmt.setInt(3, sytsemId);
			pstmt.setInt(4, clientId);
			rs = pstmt.executeQuery();
			JSONArray temperatureArray = new JSONArray();
			JSONObject tempObj;
			while (rs.next()) {
				tempObj = new JSONObject();
				tempObj.put("name", rs.getString("SENSOR_NAME"));
				tempObj.put("value", rs.getString("VALUE"));
				if (rs.getString("GMT") != null) {
					tempObj.put("time", sdf1.format(sdfDB.parse((rs.getString("GMT")))));
				} else {
					tempObj.put("time", "");
				}
				temperatureArray.put(tempObj);
			}
			pstmt = con.prepareStatement(GeneralVerticalStatements.GET_TEMP_COUNT4);
			pstmt.setInt(1, offset);
			pstmt.setString(2, regNo);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				if (rs.getString("REEFER").equals("0")) {
					ref = "OFF";
				} else if (rs.getString("REEFER").equals("1")) {
					ref = "ON";
				} else {
					ref = rs.getString("REEFER");
				}
				time4 = rs.getString("GMT");
			}
			pstmt = con.prepareStatement("select IONO,ALERTID from dbo.VEHICLEIOASSOCIATION  where VEHICLEID = ? " + " and IONO in('IO6','IO7') and ALERTID in (186,187)");
			pstmt.setString(1, regNo);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				pstmt1 = con.prepareStatement(GeneralVerticalStatements.GET_HUMIDITY);
				pstmt1.setInt(1, offset);
				pstmt1.setString(2, regNo);
				rs1 = pstmt1.executeQuery();
				if (rs1.next()) {
					humidity = rs1.getString("Humidity");
					time5 = rs1.getString("GMT");
				}
			}
			// /////////////////////////////////////////////////////////////////////////////////////////////////////////////
			pstmt1 = con.prepareStatement(CreateTripStatement.GET_TRIP_VEHICLE_TEMPERATURE_DETAILS);
			pstmt1.setString(1, tripId);
			pstmt1.setString(2, regNo);
			rs1 = pstmt1.executeQuery();

			String tblData = "";
			boolean data = false;
			while (rs1.next()) {
				data = true;
				double negativeMaxTemp = rs1.getDouble("MAX_NEGATIVE_TEMP");
				double negativeMinTemp = rs1.getDouble("MIN_NEGATIVE_TEMP");
				double positiveMaxTemp = rs1.getDouble("MAX_POSITIVE_TEMP");
				double positiveMinTemp = rs1.getDouble("MIN_POSITIVE_TEMP");
				String displayName = rs1.getString("DISPLAY_NAME");
				double positiveMaxTemp2 = positiveMaxTemp;// +1;
				double negativeMinTemp2 = negativeMinTemp;// -1;

				tblData = tblData + "<tr><td style = 'padding-left: 50px;'><b> " + displayName + "</b></td><td><b style='color:green;'>&nbsp;GREEN : &nbsp;</b></td><td>" + negativeMaxTemp + " to "
						+ positiveMinTemp + "</td><td><b style='color:#f7b704 ;'>&nbsp; &nbsp;&nbsp;YELLOW : &nbsp;</b></td><td>" + negativeMinTemp + " to " + negativeMaxTemp + "; " + positiveMinTemp
						+ " to " + positiveMaxTemp + "</td><td><b style='color:red;'> &nbsp;&nbsp;&nbsp;RED :&nbsp;</b></td><td>-70 to " + negativeMinTemp2 + "; " + positiveMaxTemp2
						+ " to 70</td></tr>";
			}
			if (data == false) {
				tblData = "NA";
			}
			// //////////////////////////////////////////////////////////////////////////////////////////////////////////////////
			obj = new JSONObject();
			obj.put("temperatureData", temperatureArray);
			obj.put("humidity", humidity);
			obj.put("REFFER", ref);
			obj.put("temperatureRange", "<table><tr><td style='font-size: 15px;'><b>Temperature Range :  &nbsp; &nbsp;   </b></td></tr>" + tblData + "</table> ");
			if (!time4.contains("1900") && !time4.equals("")) {
				obj.put("time4", sdf1.format(sdfDB.parse((time4))));
			} else {
				obj.put("time4", "");
			}
			if (!time5.contains("1900") && !time5.equals("")) {
				obj.put("time5", sdf1.format(sdfDB.parse((time5))));
			} else {
				obj.put("time5", "");
			}

			jsonArray.put(obj);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
			DBConnection.releaseConnectionToDB(null, pstmt1, rs1);
		}
		return jsonArray;
	}

	public JSONArray getTemperatureReport(int systemId, int clientId, int offset, int userId, String startDate, String endDate, String regNo) {

		JSONArray JsonArray = new JSONArray();
		JSONObject JsonObject = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		MongoClient mongo = null;
		try {
			mongo = TemperatureConfiguration.getMongoConnection();
			DBCollection collection = mongo.getDB("temperature_module").getCollection("temperature_details");
			BasicDBObject andQuery = new BasicDBObject();
			List<BasicDBObject> obj = new ArrayList<BasicDBObject>();
			obj.add(new BasicDBObject("systemId", systemId));
			obj.add(new BasicDBObject("customerId", clientId));
			obj.add(new BasicDBObject("registrationNo", regNo));
			obj.add(new BasicDBObject("gmt", new BasicDBObject("$gte", sdfDB.parse(cf.getGMT(sdfDB.parse(startDate), offset))).append("$lt", sdfDB.parse(cf.getGMT(sdfDB.parse(endDate), offset)))));
			andQuery.put("$and", obj);
			int i = 0;
			DBCursor cursor = collection.find(andQuery).sort(new BasicDBObject("gmt", 1));
			while (cursor.hasNext()) {
				DBObject theObj = cursor.next();
				BasicDBList tempList = (BasicDBList) theObj.get("temperatureSensorDetails");
				i++;
				JsonObject = new JSONObject();
				JsonObject.put("slno", i);
				JsonObject.put("vehicleNo", theObj.get("registrationNo"));
				for (int j = 0; j < tempList.size(); j++) {
					BasicDBObject tempObj = (BasicDBObject) tempList.get(j);
					JsonObject.put(tempObj.getString("sensorName").replaceAll("\\s", ""), tempObj.getString("value"));
					JsonObject.put(tempObj.getString("name").replaceAll("\\s", ""), tempObj.getString("value"));
				}
				// JsonObject.put("reefer", theObj.get("reefer"));
				if (theObj.get("location") == null) {
					JsonObject.put("location", "");
				} else {
					JsonObject.put("location", theObj.get("location"));
				}

				JsonObject.put("dateTime", sdf1.format(theObj.get("gpsDatetime")));
				JsonObject.put("gmt", timef.format(theObj.get("gpsDatetime")));
				if (theObj.get("meanTemp") != null) {
					JsonObject.put("finalTemp", theObj.get("meanTemp"));
				} else {
					JsonObject.put("finalTemp", "");
				}
				JsonArray.put(JsonObject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
			mongo.close();
		}
		return JsonArray;
	}

	public JSONArray getTemperatureReportBasedOnTimeRange(int systemId, int clientId, int offset, int userId, String startDate, String endDate, String regNo, String TimeRange) {

		JSONArray JsonArray = new JSONArray();
		JSONObject JsonObject = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		MongoClient mongo = null;

		try {
			Calendar currentTime = null;
			Calendar incrementedtime = null;
			mongo = TemperatureConfiguration.getMongoConnection();
			DBCollection collection = mongo.getDB("temperature_module").getCollection("temperature_details");
			BasicDBObject andQuery = new BasicDBObject();
			List<BasicDBObject> obj = new ArrayList<BasicDBObject>();
			obj.add(new BasicDBObject("systemId", systemId));
			obj.add(new BasicDBObject("customerId", clientId));
			obj.add(new BasicDBObject("registrationNo", regNo));
			obj.add(new BasicDBObject("gmt", new BasicDBObject("$gte", sdfDB.parse(cf.getGMT(sdfDB.parse(startDate), offset))).append("$lt", sdfDB.parse(cf.getGMT(sdfDB.parse(endDate), offset)))));
			andQuery.put("$and", obj);
			int i = 0;
			int count = 0;
			String prevRecord = startDate;
			Date date = sdfDB.parse(startDate);
			currentTime = Calendar.getInstance();
			incrementedtime = Calendar.getInstance();
			currentTime.setTime(date);
			String SensorName;
			double refer = 0, referTemp = 0;
			double door = 0, doorTemp = 0;
			double middle = 0, middleTemp = 0;
			double Tcontainer = 0, containerTemp = 0;
			incrementedtime.setTime(date);
			incrementedtime.add(Calendar.MINUTE, Integer.parseInt(TimeRange));
			DBCursor cursor = collection.find(andQuery).sort(new BasicDBObject("gmt", 1));
			while (cursor.hasNext()) {
				DBObject theObj = cursor.next();
				JsonObject.put("vehicleNo", theObj.get("registrationNo"));
				JsonObject = new JSONObject();
				BasicDBList tempList = (BasicDBList) theObj.get("temperatureSensorDetails");
				for (int j = 0; j < tempList.size(); j++) {
					BasicDBObject tempObj = (BasicDBObject) tempList.get(j);
					SensorName = tempObj.getString("sensorName").replaceAll("\\s", "");
					JsonObject.put(tempObj.getString("sensorName").replaceAll("\\s", ""), tempObj.getString("value"));
					JsonObject.put(tempObj.getString("name").replaceAll("\\s", ""), tempObj.getString("value"));
					sName sensName = sName.valueOf(SensorName);
					switch (sensName) {
					case ONEWIRE3:
						if (!tempObj.getString("value").equalsIgnoreCase("NA")) {
							referTemp = Double.parseDouble(tempObj.getString("value"));
							break;
						}
					case ONEWIRE1:
						if (!tempObj.getString("value").equalsIgnoreCase("NA")) {
							middleTemp = Double.parseDouble(tempObj.getString("value"));
							break;
						}
					case ONEWIRE2:
						if (!tempObj.getString("value").equalsIgnoreCase("NA")) {
							doorTemp = Double.parseDouble(tempObj.getString("value"));
							break;
						}

					default:
						break;
					}

				}
				containerTemp = Double.parseDouble(String.valueOf(theObj.get("meanTemp")));
				if (isDateAfterDate((Date) theObj.get("gpsDatetime"), incrementedtime.getTime())) {

					if (!String.valueOf(theObj.get("meanTemp")).equalsIgnoreCase("NA")) {
						Tcontainer = Tcontainer + Double.parseDouble(String.valueOf(theObj.get("meanTemp")));
					}

					for (int j = 0; j < tempList.size(); j++) {
						BasicDBObject tempObj = (BasicDBObject) tempList.get(j);
						SensorName = tempObj.getString("sensorName").replaceAll("\\s", "");

						JsonObject.put(tempObj.getString("sensorName").replaceAll("\\s", ""), tempObj.getString("value"));
						JsonObject.put(tempObj.getString("name").replaceAll("\\s", ""), tempObj.getString("value"));
						switch (j) {
						case 0:
							if (!tempObj.getString("value").equalsIgnoreCase("NA")) {
								refer = refer + Double.parseDouble(tempObj.getString("value"));
								break;
							}
						case 1:
							if (!tempObj.getString("value").equalsIgnoreCase("NA")) {
								middle = middle + Double.parseDouble(tempObj.getString("value"));
								break;
							}
						case 2:
							if (!tempObj.getString("value").equalsIgnoreCase("NA")) {
								door = door + Double.parseDouble(tempObj.getString("value"));
								break;
							}
						}

					}
					count += 1;
				} else {
					i++;
					JsonObject.put("slno", i);
					for (int j = 0; j < tempList.size(); j++) {
						BasicDBObject tempObj = (BasicDBObject) tempList.get(j);
						switch (j) {
						case 0:
							JsonObject.put(tempObj.getString("sensorName").replaceAll("\\s", ""), df.format(refer / count));
							JsonObject.put(tempObj.getString("name").replaceAll("\\s", ""), df.format(refer / count));
							break;
						case 1:
							JsonObject.put(tempObj.getString("sensorName").replaceAll("\\s", ""), df.format(middle / count));
							JsonObject.put(tempObj.getString("name").replaceAll("\\s", ""), df.format(middle / count));
							break;
						case 2:
							JsonObject.put(tempObj.getString("sensorName").replaceAll("\\s", ""), df.format(door / count));
							JsonObject.put(tempObj.getString("name").replaceAll("\\s", ""), df.format(door / count));
							break;
						}
					}
					// JsonObject.put("reefer", theObj.get("reefer"));
					if (theObj.get("location") == null) {
						JsonObject.put("location", "");
					} else {
						JsonObject.put("location", theObj.get("location"));
					}
					int mintsDiff = cf.getTimeDiffrence(sdf1.parse(prevRecord), sdf1.parse(sdf1.format(theObj.get("gpsDatetime"))));
					// System.out.println(mintsDiff
					// +" :: "+sdf1.parse(prevRecord)+" : : "+sdf1.parse(sdf1.format(theObj.get("gpsDatetime"))));
					// System.out.println(mintsDiff+"----------------curr------------- :: "+sdf1.parse(sdf1.format(theObj.get("gpsDatetime"))));
					if (mintsDiff > Integer.parseInt(TimeRange) + 5) {
						// System.out.println("prevRecord :: "+prevRecord+" gpsDatetime:: "+sdf1.format(theObj.get("gpsDatetime")));
						Date date1 = sdf1.parse(sdf1.format(theObj.get("gpsDatetime")));
						currentTime.setTime(date1);
						incrementedtime.setTime(date1);
						// System.out.println("currentTime :: "+currentTime.getTime()
						// +" increment :: "+ incrementedtime.getTime());
					}
					JsonObject.put("finalTemp", df.format(Tcontainer / count));
					JsonObject.put("dateTime", sdf1.format(incrementedtime.getTime()));
					JsonObject.put("gmt", timef.format(theObj.get("gpsDatetime")));
					currentTime.add(Calendar.MINUTE, Integer.parseInt(TimeRange));
					incrementedtime.add(Calendar.MINUTE, Integer.parseInt(TimeRange));
					prevRecord = sdf1.format(theObj.get("gpsDatetime"));
					// System.out.println("prevRecord :: "+prevRecord);
					JsonArray.put(JsonObject);
					refer = referTemp;
					door = doorTemp;
					middle = middleTemp;
					Tcontainer = containerTemp;
					count = 1;

				}

			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
			mongo.close();
		}
		return JsonArray;
	}

	public JSONArray getTemperatureReport1(int systemId, int clientId, int offset, int userId, String startDate, String endDate, String regNo) {

		JSONArray JsonArray = new JSONArray();
		JSONObject JsonObject = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		List<JSONObject> expList = null;
		List<TemperatureBean> beanList = null;
		TemperatureBean ieBean = null;
		try {
			LinkedHashSet<Date> tempSet = new LinkedHashSet<Date>();
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(GeneralVerticalStatements.GET_TEMPERATURE_REPORT);
			pstmt.setInt(1, offset);
			pstmt.setString(2, regNo);
			pstmt.setInt(3, offset);
			pstmt.setString(4, startDate);
			pstmt.setInt(5, offset);
			pstmt.setString(6, endDate);
			pstmt.setInt(7, offset);
			pstmt.setString(8, regNo);
			pstmt.setInt(9, offset);
			pstmt.setString(10, startDate);
			pstmt.setInt(11, offset);
			pstmt.setString(12, endDate);
			rs = pstmt.executeQuery();
			expList = new ArrayList<JSONObject>();
			String reffer = "";
			int count = 0;
			while (rs.next()) {
				count++;
				JsonObject = new JSONObject();
				JsonObject.put("datetime", rs.getTimestamp("GMT"));
				JsonObject.put("ioValue", rs.getString("IO_VALUE"));
				JsonObject.put("location", rs.getString("LOCATION"));
				JsonObject.put("category", rs.getString("IO_CATEGORY"));

				expList.add(JsonObject);
				tempSet.add(rs.getTimestamp("GMT"));
			}
			beanList = new ArrayList<TemperatureBean>();
			String t1 = "NA";
			String t2 = "NA";
			String t3 = "NA";
			for (Date date : tempSet) {
				ieBean = new TemperatureBean();
				for (JSONObject obj : expList) {
					if (obj.get("datetime").equals(date)) {
						ieBean.setGmt(obj.getString("datetime"));
						ieBean.setLocation(obj.getString("location"));
						if (obj.getString("category").equals("TEMPERATURE1")) {
							ieBean.setT1(obj.getString("ioValue"));
							t1 = obj.getString("ioValue");
						} else {
							ieBean.setT1(t1);
						}

						if (obj.getString("category").equals("TEMPERATURE2")) {
							ieBean.setT2(obj.getString("ioValue"));
							t2 = obj.getString("ioValue");
						} else {
							ieBean.setT2(t2);
						}

						if (obj.getString("category").equals("TEMPERATURE3")) {
							ieBean.setT3(obj.getString("ioValue"));
							t3 = obj.getString("ioValue");
						} else {
							ieBean.setT3(t3);
						}

						if (obj.getString("category").equals("REEFER")) {
							if (obj.getString("ioValue").equals("0")) {
								reffer = "OFF";
							} else if (obj.getString("ioValue").equals("1")) {
								reffer = "ON";
							} else {
								reffer = obj.getString("ioValue");
							}
							ieBean.setReefer(reffer);
						}
					}
				}
				beanList.add(ieBean);
			}
			int i = 0;
			Collections.sort(beanList);
			for (TemperatureBean bean : beanList) {
				i++;
				JsonObject = new JSONObject();
				JsonObject.put("slno", i);
				JsonObject.put("datetime", sdf1.format(sdfDB.parseObject((bean.getGmt()))));

				JsonObject.put("t1", bean.getT1());
				JsonObject.put("t2", bean.getT2());
				JsonObject.put("t3", bean.getT3());
				JsonObject.put("reefer", bean.getReefer());
				JsonObject.put("location", bean.getLocation());
				JsonObject.put("gmt", timef.format(sdfDB.parseObject((bean.getGmt()))));
				JsonArray.put(JsonObject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return JsonArray;
	}

	public JSONArray getVehicles(int systemId, int clientId, int offset, int userId) {

		JSONArray JsonArray = new JSONArray();
		JSONObject JsonObject = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			JsonArray = new JSONArray();
			JsonObject = new JSONObject();
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(GeneralVerticalStatements.GET_VEHICLES_FOR_TEMP_REPORT);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, clientId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				JsonObject = new JSONObject();
				JsonObject.put("vehicleNo", rs.getString("REGISTRATION_NO"));
				JsonArray.put(JsonObject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return JsonArray;
	}

	public JSONArray getTrip(int systemId, int clientId, int offset, int userId, String custId) {

		JSONArray JsonArray = new JSONArray();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			JsonArray = new JSONArray();
			con = DBConnection.getConnectionToDB("AMS");
			if (!custId.equals("0")) {
				pstmt = con.prepareStatement(GeneralVerticalStatements.GET_TRIP_NAMES.replace("##", " and td.TRIP_CUSTOMER_ID=" + custId));
			} else if (custId.equals("0")) {
				pstmt = con.prepareStatement(GeneralVerticalStatements.GET_TRIP_NAMES.replace("##", ""));
			}

			pstmt.setInt(1, systemId);
			pstmt.setInt(2, clientId);
			rs = pstmt.executeQuery();
			JSONObject obj1 = new JSONObject();
			while (rs.next()) {
				obj1 = new JSONObject();
				obj1.put("tripId", rs.getString("TRIP_ID"));
				obj1.put("tripName", rs.getString("TRIP_NAME_1"));
				JsonArray.put(obj1);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return JsonArray;
	}

	public JSONArray getTripData(int offset, int tripId) {
		JSONArray jsonArray = new JSONArray();
		JSONObject obj = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		PreparedStatement pstmt1 = null;
		ResultSet rs = null;
		ResultSet rs1 = null;
		String vehicleNumber = "";
		try {
			con = DBConnection.getConnectionToDB("AMS");
			String stmt = GeneralVerticalStatements.GET_TRIP_DATA;
			pstmt = con.prepareStatement(stmt);
			pstmt.setInt(1, offset);
			pstmt.setInt(2, offset);
			pstmt.setInt(3, offset);
			pstmt.setInt(4, offset);
			pstmt.setInt(5, offset);
			pstmt.setInt(6, tripId);
			rs = pstmt.executeQuery();
			obj = new JSONObject();
			if (rs.next()) {

				String STD = "";
				String endDate = "";
				if (!rs.getString("STD").contains("1900")) {
					STD = sdf.format(sdfDB.parse(rs.getString("STD")));
				}
				if (!rs.getString("END_DATE").contains("1900")) {
					endDate = sdf.format(sdfDB.parse(rs.getString("END_DATE")));
				}
				obj.put("tripName", rs.getString("TRIP_NAME"));
				obj.put("assetNo", rs.getString("ASSET_NUMBER"));
				obj.put("startDate", STD);
				obj.put("endDate", endDate);
				obj.put("vehicleType", rs.getString("MAKE"));
				obj.put("status", rs.getString("STATUS"));
				int datediff = rs.getInt("days");
				int timerange = 0;
				if (datediff >= 1 && datediff < 4) {
					timerange = 15;
				} else if (datediff >= 4 && datediff < 7) {
					timerange = 30;
				} else if (datediff >= 7 && datediff < 10) {
					timerange = 45;
				} else if (datediff >= 10 && datediff < 14) {
					timerange = 60;
				} else if (datediff >= 14 && datediff < 20) {
					timerange = 120;
				} else if (datediff >= 20) {
					timerange = 300;
				}
				obj.put("timerange", timerange);
				vehicleNumber = rs.getString("ASSET_NUMBER");
			}
			// ///////////////////////////////////////////////////////////////////////////////////////////////////////////////
			pstmt1 = con.prepareStatement(CreateTripStatement.GET_TRIP_VEHICLE_TEMPERATURE_DETAILS);
			pstmt1.setInt(1, tripId);
			pstmt1.setString(2, vehicleNumber);
			rs1 = pstmt1.executeQuery();

			String tblData = "";
			String tblDataExport = "";
			double minGreenRange = 0;
			double maxGreenRange = 0;
			boolean data = false;
			while (rs1.next()) {
				data = true;
				double negativeMaxTemp = rs1.getDouble("MAX_NEGATIVE_TEMP");
				double negativeMinTemp = rs1.getDouble("MIN_NEGATIVE_TEMP");
				double positiveMaxTemp = rs1.getDouble("MAX_POSITIVE_TEMP");
				double positiveMinTemp = rs1.getDouble("MIN_POSITIVE_TEMP");
				String displayName = rs1.getString("DISPLAY_NAME");
				double positiveMaxTemp2 = positiveMaxTemp;// +1;
				double negativeMinTemp2 = negativeMinTemp;// -1;

				minGreenRange = rs1.getDouble("MIN_POSITIVE_TEMP");
				maxGreenRange = rs1.getDouble("MAX_NEGATIVE_TEMP");
				tblData = tblData + "<tr><td style = 'padding-left: 50px;'><b> " + displayName + "</b></td><td><b style='color:green;'>&nbsp;GREEN : &nbsp;</b></td><td>" + negativeMaxTemp + " to "
						+ positiveMinTemp + "</td><td><b style='color:#f7b704 ;'>&nbsp; &nbsp;&nbsp;YELLOW : &nbsp;</b></td><td>" + negativeMinTemp + " to " + negativeMaxTemp + "; " + positiveMinTemp
						+ " to " + positiveMaxTemp + "</td><td><b style='color:red;'> &nbsp;&nbsp;&nbsp;RED :&nbsp;</b></td><td>-70 to " + negativeMinTemp2 + "; " + positiveMaxTemp2
						+ " to 70</td></tr>";
				tblDataExport = tblDataExport + "            " + displayName + "     GREEN :  " + negativeMaxTemp + " to " + positiveMinTemp + "   YELLOW :  " + negativeMinTemp + " to "
						+ negativeMaxTemp + "; " + positiveMinTemp + " to " + positiveMaxTemp + "   RED : -70 to " + negativeMinTemp2 + "; " + positiveMaxTemp2 + " to 70 \n";
			}
			if (data) {
				obj.put("tblData", "<table><tr><td style='font-size: 15px;'><b>Temperature Range :  &nbsp; &nbsp;   </b></td></tr>" + tblData + "</table> ");
				obj.put("tblDataExport", "Temperature Range : \n" + tblDataExport);
			} else {
				obj.put("tblData", "<table><tr><td style='font-size: 15px;'><b>Temperature Range :  NA   </b></td></tr></table> ");
				obj.put("tblDataExport", "Temperature Range : NA ");
			}

			obj.put("minGreenRange", minGreenRange);
			obj.put("maxGreenRange", maxGreenRange);
			jsonArray.put(obj);

			// ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
			DBConnection.releaseConnectionToDB(null, pstmt1, rs1);
		}
		return jsonArray;
	}

	public JSONArray getAllTempValues(int systemId, int clientId, int offset, int userId, String startDate, String endDate, String regNo) {

		JSONArray JsonArray = new JSONArray();
		JSONObject JsonObject = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String t1 = "";
		String t2 = "";
		String t3 = "";
		try {
			JsonArray = new JSONArray();
			JsonObject = new JSONObject();
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(GeneralVerticalStatements.GET_TEMPERATURE_DATA);
			pstmt.setInt(1, offset);
			pstmt.setString(2, regNo);
			pstmt.setInt(3, offset);
			pstmt.setString(4, startDate);
			pstmt.setInt(5, offset);
			pstmt.setString(6, endDate);

			pstmt.setInt(7, offset);
			pstmt.setString(8, regNo);
			pstmt.setInt(9, offset);
			pstmt.setString(10, startDate);
			pstmt.setInt(11, offset);
			pstmt.setString(12, endDate);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				JsonObject = new JSONObject();
				JsonObject.put("DATE", timef.format(rs.getTimestamp("GMT")));
				if (rs.getString("IO_CATEGORY").equals("TEMPERATURE1")) {
					t1 = rs.getString("IO_VALUE");
				}
				if (rs.getString("IO_CATEGORY").equals("TEMPERATURE2")) {
					t2 = rs.getString("IO_VALUE");
				}
				if (rs.getString("IO_CATEGORY").equals("TEMPERATURE3")) {
					t3 = rs.getString("IO_VALUE");
				}
				// if(!(t1.equals("") || t2.equals("") || t3.equals(""))){
				JsonObject.put("T1", t1);
				JsonObject.put("T2", t2);
				JsonObject.put("T3", t3);
				JsonArray.put(JsonObject);
				// }
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return JsonArray;
	}

	public int getAssociationDetails(String vehicleNo, String tripNo) {
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Connection con = null;
		int count = 0;
		try {
			con = DBConnection.getDashboardConnection("AMS");
			pstmt = con.prepareStatement(GeneralVerticalStatements.GET_ASSOCIATION_DATA_FOR_PRODUCT_LINE);
			// pstmt.setString(1, "Dry");
			pstmt.setString(1, vehicleNo);
			pstmt.setString(2, tripNo);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				count = rs.getInt("COUNT");
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return count;
	}

	public ArrayList<Object> getDriverScoreParameterDetails(int systemId, int customerId, int offset, String units, int modelId) {
		JSONArray JsonArray = new JSONArray();
		JSONObject JsonObject = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		ArrayList<Object> finlist = new ArrayList<Object>();

		try {
			int count = 0;
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(GeneralVerticalStatements.GET_DRIVER_SCORE_PARAMETER_SETTING_DATA);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, customerId);
			pstmt.setInt(3, modelId);
			rs = pstmt.executeQuery();
			String type = "";
			float minValue = 0;
			float maxValue = 0;
			float distFactor = 0.62137f;
			while (rs.next()) {
				JsonObject = new JSONObject();
				count++;

				JsonObject.put("slnoIndex", count);

				JsonObject.put("uIdIndex", rs.getInt("UID"));

				JsonObject.put("vehicleModelIndex", rs.getString("MODEL_NAME"));

				JsonObject.put("parameterNameIndex", rs.getString("PARAMETER"));

				maxValue = rs.getFloat("MAX_VALUE");
				minValue = rs.getFloat("MIN_VALUE");
				if (rs.getString("PARAMETER").equalsIgnoreCase("SPEED")) {
					if (units.equalsIgnoreCase("MILES")) {
						maxValue = maxValue * distFactor;
						minValue = minValue * distFactor;
					}
				}
				JsonObject.put("maxValueIndex", df.format(maxValue));

				JsonObject.put("minValueIndex", df.format(minValue));

				type = rs.getString("TYPE");
				if (type.equalsIgnoreCase("KM")) {
					if (units.equalsIgnoreCase("MILES")) {
						type = "MILES";
					}
				}
				JsonObject.put("typeOfValueIndex", type);

				JsonObject.put("modifyIndex", "<button data-toggle='modal' data-target='#modify' class='btn btn-warning'>Modify</button> ");

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

	public JSONArray getVehicleModelDetails(int systemId, int clientId) {

		JSONArray jsonArray = new JSONArray();
		JSONObject obj1 = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			con = DBConnection.getConnectionToDB("AMS");
			String query = GeneralVerticalStatements.GET_VEHICLE_MODEL_DETAILS;
			pstmt = con.prepareStatement(query);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, clientId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				obj1 = new JSONObject();
				obj1.put("modelTypeId", rs.getString("ModelTypeId"));
				obj1.put("modelName", rs.getString("ModelName"));
				jsonArray.put(obj1);
			}
		} catch (Exception e) {
			System.out.println("Error in getting Vehicle Model Details:" + e.toString());
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jsonArray;
	}

	public JSONArray getParameterNames(int vehicleModelId, int systemId, int clientId) {

		JSONArray jsonArray = new JSONArray();
		JSONObject obj1 = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			con = DBConnection.getConnectionToDB("AMS");
			String query = GeneralVerticalStatements.GET_PARAMETERS_FOR_VEHICLES;
			pstmt = con.prepareStatement(query);
			pstmt.setInt(1, vehicleModelId);
			pstmt.setInt(2, systemId);
			pstmt.setInt(3, clientId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				obj1 = new JSONObject();
				// obj1.put("parameterId", rs.getString("PARAM_ID"));
				obj1.put("parameterName", rs.getString("PARAM_NAME"));
				jsonArray.put(obj1);
			}
		} catch (Exception e) {
			System.out.println("Error in getting Vehicle Parameter Names Details:" + e.toString());
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jsonArray;
	}

	public String saveDriverScoreParameters(int modelId, String paramName, float minValueId, float maxValueId, int systemId, int clientId, String units) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String message = "";
		String type = "";
		float distFactor = 0.62137f;
		if (paramName.equalsIgnoreCase("SPEED")) {
			type = "KM";
			if (units.equalsIgnoreCase("MILES")) {
				minValueId = minValueId / distFactor;
				maxValueId = maxValueId / distFactor;
			}
		} else if (paramName.equalsIgnoreCase("ENGINE RPM")) {
			type = "RPM";
		}

		int result = 0;
		try {

			con = DBConnection.getConnectionToDB("AMS");
			String query = GeneralVerticalStatements.SAVE_DRIVER_SCORE_PARAMETERS;
			pstmt = con.prepareStatement(query);
			pstmt.setString(1, paramName);
			pstmt.setFloat(2, minValueId);
			pstmt.setFloat(3, maxValueId);
			pstmt.setInt(4, modelId);
			pstmt.setString(5, type);
			pstmt.setInt(6, systemId);
			pstmt.setInt(7, clientId);
			result = pstmt.executeUpdate();
			if (result == 1) {
				message = "Saved Successfully";
			}
		} catch (Exception e) {
			System.out.println("Error in saving Vehicle Health Parameters:" + e.toString());
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return message;
	}

	public String modifyDriverScoreParameters(int uid, float minValueId, float maxValueId, int systemId, int clientId, String paramName, String units) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String message = "";
		int result = 0;
		float distFactor = 0.62137f;
		try {
			if (paramName.equalsIgnoreCase("SPEED")) {
				if (units.equalsIgnoreCase("MILES")) {
					minValueId = minValueId / distFactor;
					maxValueId = maxValueId / distFactor;
				}
			}
			con = DBConnection.getConnectionToDB("AMS");
			String query = GeneralVerticalStatements.MODIFY_DRIVER_SCORE_PARAMETERS;
			pstmt = con.prepareStatement(query);
			pstmt.setFloat(1, minValueId);
			pstmt.setFloat(2, maxValueId);
			pstmt.setInt(3, uid);
			pstmt.setInt(4, systemId);
			pstmt.setInt(5, clientId);
			result = pstmt.executeUpdate();
			if (result == 1) {
				message = "Updated Successfully";
			}
		} catch (Exception e) {
			System.out.println("Error in saving Vehicle Health Parameters:" + e.toString());
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return message;
	}

	public JSONArray getDriverPerformanceData(int systemId, int clientId, int offset, String startDate, String endDate, 
			int driverId, String hubList, String zone) {
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonobject = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int count = 0;

		try {
			jsonArray = new JSONArray();
			con = DBConnection.getConnectionToDB("AMS");
			if(driverId != 0){
				pstmt = con.prepareStatement(GeneralVerticalStatements.GET_DRIVER_PER_DETAILS.replace("#", " and DRIVER_ID="+driverId));
			}else{
				pstmt = con.prepareStatement(GeneralVerticalStatements.GET_DRIVER_PER_DETAILS.replace("#", " and DRIVER_ID in (select Driver_id" +
						" from AMS.dbo.Driver_Master d where Client_id="+clientId+""+getHubQueryAppender(hubList, clientId, zone)+")"));
			}
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, clientId);
			pstmt.setInt(3, offset);
			pstmt.setString(4, startDate);
			pstmt.setInt(5, offset);
			pstmt.setString(6, endDate);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				count++;
				jsonobject = new JSONObject();
				jsonobject.put("slNoIndex", count);
				jsonobject.put("empIdIndex", rs.getString("EMP_ID"));
				jsonobject.put("nameIndex", rs.getString("NAME"));
				jsonobject.put("totalScoreIndex", df1.format((rs.getDouble("TOTAL_SCORE"))));
				jsonobject.put("NoofTripsIndex", rs.getDouble("NO_OF_TRIPS"));
				jsonobject.put("totalKmsIndex", rs.getDouble("TOTAL_DISTANCE"));
				jsonobject.put("totalTimeIndex", cf.convertMinutesToHHMMFormat((rs.getInt("TOTAL_DURATION"))));
				jsonobject.put("overallPerIndex", 0);
				jsonobject.put("avgMilageIndex", rs.getString("AVG_MILAGE"));// df1.format(rs.getDouble("AVG_MILAGE")));
				jsonobject.put("avgSpeedIndex", df1.format(rs.getDouble("AVG_SPEED")));
				jsonobject.put("harshAccIndex", df1.format(rs.getDouble("HA_SCORE")));
				jsonobject.put("harshBrakingIndex", df1.format(rs.getDouble("HB_SCORE")));
				jsonobject.put("harshCorneringIndex", df1.format(rs.getDouble("HC_SCORE")));
				jsonobject.put("overspeedingIndex", df1.format(rs.getDouble("OVER_SPEED_SCORE")));
				jsonobject.put("freewheelingIndex", rs.getString("FREE_WHEEL_SCORE")); // don't do df1.format
				jsonobject.put("unscheduledStoppageIndex", df1.format(rs.getDouble("UNSCHDL_STOPPAGE_SCORE")));
				jsonobject.put("excessiveIdlingIndex", df1.format(rs.getDouble("IDLE_SCORE")));
				jsonobject.put("greenBandSpeedIndex", df1.format(rs.getDouble("GREEN_BAND_SPEED_SCORE")));
				jsonobject.put("erraticSpeedingIndex", 0);
				jsonobject.put("greenBandRpmIndex", rs.getString("GREEN_BAND_RPM_SCORE")); // don't do
				jsonobject.put("lowRPMIndex", rs.getString("LOW_RPM_SCORE")); // don't
				jsonobject.put("highRPMIndex", rs.getString("HIGH_RPM_SCORE")); // don't
				jsonobject.put("overRevvingIndex", df1.format(rs.getDouble("OVER_REVV_SCORE")));
				jsonobject.put("driverIdIndex", rs.getInt("DRIVER_ID"));
				jsonobject.put("avgOBDMileageIndex", rs.getString("AVG_OBD_MILAGE"));// df1.format(rs.getDouble("AVG_OBD_MILAGE")));
				jsonobject.put("otpScoreIndex", df1.format((rs.getDouble("ON_TIME_PERFORMANCE"))));
				jsonArray.put(jsonobject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jsonArray;
	}

	public JSONArray getTopOrBottomdDriverDetails(int systemId, int clientId, int offset, String startDate, 
			String endDate, String orderBy, int driverId, String hubList, String zone) {
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonobject = null;
		
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int count = 0;
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(GeneralVerticalStatements.GET_TOP_DRIVERS.replace("#", " and DRIVER_ID in (select Driver_id " +
					" from AMS.dbo.Driver_Master d where Client_id="+clientId+""+getHubQueryAppender(hubList, clientId, zone)+")")+" "+orderBy);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, clientId);
			pstmt.setInt(3, offset);
			pstmt.setString(4, startDate);
			pstmt.setInt(5, offset);
			pstmt.setString(6, endDate);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				count++;
				jsonobject = new JSONObject();
				jsonobject.put("rank", count);
				jsonobject.put("driverName", rs.getString("NAME"));
				jsonobject.put("periodScore", df1.format(rs.getDouble("PERIOD_SCORE")));
				jsonobject.put("overallScore", df1.format(rs.getDouble("OVERALL_SCORE")));
				jsonobject.put("overallRank", df1.format(rs.getDouble("OVERALL_RANK")));
				jsonArray.put(jsonobject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jsonArray;
	}

	public JSONArray getDriverPerformanceDataForChart(int systemId, int CustomerId, int offset, String startDate, 
			String endDate, int driverId, String hubList, String zone) {
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Connection con = null;
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject = new JSONObject();

		int lowCount = 0;
		int mediumCount = 0;
		int highCount = 0;
		try {
			con = DBConnection.getConnectionToDB("AMS");
			if(driverId == 0){
				pstmt = con.prepareStatement(GeneralVerticalStatements.GET_DATA_FOR_CHART.replace("#", " and DRIVER_ID in (select Driver_id " +
						" from AMS.dbo.Driver_Master d where Client_id="+CustomerId+""+getHubQueryAppender(hubList, CustomerId, zone)+")"));
			}else{
				pstmt = con.prepareStatement(GeneralVerticalStatements.GET_DATA_FOR_CHART.replace("#", " and DRIVER_ID="+driverId));
			}
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, CustomerId);
			pstmt.setInt(3, offset);
			pstmt.setString(4, startDate);
			pstmt.setInt(5, offset);
			pstmt.setString(6, endDate);
			pstmt.setInt(7, systemId);
			pstmt.setInt(8, CustomerId);
			pstmt.setInt(9, offset);
			pstmt.setString(10, startDate);
			pstmt.setInt(11, offset);
			pstmt.setString(12, endDate);
			pstmt.setInt(13, systemId);
			pstmt.setInt(14, CustomerId);
			pstmt.setInt(15, offset);
			pstmt.setString(16, startDate);
			pstmt.setInt(17, offset);
			pstmt.setString(18, endDate);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				if (rs.getString("STATUS").equals("LOW")) {
					lowCount = rs.getInt("COUNT");
				}
				if (rs.getString("STATUS").equals("MEDIUM")) {
					mediumCount = rs.getInt("COUNT");
				}
				if (rs.getString("STATUS").equals("HIGH")) {
					highCount = rs.getInt("COUNT");
				}
			}
			jsonObject = new JSONObject();
			jsonObject.put("lowCount", lowCount);
			jsonObject.put("mediumCount", mediumCount);
			jsonObject.put("highCount", highCount);
			jsonArray.put(jsonObject);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jsonArray;
	}

	public JSONArray getDriverSummaryData(int systemId, int clientId, int offset, String startDate, 
			String endDate, int driverId, String hubList, String zone) {
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonobject = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int count = 0;
		double excessIdle = 0;
		double greenBandSPeed = 0;
		double overRevv = 0;
		double greenBandRPM = 0;
		double lowRPM = 0;
		double highRPM = 0;
		double economyScore = 0;
		double freeWheelScore = 0;
		double safetyScore = 0;
		try {
			jsonArray = new JSONArray();
			con = DBConnection.getConnectionToDB("AMS");
			if(driverId != 0){
				pstmt = con.prepareStatement(GeneralVerticalStatements.GET_DRIVER_SUMMARY.replace("#", " and DRIVER_ID="+driverId));
			}else{
				pstmt = con.prepareStatement(GeneralVerticalStatements.GET_DRIVER_SUMMARY.replace("#", " and DRIVER_ID in (select Driver_id" +
						" from AMS.dbo.Driver_Master d where Client_id="+clientId+""+getHubQueryAppender(hubList, clientId, zone)+")"));
			}
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, clientId);
			pstmt.setInt(3, offset);
			pstmt.setString(4, startDate);
			pstmt.setInt(5, offset);
			pstmt.setString(6, endDate);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				count++;
				jsonobject = new JSONObject();
				jsonobject.put("slNoIndex", count);
				jsonobject.put("empIdIndex", rs.getString("EMP_ID"));
				jsonobject.put("nameIndex", rs.getString("NAME"));
				if (!rs.getString("FREE_WHEEL_SCORE").equals("NA")) {
					freeWheelScore = Double.parseDouble(rs.getString("FREE_WHEEL_SCORE"));
				}
				safetyScore = (rs.getDouble("SAFETY_SCORE") + freeWheelScore) / 5;
				jsonobject.put("safetyScoreIndex", df1.format(safetyScore)); // HA,HB,HC,OverSpeed,Free
				// wheeling
				jsonobject.put("performanceScoreIndex", df1.format(rs.getDouble("PERFORMANCE_SCORE"))); // UnscheduledStop
				excessIdle = rs.getDouble("IDLE_SCORE");
				overRevv = rs.getDouble("OVER_REVV_SCORE");
				greenBandSPeed = rs.getDouble("GREEN_BAND_SPEED_SCORE");
				if (!rs.getString("GREEN_BAND_RPM_SCORE").equals("NA")) {
					greenBandRPM = Double.parseDouble(rs.getString("GREEN_BAND_RPM_SCORE"));
				}
				if (!rs.getString("LOW_RPM_SCORE").equals("NA")) {
					lowRPM = Double.parseDouble(rs.getString("LOW_RPM_SCORE"));
				}
				if (!rs.getString("HIGH_RPM_SCORE").equals("NA")) {
					highRPM = Double.parseDouble(rs.getString("HIGH_RPM_SCORE"));
				}
				economyScore = (excessIdle + overRevv + greenBandSPeed + greenBandRPM + lowRPM + highRPM) / 6;
				jsonobject.put("economyScoreIndex", df1.format(economyScore));
				jsonobject.put("totalScoreIndex", df1.format(rs.getDouble("TOTAL_SCORE")));
				jsonobject.put("driverId", rs.getString("DRIVER_ID"));
				jsonobject.put("mileageIndex", df1.format(rs.getDouble("AVG_MILAGE") / rs.getInt("NO_OF_TRIPS")));

				jsonArray.put(jsonobject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jsonArray;
	}

	public JSONArray getOverallScore(int systemId, int clientId, int offset,int driverId, String hubIdList, String zone) {
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Connection con = null;
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject = new JSONObject();
		con = DBConnection.getConnectionToDB("AMS");
		double presentScore = 0;
		double pastScore = 0;
		double overallScore = 0;
		try {
			String statement = GeneralVerticalStatements.GET_OVERALL_SCORE;
			if(driverId == 0){
				statement = statement.replace("#", " and DRIVER_ID in (select Driver_id from AMS.dbo.Driver_Master d " +
						" where Client_id="+clientId+""+getHubQueryAppender(hubIdList, clientId, zone)+")");
			}else{
				statement = statement.replace("#", " and DRIVER_ID="+driverId);
			}
			pstmt = con.prepareStatement(statement);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, clientId);
			pstmt.setInt(3, systemId);
			pstmt.setInt(4, clientId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				jsonObject = new JSONObject();
				if (rs.getString("STATUS").equals("PRESENT_MONTH")) {
					presentScore = rs.getDouble("TOTAL_SCORE");
				}
//				if (rs.getString("STATUS").equals("LAST_MONTH")) {
//					pastScore = rs.getDouble("TOTAL_SCORE");
//				}
				if (rs.getString("STATUS").equals("OVERALL")) {
					overallScore = rs.getDouble("TOTAL_SCORE");
				}
			}
			jsonObject.put("pastScore", df1.format(pastScore));
			jsonObject.put("presentScore", df1.format(presentScore));
//			percScore = ((presentScore - pastScore) * 100) / pastScore;
//			if (Math.floor(pastScore) == 0) {
//				percScore = 0;
//			}
			jsonObject.put("percScore", "0.0");
			jsonObject.put("overallScore", df1.format(overallScore));
			jsonArray.put(jsonObject);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jsonArray;
	}

	public JSONArray getPerformanceDetails(int systemId, int CustomerId, int offset, String startDate, String endDate, int driverId,
			String hubList, String zone) {
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Connection con = null;
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject = null;
		
		int hbscore = 0;
		int haScore = 0;
		int hcScore = 0;
		int overrevvScore = 0;
		int overSpeedScore = 0;
		int idleScore = 0;
		int unscdlScore = 0;
		int greenBandScore = 0;
		int greenbandrpmScore = 0;
		int lowrpmScore = 0;
		int highrpmScore = 0;
		try {
			con = DBConnection.getConnectionToDB("AMS");
			if(driverId != 0){
				pstmt = con.prepareStatement(GeneralVerticalStatements.GET_PERFORMANCE_DATA.replace("#", " and DRIVER_ID="+driverId));
			}else{
				pstmt = con.prepareStatement(GeneralVerticalStatements.GET_PERFORMANCE_DATA.replace("#", " and DRIVER_ID in (select Driver_id " +
						" from AMS.dbo.Driver_Master d where Client_id="+CustomerId+""+getHubQueryAppender(hubList, CustomerId, zone)+")"));
			}
			pstmt.setInt(1, CustomerId);
			pstmt.setInt(2, offset);
			pstmt.setString(3, startDate);
			pstmt.setInt(4, offset);
			pstmt.setString(5, endDate);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				hbscore = rs.getInt("HB_SCORE");
				haScore = rs.getInt("HA_SCORE");
				hcScore = rs.getInt("HC_SCORE");
				overrevvScore = rs.getInt("OVER_REVV_SCORE");
				overSpeedScore = rs.getInt("OVER_SPEED_SCORE");
				idleScore = rs.getInt("IDLE_SCORE");
				unscdlScore = rs.getInt("UNSCHDL_STOPPAGE_SCORE");
				greenBandScore = rs.getInt("GREEN_BAND_SPEED_SCORE");
				greenbandrpmScore = rs.getInt("GREEN_BAND_RPM_SCORE");
				lowrpmScore = rs.getInt("LOW_RPM_SCORE");
				highrpmScore = rs.getInt("HIGH_RPM_SCORE");
			}
			jsonObject = new JSONObject();
			if(hbscore == 0 && haScore == 0 && overrevvScore == 0 && overSpeedScore == 0 && idleScore == 0 && unscdlScore == 0
					&& greenBandScore == 0 && greenbandrpmScore == 0 && lowrpmScore == 0 && highrpmScore == 0){
				jsonObject.put("firstLow", "NA");
				jsonObject.put("secondLow", "NA");
				jsonObject.put("firstHigh", "NA");
				jsonObject.put("secondHigh", "NA");
			}else{
				Map<String, Integer> map = new HashMap<String, Integer>();
				map.put("Harsh-Acceleration", haScore);
				map.put("Hrash-Braking", hbscore);
				map.put("Harsh-Curving", hcScore);
				map.put("Over-Revving", overrevvScore);
				map.put("OverSpeed", overSpeedScore);
				map.put("Idle", idleScore);
				map.put("Unscheduled-Stoppage", unscdlScore);
				map.put("Green-Band-Speed", greenBandScore);
				map.put("Green-Band-RPM", greenbandrpmScore);
				map.put("Low-RPM", lowrpmScore);
				map.put("High-RPM", highrpmScore);

				Map<String, Integer> sortedMapDesc = sortByValue(map);
				List<Map.Entry<String, Integer>> list = new LinkedList<Map.Entry<String, Integer>>(sortedMapDesc.entrySet());
				jsonObject.put("firstLow", list.get(0));
				jsonObject.put("secondLow", list.get(1));
				jsonObject.put("firstHigh", list.get(list.size() - 1));
				jsonObject.put("secondHigh", list.get(list.size() - 2));
			}
			jsonArray.put(jsonObject);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jsonArray;
	}

	public JSONArray getColumnChartDetails(int systemId, int clientId, int offset, int userId, String driverId, String startDate, 
			String endDate, String hubList, String zone) {
		JSONArray JsonArray = new JSONArray();
		JSONObject JsonObject = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String MAX_HA_SCORE = "", MAX_HB_SCORE = "", MAX_HC_SCORE = "", MAX_OVER_SPEED_SCORE = "", MAX_FREE_WHEEL_SCORE = "", MAX_IDLE_SCORE = "", MAX_GREEN_BAND_SPEED_SCORE = "", MAX_GREEN_BAND_RPM_SCORE = "", MAX_LOW_RPM_SCORE = "", MAX_HIGH_RPM_SCORE = "", MAX_OVER_REVV_SCORE = "", MAX_UNSCHDL_STOPPAGE_SCORE = "";
		String MIN_HA_SCORE = "", MIN_HB_SCORE = "", MIN_HC_SCORE = "", MIN_OVER_SPEED_SCORE = "", MIN_FREE_WHEEL_SCORE = "", MIN_IDLE_SCORE = "", MIN_GREEN_BAND_SPEED_SCORE = "", MIN_GREEN_BAND_RPM_SCORE = "", MIN_LOW_RPM_SCORE = "", MIN_HIGH_RPM_SCORE = "", MIN_OVER_REVV_SCORE = "", MIN_UNSCHDL_STOPPAGE_SCORE = "";
		String AVG_HA_SCORE = "", AVG_HB_SCORE = "", AVG_HC_SCORE = "", AVG_OVER_SPEED_SCORE = "", AVG_FREE_WHEEL_SCORE = "", AVG_IDLE_SCORE = "", AVG_GREEN_BAND_SPEED_SCORE = "", AVG_GREEN_BAND_RPM_SCORE = "", AVG_LOW_RPM_SCORE = "", AVG_HIGH_RPM_SCORE = "", AVG_OVER_REVV_SCORE = "", AVG_UNSCHDL_STOPPAGE_SCORE = "";
		try {
			JsonArray = new JSONArray();
			JsonObject = new JSONObject();
			con = DBConnection.getConnectionToDB("AMS");

			pstmt = con.prepareStatement(GeneralVerticalStatements.GET_MAX_AVG_MIN_ALL_DRIVERS);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, clientId);
			pstmt.setInt(3, offset);
			pstmt.setString(4, startDate);
			pstmt.setInt(5, offset);
			pstmt.setString(6, endDate);
			pstmt.setInt(7, offset);
			pstmt.setString(8, startDate);
			pstmt.setInt(9, offset);
			pstmt.setString(10, endDate);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				MAX_HA_SCORE = df1.format(rs.getDouble("MAX_HA_SCORE"));
				MAX_HB_SCORE = df1.format(rs.getDouble("MAX_HB_SCORE"));
				MAX_HC_SCORE = df1.format(rs.getDouble("MAX_HC_SCORE"));
				MAX_OVER_SPEED_SCORE = df1.format(rs.getDouble("MAX_OVER_SPEED_SCORE"));
				MAX_FREE_WHEEL_SCORE = df1.format(rs.getDouble("MAX_FREE_WHEEL_SCORE"));
				MAX_IDLE_SCORE = df1.format(rs.getDouble("MAX_IDLE_SCORE"));
				MAX_GREEN_BAND_SPEED_SCORE = df1.format(rs.getDouble("MAX_GREEN_BAND_SPEED_SCORE"));
				MAX_GREEN_BAND_RPM_SCORE = df1.format(rs.getDouble("MAX_GREEN_BAND_RPM_SCORE"));
				MAX_LOW_RPM_SCORE = df1.format(rs.getDouble("MAX_LOW_RPM_SCORE"));
				MAX_HIGH_RPM_SCORE = df1.format(rs.getDouble("MAX_HIGH_RPM_SCORE"));
				MAX_OVER_REVV_SCORE = df1.format(rs.getDouble("MAX_OVER_REVV_SCORE"));
				MAX_UNSCHDL_STOPPAGE_SCORE = df1.format(rs.getDouble("MAX_UNSCHDL_STOPPAGE_SCORE"));

				MIN_HA_SCORE = df1.format(rs.getDouble("MIN_HA_SCORE"));
				MIN_HB_SCORE = df1.format(rs.getDouble("MIN_HB_SCORE"));
				MIN_HC_SCORE = df1.format(rs.getDouble("MIN_HC_SCORE"));
				MIN_OVER_SPEED_SCORE = df1.format(rs.getDouble("MIN_OVER_SPEED_SCORE"));
				MIN_FREE_WHEEL_SCORE = df1.format(rs.getDouble("MIN_FREE_WHEEL_SCORE"));
				MIN_IDLE_SCORE = df1.format(rs.getDouble("MIN_IDLE_SCORE"));
				MIN_GREEN_BAND_SPEED_SCORE = df1.format(rs.getDouble("MIN_GREEN_BAND_SPEED_SCORE"));
				MIN_GREEN_BAND_RPM_SCORE = df1.format(rs.getDouble("MIN_GREEN_BAND_RPM_SCORE"));
				MIN_LOW_RPM_SCORE = df1.format(rs.getDouble("MIN_LOW_RPM_SCORE"));
				MIN_HIGH_RPM_SCORE = df1.format(rs.getDouble("MIN_HIGH_RPM_SCORE"));
				MIN_OVER_REVV_SCORE = df1.format(rs.getDouble("MIN_OVER_REVV_SCORE"));
				MIN_UNSCHDL_STOPPAGE_SCORE = df1.format(rs.getDouble("MIN_UNSCHDL_STOPPAGE_SCORE"));

				AVG_HA_SCORE = df1.format(rs.getDouble("AVG_HA_SCORE"));
				AVG_HB_SCORE = df1.format(rs.getDouble("AVG_HB_SCORE"));
				AVG_HC_SCORE = df1.format(rs.getDouble("AVG_HC_SCORE"));
				AVG_OVER_SPEED_SCORE = df1.format(rs.getDouble("AVG_OVER_SPEED_SCORE"));
				AVG_FREE_WHEEL_SCORE = df1.format(rs.getDouble("AVG_FREE_WHEEL_SCORE"));
				AVG_IDLE_SCORE = df1.format(rs.getDouble("AVG_IDLE_SCORE"));
				AVG_GREEN_BAND_SPEED_SCORE = df1.format(rs.getDouble("AVG_GREEN_BAND_SPEED_SCORE"));
				AVG_GREEN_BAND_RPM_SCORE = df1.format(rs.getDouble("AVG_GREEN_BAND_RPM_SCORE"));
				AVG_LOW_RPM_SCORE = df1.format(rs.getDouble("AVG_LOW_RPM_SCORE"));
				AVG_HIGH_RPM_SCORE = df1.format(rs.getDouble("AVG_HIGH_RPM_SCORE"));
				AVG_OVER_REVV_SCORE = df1.format(rs.getDouble("AVG_OVER_REVV_SCORE"));
				AVG_UNSCHDL_STOPPAGE_SCORE = df1.format(rs.getDouble("AVG_UNSCHDL_STOPPAGE_SCORE"));
			}
			if (rs != null)
				rs.close();
			pstmt.close();

			pstmt = con.prepareStatement(GeneralVerticalStatements.GET_DATA_TO_COLUMN_CHART);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, clientId);
			pstmt.setString(3, driverId);
			pstmt.setInt(4, offset);
			pstmt.setString(5, startDate);
			pstmt.setInt(6, offset);
			pstmt.setString(7, endDate);
			pstmt.setInt(8, offset);
			pstmt.setString(9, startDate);
			pstmt.setInt(10, offset);
			pstmt.setString(11, endDate);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				JsonObject = new JSONObject();
				JsonObject.put("ha", df1.format(rs.getDouble("HA_SCORE")));
				JsonObject.put("hb", df1.format(rs.getDouble("HB_SCORE")));
				JsonObject.put("hc", df1.format(rs.getDouble("HC_SCORE")));
				JsonObject.put("overspeed", df1.format(rs.getDouble("OVER_SPEED_SCORE")));
				JsonObject.put("freeWwheeling", df1.format(rs.getDouble("FREE_WHEEL_SCORE")));
				JsonObject.put("idle", df1.format(rs.getDouble("IDLE_SCORE")));
				JsonObject.put("greenBand", df1.format(rs.getDouble("GREEN_BAND_SPEED_SCORE")));
				JsonObject.put("erratic", 0);
				JsonObject.put("greenbandrpm", df1.format(rs.getDouble("GREEN_BAND_RPM_SCORE")));
				JsonObject.put("lowrpm", df1.format(rs.getDouble("LOW_RPM_SCORE")));
				JsonObject.put("highrpm", df1.format(rs.getDouble("HIGH_RPM_SCORE")));
				JsonObject.put("overRevv", df1.format(rs.getDouble("OVER_REVV_SCORE")));
				JsonObject.put("unscheduledStoppage", df1.format(rs.getDouble("UNSCHDL_STOPPAGE_SCORE")));

				// Maximum
				JsonObject.put("max_ha", MAX_HA_SCORE);
				JsonObject.put("max_hb", MAX_HB_SCORE);
				JsonObject.put("max_hc", MAX_HC_SCORE);
				JsonObject.put("max_overspeed", MAX_OVER_SPEED_SCORE);
				JsonObject.put("max_freeWwheeling", MAX_FREE_WHEEL_SCORE);
				JsonObject.put("max_idle", MAX_IDLE_SCORE);
				JsonObject.put("max_greenBand", MAX_GREEN_BAND_SPEED_SCORE);
				JsonObject.put("max_erratic", 0);
				JsonObject.put("max_greenbandrpm", MAX_GREEN_BAND_RPM_SCORE);
				JsonObject.put("max_lowrpm", MAX_LOW_RPM_SCORE);
				JsonObject.put("max_highrpm", MAX_HIGH_RPM_SCORE);
				JsonObject.put("max_overRevv", MAX_OVER_REVV_SCORE);
				JsonObject.put("max_unscheduledStoppage", MAX_UNSCHDL_STOPPAGE_SCORE);

				// Average
				JsonObject.put("avg_ha", AVG_HA_SCORE);
				JsonObject.put("avg_hb", AVG_HB_SCORE);
				JsonObject.put("avg_hc", AVG_HC_SCORE);
				JsonObject.put("avg_overspeed", AVG_OVER_SPEED_SCORE);
				JsonObject.put("avg_freeWwheeling", AVG_FREE_WHEEL_SCORE);
				JsonObject.put("avg_idle", AVG_IDLE_SCORE);
				JsonObject.put("avg_greenBand", AVG_GREEN_BAND_SPEED_SCORE);
				JsonObject.put("avg_erratic", 0);
				JsonObject.put("avg_greenbandrpm", AVG_GREEN_BAND_RPM_SCORE);
				JsonObject.put("avg_lowrpm", AVG_LOW_RPM_SCORE);
				JsonObject.put("avg_highrpm", AVG_HIGH_RPM_SCORE);
				JsonObject.put("avg_overRevv", AVG_OVER_REVV_SCORE);
				JsonObject.put("avg_unscheduledStoppage", AVG_UNSCHDL_STOPPAGE_SCORE);

				// Minimun
				JsonObject.put("min_ha", MIN_HA_SCORE);
				JsonObject.put("min_hb", MIN_HB_SCORE);
				JsonObject.put("min_hc", MIN_HC_SCORE);
				JsonObject.put("min_overspeed", MIN_OVER_SPEED_SCORE);
				JsonObject.put("min_freeWwheeling", MIN_FREE_WHEEL_SCORE);
				JsonObject.put("min_idle", MIN_IDLE_SCORE);
				JsonObject.put("min_greenBand", MIN_GREEN_BAND_SPEED_SCORE);
				JsonObject.put("min_erratic", 0);
				JsonObject.put("min_greenbandrpm", MIN_GREEN_BAND_RPM_SCORE);
				JsonObject.put("min_lowrpm", MIN_LOW_RPM_SCORE);
				JsonObject.put("min_highrpm", MIN_HIGH_RPM_SCORE);
				JsonObject.put("min_overRevv", MIN_OVER_REVV_SCORE);
				JsonObject.put("min_unscheduledStoppage", MIN_UNSCHDL_STOPPAGE_SCORE);

				JsonArray.put(JsonObject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return JsonArray;
	}

	private static Map<String, Integer> sortByValue(Map<String, Integer> unsortMap) {
		List<Map.Entry<String, Integer>> list = new LinkedList<Map.Entry<String, Integer>>(unsortMap.entrySet());
		Collections.sort(list, new Comparator<Map.Entry<String, Integer>>() {
			public int compare(Map.Entry<String, Integer> o1, Map.Entry<String, Integer> o2) {
				return (o1.getValue()).compareTo(o2.getValue());
			}
		});
		Map<String, Integer> sortedMap = new LinkedHashMap<String, Integer>();
		for (Map.Entry<String, Integer> entry : list) {
			sortedMap.put(entry.getKey(), entry.getValue());
		}
		return sortedMap;
	}

	public JSONArray getCustomerMasterDetails(int systemId, String custId, int offset, int userId) {
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonobject = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int count = 0;
		try {
			jsonArray = new JSONArray();
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(GeneralVerticalStatements.GET_CUSTOMER_TRIP_DETAILS);
			pstmt.setInt(1, systemId);
			pstmt.setString(2, custId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				count++;

				jsonobject = new JSONObject();
				jsonobject.put("slno", count);
				jsonobject.put("custNameIndex", rs.getString("NAME"));
				jsonobject.put("contactPersonIndex", rs.getString("CONTACT_PERSON"));
				jsonobject.put("contactNoIndex", rs.getString("CONTACT_NO"));
				jsonobject.put("contactNo2Index", rs.getString("CONTACT_NO2"));
				jsonobject.put("contactAddressIndex", rs.getString("CONTACT_ADDRESS"));
				jsonobject.put("refIndex", rs.getString("CUSTOMER_REFERENCE_ID"));
				jsonobject.put("custtypeIndex", rs.getString("TYPE"));
				jsonobject.put("statusIndex", rs.getString("STATUS"));
				jsonobject.put("button", "<button onclick=openModal('" + rs.getString("NAME").replace(" ", "$").replace("\'", "#") + "','"
						+ rs.getString("CONTACT_PERSON").replace(" ", "$").replace("\'", "#") + "','" + rs.getString("CONTACT_NO") + "','"+ rs.getString("CONTACT_NO2") + "','"
						+ rs.getString("CONTACT_ADDRESS").replace(" ", "$").replace("\'", "#") + "','" + rs.getString("CUSTOMER_REFERENCE_ID").replace(" ", "$").replace("\'", "#") + "','"
						+ rs.getString("TYPE").replace(" ", "-") + "','" + rs.getString("STATUS").replace(" ", "-") + "','" + rs.getInt("ID")
						+ "'); class='btn btn-warning glyphicon glyphicon-pencil' id='myBtn' name='myname'>Edit</button>");

				jsonArray.put(jsonobject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jsonArray;
	}

	public String insertCustomerMasterDetails(int systemId, int custId, int offset, int userId, String custName, String contactPerson, String contactNo, String contactAddress, String custRefId,
			String status, String custType,String contactNo2) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String message = "";

		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(GeneralVerticalStatements.INSERT_CUSTOMER_DETAILS);
			pstmt.setString(1, custName);
			pstmt.setInt(2, systemId);
			pstmt.setInt(3, custId);
			pstmt.setString(4, contactPerson);
			pstmt.setString(5, contactNo);
			pstmt.setString(6, contactAddress);
			pstmt.setString(7, custRefId);
			pstmt.setString(8, status);
			pstmt.setString(9, custType);
			pstmt.setString(10, contactNo2);
			int inserted = pstmt.executeUpdate();
			if (inserted > 0) {
				message = "Saved Successfully";
			} else {
				message = "Error in Saving";
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}

		return message;
	}

	public String updateCustomerMasterDetails(int systemId, int custId, int offset, int userId, String customerName, String contactPerson, String contactNo, String contactAddress, String custRefId,
			int id, String status, String custType,String contactNo2) {
		Connection con = null;
		ResultSet rs = null;
		PreparedStatement pstmt = null;
		PreparedStatement pstmt1 = null;
		PreparedStatement pstmt2 = null;
		PreparedStatement pstmt3 = null;
		String message = "";
		int uId = 0;
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(GeneralVerticalStatements.UPDATE_CUSTOMER_TRIP_DETAILS);
			pstmt.setString(1, customerName);
			pstmt.setString(2, contactPerson);
			pstmt.setString(3, contactNo);
			pstmt.setString(4, contactAddress);
			pstmt.setString(5, custRefId);
			pstmt.setString(6, status);
			pstmt.setString(7, custType);
			pstmt.setString(8, contactNo2);
			pstmt.setInt(9, id);

			int updated = pstmt.executeUpdate();
			if (updated > 0) {
				message = "Record Updated";
				if (status.equals("Inactive") || status.equals("Active")) {
					pstmt1 = con.prepareStatement(GeneralVerticalStatements.GET_USERS_FOR_CUSTOMER);
					pstmt1.setInt(1, id);
					rs = pstmt1.executeQuery();
					while (rs.next()) {
						uId = rs.getInt("USER_ID");
						pstmt2 = con.prepareStatement(GeneralVerticalStatements.UPDATE_Users_STATUS);
						pstmt2.setString(1, status);
						pstmt2.setInt(2, uId);
						pstmt2.setInt(3, systemId);
						pstmt2.setInt(4, custId);
						pstmt2.executeUpdate();
						pstmt3 = con.prepareStatement(GeneralVerticalStatements.UPDATE_USERS_STATUS);
						pstmt3.setString(1, status);
						pstmt3.setInt(2, uId);
						pstmt3.setInt(3, systemId);
						pstmt3.setInt(4, custId);
						pstmt3.executeUpdate();
					}
				}

			} else {
				message = "Error.";
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return message;
	}

	public JSONArray getIOTypeList(String type) {
		JSONArray jArr = new JSONArray();
		JSONObject obj = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			jArr = new JSONArray();
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(GeneralVerticalStatements.CHECK_IO_TYPE_LIST);
			pstmt.setString(1, "RS232_IO");
			rs = pstmt.executeQuery();
			while (rs.next()) {
				obj = new JSONObject();
				obj.put("ioTypeName", rs.getString("VALUE"));
				jArr.put(obj);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jArr;
	}

	public JSONArray getcheckpointBuffer(int userId, int clientId, int systemId, String zone, int isLtsp, int tripCustId) {

		JSONArray BufferArray = new JSONArray();
		JSONObject BufferObject = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			BufferArray = new JSONArray();
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(GeneralVerticalStatements.GET_CHECKPOINT_BUFFERS.replace("LOCATION", "LOCATION_ZONE_" + zone));
			pstmt.setInt(1, clientId);
			pstmt.setInt(2, systemId);
			pstmt.setInt(3, tripCustId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				BufferObject = new JSONObject();
				BufferObject.put("buffername", rs.getString("NAME"));
				BufferObject.put("latitude", rs.getString("LATITUDE"));
				BufferObject.put("longitude", rs.getString("LONGITUDE"));
				BufferObject.put("radius", rs.getString("RADIUS"));
				if (rs.getString("IMAGE") != "")
					BufferObject.put("imagename", rs.getString("IMAGE"));
				else
					BufferObject.put("imagename", rs.getString("IMAGE"));
				BufferObject.put("hubId", rs.getString("HUBID"));
				BufferArray.put(BufferObject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}

		return BufferArray;
	}

	public JSONArray getcheckpointPolygon(int userId, int customerId, int systemId, String zone, int isLTSP, int tripCustId) {

		JSONArray PolygonArray = new JSONArray();
		JSONObject PolygonObject = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			PolygonArray = new JSONArray();
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(GeneralVerticalStatements.GET_CHECKPOINT_POLYGONS.replace("LOCATION_ZONE", "LOCATION_ZONE_" + zone));
			pstmt.setInt(1, customerId);
			pstmt.setInt(2, systemId);
			pstmt.setInt(3, tripCustId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				PolygonObject = new JSONObject();
				PolygonObject.put("polygonname", rs.getString("NAME"));
				PolygonObject.put("latitude", rs.getString("LATITUDE"));
				PolygonObject.put("longitude", rs.getString("LONGITUDE"));
				PolygonObject.put("sequence", rs.getString("SEQUENCE_ID"));
				PolygonObject.put("hubid", rs.getString("HUBID"));
				PolygonArray.put(PolygonObject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return PolygonArray;
	}

	public String saveLegDetails(int tripCustId, String legName, String source, String destination, String distance, String avgSpeed, String TAT, String[] checkPointjs, String[] routejs,
			String[] dragPointjs, int systemId, int clientId, int userId, String sLat, String sLon, String dLat, String dLon, int legModId, String statusA, String sourceRad, String sourceDet,
			String destinationRad, String destinationDet, String[] durationArr, String sessionId, String serverName, String PageName, String[] distancePointjs, String zone) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String message = "";
		int legId = 0;
		int count = 0;
		ArrayList<String> arr = new ArrayList<String>();
		ArrayList<String> arr1 = new ArrayList<String>();
		ArrayList<String> tableList = new ArrayList<String>();
		String operation = "";
		try {
			con = DBConnection.getConnectionToDB("AMS");
			for (String durationArr1 : durationArr) {
				durationArr1 = durationArr1.substring(1, durationArr1.length() - 1);
				String[] dur1 = durationArr1.split(",");
				arr.add(dur1[1]);
			}
			for (String distanceArr1 : distancePointjs) {
				distanceArr1 = distanceArr1.substring(1, distanceArr1.length() - 1);
				String[] dist1 = distanceArr1.split(",");
				arr1.add(dist1[1]);
			}
			if (legModId > 0) {
				pstmt = con.prepareStatement(GeneralVerticalStatements.UPDATE_LEG_MASTER_DETAILS);
				pstmt.setString(1, legName);
				pstmt.setString(2, distance);
				pstmt.setString(3, avgSpeed);
				pstmt.setDouble(4, cf.convertHHMMToMinutes1(TAT));
				pstmt.setString(5, source);
				pstmt.setString(6, destination);
				pstmt.setInt(7, legModId);
				pstmt.executeUpdate();

				pstmt = con.prepareStatement(GeneralVerticalStatements.DELETE_LEG_DETAILS);
				pstmt.setInt(1, legModId);
				pstmt.executeUpdate();

				operation = "UPDATE";
				if (statusA.equalsIgnoreCase("Active")) {
					updateStatus(systemId, legModId, "Active", "", "", "", userId, clientId, "ACTIVATE");
				}
				legId = legModId;
				tableList.add("Update" + "##" + "AMS.dbo.LEG_MASTER");
				tableList.add("Delete" + "##" + "AMS.dbo.LEG_DETAILS");

			} else {
				pstmt = con.prepareStatement(GeneralVerticalStatements.INSERT_LEG_MASTER_DETAILS, PreparedStatement.RETURN_GENERATED_KEYS);
				pstmt.setString(1, legName);
				pstmt.setInt(2, tripCustId);
				pstmt.setString(3, distance);
				pstmt.setString(4, avgSpeed);
				pstmt.setDouble(5, cf.convertHHMMToMinutes1(TAT));
				pstmt.setInt(6, systemId);
				pstmt.setInt(7, clientId);
				pstmt.setInt(8, userId);
				pstmt.setString(9, "Active");
				pstmt.setString(10, source);
				pstmt.setString(11, destination);
				pstmt.executeUpdate();
				rs = pstmt.getGeneratedKeys();
				if (rs.next()) {
					legId = rs.getInt(1);
					tableList.add("Insert" + "##" + "AMS.dbo.LEG_MASTER");
				}
				operation = "ADD";
			}
			if (legId > 0) {
				for (int i = 0; i < 2; i++) {
					int segment = 0;
					String stype = "";
					String hubId = "0";
					String latitude = "0";
					String longitude = "0";
					int seq = 0;
					String rad = "0";
					String det = "0";
					String dur = "0";
					String dist = "0";
					if (i == 0) {
						segment = 1;
						stype = "SOURCE";
						hubId = source;
						latitude = sLat;
						longitude = sLon;
						seq = 1;
						rad = sourceRad;
						det = sourceDet;
						dur = "0";
						dist = "0";
					} else {
						segment = 2;
						stype = "DESTINATION";
						hubId = destination;
						latitude = dLat;
						longitude = dLon;
						seq = routejs.length + 2;
						rad = destinationRad;
						det = destinationDet;
						dur = arr.get(arr.size() - 1);
						dist = arr1.get(arr1.size() - 1);
					}
					pstmt = con.prepareStatement(GeneralVerticalStatements.INSERT_LEG_POINTS);
					pstmt.setInt(1, legId);
					pstmt.setInt(2, segment);
					pstmt.setInt(3, seq);
					pstmt.setString(4, latitude);
					pstmt.setString(5, longitude);
					pstmt.setInt(6, Integer.parseInt(hubId));
					pstmt.setString(7, stype);
					pstmt.setString(8, rad);
					pstmt.setString(9, det);
					pstmt.setInt(10, Integer.parseInt(dur));
					pstmt.setInt(11, 0);
					pstmt.setString(12, df.format(Double.parseDouble(dist)));
					pstmt.executeUpdate();
				}
				for (String routes : routejs) {
					routes = routes.substring(1, routes.length() - 1);
					String[] routesdetails = routes.split(",");
					pstmt = con.prepareStatement(GeneralVerticalStatements.INSERT_LEG_POINTS);
					pstmt.setInt(1, legId);
					pstmt.setInt(2, 1);
					pstmt.setInt(3, Integer.parseInt(routesdetails[0]) + 1);
					pstmt.setString(4, routesdetails[1]);
					pstmt.setString(5, routesdetails[2]);
					pstmt.setInt(6, 0);
					pstmt.setString(7, "");
					pstmt.setString(8, "0");
					pstmt.setString(9, "0");
					pstmt.setString(10, "0");
					pstmt.setInt(11, 0);
					pstmt.setString(12, "0");
					pstmt.executeUpdate();
				}
				if (checkPointjs != null) {
					for (String checkpointArr : checkPointjs) {
						count++;
						String type = "CHECKPOINT";
						checkpointArr = checkpointArr.substring(1, checkpointArr.length() - 1);
						String[] checkPointdetails = checkpointArr.split(",");
						pstmt = con.prepareStatement(GeneralVerticalStatements.INSERT_LEG_POINTS);
						pstmt.setInt(1, legId);
						pstmt.setInt(2, 3);
						pstmt.setInt(3, Integer.parseInt(checkPointdetails[0]));
						pstmt.setString(4, checkPointdetails[1]);
						pstmt.setString(5, checkPointdetails[2]);
						pstmt.setString(6, checkPointdetails[3]);
						pstmt.setString(7, type);
						pstmt.setString(8, checkPointdetails[4]);
						pstmt.setString(9, checkPointdetails[5]);
						pstmt.setInt(10, Integer.parseInt(arr.get(count)));
						pstmt.setInt(11, 0);
						pstmt.setString(12, df.format(Double.parseDouble(arr1.get(count))));
						pstmt.executeUpdate();

					}
				}
				if (dragPointjs != null) {
					for (String dragpointArr : dragPointjs) {
						String type = "DRAGPOINT";
						dragpointArr = dragpointArr.substring(1, dragpointArr.length() - 1);
						String[] dragPointdetails = dragpointArr.split(",");
						pstmt = con.prepareStatement(GeneralVerticalStatements.INSERT_LEG_POINTS);
						pstmt.setInt(1, legId);
						pstmt.setInt(2, 4);
						pstmt.setInt(3, Integer.parseInt(dragPointdetails[0]));
						pstmt.setString(4, dragPointdetails[1].replace("(", ""));
						pstmt.setString(5, dragPointdetails[2].replace(")", ""));
						pstmt.setInt(6, 0);
						pstmt.setString(7, type);
						pstmt.setFloat(8, 0);
						pstmt.setFloat(9, 0);
						pstmt.setString(10, "0");
						pstmt.setInt(11, Integer.parseInt(dragPointdetails[3]));
						pstmt.setString(12, "0");
						pstmt.executeUpdate();
					}
				}
				if (legModId > 0) {
					// update route and on trip also
					modifyLegRoutesAndOnTrips(con, legModId, serverName, sessionId, systemId, clientId, userId, zone);
				}
				message = "Saved Successfully" + "##" + legId;
				tableList.add("Insert" + "##" + "AMS.dbo.LEG_DETAILS");
			}
			try {
				cf.insertDataIntoAuditLogReport(sessionId, tableList, PageName, operation, userId, serverName, systemId, clientId, "Leg Creation");
			} catch (Exception e) {
				e.printStackTrace();
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, null);
		}
		return message;
	}

	public JSONArray getSmartHubBuffer(int userId, int clientId, int systemId, String zone, int isLtsp, int tripCustId) {

		JSONArray BufferArray = new JSONArray();
		JSONObject BufferObject = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			BufferArray = new JSONArray();
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(GeneralVerticalStatements.GET_SMART_HUB_BUFFERS.replace("LOCATION", "LOCATION_ZONE_" + zone));
			pstmt.setInt(1, clientId);
			pstmt.setInt(2, systemId);
			pstmt.setInt(3, tripCustId);
			pstmt.setInt(4, clientId);
			pstmt.setInt(5, systemId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				BufferObject = new JSONObject();
				BufferObject.put("buffername", rs.getString("NAME"));
				BufferObject.put("latitude", rs.getString("LATITUDE"));
				BufferObject.put("longitude", rs.getString("LONGITUDE"));
				BufferObject.put("radius", rs.getString("RADIUS"));
				if (rs.getString("IMAGE") != "")
					BufferObject.put("imagename", rs.getString("IMAGE"));
				else
					BufferObject.put("imagename", rs.getString("IMAGE"));
				BufferObject.put("hubId", rs.getString("HUBID"));
				BufferObject.put("detention", rs.getString("DETENTION"));
				BufferArray.put(BufferObject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}

		return BufferArray;
	}

	public JSONArray getSmartHubBuffer(int userId, int clientId, int systemId, String zone, int isLtsp, List<String> tripCustIds) {

		JSONArray BufferArray = new JSONArray();
		JSONObject BufferObject = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			BufferArray = new JSONArray();
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(GeneralVerticalStatements.GET_SMART_HUB_BUFFERS_FOR_TRIPCUST.replace("LOCATION", "LOCATION_ZONE_" + zone).replace("#",
					CommonFunctions.convertListToSqlINParam(tripCustIds)));
			pstmt.setInt(1, clientId);
			pstmt.setInt(2, systemId);
			pstmt.setInt(3, clientId);
			pstmt.setInt(4, systemId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				BufferObject = new JSONObject();
				BufferObject.put("buffername", rs.getString("NAME"));
				BufferObject.put("latitude", rs.getDouble("LATITUDE"));
				BufferObject.put("longitude", rs.getDouble("LONGITUDE"));
				BufferObject.put("radius", rs.getString("RADIUS"));
				if (rs.getString("IMAGE") != "")
					BufferObject.put("imagename", rs.getString("IMAGE"));
				else
					BufferObject.put("imagename", rs.getString("IMAGE"));
				BufferObject.put("hubId", rs.getString("HUBID"));
				BufferObject.put("detention", rs.getString("DETENTION"));
				BufferObject.put("tripCustomerId", rs.getInt("TRIP_CUSTOMER_ID"));
				BufferArray.put(BufferObject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}

		return BufferArray;
	}

	public JSONArray getSmartHubPolygon(int userId, int customerId, int systemId, String zone, int isLTSP, List<String> tripCustIds) {

		JSONArray PolygonArray = new JSONArray();
		JSONObject PolygonObject = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			PolygonArray = new JSONArray();
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(GeneralVerticalStatements.GET_SMART_HUB_POLYGONS_FOR_TRIPCUST.replace("LOCATION_ZONE", "LOCATION_ZONE_" + zone).replace("#",
					CommonFunctions.convertListToSqlINParam(tripCustIds)));
			pstmt.setInt(1, customerId);
			pstmt.setInt(2, systemId);
			pstmt.setInt(3, customerId);
			pstmt.setInt(4, systemId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				PolygonObject = new JSONObject();
				PolygonObject.put("polygonname", rs.getString("NAME"));
				PolygonObject.put("latitude", rs.getDouble("LATITUDE"));
				PolygonObject.put("longitude", rs.getDouble("LONGITUDE"));
				PolygonObject.put("sequence", rs.getString("SEQUENCE_ID"));
				PolygonObject.put("hubid", rs.getString("HUBID"));
				PolygonObject.put("tripCustomerId", rs.getInt("TRIP_CUSTOMER_ID"));
				PolygonArray.put(PolygonObject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return PolygonArray;
	}

	private boolean checkIfSmartHubWithinGivenLatLngRadius(double vehicleLat, double vehicleLng, double radius, int tripCustId, JSONArray smartHubArray) throws JSONException {
		for (int i = 0; i < smartHubArray.length(); i++) {
			JSONObject obj = (JSONObject) smartHubArray.get(i);
			double distance = CommonUtil.checkDistance(vehicleLat, vehicleLng, (Double) obj.get("latitude"), (Double) obj.get("longitude"));
			if ((tripCustId == obj.getInt("tripCustomerId")) && distance <= radius) {
				return true;
			}
		}
		return false;
	}

	public JSONArray getSmartHubBufferWithinGivenLatLngRadius(int userId, int clientId, int systemId, String zone, int isLtsp, int tripCustId, double latitude, double longitude, double radius) {
		JSONArray BufferArray = new JSONArray();
		JSONObject BufferObject = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			BufferArray = new JSONArray();
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(GeneralVerticalStatements.GET_SMART_HUB_BUFFERS.replace("LOCATION", "LOCATION_ZONE_" + zone));
			pstmt.setInt(1, clientId);
			pstmt.setInt(2, systemId);
			pstmt.setInt(3, tripCustId);
			pstmt.setInt(4, clientId);
			pstmt.setInt(5, systemId);
			rs = pstmt.executeQuery();
			double reachDistance = 0.0;
			while (rs.next()) {
				// check if smart hub is within given lat long
				reachDistance = CommonUtil.checkDistance(Double.parseDouble(rs.getString("LATITUDE")), Double.parseDouble(rs.getString("LONGITUDE")), latitude, longitude);
				if (!(reachDistance <= radius)) {
					continue;
				}
				BufferObject = new JSONObject();
				BufferObject.put("buffername", rs.getString("NAME"));
				BufferObject.put("latitude", rs.getString("LATITUDE"));
				BufferObject.put("longitude", rs.getString("LONGITUDE"));
				BufferObject.put("radius", rs.getString("RADIUS"));
				if (rs.getString("IMAGE") != "")
					BufferObject.put("imagename", rs.getString("IMAGE"));
				else
					BufferObject.put("imagename", rs.getString("IMAGE"));
				BufferObject.put("hubId", rs.getString("HUBID"));
				BufferArray.put(BufferObject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}

		return BufferArray;
	}

	public JSONArray getSmartHubPolygon(int userId, int customerId, int systemId, String zone, int isLTSP, int tripCustId) {

		JSONArray PolygonArray = new JSONArray();
		JSONObject PolygonObject = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			PolygonArray = new JSONArray();
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(GeneralVerticalStatements.GET_SMART_HUB_POLYGONS.replace("LOCATION_ZONE", "LOCATION_ZONE_" + zone));
			pstmt.setInt(1, customerId);
			pstmt.setInt(2, systemId);
			pstmt.setInt(3, tripCustId);
			pstmt.setInt(4, customerId);
			pstmt.setInt(5, systemId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				PolygonObject = new JSONObject();
				PolygonObject.put("polygonname", rs.getString("NAME"));
				PolygonObject.put("latitude", rs.getString("LATITUDE"));
				PolygonObject.put("longitude", rs.getString("LONGITUDE"));
				PolygonObject.put("sequence", rs.getString("SEQUENCE_ID"));
				PolygonObject.put("hubid", rs.getString("HUBID"));
				PolygonArray.put(PolygonObject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return PolygonArray;
	}

	public JSONArray getSmartHubPolygonWithinGivenLatLngRadius(int userId, int customerId, int systemId, String zone, int isLTSP, int tripCustId, double latitude, double longitude, double radius) {

		JSONArray PolygonArray = new JSONArray();
		JSONObject PolygonObject = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			PolygonArray = new JSONArray();
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(GeneralVerticalStatements.GET_SMART_HUB_POLYGONS.replace("LOCATION_ZONE", "LOCATION_ZONE_" + zone));
			pstmt.setInt(1, customerId);
			pstmt.setInt(2, systemId);
			pstmt.setInt(3, tripCustId);
			pstmt.setInt(4, customerId);
			pstmt.setInt(5, systemId);
			rs = pstmt.executeQuery();
			double reachDistance = 0.0;
			while (rs.next()) {
				// check if smart hub is within given lat long
				reachDistance = CommonUtil.checkDistance(Double.parseDouble(rs.getString("LAT")), Double.parseDouble(rs.getString("LNG")), latitude, longitude);
				if (!(reachDistance <= radius)) {
					continue;
				}
				PolygonObject = new JSONObject();
				PolygonObject.put("polygonname", rs.getString("NAME"));
				PolygonObject.put("latitude", rs.getString("LATITUDE"));
				PolygonObject.put("longitude", rs.getString("LONGITUDE"));
				PolygonObject.put("sequence", rs.getString("SEQUENCE_ID"));
				PolygonObject.put("hubid", rs.getString("HUBID"));
				PolygonArray.put(PolygonObject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return PolygonArray;
	}

	public JSONArray getLegNames(int clientId, int systemId, String tripCust, String zone, int hubId) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject = null;
		try {
			con = DBConnection.getConnectionToDB("AMS");
			if (hubId > 0) {
				pstmt = con.prepareStatement(GeneralVerticalStatements.GET_LEG_NAMES.concat("and ld.HUB_ID in (" + hubId + ")").replaceAll("AMS.dbo.LOCATION", "AMS.dbo.LOCATION_ZONE_" + zone));
			} else {
				pstmt = con.prepareStatement(GeneralVerticalStatements.GET_LEG_NAMES.replaceAll("AMS.dbo.LOCATION", "AMS.dbo.LOCATION_ZONE_" + zone));
			}
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, clientId);
			pstmt.setString(3, tripCust);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				jsonObject = new JSONObject();
				jsonObject.put("legName", rs.getString("LEG_NAME"));
				jsonObject.put("legId", rs.getInt("ID"));
				jsonObject.put("hubId", rs.getInt("HUB_ID"));
				jsonObject.put("TAT", rs.getInt("TAT"));
				jsonObject.put("detention", rs.getInt("Standard_Duration"));
				jsonObject.put("distance", rs.getDouble("distance"));

				jsonArray.put(jsonObject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jsonArray;
	}

	public JSONArray getLegMasterDetails(int systemId, int clientId, int offset, String tripCustId, String zone) {
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonobject = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int count = 0;
		try {
			jsonArray = new JSONArray();
			con = DBConnection.getConnectionToDB("AMS");

			String Statement = GeneralVerticalStatements.GET_LEG_MASTER_DETAILS.replaceAll("AMS.dbo.LOCATION", "AMS.dbo.LOCATION_ZONE_" + zone);

			String array1 = (tripCustId.substring(0, tripCustId.length() - 1));
			String newCustomerList = "'" + array1.toString().replace(",", "','") + "'";

			Statement = Statement.replace("#", " and TRIP_CUST_ID in (" + newCustomerList + ")");

			// String stmt = GeneralVerticalStatements.GET_LEG_MASTER_DETAILS;
			// if(tripCustId.equals("00000")){
			// stmt = stmt.replace("#", "");
			// }else{
			// stmt = stmt.replace("#", " and TRIP_CUST_ID="+tripCustId);
			// }
			pstmt = con.prepareStatement(Statement);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, clientId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				count++;
				jsonobject = new JSONObject();
				jsonobject.put("slNoIndex", count);
				jsonobject.put("legNameIndex", rs.getString("LEG_NAME"));
				jsonobject.put("custNameIndex", rs.getString("CUST_NAME"));
				jsonobject.put("sourceIndex", rs.getString("SOURCE"));
				jsonobject.put("destinationIndex", rs.getString("DESTINATION"));
				jsonobject.put("avgSpeedIndex", df1.format(rs.getDouble("AVG_SPEED")));
				jsonobject.put("distanceIndex", df1.format(rs.getDouble("DISTANCE")));
				jsonobject.put("TATIndex", cf.convertMinutesToHHMMFormat(rs.getInt("TAT")));
				jsonobject.put("statusIndex", rs.getString("STATUS"));
				int id = rs.getInt("ID");
				String legName = "'" + rs.getString("LEG_NAME").replaceAll("\\s", "-") + "'";
				String avgSpeed = df1.format(rs.getDouble("AVG_SPEED"));
				String distance = df1.format(rs.getDouble("DISTANCE"));
				String TAT = "'" + cf.convertMinutesToHHMMFormat(rs.getInt("TAT")) + "'";
				String status = "";
				String status1 = "";
				if (rs.getString("STATUS").equalsIgnoreCase("active")) {
					status = "'" + "Inactive" + "'";
					status1 = "Deactivate";
				} else {
					status = "'" + "Active" + "'";
					status1 = "Active";
				}
				if (status1.equals("Active")) {
					jsonobject.put("action", "");
				} else {
					// if(array1.length() > 2) {
					// jsonobject.put("action","<button onClick=modifyRecord("+id+","+legName+","+avgSpeed+","+distance+","+TAT+","+rs.getInt("ROUTE_COUNT")+"); class='btn btn-info  text-center' disabled>Modify/View</button>");
					// }
					// else {
					// jsonobject.put("action","<button onClick=modifyRecord("+id+","+legName+","+avgSpeed+","+distance+","+TAT+","+rs.getInt("ROUTE_COUNT")+"); class='btn btn-info  text-center'>Modify/View</button>");
					// }
					jsonobject.put("action", "<button onClick=modifyRecord(" + id + "," + legName + "," + avgSpeed + "," + distance + "," + TAT + "," + rs.getInt("ROUTE_COUNT")
							+ "); class='btn btn-info  text-center'>Modify/View</button>");
				}
				// if(tripCustId.equals("00000")){
				// if(array1.length() > 2) {
				// jsonobject.put("action1","<button onclick=updateStatus("+id+","+legName+","+avgSpeed+","+distance+","+TAT+","+status+","+rs.getInt("ROUTE_COUNT")+"); class='btn btn-info  text-center' disabled>"+status1+"</button>");
				// }else {
				// jsonobject.put("action1","<button onclick=updateStatus("+id+","+legName+","+avgSpeed+","+distance+","+TAT+","+status+","+rs.getInt("ROUTE_COUNT")+"); class='btn btn-info  text-center'>"+status1+"</button>");
				// }
				jsonobject.put("action1", "<button onclick=updateStatus(" + id + "," + legName + "," + avgSpeed + "," + distance + "," + TAT + "," + status + "," + rs.getInt("ROUTE_COUNT")
						+ "); class='btn btn-info  text-center'>" + status1 + "</button>");
				jsonArray.put(jsonobject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jsonArray;
	}

	public JSONArray getLegLatLongs(int legId, int systemId, String zone) {

		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			con = DBConnection.getConnectionToDB("AMS");
			jsonArray = new JSONArray();
			jsonObject = new JSONObject();
			pstmt = con.prepareStatement(GeneralVerticalStatements.GET_LATLONGS_FOR_LEG.replaceAll("AMS.dbo.LOCATION", "AMS.dbo.LOCATION_ZONE_" + zone));
			pstmt.setInt(1, legId);
			pstmt.setInt(2, legId);
			pstmt.setInt(3, legId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				jsonObject = new JSONObject();
				jsonObject.put("sequence", rs.getString("ROUTE_SEQUENCE"));
				jsonObject.put("lat", rs.getString("LATITUDE"));
				jsonObject.put("lon", rs.getString("LONGITUDE"));
				jsonObject.put("type", rs.getString("TYPE"));
				jsonObject.put("hubId", rs.getString("HUB_ID"));
				jsonObject.put("checkSeq", rs.getString("CHECKPOINT_SEQUENCE"));
				jsonObject.put("maxCheck", rs.getString("MAX_CHECK"));
				jsonObject.put("maxdrag", rs.getString("MAX_DRAG"));
				jsonArray.put(jsonObject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jsonArray;

	}

	public JSONArray getRouteLatLongs(int routeId, int systemId, String zone) {

		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			con = DBConnection.getConnectionToDB("AMS");
			jsonArray = new JSONArray();
			jsonObject = new JSONObject();
			pstmt = con.prepareStatement(GeneralVerticalStatements.GET_LATLONGS_FOR_LEG.replaceAll("AMS.dbo.LOCATION", "AMS.dbo.LOCATION_ZONE_" + zone));
			pstmt.setInt(1, routeId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				jsonObject = new JSONObject();
				jsonObject.put("sequence", rs.getString("ROUTE_SEQUENCE"));
				jsonObject.put("lat", rs.getString("LATITUDE"));
				jsonObject.put("lon", rs.getString("LONGITUDE"));
				jsonObject.put("type", rs.getString("TYPE"));
				jsonObject.put("hubId", rs.getString("HUB_ID"));
				jsonArray.put(jsonObject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jsonArray;

	}

	public JSONArray getRouteMasterDetails(int systemId, int clientId, int offset, String tripCustId) {
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonobject = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int count = 0;
		try {
			jsonArray = new JSONArray();
			con = DBConnection.getConnectionToDB("AMS");
			String stmt = GeneralVerticalStatements.GET_ROUTE_MASTER_DETAILS;

			String array1 = (tripCustId.substring(0, tripCustId.length() - 1));
			String newCustomerList = "'" + array1.toString().replace(",", "','") + "'";

			stmt = stmt.replace("#", " and TRIP_CUST_ID in (" + newCustomerList + ")");
			/*
			 * if(tripCustId.equals("00000")){ stmt = stmt.replace("#", "");
			 * }else{ stmt = stmt.replace("#", " and TRIP_CUST_ID="+tripCustId);
			 * }
			 */
			pstmt = con.prepareStatement(stmt);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, clientId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				count++;
				jsonobject = new JSONObject();
				jsonobject.put("slNoIndex", count);
				jsonobject.put("custNameIndex", rs.getString("CUST_NAME"));
				jsonobject.put("routeNameIndex", rs.getString("ROUTE_NAME"));
				jsonobject.put("routeKeyIndex", rs.getString("ROUTE_KEY"));
				jsonobject.put("distanceIndex", df1.format(rs.getDouble("DISTANCE")));
				jsonobject.put("TATIndex", cf.formattedDaysHoursMinutes(rs.getInt("TAT") * 60000));
				jsonobject.put("radiusIndex", df1.format(rs.getDouble("RADIUS")));
				jsonobject.put("statusIndex", rs.getString("STATUS"));
				int id = rs.getInt("ID");
				String routeName = "'" + rs.getString("ROUTE_NAME").replaceAll("\\s", "-") + "'";
				String routeKey = "'" + rs.getString("ROUTE_KEY").replaceAll("\\s", "-") + "'";
				String distance = df1.format(rs.getDouble("DISTANCE"));
				String radius = df1.format(rs.getDouble("RADIUS"));
				String TAT = "'" + cf.formattedDaysHoursMinutes(rs.getInt("TAT") * 60000) + "'";
				String status = "";
				String status1 = "";
				if (rs.getString("STATUS").equalsIgnoreCase("active")) {
					status = "'" + "Inactive" + "'";
					status1 = "Inactive";
				} else {
					status = "'" + "Active" + "'";
					status1 = "Active";
				}
				int Tripcount = rs.getInt("COUNT");
				if (status1.equals("Active")) {
					jsonobject.put("action1", "");
					jsonobject.put("action", "<button onClick=modifyRoute(" + id + "," + routeName + "," + routeKey + "," + distance + "," + TAT + "," + status + "," + radius + "," + Tripcount
							+ "); class='btn btn-info  text-center'>Modify" + " / Active</button>");
					// if(array1.length() > 2) {
					// jsonobject.put("action",
					// "<button onClick=modifyRoute("+id+","+routeName+","+routeKey+","+distance+","+TAT+","+status+","+radius+","+Tripcount+"); class='btn btn-info  text-center' disabled>Modify"+" / Active</button>");
					// }
					// else {
					// jsonobject.put("action",
					// "<button onClick=modifyRoute("+id+","+routeName+","+routeKey+","+distance+","+TAT+","+status+","+radius+","+Tripcount+"); class='btn btn-info  text-center'>Modify"+" / Active</button>");
					// }
				} else {
					jsonobject.put("action", "<button onClick=modifyRoute(" + id + "," + routeName + "," + routeKey + "," + distance + "," + TAT + "," + status + "," + radius + "," + Tripcount
							+ "); class='btn btn-info  text-center'>Modify</button>");
					jsonobject.put("action1", "<button onclick=updateStatus(" + id + "," + routeName + "," + routeKey + "," + distance + "," + TAT + "," + status + "," + radius + "," + Tripcount
							+ ");  class='btn btn-info  text-center'>Deactivate</button>");
					// if(array1.length() > 2) {
					// jsonobject.put("action",
					// "<button onClick=modifyRoute("+id+","+routeName+","+routeKey+","+distance+","+TAT+","+status+","+radius+","+Tripcount+"); class='btn btn-info  text-center' disabled>Modify</button>");
					// jsonobject.put("action1",
					// "<button onclick=updateStatus("+id+","+routeName+","+routeKey+","+distance+","+TAT+","+status+","+radius+","+Tripcount+");  class='btn btn-info  text-center' disabled>Deactivate</button>");
					// }else {
					// jsonobject.put("action",
					// "<button onClick=modifyRoute("+id+","+routeName+","+routeKey+","+distance+","+TAT+","+status+","+radius+","+Tripcount+"); class='btn btn-info  text-center'>Modify</button>");
					// jsonobject.put("action1",
					// "<button onclick=updateStatus("+id+","+routeName+","+routeKey+","+distance+","+TAT+","+status+","+radius+","+Tripcount+");  class='btn btn-info  text-center'>Deactivate</button>");
					// }

				}
				jsonArray.put(jsonobject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jsonArray;
	}

	public String saveRouteDetails(int tripCustId, String routeName, String routeKey, String distance, String TAT, String[] legjs, int systemId, int clientId, int userId, int routeModId,
			String statusA, String routeRadius, String sessionId, String serverName, String pageName, String detentionCheckPointsArray, String zone) {
		Connection con = null;
		PreparedStatement pstmt = null;
		PreparedStatement pstmt1 = null;
		ResultSet rs = null;
		ResultSet rs1 = null;
		String message = "";
		int routeId = 0;
		ArrayList<String> tableList = new ArrayList<String>();
		ArrayList<String> checkPointArray = new ArrayList<String>();
		String[] strArr = null;
		String operation = "";
		ArrayList<Double> legArray = null;
		Set<Integer> set = new HashSet<Integer>();
		ArrayList<ArrayList<Double>> legsArray = new ArrayList<ArrayList<Double>>();
		try {
			if (detentionCheckPointsArray.length() > 0) {
				strArr = detentionCheckPointsArray.replaceAll("^[^{]*|[^}]*$", "").split("(?<=\\})[^{]*");

				for (String detentionCheckPointsArray1 : strArr) {
					String[] checkPoint = detentionCheckPointsArray1.split(",");
					if (checkPoint.length > 1) {
						checkPointArray.add(checkPoint[0] + "," + checkPoint[1] + "," + checkPoint[2]);
					}

				}
			}
			con = DBConnection.getConnectionToDB("AMS");
			if (routeModId > 0) {
				pstmt = con.prepareStatement(GeneralVerticalStatements.UPDATE_ROUTE_MASTER_DETAILS);
				pstmt.setString(1, routeName);
				pstmt.setString(2, distance);
				pstmt.setString(3, routeKey);
				pstmt.setDouble(4, cf.convertDDHHMMToMinutes(TAT));
				pstmt.setString(5, routeRadius);
				pstmt.setInt(6, routeModId);
				pstmt.executeUpdate();

				operation = "UPDATE";
				pstmt = con.prepareStatement(GeneralVerticalStatements.DELETE_ROUTE_DETAILS);
				pstmt.setInt(1, routeModId);
				pstmt.executeUpdate();

				if (statusA.equalsIgnoreCase("Active")) {
					updateStatusForRoute(systemId, routeModId, "Active", "", "", "", userId, clientId, "ACTIVATE");
				}
				routeId = routeModId;
				tableList.add("Update" + "##" + "AMS.dbo.TRIP_ROUTE_MASTER");
				tableList.add("Update" + "##" + "AMS.dbo.TRIP_ROUTE_DETAILS");

			} else {
				pstmt = con.prepareStatement(GeneralVerticalStatements.CHECK_DUPLICATE_ROUTE);
				pstmt.setString(1, routeName);
				pstmt.setInt(2, systemId);
				pstmt.setInt(3, clientId);
				pstmt.setInt(4, tripCustId);
				rs = pstmt.executeQuery();
				if (rs.next()) {
					message = "Route Already exists" + "##" + 0;
				} else {
					pstmt = con.prepareStatement(GeneralVerticalStatements.INSERT_ROUTE_MASTER_DETAILS, PreparedStatement.RETURN_GENERATED_KEYS);
					pstmt.setString(1, routeName);
					pstmt.setString(2, routeKey);
					if ("QTP".equals(pageName)) {
						pstmt.setDouble(3, cf.convertHHMMToMinutes1(TAT));
					} else {
						pstmt.setDouble(3, cf.convertDDHHMMToMinutes(TAT));
					}
					pstmt.setString(4, distance);
					pstmt.setString(5, "Active");
					pstmt.setInt(6, systemId);
					pstmt.setInt(7, clientId);
					pstmt.setInt(8, tripCustId);
					pstmt.setInt(9, userId);
					pstmt.setString(10, routeRadius);
					pstmt.executeUpdate();
					rs = pstmt.getGeneratedKeys();
					if (rs.next()) {
						routeId = rs.getInt(1);
						tableList.add("Insert" + "##" + "AMS.dbo.TRIP_ROUTE_MASTER");
					}
					operation = "ADD";
				}
			}
			if (routeId > 0) {
				for (String legs : legjs) {
					// legs = legs.replace("{", "").replace("}", "");
					String avgSpeedL = "0";
					String distanceL = "0";
					String tatL = "0";
					String source = "";
					String dest = "";
					String Standard_Duration = "0";
					legs = legs.substring(1, legs.length() - 1);
					String[] routesdetails = legs.split(",");
					pstmt1 = con.prepareStatement(GeneralVerticalStatements.GET_LEG_DETAILS.replaceAll("AMS.dbo.LOCATION", "AMS.dbo.LOCATION_ZONE_" + zone));
					pstmt1.setInt(1, Integer.parseInt(routesdetails[1]));
					rs1 = pstmt1.executeQuery();
					if (rs1.next()) {
						avgSpeedL = rs1.getString("AVG_SPEED");
						tatL = rs1.getString("TAT");
						distanceL = rs1.getString("DISTANCE");
						source = rs1.getString("SOURCE");
						dest = rs1.getString("DESTINATION");
						Standard_Duration = rs1.getString("Standard_Duration");

						legArray = new ArrayList<Double>();
						if (Integer.parseInt(routesdetails[0]) == 1) {
							Standard_Duration = "0";
						}
						set.add(Integer.parseInt(source));
						set.add(Integer.parseInt(dest));
						legArray.add(Double.parseDouble(source));
						legArray.add(Double.parseDouble(dest));
						legArray.add(Double.parseDouble(tatL));
						legArray.add(Double.parseDouble(distanceL));
						legArray.add(Double.parseDouble(Standard_Duration));
						legsArray.add(legArray);

					}
					if (Integer.parseInt(routesdetails[0]) == 1) {
						Standard_Duration = "0";
					}
					pstmt = con.prepareStatement(GeneralVerticalStatements.INSERT_ROUTE_POINTS);
					pstmt.setInt(1, routeId);
					pstmt.setInt(2, Integer.parseInt(routesdetails[1]));
					pstmt.setString(3, avgSpeedL);
					pstmt.setString(4, tatL);
					pstmt.setString(5, distanceL);
					pstmt.setInt(6, Integer.parseInt(routesdetails[0]));
					pstmt.setString(7, source);
					pstmt.setString(8, dest);
					pstmt.setString(9, Standard_Duration);
					pstmt.executeUpdate();
				}
				for (String checkPoint : checkPointArray) {
					String[] checkPointdetails = checkPoint.replaceAll("[{}]", "").split(",");
					String checkPointLegId = checkPointdetails[0];
					String checkPointHubId = checkPointdetails[1];
					int checkPointDetention = cf.convertHHMMToMinutes1(checkPointdetails[2]);

					pstmt = con.prepareStatement(GeneralVerticalStatements.GET_ROUTE_HUB_LEG_DETENTION_DETAILS_COUNT);
					pstmt.setInt(1, routeId);
					pstmt.setInt(2, Integer.parseInt(checkPointLegId));
					pstmt.setInt(3, Integer.parseInt(checkPointHubId));
					rs = pstmt.executeQuery();
					if (rs.next()) {
						int count = rs.getInt("count");
						if (count > 0) {
							pstmt = con.prepareStatement(GeneralVerticalStatements.UPDATE_ROUTE_HUB_LEG_DETENTION_DETAILS);
							pstmt.setInt(1, checkPointDetention);
							pstmt.setInt(2, routeId);
							pstmt.setInt(3, Integer.parseInt(checkPointLegId));
							pstmt.setInt(4, Integer.parseInt(checkPointHubId));
							pstmt.executeUpdate();
						} else {
							pstmt = con.prepareStatement(GeneralVerticalStatements.INSERT_ROUTE_HUB_LEG_DETENTION_DETAILS);
							pstmt.setInt(1, routeId);
							pstmt.setInt(2, Integer.parseInt(checkPointLegId));
							pstmt.setInt(3, Integer.parseInt(checkPointHubId));
							pstmt.setInt(4, checkPointDetention);
							pstmt.executeUpdate();

						}
					}
				}
				message = "Saved Successfully" + "##" + routeId;
				tableList.add("Insert" + "##" + "AMS.dbo.TRIP_ROUTE_DETAILS");
			}
			if (routeModId > 0) {
				// modifiy on trip also
				updateHubChangeForOnTrips(routeModId);
			}
			try {
				cf.insertDataIntoAuditLogReport(sessionId, tableList, pageName, operation, userId, serverName, systemId, clientId, "Route Creation");
			} catch (Exception e) {

				e.printStackTrace();
			}
		} catch (Exception e) {
			message = "Error" + "##" + 0;
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, null);
		}
		return message;
	}

	public String updateStatus(int systemId, int legId, String status, String serverName, String sessionId, String PageName, int userId, int clientId, String action) {
		Connection con = null;
		PreparedStatement pstmt = null;
		String message = "";
		ArrayList<String> tableList = new ArrayList<String>();
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(GeneralVerticalStatements.UPDATE_STATUS);
			pstmt.setString(1, status);
			pstmt.setInt(2, legId);
			int updated = pstmt.executeUpdate();
			if (updated > 0) {
				message = "Status Updated";
				tableList.add("Update" + "##" + "AMS.dbo.LEG_MASTER");
			} else {
				message = "Error.";
			}
			try {
				cf.insertDataIntoAuditLogReport(sessionId, tableList, PageName, action, userId, serverName, systemId, clientId, "Leg Creation");
			} catch (Exception e) {
				e.printStackTrace();
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, null);
		}
		return message;
	}

	public JSONArray getSourceDestination(int clientId, int systemId, String zone, int tripCustId) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject = null;
		try {
			con = DBConnection.getConnectionToDB("AMS");
			jsonObject = new JSONObject();
			jsonObject.put("Hub_Id", "");
			jsonObject.put("Hub_Name", "---select---");
			jsonObject.put("latitude", "");
			jsonObject.put("longitude", "");
			jsonObject.put("radius", "");
			jsonArray.put(jsonObject);
			String type = "";
			// String query=";

			String query1 = GeneralVerticalStatements.GET_TYPE;
			pstmt = con.prepareStatement(query1);
			pstmt.setInt(1, tripCustId);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				type = rs.getString("TYPE");
			}

			String query = cf.getLocationQuery(GeneralVerticalStatements.GET_SOURCE_DESTINATION_LEG, zone);
			if (type.equalsIgnoreCase("Broker")) {
				query = query.replace("$", ",999");
			} else {
				query = query.replace("$", "");
			}
			if (tripCustId == 99999 || tripCustId == 00000) {
				query = query.replace("#", "");
			} else {
				query = query.replace("#", "and TRIP_CUSTOMER_ID = " + tripCustId + " ");
			}

			pstmt = con.prepareStatement(query);
			pstmt.setInt(1, clientId);
			pstmt.setInt(2, systemId);
			// pstmt.setInt(3, tripCustId);
			pstmt.setInt(3, clientId);
			pstmt.setInt(4, systemId);
			// pstmt.setInt(6, tripCustId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				jsonObject = new JSONObject();
				jsonObject.put("Hub_Id", rs.getInt("HUBID"));
				if (tripCustId == 99999) {
					jsonObject.put("Hub_Name", rs.getString("FULLHUBNAME"));
				} else {
					jsonObject.put("Hub_Name", rs.getString("NAME"));
				}
				jsonObject.put("latitude", rs.getString("LATITUDE"));
				jsonObject.put("longitude", rs.getString("LONGITUDE"));
				jsonObject.put("radius", rs.getString("RADIUS"));
				jsonObject.put("detention", rs.getString("DETENTION"));
				jsonObject.put("hubAddress", rs.getString("HUB_ADDRESS"));
				jsonArray.put(jsonObject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jsonArray;
	}

	public JSONArray getCheckPoints(int clientId, int systemId, String zone, int tripCustId) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject = null;
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(cf.getLocationQuery(GeneralVerticalStatements.GET_CHECKPOINT_LEG, zone));
			pstmt.setInt(1, clientId);
			pstmt.setInt(2, systemId);
			// pstmt.setInt(3, tripCustId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				jsonObject = new JSONObject();
				jsonObject.put("Hub_Id", rs.getInt("HUBID"));
				jsonObject.put("Hub_Name", rs.getString("NAME"));
				jsonObject.put("latitude", rs.getString("LATITUDE"));
				jsonObject.put("longitude", rs.getString("LONGITUDE"));
				jsonObject.put("radius", rs.getString("RADIUS"));
				jsonObject.put("detention", rs.getString("DETENTION"));
				jsonObject.put("hubAddress", rs.getString("HUB_ADDRESS"));
				jsonArray.put(jsonObject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jsonArray;
	}

	public JSONArray getTripNames(int systemid, int clientid, int offset) {
		JSONArray jArr = new JSONArray();
		JSONObject obj1 = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {

			jArr = new JSONArray();
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(GeneralVerticalStatements.GET_TRIP_NAME_FOR_OBD);
			pstmt.setInt(1, offset);
			pstmt.setInt(2, offset);
			pstmt.setInt(3, offset);
			pstmt.setInt(4, systemid);
			pstmt.setInt(5, clientid);
			rs = pstmt.executeQuery();
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
				jArr.put(obj1);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jArr;
	}

	public JSONArray getLatLongsForCompleteRoute(String legIds, int systemId, String routeId, String zone) {

		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		PreparedStatement pstmt1 = null;
		ResultSet rs1 = null;
		String type = "";
		boolean legDest = false;
		ArrayList<ArrayList<String>> finalList = new ArrayList<ArrayList<String>>();
		ArrayList<String> list = new ArrayList<String>();
		ArrayList<String> list1 = new ArrayList<String>();

		try {
			con = DBConnection.getConnectionToDB("AMS");
			jsonArray = new JSONArray();
			jsonObject = new JSONObject();
			if (!legIds.equals("")) {
				String[] legArr = legIds.split(",");
				for (int j = 0; j < legArr.length; j++) {
					pstmt = con.prepareStatement((cf.getLocationQuery(GeneralVerticalStatements.GET_LATLONGS_FOR_ROUTE, zone)), ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
					pstmt.setString(1, legArr[j]);
					rs = pstmt.executeQuery();
					while (rs.next()) {
						list = new ArrayList<String>();
						list.add(rs.getString("ROUTE_SEQUENCE"));
						list.add(rs.getString("LATITUDE"));
						list.add(rs.getString("LONGITUDE"));
						list.add(rs.getString("HUB_ID"));
						list.add(rs.getString("TYPE"));
						list.add(rs.getString("CHECKPOINT_SEQUENCE"));
						list.add(rs.getString("LEG_ID"));
						list.add(rs.getString("DETENTION"));
						list.add(rs.getString("TAT"));
						list.add(rs.getString("LEG_NAME"));
						list.add(rs.getString("HUB_ADDRESS"));
						finalList.add(list);
					}
				}

				int prevLegId = 0;
				int prevHubId = 0;

				int checkPtSeq = 0;
				for (int i = 0; i <= (finalList.size() - 1); i++) {
					int currLegId = Integer.parseInt(finalList.get(i).get(6));

					int currHubId = Integer.parseInt(finalList.get(i).get(3));

					if (prevHubId != currHubId) {

						if (currLegId == prevLegId) {
							// checkPtSeq = i;
						} else {
							checkPtSeq = 0;
						}

						list1 = finalList.get(i);
						type = list1.get(4);
						legDest = false;
						if (type.equalsIgnoreCase("DESTINATION")) {
							legDest = true;
						}

						if (i == 0) {
							type = "SOURCE";
						} else if (i == finalList.size() - 1) {
							type = "DESTINATION";
						} else {
							type = "CHECKPOINT";
						}

						String detention = finalList.get(i).get(7);
						Integer routeHubDetention = null;
						jsonObject = new JSONObject();
						jsonObject.put("sequence", finalList.get(i).get(0));
						jsonObject.put("lat", finalList.get(i).get(1));
						jsonObject.put("lon", finalList.get(i).get(2));
						jsonObject.put("type", type);
						jsonObject.put("hubId", finalList.get(i).get(3));
						jsonObject.put("hubAddress", finalList.get(i).get(10));
						jsonObject.put("legDest", legDest);
						if (type.equalsIgnoreCase("CHECKPOINT") && (routeId != null)) {
							pstmt = con.prepareStatement(GeneralVerticalStatements.GET_ROUTE_HUB_LEG_DETENTION);
							pstmt.setString(1, routeId);
							pstmt.setString(2, finalList.get(i).get(6)); // legId
							pstmt.setString(3, finalList.get(i).get(3)); // hubId
							rs = pstmt.executeQuery();
							while (rs.next()) {
								routeHubDetention = rs.getInt("ROUTE_HUB_DETENTION_DETAILS_DETENTION");
							}
							jsonObject.put("detention", routeHubDetention == null ? "00:00" : cf.convertMinutesToHHMMFormat(routeHubDetention));
						} else {
							jsonObject.put("detention", detention == null ? "00:00" : cf.convertMinutesToHHMMFormat(Integer.parseInt(detention)));
						}
						String str = finalList.get(i).get(8);// NTC Requirement
						Double str1 = Double.parseDouble(str);
						long milliseconds = new Double(str1).longValue() * 60 * 1000;
						jsonObject.put("legId", currLegId);
						jsonObject.put("TAT", cf.formattedDaysHoursMinutes(milliseconds));
						jsonObject.put("LEG_NAME", finalList.get(i).get(9));
						jsonObject.put("RUN_TIME", ""); // setting blank as they
						// get updated in JSP --
						// NTC Requirement
						jsonObject.put("materialId", ""); // setting blank as
						// they get updated
						// in JSP
						jsonObject.put("materialName", ""); // setting blank as
						// they get updated
						// in JSP
						jsonObject.put("DDHHMMdetention", detention == null ? "00:00:00" : cf.formattedDaysHoursMinutes(Integer.parseInt(detention) * 60 * 1000));
						// jsonObject.put("detentionHubId",
						// (list1.get(4).equals("DESTINATION")&&(i!=(finalList.size()-1)))?true:
						// false); // NTC Requirement ends
						jsonArray.put(jsonObject);

						pstmt1 = con.prepareStatement(GeneralVerticalStatements.GET_DRAGPOINTS, ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
						pstmt1.setString(1, list1.get(6));
						pstmt1.setInt(2, checkPtSeq);
						rs1 = pstmt1.executeQuery();
						while (rs1.next()) {
							jsonObject = new JSONObject();
							jsonObject.put("sequence", rs1.getString("ROUTE_SEQUENCE"));
							jsonObject.put("lat", rs1.getString("LATITUDE"));
							jsonObject.put("lon", rs1.getString("LONGITUDE"));
							jsonObject.put("type", "DRAGPOINT");
							jsonObject.put("hubId", rs1.getString("HUB_ID"));
							jsonObject.put("hubAddress", " ");
							jsonArray.put(jsonObject);

						}
						checkPtSeq = checkPtSeq + 1;

						rs1 = null;

						prevLegId = currLegId;
					}

					prevHubId = currHubId;
				}
				/*
				 * for(int i=1;i <= finalList.size();i++){ jsonObject = new
				 * JSONObject(); if(i==1){ type="SOURCE"; }else if
				 * (i==finalList.size()){ type="DESTINATION"; }else{
				 * type="CHECKPOINT"; } jsonObject.put("sequence",
				 * finalList.get(i-1).get(0)); jsonObject.put("lat",
				 * finalList.get(i-1).get(1)); jsonObject.put("lon",
				 * finalList.get(i-1).get(2)); jsonObject.put("type", type);
				 * jsonObject.put("hubId", finalList.get(i-1).get(3));
				 * jsonArray.put(jsonObject); }
				 */
			}

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		DBConnection.releaseConnectionToDB(con, pstmt1, rs1);
		return jsonArray;

	}

	public JSONArray getIndvRoute(String legId, int systemId, String zone) {

		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			con = DBConnection.getConnectionToDB("AMS");
			jsonArray = new JSONArray();
			jsonObject = new JSONObject();
			pstmt = con.prepareStatement(GeneralVerticalStatements.GET_ROUTE_LATLONGS.replaceAll("AMS.dbo.LOCATION", "AMS.dbo.LOCATION_ZONE_" + zone));
			pstmt.setString(1, legId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				jsonObject.put("sequence", rs.getString("ROUTE_SEQUENCE"));
				jsonObject.put("lat", rs.getString("LATITUDE"));
				jsonObject.put("lon", rs.getString("LONGITUDE"));
				jsonObject.put("type", rs.getString("TYPE"));
				jsonObject.put("hubId", rs.getString("HUB_ID"));
				jsonArray.put(jsonObject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jsonArray;

	}

	public JSONArray getLegList(int routeId, int systemId) {

		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			con = DBConnection.getConnectionToDB("AMS");
			jsonArray = new JSONArray();
			jsonObject = new JSONObject();
			pstmt = con.prepareStatement(GeneralVerticalStatements.GET_LEG_IDS);
			pstmt.setInt(1, routeId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				jsonObject = new JSONObject();
				jsonObject.put("legId", rs.getInt("LEG_ID"));
				jsonArray.put(jsonObject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jsonArray;

	}

	public String updateStatusForRoute(int systemId, int routeId, String status, String serverName, String sessionId, String PageName, int userId, int clientId, String action) {
		Connection con = null;
		PreparedStatement pstmt = null;
		PreparedStatement pstmt1 = null;
		String message = "";
		ArrayList<String> tableList = new ArrayList<String>();
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(GeneralVerticalStatements.UPDATE_STATUS_FOR_ROUTE);
			pstmt.setString(1, status);
			pstmt.setInt(2, routeId);
			int updated = pstmt.executeUpdate();
			if (updated > 0) {
				message = "Status Updated";
				tableList.add("Update" + "##" + "AMS.dbo.TRIP_ROUTE_MASTER");
				pstmt1 = con.prepareStatement(GeneralVerticalStatements.UPDATE_LEG_STATUS_OF_A_ROUTE);
				pstmt1.setString(1, status);
				pstmt1.setInt(2, routeId);
				updated = pstmt1.executeUpdate();
			} else {
				message = "Error.";
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, null);
			DBConnection.releaseConnectionToDB(null, pstmt1, null);
		}
		try {
			cf.insertDataIntoAuditLogReport(sessionId, tableList, PageName, action, userId, serverName, systemId, clientId, "Route Creation");
		} catch (Exception e) {
			e.printStackTrace();
		}
		return message;
	}

	public JSONArray getUsersBasedOnCustomer(int systemId, int custId) {
		JSONArray JsonArray = null;
		JSONObject JsonObject = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			JsonArray = new JSONArray();
			con = DBConnection.getConnectionToDB("ADMINISTRATOR");
			pstmt = con.prepareStatement(AdminStatements.GET_USERS);
			pstmt.setInt(1, custId);
			pstmt.setInt(2, systemId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				JsonObject = new JSONObject();
				JsonObject.put("userId", rs.getInt("User_id"));
				JsonObject.put("userName", rs.getString("User_Name"));
				JsonArray.put(JsonObject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return JsonArray;
	}

	public ArrayList<Object> getDataForNonAssociation(int customerId, int systemId, int userId) {
		JSONArray JsonArray = new JSONArray();
		JSONObject JsonObject = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		ArrayList<Object> finlist = new ArrayList<Object>();
		try {
			int count = 0;
			con = DBConnection.getConnectionToDB("AMS");
			if (customerId != 0) {
				pstmt = con.prepareStatement(GeneralVerticalStatements.GET_NON_ASSOCIATION_DATA_FOR_USER);
				pstmt.setInt(1, customerId);
				pstmt.setInt(2, systemId);
				pstmt.setInt(3, userId);
				pstmt.setInt(4, systemId);
				rs = pstmt.executeQuery();
			} else {
				pstmt = con.prepareStatement(GeneralVerticalStatements.GET_NON_ASSOCIATION_DATA_FOR_LTSP_USERS);
				pstmt.setInt(1, systemId);
				pstmt.setInt(2, userId);
				pstmt.setInt(3, systemId);
				rs = pstmt.executeQuery();
			}
			while (rs.next()) {
				JsonObject = new JSONObject();
				count++;
				JsonObject.put("slnoIndex", count);
				JsonObject.put("custNameDataIndex", rs.getString("CUSTOMER_NAME"));
				JsonObject.put("custIdDataIndex", rs.getString("ID"));
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

	public ArrayList<Object> getDataForAssociation(int customerId, int systemId, int userId) {
		JSONArray JsonArray = new JSONArray();
		JSONObject JsonObject = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		ArrayList<Object> finlist = new ArrayList<Object>();
		try {
			int count = 0;
			con = DBConnection.getConnectionToDB("AMS");
			if (customerId != 0) {
				pstmt = con.prepareStatement(GeneralVerticalStatements.GET_ASSOCIATION_DATA_FOR_USER);
				pstmt.setInt(1, userId);
				pstmt.setInt(2, systemId);
				pstmt.setInt(3, customerId);
				rs = pstmt.executeQuery();
			} else {
				pstmt = con.prepareStatement(GeneralVerticalStatements.GET_ASSOCIATION_DATA_FOR_LTSP_USERS);
				pstmt.setInt(1, userId);
				pstmt.setInt(2, systemId);
				rs = pstmt.executeQuery();
			}
			while (rs.next()) {
				JsonObject = new JSONObject();
				count++;
				JsonObject.put("slnoIndex2", count);
				JsonObject.put("custNameDataIndex2", rs.getString("CUSTOMER_NAME"));
				JsonObject.put("custIdDataIndex2", rs.getString("ID"));
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

	public String associateCustomer(int customerId, int systemId, int userIdFromJsp, JSONArray js, int userId, String pageName, String sessionId, String serverName) {
		Connection con = null;
		PreparedStatement pstmt = null;
		PreparedStatement pstmt2 = null;
		PreparedStatement pstmt3 = null;
		ResultSet rs = null;
		ResultSet rs1 = null;
		String message = "";
		ArrayList<String> vehicleList = new ArrayList<String>();
		try {
			con = DBConnection.getConnectionToDB("AMS");
			con.setAutoCommit(false);
			for (int i = 0; i < js.length(); i++) {
				vehicleList.clear();
				JSONObject obj = js.getJSONObject(i);

				String custId = obj.getString("custIdDataIndex");

				pstmt2 = con.prepareStatement(GeneralVerticalStatements.CHECK_IF_PRESENT);
				pstmt2.setInt(1, userIdFromJsp);
				pstmt2.setInt(2, customerId);
				pstmt2.setInt(3, systemId);
				pstmt2.setString(4, custId);
				rs1 = pstmt2.executeQuery();
				if (!rs1.next()) {
					pstmt3 = con.prepareStatement(GeneralVerticalStatements.INSERT_INTO_USER_CUSTOMER_ASSOCIATION);
					pstmt3.setInt(1, userIdFromJsp);
					pstmt3.setInt(2, customerId);
					pstmt3.setInt(3, systemId);
					pstmt3.setInt(4, userId);
					pstmt3.setString(5, custId);
					pstmt3.executeUpdate();
				}
			}

			con.commit();
			message = "Associated Successfully.";
		} catch (Exception e) {
			e.printStackTrace();
			try {
				if (con != null)
					con.rollback();
			} catch (Exception ex) {
				ex.printStackTrace();
			}
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
			DBConnection.releaseConnectionToDB(null, pstmt2, rs1);
			DBConnection.releaseConnectionToDB(null, pstmt3, null);
		}
		return message;
	}

	public String dissociateCustomer(int customerId, int systemId, int userIdFromJsp, JSONArray js, int userId, String pageName, String sessionId, String serverName) {
		Connection con = null;
		PreparedStatement pstmt1 = null;
		PreparedStatement pstmt2 = null;
		PreparedStatement pstmt3 = null;
		PreparedStatement pstmt = null;
		String message = "";
		ArrayList<String> tableList = new ArrayList<String>();
		try {
			con = DBConnection.getConnectionToDB("AMS");
			con.setAutoCommit(false);
			for (int i = 0; i < js.length(); i++) {
				JSONObject obj = js.getJSONObject(i);
				String custId = obj.getString("custIdDataIndex2");
				pstmt = con.prepareStatement(GeneralVerticalStatements.MOVE_DATA_TO_USER_CUSTOMER_ASSOCIATION_HISTORY);
				pstmt.setInt(1, userId);
				pstmt.setInt(2, userIdFromJsp);
				pstmt.setInt(3, systemId);
				pstmt.setString(4, custId);
				pstmt.setInt(5, customerId);
				int inserted1 = pstmt.executeUpdate();
				if (inserted1 > 0) {
					tableList.add("Insert" + "##" + "dbo.USER_CUSTOMER_ASSOCIATION_HISTORY");
					pstmt2 = con.prepareStatement(GeneralVerticalStatements.DELETE_FROM_USER_CUSTOMER_ASSOCIATION);
					pstmt2.setInt(1, userIdFromJsp);
					pstmt2.setInt(2, customerId);
					pstmt2.setInt(3, systemId);
					pstmt2.setInt(4, Integer.parseInt(custId));
					int up1 = pstmt2.executeUpdate();
					if (up1 > 0) {
						tableList.add("Delete" + "##" + "dbo.USER_CUSTOMER_ASSOCIATION1");
					}
				}

			}
			con.commit();

			message = "Disassociated Successfully.";
		} catch (Exception e) {
			e.printStackTrace();
			try {
				if (con != null)
					con.rollback();
			} catch (Exception ex) {
				ex.printStackTrace();
			}
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt1, null);
			DBConnection.releaseConnectionToDB(null, pstmt3, null);
			DBConnection.releaseConnectionToDB(null, pstmt2, null);
			DBConnection.releaseConnectionToDB(null, pstmt, null);
		}
		return message;
	}

	public String getUserAssociatedCustomer(int userId, int systemId) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String customerName = "";
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(CommonStatements.GET_USER_ASSOCIATED_CUSTOMER);
			pstmt.setInt(1, userId);
			pstmt.setInt(2, systemId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				customerName = rs.getString("CUSTOMER_NAME");
			}

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return customerName;
	}

	public JSONArray getRouteDetails(int routeId) {
		JSONArray JsonArray = null;
		JSONObject JsonObject = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			JsonArray = new JSONArray();
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(AdminStatements.GET_ROUTE_DETAILS);
			pstmt.setInt(1, routeId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				JsonObject = new JSONObject();
				JsonObject.put("routeName", rs.getString("ROUTE_NAME"));
				JsonObject.put("routeKey", rs.getString("ROUTE_KEY"));
				JsonObject.put("routeRad", rs.getString("RADIUS"));
				JsonArray.put(JsonObject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return JsonArray;
	}

	public boolean checkIfRoutePresent(int routeId) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		boolean check = false;
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(AdminStatements.GET_ROUTE_DETAILS);
			pstmt.setInt(1, routeId);
			rs = pstmt.executeQuery();
			if (!rs.next()) {
				check = true;
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return check;
	}

	public double stoppageTime(String stop) {
		double d = Double.parseDouble(stop);
		double value = 0;

		int hrs = (int) d;
		int min = (int) ((d - hrs) * 60);
		String idletime = "0.0";
		if (min < 10) {
			idletime = String.valueOf(hrs) + ".0" + String.valueOf(min);
		} else {
			idletime = String.valueOf(hrs) + "." + String.valueOf(min);
		}
		if (idletime != null) {
			value = Double.parseDouble(idletime);
		} else {
			value = 0.0;
		}
		return value;
	}

	public ArrayList<Integer> getOnTimePerformance(Connection con, int systemId, int clientId, ArrayList<Integer> rangeList, ArrayList<Integer> relativeRangeList, String customerData,
			String routeList, int offset) {
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		ArrayList<Integer> perList = null;
		routeList = routeList.substring(0, routeList.length() - 1);
		//customerData = customerData.replaceAll(",", "','");
		customerData = customerData.substring(0, customerData.length() - 1);
		try {

			String Statement = GeneralVerticalStatements.GET_ON_TIME_PERFORMACE;
			Statement = Statement.replace("$", " and td.ROUTE_ID in (" + routeList + ")");
			Statement = Statement.replace("#", " and TRIP_CUSTOMER_ID in (" + customerData + ")");
			Statement = Statement.replaceAll("330", "" + offset);

			pstmt = con.prepareStatement(Statement);
			// System.out.println("getOnTimePerformance : "+Statement);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, clientId);
			pstmt.setInt(3, rangeList.get(0));
			pstmt.setInt(4, rangeList.get(1));
			pstmt.setInt(5, systemId);
			pstmt.setInt(6, clientId);
			pstmt.setInt(7, rangeList.get(0));
			pstmt.setInt(8, rangeList.get(1));
			pstmt.setInt(9, systemId);
			pstmt.setInt(10, clientId);
			pstmt.setInt(11, rangeList.get(0));
			pstmt.setInt(12, rangeList.get(1));
			pstmt.setInt(13, systemId);
			pstmt.setInt(14, clientId);
			pstmt.setInt(15, rangeList.get(0));
			pstmt.setInt(16, rangeList.get(1));
			pstmt.setInt(17, systemId);
			pstmt.setInt(18, clientId);
			pstmt.setInt(19, rangeList.get(0));
			pstmt.setInt(20, rangeList.get(1));

			rs = pstmt.executeQuery();
			int onTimePlacedPercentage = 0;
			int onTimeDepartPercentage = 0;
			int onTimeLoadPercentage = 0;
			int onTimeUnLoadPercentage = 0;
			if (rs.next()) {
				double TotalTripSource = rs.getInt("TOTAL_TRIP_AT_SOURCE");
				double OnTimePlaced = rs.getInt("ON_TIME_PLACED");
				double OntimeDepart = rs.getInt("ON_TIME_DEPART");
				double OnTimeLoad = rs.getInt("ON_TIME_LOAD");
				double OnTimeUnload = rs.getInt("ON_TIME_UNLOAD");

				if (TotalTripSource != 0) {
					double total = (OnTimePlaced / TotalTripSource);
					onTimePlacedPercentage = (int) Math.round(total * 100);
				} else {
					onTimePlacedPercentage = (int) OnTimePlaced;
				}
				if (TotalTripSource != 0) {
					double total = (OntimeDepart / TotalTripSource);
					onTimeDepartPercentage = (int) Math.round(total * 100);
				} else {
					onTimeDepartPercentage = (int) OntimeDepart;
				}
				if (TotalTripSource != 0) {
					double total = (OnTimeLoad / TotalTripSource);
					onTimeLoadPercentage = (int) Math.round(total * 100);
				} else {
					onTimeLoadPercentage = (int) OnTimeLoad;
				}
				if (TotalTripSource != 0) {
					double total = (OnTimeUnload / TotalTripSource);
					onTimeUnLoadPercentage = (int) Math.round(total * 100);
				} else {
					onTimeUnLoadPercentage = (int) OnTimeUnload;
				}
				perList = new ArrayList<Integer>();
				perList.add(onTimePlacedPercentage);
				perList.add(onTimeDepartPercentage);
				perList.add(onTimeLoadPercentage);
				perList.add(onTimeUnLoadPercentage);

			}

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(null, pstmt, rs);
		}

		return perList;

	}

	public ArrayList<Integer> getDelayhrsPerformance(Connection con, int systemId, int clientId, ArrayList<Integer> rangeList, ArrayList<Integer> relativeRangeList, String customerData,
			String routeList, int offset) {
		PreparedStatement pstmt = null, pstmt2 = null;
		ResultSet rs = null , rs2= null;
		ArrayList<Integer> perList = null;
		routeList = routeList.substring(0, routeList.length() - 1);
		//customerData = customerData.replaceAll(",", "','");
		customerData = customerData.substring(0, customerData.length() - 1);
		try {

			String Statement2 = GeneralVerticalStatements.GET_HOUR_DELAY_PERFORMACE_TOTAL;
			Statement2 = Statement2.replace("$", " and td.ROUTE_ID in (" + routeList + ")");
			Statement2 = Statement2.replace("#", " and TRIP_CUSTOMER_ID in (" + customerData + ")");
			Statement2 = Statement2.replaceAll("330", "" + offset);
			pstmt2 = con.prepareStatement(Statement2);
			pstmt2.setInt(1, systemId);
			pstmt2.setInt(2, clientId);
			pstmt2.setInt(3, rangeList.get(0));
			pstmt2.setInt(4, rangeList.get(1));
			rs2 = pstmt2.executeQuery();			
			double TOTAL = 0;
			
			if(rs2.next()){
				TOTAL = rs2.getInt("TOTAL_DELAY");
			}
				
			
			String Statement = GeneralVerticalStatements.GET_HOUR_DELAY_PERFORMACE;
			Statement = Statement.replace("$", " and td.ROUTE_ID in (" + routeList + ")");
			Statement = Statement.replace("#", " and TRIP_CUSTOMER_ID in (" + customerData + ")");
			Statement = Statement.replaceAll("330", "" + offset);

			pstmt = con.prepareStatement(Statement);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, clientId);
			pstmt.setInt(3, rangeList.get(0));
			pstmt.setInt(4, rangeList.get(1));
			rs = pstmt.executeQuery();
			
			
			int ONE_HOUR_DELAY = 0;
			int THREE_HOURS_DELAY = 0;
			int FIVE_HOUR_DELAY = 0;
			int ABOVE_FIVE_HOUR_DELAY = 0;
			int ONE_HOUR = 0;
			int THREE_HOURS = 0;
			int FIVE_HOUR = 0;
			int ABOVE_FIVE_HOUR = 0;

			while (rs.next()) {
				double temp = rs.getInt("DELAY");

				if (temp > 0 && temp < 60) {
					ONE_HOUR++;
				} else if (temp >= 60 && temp < 180) {
					THREE_HOURS++;
				} else if (temp >= 180 && temp < 300) {
					FIVE_HOUR++;
				} else if (temp >= 300) {
					ABOVE_FIVE_HOUR++;
				}
			}

			if (TOTAL != 0) {

				ONE_HOUR_DELAY = (int) Math.round((ONE_HOUR / TOTAL) * 100);
				THREE_HOURS_DELAY = (int) Math.round((THREE_HOURS / TOTAL) * 100);
				FIVE_HOUR_DELAY = (int) Math.round((FIVE_HOUR / TOTAL) * 100);
				ABOVE_FIVE_HOUR_DELAY = (int) Math.round((ABOVE_FIVE_HOUR / TOTAL) * 100);
				
			}
			
			perList = new ArrayList<Integer>();
			perList.add(ONE_HOUR_DELAY);
			perList.add(THREE_HOURS_DELAY);
			perList.add(FIVE_HOUR_DELAY);
			perList.add(ABOVE_FIVE_HOUR_DELAY);

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(null, pstmt, rs);
		}

		return perList;

	}

	public ArrayList<Integer> getSmartTruckPerformance(Connection con, int systemId, int clientId, ArrayList<Integer> rangeList, ArrayList<Integer> relativeRangeList, String customerData,
			String routeList, int offset) {
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		ArrayList<Integer> perList = null;
		routeList = routeList.substring(0, routeList.length() - 1);
		//customerData = customerData.replaceAll(",", "','");
		customerData = customerData.substring(0, customerData.length() - 1);
		try {
			// int TotalTruck = 0 ;
			int greater15kTruck = 0;
			int between15kTruck = 0;
			int lesser12kTruck = 0;
			double truck = 0;
			double greaterTruck = 0;
			double betweenTruck = 0;
			double lesserTruck = 0;
			String Statement = GeneralVerticalStatements.GET_TOTAL_COUNT_VEHICLE;
			Statement = Statement.replace("$", " and ROUTE_ID in (" + routeList + ")");
			Statement = Statement.replace("#", " and TRIP_CUSTOMER_ID in (" + customerData + ")");
			pstmt = con.prepareStatement(Statement);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, clientId);
			pstmt.setInt(3, offset);
			pstmt.setInt(4, offset);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				truck = rs.getInt("TotalVehicle");
			}

			Statement = GeneralVerticalStatements.GET_TOTAL_COUNT_GREATER_RANGE;
			Statement = Statement.replace("$", " and ROUTE_ID in (" + routeList + ")");
			Statement = Statement.replace("#", " and TRIP_CUSTOMER_ID in (" + customerData + ")");

			pstmt = con.prepareStatement(Statement);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, clientId);
			pstmt.setInt(3, offset);
			pstmt.setInt(4, offset);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				greaterTruck = rs.getInt("GreaterthanRange");
			}

			Statement = GeneralVerticalStatements.GET_TOTAL_COUNT_BETWEEN_RANGE;
			Statement = Statement.replace("$", " and ROUTE_ID in (" + routeList + ")");
			Statement = Statement.replace("#", " and TRIP_CUSTOMER_ID in (" + customerData + ")");
			pstmt = con.prepareStatement(Statement);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, clientId);
			pstmt.setInt(3, offset);
			pstmt.setInt(4, offset);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				betweenTruck = rs.getInt("IntheRange");
			}

			Statement = GeneralVerticalStatements.GET_TOTAL_COUNT_BELOW_RANGE;
			Statement = Statement.replace("$", " and ROUTE_ID in (" + routeList + ")");
			Statement = Statement.replace("#", " and TRIP_CUSTOMER_ID in (" + customerData + ")");
			pstmt = con.prepareStatement(Statement);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, clientId);
			pstmt.setInt(3, offset);
			pstmt.setInt(4, offset);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				lesserTruck = rs.getInt("lessthanRange");
			}
			if (truck != 0) {
				double gt = (greaterTruck / truck);
				greater15kTruck = (int) Math.round(gt * 100);

				double in = (betweenTruck / truck);
				between15kTruck = (int) Math.round(in * 100);

				double lt = (lesserTruck / truck);
				lesser12kTruck = (int) Math.round(lt * 100);
			}
			perList = new ArrayList<Integer>();
			perList.add(greater15kTruck);
			perList.add(between15kTruck);
			perList.add(lesser12kTruck);

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(null, pstmt, rs);
		}

		return perList;

	}

	public String getLegConcept(int systemId, int customerId) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String legConcept = "Y";

		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(GeneralVerticalStatements.GET_LEG_CONCEPT);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, customerId);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				legConcept = rs.getString("legConcept");
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {

			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return legConcept;
	}

	public String saveVehicleMaintenanceDetails(String vehicleNumber, String startDate, String remarks, Integer systemId, Integer userId, Integer clientId, Integer offset) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		PreparedStatement pstmt1 = null;
		ResultSet rs1 = null;
		String message = "";
		try {
			con = DBConnection.getConnectionToDB("AMS");

			pstmt1 = con.prepareStatement(GeneralVerticalStatements.VEHICLE_VALIDATION);
			pstmt1.setString(1, vehicleNumber);
			pstmt1.setString(2, sdfDB.format(sdf.parse(startDate)));
			pstmt1.setString(3, sdfDB.format(sdf.parse(startDate)));
			rs1 = pstmt1.executeQuery();
			if (rs1.next()) {
				message = "Vehicle Already In Trip";
			} else {

				pstmt = con.prepareStatement(GeneralVerticalStatements.INSERT_VEHICLES_FOR_MAINTENANCE);
				pstmt.setString(1, vehicleNumber);
				pstmt.setInt(2, offset);
				pstmt.setString(3, sdfDB.format(sdf.parse(startDate)));
				pstmt.setString(4, remarks);
				pstmt.setInt(5, systemId);
				pstmt.setInt(6, clientId);
				pstmt.setInt(7, userId);
				// pstmt.setInt(8, offset);
				int inserted = pstmt.executeUpdate();
				if (inserted > 0) {
					cf.updateVehicleStatus(con, vehicleNumber, 4, 0);
					message = "Saved Successfully";
				} else {
					message = "Vehicle Already In Trip";
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
			DBConnection.releaseConnectionToDB(null, pstmt1, rs1);
		}
		return message;
	}

	public JSONArray getVehicleshichAreNotOnTrip(Integer customerId, Integer systemId) {
		JSONArray JsonArray = null;
		JSONObject JsonObject = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			JsonArray = new JSONArray();
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(GeneralVerticalStatements.GET_VEHICLES_WHICH_ARE_NOT_ON_TRIP);
			// pstmt.setInt(1, customerId);

			pstmt.setInt(1, systemId);
			pstmt.setInt(2, customerId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				JsonObject = new JSONObject();
				JsonObject.put("vehicleNumber", rs.getString("REGISTRATION_NO"));
				JsonArray.put(JsonObject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return JsonArray;
	}

	public JSONArray getVehicleMaintenanceDetails(int systemId, int customerId, int offset) {
		JSONArray JsonArray = null;
		JSONObject jsonobject = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int count = 0;
		try {
			JsonArray = new JSONArray();
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(GeneralVerticalStatements.GET_VEHICLES_MAINTENANCE_DETAILS);
			pstmt.setInt(1, offset);
			pstmt.setInt(2, offset);
			pstmt.setInt(3, customerId);
			pstmt.setInt(4, systemId);
			// select ID,VEHICLE_NUMBER,START_DATE,REMARKS,END_DATE from
			// dbo.VEHICLE_MAINTENANCE_DETAILS WHERE CUSTOMER_ID = ?
			rs = pstmt.executeQuery();

			while (rs.next()) {
				count = count + 1;
				String id = rs.getString("ID");
				String vehicleNumber = rs.getString("VEHICLE_NUMBER").replace(" ", "^");
				String startDate = sdf.format(sdfDB.parse(rs.getString("START_DATE")));
				SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");

				startDate = startDate.replace(" ", "#");
				String remarks = rs.getString("REMARKS");
				remarks = remarks.replace(" ", "^");
				remarks = remarks.replace("\n", "").replace("\r", "");
				jsonobject = new JSONObject();
				jsonobject.put("slNo", count);
				jsonobject.put("idIndex", rs.getString("ID"));
				jsonobject.put("vehicleNumberIndex", rs.getString("VEHICLE_NUMBER"));
				jsonobject.put("startDateIndex", sdf.format(sdfDB.parse(rs.getString("START_DATE"))));
				jsonobject.put("reamrksIndex", rs.getString("REMARKS"));
				jsonobject.put("endDateIndex", sdf.format(sdfDB.parse(rs.getString("END_DATE"))).contains("1900") ? "" : sdf.format(sdfDB.parse(rs.getString("END_DATE"))));
				if (rs.getString("END_DATE").contains("1900")) {
					jsonobject.put("button", "<button onclick=openModal1('" + id + "','" + vehicleNumber + "','" + startDate + "','" + remarks
							+ "','+0+'); class='btn btn-success btn-sm text-center'>End Maintenance</button>");
				} else {

					jsonobject.put("button", "");
				}
				JsonArray.put(jsonobject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return JsonArray;
	}

	public String endVehicleMaintenanceDetails(String vehicleNumber, String id, Integer systemId, Integer userId, Integer clientId, String endDate, Integer offset) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String message = "";
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(GeneralVerticalStatements.CLOSE_VEHICLE_MAINTENANCE);

			pstmt.setInt(1, offset);
			pstmt.setString(2, sdfDB.format(sdf.parse(endDate)));
			pstmt.setInt(3, userId);

			pstmt.setString(4, id);
			pstmt.setString(5, vehicleNumber);

			pstmt.setInt(6, systemId);
			pstmt.setInt(7, clientId);

			int inserted = pstmt.executeUpdate();
			if (inserted > 0) {
				cf.updateVehicleStatus(con, vehicleNumber, 16, 0);
				message = "Saved Successfully";
			} else {
				message = "Error in Saving";
			}

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return message;
	}

	public JSONArray getLatLongsForRoute(String routeId, int systemId) {

		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		PreparedStatement pstmt1 = null;
		ResultSet rs1 = null;
		String type = "";
		ArrayList<ArrayList<String>> finalList = new ArrayList<ArrayList<String>>();
		ArrayList<String> list = new ArrayList<String>();
		ArrayList<String> list1 = new ArrayList<String>();
		try {
			con = DBConnection.getConnectionToDB("AMS");
			jsonArray = new JSONArray();
			jsonObject = new JSONObject();
			// if(!legIds.equals("")){
			pstmt = con.prepareStatement(GeneralVerticalStatements.GET_POINTS_FOR_ROUTE, ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
			pstmt.setString(1, routeId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				list = new ArrayList<String>();
				list.add(rs.getString("ROUTE_SEQUENCE"));
				list.add(rs.getString("LATITUDE"));
				list.add(rs.getString("LONGITUDE"));
				list.add(rs.getString("HUB_ID"));
				list.add(rs.getString("TYPE"));
				list.add(rs.getString("CHECKPOINT_SEQUENCE"));
				list.add(rs.getString("LEG_ID"));
				finalList.add(list);
			}

			int prevLegId = 0;

			int checkPtSeq = 0;
			for (int i = 0; i <= (finalList.size() - 1); i++) {
				int currLegId = Integer.parseInt(finalList.get(i).get(6));

				if (currLegId == prevLegId) {
					// checkPtSeq = i;
				} else {
					checkPtSeq = 0;
				}

				list1 = finalList.get(i);
				type = list1.get(4);

				if (i == 0) {
					type = "SOURCE";
				} else if (i == finalList.size() - 1) {
					type = "DESTINATION";
				} else {
					type = "CHECKPOINT";
				}

				jsonObject = new JSONObject();
				jsonObject.put("sequence", finalList.get(i).get(0));
				jsonObject.put("lat", finalList.get(i).get(1));
				jsonObject.put("lon", finalList.get(i).get(2));
				jsonObject.put("type", type);
				jsonObject.put("hubId", finalList.get(i).get(3));
				jsonArray.put(jsonObject);

				pstmt1 = con.prepareStatement(GeneralVerticalStatements.GET_DRAGPOINTS, ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
				pstmt1.setString(1, list1.get(6));
				pstmt1.setInt(2, checkPtSeq);
				rs1 = pstmt1.executeQuery();
				while (rs1.next()) {
					jsonObject = new JSONObject();
					jsonObject.put("sequence", rs1.getString("ROUTE_SEQUENCE"));
					jsonObject.put("lat", rs1.getString("LATITUDE"));
					jsonObject.put("lon", rs1.getString("LONGITUDE"));
					jsonObject.put("type", "DRAGPOINT");
					jsonObject.put("hubId", rs1.getString("HUB_ID"));
					jsonArray.put(jsonObject);

				}
				checkPtSeq = checkPtSeq + 1;

				rs1 = null;

				prevLegId = currLegId;
			}

			/*
			 * for(int i=1;i <= finalList.size();i++){ jsonObject = new
			 * JSONObject(); if(i==1){ type="SOURCE"; }else if
			 * (i==finalList.size()){ type="DESTINATION"; }else{
			 * type="CHECKPOINT"; } jsonObjectut("sequence",
			 * finalList.get(i-1).get(0)); jsonObject.put("lat",
			 * finalList.get(i-1).get(1)); jsonObject.put("lon",
			 * finalList.get(i-1).get(2)); jsonObject.put("type", type);
			 * jsonObject.put("hubId", finalList.get(i-1).get(3));
			 * jsonArray.put(jsonObject); }
			 */
			// }
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jsonArray;

	}

	public JSONArray getTwentyTwoFeetTruckDetails(int systemId, int clientId, String customerData, String routeList, int range, int comaparsion, String VehType, int offset) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		routeList = routeList.substring(0, routeList.length() - 1);
		customerData = customerData.replaceAll(",", "','");
		customerData = customerData.substring(0, customerData.length() - 3);
		JSONArray JsonArray = new JSONArray();
		ArrayList<Integer> rangeList = new ArrayList<Integer>();
		ArrayList<Integer> relativeRangeList = new ArrayList<Integer>();

		try {
			switch (range) {
			case 1:
				rangeList.add(7);
				rangeList.add(0);
				relativeRangeList.add(14);
				relativeRangeList.add(8);
				break;
			case 2:
				if (comaparsion == 1) {
					rangeList.add(30);
					rangeList.add(0);
					relativeRangeList.add(60);
					relativeRangeList.add(31);
				} else {
					rangeList.add(30);
					rangeList.add(0);
					relativeRangeList.add(395);
					relativeRangeList.add(366);

				}
				break;
			case 3:
				if (comaparsion == 1) {
					rangeList.add(90);
					rangeList.add(0);
					relativeRangeList.add(180);
					relativeRangeList.add(91);
				} else {
					rangeList.add(90);
					rangeList.add(0);
					relativeRangeList.add(455);
					relativeRangeList.add(366);
				}
				break;
			case 4:
				rangeList.add(365);
				rangeList.add(0);
				relativeRangeList.add(730);
				relativeRangeList.add(366);
				break;
			default:
				break;
			}
			con = DBConnection.getConnectionToDB("AMS");
			JSONObject JsonObject = new JSONObject();
			JsonArray = new JSONArray();
			JsonObject = new JSONObject();
			String Statment = GeneralVerticalStatements.GET_VEHICLE_TYPE_MILEAGE;
			pstmt = con.prepareStatement(Statment.replaceAll("_#", "_" + systemId));
			// pstmt.setInt(1, clientId);
			// pstmt.setInt(2, rangeList.get(0));
			// pstmt.setInt(3, rangeList.get(1));
			// pstmt.setInt(4, clientId);
			// pstmt.setInt(5, rangeList.get(0));
			// pstmt.setInt(6, rangeList.get(1));

			pstmt.setInt(1, clientId);
			pstmt.setString(2, VehType);
			pstmt.setInt(3, offset);
			pstmt.setInt(4, rangeList.get(0));
			pstmt.setInt(5, offset);
			pstmt.setInt(6, rangeList.get(1));
			pstmt.setInt(7, clientId);
			pstmt.setString(8, VehType);
			pstmt.setInt(9, offset);
			pstmt.setInt(10, rangeList.get(0));
			pstmt.setInt(11, offset);
			pstmt.setInt(12, rangeList.get(1));
			rs = pstmt.executeQuery();
			// System.out.println(Statment);
			while (rs.next()) {
				JsonObject = new JSONObject();
				JsonObject.put("Model", rs.getString("ModelName"));
				JsonObject.put("Mileage", df1.format(rs.getDouble("Mileage")));
				JsonArray.put(JsonObject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return JsonArray;

	}

	public ArrayList<Double> GET_SMART_TRUCK_DETAILS(Connection con, int systemId, int clientId, ArrayList<Integer> rangeList, 
			ArrayList<Integer> relativeRangeList, String customerData, String routeList, int offset) {
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		ArrayList<Double> perList = null;
		routeList = routeList.substring(0, routeList.length() - 1);
		//customerData = customerData.replaceAll(",", "','");
		customerData = customerData.substring(0, customerData.length() - 1);
		try {
			String Stamt = GeneralVerticalStatements.GET_SMART_TRUCK_DETAILS;

			Stamt = Stamt.replace("$", " and ROUTE_ID in (" + routeList + ")");
			Stamt = Stamt.replace("#", " and TRIP_CUSTOMER_ID in (" + customerData + ")");
			pstmt = con.prepareStatement(Stamt);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, clientId);
			pstmt.setInt(3, offset);
			pstmt.setInt(4, rangeList.get(0));
			pstmt.setInt(5, offset);
			pstmt.setInt(6, rangeList.get(1));
			pstmt.setInt(7, systemId);
			pstmt.setInt(8, clientId);
			pstmt.setInt(9, offset);
			pstmt.setInt(10, rangeList.get(0));
			pstmt.setInt(11, offset);
			pstmt.setInt(12, rangeList.get(1));
			pstmt.setInt(13, systemId);
			pstmt.setInt(14, clientId);
			pstmt.setInt(15, offset);
			pstmt.setInt(16, relativeRangeList.get(0));
			pstmt.setInt(17, offset);
			pstmt.setInt(18, relativeRangeList.get(1));
			pstmt.setInt(19, systemId);
			pstmt.setInt(20, clientId);
			pstmt.setInt(21, offset);
			pstmt.setInt(22, relativeRangeList.get(0));
			pstmt.setInt(23, offset);
			pstmt.setInt(24, relativeRangeList.get(1));

			rs = pstmt.executeQuery();
			double smartTruckKm = 0;
			double relativesmartTruckKm = 0;
			if (rs.next()) {
				double totalTruck = rs.getDouble("TOTAL_TRUCK");
				double totalDistance = rs.getDouble("ON_TRIP_KM");
				double RtotalTruck = rs.getDouble("TOTAL_TRUCK_REL");
				double RtotalDistance = rs.getDouble("ON_TRIP_KM_REL");
				DecimalFormat df = new DecimalFormat("#.##");
				if (totalTruck != 0) {
					smartTruckKm = (totalDistance / totalTruck);
					smartTruckKm = Double.parseDouble(df.format(smartTruckKm));
				} else {
					smartTruckKm = 0;
				}
				if (RtotalTruck != 0) {
					relativesmartTruckKm = (RtotalDistance / RtotalTruck);
					relativesmartTruckKm = Double.parseDouble(df.format(relativesmartTruckKm));
				} else {
					relativesmartTruckKm = 0;
				}
				perList = new ArrayList<Double>();
				perList.add(smartTruckKm);
				perList.add(relativesmartTruckKm);

			}

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(null, pstmt, rs);
		}

		return perList;

	}

	public ArrayList<Double> GET_SMART_TRUCKER_TRUCK_DETAILS(Connection con, int systemId, int clientId, ArrayList<Integer> rangeList, ArrayList<Integer> relativeRangeList, String customerData,
			String routeList) {
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		routeList = routeList.substring(0, routeList.length() - 1);
		customerData = customerData.replaceAll(",", "','");
		customerData = customerData.substring(0, customerData.length() - 3);
		ArrayList<Double> perList = null;
		try {
			double SmartTrucker = 0;
			double RelativeSmartTrucker = 0;
			String Statement = GeneralVerticalStatements.GET_SMART_TRUCKER_TRUCK_DETAILS;
			pstmt = con.prepareStatement(Statement);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, clientId);
			pstmt.setInt(3, systemId);
			pstmt.setInt(4, systemId);
			pstmt.setInt(5, clientId);
			pstmt.setInt(6, relativeRangeList.get(1));
			pstmt.setInt(7, systemId);
			pstmt.setInt(8, relativeRangeList.get(1));
			rs = pstmt.executeQuery();
			if (rs.next()) {
				double Driver = rs.getDouble("Driver");
				int Vehicle = rs.getInt("Vehicle");
				double RelDriver = rs.getDouble("RelDriver");
				int RelVehicle = rs.getInt("RelVehicle");
				DecimalFormat df = new DecimalFormat("#.##");

				if (Vehicle != 0) {
					double smartTrucker = (Driver / Vehicle);
					SmartTrucker = Double.parseDouble(df.format(smartTrucker));
				} else {
					SmartTrucker = 0;
				}
				if (RelVehicle != 0) {
					double relativeSmartTrucker = (RelDriver / RelVehicle);
					RelativeSmartTrucker = Double.parseDouble(df.format(relativeSmartTrucker));
				} else {
					RelativeSmartTrucker = 0;
				}
				perList = new ArrayList<Double>();
				perList.add(SmartTrucker);
				perList.add(RelativeSmartTrucker);
			}

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(null, pstmt, rs);
		}

		return perList;

	}

	public ArrayList<Integer> GET_SMART_TOP_TRUCKER_TRUCK_DETAILS(Connection con, int systemId, int clientId, ArrayList<Integer> rangeList, ArrayList<Integer> relativeRangeList, String customerData,
			String routeList, int offset) {
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		routeList = routeList.substring(0, routeList.length() - 1);
		//customerData = customerData.replaceAll(",", "','");
		customerData = customerData.substring(0, customerData.length() - 1);
		ArrayList<Integer> perList = null;
		try {
			int TopSmartTrucker = 0;
			int RelativeTopSmartTrucker = 0;
			double totalDriver = 0;
			double TopPerfomerDriver = 0;
			double reltotalDriver = 0;
			double relTopPerfomerDriver = 0;
			String Statement = GeneralVerticalStatements.GET_COUNT_OF_DRIVERS_PERFORMACE;
			Statement = Statement.replace("$", " and ROUTE_ID in (" + routeList + ")");
			Statement = Statement.replace("#", " and TRIP_CUSTOMER_ID in (" + customerData + ")");

			pstmt = con.prepareStatement(Statement);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, clientId);
			pstmt.setInt(3, offset);
			pstmt.setInt(4, rangeList.get(0));
			pstmt.setInt(5, offset);
			pstmt.setInt(6, rangeList.get(1));
			rs = pstmt.executeQuery();
			if (rs.next()) {
				totalDriver = rs.getInt("TOTAL_DRIVER");
			}

			Statement = GeneralVerticalStatements.GET_TOP_DRIVER_PERFORMACE;
			Statement = Statement.replace("$", " and tt.ROUTE_ID in (" + routeList + ")");
			Statement = Statement.replace("#", " and TRIP_CUSTOMER_ID in (" + customerData + ")");

			pstmt = con.prepareStatement(Statement);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, clientId);
			pstmt.setInt(3, offset);
			pstmt.setInt(4, rangeList.get(0));
			pstmt.setInt(5, offset);
			pstmt.setInt(6, rangeList.get(1));
			rs = pstmt.executeQuery();
			if (rs.next()) {
				TopPerfomerDriver = rs.getInt("TOP_PERFORMER");
			}

			Statement = GeneralVerticalStatements.GET_COUNT_OF_REL_DRIVERS_PERFORMACE;
			Statement = Statement.replace("$", " and ROUTE_ID in (" + routeList + ")");
			Statement = Statement.replace("#", " and TRIP_CUSTOMER_ID in (" + customerData + ")");
			pstmt = con.prepareStatement(Statement);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, clientId);
			pstmt.setInt(3, offset);
			pstmt.setInt(4, relativeRangeList.get(0));
			pstmt.setInt(5, offset);
			pstmt.setInt(6, relativeRangeList.get(1));
			rs = pstmt.executeQuery();
			if (rs.next()) {
				reltotalDriver = rs.getInt("REL_TOTAL_DRIVER");
			}

			Statement = GeneralVerticalStatements.GET_TOP_DRIVER_REL_PERFORMACE;
			Statement = Statement.replace("$", " and tt.ROUTE_ID in (" + routeList + ")");
			Statement = Statement.replace("#", " and TRIP_CUSTOMER_ID in (" + customerData + ")");
			pstmt = con.prepareStatement(Statement);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, clientId);
			pstmt.setInt(3, offset);
			pstmt.setInt(4, relativeRangeList.get(0));
			pstmt.setInt(5, offset);
			pstmt.setInt(6, relativeRangeList.get(1));
			rs = pstmt.executeQuery();
			if (rs.next()) {
				relTopPerfomerDriver = rs.getInt("REL_TOP_PERFORMER");
			}
			if (totalDriver != 0) {
				double topSmartTrucker = (TopPerfomerDriver / totalDriver);
				TopSmartTrucker = (int) Math.round(topSmartTrucker * 100);
			}
			if (reltotalDriver != 0) {
				double relativeTopSmartTrucker = (relTopPerfomerDriver / reltotalDriver);
				RelativeTopSmartTrucker = (int) Math.round(relativeTopSmartTrucker * 100);
			}
			perList = new ArrayList<Integer>();
			perList.add(TopSmartTrucker);
			perList.add(RelativeTopSmartTrucker);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(null, pstmt, rs);
		}
		return perList;

	}

	public JSONArray getDriverCountDetails(int systemId, int clientId, int offset, String startDate, String endDate, 
			int driverId, String hubList, String zone) {
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonobject = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		PreparedStatement pstmt1 = null;
		ResultSet rs1 = null;
		int count = 0;
		JSONArray legDetailsArray = null;
		JSONObject legDetailsObject = null;
		try {
			con = DBConnection.getConnectionToDB("AMS");

			if(driverId != 0){
				pstmt = con.prepareStatement(GeneralVerticalStatements.GET_DRIVER_COUNT_DETAILS.replace("#", " and DRIVER_ID="+driverId));
			}else{
				pstmt = con.prepareStatement(GeneralVerticalStatements.GET_DRIVER_COUNT_DETAILS.replace("#", " and DRIVER_ID in (select Driver_id" +
						" from AMS.dbo.Driver_Master d where Client_id="+clientId+""+getHubQueryAppender(hubList, clientId, zone)+")"));
			}
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, clientId);
			pstmt.setInt(3, offset);
			pstmt.setString(4, startDate);
			pstmt.setInt(5, offset);
			pstmt.setString(6, endDate);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				int legCount = 0;
				count++;
				jsonobject = new JSONObject();

				jsonobject.put("slNoIndex", count);
				jsonobject.put("empIdCIndex", rs.getString("EMP_ID"));
				jsonobject.put("nameCIndex", rs.getString("NAME"));
				jsonobject.put("NoofTripsCIndex", rs.getDouble("NO_OF_TRIPS"));
				jsonobject.put("harshAccCountIndex", df1.format(rs.getDouble("HA_COUNT")));
				jsonobject.put("harshBrakingCountIndex", df1.format(rs.getDouble("HB_COUNT")));
				jsonobject.put("harshCorneringCountIndex", df1.format(rs.getDouble("HC_COUNT")));
				jsonobject.put("overspeedingCountIndex", df1.format(rs.getDouble("OVERSPEED_COUNT")));
				jsonobject.put("unscheduledStoppageCountIndex", df1.format(rs.getFloat("UNSCHLD_STOP_DUR")));
				jsonobject.put("excessiveIdlingCountIndex", df1.format(rs.getFloat("EXCESS_IDLE_DUR")));
				jsonobject.put("greenBandSpeedCountIndex", df1.format(rs.getFloat("GREEN_BAND_SPEED_DUR")));
				jsonobject.put("erraticSpeedingCountIndex", 0);
				jsonobject.put("freewheelingCountIndex", rs.getString("FREE_WHEEL_DUR")); // Do not use df1.format
				jsonobject.put("greenBandRpmCountIndex", rs.getString("GREEN_BAND_RPM_DUR")); // Do not use
				jsonobject.put("lowRPMCountIndex", rs.getString("LOW_RPM_DUR")); // Do
				jsonobject.put("highRPMCountIndex", rs.getString("HIGH_RPM_DUR")); // Do not use df1.format as
				jsonobject.put("overRevvingCountIndex", df1.format(rs.getDouble("OVER_REVV_COUNT")));
				jsonobject.put("driverIdCountIndex", df1.format(rs.getInt("DRIVER_ID")));
				jsonobject.put("mileageCountIndex", rs.getString("MILEAGE")); // Do
				jsonobject.put("obdMileageCountIndex", rs.getString("OBD_MILEAGE")); // Do not use df1.format as

				String Query = " select td.ORDER_ID,isnull(LEG_NAME,'NA') as LEG_NAME ,isnull(HA_COUNT,0) as HA_COUNT,isnull(HB_COUNT,0) as HB_COUNT,isnull(HC_COUNT,0) as HC_COUNT,"
						+ " isnull(OVERSPEED_COUNT,0) as OVERSPEED_COUNT,isnull(OVER_REVV_COUNT,0) as OVER_REVV_COUNT,isnull(UNSCHLD_STOP_DUR,0) as UNSCHLD_STOP_DUR,"
						+ " isnull(EXCESS_IDLE_DUR,0) as EXCESS_IDLE_DUR,isnull(GREEN_BAND_SPEED_DUR,0) as GREEN_BAND_SPEED_DUR,"
						+ " isnull(cast(cast (CASE WHEN (LOW_RPM_DUR>0 or HIGH_RPM_DUR>0 or GREEN_BAND_RPM_DUR>0) THEN GREEN_BAND_RPM_DUR ELSE NULL END as numeric(18,2)) as varchar(10)),'NA')  as GREEN_BAND_RPM_DUR,"
						+ " isnull(cast(cast (CASE WHEN (LOW_RPM_DUR>0 or HIGH_RPM_DUR>0 or GREEN_BAND_RPM_DUR>0) THEN LOW_RPM_DUR ELSE NULL END as numeric(18,2)) as varchar(10)),'NA')  as LOW_RPM_DUR,"
						+ " isnull(cast(cast (CASE WHEN (LOW_RPM_DUR>0 or HIGH_RPM_DUR>0 or GREEN_BAND_RPM_DUR>0) THEN HIGH_RPM_DUR ELSE NULL END as numeric(18,2)) as varchar(10)),'NA')  as HIGH_RPM_DUR,"
						+ " isnull(cast(cast (CASE WHEN (LOW_RPM_DUR>0 or HIGH_RPM_DUR>0 or GREEN_BAND_RPM_DUR>0) THEN FREE_WHEEL_DUR ELSE NULL END as numeric(18,2)) as varchar(10)),'NA')  as FREE_WHEEL_DUR,"
						+ " isnull(cast(cast (CASE WHEN (d.MILEAGE>0 and d.MILEAGE < 10) THEN d.MILEAGE ELSE NULL END as numeric(18,2)) as varchar(10)),'NA')  as MILEAGE, "
						+ " isnull(cast(cast (CASE WHEN (d.OBD_MILEAGE>0 and d.OBD_MILEAGE < 10) THEN d.OBD_MILEAGE ELSE NULL END as numeric(18,2)) as varchar(10)),'NA')  as OBD_MILEAGE "
						+ " from AMS.dbo.TRIP_DRIVER_DETAILS d " 
						+ " left outer join AMS.dbo.LEG_MASTER lm on lm.ID=d.LEG_ID " 
						+ " inner join AMS.dbo.TRACK_TRIP_DETAILS td on td.TRIP_ID=d.TRIP_ID "
						+ " where DRIVER_ID=? and d.SYSTEM_ID=? and d.CUSTOMER_ID=? and  END_DATE between dateadd(mi,-?,?) and dateadd(mi,-?,?) "
						+ " group by td.ORDER_ID,LEG_NAME,HA_COUNT,HB_COUNT,HC_COUNT,OVERSPEED_COUNT,OVER_REVV_COUNT,UNSCHLD_STOP_DUR,EXCESS_IDLE_DUR,"
						+ " GREEN_BAND_SPEED_DUR,GREEN_BAND_RPM_DUR,LOW_RPM_DUR,HIGH_RPM_DUR,FREE_WHEEL_DUR,d.MILEAGE,d.OBD_MILEAGE,td.TRIP_ID order by td.TRIP_ID ";

				try {
					pstmt1 = con.prepareStatement(Query);
					pstmt1.setInt(1, rs.getInt("DRIVER_ID"));
					pstmt1.setInt(2, systemId);
					pstmt1.setInt(3, clientId);
					pstmt1.setInt(4, offset);
					pstmt1.setString(5, startDate);
					pstmt1.setInt(6, offset);
					pstmt1.setString(7, endDate);
					rs1 = pstmt1.executeQuery();

					legDetailsArray = new JSONArray();
					while (rs1.next()) {
						legCount++;
						legDetailsObject = new JSONObject();
						legDetailsObject.put("slNo", legCount);
						legDetailsObject.put("legName", rs1.getString("LEG_NAME"));
						legDetailsObject.put("tripName", rs1.getString("ORDER_ID"));
						legDetailsObject.put("haCount", rs1.getDouble("HA_COUNT"));
						legDetailsObject.put("hbCount", rs1.getDouble("HB_COUNT"));
						legDetailsObject.put("hcCount", rs1.getDouble("HC_COUNT"));
						legDetailsObject.put("overspeedingCount", rs1.getDouble("OVERSPEED_COUNT"));
						legDetailsObject.put("freewheelingCount", rs1.getString("FREE_WHEEL_DUR")); // Do not use
						legDetailsObject.put("unscheduledStoppageCount", rs1.getString("UNSCHLD_STOP_DUR"));
						legDetailsObject.put("excessiveIdlingCount", rs1.getString("EXCESS_IDLE_DUR"));
						legDetailsObject.put("greenBandSpeedCount", rs1.getString("GREEN_BAND_SPEED_DUR"));
						legDetailsObject.put("erraticSpeedingCount", 0);
						legDetailsObject.put("greenBandRpmCount", rs1.getString("GREEN_BAND_RPM_DUR")); // Do not use
						legDetailsObject.put("lowRPMCount", rs1.getString("LOW_RPM_DUR")); // Do not use
						legDetailsObject.put("highRPMCount", rs1.getString("HIGH_RPM_DUR")); // Do not use
						legDetailsObject.put("overRevvingCount", rs1.getDouble("OVER_REVV_COUNT"));
						legDetailsObject.put("mileage", rs1.getString("MILEAGE")); // Do not use df1.format
						legDetailsObject.put("obdMileage", rs1.getString("OBD_MILEAGE")); // Do not use
						legDetailsArray.put(legDetailsObject);
					}
					jsonobject.put("legdetails", legDetailsArray);
				} catch (Exception e) {
					e.printStackTrace();
				}
				jsonArray.put(jsonobject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
			DBConnection.releaseConnectionToDB(null, pstmt1, rs1);
		}
		return jsonArray;
	}

	public ArrayList<Integer> getSmartTruckHealthDBDetailsFuel(Connection con, int systemId, int clientId, String makeList, String vehicleList, String truckTypeList, String replaceString) {
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		ArrayList<Integer> alert = null;
		String sql = null;
		try {
			alert = new ArrayList<Integer>();

			String array1 = (makeList.substring(0, makeList.length() - 1));
			String array2 = (vehicleList.substring(0, vehicleList.length() - 1));
			String array3 = (truckTypeList.substring(0, truckTypeList.length() - 1));

			// String newMakeList
			// ="'"+array1.toString().replace("[","").replace("]",
			// "").replace(" ","").replace(",","','")+"'";
			String newMakeList = "'" + array1.toString().replace(",", "','") + "'";

			// String newVehicleList
			// ="'"+array2.toString().replace("[","").replace("]",
			// "").replace(" ","").replace(",","','")+"'";
			String newVehicleList = "'" + array2.toString().replace(",", "','") + "'";

			// String newTruckList
			// ="'"+array3.toString().replace("[","").replace("]",
			// "").replace(" ","").replace(",","','")+"'";
			String newTruckList = "'" + array3.toString().replace(",", "','") + "'";
			con = DBConnection.getConnectionToDB("AMS");

			sql = GeneralVerticalStatements.GET_LOW_FUEL_ALERT_COUNT;

			sql = sql + " and b.Model in (" + newMakeList + ")";
			sql = sql + " and REGISTRATION_NO in (" + newVehicleList + ")";

			sql = sql + " and VehicleType in (" + newTruckList + ")";

			// if(!OEMMakeId.equalsIgnoreCase("ALL"))
			// {
			// sql=sql+" and b.Model="+OEMMakeId;
			// }
			// if(!vehicleId.equalsIgnoreCase("ALL"))
			// {
			// sql=sql+" and REGISTRATION_NO='"+vehicleId+"'";
			// }
			// if(!typeId.equalsIgnoreCase("ALL"))
			// {
			// sql=sql+" and VehicleType='"+typeId+"'";
			// }
			sql = sql.replace("#", replaceString);
			pstmt = con.prepareStatement(sql);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, clientId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				alert.add(rs.getInt("LowFuelAlert"));
			}

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(null, pstmt, rs);
		}
		return alert;
	}

	public String getLegDetaisReport(int systemId, int clientId, int offset, String groupId, String unit, int userId, String custId, String routeId, String tripStatus, String startDateRange,
			String endDateRange, String custType, String tripType, String zone) {

		Connection connection = null;
		PreparedStatement pstmt = null, pstmt1 = null;
		ResultSet rs = null, rs1 = null;

		LegDetailsBean legBean = null;

		int count = 0;
		ArrayList<LegDetailsBean> legBeanDetails;
		legBean = new LegDetailsBean();

		String condition = "";
		double distance = 0;
		double distanceNext = 0;
		String endDate = "";
		String tripStr = "";
		Properties prop = ApplicationListener.prop;
		int allowedDetention = Integer.parseInt(prop.getProperty("AllowedDetention"));
		String loadingD = "";
		String unloadingD = "";
		String custD = "";
		String completePath = "";
		String Stawrtatd = "";
		try {
			// jsonArray = new JSONArray();
			legBeanDetails = new ArrayList<LegDetailsBean>();
			connection = DBConnection.getConnectionToDB("AMS");

			String groupBy = " group by CUSTOMER_REF_ID,NEXT_POINT_DISTANCE,AVG_SPEED,STOPPAGE_DURATION,td.ROUTE_ID,td.TRIP_ID,td.SHIPMENT_ID,td.ASSET_NUMBER,td.CUSTOMER_NAME,"
					+ "	 td.DRIVER_NAME,td.DRIVER_NUMBER,gps.LOCATION,NEXT_POINT,td.TRIP_START_TIME,td.ACTUAL_TRIP_START_TIME,td.NEXT_POINT_ETA,td.DESTINATION_ETA,ds.PLANNED_ARR_DATETIME,DEST_ARR_TIME_ON_ATD,"
					+ "	 td.ACTUAL_DISTANCE,ds1.NAME,ds.NAME,td.STATUS,td.TRIP_STATUS,td.DELAY,ACTUAL_TRIP_END_TIME,ds.PLANNED_ARR_DATETIME,DESTINATION_ETA,ACTUAL_TRIP_START_TIME,ACT_SRC_ARR_DATETIME,"
					+ "	 ORDER_ID,vm.ModelName,td.ROUTE_NAME,ds1.PLANNED_ARR_DATETIME,ds1.ACT_ARR_DATETIME,ds.ACT_ARR_DATETIME,td.ACTUAL_DISTANCE,ds.ACT_DEP_DATETIME,"
					+ "	 td.FUEL_CONSUMED,td.MILEAGE,td.OBD_MILEAGE,td.NEXT_LEG,td.NEXT_LEG_ETA,ll1.HUB_CITY,ll1.HUB_STATE,ll0.HUB_CITY,ll0.HUB_STATE,u.Firstname,u.Lastname,vm.VehType,REMARKS,"
					+ " td.PRODUCT_LINE,td.TRIP_CATEGORY,trd.ROUTE_KEY,UNSCHEDULED_STOP_DUR,PLANNED_DURATION,ds1.DISTANCE_FLAG,ds1.DETENTION_TIME,ds.DETENTION_TIME,td.END_LOCATION,RED_DUR_T1,RED_DUR_T2,RED_DUR_T3,DISTANCE_TRAVELLED,  "
					+ " td.INSERTED_TIME,c.VehicleType,ACTUAL_DURATION,trd.TAT, rd.TRAVEL_TIME,td.TRIP_CUSTOMER_TYPE,gps.DRIVER_NAME,gps.DRIVER_MOBILE,custd.CUSTOMER_REFERENCE_ID, gps.GMT";

			String eventStrHubDetention = " and td.TRIP_ID in (select distinct TRIP_ID from DES_TRIP_DETAILS where  ACT_ARR_DATETIME is not null and SEQUENCE not in (0,100) "
					+ " and datediff(mi,ACT_ARR_DATETIME,isnull(ACT_DEP_DATETIME,getutcdate()))>isnull(DETENTION_TIME,0))";
			String eventQueryStoppage = " and td.TRIP_ID in (select distinct TRIP_ID from TRIP_EVENT_DETAILS where ALERT_TYPE=1) and gps.CATEGORY='stoppage' ";
			String eventQueryroutedEviation = "and td.TRIP_ID in (select distinct TRIP_ID from TRIP_EVENT_DETAILS a where ALERT_TYPE=5 and TRIP_ID not in (select TRIP_ID from TRIP_EVENT_DETAILS b where b.TRIP_ID=td.TRIP_ID and ALERT_TYPE=134 and b.GMT>a.GMT))";

			if (groupId.equals("0")) {
				condition = "and td.STATUS='OPEN'";
			} else if (groupId.equals("1")) {
				condition = "and td.TRIP_START_TIME between dateadd(dd,-2,getutcdate()) and getutcdate()";
			} else if (groupId.equals("2")) {
				condition = "and td.TRIP_START_TIME between dateadd(dd,-7,getutcdate()) and getutcdate()";
			} else if (groupId.equals("3")) {
				condition = "and td.TRIP_START_TIME between dateadd(dd,-15,getutcdate()) and getutcdate()";
			} else if (groupId.equals("4")) {
				condition = "and td.TRIP_START_TIME between dateadd(dd,-30,getutcdate()) and getutcdate()";
			} else if (groupId.equals("5")) {
				condition = "and td.TRIP_START_TIME between dateadd(mi,-330,'" + startDateRange + " 00:00:00') and dateadd(mi,-330,'" + endDateRange + " 23:59:59')";
			}

			if (tripStatus.equalsIgnoreCase("enrouteId")) {
				tripStatus = "ENROUTE PLACEMENT%";
				tripStr = "and TRIP_STATUS like '" + tripStatus + "'";
			} else if (tripStatus.equalsIgnoreCase("onTimeId")) {
				tripStatus = "ON TIME";
				tripStr = "and TRIP_STATUS = '" + tripStatus + "'";
			} else if (tripStatus.equalsIgnoreCase("delayedless1")) {
				tripStatus = "DELAYED";
				tripStr = "and TRIP_STATUS = '" + tripStatus + "'" + "and isnull(DELAY,0)<60";
			} else if (tripStatus.equalsIgnoreCase("delayedgreater1")) {
				tripStatus = "DELAYED";
				tripStr = "and TRIP_STATUS = '" + tripStatus + "'" + "and isnull(DELAY,0)>60";
			} else if (tripStatus.equalsIgnoreCase("enrouteId-Ontime")) {
				tripStatus = "ENROUTE PLACEMENT ON TIME";
				tripStr = "and TRIP_STATUS = '" + tripStatus + "'";
			} else if (tripStatus.equalsIgnoreCase("enrouteId-delay")) {
				tripStatus = "ENROUTE PLACEMENT DELAYED";
				tripStr = "and TRIP_STATUS = '" + tripStatus + "'";
			} else if (tripStatus.equalsIgnoreCase("loading-detention")) {
				tripStatus = "LOADING DETENTION";
				tripStr = "and TRIP_STATUS = '" + tripStatus + "'";
			} else if (tripStatus.equalsIgnoreCase("unloading-detention")) {
				tripStatus = "UNLOADING DETENTION";
				tripStr = "and TRIP_STATUS = '" + tripStatus + "'";
			}// EVENT QUERIES
			// ONTIME
			else if (tripStatus.equalsIgnoreCase("onTimeId-hubhetention")) {
				tripStatus = "ON TIME";
				tripStr = " and TRIP_STATUS = '" + tripStatus + "'" + eventStrHubDetention;
			} else if (tripStatus.equalsIgnoreCase("onTimeId-stoppage")) {
				tripStatus = "ON TIME";
				tripStr = " and TRIP_STATUS = '" + tripStatus + "'" + eventQueryStoppage;
			} else if (tripStatus.equalsIgnoreCase("onTimeId-deviation")) {
				tripStatus = "ON TIME";
				tripStr = " and TRIP_STATUS = '" + tripStatus + "'" + eventQueryroutedEviation;
			}
			// DELAYED<1HR
			else if (tripStatus.equalsIgnoreCase("delayedless1-detention")) {
				tripStatus = "DELAYED";
				tripStr = " and TRIP_STATUS = '" + tripStatus + "'" + "and isnull(DELAY,0)<60" + eventStrHubDetention;
			} else if (tripStatus.equalsIgnoreCase("delayedless1-stoppage")) {
				tripStatus = "DELAYED";
				tripStr = " and TRIP_STATUS = '" + tripStatus + "'" + "and isnull(DELAY,0)<60" + eventQueryStoppage;
			} else if (tripStatus.equalsIgnoreCase("delayedless1-deviation")) {
				tripStatus = "DELAYED";
				tripStr = " and TRIP_STATUS = '" + tripStatus + "'" + "and isnull(DELAY,0)<60" + eventQueryroutedEviation;
			}
			// DELAYED>1HR
			else if (tripStatus.equalsIgnoreCase("delayedgreater1-detention")) {
				tripStatus = "DELAYED";
				tripStr = " and TRIP_STATUS = '" + tripStatus + "'" + "and isnull(DELAY,0)>60" + eventStrHubDetention;
			} else if (tripStatus.equalsIgnoreCase("delayedgreater1-stoppage")) {
				tripStatus = "DELAYED";
				tripStr = " and TRIP_STATUS = '" + tripStatus + "'" + "and isnull(DELAY,0)>60" + eventQueryStoppage;
			} else if (tripStatus.equalsIgnoreCase("delayedgreater1-deviation")) {
				tripStatus = "DELAYED";
				tripStr = " and TRIP_STATUS = '" + tripStatus + "'" + "and isnull(DELAY,0)>60" + eventQueryroutedEviation;
			} else {
				// tripStr="and td.TRIP_STATUS <> 'NEW'";
				tripStr = "";
			}

			String stmt = GeneralVerticalStatements.GET_TRIP_SUMMARY_DETAILS_DHL.replace("&", condition).concat(tripStr).replaceAll("330", "" + offset).replaceAll("AMS.dbo.LOCATION",
					"AMS.dbo.LOCATION_ZONE_" + zone);
			if (routeId.equals("ALL")) {
				stmt = stmt.replace("#", "");
			} else {
				routeId = routeId.substring(0, routeId.length() - 1);
				stmt = stmt.replace("#", "and td.ROUTE_ID in (" + routeId + ")");
			}
			// if(custName.equals("ALL")){
			// stmt = stmt.replace("$", "");
			// }else{
			// stmt=stmt.replace("$","and CUSTOMER_NAME='"+custName+"'");
			// }
			if (custId.equals("ALL")) {
				stmt = stmt.replace("$", "");
			} else {
				custId = custId.substring(0, custId.length() - 1);
				stmt = stmt.replace("$", "and TRIP_CUSTOMER_ID in (" + custId + ")");
			}
			if (custType.equals("ALL")) {
				stmt = stmt.replace("custTypeCondition", "");
			} else {
				custType = custType.substring(0, custType.length() - 1);
				stmt = stmt.replace("custTypeCondition", "and TRIP_CUSTOMER_TYPE in (" + custType + ")");
			}
			if (tripType.equals("ALL")) {
				stmt = stmt.replace("tripTypeCondition", "");
			} else {
				tripType = tripType.substring(0, tripType.length() - 1);
				stmt = stmt.replace("tripTypeCondition", "and PRODUCT_LINE in (" + tripType + ")");
			}
			pstmt = connection.prepareStatement(stmt + " " + groupBy + " order by td.TRIP_ID desc");
			pstmt.setInt(1, offset);
			pstmt.setInt(2, offset);
			pstmt.setInt(3, offset);
			pstmt.setInt(4, offset);
			pstmt.setInt(5, offset);
			pstmt.setInt(6, offset);
			pstmt.setInt(7, offset);
			pstmt.setInt(8, allowedDetention);
			pstmt.setInt(9, offset);
			pstmt.setInt(10, offset);
			pstmt.setInt(11, offset);
			// pstmt.setInt(12, allowedDetention);
			pstmt.setInt(12, offset);
			pstmt.setInt(13, offset);
			pstmt.setInt(14, offset);
			pstmt.setInt(15, offset);
			pstmt.setInt(16, systemId);
			pstmt.setInt(17, clientId);
			rs = pstmt.executeQuery();
			while (rs.next()) {

				endDate = "";
				count++;
				String STD = "";
				if (!rs.getString("STD").contains("1900")) {
					STD = mmddyyy.format(sdfDB.parse(rs.getString("STD")));
				}
				String ATD = "";
				if (!rs.getString("ATD").contains("1900")) {
					ATD = mmddyyy.format(sdfDB.parse(rs.getString("ATD")));
				}
				String ETHA = "";
				if (!rs.getString("ETHA").contains("1900")) {
					ETHA = mmddyyy.format(sdfDB.parse(rs.getString("ETHA")));
				}
				String ETA = "";
				if (!rs.getString("ETA").contains("1900")) {
					ETA = mmddyyy.format(sdfDB.parse(rs.getString("ETA")));
				}
				String STA = "";
				if (!rs.getString("STA").contains("1900")) {
					STA = mmddyyy.format(sdfDB.parse(rs.getString("STA")));
				}

				String ATP = "";
				if (!rs.getString("ATP").contains("1900")) {
					ATP = mmddyyy.format(sdfDB.parse(rs.getString("ATP")));
				}

				String STP = "";
				if (!rs.getString("STP").contains("1900")) {
					STP = mmddyyy.format(sdfDB.parse(rs.getString("STP")));
				}

				String ATA = "";
				if (!rs.getString("ATA").contains("1900")) {
					ATA = mmddyyy.format(sdfDB.parse(rs.getString("ATA")));
				}
				int tripNO = Integer.parseInt(rs.getString("TRIP_NO"));

				legBean = new LegDetailsBean();
				legBean.setSlNo(count);
				legBean.setTripNo(rs.getString("TRIP_NO"));// tripId
				legBean.setShipmentId(rs.getString("TRIP_ID"));
				legBean.setRouteName(rs.getString("ROUTE_NAME"));
				legBean.setVehicleNo(rs.getString("VEHICLE_NO"));
				legBean.setMake(rs.getString("MAKE"));
				legBean.setLrNo(rs.getString("LR_NO"));
				legBean.setCustRefId(rs.getString("CUSTOMER_REF_ID"));
				legBean.setCustomerName(rs.getString("CUSTOMER_NAME"));
				legBean.setDriverName(rs.getString("DRIVER_NAME"));
				legBean.setDriverContact(rs.getString("DRIVER_NUMBER"));
				legBean.setLocation(rs.getString("LOCATION"));
				legBean.setOrigin(rs.getString("ORIGIN"));
				legBean.setDestination(rs.getString("DESTINATION"));
				legBean.setStatus(rs.getString("STATUS"));
				if (!rs.getString("STA_ON_ATD").contains("1900")) {
					Stawrtatd = mmddyyy.format(sdfDB.parse(rs.getString("STA_ON_ATD")));
				}
				legBean.setStawrtatd(Stawrtatd);
				legBean.setSTP(STP);
				legBean.setATP(ATP);
				legBean.setSTD(STD);
				legBean.setATD(ATD);
				legBean.setNearestHub(rs.getString("NEAREST_HUB"));
				distanceNext = rs.getDouble("DISTANCE_TO_NEXTHUB");
				if (unit.equals("Miles")) {
					distanceNext = rs.getDouble("DISTANCE_TO_NEXTHUB") * 0.621371;
				}
				legBean.setDistanceToNextHub(df.format(distanceNext));
				legBean.setETHA(ETHA);
				legBean.setETA(ETA);
				legBean.setSTA(STA);
				legBean.setATA(ATA);
				String delayS = cf.convertMinutesToHHMMFormat(rs.getInt("DELAY"));
				String delayE = cf.convertMinutesToHHMMFormatNegative(rs.getInt("DELAY"));
				if (rs.getInt("DELAY") < 0) {
					legBean.setDelay(delayE);
				} else {
					legBean.setDelay(delayS);
				}
				double avgSpped = rs.getDouble("AVG_SPEED");
				if (unit.equals("Miles")) {
					avgSpped = rs.getDouble("AVG_SPEED") * 0.621371;
				}
				legBean.setAvgSpeed(df.format(avgSpped));
				String stoppageTime = cf.convertMinutesToHHMMFormat(rs.getInt("STOPPAGE_TIME"));
				legBean.setStoppageTime(stoppageTime);

				distance = rs.getDouble("TOTAL_DISTANCE");
				if (unit.equals("Miles")) {
					distance = rs.getDouble("TOTAL_DISTANCE") * 0.621371;
				}
				legBean.setTotalDist(df.format(distance));
				// String
				// PlacedelayS=cf.convertMinutesToHHMMFormat(rs.getInt("PLACEMENT_DELAY"));
				if (rs.getInt("PLACEMENT_DELAY") < 0) {
					legBean.setPlacementDelay(cf.convertMinutesToHHMMFormatNegative(rs.getInt("PLACEMENT_DELAY")));
				} else {
					legBean.setPlacementDelay(cf.convertMinutesToHHMMFormat(rs.getInt("PLACEMENT_DELAY")));
				}
				if (rs.getInt("LOADING_DETENTION") < 0) {
					loadingD = cf.convertMinutesToHHMMFormatNegative(rs.getInt("LOADING_DETENTION"));
				} else {
					loadingD = cf.convertMinutesToHHMMFormat(rs.getInt("LOADING_DETENTION"));
				}
				if (rs.getInt("UNLOADING_DETENTION") < 0) {
					unloadingD = cf.convertMinutesToHHMMFormatNegative(rs.getInt("UNLOADING_DETENTION"));
				} else {
					unloadingD = cf.convertMinutesToHHMMFormat(rs.getInt("UNLOADING_DETENTION"));
				}
				int custDete = rs.getInt("LOADING_DETENTION") + rs.getInt("UNLOADING_DETENTION");
				if (custDete < 0) {
					custD = "00:00";
				} else {
					custD = cf.convertMinutesToHHMMFormat(custDete);
				}
				legBean.setCustomerDetentionTime(custD);
				legBean.setLoadingDetentionTime(loadingD);
				legBean.setUnloadingDetentionTime(unloadingD);
				String flag = "";
				if (rs.getString("FLAG").equalsIgnoreCase("GREEN")) {
					flag = " <div class='location-icon'><img src='/ApplicationImages/VehicleImages/startflag.png'></div> ";
				} else if (rs.getString("FLAG").equalsIgnoreCase("RED")) {
					flag = " <div class='location-icon'><img src='/ApplicationImages/VehicleImages/endflag.png'></div> ";
				}
				legBean.setFlag(flag);
				legBean.setWeather("");
				if (!rs.getString("endDate").contains("1900")) {
					endDate = mmddyyy.format(sdfDB.parse(rs.getString("endDate")));
				}
				String RouteId = rs.getString("ROUTE_ID");
				legBean.setEndDateHidden(endDate);
				legBean.setRouteIdHidden(RouteId);
				legBean.setPanicAlert(rs.getString("PANIC_COUNT"));
				legBean.setDoorAlert(rs.getString("DOOR_COUNT"));
				legBean.setNonReporting(rs.getString("NON_REPORTING_COUNT"));
				legBean.setFuelConsumed(df.format(rs.getDouble("fuelConsumed")));
				double mileage = 0;
				if (rs.getDouble("fuelConsumed") > 0) {
					mileage = distance / rs.getDouble("fuelConsumed");
				}
				legBean.setMileage(df.format(mileage));
				legBean.setMileageOBD(df.format(rs.getDouble("OBD_MILEAGE")));
				String nextLegETA = "";
				if (!rs.getString("NEXT_LEG_ETA").contains("1900")) {
					nextLegETA = mmddyyy.format(sdfDB.parse(rs.getString("NEXT_LEG_ETA")));
				}
				legBean.setNextLeg(rs.getString("NEXT_LEG"));
				legBean.setNextLegETA(nextLegETA);
				legBean.setTotalStopDuration(rs.getString("TOTAL_STOP_DURATION"));

				legBean.setWeightedGreenBandSpeed(rs.getString("WEIGHTED_GREEN_BAND_SPEED_DURATION"));
				legBean.setWeightedGreenBandRPM(rs.getString("WEIGHTED_GREEN_BAND_RPM_DURATION"));
				legBean.setLlsMileage(rs.getString("LLS_MILEAGE"));
				legBean.setObdMileageForSLALegReport(rs.getString("OBD_MILEAGE_FOR_SLA_LEG_REPORT"));
				legBean.setVehicleLength(rs.getString("VEHICLE_LENGTH"));

				legBean.setTripType(rs.getString("PRODUCT_LINE"));// new field
				legBean.setTripCategory(rs.getString("TRIP_CATEGORY"));// new

				if (rs.getString("delayedDepartureATD_STD") != null && !rs.getString("delayedDepartureATD_STD").equals("")) {
					if (rs.getInt("delayedDepartureATD_STD") < 0) {
						legBean.setDepartureDelayWrtSTD(cf.convertMinutesToHHMMFormatNegative(Integer.parseInt(rs.getString("delayedDepartureATD_STD"))));// Departure
						// Delay
						// wrt
						// STD(ATD-STD)
						// New
						// field
					} else {
						legBean.setDepartureDelayWrtSTD(cf.convertMinutesToHHMMFormat(Integer.parseInt(rs.getString("delayedDepartureATD_STD"))));// Departure
						// Delay
						// wrt
						// STD(ATD-STD)
						// New
						// field
					}
				} else {
					legBean.setDepartureDelayWrtSTD("NA");
				}
				legBean.setPlannedTransitTime(cf.convertMinutesToHHMMFormat(rs.getInt("PLANNED_DURATION")));
				Integer totalTripTimeATAATD = 0;
				if ((!ATA.equals("")) && (!ATD.equals(""))) {
					totalTripTimeATAATD = rs.getInt("TOTAL_TRIP_TIME_ATA_ATD");
					totalTripTimeATAATD = totalTripTimeATAATD < 0 ? 0 : totalTripTimeATAATD;
				}
				legBean.setActualTransitTime(cf.convertMinutesToHHMMFormat(totalTripTimeATAATD));

				// String legGroupBy =
				// "group by LEG_NAME, lz.NAME,lz1.NAME ,STD ,STA ,ACTUAL_ARRIVAL,ACTUAL_DEPARTURE,tl.TOTAL_DISTANCE ,tl.AVG_SPEED,tl.FUEL_CONSUMED,tl.MILEAGE,"
				// +
				// " tl.OBD_MILEAGE,ACTUAL_ARRIVAL,ACTUAL_DEPARTURE,d.Fullname,d1.Fullname,ETA,tdd.GREEN_BAND_SPEED_PERC,tdd.GREEN_RPM_PERC,d.Mobile,d1.Mobile,tl.ID,lm.TAT";
				String legGroupBy = " group by tl.LEG_ID , LEG_NAME, lz.NAME,lz1.NAME ,STD ,STA ,ACTUAL_ARRIVAL,ACTUAL_DEPARTURE,tl.TOTAL_DISTANCE ,tl.AVG_SPEED,tl.FUEL_CONSUMED,tl.MILEAGE, "
						+ " tl.OBD_MILEAGE,ACTUAL_ARRIVAL,ACTUAL_DEPARTURE,d.Fullname,d1.Fullname,ETA,tdd.GREEN_BAND_SPEED_PERC,tdd.GREEN_RPM_PERC,d.Mobile,d1.Mobile,tl.ID,lm.TAT "
						+ " ,lm.DISTANCE,lz.Standard_Duration,lz1.Standard_Duration ";

				try {
					pstmt1 = connection.prepareStatement(GeneralVerticalStatements.GET_TRIP_SUMMARY_REPORT_LEG_DETAILS.replaceAll("AMS.dbo.LOCATION", "AMS.dbo.LOCATION_ZONE_" + zone) + legGroupBy
							+ " order by tl.ID ");
					pstmt1.setInt(1, offset);
					pstmt1.setInt(2, offset);
					pstmt1.setInt(3, offset);
					pstmt1.setInt(4, offset);
					pstmt1.setInt(5, offset);
					pstmt1.setInt(6, tripNO);
					rs1 = pstmt1.executeQuery();
					List<LegInfoBean> legInfo = new ArrayList<LegInfoBean>();
					LegInfoBean leginfoval = null;

					while (rs1.next()) {
						leginfoval = new LegInfoBean();
						leginfoval.setLegName(rs1.getString("LEG_NAME"));
						leginfoval.setSource(rs1.getString("SOURCE"));
						leginfoval.setDestination(rs1.getString("DESTIANTION"));
						double Legdistance = rs1.getDouble("DISTANCE");
						leginfoval.setLegDistance(Legdistance);

						long plannedTransitTime = rs1.getInt("plannedTransitTime");
						long actualTransitTime = rs1.getInt("actualTransitTime");
						long transitDealy = (actualTransitTime != 0) ? (actualTransitTime - plannedTransitTime) : 0;
						leginfoval.setsPlannedT(plannedTransitTime);
						leginfoval.setsActualT(actualTransitTime);
						leginfoval.setsTransitDelay(transitDealy);

						// String STAwrtATD=(rs1.getString("STA_wrt_ATD")==null
						// ||
						// rs1.getString("STA_wrt_ATD").contains("1900")?"":mmddyyy.format(sdfDB.parse(rs1.getString("STA_wrt_ATD"))));
						String STAwrtATD = getDate(rs1.getString("ATD"), plannedTransitTime);
						String legTransitDealy = (transitDealy != 0) ? formattedHoursMinutesSeconds(transitDealy) : "";

						leginfoval.setSTAwrtATD(STAwrtATD);
						leginfoval.setTransitDelay(legTransitDealy);
						leginfoval.setsTransitDelay(transitDealy);

						String LEGSTD = "";
						if (!rs1.getString("STD").contains("1900")) {
							LEGSTD = mmddyyy.format(sdfDB.parse(rs1.getString("STD")));
						}
						String LEGSTA = "";
						if (!rs1.getString("STA").contains("1900")) {
							LEGSTA = mmddyyy.format(sdfDB.parse(rs1.getString("STA")));
						}

						String LEGATD = "";
						if (!rs1.getString("ATD").contains("1900")) {
							LEGATD = mmddyyy.format(sdfDB.parse(rs1.getString("ATD")));
						}
						String LEGATA = "";
						if (!rs1.getString("ATA").contains("1900")) {
							LEGATA = mmddyyy.format(sdfDB.parse(rs1.getString("ATA")));
						}

						leginfoval.setLegSTD(LEGSTD);
						leginfoval.setLegSTA(LEGSTA);
						leginfoval.setLegATA(LEGATA);
						leginfoval.setLegATD(LEGATD);
						leginfoval.setTotalDistance(rs1.getString("TOTAL_DISTANCE"));
						leginfoval.setAvgSpeed(rs1.getString("AVG_SPEED"));
						leginfoval.setFuelConsumed(rs1.getString("FUEL_CONSUMED"));
						leginfoval.setMileage(rs1.getString("MILEAGE"));
						leginfoval.setOBDMileage(rs1.getString("OBD_MILEAGE"));
						leginfoval.setTravelDuration(rs1.getString("TRAVEL_DURATION"));
						leginfoval.setDriver1(rs1.getString("DRIVER1"));
						leginfoval.setDriver2(rs1.getString("DRIVER2"));
						leginfoval.setDriver1Contact(rs1.getString("DRIVER1_CONTACT"));
						leginfoval.setDriver2Contact(rs1.getString("DRIVER2_CONTACT"));
						leginfoval.setTotalStoppage(rs1.getString("TOTAL_STOP_DURATION"));
						leginfoval.setGreenBandRPMPercentage(rs1.getString("greenRPMPerc"));
						leginfoval.setGreenBandSpeedPercentage(rs1.getString("greenBandSpeedPerc"));
						// new
						if (rs1.getString("delayedDepartureATD_STD") != null && !rs1.getString("delayedDepartureATD_STD").equals("")) {
							if (rs1.getInt("delayedDepartureATD_STD") < 0) {
								leginfoval.setDepartureDelayWrtSTD(formattedHoursMinutesSeconds(Integer.parseInt(rs1.getString("delayedDepartureATD_STD"))));// Departure
								// Delay
								// wrt
								// STD(ATD-STD)
								// New
								// field
								leginfoval.setsDepartureDelay(Integer.parseInt(rs1.getString("delayedDepartureATD_STD")));
							} else {
								leginfoval.setDepartureDelayWrtSTD(formattedHoursMinutesSeconds(Integer.parseInt(rs1.getString("delayedDepartureATD_STD"))));// Departure
								// Delay
								// wrt
								// STD(ATD-STD)
								// New
								// field
								leginfoval.setsDepartureDelay(Integer.parseInt(rs1.getString("delayedDepartureATD_STD")));
							}
						} else {
							leginfoval.setDepartureDelayWrtSTD("");
						}
						leginfoval.setPlannedTransitTime(formattedHoursMinutesSeconds(rs1.getInt("plannedTransitTime")));
						if (rs1.getString("actualTransitTime") != null && !rs1.getString("actualTransitTime").equals("")) {
							if (rs1.getInt("actualTransitTime") < 0) {
								leginfoval.setActualTransitTime(formattedHoursMinutesSeconds(Integer.parseInt(rs1.getString("actualTransitTime"))));// Departure
								// Delay
								// wrt
								// STD(ATD-STD)
								// New
								// field
							} else {
								leginfoval.setActualTransitTime(formattedHoursMinutesSeconds(Integer.parseInt(rs1.getString("actualTransitTime"))));// Departure
								// Delay
								// wrt
								// STD(ATD-STD)
								// New
								// field
							}
						} else {
							leginfoval.setActualTransitTime("");
						}
						String LEGETA = "";
						if (!rs1.getString("ETA").contains("1900")) {
							LEGETA = mmddyyy.format(sdfDB.parse(rs1.getString("ETA")));
						}
						leginfoval.setLegETA(LEGETA);
						legInfo.add(leginfoval);
					}
					legBean.setLegDetails(legInfo);
				} catch (Exception e) {
					e.printStackTrace();
				}
				legBeanDetails.add(legBean);
			}
			// System.out.println(legBeanDetails);
			if (legBeanDetails.size() > 0) {
				// completePath=CreateExcel(connection,legBeanDetails);
				SlaDashBoardLegExport legreport = new SlaDashBoardLegExport();
				completePath = legreport.CreateExcel(connection, legBeanDetails);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(connection, pstmt, rs);
			DBConnection.releaseConnectionToDB(null, pstmt1, rs1);
		}
		return completePath;
	}

	public String CreateExcel(Connection con, ArrayList<LegDetailsBean> legBean) {

		String completePath = null;
		try {
			Calendar cal = Calendar.getInstance();
			Date endDate = cal.getTime();
			cal.add(Calendar.DATE, -1);
			Date startDate = cal.getTime();
			String name = "Leg Details Report";
			String customername = "DHL";
			Properties properties = ApplicationListener.prop;
			String rootPath = properties.getProperty("legCreatePath");
			// String rootPath ="C:\\LegDetailsExcel";
			completePath = rootPath + "//" + name + "_" + customername + "_" + sdfDBMMDD.format(startDate) + "_" + sdfDBMMDD.format(endDate) + ".xls";

			File f = new File(rootPath);
			if (!f.exists()) {
				f.mkdir();
			}

			FileOutputStream fileOut = new FileOutputStream(completePath);

			HSSFWorkbook workbook = new HSSFWorkbook();
			HSSFSheet worksheet = workbook.createSheet("Report");
			HSSFRow customerNameRow = null;

			HSSFFont font = null;
			font = workbook.createFont();
			font.setBoldweight(Font.BOLDWEIGHT_BOLD);

			HSSFFont titleFont = null;
			titleFont = workbook.createFont();
			titleFont.setFontName(HSSFFont.FONT_ARIAL);
			titleFont.setFontHeightInPoints((short) 15);
			titleFont.setBoldweight(Font.BOLDWEIGHT_BOLD);

			HSSFCellStyle headerStyle = workbook.createCellStyle();
			headerStyle.setFont(titleFont);
			headerStyle.setAlignment(HSSFCellStyle.ALIGN_CENTER);

			HSSFCellStyle styleForCustomer = workbook.createCellStyle();
			styleForCustomer.setAlignment(HSSFCellStyle.ALIGN_LEFT);

			CellStyle blankOrNAStyle = workbook.createCellStyle();
			blankOrNAStyle.setFillForegroundColor(IndexedColors.YELLOW.getIndex());
			blankOrNAStyle.setFillPattern(CellStyle.SOLID_FOREGROUND);

			DataFormat fmt = workbook.createDataFormat();
			HSSFCellStyle timeStyleForLegs = workbook.createCellStyle();
			timeStyleForLegs.setAlignment(HSSFCellStyle.ALIGN_LEFT);
			timeStyleForLegs.setDataFormat(fmt.getFormat("@"));

			HSSFCellStyle decimalStyleForLegs = workbook.createCellStyle();
			decimalStyleForLegs.setAlignment(HSSFCellStyle.ALIGN_LEFT);
			decimalStyleForLegs.setDataFormat(fmt.getFormat("0.00"));

			HSSFCellStyle dateStyleForLegs = workbook.createCellStyle();
			dateStyleForLegs.setAlignment(HSSFCellStyle.ALIGN_LEFT);
			dateStyleForLegs.setDataFormat(fmt.getFormat("dd/MM/yyyy HH:mm:ss"));

			HSSFCellStyle summaryStyle = workbook.createCellStyle();
			summaryStyle.setFont(font);
			summaryStyle.setFillForegroundColor(IndexedColors.GREY_40_PERCENT.index);
			summaryStyle.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
			summaryStyle.setAlignment(HSSFCellStyle.ALIGN_LEFT);
			summaryStyle.setBorderTop((short) 1); // single line border
			summaryStyle.setBorderBottom((short) 1); // single line border

			HSSFCellStyle timeStyleForTrips = workbook.createCellStyle();
			timeStyleForTrips.setFont(font);
			timeStyleForTrips.setFillForegroundColor(IndexedColors.GREY_40_PERCENT.index);
			timeStyleForTrips.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
			timeStyleForTrips.setAlignment(HSSFCellStyle.ALIGN_LEFT);
			timeStyleForTrips.setBorderTop((short) 1); // single line border
			timeStyleForTrips.setBorderBottom((short) 1); // single line border
			timeStyleForTrips.setAlignment(HSSFCellStyle.ALIGN_LEFT);
			timeStyleForTrips.setDataFormat(fmt.getFormat("@"));

			HSSFCellStyle dateStyleForTrips = workbook.createCellStyle();
			dateStyleForTrips.setFont(font);
			dateStyleForTrips.setFillForegroundColor(IndexedColors.GREY_40_PERCENT.index);
			dateStyleForTrips.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
			dateStyleForTrips.setAlignment(HSSFCellStyle.ALIGN_LEFT);
			dateStyleForTrips.setBorderTop((short) 1); // single line border
			dateStyleForTrips.setBorderBottom((short) 1); // single line border
			dateStyleForTrips.setAlignment(HSSFCellStyle.ALIGN_LEFT);
			dateStyleForTrips.setDataFormat(fmt.getFormat("dd/MM/yyyy HH:mm:ss"));

			HSSFCellStyle decimalStyleForTrips = workbook.createCellStyle();
			decimalStyleForTrips.setFont(font);
			decimalStyleForTrips.setFillForegroundColor(IndexedColors.GREY_40_PERCENT.index);
			decimalStyleForTrips.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
			decimalStyleForTrips.setAlignment(HSSFCellStyle.ALIGN_LEFT);
			decimalStyleForTrips.setBorderTop((short) 1); // single line border
			decimalStyleForTrips.setBorderBottom((short) 1); // single line
			// border
			decimalStyleForTrips.setDataFormat(fmt.getFormat("0.00"));

			HSSFCellStyle style1 = workbook.createCellStyle();
			style1.setFont(font);

			HSSFRow row = worksheet.createRow((short) 0);
			worksheet.createFreezePane(0, 4);

			HSSFCell titleCellC1 = row.createCell((short) 0);
			titleCellC1.setCellValue("SLA Leg Wise Details");
			titleCellC1.setCellStyle(headerStyle);
			worksheet.addMergedRegion(new Region(0, (short) 0, 1, (short) 13));

			// System.out.println("legBean.size() ::"+legBean.size());
			int rowNumber = 3;

			HSSFRow row1 = worksheet.createRow((short) rowNumber);

			HSSFCell cellA1 = row1.createCell((short) 0);
			cellA1.setCellValue("S.No");
			cellA1.setCellStyle(style1);

			HSSFCell cellB1 = row1.createCell((short) 1);
			cellB1.setCellValue("Trip Id");
			cellB1.setCellStyle(style1);

			HSSFCell cellD1 = row1.createCell((short) 2);
			cellD1.setCellValue("Trip LR No");
			cellD1.setCellStyle(style1);

			HSSFCell cellTripType = row1.createCell((short) 3);
			cellTripType.setCellValue("Trip Type");
			cellTripType.setCellStyle(style1);

			HSSFCell cellTripCat = row1.createCell((short) 4);
			cellTripCat.setCellValue("Trip Category");
			cellTripCat.setCellStyle(style1);

			HSSFCell cellE1 = row1.createCell((short) 5);
			cellE1.setCellValue("Route Id");
			cellE1.setCellStyle(style1);

			HSSFCell cellF1 = row1.createCell((short) 6);
			cellF1.setCellValue("Vehicle Number");
			cellF1.setCellStyle(style1);

			HSSFCell cellG1 = row1.createCell((short) 7);
			cellG1.setCellValue("Make Of Vehicle");
			cellG1.setCellStyle(style1);

			HSSFCell cellH1 = row1.createCell((short) 8);
			cellH1.setCellValue("Length Of Truck(Type of vehicle)");
			cellH1.setCellStyle(style1);

			HSSFCell cellI1 = row1.createCell((short) 9);
			cellI1.setCellValue("Customer Reference ID");
			cellI1.setCellStyle(style1);

			HSSFCell cellJ1 = row1.createCell((short) 10);
			cellJ1.setCellValue("Customer Name");
			cellJ1.setCellStyle(style1);

			HSSFCell cellK1 = row1.createCell((short) 11);
			cellK1.setCellValue("Leg Name");
			cellK1.setCellStyle(style1);

			HSSFCell cellL1 = row1.createCell((short) 12);
			cellL1.setCellValue("Driver 1 Name ");
			cellL1.setCellStyle(style1);

			HSSFCell cellM1 = row1.createCell((short) 13);
			cellM1.setCellValue("Driver 1 Contact ");
			cellM1.setCellStyle(style1);

			HSSFCell cellN1 = row1.createCell((short) 14);
			cellN1.setCellValue("Driver 2 Name");
			cellN1.setCellStyle(style1);

			HSSFCell cellO1 = row1.createCell((short) 15);
			cellO1.setCellValue("Driver 2 Contact");
			cellO1.setCellStyle(style1);

			HSSFCell cellP1 = row1.createCell((short) 16);
			cellP1.setCellValue("Origin");
			cellP1.setCellStyle(style1);

			HSSFCell cellQ1 = row1.createCell((short) 17);
			cellQ1.setCellValue("Destination");
			cellQ1.setCellStyle(style1);

			HSSFCell cellR1 = row1.createCell((short) 18);
			cellR1.setCellValue("STD");
			cellR1.setCellStyle(style1);

			HSSFCell cellS1 = row1.createCell((short) 19);
			cellS1.setCellValue("ATD");
			cellS1.setCellStyle(style1);

			HSSFCell departureDelaywrtSTD = row1.createCell((short) 20);
			departureDelaywrtSTD.setCellValue("Departure Delay wrt STD");
			departureDelaywrtSTD.setCellStyle(style1);

			HSSFCell plannedTransitTime = row1.createCell((short) 21);
			plannedTransitTime.setCellValue("Planned Transit Time (incl. planned stoppages) (hh:mm)");
			plannedTransitTime.setCellStyle(style1);

			HSSFCell cellT1 = row1.createCell((short) 22);
			cellT1.setCellValue("ETA");
			cellT1.setCellStyle(style1);

			HSSFCell cellU1 = row1.createCell((short) 23);
			cellU1.setCellValue("STA");
			cellU1.setCellStyle(style1);

			HSSFCell cellV1 = row1.createCell((short) 24);
			cellV1.setCellValue("ATA");
			cellV1.setCellStyle(style1);

			HSSFCell actualTransitTime = row1.createCell((short) 25);
			actualTransitTime.setCellValue("Actual Transit Time (incl. planned and unplanned stoppages)");
			actualTransitTime.setCellStyle(style1);

			HSSFCell cellW1 = row1.createCell((short) 26);
			cellW1.setCellValue("Transit Delay (hh:mm)");
			cellW1.setCellStyle(style1);

			HSSFCell cellX1 = row1.createCell((short) 27);
			cellX1.setCellValue("Leg Distance (Kms)");
			cellX1.setCellStyle(style1);

			HSSFCell cellY1 = row1.createCell((short) 28);
			cellY1.setCellValue("Duration (hh:mm)");
			cellY1.setCellStyle(style1);

			HSSFCell cellZ1 = row1.createCell((short) 29);
			cellZ1.setCellValue("Avg. Speed(Kmph)");
			cellZ1.setCellStyle(style1);

			HSSFCell cellAA1 = row1.createCell((short) 30);
			cellAA1.setCellValue("Total Stoppage Time(HH:mm)");
			cellAA1.setCellStyle(style1);

			HSSFCell cellAB1 = row1.createCell((short) 31);
			cellAB1.setCellValue("Green Band Speed (% time)");
			cellAB1.setCellStyle(style1);

			HSSFCell cellAC1 = row1.createCell((short) 32);
			cellAC1.setCellValue("Green Band RPM (%Time)");
			cellAC1.setCellStyle(style1);

			HSSFCell cellAD1 = row1.createCell((short) 33);
			cellAD1.setCellValue("LLS Mileage (KMPL)");
			cellAD1.setCellStyle(style1);

			HSSFCell cellAE1 = row1.createCell((short) 34);
			cellAE1.setCellValue("OBD Mileage (KMPL)");
			cellAE1.setCellStyle(style1);

			HSSFCell cellAF1 = row1.createCell((short) 35);
			cellAF1.setCellValue("Fuel Consumed(L)");
			cellAF1.setCellStyle(style1);

			int summaryRowCount = 0;
			for (int i = 0; i < legBean.size(); i++) {
				// rowNumber++;
				if (legBean.get(i).getLegDetails().size() > 0) {
					rowNumber++;
					customerNameRow = worksheet.createRow((short) rowNumber);

					HSSFCell cellC1 = customerNameRow.createCell((short) 0);
					// cellC1.setCellValue(legBean.get(i).getCustomerName());
					cellC1.setCellStyle(styleForCustomer);
					worksheet.addMergedRegion(new Region(rowNumber, (short) 0, rowNumber, (short) 13));

					rowNumber++;

					worksheet.addMergedRegion(new Region(rowNumber, (short) 0, rowNumber, (short) 13));
					int count = 0;

					String std = "";
					String atd = "";
					String sta = "";
					String ata = "";
					Double totalDistance = 0.0;
					Double totalDuration = 0.0;
					Double mileage = 0.0;
					Double obdMileage = 0.0;
					Double fuelConsumed = 0.0;
					String driver1 = "";
					String driver1Contact = "";
					String driver2 = "";
					String driver2Contact = "";
					for (int ii = 0; ii < legBean.get(i).getLegDetails().size(); ii++) {
						List<LegInfoBean> internalLegBean = legBean.get(i).getLegDetails();
						// String customerName =
						// internalLegBean.getShipmentId();
						// System.out.println(" legBean.get(i).getLegDetails().size();;"+
						// legBean.get(i).getLegDetails().size());
						count++;
						rowNumber++;
						HSSFRow row2 = worksheet.createRow((short) rowNumber);
						row2.setRowStyle(styleForCustomer);

						cellA1 = row2.createCell((short) 0);
						cellA1.setCellValue("");// Seria Number
						cellA1.setCellStyle(styleForCustomer);

						cellB1 = row2.createCell((short) 1);
						if (legBean.get(i).getShipmentId().equalsIgnoreCase("") || legBean.get(i).getShipmentId().equalsIgnoreCase("NA")) {
							cellB1.setCellValue(legBean.get(i).getShipmentId());// ""
							// or
							// NA
							cellB1.setCellStyle(blankOrNAStyle);
						} else {
							cellB1.setCellValue(legBean.get(i).getShipmentId());// Trip
							// ID
							cellB1.setCellStyle(styleForCustomer);
						}

						cellD1 = row2.createCell((short) 2);
						if (legBean.get(i).getLrNo().equalsIgnoreCase("") || legBean.get(i).getLrNo().equalsIgnoreCase("NA")) {
							cellD1.setCellValue(legBean.get(i).getLrNo());// ""
							// or
							// NA
							cellD1.setCellStyle(blankOrNAStyle);
						} else {
							cellD1.setCellValue(legBean.get(i).getLrNo());// Trip
							// LR
							// NO
							cellD1.setCellStyle(styleForCustomer);
						}

						cellTripType = row2.createCell((short) 3);
						if (legBean.get(i).getTripType().equalsIgnoreCase("") || legBean.get(i).getTripType().equalsIgnoreCase("NA")) {
							cellTripType.setCellValue(legBean.get(i).getTripType());// "" or NA
							cellTripType.setCellStyle(blankOrNAStyle);
						} else {
							cellTripType.setCellValue(legBean.get(i).getTripType());// Trip Type.
							cellTripType.setCellStyle(styleForCustomer);
						}

						cellTripCat = row2.createCell((short) 4);
						if (legBean.get(i).getTripCategory().equalsIgnoreCase("") || legBean.get(i).getTripCategory().equalsIgnoreCase("NA")) {
							cellTripCat.setCellValue(legBean.get(i).getTripCategory());// "" OR NA
							cellTripCat.setCellStyle(blankOrNAStyle);
						} else {
							cellTripCat.setCellValue(legBean.get(i).getTripCategory());// Trip Catagory
							cellTripCat.setCellStyle(styleForCustomer);
						}

						cellF1 = row2.createCell((short) 5);
						if (legBean.get(i).getRouteName().equalsIgnoreCase("") || legBean.get(i).getRouteName().equalsIgnoreCase("NA")) {
							cellF1.setCellValue(legBean.get(i).getRouteName());// ""
							// or
							// NA
							cellF1.setCellStyle(blankOrNAStyle);
						} else {
							cellF1.setCellValue(legBean.get(i).getRouteName());// Route
							// ID
							cellF1.setCellStyle(styleForCustomer);
						}

						cellF1 = row2.createCell((short) 6);
						if (legBean.get(i).getVehicleNo().equalsIgnoreCase("") || legBean.get(i).getVehicleNo().equalsIgnoreCase("NA")) {
							cellF1.setCellValue(legBean.get(i).getVehicleNo());// ""
							// or
							// NA
							cellF1.setCellStyle(blankOrNAStyle);
						} else {
							cellF1.setCellValue(legBean.get(i).getVehicleNo());// Vehicle
							// Number
							cellF1.setCellStyle(styleForCustomer);
						}

						cellG1 = row2.createCell((short) 7);
						if (legBean.get(i).getMake().equalsIgnoreCase("") || legBean.get(i).getMake().equalsIgnoreCase("NA")) {
							cellG1.setCellValue(legBean.get(i).getMake());// ""
							// or
							// NA
							cellG1.setCellStyle(blankOrNAStyle);
						} else {
							cellG1.setCellValue(legBean.get(i).getMake());// Make
							// of
							// Vehicle
							cellG1.setCellStyle(styleForCustomer);
						}

						cellH1 = row2.createCell((short) 8);
						if (legBean.get(i).getVehicleLength().equalsIgnoreCase("") || legBean.get(i).getVehicleLength().equalsIgnoreCase("NA")) {
							cellH1.setCellValue(legBean.get(i).getVehicleLength());// "" or NA
							cellH1.setCellStyle(blankOrNAStyle);
						} else {
							cellH1.setCellValue(legBean.get(i).getVehicleLength());// Length of Truck
							cellH1.setCellStyle(styleForCustomer);
						}

						cellI1 = row2.createCell((short) 9);
						if (legBean.get(i).getCustRefId().equalsIgnoreCase("") || legBean.get(i).getCustRefId().equalsIgnoreCase("NA")) {
							cellI1.setCellValue(legBean.get(i).getCustRefId());// ""
							// or
							// NA
							cellI1.setCellStyle(blankOrNAStyle);
						} else {
							cellI1.setCellValue(legBean.get(i).getCustRefId());// Customer
							// Reference
							// ID
							cellI1.setCellStyle(styleForCustomer);
						}

						cellJ1 = row2.createCell((short) 10);
						if (legBean.get(i).getCustomerName().equalsIgnoreCase("") || legBean.get(i).getCustomerName().equalsIgnoreCase("NA")) {
							cellJ1.setCellValue(legBean.get(i).getCustomerName());// "" OR NA
							cellJ1.setCellStyle(blankOrNAStyle);
						} else {
							cellJ1.setCellValue(legBean.get(i).getCustomerName());// Customer Name
							cellJ1.setCellStyle(styleForCustomer);
						}
						// 11 is missing need clarification

						cellK1 = row2.createCell((short) 11);
						// cellK1.setCellValue("Leg" + count);//LegId
						cellK1.setCellValue(internalLegBean.get(ii).getLegName());
						cellK1.setCellStyle(styleForCustomer);

						cellL1 = row2.createCell((short) 12);
						if (internalLegBean.get(ii).getDriver1().equalsIgnoreCase("") || internalLegBean.get(ii).getDriver1().equalsIgnoreCase("NA")) {
							cellL1.setCellValue(internalLegBean.get(ii).getDriver1());// "" or NA
							cellL1.setCellStyle(blankOrNAStyle);
						} else {
							cellL1.setCellValue(internalLegBean.get(ii).getDriver1());// /Driver 1 Name
							cellL1.setCellStyle(styleForCustomer);
						}

						cellM1 = row2.createCell((short) 13);
						if (internalLegBean.get(ii).getDriver1Contact().equalsIgnoreCase("") || internalLegBean.get(ii).getDriver1Contact().equalsIgnoreCase("NA")) {
							cellM1.setCellValue(internalLegBean.get(ii).getDriver1Contact());// "" or NA
							cellM1.setCellStyle(blankOrNAStyle);
						} else {
							cellM1.setCellValue(internalLegBean.get(ii).getDriver1Contact());// Driver 1 Contact
							cellM1.setCellStyle(styleForCustomer);
						}

						cellN1 = row2.createCell((short) 14);
						if (internalLegBean.get(ii).getDriver2().equalsIgnoreCase("") || internalLegBean.get(ii).getDriver2().equalsIgnoreCase("NA")) {
							cellN1.setCellValue(internalLegBean.get(ii).getDriver2());// "" or NA
							cellN1.setCellStyle(blankOrNAStyle);
						} else {
							cellN1.setCellValue(internalLegBean.get(ii).getDriver2());// Driver 2 Name
							cellN1.setCellStyle(styleForCustomer);
						}

						cellO1 = row2.createCell((short) 15);
						if (internalLegBean.get(ii).getDriver2Contact().equalsIgnoreCase("") || internalLegBean.get(ii).getDriver2Contact().equalsIgnoreCase("NA")) {
							cellO1.setCellValue(internalLegBean.get(ii).getDriver2Contact());// "" OR NA
							cellO1.setCellStyle(blankOrNAStyle);
						} else {
							cellO1.setCellValue(internalLegBean.get(ii).getDriver2Contact());// Driver 2 Contact
							cellO1.setCellStyle(styleForCustomer);
						}

						cellP1 = row2.createCell((short) 16);
						if (internalLegBean.get(ii).getSource().equalsIgnoreCase("") || internalLegBean.get(ii).getSource().equalsIgnoreCase("NA")) {
							cellP1.setCellValue(internalLegBean.get(ii).getSource());// "" or NA
							cellP1.setCellStyle(blankOrNAStyle);
						} else {
							cellP1.setCellValue(internalLegBean.get(ii).getSource());// Origin
							cellP1.setCellStyle(styleForCustomer);
						}

						cellQ1 = row2.createCell((short) 17);
						if (internalLegBean.get(ii).getDestination().equalsIgnoreCase("") || internalLegBean.get(ii).getDestination().equalsIgnoreCase("NA")) {
							cellQ1.setCellValue(internalLegBean.get(ii).getDestination());// "" or NA
							cellQ1.setCellStyle(blankOrNAStyle);
						} else {
							cellQ1.setCellValue(internalLegBean.get(ii).getDestination());// Destination
							cellQ1.setCellStyle(styleForCustomer);
						}

						cellR1 = row2.createCell((short) 18);
						if (internalLegBean.get(ii).getLegSTD().equalsIgnoreCase("") || internalLegBean.get(ii).getLegSTD().equalsIgnoreCase("NA")) {
							cellR1.setCellValue(internalLegBean.get(ii).getLegSTD());// "" or NA
							cellR1.setCellStyle(blankOrNAStyle);
						} else {
							cellR1.setCellValue(internalLegBean.get(ii).getLegSTD());// STD
							cellR1.setCellStyle(dateStyleForLegs);
						}

						cellS1 = row2.createCell((short) 19);
						if (internalLegBean.get(ii).getLegATD().equalsIgnoreCase("") || internalLegBean.get(ii).getLegATD().equalsIgnoreCase("NA")) {
							cellS1.setCellValue(internalLegBean.get(ii).getLegATD());// "" or NA
							cellS1.setCellStyle(blankOrNAStyle);
						} else {
							cellS1.setCellValue(internalLegBean.get(ii).getLegATD());// ATD
							cellS1.setCellStyle(dateStyleForLegs);
						}

						// delayedDepartureATD_STD
						cellU1 = row2.createCell((short) 20);
						if (internalLegBean.get(ii).getDepartureDelayWrtSTD().equalsIgnoreCase("") || internalLegBean.get(ii).getDepartureDelayWrtSTD().equalsIgnoreCase("NA")) {
							cellU1.setCellValue(internalLegBean.get(ii).getDepartureDelayWrtSTD());// "" or NA
							cellU1.setCellStyle(blankOrNAStyle);
						} else {
							cellU1.setCellValue(internalLegBean.get(ii).getDepartureDelayWrtSTD());// delayedDepartureATD_STD
							cellU1.setCellStyle(dateStyleForLegs);
						}

						// plannedTransitTime
						cellU1 = row2.createCell((short) 21);
						if (internalLegBean.get(ii).getPlannedTransitTime().equalsIgnoreCase("") || internalLegBean.get(ii).getPlannedTransitTime().equalsIgnoreCase("NA")) {
							cellU1.setCellValue(internalLegBean.get(ii).getPlannedTransitTime());// "" or NA
							cellU1.setCellStyle(blankOrNAStyle);
						} else {
							cellU1.setCellValue(internalLegBean.get(ii).getPlannedTransitTime());// plannedTransitTime
							cellU1.setCellStyle(dateStyleForLegs);
						}

						cellT1 = row2.createCell((short) 22);
						if (internalLegBean.get(ii).getLegETA().equalsIgnoreCase("") || internalLegBean.get(ii).getLegETA().equalsIgnoreCase("NA")) {
							cellT1.setCellValue(internalLegBean.get(ii).getLegETA());// "" or NA
							cellT1.setCellStyle(blankOrNAStyle);
						} else {
							cellT1.setCellValue(internalLegBean.get(ii).getLegETA());// ETA
							cellT1.setCellStyle(dateStyleForLegs);
						}

						cellU1 = row2.createCell((short) 23);
						if (internalLegBean.get(ii).getLegSTA().equalsIgnoreCase("") || internalLegBean.get(ii).getLegSTA().equalsIgnoreCase("NA")) {
							cellU1.setCellValue(internalLegBean.get(ii).getLegSTA());// "" or NA
							cellU1.setCellStyle(blankOrNAStyle);
						} else {
							cellU1.setCellValue(internalLegBean.get(ii).getLegSTA());// STA
							cellU1.setCellStyle(dateStyleForLegs);
						}

						cellU1 = row2.createCell((short) 24);
						if (internalLegBean.get(ii).getLegATA().equalsIgnoreCase("") || internalLegBean.get(ii).getLegATA().equalsIgnoreCase("NA")) {
							cellU1.setCellValue(internalLegBean.get(ii).getLegATA());// "" or nA
							cellU1.setCellStyle(blankOrNAStyle);
						} else {
							cellU1.setCellValue(internalLegBean.get(ii).getLegATA());// ATA
							cellU1.setCellStyle(dateStyleForLegs);
						}

						cellV1 = row2.createCell((short) 25);
						if (internalLegBean.get(ii).getActualTransitTime().equalsIgnoreCase("") || internalLegBean.get(ii).getActualTransitTime().equalsIgnoreCase("NA")) {
							cellV1.setCellValue(internalLegBean.get(ii).getActualTransitTime());// "" or NA
							cellV1.setCellStyle(blankOrNAStyle);
						} else {
							cellV1.setCellValue(internalLegBean.get(ii).getActualTransitTime());// ActualTransitTime
							cellV1.setCellStyle(dateStyleForLegs);
						}

						cellW1 = row2.createCell((short) 26);
						if (legBean.get(i).getDelay().equalsIgnoreCase("") || legBean.get(i).getDelay().equalsIgnoreCase("NA")) {
							cellW1.setCellValue(legBean.get(i).getDelay());// Total
							// Delay
							// (HH:mm)
							cellW1.setCellStyle(blankOrNAStyle);
						} else {
							cellW1.setCellValue(legBean.get(i).getDelay());// Total
							// Delay
							// (HH:mm)
							cellW1.setCellStyle(timeStyleForLegs);
						}

						cellX1 = row2.createCell((short) 27);
						if (internalLegBean.get(ii).getTotalDistance().equalsIgnoreCase("") || internalLegBean.get(ii).getTotalDistance().equalsIgnoreCase("NA")) {
							cellX1.setCellValue(internalLegBean.get(ii).getTotalDistance());// "" or NA
							cellX1.setCellStyle(blankOrNAStyle);
						} else {
							cellX1.setCellValue(df2.format(Double.parseDouble(internalLegBean.get(ii).getTotalDistance())));// Distance
							// (Kms)
							cellX1.setCellStyle(decimalStyleForLegs);
						}

						cellY1 = row2.createCell((short) 28);
						if (internalLegBean.get(ii).getTravelDuration().equalsIgnoreCase("") || internalLegBean.get(ii).getTravelDuration().equalsIgnoreCase("NA")) {
							cellY1.setCellValue(internalLegBean.get(ii).getTravelDuration());// "" or NA
							cellY1.setCellStyle(blankOrNAStyle);
						} else {
							cellY1.setCellValue(cf.convertMinutesToHHMMFormat(Integer.parseInt(internalLegBean.get(ii).getTravelDuration())));// Duration
							// (Kms)
							cellY1.setCellStyle(timeStyleForLegs);
						}

						// not required
						Double avgSpeed = Double.parseDouble(internalLegBean.get(ii).getTravelDuration()) > 0.0 ? ((Double.parseDouble(internalLegBean.get(ii).getTotalDistance()) / Double
								.parseDouble(internalLegBean.get(ii).getTravelDuration())) * 60) : 0.0;
						cellZ1 = row2.createCell((short) 29);
						cellZ1.setCellValue(df2.format(avgSpeed));// Avg.
						// Speed(Kmph)
						cellZ1.setCellStyle(decimalStyleForLegs);

						cellAA1 = row2.createCell((short) 30);
						if (internalLegBean.get(ii).getTotalStoppage().equalsIgnoreCase("") || internalLegBean.get(ii).getTotalStoppage().equalsIgnoreCase("NA")) {
							cellAA1.setCellValue(internalLegBean.get(ii).getTotalStoppage());// "" or NA
							cellAA1.setCellStyle(blankOrNAStyle);
						} else {
							cellAA1.setCellValue(cf.convertMinutesToHHMMFormat(Integer.parseInt(internalLegBean.get(ii).getTotalStoppage())));// Total
							// Stoppage
							// Time(HH:mm)
							cellAA1.setCellStyle(timeStyleForLegs);
						}

						cellAB1 = row2.createCell((short) 31);
						if (internalLegBean.get(ii).getGreenBandSpeedPercentage().equalsIgnoreCase("") || internalLegBean.get(ii).getGreenBandSpeedPercentage().equalsIgnoreCase("NA")) {
							cellAB1.setCellValue(internalLegBean.get(ii).getGreenBandSpeedPercentage());// "" or NA
							cellAB1.setCellStyle(blankOrNAStyle);
						} else {
							cellAB1.setCellValue(df2.format(Double.parseDouble(internalLegBean.get(ii).getGreenBandSpeedPercentage())));// Green
							// Band
							// Speed
							// (%
							// time)
							cellAB1.setCellStyle(decimalStyleForLegs);
						}

						cellAC1 = row2.createCell((short) 32);
						if (internalLegBean.get(ii).getGreenBandRPMPercentage().equalsIgnoreCase("") || internalLegBean.get(ii).getGreenBandRPMPercentage().equalsIgnoreCase("NA")) {
							cellAC1.setCellValue(df2.format(Double.parseDouble(internalLegBean.get(ii).getGreenBandRPMPercentage())));// ""
							// or
							// NA
							cellAC1.setCellStyle(blankOrNAStyle);
						} else {
							cellAC1.setCellValue(df2.format(Double.parseDouble(internalLegBean.get(ii).getGreenBandRPMPercentage())));// Green
							// Band
							// RPM
							// (%Time)
							cellAC1.setCellStyle(decimalStyleForLegs);
						}

						cellAD1 = row2.createCell((short) 33);
						if (internalLegBean.get(ii).getMileage().equalsIgnoreCase("") || internalLegBean.get(ii).getMileage().equalsIgnoreCase("NA")) {
							cellAD1.setCellValue(internalLegBean.get(ii).getMileage()); // "" or NA
							cellAD1.setCellStyle(blankOrNAStyle);
						} else {
							cellAD1.setCellValue(df2.format(Double.parseDouble(internalLegBean.get(ii).getMileage()))); // LLS Mileage
							// (KMPL)
							cellAD1.setCellStyle(decimalStyleForLegs);
						}

						cellAE1 = row2.createCell((short) 34);
						if (internalLegBean.get(ii).getOBDMileage().equalsIgnoreCase("") || internalLegBean.get(ii).getOBDMileage().equalsIgnoreCase("NA")) {
							cellAE1.setCellValue(internalLegBean.get(ii).getOBDMileage()); // "" or NA
							cellAE1.setCellStyle(blankOrNAStyle);
						} else {
							cellAE1.setCellValue(df2.format(Double.parseDouble(internalLegBean.get(ii).getOBDMileage()))); // OBD Mileage
							// (KMPL)
							cellAE1.setCellStyle(decimalStyleForLegs);
						}

						cellAF1 = row2.createCell((short) 35);
						if (internalLegBean.get(ii).getFuelConsumed().equalsIgnoreCase("") || internalLegBean.get(ii).getFuelConsumed().equalsIgnoreCase("NA")) {
							cellAF1.setCellValue(internalLegBean.get(ii).getFuelConsumed()); // "" or NA
							cellAF1.setCellStyle(blankOrNAStyle);
						} else {
							cellAF1.setCellValue(df2.format(Double.parseDouble(internalLegBean.get(ii).getFuelConsumed()))); // Fuel
							// Consumed(L)
							cellAF1.setCellStyle(decimalStyleForLegs);
						}

						if (ii == 0) {
							std = internalLegBean.get(ii).getLegSTD();
							atd = internalLegBean.get(ii).getLegATD();
						}
						if (ii == (legBean.get(i).getLegDetails().size() - 1)) {
							sta = internalLegBean.get(ii).getLegSTA();
							ata = internalLegBean.get(ii).getLegATA();

						}

						totalDistance = totalDistance + Double.parseDouble(internalLegBean.get(ii).getTotalDistance());
						totalDuration = totalDuration + Double.parseDouble(internalLegBean.get(ii).getTravelDuration());
						mileage = mileage + Double.parseDouble(internalLegBean.get(ii).getMileage());
						obdMileage = obdMileage + Double.parseDouble(internalLegBean.get(ii).getOBDMileage());
						fuelConsumed = fuelConsumed + Double.parseDouble(internalLegBean.get(ii).getFuelConsumed());

						if ((internalLegBean.get(ii).getLegATA().equalsIgnoreCase("")) && (!internalLegBean.get(ii).getLegATD().equalsIgnoreCase(""))) {
							driver1 = internalLegBean.get(ii).getDriver1();
							driver1Contact = internalLegBean.get(ii).getDriver1Contact();
							driver2 = internalLegBean.get(ii).getDriver2();
							driver2Contact = internalLegBean.get(ii).getDriver2Contact();
						}

					}
					rowNumber++;
					HSSFRow tripNameRow = worksheet.createRow((short) rowNumber);
					tripNameRow.setRowStyle(summaryStyle);

					cellA1 = tripNameRow.createCell((short) 0);
					cellA1.setCellValue(++summaryRowCount);// Seria Number
					cellA1.setCellStyle(summaryStyle);

					cellB1 = tripNameRow.createCell((short) 1);
					cellB1.setCellValue(legBean.get(i).getShipmentId());// Trip
					// ID
					cellB1.setCellStyle(summaryStyle);

					cellD1 = tripNameRow.createCell((short) 2);
					cellD1.setCellValue(legBean.get(i).getLrNo());// LR NO
					cellD1.setCellStyle(summaryStyle);

					cellD1 = tripNameRow.createCell((short) 3);
					cellD1.setCellValue(legBean.get(i).getTripType());// Trip
					// type
					cellD1.setCellStyle(summaryStyle);

					cellD1 = tripNameRow.createCell((short) 4);
					cellD1.setCellValue(legBean.get(i).getTripCategory());// Trip
					// cat
					cellD1.setCellStyle(summaryStyle);

					cellD1 = tripNameRow.createCell((short) 5);
					cellD1.setCellValue(legBean.get(i).getRouteName());// Route
					// ID
					// getRouteName()
					cellD1.setCellStyle(summaryStyle);

					// cellE1 = tripNameRow.createCell((short) 3);
					// cellE1.setCellValue(legBean.get(i).getLrNo());//Trip LR
					// No.
					// cellE1.setCellStyle(summaryStyle);

					cellF1 = tripNameRow.createCell((short) 6);
					cellF1.setCellValue(legBean.get(i).getVehicleNo());// Vehicle
					// Number
					cellF1.setCellStyle(summaryStyle);

					cellG1 = tripNameRow.createCell((short) 7);
					cellG1.setCellValue(legBean.get(i).getMake());// Make of
					// Vehicle
					cellG1.setCellStyle(summaryStyle);

					cellH1 = tripNameRow.createCell((short) 8);
					cellH1.setCellValue(legBean.get(i).getVehicleLength());// Length
					// of
					// Truck
					cellH1.setCellStyle(summaryStyle);

					cellI1 = tripNameRow.createCell((short) 9);
					cellI1.setCellValue(legBean.get(i).getCustRefId());// Customer
					// Reference
					// ID
					cellI1.setCellStyle(summaryStyle);

					cellJ1 = tripNameRow.createCell((short) 10);
					cellJ1.setCellValue(legBean.get(i).getCustomerName());// Customer
					// Name
					cellJ1.setCellStyle(summaryStyle);

					cellK1 = tripNameRow.createCell((short) 11);
					cellK1.setCellValue("");// LegId
					cellK1.setCellStyle(summaryStyle);

					cellL1 = tripNameRow.createCell((short) 12);
					cellL1.setCellValue(driver1);// /Driver 1 Name
					cellL1.setCellStyle(summaryStyle);

					cellM1 = tripNameRow.createCell((short) 13);
					cellM1.setCellValue(driver1Contact);// Driver 1 Contact
					cellM1.setCellStyle(summaryStyle);

					cellN1 = tripNameRow.createCell((short) 14);
					cellN1.setCellValue(driver2);// Driver 2 Name
					cellN1.setCellStyle(summaryStyle);

					cellO1 = tripNameRow.createCell((short) 15);
					cellO1.setCellValue(driver2Contact);// Driver 2 Contact
					cellO1.setCellStyle(summaryStyle);

					cellP1 = tripNameRow.createCell((short) 16);
					cellP1.setCellValue(legBean.get(i).getOrigin());// Origin
					cellP1.setCellStyle(summaryStyle);

					cellQ1 = tripNameRow.createCell((short) 17);
					cellQ1.setCellValue(legBean.get(i).getDestination());// Destination
					cellQ1.setCellStyle(summaryStyle);

					cellR1 = tripNameRow.createCell((short) 18);
					cellR1.setCellValue(std);// STD
					cellR1.setCellStyle(dateStyleForTrips);

					cellS1 = tripNameRow.createCell((short) 19);
					cellS1.setCellValue(atd);// ATD
					cellS1.setCellStyle(dateStyleForTrips);
					// departureDelaywrtSTD
					cellS1 = tripNameRow.createCell((short) 20);
					cellS1.setCellValue(legBean.get(i).getDepartureDelayWrtSTD());// ATD
					cellS1.setCellStyle(dateStyleForTrips);

					// plannedTransitTime
					cellS1 = tripNameRow.createCell((short) 21);
					cellS1.setCellValue(legBean.get(i).getPlannedTransitTime());// ATD
					cellS1.setCellStyle(dateStyleForTrips);

					cellT1 = tripNameRow.createCell((short) 22);
					cellT1.setCellValue(legBean.get(i).getETA());// ETA
					cellT1.setCellStyle(dateStyleForTrips);

					cellU1 = tripNameRow.createCell((short) 23);
					cellU1.setCellValue(sta);// STA
					cellU1.setCellStyle(dateStyleForTrips);

					cellV1 = tripNameRow.createCell((short) 24);
					cellV1.setCellValue(ata);// ATA
					cellV1.setCellStyle(dateStyleForTrips);

					// actualTransitTime
					cellS1 = tripNameRow.createCell((short) 25);
					cellS1.setCellValue(legBean.get(i).getActualTransitTime());// ATD
					cellS1.setCellStyle(dateStyleForTrips);

					cellW1 = tripNameRow.createCell((short) 26);
					cellW1.setCellValue(legBean.get(i).getDelay());// Total
					// Delay
					// (HH:mm)
					cellW1.setCellStyle(timeStyleForTrips);

					cellX1 = tripNameRow.createCell((short) 27);
					cellX1.setCellValue(df2.format(totalDistance));// Distance
					// (Kms)
					cellX1.setCellStyle(summaryStyle);

					cellY1 = tripNameRow.createCell((short) 28);
					cellY1.setCellValue(cf.convertMinutesToHHMMFormat(totalDuration.intValue()));// Duration (Kms)
					cellY1.setCellStyle(summaryStyle);

					Double totAvgSpeed = totalDuration > 0.0 ? ((totalDistance / totalDuration) * 60) : 0.0;
					cellZ1 = tripNameRow.createCell((short) 29);
					cellZ1.setCellValue(df2.format(totAvgSpeed));// Avg.
					// Speed(Kmph)
					cellZ1.setCellStyle(decimalStyleForTrips);

					cellAA1 = tripNameRow.createCell((short) 30);
					cellAA1.setCellValue(cf.convertMinutesToHHMMFormat(Integer.parseInt(legBean.get(i).getTotalStopDuration())));// Total
					// Stoppage
					// Time(HH:mm)
					cellAA1.setCellStyle(timeStyleForTrips);

					cellAB1 = tripNameRow.createCell((short) 31);
					cellAB1.setCellValue(df2.format(Double.parseDouble(legBean.get(i).getWeightedGreenBandSpeed())));// Green Band
					// Speed (%
					// time)
					cellAB1.setCellStyle(decimalStyleForTrips);

					cellAC1 = tripNameRow.createCell((short) 32);
					cellAC1.setCellValue(df2.format(Double.parseDouble(legBean.get(i).getWeightedGreenBandRPM())));// Green Band
					// RPM
					// (%Time)
					cellAC1.setCellStyle(decimalStyleForTrips);

					cellAD1 = tripNameRow.createCell((short) 33);
					cellAD1.setCellValue(df2.format(Double.parseDouble(legBean.get(i).getLlsMileage()))); // LLS Mileage (KMPL)
					cellAD1.setCellStyle(decimalStyleForTrips);

					cellAE1 = tripNameRow.createCell((short) 34);
					cellAE1.setCellValue(df2.format(Double.parseDouble(legBean.get(i).getObdMileageForSLALegReport()))); // OBD
					// Mileage
					// (KMPL)
					cellAE1.setCellStyle(decimalStyleForTrips);

					cellAF1 = tripNameRow.createCell((short) 35);
					cellAF1.setCellValue(df2.format(fuelConsumed)); // Fuel
					// Consumed(L)
					cellAF1.setCellStyle(decimalStyleForTrips);

					// rowNumber++;
				}
				// else
				// {
				// HSSFRow legNorFound = worksheet.createRow((short)rowNumber);
				// HSSFCell celltrip = legNorFound.createCell((short) 0);
				// celltrip.setCellValue("Leg not found for "+legBean.get(i).getShipmentId());
				// celltrip.setCellStyle(styleForCustomer);
				// worksheet.addMergedRegion(new
				// Region(rowNumber,(short)0,rowNumber,(short)13));
				// }
			}

			workbook.write(fileOut);
			fileOut.flush();
			fileOut.close();

			// workbook.write(response.getOutputStream());

		} catch (Exception e) {
			e.printStackTrace();
		}
		return completePath;
	}

	public JSONArray getUnAssigendVehiclesLatLng(int offset, int clientId, int systemId) {

		JSONArray BufferArray = new JSONArray();
		JSONObject BufferObject = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			BufferArray = new JSONArray();
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(GeneralVerticalStatements.GET_UNASSIGNED_VEHICLE_LATLNG);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, clientId);

			rs = pstmt.executeQuery();
			while (rs.next()) {
				BufferObject = new JSONObject();
				BufferObject.put("vehicleNo", rs.getString("REGISTRATION_NO"));
				BufferObject.put("latitude", rs.getString("LATITUDE"));
				BufferObject.put("longitude", rs.getString("LONGITUDE"));

				BufferArray.put(BufferObject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return BufferArray;

	}

	public JSONArray getAssigendEnrouteVehiclesLatLng(int offset, int clientId, int systemId) {

		JSONArray BufferArray = new JSONArray();
		JSONObject BufferObject = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			BufferArray = new JSONArray();
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(GeneralVerticalStatements.GET_ASSIGNED_ENROUTE_VEHICLE_LATLNG);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, clientId);

			rs = pstmt.executeQuery();
			while (rs.next()) {
				BufferObject = new JSONObject();
				BufferObject.put("vehicleNo", rs.getString("REGISTRATION_NO"));
				BufferObject.put("latitude", rs.getString("LATITUDE"));
				BufferObject.put("longitude", rs.getString("LONGITUDE"));

				BufferArray.put(BufferObject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return BufferArray;

	}

	public JSONArray getAssigendPlacedVehiclesLatLng(int offset, int clientId, int systemId) {

		JSONArray BufferArray = new JSONArray();
		JSONObject BufferObject = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			BufferArray = new JSONArray();
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(GeneralVerticalStatements.GET_ASSIGNED_PLACED_VEHICLE_LATLNG);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, clientId);

			rs = pstmt.executeQuery();
			while (rs.next()) {
				BufferObject = new JSONObject();
				BufferObject.put("vehicleNo", rs.getString("REGISTRATION_NO"));
				BufferObject.put("latitude", rs.getString("LATITUDE"));
				BufferObject.put("longitude", rs.getString("LONGITUDE"));

				BufferArray.put(BufferObject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return BufferArray;
	}

	public JSONArray getTrucksAvailable(int hrs, int offset, int clientId, int systemId) {

		JSONArray jsonArray = new JSONArray();
		JSONObject obj = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			jsonArray = new JSONArray();
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(GeneralVerticalStatements.GET_FUTURE_AVAILABLE_TRUCKS);
			pstmt.setInt(1, offset);
			pstmt.setInt(2, hrs);
			pstmt.setInt(3, systemId);
			pstmt.setInt(4, clientId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				obj = new JSONObject();
				obj.put("vehicleNo", rs.getString("REGISTRATION_NO"));
				obj.put("latitude", rs.getString("LATITUDE"));
				obj.put("longitude", rs.getString("LONGITUDE"));
				obj.put("loc", rs.getString("LOCATION"));
				obj.put("eta", rs.getString("ETA"));

				jsonArray.put(obj);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jsonArray;

	}

	public JSONArray getDriverDetails(int clientId, int systemId, String Status) {
		JSONArray jsonArray = new JSONArray();
		JSONObject obj = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			int count = 0;
			jsonArray = new JSONArray();
			con = DBConnection.getConnectionToDB("AMS");
			StringBuffer query = new StringBuffer();
			query.append(GeneralVerticalStatements.GET_DRIVERS_FOR_UTILIZATION);
			if (Status.equalsIgnoreCase("OPEN")) {
				query.append(" and c.STATUS='OPEN' ");
			} else {
				query.append(" and c.STATUS<>'OPEN' ");
			}
			pstmt = con.prepareStatement(query.toString());
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, clientId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				obj = new JSONObject();
				obj.put("slno", ++count);
				obj.put("driverId", rs.getInt("id"));
				obj.put("driverName", rs.getString("DriverName"));
				jsonArray.put(obj);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jsonArray;

	}

	public JSONArray getRouteVehicleDetails(int systemId, int clientId, String custList) {
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonobject = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		// String query=GeneralVerticalStatements.GET_ROUTE_DETAILS;
		String query = GeneralVerticalStatements.GET_ROUTE_DETAILS_FOR_LIST_VIEW;

		try {
			jsonArray = new JSONArray();
			con = DBConnection.getConnectionToDB("AMS");

			String array1 = (custList.substring(0, custList.length() - 1));
			// String newRouteList
			// ="'"+array1.toString().replace("[","").replace("]",
			// "").replace(" ","").replace(",","','")+"'";
			// String newRouteList
			// ="'"+array1.toString().replace(",","','")+"'";

			query = query.replace("#", " and TRIP_CUSTOMER_ID in (" + array1 + ")");

			// pstmt =
			// con.prepareStatement(GeneralVerticalStatements.GET_ROUTE_DETAILS.replace("#",
			// " and CUSTOMER_NAME in ("+newRouteList +")"));

			// pstmt =
			// con.prepareStatement(GeneralVerticalStatements.GET_ROUTE_DETAILS.replace("#",
			// " and CUSTOMER_NAME='"+CustomerName+"'" ));
			// if(custList.equalsIgnoreCase("All")){
			// pstmt =
			// con.prepareStatement(GeneralVerticalStatements.GET_ROUTE_DETAILS.replace("#",
			// ""));
			// }else{
			// pstmt =
			// con.prepareStatement(GeneralVerticalStatements.GET_ROUTE_DETAILS.replace("#",
			// " and CUSTOMER_NAME='"+CustomerName+"'" ));
			// }
			pstmt = con.prepareStatement(query);
			pstmt.setInt(1, systemId);
			rs = pstmt.executeQuery();

			while (rs.next()) {
				jsonobject = new JSONObject();
				jsonobject.put("routeId", rs.getString("ROUTE_ID"));
				jsonobject.put("routeName", rs.getString("RouteName"));
				jsonArray.put(jsonobject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jsonArray;
	}

	public int getUserAssociatedCustomerID(int userId, int systemId) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		// String customerName="";
		int customerId = 0;
		// String customerId = "";
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(CommonStatements.GET_USER_ASSOCIATED_CUSTOMER_ID);
			pstmt.setInt(1, userId);
			pstmt.setInt(2, systemId);
			// pstmt.setInt(3, clientId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				customerId = Integer.parseInt(rs.getString("ID"));
			}

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return customerId;
	}

	public JSONArray getCustNamesForSLA(int custId, int systemId) {

		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			con = DBConnection.getConnectionToDB("AMS");
			jsonArray = new JSONArray();
			jsonObject = new JSONObject();
			pstmt = con.prepareStatement(GeneralVerticalStatements.GET_CUSTOMERS_FOR_SLA);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, custId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				jsonObject = new JSONObject();
				jsonObject.put("CustId", rs.getString("TRIP_CUSTOMER_ID"));
				jsonObject.put("CustName", rs.getString("NAME"));
				jsonArray.put(jsonObject);
			}
		} catch (Exception e) {
			System.out.println("Error in getCustomer :: " + e.toString());
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jsonArray;
	}

	@SuppressWarnings("static-access")
	public String CreateDriverPerformanceExcelExport(JSONArray legBean, String startDate, String endDate) {

		String completePath = null;
		try {

			String name = "Driver Performance Report";
			Properties properties = ApplicationListener.prop;
			String rootPath = properties.getProperty("driverPerformanceLegwiseExcelExport");

			completePath = rootPath + "//" + name + "_" + sdfDBMMDD.format(sdfDB.parse(startDate)) + "_" + sdfDBMMDD.format(sdfDB.parse(endDate)) + ".xls";

			File f = new File(rootPath);
			if (!f.exists()) {
				f.mkdir();
			}

			FileOutputStream fileOut = new FileOutputStream(completePath);

			HSSFWorkbook workbook = new HSSFWorkbook();
			HSSFSheet worksheet = workbook.createSheet("Report");
			HSSFRow customerNameRow = null;

			HSSFFont font = null;
			font = workbook.createFont();
			font.setBoldweight(Font.BOLDWEIGHT_BOLD);

			HSSFFont titleFont = null;
			titleFont = workbook.createFont();
			titleFont.setFontName(HSSFFont.FONT_ARIAL);
			titleFont.setFontHeightInPoints((short) 15);
			titleFont.setBoldweight(Font.BOLDWEIGHT_BOLD);

			HSSFCellStyle headerStyle = workbook.createCellStyle();
			headerStyle.setFont(titleFont);
			headerStyle.setAlignment(headerStyle.ALIGN_CENTER);

			HSSFCellStyle styleForCustomer = workbook.createCellStyle();
			styleForCustomer.setFont(font);
			styleForCustomer.setAlignment(styleForCustomer.ALIGN_LEFT);
			// styleForCustomer.setBorderBottom(HSSFCellStyle.BORDER_MEDIUM);

			HSSFCellStyle style1 = workbook.createCellStyle();
			style1.setFont(font);

			HSSFRow row = worksheet.createRow((short) 0);
			worksheet.createFreezePane(0, 4);

			HSSFCell titleCellC1 = row.createCell((short) 0);
			titleCellC1.setCellValue("Driver Performance Leg Wise Details");
			titleCellC1.setCellStyle(headerStyle);
			worksheet.addMergedRegion(new Region(0, (short) 0, 1, (short) 13));

			// System.out.println("legBean.size() ::"+legBean.size());
			int rowNumber = 3;

			HSSFRow row1 = worksheet.createRow((short) rowNumber);

			HSSFCell cellA1 = row1.createCell((short) 0);
			cellA1.setCellValue("Sl No.");
			cellA1.setCellStyle(style1);

			HSSFCell cellB1 = row1.createCell((short) 1);
			cellB1.setCellValue("Leg Name");
			cellB1.setCellStyle(style1);

			HSSFCell cellD1 = row1.createCell((short) 2);
			cellD1.setCellValue("Trip Name");
			cellD1.setCellStyle(style1);

			HSSFCell cellE1 = row1.createCell((short) 3);
			cellE1.setCellValue("Harsh Acceleration (per Hr)");
			cellE1.setCellStyle(style1);

			HSSFCell cellF1 = row1.createCell((short) 4);
			cellF1.setCellValue("Harsh Braking (per Hr)");
			cellF1.setCellStyle(style1);

			HSSFCell cellG1 = row1.createCell((short) 5);
			cellG1.setCellValue("Harsh Cornering (per Hr)");
			cellG1.setCellStyle(style1);

			HSSFCell cellH1 = row1.createCell((short) 6);
			cellH1.setCellValue("Overspeeding (per Hr)");
			cellH1.setCellStyle(style1);

			HSSFCell cellI1 = row1.createCell((short) 7);
			cellI1.setCellValue("Total Freewheeling Time (%Time)");
			cellI1.setCellStyle(style1);

			HSSFCell cellJ1 = row1.createCell((short) 8);
			cellJ1.setCellValue("Unscheduled Stoppage Time (%Time)");
			cellJ1.setCellStyle(style1);

			HSSFCell cellK1 = row1.createCell((short) 9);
			cellK1.setCellValue("Excessive Idling Time (%Time)");
			cellK1.setCellStyle(style1);

			HSSFCell cellL1 = row1.createCell((short) 10);
			cellL1.setCellValue("Green Band Speed (%Time)");
			cellL1.setCellStyle(style1);

			HSSFCell cellM1 = row1.createCell((short) 11);
			cellM1.setCellValue("Erratic Speeding (%Time)");
			cellM1.setCellStyle(style1);

			HSSFCell cellN1 = row1.createCell((short) 12);
			cellN1.setCellValue("Green Band RPM (%Time)");
			cellN1.setCellStyle(style1);

			HSSFCell cellO1 = row1.createCell((short) 13);
			cellO1.setCellValue("Low RPM (%Time)");
			cellO1.setCellStyle(style1);

			HSSFCell cellP1 = row1.createCell((short) 14);
			cellP1.setCellValue("High RPM (%Time)");
			cellP1.setCellStyle(style1);

			HSSFCell cellQ1 = row1.createCell((short) 15);
			cellQ1.setCellValue("Over-Revving");
			cellQ1.setCellStyle(style1);

			HSSFCell cellR1 = row1.createCell((short) 16);
			cellR1.setCellValue("LLS Mileage KMPL");
			cellR1.setCellStyle(style1);

			HSSFCell cellS1 = row1.createCell((short) 17);
			cellS1.setCellValue("OBD Mileage KMPL");
			cellS1.setCellStyle(style1);

			for (int i = 0; i < legBean.length(); i++) {
				// rowNumber++;
				if (legBean.getJSONObject(i).length() > 0) {
					rowNumber++;
					customerNameRow = worksheet.createRow((short) rowNumber);

					HSSFCell cellC1 = customerNameRow.createCell((short) 0);
					// cellC1.setCellValue(legBean.get(i).getCustomerName());
					cellC1.setCellStyle(styleForCustomer);
					worksheet.addMergedRegion(new Region(rowNumber, (short) 0, rowNumber, (short) 13));

					rowNumber++;

					HSSFRow tripNameRow = worksheet.createRow((short) rowNumber);
					HSSFCell celltrip = tripNameRow.createCell((short) 0);
					celltrip.setCellValue("Driver ID: " + legBean.getJSONObject(i).get("nameCIndex") + " - " + legBean.getJSONObject(i).get("empIdCIndex"));
					celltrip.setCellStyle(styleForCustomer);

					worksheet.addMergedRegion(new Region(rowNumber, (short) 0, rowNumber, (short) 13));
					for (int ii = 0; ii < legBean.getJSONObject(i).getJSONArray("legdetails").length(); ii++) {
						JSONObject internalLegBean = legBean.getJSONObject(i).getJSONArray("legdetails").getJSONObject(ii);
						// String customerName =
						// internalLegBean.getShipmentId();
						// System.out.println(" legBean.get(i).getLegDetails().size();;"+
						// legBean.get(i).getLegDetails().size());

						rowNumber++;
						HSSFRow row2 = worksheet.createRow((short) rowNumber);

						cellA1 = row2.createCell((short) 0);// createCell((short)
						// 0);
						// cellA1.setCellValue(String.valueOf(ii + 1));
						cellA1.setCellValue(ii + 1);

						cellB1 = row2.createCell((short) 1);// createCell((short)
						// 0);
						cellB1.setCellValue(internalLegBean.get("legName").toString());
						// cellB1.setCellValue("leg1");

						cellD1 = row2.createCell((short) 2);
						cellD1.setCellValue(internalLegBean.get("tripName").toString());
						// cellD1.setCellValue("leg1");

						cellE1 = row2.createCell((short) 3);
						cellE1.setCellValue(internalLegBean.get("haCount").toString());
						// cellE1.setCellValue("leg1");

						cellF1 = row2.createCell((short) 4);
						cellF1.setCellValue(internalLegBean.get("hbCount").toString());
						// cellF1.setCellValue("leg1");

						cellG1 = row2.createCell((short) 5);
						cellG1.setCellValue(internalLegBean.get("hcCount").toString());
						// cellG1.setCellValue("leg1");

						cellH1 = row2.createCell((short) 6);
						cellH1.setCellValue(internalLegBean.get("overspeedingCount").toString());
						// cellH1.setCellValue("leg1");

						cellI1 = row2.createCell((short) 7);
						cellI1.setCellValue(internalLegBean.get("freewheelingCount").toString());
						// cellI1.setCellValue("leg1");

						cellJ1 = row2.createCell((short) 8);
						cellJ1.setCellValue(internalLegBean.get("unscheduledStoppageCount").toString());
						// cellJ1.setCellValue("leg1");

						cellK1 = row2.createCell((short) 9);
						cellK1.setCellValue(internalLegBean.get("excessiveIdlingCount").toString());
						// cellK1.setCellValue("leg1");

						cellL1 = row2.createCell((short) 10);
						cellL1.setCellValue(internalLegBean.get("greenBandSpeedCount").toString());
						// cellL1.setCellValue("leg1");

						cellM1 = row2.createCell((short) 11);
						cellM1.setCellValue(internalLegBean.get("erraticSpeedingCount").toString());
						// cellM1.setCellValue("leg1");

						cellN1 = row2.createCell((short) 12);
						cellN1.setCellValue(internalLegBean.get("greenBandRpmCount").toString());
						// cellN1.setCellValue("leg1");

						cellO1 = row2.createCell((short) 13);
						cellO1.setCellValue(internalLegBean.get("lowRPMCount").toString());
						// cellO1.setCellValue("leg1");

						cellP1 = row2.createCell((short) 14);
						cellP1.setCellValue(internalLegBean.get("highRPMCount").toString());
						// cellP1.setCellValue("leg1");

						cellQ1 = row2.createCell((short) 15);
						cellQ1.setCellValue(internalLegBean.get("overRevvingCount").toString());

						cellR1 = row2.createCell((short) 16);
						cellR1.setCellValue(internalLegBean.get("mileage").toString());

						cellS1 = row2.createCell((short) 17);
						cellS1.setCellValue(internalLegBean.get("obdMileage").toString());
					}
					// rowNumber++;
				}
				// else
				// {
				// HSSFRow legNorFound = worksheet.createRow((short)rowNumber);
				// HSSFCell celltrip = legNorFound.createCell((short) 0);
				// celltrip.setCellValue("Leg not found for "+legBean.get(i).getShipmentId());
				// celltrip.setCellStyle(styleForCustomer);
				// worksheet.addMergedRegion(new
				// Region(rowNumber,(short)0,rowNumber,(short)13));
				// }
			}

			workbook.write(fileOut);
			fileOut.flush();
			fileOut.close();

			// workbook.write(response.getOutputStream());

		} catch (Exception e) {
			e.printStackTrace();
		}
		return completePath;
	}

	public JSONArray getAllRouteTemplates(int systemId, int clientId, int tripCustId) {
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonobject = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int count = 0;
		try {
			jsonArray = new JSONArray();
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(GeneralVerticalStatements.GET_ALL_ROUTE_TEMPLATE);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, clientId);
			pstmt.setInt(3, tripCustId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				count++;
				jsonobject = new JSONObject();
				jsonobject.put("slNoIndex", count);
				jsonobject.put("ID", rs.getString("ID"));
				jsonobject.put("templateName", rs.getString("NAME"));
				jsonobject.put("routeName", rs.getString("ROUTE_NAME"));
				jsonobject.put("routeId", rs.getString("ROUTE_ID"));
				jsonobject.put("materialName", rs.getString("MATERIALS"));
				jsonobject.put("view", "<button class='btn btn-primary'>View</button>");
				jsonobject.put("modify", "<button class='btn btn-primary'>Modify</button>");
				jsonArray.put(jsonobject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jsonArray;
	}

	public JSONArray getAllMaterialsByTemplateId(int templateId, int systemId, int clientId, int tripCustId) {
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonobject = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int count = 0;
		try {
			jsonArray = new JSONArray();
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(GeneralVerticalStatements.GET_MATERIALS_TOTAL_TAT);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, clientId);
			pstmt.setInt(3, tripCustId);
			pstmt.setInt(4, templateId);
			rs = pstmt.executeQuery();
			Double doubleVal;
			long milliseconds;
			while (rs.next()) {
				count++;
				jsonobject = new JSONObject();
				jsonobject.put("materialId", rs.getString("MATERIAL_ID"));
				jsonobject.put("materialName", rs.getString("MATERIAL_NAME"));
				doubleVal = Double.parseDouble(rs.getString("TotalTAT"));
				milliseconds = new Double(doubleVal).longValue() * 60 * 1000;
				jsonobject.put("totalTAT", cf.formattedDaysHoursMinutes(milliseconds));
				doubleVal = Double.parseDouble(rs.getString("TotalRunTime"));
				milliseconds = new Double(doubleVal).longValue() * 60 * 1000;
				jsonobject.put("totalRunTime", cf.formattedDaysHoursMinutes(milliseconds));
				jsonArray.put(jsonobject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jsonArray;
	}

	public JSONArray getRouteTemplateDetailsById(int id) {
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonobject = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int count = 0;
		Double doubleVal;
		long milliseconds;
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(GeneralVerticalStatements.GET_ROUTE_TEMPLATE_BY_ID);
			pstmt.setInt(1, id);
			rs = pstmt.executeQuery();
			Map<String, JSONArray> materialToLegTATDetailsMap = new HashMap<String, JSONArray>();
			Map<String, JSONObject> materialToLegTotalTATDetailsMap = new HashMap<String, JSONObject>();
			while (rs.next()) {
				count++;
				int materilId = rs.getInt("MATERIAL_ID");
				String materialName = rs.getString("MATERIAL_NAME");
				JSONObject legTatdetails = new JSONObject();
				legTatdetails.put("legId", rs.getString("LEG_ID"));
				legTatdetails.put("legName", rs.getString("LEG_NAME"));
				doubleVal = Double.parseDouble(rs.getString("TAT"));
				milliseconds = new Double(doubleVal).longValue() * 60 * 1000;
				legTatdetails.put("TAT", cf.formattedDaysHoursMinutes(milliseconds));

				doubleVal = Double.parseDouble(rs.getString("RUN_TIME"));
				milliseconds = new Double(doubleVal).longValue() * 60 * 1000;
				legTatdetails.put("runtime", cf.formattedDaysHoursMinutes(milliseconds));

				doubleVal = Double.parseDouble(rs.getString("DETENTION"));
				milliseconds = new Double(doubleVal).longValue() * 60 * 1000;
				legTatdetails.put("detention", cf.formattedDaysHoursMinutes(milliseconds));
				JSONObject legTatTotaldetails = new JSONObject();
				legTatTotaldetails.put("totalTAT", cf.formattedDaysHoursMinutes(rs.getLong("TotalTAT") * 60 * 1000));
				legTatTotaldetails.put("totalRunTime", cf.formattedDaysHoursMinutes(rs.getLong("TotalRunTime") * 60 * 1000));
				legTatTotaldetails.put("totalStoppage", cf.formattedDaysHoursMinutes(rs.getLong("TotalDetention") * 60 * 1000));
				String key = materilId + "+" + materialName;// eg. 1+Blade
				if (materialToLegTATDetailsMap.containsKey(key)) {
					JSONArray legTATdetailsArray = materialToLegTATDetailsMap.get(key);
					legTATdetailsArray.put(legTatdetails);
				} else {
					JSONArray legTATdetailsArray = new JSONArray();
					legTATdetailsArray.put(legTatdetails);
					materialToLegTATDetailsMap.put(key, legTATdetailsArray);
				}
				materialToLegTotalTATDetailsMap.put(key, legTatTotaldetails);
			}
			jsonArray = new JSONArray();
			for (String key : materialToLegTATDetailsMap.keySet()) {
				jsonobject = new JSONObject();
				jsonobject.put("materialID", key.split("\\+")[0]);
				jsonobject.put("materialName", key.split("\\+")[1]);
				jsonobject.put("legTATdetails", materialToLegTATDetailsMap.get(key));
				jsonobject.put("totalTAT", materialToLegTotalTATDetailsMap.get(key).get("totalTAT"));
				jsonobject.put("totalRunTime", materialToLegTotalTATDetailsMap.get(key).get("totalRunTime"));
				jsonobject.put("totalStoppage", materialToLegTotalTATDetailsMap.get(key).get("totalStoppage"));

				jsonArray.put(jsonobject);
			}

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jsonArray;
	}

	@SuppressWarnings("unchecked")
	public String saveRouteTemplate(String templateName, int routeId, int systemId, int clientId, int userId, int tripCustId, List routelegMaterialAssocList) {
		Connection con = null;
		PreparedStatement pstmt = null;
		PreparedStatement pstmt1 = null;
		ResultSet rs = null;
		try {
			con = DBConnection.getConnectionToDB("AMS");

			pstmt = con.prepareStatement(GeneralVerticalStatements.INSERT_ROUTE_TEMPLATE, PreparedStatement.RETURN_GENERATED_KEYS);
			pstmt.setString(1, templateName);
			pstmt.setInt(2, routeId);
			pstmt.setInt(3, systemId);
			pstmt.setInt(4, clientId);
			pstmt.setInt(5, tripCustId);
			pstmt.setInt(6, userId);
			int templateId = pstmt.executeUpdate();
			rs = pstmt.getGeneratedKeys();
			if (rs.next()) {
				templateId = rs.getInt(1);
			}
			pstmt1 = con.prepareStatement(GeneralVerticalStatements.INSERT_ROUTE_LEG_MATERIAL_ASSOC);
			for (int i = 0; i < routelegMaterialAssocList.size(); i++) { // Implement
				// batch
				// update
				LinkedTreeMap map = (LinkedTreeMap) routelegMaterialAssocList.get(i);
				if ("Y".equals(map.get("saved").toString()) && "N".equals(map.get("deleted").toString())) {
					pstmt1.setInt(1, templateId);
					pstmt1.setString(2, map.get("materialId").toString());
					pstmt1.setInt(3, new Double(map.get("legId").toString()).intValue());
					pstmt1.setDouble(4, cf.convertDDHHMMToMinutes(map.get("TAT").toString()));
					pstmt1.setDouble(5, cf.convertDDHHMMToMinutes(map.get("runtime").toString()));
					pstmt1.setInt(6, cf.convertDDHHMMToMinutes(map.get("detention").toString()));
					pstmt1.setInt(7, systemId);
					pstmt1.setInt(8, clientId);
					pstmt1.setInt(9, tripCustId);
					pstmt1.addBatch();
				}
			}
			int[] result = pstmt1.executeBatch();
			if (result.length > 0) {
				return "SUCCESS";
			}
		} catch (Exception e) {
			System.out.println("Error in saveRouteTemplate :: " + e.toString());
			e.printStackTrace();
			return e.toString();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return "FAILURE";
	}

	@SuppressWarnings("unchecked")
	public String updateRouteTemplate(int templateId, int systemId, int clientId, int userId, int tripCustId, List routelegMaterialAssocList) {
		Connection con = null;
		PreparedStatement pstmt = null;
		PreparedStatement pstmt1 = null;
		ResultSet rs = null;
		try {
			con = DBConnection.getConnectionToDB("AMS");
			con.setAutoCommit(false);
			pstmt = con.prepareStatement(GeneralVerticalStatements.GET_MATERIALS_BY_TEMPLATE_ID);
			pstmt.setInt(1, templateId);
			rs = pstmt.executeQuery();
			HashSet<Integer> existingIdsInDB = new HashSet<Integer>();
			while (rs.next()) {
				existingIdsInDB.add(rs.getInt("MATERIAL_ID"));
			}

			pstmt = con.prepareStatement(GeneralVerticalStatements.UPDATE_ROUTE_TEMPLATE);
			pstmt.setInt(1, userId);
			pstmt.setInt(2, templateId);
			pstmt.executeUpdate();

			// update existing materail
			// insert new material
			// delete material - soft deletion
			for (int i = 0; i < routelegMaterialAssocList.size(); i++) {
				LinkedTreeMap map = (LinkedTreeMap) routelegMaterialAssocList.get(i);
				if ("Y".equals(map.get("saved").toString()) && "N".equals(map.get("deleted").toString())) {
					int materailId = Integer.parseInt(map.get("materialId").toString());
					if (existingIdsInDB.contains(materailId)) { // update
						pstmt1 = con.prepareStatement(GeneralVerticalStatements.UPDATE_ROUTE_LEG_MATERIAL_ASSOC);
						pstmt1.setDouble(1, cf.convertDDHHMMToMinutes(map.get("TAT").toString()));
						pstmt1.setDouble(2, cf.convertDDHHMMToMinutes(map.get("runtime").toString()));
						pstmt1.setInt(3, cf.convertDDHHMMToMinutes(map.get("detention").toString()));
						pstmt1.setInt(4, templateId);
						pstmt1.setString(5, map.get("materialId").toString());
						pstmt1.setInt(6, new Double(map.get("legId").toString()).intValue());
						pstmt1.executeUpdate();

					} else { // insert
						pstmt1 = con.prepareStatement(GeneralVerticalStatements.INSERT_ROUTE_LEG_MATERIAL_ASSOC);
						pstmt1.setInt(1, templateId);
						pstmt1.setString(2, map.get("materialId").toString());
						pstmt1.setInt(3, new Double(map.get("legId").toString()).intValue());
						pstmt1.setDouble(4, cf.convertDDHHMMToMinutes(map.get("TAT").toString()));
						pstmt1.setDouble(5, cf.convertDDHHMMToMinutes(map.get("runtime").toString()));
						pstmt1.setInt(6, cf.convertDDHHMMToMinutes(map.get("detention").toString()));
						pstmt1.setInt(7, systemId);
						pstmt1.setInt(8, clientId);
						pstmt1.setInt(9, tripCustId);
						pstmt1.executeUpdate();
					}
				} else if ("Y".equals(map.get("deleted").toString())) {// delete
					pstmt1 = con.prepareStatement(GeneralVerticalStatements.DELETE_ROUTE_LEG_MATERIAL_ASSOC);
					pstmt1.setInt(1, templateId);
					pstmt1.setString(2, map.get("materialId").toString());
					pstmt1.setInt(3, new Double(map.get("legId").toString()).intValue());
					pstmt1.executeUpdate();
				}
			}
			con.commit();

		} catch (SQLException e) {
			e.printStackTrace();
			try {
				con.rollback();
			} catch (SQLException e1) {
				System.out.println("SQLException in rollback" + e.getMessage());
			}
		} catch (Exception e) {
			e.printStackTrace();
			return "Failure";
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return "SUCCESS";
	}

	public String updateMaterialMasterDetails(String materialName, Integer systemId, Integer userId, Integer clientId, Integer id) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String message = "";
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(GeneralVerticalStatements.UPDATE_MATERIAL_MASTER);
			pstmt.setString(1, materialName);
			pstmt.setInt(2, id);
			int inserted = pstmt.executeUpdate();
			if (inserted > 0) {
				message = "Updated Successfully";
			} else {
				message = "Not updated";
			}

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return message;
	}

	public String deleteMaterialMasterDetails(String materialName, Integer systemId, Integer userId, Integer clientId, Integer id) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String message = "";
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(GeneralVerticalStatements.DELETE_MATERIAL_MASTER);
			pstmt.setInt(1, id);

			int inserted = pstmt.executeUpdate();
			if (inserted > 0) {
				message = "Deleted Successfully";
			} else {
				message = "Not deleted";
			}

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return message;
	}

	public JSONArray getMaterialMasterDetails(Integer systemId, Integer clientId) {
		JSONArray jsonArray = null;
		JSONObject jsonObject = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int count = 0;
		try {
			jsonArray = new JSONArray();
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(GeneralVerticalStatements.GET_MATERIAL_MASTER);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, clientId);
			rs = pstmt.executeQuery();

			while (rs.next()) {
				jsonObject = new JSONObject();
				jsonObject.put("slNo", ++count);
				jsonObject.put("idIndex", rs.getString("ID"));
				jsonObject.put("materialNameIndex", rs.getString("MATERIAL_NAME"));
				jsonObject.put("editButton", "<button onclick=openModal1('" + rs.getString("ID") + "','" + rs.getString("MATERIAL_NAME").replace(" ", "^").trim()
						+ "'); class='btn btn-success btn-sm text-center'>Edit</button>");
				jsonObject.put("deleteButton", "<button onclick=openModal2('" + rs.getString("ID") + "','" + rs.getString("MATERIAL_NAME").replace(" ", "^").trim()
						+ "'); class='btn btn-success btn-sm text-center'>Delete</button>");
				jsonArray.put(jsonObject);
			}

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jsonArray;
	}

	public String saveMaterialMasterDetails(String materialName, Integer systemId, Integer userId, Integer clientId, Integer offset) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String message = "";
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(GeneralVerticalStatements.INSERT_MATERIAL_MASTER);
			pstmt.setString(1, materialName);
			pstmt.setInt(2, clientId);
			pstmt.setInt(3, systemId);

			int inserted = pstmt.executeUpdate();
			if (inserted > 0) {
				message = "Saved Successfully";
			} else {
				message = "Not saved";
			}

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return message;
	}

	public JSONArray getOnTripVehiclesStoppage(int systemId, int clientId, String zone) {
		JSONArray jsonArray = null;
		JSONObject jsonObject = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			jsonArray = new JSONArray();
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(GeneralVerticalStatements.GET_ON_TRIP_VEHICLE_STOPPAGE.replaceAll("AMS.dbo.LOCATION", "AMS.dbo.LOCATION_ZONE_" + zone));
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, clientId);
			pstmt.setInt(3, systemId);
			pstmt.setInt(4, clientId);
			rs = pstmt.executeQuery();

			while (rs.next()) {
				jsonObject = new JSONObject();
				jsonObject.put("tripId", rs.getString("TRIP_ID"));
				jsonObject.put("shipmentId", rs.getString("SHIPMENT_ID"));
				jsonObject.put("lrNumber", rs.getString("LR_NO"));
				jsonObject.put("assetNumber", rs.getString("ASSET_NUMBER"));
				jsonObject.put("routeName", rs.getString("ROUTE_NAME"));
				jsonObject.put("longitude", rs.getString("LONGITUDE"));
				jsonObject.put("latitude", rs.getString("LATITUDE"));
				jsonObject.put("location", rs.getString("LOCATION"));
				String durationHHMM = convertHourToHourMinutes(rs.getString("DURATION"));
				jsonObject.put("duration", convertHourToHourMinutes(rs.getString("DURATION")));
				jsonObject.put("tripCustomerId", rs.getString("TRIP_CUST_ID"));
				jsonObject.put("tripCustomerName", rs.getString("TRIP_CUST_NAME"));
				if (rs.getString("DURATION") != null) {
					String[] duration = durationHHMM.split("\\:");
					Calendar now = Calendar.getInstance();
					now.add(Calendar.MINUTE, -((Integer.parseInt(duration[0]) * 60) + Integer.parseInt(duration[1])));
					jsonObject.put("stoppageBegin", mmddyyy.format(now.getTime()));
				}
				jsonArray.put(jsonObject);

			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jsonArray;
	}

	public synchronized String onTripVehStoppageActoinRemindMeLater(int tripId, String status, int userId, int systemId, int customerId, String stoppageBegin) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String message = "";
		try {
			con = DBConnection.getConnectionToDB("AMS");
			// before saving check if it saved already by another user
			pstmt = con.prepareStatement(GeneralVerticalStatements.GET_ONTRIP_VEHICLE_STOPPAGE_ALERT_BY_TRIPID);
			pstmt.setInt(1, tripId);
			rs = pstmt.executeQuery();
			if (!rs.next()) {
				pstmt = con.prepareStatement(GeneralVerticalStatements.INSERT_INTO_ON_TRIP_VEHICLE_STOPPAGE_ACTION);
				pstmt.setInt(1, tripId);
				pstmt.setString(2, status);
				pstmt.setInt(3, userId);
				pstmt.setInt(4, systemId);
				pstmt.setInt(5, customerId);
				pstmt.setString(6, sdfDB.format(sdf.parse(stoppageBegin)));
				int inserted = pstmt.executeUpdate();
				if (inserted > 0) {
					message = "Successfully updated!";
				} else {
					message = "error";
				}
			}

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}

		return message;
	}

	/*
	 * Insert record, with STATUS=CLOSED, Before inserting check if Remind me
	 * later Action taken by another user, If so, then update the same record
	 */
	public String onTripVehStoppageActionTaken(int tripId, String status, int userId, int systemId, int customerId, String stoppageBegin, String remarks, String duration, String lat, String lon,
			String location) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String message = "";
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(GeneralVerticalStatements.INSERT_UPDATE_ON_TRIP_VEHICLE_STOPPAGE_ACTION);
			pstmt.setInt(1, tripId);
			pstmt.setString(2, status);
			pstmt.setInt(3, userId);
			pstmt.setInt(4, systemId);
			pstmt.setInt(5, customerId);
			pstmt.setInt(6, userId);
			pstmt.setString(7, sdfDB.format(sdf.parse(stoppageBegin)));// sdfDB.format(sdf.parse(stoppageBegin)));
			pstmt.setString(8, remarks);
			pstmt.setString(9, duration);
			pstmt.setString(10, lat);
			pstmt.setString(11, lon);
			pstmt.setString(12, location);
			int inserted = pstmt.executeUpdate();
			if (inserted > 0) {
				message = "Successfully updated!";
			} else {
				message = "error";
			}

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}

		return message;
	}

	public String updateOnTripVehicleStoppageAction(int id, int userId, int systemId, int customerId) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String message = "";
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(GeneralVerticalStatements.UPDATE_ONTRIP_VEHICLE_STOPPAGE_ACTION);
			pstmt.setInt(1, userId);
			pstmt.setInt(2, id);
			int inserted = pstmt.executeUpdate();
			if (inserted > 0) {
				message = "Successfully updated!";
			} else {
				message = "error";
			}

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}

		return message;
	}

	public JSONArray getOnTripVehiclesStoppageActionDetails(int systemId, int clientId, int userId, String zone, int isLtsp, int offset) {
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {

			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(GeneralVerticalStatements.GET_ON_TRIP_VEHICLE_STOPPAGE.replaceAll("AMS.dbo.LOCATION", "AMS.dbo.LOCATION_ZONE_" + zone));
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, clientId);
			pstmt.setInt(3, systemId);
			pstmt.setInt(4, clientId);
			rs = pstmt.executeQuery();
			int count = 0;
			String imageSrc = "";
			List<String> tripCustIds = new ArrayList<String>();
			while (rs.next()) {
				tripCustIds.add(rs.getString("TRIP_CUST_ID"));
			}
			if (tripCustIds.isEmpty()) {
				return jsonArray;
			}
			JSONArray smartHubArray = getSmartHubBuffer(userId, clientId, systemId, zone, isLtsp, tripCustIds);
			JSONArray polyHubArray = getSmartHubPolygon(userId, clientId, systemId, zone, isLtsp, tripCustIds);
			double radius = 5.0;
			rs = pstmt.executeQuery();
			boolean hasSmarthubWithinRadius = false;
			boolean hasPolyhubWithinRadius = false;
			while (rs.next()) {
				hasSmarthubWithinRadius = checkIfSmartHubWithinGivenLatLngRadius(rs.getDouble("LATITUDE"), rs.getDouble("LONGITUDE"), radius, rs.getInt("TRIP_CUST_ID"), smartHubArray);
				hasPolyhubWithinRadius = checkIfSmartHubWithinGivenLatLngRadius(rs.getDouble("LATITUDE"), rs.getDouble("LONGITUDE"), radius, rs.getInt("TRIP_CUST_ID"), polyHubArray);
				if (!(hasSmarthubWithinRadius || hasPolyhubWithinRadius)) {
					continue;
				}
				jsonObject = new JSONObject();
				count++;
				jsonObject.put("slNo", count);
				jsonObject.put("id", "");
				jsonObject.put("tripId", rs.getString("TRIP_ID"));
				jsonObject.put("lrNumber", rs.getString("LR_NO"));
				jsonObject.put("tripCustomerId", rs.getString("TRIP_CUST_ID"));
				jsonObject.put("tripCustomerName", rs.getString("TRIP_CUST_NAME"));
				jsonObject.put("shipmentId", rs.getString("SHIPMENT_ID"));
				String durationHHMM = convertHourToHourMinutes(rs.getString("DURATION"));
				jsonObject.put("duration", durationHHMM);
				imageSrc = "<div class='location-icon'><a href='#'><img src='/ApplicationImages/VehicleImagesNew/globe.jpg'/></a></div> ";
				jsonObject.put("viewMapIndex", imageSrc);
				jsonObject.put("status", "OPEN");
				jsonObject.put("latitude", rs.getString("LATITUDE"));
				jsonObject.put("longitude", rs.getString("LONGITUDE"));
				jsonObject.put("assetNumber", rs.getString("ASSET_NUMBER"));
				jsonObject.put("routeName", rs.getString("ROUTE_NAME"));
				jsonObject.put("location", rs.getString("LOCATION"));
				if (rs.getString("DURATION") != null) {
					String[] duration = durationHHMM.split("\\:");
					Calendar now = Calendar.getInstance();
					now.add(Calendar.MINUTE, -((Integer.parseInt(duration[0]) * 60) + Integer.parseInt(duration[1])));
					jsonObject.put("stoppageBegin", mmddyyy.format(now.getTime()));
				}
				jsonArray.put(jsonObject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jsonArray;
	}

	public JSONArray getPlacementDelayedTrip(int systemId, int clientId, int offset, String placemnetDelayGetAll) {
		JSONArray jsonArray = null;
		JSONObject jsonObject = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			jsonArray = new JSONArray();
			con = DBConnection.getConnectionToDB("AMS");
			// check if any if of trip ids
			// If selection type is ALL get both acknowledged and not
			// acknowledged trips.
			// else get only the trips which are not acknowledged.
			if (placemnetDelayGetAll.equalsIgnoreCase("true")) {
				pstmt = con.prepareStatement(GeneralVerticalStatements.GET_DELAYED_TRIPS_ALL);
			} else {
				pstmt = con.prepareStatement(GeneralVerticalStatements.GET_DELAYED_TRIPS_NOT_ACK);
			}
			pstmt.setInt(1, offset);
			pstmt.setInt(2, systemId);
			pstmt.setInt(3, clientId);
			rs = pstmt.executeQuery();
			int count = 0;
			String imageSrc = "";
			while (rs.next()) {
				jsonObject = new JSONObject();
				count++;
				jsonObject.put("slNo", count);
				jsonObject.put("tripId", rs.getString("TRIP_ID"));
				jsonObject.put("lrNumber", rs.getString("LR_NO"));
				jsonObject.put("vehicleNo", rs.getString("ASSET_NUMBER"));
				jsonObject.put("routeName", rs.getString("ROUTE_NAME"));
				if (rs.getString("STP") != null) {
					jsonObject.put("STP", mmddyyy.format(sdfDB.parse(rs.getString("STP"))));
				} else {
					jsonObject.put("STP", "");
				}
				jsonObject.put("currentLocation", rs.getString("LOCATION"));
				imageSrc = "<div class='location-icon'><a href='#'><img src='/ApplicationImages/VehicleImagesNew/globe.jpg'/></a></div> ";
				jsonObject.put("viewMapIndex", imageSrc);
				if (rs.getString("ATP_DELAY_ACKNOWLEDGE") == null) {
					jsonObject.put("button", "<button class='btn btn-success'>Acknowledge</button> ");
				} else {
					jsonObject.put("button", "<div>" + rs.getString("ATP_DELAY_ACKNOWLEDGE") + "</div>");
				}
				jsonObject.put("shipmentId", rs.getString("SHIPMENT_ID"));
				jsonObject.put("latitude", rs.getString("LATITUDE"));
				jsonObject.put("longitude", rs.getString("LONGITUDE"));
				jsonObject.put("duration", convertHourToHourMinutes(rs.getString("DURATION")));
				jsonObject.put("tripCustomerName", rs.getString("TRIP_CUST_NAME"));
				jsonObject.put("tripCustId", rs.getInt("TRIP_CUST_ID"));
				jsonArray.put(jsonObject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jsonArray;
	}

	public String updateTripDelayAcknowledgement(String tripId, String remarks, int systemId, int customerId, int userId) {
		Connection con = null;
		PreparedStatement pstmt = null;
		String message = "";
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(GeneralVerticalStatements.UPDATE_TRIP_ACKNOWLEDGEMENT);
			pstmt.setString(1, remarks);
			pstmt.setInt(2, userId);
			pstmt.setString(3, tripId);
			pstmt.setInt(4, systemId);
			pstmt.setInt(5, customerId);

			int updated = pstmt.executeUpdate();
			if (updated > 0) {
				message = "Acknowledge Saved";
			} else {
				message = "Error.";
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, null);
		}
		return message;
	}

	public String convertHourToHourMinutes(String duration) {

		double d = Double.parseDouble(duration);
		String hhmm = "";
		int hrs = (int) d;
		int min = (int) ((d - hrs) * 60);
		String idletime = "0:0";
		if (min < 10) {
			idletime = df3.format(hrs) + ":0" + String.valueOf(min) + ":00";
		} else {
			idletime = df3.format(hrs) + ":" + String.valueOf(min) + ":00";
		}
		if (idletime != null) {
			hhmm = (idletime);
		} else {
			hhmm = "00:00:00";
		}
		return hhmm;
	}

	public JSONArray getDriverScoreValueData(int systemId, int clientId, int offset, String startDate, String endDate, 
			int driverId, String hubList, String zone) {
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonobject = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int count = 0;
		try {
			con = DBConnection.getConnectionToDB("AMS");
			if(driverId != 0){
				pstmt = con.prepareStatement(GeneralVerticalStatements.GET_DRIVER_SCORE_VALUE_DETAILS.replace("#", " and DRIVER_ID="+driverId));
			}else{
				pstmt = con.prepareStatement(GeneralVerticalStatements.GET_DRIVER_SCORE_VALUE_DETAILS.replace("#", " and DRIVER_ID in (select Driver_id" +
						" from AMS.dbo.Driver_Master d where Client_id="+clientId+""+getHubQueryAppender(hubList, clientId, zone)+")"));
			}
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, clientId);
			pstmt.setInt(3, offset);
			pstmt.setString(4, startDate);
			pstmt.setInt(5, offset);
			pstmt.setString(6, endDate);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				count++;
				jsonobject = new JSONObject();
				jsonobject.put("slNoIndex", count);
				jsonobject.put("empIdIndex", rs.getString("EMP_ID"));
				jsonobject.put("nameIndex", rs.getString("NAME"));
				jsonobject.put("totalScoreIndex", df1.format((rs.getDouble("TOTAL_SCORE"))));
				jsonobject.put("NoofTripsIndex", rs.getDouble("NO_OF_TRIPS"));
				jsonobject.put("totalKmsIndex", rs.getDouble("TOTAL_DISTANCE"));
				jsonobject.put("totalTimeIndex", cf.convertMinutesToHHMMFormat((rs.getInt("TOTAL_DURATION"))));
				jsonobject.put("overallPerIndex", 0);
				jsonobject.put("avgMilageIndex", rs.getString("AVG_MILAGE"));// df1.format(rs.getDouble("AVG_MILAGE")));
				jsonobject.put("avgSpeedIndex", df1.format(rs.getDouble("AVG_SPEED")));
				jsonobject.put("harshAccIndex", df1.format(rs.getDouble("HA_SCORE")));
				jsonobject.put("harshBrakingIndex", df1.format(rs.getDouble("HB_SCORE")));
				jsonobject.put("harshCorneringIndex", df1.format(rs.getDouble("HC_SCORE")));
				jsonobject.put("overspeedingIndex", df1.format(rs.getDouble("OVER_SPEED_SCORE")));
				jsonobject.put("freewheelingIndex", rs.getString("FREE_WHEEL_SCORE")); // don't do df1.format
				jsonobject.put("unscheduledStoppageIndex", df1.format(rs.getDouble("UNSCHDL_STOPPAGE_SCORE")));
				jsonobject.put("excessiveIdlingIndex", df1.format(rs.getDouble("IDLE_SCORE")));
				jsonobject.put("greenBandSpeedIndex", df1.format(rs.getDouble("GREEN_BAND_SPEED_SCORE")));
				jsonobject.put("greenBandRpmIndex", rs.getString("GREEN_BAND_RPM_SCORE")); // don't do
				jsonobject.put("lowRPMIndex", rs.getString("LOW_RPM_SCORE")); // don't
				jsonobject.put("highRPMIndex", rs.getString("HIGH_RPM_SCORE")); // don't
				jsonobject.put("overRevvingIndex", df1.format(rs.getDouble("OVER_REVV_SCORE")));
				
				jsonobject.put("harshAccCountIndex", df1.format(rs.getDouble("HA_COUNT")));
				jsonobject.put("harshBrakingCountIndex", df1.format(rs.getDouble("HB_COUNT")));
				jsonobject.put("harshCorneringCountIndex", df1.format(rs.getDouble("HC_COUNT")));
				jsonobject.put("overspeedingCountIndex", df1.format(rs.getDouble("OVERSPEED_COUNT")));
				jsonobject.put("unscheduledStoppageCountIndex", df1.format(rs.getFloat("UNSCHLD_STOP_DUR")));
				jsonobject.put("excessiveIdlingCountIndex", df1.format(rs.getFloat("EXCESS_IDLE_DUR")));
				jsonobject.put("greenBandSpeedCountIndex", df1.format(rs.getFloat("GREEN_BAND_SPEED_DUR")));
				jsonobject.put("freewheelingCountIndex", rs.getString("FREE_WHEEL_DUR")); // Do not use df1.format
				jsonobject.put("greenBandRpmCountIndex", rs.getString("GREEN_BAND_RPM_DUR")); // Do not use
				jsonobject.put("lowRPMCountIndex", rs.getString("LOW_RPM_DUR")); // Do
				jsonobject.put("highRPMCountIndex", rs.getString("HIGH_RPM_DUR")); // Do not use df1.format as
				jsonobject.put("overRevvingCountIndex", df1.format(rs.getDouble("OVER_REVV_COUNT")));
				jsonobject.put("driverIdIndex", rs.getInt("DRIVER_ID"));
				jsonobject.put("avgOBDMileageIndex", rs.getString("AVG_OBD_MILAGE"));// df1.format(rs.getDouble("AVG_OBD_MILAGE")));
				jsonobject.put("otpScoreIndex", df1.format((rs.getDouble("ON_TIME_PERFORMANCE"))));
				jsonArray.put(jsonobject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jsonArray;
	}

	public JSONArray getTripCustomers(int systemId, String custId, String type) {

		JSONArray jsonArray = new JSONArray();
		JSONObject jsonobject = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			jsonArray = new JSONArray();
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(GeneralVerticalStatements.GET_CUSTOMERS_BY_TYPE);
			pstmt.setInt(1, systemId);
			pstmt.setString(2, custId);
			pstmt.setString(3, type);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				jsonobject = new JSONObject();
				jsonobject.put("tripCustName", rs.getString("NAME"));
				jsonobject.put("tripCustId", rs.getInt("ID"));
				jsonArray.put(jsonobject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jsonArray;
	}

	public JSONArray getCustomerType(int systemId, String custId) {

		JSONArray jsonArray = new JSONArray();
		JSONObject jsonobject = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			jsonArray = new JSONArray();
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(GeneralVerticalStatements.GET_CUSTOMER_TYPE);
			pstmt.setInt(1, systemId);
			pstmt.setString(2, custId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				jsonobject = new JSONObject();
				jsonobject.put("custType", rs.getString("TYPE"));
				jsonArray.put(jsonobject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jsonArray;
	}

	// public JSONArray generateRouteID(int systemId, String custId,String
	// routeKey, String TAT, String sourceCity, String destCity, String[]
	// touchPointArray,
	// String tripCustId) {
	// JSONArray jsonArray = new JSONArray();
	// JSONObject jsonobject = new JSONObject();
	// Connection con = null;
	// PreparedStatement pstmt = null;
	// ResultSet rs = null;
	// String routeID = "";
	// String touchPointSequence = "";
	// boolean iscomplete=true;
	// try {
	// con = DBConnection.getConnectionToDB("AMS");
	// String[] routekeyArr = routeKey.split("_");
	// String OriginKeyCode = "";
	// String DestKeyCode = "";
	// if(routekeyArr.length>1){
	// OriginKeyCode = getIATACodeAndIRCTCCode(routekeyArr[0]);
	// DestKeyCode = getIATACodeAndIRCTCCode(routekeyArr[1]);
	// }
	//			
	// String originCode = getNumeralRouteCode(systemId,
	// Integer.parseInt(custId), sourceCity, Integer.parseInt(tripCustId));
	// String destinationCode = getNumeralRouteCode(systemId,
	// Integer.parseInt(custId), destCity, Integer.parseInt(tripCustId));
	//			
	// if(touchPointArray!=null) {
	// for(String touchPoints:touchPointArray)
	// {
	// touchPoints=touchPoints.substring(1,touchPoints.length()-1);
	// String[] touchPointDetails = touchPoints.split(",");
	//					
	// String touchPointCity="";
	// if(checkNumeric(touchPointDetails[1])==true){
	// touchPointCity = getCityName(touchPointDetails[1]);
	// }else{
	// touchPointCity = touchPointDetails[1].trim();
	// }
	// if(touchPointDetails[2].equalsIgnoreCase("smarthub")) {
	// String hubName = getHubName(touchPointDetails[1]);
	// String[] hubNameArr = hubName.split("_");
	// touchPointSequence = touchPointSequence + "_" + hubNameArr[1];
	// } else{
	// String numeralCode = getNumeralRouteCode(systemId,
	// Integer.parseInt(custId), touchPointCity, Integer.parseInt(tripCustId));
	// if(numeralCode.equals("")){
	// numeralCode="*";
	// }
	// touchPointSequence = touchPointSequence + "_" + numeralCode;
	// }
	// }
	// }
	// if(touchPointSequence.length()>0){
	// if(touchPointSequence.contains("*")){
	// iscomplete = false;
	// touchPointSequence = touchPointSequence.replace("*", "");
	// }
	// }
	// if(touchPointSequence.length()>0){
	// touchPointSequence =
	// touchPointSequence.substring(1,touchPointSequence.length());
	// }
	// int tat = cf.convertDDHHMMToMinutes(TAT)/60;
	// routeID =
	// OriginKeyCode+"_"+DestKeyCode+"_"+originCode+"_"+touchPointSequence+"_"+destinationCode+"_"+String.valueOf(tat)
	// ;
	// if(OriginKeyCode.equals("") || !DestKeyCode.equals("") ||
	// originCode.equals("") || destinationCode.equals("")){
	// iscomplete = false;
	// }else{
	// iscomplete = true;
	// }
	// jsonobject = new JSONObject();
	// jsonobject.put("routeId", routeID);
	// jsonobject.put("isComplete", iscomplete);
	// jsonArray.put(jsonobject);
	// } catch (Exception e) {
	// e.printStackTrace();
	// } finally {
	// DBConnection.releaseConnectionToDB(con, pstmt, rs);
	// }
	// return jsonArray;
	// }

	public JSONArray generateRouteID(int systemId, String custId, String routeKey, String TAT, String sourceCity, String destCity, String[] touchPointArray, String tripCustId, String sourceHub,
			String destHub, String sourceType, String destinationType, String zone) {
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonobject = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String routeID = "";
		String touchPointSequence = "";
		boolean iscomplete = true;
		try {
			con = DBConnection.getConnectionToDB("AMS");
			String[] routekeyArr = routeKey.split("_");
			String OriginKeyCode = "";
			String DestKeyCode = "";
			String originCode = "";
			String destinationCode = "";
			if (routekeyArr.length > 1) {
				OriginKeyCode = getIATACodeAndIRCTCCode(routekeyArr[0]);
				DestKeyCode = getIATACodeAndIRCTCCode(routekeyArr[1]);
			}
			if (!sourceHub.equals("")) {
				if (sourceType.equalsIgnoreCase("Generic Hub")) {
					originCode = getGenericHubName(sourceHub, zone) + "-GEN";
				} else {
					originCode = getHubName(sourceHub, zone);
				}
			} else {
				if (sourceType.equalsIgnoreCase("Generic Hub")) {
					originCode = getIATACodeAndIRCTCCode(sourceCity) + "-GEN";
				} else {
					originCode = getNumeralHubCode(systemId, Integer.parseInt(custId), sourceCity, Integer.parseInt(tripCustId), zone).split("_")[0];
				}
			}

			if (!destHub.equals("")) {
				if (destinationType.equalsIgnoreCase("Generic Hub")) {
					destinationCode = getGenericHubName(destHub, zone) + "-GEN";
				} else {
					destinationCode = getHubName(destHub, zone);
				}
			} else {
				if (destinationType.equalsIgnoreCase("Generic Hub")) {
					destinationCode = getIATACodeAndIRCTCCode(destCity) + "-GEN";
				} else {
					destinationCode = getNumeralHubCode(systemId, Integer.parseInt(custId), destCity, Integer.parseInt(tripCustId), zone).split("_")[0];
				}
			}
			if (touchPointArray != null) {
				for (String touchPoints : touchPointArray) {
					touchPoints = touchPoints.substring(1, touchPoints.length() - 1);
					String[] touchPointDetails = touchPoints.split(",");

					if (touchPointDetails[2].equalsIgnoreCase("smarthub")) {
						String hubName = getSmartHubName(touchPointDetails[1], zone);
						touchPointSequence = touchPointSequence + "_" + hubName.split("_")[1];
					} else if (touchPointDetails[2].equalsIgnoreCase("Generic Hub")) {
						String code = "";
						if (checkNumeric(touchPointDetails[1]) == true) {
							code = getGenericHubName(touchPointDetails[1], zone);
						} else {
							code = getIATACodeAndIRCTCCode(touchPointDetails[1]);
						}
						touchPointSequence = touchPointSequence + "_" + code + "-GEN";
					} else {
						String numeralCode = "";
						if (checkNumeric(touchPointDetails[1]) == true) {
							numeralCode = getHubName(touchPointDetails[1], zone);
						} else {
							numeralCode = getNumeralHubCode(systemId, Integer.parseInt(custId), touchPointDetails[1], Integer.parseInt(tripCustId), zone).split("_")[0];
						}
						if (numeralCode.equals("")) {
							numeralCode = "***";
						}
						touchPointSequence = touchPointSequence + "_" + numeralCode;
					}
				}
			}
			if (touchPointSequence.length() > 0) {
				if (touchPointSequence.contains("*")) {
					iscomplete = false;
				}
			}
			if (touchPointSequence.length() > 0) {
				touchPointSequence = touchPointSequence.substring(1, touchPointSequence.length());
			}
			int tat = cf.convertHHMMToMinutes1(TAT) / 60;
			if (touchPointSequence.equals("")) {
				routeID = OriginKeyCode + "_" + DestKeyCode + "_" + originCode + "_" + destinationCode + "_" + String.valueOf(tat);
			} else {
				routeID = OriginKeyCode + "_" + DestKeyCode + "_" + originCode + "_" + touchPointSequence + "_" + destinationCode + "_" + String.valueOf(tat);
			}
			if (OriginKeyCode.equals("") || DestKeyCode.equals("") || originCode.equals("") || destinationCode.equals("")) {
				iscomplete = false;
			} else {
				iscomplete = true;
			}
			jsonobject = new JSONObject();
			jsonobject.put("routeId", routeID);
			jsonobject.put("isComplete", iscomplete);
			jsonArray.put(jsonobject);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jsonArray;
	}

	private String getSmartHubName(String hubId, String zone) {
		Connection conAdmin = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String hub = "";
		String hubName[] = null;
		try {
			conAdmin = DBConnection.getConnectionToDB("AMS");
			pstmt = conAdmin.prepareStatement(GeneralVerticalStatements.GET_HUB_NAME.replaceAll("AMS.dbo.LOCATION", "AMS.dbo.LOCATION_ZONE_" + zone));

			pstmt.setString(1, hubId);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				hub = rs.getString("NAME");
			}
		} catch (Exception e) {
			System.out.println("Error in GeneralVertical Functions:-getHubName " + e.toString());
		} finally {
			DBConnection.releaseConnectionToDB(conAdmin, pstmt, rs);
		}
		hubName = hub.split(",");
		return hubName[0];
	}

	public String getIATACodeAndIRCTCCode(String city) {
		Connection con = null;
		PreparedStatement pstmt2 = null;
		ResultSet rs = null;
		String cityCode = "***";
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt2 = con.prepareStatement(GeneralVerticalStatements.GET_IATA_CODE);
			pstmt2.setString(1, city.toUpperCase().trim());
			rs = pstmt2.executeQuery();
			if (rs.next()) {
				cityCode = rs.getString("AIRPORT_CODE");
			} else {
				pstmt2 = con.prepareStatement(GeneralVerticalStatements.GET_IRCTC_CODE);
				pstmt2.setString(1, city.toUpperCase().trim());
				rs = pstmt2.executeQuery();
				if (rs.next()) {
					cityCode = rs.getString("STATION_CODE");
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt2, rs);
		}
		return cityCode;
	}

	public String getNumeralHubCode(int systemId, int customerId, String city, int tripCustId, String zone) {
		Connection con = null;
		PreparedStatement pstmt = null, pstmt1 = null, pstmt2 = null;
		ResultSet rs = null;
		String cityCode = "***";
		int count = 1;
		String numeralCityCode = "";
		String custName = "";
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt2 = con.prepareStatement(GeneralVerticalStatements.GET_CUSTOMER_NAME);
			pstmt2.setInt(1, tripCustId);
			rs = pstmt2.executeQuery();
			if (rs.next()) {
				custName = rs.getString("CUST_NAME");
			}
			pstmt2 = con.prepareStatement(GeneralVerticalStatements.GET_IATA_CODE);
			pstmt2.setString(1, city.toUpperCase().trim());
			rs = pstmt2.executeQuery();
			if (rs.next()) {
				cityCode = rs.getString("AIRPORT_CODE");
			} else {
				pstmt2 = con.prepareStatement(GeneralVerticalStatements.GET_IRCTC_CODE);
				pstmt2.setString(1, city.toUpperCase().trim());
				rs = pstmt2.executeQuery();
				if (rs.next()) {
					cityCode = rs.getString("STATION_CODE");
				}
			}
			if (!cityCode.equals("")) {
				pstmt = con.prepareStatement(GeneralVerticalStatements.GET_HUB.replaceAll("AMS.dbo.LOCATION", "AMS.dbo.LOCATION_ZONE_" + zone));

				pstmt.setInt(1, tripCustId);
				pstmt.setString(2, cityCode + "%");
				pstmt.setString(3, "%_" + cityCode + "%");
				rs = pstmt.executeQuery();

				if (rs.next()) {
					if (rs.getString("number").split(",")[0].split("_").length > 1) {
						if (checkNumeric(rs.getString("number").split(",")[0].split("_")[0])) {
							count = Integer.parseInt(rs.getString("number").split(",")[0].split("_")[0]);
						} else {
							count = 0;
						}
					} else {
						count = Integer.parseInt(rs.getString("number").split(",")[0]);
					}
					count++;
					numeralCityCode = cityCode + count + "_" + custName;
				} else {
					numeralCityCode = cityCode + count + "_" + custName;
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt2, null);
			DBConnection.releaseConnectionToDB(null, pstmt, rs);
			DBConnection.releaseConnectionToDB(null, pstmt1, null);
		}
		return numeralCityCode;
	}

	public String getCityName(String hubId, String zone) {
		Connection conAdmin = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String city = "";
		try {
			conAdmin = DBConnection.getConnectionToDB("AMS");
			pstmt = conAdmin.prepareStatement(GeneralVerticalStatements.GET_CITY_NAME.replaceAll("AMS.dbo.LOCATION", "AMS.dbo.LOCATION_ZONE_" + zone));
			pstmt.setString(1, hubId);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				city = rs.getString("HUB_CITY");
			}

		} catch (Exception e) {
			System.out.println("Error in GeneralVertical Functions:-getCityName " + e.toString());
		} finally {
			DBConnection.releaseConnectionToDB(conAdmin, pstmt, rs);
		}
		return city;
	}

	public String getHubName(String hubId, String zone) {
		Connection conAdmin = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String hub = "";
		String hubName = "";
		String custName = "";
		try {
			conAdmin = DBConnection.getConnectionToDB("AMS");
			pstmt = conAdmin.prepareStatement(GeneralVerticalStatements.GET_HUB_NAME.replaceAll("AMS.dbo.LOCATION", "AMS.dbo.LOCATION_ZONE_" + zone));

			pstmt.setString(1, hubId);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				hub = rs.getString("NAME");
				custName = rs.getString("CUST_NAME");
			}
			if (hub.split(",")[0].contains("_")) {
				if (hub.split(",")[0].contains("_") && custName.contains(hub.split(",")[0].split("_")[1])) {
					hubName = hub.split(",")[0].split("_")[0];
				} else {
					hubName = hub.split(",")[0].split("_")[1];
				}
			} else {
				hubName = hub.split(",")[0];
			}
		} catch (Exception e) {
			System.out.println("Error in GeneralVertical Functions:-getHubName " + e.toString());
		} finally {
			DBConnection.releaseConnectionToDB(conAdmin, pstmt, rs);
		}
		return hubName;
	}

	public String getHubDetails(String hubId, String zone) {
		Connection conAdmin = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String value = "";
		try {
			conAdmin = DBConnection.getConnectionToDB("AMS");
			pstmt = conAdmin.prepareStatement(GeneralVerticalStatements.GET_HUB_NAME.replaceAll("AMS.dbo.LOCATION", "AMS.dbo.LOCATION_ZONE_" + zone));

			pstmt.setString(1, hubId);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				value = rs.getString("DETENTION") + "##" + rs.getString("RADIUS");
			}
		} catch (Exception e) {
			System.out.println("Error in GeneralVertical Functions:-getHubName " + e.toString());
		} finally {
			DBConnection.releaseConnectionToDB(conAdmin, pstmt, rs);
		}
		return value;
	}

	public JSONArray getLegReportForDriverScoreData(int systemId, int clientId, int offset, String startDate, String endDate, int driverId, String hubList, String zone) {
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonobject = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt1 = null;
		ResultSet rs1 = null;
		int count = 1;
		JSONArray legDetailsArray = new JSONArray();
		JSONObject legDetailsObject = null;
		try {
			jsonArray = new JSONArray();
			con = DBConnection.getConnectionToDB("AMS");
			String statement = "";
			if(driverId != 0){
				statement = GeneralVerticalStatements.GET_LEG_REPORT_FOR_DRIVER_SCORE.replace("#", " and DRIVER_ID="+driverId);
			}else{
				statement = GeneralVerticalStatements.GET_LEG_REPORT_FOR_DRIVER_SCORE.replace("#", " and DRIVER_ID in (select Driver_id" +
						" from AMS.dbo.Driver_Master d where Client_id="+clientId+""+getHubQueryAppender(hubList, clientId, zone)+")");
			}
			pstmt1 = con.prepareStatement(statement);
			pstmt1.setInt(1, systemId);
			pstmt1.setInt(2, clientId);
			pstmt1.setInt(3, offset);
			pstmt1.setString(4, startDate);
			pstmt1.setInt(5, offset);
			pstmt1.setString(6, endDate);
			pstmt1.setInt(7, systemId);
			pstmt1.setInt(8, clientId);
			pstmt1.setInt(9, offset);
			pstmt1.setString(10, startDate);
			pstmt1.setInt(11, offset);
			pstmt1.setString(12, endDate);
			rs1 = pstmt1.executeQuery();

			while (rs1.next()) {
				legDetailsObject = new JSONObject();
				String STD = "";
				if (!rs1.getString("STD").contains("1900")) {
					STD = sdf.format(sdfDB.parse(rs1.getString("STD")));
				}
				String ATD = "";
				if (!rs1.getString("ATD").contains("1900")) {
					ATD = sdf.format(sdfDB.parse(rs1.getString("ATD")));
				}
				String ETA = "";
				if (!rs1.getString("ETA").contains("1900")) {
					ETA = sdf.format(sdfDB.parse(rs1.getString("ETA")));
				}
				String STA = "";
				if (!rs1.getString("STA").contains("1900")) {
					STA = sdf.format(sdfDB.parse(rs1.getString("STA")));
				}
				String ATA = "";
				if (!rs1.getString("ATA").contains("1900")) {
					ATA = sdf.format(sdfDB.parse(rs1.getString("ATA")));
				}
				if (rs1.getString("TRIP_ID").equals("")) {
					legDetailsObject.put("slNo", count);
					count++;
				} else {
					legDetailsObject.put("slNo", "");
				}
				legDetailsObject.put("driverId", rs1.getString("EMP_ID"));
				legDetailsObject.put("driverName", rs1.getString("NAME"));
				legDetailsObject.put("tripId", rs1.getString("TRIP_ID"));
				if (rs1.getInt("ROUTE_ID") == 0) {
					legDetailsObject.put("routeId", "");
				} else {
					legDetailsObject.put("routeId", rs1.getString("ROUTE_ID"));
				}
				legDetailsObject.put("routeName", rs1.getString("ROUTE_NAME"));
				legDetailsObject.put("tripLrNo", rs1.getString("TRIP_LR_NO"));
				legDetailsObject.put("vehicleNo", rs1.getString("VEHICLE_NUMBER"));
				legDetailsObject.put("vehicleType", rs1.getString("VEHICLE_TYPE"));
				legDetailsObject.put("modelName", rs1.getString("MODEL_NAME"));
				legDetailsObject.put("customerRefNo", rs1.getString("CUSTOMER_REF_ID"));
				legDetailsObject.put("customerName", rs1.getString("CUSTOMER_NAME"));
				legDetailsObject.put("legId", rs1.getString("LEG_ID"));
				legDetailsObject.put("legName", rs1.getString("LEG_NAME"));
				legDetailsObject.put("origin", rs1.getString("ORIGIN"));
				legDetailsObject.put("destination", rs1.getString("DESTINATION"));
				legDetailsObject.put("STD", STD);
				legDetailsObject.put("ATD", ATD);
				legDetailsObject.put("ETA", ETA);
				legDetailsObject.put("STA", STA);
				legDetailsObject.put("ATA", ATA);
				if (rs1.getInt("DELAY") < 0) {
					String negativeDelay = "";
					negativeDelay = cf.convertMinutesToHHMMFormatNegative(rs1.getInt("DELAY"));
					legDetailsObject.put("delay", negativeDelay);
				} else {
					legDetailsObject.put("delay", cf.convertMinutesToHHMMFormat1(rs1.getInt("DELAY")));
				}
				legDetailsObject.put("totalDist", df1.format(rs1.getDouble("TOTAL_DISTANCE")));
				legDetailsObject.put("totalDur", cf.convertMinutesToHHMMFormat1(rs1.getInt("TOTAL_DURATION")));
				legDetailsObject.put("stoppageDur", cf.convertMinutesToHHMMFormat1(rs1.getInt("STOPPAGE_DURATION")));
				legDetailsObject.put("greenBandSpeedPer", df1.format(rs1.getDouble("GREEN_BAND_SPEED_DUR")));
				legDetailsObject.put("greenBandRpmPer", df1.format(rs1.getDouble("GREEN_BAND_RPM_DUR")));
				legDetailsObject.put("llsMileage", df1.format(rs1.getDouble("LLS_MILEAGE")));
				legDetailsObject.put("obdMileage", df1.format(rs1.getDouble("OBD_MILEAGE")));
				legDetailsObject.put("fuelConsumed", rs1.getString("FUEL_CONSUMED"));
				legDetailsObject.put("haCount", df1.format(rs1.getDouble("HA_COUNT")));
				legDetailsObject.put("hbCount", df1.format(rs1.getDouble("HB_COUNT")));
				legDetailsObject.put("hcCount", df1.format(rs1.getDouble("HC_COUNT")));
				legDetailsObject.put("overspeedCount", df1.format(rs1.getDouble("OVERSPEED_COUNT")));
				legDetailsObject.put("freeWheelDur", df1.format(rs1.getDouble("FREE_WHEEL_DUR")));
				legDetailsObject.put("unscheduledStopValue", df1.format(rs1.getDouble("UNSCHEDULED_STOP")));
				legDetailsObject.put("excessIdleDur", df1.format(rs1.getDouble("EXCESS_IDLE_DUR")));
				legDetailsObject.put("lowRpmDur", df1.format(rs1.getDouble("LOW_RPM_DUR")));
				legDetailsObject.put("highRpmDur", df1.format(rs1.getDouble("HIGH_RPM_DUR")));
				legDetailsObject.put("overRevvCount", df1.format(rs1.getDouble("OVER_REVV_COUNT")));
				legDetailsObject.put("finalScore", df1.format(rs1.getDouble("FINAL_SCORE")));
				legDetailsObject.put("haScore", df1.format(rs1.getDouble("HA_SCORE")));
				legDetailsObject.put("hbScore", df1.format(rs1.getDouble("HB_SCORE")));
				legDetailsObject.put("hcScore", df1.format(rs1.getDouble("HC_SCORE")));
				legDetailsObject.put("overSpeedScore", df1.format(rs1.getDouble("OVER_SPEED_SCORE")));
				legDetailsObject.put("freeWheelScore", df1.format(rs1.getDouble("FREE_WHEEL_SCORE")));
				legDetailsObject.put("unscheduledStoppageScore", df1.format(rs1.getDouble("UNSCHDL_STOPPAGE_SCORE")));
				legDetailsObject.put("idleScore", df1.format(rs1.getDouble("IDLE_SCORE")));
				legDetailsObject.put("greenBandSpeedScore", df1.format(rs1.getDouble("GREEN_BAND_SPEED_SCORE")));
				legDetailsObject.put("greenBandRpmScore", df1.format(rs1.getDouble("GREEN_BAND_RPM_SCORE")));
				legDetailsObject.put("lowRpmScore", df1.format(rs1.getDouble("LOW_RPM_SCORE")));
				legDetailsObject.put("highRpmScore", df1.format(rs1.getDouble("HIGH_RPM_SCORE")));
				legDetailsObject.put("overRevvScore", df1.format(rs1.getDouble("OVER_REVV_SCORE")));
				String weightedAvgSpeed = df1.format(rs1.getDouble("W_AVG_SPEED"));
				if (Double.parseDouble(weightedAvgSpeed) == 0.0) {
					legDetailsObject.put("weightedAverageSpeed", df1.format(rs1.getDouble("AVG_SPEED")));
				} else {
					legDetailsObject.put("weightedAverageSpeed", df1.format(rs1.getDouble("W_AVG_SPEED")));
				}
				legDetailsArray.put(legDetailsObject);
			}
			jsonobject.put("legReportdetails", legDetailsArray);

			jsonArray.put(jsonobject);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt1, rs1);
		}
		return jsonArray;
	}

	@SuppressWarnings("static-access")
	public String CreateLegReportDriverScoreExcelExport(JSONArray legBean, String startDate, String endDate) {

		String completePath = null;
		try {
			String name = "Leg Report For Driver Score Report";
			Properties properties = ApplicationListener.prop;
			// String rootPath =
			// properties.getProperty("driverPerformanceLegwiseExcelExport");
			String rootPath = properties.getProperty("LegReportDriverScoreExcelExport");
			completePath = rootPath + "//" + name + "_" + sdfDBMMDD.format(sdfDB.parse(startDate)) + "_" + sdfDBMMDD.format(sdfDB.parse(endDate)) + ".xls";
			File f = new File(rootPath);
			if (!f.exists()) {
				f.mkdir();
			}
			FileOutputStream fileOut = new FileOutputStream(completePath);
			HSSFWorkbook workbook = new HSSFWorkbook();
			HSSFSheet worksheet = workbook.createSheet("Report");
			HSSFFont font = null;
			font = workbook.createFont();
			font.setBoldweight(Font.BOLDWEIGHT_BOLD);

			HSSFFont titleFont = null;
			titleFont = workbook.createFont();
			titleFont.setFontName(HSSFFont.FONT_ARIAL);
			titleFont.setFontHeightInPoints((short) 15);
			titleFont.setBoldweight(Font.BOLDWEIGHT_BOLD);

			HSSFCellStyle headerStyle = workbook.createCellStyle();
			headerStyle.setFont(titleFont);
			headerStyle.setAlignment(headerStyle.ALIGN_CENTER);

			HSSFCellStyle styleForCustomer = workbook.createCellStyle();
			styleForCustomer.setFont(font);
			styleForCustomer.setAlignment(styleForCustomer.ALIGN_LEFT);

			HSSFCellStyle style1 = workbook.createCellStyle();
			style1.setFont(font);

			HSSFCellStyle style2 = workbook.createCellStyle();
			style2.setFont(font);
			style2.setAlignment(headerStyle.ALIGN_CENTER);
			style2.setFillForegroundColor(IndexedColors.LIGHT_ORANGE.getIndex());
			style2.setFillPattern(CellStyle.SOLID_FOREGROUND);

			HSSFCellStyle style3 = workbook.createCellStyle();
			style3.setFont(font);
			style3.setAlignment(headerStyle.ALIGN_CENTER);
			style3.setFillForegroundColor(IndexedColors.LIGHT_CORNFLOWER_BLUE.getIndex());
			style3.setFillPattern(CellStyle.SOLID_FOREGROUND);

			HSSFRow row = worksheet.createRow((short) 0);
			worksheet.createFreezePane(0, 4);

			HSSFCell titleCellC1 = row.createCell((short) 0);
			titleCellC1.setCellValue("Leg Report For Driver Score Report");
			titleCellC1.setCellStyle(headerStyle);
			worksheet.addMergedRegion(new Region(0, (short) 0, 1, (short) 54));

			int rowHeaders = 2;
			HSSFRow rowNew = worksheet.createRow((short) rowHeaders);

			HSSFCell valuesHeading1 = rowNew.createCell((short) 29);
			valuesHeading1.setCellValue("Values");
			valuesHeading1.setCellStyle(style2);
			worksheet.addMergedRegion(new Region(2, (short) 29, 2, (short) 40));

			HSSFCell valuesHeading2 = rowNew.createCell((short) 41);
			valuesHeading2.setCellValue("Score");
			valuesHeading2.setCellStyle(style3);
			worksheet.addMergedRegion(new Region(2, (short) 41, 2, (short) 53));

			int rowNumber = 3;

			HSSFRow row1 = worksheet.createRow((short) rowNumber);

			HSSFCell cellA1 = row1.createCell((short) 0);
			cellA1.setCellValue("Sl No.");
			cellA1.setCellStyle(style1);

			HSSFCell cellB1 = row1.createCell((short) 1);
			cellB1.setCellValue("Driver ID");
			cellB1.setCellStyle(style1);

			HSSFCell cellD1 = row1.createCell((short) 2);
			cellD1.setCellValue("Driver Name");
			cellD1.setCellStyle(style1);

			HSSFCell cellE1 = row1.createCell((short) 3);
			cellE1.setCellValue("Trip ID");
			cellE1.setCellStyle(style1);

			HSSFCell cellG1 = row1.createCell((short) 4);
			cellG1.setCellValue("Route ID");
			cellG1.setCellStyle(style1);

			HSSFCell cellH1 = row1.createCell((short) 5);
			cellH1.setCellValue("Route Name");
			cellH1.setCellStyle(style1);

			HSSFCell cellI1 = row1.createCell((short) 6);
			cellI1.setCellValue("Trip LR No");
			cellI1.setCellStyle(style1);

			HSSFCell cellJ1 = row1.createCell((short) 7);
			cellJ1.setCellValue("Vehicle No");
			cellJ1.setCellStyle(style1);

			HSSFCell cellK1 = row1.createCell((short) 8);
			cellK1.setCellValue("Make of Vehicle");
			cellK1.setCellStyle(style1);

			HSSFCell cellL1 = row1.createCell((short) 9);
			cellL1.setCellValue("Vehicle Type");
			cellL1.setCellStyle(style1);

			HSSFCell cellM1 = row1.createCell((short) 10);
			cellM1.setCellValue("Customer Ref Id");
			cellM1.setCellStyle(style1);

			HSSFCell cellN1 = row1.createCell((short) 11);
			cellN1.setCellValue("Customer Name");
			cellN1.setCellStyle(style1);

			HSSFCell cellO1 = row1.createCell((short) 12);
			cellO1.setCellValue("Leg ID");
			cellO1.setCellStyle(style1);

			HSSFCell cellP1 = row1.createCell((short) 13);
			cellP1.setCellValue("Leg Name");
			cellP1.setCellStyle(style1);

			HSSFCell cellQ1 = row1.createCell((short) 14);
			cellQ1.setCellValue("Origin");
			cellQ1.setCellStyle(style1);

			HSSFCell cellR1 = row1.createCell((short) 15);
			cellR1.setCellValue("Destination");
			cellR1.setCellStyle(style1);

			HSSFCell cellS1 = row1.createCell((short) 16);
			cellS1.setCellValue("STD");
			cellS1.setCellStyle(style1);

			HSSFCell cellT1 = row1.createCell((short) 17);
			cellT1.setCellValue("ATD");
			cellT1.setCellStyle(style1);

			HSSFCell cellU1 = row1.createCell((short) 18);
			cellU1.setCellValue("ETA");
			cellU1.setCellStyle(style1);

			HSSFCell cellV1 = row1.createCell((short) 19);
			cellV1.setCellValue("STA");
			cellV1.setCellStyle(style1);

			HSSFCell cellW1 = row1.createCell((short) 20);
			cellW1.setCellValue("ATA");
			cellW1.setCellStyle(style1);

			HSSFCell cellX1 = row1.createCell((short) 21);
			cellX1.setCellValue("Total Delay (HH:MM)");
			cellX1.setCellStyle(style1);

			HSSFCell cellY1 = row1.createCell((short) 22);
			cellY1.setCellValue("Distance (Kms)");
			cellY1.setCellStyle(style1);

			HSSFCell cellZ1 = row1.createCell((short) 23);
			cellZ1.setCellValue("Duration (HH:MM)");
			cellZ1.setCellStyle(style1);

			HSSFCell cellAA1 = row1.createCell((short) 24);
			cellAA1.setCellValue("Average Speed (kmph)");
			cellAA1.setCellStyle(style1);

			HSSFCell cellAB1 = row1.createCell((short) 25);
			cellAB1.setCellValue("Total Stoppage Time (HH:MM)");
			cellAB1.setCellStyle(style1);

			HSSFCell cellAE1 = row1.createCell((short) 26);
			cellAE1.setCellValue("LLS Mileage (kmpl)");
			cellAE1.setCellStyle(style1);

			HSSFCell cellAF1 = row1.createCell((short) 27);
			cellAF1.setCellValue("OBD Mileage (kmpl)");
			cellAF1.setCellStyle(style1);

			HSSFCell cellAG1 = row1.createCell((short) 28);
			cellAG1.setCellValue("Fuel Consumed");
			cellAG1.setCellStyle(style1);

			HSSFCell cellAH1 = row1.createCell((short) 29);
			cellAH1.setCellValue("Harsh Acceleration (per Hr)");
			cellAH1.setCellStyle(style1);

			HSSFCell cellAI1 = row1.createCell((short) 30);
			cellAI1.setCellValue("Harsh Braking (per Hr)");
			cellAI1.setCellStyle(style1);

			HSSFCell cellAJ1 = row1.createCell((short) 31);
			cellAJ1.setCellValue("Harsh Cornering (per Hr)");
			cellAJ1.setCellStyle(style1);

			HSSFCell cellAK1 = row1.createCell((short) 32);
			cellAK1.setCellValue("Overspeeding (per Hr)");
			cellAK1.setCellStyle(style1);

			HSSFCell cellAL1 = row1.createCell((short) 33);
			cellAL1.setCellValue("Total Freewheeling Time(%Time)");
			cellAL1.setCellStyle(style1);

			HSSFCell cellAM1 = row1.createCell((short) 34);
			cellAM1.setCellValue("Unscheduled Stoppage Time(%Time)");
			cellAM1.setCellStyle(style1);

			HSSFCell cellAN1 = row1.createCell((short) 35);
			cellAN1.setCellValue("Excessive Idling Time(%Time)");
			cellAN1.setCellStyle(style1);

			HSSFCell cellAC1 = row1.createCell((short) 36);
			cellAC1.setCellValue("Green Band Speed (%Time)");
			cellAC1.setCellStyle(style1);

			HSSFCell cellAD1 = row1.createCell((short) 37);
			cellAD1.setCellValue("Green Band RPM (%Time)");
			cellAD1.setCellStyle(style1);

			HSSFCell cellAO1 = row1.createCell((short) 38);
			cellAO1.setCellValue("Low RPM (%Time)");
			cellAO1.setCellStyle(style1);

			HSSFCell cellAP1 = row1.createCell((short) 39);
			cellAP1.setCellValue("High RPM (%Time)");
			cellAP1.setCellStyle(style1);

			HSSFCell cellAQ1 = row1.createCell((short) 40);
			cellAQ1.setCellValue("Overrevving");
			cellAQ1.setCellStyle(style1);

			HSSFCell cellAR1 = row1.createCell((short) 41);
			cellAR1.setCellValue("Total Score");
			cellAR1.setCellStyle(style1);

			HSSFCell cellAS1 = row1.createCell((short) 42);
			cellAS1.setCellValue("Harsh Acceleration");
			cellAS1.setCellStyle(style1);

			HSSFCell cellAT1 = row1.createCell((short) 43);
			cellAT1.setCellValue("Harsh Braking");
			cellAT1.setCellStyle(style1);

			HSSFCell cellAU1 = row1.createCell((short) 44);
			cellAU1.setCellValue("Harsh Cornering");
			cellAU1.setCellStyle(style1);

			HSSFCell cellAV1 = row1.createCell((short) 45);
			cellAV1.setCellValue("Overspeeding");
			cellAV1.setCellStyle(style1);

			HSSFCell cellAW1 = row1.createCell((short) 46);
			cellAW1.setCellValue("Total Freewheeling Time");
			cellAW1.setCellStyle(style1);

			HSSFCell cellAX1 = row1.createCell((short) 47);
			cellAX1.setCellValue("Unscheduled Stoppage Time");
			cellAX1.setCellStyle(style1);

			HSSFCell cellAY1 = row1.createCell((short) 48);
			cellAY1.setCellValue("Excessive Idling Time");
			cellAY1.setCellStyle(style1);

			HSSFCell cellAZ1 = row1.createCell((short) 49);
			cellAZ1.setCellValue("Green Band Speed");
			cellAZ1.setCellStyle(style1);

			HSSFCell cellBA1 = row1.createCell((short) 50);
			cellBA1.setCellValue("Green Band RPM");
			cellBA1.setCellStyle(style1);

			HSSFCell cellBB1 = row1.createCell((short) 51);
			cellBB1.setCellValue("Low RPM");
			cellBB1.setCellStyle(style1);

			HSSFCell cellBC1 = row1.createCell((short) 52);
			cellBC1.setCellValue("High RPM");
			cellBC1.setCellStyle(style1);

			HSSFCell cellBD1 = row1.createCell((short) 53);
			cellBD1.setCellValue("Overrevving");
			cellBD1.setCellStyle(style1);

			for (int i = 0; i < legBean.length(); i++) {
				if (legBean.getJSONObject(i).length() > 0) {
					for (int ii = 0; ii < legBean.getJSONObject(i).getJSONArray("legReportdetails").length(); ii++) {
						JSONObject internalLegBean = legBean.getJSONObject(i).getJSONArray("legReportdetails").getJSONObject(ii);
						rowNumber++;
						HSSFRow row2 = worksheet.createRow((short) rowNumber);

						cellA1 = row2.createCell((short) 0);// createCell((short)
						// 0);
						cellA1.setCellValue(internalLegBean.get("slNo").toString());

						cellB1 = row2.createCell((short) 1);// createCell((short)
						// 0);
						cellB1.setCellValue(internalLegBean.get("driverId").toString());

						cellD1 = row2.createCell((short) 2);
						cellD1.setCellValue(internalLegBean.get("driverName").toString());

						cellE1 = row2.createCell((short) 3);
						cellE1.setCellValue(internalLegBean.get("tripId").toString());

						cellG1 = row2.createCell((short) 4);
						cellG1.setCellValue(internalLegBean.get("routeId").toString());

						cellH1 = row2.createCell((short) 5);
						cellH1.setCellValue(internalLegBean.get("routeName").toString());

						cellI1 = row2.createCell((short) 6);
						cellI1.setCellValue(internalLegBean.get("tripLrNo").toString());

						cellJ1 = row2.createCell((short) 7);
						cellJ1.setCellValue(internalLegBean.get("vehicleNo").toString());

						cellK1 = row2.createCell((short) 8);
						cellK1.setCellValue(internalLegBean.get("modelName").toString());

						cellL1 = row2.createCell((short) 9);
						cellL1.setCellValue(internalLegBean.get("vehicleType").toString());

						cellM1 = row2.createCell((short) 10);
						cellM1.setCellValue(internalLegBean.get("customerRefNo").toString());

						cellN1 = row2.createCell((short) 11);
						cellN1.setCellValue(internalLegBean.get("customerName").toString());

						cellO1 = row2.createCell((short) 12);
						cellO1.setCellValue(internalLegBean.get("legId").toString());

						cellP1 = row2.createCell((short) 13);
						cellP1.setCellValue(internalLegBean.get("legName").toString());

						cellQ1 = row2.createCell((short) 14);
						cellQ1.setCellValue(internalLegBean.get("origin").toString());

						cellR1 = row2.createCell((short) 15);
						cellR1.setCellValue(internalLegBean.get("destination").toString());

						cellS1 = row2.createCell((short) 16);
						cellS1.setCellValue(internalLegBean.get("STD").toString());

						cellT1 = row2.createCell((short) 17);
						cellT1.setCellValue(internalLegBean.get("ATD").toString());

						cellU1 = row2.createCell((short) 18);
						cellU1.setCellValue(internalLegBean.get("ETA").toString());

						cellV1 = row2.createCell((short) 19);
						cellV1.setCellValue(internalLegBean.get("STA").toString());

						cellW1 = row2.createCell((short) 20);
						cellW1.setCellValue(internalLegBean.get("ATA").toString());

						cellX1 = row2.createCell((short) 21);
						cellX1.setCellValue(internalLegBean.get("delay").toString());

						cellY1 = row2.createCell((short) 22);
						cellY1.setCellValue(internalLegBean.get("totalDist").toString());

						cellZ1 = row2.createCell((short) 23);
						cellZ1.setCellValue(internalLegBean.get("totalDur").toString());

						cellAA1 = row2.createCell((short) 24);
						cellAA1.setCellValue(internalLegBean.get("weightedAverageSpeed").toString());

						cellAB1 = row2.createCell((short) 25);
						cellAB1.setCellValue(internalLegBean.get("stoppageDur").toString());

						cellAE1 = row2.createCell((short) 26);
						cellAE1.setCellValue(internalLegBean.get("llsMileage").toString());

						cellAF1 = row2.createCell((short) 27);
						cellAF1.setCellValue(internalLegBean.get("obdMileage").toString());

						cellAG1 = row2.createCell((short) 28);
						cellAG1.setCellValue(internalLegBean.get("fuelConsumed").toString());

						cellAH1 = row2.createCell((short) 29);
						cellAH1.setCellValue(internalLegBean.get("haCount").toString());

						cellAI1 = row2.createCell((short) 30);
						cellAI1.setCellValue(internalLegBean.get("hbCount").toString());

						cellAJ1 = row2.createCell((short) 31);
						cellAJ1.setCellValue(internalLegBean.get("hcCount").toString());

						cellAK1 = row2.createCell((short) 32);
						cellAK1.setCellValue(internalLegBean.get("overspeedCount").toString());

						cellAL1 = row2.createCell((short) 33);
						cellAL1.setCellValue(internalLegBean.get("freeWheelDur").toString());

						cellAM1 = row2.createCell((short) 34);
						cellAM1.setCellValue(internalLegBean.get("unscheduledStopValue").toString());

						cellAN1 = row2.createCell((short) 35);
						cellAN1.setCellValue(internalLegBean.get("excessIdleDur").toString());

						cellAC1 = row2.createCell((short) 36);
						cellAC1.setCellValue(internalLegBean.get("greenBandSpeedPer").toString());

						cellAD1 = row2.createCell((short) 37);
						cellAD1.setCellValue(internalLegBean.get("greenBandRpmPer").toString());

						cellAO1 = row2.createCell((short) 38);
						cellAO1.setCellValue(internalLegBean.get("lowRpmDur").toString());

						cellAP1 = row2.createCell((short) 39);
						cellAP1.setCellValue(internalLegBean.get("highRpmDur").toString());

						cellAQ1 = row2.createCell((short) 40);
						cellAQ1.setCellValue(internalLegBean.get("overRevvCount").toString());

						cellAR1 = row2.createCell((short) 41);
						cellAR1.setCellValue(internalLegBean.get("finalScore").toString());

						cellAS1 = row2.createCell((short) 42);
						cellAS1.setCellValue(internalLegBean.get("haScore").toString());

						cellAT1 = row2.createCell((short) 43);
						cellAT1.setCellValue(internalLegBean.get("hbScore").toString());

						cellAU1 = row2.createCell((short) 44);
						cellAU1.setCellValue(internalLegBean.get("hcScore").toString());

						cellAV1 = row2.createCell((short) 45);
						cellAV1.setCellValue(internalLegBean.get("overSpeedScore").toString());

						cellAW1 = row2.createCell((short) 46);
						cellAW1.setCellValue(internalLegBean.get("freeWheelScore").toString());

						cellAX1 = row2.createCell((short) 47);
						cellAX1.setCellValue(internalLegBean.get("unscheduledStoppageScore").toString());

						cellAY1 = row2.createCell((short) 48);
						cellAY1.setCellValue(internalLegBean.get("idleScore").toString());

						cellAZ1 = row2.createCell((short) 49);
						cellAZ1.setCellValue(internalLegBean.get("greenBandSpeedScore").toString());

						cellBA1 = row2.createCell((short) 50);
						cellBA1.setCellValue(internalLegBean.get("greenBandRpmScore").toString());

						cellBB1 = row2.createCell((short) 51);
						cellBB1.setCellValue(internalLegBean.get("lowRpmScore").toString());

						cellBC1 = row2.createCell((short) 52);
						cellBC1.setCellValue(internalLegBean.get("highRpmScore").toString());

						cellBD1 = row2.createCell((short) 53);
						cellBD1.setCellValue(internalLegBean.get("overRevvScore").toString());
					}
				}
			}
			workbook.write(fileOut);
			fileOut.flush();
			fileOut.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return completePath;
	}

	public void updateHubChangeForOnTrips(int routeid) {
		PreparedStatement pstmt = null;
		PreparedStatement pstmt1 = null;
		ResultSet rs = null;
		Connection con = null;
		try {
			con = DBConnection.getConnectionToDB("AMS");
			con.setAutoCommit(false);
			pstmt1 = con.prepareStatement(" select * from TRACK_TRIP_DETAILS where STATUS='OPEN' and ROUTE_ID=? ", ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
			pstmt1.setInt(1, routeid);
			rs = pstmt1.executeQuery();
			while (rs.next()) {
				int tripid = rs.getInt("TRIP_ID");
				ArrayList<ArrayList<String>> arr = getLegDetailsForTrip(con, routeid, rs.getInt("TRIP_ID"), rs.getString("TRIP_START_TIME"));
				// delete checkpoint details
				pstmt = con.prepareStatement(" delete AMS.dbo.DES_TRIP_DETAILS where TRIP_ID=? ");
				pstmt.setInt(1, tripid);
				pstmt.executeUpdate();

				// delete driver performance
				pstmt = con.prepareStatement(" delete from AMS.dbo.TRIP_DRIVER_DETAILS where TRIP_ID=? ");
				pstmt.setInt(1, tripid);
				pstmt.executeUpdate();

				// delete leg details
				pstmt = con.prepareStatement(" delete from AMS.dbo.TRIP_LEG_DETAILS where TRIP_ID=? ");
				pstmt.setInt(1, tripid);
				pstmt.executeUpdate();

				for (int i = 0; i < arr.size(); i++) {
					ArrayList<String> legdetails = arr.get(i);
					pstmt = con.prepareStatement("insert into AMS.dbo.TRIP_LEG_DETAILS (TRIP_ID,LEG_ID,STD,STA,INSERTED_DATE,INSERTED_BY) values (?,?,?,?,getutcdate(),?)");
					pstmt.setInt(1, Integer.parseInt(legdetails.get(0)));
					pstmt.setInt(2, Integer.parseInt(legdetails.get(1)));
					pstmt.setString(3, (legdetails.get(2)));
					pstmt.setString(4, (legdetails.get(3)));
					pstmt.setInt(5, 0);
					pstmt.executeUpdate();
				}

				// reset trip as new trip.
				pstmt = con.prepareStatement("update AMS.dbo.TRACK_TRIP_DETAILS set TRIP_STATUS='NEW',LAST_EXEC_DATE=null,ACTUAL_TRIP_START_TIME=null where STATUS='OPEN' and TRIP_ID=? ");
				pstmt.setInt(1, tripid);
				pstmt.executeUpdate();

			}

			con.commit();
		} catch (Exception e) {
			try {
				con.rollback();
			} catch (SQLException e1) {
				e1.printStackTrace();
			}
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
			DBConnection.releaseConnectionToDB(null, pstmt1, null);
		}
	}

	public ArrayList<ArrayList<String>> getLegDetailsForTrip(Connection con, int routeid, int tripid, String tripstartdatetime) {
		PreparedStatement pstmt1 = null;
		ResultSet rs = null;
		ArrayList<ArrayList<String>> arr = new ArrayList<ArrayList<String>>();
		SimpleDateFormat sdfSS = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		Calendar cal = Calendar.getInstance();

		try {
			pstmt1 = con.prepareStatement(" select ? as STD,dateadd(mi,(lg.TAT+DETENTION_TIME),?) as STA,trd.LEG_SEQUENCE,LEG_ID,lg.TAT,DESTINATION,DETENTION_TIME from LEG_MASTER lg "
					+ " inner join TRIP_ROUTE_DETAILS trd on LEG_ID=lg.ID where ROUTE_ID=? order by trd.LEG_SEQUENCE ");
			pstmt1.setString(1, tripstartdatetime);
			pstmt1.setString(2, tripstartdatetime);
			pstmt1.setInt(3, routeid);
			rs = pstmt1.executeQuery();
			cal.setTime(sdfSS.parse(tripstartdatetime));
			while (rs.next()) {
				cal.add(Calendar.MINUTE, rs.getInt("DETENTION_TIME"));
				ArrayList<String> legdetails = new ArrayList<String>();
				legdetails.add("" + tripid);
				legdetails.add("" + rs.getInt("LEG_ID"));
				legdetails.add(sdfSS.format(cal.getTime()));
				cal.add(Calendar.MINUTE, rs.getInt("TAT"));
				legdetails.add(sdfSS.format(cal.getTime()));
				arr.add(legdetails);
			}

		} catch (Exception e) {
			System.out.println("Exception in AdminFunctions:-insertDataIntoAuditLogReport " + e.toString());
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(null, pstmt1, rs);
		}
		return arr;
	}

	public void modifyLegRoutesAndOnTrips(Connection con, int mainlegid, String serverName, String sessionId, int systemId, int clientId, int userId, String zone) {
		PreparedStatement pstmt1 = null;
		PreparedStatement pstmt2 = null;
		ResultSet rs1 = null;
		ResultSet rs2 = null;

		try {
			double totaltat = 0;
			double totaldistance = 0;
			// process for routes
			pstmt1 = con.prepareStatement(" select * from TRIP_ROUTE_MASTER where ID in (select ROUTE_ID from AMS.dbo.TRIP_ROUTE_DETAILS where LEG_ID=? )");
			pstmt1.setInt(1, mainlegid);
			rs1 = pstmt1.executeQuery();
			while (rs1.next()) {
				boolean flag = false;
				String[] legjs = new String[6];
				pstmt2 = con
						.prepareStatement(" select LEG_SEQUENCE,a.LEG_ID,b.DETENTION as legdetention,c.TAT as legtat,c.DISTANCE as legdistance from TRIP_ROUTE_DETAILS a inner join LEG_DETAILS b on b.LEG_ID=a.LEG_ID and b.TYPE in ('SOURCE') inner join LEG_MASTER c on c.ID=b.LEG_ID where a.ROUTE_ID=? order by a.LEG_SEQUENCE ");
				pstmt2.setInt(1, rs1.getInt("ID"));
				rs2 = pstmt2.executeQuery();
				int count = 0;
				while (rs2.next()) {
					int legseq = rs2.getInt("LEG_SEQUENCE");
					if (legseq == 0) {
						flag = true;
					}
					if (flag) {
						if (legseq == 0) {
							totaltat = rs2.getDouble("legtat");
							totaldistance = rs2.getDouble("legdistance");
						} else {
							totaltat = totaltat + (rs2.getDouble("legtat") + rs2.getDouble("legdetention"));
							totaldistance = totaldistance + rs2.getDouble("legdistance");
						}
					} else {
						if (legseq == 1) {
							totaltat = rs2.getDouble("legtat");
							totaldistance = rs2.getDouble("legdistance");
						} else {
							totaltat = totaltat + (rs2.getDouble("legtat") + rs2.getDouble("legdetention"));
							totaldistance = totaldistance + rs2.getDouble("legdistance");
						}
					}

					int legid = rs2.getInt("LEG_ID");
					String legjss = "{" + legseq + "," + legid + "}";
					legjs[count] = legjss;
					count++;
				}
				saveRouteDetails(rs1.getInt("TRIP_CUST_ID"), rs1.getString("ROUTE_NAME"), rs1.getString("ROUTE_KEY"), String.valueOf(totaldistance), String.valueOf(totaltat), legjs, systemId,
						clientId, userId, rs1.getInt("ID"), "Active", rs1.getString("RADIUS"), sessionId, serverName, "", "", zone);
			}
		} catch (Exception e) {
			System.out.println("Exception in AdminFunctions:-insertDataIntoAuditLogReport " + e.toString());
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(null, pstmt1, rs1);
		}
	}

	public boolean checkNumeric(String value) {
		boolean numeric = true;

		numeric = value.matches("-?\\d+(\\.\\d+)?");

		if (numeric)
			return true;
		else
			return false;

	}

	public boolean checkRouteExists(String routeName, String tripCustId, int systemId, int clientId) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		boolean check = false;
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(GeneralVerticalStatements.CHECK_DUPLICATE_ROUTE);
			pstmt.setString(1, routeName);
			pstmt.setInt(2, systemId);
			pstmt.setInt(3, clientId);
			pstmt.setString(4, tripCustId);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				check = true;
			}
		} catch (Exception e) {
			e.getMessage();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return check;
	}

	public JSONArray getTripDelaySmartHubBuffer(int userId, int clientId, int systemId, String zone, int isLtsp, int tripCustId) {

		JSONArray BufferArray = new JSONArray();
		JSONObject BufferObject = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			BufferArray = new JSONArray();
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(GeneralVerticalStatements.GET_SMART_HUB_BUFFERS_TRIP_DELAY.replace("LOCATION", "LOCATION_ZONE_" + zone));
			pstmt.setInt(1, clientId);
			pstmt.setInt(2, systemId);
			pstmt.setInt(3, tripCustId);
			pstmt.setInt(4, clientId);
			pstmt.setInt(5, systemId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				BufferObject = new JSONObject();
				BufferObject.put("buffername", rs.getString("NAME"));
				BufferObject.put("latitude", rs.getString("LATITUDE"));
				BufferObject.put("longitude", rs.getString("LONGITUDE"));
				BufferObject.put("radius", rs.getString("RADIUS"));
				if (rs.getString("IMAGE") != "")
					BufferObject.put("imagename", rs.getString("IMAGE"));
				else
					BufferObject.put("imagename", rs.getString("IMAGE"));
				BufferObject.put("hubId", rs.getString("HUBID"));
				BufferObject.put("detention", rs.getString("DETENTION"));
				BufferObject.put("hubType", rs.getInt("OPERATION_ID"));
				BufferArray.put(BufferObject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}

		return BufferArray;
	}

	public JSONArray getTripDelaySmartHubPolygon(int userId, int customerId, int systemId, String zone, int isLTSP, int tripCustId) {

		JSONArray PolygonArray = new JSONArray();
		JSONObject PolygonObject = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			PolygonArray = new JSONArray();
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(GeneralVerticalStatements.GET_SMART_HUB_POLYGONS_TRIP_DELAY.replace("LOCATION_ZONE", "LOCATION_ZONE_" + zone));
			pstmt.setInt(1, customerId);
			pstmt.setInt(2, systemId);
			pstmt.setInt(3, tripCustId);
			pstmt.setInt(4, customerId);
			pstmt.setInt(5, systemId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				PolygonObject = new JSONObject();
				PolygonObject.put("polygonname", rs.getString("NAME"));
				PolygonObject.put("latitude", rs.getString("LATITUDE"));
				PolygonObject.put("longitude", rs.getString("LONGITUDE"));
				PolygonObject.put("sequence", rs.getString("SEQUENCE_ID"));
				PolygonObject.put("hubid", rs.getString("HUBID"));
				PolygonObject.put("hubType", rs.getInt("OPERATION_ID"));
				PolygonArray.put(PolygonObject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return PolygonArray;
	}

	public String formattedHoursMinutesSeconds(long diff) {
		String hhmmssformat = "";
		String format = "";
		boolean negative = false;
		try {
			diff = (diff * 60) * 1000;
			if (diff == 0) {
				return hhmmssformat = "";
			}
			long diffSeconds = diff / 1000 % 60;
			long diffMinutes = diff / (60 * 1000) % 60;
			long diffHours = diff / (60 * 60 * 1000);
			// hhmmssformat=diffHours+":"+diffMinutes+":"+diffSeconds;
			hhmmssformat = df3.format(diffHours) + ":" + df3.format(diffMinutes) + ":" + df3.format(diffSeconds);
			negative = hhmmssformat.contains("-") ? true : false;
			format = negative ? "-" + hhmmssformat.replaceAll("-", "") : hhmmssformat;
		} catch (Exception e) {
			System.out.println("hh:mm:ss exception :::::   " + e.getLocalizedMessage());
			e.printStackTrace();

		}
		return format;

	}

	public String getDate(String date, long mins) {
		String newDate = "";
		date = (date != null) ? date : "";
		try {
			if (!date.contains("1900") && mins > 0) {
				Date d = sdfDB.parse(date);
				Calendar cal = Calendar.getInstance();
				cal.setTime(d);
				cal.add(Calendar.MINUTE, (int) mins);
				newDate = sdfDB.format(cal.getTime());
				newDate = mmddyyy.format(sdfDB.parse(newDate));
			}

		} catch (Exception e) {
			e.printStackTrace();
		}
		return newDate;
	}

	public String getTripName(int id) {

		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String tripName = "";
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(GeneralVerticalStatements.GET_TRIP);
			pstmt.setInt(1, id);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				tripName = rs.getString("ORDER_ID");
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return tripName;
	}

	public String getTransitDealy(String tripStatus, String eta, String staonata) {
		try {

			if (eta.equals("") || staonata.equals("")) {
				return "";
			} else {
				return getFormattedHoursMinutes(eta, staonata);
			}

		} catch (Exception e) {
			e.printStackTrace();
		}
		return "";

	}

	public static boolean isDateAfterDate(Date d1, Date d2) {
		int ff = 0;
		boolean addRequired = false;
		try {
			ff = d1.compareTo(d2);
			if (ff == 0) {
				addRequired = true;
			} else if (ff < 0) {
				addRequired = true;
			} else if (ff > 0) {
				addRequired = false;
			}
		} catch (Exception e) {

		}
		return addRequired;
	}

	public String getFormattedHoursMinutes(String date1, String date2) {
		String hhmmssformat = "";
		SimpleDateFormat format = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
		Date d1 = null;
		Date d2 = null;
		String Timeformat = "";
		boolean negative = false;
		try {
			d1 = format.parse(date1);
			d2 = format.parse(date2);

			// in milliseconds
			long diff = d1.getTime() - d2.getTime();

			long diffSeconds = diff / 1000 % 60;
			long diffMinutes = diff / (60 * 1000) % 60;
			long diffHours = diff / (60 * 60 * 1000);
			hhmmssformat = df3.format(diffHours) + ":" + df3.format(diffMinutes) + ":" + df3.format(diffSeconds);
			negative = hhmmssformat.contains("-") ? true : false;
			Timeformat = negative ? "-" + hhmmssformat.replaceAll("-", "") : hhmmssformat;
		} catch (Exception e) {
			System.out.println("hh:mm:ss exception :::::   " + e.getLocalizedMessage());
			e.printStackTrace();

		}
		return Timeformat;

	}

	public String getGenericHubName(String hubId, String zone) {
		Connection conAdmin = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String hub = "";
		String hubName = "";
		try {
			conAdmin = DBConnection.getConnectionToDB("AMS");
			pstmt = conAdmin.prepareStatement(GeneralVerticalStatements.GET_GENERIC_HUB_NAME.replaceAll("AMS.dbo.LOCATION", "AMS.dbo.LOCATION_ZONE_" + zone));
			pstmt.setString(1, hubId);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				hub = rs.getString("NAME");
			}
			if (hub.split(",")[0].contains("_")) {
				if (hub.split(",")[0].contains("_")) {
					hubName = hub.split(",")[0].split("_")[0];
				} else {
					hubName = hub.split(",")[0].split("_")[1];
				}
			} else {
				hubName = hub.split(",")[0];
			}
		} catch (Exception e) {
			System.out.println("Error in GeneralVertical Functions:-getGenericHubName " + e.toString());
		} finally {
			DBConnection.releaseConnectionToDB(conAdmin, pstmt, rs);
		}
		return hubName;
	}

	public JSONArray getIndividualTemperatureReportBasedOnTimeRange(int systemId, int clientId, int offset, int userId, String startDate, String endDate, String regNo, String category,
			String TimeRange) {
		JSONArray JsonArray = new JSONArray();
		JSONObject JsonObject = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		MongoClient mongo = null;

		try {
			Calendar currentTime = null;
			Calendar incrementedtime = null;
			mongo = TemperatureConfiguration.getMongoConnection();
			DBCollection collection = mongo.getDB("temperature_module").getCollection("temperature_details");
			BasicDBObject andQuery = new BasicDBObject();
			List<BasicDBObject> obj = new ArrayList<BasicDBObject>();
			obj.add(new BasicDBObject("systemId", systemId));
			obj.add(new BasicDBObject("customerId", clientId));
			obj.add(new BasicDBObject("registrationNo", regNo));
			obj.add(new BasicDBObject("gmt", new BasicDBObject("$gte", sdfDB.parse(cf.getGMT(sdfDB.parse(startDate), offset))).append("$lt", sdfDB.parse(cf.getGMT(sdfDB.parse(endDate), offset)))));
			andQuery.put("$and", obj);
			int i = 0;
			int count = 0;
			Date date = sdfDB.parse(startDate);
			currentTime = Calendar.getInstance();
			incrementedtime = Calendar.getInstance();
			currentTime.setTime(date);
			String SensorName;
			double refer = 0, referTemp = 0;
			double door = 0, doorTemp = 0;
			double middle = 0, middleTemp = 0;
			double Tcontainer = 0, containerTemp = 0;
			incrementedtime.setTime(date);
			incrementedtime.add(Calendar.MINUTE, Integer.parseInt(TimeRange));
			DBCursor cursor = collection.find(andQuery).sort(new BasicDBObject("gmt", 1));
			while (cursor.hasNext()) {
				DBObject theObj = cursor.next();
				JsonObject.put("vehicleNo", theObj.get("registrationNo"));
				JsonObject = new JSONObject();
				BasicDBList tempList = (BasicDBList) theObj.get("temperatureSensorDetails");
				for (int j = 0; j < tempList.size(); j++) {
					BasicDBObject tempObj = (BasicDBObject) tempList.get(j);
					SensorName = tempObj.getString("sensorName").replaceAll("\\s", "");
					JsonObject.put(tempObj.getString("sensorName").replaceAll("\\s", ""), tempObj.getString("value"));
					JsonObject.put(tempObj.getString("name").replaceAll("\\s", ""), tempObj.getString("value"));
					sName sensName = sName.valueOf(SensorName);
					switch (sensName) {
					case ONEWIRE3:
						if (!tempObj.getString("value").equalsIgnoreCase("NA")) {
							referTemp = Double.parseDouble(tempObj.getString("value"));
							break;
						}
					case ONEWIRE1:
						if (!tempObj.getString("value").equalsIgnoreCase("NA")) {
							middleTemp = Double.parseDouble(tempObj.getString("value"));
							break;
						}
					case ONEWIRE2:
						if (!tempObj.getString("value").equalsIgnoreCase("NA")) {
							doorTemp = Double.parseDouble(tempObj.getString("value"));
							break;
						}
					default:
						break;
					}

				}
				containerTemp = Double.parseDouble(String.valueOf(theObj.get("meanTemp")));

				if (isDateAfterDate((Date) theObj.get("gpsDatetime"), incrementedtime.getTime())) {

					if (!String.valueOf(theObj.get("meanTemp")).equalsIgnoreCase("NA")) {
						Tcontainer = Tcontainer + Double.parseDouble(String.valueOf(theObj.get("meanTemp")));
					}

					for (int j = 0; j < tempList.size(); j++) {
						BasicDBObject tempObj = (BasicDBObject) tempList.get(j);
						SensorName = tempObj.getString("sensorName").replaceAll("\\s", "");

						JsonObject.put(tempObj.getString("sensorName").replaceAll("\\s", ""), tempObj.getString("value"));
						JsonObject.put(tempObj.getString("name").replaceAll("\\s", ""), tempObj.getString("value"));
						switch (j) {
						case 0:
							if (!tempObj.getString("value").equalsIgnoreCase("NA")) {
								refer = refer + Double.parseDouble(tempObj.getString("value"));
								break;
							}
						case 1:
							if (!tempObj.getString("value").equalsIgnoreCase("NA")) {
								middle = middle + Double.parseDouble(tempObj.getString("value"));
								break;
							}
						case 2:
							if (!tempObj.getString("value").equalsIgnoreCase("NA")) {
								door = door + Double.parseDouble(tempObj.getString("value"));
								break;
							}
						}
					}
					count += 1;
				} else {
					i++;
					JsonObject.put("slno", i);
					String cat[] = category.split(",");
					if (cat.length == 1) {
						JsonObject = new JSONObject();
						JsonObject.put("DATE", timef.format(theObj.get("gpsDatetime")));
						if (cat[0].equals("T@Container")) {
							JsonObject.put("TEMP", df.format(Tcontainer / count));
						} else {
							for (int j = 0; j < tempList.size(); j++) {
								BasicDBObject tempObj = (BasicDBObject) tempList.get(j);
								if (cat[0].equals(tempObj.getString("name"))) {
									if (tempObj.getString("name").contains("reefer")) {
										JsonObject.put("TEMP", df.format(refer / count));
									} else if (tempObj.getString("name").contains("middle")) {
										JsonObject.put("TEMP", df.format(middle / count));
									} else {
										JsonObject.put("TEMP", df.format(door / count));
									}
								}
							}
						}

					} else if (cat.length == 2) {
						JsonObject = new JSONObject();
						JsonObject.put("DATE", timef.format(theObj.get("gpsDatetime")));
						if (cat[1].equals("T@Container")) {
							JsonObject.put("TEMP1", df.format(Tcontainer / count));
						}

						if (cat[0].equals("T@Container")) {
							JsonObject.put("TEMP", df.format(Tcontainer / count));
						}
						for (int j = 0; j < tempList.size(); j++) {
							BasicDBObject tempObj = (BasicDBObject) tempList.get(j);
							if (cat[0].equals(tempObj.getString("name"))) {
								if (tempObj.getString("name").contains("reefer")) {
									JsonObject.put("TEMP", df.format(refer / count));
								} else if (tempObj.getString("name").contains("middle")) {
									JsonObject.put("TEMP", df.format(middle / count));
								} else {
									JsonObject.put("TEMP", df.format(door / count));
								}
							}

							if (cat[1].equals(tempObj.getString("name"))) {
								if (tempObj.getString("name").contains("reefer")) {
									JsonObject.put("TEMP1", df.format(refer / count));
								} else if (tempObj.getString("name").contains("middle")) {
									JsonObject.put("TEMP1", df.format(middle / count));
								} else {
									JsonObject.put("TEMP1", df.format(door / count));
								}
							}
						}
					} else if (cat.length == 3) {

						JsonObject = new JSONObject();
						JsonObject.put("DATE", timef.format(theObj.get("gpsDatetime")));
						for (int j = 0; j < tempList.size(); j++) {
							BasicDBObject tempObj = (BasicDBObject) tempList.get(j);
							if (cat[0].equals(tempObj.getString("name"))) {

								if (tempObj.getString("name").contains("reefer")) {
									JsonObject.put("TEMP", df.format(refer / count));
								} else if (tempObj.getString("name").contains("middle")) {
									JsonObject.put("TEMP", df.format(middle / count));
								} else {
									JsonObject.put("TEMP", df.format(door / count));
								}
							}

							if (cat[1].equals(tempObj.getString("name"))) {
								if (tempObj.getString("name").contains("reefer")) {
									JsonObject.put("TEMP1", df.format(refer / count));
								} else if (tempObj.getString("name").contains("middle")) {
									JsonObject.put("TEMP1", df.format(middle / count));
								} else {
									JsonObject.put("TEMP1", df.format(door / count));
								}
							}

							if (cat[2].equals(tempObj.getString("name"))) {
								if (tempObj.getString("name").contains("reefer")) {
									JsonObject.put("TEMP2", df.format(refer / count));
								} else if (tempObj.getString("name").contains("middle")) {
									JsonObject.put("TEMP2", df.format(middle / count));
								} else {
									JsonObject.put("TEMP2", df.format(door / count));
								}
							}
						}

						if (cat[0].equals("T@Container")) {
							JsonObject.put("TEMP", df.format(Tcontainer / count));
						}
						if (cat[1].equals("T@Container")) {
							JsonObject.put("TEMP1", df.format(Tcontainer / count));
						}
						if (cat[2].equals("T@Container")) {
							JsonObject.put("TEMP2", df.format(Tcontainer / count));
						}
					}
					currentTime.add(Calendar.MINUTE, Integer.parseInt(TimeRange));
					incrementedtime.add(Calendar.MINUTE, Integer.parseInt(TimeRange));
					JsonArray.put(JsonObject);
					refer = referTemp;
					door = doorTemp;
					middle = middleTemp;
					Tcontainer = containerTemp;
					count = 1;

				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
			mongo.close();
		}
		return JsonArray;
	}

	public ArrayList<Object> getGeofenceCorrectionData(String startDate, String endDate, int offset, int systemId, int clientId, String tripCustId, String zone) {
		JSONArray JsonArray = new JSONArray();
		JSONObject JsonObject = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		ArrayList<Object> finlist = new ArrayList<Object>();
		try {
			int count = 0;
			String array1 = (tripCustId.substring(0, tripCustId.length() - 1));
			String newCustomerList = "'" + array1.toString().replace(",", "','") + "'";

			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(GeneralVerticalStatements.GET_USER_AUDIT_LOG_REPORT.replace("##", "and TRIP_CUST_ID in (" + newCustomerList + ")").replaceAll("AMS.dbo.LOCATION",
					"AMS.dbo.LOCATION_ZONE_" + zone));
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, clientId);
			pstmt.setString(3, startDate);
			pstmt.setString(4, endDate);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				JsonObject = new JSONObject();
				count++;
				String updatedDate = "";
				if (!rs.getString("UPDATED_DATETIME").contains("1900")) {
					updatedDate = sdf.format(rs.getTimestamp("UPDATED_DATETIME"));
				}
				JsonObject.put("slnoIndex", count);
				JsonObject.put("tripNumberIndex", "");
				JsonObject.put("hubNameIndex", rs.getString("HUB_NAME"));
				JsonObject.put("previousLatIndex", rs.getString("PREV_LATITUDE"));
				JsonObject.put("previousLonIndex", rs.getString("PREV_LONGITUDE"));
				JsonObject.put("presentLatIndex", rs.getString("PRESENT_LATITUDE"));
				JsonObject.put("presentLonIndex", rs.getString("PRESENT_LONGITUDE"));
				JsonObject.put("updatedDateIndex", updatedDate);
				JsonObject.put("updatedByIndex", rs.getString("FIRSTNAME") + " " + rs.getString("LASTNAME"));
				JsonObject.put("tripCustNameIndex", rs.getString("NAME"));
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

	public JSONArray getMapViewBuffers(int userId, int customerId, int systemId, String zone, int isLTSP, int tripId) {

		JSONArray BufferArray = new JSONArray();
		JSONObject BufferObject = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			BufferArray = new JSONArray();
			con = DBConnection.getConnectionToDB("AMS");
			String hubQuery = " and HUBID in (select distinct HUB_ID from DES_TRIP_DETAILS where TRIP_ID=" + tripId + ")";
			if (customerId == 0) {
				pstmt = con.prepareStatement(MapViewStatements.GET_BUFFERS_FOR_LTSP_MAP_VIEW.replace("LOCATION", "LOCATION_ZONE_" + zone).concat(hubQuery));
				pstmt.setInt(1, systemId);
			} else {
				pstmt = con.prepareStatement(MapViewStatements.GET_BUFFERS_FOR_MAP_VIEW.replace("LOCATION", "LOCATION_ZONE_" + zone).concat(hubQuery));
				pstmt.setInt(1, customerId);
				pstmt.setInt(2, systemId);
			}
			rs = pstmt.executeQuery();
			while (rs.next()) {
				BufferObject = new JSONObject();
				BufferObject.put("buffername", rs.getString("NAME"));
				BufferObject.put("latitude", rs.getString("LATITUDE"));
				BufferObject.put("longitude", rs.getString("LONGITUDE"));
				BufferObject.put("radius", rs.getString("RADIUS"));
				if (rs.getString("IMAGE") != "")
					BufferObject.put("imagename", rs.getString("IMAGE"));
				else
					BufferObject.put("imagename", rs.getString("IMAGE"));
				BufferObject.put("hubId", rs.getString("HUBID"));
				BufferArray.put(BufferObject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}

		return BufferArray;

	}

	public JSONArray getMapViewPolygons(int userId, int customerId, int systemId, String zone, int isLTSP, int tripId) {

		JSONArray PolygonArray = new JSONArray();
		JSONObject PolygonObject = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			PolygonArray = new JSONArray();
			con = DBConnection.getConnectionToDB("AMS");
			String hubQuery = " and b.HUBID in (select HUB_ID from DES_TRIP_DETAILS where TRIP_ID=" + tripId + ")";
			if (customerId == 0) {
				pstmt = con.prepareStatement(MapViewStatements.GET_POLYGONS_FOR_MAP_TRIP.replace("LOCATION_ZONE", "LOCATION_ZONE_" + zone).replace("##", hubQuery));
				pstmt.setInt(1, systemId);
			} else if (isLTSP == -1 && customerId > 0) {
				pstmt = con.prepareStatement(MapViewStatements.GET_POLYGONS_FOR_USER_MAP_TRIP.replace("LOCATION_ZONE", "LOCATION_ZONE_" + zone).replace("##", hubQuery));
				pstmt.setInt(1, systemId);
				pstmt.setInt(2, userId);
				pstmt.setInt(3, customerId);
				pstmt.setInt(4, systemId);
			} else {
				pstmt = con.prepareStatement(MapViewStatements.GET_POLYGONS_FOR_MAP_TRIP.replace("LOCATION_ZONE", "LOCATION_ZONE_" + zone).replace("##", hubQuery));
				pstmt.setInt(1, customerId);
				pstmt.setInt(2, systemId);
			}
			rs = pstmt.executeQuery();
			while (rs.next()) {
				PolygonObject = new JSONObject();
				PolygonObject.put("polygonname", rs.getString("NAME"));
				PolygonObject.put("latitude", rs.getString("LATITUDE"));
				PolygonObject.put("longitude", rs.getString("LONGITUDE"));
				PolygonObject.put("sequence", rs.getString("SEQUENCE_ID"));
				PolygonObject.put("hubid", rs.getString("HUBID"));
				PolygonArray.put(PolygonObject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return PolygonArray;
	}

	public JSONArray getInBoundSHTrips(int systemId, int clientId, int offset, int userId, String hubIds) {

		JSONArray jsonArray = new JSONArray();
		JSONObject jsonobject = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int count = 0;
		SimpleDateFormat dateFormatForArguements = new SimpleDateFormat("dd/MM/yyyy-HH:mm:ss");
		try {
			String hubArray = "";
			String hubList = "";
			jsonArray = new JSONArray();
			if (!hubIds.equals("")) {
				hubArray = (hubIds.substring(0, hubIds.length() - 1));
				hubList = "'" + hubArray.toString().replace(",", "','") + "'";
				con = DBConnection.getConnectionToDB("AMS");
				pstmt = con.prepareStatement(GeneralVerticalStatements.GET_INBOUND_SH_TRIPS.replace("$$", " and td.STATUS='OPEN' ").replace("##", " and ds.HUB_ID in (" + hubList + ")").replace("330",
						"" + offset));
				pstmt.setInt(1, systemId);
				pstmt.setInt(2, clientId);
				rs = pstmt.executeQuery();
				while (rs.next()) {
					count++;
					jsonobject = new JSONObject();
					jsonobject.put("slNo", count);
					jsonobject.put("tripID", rs.getString("TRIP_ID"));
					jsonobject.put("status", rs.getString("STATUS"));
					jsonobject.put("vehicleNo", rs.getString("VEHICLE_NO"));
					jsonobject.put("ETA", rs.getString("ETA").contains("1900") ? "" : mmddyyy.format(sdfDB.parse(rs.getString("ETA"))));
					jsonobject.put("STA_WRT_STD", rs.getString("STA_WRT_STD").contains("1900") ? "" : mmddyyy.format(sdfDB.parse(rs.getString("STA_WRT_STD"))));
					if (rs.getInt("DELAY") < 0) {
						jsonobject.put("delay", "-" + cf.convertMinutesToHHMMFormat(Math.abs(rs.getInt("DELAY"))));
					} else {
						jsonobject.put("delay", cf.convertMinutesToHHMMFormat(rs.getInt("DELAY")));
					}
					int netDelay = calculateNetDelayForSH(rs.getInt("ID"), con, rs.getInt("SEQUENCE"));
					jsonobject.put("netDelay", cf.convertMinutesToHHMMFormat(rs.getInt("DELAY") - netDelay));
					String param = rs.getInt("ID") + "," + "'" + rs.getString("VEHICLE_NO") + "'" + "," + "'" + dateFormatForArguements.format(sdfDB.parse(rs.getString("INSERTED_TIME"))) + "'" + ","
					+ "'" + dateFormatForArguements.format(sdfDB.parse(rs.getString("endDate"))) + "'" + "," + "'" + rs.getString("status") + "'" + "," + rs.getInt("routeId");
					jsonobject.put("tripNo", "<p><a style='color: black' href='javascript:void(0);' onclick=showTripAndAlertDetails(" + param + ");>" + rs.getString("TRIP_NO") + "</a></p>");
					jsonArray.put(jsonobject);
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jsonArray;

	}

	public int calculateNetDelayForSH(int tripId, Connection con, int sequence) {

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int netDelay = 0;
		try {
			pstmt = con.prepareStatement(GeneralVerticalStatements.GET_SH_ENROUTE_DETAILS);
			pstmt.setInt(1, tripId);
			pstmt.setInt(2, sequence);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				if (rs.getInt("DELAY") != -9999) {
					netDelay += rs.getInt("DELAY");
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(null, pstmt, rs);
		}
		return netDelay;
	}

	public JSONArray getInBoundDestinationCHTrips(int systemId, int clientId, int offset, int userId, String hubIds, String zone) {

		JSONArray jsonArray = new JSONArray();
		JSONObject jsonobject = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int count = 0;
		SimpleDateFormat dateFormatForArguements = new SimpleDateFormat("dd/MM/yyyy-HH:mm:ss");
		try {
			String hubArray = "";
			String hubList = "";
			jsonArray = new JSONArray();
			if (!hubIds.equals("")) {
				hubArray = (hubIds.substring(0, hubIds.length() - 1));
				hubList = "'" + hubArray.toString().replace(",", "','") + "'";
				con = DBConnection.getConnectionToDB("AMS");
				pstmt = con.prepareStatement(GeneralVerticalStatements.GET_INBOUND_DESTINATION_TRIPS.replace("$$", " and td.STATUS='OPEN' ").replace("##", " where HUB_ID in (" + hubList + ")")
						.replace("330", "" + offset).replaceAll("AMS.dbo.LOCATION", "AMS.dbo.LOCATION_ZONE_" + zone));

				pstmt.setInt(1, offset);
				pstmt.setInt(2, systemId);
				pstmt.setInt(3, clientId);
				rs = pstmt.executeQuery();
				while (rs.next()) {
					count++;
					jsonobject = new JSONObject();
					jsonobject.put("slNo", count);
					jsonobject.put("status", rs.getString("STATUS"));
					jsonobject.put("tripId", rs.getString("TRIP_ID"));
					jsonobject.put("tripNo", rs.getString("TRIP_NO"));
					jsonobject.put("ETA", rs.getString("ETA_HH_MM").contains("1900") ? "" : mmddyyy.format(sdfDB.parse(rs.getString("ETA_HH_MM"))));
					jsonobject.put("STA", rs.getString("STA_WRT_ATD").contains("1900") ? "" : mmddyyy.format(sdfDB.parse(rs.getString("STA_WRT_ATD"))));

					if (rs.getInt("DELAY") < 0) {
						jsonobject.put("delay", "-" + cf.convertMinutesToHHMMFormat(Math.abs(rs.getInt("DELAY"))));
					} else {
						jsonobject.put("delay", cf.convertMinutesToHHMMFormat(rs.getInt("DELAY")));
					}
					int netDelay = calculateNetDelayForDestination(rs.getInt("ID"), con);
					jsonobject.put("netDelay", cf.convertMinutesToHHMMFormat(rs.getInt("DELAY") - netDelay));
					String param = rs.getInt("ID") + "," + "'" + rs.getString("VEHICLE_NO") + "'" + "," + "'" + dateFormatForArguements.format(sdfDB.parse(rs.getString("INSERTED_TIME"))) + "'" + ","
					+ "'" + dateFormatForArguements.format(sdfDB.parse(rs.getString("endDate"))) + "'" + "," + "'" + rs.getString("status") + "'" + "," + rs.getInt("routeId");
					jsonobject.put("tripId", "<p><a style='color: black' href='javascript:void(0);' onclick=showTripAndAlertDetails(" + param + ");>" + rs.getString("TRIP_ID") + "</a></p>");
					jsonArray.put(jsonobject);
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jsonArray;

	}

	public int calculateNetDelayForDestination(int tripId, Connection con) {
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int netDelay = 0;
		try {
			pstmt = con.prepareStatement(GeneralVerticalStatements.GET_ENROUTE_DETAILS);
			pstmt.setInt(1, tripId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				if (rs.getInt("DELAY") != -9999) {
					netDelay += rs.getInt("DELAY");
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(null, pstmt, rs);
		}
		return netDelay;

	}

	public JSONArray getOutBoundSHTrips(int systemId, int clientId, int offset, int userId, String hubIds) {

		JSONArray jsonArray = new JSONArray();
		JSONObject jsonobject = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int count = 0;
		SimpleDateFormat dateFormatForArguements = new SimpleDateFormat("dd/MM/yyyy-HH:mm:ss");
		try {
			String hubArray = "";
			String hubList = "";
			jsonArray = new JSONArray();
			if (!hubIds.equals("")) {
				hubArray = (hubIds.substring(0, hubIds.length() - 1));
				hubList = "'" + hubArray.toString().replace(",", "','") + "'";
				con = DBConnection.getConnectionToDB("AMS");
				pstmt = con.prepareStatement(GeneralVerticalStatements.GET_OUTBOUND_SH_TRIPS.replace("$$", " and td.STATUS='OPEN' ").replace("##", " and ds.HUB_ID in (" + hubList + ")"));
				pstmt.setInt(1, offset);
				pstmt.setInt(2, offset);
				pstmt.setInt(3, systemId);
				pstmt.setInt(4, clientId);
				rs = pstmt.executeQuery();
				while (rs.next()) {
					count++;
					jsonobject = new JSONObject();
					jsonobject.put("slNo", count);
					jsonobject.put("status", rs.getString("STATUS"));
					jsonobject.put("vehicleNo", rs.getString("VEHICLE_NO"));
					jsonobject.put("ATA", rs.getString("ATA@SH").contains("1900") ? "" : mmddyyy.format(sdfDB.parse(rs.getString("ATA@SH"))));
					jsonobject.put("ATD", rs.getString("ATD@SH").contains("1900") ? "" : mmddyyy.format(sdfDB.parse(rs.getString("ATD@SH"))));
					if (rs.getInt("EXCESS_DETENTION") < 0) {
						jsonobject.put("excessDetention", 0);
					} else {
						jsonobject.put("excessDetention", cf.convertMinutesToHHMMFormat(rs.getInt("EXCESS_DETENTION")));
					}
					String param = rs.getInt("ID") + "," + "'" + rs.getString("VEHICLE_NO") + "'" + "," + "'" + dateFormatForArguements.format(sdfDB.parse(rs.getString("INSERTED_TIME"))) + "'" + ","
					+ "'" + dateFormatForArguements.format(sdfDB.parse(rs.getString("endDate"))) + "'" + "," + "'" + rs.getString("status") + "'" + "," + rs.getInt("routeId");
					jsonobject.put("tripNo", "<p><a style='color: black' href='javascript:void(0);' onclick=showTripAndAlertDetails(" + param + ");>" + rs.getString("TRIP_NO") + "</a></p>");
					jsonArray.put(jsonobject);
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jsonArray;

	}

	public JSONArray getOutBoundOriginCHTrips(int systemId, int clientId, int offset, int userId, String hubIds, String zone) {

		JSONArray jsonArray = new JSONArray();
		JSONObject jsonobject = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int count = 0;
		SimpleDateFormat dateFormatForArguements = new SimpleDateFormat("dd/MM/yyyy-HH:mm:ss");
		try {
			String hubArray = "";
			String hubList = "";
			jsonArray = new JSONArray();
			if (!hubIds.equals("")) {
				hubArray = (hubIds.substring(0, hubIds.length() - 1));
				hubList = "'" + hubArray.toString().replace(",", "','") + "'";

				con = DBConnection.getConnectionToDB("AMS");
				pstmt = con.prepareStatement(GeneralVerticalStatements.GET_OUTBOUND_ORIGIN_TRIPS.replace("$$", " and td.STATUS='OPEN' ").replace("##", " where HUB_ID in (" + hubList + ")")
						.replaceAll("AMS.dbo.LOCATION", "AMS.dbo.LOCATION_ZONE_" + zone));
				pstmt.setInt(1, offset);
				pstmt.setInt(2, offset);
				pstmt.setInt(3, offset);
				pstmt.setInt(4, offset);
				pstmt.setInt(5, offset);
				pstmt.setInt(6, systemId);
				pstmt.setInt(7, clientId);
				rs = pstmt.executeQuery();
				while (rs.next()) {
					count++;
					jsonobject = new JSONObject();
					jsonobject.put("slNo", count);
					jsonobject.put("status", rs.getString("STATUS"));
					jsonobject.put("tripNo", rs.getString("TRIP_NO"));
					jsonobject.put("ATP", rs.getString("ATP").contains("1900") ? "" : mmddyyy.format(sdfDB.parse(rs.getString("ATP"))));
					if (rs.getInt("PLACEMENT_DELAY") < 0) {
						jsonobject.put("placementDelay", "-" + cf.convertMinutesToHHMMFormat(Math.abs(rs.getInt("PLACEMENT_DELAY"))));
					} else {
						jsonobject.put("placementDelay", cf.convertMinutesToHHMMFormat(rs.getInt("PLACEMENT_DELAY")));
					}
					jsonobject.put("ATD", rs.getString("ATD").contains("1900") ? "" : mmddyyy.format(sdfDB.parse(rs.getString("ATD"))));
					jsonobject.put("nextTouchPoint", rs.getString("NEXT_TOUCH_POINT"));
					jsonobject.put("ETA", rs.getString("DESTINATION_ETA").contains("1900") ? "" : mmddyyy.format(sdfDB.parse(rs.getString("DESTINATION_ETA"))));
					jsonobject.put("STD_WRT_ATD", rs.getString("STA_WRT_ATD").contains("1900") ? "" : mmddyyy.format(sdfDB.parse(rs.getString("STA_WRT_ATD"))));
					jsonobject.put("ATA", rs.getString("ATA").contains("1900") ? "" : mmddyyy.format(sdfDB.parse(rs.getString("ATA"))));
					String param = rs.getInt("ID") + "," + "'" + rs.getString("VEHICLE_NO") + "'" + "," + "'" + dateFormatForArguements.format(sdfDB.parse(rs.getString("INSERTED_TIME"))) + "'" + ","
					+ "'" + dateFormatForArguements.format(sdfDB.parse(rs.getString("endDate"))) + "'" + "," + "'" + rs.getString("status") + "'" + "," + rs.getInt("routeId");
					jsonobject.put("tripId", "<p><a style='color: black' href='javascript:void(0);' onclick=showTripAndAlertDetails(" + param + ");>" + rs.getString("TRIP_ID") + "</a></p>");
					jsonArray.put(jsonobject);
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jsonArray;

	}

	public JSONArray getSmarthubDetails(int systemId, int clientId, String zone) {
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonobject = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			jsonArray = new JSONArray();
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(GeneralVerticalStatements.GET_SMARTHUB_DETAILS.replaceAll("AMS.dbo.LOCATION", "AMS.dbo.LOCATION_ZONE_" + zone));
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, clientId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				jsonobject = new JSONObject();
				if (rs.getString("NAME") != null && !rs.getString("NAME").equals("")) {
					String[] locArray = rs.getString("NAME").split(",");
					jsonobject.put("name", locArray[0] + "," + locArray[1]);
					jsonobject.put("hubId", rs.getString("HUBID"));
					jsonArray.put(jsonobject);
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jsonArray;
	}

	public JSONArray getTripCustomerType(int systemId, int custId) {
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			jsonArray = new JSONArray();
			jsonObject = new JSONObject();

			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(GeneralVerticalStatements.GET_TRIP_CUSTOMER_TYPE_FROM_LOOKUP_DETAILS);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				jsonObject = new JSONObject();
				jsonObject.put("tripCustomerType", rs.getString("LABEL"));
				jsonObject.put("tripCustomerValue", rs.getString("VALUE"));
				jsonArray.put(jsonObject);
			}
		} catch (Exception e) {
			System.out.println("Error in getTripCustomerType " + e.toString());
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jsonArray;

	}

	public JSONArray getTripsForCustomer(int systemId, int clientId, int offset, int userId, String tripCustId, String startDate, String endDate) {

		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			jsonArray = new JSONArray();
			jsonObject = new JSONObject();

			if (tripCustId.length() > 1) {
				String array1 = (tripCustId.substring(0, tripCustId.length() - 1));
				String newCustomerList = "'" + array1.toString().replace(",", "','") + "'";
				con = DBConnection.getConnectionToDB("AMS");
				if (!startDate.equals("") && !endDate.equals("")) {
					pstmt = con.prepareStatement(GeneralVerticalStatements.GET_TRIPS.replace("&&", " and INSERTED_TIME between dateadd(mi,-?,?) and dateadd(mi,-?,?)").replace("##",
							"and td.TRIP_CUSTOMER_ID in (" + newCustomerList + ")"));
					pstmt.setInt(1, systemId);
					pstmt.setInt(2, clientId);
					pstmt.setInt(3, offset);
					pstmt.setString(4, sdfDB.format(ddmmyyyy.parse(startDate)));
					pstmt.setInt(5, offset);
					pstmt.setString(6, sdfDB.format(ddmmyyyy.parse(endDate)));
				} else {
					pstmt = con.prepareStatement(GeneralVerticalStatements.GET_TRIPS.replace("&&", "").replace("##", "and td.TRIP_CUSTOMER_ID in (" + newCustomerList + ")"));
					pstmt.setInt(1, systemId);
					pstmt.setInt(2, clientId);
				}
				rs = pstmt.executeQuery();
				while (rs.next()) {
					jsonObject = new JSONObject();
					jsonObject.put("tripId", rs.getString("TRIP_ID"));
					jsonObject.put("tripName", rs.getString("TRIP_NAME"));
					jsonArray.put(jsonObject);
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jsonArray;
	}

	public JSONArray getTrips(int systemId, int clientId, int offset, int userId, String tripIds) {

		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int count = 0;
		try {
			String array1 = (tripIds.substring(0, tripIds.length() - 1));
			String newtripList = "'" + array1.toString().replace(",", "','") + "'";

			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(GeneralVerticalStatements.GET_TRIP_DETAILS.replace("&&", String.valueOf(offset)).replace("##", " where td.TRIP_ID in (" + newtripList + ")"));
			rs = pstmt.executeQuery();
			while (rs.next()) {
				int tripId = rs.getInt("TRIP_ID");
				jsonObject = new JSONObject();
				count++;
				String STD = "";
				String endDate = "";
				jsonObject.put("slno", count);
				if (rs.getString("STD") != null) {
					STD = sdf.format(sdfDB.parse(rs.getString("STD")));
				}
				if (rs.getString("END_DATE") != null) {
					endDate = sdf.format(sdfDB.parse(rs.getString("END_DATE")));
				}
				jsonObject.put("tripName", rs.getString("TRIP_NAME"));
				jsonObject.put("tripNo", rs.getString("TRIP_NO"));
				jsonObject.put("custName", rs.getString("NAME"));
				jsonObject.put("startDate", STD);
				jsonObject.put("endDate", endDate);
				jsonObject.put("tripId", rs.getString("TRIP_ID"));
				jsonObject.put("assetNo", rs.getString("ASSET_NUMBER"));
				jsonObject.put("status", rs.getString("STATUS"));
				if(rs.getString("STATUS").equalsIgnoreCase("CLOSED"))
				{
					jsonObject.put("export", "<div class='col-lg-1 col-md-1 col-xs-1' style='white-space: nowrap'>" + " <a href='javascript:void(0);' title='Download Excel'> "
							+ " <img src='/ApplicationImages/excel.png' id='excelBtnId' onclick=getReport(" + tripId + ",'1'" + "); style='width: 36px;'></a>"
							+ " <a href='javascript:void(0);' title='Download PDF'> " + " <img src='/ApplicationImages/pdf.png' id='graphBtnId' onclick=getReport(" + tripId + ",'2'"
							+ "); style='width: 29px;'></a><a href='javascript:void(0);' title='Push to SAP'> " + " <img src='/ApplicationImages/sendtosap.png' id='sapBtnId' onclick=getReport1(" + tripId + ",'4'" + "); style='width: 29px;'></a></div>");	
				}
				else
				{
					jsonObject.put("export", "<div class='col-lg-1 col-md-1 col-xs-1' style='white-space: nowrap'>" + " <a href='javascript:void(0);' title='Download Excel'> "
							+ " <img src='/ApplicationImages/excel.png' id='excelBtnId' onclick=getReport(" + tripId + ",'1'" + "); style='width: 36px;'></a>"
							+ " <a href='javascript:void(0);' title='Download PDF'> " + " <img src='/ApplicationImages/pdf.png' id='graphBtnId' onclick=getReport(" + tripId + ",'2'"
							+ "); style='width: 29px;'></a></div>");	
				}
				jsonArray.put(jsonObject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jsonArray;
	}

	public JSONArray getStaticDashBoardCounts(int clientId, int systemId) {

		JSONArray jsonArray = new JSONArray();
		JSONObject obj = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		try {
			con = DBConnection.getConnectionToDB("AMS");

			pstmt = con.prepareStatement(GeneralVerticalStatements.GET_DASHBOARD_COUNTS);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, clientId);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				obj = new JSONObject();
				obj.put("ontimeCount", rs.getInt("ONTIME"));
				obj.put("delayLess", rs.getInt("DELAYED_LESS_HR"));
				obj.put("delayGreater", rs.getInt("DELAYED_GREATER_HR"));
				obj.put("enroutePlacement", rs.getInt("ENROUTE_ONTIME") + rs.getInt("ENROUTE_DELAYED"));
				obj.put("enrouteOntime", rs.getInt("ENROUTE_ONTIME"));
				obj.put("enrouteDelay", rs.getInt("ENROUTE_DELAYED"));
				obj.put("loadingDetention", rs.getInt("LOADING_DETENTION"));
				obj.put("unloadingDetention", rs.getInt("UNLOADING_DETENTION"));
				obj.put("delayLateDeparture", rs.getInt("DELAYED_LATE_DEPARTURE"));
				obj.put("stoppageDelayLess", rs.getInt("STOPPAGE_DELAYED_LESS"));
				obj.put("detentionDelayLess", rs.getInt("DETENTION_DELAYED_LESS"));
				obj.put("deviationDelayless", rs.getInt("DEVIATION_DELAYED_LESS"));
				obj.put("stoppagedelayGreater", rs.getInt("STAOPPAGE_DELAYED_GREATER"));
				obj.put("deviationDelayGreater", rs.getInt("DEVIATION_DELAYED_GREATER"));
				obj.put("detentionDelayedGreater", rs.getInt("DETENTION_DELAYED_GREATER"));
				obj.put("ontimeStoopage", rs.getInt("STOPPAGE_ONTIME"));
				obj.put("ontimeDetention", rs.getInt("DETENTION_ONTIME"));
				obj.put("ontimeDeviation", rs.getInt("DEVIATION_ONTIME"));
				jsonArray.put(obj);
			}

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jsonArray;

	}

	public JSONArray getAlertDashBoardCounts(int clientId, int systemId) {

		JSONArray jsonArray = new JSONArray();
		JSONObject obj = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		try {
			con = DBConnection.getConnectionToDB("AMS");

			pstmt = con.prepareStatement(GeneralVerticalStatements.GET_DASHBOARD_COUNTS);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, clientId);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				obj = new JSONObject();

				obj.put("doorCount", rs.getInt("DOOR_ACKNOWLEDGED") + "/" + rs.getInt("DOOR_TOTAL"));
				obj.put("panicCount", rs.getInt("PANIC_ACKNOWLEDGED") + "/" + rs.getInt("PANIC_TOTAL"));
				obj.put("nonReportingCount", rs.getInt("REPORTING_ACKNOWLEDGED") + "/" + rs.getInt("REPORTING_TOTAL"));
				obj.put("tempCount", rs.getInt("TEMP_ACKNOWLEDGED") + "/" + rs.getInt("TEMP_TOTAL"));
				obj.put("humidityCount", rs.getInt("HUMIDITY_ACKNOWLEDGED") + "/" + rs.getInt("HUMIDITY_TOTAL"));
				obj.put("reeferCount", rs.getInt("REEFER_ACKNOWLEDGED") + "/" + rs.getInt("REEFER_TOTAL"));
				jsonArray.put(obj);
			}

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jsonArray;
	}

	public JSONArray getVehicleWiseTemperatureReport(int systemId, int clientId, int offset, int userId, String startDate, String endDate, String regNo) {

		JSONArray JsonArray = new JSONArray();
		JSONObject JsonObject = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		List<JSONObject> expList = null;
		List<TemperatureBean> beanList = null;
		TemperatureBean ieBean = null;
		try {
			LinkedHashSet<Date> tempSet = new LinkedHashSet<Date>();
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(GeneralVerticalStatements.GET_TEMPERATURE_REPORT);
			pstmt.setInt(1, offset);
			pstmt.setString(2, regNo);
			pstmt.setInt(3, offset);
			pstmt.setString(4, startDate);
			pstmt.setInt(5, offset);
			pstmt.setString(6, endDate);
			pstmt.setInt(7, offset);
			pstmt.setString(8, regNo);
			pstmt.setInt(9, offset);
			pstmt.setString(10, startDate);
			pstmt.setInt(11, offset);
			pstmt.setString(12, endDate);
			rs = pstmt.executeQuery();
			expList = new ArrayList<JSONObject>();
			String reffer = "";
			int count = 0;
			while (rs.next()) {
				count++;
				JsonObject = new JSONObject();
				JsonObject.put("datetime", rs.getTimestamp("GMT"));
				JsonObject.put("ioValue", rs.getString("IO_VALUE"));
				JsonObject.put("location", rs.getString("LOCATION"));
				JsonObject.put("category", rs.getString("IO_CATEGORY"));

				expList.add(JsonObject);
				tempSet.add(rs.getTimestamp("GMT"));
			}
			beanList = new ArrayList<TemperatureBean>();
			String t1 = "NA";
			String t2 = "NA";
			String t3 = "NA";
			Date prevDate = null;
			Date prevDate1 = null;
			Date prevDate2 = null;
			int j = 0;
			for (Date date : tempSet) {
				if (j == 0) {
					prevDate = date;
				}
				j++;
				ieBean = new TemperatureBean();
				for (JSONObject obj : expList) {
					Date currDate = (Date) obj.get("datetime");
					if (obj.get("datetime").equals(date)) {
						ieBean.setGmt(obj.getString("datetime"));
						ieBean.setLocation(obj.getString("location"));

						// TEMPERATURE 1
						if (obj.getString("category").equals("TEMPERATURE1")) {
							ieBean.setT1(obj.getString("ioValue"));
							t1 = obj.getString("ioValue");
							prevDate = currDate;
						} else {
							ieBean.setT1(t1);
							int diff = cf.getTimeDiffrence(prevDate, currDate);
							if (prevDate != null && diff >= 5) {
								t1 = "NA";
								ieBean.setT1(t1);
							} else {
								ieBean.setT1(t1);
							}
						}

						// TEMPERATURE 2
						if (obj.getString("category").equals("TEMPERATURE2")) {
							ieBean.setT2(obj.getString("ioValue"));
							t2 = obj.getString("ioValue");
							prevDate1 = currDate;
						} else {
							ieBean.setT2(t2);
							int diff = cf.getTimeDiffrence(prevDate1, currDate);
							if (prevDate1 != null && diff >= 5) {
								t2 = "NA";
								ieBean.setT2(t2);
							} else {
								ieBean.setT2(t2);
							}
						}

						// TEMPERATURE 3
						if (obj.getString("category").equals("TEMPERATURE3")) {
							ieBean.setT3(obj.getString("ioValue"));
							t3 = obj.getString("ioValue");
							prevDate2 = currDate;
						} else {
							ieBean.setT3(t3);
							int diff = cf.getTimeDiffrence(prevDate2, currDate);
							if (prevDate2 != null && diff >= 5) {
								t3 = "NA";
								ieBean.setT3(t3);
							} else {
								ieBean.setT3(t3);
							}
						}
						if (obj.getString("category").equals("REEFER")) {
							if (obj.getString("ioValue").equals("0")) {
								reffer = "OFF";
							} else if (obj.getString("ioValue").equals("1")) {
								reffer = "ON";
							} else {
								reffer = obj.getString("ioValue");
							}
							ieBean.setReefer(reffer);
						}
					}
				}
				beanList.add(ieBean);
			}
			int i = 0;
			Collections.sort(beanList);
			for (TemperatureBean bean : beanList) {
				i++;
				JsonObject = new JSONObject();
				JsonObject.put("slno", i);
				JsonObject.put("datetime", sdf1.format(sdfDB.parseObject((bean.getGmt()))));
				JsonObject.put("t1", bean.getT1());
				JsonObject.put("t2", bean.getT2());
				JsonObject.put("t3", bean.getT3());
				JsonObject.put("reefer", bean.getReefer());
				JsonObject.put("location", bean.getLocation());
				JsonObject.put("gmt", timef.format(sdfDB.parseObject((bean.getGmt()))));
				JsonArray.put(JsonObject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return JsonArray;
	}

	public ArrayList<Object> getSwipedReportData(int clientId, int systemId, int offset, String startDate, String endDate) {
		JSONArray JsonArray = new JSONArray();
		JSONObject JsonObject = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		ArrayList<Object> finlist = new ArrayList<Object>();
		try {
			int count = 0;
			con = DBConnection.getConnectionToDB("AMS");

			pstmt = con.prepareStatement(GeneralVerticalStatements.GET_SWIPED_DATA.replace("#", "HISTORY_DATA_" + systemId).replace("$", "AMS_Archieve.dbo.GE_DATA_" + systemId));
			pstmt.setInt(1, offset);
			pstmt.setString(2, startDate);
			pstmt.setString(3, endDate);
			pstmt.setInt(4, clientId);
			pstmt.setInt(5, offset);
			pstmt.setString(6, startDate);
			pstmt.setString(7, endDate);
			pstmt.setInt(8, clientId);

			rs = pstmt.executeQuery();
			while (rs.next()) {

				JsonObject = new JSONObject();
				count++;
				JsonObject.put("slnoIndex", count);
				JsonObject.put("vehicleNoIndex", rs.getString("REGISTRATION_NO"));
				JsonObject.put("driverNameIndex", rs.getString("Driver_name"));
				JsonObject.put("driverKeyIndex", rs.getString("DRIVER_ID"));
				JsonObject.put("timeIndex", rs.getString("DATETIME"));
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

	public ArrayList<Object> getVehicleTripDetailsData(int clientId, int systemId, int offset, String startDate, String endDate, String vehcileNo, String vehicleGroup) {
		JSONArray JsonArray = new JSONArray();
		JSONObject JsonObject = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		ArrayList<Object> finlist = new ArrayList<Object>();
		try {
			int count = 0;
			con = DBConnection.getConnectionToDB("AMS");
			if (vehcileNo != null && !vehcileNo.equals("")) {
				pstmt = con.prepareStatement(GeneralVerticalStatements.GET_VEHICLE_TRIP_DETAILS.replace("#", "ASSET_NUMBER=?"));
				pstmt.setString(3, vehcileNo);
			} else {
				pstmt = con.prepareStatement(GeneralVerticalStatements.GET_VEHICLE_TRIP_DETAILS.replace("#", "lvs.GROUP_NAME=?"));
				pstmt.setString(3, vehicleGroup);
			}
			pstmt.setInt(1, offset);
			pstmt.setInt(2, offset);
			pstmt.setInt(4, offset);
			pstmt.setString(5, startDate);
			pstmt.setInt(6, offset);
			pstmt.setString(7, endDate);
			pstmt.setInt(8, systemId);
			pstmt.setInt(9, clientId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				JsonObject = new JSONObject();
				count++;
				JsonObject.put("slnoIndex", count);
				JsonObject.put("groupIndex", rs.getString("GROUP_NAME"));
				JsonObject.put("vehicleNoIndex", rs.getString("ASSET_NUMBER"));
				JsonObject.put("vehicleTypeIndex", rs.getString("VehicleType"));
				if (rs.getString("Fullname") != null) {
					JsonObject.put("driverNameIndex", rs.getString("Fullname"));
				} else {
					JsonObject.put("driverNameIndex", "");
				}
				JsonObject.put("startingTimeIndex", sdf.format(sdfDB.parse(rs.getString("ACTUAL_TRIP_START_TIME"))));
				if (rs.getString("ACTUAL_TRIP_END_TIME") != null) {
					JsonObject.put("endingTimeIndex", sdf.format(sdfDB.parse(rs.getString("ACTUAL_TRIP_END_TIME"))));
				} else {
					JsonObject.put("endingTimeIndex", "");
				}
				if (rs.getString("START_ODOMETER") != null) {
					JsonObject.put("startingOdometerIndex", rs.getString("START_ODOMETER"));
				} else {
					JsonObject.put("startingOdometerIndex", "");
				}
				JsonObject.put("endingOdometerTime", rs.getString("END_ODOMETER"));
				JsonObject.put("totalHoursOnTrip", cf.convertMinutesToHHMMFormat(Integer.parseInt(rs.getString("TOTAL_TRIP_MIN"))));
				JsonObject.put("tripTotalKilometers", rs.getString("ACTUAL_DISTANCE"));
				JsonObject.put("totalNoOfEmployees", rs.getString("SWIPE_COUNT"));
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

	public ArrayList<Object> getVehicleTripSummaryData(int clientId, int systemId, int offset, String startDate, String endDate, String vehcileNo1, String vehicleGroup1) {
		JSONArray JsonArray = new JSONArray();
		JSONObject JsonObject = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		ArrayList<Object> finlist = new ArrayList<Object>();
		try {
			int count = 0;
			con = DBConnection.getConnectionToDB("AMS");
			if (vehcileNo1 != null && !vehcileNo1.equals("")) {
				pstmt = con.prepareStatement(GeneralVerticalStatements.GET_VEHICLE_TRIP_SUMMARY);
				pstmt.setString(1, vehcileNo1);
			} else {
				pstmt = con.prepareStatement(GeneralVerticalStatements.GET_GROUP_TRIP_SUMMARY);
				pstmt.setString(1, vehicleGroup1);
			}
			pstmt.setInt(2, offset);
			pstmt.setString(3, startDate);
			pstmt.setInt(4, offset);
			pstmt.setString(5, endDate);
			pstmt.setInt(6, systemId);
			pstmt.setInt(7, clientId);

			rs = pstmt.executeQuery();
			while (rs.next()) {

				JsonObject = new JSONObject();
				count++;

				JsonObject.put("slnoIndex", count);
				if (vehcileNo1 != null && !vehcileNo1.equals("")) {
					JsonObject.put("vehicleNoIndex", rs.getString("ASSET_NUMBER"));
					JsonObject.put("groupIndex", "");
				} else {
					JsonObject.put("groupIndex", rs.getString("GROUP_NAME"));
					JsonObject.put("vehicleNoIndex", "");
				}
				JsonObject.put("noOfTripsIndex", rs.getString("TRIP_COUNT"));
				JsonObject.put("noOfDriversIndex", " ");
				JsonObject.put("totalDistanceIndex", rs.getString("TOTAL_DISTANCE"));
				JsonObject.put("noOfPassengersIndex", rs.getString("SUM_PAS"));
				JsonObject.put("averagePassengersPerTrip", rs.getString("AVG_PAS"));
				JsonObject.put("averageDistancePerTrip", rs.getString("AVG_DIS"));
				JsonObject.put("averageDistancePerDriver", " ");// rs.getString("DATETIME"));
				JsonObject.put("averageTimePerTrip", rs.getString("AVG_TIME"));
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

	public JSONArray getGroupName(int systemId, int clientId) {
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonobject = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			jsonArray = new JSONArray();
			jsonobject = new JSONObject();
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(GeneralVerticalStatements.GET_GROUP_NAME);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, clientId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				jsonobject = new JSONObject();
				jsonobject.put("groupName", rs.getString("GROUP_NAME"));
				jsonArray.put(jsonobject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jsonArray;
	}

	public JSONArray getgeofenceCorrectionAndOtherAlerts(int systemId, int clientId, int userId, String zone, int isLtsp, int offset) {
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {

			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(GeneralVerticalStatements.GET_GEOFENCE_CORRECTION_DATA.replace("LOCATION_ZONE", "LOCATION_ZONE_" + zone));

			rs = pstmt.executeQuery();
			int count = 0;
			String imageSrc = "";
			List<String> tripCustIds = new ArrayList<String>();
			while (rs.next()) {
				tripCustIds.add(rs.getString("TRIP_CUST_ID"));
			}
			if (tripCustIds.isEmpty()) {
				return jsonArray;
			}
			JSONArray smartHubArray = getSmartHubBuffer(userId, clientId, systemId, zone, isLtsp, tripCustIds);
			JSONArray polyHubArray = getSmartHubPolygon(userId, clientId, systemId, zone, isLtsp, tripCustIds);
			double radius = 5.0;

			rs = pstmt.executeQuery();
			@SuppressWarnings("unused")
			boolean hasSmarthubWithinRadius = false;
			@SuppressWarnings("unused")
			boolean hasPolyhubWithinRadius = false;
			while (rs.next()) {
				hasSmarthubWithinRadius = checkIfSmartHubWithinGivenLatLngRadius(rs.getDouble("LATITUDE"), rs.getDouble("LONGITUDE"), radius, rs.getInt("TRIP_CUST_ID"), smartHubArray);
				hasPolyhubWithinRadius = checkIfSmartHubWithinGivenLatLngRadius(rs.getDouble("LATITUDE"), rs.getDouble("LONGITUDE"), radius, rs.getInt("TRIP_CUST_ID"), polyHubArray);
				jsonObject = new JSONObject();
				count++;
				jsonObject.put("slNo", count);
				jsonObject.put("tripId", rs.getString("TRIP_ID"));
				jsonObject.put("lrNumber", rs.getString("LR_NO"));
				jsonObject.put("tripCustomerId", rs.getString("TRIP_CUST_ID"));
				jsonObject.put("tripCustomerName", rs.getString("TRIP_CUST_NAME"));
				jsonObject.put("shipmentId", rs.getString("SHIPMENT_ID"));
				String durationHHMM = convertHourToHourMinutes(rs.getString("DURATION"));
				jsonObject.put("duration", durationHHMM);
				imageSrc = "<div class='location-icon'><a href='#'><img src='/ApplicationImages/VehicleImagesNew/globe.jpg'/></a></div> ";
				jsonObject.put("viewMapIndex", imageSrc);
				jsonObject.put("category", rs.getString("CATEGORY"));
				jsonObject.put("latitude", rs.getString("LATITUDE"));
				jsonObject.put("longitude", rs.getString("LONGITUDE"));
				jsonObject.put("assetNumber", rs.getString("ASSET_NUMBER"));
				jsonObject.put("routeName", rs.getString("ROUTE_NAME"));
				jsonObject.put("location", rs.getString("LOCATION"));
				jsonObject.put("stoppageBegin", "");
				jsonObject.put("id", rs.getInt("ID"));
				jsonObject.put("hubName", rs.getString("hubName"));
				jsonArray.put(jsonObject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jsonArray;
	}

	public String updateGeofenceCorrection(Integer tripId, Integer id, Integer userId, Integer systemId, Integer clientId, String remarks) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String message = "";
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(GeneralVerticalStatements.ACKNOWLEDGE_GEOFENCE_CORRECTION);
			pstmt.setString(1, remarks);
			pstmt.setInt(2, userId);
			pstmt.setInt(3, id);

			int inserted = pstmt.executeUpdate();
			if (inserted > 0) {
				message = "Successfully updated!";
			} else {
				message = "error";
			}

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}

		return message;
	}

	public JSONArray getTripsWhoseATAIsToBeUpdated(int systemId, int customerId, int offset) {
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(GeneralVerticalStatements.GET_TRIPS_WHOSE_ATA_IS_TO_BE_UPDATED);
			pstmt.setInt(1, offset);
			pstmt.setInt(2, offset);
			pstmt.setInt(3, systemId);
			pstmt.setInt(4, customerId);
			rs = pstmt.executeQuery();
			int count = 0;
			while (rs.next()) {
				jsonObject = new JSONObject();
				jsonObject.put("slNo", ++count);
				jsonObject.put("tripId", rs.getString("TRIP_ID"));
				jsonObject.put("orderId", rs.getString("ORDER_ID"));
				jsonObject.put("actualTripStartTime", mmddyyy.format(sdfDB.parse(rs.getString("ACTUAL_TRIP_START_TIME"))).replace(" ", "$"));
				jsonObject.put("actualTripEndTime", mmddyyy.format(sdfDB.parse(rs.getString("ACTUAL_TRIP_END_TIME"))).replace(" ", "$"));
				jsonObject.put("vehicleNumber", rs.getString("ASSET_NUMBER"));
				jsonObject.put("tripStatus", rs.getString("TRIP_STATUS"));
				jsonObject.put("button", "<button onclick=loadTripDetails(" + jsonObject + "); class='btn btn-warning'>Update ATA</button> ");

				jsonArray.put(jsonObject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jsonArray;
	}

	public String updateATAForClosedTrip(String tripId, String ata, int systemId, int customerId, int userId, int offset, 
			String zone, LogWriter logWriter) {
		logWriter.log("Updating ATA for closed trip : "+tripId, LogWriter.INFO);
		Connection con = null;
		ResultSet rs = null;
		PreparedStatement pstmt = null;
		PreparedStatement pstmt1 = null;
		PreparedStatement pstmt2 = null;
		String message = "";
		int updated1 = 0;
		int updated2 = 0;
		int updated3 = 0;
		int updated4 = 0;
		String lrNo = "";
		String endLoc = "";
		String successorId = "";
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt1 = con.prepareStatement(GeneralVerticalStatements.UPDATE_ATA_OF_DES_TRIP_DETAILS_FOR_CLOSED_TRIP);
			pstmt1.setInt(1, offset);
			pstmt1.setString(2, sdfDB.format(sdf.parse(ata)));
			pstmt1.setString(3, tripId);
			updated1 = pstmt1.executeUpdate();

			pstmt2 = con.prepareStatement(GeneralVerticalStatements.UPDATE_ATA_OF_TRIP_LEG_DETAILS_FOR_CLOSED_TRIP);
			pstmt2.setInt(1, offset);
			pstmt2.setString(2,sdfDB.format(sdf.parse(ata)));
			pstmt2.setString(3,tripId);
			pstmt2.setString(4,tripId);
			updated2 = pstmt2.executeUpdate();

			pstmt1 = con.prepareStatement(GeneralVerticalStatements.DELETE_REPORT_BUILDER_DETAILS);
			pstmt1.setString(1, tripId);
			updated4 = pstmt1.executeUpdate();
			
			pstmt1 = con.prepareStatement(GeneralVerticalStatements.UPDATE_TRACK_TRIP_DETAILS_ON_ATA_UPDATE_FOR_CLOSED_TRIP);
			pstmt1.setString(1, tripId);
			updated3 = pstmt1.executeUpdate();
			// ATA Updation in SLA Report
			try {
				cf.updateTripATADetailsInSLAReport(tripId, ata, logWriter, con);
				cf.updateLegDetailsInSLAReport(tripId, ata, logWriter, con);
			} catch (Exception e) {
				e.printStackTrace();
			}
			// SAP API CALL
			pstmt = con.prepareStatement(GeneralVerticalStatements.GET_ROUTE_ID_AND_VEHICLE_NUMBER_BY_TRIP_ID);
			pstmt.setString(1, tripId);
			pstmt.setInt(2, systemId);
			pstmt.setInt(3, customerId);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				lrNo = rs.getString("ORDER_ID");
				successorId = rs.getString("successorId");
				endLoc = rs.getString("NAME").contains(",") ? rs.getString("NAME").substring(0, rs.getString("NAME").indexOf(",")) : rs.getString("NAME");
			}
			if (systemId == 268 && !lrNo.contains("DHL")) {
				ArrayList<String> apiDetails = getAPIConfiguration(con, "Trip_Exec");
				try {
					logWriter.log("SAP API called for ATA update of closed Trip : "+lrNo, LogWriter.INFO);
					cf.SAPAPICall(lrNo, successorId, "ARRIV_DEST", endLoc, 0,logWriter,apiDetails.get(0), apiDetails.get(1), ata);
				} catch (final Exception e) {
					e.printStackTrace();
				}
			}
			if ((updated1 > 0 && updated2 > 0 && updated3 > 0) || (updated4 > 0)) {
				message = "ATA Updated";
			} else {
				message = "Error.";
			}
		} catch (Exception e) {
			e.printStackTrace();
			logWriter.log("Exception occurred while updating ATA for closed trip : "+tripId+". Exception is : "+e.getMessage(), LogWriter.ERROR);
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt1, null);
			DBConnection.releaseConnectionToDB(null, pstmt2, null);
		}
		return message;
	}

	private ArrayList<String> getAPIConfiguration(Connection con, String apiType) throws SQLException {
		ArrayList<String> APIConfig = new ArrayList<String>();
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		pstmt = con.prepareStatement(GeneralVerticalStatements.GET_API_DETAILS);
		pstmt.setString(1, apiType);
		rs = pstmt.executeQuery();
		if (rs.next()) {
			APIConfig.add(rs.getString("URL"));
			APIConfig.add(rs.getString("AUTH"));
		}
		return APIConfig;
	}
	
	public JSONArray getTripAuditLogDetails(String startDate, String endDate, int systemId, int customerId, int offset) {
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(GeneralVerticalStatements.GET_TRIP_LOG_dETAILS);
			pstmt.setInt(1, offset);
			pstmt.setInt(2, systemId);
			pstmt.setInt(3, customerId);
			pstmt.setInt(4, offset);
			pstmt.setString(5, startDate);
			pstmt.setInt(6, offset);
			pstmt.setString(7, endDate);
			rs = pstmt.executeQuery();
			int count = 0;
			while (rs.next()) {
				jsonObject = new JSONObject();
				jsonObject.put("slNo", ++count);
				jsonObject.put("tripId", rs.getString("TRIP_ID"));
				jsonObject.put("orderId", rs.getString("TRIP_NO"));
				jsonObject.put("datetime", mmddyyy.format(sdfDB.parse(rs.getString("INSERTED_DATETIME"))));
				jsonObject.put("action", rs.getString("ACTION"));
				jsonObject.put("pageName", rs.getString("PAGE_NAME"));
				jsonObject.put("userName", rs.getString("USER_NAME"));
				jsonObject.put("remarks", rs.getString("REMARKS"));
				jsonArray.put(jsonObject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jsonArray;
	}

	public JSONArray getDriverAssociatedHubNames(int systemId, int clientId, String zone) {
		JSONArray jArr = new JSONArray();
		JSONObject obj = null;
		
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try{
			final String GET_HUB_LIST_FROM_DRIVER_ASSOCIATION = "select SUBSTRING(NAME,1,CHARINDEX(',',NAME)-1) as hubName,HUBID " +
					" from AMS.dbo.LOCATION l" +
					" where SYSTEMID=? and CLIENTID=? and RADIUS < 15 and OPERATION_ID=33 order by NAME";
			if(con == null || con.isClosed()){
				con = DBConnection.getConnectionToDB("AMS");
			}
			pstmt = con.prepareStatement(GET_HUB_LIST_FROM_DRIVER_ASSOCIATION.replace("AMS.dbo.LOCATION", "AMS.dbo.LOCATION_ZONE_"+zone));
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, clientId);
			rs = pstmt.executeQuery();
			while(rs.next()){
				obj = new JSONObject();
				obj.put("hubId", rs.getInt("HUBID"));
				obj.put("hubName", rs.getString("hubName"));
				jArr.put(obj);
			}
		}catch(final Exception e){
			e.printStackTrace();
		}finally{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jArr;
	}

	public JSONArray getDriverNamesBasedOnHubSelected(String hubIdList, int clientId, String zone) {
		JSONArray jArr = new JSONArray();
		JSONObject obj = null;
		
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try{
			final String GET_DRIVER_BASED_ON_HUB_SELECTED = "select Driver_id,Fullname+' ('+EmployeeID+')' as driverName from " +
					" AMS.dbo.Driver_Master d" +
					" left outer join LOCATION_ZONE l on l.HUBID=d.RESPONSIBLE_LOCATION"+
					" where Client_id=? # order by Fullname";
			if(con == null || con.isClosed()){
				con = DBConnection.getConnectionToDB("AMS");
			}
			String statement = GET_DRIVER_BASED_ON_HUB_SELECTED.replace("LOCATION_ZONE", "LOCATION_ZONE_"+zone);
			statement = statement.replace("#", getHubQueryAppender(hubIdList, clientId, zone));
			pstmt = con.prepareStatement(statement);
			pstmt.setInt(1, clientId);
			//pstmt.setInt(2, hubId);
			rs = pstmt.executeQuery();
			while(rs.next()){
				obj = new JSONObject();
				obj.put("driverId", rs.getInt("Driver_id"));
				obj.put("driverName", rs.getString("driverName"));
				jArr.put(obj);
			}
		}catch(final Exception e){
			e.printStackTrace();
		}finally{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jArr;
	}

	private String getHubQueryAppender(String hubIdList, int clientId, String zone) {
		String appender = "";
		if(hubIdList.equals("")){
			appender = " and d.RESPONSIBLE_LOCATION in (select HUBID from LOCATION_ZONE_"+zone+" where OPERATION_ID=33 and CLIENTID="+clientId+")";
		}else{
			appender = " and d.RESPONSIBLE_LOCATION in ("+hubIdList+")";
		}
		return appender;
	}

	public JSONArray getDriverDetailsByDriverId(int clientId, int driverId, String startDate, String endDate, int offset) {
		JSONArray jArr = new JSONArray();
		JSONObject obj = null;
		
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try{
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(GeneralVerticalStatements.GET_DRIVER_DETAILS_BY_ID);
			pstmt.setInt(1, clientId);
			pstmt.setInt(2, driverId);
			pstmt.setInt(3, offset);
			pstmt.setString(4, startDate);
			pstmt.setInt(5, offset);
			pstmt.setString(6, endDate);
			pstmt.setInt(7, clientId);
			pstmt.setInt(8, driverId);
			rs = pstmt.executeQuery();
			if(rs.next()){
				obj = new JSONObject();
				obj.put("hubname", rs.getString("NAME"));
				obj.put("drivername", rs.getString("DriverName"));
				obj.put("employeeid", rs.getString("EmployeeId"));
				obj.put("trainingremarks", "");
				obj.put("hubId", rs.getInt("HUBID"));
				obj.put("periodScore", rs.getDouble("periodScore") == 0 ? "NA" : df1.format(rs.getDouble("periodScore")));
				jArr.put(obj);
			}
		}catch(final Exception e){
			e.printStackTrace();
		}finally{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jArr;
	}

	public String updateTrainingRemarks(int systemId, int clientId, int driverId, String driverName, 
			int hubId, String hubName, double score, String remarks, int userId) {
		String message = "Failure";
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try{
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(GeneralVerticalStatements.UPDATE_DRIVER_REMARKS);
			pstmt.setInt(1, driverId);
			pstmt.setString(2, driverName);
			pstmt.setInt(3, hubId);
			pstmt.setString(4, hubName);
			pstmt.setString(5, remarks);
			pstmt.setDouble(6, score);
			pstmt.setInt(7, userId);
			pstmt.setInt(8, systemId);
			pstmt.setInt(9, clientId);
			int update = pstmt.executeUpdate();
			if(update > 0){
				message = "Success";
			}
		}catch(final Exception e){
			e.printStackTrace();
		}finally{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return message;
	}

	public JSONArray fetchTrainingRemarksDetails(int clientId, int driverId) {
		JSONArray jArr = new JSONArray();
		JSONObject obj = null;
		
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try{
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(GeneralVerticalStatements.GET_TRAINING_REMARKS_DETAILS);
			pstmt.setInt(1, clientId);
			pstmt.setInt(2, driverId);
			rs = pstmt.executeQuery();
			while(rs.next()){
				obj = new JSONObject();
				obj.put("driverName", rs.getString("DRIVER_NAME"));
				obj.put("hubName", rs.getString("HUB_NAME"));
				obj.put("remarks", rs.getString("REMARKS"));
				obj.put("score", rs.getDouble("SCORE"));
				obj.put("user", rs.getString("userName"));
				jArr.put(obj);
			}
		}catch(final Exception e){
			e.printStackTrace();
		}finally{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jArr;
	}

	public JSONArray getVehicleWiseTemperatureReportBasedOnTimeRange(int systemId, int clientId, int offset, int userId, String startDate, String endDate, String regNo, String TimeRange) {

		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int noOfLoops = 0;

		try {
			long diffMinutes = getDateDiffInMinutes(startDate, endDate) + 1;
			noOfLoops = (int) (diffMinutes / Long.parseLong(TimeRange));
			int slncount = 0;
			String location = "";
			String gmt = "";
			for (int i = 0; i < noOfLoops; i++) {
				gmt = "";
				slncount++;
				String referTemp = "";
				String doorTemp = "";
				String middleTemp = "";
				double refer = 0;
				double door = 0;
				double middle = 0;
				int referCount = 0;
				int middleCount = 0;
				int doorCount = 0;
				Date startDt = sdfDB.parse(startDate);
				Calendar cal = Calendar.getInstance();
				cal.setTime(startDt);
				cal.add(Calendar.MINUTE, Integer.parseInt(TimeRange));
				endDate = sdfDB.format(cal.getTime());
				con = DBConnection.getConnectionToDB("AMS");
				pstmt = con.prepareStatement(GeneralVerticalStatements.GET_TEMPERATURE_REPORT);
				pstmt.setInt(1, offset);
				pstmt.setString(2, regNo);
				pstmt.setInt(3, offset);
				pstmt.setString(4, startDate);
				pstmt.setInt(5, offset);
				pstmt.setString(6, endDate);
				pstmt.setInt(7, offset);
				pstmt.setString(8, regNo);
				pstmt.setInt(9, offset);
				pstmt.setString(10, startDate);
				pstmt.setInt(11, offset);
				pstmt.setString(12, endDate);
				rs = pstmt.executeQuery();
				while (rs.next()) {
					location = rs.getString("LOCATION");
					gmt = sdfDB.format (rs.getTimestamp("GMT"));
					if ((rs.getString("IO_CATEGORY").equals("TEMPERATURE1")) && (!rs.getString("IO_VALUE").equals("NA"))) {
						refer = refer + Double.parseDouble(rs.getString("IO_VALUE"));
						referCount += 1;
					} else if ((rs.getString("IO_CATEGORY").equals("TEMPERATURE2")) && (!rs.getString("IO_VALUE").equals("NA"))) {
						middle = middle + Double.parseDouble(rs.getString("IO_VALUE"));
						middleCount += 1;
					} else if ((rs.getString("IO_CATEGORY").equals("TEMPERATURE3")) && (!rs.getString("IO_VALUE").equals("NA"))) {
						door = door + Double.parseDouble(rs.getString("IO_VALUE"));
						doorCount += 1;
					}
				}
                 if(referCount != 0){
                	 referTemp = df.format(refer / referCount);
                 }else{
                	 referTemp = "NA";
                 }
                 
                 if(middleCount != 0){
                	 middleTemp = df.format(middle / middleCount);
                 }else{
                	 middleTemp = "NA";
                 }
                 
                 if(doorCount != 0){
                	 doorTemp = df.format(door / doorCount);
                 }else{
                	 doorTemp = "NA";
                 }
                
				if(!gmt.equals("")){
				jsonObject = new JSONObject();
				jsonObject.put("slno", slncount);
				jsonObject.put("datetime", gmt);
				jsonObject.put("t1", referTemp);
				jsonObject.put("t2", middleTemp);
				jsonObject.put("t3", doorTemp);
				jsonObject.put("location", location);
				jsonArray.put(jsonObject);
				}
				startDate = endDate;
			}

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jsonArray;
	}

	public long getDateDiffInMinutes(String startDate, String endDate) {
		Date d1 = null;
		Date d2 = null;
		try {
			d1 = sdfDB.parse(startDate);
			d2 = sdfDB.parse(endDate);
		} catch (Exception e) {
			e.printStackTrace();
		}
		long diff = d2.getTime() - d1.getTime();
		long diffMinutes = diff / (60 * 1000);
		return diffMinutes;
	}

}
