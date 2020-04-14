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
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.DataFormat;
import org.apache.poi.ss.usermodel.Font;
import org.apache.poi.ss.usermodel.IndexedColors;
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
import t4u.statements.TripSummaryStatement;
import t4u.util.TemperatureConfiguration;

import com.google.gson.internal.LinkedTreeMap;
import com.mongodb.BasicDBList;
import com.mongodb.BasicDBObject;
import com.mongodb.DBCollection;
import com.mongodb.DBCursor;
import com.mongodb.DBObject;
import com.mongodb.MongoClient;

@SuppressWarnings("deprecation")
public class TripSummaryFunctions {
	SimpleDateFormat sdfDB = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
	SimpleDateFormat sdf1 = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");// yyu
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
 
	
	
	
	public ArrayList<Object> getVehicleTripDetailsData(int clientId, int systemId,int offset,String startDate, String endDate,
							String vehcileNo,String vehicleGroup) {
		JSONArray JsonArray = new JSONArray();
		JSONObject JsonObject = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		ArrayList<Object> finlist = new ArrayList<Object>();
		try {
			int count = 0;
			con = DBConnection.getConnectionToDB("AMS");
			if(vehcileNo != null && !vehcileNo.equals("")){
				pstmt = con.prepareStatement(TripSummaryStatement.GET_VEHICLE_TRIP_DETAILS.replace("#", "ASSET_NUMBER=?"));
				pstmt.setString(3,vehcileNo);
			}
			else{
				pstmt = con.prepareStatement(TripSummaryStatement.GET_VEHICLE_TRIP_DETAILS.replace("#", "lvs.GROUP_NAME=?"));
				pstmt.setString(3,vehicleGroup);
			}
			pstmt.setInt(1,offset);
			pstmt.setInt(2,offset);
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
				JsonObject.put("groupIndex",rs.getString("GROUP_NAME"));
				JsonObject.put("vehicleNoIndex",rs.getString("ASSET_NUMBER"));
				JsonObject.put("vehicleTypeIndex",rs.getString("VehicleType"));
				if(rs.getString("Fullname") != null){
					JsonObject.put("driverNameIndex", rs.getString("Fullname"));
				}else{
					JsonObject.put("driverNameIndex","");
				}
				JsonObject.put("startingDateIndex",ddmmyyyy.format(sdfDB.parse(rs.getString("ACTUAL_TRIP_START_TIME"))));
				JsonObject.put("startingTimeIndex",timef.format(sdfDB.parse(rs.getString("ACTUAL_TRIP_START_TIME"))));
				if(rs.getString("ACTUAL_TRIP_END_TIME") != null){
					JsonObject.put("endingDateIndex",ddmmyyyy.format(sdfDB.parse(rs.getString("ACTUAL_TRIP_START_TIME"))));
					JsonObject.put("endingTimeIndex", timef.format(sdfDB.parse(rs.getString("ACTUAL_TRIP_END_TIME"))));
				}else{
					JsonObject.put("endingDateIndex","");
					JsonObject.put("endingTimeIndex","");
				}
				if(rs.getString("START_ODOMETER") != null){
					JsonObject.put("startingOdometerIndex", rs.getString("START_ODOMETER"));
				}else{
					JsonObject.put("startingOdometerIndex","");
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
	}
	 finally {
		DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return finlist;
	}


	public ArrayList<Object> getVehicleTripSummaryData(int clientId,
			int systemId, int offset, String startDate, String endDate,
			String vehcileNo1, String vehicleGroup1) {
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
				pstmt = con
						.prepareStatement(TripSummaryStatement.GET_VEHICLE_TRIP_SUMMARY);
				pstmt.setString(1, vehcileNo1);
			} else {
				pstmt = con
						.prepareStatement(TripSummaryStatement.GET_GROUP_TRIP_SUMMARY);
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
			pstmt = con
					.prepareStatement(TripSummaryStatement.GET_GROUP_NAME);
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
}
