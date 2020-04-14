/**
 * 
 */
package t4u.functions;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.text.DecimalFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.Properties;

import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.usermodel.Font;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import t4u.common.ApplicationListener;
import t4u.common.DBConnection;
import t4u.statements.SelfDriveCarsStatements;

/**
 * @author T4u525
 * 
 */
public class SelfDriveCarsFunctions {

	SimpleDateFormat sdfDB = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	SimpleDateFormat sdfDB2 = new SimpleDateFormat("yyyy-MM-dd");
	SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
	 SimpleDateFormat sdf3 = new SimpleDateFormat("MM-dd-yyyy");
	CommonFunctions cf = new CommonFunctions();
	private static DecimalFormat df2 = new DecimalFormat("#.##");
	Properties properties = ApplicationListener.prop;
	String dailyTravelledDistanceLimit = properties.getProperty("dailyTravelledDistanceLimit");

	/*
	 * 58 : Harsh Braking 105 : Harsh Acceleration 106 : Harsh Curving
	 */

	public JSONObject getDashboardCountsRow0(Integer systemId, Integer customerId, String startDate, String endDate, Integer offset, int userId) {

		Connection con = null;
		JSONObject obj = new JSONObject();
		try {
			startDate = sdfDB.format(sdf.parse(startDate));
			endDate = sdfDB.format(sdf.parse(endDate));
			con = DBConnection.getConnectionToDB("AMS");
			obj = getTopRowCounts(con, systemId, customerId, startDate, endDate, offset, obj, userId);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, null, null);
		}
		return obj;

	}

	public JSONObject getDashboardCountsRow1(Integer systemId, Integer customerId, String startDate, String endDate, Integer offset, int userId, String groupName) {

		Connection con = null;
		JSONObject obj = new JSONObject();
		try {
			startDate = sdfDB.format(sdf.parse(startDate));
			endDate = sdfDB.format(sdf.parse(endDate));
			con = DBConnection.getConnectionToDB("AMS");
			obj = getTripOPSCount(con, systemId, customerId, startDate, endDate, offset, obj, userId, groupName);
			obj = getTripStatusCount(con, systemId, customerId, startDate, endDate, offset, obj, userId, groupName);
			obj = getPickupRiskCount(con, systemId, customerId, startDate, endDate, offset, obj, userId, groupName);
			obj = getRestrictiveZonesCount(con, systemId, customerId, startDate, endDate, offset, obj, userId, groupName);
			obj = getNearFuelStationCount(con, systemId, customerId, startDate, endDate, offset, obj, userId, groupName);
			obj = getMileageCount(con, systemId, customerId, startDate, endDate, offset, obj, userId, groupName);
			obj = getRefuelCount(con, systemId, customerId, startDate, endDate, offset, obj, userId, groupName);
			obj = getPilferageCount(con, systemId, customerId, startDate, endDate, offset, obj, userId, groupName);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, null, null);
		}
		System.out.println("dashboard Object :: " + obj.toString());
		return obj;

	}

	public JSONObject getDashboardCountsRow2(Integer systemId, Integer customerId, String startDate, String endDate, Integer offset, int userId, String groupName) {

		Connection con = null;
		JSONObject obj = new JSONObject();
		try {
			startDate = sdfDB.format(sdf.parse(startDate));
			endDate = sdfDB.format(sdf.parse(endDate));
			con = DBConnection.getConnectionToDB("AMS");
			obj = getVehicleHealthBatteryCount(con, systemId, customerId, startDate, endDate, offset, obj, userId, groupName);
			obj = getVehicleHealthEngineCount(con, systemId, customerId, startDate, endDate, offset, obj, userId, groupName);
			obj = getHealthOPSCount(con, systemId, customerId, startDate, endDate, offset, obj, userId, groupName);
			obj = getAccidenCount(con, systemId, customerId, startDate, endDate, offset, obj, userId, groupName);
			obj = getServiceReminderCount(con, systemId, customerId, startDate, endDate, offset, obj, userId, groupName);
			obj = getMileageDropCount(con, systemId, customerId, startDate, endDate, offset, obj, userId, groupName);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, null, null);
		}
		System.out.println("dashboard Object :: " + obj.toString());
		return obj;

	}

	public JSONObject getDashboardCountsRow3(Integer systemId, Integer customerId, String startDate, String endDate, Integer offset, int userId, String groupName) {

		Connection con = null;
		JSONObject obj = new JSONObject();
		try {
			startDate = sdfDB.format(sdf.parse(startDate));
			endDate = sdfDB.format(sdf.parse(endDate));
			con = DBConnection.getConnectionToDB("AMS");
			obj = getHarshAlertCount(con, systemId, customerId, startDate, endDate, offset, obj, userId, groupName);
			obj = getDrivingPerformanceCount(con, systemId, customerId, startDate, endDate, offset, obj, userId, groupName);
			obj = getPerformanceOPSCount(con, systemId, customerId, startDate, endDate, offset, obj, userId, groupName);
			obj = getIdlingCount(con, systemId, customerId, startDate, endDate, offset, obj, userId, groupName);

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, null, null);
		}
		System.out.println("dashboard Object :: " + obj.toString());
		return obj;

	}

	public JSONArray getDataByType(Integer systemId, Integer customerId, String type, String startDate, String endDate, Integer offset, int userId, String zone, String groupName) {

		JSONArray array = null;
		JSONArray array1 = null;
		Connection con = null;
		try {
			con = DBConnection.getConnectionToDB("AMS");
			startDate = sdfDB.format(sdf.parse(startDate));
			endDate = sdfDB.format(sdf.parse(endDate));
			if (type.equalsIgnoreCase("ha") || type.equalsIgnoreCase("hb") || type.equalsIgnoreCase("hc")) {
				array = getHarshAlerts(con, systemId, customerId, type, startDate, endDate, offset, userId, groupName);
			} else if (type.equalsIgnoreCase("drivingPerformanceGood") || type.equalsIgnoreCase("drivingPerformanceAvg") || type.equalsIgnoreCase("drivingPerformanceBad")) {
				array = getDrivingPerformance(con, systemId, customerId, type, startDate, endDate, offset, userId, groupName);
			} else if (type.equalsIgnoreCase("onTimeDelivery") || type.equalsIgnoreCase("onTimePickup")) {
				array = getPerformanceOPS(con, systemId, customerId, type, startDate, endDate, offset, userId, groupName);
			} else if (type.equalsIgnoreCase("batteryLow") || type.equalsIgnoreCase("batteryHigh")) {
				array = getEngineHealthBattery(con, systemId, customerId, type, startDate, endDate, offset, userId, groupName);
			} else if (type.equalsIgnoreCase("engineHigh") || type.equalsIgnoreCase("engineLow") || type.equalsIgnoreCase("engineCritical")) {
				array = getVehicleHealthEngine(con, systemId, customerId, type, startDate, endDate, offset, userId, groupName);
			} else if (type.equalsIgnoreCase("healthOPSDTCErrors") || type.equalsIgnoreCase("healthOPSMil")) {
				array = getHealthOPS(con, systemId, customerId, type, startDate, endDate, offset, userId, groupName);
			} else if (type.equalsIgnoreCase("accident")) {
				array = getAccidentData(con, systemId, customerId, type, startDate, endDate, offset, userId, groupName);
			} else if (type.equalsIgnoreCase("serviceReminder")) {
				array = getServiceReminderData(con, systemId, customerId, type, startDate, endDate, offset, userId, groupName);
			} else if (type.equalsIgnoreCase("sourceOnTimeStart") || type.equalsIgnoreCase("sourceDelayedStart") || type.equalsIgnoreCase("destinationOnTimeReach")
					|| type.equalsIgnoreCase("destinationDelayedReach")) {
				array = getTripStatusOverview(con, systemId, customerId, type, startDate, endDate, offset, userId, groupName);
			} else if (type.equalsIgnoreCase("extraKMS") || type.equalsIgnoreCase("crossBorderCount")) {
				array = getTripOPS(con, systemId, customerId, type, startDate, endDate, offset, userId, groupName);
			} else if (type.equalsIgnoreCase("pickupRisk")) {
				array = getPickupRisk(con, systemId, customerId, type, startDate, endDate, offset, userId, groupName);
			} else if (type.equalsIgnoreCase("restrictiveZones")) {
				array = getRestrictiveZoneData(con, systemId, customerId, type, startDate, endDate, offset, userId, zone, groupName);
			} else if (type.equalsIgnoreCase("lowFuel")) {
				array = getLowFuelData(con, systemId, customerId, type, startDate, endDate, offset, userId, zone, groupName);
			} else if (type.equalsIgnoreCase("nearFuelStn")) {
				array = getNearFuelStationData(con, systemId, customerId, type, startDate, endDate, offset, userId, zone, groupName);
			} else if (type.equalsIgnoreCase("totalVehicles") || type.equalsIgnoreCase("onTripVehicles") || type.equalsIgnoreCase("onRoadVehicles") || type.equalsIgnoreCase("vehiclesAtHubLocations")
					|| type.equalsIgnoreCase("vehiclesAtServiceStation") || type.equalsIgnoreCase("totalKmsToday")) {
				array = getTopRowData(con, systemId, customerId, type, startDate, endDate, offset, userId, zone);
			} else if (type.equalsIgnoreCase("delayStartOrReach")) {
				ArrayList<String> type1 = new ArrayList<String>();
				type1.add(type);
				type1.add("sourceDelayedStart");

				array = getTripStatusOverview(con, systemId, customerId, type1.toString(), startDate, endDate, offset, userId, groupName);
				ArrayList<String> type2 = new ArrayList<String>();
				type2.add(type);
				type2.add("destinationDelayedReach");

				array1 = getTripStatusOverview(con, systemId, customerId, type2.toString(), startDate, endDate, offset, userId, groupName);
				int index = array.length();
				for (int i = 1; i < array1.length(); i++) {
					JSONObject test = array1.getJSONObject(i);
					test.put("0", index);
					array.put(test);
					index++;
				}
			} else if (type.equalsIgnoreCase("idle")) {
				array = getIdlingData(con, systemId, customerId, type, startDate, endDate, offset, userId, groupName);
			} else if (type.equalsIgnoreCase("mileage")) {
				array = getMileageData(con, systemId, customerId, type, startDate, endDate, offset, userId, groupName);
			} else if (type.equalsIgnoreCase("refuel")) {
				array = getRefuelData(con, systemId, customerId, type, startDate, endDate, offset, userId, groupName);
			} else if (type.equalsIgnoreCase("pilferage")) {
				array = getPilferageData(con, systemId, customerId, type, startDate, endDate, offset, userId, groupName);
			} else if (type.equalsIgnoreCase("mileageDrop")) {
				array = getMileageDropData(con, systemId, customerId, type, startDate, endDate, offset, userId, groupName);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, null, null);
		}
		return array;

	}

	public JSONObject getHarshAlertCount(Connection con, Integer systemId, Integer customerId, String startDate, String endDate, Integer offset, JSONObject obj, Integer userId, String groupName) {
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Integer haCount = 0;
		Integer hbCount = 0;
		Integer hcCount = 0;
		String query = "";

		try {
			query = getGroupNameQuery(SelfDriveCarsStatements.GET_HARSH_COUNTS, groupName);
			pstmt = con.prepareStatement(query);
			System.out.println(SelfDriveCarsStatements.GET_HARSH_COUNTS);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, customerId);
			pstmt.setInt(3, offset);
			pstmt.setString(4, startDate);
			pstmt.setInt(5, offset);
			pstmt.setString(6, endDate);
			pstmt.setInt(7, userId);

			pstmt.setInt(8, systemId);
			pstmt.setInt(9, customerId);
			pstmt.setInt(10, offset);
			pstmt.setString(11, startDate);
			pstmt.setInt(12, offset);
			pstmt.setString(13, endDate);
			pstmt.setInt(14, userId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				if (rs.getInt("TYPE_OF_ALERT") == 58) {
					hbCount = hbCount + rs.getInt("DISTINCTCOUNT");
				}
				if (rs.getInt("TYPE_OF_ALERT") == 105) {
					haCount = haCount + rs.getInt("DISTINCTCOUNT");
				}
				if (rs.getInt("TYPE_OF_ALERT") == 106) {
					hcCount = hcCount + rs.getInt("DISTINCTCOUNT");
				}
			}
			obj.put("HA", haCount);
			obj.put("HB", hbCount);
			obj.put("HC", hcCount);

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(null, pstmt, rs);
		}

		return obj;
	}

	public JSONArray getHarshAlerts(Connection con, Integer systemId, Integer customerId, String type, String startDate, String endDate, Integer offset, int userId, String groupName) throws Exception {

		JSONArray arr = new JSONArray();
		JSONObject obj = null;
		PreparedStatement pstmt = null;

		ResultSet rs = null;
		Integer typeOfAlert = 0;
		String query = "";

		try {
			if (type.equalsIgnoreCase("ha")) {
				typeOfAlert = 105;

			} else if (type.equalsIgnoreCase("hb")) {
				typeOfAlert = 58;

			} else {
				typeOfAlert = 106;
			}
			query = getGroupNameQuery(SelfDriveCarsStatements.GET_HARSH_DATA, groupName);
			pstmt = con.prepareStatement(query);
			pstmt.setInt(1, offset);
			pstmt.setInt(2, systemId);
			pstmt.setInt(3, customerId);

			pstmt.setInt(4, typeOfAlert);
			pstmt.setInt(5, offset);
			pstmt.setString(6, startDate);
			pstmt.setInt(7, offset);
			pstmt.setString(8, endDate);
			pstmt.setInt(9, userId);

			pstmt.setInt(10, systemId);
			pstmt.setInt(11, customerId);
			pstmt.setInt(12, typeOfAlert);
			pstmt.setInt(13, offset);
			pstmt.setString(14, startDate);
			pstmt.setInt(15, offset);
			pstmt.setString(16, endDate);
			pstmt.setInt(17, userId);
			rs = pstmt.executeQuery();
			obj = new JSONObject();
			ResultSetMetaData rsmd = rs.getMetaData();
			int columnCount = rsmd.getColumnCount();
			if (typeOfAlert != 58) {
				columnCount = columnCount - 1;
			}
			obj.put("0", "SL NO.");
			for (int i = 1; i <= columnCount; i++) {
				obj.put("" + i, rsmd.getColumnName(i));
			}
			arr.put(obj);
			int counter = 0;
			while (rs.next()) {
				obj = new JSONObject();
				obj.put("0", ++counter);
				obj.put("1", rs.getString("VEHICLE NUMBER"));
				obj.put("2", rs.getString("GROUP NAME"));
				obj.put("3", sdfDB.format(sdfDB.parse(rs.getString("ALERT TIME"))));
				obj.put("4", rs.getString("LOCATION"));
				obj.put("5", rs.getString("TRIP ID") != null ? rs.getString("TRIP ID") : "-");
				if (typeOfAlert == 58) {
					obj.put("6", rs.getString("DEACCELERATION"));
				}
				
				arr.put(obj);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(null, pstmt, rs);
		}
		return arr;
	}

	public JSONArray getDrivingPerformance(Connection con, Integer systemId, Integer customerId, String type, String startDate, String endDate, Integer offset, int userId, String groupName)
			throws Exception {

		JSONArray arr = new JSONArray();
		JSONObject obj = null;
		PreparedStatement pstmt = null, pstmt1 = null;
		ResultSet rs = null, rs1 = null;
		Double scoreFrom = null, scoreTo = null, calculation_factor = 1.00;
		String query = "";

		try {

			if (type.equalsIgnoreCase("drivingPerformanceBad")) {
				scoreFrom = 0.00;
				scoreTo = 7.00;
			} else if (type.equalsIgnoreCase("drivingPerformanceAvg")) {
				scoreFrom = 7.01;
				scoreTo = 9.00;
			} else {
				scoreFrom = 9.01;
				scoreTo = 10.00;
			}

			query = getGroupNameQuery(SelfDriveCarsStatements.GET_DRIVING_PERFORMANCE_DATA, groupName);
			pstmt = con.prepareStatement(query);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, customerId);
			pstmt.setInt(3, offset);
			pstmt.setString(4, startDate);
			pstmt.setInt(5, offset);
			pstmt.setString(6, endDate);
			pstmt.setDouble(7, scoreFrom);
			pstmt.setDouble(8, scoreTo);
			pstmt.setInt(9, userId);
			rs = pstmt.executeQuery();
			obj = new JSONObject();
			ResultSetMetaData rsmd = rs.getMetaData();
			int columnCount = rsmd.getColumnCount();
			obj.put("0", "SL NO.");
			for (int i = 1; i <= columnCount; i++) {
				obj.put("" + i, rsmd.getColumnName(i));
			}
			arr.put(obj);
			int counter = 0;

			// check if there is any display parameter mentioned, if anything
			// exists multiply it with the calculated score
			pstmt1 = con.prepareStatement(SelfDriveCarsStatements.GET_SCORE_CALCULATION_FACTOR);
			pstmt1.setString(1, "SCORE_CALCULATION_FACTOR");
			pstmt1.setInt(2, systemId);
			pstmt1.setInt(3, customerId);
			rs1 = pstmt1.executeQuery();
			if (rs1.next()) {
				calculation_factor = rs1.getDouble("VALUE");
			}
			while (rs.next()) {
				obj = new JSONObject();
				obj.put("0", ++counter);
				obj.put("1", rs.getString("VEHICLE NUMBER"));
				obj.put("2", rs.getString("GROUP NAME"));
				obj.put("3", rs.getString("TRIP NO"));
				obj.put("4", rs.getString("CUSTOMER"));
				obj.put("5", df2.format((calculation_factor * rs.getDouble("SCORE(%)"))));

				arr.put(obj);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(null, pstmt, rs);
		}
		return arr;
	}

	public JSONObject getDrivingPerformanceCount(Connection con, Integer systemId, Integer customerId, String startDate, String endDate, Integer offset, JSONObject obj, Integer userId,
			String groupName) {
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Integer drivingPerformanceCountGood = 0;
		Integer drivingPerformanceCountAvg = 0;
		Integer drivingPerformanceCountBad = 0;
		String query = "";

		try {
			query = getGroupNameQuery(SelfDriveCarsStatements.GET_DRIVING_PERFORMANCE_COUNT, groupName);
			pstmt = con.prepareStatement(query);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, customerId);
			pstmt.setInt(3, offset);
			pstmt.setString(4, startDate);
			pstmt.setInt(5, offset);
			pstmt.setString(6, endDate);
			pstmt.setInt(7, userId);
			rs = pstmt.executeQuery();

			while (rs.next()) {
				if (rs.getString("CATEGORY").equalsIgnoreCase("GOOD")) {
					drivingPerformanceCountGood = rs.getInt("RECORD_COUNT");
				} else if (rs.getString("CATEGORY").equalsIgnoreCase("AVG")) {
					drivingPerformanceCountAvg = rs.getInt("RECORD_COUNT");
				} else {
					drivingPerformanceCountBad = rs.getInt("RECORD_COUNT");
				}
			}

			obj.put("drivingPerformanceGood", drivingPerformanceCountGood);
			obj.put("drivingPerformanceAvg", drivingPerformanceCountAvg);
			obj.put("drivingPerformanceBad", drivingPerformanceCountBad);

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(null, pstmt, rs);
		}

		return obj;
	}

	public JSONObject getPerformanceOPSCount(Connection con, Integer systemId, Integer customerId, String startDate, String endDate, Integer offset, JSONObject obj, Integer userId, String groupName) {
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Integer deliveryCount = 0;
		Integer pickupCount = 0;
		String query = "";

		try {
			query = getGroupNameQuery(SelfDriveCarsStatements.GET_PERFORMANCE_OPS_COUNT_DELIVERY, groupName);
			pstmt = con.prepareStatement(query);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, customerId);
			pstmt.setInt(3, offset);
			pstmt.setString(4, startDate);
			pstmt.setInt(5, offset);
			pstmt.setString(6, endDate);
			pstmt.setInt(7, userId);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				deliveryCount = rs.getInt("OPS_COUNT");
			}
			DBConnection.releaseConnectionToDB(null, pstmt, rs);

			query = getGroupNameQuery(SelfDriveCarsStatements.GET_PERFORMANCE_OPS_COUNT_PICKUP, groupName);
			pstmt = con.prepareStatement(query);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, customerId);
			pstmt.setInt(3, offset);
			pstmt.setString(4, startDate);
			pstmt.setInt(5, offset);
			pstmt.setString(6, endDate);
			pstmt.setInt(7, userId);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				pickupCount = rs.getInt("OPS_COUNT");
			}

			obj.put("onTimeDelivery", deliveryCount);
			obj.put("onTimePickup", pickupCount);

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(null, pstmt, rs);
		}

		return obj;
	}

	public JSONArray getPerformanceOPS(Connection con, Integer systemId, Integer customerId, String type, String startDate, String endDate, Integer offset, int userId, String groupName)
			throws Exception {

		JSONArray arr = new JSONArray();
		JSONObject obj = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String val = "";
		String query = "";

		try {
			val = type.equals("onTimeDelivery") ? "ON_TIME_DELIVERY" : "ON_TIME_PICKUP";
			query = getGroupNameQuery(type.equals("onTimeDelivery") ? SelfDriveCarsStatements.GET_PERFORMANCE_OPS_DELIVERY : SelfDriveCarsStatements.GET_PERFORMANCE_OPS_PICKUP, groupName);
			pstmt = con.prepareStatement(query);
			pstmt.setInt(1, offset);
			pstmt.setInt(2, offset);
			pstmt.setString(3, val);
			pstmt.setInt(4, systemId);
			pstmt.setInt(5, customerId);
			pstmt.setInt(6, offset);
			pstmt.setString(7, startDate);
			pstmt.setInt(8, offset);
			pstmt.setString(9, endDate);
			pstmt.setInt(10, userId);
			rs = pstmt.executeQuery();
			obj = new JSONObject();
			ResultSetMetaData rsmd = rs.getMetaData();
			int columnCount = rsmd.getColumnCount();
			obj.put("0", "SL NO.");
			for (int i = 1; i <= columnCount; i++) {
				obj.put("" + i, rsmd.getColumnName(i));
			}
			arr.put(obj);
			int counter = 0;
			while (rs.next()) {
				obj = new JSONObject();
				obj.put("0", ++counter);
				obj.put("1", rs.getString("VEHICLE NUMBER"));
				obj.put("2", rs.getString("GROUP NAME"));
				obj.put("3", rs.getString("TRIP NO"));
				if (type.equalsIgnoreCase("onTimeDelivery")) {
					obj.put("4", sdfDB.format(sdfDB.parse(rs.getString("PLANNED TRIP START TIME"))));
					obj.put("5", rs.getString("DELIVERY TIME") != null ? sdfDB.format(sdfDB.parse(rs.getString("DELIVERY TIME"))) : "");

				} else {
					obj.put("4", sdfDB.format(sdfDB.parse(rs.getString("PLANNED TRIP END TIME"))));
					obj.put("5", rs.getString("PICKUP TIME") != null ? sdfDB.format(sdfDB.parse(rs.getString("PICKUP TIME"))) : "");

				}
				obj.put("6", rs.getString("DIFF(HH:MM)").contains("-") ? cf.convertMinutesToHHMMFormatNegative(rs.getInt("DIFF(HH:MM)")) : cf.convertMinutesToHHMMFormat(rs.getInt("DIFF(HH:MM)")));

				arr.put(obj);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(null, pstmt, rs);
		}
		return arr;
	}

	public JSONObject getVehicleHealthEngineCount(Connection con, Integer systemId, Integer customerId, String startDate, String endDate, Integer offset, JSONObject obj, Integer userId,
			String groupName) {
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Integer high = 0;
		Integer low = 0;
		Integer critical = 0;
		String query = "";
		try {
			System.out.println("ClientID / CustomerId  " + customerId);
			query = getGroupNameQuery(SelfDriveCarsStatements.GET_VEHICLE_HEALTH_ENGINE_COUNT, groupName);
			pstmt = con.prepareStatement(query);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, customerId);
			pstmt.setInt(3, offset);
			pstmt.setString(4, startDate);
			pstmt.setInt(5, offset);
			pstmt.setString(6, endDate);
			pstmt.setInt(7, userId);
			pstmt.setInt(8, systemId);
			pstmt.setInt(9, customerId);
			pstmt.setInt(10, offset);
			pstmt.setString(11, startDate);
			pstmt.setInt(12, offset);
			pstmt.setString(13, endDate);
			pstmt.setInt(14, userId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				if (rs.getString("TOGGLE").equalsIgnoreCase("0")) {
					low += rs.getInt("HUB_ID_COUNT");
				} else if (rs.getString("TOGGLE").equalsIgnoreCase("1")) {
					high += rs.getInt("HUB_ID_COUNT");
				}
			}
			query = getGroupNameQuery(SelfDriveCarsStatements.GET_VEHICLE_HEALTH_ENGINE_CRITICAL_COUNT, groupName);
			pstmt = con.prepareStatement(query);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, customerId);
			pstmt.setInt(3, offset);
			pstmt.setString(4, startDate);
			pstmt.setInt(5, offset);
			pstmt.setString(6, endDate);
			pstmt.setInt(7, userId);
			pstmt.setInt(8, systemId);
			pstmt.setInt(9, customerId);
			pstmt.setInt(10, offset);
			pstmt.setString(11, startDate);
			pstmt.setInt(12, offset);
			pstmt.setString(13, endDate);
			pstmt.setInt(14, userId);
			rs = pstmt.executeQuery();

			while (rs.next()) {
				critical += rs.getInt("Count");
			}

			obj.put("engineLow", low);
			obj.put("engineHigh", high);
			obj.put("engineCritical", critical);

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(null, pstmt, rs);
		}

		return obj;
	}

	public JSONObject getHealthOPSCount(Connection con, Integer systemId, Integer customerId, String startDate, String endDate, Integer offset, JSONObject obj, Integer userId, String groupName) {
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Integer dtc = 0;
		Integer mil = 0;
		String query = "";
		try {
			query = getGroupNameQuery(SelfDriveCarsStatements.GET_HEALTH_OPS_COUNT, groupName);
			pstmt = con.prepareStatement(query);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, customerId);
			pstmt.setInt(3, offset);
			pstmt.setString(4, startDate);
			pstmt.setInt(5, offset);
			pstmt.setString(6, endDate);
			pstmt.setInt(7, userId);
			pstmt.setInt(8, systemId);
			pstmt.setInt(9, customerId);
			pstmt.setInt(10, offset);
			pstmt.setString(11, startDate);
			pstmt.setInt(12, offset);
			pstmt.setString(13, endDate);
			pstmt.setInt(14, userId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				if (rs.getString("AlertType").equalsIgnoreCase("174")) {
					dtc += rs.getInt("Count");
				} else if (rs.getString("AlertType").equalsIgnoreCase("160")) {
					mil += rs.getInt("Count");
				}
			}

			obj.put("healthOPSDTCErrors", dtc);
			obj.put("healthOPSMil", mil);

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(null, pstmt, rs);
		}

		return obj;
	}

	public JSONObject getVehicleHealthBatteryCount(Connection con, Integer systemId, Integer customerId, String startDate, String endDate, Integer offset, JSONObject obj, Integer userId,
			String groupName) {
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		Integer vehicleHealthBatteryCountLow = 0;
		Integer vehicleHealthBatteryCountHigh = 0;
		String query = "";

		try {
			query = getGroupNameQuery(SelfDriveCarsStatements.GET_VEHICLE_HEALTH_BATTERY_COUNT, groupName);
			pstmt = con.prepareStatement(query);
			pstmt.setInt(1, 153);
			pstmt.setInt(2, systemId);
			pstmt.setInt(3, customerId);
			pstmt.setInt(4, offset);
			pstmt.setString(5, startDate);
			pstmt.setInt(6, offset);
			pstmt.setString(7, endDate);
			pstmt.setInt(8, userId);

			pstmt.setInt(9, 153);
			pstmt.setInt(10, systemId);
			pstmt.setInt(11, customerId);
			pstmt.setInt(12, offset);
			pstmt.setString(13, startDate);
			pstmt.setInt(14, offset);
			pstmt.setString(15, endDate);
			pstmt.setInt(16, userId);

			rs = pstmt.executeQuery();

			while (rs.next()) {
				System.out.println(" CATGEORY :: " + rs.getString("CATEGORY"));
				if (rs.getInt("CATEGORY") == 1) {
					vehicleHealthBatteryCountHigh = rs.getInt("RECORD_COUNT");
				} else {
					vehicleHealthBatteryCountLow = rs.getInt("RECORD_COUNT");
				}
			}

			obj.put("batteryCountLow", vehicleHealthBatteryCountLow);
			obj.put("batteryCountHigh", vehicleHealthBatteryCountHigh);

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(null, pstmt, rs);
		}

		return obj;
	}

	public JSONArray getEngineHealthBattery(Connection con, Integer systemId, Integer customerId, String type, String startDate, String endDate, Integer offset, int userId, String groupName)
			throws Exception {

		JSONArray arr = new JSONArray();
		JSONObject obj = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";

		try {
			query = getGroupNameQuery(SelfDriveCarsStatements.GET_VEHICLE_HEALTH_BATTERY, groupName);
			pstmt = con.prepareStatement(query);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, customerId);
			pstmt.setInt(3, offset);
			pstmt.setString(4, startDate);
			pstmt.setInt(5, offset);
			pstmt.setString(6, endDate);
			pstmt.setInt(7, 153);
			pstmt.setInt(8, type.equalsIgnoreCase("batteryLow") ? 0 : 1);
			pstmt.setInt(9, userId);

			pstmt.setInt(10, systemId);
			pstmt.setInt(11, customerId);
			pstmt.setInt(12, offset);
			pstmt.setString(13, startDate);
			pstmt.setInt(14, offset);
			pstmt.setString(15, endDate);
			pstmt.setInt(16, 153);
			pstmt.setInt(17, type.equalsIgnoreCase("batteryLow") ? 0 : 1);
			pstmt.setInt(18, userId);
			rs = pstmt.executeQuery();
			obj = new JSONObject();
			ResultSetMetaData rsmd = rs.getMetaData();
			int columnCount = rsmd.getColumnCount();
			obj.put("0", "SL NO.");
			for (int i = 1; i <= columnCount; i++) {
				obj.put("" + i, rsmd.getColumnName(i));
			}
			arr.put(obj);
			int counter = 0;
			while (rs.next()) {
				obj = new JSONObject();
				obj.put("0", ++counter);
				obj.put("1", rs.getString("VEHICLE NUMBER"));
				obj.put("2", rs.getString("GROUP NAME"));
				obj.put("3", df2.format(rs.getDouble("VOLTAGE")));
				obj.put("4", rs.getString("START TIME").contains("1900") ? "" : sdfDB.format(sdfDB.parse(rs.getString("START TIME"))));
				obj.put("5", rs.getString("END TIME").contains("1900") ? "" : sdfDB.format(sdfDB.parse(rs.getString("END TIME"))));

				arr.put(obj);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(null, pstmt, rs);
		}
		return arr;
	}

	public JSONArray getVehicleHealthEngine(Connection con, Integer systemId, Integer customerId, String type, String startDate, String endDate, Integer offset, Integer userId, String groupName)
			throws Exception {

		JSONArray arr = new JSONArray();
		JSONObject obj = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Integer hubId = 0;
		String query = "";

		try {

			if (type.equalsIgnoreCase("engineCritical")) {
				query = getGroupNameQuery(SelfDriveCarsStatements.GET_VEHICLE_HEALTH_ENGINE_CRITICAL, groupName);
				pstmt = con.prepareStatement(query);
				pstmt.setInt(1, offset);
				pstmt.setInt(2, systemId);
				pstmt.setInt(3, customerId);
				pstmt.setInt(4, offset);
				pstmt.setString(5, startDate);
				pstmt.setInt(6, offset);
				pstmt.setString(7, endDate);
				pstmt.setInt(8, userId);
				pstmt.setInt(9, offset);
				pstmt.setInt(10, systemId);
				pstmt.setInt(11, customerId);
				pstmt.setInt(12, offset);
				pstmt.setString(13, startDate);
				pstmt.setInt(14, offset);
				pstmt.setString(15, endDate);
				pstmt.setInt(16, userId);

				rs = pstmt.executeQuery();
				obj = new JSONObject();
				ResultSetMetaData rsmd = rs.getMetaData();
				int columnCount = rsmd.getColumnCount();
				obj.put("0", "SL NO.");
				for (int i = 1; i <= columnCount; i++) {
					obj.put("" + i, rsmd.getColumnName(i));
				}
				arr.put(obj);
				int counter = 0;
				while (rs.next()) {
					obj = new JSONObject();
					obj.put("0", ++counter);
					obj.put("1", rs.getString("VEHICLE NO"));
					obj.put("2", rs.getString("GROUP NAME"));
					obj.put("3", rs.getString("ALERT TYPE"));
					obj.put("4", sdfDB.format(sdfDB.parse(rs.getString("LOCALTIME"))));
					obj.put("5", rs.getString("REMARKS"));
					arr.put(obj);
				}
			} else {

				if (type.equalsIgnoreCase("engineHigh")) {
					hubId = 1;
				} else if (type.equalsIgnoreCase("engineLow")) {
					hubId = 0;
				}
				System.out.println(startDate);
				System.out.println(endDate);
				System.out.println(offset);
				query = getGroupNameQuery(SelfDriveCarsStatements.GET_VEHICLE_HEALTH_ENGINE, groupName);
				pstmt = con.prepareStatement(query);
				pstmt.setInt(1, offset);
				pstmt.setInt(2, systemId);
				pstmt.setInt(3, customerId);
				pstmt.setInt(4, offset);
				pstmt.setString(5, startDate);
				pstmt.setInt(6, offset);
				pstmt.setString(7, endDate);
				pstmt.setInt(8, hubId);
				pstmt.setInt(9, userId);
				// pstmt.setInt(10, offset);
				pstmt.setInt(10, systemId);
				pstmt.setInt(11, customerId);
				pstmt.setInt(12, offset);
				pstmt.setString(13, startDate);
				pstmt.setInt(14, offset);
				pstmt.setString(15, endDate);
				pstmt.setInt(16, hubId);
				pstmt.setInt(17, userId);
				rs = pstmt.executeQuery();
				obj = new JSONObject();
				ResultSetMetaData rsmd = rs.getMetaData();
				int columnCount = rsmd.getColumnCount();
				obj.put("0", "SL NO.");
				for (int i = 1; i <= columnCount; i++) {
					obj.put("" + i, rsmd.getColumnName(i));
				}
				arr.put(obj);
				int counter = 0;
				while (rs.next()) {
					obj = new JSONObject();
					obj.put("0", ++counter);
					obj.put("1", rs.getString("VEHICLE NO"));
					obj.put("2", rs.getString("GROUP NAME"));
					obj.put("3", rs.getString("ALERT TYPE"));
					obj.put("4", sdfDB.format(sdfDB.parse(rs.getString("LOCALTIME"))));
					obj.put("5", rs.getString("REMARKS"));
					arr.put(obj);
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(null, pstmt, rs);
		}
		return arr;
	}

	public JSONArray getHealthOPS(Connection con, Integer systemId, Integer customerId, String type, String startDate, String endDate, Integer offset, int userId, String groupName) throws Exception {

		JSONArray arr = new JSONArray();
		JSONObject obj = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Integer alertId = 0;
		String query = "";

		if (type.equalsIgnoreCase("healthOPSDTCErrors")) {
			alertId = 174;
		} else {
			alertId = 160;
		}
		try {
			query = getGroupNameQuery(SelfDriveCarsStatements.GET_HEALTH_OPS, groupName);
			pstmt = con.prepareStatement(query);
			pstmt.setInt(1, offset);
			pstmt.setInt(2, systemId);
			pstmt.setInt(3, customerId);
			pstmt.setInt(4, offset);
			pstmt.setString(5, startDate);
			pstmt.setInt(6, offset);
			pstmt.setString(7, endDate);
			pstmt.setInt(8, alertId);
			pstmt.setInt(9, userId);
			pstmt.setInt(10, systemId);
			pstmt.setInt(11, customerId);
			pstmt.setInt(12, offset);
			pstmt.setString(13, startDate);
			pstmt.setInt(14, offset);
			pstmt.setString(15, endDate);
			pstmt.setInt(16, alertId);
			pstmt.setInt(17, userId);

			rs = pstmt.executeQuery();
			obj = new JSONObject();
			ResultSetMetaData rsmd = rs.getMetaData();
			int columnCount = rsmd.getColumnCount();
			obj.put("0", "SL NO.");
			for (int i = 1; i <= columnCount; i++) {
				obj.put("" + i, rsmd.getColumnName(i));
			}
			arr.put(obj);
			int counter = 0;
			while (rs.next()) {
				String alertLink = "<a href=\"https://www.obd-codes.com/" + rs.getString("REMARKS") + "\">" + rs.getString("REMARKS") + "</a>";
				obj = new JSONObject();
				obj.put("0", ++counter);
				obj.put("1", rs.getString("VEHICLE NO"));
				obj.put("2", rs.getString("GROUP NAME"));
				obj.put("3", rs.getString("ALERT TYPE"));
				obj.put("4", sdfDB.format(sdfDB.parse(rs.getString("LOCALTIME"))));
				obj.put("5", alertLink);
				arr.put(obj);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(null, pstmt, rs);
		}
		return arr;
	}

	public JSONObject getAccidenCount(Connection con, Integer systemId, Integer customerId, String startDate, String endDate, Integer offset, JSONObject obj, Integer userId, String groupName) {
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Integer accidentCount = 0;
		String query = "";
		try {
			query = getGroupNameQuery(SelfDriveCarsStatements.GET_ACCIDENT_COUNT, groupName);
			pstmt = con.prepareStatement(query);
			pstmt.setInt(1, 184);
			pstmt.setInt(2, systemId);
			pstmt.setInt(3, customerId);
			pstmt.setInt(4, offset);
			pstmt.setString(5, startDate);
			pstmt.setInt(6, offset);
			pstmt.setString(7, endDate);
			pstmt.setInt(8, userId);

			pstmt.setInt(9, 184);
			pstmt.setInt(10, systemId);
			pstmt.setInt(11, customerId);
			pstmt.setInt(12, offset);
			pstmt.setString(13, startDate);
			pstmt.setInt(14, offset);
			pstmt.setString(15, endDate);
			pstmt.setInt(16, userId);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				accidentCount = rs.getInt("ACCIDENT_COUNT");
			}
			obj.put("accidentCount", accidentCount);

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(null, pstmt, rs);
		}

		return obj;
	}

	public JSONArray getAccidentData(Connection con, Integer systemId, Integer customerId, String type, String startDate, String endDate, Integer offset, int userId, String groupName)
			throws Exception {

		JSONArray arr = new JSONArray();
		JSONObject obj = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";

		try {
			query = getGroupNameQuery(SelfDriveCarsStatements.GET_ACCIDENT_DATA, groupName);
			pstmt = con.prepareStatement(query);
			pstmt.setInt(1, offset);
			pstmt.setInt(2, systemId);
			pstmt.setInt(3, customerId);
			pstmt.setInt(4, offset);
			pstmt.setString(5, startDate);
			pstmt.setInt(6, offset);
			pstmt.setString(7, endDate);
			pstmt.setInt(8, 184);
			pstmt.setInt(9, userId);

			pstmt.setInt(10, systemId);
			pstmt.setInt(11, customerId);
			pstmt.setInt(12, offset);
			pstmt.setString(13, startDate);
			pstmt.setInt(14, offset);
			pstmt.setString(15, endDate);
			pstmt.setInt(16, 184);
			pstmt.setInt(17, userId);
			rs = pstmt.executeQuery();
			obj = new JSONObject();
			ResultSetMetaData rsmd = rs.getMetaData();
			int columnCount = rsmd.getColumnCount();
			obj.put("0", "SL NO.");
			for (int i = 1; i <= columnCount; i++) {
				obj.put("" + i, rsmd.getColumnName(i));
			}
			arr.put(obj);
			int counter = 0;
			while (rs.next()) {
				obj = new JSONObject();
				obj.put("0", ++counter);
				obj.put("1", rs.getString("VEHICLE NO"));
				obj.put("2", rs.getString("GROUP NAME"));
				obj.put("3", rs.getString("ACCIDENT TIME").contains("1900") ? "" : sdfDB.format(sdfDB.parse(rs.getString("ACCIDENT TIME"))));
				obj.put("4", rs.getString("LOCATION"));
				obj.put("5", rs.getString("SPEED"));
				arr.put(obj);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(null, pstmt, rs);
		}
		return arr;
	}

	public JSONObject getServiceReminderCount(Connection con, Integer systemId, Integer customerId, String startDate, String endDate, Integer offset, JSONObject obj, int userId, String groupName) {
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Integer serviceReminderCount = 0;
		String query = "";
		try {
			query = getGroupNameQuery(SelfDriveCarsStatements.PREVENTIVE_EXPIRED_FROM_PREVENTIVE_EVENTS, groupName);
			pstmt = con.prepareStatement(query);

			pstmt.setInt(1, systemId);
			pstmt.setInt(2, customerId);
			pstmt.setInt(3, userId);
			// pstmt.setInt(4, offset);
			// pstmt.setString(5, startDate);
			// pstmt.setInt(6, offset);
			// pstmt.setString(7, endDate);
			pstmt.setInt(4, systemId);
			pstmt.setInt(5, customerId);
			pstmt.setInt(6, userId);
			// pstmt.setInt(11, offset);
			// pstmt.setString(12, startDate);
			// pstmt.setInt(13, offset);
			// pstmt.setString(14, endDate);

			rs = pstmt.executeQuery();
			if (rs.next()) {
				serviceReminderCount = serviceReminderCount + rs.getInt("PREVENTIVE_EXPIRED");
			}
			DBConnection.releaseConnectionToDB(null, pstmt, rs);
			pstmt = con.prepareStatement(SelfDriveCarsStatements.GET_STATUTORY_ALERT_COUNT_NEW);
			pstmt.setInt(1, offset);
			pstmt.setString(2, startDate);
			pstmt.setInt(3, offset);
			pstmt.setString(4, endDate);
			pstmt.setInt(5, customerId);
			pstmt.setInt(6, systemId);
			pstmt.setInt(7, offset);
			pstmt.setString(8, startDate);
			pstmt.setInt(9, offset);
			pstmt.setString(10, endDate);
			pstmt.setInt(11, customerId);
			pstmt.setInt(12, systemId);
			pstmt.setInt(13, systemId);
			pstmt.setInt(14, userId);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				serviceReminderCount = serviceReminderCount + rs.getInt("INSURANCE_EXP");
				serviceReminderCount = serviceReminderCount + rs.getInt("GOODS_TOKEN_TAX_EXP");
				serviceReminderCount = serviceReminderCount + rs.getInt("FCI_EXP");
				serviceReminderCount = serviceReminderCount + rs.getInt("EMISSION_EXP");
				serviceReminderCount = serviceReminderCount + rs.getInt("PERMIT_EXP");
				serviceReminderCount = serviceReminderCount + rs.getInt("REGISTRATION_EXP");
				serviceReminderCount = serviceReminderCount + rs.getInt("DRIVER_LICENSE_EXP");
			}
			obj.put("serviceReminderCount", serviceReminderCount);

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(null, pstmt, rs);
		}

		return obj;
	}

	public JSONArray getServiceReminderData(Connection con, Integer systemId, Integer customerId, String type, String startDate, String endDate, Integer offset, Integer userId, String groupName)
			throws Exception {

		JSONArray arr = new JSONArray();
		JSONObject obj = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";

		try {
			int counter = 0;
			query = getGroupNameQuery(SelfDriveCarsStatements.GET_ALREADY_EXPIRED_DETAILS_REPORT, groupName);
			pstmt = con.prepareStatement(query);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, customerId);
			pstmt.setInt(3, 1); // referred from
								// PreventiveMaintenanceFunctions.getPreventiveMaintenanceReport
			pstmt.setInt(4, userId);
			rs = pstmt.executeQuery();
			obj = new JSONObject();
			ResultSetMetaData rsmd = rs.getMetaData();
			int columnCount = rsmd.getColumnCount();
			obj.put("0", "SL NO.");
			for (int i = 1; i <= columnCount; i++) {
				obj.put("" + i, rsmd.getColumnName(i));
			}
			arr.put(obj);
			while (rs.next()) {
				obj = new JSONObject();
				obj.put("0", ++counter);
				obj.put("1", rs.getString("VEHICLE NO"));
				obj.put("2", rs.getString("GROUP NAME"));
				obj.put("3", rs.getString("EVENT DATE").contains("1900") ? "" : sdfDB.format(sdfDB.parse(rs.getString("EVENT DATE"))));
				obj.put("4", rs.getString("ALERT NAME"));
				arr.put(obj);
			}

			DBConnection.releaseConnectionToDB(null, pstmt, rs);

			pstmt = con.prepareStatement(SelfDriveCarsStatements.GET_SERVICE_REMINDERS);
			pstmt.setInt(1, offset);
			pstmt.setInt(2, offset);
			pstmt.setString(3, startDate);
			pstmt.setInt(4, offset);
			pstmt.setString(5, endDate);
			pstmt.setInt(6, customerId);
			pstmt.setInt(7, systemId);

			pstmt.setInt(8, offset);
			pstmt.setString(9, startDate);
			pstmt.setInt(10, offset);
			pstmt.setString(11, endDate);
			pstmt.setInt(12, customerId);
			pstmt.setInt(13, systemId);
			pstmt.setInt(14, systemId);
			pstmt.setInt(15, userId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				obj = new JSONObject();
				obj.put("0", ++counter);
				obj.put("1", rs.getString("VEHICLE NO"));
				obj.put("2", rs.getString("EVENT DATE").contains("1900") ? "" : sdfDB.format(sdfDB.parse(rs.getString("EVENT DATE"))));
				obj.put("3", rs.getString("ALERT NAME"));
				arr.put(obj);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(null, pstmt, rs);
		}
		return arr;
	}

	public JSONObject getTripStatusCount(Connection con, Integer systemId, Integer customerId, String startDate, String endDate, Integer offset, JSONObject obj, Integer userId, String groupName) {
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Integer sourceOnTimeStart = 0;
		Integer sourceDelayedStart = 0;
		Integer destinationOnTimeReach = 0;
		Integer destinationDelayedReach = 0;
		String query = "";

		try {
			query = getGroupNameQuery(SelfDriveCarsStatements.GET_TRIP_STATUS_COUNT_SOURCE, groupName);
			pstmt = con.prepareStatement(query);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, customerId);
			pstmt.setInt(3, offset);
			pstmt.setString(4, startDate);
			pstmt.setInt(5, offset);
			pstmt.setString(6, endDate);
			pstmt.setInt(7, userId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				if (rs.getString("OPS_TYPE_DELIVERY").equals("ON_TIME_DELIVERY")) {
					sourceOnTimeStart = rs.getInt("SOURCE_COUNT");
				} else {
					sourceDelayedStart = rs.getInt("SOURCE_COUNT");
				}
			}
			DBConnection.releaseConnectionToDB(null, pstmt, rs);

			query = getGroupNameQuery(SelfDriveCarsStatements.GET_TRIP_STATUS_COUNT_DESTINATION, groupName);
			pstmt = con.prepareStatement(query);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, customerId);
			pstmt.setInt(3, offset);
			pstmt.setString(4, startDate);
			pstmt.setInt(5, offset);
			pstmt.setString(6, endDate);
			pstmt.setInt(7, userId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				if (rs.getString("OPS_TYPE_PICKUP").equals("ON_TIME_PICKUP")) {
					destinationOnTimeReach = rs.getInt("DESTINATION_COUNT");
				} else {
					destinationDelayedReach = rs.getInt("DESTINATION_COUNT");
				}
			}

			obj.put("sourceOnTimeStart", sourceOnTimeStart);
			obj.put("sourceDelayedStart", sourceDelayedStart);

			obj.put("destinationOnTimeReach", destinationOnTimeReach);
			obj.put("destinationDelayedReach", destinationDelayedReach);

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(null, pstmt, rs);
		}

		return obj;
	}

	public JSONArray getTripStatusOverview(Connection con, Integer systemId, Integer customerId, String type, String startDate, String endDate, Integer offset, int userId, String groupName)
			throws Exception {

		JSONArray arr = new JSONArray();
		JSONObject obj = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String val = "";
		String query = "";

		try {
			if (type.equals("sourceOnTimeStart")) {
				val = "ON_TIME_DELIVERY";
			} else if (type.equals("sourceDelayedStart")) {
				val = "DELAYED_DELIVERY";
			} else if (type.equals("destinationOnTimeReach")) {
				val = "ON_TIME_PICKUP";
			} else if (type.equals("destinationDelayedReach")) {
				val = "DELAYED_PICKUP";
			} else if (type.equals("[delayStartOrReach, sourceDelayedStart]")) {
				type = "delaySrc";
				val = "DELAYED_DELIVERY";
			} else if (type.equals("[delayStartOrReach, destinationDelayedReach]")) {
				type = "delayDesc";
				val = "DELAYED_PICKUP";
			}

			query = getGroupNameQuery(type.contains("source") ? SelfDriveCarsStatements.GET_PERFORMANCE_OPS_DELIVERY
					: type.contains("destination") ? SelfDriveCarsStatements.GET_PERFORMANCE_OPS_PICKUP : type.contains("delaySrc") ? SelfDriveCarsStatements.PERFORMANCE_OPS_DELAY_START
							: SelfDriveCarsStatements.PERFORMANCE_OPS_DELAY_REACH, groupName);

			pstmt = con.prepareStatement(query);
			pstmt.setInt(1, offset);
			pstmt.setInt(2, offset);
			pstmt.setInt(3, offset);
			pstmt.setString(4, val);
			pstmt.setInt(5, systemId);
			pstmt.setInt(6, customerId);
			pstmt.setInt(7, offset);
			pstmt.setString(8, startDate);
			pstmt.setInt(9, offset);
			pstmt.setString(10, endDate);
			pstmt.setInt(11, userId);
			rs = pstmt.executeQuery();
			obj = new JSONObject();
			ResultSetMetaData rsmd = rs.getMetaData();
			int columnCount = rsmd.getColumnCount();

			obj.put("0", "SL NO.");
			for (int i = 1; i <= columnCount; i++) {
				obj.put("" + i, rsmd.getColumnName(i));
			}
			arr.put(obj);

			int counter = 0;
			while (rs.next()) {
				obj = new JSONObject();
				obj.put("0", ++counter);
				obj.put("1", rs.getString("VEHICLE NUMBER"));
				obj.put("2", rs.getString("GROUP NAME"));
				obj.put("3", rs.getString("TRIP NO"));
				if (type.contains("source")) {
					obj.put("4", sdfDB.format(sdfDB.parse(rs.getString("PLANNED TRIP START TIME"))));
					obj.put("5", sdfDB.format(sdfDB.parse(rs.getString("QIK OTP TIME"))));
					obj.put("6", rs.getString("GEOFENCE TIME") != null ? sdfDB.format(sdfDB.parse(rs.getString("GEOFENCE TIME"))) : "");
				} else if ((type.contains("delaySrc")) || (type.contains("delayDesc"))) {
					obj.put("4", sdfDB.format(sdfDB.parse(rs.getString("PLANNED TIME"))));
					obj.put("5", sdfDB.format(sdfDB.parse(rs.getString("ACTUAL TIME"))));
					obj.put("6", rs.getString("DELIVERY/PICKUP TIME") != null ? sdfDB.format(sdfDB.parse(rs.getString("DELIVERY/PICKUP TIME"))) : "");
					obj.put("8", rs.getString("DELAY START/REACH"));
				} else {
					obj.put("4", sdfDB.format(sdfDB.parse(rs.getString("PLANNED TRIP END TIME"))));
					obj.put("5", sdfDB.format(sdfDB.parse(rs.getString("QIK OTP TIME"))));
					obj.put("6", rs.getString("GEOFENCE TIME") != null ? sdfDB.format(sdfDB.parse(rs.getString("GEOFENCE TIME"))) : "");
				}

				obj.put("7", rs.getString("DIFF(HH:MM)").contains("-") ? cf.convertMinutesToHHMMFormatNegative(rs.getInt("DIFF(HH:MM)")) : cf.convertMinutesToHHMMFormat(rs.getInt("DIFF(HH:MM)")));

				arr.put(obj);

			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(null, pstmt, rs);
		}
		return arr;
	}

	public JSONObject getTripOPSCount(Connection con, Integer systemId, Integer customerId, String startDate, String endDate, Integer offset, JSONObject obj, Integer userId, String groupName) {
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Integer crossBorderCount = 0, lowFuelCount = 0;
		String query = "";

		try {
			query = getGroupNameQuery(SelfDriveCarsStatements.GET_KMS_INFORMATION_COUNT, groupName);
			pstmt = con.prepareStatement(query);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, customerId);
			pstmt.setInt(3, offset);
			pstmt.setString(4, startDate);
			pstmt.setInt(5, offset);
			pstmt.setString(6, endDate);
			pstmt.setInt(7, userId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				obj.put("extraKMS", rs.getInt("EXTRA_KMS"));
			}

			query = getGroupNameQuery(SelfDriveCarsStatements.GET_CROSS_BORDER_COUNT, groupName);
			pstmt = con.prepareStatement(query);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, customerId);
			pstmt.setInt(3, offset);
			pstmt.setString(4, startDate);
			pstmt.setInt(5, offset);
			pstmt.setString(6, endDate);
			pstmt.setInt(7, userId);
			pstmt.setInt(8, systemId);
			pstmt.setInt(9, customerId);
			pstmt.setInt(10, offset);
			pstmt.setString(11, startDate);
			pstmt.setInt(12, offset);
			pstmt.setString(13, endDate);
			pstmt.setInt(14, userId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				crossBorderCount += rs.getInt("COUNT");
			}

			obj.put("crossBorderCount", crossBorderCount);

			query = getGroupNameQuery(SelfDriveCarsStatements.GET_LOW_FUEL_COUNT, groupName);
			pstmt = con.prepareStatement(query);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, customerId);
			pstmt.setInt(3, offset);
			pstmt.setString(4, startDate);
			pstmt.setInt(5, offset);
			pstmt.setString(6, endDate);
			pstmt.setInt(7, userId);
			pstmt.setInt(8, systemId);
			pstmt.setInt(9, customerId);
			pstmt.setInt(10, offset);
			pstmt.setString(11, startDate);
			pstmt.setInt(12, offset);
			pstmt.setString(13, endDate);
			pstmt.setInt(14, userId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				lowFuelCount = rs.getInt("COUNT");
			}

			obj.put("lowFuelCount", lowFuelCount);

			DBConnection.releaseConnectionToDB(null, pstmt, rs);

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(null, pstmt, rs);
		}

		return obj;
	}

	public JSONArray getTripOPS(Connection con, Integer systemId, Integer customerId, String type, String startDate, String endDate, Integer offset, int userId, String groupName) throws Exception {

		JSONArray arr = new JSONArray();
		JSONObject obj = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";

		try {
			if (type.equals("extraKMS")) {
				query = getGroupNameQuery(SelfDriveCarsStatements.GET_KMS_INFORMATION_DATA, groupName);
				pstmt = con.prepareStatement(query);
				pstmt.setInt(1, systemId);
				pstmt.setInt(2, customerId);
				pstmt.setInt(3, offset);
				pstmt.setString(4, startDate);
				pstmt.setInt(5, offset);
				pstmt.setString(6, endDate);
				pstmt.setInt(7, userId);
				rs = pstmt.executeQuery();

				obj = new JSONObject();
				ResultSetMetaData rsmd = rs.getMetaData();
				int columnCount = rsmd.getColumnCount();
				obj.put("0", "SL NO.");
				for (int i = 1; i <= columnCount; i++) {
					obj.put("" + i, rsmd.getColumnName(i));
				}
				arr.put(obj);
				int counter = 0;
				while (rs.next()) {
					obj = new JSONObject();
					obj.put("0", ++counter);
					obj.put("1", rs.getString("VEHICLE NUMBER"));
					obj.put("2", rs.getString("GROUP NAME"));
					obj.put("3", rs.getString("CUSTOMER"));
					obj.put("4", rs.getString("TRIP NO"));
					obj.put("5", rs.getString("FREE KMS"));
					obj.put("6", rs.getString("TRAVELLED KMS"));
					obj.put("7", rs.getString("EXTRA KMS"));

					arr.put(obj);
				}
			} else if (type.equalsIgnoreCase("crossBorderCount")) {
				query = getGroupNameQuery(SelfDriveCarsStatements.GET_CROSS_BORDER_DATA.replaceAll("AMS.dbo.LOCATION_ZONE", "AMS.dbo.LOCATION_ZONE_A"), groupName);
				pstmt = con.prepareStatement(query);
				pstmt.setInt(1, offset);
				pstmt.setInt(2, systemId);
				pstmt.setInt(3, customerId);
				pstmt.setInt(4, offset);
				pstmt.setString(5, startDate);
				pstmt.setInt(6, offset);
				pstmt.setString(7, endDate);
				pstmt.setInt(8, userId);
				// pstmt.setInt(9, offset);
				pstmt.setInt(9, systemId);
				pstmt.setInt(10, customerId);
				pstmt.setInt(11, offset);
				pstmt.setString(12, startDate);
				pstmt.setInt(13, offset);
				pstmt.setString(14, endDate);
				pstmt.setInt(15, userId);
				rs = pstmt.executeQuery();

				obj = new JSONObject();
				ResultSetMetaData rsmd = rs.getMetaData();
				int columnCount = rsmd.getColumnCount();
				obj.put("0", "SL NO.");
				for (int i = 1; i <= columnCount; i++) {
					obj.put("" + i, rsmd.getColumnName(i));
				}
				arr.put(obj);
				int counter = 0;
				while (rs.next()) {
					obj = new JSONObject();
					obj.put("0", ++counter);
					obj.put("1", rs.getString("VEHICLE NUMBER"));
					obj.put("2", rs.getString("GROUP NAME"));
					obj.put("3", rs.getString("ALERT TYPE"));
					obj.put("4", sdfDB.format(sdfDB.parse(rs.getString("LOCALTIME"))));
					obj.put("5", rs.getString("CROSSED BORDER"));

					arr.put(obj);
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(null, pstmt, rs);
		}
		return arr;
	}

	public JSONObject getPickupRiskCount(Connection con, Integer systemId, Integer customerId, String startDate, String endDate, Integer offset, JSONObject obj, Integer userId, String groupName) {
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		Integer pickupRiskCount = 0;
		String query = "";
		try {
			query = getGroupNameQuery(SelfDriveCarsStatements.GET_PICKUP_RISK_COUNT, groupName);
			pstmt = con.prepareStatement(query);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, customerId);
			pstmt.setInt(3, offset);
			pstmt.setString(4, startDate);
			pstmt.setInt(5, offset);
			pstmt.setString(6, endDate);
			pstmt.setInt(7, userId);
			rs = pstmt.executeQuery();

			if (rs.next()) {
				pickupRiskCount = rs.getInt("PICKUP_RISK_COUNT");
			}
			obj.put("pickupRiskCount", pickupRiskCount);

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(null, pstmt, rs);
		}

		return obj;
	}

	private JSONArray getPickupRisk(Connection con, Integer systemId, Integer customerId, String type, String startDate, String endDate, Integer offset, int userId, String groupName) {

		JSONArray arr = new JSONArray();
		JSONObject obj = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";

		try {
			query = getGroupNameQuery(SelfDriveCarsStatements.GET_PICKUP_RISK_DATA, groupName);
			pstmt = con.prepareStatement(query);
			pstmt.setInt(1, offset);
			pstmt.setInt(2, offset);
			pstmt.setInt(3, offset);
			pstmt.setInt(4, systemId);
			pstmt.setInt(5, customerId);
			pstmt.setInt(6, offset);
			pstmt.setString(7, startDate);
			pstmt.setInt(8, offset);
			pstmt.setString(9, endDate);
			pstmt.setInt(10, userId);

			rs = pstmt.executeQuery();
			obj = new JSONObject();
			ResultSetMetaData rsmd = rs.getMetaData();
			int columnCount = rsmd.getColumnCount();
			obj.put("0", "SL NO.");
			for (int i = 1; i <= columnCount; i++) {
				obj.put("" + i, rsmd.getColumnName(i));
			}
			arr.put(obj);
			int counter = 0;
			while (rs.next()) {
				obj = new JSONObject();
				obj.put("0", ++counter);
				obj.put("1", rs.getString("VEHICLE NUMBER"));
				obj.put("2", rs.getString("GROUP NAME"));
				obj.put("3", rs.getString("TRIP NO"));
				obj.put("4", rs.getString("ACTUAL TRIP START TIME") != null ? sdfDB.format(sdfDB.parse(rs.getString("ACTUAL TRIP START TIME"))) : "");
				obj.put("5", sdfDB.format(sdfDB.parse(rs.getString("PLANNED TRIP END TIME"))));
				obj.put("6", rs.getString("ETA") != null ? sdfDB.format(sdfDB.parse(rs.getString("ETA"))) : "");
				obj.put("7", rs.getString("DELAY(HH:MM)").contains("-") ? cf.convertMinutesToHHMMFormatNegative(rs.getInt("DELAY(HH:MM)")) : cf.convertMinutesToHHMMFormat(rs.getInt("DELAY(HH:MM)")));

				arr.put(obj);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(null, pstmt, rs);
		}
		return arr;
	}

	public JSONObject getRestrictiveZonesCount(Connection con, Integer systemId, Integer customerId, String startDate, String endDate, Integer offset, JSONObject obj, Integer userId, String groupName) {
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		Integer restrictiveZonesCount = 0;
		String query = "";

		try {
			query = getGroupNameQuery(SelfDriveCarsStatements.GET_RESTRICTIVE_ZONES_COUNT, groupName);
			pstmt = con.prepareStatement(query);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, customerId);
			pstmt.setInt(3, offset);
			pstmt.setString(4, startDate);
			pstmt.setInt(5, offset);
			pstmt.setString(6, endDate);
			pstmt.setInt(7, userId);
			rs = pstmt.executeQuery();

			if (rs.next()) {
				restrictiveZonesCount = rs.getInt("RESTRICTIVE_ZONES_COUNT");
			}
			obj.put("restrictiveZonesCount", restrictiveZonesCount);

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(null, pstmt, rs);
		}

		return obj;
	}

	private JSONArray getRestrictiveZoneData(Connection con, Integer systemId, Integer customerId, String type, String startDate, String endDate, Integer offset, int userId, String zone,
			String groupName) {

		JSONArray arr = new JSONArray();
		JSONObject obj = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
		try {
			query = getGroupNameQuery(SelfDriveCarsStatements.GET_RESTRICTIVE_ZONES_DATA.replace("X", zone), groupName);
			pstmt = con.prepareStatement(query);
			pstmt.setInt(1, offset);
			pstmt.setInt(2, systemId);
			pstmt.setInt(3, customerId);
			pstmt.setInt(4, offset);
			pstmt.setString(5, startDate);
			pstmt.setInt(6, offset);
			pstmt.setString(7, endDate);
			pstmt.setInt(8, userId);

			rs = pstmt.executeQuery();
			obj = new JSONObject();
			ResultSetMetaData rsmd = rs.getMetaData();
			int columnCount = rsmd.getColumnCount();
			obj.put("0", "SL NO.");
			for (int i = 1; i <= columnCount; i++) {
				obj.put("" + i, rsmd.getColumnName(i));
			}
			arr.put(obj);
			int counter = 0;
			while (rs.next()) {
				obj = new JSONObject();
				obj.put("0", ++counter);
				obj.put("1", rs.getString("VEHICLE NUMBER"));
				obj.put("2", rs.getString("GROUP NAME"));
				obj.put("3", rs.getString("TRIP NO"));
				obj.put("4", rs.getString("NAME"));
				obj.put("5", rs.getString("LOCATION"));
				obj.put("6", rs.getString("ALERT TIME") != null ? sdfDB.format(sdfDB.parse(rs.getString("ALERT TIME"))) : "");

				arr.put(obj);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(null, pstmt, rs);
		}
		return arr;
	}

	private JSONArray getLowFuelData(Connection con, Integer systemId, Integer customerId, String type, String startDate, String endDate, Integer offset, int userId, String zone, String groupName) {

		JSONArray arr = new JSONArray();
		JSONObject obj = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
		try {
			query = getGroupNameQuery(SelfDriveCarsStatements.GET_LOW_FUEL_DATA, groupName);
			pstmt = con.prepareStatement(query);
			pstmt.setInt(1, offset);
			pstmt.setInt(2, offset);
			pstmt.setInt(3, systemId);
			pstmt.setInt(4, customerId);
			pstmt.setInt(5, offset);
			pstmt.setString(6, startDate);
			pstmt.setInt(7, offset);
			pstmt.setString(8, endDate);
			pstmt.setInt(9, userId);
			pstmt.setInt(10, systemId);
			pstmt.setInt(11, customerId);
			pstmt.setInt(12, offset);
			pstmt.setString(13, startDate);
			pstmt.setInt(14, offset);
			pstmt.setString(15, endDate);
			pstmt.setInt(16, userId);

			rs = pstmt.executeQuery();
			obj = new JSONObject();
			ResultSetMetaData rsmd = rs.getMetaData();
			int columnCount = rsmd.getColumnCount();
			obj.put("0", "SL NO.");
			for (int i = 1; i <= columnCount; i++) {
				obj.put("" + i, rsmd.getColumnName(i));
			}
			arr.put(obj);
			int counter = 0;
			while (rs.next()) {
				obj = new JSONObject();
				obj.put("0", ++counter);
				obj.put("1", rs.getString("VEHICLE NUMBER"));
				obj.put("2", rs.getString("GROUP NAME"));
				obj.put("3", df2.format(rs.getDouble("FUEL LEVEL (Ltr)")));
				obj.put("4", sdfDB.format(sdfDB.parse(rs.getString("START TIME"))));
				obj.put("5", sdfDB.format(sdfDB.parse(rs.getString("END TIME"))));
				arr.put(obj);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(null, pstmt, rs);
		}
		return arr;
	}

	public JSONObject getNearFuelStationCount(Connection con, Integer systemId, Integer customerId, String startDate, String endDate, Integer offset, JSONObject obj, Integer userId, String groupName) {
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Integer nearFuelStationCount = 0;
		String query = "";

		try {
			query = getGroupNameQuery(SelfDriveCarsStatements.GET_NEAR_FUEL_STATION_COUNT, groupName);
			pstmt = con.prepareStatement(query);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, customerId);
			pstmt.setInt(3, offset);
			pstmt.setString(4, startDate);
			pstmt.setInt(5, offset);
			pstmt.setString(6, endDate);
			pstmt.setInt(7, userId);
			pstmt.setInt(8, systemId);
			pstmt.setInt(9, customerId);
			pstmt.setInt(10, offset);
			pstmt.setString(11, startDate);
			pstmt.setInt(12, offset);
			pstmt.setString(13, endDate);
			pstmt.setInt(14, userId);
			rs = pstmt.executeQuery();

			while (rs.next()) {
				nearFuelStationCount += rs.getInt("COUNT");
			}
			obj.put("nearFuelStationCount", nearFuelStationCount);

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(null, pstmt, rs);
		}

		return obj;
	}

	private JSONArray getNearFuelStationData(Connection con, Integer systemId, Integer customerId, String type, String startDate, String endDate, Integer offset, int userId, String zone,
			String groupName) {

		JSONArray arr = new JSONArray();
		JSONObject obj = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
		try {
			query = getGroupNameQuery(SelfDriveCarsStatements.GET_NEAR_FUEL_STATION_DATA, groupName);
			pstmt = con.prepareStatement(query);
			pstmt.setInt(1, offset);
			pstmt.setInt(2, systemId);
			pstmt.setInt(3, customerId);
			pstmt.setInt(4, offset);
			pstmt.setString(5, startDate);
			pstmt.setInt(6, offset);
			pstmt.setString(7, endDate);
			pstmt.setInt(8, userId);
			pstmt.setInt(9, systemId);
			pstmt.setInt(10, customerId);
			pstmt.setInt(11, offset);
			pstmt.setString(12, startDate);
			pstmt.setInt(13, offset);
			pstmt.setString(14, endDate);
			pstmt.setInt(15, userId);

			rs = pstmt.executeQuery();
			obj = new JSONObject();
			ResultSetMetaData rsmd = rs.getMetaData();
			int columnCount = rsmd.getColumnCount();
			obj.put("0", "SL NO.");
			for (int i = 1; i <= columnCount; i++) {
				if (!rsmd.getColumnName(i).equals("NEAR BY FUEL STATIONS")) {
					obj.put("" + i, rsmd.getColumnName(i));
				}

			}
			arr.put(obj);
			int counter = 0;
			while (rs.next()) {
				obj = new JSONObject();
				obj.put("0", ++counter);
				obj.put("1", rs.getString("VEHICLE NUMBER"));
				obj.put("2", rs.getString("GROUP NAME"));
				obj.put("3", df2.format(rs.getDouble("FUEL LEVEL (Ltr)")));
				obj.put("4", sdfDB.format(sdfDB.parse(rs.getString("START TIME"))));
				// obj.put("5",
				// "<p><a style='cursor: pointer;color:blue'  href = 'https://www.google.co.in/maps/search/fuel+station+near+me/@"+rs.getString("NEAR BY FUEL STATIONS")+"' target='_blank'><u>Near By Fuel Stations</u></a></p>");
				arr.put(obj);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(null, pstmt, rs);
		}
		return arr;
	}

	@SuppressWarnings("deprecation")
	public JSONObject getTopRowCounts(Connection con, Integer systemId, Integer customerId, String startDate, String endDate, Integer offset, JSONObject obj, Integer userId) {
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		Integer totalVehicles = 0, onTripVehicles = 0, onRoadVehicles = 0, vehiclesAtServiceStation = 0, vehiclesAtHubLocations = 0, totalKmsToday = 0;

		try {
			pstmt = con.prepareStatement(SelfDriveCarsStatements.GET_TOTAL_VEHICLES_COUNT);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, customerId);
			pstmt.setInt(3, userId);
			rs = pstmt.executeQuery();

			if (rs.next()) {
				totalVehicles = rs.getInt("COUNT");
			}
			obj.put("totalVehicles", totalVehicles);

			pstmt = con.prepareStatement(SelfDriveCarsStatements.GET_ON_TRIP_VEHICLES_COUNT);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, customerId);
			pstmt.setInt(3, userId);
			rs = pstmt.executeQuery();

			if (rs.next()) {
				onTripVehicles = rs.getInt("COUNT");
			}
			obj.put("onTripVehicles", onTripVehicles);

			pstmt = con.prepareStatement(SelfDriveCarsStatements.GET_ON_ROAD_VEHICLES_COUNT);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, customerId);
			pstmt.setInt(3, userId);
			rs = pstmt.executeQuery();

			if (rs.next()) {
				onRoadVehicles = rs.getInt("COUNT");
			}
			obj.put("onRoadVehicles", onRoadVehicles);

			pstmt = con.prepareStatement(SelfDriveCarsStatements.GET_VEHICLES_AT_SERVICE_STATION_COUNT);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, customerId);
			pstmt.setInt(3, offset);
			pstmt.setString(4, startDate);
			pstmt.setInt(5, offset);
			pstmt.setString(6, endDate);
			pstmt.setInt(7, userId);
			pstmt.setInt(8, systemId);
			pstmt.setInt(9, customerId);
			pstmt.setInt(10, offset);
			pstmt.setString(11, startDate);
			pstmt.setInt(12, offset);
			pstmt.setString(13, endDate);
			pstmt.setInt(14, userId);
			rs = pstmt.executeQuery();

			while (rs.next()) {
				vehiclesAtServiceStation += rs.getInt("COUNT");
			}

			obj.put("vehiclesAtServiceStation", vehiclesAtServiceStation);

			pstmt = con.prepareStatement(SelfDriveCarsStatements.GET_VEHICLES_AT_HUB_LOCATIONS_COUNT);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, customerId);
			pstmt.setInt(3, offset);
			pstmt.setString(4, startDate);
			pstmt.setInt(5, offset);
			pstmt.setString(6, endDate);
			pstmt.setInt(7, userId);
			pstmt.setInt(8, systemId);
			pstmt.setInt(9, customerId);
			pstmt.setInt(10, offset);
			pstmt.setString(11, startDate);
			pstmt.setInt(12, offset);
			pstmt.setString(13, endDate);
			pstmt.setInt(14, userId);
			rs = pstmt.executeQuery();

			while (rs.next()) {
				vehiclesAtHubLocations += rs.getInt("COUNT");
			}

			obj.put("vehiclesAtHubLocations", vehiclesAtHubLocations);

			// creating a window to fetch data
			Date sDate = sdfDB.parse(endDate);
			sDate.setHours(0);
			sDate.setMinutes(0);
			sDate.setSeconds(0);
			Date eDate = sdfDB.parse(endDate);
			eDate.setHours(23);
			eDate.setMinutes(59);
			eDate.setSeconds(59);
			pstmt = con.prepareStatement(SelfDriveCarsStatements.GET_TODAY_TRAVELLED_KMS.replaceAll("##", Integer.toString(systemId)));
			pstmt.setInt(1, offset);
			pstmt.setString(2, sdfDB.format(sDate));
			pstmt.setInt(3, offset);
			pstmt.setString(4, sdfDB.format(eDate));
			pstmt.setInt(5, userId);
			rs = pstmt.executeQuery();

			while (rs.next()) {
				if (rs.getInt("COUNT") < Integer.parseInt(dailyTravelledDistanceLimit)) {
					totalKmsToday += rs.getInt("COUNT");
				}

			}

			obj.put("totalKmsToday", totalKmsToday);

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(null, pstmt, rs);
		}

		return obj;
	}

	@SuppressWarnings("deprecation")
	private JSONArray getTopRowData(Connection con, Integer systemId, Integer customerId, String type, String startDate, String endDate, Integer offset, int userId, String zone) {

		JSONArray arr = new JSONArray();
		JSONObject obj = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		try {
			if (type.equalsIgnoreCase("totalVehicles")) {
				pstmt = con.prepareStatement(SelfDriveCarsStatements.GET_TOTAL_VEHICLES_DATA);
				pstmt.setInt(1, offset);
				pstmt.setInt(2, systemId);
				pstmt.setInt(3, customerId);
				pstmt.setInt(4, userId);
				rs = pstmt.executeQuery();

				obj = new JSONObject();
				ResultSetMetaData rsmd = rs.getMetaData();
				int columnCount = rsmd.getColumnCount();
				obj.put("0", "SL NO.");
				for (int i = 1; i <= columnCount; i++) {
					obj.put("" + i, rsmd.getColumnName(i));
				}
				arr.put(obj);
				int counter = 0;
				while (rs.next()) {
					obj = new JSONObject();
					obj.put("0", ++counter);
					obj.put("1", rs.getString("VEHICLE NUMBER"));
					obj.put("2", rs.getString("GROUP NAME"));
					obj.put("3", sdfDB.format(sdfDB.parse(rs.getString("LAST COMMUNICATED TIME"))));
					arr.put(obj);
				}
			} else if (type.equalsIgnoreCase("onTripVehicles")) {
				pstmt = con.prepareStatement(SelfDriveCarsStatements.GET_ON_TRIP_VEHICLES_DATA);
				pstmt.setInt(1, offset);
				pstmt.setInt(2, systemId);
				pstmt.setInt(3, customerId);
				pstmt.setInt(4, userId);
				rs = pstmt.executeQuery();

				obj = new JSONObject();
				ResultSetMetaData rsmd = rs.getMetaData();
				int columnCount = rsmd.getColumnCount();
				obj.put("0", "SL NO.");
				for (int i = 1; i <= columnCount; i++) {
					obj.put("" + i, rsmd.getColumnName(i));
				}
				arr.put(obj);
				int counter = 0;
				while (rs.next()) {
					obj = new JSONObject();
					obj.put("0", ++counter);
					obj.put("1", rs.getString("VEHICLE NUMBER"));
					obj.put("2", rs.getString("GROUP NAME"));
					obj.put("3", sdfDB.format(sdfDB.parse(rs.getString("TRIP START TIME"))));
					arr.put(obj);
				}
			} else if (type.equalsIgnoreCase("onRoadVehicles")) {
				pstmt = con.prepareStatement(SelfDriveCarsStatements.GET_ON_ROAD_VEHICLES_DATA);
				pstmt.setInt(1, offset);
				pstmt.setInt(2, systemId);
				pstmt.setInt(3, customerId);
				pstmt.setInt(4, userId);
				rs = pstmt.executeQuery();

				obj = new JSONObject();
				ResultSetMetaData rsmd = rs.getMetaData();
				int columnCount = rsmd.getColumnCount();
				obj.put("0", "SL NO.");
				for (int i = 1; i <= columnCount; i++) {
					obj.put("" + i, rsmd.getColumnName(i));
				}
				arr.put(obj);
				int counter = 0;
				while (rs.next()) {
					obj = new JSONObject();
					obj.put("0", ++counter);
					obj.put("1", rs.getString("VEHICLE NUMBER"));
					obj.put("2", rs.getString("GROUP NAME"));
					obj.put("3", sdfDB.format(sdfDB.parse(rs.getString("LAST COMMUNICATED TIME"))));
					arr.put(obj);
				}
			} else if (type.equalsIgnoreCase("vehiclesAtHubLocations")) {
				pstmt = con.prepareStatement(SelfDriveCarsStatements.GET_VEHICLES_AT_HUB_LOCATIONS_DATA);
				pstmt.setInt(1, offset);
				pstmt.setInt(2, systemId);
				pstmt.setInt(3, customerId);
				pstmt.setInt(4, offset);
				pstmt.setString(5, startDate);
				pstmt.setInt(6, offset);
				pstmt.setString(7, endDate);
				pstmt.setInt(8, userId);
				pstmt.setInt(9, offset);
				pstmt.setInt(10, systemId);
				pstmt.setInt(11, customerId);
				pstmt.setInt(12, offset);
				pstmt.setString(13, startDate);
				pstmt.setInt(14, offset);
				pstmt.setString(15, endDate);
				pstmt.setInt(16, userId);
				rs = pstmt.executeQuery();

				obj = new JSONObject();
				ResultSetMetaData rsmd = rs.getMetaData();
				int columnCount = rsmd.getColumnCount();
				obj.put("0", "SL NO.");
				for (int i = 1; i <= columnCount; i++) {
					obj.put("" + i, rsmd.getColumnName(i));
				}
				arr.put(obj);
				int counter = 0;
				while (rs.next()) {
					obj = new JSONObject();
					obj.put("0", ++counter);
					obj.put("1", rs.getString("VEHICLE NUMBER"));
					obj.put("2", rs.getString("GROUP NAME"));
					obj.put("3", sdfDB.format(sdfDB.parse(rs.getString("HUB LOCATION ARRIVAL TIME"))));
					arr.put(obj);
				}
			} else if (type.equalsIgnoreCase("vehiclesAtServiceStation")) {
				pstmt = con.prepareStatement(SelfDriveCarsStatements.GET_VEHICLES_AT_SERVICE_STATION_DATA);
				pstmt.setInt(1, offset);
				pstmt.setInt(2, systemId);
				pstmt.setInt(3, customerId);
				pstmt.setInt(4, offset);
				pstmt.setString(5, startDate);
				pstmt.setInt(6, offset);
				pstmt.setString(7, endDate);
				pstmt.setInt(8, userId);
				pstmt.setInt(9, offset);
				pstmt.setInt(10, systemId);
				pstmt.setInt(11, customerId);
				pstmt.setInt(12, offset);
				pstmt.setString(13, startDate);
				pstmt.setInt(14, offset);
				pstmt.setString(15, endDate);
				pstmt.setInt(16, userId);
				rs = pstmt.executeQuery();

				obj = new JSONObject();
				ResultSetMetaData rsmd = rs.getMetaData();
				int columnCount = rsmd.getColumnCount();
				obj.put("0", "SL NO.");
				for (int i = 1; i <= columnCount; i++) {
					obj.put("" + i, rsmd.getColumnName(i));
				}
				arr.put(obj);
				int counter = 0;
				while (rs.next()) {
					obj = new JSONObject();
					obj.put("0", ++counter);
					obj.put("1", rs.getString("VEHICLE NUMBER"));
					obj.put("2", rs.getString("GROUP NAME"));
					obj.put("3", sdfDB.format(sdfDB.parse(rs.getString("SERVICE STATION ARRIVAL TIME"))));
					arr.put(obj);
				}
			}

			else if (type.equalsIgnoreCase("totalKmsToday")) {
				Date sDate = sdfDB.parse(endDate);
				sDate.setHours(0);
				sDate.setMinutes(0);
				sDate.setSeconds(0);
				Date eDate = sdfDB.parse(endDate);
				eDate.setHours(23);
				eDate.setMinutes(59);
				eDate.setSeconds(59);

				pstmt = con.prepareStatement(SelfDriveCarsStatements.GET_TODAY_TRAVELLED_KMS_DATA.replaceAll("##", Integer.toString(systemId)));
				pstmt.setInt(1, offset);
				pstmt.setString(2, sdfDB.format(sDate));
				pstmt.setInt(3, offset);
				pstmt.setString(4, sdfDB.format(eDate));
				pstmt.setInt(5, userId);
				rs = pstmt.executeQuery();

				obj = new JSONObject();
				ResultSetMetaData rsmd = rs.getMetaData();
				int columnCount = rsmd.getColumnCount();
				obj.put("0", "SL NO.");
				for (int i = 1; i <= columnCount; i++) {
					obj.put("" + i, rsmd.getColumnName(i));
				}
				arr.put(obj);
				int counter = 0;
				while (rs.next()) {
					if (rs.getInt("TRAVELLED KMS") < Integer.parseInt(dailyTravelledDistanceLimit)) {
						obj = new JSONObject();
						obj.put("0", ++counter);
						obj.put("1", rs.getString("VEHICLE NUMBER"));
						obj.put("2", rs.getString("GROUP NAME"));
						obj.put("3", rs.getString("TRAVELLED KMS"));
						// obj.put("4",
						// sdfDB.format(sdfDB.parse(rs.getString("START TIME"))));
						// obj.put("5",
						// sdfDB.format(sdfDB.parse(rs.getString("END TIME"))));
						arr.put(obj);
					}
				}
			}

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(null, pstmt, rs);
		}
		return arr;
	}

	public JSONArray getVehicleCurrentPositions(String vehicles, Integer systemId, Integer customerId) {
		JSONArray arr = new JSONArray();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		JSONObject obj = null;
		String vehicleList = "'" + vehicles.replace(",", "','") + "'";

		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(SelfDriveCarsStatements.GET_VEHICLES_CURRENT_POSITION.replace("##", "  REGISTRATION_NO IN (" + vehicleList + ")"));
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, customerId);
			rs = pstmt.executeQuery();

			while (rs.next()) {
				obj = new JSONObject();
				obj.put("latitude", rs.getString("LATITUDE"));
				obj.put("longitude", rs.getString("LONGITUDE"));
				obj.put("vehicleNo", rs.getString("REGISTRATION_NO"));
				obj.put("location", rs.getString("LOCATION"));
				arr.put(obj);
			}

		} catch (Exception e) {
			e.printStackTrace();
		}

		return arr;
	}

	public JSONArray getGroupNames(int systemId, int custId) {

		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			jsonArray = new JSONArray();
			jsonObject = new JSONObject();

			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(SelfDriveCarsStatements.GET_GROUP_NAMES);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, custId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				jsonObject = new JSONObject();
				jsonObject.put("groupName", rs.getString("GROUP_NAME"));
				jsonArray.put(jsonObject);
			}
		} catch (Exception e) {
			System.out.println("Error in getGroupNames " + e.toString());
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jsonArray;

	}

	public String getGroupNameQuery(CharSequence query, String groupName) {
		String groupNme = "";
		String[] groupNames = groupName.split(",");
		String retValue = query.toString();
		for (int i = 0; i < groupNames.length; i++) {
			groupNme = groupNme + ",'" + groupNames[i] + "'";
		}
		if (groupName.equals("ALL") || groupName.equals("")) {
			retValue = query.toString().replace("#", "");
		} else {
			retValue = query.toString().replace("#", " AND lvs.GROUP_NAME in (" + groupNme.substring(1, groupNme.length()) + ")");
		}

		return retValue;
	}

	public String appendDatesForMileage(CharSequence query, String dates) {
		String groupNme = "";
		String[] groupNames = dates.split(",");
		String retValue = query.toString();
		for (int i = 0; i < groupNames.length; i++) {
			if (i == 0)
				groupNme = "'" + groupNames[i] + "'";
			else
				groupNme = groupNme + ",'" + groupNames[i] + "'";
		}

		retValue = query.toString().replace("$", " AND a.DATE IN (" + groupNme + ")");
		System.out.println(retValue);

		return retValue;
	}

	public String datedifference(String startDate, String endDate) {
		String dates = "";
		Calendar temp = Calendar.getInstance();
		Date sDate;
		try {
			sDate = sdfDB.parse(startDate);
			long startTime = sdfDB.parse(startDate).getTime();
			long endTime = sdfDB.parse(endDate).getTime();
			long diffDays = (endTime - startTime) / (1000 * 60 * 60 * 24);
			dates = sdfDB2.format(sDate);
			Date mid = sDate;
			for (int k = 0; k < diffDays; ++k) {
				temp.setTime(mid);
				temp.add(Calendar.DATE, 1);
				mid = temp.getTime();
				dates += "," + sdfDB2.format(temp.getTime());
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		System.out.println("The processed dates list is as : " + dates);

		return dates;
	}

	public JSONObject getIdlingCount(Connection con, Integer systemId, Integer customerId, String startDate, String endDate, Integer offset, JSONObject obj, Integer userId, String groupName) {
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Integer idleCount = 0;
		String query = "";

		try {
			query = getGroupNameQuery(SelfDriveCarsStatements.GET_IDLE_COUNT, groupName);
			pstmt = con.prepareStatement(query);
			System.out.println(SelfDriveCarsStatements.GET_IDLE_COUNT);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, customerId);
			pstmt.setInt(3, offset);
			pstmt.setString(4, startDate);
			pstmt.setInt(5, offset);
			pstmt.setString(6, endDate);
			pstmt.setInt(7, userId);

			pstmt.setInt(8, systemId);
			pstmt.setInt(9, customerId);
			pstmt.setInt(10, offset);
			pstmt.setString(11, startDate);
			pstmt.setInt(12, offset);
			pstmt.setString(13, endDate);
			pstmt.setInt(14, userId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				idleCount += rs.getInt("COUNT");
			}
			obj.put("Idle", idleCount);

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(null, pstmt, rs);
		}

		return obj;
	}

	public JSONArray getIdlingData(Connection con, Integer systemId, Integer customerId, String type, String startDate, String endDate, Integer offset, int userId, String groupName) throws Exception {

		JSONArray arr = new JSONArray();
		JSONObject obj = null;
		PreparedStatement pstmt = null;

		ResultSet rs = null;
		String query = "";

		try {
			query = getGroupNameQuery(SelfDriveCarsStatements.GET_IDLE_DATA, groupName);
			pstmt = con.prepareStatement(query);
			pstmt.setInt(1, offset);
			pstmt.setInt(2, systemId);
			pstmt.setInt(3, customerId);
			pstmt.setInt(4, offset);
			pstmt.setString(5, startDate);
			pstmt.setInt(6, offset);
			pstmt.setString(7, endDate);
			pstmt.setInt(8, userId);
			pstmt.setInt(9, offset);
			pstmt.setInt(10, systemId);
			pstmt.setInt(11, customerId);
			pstmt.setInt(12, offset);
			pstmt.setString(13, startDate);
			pstmt.setInt(14, offset);
			pstmt.setString(15, endDate);
			pstmt.setInt(16, userId);
			rs = pstmt.executeQuery();
			obj = new JSONObject();
			ResultSetMetaData rsmd = rs.getMetaData();
			int columnCount = rsmd.getColumnCount();
			obj.put("0", "SL NO.");
			for (int i = 1; i <= columnCount; i++) {
				obj.put("" + i, rsmd.getColumnName(i));
			}
			arr.put(obj);
			int counter = 0;
			while (rs.next()) {
				obj = new JSONObject();
				obj.put("0", ++counter);
				obj.put("1", rs.getString("VEHICLE NO"));
				obj.put("2", rs.getString("GROUP NAME"));
				obj.put("3", sdfDB.format(sdfDB.parse(rs.getString("ALERT TIME"))));
				obj.put("4",  String.format("%.2f", (stoppageTimeInHHMM(rs.getString("IDLE DURATION(HH.MM)")))));
				obj.put("5", rs.getString("TRIP ID") != null ? rs.getString("TRIP ID") : "-");
				arr.put(obj);
			}

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(null, pstmt, rs);
		}
		return arr;
	}

	public double stoppageTimeInHHMM(String stop) {
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

	public JSONObject getMileageCount(Connection con, Integer systemId, Integer customerId, String startDate, String endDate, Integer offset, JSONObject obj, Integer userId, String groupName) {
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Integer mileageCount = 0;
		String query = "";
		String dates = "";

		try {
			if (startDate != null || endDate != null) {
				dates = datedifference(startDate, endDate);
			}
			query = getGroupNameQuery(SelfDriveCarsStatements.GET_MILEAGE_COUNT, groupName);
			String temp = appendDatesForMileage(query, dates);
			pstmt = con.prepareStatement(temp);
			System.out.println(SelfDriveCarsStatements.GET_MILEAGE_COUNT);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, customerId);
			pstmt.setInt(3, userId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				mileageCount += rs.getInt("COUNT");
			}
			obj.put("mileageCount", mileageCount);

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(null, pstmt, rs);
		}

		return obj;
	}

	public JSONArray getMileageData(Connection con, Integer systemId, Integer customerId, String type, String startDate, String endDate, Integer offset, int userId, String groupName) throws Exception {

		JSONArray arr = new JSONArray();
		JSONObject obj = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
		String dates = "";
		try {

			if (startDate != null || endDate != null) {
				dates = datedifference(startDate, endDate);
			}
			query = getGroupNameQuery(SelfDriveCarsStatements.GET_MILEAGE_DATA, groupName);
			String temp = appendDatesForMileage(query, dates);
			pstmt = con.prepareStatement(temp);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, customerId);
			pstmt.setInt(3, userId);
			rs = pstmt.executeQuery();
			obj = new JSONObject();
			ResultSetMetaData rsmd = rs.getMetaData();

			int columnCount = rsmd.getColumnCount();
			obj.put("0", "SL NO.");
			for (int i = 1; i <= columnCount; i++) {
				obj.put("" + i, rsmd.getColumnName(i));
			}
			arr.put(obj);
			int counter = 0;
			while (rs.next()) {
				obj = new JSONObject();
				obj.put("0", ++counter);
				obj.put("1", rs.getString("VEHICLE NO"));
				obj.put("2", rs.getString("GROUP NAME"));
				obj.put("3", rs.getString("DATE"));
				obj.put("4",  String.format("%.2f", Double.parseDouble(rs.getString("MILEAGE"))));
				obj.put("5", rs.getString("TRIP NO"));
				arr.put(obj);
			}
			System.out.println("arr " + arr.length());

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(null, pstmt, rs);
		}
		return arr;
	}

	public JSONObject getRefuelCount(Connection con, Integer systemId, Integer customerId, String startDate, String endDate, Integer offset, JSONObject obj, Integer userId, String groupName) {
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Integer refuelCount = 0;
		String query = "";
		String dates = "";

		try {
			if (startDate != null || endDate != null) {
				dates = datedifference(startDate, endDate);
			}
			query = getGroupNameQuery(SelfDriveCarsStatements.GET_REFUEL_COUNT, groupName);
			String temp = appendDatesForMileage(query, dates);
			pstmt = con.prepareStatement(temp);
			System.out.println(SelfDriveCarsStatements.GET_REFUEL_COUNT);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, customerId);
			pstmt.setInt(3, userId);

			rs = pstmt.executeQuery();
			while (rs.next()) {
				refuelCount += rs.getInt("COUNT");
			}
			obj.put("refuelCount", refuelCount);

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(null, pstmt, rs);
		}

		return obj;
	}

	public JSONArray getRefuelData(Connection con, Integer systemId, Integer customerId, String type, String startDate, String endDate, Integer offset, int userId, String groupName) throws Exception {

		JSONArray arr = new JSONArray();
		JSONObject obj = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
		String dates = "";

		try {
			if (startDate != null || endDate != null) {
				dates = datedifference(startDate, endDate);
			}
			query = getGroupNameQuery(SelfDriveCarsStatements.GET_REFUEL_DATA, groupName);
			String temp = appendDatesForMileage(query, dates);
			pstmt = con.prepareStatement(temp);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, customerId);
			pstmt.setInt(3, userId);

			rs = pstmt.executeQuery();
			obj = new JSONObject();
			ResultSetMetaData rsmd = rs.getMetaData();
			int columnCount = rsmd.getColumnCount();
			obj.put("0", "SL NO.");
			for (int i = 1; i <= columnCount; i++) {
				obj.put("" + i, rsmd.getColumnName(i));
			}
			arr.put(obj);
			int counter = 0;
			while (rs.next()) {
				obj = new JSONObject();
				obj.put("0", ++counter);
				obj.put("1", rs.getString("VEHICLE NO"));
				obj.put("2", rs.getString("GROUP NAME"));
				obj.put("3", rs.getString("DATE"));
				obj.put("4", df2.format(rs.getDouble("REFUEL (Ltrs)")));
				obj.put("5", rs.getString("TRIP NO"));
				arr.put(obj);
			}

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(null, pstmt, rs);
		}
		return arr;
	}

	public JSONObject getPilferageCount(Connection con, Integer systemId, Integer customerId, String startDate, String endDate, Integer offset, JSONObject obj, Integer userId, String groupName) {
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Integer pilferageCount = 0;
		String query = "";
		String dates = "";

		try {
			if (startDate != null || endDate != null) {
				dates = datedifference(startDate, endDate);
			}
			query = getGroupNameQuery(SelfDriveCarsStatements.GET_PILFERAGE_COUNT, groupName);
			String temp = appendDatesForMileage(query, dates);
			pstmt = con.prepareStatement(temp);
			System.out.println(SelfDriveCarsStatements.GET_PILFERAGE_COUNT);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, customerId);
			pstmt.setInt(3, userId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				pilferageCount += rs.getInt("COUNT");
			}
			obj.put("pilferageCount", pilferageCount);

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(null, pstmt, rs);
		}

		return obj;
	}

	public JSONArray getPilferageData(Connection con, Integer systemId, Integer customerId, String type, String startDate, String endDate, Integer offset, int userId, String groupName)
			throws Exception {

		JSONArray arr = new JSONArray();
		JSONObject obj = null;
		PreparedStatement pstmt = null;

		ResultSet rs = null;
		String query = "";
		String dates = "";

		try {
			if (startDate != null || endDate != null) {
				dates = datedifference(startDate, endDate);
			}
			query = getGroupNameQuery(SelfDriveCarsStatements.GET_PILFERAGE_DATA, groupName);
			String temp = appendDatesForMileage(query, dates);
			pstmt = con.prepareStatement(temp);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, customerId);
			pstmt.setInt(3, userId);
			rs = pstmt.executeQuery();
			obj = new JSONObject();
			ResultSetMetaData rsmd = rs.getMetaData();
			int columnCount = rsmd.getColumnCount();
			obj.put("0", "SL NO.");
			for (int i = 1; i <= columnCount; i++) {
				obj.put("" + i, rsmd.getColumnName(i));
			}
			arr.put(obj);
			int counter = 0;
			while (rs.next()) {
				obj = new JSONObject();
				obj.put("0", ++counter);
				obj.put("1", rs.getString("VEHICLE NO"));
				obj.put("2", rs.getString("GROUP NAME"));
				obj.put("3", rs.getString("DATE"));
				obj.put("4", df2.format(rs.getDouble("PILFERAGE (Ltrs)")));
				obj.put("5", rs.getString("TRIP NO"));
				arr.put(obj);
			}

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(null, pstmt, rs);
		}
		return arr;
	}
	
	public JSONObject getMileageDropCount(Connection con, Integer systemId, Integer customerId, String startDate, String endDate, Integer offset, JSONObject obj, Integer userId, String groupName) {
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Integer mileageDropCount = 0;
		String query = "";
		String dates = "";

		try {
			if (startDate != null || endDate != null) {
				dates = datedifference(startDate, endDate);
			}
			query = getGroupNameQuery(SelfDriveCarsStatements.GET_MILEAGE_DROP_COUNT, groupName);
			String temp = appendDatesForMileage(query, dates);
			pstmt = con.prepareStatement(temp);
			System.out.println(SelfDriveCarsStatements.GET_MILEAGE_DROP_COUNT);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, customerId);
			pstmt.setInt(3, userId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				 mileageDropCount += rs.getInt("COUNT");
			}
			obj.put("mileageDropCount",  mileageDropCount);

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(null, pstmt, rs);
		}

		return obj;
	}
	
	public JSONArray getMileageDropData(Connection con, Integer systemId, Integer customerId, String type, String startDate, String endDate, Integer offset, int userId, String groupName) throws Exception {

		JSONArray arr = new JSONArray();
		JSONObject obj = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
		String dates = "";
		try {

			if (startDate != null || endDate != null) {
				dates = datedifference(startDate, endDate);
			}
			query = getGroupNameQuery(SelfDriveCarsStatements.GET_MILEAGE_DROP_DATA, groupName);
			String temp = appendDatesForMileage(query, dates);
			pstmt = con.prepareStatement(temp);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, customerId);
			pstmt.setInt(3, userId);
			rs = pstmt.executeQuery();
			obj = new JSONObject();
			ResultSetMetaData rsmd = rs.getMetaData();

			int columnCount = rsmd.getColumnCount();
			obj.put("0", "SL NO.");
			for (int i = 1; i <= columnCount; i++) {
				obj.put("" + i, rsmd.getColumnName(i));
			}
			arr.put(obj);
			int counter = 0;
			while (rs.next()) {
				obj = new JSONObject();
				obj.put("0", ++counter);
				obj.put("1", rs.getString("VEHICLE NO"));
				obj.put("2", rs.getString("GROUP NAME"));
				obj.put("3", rs.getString("DATE"));
				obj.put("4",  String.format("%.2f", Double.parseDouble(rs.getString("MILEAGE"))));
				obj.put("5", rs.getString("TRIP NO"));
				arr.put(obj);
			}
			System.out.println("arr " + arr.length());

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(null, pstmt, rs);
		}
		return arr;
	}
	
	

	@SuppressWarnings({ "deprecation" })
	public void sendMail(Integer systemId, Integer customerId, String type,
			String startDate, String endDate, Integer offset, int userId,
			String zone, String groupName) throws ParseException,
			JSONException, IOException {

		StringBuilder header = new StringBuilder();
		String rootPath;
		String completePath = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		try {
			con = DBConnection.getConnectionToDB("AMS");
			JSONArray data = getDataByType(systemId, customerId, type,
					startDate, endDate, offset, userId, zone, groupName);

			Date eDate = sdf.parse(endDate);
			Date sDate = sdf.parse(startDate);
			String name = type;
			

			int index = data.length();
			if (index != 0) {
				Properties properties = ApplicationListener.prop;
				rootPath = properties.getProperty("REVVMailData");
				completePath = rootPath + "\\" + name + "_"
						+ sdfDB2.format(sDate)+ "_" + sdfDB2.format(eDate)
						+ ".xls";
				File f = new File(rootPath);
				if (!f.exists()) {
					f.mkdir();
				}

				FileOutputStream fileOut = new FileOutputStream(completePath);
				HSSFWorkbook workbook = new HSSFWorkbook();
				HSSFSheet worksheet = workbook.createSheet(type);
				HSSFRow row;

				Font font = null;
				font = workbook.createFont();
				font.setBoldweight(Font.BOLDWEIGHT_BOLD);
				HSSFCellStyle style = workbook.createCellStyle();
				style.setFont(font);

				for (int i = 0; i < data.length(); i++) {
					row = worksheet.createRow((short) i);
					JSONObject xyz = data.getJSONObject(i);
					for (int j = 0; j < xyz.length(); j++) {
						if (i == 0) {
							HSSFCell cell = row.createCell((short) j);
							cell.setCellValue(xyz
									.getString(Integer.toString(j)));
							cell.setCellStyle(style);
						} else {
							HSSFCell cell = row.createCell((short) j);
							cell.setCellValue(xyz
									.getString(Integer.toString(j)));
						}
					}
				}
				workbook.write(fileOut);
				fileOut.flush();
				fileOut.close();

			}
			String subject = "Self Drive Vehicles Data Report"
					+ sdfDB2.format(sDate) +" - "
					+ sdfDB2.format(eDate);

			pstmt = con.prepareStatement(SelfDriveCarsStatements.GET_MAIL_ID);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, customerId);
			pstmt.setInt(3, userId);
			rs = pstmt.executeQuery();
			ArrayList<String> emailList = new ArrayList<String>();
			while(rs.next()){
				emailList.add(rs.getString("MAIL"));
			}

			header
					.append("<html> <body> <p><b>Dear Team,</b></p><p>Please find enclosed Data Report for "
							+ type
							+ sdfDB2.format(sDate)
							+ " - "
							+ sdfDB2.format(eDate)
							+ " </p></body></html>");
			MailGenerator m = new MailGenerator();
//			Only for local usage for triggering mails
//			MailGeneratorDummy m = new MailGeneratorDummy();
			m.send(con, 12, emailList, subject, header.toString(),
					completePath, "", "", true, "CC");
		} catch (Exception e) {
			e.printStackTrace();
		} finally{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
	}
	
}

