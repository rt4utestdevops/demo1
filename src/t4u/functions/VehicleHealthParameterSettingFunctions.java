package t4u.functions;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.text.DecimalFormat;
import java.util.ArrayList;

import org.json.JSONArray;
import org.json.JSONObject;

import t4u.common.DBConnection;
import t4u.statements.CreateLandmarkStatements;
import t4u.statements.VehicleHealthParameterSettingStatements;

public class VehicleHealthParameterSettingFunctions {

	public JSONArray getVehicleModel(int systemId, int clientId) {

		JSONArray jsonArray = new JSONArray();
		JSONObject obj1 = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			con = DBConnection.getConnectionToDB("AMS");
			String query = VehicleHealthParameterSettingStatements.GET_VEHICLE_MODEL_DETAILS;
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
			System.out.println("Error in getting Vehicle Model Details:"
					+ e.toString());
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jsonArray;
	}

	public JSONArray getVehicleParameterDetails(int vehicleModelId,
			int systemId, int clientId) {

		JSONArray jsonArray = new JSONArray();
		JSONObject obj1 = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		DecimalFormat df = new DecimalFormat("##0.00");
		try {
			con = DBConnection.getConnectionToDB("AMS");
			String query = VehicleHealthParameterSettingStatements.GET_VEHICLE_PARAMETERS_DETAILS;
			pstmt = con.prepareStatement(query);
			pstmt.setInt(1, vehicleModelId);
			pstmt.setInt(2, systemId);
			pstmt.setInt(3, clientId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				obj1 = new JSONObject();
				obj1.put("parameterId", rs.getString("PARAM_ID"));
				obj1.put("parameterName", rs.getString("PARAM_NAME"));
				obj1.put("minValueRed", df.format(Float.parseFloat(rs
						.getString("MIN_VALUE_RED"))));
				obj1.put("maxValueRed", df.format(Float.parseFloat(rs
						.getString("MAX_VALUE_RED"))));
				obj1.put("minValueYellow", df.format(Float.parseFloat(rs
						.getString("MIN_VALUE_YELLOW"))));
				obj1.put("maxValueYellow", df.format(Float.parseFloat(rs
						.getString("MAX_VALUE_YELLOW"))));
				obj1.put("minValueGreen", df.format(Float.parseFloat(rs
						.getString("MIN_VALUE_GREEN"))));
				obj1.put("maxValueGreen", df.format(Float.parseFloat(rs
						.getString("MAX_VALUE_GREEN"))));
				jsonArray.put(obj1);
			}
		} catch (Exception e) {
			System.out.println("Error in getting Vehicle Parameter Details:"
					+ e.toString());
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jsonArray;
	}

	public JSONArray getParameterNames(int vehicleModelId, int systemId,
			int clientId) {

		JSONArray jsonArray = new JSONArray();
		JSONObject obj1 = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			con = DBConnection.getConnectionToDB("AMS");
			String query = VehicleHealthParameterSettingStatements.GET_VEHICLE_PARAMETERS_NAMES;
			pstmt = con.prepareStatement(query);
			pstmt.setInt(1, vehicleModelId);
			pstmt.setInt(2, systemId);
			pstmt.setInt(3, clientId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				obj1 = new JSONObject();
				obj1.put("parameterId", rs.getString("PARAM_ID"));
				obj1.put("parameterName", rs.getString("PARAM_NAME"));
				jsonArray.put(obj1);
			}
		} catch (Exception e) {
			System.out
					.println("Error in getting Vehicle Parameter Names Details:"
							+ e.toString());
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jsonArray;
	}

	public String saveVehicleHealthParameters(int modelId, int paramId,
			float minValueRed, float maxValueRed, float minValueYellow,
			float maxValueYellow, float minValueGreen, float maxValueGreen,
			int systemId, int clientId, int userId) {

		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String message = "";
		int result = 0;
		try {
			con = DBConnection.getConnectionToDB("AMS");
			String query = VehicleHealthParameterSettingStatements.SAVE_VEHICLE_PARAMETERS;
			pstmt = con.prepareStatement(query);
			pstmt.setInt(1, modelId);
			pstmt.setInt(2, paramId);
			pstmt.setFloat(3, minValueRed);
			pstmt.setFloat(4, maxValueRed);
			pstmt.setFloat(5, minValueYellow);
			pstmt.setFloat(6, maxValueYellow);
			pstmt.setFloat(7, minValueGreen);
			pstmt.setFloat(8, maxValueGreen);
			pstmt.setInt(9, systemId);
			pstmt.setInt(10, clientId);
			pstmt.setInt(11, userId);
			result = pstmt.executeUpdate();
			if (result == 1) {
				message = "Saved Successfully";
			}
		} catch (Exception e) {
			System.out.println("Error in saving Vehicle Health Parameters:"
					+ e.toString());
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return message;
	}

	// public JSONArray getAllParameterNames(int systemId, int clientId) {
	//
	// JSONArray jsonArray = new JSONArray();
	// JSONObject obj1 = null;
	// Connection con = null;
	// PreparedStatement pstmt = null;
	// ResultSet rs = null;
	// try {
	// con = DBConnection.getConnectionToDB("AMS");
	// String query =
	// VehicleHealthParameterSettingStatements.GET_ALL_VEHICLE_PARAMETERS_NAMES;
	// pstmt = con.prepareStatement(query);
	// pstmt.setInt(1, systemId);
	// pstmt.setInt(2, clientId);
	// rs = pstmt.executeQuery();
	// while (rs.next()) {
	// obj1 = new JSONObject();
	// obj1.put("parameterId", rs.getString("PARAM_ID"));
	// obj1.put("parameterName", rs.getString("PARAM_NAME"));
	// jsonArray.put(obj1);
	// }
	// } catch (Exception e) {
	// System.out.println("Error in getting Vehicle Model Details:"
	// + e.toString());
	// e.printStackTrace();
	// } finally {
	// DBConnection.releaseConnectionToDB(con, pstmt, rs);
	// }
	// return jsonArray;
	// }

	public String updateModifiedVehicleHealthParameters(int vehicleModelId,
			int paramId, float minValueRed, float maxValueRed,
			float minValueYellow, float maxValueYellow, float minValueGreen,
			float maxValueGreen, String historyData, int systemId,
			int clientId, int userId) {

		Connection con = null;
		PreparedStatement pstmt = null;
		PreparedStatement pstmt1 = null;
		String message = "";
		int result = 0;
		int resultForHistory = 0;
		float oldMinValueRed = 0;
		float oldMaxValueRed = 0;
		float oldMinValueYellow = 0;
		float oldMaxValueYellow = 0;
		float oldMinValueGreen = 0;
		float oldMaxValueGreen = 0;

		try {
			con = DBConnection.getConnectionToDB("AMS");
			historyData = historyData.replace("{", "").replace("}", "")
					.replace("[", "").replace("]", "").replace("\"", "");
			String[] historyDataArray = historyData.split(",");
			if (historyDataArray.length == 6) {
				oldMinValueRed = Float.parseFloat(historyDataArray[0]);
				oldMaxValueRed = Float.parseFloat(historyDataArray[1]);
				oldMinValueYellow = Float.parseFloat(historyDataArray[2]);
				oldMaxValueYellow = Float.parseFloat(historyDataArray[3]);
				oldMinValueGreen = Float.parseFloat(historyDataArray[4]);
				oldMaxValueGreen = Float.parseFloat(historyDataArray[5]);
			}
			String query = VehicleHealthParameterSettingStatements.INSERT_INTO_VEHICLE_PARAMETERS_HISTORY;
			pstmt = con.prepareStatement(query);
			pstmt.setInt(1, vehicleModelId);
			pstmt.setInt(2, paramId);
			pstmt.setFloat(3, oldMinValueRed);
			pstmt.setFloat(4, oldMaxValueRed);
			pstmt.setFloat(5, oldMinValueYellow);
			pstmt.setFloat(6, oldMaxValueYellow);
			pstmt.setFloat(7, oldMinValueGreen);
			pstmt.setFloat(8, oldMaxValueGreen);
			pstmt.setInt(9, systemId);
			pstmt.setInt(10, clientId);
			pstmt.setInt(11, userId);
			resultForHistory = pstmt.executeUpdate();

			String updateQuery = VehicleHealthParameterSettingStatements.UPDATE_MODIFIED_DATA_IN_VEHICLE_PARAMETERS;
			pstmt1 = con.prepareStatement(updateQuery);
			pstmt1.setFloat(1, minValueRed);
			pstmt1.setFloat(2, maxValueRed);
			pstmt1.setFloat(3, minValueYellow);
			pstmt1.setFloat(4, maxValueYellow);
			pstmt1.setFloat(5, minValueGreen);
			pstmt1.setFloat(6, maxValueGreen);
			pstmt1.setInt(7, userId);
			pstmt1.setInt(8, vehicleModelId);
			pstmt1.setInt(9, paramId);
			pstmt1.setInt(10, systemId);
			pstmt1.setInt(11, clientId);
			result = pstmt1.executeUpdate();

			if (resultForHistory == 1 && result == 1) {
				message = "Updated Successfully";
			}
		} catch (Exception e) {
			System.out.println("Error in update Vehicle Health Parameters:"
					+ e.toString());
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, null);
			DBConnection.releaseConnectionToDB(null, pstmt1, null);
		}
		return message;
	}
}
