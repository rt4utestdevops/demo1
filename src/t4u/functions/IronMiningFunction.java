package t4u.functions;

import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.PrintWriter;
import java.io.StringWriter;
import java.net.HttpURLConnection;
import java.net.URL;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Properties;
import java.util.Set;

import org.json.JSONArray;
import org.json.JSONObject;

import t4u.beans.ReportHelper;
import t4u.common.ApplicationListener;
import t4u.common.DBConnection;
import t4u.ironMining.DMFDetailsBean;
import t4u.ironMining.ImportsExportsBean;
import t4u.statements.CommonStatements;
import t4u.statements.IronMiningStatement;

public class IronMiningFunction {
	SimpleDateFormat ddMMyyyyHHmmss = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
	SimpleDateFormat ddMMyyyy = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
	SimpleDateFormat ddMMyyyyHms = new SimpleDateFormat("dd/MM/yyyy");
	CommonFunctions cf = new CommonFunctions();
	int counts = 0;
	SimpleDateFormat sdf = new SimpleDateFormat("dd-MM-yyyy");
	IronMiningFunctionsUtil util = new IronMiningFunctionsUtil();

	public JSONArray getDashboardElementsCount(int systemId, int customerId, int userId, int offset, String vehicleType,
			int isLtsp) {
		JSONArray jsonArray = null;
		JSONObject jsonObject = null;
		Connection connection = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		try {
			int totalAssetCount = 0;
			int commCount = 0;
			int nonComm = 0;
			int tripsheetIssued = 0;
			String dispachedQuantity = "";
			int tripSheetOpen = 0;
			String inTransaitQuantity = "";
			int tripSheetClosed = 0;
			String recievedQuantity = "";
			int ClosedReturnTrip = 0;
			int vehiclesmodifiedtrip = 0;
			int vehiclesextendedtrip = 0;
			DecimalFormat df = new DecimalFormat("#.###");
			jsonArray = new JSONArray();
			connection = DBConnection.getDashboardConnection("AMS");

			try {
				if (isLtsp == 0 || customerId == 0)
					pstmt = connection.prepareStatement(IronMiningStatement.GET_TOTAL_ASSET_COUNT,
							ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
				else
					pstmt = connection.prepareStatement(IronMiningStatement.GET_TOTAL_ASSET_COUNT_CLIENT,
							ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
				pstmt.setInt(1, systemId);
				pstmt.setInt(2, customerId);
				pstmt.setInt(3, userId);
				pstmt.setString(4, vehicleType);
				rs = pstmt.executeQuery();
				if (rs.next()) {
					totalAssetCount = rs.getInt("COUNT");
				}
				rs.close();
				if (isLtsp == 0 || customerId == 0)
					pstmt = connection.prepareStatement(IronMiningStatement.GET_COMMUNICATION_COUNT,
							ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
				else
					pstmt = connection.prepareStatement(IronMiningStatement.GET_COMMUNICATION_COUNT_CLIENT,
							ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
				pstmt.setInt(1, systemId);
				pstmt.setInt(2, customerId);
				pstmt.setInt(3, userId);
				pstmt.setString(4, vehicleType);
				rs = pstmt.executeQuery();
				if (rs.next()) {
					commCount = rs.getInt("COUNT");
				}
				rs.close();
				if (isLtsp == 0 || customerId == 0)
					pstmt = connection.prepareStatement(IronMiningStatement.GET_NON_COMM_COUNT,
							ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
				else
					pstmt = connection.prepareStatement(IronMiningStatement.GET_NON_COMM_COUNT_CLIENT,
							ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
				pstmt.setInt(1, systemId);
				pstmt.setInt(2, customerId);
				pstmt.setInt(3, userId);
				pstmt.setString(4, vehicleType);
				rs = pstmt.executeQuery();
				if (rs.next()) {
					nonComm = rs.getInt("COUNT");
				}
				rs.close();

				pstmt = connection.prepareStatement(IronMiningStatement.GET_IRON_DASHBOARD_TRIP_SHEET_ISSUED);
				pstmt.setString(1, vehicleType);
				pstmt.setInt(2, systemId);
				pstmt.setInt(3, customerId);
				pstmt.setInt(4, userId);
				rs = pstmt.executeQuery();
				if (rs.next()) {
					tripsheetIssued = rs.getInt("TRIP_SHEET_ISSUED");
					dispachedQuantity = df.format(rs.getFloat("DISPATCHED_QUANTITY"));
				}
				rs.close();

				pstmt = connection.prepareStatement(IronMiningStatement.GET_IRON_DASHBOARD_TRIPSHEET_OPEN);
				pstmt.setString(1, vehicleType);
				pstmt.setInt(2, systemId);
				pstmt.setInt(3, customerId);
				pstmt.setInt(4, userId);
				rs = pstmt.executeQuery();
				if (rs.next()) {
					tripSheetOpen = rs.getInt("TRIPSHEET_OPEN");
					inTransaitQuantity = df.format(rs.getFloat("IN_TRANSIT_QUANTITY"));
				}
				rs.close();

				pstmt = connection.prepareStatement(IronMiningStatement.GET_IRON_DASHBOARD_TRIP_SHEET_CLOSED);
				pstmt.setString(1, vehicleType);
				pstmt.setInt(2, systemId);
				pstmt.setInt(3, customerId);
				pstmt.setInt(4, userId);
				rs = pstmt.executeQuery();
				if (rs.next()) {
					tripSheetClosed = rs.getInt("TRIP_SHEET_CLOSED");
					recievedQuantity = df.format(rs.getFloat("RECIEVED_QUANTITY"));
				}
				rs.close();

				pstmt = connection.prepareStatement(IronMiningStatement.GET_IRON_DASHBOARD_CLOSED_RETURN_TRIP);
				pstmt.setString(1, vehicleType);
				pstmt.setInt(2, systemId);
				pstmt.setInt(3, customerId);
				pstmt.setInt(4, userId);
				rs = pstmt.executeQuery();
				if (rs.next()) {
					ClosedReturnTrip = rs.getInt("CLOSED_RETURN_TRIP");
				}
				rs.close();

				pstmt = connection
						.prepareStatement(IronMiningStatement.GET_IRON_DASHBOARD_VECHICLES_WITH_EXTENDED_TRIPS);
				pstmt.setString(1, vehicleType);
				pstmt.setInt(2, systemId);
				pstmt.setInt(3, customerId);
				pstmt.setInt(4, userId);
				rs = pstmt.executeQuery();
				if (rs.next()) {
					vehiclesextendedtrip = rs.getInt("VECHICLES_WITH_EXTENDED_TRIPS");
				}
				rs.close();

				pstmt = connection
						.prepareStatement(IronMiningStatement.GET_IRON_DASHBOARD_VECHICLES_WITH_MODIFIED_TRIPS);
				pstmt.setString(1, vehicleType);
				pstmt.setInt(2, systemId);
				pstmt.setInt(3, customerId);
				pstmt.setInt(4, userId);
				rs = pstmt.executeQuery();
				if (rs.next()) {
					vehiclesmodifiedtrip = rs.getInt("VECHICLES_WITH_MODIFIED_TRIPS");
				}
				rs.close();

			} catch (Exception e) {
				e.printStackTrace();
			}

			jsonObject = new JSONObject();
			jsonObject.put("totalAssetCount", totalAssetCount);
			jsonObject.put("tripsheetIssued", tripsheetIssued);
			jsonObject.put("dispachedQuantity", dispachedQuantity);
			jsonObject.put("commCount", commCount);
			jsonObject.put("tripSheetOpen", tripSheetOpen);
			jsonObject.put("inTransaitQuantity", inTransaitQuantity);
			jsonObject.put("nonComm", nonComm);
			jsonObject.put("tripSheetClosed", tripSheetClosed);
			jsonObject.put("recievedQuantity", recievedQuantity);
			jsonObject.put("ClosedReturnTrip", ClosedReturnTrip);
			jsonObject.put("vehiclesmodifiedtrip", vehiclesmodifiedtrip);
			jsonObject.put("vehiclesextendedtrip", vehiclesextendedtrip);
			jsonArray.put(jsonObject);

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(connection, pstmt, rs);
		}
		return jsonArray;

	}

	public JSONArray getWeeklyRevenue(int customerId, String vehicleType, int systemId, int offmin) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		DecimalFormat df = new DecimalFormat("#.###");
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject = new JSONObject();
		try {
			con = DBConnection.getConnectionToDB("AMS");

			pstmt = con.prepareStatement(IronMiningStatement.GET_QUANTITY_FOR_DASHBOARD_CHART);
			pstmt.setString(1, vehicleType);
			pstmt.setInt(2, customerId);
			pstmt.setInt(3, systemId);
			pstmt.setString(4, vehicleType);
			pstmt.setInt(5, customerId);
			pstmt.setInt(6, systemId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				switch (rs.getInt(1)) {
				case 1:
					jsonObject.put("sunrevenueIndex", df.format(rs.getFloat("QUANTITY")));
					break;
				case 2:
					jsonObject.put("monrevenueIndex", df.format(rs.getFloat("QUANTITY")));
					break;
				case 3:
					jsonObject.put("tuerevenueIndex", df.format(rs.getFloat("QUANTITY")));
					break;
				case 4:
					jsonObject.put("wedrevenueIndex", df.format(rs.getFloat("QUANTITY")));
					break;
				case 5:
					jsonObject.put("thurevenueIndex", df.format(rs.getFloat("QUANTITY")));
					break;
				case 6:
					jsonObject.put("frirevenueIndex", df.format(rs.getFloat("QUANTITY")));
					break;
				case 7:
					jsonObject.put("satrevenueIndex", df.format(rs.getFloat("QUANTITY")));
					break;
				}

			}
			jsonArray.put(jsonObject);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jsonArray;
	}

	public JSONArray getWeeklyPermit(int customerId, String vehicleType, int systemId, int offmin) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject = new JSONObject();
		try {
			con = DBConnection.getConnectionToDB("AMS");

			pstmt = con.prepareStatement(IronMiningStatement.GET_PERMIT_FOR_DASHBOARD_CHART);
			pstmt.setString(1, vehicleType);
			pstmt.setInt(2, customerId);
			pstmt.setInt(3, systemId);
			pstmt.setString(4, vehicleType);
			pstmt.setInt(5, customerId);
			pstmt.setInt(6, systemId);
			rs = pstmt.executeQuery();
			while (rs.next()) {

				switch (rs.getInt(1)) {
				case 1:
					jsonObject.put("sunpermitIndex", rs.getString("TRIP_SHEET_ISSUED"));
					break;
				case 2:
					jsonObject.put("monpermitIndex", rs.getString("TRIP_SHEET_ISSUED"));
					break;
				case 3:
					jsonObject.put("tuepermitIndex", rs.getString("TRIP_SHEET_ISSUED"));
					break;
				case 4:
					jsonObject.put("wedpermitIndex", rs.getString("TRIP_SHEET_ISSUED"));
					break;
				case 5:
					jsonObject.put("thupermitIndex", rs.getString("TRIP_SHEET_ISSUED"));
					break;
				case 6:
					jsonObject.put("fripermitIndex", rs.getString("TRIP_SHEET_ISSUED"));
					break;
				case 7:
					jsonObject.put("satpermitIndex", rs.getString("TRIP_SHEET_ISSUED"));
					break;
				}

			}
			jsonArray.put(jsonObject);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jsonArray;
	}

	//--------------------Added for HubOperationalWindow 1.GRID-----------------------------//

	public JSONArray getMiningSettingTypes(int clientId, int systemId, String hubOpID, String zone) {
		JSONArray jList = new JSONArray();
		Connection con = null;
		PreparedStatement pstmt = null, pstmt1 = null;
		ResultSet rs = null, rs1 = null;
		String query = "";

		try {

			con = DBConnection.getConnectionToDB("AMS");

			if (hubOpID.equalsIgnoreCase("All")) {
				query = IronMiningStatement.GET_MINING_SETTING_TYPES.replaceAll("LOCATION ",
						"LOCATION_ZONE_" + zone + " ");
				pstmt = con.prepareStatement(query);
				pstmt.setInt(1, clientId);
				pstmt.setInt(2, systemId);
			} else {
				query = IronMiningStatement.GET_MINING_SETTING_TYPES1.replaceAll("LOCATION ",
						"LOCATION_ZONE_" + zone + " ");
				pstmt = con.prepareStatement(query);
				pstmt.setInt(1, clientId);
				pstmt.setInt(2, systemId);
				pstmt.setString(3, hubOpID);
			}

			rs = pstmt.executeQuery();

			while (rs.next()) {
				int locationID = rs.getInt("LOCATION_ID");
				pstmt1 = con.prepareStatement(IronMiningStatement.GET_VEHICLE_COUNT);
				pstmt1.setInt(1, locationID);
				pstmt1.setInt(2, systemId);
				pstmt1.setInt(3, clientId);
				rs1 = pstmt1.executeQuery();
				JSONObject obj = new JSONObject();
				obj.put("slnoIndex", rs.getString("TYPE_ID").trim());
				obj.put("operationTypeIndex", rs.getString("TYPE_DESCRIPTION").trim());
				obj.put("hubDataIndex", rs.getString("PLACE_NAME").trim());
				obj.put("placeDataIndex", rs.getString("NAME").trim());
				obj.put("ID", rs.getInt("LOCATION_ID"));
				while (rs1.next()) {
					obj.put("vehicleDataIndex", rs1.getInt("Vehicle_Count"));
				}
				jList.put(obj);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
			DBConnection.releaseConnectionToDB(null, pstmt1, rs1);
		}
		return jList;
	}

	//-----------------------------------------2.ADD/MODIFY-------------------------------------------------//

	public String addModifyHubOperation(int clientID, int systemID, String buttonValue, String nameID, String hubOpID,
			String selectdName, String placeName, String zone, String typeID) {
		String msg = "", query = "";
		int count = 0;
		Connection connection = null;
		PreparedStatement pstmt = null, pstmt1 = null;
		ResultSet rs = null;
		boolean isNumber = false;
		try {
			connection = DBConnection.getConnectionToDB("AMS");
			if (buttonValue != null && buttonValue != "" && buttonValue.equalsIgnoreCase("Add")) {
				pstmt1 = connection.prepareStatement(IronMiningStatement.SAVE_MINING_TYPE);
				pstmt1.setString(1, hubOpID);
				pstmt1.setString(2, nameID);
				pstmt1.setInt(3, clientID);
				pstmt1.setInt(4, systemID);
				pstmt1.setString(5, placeName);
				count = pstmt1.executeUpdate();

				if (count > 0) {
					msg = "Saved Successfully.";
				} else
					msg = "Error While Saving";
			} else if (buttonValue != null && buttonValue != "" && buttonValue.equalsIgnoreCase("Modify")) {
				if (nameID != null && nameID != "")
					isNumber = isNumber(nameID);
				if (isNumber != true) {
					nameID = nameID + "%";
					{
						query = "select HUBID from dbo.LOCATION_ZONE_" + zone + " where NAME like '" + nameID + "' and "
								+ "SYSTEMID=" + systemID + " AND CLIENTID=" + clientID + " ";
						pstmt = connection.prepareStatement(query);
						rs = pstmt.executeQuery();
						while (rs.next()) {
							nameID = rs.getString("HUBID");
						}
					}
				}
				pstmt1 = connection.prepareStatement(IronMiningStatement.UPDATE_MINING_TYPE);
				pstmt1.setString(1, nameID);
				pstmt1.setString(2, placeName);
				pstmt1.setString(3, hubOpID);
				pstmt1.setString(4, selectdName);
				pstmt1.setInt(5, clientID);
				pstmt1.setInt(6, systemID);
				pstmt1.setString(7, typeID);
				count = pstmt1.executeUpdate();

				if (count > 0) {
					msg = "Updated Successfully.";
				} else
					msg = "Error While Updating";
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(connection, pstmt, rs);
			DBConnection.releaseConnectionToDB(null, pstmt1, null);
		}
		return msg;
	}

	//------------------------------------------3.HUB NAMES--------------------------------------//

	public JSONArray getPlaceNames(int clientId, int systemId, String hubOpID, String zone) {
		String locationIDs = "";
		JSONArray placeList = new JSONArray();
		Connection connection = null;
		String query = "";
		PreparedStatement pstmt = null, pstmt1 = null;
		ResultSet rs = null, rs1 = null;
		try {
			connection = DBConnection.getConnectionToDB("AMS");

			pstmt1 = connection.prepareStatement(IronMiningStatement.EXISTING_LOCATIONS_ID);
			pstmt1.setInt(1, systemId);
			pstmt1.setInt(2, clientId);
			rs1 = pstmt1.executeQuery();
			while (rs1.next()) {
				locationIDs = locationIDs + rs1.getString("LOCATION_ID") + ",";
			}

			if (locationIDs != null && locationIDs != "") {
				locationIDs = locationIDs.substring(0, locationIDs.length() - 1);

				query = IronMiningStatement.HUB_NAMES.replaceAll("LOCATION ", "LOCATION_ZONE_" + zone + " ") + "("
						+ locationIDs + ") ORDER BY NAME";
				pstmt = connection.prepareStatement(query);
				pstmt.setInt(1, systemId);
				pstmt.setInt(2, clientId);
			} else {
				query = IronMiningStatement.HUB_NAMES1.replaceAll("LOCATION ", "LOCATION_ZONE_" + zone + " ");
				pstmt = connection.prepareStatement(query);
				pstmt.setInt(1, systemId);
				pstmt.setInt(2, clientId);
			}
			rs = pstmt.executeQuery();

			while (rs.next()) {
				JSONObject obj = new JSONObject();
				obj.put("PlaceId", rs.getString("HUBID"));
				obj.put("PlaceName", rs.getString("NAME"));
				placeList.put(obj);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(connection, pstmt, rs);
			DBConnection.releaseConnectionToDB(null, pstmt1, rs1);
		}
		return placeList;

	}

	//-----------------------------------------4.DELETE---------------------------------------------//

	public String deleteHubDetails(int clientId, int systemId, String locID, String typeID) {
		int count = 0;
		Connection connection = null;
		String msg = "";
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {

			connection = DBConnection.getConnectionToDB("AMS");
			if (locID != null && typeID != null) {
				pstmt = connection.prepareStatement(IronMiningStatement.DELETE_MINING_TYPE);
				pstmt.setInt(1, clientId);
				pstmt.setInt(2, systemId);
				pstmt.setString(3, locID);
				pstmt.setString(4, typeID);
				count = pstmt.executeUpdate();
			}
			if (count > 0) {
				msg = "Successfully Deleted.";
			} else
				msg = "Error in Deleting.";
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(connection, pstmt, rs);
		}
		return msg;

	}

	//------------------------------------5.DETAILS---------------------------------------//

	public JSONArray getDetails(int clientId, int systemId, String hubOpID, String NameID, int offset, String zone) {
		JSONArray jList = new JSONArray();
		Connection connection = null;
		PreparedStatement pstmt = null, pstmt1 = null;
		ResultSet rs = null, rs1 = null;
		SimpleDateFormat sdf_from = new SimpleDateFormat("yyyy-MM-dd HH:mm");
		SimpleDateFormat sdfyyyymmddhhmmss = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
		NameID = NameID + "%";
		Date dt = new Date();
		int placeNameID = 0;

		try {
			connection = DBConnection.getConnectionToDB("AMS");
			if (NameID != null && NameID != "") {
				String query1 = "select HUBID from dbo.LOCATION_ZONE_" + zone + " where NAME like '" + NameID
						+ "' and SYSTEMID=" + systemId + " AND CLIENTID=" + clientId + " ";
				pstmt1 = connection.prepareStatement(query1);
				rs1 = pstmt1.executeQuery();
				while (rs1.next()) {
					placeNameID = rs1.getInt("HUBID");

				}
			}
			pstmt = connection.prepareStatement(IronMiningStatement.GET_VEHICLE_DETAILS);
			pstmt.setInt(1, offset);
			pstmt.setInt(2, placeNameID);
			pstmt.setInt(3, systemId);
			pstmt.setInt(4, clientId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				if (rs.getString("REGISTRATION_NO") != null && rs.getString("REGISTRATION_NO").trim().length() > 0) {
					Date arrivalDateTime = sdf_from.parse(rs.getString("HUB_TIME").trim());
					double milli = dt.getTime() - arrivalDateTime.getTime();
					int hrs = (int) (milli / (1000 * 60 * 60));
					milli = milli - (hrs * 60 * 60 * 1000);
					int mins = (int) (milli / (1000 * 60));

					JSONObject obj = new JSONObject();

					obj.put("registrationNoIndex", rs.getString("REGISTRATION_NO").trim());
					obj.put("detentionIndex", hrs + ":" + mins);
					if (rs.getString("HUB_TIME") != null) {
						dt = rs.getTimestamp("HUB_TIME");
						obj.put("actualArrivalIndex", sdfyyyymmddhhmmss.format(dt));
					} else
						obj.put("actualArrivalIndex", "");
					if (rs.getString("GPS_DATETIME") != null) {
						dt = rs.getTimestamp("GPS_DATETIME");
						obj.put("lastCommunicatedIndex", sdfyyyymmddhhmmss.format(dt));
					} else
						obj.put("lastCommunicatedIndex", "");
					jList.put(obj);
				}
			}

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(connection, pstmt, rs);
			DBConnection.releaseConnectionToDB(null, pstmt1, rs1);
		}
		return jList;
	}

	public boolean isNumber(String string) {
		try {
			Integer.parseInt(string);
		} catch (Exception e) {
			return false;
		}
		return true;
	}

	//--------------------------------------TripsheetReport----------------------------------------------//
	public JSONArray getAssetNumberDetails(int systemId, int customerId, int userId, String groupId) {
		JSONArray JsonArray = null;
		JSONObject JsonObject = null;

		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		int count = 0;

		try {
			JsonArray = new JSONArray();

			con = DBConnection.getConnectionToDB("AMS");

			pstmt = con.prepareStatement(IronMiningStatement.GET_ASSET_NUMBER);
			pstmt.setInt(1, customerId);
			pstmt.setInt(2, systemId);
			pstmt.setInt(3, userId);
			pstmt.setString(4, groupId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				count++;

				JsonObject = new JSONObject();

				JsonObject.put("slnoIndex", count);
				//  JsonObject.put("AssetType", rs.getString("ModelName"));
				JsonObject.put("assetnumber", rs.getString("REGISTRATION_NUMBER"));

				JsonArray.put(JsonObject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return JsonArray;
	}

	public JSONArray getGroupNameList(int systemId, int clientId, int userId) {
		JSONArray JsonArray = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			JsonArray = new JSONArray();
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(IronMiningStatement.SELECT_GROUP_LIST_FOR_ASSET);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, clientId);
			pstmt.setInt(3, userId);
			rs = pstmt.executeQuery();
			JSONObject jsonObject = new JSONObject();
			jsonObject.put("groupId", "0");
			jsonObject.put("groupName", "ALL");
			JsonArray.put(jsonObject);
			while (rs.next()) {
				jsonObject = new JSONObject();
				jsonObject.put("groupId", rs.getString("GROUP_ID"));
				jsonObject.put("groupName", rs.getString("GROUP_NAME"));
				JsonArray.put(jsonObject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return JsonArray;
	}

	public JSONArray getAssetTypeDetails(int systemId, int customerId, int userId, String groupId) {
		JSONArray JsonArray = null;
		JSONObject JsonObject = null;

		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		int count = 0;

		try {
			JsonArray = new JSONArray();

			con = DBConnection.getConnectionToDB("AMS");
			if (groupId.equals("0")) {
				pstmt = con.prepareStatement(IronMiningStatement.GET_ASSET_TYPE_ALL);
				pstmt.setInt(1, customerId);
				pstmt.setInt(2, systemId);
				pstmt.setInt(3, userId);
			} else {
				pstmt = con.prepareStatement(IronMiningStatement.GET_ASSET_TYPE);
				pstmt.setInt(1, customerId);
				pstmt.setInt(2, systemId);
				pstmt.setInt(3, userId);
				pstmt.setString(4, groupId);
			}

			rs = pstmt.executeQuery();
			while (rs.next()) {
				count++;
				JsonObject = new JSONObject();
				JsonObject.put("AssetType", rs.getString("VehicleType"));
				JsonArray.put(JsonObject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return JsonArray;
	}

	@SuppressWarnings("unchecked")
	public ArrayList getTripSheetReportDetails(JSONArray firstGridData, int systemId, int CustomerId, int userId,
			String assettype, String startDate, String endDate, String vehicleValue, String language, String groupId) {
		CommonFunctions cf = new CommonFunctions();
		JSONArray JsonArray = new JSONArray();
		JSONObject JsonObject = null;
		Connection con = null;
		PreparedStatement pstmt2 = null;
		ResultSet rs2 = null;
		//String sql="";
		int slcount = 0;
		ArrayList<ReportHelper> reportsList = new ArrayList<ReportHelper>();
		ArrayList<String> headersList = new ArrayList<String>();
		ReportHelper finalreporthelper = new ReportHelper();
		ArrayList aslist = new ArrayList();
		SimpleDateFormat yyyyMMddHHmmss = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");

		headersList.add(cf.getLabelFromDB("SLNO", language));
		headersList.add(cf.getLabelFromDB("Trip_Sheet_No", language));
		headersList.add(cf.getLabelFromDB("Trip_Issued_Date_And_Time", language));
		headersList.add(cf.getLabelFromDB("Trip_Close_Date_And_Time", language));
		headersList.add(cf.getLabelFromDB("Trip_Sheet_Status", language));
		headersList.add(cf.getLabelFromDB("TC_No", language));
		headersList.add(cf.getLabelFromDB("Asset_Number", language));
		headersList.add(cf.getLabelFromDB("Asset_Type", language));
		if (groupId.equals("0")) {
			headersList.add(cf.getLabelFromDB("Asset_Group", language));
		} else {
			headersList.add("");
		}
		headersList.add(cf.getLabelFromDB("Driver_Name", language));
		headersList.add(cf.getLabelFromDB("Start_Location", language));
		headersList.add(cf.getLabelFromDB("Quantity_At_Source(Ton)", language));
		headersList.add(cf.getLabelFromDB("Quantity_At_Destination(Ton)", language));
		headersList.add(cf.getLabelFromDB("Route_Id", language));
		headersList.add(cf.getLabelFromDB("Destination", language));
		headersList.add(cf.getLabelFromDB("Mining_Type", language));
		headersList.add(cf.getLabelFromDB("Communication_Status", language));
		headersList.add(cf.getLabelFromDB("Remarks", language));

		try {
			con = DBConnection.getConnectionToDB("AMS");
			if (startDate.contains("T")) {
				startDate = startDate.substring(0, startDate.indexOf("T"));
				startDate = startDate + " 00:00:00";
			} else {
				startDate = startDate.substring(0, startDate.indexOf(" "));
				startDate = startDate + " 00:00:00";
			}

			if (endDate.contains("T")) {
				endDate = endDate.substring(0, endDate.indexOf("T"));
				endDate = endDate + " 00:00:00";
			} else {
				endDate = endDate.substring(0, endDate.indexOf(" "));
				endDate = endDate + " 00:00:00";
			}

			String assetnos = "";
			for (int i = 0; i < firstGridData.length(); i++) {
				JSONObject obj = firstGridData.getJSONObject(i);
				assetnos = assetnos + ",'" + obj.getString("assetnumber") + "'";
			}
			if (assetnos.length() > 0) {
				assetnos = assetnos.substring(1, assetnos.length());
			}

			if (vehicleValue.equals("0")) {
				if (groupId.equals("0")) {
					pstmt2 = con.prepareStatement(IronMiningStatement.GET_TRIP_SHEET_REPORT_DETAILS_FOR_ALL);
					pstmt2.setString(1, startDate);
					pstmt2.setString(2, endDate);
					pstmt2.setInt(3, systemId);
					pstmt2.setString(4, startDate);
					pstmt2.setString(5, endDate);
					pstmt2.setInt(6, systemId);
				} else {
					pstmt2 = con.prepareStatement(IronMiningStatement.GET_TRIP_SHEET_REPORT_DETAILS_FOR_ALL_GROUPID);
					pstmt2.setString(1, startDate);
					pstmt2.setString(2, endDate);
					pstmt2.setInt(3, CustomerId);
					pstmt2.setInt(4, systemId);
					pstmt2.setString(5, groupId);
					pstmt2.setInt(6, userId);
					pstmt2.setString(7, startDate);
					pstmt2.setString(8, endDate);
					pstmt2.setInt(9, CustomerId);
					pstmt2.setInt(10, systemId);
					pstmt2.setString(11, groupId);
					pstmt2.setInt(12, userId);
				}
			} else {
				pstmt2 = con.prepareStatement(
						IronMiningStatement.GET_TRIP_SHEET_REPORT_DETAILS_FOR_EACH_VEHICLE.replace("#", assetnos));
				pstmt2.setString(1, startDate);
				pstmt2.setString(2, endDate);
				pstmt2.setInt(3, CustomerId);
				pstmt2.setInt(4, systemId);
				pstmt2.setString(5, startDate);
				pstmt2.setString(6, endDate);
				pstmt2.setInt(7, CustomerId);
				pstmt2.setInt(8, systemId);
			}
			rs2 = pstmt2.executeQuery();

			while (rs2.next()) {
				JsonObject = new JSONObject();
				ArrayList<Object> informationList = new ArrayList<Object>();
				ReportHelper reporthelper = new ReportHelper();
				slcount++;
				JsonObject.put("SLNODataIndex", slcount);
				informationList.add(slcount);

				informationList.add(rs2.getString("Trip_Sheet_No").toUpperCase());
				JsonObject.put("TripSheetNoDataIndex", rs2.getString("Trip_Sheet_No").toUpperCase());

				if (yyyyMMddHHmmss.format(rs2.getTimestamp("Trip_Issued_DateAndTime")) != null) {
					informationList.add(ddMMyyyyHHmmss.format(rs2.getTimestamp("Trip_Issued_DateAndTime")));
					JsonObject.put("TripIssuedDateAndTimeDataIndex",
							yyyyMMddHHmmss.format(rs2.getTimestamp("Trip_Issued_DateAndTime")));
				} else {
					informationList.add("");
					JsonObject.put("TripIssuedDateAndTimeDataIndex", "");
				}

				if (yyyyMMddHHmmss.format(rs2.getTimestamp("Trip_Closed_DateAndTime")) != null) {
					informationList.add(ddMMyyyyHHmmss.format(rs2.getTimestamp("Trip_Closed_DateAndTime")));
					JsonObject.put("TripCloseDateAndTimeDataIndex",
							yyyyMMddHHmmss.format(rs2.getTimestamp("Trip_Closed_DateAndTime")));
				} else {
					informationList.add("");
					JsonObject.put("TripCloseDateAndTimeDataIndex", "");
				}
				informationList.add(rs2.getString("Trip_Sheet_Status").toUpperCase());
				JsonObject.put("TripSheetStatusDataIndex", rs2.getString("Trip_Sheet_Status").toUpperCase());

				informationList.add(rs2.getString("TC_NO"));
				JsonObject.put("TCNoDataIndex", rs2.getString("TC_NO"));

				informationList.add(rs2.getString("ASSET_NUMBER"));
				JsonObject.put("AssetNoDataIndex", rs2.getString("ASSET_NUMBER"));

				informationList.add(rs2.getString("Asset_Type"));
				JsonObject.put("AssetTypeDataIndex", rs2.getString("Asset_Type"));

				if (groupId.equals("0")) {
					informationList.add(rs2.getString("Group_Name"));
					JsonObject.put("GroupNameDataIndex", rs2.getString("Group_Name"));
				} else {
					informationList.add("");
					JsonObject.put("GroupNameDataIndex", "");
				}

				informationList.add(rs2.getString("DRIVER_NAME").toUpperCase());
				JsonObject.put("DriverNameDataIndex", rs2.getString("DRIVER_NAME").toUpperCase());

				informationList.add(rs2.getString("START_LOCATION").toUpperCase());
				JsonObject.put("StartLocationDataIndex", rs2.getString("START_LOCATION").toUpperCase());

				informationList.add(rs2.getString("Quantity_At_Source"));
				JsonObject.put("QuantityAtSourceDataIndex", rs2.getString("Quantity_At_Source"));

				informationList.add(rs2.getString("Quantity_At_Destination"));
				JsonObject.put("QuantityAtDestinationDataIndex", rs2.getString("Quantity_At_Destination"));

				informationList.add(rs2.getString("ROUTE_ID"));
				JsonObject.put("RouteIdDataIndex", rs2.getString("ROUTE_ID"));

				informationList.add(rs2.getString("Destination").toUpperCase());
				JsonObject.put("DestinationDataIndex", rs2.getString("Destination").toUpperCase());

				informationList.add(rs2.getString("Mining_Type").toUpperCase());
				JsonObject.put("MiningTypeDataIndex", rs2.getString("Mining_Type").toUpperCase());

				informationList.add(rs2.getString("COMMUNICATION_STATUS").toUpperCase());
				JsonObject.put("CommunicationStatusIndex", rs2.getString("COMMUNICATION_STATUS").toUpperCase());

				informationList.add(rs2.getString("REMARKS").toUpperCase());
				JsonObject.put("RemarksDataIndex", rs2.getString("REMARKS").toUpperCase());

				JsonArray.put(JsonObject);
				reporthelper.setInformationList(informationList);
				reportsList.add(reporthelper);
			}
			aslist.add(JsonArray);
			finalreporthelper.setReportsList(reportsList);
			finalreporthelper.setHeadersList(headersList);
			aslist.add(finalreporthelper);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {

			DBConnection.releaseConnectionToDB(con, pstmt2, rs2);
		}
		return aslist;
	}

	//--------------------------------------------------------MINING OVERSPEED REPORT--------------------------------------------------------------------------------//
	@SuppressWarnings("unchecked")
	public ArrayList getMiningOverSpeedReportDetails(int systemId, int CustomerId, int userId, String startDate,
			String endDate, String language, String groupId, int offset) {

		JSONArray JsonArray = new JSONArray();
		JSONObject JsonObject = null;
		Connection con = null;
		PreparedStatement pstmt2 = null;
		ResultSet rs2 = null;
		//String sql="";
		int slcount = 0;
		ArrayList<ReportHelper> reportsLists = new ArrayList<ReportHelper>();
		ArrayList<String> headersLists = new ArrayList<String>();
		ReportHelper finalreporthelper = new ReportHelper();
		ArrayList aslist = new ArrayList();
		SimpleDateFormat yyyyMMddHHmmss = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");

		headersLists.add(cf.getLabelFromDB("SLNO", language));
		headersLists.add(cf.getLabelFromDB("Asset_Number", language));
		if (groupId.equals("0")) {
			headersLists.add(cf.getLabelFromDB("Asset_Group", language));
		} else {
			headersLists.add("");
		}
		headersLists.add(cf.getLabelFromDB("Date", language));
		headersLists.add(cf.getLabelFromDB("GPS_DATE_TIME", language));
		headersLists.add(cf.getLabelFromDB("GMT", language));
		headersLists.add(cf.getLabelFromDB("Latitude", language));
		headersLists.add(cf.getLabelFromDB("Longitude", language));
		headersLists.add(cf.getLabelFromDB("Location", language));
		headersLists.add(cf.getLabelFromDB("Trip_Sheet_No", language));
		headersLists.add(cf.getLabelFromDB("Speed", language));
		headersLists.add(cf.getLabelFromDB("OS_LIMIT", language));

		try {
			con = DBConnection.getConnectionToDB("AMS");
			if (startDate.contains("T")) {
				startDate = startDate.substring(0, startDate.indexOf("T"));
				startDate = startDate + " 00:00:00";
			} else {
				startDate = startDate.substring(0, startDate.indexOf(" "));
				startDate = startDate + " 00:00:00";
			}

			if (endDate.contains("T")) {
				endDate = endDate.substring(0, endDate.indexOf("T"));
				endDate = endDate + " 00:00:00";
			} else {
				endDate = endDate.substring(0, endDate.indexOf(" "));
				endDate = endDate + " 00:00:00";
			}

			if (groupId.equals("0")) {
				pstmt2 = con.prepareStatement(IronMiningStatement.GET_MINING_OVERSPEED_REPORT_DETAILS_FOR_ALL);
				pstmt2.setInt(1, offset);
				pstmt2.setInt(2, offset);
				pstmt2.setString(3, startDate);
				pstmt2.setInt(4, offset);
				pstmt2.setString(5, endDate);
				pstmt2.setInt(6, systemId);
				pstmt2.setInt(7, userId);
			} else {
				pstmt2 = con.prepareStatement(IronMiningStatement.GET_MINING_OVERSPEED_REPORT_DETAILS_FOR_ALL_GROUPID);
				pstmt2.setInt(1, offset);
				pstmt2.setInt(2, offset);
				pstmt2.setString(3, startDate);
				pstmt2.setInt(4, offset);
				pstmt2.setString(5, endDate);
				pstmt2.setInt(6, systemId);
				pstmt2.setInt(7, CustomerId);
				pstmt2.setString(8, groupId);
				pstmt2.setInt(9, userId);
			}

			rs2 = pstmt2.executeQuery();

			while (rs2.next()) {
				JsonObject = new JSONObject();
				ArrayList<Object> informationList = new ArrayList<Object>();
				ReportHelper reporthelper = new ReportHelper();
				slcount++;
				JsonObject.put("SLNODataIndex", slcount);
				informationList.add(slcount);

				informationList.add(rs2.getString("Asset_No").toUpperCase());
				JsonObject.put("AssetNoDataIndex", rs2.getString("Asset_No").toUpperCase());

				if (groupId.equals("0")) {
					informationList.add(rs2.getString("Group_Name"));
					JsonObject.put("GroupNameDataIndex", rs2.getString("Group_Name"));
				} else {
					informationList.add("");
					JsonObject.put("GroupNameDataIndex", "");
				}

				if (yyyyMMddHHmmss.format(rs2.getTimestamp("DATE")) != null) {
					informationList.add(ddMMyyyyHHmmss.format(rs2.getTimestamp("DATE")));
					JsonObject.put("DateAndTimeDataIndex", yyyyMMddHHmmss.format(rs2.getTimestamp("DATE")));
				} else {
					informationList.add("");
					JsonObject.put("DateAndTimeDataIndex", "");
				}

				if (yyyyMMddHHmmss.format(rs2.getTimestamp("GPS_DATETIME")) != null) {
					informationList.add(ddMMyyyyHHmmss.format(rs2.getTimestamp("GPS_DATETIME")));
					JsonObject.put("GpsDateAndTimeDataIndex", yyyyMMddHHmmss.format(rs2.getTimestamp("GPS_DATETIME")));
				} else {
					informationList.add("");
					JsonObject.put("GpsDateAndTimeDataIndex", "");
				}

				if (yyyyMMddHHmmss.format(rs2.getTimestamp("GMT")) != null) {
					informationList.add(ddMMyyyyHHmmss.format(rs2.getTimestamp("GMT")));
					JsonObject.put("GmtDateAndTimeDataIndex", yyyyMMddHHmmss.format(rs2.getTimestamp("GMT")));
				} else {
					informationList.add("");
					JsonObject.put("GmtDateAndTimeDataIndex", "");
				}

				informationList.add(rs2.getString("LATITUDE").toUpperCase());
				JsonObject.put("latitudeDataIndex", rs2.getString("LATITUDE").toUpperCase());

				informationList.add(rs2.getString("LONGITUDE"));
				JsonObject.put("longitudeDataIndex", rs2.getString("LONGITUDE"));

				informationList.add(rs2.getString("LOCATION").toUpperCase());
				JsonObject.put("LocationDataIndex", rs2.getString("LOCATION").toUpperCase());

				if (rs2.getString("TRIP_NUMBER").equals("")) {
					informationList.add("NA");
					JsonObject.put("tripSheetNoDataIndex", "NA");
				} else {
					informationList.add(rs2.getString("TRIP_NUMBER"));
					JsonObject.put("tripSheetNoDataIndex", rs2.getString("TRIP_NUMBER"));
				}
				informationList.add(rs2.getString("SPEED"));
				JsonObject.put("speedDataIndex", rs2.getString("SPEED"));

				informationList.add(rs2.getString("OS_LIMIT"));
				JsonObject.put("osLimitDataIndex", rs2.getString("OS_LIMIT"));

				JsonArray.put(JsonObject);
				reporthelper.setInformationList(informationList);
				reportsLists.add(reporthelper);
			}
			aslist.add(JsonArray);
			finalreporthelper.setReportsList(reportsLists);
			finalreporthelper.setHeadersList(headersLists);
			aslist.add(finalreporthelper);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {

			DBConnection.releaseConnectionToDB(con, pstmt2, rs2);
		}
		return aslist;
	}

	//----------------------------------------MINING ASSET ENROLLMENT REPORT------------------------------------//
	@SuppressWarnings("unchecked")
	public ArrayList getAssetEnrollmentDetails(String customerName, int systemId, int CustomerId, int userId,
			String language) {
		JSONArray JsonArray = new JSONArray();
		JSONObject JsonObject = null;
		Connection con = null;
		PreparedStatement pstmt52 = null;
		ResultSet rs52 = null;
		int aslcount = 0;
		ArrayList assetList = new ArrayList();
		ArrayList<ReportHelper> reportsList = new ArrayList<ReportHelper>();
		ArrayList<String> headersList = new ArrayList<String>();
		ReportHelper finalreporthelper = new ReportHelper();

		headersList.add(cf.getLabelFromDB("SLNO", language));
		headersList.add(cf.getLabelFromDB("Enrollment_Number", language));
		headersList.add(cf.getLabelFromDB("Enrollment_Date", language));
		headersList.add(cf.getLabelFromDB("Asset_Number", language));
		headersList.add(cf.getLabelFromDB("Registration_Date", language));
		headersList.add("Engine Number");
		headersList.add(cf.getLabelFromDB("Carriage_Capacity", language));
		headersList.add(cf.getLabelFromDB("Owner_Name", language));
		headersList.add(cf.getLabelFromDB("Assembly_Constituency", language));
		headersList.add(cf.getLabelFromDB("District", language));
		headersList.add(cf.getLabelFromDB("State", language));
		headersList.add(cf.getLabelFromDB("Challan_Number", language));
		headersList.add(cf.getLabelFromDB("Challen_Date", language));
		headersList.add(cf.getLabelFromDB("Bank_Transaction_Number", language));
		headersList.add(cf.getLabelFromDB("Amount_Paid", language));
		headersList.add(cf.getLabelFromDB("Validity_Date", language));
		headersList.add(cf.getLabelFromDB("Acknowledge_By", language));
		headersList.add(cf.getLabelFromDB("District_Name", language));
		headersList.add(cf.getLabelFromDB("State_Name", language));
		headersList.add("InsurancePolicyNo");
		headersList.add("InsuranceExpiryDate");
		headersList.add("PucNumber");
		headersList.add("PucExpiryDate");
		headersList.add("Road Tax Validity Date");
		headersList.add("Permit Validity Date");
		headersList.add("Status");
		headersList.add("Reason For Inactive");

		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt52 = con.prepareStatement(IronMiningStatement.GET_MINING_ASSET_ENROLLMENT_DETAILS);
			pstmt52.setInt(1, systemId);
			pstmt52.setInt(2, CustomerId);
			rs52 = pstmt52.executeQuery();
			while (rs52.next()) {
				JsonObject = new JSONObject();
				ArrayList<Object> informationList = new ArrayList<Object>();
				ReportHelper reporthelper = new ReportHelper();
				aslcount++;
				JsonObject.put("slnoIndex", aslcount);
				informationList.add(aslcount);

				JsonObject.put("EnrollmentNumberIndex", rs52.getString("ENROLLMENT_NUMBER").toUpperCase());
				informationList.add(rs52.getString("ENROLLMENT_NUMBER").toUpperCase());

				if (rs52.getTimestamp("ENROLLMENT_DATE") == null || rs52.getString("ENROLLMENT_DATE").equals("")
						|| rs52.getString("ENROLLMENT_DATE").contains("1900")) {
					JsonObject.put("EnrollmentDateIndex", "");
					informationList.add("");
				} else {
					JsonObject.put("EnrollmentDateIndex", ddMMyyyy.format(rs52.getTimestamp("ENROLLMENT_DATE")));
					informationList.add(ddMMyyyyHms.format(rs52.getTimestamp("ENROLLMENT_DATE")));
				}

				JsonObject.put("assetNoIndex", rs52.getString("ASSET_NUMBER").toUpperCase());
				informationList.add(rs52.getString("ASSET_NUMBER").toUpperCase());

				if (rs52.getTimestamp("REGISTRATION_DATE") == null || rs52.getString("REGISTRATION_DATE").equals("")
						|| rs52.getString("REGISTRATION_DATE").contains("1900")) {
					JsonObject.put("RegistrationDateIndex", "");
					informationList.add("");
				} else {
					JsonObject.put("RegistrationDateIndex", ddMMyyyy.format(rs52.getTimestamp("REGISTRATION_DATE")));
					informationList.add(ddMMyyyyHms.format(rs52.getTimestamp("REGISTRATION_DATE")));
				}

				JsonObject.put("engineNoIndex", rs52.getString("ENGINE_NUMBER").toUpperCase());
				informationList.add(rs52.getString("ENGINE_NUMBER").toUpperCase());

				JsonObject.put("carriageCapacityIndex", rs52.getString("CARRIAGE_CAPACITY"));
				informationList.add(rs52.getString("CARRIAGE_CAPACITY"));

				JsonObject.put("OwnerNameIndex", rs52.getString("OWNER_NAME").toUpperCase());
				informationList.add(rs52.getString("OWNER_NAME"));

				JsonObject.put("AssemblyConstituencyIndex", rs52.getString("ASSEMBLY_CONSTITUENCY").toUpperCase());
				informationList.add(rs52.getString("ASSEMBLY_CONSTITUENCY"));

				JsonObject.put("DistrictIndex", rs52.getString("DISTRICT").toUpperCase());
				informationList.add(rs52.getString("DISTRICT"));

				JsonObject.put("StateIndex", rs52.getString("STATE").toUpperCase());
				informationList.add(rs52.getString("STATE"));

				if (rs52.getString("CHALLAN_NO") == null || rs52.getString("CHALLAN_NO").equals("")) {
					JsonObject.put("challenNoIndex", "");
					informationList.add("");
				} else {
					JsonObject.put("challenNoIndex", rs52.getString("CHALLAN_NO"));
					informationList.add(rs52.getString("CHALLAN_NO"));
				}

				if (rs52.getTimestamp("CHALLAN_DATE") == null || rs52.getString("CHALLAN_DATE").equals("")
						|| rs52.getString("CHALLAN_DATE").contains("1900")) {
					JsonObject.put("challenDataIndex", "");
					informationList.add("");
				} else {
					JsonObject.put("challenDataIndex", ddMMyyyy.format(rs52.getTimestamp("CHALLAN_DATE")));
					informationList.add(ddMMyyyyHms.format(rs52.getTimestamp("CHALLAN_DATE")));
				}

				if (rs52.getString("BANK_TRANSACTION_NUMBER") == null
						|| rs52.getString("BANK_TRANSACTION_NUMBER").equals("")) {
					JsonObject.put("banktransactionDataIndex", "");
					informationList.add("");
				} else {
					JsonObject.put("banktransactionDataIndex", rs52.getString("BANK_TRANSACTION_NUMBER"));
					informationList.add(rs52.getString("BANK_TRANSACTION_NUMBER"));
				}

				if (rs52.getString("AMOUNT_PAID") == null || rs52.getString("AMOUNT_PAID").equals("")) {
					JsonObject.put("amountPaidDataIndex", "");
					informationList.add("");
				} else {
					JsonObject.put("amountPaidDataIndex", rs52.getString("AMOUNT_PAID"));
					informationList.add(rs52.getString("AMOUNT_PAID"));
				}

				if (rs52.getTimestamp("VALIDITY_DATE") == null || rs52.getString("VALIDITY_DATE").equals("")
						|| rs52.getString("VALIDITY_DATE").contains("1900")) {
					JsonObject.put("validityDateDataIndex", "");
					informationList.add("");
				} else {
					JsonObject.put("validityDateDataIndex", ddMMyyyy.format(rs52.getTimestamp("VALIDITY_DATE")));
					informationList.add(ddMMyyyyHms.format(rs52.getTimestamp("VALIDITY_DATE")));
				}

				if (rs52.getString("ACKNOWLEDGE_NAME") == null || rs52.getString("ACKNOWLEDGE_NAME").equals("")) {
					JsonObject.put("AcknowledgeByIndex", "");
					informationList.add("");
				} else {
					JsonObject.put("AcknowledgeByIndex", rs52.getString("ACKNOWLEDGE_NAME").toUpperCase());
					informationList.add(rs52.getString("ACKNOWLEDGE_NAME"));
				}

				if (rs52.getString("DISTRICT_ID") == null || rs52.getString("DISTRICT_ID").equals("")) {
					JsonObject.put("districtIdIndex", "");
					informationList.add("");
				} else {
					JsonObject.put("districtIdIndex", rs52.getString("DISTRICT_ID"));
					informationList.add(rs52.getString("DISTRICT_ID"));
				}

				if (rs52.getString("STATE_ID") == null || rs52.getString("STATE_ID").equals("")) {
					JsonObject.put("stateIdIndex", "");
					informationList.add("");
				} else {
					JsonObject.put("stateIdIndex", rs52.getString("STATE_ID"));
					informationList.add(rs52.getString("STATE_ID"));
				}
				JsonObject.put("InsurancePolicyNumber", rs52.getString("INSURANCE_POLICY_NO"));
				informationList.add(rs52.getString("INSURANCE_POLICY_NO"));

				if (rs52.getTimestamp("INSURANCE_EXPIRY_DATE") == null
						|| rs52.getString("INSURANCE_EXPIRY_DATE").equals("")
						|| rs52.getString("INSURANCE_EXPIRY_DATE").contains("1900")) {
					JsonObject.put("InsuranceExpiryDate", "");
					informationList.add("");
				} else {
					JsonObject.put("InsuranceExpiryDate", ddMMyyyy.format(rs52.getTimestamp("INSURANCE_EXPIRY_DATE")));
					informationList.add(ddMMyyyyHms.format(rs52.getTimestamp("INSURANCE_EXPIRY_DATE")));
				}

				JsonObject.put("PucNumber", rs52.getString("PUC_NUMBER"));
				informationList.add(rs52.getString("PUC_NUMBER"));

				if (rs52.getTimestamp("PUC_EXPIRY_DATE") == null || rs52.getString("PUC_EXPIRY_DATE").equals("")
						|| rs52.getString("PUC_EXPIRY_DATE").contains("1900")) {
					JsonObject.put("PucExpiredDate", "");
					informationList.add("");
				} else {
					JsonObject.put("PucExpiredDate", ddMMyyyy.format(rs52.getTimestamp("PUC_EXPIRY_DATE")));
					informationList.add(ddMMyyyyHms.format(rs52.getTimestamp("PUC_EXPIRY_DATE")));
				}
				if (rs52.getString("ROADTAX_VALIDITY_DATE").equals("")
						|| rs52.getString("ROADTAX_VALIDITY_DATE").contains("1900")) {
					JsonObject.put("roadTaxValidityDate", "");
					informationList.add("");
				} else {
					JsonObject.put("roadTaxValidityDate", ddMMyyyy.format(rs52.getTimestamp("ROADTAX_VALIDITY_DATE")));
					informationList.add(ddMMyyyy.format(rs52.getTimestamp("ROADTAX_VALIDITY_DATE")));
				}

				if (rs52.getString("PERMIT_VALIDITY_DATE").equals("")
						|| rs52.getString("PERMIT_VALIDITY_DATE").contains("1900")) {
					JsonObject.put("permitValidityDate", "");
					informationList.add("");
				} else {
					JsonObject.put("permitValidityDate", ddMMyyyy.format(rs52.getTimestamp("PERMIT_VALIDITY_DATE")));
					informationList.add(ddMMyyyy.format(rs52.getTimestamp("PERMIT_VALIDITY_DATE")));
				}

				JsonObject.put("status", rs52.getString("STATUS"));
				informationList.add(rs52.getString("STATUS"));

				JsonObject.put("reasonOfInactive", rs52.getString("REASON"));
				informationList.add(rs52.getString("REASON"));

				JsonObject.put("operatingOnMineIndex", rs52.getString("OPERATING_ON_MINE"));

				JsonObject.put("locationIndex", rs52.getString("LOCATION"));

				JsonObject.put("MiningLeaseNoIndex", rs52.getString("MINING_LEASE_NO"));

				JsonObject.put("ChasisNoIndex", rs52.getString("CHASSIS_NO"));

				JsonObject.put("houseNoIndex", rs52.getString("HOUSE_NO"));

				JsonObject.put("localityIndex", rs52.getString("LOCALITY"));

				JsonObject.put("cityIndex", rs52.getString("CITY_OR_VILLAGE").toUpperCase());

				JsonObject.put("talukaIndex", rs52.getString("TALUKA").toUpperCase());

				JsonObject.put("EPICNoIndex", rs52.getString("EPIC_NO"));

				JsonObject.put("PANNoIndex", rs52.getString("PAN_NO"));

				JsonObject.put("MobileNoIndex", rs52.getString("MOBILE_NO"));

				JsonObject.put("PhoneNoIndex", rs52.getString("PHONE_NO"));

				JsonObject.put("AadharNoIndex", rs52.getString("AADHAR_NO").toUpperCase());

				JsonObject.put("BankIndex", rs52.getString("BANK").toUpperCase());

				JsonObject.put("BranchIndex", rs52.getString("BRANCH"));

				JsonObject.put("PrincipalBalanceIndex", rs52.getString("PRINCIPAL_BALANCE"));

				JsonObject.put("PrincipalOverDuesIndex", rs52.getString("PRINCIPAL_OVER_DUES"));

				JsonObject.put("PrincipalInterestIndex", rs52.getString("INTEREST_BALANCE"));

				JsonObject.put("AccountNoIndex", rs52.getString("ACCOUNT_NO").toUpperCase());

				JsonObject.put("statusIndex", rs52.getString("STATUS"));

				JsonObject.put("uniqueIdDataIndex", rs52.getString("ID"));

				JsonArray.put(JsonObject);
				reporthelper.setInformationList(informationList);
				reportsList.add(reporthelper);
			}
			assetList.add(JsonArray);
			finalreporthelper.setReportsList(reportsList);
			finalreporthelper.setHeadersList(headersList);
			assetList.add(finalreporthelper);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {

			DBConnection.releaseConnectionToDB(con, pstmt52, rs52);
		}
		return assetList;
	}

	//----------------------------------------------MINING ASSET ENROLLMENT SAVE DETAILS-----------------------// 
	public String saveAssetEnrollmentInformation(int customerId, String assetNo, String regDate, String engineNo,
			String carriageCapacity, String operationMine, String location, String leaseNo, String chassisNo,
			String InsurancePolicyNo, String InsuranceExpiryDate, String PucNumber, String PucExpiryDate,
			String ownerName, String houseNo, String locality, String city, String taluk, String district, String state,
			String epicNo, String panNo, String mobileNo, String phoneNo, String adharNo, String enrollDate,
			String bank, String branch, String princiaplBal, String overDues, String interestBal, String accountNo,
			int userId, int systemId, String CustName, String assemblyConstituency, String roadTaxValidityDate,
			String permitValidityDate) {
		String message = "";
		Connection conAdmin = null;
		PreparedStatement pstmt55 = null;
		ResultSet rs55 = null;
		try {
			int inserted = 0;
			int enrollmentNo = 0;
			conAdmin = DBConnection.getConnectionToDB("AMS");
			pstmt55 = conAdmin.prepareStatement(IronMiningStatement.GET_ASSET_NO_VALIDATE);
			pstmt55.setInt(1, systemId);
			pstmt55.setInt(2, customerId);
			pstmt55.setString(3, assetNo.toUpperCase());
			rs55 = pstmt55.executeQuery();
			if (rs55.next()) {
				message = "<p>Asset Number Already Enrolled.</p>";
				return (message);
			}
			Calendar gcalendar = new GregorianCalendar();
			int year = gcalendar.get(Calendar.YEAR);
			String curyear = String.valueOf(year);

			enrollmentNo = getEnrollmentNumber(conAdmin, systemId, customerId, curyear);

			//----leading Zeros handling----------------------//  
			String enrolmentNotoGrid = "";
			if (String.valueOf(enrollmentNo).length() <= 5) {
				enrolmentNotoGrid = ("00000" + enrollmentNo).substring(String.valueOf(enrollmentNo).length());
			} else {
				enrolmentNotoGrid = ("000000000" + enrollmentNo).substring(String.valueOf(enrollmentNo).length());
			}
			//-----Insert Mining Asset Enrolment details into MINING_ASSET_ENROLLMENT Table--------//
			String currentyear = curyear.substring(Math.max(curyear.length() - 2, 0));
			pstmt55 = conAdmin.prepareStatement(IronMiningStatement.SAVE_MINING_ASSET_ENROLLMENT_INFORMATION);
			pstmt55.setString(1, CustName + "" + enrolmentNotoGrid + "/" + currentyear);
			pstmt55.setString(2, assetNo.toUpperCase());
			pstmt55.setString(3, regDate);
			pstmt55.setDouble(4, Double.parseDouble(carriageCapacity));
			pstmt55.setString(5, operationMine.toUpperCase());
			pstmt55.setString(6, location.toUpperCase());
			pstmt55.setString(7, leaseNo.toUpperCase());
			pstmt55.setString(8, chassisNo.toUpperCase());
			pstmt55.setString(9, InsurancePolicyNo.toUpperCase());
			pstmt55.setString(10, InsuranceExpiryDate);
			pstmt55.setString(11, PucNumber.toUpperCase());
			pstmt55.setString(12, PucExpiryDate);
			pstmt55.setString(13, ownerName.toUpperCase());
			pstmt55.setString(14, assemblyConstituency.toUpperCase());
			pstmt55.setString(15, houseNo.toUpperCase());
			pstmt55.setString(16, locality.toUpperCase());
			pstmt55.setString(17, city.toUpperCase());
			pstmt55.setString(18, taluk.toUpperCase());
			pstmt55.setString(19, district.toUpperCase());
			pstmt55.setString(20, state.toUpperCase());
			pstmt55.setString(21, epicNo.toUpperCase());
			pstmt55.setString(22, panNo.toUpperCase());
			pstmt55.setDouble(23, Double.parseDouble(mobileNo));
			pstmt55.setDouble(24, Double.parseDouble(phoneNo));
			pstmt55.setString(25, adharNo.toUpperCase());
			pstmt55.setString(26, enrollDate);
			pstmt55.setString(27, bank.toUpperCase());
			pstmt55.setString(28, branch.toUpperCase());
			pstmt55.setDouble(29, Double.parseDouble(princiaplBal));
			pstmt55.setDouble(30, Double.parseDouble(overDues));
			pstmt55.setDouble(31, Double.parseDouble(interestBal));
			pstmt55.setString(32, accountNo.toUpperCase());
			pstmt55.setString(33, engineNo);
			pstmt55.setInt(34, systemId);
			pstmt55.setInt(35, customerId);
			pstmt55.setInt(36, userId);
			pstmt55.setString(37, roadTaxValidityDate);
			pstmt55.setString(38, permitValidityDate);
			inserted = pstmt55.executeUpdate();
			if (inserted > 0) {
				message = "Asset Enrollment Details Saved Successfully";
			} else {
				message = "Error in Saving Asset Enrollment Details";
			}
		} catch (Exception e) {
			System.out.println("error in Asset Enrollment Details:-save Asset Enrollment Details" + e.toString());
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(conAdmin, pstmt55, rs55);
		}
		return message;
	}

	private synchronized int getEnrollmentNumber(Connection conAdmin, int systemId, int customerId, String curyear) {
		PreparedStatement pstmt550 = null;
		PreparedStatement pstmt55 = null;
		ResultSet rs550 = null;
		int enrolmentnonew = 0;
		try {
			pstmt550 = conAdmin.prepareStatement(IronMiningStatement.GET_ENROLLMENT_NUMBER, ResultSet.TYPE_FORWARD_ONLY,
					ResultSet.CONCUR_UPDATABLE);
			pstmt550.setString(1, "ENROLL_NUMBER");
			pstmt550.setInt(2, systemId);
			pstmt550.setInt(3, customerId);
			pstmt550.setString(4, curyear);
			rs550 = pstmt550.executeQuery();
			if (rs550.next()) {
				enrolmentnonew = rs550.getInt("VALUE");
				enrolmentnonew++;
				rs550.updateInt("VALUE", enrolmentnonew);
				rs550.rowUpdated();
				pstmt55 = conAdmin.prepareStatement(IronMiningStatement.UPDATE_ENROLLMENT_NO_TO_LOOKUP);
				pstmt55.setInt(1, enrolmentnonew);
				pstmt55.setString(2, "ENROLL_NUMBER");
				pstmt55.setInt(3, systemId);
				pstmt55.setInt(4, customerId);
				pstmt55.setString(5, curyear);
				pstmt55.executeUpdate();
			} else {
				enrolmentnonew++;
				pstmt55 = conAdmin.prepareStatement(IronMiningStatement.INSERT_ENROLLMENT_NUMBER_TO_LOOKUP);
				pstmt55.setString(1, "ENROLL_NUMBER");
				pstmt55.setInt(2, enrolmentnonew);
				pstmt55.setString(3, curyear);
				pstmt55.setInt(4, systemId);
				pstmt55.setInt(5, customerId);
				pstmt55.executeUpdate();
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(null, pstmt550, rs550);
			DBConnection.releaseConnectionToDB(null, pstmt55, null);
		}
		return enrolmentnonew;
	}

	private synchronized int getMonthlyReturnNumber(Connection conAdmin, int systemId, int customerId, String curyear) {
		PreparedStatement pstmt550 = null;
		PreparedStatement pstmt55 = null;
		ResultSet rs550 = null;
		int enrolmentnonew = 0;
		try {
			pstmt550 = conAdmin.prepareStatement(IronMiningStatement.GET_ENROLLMENT_NUMBER, ResultSet.TYPE_FORWARD_ONLY,
					ResultSet.CONCUR_UPDATABLE);
			pstmt550.setString(1, "MONTHLY_RETURN");
			pstmt550.setInt(2, systemId);
			pstmt550.setInt(3, customerId);
			pstmt550.setString(4, curyear);
			rs550 = pstmt550.executeQuery();
			if (rs550.next()) {
				enrolmentnonew = rs550.getInt("VALUE");
				enrolmentnonew++;
				rs550.updateInt("VALUE", enrolmentnonew);
				rs550.rowUpdated();
				pstmt55 = conAdmin.prepareStatement(IronMiningStatement.UPDATE_ENROLLMENT_NO_TO_LOOKUP);
				pstmt55.setInt(1, enrolmentnonew);
				pstmt55.setString(2, "MONTHLY_RETURN");
				pstmt55.setInt(3, systemId);
				pstmt55.setInt(4, customerId);
				pstmt55.setString(5, curyear);
				pstmt55.executeUpdate();
			} else {
				enrolmentnonew++;
				pstmt55 = conAdmin.prepareStatement(IronMiningStatement.INSERT_ENROLLMENT_NUMBER_TO_LOOKUP);
				pstmt55.setString(1, "MONTHLY_RETURN");
				pstmt55.setInt(2, enrolmentnonew);
				pstmt55.setString(3, curyear);
				pstmt55.setInt(4, systemId);
				pstmt55.setInt(5, customerId);
				pstmt55.executeUpdate();
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(null, pstmt550, rs550);
			DBConnection.releaseConnectionToDB(null, pstmt55, null);
		}
		return enrolmentnonew;
	}

	//-------------------------------------MINING MODIFY SAVE DETAILS--------------------------------------//
	public String modifyAssetEnrollmentInformation(int customerId, String assetNo, String regDate, String engineNo,
			String carriageCapacity, String operationMine, String location, String leaseNo, String chassisNo,
			String InsurancePolicyNo, String InsuranceExpiryDate, String PucNumber, String PucExpiryDate,
			String ownerName, String houseNo, String locality, String city, String taluk, String district, String state,
			String epicNo, String panNo, String mobileNo, String phoneNo, String adharNo, String enrollDate,
			String bank, String branch, String princiaplBal, String overDues, String interestBal, String accountNo,
			int userId, String uniqueId, int systemId, String assemblyName, String roadTaxValidityDate,
			String permitValidityDate) {
		String message = "";
		Connection conAdmin = null;
		PreparedStatement pstmt90 = null;
		try {
			conAdmin = DBConnection.getConnectionToDB("AMS");
			int updated = 0;
			pstmt90 = conAdmin.prepareStatement(IronMiningStatement.MODIFY_ASSET_ENROLLMENT_NO_INFORMATION);
			pstmt90.setString(1, operationMine.toUpperCase());
			pstmt90.setString(2, location.toUpperCase());
			pstmt90.setString(3, leaseNo.toUpperCase());
			pstmt90.setString(4, chassisNo.toUpperCase());
			pstmt90.setString(5, InsurancePolicyNo.toUpperCase());
			pstmt90.setString(6, InsuranceExpiryDate);
			pstmt90.setString(7, PucNumber.toUpperCase());
			pstmt90.setString(8, PucExpiryDate);
			pstmt90.setString(9, houseNo.toUpperCase());
			pstmt90.setString(10, locality.toUpperCase());
			pstmt90.setString(11, city.toUpperCase());
			pstmt90.setString(12, taluk.toUpperCase());
			pstmt90.setString(13, epicNo.toUpperCase());
			pstmt90.setString(14, panNo.toUpperCase());
			pstmt90.setDouble(15, Double.parseDouble(mobileNo));
			pstmt90.setDouble(16, Double.parseDouble(phoneNo));
			pstmt90.setString(17, adharNo.toUpperCase());
			pstmt90.setString(18, bank.toUpperCase());
			pstmt90.setString(19, branch.toUpperCase());
			pstmt90.setDouble(20, Double.parseDouble(princiaplBal));
			pstmt90.setDouble(21, Double.parseDouble(overDues));
			pstmt90.setDouble(22, Double.parseDouble(interestBal));
			pstmt90.setString(23, accountNo.toUpperCase());
			pstmt90.setInt(24, userId);
			pstmt90.setString(25, engineNo);
			pstmt90.setString(26, assemblyName);
			pstmt90.setString(27, roadTaxValidityDate);
			pstmt90.setString(28, permitValidityDate);
			pstmt90.setInt(29, systemId);
			pstmt90.setInt(30, customerId);
			pstmt90.setString(31, uniqueId);
			updated = pstmt90.executeUpdate();
			if (updated > 0) {
				message = "Asset Enrollment Details Modified Successfully";
			} else {
				message = "Asset Enrollment Details is not possible for Modified of this Vehicles";
			}
		} catch (Exception e) {
			System.out.println("error in ModifyAssetEnrollmentFunction:-save Asset enrollment details " + e.toString());
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(conAdmin, pstmt90, null);
		}
		return message;
	}
	//-------------------------------------MINING acknowledgement SAVE DETAILS--------------------------------------//

	public String saveAssetAcknowledgementInformation(int customerId, String assetNos, String challenNo,
			String challendate, String bankTransactionNumber, String paidAmount, String validityDate, int userId,
			int systemId, String ackuniqueId, String enrolNoGrid, String enrollDateGrid, String assetNumberGrid,
			String regstartdateGrid, String carriageCapacityGrid, String operatingOnMineGrid, String locationGrid,
			String miningLeaseNoGrid, String chassisNoGrid, String ownerNameGrid, String assemblyNameGrid,
			String houseNoGrid, String localityGrid, String enterCityGrid, String talukaGrid, String districtcomboGrid,
			String statecomboGrid, String ePICNoGrid, String pANNoGrid, String mobileNoGrid, String phoneNoGrid,
			String adharNoGrid, String bankGrid, String branchGrid, String principalBalanceGrid,
			String principalOverDuesGrid, String interestBalanceGrid, String accountNoGrid, String challenNoGrid,
			String challenDataGrid, String banktransactionGrid, String amountPaidGrid, String validityDateGrid,
			String StatusGrid) {
		String message = "";
		Connection conAdmin = null;
		PreparedStatement pstmt95 = null;
		int insertHistory = 0;
		try {
			conAdmin = DBConnection.getConnectionToDB("AMS");
			if (challenNoGrid != null && !challenNoGrid.equals("")) {
				pstmt95 = conAdmin.prepareStatement(IronMiningStatement.MOVED_CHALLAN_EXPIRED_DATA_TO_HISTORY);
				pstmt95.setString(1, enrolNoGrid);
				pstmt95.setString(2, assetNumberGrid.toUpperCase());
				pstmt95.setString(3, regstartdateGrid);
				pstmt95.setDouble(4, Double.parseDouble(carriageCapacityGrid));
				pstmt95.setString(5, operatingOnMineGrid.toUpperCase());
				pstmt95.setString(6, locationGrid.toUpperCase());
				pstmt95.setString(7, miningLeaseNoGrid.toUpperCase());
				pstmt95.setString(8, chassisNoGrid.toUpperCase());
				pstmt95.setString(9, ownerNameGrid.toUpperCase());
				pstmt95.setString(10, assemblyNameGrid.toUpperCase());
				pstmt95.setString(11, houseNoGrid.toUpperCase());
				pstmt95.setString(12, localityGrid.toUpperCase());
				pstmt95.setString(13, enterCityGrid.toUpperCase());
				pstmt95.setString(14, talukaGrid.toUpperCase());
				pstmt95.setString(15, districtcomboGrid.toUpperCase());
				pstmt95.setString(16, statecomboGrid.toUpperCase());
				pstmt95.setString(17, ePICNoGrid.toUpperCase());
				pstmt95.setString(18, pANNoGrid.toUpperCase());
				pstmt95.setDouble(19, Double.parseDouble(mobileNoGrid));
				pstmt95.setDouble(20, Double.parseDouble(phoneNoGrid));
				pstmt95.setString(21, adharNoGrid.toUpperCase());
				pstmt95.setString(22, enrollDateGrid);
				pstmt95.setString(23, bankGrid.toUpperCase());
				pstmt95.setString(24, branchGrid.toUpperCase());
				pstmt95.setDouble(25, Double.parseDouble(principalBalanceGrid));
				pstmt95.setDouble(26, Double.parseDouble(principalOverDuesGrid));
				pstmt95.setDouble(27, Double.parseDouble(interestBalanceGrid));
				pstmt95.setString(28, accountNoGrid.toUpperCase());
				pstmt95.setString(29, challenNoGrid.toUpperCase());
				pstmt95.setString(30, challenDataGrid);
				pstmt95.setString(31, banktransactionGrid);
				pstmt95.setDouble(32, Double.parseDouble(amountPaidGrid));
				pstmt95.setString(33, validityDateGrid);
				pstmt95.setString(34, StatusGrid);
				pstmt95.setString(35, ackuniqueId);
				pstmt95.setInt(36, systemId);
				pstmt95.setInt(37, customerId);
				pstmt95.setInt(38, userId);
				insertHistory = pstmt95.executeUpdate();
				if (insertHistory > 0) {
					message = "Asset Enrollment Details Moved to History Successfully";
				} else {
					message = "Error in Moving Asset Enrollment Details to History";
				}
			}
			int updated = 0;
			pstmt95 = conAdmin.prepareStatement(IronMiningStatement.SAVE_ACKNOWLEDGEMENT_INFORMATION);
			pstmt95.setString(1, challenNo.toUpperCase());
			pstmt95.setString(2, challendate);
			pstmt95.setString(3, bankTransactionNumber);
			pstmt95.setDouble(4, Double.parseDouble(paidAmount));
			pstmt95.setString(5, validityDate);
			pstmt95.setInt(6, userId);
			pstmt95.setInt(7, systemId);
			pstmt95.setInt(8, customerId);
			pstmt95.setString(9, ackuniqueId);
			updated = pstmt95.executeUpdate();
			if (updated > 0) {
				message = "Acknowledgemnet Details saved Successfully";
			} else {
				message = "Acknowledgemnet Details is not possible for Vehicles";
			}
		} catch (Exception e) {
			e.printStackTrace();
			System.out.println("Inside acknoledgement function" + e.toString());
		} finally {
			DBConnection.releaseConnectionToDB(conAdmin, pstmt95, null);
		}
		return message;
	}

	//-------------------------------------GET MINING SAVE DETAILS FOR PDF--------------------------------------//
	public ArrayList<ArrayList<String>> getPrintList(int systemId, int clientId, String assetNo, String customerName) {
		Connection conAdmin = null;
		PreparedStatement pstmt100 = null;
		ResultSet rs100 = null;
		ArrayList<String> finlist = new ArrayList<String>();
		ArrayList<ArrayList<String>> list = new ArrayList<ArrayList<String>>();
		SimpleDateFormat ddMMyyyyHH = new SimpleDateFormat("dd/MM/yyyy");
		try {
			conAdmin = DBConnection.getConnectionToDB("AMS");
			pstmt100 = conAdmin.prepareStatement(IronMiningStatement.GET_DATA_FOR_PDF);
			pstmt100.setInt(1, systemId);
			pstmt100.setInt(2, clientId);
			pstmt100.setString(3, assetNo);
			rs100 = pstmt100.executeQuery();
			while (rs100.next()) {
				finlist.add(rs100.getString("ENROLLMENT_NUMBER"));//0
				if (rs100.getTimestamp("ENROLLMENT_DATE") != null || rs100.getString("ENROLLMENT_DATE").equals("")
						|| rs100.getString("ENROLLMENT_DATE").contains("1900")) {
					finlist.add(ddMMyyyyHH.format(rs100.getTimestamp("ENROLLMENT_DATE")));//1
				} else {
					finlist.add("");
				}
				finlist.add(rs100.getString("ASSET_NUMBER").toUpperCase());//2

				if (rs100.getTimestamp("REGISTRATION_DATE") != null || rs100.getString("REGISTRATION_DATE").equals("")
						|| rs100.getString("REGISTRATION_DATE").contains("1900")) {
					finlist.add(ddMMyyyyHH.format(rs100.getTimestamp("REGISTRATION_DATE")));//3
				} else {
					finlist.add("");
				}
				finlist.add(rs100.getString("CARRIAGE_CAPACITY"));//4
				finlist.add(rs100.getString("CHASSIS_NO"));//5
				finlist.add(rs100.getString("INSURANCE_POLICY_NO"));//6
				if (rs100.getTimestamp("INSURANCE_EXPIRY_DATE") != null
						|| rs100.getString("INSURANCE_EXPIRY_DATE").equals("")
						|| rs100.getString("INSURANCE_EXPIRY_DATE").contains("1900")) {
					finlist.add(ddMMyyyyHH.format(rs100.getTimestamp("INSURANCE_EXPIRY_DATE")));//7
				} else {
					finlist.add("");
				}

				finlist.add(rs100.getString("PUC_NUMBER"));//8
				if (rs100.getTimestamp("PUC_EXPIRY_DATE") != null || rs100.getString("PUC_EXPIRY_DATE").equals("")
						|| rs100.getString("PUC_EXPIRY_DATE").contains("1900")) {
					finlist.add(ddMMyyyyHH.format(rs100.getTimestamp("PUC_EXPIRY_DATE")));//9
				} else {
					finlist.add("");
				}

				finlist.add(rs100.getString("OWNER_NAME").toUpperCase());//10
				finlist.add(rs100.getString("HOUSE_NO"));//11
				finlist.add(rs100.getString("ASSEMBLY_CONSTITUENCY").toUpperCase());//12
				finlist.add(rs100.getString("LOCALITY"));//13
				finlist.add(rs100.getString("CITY_OR_VILLAGE").toUpperCase());//14
				finlist.add(rs100.getString("TALUKA").toUpperCase());//15
				finlist.add(rs100.getString("DISTRICT").toUpperCase());//16
				finlist.add(rs100.getString("STATE").toUpperCase());//17
				finlist.add(rs100.getString("EPIC_NO"));//18
				finlist.add(rs100.getString("PAN_NO"));//19
				finlist.add(rs100.getString("MOBILE_NO"));//20
				finlist.add(rs100.getString("AADHAR_NO").toUpperCase());//21
				finlist.add(rs100.getString("VEHICLE_TYPE").toUpperCase());//22
			}
			list.add(finlist);
		} catch (Exception e) {
			if (conAdmin != null) {
				try {
					conAdmin.rollback();
				} catch (SQLException e9) {
					e9.printStackTrace();
				}
			}
			e.printStackTrace();
			System.out.println("Inside pdf generation function" + e.toString());
		} finally {
			DBConnection.releaseConnectionToDB(conAdmin, pstmt100, rs100);
		}
		return list;
	}
	//-------------------------------------GET MINING SAVE DETAILS FOR ACKNOWLEDGE PDF--------------------------------------//

	public ArrayList<ArrayList<String>> getAcknowledgePrintList(int systemId, int clientId, String vehicleNo) {
		Connection conAdmin = null;
		PreparedStatement pstmt007 = null;
		ResultSet rs007 = null;
		ArrayList<String> ackfinlist = new ArrayList<String>();
		ArrayList<ArrayList<String>> acklist = new ArrayList<ArrayList<String>>();
		SimpleDateFormat ddMMyyyyHH = new SimpleDateFormat("dd/MM/yyyy");
		try {
			conAdmin = DBConnection.getConnectionToDB("AMS");
			pstmt007 = conAdmin.prepareStatement(IronMiningStatement.GET_DATA_FOR_PDF_ACKNOWLEDGEMENT);
			pstmt007.setInt(1, systemId);
			pstmt007.setInt(2, clientId);
			pstmt007.setString(3, vehicleNo);
			rs007 = pstmt007.executeQuery();
			String bankNo = "0";
			double amountPaid = 0.0;
			while (rs007.next()) {
				ackfinlist.add(rs007.getString("ENROLLMENT_NUMBER"));//0

				if (rs007.getTimestamp("ENROLLMENT_DATE") != null || rs007.getString("ENROLLMENT_DATE").equals("")
						|| rs007.getString("ENROLLMENT_DATE").contains("1900")) {
					ackfinlist.add(ddMMyyyyHH.format(rs007.getTimestamp("ENROLLMENT_DATE")));//1
				} else {
					ackfinlist.add("");
				}
				ackfinlist.add(rs007.getString("ASSET_NUMBER").toUpperCase());//2
				ackfinlist.add(rs007.getString("OWNER_NAME").toUpperCase());//3
				ackfinlist.add(rs007.getString("ASSEMBLY_CONSTITUENCY").toUpperCase());//4
				ackfinlist.add(rs007.getString("CHALLAN_NO").toUpperCase());//5
				if (rs007.getTimestamp("CHALLAN_DATE") != null || rs007.getString("CHALLAN_DATE").equals("")
						|| rs007.getString("CHALLAN_DATE").contains("1900")) {
					ackfinlist.add(ddMMyyyyHH.format(rs007.getTimestamp("CHALLAN_DATE")));//6
				} else {
					ackfinlist.add("");
				}
				bankNo = rs007.getString("BANK_TRANSACTION_NUMBER");
				ackfinlist.add(String.valueOf(bankNo));//7
				amountPaid = rs007.getDouble("AMOUNT_PAID");
				ackfinlist.add(String.valueOf(amountPaid));//8
				if (rs007.getTimestamp("VALIDITY_DATE") != null || rs007.getString("VALIDITY_DATE").equals("")
						|| rs007.getString("VALIDITY_DATE").contains("1900")) {
					ackfinlist.add(ddMMyyyyHH.format(rs007.getTimestamp("VALIDITY_DATE")));//9
				} else {
					ackfinlist.add("");
				}
			}
			acklist.add(ackfinlist);
		} catch (Exception e) {
			if (conAdmin != null) {
				try {
					conAdmin.rollback();
				} catch (SQLException e9) {
					e9.printStackTrace();
				}
			}
			e.printStackTrace();
			System.out.println("Inside ACKNOWLEDGEMENT pdf generation function" + e.toString());
		} finally {
			DBConnection.releaseConnectionToDB(conAdmin, pstmt007, rs007);
		}
		return acklist;
	}
	//-------------------------------Trip sheet Generation Report on 16/04/2015 by Santhosh---------------------------//

	//-----------------------------------get vehicle list----------------------------------//
	public JSONArray getVehicleNoList(String clientId, int systemId) {
		JSONArray JsonArray = new JSONArray();
		JSONObject JsonObject = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			System.out.println("%%%%%%%%%%%%%%%%getVehicleNoList%%%%%%%%%%%%%%%%%%%%%%%%%%%555");
			JsonArray = new JSONArray();
			JsonObject = new JSONObject();
			con = DBConnection.getConnectionToDB("AMS");

			pstmt = con.prepareStatement(IronMiningStatement.GET_VEHILCE_NO_FOR_TRIP_SHEET_GEN);
			pstmt.setInt(1, systemId);
			pstmt.setString(2, clientId);
			System.out.println("%%%%%%%%%%%%%%!1111111111%%%%%%%" + new Date());
			rs = pstmt.executeQuery();
			System.out.println("%%%%%%%%%%%%%%!222222222222%%%%%%%" + new Date());
			while (rs.next()) {
				JsonObject = new JSONObject();
				JsonObject.put("vehicleNoID", rs.getString("VID"));
				JsonObject.put("vehicleName", rs.getString("VNAME"));
				JsonObject.put("quantity1", rs.getString("QUANTITY1"));
				if (rs.getInt("LOADCAPACITY") > 0) {
					JsonObject.put("loadcapacity", rs.getString("LOADCAPACITY"));
				} else {
					JsonObject.put("loadcapacity", 10500);
				}

				JsonObject.put("incExpStatus", rs.getString("INSURANCE_EXPIRED_STATUS"));
				JsonObject.put("pucExpStatus", rs.getString("PUC_EXPIRED_STATUS"));
				JsonArray.put(JsonObject);
			}
			System.out.println("%%%%%%%%%%%%%%!3333333333333%%%%%%%" + new Date());
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		System.out.println("%%%%%%%%%%%%%%%%getVehicleNoList end%%%%%%%%%%%%%%%%%%%%%%%%%%%555");

		return JsonArray;
	}

	//-------------------------------------GET ROUTE NAME LIST---------------------------------------------//
	public JSONArray getRouteNameList(String clientId, int systemId, int orgId, String permitType, int permitId) {
		JSONArray JsonArray = new JSONArray();
		JSONObject JsonObject = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			JsonArray = new JSONArray();
			JsonObject = new JSONObject();
			con = DBConnection.getConnectionToDB("AMS");
			if (permitType.equalsIgnoreCase("Purchased Rom Sale Transit Permit")) {
				pstmt = con.prepareStatement(IronMiningStatement.GET_ROUTE_NAME_FOR_TRIP_SHEET_GEN
						.concat("and SOURCE_HUB_ID in (select ROUTE_ID from MINING_PERMIT_DETAILS WHERE ID=?)"));
				pstmt.setInt(1, systemId);
				pstmt.setString(2, clientId);
				pstmt.setInt(3, orgId);
				pstmt.setInt(4, systemId);
				pstmt.setString(5, clientId);
				pstmt.setInt(6, orgId);
				pstmt.setInt(7, permitId);
			} else {
				pstmt = con.prepareStatement(IronMiningStatement.GET_ROUTE_NAME_FOR_TRIP_SHEET_GEN);
				pstmt.setInt(1, systemId);
				pstmt.setString(2, clientId);
				pstmt.setInt(3, orgId);
				pstmt.setInt(4, systemId);
				pstmt.setString(5, clientId);
				pstmt.setInt(6, orgId);
			}
			rs = pstmt.executeQuery();
			while (rs.next()) {
				JsonObject = new JSONObject();
				JsonObject.put("routeId", rs.getString("ROUTE_ID"));
				JsonObject.put("routeName", rs.getString("ROUTE_NAME"));
				JsonObject.put("fromlocation", rs.getString("FROM_LOCATION"));
				JsonObject.put("tolocation", rs.getString("TO_LOCATION"));
				JsonObject.put("status", rs.getString("STATUS"));
				JsonArray.put(JsonObject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return JsonArray;
	}

	//-----------------------------------get GRADE list----------------------------------//
	public JSONArray getGradeList(String clientId, int systemId) {
		JSONArray JsonArray = new JSONArray();
		JSONObject JsonObject = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			JsonArray = new JSONArray();
			JsonObject = new JSONObject();
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(IronMiningStatement.GET_GRADE_FOR_TRIP_SHEET_GEN);
			pstmt.setInt(1, systemId);
			pstmt.setString(2, clientId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				JsonObject = new JSONObject();
				JsonObject.put("gradeMineralsID", rs.getString("GRADE_ID"));
				JsonObject.put("gradeMineralsName", rs.getString("GRADE_NAME"));
				JsonArray.put(JsonObject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}

		return JsonArray;
	}

	//-----------------------------------get TC name list----------------------------------//
	public JSONArray getTCNameList(String clientId, int systemId) {
		JSONArray JsonArray = new JSONArray();
		JSONObject JsonObject = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			JsonArray = new JSONArray();
			JsonObject = new JSONObject();
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(IronMiningStatement.GET_TCNAME_FOR_TRIP_SHEET_GEN);
			pstmt.setInt(1, systemId);
			pstmt.setString(2, clientId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				JsonObject = new JSONObject();
				JsonObject.put("TCNameID", rs.getString("TC_NAME_ID"));
				JsonObject.put("TcLeaseName", rs.getString("TC_LEASE_NAME"));
				JsonArray.put(JsonObject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}

		return JsonArray;
	}
	//-------------------------------------GET RFID-------------------------------------------------------//

	public JSONArray getRFID(String clientId, int systemId, String rfidNumber) {
		JSONArray JsonArray = new JSONArray();
		JSONObject JsonObject = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String vehicleNo = "";
		String quantity1 = "";
		int loadcapacity = 0;
		String incExp = "";
		String pucExp = "";
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(IronMiningStatement.GET_VEHICLE_NUMBER_BASED_ON_RFID);
			pstmt.setInt(1, systemId);
			pstmt.setString(2, clientId);
			pstmt.setString(3, rfidNumber);
			pstmt.setInt(4, systemId);
			pstmt.setString(5, clientId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				vehicleNo = rs.getString("VehicleNo");
				quantity1 = rs.getString("QUANTITY1");
				if (rs.getInt("LOADCAPACITY") > 0) {
					loadcapacity = rs.getInt("LOADCAPACITY");
				} else {
					loadcapacity = 10500;
				}
				incExp = rs.getString("INSURANCE_EXPIRED_STATUS");
				pucExp = rs.getString("PUC_EXPIRED_STATUS");

			}
			JsonObject = new JSONObject();
			JsonObject.put("jsonString", vehicleNo);
			JsonObject.put("quantity1", quantity1);
			JsonObject.put("loadcapacity", loadcapacity);
			JsonObject.put("incExpStatus", incExp);
			JsonObject.put("pucExpStatus", pucExp);
			JsonArray.put(JsonObject);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return JsonArray;
	}

	//*****************************GET WEIGHT****************************************************//
	public JSONArray getWeightFromFile(String clientId, int systemId, String ip) {
		JSONArray JsonArray = new JSONArray();
		JSONObject JsonObject = new JSONObject();
		String Weight = "";
		try {
			Weight = getCaptureWeightFromFile(ip);
			JsonObject = new JSONObject();
			JsonObject.put("", Weight);
			JsonArray.put(JsonObject);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return JsonArray;
	}

	//********************************************GET WEIGHT FOR TIME INTERVAL*************************//
	public JSONArray getWeightFromFileForInterval(String clientId, int systemId, String ip) {
		JSONArray JsonArray = new JSONArray();
		JSONObject JsonObject = new JSONObject();
		String Weight = "";
		try {
			Weight = getCaptureWeightFromFile(ip);
			JsonObject = new JSONObject();
			JsonObject.put("Weight", Weight);
			JsonArray.put(JsonObject);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return JsonArray;
	}

	//***********************************GET WEIGHT FROM FILE******************************************//
	private String getCaptureWeightFromFile(String ip) {
		String finalWeightValue = "";
		String responseCode = "";
		StringBuilder buf = new StringBuilder();
		try {
			Properties prop = ApplicationListener.prop;
			String webServicePathForWeight = prop.getProperty("WebServiceUrlPathForWeight");
			URL url = new URL("http://" + ip + webServicePathForWeight);
			//URL url = new URL(webServicePathForWeight);

			HttpURLConnection connection = (HttpURLConnection) url.openConnection();
			connection.setRequestMethod("POST");
			connection.setRequestProperty("Content-Type", "application/xml");
			connection.setDoOutput(true);
			connection.setInstanceFollowRedirects(false);

			StringBuffer jsonOb = new StringBuffer();
			OutputStream os = connection.getOutputStream();
			System.out.println("os=" + os);
			os.write(jsonOb.toString().getBytes());
			os.flush();

			System.out.println("connection.getResponseCode()" + connection.getResponseCode());

			responseCode = connection.getResponseCode() + "";
			System.out.println("response=" + responseCode);
			InputStreamReader reader = new InputStreamReader(connection.getInputStream());
			char[] cbuf = new char[2048];
			int num;
			while (-1 != (num = reader.read(cbuf))) {
				buf.append(cbuf, 0, num);
			}
			finalWeightValue = buf.toString();
			System.out.println(finalWeightValue);
			connection.disconnect();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return finalWeightValue;
	}
	//-----------------------------------GETTING TRIP SHEET DETAILS FOR GRID-------------------------------------//

	@SuppressWarnings("unchecked")
	public ArrayList getTripSheetDetails(String customerName, int systemId, int CustomerId, int userId, String language,
			String fromDate, String endDate, String status) {
		JSONArray JsonArray = new JSONArray();
		JSONObject JsonObject = null;
		Connection con = null;
		PreparedStatement pstmt52 = null;
		ResultSet rs52 = null;
		int aslcount = 0;
		SimpleDateFormat diffddMMyyyyHHmmss = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
		ArrayList assetLists = new ArrayList();
		DecimalFormat df = new DecimalFormat("#.###");
		ArrayList<String> headersList = new ArrayList<String>();
		ArrayList<ReportHelper> reportsList = new ArrayList<ReportHelper>();
		ReportHelper finalreporthelper = new ReportHelper();

		headersList.add("SLNO");
		headersList.add("Type @S");
		headersList.add("Trip Sheet Number");
		headersList.add("Asset Number");
		headersList.add("TC Lease Name");
		headersList.add("Organization/Trader Name");
		headersList.add("Issued Date Time");
		headersList.add("Validity Date Time");
		headersList.add("Grade / Type");
		headersList.add("Route");
		headersList.add("RMK/Order");
		headersList.add("W B @S");
		headersList.add("Status");
		headersList.add("Tare W @ S");
		headersList.add("Gross W @ S");
		headersList.add("Net W @ S");
		headersList.add("Type @ D");
		headersList.add("Gross W @ D");
		headersList.add("Tare W @ D");
		headersList.add("Net W @ D");
		headersList.add("W B @ D");
		headersList.add("Net weight Difference(Kgs)");
		headersList.add("Closing Type");
		headersList.add("Actual Quantity");
		headersList.add("Permit Id");
		headersList.add("MIneral Type");
		headersList.add("Closed DateTime");
		headersList.add("Source Storage Location");
		headersList.add("Destination Storage Location");
		headersList.add("Transaction No");
		headersList.add("Communicating Status");
		headersList.add("Trip Transfer Reason");
		headersList.add("Opening Datetime");
		headersList.add("Opening Location");
		headersList.add("Closing Datetime");
		headersList.add("Closing Location");

		try {
			con = DBConnection.getConnectionToDB("AMS");
			if (status.equalsIgnoreCase("open")) {
				pstmt52 = con.prepareStatement(IronMiningStatement.GET_MINING_TRIP_SHEET_GENERATION_DETAILS
						.replaceAll("&", " and a.STATUS IN ('OPEN')"));
			} else if (status.equalsIgnoreCase("close")) {
				pstmt52 = con.prepareStatement(IronMiningStatement.GET_MINING_TRIP_SHEET_GENERATION_DETAILS
						.replaceAll("&", " and a.STATUS IN ('CLOSE')"));
			} else if (status.equalsIgnoreCase("others")) {
				pstmt52 = con.prepareStatement(IronMiningStatement.GET_MINING_TRIP_SHEET_GENERATION_DETAILS
						.replaceAll("&", " and a.STATUS NOT IN ('OPEN','CLOSE')"));
			} else if (status.equalsIgnoreCase("All")) {
				pstmt52 = con.prepareStatement(
						IronMiningStatement.GET_MINING_TRIP_SHEET_GENERATION_DETAILS.replaceAll("&", " "));
			}
			pstmt52.setInt(1, systemId);
			pstmt52.setInt(2, CustomerId);
			pstmt52.setString(3, fromDate);
			pstmt52.setString(4, endDate);
			pstmt52.setInt(5, userId);
			pstmt52.setInt(6, systemId);
			pstmt52.setInt(7, userId);
			pstmt52.setInt(8, systemId);
			pstmt52.setInt(9, systemId);
			pstmt52.setInt(10, CustomerId);
			pstmt52.setString(11, fromDate);
			pstmt52.setString(12, endDate);
			pstmt52.setInt(13, userId);
			pstmt52.setInt(14, systemId);
			pstmt52.setInt(15, userId);
			pstmt52.setInt(16, systemId);
			rs52 = pstmt52.executeQuery();
			while (rs52.next()) {
				JsonObject = new JSONObject();
				ArrayList<Object> informationList = new ArrayList<Object>();
				ReportHelper reporthelper = new ReportHelper();
				aslcount++;
				JsonObject.put("slnoIndex", aslcount);
				informationList.add(aslcount);

				JsonObject.put("uniqueIDIndex", rs52.getString("ID"));

				JsonObject.put("TypeIndex", rs52.getString("TYPE").toUpperCase());
				informationList.add(rs52.getString("TYPE").toUpperCase());

				JsonObject.put("TripSheetNumberIndex", rs52.getString("TRIP_NO").toUpperCase());
				informationList.add(rs52.getString("TRIP_NO").toUpperCase());

				JsonObject.put("assetNoIndex", rs52.getString("ASSET_NUMBER").toUpperCase());
				informationList.add(rs52.getString("ASSET_NUMBER").toUpperCase());

				JsonObject.put("tcLeaseNoIndex", rs52.getString("LESSE_NAME"));
				informationList.add(rs52.getString("LESSE_NAME").toUpperCase());

				JsonObject.put("orgNameIndex", rs52.getString("ORGANIZATION_NAME"));
				informationList.add(rs52.getString("ORGANIZATION_NAME").toUpperCase());

				JsonObject.put("issuedIndexId", diffddMMyyyyHHmmss.format(rs52.getTimestamp(("ISSUE_DATE"))));
				informationList.add(diffddMMyyyyHHmmss.format(rs52.getTimestamp(("ISSUE_DATE"))));

				JsonObject.put("isClosableIndexId", rs52.getString("CLIENT_CLOSABLE"));
				JsonObject.put("issuedBy", rs52.getString("ISSUED_BY"));

				if (rs52.getTimestamp("VALIDITY_DATE") == null || rs52.getString("VALIDITY_DATE").equals("")
						|| rs52.getString("VALIDITY_DATE").contains("1900")) {
					JsonObject.put("validityDateDataIndex", "");
					informationList.add("");
				} else {
					JsonObject.put("validityDateDataIndex",
							diffddMMyyyyHHmmss.format(rs52.getTimestamp("VALIDITY_DATE")));
					informationList.add(diffddMMyyyyHHmmss.format(rs52.getTimestamp("VALIDITY_DATE")));
				}

				JsonObject.put("gradeAndMineralIndex", rs52.getString("GRADE_NAME"));
				informationList.add(rs52.getString("GRADE_NAME").toUpperCase());

				JsonObject.put("RouteIndex", rs52.getString("ROUTE_NAME"));
				informationList.add(rs52.getString("ROUTE_NAME").toUpperCase());

				JsonObject.put("OrderIndex", rs52.getString("DRIVER_NAME"));
				informationList.add(rs52.getString("DRIVER_NAME"));

				JsonObject.put("wbsIndex", rs52.getString("WBS"));
				informationList.add(rs52.getString("WBS"));

				JsonObject.put("statusIndexId", rs52.getString("STATUS"));
				informationList.add(rs52.getString("STATUS").toUpperCase());

				JsonObject.put("q1IndexId", rs52.getString("QUANTITY1"));
				informationList.add(rs52.getString("QUANTITY1").toUpperCase());

				JsonObject.put("QuantityIndex", String.valueOf(rs52.getString("QUANTITY2")).split("\\.")[0]);
				informationList.add(String.valueOf(rs52.getString("QUANTITY2")).split("\\.")[0]);

				JsonObject.put("netIndexId", df.format(rs52.getFloat("QUANTITY2") - rs52.getFloat("QUANTITY1")));
				informationList.add(df.format(rs52.getFloat("QUANTITY2") - rs52.getFloat("QUANTITY1")));

				String netwtSource = df.format(rs52.getFloat("QUANTITY2") - rs52.getFloat("QUANTITY1"));
				JsonObject.put("typedestIndex", rs52.getString("DESTINATION_TYPE"));
				informationList.add(rs52.getString("DESTINATION_TYPE"));

				if (rs52.getFloat("QUANTITY3") == 0.0) {
					JsonObject.put("q2IndexId", "");
					informationList.add("");
				} else {
					JsonObject.put("q2IndexId", rs52.getString("QUANTITY3"));
					informationList.add(rs52.getString("QUANTITY3"));
				}

				if (rs52.getFloat("QUANTITY4") == 0.0) {
					JsonObject.put("q3IndexId", "");
					informationList.add("");
				} else {
					JsonObject.put("q3IndexId", rs52.getString("QUANTITY4"));
					informationList.add(rs52.getString("QUANTITY4"));
				}

				JsonObject.put("netWghtDestIndex", df.format(rs52.getFloat("QUANTITY3") - rs52.getFloat("QUANTITY4")));
				informationList.add(df.format(rs52.getFloat("QUANTITY3") - rs52.getFloat("QUANTITY4")));

				String netWghtDest = df.format(rs52.getFloat("QUANTITY3") - rs52.getFloat("QUANTITY4"));

				JsonObject.put("wbdIndex", rs52.getString("WBD"));
				informationList.add(rs52.getString("WBD"));

				JsonObject.put("diffBtwWeight",
						df.format(Double.parseDouble(netwtSource) - Double.parseDouble(netWghtDest)));
				informationList.add(df.format(Double.parseDouble(netwtSource) - Double.parseDouble(netWghtDest)));

				JsonObject.put("closingTypeDataIndex", rs52.getString("CLOSING_TYPE"));
				informationList.add(rs52.getString("CLOSING_TYPE"));

				JsonObject.put("actualQtyIndexId", rs52.getString("TRIPSHEET_QTY"));
				informationList.add(rs52.getString("TRIPSHEET_QTY"));

				JsonObject.put("permitIndexId", rs52.getString("PERMIT_ID"));
				informationList.add(rs52.getString("PERMIT_ID"));

				JsonObject.put("mineralTypeIndexId", rs52.getString("MINERAL_TYPE"));
				informationList.add(rs52.getString("MINERAL_TYPE"));

				if (rs52.getString(("CLOSED_DATETIME")).contains("1900")) {
					JsonObject.put("closedDateIndexId", "");
					informationList.add("");
				} else {
					JsonObject.put("closedDateIndexId",
							diffddMMyyyyHHmmss.format(rs52.getTimestamp(("CLOSED_DATETIME"))));
					informationList.add(diffddMMyyyyHHmmss.format(rs52.getTimestamp(("CLOSED_DATETIME"))));
				}

				JsonObject.put("dsSourceIndex", rs52.getString("DS_SOURCE"));
				informationList.add(rs52.getString("DS_SOURCE"));

				JsonObject.put("dsdestIndex", rs52.getString("DS_DESTINATION"));
				informationList.add(rs52.getString("DS_DESTINATION"));

				JsonObject.put("transactnIndex", rs52.getString("TRANSACTION_ID"));
				informationList.add(rs52.getString("TRANSACTION_ID"));

				JsonObject.put("commStatus", rs52.getString("COMMUNICATION_STATUS"));
				informationList.add(rs52.getString("COMMUNICATION_STATUS"));

				JsonObject.put("reasonIndex", rs52.getString("REASON"));
				informationList.add(rs52.getString("REASON"));

				if (rs52.getString(("OPENING_DATETIME")).contains("1900")) {
					JsonObject.put("lastCommDateIndex", "");
					informationList.add("");
				} else {
					JsonObject.put("lastCommDateIndex",
							diffddMMyyyyHHmmss.format(rs52.getTimestamp(("OPENING_DATETIME"))));
					informationList.add(diffddMMyyyyHHmmss.format(rs52.getTimestamp(("OPENING_DATETIME"))));
				}
				if (!rs52.getString(("OPENING_LOCATION")).startsWith("Inside") && !rs52.getString(("OPENING_LOCATION")).startsWith("At")){
					String openingloc="<html><span style=color:red;>"+rs52.getString("OPENING_LOCATION")+"</span></html>";
					JsonObject.put("lastCommLocIndex",openingloc);
					informationList.add(rs52.getString("OPENING_LOCATION"));		
				}
				else
				{
					JsonObject.put("lastCommLocIndex", rs52.getString("OPENING_LOCATION"));
					informationList.add(rs52.getString("OPENING_LOCATION"));		
				}

				if (rs52.getString(("CLOSING_DATETIME")).contains("1900")) {
					JsonObject.put("lastCommDateClosingIndex", "");
					informationList.add("");
				} else {
					JsonObject.put("lastCommDateClosingIndex",
					diffddMMyyyyHHmmss.format(rs52.getTimestamp(("CLOSING_DATETIME"))));
					informationList.add(diffddMMyyyyHHmmss.format(rs52.getTimestamp(("CLOSING_DATETIME"))));
				}
				if (!rs52.getString(("CLOSING_LOCATION")).startsWith("Inside") && !rs52.getString(("CLOSING_LOCATION")).startsWith("At")){
					String closingloc="<span style=color:red;>"+rs52.getString("CLOSING_LOCATION")+"</span>";
					JsonObject.put("lastCommLocClosingIndex",closingloc);
					informationList.add(rs52.getString("CLOSING_LOCATION"));
				}
				else
				{
				JsonObject.put("lastCommLocClosingIndex", rs52.getString("CLOSING_LOCATION"));
				informationList.add(rs52.getString("CLOSING_LOCATION"));
				}
				JsonObject.put("tcLeaseNoIndexId", rs52.getString("TC_ID"));

				JsonObject.put("RouteIndexId", rs52.getString("ROUTE_ID"));

				JsonObject.put("pIdIndexId", rs52.getInt("PID"));

				JsonArray.put(JsonObject);
				reporthelper.setInformationList(informationList);
				reportsList.add(reporthelper);
			}
			assetLists.add(JsonArray);
			finalreporthelper.setReportsList(reportsList);
			finalreporthelper.setHeadersList(headersList);
			assetLists.add(finalreporthelper);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {

			DBConnection.releaseConnectionToDB(con, pstmt52, rs52);
		}
		return assetLists;
	}
	//-----------------------------------------saveTripSheetDetailsInformation--------------------------------------------------------------------//

	public String saveTripSheetDetailsInformation(int customerId, String type, String assetNo, String leaseName,
			String quantity, String validityDateTime, String grade, String routeId, int userId, int systemId,
			String custName, String quantity1, String srcHubId, String desHubId, String permitNo, int pId,
			float actualQuantity, int userSettingId, int orgCode, String gradetype, String rsSource,
			String rsDestination, String transactionNo, String nonCommHrs, String order, Connection conAdmin,
			String lastCommDate, String lastCommLoc, String commStatus, String sessionid) {
		float actualPermitQuantity = 0;
		String message = "";
		//Connection conAdmin = null;
		PreparedStatement pstmt55 = null;
		PreparedStatement pstmt1 = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		ResultSet rs55 = null;
		float permitqty = 0;
		float permitusedqty = 0;
		float permitusedqtyintotons = 0;
		float permitbal = 0;
		DecimalFormat df = new DecimalFormat();
		boolean tripsheetexists = true;
		LogWriter logWriter = null;
		int buyOrgId = 0;
		String permittype = "";
		String mineraltype = "";
		String permitNo1 = "";
		int sorceHubDB = 0;
		int tripCount = 0;
		int count1 = 0;
		int count2 = 0;
		int sessionCount = 0;
		int tripLimit = 0;
		String operationType = "";
		String tableName = "";
		try {
			int inserted = 0;
			int tripSheetNo = 0;
			actualQuantity = Float.parseFloat(quantity) - Float.parseFloat(quantity1);
			Properties properties = ApplicationListener.prop;
			String logFile = properties.getProperty("LogFileForTruckTripsheet");
			String logFileName = logFile.substring(0, logFile.lastIndexOf("."));
			String logFileExt = logFile.substring(logFile.lastIndexOf(".") + 1, logFile.length());
			logFile = logFileName + "-" + sdf.format(new Date()) + "." + logFileExt;

			PrintWriter pw;

			if (logFile != null) {
				try {
					pw = new PrintWriter(new FileWriter(logFile, true), true);
					logWriter = new LogWriter("saveTripSheetDetailsInformation" + "--" + sessionid + "--" + userId,
							LogWriter.INFO, pw);
					logWriter.setPrintWriter(pw);
				} catch (IOException e) {
					logWriter.log("Can't open the log file: " + logFile + ". Using System.err instead",
							LogWriter.ERROR);
				}
			}
			logWriter.log(" Begining of the method ", LogWriter.INFO);
			tableName = "AMS.dbo.TRIP_SHEET_USER_SETTINGS";
			pstmt = conAdmin.prepareStatement(IronMiningStatement.GET_PERMIT_NO);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, customerId);
			pstmt.setInt(3, userId);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				permitNo1 = rs.getString("PERMIT_IDS");
			}
			if (!permitNo1.equals("")) {
				tableName = "AMS.dbo.MINING_PERMIT_DETAILS";
				rs = util.getPermitTripSheet(customerId, assetNo, systemId, pId, conAdmin, permitNo1);
				while (rs.next()) {
					if (rs.getInt("CHALLAN_ID") > 0) {
						permitqty = rs.getFloat("QUANTITY");
					} else {
						permitqty = rs.getFloat("POTQUANTITY");
					}

					permitusedqty = rs.getFloat("TRIPSHEET_QTY");
					permitusedqtyintotons = permitusedqty / 1000;
					if (rs.getInt("CHALLAN_ID") > 0) {
						permitbal = rs.getFloat("QUANTITY") - permitusedqtyintotons;
					} else {
						permitbal = rs.getFloat("POTQUANTITY") - permitusedqtyintotons;
					}
					if (rs.getString("TRIP_STATUS").equalsIgnoreCase("OPEN")) {
						tripsheetexists = false;
					}
					buyOrgId = rs.getInt("BUYING_ORG_ID");
					tripSheetNo = rs.getInt("TRIPSHEET_NO");
					tripSheetNo++;
					actualPermitQuantity = rs.getFloat("ACTUAL_QUANTITY");
					permittype = rs.getString("PERMIT_TYPE");
					mineraltype = rs.getString("MINERAL");
				}
				float actualqtyintons = actualQuantity / 1000;
				logWriter.log("Permitbal==" + permitbal + " Actualqtyintons==" + actualqtyintons + " tripsheetexists=="
						+ tripsheetexists, LogWriter.INFO);
				if (permitbal >= actualqtyintons && tripsheetexists) {
					Calendar gcalendar = new GregorianCalendar();
					int year = gcalendar.get(Calendar.YEAR);
					Calendar cal = Calendar.getInstance();
					String curyear = String.valueOf(year);
					String curmonth = new SimpleDateFormat("MM").format(cal.getTime());
					System.out.println(curmonth);

					//			synchronized (this) {
					//			logWriter.log("in synchronized block "+new Date(),LogWriter.INFO);
					tableName = "MINING.dbo.TRUCK_TRIP_DETAILS";
					rs = util.getPermitCount(systemId, pId, conAdmin);
					if (rs.next()) {
						if (rs.getInt("TRIP_COUNT") > 0) {
							tripSheetNo = rs.getInt("TRIP_COUNT");
							tripSheetNo++;
						}
					}
					//----leading Zeros handling----------------------//  
					String tripSheetNotoGrid = "";
					if (String.valueOf(tripSheetNo).length() <= 5) {
						tripSheetNotoGrid = ("00000" + tripSheetNo).substring(String.valueOf(tripSheetNo).length());
					} else {
						tripSheetNotoGrid = ("000000000" + tripSheetNo).substring(String.valueOf(tripSheetNo).length());
					}
					int uniqueId = 0;
					//-----Insert Mining Asset Enrolment details into MINING_ASSET_ENROLLMENT Table--------//
					logWriter.log(" TRIP NO== " + permitNo + "-" + tripSheetNotoGrid + " TYPE" + type + " VEHICLE NO=="
							+ assetNo + " GROSS WEIGHT==" + quantity + " TARE WEIGHT==" + quantity1 + " PERMIT NO=="
							+ permitNo + " GRADE TYPE== " + gradetype + " LEASE NAME==" + leaseName + " SOURCE HUBID=="
							+ srcHubId + " DESTINATION HUBID==" + desHubId + " RS SOURCE==" + rsSource
							+ " RS DESTINATION==" + rsDestination + "ORG CODE==" + orgCode, LogWriter.INFO);

					//					String currentyear = curyear.substring(Math.max(curyear.length() - 2, 0));
					tableName = "MINING.dbo.TRUCK_TRIP_DETAILS";
					rs = util.saveMiningTripSheetInformation(customerId, type, assetNo, leaseName, quantity,
							validityDateTime, grade, routeId, userId, systemId, quantity1, srcHubId, desHubId, permitNo,
							pId, userSettingId, orgCode, rsSource, rsDestination, transactionNo, order, conAdmin,
							lastCommDate, lastCommLoc, commStatus, tripSheetNo, tripSheetNotoGrid);
					if (rs.next()) {
						uniqueId = rs.getInt(1);
					}
					if (uniqueId > 0) {
						logWriter.log("TRIPSHEET INSERTED", LogWriter.INFO);
						tableName = "AMS.dbo.MINING_PERMIT_DETAILS";
						util.insertActualQuantity(pId, actualQuantity, conAdmin, tripSheetNo);

						tableName = "AMS.dbo.MINING_ASSET_ENROLLMENT";
						util.updateTripStatusInAssetEnrollment(customerId, assetNo, systemId, conAdmin, "OPEN");

						logWriter.log("TRIPSTATUS UPDATED", LogWriter.INFO);

						logWriter.log(" Updated permit balance actualPermitQuantity==" + actualPermitQuantity
								+ " actualQuantity==" + actualQuantity, LogWriter.INFO);

						message = String.valueOf(uniqueId);//"Trip Sheet Details Saved Successfully";
					} else {
						message = "0";//"Error in Saving Trip Sheet Details";
						logWriter.log("Error in Saving Trip Sheet Details", LogWriter.INFO);
					}
					//			}
				} else {
					message = "-1";//"Permit Balance is over. Please change permit";
					logWriter.log("Permit Balance is over. Please change permit", LogWriter.INFO);
				}
			} else {
				message = "-1";//"Permit is not associated";
				logWriter.log("Permit is not associated", LogWriter.INFO);
			}
			//}
		} catch (Exception e) {
			System.out.println("error in Trip Sheet Details :-save Trip Sheet Details" + e.toString());
			message = "0";
			StringWriter errors = new StringWriter();
			e.printStackTrace(new PrintWriter(errors));
			logWriter.log(errors.toString(), LogWriter.ERROR);
			e.printStackTrace();
			logWriter.log("Before inserting", LogWriter.INFO);
			if (conAdmin != null) {
				try {

					pstmt55 = conAdmin.prepareStatement(
							"insert into AMS.dbo.EmailQueue(Subject,Body,EmailList,SystemId) values (?,?,?,?)");
					pstmt55.setString(1, "error in saveTripSheetDetailsInformation for SystemId " + systemId
							+ " for TableName : " + tableName);
					pstmt55.setString(2, errors.toString());
					pstmt55.setString(3,
							"gayatri.p@telematics4u.com,praveen.c@telematics4u.com,namrata.d@telematics4u.com");
					pstmt55.setInt(4, systemId);
					pstmt55.executeUpdate();
					logWriter.log("Record inserted in EmailQueue", LogWriter.INFO);
				} catch (SQLException e1) {
					errors = new StringWriter();
					e1.printStackTrace(new PrintWriter(errors));
					logWriter.log(errors.toString(), LogWriter.ERROR);
					e1.printStackTrace();
				}
			}
		} finally {
			DBConnection.releaseConnectionToDB(null, pstmt55, rs55);
			DBConnection.releaseConnectionToDB(null, pstmt, rs);
			DBConnection.releaseConnectionToDB(null, pstmt1, rs);
		}
		logWriter.log(" Ending of the method ", LogWriter.INFO);
		return message;
	}

	//------------------------------------------------modifyTripSheetDetailsInformation-------------------------------------------------------------//

	public String modifyTripSheetDetailsInformation(int customerId, String type, String assetNo, String leaseName,
			String quantity, String validityDateTime, String grade, String routeId, int userId, int systemId,
			String custName, String leaseModify, String gradeModify, String routeModify, String uniqueId,
			String order) {
		String message = "";
		Connection conAdmin = null;
		try {
			conAdmin = DBConnection.getConnectionToDB("AMS");
			int updated = 0;

			updated = util.modifyTripSheetNoInformation(customerId, validityDateTime, grade, systemId, routeModify,
					uniqueId, order, conAdmin);

			if (updated > 0) {
				message = String.valueOf(uniqueId);//"Trip Sheet Details Modified Successfully";
			} else {
				message = "0";//"Trip Sheet Details is not possible for Modified of this Vehicles";
			}
		} catch (Exception e) {
			System.out.println("error in ModifyTripSheetDetails Function:-save Trip Sheet Details  " + e.toString());
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(conAdmin, null, null);
		}
		return message;
	}

	//-------------------------------------------------------------------------------------------------------------//
	public synchronized int getTripSheetNumber(Connection conAdmin, int systemId, int customerId, String curyear) {
		PreparedStatement pstmt550 = null;
		PreparedStatement pstmt55 = null;
		ResultSet rs550 = null;
		int enrolmentnonew = 0;
		try {
			pstmt550 = conAdmin.prepareStatement(IronMiningStatement.GET_ENROLLMENT_NUMBER, ResultSet.TYPE_FORWARD_ONLY,
					ResultSet.CONCUR_UPDATABLE);
			pstmt550.setString(1, "TRIP_SHEET_NUMBER");
			pstmt550.setInt(2, systemId);
			pstmt550.setInt(3, customerId);
			pstmt550.setString(4, curyear);
			rs550 = pstmt550.executeQuery();
			if (rs550.next()) {
				enrolmentnonew = rs550.getInt("VALUE");
				enrolmentnonew++;
				rs550.updateInt("VALUE", enrolmentnonew);
				rs550.rowUpdated();
				pstmt55 = conAdmin.prepareStatement(IronMiningStatement.UPDATE_ENROLLMENT_NO_TO_LOOKUP);
				pstmt55.setInt(1, enrolmentnonew);
				pstmt55.setString(2, "TRIP_SHEET_NUMBER");
				pstmt55.setInt(3, systemId);
				pstmt55.setInt(4, customerId);
				pstmt55.setString(5, curyear);
				pstmt55.executeUpdate();
			} else {
				enrolmentnonew++;
				pstmt55 = conAdmin.prepareStatement(IronMiningStatement.INSERT_ENROLLMENT_NUMBER_TO_LOOKUP);
				pstmt55.setString(1, "TRIP_SHEET_NUMBER");
				pstmt55.setInt(2, enrolmentnonew);
				pstmt55.setString(3, curyear);
				pstmt55.setInt(4, systemId);
				pstmt55.setInt(5, customerId);
				pstmt55.executeUpdate();
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(null, pstmt550, rs550);
			DBConnection.releaseConnectionToDB(null, pstmt55, null);
		}
		return enrolmentnonew;
	}

	//-------------------------------------GET MINING TRIP DETAILS FOR PDF--------------------------------------//
	public ArrayList<ArrayList<String>> getPrintTripSheet(int systemId, int clientId, String assetNo,
			String customerName, String buttonvalue, String uniqueId, String zone) {
		Connection conAdmin = null;
		PreparedStatement pstmt100 = null;
		ResultSet rs100 = null;
		ArrayList<String> finlist = new ArrayList<String>();
		ArrayList<ArrayList<String>> list = new ArrayList<ArrayList<String>>();
		SimpleDateFormat yyyymmdd = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		SimpleDateFormat ddmmyyyy = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");

		try {
			conAdmin = DBConnection.getConnectionToDB("AMS");

			pstmt100 = conAdmin
					.prepareStatement(cf.getLocationQuery(IronMiningStatement.GET_TRIP_DATA_FOR_PDF_MODIFY, zone));
			pstmt100.setInt(1, systemId);
			pstmt100.setInt(2, clientId);
			pstmt100.setString(3, assetNo);
			pstmt100.setString(4, uniqueId);
			rs100 = pstmt100.executeQuery();
			while (rs100.next()) {
				finlist.add(rs100.getString("TRIP_NO"));//0
				if (rs100.getString("VALIDITY_DATE") == "" || rs100.getString("VALIDITY_DATE").contains("1900")) {
					finlist.add("");//1
				} else {
					finlist.add(ddmmyyyy.format(yyyymmdd.parse(rs100.getString("VALIDITY_DATE"))));//1
				}

				finlist.add(rs100.getString("ASSET_NUMBER").toUpperCase());//2
				if (rs100.getString("LESSE_NAME") != null && !rs100.getString("LESSE_NAME").equals("")) {
					finlist.add(rs100.getString("LESSE_NAME").toUpperCase());//3
				} else {
					finlist.add(rs100.getString("ORGANIZATION_NAME").toUpperCase());//3
				}
				finlist.add(rs100.getString("QUANTITY"));//4
				if(rs100.getString("TRIP_NO").startsWith("RTP"))
				{
					finlist.add(rs100.getString("GRADE_NAME")+"(ROM)");//5	
				}
				else{
				finlist.add(rs100.getString("GRADE_NAME"));//5
				}
				finlist.add(rs100.getString("ROUTE_NAME").toUpperCase());//6
				//	finlist.add(rs100.getString("MINERALS"));//7
				finlist.add(rs100.getString("DISTANCE"));//8
				finlist.add(rs100.getString("SOURCE"));//9
				finlist.add(rs100.getString("DESTINATION"));//10

				finlist.add("");//11
				finlist.add("");//12
				finlist.add(rs100.getString("TARE_WEIGHT"));//13
				finlist.add(rs100.getString("TOTAL_QUANTITY"));//14
				if (rs100.getString("ISSUE_DATE") == "" || rs100.getString("ISSUE_DATE").contains("1900")) {
					finlist.add("");//15
				} else {
					finlist.add(ddmmyyyy.format(yyyymmdd.parse(rs100.getString("ISSUE_DATE"))));//15
				}

				finlist.add(rs100.getString("DS_SOURCE"));//16 
				finlist.add(rs100.getString("DS_DESTINATION"));//17 
				finlist.add(rs100.getString("TRANSACTION_ID"));//18
				finlist.add(rs100.getString("WEIGHBRIDGE_ID"));//19
				finlist.add(rs100.getString("GST_NO"));//20

			}
			list.add(finlist);
		} catch (Exception e) {
			e.printStackTrace();
			System.out.println("Inside pdf generation function" + e.toString());
		} finally {
			DBConnection.releaseConnectionToDB(conAdmin, pstmt100, rs100);
		}
		return list;
	}

	//-------------------------------------Grade Master Report Details --------------------------------------//
	public ArrayList<Object> getGradeMasterDetails(int systemid, String language, int Cust) {

		JSONArray JsonArray = new JSONArray();
		JSONObject JsonObject = null;
		ReportHelper reporthelper = null;
		ArrayList<Object> informationList = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		ArrayList<ReportHelper> reportsList = new ArrayList<ReportHelper>();
		ArrayList<String> headersList = new ArrayList<String>();
		ReportHelper finalreporthelper = new ReportHelper();
		ArrayList<Object> finlist = new ArrayList<Object>();
		DecimalFormat df = new DecimalFormat("##0.00");
		headersList.add("SLNO");
		headersList.add("Month");
		headersList.add("Year");
		headersList.add("Grade");
		headersList.add("IBM Rate");
		headersList.add("Royalty Rate (15%)");
		headersList.add("GIOPF Rate (10%)");
		headersList.add("Mineral Code");
		headersList.add("Type");
		headersList.add("ID");
		try {
			int count = 0;
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(IronMiningStatement.GET_GRADE_MASTER_DETAILS);
			pstmt.setInt(1, systemid);
			pstmt.setInt(2, Cust);
			rs = pstmt.executeQuery();

			while (rs.next()) {
				JsonObject = new JSONObject();
				reporthelper = new ReportHelper();
				informationList = new ArrayList<Object>();
				count++;
				JsonObject.put("slnoIndex", count);
				informationList.add(count);

				JsonObject.put("monthDataIndex", rs.getString("MONTH"));
				informationList.add(rs.getString("MONTH"));

				JsonObject.put("yearDataIndex", rs.getString("YEAR"));
				informationList.add(rs.getString("YEAR"));

				JsonObject.put("gradeDataIndex", rs.getString("GRADE"));
				informationList.add(rs.getString("GRADE"));

				double rate = rs.getDouble("RATE");
				JsonObject.put("rateDataIndex", rate);
				informationList.add(rate);

				JsonObject.put("rate1DataIndex", df.format(rate * 0.15));
				informationList.add(df.format(rate * 0.15));

				JsonObject.put("rate2DataIndex", df.format(rate * 0.1));
				informationList.add(df.format(rate * 0.1));

				JsonObject.put("mineralCodeDataIndex", rs.getString("MINERAL_CODE"));
				informationList.add(rs.getString("MINERAL_CODE"));

				JsonObject.put("typeDataIndex", rs.getString("TYPE"));
				informationList.add(rs.getString("TYPE"));

				JsonObject.put("IdDataIndex", rs.getString("ID"));
				informationList.add(rs.getString("ID"));

				JsonArray.put(JsonObject);
				reporthelper.setInformationList(informationList);
				reportsList.add(reporthelper);
			}
			finalreporthelper.setReportsList(reportsList);
			finalreporthelper.setHeadersList(headersList);
			finlist.add(JsonArray);
			finlist.add(finalreporthelper);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}

		return finlist;
	}

	// -------------------------------------Insert Grade Information-----------------------------------------------------------//
	public String insertGradeMasterInformations(String month, int year, JSONArray js, String mineralCode, String type,
			int CustId, int systemId, int userId) {
		Connection con = null;
		PreparedStatement pstmt = null;
		PreparedStatement pstmtop = null;
		ResultSet rs = null;
		String message = "";
		JSONObject obj = null;
		String grade;
		float rate;
		try {
			con = DBConnection.getConnectionToDB("AMS");
			for (int i = 0; i < js.length(); i++) {
				obj = js.getJSONObject(i);
				if (mineralCode.equals("Fe")) {
					grade = obj.getString("gradeIndex");
					rate = Float.parseFloat(obj.getString("rateIndex"));
				} else {
					grade = obj.getString("gradeIndex");
					rate = Float.parseFloat(obj.getString("rateIndex"));
				}
				if (rate > 0) {
					pstmtop = con.prepareStatement(IronMiningStatement.CHECK_RECORD_EXISTS);
					pstmtop.setInt(1, systemId);
					pstmtop.setInt(2, CustId);
					pstmtop.setString(3, month);
					pstmtop.setInt(4, year);
					pstmtop.setString(5, grade);
					pstmtop.setString(6, mineralCode);
					pstmtop.setString(7, type);
					rs = pstmtop.executeQuery();
					if (!rs.next()) {
						pstmt = con.prepareStatement(IronMiningStatement.INSERT_INTO_MASTER_DETAILS);
						pstmt.setString(1, month);
						pstmt.setInt(2, year);
						pstmt.setString(3, grade);
						pstmt.setFloat(4, rate);
						pstmt.setString(5, mineralCode);
						pstmt.setString(6, type);
						pstmt.setInt(7, systemId);
						pstmt.setInt(8, CustId);
						pstmt.setInt(9, userId);
						int inserted = pstmt.executeUpdate();
						if (inserted > 0) {
							message = "Grade Information Saved Successfully";
						}
					} else {
						message = "Record Already Exists";
					}
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(null, pstmtop, rs);
			DBConnection.releaseConnectionToDB(con, pstmt, null);
		}
		return message;
	}

	//----------------------------------------modify Grade Information-------------------------------------------//
	public String modifyGradeMasterInformation(int id, String month, int year, String grade, double rate,
			String mineralCode, String type, int CustId, int systemId, int userId) {
		Connection con = null;
		PreparedStatement pstmt = null;
		PreparedStatement pstmtop = null;
		String message = "";
		ResultSet rs = null;
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmtop = con.prepareStatement(IronMiningStatement.CHECK_RECORD_EXISTS + " and ID!=?");
			pstmtop.setInt(1, systemId);
			pstmtop.setInt(2, CustId);
			pstmtop.setString(3, month);
			pstmtop.setInt(4, year);
			pstmtop.setString(5, grade);
			pstmtop.setString(6, mineralCode);
			pstmtop.setString(7, type);
			pstmtop.setInt(8, id);
			rs = pstmtop.executeQuery();
			if (!rs.next()) {
				pstmt = con.prepareStatement(IronMiningStatement.UPDATE_GRADE_MASTER_INFORMATION);
				pstmt.setString(1, month);
				pstmt.setInt(2, year);
				pstmt.setString(3, grade);
				pstmt.setDouble(4, rate);
				pstmt.setString(5, mineralCode);
				pstmt.setString(6, type);
				pstmt.setInt(7, userId);
				pstmt.setInt(8, systemId);
				pstmt.setInt(9, CustId);
				pstmt.setInt(10, id);
				int updated = pstmt.executeUpdate();
				if (updated > 0) {
					message = "Grade Updated Successfully";
				}
			} else {
				message = "Record Already Exists";
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(null, pstmtop, rs);
			DBConnection.releaseConnectionToDB(con, pstmt, null);
		}
		return message;
	}

	//*************************************************Mineral Code Information **************************************************************//
	public JSONArray getMineralCode(int systemId, int CustId) {
		JSONArray JsonArray = null;
		JSONObject JsonObject = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			JsonArray = new JSONArray();
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(IronMiningStatement.GET_MINERAL_CODE);
			pstmt.setInt(1, systemId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				JsonObject = new JSONObject();
				JsonObject.put("Mineral", rs.getString("MINERAL_CODE"));
				JsonObject.put("Value", rs.getString("MINERAL_CODE"));
				JsonArray.put(JsonObject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return JsonArray;
	}
	//--------------------------------------TC Master Function :start-------------------------------------------//

	//***********************************District Information **********************************************//
	public JSONArray getDistrictNames(int systemId, int stateId) {
		JSONArray JsonArray = null;
		JSONObject JsonObject = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			JsonArray = new JSONArray();
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(IronMiningStatement.GET_DISTRICT);
			pstmt.setInt(1, stateId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				JsonObject = new JSONObject();
				JsonObject.put("District", rs.getString("DISTRICT_NAMES"));
				JsonObject.put("Value", rs.getString("DISTRICT_CODE"));
				JsonArray.put(JsonObject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return JsonArray;
	}

	//*************************************Taluk Information ***************************************//	
	public JSONArray getTalukNames(int systemId, int distId) {
		JSONArray JsonArray = null;
		JSONObject JsonObject = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			JsonArray = new JSONArray();
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(IronMiningStatement.GET_TALUK);
			pstmt.setInt(1, distId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				JsonObject = new JSONObject();
				JsonObject.put("Taluk", rs.getString("TALUK_NAME"));
				JsonObject.put("Value", rs.getString("TALUKA_CODE"));
				JsonArray.put(JsonObject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return JsonArray;
	}

	//-------------------------------------TC Master Report Details --------------------------------------//
	public ArrayList<Object> getTCMasterDetails(int systemid, String language, int Cust, String zone, int userId) {

		JSONArray JsonArray = new JSONArray();
		JSONObject JsonObject = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		ArrayList<Object> finlist = new ArrayList<Object>();
		ArrayList<ReportHelper> reportsList = new ArrayList<ReportHelper>();
		ArrayList<String> headersList = new ArrayList<String>();
		ReportHelper finalreporthelper = new ReportHelper();
		SimpleDateFormat diffddMMyyyy = new SimpleDateFormat("dd-MM-yyyy");
		DecimalFormat df = new DecimalFormat("##0.00");
		headersList.add("Sl No");
		headersList.add("REG IBM");
		headersList.add("Mine Code");
		headersList.add("Tc Number");
		headersList.add("Mineral Name");
		headersList.add("Lease Name");
		headersList.add("Name Of The Lessee");
		headersList.add("State");
		headersList.add("District");
		headersList.add("Taluka");
		headersList.add("Village");
		headersList.add("CTO_Code");
		headersList.add("CTO_Date");
		headersList.add("Post Office");
		headersList.add("Pin Code");
		headersList.add("Fax");
		headersList.add("Phone No");
		headersList.add("Email");
		headersList.add("Order Number");
		headersList.add("Order Date");
		headersList.add("Status");
		headersList.add("MPL Allocated");
		headersList.add("MPL Balance");
		headersList.add("MPL Used");
		headersList.add("ID");
		headersList.add("District Code");
		headersList.add("Taluk Code");
		headersList.add("State Code");
		headersList.add("Processing Plant");
		headersList.add("EC Linked");
		headersList.add("Amount Of ROM");
		headersList.add("Quantity Of ROM");
		headersList.add("Hub");
		headersList.add("Hub Id");
		headersList.add("Mine Code Id");
		headersList.add("Mine Name");
		headersList.add("Lease Area/Sqmt");
		headersList.add("Year");
		headersList.add("MPL Enhanced");
		headersList.add("MPL Production");
		headersList.add("MPL Carry Forward");
		headersList.add("MPL Transportation");
		try {
			int count = 0;
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(cf.getLocationQuery(IronMiningStatement.GET_TC_MASTER_DETAILS, zone));
			pstmt.setInt(1, systemid);
			pstmt.setInt(2, Cust);
			rs = pstmt.executeQuery();

			while (rs.next()) {
				ArrayList<Object> informationList = new ArrayList<Object>();
				ReportHelper reporthelper = new ReportHelper();
				count++;
				JsonObject = new JSONObject();

				JsonObject.put("slnoIndex", count);
				informationList.add(count);

				JsonObject.put("regIbmDataIndex", rs.getString("REG_IBM"));
				informationList.add(rs.getString("REG_IBM"));

				JsonObject.put("mineCodeDataIndex", rs.getString("MINE_CODE"));
				informationList.add(rs.getString("MINE_CODE"));

				JsonObject.put("TCNumberDataIndex", rs.getString("TC_NO"));
				informationList.add(rs.getString("TC_NO"));

				JsonObject.put("mineralNameDataIndex", rs.getString("NAME_OF_MINERAL"));
				informationList.add(rs.getString("NAME_OF_MINERAL"));

				JsonObject.put("MineNameDataIndex", rs.getString("NAME_OF_MINE"));
				informationList.add(rs.getString("NAME_OF_MINE"));

				JsonObject.put("NameOfTheIssueDataIndex", rs.getString("LESSE_NAME"));
				informationList.add(rs.getString("LESSE_NAME"));

				JsonObject.put("stateDataIndex", rs.getString("STATE_NAME"));
				informationList.add(rs.getString("STATE_NAME"));

				JsonObject.put("DistrictDataIndex", rs.getString("DISTRICT"));
				informationList.add(rs.getString("DISTRICT"));

				JsonObject.put("TalukDataIndex", rs.getString("TALUK"));
				informationList.add(rs.getString("TALUK"));

				JsonObject.put("VillageDataIndex", rs.getString("VILLAGE"));
				informationList.add(rs.getString("VILLAGE"));

				JsonObject.put("ctoCodeIndex", rs.getString("CTO_CODE"));
				informationList.add(rs.getString("CTO_CODE"));

				if (rs.getString("CTO_DATE") == null || rs.getString("CTO_DATE").equals("")
						|| rs.getString("CTO_DATE").contains("1900")) {
					JsonObject.put("ctoDateIndex", "");
					informationList.add("");
				} else {
					JsonObject.put("ctoDateIndex", rs.getString("CTO_DATE"));
					informationList.add(diffddMMyyyy.format(rs.getTimestamp("CTO_DATE")));
				}
				JsonObject.put("AreaDataIndex", rs.getString("AREA"));
				informationList.add(rs.getString("AREA"));

				JsonObject.put("pinDataIndex", rs.getString("PIN"));
				informationList.add(rs.getString("PIN"));

				JsonObject.put("faxNoDataIndex", rs.getString("FAX_NO"));
				informationList.add(rs.getString("FAX_NO"));

				JsonObject.put("phoneNoDataIndex", rs.getString("PHONE_NO"));
				informationList.add(rs.getString("PHONE_NO"));

				JsonObject.put("emailDataIndex", rs.getString("EMAIL_ID"));
				informationList.add(rs.getString("EMAIL_ID"));

				JsonObject.put("OrderNumberDataIndex", rs.getString("ORDER_NO"));
				informationList.add(rs.getString("ORDER_NO"));

				if (rs.getString("ISSUED_DATE") == null || rs.getString("ISSUED_DATE").equals("")
						|| rs.getString("ISSUED_DATE").contains("1900")) {
					JsonObject.put("DateIssuedDateDataIndex", "");
					informationList.add(rs.getString(""));
				} else {
					JsonObject.put("DateIssuedDateDataIndex", rs.getString("ISSUED_DATE"));
					informationList.add(diffddMMyyyy.format(rs.getTimestamp("ISSUED_DATE")));
				}

				JsonObject.put("StatusDataIndex", rs.getString("STATUS"));
				informationList.add(rs.getString("STATUS"));

				JsonObject.put("EcCappingLimitIndex", rs.getString("EC_CAPPING_LIMIT"));
				informationList.add(df.format(rs.getFloat("EC_CAPPING_LIMIT")));

				JsonObject.put("mplBalIndex",
						df.format(rs.getDouble("TRANSPORTATION_MPL") - rs.getDouble("MPL_BALANCE")));
				informationList.add(df.format(rs.getDouble("TRANSPORTATION_MPL") - rs.getDouble("MPL_BALANCE")));

				JsonObject.put("mplBalenceIndex", rs.getString("MPL_BALANCE"));
				informationList.add(df.format(rs.getFloat("MPL_BALANCE")));

				JsonObject.put("IdDataIndex", rs.getString("ID"));
				informationList.add(rs.getString("ID"));

				JsonObject.put("districtIdDataIndex", rs.getString("DISTRICT_CODE"));
				informationList.add(rs.getString("DISTRICT_CODE"));

				JsonObject.put("TalukIdDataIndex", rs.getString("TALUK_CODE"));
				informationList.add(rs.getString("TALUK_CODE"));

				JsonObject.put("stateIdDataIndex", rs.getString("STATE_ID"));
				informationList.add(rs.getString("STATE_ID"));

				JsonObject.put("processingPlantIndex", rs.getString("PROCESSING_PLANT"));
				informationList.add(rs.getString("PROCESSING_PLANT"));

				JsonObject.put("walletLinkedIndex", rs.getString("WALLET_LINKED"));
				informationList.add(rs.getString("WALLET_LINKED"));

				JsonObject.put("amountOfROMIndex", rs.getString("ROM_CHALLAN_PAID_AMOUNT"));
				informationList.add(df.format(rs.getFloat("ROM_CHALLAN_PAID_AMOUNT")));

				JsonObject.put("quantityOfROMIndex", rs.getString("ROM_CHALLAN_PAID_QUANTITY"));
				informationList.add(df.format(rs.getFloat("ROM_CHALLAN_PAID_QUANTITY")));

				JsonObject.put("hubIndex", rs.getString("HUB"));
				informationList.add(rs.getString("HUB"));

				JsonObject.put("hubIdIndex", rs.getString("HUBID"));
				informationList.add(rs.getString("HUBID"));

				JsonObject.put("MineCodeIdIndex", rs.getString("MINE_CODE_ID"));
				informationList.add(rs.getString("MINE_CODE_ID"));

				JsonObject.put("MineNameIdIndex", rs.getString("MINE_NAME"));
				informationList.add(rs.getString("MINE_NAME"));

				JsonObject.put("LeaseAreaIdIndex", rs.getString("LEASE_AREA"));
				informationList.add(rs.getString("LEASE_AREA"));

				JsonObject.put("yearIdIndex", rs.getString("YEAR"));
				informationList.add(rs.getString("YEAR"));

				JsonObject.put("MplenhanceLimitIdIndex", rs.getString("ENHANCED_MPL"));
				informationList.add(rs.getString("ENHANCED_MPL"));

				JsonObject.put("MPLproductionLimitIdIndex", rs.getString("PRODUCTION_MPL"));
				informationList.add(rs.getString("PRODUCTION_MPL"));

				JsonObject.put("MplCarryForwardLimitIdIndex", rs.getString("CARRY_FORWARDED_MPL"));
				informationList.add(rs.getString("CARRY_FORWARDED_MPL"));

				JsonObject.put("MpltransportationLimitIdIndex", rs.getString("TRANSPORTATION_MPL"));
				informationList.add(rs.getString("TRANSPORTATION_MPL"));

				JsonArray.put(JsonObject);
				reporthelper.setInformationList(informationList);
				reportsList.add(reporthelper);
			}
			finlist.add(JsonArray);
			finalreporthelper.setReportsList(reportsList);
			finalreporthelper.setHeadersList(headersList);
			finlist.add(finalreporthelper);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}

		return finlist;
	}

	//-------------------------------------Insert TC Master Information-----------------------------------------------------------//
	public String insertTCMasterInformation(String tcNumber, String nameOfTheIssue, String OrderNuber,
			String isuuedDate, int district, String taluk, String village, String postOffice, String status, int CustId,
			int systemId, String regIbm, String mineCode, String mineralName, String mineName, int state, int pin,
			String faxNo, String phoneNo, String emailId, int userId, float EcCappingLimit, String processingPlant,
			String walletLinked, int hub, String mineCodeValue, String minenamee, double leasearea, int year,
			String ctoCode, String ctoDate, String mplEnh, String mplProd, String mpltCarry, String mplTrans,
			String financial) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		ResultSet rs1 = null;
		PreparedStatement pstmttop2 = null;
		PreparedStatement pstmttop1 = null;
		String message = "";
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmttop1 = con.prepareStatement(IronMiningStatement.CHECK_REG_IBM_NO.replace("#", ""));
			pstmttop1.setInt(1, systemId);
			pstmttop1.setInt(2, CustId);
			pstmttop1.setString(3, regIbm);
			rs = pstmttop1.executeQuery();

			if (!rs.next()) {
				pstmttop2 = con.prepareStatement(IronMiningStatement.CHECK_TC_NO);
				pstmttop2.setInt(1, systemId);
				pstmttop2.setInt(2, CustId);
				pstmttop2.setString(3, tcNumber);
				rs1 = pstmttop2.executeQuery();

				if (!rs1.next()) {
					pstmt = con.prepareStatement(IronMiningStatement.INSERT_INTO_TCMASTER_DETAILS);
					pstmt.setString(1, tcNumber);
					pstmt.setString(2, nameOfTheIssue);
					pstmt.setString(3, OrderNuber);
					pstmt.setString(4, isuuedDate);
					pstmt.setInt(5, district);
					pstmt.setString(6, taluk);
					pstmt.setString(7, village);
					pstmt.setString(8, postOffice);
					pstmt.setString(9, status);
					pstmt.setInt(10, systemId);
					pstmt.setInt(11, CustId);
					pstmt.setString(12, regIbm);
					pstmt.setString(13, mineCodeValue);
					pstmt.setString(14, mineralName);
					pstmt.setString(15, mineName);
					pstmt.setInt(16, state);
					pstmt.setInt(17, pin);
					pstmt.setString(18, faxNo);
					pstmt.setString(19, phoneNo);
					pstmt.setString(20, emailId);
					pstmt.setInt(21, userId);
					pstmt.setFloat(22, EcCappingLimit);
					pstmt.setString(23, processingPlant);
					pstmt.setString(24, walletLinked);
					pstmt.setInt(25, hub);
					pstmt.setInt(26, Integer.parseInt(mineCode));
					pstmt.setString(27, minenamee);
					pstmt.setDouble(28, leasearea);
					pstmt.setInt(29, year);
					pstmt.setString(30, ctoCode);
					pstmt.setString(31, ctoDate);
					pstmt.setString(32, mplEnh);
					pstmt.setString(33, mplProd);
					pstmt.setString(34, mpltCarry);
					pstmt.setString(35, mplTrans);
					pstmt.setString(36, financial);
					int inserted = pstmt.executeUpdate();
					if (inserted > 0) {
						message = "Saved Successfully";
					}
				} else {
					message = "TC Number Already Exists";
				}
			} else {
				message = "REG IBM Already Exists";
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(null, pstmttop1, rs);
			DBConnection.releaseConnectionToDB(null, pstmttop2, rs1);
			DBConnection.releaseConnectionToDB(con, pstmt, null);
		}
		return message;
	}

	//----------------------------------------modify TCMaster Information-------------------------------------------//
	public String modifyTCMasterInformation(int id, String tcNumber, String nameOfTheIssue, String OrderNuber,
			String isuuedDate, int district, int taluk, String village, String postOffice, String status, int CustId,
			int systemId, String regIbm, String mineCodeModify, String mineralName, String mineName, int state, int pin,
			String faxNo, String phoneNo, String emailId, int userId, float EcCappingLimit, String processingPlant,
			String walletLinked, int hub, String mineCodeValue, String minenamee, double leasearea, int year,
			String ctoCode, String ctoDate, String mplEnh, String mplProd, String mplCarry, String mplTrans) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		PreparedStatement pstmttop1 = null;
		String message = "";
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmttop1 = con.prepareStatement(IronMiningStatement.CHECK_REG_IBM_NO.replace("#", "and ID!=?"));
			pstmttop1.setInt(1, systemId);
			pstmttop1.setInt(2, CustId);
			pstmttop1.setString(3, regIbm);
			pstmttop1.setInt(4, id);
			rs = pstmttop1.executeQuery();
			if (!rs.next()) {
				pstmt = con.prepareStatement(IronMiningStatement.UPDATE_TCMASTER_INFORMATION);
				pstmt.setString(1, tcNumber);
				pstmt.setString(2, nameOfTheIssue);
				pstmt.setString(3, OrderNuber);
				pstmt.setString(4, isuuedDate);
				pstmt.setInt(5, district);
				pstmt.setInt(6, taluk);
				pstmt.setString(7, village);
				pstmt.setString(8, postOffice);
				pstmt.setString(9, status);
				pstmt.setString(10, regIbm);
				pstmt.setString(11, mineCodeValue);
				pstmt.setString(12, mineralName);
				pstmt.setString(13, mineName);
				pstmt.setInt(14, state);
				pstmt.setInt(15, pin);
				pstmt.setString(16, faxNo);
				pstmt.setString(17, phoneNo);
				pstmt.setFloat(18, EcCappingLimit);
				pstmt.setString(19, emailId);
				pstmt.setInt(20, userId);
				pstmt.setString(21, processingPlant);
				pstmt.setString(22, walletLinked);
				pstmt.setInt(23, hub);
				pstmt.setInt(24, Integer.parseInt(mineCodeModify));
				pstmt.setString(25, minenamee);
				pstmt.setDouble(26, leasearea);
				pstmt.setInt(27, year);
				pstmt.setString(28, ctoCode);
				pstmt.setString(29, ctoDate);
				pstmt.setString(30, mplEnh);
				pstmt.setString(31, mplProd);
				pstmt.setString(32, mplCarry);
				pstmt.setString(33, mplTrans);
				pstmt.setInt(34, systemId);
				pstmt.setInt(35, CustId);
				pstmt.setInt(36, id);

				int updated = pstmt.executeUpdate();
				if (updated > 0) {
					//System.out.println("tcNumber="+tcNumber+" ,LEASE_NAME ="+nameOfTheIssue+", NAME ="+mineName+", STATE ="+state+" ,DISTRICT ="+district+" ,TALUKA ="+taluk+" , POST_OFFICE="+postOffice+" , VILLAGE="+village+" ,PIN="+pin+" ,FAX_NO="+faxNo+" ,PHONE="+phoneNo+" ,EMAIL_ID="+emailId+" ,YEAR"+year);
					pstmt = con.prepareStatement(IronMiningStatement.UPDATE_TCMASTER_INFORMATION_OWNER_MASTER);
					pstmt.setInt(1, year);
					pstmt.setString(2, nameOfTheIssue);
					pstmt.setString(3, mineName);
					pstmt.setInt(4, state);
					pstmt.setInt(5, district);
					pstmt.setInt(6, taluk);
					pstmt.setString(7, postOffice);
					pstmt.setString(8, village);
					pstmt.setInt(9, pin);
					pstmt.setString(10, faxNo);
					pstmt.setString(11, phoneNo);
					pstmt.setString(12, emailId);
					pstmt.setInt(13, systemId);
					pstmt.setInt(14, CustId);
					pstmt.setString(15, tcNumber);

					pstmt.executeUpdate();
					//System.out.println("Updated"+updated1+" rows");
					message = "Updated Successfully";
				} else {
					message = "Error";
				}
			} else {
				message = "REG IBM Already Exists";
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(null, pstmttop1, rs);
			DBConnection.releaseConnectionToDB(con, pstmt, null);
		}
		return message;
	}

	//-----------------------------------------Mining Mineral Master Report Details------------------------------------//
	@SuppressWarnings("unchecked")
	public ArrayList getMineMasterDetails(int systemId, int customerId) {
		JSONArray JsonArray = new JSONArray();
		JSONObject JsonObject = null;
		Connection con = null;
		PreparedStatement pstmt2 = null;
		ResultSet rs2 = null;
		int slcount = 0;
		ArrayList aslist = new ArrayList();
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt2 = con.prepareStatement(IronMiningStatement.GET_MINE_MASTER_DETAILS);
			pstmt2.setInt(1, systemId);
			rs2 = pstmt2.executeQuery();
			while (rs2.next()) {
				JsonObject = new JSONObject();
				slcount++;
				JsonObject.put("slnoIndex", slcount);

				JsonObject.put("mineralCodeDataIndex", rs2.getString("MINERAL_CODE"));

				JsonObject.put("mineralNameIndex", rs2.getString("MINERAL_NAME"));

				JsonObject.put("uniqueIdDataIndex", rs2.getString("ID"));

				JsonArray.put(JsonObject);
			}
			aslist.add(JsonArray);

		} catch (Exception e) {
			e.printStackTrace();
		} finally {

			DBConnection.releaseConnectionToDB(con, pstmt2, rs2);
		}
		return aslist;
	}

	public String addMineraldetails(String Mineral_Code, String Mineral_Name, int systemId, int customerId) {

		Connection con = null;
		PreparedStatement pstmt = null;
		PreparedStatement pstmt1 = null;
		PreparedStatement pstmttop = null;
		ResultSet rs = null;
		ResultSet rs1 = null;
		String message = "";

		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt1 = con.prepareStatement(IronMiningStatement.CHECK_CODE_ALREADY_EXIST);
			pstmt1.setString(1, Mineral_Code);
			pstmt1.setInt(2, systemId);
			rs = pstmt1.executeQuery();
			if (!rs.next()) {
				pstmttop = con.prepareStatement(IronMiningStatement.CHECK_MINERAL_NAME_ALREADY_EXIST);
				pstmttop.setString(1, Mineral_Name);
				pstmttop.setInt(2, systemId);
				rs1 = pstmttop.executeQuery();

				if (!rs1.next()) {
					pstmt = con.prepareStatement(IronMiningStatement.INSERT_MINERALS_INFORMATION);
					pstmt.setString(1, Mineral_Code);
					pstmt.setString(2, Mineral_Name);
					pstmt.setInt(3, systemId);
					int inserted = pstmt.executeUpdate();
					if (inserted > 0) {
						message = "Saved Successfully";
					}
				} else {
					message = "Mineral Name Already Exists";
				}
			} else {
				message = "MineralCode Already Exist";
			}
		} catch (Exception e) {
			System.out.println("error in:-save MineMaster details " + e.toString());
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(null, pstmt1, rs);
			DBConnection.releaseConnectionToDB(null, pstmttop, rs1);
			DBConnection.releaseConnectionToDB(con, pstmt, null);
		}
		return message;

	}

	public String modifyMineralMaster(String Mineral_Code, String Mineral_Name, int systemId, int custId, int id) {
		Connection con = null;
		PreparedStatement pstmt = null;
		PreparedStatement pstmt1 = null;
		PreparedStatement pstmttop = null;
		ResultSet rs = null;
		ResultSet rs1 = null;
		String message = "";
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt1 = con.prepareStatement(IronMiningStatement.CHECK_CODE_ALREADY_EXIST);
			pstmt1.setString(1, Mineral_Code);
			rs = pstmt1.executeQuery();
			if (!rs.next()) {
				pstmttop = con.prepareStatement(IronMiningStatement.CHECK_MINERAL_NAME_ALREADY_EXIST);
				pstmttop.setString(1, Mineral_Name);
				rs1 = pstmttop.executeQuery();

				if (!rs1.next()) {
					pstmt = con.prepareStatement(IronMiningStatement.UPDATE_NAME);
					pstmt.setString(1, Mineral_Code);
					pstmt.setString(2, Mineral_Name);
					pstmt.setInt(3, id);
					int updated = pstmt.executeUpdate();
					if (updated > 0) {
						message = "Updated Successfully";
					}
				} else {
					message = "Mineral Name Already Exists";
				}
			} else {
				message = "MineralCode Already Exist";
			}
		} catch (Exception e) {
			System.out.println("error in :-update MineMaster details " + e.toString());
			e.printStackTrace();
		}

		finally {
			DBConnection.releaseConnectionToDB(null, pstmt1, rs);
			DBConnection.releaseConnectionToDB(null, pstmttop, rs1);
			DBConnection.releaseConnectionToDB(con, pstmt, null);
		}
		return message;
	}

	//-----------------------------------------ACCOUNTS HEAD MASTER Report Details------------------------------------//

	public ArrayList getAccountsHeadMasterDetails(int systemId, int customerId) {
		JSONArray JsonArray = new JSONArray();
		JSONObject JsonObject = null;
		Connection con = null;
		PreparedStatement pstmt2 = null;
		ResultSet rs2 = null;
		int slcount = 0;
		ArrayList aslist = new ArrayList();
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt2 = con.prepareStatement(IronMiningStatement.GET_ACCOUNTS_HEAD_MASTER_DETAILS);
			pstmt2.setInt(1, systemId);
			pstmt2.setInt(2, customerId);
			rs2 = pstmt2.executeQuery();
			while (rs2.next()) {
				JsonObject = new JSONObject();
				slcount++;
				JsonObject.put("slnoIndex", slcount);

				JsonObject.put("paymentHeadDataIndex", rs2.getString("PAYMENT_ACCOUNTS_HEAD"));

				JsonObject.put("descriptionDataIndex", rs2.getString("DESCRIPTION"));

				JsonObject.put("uniqueIdDataIndex", rs2.getString("ID"));

				JsonArray.put(JsonObject);
			}
			aslist.add(JsonArray);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt2, rs2);
		}
		return aslist;
	}

	public String addAccountsHeadMasterdetails(String paymentHead, String Description, int systemId, int customerId) {

		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String message = "";

		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(IronMiningStatement.CHECK_IF_PAYMENT_ACC_ALREADY_EXIST);
			pstmt.setString(1, paymentHead);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				message = "Payment A/C Head Already Exist";
				return message;
			}
			pstmt = con.prepareStatement(IronMiningStatement.INSERT_ACCOUNT_HEAD_INFORMATION);
			pstmt.setString(1, paymentHead);
			pstmt.setString(2, Description);
			pstmt.setInt(3, systemId);
			pstmt.setInt(4, customerId);
			int inserted = pstmt.executeUpdate();
			if (inserted > 0) {
				message = "Saved Successfully";
			}
		} catch (Exception e) {
			System.out.println("error in:-save AccountsHeadMaster details " + e.toString());
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return message;

	}

	public String modifyAccountsHeadMasterdetails(String paymentHead, String description, int systemId, int custId,
			int id) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String message = "";
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(IronMiningStatement.CHECK_IF_PAYMENT_ACC_ALREADY_EXISTS);
			pstmt.setString(1, paymentHead);
			pstmt.setInt(2, id);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				message = "Payment A/C Head Already Exist";
				return message;
			}

			pstmt = con.prepareStatement(IronMiningStatement.UPDATE_ACCOUNT_HEAD_INFORMATION);
			pstmt.setString(1, paymentHead);
			pstmt.setString(2, description);
			pstmt.setInt(3, systemId);
			pstmt.setInt(4, custId);
			pstmt.setInt(5, id);
			int updated = pstmt.executeUpdate();
			if (updated > 0) {
				message = "Updated Successfully";
			}
		} catch (Exception e) {
			System.out.println("error in :-update AccountsHeadMaster details " + e.toString());
			e.printStackTrace();
		}

		finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return message;
	}

	//-----------------------------------GETTING TARE WEIGHT DETAILS FOR GRID-------------------------------------//
	@SuppressWarnings("unchecked")
	public ArrayList getTareWeightDetails(String customerName, int systemId, int CustomerId, String Assetnumber,
			String Buttonvalue, String startdate, String enddate, int userId, String language) {
		JSONArray JsonArray = new JSONArray();
		JSONObject JsonObject = null;
		Connection con = null;
		PreparedStatement pstmt52 = null;
		ResultSet rs52 = null;
		int aslcount = 0;
		SimpleDateFormat diffddMMyyyyHHmmss = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
		ArrayList tareWLists = new ArrayList();

		try {
			con = DBConnection.getConnectionToDB("AMS");
			if (Buttonvalue.equals("view")) {
				pstmt52 = con.prepareStatement(IronMiningStatement.GET_MINING_TARE_WEIGHT_DETAILS);
				pstmt52.setInt(1, systemId);
				pstmt52.setInt(2, CustomerId);
				pstmt52.setString(3, startdate);
				pstmt52.setString(4, enddate);
			} else {
				pstmt52 = con
						.prepareStatement(IronMiningStatement.GET_MINING_TARE_WEIGHT_DETAILS_BASED_ON_ASSET_NUMBER);
				pstmt52.setInt(1, systemId);
				pstmt52.setInt(2, CustomerId);
				pstmt52.setString(3, Assetnumber);
			}
			rs52 = pstmt52.executeQuery();
			while (rs52.next()) {
				JsonObject = new JSONObject();
				aslcount++;
				JsonObject.put("slnoIndex", aslcount);

				JsonObject.put("TypeIndex", rs52.getString("TYPE").toUpperCase());

				JsonObject.put("assetNoIndex", rs52.getString("ASSET_NUMBER").toUpperCase());

				JsonObject.put("tareWeightIndex", String.valueOf(rs52.getString("TARE_WEIGHT_1")));

				if (rs52.getTimestamp("WEIGHT_DATE_AND_TIME") == null
						|| rs52.getString("WEIGHT_DATE_AND_TIME").equals("")
						|| rs52.getString("WEIGHT_DATE_AND_TIME").contains("1900")) {
					JsonObject.put("WeightDateTimeIndex", "");
				} else {
					JsonObject.put("WeightDateTimeIndex",
							diffddMMyyyyHHmmss.format(rs52.getTimestamp("WEIGHT_DATE_AND_TIME")));
				}
				JsonObject.put("uniqueIDIndex", rs52.getString("ID"));

				JsonArray.put(JsonObject);
			}
			tareWLists.add(JsonArray);
			//finalreporthelper.setReportsList(reportsList);
			//finalreporthelper.setHeadersList(headersList);
			//tareWLists.add(finalreporthelper);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {

			DBConnection.releaseConnectionToDB(con, pstmt52, rs52);
		}
		return tareWLists;
	}

	//-------------------------------SAVE TARE WEIGHT DETAILS-----------------------------------//
	public String saveTareWeightDetailsInformation(int customerId, String type, String assetNo, String tareWeight,
			String quantity, String weightDateTime, int userId, int systemId, String custName) {

		String message = "";
		Connection conAdmin = null;
		PreparedStatement pstmt55 = null;
		ResultSet rs55 = null;
		try {
			int inserted = 0;
			conAdmin = DBConnection.getConnectionToDB("AMS");
			pstmt55 = conAdmin.prepareStatement(IronMiningStatement.SAVE_MINING_TARE_WEIGHT_INFORMATION);
			pstmt55.setString(1, type);
			pstmt55.setString(2, assetNo);
			pstmt55.setInt(3, Integer.parseInt(tareWeight));
			//pstmt55.setString(3,weightDateTime);
			pstmt55.setInt(4, systemId);
			pstmt55.setInt(5, customerId);
			inserted = pstmt55.executeUpdate();
			if (inserted > 0) {
				message = "Tare Weight Details Saved Successfully";
			} else {
				message = "Error in Saving Tare Weight Details";
			}
		} catch (Exception e) {
			System.out.println("error in Trip Sheet Details :-save Tare Weight Details" + e.toString());
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(conAdmin, pstmt55, rs55);
		}
		return message;
	}

	//----------------------------------MODIFY TARE WEIGHT----------------------------------------//
	public String modifyTareWeightDetailsInformation(int customerId, String type, String assetNo, String tareWeight,
			String quantity, String weightDateTime, int userId, int systemId, String uniqueId) {
		String message = "";
		Connection conAdmin = null;
		PreparedStatement pstmt90 = null;
		try {
			conAdmin = DBConnection.getConnectionToDB("AMS");
			int updated = 0;
			pstmt90 = conAdmin.prepareStatement(IronMiningStatement.MODIFY_TARE_WEIGHT_INFORMATION);
			pstmt90.setString(1, weightDateTime);
			pstmt90.setInt(2, systemId);
			pstmt90.setInt(3, customerId);
			pstmt90.setString(4, uniqueId);
			updated = pstmt90.executeUpdate();
			if (updated > 0) {
				message = "Tare Weight Details Modified Successfully";
			} else {
				message = "Tare Weight Details is not possible for Modified of this Vehicles";
			}
		} catch (Exception e) {
			System.out.println("error in ModifyTripSheetDetails Function:-save Tare weight Details  " + e.toString());
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(conAdmin, pstmt90, null);
		}
		return message;
	}

	//*************************************TC Number Details ***************************************//	
	public JSONArray getTCNumber(int custId, int systemId) {
		JSONArray JsonArray = null;
		JSONObject JsonObject = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			JsonArray = new JSONArray();
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(IronMiningStatement.GET_TC_NUMBER);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, custId);
			pstmt.setInt(3, systemId);
			pstmt.setInt(4, custId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				JsonObject = new JSONObject();
				JsonObject.put("TCNumber", rs.getString("TC_NUMBER"));
				JsonObject.put("TCID", rs.getString("TC_ID"));
				JsonObject.put("year", rs.getString("YEAR"));
				JsonObject.put("area", rs.getString("AREA"));
				JsonObject.put("pin", rs.getString("PIN"));
				JsonObject.put("fax", rs.getString("FAX_NO"));
				JsonObject.put("phone", rs.getString("PHONE_NO"));
				JsonObject.put("email", rs.getString("EMAIL_ID"));
				JsonObject.put("name", rs.getString("NAME_OF_MINE"));
				JsonObject.put("lessename", rs.getString("LESSE_NAME"));
				JsonObject.put("state", rs.getString("STATE"));
				JsonObject.put("district", rs.getString("DISTRICT_NAME"));
				JsonObject.put("taluk", rs.getString("TALUKA_NAME"));
				JsonObject.put("village", rs.getString("VILLAGE"));
				JsonObject.put("talukCode", rs.getString("TALUKA_CODE"));
				JsonObject.put("districtCode", rs.getString("DISTRICT_CODE"));
				JsonArray.put(JsonObject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return JsonArray;
	}

	//*************************************TYPE Details ***************************************//	
	public JSONArray getType() {
		JSONArray JsonArray = null;
		JSONObject JsonObject = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			JsonArray = new JSONArray();
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(IronMiningStatement.GET_TYPE);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				JsonObject = new JSONObject();
				JsonObject.put("Type", rs.getString("TYPE"));
				JsonArray.put(JsonObject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return JsonArray;
	}

	//-------------------------------------Insert Mine Owner Master Information-----------------------------------------------------------//
	public String insertMineOwnerInformation(String tcNumber, int tcId, String year, String name, String lesseeName,
			int state, int district, int taluk, String village, String postOffice, String address, int pin,
			String phoneNo, String contactPerson, String panNo, String tanNo, String banker, String branch, int CustId,
			int systemId, int userId, String faxNo, String emailId) {
		Connection con = null;
		PreparedStatement pstmt = null;
		String message = "";
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(IronMiningStatement.INSERT_MINE_OWNER_DETAILS);
			pstmt.setString(1, tcNumber);
			pstmt.setInt(2, tcId);
			pstmt.setString(3, year);
			pstmt.setString(4, name);
			pstmt.setString(5, contactPerson);
			pstmt.setString(6, lesseeName);
			pstmt.setInt(7, state);
			pstmt.setInt(8, district);
			pstmt.setInt(9, taluk);
			pstmt.setString(10, village);
			pstmt.setString(11, postOffice);
			pstmt.setString(12, address);
			pstmt.setInt(13, pin);
			pstmt.setString(14, phoneNo);
			pstmt.setString(15, panNo);
			pstmt.setString(16, tanNo);
			pstmt.setString(17, banker);
			pstmt.setString(18, branch);
			pstmt.setInt(19, systemId);
			pstmt.setInt(20, CustId);
			pstmt.setInt(21, userId);
			pstmt.setString(22, emailId);
			pstmt.setString(23, faxNo);
			int inserted = pstmt.executeUpdate();
			if (inserted > 0) {
				message = "Saved Successfully";
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, null);
		}
		return message;
	}

	//----------------------------------------modify MineOwner Master Information-------------------------------------------//
	public String modifyMineOwnerInformation(int id, int CustId, int systemId, String tcNumber, int tcId, String year,
			String name, String lesseeName, int state, int district, int taluk, String village, String postOffice,
			String address, int pin, String phoneNo, String contactPerson, String panNo, String tanNo, String banker,
			String branch, int userId, String faxNo, String emailId) {
		Connection con = null;
		PreparedStatement pstmt = null;
		String message = "";
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(IronMiningStatement.UPDATE_MINE_OWNER_INFORMATION);
			pstmt.setString(1, tcNumber);
			pstmt.setInt(2, tcId);
			pstmt.setString(3, year);
			pstmt.setString(4, name);
			pstmt.setString(5, contactPerson);
			pstmt.setString(6, lesseeName);
			pstmt.setInt(7, state);
			pstmt.setInt(8, district);
			pstmt.setInt(9, taluk);
			pstmt.setString(10, village);
			pstmt.setString(11, postOffice);
			pstmt.setString(12, address);
			pstmt.setInt(13, pin);
			pstmt.setString(14, phoneNo);
			pstmt.setString(15, panNo);
			pstmt.setString(16, tanNo);
			pstmt.setString(17, banker);
			pstmt.setString(18, branch);
			pstmt.setInt(19, userId);
			pstmt.setString(20, emailId);
			pstmt.setString(21, faxNo);
			pstmt.setInt(22, id);
			pstmt.setInt(23, systemId);
			pstmt.setInt(24, CustId);

			int updated = pstmt.executeUpdate();
			if (updated > 0) {
				message = "Updated Successfully";
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {

			DBConnection.releaseConnectionToDB(con, pstmt, null);
		}
		return message;
	}

	//-------------------------------------TC Master Report Details --------------------------------------//
	public ArrayList<Object> getOwnerMasterDeatils(int systemid, int CustId) {

		JSONArray JsonArray = new JSONArray();
		JSONObject JsonObject = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		ReportHelper finalreporthelper = new ReportHelper();
		ArrayList<Object> finlist = new ArrayList<Object>();
		ArrayList<ReportHelper> reportsList = new ArrayList<ReportHelper>();
		ArrayList<String> headersList = new ArrayList<String>();
		headersList.add("Sl No");
		headersList.add("Tc Number");
		headersList.add("Year");
		headersList.add("Name Of Lease");
		headersList.add("Contact Person");
		headersList.add("Name Of The Lessee");
		headersList.add("State");
		headersList.add("District");
		headersList.add("Taluka");
		headersList.add("Village");
		headersList.add("Post Office");
		headersList.add("Address");
		headersList.add("Pin Code");
		headersList.add("Phone No");
		headersList.add("Fax");
		headersList.add("Email");
		headersList.add("PAN No");
		headersList.add("TAN No");
		headersList.add("Banker");
		headersList.add("Branch");
		headersList.add("ID");
		headersList.add("District Code");
		headersList.add("Taluk Code");
		headersList.add("State Code");

		try {
			int count = 0;
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(IronMiningStatement.GET_OWNER_MASTER_DETAILS);
			pstmt.setInt(1, systemid);
			pstmt.setInt(2, CustId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				ArrayList<Object> informationList = new ArrayList<Object>();
				ReportHelper reporthelper = new ReportHelper();
				JsonObject = new JSONObject();
				count++;

				JsonObject.put("slnoIndex", count);
				informationList.add(count);

				JsonObject.put("tcNumberDataIndex", rs.getString("TC_NUMBER"));
				informationList.add(rs.getString("TC_NUMBER"));

				JsonObject.put("yearDataIndex", rs.getString("YEAR"));
				informationList.add(rs.getString("YEAR"));

				JsonObject.put("nameDataIndex", rs.getString("NAME"));
				informationList.add(rs.getString("NAME"));

				JsonObject.put("contactPersonDataIndex", rs.getString("CONTACT_PERSON"));
				informationList.add(rs.getString("CONTACT_PERSON"));

				JsonObject.put("lesseeNameDataIndex", rs.getString("LESSEE_NAME"));
				informationList.add(rs.getString("LESSEE_NAME"));

				JsonObject.put("stateDataIndex", rs.getString("STATE"));
				informationList.add(rs.getString("STATE"));

				JsonObject.put("DistrictDataIndex", rs.getString("DISTRICT"));
				informationList.add(rs.getString("DISTRICT"));

				JsonObject.put("TalukDataIndex", rs.getString("TALUKA"));
				informationList.add(rs.getString("TALUKA"));

				JsonObject.put("VillageDataIndex", rs.getString("VILLAGE"));
				informationList.add(rs.getString("VILLAGE"));

				JsonObject.put("postOfficeDataIndex", rs.getString("POST_OFFICE"));
				informationList.add(rs.getString("POST_OFFICE"));

				JsonObject.put("addressDataIndex", rs.getString("ADDRESS"));
				informationList.add(rs.getString("ADDRESS"));

				JsonObject.put("pinDataIndex", rs.getString("PIN"));
				informationList.add(rs.getString("PIN"));

				JsonObject.put("phoneNoDataIndex", rs.getString("PHONE_NUMBER"));
				informationList.add(rs.getString("PHONE_NUMBER"));

				JsonObject.put("faxNoDataIndex", rs.getString("FAX_NO"));
				informationList.add(rs.getString("FAX_NO"));

				JsonObject.put("emailDataIndex", rs.getString("EMAIL_ID"));
				informationList.add(rs.getString("EMAIL_ID"));

				JsonObject.put("panNoDataIndex", rs.getString("PAN_NO"));
				informationList.add(rs.getString("PAN_NO"));

				JsonObject.put("tanNoDataIndex", rs.getString("TAN_NO"));
				informationList.add(rs.getString("TAN_NO"));

				JsonObject.put("bankerDataIndex", rs.getString("BANKER"));
				informationList.add(rs.getString("BANKER"));

				JsonObject.put("branchDataIndex", rs.getString("BRANCH"));
				informationList.add(rs.getString("BRANCH"));

				JsonObject.put("IdDataIndex", rs.getString("ID"));
				informationList.add(rs.getString("ID"));

				JsonObject.put("districtIdDataIndex", rs.getString("DISTRICT_ID"));
				informationList.add(rs.getString("DISTRICT_ID"));

				JsonObject.put("TalukIdDataIndex", rs.getString("TALUKA_ID"));
				informationList.add(rs.getString("TALUKA_ID"));

				JsonObject.put("stateIdDataIndex", rs.getString("STATE_ID"));
				informationList.add(rs.getString("STATE_ID"));

				JsonObject.put("tcIdDataIndex", rs.getString("TC_ID"));

				JsonArray.put(JsonObject);
				reporthelper.setInformationList(informationList);
				reportsList.add(reporthelper);
			}
			finlist.add(JsonArray);
			finalreporthelper.setReportsList(reportsList);
			finalreporthelper.setHeadersList(headersList);
			finlist.add(finalreporthelper);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}

		return finlist;
	}

	//-------------------------------------Monthly Returns --------------------------------------//
	public ArrayList<Object> getMonthlyReturns(int systemId, int customerId, int userId, String userAuthority,
			String startDate, String endDate, String language) {
		ArrayList<ReportHelper> reportsList = new ArrayList<ReportHelper>();
		ArrayList<String> headersList = new ArrayList<String>();
		ReportHelper finalreporthelper = new ReportHelper();
		ArrayList<Object> finlist = new ArrayList<Object>();
		JSONArray JsonArray = new JSONArray();
		JSONObject JsonObject = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int count = 0;
		try {
			headersList.add("SLNO");
			headersList.add("Monthly Form Details ID");
			headersList.add("Return Form Id");
			headersList.add("Month Applied");
			headersList.add("IBM Reg. No.");
			headersList.add("Minerals Name");
			headersList.add("Mining Name");
			headersList.add("TC Number");
			headersList.add("Owner");
			headersList.add("Designation");
			headersList.add("Status");
			headersList.add("Remarks");
			headersList.add("Approved or Rejected By");
			headersList.add("Approved or Rejected Date Time");
			con = DBConnection.getConnectionToDB("AMS");
			if (userAuthority.equalsIgnoreCase("Admin")) {
				pstmt = con.prepareStatement(IronMiningStatement.GET_MONTHLY_FORM_DETAILS.replace("#", " "));

			} else {
				pstmt = con.prepareStatement(
						IronMiningStatement.GET_MONTHLY_FORM_DETAILS.replace("#", "and mfd.INSERTED_BY=" + userId));

			}
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, customerId);
			pstmt.setString(3, startDate);
			pstmt.setString(4, endDate);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				count++;
				ReportHelper reporthelper = new ReportHelper();
				JsonObject = new JSONObject();
				ArrayList<Object> informationList = new ArrayList<Object>();

				informationList.add(count);
				JsonObject.put("SNOIndex", count);

				informationList.add(count);
				JsonObject.put("IDIndex", rs.getString("ID"));

				informationList.add(rs.getString("RETURN_FORM_ID"));
				JsonObject.put("returnFormIdIndex", rs.getString("RETURN_FORM_ID"));

				informationList.add(rs.getString("MONTH"));
				JsonObject.put("monthAppliedIndex", rs.getString("MONTH"));

				informationList.add(rs.getString("REGISTRATION_NO"));
				JsonObject.put("RegIndex", rs.getString("REGISTRATION_NO"));

				informationList.add(rs.getString("MINERAL_NAME"));
				JsonObject.put("mineralsIndex", rs.getString("MINERAL_NAME"));

				informationList.add(rs.getString("NAME_OF_MINE"));
				JsonObject.put("minesIndex", rs.getString("NAME_OF_MINE"));

				informationList.add(rs.getString("TC_NO"));
				JsonObject.put("tcNoIndex", rs.getString("TC_NO"));

				informationList.add(rs.getString("CONTACT_PERSON"));
				JsonObject.put("ownerIndex", rs.getString("CONTACT_PERSON"));

				informationList.add(rs.getString("DESIGNATION"));
				JsonObject.put("desgnationIndex", rs.getString("DESIGNATION"));

				informationList.add(rs.getString("STATUS"));
				JsonObject.put("statusIndex", rs.getString("STATUS"));

				informationList.add(rs.getString("REMAKRS"));
				JsonObject.put("remarksIndex", rs.getString("REMAKRS"));

				informationList.add(rs.getString("APPROVED_REJECTED_BY"));
				JsonObject.put("approvedRejectedByIndex", rs.getString("APPROVED_REJECTED_BY"));

				String approvedRejectedBy = "";
				if (rs.getString("APPROVED_REJECTED_DATETIME").contains("1900")) {
					approvedRejectedBy = "";
				} else {
					approvedRejectedBy = rs.getString("APPROVED_REJECTED_DATETIME");
				}
				informationList.add(approvedRejectedBy);
				JsonObject.put("approvedRejectedDTIndex", approvedRejectedBy);

				JsonArray.put(JsonObject);
				reporthelper.setInformationList(informationList);
				reportsList.add(reporthelper);
			}
			finalreporthelper.setReportsList(reportsList);
			finalreporthelper.setHeadersList(headersList);
			finlist.add(JsonArray);
			finlist.add(finalreporthelper);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return finlist;
	}

	public JSONArray getListOfLabourAndWages() {
		JSONArray JsonArray = null;
		JSONObject JsonObject = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int count = 0;
		try {
			JsonArray = new JSONArray();
			con = DBConnection.getConnectionToDB("AMS");
			List<String> listOfLabourAndWages = new ArrayList<String>();
			listOfLabourAndWages.add("Below Ground");
			listOfLabourAndWages.add("Opencast");
			listOfLabourAndWages.add("Above Ground");
			for (int i = 0; i < listOfLabourAndWages.size(); i++) {
				count++;
				JsonObject = new JSONObject();
				JsonObject.put("SLNOIndex", count);
				JsonObject.put("workPlaceIndex", listOfLabourAndWages.get(i));
				JsonArray.put(JsonObject);
			}
			JsonObject = new JSONObject();
			JsonObject.put("workPlaceIndex", "Total");
			JsonArray.put(JsonObject);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return JsonArray;
	}

	public JSONArray getGradeWiseProductionDespatchList(String mineral, String type) {
		JSONArray JsonArray = null;
		JSONObject JsonObject = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int count = 0;
		try {
			JsonArray = new JSONArray();
			con = DBConnection.getConnectionToDB("AMS");
			List<String> listOfGrade = new ArrayList<String>();
			if (mineral.equalsIgnoreCase("Iron Ore")) {
				listOfGrade.add("Fe:Lumps:Below 55%");
				listOfGrade.add("Fe:Lumps:55% to Below 58%");
				listOfGrade.add("Fe:Lumps:58% to Below 60%");
				listOfGrade.add("Fe:Lumps:60% to Below 62%");
				listOfGrade.add("Fe:Lumps:62% to Below 65%");
				listOfGrade.add("Fe:Lumps:65% and above");
				listOfGrade.add("Fe:Fines:Below 55%");
				listOfGrade.add("Fe:Fines:55% to Below 58%");
				listOfGrade.add("Fe:Fines:58% to Below 60%");
				listOfGrade.add("Fe:Fines:60% to Below 62%");
				listOfGrade.add("Fe:Fines:62% to Below 65%");
				listOfGrade.add("Fe:Fines:65% and above");
				listOfGrade.add("Concentrates");
			} else if (mineral.equalsIgnoreCase("Manganese")) {
				listOfGrade.add("Mn:Below 25%");
				listOfGrade.add("Mn:25% to Below 35%");
				listOfGrade.add("Mn:35% to Below 46%");
				listOfGrade.add("Mn:46% and above");
				listOfGrade.add("Mn:Dioxide ore");
				listOfGrade.add("Mn:Concentrates");
			} else if (mineral.equalsIgnoreCase("Bauxite/Laterite")) {
				listOfGrade.add("Al:Below 40%");
				listOfGrade.add("Al:40% to Below 45%");
				listOfGrade.add("Al:45% to Below 50%");
				listOfGrade.add("Al:50% to Below 55%");
				listOfGrade.add("Al:55% to Below 60%");
				listOfGrade.add("Al:60% and above");
				listOfGrade.add("Other than Al:Cement");
				listOfGrade.add("Other than Al:Abrasive");
				listOfGrade.add("Other than Al:Refactory");
				listOfGrade.add("Other than Al:Chemical");
			}
			if (type.equals("Dispatch")) {
				listOfGrade.add("ROM");
				listOfGrade.add("Tailing");
			}
			for (int i = 0; i < listOfGrade.size(); i++) {
				JsonObject = new JSONObject();
				count++;
				JsonObject.put("SLNOIndex", count);
				JsonObject.put("gradesIndex", listOfGrade.get(i));
				JsonArray.put(JsonObject);
			}

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return JsonArray;
	}

	public JSONArray getListOfTCNo(int systemId, int customerId) {
		JSONArray JsonArray = null;
		JSONObject JsonObject = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			JsonArray = new JSONArray();
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(IronMiningStatement.GET_LIST_OF_TC_NO);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, customerId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				JsonObject = new JSONObject();
				JsonObject.put("tcNoId", rs.getString("ID"));
				JsonObject.put("regIBM", rs.getString("REG_IBM"));
				JsonObject.put("minecode", rs.getString("MINE_CODE"));
				JsonObject.put("tcno", rs.getString("TC_NO"));
				JsonObject.put("nameOfMines", rs.getString("NAME_OF_MINE"));
				JsonObject.put("Village", rs.getString("VILLAGE"));
				JsonObject.put("postOffice", rs.getString("POST_OFFICE"));
				JsonObject.put("talukaName", rs.getString("TALUKA_NAME"));
				JsonObject.put("districtName", rs.getString("DISTRICT_NAME"));
				JsonObject.put("stateName", rs.getString("STATE_NAME"));
				JsonObject.put("PIN", rs.getString("PIN"));
				JsonObject.put("FAXNo", rs.getString("FAX_NO"));
				JsonObject.put("phoneNo", rs.getString("PHONE_NO"));
				JsonObject.put("emailId", rs.getString("EMAIL_ID"));
				JsonArray.put(JsonObject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return JsonArray;
	}

	public JSONArray getNameAndAddress(int systemId, int customerId) {
		JSONArray JsonArray = null;
		JSONObject JsonObject = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			JsonArray = new JSONArray();
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(IronMiningStatement.GET_NAME_AND_ADDRESS);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, customerId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				JsonObject = new JSONObject();
				JsonObject.put("ID", rs.getString("ID"));
				JsonObject.put("name", rs.getString("LEASE_NAME"));
				JsonObject.put("Village", rs.getString("VILLAGE"));
				JsonObject.put("postOffice", rs.getString("POST_OFFICE"));
				JsonObject.put("talukaName", rs.getString("TALUKA_NAME"));
				JsonObject.put("districtName", rs.getString("DISTRICT_NAME"));
				JsonObject.put("stateName", rs.getString("STATE_NAME"));
				JsonObject.put("PIN", rs.getString("PIN"));
				JsonObject.put("FAXNo", rs.getString("FAX_NO"));
				JsonObject.put("phoneNo", rs.getString("PHONE_NO"));
				JsonObject.put("emailId", rs.getString("EMAIL_ID"));
				JsonArray.put(JsonObject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return JsonArray;
	}

	public String insertDailyEmploymentDetails(int SLNO, String workPlace, int maleLabour, int femaleLabour,
			int contractMaleLabour, int contractFemaleLabour, int directWagesLabour, int contractWagesLabour) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String message = "";
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(IronMiningStatement.INSERT_MINE_OWNER_DETAILS);

			int inserted = pstmt.executeUpdate();
			if (inserted > 0) {
				message = "Saved Successfully";
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return message;
	}

	public int saveGeneralAndLabourInformation(String custName, String date, String region, String pin, String regNo,
			int mineCode, String mineralsName, String tcNoId, String mineId, String otherMine, String nameAndAddress,
			float rentPaid, float royaltyPaid, float deadRent, float challanDetailsOne, float challanDetailsTwo,
			int mineWorked, int workStopped, String stoppedReason, int technicalStaff, float totalSalary, int systemId,
			int customerId, int userId, JSONArray jsonarray, String otherStoppedReason, JSONArray cjson) {
		JSONObject jsonObject = new JSONObject();
		Connection con = null;
		ResultSet rs = null;
		PreparedStatement pstmt = null;
		PreparedStatement pstmt1 = null;
		PreparedStatement pstmt2 = null;
		int inserted = 0;
		int autoGeneratedKeys = 0;
		try {
			con = DBConnection.getConnectionToDB("AMS");
			Calendar gcalendar = new GregorianCalendar();
			int year = gcalendar.get(Calendar.YEAR);
			String curyear = String.valueOf(year);
			int monthlyreturnid = getMonthlyReturnNumber(con, systemId, customerId, curyear);
			/*----leading Zeros handling----------------------*/
			String monthlyreturnidtoGrid = "";
			if (String.valueOf(monthlyreturnid).length() <= 5) {
				monthlyreturnidtoGrid = ("00000" + monthlyreturnid).substring(String.valueOf(monthlyreturnid).length());
			} else {
				monthlyreturnidtoGrid = ("000000000" + monthlyreturnid)
						.substring(String.valueOf(monthlyreturnid).length());
			}
			String currentyear = curyear.substring(Math.max(curyear.length() - 2, 0));
			pstmt = con.prepareStatement(IronMiningStatement.INSERT_MONTHLY_FORM_DETAILS,
					Statement.RETURN_GENERATED_KEYS);
			pstmt.setString(1, custName + " MRF " + monthlyreturnidtoGrid + "/" + currentyear);
			pstmt.setString(2, date);
			pstmt.setString(3, region);
			pstmt.setString(4, pin);
			pstmt.setString(5, regNo);
			pstmt.setInt(6, mineCode);
			pstmt.setString(7, mineralsName);
			pstmt.setString(8, tcNoId);
			pstmt.setString(9, otherMine);
			pstmt.setString(10, nameAndAddress);
			pstmt.setFloat(11, rentPaid);
			pstmt.setFloat(12, royaltyPaid);
			pstmt.setFloat(13, deadRent);
			pstmt.setFloat(14, challanDetailsOne);
			pstmt.setFloat(15, challanDetailsTwo);
			pstmt.setInt(16, mineWorked);
			pstmt.setInt(17, workStopped);
			pstmt.setString(18, stoppedReason);
			pstmt.setInt(19, technicalStaff);
			pstmt.setFloat(20, totalSalary);
			pstmt.setInt(21, systemId);
			pstmt.setInt(22, customerId);
			pstmt.setInt(23, userId);
			pstmt.setString(24, otherStoppedReason);
			inserted = pstmt.executeUpdate();
			rs = pstmt.getGeneratedKeys();
			if (rs.next()) {
				autoGeneratedKeys = rs.getInt(1);
			}
			if (inserted > 0 && autoGeneratedKeys > 0) {
				for (int i = 0; i < jsonarray.length(); i++) {
					inserted = 0;
					jsonObject = jsonarray.getJSONObject(i);
					String workPlace = "";
					int maleLabour = 0;
					int femaleLabour = 0;
					int contractMaleLabour = 0;
					int contractFemaleLabour = 0;
					float directWagesLabour = 0;
					float contractWagesLabour = 0;
					if (jsonObject.getString("workPlaceIndex") != null
							&& !jsonObject.getString("workPlaceIndex").equals("")) {
						workPlace = jsonObject.getString("workPlaceIndex");
					}
					if (jsonObject.getString("maleLabourIndex") != null
							&& !jsonObject.getString("maleLabourIndex").equals("")) {
						maleLabour = Integer.parseInt(jsonObject.getString("maleLabourIndex"));
					}
					if (jsonObject.getString("femaleLabourIndex") != null
							&& !jsonObject.getString("femaleLabourIndex").equals("")) {
						femaleLabour = Integer.parseInt(jsonObject.getString("femaleLabourIndex"));
					}
					if (jsonObject.getString("contractMaleLabourIndex") != null
							&& !jsonObject.getString("contractMaleLabourIndex").equals("")) {
						contractMaleLabour = Integer.parseInt(jsonObject.getString("contractMaleLabourIndex"));
					}
					if (jsonObject.getString("contractFemaleLabourIndex") != null
							&& !jsonObject.getString("contractFemaleLabourIndex").equals("")) {
						contractFemaleLabour = Integer.parseInt(jsonObject.getString("contractFemaleLabourIndex"));
					}
					if (jsonObject.getString("directWagesLabourIndex") != null
							&& !jsonObject.getString("directWagesLabourIndex").equals("")) {
						directWagesLabour = Float.parseFloat(jsonObject.getString("directWagesLabourIndex"));
					}
					if (jsonObject.getString("contractWagesLabourIndex") != null
							&& !jsonObject.getString("contractWagesLabourIndex").equals("")) {
						contractWagesLabour = Float.parseFloat(jsonObject.getString("contractWagesLabourIndex"));
					}
					pstmt1 = con.prepareStatement(IronMiningStatement.INSERT_DAILY_EMPLOYMENT_DETAILS);
					pstmt1.setInt(1, autoGeneratedKeys);
					pstmt1.setString(2, workPlace);
					pstmt1.setInt(3, maleLabour);
					pstmt1.setInt(4, femaleLabour);
					pstmt1.setInt(5, contractMaleLabour);
					pstmt1.setInt(6, contractFemaleLabour);
					pstmt1.setFloat(7, directWagesLabour);
					pstmt1.setFloat(8, contractWagesLabour);
					inserted = pstmt1.executeUpdate();
				}
			}
			if (inserted > 0 && autoGeneratedKeys > 0) {
				for (int i = 0; i < cjson.length(); i++) {
					inserted = 0;
					jsonObject = cjson.getJSONObject(i);
					String challanNo = "";
					float quantity = 0;
					String challanDate = "";
					float valuePaid = 0;
					float royalityRate = 0;
					String grade = "";
					String type = "";
					if (jsonObject.getString("challanNumberIndex") != null
							&& !jsonObject.getString("challanNumberIndex").equals("")) {
						challanNo = jsonObject.getString("challanNumberIndex");
					}
					if (jsonObject.getString("challanDateIndex") != null
							&& !jsonObject.getString("challanDateIndex").equals("")) {
						challanDate = jsonObject.getString("challanDateIndex");
					}
					if (challanDate.contains("T")) {
						challanDate = challanDate.replace("T", " ");
					}
					if (jsonObject.getString("quantityIndex") != null
							&& !jsonObject.getString("quantityIndex").equals("")) {
						quantity = Float.parseFloat(jsonObject.getString("quantityIndex"));
					}
					if (jsonObject.getString("gradeIndex") != null && !jsonObject.getString("gradeIndex").equals("")) {
						grade = jsonObject.getString("gradeIndex");
					}
					if (jsonObject.getString("typeIndex") != null && !jsonObject.getString("typeIndex").equals("")) {
						type = jsonObject.getString("typeIndex");
					}
					if (jsonObject.getString("royalityRateIndex") != null
							&& !jsonObject.getString("royalityRateIndex").equals("")) {
						royalityRate = Float.parseFloat(jsonObject.getString("royalityRateIndex"));
					}
					if (jsonObject.getString("valuePaidIndex") != null
							&& !jsonObject.getString("valuePaidIndex").equals("")) {
						valuePaid = Float.parseFloat(jsonObject.getString("valuePaidIndex"));
					}
					pstmt2 = con.prepareStatement(IronMiningStatement.INSERT_CHALLAN_DETAILS);
					pstmt2.setInt(1, autoGeneratedKeys);
					pstmt2.setString(2, challanNo);
					pstmt2.setString(3, grade);
					pstmt2.setFloat(4, quantity);
					pstmt2.setString(5, type);
					pstmt2.setFloat(6, royalityRate);
					pstmt2.setFloat(7, valuePaid);
					pstmt2.setString(8, challanDate);
					inserted = pstmt2.executeUpdate();
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
			DBConnection.releaseConnectionToDB(null, pstmt1, null);
			DBConnection.releaseConnectionToDB(null, pstmt2, null);
		}
		return autoGeneratedKeys;
	}

	public int updateGeneralAndLabourInformation(int generatedkey, String custName, String date, String region,
			String pin, String regNo, int mineCode, String mineralsName, String tcNoId, String mineId, String otherMine,
			String nameAndAddress, float rentPaid, float royaltyPaid, float deadRent, float challanDetails1,
			float challanDetails2, int mineWorked, int workStopped, String stoppedReason, int technicalStaff,
			float totalSalary, int systemId, int customerId, int userId, JSONArray jsonarray, String otherStoppedReason,
			JSONArray cjson) {
		JSONObject jsonObject = new JSONObject();
		Connection con = null;
		ResultSet rs = null;
		PreparedStatement pstmt = null;
		PreparedStatement pstmt1 = null;
		PreparedStatement pstmt2 = null;
		int inserted = 0;
		int autoGeneratedKeys = generatedkey;
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(IronMiningStatement.UPDATE_MONTHLY_DETAILS, Statement.RETURN_GENERATED_KEYS);
			pstmt.setString(1, date);
			pstmt.setString(2, region);
			pstmt.setString(3, pin);
			pstmt.setString(4, regNo);
			pstmt.setInt(5, mineCode);
			pstmt.setString(6, mineralsName);
			pstmt.setString(7, tcNoId);
			pstmt.setString(8, otherMine);
			pstmt.setString(9, nameAndAddress);
			pstmt.setFloat(10, rentPaid);
			pstmt.setFloat(11, royaltyPaid);
			pstmt.setFloat(12, deadRent);
			pstmt.setFloat(13, challanDetails1);
			pstmt.setFloat(14, challanDetails2);
			pstmt.setInt(15, mineWorked);
			pstmt.setInt(16, workStopped);
			pstmt.setString(17, stoppedReason);
			pstmt.setInt(18, technicalStaff);
			pstmt.setFloat(19, totalSalary);
			pstmt.setInt(20, userId);
			pstmt.setString(21, otherStoppedReason);
			pstmt.setInt(22, generatedkey);
			inserted = pstmt.executeUpdate();

			if (inserted > 0) {
				for (int i = 0; i < jsonarray.length(); i++) {
					jsonObject = jsonarray.getJSONObject(i);
					String workPlace = "";
					int maleLabour = 0;
					int femaleLabour = 0;
					int contractMaleLabour = 0;
					int contractFemaleLabour = 0;
					float directWagesLabour = 0;
					float contractWagesLabour = 0;
					int autoIncId = 0;
					if (jsonObject.getString("autoIncIdIndex") != null
							&& !jsonObject.getString("autoIncIdIndex").equals("")) {
						autoIncId = Integer.parseInt(jsonObject.getString("autoIncIdIndex"));
					}
					if (jsonObject.getString("workPlaceIndex") != null
							&& !jsonObject.getString("workPlaceIndex").equals("")) {
						workPlace = jsonObject.getString("workPlaceIndex");
					}
					if (jsonObject.getString("maleLabourIndex") != null
							&& !jsonObject.getString("maleLabourIndex").equals("")) {
						maleLabour = Integer.parseInt(jsonObject.getString("maleLabourIndex"));
					}
					if (jsonObject.getString("femaleLabourIndex") != null
							&& !jsonObject.getString("femaleLabourIndex").equals("")) {
						femaleLabour = Integer.parseInt(jsonObject.getString("femaleLabourIndex"));
					}
					if (jsonObject.getString("contractMaleLabourIndex") != null
							&& !jsonObject.getString("contractMaleLabourIndex").equals("")) {
						contractMaleLabour = Integer.parseInt(jsonObject.getString("contractMaleLabourIndex"));
					}
					if (jsonObject.getString("contractFemaleLabourIndex") != null
							&& !jsonObject.getString("contractFemaleLabourIndex").equals("")) {
						contractFemaleLabour = Integer.parseInt(jsonObject.getString("contractFemaleLabourIndex"));
					}
					if (jsonObject.getString("directWagesLabourIndex") != null
							&& !jsonObject.getString("directWagesLabourIndex").equals("")) {
						directWagesLabour = Float.parseFloat(jsonObject.getString("directWagesLabourIndex"));
					}
					if (jsonObject.getString("contractWagesLabourIndex") != null
							&& !jsonObject.getString("contractWagesLabourIndex").equals("")) {
						contractWagesLabour = Float.parseFloat(jsonObject.getString("contractWagesLabourIndex"));
					}
					if (autoIncId > 0) {
						pstmt1 = con.prepareStatement(IronMiningStatement.UPDATE_DAILY_EMPLOYMENT_DETAILS);
						pstmt1.setString(1, workPlace);
						pstmt1.setInt(2, maleLabour);
						pstmt1.setInt(3, femaleLabour);
						pstmt1.setInt(4, contractMaleLabour);
						pstmt1.setInt(5, contractFemaleLabour);
						pstmt1.setFloat(6, directWagesLabour);
						pstmt1.setFloat(7, contractWagesLabour);
						pstmt1.setInt(8, autoIncId);
						pstmt1.executeUpdate();
					} else {
						pstmt1 = con.prepareStatement(IronMiningStatement.INSERT_DAILY_EMPLOYMENT_DETAILS);
						pstmt1.setInt(1, autoGeneratedKeys);
						pstmt1.setString(2, workPlace);
						pstmt1.setInt(3, maleLabour);
						pstmt1.setInt(4, femaleLabour);
						pstmt1.setInt(5, contractMaleLabour);
						pstmt1.setInt(6, contractFemaleLabour);
						pstmt1.setFloat(7, directWagesLabour);
						pstmt1.setFloat(8, contractWagesLabour);
						pstmt1.executeUpdate();
					}
				}
				for (int i = 0; i < cjson.length(); i++) {
					jsonObject = cjson.getJSONObject(i);
					String challanNo = "";
					float quantity = 0;
					String challanDate = "";
					float valuePaid = 0;
					float royalityRate = 0;
					String grade = "";
					String type = "";
					int autoIncId = 0;
					if (jsonObject.getString("autoIncIdIndex") != null
							&& !jsonObject.getString("autoIncIdIndex").equals("")) {
						autoIncId = Integer.parseInt(jsonObject.getString("autoIncIdIndex"));
					}
					if (jsonObject.getString("challanNumberIndex") != null
							&& !jsonObject.getString("challanNumberIndex").equals("")) {
						challanNo = jsonObject.getString("challanNumberIndex");
					}
					if (jsonObject.getString("challanDateIndex") != null
							&& !jsonObject.getString("challanDateIndex").equals("")) {
						challanDate = jsonObject.getString("challanDateIndex");
					}
					if (challanDate.contains("T")) {
						challanDate = challanDate.replace("T", " ");
					}
					if (jsonObject.getString("quantityIndex") != null
							&& !jsonObject.getString("quantityIndex").equals("")) {
						quantity = Float.parseFloat(jsonObject.getString("quantityIndex"));
					}
					if (jsonObject.getString("gradeIndex") != null && !jsonObject.getString("gradeIndex").equals("")) {
						grade = jsonObject.getString("gradeIndex");
					}
					if (jsonObject.getString("typeIndex") != null && !jsonObject.getString("typeIndex").equals("")) {
						type = jsonObject.getString("typeIndex");
					}
					if (jsonObject.getString("royalityRateIndex") != null
							&& !jsonObject.getString("royalityRateIndex").equals("")) {
						royalityRate = Float.parseFloat(jsonObject.getString("royalityRateIndex"));
					}
					if (jsonObject.getString("valuePaidIndex") != null
							&& !jsonObject.getString("valuePaidIndex").equals("")) {
						valuePaid = Float.parseFloat(jsonObject.getString("valuePaidIndex"));
					}
					if (autoIncId > 0) {
						pstmt2 = con.prepareStatement(IronMiningStatement.UPDATE_MONTHLY_CHALLAN_DETAILS);
						pstmt2.setString(1, challanNo);
						pstmt2.setString(2, grade);
						pstmt2.setFloat(3, quantity);
						pstmt2.setString(4, type);
						pstmt2.setFloat(5, royalityRate);
						pstmt2.setFloat(6, valuePaid);
						pstmt2.setString(7, challanDate);
						pstmt2.setInt(8, autoIncId);
						pstmt2.executeUpdate();
					} else {
						pstmt2 = con.prepareStatement(IronMiningStatement.INSERT_CHALLAN_DETAILS);
						pstmt2.setInt(1, autoGeneratedKeys);
						pstmt2.setString(2, challanNo);
						pstmt2.setString(3, grade);
						pstmt2.setFloat(4, quantity);
						pstmt2.setString(5, type);
						pstmt2.setFloat(6, royalityRate);
						pstmt2.setFloat(7, valuePaid);
						pstmt2.setString(8, challanDate);
						pstmt2.executeUpdate();
					}

				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
			DBConnection.releaseConnectionToDB(null, pstmt1, null);
			DBConnection.releaseConnectionToDB(null, pstmt2, null);
		}
		return autoGeneratedKeys;
	}

	public String saveFormOnePartTwoInformation(int autoGeneratedKeys, String typeOfOre, JSONArray jsonarray,
			JSONArray jsonarray1, JSONArray jsonarray2, JSONArray jsonarray3) {
		JSONObject jsonObject = new JSONObject();
		Connection con = null;
		ResultSet rs = null;
		PreparedStatement pst = null;
		PreparedStatement pstmt = null;
		PreparedStatement pstmt1 = null;
		PreparedStatement pstmt2 = null;
		PreparedStatement pstmt3 = null;
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pst = con.prepareStatement(IronMiningStatement.UPDATE_TYPE_OF_ORE);
			pst.setString(1, typeOfOre);
			pst.setInt(2, autoGeneratedKeys);
			pst.executeUpdate();
			for (int i = 0; i < jsonarray.length(); i++) {
				jsonObject = jsonarray.getJSONObject(i);
				String category = "";
				float openStock = 0;
				float production = 0;
				float closingStock = 0;
				int autoIncId = 0;
				if (jsonObject.getString("autoIncIdIndex") != null
						&& !jsonObject.getString("autoIncIdIndex").equals("")) {
					autoIncId = Integer.parseInt(jsonObject.getString("autoIncIdIndex"));
				}
				if (jsonObject.getString("categoryIndex") != null
						&& !jsonObject.getString("categoryIndex").equals("")) {
					category = jsonObject.getString("categoryIndex");
				}
				if (jsonObject.getString("openStockIndex") != null
						&& !jsonObject.getString("openStockIndex").equals("")) {
					openStock = Float.parseFloat(jsonObject.getString("openStockIndex"));
				}
				if (jsonObject.getString("productionIndex") != null
						&& !jsonObject.getString("productionIndex").equals("")) {
					production = Float.parseFloat(jsonObject.getString("productionIndex"));
				}
				if (jsonObject.getString("closingStockIndex") != null
						&& !jsonObject.getString("closingStockIndex").equals("")) {
					closingStock = Float.parseFloat(jsonObject.getString("closingStockIndex"));
				}
				if (autoIncId > 0) {
					pstmt = con.prepareStatement(IronMiningStatement.UPDATE_PRODUCTION_AND_STOCK_DETAILS);
					pstmt.setString(1, category);
					pstmt.setFloat(2, openStock);
					pstmt.setFloat(3, production);
					pstmt.setFloat(4, closingStock);
					pstmt.setInt(5, autoIncId);
					pstmt.executeUpdate();
				} else {
					pstmt = con.prepareStatement(IronMiningStatement.INSERT_PRODUCTION_AND_STOCK_DETAILS);
					pstmt.setInt(1, autoGeneratedKeys);
					pstmt.setString(2, category);
					pstmt.setFloat(3, openStock);
					pstmt.setFloat(4, production);
					pstmt.setFloat(5, closingStock);
					pstmt.executeUpdate();
				}
			}
			for (int i = 0; i < jsonarray1.length(); i++) {
				jsonObject = jsonarray1.getJSONObject(i);
				String grades = "";
				float openStock = 0;
				float product = 0;
				float despatch = 0;
				float closeStock = 0;
				float PMV = 0;
				int autoIncId = 0;
				if (jsonObject.getString("autoIncIdIndex") != null
						&& !jsonObject.getString("autoIncIdIndex").equals("")) {
					autoIncId = Integer.parseInt(jsonObject.getString("autoIncIdIndex"));
				}
				if (jsonObject.getString("gradesIndex") != null && !jsonObject.getString("gradesIndex").equals("")) {
					grades = jsonObject.getString("gradesIndex");
				}
				if (jsonObject.getString("openingStockIndex") != null
						&& !jsonObject.getString("openingStockIndex").equals("")) {
					openStock = Float.parseFloat(jsonObject.getString("openingStockIndex"));
				}
				if (jsonObject.getString("productIndex") != null && !jsonObject.getString("productIndex").equals("")) {
					product = Float.parseFloat(jsonObject.getString("productIndex"));
				}
				if (jsonObject.getString("despatchIndex") != null
						&& !jsonObject.getString("despatchIndex").equals("")) {
					despatch = Float.parseFloat(jsonObject.getString("despatchIndex"));
				}
				if (jsonObject.getString("closeStockIndex") != null
						&& !jsonObject.getString("closeStockIndex").equals("")) {
					closeStock = Float.parseFloat(jsonObject.getString("closeStockIndex"));
				}
				if (jsonObject.getString("PMVIndex") != null && !jsonObject.getString("PMVIndex").equals("")) {
					PMV = Float.parseFloat(jsonObject.getString("PMVIndex"));
				}
				if (autoIncId > 0) {
					pstmt1 = con.prepareStatement(IronMiningStatement.UPDATE_GRADE_WISE_MINERAL_DEATILS);
					pstmt1.setString(1, grades);
					pstmt1.setFloat(2, openStock);
					pstmt1.setFloat(3, product);
					pstmt1.setFloat(4, despatch);
					pstmt1.setFloat(5, closeStock);
					pstmt1.setFloat(6, PMV);
					pstmt1.setInt(7, autoIncId);
					pstmt1.executeUpdate();
				} else {
					pstmt1 = con.prepareStatement(IronMiningStatement.INSERT_GRADE_WISE_MINERAL_DEATILS);
					pstmt1.setInt(1, autoGeneratedKeys);
					pstmt1.setString(2, grades);
					pstmt1.setFloat(3, openStock);
					pstmt1.setFloat(4, product);
					pstmt1.setFloat(5, despatch);
					pstmt1.setFloat(6, closeStock);
					pstmt1.setFloat(7, PMV);
					pstmt1.executeUpdate();
				}
			}
			for (int i = 0; i < jsonarray2.length(); i++) {
				jsonObject = jsonarray2.getJSONObject(i);
				String deduction = "";
				float matircsTons = 0;
				String remarks = "";
				int autoIncId = 0;
				if (jsonObject.getString("autoIncIdIndex") != null
						&& !jsonObject.getString("autoIncIdIndex").equals("")) {
					autoIncId = Integer.parseInt(jsonObject.getString("autoIncIdIndex"));
				}
				if (jsonObject.getString("DeductionClaimedIndex") != null
						&& !jsonObject.getString("DeductionClaimedIndex").equals("")) {
					deduction = jsonObject.getString("DeductionClaimedIndex");
				}
				if (jsonObject.getString("matricsTonesIndex") != null
						&& !jsonObject.getString("matricsTonesIndex").equals("")) {
					matircsTons = Float.parseFloat(jsonObject.getString("matricsTonesIndex"));
				}
				if (jsonObject.getString("remarksIndex") != null && !jsonObject.getString("remarksIndex").equals("")) {
					remarks = jsonObject.getString("remarksIndex");
				}
				if (autoIncId > 0) {
					pstmt2 = con.prepareStatement(IronMiningStatement.UPDATE_DEDUCTION_SALES_DETAILS);
					pstmt2.setString(1, deduction);
					pstmt2.setFloat(2, matircsTons);
					pstmt2.setString(3, remarks);
					pstmt2.setInt(4, autoIncId);
					pstmt2.executeUpdate();
				} else {
					pstmt2 = con.prepareStatement(IronMiningStatement.INSERT_DEDUCTION_SALES_DETAILS);
					pstmt2.setInt(1, autoGeneratedKeys);
					pstmt2.setString(2, deduction);
					pstmt2.setFloat(3, matircsTons);
					pstmt2.setString(4, remarks);
					pstmt2.executeUpdate();
				}
			}
			for (int i = 0; i < jsonarray3.length(); i++) {
				jsonObject = jsonarray3.getJSONObject(i);
				String grade = "";
				String despatch = "";
				String cosumptConsignee = "";
				float ConsumptQuantity = 0;
				float ConsumptSales = 0;
				String exportCountry = "";
				float exportQuality = 0;
				float exportFOB = 0;
				int autoIncId = 0;
				if (jsonObject.getString("autoIncIdIndex") != null
						&& !jsonObject.getString("autoIncIdIndex").equals("")) {
					autoIncId = Integer.parseInt(jsonObject.getString("autoIncIdIndex"));
				}
				if (jsonObject.getString("gradeIndex") != null && !jsonObject.getString("gradeIndex").equals("")) {
					grade = jsonObject.getString("gradeIndex");
				}
				if (jsonObject.getString("despatchIndex") != null
						&& !jsonObject.getString("despatchIndex").equals("")) {
					despatch = jsonObject.getString("despatchIndex");
				}
				if (jsonObject.getString("domConsumptConsigneeNameIndex") != null
						&& !jsonObject.getString("domConsumptConsigneeNameIndex").equals("")) {
					cosumptConsignee = jsonObject.getString("domConsumptConsigneeNameIndex");
				}
				if (jsonObject.getString("domConsumptQuantityIndex") != null
						&& !jsonObject.getString("domConsumptQuantityIndex").equals("")) {
					ConsumptQuantity = Float.parseFloat(jsonObject.getString("domConsumptQuantityIndex"));
				}
				if (jsonObject.getString("domConsumptSalesValueIndex") != null
						&& !jsonObject.getString("domConsumptSalesValueIndex").equals("")) {
					ConsumptSales = Float.parseFloat(jsonObject.getString("domConsumptSalesValueIndex"));
				}
				if (jsonObject.getString("exportCountryIndex") != null
						&& !jsonObject.getString("exportCountryIndex").equals("")) {
					exportCountry = jsonObject.getString("exportCountryIndex");
				}
				if (jsonObject.getString("exportQualityIndex") != null
						&& !jsonObject.getString("exportQualityIndex").equals("")) {
					exportQuality = Float.parseFloat(jsonObject.getString("exportQualityIndex"));
				}
				if (jsonObject.getString("exportFOBIndex") != null
						&& !jsonObject.getString("exportFOBIndex").equals("")) {
					exportFOB = Float.parseFloat(jsonObject.getString("exportFOBIndex"));
				}
				if (autoIncId > 0) {
					pstmt3 = con.prepareStatement(IronMiningStatement.UPDATE_DOMESTIC_EXPORT_SALES_DEATILS);
					pstmt3.setString(1, grade);
					pstmt3.setString(2, despatch);
					pstmt3.setString(3, cosumptConsignee);
					pstmt3.setFloat(4, ConsumptQuantity);
					pstmt3.setFloat(5, ConsumptSales);
					pstmt3.setString(6, exportCountry);
					pstmt3.setFloat(7, exportQuality);
					pstmt3.setFloat(8, exportFOB);
					pstmt3.setInt(9, autoIncId);
					pstmt3.executeUpdate();
				} else {
					pstmt3 = con.prepareStatement(IronMiningStatement.INSERT_DOMESTIC_EXPORT_SALES_DEATILS);
					pstmt3.setInt(1, autoGeneratedKeys);
					pstmt3.setString(2, grade);
					pstmt3.setString(3, despatch);
					pstmt3.setString(4, cosumptConsignee);
					pstmt3.setFloat(5, ConsumptQuantity);
					pstmt3.setFloat(6, ConsumptSales);
					pstmt3.setString(7, exportCountry);
					pstmt3.setFloat(8, exportQuality);
					pstmt3.setFloat(9, exportFOB);
					pstmt3.executeUpdate();
				}

			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
			DBConnection.releaseConnectionToDB(null, pstmt1, null);
			DBConnection.releaseConnectionToDB(null, pstmt2, null);
			DBConnection.releaseConnectionToDB(null, pstmt3, null);
		}
		return "Saved Successfully";
	}

	public String saveFormOnePartThreeInformation(int autoGeneratedKeys, String production, String gradeWise,
			String remarks, String place, String date, String name, String designation) {
		Connection con = null;
		ResultSet rs = null;
		PreparedStatement pstmt = null;
		int updated = 0;
		String message = "";
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(IronMiningStatement.UPDATE_PROD_GRADE_REASON);
			pstmt.setString(1, production);
			pstmt.setString(2, gradeWise);
			pstmt.setString(3, remarks);
			pstmt.setString(4, place);
			pstmt.setString(5, date);
			pstmt.setString(6, name);
			pstmt.setString(7, designation);
			pstmt.setInt(8, autoGeneratedKeys);
			updated = pstmt.executeUpdate();
			if (updated > 0) {
				message = "Save Successfully";
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return message;
	}

	public JSONArray getPaymentACHead(int customerId, int systemId) {
		JSONArray JsonArray = null;
		JSONObject JsonObject = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			JsonArray = new JSONArray();
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(IronMiningStatement.GET_PAYMENT_ACC_HEAD);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, customerId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				JsonObject = new JSONObject();
				JsonObject.put("paymentAccHeadId", rs.getInt("ID"));
				JsonObject.put("paymentAccHead", rs.getString("PAYMENT_ACC_HEAD"));
				JsonArray.put(JsonObject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return JsonArray;
	}

	public JSONArray getMineOwnerDetails(int customerId, int systemId) {
		JSONArray JsonArray = null;
		JSONObject JsonObject = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			JsonArray = new JSONArray();
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(IronMiningStatement.GET_MINE_OWNER_NAME);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, customerId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				JsonObject = new JSONObject();
				JsonObject.put("mineOwnerId", rs.getString("ID"));
				JsonObject.put("mineOwnerName", rs.getString("LEASE_NAME"));
				JsonArray.put(JsonObject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return JsonArray;
	}

	public JSONArray getTCNumberDetails(int customerId, int systemId, int userId) {
		JSONArray JsonArray = null;
		JSONObject JsonObject = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			JsonArray = new JSONArray();
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(IronMiningStatement.GET_TC_NUMBER_CHA);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, customerId);
			pstmt.setInt(3, userId);
			pstmt.setInt(4, systemId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				JsonObject = new JSONObject();
				JsonObject.put("TCno", rs.getString("TC_NO"));
				JsonObject.put("MiningName", rs.getString("NAME_OF_MINE"));
				JsonObject.put("TCID", rs.getInt("ID"));
				JsonObject.put("MineCode", rs.getString("MINE_CODE"));
				JsonObject.put("ownerName", rs.getString("OWNER_NAME"));
				JsonObject.put("orgName", rs.getString("ORGANIZATION_NAME"));
				JsonObject.put("quantity", rs.getString("QUANTITY"));
				JsonObject.put("ecAllocated", rs.getString("EC_ALLOCATED"));
				JsonObject.put("mplBal", rs.getString("MPL_BALANCE"));
				JsonObject.put("ctoDate", rs.getString("CTO_DATE"));
				JsonArray.put(JsonObject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return JsonArray;
	}

	public JSONArray getMineralType(int systemId) {
		JSONArray JsonArray = null;
		JSONObject JsonObject = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			JsonArray = new JSONArray();
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(IronMiningStatement.GET_MINERAL_TPYE);
			pstmt.setInt(1, systemId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				JsonObject = new JSONObject();
				JsonObject.put("mineralCode", rs.getString("MINERAL_CODE"));
				JsonObject.put("mineralName", rs.getString("MINERAL_NAME"));
				JsonArray.put(JsonObject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return JsonArray;
	}

	public JSONArray getGradeAndRate(String MineralType, String RoyaltyDate, int custId, int SysId) {
		JSONArray JsonArray = null;
		JSONObject JsonObject = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		DecimalFormat df = new DecimalFormat("0.00");
		try {
			JsonArray = new JSONArray();
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(IronMiningStatement.GET_GRADE_AND_RATE);
			pstmt.setString(1, MineralType);
			pstmt.setString(2, RoyaltyDate);
			pstmt.setString(3, RoyaltyDate);
			pstmt.setInt(4, custId);
			pstmt.setInt(5, SysId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				JsonObject = new JSONObject();
				String grade = rs.getString("GRADE") + " (" + rs.getString("TYPE") + ")";
				JsonObject.put("rate", df.format(rs.getDouble("RATE") * 0.15));
				JsonObject.put("Giopfrate", df.format(rs.getDouble("RATE") * 0.10));
				JsonObject.put("grade", grade);
				JsonArray.put(JsonObject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return JsonArray;
	}

	private synchronized int getChallanNumber(Connection conAdmin, int systemId, int customerId, String curyear) {
		PreparedStatement pstmt550 = null;
		PreparedStatement pstmt55 = null;
		ResultSet rs550 = null;
		int enrolmentnonew = 0;
		try {
			pstmt550 = conAdmin.prepareStatement(IronMiningStatement.GET_ENROLLMENT_NUMBER, ResultSet.TYPE_FORWARD_ONLY,
					ResultSet.CONCUR_UPDATABLE);
			pstmt550.setString(1, "CHALLAN_NO");
			pstmt550.setInt(2, systemId);
			pstmt550.setInt(3, customerId);
			pstmt550.setString(4, curyear);
			rs550 = pstmt550.executeQuery();
			if (rs550.next()) {
				enrolmentnonew = rs550.getInt("VALUE");
				enrolmentnonew++;
				rs550.updateInt("VALUE", enrolmentnonew);
				rs550.rowUpdated();
				pstmt55 = conAdmin.prepareStatement(IronMiningStatement.UPDATE_ENROLLMENT_NO_TO_LOOKUP);
				pstmt55.setInt(1, enrolmentnonew);
				pstmt55.setString(2, "CHALLAN_NO");
				pstmt55.setInt(3, systemId);
				pstmt55.setInt(4, customerId);
				pstmt55.setString(5, curyear);
				pstmt55.executeUpdate();
			} else {
				enrolmentnonew++;
				pstmt55 = conAdmin.prepareStatement(IronMiningStatement.INSERT_ENROLLMENT_NUMBER_TO_LOOKUP);
				pstmt55.setString(1, "CHALLAN_NO");
				pstmt55.setInt(2, enrolmentnonew);
				pstmt55.setString(3, curyear);
				pstmt55.setInt(4, systemId);
				pstmt55.setInt(5, customerId);
				pstmt55.executeUpdate();
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(null, pstmt550, rs550);
			DBConnection.releaseConnectionToDB(null, pstmt55, null);
		}
		return enrolmentnonew;
	}

	public ArrayList getChallanDetails(String customerName, int systemId, int CustomerId, int userId, int offSet,
			String fromDate, String endDate, int selectedChallanId, int selectedOrgId) {
		JSONArray JsonArray = new JSONArray();
		JSONObject JsonObject = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		ResultSet rs1 = null;
		int aslcount = 0;
		int count = 0;
		float qty = 0;
		float rate = 0;
		double dmf = 0;
		double nmet = 0;
		float processingFee = 0;
		double totalPay = 0;
		double payable = 0;
		ArrayList<Object> finlist = new ArrayList<Object>();
		ArrayList<ReportHelper> reportsList = new ArrayList<ReportHelper>();
		ArrayList<String> headersList = new ArrayList<String>();
		ReportHelper finalreporthelper = new ReportHelper();
		double LmeRate = 0;
		double tdsPerc = 0;
		double dollarRate = 0;
		double gradeRate = 0;
		double rateB = 0;
		double cellAmt = 0;
		double processFeeRate = 0;
		double qtyB = 0;
		double totalRoyality = 0;
		double royality = 0;
		double totalChallanAmt = 0;

		headersList.add("Sl No");
		headersList.add("Unique Id");
		headersList.add("Challan Number");
		headersList.add("Status");
		headersList.add("Payment A/C Head");
		headersList.add("Payment Account Head Id");
		headersList.add("Tc Number");
		headersList.add("Tc Number Id");
		headersList.add("Lease Name");
		headersList.add("Organization Name");
		headersList.add("Total Quantity");
		headersList.add("Used Quantity");
		headersList.add("Royalty");
		headersList.add("DMF");
		headersList.add("NMET");
		headersList.add("Processing Fee Amount");
		headersList.add("PF Payable");
		headersList.add("GIOPF");
		headersList.add("Total Challan Amount");
		headersList.add("Type");
		headersList.add("Mine Code");
		headersList.add("Mine Owner");
		headersList.add("IBM Average Sale Price Month ");
		headersList.add("Transportation Month");
		headersList.add("Royalty Date");
		headersList.add("Mineral Type");
		headersList.add("Mineral Code");
		headersList.add("Challan Type");
		headersList.add("Financial Year");
		headersList.add("Payment Description");
		headersList.add("Date");
		headersList.add("Bank Transaction Number");
		headersList.add("Bank");
		headersList.add("Branch");
		headersList.add("Amount Paid");
		headersList.add("Payment Descriptoin");
		headersList.add("Acknowledgement Generation Datetime");

		headersList.add("Closed Permit Id");
		headersList.add("Closed Permit No");

		headersList.add("E-Wallet Balence");
		headersList.add("E-Wallet Used");
		headersList.add("Total Payable");
		headersList.add("Processing Fee");

		headersList.add("Royalty Challan No");
		headersList.add("Royalty Challan Date");
		headersList.add("DMF Challan No");
		headersList.add("DMF Challan Date");
		headersList.add("NMET Challan No");
		headersList.add("NMET Challan Date");
		headersList.add("PF Challan No");
		headersList.add("PF Challan Date");
		headersList.add("GIOPF Challan No");
		headersList.add("GIOPF Challan Date");

		headersList.add("orgId");
		headersList.add("Organization/Trader Code");
		//headersList.add("Organization/Trader Name");
		headersList.add("Issued Date Time");
		headersList.add("District Name");

		ArrayList assetList = new ArrayList();
		SimpleDateFormat diffddMMyyyyHHmmss = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
		SimpleDateFormat diffddMMyyyyHHmmss1 = new SimpleDateFormat("dd-MM-yyyy");
		SimpleDateFormat MMddyyyy = new SimpleDateFormat("MM-dd-yyyy");
		SimpleDateFormat MMMMMyyyy = new SimpleDateFormat("MMMMM yyyy");
		DecimalFormat df = new DecimalFormat("0.00");

		try {
			con = DBConnection.getConnectionToDB("AMS");
			if (selectedChallanId == 0 && selectedOrgId == 0) {
				pstmt = con.prepareStatement(IronMiningStatement.GET_MINING_CHALLAN_DETAILS.replace("#conditions#",
						" and(a.TC_NO in (select TC_ID from MINING.dbo.USER_TC_ASSOCIATION where USER_ID=? and SYSTEM_ID=a.SYSTEM_ID and TC_ID!=0) or "
								+ "a.ORGANIZATION_ID in (select ORG_ID from MINING.dbo.USER_TC_ASSOCIATION where USER_ID=? and SYSTEM_ID=a.SYSTEM_ID)) and CHALLAN_DATETIME between dateadd(mi,-330,?) and dateadd(mi,-330,?) "));
				pstmt.setInt(1, offSet);
				pstmt.setInt(2, systemId);
				pstmt.setInt(3, CustomerId);
				pstmt.setInt(4, userId);
				pstmt.setInt(5, userId);
				pstmt.setString(6, fromDate);
				pstmt.setString(7, endDate);
			} else if (selectedChallanId != 0 && selectedOrgId == 0) {
				pstmt = con.prepareStatement(
						IronMiningStatement.GET_MINING_CHALLAN_DETAILS.replace("#conditions#", " and a.ID=? "));
				pstmt.setInt(1, offSet);
				pstmt.setInt(2, systemId);
				pstmt.setInt(3, CustomerId);
				pstmt.setInt(4, selectedChallanId);
			} else if (selectedChallanId == 0 && selectedOrgId != 0) {
				pstmt = con.prepareStatement(IronMiningStatement.GET_MINING_CHALLAN_DETAILS.replace("#conditions#",
						" and (a.ORGANIZATION_ID=? or "
								+ "a.TC_NO in (select a1.ID from AMS.dbo.MINING_TC_MASTER a1 left outer join AMS.dbo.MINING_MINE_MASTER b1 on b1.ID=a1.MINE_ID and a1.SYSTEM_ID=b1.SYSTEM_ID and a1.CUSTOMER_ID=b1.CUSTOMER_ID  where b1.ORG_ID=? ))"));
				pstmt.setInt(1, offSet);
				pstmt.setInt(2, systemId);
				pstmt.setInt(3, CustomerId);
				pstmt.setInt(4, selectedOrgId);
				pstmt.setInt(5, selectedOrgId);
			}
			rs = pstmt.executeQuery();
			while (rs.next()) {
				qty = 0;
				rate = 0;
				dmf = 0;
				nmet = 0;
				processingFee = 0;
				totalPay = 0;
				payable = 0;
				JsonObject = new JSONObject();
				ArrayList<Object> informationList = new ArrayList<Object>();
				ReportHelper reporthelper = new ReportHelper();
				count++;
				JsonObject.put("slnoIndex", count);
				informationList.add(count);

				JsonObject.put("uniqueIdDataIndex", rs.getInt("ID"));
				informationList.add(rs.getInt("ID"));

				JsonObject.put("challanNumberDataIndex", rs.getString("CHALLAN_NO"));
				informationList.add(rs.getString("CHALLAN_NO"));

				JsonObject.put("openStatusDataIndex", rs.getString("STATUS"));
				informationList.add(rs.getString("STATUS"));

				JsonObject.put("paymentAcHeadDataIndex", rs.getString("PAYMENT_ACC_HEAD"));
				informationList.add(rs.getString("PAYMENT_ACC_HEAD"));

				JsonObject.put("paymentAcHeadIdDataIndex", rs.getString("PAY_ACC"));
				informationList.add(rs.getString("PAY_ACC"));

				JsonObject.put("TCNODataIndex", rs.getString("TC_NO"));
				informationList.add(rs.getString("TC_NO"));

				JsonObject.put("TCNOIdDataIndex", rs.getString("TC_ID"));
				informationList.add(rs.getString("TC_ID"));

				JsonObject.put("MineNameDataIndex", rs.getString("MINING_LEASE"));
				informationList.add(rs.getString("MINING_LEASE"));

				if (!rs.getString("ORGANIZATION_NAME").equals("")) {
					JsonObject.put("orgNameDataIndex", rs.getString("ORGANIZATION_NAME"));
					informationList.add(rs.getString("ORGANIZATION_NAME"));
				} else {
					JsonObject.put("orgNameDataIndex", rs.getString("ORGANIZATION_NAME_PF"));
					informationList.add(rs.getString("ORGANIZATION_NAME_PF"));
				}
				pstmt = con.prepareStatement(IronMiningStatement.GET_MINING_CHALLAN_GRADE_DETAILS);
				pstmt.setInt(1, rs.getInt("ID"));
				rs1 = pstmt.executeQuery();
				while (rs1.next()) {
					qty = qty + rs1.getFloat("QUANTITY");
					rate = rate + rs1.getFloat("RATE");
					payable = payable + rs1.getFloat("PAYABLE");
					if (rs.getString("CHALLAN_TYPE").equalsIgnoreCase("Bauxite Challan")) {
						if (rs1.getString("GRADE").equals("LME RATE")) {
							LmeRate = rs1.getDouble("RATE");
						}
						if (rs1.getString("GRADE").equals("DOLLAR RATE")) {
							dollarRate = rs1.getDouble("RATE");
						}
						if (rs1.getString("GRADE").equals("GRADE RATE")) {
							gradeRate = rs1.getDouble("RATE");
						}
						if (rs1.getString("GRADE").equals("RATE")) {
							rateB = rs1.getDouble("RATE");
						}
						if (rs1.getString("GRADE").equals("QUANTITY")) {
							qtyB = rs1.getDouble("RATE");
						}
						if (rs1.getString("GRADE").equals("CELL AMOUNT RATE")) {
							cellAmt = rs1.getDouble("RATE");
						}
						if (rs1.getString("GRADE").equals("PROCESSING FEE RATE")) {
							processFeeRate = rs1.getDouble("RATE");
						}
						if (rs1.getString("GRADE").equals("TDS PERCENTAGE")) {
							tdsPerc = (rs1.getDouble("RATE")) / 100;
						}
					}
				}
				payable = Math.round(payable);
				dmf = Math.round(payable * (0.3));
				nmet = Math.round(payable * (0.02));
				if (rs.getString("CHALLAN_TYPE").equalsIgnoreCase("Others")) {
					dmf = 0;
					nmet = 0;
					processingFee = 0;
				}
				if (rs.getString("CHALLAN_TYPE").equalsIgnoreCase("Bauxite Challan")) {
					royality = (LmeRate * dollarRate * gradeRate) * (rateB / 100);
					totalRoyality = ((LmeRate * dollarRate * gradeRate) * (rateB / 100)) * qtyB;
					totalChallanAmt = (totalRoyality) + (totalRoyality * 0.3) + (qtyB * processFeeRate)
							+ (qtyB * cellAmt) + (totalRoyality * tdsPerc) + (totalRoyality * 0.02);
					dmf = totalRoyality * 0.3;
					nmet = totalRoyality * 0.02;
					processingFee = (float) (qtyB * processFeeRate);
					payable = totalRoyality;
					qty = (float) qtyB;
				}
				if (rs.getFloat("PROCESSING_FEE") != 0) {
					processingFee = qty * rs.getFloat("PROCESSING_FEE");
				}
				totalPay = Math.round(dmf + nmet + payable + processingFee + (rs.getDouble("GIOPF_PAYABLE")));
				JsonObject.put("totalQtyDataIndex", df.format(qty));
				informationList.add(df.format(qty));

				JsonObject.put("usedQtyDataIndex", df.format(rs.getDouble("USED_QTY") / 1000));
				informationList.add(df.format(rs.getDouble("USED_QTY") / 1000));

				if (rs.getString("TYPE").equalsIgnoreCase("Royalty")) {
					JsonObject.put("royaltyAmtDataIndex", rs.getString("TOTAL_PAYABLE"));
					informationList.add(rs.getString("TOTAL_PAYABLE"));
				} else {
					JsonObject.put("royaltyAmtDataIndex", df.format(payable));
					informationList.add(df.format(payable));
				}

				if (rs.getString("TYPE").equalsIgnoreCase("DMF")) {
					JsonObject.put("DMFDataIndex", rs.getString("TOTAL_PAYABLE"));
					informationList.add(rs.getString("TOTAL_PAYABLE"));
				} else {
					JsonObject.put("DMFDataIndex", df.format(dmf));
					informationList.add(df.format(dmf));
				}

				if (rs.getString("TYPE").equalsIgnoreCase("NMET")) {
					JsonObject.put("NMETDataIndex", rs.getString("TOTAL_PAYABLE"));
					informationList.add(rs.getString("TOTAL_PAYABLE"));
				} else {
					JsonObject.put("NMETDataIndex", df.format(nmet));
					informationList.add(df.format(nmet));
				}

				JsonObject.put("pFeeAmtDataIndex", df.format(processingFee));
				informationList.add(df.format(processingFee));

				if (rs.getString("TYPE").equalsIgnoreCase("NMET") || rs.getString("TYPE").equalsIgnoreCase("DMF")
						|| rs.getString("TYPE").equalsIgnoreCase("GIOPF")
						|| rs.getString("TYPE").equalsIgnoreCase("Royalty")) {
					JsonObject.put("totalPayableDataIndex", 0);
					informationList.add(0);
				} else {
					JsonObject.put("totalPayableDataIndex", rs.getString("TOTAL_PAYABLE"));
					informationList.add(rs.getString("TOTAL_PAYABLE"));
				}

				//				JsonObject.put("totalPayableDataIndex", rs.getString("TOTAL_PAYABLE"));
				//				informationList.add(rs.getString("TOTAL_PAYABLE"));
				//				
				if (rs.getString("TYPE").equalsIgnoreCase("GIOPF")) {
					JsonObject.put("GIDataIndex", rs.getString("TOTAL_PAYABLE"));
					informationList.add(rs.getString("TOTAL_PAYABLE"));
				} else {
					JsonObject.put("GIDataIndex", df.format(rs.getDouble("GIOPF_PAYABLE")));
					informationList.add(df.format(rs.getDouble("GIOPF_PAYABLE")));
				}

				if (rs.getString("CHALLAN_TYPE").equalsIgnoreCase("Bauxite Challan")) {
					JsonObject.put("payableDataIndex", df.format(totalChallanAmt));
					informationList.add(df.format(totalChallanAmt));
				} else {
					JsonObject.put("payableDataIndex", df.format(totalPay));
					informationList.add(df.format(totalPay));
				}

				JsonObject.put("typeDataIndex", rs.getString("TYPE"));
				informationList.add(rs.getString("TYPE"));

				JsonObject.put("MineCodeDataIndex", rs.getString("MINE_CODE"));
				informationList.add(rs.getString("MINE_CODE"));

				JsonObject.put("ownerNameDataIndex", rs.getString("LEASE_NAME"));
				informationList.add(rs.getString("LEASE_NAME"));

				if (rs.getString("CHALLAN_TYPE").equalsIgnoreCase("Processing Fee")) {
					JsonObject.put("royaltyDataIndex", "");
					informationList.add("");

					JsonObject.put("TransMonthIndex", "");
					informationList.add("");

					JsonObject.put("royaltyDateDataIndex", "");
					informationList.add("");

				} else {
					JsonObject.put("royaltyDataIndex", rs.getString("ROYALITY_FOR_MONTH"));
					informationList.add(rs.getString("ROYALITY_FOR_MONTH"));

					if (rs.getString("PREVIOUS_CHALLAN_DATE").contains("1900")) {
						JsonObject.put("TransMonthIndex", "");
						informationList.add("");
					} else {
						JsonObject.put("TransMonthIndex", MMMMMyyyy.format(rs.getTimestamp("PREVIOUS_CHALLAN_DATE")));
						informationList.add(MMMMMyyyy.format(rs.getTimestamp("PREVIOUS_CHALLAN_DATE")));
					}

					if (rs.getString("ROY_DATE").contains("1900")) {
						JsonObject.put("royaltyDateDataIndex", "");
						informationList.add("");
					} else {
						JsonObject.put("royaltyDateDataIndex", MMddyyyy.format(rs.getTimestamp("ROY_DATE")));
						informationList.add(diffddMMyyyyHHmmss1.format(rs.getTimestamp("ROY_DATE")));
					}
				}

				JsonObject.put("mineralTypeDataIndex", rs.getString("MINERAL_TYPE"));
				informationList.add(rs.getString("MINERAL_TYPE"));

				JsonObject.put("mineralCodeDataIndex", rs.getString("MINERAL_CODE"));
				informationList.add(rs.getString("MINERAL_CODE"));

				JsonObject.put("challanTypeDataIndex", rs.getString("CHALLAN_TYPE"));
				informationList.add(rs.getString("CHALLAN_TYPE"));

				JsonObject.put("financialYrDataIndex", rs.getString("FINANCIAL_YEAR"));
				informationList.add(rs.getString("FINANCIAL_YEAR"));

				JsonObject.put("paymentDescriptionDataIndex", rs.getString("PAYMENT_DESC"));
				informationList.add(rs.getString("PAYMENT_DESC"));

				if (rs.getString("CHALLAN_DATETIME").contains("1900")) {
					JsonObject.put("dateDataIndex", "");
					informationList.add("");
				} else {
					JsonObject.put("dateDataIndex",
							new SimpleDateFormat("dd-MM-yyyy").format(rs.getTimestamp("CHALLAN_DATETIME")));
					informationList.add(new SimpleDateFormat("dd-MM-yyyy").format(rs.getTimestamp("CHALLAN_DATETIME")));
				}

				JsonObject.put("transactionDataIndex", rs.getString("BANK_TRANS_NO"));
				informationList.add(rs.getString("BANK_TRANS_NO"));

				JsonObject.put("bankDataIndex", rs.getString("BANK_NAME"));
				informationList.add(rs.getString("BANK_NAME"));

				JsonObject.put("branchDataIndex", rs.getString("BRANCH"));
				informationList.add(rs.getString("BRANCH"));

				JsonObject.put("amountDataIndex", rs.getString("AMOUNT_PAID"));
				informationList.add(rs.getString("AMOUNT_PAID"));

				JsonObject.put("paymentDataIndex", rs.getString("ACK_PAYMENT_DESC"));
				informationList.add(rs.getString("ACK_PAYMENT_DESC"));

				if (rs.getString("ACK_DATETIME").contains("1900")) {
					JsonObject.put("AckGenDataIndex", "");
					informationList.add("");
				} else {
					JsonObject.put("AckGenDataIndex", diffddMMyyyyHHmmss.format(rs.getTimestamp("ACK_DATETIME")));
					informationList.add(diffddMMyyyyHHmmss.format(rs.getTimestamp("ACK_DATETIME")));
				}

				JsonObject.put("closedPermitIdDataIndex", rs.getString("CLOSED_PERMIT_ID"));
				informationList.add(rs.getString("CLOSED_PERMIT_ID"));

				JsonObject.put("closedPermitNoDataIndex", rs.getString("PERMIT_NO"));
				informationList.add(rs.getString("PERMIT_NO"));

				JsonObject.put("ewalletBalance2DataIndex", rs.getString("E_WALLET_BALANCE"));
				informationList.add(rs.getString("E_WALLET_BALANCE"));

				JsonObject.put("ewalletBalanceDataIndex", rs.getString("E_WALLET_USED"));
				informationList.add(rs.getString("E_WALLET_USED"));

				if (rs.getString("CHALLAN_TYPE").equalsIgnoreCase("Others")) {
					JsonObject.put("ewalletPayableDataIndex", df.format(payable));
					informationList.add(df.format(payable));
				} else if (rs.getString("CHALLAN_TYPE").equalsIgnoreCase("Bauxite Challan")) {
					JsonObject.put("ewalletPayableDataIndex", df.format(totalChallanAmt));
					informationList.add(df.format(totalChallanAmt));
				} else {
					JsonObject.put("ewalletPayableDataIndex", rs.getString("TOTAL_EWALLET_PAYABLE"));
					informationList.add(rs.getString("TOTAL_EWALLET_PAYABLE"));
				}
				JsonObject.put("pFeeDataIndex", rs.getString("PROCESSING_FEE"));
				informationList.add(rs.getString("PROCESSING_FEE"));

				JsonObject.put("challanNoDataIndex", rs.getString("NIC_CHALLAN_NO"));
				informationList.add(rs.getString("NIC_CHALLAN_NO"));

				if (rs.getString("NIC_CHALLAN_DATE").contains("1900")) {
					JsonObject.put("challanDateDataIndex", "");
					informationList.add("");
				} else {
					JsonObject.put("challanDateDataIndex", MMddyyyy.format(rs.getTimestamp("NIC_CHALLAN_DATE")));
					informationList.add(diffddMMyyyyHHmmss1.format(rs.getTimestamp("NIC_CHALLAN_DATE")));
				}
				JsonObject.put("DMFchallanNoDataIndex", rs.getString("DMF_NIC_CHALLAN_NO"));
				informationList.add(rs.getString("DMF_NIC_CHALLAN_NO"));

				if (rs.getString("DMF_NIC_CHALLAN_DATE").contains("1900")) {
					JsonObject.put("DMFchallanDateDataIndex", "");
					informationList.add("");
				} else {
					JsonObject.put("DMFchallanDateDataIndex", MMddyyyy.format(rs.getTimestamp("DMF_NIC_CHALLAN_DATE")));
					informationList.add(diffddMMyyyyHHmmss1.format(rs.getTimestamp("DMF_NIC_CHALLAN_DATE")));
				}

				JsonObject.put("NMETchallanNoDataIndex", rs.getString("NMET_NIC_CHALLAN_NO"));
				informationList.add(rs.getString("NMET_NIC_CHALLAN_NO"));

				if (rs.getString("NMET_NIC_CHALLAN_DATE").contains("1900")) {
					JsonObject.put("NMETchallanDateDataIndex", "");
					informationList.add("");
				} else {
					JsonObject.put("NMETchallanDateDataIndex",
							MMddyyyy.format(rs.getTimestamp("NMET_NIC_CHALLAN_DATE")));
					informationList.add(diffddMMyyyyHHmmss1.format(rs.getTimestamp("NMET_NIC_CHALLAN_DATE")));
				}

				JsonObject.put("PFchallanNoDataIndex", rs.getString("PF_NIC_CHALLAN_NO"));
				informationList.add(rs.getString("PF_NIC_CHALLAN_NO"));

				if (rs.getString("PF_NIC_CHALLAN_DATE").contains("1900")) {
					JsonObject.put("PFchallanDateDataIndex", "");
					informationList.add("");
				} else {
					JsonObject.put("PFchallanDateDataIndex", MMddyyyy.format(rs.getTimestamp("PF_NIC_CHALLAN_DATE")));
					informationList.add(diffddMMyyyyHHmmss1.format(rs.getTimestamp("PF_NIC_CHALLAN_DATE")));
				}

				JsonObject.put("GIchallanNoDataIndex", rs.getString("GIOPF_NIC_CHALLAN_NO"));
				informationList.add(rs.getString("GIOPF_NIC_CHALLAN_NO"));

				if (rs.getString("GIOPF_NIC_CHALLAN_DATE").contains("1900")) {
					JsonObject.put("GIchallanDateDataIndex", "");
					informationList.add("");
				} else {
					JsonObject.put("GIchallanDateDataIndex",
							MMddyyyy.format(rs.getTimestamp("GIOPF_NIC_CHALLAN_DATE")));
					informationList.add(diffddMMyyyyHHmmss1.format(rs.getTimestamp("GIOPF_NIC_CHALLAN_DATE")));
				}

				JsonObject.put("organizationIdDataIndex", rs.getInt("ORGANIZATION_ID"));
				informationList.add(rs.getString("ORGANIZATION_ID"));

				JsonObject.put("organizationCodeDataIndex", rs.getString("ORGANIZATION_CODE"));
				informationList.add(rs.getString("ORGANIZATION_CODE"));

				JsonObject.put("insertedTimeInd", rs.getString("INSERTED_DATETIME"));
				informationList.add(rs.getString("INSERTED_DATETIME"));

				JsonObject.put("districtNameInd", rs.getString("DISTRICT_NAME"));
				informationList.add(rs.getString("DISTRICT_NAME"));

				JsonObject.put("EWC_ID_Ind", rs.getString("EWC_ID"));

				JsonArray.put(JsonObject);
				reporthelper.setInformationList(informationList);
				reportsList.add(reporthelper);
			}
			finlist.add(JsonArray);
			finalreporthelper.setReportsList(reportsList);
			finalreporthelper.setHeadersList(headersList);
			finlist.add(finalreporthelper);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {

			DBConnection.releaseConnectionToDB(con, pstmt, rs);
			DBConnection.releaseConnectionToDB(null, pstmt, rs1);
		}
		return finlist;
	}

	public String saveChallanAcknowledgementInformation(int custId, int ackuniqueId, String challanNo,
			String nicChallanNo, String nicChallanDate, String bankTranscNumber, String bankName, String branchName,
			String amount, String payDesc, String dateTymOfGen, int systemId, int userId, String challantype,
			String DMFnicChallanNo, String DMFnicChallanDate, String DMFamount, String NMETnicChallanNo,
			String NMETnicChallanDate, String NMETamount, String PFnicChallanNo, String PFnicChallanDate,
			String PFamount, float mWallet, int orgId, String GInicChallanNo, String GInicChallanDate,
			String GIamount) {
		String message = "";
		Connection conAdmin = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int updated = 0;
		String status = "PENDING APPROVAL";
		if (nicChallanNo == "" && nicChallanDate == "" && amount == "" && DMFnicChallanNo == ""
				&& DMFnicChallanDate == "" && DMFamount == "" && NMETnicChallanNo == "" && NMETnicChallanDate == ""
				&& NMETamount == "" && PFnicChallanNo == "" && PFnicChallanDate == "" && PFamount == ""
				&& GInicChallanNo == "" && GInicChallanDate == "") {
			status = "APPROVED";
		}
		if ((nicChallanNo != "" || amount.equals("0")) && (DMFnicChallanNo != "" || DMFamount.equals("0"))
				&& (NMETnicChallanNo != "" || NMETamount.equals("0"))
				&& (PFnicChallanNo != "" || PFamount.equals("0") && (GInicChallanNo != "" || GIamount.equals("0")))) {
			status = "APPROVED";
		}
		try {
			conAdmin = DBConnection.getConnectionToDB("AMS");

			pstmt = conAdmin.prepareStatement(IronMiningStatement.SAVE_CHALLAN_ACKNOWLEDGEMENT_INFORMATION);
			pstmt.setString(1, nicChallanNo);
			pstmt.setString(2, nicChallanDate);
			pstmt.setString(3, bankTranscNumber);
			pstmt.setString(4, bankName);
			pstmt.setString(5, branchName);
			pstmt.setString(6, payDesc);
			pstmt.setString(7, dateTymOfGen);
			pstmt.setInt(8, userId);
			pstmt.setString(9, status);
			pstmt.setString(10, DMFnicChallanNo);
			pstmt.setString(11, DMFnicChallanDate);
			pstmt.setString(12, NMETnicChallanNo);
			pstmt.setString(13, NMETnicChallanDate);
			pstmt.setString(14, PFnicChallanNo);
			pstmt.setString(15, PFnicChallanDate);
			pstmt.setString(16, GInicChallanNo);
			pstmt.setString(17, GInicChallanDate);
			pstmt.setInt(18, systemId);
			pstmt.setInt(19, custId);
			pstmt.setInt(20, ackuniqueId);
			updated = pstmt.executeUpdate();
			if (updated > 0) {
				if (challantype.equalsIgnoreCase("Processing Fee")) {
					pstmt = conAdmin.prepareStatement(IronMiningStatement.UPDATE_PROCESSING_FEE_IN_ORG_MASTER);
					pstmt.setFloat(1, mWallet);
					pstmt.setInt(2, orgId);
					pstmt.setInt(3, systemId);
					pstmt.setInt(4, custId);
					pstmt.executeUpdate();
				}
				message = "Acknowledgement Details saved Successfully";
			}
		} catch (Exception e) {
			e.printStackTrace();
			System.out.println("Inside acknoledgement function" + e.toString());
		} finally {
			DBConnection.releaseConnectionToDB(conAdmin, pstmt, null);
		}
		return message;
	}

	public ArrayList getSummary(int systemId, int CustomerId) {
		JSONArray JsonArray = new JSONArray();
		JSONObject JsonObject = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int aslcount = 0;
		ArrayList assetList = new ArrayList();
		ArrayList<ReportHelper> reportsList = new ArrayList<ReportHelper>();
		ArrayList<String> headersList = new ArrayList<String>();
		ReportHelper finalreporthelper = new ReportHelper();

		SimpleDateFormat diffddMMyyyyHHmmss = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
		headersList.add("Sl No");
		headersList.add("TC Number");
		headersList.add("Month/Year");
		headersList.add("No Of Challans");
		headersList.add("Amount Paid");
		headersList.add("Rate");
		headersList.add("Credit/Debit Amount");
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(IronMiningStatement.GET_MINING_SUMMARY_DETAILS);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, CustomerId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				JsonObject = new JSONObject();
				ArrayList<Object> informationList = new ArrayList<Object>();
				ReportHelper reporthelper = new ReportHelper();
				aslcount++;
				JsonObject.put("slnoIndex", aslcount);
				informationList.add(aslcount);
				JsonObject.put("TcNumberDataIndex", rs.getString("TC_NO"));
				informationList.add(rs.getString("TC_NO"));
				JsonObject.put("MonthYearDataIndex", rs.getString("month") + " / " + rs.getString("year"));
				informationList.add(rs.getString("month") + " / " + rs.getString("year"));
				JsonObject.put("NoOfChallanDataIndex", rs.getString("NO_OF_CHALLAN"));
				informationList.add(rs.getString("NO_OF_CHALLAN"));
				JsonObject.put("AmountPaidDataIndex", rs.getString("AMOUNT_PAID"));
				informationList.add(rs.getString("AMOUNT_PAID"));
				JsonObject.put("CurrentRateDataIndex", rs.getString("RATE"));
				informationList.add(rs.getString("RATE"));
				JsonObject.put("CreditDebitDataIndex", rs.getString("Credit"));
				informationList.add(rs.getDouble("Credit"));

				JsonArray.put(JsonObject);
				reporthelper.setInformationList(informationList);
				reportsList.add(reporthelper);
			}
			assetList.add(JsonArray);
			finalreporthelper.setReportsList(reportsList);
			finalreporthelper.setHeadersList(headersList);
			assetList.add(finalreporthelper);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {

			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return assetList;
	}

	public ArrayList getSummaryDetails(String customerName, int systemId, int CustomerId, String month, String tcNum,
			String language) {
		JSONArray JsonArray = new JSONArray();
		JSONObject JsonObject = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int aslcount = 0;
		int id = 0;
		ArrayList assetList = new ArrayList();
		ArrayList<ReportHelper> reportsList = new ArrayList<ReportHelper>();
		ArrayList<String> headersList = new ArrayList<String>();
		ReportHelper finalreporthelper = new ReportHelper();

		SimpleDateFormat diffddMMyyyyHHmmss = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");

		headersList.add(cf.getLabelFromDB("SLNO", language));
		headersList.add(cf.getLabelFromDB("Challan_Number", language));
		headersList.add(cf.getLabelFromDB("Payment_Acc_Head", language));
		headersList.add(cf.getLabelFromDB("Type", language));
		headersList.add(cf.getLabelFromDB("TC_Number", language));
		headersList.add(cf.getLabelFromDB("Mining_Lease_Name", language));
		headersList.add(cf.getLabelFromDB("Adjustment_Type", language));
		headersList.add(cf.getLabelFromDB("Previous_Challan_Reference", language));
		headersList.add(cf.getLabelFromDB("Previous_Challan_Date_Reference", language));
		headersList.add(cf.getLabelFromDB("Lease_No/Mine_Owner", language));
		headersList.add(cf.getLabelFromDB("Mineral_Type", language));
		headersList.add(cf.getLabelFromDB("Royalty_for_the_month/year", language));
		headersList.add(cf.getLabelFromDB("Grade", language));
		headersList.add(cf.getLabelFromDB("Exact_Grade", language));
		headersList.add(cf.getLabelFromDB("Rate", language));
		headersList.add(cf.getLabelFromDB("Quantity", language));
		headersList.add(cf.getLabelFromDB("Total_Payable", language));
		headersList.add(cf.getLabelFromDB("Payment_Description", language));
		headersList.add(cf.getLabelFromDB("Date_and_Time_of_Generation", language));
		headersList.add(cf.getLabelFromDB("NIC_Challan_No", language));
		headersList.add(cf.getLabelFromDB("NIC_Challan_Date", language));
		headersList.add(cf.getLabelFromDB("Bank_Transaction_Number", language));
		headersList.add(cf.getLabelFromDB("Bank", language));
		headersList.add(cf.getLabelFromDB("Branch", language));
		headersList.add(cf.getLabelFromDB("Amount_Paid", language));
		headersList.add(cf.getLabelFromDB("Payment_Description", language));
		headersList.add(cf.getLabelFromDB("Acknowledgement_Generation_Datetime", language));

		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(IronMiningStatement.GET_TC_NUMBER_SUMMARY);
			pstmt.setString(1, tcNum);
			pstmt.setInt(2, systemId);
			pstmt.setInt(3, CustomerId);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				id = rs.getInt("ID");
			}
			pstmt = con.prepareStatement(IronMiningStatement.GET_SUMMARY_DETAILS);
			pstmt.setInt(1, id);
			pstmt.setString(2, month);
			pstmt.setInt(3, systemId);
			pstmt.setInt(4, CustomerId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				JsonObject = new JSONObject();
				aslcount++;
				JsonObject.put("slnoIndex", aslcount);
				ArrayList<Object> informationList = new ArrayList<Object>();
				ReportHelper reporthelper = new ReportHelper();
				informationList.add(aslcount);
				JsonObject.put("uniqueIdDataIndex", rs.getInt("ID"));
				JsonObject.put("challanNumberDataIndex", rs.getString("CHALLAN_NO"));
				informationList.add(rs.getString("CHALLAN_NO"));
				JsonObject.put("paymentAcHeadDataIndex", rs.getString("PAYMENT_ACC_HEAD"));
				informationList.add(rs.getString("PAYMENT_ACC_HEAD"));
				JsonObject.put("typeDataIndex", rs.getString("TYPE"));
				informationList.add(rs.getString("TYPE"));
				JsonObject.put("TCNODataIndex", rs.getString("TC_NO"));
				informationList.add(rs.getString("TC_NO"));
				JsonObject.put("MineNameDataIndex", rs.getString("MINING_LEASE"));
				informationList.add(rs.getString("MINING_LEASE"));
				JsonObject.put("AdjustmentTypeDataIndex", rs.getString("TYPE1"));
				informationList.add(rs.getString("TYPE1"));
				JsonObject.put("PreviousChallanDataIndex", rs.getString("PREVIOUS_CHALLAN_REF"));
				informationList.add(rs.getString("PREVIOUS_CHALLAN_REF"));

				if (rs.getString("PREVIOUS_CHALLAN_DATE").contains("1900")) {
					JsonObject.put("PreviousDateDataIndex", "");
					informationList.add("");
				} else {
					JsonObject.put("PreviousDateDataIndex",
							diffddMMyyyyHHmmss.format(rs.getTimestamp("PREVIOUS_CHALLAN_DATE")));
					informationList.add(diffddMMyyyyHHmmss.format(rs.getTimestamp("PREVIOUS_CHALLAN_DATE")));
				}

				JsonObject.put("ownerNameDataIndex", rs.getString("LEASE_NAME"));
				informationList.add(rs.getString("LEASE_NAME"));
				JsonObject.put("mineralTypeDataIndex", rs.getString("MINERAL_TYPE"));
				informationList.add(rs.getString("MINERAL_TYPE"));
				if (rs.getString("ROYALITY_FOR_MONTH").contains("1900")) {
					JsonObject.put("royaltyDataIndex", "");
					informationList.add("");
				} else {
					JsonObject.put("royaltyDataIndex",
							diffddMMyyyyHHmmss.format(rs.getTimestamp("ROYALITY_FOR_MONTH")));
					informationList.add(diffddMMyyyyHHmmss.format(rs.getTimestamp("ROYALITY_FOR_MONTH")));
				}

				JsonObject.put("gradeDataIndex", rs.getString("GRADE"));
				informationList.add(rs.getString("GRADE"));

				JsonObject.put("extractGradeDataIndex", rs.getString("EXACT_GRADE"));
				informationList.add(rs.getString("EXACT_GRADE"));

				JsonObject.put("rateDataIndex", rs.getString("RATE"));
				informationList.add(rs.getString("RATE"));

				JsonObject.put("quantityDataIndex", rs.getString("QUANTITY"));
				informationList.add(rs.getString("QUANTITY"));

				JsonObject.put("totalPayableDataIndex", rs.getString("TOTAL"));
				informationList.add(rs.getString("TOTAL"));

				JsonObject.put("paymentDescriptionDataIndex", rs.getString("PAYMENT_DESC"));
				informationList.add(rs.getString("PAYMENT_DESC"));

				JsonObject.put("generationDateDataIndex",
						diffddMMyyyyHHmmss.format(rs.getTimestamp("CHALLAN_DATETIME")));
				informationList.add(diffddMMyyyyHHmmss.format(rs.getTimestamp("CHALLAN_DATETIME")));

				JsonObject.put("challanNoDataIndex", rs.getString("NIC_CHALLAN_NO"));
				informationList.add(rs.getString("NIC_CHALLAN_NO"));
				if (rs.getString("NIC_CHALLAN_DATE").contains("1900")) {
					JsonObject.put("challanDateDataIndex", "");
					informationList.add("");
				} else {
					JsonObject.put("challanDateDataIndex",
							diffddMMyyyyHHmmss.format(rs.getTimestamp("NIC_CHALLAN_DATE")));
					informationList.add(diffddMMyyyyHHmmss.format(rs.getTimestamp("NIC_CHALLAN_DATE")));
				}
				JsonObject.put("transactionDataIndex", rs.getString("BANK_TRANS_NO"));
				informationList.add(rs.getString("BANK_TRANS_NO"));

				JsonObject.put("bankDataIndex", rs.getString("BANK_NAME"));
				informationList.add(rs.getString("BANK_NAME"));

				JsonObject.put("branchDataIndex", rs.getString("BRANCH"));
				informationList.add(rs.getString("BRANCH"));
				JsonObject.put("amountDataIndex", rs.getString("AMOUNT_PAID"));
				informationList.add(rs.getString("AMOUNT_PAID"));

				JsonObject.put("paymentDataIndex", rs.getString("ACK_PAYMENT_DESC"));
				informationList.add(rs.getString("ACK_PAYMENT_DESC"));

				if (rs.getString("ACK_DATETIME").contains("1900")) {
					JsonObject.put("AckGenDataIndex", "");
					informationList.add("");
				} else {
					JsonObject.put("AckGenDataIndex", diffddMMyyyyHHmmss.format(rs.getTimestamp("ACK_DATETIME")));
					informationList.add(diffddMMyyyyHHmmss.format(rs.getTimestamp("ACK_DATETIME")));
				}

				JsonArray.put(JsonObject);
				reporthelper.setInformationList(informationList);
				reportsList.add(reporthelper);
			}
			assetList.add(JsonArray);
			finalreporthelper.setReportsList(reportsList);
			finalreporthelper.setHeadersList(headersList);
			assetList.add(finalreporthelper);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {

			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return assetList;
	}

	public ArrayList<Object> getMonthlyReturnsDashboardDetails(int systemId, int customerId, int userId,
			String userAuthority, String language, String type) {
		ArrayList<ReportHelper> reportsList = new ArrayList<ReportHelper>();
		ArrayList<String> headersList = new ArrayList<String>();
		ReportHelper finalreporthelper = new ReportHelper();
		ArrayList<Object> finlist = new ArrayList<Object>();
		JSONArray JsonArray = new JSONArray();
		JSONObject JsonObject = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int count = 0;
		try {
			headersList.add("SLNO");
			headersList.add("Monthly Form Details ID");
			headersList.add("Return Form Id");
			headersList.add("Month Applied");
			headersList.add("IBM Reg. No.");
			headersList.add("Minerals Name");
			headersList.add("Mining Name");
			headersList.add("TC Number");
			headersList.add("Owner");
			headersList.add("Designation");
			headersList.add("Status");
			headersList.add("Remarks");
			headersList.add("Approved or Rejected By");
			headersList.add("Approved or Rejected Date Time");
			con = DBConnection.getConnectionToDB("AMS");
			if (userAuthority.equalsIgnoreCase("Admin")) {
				if (type.equalsIgnoreCase("totalforms")) {
					pstmt = con.prepareStatement(
							IronMiningStatement.GET_MONTHLY_RETURNS_DASHBOARD_DETAILS.replace("#", " "));
				} else if (type.equalsIgnoreCase("approved")) {
					pstmt = con.prepareStatement(IronMiningStatement.GET_MONTHLY_RETURNS_DASHBOARD_DETAILS.replace("#",
							"and mfd.STATUS='APPROVED'  "));
				} else if (type.equalsIgnoreCase("pending")) {
					pstmt = con.prepareStatement(IronMiningStatement.GET_MONTHLY_RETURNS_DASHBOARD_DETAILS.replace("#",
							"and mfd.STATUS='PENDING' "));
				} else if (type.equalsIgnoreCase("rejected")) {
					pstmt = con.prepareStatement(IronMiningStatement.GET_MONTHLY_RETURNS_DASHBOARD_DETAILS.replace("#",
							"and mfd.STATUS='REJECTED'  "));
				}
			} else if (userAuthority.equalsIgnoreCase("Supervisor")) {
				if (type.equalsIgnoreCase("totalforms")) {
					pstmt = con.prepareStatement(IronMiningStatement.GET_MONTHLY_RETURNS_DASHBOARD_DETAILS.replace("#",
							"and mfd.INSERTED_BY=" + userId));
				} else if (type.equalsIgnoreCase("approved")) {
					pstmt = con.prepareStatement(IronMiningStatement.GET_MONTHLY_RETURNS_DASHBOARD_DETAILS.replace("#",
							"and mfd.STATUS='APPROVED' and mfd.INSERTED_BY=" + userId));
				} else if (type.equalsIgnoreCase("pending")) {
					pstmt = con.prepareStatement(IronMiningStatement.GET_MONTHLY_RETURNS_DASHBOARD_DETAILS.replace("#",
							"and mfd.STATUS='PENDING' and mfd.INSERTED_BY=" + userId));
				} else if (type.equalsIgnoreCase("rejected")) {
					pstmt = con.prepareStatement(IronMiningStatement.GET_MONTHLY_RETURNS_DASHBOARD_DETAILS.replace("#",
							"and mfd.STATUS='REJECTED' and mfd.INSERTED_BY=" + userId));
				}
			}
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, customerId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				count++;
				ReportHelper reporthelper = new ReportHelper();
				JsonObject = new JSONObject();
				ArrayList<Object> informationList = new ArrayList<Object>();

				informationList.add(count);
				JsonObject.put("SNOIndex", count);

				informationList.add(count);
				JsonObject.put("IDIndex", rs.getString("ID"));

				informationList.add(rs.getString("RETURN_FORM_ID"));
				JsonObject.put("returnFormIdIndex", rs.getString("RETURN_FORM_ID"));

				informationList.add(rs.getString("MONTH"));
				JsonObject.put("monthAppliedIndex", rs.getString("MONTH"));

				informationList.add(rs.getString("REGISTRATION_NO"));
				JsonObject.put("RegIndex", rs.getString("REGISTRATION_NO"));

				informationList.add(rs.getString("MINERAL_NAME"));
				JsonObject.put("mineralsIndex", rs.getString("MINERAL_NAME"));

				informationList.add(rs.getString("NAME_OF_MINE"));
				JsonObject.put("minesIndex", rs.getString("NAME_OF_MINE"));

				informationList.add(rs.getString("TC_NO"));
				JsonObject.put("tcNoIndex", rs.getString("TC_NO"));

				informationList.add(rs.getString("CONTACT_PERSON"));
				JsonObject.put("ownerIndex", rs.getString("CONTACT_PERSON"));

				informationList.add(rs.getString("DESIGNATION"));
				JsonObject.put("desgnationIndex", rs.getString("DESIGNATION"));

				informationList.add(rs.getString("STATUS"));
				JsonObject.put("statusIndex", rs.getString("STATUS"));

				informationList.add(rs.getString("REMAKRS"));
				JsonObject.put("remarksIndex", rs.getString("REMAKRS"));

				informationList.add(rs.getString("APPROVED_REJECTED_BY"));
				JsonObject.put("approvedRejectedByIndex", rs.getString("APPROVED_REJECTED_BY"));

				String approvedRejectedBy = "";
				if (rs.getString("APPROVED_REJECTED_DATETIME").contains("1900")) {
					approvedRejectedBy = "";
				} else {
					approvedRejectedBy = rs.getString("APPROVED_REJECTED_DATETIME");
				}
				informationList.add(approvedRejectedBy);
				JsonObject.put("approvedRejectedDTIndex", approvedRejectedBy);

				JsonArray.put(JsonObject);
				reporthelper.setInformationList(informationList);
				reportsList.add(reporthelper);
			}
			finalreporthelper.setReportsList(reportsList);
			finalreporthelper.setHeadersList(headersList);
			finlist.add(JsonArray);
			finlist.add(finalreporthelper);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return finlist;
	}

	public JSONArray getDashboardCount(String userAuthority, int systemId, int customerId, int userId) {
		JSONArray JsonArray = null;
		JSONObject JsonObject = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int approvedCount = 0;
		int pendingCount = 0;
		int rejectedCount = 0;
		int otherCount = 0;
		try {
			JsonArray = new JSONArray();
			con = DBConnection.getConnectionToDB("AMS");
			if (userAuthority.equalsIgnoreCase("Admin")) {
				pstmt = con.prepareStatement(IronMiningStatement.GET_MONTHLY_RETURNS_DASHBOARD_COUNT.replace("#", " "));
			} else if (userAuthority.equalsIgnoreCase("Supervisor")) {
				pstmt = con.prepareStatement(IronMiningStatement.GET_MONTHLY_RETURNS_DASHBOARD_COUNT.replace("#",
						"and INSERTED_BY=" + userId));
			}
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, customerId);
			rs = pstmt.executeQuery();
			while (rs.next()) {

				if (rs.getString("STATUS").equals("APPROVED")) {
					approvedCount = rs.getInt("COUNT");
				} else if (rs.getString("STATUS").equals("PENDING")) {
					pendingCount = rs.getInt("COUNT");
				} else if (rs.getString("STATUS").equals("REJECTED")) {
					rejectedCount = rs.getInt("COUNT");
				} else {
					otherCount = rs.getInt("COUNT");
				}
			}
			JsonObject = new JSONObject();
			JsonObject.put("approvedcountIndex", approvedCount);
			JsonObject.put("pendingactioncountIndex", pendingCount);
			JsonObject.put("rejectedcountIndex", rejectedCount);
			JsonObject.put("totalformscountIndex", approvedCount + pendingCount + rejectedCount + otherCount);
			JsonArray.put(JsonObject);

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return JsonArray;
	}

	public String updateRemarks(int id, String remarks, String buttonValue, int userId) {
		Connection con = null;
		PreparedStatement pstmt = null;
		String message = "";
		String status = "";
		if (buttonValue.equals("Approve")) {
			status = "APPROVED";
		}
		if (buttonValue.equals("Reject")) {
			status = "REJECTED";
		}
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(IronMiningStatement.UPDATE_REMARK);
			pstmt.setString(1, status);
			pstmt.setString(2, remarks);
			pstmt.setInt(3, userId);
			pstmt.setInt(4, id);
			int updated = pstmt.executeUpdate();
			if (updated > 0) {
				message = "Updated Successfully";
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, null);
		}
		return message;
	}

	public JSONArray getCategory(String mineral) {
		JSONArray JsonArray = null;
		JSONObject JsonObject = null;
		int count = 0;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		try {
			JsonArray = new JSONArray();
			con = DBConnection.getConnectionToDB("AMS");
			List<String> listOreProduction = new ArrayList<String>();

			listOreProduction.add("Open Cast Workings");
			if (mineral.equalsIgnoreCase("Manganese")) {
				listOreProduction.add("Underground Workings");
			} else if (mineral.equalsIgnoreCase("Bauxite/Laterite")) {
				listOreProduction.add("From Underground Workings");
			}
			listOreProduction.add("Dump Workings");
			for (int i = 0; i < listOreProduction.size(); i++) {
				count++;
				JsonObject = new JSONObject();
				JsonObject.put("categoryName", listOreProduction.get(i));
				JsonArray.put(JsonObject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return JsonArray;
	}

	public ArrayList<Object> getProductionOfROMReport(String mineralName, String category, String month, int systemId,
			int customerId, String year) {
		ArrayList<ReportHelper> reportsList = new ArrayList<ReportHelper>();
		ArrayList<String> headersList = new ArrayList<String>();
		ReportHelper finalreporthelper = new ReportHelper();
		ArrayList<Object> finlist = new ArrayList<Object>();
		JSONArray JsonArray = new JSONArray();
		JSONObject JsonObject = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int count = 0;
		try {
			headersList.add("SLNO");
			headersList.add("Mine Code");
			headersList.add("Tc No");
			headersList.add("Opening Stock");
			headersList.add("Production");
			headersList.add("Closing Stock");
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(IronMiningStatement.GET_PRODUCTION_OF_ROM_REPORT);
			pstmt.setString(1, month);
			pstmt.setString(2, mineralName);
			pstmt.setString(3, category);
			pstmt.setInt(4, systemId);
			pstmt.setInt(5, customerId);
			pstmt.setString(6, year);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				count++;
				ReportHelper reporthelper = new ReportHelper();
				JsonObject = new JSONObject();
				ArrayList<Object> informationList = new ArrayList<Object>();

				informationList.add(count);
				JsonObject.put("slnoIndex", count);

				informationList.add(rs.getString("MINE_CODE"));
				JsonObject.put("mineCodeDataIndex", rs.getString("MINE_CODE"));

				informationList.add(rs.getString("TC_NO"));
				JsonObject.put("tcNoDataIndex", rs.getString("TC_NO"));

				informationList.add(rs.getString("OPENING_STOCK"));
				JsonObject.put("openingStockDataIndex", rs.getString("OPENING_STOCK"));

				informationList.add(rs.getString("PRODUCTION"));
				JsonObject.put("productionDataIndex", rs.getString("PRODUCTION"));

				informationList.add(rs.getString("CLOSING_STOCK"));
				JsonObject.put("closingStockDataIndex", rs.getString("CLOSING_STOCK"));

				JsonArray.put(JsonObject);
				reporthelper.setInformationList(informationList);
				reportsList.add(reporthelper);
			}
			finalreporthelper.setReportsList(reportsList);
			finalreporthelper.setHeadersList(headersList);
			finlist.add(JsonArray);
			finlist.add(finalreporthelper);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return finlist;
	}

	/********************************************************Modify Monthly Return Forms*************************************************************************************************/
	public JSONArray getDetailsAndLocationOfMine(int monthlyId) {
		JSONArray JsonArray = null;
		JSONObject JsonObject = null;
		SimpleDateFormat yyyymmdd = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		SimpleDateFormat ddmmyyyy = new SimpleDateFormat("MM-dd-yyyy");
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			JsonArray = new JSONArray();
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(IronMiningStatement.GET_DETAILS_AND_LOCATION_OF_MINE);
			pstmt.setInt(1, monthlyId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				JsonObject = new JSONObject();
				JsonObject.put("dateIndex", ddmmyyyy.format(yyyymmdd.parse(rs.getString("DATE"))));
				JsonObject.put("regionIndex", rs.getString("REGION"));
				JsonObject.put("registrationIndex", rs.getString("REGISTRATION_NO"));
				JsonObject.put("mineralNameIndex", rs.getString("MINERAL_NAME"));
				JsonObject.put("mineCodeIndex", rs.getString("MINE_CODE"));
				JsonObject.put("mineIdIndex", rs.getString("MINE_ID"));
				JsonObject.put("TCNOIndex", rs.getString("TC_NO"));
				JsonObject.put("mineNameIndex", rs.getString("NAME_OF_MINE"));
				JsonObject.put("villageIndex", rs.getString("VILLAGE"));
				JsonObject.put("postOfficeIndex", rs.getString("POST_OFFICE"));
				JsonObject.put("talukaNameIndex", rs.getString("TALUKA_NAME"));
				JsonObject.put("districtNameIndex", rs.getString("DISTRICT_NAME"));
				JsonObject.put("stateNameIndex", rs.getString("STATE_NAME"));
				JsonObject.put("PINIndex", rs.getString("PIN"));
				JsonObject.put("FAXNOIndex", rs.getString("FAX_NO"));
				JsonObject.put("phoneNoIndex", rs.getString("PHONE_NO"));
				JsonObject.put("emailIdIndex", rs.getString("EMAIL_ID"));
				JsonObject.put("otherMineralsNameIndex", rs.getString("OTHER_MINERAL_NAME"));
				JsonObject.put("mineOwnerIdIndex", rs.getString("MINE_OWNER_ID"));
				JsonObject.put("rentPaidIndex", rs.getString("RENT_PAID"));
				JsonObject.put("royaltyPaidIndex", rs.getString("ROYALTY_PAID"));
				JsonObject.put("deadRentPaidIndex", rs.getString("DEAD_RENT_PAID"));
				JsonObject.put("mineWorkDaysIndex", rs.getString("MINE_WORK_DAYS"));
				JsonObject.put("mineNonWorkDaysIndex", rs.getString("MINE_NON_WORK_DAYS"));
				JsonObject.put("reasonForNotWorkedIndex", rs.getString("REASON_FOR_NOT_WORK"));
				JsonObject.put("technicalStaffIndex", rs.getString("TECHNICAL_STAFF"));
				JsonObject.put("totalSalariesIndex", rs.getString("TOTAL_SALARIES"));
				JsonObject.put("otherStoppedReasonIndex", rs.getString("OTHER_REASON_NOT_WORK"));
				JsonArray.put(JsonObject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return JsonArray;
	}

	public JSONArray getDailyEmploymentDetails(int autoGeneratedId) {
		JSONArray JsonArray = null;
		JSONObject JsonObject = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			JsonArray = new JSONArray();
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(IronMiningStatement.GET_DAILY_EMPLOYMENT_DETAILS);
			pstmt.setInt(1, autoGeneratedId);
			pstmt.setInt(2, autoGeneratedId);
			rs = pstmt.executeQuery();

			HashMap<String, JSONObject> finlist = new HashMap<String, JSONObject>();
			JsonObject = getDailyEmploymentJSONObject("Below Ground");
			finlist.put("Below Ground", JsonObject);

			JsonObject = getDailyEmploymentJSONObject("Opencast");
			finlist.put("Opencast", JsonObject);

			JsonObject = getDailyEmploymentJSONObject("Above Ground");
			finlist.put("Above Ground", JsonObject);

			JsonObject = getDailyEmploymentJSONObject("Total");
			finlist.put("Total", JsonObject);

			while (rs.next()) {
				JsonObject = new JSONObject();
				JsonObject.put("SLNOIndex", finlist.get(rs.getString("WORK_PLACE")).getString("SLNOIndex"));
				JsonObject.put("autoIncIdIndex", rs.getString("ID"));
				JsonObject.put("workPlaceIndex", rs.getString("WORK_PLACE"));
				JsonObject.put("maleLabourIndex", rs.getString("DIRECT_MALE"));
				JsonObject.put("femaleLabourIndex", rs.getString("DIRECT_FEMALE"));
				JsonObject.put("contractMaleLabourIndex", rs.getString("CONTRACT_MALE"));
				JsonObject.put("contractFemaleLabourIndex", rs.getString("CONTRACT_FEMALE"));
				JsonObject.put("directWagesLabourIndex", rs.getString("WAGES_DIRECT"));
				JsonObject.put("contractWagesLabourIndex", rs.getString("WAGES_CONTRACT"));

				finlist.remove(rs.getString("WORK_PLACE"));
				finlist.put(rs.getString("WORK_PLACE"), JsonObject);
			}
			JsonArray.put(finlist.get("Below Ground"));
			JsonArray.put(finlist.get("Opencast"));
			JsonArray.put(finlist.get("Above Ground"));
			JsonArray.put(finlist.get("Total"));
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return JsonArray;
	}

	public JSONObject getDailyEmploymentJSONObject(String workPlace) {

		JSONObject JsonObject = new JSONObject();
		try {
			JsonObject.put("SLNOIndex", ++counts);
			JsonObject.put("autoIncIdIndex", "");
			JsonObject.put("maleLabourIndex", "");
			JsonObject.put("femaleLabourIndex", "");
			JsonObject.put("contractMaleLabourIndex", "");
			JsonObject.put("contractFemaleLabourIndex", "");
			JsonObject.put("directWagesLabourIndex", "");
			JsonObject.put("contractWagesLabourIndex", "");
			JsonObject.put("workPlaceIndex", workPlace);
		} catch (Exception e) {
			e.printStackTrace();
		}

		return JsonObject;
	}

	public JSONArray getNameAddressOfLesseeOwner(int systemId, int custId, int autoGeneratedId) {
		JSONArray JsonArray = null;
		JSONObject JsonObject = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			JsonArray = new JSONArray();
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(IronMiningStatement.GET_NAME_ADDRESS_OF_LESSEE_OWNER);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, custId);
			pstmt.setInt(3, autoGeneratedId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				JsonObject = new JSONObject();
				JsonObject.put("mineOwnerIdIndex", rs.getString("ID"));
				JsonObject.put("contactPersonIndex", rs.getString("CONTACT_PERSON"));
				JsonObject.put("villageIndex", rs.getString("VILLAGE"));
				JsonObject.put("postIndex", rs.getString("POST_OFFICE"));
				JsonObject.put("talukaIndex", rs.getString("TALUKA_NAME"));
				JsonObject.put("districtIndex", rs.getString("DISTRICT_NAME"));
				JsonObject.put("stateIndex", rs.getString("STATE_NAME"));
				JsonObject.put("pinIndex", rs.getString("PIN"));
				JsonObject.put("faxIndex", rs.getString("FAX_NO"));
				JsonObject.put("phoneIndex", rs.getString("PHONE_NO"));
				JsonObject.put("emailIndex", rs.getString("EMAIL_ID"));
				JsonArray.put(JsonObject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return JsonArray;
	}

	public JSONArray getGradeWiseProductionDespatchLists(String mineral, String type, int autoGeneraedKey) {
		JSONArray JsonArray = null;
		JSONObject JsonObject = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			JsonArray = new JSONArray();
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(IronMiningStatement.GET_GRADE_WISE_PRODUCTION_LISTS);
			pstmt.setInt(1, autoGeneraedKey);
			rs = pstmt.executeQuery();
			HashMap<String, JSONObject> finlist = new HashMap<String, JSONObject>();
			if (mineral.equalsIgnoreCase("Iron Ore")) {
				JsonObject = getGradeWiseJSONObject("Fe:Lumps:Below 55%");
				finlist.put("Fe:Lumps:Below 55%", JsonObject);
				JsonObject = getGradeWiseJSONObject("Fe:Lumps:55% to Below 58%");
				finlist.put("Fe:Lumps:55% to Below 58%", JsonObject);
				JsonObject = getGradeWiseJSONObject("Fe:Lumps:58% to Below 60%");
				finlist.put("Fe:Lumps:58% to Below 60%", JsonObject);
				JsonObject = getGradeWiseJSONObject("Fe:Lumps:60% to Below 62%");
				finlist.put("Fe:Lumps:60% to Below 62%", JsonObject);
				JsonObject = getGradeWiseJSONObject("Fe:Lumps:62% to Below 65%");
				finlist.put("Fe:Lumps:62% to Below 65%", JsonObject);
				JsonObject = getGradeWiseJSONObject("Fe:Lumps:65% and above");
				finlist.put("Fe:Lumps:65% and above", JsonObject);
				JsonObject = getGradeWiseJSONObject("Fe:Fines:Below 55%");
				finlist.put("Fe:Fines:Below 55%", JsonObject);
				JsonObject = getGradeWiseJSONObject("Fe:Fines:55% to Below 58%");
				finlist.put("Fe:Fines:55% to Below 58%", JsonObject);
				JsonObject = getGradeWiseJSONObject("Fe:Fines:58% to Below 60%");
				finlist.put("Fe:Fines:58% to Below 60%", JsonObject);
				JsonObject = getGradeWiseJSONObject("Fe:Fines:60% to Below 62%");
				finlist.put("Fe:Fines:60% to Below 62%", JsonObject);
				JsonObject = getGradeWiseJSONObject("Fe:Fines:62% to Below 65%");
				finlist.put("Fe:Fines:62% to Below 65%", JsonObject);
				JsonObject = getGradeWiseJSONObject("Fe:Fines:65% and above");
				finlist.put("Fe:Fines:65% and above", JsonObject);
				JsonObject = getGradeWiseJSONObject("Concentrates");
				finlist.put("Concentrates", JsonObject);
			} else if (mineral.equalsIgnoreCase("Manganese")) {
				JsonObject = getGradeWiseJSONObject("Mn:Below 25%");
				finlist.put("Mn:Below 25%", JsonObject);
				JsonObject = getGradeWiseJSONObject("Mn:25% to Below 35%");
				finlist.put("Mn:25% to Below 35%", JsonObject);
				JsonObject = getGradeWiseJSONObject("Mn:35% to Below 46%");
				finlist.put("Mn:35% to Below 46%", JsonObject);
				JsonObject = getGradeWiseJSONObject("Mn:46% and above");
				finlist.put("Mn:46% and above", JsonObject);
				JsonObject = getGradeWiseJSONObject("Mn:Dioxide ore");
				finlist.put("Mn:Dioxide ore", JsonObject);
				JsonObject = getGradeWiseJSONObject("Mn:Concentrates");
				finlist.put("Mn:Concentrates", JsonObject);
			} else if (mineral.equalsIgnoreCase("Bauxite/Laterite")) {
				JsonObject = getGradeWiseJSONObject("Al:Below 40%");
				finlist.put("Al:Below 40%", JsonObject);
				JsonObject = getGradeWiseJSONObject("Al:40% to Below 45%");
				finlist.put("Al:40% to Below 45%", JsonObject);
				JsonObject = getGradeWiseJSONObject("Al:45% to Below 50%");
				finlist.put("Al:45% to Below 50%", JsonObject);
				JsonObject = getGradeWiseJSONObject("Al:50% to Below 55%");
				finlist.put("Al:50% to Below 55%", JsonObject);
				JsonObject = getGradeWiseJSONObject("Al:55% to Below 60%");
				finlist.put("Al:55% to Below 60%", JsonObject);
				JsonObject = getGradeWiseJSONObject("Al:60% and above");
				finlist.put("Al:60% and above", JsonObject);
				JsonObject = getGradeWiseJSONObject("Other than Al:Cement");
				finlist.put("Other than Al:Cement", JsonObject);
				JsonObject = getGradeWiseJSONObject("Other than Al:Abrasive");
				finlist.put("Other than Al:Abrasive", JsonObject);
				JsonObject = getGradeWiseJSONObject("Other than Al:Refactory");
				finlist.put("Other than Al:Refactory", JsonObject);
				JsonObject = getGradeWiseJSONObject("Other than Al:Chemical");
				finlist.put("Other than Al:Chemical", JsonObject);
			}
			if (type.equals("Dispatch")) {
				JsonObject = getGradeWiseJSONObject("ROM");
				finlist.put("ROM", JsonObject);
				JsonObject = getGradeWiseJSONObject("Tailing");
				finlist.put("Tailing", JsonObject);
			}
			while (rs.next()) {
				JsonObject = new JSONObject();
				JsonObject.put("SLNOIndex", finlist.get(rs.getString("GRADE")).getString("SLNOIndex"));
				JsonObject.put("autoIncIdIndex", rs.getString("ID"));
				JsonObject.put("gradesIndex", rs.getString("GRADE"));
				JsonObject.put("openingStockIndex", rs.getString("OPENING_STOCK"));
				JsonObject.put("productIndex", rs.getString("PRODUCTION"));
				JsonObject.put("despatchIndex", rs.getString("DESPATCHES"));
				JsonObject.put("closeStockIndex", rs.getString("CLOSING_STOCK"));
				JsonObject.put("PMVIndex", rs.getString("EX_MINE_PRICE"));

				finlist.remove(rs.getString("GRADE"));
				finlist.put(rs.getString("GRADE"), JsonObject);
			}
			if (mineral.equalsIgnoreCase("Iron Ore")) {
				JsonArray.put(finlist.get("Fe:Lumps:Below 55%"));
				JsonArray.put(finlist.get("Fe:Lumps:55% to Below 58%"));
				JsonArray.put(finlist.get("Fe:Lumps:58% to Below 60%"));
				JsonArray.put(finlist.get("Fe:Lumps:60% to Below 62%"));
				JsonArray.put(finlist.get("Fe:Lumps:62% to Below 65%"));
				JsonArray.put(finlist.get("Fe:Lumps:65% and above"));
				JsonArray.put(finlist.get("Fe:Fines:Below 55%"));
				JsonArray.put(finlist.get("Fe:Fines:55% to Below 58%"));
				JsonArray.put(finlist.get("Fe:Fines:58% to Below 60%"));
				JsonArray.put(finlist.get("Fe:Fines:60% to Below 62%"));
				JsonArray.put(finlist.get("Fe:Fines:62% to Below 65%"));
				JsonArray.put(finlist.get("Fe:Fines:65% and above"));
				JsonArray.put(finlist.get("Concentrates"));
			} else if (mineral.equalsIgnoreCase("Manganese")) {
				JsonArray.put(finlist.get("Mn:Below 25%"));
				JsonArray.put(finlist.get("Mn:25% to Below 35%"));
				JsonArray.put(finlist.get("Mn:35% to Below 46%"));
				JsonArray.put(finlist.get("Mn:46% and above"));
				JsonArray.put(finlist.get("Mn:Dioxide ore"));
				JsonArray.put(finlist.get("Mn:Concentrates"));
			} else if (mineral.equalsIgnoreCase("Bauxite/Laterite")) {
				JsonArray.put(finlist.get("Al:Below 40%"));
				JsonArray.put(finlist.get("Al:40% to Below 45%"));
				JsonArray.put(finlist.get("Al:45% to Below 50%"));
				JsonArray.put(finlist.get("Al:50% to Below 55%"));
				JsonArray.put(finlist.get("Al:55% to Below 60%"));
				JsonArray.put(finlist.get("Al:60% and above"));
				JsonArray.put(finlist.get("Other than Al:Cement"));
				JsonArray.put(finlist.get("Other than Al:Abrasive"));
				JsonArray.put(finlist.get("Other than Al:Refactory"));
				JsonArray.put(finlist.get("Other than Al:Chemical"));
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return JsonArray;
	}

	public JSONObject getGradeWiseJSONObject(String grade) {
		JSONObject JsonObject = new JSONObject();
		try {
			JsonObject.put("SLNOIndex", ++counts);
			JsonObject.put("autoIncIdIndex", "");
			JsonObject.put("openingStockIndex", "");
			JsonObject.put("productIndex", "");
			JsonObject.put("despatchIndex", "");
			JsonObject.put("closeStockIndex", "");
			JsonObject.put("PMVIndex", "");
			JsonObject.put("gradesIndex", grade);

		} catch (Exception e) {
			e.printStackTrace();
		}
		return JsonObject;
	}

	public JSONArray getOreProductionLists(String mineral, int autoGeneraedKey, int custId, int systemId) {
		JSONArray JsonArray = null;
		JSONObject JsonObject = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		PreparedStatement pstmt1 = null;
		ResultSet rs1 = null;
		int minecode = 0;
		String mineralName = "";
		String month = "";
		boolean check = false;
		String year = "";
		int count = 0;
		HashMap<String, JSONObject> finlist = new HashMap<String, JSONObject>();
		try {
			JsonArray = new JSONArray();
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(IronMiningStatement.GET_DETAILS_FROM_ID);
			pstmt.setInt(1, autoGeneraedKey);
			pstmt.setInt(2, autoGeneraedKey);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				minecode = rs.getInt("MINE_CODE");
				mineralName = rs.getString("MINERAL_NAME");
				month = rs.getString("MONTH");
				year = rs.getString("YEAR");
			}
			pstmt1 = con.prepareStatement(IronMiningStatement.GET_OPENING_STOCK_DETAILS);
			pstmt1.setInt(1, systemId);
			pstmt1.setInt(2, custId);
			pstmt1.setString(3, month);
			pstmt1.setString(4, mineralName);
			pstmt1.setInt(5, minecode);
			pstmt1.setString(6, year);
			rs1 = pstmt1.executeQuery();
			while (rs1.next()) {
				check = true;
				JsonObject = new JSONObject();
				count++;
				JsonObject.put("SLNOIndex", count);
				JsonObject.put("categoryIndex", rs1.getString("CATEGORY"));
				JsonObject.put("openStockIndex", rs1.getString("CLOSING_STOCK"));
				JsonArray.put(JsonObject);
			}
			if (!check) {
				pstmt = con.prepareStatement(IronMiningStatement.GET_ORE_PRODUCTION_LISTS);
				pstmt.setInt(1, autoGeneraedKey);
				rs = pstmt.executeQuery();

				if (mineral.equalsIgnoreCase("Iron Ore")) {
					JsonObject = getOreProductionJSONObject("Open Cast Workings");
					finlist.put("Open Cast Workings", JsonObject);

					JsonObject = getOreProductionJSONObject("Dump Workings");
					finlist.put("Dump Workings", JsonObject);
				} else if (mineral.equalsIgnoreCase("Manganese")) {
					JsonObject = getOreProductionJSONObject("Open Cast Workings");
					finlist.put("Open Cast Workings", JsonObject);

					JsonObject = getOreProductionJSONObject("Underground Workings");
					finlist.put("Underground Workings", JsonObject);

					JsonObject = getOreProductionJSONObject("Dump Workings");
					finlist.put("Dump Workings", JsonObject);
				} else if (mineral.equalsIgnoreCase("Bauxite/Laterite")) {
					JsonObject = getOreProductionJSONObject("Open Cast Workings");
					finlist.put("Open Cast Workings", JsonObject);

					JsonObject = getOreProductionJSONObject("From Underground Workings");
					finlist.put("From Underground Workings", JsonObject);

					JsonObject = getOreProductionJSONObject("Dump Workings");
					finlist.put("Dump Workings", JsonObject);
				}
				while (rs.next()) {
					JsonObject = new JSONObject();
					JsonObject.put("SLNOIndex", finlist.get(rs.getString("CATEGORY")).getString("SLNOIndex"));
					JsonObject.put("autoIncIdIndex", rs.getString("ID"));
					JsonObject.put("categoryIndex", rs.getString("CATEGORY"));
					JsonObject.put("openStockIndex", rs.getString("OPENING_STOCK"));
					JsonObject.put("productionIndex", rs.getString("PRODUCTION"));
					JsonObject.put("closingStockIndex", rs.getString("CLOSING_STOCK"));

					finlist.remove(rs.getString("CATEGORY"));
					finlist.put(rs.getString("CATEGORY"), JsonObject);
				}
				if (mineral.equalsIgnoreCase("Iron Ore")) {
					JsonArray.put(finlist.get("Open Cast Workings"));
					JsonArray.put(finlist.get("Dump Workings"));
				} else if (mineral.equalsIgnoreCase("Manganese")) {
					JsonArray.put(finlist.get("Open Cast Workings"));
					JsonArray.put(finlist.get("Underground Workings"));
					JsonArray.put(finlist.get("Dump Workings"));
				} else if (mineral.equalsIgnoreCase("Bauxite/Laterite")) {
					JsonArray.put(finlist.get("Open Cast Workings"));
					JsonArray.put(finlist.get("From Underground Workings"));
					JsonArray.put(finlist.get("Dump Workings"));
				}
			}

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
			DBConnection.releaseConnectionToDB(null, pstmt1, rs1);

		}
		return JsonArray;
	}

	public JSONObject getOreProductionJSONObject(String category) {
		JSONObject JsonObject = new JSONObject();
		try {
			JsonObject.put("SLNOIndex", ++counts);
			JsonObject.put("autoIncIdIndex", "");
			JsonObject.put("openStockIndex", "");
			JsonObject.put("productionIndex", "");
			JsonObject.put("closingStockIndex", "");
			JsonObject.put("categoryIndex", category);

		} catch (Exception e) {
			e.printStackTrace();
		}
		return JsonObject;
	}

	public JSONArray getDetailsOfDeductionsLists(int autoGeneraedKey) {
		JSONArray JsonArray = null;
		JSONObject JsonObject = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			JsonArray = new JSONArray();
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(IronMiningStatement.GET_DETAILS_OF_DEDUCTIONS_LISTS);
			pstmt.setInt(1, autoGeneraedKey);
			pstmt.setInt(2, autoGeneraedKey);
			rs = pstmt.executeQuery();
			HashMap<String, JSONObject> finlist = new HashMap<String, JSONObject>();
			JsonObject = getDetailsOfDeductionsJSONObject(
					"(a) Cost of Transportation (indicate Loading station and Distance from mines in remarks)");
			finlist.put("(a) Cost of Transportation (indicate Loading station and Distance from mines in remarks)",
					JsonObject);

			JsonObject = getDetailsOfDeductionsJSONObject("(b) Loading and unloading Charges");
			finlist.put("(b) Loading and unloading Charges", JsonObject);

			JsonObject = getDetailsOfDeductionsJSONObject(
					"(c) Railway freight, if applicable (indicate destination and distance)");
			finlist.put("(c) Railway freight, if applicable (indicate destination and distance)", JsonObject);

			JsonObject = getDetailsOfDeductionsJSONObject(
					"(d) Port Handling charges/export duty (indicate name of port)");
			finlist.put("(d) Port Handling charges/export duty (indicate name of port)", JsonObject);

			JsonObject = getDetailsOfDeductionsJSONObject("(e) Charges for Sampling and Analysis");
			finlist.put("(e) Charges for Sampling and Analysis", JsonObject);

			JsonObject = getDetailsOfDeductionsJSONObject("(f) Rent for the plot at stocking yard");
			finlist.put("(f) Rent for the plot at stocking yard", JsonObject);

			JsonObject = getDetailsOfDeductionsJSONObject("(g) Other charges (Specify Clearly)");
			finlist.put("(g) Other charges (Specify Clearly)", JsonObject);

			JsonObject = getDetailsOfDeductionsJSONObject("Total (a) to (g)");
			finlist.put("Total (a) to (g)", JsonObject);

			while (rs.next()) {
				JsonObject = new JSONObject();
				JsonObject.put("SLNOIndex", finlist.get(rs.getString("DEDUCTION_CLAIMED")).getString("SLNOIndex"));
				JsonObject.put("autoIncIdIndex", rs.getString("ID"));
				JsonObject.put("DeductionClaimedIndex", rs.getString("DEDUCTION_CLAIMED"));
				JsonObject.put("matricsTonesIndex", rs.getString("UNIT_RS_PER_TONE"));
				JsonObject.put("remarksIndex", rs.getString("REMARKS"));

				finlist.remove(rs.getString("DEDUCTION_CLAIMED"));
				finlist.put(rs.getString("DEDUCTION_CLAIMED"), JsonObject);
			}
			JsonArray.put(finlist
					.get("(a) Cost of Transportation (indicate Loading station and Distance from mines in remarks)"));
			JsonArray.put(finlist.get("(b) Loading and unloading Charges"));
			JsonArray.put(finlist.get("(c) Railway freight, if applicable (indicate destination and distance)"));
			JsonArray.put(finlist.get("(d) Port Handling charges/export duty (indicate name of port)"));
			JsonArray.put(finlist.get("(e) Charges for Sampling and Analysis"));
			JsonArray.put(finlist.get("(f) Rent for the plot at stocking yard"));
			JsonArray.put(finlist.get("(g) Other charges (Specify Clearly)"));
			JsonArray.put(finlist.get("Total (a) to (g)"));
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return JsonArray;
	}

	public JSONObject getDetailsOfDeductionsJSONObject(String deductionClaimed) {
		JSONObject JsonObject = new JSONObject();
		try {
			JsonObject.put("SLNOIndex", ++counts);
			JsonObject.put("autoIncIdIndex", "");
			JsonObject.put("matricsTonesIndex", "");
			JsonObject.put("remarksIndex", "");
			JsonObject.put("DeductionClaimedIndex", deductionClaimed);

		} catch (Exception e) {
			e.printStackTrace();
		}
		return JsonObject;
	}

	public JSONArray getTypesOfOreStore(int autoGeneratedId) {
		JSONArray JsonArray = null;
		JSONObject JsonObject = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			JsonArray = new JSONArray();
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(IronMiningStatement.GET_TYPE_OF_ORE);
			pstmt.setInt(1, autoGeneratedId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				JsonObject = new JSONObject();
				JsonObject.put("typesOfOreIndex", rs.getString("TYPE_OF_ORE"));
				JsonArray.put(JsonObject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return JsonArray;
	}

	public JSONArray getSalesDespatchList(int autoGeneratedId) {
		JSONArray JsonArray = null;
		JSONObject JsonObject = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int count = 0;
		try {
			JsonArray = new JSONArray();
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(IronMiningStatement.GET_SALES_DESPATCH_DETAILS);
			pstmt.setInt(1, autoGeneratedId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				JsonObject = new JSONObject();
				count++;
				JsonObject.put("SLNOIndex", count);
				JsonObject.put("autoIncIdIndex", rs.getString("ID"));
				JsonObject.put("gradeIndex", rs.getString("GRADE"));
				JsonObject.put("despatchIndex", rs.getString("DESPATCH_NAME"));
				JsonObject.put("domConsumptConsigneeNameIndex", rs.getString("DOMESTIC_CONSIGNEE"));
				JsonObject.put("domConsumptQuantityIndex", rs.getString("DOMESTIC_QUANTITY"));
				JsonObject.put("domConsumptSalesValueIndex", rs.getString("DOMESTICS_SALE_VALUE"));
				JsonObject.put("exportCountryIndex", rs.getString("EXPORT_COUNTRY"));
				JsonObject.put("exportQualityIndex", rs.getString("QUANTITY"));
				JsonObject.put("exportFOBIndex", rs.getString("EXPORT_FOB_VALUE"));
				JsonArray.put(JsonObject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return JsonArray;
	}

	public JSONArray getChallanDetailsForMonthlyReturns(int autoGeneratedId) {
		JSONArray JsonArray = null;
		JSONObject JsonObject = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int count = 0;
		SimpleDateFormat yyyymmdd = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		try {
			JsonArray = new JSONArray();
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(IronMiningStatement.GET_MONTHLY_CHALLAN_DETAILS);
			pstmt.setInt(1, autoGeneratedId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				JsonObject = new JSONObject();
				count++;
				JsonObject.put("SLNOIndex", count);
				JsonObject.put("autoIncIdIndex", rs.getString("ID"));
				JsonObject.put("challanNumberIndex", rs.getString("CHALLAN_NO"));
				if (rs.getString("CHALLAN_DATE").equals("") || rs.getString("CHALLAN_DATE").contains("1900")) {
					JsonObject.put("challanDateIndex", "");
				} else {
					JsonObject.put("challanDateIndex", yyyymmdd.format(rs.getTimestamp("CHALLAN_DATE")));
				}
				JsonObject.put("quantityIndex", rs.getString("QUANTITY"));
				JsonObject.put("gradeIndex", rs.getString("GRADE"));
				JsonObject.put("typeIndex", rs.getString("TYPE"));
				JsonObject.put("royalityRateIndex", rs.getString("PROVISIONAL_ROYALITY_RATE"));
				JsonObject.put("valuePaidIndex", rs.getString("VALUE_PAID"));

				JsonArray.put(JsonObject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return JsonArray;
	}

	public JSONArray getFormThreeDetails(int autoGeneratedId) {
		JSONArray JsonArray = null;
		JSONObject JsonObject = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		SimpleDateFormat yyyymmdd = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		SimpleDateFormat ddmmyyyy = new SimpleDateFormat("dd-MM-yyyy");
		try {
			JsonArray = new JSONArray();
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(IronMiningStatement.GET_FORM_THREE_DETAILS);
			pstmt.setInt(1, autoGeneratedId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				JsonObject = new JSONObject();
				JsonObject.put("productionReasonIndex", rs.getString("INC_DEC_PROD_REASON"));
				JsonObject.put("gradeWiseReasonIndex", rs.getString("INC_DEC_GRADE_REASON"));
				JsonObject.put("remarksIndex", rs.getString("OTHER_REMARKS"));
				JsonObject.put("placeIndex", rs.getString("PLACE"));
				if (rs.getString("ENTERED_DATE").equals("") || rs.getString("ENTERED_DATE").contains("1900")) {
					JsonObject.put("dateIndex", "");
				} else {
					JsonObject.put("dateIndex", ddmmyyyy.format(yyyymmdd.parse(rs.getString("ENTERED_DATE"))));
				}
				JsonObject.put("nameIndex", rs.getString("ENTERED_BY"));
				JsonObject.put("designationIndex", rs.getString("DESIGNATION"));
				JsonArray.put(JsonObject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return JsonArray;
	}

	public String finalSubmission(int monthlyFormId) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String message = "";
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(IronMiningStatement.FINAL_SUBMISSION_OF_MFD);
			pstmt.setInt(1, monthlyFormId);
			int updated = pstmt.executeUpdate();
			if (updated > 0) {
				message = "Saved Successfully";
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return message;
	}

	public JSONArray getOversizeDetails(int autoGeneratedKey) {

		JSONArray JsonArray = null;
		JSONObject JsonObject = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int count = 0;
		try {
			JsonArray = new JSONArray();
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(IronMiningStatement.GET_OVERSIZE_DATA);
			pstmt.setInt(1, autoGeneratedKey);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				count++;
				JsonObject = new JSONObject();
				JsonObject.put("SLNOIndex", count);
				JsonObject.put("oversizeLocationIndex", rs.getString("LOCATION_OF_PLANT"));
				JsonObject.put("oversizeOpeningIndex", rs.getString("OPENING_STOCK_OF_OVERSIZE"));
				JsonObject.put("oversizeGenerationIndex", rs.getString("GENERATION_OF_OVERSIZE"));
				JsonObject.put("oversizeProcessedIndex", rs.getString("PROCESSING_OF_OVERSIZE"));
				JsonObject.put("oversizeClosingStockIndex", rs.getString("CLOSING_STOCK_OF_OVERSIZE"));
				JsonObject.put("autoIncIdIndex", rs.getString("ID"));
				JsonArray.put(JsonObject);
			}

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return JsonArray;
	}

	public JSONArray getProductionDetails(int autoGeneratedKey, String mineral) {

		JSONArray JsonArray = null;
		JSONObject JsonObject = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(IronMiningStatement.GET_PRODUCT_AND_CLOSING_BALANCE_DETAILS);
			pstmt.setInt(1, autoGeneratedKey);
			pstmt.setInt(2, autoGeneratedKey);
			pstmt.setInt(3, autoGeneratedKey);
			pstmt.setInt(4, autoGeneratedKey);
			rs = pstmt.executeQuery();
			HashMap<String, JSONObject> finlist = new HashMap<String, JSONObject>();
			if (mineral.equalsIgnoreCase("Iron Ore")) {
				JsonObject = getproductionJSONObject("Fe:Lumps:Below 55%");
				finlist.put("Fe:Lumps:Below 55%", JsonObject);
				JsonObject = getproductionJSONObject("Fe:Lumps:55% to Below 58%");
				finlist.put("Fe:Lumps:55% to Below 58%", JsonObject);
				JsonObject = getproductionJSONObject("Fe:Lumps:58% to Below 60%");
				finlist.put("Fe:Lumps:58% to Below 60%", JsonObject);
				JsonObject = getproductionJSONObject("Fe:Lumps:60% to Below 62%");
				finlist.put("Fe:Lumps:60% to Below 62%", JsonObject);
				JsonObject = getproductionJSONObject("Fe:Lumps:62% to Below 65%");
				finlist.put("Fe:Lumps:62% to Below 65%", JsonObject);
				JsonObject = getproductionJSONObject("Fe:Lumps:65% and above");
				finlist.put("Fe:Lumps:65% and above", JsonObject);

				JsonObject = getproductionJSONObject("Fe:Fines:Below 55%");
				finlist.put("Fe:Fines:Below 55%", JsonObject);
				JsonObject = getproductionJSONObject("Fe:Fines:55% to Below 58%");
				finlist.put("Fe:Fines:55% to Below 58%", JsonObject);
				JsonObject = getproductionJSONObject("Fe:Fines:58% to Below 60%");
				finlist.put("Fe:Fines:58% to Below 60%", JsonObject);
				JsonObject = getproductionJSONObject("Fe:Fines:60% to Below 62%");
				finlist.put("Fe:Fines:60% to Below 62%", JsonObject);
				JsonObject = getproductionJSONObject("Fe:Fines:62% to Below 65%");
				finlist.put("Fe:Fines:62% to Below 65%", JsonObject);
				JsonObject = getproductionJSONObject("Fe:Fines:65% and above");
				finlist.put("Fe:Fines:65% and above", JsonObject);

				JsonObject = getproductionJSONObject("Total");
				finlist.put("Total", JsonObject);
				JsonObject = getproductionJSONObject("Total Waste & Tailing");
				finlist.put("Total Waste & Tailing", JsonObject);
				JsonObject = getproductionJSONObject("Total Closing Stock Of Oversize");
				finlist.put("Total Closing Stock Of Oversize", JsonObject);
				JsonObject = getproductionJSONObject("Reconciled");
				finlist.put("Reconciled", JsonObject);

			} else if (mineral.equalsIgnoreCase("Manganese")) {
				JsonObject = getproductionJSONObject("Mn:Below 25%");
				finlist.put("Mn:Below 25%", JsonObject);
				JsonObject = getproductionJSONObject("Mn:25% to Below 35%");
				finlist.put("Mn:25% to Below 35%", JsonObject);
				JsonObject = getproductionJSONObject("Mn:35% to Below 46%");
				finlist.put("Mn:35% to Below 46%", JsonObject);
				JsonObject = getproductionJSONObject("Mn:46% and above");
				finlist.put("Mn:46% and above", JsonObject);
				JsonObject = getproductionJSONObject("Mn:Dioxide ore");
				finlist.put("Mn:Dioxide ore", JsonObject);
				JsonObject = getproductionJSONObject("Mn:Concentrates");
				finlist.put("Mn:Concentrates", JsonObject);
				JsonObject = getproductionJSONObject("Total");
				finlist.put("Total", JsonObject);
				JsonObject = getproductionJSONObject("Total Waste & Tailing");
				finlist.put("Total Waste & Tailing", JsonObject);
				JsonObject = getproductionJSONObject("Total Closing Stock Of Oversize");
				finlist.put("Total Closing Stock Of Oversize", JsonObject);
				JsonObject = getproductionJSONObject("Reconciled");
				finlist.put("Reconciled", JsonObject);
			} else if (mineral.equalsIgnoreCase("Bauxite/Laterite")) {
				JsonObject = getproductionJSONObject("Al:Below 40%");
				finlist.put("Al:Below 40%", JsonObject);
				JsonObject = getproductionJSONObject("Al:40% to Below 45%");
				finlist.put("Al:40% to Below 45%", JsonObject);
				JsonObject = getproductionJSONObject("Al:45% to Below 50%");
				finlist.put("Al:45% to Below 50%", JsonObject);
				JsonObject = getproductionJSONObject("Al:50% to Below 55%");
				finlist.put("Al:50% to Below 55%", JsonObject);
				JsonObject = getproductionJSONObject("Al:55% to Below 60%");
				finlist.put("Al:55% to Below 60%", JsonObject);
				JsonObject = getproductionJSONObject("Al:60% and above");
				finlist.put("Al:60% and above", JsonObject);
				JsonObject = getproductionJSONObject("Other than Al:Cement");
				finlist.put("Other than Al:Cement", JsonObject);
				JsonObject = getproductionJSONObject("Other than Al:Abrasive");
				finlist.put("Other than Al:Abrasive", JsonObject);
				JsonObject = getproductionJSONObject("Other than Al:Refactory");
				finlist.put("Other than Al:Refactory", JsonObject);
				JsonObject = getproductionJSONObject("Other than Al:Chemical");
				finlist.put("Other than Al:Chemical", JsonObject);
				JsonObject = getproductionJSONObject("Total");
				finlist.put("Total", JsonObject);
				JsonObject = getproductionJSONObject("Total Waste & Tailing");
				finlist.put("Total Waste & Tailing", JsonObject);
				JsonObject = getproductionJSONObject("Total Closing Stock Of Oversize");
				finlist.put("Total Closing Stock Of Oversize", JsonObject);
				JsonObject = getproductionJSONObject("Reconciled");
				finlist.put("Reconciled", JsonObject);
			}
			while (rs.next()) {
				JsonObject = new JSONObject();
				JsonObject.put("SLNOIndex", finlist.get(rs.getString("GRADE")).getString("SLNOIndex"));
				JsonObject.put("productGradeIndex", rs.getString("GRADE"));
				JsonObject.put("ProductOpeningIndex", rs.getString("OPENING_STOCK"));
				JsonObject.put("productIndex", rs.getString("PRODUCT"));
				JsonObject.put("despatchIndex", rs.getString("DESPATCH"));
				JsonObject.put("productClosingIndex", rs.getString("CLOSING_STOCK"));
				JsonObject.put("autoIncIdIndex", rs.getString("ID"));

				finlist.remove(rs.getString("GRADE"));
				finlist.put(rs.getString("GRADE"), JsonObject);
			}
			if (mineral.equalsIgnoreCase("Iron Ore")) {
				JsonArray = new JSONArray();
				JsonArray.put(finlist.get("Fe:Lumps:Below 55%"));
				JsonArray.put(finlist.get("Fe:Lumps:55% to Below 58%"));
				JsonArray.put(finlist.get("Fe:Lumps:58% to Below 60%"));
				JsonArray.put(finlist.get("Fe:Lumps:60% to Below 62%"));
				JsonArray.put(finlist.get("Fe:Lumps:62% to Below 65%"));
				JsonArray.put(finlist.get("Fe:Lumps:65% and above"));
				JsonArray.put(finlist.get("Fe:Fines:Below 55%"));
				JsonArray.put(finlist.get("Fe:Fines:55% to Below 58%"));
				JsonArray.put(finlist.get("Fe:Fines:58% to Below 60%"));
				JsonArray.put(finlist.get("Fe:Fines:60% to Below 62%"));
				JsonArray.put(finlist.get("Fe:Fines:62% to Below 65%"));
				JsonArray.put(finlist.get("Fe:Fines:65% and above"));
				JsonArray.put(finlist.get("Total"));
				JsonArray.put(finlist.get("Total Waste & Tailing"));
				JsonArray.put(finlist.get("Total Closing Stock Of Oversize"));
				JsonArray.put(finlist.get("Reconciled"));
			} else if (mineral.equalsIgnoreCase("Manganese")) {
				JsonArray = new JSONArray();
				JsonArray.put(finlist.get("Mn:Below 25%"));
				JsonArray.put(finlist.get("Mn:25% to Below 35%"));
				JsonArray.put(finlist.get("Mn:35% to Below 46%"));
				JsonArray.put(finlist.get("Mn:46% and above"));
				JsonArray.put(finlist.get("Mn:Dioxide ore"));
				JsonArray.put(finlist.get("Mn:Concentrates"));
				JsonArray.put(finlist.get("Total"));
				JsonArray.put(finlist.get("Total Waste & Tailing"));
				JsonArray.put(finlist.get("Total Closing Stock Of Oversize"));
				JsonArray.put(finlist.get("Reconciled"));
			} else if (mineral.equalsIgnoreCase("Bauxite/Laterite")) {
				JsonArray = new JSONArray();
				JsonArray.put(finlist.get("Al:Below 40%"));
				JsonArray.put(finlist.get("Al:40% to Below 45%"));
				JsonArray.put(finlist.get("Al:45% to Below 50%"));
				JsonArray.put(finlist.get("Al:50% to Below 55%"));
				JsonArray.put(finlist.get("Al:55% to Below 60%"));
				JsonArray.put(finlist.get("Al:60% and above"));
				JsonArray.put(finlist.get("Other than Al:Cement"));
				JsonArray.put(finlist.get("Other than Al:Abrasive"));
				JsonArray.put(finlist.get("Other than Al:Refactory"));
				JsonArray.put(finlist.get("Other than Al:Chemical"));
				JsonArray.put(finlist.get("Total"));
				JsonArray.put(finlist.get("Total Waste & Tailing"));
				JsonArray.put(finlist.get("Total Closing Stock Of Oversize"));
				JsonArray.put(finlist.get("Reconciled"));
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return JsonArray;
	}

	public JSONArray getROMProcessingDetails(int autoGeneratedKey) {

		JSONArray JsonArray = null;
		JSONObject JsonObject = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int count = 0;
		try {
			JsonArray = new JSONArray();
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(IronMiningStatement.GET_ROM_PROSESSING_DATA);
			pstmt.setInt(1, autoGeneratedKey);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				count++;
				JsonObject = new JSONObject();
				JsonObject.put("SLNOIndex", count);
				JsonObject.put("plantLocationIndex", rs.getString("LOCATION_OF_PLANT"));
				JsonObject.put("openingRomIndex", rs.getString("OPENING_STOCK_OF_ROM"));
				JsonObject.put("receiptIndex", rs.getString("RECEIPT_OF_ROM"));
				JsonObject.put("romProcessedIndex", rs.getString("ROM_PROCESSED"));
				JsonObject.put("closingStockromIndex", rs.getString("CLOSING_STOCK_OF_ROM"));
				JsonObject.put("autoIncIdIndex", rs.getString("ID"));
				JsonArray.put(JsonObject);
			}

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return JsonArray;
	}

	public JSONObject getproductionJSONObject(String grade) {
		JSONObject JsonObject = new JSONObject();
		try {
			JsonObject.put("SLNOIndex", ++counts);
			JsonObject.put("ProductOpeningIndex", "");
			JsonObject.put("productIndex", "");
			JsonObject.put("despatchIndex", "");
			JsonObject.put("productClosingIndex", "");
			JsonObject.put("productGradeIndex", grade);

		} catch (Exception e) {
			e.printStackTrace();
		}
		return JsonObject;
	}

	public JSONArray getOreProcessedDetails(int autoGeneraedKey, String mineral) {

		JSONArray JsonArray = null;
		JSONObject JsonObject = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(IronMiningStatement.GET_ORE_PROCESSED_DETAILS);
			pstmt.setInt(1, autoGeneraedKey);
			pstmt.setInt(2, autoGeneraedKey);
			rs = pstmt.executeQuery();
			HashMap<String, JSONObject> finlist = new HashMap<String, JSONObject>();
			if (mineral.equalsIgnoreCase("Iron Ore")) {
				JsonObject = getRomGradeWiseJSONObject("Fe:Below 55%");
				finlist.put("Fe:Below 55%", JsonObject);
				JsonObject = getRomGradeWiseJSONObject("Fe:55% to Below 58%");
				finlist.put("Fe:55% to Below 58%", JsonObject);
				JsonObject = getRomGradeWiseJSONObject("Fe:58% to Below 60%");
				finlist.put("Fe:58% to Below 60%", JsonObject);
				JsonObject = getRomGradeWiseJSONObject("Fe:60% to Below 62%");
				finlist.put("Fe:60% to Below 62%", JsonObject);
				JsonObject = getRomGradeWiseJSONObject("Fe:62% to Below 65%");
				finlist.put("Fe:62% to Below 65%", JsonObject);
				JsonObject = getRomGradeWiseJSONObject("Fe:65% and above");
				finlist.put("Fe:65% and above", JsonObject);
				JsonObject = getRomGradeWiseJSONObject("Total");
				finlist.put("Total", JsonObject);
			} else if (mineral.equalsIgnoreCase("Manganese")) {
				JsonObject = getRomGradeWiseJSONObject("Mn:Below 25%");
				finlist.put("Mn:Below 25%", JsonObject);
				JsonObject = getRomGradeWiseJSONObject("Mn:25% to Below 35%");
				finlist.put("Mn:25% to Below 35%", JsonObject);
				JsonObject = getRomGradeWiseJSONObject("Mn:35% to Below 46%");
				finlist.put("Mn:35% to Below 46%", JsonObject);
				JsonObject = getRomGradeWiseJSONObject("Mn:46% and above");
				finlist.put("Mn:46% and above", JsonObject);
				JsonObject = getRomGradeWiseJSONObject("Mn:Dioxide ore");
				finlist.put("Mn:Dioxide ore", JsonObject);
				JsonObject = getRomGradeWiseJSONObject("Mn:Concentrates");
				finlist.put("Mn:Concentrates", JsonObject);
				JsonObject = getRomGradeWiseJSONObject("Total");
				finlist.put("Total", JsonObject);
			} else if (mineral.equalsIgnoreCase("Bauxite/Laterite")) {
				JsonObject = getRomGradeWiseJSONObject("Al:Below 40%");
				finlist.put("Al:Below 40%", JsonObject);
				JsonObject = getRomGradeWiseJSONObject("Al:40% to Below 45%");
				finlist.put("Al:40% to Below 45%", JsonObject);
				JsonObject = getRomGradeWiseJSONObject("Al:45% to Below 50%");
				finlist.put("Al:45% to Below 50%", JsonObject);
				JsonObject = getRomGradeWiseJSONObject("Al:50% to Below 55%");
				finlist.put("Al:50% to Below 55%", JsonObject);
				JsonObject = getRomGradeWiseJSONObject("Al:55% to Below 60%");
				finlist.put("Al:55% to Below 60%", JsonObject);
				JsonObject = getRomGradeWiseJSONObject("Al:60% and above");
				finlist.put("Al:60% and above", JsonObject);
				JsonObject = getRomGradeWiseJSONObject("Other than Al:Cement");
				finlist.put("Other than Al:Cement", JsonObject);
				JsonObject = getRomGradeWiseJSONObject("Other than Al:Abrasive");
				finlist.put("Other than Al:Abrasive", JsonObject);
				JsonObject = getRomGradeWiseJSONObject("Other than Al:Refactory");
				finlist.put("Other than Al:Refactory", JsonObject);
				JsonObject = getRomGradeWiseJSONObject("Other than Al:Chemical");
				finlist.put("Other than Al:Chemical", JsonObject);
				JsonObject = getRomGradeWiseJSONObject("Total");
				finlist.put("Total", JsonObject);
			}
			while (rs.next()) {
				JsonObject = new JSONObject();
				JsonObject.put("SLNOIndex", finlist.get(rs.getString("GRADE")).getString("SLNOIndex"));
				JsonObject.put("ROMgradeIndex", rs.getString("GRADE"));
				JsonObject.put("finesIndex", rs.getString("FINES"));
				JsonObject.put("lumpsIndex", rs.getString("LUMPS"));
				JsonObject.put("oversizeIndex", rs.getString("OVERSIZE"));
				JsonObject.put("tailingIndex", rs.getString("WASTE"));

				finlist.remove(rs.getString("GRADE"));
				finlist.put(rs.getString("GRADE"), JsonObject);
			}
			if (mineral.equalsIgnoreCase("Iron Ore")) {
				JsonArray = new JSONArray();
				JsonArray.put(finlist.get("Fe:Below 55%"));
				JsonArray.put(finlist.get("Fe:55% to Below 58%"));
				JsonArray.put(finlist.get("Fe:58% to Below 60%"));
				JsonArray.put(finlist.get("Fe:60% to Below 62%"));
				JsonArray.put(finlist.get("Fe:62% to Below 65%"));
				JsonArray.put(finlist.get("Fe:65% and above"));
				JsonArray.put(finlist.get("Total"));
			} else if (mineral.equalsIgnoreCase("Manganese")) {
				JsonArray = new JSONArray();
				JsonArray.put(finlist.get("Mn:Below 25%"));
				JsonArray.put(finlist.get("Mn:25% to Below 35%"));
				JsonArray.put(finlist.get("Mn:35% to Below 46%"));
				JsonArray.put(finlist.get("Mn:46% and above"));
				JsonArray.put(finlist.get("Mn:Dioxide ore"));
				JsonArray.put(finlist.get("Mn:Concentrates"));
				JsonArray.put(finlist.get("Total"));
			} else if (mineral.equalsIgnoreCase("Bauxite/Laterite")) {
				JsonArray = new JSONArray();
				JsonArray.put(finlist.get("Al:Below 40%"));
				JsonArray.put(finlist.get("Al:40% to Below 45%"));
				JsonArray.put(finlist.get("Al:45% to Below 50%"));
				JsonArray.put(finlist.get("Al:50% to Below 55%"));
				JsonArray.put(finlist.get("Al:55% to Below 60%"));
				JsonArray.put(finlist.get("Al:60% and above"));
				JsonArray.put(finlist.get("Other than Al:Cement"));
				JsonArray.put(finlist.get("Other than Al:Abrasive"));
				JsonArray.put(finlist.get("Other than Al:Refactory"));
				JsonArray.put(finlist.get("Other than Al:Chemical"));
				JsonArray.put(finlist.get("Total"));
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return JsonArray;
	}

	public JSONArray getOversizeProcessingDeatils(int autoGeneratedKey, String mineral) {

		JSONArray JsonArray = null;
		JSONObject JsonObject = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(IronMiningStatement.GET_OVERSIZE_PROCESSING_DETAILS);
			pstmt.setInt(1, autoGeneratedKey);
			pstmt.setInt(2, autoGeneratedKey);
			rs = pstmt.executeQuery();
			HashMap<String, JSONObject> finlist = new HashMap<String, JSONObject>();
			if (mineral.equalsIgnoreCase("Iron Ore")) {
				JsonObject = getOversizeJSONObject("Fe:Below 55%");
				finlist.put("Fe:Below 55%", JsonObject);
				JsonObject = getOversizeJSONObject("Fe:55% to Below 58%");
				finlist.put("Fe:55% to Below 58%", JsonObject);
				JsonObject = getOversizeJSONObject("Fe:58% to Below 60%");
				finlist.put("Fe:58% to Below 60%", JsonObject);
				JsonObject = getOversizeJSONObject("Fe:60% to Below 62%");
				finlist.put("Fe:60% to Below 62%", JsonObject);
				JsonObject = getOversizeJSONObject("Fe:62% to Below 65%");
				finlist.put("Fe:62% to Below 65%", JsonObject);
				JsonObject = getOversizeJSONObject("Fe:65% and above");
				finlist.put("Fe:65% and above", JsonObject);
				JsonObject = getOversizeJSONObject("Total");
				finlist.put("Total", JsonObject);
			} else if (mineral.equalsIgnoreCase("Manganese")) {
				JsonObject = getOversizeJSONObject("Mn:Below 25%");
				finlist.put("Mn:Below 25%", JsonObject);
				JsonObject = getOversizeJSONObject("Mn:25% to Below 35%");
				finlist.put("Mn:25% to Below 35%", JsonObject);
				JsonObject = getOversizeJSONObject("Mn:35% to Below 46%");
				finlist.put("Mn:35% to Below 46%", JsonObject);
				JsonObject = getOversizeJSONObject("Mn:46% and above");
				finlist.put("Mn:46% and above", JsonObject);
				JsonObject = getOversizeJSONObject("Mn:Dioxide ore");
				finlist.put("Mn:Dioxide ore", JsonObject);
				JsonObject = getOversizeJSONObject("Mn:Concentrates");
				finlist.put("Mn:Concentrates", JsonObject);
				JsonObject = getOversizeJSONObject("Total");
				finlist.put("Total", JsonObject);
			} else if (mineral.equalsIgnoreCase("Bauxite/Laterite")) {
				JsonObject = getOversizeJSONObject("Al:Below 40%");
				finlist.put("Al:Below 40%", JsonObject);
				JsonObject = getOversizeJSONObject("Al:40% to Below 45%");
				finlist.put("Al:40% to Below 45%", JsonObject);
				JsonObject = getOversizeJSONObject("Al:45% to Below 50%");
				finlist.put("Al:45% to Below 50%", JsonObject);
				JsonObject = getOversizeJSONObject("Al:50% to Below 55%");
				finlist.put("Al:50% to Below 55%", JsonObject);
				JsonObject = getOversizeJSONObject("Al:55% to Below 60%");
				finlist.put("Al:55% to Below 60%", JsonObject);
				JsonObject = getOversizeJSONObject("Al:60% and above");
				finlist.put("Al:60% and above", JsonObject);
				JsonObject = getOversizeJSONObject("Other than Al:Cement");
				finlist.put("Other than Al:Cement", JsonObject);
				JsonObject = getOversizeJSONObject("Other than Al:Abrasive");
				finlist.put("Other than Al:Abrasive", JsonObject);
				JsonObject = getOversizeJSONObject("Other than Al:Refactory");
				finlist.put("Other than Al:Refactory", JsonObject);
				JsonObject = getOversizeJSONObject("Other than Al:Chemical");
				finlist.put("Other than Al:Chemical", JsonObject);
				JsonObject = getOversizeJSONObject("Total");
				finlist.put("Total", JsonObject);
			}
			while (rs.next()) {
				JsonObject = new JSONObject();
				JsonObject.put("SLNOIndex", finlist.get(rs.getString("GRADE")).getString("SLNOIndex"));
				JsonObject.put("overSizeGradeIndex", rs.getString("GRADE"));
				JsonObject.put("oversizeFinesIndex", rs.getString("OVERSIZE_FINES"));
				JsonObject.put("oversizeLumpsIndex", rs.getString("OVERSIZE_LUMPS"));
				JsonObject.put("oversizeTailingIndex", rs.getString("OVERSIZE_WASTE"));

				finlist.remove(rs.getString("GRADE"));
				finlist.put(rs.getString("GRADE"), JsonObject);
			}
			if (mineral.equalsIgnoreCase("Iron Ore")) {
				JsonArray = new JSONArray();
				JsonArray.put(finlist.get("Fe:Below 55%"));
				JsonArray.put(finlist.get("Fe:55% to Below 58%"));
				JsonArray.put(finlist.get("Fe:58% to Below 60%"));
				JsonArray.put(finlist.get("Fe:60% to Below 62%"));
				JsonArray.put(finlist.get("Fe:62% to Below 65%"));
				JsonArray.put(finlist.get("Fe:65% and above"));
				JsonArray.put(finlist.get("Total"));
			} else if (mineral.equalsIgnoreCase("Manganese")) {
				JsonArray = new JSONArray();
				JsonArray.put(finlist.get("Mn:Below 25%"));
				JsonArray.put(finlist.get("Mn:25% to Below 35%"));
				JsonArray.put(finlist.get("Mn:35% to Below 46%"));
				JsonArray.put(finlist.get("Mn:46% and above"));
				JsonArray.put(finlist.get("Mn:Dioxide ore"));
				JsonArray.put(finlist.get("Mn:Concentrates"));
				JsonArray.put(finlist.get("Total"));
			} else if (mineral.equalsIgnoreCase("Bauxite/Laterite")) {
				JsonArray = new JSONArray();
				JsonArray.put(finlist.get("Al:Below 40%"));
				JsonArray.put(finlist.get("Al:40% to Below 45%"));
				JsonArray.put(finlist.get("Al:45% to Below 50%"));
				JsonArray.put(finlist.get("Al:50% to Below 55%"));
				JsonArray.put(finlist.get("Al:55% to Below 60%"));
				JsonArray.put(finlist.get("Al:60% and above"));
				JsonArray.put(finlist.get("Other than Al:Cement"));
				JsonArray.put(finlist.get("Other than Al:Abrasive"));
				JsonArray.put(finlist.get("Other than Al:Refactory"));
				JsonArray.put(finlist.get("Other than Al:Chemical"));
				JsonArray.put(finlist.get("Total"));
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return JsonArray;
	}

	public JSONObject getOversizeJSONObject(String grade) {
		JSONObject JsonObject = new JSONObject();
		try {
			JsonObject.put("SLNOIndex", ++counts);
			JsonObject.put("oversizeFinesIndex", "");
			JsonObject.put("oversizeLumpsIndex", "");
			JsonObject.put("oversizeTailingIndex", "");
			JsonObject.put("overSizeGradeIndex", grade);

		} catch (Exception e) {
			e.printStackTrace();
		}
		return JsonObject;
	}

	public String saveFormOnePartFourInformation(int autoGeneratedKeys, String typeOfOre, JSONArray jsonarray,
			JSONArray jsonarray1, JSONArray jsonarray2, JSONArray jsonarray3, JSONArray jsonarray4) {
		JSONObject jsonObject = new JSONObject();
		Connection con = null;
		ResultSet rs = null;
		PreparedStatement pst = null;
		PreparedStatement pstmt = null;
		PreparedStatement pstmt1 = null;
		PreparedStatement pstmt2 = null;
		PreparedStatement pstmt3 = null;
		PreparedStatement pstmt4 = null;
		try {
			con = DBConnection.getConnectionToDB("AMS");
			//			pst = con.prepareStatement(IronMiningStatement.UPDATE_TYPE_OF_ORE);
			//			pst.setString(1, typeOfOre);
			//			pst.setInt(2,autoGeneratedKeys);
			//			pst.executeUpdate();

			for (int i = 0; i < jsonarray.length(); i++) {
				jsonObject = jsonarray.getJSONObject(i);
				String plantLocation = "";
				float openingStockRom = 0;
				float receiptOfRom = 0;
				float RomProcessed = 0;
				float closingStockRom = 0;
				int autoIncId = 0;
				if (jsonObject.getString("plantLocationIndex") != null
						&& !jsonObject.getString("plantLocationIndex").equals("")) {
					plantLocation = jsonObject.getString("plantLocationIndex");
				}
				if (jsonObject.getString("openingRomIndex") != null
						&& !jsonObject.getString("openingRomIndex").equals("")) {
					openingStockRom = Float.parseFloat(jsonObject.getString("openingRomIndex"));
				}
				if (jsonObject.getString("receiptIndex") != null && !jsonObject.getString("receiptIndex").equals("")) {
					receiptOfRom = Float.parseFloat(jsonObject.getString("receiptIndex"));
				}
				if (jsonObject.getString("romProcessedIndex") != null
						&& !jsonObject.getString("romProcessedIndex").equals("")) {
					RomProcessed = Float.parseFloat(jsonObject.getString("romProcessedIndex"));
				}
				if (jsonObject.getString("closingStockromIndex") != null
						&& !jsonObject.getString("closingStockromIndex").equals("")) {
					closingStockRom = Float.parseFloat(jsonObject.getString("closingStockromIndex"));
				}
				if (jsonObject.getString("autoIncIdIndex") != null
						&& !jsonObject.getString("autoIncIdIndex").equals("")) {
					autoIncId = Integer.parseInt(jsonObject.getString("autoIncIdIndex"));
				}
				if (autoIncId > 0) {
					pstmt = con.prepareStatement(IronMiningStatement.UPDATE_ROM_PROCESSING_DETAILS); //update Statement
					pstmt.setString(1, plantLocation);
					pstmt.setFloat(2, openingStockRom);
					pstmt.setFloat(3, receiptOfRom);
					pstmt.setFloat(4, RomProcessed);
					pstmt.setFloat(5, closingStockRom);
					pstmt.setInt(6, autoIncId);
					pstmt.executeUpdate();
				} else {
					pstmt = con.prepareStatement(IronMiningStatement.INSERT_ROM_PROCESSING_DETAILS);
					pstmt.setInt(1, autoGeneratedKeys);
					pstmt.setString(2, plantLocation);
					pstmt.setFloat(3, openingStockRom);
					pstmt.setFloat(4, receiptOfRom);
					pstmt.setFloat(5, RomProcessed);
					pstmt.setFloat(6, closingStockRom);
					pstmt.executeUpdate();
				}
			}
			for (int i = 0; i < jsonarray1.length(); i++) {
				jsonObject = jsonarray1.getJSONObject(i);
				String oreGrade = "";
				float fines = 0;
				float lumps = 0;
				float oversize = 0;
				float waste = 0;
				int autoIncId1 = 0;
				if (jsonObject.getString("ROMgradeIndex") != null
						&& !jsonObject.getString("ROMgradeIndex").equals("")) {
					oreGrade = jsonObject.getString("ROMgradeIndex");
				}
				if (jsonObject.getString("finesIndex") != null && !jsonObject.getString("finesIndex").equals("")) {
					fines = Float.parseFloat(jsonObject.getString("finesIndex"));
				}
				if (jsonObject.getString("lumpsIndex") != null && !jsonObject.getString("lumpsIndex").equals("")) {
					lumps = Float.parseFloat(jsonObject.getString("lumpsIndex"));
				}
				if (jsonObject.getString("oversizeIndex") != null
						&& !jsonObject.getString("oversizeIndex").equals("")) {
					oversize = Float.parseFloat(jsonObject.getString("oversizeIndex"));
				}
				if (jsonObject.getString("tailingIndex") != null && !jsonObject.getString("tailingIndex").equals("")) {
					waste = Float.parseFloat(jsonObject.getString("tailingIndex"));
				}
				if (jsonObject.getString("autoIncIdIndex") != null
						&& !jsonObject.getString("autoIncIdIndex").equals("")) {
					autoIncId1 = Integer.parseInt(jsonObject.getString("autoIncIdIndex"));
				}
				if (autoIncId1 > 0) {
					pstmt1 = con.prepareStatement(IronMiningStatement.UPDATE_ORE_PROCESSING_DETAILS); //update Statement
					pstmt1.setString(1, oreGrade);
					pstmt1.setFloat(2, fines);
					pstmt1.setFloat(3, lumps);
					pstmt1.setFloat(4, oversize);
					pstmt1.setFloat(5, waste);
					pstmt1.setInt(6, autoIncId1);
					pstmt1.executeUpdate();
				} else {
					pstmt1 = con.prepareStatement(IronMiningStatement.INSERT_ORE_PROCESSING_DETAILS);
					pstmt1.setInt(1, autoGeneratedKeys);
					pstmt1.setString(2, oreGrade);
					pstmt1.setFloat(3, fines);
					pstmt1.setFloat(4, lumps);
					pstmt1.setFloat(5, oversize);
					pstmt1.setFloat(6, waste);
					pstmt1.executeUpdate();
				}

			}
			for (int i = 0; i < jsonarray2.length(); i++) {
				jsonObject = jsonarray2.getJSONObject(i);
				String oversizeLocation = "";
				float oversizeOpeningStock = 0;
				float oversizeGeneration = 0;
				float oversizeProcessing = 0;
				float oversizeClosingStock = 0;
				int autoIncId2 = 0;
				if (jsonObject.getString("oversizeLocationIndex") != null
						&& !jsonObject.getString("oversizeLocationIndex").equals("")) {
					oversizeLocation = jsonObject.getString("oversizeLocationIndex");
				}
				if (jsonObject.getString("oversizeOpeningIndex") != null
						&& !jsonObject.getString("oversizeOpeningIndex").equals("")) {
					oversizeOpeningStock = Float.parseFloat(jsonObject.getString("oversizeOpeningIndex"));
				}
				if (jsonObject.getString("oversizeGenerationIndex") != null
						&& !jsonObject.getString("oversizeGenerationIndex").equals("")) {
					oversizeGeneration = Float.parseFloat(jsonObject.getString("oversizeGenerationIndex"));
				}
				if (jsonObject.getString("oversizeProcessedIndex") != null
						&& !jsonObject.getString("oversizeProcessedIndex").equals("")) {
					oversizeProcessing = Float.parseFloat(jsonObject.getString("oversizeProcessedIndex"));
				}
				if (jsonObject.getString("oversizeClosingStockIndex") != null
						&& !jsonObject.getString("oversizeClosingStockIndex").equals("")) {
					oversizeClosingStock = Float.parseFloat(jsonObject.getString("oversizeClosingStockIndex"));
				}
				if (jsonObject.getString("autoIncIdIndex") != null
						&& !jsonObject.getString("autoIncIdIndex").equals("")) {
					autoIncId2 = Integer.parseInt(jsonObject.getString("autoIncIdIndex"));
				}
				if (autoIncId2 > 0) {
					pstmt2 = con.prepareStatement(IronMiningStatement.UPDATE_OVERSIZE_DETAILS); //update Statement
					pstmt2.setString(1, oversizeLocation);
					pstmt2.setFloat(2, oversizeOpeningStock);
					pstmt2.setFloat(3, oversizeGeneration);
					pstmt2.setFloat(4, oversizeProcessing);
					pstmt2.setFloat(5, oversizeClosingStock);
					pstmt2.setInt(6, autoIncId2);
					pstmt2.executeUpdate();
				} else {
					pstmt2 = con.prepareStatement(IronMiningStatement.INSERT_OVERSIZE_DETAILS);
					pstmt2.setInt(1, autoGeneratedKeys);
					pstmt2.setString(2, oversizeLocation);
					pstmt2.setFloat(3, oversizeOpeningStock);
					pstmt2.setFloat(4, oversizeGeneration);
					pstmt2.setFloat(5, oversizeProcessing);
					pstmt2.setFloat(6, oversizeClosingStock);
					pstmt2.executeUpdate();
				}
			}
			for (int i = 0; i < jsonarray3.length(); i++) {
				jsonObject = jsonarray3.getJSONObject(i);
				String OversizeGrade = "";
				float oversizeFines = 0;
				float oversizeLumps = 0;
				float oversizeWaste = 0;
				int autoIncId3 = 0;
				if (jsonObject.getString("overSizeGradeIndex") != null
						&& !jsonObject.getString("overSizeGradeIndex").equals("")) {
					OversizeGrade = jsonObject.getString("overSizeGradeIndex");
				}
				if (jsonObject.getString("oversizeFinesIndex") != null
						&& !jsonObject.getString("oversizeFinesIndex").equals("")) {
					oversizeFines = Float.parseFloat(jsonObject.getString("oversizeFinesIndex"));
				}
				if (jsonObject.getString("oversizeLumpsIndex") != null
						&& !jsonObject.getString("oversizeLumpsIndex").equals("")) {
					oversizeLumps = Float.parseFloat(jsonObject.getString("oversizeLumpsIndex"));
				}
				if (jsonObject.getString("oversizeTailingIndex") != null
						&& !jsonObject.getString("oversizeTailingIndex").equals("")) {
					oversizeWaste = Float.parseFloat(jsonObject.getString("oversizeTailingIndex"));
				}
				if (jsonObject.getString("autoIncIdIndex") != null
						&& !jsonObject.getString("autoIncIdIndex").equals("")) {
					autoIncId3 = Integer.parseInt((jsonObject.getString("autoIncIdIndex")));
				}
				if (autoIncId3 > 0) {
					pstmt3 = con.prepareStatement(IronMiningStatement.UPDATE_OVERSIZE_PROCESSING_DETAILS); //update Statement
					pstmt3.setString(1, OversizeGrade);
					pstmt3.setFloat(2, oversizeFines);
					pstmt3.setFloat(3, oversizeLumps);
					pstmt3.setFloat(4, oversizeWaste);
					pstmt3.setInt(5, autoIncId3);
					pstmt3.executeUpdate();
				} else {
					pstmt3 = con.prepareStatement(IronMiningStatement.INSERT_OVERSIZE_PROCESSING_DETAILS);
					pstmt3.setInt(1, autoGeneratedKeys);
					pstmt3.setString(2, OversizeGrade);
					pstmt3.setFloat(3, oversizeFines);
					pstmt3.setFloat(4, oversizeLumps);
					pstmt3.setFloat(5, oversizeWaste);
					pstmt3.executeUpdate();
				}

			}
			for (int i = 0; i < jsonarray4.length(); i++) {
				jsonObject = jsonarray4.getJSONObject(i);
				String productGrade = "";
				float openingStock = 0;
				float product = 0;
				float despatch = 0;
				float closingStock = 0;
				int autoIncId4 = 0;
				if (jsonObject.getString("productGradeIndex") != null
						&& !jsonObject.getString("productGradeIndex").equals("")) {
					productGrade = jsonObject.getString("productGradeIndex");
				}
				if (jsonObject.getString("ProductOpeningIndex") != null
						&& !jsonObject.getString("ProductOpeningIndex").equals("")) {
					openingStock = Float.parseFloat(jsonObject.getString("ProductOpeningIndex"));
				}
				if (jsonObject.getString("productIndex") != null && !jsonObject.getString("productIndex").equals("")) {
					product = Float.parseFloat(jsonObject.getString("productIndex"));
				}
				if (jsonObject.getString("despatchIndex") != null
						&& !jsonObject.getString("despatchIndex").equals("")) {
					despatch = Float.parseFloat(jsonObject.getString("despatchIndex"));
				}
				if (jsonObject.getString("productClosingIndex") != null
						&& !jsonObject.getString("productClosingIndex").equals("")) {
					closingStock = Float.parseFloat(jsonObject.getString("productClosingIndex"));
				}
				if (jsonObject.getString("autoIncIdIndex") != null
						&& !jsonObject.getString("autoIncIdIndex").equals("")) {
					autoIncId4 = Integer.parseInt((jsonObject.getString("autoIncIdIndex")));
				}
				if (autoIncId4 > 0) {
					pstmt4 = con.prepareStatement(IronMiningStatement.UPDATE_PRODUCT_GENERATED_DETAILS); //update Statement
					pstmt4.setString(1, productGrade);
					pstmt4.setFloat(2, openingStock);
					pstmt4.setFloat(3, product);
					pstmt4.setFloat(4, despatch);
					pstmt4.setFloat(5, closingStock);
					pstmt4.setInt(6, autoIncId4);
					pstmt4.executeUpdate();
				} else {
					pstmt4 = con.prepareStatement(IronMiningStatement.INSERT_PRODUCT_GENERATED_DETAILS);
					pstmt4.setInt(1, autoGeneratedKeys);
					pstmt4.setString(2, productGrade);
					pstmt4.setFloat(3, openingStock);
					pstmt4.setFloat(4, product);
					pstmt4.setFloat(5, despatch);
					pstmt4.setFloat(6, closingStock);
					pstmt4.executeUpdate();
				}

			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
			DBConnection.releaseConnectionToDB(null, pstmt1, null);
			DBConnection.releaseConnectionToDB(null, pstmt2, null);
			DBConnection.releaseConnectionToDB(null, pstmt3, null);
			DBConnection.releaseConnectionToDB(null, pstmt4, null);
		}
		return "Saved Successfully";
	}

	public JSONObject getRomGradeWiseJSONObject(String grade) {
		JSONObject JsonObject = new JSONObject();
		try {
			JsonObject.put("SLNOIndex", ++counts);
			JsonObject.put("finesIndex", "");
			JsonObject.put("lumpsIndex", "");
			JsonObject.put("oversizeIndex", "");
			JsonObject.put("tailingIndex", "");
			JsonObject.put("ROMgradeIndex", grade);

		} catch (Exception e) {
			e.printStackTrace();
		}
		return JsonObject;
	}

	public ArrayList<Object> getSalesDispatchDetails(int systemId, int custId, String monthYear, String mineralName,
			String grade) {
		ArrayList<ReportHelper> reportsList = new ArrayList<ReportHelper>();
		ArrayList<String> headersList = new ArrayList<String>();
		ReportHelper finalreporthelper = new ReportHelper();
		ArrayList<Object> finlist = new ArrayList<Object>();
		JSONArray JsonArray = null;
		JSONObject JsonObject = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int count = 0;
		try {
			headersList.add("SLNO");
			headersList.add("TC No");
			headersList.add("Mine Code");
			headersList.add("Nature of Dispatch");
			headersList.add("Consignee Name& Registration Number");
			headersList.add("Domestic Quantity");
			headersList.add("Sale Value");
			headersList.add("Country");
			headersList.add("Export Quantity");
			headersList.add("F.O.B Value(Rs)");
			JsonArray = new JSONArray();

			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(IronMiningStatement.GET_SALES_DISPATCH_DETAILS);
			String MY[] = monthYear.split(" ");
			String month = MY[0];
			String year = MY[1];
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, custId);
			pstmt.setString(3, month);
			pstmt.setString(4, year);
			pstmt.setString(5, mineralName);
			pstmt.setString(6, grade);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				count++;
				ReportHelper reporthelper = new ReportHelper();
				JsonObject = new JSONObject();
				ArrayList<Object> informationList = new ArrayList<Object>();

				JsonObject.put("slnoIndex", count);
				informationList.add(count);

				informationList.add(rs.getString("TC_NO"));
				JsonObject.put("TcNoIndex", rs.getString("TC_NO"));

				informationList.add(rs.getString("MINE_CODE"));
				JsonObject.put("MineCodeIndex", rs.getString("MINE_CODE"));

				informationList.add(rs.getString("DESPATCH"));
				JsonObject.put("DespatchNameIndex", rs.getString("DESPATCH"));

				informationList.add(rs.getString("CONSIGNEE"));
				JsonObject.put("ConsigneeNameIndex", rs.getString("CONSIGNEE"));

				informationList.add(rs.getString("DOMESTIC_QUANTITY"));
				JsonObject.put("DomesticQuantityIndex", rs.getString("DOMESTIC_QUANTITY"));

				informationList.add(rs.getString("SALE_VALUE"));
				JsonObject.put("SaleValueIndex", rs.getString("SALE_VALUE"));

				informationList.add(rs.getString("COUNTRY"));
				JsonObject.put("CountryIndex", rs.getString("COUNTRY"));

				informationList.add(rs.getString("EXPORT_QUANTITY"));
				JsonObject.put("ExportQuantityIndex", rs.getString("EXPORT_QUANTITY"));

				informationList.add(rs.getString("FOB_VALUE"));
				JsonObject.put("FOBValueIndex", rs.getString("FOB_VALUE"));

				JsonArray.put(JsonObject);
				reporthelper.setInformationList(informationList);
				reportsList.add(reporthelper);
			}
			finalreporthelper.setReportsList(reportsList);
			finalreporthelper.setHeadersList(headersList);
			finlist.add(JsonArray);
			finlist.add(finalreporthelper);

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return finlist;

	}

	public ArrayList<Object> getDeductionClaimDetails(int systemId, int custId, String monthYear, String mineralName,
			String deductionClaimed) {
		ArrayList<ReportHelper> reportsList = new ArrayList<ReportHelper>();
		ArrayList<String> headersList = new ArrayList<String>();
		ReportHelper finalreporthelper = new ReportHelper();
		ArrayList<Object> finlist = new ArrayList<Object>();
		JSONArray JsonArray = null;
		JSONObject JsonObject = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int count = 0;
		try {
			headersList.add("SLNO");
			headersList.add("Mine Code");
			headersList.add("TC No");
			headersList.add("Unit In Rs");
			JsonArray = new JSONArray();

			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(IronMiningStatement.GET_DEDUCTION_CLAIMED);
			String MY[] = monthYear.split(" ");
			String month = MY[0];
			String year = MY[1];
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, custId);
			pstmt.setString(3, month);
			pstmt.setString(4, year);
			pstmt.setString(5, mineralName);
			pstmt.setString(6, deductionClaimed);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				count++;
				ReportHelper reporthelper = new ReportHelper();
				JsonObject = new JSONObject();
				ArrayList<Object> informationList = new ArrayList<Object>();

				JsonObject.put("slnoIndex", count);
				informationList.add(count);

				informationList.add(rs.getString("MINE_CODE"));
				JsonObject.put("MineCodeIndex", rs.getString("MINE_CODE"));

				informationList.add(rs.getString("TC_NO"));
				JsonObject.put("TcNoIndex", rs.getString("TC_NO"));

				informationList.add(rs.getString("UNIT_RS_PER_TONE"));
				JsonObject.put("UnitInRsIndex", rs.getString("UNIT_RS_PER_TONE"));

				JsonArray.put(JsonObject);
				reporthelper.setInformationList(informationList);
				reportsList.add(reporthelper);
			}
			finalreporthelper.setReportsList(reportsList);
			finalreporthelper.setHeadersList(headersList);
			finlist.add(JsonArray);
			finlist.add(finalreporthelper);

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return finlist;

	}

	public ArrayList<Object> getEmploymentDetails(int custId, int systemId, String labour, String workPlace,
			String mineralName, String month, String year) {
		JSONArray JsonArray = new JSONArray();
		JSONObject JsonObject = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int count = 0;
		ArrayList<Object> finlist = new ArrayList<Object>();
		ArrayList<ReportHelper> reportsList = new ArrayList<ReportHelper>();
		ArrayList<String> headersList = new ArrayList<String>();
		ReportHelper finalreporthelper = new ReportHelper();

		headersList.add("Sl No");
		headersList.add("Mine Code");
		headersList.add("TC Number");
		headersList.add("Male");
		headersList.add("Female");
		headersList.add("Wages(Rs)");

		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(IronMiningStatement.GET_EMPLOYMENT_DETAILS);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, custId);
			pstmt.setString(3, mineralName);
			pstmt.setString(4, workPlace);
			pstmt.setString(5, month);
			pstmt.setString(6, year);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				JsonObject = new JSONObject();
				ArrayList<Object> informationList = new ArrayList<Object>();
				ReportHelper reporthelper = new ReportHelper();
				count++;
				JsonObject.put("slnoIndex", count);
				informationList.add(count);

				JsonObject.put("MineCodeDataIndex", rs.getString("MINE_CODE"));
				informationList.add(rs.getString("MINE_CODE"));

				JsonObject.put("TcNumberDataIndex", rs.getString("TC_NO"));
				informationList.add(rs.getString("TC_NO"));

				if (labour.equals("Direct")) {
					JsonObject.put("MaleDataIndex", rs.getString("DIRECT_MALE"));
					informationList.add(rs.getString("DIRECT_MALE"));

					JsonObject.put("FemaleDataIndex", rs.getString("DIRECT_FEMALE"));
					informationList.add(rs.getString("DIRECT_FEMALE"));

					JsonObject.put("WagesDataIndex", rs.getString("WAGES_DIRECT"));
					informationList.add(rs.getString("WAGES_DIRECT"));

				} else if (labour.equals("Contract")) {
					JsonObject.put("MaleDataIndex", rs.getString("CONTRACT_MALE"));
					informationList.add(rs.getString("CONTRACT_MALE"));

					JsonObject.put("FemaleDataIndex", rs.getString("CONTRACT_FEMALE"));
					informationList.add(rs.getString("CONTRACT_FEMALE"));

					JsonObject.put("WagesDataIndex", rs.getString("WAGES_CONTRACT"));
					informationList.add(rs.getString("WAGES_CONTRACT"));
				}

				JsonArray.put(JsonObject);
				reporthelper.setInformationList(informationList);
				reportsList.add(reporthelper);
			}
			finlist.add(JsonArray);
			finalreporthelper.setReportsList(reportsList);
			finalreporthelper.setHeadersList(headersList);
			finlist.add(finalreporthelper);

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return finlist;
	}

	public ArrayList<Object> getMRFGradewiseDetails(int systemId, int custId, String month, String year,
			String mineralName, String grade) {

		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject = null;
		int count = 0;

		ArrayList<ReportHelper> reportsList = new ArrayList<ReportHelper>();
		ArrayList<String> headersList = new ArrayList<String>();
		ReportHelper finalreporthelper = new ReportHelper();
		ArrayList<Object> mrfGradefinlist = new ArrayList<Object>();

		try {

			headersList.add("SLNO");
			headersList.add("Mine Code");
			headersList.add("TC No");
			headersList.add("Opening Stock at Mine Head");
			headersList.add("Production");
			headersList.add("Dispatches from Mine Head");
			headersList.add("Closing Stock at Mine Head");
			headersList.add("Ex-mine Price");

			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(IronMiningStatement.GET_MRF_GRADEWISE_DETAILS);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, custId);
			pstmt.setString(3, year);
			pstmt.setString(4, month);
			pstmt.setString(5, mineralName);
			pstmt.setString(6, grade);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				count++;

				jsonObject = new JSONObject();
				ReportHelper reporthelper = new ReportHelper();
				ArrayList<Object> informationList = new ArrayList<Object>();

				informationList.add(count);
				jsonObject.put("SLNOIndex", count);

				informationList.add(rs.getString("MINE_CODE"));
				jsonObject.put("mineCodeIndex", rs.getString("MINE_CODE"));

				informationList.add(rs.getString("TC_NO"));
				jsonObject.put("TCNoIndex", rs.getString("TC_NO"));

				informationList.add(rs.getString("OPENING_STOCK"));
				jsonObject.put("openingStockIndex", rs.getString("OPENING_STOCK"));

				informationList.add(rs.getString("PRODUCTION"));
				jsonObject.put("productionIndex", rs.getString("PRODUCTION"));

				informationList.add(rs.getString("DESPATCHES"));
				jsonObject.put("dispatchesIndex", rs.getString("DESPATCHES"));

				informationList.add(rs.getString("CLOSING_STOCK"));
				jsonObject.put("closingStockIndex", rs.getString("CLOSING_STOCK"));

				informationList.add(rs.getString("EX_MINE_PRICE"));
				jsonObject.put("ExmineIndex", rs.getString("EX_MINE_PRICE"));

				jsonArray.put(jsonObject);
				reporthelper.setInformationList(informationList);
				reportsList.add(reporthelper);
			}
			mrfGradefinlist.add(jsonArray);
			finalreporthelper.setReportsList(reportsList);
			finalreporthelper.setHeadersList(headersList);
			mrfGradefinlist.add(finalreporthelper);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return mrfGradefinlist;
	}

	//-----------------------------------------Mining Details------------------------------------//
	@SuppressWarnings("unchecked")
	public ArrayList getMineDetails(int systemId, int customerId, int userId) {
		JSONArray JsonArray = new JSONArray();
		JSONObject JsonObject = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int slcount = 0;
		ArrayList aslist = new ArrayList();
		ArrayList<Object> finlist = new ArrayList<Object>();
		ArrayList<ReportHelper> reportsList = new ArrayList<ReportHelper>();
		ArrayList<String> headersList = new ArrayList<String>();
		ReportHelper finalreporthelper = new ReportHelper();
		DecimalFormat df = new DecimalFormat("##0.00");
		SimpleDateFormat diffddMMyyyyHHmmss = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
		headersList.add("Sl No");
		headersList.add("Mine Code");
		headersList.add("Mine Name");
		headersList.add("IBM Number");
		headersList.add("Organization Code");
		headersList.add("Organization Name");
		headersList.add("Financial Year");
		headersList.add("Carry Forwarded EC");
		headersList.add("EC Allocated");
		headersList.add("Enhanced EC");
		headersList.add("Total EC");
		headersList.add("Wallet Amount");
		headersList.add("Wallet Quantity");
		headersList.add("EC Balance");
		headersList.add("EC Used");
		headersList.add("Remarks");
		headersList.add("Inserted Time");
		headersList.add("Inserted By");
		headersList.add("Updated Time");
		headersList.add("Updated By");
		headersList.add("Org Id");
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(IronMiningStatement.GET_MINE_DETAILS);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, customerId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				JsonObject = new JSONObject();
				ArrayList<Object> informationList = new ArrayList<Object>();
				ReportHelper reporthelper = new ReportHelper();
				slcount++;
				JsonObject.put("slnoIndex", slcount);
				informationList.add(slcount);

				JsonObject.put("mineralCodeDataIndex", rs.getString("MINE_CODE"));
				informationList.add(rs.getString("MINE_CODE"));

				JsonObject.put("miningcompanyNameIndex", rs.getString("MINING_COMPANY"));
				informationList.add(rs.getString("MINING_COMPANY"));

				JsonObject.put("ibmNumberIndex", rs.getString("IBM_NUMBER"));
				informationList.add(rs.getString("IBM_NUMBER"));

				JsonObject.put("orgcodeDataIndex", rs.getString("ORGANIZATION_CODE"));
				informationList.add(rs.getString("ORGANIZATION_CODE"));

				JsonObject.put("orgNameDataIndex", rs.getString("ORGANIZATION_NAME"));
				informationList.add(rs.getString("ORGANIZATION_NAME"));

				JsonObject.put("finanYearInd", rs.getString("FINANCIAL_YEAR"));
				informationList.add(rs.getString("FINANCIAL_YEAR"));

				JsonObject.put("carryForwardedECInd", rs.getString("CARRY_FORWARDED_EC"));
				informationList.add(df.format(rs.getFloat("CARRY_FORWARDED_EC")));

				JsonObject.put("EcIndex", rs.getString("EC_LIMIT"));
				informationList.add(df.format(rs.getFloat("EC_LIMIT")));

				JsonObject.put("enhancedECInd", df.format(rs.getDouble("ENHANCED_EC")));
				informationList.add(df.format(rs.getDouble("ENHANCED_EC")));

				JsonObject.put("totalECInd", df.format(rs.getDouble("TOTAL_EC")));
				informationList.add(df.format(rs.getDouble("TOTAL_EC")));

				JsonObject.put("uniqueIdDataIndex", rs.getString("ID"));
				//informationList.add(rs.getString("ID"));

				JsonObject.put("walletAmountIndex", rs.getString("AMOUNT"));
				informationList.add(df.format(rs.getFloat("AMOUNT")));

				JsonObject.put("walletQuantityIndex", df.format(rs.getDouble("QUANTITY")));
				informationList.add(df.format(rs.getDouble("QUANTITY")));

				JsonObject.put("ecBalenceIndex", df.format(rs.getDouble("TOTAL_EC") - rs.getDouble("QUANTITY")));
				informationList.add(df.format(rs.getDouble("TOTAL_EC") - rs.getDouble("QUANTITY")));

				JsonObject.put("ecUsedIndex", df.format(rs.getDouble("QUANTITY")));
				informationList.add(df.format(rs.getDouble("QUANTITY")));

				JsonObject.put("remarksInd", rs.getString("REMARKS"));
				informationList.add(rs.getString("REMARKS"));

				if (rs.getTimestamp("INSERTED_DATETIME") == null) {
					JsonObject.put("insertedTimeInd", "");
					informationList.add("");
				} else {
					JsonObject.put("insertedTimeInd", rs.getTimestamp("INSERTED_DATETIME"));
					informationList.add(diffddMMyyyyHHmmss.format(rs.getTimestamp("INSERTED_DATETIME")));
				}

				JsonObject.put("insertedByInd", rs.getString("INSERTED_BY"));
				informationList.add(rs.getString("INSERTED_BY"));

				if (rs.getTimestamp("UPDATED_DATETIME") == null) {
					JsonObject.put("updatedTimeInd", "");
					informationList.add("");
				} else {
					JsonObject.put("updatedTimeInd", rs.getTimestamp("UPDATED_DATETIME"));
					informationList.add(diffddMMyyyyHHmmss.format(rs.getTimestamp("UPDATED_DATETIME")));
				}

				JsonObject.put("updatedByInd", rs.getString("UPDATED_BY"));
				informationList.add(rs.getString("UPDATED_BY"));

				JsonObject.put("orgIdDataIndex", rs.getString("ORG_ID"));
				informationList.add(rs.getString("ORG_ID"));

				JsonArray.put(JsonObject);
				reporthelper.setInformationList(informationList);
				reportsList.add(reporthelper);
			}
			finlist.add(JsonArray);
			finalreporthelper.setReportsList(reportsList);
			finalreporthelper.setHeadersList(headersList);
			finlist.add(finalreporthelper);

		} catch (Exception e) {
			e.printStackTrace();
		} finally {

			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return finlist;
	}

	public JSONArray getMaxCarryForwardedEC(int systemId, int custId, int orgId, String financialYear,
			String currFinancialYear) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		JSONArray jArry = new JSONArray();
		JSONObject jObj = new JSONObject();
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(IronMiningStatement.GET_MAX_CARRY_FORWARDED_EC_PER_ORG);
			pstmt.setInt(1, orgId);
			pstmt.setInt(2, custId);
			pstmt.setInt(3, systemId);
			pstmt.setString(4, financialYear);
			pstmt.setInt(5, orgId);
			pstmt.setInt(6, custId);
			pstmt.setInt(7, systemId);
			pstmt.setString(8, currFinancialYear);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				jObj.put("MAX_CARRYED_EC", rs.getDouble("EC_BALANCE") > 0 ? rs.getDouble("EC_BALANCE") : 0);
				jObj.put("ORG_ID", rs.getInt("ORG_ID"));
				jArry.put(jObj);
			} else {
				jObj.put("MAX_CARRYED_EC", 0);
				jObj.put("ORG_ID", orgId);
				jArry.put(jObj);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jArry;
	}

	public JSONArray getMaxCarryForwardedTC(int systemId, int custId, int mineId, String financialYear,
			String currFinancialYear) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		JSONArray jArry = new JSONArray();
		JSONObject jObj = new JSONObject();
		try {
			con = DBConnection.getConnectionToDB("AMS");

			pstmt = con.prepareStatement(IronMiningStatement.GET_MAX_CARRY_FORWARDED_TC_PER_ORG);
			pstmt.setInt(1, mineId);
			pstmt.setInt(2, custId);
			pstmt.setInt(3, systemId);
			pstmt.setString(4, financialYear);
			pstmt.setInt(5, mineId);
			pstmt.setInt(6, custId);
			pstmt.setInt(7, systemId);
			pstmt.setString(8, currFinancialYear);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				jObj.put("MAX_CARRYED_TC", rs.getDouble("CarryForward") > 0 ? rs.getDouble("CarryForward") : 0);
				jObj.put("MINE_ID", mineId);
				jArry.put(jObj);
			} else {
				jObj.put("MAX_CARRYED_TC", 0);
				jObj.put("MINE_ID", mineId);
				jArry.put(jObj);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jArry;
	}

	public String addMiningdetails(String Mineral_Code, String MiningName, int systemId, int customerId, String IBMno,
			double ecLimit, int userId, String orgcode, String orgname, String orgid, String financialYear,
			Double carryedEC, Double enhancedEC, String remarks) {

		Connection con = null;
		PreparedStatement pstmt = null;
		PreparedStatement pstmt1 = null;
		ResultSet rs = null;
		String message = "";

		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt1 = con.prepareStatement(IronMiningStatement.CHECK_MINE_CODE_ALREADY_EXIST);
			pstmt1.setString(1, Mineral_Code);
			pstmt1.setString(2, IBMno);
			pstmt1.setInt(3, systemId);
			pstmt1.setInt(4, customerId);
			rs = pstmt1.executeQuery();
			if (!rs.next()) {

				pstmt = con.prepareStatement(IronMiningStatement.INSERT_MINERALS_DETAILS);//,PreparedStatement.RETURN_GENERATED_KEYS
				pstmt.setString(1, Mineral_Code);
				pstmt.setString(2, MiningName);
				pstmt.setString(3, IBMno);
				pstmt.setDouble(4, ecLimit);
				pstmt.setInt(5, systemId);
				pstmt.setInt(6, customerId);
				pstmt.setInt(7, userId);
				pstmt.setString(8, orgcode);
				pstmt.setString(9, orgname);
				pstmt.setString(10, orgid);
				pstmt.setString(11, financialYear);
				pstmt.setDouble(12, carryedEC);
				pstmt.setDouble(13, enhancedEC);
				pstmt.setString(14, remarks);
				int inserted = pstmt.executeUpdate();
				if (inserted > 0) {
					message = "Saved Successfully";
				}
				/*	rs = pstmt.getGeneratedKeys();
					if (rs.next()) {
						int genKey=rs.getInt(1);
						System.out.println("id:"+genKey);
						pstmt=con.prepareStatement(IronMiningStatement.INSERT_MINE_MASTER_HISTORY_DETAILS);
						pstmt.setInt(1, genKey);
						pstmt.setDouble(2, carryedEC);
						pstmt.setDouble(3, ecLimit);
						pstmt.setDouble(4, enhancedEC);
						pstmt.setString(5, remarks);
						pstmt.setInt(6, systemId);
						pstmt.setInt(7, customerId);
						pstmt.setInt(8, userId);
						pstmt.setString(9, financialYear);
						int inserted = pstmt.executeUpdate();
						if(inserted > 0 && genKey>0) {
				   message = "Saved Successfully";
						}
				    }	*/
			} else {
				message = "Mine Code/IBM Number Already Exists";
			}
		} catch (Exception e) {
			System.out.println("error in:-save Mine details " + e.toString());
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(null, pstmt1, rs);
			DBConnection.releaseConnectionToDB(con, pstmt, null);
		}
		return message;

	}

	public String modifyMiningDetails(String Mineral_Code, String MiningName, int systemId, int custId, int id,
			String IBMno, double ecLimit, int userId, String orgcode, String orgname, String orgid, Double carryedEC,
			Double enhancedEC, String remarks, String financialYear) {
		Connection con = null;
		PreparedStatement pstmt1 = null;
		ResultSet rs = null;
		String message = "";
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt1 = con.prepareStatement(IronMiningStatement.CHECK_MINE_CODE_ALREADY_EXIST + " and ID!=? ");
			pstmt1.setString(1, Mineral_Code);
			pstmt1.setString(2, IBMno);
			pstmt1.setInt(3, systemId);
			pstmt1.setInt(4, custId);
			pstmt1.setInt(5, id);
			rs = pstmt1.executeQuery();
			if (rs.next()) {
				message = "Mine Code/IBM Number Already Exists";
			} else {
				pstmt1 = con.prepareStatement(IronMiningStatement.UPDATE_MINERALS_DETAILS);
				pstmt1.setString(1, Mineral_Code);
				pstmt1.setString(2, MiningName);
				pstmt1.setString(3, IBMno);
				pstmt1.setDouble(4, ecLimit);
				pstmt1.setInt(5, userId);
				pstmt1.setString(6, orgcode);
				pstmt1.setString(7, orgname);
				pstmt1.setInt(8, Integer.parseInt(orgid));
				pstmt1.setDouble(9, carryedEC);
				pstmt1.setDouble(10, enhancedEC);
				pstmt1.setString(11, remarks);
				pstmt1.setInt(12, id);
				int updated = pstmt1.executeUpdate();
				if (updated > 0) {
					message = "Updated Successfully";
				}
				/*	if (updated > 0) {
						pstmt1=con.prepareStatement(IronMiningStatement.INSERT_MINE_MASTER_HISTORY_DETAILS);
						pstmt1.setInt(1, id);
						pstmt1.setDouble(2, carryedEC);
						pstmt1.setDouble(3, ecLimit);
						pstmt1.setDouble(4, enhancedEC);
						pstmt1.setString(5, remarks);
						pstmt1.setInt(6, systemId);
						pstmt1.setInt(7, custId);
						pstmt1.setInt(8, userId);
						pstmt1.setString(9, financialYear);
						int inserted = pstmt1.executeUpdate();
						if(inserted > 0) {
				       message = "Updated Successfully";
						}
					}	*/
			}

		} catch (Exception e) {
			System.out.println("error in :-update Mine details " + e.toString());
			e.printStackTrace();
		}

		finally {
			DBConnection.releaseConnectionToDB(con, pstmt1, rs);
		}
		return message;
	}

	public ArrayList<Object> getGridData(int systemId, int custId, int Userid, String type, int id) {

		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		PreparedStatement pstmt1 = null;
		ResultSet rs1 = null;
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject = null;
		int count = 0;
		int count1 = 0;
		double payable = 0;
		double qty = 0;
		double rate = 0;
		double giopfRate = 0;
		double giopfQty = 0;
		ArrayList<Object> finlist = new ArrayList<Object>();
		DecimalFormat df = new DecimalFormat("0.00");
		try {
			con = DBConnection.getConnectionToDB("AMS");

			if (id != 0) {
				pstmt = con.prepareStatement(IronMiningStatement.GET_CHALLAN_GRADE_DEATILS);
				pstmt.setInt(1, id);
				pstmt.setInt(2, id);
				pstmt.setInt(3, id);
				pstmt.setInt(4, id);
				rs = pstmt.executeQuery();
				while (rs.next()) {
					count++;
					rate = (rs.getDouble("PROCESSING_FEE"));
					giopfRate = (rs.getDouble("GIOPF_RATE"));
					giopfQty = (rs.getDouble("GIOPF_QTY"));
					jsonObject = new JSONObject();
					jsonObject.put("SLNOIndex", count);
					jsonObject.put("uniqueIdIndex", rs.getInt("ID"));
					jsonObject.put("gradeIdIndex", rs.getString("GRADE"));
					jsonObject.put("rateIdIndex", df.format((rs.getDouble("RATE"))));
					jsonObject.put("qtyIdIndex", df.format(rs.getDouble("QUANTITY")));
					qty = qty + rs.getDouble("QUANTITY");
					payable = payable + Math.round(rs.getDouble("PAYABLE"));
					jsonObject.put("payableIdIndex", df.format(Math.round(rs.getDouble("PAYABLE"))));
					jsonArray.put(jsonObject);
					count1 = count;
				}
				jsonObject = new JSONObject();
				count1++;
				jsonObject.put("gradeIdIndex", "Royalty");
				jsonObject.put("rateIdIndex", "");
				jsonObject.put("qtyIdIndex", df.format(qty));
				jsonObject.put("payableIdIndex", df.format(payable));
				jsonObject.put("gridStatusDataIndex", "L1");
				jsonArray.put(jsonObject);

				jsonObject = new JSONObject();
				jsonObject.put("gradeIdIndex", "DMF 30% (Automatically calculate on total)");
				jsonObject.put("rateIdIndex", "");
				jsonObject.put("qtyIdIndex", "");
				jsonObject.put("payableIdIndex", df.format(Math.round(payable * 0.3)));
				jsonObject.put("gridStatusDataIndex", "L2");
				jsonArray.put(jsonObject);

				jsonObject = new JSONObject();
				jsonObject.put("gradeIdIndex", "NMET 2%(Automatically calculate on total)");
				jsonObject.put("rateIdIndex", "");
				jsonObject.put("qtyIdIndex", "");
				jsonObject.put("payableIdIndex", df.format(Math.round(payable * 0.02)));
				jsonObject.put("gridStatusDataIndex", "L3");
				jsonArray.put(jsonObject);

				jsonObject = new JSONObject();
				jsonObject.put("SLNOIndex", 2);
				jsonObject.put("gradeIdIndex", "GIOPF 10%");
				jsonObject.put("rateIdIndex", giopfRate);
				jsonObject.put("qtyIdIndex", giopfQty);
				jsonObject.put("payableIdIndex", df.format(giopfRate * giopfQty));
				jsonObject.put("gridStatusDataIndex", "L4");
				jsonArray.put(jsonObject);

				jsonObject = new JSONObject();
				jsonObject.put("gradeIdIndex", "Total Challan Amount");
				jsonObject.put("rateIdIndex", "");
				jsonObject.put("qtyIdIndex", "");
				jsonObject.put("payableIdIndex",
						df.format(Math.round(payable + (payable * 0.3) + (payable * 0.02) + (giopfRate * giopfQty))));
				jsonObject.put("gridStatusDataIndex", "L5");
			} else {
				jsonObject = new JSONObject();
				jsonObject.put("SLNOIndex", "new1");
				jsonObject.put("gradeIdIndex", "");
				jsonObject.put("rateIdIndex", "");
				jsonObject.put("qtyIdIndex", "");
				jsonObject.put("payableIdIndex", "");
				jsonObject.put("gridStatusDataIndex", "");
				jsonArray.put(jsonObject);

				jsonObject = new JSONObject();
				jsonObject.put("SLNOIndex", "");
				jsonObject.put("gradeIdIndex", "Royalty");
				jsonObject.put("rateIdIndex", "");
				jsonObject.put("qtyIdIndex", "");
				jsonObject.put("payableIdIndex", "");
				jsonObject.put("gridStatusDataIndex", "L1");
				jsonArray.put(jsonObject);

				jsonObject = new JSONObject();
				jsonObject.put("SLNOIndex", "");
				jsonObject.put("gradeIdIndex", "DMF 30% (Automatically calculate on total)");
				jsonObject.put("rateIdIndex", "");
				jsonObject.put("qtyIdIndex", "");
				jsonObject.put("payableIdIndex", "");
				jsonObject.put("gridStatusDataIndex", "L2");
				jsonArray.put(jsonObject);

				jsonObject = new JSONObject();
				jsonObject.put("SLNOIndex", "");
				jsonObject.put("gradeIdIndex", "NMET 2%(Automatically calculate on total)");
				jsonObject.put("rateIdIndex", "");
				jsonObject.put("qtyIdIndex", "");
				jsonObject.put("payableIdIndex", "");
				jsonObject.put("gridStatusDataIndex", "L3");
				jsonArray.put(jsonObject);

				jsonObject = new JSONObject();
				jsonObject.put("SLNOIndex", "new2");
				jsonObject.put("gradeIdIndex", "GIOPF 10%");
				jsonObject.put("rateIdIndex", "");
				jsonObject.put("qtyIdIndex", "");
				jsonObject.put("payableIdIndex", "");
				jsonObject.put("gridStatusDataIndex", "L4");
				jsonArray.put(jsonObject);

				jsonObject = new JSONObject();
				jsonObject.put("SLNOIndex", "");
				jsonObject.put("gradeIdIndex", "Total Challan Amount");
				jsonObject.put("rateIdIndex", "");
				jsonObject.put("qtyIdIndex", "");
				jsonObject.put("payableIdIndex", "");
				jsonObject.put("gridStatusDataIndex", "L5");
			}
			jsonArray.put(jsonObject);
			finlist.add(jsonArray);

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(null, pstmt1, rs1);
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return finlist;
	}

	public synchronized String updateFinalSubmit(String status, int custId, int sysId, int uniqueId, String ewalletId,
			String ewalletUsed, String challanType, String totalQuantity, float ewalletAmount, float payableAmount,
			float ewalletPayable, int tcNo, float eWalletBalance, int orgId, Float mWallet) {
		String message = "";
		Connection conAdmin = null;
		PreparedStatement pstmt = null;
		PreparedStatement pstmt1 = null;
		PreparedStatement pstmt2 = null;
		ResultSet rs1 = null;
		ResultSet rs2 = null;
		int updated = 0;
		float amountPayable = 0;
		float challanUsedQty = 0;
		float challanUsedamt = 0;
		float challantotalamt = 0;
		float challantotalQty = 0;
		float totalPayable = 0;
		float totalPayableRom = 0;
		boolean statusUpdate = true;
		float Tcewalletamount = 0;
		try {
			conAdmin = DBConnection.getConnectionToDB("AMS");
			float ecAllocated = 0;
			float mplUsed = 0;
			String walletLinked = "";
			String processingPlant = "";
			float mplBalance = 0;
			pstmt = conAdmin.prepareStatement(IronMiningStatement.GET_MPL_BALANCE);
			pstmt.setInt(1, tcNo);//change to total production
			rs2 = pstmt.executeQuery();
			if (rs2.next()) {
				ecAllocated = rs2.getFloat("TOTAL_EC_LIMIT");
				mplUsed = rs2.getFloat("EC_USED");
				walletLinked = rs2.getString("WALLET_LINK");
				processingPlant = rs2.getString("PROCESSING_PLANT");
				mplBalance = ecAllocated - mplUsed;
				Tcewalletamount = rs2.getFloat("AMOUNT");
			}
			if (challanType.equalsIgnoreCase("ROM")) {
				pstmt1 = conAdmin.prepareStatement(IronMiningStatement.GET_TOTAL_USED_FOR_CHALLAN);
				pstmt1.setInt(1, Integer.parseInt(ewalletId));
				rs1 = pstmt1.executeQuery();
				if (rs1.next()) {
					challantotalamt = rs1.getFloat("TOTAL_AMOUNT");
					challantotalQty = rs1.getFloat("TOTAL_QUANTITY");
					challanUsedQty = rs1.getFloat("USED_QTY");
					challanUsedamt = rs1.getFloat("USED_AMOUNT");
					totalPayableRom = (challantotalamt - challanUsedamt);
				}
				if ((challantotalQty - challanUsedQty) >= Float.parseFloat(totalQuantity)) {
					if (totalPayableRom < ewalletPayable) {
						amountPayable = totalPayableRom;
					} else {
						amountPayable = ewalletPayable;
					}
					pstmt2 = conAdmin.prepareStatement(IronMiningStatement.UPDATE_USED_QTY_FOR_E_WALLET);
					pstmt2.setFloat(1, challanUsedQty + Float.parseFloat(totalQuantity));
					pstmt2.setFloat(2, challanUsedamt + amountPayable);
					pstmt2.setInt(3, Integer.parseInt(ewalletId));
					pstmt2.executeUpdate();
					if (totalPayableRom <= ewalletPayable) {
						totalPayableRom = ewalletPayable - totalPayableRom;
					} else {
						totalPayableRom = 0;
					}
					if (ewalletUsed.equalsIgnoreCase("Yes")) {
						if (totalPayableRom != 0) {
							if (eWalletBalance <= totalPayableRom) {
								totalPayable = 0;
							} else {
								totalPayable = eWalletBalance - totalPayableRom;
							}
							pstmt = conAdmin.prepareStatement(IronMiningStatement.UPDATE_E_WALLET_FOR_ROM);
							pstmt.setFloat(1, totalPayable);
							pstmt.setInt(2, tcNo);
							pstmt.executeUpdate();
						}
					}
					statusUpdate = true;
				} else {
					statusUpdate = false;
					message = "Quantity is not Available for this e-Wallet Challan.Please reduce the quantity or delete the challan.";
				}
			}
			if (challanType.equalsIgnoreCase("E-Wallet Challan")) {
				if (Float.parseFloat(totalQuantity) > mplBalance) {
					statusUpdate = false;
					message = "MPL balance is over";
				} else {
					pstmt = conAdmin.prepareStatement(
							"update AMS.dbo.MINING_TC_MASTER set MPL_BALANCE=MPL_BALANCE+(select QUANTITY from AMS.dbo.MINING_CHALLAN_DETAILS where ID=?) where "
									+ " ID in (select TC_NO from AMS.dbo.MINING_CHALLAN_DETAILS where ID=?) ");
					pstmt.setInt(1, uniqueId);
					pstmt.setInt(2, uniqueId);
					updated = pstmt.executeUpdate();
					statusUpdate = true;
					if (ewalletUsed.equalsIgnoreCase("Yes")) {

						float updateAmt = 0;
						float totalpayableeU = 0;
						if (Tcewalletamount < ewalletPayable) {
							updateAmt = Tcewalletamount;
							totalpayableeU = ewalletPayable - Tcewalletamount;
						} else {
							updateAmt = ewalletPayable;
							totalpayableeU = 0;
						}
						pstmt = conAdmin.prepareStatement(IronMiningStatement.UPDATE_E_WALLET_FOR_ROM);
						pstmt.setFloat(1, updateAmt);
						pstmt.setInt(2, tcNo);
						pstmt.executeUpdate();

						pstmt = conAdmin.prepareStatement(IronMiningStatement.UPDATE_TOTAL_PAYABLE);
						pstmt.setFloat(1, totalpayableeU);
						pstmt.setInt(2, uniqueId);
						pstmt.executeUpdate();

						statusUpdate = true;
					}
				}
			}
			if (challanType.equalsIgnoreCase("Processed Ore")) {
				if (Float.parseFloat(totalQuantity) > mplBalance) {
					statusUpdate = false;
					message = "MPL balance is over";
				} else {
					pstmt = conAdmin.prepareStatement(
							"update AMS.dbo.MINING_TC_MASTER set MPL_BALANCE=MPL_BALANCE+(select QUANTITY from AMS.dbo.MINING_CHALLAN_DETAILS where ID=?) where "
									+ " ID in (select TC_NO from AMS.dbo.MINING_CHALLAN_DETAILS where ID=?) ");
					pstmt.setInt(1, uniqueId);
					pstmt.setInt(2, uniqueId);
					updated = pstmt.executeUpdate();
					statusUpdate = true;
				}
			}
			if (challanType.equalsIgnoreCase("Bauxite Challan")) {
				if (walletLinked.equalsIgnoreCase("BAUXITE") && Float.parseFloat(totalQuantity) > mplBalance) {
					statusUpdate = false;
					message = "MPL balance is over";
				} else {
					pstmt = conAdmin.prepareStatement(
							"update AMS.dbo.MINING_TC_MASTER set MPL_BALANCE=MPL_BALANCE+(select QUANTITY from AMS.dbo.CHALLAN_GRADE_DETAILS where CHALLAN_ID=? and GRADE='QUANTITY') where "
									+ " ID in (select TC_NO from AMS.dbo.MINING_CHALLAN_DETAILS where ID=?) and upper(WALLET_LINK)='BAUXITE' ");
					pstmt.setInt(1, uniqueId);
					pstmt.setInt(2, uniqueId);
					updated = pstmt.executeUpdate();
					statusUpdate = true;
				}
			}
			if (statusUpdate) {
				pstmt = conAdmin.prepareStatement(IronMiningStatement.UPDATE_STATUS_FOR_FINAL_SUBMIT);
				pstmt.setInt(1, sysId);
				pstmt.setInt(2, custId);
				pstmt.setInt(3, uniqueId);
				updated = pstmt.executeUpdate();
				if (updated > 0) {
					message = "Successfully Submitted";
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
			System.out.println("Inside acknoledgement function" + e.toString());
		} finally {
			DBConnection.releaseConnectionToDB(null, pstmt1, rs1);
			DBConnection.releaseConnectionToDB(null, pstmt2, null);
			DBConnection.releaseConnectionToDB(conAdmin, pstmt, null);
		}
		return message;
	}

	public JSONArray getHubForTcMaster(int cutomerId, int systemId, String zone) {

		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			con = DBConnection.getConnectionToDB("AMS");
			jsonArray = new JSONArray();
			jsonObject = new JSONObject();
			pstmt = con
					.prepareStatement(cf.getLocationQuery(IronMiningStatement.GET_ASSOCIATED_HUBS_FOR_TC_MASTER, zone));

			pstmt.setInt(1, systemId);
			pstmt.setInt(2, cutomerId);

			rs = pstmt.executeQuery();
			while (rs.next()) {
				jsonObject = new JSONObject();
				jsonObject.put("hubName", rs.getString("NAME"));
				jsonObject.put("hubId", rs.getString("HUBID"));
				jsonArray.put(jsonObject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jsonArray;

	}

	public JSONArray getMineCodeForTcMaster(int systemId, int cutomerId) {

		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			con = DBConnection.getConnectionToDB("AMS");
			jsonArray = new JSONArray();
			jsonObject = new JSONObject();
			pstmt = con.prepareStatement(IronMiningStatement.GET_MINE_CODE_DETAILS);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, cutomerId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				jsonObject = new JSONObject();
				jsonObject.put("mineName", rs.getString("MINE_CODE"));
				jsonObject.put("mineId", rs.getString("MINE_ID"));
				jsonObject.put("miningname", rs.getString("MINE_NAME"));
				jsonObject.put("ecLimit", rs.getString("TOTAL_EC"));
				jsonObject.put("ecCapLimit", rs.getString("EC_CAPPING_LIMIT"));
				jsonObject.put("nameOfLesse", rs.getString("ORGANIZATION_NAME"));
				jsonArray.put(jsonObject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jsonArray;

	}

	public JSONArray getOrgcode(int systemId, int cutomerId) {

		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			con = DBConnection.getConnectionToDB("AMS");
			jsonArray = new JSONArray();
			jsonObject = new JSONObject();
			pstmt = con.prepareStatement(IronMiningStatement.GET_ORG_CODE_DETAILS);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, cutomerId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				jsonObject = new JSONObject();
				jsonObject.put("ID", rs.getString("ID"));
				jsonObject.put("orgcode", rs.getString("ORGANIZATION_CODE"));
				jsonObject.put("orgName", rs.getString("ORGANIZATION_NAME"));
				jsonArray.put(jsonObject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jsonArray;

	}

	//********************************functions for User Settings***************************************//
	public JSONArray getTCNoForUserSetting(int customerId, int systemId, int userId) {
		JSONArray JsonArray = null;
		JSONObject JsonObject = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			JsonArray = new JSONArray();
			JsonObject = new JSONObject();
			JsonObject.put("TCno", "NA");
			JsonObject.put("TCID", 0);
			JsonArray.put(JsonObject);
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(IronMiningStatement.GET_TC_NO_FOR_USER_SETTING);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, customerId);
			pstmt.setInt(3, userId);
			pstmt.setInt(4, systemId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				JsonObject = new JSONObject();
				JsonObject.put("TCno", rs.getString("TC_NO"));
				JsonObject.put("TCID", rs.getInt("ID"));
				JsonArray.put(JsonObject);
			}

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return JsonArray;
	}

	public JSONArray getPermitNo(int customerId, String tcid, int systemId, String orgCode) {
		JSONArray JsonArray = null;
		JSONObject JsonObject = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			JsonArray = new JSONArray();
			con = DBConnection.getConnectionToDB("AMS");
			if (!tcid.equals("") && tcid != null && !tcid.equals("0")) {
				pstmt = con.prepareStatement(IronMiningStatement.GET_PERMIT_NO_FOR_USER_SETTING);
				pstmt.setInt(1, systemId);
				pstmt.setInt(2, customerId);
				pstmt.setInt(3, Integer.parseInt(tcid));
				rs = pstmt.executeQuery();
				while (rs.next()) {
					JsonObject = new JSONObject();
					JsonObject.put("PermitNo", rs.getString("PERMIT_NO"));
					JsonObject.put("ID", rs.getInt("ID"));
					JsonArray.put(JsonObject);
				}
			}
			if (!orgCode.equals("") && orgCode != null && !orgCode.equals("0")) {
				pstmt = con.prepareStatement(IronMiningStatement.GET_PERMIT_NO_BASED_ON_ORGCODE);
				pstmt.setInt(1, systemId);
				pstmt.setInt(2, customerId);
				pstmt.setInt(3, Integer.parseInt(orgCode));
				rs = pstmt.executeQuery();
				while (rs.next()) {
					JsonObject = new JSONObject();
					JsonObject.put("PermitNo", rs.getString("PERMIT_NO"));
					JsonObject.put("ID", rs.getInt("ID"));
					JsonArray.put(JsonObject);
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return JsonArray;
	}

	public JSONArray getSourcehub(int customerId, int systemId) {
		JSONArray JsonArray = null;
		JSONObject JsonObject = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			JsonArray = new JSONArray();
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(IronMiningStatement.GET_HUB_FOR_USER_SETTING);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, customerId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				JsonObject = new JSONObject();
				JsonObject.put("Hubname", rs.getString("NAME"));
				JsonObject.put("HubID", rs.getInt("HUBID"));
				JsonArray.put(JsonObject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return JsonArray;
	}

	public String addUserSetting(int customerId, int systemId, int userId, int TCNO, String permitno, String sourcehub,
			String destinationhub, String type, int userName, int orgCode, String closingType) {

		Connection con = null;
		PreparedStatement pstmt = null;
		PreparedStatement pstmt1 = null;
		ResultSet rs = null;
		String message = "";
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(IronMiningStatement.INSERT_USER_SETTING_DETAILS);
			pstmt.setInt(1, TCNO);
			pstmt.setString(2, permitno);
			pstmt.setString(3, sourcehub);
			pstmt.setString(4, destinationhub);
			pstmt.setString(5, type);
			pstmt.setInt(6, systemId);
			pstmt.setInt(7, customerId);
			pstmt.setInt(8, userId);
			pstmt.setInt(9, userName);
			pstmt.setInt(10, orgCode);
			pstmt.setInt(11, 0);
			pstmt.setString(12, closingType);
			int inserted = pstmt.executeUpdate();
			if (inserted > 0) {
				message = "Saved Successfully";
			}
		} catch (Exception e) {
			System.out.println("error in:-save Mine details " + e.toString());
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(null, pstmt1, rs);
			DBConnection.releaseConnectionToDB(con, pstmt, null);
		}
		return message;

	}

	@SuppressWarnings("unchecked")
	public ArrayList getUserSettingDetails(int systemId, int customerId, int userId) {
		JSONArray JsonArray = new JSONArray();
		JSONObject JsonObject = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		SimpleDateFormat diffddMMyyyyHHmmss = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
		int slcount = 0;
		ArrayList aslist = new ArrayList();
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(IronMiningStatement.GET_USER_SETTING_DETAILS);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, customerId);
			pstmt.setInt(3, userId);
			pstmt.setInt(4, systemId);
			pstmt.setInt(5, userId);
			pstmt.setInt(6, systemId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				JsonObject = new JSONObject();
				slcount++;
				JsonObject.put("slnoIndex", slcount);

				JsonObject.put("tcNoDataIndex", rs.getString("TC_NO"));

				//		JsonObject.put("permitNoDataIndex", rs.getString("PERMIT_NO"));

				JsonObject.put("sourceHubDataIndex", rs.getString("SOURCE_NAME"));

				JsonObject.put("destinationHubDataIndex", rs.getString("DESTINATION_NAME"));

				JsonObject.put("typeDataIndex", rs.getString("TYPE"));

				if (rs.getTimestamp("INSERTED_DATETIME") == null || rs.getString("INSERTED_DATETIME").equals("")
						|| rs.getString("INSERTED_DATETIME").contains("1900")) {
					JsonObject.put("insertedtimeDataIndex", "");
				} else {
					JsonObject.put("insertedtimeDataIndex",
							diffddMMyyyyHHmmss.format(rs.getTimestamp("INSERTED_DATETIME")));
				}
				JsonObject.put("closingTypeDataIndex", rs.getString("CLOSING_TYPE"));
				JsonObject.put("orgCodeDataIndex", rs.getString("ORGANISATION_CODE"));
				JsonObject.put("userNameDataIndex", rs.getString("USER_NAME"));

				JsonArray.put(JsonObject);
			}
			aslist.add(JsonArray);

		} catch (Exception e) {
			e.printStackTrace();
		} finally {

			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return aslist;
	}
	//**************************************function for PermitDetails****************

	public JSONArray getRefNumber(int customerId, int systemId, int tcid) {
		JSONArray JsonArray = null;
		JSONObject JsonObject = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			JsonArray = new JSONArray();
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(IronMiningStatement.GET_REFERENCE_NUMBER);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, customerId);
			pstmt.setInt(3, tcid);
			pstmt.setInt(4, systemId);
			pstmt.setInt(5, customerId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				JsonObject = new JSONObject();
				JsonObject.put("ChallanNo", rs.getString("CHALLAN_NO"));
				JsonObject.put("ChallanID", rs.getString("ID"));
				JsonArray.put(JsonObject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return JsonArray;
	}

	public JSONArray getChallanGradeDetails(int challanid, int permitId, String permitType, String buttinValue,
			int systemId, int custId) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		PreparedStatement pstmt1 = null;
		ResultSet rs1 = null;
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject = null;
		float rate = 0;
		float giopfRate = 0;
		float giopfQty = 0;
		DecimalFormat df = new DecimalFormat("0.00");
		float pf = 0;
		float pfRate = 0;
		String mineraltype = "";
		try {
			double qty = 0;
			double paybale = 0;
			con = DBConnection.getConnectionToDB("AMS");
			if (permitType.equalsIgnoreCase("Purchased Rom Sale Transit Permit") && buttinValue.equals("Modify")) {
				pstmt = con.prepareStatement(IronMiningStatement.GET_GRADE_DETAILS_FOR_MODIFY);
				pstmt.setInt(1, permitId);
				pstmt.setInt(2, permitId);
				rs = pstmt.executeQuery();
			} else {
				pstmt = con.prepareStatement(IronMiningStatement.GET_GRADE_DETAILS_FOR_CHALLAN);
				pstmt.setInt(1, permitId);
				pstmt.setInt(2, challanid);
				rs = pstmt.executeQuery();
			}
			while (rs.next()) {
				jsonObject = new JSONObject();
				jsonObject.put("SLNOIndex", 1);
				jsonObject.put("gradeIdIndex", rs.getString("GRADE"));
				jsonObject.put("rateIdIndex", rs.getDouble("RATE"));
				jsonObject.put("qtyIdIndex", df.format((rs.getDouble("QUANTITY"))));
				jsonObject.put("payableIdIndex", df.format(Math.round(rs.getDouble("PAYABLE"))));
				qty = qty + (rs.getDouble("QUANTITY"));
				paybale = paybale + Math.round(rs.getDouble("PAYABLE"));
				rate = rs.getFloat("PROCESSING_FEE");
				giopfRate = rs.getFloat("GIOPF_RATE");
				giopfQty = rs.getFloat("GIOPF_QTY");
				mineraltype = rs.getString("MINERAL_TYPE");
				jsonArray.put(jsonObject);
			}
			if (buttinValue.equals("add")) {
				pstmt1 = con.prepareStatement(IronMiningStatement.GET_PROCESSING_FEE_FROM_PF_MASTER);
				pstmt1.setInt(1, systemId);
				pstmt1.setInt(2, custId);
				pstmt1.setString(3, permitType);
				pstmt1.setString(4, mineraltype);
				rs1 = pstmt1.executeQuery();
				while (rs1.next()) {
					pf = rs1.getFloat("PROCESSING_FEE");
				}
				pfRate = pf;
			} else {
				pfRate = rate;
			}
			double dmf = ((paybale * 30) / 100);
			double nmet = ((paybale * 2) / 100);
			double processingfee = (pfRate * qty);
			double giopfPayable = giopfRate * giopfQty;
			double total = paybale + dmf + nmet + processingfee + giopfPayable;
			jsonObject = new JSONObject();
			jsonObject.put("SLNOIndex", 2);
			jsonObject.put("gradeIdIndex", "ROYALTY PAID ROM");
			jsonObject.put("rateIdIndex", "");
			jsonObject.put("qtyIdIndex", "");
			jsonObject.put("payableIdIndex", df.format(Math.round(paybale)));

			jsonArray.put(jsonObject);
			jsonObject = new JSONObject();
			jsonObject.put("SLNOIndex", 3);
			jsonObject.put("gradeIdIndex", "DMF 30% (Automatically calculate on total)");
			jsonObject.put("rateIdIndex", "");
			jsonObject.put("qtyIdIndex", "");
			jsonObject.put("payableIdIndex", df.format(Math.round(dmf)));

			jsonArray.put(jsonObject);
			jsonObject = new JSONObject();
			jsonObject.put("SLNOIndex", 4);
			jsonObject.put("gradeIdIndex", "NMET 2%(Automatically calculate on total)");
			jsonObject.put("rateIdIndex", "");
			jsonObject.put("qtyIdIndex", "");
			jsonObject.put("payableIdIndex", df.format(Math.round(nmet)));

			jsonArray.put(jsonObject);
			jsonObject = new JSONObject();
			jsonObject.put("SLNOIndex", 5);
			jsonObject.put("gradeIdIndex", "GIOPF 10%");
			jsonObject.put("rateIdIndex", df.format(giopfRate));
			jsonObject.put("qtyIdIndex", df.format(giopfQty));
			jsonObject.put("payableIdIndex", df.format(Math.round(giopfPayable)));

			jsonArray.put(jsonObject);
			jsonObject = new JSONObject();
			jsonObject.put("SLNOIndex", 6);
			jsonObject.put("gradeIdIndex", "PROCESS FEE(Automatic based on total ton)");
			jsonObject.put("rateIdIndex", df.format(pfRate));
			jsonObject.put("qtyIdIndex", df.format(qty));
			jsonObject.put("payableIdIndex", df.format(Math.round(processingfee)));
			jsonArray.put(jsonObject);

			jsonObject = new JSONObject();
			jsonObject.put("SLNOIndex", 7);
			jsonObject.put("gradeIdIndex", "Total");
			jsonObject.put("rateIdIndex", "");
			jsonObject.put("qtyIdIndex", "");
			jsonObject.put("payableIdIndex", df.format(Math.round(total)));

			jsonArray.put(jsonObject);

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jsonArray;
	}

	public JSONArray getDetailsForExport(int orgCode, int custId, int systemId, String mineralType, int routeId,
			String permitType) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject = null;
		DecimalFormat df = new DecimalFormat("0.00");
		String totalfines = "0";
		String totallumps = "0";
		String totalTailings = "0";
		String totalUfo = "0";
		String totalRejects = "0";
		String totalConcentrates = "0";
		double totalQty = 0;
		int hubId = 0;
		int Shub = 0;
		try {
			con = DBConnection.getConnectionToDB("AMS");
			if (mineralType.equals("Bauxite/Laterite")) {
				pstmt = con.prepareStatement(IronMiningStatement.GET_EXPORT_DETAILS_FOR_BAUXITE);
				pstmt.setInt(1, systemId);
				pstmt.setInt(2, custId);
				pstmt.setInt(3, orgCode);
			} else if (permitType.equals("Rom Transit") || permitType.equals("Rom Sale")) {
				pstmt = con.prepareStatement(IronMiningStatement.GET_DESTINATION_FROM_ROUTE);
				pstmt.setInt(1, systemId);
				pstmt.setInt(2, custId);
				pstmt.setInt(3, routeId);
				rs = pstmt.executeQuery();
				if (rs.next()) {
					hubId = rs.getInt("Start_Hubid");
				}
				if (permitType.equals("Rom Sale")) {
					Shub = routeId;
				} else {
					Shub = hubId;
				}
				pstmt = con.prepareStatement(IronMiningStatement.GET_EXPORT_DETAILS_FOR_RTP);
				pstmt.setInt(1, systemId);
				pstmt.setInt(2, custId);
				pstmt.setInt(3, orgCode);
				pstmt.setString(4, mineralType);
				pstmt.setInt(5, Shub);
			} else {
				pstmt = con.prepareStatement(IronMiningStatement.GET_DESTINATION_FROM_ROUTE);
				pstmt.setInt(1, systemId);
				pstmt.setInt(2, custId);
				pstmt.setInt(3, routeId);
				rs = pstmt.executeQuery();
				if (rs.next()) {
					hubId = rs.getInt("Start_Hubid");
				}
				if (permitType.equals("Processed Ore Sale") || permitType.equals("Rom Sale")) {
					Shub = routeId;
				} else {
					Shub = hubId;
				}
				pstmt = con.prepareStatement(IronMiningStatement.GET_EXPORT_DETAILS);
				pstmt.setInt(1, systemId);
				pstmt.setInt(2, custId);
				pstmt.setInt(3, orgCode);
				pstmt.setString(4, mineralType);
				pstmt.setInt(5, Shub);
				pstmt.setInt(6, systemId);
				pstmt.setInt(7, custId);
				pstmt.setInt(8, orgCode);
				pstmt.setInt(9, Shub);
				pstmt.setString(10, mineralType);
			}
			rs = pstmt.executeQuery();
			while (rs.next()) {
				jsonObject = new JSONObject();
				jsonObject.put("stockLocIndex", rs.getString("NAME"));
				jsonObject.put("stockTypeIndex", rs.getString("STOCK_TYPE"));
				jsonObject.put("totalLumpsIndex", df.format((rs.getDouble("TOTAL_LUMPS"))));
				jsonObject.put("totalFinesIndex", df.format((rs.getDouble("TOTAL_FINES"))));
				jsonObject.put("totalConcentratesIndex", df.format((rs.getDouble("TOTAL_CONC"))));
				jsonObject.put("totalTailingsIndex", df.format((rs.getDouble("TAILINGS"))));
				jsonObject.put("totalRejectsIndex", df.format((rs.getDouble("REJECTS"))));
				jsonObject.put("totalufoIndex", df.format((rs.getDouble("TOTAL_UFO"))));
				jsonObject.put("romQtyIndex", df.format((rs.getDouble("ROM_QTY"))));
				if (rs.getString("STOCK_TYPE").equalsIgnoreCase("PLANT")) {
					totallumps = df.format(rs.getDouble("TOTAL_LUMPS"));
					totalfines = df.format(rs.getDouble("TOTAL_FINES"));
					totalConcentrates = df.format(rs.getDouble("TOTAL_CONC"));
					totalRejects = df.format(rs.getDouble("REJECTS"));
					totalTailings = df.format(rs.getDouble("TAILINGS"));
					totalUfo = df.format(rs.getDouble("TOTAL_UFO"));
					totalQty = Double.parseDouble(totallumps) + Double.parseDouble(totalfines)
							+ Double.parseDouble(totalRejects) + Double.parseDouble(totalTailings)
							+ Double.parseDouble(totalUfo) + Double.parseDouble(totalConcentrates);
					jsonObject.put("totalQtyIndex", df.format((totalQty)));
				} else {
					jsonObject.put("totalQtyIndex", df.format((rs.getDouble("TOTAL_QUANTITY"))));
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

	//*****************************permit details**************
	public String addPermitdetails(int customerId, int systemId, String mineral, int tcid, String date, String remarks,
			String startdate, String enddate, int routeid, int challanid, int userId, String permittype,
			String CustName, String permitReq, String ownerType, String finYr, String appNo, JSONArray js, int orgCode,
			String buyer, String ship, int country, int state, int buyingOrgId, String ImporteiPermitId,
			float permitQuantity, String stockName, String importType, String importPurpose, String vesselName,
			String exportPermitNo, String exportPermitDate, String exportChallanNo, String exportChallanDate,
			String saleInvoiceNo, String saleInvoiceDate, String transportnType, int hubId, int TcorgId,
			String toLocations, String srcType)

	{

		Connection con = null;
		PreparedStatement pstmt = null;
		PreparedStatement pstmt1 = null;
		ResultSet rs = null;
		String message = "";
		String prefix = "";
		JSONObject obj = null;
		String grade;
		String qty;
		String type;
		int stockType = 0;
		String processFee = "0";
		String sourceType = "";
		String totProcessFee = "0";
		int uniqueId = 0;
		int importUp = 0;
		String imType = "";
		int route = 0;
		int ID = 0;
		try {
			con = DBConnection.getConnectionToDB("AMS");
			Calendar gcalendar = new GregorianCalendar();
			int year = gcalendar.get(Calendar.YEAR);
			String curyear = String.valueOf(year);

			int enrollmentNo = getPermitNumber(con, systemId, customerId, curyear);

			//----leading Zeros handling----------------------//  
			//doubt line
			String enrolmentNotoGrid = "";
			if (String.valueOf(enrollmentNo).length() <= 3) {
				enrolmentNotoGrid = ("000" + enrollmentNo).substring(String.valueOf(enrollmentNo).length());
			} else {
				enrolmentNotoGrid = (String.valueOf(enrollmentNo));
			}

			if (permittype.equalsIgnoreCase("Rom Transit")) {
				prefix = "RTP";
			} else if (permittype.equalsIgnoreCase("Processed Ore Transit")) {
				prefix = "POT";
			} else if (permittype.equalsIgnoreCase("Domestic Export")) {
				prefix = "DE";
			} else if (permittype.equalsIgnoreCase("International Export")) {
				prefix = "IE";
			} else if (permittype.equalsIgnoreCase("Rom Sale")) {
				prefix = "RS";
			} else if (permittype.equalsIgnoreCase("Processed Ore Sale")) {
				prefix = "POS";
			} else if (permittype.equalsIgnoreCase("Bauxite Transit")) {
				prefix = "BTP";
			} else if (permittype.equalsIgnoreCase("Processed Ore Sale Transit")) {
				prefix = "POST";
			} else if (permittype.equalsIgnoreCase("Import Permit")) {
				prefix = "IMP";
			} else if (permittype.equalsIgnoreCase("Import Transit Permit")) {
				prefix = "IMTP";
			} else if (permittype.equalsIgnoreCase("Purchased Rom Sale Transit Permit")) {
				prefix = "PRSTP";
			}
			if (permittype.equalsIgnoreCase("Processed Ore Sale") || permittype.equalsIgnoreCase("Rom Sale")) {
				route = hubId;
			} else {
				route = routeid;
			}
			pstmt = con.prepareStatement(IronMiningStatement.INSERT_PERMIT_DETAILS,
					PreparedStatement.RETURN_GENERATED_KEYS);
			pstmt.setString(1, prefix + " " + CustName + "" + enrolmentNotoGrid + "/" + curyear);
			pstmt.setInt(2, tcid);
			pstmt.setString(3, date);
			pstmt.setString(4, mineral);
			pstmt.setInt(5, route);
			pstmt.setInt(6, challanid);
			pstmt.setString(7, startdate);
			pstmt.setString(8, enddate);
			pstmt.setString(9, remarks);
			pstmt.setInt(10, userId);
			pstmt.setInt(11, systemId);
			pstmt.setInt(12, customerId);
			pstmt.setString(13, permittype);
			pstmt.setString(14, finYr);
			pstmt.setString(15, permitReq);
			pstmt.setString(16, ownerType);
			pstmt.setString(17, appNo);
			pstmt.setInt(18, orgCode);
			pstmt.setString(19, buyer);
			pstmt.setString(20, ship);
			pstmt.setInt(21, state);
			pstmt.setInt(22, country);
			pstmt.setInt(23, buyingOrgId);
			pstmt.setInt(24, Integer.parseInt(ImporteiPermitId));
			pstmt.setString(25, toLocations);
			pstmt.setString(26, srcType);
			int inserted = pstmt.executeUpdate();
			rs = pstmt.getGeneratedKeys();
			if (rs.next()) {
				ID = rs.getInt(1);
			}
			if (inserted > 0) {
				if (permittype.equalsIgnoreCase("Processed Ore Transit")
						|| permittype.equalsIgnoreCase("Domestic Export")
						|| permittype.equalsIgnoreCase("International Export")
						|| permittype.equalsIgnoreCase("Processed Ore Sale")
						|| permittype.equalsIgnoreCase("Processed Ore Sale Transit")
						|| permittype.equalsIgnoreCase("Import Permit")
						|| permittype.equalsIgnoreCase("Import Transit Permit")) {
					pstmt = con.prepareStatement(IronMiningStatement.GET_UNIQUE_ID_FROM_PERMIT_DETAILS);
					pstmt.setString(1, prefix + " " + CustName + "" + enrolmentNotoGrid + "/" + curyear);
					pstmt.setInt(2, customerId);
					pstmt.setInt(3, systemId);
					rs = pstmt.executeQuery();
					if (rs.next()) {
						uniqueId = rs.getInt("ID");
					}
					if (permittype.equalsIgnoreCase("Import Transit Permit")) {

						pstmt = con.prepareStatement(IronMiningStatement.GET_IMPORT_TYPE);
						pstmt.setInt(1, Integer.parseInt(ImporteiPermitId));
						rs = pstmt.executeQuery();
						if (rs.next()) {
							imType = rs.getString("IMPORT_TYPE");
						}
						pstmt = con.prepareStatement(IronMiningStatement.INSERT_IMPORT_TRANSIT_DETAILS);
						pstmt.setInt(1, uniqueId);
						pstmt.setString(2, exportPermitNo);
						pstmt.setString(3, exportPermitDate);
						pstmt.setString(4, exportChallanNo);
						pstmt.setString(5, exportChallanDate);
						pstmt.setString(6, saleInvoiceNo);
						pstmt.setString(7, saleInvoiceDate);
						pstmt.setString(8, transportnType);
						pstmt.setString(9, vesselName);
						pstmt.setString(10, imType);
						importUp = pstmt.executeUpdate();
						if (importUp > 0) {
							pstmt = con.prepareStatement(IronMiningStatement.UPDATE_STATUS_FOR_IMPORT_PERMIT);
							pstmt.setInt(1, Integer.parseInt(ImporteiPermitId));
							pstmt.executeUpdate();
							if (js.length() == 0) {
								pstmt = con.prepareStatement(
										IronMiningStatement.INSERT_INTO_PROCESSED_ORE_DETAILS_FOR_IMPORT);
								pstmt.setInt(1, uniqueId);
								pstmt.setInt(2, Integer.parseInt(ImporteiPermitId));
								pstmt.executeUpdate();

								pstmt = con.prepareStatement(IronMiningStatement.GET_PROCESSING_FEE);
								pstmt.setInt(1, uniqueId);
								rs = pstmt.executeQuery();
								if (rs.next()) {
									totProcessFee = rs.getString("TOTAL_PROCESSING_FEE");
								}

								pstmt = con.prepareStatement(IronMiningStatement.UPDATE_ORGANIZATION_DEATILS);
								pstmt.setString(1, totProcessFee);
								pstmt.setInt(2, systemId);
								pstmt.setInt(3, customerId);
								pstmt.setInt(4, orgCode);
								pstmt.executeUpdate();
							}
						}
					}
					if (permittype.equalsIgnoreCase("Import Permit")) {
						pstmt = con.prepareStatement(IronMiningStatement.INSERT_IMPORT_DETAILS);
						pstmt.setInt(1, uniqueId);
						pstmt.setString(2, importType);
						pstmt.setString(3, importPurpose);
						pstmt.setString(4, vesselName);
						pstmt.executeUpdate();
					}
					for (int i = 0; i < js.length(); i++) {
						obj = js.getJSONObject(i);
						grade = obj.getString("gardeDataIndex");
						type = obj.getString("type2IdIndex");
						qty = obj.getString("qty2IdIndex");
						if (!obj.getString("processingFeeIndex").equals("")
								&& obj.getString("processingFeeIndex") != null) {
							processFee = obj.getString("processingFeeIndex");
						}
						if (!obj.getString("totalPfeeIndex").equals("") && obj.getString("totalPfeeIndex") != null) {
							totProcessFee = obj.getString("totalPfeeIndex");
						}
						if (!permittype.equalsIgnoreCase("Import Permit")) {
							stockType = Integer.parseInt(obj.getString("stockTypeIdIndex"));

							if (stockName.contains("PLANT")) {
								sourceType = "PLANT";
							}
							if (stockName.contains("STOCK/JETTY")) {
								sourceType = "STOCK";
							}
						}
						pstmt = con.prepareStatement(IronMiningStatement.INSERT_INTO_PROCESSED_ORE_PERMIT_DETAILS);
						pstmt.setInt(1, uniqueId);
						pstmt.setString(2, grade);
						pstmt.setString(3, type);
						pstmt.setString(4, qty);
						pstmt.setInt(5, stockType);
						pstmt.setString(6, sourceType);
						pstmt.setString(7, processFee);
						pstmt.setString(8, totProcessFee);
						pstmt.executeUpdate();

						if (!permittype.equalsIgnoreCase("Import Permit")) {

							float lumps = 0;
							float fines = 0;
							float totalQty = 0;
							float concentrates = 0;
							float tailings = 0;
							if (type.equalsIgnoreCase("Fines")) {
								fines = Float.parseFloat(qty);
							} else if (type.equalsIgnoreCase("Lumps")) {
								lumps = Float.parseFloat(qty);
							} else if (type.equalsIgnoreCase("Concentrates")) {
								concentrates = Float.parseFloat(qty);
							} else if (type.equalsIgnoreCase("tailings")) {
								tailings = Float.parseFloat(qty);
							}
							if (stockName.contains("PLANT")) {
								pstmt = con.prepareStatement(IronMiningStatement.UPDATE_PLANT_MASTER);
								pstmt.setFloat(1, fines);
								pstmt.setFloat(2, lumps);
								pstmt.setFloat(3, concentrates);
								pstmt.setFloat(4, tailings);
								pstmt.setInt(5, systemId);
								pstmt.setInt(6, customerId);
								pstmt.setInt(7, stockType);
								pstmt.executeUpdate();
							}
							if (stockName.contains("STOCK/JETTY")) {
								if (type.equalsIgnoreCase("NA")) {
									totalQty = Float.parseFloat(qty);
								}
								pstmt = con.prepareStatement(IronMiningStatement.UPDATE_STOCK_DEATILS);
								pstmt.setFloat(1, fines);
								pstmt.setFloat(2, lumps);
								pstmt.setFloat(3, concentrates);
								pstmt.setFloat(4, tailings);
								pstmt.setFloat(5, totalQty);
								pstmt.setInt(6, systemId);
								pstmt.setInt(7, customerId);
								pstmt.setInt(8, stockType);
								pstmt.setInt(9, orgCode);
								pstmt.setString(10, mineral);
								pstmt.executeUpdate();
							}
						}
						pstmt = con.prepareStatement(IronMiningStatement.UPDATE_ORGANIZATION_DEATILS);
						pstmt.setString(1, totProcessFee);
						pstmt.setInt(2, systemId);
						pstmt.setInt(3, customerId);
						pstmt.setInt(4, orgCode);
						pstmt.executeUpdate();
					}
				}
				if (permittype.equalsIgnoreCase("Rom Transit") || permittype.equalsIgnoreCase("Rom Sale")) {
					int Uid = 0;
					String grade1 = "";
					String rate = "";
					String Rmqty = "";
					String totalPayable = "";
					pstmt = con.prepareStatement(IronMiningStatement.GET_UNIQUE_ID_FROM_PERMIT_DETAILS);
					pstmt.setString(1, prefix + " " + CustName + "" + enrolmentNotoGrid + "/" + curyear);
					pstmt.setInt(2, customerId);
					pstmt.setInt(3, systemId);
					rs = pstmt.executeQuery();
					if (rs.next()) {
						Uid = rs.getInt("ID");
					}
					pstmt = con.prepareStatement(IronMiningStatement.GET_GRADE_FROM_CHALLAN);
					pstmt.setInt(1, challanid);
					rs = pstmt.executeQuery();
					if (rs.next()) {
						grade1 = rs.getString("GRADE");
					}
					if (srcType.equalsIgnoreCase("ROM")) {
						for (int i = 0; i < js.length(); i++) {
							obj = js.getJSONObject(i);
							type = obj.getString("type2IdIndex");
							qty = obj.getString("qty2IdIndex");
							if (!obj.getString("processingFeeIndex").equals("")
									&& obj.getString("processingFeeIndex") != null) {
								processFee = obj.getString("processingFeeIndex");
							}
							if (!obj.getString("totalPfeeIndex").equals("")
									&& obj.getString("totalPfeeIndex") != null) {
								totProcessFee = obj.getString("totalPfeeIndex");
							}

							stockType = Integer.parseInt(obj.getString("stockTypeIdIndex"));

							if (stockName.contains("PLANT")) {
								sourceType = "PLANT";
							}
							if (stockName.contains("STOCK/JETTY")) {
								sourceType = "STOCK";
							}
							totalPayable = totProcessFee;
							pstmt = con.prepareStatement(IronMiningStatement.INSERT_INTO_PROCESSED_ORE_PERMIT_DETAILS);
							pstmt.setInt(1, Uid);
							pstmt.setString(2, obj.getString("gardeDataIndex"));
							pstmt.setString(3, "Rom");
							pstmt.setString(4, qty);
							pstmt.setInt(5, stockType);
							pstmt.setString(6, sourceType);
							pstmt.setString(7, processFee);
							pstmt.setString(8, totProcessFee);
							pstmt.executeUpdate();

							pstmt = con.prepareStatement(IronMiningStatement.UPDATE_STOCK_DEATILS_ROM);
							pstmt.setFloat(1, Float.parseFloat(qty));
							pstmt.setInt(2, systemId);
							pstmt.setInt(3, customerId);
							pstmt.setInt(4, stockType);
							pstmt.setInt(5, orgCode);
							pstmt.setString(6, mineral);
							pstmt.executeUpdate();

						}
						pstmt = con.prepareStatement(IronMiningStatement.UPDATE_ORGANIZATION_DEATILS);
						pstmt.setString(1, totalPayable);
						pstmt.setInt(2, systemId);
						pstmt.setInt(3, customerId);
						pstmt.setInt(4, orgCode);
						pstmt.executeUpdate();
					} else {
						for (int i = 0; i < js.length(); i++) {
							obj = js.getJSONObject(i);
							rate = obj.getString("rateIdIndex");
							Rmqty = obj.getString("qtyIdIndex");
							totalPayable = obj.getString("payableIdIndex");

							pstmt = con.prepareStatement(IronMiningStatement.INSERT_INTO_PROCESSED_ORE_PERMIT_DETAILS);
							pstmt.setInt(1, Uid);
							pstmt.setString(2, grade1);
							pstmt.setString(3, "");
							pstmt.setString(4, Rmqty);
							pstmt.setInt(5, 0);
							pstmt.setString(6, "");
							pstmt.setString(7, rate);
							pstmt.setString(8, totalPayable);
							pstmt.executeUpdate();
						}
						pstmt = con.prepareStatement(IronMiningStatement.UPDATE_ORGANIZATION_DEATILS);
						pstmt.setString(1, totalPayable);
						pstmt.setInt(2, systemId);
						pstmt.setInt(3, customerId);
						pstmt.setInt(4, TcorgId);
						pstmt.executeUpdate();
					}
				}
				if (permittype.equalsIgnoreCase("Purchased Rom Sale Transit Permit")) {
					int uniqId = 0;
					String rmqty = "0";
					String rmGrade = "";
					pstmt = con.prepareStatement(IronMiningStatement.GET_UNIQUE_ID_FROM_PERMIT_DETAILS);
					pstmt.setString(1, prefix + " " + CustName + "" + enrolmentNotoGrid + "/" + curyear);
					pstmt.setInt(2, customerId);
					pstmt.setInt(3, systemId);
					rs = pstmt.executeQuery();
					if (rs.next()) {
						uniqId = rs.getInt("ID");
					}
					pstmt = con.prepareStatement(IronMiningStatement.UPDATE_STATUS_FOR_IMPORT_PERMIT);
					pstmt.setInt(1, Integer.parseInt(ImporteiPermitId));
					pstmt.executeUpdate();
					String rsType = "";
					String rsQty = "";
					String rsPFee = "";
					String rsTotalPFee = "";
					int rsSType = 0;

					pstmt = con.prepareStatement(IronMiningStatement.GET_PROCESSING_FEE);
					pstmt.setInt(1, Integer.parseInt(ImporteiPermitId));
					rs = pstmt.executeQuery();
					if (rs.next()) {
						rmqty = rs.getString("QUANTITY");
						rmGrade = rs.getString("GRADE");
						rsType = rs.getString("TYPE");
						rsSType = rs.getInt("STOCK_TYPE");
					}
					for (int i = 0; i < js.length(); i++) {
						obj = js.getJSONObject(i);
						if (rsType.equalsIgnoreCase("Rom")) {
							rsQty = obj.getString("qty2IdIndex");
							rsPFee = obj.getString("processingFeeIndex");
							rsTotalPFee = obj.getString("totalPfeeIndex");
						} else {
							rsQty = obj.getString("qtyIdIndex");
							rsPFee = obj.getString("rateIdIndex");
							rsTotalPFee = obj.getString("payableIdIndex");
							rsSType = 0;
						}
						pstmt = con.prepareStatement(IronMiningStatement.INSERT_INTO_PROCESSED_ORE_PERMIT_DETAILS);
						pstmt.setInt(1, uniqId);
						pstmt.setString(2, rmGrade);
						pstmt.setString(3, rsType);
						pstmt.setString(4, rsQty);
						pstmt.setInt(5, rsSType);
						pstmt.setString(6, "");
						pstmt.setString(7, rsPFee);
						pstmt.setString(8, rsTotalPFee);
						pstmt.executeUpdate();

						pstmt = con.prepareStatement(IronMiningStatement.UPDATE_ORGANIZATION_DEATILS);
						pstmt.setString(1, rsTotalPFee);
						pstmt.setInt(2, systemId);
						pstmt.setInt(3, customerId);
						pstmt.setInt(4, orgCode);
						pstmt.executeUpdate();

						pstmt = con.prepareStatement(IronMiningStatement.UPDATE_PR_FOR_ORG);
						pstmt.setString(1, rsQty);
						pstmt.setInt(2, orgCode);
						pstmt.executeUpdate();
					}
				}
				message = String.valueOf(ID);//"Permit Details Saved Successfully";
			} else {
				message = "0";//"Error in Saving permit Details";
			}
		} catch (Exception e) {
			message = "error in saving Permit details ";
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(null, pstmt1, rs);
			DBConnection.releaseConnectionToDB(con, pstmt, null);
		}
		return message;

	}

	//-----------------------------------------Get Permit Details------------------------------------//
	@SuppressWarnings("unchecked")
	public ArrayList getPermitDetails(int systemId, int customerId, int userId, String fromDate, String endDate,
			int selectedPermitId, int selectedOrgId, int selectedBuyOrgId) {
		ArrayList<ReportHelper> reportsList = new ArrayList<ReportHelper>();
		ArrayList<String> headersList = new ArrayList<String>();
		JSONArray JsonArray = new JSONArray();
		JSONObject JsonObject = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int slcount = 0;
		ReportHelper finalreporthelper = new ReportHelper();
		ArrayList<Object> finlist = new ArrayList<Object>();
		SimpleDateFormat diffddMMyyyyHHmmss = new SimpleDateFormat("dd-MM-yyyy");
		DecimalFormat df = new DecimalFormat("##0.00");
		DecimalFormat df3 = new DecimalFormat("##0.000");
		try {
			headersList.add("SLNO");
			headersList.add("Application No");
			headersList.add("Permit No");
			headersList.add("Status");
			headersList.add("Date");
			headersList.add("Financial Year");
			headersList.add("Permit Request Type");
			headersList.add("Owner Type");
			headersList.add("Permit Type");
			headersList.add("ROM");
			headersList.add("Fines");
			headersList.add("Lumps");
			headersList.add("Concentrates");
			headersList.add("Tailings");
			headersList.add("Permit Quantity");
			headersList.add("Used Quantity");
			headersList.add("Permit Balance");
			headersList.add("To Source");
			headersList.add("Self Consumption Quantity");
			headersList.add("Processing Fee");
			headersList.add("Total Processing Fee");
			headersList.add("Closed Quantity");
			headersList.add("TC No");
			headersList.add("Mine Code");
			headersList.add("Lease Name");
			headersList.add("Lease Owner");
			headersList.add("Organization/Trader Code");
			headersList.add("Organization/Trader Name");
			headersList.add("Mineral Type");
			headersList.add("Route Id");
			headersList.add("From Location");
			headersList.add("To Location");
			headersList.add("Ref");
			headersList.add("Id");
			headersList.add("Remarks");
			headersList.add("Start Date");
			headersList.add("End Date");
			headersList.add("Buyer Name");
			headersList.add("Country");
			headersList.add("Country Id");
			headersList.add("State");
			headersList.add("State Id");
			headersList.add("Vessel Name");
			headersList.add("Route");
			headersList.add("Buying Org Id");
			headersList.add("Buying Org/Trader Name");
			headersList.add("Buying Org/Trader Code");
			headersList.add("Existing Permit No");
			headersList.add("Import Type");
			headersList.add("Source HubName");
			headersList.add("To Location");
			headersList.add("Source Type");
			headersList.add("Mother Route");
			headersList.add("Route Type");
			headersList.add("Processing Fee Type");

			con = DBConnection.getConnectionToDB("AMS");
			if (selectedPermitId == 0 && selectedOrgId == 0 && selectedBuyOrgId == 0) {
				pstmt = con.prepareStatement(IronMiningStatement.GET_PERMIT_DETAILS.replace("#conditions#",
						" and( a.TC_ID in (select TC_ID from MINING.dbo.USER_TC_ASSOCIATION where USER_ID=? and   SYSTEM_ID=a.SYSTEM_ID and TC_ID!=0 ) "
								+ "or a.ORGANIZATION_CODE  in (select ORG_ID from MINING.dbo.USER_TC_ASSOCIATION where USER_ID=? and  SYSTEM_ID=a.SYSTEM_ID)) and a.INSERTED_DATETIME between dateadd(mi,-330,?) and dateadd(mi,-330,?)"));
				pstmt.setInt(1, systemId);
				pstmt.setInt(2, customerId);
				pstmt.setInt(3, userId);
				pstmt.setInt(4, userId);
				pstmt.setString(5, fromDate);
				pstmt.setString(6, endDate);
			} else if (selectedPermitId != 0 && selectedOrgId == 0 && selectedBuyOrgId == 0) {
				pstmt = con
						.prepareStatement(IronMiningStatement.GET_PERMIT_DETAILS.replace("#conditions#", "and a.ID=?"));
				pstmt.setInt(1, systemId);
				pstmt.setInt(2, customerId);
				pstmt.setInt(3, selectedPermitId);
			} else if (selectedPermitId == 0 && selectedOrgId != 0 && selectedBuyOrgId == 0) {
				pstmt = con.prepareStatement(
						IronMiningStatement.GET_PERMIT_DETAILS.replace("#conditions#", "and (a.ORGANIZATION_CODE=? "
								+ "or a.TC_ID in (select a1.ID from AMS.dbo.MINING_TC_MASTER a1 left outer join AMS.dbo.MINING_MINE_MASTER b1 on b1.ID=a1.MINE_ID and a1.SYSTEM_ID=b1.SYSTEM_ID and a1.CUSTOMER_ID=b1.CUSTOMER_ID  where b1.ORG_ID=? ))"));
				pstmt.setInt(1, systemId);
				pstmt.setInt(2, customerId);
				pstmt.setInt(3, selectedOrgId);
				pstmt.setInt(4, selectedOrgId);
			} else if (selectedPermitId == 0 && selectedOrgId == 0 && selectedBuyOrgId != 0) {
				pstmt = con.prepareStatement(IronMiningStatement.GET_PERMIT_DETAILS.replace("#conditions#",
						" and BUYING_ORG_ID=" + selectedBuyOrgId));
				pstmt.setInt(1, systemId);
				pstmt.setInt(2, customerId);
			}
			rs = pstmt.executeQuery();
			while (rs.next()) {
				JsonObject = new JSONObject();
				slcount++;
				ReportHelper reporthelper = new ReportHelper();
				ArrayList<Object> informationList = new ArrayList<Object>();

				JsonObject.put("slnoIndex", slcount);
				informationList.add(slcount);

				JsonObject.put("applicationNoDataIndex", rs.getString("APPLICATION_NO"));
				informationList.add(rs.getString("APPLICATION_NO"));

				JsonObject.put("permitNoDataIndex", rs.getString("PERMIT_NO"));
				informationList.add(rs.getString("PERMIT_NO"));

				JsonObject.put("statusDataIndex", rs.getString("STATUS"));
				informationList.add(rs.getString("STATUS"));

				if (rs.getString("DATE").contains("1900")) {
					JsonObject.put("dateIndex", "");
					informationList.add("");
				} else {
					JsonObject.put("dateIndex", diffddMMyyyyHHmmss.format(rs.getTimestamp("DATE")));
					informationList.add(diffddMMyyyyHHmmss.format(rs.getTimestamp("DATE")));
				}

				JsonObject.put("financialYearIndex", rs.getString("FINANCIAL_YEAR"));
				informationList.add(rs.getString("FINANCIAL_YEAR"));

				JsonObject.put("permitRequestTypeIndex", rs.getString("PERMIT_REQUEST_TYPE"));
				informationList.add(rs.getString("PERMIT_REQUEST_TYPE"));

				JsonObject.put("ownerTypeIndex", rs.getString("OWNER_TYPE"));
				informationList.add(rs.getString("OWNER_TYPE"));

				JsonObject.put("permitTypeIndex", rs.getString("PERMIT_TYPE"));
				informationList.add(rs.getString("PERMIT_TYPE"));

				if (((rs.getString("PERMIT_TYPE").equals("Rom Transit")
						|| rs.getString("PERMIT_TYPE").equals("Rom Sale"))
						&& rs.getString("SRC_TYPE").equals("E-Wallet"))) {
					JsonObject.put("exactRomIndex", rs.getString("RTP_ROM_GRADE"));
					informationList.add(rs.getString("RTP_ROM_GRADE"));

					JsonObject.put("exactFinesIndex", rs.getString("RTP_FINES_GRADE"));
					informationList.add(rs.getString("RTP_FINES_GRADE"));

					JsonObject.put("exactLumpsIndex", rs.getString("RTP_LUMPS_GRADE"));
					informationList.add(rs.getString("RTP_LUMPS_GRADE"));

					JsonObject.put("exactConcentratesIndex", "");
					informationList.add("");

					JsonObject.put("exactTailingsIndex", "");
					informationList.add("");

				} else {
					if (rs.getString("EXACT_TYPE").equals("Fines")) {
						JsonObject.put("exactRomIndex", "");
						informationList.add("");

						JsonObject.put("exactFinesIndex", rs.getString("EXACT_GRADE"));
						informationList.add(rs.getString("EXACT_GRADE"));

						JsonObject.put("exactLumpsIndex", "");
						informationList.add("");

						JsonObject.put("exactConcentratesIndex", "");
						informationList.add("");

						JsonObject.put("exactTailingsIndex", "");
						informationList.add("");

					} else if (rs.getString("EXACT_TYPE").equals("Lumps")) {
						JsonObject.put("exactRomIndex", "");
						informationList.add("");

						JsonObject.put("exactFinesIndex", "");
						informationList.add("");

						JsonObject.put("exactLumpsIndex", rs.getString("EXACT_GRADE"));
						informationList.add(rs.getString("EXACT_GRADE"));

						JsonObject.put("exactConcentratesIndex", "");
						informationList.add("");

						JsonObject.put("exactTailingsIndex", "");
						informationList.add("");

					} else if (rs.getString("EXACT_TYPE").equals("Concentrates")) {
						JsonObject.put("exactRomIndex", "");
						informationList.add("");

						JsonObject.put("exactFinesIndex", "");
						informationList.add("");

						JsonObject.put("exactLumpsIndex", "");
						informationList.add("");

						JsonObject.put("exactConcentratesIndex", rs.getString("EXACT_GRADE"));
						informationList.add(rs.getString("EXACT_GRADE"));

						JsonObject.put("exactTailingsIndex", "");
						informationList.add("");

					} else if (rs.getString("EXACT_TYPE").equals("Tailings")) {
						JsonObject.put("exactRomIndex", "");
						informationList.add("");

						JsonObject.put("exactFinesIndex", "");
						informationList.add("");

						JsonObject.put("exactLumpsIndex", "");
						informationList.add("");

						JsonObject.put("exactConcentratesIndex", "");
						informationList.add("");

						JsonObject.put("exactTailingsIndex", rs.getString("EXACT_GRADE"));
						informationList.add(rs.getString("EXACT_GRADE"));

					} else {
						JsonObject.put("exactRomIndex", rs.getString("EXACT_GRADE"));
						informationList.add(rs.getString("EXACT_GRADE"));

						JsonObject.put("exactFinesIndex", "");
						informationList.add("");

						JsonObject.put("exactLumpsIndex", "");
						informationList.add("");

						JsonObject.put("exactConcentratesIndex", "");
						informationList.add("");

						JsonObject.put("exactTailingsIndex", "");
						informationList.add("");
					}
				}

				float permitQty;
				if (Double.parseDouble(rs.getString("challanqty")) > 0) {
					JsonObject.put("quantityDataIndex", df3.format(rs.getFloat("challanqty")));
					informationList.add(df3.format(rs.getFloat("challanqty")));
					permitQty = rs.getFloat("challanqty");
				} else {
					JsonObject.put("quantityDataIndex", df3.format(rs.getFloat("permitqty")));
					informationList.add(df3.format(rs.getFloat("permitqty")));
					permitQty = rs.getFloat("permitqty");
				}

				JsonObject.put("usedQtyIndex", df3.format(rs.getFloat("USED_QTY")));
				informationList.add(df3.format(rs.getFloat("USED_QTY")));

				if (rs.getString("STATUS").equals("CLOSE") || rs.getString("STATUS").equals("CANCEL")) {
					JsonObject.put("permitBalanceIndex", df3.format(0f));
					informationList.add(df3.format(0f));
					JsonObject.put("toSourceIndex", df3.format(permitQty - rs.getFloat("CLOSED_QTY")));
					informationList.add(df3.format(permitQty - rs.getFloat("CLOSED_QTY")));
				} else {
					JsonObject.put("permitBalanceIndex", df3.format(permitQty - rs.getFloat("USED_QTY")));
					informationList.add(df3.format(permitQty - rs.getFloat("USED_QTY")));
					JsonObject.put("toSourceIndex", df3.format(0f));
					informationList.add(df3.format(0f));
				}

				JsonObject.put("selfconsIndex", df3.format(rs.getFloat("SELF_CONSUMPTION_QUANTITY")));
				informationList.add(df3.format(rs.getFloat("SELF_CONSUMPTION_QUANTITY")));

				JsonObject.put("pfIndex", df.format(rs.getFloat("PROCESSING_FEE")));
				informationList.add(df.format(rs.getFloat("PROCESSING_FEE")));

				JsonObject.put("totalPfIndex", df.format(rs.getFloat("TOTAL_PROCESSING_FEE")));
				informationList.add(df.format(rs.getFloat("TOTAL_PROCESSING_FEE")));

				JsonObject.put("closedQtyIndex", df3.format(rs.getFloat("CLOSED_QTY")));
				informationList.add(df3.format(rs.getFloat("CLOSED_QTY")));

				JsonObject.put("tcNoIndex", rs.getString("TC_NO"));
				informationList.add(rs.getString("TC_NO"));

				JsonObject.put("mineCodeDataIndex", rs.getString("MINE_CODE"));
				informationList.add(rs.getString("MINE_CODE"));

				JsonObject.put("leaseNameDataIndex", rs.getString("MINING_LEASE"));
				informationList.add(rs.getString("MINING_LEASE"));

				JsonObject.put("leaseOwnerDataIndex", rs.getString("LEASE_NAME"));
				informationList.add(rs.getString("LEASE_NAME"));

				if (((rs.getString("PERMIT_TYPE").equals("Rom Transit")
						|| rs.getString("PERMIT_TYPE").equals("Rom Sale")) && rs.getString("SRC_TYPE").equals("ROM"))
						|| rs.getString("PERMIT_TYPE").equalsIgnoreCase("Purchased Rom Sale Transit Permit")
						|| rs.getString("PERMIT_TYPE").equalsIgnoreCase("Processed Ore Transit")
						|| rs.getString("PERMIT_TYPE").equalsIgnoreCase("Domestic Export")
						|| rs.getString("PERMIT_TYPE").equalsIgnoreCase("International Export")
						|| rs.getString("PERMIT_TYPE").equalsIgnoreCase("Processed Ore Sale")
						|| rs.getString("PERMIT_TYPE").equalsIgnoreCase("Processed Ore Sale Transit")
						|| rs.getString("PERMIT_TYPE").equalsIgnoreCase("Import Permit")
						|| rs.getString("PERMIT_TYPE").equalsIgnoreCase("Import Transit Permit")) {

					JsonObject.put("organizationCodeDataIndex", rs.getString("ORGANIZATION_CODE"));
					informationList.add(rs.getString("ORGANIZATION_CODE"));

					JsonObject.put("organizationNameDataIndex", rs.getString("ORGNAME"));
					informationList.add(rs.getString("ORGNAME"));

					JsonObject.put("organizationIdDataIndex", rs.getString("ORGANIZATION_ID"));
				} else {
					informationList.add("");
					informationList.add(rs.getString("ORGANIZATION_NAME"));
					JsonObject.put("organizationNameDataIndex", rs.getString("ORGANIZATION_NAME"));
					JsonObject.put("organizationIdDataIndex", rs.getString("TC_ORG"));
				}

				JsonObject.put("mineralDataIndex", rs.getString("MINERAL"));
				informationList.add(rs.getString("MINERAL"));

				JsonObject.put("routeIdDataIndex", rs.getString("Trip_Name"));
				informationList.add(rs.getString("Trip_Name"));

				JsonObject.put("fromLocationDataIndex", rs.getString("Start_Location"));
				informationList.add(rs.getString("Start_Location"));

				JsonObject.put("toLocationDataIndex", rs.getString("End_Location"));
				informationList.add(rs.getString("End_Location"));

				JsonObject.put("refDataIndex", rs.getString("CHALLAN_NO"));
				informationList.add(rs.getString("CHALLAN_NO"));

				JsonObject.put("uniqueidDataIndex", rs.getString("ID"));
				informationList.add(rs.getString("ID"));

				JsonObject.put("remarksDataIndex", rs.getString("REMARKS"));
				informationList.add(rs.getString("REMARKS"));

				JsonObject.put("challanIdDataIndex", rs.getString("CHALLAN_ID"));
				//informationList.add( rs.getString("CHALLAN_ID"));

				if (rs.getString("START_DATE").contains("1900")) {
					JsonObject.put("startdateDataIndex", "");
					informationList.add("");
				} else {
					JsonObject.put("startdateDataIndex", diffddMMyyyyHHmmss.format(rs.getTimestamp("START_DATE")));
					informationList.add(diffddMMyyyyHHmmss.format(rs.getTimestamp("START_DATE")));
				}

				if (rs.getString("END_DATE").contains("1900")) {
					JsonObject.put("enddateDataIndex", "");
					informationList.add("");
				} else {
					JsonObject.put("enddateDataIndex", diffddMMyyyyHHmmss.format(rs.getTimestamp("END_DATE")));
					informationList.add(diffddMMyyyyHHmmss.format(rs.getTimestamp("END_DATE")));
				}

				if (rs.getString("PERMIT_TYPE").equalsIgnoreCase("Domestic Export")
						|| rs.getString("IMPORT_TYPE").equalsIgnoreCase("Domestic Import")) {

					JsonObject.put("buyerDataIndex", rs.getString("BUYER_NAME"));
					JsonObject.put("stateNameDataIndex", rs.getString("STATE_NAME"));
					JsonObject.put("stateIdDataIndex", rs.getString("STATE_CODE"));
					informationList.add(rs.getString("BUYER_NAME"));
					informationList.add("");
					informationList.add("");
					informationList.add(rs.getString("STATE_NAME"));
					informationList.add(rs.getString("STATE_CODE"));
					informationList.add("");
				} else if (rs.getString("PERMIT_TYPE").equalsIgnoreCase("International Export")
						|| rs.getString("IMPORT_TYPE").equalsIgnoreCase("International Import")) {

					JsonObject.put("buyerDataIndex", rs.getString("BUYER_NAME"));
					JsonObject.put("countryNameDataIndex", rs.getString("COUNTRY_NAME"));
					JsonObject.put("countryIdDataIndex", rs.getString("COUNTRY_CODE"));
					JsonObject.put("shipNameDataIndex", rs.getString("SHIP_NAME"));
					informationList.add(rs.getString("BUYER_NAME"));
					informationList.add(rs.getString("COUNTRY_NAME"));
					informationList.add(rs.getString("COUNTRY_CODE"));
					informationList.add("");
					informationList.add("");
					informationList.add(rs.getString("SHIP_NAME"));
				} else if (rs.getString("PERMIT_TYPE").equalsIgnoreCase("Purchased Rom Sale Transit Permit")
						|| rs.getString("PERMIT_TYPE").equalsIgnoreCase("Rom Sale")
						|| rs.getString("PERMIT_TYPE").equalsIgnoreCase("Processed Ore Sale")
						|| rs.getString("PERMIT_TYPE").equalsIgnoreCase("Processed Ore Sale Transit")) {
					JsonObject.put("countryNameDataIndex", rs.getString("COUNTRY_NAME"));
					JsonObject.put("countryIdDataIndex", rs.getString("COUNTRY_CODE"));
					JsonObject.put("stateNameDataIndex", rs.getString("STATE_NAME"));
					JsonObject.put("stateIdDataIndex", rs.getString("STATE_CODE"));
					JsonObject.put("buyingOrgIdDataIndex", rs.getString("BUYING_ORG_ID"));
					JsonObject.put("buyingOrgNameDataIndex", rs.getString("BUYING_ORGANIZAION_NAME"));
					JsonObject.put("buyingOrgCodeDataIndex", rs.getString("BUYING_ORGANIZATION_CODE"));
					informationList.add("");
					informationList.add(rs.getString("COUNTRY_NAME"));
					informationList.add(rs.getString("COUNTRY_CODE"));
					informationList.add(rs.getString("STATE_NAME"));
					informationList.add(rs.getString("STATE_CODE"));
					informationList.add("");
				} else {
					informationList.add(rs.getString("BUYER_NAME"));
					informationList.add("");
					informationList.add("");
					informationList.add("");
					informationList.add("");
					informationList.add("");
				}

				JsonObject.put("routeDataIndex", rs.getString("ROUTE_ID"));
				informationList.add(rs.getString("ROUTE_ID"));

				informationList.add(rs.getString("BUYING_ORG_ID"));

				informationList.add(rs.getString("BUYING_ORGANIZAION_NAME"));

				informationList.add(rs.getString("BUYING_ORGANIZATION_CODE"));

				JsonObject.put("ExtpermitIdDataIndex", rs.getString("EXISTING_PERMIT_ID"));

				if (Integer.parseInt(rs.getString("EXISTING_PERMIT_ID")) != 0) {
					JsonObject.put("existingPermitIndex", rs.getString("EXISTING_PERMIT_NO"));
					informationList.add(rs.getString("EXISTING_PERMIT_NO"));
				} else {
					JsonObject.put("existingPermitIndex", "");
					informationList.add("");
				}
				JsonObject.put("importTypeDataIndex", rs.getString("IMPORT_TYPE"));
				informationList.add(rs.getString("IMPORT_TYPE"));

				JsonObject.put("hubNameIndex", rs.getString("NAME"));
				informationList.add(rs.getString("NAME"));

				if (rs.getString("PERMIT_TYPE").equalsIgnoreCase("Processed Ore Sale")
						|| rs.getString("PERMIT_TYPE").equalsIgnoreCase("Rom Sale")) {
					JsonObject.put("hubIdIndex", rs.getString("ROUTE_ID"));
				}

				JsonObject.put("toLocIndex", rs.getString("DEST_TYPE"));
				informationList.add(rs.getString("DEST_TYPE"));

				JsonObject.put("destTypeDataIndex", rs.getString("SRC_TYPE"));
				informationList.add(rs.getString("SRC_TYPE"));

				JsonObject.put("motherRDataIndex", rs.getString("MOTHER_ROUTE"));
				informationList.add(rs.getString("MOTHER_ROUTE"));

				JsonObject.put("leaseTypeDataIndex", rs.getString("ROUTE_LEASE"));
				informationList.add(rs.getString("ROUTE_LEASE"));

				JsonObject.put("processingFeeTypeDataIndex", rs.getString("REFUND_TYPE"));
				informationList.add(rs.getString("REFUND_TYPE"));

				JsonObject.put("importPurposeDataIndex", rs.getString("IMPORT_PURPOSE"));

				JsonObject.put("exportPermitDataIndex", rs.getString("EXPORT_PERMIT_NO"));
				if (rs.getString("EXPORT_PERMIT_NO_DATE").contains("1900")) {
					JsonObject.put("exportPermitDateDataIndex", rs.getString("EXPORT_PERMIT_NO_DATE"));
				} else {
					JsonObject.put("exportPermitDateDataIndex",
							diffddMMyyyyHHmmss.format(rs.getTimestamp("EXPORT_PERMIT_NO_DATE")));
				}
				JsonObject.put("exportChallanDataIndex", rs.getString("EXPORT_CHALLAN_NO"));
				if (rs.getString("EXPORT_CHALLAN_NO_DATE").contains("1900")) {
					JsonObject.put("exportChallanDateDataIndex", rs.getString("EXPORT_CHALLAN_NO_DATE"));
				} else {
					JsonObject.put("exportChallanDateDataIndex",
							diffddMMyyyyHHmmss.format(rs.getTimestamp("EXPORT_CHALLAN_NO_DATE")));
				}
				JsonObject.put("saleInvoiceDataIndex", rs.getString("SALE_INVOICE_NO"));
				if (rs.getString("SALE_INVOICE_NO_DATE").contains("1900")) {
					JsonObject.put("saleInvoiceDateDataIndex", rs.getString("SALE_INVOICE_NO_DATE"));
				} else {
					JsonObject.put("saleInvoiceDateDataIndex",
							diffddMMyyyyHHmmss.format(rs.getTimestamp("SALE_INVOICE_NO_DATE")));
				}

				JsonObject.put("transportnDataIndex", rs.getString("TRANSPORTATION_TYPE"));
				JsonObject.put("vesselNameDataIndex", rs.getString("VESSEL_NAME"));
				JsonObject.put("srcTypePrstpIndex", rs.getString("SRC_TYPE_PRSTP"));

				JsonArray.put(JsonObject);
				reporthelper.setInformationList(informationList);
				reportsList.add(reporthelper);
			}
			finalreporthelper.setReportsList(reportsList);
			finalreporthelper.setHeadersList(headersList);
			finlist.add(JsonArray);
			finlist.add(finalreporthelper);

		} catch (Exception e) {
			e.printStackTrace();
		} finally {

			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return finlist;
	}

	private synchronized int getPermitNumber(Connection conAdmin, int systemId, int customerId, String curyear) {
		PreparedStatement pstmt550 = null;
		PreparedStatement pstmt55 = null;
		ResultSet rs550 = null;
		int enrolmentnonew = 0;
		try {
			pstmt550 = conAdmin.prepareStatement(IronMiningStatement.GET_ENROLLMENT_NUMBER, ResultSet.TYPE_FORWARD_ONLY,
					ResultSet.CONCUR_UPDATABLE);
			pstmt550.setString(1, "PERMIT_NO");
			pstmt550.setInt(2, systemId);
			pstmt550.setInt(3, customerId);
			pstmt550.setString(4, curyear);
			rs550 = pstmt550.executeQuery();
			if (rs550.next()) {
				enrolmentnonew = rs550.getInt("VALUE");
				enrolmentnonew++;
				rs550.updateInt("VALUE", enrolmentnonew);
				rs550.rowUpdated();
				pstmt55 = conAdmin.prepareStatement(IronMiningStatement.UPDATE_ENROLLMENT_NO_TO_LOOKUP);
				pstmt55.setInt(1, enrolmentnonew);
				pstmt55.setString(2, "PERMIT_NO");
				pstmt55.setInt(3, systemId);
				pstmt55.setInt(4, customerId);
				pstmt55.setString(5, curyear);
				pstmt55.executeUpdate();
			} else {
				enrolmentnonew++;
				pstmt55 = conAdmin.prepareStatement(IronMiningStatement.INSERT_ENROLLMENT_NUMBER_TO_LOOKUP);
				pstmt55.setString(1, "PERMIT_NO");
				pstmt55.setInt(2, enrolmentnonew);
				pstmt55.setString(3, curyear);
				pstmt55.setInt(4, systemId);
				pstmt55.setInt(5, customerId);
				pstmt55.executeUpdate();
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(null, pstmt550, rs550);
			DBConnection.releaseConnectionToDB(null, pstmt55, null);
		}
		return enrolmentnonew;
	}

	public String updateAcknowledgementStatus(String status, int custId, String pemitNo, int sysId, int routeId,
			int permitId, int buyOrgId, String mineralType, int impPermitId, int sourceHubId, String sourceT) {
		String message = "";
		Connection con = null;
		PreparedStatement pstmt = null;
		PreparedStatement pstmtop = null;
		PreparedStatement pstmt1 = null;
		PreparedStatement pstmtUp = null;
		ResultSet rs = null;
		ResultSet rs1 = null;
		int updated = 0;
		try {
			con = DBConnection.getConnectionToDB("AMS");
			if (status.equalsIgnoreCase("APPROVED") || status.equalsIgnoreCase("ACKNOWLEDGED")) {
				message = "Record Already Acknowledged";
			} else {
				pstmt = con.prepareStatement(IronMiningStatement.UPDATE_STATUS_FOR_ACKNOWLEDGEMENT);

				pstmt.setInt(1, sysId);
				pstmt.setInt(2, custId);
				pstmt.setInt(3, permitId);
				updated = pstmt.executeUpdate();
				if (updated > 0) {
					message = "Successfully Acknowledged";
					if (!status.equalsIgnoreCase("MODIFIED-SUBMIT")) {
						float fines = 0;
						float lumps = 0;
						float totalqty = 0;
						float permitqty = 0;
						float concentrates = 0;
						float tailings = 0;
						pstmt1 = con.prepareStatement(IronMiningStatement.GET_PERMIT_QTY);
						pstmt1.setInt(1, permitId);
						rs1 = pstmt1.executeQuery();
						if (rs1.next()) {
							if (rs1.getString("TYPE").equalsIgnoreCase("Fines")) {
								fines = rs1.getFloat("QUANTITY");
								permitqty = rs1.getFloat("QUANTITY");
							} else if (rs1.getString("TYPE").equalsIgnoreCase("Lumps")) {
								lumps = rs1.getFloat("QUANTITY");
								permitqty = rs1.getFloat("QUANTITY");
							} else if (rs1.getString("TYPE").equalsIgnoreCase("concentrates")) {
								concentrates = rs1.getFloat("QUANTITY");
								permitqty = rs1.getFloat("QUANTITY");
							} else if (rs1.getString("TYPE").equalsIgnoreCase("tailings")) {
								tailings = rs1.getFloat("QUANTITY");
								permitqty = rs1.getFloat("QUANTITY");
							} else {
								permitqty = rs1.getFloat("QUANTITY");
							}
						}
						if (pemitNo.startsWith("IMTP")) {
							util.insertActualQuantity(impPermitId, permitqty * 1000, con, 0);
						}
						if (pemitNo.startsWith("RS")) {

							util.updatePRQuantityInOrgmaster(buyOrgId, con, permitqty);

							util.insertActualQuantity(permitId, permitqty * 1000, con, 0);
						}
						if (pemitNo.startsWith("POS") && !pemitNo.startsWith("POST")) {
							pstmtop = null;
							pstmtop = con.prepareStatement(IronMiningStatement.GET_STOCK_DETAILS,
									ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
							pstmtop.setInt(1, sysId);
							pstmtop.setInt(2, custId);
							pstmtop.setInt(3, sourceHubId);
							pstmtop.setInt(4, buyOrgId);
							pstmtop.setString(5, mineralType);
							rs = pstmtop.executeQuery();
							if (rs.next()) {
								rs.updateFloat("FINES", rs.getFloat("FINES") + fines);
								rs.updateFloat("LUMPS", rs.getFloat("LUMPS") + lumps);
								rs.updateFloat("CONCENTRATES", rs.getFloat("CONCENTRATES") + concentrates);
								rs.updateFloat("TAILINGS", rs.getFloat("TAILINGS") + tailings);
								rs.updateFloat("TOTAL_QTY", rs.getFloat("TOTAL_QTY") + totalqty);
								rs.updateRow();
							} else {
								util.insertIntoStockYardMaster(custId, sysId, con, mineralType, buyOrgId, sourceHubId,
										fines, lumps, concentrates, tailings, totalqty);
							}
							util.insertActualQuantity(permitId, permitqty * 1000, con, 0);
						}
					}
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
			System.out.println("Inside acknoledgement function" + e.toString());
		} finally {
			DBConnection.releaseConnectionToDB(null, pstmtUp, null);
			DBConnection.releaseConnectionToDB(null, pstmt1, rs1);
			DBConnection.releaseConnectionToDB(null, pstmtop, rs);
			DBConnection.releaseConnectionToDB(con, pstmt, null);
		}
		return message;
	}

	//*****************Modify Permit Details************************************************//
	public String modifyPermitDetails(int customerId, int systemId, String date, String remarks, String startdate,
			String enddate, int selectedRoute, int userId, String ownerType, String finYr, String appNo, int id,
			JSONArray js, String Permittype, String buyer, String ship, int country, int state, int buyingOrgIdModify,
			String vesselName, String exportPermitNo, String exportPermitDate, String exportChallanNo,
			String exportChallanDate, String saleInvoiceNo, String saleInvoiceDate, String transportnType,
			String importPurpose) {
		Connection con = null;
		PreparedStatement pstmt1 = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		JSONObject obj = null;
		String message = "";
		int updated = 0;
		String grade;
		String qty;
		String type;
		String stockType = "";
		int uniqueId = 0;
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt1 = con.prepareStatement(IronMiningStatement.UPDATE_PERMIT_DETAILS);
			pstmt1.setString(1, appNo);
			pstmt1.setString(2, date);
			pstmt1.setString(3, finYr);
			pstmt1.setString(4, ownerType);
			pstmt1.setInt(5, selectedRoute);
			pstmt1.setString(6, startdate);
			pstmt1.setString(7, enddate);
			pstmt1.setString(8, remarks);
			pstmt1.setInt(9, userId);
			pstmt1.setString(10, buyer);
			pstmt1.setString(11, ship);
			pstmt1.setInt(12, state);
			pstmt1.setInt(13, country);
			pstmt1.setInt(14, buyingOrgIdModify);
			pstmt1.setInt(15, id);
			updated = pstmt1.executeUpdate();
			if (!Permittype.equalsIgnoreCase("Import Permit")) {
				importPurpose = "";
			}
			if (updated > 0) {
				if (Permittype.equalsIgnoreCase("Import Permit") || Permittype.equalsIgnoreCase("Import Transit Permit")
						|| Permittype.equalsIgnoreCase("Processed Ore Transit")
						|| Permittype.equalsIgnoreCase("Domestic Export")
						|| Permittype.equalsIgnoreCase("International Export")
						|| Permittype.equalsIgnoreCase("Processed Ore Sale")
						|| Permittype.equalsIgnoreCase("Processed Ore Sale Transit")) {
					if (Permittype.equalsIgnoreCase("Import Permit")
							|| Permittype.equalsIgnoreCase("Import Transit Permit")) {
						pstmt = con.prepareStatement(IronMiningStatement.UPDATE_IMPORT_DETAILS);
						pstmt.setString(1, exportPermitNo);
						pstmt.setString(2, exportPermitDate);
						pstmt.setString(3, exportChallanNo);
						pstmt.setString(4, exportChallanDate);
						pstmt.setString(5, saleInvoiceNo);
						pstmt.setString(6, saleInvoiceDate);
						pstmt.setString(7, transportnType);
						pstmt.setString(8, importPurpose);
						pstmt.setString(9, vesselName);
						pstmt.setInt(10, id);
						pstmt.executeUpdate();
					}
					for (int i = 0; i < js.length(); i++) {
						obj = js.getJSONObject(i);
						grade = obj.getString("gardeDataIndex");
						type = obj.getString("type2IdIndex");
						qty = obj.getString("qty2IdIndex");
						stockType = obj.getString("stockTypeIdIndex");
						pstmt = con.prepareStatement(IronMiningStatement.UPDATE_PROCESSED_ORE_PERMIT_DETAILS);
						pstmt.setString(1, grade);
						pstmt.setString(2, type);
						pstmt.setString(3, qty);
						pstmt.setString(4, stockType);
						pstmt.setInt(5, id);
						pstmt.executeUpdate();
					}
				}
				message = String.valueOf(id);//"Updated Successfully";
			} else {
				message = "0";//"Error while updating permit details.";
			}
		} catch (Exception e) {
			System.out.println("error in :-update Mine details " + e.toString());
			e.printStackTrace();
		}

		finally {
			DBConnection.releaseConnectionToDB(con, pstmt1, rs);
		}
		return message;
	}

	public String updateFinalSubmitPermit(String status, int custId, String pemitNo, int sysId) {
		String message = "";
		Connection conAdmin = null;
		PreparedStatement pstmt = null;
		int updated = 0;
		String statusUpdate = "PENDING APPROVAL";
		try {
			conAdmin = DBConnection.getConnectionToDB("AMS");
			if (status.equalsIgnoreCase("PENDING APPROVAL") || status.equalsIgnoreCase("CLOSE")) {
				message = "Record Already Submitted";
			} else if (status.equalsIgnoreCase("APPROVED") || status.equalsIgnoreCase("ACKNOWLEDGED")) {
				message = "Record Already Acknowledged";
			} else {
				if (status.equalsIgnoreCase("MODIFIED")) {
					statusUpdate = "MODIFIED-SUBMIT";
				}
				pstmt = conAdmin.prepareStatement(IronMiningStatement.UPDATE_STATUS_FOR_FINAL_SUBMIT_PERMIT);

				pstmt.setString(1, statusUpdate);
				pstmt.setInt(2, sysId);
				pstmt.setInt(3, custId);
				pstmt.setString(4, pemitNo);
				updated = pstmt.executeUpdate();
				if (updated > 0) {
					message = "Successfully Submitted";
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
			System.out.println("Inside acknoledgement function" + e.toString());
		} finally {
			DBConnection.releaseConnectionToDB(conAdmin, pstmt, null);
		}
		return message;
	}

	public JSONArray getPermitNumber(int customerId, int systemId, String tcid, String orgCode, String permitType,
			String shipName) {
		JSONArray JsonArray = null;
		JSONObject JsonObject = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String type = "";
		SimpleDateFormat diffddMMyyyyHHmmss = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
		try {
			JsonArray = new JSONArray();
			con = DBConnection.getConnectionToDB("AMS");
			if (permitType.equalsIgnoreCase("Rom Transit")) {
				type = "RTP%";
			} else if (permitType.equalsIgnoreCase("Processed Ore Transit")) {
				type = "POT%";
			} else if (permitType.equalsIgnoreCase("Domestic Export")) {
				type = "DE%";
			} else if (permitType.equalsIgnoreCase("International Export")) {
				type = "IE%";
			} else if (permitType.equalsIgnoreCase("Rom Sale")) {
				type = "RS%";
			} else if (permitType.equalsIgnoreCase("Processed Ore Sale")) {
				type = "POS%";
			} else if (permitType.equalsIgnoreCase("Bauxite Transit")) {
				type = "BTP%";
			} else if (permitType.equalsIgnoreCase("Processed Ore Sale Transit")) {
				type = "POST%";
			} else if (permitType.equalsIgnoreCase("Purchased Rom Sale Transit Permit")) {
				type = "PRSTP%";
			}
			if (!tcid.equals("") && tcid != null && !tcid.equals("0")) {
				pstmt = con
						.prepareStatement(IronMiningStatement.GET_PERMIT_NUMBER.replaceAll("#", " and mpd.TC_ID=? "));
				pstmt.setInt(1, systemId);
				pstmt.setInt(2, customerId);
				pstmt.setString(3, shipName);
				pstmt.setString(4, type);
				pstmt.setInt(5, Integer.parseInt(tcid));
			} else if (!orgCode.equals("") && orgCode != null && !orgCode.equals("0")) {
				pstmt = con.prepareStatement(
						IronMiningStatement.GET_PERMIT_NUMBER.replaceAll("#", " and mpd.ORGANIZATION_CODE=? "));
				pstmt.setInt(1, systemId);
				pstmt.setInt(2, customerId);
				pstmt.setString(3, shipName);
				pstmt.setString(4, type);
				pstmt.setInt(5, Integer.parseInt(orgCode));
			}
			rs = pstmt.executeQuery();
			while (rs.next()) {
				JsonObject = new JSONObject();
				JsonObject.put("PermitNo", rs.getString("PERMIT_NO"));
				JsonObject.put("ID", rs.getString("ID"));
				JsonArray.put(JsonObject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return JsonArray;
	}

	public JSONArray getPermitDetailsForClosure(int permitId) {
		JSONArray JsonArray = null;
		JSONObject JsonObject = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String type = "";
		SimpleDateFormat diffddMMyyyyHHmmss = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
		try {
			JsonArray = new JSONArray();
			con = DBConnection.getConnectionToDB("AMS");

			pstmt = con.prepareStatement(IronMiningStatement.GET_PERMIT_DETAILS_FOR_CLOSURE_BY_ID);
			pstmt.setInt(1, permitId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				JsonObject = new JSONObject();
				JsonObject.put("PermitNo", rs.getString("PERMIT_NO"));
				JsonObject.put("ID", rs.getString("ID"));
				JsonObject.put("PermitDate", diffddMMyyyyHHmmss.format(rs.getTimestamp("PERMIT_DATE")));
				if (Double.parseDouble(rs.getString("CHALLAN_QTY")) > 0) {
					JsonObject.put("Qty", rs.getString("CHALLAN_QTY"));
				} else {
					JsonObject.put("Qty", rs.getString("PERMIT_QTY"));
				}
				JsonObject.put("tripSheetQty", rs.getString("TRIPSHEET_QTY"));
				JsonObject.put("blnceEwalletQty", rs.getString("ROM_PERMITY_QTY"));
				JsonObject.put("blnceRomAmt", rs.getString("ROM_TOTAL_PAYABLE"));
				JsonObject.put("totalPayableRom", rs.getString("TOTAL_PAYABLE"));
				JsonObject.put("tripCount", rs.getString("TRIP_COUNT"));
				JsonObject.put("bargeTripCount", rs.getString("BARGE_TRIP_COUNT"));
				JsonObject.put("rmCount", rs.getString("RM_COUNT"));
				JsonObject.put("srcTypeIndex", rs.getString("SRC_TYPE"));
				JsonObject.put("mineralType", rs.getString("MINERAL_TYPE"));
				JsonObject.put("processingFee", rs.getString("TOTAL_PROCESSING_FEE"));
				JsonArray.put(JsonObject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return JsonArray;
	}

	public String closePermitClosuredetails(int customerId, int systemId, int tcid, String permitno, String permitdate,
			int userId, String closedqty, String permitQty, float tripsheetqty, float romAmt, String permitName,
			float romQty, String orgCode, String totalPayableRom, String srcTypeClose, String mineralType,
			String processingFee, String refundType) {
		Connection con = null;
		PreparedStatement pstmt1 = null;
		ResultSet rs1 = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		ResultSet rs2 = null;
		PreparedStatement pstmtUpdate = null;
		String message = "";
		int updated = 0;
		float usedAmt = 0;
		String status = "CLOSE";
		float mplBalance = 0;
		String type = "";
		float qty = 0;
		String stockType = "0";
		String sourceType = "";
		String sourceType1 = "";
		try {
			con = DBConnection.getConnectionToDB("AMS");
			con.setAutoCommit(false);
			if (Float.parseFloat(closedqty) == 0 && romQty == 0 && tripsheetqty == 0) {
				status = "CANCEL";
			}
			String walletLinked = "";
			String processingPlant = "";
			pstmt = con.prepareStatement(IronMiningStatement.GET_MPL_BALANCE);
			pstmt.setInt(1, tcid);
			rs2 = pstmt.executeQuery();
			if (rs2.next()) {
				walletLinked = rs2.getString("WALLET_LINK");
				processingPlant = rs2.getString("PROCESSING_PLANT");
			}
			updated = util.updatePermitClosureDetails(permitno, userId, closedqty, permitQty, refundType, con, status);
			if (updated > 0) {
				message = "Closed Successfully";
				pstmt = con.prepareStatement(IronMiningStatement.GET_ORG_NO_BASED_ON_TCNO);
				pstmt.setInt(1, systemId);
				pstmt.setInt(2, customerId);
				pstmt.setInt(3, tcid);
				rs = pstmt.executeQuery();
				if (rs.next()) {
					orgCode = rs.getString("ORG_ID");
				}
				if ((permitName.startsWith("RTP") && srcTypeClose.equalsIgnoreCase("E-Wallet")
						&& status.equalsIgnoreCase("CLOSE"))) {
					//if(walletLinked.equalsIgnoreCase("ROM") && processingPlant.equalsIgnoreCase("NO")){
					if (romQty == 0) {
						usedAmt = Float.parseFloat(totalPayableRom);
						mplBalance = Float.parseFloat(permitQty) - Float.parseFloat(closedqty);
					} else {
						usedAmt = romAmt;
						mplBalance = Float.parseFloat(permitQty) - Float.parseFloat(closedqty);
					}
					util.updateEWalletForROMClosure(tcid, con, usedAmt, mplBalance);

				}
				if (permitName.startsWith("IE") || permitName.startsWith("DE") || permitName.startsWith("POT")
						|| permitName.startsWith("POST")) {
					pstmt1 = con.prepareStatement(IronMiningStatement.GET_DETAILS_FROM_PROCESSED_ORE_PERMIT_DETAILS);
					pstmt1.setInt(1, Integer.parseInt(permitno));
					rs1 = pstmt1.executeQuery();
					if (rs1.next()) {
						type = rs1.getString("TYPE");
						sourceType1 = rs1.getString("SOURCE_TYPE");
						if (sourceType1 != null) {
							sourceType = rs1.getString("SOURCE_TYPE");
						}
						qty = Float.parseFloat(permitQty) - Float.parseFloat(closedqty);
						stockType = rs1.getString("STOCK_TYPE");
						float lumps = 0;
						float fines = 0;
						float totalqty = 0;
						float concentrates = 0;
						float tailings = 0;
						if (type.equalsIgnoreCase("Fines")) {
							fines = qty;
						} else if (type.equalsIgnoreCase("Lumps")) {
							lumps = qty;
						} else if (type.equalsIgnoreCase("Concentrates")) {
							concentrates = qty;
						} else if (type.equalsIgnoreCase("tailings")) {
							tailings = qty;
						} else {
							totalqty = qty;
						}
						if (sourceType.equalsIgnoreCase("PLANT")) {
							util.updateOrgDetails(customerId, systemId, con, stockType, lumps, fines, concentrates,
									tailings);
						} else if (sourceType.equalsIgnoreCase("STOCK")) {
							util.updateStockDetailsForPermitClosure(fines, lumps, concentrates, tailings, customerId,
									systemId, orgCode, mineralType, con, totalqty, stockType);
						}
					}
				}
				if (permitName.startsWith("RTP") && srcTypeClose.equalsIgnoreCase("ROM")) {
					pstmt1 = con.prepareStatement(IronMiningStatement.GET_DETAILS_FROM_PROCESSED_ORE_PERMIT_DETAILS);
					pstmt1.setInt(1, Integer.parseInt(permitno));
					rs1 = pstmt1.executeQuery();
					if (rs1.next()) {
						type = rs1.getString("TYPE");
						sourceType1 = rs1.getString("SOURCE_TYPE");
						if (sourceType1 != null) {
							sourceType = rs1.getString("SOURCE_TYPE");
						}
						qty = Float.parseFloat(permitQty) - Float.parseFloat(closedqty);
						stockType = rs1.getString("STOCK_TYPE");

						util.updateStockDetailsForPermitClosure(0, 0, 0, 0, customerId, systemId, orgCode, mineralType,
								con, qty, stockType);
					}
				}
				if (permitName.startsWith("PRSTP")) {
					qty = Float.parseFloat(permitQty) - Float.parseFloat(closedqty);
					util.updatePRQuantityInOrgmaster(Integer.parseInt(orgCode), con, qty);

					pstmt1 = con.prepareStatement(IronMiningStatement.GET_DETAILS_FROM_MINING_PERMIT_DETAILS);
					pstmt1.setInt(1, Integer.parseInt(permitno));
					rs1 = pstmt1.executeQuery();
					if (rs1.next()) {
						pstmt = con.prepareStatement(IronMiningStatement.UPDATE_STATUS_FOR_PRSTP_AS_APPROVE_PERMIT);
						pstmt.setString(1, rs1.getString("EXISTING_PERMIT_ID"));
						pstmt.executeUpdate();
					}

				}

				if (permitName.startsWith("RS")) {
					qty = Float.parseFloat(permitQty) - Float.parseFloat(closedqty);
					if (srcTypeClose.equalsIgnoreCase("ROM")) {
						pstmt1 = con
								.prepareStatement(IronMiningStatement.GET_DETAILS_FROM_PROCESSED_ORE_PERMIT_DETAILS);
						pstmt1.setInt(1, Integer.parseInt(permitno));
						rs1 = pstmt1.executeQuery();
						if (rs1.next()) {
							type = rs1.getString("TYPE");
							sourceType1 = rs1.getString("SOURCE_TYPE");
							if (sourceType1 != null) {
								sourceType = rs1.getString("SOURCE_TYPE");
							}
							stockType = rs1.getString("STOCK_TYPE");
						}
						util.updateStockDetailsForPermitClosure(0, 0, 0, 0, customerId, systemId, orgCode, mineralType,
								con, qty, stockType);
					}
					pstmt = con.prepareStatement(IronMiningStatement.UPDATE_TRIPSHEET_QTY_FOR_PERMIT_CLOSURE);
					pstmt.setInt(1, Integer.parseInt(permitno));
					pstmt.executeUpdate();

					int buyingOrgCode = 0;
					pstmt1 = con.prepareStatement(IronMiningStatement.GET_DETAILS_FROM_MINING_PERMIT_DETAILS);
					pstmt1.setInt(1, Integer.parseInt(permitno));
					rs1 = pstmt1.executeQuery();
					if (rs1.next()) {
						buyingOrgCode = rs1.getInt("BUYING_ORG_ID");
					}

					pstmt = con.prepareStatement(IronMiningStatement.UPDATE_PR_FOR_ORG);
					pstmt.setFloat(1, qty);
					pstmt.setInt(2, buyingOrgCode);
					pstmt.executeUpdate();
				}
				if (status.equalsIgnoreCase("cancel") && refundType.equalsIgnoreCase("Refundable")) {
					util.updateProcessingFeeInOrgMaster(customerId, systemId, orgCode, processingFee, con);

					pstmt = con.prepareStatement(IronMiningStatement.GET_DETAILS_FROM_PROCESSED_ORE_PERMIT_DETAILS,
							ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
					pstmt.setInt(1, Integer.parseInt(permitno));
					rs = pstmt.executeQuery();
					if (rs.next()) {
						rs.updateFloat("PROCESSING_FEE", 0);
						rs.updateFloat("TOTAL_PROCESSING_FEE", 0);
						rs.updateRow();
					}
				}
			}
			con.commit();
		} catch (Exception e) {
			System.out.println("error in :-update Permit Closure details " + e.toString());
			e.printStackTrace();
			try {
				if (con != null) {
					con.rollback();
				}
			} catch (SQLException e1) {
				e1.printStackTrace();
			}
		}

		finally {
			DBConnection.releaseConnectionToDB(null, pstmt, rs2);
			DBConnection.releaseConnectionToDB(con, pstmt1, rs);
		}
		return message;
	}

	//-----------------------------------get Trip Details for Trip Generation----------------------------------//
	public JSONArray getTripDetails(String clientId, int systemId, int userId) {
		JSONArray JsonArray = new JSONArray();
		JSONObject JsonObject = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		float actualQuantity = 0;
		float covertTotons = 0;
		DecimalFormat df = new DecimalFormat("#.###");
		try {
			JsonArray = new JSONArray();
			JsonObject = new JSONObject();
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(IronMiningStatement.GET_TRIP_DETAILS);
			pstmt.setInt(1, userId);
			pstmt.setInt(2, systemId);
			pstmt.setString(3, clientId);
			pstmt.setInt(4, userId);
			pstmt.setInt(5, systemId);
			pstmt.setString(6, clientId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				JsonObject = new JSONObject();
				JsonObject.put("userSettingId", rs.getInt("ID"));
				JsonObject.put("sHubId", rs.getString("SOURCE_HUBID"));
				JsonObject.put("dHubId", rs.getString("DESTINATION_HUBID"));
				JsonObject.put("type", rs.getString("TYPE"));
				JsonObject.put("closingType", rs.getString("CLOSING_TYPE"));
				JsonObject.put("bargeLocId", rs.getInt("BARGE_LOC_ID"));
				JsonArray.put(JsonObject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}

		return JsonArray;
	}

	public JSONArray getTripDetailsForTare(String clientId, int systemId, int userId) {
		JSONArray JsonArray = new JSONArray();
		JSONObject JsonObject = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			JsonArray = new JSONArray();
			JsonObject = new JSONObject();
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(IronMiningStatement.GET_TRIP_DETAILS_FOR_TARE);
			pstmt.setInt(1, userId);
			pstmt.setInt(2, systemId);
			pstmt.setString(3, clientId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				JsonObject = new JSONObject();
				JsonObject.put("routeId", rs.getString("ROUTE_ID"));
				JsonObject.put("routeName", rs.getString("ROUTE_NAME"));
				JsonObject.put("tcId", rs.getString("TC_ID"));
				JsonObject.put("lesseName", rs.getString("TC_LEASE_NAME"));
				JsonArray.put(JsonObject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}

		return JsonArray;
	}

	public JSONArray getVehicleDetailsForTare(String clientId, int systemId, int userId, String buttonValue) {
		JSONArray JsonArray = new JSONArray();
		JSONObject JsonObject = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		PreparedStatement pstmtop = null;
		ResultSet rs1 = null;
		String permitNo = "";
		int destinationHubId = 0;
		SimpleDateFormat diffddMMyyyyHHmmss = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
		try {
			JsonArray = new JSONArray();
			JsonObject = new JSONObject();
			con = DBConnection.getConnectionToDB("AMS");
			pstmtop = con.prepareStatement(IronMiningStatement.GET_PERMIT_NO_FOR_TS);
			pstmtop.setInt(1, systemId);
			pstmtop.setString(2, clientId);
			pstmtop.setInt(3, userId);
			rs1 = pstmtop.executeQuery();
			while (rs1.next()) {
				JsonObject = new JSONObject();
				permitNo = rs1.getString("PERMIT_IDS");
				destinationHubId = rs1.getInt("DESTINATION_HUBID");
			}
			if (!permitNo.equals("")) {
				String query = null;
				if (buttonValue.equalsIgnoreCase("tareWeight")) {
					query = IronMiningStatement.GET_VEHICLE_DETAILS_FOR_TARE
							.replace("(#)", "(#) and rd.DESTINATION_HUB_ID=" + destinationHubId).replace("#", permitNo);
				} else {
					query = IronMiningStatement.GET_VEHICLE_DETAILS_FOR_CLOSE_TRIP
							.replace("(#)", "(#) and rd.DESTINATION_HUB_ID=" + destinationHubId).replace("#", permitNo);
				}
				//System.out.println(query);
				pstmt = con.prepareStatement(query);
				pstmt.setInt(1, systemId);
				pstmt.setString(2, clientId);
				rs = pstmt.executeQuery();
				while (rs.next()) {
					JsonObject = new JSONObject();
					JsonObject.put("tcNo", rs.getString("LESSE_NAME"));
					JsonObject.put("tripName", rs.getString("Trip_Name"));
					JsonObject.put("vehicleName", rs.getString("ASSET_NUMBER"));
					JsonObject.put("validityDate", diffddMMyyyyHHmmss.format(rs.getTimestamp("VALIDITY_DATE")));
					JsonObject.put("grade", rs.getString("GRADE"));
					JsonObject.put("orgName", rs.getString("ORGANIZATION_NAME"));
					JsonObject.put("grossWeight", rs.getString("GROSS_WEIGHT_S"));
					JsonObject.put("tareWeight", rs.getString("TARE_WEIGHT_S"));
					JsonObject.put("tripNo", rs.getInt("ID"));
					JsonObject.put("tripSheetNo", rs.getString("TRIP_NO"));
					JsonObject.put("grossWeightDest", rs.getString("GROSS_WEIGHT_D"));
					JsonObject.put("tareWeightDest", rs.getString("TARE_WEIGHT_D"));
					JsonObject.put("loadCapacity", rs.getString("LOADCAPACITY"));

					JsonArray.put(JsonObject);
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(null, pstmtop, rs1);
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}

		return JsonArray;
	}

	public String saveTripSheetDetailsInformationForTare(int customerId, String assetNo, String quantity,
			String validityDateTime, String grade, int userId, int systemId, String closingType, String closeQuantity,
			String type, int tripNo, String closeReason, String sessionid) {

		String message = "";
		Connection conAdmin = null;
		PreparedStatement pstmt55 = null;
		PreparedStatement pstmt66 = null;
		ResultSet rs = null;
		ResultSet rs55 = null;
		PreparedStatement pstmt = null;
		int permitId = 0;
		String permittype = "";
		String mineraltype = "";
		int buyOrgId = 0;
		int routeId = 0;
		String gradeType = "";
		int orgCode = 0;
		int tcId = 0;
		float netQty = 0;
		LogWriter logWriter = null;
		String destType = "";
		String srcType = "";
		String lastCommDate = "";
		String lastCommLoc = "";
		String operationType = "";
		String tableName = "";
		try {
			int inserted = 0;
			Properties properties = ApplicationListener.prop;
			String logFile = properties.getProperty("LogFileForCloseTripForDestinationWeight");
			String logFileName = logFile.substring(0, logFile.lastIndexOf("."));
			String logFileExt = logFile.substring(logFile.lastIndexOf(".") + 1, logFile.length());
			logFile = logFileName + "-" + sdf.format(new Date()) + "." + logFileExt;

			PrintWriter pw;

			if (logFile != null) {
				try {
					pw = new PrintWriter(new FileWriter(logFile, true), true);
					logWriter = new LogWriter(
							"saveTripSheetDetailsInformationForTare" + "-- " + sessionid + "--" + userId,
							LogWriter.INFO, pw);
					;
					logWriter.setPrintWriter(pw);
				} catch (IOException e) {
					logWriter.log("Can't open the log file: " + logFile + ". Using System.err instead",
							LogWriter.ERROR);
				}
			}
			conAdmin = DBConnection.getConnectionToDB("AMS");
			logWriter.log(" Begining of the method ", LogWriter.INFO);
			logWriter.log(
					"CLOSING TYPE == " + closingType + " ASSET NO== " + assetNo + " TRIP NO== " + tripNo
							+ " CLOSE QTY== " + closeQuantity + " TYPE" + type + " USER ID== " + userId,
					LogWriter.INFO);
			if (closingType.equals("Close w/o Tare @ D")) {
				tableName = "AMS.dbo.TRIP_SHEET_USER_SETTINGS";
				rs = util.getPermitNo(customerId, userId, systemId, conAdmin);
				while (rs.next()) {
					if (rs.getString("OPERATION_TYPE").equalsIgnoreCase("R")) {
						operationType = "RFID";
					} else if (rs.getString("OPERATION_TYPE").equalsIgnoreCase("A")) {
						operationType = "APPLICATION";
					} else if (rs.getString("OPERATION_TYPE").equalsIgnoreCase("B")) {
						operationType = "BOTH";
					}
				}
				logWriter.log(" operational Type " + operationType, LogWriter.INFO);
				if (!operationType.equalsIgnoreCase("BOTH") && !operationType.equalsIgnoreCase(type)) {
					message = "select Valid Operation Type";
				} else {
					tableName = "AMS.dbo.gpsdata_history_latest";
					rs = util.getCurrentLocation(customerId, assetNo, systemId, conAdmin);
					if (rs.next()) {
						lastCommLoc = rs.getString("LOCATION");
						lastCommDate = rs.getString("GPS_DATETIME");
					}
					logWriter.log("last communication date =" + lastCommDate + "Last comm location == " + lastCommLoc,
							LogWriter.INFO);
					tableName = "MINING.dbo.TRUCK_TRIP_DETAILS";
					inserted = util.updateQuantityForTareAndCloseTrip(assetNo, quantity, userId, closingType,
							closeQuantity, type, tripNo, closeReason, conAdmin, lastCommDate, lastCommLoc);
					if (inserted > 0) {
						tableName = "MINING.dbo.TRUCK_TRIP_DETAILS";
						pstmt = conAdmin.prepareStatement(IronMiningStatement.GET_PERMIT_ID);
						pstmt.setInt(1, tripNo);
						rs = pstmt.executeQuery();
						if (rs.next()) {
							permitId = rs.getInt("PERMIT_ID");
							netQty = rs.getFloat("NET_WEIGHT");
						}
						logWriter.log(" net Quantity == " + netQty + " PERMIT ID == " + permitId, LogWriter.INFO);

						tableName = "AMS.dbo.PROCESSED_ORE_PERMIT_DETAILS";
						pstmt = conAdmin.prepareStatement(IronMiningStatement.GET_PERMIT_DETAILS_FOR_CLOSE);
						pstmt.setInt(1, permitId);
						pstmt.setInt(2, systemId);
						pstmt.setInt(3, customerId);
						rs = pstmt.executeQuery();
						if (rs.next()) {
							buyOrgId = rs.getInt("BUYING_ORG_ID");
							permittype = rs.getString("PERMIT_TYPE");
							mineraltype = rs.getString("MINERAL");
							routeId = rs.getInt("ROUTE_ID");
							gradeType = rs.getString("TYPE");
							orgCode = rs.getInt("ORGANIZATION_ID");
							tcId = rs.getInt("TC_ID");
							destType = rs.getString("DEST_TYPE");
							srcType = rs.getString("SRC_TYPE");
						}
						if (permittype.equalsIgnoreCase("Import Transit Permit")) {
							logWriter.log(" Inside Import updation method", LogWriter.INFO);
							float impFines = 0;
							float impLumps = 0;
							float impConc = 0;
							float impTailings = 0;
							if (gradeType.equalsIgnoreCase("FINES")) {
								impFines = netQty;
							} else if (gradeType.equalsIgnoreCase("LUMPS")) {
								impLumps = netQty;
							} else if (gradeType.equalsIgnoreCase("CONCENTRATES")) {
								impConc = netQty;
							} else if (gradeType.equalsIgnoreCase("TAILINGS")) {
								impTailings = netQty;
							}
							logWriter.log(
									"Imported fines== " + impFines + " imported Lumps== " + impLumps
											+ " imported Conc== " + impConc + " imported Tailings== " + impTailings,
									LogWriter.INFO);
							tableName = "AMS.dbo.MINING_ORGANIZATION_MASTER";
							util.updateImportQuantityInOrgMaster(conAdmin, orgCode, impFines, impLumps, impConc,
									impTailings);
						}
						int destinationhub = 0;
						if (permittype.equalsIgnoreCase("Processed Ore Transit")
								|| permittype.equalsIgnoreCase("Bauxite Transit")
								|| permittype.equalsIgnoreCase("Processed Ore Sale Transit")
								|| permittype.equalsIgnoreCase("Rom Transit")
								|| permittype.equalsIgnoreCase("Purchased Rom Sale Transit Permit")) {

							logWriter.log(" Inside stock updation method", LogWriter.INFO);
							tableName = "MINING.dbo.ROUTE_DETAILS";
							pstmt55 = conAdmin.prepareStatement(IronMiningStatement.GET_DESTINATION_FROM_ROUTE);
							pstmt55.setInt(1, systemId);
							pstmt55.setInt(2, customerId);
							pstmt55.setInt(3, routeId);
							rs55 = pstmt55.executeQuery();
							if (rs55.next()) {
								destinationhub = rs55.getInt("End_Hubid");
							}
						}
						if (destinationhub > 0) {
							if ((permittype.equalsIgnoreCase("Bauxite Transit")
									|| (permittype.equalsIgnoreCase("Rom Transit")
											&& srcType.equalsIgnoreCase("E-Wallet")))
									&& orgCode == 0) {
								tableName = "AMS.dbo.MINING_ORGANIZATION_MASTER";
								pstmt55 = null;
								pstmt55 = conAdmin.prepareStatement(IronMiningStatement.GET_ORG_NO_BASED_ON_TCNO);
								pstmt55.setInt(1, systemId);
								pstmt55.setInt(2, customerId);
								pstmt55.setInt(3, tcId);
								rs55 = pstmt55.executeQuery();
								if (rs55.next()) {
									orgCode = rs55.getInt("ORG_ID");
								}
							}
							if (permittype.equalsIgnoreCase("Processed Ore Sale Transit")) {
								orgCode = buyOrgId;
							}
							if (permittype.equalsIgnoreCase("Rom Transit")
									|| permittype.equalsIgnoreCase("Purchased Rom Sale Transit Permit")) {
								if (destType.equalsIgnoreCase("plant") || permittype.equalsIgnoreCase("Rom Transit")) {
									tableName = "MINING.dbo.PLANT_MASTER";
									int plantId = 0;
									pstmt55 = null;
									pstmt55 = conAdmin.prepareStatement(IronMiningStatement.GET_PLANT_NAMES
											.concat("and HUB_ID=? and MINERAL_TYPE=? "));
									pstmt55.setInt(1, systemId);
									pstmt55.setInt(2, customerId);
									pstmt55.setInt(3, orgCode);
									pstmt55.setInt(4, destinationhub);
									pstmt55.setString(5, mineraltype);
									rs55 = pstmt55.executeQuery();
									if (rs55.next()) {
										plantId = rs55.getInt("ID");
									}
									tableName = "MINING.dbo.PLANT_MASTER";
									util.updateROMQuantityInPlantMaster(customerId, systemId, conAdmin, mineraltype,
											netQty, plantId);
								}
								if (destType.equalsIgnoreCase("stock")) {
									tableName = "AMS.dbo.MINING_STOCKYARD_MASTER";
									pstmt55 = null;
									pstmt55 = conAdmin.prepareStatement(IronMiningStatement.GET_STOCK_DETAILS,
											ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
									pstmt55.setInt(1, systemId);
									pstmt55.setInt(2, customerId);
									pstmt55.setInt(3, destinationhub);
									pstmt55.setInt(4, orgCode);
									pstmt55.setString(5, mineraltype);
									rs55 = pstmt55.executeQuery();
									if (rs55.next()) {
										//									rs55.updateFloat("ROM_QTY", rs55.getFloat("ROM_QTY")+ netQty);
										//									rs55.updateRow();
										tableName = "AMS.dbo.MINING_STOCKYARD_MASTER";
										util.updateROMQuantityInMaster(customerId, systemId, conAdmin, mineraltype,
												orgCode, netQty, destinationhub);
										logWriter.log("Record updated in stock master for purchased rom sale transit",
												LogWriter.INFO);
									} else {
										tableName = "AMS.dbo.MINING_STOCKYARD_MASTER";
										util.insertStockDetailsForROM(customerId, systemId, conAdmin, mineraltype,
												orgCode, netQty, destinationhub);
										logWriter.log("Record inserted in stock master for purchased rom sale transit",
												LogWriter.INFO);
									}
								}
							}
							if (permittype.equalsIgnoreCase("Processed Ore Transit")
									|| permittype.equalsIgnoreCase("Bauxite Transit")
									|| permittype.equalsIgnoreCase("Processed Ore Sale Transit")) {
								float fines = 0;
								float lumps = 0;
								float concentrates = 0;
								float tailings = 0;
								float totalqty = 0;
								if (gradeType.equalsIgnoreCase("FINES")) {
									fines = netQty;
								} else if (gradeType.equalsIgnoreCase("LUMPS")) {
									lumps = netQty;
								} else if (gradeType.equalsIgnoreCase("CONCENTRATES")) {
									concentrates = netQty;
								} else if (gradeType.equalsIgnoreCase("TAILINGS")) {
									tailings = netQty;
								} else {
									totalqty = netQty;
								}
								logWriter.log(" Before stock updation fines== " + fines + " Lumps== " + lumps
										+ " concentrates== " + concentrates + " tailings== " + tailings + " totalqty== "
										+ totalqty + " orgCode == " + orgCode + " mineraltype== " + mineraltype
										+ "destinationhub== " + destinationhub, LogWriter.INFO);
								tableName = "AMS.dbo.MINING_STOCKYARD_MASTER";
								pstmt55 = null;
								pstmt55 = conAdmin.prepareStatement(IronMiningStatement.GET_STOCK_DETAILS,
										ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
								pstmt55.setInt(1, systemId);
								pstmt55.setInt(2, customerId);
								pstmt55.setInt(3, destinationhub);
								pstmt55.setInt(4, orgCode);
								pstmt55.setString(5, mineraltype);
								rs55 = pstmt55.executeQuery();
								if (rs55.next()) {
									tableName = "AMS.dbo.MINING_STOCKYARD_MASTER";
									util.updateMiningStockYardMaster(customerId, systemId, conAdmin, mineraltype,
											orgCode, destinationhub, fines, lumps, concentrates, tailings, totalqty);

									logWriter.log("Record updated in stock master", LogWriter.INFO);
								} else {
									tableName = "AMS.dbo.MINING_STOCKYARD_MASTER";
									util.insertIntoStockYardMaster(customerId, systemId, conAdmin, mineraltype, orgCode,
											destinationhub, fines, lumps, concentrates, tailings, totalqty);
									logWriter.log("Record inserted in stock master", LogWriter.INFO);
								}
							}
						}
						tableName = "AMS.dbo.MINING_ASSET_ENROLLMENT";
						util.updateTripStatusInAssetEnrollment(customerId, assetNo, systemId, conAdmin, "CLOSE");
						logWriter.log("Updated Trip Status in Asset Enrollment", LogWriter.INFO);
					}
				}
			} else {
				tableName = "MINING.dbo.TRUCK_TRIP_DETAILS";
				inserted = util.updateQuantiryForTare(assetNo, quantity, conAdmin);
				logWriter.log("Updated Status for close w Tare @ D", LogWriter.INFO);
				logWriter.log("User Id== " + userId, LogWriter.INFO);
			}
			if (inserted > 0) {
				if (closingType.equals("Close w/o Tare @ D")) {
					logWriter.log("Destination Weight Saved and Trip Closed Successfully", LogWriter.INFO);
					message = "Destination Weight Saved and Trip Closed Successfully";
				} else {
					logWriter.log("Destination Weight Saved Successfully", LogWriter.INFO);
					message = "Destination Weight Saved Successfully";
				}
			} else {
				logWriter.log("Error in Saving Tare Weight", LogWriter.INFO);
				message = "Error in Saving Tare Weight";
			}
		} catch (Exception e) {
			StringWriter errors = new StringWriter();
			e.printStackTrace(new PrintWriter(errors));
			logWriter.log(errors.toString(), LogWriter.ERROR);
			System.out.println("error in Tare Weight :-save Tare Weight" + e.toString());
			e.printStackTrace();
			if (conAdmin != null) {
				try {
					pstmt55 = conAdmin.prepareStatement(
							"insert into AMS.dbo.EmailQueue(Subject,Body,EmailList,SystemId) values (?,?,?,?)");
					pstmt55.setString(1, "error in saveTripSheetDetailsInformationForTare for SystemId " + systemId
							+ " for Table Name :" + tableName);
					pstmt55.setString(2, errors.toString());
					pstmt55.setString(3,
							"gayatri.p@telematics4u.com,praveen.c@telematics4u.com,namrata.d@telematics4u.com");
					pstmt55.setInt(4, systemId);
					pstmt55.executeUpdate();
					logWriter.log("Record inserted in EmailQueue", LogWriter.INFO);
				} catch (SQLException e1) {
					errors = new StringWriter();
					e1.printStackTrace(new PrintWriter(errors));
					logWriter.log(errors.toString(), LogWriter.ERROR);
					e1.printStackTrace();
				}
			}
		} finally {
			DBConnection.releaseConnectionToDB(conAdmin, pstmt55, rs55);
			DBConnection.releaseConnectionToDB(null, pstmt, null);
			DBConnection.releaseConnectionToDB(null, pstmt66, null);
		}
		logWriter.log(" Ending of the method ", LogWriter.INFO);
		return message;
	}

	public JSONArray getRFIDForTare(String clientId, int systemId, String rfidNumber, String buttonValue, int userId) {
		JSONArray JsonArray = new JSONArray();
		JSONObject JsonObject = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String vehicleNo = "";
		String lesseName = "";
		String TripName = "";
		String validityDate = "";
		String grade = "";
		String orgName = "";
		String grossWeight = "";
		String tareWeight = "";
		PreparedStatement pstmtop = null;
		ResultSet rs1 = null;
		String permitNo = "";
		int destinationHubId = 0;
		SimpleDateFormat diffddMMyyyyHHmmss = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
		int tripId = 0;
		String grossWeightDest = "";
		String loadCapacity = "";
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmtop = con.prepareStatement(IronMiningStatement.GET_PERMIT_NO_FOR_TS);
			pstmtop.setInt(1, systemId);
			pstmtop.setString(2, clientId);
			pstmtop.setInt(3, userId);
			rs1 = pstmtop.executeQuery();
			while (rs1.next()) {
				permitNo = rs1.getString("PERMIT_IDS");
				destinationHubId = rs1.getInt("DESTINATION_HUBID");
			}
			if (!permitNo.equals("")) {
				String query = null;
				if (buttonValue.equalsIgnoreCase("closetrip")) {
					query = IronMiningStatement.GET_VEHICLE_NUMBER_BASED_ON_RFID_FOR_CLOSE
							.replace("(#)", "(#) and rd.DESTINATION_HUB_ID=" + destinationHubId)
							.replaceAll("#", permitNo);
				} else {
					query = IronMiningStatement.GET_VEHICLE_NUMBER_BASED_ON_RFID_FOR_TARE
							.replace("(#)", "(#) and rd.DESTINATION_HUB_ID=" + destinationHubId)
							.replaceAll("#", permitNo);
				}
				pstmt = con.prepareStatement(query);
				pstmt.setInt(1, systemId);
				pstmt.setString(2, clientId);
				pstmt.setString(3, rfidNumber);
				rs = pstmt.executeQuery();
				while (rs.next()) {
					vehicleNo = rs.getString("ASSET_NUMBER");
					lesseName = rs.getString("LESSE_NAME");
					TripName = rs.getString("Trip_Name");
					grade = rs.getString("GRADE");
					validityDate = diffddMMyyyyHHmmss.format(rs.getTimestamp("VALIDITY_DATE"));
					orgName = rs.getString("ORGANIZATION_NAME");
					grossWeight = rs.getString("GROSS_WEIGHT_S");
					tareWeight = rs.getString("TARE_WEIGHT_S");
					tripId = rs.getInt("ID");
					grossWeightDest = rs.getString("GROSS_WEIGHT_D");
					loadCapacity = rs.getString("LOADCAPACITY");
				}
				JsonObject = new JSONObject();
				JsonObject.put("jsonString", vehicleNo);
				JsonObject.put("lesseName", lesseName);
				JsonObject.put("routeName", TripName);
				JsonObject.put("grade", grade);
				JsonObject.put("validityDate", validityDate);
				JsonObject.put("orgName", orgName);
				JsonObject.put("tareWeight", tareWeight);
				JsonObject.put("grossWeight", grossWeight);
				JsonObject.put("tripNo", tripId);
				JsonObject.put("grossWeightDestRfid", grossWeightDest);
				JsonObject.put("loadCapacity", loadCapacity);
				JsonArray.put(JsonObject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(null, pstmtop, rs1);
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return JsonArray;
	}

	public String saveTripSheetDetailsInformationForCloseTrip(int customerId, String assetNo, String quantity,
			String validityDateTime, String grade, int userId, int systemId, String tareqty, String grossQty,
			String buttonValue, String closingType, String type, int tripNo, String closeReason, String sessionid) {

		String message = "";
		Connection conAdmin = null;
		PreparedStatement pstmt55 = null;
		PreparedStatement pstmt = null;
		PreparedStatement pstmt66 = null;
		ResultSet rs55 = null;
		ResultSet rs = null;
		int permitId = 0;
		String permittype = "";
		String mineraltype = "";
		float tripsheetQty = 0;
		int buyOrgId = 0;
		int routeId = 0;
		String gradeType = "";
		int orgCode = 0;
		int tcId = 0;
		float netQty = 0;
		LogWriter logWriter = null;
		String destType = "";
		String srcType = "";
		String lastCommLoc = "";
		String lastCommDate = "";
		String operationType = "";
		String tableName = "";
		try {
			int inserted = 0;
			Properties properties = ApplicationListener.prop;
			String logFile = properties.getProperty("LogFileForCloseTripForManualClose");
			String logFileName = logFile.substring(0, logFile.lastIndexOf("."));
			String logFileExt = logFile.substring(logFile.lastIndexOf(".") + 1, logFile.length());
			logFile = logFileName + "-" + sdf.format(new Date()) + "." + logFileExt;

			PrintWriter pw;

			if (logFile != null) {
				try {
					pw = new PrintWriter(new FileWriter(logFile, true), true);
					logWriter = new LogWriter(
							"saveTripSheetDetailsInformationForCloseTrip" + "-- " + sessionid + "--" + userId,
							LogWriter.INFO, pw);
					;
					logWriter.setPrintWriter(pw);
				} catch (IOException e) {
					logWriter.log("Can't open the log file: " + logFile + ". Using System.err instead",
							LogWriter.ERROR);
				}
			}
			conAdmin = DBConnection.getConnectionToDB("AMS");
			logWriter.log(" Begining of the method ", LogWriter.INFO);
			logWriter.log("BUTTON VALUE == " + buttonValue + " CLOSING TYPE == " + closingType + " ASSET NO== "
					+ assetNo + " TRIP NO== " + tripNo + " TYPE" + type, LogWriter.INFO);
			tableName = "AMS.dbo.TRIP_SHEET_USER_SETTINGS";
			pstmt = conAdmin.prepareStatement(
					IronMiningStatement.GET_PERMIT_NO.replace("and ts.TYPE!='Close'", "and ts.TYPE!='Open'"));
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, customerId);
			pstmt.setInt(3, userId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				if (rs.getString("OPERATION_TYPE").equalsIgnoreCase("R")) {
					operationType = "RFID";
				} else if (rs.getString("OPERATION_TYPE").equalsIgnoreCase("A")) {
					operationType = "APPLICATION";
				} else if (rs.getString("OPERATION_TYPE").equalsIgnoreCase("B")) {
					operationType = "BOTH";
				}
			}
			logWriter.log(" operational Type " + operationType, LogWriter.INFO);
			if (!operationType.equalsIgnoreCase("BOTH") && !operationType.equalsIgnoreCase(type)) {
				message = "Select Valid Operation Type";
			} else {
				if (buttonValue.equals("manualClose")) {
					tableName = "AMS.dbo.gpsdata_history_latest";
					rs = util.getCurrentLocation(customerId, assetNo, systemId, conAdmin);
					if (rs.next()) {
						lastCommLoc = rs.getString("LOCATION");
						lastCommDate = rs.getString("GPS_DATETIME");
					}
					tableName = "MINING.dbo.TRUCK_TRIP_DETAILS";
					inserted = util.updateQuantiryForTareAndTripClose(assetNo, userId, tareqty, grossQty, closingType,
							type, tripNo, conAdmin, lastCommLoc, lastCommDate);
				} else {
					tableName = "AMS.dbo.gpsdata_history_latest";
					rs = util.getCurrentLocation(customerId, assetNo, systemId, conAdmin);
					if (rs.next()) {
						lastCommLoc = rs.getString("LOCATION");
						lastCommDate = rs.getString("GPS_DATETIME");
					}
					tableName = "MINING.dbo.TRUCK_TRIP_DETAILS";
					inserted = util.updatQuantityForClose(assetNo, quantity, userId, closingType, type, tripNo,
							closeReason, conAdmin, lastCommLoc, lastCommDate);
				}
				if (inserted > 0) {
					tableName = "MINING.dbo.TRUCK_TRIP_DETAILS";
					pstmt = conAdmin.prepareStatement(IronMiningStatement.GET_PERMIT_ID);
					pstmt.setInt(1, tripNo);
					rs = pstmt.executeQuery();
					if (rs.next()) {
						permitId = rs.getInt("PERMIT_ID");
						netQty = rs.getFloat("NET_WEIGHT");
					}
					logWriter.log(" net Quantity == " + netQty + " PERMIT ID == " + permitId, LogWriter.INFO);
					tableName = "AMS.dbo.MINING_PERMIT_DETAILS";
					pstmt = conAdmin.prepareStatement(IronMiningStatement.GET_PERMIT_DETAILS_FOR_CLOSE);
					pstmt.setInt(1, permitId);
					pstmt.setInt(2, systemId);
					pstmt.setInt(3, customerId);
					rs = pstmt.executeQuery();
					while (rs.next()) {
						buyOrgId = rs.getInt("BUYING_ORG_ID");
						tripsheetQty = rs.getFloat("TRIPSHEET_QTY");
						permittype = rs.getString("PERMIT_TYPE");
						mineraltype = rs.getString("MINERAL");
						routeId = rs.getInt("ROUTE_ID");
						gradeType = rs.getString("TYPE");
						orgCode = rs.getInt("ORGANIZATION_ID");
						tcId = rs.getInt("TC_ID");
						destType = rs.getString("DEST_TYPE");
						srcType = rs.getString("SRC_TYPE");
					}
					if (permittype.equalsIgnoreCase("Import Transit Permit")) {
						logWriter.log(" Inside Import updation method", LogWriter.INFO);
						float impFines = 0;
						float impLumps = 0;
						float impConc = 0;
						float impTailings = 0;
						if (gradeType.equalsIgnoreCase("FINES")) {
							impFines = netQty;
						} else if (gradeType.equalsIgnoreCase("LUMPS")) {
							impLumps = netQty;
						} else if (gradeType.equalsIgnoreCase("CONCENTRATES")) {
							impConc = netQty;
						} else if (gradeType.equalsIgnoreCase("TAILINGS")) {
							impTailings = netQty;
						}
						logWriter.log("Imported fines== " + impFines + " imported Lumps== " + impLumps
								+ " imported Conc== " + impConc + " imported Tailings== " + impTailings,
								LogWriter.INFO);
						tableName = "AMS.dbo.MINING_ORGANIZATION_MASTER";
						util.updateImportQuantiryInOrgMaster(conAdmin, orgCode, impFines, impLumps, impConc,
								impTailings);
					}
					int destinationhub = 0;
					if (permittype.equalsIgnoreCase("Processed Ore Transit")
							|| permittype.equalsIgnoreCase("Bauxite Transit")
							|| permittype.equalsIgnoreCase("Processed Ore Sale Transit")
							|| permittype.equalsIgnoreCase("Rom Transit")
							|| permittype.equalsIgnoreCase("Purchased Rom Sale Transit Permit")) {

						logWriter.log(" Inside stock updation method", LogWriter.INFO);
						tableName = "MINING.dbo.ROUTE_DETAILS";
						pstmt55 = conAdmin.prepareStatement(IronMiningStatement.GET_DESTINATION_FROM_ROUTE);
						pstmt55.setInt(1, systemId);
						pstmt55.setInt(2, customerId);
						pstmt55.setInt(3, routeId);
						rs55 = pstmt55.executeQuery();
						if (rs55.next()) {
							destinationhub = rs55.getInt("End_Hubid");
						}
					}
					if (destinationhub > 0) {
						if ((permittype.equalsIgnoreCase("Bauxite Transit")
								|| (permittype.equalsIgnoreCase("Rom Transit") && srcType.equalsIgnoreCase("E-Wallet")))
								&& orgCode == 0) {
							pstmt55 = null;
							tableName = "AMS.dbo.MINING_ORGANIZATION_MASTER";
							pstmt55 = conAdmin.prepareStatement(IronMiningStatement.GET_ORG_NO_BASED_ON_TCNO);
							pstmt55.setInt(1, systemId);
							pstmt55.setInt(2, customerId);
							pstmt55.setInt(3, tcId);
							rs55 = pstmt55.executeQuery();
							if (rs55.next()) {
								orgCode = rs55.getInt("ORG_ID");
							}
						}
						if (permittype.equalsIgnoreCase("Processed Ore Sale Transit")) {
							orgCode = buyOrgId;
						}
						if (permittype.equalsIgnoreCase("Rom Transit")
								|| permittype.equalsIgnoreCase("Purchased Rom Sale Transit Permit")) {
							if (destType.equalsIgnoreCase("plant") || permittype.equalsIgnoreCase("Rom Transit")) {
								int plantId = 0;
								pstmt55 = null;
								tableName = "MINING.dbo.PLANT_MASTER";
								pstmt55 = conAdmin.prepareStatement(
										IronMiningStatement.GET_PLANT_NAMES.concat("and HUB_ID=? and MINERAL_TYPE=? "));
								pstmt55.setInt(1, systemId);
								pstmt55.setInt(2, customerId);
								pstmt55.setInt(3, orgCode);
								pstmt55.setInt(4, destinationhub);
								pstmt55.setString(5, mineraltype);
								rs55 = pstmt55.executeQuery();
								if (rs55.next()) {
									plantId = rs55.getInt("ID");
								}
								tableName = "MINING.dbo.PLANT_MASTER";
								util.updateROMQuantityInPlantMaster(customerId, systemId, conAdmin, mineraltype, netQty,
										plantId);

							}
							if (destType.equalsIgnoreCase("stock")) {
								pstmt55 = null;
								tableName = "AMS.dbo.MINING_STOCKYARD_MASTER";
								pstmt55 = conAdmin.prepareStatement(IronMiningStatement.GET_STOCK_DETAILS,
										ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
								pstmt55.setInt(1, systemId);
								pstmt55.setInt(2, customerId);
								pstmt55.setInt(3, destinationhub);
								pstmt55.setInt(4, orgCode);
								pstmt55.setString(5, mineraltype);
								rs55 = pstmt55.executeQuery();
								if (rs55.next()) {
									//								rs55.updateFloat("ROM_QTY", rs55.getFloat("ROM_QTY")+ netQty);
									//								rs55.updateRow();
									tableName = "AMS.dbo.MINING_STOCKYARD_MASTER";
									util.updateROMQuantityInMaster(customerId, systemId, conAdmin, mineraltype, orgCode,
											netQty, destinationhub);
									logWriter.log("Record updated in stock master for purchased rom sale transit",
											LogWriter.INFO);
								} else {
									tableName = "AMS.dbo.MINING_STOCKYARD_MASTER";
									util.insertStockDetailsForROM(customerId, systemId, conAdmin, mineraltype, orgCode,
											netQty, destinationhub);
									logWriter.log("Record inserted in stock master for purchased rom sale transit",
											LogWriter.INFO);
								}
							}
						}
						if (permittype.equalsIgnoreCase("Processed Ore Transit")
								|| permittype.equalsIgnoreCase("Bauxite Transit")
								|| permittype.equalsIgnoreCase("Processed Ore Sale Transit")) {
							float fines = 0;
							float lumps = 0;
							float totalqty = 0;
							float concentrates = 0;
							float tailings = 0;
							if (gradeType.equalsIgnoreCase("FINES")) {
								fines = netQty;
							} else if (gradeType.equalsIgnoreCase("LUMPS")) {
								lumps = netQty;
							} else if (gradeType.equalsIgnoreCase("CONCENTRATES")) {
								concentrates = netQty;
							} else if (gradeType.equalsIgnoreCase("TAILINGS")) {
								tailings = netQty;
							} else {
								totalqty = netQty;
							}
							logWriter.log(" Before stock updation fines== " + fines + " Lumps== " + lumps
									+ " concentrates== " + concentrates + " tailings== " + tailings + " totalqty== "
									+ totalqty + " orgCode == " + orgCode + " mineraltype== " + mineraltype
									+ "destinationhub== " + destinationhub, LogWriter.INFO);
							tableName = "AMS.dbo.MINING_STOCKYARD_MASTER";
							pstmt55 = null;
							pstmt55 = conAdmin.prepareStatement(IronMiningStatement.GET_STOCK_DETAILS,
									ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
							pstmt55.setInt(1, systemId);
							pstmt55.setInt(2, customerId);
							pstmt55.setInt(3, destinationhub);
							pstmt55.setInt(4, orgCode);
							pstmt55.setString(5, mineraltype);
							rs55 = pstmt55.executeQuery();
							if (rs55.next()) {
								tableName = "AMS.dbo.MINING_STOCKYARD_MASTER";
								util.updateMiningStockYardMaster(customerId, systemId, conAdmin, mineraltype, orgCode,
										destinationhub, fines, lumps, concentrates, tailings, totalqty);
								logWriter.log("Record updated in stock master", LogWriter.INFO);
							} else {
								tableName = "AMS.dbo.MINING_STOCKYARD_MASTER";
								util.insertIntoStockYardMaster(customerId, systemId, conAdmin, mineraltype, orgCode,
										destinationhub, fines, lumps, concentrates, tailings, totalqty);
								logWriter.log("Record inserted in stock master", LogWriter.INFO);
							}
						}
					}
					tableName = "AMS.dbo.MINING_ASSET_ENROLLMENT";
					util.updateTripStatusInAssetEnrollment(customerId, assetNo, systemId, conAdmin, "CLOSE");
					logWriter.log("Trip Closed Successfully", LogWriter.INFO);
					message = "Trip Closed Successfully";
				} else {
					message = "Error in Close Trip";
					logWriter.log("Error in Close Trip", LogWriter.INFO);
				}
			}
		} catch (Exception e) {
			StringWriter errors = new StringWriter();
			e.printStackTrace(new PrintWriter(errors));
			logWriter.log(errors.toString(), LogWriter.ERROR);
			System.out.println("error in Close Trip :-save Tare Weight" + e.toString());
			e.printStackTrace();
			if (conAdmin != null) {
				try {
					pstmt55 = conAdmin.prepareStatement(
							"insert into AMS.dbo.EmailQueue(Subject,Body,EmailList,SystemId) values (?,?,?,?)");
					pstmt55.setString(1, "error in saveTripSheetDetailsInformationForCloseTrip for SystemId " + systemId
							+ " for TableName : " + tableName);
					pstmt55.setString(2, errors.toString());
					pstmt55.setString(3,
							"gayatri.p@telematics4u.com,praveen.c@telematics4u.com,namrata.d@telematics4u.com");
					pstmt55.setInt(4, systemId);
					pstmt55.executeUpdate();
					logWriter.log("Record inserted in EmailQueue", LogWriter.INFO);
				} catch (SQLException e1) {
					errors = new StringWriter();
					e1.printStackTrace(new PrintWriter(errors));
					logWriter.log(errors.toString(), LogWriter.ERROR);
					e1.printStackTrace();
				}
			}

		} finally {
			DBConnection.releaseConnectionToDB(conAdmin, pstmt55, rs55);
		}
		logWriter.log(" Ending of the method ", LogWriter.INFO);
		return message;
	}

	public JSONArray getVehicleNoListForTareWeight(String clientId, int systemId) {
		JSONArray JsonArray = new JSONArray();
		JSONObject JsonObject = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			JsonArray = new JSONArray();
			JsonObject = new JSONObject();
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(IronMiningStatement.GET_VEHILCE_NO_FOR_TARE_WEIGHT);
			pstmt.setInt(1, systemId);
			pstmt.setString(2, clientId);

			rs = pstmt.executeQuery();
			while (rs.next()) {
				JsonObject = new JSONObject();
				JsonObject.put("vehicleNoID", rs.getString("VID"));
				JsonObject.put("vehicleName", rs.getString("VNAME"));
				JsonObject.put("UnLadenWeight", rs.getFloat("UN_LADEN_WEIGHT"));
				JsonArray.put(JsonObject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}

		return JsonArray;
	}

	public JSONArray getRFIDForTareWeight(String clientId, int systemId, String rfidNumber) {
		JSONArray JsonArray = new JSONArray();
		JSONObject JsonObject = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String vehicleNo = "";
		//String rfidNumber="";
		try {
			//rfidNumber=getRFIDFromFile(ip);
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(IronMiningStatement.GET_VEHICLE_NUMBER_BASED_ON_RFID_FOR_TARE_WEIGHT);
			pstmt.setInt(1, systemId);
			pstmt.setString(2, clientId);
			pstmt.setString(3, rfidNumber);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				vehicleNo = rs.getString("VehicleNo");
			}
			JsonObject = new JSONObject();
			JsonObject.put("jsonString", vehicleNo);
			JsonArray.put(JsonObject);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return JsonArray;
	}

	@SuppressWarnings({ "unused", "unused", "unused" })
	public synchronized String modifyChallanDetails(int customerId, String paymentAccHead, String challanType,
			String financeYr, int systemId, int userId, JSONArray js, String payDesc, int uniqueId, float totalPayable,
			String ewalletCheck, float ewalletPayable, float ewalletQbalance, float processingFee, int ewalletId,
			float eWalletAmount, float payableAmount, float ewalletQty, float challanAmount, String totalQty,
			String updatepayable, String date, String transMonth) {

		String message = "";
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		JSONObject obj = null;
		JSONObject obj1 = null;
		JSONObject obj2 = null;
		String grade = "";
		String qty = "0";
		String rate = "0";
		;
		String payable = "0";
		float quantity = 0;
		float sumOfQuantity = 0;
		String giopfRate = "0";
		String giopfQty = "0";
		int id;
		try {
			int updated = 0;
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(IronMiningStatement.UPDATE_CHALLAN_DETAILS);
			pstmt.setString(1, paymentAccHead);
			pstmt.setString(2, financeYr);
			pstmt.setString(3, payDesc);
			pstmt.setString(4, ewalletCheck);
			pstmt.setFloat(5, ewalletPayable);
			pstmt.setFloat(6, ewalletQbalance);
			pstmt.setInt(7, userId);
			pstmt.setString(8, date);
			pstmt.setString(9, transMonth);
			pstmt.setInt(10, uniqueId);

			updated = pstmt.executeUpdate();
			if (updated > 0) {
				message = String.valueOf(uniqueId);
				if (challanType.equals("ROM") || challanType.equals("E-Wallet Challan")
						|| challanType.equals("Processed Ore")) {
					obj1 = js.getJSONObject(0);
					obj2 = js.getJSONObject(1);
					grade = obj1.getString("gradeIdIndex");
					rate = obj1.getString("rateIdIndex");
					qty = obj1.getString("qtyIdIndex");
					payable = obj1.getString("payableIdIndex");
					sumOfQuantity = sumOfQuantity + Float.parseFloat(qty);
					id = Integer.parseInt(obj1.getString("uniqueIdIndex"));

					pstmt = con.prepareStatement(IronMiningStatement.UPDATE_MINING_RATE_MASTER);
					pstmt.setString(1, grade);
					pstmt.setString(2, rate);
					pstmt.setString(3, qty);
					pstmt.setString(4, payable);
					pstmt.setInt(5, id);
					pstmt.executeUpdate();

					giopfRate = obj2.getString("rateIdIndex");
					giopfQty = obj2.getString("qtyIdIndex");

				} else {
					for (int i = 0; i < js.length(); i++) {
						obj = js.getJSONObject(i);
						if (challanType.equals("Others")) {
							grade = obj.getString("leaseAreaDataIndex");
							rate = obj.getString("rate2IdIndex");
							qty = "0";
							payable = obj.getString("payable2IdIndex");
						} else if (challanType.equals("Bauxite Challan")) {
							grade = obj.getString("inputDataIndex");
							rate = obj.getString("valueDataIndex");
							if (grade.equals("QUANTITY")) {
								qty = obj.getString("valueDataIndex");
							} else {
								qty = "0";
							}
							payable = "0";
						}
						id = Integer.parseInt(obj.getString("uniqueIdIndex"));

						pstmt = con.prepareStatement(IronMiningStatement.UPDATE_MINING_RATE_MASTER);
						pstmt.setString(1, grade);
						pstmt.setString(2, rate);
						pstmt.setString(3, qty);
						pstmt.setString(4, payable);
						pstmt.setInt(5, id);
						pstmt.executeUpdate();
					}
				}
				pstmt = con.prepareStatement(IronMiningStatement.UPDATE_QTY_FOR_CHALLAN);
				pstmt.setFloat(1, sumOfQuantity);
				pstmt.setString(2, giopfQty);
				pstmt.setString(3, giopfRate);
				pstmt.setInt(4, uniqueId);
				pstmt.executeUpdate();
				message = String.valueOf(uniqueId);//"Updated Successfully";
			} else {
				message = "0";//"Error in Saving Challan Details";
			}
		} catch (Exception e) {
			System.out.println("error in challan Details:-save challan Details" + e.toString());
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return message;
	}

	public synchronized String saveChallanDetails(int customerId, String paymentAccHead, String type, String tcNum,
			String mineName, String mineralType, String royalty, String challanType, String financeYr, String CustName,
			int systemId, int userId, JSONArray js, String payDesc, int closedPermitId, float totalPayable,
			String ewalletCheck, float ewalletPayable, float ewalletQbalance, float processingFee, float eWalletQty,
			float eWalletAmount, int ewalletId, float payableAmount, String date, String transMonth) {

		String message = "";
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int enrollmentNo = 0;
		JSONObject obj = null;
		JSONObject obj1 = null;
		JSONObject obj2 = null;
		String grade = "";
		String qty = "0";
		String rate = "0";
		String payable = "0";
		int uniqueId = 0;
		String prefix = "";
		float sumOfQuantity = 0;
		String giopfRate = "0";
		String giopfQty = "0";
		try {
			@SuppressWarnings("unused")
			int inserted = 0;
			con = DBConnection.getConnectionToDB("AMS");

			Calendar gcalendar = new GregorianCalendar();
			int year = gcalendar.get(Calendar.YEAR);
			String curyear = String.valueOf(year);

			enrollmentNo = getChallanNumber(con, systemId, customerId, curyear);

			// ----leading Zeros handling----------------------//
			String enrolmentNotoGrid = "";
			if (String.valueOf(enrollmentNo).length() <= 3) {
				enrolmentNotoGrid = ("000" + enrollmentNo).substring(String.valueOf(enrollmentNo).length());
			} else {
				enrolmentNotoGrid = (String.valueOf(enrollmentNo));
			}

			if (challanType.equalsIgnoreCase("ROM")) {
				prefix = "RM";
			} else if (challanType.equalsIgnoreCase("E-Wallet Challan")) {
				prefix = "EWC";
			} else if (challanType.equalsIgnoreCase("Processed Ore")) {
				prefix = "PO";
			} else if (challanType.equalsIgnoreCase("Others")) {
				prefix = "OT";
			} else if (challanType.equalsIgnoreCase("Bauxite Challan")) {
				prefix = "BEWC";
			}
			if (challanType.equalsIgnoreCase("Others") || challanType.equalsIgnoreCase("Processed Ore")) {
				processingFee = 0;
			}
			pstmt = con.prepareStatement(IronMiningStatement.SAVE_MINING_CHALLAN_DETAILS,
					PreparedStatement.RETURN_GENERATED_KEYS);
			pstmt.setString(1, prefix + " " + CustName + "" + enrolmentNotoGrid + "/" + curyear);
			pstmt.setString(2, paymentAccHead);
			pstmt.setString(3, type);
			pstmt.setString(4, tcNum);
			pstmt.setString(5, mineName);
			pstmt.setString(6, mineralType);
			pstmt.setString(7, royalty);
			pstmt.setString(8, challanType);
			pstmt.setString(9, financeYr);
			pstmt.setInt(10, systemId);
			pstmt.setInt(11, customerId);
			pstmt.setInt(12, userId);
			pstmt.setString(13, payDesc);
			pstmt.setString(14, date);
			pstmt.setInt(15, closedPermitId);
			pstmt.setFloat(16, totalPayable);
			pstmt.setString(17, ewalletCheck);
			pstmt.setFloat(18, ewalletPayable);
			pstmt.setFloat(19, ewalletQbalance);
			pstmt.setFloat(20, processingFee);
			pstmt.setFloat(21, 0);
			pstmt.setString(22, transMonth);

			inserted = pstmt.executeUpdate();
			rs = pstmt.getGeneratedKeys();
			if (rs.next()) {
				uniqueId = rs.getInt(1);
			}
			if (uniqueId > 0) {
				float totalqty = 0;
				float totalpay = 0;
				if (challanType.equals("ROM") || challanType.equals("E-Wallet Challan")
						|| challanType.equals("Processed Ore")) {
					System.out.println(js);
					obj1 = js.getJSONObject(0);
					obj2 = js.getJSONObject(1);
					grade = obj1.getString("gradeIdIndex");
					rate = obj1.getString("rateIdIndex");
					qty = obj1.getString("qtyIdIndex");
					payable = obj1.getString("payableIdIndex");
					sumOfQuantity = sumOfQuantity + Float.parseFloat(qty);

					pstmt = con.prepareStatement(IronMiningStatement.INSERT_INTO_MINING_RATE_MASTER);
					pstmt.setInt(1, uniqueId);
					pstmt.setString(2, grade);
					pstmt.setString(3, rate);
					pstmt.setString(4, qty);
					pstmt.setString(5, payable);
					pstmt.executeUpdate();

					giopfRate = obj2.getString("rateIdIndex");
					giopfQty = obj2.getString("qtyIdIndex");
				} else {
					for (int i = 0; i < js.length(); i++) {
						obj = js.getJSONObject(i);
						if (challanType.equals("Others")) {
							grade = obj.getString("leaseAreaDataIndex");
							rate = obj.getString("rate2IdIndex");
							qty = "0";
							payable = obj.getString("payable2IdIndex");
							giopfRate = "0";
							giopfQty = "0";
						} else if (challanType.equals("Bauxite Challan")) {
							grade = obj.getString("inputDataIndex");
							rate = obj.getString("valueDataIndex");
							if (grade.equals("QUANTITY")) {
								qty = obj.getString("valueDataIndex");
							} else {
								qty = "0";
							}
							payable = "0";
							giopfRate = "0";
							giopfQty = "0";
						}
						pstmt = con.prepareStatement(IronMiningStatement.INSERT_INTO_MINING_RATE_MASTER);
						pstmt.setInt(1, uniqueId);
						pstmt.setString(2, grade);
						pstmt.setString(3, rate);
						pstmt.setString(4, qty);
						pstmt.setString(5, payable);
						pstmt.executeUpdate();
						totalpay = totalpay + Float.parseFloat(payable);
						totalqty = totalqty + Float.parseFloat(qty);
					}
				}
				pstmt = con.prepareStatement(IronMiningStatement.UPDATE_QTY_FOR_CHALLAN);
				pstmt.setFloat(1, sumOfQuantity);
				pstmt.setString(2, giopfQty);
				pstmt.setString(3, giopfRate);
				pstmt.setInt(4, uniqueId);
				pstmt.executeUpdate();
				message = String.valueOf(uniqueId);// "Challan Details Saved Successfully";
				System.out.println(giopfRate + "---" + giopfQty);
			} else {
				message = "0";// "Error in Saving Challan Details";
			}
		} catch (Exception e) {
			System.out.println("error in challan Details:-save challan Details" + e.toString());
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return message;
	}

	public JSONArray getClosedPermitNo(int customerId, int systemId, int tcId) {
		JSONArray JsonArray = null;
		JSONObject JsonObject = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			JsonArray = new JSONArray();
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(IronMiningStatement.GET_CLOSED_PERMIT_NO);
			pstmt.setInt(1, tcId);
			pstmt.setInt(2, systemId);
			pstmt.setInt(3, customerId);
			pstmt.setInt(4, systemId);
			pstmt.setInt(5, customerId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				JsonObject = new JSONObject();
				JsonObject.put("permit_id", rs.getInt("ID"));
				JsonObject.put("permit_no", rs.getString("PERMIT_NO"));
				JsonArray.put(JsonObject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return JsonArray;
	}

	public ArrayList<Object> getDataForGrid(int systemId, int custId, int Userid, String type, int id, int tcno) {

		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		PreparedStatement pstmt1 = null;
		ResultSet rs1 = null;
		double leasearea = 0;
		double rate = 0;
		double payable = 0;
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject = null;
		int count = 0;
		ArrayList<Object> finlist = new ArrayList<Object>();
		DecimalFormat df = new DecimalFormat("0.00");
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt1 = con.prepareStatement(IronMiningStatement.GET_LEASE_AREA);
			pstmt1.setInt(1, systemId);
			pstmt1.setInt(2, custId);
			pstmt1.setInt(3, tcno);
			rs1 = pstmt1.executeQuery();
			while (rs1.next()) {
				leasearea = Math.round(rs1.getDouble("LEASE_AREA"));
			}
			if (id != 0) {
				pstmt = con.prepareStatement(IronMiningStatement.GET_CHALLAN_GRADE_DEATILS);
				pstmt.setInt(1, id);
				pstmt.setInt(2, id);
				pstmt.setInt(3, id);
				pstmt.setInt(4, id);
				rs = pstmt.executeQuery();
				while (rs.next()) {
					count++;
					jsonObject = new JSONObject();
					jsonObject.put("SLNOIndex", count);
					jsonObject.put("uniqueIdIndex", rs.getInt("ID"));
					jsonObject.put("leaseAreaDataIndex", rs.getString("GRADE"));
					jsonObject.put("rate2IdIndex", df.format(rs.getDouble("RATE")));
					rate = rate + Math.round(rs.getDouble("RATE"));
					payable = payable + Math.round(rs.getDouble("PAYABLE"));
					jsonObject.put("payable2IdIndex", df.format(Math.round(rs.getDouble("PAYABLE"))));

					jsonArray.put(jsonObject);
				}
			} else {
				jsonObject = new JSONObject();
				jsonObject.put("SLNOIndex", "new1");
				jsonObject.put("leaseAreaDataIndex", df.format(leasearea));
				jsonObject.put("rate2IdIndex", "");
				jsonObject.put("payable2IdIndex", "");
				jsonArray.put(jsonObject);

				jsonObject = new JSONObject();
				jsonObject.put("SLNOIndex", "new2");
				jsonObject.put("leaseAreaDataIndex", "Interest if Any");
				jsonObject.put("rate2IdIndex", "");
				jsonObject.put("payable2IdIndex", "");
				jsonArray.put(jsonObject);
			}
			jsonObject = new JSONObject();
			jsonObject.put("SLNOIndex", "new3");
			jsonObject.put("leaseAreaDataIndex", "TOTAL PAYABLE");
			jsonObject.put("rate2IdIndex", "");
			jsonObject.put("payable2IdIndex", df.format(payable));
			jsonArray.put(jsonObject);
			finlist.add(jsonArray);

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(null, pstmt1, rs1);
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return finlist;
	}

	public JSONArray getTCnumber(int systemId, int clientId, int userId) {
		JSONArray jList = new JSONArray();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(IronMiningStatement.GET_TC_NO);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, clientId);
			pstmt.setInt(3, userId);
			pstmt.setInt(4, systemId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				JSONObject obj = new JSONObject();
				obj.put("TC_ID", rs.getString("TC_ID"));
				obj.put("TC_NO", rs.getString("TC_NUMBER"));
				obj.put("MINE_ID", rs.getString("MINE_ID"));
				obj.put("PF_ROM_USED_QTY", rs.getString("PF_ROM_USED_QTY"));
				obj.put("PF_PROC_USED_QTY", rs.getString("PF_PROC_USED_QTY"));
				obj.put("ROM_QTY", rs.getString("ROM_QTY"));
				obj.put("PROCESSED_QTY", rs.getString("PROCESSED_QTY"));
				jList.put(obj);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jList;
	}

	public JSONArray getOCode(int systemId, int clientId, int userId) {
		JSONArray jList = new JSONArray();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(IronMiningStatement.GET_OCODE);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, clientId);
			pstmt.setInt(3, userId);
			pstmt.setInt(4, systemId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				JSONObject obj = new JSONObject();
				obj.put("ORG_ID", rs.getString("ID"));
				obj.put("ORG_CODE", rs.getString("ORGANIZATION_CODE"));
				obj.put("ORG_NAME", rs.getString("ORGANIZATION_NAME"));
				jList.put(obj);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jList;
	}

	public JSONArray getOrgCodeAndName(int systemId, int clientId, String orgCodeId) {
		JSONArray jList = new JSONArray();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(IronMiningStatement.GET_PLANT_NAME_FOR_PLANT_FEED);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, clientId);
			pstmt.setString(3, orgCodeId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				JSONObject obj = new JSONObject();
				obj.put("PLANT_ID", rs.getString("PLANT_ID"));
				obj.put("PLANT_NAME", rs.getString("PLANT_NAME"));
				obj.put("PLANT_QTY", rs.getString("PLANT_QTY"));
				obj.put("UFO_QTY", rs.getString("UFO_QTY"));
				obj.put("LUMPS_QTY", rs.getString("LUMPS_QTY"));
				jList.put(obj);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jList;
	}

	public JSONArray getRomChallan(int systemId, int clientId, int tcId) {
		JSONArray jList = new JSONArray();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(IronMiningStatement.GET_ROM_CHALLAN);
			pstmt.setInt(1, tcId);
			pstmt.setInt(2, systemId);
			pstmt.setInt(3, clientId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				JSONObject obj = new JSONObject();
				Float usedqty = Float.parseFloat(rs.getString("USED_QTY"));
				Float qty = Float.parseFloat(rs.getString("QUANTITY"));
				obj.put("CHALLAN_NO", rs.getString("CHALLAN_NO"));
				obj.put("ID", rs.getString("ID"));
				if (usedqty > qty) {
					obj.put("QTY", "");
				} else {
					obj.put("QTY", rs.getString("QUANTITY"));
				}
				obj.put("USED_QTY", rs.getString("USED_QTY"));
				jList.put(obj);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jList;
	}

	public ArrayList<Object> getPlantFeedDetails(int systemId, int clientId, int userId) {
		ArrayList<ReportHelper> reportsList = new ArrayList<ReportHelper>();
		ArrayList<String> headersList = new ArrayList<String>();
		SimpleDateFormat simpleDateFormatddMMYY = new SimpleDateFormat("dd/MM/yyyy");
		SimpleDateFormat simpleDateFormatddMMYYYYDB = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		ReportHelper finalreporthelper = new ReportHelper();
		ArrayList<Object> finlist = new ArrayList<Object>();
		DecimalFormat df = new DecimalFormat("0.00");
		int count = 0;
		try {
			headersList.add("SLNO");
			headersList.add("ID");
			headersList.add("Type");
			headersList.add("Organization Name");
			headersList.add("Organization Code");
			headersList.add("Plant Name");
			headersList.add("Plant Quantity");
			headersList.add("Date");
			headersList.add("ROM");
			headersList.add("Lumps Below 55%");
			headersList.add("Lumps 55% Below 58%");
			headersList.add("Lumps 58% Below 60%");
			headersList.add("Lumps 60% Below 62%");
			headersList.add("Lumps 62% Below 65%");
			headersList.add("Lumps 65% and Above");
			headersList.add("Fines Below 55%");
			headersList.add("Fines 55% Below 58%");
			headersList.add("Fines 58% Below 60%");
			headersList.add("Fines 60% Below 62%");
			headersList.add("Fines 62% Below 65%");
			headersList.add("Fines 65% and Above");
			headersList.add("Concentrates Below 55%");
			headersList.add("Concentrates 55% Below 58%");
			headersList.add("Concentrates 58% Below 60%");
			headersList.add("Concentrates 60% Below 62%");
			headersList.add("Concentrates 62% Below 65%");
			headersList.add("Concentrates 65% and Above");
			headersList.add("Tailings");
			headersList.add("Rejects");
			headersList.add("UFO");
			headersList.add("Remarks");

			jsonObject = new JSONObject();
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(IronMiningStatement.GET_PLANT_FEED_DETAILS);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, clientId);
			pstmt.setInt(3, userId);
			pstmt.setInt(4, systemId);
			pstmt.setInt(5, userId);
			pstmt.setInt(6, systemId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				count++;
				ReportHelper reporthelper = new ReportHelper();
				String Date = "";
				Date = simpleDateFormatddMMYY.format(simpleDateFormatddMMYYYYDB.parse(rs.getString("DATE")));
				if (Date.substring(6, 10).equals("1900")) {
					Date = "";
				}
				jsonObject = new JSONObject();
				ArrayList<Object> informationList = new ArrayList<Object>();
				jsonObject.put("slnoIndex", count);
				informationList.add(count);

				jsonObject.put("uniqueIdIndex", rs.getInt("ID"));
				informationList.add(rs.getInt("ID"));

				jsonObject.put("orgIdIndex", rs.getString("ORG_ID"));

				jsonObject.put("typeIndex", rs.getString("TYPE"));
				informationList.add(rs.getString("TYPE"));

				jsonObject.put("orgNameDataIndex", rs.getString("ORGANIZATION_NAME"));
				informationList.add(rs.getString("ORGANIZATION_NAME"));

				jsonObject.put("oCodeDataIndex", rs.getString("ORGANIZATION_CODE"));
				informationList.add(rs.getString("ORGANIZATION_CODE"));

				jsonObject.put("plantIdDataIndex", rs.getString("PLANT_ID"));

				jsonObject.put("plantNameDataIndex", rs.getString("PLANT_NAME"));
				informationList.add(rs.getString("PLANT_NAME"));

				jsonObject.put("plantQtyIndex", rs.getString("PLANT_QTY"));
				informationList.add(rs.getString("PLANT_QTY"));

				jsonObject.put("dateDataIndex", Date);
				informationList.add(Date);

				jsonObject.put("romDataIndex", rs.getString("ROM"));
				informationList.add(rs.getString("ROM"));

				jsonObject.put("lBelow55DataIndex", rs.getString("LUMP1"));
				informationList.add(rs.getString("LUMP1"));

				jsonObject.put("lBelow58DataIndex", rs.getString("LUMP2"));
				informationList.add(rs.getString("LUMP2"));

				jsonObject.put("lBelow60DataIndex", rs.getString("LUMP3"));
				informationList.add(rs.getString("LUMP3"));

				jsonObject.put("lBelow62DataIndex", rs.getString("LUMP4"));
				informationList.add(rs.getString("LUMP4"));

				jsonObject.put("lBelow65DataIndex", rs.getString("LUMP5"));
				informationList.add(rs.getString("LUMP5"));

				jsonObject.put("labove65DataIndex", rs.getString("LUMP6"));
				informationList.add(rs.getString("LUMP6"));

				jsonObject.put("fBelow55DataIndex", rs.getString("FINES1"));
				informationList.add(rs.getString("FINES1"));

				jsonObject.put("fBelow58DataIndex", rs.getString("FINES2"));
				informationList.add(rs.getString("FINES2"));

				jsonObject.put("fBelow60DataIndex", rs.getString("FINES3"));
				informationList.add(rs.getString("FINES3"));

				jsonObject.put("fBelow62DataIndex", rs.getString("FINES4"));
				informationList.add(rs.getString("FINES4"));

				jsonObject.put("fBelow65DataIndex", rs.getString("FINES5"));
				informationList.add(rs.getString("FINES5"));

				jsonObject.put("fabove65DataIndex", rs.getString("FINES6"));
				informationList.add(rs.getString("FINES6"));

				jsonObject.put("cBelow55DataIndex", rs.getString("CONCENTRATE1"));
				informationList.add(rs.getString("CONCENTRATE1"));

				jsonObject.put("cBelow58DataIndex", rs.getString("CONCENTRATE2"));
				informationList.add(rs.getString("CONCENTRATE2"));

				jsonObject.put("cBelow60DataIndex", rs.getString("CONCENTRATE3"));
				informationList.add(rs.getString("CONCENTRATE3"));

				jsonObject.put("cBelow62DataIndex", rs.getString("CONCENTRATE4"));
				informationList.add(rs.getString("CONCENTRATE4"));

				jsonObject.put("cBelow65DataIndex", rs.getString("CONCENTRATE5"));
				informationList.add(rs.getString("CONCENTRATE5"));

				jsonObject.put("cabove65DataIndex", rs.getString("CONCENTRATE6"));
				informationList.add(rs.getString("CONCENTRATE6"));

				jsonObject.put("tailingsDataIndex", rs.getString("TAILINGS"));
				informationList.add(rs.getString("TAILINGS"));

				jsonObject.put("rejectsDataIndex", rs.getString("REJECTS"));
				informationList.add(rs.getString("REJECTS"));

				jsonObject.put("UFODataIndex", rs.getString("UFO"));
				informationList.add(rs.getString("UFO"));

				jsonObject.put("remarksDataIndex", rs.getString("REMARKS"));
				informationList.add(rs.getString("REMARKS"));

				jsonArray.put(jsonObject);
				reporthelper.setInformationList(informationList);
				reportsList.add(reporthelper);
			}
			finalreporthelper.setReportsList(reportsList);
			finalreporthelper.setHeadersList(headersList);
			finlist.add(jsonArray);
			finlist.add(finalreporthelper);
		} catch (Exception e) {
			System.out.println("Error in IronMining Functions:- getPlantFeedDetails " + e.toString());
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return finlist;
	}

	public String addPlantFeedDetails(int userid, int organCode, String date, float rom, float lump1, float lump2,
			float lump3, float lump4, float lump5, float lump6, float fine1, float fine2, float fine3, float fine4,
			float fine5, float fine6, float concentrate1, float concentrate2, float concentrate3, float concentrate4,
			float concentrate5, float concentrate6, float tailing, float reject, float UFO, int systemId, int CustId,
			float usedqty, int plantId, float romQty, String type, String remarks) {
		Connection con = null;
		PreparedStatement pstmt = null;
		PreparedStatement pstmt1 = null;
		String message = "";
		try {
			if (date.contains("T")) {
				date = date.replaceAll("T", " ");
			}
			float totallumps = lump1 + lump2 + lump3 + lump4 + lump5 + lump6;
			float totalfines = fine1 + fine2 + fine3 + fine4 + fine5 + fine6;
			float totalconcentrates = concentrate1 + concentrate2 + concentrate3 + concentrate4 + concentrate5
					+ concentrate6;
			float totalprocessedore = totalfines + totallumps + tailing + reject + UFO;
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(IronMiningStatement.INSERT_INTO_PLANT_FEED_DETAILS);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, CustId);
			pstmt.setInt(3, userid);
			pstmt.setInt(4, organCode);
			pstmt.setString(5, date);
			pstmt.setFloat(6, rom);
			pstmt.setFloat(7, lump1);
			pstmt.setFloat(8, lump2);
			pstmt.setFloat(9, lump3);
			pstmt.setFloat(10, lump4);
			pstmt.setFloat(11, lump5);
			pstmt.setFloat(12, lump6);
			pstmt.setFloat(13, fine1);
			pstmt.setFloat(14, fine2);
			pstmt.setFloat(15, fine3);
			pstmt.setFloat(16, fine4);
			pstmt.setFloat(17, fine5);
			pstmt.setFloat(18, fine6);
			pstmt.setFloat(19, concentrate1);
			pstmt.setFloat(20, concentrate2);
			pstmt.setFloat(21, concentrate3);
			pstmt.setFloat(22, concentrate4);
			pstmt.setFloat(23, concentrate5);
			pstmt.setFloat(24, concentrate6);
			pstmt.setFloat(25, tailing);
			pstmt.setFloat(26, reject);
			pstmt.setFloat(27, totallumps);
			pstmt.setFloat(28, totalfines);
			pstmt.setFloat(29, totalconcentrates);
			pstmt.setFloat(30, UFO);
			pstmt.setFloat(31, totalprocessedore);
			pstmt.setInt(32, plantId);
			pstmt.setString(33, type);
			pstmt.setString(34, remarks);
			int inserted = pstmt.executeUpdate();

			if (inserted > 0) {
				if (type.equalsIgnoreCase("ROM")) {
					pstmt = con.prepareStatement(IronMiningStatement.UPDATE_ROM_QTY_IN_PLANT_MASTER_FOR_PLANT_FEED);
					pstmt.setFloat(1, rom);
					pstmt.setInt(2, systemId);
					pstmt.setInt(3, CustId);
					pstmt.setInt(4, plantId);
					pstmt.executeUpdate();
				} else if (type.equalsIgnoreCase("LUMPS")) {
					pstmt = con.prepareStatement(IronMiningStatement.UPDATE_LUMPS_QTY_IN_PLANT_MASTER_FOR_PLANT_FEED);
					pstmt.setFloat(1, rom);
					pstmt.setInt(2, systemId);
					pstmt.setInt(3, CustId);
					pstmt.setInt(4, plantId);
					pstmt.executeUpdate();
				} else {
					pstmt = con.prepareStatement(IronMiningStatement.UPDATE_UFO_QTY_IN_PLANT_MASTER_FOR_PLANT_FEED);
					pstmt.setFloat(1, rom);
					pstmt.setInt(2, systemId);
					pstmt.setInt(3, CustId);
					pstmt.setInt(4, plantId);
					pstmt.executeUpdate();
				}
				message = "Added Successfully";
			} else {
				message = "Error in Adding";
			}
		} catch (Exception e) {
			message = "Error in Adding";
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, null);
			DBConnection.releaseConnectionToDB(con, pstmt1, null);
		}
		return message;
	}

	public String modifyPlantFeedDetails(int userid, int uniqueId, float rom, float lump1, float lump2, float lump3,
			float lump4, float lump5, float lump6, float fine1, float fine2, float fine3, float fine4, float fine5,
			float fine6, float tailing, float reject, float UFO, int systemId, int CustId, int plantId) {
		Connection con = null;
		PreparedStatement pstmt = null;
		String message = "";
		try {
			con = DBConnection.getConnectionToDB("AMS");
			float totallumps = lump1 + lump2 + lump3 + lump4 + lump5 + lump6;
			float totalfines = fine1 + fine2 + fine3 + fine4 + fine5 + fine6;
			float totalprocessedore = totalfines + totallumps + tailing + reject + UFO;
			pstmt = con.prepareStatement(IronMiningStatement.UPDATE_PLANT_FEED_DETAILS);
			pstmt.setFloat(1, rom);
			pstmt.setFloat(2, lump1);
			pstmt.setFloat(3, lump2);
			pstmt.setFloat(4, lump3);
			pstmt.setFloat(5, lump4);
			pstmt.setFloat(6, lump5);
			pstmt.setFloat(7, lump6);
			pstmt.setFloat(8, fine1);
			pstmt.setFloat(9, fine2);
			pstmt.setFloat(10, fine3);
			pstmt.setFloat(11, fine4);
			pstmt.setFloat(12, fine5);
			pstmt.setFloat(13, fine6);
			pstmt.setFloat(14, tailing);
			pstmt.setFloat(15, reject);
			pstmt.setFloat(16, totallumps);
			pstmt.setFloat(17, totalfines);
			pstmt.setFloat(18, UFO);
			pstmt.setFloat(19, totalprocessedore);
			pstmt.setInt(20, userid);
			pstmt.setInt(21, plantId);
			pstmt.setInt(22, systemId);
			pstmt.setInt(23, CustId);
			pstmt.setInt(24, uniqueId);
			int updated = pstmt.executeUpdate();
			if (updated > 0) {
				message = "Updated Successfully";
			} else {
				message = "Error in Updating";
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, null);
		}
		return message;
	}

	public JSONArray getOrganizationCode(int customerId, int systemId, int userId) {
		JSONArray JsonArray = null;
		JSONObject JsonObject = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		DecimalFormat df = new DecimalFormat("##0.00");
		try {
			JsonArray = new JSONArray();
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(IronMiningStatement.GET_ORGANIZATION_CODE);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, customerId);
			pstmt.setInt(3, userId);
			pstmt.setInt(4, systemId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				JsonObject = new JSONObject();
				JsonObject.put("organizationCode", rs.getString("ORGANIZATION_CODE"));
				JsonObject.put("id", rs.getInt("ID"));
				JsonObject.put("organizationName", rs.getString("ORGANIZATION_NAME"));
				JsonObject.put("aliasName", rs.getString("ALIAS_NAME"));
				JsonObject.put("type", rs.getString("TYPE"));
				JsonObject.put("totalFines", df.format(rs.getFloat("TOTAL_FINES") - rs.getFloat("USED_FINES")));
				JsonObject.put("totalLumps", df.format(rs.getFloat("TOTAL_LUMPS") - rs.getFloat("USED_LUMPS")));
				JsonObject.put("totalTailing", df.format(rs.getFloat("TAILINGS") - rs.getFloat("USED_TAILINGS")));
				JsonObject.put("totalRejects", df.format(rs.getFloat("REJECTS") - rs.getFloat("USED_REJECTS")));
				JsonObject.put("mWalletBalance", df.format(rs.getFloat("M_WALLET_BALANCE")));
				JsonArray.put(JsonObject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return JsonArray;
	}

	public JSONArray getStockType(int orgCode, int custId, int systemId, String mineralType, int routeId,
			String permitType) {
		JSONArray JsonArray = null;
		JSONObject JsonObject = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		DecimalFormat df = new DecimalFormat("0.00");
		int hubId = 0;
		int Shub = 0;
		try {
			JsonArray = new JSONArray();
			con = DBConnection.getConnectionToDB("AMS");
			if (mineralType.equals("Bauxite/Laterite")) {
				pstmt = con.prepareStatement(IronMiningStatement.GET_EXPORT_DETAILS_FOR_BAUXITE);
				pstmt.setInt(1, systemId);
				pstmt.setInt(2, custId);
				pstmt.setInt(3, orgCode);
			} else if (permitType.equals("Rom Transit") || permitType.equals("Rom Sale")) {
				pstmt = con.prepareStatement(IronMiningStatement.GET_DESTINATION_FROM_ROUTE);
				pstmt.setInt(1, systemId);
				pstmt.setInt(2, custId);
				pstmt.setInt(3, routeId);
				rs = pstmt.executeQuery();
				if (rs.next()) {
					hubId = rs.getInt("Start_Hubid");
				}
				if (permitType.equals("Rom Sale")) {
					Shub = routeId;
				} else {
					Shub = hubId;
				}
				pstmt = con.prepareStatement(IronMiningStatement.GET_EXPORT_DETAILS_FOR_RTP);
				pstmt.setInt(1, systemId);
				pstmt.setInt(2, custId);
				pstmt.setInt(3, orgCode);
				pstmt.setString(4, mineralType);
				pstmt.setInt(5, Shub);
			} else {
				pstmt = con.prepareStatement(IronMiningStatement.GET_DESTINATION_FROM_ROUTE);
				pstmt.setInt(1, systemId);
				pstmt.setInt(2, custId);
				pstmt.setInt(3, routeId);
				rs = pstmt.executeQuery();
				if (rs.next()) {
					hubId = rs.getInt("Start_Hubid");
				}
				if (permitType.equals("Processed Ore Sale") || permitType.equals("Rom Sale")) {
					Shub = routeId;
				} else {
					Shub = hubId;
				}
				pstmt = con.prepareStatement(IronMiningStatement.GET_EXPORT_DETAILS);
				pstmt.setInt(1, systemId);
				pstmt.setInt(2, custId);
				pstmt.setInt(3, orgCode);
				pstmt.setString(4, mineralType);
				pstmt.setInt(5, Shub);
				pstmt.setInt(6, systemId);
				pstmt.setInt(7, custId);
				pstmt.setInt(8, orgCode);
				pstmt.setInt(9, Shub);
				pstmt.setString(10, mineralType);
			}
			rs = pstmt.executeQuery();
			while (rs.next()) {
				JsonObject = new JSONObject();
				JsonObject.put("stockType", rs.getString("NAME") + "(" + rs.getString("STOCK_TYPE") + ")");
				JsonObject.put("routeId", rs.getString("ROUTE_ID"));
				JsonObject.put("totalLumps", df.format((rs.getDouble("TOTAL_LUMPS"))));
				JsonObject.put("totalFines", df.format((rs.getDouble("TOTAL_FINES"))));
				JsonObject.put("totalConc", df.format((rs.getDouble("TOTAL_CONC"))));
				JsonObject.put("totalTailings", df.format((rs.getDouble("TAILINGS"))));
				JsonObject.put("totalRejects", df.format((rs.getDouble("REJECTS"))));
				JsonObject.put("totalQty", df.format((rs.getDouble("TOTAL_QUANTITY"))));
				JsonObject.put("romQty", df.format((rs.getDouble("ROM_QTY"))));
				JsonArray.put(JsonObject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return JsonArray;
	}

	public ArrayList<Object> getDataForGridForPermit(int systemId, int custId, int Userid, int id, String permitType,
			String mineralType) {

		Connection con = null;
		PreparedStatement pstmt = null;
		PreparedStatement pstmt1 = null;
		ResultSet rs = null;
		ResultSet rs1 = null;
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject = null;
		int count = 0;
		ArrayList<Object> finlist = new ArrayList<Object>();
		DecimalFormat df = new DecimalFormat("#.###");
		double qty = 0;
		double pf = 0;
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt1 = con.prepareStatement(IronMiningStatement.GET_PROCESSING_FEE_FROM_PF_MASTER);
			pstmt1.setInt(1, systemId);
			pstmt1.setInt(2, custId);
			pstmt1.setString(3, permitType);
			pstmt1.setString(4, mineralType);

			rs1 = pstmt1.executeQuery();
			while (rs1.next()) {
				pf = (rs1.getDouble("PROCESSING_FEE"));
			}
			if (id != 0) {
				pstmt = con.prepareStatement(IronMiningStatement.GET_PERMIT_GRID_DEATILS);
				pstmt.setInt(1, id);
				rs = pstmt.executeQuery();
				while (rs.next()) {
					count++;
					jsonObject = new JSONObject();
					jsonObject.put("SLNOIndex", count);
					jsonObject.put("gardeDataIndex", rs.getString("GRADE"));
					jsonObject.put("type2IdIndex", rs.getString("TYPE"));
					jsonObject.put("stockTypeIdIndex", rs.getString("STOCK_TYPE"));
					jsonObject.put("qty2IdIndex", df.format((rs.getDouble("QUANTITY"))));
					if (permitType != null && permitType.equals("Purchased Rom Sale Transit Permit")) {
						jsonObject.put("processingFeeIndex", df.format(pf));
						jsonObject.put("totalPfeeIndex", df.format(pf * rs.getDouble("QUANTITY")));
					} else {
						jsonObject.put("processingFeeIndex", df.format((rs.getDouble("PROCESSING_FEE"))));
						jsonObject.put("totalPfeeIndex", df.format((rs.getDouble("TOTAL_PROCESSING_FEE"))));
					}
					qty = (rs.getDouble("QUANTITY"));
					jsonArray.put(jsonObject);
				}
			} else {
				jsonObject = new JSONObject();
				jsonObject.put("SLNOIndex", "new1");
				jsonObject.put("gardeDataIndex", "");
				jsonObject.put("type2IdIndex", "");
				jsonObject.put("stockTypeIdIndex", "");
				jsonObject.put("qty2IdIndex", "");

				jsonObject.put("processingFeeIndex", df.format(pf));
				jsonArray.put(jsonObject);
			}
			finlist.add(jsonArray);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return finlist;
	}

	public int getTripSheetNumberFromPermitDetails(Connection conAdmin, int systemId, int customerId, String curyear,
			int PID) {
		PreparedStatement pstmt550 = null;
		PreparedStatement pstmt55 = null;
		ResultSet rs550 = null;
		int enrolmentnonew = 0;
		try {
			pstmt550 = conAdmin.prepareStatement(IronMiningStatement.GET_TRIP_SHEET_NUMBER);
			pstmt550.setInt(1, PID);
			rs550 = pstmt550.executeQuery();
			if (rs550.next()) {
				enrolmentnonew = rs550.getInt("TRIPSHEET_NO");
				enrolmentnonew++;
			} else {
				enrolmentnonew++;

			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(null, pstmt550, rs550);
			DBConnection.releaseConnectionToDB(null, pstmt55, null);
		}
		return enrolmentnonew;
	}

	public int UpdateTripSheetNumberForPermitDetails(Connection conAdmin, int tripSheetNo, int PID) {
		PreparedStatement pstmt550 = null;
		ResultSet rs550 = null;
		int updated = 0;
		try {
			pstmt550 = conAdmin.prepareStatement(IronMiningStatement.UPDATE_TRIP_SHEET_NUMBER);
			pstmt550.setInt(1, tripSheetNo);
			pstmt550.setInt(2, PID);
			updated = pstmt550.executeUpdate();

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(null, pstmt550, rs550);
		}
		return updated;
	}

	public JSONArray getUsersForUserSetting(int customerId, int systemId, int ltsp, int userId) {
		JSONArray JsonArray = null;
		JSONObject JsonObject = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String tcId = "";
		String orgId = "";
		boolean flag = false;
		try {
			JsonArray = new JSONArray();
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(IronMiningStatement.GET_ASSOCIATION_DATA_FOR_LTSP_USERS);
			pstmt.setInt(1, userId);
			pstmt.setInt(2, systemId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				if (!rs.getString("TC_ID").equals("0")) {
					tcId = rs.getString("TC_ID") + "," + tcId;
				} else {
					orgId = rs.getString("ORG_ID") + "," + orgId;
				}
				flag = true;
			}
			if (flag) {
				if (tcId.length() > 1) {
					tcId = tcId.substring(0, tcId.length() - 1);
				}
				if (orgId.length() > 1) {
					orgId = orgId.substring(0, orgId.length() - 1);
				}
				tcId = tcId.equals("") ? "0" : tcId;
				orgId = orgId.equals("") ? "0" : orgId;
				if (tcId.equals("0") && !orgId.equals("0")) {
					pstmt = con.prepareStatement(IronMiningStatement.GET_USERS_FOR_USER_SETTING.replace("#condition#",
							" and(ORG_ID in(" + orgId + "))"));
				} else if (!tcId.equals("0") && orgId.equals("0")) {
					pstmt = con.prepareStatement(IronMiningStatement.GET_USERS_FOR_USER_SETTING.replace("#condition#",
							" and(TC_ID in(" + tcId + "))"));
				} else {
					pstmt = con.prepareStatement(IronMiningStatement.GET_USERS_FOR_USER_SETTING.replace("#condition#",
							" and(TC_ID in(" + tcId + ") or ORG_ID in(" + orgId + "))"));
				}
				pstmt.setInt(1, systemId);
				pstmt.setInt(2, customerId);
				rs = pstmt.executeQuery();

				while (rs.next()) {
					JsonObject = new JSONObject();
					JsonObject.put("userName", rs.getString("USER_NAME"));
					JsonObject.put("userId", rs.getInt("USER_ID"));
					JsonArray.put(JsonObject);
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return JsonArray;
	}

	public JSONArray getOrganisationCode(int customerId, int systemId, int userId) {
		JSONArray JsonArray = null;
		JSONObject JsonObject = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			JsonArray = new JSONArray();
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(IronMiningStatement.GET_OCODE);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, customerId);
			pstmt.setInt(3, userId);
			pstmt.setInt(4, systemId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				JsonObject = new JSONObject();
				JsonObject.put("orgName", rs.getString("ORGANIZATION_NAME"));
				JsonObject.put("orgCode", rs.getString("ORGANIZATION_CODE"));
				JsonObject.put("orgId", rs.getString("ID"));
				JsonArray.put(JsonObject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return JsonArray;
	}

	//*********************************************getgrade***************************************//
	public JSONArray getGrade(String mineral) {
		JSONArray JsonArray = null;
		JSONObject JsonObject = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int count = 0;
		try {
			JsonArray = new JSONArray();
			con = DBConnection.getConnectionToDB("AMS");
			List<String> listOfGrade = new ArrayList<String>();
			if (mineral.equalsIgnoreCase("Fe")) {
				listOfGrade.add("Below 55%");
				listOfGrade.add("55% to Below 58%");
				listOfGrade.add("58% to Below 60%");
				listOfGrade.add("60% to Below 62%");
				listOfGrade.add("62% to Below 65%");
				listOfGrade.add("65% and above");
			} else if (mineral.equalsIgnoreCase("Mn")) {
				listOfGrade.add("Below 25%");
				listOfGrade.add("25% to Below 35%");
				listOfGrade.add("35% to Below 46%");
				listOfGrade.add("46% and above");
				listOfGrade.add("Dioxide ore");
			} else if (mineral.equalsIgnoreCase("Bauxite/Laterite")) {
				listOfGrade.add("Below 40%");
				listOfGrade.add("40% to Below 45%");
				listOfGrade.add("45% to Below 50%");
				listOfGrade.add("50% to Below 55%");
				listOfGrade.add("55% to Below 60%");
				listOfGrade.add("60% and above");

			}
			for (int i = 0; i < listOfGrade.size(); i++) {
				JsonObject = new JSONObject();
				count++;
				JsonObject.put("SLNOIndex", count);
				JsonObject.put("gradesIndex", listOfGrade.get(i));
				JsonArray.put(JsonObject);
			}

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return JsonArray;
	}

	public ArrayList<Object> getStockYardMasterDetails(int systemId, int custId, int userId, String language) {
		CommonFunctions cf = new CommonFunctions();
		ArrayList<ReportHelper> reportsList = new ArrayList<ReportHelper>();
		ArrayList<String> headersList = new ArrayList<String>();
		ReportHelper finalreporthelper = new ReportHelper();
		ArrayList<Object> finlist = new ArrayList<Object>();
		JSONArray JsonArray = null;
		JSONObject JsonObject = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int count = 0;
		try {
			headersList.add(cf.getLabelFromDB("SLNO", language));
			headersList.add("ID");
			headersList.add("Location Name");
			headersList.add("Type");
			headersList.add(cf.getLabelFromDB("Organization_Code", language));
			headersList.add("Organization Name");
			headersList.add(cf.getLabelFromDB("Mineral_Name", language));
			headersList.add(cf.getLabelFromDB("Total_Fines", language) + "(MT)");
			headersList.add(cf.getLabelFromDB("Total_Lumps", language) + "(MT)");
			headersList.add(cf.getLabelFromDB("Total_Rejects", language) + "(MT)");
			headersList.add(cf.getLabelFromDB("Total_Tailings", language) + "(MT)");
			headersList.add(cf.getLabelFromDB("Total_UFO", language));
			headersList.add("Total Concentrates (MT)");
			headersList.add(cf.getLabelFromDB("Total_Quantity", language));
			headersList.add(cf.getLabelFromDB("Quantity_Of_ROM", language));
			JsonArray = new JSONArray();

			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(IronMiningStatement.GET_STOCKYARD_MASTER_DETAILS);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, custId);
			pstmt.setInt(3, userId);
			pstmt.setInt(4, systemId);
			pstmt.setInt(5, systemId);
			pstmt.setInt(6, custId);
			pstmt.setInt(7, userId);
			pstmt.setInt(8, systemId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				count++;
				ReportHelper reporthelper = new ReportHelper();
				JsonObject = new JSONObject();
				ArrayList<Object> informationList = new ArrayList<Object>();

				JsonObject.put("slnoIndex", count);
				informationList.add(count);

				informationList.add(rs.getString("ID"));
				JsonObject.put("idIndex", rs.getInt("ID"));

				informationList.add(rs.getString("NAME"));
				JsonObject.put("JettyIndex", rs.getString("NAME"));

				informationList.add(rs.getString("TYPE"));
				JsonObject.put("TypeIndex", rs.getString("TYPE"));

				informationList.add(rs.getString("ORGANIZATION_CODE"));
				JsonObject.put("OrganizationCodeIndex", rs.getString("ORGANIZATION_CODE"));

				informationList.add(rs.getString("ORGANIZATION_NAME"));
				JsonObject.put("OrganizationNameIndex", rs.getString("ORGANIZATION_NAME"));

				informationList.add(rs.getString("MINERAL_TYPE"));
				JsonObject.put("MineralTypeIndex", rs.getString("MINERAL_TYPE"));

				informationList.add(rs.getString("FINES"));
				JsonObject.put("TotalFinesIndex", rs.getString("FINES"));

				informationList.add(rs.getString("LUMPS"));
				JsonObject.put("TotalLumpsIndex", rs.getString("LUMPS"));

				informationList.add(rs.getString("REJECTS"));
				JsonObject.put("TotalRejectsIndex", rs.getString("REJECTS"));

				informationList.add(rs.getString("TAILINGS"));
				JsonObject.put("TotalTailingsIndex", rs.getString("TAILINGS"));

				informationList.add(rs.getString("UFO"));
				JsonObject.put("TotalUFOIndex", rs.getString("UFO"));

				informationList.add(rs.getString("CONCENTRATES"));
				JsonObject.put("TotalConcentratesIndex", rs.getString("CONCENTRATES"));

				informationList.add(rs.getString("TOTAL_QTY"));
				JsonObject.put("TotalQtyIndex", rs.getString("TOTAL_QTY"));

				informationList.add(rs.getString("ROM_QTY"));
				JsonObject.put("romQtyIndex", rs.getString("ROM_QTY"));

				JsonObject.put("hubIdIndex", rs.getString("HUB_ID"));
				JsonObject.put("orgIdIndex", rs.getString("ORG_ID"));
				JsonArray.put(JsonObject);
				reporthelper.setInformationList(informationList);
				reportsList.add(reporthelper);
			}
			finalreporthelper.setReportsList(reportsList);
			finalreporthelper.setHeadersList(headersList);
			finlist.add(JsonArray);
			finlist.add(finalreporthelper);

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return finlist;
	}

	public JSONArray getPermitBalForModify(String clientId, int systemId, String permitId) {
		JSONArray JsonArray = new JSONArray();
		JSONObject JsonObject = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		float actualQuantity = 0;
		float covertTotons = 0;
		DecimalFormat df = new DecimalFormat("#.###");
		try {
			JsonArray = new JSONArray();
			JsonObject = new JSONObject();
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(IronMiningStatement.GET_TRIP_SHEET_DETAILS_FOR_MODIFY);
			pstmt.setString(1, permitId);
			pstmt.setInt(2, systemId);
			pstmt.setString(3, clientId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				JsonObject = new JSONObject();

				if (rs.getInt("CHALLAN_ID") > 0) {
					JsonObject.put("quantity", df.format(rs.getFloat("QUANTITY")));
				} else {
					JsonObject.put("quantity", df.format(rs.getFloat("POTQUANTITY")));
				}

				actualQuantity = rs.getFloat("TRIPSHEET_QTY");
				covertTotons = actualQuantity / 1000;
				if (rs.getInt("CHALLAN_ID") > 0) {
					JsonObject.put("tripSheetQty", df.format(rs.getFloat("QUANTITY") - covertTotons));
				} else {
					JsonObject.put("tripSheetQty", df.format(rs.getFloat("POTQUANTITY") - covertTotons));
				}

				JsonArray.put(JsonObject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}

		return JsonArray;
	}

	public String saveTripSheetDetailsInformationForBarge(int customerId, String type, String assetNo,
			String bargeCapacity, String bargeQuantity, String validityDateTime, int userId, int systemId,
			String custName, int userSettingId, String tripSheetType, int orgId, int bargeLocId) {

		float actualPermitQuantity = 0;
		String message = "";
		LogWriter logWriter = null;
		Connection conAdmin = null;
		PreparedStatement pstmt55 = null;
		ResultSet rs55 = null;
		float qty = 0;
		int enrollmentNo = 0;
		String material = "";
		try {
			int inserted = 0;
			int tripSheetNo = 0;
			Properties properties = ApplicationListener.prop;
			String logFile = properties.getProperty("LogFileForBargeTripsheet");
			String logFileName = logFile.substring(0, logFile.lastIndexOf("."));
			String logFileExt = logFile.substring(logFile.lastIndexOf(".") + 1, logFile.length());
			logFile = logFileName + "-" + sdf.format(new Date()) + "." + logFileExt;

			PrintWriter pw;

			if (logFile != null) {
				try {
					pw = new PrintWriter(new FileWriter(logFile, true), true);
					logWriter = new LogWriter("saveTripSheetDetailsInformationForBarge", LogWriter.INFO, pw);
					;
					logWriter.setPrintWriter(pw);
				} catch (IOException e) {
					logWriter.log("Can't open the log file: " + logFile + ". Using System.err instead",
							LogWriter.ERROR);
				}
			}
			logWriter.log(" Begining of the method ", LogWriter.INFO);
			conAdmin = DBConnection.getConnectionToDB("AMS");
			/*pstmt55=conAdmin.prepareStatement(IronMiningStatement.GET_ASSET_NO_VALIDATE);
			pstmt55.setInt(1, systemId);
			pstmt55.setInt(2, customerId);
			pstmt55.setString(3,assetNo.toUpperCase());
			rs55=pstmt55.executeQuery();
			if(rs55.next())
			{  
			message = "<p>Asset Number Already Enrolled.</p>";
			return (message);
			}*/
			Calendar gcalendar = new GregorianCalendar();
			int year = gcalendar.get(Calendar.YEAR);
			Calendar cal = Calendar.getInstance();
			String curyear = String.valueOf(year);
			String curmonth = new SimpleDateFormat("MM").format(cal.getTime());
			System.out.println(curmonth);
			//	tripSheetNo=getTripSheetNumberFromPermitDetails(conAdmin,systemId,customerId,curyear,pId);
			enrollmentNo = getTripSheetNumberForBarge(conAdmin, systemId, customerId, curyear);

			if (tripSheetType.equalsIgnoreCase("train")) {
				material = "TRAIN";
			} else {
				material = "BARGE";
			}
			//----leading Zeros handling----------------------//  
			String tripSheetNotoGrid = "";
			if (String.valueOf(enrollmentNo).length() <= 5) {
				tripSheetNotoGrid = ("00000" + enrollmentNo).substring(String.valueOf(enrollmentNo).length());
			} else {
				tripSheetNotoGrid = ("000000000" + enrollmentNo).substring(String.valueOf(enrollmentNo).length());
			}
			//-----Insert Mining Asset Enrolment details into MINING_ASSET_ENROLLMENT Table--------//
			String currentyear = curyear.substring(Math.max(curyear.length() - 2, 0));

			logWriter.log(" TRIP NO== " + "BE " + curmonth + " " + currentyear + "/" + tripSheetNotoGrid
					+ " VEHICLE NO==" + assetNo + " bargeCapacity==" + bargeCapacity + " bargeQuantity=="
					+ bargeQuantity + " Ptype==" + type + " validityDateTime== " + validityDateTime + " systemId=="
					+ systemId + " customerId==" + customerId + " userId==" + userId + " userSettingId=="
					+ userSettingId + " inserteddatetime==" + new Date() + " ORG ID== " + orgId, LogWriter.INFO);

			pstmt55 = conAdmin.prepareStatement(IronMiningStatement.SAVE_MINING_TRIP_SHEET_INFORMATION_FOR_BARGE);
			pstmt55.setString(1, "BE " + curmonth + " " + currentyear + "/" + tripSheetNotoGrid);
			pstmt55.setString(2, type);
			pstmt55.setString(3, assetNo);
			pstmt55.setString(4, validityDateTime);
			pstmt55.setString(5, bargeCapacity);
			pstmt55.setInt(6, systemId);
			pstmt55.setInt(7, customerId);
			pstmt55.setString(8, bargeQuantity);
			pstmt55.setInt(9, userId);
			pstmt55.setInt(10, userSettingId);
			pstmt55.setInt(11, orgId);
			pstmt55.setInt(12, bargeLocId);
			inserted = pstmt55.executeUpdate();
			if (inserted > 0) {
				logWriter.log(" Trip Sheet Details Saved Successfully", LogWriter.INFO);
				message = "Trip Sheet Details Saved Successfully";
			} else {
				logWriter.log(" Error in Saving Trip Sheet Details", LogWriter.INFO);
				message = "Error in Saving Trip Sheet Details";
			}
		} catch (Exception e) {
			StringWriter errors = new StringWriter();
			e.printStackTrace(new PrintWriter(errors));
			logWriter.log(errors.toString(), LogWriter.ERROR);
			System.out.println("error in Trip Sheet Details :-save Trip Sheet Details" + e.toString());
			e.printStackTrace();
			logWriter.log("Before inserting in EmailQueue", LogWriter.INFO);
			if (conAdmin != null) {
				try {
					pstmt55 = conAdmin.prepareStatement(
							"insert into AMS.dbo.EmailQueue(Subject,Body,EmailList,SystemId) values (?,?,?,?)");
					pstmt55.setString(1,
							"error in saveTripSheetDetailsInformationForTruckForBarge for SystemId " + systemId);
					pstmt55.setString(2, errors.toString());
					pstmt55.setString(3,
							"gayatri.p@telematics4u.com,praveen.c@telematics4u.com,namrata.d@telematics4u.com");
					pstmt55.setInt(4, systemId);
					pstmt55.executeUpdate();
					logWriter.log("Record inserted in EmailQueue", LogWriter.INFO);
				} catch (SQLException e1) {
					e1.printStackTrace();
				}
			}
		} finally {
			DBConnection.releaseConnectionToDB(conAdmin, pstmt55, rs55);
		}
		logWriter.log(" Ending of the method ", LogWriter.INFO);
		return message;
	}

	@SuppressWarnings("unchecked")
	public ArrayList getTripSheetDetailsForBarge(int systemId, int CustomerId, int userId, String language,
			String fromDate, String endDate) {
		JSONArray JsonArray = new JSONArray();
		JSONObject JsonObject = null;
		Connection con = null;
		PreparedStatement pstmt52 = null;
		ResultSet rs52 = null;
		int aslcount = 0;
		SimpleDateFormat diffddMMyyyyHHmmss = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
		ArrayList assetLists = new ArrayList();
		DecimalFormat df = new DecimalFormat("#0.00");
		ArrayList<String> headersList = new ArrayList<String>();
		ArrayList<ReportHelper> reportsList = new ArrayList<ReportHelper>();
		ReportHelper finalreporthelper = new ReportHelper();

		headersList.add("SLNO");
		headersList.add("Type");
		headersList.add("WB@S");
		headersList.add("Trip Sheet Number");
		headersList.add("Barge Name");
		headersList.add("Asset Id");
		headersList.add("Organization Name");
		headersList.add("Issued Date");
		headersList.add("Stop BLO DateTime");
		headersList.add("Validity Date Time");
		headersList.add("Status");
		headersList.add("Barge Capacity");
		headersList.add("Barge Quantity");
		headersList.add("Unique Id");
		headersList.add("Unloaded Quantity");
		headersList.add("Closed Date Time");
		headersList.add("WB@D");

		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt52 = con.prepareStatement(IronMiningStatement.GET_BARGE_TRIP_DETAILS);
			pstmt52.setInt(1, systemId);
			pstmt52.setInt(2, CustomerId);
			pstmt52.setString(3, fromDate);
			pstmt52.setString(4, endDate);
			pstmt52.setInt(5, userId);
			pstmt52.setInt(6, systemId);
			rs52 = pstmt52.executeQuery();
			while (rs52.next()) {
				JsonObject = new JSONObject();
				ArrayList<Object> informationList = new ArrayList<Object>();
				ReportHelper reporthelper = new ReportHelper();
				aslcount++;
				JsonObject.put("slnoIndex", aslcount);
				informationList.add(aslcount);

				JsonObject.put("TypeIndex", rs52.getString("TYPE").toUpperCase());
				informationList.add(rs52.getString("TYPE").toUpperCase());

				JsonObject.put("wbsIndex", rs52.getString("WBS"));
				informationList.add(rs52.getString("WBS"));

				JsonObject.put("TripSheetNumberIndex", rs52.getString("TRIP_NO").toUpperCase());
				informationList.add(rs52.getString("TRIP_NO").toUpperCase());

				JsonObject.put("assetNoIndex", rs52.getString("ASSET_NUMBER").toUpperCase());
				informationList.add(rs52.getString("ASSET_NUMBER").toUpperCase());

				JsonObject.put("assetIdIndex", rs52.getString("ASSET_ID").toUpperCase());
				informationList.add(rs52.getString("ASSET_ID").toUpperCase());

				JsonObject.put("orgIndex", rs52.getString("ORG_NAME"));
				informationList.add(rs52.getString("ORG_NAME"));

				if (rs52.getString("ISSUE_DATE").contains("1900")) {
					JsonObject.put("issuedIndexId", "");
					informationList.add("");
				} else {
					JsonObject.put("issuedIndexId", diffddMMyyyyHHmmss.format(rs52.getTimestamp(("ISSUE_DATE"))));
					informationList.add(diffddMMyyyyHHmmss.format(rs52.getTimestamp(("ISSUE_DATE"))));
				}
				if (rs52.getString("STOP_BLO_DATETIME").contains("1900")) {
					JsonObject.put("stopBLODateTimeIndexId", "");
					informationList.add("");
				} else {
					JsonObject.put("stopBLODateTimeIndexId",
							diffddMMyyyyHHmmss.format(rs52.getTimestamp(("STOP_BLO_DATETIME"))));
					informationList.add(diffddMMyyyyHHmmss.format(rs52.getTimestamp(("STOP_BLO_DATETIME"))));
				}

				if (rs52.getTimestamp("VALIDITY_DATE") == null || rs52.getString("VALIDITY_DATE").equals("")
						|| rs52.getString("VALIDITY_DATE").contains("1900")) {
					JsonObject.put("validityDateDataIndex", "");
					informationList.add("");
				} else {
					JsonObject.put("validityDateDataIndex",
							diffddMMyyyyHHmmss.format(rs52.getTimestamp("VALIDITY_DATE")));
					informationList.add(diffddMMyyyyHHmmss.format(rs52.getTimestamp("VALIDITY_DATE")));
				}
				if (rs52.getString("STATUS").equalsIgnoreCase("Start BLO")) {
					JsonObject.put("statusIndexId", "BLO In-Transit");
					informationList.add("BLO In-Transit");
				} else if (rs52.getString("STATUS").equalsIgnoreCase("Stop BLO")) {
					JsonObject.put("statusIndexId", "In-Transit");
					informationList.add("In-Transit");
				} else if (rs52.getString("STATUS").equalsIgnoreCase("Close")) {
					JsonObject.put("statusIndexId", "Closed-Completed Trip");
					informationList.add("Closed-Completed trip");
				} else {
					JsonObject.put("statusIndexId", rs52.getString("STATUS"));
					informationList.add(rs52.getString("STATUS"));
				}

				JsonObject.put("QuantityIndex", df.format(rs52.getFloat("QUANTITY2")));
				informationList.add(rs52.getString("QUANTITY2"));

				float bargeQuantity = Float.parseFloat(rs52.getString("QUANTITY1"));
				JsonObject.put("q1IndexId", df.format(bargeQuantity / 1000));
				informationList.add(df.format(bargeQuantity / 1000));

				JsonObject.put("uniqueIDIndex", rs52.getString("ID"));
				informationList.add(rs52.getString("ID"));

				JsonObject.put("orgIdIndex", rs52.getInt("ORGANIZATION_ID"));
				JsonObject.put("bargeLocIndex", rs52.getInt("SOURCE_HUBID"));
				JsonObject.put("flagIndex", rs52.getString("FLAG"));

				if ((rs52.getString("STATUS").equalsIgnoreCase("Closed Diverted Trip")
						&& !rs52.getString("TRIP_NO").contains("-"))
						|| rs52.getString("STATUS").equalsIgnoreCase("Start BLO")
						|| rs52.getString("STATUS").equalsIgnoreCase("Stop BLO")
						|| (rs52.getString("STATUS").equalsIgnoreCase("Close")
								&& !rs52.getString("TRIP_NO").contains("-"))) {
					JsonObject.put("vesselNameIndex", rs52.getString("SHIP_NAME"));
				} else {
					JsonObject.put("vesselNameIndex", rs52.getString("VESSEL_NAME"));
				}

				JsonObject.put("destinationIndex", rs52.getString("DESTINATION"));

				JsonObject.put("boatNote", rs52.getString("BOAT_NOTE"));

				JsonObject.put("reason", rs52.getString("REASON"));

				JsonObject.put("issuedBy", rs52.getString("ISSUED_BY"));

				if (rs52.getString("STATUS").equalsIgnoreCase("Stop BLO")
						|| rs52.getString("STATUS").equalsIgnoreCase("Start BLO")
						|| rs52.getString("STATUS").equalsIgnoreCase("In-transit Diverted Trip")) {
					JsonObject.put("divQtyIndex", df.format(0));
					informationList.add(df.format(0));
				} else {
					JsonObject.put("divQtyIndex", df.format(rs52.getDouble("DIVERTED_QTY")));
					informationList.add(df.format(rs52.getDouble("DIVERTED_QTY")));
				}

				if (rs52.getString("CLOSED_DATETIME").contains("1900")
						|| rs52.getString("STATUS").equalsIgnoreCase("Stop BLO")) {
					JsonObject.put("closedDateIndex", "");
					informationList.add("");
				} else {
					JsonObject.put("closedDateIndex",
							diffddMMyyyyHHmmss.format(rs52.getTimestamp(("CLOSED_DATETIME"))));
					informationList.add(diffddMMyyyyHHmmss.format(rs52.getTimestamp(("CLOSED_DATETIME"))));
				}

				JsonObject.put("wbdIndex", rs52.getString("WBD"));
				informationList.add(rs52.getString("WBD"));

				JsonArray.put(JsonObject);
				reporthelper.setInformationList(informationList);
				reportsList.add(reporthelper);
			}
			assetLists.add(JsonArray);
			finalreporthelper.setReportsList(reportsList);
			finalreporthelper.setHeadersList(headersList);
			assetLists.add(finalreporthelper);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {

			DBConnection.releaseConnectionToDB(con, pstmt52, rs52);
		}
		return assetLists;
	}

	public ArrayList getTrainTripSheetDetails(int systemId, int CustomerId, int userId, String language,
			String fromDate, String endDate) {
		JSONArray JsonArray = new JSONArray();
		JSONObject JsonObject = null;
		Connection con = null;
		PreparedStatement pstmt52 = null;
		ResultSet rs52 = null;
		int aslcount = 0;
		SimpleDateFormat diffddMMyyyyHHmmss = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
		ArrayList assetLists = new ArrayList();
		DecimalFormat df = new DecimalFormat("#.###");
		ArrayList<String> headersList = new ArrayList<String>();
		ArrayList<ReportHelper> reportsList = new ArrayList<ReportHelper>();
		ReportHelper finalreporthelper = new ReportHelper();

		headersList.add("SLNO");
		headersList.add("Type");
		headersList.add("Trip Sheet Number");
		headersList.add("Train Name");
		headersList.add("Issued Date");
		headersList.add("Stop BLO DateTime");
		headersList.add("Validity Date Time");
		headersList.add("Status");
		headersList.add("Train Capacity");
		headersList.add("Quantity");
		headersList.add("Unique Id");
		headersList.add("Closed Date Time");

		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt52 = con.prepareStatement(IronMiningStatement.GET_BARGE_TRIP_DETAILS);
			pstmt52.setInt(1, systemId);
			pstmt52.setInt(2, CustomerId);
			pstmt52.setString(3, fromDate);
			pstmt52.setString(4, endDate);
			//pstmt52.setString(5, "TRAIN");
			pstmt52.setInt(5, userId);
			pstmt52.setInt(6, systemId);
			pstmt52.setInt(7, userId);
			pstmt52.setInt(8, systemId);
			pstmt52.setInt(9, systemId);
			pstmt52.setInt(10, CustomerId);
			pstmt52.setString(11, fromDate);
			pstmt52.setString(12, endDate);
			//pstmt52.setString(14, "TRAIN");
			pstmt52.setInt(13, userId);
			pstmt52.setInt(14, systemId);
			pstmt52.setInt(15, userId);
			pstmt52.setInt(16, systemId);
			rs52 = pstmt52.executeQuery();
			while (rs52.next()) {
				JsonObject = new JSONObject();
				ArrayList<Object> informationList = new ArrayList<Object>();
				ReportHelper reporthelper = new ReportHelper();
				aslcount++;
				JsonObject.put("slnoIndex", aslcount);
				informationList.add(aslcount);

				JsonObject.put("TypeIndex", rs52.getString("TYPE").toUpperCase());
				informationList.add(rs52.getString("TYPE").toUpperCase());

				JsonObject.put("TripSheetNumberIndex", rs52.getString("TRIP_NO").toUpperCase());
				informationList.add(rs52.getString("TRIP_NO").toUpperCase());

				JsonObject.put("assetNoIndex", rs52.getString("ASSET_NUMBER").toUpperCase());
				informationList.add(rs52.getString("ASSET_NUMBER").toUpperCase());

				if (rs52.getString("ISSUE_DATE").contains("1900")) {
					JsonObject.put("issuedIndexId", "");
					informationList.add("");
				} else {
					JsonObject.put("issuedIndexId", diffddMMyyyyHHmmss.format(rs52.getTimestamp(("ISSUE_DATE"))));
					informationList.add(diffddMMyyyyHHmmss.format(rs52.getTimestamp(("ISSUE_DATE"))));
				}
				if (rs52.getString("STOP_BLO_DATETIME").contains("1900")) {
					JsonObject.put("stopBLODateTimeIndexId", "");
					informationList.add("");
				} else {
					JsonObject.put("stopBLODateTimeIndexId",
							diffddMMyyyyHHmmss.format(rs52.getTimestamp(("STOP_BLO_DATETIME"))));
					informationList.add(diffddMMyyyyHHmmss.format(rs52.getTimestamp(("STOP_BLO_DATETIME"))));
				}

				if (rs52.getTimestamp("VALIDITY_DATE") == null || rs52.getString("VALIDITY_DATE").equals("")
						|| rs52.getString("VALIDITY_DATE").contains("1900")) {
					JsonObject.put("validityDateDataIndex", "");
					informationList.add("");
				} else {
					JsonObject.put("validityDateDataIndex",
							diffddMMyyyyHHmmss.format(rs52.getTimestamp("VALIDITY_DATE")));
					informationList.add(diffddMMyyyyHHmmss.format(rs52.getTimestamp("VALIDITY_DATE")));
				}
				if (rs52.getString("STATUS").equalsIgnoreCase("Start BLO")) {
					JsonObject.put("statusIndexId", "BLO In-Transit");
					informationList.add("BLO In-Transit");
				} else if (rs52.getString("STATUS").equalsIgnoreCase("Stop BLO")) {
					JsonObject.put("statusIndexId", "In-Transit");
					informationList.add("In-Transit");
				} else if (rs52.getString("STATUS").equalsIgnoreCase("Close")) {
					JsonObject.put("statusIndexId", "Closed-Completed Trip");
					informationList.add("Closed-Completed trip");
				} else {
					JsonObject.put("statusIndexId", rs52.getString("STATUS"));
					informationList.add(rs52.getString("STATUS"));
				}

				JsonObject.put("QuantityIndex", df.format(rs52.getFloat("QUANTITY2")));
				informationList.add(rs52.getString("QUANTITY2"));

				float bargeQuantity = Float.parseFloat(rs52.getString("QUANTITY1"));
				JsonObject.put("q1IndexId", df.format(bargeQuantity / 1000));
				informationList.add(df.format(bargeQuantity / 1000));

				JsonObject.put("uniqueIDIndex", rs52.getString("ID"));
				informationList.add(rs52.getString("ID"));

				JsonObject.put("orgIdIndex", rs52.getInt("ORGANIZATION_ID"));
				JsonObject.put("bargeLocIndex", rs52.getInt("SOURCE_HUBID"));

				JsonObject.put("vesselNameIndex", rs52.getString("VESSEL_NAME"));
				//informationList.add(rs52.getString("VESSEL_NAME"));

				JsonObject.put("destinationIndex", rs52.getString("DESTINATION"));
				//informationList.add(rs52.getString("DESTINATION"));

				JsonObject.put("boatNote", rs52.getString("BOAT_NOTE"));
				//informationList.add(rs52.getString("BOAT_NOTE"));

				JsonObject.put("reason", rs52.getString("REASON"));
				//informationList.add(rs52.getString("REASON"));

				if (rs52.getString("CLOSED_DATETIME").contains("1900")
						|| rs52.getString("STATUS").equalsIgnoreCase("Stop BLO")) {
					JsonObject.put("closedDateIndex", "");
					informationList.add("");
				} else {
					JsonObject.put("closedDateIndex",
							diffddMMyyyyHHmmss.format(rs52.getTimestamp(("CLOSED_DATETIME"))));
					informationList.add(diffddMMyyyyHHmmss.format(rs52.getTimestamp(("CLOSED_DATETIME"))));
				}
				JsonArray.put(JsonObject);
				reporthelper.setInformationList(informationList);
				reportsList.add(reporthelper);
			}
			assetLists.add(JsonArray);
			finalreporthelper.setReportsList(reportsList);
			finalreporthelper.setHeadersList(headersList);
			assetLists.add(finalreporthelper);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {

			DBConnection.releaseConnectionToDB(con, pstmt52, rs52);
		}
		return assetLists;
	}

	public String closeTripForBarge(int customerId, String assetNo, String tripSheetNo, int userId, int systemId) {

		String message = "";
		Connection conAdmin = null;
		PreparedStatement pstmt55 = null;
		ResultSet rs55 = null;
		try {
			int inserted = 0;
			conAdmin = DBConnection.getConnectionToDB("AMS");

			pstmt55 = conAdmin.prepareStatement(IronMiningStatement.UPDATE_STATUS_FOR_CLOSE_TRIP);
			pstmt55.setInt(1, userId);
			pstmt55.setString(2, assetNo);
			pstmt55.setString(3, tripSheetNo);
			pstmt55.setInt(4, customerId);
			pstmt55.setInt(5, systemId);

			inserted = pstmt55.executeUpdate();
			if (inserted > 0) {
				message = "Trip Closed Successfully";
			} else {
				message = "Error in Close Trip";
			}
		} catch (Exception e) {
			System.out.println("error in Close Trip :-save Tare Weight" + e.toString());
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(conAdmin, pstmt55, rs55);
		}
		return message;
	}

	//-----------------------------------get vehicle list----------------------------------//
	public JSONArray getVehicleListForBarge(String clientId, int systemId) {
		JSONArray JsonArray = new JSONArray();
		JSONObject JsonObject = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			JsonArray = new JSONArray();
			JsonObject = new JSONObject();
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(IronMiningStatement.GET_VEHILCE_NO_FOR_BARGE_TRIP_SHEET_GEN);
			pstmt.setInt(1, systemId);
			pstmt.setString(2, clientId);
			pstmt.setInt(3, systemId);
			pstmt.setString(4, clientId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				JsonObject = new JSONObject();
				JsonObject.put("vehicleNoID", rs.getString("VID"));
				JsonObject.put("vehicleName", rs.getString("VNAME"));
				JsonObject.put("quantity1", rs.getString("QUANTITY1"));
				JsonArray.put(JsonObject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}

		return JsonArray;
	}

	public JSONArray getBargeNoList(String clientId, int systemId, int userid) {
		JSONArray JsonArray = new JSONArray();
		JSONObject JsonObject = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String Vehiclename = "";
		String vehiclealias = "";
		try {
			JsonArray = new JSONArray();
			JsonObject = new JSONObject();
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(IronMiningStatement.GET_BARGE_NO_FOR_TRIP_SHEET_GEN);
			pstmt.setInt(1, systemId);
			pstmt.setString(2, clientId);
			pstmt.setInt(3, userid);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				Vehiclename = rs.getString("VNAME");
				vehiclealias = rs.getString("VehicleAlias");
				if (!Vehiclename.equals("") && !vehiclealias.equals("")) {
					Vehiclename = Vehiclename + "[" + vehiclealias + "]";

				}
				JsonObject = new JSONObject();
				JsonObject.put("vehicleNoID", rs.getString("VID"));
				JsonObject.put("vehicleName", Vehiclename);
				JsonObject.put("quantity1", rs.getString("LoadCapacity"));
				JsonObject.put("bargeQuantity", rs.getFloat("BARGEQUANTITY"));
				JsonArray.put(JsonObject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}

		return JsonArray;
	}

	private synchronized int getTripSheetNumberForBarge(Connection conAdmin, int systemId, int customerId,
			String curyear) {
		PreparedStatement pstmt550 = null;
		PreparedStatement pstmt55 = null;
		ResultSet rs550 = null;
		int enrolmentnonew = 0;
		try {
			pstmt550 = conAdmin.prepareStatement(IronMiningStatement.GET_ENROLLMENT_NUMBER, ResultSet.TYPE_FORWARD_ONLY,
					ResultSet.CONCUR_UPDATABLE);
			pstmt550.setString(1, "TRIP_SHEET_NUMBER");
			pstmt550.setInt(2, systemId);
			pstmt550.setInt(3, customerId);
			pstmt550.setString(4, curyear);
			rs550 = pstmt550.executeQuery();
			if (rs550.next()) {
				enrolmentnonew = rs550.getInt("VALUE");
				enrolmentnonew++;
				rs550.updateInt("VALUE", enrolmentnonew);
				rs550.rowUpdated();
				pstmt55 = conAdmin.prepareStatement(IronMiningStatement.UPDATE_ENROLLMENT_NO_TO_LOOKUP);
				pstmt55.setInt(1, enrolmentnonew);
				pstmt55.setString(2, "TRIP_SHEET_NUMBER");
				pstmt55.setInt(3, systemId);
				pstmt55.setInt(4, customerId);
				pstmt55.setString(5, curyear);
				pstmt55.executeUpdate();
			} else {
				enrolmentnonew++;
				pstmt55 = conAdmin.prepareStatement(IronMiningStatement.INSERT_ENROLLMENT_NUMBER_TO_LOOKUP);
				pstmt55.setString(1, "TRIP_SHEET_NUMBER");
				pstmt55.setInt(2, enrolmentnonew);
				pstmt55.setString(3, curyear);
				pstmt55.setInt(4, systemId);
				pstmt55.setInt(5, customerId);
				pstmt55.executeUpdate();
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(null, pstmt550, rs550);
			DBConnection.releaseConnectionToDB(null, pstmt55, null);
		}
		return enrolmentnonew;
	}

	public JSONArray getRFIDForBarge(String clientId, int systemId, String rfidNumber, int userid) {
		JSONArray JsonArray = new JSONArray();
		JSONObject JsonObject = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String vehicleNo = "";
		String quantity1 = "";
		float bargeQuantity = 0;
		try {
			//rfidNumber=getRFIDFromFile(ip);
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(IronMiningStatement.GET_BARGE_RFID_VEHICLE);
			pstmt.setInt(1, systemId);
			pstmt.setString(2, clientId);
			pstmt.setString(3, rfidNumber);
			pstmt.setInt(4, userid);

			rs = pstmt.executeQuery();
			while (rs.next()) {
				vehicleNo = rs.getString("VehicleNo");
				quantity1 = rs.getString("QUANTITY1");
				bargeQuantity = rs.getFloat("BARGEQUANTITY");
			}
			JsonObject = new JSONObject();
			JsonObject.put("jsonString", vehicleNo);
			JsonObject.put("quantity1", quantity1);
			JsonObject.put("bargeQuantity", bargeQuantity);
			JsonArray.put(JsonObject);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return JsonArray;
	}

	public JSONArray getPermitNo(String clientId, int systemId, int userId) {
		JSONArray JsonArray = new JSONArray();
		JSONObject JsonObject = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		PreparedStatement pstmtop = null;
		ResultSet rs1 = null;
		String permitNo = "";
		int sourceHubId = 0;
		DecimalFormat df = new DecimalFormat("#.###");
		float actualQuantity = 0;
		float covertTotons = 0;
		try {
			JsonArray = new JSONArray();
			JsonObject = new JSONObject();
			con = DBConnection.getConnectionToDB("AMS");
			pstmtop = con.prepareStatement(IronMiningStatement.GET_PERMIT_NO_FOR_TRIP_GEN);
			pstmtop.setInt(1, systemId);
			pstmtop.setString(2, clientId);
			pstmtop.setInt(3, userId);
			rs1 = pstmtop.executeQuery();
			while (rs1.next()) {
				JsonObject = new JSONObject();
				permitNo = rs1.getString("PERMIT_IDS");
				sourceHubId = rs1.getInt("SOURCE_HUBID");
			}
			if (!permitNo.equals("")) {
				pstmt = con.prepareStatement(
						" select isnull(TRIP_SHEET_COUNT1,0) as TRIP_SHEET_COUNT1,isnull(TRIP_SHEET_COUNT2,0) as TRIP_SHEET_COUNT2,pd.TC_ID,pd.ORGANIZATION_CODE,isnull(tc.LESSE_NAME,'NA') as TC_LEASE_NAME,isnull(mm.ORGANIZATION_NAME,'')as ORGANIZATION,pd.PERMIT_NO,pd.ID,pd.CHALLAN_ID,rd.ROUTE_NAME as ROUTE_NAME,rd.ID as ROUTE_ID,(select sum(QUANTITY) from  dbo.CHALLAN_GRADE_DETAILS where CHALLAN_ID=pd.CHALLAN_ID) as QUANTITY, "
								+ " isnull(pd.TRIPSHEET_QTY,0)as TRIPSHEET_QTY,(select sum(QUANTITY) from AMS.dbo.PROCESSED_ORE_PERMIT_DETAILS where PERMIT_ID=pd.ID ) as POTQUANTITY,isnull(pd.SRC_TYPE,'') as SRC_TYPE "
								+ " from  AMS.dbo.MINING_PERMIT_DETAILS pd "
								+ " left outer join MINING_TC_MASTER tc on tc.ID=pd.TC_ID and tc.SYSTEM_ID=pd.SYSTEM_ID and tc.CUSTOMER_ID=pd.CUSTOMER_ID   "
								+ " left outer join AMS.dbo.MINING_ORGANIZATION_MASTER mm on mm.ID=pd.ORGANIZATION_CODE and mm.SYSTEM_ID=pd.SYSTEM_ID and mm.CUSTOMER_ID=pd.CUSTOMER_ID  "
								+
								//" inner  join AMS.dbo.Trip_Master tm on tm.Trip_id=pd.ROUTE_ID and tm.System_id=pd.SYSTEM_ID and tm.Client_id=pd.CUSTOMER_ID  " +
								" left outer join MINING.dbo.ROUTE_DETAILS rd on rd.ID=pd.ROUTE_ID and rd.SYSTEM_ID=pd.SYSTEM_ID and rd.CUSTOMER_ID=pd.CUSTOMER_ID "
								+ " where  pd.SYSTEM_ID=? and pd.CUSTOMER_ID=? and  pd.ID in (" + permitNo
								+ ") and rd.SOURCE_HUB_ID=" + sourceHubId
								+ " and pd.STATUS in ('APPROVED','ACKNOWLEDGED') and DATEADD(dd, 0, DATEDIFF(dd, 0, GETDATE()))>=pd.START_DATE and DATEADD(dd, 0, DATEDIFF(dd, 0, GETDATE()))<=pd.END_DATE");

				pstmt.setInt(1, systemId);
				pstmt.setString(2, clientId);
				rs = pstmt.executeQuery();
				while (rs.next()) {
					JsonObject = new JSONObject();
					JsonObject.put("routeId", rs.getString("ROUTE_ID"));
					JsonObject.put("routeName", rs.getString("ROUTE_NAME"));
					if (rs.getInt("CHALLAN_ID") > 0) {
						JsonObject.put("quantity", df.format(rs.getFloat("QUANTITY")));
					} else {
						JsonObject.put("quantity", df.format(rs.getFloat("POTQUANTITY")));
					}
					JsonObject.put("permitNo", rs.getString("PERMIT_NO"));
					actualQuantity = rs.getFloat("TRIPSHEET_QTY");
					covertTotons = actualQuantity / 1000;
					JsonObject.put("pId", rs.getInt("ID"));
					if (rs.getInt("CHALLAN_ID") > 0) {
						JsonObject.put("tripSheetQty", df.format(rs.getFloat("QUANTITY") - covertTotons));
					} else {
						JsonObject.put("tripSheetQty", df.format(rs.getFloat("POTQUANTITY") - covertTotons));
					}
					JsonObject.put("tcId", rs.getString("TC_ID"));
					JsonObject.put("orgCode", rs.getString("ORGANIZATION_CODE"));
					JsonObject.put("leaseName", rs.getString("TC_LEASE_NAME"));
					JsonObject.put("orgName", rs.getString("ORGANIZATION"));
					JsonObject.put("tripsheetCount1", rs.getString("TRIP_SHEET_COUNT1"));
					JsonObject.put("tripsheetCount2", rs.getString("TRIP_SHEET_COUNT2"));
					JsonObject.put("srcType", rs.getString("SRC_TYPE"));
					JsonArray.put(JsonObject);
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return JsonArray;
	}

	public String saveTripSheetDetailsInformationForTruck(int customerId, String type, String assetNo, String leaseName,
			String quantity, String validityDateTime, String routeId, int userId, int systemId, String quantity1,
			String srcHubId, String desHubId, String permitNo, int pId, float actualQuantity, int userSettingId,
			int orgCode, String gradetype, String tripNo, int bargeId, float bargeQuantity, String tripSheetType,
			String rsSource, String rsDestination, String transactionNo, String bargeNo, float bargeCapacity,
			String nonCommHrs) {
		float actualPermitQuantity = 0;
		String message = "";
		Connection conAdmin = null;
		PreparedStatement pstmt55 = null;
		PreparedStatement pstmtU = null;
		ResultSet rs55 = null;
		float permitqty = 0;
		float permitusedqty = 0;
		float AvailableBargeQty = 0;
		float permitusedqtyintotons = 0;
		float permitbal = 0;
		DecimalFormat df = new DecimalFormat();
		boolean tripsheetexists = true;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		ResultSet rs1 = null;
		int uniqueId = 0;
		SimpleDateFormat sdf = new SimpleDateFormat("dd-MM-yyyy");
		LogWriter logWriter = null;
		int buyOrgId = 0;
		String permittype = "";
		String mineraltype = "";
		String permitNo1 = "";
		String commStatus = "";
		String destType = "";
		try {
			int inserted = 0;
			int tripSheetNo = 0;
			float bargeQty = 0;
			String bargeStatus = "";
			float actualBargeQty = 0;
			actualQuantity = Float.parseFloat(quantity) - Float.parseFloat(quantity1);
			Properties properties = ApplicationListener.prop;
			String logFile = properties.getProperty("LogFileForBargeTruck");
			String logFileName = logFile.substring(0, logFile.lastIndexOf("."));
			String logFileExt = logFile.substring(logFile.lastIndexOf(".") + 1, logFile.length());
			logFile = logFileName + "-" + sdf.format(new Date()) + "." + logFileExt;

			PrintWriter pw;

			if (logFile != null) {
				try {
					pw = new PrintWriter(new FileWriter(logFile, true), true);
					logWriter = new LogWriter("saveTripSheetDetailsInformationForTruck", LogWriter.INFO, pw);
					;
					logWriter.setPrintWriter(pw);
				} catch (IOException e) {
					logWriter.log("Can't open the log file: " + logFile + ". Using System.err instead",
							LogWriter.ERROR);
				}
			}
			conAdmin = DBConnection.getConnectionToDB("AMS");
			logWriter.log(" Begining of the method ", LogWriter.INFO);

			pstmt = conAdmin.prepareStatement(IronMiningStatement.GET_PERMIT_NO);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, customerId);
			pstmt.setInt(3, userId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				permitNo1 = rs.getString("PERMIT_IDS");
			}
			logWriter.log(" User setting permit Ids " + permitNo1, LogWriter.INFO);
			if (!permitNo1.equals("")) {
				rs = util.getPermitTripSheet(customerId, assetNo, systemId, pId, conAdmin, permitNo1);
				while (rs.next()) {
					if (rs.getInt("CHALLAN_ID") > 0) {
						permitqty = rs.getFloat("QUANTITY");
					} else {
						permitqty = rs.getFloat("POTQUANTITY");
					}
					permitusedqty = rs.getFloat("TRIPSHEET_QTY");
					permitusedqtyintotons = permitusedqty / 1000;
					if (rs.getInt("CHALLAN_ID") > 0) {
						permitbal = rs.getFloat("QUANTITY") - permitusedqtyintotons;
					} else {
						permitbal = rs.getFloat("POTQUANTITY") - permitusedqtyintotons;
					}
					if (rs.getString("TRIP_STATUS").equalsIgnoreCase("OPEN")) {
						tripsheetexists = false;
					}
					buyOrgId = rs.getInt("BUYING_ORG_ID");
					tripSheetNo = rs.getInt("TRIPSHEET_NO");
					tripSheetNo++;
					actualPermitQuantity = rs.getFloat("ACTUAL_QUANTITY");
					permittype = rs.getString("PERMIT_TYPE");
					mineraltype = rs.getString("MINERAL");
					destType = rs.getString("DEST_TYPE");
				}
				float actualqtyintons = actualQuantity / 1000;

				pstmt55 = conAdmin.prepareStatement(IronMiningStatement.GET_BARGE_DETAILS_FOR_IMPORT);
				pstmt55.setInt(1, systemId);
				pstmt55.setInt(2, customerId);
				pstmt55.setString(3, bargeNo);
				rs55 = pstmt55.executeQuery();
				if (rs55.next()) {
					actualBargeQty = rs55.getFloat("BARGEQUANTITY");
				}
				AvailableBargeQty = bargeCapacity - (actualBargeQty / 1000);
				logWriter.log("Permitbal==" + permitbal + " Actualqtyintons==" + actualqtyintons + " tripsheetexists=="
						+ tripsheetexists, LogWriter.INFO);
				if (permitbal >= actualqtyintons && tripsheetexists && AvailableBargeQty >= actualqtyintons) {
					Calendar gcalendar = new GregorianCalendar();
					int year = gcalendar.get(Calendar.YEAR);
					Calendar cal = Calendar.getInstance();
					String curyear = String.valueOf(year);
					String curmonth = new SimpleDateFormat("MM").format(cal.getTime());

					pstmt55 = conAdmin.prepareStatement(IronMiningStatement.GET_BARGE_QUANTITY);
					pstmt55.setInt(1, systemId);
					pstmt55.setInt(2, customerId);
					pstmt55.setInt(3, bargeId);
					rs55 = pstmt55.executeQuery();
					if (rs55.next()) {
						bargeQty = rs55.getFloat("QUANTITY1");
						bargeStatus = rs55.getString("STATUS");
					}

					if (bargeStatus.equals("OPEN")) {
						util.updateBargeStatusAndRouteToTripDetails(customerId, systemId, bargeId, conAdmin, routeId);
					}
					if (bargeStatus.equals("OPEN") || bargeStatus.equals("Start BLO")) {
						synchronized (this) {
							logWriter.log("in synchronized block " + new Date(), LogWriter.INFO);
							rs = util.getPermitCount(systemId, pId, conAdmin);
							if (rs.next()) {
								if (rs.getInt("TRIP_COUNT") > 0) {
									tripSheetNo = rs.getInt("TRIP_COUNT");
									tripSheetNo++;
								}
							}
							//----leading Zeros handling----------------------//  
							String tripSheetNotoGrid = "";
							if (String.valueOf(tripSheetNo).length() <= 5) {
								tripSheetNotoGrid = ("00000" + tripSheetNo)
										.substring(String.valueOf(tripSheetNo).length());
							} else {
								tripSheetNotoGrid = ("000000000" + tripSheetNo)
										.substring(String.valueOf(tripSheetNo).length());
							}
							//-----Insert Mining Asset Enrolment details into MINING_ASSET_ENROLLMENT Table--------//
							String currentyear = curyear.substring(Math.max(curyear.length() - 2, 0));

							logWriter.log(" TRIP NO== " + tripNo + "-" + tripSheetNotoGrid + " VEHICLE NO==" + assetNo
									+ " GROSS WEIGHT==" + quantity + " TARE WEIGHT==" + quantity1 + " PERMIT NO=="
									+ permitNo + " GRADE TYPE== " + gradetype + " LEASE NAME==" + leaseName
									+ " SOURCE HUBID==" + srcHubId + " DESTINATION HUBID==" + desHubId
									+ " BARGE QUANTITY==" + bargeQuantity + " BARGE STATUS==" + bargeStatus
									+ " TRIPSHEET TYPE" + tripSheetType, LogWriter.INFO);

							pstmt55 = conAdmin.prepareStatement(
									IronMiningStatement.SAVE_MINING_TRIP_SHEET_INFORMATION_FOR_TRUCK,
									PreparedStatement.RETURN_GENERATED_KEYS);
							pstmt55.setString(1, tripNo + "-" + tripSheetNotoGrid);
							pstmt55.setString(2, type);
							pstmt55.setString(3, assetNo);
							pstmt55.setInt(4, Integer.parseInt(leaseName));
							pstmt55.setString(5, validityDateTime);
							pstmt55.setString(6, gradetype);
							pstmt55.setString(7, quantity);
							pstmt55.setInt(8, Integer.parseInt(routeId));
							pstmt55.setInt(9, systemId);
							pstmt55.setInt(10, customerId);
							pstmt55.setString(11, quantity1);
							pstmt55.setString(12, srcHubId);
							pstmt55.setString(13, desHubId);
							pstmt55.setInt(14, pId);
							pstmt55.setInt(15, userId);
							pstmt55.setInt(16, userSettingId);
							pstmt55.setInt(17, orgCode);
							pstmt55.setInt(18, bargeId);
							pstmt55.setString(19, transactionNo);
							pstmt55.setString(20, rsSource);
							pstmt55.setString(21, rsDestination);
							pstmt55.setInt(22, tripSheetNo);
							pstmt55.setString(23, commStatus);
							inserted = pstmt55.executeUpdate();
							rs = pstmt55.getGeneratedKeys();
							if (rs.next()) {
								uniqueId = rs.getInt(1);
							}
							if (uniqueId > 0) {
								util.insertActualQuantity(pId, actualQuantity, conAdmin, tripSheetNo);
								logWriter.log(" Updated permit balance actualPermitQuantity==" + actualPermitQuantity
										+ " actualQuantity==" + actualQuantity, LogWriter.INFO);

								logWriter.log(" BEFORE UPDATE BARGE QUANTITY==" + (bargeQty), LogWriter.INFO);

								try {
									util.updateBargeQuantityToTripDetails(customerId, systemId, actualQuantity, bargeId,
											conAdmin);
								} catch (Exception e1) {
									System.out.println("error in updating qty in barge" + e1.toString());
									StringWriter errors1 = new StringWriter();
									e1.printStackTrace(new PrintWriter(errors1));
									logWriter.log(errors1.toString(), LogWriter.ERROR);
									if (conAdmin != null) {
										try {
											pstmt55 = conAdmin.prepareStatement(
													"insert into AMS.dbo.EmailQueue(Subject,Body,EmailList,SystemId) values (?,?,?,?)");
											pstmt55.setString(1,
													"error in saveTripSheetDetailsInformationForTruck for SystemId "
															+ systemId + " for tripNo== " + tripNo + "-"
															+ tripSheetNotoGrid);
											pstmt55.setString(2, errors1.toString());
											pstmt55.setString(3,
													"gayatri.p@telematics4u.com,praveen.c@telematics4u.com,namrata.d@telematics4u.com,jayaram.r@telematics4u.com,naveen.kk@telematics4u.com,meghana.g@telematics4u.com");
											pstmt55.setInt(4, systemId);
											pstmt55.executeUpdate();
											logWriter.log("Record inserted in EmailQueue", LogWriter.INFO);
										} catch (SQLException e3) {
											e3.printStackTrace();
										}
									}
								}
								logWriter.log(" AFTER UPDATE BARGE QUANTITY==" + (bargeQty + actualQuantity),
										LogWriter.INFO);

								if (permittype.equalsIgnoreCase("Import Transit Permit")) {
									logWriter.log(" Inside Import updation method", LogWriter.INFO);
									float impFines = 0;
									float impLumps = 0;
									float impConc = 0;
									float impTailings = 0;
									actualQuantity = actualQuantity / 1000;
									if ((gradetype.toUpperCase()).contains("FINE")) {
										impFines = actualQuantity;
									} else if ((gradetype.toUpperCase()).contains("LUMP")) {
										impLumps = actualQuantity;
									} else if ((gradetype.toUpperCase()).contains("CONCENTRATES")) {
										impConc = actualQuantity;
									} else if ((gradetype.toUpperCase()).contains("TAILINGS")) {
										impTailings = actualQuantity;
									}
									logWriter.log("Imported fines== " + impFines + " imported Lumps== " + impLumps
											+ " imported Conc== " + impConc + " imported Tailings== " + impTailings,
											LogWriter.INFO);
									util.updateImportQuantiryInOrgMaster(conAdmin, orgCode, impFines, impLumps, impConc,
											impTailings);
								}
								if (permittype.equalsIgnoreCase("Processed Ore Transit")
										|| permittype.equalsIgnoreCase("Bauxite Transit")
										|| permittype.equalsIgnoreCase("Processed Ore Sale Transit")
										|| permittype.equalsIgnoreCase("Purchased Rom Sale Transit Permit")) {
									int destinationhub = 0;
									pstmt55 = conAdmin.prepareStatement(IronMiningStatement.GET_DESTINATION_FROM_ROUTE);
									pstmt55.setInt(1, systemId);
									pstmt55.setInt(2, customerId);
									pstmt55.setInt(3, Integer.parseInt(routeId));
									rs55 = pstmt55.executeQuery();
									if (rs55.next()) {
										destinationhub = rs55.getInt("End_Hubid");
									}
									float fines = 0;
									float lumps = 0;
									float totalqty = 0;
									float concentrates = 0;
									float tailings = 0;
									actualQuantity = actualQuantity / 1000;
									if (!permittype.equalsIgnoreCase("Purchased Rom Sale Transit Permit")) {
										if ((gradetype.toUpperCase()).contains("FINE")) {
											fines = actualQuantity;
										} else if ((gradetype.toUpperCase()).contains("LUMP")) {
											lumps = actualQuantity;
										} else if ((gradetype.toUpperCase()).contains("CONCENTRATES")) {
											concentrates = actualQuantity;
										} else if ((gradetype.toUpperCase()).contains("TAILINGS")) {
											tailings = actualQuantity;
										} else {
											totalqty = actualQuantity;
										}
									}
									if (destinationhub > 0) {
										if ((permittype.equalsIgnoreCase("Bauxite Transit")) && orgCode == 0) {
											pstmt55 = null;
											pstmt55 = conAdmin
													.prepareStatement(IronMiningStatement.GET_ORG_NO_BASED_ON_TCNO);
											pstmt55.setInt(1, systemId);
											pstmt55.setInt(2, customerId);
											pstmt55.setInt(3, Integer.parseInt(leaseName));
											rs55 = pstmt55.executeQuery();
											if (rs55.next()) {
												orgCode = rs55.getInt("ORG_ID");
											}
										}
										if (permittype.equalsIgnoreCase("Processed Ore Sale Transit")) {
											orgCode = buyOrgId;
										}
										if (permittype.equalsIgnoreCase("Purchased Rom Sale Transit Permit")) {
											if (destType.equalsIgnoreCase("plant")) {
												int plantId = 0;
												pstmt55 = null;
												pstmt55 = conAdmin.prepareStatement(IronMiningStatement.GET_PLANT_NAMES
														.concat("and HUB_ID=? and MINERAL_TYPE=? "));
												pstmt55.setInt(1, systemId);
												pstmt55.setInt(2, customerId);
												pstmt55.setInt(3, orgCode);
												pstmt55.setInt(4, destinationhub);
												pstmt55.setString(5, mineraltype);
												rs55 = pstmt55.executeQuery();
												if (rs55.next()) {
													plantId = rs55.getInt("ID");
												}
												util.updateROMQuantityInPlantMaster(customerId, systemId, conAdmin,
														mineraltype, actualQuantity, plantId);
											}
											if (destType.equalsIgnoreCase("stock")) {
												pstmt55 = null;
												pstmt55 = conAdmin.prepareStatement(
														IronMiningStatement.GET_STOCK_DETAILS,
														ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
												pstmt55.setInt(1, systemId);
												pstmt55.setInt(2, customerId);
												pstmt55.setInt(3, destinationhub);
												pstmt55.setInt(4, orgCode);
												pstmt55.setString(5, mineraltype);
												rs55 = pstmt55.executeQuery();
												if (rs55.next()) {
													rs55.updateFloat("ROM_QTY",
															rs55.getFloat("ROM_QTY") + actualQuantity);
													rs55.updateRow();
													logWriter.log(
															"Record updated in stock master for purchased rom sale transit",
															LogWriter.INFO);
												} else {
													util.insertStockDetailsForROM(customerId, systemId, conAdmin,
															mineraltype, orgCode, actualQuantity, destinationhub);
													logWriter.log(
															"Record inserted in stock master for purchased rom sale transit",
															LogWriter.INFO);
												}
											}
										}
										if (!permittype.equalsIgnoreCase("Purchased Rom Sale Transit Permit")) {
											pstmt55 = null;
											pstmt55 = conAdmin.prepareStatement(IronMiningStatement.GET_STOCK_DETAILS,
													ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
											pstmt55.setInt(1, systemId);
											pstmt55.setInt(2, customerId);
											pstmt55.setInt(3, destinationhub);
											pstmt55.setInt(4, orgCode);
											pstmt55.setString(5, mineraltype);
											rs55 = pstmt55.executeQuery();
											if (rs55.next()) {
												rs55.updateFloat("FINES", rs55.getFloat("FINES") + fines);
												rs55.updateFloat("LUMPS", rs55.getFloat("LUMPS") + lumps);
												rs55.updateFloat("CONCENTRATES",
														rs55.getFloat("CONCENTRATES") + concentrates);
												rs55.updateFloat("TAILINGS", rs55.getFloat("TAILINGS") + tailings);
												rs55.updateFloat("TOTAL_QTY", rs55.getFloat("TOTAL_QTY") + totalqty);
												rs55.updateRow();
											} else {
												util.insertIntoStockYardMaster(customerId, systemId, conAdmin,
														mineraltype, orgCode, destinationhub, fines, lumps,
														concentrates, tailings, totalqty);
											}
										}
									}
								}
								if (tripSheetType.equals("Train Trip Sheet")) {
									message = String.valueOf(uniqueId);//"Trip Sheet Details Saved Successfully";
								} else {
									message = "1";//Trip Sheet Details Saved Successfully";
								}

							} else {
								logWriter.log("Error in Saving Trip Sheet Details", LogWriter.INFO);
								message = "0";//"Error in Saving Trip Sheet Details";
							}
						}
					} else {
						logWriter.log("Barge Loading has been already stopped by Other user.", LogWriter.INFO);
						message = "Barge Loading has been already stopped.";
					}
				} else {
					logWriter.log("Permit Balance is over or Barge Qty is over.", LogWriter.INFO);
					message = "-1";//"Permit Balance is over. Please change permit";
				}
			} else {
				logWriter.log("Permit is not associated.", LogWriter.INFO);
				message = "-1";//"Permit Balance is over. Please change permit";
			}
		} catch (Exception e) {
			System.out.println("error in Trip Sheet Details :-save Trip Sheet Details" + e.toString());
			message = "0";//"Error in Saving Trip Sheet Details";
			StringWriter errors = new StringWriter();
			e.printStackTrace(new PrintWriter(errors));
			logWriter.log(errors.toString(), LogWriter.ERROR);
			e.printStackTrace();
			logWriter.log("Before inserting", LogWriter.INFO);
			if (conAdmin != null) {
				try {
					pstmt55 = conAdmin.prepareStatement(
							"insert into AMS.dbo.EmailQueue(Subject,Body,EmailList,SystemId) values (?,?,?,?)");
					pstmt55.setString(1, "error in saveTripSheetDetailsInformationForTruck for SystemId " + systemId);
					pstmt55.setString(2, errors.toString());
					pstmt55.setString(3,
							"gayatri.p@telematics4u.com,praveen.c@telematics4u.com,namrata.d@telematics4u.com");
					pstmt55.setInt(4, systemId);
					pstmt55.executeUpdate();
					logWriter.log("Record inserted in EmailQueue", LogWriter.INFO);
				} catch (SQLException e1) {
					e1.printStackTrace();
				}
			}

		} finally {
			DBConnection.releaseConnectionToDB(conAdmin, pstmt55, rs55);
			DBConnection.releaseConnectionToDB(null, pstmt, rs);
			DBConnection.releaseConnectionToDB(null, null, rs1);
			DBConnection.releaseConnectionToDB(null, pstmtU, null);
		}
		logWriter.log(" Ending of the method ", LogWriter.INFO);
		return message;
	}

	public JSONArray getBargeQuantity(String clientId, int systemId, String bargNo) {
		JSONArray JsonArray = new JSONArray();
		JSONObject JsonObject = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		float bargeQuantity = 0;
		try {
			//rfidNumber=getRFIDFromFile(ip);
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(IronMiningStatement.GET_SUM_BARGE_QUANTITY);
			pstmt.setInt(1, systemId);
			pstmt.setString(2, clientId);
			pstmt.setString(3, bargNo);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				bargeQuantity = rs.getFloat("BARGE_QUANTITY");

			}
			JsonObject = new JSONObject();
			JsonObject.put("bargeQuantity", bargeQuantity);
			JsonArray.put(JsonObject);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return JsonArray;
	}

	public String stopBloForBarge(int customerId, String assetNo, String tripSheetNo, int userId, int systemId) {

		String message = "";
		Connection conAdmin = null;
		PreparedStatement pstmt55 = null;
		ResultSet rs55 = null;
		try {
			int inserted = 0;
			conAdmin = DBConnection.getConnectionToDB("AMS");

			pstmt55 = conAdmin.prepareStatement(IronMiningStatement.UPDATE_STATUS_FOR_STOP_BLO);
			pstmt55.setInt(1, userId);
			pstmt55.setInt(2, userId);
			pstmt55.setString(3, assetNo);
			pstmt55.setString(4, tripSheetNo);
			pstmt55.setInt(5, customerId);
			pstmt55.setInt(6, systemId);

			inserted = pstmt55.executeUpdate();
			if (inserted > 0) {
				message = "Trip Sheet Stopped Successfully";
			} else {
				message = "Error in stop blo";
			}
		} catch (Exception e) {
			System.out.println("error in Stop Blo :-save blo status" + e.toString());
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(conAdmin, pstmt55, rs55);
		}
		return message;
	}

	public ArrayList getTripSheetDetailsForTruck(int systemId, int CustomerId, int userId, int bargeId) {
		JSONArray JsonArray = new JSONArray();
		JSONObject JsonObject = null;
		Connection con = null;
		PreparedStatement pstmt52 = null;
		ResultSet rs52 = null;
		int aslcount = 0;
		SimpleDateFormat diffddMMyyyyHHmmss = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
		ArrayList assetLists = new ArrayList();
		DecimalFormat df = new DecimalFormat("#.###");
		ArrayList<String> headersList = new ArrayList<String>();
		ArrayList<ReportHelper> reportsList = new ArrayList<ReportHelper>();
		ReportHelper finalreporthelper = new ReportHelper();

		headersList.add("SLNO");
		headersList.add("Type");
		headersList.add("Trip Sheet Number");
		headersList.add("Asset Number");
		headersList.add("TC Lease Name");
		headersList.add("Organization Name");
		headersList.add("Issued Date");
		headersList.add("Validity Date Time");
		headersList.add("Grade And Mineral Information");
		headersList.add("Route");
		headersList.add("Status");
		headersList.add("Tare Weight1");
		headersList.add("Gross Weight1");
		headersList.add("Net Weight");
		headersList.add("Actual Quantity");
		headersList.add("Permit No");
		headersList.add("Vessel Name");
		headersList.add("Communicating Status");

		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt52 = con.prepareStatement(IronMiningStatement.GET_MINING_TRIP_SHEET_GENERATION_DETAILS_FOR_TRUCK);
			pstmt52.setInt(1, systemId);
			pstmt52.setInt(2, CustomerId);
			pstmt52.setInt(3, bargeId);
			pstmt52.setInt(4, systemId);
			pstmt52.setInt(5, CustomerId);
			pstmt52.setInt(6, bargeId);

			rs52 = pstmt52.executeQuery();
			while (rs52.next()) {
				JsonObject = new JSONObject();
				ArrayList<Object> informationList = new ArrayList<Object>();
				ReportHelper reporthelper = new ReportHelper();
				aslcount++;
				JsonObject.put("slnoIndex", aslcount);
				informationList.add(aslcount);

				JsonObject.put("TypeIndex", rs52.getString("TYPE").toUpperCase());
				informationList.add(rs52.getString("TYPE").toUpperCase());

				JsonObject.put("TripSheetNumberIndex", rs52.getString("TRIP_NO").toUpperCase());
				informationList.add(rs52.getString("TRIP_NO").toUpperCase());

				JsonObject.put("assetNoIndex", rs52.getString("ASSET_NUMBER").toUpperCase());
				informationList.add(rs52.getString("ASSET_NUMBER").toUpperCase());

				JsonObject.put("tcLeaseNoIndex", rs52.getString("LESSE_NAME"));
				informationList.add(rs52.getString("LESSE_NAME"));

				JsonObject.put("orgNameIndex", rs52.getString("ORGANIZATION_NAME"));
				informationList.add(rs52.getString("ORGANIZATION_NAME"));

				JsonObject.put("issuedIndexId", diffddMMyyyyHHmmss.format(rs52.getTimestamp(("ISSUE_DATE"))));
				informationList.add(diffddMMyyyyHHmmss.format(rs52.getTimestamp(("ISSUE_DATE"))));

				if (rs52.getTimestamp("VALIDITY_DATE") == null || rs52.getString("VALIDITY_DATE").equals("")
						|| rs52.getString("VALIDITY_DATE").contains("1900")) {
					JsonObject.put("validityDateDataIndex", "");
					informationList.add("");
				} else {
					JsonObject.put("validityDateDataIndex",
							diffddMMyyyyHHmmss.format(rs52.getTimestamp("VALIDITY_DATE")));
					informationList.add(diffddMMyyyyHHmmss.format(rs52.getTimestamp("VALIDITY_DATE")));
				}

				JsonObject.put("gradeAndMineralIndex", rs52.getString("GRADE_NAME"));
				informationList.add(rs52.getString("GRADE_NAME"));

				JsonObject.put("RouteIndex", rs52.getString("ROUTE_NAME"));
				informationList.add(rs52.getString("ROUTE_NAME"));

				JsonObject.put("statusIndexId", rs52.getString("STATUS"));
				informationList.add(rs52.getString("STATUS"));

				JsonObject.put("q1IndexId", rs52.getString("QUANTITY1"));
				informationList.add(rs52.getString("QUANTITY1"));

				JsonObject.put("QuantityIndex", String.valueOf(rs52.getString("QUANTITY2")).split("\\.")[0]);
				informationList.add(String.valueOf(rs52.getString("QUANTITY2")).split("\\.")[0]);

				JsonObject.put("netIndexId", df.format(rs52.getFloat("QUANTITY2") - rs52.getFloat("QUANTITY1")));
				informationList.add(df.format(rs52.getFloat("QUANTITY2") - rs52.getFloat("QUANTITY1")));

				JsonObject.put("uniqueIDIndex", rs52.getString("ID"));

				JsonObject.put("tcLeaseNoIndexId", rs52.getString("TC_ID"));

				//JsonObject.put("gradeAndMineralIndexId", rs52.getString("GRADE_ID"));

				JsonObject.put("RouteIndexId", rs52.getString("ROUTE_ID"));

				JsonObject.put("actualQtyIndexId", rs52.getString("TRIPSHEET_QTY"));
				informationList.add(rs52.getString("TRIPSHEET_QTY"));

				JsonObject.put("permitIndexId", rs52.getString("PERMIT_ID"));
				informationList.add(rs52.getString("PERMIT_ID"));

				JsonObject.put("shipNameIndexId", rs52.getString("SHIP_NAME"));
				informationList.add(rs52.getString("SHIP_NAME"));

				JsonObject.put("commStatusIndexId", rs52.getString("COMMUNICATION_STATUS"));
				informationList.add(rs52.getString("COMMUNICATION_STATUS"));

				JsonObject.put("permitTypeIndex", rs52.getString("PERMIT_TYPE"));

				JsonArray.put(JsonObject);
				reporthelper.setInformationList(informationList);
				reportsList.add(reporthelper);
			}
			assetLists.add(JsonArray);
			finalreporthelper.setReportsList(reportsList);
			finalreporthelper.setHeadersList(headersList);
			assetLists.add(finalreporthelper);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {

			DBConnection.releaseConnectionToDB(con, pstmt52, rs52);
		}
		return assetLists;
	}

	public ArrayList<ArrayList<String>> getBargePrintTripSheet(int uniqueId, String zone) {
		System.out.println("uniqueId" + uniqueId);
		Connection conAdmin = null;
		PreparedStatement pstmt100 = null;
		ResultSet rs100 = null;
		ArrayList<String> finlist = new ArrayList<String>();
		ArrayList<ArrayList<String>> list = new ArrayList<ArrayList<String>>();
		SimpleDateFormat yyyymmdd = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		SimpleDateFormat ddmmyyyy = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
		DecimalFormat df = new DecimalFormat("0.00");
		try {
			conAdmin = DBConnection.getConnectionToDB("AMS");
			pstmt100 = conAdmin.prepareStatement(IronMiningStatement.GET_BARGE_TRIP_DATA_FOR_PDF);
			pstmt100.setInt(1, uniqueId);
			rs100 = pstmt100.executeQuery();
			while (rs100.next()) {
				finlist.add(rs100.getString("TRIP_NO"));//0
				if (rs100.getString("VALIDITY_DATE") == "" || rs100.getString("VALIDITY_DATE").contains("1900")) {
					finlist.add("");//1
				} else {
					finlist.add(ddmmyyyy.format(yyyymmdd.parse(rs100.getString("VALIDITY_DATE"))));//1
				}

				finlist.add(rs100.getString("ASSET_NUMBER").toUpperCase());//2
				if (rs100.getString("LESSE_NAME") != null && !rs100.getString("LESSE_NAME").equals("")) {
					finlist.add(rs100.getString("LESSE_NAME").toUpperCase());//3
				} else {
					finlist.add(rs100.getString("ORGANIZATION_NAME").toUpperCase());//3
				}
				finlist.add(df.format(rs100.getDouble("BARGE_QUANTITY") != 0 ? rs100.getDouble("BARGE_QUANTITY")
						: rs100.getDouble("BARGE_QUANTITY1")));//4
				finlist.add(df.format(rs100.getDouble("BARGE_CAPACITY")));//5
				if (rs100.getString("ISSUE_DATE") == "" || rs100.getString("ISSUE_DATE").contains("1900")) {
					finlist.add("");//6
				} else {
					finlist.add(ddmmyyyy.format(yyyymmdd.parse(rs100.getString("ISSUE_DATE"))));//6
				}
				finlist.add(rs100.getString("ROUTE_NAME"));//7
				finlist.add(rs100.getString("SOURCE"));//8
				finlist.add(rs100.getString("DESTINATION"));//9
				finlist.add(rs100.getString("ASSET_ID"));//10
				finlist.add(rs100.getString("VESSEL_NAME"));//11
				finlist.add(rs100.getString("DIVERTED_QTY"));//12

			}
			list.add(finlist);
		} catch (Exception e) {
			if (conAdmin != null) {
				try {
					conAdmin.rollback();
				} catch (SQLException e9) {
					e9.printStackTrace();
				}
			}
			e.printStackTrace();
			System.out.println("Inside pdf generation function" + e.toString());
		} finally {
			DBConnection.releaseConnectionToDB(conAdmin, pstmt100, rs100);
		}
		return list;
	}

	public ArrayList<Object> getPermit(int uniqueId) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		ArrayList<Object> finlist = new ArrayList<Object>();
		ArrayList<Object> permitList = new ArrayList<Object>();
		DecimalFormat df = new DecimalFormat("0.00");
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(IronMiningStatement.GET_PERMIT_DETAILS_FOR_BARGE);
			pstmt.setInt(1, uniqueId);
			pstmt.setInt(2, uniqueId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				finlist = new ArrayList<Object>();
				finlist.add(rs.getString("PERMIT_NO"));
				finlist.add(df.format(rs.getDouble("PERMIT_BALANCE")));
				finlist.add(rs.getString("GRADE"));
				finlist.add(rs.getString("SHIP_NAME"));
				permitList.add(finlist);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}

		return permitList;
	}

	public String getVesselName(int uniqueId) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String vesselList = "";
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(IronMiningStatement.GET_VESSEL_NAME_FOR_BARGE_PDF);
			pstmt.setInt(1, uniqueId);
			pstmt.setInt(2, uniqueId);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				vesselList = rs.getString("SHIP_NAME");
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}

		return vesselList;
	}

	public JSONArray getVehicleNoListForTruck(String clientId, int systemId) {
		JSONArray JsonArray = new JSONArray();
		JSONObject JsonObject = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			JsonArray = new JSONArray();
			JsonObject = new JSONObject();
			con = DBConnection.getConnectionToDB("AMS");
			System.out.println("*********getVehicleNoListForTruck started**********" + new Date());
			//		String vehicleno="";
			//		pstmt = con.prepareStatement(IronMiningStatement.GET_ALL_OPEN_ASSETS);
			//		pstmt.setInt(1, systemId);
			//		pstmt.setString(2,clientId);
			//		rs = pstmt.executeQuery();
			//		while (rs.next()) {
			//			vehicleno = vehicleno+"'"+rs.getString("ASSET_NUMBER")+"',";
			//		}
			//		if (vehicleno.length()>0) {
			//			vehicleno = vehicleno.substring(0,vehicleno.length()-1);
			//		}else{
			//			vehicleno = "''";
			//		}
			//		pstmt = null;
			//		rs = null;
			//pstmt = con.prepareStatement(IronMiningStatement.GET_VEHILCE_NO_FOR_BARGE_TRUCK_TRIPSHEET.replace("#", vehicleno));
			pstmt = con.prepareStatement(IronMiningStatement.GET_VEHILCE_NO_FOR_BARGE_TRUCK_TRIPSHEET);
			pstmt.setInt(1, systemId);
			pstmt.setString(2, clientId);
			System.out.println("*********3333333333333**********" + new Date());
			rs = pstmt.executeQuery();
			System.out.println("*********44444444444444444**********" + new Date());
			while (rs.next()) {
				JsonObject = new JSONObject();
				JsonObject.put("vehicleNoID", rs.getString("VID"));
				JsonObject.put("vehicleName", rs.getString("VNAME"));
				JsonObject.put("quantity1", rs.getString("QUANTITY1"));
				JsonObject.put("incExpStatus", rs.getString("INSURANCE_EXPIRED_STATUS"));
				JsonObject.put("pucExpStatus", rs.getString("PUC_EXPIRED_STATUS"));
				JsonArray.put(JsonObject);
			}
			System.out.println("*********getVehicleNoListForTruck ended**********" + new Date());
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}

		return JsonArray;
	}

	public String getGradeDetails(int uniqueId) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String grade = "";
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(IronMiningStatement.GET_GRADE_FOR_BARGE);
			pstmt.setInt(1, uniqueId);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				grade = rs.getString("GRADE_DETAILS");
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}

		return grade;
	}

	public ArrayList<Object> getMiningOrganizationMaster(int systamId, int customerId, int userId) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		ArrayList<ReportHelper> reportsList = new ArrayList<ReportHelper>();
		ArrayList<String> headersList = new ArrayList<String>();
		ReportHelper finalreporthelper = new ReportHelper();
		//ArrayList < Object > list = new ArrayList < Object > ();
		ArrayList<Object> finalList = new ArrayList<Object>();
		headersList.add("SLNO");
		headersList.add("Organization Code");
		headersList.add("Organization Name");
		headersList.add("Alias Name");
		headersList.add("GST No");
		headersList.add("Purchased ROM");
		headersList.add("M-Wallet Balance");
		headersList.add("Imported Fines");
		headersList.add("Imported Lumps");
		headersList.add("Imported Concentrates");
		headersList.add("Imported Tailings");
		headersList.add("ID");
		JSONArray JsonArray = new JSONArray();
		JSONObject JsonObject = null;
		ReportHelper reporthelper = null;
		ArrayList<Object> informationList = null;
		try {
			int count = 0;
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(IronMiningStatement.GET_MINING_ORGANIZATION_MASTER);
			pstmt.setInt(1, systamId);
			pstmt.setInt(2, customerId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				JsonObject = new JSONObject();
				reporthelper = new ReportHelper();
				informationList = new ArrayList<Object>();

				count++;
				JsonObject.put("slnoIndex", count);
				informationList.add(count);

				JsonObject.put("OrganizationCodeIndex", rs.getString("ORGANIZATION_CODE"));
				informationList.add(rs.getString("ORGANIZATION_CODE"));

				JsonObject.put("OrganizationNameIndex", rs.getString("ORGANIZATION_NAME"));
				informationList.add(rs.getString("ORGANIZATION_NAME"));

				JsonObject.put("aliasNameIndex", rs.getString("ALIAS_NAME"));
				informationList.add(rs.getString("ALIAS_NAME"));

				JsonObject.put("gstNoIndex", rs.getString("GST_NO"));
				informationList.add(rs.getString("GST_NO"));

				JsonObject.put("purchROMIndex", rs.getString("PURCHASED_ROM"));
				informationList.add(rs.getString("PURCHASED_ROM"));

				JsonObject.put("mwalletBalanceDataIndex", rs.getString("M_WALLET_BALANCE"));
				informationList.add(rs.getString("M_WALLET_BALANCE"));

				JsonObject.put("impFinesDataIndex", rs.getString("IMP_FINES_QTY"));
				informationList.add(rs.getString("IMP_FINES_QTY"));

				JsonObject.put("impLumpsDataIndex", rs.getString("IMP_LUMPS_QTY"));
				informationList.add(rs.getString("IMP_LUMPS_QTY"));

				JsonObject.put("impConcentratesDataIndex", rs.getString("IMP_CONCENTRATES_QTY"));
				informationList.add(rs.getString("IMP_CONCENTRATES_QTY"));

				JsonObject.put("impTailingsDataIndex", rs.getString("IMP_TAILINGS_QTY"));
				informationList.add(rs.getString("IMP_TAILINGS_QTY"));

				JsonObject.put("UniqueIDIndex", rs.getInt("UniqueID"));
				informationList.add(rs.getInt("UniqueID"));

				JsonArray.put(JsonObject);
				reporthelper.setInformationList(informationList);
				reportsList.add(reporthelper);
			}
			finalreporthelper.setReportsList(reportsList);
			finalreporthelper.setHeadersList(headersList);
			finalList.add(JsonArray);
			finalList.add(finalreporthelper);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}

		return finalList;
	}

	public String insertMiningOrganizationMasterInformation(int systamId, int customerId, String orgCode,
			String orgName, String aliasName, String gstNo) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String message = "";
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(IronMiningStatement.CHECK_ORGANIZATION_CODE);
			pstmt.setInt(1, systamId);
			pstmt.setInt(2, customerId);
			pstmt.setString(3, orgCode);
			rs = pstmt.executeQuery();
			if (!rs.next()) {
				pstmt = con.prepareStatement(IronMiningStatement.INSERT_MINING_ORGANIZATION_MASTER_INFO);
				pstmt.setString(1, orgCode);
				pstmt.setString(2, orgName);
				pstmt.setInt(3, systamId);
				pstmt.setInt(4, customerId);
				pstmt.setString(5, aliasName);
				pstmt.setString(6, gstNo);
				int inserted = pstmt.executeUpdate();
				if (inserted > 0) {
					message = "Saved Successfully";
				}
			} else {
				message = "Organization Code Already Exist.";
			}

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}

		return message;
	}

	public String updateMiningOrganizationMasterInformation(int systamId, int customerId, String orgCode,
			String orgName, int uniqueId, String aliasName, String gstNo) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String message = "";
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(IronMiningStatement.CHECK_ORGANIZATION_CODE
					.replace("and mom.ORGANIZATION_CODE=?", "and mom.ORGANIZATION_CODE=? and ID!=?"));
			pstmt.setInt(1, systamId);
			pstmt.setInt(2, customerId);
			pstmt.setString(3, orgCode);
			pstmt.setInt(4, uniqueId);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				message = "Organization Code Already Exist.";
			} else {
				pstmt = con.prepareStatement(IronMiningStatement.UPDATE_MINING_ORGANIZATION_MASTER_INFO);
				pstmt.setString(1, orgCode);
				pstmt.setString(2, orgName);
				pstmt.setString(3, aliasName);
				pstmt.setString(4, gstNo);
				pstmt.setInt(5, uniqueId);
				int updated = pstmt.executeUpdate();
				if (updated > 0) {
					message = "Updated Successfully";
				} else {
					message = "Error in Updation";
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}

		return message;
	}

	public JSONArray getPermitNoForTruckTripSheet(String clientId, int systemId, int userId) {
		JSONArray JsonArray = new JSONArray();
		JSONObject JsonObject = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		PreparedStatement pstmtop = null;
		ResultSet rs1 = null;
		String permitNo = "";
		int sourceHub = 0;
		DecimalFormat df = new DecimalFormat("#.###");
		float actualQuantity = 0;
		float covertTotons = 0;
		try {
			JsonArray = new JSONArray();
			JsonObject = new JSONObject();
			con = DBConnection.getConnectionToDB("AMS");
			pstmtop = con.prepareStatement(IronMiningStatement.GET_PERMIT_NO);
			pstmtop.setInt(1, systemId);
			pstmtop.setString(2, clientId);
			pstmtop.setInt(3, userId);
			rs1 = pstmtop.executeQuery();
			while (rs1.next()) {
				JsonObject = new JSONObject();
				permitNo = rs1.getString("PERMIT_IDS");
				sourceHub = rs1.getInt("SOURCE_HUBID");
			}
			if (!permitNo.equals("")) {
				pstmt = con.prepareStatement(
						"select pd.TC_ID,pd.ORGANIZATION_CODE,isnull(tc.LESSE_NAME,'NA') as TC_LEASE_NAME,isnull(mm.ORGANIZATION_NAME,'')as ORGANIZATION,pd.PERMIT_NO,pd.ID,pd.CHALLAN_ID,rd.ROUTE_NAME as ROUTE_NAME,rd.ID as ROUTE_ID,"
								+ " (select sum(QUANTITY) from  dbo.CHALLAN_GRADE_DETAILS where CHALLAN_ID=pd.CHALLAN_ID) as QUANTITY, isnull(pd.TRIPSHEET_QTY,0)as TRIPSHEET_QTY,"
								+ " (select sum(QUANTITY) from AMS.dbo.PROCESSED_ORE_PERMIT_DETAILS where PERMIT_ID=pd.ID ) as POTQUANTITY  "
								+ " ,(select GRADE from AMS.dbo.PROCESSED_ORE_PERMIT_DETAILS where PERMIT_ID=pd.ID) as GRADE"
								+ " ,(select TYPE from AMS.dbo.PROCESSED_ORE_PERMIT_DETAILS where PERMIT_ID=pd.ID) as TYPE,isnull(pd.SHIP_NAME,'') as SHIP_NAME"
								+ " from  AMS.dbo.MINING_PERMIT_DETAILS pd  " +
								//" inner  join AMS.dbo.Trip_Master tm on tm.Trip_id=pd.ROUTE_ID and tm.System_id=pd.SYSTEM_ID " +
								" left outer join MINING.dbo.ROUTE_DETAILS rd on rd.ID=pd.ROUTE_ID and rd.SYSTEM_ID=pd.SYSTEM_ID and rd.CUSTOMER_ID=pd.CUSTOMER_ID  "
								+ " left outer join MINING_TC_MASTER tc on tc.ID=pd.TC_ID and tc.SYSTEM_ID=pd.SYSTEM_ID and tc.CUSTOMER_ID=pd.CUSTOMER_ID   "
								+ " left outer join AMS.dbo.MINING_ORGANIZATION_MASTER mm on mm.ID=pd.ORGANIZATION_CODE and mm.SYSTEM_ID=pd.SYSTEM_ID and mm.CUSTOMER_ID=pd.CUSTOMER_ID  "
								+ " where  pd.SYSTEM_ID=? and pd.CUSTOMER_ID = ? and  pd.ID in (" + permitNo
								+ ") and rd.SOURCE_HUB_ID=" + sourceHub
								+ " and PERMIT_TYPE not in ('Rom Transit','Bauxite Transit') and pd.STATUS in ('APPROVED','ACKNOWLEDGED') and DATEADD(dd, 0, DATEDIFF(dd, 0, GETDATE()))>=pd.START_DATE and DATEADD(dd, 0, DATEDIFF(dd, 0, GETDATE()))<=pd.END_DATE ");

				pstmt.setInt(1, systemId);
				pstmt.setString(2, clientId);
				rs = pstmt.executeQuery();
				while (rs.next()) {
					JsonObject = new JSONObject();
					JsonObject.put("routeId", rs.getString("ROUTE_ID"));
					JsonObject.put("routeName", rs.getString("ROUTE_NAME"));
					if (rs.getInt("CHALLAN_ID") > 0) {
						JsonObject.put("quantity", df.format(rs.getFloat("QUANTITY")));
					} else {
						JsonObject.put("quantity", df.format(rs.getFloat("POTQUANTITY")));
					}
					JsonObject.put("permitNo", rs.getString("PERMIT_NO"));
					actualQuantity = rs.getFloat("TRIPSHEET_QTY");
					covertTotons = actualQuantity / 1000;
					JsonObject.put("pId", rs.getInt("ID"));
					if (rs.getInt("CHALLAN_ID") > 0) {
						JsonObject.put("tripSheetQty", df.format(rs.getFloat("QUANTITY") - covertTotons));
					} else {
						JsonObject.put("tripSheetQty", df.format(rs.getFloat("POTQUANTITY") - covertTotons));
					}
					if (rs.getString("TYPE").equals("")) {
						JsonObject.put("grade", rs.getString("GRADE"));
					} else {
						JsonObject.put("grade", rs.getString("GRADE") + "(" + rs.getString("TYPE") + ")");
					}
					//JsonObject.put("grade", rs.getString("GRADE")+"("+rs.getString("TYPE")+")");
					JsonObject.put("tcId", rs.getString("TC_ID"));
					JsonObject.put("orgCode", rs.getString("ORGANIZATION_CODE"));
					JsonObject.put("leaseName", rs.getString("TC_LEASE_NAME"));
					JsonObject.put("orgName", rs.getString("ORGANIZATION"));
					JsonObject.put("motherVessel", rs.getString("SHIP_NAME"));
					JsonArray.put(JsonObject);
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return JsonArray;
	}

	public int updateBargeQuantity(float bargeQty, float actualQty, int systemId, int customerId, int bargeId) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int inserted = 0;

		try {
			//rfidNumber=getRFIDFromFile(ip);
			con = DBConnection.getConnectionToDB("AMS");
			util.updateBargeQuantityToTripDetails(customerId, systemId, actualQty, bargeId, con);

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return inserted;
	}

	//************************************UserTcAssociation***********************************//
	public JSONArray getUsersBasedOnCustomer(int systemId, int custId) {
		JSONArray JsonArray = null;
		JSONObject JsonObject = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			JsonArray = new JSONArray();
			con = DBConnection.getConnectionToDB("ADMINISTRATOR");
			pstmt = con.prepareStatement(IronMiningStatement.GET_USERS);
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
				pstmt = con.prepareStatement(IronMiningStatement.GET_NON_ASSOCIATION_DATA);
				pstmt.setInt(1, customerId);
				pstmt.setInt(2, systemId);
				pstmt.setInt(3, userId);
				pstmt.setInt(4, systemId);
				pstmt.setInt(5, customerId);
				pstmt.setInt(6, systemId);
				pstmt.setInt(7, userId);
				pstmt.setInt(8, systemId);
				rs = pstmt.executeQuery();
			} else {
				pstmt = con.prepareStatement(IronMiningStatement.GET_NON_ASSOCIATION_DATA_FOR_LTSP_USERS);
				pstmt.setInt(1, systemId);
				pstmt.setInt(2, userId);
				pstmt.setInt(3, systemId);
				pstmt.setInt(4, systemId);
				pstmt.setInt(5, userId);
				pstmt.setInt(6, systemId);
				rs = pstmt.executeQuery();
			}
			while (rs.next()) {
				JsonObject = new JSONObject();
				count++;
				JsonObject.put("slnoIndex", count);
				JsonObject.put("tcNameDataIndex", rs.getString("TC_NO"));
				JsonObject.put("orgNameDataIndex", rs.getString("ORGANIZATION_NAME"));
				JsonObject.put("tcIdDataIndex", rs.getString("TC_ID"));
				JsonObject.put("orgIdDataIndex", rs.getString("ORG_ID"));
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
				pstmt = con.prepareStatement(IronMiningStatement.GET_ASSOCIATION_DATA);
				pstmt.setInt(1, userId);
				pstmt.setInt(2, systemId);
				pstmt.setInt(3, customerId);
				rs = pstmt.executeQuery();
			} else {
				pstmt = con.prepareStatement(IronMiningStatement.GET_ASSOCIATION_DATA_FOR_LTSP_USERS);
				pstmt.setInt(1, userId);
				pstmt.setInt(2, systemId);
				rs = pstmt.executeQuery();
			}
			while (rs.next()) {
				JsonObject = new JSONObject();
				count++;
				JsonObject.put("slnoIndex2", count);
				JsonObject.put("tcNameDataIndex2", rs.getString("TC_NO"));
				JsonObject.put("orgNameDataIndex2", rs.getString("ORGANIZATION_NAME"));
				JsonObject.put("tcIdDataIndex2", rs.getString("TC_ID"));
				JsonObject.put("orgIdDataIndex2", rs.getString("ORG_ID"));
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

	public String associateGroup(int customerId, int systemId, int userIdFromJsp, JSONArray js, int userId) {
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
			for (int i = 0; i < js.length(); i++) {
				vehicleList.clear();
				JSONObject obj = js.getJSONObject(i);
				String tcId = obj.getString("tcIdDataIndex");
				String orgid = obj.getString("orgIdDataIndex");
				pstmt2 = con.prepareStatement(IronMiningStatement.CHECK_IF_PRESENT);
				pstmt2.setInt(1, userIdFromJsp);
				pstmt2.setString(2, tcId);
				pstmt2.setString(3, orgid);
				pstmt2.setInt(4, systemId);
				rs1 = pstmt2.executeQuery();
				if (!rs1.next()) {
					pstmt3 = con.prepareStatement(IronMiningStatement.INSERT_INTO_USER_TC_ASSOCIATION);
					pstmt3.setInt(1, userIdFromJsp);
					pstmt3.setString(2, tcId);
					pstmt3.setInt(3, systemId);
					pstmt3.setInt(4, userId);
					pstmt3.setString(5, orgid);
					pstmt3.executeUpdate();
				}
			}
			message = "Associated Successfully.";
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
			DBConnection.releaseConnectionToDB(null, pstmt2, rs1);
			DBConnection.releaseConnectionToDB(null, pstmt3, null);
		}
		return message;
	}

	public String dissociateGroup(int customerId, int systemId, int userIdFromJsp, JSONArray js, int userId) {
		Connection con = null;
		PreparedStatement pstmt2 = null;
		PreparedStatement pstmt = null;
		String message = "";
		try {
			con = DBConnection.getConnectionToDB("AMS");
			for (int i = 0; i < js.length(); i++) {
				JSONObject obj = js.getJSONObject(i);
				String tcId = obj.getString("tcIdDataIndex2");
				String orgid = obj.getString("orgIdDataIndex2");
				pstmt = con.prepareStatement(IronMiningStatement.MOVE_DATA_TO_USER_TC_ASSOCIATION_HISTORY);
				pstmt.setInt(1, userId);
				pstmt.setInt(2, userIdFromJsp);
				pstmt.setString(3, tcId);
				pstmt.setString(4, orgid);
				pstmt.setInt(5, systemId);
				int inserted1 = pstmt.executeUpdate();
				if (inserted1 > 0) {
					pstmt2 = con.prepareStatement(IronMiningStatement.DELETE_FROM_USER_TC_ASSOCIATION);
					pstmt2.setInt(1, userIdFromJsp);
					pstmt2.setString(2, tcId);
					pstmt2.setString(3, orgid);
					pstmt2.setInt(4, systemId);
					pstmt2.executeUpdate();
				}
			}
			message = "Disassociated Successfully.";
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt2, null);
			DBConnection.releaseConnectionToDB(null, pstmt, null);
		}
		return message;
	}

	public JSONArray getEwalletNumber(int customerId, int systemId, int permitId) {
		JSONArray JsonArray = null;
		JSONObject JsonObject = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			JsonArray = new JSONArray();
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(IronMiningStatement.GET_EWALLET_NO_QTY);
			pstmt.setInt(1, permitId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				JsonObject = new JSONObject();
				JsonObject.put("ewalletId", rs.getInt("ID"));
				JsonObject.put("ewalletNo", rs.getString("CHALLAN_NO"));
				JsonObject.put("qty", rs.getFloat("QUANTITY"));
				JsonObject.put("amount", rs.getString("TOTAL_PAYABLE"));
				JsonObject.put("usedQty", rs.getFloat("USED_QTY"));
				JsonObject.put("usedAmount", rs.getFloat("USED_AMOUNT"));
				JsonObject.put("giopfStatus", rs.getString("STATUS"));
				JsonArray.put(JsonObject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return JsonArray;
	}

	public JSONArray getEwalletDetails(int customerId, int systemId, int pid) {
		JSONArray JsonArray = null;
		JSONObject JsonObject = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		SimpleDateFormat diffddMMyyyyHHmmss = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
		try {
			JsonArray = new JSONArray();
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(IronMiningStatement.GET_EWALLET_DETAILS);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, customerId);
			pstmt.setInt(3, pid);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				JsonObject = new JSONObject();
				JsonObject.put("ewalletQty", rs.getString("EWALLET_QTY"));
				JsonObject.put("ewalletAmount", rs.getString("EWALLET_AMOUNT"));
				JsonArray.put(JsonObject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return JsonArray;
	}

	public JSONArray getGradefortrip(String clientId, int systemId, int userId, String pid, String permitno,
			String srcType) {
		JSONArray JsonArray = new JSONArray();
		JSONObject JsonObject = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		boolean existGrade = false;
		try {
			JsonArray = new JSONArray();
			JsonObject = new JSONObject();
			con = DBConnection.getConnectionToDB("AMS");
			if (permitno.startsWith("RTP") && srcType.equalsIgnoreCase("E-Wallet")) {
				pstmt = con.prepareStatement(IronMiningStatement.GET_GRADE_FOR_RTP);
				pstmt.setString(1, pid);
				rs = pstmt.executeQuery();
				while (rs.next()) {
					existGrade = true;
					JsonObject = new JSONObject();
					JsonObject.put("gradeName", rs.getString("GRADE"));
					JsonArray.put(JsonObject);
				}
			} else {
				pstmt = con.prepareStatement(IronMiningStatement.GET_GRADE_FOR_OTHERS);
				pstmt.setString(1, pid);
				rs = pstmt.executeQuery();
				while (rs.next()) {
					existGrade = true;
					JsonObject = new JSONObject();
					if (rs.getString("TYPE").equals("")) {
						JsonObject.put("gradeName", rs.getString("GRADE"));
					} else {
						JsonObject.put("gradeName", rs.getString("GRADE") + "(" + rs.getString("TYPE") + ")");
					}
					JsonArray.put(JsonObject);
				}
			}
			if (!existGrade) {
				JsonObject = new JSONObject();
				JsonObject.put("gradeName", "NA");
				JsonArray.put(JsonObject);
			}

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}

		return JsonArray;
	}

	public JSONArray getTCNumberDetailsForPermit(int customerId, int systemId, int userId) {
		JSONArray JsonArray = null;
		JSONObject JsonObject = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			JsonArray = new JSONArray();
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(IronMiningStatement.GET_TC_NUMBER_PERMIT);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, customerId);
			pstmt.setInt(3, userId);
			pstmt.setInt(4, systemId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				JsonObject = new JSONObject();
				JsonObject.put("TCno", rs.getString("TC_NO"));
				JsonObject.put("MiningName", rs.getString("NAME_OF_MINE"));
				JsonObject.put("TCID", rs.getInt("ID"));
				JsonObject.put("MineCode", rs.getString("MINE_CODE"));
				JsonObject.put("ownerName", rs.getString("OWNER_NAME"));
				JsonObject.put("orgName", rs.getString("ORGANIZATION_NAME"));
				JsonObject.put("orgCode", rs.getString("ORGANIZATION_CODE"));
				JsonObject.put("quantity", rs.getString("QUANTITY"));
				JsonObject.put("orgId", rs.getString("ORG_ID"));
				JsonObject.put("mwalletBal", rs.getString("M_WALLET_BALANCE"));
				JsonObject.put("aliasName", rs.getString("ALIAS_NAME"));
				JsonObject.put("ctoDate", rs.getString("CTO_DATE"));
				JsonArray.put(JsonObject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return JsonArray;
	}

	public JSONArray getBuyingOrgName(int customerId, int systemId, int userId, int orgcode) {
		JSONArray JsonArray = null;
		JSONObject JsonObject = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			JsonArray = new JSONArray();
			con = DBConnection.getConnectionToDB("AMS");
			if (orgcode == 0) {
				pstmt = con.prepareStatement(IronMiningStatement.GET_BUYING_ORG_NAME);
			} else {
				pstmt = con
						.prepareStatement(IronMiningStatement.GET_BUYING_ORG_NAME + "and ID not in(" + orgcode + ")");
			}
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, customerId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				JsonObject = new JSONObject();
				JsonObject.put("BuyingOrgName", rs.getString("ORGANIZATION_NAME"));
				JsonObject.put("BuyingOrgCode", rs.getString("ORGANIZATION_CODE"));
				JsonObject.put("ID", rs.getString("ID"));
				JsonArray.put(JsonObject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return JsonArray;
	}

	public JSONArray getCustomer(int SystemId, String ltsp, int customerIdlogin) {
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject = new JSONObject();
		Connection conAdmin = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			jsonArray = new JSONArray();
			jsonObject = new JSONObject();

			conAdmin = DBConnection.getConnectionToDB("ADMINISTRATOR");
			if (customerIdlogin > 0) {
				pstmt = conAdmin.prepareStatement(CommonStatements.GET_CUSTOMER_FOR_LOGGED_IN_CUST);
				pstmt.setInt(1, SystemId);
				pstmt.setInt(2, customerIdlogin);
			} else {
				pstmt = conAdmin.prepareStatement(CommonStatements.GET_CUSTOMER);
				pstmt.setInt(1, SystemId);
			}
			rs = pstmt.executeQuery();
			//if we want to give option to select whole ltsp
			if (ltsp.equals("yes")) {
				jsonObject = new JSONObject();
				jsonObject.put("CustId", 0);
				jsonObject.put("CustName", "LTSP");
				jsonArray.put(jsonObject);
			}
			while (rs.next()) {
				jsonObject = new JSONObject();
				int custId = rs.getInt("CUSTOMER_ID");
				String custName = rs.getString("NAME");
				String status = rs.getString("STATUS");
				String activationstatus = rs.getString("ACTIVATION_STATUS");
				jsonObject.put("CustId", custId);
				jsonObject.put("CustName", custName);
				jsonObject.put("Status", status);
				jsonObject.put("ActivationStatus", activationstatus);
				jsonArray.put(jsonObject);
			}
		} catch (Exception e) {
			System.out.println("Error in getCustomer " + e.toString());
		} finally {
			DBConnection.releaseConnectionToDB(conAdmin, pstmt, rs);
		}
		return jsonArray;
	}

	public String saveTripSheetDetailsInformationForImport(int systemId, int customerId, int userId, JSONArray simJs,
			int bargeId, float bargeCapacity, String bargeNo, String tripNo, int userSettingId, int srcHubId,
			int desHubId) {

		float actualPermitQuantity = 0;
		String message = "";
		Connection conAdmin = null;
		PreparedStatement pstmt = null;
		PreparedStatement pstmt55 = null;
		PreparedStatement pstmtU = null;
		ResultSet rs55 = null;
		ResultSet rs = null;
		LogWriter logWriter = null;
		try {
			int inserted = 0;
			int tripSheetNo = 0;
			float bargeQty = 0;
			String bargeStatus = "";
			float checkBargeQuantity = 0;
			float actualQuantity = 0;
			float bargeAvailableQuantity;
			float permitAvailableQuantity;
			float truckQuantity;
			SimpleDateFormat yyyymmdd = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			SimpleDateFormat ddmmyyyy = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");

			Properties properties = ApplicationListener.prop;
			String logFile = properties.getProperty("LogFileForBargeTruckImport");
			String logFileName = logFile.substring(0, logFile.lastIndexOf("."));
			String logFileExt = logFile.substring(logFile.lastIndexOf(".") + 1, logFile.length());
			logFile = logFileName + "-" + sdf.format(new Date()) + "." + logFileExt;

			PrintWriter pw;

			if (logFile != null) {
				try {
					pw = new PrintWriter(new FileWriter(logFile, true), true);
					logWriter = new LogWriter("saveTripSheetDetailsInformationForImport", LogWriter.INFO, pw);
					;
					logWriter.setPrintWriter(pw);
				} catch (IOException e) {
					logWriter.log("Can't open the log file: " + logFile + ". Using System.err instead",
							LogWriter.ERROR);
				}
			}
			conAdmin = DBConnection.getConnectionToDB("AMS");

			logWriter.log(" Entering Method", LogWriter.INFO);

			for (int i = 0; i < simJs.length(); i++) {
				JSONObject obj = simJs.getJSONObject(i);
				if (obj.getString("importtripstatusindex").equalsIgnoreCase("Valid")) {
					logWriter.log(" Inside For Loop", LogWriter.INFO);
					Calendar gcalendar = new GregorianCalendar();
					int year = gcalendar.get(Calendar.YEAR);
					Calendar cal = Calendar.getInstance();
					String curyear = String.valueOf(year);
					String curmonth = new SimpleDateFormat("MM").format(cal.getTime());
					System.out.println(curmonth);
					tripSheetNo = getTripSheetNumberFromPermitDetails(conAdmin, systemId, customerId, curyear,
							Integer.parseInt(obj.getString("importpermitIdindex")));

					pstmt55 = conAdmin.prepareStatement(IronMiningStatement.GET_BARGE_DETAILS_FOR_IMPORT);
					pstmt55.setInt(1, systemId);
					pstmt55.setInt(2, customerId);
					pstmt55.setString(3, bargeNo);
					rs = pstmt55.executeQuery();
					if (rs.next()) {
						checkBargeQuantity = rs.getFloat("BARGEQUANTITY");
					}

					pstmt55 = conAdmin.prepareStatement(IronMiningStatement.GET_ACTUAL_QUANTITY);
					pstmt55.setInt(1, Integer.parseInt(obj.getString("importpermitIdindex")));
					rs55 = pstmt55.executeQuery();
					while (rs55.next()) {
						actualPermitQuantity = rs55.getFloat("ACTUAL_QUANTITY");
					}
					bargeAvailableQuantity = bargeCapacity - (checkBargeQuantity / 1000);
					permitAvailableQuantity = Float.parseFloat(obj.getString("importpermitQtyindex"))
							- (actualPermitQuantity / 1000);
					truckQuantity = (Float.parseFloat(obj.getString("importgrossWeightindex"))
							- Float.parseFloat(obj.getString("importtareWeightindex"))) / 1000;
					logWriter.log(" bargeAvailableQuantity==" + bargeAvailableQuantity + " truckQuantity=="
							+ truckQuantity + " permitAvailableQuantity==" + permitAvailableQuantity
							+ " truckQuantity==" + truckQuantity, LogWriter.INFO);
					if (bargeAvailableQuantity > truckQuantity && permitAvailableQuantity > truckQuantity) {

						pstmt55 = conAdmin.prepareStatement(IronMiningStatement.GET_BARGE_QUANTITY);
						pstmt55.setInt(1, systemId);
						pstmt55.setInt(2, customerId);
						pstmt55.setInt(3, bargeId);
						rs55 = pstmt55.executeQuery();
						if (rs55.next()) {
							bargeQty = rs55.getFloat("QUANTITY1");
							bargeStatus = rs55.getString("STATUS");
						}
						actualQuantity = Float.parseFloat(obj.getString("importgrossWeightindex"))
								- Float.parseFloat(obj.getString("importtareWeightindex"));
						//		inserted = updateBargeQuantity(bargeQty,actualQuantity,systemId,customerId,bargeId);

						pstmt55 = conAdmin.prepareStatement(IronMiningStatement.CHECK_TRANSACTION_ID);
						pstmt55.setInt(1, systemId);
						pstmt55.setInt(2, customerId);
						pstmt55.setString(3, obj.getString("transactionIDindex"));
						rs55 = pstmt55.executeQuery();
						if (!rs55.next()) {

							if (bargeStatus.equals("OPEN")) {
								util.updateBargeStatusAndRouteToTripDetails(customerId, systemId, bargeId, conAdmin,
										obj.getString("importrouteIdindex"));
							}
							if (bargeStatus.equals("OPEN") || bargeStatus.equals("Start BLO")) {
								synchronized (this) {
									logWriter.log("in synchronized block " + new Date(), LogWriter.INFO);
									rs = util.getPermitCount(systemId,
											Integer.parseInt(obj.getString("importpermitIdindex")), conAdmin);
									if (rs.next()) {
										if (rs.getInt("TRIP_COUNT") > 0) {
											tripSheetNo = rs.getInt("TRIP_COUNT");
											tripSheetNo++;
										}
									}

									//----leading Zeros handling----------------------//  
									String tripSheetNotoGrid = "";
									if (String.valueOf(tripSheetNo).length() <= 5) {
										tripSheetNotoGrid = ("00000" + tripSheetNo)
												.substring(String.valueOf(tripSheetNo).length());
									} else {
										tripSheetNotoGrid = ("000000000" + tripSheetNo)
												.substring(String.valueOf(tripSheetNo).length());
									}
									//-----Insert Mining Asset Enrolment details into MINING_ASSET_ENROLLMENT Table--------//
									logWriter.log(
											" TRIP NO== " + tripNo + "VEHICLE NO=="
													+ obj.getString("importvehicleNoindex") + "GROSS WEIGHT=="
													+ obj.getString("importgrossWeightindex") + "TARE WEIGHT=="
													+ obj.getString("importtareWeightindex") + "PERMIT NO=="
													+ Integer.parseInt(obj.getString("importpermitIdindex"))
													+ "GRADE TYPE== " + obj.getString("importgradeindex")
													+ "LEASE NAME==" + obj.getString("importtcIdindex")
													+ "SOURCE HUBID==" + srcHubId + "DESTINATION HUBID==" + desHubId
													+ "BARGE QUANTITY==" + bargeQty + "BARGE STATUS==" + bargeStatus,
											LogWriter.INFO);

									String currentyear = curyear.substring(Math.max(curyear.length() - 2, 0));
									pstmt55 = conAdmin.prepareStatement(
											IronMiningStatement.SAVE_MINING_TRIP_SHEET_INFORMATION_FOR_TRUCK);
									pstmt55.setString(1, tripNo + "-" + tripSheetNotoGrid);
									pstmt55.setString(2, obj.getString("importtypeindex"));
									pstmt55.setString(3, obj.getString("importvehicleNoindex"));
									pstmt55.setInt(4, Integer.parseInt(obj.getString("importtcIdindex")));
									pstmt55.setString(5,
											yyyymmdd.format(ddmmyyyy.parse(obj.getString("importvalidityDateindex"))));
									pstmt55.setString(6, obj.getString("importgradeindex"));
									pstmt55.setString(7, obj.getString("importgrossWeightindex"));
									pstmt55.setInt(8, Integer.parseInt(obj.getString("importrouteIdindex")));
									pstmt55.setInt(9, systemId);
									pstmt55.setInt(10, customerId);
									pstmt55.setString(11, obj.getString("importtareWeightindex"));
									pstmt55.setInt(12, srcHubId);
									pstmt55.setInt(13, desHubId);
									pstmt55.setInt(14, Integer.parseInt(obj.getString("importpermitIdindex")));
									pstmt55.setInt(15, userId);
									pstmt55.setInt(16, userSettingId);
									pstmt55.setInt(17, Integer.parseInt(obj.getString("importorgCodeindex")));
									pstmt55.setInt(18, bargeId);
									pstmt55.setString(19, obj.getString("transactionIDindex"));
									pstmt55.setString(20, "");
									pstmt55.setString(21, "");
									pstmt55.setInt(22, tripSheetNo);
									pstmt55.setString(23, obj.getString("commStatusindex"));
									inserted = pstmt55.executeUpdate();
									if (inserted > 0) {
										logWriter.log(" TRIPSHEET INSERTED", LogWriter.INFO);
										//updateBargeQuantity(bargeQty,actualQuantity,systemId,customerId,bargeId);
										logWriter.log(" BEFORE UPDATE BARGE QUANTITY==" + (bargeQty), LogWriter.INFO);
										conAdmin = DBConnection.getConnectionToDB("AMS");
										util.updateBargeQuantityToTripDetails(customerId, systemId, actualQuantity,
												bargeId, conAdmin);
										logWriter.log(" After UPDATE BARGE QUANTITY==" + (bargeQty + actualQuantity),
												LogWriter.INFO);
										//UpdateTripSheetNumberForPermitDetails(conAdmin, tripSheetNo, Integer.parseInt(obj.getString("importpermitIdindex")));

										String permittype = "";
										String mineraltype = "";
										pstmt55 = conAdmin.prepareStatement(IronMiningStatement.GET_ACTUAL_QUANTITY);
										pstmt55.setInt(1, Integer.parseInt(obj.getString("importpermitIdindex")));
										rs55 = pstmt55.executeQuery();
										while (rs55.next()) {
											actualPermitQuantity = rs55.getFloat("ACTUAL_QUANTITY");
											permittype = rs55.getString("PERMIT_TYPE");
											mineraltype = rs55.getString("MINERAL");
										}

										util.insertActualQuantity(
												Integer.parseInt(obj.getString("importpermitIdindex")), actualQuantity,
												conAdmin, tripSheetNo);
										logWriter.log(" After UPDATE PERMIT BALANCE actualPermitQuantity=="
												+ actualPermitQuantity + " qty=="
												+ (Float.parseFloat(obj.getString("importgrossWeightindex"))
														- Float.parseFloat(obj.getString("importtareWeightindex"))),
												LogWriter.INFO);
										if (permittype.equalsIgnoreCase("Processed Ore Transit")
												|| permittype.equalsIgnoreCase("Bauxite Transit")) {
											//check insert or update stockyard
											int destinationhub = 0;
											pstmt55 = conAdmin
													.prepareStatement(IronMiningStatement.GET_DESTINATION_FROM_ROUTE);
											pstmt55.setInt(1, systemId);
											pstmt55.setInt(2, customerId);
											pstmt55.setInt(3, Integer.parseInt(obj.getString("importrouteIdindex")));
											rs55 = pstmt55.executeQuery();
											if (rs55.next()) {
												destinationhub = rs55.getInt("End_Hubid");
											}
											float fines = 0;
											float lumps = 0;
											float totalqty = 0;
											float concentrates = 0;
											float tailings = 0;
											actualQuantity = actualQuantity / 1000;
											if ((obj.getString("importgradeindex").toUpperCase()).contains("FINE")) {
												fines = actualQuantity;
											} else if ((obj.getString("importgradeindex").toUpperCase())
													.contains("LUMP")) {
												lumps = actualQuantity;
											} else if ((obj.getString("importgradeindex").toUpperCase())
													.contains("CONCENTRATES")) {
												concentrates = actualQuantity;
											} else if ((obj.getString("importgradeindex").toUpperCase())
													.contains("TAILINGS")) {
												tailings = actualQuantity;
											} else {
												totalqty = actualQuantity;
											}
											if (destinationhub > 0) {
												pstmt55 = null;
												pstmt55 = conAdmin.prepareStatement(
														IronMiningStatement.GET_STOCK_DETAILS,
														ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
												pstmt55.setInt(1, systemId);
												pstmt55.setInt(2, customerId);
												pstmt55.setInt(3, destinationhub);
												pstmt55.setInt(4,
														Integer.parseInt(obj.getString("importorgCodeindex")));
												pstmt55.setString(5, mineraltype);
												rs55 = pstmt55.executeQuery();
												if (rs55.next()) {
													rs55.updateFloat("FINES", rs55.getFloat("FINES") + fines);
													rs55.updateFloat("LUMPS", rs55.getFloat("LUMPS") + lumps);
													rs55.updateFloat("CONCENTRATES",
															rs55.getFloat("CONCENTRATES") + concentrates);
													rs55.updateFloat("TAILINGS", rs55.getFloat("TAILINGS") + tailings);
													rs55.updateFloat("TOTAL_QTY",
															rs55.getFloat("TOTAL_QTY") + totalqty);
													rs55.updateRow();
												} else {
													util.insertIntoStockYardMaster(customerId, systemId, conAdmin,
															mineraltype,
															Integer.parseInt(obj.getString("importorgCodeindex")),
															destinationhub, fines, lumps, concentrates, tailings,
															totalqty);
												}
											}
										}
										message = "Trip Sheet Details Saved Successfully";
									} else {
										logWriter.log(" Error in Saving Trip Sheet Details", LogWriter.INFO);

										message = "Error in Saving Trip Sheet Details";
									}
								}
							} else {
								logWriter.log("Barge Loading has been already stopped by Other user.", LogWriter.INFO);
								message = "Barge Loading has been already stopped.";
							}
						} else {
							logWriter.log(
									"Transaction Id for SLNO:" + obj.getString("importslnoIndex") + " already used",
									LogWriter.INFO);
							message = "Transaction Id for SLNO:" + obj.getString("importslnoIndex") + " already used";
						} //Transaction ID
					} //close of barge quantity check
				} //close of if
			} //for close
			logWriter.log(" Ending of the for loop", LogWriter.INFO);
		} catch (Exception e) {
			System.out.println("error in Trip Sheet Details :-save Trip Sheet Details" + e.toString());
			StringWriter errors = new StringWriter();
			e.printStackTrace(new PrintWriter(errors));
			logWriter.log(errors.toString(), LogWriter.ERROR);
			e.printStackTrace();
			logWriter.log("Before inserting", LogWriter.INFO);
			if (conAdmin != null) {
				try {
					pstmt55 = conAdmin.prepareStatement(
							"insert into AMS.dbo.EmailQueue(Subject,Body,EmailList,SystemId) values (?,?,?,?)");
					pstmt55.setString(1, "error in saveTripSheetDetailsInformationForImport for SystemId " + systemId);
					pstmt55.setString(2, errors.toString());
					pstmt55.setString(3,
							"gayatri.p@telematics4u.com,praveen.c@telematics4u.com,namrata.d@telematics4u.com");
					pstmt55.setInt(4, systemId);
					pstmt55.executeUpdate();
					logWriter.log("Record inserted in EmailQueue", LogWriter.INFO);
				} catch (SQLException e1) {
					e1.printStackTrace();
				}
			}

		} finally {
			DBConnection.releaseConnectionToDB(null, pstmtU, null);
			DBConnection.releaseConnectionToDB(conAdmin, pstmt55, rs55);

		}
		logWriter.log(" Ending of the method", LogWriter.INFO);
		return message;
	}

	public JSONArray getStateList(String countryid) {
		Connection conAdmin = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject = new JSONObject();

		int countrycode = Integer.parseInt(countryid);
		try {
			conAdmin = DBConnection.getConnectionToDB("ADMINISTRATOR");
			pstmt = conAdmin.prepareStatement(IronMiningStatement.GET_STATE_LIST);
			pstmt.setInt(1, countrycode);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				jsonObject = new JSONObject();
				jsonObject.put("StateID", rs.getString("STATE_CODE"));
				jsonObject.put("StateName", rs.getString("STATE_NAME"));
				jsonArray.put(jsonObject);
			}

		} catch (Exception e) {
			System.out.println("Error in State Functions:-getStateList " + e.toString());
		} finally {
			DBConnection.releaseConnectionToDB(conAdmin, pstmt, rs);
		}
		return jsonArray;
	}

	public String cancelTripOfBarge(int customerId, int btsId, int systemId, String reason, String remark) {

		String message = "";
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		float permitQty = 0;
		float bargeqty = 0;
		int permitId;
		int inserted = 0;
		try {
			con = DBConnection.getConnectionToDB("AMS");

			pstmt = con.prepareStatement(IronMiningStatement.GET_PERMIT_QTY_FOR_CANCELLATION);
			pstmt.setInt(1, btsId);
			pstmt.setInt(2, customerId);
			pstmt.setInt(3, systemId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				permitId = rs.getInt("PERMIT_ID");
				permitQty = rs.getFloat("PERMIT_QTY");
				bargeqty = bargeqty + rs.getFloat("PERMIT_QTY");
				inserted = updatePermitQty(permitId, permitQty, customerId, systemId);
			}
			pstmt = con.prepareStatement(IronMiningStatement.UPDATE_REMARK_REASON_FOR_BARGE_CANCELLATION);
			pstmt.setFloat(1, bargeqty);
			pstmt.setString(2, remark);
			pstmt.setString(3, reason);
			pstmt.setInt(4, customerId);
			pstmt.setInt(5, systemId);
			pstmt.setInt(6, btsId);
			pstmt.executeUpdate();
			message = "Trip Cancelled";

		} catch (Exception e) {
			System.out.println("error in Cancel Trip Of barge :-save blo status" + e.toString());
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return message;
	}

	public synchronized int updatePermitQty(int permitID, float permitQty, int customerId, int systemId) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int inserted = 0;
		String permittype = "";
		String mineraltype = "";
		int routeId = 0;
		String gradeType = "";
		int orgCode = 0;
		float netQty = 0;
		int destination = 0;
		int buyOrgId = 0;
		int tcId = 0;
		String destType = "";
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(IronMiningStatement.UPDATE_TRIP_SHEET_QTY_FOR_BARGE_CANCELLATION);
			pstmt.setFloat(1, permitQty);
			pstmt.setInt(2, permitID);
			pstmt.setInt(3, customerId);
			pstmt.setInt(4, systemId);
			inserted = pstmt.executeUpdate();

			pstmt = con.prepareStatement(IronMiningStatement.GET_PERMIT_DETAILS_FOR_CLOSE);
			pstmt.setInt(1, permitID);
			pstmt.setInt(2, systemId);
			pstmt.setInt(3, customerId);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				permittype = rs.getString("PERMIT_TYPE");
				mineraltype = rs.getString("MINERAL");
				routeId = rs.getInt("ROUTE_ID");
				gradeType = rs.getString("TYPE");
				orgCode = rs.getInt("ORGANIZATION_ID");
				buyOrgId = rs.getInt("BUYING_ORG_ID");
				tcId = rs.getInt("TC_ID");
				destType = rs.getString("DEST_TYPE");
			}
			if (permittype.equalsIgnoreCase("Import Transit Permit")) {
				netQty = permitQty / 1000;
				float impFines = 0;
				float impLumps = 0;
				float impConc = 0;
				float impTailings = 0;
				if (gradeType.equalsIgnoreCase("FINES")) {
					impFines = netQty;
				} else if (gradeType.equalsIgnoreCase("LUMPS")) {
					impLumps = netQty;
				} else if (gradeType.equalsIgnoreCase("CONCENTRATES")) {
					impConc = netQty;
				} else if (gradeType.equalsIgnoreCase("TAILINGS")) {
					impTailings = netQty;
				}
				pstmt = con.prepareStatement(IronMiningStatement.UPDATE_IMPORT_QTY_IN_ORG_MASTER_FOR_CANCEL_TRIP);
				pstmt.setFloat(1, impFines);
				pstmt.setFloat(2, impLumps);
				pstmt.setFloat(3, impConc);
				pstmt.setFloat(4, impTailings);
				pstmt.setInt(5, orgCode);
				pstmt.executeUpdate();
			}
			if (permittype.equalsIgnoreCase("Processed Ore Transit") || permittype.equalsIgnoreCase("Bauxite Transit")
					|| permittype.equalsIgnoreCase("Processed Ore Sale Transit")
					|| permittype.equalsIgnoreCase("Purchased Rom Sale Transit Permit")) {
				pstmt = null;
				pstmt = con.prepareStatement(IronMiningStatement.GET_DESTINATION_FROM_ROUTE);
				pstmt.setInt(1, systemId);
				pstmt.setInt(2, customerId);
				pstmt.setInt(3, routeId);
				rs = pstmt.executeQuery();
				if (rs.next()) {
					destination = rs.getInt("End_Hubid");
				}
				float fines = 0;
				float lumps = 0;
				float totalQty = 0;
				float romQty = 0;
				float concentrates = 0;
				float tailings = 0;
				if ((gradeType.toUpperCase()).contains("FINE")) {
					fines = permitQty / 1000;
					romQty = 0;
				} else if ((gradeType.toUpperCase()).contains("LUMP")) {
					lumps = permitQty / 1000;
					romQty = 0;
				} else if ((gradeType.toUpperCase()).contains("CONCENTRATES")) {
					concentrates = permitQty / 1000;
					romQty = 0;
				} else if ((gradeType.toUpperCase()).contains("TAILINGS")) {
					tailings = permitQty / 1000;
					romQty = 0;
				} else {
					totalQty = permitQty / 1000;
					romQty = 0;
				}
				if (permittype.equalsIgnoreCase("Purchased Rom Sale Transit Permit")) {
					if (destType.equalsIgnoreCase("plant")) {
						int plantId = 0;
						pstmt = null;
						pstmt = con.prepareStatement(IronMiningStatement.GET_PLANT_NAMES.concat("and HUB_ID=? "));
						pstmt.setInt(1, systemId);
						pstmt.setInt(2, customerId);
						pstmt.setInt(3, orgCode);
						pstmt.setInt(4, destination);
						rs = pstmt.executeQuery();
						if (rs.next()) {
							plantId = rs.getInt("ID");
						}
						pstmt = con.prepareStatement(IronMiningStatement.UPDATE_ROM_QTY_IN_PLANT_MASTER_FOR_PLANT_FEED);
						pstmt.setFloat(1, permitQty / 1000);
						pstmt.setInt(2, systemId);
						pstmt.setInt(3, customerId);
						pstmt.setInt(4, plantId);
						pstmt.executeUpdate();

					}
					if (destType.equalsIgnoreCase("stock")) {
						romQty = permitQty / 1000;
					}
				}
				if (destination > 0) {
					if (permittype.equalsIgnoreCase("Bauxite Transit") && orgCode == 0) {
						pstmt = null;
						pstmt = con.prepareStatement(IronMiningStatement.GET_ORG_NO_BASED_ON_TCNO);
						pstmt.setInt(1, systemId);
						pstmt.setInt(2, customerId);
						pstmt.setInt(3, tcId);
						rs = pstmt.executeQuery();
						if (rs.next()) {
							orgCode = rs.getInt("ORG_ID");
						}
					}
					if (permittype.equalsIgnoreCase("Processed Ore Sale Transit")) {
						orgCode = buyOrgId;
					}
					if (!destType.equalsIgnoreCase("plant")) {
						pstmt = null;
						pstmt = con.prepareStatement(IronMiningStatement.UPDATE_STOCK_DETAILS_FOR_CANCEL_TRIP);
						pstmt.setFloat(1, fines);
						pstmt.setFloat(2, lumps);
						pstmt.setFloat(3, totalQty);
						pstmt.setFloat(4, romQty);
						pstmt.setFloat(5, concentrates);
						pstmt.setFloat(6, tailings);
						pstmt.setInt(7, destination);
						pstmt.setInt(8, orgCode);
						pstmt.setString(9, mineraltype);
						pstmt.executeUpdate();
					}
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return inserted;
	}

	public String modifyBargeDetails(String validityDateTime, String vesselName, String destination, String boatNote,
			String reason, int uniqueId, int customerId, int systemId, String status, String flag, float divQty,
			float modBargeQty, String tripSheetNo, int userId) {
		String message = "";
		Connection con = null;
		PreparedStatement pstmt = null;
		try {
			con = DBConnection.getConnectionToDB("AMS");
			int updated = 0;
			//			if (status.equalsIgnoreCase("Closed-Completed Trip")|| status.equalsIgnoreCase("Closed-Completed-Modified Trip")) {
			//				status = "Closed-Completed-Modified Trip";
			//			} else {
			//				status = "In-transit Modified";
			//			}
			String query = "";
			if (flag.equals("TRIP")) {
				query = IronMiningStatement.SAVE_MINING_TRIP_SHEET_INFORMATION_FOR_BARGE_DIVERTION
						.replace("##", "AMS.dbo.TRIP_DETAILS").replace("&&", "USER_SETTING_ID");
				pstmt = con.prepareStatement(IronMiningStatement.MODIFY_BARGE_INFORMATION);
				pstmt.setString(1, validityDateTime);
				pstmt.setString(2, "Closed Diverted Trip");
				pstmt.setFloat(3, divQty);
				pstmt.setString(4, boatNote);
				pstmt.setString(5, reason);
				pstmt.setString(6, destination);
				pstmt.setInt(7, userId);
				pstmt.setInt(8, customerId);
				pstmt.setInt(9, systemId);
				pstmt.setInt(10, uniqueId);
				updated = pstmt.executeUpdate();
			}
			if (updated > 0) {
				//if(modBargeQty>divQty){
				pstmt = con.prepareStatement(query);
				pstmt.setString(1, tripSheetNo);
				pstmt.setFloat(2, divQty * 1000);//as QUANTITY1  TRIP_COUNT=isnull(TRIP_COUNT,0)+1 tripSheetNo=tripSheetNo+'-'+CONVERT(varchar(10)
				pstmt.setFloat(3, 0);
				pstmt.setString(4, "In-transit Diverted Trip");
				pstmt.setInt(5, userId);
				pstmt.setString(6, vesselName);
				pstmt.setInt(7, uniqueId);
				int updated1 = pstmt.executeUpdate();
				if (updated1 > 0) {
					message = "Diverted Tripsheet Created successfully";
				} else {
					message = "Trip Sheet Details Modification Failed";
				}
				//}else{ message = "Diverted Tripsheet Closed successfully"; }
			} else {
				message = "Trip Sheet Details Modification Failed";
			}
		} catch (Exception e) {
			System.out
					.println("error in ModifyBargeTripSheetDetails Function:-save Trip Sheet Details  " + e.toString());
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, null);
		}
		return message;
	}

	public JSONArray getImportedPermitNo(int customerId, int systemId, String orgCode) {
		JSONArray JsonArray = null;
		JSONObject JsonObject = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			JsonArray = new JSONArray();
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(IronMiningStatement.GET_IMPORTED_PERMIT_NO);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, customerId);
			pstmt.setInt(3, Integer.parseInt(orgCode));
			rs = pstmt.executeQuery();
			while (rs.next()) {
				JsonObject = new JSONObject();
				JsonObject.put("PermitNo", rs.getString("PERMIT_NO"));
				JsonObject.put("ID", rs.getString("ID"));
				JsonObject.put("processingFeeImport", rs.getString("TOTAL_PROCESSING_FEE"));
				JsonArray.put(JsonObject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return JsonArray;
	}

	public synchronized String deleteChallan(String status, int custId, int sysId, int uniqueId, int userId) {
		String message = "";
		Connection conAdmin = null;
		PreparedStatement pstmt = null;
		int updated = 0;
		try {
			conAdmin = DBConnection.getConnectionToDB("AMS");
			pstmt = conAdmin.prepareStatement(IronMiningStatement.UPDATE_STATUS_FOR_DELETE_RECORD);
			pstmt.setInt(1, userId);
			pstmt.setInt(2, sysId);
			pstmt.setInt(3, custId);
			pstmt.setInt(4, uniqueId);
			updated = pstmt.executeUpdate();
			if (updated > 0) {
				message = "Successfully Deleted";
			}
		} catch (Exception e) {
			e.printStackTrace();
			System.out.println("Inside delete function" + e.toString());
		} finally {
			DBConnection.releaseConnectionToDB(conAdmin, pstmt, null);
		}
		return message;
	}

	public String saveChallanDetailsForOthers(int customerId, String paymentAccHead, String type, String tcNum,
			String mineName, String mineralType, String royalty, String challanType, String financeYr, String CustName,
			int systemId, int userId, String payDesc, float totalPayable, int orgId, String date, String transMonth) {

		String message = "";
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int enrollmentNo = 0;
		String prefix = "";
		int uniqueId = 0;

		try {
			int inserted = 0;
			con = DBConnection.getConnectionToDB("AMS");

			Calendar gcalendar = new GregorianCalendar();
			int year = gcalendar.get(Calendar.YEAR);
			String curyear = String.valueOf(year);

			enrollmentNo = getChallanNumber(con, systemId, customerId, curyear);

			//----leading Zeros handling----------------------//  
			String enrolmentNotoGrid = "";
			if (String.valueOf(enrollmentNo).length() <= 3) {
				enrolmentNotoGrid = ("000" + enrollmentNo).substring(String.valueOf(enrollmentNo).length());
			} else {
				enrolmentNotoGrid = ("000000000" + enrollmentNo).substring(String.valueOf(enrollmentNo).length());
			}

			if (challanType.equalsIgnoreCase("ROM")) {
				prefix = "RM";
			} else if (challanType.equalsIgnoreCase("E-Wallet Challan")) {
				prefix = "EWC";
			} else if (challanType.equalsIgnoreCase("Processed Ore")) {
				prefix = "PO";
			} else if (challanType.equalsIgnoreCase("Tailings")) {
				prefix = "TA";
			} else if (challanType.equalsIgnoreCase("Others")) {
				prefix = "OT";
			} else if (challanType.equalsIgnoreCase("Processing Fee")) {
				prefix = "PF";
			}

			pstmt = con.prepareStatement(IronMiningStatement.SAVE_MINING_CHALLAN_DETAILS,
					PreparedStatement.RETURN_GENERATED_KEYS);
			pstmt.setString(1, prefix + " " + CustName + "" + enrolmentNotoGrid + "/" + curyear);
			pstmt.setString(2, paymentAccHead);
			pstmt.setString(3, type);
			pstmt.setString(4, tcNum);
			pstmt.setString(5, mineName);
			pstmt.setString(6, mineralType);
			pstmt.setString(7, royalty);
			pstmt.setString(8, challanType);
			pstmt.setString(9, financeYr);
			pstmt.setInt(10, systemId);
			pstmt.setInt(11, customerId);
			pstmt.setInt(12, userId);
			pstmt.setString(13, payDesc);
			pstmt.setString(14, date);
			pstmt.setInt(15, 0);
			pstmt.setFloat(16, totalPayable);
			pstmt.setString(17, "NO");
			pstmt.setFloat(18, 0);
			pstmt.setFloat(19, 0);
			pstmt.setFloat(20, 0);
			pstmt.setInt(21, orgId);
			pstmt.setString(22, transMonth);
			inserted = pstmt.executeUpdate();
			rs = pstmt.getGeneratedKeys();
			if (rs.next()) {
				uniqueId = rs.getInt(1);
			}
			if (uniqueId > 0) {
				message = String.valueOf(uniqueId);//"Challan Details Saved Successfully";
			} else {
				message = "0";//"Error in Saving Challan Details";
			}
		} catch (Exception e) {
			System.out.println("error in challan Details:-save challan Details" + e.toString());
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return message;
	}
	//******************************Trader Master Function************************************//

	public String insertTraderMasterInformation(Integer CustId, int systemId, String ibmAppNo, String appDate,
			String type, String ibmTraderNo, String nameOfTrader, String address, String panNo, String iecNo,
			String tinNo, String dmgTraderNo, String dateOfIssue, int userid, String aliasName, String gstNo,
			String appNoTBR) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String message = "";
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(IronMiningStatement.CHECK_ORG_CODE_FOR_TRADER);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, CustId);
			pstmt.setString(3, dmgTraderNo);
			rs = pstmt.executeQuery();
			if (!rs.next()) {
				pstmt = con.prepareStatement(IronMiningStatement.INSERT_MINING_TRADER_MASTER_DETAILS);
				pstmt.setString(1, dmgTraderNo);
				pstmt.setString(2, nameOfTrader);
				pstmt.setString(3, type);
				pstmt.setString(4, ibmAppNo);
				pstmt.setString(5, appDate);
				pstmt.setString(6, ibmTraderNo);
				pstmt.setString(7, address);
				pstmt.setString(8, panNo);
				pstmt.setString(9, iecNo);
				pstmt.setString(10, tinNo);
				pstmt.setString(11, dateOfIssue);
				pstmt.setInt(12, systemId);
				pstmt.setInt(13, CustId);
				pstmt.setInt(14, userid);
				pstmt.setString(15, aliasName);
				pstmt.setString(16, gstNo);
				pstmt.setString(17, appNoTBR);
				int inserted = pstmt.executeUpdate();
				if (inserted > 0) {
					message = "Saved Successfully";
				} else {
					message = "Error saving Trader Details";
				}
			} else {
				message = "DMG " + type + " No Already Exists.";
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return message;
	}

	public String modifyTraderMasterInformation(Integer CustId, int systemId, String ibmAppNo, String appDate,
			String ibmTraderNo, String nameOfTrader, String address, String panNo, String iecNo, String tinNo,
			String dmgTraderNo, String dateOfIssue, int userid, int Id, String aliasName, String gstNo,
			String appNoTBR) {
		String message = "";
		Connection conAdmin = null;
		PreparedStatement pstmt = null;
		try {
			conAdmin = DBConnection.getConnectionToDB("AMS");
			int updated = 0;
			pstmt = conAdmin.prepareStatement(IronMiningStatement.UPDATE_MINING_TRADER_MASTER_DETAILS);
			pstmt.setString(1, dmgTraderNo);
			pstmt.setString(2, nameOfTrader);
			pstmt.setString(3, ibmAppNo);
			pstmt.setString(4, appDate);
			pstmt.setString(5, ibmTraderNo);
			pstmt.setString(6, address);
			pstmt.setString(7, panNo);
			pstmt.setString(8, iecNo);
			pstmt.setString(9, tinNo);
			pstmt.setString(10, dateOfIssue);
			pstmt.setInt(11, userid);
			pstmt.setString(12, aliasName);
			pstmt.setString(13, gstNo);
			pstmt.setString(14, appNoTBR);
			pstmt.setInt(15, Id);

			updated = pstmt.executeUpdate();
			if (updated > 0) {
				message = "Updated Successfully";
			} else {
				message = "Updation Failed";
			}

		} catch (Exception e) {
			System.out.println("error in Updating TraderMaster Details " + e.toString());
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(conAdmin, pstmt, null);
		}
		return message;
	}

	public ArrayList<Object> getTraderMasterDetails(int customerId, int systemId) {
		ArrayList<ReportHelper> reportsList = new ArrayList<ReportHelper>();
		ArrayList<String> headersList = new ArrayList<String>();
		ArrayList<Object> finlist = new ArrayList<Object>();
		ReportHelper finalreporthelper = new ReportHelper();
		JSONArray JsonArray = null;
		JSONObject JsonObject = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		SimpleDateFormat diffddMMyyyy = new SimpleDateFormat("dd-MM-yyyy");
		int count = 0;
		try {
			JsonArray = new JSONArray();
			headersList.add("SLNO");
			headersList.add("Uid");
			headersList.add("Type");
			headersList.add("Application No");
			headersList.add("Application No TBR");
			headersList.add("Application Date");
			headersList.add("IBM Trader No");
			headersList.add("Incorporation Certificate");
			headersList.add("Name Of Trader");
			headersList.add("Name Of RC");
			headersList.add("Address");
			headersList.add("PAN No");
			headersList.add("IEC No");
			headersList.add("Service Tax No");
			headersList.add("TIN NO");
			headersList.add("DMG Trader No");
			headersList.add("DMG RC Code");
			headersList.add("Issued Date");
			headersList.add("Purchased ROM");
			headersList.add("Purchased Processed Ore");
			headersList.add("Alias Name");
			headersList.add("GST No");

			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(IronMiningStatement.GET_TRADER_MASTER_DETAILS);
			pstmt.setInt(1, customerId);
			pstmt.setInt(2, systemId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				count++;
				ReportHelper reporthelper = new ReportHelper();
				JsonObject = new JSONObject();
				ArrayList<Object> informationList = new ArrayList<Object>();

				JsonObject.put("slnoIndex", count);
				informationList.add(count);

				JsonObject.put("uniqueIdDataIndex", rs.getString("ID"));
				informationList.add(rs.getString("ID"));

				String type = rs.getString("TYPE");
				JsonObject.put("typeIndex", type);
				informationList.add(type);

				JsonObject.put("ibmApplicationNoIndex", rs.getString("IBM_APPLICATION_NO"));
				informationList.add(rs.getString("IBM_APPLICATION_NO"));

				JsonObject.put("applicationNoTBRIndex", rs.getString("TBR_APPLICATION_NO"));
				informationList.add(rs.getString("TBR_APPLICATION_NO"));

				if (rs.getString("APPLICATION_DATE").contains("1900")) {
					JsonObject.put("applicationDateIndex", "");
					informationList.add("");
				} else {
					JsonObject.put("applicationDateIndex", diffddMMyyyy.format(rs.getTimestamp("APPLICATION_DATE")));
					informationList.add(diffddMMyyyy.format(rs.getTimestamp("APPLICATION_DATE")));
				}

				if (type.equals("TRADER")) {
					JsonObject.put("ibmTraderNumberIndex", rs.getString("IBM_TRADER_NO"));
					JsonObject.put("incorpCertIndex", "");
					informationList.add(rs.getString("IBM_TRADER_NO"));
					informationList.add("");
				} else if (type.equals("RAISING CONTRACTOR")) {
					JsonObject.put("ibmTraderNumberIndex", "");
					JsonObject.put("incorpCertIndex", rs.getString("IBM_TRADER_NO"));
					informationList.add("");
					informationList.add(rs.getString("IBM_TRADER_NO"));
				} else {
					JsonObject.put("ibmTraderNumberIndex", "");
					JsonObject.put("incorpCertIndex", "");
					informationList.add("");
					informationList.add("");
				}

				if (type.equals("TRADER")) {
					JsonObject.put("nameOfTraderIndex", rs.getString("ORGANIZATION_NAME"));
					JsonObject.put("nameOfRCIndex", "");
					informationList.add(rs.getString("ORGANIZATION_NAME"));
					informationList.add("");
				} else if (type.equals("RAISING CONTRACTOR")) {
					JsonObject.put("nameOfTraderIndex", "");
					JsonObject.put("nameOfRCIndex", rs.getString("ORGANIZATION_NAME"));
					informationList.add("");
					informationList.add(rs.getString("ORGANIZATION_NAME"));
				} else {
					JsonObject.put("nameOfTraderIndex", "");
					JsonObject.put("nameOfRCIndex", "");
					informationList.add("");
					informationList.add("");
				}

				JsonObject.put("addressIndex", rs.getString("ADDRESS"));
				informationList.add(rs.getString("ADDRESS"));

				JsonObject.put("panNoIndex", rs.getString("PAN_NO"));
				informationList.add(rs.getString("PAN_NO"));

				if (type.equals("TRADER")) {
					JsonObject.put("iecNoIndex", rs.getString("IEC_NUMBER"));
					JsonObject.put("serviceTaxIndex", "");
					informationList.add(rs.getString("IEC_NUMBER"));
					informationList.add("");
				} else if (type.equals("RAISING CONTRACTOR")) {
					JsonObject.put("iecNoIndex", "");
					JsonObject.put("serviceTaxIndex", rs.getString("IEC_NUMBER"));
					informationList.add("");
					informationList.add(rs.getString("IEC_NUMBER"));
				} else {
					JsonObject.put("iecNoIndex", "");
					JsonObject.put("serviceTaxIndex", "");
					informationList.add("");
					informationList.add("");
				}

				JsonObject.put("tinNoIndex", rs.getString("TIN_NO"));
				informationList.add(rs.getString("TIN_NO"));

				if (type.equals("TRADER")) {
					JsonObject.put("dmgTraderNoIndex", rs.getString("ORGANIZATION_CODE"));
					JsonObject.put("dmgRCNoIndex", "");
					informationList.add(rs.getString("ORGANIZATION_CODE"));
					informationList.add("");
				} else if (type.equals("RAISING CONTRACTOR")) {
					JsonObject.put("dmgTraderNoIndex", "");
					JsonObject.put("dmgRCNoIndex", rs.getString("ORGANIZATION_CODE"));
					informationList.add("");
					informationList.add(rs.getString("ORGANIZATION_CODE"));
				} else {
					JsonObject.put("dmgTraderNoIndex", "");
					JsonObject.put("dmgRCNoIndex", "");
					informationList.add("");
					informationList.add("");
				}

				if (rs.getString("DATE_OF_ISSUE").contains("1900")) {
					JsonObject.put("dateOfIssueIndex", "");
					informationList.add("");
				} else {
					JsonObject.put("dateOfIssueIndex", diffddMMyyyy.format(rs.getTimestamp("DATE_OF_ISSUE")));
					informationList.add(diffddMMyyyy.format(rs.getTimestamp("DATE_OF_ISSUE")));
				}

				JsonObject.put("purchasedROMIndex", rs.getString("PURCHASED_ROM"));
				informationList.add(rs.getString("PURCHASED_ROM"));

				JsonObject.put("purchasedProcessedOreIndex", rs.getString("PURCHASED_PROCESSED_ORE"));
				informationList.add(rs.getString("PURCHASED_PROCESSED_ORE"));

				JsonObject.put("aliasNameIndex", rs.getString("ALIAS_NAME"));
				informationList.add(rs.getString("ALIAS_NAME"));

				JsonObject.put("gstNoIndex", rs.getString("GST_NO"));
				informationList.add(rs.getString("GST_NO"));

				JsonArray.put(JsonObject);
				reporthelper.setInformationList(informationList);
				reportsList.add(reporthelper);
			}
			finalreporthelper.setReportsList(reportsList);
			finalreporthelper.setHeadersList(headersList);
			finlist.add(JsonArray);
			finlist.add(finalreporthelper);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return finlist;
	}

	public Date convertStringToDate1(String inputDate) {
		Date dDateTime = null;
		SimpleDateFormat sdfFormatDate = new SimpleDateFormat("yyyy-MM-dd");
		try {
			if (inputDate != null && !inputDate.equals("")) {
				dDateTime = sdfFormatDate.parse(inputDate);
			}
		} catch (Exception e) {
			System.out.println("Error in convertStringToDate method" + e);
			e.printStackTrace();
		}
		return dDateTime;
	}

	public ArrayList getGridDataForMineGrade(String mineralCode, String mineralType) {
		JSONArray JsonArray = null;
		JSONObject JsonObject = null;
		ArrayList<Object> finlist = new ArrayList<Object>();
		try {
			JsonArray = new JSONArray();
			if (mineralType.equals("High Court")) {
				JsonObject = new JSONObject();
				JsonObject.put("SLNOIndex", 1);
				JsonObject.put("gradeIndex", "High Court Grade");
				JsonObject.put("rateIndex", "");
				JsonArray.put(JsonObject);
			} else if (mineralCode.equals("Fe")) {
				JsonObject = new JSONObject();
				JsonObject.put("SLNOIndex", 1);
				JsonObject.put("gradeIndex", "Below 55%");
				JsonObject.put("rateIndex", "");
				JsonArray.put(JsonObject);

				JsonObject = new JSONObject();
				JsonObject.put("SLNOIndex", 2);
				JsonObject.put("gradeIndex", "55% to Below 58%");
				JsonObject.put("rateIndex", "");
				JsonArray.put(JsonObject);

				JsonObject = new JSONObject();
				JsonObject.put("SLNOIndex", 3);
				JsonObject.put("gradeIndex", "58% to Below 60%");
				JsonObject.put("rateIndex", "");
				JsonArray.put(JsonObject);

				JsonObject = new JSONObject();
				JsonObject.put("SLNOIndex", 4);
				JsonObject.put("gradeIndex", "60% to Below 62%");
				JsonObject.put("rateIndex", "");
				JsonArray.put(JsonObject);

				JsonObject = new JSONObject();
				JsonObject.put("SLNOIndex", 5);
				JsonObject.put("gradeIndex", "62% to Below 65%");
				JsonObject.put("rateIndex", "");
				JsonArray.put(JsonObject);

				JsonObject = new JSONObject();
				JsonObject.put("SLNOIndex", 6);
				JsonObject.put("gradeIndex", "65% and above");
				JsonObject.put("rateIndex", "");
				JsonArray.put(JsonObject);
			} else {
				JsonObject = new JSONObject();
				JsonObject.put("SLNOIndex", 1);
				JsonObject.put("gradeIndex", "Below 25%");
				JsonObject.put("rateIndex", "");
				JsonArray.put(JsonObject);

				JsonObject = new JSONObject();
				JsonObject.put("SLNOIndex", 2);
				JsonObject.put("gradeIndex", "25% to Below 35%");
				JsonObject.put("rateIndex", "");
				JsonArray.put(JsonObject);

				JsonObject = new JSONObject();
				JsonObject.put("SLNOIndex", 3);
				JsonObject.put("gradeIndex", "35% to Below 46%");
				JsonObject.put("rateIndex", "");
				JsonArray.put(JsonObject);

				JsonObject = new JSONObject();
				JsonObject.put("SLNOIndex", 4);
				JsonObject.put("gradeIndex", "46% and above");
				JsonObject.put("rateIndex", "");
				JsonArray.put(JsonObject);

				JsonObject = new JSONObject();
				JsonObject.put("SLNOIndex", 5);
				JsonObject.put("gradeIndex", "Dioxide ore");
				JsonObject.put("rateIndex", "");
				JsonArray.put(JsonObject);
			}
			finlist.add(JsonArray);

		} catch (Exception e) {
			e.printStackTrace();
		}
		return finlist;
	}

	public ArrayList<Object> getGridDataForBauxite(int systemId, int custId, int Userid, int id) {

		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		PreparedStatement pstmt1 = null;
		ResultSet rs1 = null;
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject = null;
		int count = 0;
		double LmeRate = 0;
		double tdsPerc = 0;
		double dollarRate = 0;
		double gradeRate = 0;
		double rate = 0;
		double cellAmt = 0;
		double processFeeRate = 0;
		double qty = 0;
		double totalRoyality = 0;
		double royality = 0;
		double totalChallanAmt = 0;
		ArrayList<Object> finlist = new ArrayList<Object>();
		DecimalFormat df = new DecimalFormat("0.00");
		try {
			con = DBConnection.getConnectionToDB("AMS");
			if (id != 0) {
				pstmt = con.prepareStatement(IronMiningStatement.GET_CHALLAN_GRADE_DEATILS);
				pstmt.setInt(1, id);
				pstmt.setInt(2, id);
				pstmt.setInt(3, id);
				pstmt.setInt(4, id);
				rs = pstmt.executeQuery();
				while (rs.next()) {
					count++;
					jsonObject = new JSONObject();
					jsonObject.put("SLNOIndex", count);
					jsonObject.put("uniqueIdIndex", rs.getInt("ID"));
					jsonObject.put("inputDataIndex", rs.getString("GRADE"));
					jsonObject.put("valueDataIndex", rs.getDouble("RATE"));
					jsonArray.put(jsonObject);
					if (rs.getString("GRADE").equals("LME RATE")) {
						LmeRate = rs.getDouble("RATE");
					}
					if (rs.getString("GRADE").equals("DOLLAR RATE")) {
						dollarRate = rs.getDouble("RATE");
					}
					if (rs.getString("GRADE").equals("GRADE RATE")) {
						gradeRate = rs.getDouble("RATE");
					}
					if (rs.getString("GRADE").equals("RATE")) {
						rate = rs.getDouble("RATE");
					}
					if (rs.getString("GRADE").equals("QUANTITY")) {
						qty = rs.getDouble("RATE");
					}
					if (rs.getString("GRADE").equals("CELL AMOUNT RATE")) {
						cellAmt = rs.getDouble("RATE");
					}
					if (rs.getString("GRADE").equals("PROCESSING FEE RATE")) {
						processFeeRate = rs.getDouble("RATE");
					}
					if (rs.getString("GRADE").equals("TDS PERCENTAGE")) {
						tdsPerc = (rs.getDouble("RATE")) / 100;
					}
				}
				royality = (LmeRate * dollarRate * gradeRate) * (rate / 100);
				totalRoyality = ((LmeRate * dollarRate * gradeRate) * (rate / 100)) * qty;
				totalChallanAmt = (totalRoyality) + (totalRoyality * 0.3) + (qty * processFeeRate) + (qty * cellAmt)
						+ (totalRoyality * tdsPerc) + (totalRoyality * 0.02);

				jsonObject = new JSONObject();
				jsonObject.put("SLNOIndex", "");
				jsonObject.put("inputDataIndex", "LME RATE * DOLLAR PRICE");
				jsonObject.put("valueDataIndex", df.format(LmeRate * dollarRate));
				jsonObject.put("statusBuDataIndex", "S1");
				jsonArray.put(jsonObject);

				jsonObject = new JSONObject();
				jsonObject.put("SLNOIndex", "");
				jsonObject.put("inputDataIndex", "(LME RATE * DOLLAR PRICE) * GRADE RATE");
				jsonObject.put("valueDataIndex", df.format(LmeRate * dollarRate * gradeRate));
				jsonObject.put("statusBuDataIndex", "S2");
				jsonArray.put(jsonObject);

				jsonObject = new JSONObject();
				jsonObject.put("SLNOIndex", "");
				jsonObject.put("inputDataIndex", "((LME RATE * DOLLAR PRICE) * GRADE RATE)* RATE/100");
				jsonObject.put("valueDataIndex", df.format(royality));
				jsonObject.put("statusBuDataIndex", "S3");
				jsonArray.put(jsonObject);

				jsonObject = new JSONObject();
				jsonObject.put("SLNOIndex", "");
				jsonObject.put("inputDataIndex", "ROYALTY/M.T.");
				jsonObject.put("valueDataIndex", df.format(royality));
				jsonObject.put("statusBuDataIndex", "S4");
				jsonArray.put(jsonObject);

				jsonObject = new JSONObject();
				jsonObject.put("SLNOIndex", "");
				jsonObject.put("inputDataIndex", "(QUANTITY * ROYALTY)/ M T");
				jsonObject.put("valueDataIndex", df.format(totalRoyality));
				jsonObject.put("statusBuDataIndex", "S5");
				jsonArray.put(jsonObject);

				jsonObject = new JSONObject();
				jsonObject.put("SLNOIndex", "");
				jsonObject.put("inputDataIndex", "TDS");
				jsonObject.put("valueDataIndex", df.format(totalRoyality * tdsPerc));
				jsonObject.put("statusBuDataIndex", "S6");
				jsonArray.put(jsonObject);

				jsonObject = new JSONObject();
				jsonObject.put("SLNOIndex", "");
				jsonObject.put("inputDataIndex", "Cell Amount");
				jsonObject.put("valueDataIndex", df.format(qty * cellAmt));
				jsonObject.put("statusBuDataIndex", "S7");
				jsonArray.put(jsonObject);

				jsonObject = new JSONObject();
				jsonObject.put("SLNOIndex", "");
				jsonObject.put("inputDataIndex", "Processing Fees");
				jsonObject.put("valueDataIndex", df.format(qty * processFeeRate));
				jsonObject.put("statusBuDataIndex", "S8");
				jsonArray.put(jsonObject);

				jsonObject = new JSONObject();
				jsonObject.put("SLNOIndex", "");
				jsonObject.put("inputDataIndex", "DMF (30%)");
				jsonObject.put("valueDataIndex", df.format(totalRoyality * 0.3));
				jsonObject.put("statusBuDataIndex", "S9");
				jsonArray.put(jsonObject);

				jsonObject = new JSONObject();
				jsonObject.put("SLNOIndex", "");
				jsonObject.put("inputDataIndex", "NMET (2%)");
				jsonObject.put("valueDataIndex", df.format((totalRoyality * 0.02)));
				jsonObject.put("statusBuDataIndex", "S10");
				jsonArray.put(jsonObject);

				jsonObject = new JSONObject();
				jsonObject.put("SLNOIndex", "");
				jsonObject.put("inputDataIndex", "TOTAL CHALLAN AMOUNT");
				jsonObject.put("valueDataIndex", df.format(totalChallanAmt));
				jsonObject.put("statusBuDataIndex", "S11");

			} else {
				jsonObject = new JSONObject();
				jsonObject.put("SLNOIndex", "new1");
				jsonObject.put("inputDataIndex", "LME RATE");
				jsonObject.put("valueDataIndex", "");
				jsonObject.put("statusBuDataIndex", "");
				jsonArray.put(jsonObject);

				jsonObject = new JSONObject();
				jsonObject.put("SLNOIndex", "new2");
				jsonObject.put("inputDataIndex", "DOLLAR RATE");
				jsonObject.put("valueDataIndex", "");
				jsonObject.put("statusBuDataIndex", "");
				jsonArray.put(jsonObject);

				jsonObject = new JSONObject();
				jsonObject.put("SLNOIndex", "new3");
				jsonObject.put("inputDataIndex", "GRADE RATE");
				jsonObject.put("valueDataIndex", "");
				jsonObject.put("statusBuDataIndex", "");
				jsonArray.put(jsonObject);

				jsonObject = new JSONObject();
				jsonObject.put("SLNOIndex", "new4");
				jsonObject.put("inputDataIndex", "RATE");
				jsonObject.put("valueDataIndex", "");
				jsonObject.put("statusBuDataIndex", "");
				jsonArray.put(jsonObject);

				jsonObject = new JSONObject();
				jsonObject.put("SLNOIndex", "new5");
				jsonObject.put("inputDataIndex", "QUANTITY");
				jsonObject.put("valueDataIndex", "");
				jsonObject.put("statusBuDataIndex", "");
				jsonArray.put(jsonObject);

				jsonObject = new JSONObject();
				jsonObject.put("SLNOIndex", "new6");
				jsonObject.put("inputDataIndex", "CELL AMOUNT RATE");
				jsonObject.put("valueDataIndex", "");
				jsonObject.put("statusBuDataIndex", "");
				jsonArray.put(jsonObject);

				jsonObject = new JSONObject();
				jsonObject.put("SLNOIndex", "new7");
				jsonObject.put("inputDataIndex", "PROCESSING FEE RATE");
				jsonObject.put("valueDataIndex", "");
				jsonObject.put("statusBuDataIndex", "");
				jsonArray.put(jsonObject);

				jsonObject = new JSONObject();
				jsonObject.put("SLNOIndex", "new8");
				jsonObject.put("inputDataIndex", "TDS PERCENTAGE");
				jsonObject.put("valueDataIndex", "");
				jsonObject.put("statusBuDataIndex", "");
				jsonArray.put(jsonObject);

				jsonObject = new JSONObject();
				jsonObject.put("SLNOIndex", "");
				jsonObject.put("inputDataIndex", "LME RATE * DOLLAR PRICE");
				jsonObject.put("valueDataIndex", "");
				jsonObject.put("statusBuDataIndex", "S1");
				jsonArray.put(jsonObject);

				jsonObject = new JSONObject();
				jsonObject.put("SLNOIndex", "");
				jsonObject.put("inputDataIndex", "(LME RATE * DOLLAR PRICE) * GRADE RATE");
				jsonObject.put("valueDataIndex", "");
				jsonObject.put("statusBuDataIndex", "S2");
				jsonArray.put(jsonObject);

				jsonObject = new JSONObject();
				jsonObject.put("SLNOIndex", "");
				jsonObject.put("inputDataIndex", "((LME RATE * DOLLAR PRICE) * GRADE RATE)* RATE/100");
				jsonObject.put("valueDataIndex", "");
				jsonObject.put("statusBuDataIndex", "S3");
				jsonArray.put(jsonObject);

				jsonObject = new JSONObject();
				jsonObject.put("SLNOIndex", "");
				jsonObject.put("inputDataIndex", "ROYALTY/M.T.");
				jsonObject.put("valueDataIndex", "");
				jsonObject.put("statusBuDataIndex", "S4");
				jsonArray.put(jsonObject);

				jsonObject = new JSONObject();
				jsonObject.put("SLNOIndex", "");
				jsonObject.put("inputDataIndex", "(QUANTITY * ROYALTY)/ M T");
				jsonObject.put("valueDataIndex", "");
				jsonObject.put("statusBuDataIndex", "S5");
				jsonArray.put(jsonObject);

				jsonObject = new JSONObject();
				jsonObject.put("SLNOIndex", "");
				jsonObject.put("inputDataIndex", "TDS");
				jsonObject.put("valueDataIndex", "");
				jsonObject.put("statusBuDataIndex", "S6");
				jsonArray.put(jsonObject);

				jsonObject = new JSONObject();
				jsonObject.put("SLNOIndex", "");
				jsonObject.put("inputDataIndex", "Cell Amount");
				jsonObject.put("valueDataIndex", "");
				jsonObject.put("statusBuDataIndex", "S7");
				jsonArray.put(jsonObject);

				jsonObject = new JSONObject();
				jsonObject.put("SLNOIndex", "");
				jsonObject.put("inputDataIndex", "Processing Fees");
				jsonObject.put("valueDataIndex", "");
				jsonObject.put("statusBuDataIndex", "S8");
				jsonArray.put(jsonObject);

				jsonObject = new JSONObject();
				jsonObject.put("SLNOIndex", "");
				jsonObject.put("inputDataIndex", "DMF (30%)");
				jsonObject.put("valueDataIndex", "");
				jsonObject.put("statusBuDataIndex", "S9");
				jsonArray.put(jsonObject);

				jsonObject = new JSONObject();
				jsonObject.put("SLNOIndex", "");
				jsonObject.put("inputDataIndex", "NMET (2%)");
				jsonObject.put("valueDataIndex", "");
				jsonObject.put("statusBuDataIndex", "S10");
				jsonArray.put(jsonObject);

				jsonObject = new JSONObject();
				jsonObject.put("SLNOIndex", "");
				jsonObject.put("inputDataIndex", "TOTAL CHALLAN AMOUNT");
				jsonObject.put("valueDataIndex", "");
				jsonObject.put("statusBuDataIndex", "S11");

			}
			jsonArray.put(jsonObject);
			finlist.add(jsonArray);

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(null, pstmt1, rs1);
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return finlist;
	}

	public ArrayList<Object> getGridDataForBauxiteChallan(int systemId, int Userid, int id) {

		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject = null;
		int count = 0;
		double LmeRate = 0;
		double tdsPerc = 0;
		double dollarRate = 0;
		double gradeRate = 0;
		double rate = 0;
		double cellAmt = 0;
		double processFeeRate = 0;
		double qty = 0;
		double totalRoyality = 0;
		double royality = 0;
		double totalChallanAmt = 0;
		ArrayList<Object> finlist = new ArrayList<Object>();
		DecimalFormat df = new DecimalFormat("0.00");
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(IronMiningStatement.GET_CHALLAN_GRADE_DEATILS);
			pstmt.setInt(1, id);
			pstmt.setInt(2, id);
			pstmt.setInt(3, id);
			pstmt.setInt(4, id);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				count++;
				jsonObject = new JSONObject();
				jsonObject.put("SLNOIndex", count);
				jsonObject.put("uniqueIdIndex", rs.getInt("ID"));
				jsonObject.put("inputDataIndex", rs.getString("GRADE"));
				jsonObject.put("valueDataIndex", rs.getDouble("RATE"));
				jsonArray.put(jsonObject);
				if (rs.getString("GRADE").equals("LME RATE")) {
					LmeRate = rs.getDouble("RATE");
				}
				if (rs.getString("GRADE").equals("DOLLAR RATE")) {
					dollarRate = rs.getDouble("RATE");
				}
				if (rs.getString("GRADE").equals("GRADE RATE")) {
					gradeRate = rs.getDouble("RATE");
				}
				if (rs.getString("GRADE").equals("RATE")) {
					rate = rs.getDouble("RATE");
				}
				if (rs.getString("GRADE").equals("QUANTITY")) {
					qty = rs.getDouble("RATE");
				}
				if (rs.getString("GRADE").equals("CELL AMOUNT RATE")) {
					cellAmt = rs.getDouble("RATE");
				}
				if (rs.getString("GRADE").equals("PROCESSING FEE RATE")) {
					processFeeRate = rs.getDouble("RATE");
				}
				if (rs.getString("GRADE").equals("TDS PERCENTAGE")) {
					tdsPerc = (rs.getDouble("RATE")) / 100;
				}
			}
			royality = (LmeRate * dollarRate * gradeRate) * (rate / 100);
			totalRoyality = ((LmeRate * dollarRate * gradeRate) * (rate / 100)) * qty;
			totalChallanAmt = (totalRoyality) + (totalRoyality * 0.3) + (qty * processFeeRate) + (qty * cellAmt)
					+ (totalRoyality * tdsPerc) + (totalRoyality * 0.02);

			jsonObject = new JSONObject();
			jsonObject.put("SLNOIndex", "");
			jsonObject.put("inputDataIndex", "LME RATE * DOLLAR PRICE");
			jsonObject.put("valueDataIndex", df.format(LmeRate * dollarRate));
			jsonObject.put("statusBuDataIndex", "S1");
			jsonArray.put(jsonObject);

			jsonObject = new JSONObject();
			jsonObject.put("SLNOIndex", "");
			jsonObject.put("inputDataIndex", "(LME RATE * DOLLAR PRICE) * GRADE RATE");
			jsonObject.put("valueDataIndex", df.format(LmeRate * dollarRate * gradeRate));
			jsonObject.put("statusBuDataIndex", "S2");
			jsonArray.put(jsonObject);

			jsonObject = new JSONObject();
			jsonObject.put("SLNOIndex", "");
			jsonObject.put("inputDataIndex", "((LME RATE * DOLLAR PRICE) * GRADE RATE)* RATE/100");
			jsonObject.put("valueDataIndex", df.format(royality));
			jsonObject.put("statusBuDataIndex", "S3");
			jsonArray.put(jsonObject);

			jsonObject = new JSONObject();
			jsonObject.put("SLNOIndex", "");
			jsonObject.put("inputDataIndex", "ROYALTY/M.T.");
			jsonObject.put("valueDataIndex", df.format(royality));
			jsonObject.put("statusBuDataIndex", "S4");
			jsonArray.put(jsonObject);

			jsonObject = new JSONObject();
			jsonObject.put("SLNOIndex", "");
			jsonObject.put("inputDataIndex", "(QUANTITY * ROYALTY)/ M T");
			jsonObject.put("valueDataIndex", df.format(totalRoyality));
			jsonObject.put("statusBuDataIndex", "S5");
			jsonArray.put(jsonObject);

			jsonObject = new JSONObject();
			jsonObject.put("SLNOIndex", "");
			jsonObject.put("inputDataIndex", "TDS");
			jsonObject.put("valueDataIndex", df.format(totalRoyality * tdsPerc));
			jsonObject.put("statusBuDataIndex", "S6");
			jsonArray.put(jsonObject);

			jsonObject = new JSONObject();
			jsonObject.put("SLNOIndex", "");
			jsonObject.put("inputDataIndex", "Cell Amount");
			jsonObject.put("valueDataIndex", df.format(qty * cellAmt));
			jsonObject.put("statusBuDataIndex", "S7");
			jsonArray.put(jsonObject);

			jsonObject = new JSONObject();
			jsonObject.put("SLNOIndex", "");
			jsonObject.put("inputDataIndex", "Processing Fees");
			jsonObject.put("valueDataIndex", df.format(qty * processFeeRate));
			jsonObject.put("statusBuDataIndex", "S8");
			jsonArray.put(jsonObject);

			jsonObject = new JSONObject();
			jsonObject.put("SLNOIndex", "");
			jsonObject.put("inputDataIndex", "DMF (30%)");
			jsonObject.put("valueDataIndex", df.format(totalRoyality * 0.3));
			jsonObject.put("statusBuDataIndex", "S9");
			jsonArray.put(jsonObject);

			jsonObject = new JSONObject();
			jsonObject.put("SLNOIndex", "");
			jsonObject.put("inputDataIndex", "NMET (2%)");
			jsonObject.put("valueDataIndex", df.format((totalRoyality * 0.02)));
			jsonObject.put("statusBuDataIndex", "S10");
			jsonArray.put(jsonObject);

			jsonObject = new JSONObject();
			jsonObject.put("SLNOIndex", "");
			jsonObject.put("inputDataIndex", "TOTAL CHALLAN AMOUNT");
			jsonObject.put("valueDataIndex", df.format(totalChallanAmt));
			jsonObject.put("statusBuDataIndex", "S11");

			jsonArray.put(jsonObject);
			finlist.add(jsonArray);

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return finlist;
	}

	public JSONArray getBauxiteChallan(int customerId, int systemId, int tcid) {
		JSONArray JsonArray = null;
		JSONObject JsonObject = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			JsonArray = new JSONArray();
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(IronMiningStatement.GET_BAUXITE_CHALLAN);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, customerId);
			pstmt.setInt(3, tcid);
			pstmt.setInt(4, systemId);
			pstmt.setInt(5, customerId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				JsonObject = new JSONObject();
				JsonObject.put("BauxiteChallanNo", rs.getString("CHALLAN_NO"));
				JsonObject.put("BuChallanID", rs.getString("ID"));
				JsonArray.put(JsonObject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return JsonArray;
	}

	//**********************************Plant Master ************************************//
	public String insertPlantMasterInformation(int systamId, int customerId, String orgId, String plantName,
			String tcNo, int userid, int hubLocId, String mineralType) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String message = "";
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(IronMiningStatement.INSERT_INTO_PLANT_MASTER);
			pstmt.setString(1, plantName);
			pstmt.setInt(2, hubLocId);
			pstmt.setString(3, orgId);
			pstmt.setString(4, tcNo);
			pstmt.setInt(5, systamId);
			pstmt.setInt(6, customerId);
			pstmt.setInt(7, userid);
			pstmt.setString(8, mineralType);
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

	public JSONArray getTCNoForPlantMaster(int systemId, int customerId, int orgId) {

		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			con = DBConnection.getConnectionToDB("AMS");
			jsonArray = new JSONArray();
			jsonObject = new JSONObject();
			pstmt = con.prepareStatement(IronMiningStatement.GET_TC_FOR_PLANT_MASTER);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, customerId);
			pstmt.setInt(3, orgId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				jsonObject = new JSONObject();
				jsonObject.put("TcId", rs.getString("TC_ID"));
				jsonObject.put("TCNumber", rs.getString("TC_NO"));
				jsonArray.put(jsonObject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jsonArray;

	}

	public String updatePlantMasterInformation(int systemId, int customerId, String orgNameModify, String plantName,
			String tcNo, int userid, int Id, int hubLocId) {
		String message = "";
		Connection conAdmin = null;
		PreparedStatement pstmt = null;
		try {
			conAdmin = DBConnection.getConnectionToDB("AMS");
			int updated = 0;
			pstmt = conAdmin.prepareStatement(IronMiningStatement.UPDATE_PLANT_MASTER_DETAILS);
			pstmt.setString(1, plantName);
			pstmt.setInt(2, hubLocId);
			pstmt.setString(3, orgNameModify);
			pstmt.setString(4, tcNo);
			pstmt.setInt(5, userid);
			pstmt.setInt(6, systemId);
			pstmt.setInt(7, customerId);
			pstmt.setInt(8, Id);

			updated = pstmt.executeUpdate();
			if (updated > 0) {
				message = "Updated Successfully";
			} else {
				message = "Updation Failed";
			}

		} catch (Exception e) {
			System.out.println("error in Updating PlantMaster Details " + e.toString());
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(conAdmin, pstmt, null);
		}
		return message;
	}

	@SuppressWarnings("unchecked")
	public ArrayList<Object> getPlantMasterDetails(int systemId, int customerId, int userId) {
		JSONArray JsonArray = new JSONArray();
		JSONObject JsonObject = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int slcount = 0;
		ReportHelper finalreporthelper = new ReportHelper();
		ArrayList<Object> finlist = new ArrayList<Object>();
		ArrayList<ReportHelper> reportsList = new ArrayList<ReportHelper>();
		ArrayList<String> headersList = new ArrayList<String>();
		headersList.add("Sl No");
		headersList.add("ID");
		headersList.add("Plant Name");
		headersList.add("Hub Name");
		headersList.add("Organization Name");
		headersList.add("Organization Code");
		headersList.add("TC Number");
		headersList.add("Mineral Type");
		headersList.add("Total Fines");
		headersList.add("Used Fines");
		headersList.add("Total Lumps");
		headersList.add("Used Lumps");
		headersList.add("Total Rejects");
		headersList.add("Used Rejects");
		headersList.add("Total UFO");
		headersList.add("Used UFO");
		headersList.add("Total Tailings");
		headersList.add("Used Tailings");
		headersList.add("Total Concentrates");
		headersList.add("Used Concentrates");
		headersList.add("Org Id");
		headersList.add("Tc id");
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(IronMiningStatement.GET_PLANT_MASTER_DETAILS);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, customerId);
			pstmt.setInt(3, userId);
			pstmt.setInt(4, systemId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				ArrayList<Object> informationList = new ArrayList<Object>();
				ReportHelper reporthelper = new ReportHelper();
				JsonObject = new JSONObject();
				slcount++;
				JsonObject.put("slnoIndex", slcount);
				informationList.add(slcount);

				JsonObject.put("UniqueIDIndex", rs.getString("ID"));
				informationList.add(rs.getString("ID"));

				JsonObject.put("PlantNameIndex", rs.getString("PLANT_NAME"));
				informationList.add(rs.getString("PLANT_NAME"));

				JsonObject.put("HubIdIndex", rs.getString("HUB_ID"));

				JsonObject.put("HubNameIndex", rs.getString("HUB_NAME"));
				informationList.add(rs.getString("HUB_NAME"));

				JsonObject.put("OrganizationNameIndex", rs.getString("ORGANIZATION_NAME"));
				informationList.add(rs.getString("ORGANIZATION_NAME"));

				JsonObject.put("OrganizationCodeIndex", rs.getString("ORGANIZATION_CODE"));
				informationList.add(rs.getString("ORGANIZATION_CODE"));

				JsonObject.put("TcNoIndex", rs.getString("TC_NO"));
				informationList.add(rs.getString("TC_NO"));

				JsonObject.put("mineralIndex", rs.getString("MINERAL_TYPE"));
				informationList.add(rs.getString("MINERAL_TYPE"));

				JsonObject.put("TotalFinesIndex", rs.getString("TOTAL_FINES"));
				informationList.add(rs.getString("TOTAL_FINES"));

				JsonObject.put("UsedFinesIndex", rs.getString("USED_FINES"));
				informationList.add(rs.getString("USED_FINES"));

				JsonObject.put("TotalLumpsIndex", rs.getString("TOTAL_LUMPS"));
				informationList.add(rs.getString("TOTAL_LUMPS"));

				JsonObject.put("UsedLumpsIndex", rs.getString("USED_LUMPS"));
				informationList.add(rs.getString("USED_LUMPS"));

				JsonObject.put("TotalRejectsIndex", rs.getString("TOTAL_REJECTS"));
				informationList.add(rs.getString("TOTAL_REJECTS"));

				JsonObject.put("UsedRejectsIndex", rs.getString("USED_REJECTS"));
				informationList.add(rs.getString("USED_REJECTS"));

				JsonObject.put("TotalUFOIndex", rs.getString("TOTAL_UFO"));
				informationList.add(rs.getString("TOTAL_UFO"));

				JsonObject.put("UsedUFOIndex", rs.getString("USED_UFO"));
				informationList.add(rs.getString("USED_UFO"));

				JsonObject.put("TotalTailingIndex", rs.getString("TOTAL_TAILINGS"));
				informationList.add(rs.getString("TOTAL_TAILINGS"));

				JsonObject.put("UsedTailingIndex", rs.getString("USED_TAILINGS"));
				informationList.add(rs.getString("USED_TAILINGS"));

				JsonObject.put("TotalConcentratesIndex", rs.getString("TOTAL_CONCENTRATES"));
				informationList.add(rs.getString("TOTAL_CONCENTRATES"));

				JsonObject.put("UsedConcentratesIndex", rs.getString("USED_CONCENTRATES"));
				informationList.add(rs.getString("USED_CONCENTRATES"));

				JsonObject.put("OrgIdIndex", rs.getString("ORGANIZATION_ID"));
				informationList.add(rs.getString("ORGANIZATION_ID"));

				JsonObject.put("TcIdIndex", rs.getString("TC_ID"));
				informationList.add(rs.getString("TC_ID"));

				JsonArray.put(JsonObject);
				reporthelper.setInformationList(informationList);
				reportsList.add(reporthelper);
			}
			finlist.add(JsonArray);
			finalreporthelper.setReportsList(reportsList);
			finalreporthelper.setHeadersList(headersList);
			finlist.add(finalreporthelper);

		} catch (Exception e) {
			e.printStackTrace();
		} finally {

			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return finlist;
	}

	public synchronized String cancelTrip(String clientId, int systemId, int userId, String tripid, String permitNo,
			int tcId, int routeId, String assetNo, boolean isLTSP, boolean isLogedIn) {
		Connection con = null;
		PreparedStatement pstmt = null;
		PreparedStatement pstmt1 = null;
		PreparedStatement pstmtop = null;
		ResultSet rs = null;
		int destination = 0;
		int permitId = 0;
		int orgId = 0;
		float qty = 0;
		String gradeType = "";
		boolean isClosable = false;
		String message = "";
		int updated1;
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmtop = con.prepareStatement(IronMiningStatement.GET_TRIP_DETAILS_FOR_CANCEL_TRIP_FOR_TRUCK);
			pstmtop.setInt(1, systemId);
			pstmtop.setInt(2, Integer.parseInt(clientId));
			pstmtop.setInt(3, Integer.parseInt(tripid));
			rs = pstmtop.executeQuery();
			if (rs.next()) {
				qty = rs.getFloat("TOTAL_QTY");
				permitId = rs.getInt("PERMIT_ID");
				orgId = rs.getInt("ORG_ID");
				gradeType = rs.getString("START_LOCATION");
				isClosable = rs.getString("CLIENT_CLOSABLE").equals("T") ? true : false;
			}

			if (!isLTSP && isLogedIn && !isClosable) {
				message = "User cann't cancel the Trip Sheet after 5 minutes from Issued Date Time";
			} else {
				pstmt = con.prepareStatement(IronMiningStatement.UPDATE_CLOSE_TRIP_DETAILS);
				pstmt.setInt(1, userId);
				pstmt.setInt(2, Integer.parseInt(tripid));
				updated1 = pstmt.executeUpdate();
				if (updated1 > 0) {
					message = "Cancelled Successfully";

					pstmt = con.prepareStatement(IronMiningStatement.UPDATE_TRIP_STATUS_IN_ASSET_ENROLMENT);
					pstmt.setString(1, "CLOSE");
					pstmt.setString(2, assetNo);
					pstmt.setInt(3, systemId);
					pstmt.setInt(4, Integer.parseInt(clientId));
					pstmt.executeUpdate();

					pstmt1 = con.prepareStatement(IronMiningStatement.UPDATE_TRIPSHEET_QTY);
					pstmt1.setFloat(1, qty);
					pstmt1.setInt(2, permitId);
					pstmt1.setInt(3, systemId);
					pstmt1.setInt(4, Integer.parseInt(clientId));
					int up = pstmt1.executeUpdate();
					message = " Tripsheet Cancelled Successfully ";
				} else {
					message = " Tripsheet cannot be Cancelled. ";
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(null, pstmt, null);
			DBConnection.releaseConnectionToDB(null, pstmtop, rs);
			DBConnection.releaseConnectionToDB(con, pstmt1, null);
		}
		return message;
	}

	public JSONArray getHubLocation(int customerId, int systemId) {
		JSONArray JsonArray = null;
		JSONObject JsonObject = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			JsonArray = new JSONArray();
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(IronMiningStatement.GET_LOCATION_FOR_WEIGHBRIDGE);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, customerId);
			rs = pstmt.executeQuery();
			JsonObject = new JSONObject();
			JsonObject.put("HubID", "0");
			JsonObject.put("Hubname", "-- ALL --");
			JsonArray.put(JsonObject);
			while (rs.next()) {
				JsonObject = new JSONObject();
				JsonObject.put("Hubname", rs.getString("NAME"));
				JsonObject.put("HubID", rs.getInt("HUBID"));
				JsonArray.put(JsonObject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return JsonArray;
	}

	public String addWeighbrideMasterdetails(int orgId, int hubLocation, String weighbridge, String companyName,
			String weighbridgeModel, String supplierName, int systemId, int customerId, int userId) {

		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String message = "";
		int count;

		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(IronMiningStatement.CHECK_WEIGHBRIDGE_EXIST);
			pstmt.setString(1, weighbridge);
			pstmt.setInt(2, systemId);
			pstmt.setInt(3, customerId);
			rs = pstmt.executeQuery();
			if (!rs.next()) {
				pstmt = con.prepareStatement(IronMiningStatement.SAVE_WEIGHBRIDGE_MASTER_DETAILS);
				pstmt.setInt(1, orgId);
				pstmt.setInt(2, hubLocation);
				pstmt.setString(3, weighbridge);
				pstmt.setString(4, companyName);
				pstmt.setString(5, weighbridgeModel);
				pstmt.setString(6, supplierName);
				pstmt.setInt(7, systemId);
				pstmt.setInt(8, customerId);
				pstmt.setInt(9, userId);
				count = pstmt.executeUpdate();
				if (count > 0) {
					message = "Saved Successfully.";
				} else
					message = "Error While Saving";
			} else {
				message = weighbridge + " already existed.";
			}

		} catch (Exception e) {
			System.out.println("error in:-Saving Weighbridge Master Details " + e.toString());
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return message;

	}

	public String modifyWeighbrideMasterdetails(int orgId, int hubLocation, String companyName, String weighbridgeModel,
			String supplierName, int systemId, int customerId, int userId, int uniqueId) {

		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String message = "";
		int count;

		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(IronMiningStatement.MODIFY_WEIGHBRIDGE_MASTER_DETAILS);
			pstmt.setInt(1, orgId);
			pstmt.setInt(2, hubLocation);
			pstmt.setString(3, companyName);
			pstmt.setString(4, weighbridgeModel);
			pstmt.setString(5, supplierName);
			pstmt.setInt(6, systemId);
			pstmt.setInt(7, customerId);
			pstmt.setInt(8, userId);
			pstmt.setInt(9, uniqueId);
			count = pstmt.executeUpdate();
			if (count > 0) {
				message = "Updated Successfully.";
			} else
				message = "Error While Updating";
		} catch (Exception e) {
			System.out.println("error in:-Updating Weighbridge Master Details " + e.toString());
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return message;

	}

	public ArrayList<Object> getWeighbridgeMasterDetails(int systemId, int customerId, int userId) {
		JSONArray JsonArray = new JSONArray();
		JSONObject JsonObject = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int slcount = 0;
		ArrayList<Object> finalList = new ArrayList<Object>();
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(IronMiningStatement.GET_WEIGHBRIDGE_MASTER_DETAILS);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, customerId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				JsonObject = new JSONObject();
				slcount++;
				JsonObject.put("slnoIndex", slcount);

				JsonObject.put("uniqueIdDataIndex", rs.getString("ID"));

				JsonObject.put("organizationNameIndex", rs.getString("ORGANIZATION_NAME").toUpperCase());

				JsonObject.put("orgIdIndex", rs.getString("ORGANIZATION_ID"));

				JsonObject.put("weighbridgeLocationIndex", rs.getString("LOCATION").toUpperCase());

				JsonObject.put("LocationIdIndex", rs.getString("LOCATION_ID"));

				JsonObject.put("weighbridgeIdIndex", rs.getString("WEIGHBRIDGE"));

				JsonObject.put("companyNameIndex", rs.getString("COMPANY_NAME"));

				JsonObject.put("weighbridgeModelIndex", rs.getString("WEIGHBRIDGE_MODEL"));

				JsonObject.put("supplierNameIndex", rs.getString("SUPPLIER_NAME"));

				JsonArray.put(JsonObject);
			}
			finalList.add(JsonArray);

		} catch (Exception e) {
			e.printStackTrace();
		} finally {

			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return finalList;
	}

	public JSONArray getWeighbridgesAssociatedToUser(int systemId, int userId) {
		JSONArray jsonArray = null;
		JSONObject jsonObject = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			jsonArray = new JSONArray();
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(IronMiningStatement.GET_WEIGHBRIDGES_ASSOCIATED_TO_USER);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, userId);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				jsonObject = new JSONObject();
				jsonObject.put("SourceHubId", rs.getInt("SOURCE_HUBID"));
				jsonObject.put("DestiHubId", rs.getInt("DESTINATION_HUBID"));
				jsonObject.put("BargeHubId", rs.getInt("BARGE_HUBID"));
				jsonObject.put("Type", rs.getString("TYPE"));
				jsonObject.put("ClosingType", rs.getString("CLOSING_TYPE"));
				jsonObject.put("operationType", rs.getString("OPERATION_TYPE"));
				jsonArray.put(jsonObject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jsonArray;

	}

	public JSONArray getWBForUserSetting(int customerId, int systemId, int userId) {
		JSONArray JsonArray = null;
		JSONObject JsonObject = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			JsonArray = new JSONArray();
			HashSet<Integer> orgSet = new HashSet<Integer>();
			String orgId = "";
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(IronMiningStatement.GET_ASSOCIATION_DATA_FOR_LTSP_USERS);
			pstmt.setInt(1, userId);
			pstmt.setInt(2, systemId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				orgSet.add(rs.getInt("ORG_ID"));
			}
			orgSet.add(0);
			orgId = orgSet.toString();
			orgId = orgId.substring(1, orgId.length() - 1);

			pstmt = con.prepareStatement(IronMiningStatement.GET_HUB_FOR_USER_SETTING_BY_ORG.replace("#", orgId));
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, customerId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				JsonObject = new JSONObject();
				JsonObject.put("Hubname", rs.getString("WEIGHBRIDGE_ID"));
				JsonObject.put("HubID", rs.getInt("ID"));
				JsonArray.put(JsonObject);
			}

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return JsonArray;
	}

	public JSONArray getBargeForUserSetting(int customerId, int systemId) {
		JSONArray JsonArray = null;
		JSONObject JsonObject = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			JsonArray = new JSONArray();
			HashSet<Integer> orgSet = new HashSet<Integer>();
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(IronMiningStatement.GET_BARGE_HUB_FOR_USER_SETTINGS);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, customerId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				JsonObject = new JSONObject();
				JsonObject.put("Hubname", rs.getString("NAME"));
				JsonObject.put("HubID", rs.getInt("ID"));
				JsonArray.put(JsonObject);
			}

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return JsonArray;
	}

	public JSONArray getNonAssociatedPermits(int customerId, int systemId, int userid, int loginUserId) {
		JSONArray JsonArray = new JSONArray();
		JSONObject JsonObject = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		DecimalFormat df = new DecimalFormat("##0.00");
		String tcId = "";
		String orgId = "";
		try {
			int count = 0;
			String permitids = "0";
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(IronMiningStatement.GET_PERMIT_NO_FROM_USER_SETTING);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, userid);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				permitids = rs.getString("PERMIT_IDS");
			}
			if (permitids == null || (permitids != null && !(permitids.trim().length() > 0))) {
				permitids = "0";
			}

			boolean flag = false;
			pstmt = con.prepareStatement(IronMiningStatement.GET_ASSOCIATION_DATA_FOR_LTSP_USERS_BASED_ON_LOGIN);
			pstmt.setInt(1, loginUserId);
			pstmt.setInt(2, systemId);
			pstmt.setInt(3, userid);
			pstmt.setInt(4, systemId);
			pstmt.setInt(5, userid);
			pstmt.setInt(6, systemId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				if (!rs.getString("TC_ID").equals("0")) {
					tcId = rs.getString("TC_ID") + "," + tcId;
				} else {
					orgId = rs.getString("ORG_ID") + "," + orgId;
				}
				flag = true;
			}
			if (flag) {
				if (tcId.length() > 1) {
					tcId = tcId.substring(0, tcId.length() - 1);
				}
				if (orgId.length() > 1) {
					orgId = orgId.substring(0, orgId.length() - 1);
				}
				String stmt = "";
				if (tcId.equals("") && !orgId.equals("")) {
					stmt = IronMiningStatement.GET_PERMIT_NO_FOR_USER_SETTINGS
							.replace("#", "a.ORGANIZATION_CODE in (" + orgId + ")")
							.replace("&", "and a.ID not in (" + permitids + ")");
				} else if (!tcId.equals("") && orgId.equals("")) {
					stmt = IronMiningStatement.GET_PERMIT_NO_FOR_USER_SETTINGS.replace("#", "a.TC_ID in (" + tcId + ")")
							.replace("&", "and a.ID not in (" + permitids + ")");
				} else {
					stmt = IronMiningStatement.GET_PERMIT_NO_FOR_USER_SETTINGS
							.replace("#", "a.TC_ID in (" + tcId + ") or a.ORGANIZATION_CODE in (" + orgId + ")")
							.replace("&", "and a.ID not in (" + permitids + ")");
				}
				pstmt = con.prepareStatement(stmt);
				pstmt.setInt(1, systemId);
				pstmt.setInt(2, customerId);
				rs = pstmt.executeQuery();
				if (rs != null) {
					while (rs.next()) {
						JsonObject = new JSONObject();
						count++;
						float permitQty;
						JsonObject.put("slnoIndex", count);
						JsonObject.put("permitIdIndex", rs.getString("ID"));
						JsonObject.put("permitNoIndex", rs.getString("PERMIT_NO"));

						if (Double.parseDouble(rs.getString("CHALLAN_QTY")) > 0) {
							JsonObject.put("permitQty", df.format(rs.getFloat("CHALLAN_QTY")));
							permitQty = rs.getFloat("CHALLAN_QTY");
						} else {
							JsonObject.put("permitQty", df.format(rs.getFloat("PERMIT_QTY")));
							permitQty = rs.getFloat("PERMIT_QTY");
						}
						JsonObject.put("permitBalance", df.format(permitQty - rs.getFloat("USED_QTY")));
						JsonArray.put(JsonObject);

						JsonObject.put("tcIdIndex", rs.getString("TC_ID"));
						JsonObject.put("tcNoIndex", rs.getString("TC_NO"));
						JsonObject.put("orgIdIndex", rs.getString("ORG_ID"));
						JsonObject.put("orgNameIndex", rs.getString("ORG_NAME"));
						JsonObject.put("routeNameIndex", rs.getString("ROUTE_NAME"));
						JsonObject.put("startLocationIndex", rs.getString("START_LOCATION"));
						JsonObject.put("endLocationIndex", rs.getString("END_LOCATION"));
					}
				}
			} //flag
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return JsonArray;
	}

	public JSONArray getAssociatedPermits(int customerId, int systemId, int userid, int loginUserId) {
		JSONArray JsonArray = new JSONArray();
		JSONObject JsonObject = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		DecimalFormat df = new DecimalFormat("##0.00");
		String tcId = "";
		String orgId = "";
		try {
			int count = 0;
			String permitids = "0";
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(IronMiningStatement.GET_PERMIT_NO_FROM_USER_SETTING);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, userid);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				permitids = rs.getString("PERMIT_IDS");
			}
			if (permitids == null || (permitids != null && !(permitids.trim().length() > 0))) {
				permitids = "0";
			}

			boolean flag = false;
			pstmt = con.prepareStatement(IronMiningStatement.GET_ASSOCIATION_DATA_FOR_LTSP_USERS_BASED_ON_LOGIN);
			pstmt.setInt(1, loginUserId);
			pstmt.setInt(2, systemId);
			pstmt.setInt(3, userid);
			pstmt.setInt(4, systemId);
			pstmt.setInt(5, userid);
			pstmt.setInt(6, systemId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				if (!rs.getString("TC_ID").equals("0")) {
					tcId = rs.getString("TC_ID") + "," + tcId;
				} else {
					orgId = rs.getString("ORG_ID") + "," + orgId;
				}
				flag = true;
			}
			if (flag) {
				if (tcId.length() > 1) {
					tcId = tcId.substring(0, tcId.length() - 1);
				}
				if (orgId.length() > 1) {
					orgId = orgId.substring(0, orgId.length() - 1);
				}
				String stmt = "";
				if (tcId.equals("") && !orgId.equals("")) {
					stmt = IronMiningStatement.GET_PERMIT_NO_FOR_USER_SETTINGS
							.replace("#", "a.ORGANIZATION_CODE in (" + orgId + ")")
							.replace("&", "and a.ID in (" + permitids + ")");
				} else if (!tcId.equals("") && orgId.equals("")) {
					stmt = IronMiningStatement.GET_PERMIT_NO_FOR_USER_SETTINGS.replace("#", "a.TC_ID in (" + tcId + ")")
							.replace("&", "and a.ID in (" + permitids + ")");
				} else {
					stmt = IronMiningStatement.GET_PERMIT_NO_FOR_USER_SETTINGS
							.replace("#", "a.TC_ID in (" + tcId + ") or a.ORGANIZATION_CODE in (" + orgId + ")")
							.replace("&", "and a.ID in (" + permitids + ")");
				}
				pstmt = con.prepareStatement(stmt);
				pstmt.setInt(1, systemId);
				pstmt.setInt(2, customerId);
				rs = pstmt.executeQuery();
				if (rs != null) {
					while (rs.next()) {
						JsonObject = new JSONObject();
						count++;
						float permitQty;
						JsonObject.put("slnoIndex2", count);
						JsonObject.put("permitIdIndex2", rs.getString("ID"));
						JsonObject.put("permitNoIndex2", rs.getString("PERMIT_NO"));
						if (Double.parseDouble(rs.getString("CHALLAN_QTY")) > 0) {
							JsonObject.put("permitQty2", df.format(rs.getFloat("CHALLAN_QTY")));
							permitQty = rs.getFloat("CHALLAN_QTY");
						} else {
							JsonObject.put("permitQty2", df.format(rs.getFloat("PERMIT_QTY")));
							permitQty = rs.getFloat("PERMIT_QTY");
						}
						JsonObject.put("permitBalance2", df.format(permitQty - rs.getFloat("USED_QTY")));
						JsonArray.put(JsonObject);

						JsonObject.put("tcIdIndex2", rs.getString("TC_ID"));
						JsonObject.put("tcNoIndex2", rs.getString("TC_NO"));
						JsonObject.put("orgIdIndex2", rs.getString("ORG_ID"));
						JsonObject.put("orgNameIndex2", rs.getString("ORG_NAME"));
						JsonObject.put("routeNameIndex2", rs.getString("ROUTE_NAME"));
						JsonObject.put("startLocationIndex2", rs.getString("START_LOCATION"));
						JsonObject.put("endLocationIndex2", rs.getString("END_LOCATION"));
					}
				}
			} //flag
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return JsonArray;
	}

	public String associatePermitToUser(int customerId, int systemId, int userIdFromJsp, JSONArray js, int userId,
			int sourceHubId, int destnationHubId, int bargeHubId, String type, String closedType, String operationType,
			int loginUserId) {
		Connection con = null;
		PreparedStatement pstmt = null;
		PreparedStatement pstmt1 = null;
		ResultSet rs = null;
		ResultSet rs1 = null;
		String message = "";
		JSONObject jsonObject = null;

		String permitNoFromDB = "";
		String permitNoFromDB1 = "";
		String permitNo = "";
		String tcId = "";
		String orgId = "";
		String stmt = "";
		Set<Integer> set = new HashSet<Integer>();
		try {
			for (int i = 0; i < js.length(); i++) {
				jsonObject = (JSONObject) js.get(i);
				set.add(Integer.parseInt(jsonObject.getString("permitIdIndex")));
			}
			con = DBConnection.getConnectionToDB("AMS");

			pstmt = con.prepareStatement(IronMiningStatement.GET_PERMIT_NO_FROM_USER_SETTING);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, userIdFromJsp);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				permitNoFromDB = rs.getString("PERMIT_IDS");
			}
			pstmt = con.prepareStatement(IronMiningStatement.GET_ASSOCIATION_DATA_FOR_LTSP_USERS_BASED_ON_LOGIN);
			pstmt.setInt(1, loginUserId);
			pstmt.setInt(2, systemId);
			pstmt.setInt(3, userIdFromJsp);
			pstmt.setInt(4, systemId);
			pstmt.setInt(5, userIdFromJsp);
			pstmt.setInt(6, systemId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				if (!rs.getString("TC_ID").equals("0")) {
					tcId = rs.getString("TC_ID") + "," + tcId;
				} else {
					orgId = rs.getString("ORG_ID") + "," + orgId;
				}
			}
			if (tcId.length() > 1) {
				tcId = tcId.substring(0, tcId.length() - 1);
			}
			if (orgId.length() > 1) {
				orgId = orgId.substring(0, orgId.length() - 1);
			}
			tcId = tcId.equals("") ? "0" : tcId;
			orgId = orgId.equals("") ? "0" : orgId;

			if (permitNoFromDB != null && !permitNoFromDB.equals("")) {
				if (tcId.equals("") && !orgId.equals("")) {
					stmt = IronMiningStatement.GET_PERMIT_NO_FOR_USER_SETTINGS
							.replace("#", "a.ORGANIZATION_CODE in (" + orgId + ")")
							.replace("&", "and a.ID in (" + permitNoFromDB + ")");
				} else if (!tcId.equals("") && orgId.equals("")) {
					stmt = IronMiningStatement.GET_PERMIT_NO_FOR_USER_SETTINGS.replace("#", "a.TC_ID in (" + tcId + ")")
							.replace("&", "and a.ID in (" + permitNoFromDB + ")");
				} else {
					stmt = IronMiningStatement.GET_PERMIT_NO_FOR_USER_SETTINGS
							.replace("#", "a.TC_ID in (" + tcId + ") or a.ORGANIZATION_CODE in (" + orgId + ")")
							.replace("&", "and a.ID in (" + permitNoFromDB + ")");
				}
				pstmt = con.prepareStatement(stmt);
				pstmt.setInt(1, systemId);
				pstmt.setInt(2, customerId);
				rs = pstmt.executeQuery();
				while (rs.next()) {
					permitNoFromDB1 = rs.getString("ID") + "," + permitNoFromDB1;
				}
			}

			if (permitNoFromDB1.trim().length() > 0) {
				String[] arr = permitNoFromDB1.split(",");
				for (String str : arr) {
					set.add(Integer.parseInt(str));
				}
			}
			for (Integer str : set) {
				permitNo += str + ",";
			}
			if (permitNo.length() > 1) {
				permitNo = permitNo.substring(0, permitNo.length() - 1);
			}
			pstmt1 = con.prepareStatement(IronMiningStatement.INSERT_TRIP_SHEET_USER_SETTINGS_HISTORY);
			pstmt1.setInt(1, userId);
			pstmt1.setInt(2, systemId);
			pstmt1.setInt(3, userIdFromJsp);
			int inserted = pstmt1.executeUpdate();
			if (inserted > 0) {
				inserted = 0;
				pstmt1 = con.prepareStatement(IronMiningStatement.DELETE_TRIP_SHEET_USER_SETTINGS_BASEDON_USER);
				pstmt1.setInt(1, systemId);
				pstmt1.setInt(2, userIdFromJsp);
				inserted = pstmt1.executeUpdate();
			}
			inserted = 0;
			pstmt1 = con.prepareStatement(IronMiningStatement.INSERT_TRIP_SHEET_USER_SETTINGS);
			pstmt1.setInt(1, userIdFromJsp);
			pstmt1.setInt(2, 0);
			pstmt1.setInt(3, 0);
			pstmt1.setString(4, permitNo);
			pstmt1.setInt(5, sourceHubId);
			pstmt1.setInt(6, destnationHubId);
			pstmt1.setString(7, type);
			pstmt1.setInt(8, systemId);
			pstmt1.setInt(9, customerId);
			pstmt1.setInt(10, userId);
			pstmt1.setInt(11, bargeHubId);
			pstmt1.setString(12, closedType);
			pstmt1.setString(13, operationType);
			inserted = pstmt1.executeUpdate();
			if (inserted > 0) {
				message = "Associated Successfully";
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
			DBConnection.releaseConnectionToDB(null, pstmt1, rs1);
		}
		return message;
	}

	public String disassociatePermitFromUser(int customerId, int systemId, int userIdFromJsp, JSONArray js, int userId,
			int sourceHubId, int destnationHubId, int bargeHubId, String type, String closedType, String operationType,
			int loginUserId) {
		Connection con = null;
		PreparedStatement pstmt = null;
		PreparedStatement pstmt1 = null;
		ResultSet rs = null;
		ResultSet rs1 = null;
		String message = "";
		JSONObject jsonObject = null;

		String permitNo = "";
		String permitNoFromDB = "";
		String permitNoFromDB1 = "";
		Set<Integer> set1 = new HashSet<Integer>();
		Set<Integer> set2 = new HashSet<Integer>();
		String tcId = "";
		String orgId = "";
		String stmt = "";
		try {

			for (int i = 0; i < js.length(); i++) {
				jsonObject = (JSONObject) js.get(i);
				set1.add(Integer.parseInt(jsonObject.getString("permitIdIndex2")));

			}
			con = DBConnection.getConnectionToDB("AMS");

			pstmt = con.prepareStatement(IronMiningStatement.GET_PERMIT_NO_FROM_USER_SETTING);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, userIdFromJsp);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				permitNoFromDB = rs.getString("PERMIT_IDS");
			}
			pstmt = con.prepareStatement(IronMiningStatement.GET_ASSOCIATION_DATA_FOR_LTSP_USERS_BASED_ON_LOGIN);
			pstmt.setInt(1, loginUserId);
			pstmt.setInt(2, systemId);
			pstmt.setInt(3, userIdFromJsp);
			pstmt.setInt(4, systemId);
			pstmt.setInt(5, userIdFromJsp);
			pstmt.setInt(6, systemId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				if (!rs.getString("TC_ID").equals("0")) {
					tcId = rs.getString("TC_ID") + "," + tcId;
				} else {
					orgId = rs.getString("ORG_ID") + "," + orgId;
				}
			}
			if (tcId.length() > 1) {
				tcId = tcId.substring(0, tcId.length() - 1);
			}
			if (orgId.length() > 1) {
				orgId = orgId.substring(0, orgId.length() - 1);
			}
			tcId = tcId.equals("") ? "0" : tcId;
			orgId = orgId.equals("") ? "0" : orgId;

			if (permitNoFromDB != null && !permitNoFromDB.equals("")) {
				if (tcId.equals("") && !orgId.equals("")) {
					stmt = IronMiningStatement.GET_PERMIT_NO_FOR_USER_SETTINGS
							.replace("#", "a.ORGANIZATION_CODE in (" + orgId + ")")
							.replace("&", "and a.ID in (" + permitNoFromDB + ")");
				} else if (!tcId.equals("") && orgId.equals("")) {
					stmt = IronMiningStatement.GET_PERMIT_NO_FOR_USER_SETTINGS.replace("#", "a.TC_ID in (" + tcId + ")")
							.replace("&", "and a.ID in (" + permitNoFromDB + ")");
				} else {
					stmt = IronMiningStatement.GET_PERMIT_NO_FOR_USER_SETTINGS
							.replace("#", "a.TC_ID in (" + tcId + ") or a.ORGANIZATION_CODE in (" + orgId + ")")
							.replace("&", "and a.ID in (" + permitNoFromDB + ")");
				}
				pstmt = con.prepareStatement(stmt);
				pstmt.setInt(1, systemId);
				pstmt.setInt(2, customerId);
				rs = pstmt.executeQuery();
				while (rs.next()) {
					permitNoFromDB1 = rs.getString("ID") + "," + permitNoFromDB1;
				}
			}
			if (permitNoFromDB1.trim().length() > 0) {
				String[] arr = permitNoFromDB1.split(",");
				for (int i = 0; i < arr.length; i++) {
					set2.add(Integer.parseInt(arr[i]));
				}
			}
			set2.removeAll(set1);
			for (Integer str : set2) {
				permitNo += str + ",";
			}
			if (permitNo.length() > 1) {
				permitNo = permitNo.substring(0, permitNo.length() - 1);
			}
			//System.out.println("disassociatePermitFromUser ="+permitNo);
			pstmt1 = con.prepareStatement(IronMiningStatement.INSERT_TRIP_SHEET_USER_SETTINGS_HISTORY);
			pstmt1.setInt(1, userId);
			pstmt1.setInt(2, systemId);
			pstmt1.setInt(3, userIdFromJsp);
			int inserted = pstmt1.executeUpdate();
			if (inserted > 0) {
				inserted = 0;
				pstmt1 = con.prepareStatement(IronMiningStatement.DELETE_TRIP_SHEET_USER_SETTINGS_BASEDON_USER);
				pstmt1.setInt(1, systemId);
				pstmt1.setInt(2, userIdFromJsp);
				inserted = pstmt1.executeUpdate();
			}
			inserted = 0;
			pstmt1 = con.prepareStatement(IronMiningStatement.INSERT_TRIP_SHEET_USER_SETTINGS);
			pstmt1.setInt(1, userIdFromJsp);
			pstmt1.setInt(2, 0);
			pstmt1.setInt(3, 0);
			pstmt1.setString(4, permitNo);
			pstmt1.setInt(5, sourceHubId);
			pstmt1.setInt(6, destnationHubId);
			pstmt1.setString(7, type);
			pstmt1.setInt(8, systemId);
			pstmt1.setInt(9, customerId);
			pstmt1.setInt(10, userId);
			pstmt1.setInt(11, bargeHubId);
			pstmt1.setString(12, closedType);
			pstmt1.setString(13, operationType);
			inserted = pstmt1.executeUpdate();
			if (inserted > 0) {
				message = "Disassociated Successfully";
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
			DBConnection.releaseConnectionToDB(null, pstmt1, rs1);
		}
		return message;
	}

	public JSONArray getServerTime(int CustID, int systemId) {
		JSONArray JsonArray = new JSONArray();
		JSONObject JsonObject = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String hour = "";
		String time = "";
		try {
			JsonArray = new JSONArray();
			JsonObject = new JSONObject();
			con = DBConnection.getConnectionToDB("AMS");

			pstmt = con.prepareStatement(IronMiningStatement.GET_TIME_DETAILS);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, CustID);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				hour = rs.getString("HOUR");
				time = rs.getString("TIME");
				String str3 = "";
				if (time.length() == 1) {
					str3 = hour + ":" + "0" + time;
				} else {
					str3 = hour + ":" + time;
				}
				JsonObject.put("time", str3);
				JsonObject.put("day", rs.getString("DAY"));
				JsonObject.put("id", rs.getInt("ID"));
				JsonObject.put("startTime", rs.getString("START_TIME"));
				JsonObject.put("endTime", rs.getString("END_TIME"));
				JsonObject.put("breakSTime", rs.getString("BREAK_START_TIME"));
				JsonObject.put("breakETime", rs.getString("BREAK_END_TIME"));
				JsonObject.put("nonCommHrs", rs.getInt("NON_COMM_HRS"));
				JsonArray.put(JsonObject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return JsonArray;
	}

	public JSONArray getDashBoardElementCount(int systemId, int CustomerId, int userId) {

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Connection connection = null;
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject = new JSONObject();
		DecimalFormat df = new DecimalFormat("##0.00");
		try {
			connection = DBConnection.getConnectionToDB("AMS");
			//permit count
			try {
				pstmt = connection.prepareStatement(IronMiningStatement.GET_DASHBOARD_PERMIT_COUNT);
				pstmt.setInt(1, systemId);
				pstmt.setInt(2, CustomerId);
				pstmt.setInt(3, userId);
				pstmt.setInt(4, systemId);
				pstmt.setInt(5, userId);
				pstmt.setInt(6, systemId);
				pstmt.setInt(7, systemId);
				pstmt.setInt(8, CustomerId);
				pstmt.setInt(9, userId);
				pstmt.setInt(10, systemId);
				pstmt.setInt(11, userId);
				pstmt.setInt(12, systemId);
				pstmt.setInt(13, systemId);
				pstmt.setInt(14, CustomerId);
				pstmt.setInt(15, userId);
				pstmt.setInt(16, systemId);
				pstmt.setInt(17, userId);
				pstmt.setInt(18, systemId);
				pstmt.setInt(19, systemId);
				pstmt.setInt(20, CustomerId);
				pstmt.setInt(21, userId);
				pstmt.setInt(22, systemId);
				pstmt.setInt(23, userId);
				pstmt.setInt(24, systemId);

				rs = pstmt.executeQuery();
				while (rs.next()) {
					switch (rs.getInt("type")) {
					case 1:
						jsonObject.put("totalPermitCount", rs.getInt("COUNT"));
						break;
					case 2:
						jsonObject.put("approvedPermitCount", rs.getInt("COUNT"));
						break;
					case 3:
						jsonObject.put("pendingPermitCount", rs.getInt("COUNT"));
						break;
					case 4:
						jsonObject.put("closedPermitCount", rs.getInt("COUNT"));
						break;
					}
				}
			} catch (Exception e) {
				e.printStackTrace();
			} finally {
				DBConnection.releaseConnectionToDB(null, pstmt, rs);
			}

			//Challan Count
			try {
				pstmt = connection.prepareStatement(IronMiningStatement.GET_DASHBOARD_CHALLAN_COUNT);
				pstmt.setInt(1, systemId);
				pstmt.setInt(2, CustomerId);
				pstmt.setInt(3, userId);
				pstmt.setInt(4, systemId);
				pstmt.setInt(5, userId);
				pstmt.setInt(6, systemId);
				pstmt.setInt(7, systemId);
				pstmt.setInt(8, CustomerId);
				pstmt.setInt(9, userId);
				pstmt.setInt(10, systemId);
				pstmt.setInt(11, userId);
				pstmt.setInt(12, systemId);
				pstmt.setInt(13, systemId);
				pstmt.setInt(14, CustomerId);
				pstmt.setInt(15, userId);
				pstmt.setInt(16, systemId);
				pstmt.setInt(17, userId);
				pstmt.setInt(18, systemId);
				rs = pstmt.executeQuery();
				while (rs.next()) {
					switch (rs.getInt("type")) {
					case 1:
						jsonObject.put("totalChallanCount", rs.getInt("COUNT"));
						break;
					case 2:
						jsonObject.put("approvedChallanCount", rs.getInt("COUNT"));
						break;
					case 3:
						jsonObject.put("pendingChallanCount", rs.getInt("COUNT"));
						break;
					}
				}
			} catch (Exception e) {
				e.printStackTrace();
			} finally {
				DBConnection.releaseConnectionToDB(null, pstmt, rs);
			}
			//Permit Quantity
			try {
				pstmt = connection.prepareStatement(IronMiningStatement.GET_PERMIT_QUANTITY);
				pstmt.setInt(1, systemId);
				pstmt.setInt(2, CustomerId);
				pstmt.setInt(3, userId);
				pstmt.setInt(4, systemId);
				pstmt.setInt(5, userId);
				pstmt.setInt(6, systemId);
				pstmt.setInt(7, systemId);
				pstmt.setInt(8, CustomerId);
				pstmt.setInt(9, userId);
				pstmt.setInt(10, systemId);
				pstmt.setInt(11, userId);
				pstmt.setInt(12, systemId);
				pstmt.setInt(13, systemId);
				pstmt.setInt(14, CustomerId);
				pstmt.setInt(15, userId);
				pstmt.setInt(16, systemId);
				pstmt.setInt(17, userId);
				pstmt.setInt(18, systemId);
				pstmt.setInt(19, systemId);
				pstmt.setInt(20, CustomerId);
				pstmt.setInt(21, userId);
				pstmt.setInt(22, systemId);
				pstmt.setInt(23, userId);
				pstmt.setInt(24, systemId);
				pstmt.setInt(25, systemId);
				pstmt.setInt(26, CustomerId);
				pstmt.setInt(27, userId);
				pstmt.setInt(28, systemId);
				pstmt.setInt(29, userId);
				pstmt.setInt(30, systemId);
				rs = pstmt.executeQuery();
				while (rs.next()) {
					switch (rs.getInt("type")) {
					case 1:
						jsonObject.put("potQuantity", df.format(rs.getFloat("QUANTITY")));
						break;
					case 2:
						jsonObject.put("posQuantity", df.format(rs.getFloat("QUANTITY")));
						break;
					case 3:
						jsonObject.put("deQuantity", df.format(rs.getFloat("QUANTITY")));
						break;
					case 4:
						jsonObject.put("ieQuantity", df.format(rs.getFloat("QUANTITY")));
						break;
					case 5:
						jsonObject.put("postQuantity", df.format(rs.getFloat("QUANTITY")));
						break;
					}
				}
			} catch (Exception e) {
				e.printStackTrace();
			} finally {
				DBConnection.releaseConnectionToDB(null, pstmt, rs);
			}
			//Monthly Returns Count
			try {
				pstmt = connection.prepareStatement(IronMiningStatement.GET_MONTHLY_RETURNS_COUNT);
				pstmt.setInt(1, systemId);
				pstmt.setInt(2, CustomerId);
				pstmt.setInt(3, systemId);
				pstmt.setInt(4, CustomerId);
				pstmt.setInt(5, systemId);
				pstmt.setInt(6, CustomerId);
				pstmt.setInt(7, systemId);
				pstmt.setInt(8, CustomerId);
				rs = pstmt.executeQuery();
				while (rs.next()) {
					switch (rs.getInt("type")) {
					case 1:
						jsonObject.put("totalMonthlyRetunsCount", rs.getInt("COUNT"));
						break;
					case 2:
						jsonObject.put("approvedMonthlyRetunsCount", rs.getInt("COUNT"));
						break;
					case 3:
						jsonObject.put("pendingMonthlyRetunsCount", rs.getInt("COUNT"));
						break;
					case 4:
						jsonObject.put("rejectedMonthlyRetunsCount", rs.getInt("COUNT"));
						break;
					}
				}
			} catch (Exception e) {
				e.printStackTrace();
			} finally {
				DBConnection.releaseConnectionToDB(null, pstmt, rs);
			}
			jsonArray.put(jsonObject);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(connection, pstmt, rs);
		}
		return jsonArray;
	}

	public JSONArray getTripSheetCountAndQuantity(int systemId, int CustomerId, int userId) {

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Connection connection = null;
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject = new JSONObject();
		DecimalFormat df = new DecimalFormat("##0.00");
		try {
			connection = DBConnection.getConnectionToDB("AMS");
			//trucktripsheet count
			try {
				pstmt = connection.prepareStatement(IronMiningStatement.GET_TRUCK_TRIPSHEET_COUNT_AND_QUANTITY);
				pstmt.setInt(1, systemId);
				pstmt.setInt(2, CustomerId);
				pstmt.setInt(3, userId);
				pstmt.setInt(4, systemId);
				pstmt.setInt(5, userId);
				pstmt.setInt(6, systemId);
				pstmt.setInt(7, systemId);
				pstmt.setInt(8, CustomerId);
				pstmt.setInt(9, userId);
				pstmt.setInt(10, systemId);
				pstmt.setInt(11, userId);
				pstmt.setInt(12, systemId);
				pstmt.setInt(13, systemId);
				pstmt.setInt(14, CustomerId);
				pstmt.setInt(15, userId);
				pstmt.setInt(16, systemId);
				pstmt.setInt(17, userId);
				pstmt.setInt(18, systemId);
				pstmt.setInt(19, systemId);
				pstmt.setInt(20, CustomerId);
				pstmt.setInt(21, userId);
				pstmt.setInt(22, systemId);
				pstmt.setInt(23, userId);
				pstmt.setInt(24, systemId);
				pstmt.setInt(25, systemId);
				pstmt.setInt(26, CustomerId);
				pstmt.setInt(27, userId);
				pstmt.setInt(28, systemId);
				pstmt.setInt(29, userId);
				pstmt.setInt(30, systemId);

				rs = pstmt.executeQuery();
				while (rs.next()) {
					switch (rs.getInt("type")) {
					case 1:
						jsonObject.put("totalTripSheetCount", rs.getInt("COUNT"));
						jsonObject.put("totalTripSheetQty", rs.getInt("TOTAL_QTY"));
						break;
					case 2:
						jsonObject.put("openTripSheetCount", rs.getInt("COUNT"));
						jsonObject.put("openTripSheetQty", rs.getInt("TOTAL_QTY"));
						break;
					case 3:
						jsonObject.put("CloseTripSheetCount", rs.getInt("COUNT"));
						jsonObject.put("CloseTripSheetQty", rs.getInt("TOTAL_QTY"));
						break;
					}
				}
			} catch (Exception e) {
				e.printStackTrace();
			} finally {
				DBConnection.releaseConnectionToDB(null, pstmt, rs);
			}

			//Bargetripsheet count
			try {
				pstmt = connection.prepareStatement(IronMiningStatement.GET_BARGE_TRIPSHEET_COUNT_AND_QUANTITY);
				pstmt.setInt(1, systemId);
				pstmt.setInt(2, CustomerId);
				pstmt.setInt(3, userId);
				pstmt.setInt(4, systemId);
				pstmt.setInt(5, systemId);
				pstmt.setInt(6, CustomerId);
				pstmt.setInt(7, userId);
				pstmt.setInt(8, systemId);
				pstmt.setInt(9, systemId);
				pstmt.setInt(10, CustomerId);
				pstmt.setInt(11, userId);
				pstmt.setInt(12, systemId);

				rs = pstmt.executeQuery();
				while (rs.next()) {
					switch (rs.getInt("type")) {
					case 1:
						jsonObject.put("totalBargeTripSheetCount", rs.getInt("COUNT"));
						jsonObject.put("totalBargeTripSheetQty", rs.getInt("TOTAL_BARGE_QTY"));
						break;
					case 2:
						jsonObject.put("openBargeTripSheetCount", rs.getInt("COUNT"));
						jsonObject.put("openBargeTripSheetQty", rs.getInt("TOTAL_BARGE_QTY"));
						break;
					case 3:
						jsonObject.put("ClosedBargeTripSheetCount", rs.getInt("COUNT"));
						jsonObject.put("ClosedBargeTripSheetQty", rs.getInt("TOTAL_BARGE_QTY"));
						break;
					}
				}
			} catch (Exception e) {
				e.printStackTrace();
			} finally {
				DBConnection.releaseConnectionToDB(null, pstmt, rs);
			}
			jsonArray.put(jsonObject);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(connection, pstmt, rs);
		}
		return jsonArray;
	}

	public JSONArray getTripsheetCountForChart(int systemId, int CustomerId, int userId) {

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Connection connection = null;
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject = new JSONObject();
		DecimalFormat df = new DecimalFormat("##0.00");
		try {
			connection = DBConnection.getConnectionToDB("AMS");
			//truck trip sheet count for chart
			try {
				pstmt = connection.prepareStatement(IronMiningStatement.GET_TRIPSHEET_COUNT_FOR_TRUCK);
				pstmt.setInt(1, systemId);
				pstmt.setInt(2, CustomerId);
				pstmt.setInt(3, userId);
				pstmt.setInt(4, systemId);
				pstmt.setInt(5, userId);
				pstmt.setInt(6, systemId);
				pstmt.setInt(7, systemId);
				pstmt.setInt(8, CustomerId);
				pstmt.setInt(9, userId);
				pstmt.setInt(10, systemId);
				pstmt.setInt(11, userId);
				pstmt.setInt(12, systemId);
				rs = pstmt.executeQuery();
				while (rs.next()) {
					jsonObject.put(rs.getString("DATE").replaceAll("\\s", ""), rs.getInt("COUNT"));
				}
				jsonArray.put(jsonObject);
			} catch (Exception e) {
				e.printStackTrace();
			} finally {
				DBConnection.releaseConnectionToDB(null, pstmt, rs);
			}

			//barge count for chart
			try {
				jsonObject = new JSONObject();
				pstmt = connection.prepareStatement(IronMiningStatement.GET_TRIPSHEET_COUNT_FOR_BARGE);
				pstmt.setInt(1, systemId);
				pstmt.setInt(2, CustomerId);
				pstmt.setInt(3, userId);
				pstmt.setInt(4, systemId);

				rs = pstmt.executeQuery();
				while (rs.next()) {
					jsonObject.put(rs.getString("DATE").replaceAll("\\s", ""), rs.getInt("COUNT"));
				}
			} catch (Exception e) {
				e.printStackTrace();
			} finally {
				DBConnection.releaseConnectionToDB(null, pstmt, rs);
			}
			jsonArray.put(jsonObject);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(connection, null, null);
		}
		return jsonArray;
	}

	public JSONArray getTripsheetQuantityForChart(int systemId, int CustomerId, int userId) {

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Connection connection = null;
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject = new JSONObject();
		DecimalFormat df = new DecimalFormat("##0.00");
		try {
			connection = DBConnection.getConnectionToDB("AMS");
			//truck trip sheet quantity for chart
			try {
				pstmt = connection.prepareStatement(IronMiningStatement.GET_TRIPSHEET_QUANTITY_FOR_TRUCK);
				pstmt.setInt(1, systemId);
				pstmt.setInt(2, CustomerId);
				pstmt.setInt(3, userId);
				pstmt.setInt(4, systemId);
				pstmt.setInt(5, userId);
				pstmt.setInt(6, systemId);
				pstmt.setInt(7, systemId);
				pstmt.setInt(8, CustomerId);
				pstmt.setInt(9, userId);
				pstmt.setInt(10, systemId);
				pstmt.setInt(11, userId);
				pstmt.setInt(12, systemId);

				rs = pstmt.executeQuery();
				while (rs.next()) {
					jsonObject.put(rs.getString("DATE").replaceAll("\\s", ""), rs.getInt("COUNT"));
				}
				jsonArray.put(jsonObject);
			} catch (Exception e) {
				e.printStackTrace();
			} finally {
				DBConnection.releaseConnectionToDB(null, pstmt, rs);
			}

			//barge Quantity for chart
			try {
				jsonObject = new JSONObject();
				pstmt = connection.prepareStatement(IronMiningStatement.GET_TRIPSHEET_QUANTITY_FOR_BARGE);
				pstmt.setInt(1, systemId);
				pstmt.setInt(2, CustomerId);
				pstmt.setInt(3, userId);
				pstmt.setInt(4, systemId);

				rs = pstmt.executeQuery();
				while (rs.next()) {
					jsonObject.put(rs.getString("DATE").replaceAll("\\s", ""), rs.getInt("COUNT"));
				}
			} catch (Exception e) {
				e.printStackTrace();
			} finally {
				DBConnection.releaseConnectionToDB(null, pstmt, rs);
			}
			jsonArray.put(jsonObject);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(connection, null, null);
		}
		return jsonArray;
	}

	public String transferTrip(String clientId, int systemId, String extVehicleNo, String tripSheetNo,
			String replaceVehicleNo, String remark, String tripId, String Transfertareweight, int userId) {

		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int updated;
		String message = "";
		LogWriter logWriter = null;
		float netweight = 0;
		float grossWeight = 0;
		try {
			con = DBConnection.getConnectionToDB("AMS");
			Properties properties = ApplicationListener.prop;
			String logFile = properties.getProperty("LogFileForTripTransfer");
			String logFileName = logFile.substring(0, logFile.lastIndexOf("."));
			String logFileExt = logFile.substring(logFile.lastIndexOf(".") + 1, logFile.length());
			logFile = logFileName + "-" + sdf.format(new Date()) + "." + logFileExt;

			PrintWriter pw;

			if (logFile != null) {
				try {
					pw = new PrintWriter(new FileWriter(logFile, true), true);
					logWriter = new LogWriter("transferTrip", LogWriter.INFO, pw);
					;
					logWriter.setPrintWriter(pw);
				} catch (IOException e) {
					logWriter.log("Can't open the log file: " + logFile + ". Using System.err instead",
							LogWriter.ERROR);
				}
			}
			logWriter.log(" Begining of the method ", LogWriter.INFO);
			logWriter.log(" Existing Vehicle No== " + extVehicleNo + " Tripsheet No== " + tripSheetNo
					+ " Replace vehicle No== " + replaceVehicleNo + " Trip ID== " + tripId, LogWriter.INFO);

			pstmt = con.prepareStatement(IronMiningStatement.GET_NET_WEIGHT);
			pstmt.setString(1, tripId);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				netweight = rs.getFloat("NET_WEIGHT");
			}
			grossWeight = Float.parseFloat(Transfertareweight) + netweight;

			pstmt = con.prepareStatement(IronMiningStatement.INSERT_TRANSFER_TRIP_DETAILS);
			pstmt.setString(1, replaceVehicleNo);
			pstmt.setFloat(2, grossWeight);
			pstmt.setFloat(3, Float.parseFloat(Transfertareweight));
			pstmt.setString(4, extVehicleNo);
			pstmt.setString(5, tripSheetNo);
			pstmt.setInt(6, systemId);
			pstmt.setInt(7, Integer.parseInt(clientId));
			pstmt.setString(8, tripId);

			updated = pstmt.executeUpdate();
			logWriter.log(" TRIP DETAILS INSERTED ", LogWriter.INFO);
			if (updated > 0) {

				pstmt = con.prepareStatement(IronMiningStatement.UPDATE_TRIP_STATUS_IN_ASSET_ENROLMENT);
				pstmt.setString(1, "CLOSE");
				pstmt.setString(2, extVehicleNo);
				pstmt.setInt(3, systemId);
				pstmt.setInt(4, Integer.parseInt(clientId));
				pstmt.executeUpdate();
				logWriter.log(" Updated trip status in asset enrolment for existing vehicle ", LogWriter.INFO);

				pstmt = con.prepareStatement(IronMiningStatement.UPDATE_TRIP_STATUS_IN_ASSET_ENROLMENT);
				pstmt.setString(1, "OPEN");
				pstmt.setString(2, replaceVehicleNo);
				pstmt.setInt(3, systemId);
				pstmt.setInt(4, Integer.parseInt(clientId));
				pstmt.executeUpdate();
				logWriter.log(" Updated trip status in asset enrolment for new vehicle ", LogWriter.INFO);

				pstmt = con.prepareStatement(IronMiningStatement.UPDATE_VEHICLE_DETAILS);
				pstmt.setString(1, remark);
				pstmt.setInt(2, userId);
				pstmt.setString(3, extVehicleNo);
				pstmt.setString(4, tripSheetNo);
				pstmt.setInt(5, systemId);
				pstmt.setInt(6, Integer.parseInt(clientId));
				pstmt.setString(7, tripId);
				pstmt.executeUpdate();
				logWriter.log(" Updated Quantity and status for existing vehicle ", LogWriter.INFO);

				message = "Trip Transfer details updated successfully";
				logWriter.log("Trip Transfer details updated successfully", LogWriter.INFO);
			} else {
				message = "Error in saving trip transfer details";
				logWriter.log("Error in saving trip transfer details", LogWriter.INFO);
			}
		} catch (Exception e) {
			System.out.println("error in Trip Sheet Details :-save Trip Sheet Details" + e.toString());
			StringWriter errors = new StringWriter();
			e.printStackTrace(new PrintWriter(errors));
			logWriter.log(errors.toString(), LogWriter.ERROR);
			e.printStackTrace();
			if (con != null) {
				try {
					pstmt = con.prepareStatement(
							"insert into AMS.dbo.EmailQueue(Subject,Body,EmailList,SystemId) values (?,?,?,?)");
					pstmt.setString(1, "error in tripTransfer for SystemId " + systemId);
					pstmt.setString(2, errors.toString());
					pstmt.setString(3,
							"gayatri.p@telematics4u.com,praveen.c@telematics4u.com,namrata.d@telematics4u.com");
					pstmt.setInt(4, systemId);
					pstmt.executeUpdate();
					logWriter.log("Record inserted in EmailQueue", LogWriter.INFO);
				} catch (SQLException e1) {
					errors = new StringWriter();
					e1.printStackTrace(new PrintWriter(errors));
					logWriter.log(errors.toString(), LogWriter.ERROR);
					e1.printStackTrace();
				}
			}
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return message;
	}

	public JSONArray getOrgNameForBarge(int userId, int systemId) {
		JSONArray JsonArray = null;
		JSONObject JsonObject = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			JsonArray = new JSONArray();
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(IronMiningStatement.GET_ORG_NAME_FOR_BARGE);
			pstmt.setInt(1, userId);
			pstmt.setInt(2, systemId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				JsonObject = new JSONObject();
				JsonObject.put("orgName", rs.getString("ORGANIZATION_NAME"));
				JsonObject.put("orgId", rs.getInt("ORG_ID"));
				JsonArray.put(JsonObject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return JsonArray;
	}

	public JSONArray getMiningTimes(int customerId, int systemId) {
		JSONArray JsonArray = null;
		JSONObject JsonObject = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		CommonFunctions cf = new CommonFunctions();
		try {
			JsonArray = new JSONArray();
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(IronMiningStatement.GET_MINING_TIMES);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, customerId);
			rs = pstmt.executeQuery();
			int startHrs = 0;
			int startMnt = 0;
			int endHrs = 0;
			int endMnt = 0;
			int brStartHrs = 0;
			int brStartMnt = 0;
			int brEndHrs = 0;
			int brEndMnt = 0;
			int firstResStartHrs = 0;
			int firstResStartMnt = 0;
			int firstResEndHrs = 0;
			int firstResEndMnt = 0;
			int secondResStartHrs = 0;
			int secondResStartMnt = 0;
			int secondResEndHrs = 0;
			int secondResEndMnt = 0;

			int nonComHrs = 0;
			if (rs.next()) {
				String sTime = rs.getString("START_TIME");
				if (sTime != null && !sTime.equals("")) {
					String[] arr = sTime.split(":");
					startHrs = Integer.parseInt(arr[0]);
					startMnt = Integer.parseInt(arr[1]);
				}
				String eTime = rs.getString("END_TIME");
				if (eTime != null && !eTime.equals("")) {
					String[] arr = eTime.split(":");
					endHrs = Integer.parseInt(arr[0]);
					endMnt = Integer.parseInt(arr[1]);
				}
				String brSTime = rs.getString("BREAK_START_TIME");
				if (brSTime != null && !brSTime.equals("")) {
					String[] arr = brSTime.split(":");
					brStartHrs = Integer.parseInt(arr[0]);
					brStartMnt = Integer.parseInt(arr[1]);
				}
				String brETime = rs.getString("BREAK_END_TIME");
				if (brETime != null && !brETime.equals("")) {
					String[] arr = brETime.split(":");
					brEndHrs = Integer.parseInt(arr[0]);
					brEndMnt = Integer.parseInt(arr[1]);
				}
				String firstRestrictiveStartTime = rs.getString("FIRST_RESTRICTIVE_START_TIME");
				if (firstRestrictiveStartTime != null && !firstRestrictiveStartTime.equals("")) {
					String[] arr = firstRestrictiveStartTime.split(":");
					firstResStartHrs = Integer.parseInt(arr[0]);
					firstResStartMnt = Integer.parseInt(arr[1]);
				}
				String firstRestrictiveEndTime = rs.getString("FIRST_RESTRICTIVE_END_TIME");
				if (firstRestrictiveEndTime != null && !firstRestrictiveEndTime.equals("")) {
					String[] arr = firstRestrictiveEndTime.split(":");
					firstResEndHrs = Integer.parseInt(arr[0]);
					firstResEndMnt = Integer.parseInt(arr[1]);
				}
				String secondRestrictiveStartTime = rs.getString("SECOND_RESTRICTIVE_START_TIME");
				if (secondRestrictiveStartTime != null && !secondRestrictiveStartTime.equals("")) {
					String[] arr = secondRestrictiveStartTime.split(":");
					secondResStartHrs = Integer.parseInt(arr[0]);
					secondResStartMnt = Integer.parseInt(arr[1]);
				}
				String secondRestrictiveEndTime = rs.getString("SECOND_RESTRICTIVE_END_TIME");
				if (secondRestrictiveEndTime != null && !secondRestrictiveEndTime.equals("")) {
					String[] arr = secondRestrictiveEndTime.split(":");
					secondResEndHrs = Integer.parseInt(arr[0]);
					secondResEndMnt = Integer.parseInt(arr[1]);
				}

				nonComHrs = rs.getInt("NON_COMM_HRS");
			}
			JsonObject = new JSONObject();
			JsonObject.put("startHrsInx", startHrs);
			JsonObject.put("startMntInx", startMnt);
			JsonObject.put("endHrsInx", endHrs);
			JsonObject.put("endMntInx", endMnt);
			JsonObject.put("brStartHrsInx", brStartHrs);
			JsonObject.put("brStartMntInx", brStartMnt);
			JsonObject.put("brEndHrsInx", brEndHrs);
			JsonObject.put("brEndMntInx", brEndMnt);
			JsonObject.put("nonComHrsInx", cf.convertMinutesToHHMMFormat(nonComHrs));
			JsonObject.put("firstResStartHrsInx", firstResStartHrs);
			JsonObject.put("firstResStartMntInx", firstResStartMnt);
			JsonObject.put("firstResEndHrsInx", firstResEndHrs);
			JsonObject.put("firstResEndMntInx", firstResEndMnt);
			JsonObject.put("secondResStartHrsInx", secondResStartHrs);
			JsonObject.put("secondResStartMntInx", secondResStartMnt);
			JsonObject.put("secondResEndHrsInx", secondResEndHrs);
			JsonObject.put("secondResEndMntInx", secondResEndMnt);
			JsonArray.put(JsonObject);

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return JsonArray;
	}

	public String saveMiningTimes(int systemId, int custId, String startTime, String endTime, String brStartTime,
			String brEndTime, String nonCommHrs, String firstResStartTime, String firstResEndTime,
			String secondResStartTime, String secondResEndTime) {
		//System.out.println("systemId ="+systemId+",custId ="+custId+",startTime ="+startTime+",endTime ="+endTime+",brStartTime ="+brStartTime+",brEndTime ="+brEndTime+",NonCommHrs ="+nonCommHrs);
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String message = "";
		CommonFunctions cf = new CommonFunctions();
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(IronMiningStatement.GET_MINING_TIMES);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, custId);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				//Update
				pstmt = con.prepareStatement(IronMiningStatement.UPDATE_MINING_TIMES);
				pstmt.setString(1, startTime);
				pstmt.setString(2, endTime);
				pstmt.setString(3, brStartTime);
				pstmt.setString(4, brEndTime);
				pstmt.setInt(5, cf.convertHHMMToMinutes1(nonCommHrs));
				pstmt.setString(6, firstResStartTime);
				pstmt.setString(7, firstResEndTime);
				pstmt.setString(8, secondResStartTime);
				pstmt.setString(9, secondResEndTime);
				pstmt.setInt(10, systemId);
				pstmt.setInt(11, custId);
				int updated = pstmt.executeUpdate();
				message = updated > 0 ? "Updated Successfully" : "Error in Updation";
			} else {
				//Insert
				pstmt = con.prepareStatement(IronMiningStatement.INSERT_MINING_TIMES);
				pstmt.setString(1, startTime);
				pstmt.setString(2, endTime);
				pstmt.setString(3, brStartTime);
				pstmt.setString(4, brEndTime);
				pstmt.setInt(5, cf.convertHHMMToMinutes1(nonCommHrs));
				pstmt.setString(6, firstResStartTime);
				pstmt.setString(7, firstResEndTime);
				pstmt.setString(8, secondResStartTime);
				pstmt.setString(9, secondResEndTime);
				pstmt.setInt(10, systemId);
				pstmt.setInt(11, custId);
				int inserted = pstmt.executeUpdate();
				message = inserted > 0 ? "Inserted Successfully" : "Error in Insertion";
			}

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return message;
	}

	public JSONArray getPermitsForUser(int systemId, int customerId, int userId) {
		JSONArray jsonArray = null;
		JSONObject jsonObject = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			jsonArray = new JSONArray();
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(IronMiningStatement.GET_PERMITS_FOR_USER);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, customerId);
			pstmt.setInt(3, userId);
			pstmt.setInt(4, systemId);
			pstmt.setInt(5, userId);
			pstmt.setInt(6, systemId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				jsonObject = new JSONObject();
				jsonObject.put("permitId", rs.getInt("ID"));
				jsonObject.put("permitNo", rs.getString("PERMIT_NO"));
				jsonArray.put(jsonObject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jsonArray;
	}

	public ArrayList getTripSheetDetailsForBargeUsingPermit(int systemId, int CustomerId, int userId, int permitId) {
		JSONArray JsonArray = new JSONArray();
		JSONObject JsonObject = null;
		Connection con = null;
		PreparedStatement pstmt52 = null;
		ResultSet rs52 = null;
		int aslcount = 0;
		SimpleDateFormat diffddMMyyyyHHmmss = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
		ArrayList assetLists = new ArrayList();
		DecimalFormat df = new DecimalFormat("#.###");
		ArrayList<String> headersList = new ArrayList<String>();
		ArrayList<ReportHelper> reportsList = new ArrayList<ReportHelper>();
		ReportHelper finalreporthelper = new ReportHelper();

		headersList.add("SLNO");
		headersList.add("Type");
		headersList.add("Trip Sheet Number");
		headersList.add("Barge Name");
		headersList.add("Issued Date");
		headersList.add("Stop BLO DateTime");
		headersList.add("Validity Date Time");
		headersList.add("Status");
		headersList.add("Barge Capacity");
		headersList.add("Quantity");
		headersList.add("Unique Id");
		headersList.add("Closed Date Time");

		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt52 = con.prepareStatement(IronMiningStatement.GET_BARGE_TRIP_DETAILS_PER_PERMIT);
			pstmt52.setInt(1, systemId);
			pstmt52.setInt(2, CustomerId);
			pstmt52.setInt(3, systemId);
			pstmt52.setInt(4, CustomerId);
			pstmt52.setInt(5, permitId);
			pstmt52.setInt(6, systemId);
			pstmt52.setInt(7, CustomerId);
			pstmt52.setInt(8, permitId);
			rs52 = pstmt52.executeQuery();
			while (rs52.next()) {
				JsonObject = new JSONObject();
				ArrayList<Object> informationList = new ArrayList<Object>();
				ReportHelper reporthelper = new ReportHelper();
				aslcount++;
				JsonObject.put("slnoIndex", aslcount);
				informationList.add(aslcount);

				JsonObject.put("TypeIndex", rs52.getString("TYPE").toUpperCase());
				informationList.add(rs52.getString("TYPE").toUpperCase());

				JsonObject.put("TripSheetNumberIndex", rs52.getString("TRIP_NO").toUpperCase());
				informationList.add(rs52.getString("TRIP_NO").toUpperCase());

				JsonObject.put("assetNoIndex", rs52.getString("ASSET_NUMBER").toUpperCase());
				informationList.add(rs52.getString("ASSET_NUMBER").toUpperCase());

				if (rs52.getString("ISSUE_DATE").contains("1900")) {
					JsonObject.put("issuedIndexId", "");
					informationList.add("");
				} else {
					JsonObject.put("issuedIndexId", diffddMMyyyyHHmmss.format(rs52.getTimestamp(("ISSUE_DATE"))));
					informationList.add(diffddMMyyyyHHmmss.format(rs52.getTimestamp(("ISSUE_DATE"))));
				}
				if (rs52.getString("STOP_BLO_DATETIME").contains("1900")) {
					JsonObject.put("stopBLODateTimeIndexId", "");
					informationList.add("");
				} else {
					JsonObject.put("stopBLODateTimeIndexId",
							diffddMMyyyyHHmmss.format(rs52.getTimestamp(("STOP_BLO_DATETIME"))));
					informationList.add(diffddMMyyyyHHmmss.format(rs52.getTimestamp(("STOP_BLO_DATETIME"))));
				}

				if (rs52.getTimestamp("VALIDITY_DATE") == null || rs52.getString("VALIDITY_DATE").equals("")
						|| rs52.getString("VALIDITY_DATE").contains("1900")) {
					JsonObject.put("validityDateDataIndex", "");
					informationList.add("");
				} else {
					JsonObject.put("validityDateDataIndex",
							diffddMMyyyyHHmmss.format(rs52.getTimestamp("VALIDITY_DATE")));
					informationList.add(diffddMMyyyyHHmmss.format(rs52.getTimestamp("VALIDITY_DATE")));
				}
				if (rs52.getString("STATUS").equalsIgnoreCase("Start BLO")) {
					JsonObject.put("statusIndexId", "BLO In-Transit");
					informationList.add("BLO In-Transit");
				} else if (rs52.getString("STATUS").equalsIgnoreCase("Stop BLO")) {
					JsonObject.put("statusIndexId", "In-Transit");
					informationList.add("In-Transit");
				} else if (rs52.getString("STATUS").equalsIgnoreCase("Close")) {
					JsonObject.put("statusIndexId", "Closed-Completed Trip");
					informationList.add("Closed-Completed trip");
				} else {
					JsonObject.put("statusIndexId", rs52.getString("STATUS"));
					informationList.add(rs52.getString("STATUS"));
				}

				JsonObject.put("QuantityIndex", df.format(rs52.getFloat("QUANTITY2")));
				informationList.add(rs52.getString("QUANTITY2"));

				float bargeQuantity = Float.parseFloat(rs52.getString("QUANTITY1"));
				JsonObject.put("q1IndexId", df.format(bargeQuantity / 1000));
				informationList.add(df.format(bargeQuantity / 1000));

				JsonObject.put("uniqueIDIndex", rs52.getString("ID"));
				informationList.add(rs52.getString("ID"));

				JsonObject.put("orgIdIndex", rs52.getInt("ORGANIZATION_ID"));
				JsonObject.put("bargeLocIndex", rs52.getInt("SOURCE_HUBID"));
				JsonObject.put("flagIndex", rs52.getString("FLAG"));

				JsonObject.put("vesselNameIndex", rs52.getString("VESSEL_NAME"));
				//informationList.add(rs52.getString("VESSEL_NAME"));

				JsonObject.put("destinationIndex", rs52.getString("DESTINATION"));
				//informationList.add(rs52.getString("DESTINATION"));

				JsonObject.put("boatNote", rs52.getString("BOAT_NOTE"));
				//informationList.add(rs52.getString("BOAT_NOTE"));

				JsonObject.put("reason", rs52.getString("REASON"));
				//informationList.add(rs52.getString("REASON"));

				if (rs52.getString("CLOSED_DATETIME").contains("1900")
						|| rs52.getString("STATUS").equalsIgnoreCase("Stop BLO")) {
					JsonObject.put("closedDateIndex", "");
					informationList.add("");
				} else {
					JsonObject.put("closedDateIndex",
							diffddMMyyyyHHmmss.format(rs52.getTimestamp(("CLOSED_DATETIME"))));
					informationList.add(diffddMMyyyyHHmmss.format(rs52.getTimestamp(("CLOSED_DATETIME"))));
				}
				JsonArray.put(JsonObject);
				reporthelper.setInformationList(informationList);
				reportsList.add(reporthelper);
			}
			assetLists.add(JsonArray);
			finalreporthelper.setReportsList(reportsList);
			finalreporthelper.setHeadersList(headersList);
			assetLists.add(finalreporthelper);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {

			DBConnection.releaseConnectionToDB(con, pstmt52, rs52);
		}
		return assetLists;
	}

	public ArrayList getTripSheetGenerationDetailsUsingPermit(int systemId, int CustomerId, int userId, int permitId) {
		JSONArray JsonArray = new JSONArray();
		JSONObject JsonObject = null;
		Connection con = null;
		PreparedStatement pstmt52 = null;
		ResultSet rs52 = null;
		int aslcount = 0;
		SimpleDateFormat diffddMMyyyyHHmmss = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
		ArrayList assetLists = new ArrayList();
		DecimalFormat df = new DecimalFormat("#.###");
		ArrayList<String> headersList = new ArrayList<String>();
		ArrayList<ReportHelper> reportsList = new ArrayList<ReportHelper>();
		ReportHelper finalreporthelper = new ReportHelper();

		headersList.add("SLNO");
		headersList.add("Type @S");
		headersList.add("Trip Sheet Number");
		headersList.add("Asset Number");
		headersList.add("TC Lease Name");
		headersList.add("Organization/Trader Name");
		headersList.add("Issued Date");
		headersList.add("Validity Date Time");
		headersList.add("Grade / Type");
		headersList.add("Route");
		headersList.add("W B @S");
		headersList.add("Status");
		headersList.add("Tare W @ S");
		headersList.add("Gross W @ S");
		headersList.add("Net W @ S");
		headersList.add("Type @ D");
		headersList.add("Gross W @ D");
		headersList.add("Tare W @ D");
		headersList.add("Net W @ D");
		headersList.add("W B @ D");
		headersList.add("Closing Type");
		headersList.add("Actual Quantity");
		headersList.add("Permit Id");
		headersList.add("Closed DateTime");
		headersList.add("Source Storage Location");
		headersList.add("Destination Storage Location");
		headersList.add("Transaction No");
		headersList.add("Communicating Status");
		headersList.add("Trip Transfer Reason");

		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt52 = con.prepareStatement(IronMiningStatement.GET_MINING_TRIP_SHEET_GENERATION_DETAILS_PER_PERMIT);
			pstmt52.setInt(1, systemId);
			pstmt52.setInt(2, CustomerId);
			pstmt52.setInt(3, permitId);
			pstmt52.setInt(4, userId);
			pstmt52.setInt(5, systemId);
			pstmt52.setInt(6, userId);
			pstmt52.setInt(7, systemId);
			pstmt52.setInt(8, systemId);
			pstmt52.setInt(9, CustomerId);
			pstmt52.setInt(10, permitId);
			pstmt52.setInt(11, userId);
			pstmt52.setInt(12, systemId);
			pstmt52.setInt(13, userId);
			pstmt52.setInt(14, systemId);
			rs52 = pstmt52.executeQuery();
			while (rs52.next()) {
				JsonObject = new JSONObject();
				ArrayList<Object> informationList = new ArrayList<Object>();
				ReportHelper reporthelper = new ReportHelper();
				aslcount++;
				JsonObject.put("slnoIndex", aslcount);
				informationList.add(aslcount);

				JsonObject.put("uniqueIDIndex", rs52.getString("ID"));

				JsonObject.put("TypeIndex", rs52.getString("TYPE").toUpperCase());
				informationList.add(rs52.getString("TYPE").toUpperCase());

				JsonObject.put("TripSheetNumberIndex", rs52.getString("TRIP_NO").toUpperCase());
				informationList.add(rs52.getString("TRIP_NO").toUpperCase());

				JsonObject.put("assetNoIndex", rs52.getString("ASSET_NUMBER").toUpperCase());
				informationList.add(rs52.getString("ASSET_NUMBER").toUpperCase());

				JsonObject.put("tcLeaseNoIndex", rs52.getString("LESSE_NAME"));
				informationList.add(rs52.getString("LESSE_NAME").toUpperCase());

				JsonObject.put("orgNameIndex", rs52.getString("ORGANIZATION_NAME"));
				informationList.add(rs52.getString("ORGANIZATION_NAME").toUpperCase());

				JsonObject.put("issuedIndexId", diffddMMyyyyHHmmss.format(rs52.getTimestamp(("ISSUE_DATE"))));
				informationList.add(diffddMMyyyyHHmmss.format(rs52.getTimestamp(("ISSUE_DATE"))));

				if (rs52.getTimestamp("VALIDITY_DATE") == null || rs52.getString("VALIDITY_DATE").equals("")
						|| rs52.getString("VALIDITY_DATE").contains("1900")) {
					JsonObject.put("validityDateDataIndex", "");
					informationList.add("");
				} else {
					JsonObject.put("validityDateDataIndex",
							diffddMMyyyyHHmmss.format(rs52.getTimestamp("VALIDITY_DATE")));
					informationList.add(diffddMMyyyyHHmmss.format(rs52.getTimestamp("VALIDITY_DATE")));
				}

				JsonObject.put("gradeAndMineralIndex", rs52.getString("GRADE_NAME"));
				informationList.add(rs52.getString("GRADE_NAME").toUpperCase());

				JsonObject.put("RouteIndex", rs52.getString("ROUTE_NAME"));
				informationList.add(rs52.getString("ROUTE_NAME").toUpperCase());

				JsonObject.put("wbsIndex", rs52.getString("WBS"));
				informationList.add(rs52.getString("WBS"));

				JsonObject.put("statusIndexId", rs52.getString("STATUS"));
				informationList.add(rs52.getString("STATUS").toUpperCase());

				JsonObject.put("q1IndexId", rs52.getString("QUANTITY1"));
				informationList.add(rs52.getString("QUANTITY1").toUpperCase());

				JsonObject.put("QuantityIndex", String.valueOf(rs52.getString("QUANTITY2")).split("\\.")[0]);
				informationList.add(String.valueOf(rs52.getString("QUANTITY2")).split("\\.")[0]);

				JsonObject.put("netIndexId", df.format(rs52.getFloat("QUANTITY2") - rs52.getFloat("QUANTITY1")));
				informationList.add(df.format(rs52.getFloat("QUANTITY2") - rs52.getFloat("QUANTITY1")));

				JsonObject.put("typedestIndex", rs52.getString("DESTINATION_TYPE"));
				informationList.add(rs52.getString("DESTINATION_TYPE"));

				if (rs52.getFloat("QUANTITY3") == 0.0) {
					JsonObject.put("q2IndexId", "");
					informationList.add("");
				} else {
					JsonObject.put("q2IndexId", rs52.getString("QUANTITY3"));
					informationList.add(rs52.getString("QUANTITY3"));
				}

				if (rs52.getFloat("QUANTITY4") == 0.0) {
					JsonObject.put("q3IndexId", "");
					informationList.add("");
				} else {
					JsonObject.put("q3IndexId", rs52.getString("QUANTITY4"));
					informationList.add(rs52.getString("QUANTITY4"));
				}

				JsonObject.put("netWghtDestIndex", df.format(rs52.getFloat("QUANTITY3") - rs52.getFloat("QUANTITY4")));
				informationList.add(df.format(rs52.getFloat("QUANTITY3") - rs52.getFloat("QUANTITY4")));

				JsonObject.put("wbdIndex", rs52.getString("WBD"));
				informationList.add(rs52.getString("WBD"));

				JsonObject.put("closingTypeDataIndex", rs52.getString("CLOSING_TYPE"));
				informationList.add(rs52.getString("CLOSING_TYPE"));

				JsonObject.put("actualQtyIndexId", rs52.getString("TRIPSHEET_QTY"));
				informationList.add(rs52.getString("TRIPSHEET_QTY"));

				JsonObject.put("permitIndexId", rs52.getString("PERMIT_ID"));
				informationList.add(rs52.getString("PERMIT_ID"));

				if (rs52.getString(("CLOSED_DATETIME")).contains("1900")) {
					JsonObject.put("closedDateIndexId", "");
					informationList.add("");
				} else {
					JsonObject.put("closedDateIndexId",
							diffddMMyyyyHHmmss.format(rs52.getTimestamp(("CLOSED_DATETIME"))));
					informationList.add(diffddMMyyyyHHmmss.format(rs52.getTimestamp(("CLOSED_DATETIME"))));
				}

				JsonObject.put("dsSourceIndex", rs52.getString("DS_SOURCE"));
				informationList.add(rs52.getString("DS_SOURCE"));

				JsonObject.put("dsdestIndex", rs52.getString("DS_DESTINATION"));
				informationList.add(rs52.getString("DS_DESTINATION"));

				JsonObject.put("transactnIndex", rs52.getString("TRANSACTION_ID"));
				informationList.add(rs52.getString("TRANSACTION_ID"));

				JsonObject.put("commStatus", rs52.getString("COMMUNICATION_STATUS"));
				informationList.add(rs52.getString("COMMUNICATION_STATUS"));

				JsonObject.put("reasonIndex", rs52.getString("REASON"));
				informationList.add(rs52.getString("REASON"));

				JsonObject.put("tcLeaseNoIndexId", rs52.getString("TC_ID"));

				JsonObject.put("RouteIndexId", rs52.getString("ROUTE_ID"));

				JsonObject.put("pIdIndexId", rs52.getInt("PID"));

				JsonArray.put(JsonObject);
				reporthelper.setInformationList(informationList);
				reportsList.add(reporthelper);
			}
			assetLists.add(JsonArray);
			finalreporthelper.setReportsList(reportsList);
			finalreporthelper.setHeadersList(headersList);
			assetLists.add(finalreporthelper);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {

			DBConnection.releaseConnectionToDB(con, pstmt52, rs52);
		}
		return assetLists;
	}

	public ArrayList getTruckTripSheetDetailsForPermit(int systemId, int CustomerId, int userId, int bargeId,
			int permitId) {
		JSONArray JsonArray = new JSONArray();
		JSONObject JsonObject = null;
		Connection con = null;
		PreparedStatement pstmt52 = null;
		ResultSet rs52 = null;
		int aslcount = 0;
		SimpleDateFormat diffddMMyyyyHHmmss = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
		ArrayList assetLists = new ArrayList();
		DecimalFormat df = new DecimalFormat("#.###");
		ArrayList<String> headersList = new ArrayList<String>();
		ArrayList<ReportHelper> reportsList = new ArrayList<ReportHelper>();
		ReportHelper finalreporthelper = new ReportHelper();

		headersList.add("SLNO");
		headersList.add("Type");
		headersList.add("Trip Sheet Number");
		headersList.add("Asset Number");
		headersList.add("TC Lease Name");
		headersList.add("Organization Name");
		headersList.add("Issued Date");
		headersList.add("Validity Date Time");
		headersList.add("Grade And Mineral Information");
		headersList.add("Route");
		headersList.add("Status");
		headersList.add("Tare Weight1");
		headersList.add("Gross Weight1");
		headersList.add("Net Weight");
		headersList.add("Actual Quantity");
		headersList.add("Permit No");
		headersList.add("Vessel Name");
		headersList.add("Communicating Status");

		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt52 = con.prepareStatement(IronMiningStatement.GET_TRUCK_TRIP_SHEET_DETAILS_FOR_PERMIT);
			pstmt52.setInt(1, systemId);
			pstmt52.setInt(2, CustomerId);
			pstmt52.setInt(3, bargeId);
			pstmt52.setInt(4, permitId);
			pstmt52.setInt(5, systemId);
			pstmt52.setInt(6, CustomerId);
			pstmt52.setInt(7, bargeId);
			pstmt52.setInt(8, permitId);

			rs52 = pstmt52.executeQuery();
			while (rs52.next()) {
				JsonObject = new JSONObject();
				ArrayList<Object> informationList = new ArrayList<Object>();
				ReportHelper reporthelper = new ReportHelper();
				aslcount++;
				JsonObject.put("slnoIndex", aslcount);
				informationList.add(aslcount);

				JsonObject.put("TypeIndex", rs52.getString("TYPE").toUpperCase());
				informationList.add(rs52.getString("TYPE").toUpperCase());

				JsonObject.put("TripSheetNumberIndex", rs52.getString("TRIP_NO").toUpperCase());
				informationList.add(rs52.getString("TRIP_NO").toUpperCase());

				JsonObject.put("assetNoIndex", rs52.getString("ASSET_NUMBER").toUpperCase());
				informationList.add(rs52.getString("ASSET_NUMBER").toUpperCase());

				JsonObject.put("tcLeaseNoIndex", rs52.getString("LESSE_NAME"));
				informationList.add(rs52.getString("LESSE_NAME"));

				JsonObject.put("orgNameIndex", rs52.getString("ORGANIZATION_NAME"));
				informationList.add(rs52.getString("ORGANIZATION_NAME"));

				JsonObject.put("issuedIndexId", diffddMMyyyyHHmmss.format(rs52.getTimestamp(("ISSUE_DATE"))));
				informationList.add(diffddMMyyyyHHmmss.format(rs52.getTimestamp(("ISSUE_DATE"))));

				if (rs52.getTimestamp("VALIDITY_DATE") == null || rs52.getString("VALIDITY_DATE").equals("")
						|| rs52.getString("VALIDITY_DATE").contains("1900")) {
					JsonObject.put("validityDateDataIndex", "");
					informationList.add("");
				} else {
					JsonObject.put("validityDateDataIndex",
							diffddMMyyyyHHmmss.format(rs52.getTimestamp("VALIDITY_DATE")));
					informationList.add(diffddMMyyyyHHmmss.format(rs52.getTimestamp("VALIDITY_DATE")));
				}

				JsonObject.put("gradeAndMineralIndex", rs52.getString("GRADE_NAME"));
				informationList.add(rs52.getString("GRADE_NAME"));

				JsonObject.put("RouteIndex", rs52.getString("ROUTE_NAME"));
				informationList.add(rs52.getString("ROUTE_NAME"));

				JsonObject.put("statusIndexId", rs52.getString("STATUS"));
				informationList.add(rs52.getString("STATUS"));

				JsonObject.put("q1IndexId", rs52.getString("QUANTITY1"));
				informationList.add(rs52.getString("QUANTITY1"));

				JsonObject.put("QuantityIndex", String.valueOf(rs52.getString("QUANTITY2")).split("\\.")[0]);
				informationList.add(String.valueOf(rs52.getString("QUANTITY2")).split("\\.")[0]);

				JsonObject.put("netIndexId", df.format(rs52.getFloat("QUANTITY2") - rs52.getFloat("QUANTITY1")));
				informationList.add(df.format(rs52.getFloat("QUANTITY2") - rs52.getFloat("QUANTITY1")));

				JsonObject.put("uniqueIDIndex", rs52.getString("ID"));

				JsonObject.put("tcLeaseNoIndexId", rs52.getString("TC_ID"));

				//JsonObject.put("gradeAndMineralIndexId", rs52.getString("GRADE_ID"));

				JsonObject.put("RouteIndexId", rs52.getString("ROUTE_ID"));

				JsonObject.put("actualQtyIndexId", rs52.getString("TRIPSHEET_QTY"));
				informationList.add(rs52.getString("TRIPSHEET_QTY"));

				JsonObject.put("permitIndexId", rs52.getString("PERMIT_ID"));
				informationList.add(rs52.getString("PERMIT_ID"));

				JsonObject.put("shipNameIndexId", rs52.getString("SHIP_NAME"));
				informationList.add(rs52.getString("SHIP_NAME"));

				JsonObject.put("commStatusIndexId", rs52.getString("COMMUNICATION_STATUS"));
				informationList.add(rs52.getString("COMMUNICATION_STATUS"));

				JsonArray.put(JsonObject);
				reporthelper.setInformationList(informationList);
				reportsList.add(reporthelper);
			}
			assetLists.add(JsonArray);
			finalreporthelper.setReportsList(reportsList);
			finalreporthelper.setHeadersList(headersList);
			assetLists.add(finalreporthelper);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {

			DBConnection.releaseConnectionToDB(con, pstmt52, rs52);
		}
		return assetLists;
	}

	public JSONArray getVehicleDetails(int systemId, int custId) {

		JSONArray JsonArray = new JSONArray();
		JSONObject JsonObject = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");

		try {
			JsonArray = new JSONArray();
			JsonObject = new JSONObject();
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(IronMiningStatement.GET_VEHICLE_LIST_FOR_VEHICLE_STATUS);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, custId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				JsonObject = new JSONObject();
				String vtsinstalled = "Yes";
				if (rs.getString("VTS_INSTALLED").equals("")) {
					vtsinstalled = "No";
				}
				JsonObject.put("VehicleNo", rs.getString("REGISTRATION_NO"));
				JsonObject.put("VTS_Installed", vtsinstalled);
				JsonObject.put("Vehicle_Status", rs.getString("STATUS"));
				JsonObject.put("Communicating_Status", rs.getString("COMM_STATUS"));
				JsonObject.put("Enrollment_Status", rs.getString("ENROLLMENT_STATUS") + rs.getString("REASON"));
				JsonObject.put("Overspeed_Debarring", "");
				if (rs.getString("PUC_EXPIRY_DATE").equals("") || rs.getString("PUC_EXPIRY_DATE").contains("1900")) {
					JsonObject.put("pucExpDate", "");
				} else {
					JsonObject.put("pucExpDate", sdf.format(rs.getTimestamp("PUC_EXPIRY_DATE")));
				}
				if (rs.getString("INSURANCE_EXPIRY_DATE").equals("")
						|| rs.getString("INSURANCE_EXPIRY_DATE").contains("1900")) {
					JsonObject.put("incExpDate", "");
				} else {
					JsonObject.put("incExpDate", sdf.format(rs.getTimestamp("INSURANCE_EXPIRY_DATE")));
				}
				if (rs.getString("ROADTAX_VALIDITY_DATE").equals("")
						|| rs.getString("ROADTAX_VALIDITY_DATE").contains("1900")) {
					JsonObject.put("roadTaxValidityDate", "");
				} else {
					JsonObject.put("roadTaxValidityDate", sdf.format(rs.getTimestamp("ROADTAX_VALIDITY_DATE")));
				}
				if (rs.getString("PERMIT_VALIDITY_DATE").equals("")
						|| rs.getString("PERMIT_VALIDITY_DATE").contains("1900")) {
					JsonObject.put("permitValidityDate", "");
				} else {
					JsonObject.put("permitValidityDate", sdf.format(rs.getTimestamp("PERMIT_VALIDITY_DATE")));
				}
				JsonObject.put("trip_status", rs.getString("TRIP_STATUS"));
				JsonArray.put(JsonObject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);

		}

		return JsonArray;
	}

	public JSONArray getVehicleInformation(int systemId, int custId, String assetNo) {

		JSONArray JsonArray = new JSONArray();
		JSONObject JsonObject = new JSONObject();
		JSONObject Obj1 = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		PreparedStatement pstmt1 = null;
		ResultSet rs1 = null;
		SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
		SimpleDateFormat sdf1 = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

		try {
			JsonArray = new JSONArray();
			JsonObject = new JSONObject();
			String nonCommunication = "No";
			String mainPower = "No Alert";
			String InternalBattery = "No";
			String overSpeed = "No";
			con = DBConnection.getConnectionToDB("AMS");
			pstmt1 = con.prepareStatement(IronMiningStatement.GET_VEHICLE_INFORMATION);
			pstmt1.setInt(1, systemId);
			pstmt1.setInt(2, custId);
			pstmt1.setString(3, assetNo);
			pstmt1.setInt(4, systemId);
			pstmt1.setInt(5, custId);
			pstmt1.setString(6, assetNo);
			rs1 = pstmt1.executeQuery();
			String Last_Trip_No_and_Status = "";
			String Tare_weight = "";
			String Last_Trip_Issued_Time = "";
			String status = "";
			if (rs1.next()) {

				//	 JsonObject = new JSONObject();
				// JsonObject.put("Last_Trip_No_and_Status", (rs.getString("TRIP_NO")+"("+rs.getString("STATUS")+")"));
				Last_Trip_No_and_Status = rs1.getString("TRIP_NO") + "(" + rs1.getString("STATUS") + ")";
				if (rs1.getString("WEIGHT_DATETIME").equals("") || rs1.getString("WEIGHT_DATETIME").contains("1900")) {
					// JsonObject.put("Tare_weight","");
					Tare_weight = "";
				} else {
					// JsonObject.put("Tare_weight",sdf.format(sdf1.parse(rs.getString("WEIGHT_DATETIME"))));
					Tare_weight = sdf.format(sdf1.parse(rs1.getString("WEIGHT_DATETIME")));
				}
				Last_Trip_Issued_Time = sdf.format(rs1.getTimestamp("INSERTED_TIME"));
				status = rs1.getString("STATUS");
				//	 JsonObject.put("Last_Trip_Issued_Time", sdf.format(rs.getTimestamp("INSERTED_TIME")));
				// JsonArray.put(JsonObject);
			}
			pstmt = con.prepareStatement(IronMiningStatement.GET_VEHICLE_LIST_FOR_VEHICLE_ALERT_STATUS);
			pstmt.setInt(1, systemId);
			pstmt.setString(2, assetNo);
			pstmt.setInt(3, systemId);
			pstmt.setString(4, assetNo);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				JsonObject = new JSONObject();
				JsonObject.put("Last_Trip_No_and_Status", Last_Trip_No_and_Status);
				JsonObject.put("Tare_weight", Tare_weight);
				JsonObject.put("Last_Trip_Issued_Time", Last_Trip_Issued_Time);

				if (rs.getString("TYPE_OF_ALERT").contains("85")) {
					nonCommunication = "Yes " + "(" + sdf.format(rs.getTimestamp("GMT")) + ")";
				}
				if (rs.getString("TYPE_OF_ALERT").contains("7")) {
					mainPower = "Yes " + "(" + sdf.format(rs.getTimestamp("GMT")) + ")";
				}
				if (rs.getString("TYPE_OF_ALERT").contains("154")) {
					InternalBattery = "Yes " + "(" + sdf.format(rs.getTimestamp("GMT")) + ")";
				}
				if (rs.getString("TYPE_OF_ALERT").contains("2")) {
					overSpeed = "Yes " + "(" + sdf.format(rs.getTimestamp("GMT")) + ")";
				}
				JsonObject.put("nonCommunication", nonCommunication);
				JsonObject.put("mainPower", mainPower);
				JsonObject.put("internalBattery", InternalBattery);
				JsonObject.put("overSpeed", overSpeed);
				JsonObject.put("status", status);
				JsonArray.put(JsonObject);
			}

			if (!rs.next()) {
				JsonObject = new JSONObject();
				JsonObject.put("Last_Trip_No_and_Status", Last_Trip_No_and_Status);
				JsonObject.put("Tare_weight", Tare_weight);
				JsonObject.put("Last_Trip_Issued_Time", Last_Trip_Issued_Time);
				JsonObject.put("nonCommunication", nonCommunication);
				JsonObject.put("mainPower", mainPower);
				JsonObject.put("internalBattery", InternalBattery);
				JsonObject.put("overSpeed", overSpeed);
				JsonObject.put("status", status);
				JsonArray.put(JsonObject);
			}

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
			DBConnection.releaseConnectionToDB(null, pstmt1, rs1);
		}

		return JsonArray;
	}

	public String InactiveStatus(String status, int custId, int id, int sysId) {
		String message = "";
		Connection conAdmin = null;
		PreparedStatement pstmt = null;
		int updated = 0;
		String permitStatus = "";
		try {
			conAdmin = DBConnection.getConnectionToDB("AMS");
			if (status.equalsIgnoreCase("APPROVED") || status.equalsIgnoreCase("ACKNOWLEDGED")) {
				permitStatus = "INACTIVE";
			} else if (status.equalsIgnoreCase("INACTIVE")) {
				permitStatus = "APPROVED";
			}
			pstmt = conAdmin.prepareStatement(IronMiningStatement.UPDATE_STATUS_FOR_PERMIT);
			pstmt.setString(1, permitStatus);
			pstmt.setInt(2, sysId);
			pstmt.setInt(3, custId);
			pstmt.setInt(4, id);
			updated = pstmt.executeUpdate();
			if (updated > 0) {
				message = "Successfully Updated";
			}
		} catch (Exception e) {
			e.printStackTrace();
			System.out.println("Inside InactiveStatus function" + e.toString());
		} finally {
			DBConnection.releaseConnectionToDB(conAdmin, pstmt, null);
		}
		return message;
	}

	public String modifyApprovedPermits(String date, String startDate, String endDate, int id, String remarks,
			int userId, String vessel, String buyer, String grade, String permitType) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int up = 0;
		String message = "";
		float usedQty = 0;
		try {
			con = DBConnection.getConnectionToDB("AMS");
			if (permitType.equalsIgnoreCase("International Export")) {
				pstmt = con.prepareStatement(IronMiningStatement.GET_ACTUAL_QUANTITY);
				pstmt.setInt(1, id);
				rs = pstmt.executeQuery();
				if (rs.next()) {
					usedQty = rs.getFloat("ACTUAL_QUANTITY");
				}
				if (usedQty == 0) {
					pstmt = con.prepareStatement(
							IronMiningStatement.UPDATE_START_END_DATE.replaceAll("&&", ",SHIP_NAME=?,BUYER_NAME=?"));
					pstmt.setString(1, date);
					pstmt.setString(2, startDate);
					pstmt.setString(3, endDate);
					pstmt.setString(4, remarks);
					pstmt.setInt(5, userId);
					pstmt.setString(6, vessel);
					pstmt.setString(7, buyer);
					pstmt.setInt(8, id);
					up = pstmt.executeUpdate();
				} else {
					pstmt = con.prepareStatement(
							IronMiningStatement.UPDATE_START_END_DATE.replaceAll("&&", ",BUYER_NAME=?"));
					pstmt.setString(1, date);
					pstmt.setString(2, startDate);
					pstmt.setString(3, endDate);
					pstmt.setString(4, remarks);
					pstmt.setInt(5, userId);
					pstmt.setString(6, buyer);
					pstmt.setInt(7, id);
					up = pstmt.executeUpdate();
					//message="-1";
				}
			} else if (permitType.equalsIgnoreCase("Domestic Export")) {
				pstmt = con
						.prepareStatement(IronMiningStatement.UPDATE_START_END_DATE.replaceAll("&&", ",BUYER_NAME=?"));
				pstmt.setString(1, date);
				pstmt.setString(2, startDate);
				pstmt.setString(3, endDate);
				pstmt.setString(4, remarks);
				pstmt.setInt(5, userId);
				pstmt.setString(6, buyer);
				pstmt.setInt(7, id);
				up = pstmt.executeUpdate();
			} else {
				pstmt = con.prepareStatement(IronMiningStatement.UPDATE_START_END_DATE.replaceAll("&&", ""));
				pstmt.setString(1, date);
				pstmt.setString(2, startDate);
				pstmt.setString(3, endDate);
				pstmt.setString(4, remarks);
				pstmt.setInt(5, userId);
				pstmt.setInt(6, id);
				up = pstmt.executeUpdate();
			}
			if (message != "-1") {
				if (!grade.equalsIgnoreCase("") && grade != null) {
					pstmt = con.prepareStatement(IronMiningStatement.UPDATE_GRADE);
					pstmt.setString(1, grade);
					pstmt.setInt(2, id);
					pstmt.executeUpdate();
				}
			}
			if (up > 0) {
				message = String.valueOf(id);//"Updated Successfully";
			} else {
				message = "0";
			}
		} catch (Exception e) {
			System.out.println("error in :-update permit details " + e.toString());
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, null);
		}
		return message;
	}

	public ArrayList<Object> getEwalletDetails(int systemId, int custId) {
		CommonFunctions cf = new CommonFunctions();
		ArrayList<ReportHelper> reportsList = new ArrayList<ReportHelper>();
		ArrayList<String> headersList = new ArrayList<String>();
		ReportHelper finalreporthelper = new ReportHelper();
		ArrayList<Object> finlist = new ArrayList<Object>();
		JSONArray JsonArray = null;
		JSONObject JsonObject = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int count = 0;
		try {
			headersList.add("SLNO");
			headersList.add("Organization Name");
			headersList.add("Organization Code");
			headersList.add("Id");
			headersList.add("Type");
			headersList.add("Ewallet Balance");
			headersList.add("Mwallet Balance");

			JsonArray = new JSONArray();

			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(IronMiningStatement.GET_E_WALLET_DETAILS);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, custId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				count++;
				ReportHelper reporthelper = new ReportHelper();
				JsonObject = new JSONObject();
				ArrayList<Object> informationList = new ArrayList<Object>();

				JsonObject.put("slnoIndex", count);
				informationList.add(count);

				informationList.add(rs.getString("ORGANIZATION_NAME"));
				JsonObject.put("orgNameIndex", rs.getString("ORGANIZATION_NAME"));

				informationList.add(rs.getString("ORGANIZATION_CODE"));
				JsonObject.put("orgCodeIndex", rs.getString("ORGANIZATION_CODE"));

				informationList.add(rs.getString("ID"));
				JsonObject.put("orgIdIndex", rs.getString("ID"));

				informationList.add(rs.getString("TYPE"));
				JsonObject.put("TypeIndex", rs.getString("TYPE"));

				informationList.add(rs.getString("EWALLET_BALANCE"));
				JsonObject.put("eWalletIndex", rs.getString("EWALLET_BALANCE"));

				informationList.add(rs.getString("M_WALLET_BALANCE"));
				JsonObject.put("mWalletIndex", rs.getString("M_WALLET_BALANCE"));

				JsonArray.put(JsonObject);
				reporthelper.setInformationList(informationList);
				reportsList.add(reporthelper);
			}
			finalreporthelper.setReportsList(reportsList);
			finalreporthelper.setHeadersList(headersList);
			finlist.add(JsonArray);
			finlist.add(finalreporthelper);

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return finlist;
	}

	public ArrayList<Object> getMPLBalances(int systamId, int customerId) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		ArrayList<ReportHelper> reportsList = new ArrayList<ReportHelper>();
		ArrayList<String> headersList = new ArrayList<String>();
		ReportHelper finalreporthelper = new ReportHelper();
		//ArrayList < Object > list = new ArrayList < Object > ();
		ArrayList<Object> finalList = new ArrayList<Object>();
		DecimalFormat df = new DecimalFormat("##0.00");

		headersList.add("SLNO");
		headersList.add("TC Number");
		headersList.add("Lease Name");
		headersList.add("Organization");
		headersList.add("MPL Allocated");
		headersList.add("MPL Used");
		headersList.add("MPL Balance");
		JSONArray JsonArray = new JSONArray();
		JSONObject JsonObject = null;
		ReportHelper reporthelper = null;
		ArrayList<Object> informationList = null;
		try {
			int count = 0;
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(IronMiningStatement.GET_MPL_BALANCE_DETAILS);
			pstmt.setInt(1, systamId);
			pstmt.setInt(2, customerId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				JsonObject = new JSONObject();
				reporthelper = new ReportHelper();
				informationList = new ArrayList<Object>();

				count++;
				JsonObject.put("slnoIndex", count);
				informationList.add(count);

				JsonObject.put("UniqueIDIndex", rs.getString("ID"));

				JsonObject.put("tcNoIndex", rs.getString("TC_NO"));
				informationList.add(rs.getString("TC_NO"));

				JsonObject.put("leaseNameIndex", rs.getString("LESSE_NAME"));
				informationList.add(rs.getString("LESSE_NAME"));

				JsonObject.put("orgNameIndex", rs.getString("ORGANIZATION_NAME"));
				informationList.add(rs.getString("ORGANIZATION_NAME"));

				JsonObject.put("mplAllocatedIndex", df.format(rs.getDouble("MPL_ALLOCATED")));
				informationList.add(rs.getString("MPL_ALLOCATED"));

				JsonObject.put("mplUsedIndex", df.format(rs.getDouble("MPL_USED")));
				informationList.add(rs.getString("MPL_USED"));

				JsonObject.put("mplBalanceIndex", df.format(rs.getDouble("MPL_BALANCE")));
				informationList.add(rs.getString("MPL_BALANCE"));

				JsonArray.put(JsonObject);
				reporthelper.setInformationList(informationList);
				reportsList.add(reporthelper);
			}
			finalreporthelper.setReportsList(reportsList);
			finalreporthelper.setHeadersList(headersList);
			finalList.add(JsonArray);
			finalList.add(finalreporthelper);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return finalList;
	}

	public ArrayList<Object> getImportsExportsReportDetails(int systamId, int customerId) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		ArrayList<ReportHelper> reportsList = new ArrayList<ReportHelper>();
		ArrayList<String> headersList = new ArrayList<String>();
		ReportHelper finalreporthelper = new ReportHelper();
		ArrayList<Object> finalList = new ArrayList<Object>();
		DecimalFormat df = new DecimalFormat("##0.00");

		headersList.add("SLNO");
		headersList.add("ORG ID");
		headersList.add("Organization Name");
		headersList.add("Organization Code");
		headersList.add("Domestic Exp Fines");
		headersList.add("Domestic Exp Lumps");
		headersList.add("Domestic Exp Concentrates");
		headersList.add("Domestic Exp Tailings");
		headersList.add("Total Domestic Exp");
		headersList.add("Int Exp Fines");
		headersList.add("Int Exp Lumps");
		headersList.add("Int Exp Concentrates");
		headersList.add("Int Exp Tailings");
		headersList.add("Total Int Exp");
		headersList.add("Domestic Imp Fines");
		headersList.add("Domestic Imp Lumps");
		headersList.add("Domestic Imp Concentrates");
		headersList.add("Domestic Imp Tailings");
		headersList.add("Total Domestic Imp");
		headersList.add("Int Imp Fines");
		headersList.add("Int Imp Lumps");
		headersList.add("Int Imp Concentrates");
		headersList.add("Int Imp Tailings");
		headersList.add("Total Int Imp");
		JSONArray JsonArray = new JSONArray();
		JSONObject JsonObject = null;
		JSONObject jObjExp = null;
		List<JSONObject> expList = null;
		JSONObject jObjImp = null;
		List<JSONObject> impList = null;
		ReportHelper reporthelper = null;
		ArrayList<Object> informationList = null;
		ImportsExportsBean ieBean = null;
		List<ImportsExportsBean> beanList = null;
		try {
			int count = 0;
			HashSet<Integer> orgSet = new HashSet<Integer>();
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(IronMiningStatement.GET_IMPORTS_EXPORTS_DETAILS);
			pstmt.setInt(1, systamId);
			pstmt.setInt(2, customerId);
			pstmt.setInt(3, systamId);
			pstmt.setInt(4, customerId);
			rs = pstmt.executeQuery();
			expList = new ArrayList<JSONObject>();
			while (rs.next()) {
				jObjExp = new JSONObject();
				jObjExp.put("TYPE", rs.getString("TYPE"));
				jObjExp.put("QUANTITY", rs.getDouble("QUANTITY"));
				jObjExp.put("PERMIT_TYPE", rs.getString("PERMIT_TYPE"));
				jObjExp.put("ORG_CODE", rs.getInt("ORG_CODE"));
				jObjExp.put("ORGANIZATION_NAME", rs.getString("ORGANIZATION_NAME"));
				jObjExp.put("ORGANIZATION_CODE", rs.getString("ORGANIZATION_CODE"));

				expList.add(jObjExp);
				orgSet.add(rs.getInt("ORG_CODE"));
			}

			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(IronMiningStatement.GET_IMPORTS_EXPORTS_DETAILS1);
			pstmt.setInt(1, systamId);
			pstmt.setInt(2, customerId);
			pstmt.setInt(3, systamId);
			pstmt.setInt(4, customerId);
			rs = pstmt.executeQuery();
			impList = new ArrayList<JSONObject>();
			while (rs.next()) {
				jObjImp = new JSONObject();
				jObjImp.put("TYPE", rs.getString("TYPE"));
				jObjImp.put("QUANTITY", rs.getDouble("QUANTITY"));
				jObjImp.put("PERMIT_TYPE", rs.getString("IMPORT_TYPE"));
				jObjImp.put("ORG_CODE", rs.getInt("ORG_CODE"));
				jObjImp.put("ORGANIZATION_NAME", rs.getString("ORGANIZATION_NAME"));
				jObjImp.put("ORGANIZATION_CODE", rs.getString("ORGANIZATION_CODE"));

				impList.add(jObjImp);
				orgSet.add(rs.getInt("ORG_CODE"));
			}

			beanList = new ArrayList<ImportsExportsBean>();
			for (Integer orgId : orgSet) {
				ieBean = new ImportsExportsBean();

				for (JSONObject obj : expList) {
					if (obj.getInt("ORG_CODE") == orgId) {
						ieBean.setOrgId(orgId);
						ieBean.setOrgName(obj.getString("ORGANIZATION_NAME"));
						ieBean.setOrgCode(obj.getString("ORGANIZATION_CODE"));
						if (obj.getString("PERMIT_TYPE").equals("Domestic Export")) {
							if (obj.getString("TYPE").equals("Fines")) {
								ieBean.setDomExpFines(obj.getDouble("QUANTITY"));
							} else if (obj.getString("TYPE").equals("Lumps")) {
								ieBean.setDomExpLumps(obj.getDouble("QUANTITY"));
							} else if (obj.getString("TYPE").equals("Concentrates")) {
								ieBean.setDomExpConcentrates(obj.getDouble("QUANTITY"));
							} else if (obj.getString("TYPE").equals("Tailings")) {
								ieBean.setDomExpTailings(obj.getDouble("QUANTITY"));
							}
						} else if (obj.getString("PERMIT_TYPE").equals("International Export")) {
							if (obj.getString("TYPE").equals("Fines")) {
								ieBean.setIntExpFines(obj.getDouble("QUANTITY"));
							} else if (obj.getString("TYPE").equals("Lumps")) {
								ieBean.setIntExpLumps(obj.getDouble("QUANTITY"));
							} else if (obj.getString("TYPE").equals("Concentrates")) {
								ieBean.setIntExpConcentrates(obj.getDouble("QUANTITY"));
							} else if (obj.getString("TYPE").equals("Tailings")) {
								ieBean.setIntExpTailings(obj.getDouble("QUANTITY"));
							}
						}
					}
				}
				for (JSONObject obj : impList) {
					if (obj.getInt("ORG_CODE") == orgId) {
						ieBean.setOrgId(orgId);
						ieBean.setOrgName(obj.getString("ORGANIZATION_NAME"));
						ieBean.setOrgCode(obj.getString("ORGANIZATION_CODE"));
						if (obj.getString("PERMIT_TYPE").equals("Domestic Import")) {
							if (obj.getString("TYPE").equals("Fines")) {
								ieBean.setDomImpFines(obj.getDouble("QUANTITY"));
							} else if (obj.getString("TYPE").equals("Lumps")) {
								ieBean.setDomImpLumps(obj.getDouble("QUANTITY"));
							} else if (obj.getString("TYPE").equals("Concentrates")) {
								ieBean.setDomImpConcentrates(obj.getDouble("QUANTITY"));
							} else if (obj.getString("TYPE").equals("Tailings")) {
								ieBean.setDomImpTailings(obj.getDouble("QUANTITY"));
							}
						} else if (obj.getString("PERMIT_TYPE").equals("International Import")) {
							if (obj.getString("TYPE").equals("Fines")) {
								ieBean.setIntImpFines(obj.getDouble("QUANTITY"));
							} else if (obj.getString("TYPE").equals("Lumps")) {
								ieBean.setIntImpLumps(obj.getDouble("QUANTITY"));
							} else if (obj.getString("TYPE").equals("Concentrates")) {
								ieBean.setIntImpConcentrates(obj.getDouble("QUANTITY"));
							} else if (obj.getString("TYPE").equals("Tailings")) {
								ieBean.setIntImpTailings(obj.getDouble("QUANTITY"));
							}
						}
					}
				}
				beanList.add(ieBean);
			}

			for (ImportsExportsBean bean : beanList) {
				JsonObject = new JSONObject();
				reporthelper = new ReportHelper();
				informationList = new ArrayList<Object>();

				count++;
				JsonObject.put("slnoIndex", count);
				informationList.add(count);

				//JsonObject.put("UniqueIDIndex",rs.getString("ID"));
				JsonObject.put("orgIdInd", bean.getOrgId());
				informationList.add(bean.getOrgId());

				JsonObject.put("orgNameInd", bean.getOrgName());
				informationList.add(bean.getOrgName());

				JsonObject.put("orgCodeInd", bean.getOrgCode());
				informationList.add(bean.getOrgCode());

				JsonObject.put("domExpFinesInd", df.format(bean.getDomExpFines()));
				informationList.add(df.format(bean.getDomExpFines()));

				JsonObject.put("domExpLumpsInd", df.format(bean.getDomExpLumps()));
				informationList.add(df.format(bean.getDomExpLumps()));

				JsonObject.put("domExpConcInd", df.format(bean.getDomExpConcentrates()));
				informationList.add(df.format(bean.getDomExpConcentrates()));

				JsonObject.put("domExpTailingsInd", df.format(bean.getDomExpTailings()));
				informationList.add(df.format(bean.getDomExpTailings()));

				JsonObject.put("totalDomExpInd", df.format(bean.getTotalDomExp()));
				informationList.add(df.format(bean.getTotalDomExp()));

				JsonObject.put("intExpFinesInd", df.format(bean.getIntExpFines()));
				informationList.add(df.format(bean.getIntExpFines()));

				JsonObject.put("intExpLumpsInd", df.format(bean.getIntExpLumps()));
				informationList.add(df.format(bean.getIntExpLumps()));

				JsonObject.put("intExpConcInd", df.format(bean.getIntExpConcentrates()));
				informationList.add(df.format(bean.getIntExpConcentrates()));

				JsonObject.put("intExpTailingsInd", df.format(bean.getIntExpTailings()));
				informationList.add(df.format(bean.getIntExpTailings()));

				JsonObject.put("totalIntExpInd", df.format(bean.getTotalIntExp()));
				informationList.add(df.format(bean.getTotalIntExp()));

				JsonObject.put("domImpFinesInd", df.format(bean.getDomImpFines()));
				informationList.add(df.format(bean.getDomImpFines()));

				JsonObject.put("domImpLumpsInd", df.format(bean.getDomImpLumps()));
				informationList.add(df.format(bean.getDomImpLumps()));

				JsonObject.put("domImpConcInd", df.format(bean.getDomImpConcentrates()));
				informationList.add(df.format(bean.getDomImpConcentrates()));

				JsonObject.put("domImpTailingsInd", df.format(bean.getDomImpTailings()));
				informationList.add(df.format(bean.getDomImpTailings()));

				JsonObject.put("totalDomImpInd", df.format(bean.getTotalDomImp()));
				informationList.add(df.format(bean.getTotalDomImp()));

				JsonObject.put("intImpFinesInd", df.format(bean.getIntImpFines()));
				informationList.add(df.format(bean.getIntImpFines()));

				JsonObject.put("intImpLumpsInd", df.format(bean.getIntImpLumps()));
				informationList.add(df.format(bean.getIntImpLumps()));

				JsonObject.put("intImpConcInd", df.format(bean.getIntImpConcentrates()));
				informationList.add(df.format(bean.getIntImpConcentrates()));

				JsonObject.put("intImpTailingsInd", df.format(bean.getIntImpTailings()));
				informationList.add(df.format(bean.getIntImpTailings()));

				JsonObject.put("totalIntImpInd", df.format(bean.getTotalIntImp()));
				informationList.add(df.format(bean.getTotalIntImp()));

				JsonArray.put(JsonObject);
				reporthelper.setInformationList(informationList);
				reportsList.add(reporthelper);

			}

			finalreporthelper.setReportsList(reportsList);
			finalreporthelper.setHeadersList(headersList);
			finalList.add(JsonArray);
			finalList.add(finalreporthelper);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return finalList;
	}

	public String transferBargeTrip(int clientId, int systemId, String tripId, String bargeId, String tripSheetNumber,
			String remark, int userId, String quantity, String quantity1, int permitId, String bargeStatus,
			float bargeQty, float bargeCapacity, String vehicleNo, String truckTripNo) {

		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String message = "";
		LogWriter logWriter = null;
		int uniqueId = 0;
		PreparedStatement pstmtU = null;
		float actualQuantity = Float.parseFloat(quantity) - Float.parseFloat(quantity1);
		String permittype = "";
		String gradetype = "";
		int tcId = 0;
		int orgId = 0;
		int buyingOrgId = 0;
		int routeId = 0;
		String mineraltype = "";
		float AvailableBargeQty = 0;
		int tripSheetNo = 0;
		String tripStatus = "";
		String destType = "";
		String srcType = "";
		try {
			con = DBConnection.getConnectionToDB("AMS");
			Properties properties = ApplicationListener.prop;
			String logFile = properties.getProperty("LogFileForBargeTripTransfer");
			String logFileName = logFile.substring(0, logFile.lastIndexOf("."));
			String logFileExt = logFile.substring(logFile.lastIndexOf(".") + 1, logFile.length());
			logFile = logFileName + "-" + sdf.format(new Date()) + "." + logFileExt;

			PrintWriter pw;

			if (logFile != null) {
				try {
					pw = new PrintWriter(new FileWriter(logFile, true), true);
					logWriter = new LogWriter("transferBargeTrip", LogWriter.INFO, pw);
					;
					logWriter.setPrintWriter(pw);
				} catch (IOException e) {
					logWriter.log("Can't open the log file: " + logFile + ". Using System.err instead",
							LogWriter.ERROR);
				}
			}
			logWriter.log(" Begining of the method ", LogWriter.INFO);

			pstmt = con.prepareStatement(IronMiningStatement.GET_PERMIT_DETAILSS);
			pstmt.setString(1, tripId);
			pstmt.setString(2, tripId);
			pstmt.setInt(3, systemId);
			pstmt.setInt(4, permitId);
			pstmt.setInt(5, clientId);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				permittype = rs.getString("PERMIT_TYPE");
				gradetype = rs.getString("TYPE");
				tcId = rs.getInt("TC_ID");
				orgId = rs.getInt("ORG_ID");
				buyingOrgId = rs.getInt("BUYING_ORG_ID");
				routeId = rs.getInt("ROUTE_ID");
				mineraltype = rs.getString("MINERAL");
				tripStatus = rs.getString("TRIP_STATUS");
				destType = rs.getString("DEST_TYPE");
				srcType = rs.getString("DEST_TYPE");
			}
			logWriter.log(" PERMIT TYPE == " + permittype + "GRADE TYPE == " + gradetype + "TC ID == " + tcId
					+ "ORG ID == " + orgId + "BUYING ORG ID== " + buyingOrgId + " ROUTE ID == " + routeId
					+ " MINERAL TYPE == " + mineraltype + " TRIP STATUS == " + tripStatus, LogWriter.INFO);
			if (tripStatus.equalsIgnoreCase("OPEN")) {
				float actualqtyintons = actualQuantity / 1000;
				AvailableBargeQty = bargeCapacity - (bargeQty / 1000);
				if (AvailableBargeQty >= actualqtyintons) {
					if (bargeStatus.equals("OPEN")) {
						util.updateBargeStatusAndRouteToTripDetails(clientId, systemId, Integer.parseInt(bargeId), con,
								String.valueOf(routeId));
						logWriter.log(" barge status and route Updated", LogWriter.INFO);
					}
					String[] tripNo = truckTripNo.split("-");
					tripSheetNo = Integer.parseInt(tripNo[1]);

					// ----leading Zeros handling----------------------//
					String tripSheetNotoGrid = "";
					if (String.valueOf(tripSheetNo).length() <= 5) {
						tripSheetNotoGrid = ("00000" + tripSheetNo).substring(String.valueOf(tripSheetNo).length());
					} else {
						tripSheetNotoGrid = ("000000000" + tripSheetNo).substring(String.valueOf(tripSheetNo).length());
					}
					pstmt = con.prepareStatement(IronMiningStatement.INSERT_BARGE_TRUCK_TRIPSHEET_DETAILS,
							PreparedStatement.RETURN_GENERATED_KEYS);
					pstmt.setString(1, tripSheetNumber + "-" + tripSheetNotoGrid);
					pstmt.setString(2, bargeId);
					pstmt.setString(3, remark);
					pstmt.setString(4, "Trip Transfer");
					pstmt.setInt(5, systemId);
					pstmt.setInt(6, clientId);
					pstmt.setString(7, tripId);
					pstmt.executeUpdate();
					rs = pstmt.getGeneratedKeys();
					logWriter.log(" Record inserted successfully", LogWriter.INFO);
					if (rs.next()) {
						uniqueId = rs.getInt(1);
					}
					if (uniqueId > 0) {

						logWriter.log(" BEFORE UPDATE BARGE QUANTITY == " + (bargeQty), LogWriter.INFO);
						util.updateBargeQuantityToTripDetails(clientId, systemId, actualQuantity,
								Integer.parseInt(bargeId), con);

						logWriter.log(" AFTER UPDATE BARGE QUANTITY == " + (bargeQty + actualQuantity), LogWriter.INFO);

						pstmt = con.prepareStatement(IronMiningStatement.UPDATE_TRIP_STATUS);
						pstmt.setString(1, tripId);
						pstmt.executeUpdate();
						logWriter.log(" Trip status Updated ", LogWriter.INFO);

						pstmt = con.prepareStatement(IronMiningStatement.UPDATE_TRIP_STATUS_IN_ASSET_ENROLMENT);
						pstmt.setString(1, "CLOSE");
						pstmt.setString(2, vehicleNo);
						pstmt.setInt(3, systemId);
						pstmt.setInt(4, clientId);
						pstmt.executeUpdate();
						logWriter.log(" Trip Status updated in asset enrolment ", LogWriter.INFO);

						if (permittype.equalsIgnoreCase("Import Transit Permit")) {
							logWriter.log(" Inside Import updation method", LogWriter.INFO);
							float impFines = 0;
							float impLumps = 0;
							float impConc = 0;
							float impTailings = 0;
							actualQuantity = actualQuantity / 1000;
							if ((gradetype.toUpperCase()).contains("FINE")) {
								impFines = actualQuantity;
							} else if ((gradetype.toUpperCase()).contains("LUMP")) {
								impLumps = actualQuantity;
							} else if ((gradetype.toUpperCase()).contains("CONCENTRATES")) {
								impConc = actualQuantity;
							} else if ((gradetype.toUpperCase()).contains("TAILINGS")) {
								impTailings = actualQuantity;
							}
							logWriter.log(
									"Imported fines== " + impFines + " imported Lumps== " + impLumps
											+ " imported Conc== " + impConc + " imported Tailings== " + impTailings,
									LogWriter.INFO);
							pstmt = con.prepareStatement(IronMiningStatement.UPDATE_IMPORT_QTY_IN_ORG_MASTER);
							pstmt.setFloat(1, impFines);
							pstmt.setFloat(2, impLumps);
							pstmt.setFloat(3, impConc);
							pstmt.setFloat(4, impTailings);
							pstmt.setInt(5, orgId);
							pstmt.executeUpdate();
						}
						int destinationhub = 0;
						if (permittype.equalsIgnoreCase("Processed Ore Transit")
								|| permittype.equalsIgnoreCase("Bauxite Transit")
								|| permittype.equalsIgnoreCase("Processed Ore Sale Transit")
								|| permittype.equalsIgnoreCase("Rom Transit")
								|| permittype.equalsIgnoreCase("Purchased Rom Sale Transit Permit")) {

							logWriter.log(" Inside stock updation method", LogWriter.INFO);

							pstmt = con.prepareStatement(IronMiningStatement.GET_DESTINATION_FROM_ROUTE);
							pstmt.setInt(1, systemId);
							pstmt.setInt(2, clientId);
							pstmt.setInt(3, routeId);
							rs = pstmt.executeQuery();
							if (rs.next()) {
								destinationhub = rs.getInt("End_Hubid");
							}
						}
						if (destinationhub > 0) {
							if ((permittype.equalsIgnoreCase("Bauxite Transit")
									|| (permittype.equalsIgnoreCase("Rom Transit")
											&& srcType.equalsIgnoreCase("E-Wallet")))
									&& orgId == 0) {
								pstmt = null;
								pstmt = con.prepareStatement(IronMiningStatement.GET_ORG_NO_BASED_ON_TCNO);
								pstmt.setInt(1, systemId);
								pstmt.setInt(2, clientId);
								pstmt.setInt(3, tcId);
								rs = pstmt.executeQuery();
								if (rs.next()) {
									orgId = rs.getInt("ORG_ID");
								}
							}
							if (permittype.equalsIgnoreCase("Processed Ore Sale Transit")) {
								orgId = buyingOrgId;
							}
							if (permittype.equalsIgnoreCase("Rom Transit")
									|| permittype.equalsIgnoreCase("Purchased Rom Sale Transit Permit")) {
								if (destType.equalsIgnoreCase("plant") || permittype.equalsIgnoreCase("Rom Transit")) {
									int plantId = 0;
									pstmt = null;
									pstmt = con.prepareStatement(IronMiningStatement.GET_PLANT_NAMES
											.concat("and HUB_ID=? and MINERAL_TYPE=?"));
									pstmt.setInt(1, systemId);
									pstmt.setInt(2, clientId);
									pstmt.setInt(3, orgId);
									pstmt.setInt(4, destinationhub);
									pstmt.setString(5, mineraltype);
									rs = pstmt.executeQuery();
									if (rs.next()) {
										plantId = rs.getInt("ID");
									}
									pstmt = con.prepareStatement(IronMiningStatement.UPDATE_ROM_QTY_IN_PLANT_MASTER);
									pstmt.setFloat(1, actualQuantity / 1000);
									pstmt.setInt(2, plantId);
									pstmt.setInt(3, systemId);
									pstmt.setInt(4, clientId);
									pstmt.setString(5, mineraltype);
									pstmt.executeUpdate();
								}
								if (destType.equalsIgnoreCase("stock")) {
									pstmt = null;
									pstmt = con.prepareStatement(IronMiningStatement.GET_STOCK_DETAILS,
											ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
									pstmt.setInt(1, systemId);
									pstmt.setInt(2, clientId);
									pstmt.setInt(3, destinationhub);
									pstmt.setInt(4, orgId);
									pstmt.setString(5, mineraltype);
									rs = pstmt.executeQuery();
									if (rs.next()) {
										rs.updateFloat("ROM_QTY", rs.getFloat("ROM_QTY") + actualQuantity / 1000);
										rs.updateRow();
										logWriter.log("Record updated in stock master for purchased rom sale transit",
												LogWriter.INFO);
									} else {
										pstmt = con.prepareStatement(
												IronMiningStatement.INSERT_INTO_STOCK_DEATILS_FOR_ROM);
										pstmt.setInt(1, destinationhub);
										pstmt.setInt(2, orgId);
										pstmt.setFloat(3, actualQuantity / 1000);
										pstmt.setInt(4, systemId);
										pstmt.setInt(5, clientId);
										pstmt.setString(6, mineraltype);
										pstmt.executeUpdate();
										logWriter.log("Record inserted in stock master for purchased rom sale transit",
												LogWriter.INFO);
									}
								}
							}
							if (permittype.equalsIgnoreCase("Processed Ore Transit")
									|| permittype.equalsIgnoreCase("Bauxite Transit")
									|| permittype.equalsIgnoreCase("Processed Ore Sale Transit")) {
								float fines = 0;
								float lumps = 0;
								float totalqty = 0;
								float concentrates = 0;
								float tailings = 0;
								if ((gradetype.toUpperCase()).contains("FINE")) {
									fines = actualQuantity / 1000;
								} else if ((gradetype.toUpperCase()).contains("LUMP")) {
									lumps = actualQuantity / 1000;
								} else if ((gradetype.toUpperCase()).contains("CONCENTRATES")) {
									concentrates = actualQuantity / 1000;
								} else if ((gradetype.toUpperCase()).contains("TAILINGS")) {
									tailings = actualQuantity / 1000;
								} else {
									totalqty = actualQuantity / 1000;
								}
								logWriter.log(" Before stock updation fines== " + fines + " Lumps== " + lumps
										+ " totalqty== " + totalqty + " orgCode == " + orgId + " mineraltype== "
										+ mineraltype + "destinationhub== " + destinationhub, LogWriter.INFO);
								pstmt = null;
								pstmt = con.prepareStatement(IronMiningStatement.GET_STOCK_DETAILS,
										ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
								pstmt.setInt(1, systemId);
								pstmt.setInt(2, clientId);
								pstmt.setInt(3, destinationhub);
								pstmt.setInt(4, orgId);
								pstmt.setString(5, mineraltype);
								rs = pstmt.executeQuery();
								if (rs.next()) {
									rs.updateFloat("FINES", rs.getFloat("FINES") + fines);
									rs.updateFloat("LUMPS", rs.getFloat("LUMPS") + lumps);
									rs.updateFloat("CONCENTRATES", rs.getFloat("CONCENTRATES") + concentrates);
									rs.updateFloat("TAILINGS", rs.getFloat("TAILINGS") + tailings);
									rs.updateFloat("TOTAL_QTY", rs.getFloat("TOTAL_QTY") + totalqty);
									rs.updateRow();//
									logWriter.log("Record updated in stock master", LogWriter.INFO);
								} else {
									util.insertIntoStockYardMaster(clientId, systemId, con, mineraltype, orgId,
											destinationhub, fines, lumps, concentrates, tailings, totalqty);
									logWriter.log("Record inserted in stock master", LogWriter.INFO);
								}
							}
						}
						logWriter.log("Barge Trip Transfer details saved successfully", LogWriter.INFO);
						message = "Trip sheet details saved successfully";
					} else {
						logWriter.log("Error in Saving Trip Sheet Details", LogWriter.INFO);
						message = "Error in Saving Trip Sheet Details";
					}
				} else {
					logWriter.log("Permit Balance is over or Barge Qty is over.", LogWriter.INFO);
					message = "Permit Balance is over or Barge Qty is over.";
				}
			} else {
				logWriter.log("Can not transfer trip", LogWriter.INFO);
				message = "Trip is already Transferred";
			}
		} catch (Exception e) {
			System.out.println("Error in Trip Sheet Details :-save Trip Sheet Details" + e.toString());
			StringWriter errors = new StringWriter();
			e.printStackTrace(new PrintWriter(errors));
			logWriter.log(errors.toString(), LogWriter.ERROR);
			e.printStackTrace();
			if (con != null) {
				try {
					pstmt = con.prepareStatement(
							"insert into AMS.dbo.EmailQueue(Subject,Body,EmailList,SystemId) values (?,?,?,?)");
					pstmt.setString(1, "error in bargeTripTransfer for SystemId " + systemId);
					pstmt.setString(2, errors.toString());
					pstmt.setString(3,
							"gayatri.p@telematics4u.com,praveen.c@telematics4u.com,namrata.d@telematics4u.com");
					pstmt.setInt(4, systemId);
					pstmt.executeUpdate();
					logWriter.log("Record inserted in EmailQueue", LogWriter.INFO);
				} catch (SQLException e1) {
					errors = new StringWriter();
					e1.printStackTrace(new PrintWriter(errors));
					logWriter.log(errors.toString(), LogWriter.ERROR);
					e1.printStackTrace();
				}
			}
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return message;
	}

	public JSONArray getBargeTripNo(String clientId, int systemId, int userid) {
		JSONArray JsonArray = new JSONArray();
		JSONObject JsonObject = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			JsonArray = new JSONArray();
			JsonObject = new JSONObject();
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(IronMiningStatement.GET_BARGE_TRIP_NO);
			pstmt.setInt(1, systemId);
			pstmt.setString(2, clientId);
			pstmt.setInt(3, userid);
			pstmt.setInt(4, systemId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				JsonObject = new JSONObject();
				JsonObject.put("id", rs.getString("ID"));
				JsonObject.put("tripNo", rs.getString("TRIP_NO"));
				JsonObject.put("bargeStatus", rs.getString("STATUS"));
				JsonObject.put("bargeQty", rs.getString("BARGEQUANTITY"));
				JsonObject.put("bargeCapacity", rs.getString("LoadCapacity"));
				JsonObject.put("assetNo", rs.getString("ASSET_NUMBER"));
				JsonArray.put(JsonObject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}

		return JsonArray;
	}

	public JSONArray getTCNumberforTripFeed(int customerId, int systemId, int userId) {
		JSONArray JsonArray = null;
		JSONObject JsonObject = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			JsonArray = new JSONArray();
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(IronMiningStatement.GET_TC_NUMBER_FOR_TRIP_FEED);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, customerId);
			pstmt.setString(3, "ROM");
			pstmt.setInt(4, userId);
			pstmt.setInt(5, systemId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				JsonObject = new JSONObject();
				JsonObject.put("TCno", rs.getString("TC_NO"));
				JsonObject.put("TCID", rs.getInt("ID"));
				JsonObject.put("orgName", rs.getString("ORGANIZATION_NAME"));
				JsonObject.put("orgId", rs.getString("ORG_ID"));
				JsonArray.put(JsonObject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return JsonArray;
	}

	public JSONArray getPermitNumberForTripFeed(int customerId, int systemId, int tcId, int userId, int orgId,
			String permitType) {
		JSONArray JsonArray = null;
		JSONObject JsonObject = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		PreparedStatement pstmtop = null;
		ResultSet rs1 = null;
		String permitNo = "";
		try {
			JsonArray = new JSONArray();
			con = DBConnection.getConnectionToDB("AMS");
			pstmtop = con.prepareStatement(IronMiningStatement.GET_PERMIT_NO);
			pstmtop.setInt(1, systemId);
			pstmtop.setInt(2, customerId);
			pstmtop.setInt(3, userId);
			rs1 = pstmtop.executeQuery();
			while (rs1.next()) {
				JsonObject = new JSONObject();
				permitNo = rs1.getString("PERMIT_IDS");
			}
			if (!permitNo.equals("")) {
				if (permitType.equalsIgnoreCase("Rom Transit")) {
					pstmt = con.prepareStatement(IronMiningStatement.GET_RTP_PERMITS.replaceAll("#", permitNo)
							.replaceAll("&&", "and (mpd.ORGANIZATION_CODE=" + orgId
									+ " or mpd.TC_ID in (select a.ID from AMS.dbo.MINING_TC_MASTER a "
									+ " left outer join AMS.dbo.MINING_MINE_MASTER c on c.ID=a.MINE_ID and c.SYSTEM_ID=a.SYSTEM_ID and c.CUSTOMER_ID=a.CUSTOMER_ID  "
									+ " where c.ORG_ID=" + orgId + "))"));
					pstmt.setInt(1, systemId);
					pstmt.setInt(2, customerId);
					pstmt.setString(3, permitType);
				} else {
					pstmt = con.prepareStatement(IronMiningStatement.GET_RTP_PERMITS.replaceAll("#", permitNo)
							.replaceAll("&&", " and mpd.DEST_TYPE='Plant' and mpd.ORGANIZATION_CODE=" + orgId));
					pstmt.setInt(1, systemId);
					pstmt.setInt(2, customerId);
					pstmt.setString(3, "Purchased Rom Sale Transit Permit");
				}
				rs = pstmt.executeQuery();
				float permitBal = 0;
				while (rs.next()) {
					JsonObject = new JSONObject();
					JsonObject.put("PermitId", rs.getString("ID"));
					JsonObject.put("PermitNo", rs.getString("PERMIT_NO"));
					JsonObject.put("permitQty", rs.getFloat("PERMIT_QUANTITY"));
					JsonObject.put("usedQty", rs.getFloat("USED_QTY"));
					permitBal = rs.getFloat("PERMIT_QUANTITY") - rs.getFloat("USED_QTY");
					JsonObject.put("permitBalance", permitBal);
					JsonObject.put("destHubId", rs.getString("DESTINATION"));
					JsonObject.put("mineralType", rs.getString("MINERAL"));
					JsonArray.put(JsonObject);
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(null, pstmtop, rs1);
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return JsonArray;
	}

	public JSONArray getPermitNumberForSelfConsumption(int customerId, int systemId, int tcId, int userId, int orgId,
			String permitType) {
		JSONArray JsonArray = null;
		JSONObject JsonObject = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		PreparedStatement pstmtop = null;
		ResultSet rs1 = null;
		String permitNo = "";
		try {
			JsonArray = new JSONArray();
			con = DBConnection.getConnectionToDB("AMS");
			pstmtop = con.prepareStatement(IronMiningStatement.GET_PERMIT_NO);
			pstmtop.setInt(1, systemId);
			pstmtop.setInt(2, customerId);
			pstmtop.setInt(3, userId);
			rs1 = pstmtop.executeQuery();
			while (rs1.next()) {
				JsonObject = new JSONObject();
				permitNo = rs1.getString("PERMIT_IDS");
			}
			if (!permitNo.equals("")) {
				if (permitType.equalsIgnoreCase("Rom Transit")) {
					pstmt = con.prepareStatement(IronMiningStatement.GET_RTP_PERMITS.replaceAll("#", permitNo)
							.replaceAll("&&", "and (mpd.ORGANIZATION_CODE=" + orgId
									+ " or mpd.TC_ID in (select a.ID from AMS.dbo.MINING_TC_MASTER a "
									+ " left outer join AMS.dbo.MINING_MINE_MASTER c on c.ID=a.MINE_ID and c.SYSTEM_ID=a.SYSTEM_ID and c.CUSTOMER_ID=a.CUSTOMER_ID  "
									+ " where c.ORG_ID=" + orgId + "))"));
					pstmt.setInt(1, systemId);
					pstmt.setInt(2, customerId);
					pstmt.setString(3, permitType);
					rs = pstmt.executeQuery();
				} else if (permitType.equalsIgnoreCase("Purchased ROM Sale Transit Permit")
						|| permitType.equalsIgnoreCase("Processed Ore Transit")
						|| permitType.equalsIgnoreCase("Processed Ore Sale Transit")
						|| permitType.equalsIgnoreCase("Domestic Export")
						|| permitType.equalsIgnoreCase("International Export")
						|| permitType.equalsIgnoreCase("Import Transit Permit")) {
					pstmt = con.prepareStatement(
							IronMiningStatement.GET_RTP_PERMITS.replaceAll("#", permitNo).replaceAll("&&", ""));
					pstmt.setInt(1, systemId);
					pstmt.setInt(2, customerId);
					pstmt.setString(3, permitType);
					rs = pstmt.executeQuery();
				}

				float permitBal = 0;
				while (rs.next()) {
					JsonObject = new JSONObject();
					JsonObject.put("PermitId", rs.getString("ID"));
					JsonObject.put("PermitNo", rs.getString("PERMIT_NO"));
					JsonObject.put("permitQty", rs.getFloat("PERMIT_QUANTITY"));
					JsonObject.put("usedQty", rs.getFloat("USED_QTY"));
					permitBal = rs.getFloat("PERMIT_QUANTITY") - rs.getFloat("USED_QTY");
					JsonObject.put("permitBalance", permitBal);
					JsonObject.put("destHubId", rs.getString("DESTINATION"));
					JsonObject.put("mineralType", rs.getString("MINERAL"));
					JsonArray.put(JsonObject);
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(null, pstmtop, rs1);
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return JsonArray;
	}

	public JSONArray getPlantNames(int customerId, int systemId, int orgId, int destHubId, String mineral) {
		JSONArray JsonArray = null;
		JSONObject JsonObject = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			JsonArray = new JSONArray();
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(IronMiningStatement.GET_PLANT_NAMES.concat("and HUB_ID=? and MINERAL_TYPE=?"));
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, customerId);
			pstmt.setInt(3, orgId);
			pstmt.setInt(4, destHubId);
			pstmt.setString(5, mineral);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				JsonObject = new JSONObject();
				JsonObject.put("plantName", rs.getString("PLANT_NAME"));
				JsonObject.put("plantId", rs.getString("ID"));
				JsonArray.put(JsonObject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return JsonArray;
	}

	public String addTripFeedDetails(int customerId, int systemId, int tcId, int orgId, int permitId, int plantId,
			float ROMQuantity, int userId, String vehicleNo) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String message = "";
		int inserted = 0;
		float permitUsedQty = 0;
		float permitQty = 0;
		String mineralType = "";
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(IronMiningStatement.GET_ACTUAL_PERMIT_QTY);
			pstmt.setInt(1, permitId);
			pstmt.setInt(2, systemId);
			pstmt.setInt(3, customerId);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				permitUsedQty = rs.getFloat("TRIPSHEET_QTY");
				permitQty = rs.getFloat("PERMIT_QUANTITY");
				mineralType = rs.getString("MINERAL");
			}
			float actualPermitBal = permitQty - permitUsedQty;
			//float ROMQuantityinTons=ROMQuantity/1000;
			if (actualPermitBal >= ROMQuantity) {
				pstmt = con.prepareStatement(IronMiningStatement.SAVE_TRIP_FEED_DETAILS);
				pstmt.setInt(1, tcId);
				pstmt.setInt(2, orgId);
				pstmt.setInt(3, permitId);
				pstmt.setInt(4, 0);
				pstmt.setFloat(5, ROMQuantity);
				pstmt.setInt(6, plantId);
				pstmt.setInt(7, systemId);
				pstmt.setInt(8, customerId);
				pstmt.setInt(9, userId);
				pstmt.setString(10, vehicleNo);
				inserted = pstmt.executeUpdate();
				if (inserted > 0) {
					message = "Trip feed details saved successfully";
					pstmt = con.prepareStatement(IronMiningStatement.UPDATE_TRIPSHEET_QTY_FOR_RTP);
					pstmt.setFloat(1, ROMQuantity * 1000);
					pstmt.setInt(2, permitId);
					pstmt.executeUpdate();

					pstmt = con.prepareStatement(IronMiningStatement.UPDATE_ROM_QTY_IN_PLANT_MASTER);
					pstmt.setFloat(1, ROMQuantity);
					pstmt.setInt(2, plantId);
					pstmt.setInt(3, systemId);
					pstmt.setInt(4, customerId);
					pstmt.setString(5, mineralType);
					pstmt.executeUpdate();
				} else {
					message = "Error while saving Trip feed details";
				}
			} else {
				message = "Permit Balance is over. Please change permit";
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}

		return message;
	}

	public ArrayList<Object> getTripFeedDetails(int customerId, int systemId, int userId) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		ArrayList<ReportHelper> reportsList = new ArrayList<ReportHelper>();
		ArrayList<String> headersList = new ArrayList<String>();
		ReportHelper finalreporthelper = new ReportHelper();
		ArrayList<Object> finalList = new ArrayList<Object>();
		DecimalFormat df = new DecimalFormat("##0.00");
		SimpleDateFormat diffddMMyyyyHHmmss = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");

		headersList.add("SLNO");
		headersList.add("TC No");
		headersList.add("Organisation Name");
		headersList.add("Permit No");
		headersList.add("Challlan No");
		headersList.add("Plant Name");
		headersList.add("Quantity");
		headersList.add("Vehicle No");
		headersList.add("Issued Date");
		headersList.add("Status");
		headersList.add("Remarks");

		JSONArray JsonArray = new JSONArray();
		JSONObject JsonObject = null;
		ReportHelper reporthelper = null;
		ArrayList<Object> informationList = null;
		try {
			int count = 0;
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(IronMiningStatement.GET_TRIP_FEED_DETAILS);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, customerId);
			pstmt.setInt(3, userId);
			pstmt.setInt(4, systemId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				JsonObject = new JSONObject();
				reporthelper = new ReportHelper();
				informationList = new ArrayList<Object>();

				count++;
				JsonObject.put("slnoIndex", count);
				informationList.add(count);

				JsonObject.put("tcNoIndex", rs.getString("TC_NO"));
				informationList.add(rs.getString("TC_NO"));

				JsonObject.put("organizationNameIndex", rs.getString("ORGANIZATION_NAME"));
				informationList.add(rs.getString("ORGANIZATION_NAME"));

				JsonObject.put("permitNoIndex", rs.getString("PERMIT_NO"));
				informationList.add(rs.getString("PERMIT_NO"));

				JsonObject.put("challanNoIndex", rs.getString("CHALLAN_NO"));
				informationList.add(rs.getString("CHALLAN_NO"));

				JsonObject.put("plantNameIndex", rs.getString("PLANT_NAME"));
				informationList.add(rs.getString("PLANT_NAME"));

				JsonObject.put("quantityIndex", df.format(rs.getDouble("QUANTITY")));
				informationList.add(rs.getString("QUANTITY"));

				JsonObject.put("vehicleNoIndex", rs.getString("VEHICLE_NO"));
				informationList.add(rs.getString("VEHICLE_NO"));

				if (rs.getTimestamp("INSERTED_DATETIME") == null || rs.getString("INSERTED_DATETIME").equals("")
						|| rs.getString("INSERTED_DATETIME").contains("1900")) {
					JsonObject.put("issuedDateIndex", "");
					informationList.add("");
				} else {
					JsonObject.put("issuedDateIndex", diffddMMyyyyHHmmss.format(rs.getTimestamp("INSERTED_DATETIME")));
					informationList.add(diffddMMyyyyHHmmss.format(rs.getTimestamp("INSERTED_DATETIME")));
				}

				JsonObject.put("statusIndex", rs.getString("STATUS"));
				informationList.add(rs.getString("STATUS"));

				JsonObject.put("remarksIndex", rs.getString("REMARKS"));
				informationList.add(rs.getString("REMARKS"));

				JsonObject.put("plantIdIndex", rs.getInt("PLANT_ID"));
				JsonObject.put("permitIdIndex", rs.getInt("PERMIT_ID"));
				JsonObject.put("idIndex", rs.getInt("ID"));

				JsonArray.put(JsonObject);
				reporthelper.setInformationList(informationList);
				reportsList.add(reporthelper);
			}
			finalreporthelper.setReportsList(reportsList);
			finalreporthelper.setHeadersList(headersList);
			finalList.add(JsonArray);
			finalList.add(finalreporthelper);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return finalList;
	}

	public String saveImportDetailsForRTP(JSONArray json, int customerId, int systemId, int userId) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String message = "";
		int inserted = 0;
		float permitUsedQty = 0;
		float permitQty = 0;
		String mineralType = "";
		try {
			con = DBConnection.getConnectionToDB("AMS");
			for (int i = 0; i < json.length(); i++) {
				JSONObject obj = json.getJSONObject(i);
				if (obj.getString("importValidStatusIndex").equalsIgnoreCase("Valid")) {
					pstmt = con.prepareStatement(IronMiningStatement.GET_ACTUAL_PERMIT_QTY);
					pstmt.setInt(1, Integer.parseInt(obj.getString("importpermitIdIndex")));
					pstmt.setInt(2, systemId);
					pstmt.setInt(3, customerId);
					rs = pstmt.executeQuery();
					if (rs.next()) {
						permitUsedQty = rs.getFloat("TRIPSHEET_QTY");
						permitQty = rs.getFloat("PERMIT_QUANTITY");
						mineralType = rs.getString("MINERAL");
					}
					float actualPermitBal = permitQty - permitUsedQty;
					//float ROMQuantityinTons=Float.parseFloat(obj.getString("importQuantityIndex"))/1000;
					if (actualPermitBal >= Float.parseFloat(obj.getString("importQuantityIndex"))) {
						pstmt = con.prepareStatement(IronMiningStatement.SAVE_TRIP_FEED_DETAILS);
						pstmt.setInt(1, 0);
						pstmt.setInt(2, Integer.parseInt(obj.getString("importOrgIdIndex")));
						pstmt.setInt(3, Integer.parseInt(obj.getString("importpermitIdIndex")));
						pstmt.setInt(4, 0);
						pstmt.setFloat(5, Float.parseFloat(obj.getString("importQuantityIndex")));
						pstmt.setInt(6, Integer.parseInt(obj.getString("importplantIdIndex")));
						pstmt.setInt(7, systemId);
						pstmt.setInt(8, customerId);
						pstmt.setInt(9, userId);
						pstmt.setString(10, obj.getString("importVehicleNoIndex"));
						inserted = pstmt.executeUpdate();
						if (inserted > 0) {
							message = "Trip feed details saved successfully";
							pstmt = con.prepareStatement(IronMiningStatement.UPDATE_TRIPSHEET_QTY_FOR_RTP);
							pstmt.setFloat(1, Float.parseFloat(obj.getString("importQuantityIndex")) * 1000);
							pstmt.setInt(2, Integer.parseInt(obj.getString("importpermitIdIndex")));
							pstmt.executeUpdate();

							pstmt = con.prepareStatement(IronMiningStatement.UPDATE_ROM_QTY_IN_PLANT_MASTER);
							pstmt.setFloat(1, Float.parseFloat(obj.getString("importQuantityIndex")));
							pstmt.setInt(2, Integer.parseInt(obj.getString("importplantIdIndex")));
							pstmt.setInt(3, systemId);
							pstmt.setInt(4, customerId);
							pstmt.setString(5, mineralType);
							pstmt.executeUpdate();
						} else {
							message = "Error while saving Trip feed details";
						}
					} else {
						message = "Permit Balance is over. Please change permit";
					}
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}

		return message;
	}

	public JSONArray getOrgNameforTripFeed(int customerId, int systemId, int userId, String type) {
		JSONArray JsonArray = null;
		JSONObject JsonObject = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			JsonArray = new JSONArray();
			con = DBConnection.getConnectionToDB("AMS");
			//if(type.equals("Purchased Rom Sale Transit Permit") || type.equals("Rom Transit")){
			pstmt = con.prepareStatement(IronMiningStatement.GET_ORGANIZATION_NAME);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, customerId);
			pstmt.setInt(3, userId);
			pstmt.setInt(4, systemId);
			rs = pstmt.executeQuery();
			//  }else{
			//		        pstmt = con.prepareStatement(IronMiningStatement.GET_ORG_NAME_FOR_TF.replace("and WALLET_LINK=? and PROCESSING_PLANT='yes'", ""));
			//		        pstmt.setInt(1, systemId);
			//		        pstmt.setInt(2,customerId);
			//		        pstmt.setInt(3, userId);
			//		        pstmt.setInt(4, systemId);
			//		        rs = pstmt.executeQuery();
			//}
			while (rs.next()) {
				JsonObject = new JSONObject();
				JsonObject.put("orgName", rs.getString("ORGANIZATION_NAME"));
				JsonObject.put("orgId", rs.getString("ID"));
				JsonObject.put("orgCode", rs.getString("ORGANIZATION_CODE"));
				JsonArray.put(JsonObject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return JsonArray;
	}

	public JSONArray getChallanNumber(int customerId, int systemId, int orgId) {
		JSONArray JsonArray = null;
		JSONObject JsonObject = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			JsonArray = new JSONArray();
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(IronMiningStatement.GET_CHALLAN_NUMBER_FOR_P_TRIP);//and WALLET_LINK='PROCESSED ORE' and PROCESSING_PLANT='yes'
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, customerId);
			pstmt.setInt(3, orgId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				JsonObject = new JSONObject();
				JsonObject.put("challanId", rs.getString("ID"));
				JsonObject.put("challanNo", rs.getString("CHALLAN_NO"));
				JsonObject.put("challanBalance", rs.getFloat("QUANTITY") - rs.getFloat("USED_QTY"));
				JsonObject.put("challanQty", rs.getString("QUANTITY"));
				if (rs.getString("MINERAL_TYPE").equalsIgnoreCase("IRON ORE")) {
					JsonObject.put("mineral", "Iron Ore");
				} else if (rs.getString("MINERAL_TYPE").equalsIgnoreCase("IRON ORE(E-AUCTION)")) {
					JsonObject.put("mineral", "Iron Ore(E-Auction)");
				}
				JsonObject.put("ctoDate", rs.getString("CTO_DATE"));
				JsonArray.put(JsonObject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return JsonArray;
	}

	public JSONArray getPlantNamesForCha(int customerId, int systemId, int orgId, String mineral) {
		JSONArray JsonArray = null;
		JSONObject JsonObject = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			JsonArray = new JSONArray();
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(IronMiningStatement.GET_PLANT_NAMES.concat("and MINERAL_TYPE=?"));
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, customerId);
			pstmt.setInt(3, orgId);
			pstmt.setString(4, mineral);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				JsonObject = new JSONObject();
				JsonObject.put("plantName", rs.getString("PLANT_NAME"));
				JsonObject.put("plantId", rs.getString("ID"));
				JsonArray.put(JsonObject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return JsonArray;
	}

	public String addChallanTripDetails(int customerId, int systemId, int orgId, int challanId, int plantId,
			float quantity, int userId, String vehicleNo, String mineral) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String message = "";
		int inserted = 0;
		float challanUsedQty = 0;
		float challanQty = 0;
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(IronMiningStatement.GET_CHALLAN_USED_QTY);
			pstmt.setInt(1, challanId);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				challanUsedQty = rs.getFloat("USED_QTY");
				challanQty = rs.getFloat("CHALLAN_QTY");
			}
			float actualchallanBal = challanQty - challanUsedQty;
			//float challanQuantityinTons = quantity / 1000;
			if (actualchallanBal >= quantity) {
				pstmt = con.prepareStatement(IronMiningStatement.SAVE_TRIP_FEED_DETAILS);
				pstmt.setInt(1, 0);
				pstmt.setInt(2, orgId);
				pstmt.setInt(3, 0);
				pstmt.setInt(4, challanId);
				pstmt.setFloat(5, quantity);
				pstmt.setInt(6, plantId);
				pstmt.setInt(7, systemId);
				pstmt.setInt(8, customerId);
				pstmt.setInt(9, userId);
				pstmt.setString(10, vehicleNo);
				inserted = pstmt.executeUpdate();
				if (inserted > 0) {
					message = " Challan Trip Details saved successfully";
					pstmt = con.prepareStatement(IronMiningStatement.UPDATE_CHALLAN_USED_QTY);
					pstmt.setFloat(1, quantity * 1000);
					pstmt.setInt(2, challanId);
					pstmt.executeUpdate();

					pstmt = con.prepareStatement(IronMiningStatement.UPDATE_ROM_QTY_IN_PLANT_MASTER);
					pstmt.setFloat(1, quantity);
					pstmt.setInt(2, plantId);
					pstmt.setInt(3, systemId);
					pstmt.setInt(4, customerId);
					pstmt.setString(5, mineral);
					pstmt.executeUpdate();

				} else {
					message = "Error while saving Challan Trip details";
				}
			} else {
				message = "challan Quantity is over. Please change challan";
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}

		return message;
	}

	public String saveImportDetailsForPOChallan(JSONArray json, int customerId, int systemId, int userId) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String message = "";
		int inserted = 0;
		float challanUsedQty = 0;
		float challanQty = 0;
		String mineral = "";
		try {
			con = DBConnection.getConnectionToDB("AMS");
			for (int i = 0; i < json.length(); i++) {
				JSONObject obj = json.getJSONObject(i);
				if (obj.getString("importValidStatusIndex1").equalsIgnoreCase("Valid")) {
					pstmt = con.prepareStatement(IronMiningStatement.GET_CHALLAN_USED_QTY);
					pstmt.setInt(1, Integer.parseInt(obj.getString("importChallanIdIndex1")));
					rs = pstmt.executeQuery();
					if (rs.next()) {
						challanUsedQty = rs.getFloat("USED_QTY");
						challanQty = rs.getFloat("CHALLAN_QTY");
						mineral = rs.getString("MINERAL_TYPE");
					}
					float actualchallanBal = challanQty - challanUsedQty;
					//float challanQuantityinTons = Float.parseFloat(obj.getString("importQuantityIndex1")) / 1000;
					if (actualchallanBal >= Float.parseFloat(obj.getString("importQuantityIndex1"))) {
						pstmt = con.prepareStatement(IronMiningStatement.SAVE_TRIP_FEED_DETAILS);
						pstmt.setInt(1, 0);
						pstmt.setInt(2, Integer.parseInt(obj.getString("importOrgIdIndex1")));
						pstmt.setInt(3, 0);
						pstmt.setInt(4, Integer.parseInt(obj.getString("importChallanIdIndex1")));
						pstmt.setFloat(5, Float.parseFloat(obj.getString("importQuantityIndex1")));
						pstmt.setInt(6, Integer.parseInt(obj.getString("importplantIdIndex1")));
						pstmt.setInt(7, systemId);
						pstmt.setInt(8, customerId);
						pstmt.setInt(9, userId);
						pstmt.setString(10, obj.getString("importVehicleNoIndex1"));
						inserted = pstmt.executeUpdate();
						if (inserted > 0) {
							message = "Challan Trip Details saved successfully";
							pstmt = con.prepareStatement(IronMiningStatement.UPDATE_CHALLAN_USED_QTY);
							pstmt.setFloat(1, Float.parseFloat(obj.getString("importQuantityIndex1")) * 1000);
							pstmt.setInt(2, Integer.parseInt(obj.getString("importChallanIdIndex1")));
							pstmt.executeUpdate();

							pstmt = con.prepareStatement(IronMiningStatement.UPDATE_ROM_QTY_IN_PLANT_MASTER);
							pstmt.setFloat(1, Float.parseFloat(obj.getString("importQuantityIndex1")));
							pstmt.setInt(2, Integer.parseInt(obj.getString("importplantIdIndex1")));
							pstmt.setInt(3, systemId);
							pstmt.setInt(4, customerId);
							pstmt.setString(5, mineral);
							pstmt.executeUpdate();
						} else {
							message = "Error while saving challan trip details";
						}
					} else {
						message = "challan Quantity is over. Please change challan";
					}
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}

		return message;
	}

	//-----------------------------------------VESSEL MASTER DETAILS------------------------------------//
	public ArrayList<JSONArray> getVesselMasterDetails(int systemId, int customerId) {
		JSONArray JsonArray = new JSONArray();
		JSONObject JsonObject = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int count = 0;
		ArrayList<JSONArray> list = new ArrayList<JSONArray>();
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(IronMiningStatement.GET_VESSEL_DETAILS);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, customerId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				JsonObject = new JSONObject();
				count++;
				JsonObject.put("slnoInd", count);

				JsonObject.put("vesselNameInd", rs.getString("VESSEL_NAME"));

				JsonObject.put("statusInd", rs.getString("STATUS"));

				JsonObject.put("buyerNameInd", rs.getString("BUYER_NAME"));

				JsonObject.put("uidInd", rs.getString("ID"));

				JsonArray.put(JsonObject);
			}
			list.add(JsonArray);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return list;
	}

	public String addVesselMaster(String vesselName, String status, int systemId, int customerId, int userId,
			String buyerName) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String message = "";
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(IronMiningStatement.CHECK_VESSEL_NAME_VESSEL_MASTER);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, customerId);
			pstmt.setString(3, vesselName);
			rs = pstmt.executeQuery();
			if (!rs.next()) {
				con = DBConnection.getConnectionToDB("AMS");
				pstmt = con.prepareStatement(IronMiningStatement.INSERT_VESSEL_MASTER_DETAILS);
				pstmt.setString(1, vesselName);
				pstmt.setString(2, status);
				pstmt.setInt(3, systemId);
				pstmt.setInt(4, customerId);
				pstmt.setInt(5, userId);
				pstmt.setString(6, buyerName);
				int inserted = pstmt.executeUpdate();
				if (inserted > 0) {
					message = "Saved Successfully";
				}
			} else {
				message = "Vessel Name already exist.";
			}
		} catch (Exception e) {
			System.out.println("error in:-save addVesselMaster");
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return message;
	}

	public String modifyVesselMaster(String vesselName, String status, int systemId, int customerId, int userId,
			int uid, String buyerName) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String message = "";
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(IronMiningStatement.CHECK_VESSEL_NAME_VESSEL_MASTER.concat(" and ID!=?"));
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, customerId);
			pstmt.setString(3, vesselName);
			pstmt.setInt(4, uid);
			rs = pstmt.executeQuery();
			if (!rs.next()) {
				con = DBConnection.getConnectionToDB("AMS");
				pstmt = con.prepareStatement(IronMiningStatement.UPDATE_VESSEL_MASTER_DETAILS);
				pstmt.setString(1, vesselName);
				pstmt.setString(2, status);
				pstmt.setInt(3, userId);
				pstmt.setString(4, buyerName);
				pstmt.setInt(5, uid);
				int inserted = pstmt.executeUpdate();
				if (inserted > 0) {
					message = "Updated Successfully";
				}
			} else {
				message = "Vessel Name already exist.";
			}
		} catch (Exception e) {
			System.out.println("error in:-update modifyVesselMaster");
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return message;

	}

	public JSONArray getVesselNames(int customerId, int systemId, int userId) {
		JSONArray JsonArray = null;
		JSONObject JsonObject = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			JsonArray = new JSONArray();
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(IronMiningStatement.GET_VESSEL_NAMES);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, customerId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				JsonObject = new JSONObject();
				JsonObject.put("vesselName", rs.getString("VESSEL_NAME"));
				JsonObject.put("vesselId", rs.getInt("ID"));
				JsonObject.put("buyerName", rs.getString("BUYER_NAME"));
				JsonArray.put(JsonObject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return JsonArray;
	}

	public JSONArray getOrganizationName(int customerId, int systemId, int userId) {
		JSONArray JsonArray = null;
		JSONObject JsonObject = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		DecimalFormat df = new DecimalFormat("##0.00");
		try {
			JsonArray = new JSONArray();
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(IronMiningStatement.GET_ORGANIZATION_NAME);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, customerId);
			pstmt.setInt(3, userId);
			pstmt.setInt(4, systemId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				JsonObject = new JSONObject();
				JsonObject.put("id", rs.getInt("ID"));
				JsonObject.put("organizationName", rs.getString("ORGANIZATION_NAME"));
				JsonArray.put(JsonObject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return JsonArray;
	}

	public ArrayList<Object> getRouteMasterDetails(int systemId, int customerId, int userId) {
		JSONArray JsonArray = new JSONArray();
		JSONObject JsonObject = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int slcount = 0;
		ReportHelper finalreporthelper = new ReportHelper();
		ArrayList<Object> finlist = new ArrayList<Object>();
		ArrayList<ReportHelper> reportsList = new ArrayList<ReportHelper>();
		ArrayList<String> headersList = new ArrayList<String>();
		SimpleDateFormat diffddMMyyyyHHmmss = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
		headersList.add("Sl No");
		headersList.add("Mother Route Name");
		headersList.add("Organization Name");
		headersList.add("Route Name");
		headersList.add("Source Hub");
		headersList.add("Destination Hub");
		headersList.add("Total Trip Count");
		headersList.add("Distance");
		headersList.add("Status");
		headersList.add("Route Type");
		headersList.add("ID");
		headersList.add("Updated By");
		headersList.add("Updated Datetime");
		headersList.add("Active By");
		headersList.add("Activated Datetime");
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(IronMiningStatement.GET_ROUTE_DETAILS);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, customerId);
			pstmt.setInt(3, userId);
			pstmt.setInt(4, systemId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				ArrayList<Object> informationList = new ArrayList<Object>();
				ReportHelper reporthelper = new ReportHelper();
				JsonObject = new JSONObject();
				slcount++;
				JsonObject.put("slnoIndex", slcount);
				informationList.add(slcount);

				JsonObject.put("OrgIdIndex", rs.getString("ORG_ID"));

				JsonObject.put("motherRNameIndex", rs.getString("MOTHER_ROUTE_NAME"));
				informationList.add(rs.getString("MOTHER_ROUTE_NAME"));

				JsonObject.put("OrganizationIndex", rs.getString("ORGANIZATION_NAME"));
				informationList.add(rs.getString("ORGANIZATION_NAME"));

				JsonObject.put("RouteNameIndex", rs.getString("ROUTE_NAME"));
				informationList.add(rs.getString("ROUTE_NAME"));

				JsonObject.put("SourceHubIdIndex", rs.getString("SOURCE_HUB_ID"));

				JsonObject.put("SourceHubIndex", rs.getString("SOURCE_HUBNAME"));
				informationList.add(rs.getString("SOURCE_HUBNAME"));

				JsonObject.put("DestinationHubIdIndex", rs.getString("DESTINATION_HUB_ID"));

				JsonObject.put("DestinationHubIndex", rs.getString("DESTINATION_HUBNAME"));
				informationList.add(rs.getString("DESTINATION_HUBNAME"));

				JsonObject.put("totalTripCount", rs.getInt("TOTAL_TRIPSHEET_COUNT"));
				informationList.add(rs.getInt("TOTAL_TRIPSHEET_COUNT"));

				JsonObject.put("distanceIndex", rs.getString("DISTANCE"));
				informationList.add(rs.getString("DISTANCE"));

				JsonObject.put("statusIndex", rs.getString("STATUS"));
				informationList.add(rs.getString("STATUS"));

				JsonObject.put("srcIndex", rs.getString("SOURCE_TYPE"));
				informationList.add(rs.getString("SOURCE_TYPE"));

				JsonObject.put("uid", rs.getInt("ID"));
				informationList.add(rs.getInt("ID"));

				JsonObject.put("updatedBy", rs.getInt("UPDATED_BY"));
				informationList.add(rs.getInt("UPDATED_BY"));

				if (rs.getTimestamp("UPDATED_DATETIME") == null || rs.getString("UPDATED_DATETIME").equals("")
						|| rs.getString("UPDATED_DATETIME").contains("1900")) {
					JsonObject.put("updatedDateIndex", "");
					informationList.add("");
				} else {
					JsonObject.put("updatedDateIndex", diffddMMyyyyHHmmss.format(rs.getTimestamp("UPDATED_DATETIME")));
					informationList.add(diffddMMyyyyHHmmss.format(rs.getTimestamp("UPDATED_DATETIME")));
				}

				JsonObject.put("activeBy", rs.getInt("ACTIVE_INACTIVE_BY"));
				informationList.add(rs.getInt("ACTIVE_INACTIVE_BY"));

				if (rs.getTimestamp("ACTIVE_INACTIVE_DATETIME") == null
						|| rs.getString("ACTIVE_INACTIVE_DATETIME").equals("")
						|| rs.getString("ACTIVE_INACTIVE_DATETIME").contains("1900")) {
					JsonObject.put("activeDateIndex", "");
					informationList.add("");
				} else {
					JsonObject.put("activeDateIndex",
							diffddMMyyyyHHmmss.format(rs.getTimestamp("ACTIVE_INACTIVE_DATETIME")));
					informationList.add(diffddMMyyyyHHmmss.format(rs.getTimestamp("ACTIVE_INACTIVE_DATETIME")));
				}

				JsonObject.put("routeCount", rs.getInt("ROUTE_COUNT"));
				JsonObject.put("motherRStatus", rs.getString("MOTHER_R_STATUS"));
				JsonObject.put("motherRId", rs.getInt("MID"));

				JsonArray.put(JsonObject);
				reporthelper.setInformationList(informationList);
				reportsList.add(reporthelper);
			}
			finlist.add(JsonArray);
			finalreporthelper.setReportsList(reportsList);
			finalreporthelper.setHeadersList(headersList);
			finlist.add(finalreporthelper);

		} catch (Exception e) {
			e.printStackTrace();
		} finally {

			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return finlist;
	}

	public String insertRouteMasterInformation(int systemId, int CustId, int orgId, String routeName, int userId,
			int sourceHubLocId, int destinationHubLocId, String distance, JSONArray js, int motherRId,
			String totalTripLimit, String srcType) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String message = "";
		int uniqueId = 0;
		JSONObject obj = null;
		String fromTime = "";
		String toTime = "";
		String tripLimit = "";
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(IronMiningStatement.CHECK_ROUTE_NAME_IN_ROUTE_MASTER);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, CustId);
			pstmt.setInt(3, orgId);
			pstmt.setString(4, routeName);
			rs = pstmt.executeQuery();
			if (!rs.next()) {
				con = DBConnection.getConnectionToDB("AMS");
				pstmt = con.prepareStatement(IronMiningStatement.INSERT_INTO_ROUTE_MASTER_DETAILS);
				pstmt.setInt(1, orgId);
				pstmt.setString(2, routeName);
				pstmt.setInt(3, sourceHubLocId);
				pstmt.setInt(4, destinationHubLocId);
				pstmt.setInt(5, systemId);
				pstmt.setInt(6, CustId);
				pstmt.setInt(7, userId);
				pstmt.setFloat(8, Float.parseFloat(distance));
				pstmt.setInt(9, motherRId);
				pstmt.setString(10, "Active");
				pstmt.setString(11, srcType);
				int inserted = pstmt.executeUpdate();
				if (inserted > 0) {
					message = "Inserted Successfully";
					pstmt = con.prepareStatement(IronMiningStatement.GET_UNIQUE_ID_FROM_ROUTE_DETAILS);
					pstmt.setString(1, routeName);
					pstmt.setInt(2, CustId);
					pstmt.setInt(3, systemId);
					rs = pstmt.executeQuery();
					if (rs.next()) {
						uniqueId = rs.getInt("ID");
					}
					for (int i = 0; i < js.length(); i++) {
						obj = js.getJSONObject(i);
						fromTime = obj.getString("fromTimeIndex");
						toTime = obj.getString("toTimeIndex");
						tripLimit = obj.getString("limitIndex");

						pstmt = con.prepareStatement(IronMiningStatement.INSERT_INTO_ROUTE_TRIP_LIMIT);
						pstmt.setInt(1, uniqueId);
						pstmt.setString(2, fromTime);
						pstmt.setString(3, toTime);
						pstmt.setString(4, tripLimit);
						pstmt.executeUpdate();
					}
					pstmt = con.prepareStatement(IronMiningStatement.UPDATE_TOTAL_TRIP_LIMIT);
					pstmt.setInt(1, Integer.parseInt(totalTripLimit));
					pstmt.setInt(2, uniqueId);
					pstmt.executeUpdate();
				}
			} else {
				message = "Route Name already exist for this Organization";
			}
		} catch (Exception e) {
			message = "Error in Adding";
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return message;
	}

	public String updateRouteMasterInformation(int userId, int uid, String distance, int sHubModify, int dHubModify,
			JSONArray js, JSONArray jsRemoved, String totalTripLimit, String srcType) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String message = "";
		JSONObject obj = null;
		JSONObject obj1 = null;
		String fromTime = "";
		String toTime = "";
		String tripLimit = "";
		String id = "0";
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(IronMiningStatement.UPDATE_ROUTE_MASTER_DETAILS);
			pstmt.setInt(1, userId);
			pstmt.setFloat(2, Float.parseFloat(distance));
			pstmt.setInt(3, sHubModify);
			pstmt.setInt(4, dHubModify);
			pstmt.setString(5, srcType);
			pstmt.setInt(6, uid);
			int updated = pstmt.executeUpdate();
			if (updated > 0) {
				message = "Updated Successfully";
				for (int i = 0; i < js.length(); i++) {
					obj = js.getJSONObject(i);
					fromTime = obj.getString("fromTimeIndex");
					toTime = obj.getString("toTimeIndex");
					tripLimit = obj.getString("limitIndex");
					id = obj.getString("uidIndex");

					pstmt = con.prepareStatement("Select * from MINING.dbo.ROUTE_TRIP_LIMIT_DETAILS where ID=? ",
							ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
					pstmt.setString(1, id);
					rs = pstmt.executeQuery();
					if (rs.next()) {
						rs.updateString("FROM_TIME", fromTime);
						rs.updateString("TO_TIME", toTime);
						rs.updateString("TRIPSHEET_LIMIT", tripLimit);
						rs.updateRow();
					} else {
						pstmt = con.prepareStatement(IronMiningStatement.INSERT_INTO_ROUTE_TRIP_LIMIT);
						pstmt.setInt(1, uid);
						pstmt.setString(2, fromTime);
						pstmt.setString(3, toTime);
						pstmt.setString(4, tripLimit);
						pstmt.executeUpdate();
					}
				}
				for (int j = 0; j < jsRemoved.length(); j++) {
					obj1 = jsRemoved.getJSONObject(j);
					pstmt = con.prepareStatement(IronMiningStatement.MOVE_DATA_TO_HISTORY);
					pstmt.setInt(1, userId);
					pstmt.setString(2, obj1.getString("uidIndex"));
					int inserted = pstmt.executeUpdate();
					if (inserted > 0) {
						pstmt = con.prepareStatement(IronMiningStatement.DELETE_TIME_DETAILS);
						pstmt.setString(1, obj1.getString("uidIndex"));
						pstmt.executeUpdate();
					}
				}
				pstmt = con.prepareStatement(IronMiningStatement.UPDATE_TOTAL_TRIP_LIMIT);
				pstmt.setInt(1, Integer.parseInt(totalTripLimit));
				pstmt.setInt(2, uid);
				pstmt.executeUpdate();

			}
		} catch (Exception e) {
			message = "Error in Updating";
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, null);
		}
		return message;
	}

	@SuppressWarnings({ "unused", "unused", "unused" })
	public String modifyChallanDetailsForOthers(int customerId, String paymentAccHead, String royalty, String financeYr,
			int systemId, int userId, String payDesc, int uniqueId, float totalPayable, String ewalletCheck,
			float ewalletPayable, float ewalletQbalance, String date, String transMonth) {

		String message = "";
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int id;
		try {
			int updated = 0;
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(IronMiningStatement.UPDATE_CHALLAN_DETAILS_FOR_OTHERS);
			pstmt.setString(1, paymentAccHead);
			pstmt.setString(2, financeYr);
			pstmt.setString(3, payDesc);
			pstmt.setFloat(4, totalPayable);
			pstmt.setString(5, ewalletCheck);
			pstmt.setFloat(6, ewalletPayable);
			pstmt.setFloat(7, ewalletQbalance);
			pstmt.setString(8, date);
			pstmt.setInt(9, userId);
			pstmt.setString(10, transMonth);
			pstmt.setInt(11, uniqueId);

			updated = pstmt.executeUpdate();
			if (updated > 0) {
				message = String.valueOf(uniqueId);//"Updated Successfully";
			} else {
				message = "0";//Error in Saving Challan Details";
			}
		} catch (Exception e) {
			System.out.println("error in challan Details:-save challan Details" + e.toString());
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return message;
	}

	public JSONArray getTripsheetCount(int customerId, int systemId, int routeId) {
		JSONArray JsonArray = null;
		JSONObject JsonObject = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			JsonArray = new JSONArray();
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(IronMiningStatement.CHECK_ROUTE_TS_LIMIT);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, customerId);
			pstmt.setInt(3, routeId);
			pstmt.setInt(4, systemId);
			pstmt.setInt(5, customerId);
			pstmt.setInt(6, routeId);
			pstmt.setInt(7, routeId);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				JsonObject = new JSONObject();
				JsonObject.put("tripsheetLimit", rs.getInt("TRIPSHEET_LIMIT"));
				JsonObject.put("tripsheetCount", rs.getInt("TRIPSHEET_COUNT"));
				JsonObject.put("id", rs.getString("REF_ID"));
				JsonArray.put(JsonObject);
			} else {
				JsonObject = new JSONObject();
				JsonObject.put("tripsheetLimit", 0);
				JsonObject.put("tripsheetCount", 0);
				JsonObject.put("id", "1");
				JsonArray.put(JsonObject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return JsonArray;
	}

	//----------------------------------------------MINING ASSET ENROLLMENT SAVE DETAILS-----------------------// 
	public String saveImportDetailsForInsurance(JSONArray json, int customerId, int systemId, int userId,
			String CustName) {
		String message = "";
		Connection conAdmin = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int inserted = 0;
		int enrollmentNo = 0;
		try {
			conAdmin = DBConnection.getConnectionToDB("AMS");
			for (int i = 0; i < json.length(); i++) {

				JSONObject obj = json.getJSONObject(i);
				if (obj.getString("importValidStatusIndex").equalsIgnoreCase("Valid")) {
					pstmt = conAdmin.prepareStatement(IronMiningStatement.GET_ASSET_NO_VALIDATE);
					pstmt.setInt(1, systemId);
					pstmt.setInt(2, customerId);
					pstmt.setString(3, obj.getString("importassetnoIndex"));
					rs = pstmt.executeQuery();

					if (rs.next()) {
						message = "<p>Asset Number Already Enrolled.</p>";
						//return (message);
					} else {
						Calendar gcalendar = new GregorianCalendar();
						int year = gcalendar.get(Calendar.YEAR);
						String curyear = String.valueOf(year);

						enrollmentNo = getEnrollmentNumber(conAdmin, systemId, customerId, curyear);

						//----leading Zeros handling----------------------//  
						String enrolmentNotoGrid = "";
						if (String.valueOf(enrollmentNo).length() <= 5) {
							enrolmentNotoGrid = ("00000" + enrollmentNo)
									.substring(String.valueOf(enrollmentNo).length());
						} else {
							enrolmentNotoGrid = ("000000000" + enrollmentNo)
									.substring(String.valueOf(enrollmentNo).length());
						}

						pstmt = conAdmin.prepareStatement(IronMiningStatement.SAVE_ADDED_INSURANCE_DETAILS);

						pstmt.setString(1, obj.getString("importassetnoIndex"));
						pstmt.setString(2, ddMMyyyy.format(sdf.parse(obj.getString("importregistrationdateIndex"))));
						pstmt.setInt(3, Integer.valueOf(obj.getString("importcarriagecapacityIndex")));
						pstmt.setString(4, obj.getString("importOperatingonmineIndex"));
						pstmt.setString(5, obj.getString("importlocationIndex"));
						pstmt.setString(6, obj.getString("importminingleasenoIndex"));
						pstmt.setString(7, obj.getString("importchassingnoIndex"));
						pstmt.setString(8, obj.getString("importpolicynoIndex"));
						pstmt.setString(9, ddMMyyyy.format(sdf.parse(obj.getString("importinsuranceexpirydateIndex"))));
						pstmt.setString(10, obj.getString("importpucnoIndex"));
						pstmt.setString(11, ddMMyyyy.format(sdf.parse(obj.getString("importpucexpirydateIndex"))));
						pstmt.setString(12, obj.getString("importownernameIndex"));
						pstmt.setString(13, obj.getString("importAssemblyConstituencyIndex"));
						pstmt.setString(14, obj.getString("importHouseNoIndex"));
						pstmt.setString(15, obj.getString("importLocalityIndex"));
						pstmt.setString(16, obj.getString("importCityIndex"));
						pstmt.setString(17, obj.getString("importTalukaIndex"));
						pstmt.setString(18, obj.getString("importstateidIndex"));
						pstmt.setString(19, obj.getString("importdistrictidIndex"));
						pstmt.setString(20, obj.getString("importEPICNoIndex"));
						pstmt.setString(21, obj.getString("importPANNoIndex"));
						pstmt.setInt(22, Integer.valueOf(obj.getString("importMobileNoIndex")));
						pstmt.setInt(23, Integer.valueOf(obj.getString("importPhoneNoIndex")));
						pstmt.setString(24, obj.getString("importAadharNoIndex"));
						pstmt.setString(25, ddMMyyyy.format(sdf.parse(obj.getString("importEnrollmentDateIndex"))));
						pstmt.setString(26, obj.getString("importBankIndex"));
						pstmt.setString(27, obj.getString("importBranchIndex"));
						pstmt.setInt(28, Integer.valueOf(obj.getString("importPrincipalBalanceIndex")));
						pstmt.setInt(29, Integer.valueOf(obj.getString("importPrincipalOverDuesIndex")));
						pstmt.setInt(30, Integer.valueOf(obj.getString("importInterestBalanceIndex")));
						pstmt.setString(31, obj.getString("importAccountNoIndex"));
						pstmt.setString(32, obj.getString("importEngineNoIndex"));
						pstmt.setString(33, CustName + "" + enrolmentNotoGrid + "/" + curyear);
						pstmt.setInt(34, systemId);
						pstmt.setInt(35, customerId);
						pstmt.setInt(36, userId);
						pstmt.setString(37,
								ddMMyyyy.format(sdf.parse(obj.getString("importroadTaxValiditydateIndex"))));
						pstmt.setString(38, ddMMyyyy.format(sdf.parse(obj.getString("importpermitValiditydateIndex"))));
						inserted = pstmt.executeUpdate();
						if (inserted > 0) {
							message = "Asset Enrollment Details Saved Successfully";
						} else {
							message = "Error in Saving Asset Enrollment Details";
						}
					}
				}
			}
		} catch (Exception e) {
			System.out.println("error in Asset Enrollment Details:-save Asset Enrollment Details" + e.toString());
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(conAdmin, pstmt, rs);
		}
		return message;
	}

	//----------------------------------------------UPDATE ASSET ENROLLMENT EXCEL DETAILS-----------------------// 
	public String updateAssetEnrollmentImportDetails(JSONArray json, int customerId, int systemId, int userId,
			String CustName) {
		String message = "";
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int inserted = 0;
		int updatedCount = 0;
		try {
			con = DBConnection.getConnectionToDB("AMS");
			for (int i = 0; i < json.length(); i++) {
				JSONObject obj = json.getJSONObject(i);
				try {
					if (obj.getString("impValidStatusIdx").equalsIgnoreCase("Valid")) {
						String addons = "";
						if (!obj.getString("impEngineNoIdx").equals("")) {
							addons += ("ENGINE_NUMBER='" + obj.getString("impEngineNoIdx") + "',");
						}
						if (!obj.getString("impOperatingOnMineIdx").equals("")) {
							addons += ("OPERATING_ON_MINE='" + obj.getString("impOperatingOnMineIdx") + "',");
						}
						if (!obj.getString("impLocationIdx").equals("")) {
							addons += ("LOCATION='" + obj.getString("impLocationIdx") + "',");
						}
						if (!obj.getString("impMiningLeaseNoIdx").equals("")) {
							addons += ("MINING_LEASE_NO='" + obj.getString("impMiningLeaseNoIdx") + "',");
						}
						if (!obj.getString("impChassisNoIdx").equals("")) {
							addons += ("CHASSIS_NO='" + obj.getString("impChassisNoIdx") + "',");
						}
						if (!obj.getString("impConstituencyIdx").equals("")) {
							addons += ("ASSEMBLY_CONSTITUENCY='" + obj.getString("impConstituencyIdx") + "',");
						}
						if (!obj.getString("impHouseNoIdx").equals("")) {
							addons += ("HOUSE_NO='" + obj.getString("impHouseNoIdx") + "',");
						}
						if (!obj.getString("impLocalityIdx").equals("")) {
							addons += ("LOCALITY='" + obj.getString("impLocalityIdx") + "',");
						}
						if (!obj.getString("impCityIdx").equals("")) {
							addons += ("CITY_OR_VILLAGE='" + obj.getString("impCityIdx") + "',");
						}
						if (!obj.getString("impTalukaIdx").equals("")) {
							addons += ("TALUKA='" + obj.getString("impTalukaIdx") + "',");
						}
						if (!obj.getString("impEpicNoIdx").equals("")) {
							addons += ("EPIC_NO='" + obj.getString("impEpicNoIdx") + "',");
						}
						if (!obj.getString("impPanNoIdx").equals("")) {
							addons += ("PAN_NO='" + obj.getString("impPanNoIdx") + "',");
						}
						if (!obj.getString("impMobileNoIdx").equals("")) {
							addons += ("MOBILE_NO=" + obj.getString("impMobileNoIdx") + ",");
						}
						if (!obj.getString("impPhoneNoIdx").equals("")) {
							addons += ("PHONE_NO=" + obj.getString("impPhoneNoIdx") + ",");
						}
						if (!obj.getString("impAadharNoIdx").equals("")) {
							addons += ("AADHAR_NO='" + obj.getString("impAadharNoIdx") + "',");
						}
						if (!obj.getString("impBankIdx").equals("")) {
							addons += ("BANK='" + obj.getString("impBankIdx") + "',");
						}
						if (!obj.getString("impBranchIdx").equals("")) {
							addons += ("BRANCH='" + obj.getString("impBranchIdx") + "',");
						}
						if (!obj.getString("impPrincipalBalanceIdx").equals("")) {
							addons += ("PRINCIPAL_BALANCE=" + obj.getString("impPrincipalBalanceIdx") + ",");
						}
						if (!obj.getString("impPrincipalOverDueIdx").equals("")) {
							addons += ("PRINCIPAL_OVER_DUES=" + obj.getString("impPrincipalOverDueIdx") + ",");
						}
						if (!obj.getString("impInterestBalanceIdx").equals("")) {
							addons += ("INTEREST_BALANCE=" + obj.getString("impInterestBalanceIdx") + ",");
						}
						if (!obj.getString("impAccountNoIdx").equals("")) {
							addons += ("ACCOUNT_NO='" + obj.getString("impAccountNoIdx") + "',");
						}
						if (addons.length() > 0) {
							addons = "," + addons.substring(0, addons.length() - 1);
						}
						//System.out.println(addons);
						pstmt = con.prepareStatement(
								IronMiningStatement.UPDATE_ASSET_ENROLLMENT_EXCEL_DETAILS.replace("##", addons));
						if (obj.getString("impValidityDateIdx") != null
								&& obj.getString("impValidityDateIdx").length() >= 10) {
							pstmt = con.prepareStatement(IronMiningStatement.UPDATE_ASSET_ENROLLMENT_EXCEL_DETAILS
									.replace("##", addons + " ##")
									.replace("##", ",ACKNOWLEDGE_DATETIME=getutcdate(),ACKNOWLEDGE_BY=" + userId));
						}
						pstmt.setString(1, obj.getString("impInsuranseNoIdx"));
						pstmt.setString(2, obj.getString("impInsuranseExpDateIdx").substring(0, 10));
						pstmt.setString(3, obj.getString("impPucNoIdx"));
						pstmt.setString(4, obj.getString("impPucExpDate").substring(0, 10));
						pstmt.setString(5, obj.getString("impChallanNoIdx"));
						pstmt.setString(6,
								obj.getString("impChallanDateIdx").length() >= 10
										? obj.getString("impChallanDateIdx").substring(0, 10)
										: null);
						pstmt.setString(7, obj.getString("impBankTransactionNoIdx"));
						pstmt.setDouble(8, obj.getDouble("impAmountPaidIdx"));
						pstmt.setString(9,
								obj.getString("impValidityDateIdx").length() >= 10
										? obj.getString("impValidityDateIdx").substring(0, 10)
										: null);
						pstmt.setString(10, obj.getString("impAssetStatusIdx"));
						pstmt.setInt(11, userId);
						pstmt.setString(12,
								!obj.getString("impRoadTaxValDate").equals("null")
										? obj.getString("impRoadTaxValDate").substring(0, 10)
										: "");
						pstmt.setString(13,
								!obj.getString("imppermitValDate").equals("null")
										? obj.getString("imppermitValDate").substring(0, 10)
										: "");
						pstmt.setInt(14, obj.getInt("UIDIdx"));
						pstmt.setString(15, obj.getString("impAssetNoIdx"));
						inserted = pstmt.executeUpdate();

						if (inserted > 0) {
							updatedCount++;
						} else {
							message = "Error in Updating Asset Enrollment Details";
						}

					}
				} catch (Exception e) {
					System.out.println("Exception in Updation ::" + obj.getString("impAssetNoIdx"));
					e.printStackTrace();
				}
			}
			message = updatedCount + " Asset Details has Updated Successfully";
		} catch (Exception e) {
			System.out.println(
					"error in Asset Enrollment Details:-Update Excel import Asset Enrollment Details" + e.toString());
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return message;
	}

	public JSONArray getRSPermitNo(int customerId, int systemId, int orgId, String mineralType) {
		JSONArray JsonArray = null;
		JSONObject JsonObject = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			JsonArray = new JSONArray();
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(IronMiningStatement.GET_RS_PERMIT);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, customerId);
			pstmt.setInt(3, orgId);
			pstmt.setString(4, mineralType);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				JsonObject = new JSONObject();
				JsonObject.put("rsPermitId", rs.getString("ID"));
				JsonObject.put("rsPermitNo", rs.getString("PERMIT_NO"));
				JsonObject.put("challanId", rs.getInt("CHALLAN_ID"));
				JsonObject.put("totProcessingFee", rs.getInt("TOTAL_PROCESSING_FEE"));
				JsonObject.put("srcType", rs.getString("SRC_TYPE"));
				JsonArray.put(JsonObject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return JsonArray;
	}

	public JSONArray getHubLocationForPermit(int customerId, int systemId, String permitType, String orgId,
			String mineral) {
		JSONArray JsonArray = null;
		JSONObject JsonObject = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			JsonArray = new JSONArray();
			con = DBConnection.getConnectionToDB("AMS");
			if (permitType.equalsIgnoreCase("Processed Ore Sale")) {
				pstmt = con.prepareStatement(IronMiningStatement.GET_LOCATION_FOR_PERMIT);
				pstmt.setInt(1, systemId);
				pstmt.setInt(2, customerId);
				pstmt.setString(3, orgId);
				pstmt.setString(4, mineral);
				pstmt.setInt(5, systemId);
				pstmt.setInt(6, customerId);
				pstmt.setString(7, orgId);
				pstmt.setString(8, mineral);
				rs = pstmt.executeQuery();
			} else {
				pstmt = con.prepareStatement(IronMiningStatement.GET_LOCATION_FOR_WEIGHBRIDGE);
				pstmt.setInt(1, systemId);
				pstmt.setInt(2, customerId);
				rs = pstmt.executeQuery();
			}
			while (rs.next()) {
				JsonObject = new JSONObject();
				JsonObject.put("Hubname", rs.getString("NAME"));
				JsonObject.put("HubID", rs.getInt("HUBID"));
				JsonArray.put(JsonObject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return JsonArray;
	}

	public String addLotDetails(int customerId, int systemId, int orgId, double quantity, int userId, String lotNo,
			int lotLoc, String type) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String message = "";
		int inserted = 0;
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(IronMiningStatement.SAVE_LOT_DETAILS);
			pstmt.setString(1, lotNo);
			pstmt.setInt(2, orgId);
			pstmt.setDouble(3, quantity);
			pstmt.setInt(4, systemId);
			pstmt.setInt(5, customerId);
			pstmt.setInt(6, userId);
			inserted = pstmt.executeUpdate();
			if (inserted > 0) {
				double fines = 0;
				double lumps = 0;
				double rom = 0;
				double tailings = 0;
				double concentrates = 0;
				if (type.equalsIgnoreCase("Fines")) {
					fines = quantity;
				} else if (type.equalsIgnoreCase("Lumps")) {
					lumps = quantity;
				} else if (type.equalsIgnoreCase("ROM")) {
					rom = quantity;
				} else if (type.equalsIgnoreCase("Tailings")) {
					tailings = quantity;
				} else if (type.equalsIgnoreCase("Concentrates")) {
					concentrates = quantity;
				}
				pstmt = con.prepareStatement(IronMiningStatement.GET_STOCK_DETAILS, ResultSet.TYPE_SCROLL_SENSITIVE,
						ResultSet.CONCUR_UPDATABLE);
				pstmt.setInt(1, systemId);
				pstmt.setInt(2, customerId);
				pstmt.setInt(3, lotLoc);
				pstmt.setInt(4, orgId);
				pstmt.setString(5, "Iron Ore(E-Auction)");
				rs = pstmt.executeQuery();
				if (rs.next()) {
					rs.updateDouble("ROM_QTY", rs.getFloat("ROM_QTY") + rom);
					rs.updateDouble("LUMPS", rs.getFloat("LUMPS") + lumps);
					rs.updateDouble("FINES", rs.getFloat("FINES") + fines);
					rs.updateDouble("TAILINGS", rs.getFloat("TAILINGS") + tailings);
					rs.updateDouble("CONCENTRATES", rs.getFloat("CONCENTRATES") + concentrates);
					rs.updateRow();
				} else {
					pstmt = con.prepareStatement(IronMiningStatement.INSERT_STOCK_FOR_LOT);
					pstmt.setInt(1, lotLoc);
					pstmt.setInt(2, orgId);
					pstmt.setDouble(3, fines);
					pstmt.setDouble(4, lumps);
					pstmt.setDouble(5, rom);
					pstmt.setDouble(6, tailings);
					pstmt.setDouble(7, concentrates);
					pstmt.setInt(8, systemId);
					pstmt.setInt(9, customerId);
					pstmt.setString(10, "Iron Ore(E-Auction)");
					pstmt.executeUpdate();
				}
				message = "Lot Allocation Details saved successfully";
			} else {
				message = "Error while saving Lot Allocation details";
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}

		return message;
	}

	public JSONArray getLotNo(int customerId, int systemId) {
		JSONArray JsonArray = null;
		JSONObject JsonObject = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			JsonArray = new JSONArray();
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(IronMiningStatement.GET_LOT_NO);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, customerId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				JsonObject = new JSONObject();
				JsonObject.put("lotName", rs.getString("LOT_NO"));
				JsonObject.put("lotId", rs.getString("ID"));
				JsonObject.put("lotLoc", rs.getString("LOT_LOCATION"));
				JsonObject.put("qty", rs.getString("QUANTITY"));
				JsonObject.put("hubId", rs.getString("HUBID"));
				JsonObject.put("type", rs.getString("TYPE"));
				JsonArray.put(JsonObject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return JsonArray;
	}

	public ArrayList<Object> getLotDetails(int customerId, int systemId, int userId) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		ArrayList<ReportHelper> reportsList = new ArrayList<ReportHelper>();
		ArrayList<String> headersList = new ArrayList<String>();
		ReportHelper finalreporthelper = new ReportHelper();
		ArrayList<Object> finalList = new ArrayList<Object>();
		DecimalFormat df = new DecimalFormat("##0.00");

		headersList.add("SLNO");
		headersList.add("Lot No");
		headersList.add("Lot Location");
		headersList.add("Organisation Name");
		headersList.add("Quantity");
		headersList.add("ID");
		headersList.add("Status");
		headersList.add("Remarks");

		JSONArray JsonArray = new JSONArray();
		JSONObject JsonObject = null;
		ReportHelper reporthelper = null;
		ArrayList<Object> informationList = null;
		try {
			int count = 0;
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(IronMiningStatement.GET_LOT_ALLOCATION_DETAILS);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, customerId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				JsonObject = new JSONObject();
				reporthelper = new ReportHelper();
				informationList = new ArrayList<Object>();

				count++;
				JsonObject.put("slnoIndex", count);
				informationList.add(count);

				JsonObject.put("lotNoIndex", rs.getString("LOT_NO"));
				informationList.add(rs.getString("LOT_NO"));

				JsonObject.put("lotLocIndex", rs.getString("LOT_LOCATION"));
				informationList.add(rs.getString("LOT_LOCATION"));

				JsonObject.put("organizationNameIndex", rs.getString("ORGANIZATION_NAME"));
				informationList.add(rs.getString("ORGANIZATION_NAME"));

				JsonObject.put("quantityIndex", df.format(rs.getDouble("QUANTITY")));
				informationList.add(rs.getString("QUANTITY"));

				JsonObject.put("uidIndex", (rs.getInt("ID")));
				informationList.add(rs.getInt("ID"));

				JsonObject.put("lotLocIdIndex", (rs.getInt("LOT_LOC_ID")));
				JsonObject.put("orgIdIndex", (rs.getInt("ORG_ID")));
				JsonObject.put("typeIndex", (rs.getString("TYPE")));

				JsonObject.put("statusIndex", rs.getString("STATUS"));
				informationList.add(rs.getString("STATUS"));

				JsonObject.put("remarksIndex", rs.getString("REMARKS"));
				informationList.add(rs.getString("REMARKS"));

				JsonArray.put(JsonObject);
				reporthelper.setInformationList(informationList);
				reportsList.add(reporthelper);
			}
			finalreporthelper.setReportsList(reportsList);
			finalreporthelper.setHeadersList(headersList);
			finalList.add(JsonArray);
			finalList.add(finalreporthelper);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return finalList;
	}

	public ArrayList<Object> getLotMasterDetails(int systemId, int customerId) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		ArrayList<ReportHelper> reportsList = new ArrayList<ReportHelper>();
		ArrayList<String> headersList = new ArrayList<String>();
		ReportHelper finalreporthelper = new ReportHelper();
		ArrayList<Object> finalList = new ArrayList<Object>();
		DecimalFormat df = new DecimalFormat("##0.00");
		SimpleDateFormat diffddMMyyyyHHmmss = new SimpleDateFormat("dd-MM-yyyy");
		headersList.add("SlNo");
		headersList.add("Lot Number");
		headersList.add("Lot Location");
		headersList.add("Grade");
		headersList.add("Type");
		headersList.add("Quantity");
		headersList.add("ID");
		headersList.add("Amount Paid(40%)");
		headersList.add("Date(40%)");
		headersList.add("Amount Paid(60%) ");
		headersList.add("Date(60%)");
		headersList.add("Remarks");
		headersList.add("Status");

		JSONArray JsonArray = new JSONArray();
		JSONObject JsonObject = null;
		ReportHelper reporthelper = null;
		ArrayList<Object> informationList = null;

		try {
			int count = 0;
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(IronMiningStatement.GET_LOT_MASTER_DETAILS);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, customerId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				JsonObject = new JSONObject();
				reporthelper = new ReportHelper();
				informationList = new ArrayList<Object>();
				count++;

				JsonObject.put("slnoDataIndex", count);
				informationList.add(count);

				JsonObject.put("lotnoindex", rs.getString("LOT_NO"));
				informationList.add(rs.getString("LOT_NO"));

				JsonObject.put("lotlocationindex", rs.getString("LOT_LOCATION"));
				informationList.add(rs.getString("LOT_LOCATION"));

				JsonObject.put("gradeindex", rs.getString("GRADE"));
				informationList.add(rs.getString("GRADE"));

				JsonObject.put("typeindex", rs.getString("TYPE"));
				informationList.add(rs.getString("TYPE"));

				JsonObject.put("quantityindex", df.format(rs.getDouble("QUANTITY")));
				informationList.add(df.format(rs.getDouble("QUANTITY")));

				JsonObject.put("uidIndex", rs.getInt("ID"));
				informationList.add(rs.getInt("ID"));

				JsonObject.put("amountindex", df.format(rs.getDouble("FORTY")));
				informationList.add(df.format(rs.getDouble("FORTY")));

				if (rs.getString("Date").contains("1900")) {
					JsonObject.put("dateIndex", "");
					informationList.add("");
				} else {
					JsonObject.put("dateIndex", diffddMMyyyyHHmmss.format(rs.getTimestamp("Date")));
					informationList.add(diffddMMyyyyHHmmss.format(rs.getTimestamp("Date")));
				}

				JsonObject.put("amoIndex", df.format(rs.getDouble("SIXTY")));
				informationList.add(df.format(rs.getDouble("SIXTY")));

				if (rs.getString("DATE1").contains("1900")) {
					JsonObject.put("date1Index", "");
					informationList.add("");
				} else {
					JsonObject.put("date1Index", diffddMMyyyyHHmmss.format(rs.getTimestamp("DATE1")));
					informationList.add(diffddMMyyyyHHmmss.format(rs.getTimestamp("DATE1")));
				}

				JsonObject.put("remarksIndex", rs.getString("REMARKS"));
				informationList.add(rs.getString("REMARKS"));

				JsonObject.put("statusIndex", rs.getString("STATUS"));
				informationList.add(rs.getString("STATUS"));

				JsonObject.put("lotAllCount", rs.getInt("LOT_ALLO_COUNT"));

				JsonArray.put(JsonObject);
				reporthelper.setInformationList(informationList);
				reportsList.add(reporthelper);
			}
			finalreporthelper.setReportsList(reportsList);
			finalreporthelper.setHeadersList(headersList);
			finalList.add(JsonArray);
			finalList.add(finalreporthelper);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return finalList;
	}

	public String addLotMaster(String LotNo, int LotLocation, String grade, String type, String quantity,
			String remarks, String amount40, String date40, String amount60, String date60, int systemId,
			int customerId, int userId) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String message = "";
		String amount = "";
		String amount1 = "";
		try {
			amount = amount40 != null && !amount40.equals("") ? amount40 : "0";
			amount1 = amount60 != null && !amount60.equals("") ? amount60 : "0";
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(IronMiningStatement.GET_LOT_NO_VALIDATE);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, customerId);
			pstmt.setString(3, LotNo);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				message = " Lot Number Already Exist.";
			} else {
				pstmt = con.prepareStatement(IronMiningStatement.INSERT_LOT_MASTER_DETAILS);
				pstmt.setString(1, LotNo);
				pstmt.setInt(2, LotLocation);
				pstmt.setString(3, grade);
				pstmt.setString(4, type);
				pstmt.setFloat(5, Float.parseFloat(quantity));
				pstmt.setString(6, remarks);
				pstmt.setFloat(7, Float.parseFloat(amount));
				pstmt.setString(8, date40);
				pstmt.setFloat(9, Float.parseFloat(amount1));
				pstmt.setString(10, date60);
				pstmt.setInt(11, systemId);
				pstmt.setInt(12, customerId);
				pstmt.setInt(13, userId);
				int inserted = pstmt.executeUpdate();
				if (inserted > 0) {
					message = "Saved Successfully";
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return message;
	}

	public String modifyLotMaster(String amount40, String date40, String amount60, String date60, String remarks,
			int systemId, int customerId, int userId, String id) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String message = "";
		int updated = 0;
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(IronMiningStatement.UPDATE_LOT_MASTER_DETAILS);
			pstmt.setString(1, amount40);
			pstmt.setString(2, date40);
			pstmt.setString(3, amount60);
			pstmt.setString(4, date60);
			pstmt.setString(5, remarks);
			pstmt.setInt(6, userId);
			pstmt.setInt(7, systemId);
			pstmt.setInt(8, customerId);
			pstmt.setString(9, id);
			updated = pstmt.executeUpdate();
			if (updated > 0) {
				message = "Updated Successfully";
			} else {
				message = "Updation Failed";
			}

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, null);
		}
		return message;
	}

	public JSONArray getOrganisationName(int customerId, int systemId, int userId) {
		JSONArray JsonArray = null;
		JSONObject JsonObject = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			JsonArray = new JSONArray();
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(IronMiningStatement.GET_ORGANISATION_DETAILS_FOR_PERMIT_REPORT);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, customerId);
			pstmt.setInt(3, userId);
			pstmt.setInt(4, systemId);
			rs = pstmt.executeQuery();
			while (rs.next()) {

				JsonObject = new JSONObject();
				JsonObject.put("Orgname", rs.getString("ORGANIZATION_NAME"));
				JsonObject.put("OrgID", rs.getInt("ID"));
				JsonArray.put(JsonObject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return JsonArray;
	}

	public ArrayList<Object> getPermitReportDetails(int systemId, int customerId, int OrgID, String mineral,
			String startd1, String endd1) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int count = 0;
		String orgname = "";
		ArrayList<ReportHelper> reportsList = new ArrayList<ReportHelper>();
		ArrayList<String> headersList = new ArrayList<String>();
		ReportHelper finalreporthelper = new ReportHelper();
		ArrayList<Object> finalList = new ArrayList<Object>();
		headersList.add("SL NO");
		headersList.add("Permit No");
		headersList.add("Organization Name");
		headersList.add("TC No");
		headersList.add("Permit Type");
		headersList.add("Mineral Type");
		headersList.add("ROM Quantity");
		headersList.add("Fines Quantity");
		headersList.add("Lumps Quantity");
		headersList.add("Tailings Quantity");
		headersList.add("Rejects Quantity");
		headersList.add("Concentrates Quantity");
		headersList.add("Transported Quantity");
		headersList.add("Buying Org/Trader name");
		headersList.add("Buying Org/Trader code");

		JSONArray JsonArray = new JSONArray();
		JSONObject JsonObject = null;
		ReportHelper reporthelper = null;
		ArrayList<Object> informationList = null;
		DecimalFormat df = new DecimalFormat("##0.00");
		try {
			con = DBConnection.getConnectionToDB("AMS");
			if (OrgID == 0) {
				pstmt = con.prepareStatement(IronMiningStatement.GET_ALL_PERMIT_REPORT_DETAILS.replace("&&", ""));
				pstmt.setString(1, mineral);
				pstmt.setInt(2, systemId);
				pstmt.setInt(3, customerId);
				pstmt.setString(4, startd1);
				pstmt.setString(5, endd1);
				pstmt.setString(6, mineral);
				pstmt.setInt(7, systemId);
				pstmt.setInt(8, customerId);
				pstmt.setString(9, startd1);
				pstmt.setString(10, endd1);
			} else {
				pstmt = con.prepareStatement(IronMiningStatement.GET_ALL_PERMIT_REPORT_DETAILS.replace("&&",
						" and (a.ORGANIZATION_CODE=? or ORG_ID=?)"));
				pstmt.setString(1, mineral);
				pstmt.setInt(2, systemId);
				pstmt.setInt(3, customerId);
				pstmt.setString(4, startd1);
				pstmt.setString(5, endd1);
				pstmt.setInt(6, OrgID);
				pstmt.setInt(7, OrgID);
				pstmt.setString(8, mineral);
				pstmt.setInt(9, systemId);
				pstmt.setInt(10, customerId);
				pstmt.setString(11, startd1);
				pstmt.setString(12, endd1);
				pstmt.setInt(13, OrgID);
				pstmt.setInt(14, OrgID);
			}
			rs = pstmt.executeQuery();

			while (rs.next()) {
				count++;
				JsonObject = new JSONObject();
				reporthelper = new ReportHelper();
				informationList = new ArrayList<Object>();

				JsonObject.put("slnoindex", count);
				informationList.add(count);

				JsonObject.put("permitno", rs.getString("PERMIT_NO"));
				informationList.add(rs.getString("PERMIT_NO"));

				orgname = rs.getString("ORGANIZATION_NAME");
				if (orgname.equalsIgnoreCase("Z")) {
					orgname = "TOTAL";
				}
				JsonObject.put("organizationname", orgname);
				informationList.add(orgname);

				JsonObject.put("tcnoindex", rs.getString("TC_NO"));
				informationList.add(rs.getString("TC_NO"));

				JsonObject.put("permittypeindex", rs.getString("PERMIT_TYPE"));
				informationList.add(rs.getString("PERMIT_TYPE"));

				JsonObject.put("mineraltypeindex", rs.getString("MINERAL"));
				informationList.add(rs.getString("MINERAL"));

				JsonObject.put("romquantityindex", rs.getString("ROM_QUANTITY"));
				informationList.add(rs.getString("ROM_QUANTITY"));

				JsonObject.put("finesquantityindex", rs.getString("FINES_QUANTITY"));
				informationList.add(rs.getString("FINES_QUANTITY"));

				JsonObject.put("lumpsquantityindex", rs.getString("LUMPS_QUANTITY"));
				informationList.add(rs.getString("LUMPS_QUANTITY"));

				JsonObject.put("tailingsQtyInd", rs.getString("TAILINGS_QUANTITY"));
				informationList.add(rs.getString("TAILINGS_QUANTITY"));

				JsonObject.put("rejectsQtyInd", rs.getString("REJECTS_QUANTITY"));
				informationList.add(rs.getString("REJECTS_QUANTITY"));

				JsonObject.put("concentratesQtyInd", rs.getString("CONCENTRATES_QUANTITY"));
				informationList.add(rs.getString("CONCENTRATES_QUANTITY"));

				JsonObject.put("transportedquantityindex", df.format(rs.getDouble("TRIPSHEET_QTY")));
				informationList.add(df.format(rs.getDouble("TRIPSHEET_QTY")));

				JsonObject.put("tradernameindex", rs.getString("BUYING_ORGANIZATION_NAME"));
				informationList.add(rs.getString("BUYING_ORGANIZATION_NAME"));

				JsonObject.put("tradercodeindex", rs.getString("BUYING_ORGANIZATION_CODE"));
				informationList.add(rs.getString("BUYING_ORGANIZATION_CODE"));

				JsonArray.put(JsonObject);
				reporthelper.setInformationList(informationList);
				reportsList.add(reporthelper);
			}
			finalreporthelper.setReportsList(reportsList);
			finalreporthelper.setHeadersList(headersList);
			finalList.add(JsonArray);
			finalList.add(finalreporthelper);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return finalList;
	}

	public ArrayList<Object> getPermitSummeryDetails(int systemId, int custId, int userId, String startDate,
			String endDate, String mineralType) {
		ArrayList<ReportHelper> reportsList = new ArrayList<ReportHelper>();
		ArrayList<String> headersList = new ArrayList<String>();
		ReportHelper finalreporthelper = new ReportHelper();
		ArrayList<Object> finlist = new ArrayList<Object>();
		JSONArray JsonArray = null;
		JSONObject JsonObject = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int count = 0;
		try {
			headersList.add("SLNO");
			headersList.add("Organization/Trader Name");
			headersList.add("Permit Type");
			headersList.add("ROM Quantity");
			headersList.add("Fines Quantity");
			headersList.add("Lumps Quantity");
			headersList.add("Tailings Quantity");
			headersList.add("Rejects Quantity");
			headersList.add("Concentrates Quantity");
			headersList.add("TRANSPORTED Rom");
			headersList.add("TRANSPORTED Fines");
			headersList.add("TRANSPORTED Lumps");
			headersList.add("TRANSPORTED Tailings");
			headersList.add("TRANSPORTED Rejects");
			headersList.add("TRANSPORTED Concentrates");
			JsonArray = new JSONArray();

			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(IronMiningStatement.GET_PERMIT_SUMMARY_REPORT_DETAILS);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, custId);
			pstmt.setString(3, startDate);
			pstmt.setString(4, endDate);
			pstmt.setString(5, mineralType);
			pstmt.setInt(6, userId);
			pstmt.setInt(7, systemId);
			pstmt.setInt(8, userId);
			pstmt.setInt(9, systemId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				count++;
				ReportHelper reporthelper = new ReportHelper();
				JsonObject = new JSONObject();
				ArrayList<Object> informationList = new ArrayList<Object>();

				JsonObject.put("slnoIndex", count);
				informationList.add(count);

				JsonObject.put("orgTraderNameIndex", rs.getString("ORG_NAME"));
				informationList.add(rs.getString("ORG_NAME"));

				JsonObject.put("permitTypeIndex", rs.getString("PERMIT_TYPE"));
				informationList.add(rs.getString("PERMIT_TYPE"));

				JsonObject.put("ROMQuantitytIndex", rs.getDouble("ROM_QUANTITY"));
				informationList.add(rs.getDouble("ROM_QUANTITY"));

				JsonObject.put("FinesQuantitytIndex", rs.getDouble("FINES_QUANTITY"));
				informationList.add(rs.getDouble("FINES_QUANTITY"));

				JsonObject.put("LumpsQuantitytIndex", rs.getDouble("LUMPS_QUANTITY"));
				informationList.add(rs.getDouble("LUMPS_QUANTITY"));

				JsonObject.put("TailingsQuantitytIndex", rs.getDouble("TAILINGS_QUANTITY"));
				informationList.add(rs.getDouble("TAILINGS_QUANTITY"));

				JsonObject.put("RejectsQuantitytIndex", rs.getDouble("REJECTS_QUANTITY"));
				informationList.add(rs.getDouble("REJECTS_QUANTITY"));

				JsonObject.put("ConcentratesQuantitytIndex", rs.getDouble("CONCENTRATES_QUANTITY"));
				informationList.add(rs.getDouble("CONCENTRATES_QUANTITY"));

				JsonObject.put("transportedROMIndex", rs.getDouble("ROM_TRIPSHEET_QTY"));
				informationList.add(rs.getDouble("ROM_TRIPSHEET_QTY"));

				JsonObject.put("transportedFinesIndex", rs.getDouble("FINES_TRIPSHEET_QTY"));
				informationList.add(rs.getDouble("FINES_TRIPSHEET_QTY"));

				JsonObject.put("transportedLumpsIndex", rs.getDouble("LUMPS_TRIPSHEET_QTY"));
				informationList.add(rs.getDouble("LUMPS_TRIPSHEET_QTY"));

				JsonObject.put("transportedTailingsIndex", rs.getDouble("TAILINGS_TRIPSHEET_QTY"));
				informationList.add(rs.getDouble("TAILINGS_TRIPSHEET_QTY"));

				JsonObject.put("transportedRejectsIndex", rs.getDouble("REJECTS_TRIPSHEET_QTY"));
				informationList.add(rs.getDouble("REJECTS_TRIPSHEET_QTY"));

				JsonObject.put("transportedConcentratesIndex", rs.getDouble("CONCENTRATES_TRIPSHEET_QTY"));
				informationList.add(rs.getDouble("CONCENTRATES_TRIPSHEET_QTY"));

				JsonArray.put(JsonObject);
				reporthelper.setInformationList(informationList);
				reportsList.add(reporthelper);
			}
			finalreporthelper.setReportsList(reportsList);
			finalreporthelper.setHeadersList(headersList);
			finlist.add(JsonArray);
			finlist.add(finalreporthelper);

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return finlist;
	}

	public String addProcessingFeeDetails(String permitType, float processingFee, int systemId, int custId, int userId,
			String mineralType) {
		Connection con = null;
		PreparedStatement pstmt = null;
		String message = "";
		int updated = 0;
		ResultSet rs = null;
		try {
			con = DBConnection.getConnectionToDB("AMS");

			pstmt = con.prepareStatement(IronMiningStatement.GET_PERMIT_TYPE_FROM_PROCESSING_FEE_DETAILS);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, custId);
			pstmt.setString(3, permitType);
			pstmt.setString(4, mineralType);
			rs = pstmt.executeQuery();
			if (!rs.next()) {
				pstmt = con.prepareStatement(IronMiningStatement.INSERT_PROCESSING_FEE_DETAILS);
				pstmt.setFloat(1, processingFee);
				pstmt.setString(2, permitType);
				pstmt.setInt(3, systemId);
				pstmt.setInt(4, custId);
				pstmt.setInt(5, userId);
				pstmt.setString(6, mineralType);
				updated = pstmt.executeUpdate();
				if (updated > 0) {
					message = "Saved Successfully";
				} else {
					message = "Error while Saving";
				}
			} else {
				message = "Record already exists";
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, null);
		}

		return message;
	}

	@SuppressWarnings("unchecked")
	public ArrayList getProcessingFeeMasterDetails(int systemId, int customerId) {
		JSONArray JsonArray = new JSONArray();
		JSONObject JsonObject = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int slcount = 0;
		ArrayList aslist = new ArrayList();
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(IronMiningStatement.GET_PROCESSING_FEE_DETAILS);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, customerId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				JsonObject = new JSONObject();
				slcount++;
				JsonObject.put("slnoIndex", slcount);

				JsonObject.put("permitTypeIndex", rs.getString("PERMIT_TYPE"));

				JsonObject.put("processingFeeIndex", rs.getString("PROCESSING_FEE"));

				JsonObject.put("mineralTypeIndex", rs.getString("MINERAL_TYPE"));

				JsonObject.put("uniqueIdIndex", rs.getString("ID"));

				JsonArray.put(JsonObject);
			}
			aslist.add(JsonArray);

		} catch (Exception e) {
			e.printStackTrace();
		} finally {

			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return aslist;
	}

	public ArrayList getPermitTypeForProcessingFeeMaster(int systemId, int customerId) {
		JSONArray JsonArray = new JSONArray();
		JSONObject JsonObject = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		ArrayList aslist = new ArrayList();
		try {
			HashSet<String> set = new HashSet<String>();
			set.add("Rom Transit");
			set.add("Rom Sale");
			set.add("Purchased Rom Sale Transit Permit");
			set.add("Processed Ore Transit");
			set.add("Processed Ore Sale");
			set.add("Processed Ore Sale Transit");
			set.add("Domestic Export");
			set.add("International Export");
			set.add("Import Permit");
			set.add("Import Transit Permit");
			set.add("Bauxite Transit");
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(IronMiningStatement.GET_PERMIT_TYPE_FROM_PROCESSING_FEE_DETAILS);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, customerId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				boolean bool = set.remove(rs.getString("PERMIT_TYPE"));
			}
			for (String permitType : set) {
				JsonObject = new JSONObject();
				JsonObject.put("Name", permitType);
				JsonArray.put(JsonObject);
			}
			aslist.add(JsonArray);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {

			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return aslist;
	}

	public String ModifyProcessingFeeDetails(String permitType, float processingFee, int userId, int id) {
		Connection con = null;
		PreparedStatement pstmt = null;
		String message = "";
		int updated = 0;
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(IronMiningStatement.UPDATE_PROCESSING_FEE_DETAILS);
			pstmt.setString(1, permitType);
			pstmt.setFloat(2, processingFee);
			pstmt.setInt(3, userId);
			pstmt.setInt(4, id);
			updated = pstmt.executeUpdate();
			if (updated > 0) {
				message = "Updated Successfully";
			} else {
				message = "Error while Updating";
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, null);
		}

		return message;
	}

	public JSONArray getPermitsForCustomSearch(int systemId, int custId, int userId) {
		JSONArray JsonArray = new JSONArray();
		JSONObject jObj = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(IronMiningStatement.GET_PERMIT_NUMBERS_FOR_CUSTOM_SEARCH);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, custId);
			pstmt.setInt(3, userId);
			pstmt.setInt(4, userId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				jObj = new JSONObject();
				jObj.put("PERMIT_ID", rs.getInt("PERMIT_ID"));
				jObj.put("PERMIT_NO", rs.getString("PERMIT_NO"));
				JsonArray.put(jObj);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return JsonArray;
	}

	public JSONArray getOrgNamesForCustomSearch(int systemId, int custId, int userId) {
		JSONArray JsonArray = new JSONArray();
		JSONObject jObj = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(IronMiningStatement.GET_ORG_NAMES_FOR_CUSTOM_SEARCH);
			pstmt.setInt(1, userId);
			pstmt.setInt(2, custId);
			pstmt.setInt(3, systemId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				jObj = new JSONObject();
				jObj.put("ORG_ID", rs.getInt("ORG_ID"));
				jObj.put("ORG_CODE", rs.getString("ORG_CODE"));
				jObj.put("ORG_NAME", rs.getString("ORG_NAME"));
				JsonArray.put(jObj);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return JsonArray;
	}

	public synchronized String cancelBargeTruckTrip(String clientId, int systemId, int userId, String tripid,
			String permitNo, int tcId, int routeId, String assetNo, String remark) {
		Connection con = null;
		PreparedStatement pstmt = null;
		PreparedStatement pstmt1 = null;
		PreparedStatement pstmtop = null;
		ResultSet rs = null;
		int destination = 0;
		int permitId = 0;
		int orgId = 0;
		float qty = 0;
		String gradeType = "";
		String message = "";
		int updated1;
		int btsId = 0;
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmtop = con.prepareStatement(IronMiningStatement.GET_TRIP_DETAILS_FOR_CANCEL_TRIP);
			pstmtop.setInt(1, systemId);
			pstmtop.setInt(2, Integer.parseInt(clientId));
			pstmtop.setInt(3, Integer.parseInt(tripid));
			rs = pstmtop.executeQuery();
			if (rs.next()) {
				qty = rs.getFloat("TOTAL_QTY");
				permitId = rs.getInt("PERMIT_ID");
				orgId = rs.getInt("ORG_ID");
				gradeType = rs.getString("START_LOCATION");
				btsId = rs.getInt("BTS_ID");
			}
			pstmt = con.prepareStatement(IronMiningStatement.UPDATE_CLOSE_TRIP_DETAILS_FOR_BARGE);
			pstmt.setInt(1, userId);
			pstmt.setString(2, remark);
			pstmt.setInt(3, Integer.parseInt(tripid));
			updated1 = pstmt.executeUpdate();
			if (updated1 > 0) {
				int inserted = updatePermitQty(permitId, qty, Integer.parseInt(clientId), systemId);
				if (inserted > 0) {
					pstmt1 = con.prepareStatement(IronMiningStatement.UPDATE_BARGE_QTY);
					pstmt1.setFloat(1, qty);
					pstmt1.setInt(2, btsId);
					pstmt1.executeUpdate();
				}
				message = " Tripsheet Cancelled Successfully ";
			} else {
				message = " Tripsheet cannot be Cancelled. ";
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(null, pstmt, null);
			DBConnection.releaseConnectionToDB(null, pstmtop, rs);
			DBConnection.releaseConnectionToDB(con, pstmt1, null);
		}
		return message;
	}

	public ArrayList<Object> getTripSheetSummaryReport(int systemId, int custId, int userId, String startDate,
			String endDate, String mineralType) {
		ArrayList<ReportHelper> reportsList = new ArrayList<ReportHelper>();
		ArrayList<String> headersList = new ArrayList<String>();
		ReportHelper finalreporthelper = new ReportHelper();
		ArrayList<Object> finlist = new ArrayList<Object>();
		JSONArray JsonArray = null;
		JSONObject JsonObject = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int count = 0;
		DecimalFormat df = new DecimalFormat("##0.00");
		try {
			headersList.add("SL NO");
			headersList.add("Organisation Name");
			headersList.add("Permit Type");
			headersList.add("Transported Fines");
			headersList.add("Transported Lumps");
			headersList.add("Transported ROM");
			headersList.add("Truck TripSheet Count");
			headersList.add("Barge TripSheet Count");
			JsonArray = new JSONArray();

			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(IronMiningStatement.GET_TRIPSHEET_SUMMARY_REPORT_DETAILS);
			pstmt.setString(1, startDate);
			pstmt.setString(2, endDate);
			pstmt.setString(3, startDate);
			pstmt.setString(4, endDate);
			pstmt.setString(5, startDate);
			pstmt.setString(6, endDate);
			pstmt.setString(7, startDate);
			pstmt.setString(8, endDate);
			pstmt.setString(9, startDate);
			pstmt.setString(10, endDate);
			pstmt.setString(11, startDate);
			pstmt.setString(12, endDate);
			pstmt.setInt(13, systemId);
			pstmt.setInt(14, custId);
			pstmt.setString(15, mineralType);
			pstmt.setInt(16, userId);
			pstmt.setInt(17, systemId);
			pstmt.setInt(18, userId);
			pstmt.setInt(19, systemId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				count++;
				ReportHelper reporthelper = new ReportHelper();
				JsonObject = new JSONObject();
				ArrayList<Object> informationList = new ArrayList<Object>();

				JsonObject.put("SLNODataIndex", count);
				informationList.add(count);

				JsonObject.put("orgNameDataIndex", rs.getString("ORG_NAME"));
				informationList.add(rs.getString("ORG_NAME"));

				JsonObject.put("permitTypeDataIndex", rs.getString("PERMIT_TYPE"));
				informationList.add(rs.getString("PERMIT_TYPE"));

				JsonObject.put("truckTransFinesDataIndex", df.format(rs.getDouble("FINES_TRIPSHEET_QTY")));
				informationList.add(df.format(rs.getDouble("FINES_TRIPSHEET_QTY")));

				JsonObject.put("truckTransLumpsDataIndex", df.format(rs.getDouble("LUMPS_TRIPSHEET_QTY")));
				informationList.add(df.format(rs.getDouble("LUMPS_TRIPSHEET_QTY")));

				JsonObject.put("transportedROMDataIndex", df.format(rs.getDouble("ROM_TRIPSHEET_QTY")));
				informationList.add(df.format(rs.getDouble("ROM_TRIPSHEET_QTY")));

				JsonObject.put("truckTripSheetCountDataIndex", 0);
				informationList.add(0);

				JsonObject.put("bargeTripSheetCountDataIndex", 0);
				informationList.add(0);

				JsonArray.put(JsonObject);
				reporthelper.setInformationList(informationList);
				reportsList.add(reporthelper);
			}
			finalreporthelper.setReportsList(reportsList);
			finalreporthelper.setHeadersList(headersList);
			finlist.add(JsonArray);
			finlist.add(finalreporthelper);

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return finlist;
	}

	public JSONArray getChallanssForCustomSearch(int systemId, int custId, int userId) {
		JSONArray JsonArray = new JSONArray();
		JSONObject jObj = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(IronMiningStatement.GET_CHALLAN_NUMBERS_FOR_CUSTOM_SEARCH);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, custId);
			pstmt.setInt(3, userId);
			pstmt.setInt(4, userId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				jObj = new JSONObject();
				jObj.put("CHALLAN_ID", rs.getInt("CHALLAN_ID"));
				jObj.put("CHALLAN_NO", rs.getString("CHALLAN_NO"));
				JsonArray.put(jObj);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return JsonArray;
	}

	public JSONArray getOrgNamesForChallanCustomSearch(int systemId, int custId, int userId) {
		JSONArray JsonArray = new JSONArray();
		JSONObject jObj = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(IronMiningStatement.GET_ORG_NAMES_FOR_CUSTOM_SEARCH);
			pstmt.setInt(1, userId);
			pstmt.setInt(2, custId);
			pstmt.setInt(3, systemId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				jObj = new JSONObject();
				jObj.put("ORG_ID", rs.getInt("ORG_ID"));
				jObj.put("ORG_CODE", rs.getString("ORG_CODE"));
				jObj.put("ORG_NAME", rs.getString("ORG_NAME"));
				JsonArray.put(jObj);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return JsonArray;
	}

	public String cancelPlantFeed(int customerId, int systemId, int userId, int id, String type, String qty,
			float totalFinesTf, float totalLumpsTf, float totalConcentratesTf, float tailings, int plantId,
			String remark, float ufo) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String message = "";
		float totalFines = 0;
		float totalLumps = 0;
		float totalUfo = 0;
		float totalTailings = 0;
		float totalConcentrates = 0;
		int updated = 0;
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(IronMiningStatement.CHECK_RECORDS_IN_PLANT_MASTER);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, customerId);
			pstmt.setInt(3, plantId);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				totalFines = rs.getFloat("TOTAL_FINES");
				totalLumps = rs.getFloat("TOTAL_LUMPS");
				totalConcentrates = rs.getFloat("TOTAL_CONCENTRATES");
				totalTailings = rs.getFloat("TAILINGS");
				totalUfo = rs.getFloat("TOTAL_UFO");
			}
			if (totalFines >= totalFinesTf && totalLumps >= totalLumpsTf && totalUfo >= ufo
					&& totalConcentrates >= totalConcentratesTf && totalTailings >= tailings) {
				pstmt = con.prepareStatement(IronMiningStatement.INSERT_INTO_PLANT_FEED_HISTORY);
				pstmt.setString(1, remark);
				pstmt.setInt(2, userId);
				pstmt.setInt(3, id);
				updated = pstmt.executeUpdate();
				if (updated > 0) {
					pstmt = con.prepareStatement(IronMiningStatement.DELETE_PLANT_FEED_RECORD);
					pstmt.setInt(1, id);
					int inserted = pstmt.executeUpdate();
				}
				if (updated > 0) {
					if (type.equalsIgnoreCase("ROM")) {
						pstmt = con.prepareStatement(
								IronMiningStatement.UPDATE_ROM_QTY_IN_PLANT_MASTER_FOR_CANCEL_PLANT_FEED);
						pstmt.setFloat(1, Float.parseFloat(qty));
						pstmt.setInt(2, systemId);
						pstmt.setInt(3, customerId);
						pstmt.setInt(4, plantId);
						pstmt.executeUpdate();
					} else {
						pstmt = con.prepareStatement(
								IronMiningStatement.UPDATE_UFO_QTY_IN_PLANT_MASTER_FOR_CANCEL_PLANT_FEED);
						pstmt.setFloat(1, Float.parseFloat(qty));
						pstmt.setInt(2, systemId);
						pstmt.setInt(3, customerId);
						pstmt.setInt(4, plantId);
						pstmt.executeUpdate();
					}
					message = "Cancelled Successfully";
				} else {
					message = "Error in Cancelling";
				}
			} else {
				message = "Insufficient Quantity,Can't Cancel the record";
			}
		} catch (Exception e) {
			message = "Error in Cancelling";
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, null);
		}
		return message;
	}

	public String cancelTripFeed(int customerId, int systemId, int userId, int id, int plantId, String qty,
			int permitId, String challanNo, String remarks) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String message = "";
		int updated = 0;
		float romQty = 0;
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(IronMiningStatement.GET_ROM_QTY);
			pstmt.setInt(1, plantId);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				romQty = rs.getFloat("ROM_QTY");
			}
			if (romQty > Float.parseFloat(qty)) {
				pstmt = con.prepareStatement(IronMiningStatement.DELETE_TRIP_FEED_RECORD);
				pstmt.setString(1, remarks);
				pstmt.setInt(2, userId);
				pstmt.setInt(3, id);
				updated = pstmt.executeUpdate();
				if (updated > 0) {
					message = "Cancelled successfully";
					if (permitId > 0) {
						pstmt = con.prepareStatement(IronMiningStatement.UPDATE_TRIPSHEET_QTY);
						pstmt.setFloat(1, Float.parseFloat(qty) * 1000);
						pstmt.setInt(2, permitId);
						pstmt.setInt(3, systemId);
						pstmt.setInt(4, customerId);
						pstmt.executeUpdate();
					} else {
						pstmt = con.prepareStatement(IronMiningStatement.UPDATE_CHALLAN_USED_QTY_FOR_CANCEL);
						pstmt.setFloat(1, Float.parseFloat(qty) * 1000);
						pstmt.setString(2, challanNo);
						pstmt.executeUpdate();
					}
					pstmt = con
							.prepareStatement(IronMiningStatement.UPDATE_ROM_QTY_IN_PLANT_MASTER_FOR_CANCEL_TRIP_FEED);
					pstmt.setFloat(1, Float.parseFloat(qty));
					pstmt.setInt(2, systemId);
					pstmt.setInt(3, customerId);
					pstmt.setInt(4, plantId);
					pstmt.executeUpdate();
				} else {
					message = "Error while Cancelling Trip feed details";
				}
			} else if (plantId == 0 && permitId > 0) {
				pstmt = con.prepareStatement(IronMiningStatement.DELETE_TRIP_FEED_RECORD);
				pstmt.setString(1, remarks);
				pstmt.setInt(2, userId);
				pstmt.setInt(3, id);
				updated = pstmt.executeUpdate();
				if (updated > 0) {
					pstmt = con.prepareStatement(IronMiningStatement.UPDATE_TRIPSHEET_QTY);
					pstmt.setFloat(1, Float.parseFloat(qty) * 1000);
					pstmt.setInt(2, permitId);
					pstmt.setInt(3, systemId);
					pstmt.setInt(4, customerId);
					pstmt.executeUpdate();
					message = "Cancelled successfully";
				} else {
					message = "Error while Cancelling Trip feed details";
				}
			} else {
				message = "Insufficient Quantity,Can't Cancel the record";
			}
		} catch (Exception e) {
			e.printStackTrace();
			message = "Error while Cancelling Trip feed details";
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return message;
	}

	public String cancelLotMasterDetails(int customerId, int systemId, int userId, int id, String remarks) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String message = "";
		int updated = 0;
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(IronMiningStatement.DELETE_LOT_MASTER);
			pstmt.setString(1, remarks);
			pstmt.setInt(2, userId);
			pstmt.setInt(3, id);
			updated = pstmt.executeUpdate();
			if (updated > 0) {
				message = "Record Cancelled Successfully";
			} else {
				message = "Error while Cancelling Lot details";
			}
		} catch (Exception e) {
			e.printStackTrace();
			message = "Error while Cancelling Lot details";
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return message;
	}

	public String cancelLotAllocationDetails(int customerId, int systemId, int userId, int id, String remarks,
			int orgId, float quantity, int lotLoc, String type) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String message = "";
		int inserted = 0;
		float finesQ = 0;
		float lumpsQ = 0;
		float romQ = 0;
		float tailingsQ = 0;
		float concentratesQ = 0;
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(IronMiningStatement.GET_STOCK_DETAILS);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, customerId);
			pstmt.setInt(3, lotLoc);
			pstmt.setInt(4, orgId);
			pstmt.setString(5, "Iron Ore(E-Auction)");
			rs = pstmt.executeQuery();
			if (rs.next()) {
				finesQ = rs.getFloat("FINES");
				lumpsQ = rs.getFloat("LUMPS");
				romQ = rs.getFloat("ROM_QTY");
				tailingsQ = rs.getFloat("TAILINGS");
				concentratesQ = rs.getFloat("CONCENTRATES");
			}
			float fines = 0;
			float lumps = 0;
			float rom = 0;
			float tailings = 0;
			float concentrates = 0;
			if (type.equalsIgnoreCase("Fines")) {
				fines = quantity;
			} else if (type.equalsIgnoreCase("Lumps")) {
				lumps = quantity;
			} else if (type.equalsIgnoreCase("ROM")) {
				rom = quantity;
			} else if (type.equalsIgnoreCase("Tailings")) {
				tailings = quantity;
			} else if (type.equalsIgnoreCase("Concentrates")) {
				concentrates = quantity;
			}
			if (finesQ >= fines && lumpsQ >= lumps && romQ >= rom) {
				pstmt = con.prepareStatement(IronMiningStatement.DELETE_LOT_DETAILS);
				pstmt.setString(1, remarks);
				pstmt.setInt(2, userId);
				pstmt.setInt(3, id);
				inserted = pstmt.executeUpdate();
				if (inserted > 0) {
					pstmt = con.prepareStatement(IronMiningStatement.GET_STOCK_DETAILS, ResultSet.TYPE_SCROLL_SENSITIVE,
							ResultSet.CONCUR_UPDATABLE);
					pstmt.setInt(1, systemId);
					pstmt.setInt(2, customerId);
					pstmt.setInt(3, lotLoc);
					pstmt.setInt(4, orgId);
					pstmt.setString(5, "Iron Ore(E-Auction)");
					rs = pstmt.executeQuery();
					if (rs.next()) {
						rs.updateDouble("ROM_QTY", rs.getFloat("ROM_QTY") - rom);
						rs.updateDouble("LUMPS", rs.getFloat("LUMPS") - lumps);
						rs.updateDouble("FINES", rs.getFloat("FINES") - fines);
						rs.updateDouble("TAILINGS", rs.getFloat("TAILINGS") - tailings);
						rs.updateDouble("CONCENTRATES", rs.getFloat("CONCENTRATES") - concentrates);
						rs.updateRow();
					}
					message = "Lot Allocation Details Cancelled successfully";
				} else {
					message = "Error while cancelling Lot Allocation details";
				}
			} else {
				message = "Insufficient quantity in Stock.Cant cancel";
			}
		} catch (Exception e) {
			e.printStackTrace();
			message = "Error while cancelling Lot Allocation details";
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return message;
	}

	public ArrayList<Object> getOverSpeedDebarringDetails(int customerId, int systemId, String startDate,
			String endDate) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		ArrayList<ReportHelper> reportsList = new ArrayList<ReportHelper>();
		ArrayList<String> headersList = new ArrayList<String>();
		ReportHelper finalreporthelper = new ReportHelper();
		ArrayList<Object> finalList = new ArrayList<Object>();
		SimpleDateFormat d_M_y_H_m_s = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
		headersList.add("SLNO");
		headersList.add("");
		headersList.add("Vehicle Number");
		headersList.add("Alert Count");
		headersList.add("No Of Days Inactive");
		headersList.add("Inactive Till Date");
		headersList.add("Remarks");
		headersList.add("Status");
		headersList.add("Updated Time");
		headersList.add("Updated By");
		headersList.add("uid");
		ReportHelper reporthelper = null;
		ArrayList<Object> informationList = null;
		JSONArray JsonArray = new JSONArray();
		JSONObject JsonObject = null;
		try {
			int count = 0;
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(IronMiningStatement.GET_OVERSPEED_DEBARRING_DETAILS);
			pstmt.setString(1, startDate);
			pstmt.setString(2, endDate);
			pstmt.setInt(3, systemId);
			pstmt.setInt(4, customerId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				reporthelper = new ReportHelper();
				informationList = new ArrayList<Object>();
				JsonObject = new JSONObject();
				count++;
				JsonObject.put("slnoIndex", count);
				informationList.add(count);
				informationList.add("");

				JsonObject.put("vehicleNoInd", rs.getString("ASSET_NO"));
				informationList.add(rs.getString("ASSET_NO"));

				JsonObject.put("alertCountInd", rs.getInt("COUNT"));
				informationList.add(rs.getInt("COUNT"));

				JsonObject.put("noOfDaysInactiveInd", rs.getInt("NO_OF_DAYS"));
				informationList.add(rs.getInt("NO_OF_DAYS"));

				JsonObject.put("inactiveUptoInd", sdf.format(rs.getTimestamp("BLOCKED_TILL_DATE")));
				informationList.add(sdf.format(rs.getTimestamp("BLOCKED_TILL_DATE")));

				JsonObject.put("remarksInd", rs.getString("REMARKS"));
				informationList.add(rs.getString("REMARKS"));

				JsonObject.put("statusInd", rs.getString("STATUS"));
				informationList.add(rs.getString("STATUS"));

				java.sql.Timestamp updatedTime = rs.getTimestamp("UPDATED_DATETIME");
				JsonObject.put("updatedTimeInd", updatedTime != null ? d_M_y_H_m_s.format(updatedTime) : "");
				informationList.add(updatedTime != null ? d_M_y_H_m_s.format(updatedTime) : "");

				JsonObject.put("updatedByInd", rs.getString("UPDATED_BY"));
				informationList.add(rs.getString("UPDATED_BY"));

				JsonObject.put("uidInd", rs.getInt("ID"));
				informationList.add(rs.getInt("ID"));

				JsonObject.put("enrollIdInd", rs.getInt("ASSET_ENROLL_ID"));

				reporthelper.setInformationList(informationList);
				reportsList.add(reporthelper);
				JsonArray.put(JsonObject);
			}
			finalreporthelper.setReportsList(reportsList);
			finalreporthelper.setHeadersList(headersList);
			finalList.add(JsonArray);
			finalList.add(finalreporthelper);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return finalList;
	}

	public String makeActiveSelectedVehicles(int customerId, int systemId, int userId, JSONArray js, String remarks) {
		Connection con = null;
		PreparedStatement pstmt = null;
		int updated = 0;
		String message = "";
		try {
			con = DBConnection.getConnectionToDB("AMS");
			String idString = "";
			for (int i = 0; i < js.length(); i++) {
				JSONObject obj = js.getJSONObject(i);
				idString += obj.getInt("uidInd") + ",";
				pstmt = con.prepareStatement(IronMiningStatement.UPDATE_STATUS_IN_MINING_ASSET_ENROLLMENT);
				pstmt.setInt(1, obj.getInt("enrollIdInd"));
				pstmt.setString(2, obj.getString("vehicleNoInd"));
				pstmt.setInt(3, customerId);
				pstmt.executeUpdate();
			}
			idString = idString.substring(0, idString.length() - 1);

			pstmt = con.prepareStatement(IronMiningStatement.UPDATE_REMARKS_IN_OVERSPEED_DEBARRING.replace("##",
					"ID in (" + idString + ") and "));
			pstmt.setString(1, remarks);
			pstmt.setInt(2, userId);
			pstmt.setInt(3, customerId);
			pstmt.setInt(4, systemId);
			updated = pstmt.executeUpdate();
			if (updated == 1) {
				message = 1 + " Vehicle Activated Successfully";
			} else if (updated > 1) {
				message = updated + " Vehicles Activated Successfully";
			}

		} catch (Exception e) {
			message = "Error while Activation.";
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, null);
		}
		return message;
	}

	public String addSelfConsumptionDetails(int customerId, int systemId, int tcId, int orgId, int permitId,
			float ROMQuantity, int userId, String vehicleNo) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String message = "";
		int inserted = 0;
		float permitUsedQty = 0;
		float permitQty = 0;
		String mineralType = "";
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(IronMiningStatement.GET_ACTUAL_PERMIT_QTY);
			pstmt.setInt(1, permitId);
			pstmt.setInt(2, systemId);
			pstmt.setInt(3, customerId);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				permitUsedQty = rs.getFloat("TRIPSHEET_QTY");
				permitQty = rs.getFloat("PERMIT_QUANTITY");
				mineralType = rs.getString("MINERAL");
			}
			float actualPermitBal = permitQty - permitUsedQty;
			//float ROMQuantityinTons=ROMQuantity/1000;
			if (actualPermitBal >= ROMQuantity) {
				pstmt = con.prepareStatement(IronMiningStatement.SAVE_SELF_CONSUMPTION_DETAILS);
				pstmt.setInt(1, tcId);
				pstmt.setInt(2, orgId);
				pstmt.setInt(3, permitId);
				pstmt.setFloat(4, ROMQuantity);
				pstmt.setInt(5, systemId);
				pstmt.setInt(6, customerId);
				pstmt.setInt(7, userId);
				pstmt.setString(8, vehicleNo);
				inserted = pstmt.executeUpdate();
				if (inserted > 0) {
					message = "Trip feed details saved successfully";
					pstmt = con.prepareStatement(IronMiningStatement.UPDATE_TRIPSHEET_QTY_FOR_RTP);
					pstmt.setFloat(1, ROMQuantity * 1000);
					pstmt.setInt(2, permitId);
					pstmt.executeUpdate();
				} else {
					message = "Error while saving Self Consumption details";
				}
			} else {
				message = "Permit Balance is over. Please change permit";
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}

		return message;
	}

	public String addMotherRouteDetails(int systemId, int custId, int userId, String mRouteName, int tsLimit) {

		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String message = "";

		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(IronMiningStatement.CHECK_MOTHER_ROUTE_ALREADY_EXIST);
			pstmt.setString(1, mRouteName);
			pstmt.setInt(2, custId);
			pstmt.setInt(3, systemId);
			rs = pstmt.executeQuery();
			if (!rs.next()) {
				pstmt = con.prepareStatement(IronMiningStatement.INSERT_MOTHER_ROUTE_MASTER);
				pstmt.setString(1, mRouteName);
				pstmt.setInt(2, tsLimit);
				pstmt.setString(3, "Active");
				pstmt.setInt(4, systemId);
				pstmt.setInt(5, custId);
				pstmt.setInt(6, userId);
				int inserted = pstmt.executeUpdate();
				if (inserted > 0) {
					message = "Saved Successfully";
				}
			} else {
				message = "Mother Route Name Already Exists";
			}
		} catch (Exception e) {
			System.out.println("error in:-save Mother Route Master Details " + e.toString());
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return message;
	}

	public String modifyMotherRouteDetails(int systemId, int custId, int userId, String mRouteName, int tsLimit,
			int id) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String message = "";

		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(IronMiningStatement.CHECK_MOTHER_ROUTE_ALREADY_EXIST + " and ID!=?");
			pstmt.setString(1, mRouteName);
			pstmt.setInt(2, custId);
			pstmt.setInt(3, systemId);
			pstmt.setInt(4, id);
			rs = pstmt.executeQuery();
			if (!rs.next()) {
				pstmt = con.prepareStatement(IronMiningStatement.UPDATE_MOTHER_ROUTE_MASTER);
				pstmt.setString(1, mRouteName);
				pstmt.setInt(2, tsLimit);
				pstmt.setInt(3, userId);
				pstmt.setInt(4, id);
				int inserted = pstmt.executeUpdate();
				if (inserted > 0) {
					message = "Updated Successfully";
				}
			} else {
				message = "Mother Route Name Already Exists";
			}
		} catch (Exception e) {
			System.out.println("error in:-modify Mother Route Master Details " + e.toString());
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return message;
	}

	public ArrayList getMotherRouteMaster(int systemId, int customerId) {
		JSONArray JsonArray = new JSONArray();
		JSONObject JsonObject = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int slcount = 0;
		ArrayList<Object> finlist = new ArrayList<Object>();
		ArrayList<ReportHelper> reportsList = new ArrayList<ReportHelper>();
		ArrayList<String> headersList = new ArrayList<String>();
		ReportHelper finalreporthelper = new ReportHelper();
		SimpleDateFormat diffddMMyyyyHHmmss = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
		headersList.add("Sl No");
		headersList.add("Mother Route Name");
		headersList.add("Mother Route Density");
		headersList.add("Status");
		headersList.add("Reason for Inactive");
		headersList.add("Activated/Inactivated Time");
		headersList.add("Activated/Inactivated By");
		headersList.add("Inserted Time");
		headersList.add("Inserted By");
		headersList.add("Updated Time");
		headersList.add("Updated By");
		headersList.add("uid");
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(IronMiningStatement.GET_MOTHER_ROUTE_MASTER);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, customerId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				JsonObject = new JSONObject();
				ArrayList<Object> informationList = new ArrayList<Object>();
				ReportHelper reporthelper = new ReportHelper();
				slcount++;
				JsonObject.put("slnoIndex", slcount);
				informationList.add(slcount);

				JsonObject.put("mRouteNameInd", rs.getString("MOTHER_ROUTE_NAME"));
				informationList.add(rs.getString("MOTHER_ROUTE_NAME"));

				JsonObject.put("tsLimitInd", rs.getInt("MOTHER_ROUTE_TS_LIMIT"));
				informationList.add(rs.getInt("MOTHER_ROUTE_TS_LIMIT"));

				JsonObject.put("statusInd", rs.getString("STATUS"));
				informationList.add(rs.getString("STATUS"));

				JsonObject.put("inactiveReasonInd", rs.getString("INACTIVE_REASON"));
				informationList.add(rs.getString("INACTIVE_REASON"));

				if (rs.getTimestamp("ACTIVE_INACTIVE_DT") == null) {
					JsonObject.put("statusChangedTimeInd", "");
					informationList.add("");
				} else {
					JsonObject.put("statusChangedTimeInd", rs.getTimestamp("ACTIVE_INACTIVE_DT"));
					informationList.add(diffddMMyyyyHHmmss.format(rs.getTimestamp("ACTIVE_INACTIVE_DT")));
				}

				JsonObject.put("statusChangedByInd", rs.getString("ACTIVE_INACTIVE_BY"));
				informationList.add(rs.getString("ACTIVE_INACTIVE_BY"));

				if (rs.getTimestamp("INSERTED_DATETIME") == null) {
					JsonObject.put("insertedTimeInd", "");
					informationList.add("");
				} else {
					JsonObject.put("insertedTimeInd", rs.getTimestamp("INSERTED_DATETIME"));
					informationList.add(diffddMMyyyyHHmmss.format(rs.getTimestamp("INSERTED_DATETIME")));
				}

				JsonObject.put("insertedByInd", rs.getString("INSERTED_BY"));
				informationList.add(rs.getString("INSERTED_BY"));

				if (rs.getTimestamp("UPDATED_DATETIME") == null) {
					JsonObject.put("updatedTimeInd", "");
					informationList.add("");
				} else {
					JsonObject.put("updatedTimeInd", rs.getTimestamp("UPDATED_DATETIME"));
					informationList.add(diffddMMyyyyHHmmss.format(rs.getTimestamp("UPDATED_DATETIME")));
				}

				JsonObject.put("updatedByInd", rs.getString("UPDATED_BY"));
				informationList.add(rs.getString("UPDATED_BY"));

				JsonObject.put("uidInd", rs.getInt("ID"));
				informationList.add(rs.getInt("ID"));

				JsonArray.put(JsonObject);
				reporthelper.setInformationList(informationList);
				reportsList.add(reporthelper);
			}
			finlist.add(JsonArray);
			finalreporthelper.setReportsList(reportsList);
			finalreporthelper.setHeadersList(headersList);
			finlist.add(finalreporthelper);

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return finlist;
	}

	public JSONArray getUsedTripsheetCount(int motherRouteId) {
		JSONArray JsonArray = new JSONArray();
		JSONObject JsonObject = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int totalTripSheetCount = 0;
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(IronMiningStatement.GET_ROUTE_MASTER_TOTAL_COUNT_DETAILS);
			pstmt.setInt(1, motherRouteId);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				totalTripSheetCount = rs.getInt("TOTAL_TRIPSHEET_COUNT");
			}
			JsonObject = new JSONObject();
			JsonObject.put("usedTripsheetCount", totalTripSheetCount);
			JsonArray.put(JsonObject);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return JsonArray;
	}

	public String changeSubRoutesStatusForMotherRoute(String inactiveReason, String currStatus, int userId,
			int motherRouteId) {
		Connection con = null;
		PreparedStatement pstmt = null;
		String message = "";
		String status = null;
		try {
			con = DBConnection.getConnectionToDB("AMS");
			if (currStatus.equalsIgnoreCase("Active")) {
				status = "Inactive";
				pstmt = con.prepareStatement(
						IronMiningStatement.UPDATE_STATUS_FOR_MOTHER_ROUTE.replace("#", ",INACTIVE_REASON=?"));
				pstmt.setString(1, status);
				pstmt.setInt(2, userId);
				pstmt.setString(3, inactiveReason);
				pstmt.setInt(4, motherRouteId);
			} else {
				status = "Active";
				pstmt = con.prepareStatement(IronMiningStatement.UPDATE_STATUS_FOR_MOTHER_ROUTE.replace("#", ""));
				pstmt.setString(1, status);
				pstmt.setInt(2, userId);
				pstmt.setInt(3, motherRouteId);
			}
			int updated = pstmt.executeUpdate();
			if (updated > 0) {
				pstmt = con.prepareStatement(IronMiningStatement.UPDATE_ROUTE_MASTER_STATUS_FOR_MOTHER_ROUTE);
				pstmt.setString(1, status);
				pstmt.setInt(2, motherRouteId);
				pstmt.executeUpdate();
				message = "Sub Routes " + status.substring(0, status.length() - 1) + "ated successfully";
			} else {
				message = "error";
			}

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, null);
		}
		return message;
	}

	//**********************************Production Master ************************************//
	public ArrayList<Object> getProductMasterDetails(int systemId, int customerId, int userId, String startDate,
			String endDate) {
		JSONArray JsonArray = new JSONArray();
		JSONObject JsonObject = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int slcount = 0;
		ReportHelper finalreporthelper = new ReportHelper();
		ArrayList<Object> finlist = new ArrayList<Object>();
		ArrayList<ReportHelper> reportsList = new ArrayList<ReportHelper>();
		ArrayList<String> headersList = new ArrayList<String>();
		SimpleDateFormat ddMMyyyy = new SimpleDateFormat("dd-MM-yyyy");
		DecimalFormat df = new DecimalFormat("##0.00");
		headersList.add("Sl No");
		headersList.add("Organization Name");
		headersList.add("Organization Code");
		headersList.add("TC Number");
		headersList.add("Date");
		headersList.add("Production of the Day");
		headersList.add("uid");
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(IronMiningStatement.GET_PRODUCTION_MASTER_DETAILS);
			pstmt.setInt(1, customerId);
			pstmt.setInt(2, systemId);
			pstmt.setString(3, startDate);
			pstmt.setString(4, endDate);
			pstmt.setInt(5, userId);
			pstmt.setInt(6, userId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				ArrayList<Object> informationList = new ArrayList<Object>();
				ReportHelper reporthelper = new ReportHelper();
				JsonObject = new JSONObject();
				slcount++;
				JsonObject.put("slnoIndex", slcount);
				informationList.add(slcount);

				JsonObject.put("orgIdInd", rs.getString("ORG_ID"));
				JsonObject.put("orgNameInd", rs.getString("ORGANIZATION_NAME"));
				informationList.add(rs.getString("ORGANIZATION_NAME"));

				JsonObject.put("orgCodeInd", rs.getString("ORGANIZATION_CODE"));
				informationList.add(rs.getString("ORGANIZATION_CODE"));

				JsonObject.put("tcIdInd", rs.getString("TC_ID"));
				JsonObject.put("tcNoInd", rs.getString("TC_NO"));
				informationList.add(rs.getString("TC_NO"));

				if (rs.getTimestamp("DATE") == null) {
					JsonObject.put("dateInd", "");
					informationList.add("");
				} else {
					JsonObject.put("dateInd", ddMMyyyy.format(rs.getTimestamp("DATE")));
					informationList.add(ddMMyyyy.format(rs.getTimestamp("DATE")));
				}

				JsonObject.put("productionInd", df.format(rs.getDouble("PRODUCTION_QTY")));
				informationList.add(df.format(rs.getDouble("PRODUCTION_QTY")));

				JsonObject.put("uidInd", rs.getString("UID"));
				informationList.add(rs.getString("UID"));

				JsonObject.put("isLatestInd", rs.getString("IS_LATEST"));

				JsonArray.put(JsonObject);
				reporthelper.setInformationList(informationList);
				reportsList.add(reporthelper);
			}
			finlist.add(JsonArray);
			finalreporthelper.setReportsList(reportsList);
			finalreporthelper.setHeadersList(headersList);
			finlist.add(finalreporthelper);

		} catch (Exception e) {
			e.printStackTrace();
		} finally {

			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return finlist;
	}

	public String saveProductionMaster(int orgId, int tcId, double productionQty, String date, int systamId, int custId,
			int userId) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String message = "";
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(IronMiningStatement.CHECK_PRODUCTION_MASTER);
			pstmt.setInt(1, tcId);
			pstmt.setInt(2, orgId);
			pstmt.setString(3, date);
			pstmt.setInt(4, custId);
			rs = pstmt.executeQuery();
			if (!rs.next()) {
				pstmt = con.prepareStatement(IronMiningStatement.INSERT_PRODUCTION_MASTER);
				pstmt.setInt(1, orgId);
				pstmt.setInt(2, tcId);
				pstmt.setDouble(3, productionQty);
				pstmt.setString(4, date);
				pstmt.setInt(5, userId);
				pstmt.setInt(6, custId);
				pstmt.setInt(7, systamId);
				int inserted = pstmt.executeUpdate();
				if (inserted > 0) {
					message = "Saved Successfully";
				} else {
					message = "Error in Saving";
				}
			} else {
				message = "Record is already existed for the same Date.";
			}

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, null);
		}

		return message;
	}

	public String upateProductionMaster(int orgId, int tcId, double productionQty, int userId, int id) {
		Connection con = null;
		PreparedStatement pstmt = null;
		String message = "";
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(IronMiningStatement.UPDATE_PRODUCTION_MASTER);
			pstmt.setInt(1, userId);
			pstmt.setDouble(2, productionQty);
			pstmt.setInt(3, id);
			int updated = pstmt.executeUpdate();
			if (updated > 0) {
				message = "Updated Successfully";
			} else {
				message = "Error in Update";
			}

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, null);
		}

		return message;
	}

	public JSONArray getOrgNamesForProductionMaster(int systemId, int custId, int userId) {
		JSONArray JsonArray = new JSONArray();
		JSONObject jObj = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(IronMiningStatement.GET_ORG_NAMES_FOR_PRODUCTION_MASTER);
			pstmt.setInt(1, userId);
			pstmt.setInt(2, custId);
			pstmt.setInt(3, systemId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				jObj = new JSONObject();
				jObj.put("ORG_ID", rs.getInt("ORG_ID"));
				jObj.put("ORG_CODE", rs.getString("ORG_CODE"));
				jObj.put("ORG_NAME", rs.getString("ORG_NAME"));
				JsonArray.put(jObj);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return JsonArray;
	}

	public JSONArray getTNoForProductionMaster(int systemId, int customerId, int userId, int orgId) {
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			con = DBConnection.getConnectionToDB("AMS");
			jsonArray = new JSONArray();
			jsonObject = new JSONObject();
			pstmt = con.prepareStatement(IronMiningStatement.GET_TC_FOR_PRODUCTION_MASTER);
			pstmt.setInt(1, orgId);
			pstmt.setInt(2, customerId);
			pstmt.setInt(3, userId);
			pstmt.setInt(4, userId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				jsonObject = new JSONObject();
				jsonObject.put("TcId", rs.getString("TC_ID"));
				jsonObject.put("TCNumber", rs.getString("TC_NO"));
				jsonObject.put("MPL_Allocate", rs.getDouble("EC_CAPPING_LIMIT"));
				jsonObject.put("totalProductionQty", rs.getDouble("TOTAL_PRODUCTION_QTY"));
				jsonArray.put(jsonObject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jsonArray;

	}

	public ArrayList<Object> getProductSummaryDetails(int systemId, int customerId, int userId,String startDate,String endDate) {
		JSONArray JsonArray = new JSONArray();
		JSONObject JsonObject = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int slcount = 0;
		ReportHelper finalreporthelper = new ReportHelper();
		ArrayList<Object> finlist = new ArrayList<Object>();
		ArrayList<ReportHelper> reportsList = new ArrayList<ReportHelper>();
		ArrayList<String> headersList = new ArrayList<String>();
		DecimalFormat df = new DecimalFormat("##0.00");
		headersList.add("SlNo");
		headersList.add("Organization Name");
		headersList.add("Organization Code");
		headersList.add("TC Number");
		headersList.add("Production Quantity");
		try {
			con = DBConnection.getConnectionToDB("AMS");
			if(!startDate.equals("")&&!endDate.equals("")){
				pstmt = con.prepareStatement(IronMiningStatement.GET_PRODUCTION_SUMMARY_DETAILS.replace("$", "and a.DATE between dateadd(mi,0,?) and dateadd(ss,-1,?)"));
				pstmt.setInt(1, customerId);
				pstmt.setInt(2, systemId);
				pstmt.setString(3, startDate);
				pstmt.setString(4, endDate);
				pstmt.setInt(5, userId);
				pstmt.setInt(6, userId);
			}
			else
			{
				pstmt = con.prepareStatement(IronMiningStatement.GET_PRODUCTION_SUMMARY_DETAILS.replace("$", ""));
				pstmt.setInt(1, customerId);
				pstmt.setInt(2, systemId);
				pstmt.setInt(3, userId);
				pstmt.setInt(4, userId);
			}
			rs = pstmt.executeQuery();
			while (rs.next()) {
				ArrayList<Object> informationList = new ArrayList<Object>();
				ReportHelper reporthelper = new ReportHelper();
				JsonObject = new JSONObject();
				slcount++;
				JsonObject.put("slnoIndex", slcount);
				informationList.add(slcount);

				JsonObject.put("orgIdInd", rs.getString("ORG_ID"));
				JsonObject.put("orgNameInd", rs.getString("ORGANIZATION_NAME"));
				informationList.add(rs.getString("ORGANIZATION_NAME"));

				JsonObject.put("orgCodeInd", rs.getString("ORGANIZATION_CODE"));
				informationList.add(rs.getString("ORGANIZATION_CODE"));

				JsonObject.put("tcIdInd", rs.getString("TC_ID"));
				JsonObject.put("tcNoInd", rs.getString("TC_NO"));
				informationList.add(rs.getString("TC_NO"));

				JsonObject.put("productionQtyInd", df.format(rs.getDouble("TOTAL_PRODUCTION_QTY")));
				informationList.add(df.format(rs.getDouble("TOTAL_PRODUCTION_QTY")));

				JsonArray.put(JsonObject);
				reporthelper.setInformationList(informationList);
				reportsList.add(reporthelper);
			}
			finlist.add(JsonArray);
			finalreporthelper.setReportsList(reportsList);
			finalreporthelper.setHeadersList(headersList);
			finlist.add(finalreporthelper);

		} catch (Exception e) {
			e.printStackTrace();
		} finally {

			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return finlist;
	}

	public JSONArray getDashBoardCounts(int systemId, int CustomerId, int userId) {

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Connection connection = null;
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject = new JSONObject();
		DecimalFormat df = new DecimalFormat("##0.000");

		try {
			connection = DBConnection.getConnectionToDB("AMS");
			try {
				pstmt = connection.prepareStatement(IronMiningStatement.GET_CHALLAN_QUANTITY);
				pstmt.setInt(1, systemId);
				pstmt.setInt(2, CustomerId);
				pstmt.setInt(3, userId);
				pstmt.setInt(4, userId);
				rs = pstmt.executeQuery();
				while (rs.next()) {
					jsonObject.put("royalty", df.format(rs.getDouble("ROYALITY")));
					jsonObject.put("giopf", df.format(rs.getDouble("GIOPF")));
					jsonObject.put("dmf", df.format(rs.getDouble("DMF")));
					jsonObject.put("nmet", df.format(rs.getDouble("NMET")));
				}
			} catch (Exception e) {
				e.printStackTrace();
			} finally {
				DBConnection.releaseConnectionToDB(null, pstmt, rs);
			}
			try {
				pstmt = connection.prepareStatement(IronMiningStatement.GET_PERMIT_QUANTITIES);
				pstmt.setInt(1, systemId);
				pstmt.setInt(2, CustomerId);
				pstmt.setInt(3, userId);
				pstmt.setInt(4, userId);
				pstmt.setInt(5, systemId);
				pstmt.setInt(6, CustomerId);
				pstmt.setInt(7, userId);
				pstmt.setInt(8, userId);
				pstmt.setInt(9, systemId);
				pstmt.setInt(10, CustomerId);
				pstmt.setInt(11, userId);
				pstmt.setInt(12, userId);
				pstmt.setInt(13, systemId);
				pstmt.setInt(14, CustomerId);
				pstmt.setInt(15, userId);
				pstmt.setInt(16, userId);

				rs = pstmt.executeQuery();
				while (rs.next()) {
					jsonObject.put(rs.getString("TYPE"), rs.getString("QTY"));
				}
			} catch (Exception e) {
				e.printStackTrace();
			} finally {
				DBConnection.releaseConnectionToDB(null, pstmt, rs);
			}

			try {
				pstmt = connection.prepareStatement(IronMiningStatement.GET_PRODUCTION);
				pstmt.setInt(1, CustomerId);
				pstmt.setInt(2, systemId);
				pstmt.setInt(3, userId);
				pstmt.setInt(4, userId);

				rs = pstmt.executeQuery();
				if (rs.next()) {
					jsonObject.put("productionQty", rs.getString("PRODUCTION_QTY"));
				} else {
					jsonObject.put("productionQty", 0);
				}
			} catch (Exception e) {
				e.printStackTrace();
			} finally {
				DBConnection.releaseConnectionToDB(null, pstmt, rs);
			}

			try {
				pstmt = connection.prepareStatement(IronMiningStatement.GET_ORG_COUNT);
				pstmt.setInt(1, systemId);
				pstmt.setInt(2, CustomerId);
				pstmt.setInt(3, userId);
				pstmt.setInt(4, systemId);
				pstmt.setInt(5, CustomerId);
				pstmt.setInt(6, userId);
				pstmt.setInt(7, systemId);
				pstmt.setInt(8, CustomerId);
				pstmt.setInt(9, userId);

				rs = pstmt.executeQuery();
				while (rs.next()) {
					jsonObject.put(rs.getString("TYPE"), rs.getInt("COUNT"));
				}
			} catch (Exception e) {
				e.printStackTrace();
			} finally {
				DBConnection.releaseConnectionToDB(null, pstmt, rs);
			}

			try {
				pstmt = connection.prepareStatement(IronMiningStatement.GET_DOMESTIC_CONSUMPTION);
				pstmt.setInt(1, systemId);
				pstmt.setInt(2, CustomerId);
				pstmt.setInt(3, userId);
				rs = pstmt.executeQuery();
				while (rs.next()) {
					jsonObject.put("domesticConsum", rs.getString("QUANTITY"));
				}
			} catch (Exception e) {
				e.printStackTrace();
			} finally {
				DBConnection.releaseConnectionToDB(null, pstmt, rs);
			}

			jsonArray.put(jsonObject);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(connection, pstmt, rs);
		}
		return jsonArray;
	}

	public JSONArray getGradeDataForChart(int systemId, int CustomerId, int userId, String type, String month,
			String year) {

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Connection connection = null;
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject = new JSONObject();
		DecimalFormat df = new DecimalFormat("##0.00");
		try {
			connection = DBConnection.getConnectionToDB("AMS");
			try {
				pstmt = connection.prepareStatement(IronMiningStatement.GET_IBMRATE);
				pstmt.setString(1, year);
				pstmt.setString(2, type);
				pstmt.setInt(3, CustomerId);
				pstmt.setInt(4, systemId);
				pstmt.setString(5, month);
				rs = pstmt.executeQuery();
				while (rs.next()) {
					jsonObject.put(rs.getString("GRADE").replaceAll("\\s", ""), df.format(rs.getDouble("RATE")));
				}
				jsonArray.put(jsonObject);
			} catch (Exception e) {
				e.printStackTrace();
			} finally {
				DBConnection.releaseConnectionToDB(null, pstmt, rs);
			}
			//************************************************************
			try {
				jsonObject = new JSONObject();
				pstmt = connection.prepareStatement(IronMiningStatement.GET_ROYALTY);
				pstmt.setString(1, year);
				pstmt.setString(2, type);
				pstmt.setInt(3, CustomerId);
				pstmt.setInt(4, systemId);
				pstmt.setString(5, month);
				rs = pstmt.executeQuery();
				while (rs.next()) {
					jsonObject.put(rs.getString("GRADE").replaceAll("\\s", ""), df.format(rs.getDouble("RATE")));
				}
				jsonArray.put(jsonObject);
			} catch (Exception e) {
				e.printStackTrace();
			} finally {
				DBConnection.releaseConnectionToDB(null, pstmt, rs);
			}
			//************************************************************
			try {
				jsonObject = new JSONObject();
				pstmt = connection.prepareStatement(IronMiningStatement.GET_GIOPF);
				pstmt.setString(1, year);
				pstmt.setString(2, type);
				pstmt.setInt(3, CustomerId);
				pstmt.setInt(4, systemId);
				pstmt.setString(5, month);
				rs = pstmt.executeQuery();
				while (rs.next()) {
					jsonObject.put(rs.getString("GRADE").replaceAll("\\s", ""), df.format(rs.getDouble("RATE")));
				}
			} catch (Exception e) {
				e.printStackTrace();
			} finally {
				DBConnection.releaseConnectionToDB(null, pstmt, rs);
			}

			jsonArray.put(jsonObject);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(connection, null, null);
		}
		return jsonArray;
	}

	public JSONArray getProductionSummary(int systemId, int custId, int userId) {

		JSONArray JsonArray = new JSONArray();
		JSONObject JsonObject = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int count = 0;
		DecimalFormat df = new DecimalFormat("##0.0000");
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(IronMiningStatement.GET_PRODUCTION_SUMMARY);
			pstmt.setInt(1, custId);
			pstmt.setInt(2, systemId);
			pstmt.setInt(3, userId);
			pstmt.setInt(4, userId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				JsonObject = new JSONObject();
				JsonObject.put("slNoIndex", ++count);
				JsonObject.put("orgNameIndex", rs.getString("ORGANIZATION_NAME"));
				JsonObject.put("tcNoIndex", rs.getString("TC_NO"));
				JsonObject.put("MplAllocatedIndex", df.format(rs.getDouble("MPL_ALLOCATED")));
				JsonObject.put("prodecedIndex", df.format(rs.getDouble("TOTAL_PRODUCTION_QTY")));
				JsonObject.put("balanceIndex",
						df.format(rs.getDouble("MPL_ALLOCATED") - rs.getDouble("TOTAL_PRODUCTION_QTY")));
				JsonArray.put(JsonObject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return JsonArray;
	}

	public JSONArray getDaywiseProduction(int systemId, int custId, int userId) {

		JSONArray JsonArray = new JSONArray();
		JSONObject JsonObject = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int count = 0;
		DecimalFormat df = new DecimalFormat("##0.00");
		try {
			JsonArray = new JSONArray();
			JsonObject = new JSONObject();
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(IronMiningStatement.GET_DAYWISE_PRODUCTION_SUMMARY);
			pstmt.setInt(1, custId);
			pstmt.setInt(2, systemId);
			pstmt.setInt(3, userId);
			pstmt.setInt(4, userId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				JsonObject = new JSONObject();
				JsonObject.put("slNoIndex", ++count);
				JsonObject.put("orgNameIndex", rs.getString("ORGANIZATION_NAME"));
				JsonObject.put("tcNoIndex", rs.getString("TC_NO"));
				JsonObject.put("MplAllocatedIndex", df.format(rs.getDouble("MPL_ALLOCATED")));
				JsonObject.put("prodecedIndex", df.format(rs.getDouble("PRODUCTION_QTY")));
				JsonObject.put("balanceIndex",
						df.format(rs.getDouble("MPL_ALLOCATED") - rs.getDouble("PRODUCTION_QTY")));

				JsonArray.put(JsonObject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}

		return JsonArray;
	}

	public JSONArray getTripsheetQtyForDasboard(int systemId, int CustomerId, int userId) {

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Connection connection = null;
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject = new JSONObject();
		DecimalFormat df = new DecimalFormat("##0.000");

		try {
			connection = DBConnection.getConnectionToDB("AMS");
			try {
				pstmt = connection.prepareStatement(IronMiningStatement.GET_TRUCK_TRIP_QTY);
				pstmt.setInt(1, systemId);
				pstmt.setInt(2, CustomerId);
				pstmt.setInt(3, userId);
				pstmt.setInt(4, userId);
				pstmt.setInt(5, systemId);
				pstmt.setInt(6, CustomerId);
				pstmt.setInt(7, userId);
				pstmt.setInt(8, userId);
				rs = pstmt.executeQuery();
				while (rs.next()) {
					jsonObject.put("truckTripQty", df.format(rs.getDouble("QUANTITY")));

				}
			} catch (Exception e) {
				e.printStackTrace();
			} finally {
				DBConnection.releaseConnectionToDB(null, pstmt, rs);
			}
			try {
				pstmt = connection.prepareStatement(IronMiningStatement.GET_BARGE_TRIP_QTY);
				pstmt.setInt(1, systemId);
				pstmt.setInt(2, CustomerId);
				pstmt.setInt(3, userId);
				pstmt.setInt(4, systemId);
				rs = pstmt.executeQuery();
				while (rs.next()) {
					jsonObject.put("bargeTripQty", df.format(rs.getDouble("QUANTITY") / 1000));
				}
			} catch (Exception e) {
				e.printStackTrace();
			} finally {
				DBConnection.releaseConnectionToDB(null, pstmt, rs);
			}
			jsonArray.put(jsonObject);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(connection, pstmt, rs);
		}
		return jsonArray;
	}

	public JSONArray getProductionChartData(int systemId, int CustomerId, int userId) {

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Connection connection = null;
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject = new JSONObject();
		DecimalFormat df = new DecimalFormat("##0.000");
		connection = DBConnection.getConnectionToDB("AMS");
		try {
			pstmt = connection.prepareStatement(IronMiningStatement.GET_PRODUCTION_FOR_CHART);
			pstmt.setInt(1, CustomerId);
			pstmt.setInt(2, systemId);
			pstmt.setInt(3, userId);
			pstmt.setInt(4, userId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				jsonObject.put("produced", df.format(rs.getDouble("TOTAL_PRODUCTION_QTY")));
				jsonObject.put("total", df.format(rs.getDouble("TOTAL_ALLOCATION_QTY")));
			}
			jsonArray.put(jsonObject);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(connection, pstmt, rs);
		}
		return jsonArray;
	}

	public JSONArray getGradeData(int systemId, int CustomerId, int userId, String gradeType, String month,
			String year) {

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Connection connection = null;
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject = null;
		DecimalFormat df = new DecimalFormat("##0.000");
		connection = DBConnection.getConnectionToDB("AMS");
		int count = 0;
		try {
			pstmt = connection.prepareStatement(IronMiningStatement.GET_GRADE_DATA);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, CustomerId);
			pstmt.setString(3, month);
			pstmt.setString(4, year);
			pstmt.setString(5, gradeType);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				jsonObject = new JSONObject();
				jsonObject.put("slNoIndex", ++count);
				jsonObject.put("typeIndex", rs.getString("TYPE"));
				jsonObject.put("GradeIndex", rs.getString("GRADE"));
				jsonObject.put("IBMIndex", df.format(rs.getDouble("RATE")));
				jsonObject.put("royaltyIndex", df.format(rs.getDouble("ROYALTY")));
				jsonObject.put("giopfIndex", df.format(rs.getDouble("GIOPF")));
				jsonArray.put(jsonObject);
			}

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(connection, pstmt, rs);
		}
		return jsonArray;
	}

	public JSONArray getRoyaltyForDashBoard(int systemId, int CustomerId, int userId, String month, String year) {

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Connection connection = null;
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject = new JSONObject();
		DecimalFormat df = new DecimalFormat("##0.00");
		try {
			connection = DBConnection.getConnectionToDB("AMS");
			try {
				jsonObject = new JSONObject();
				pstmt = connection.prepareStatement(IronMiningStatement.GET_ROYALTY_FOR_DASHBOARD);
				pstmt.setInt(1, systemId);
				pstmt.setInt(2, CustomerId);
				pstmt.setString(3, month);
				pstmt.setString(4, year);
				pstmt.setInt(5, userId);
				pstmt.setInt(6, userId);

				rs = pstmt.executeQuery();
				while (rs.next()) {
					jsonObject.put(rs.getString("CHALLAN_GRADE").replaceAll("\\s", ""),
							df.format(rs.getDouble("ROYALTY_COLLECTED")));
				}
				jsonArray.put(jsonObject);
				;
			} catch (Exception e) {
				e.printStackTrace();
			} finally {
				DBConnection.releaseConnectionToDB(null, pstmt, rs);
			}
			//************************************************************
			try {
				jsonObject = new JSONObject();
				pstmt = connection.prepareStatement(IronMiningStatement.GET_ROYALTY_FOR_DASHBOARD);
				pstmt.setInt(1, systemId);
				pstmt.setInt(2, CustomerId);
				pstmt.setString(3, month);
				pstmt.setString(4, year);
				pstmt.setInt(5, userId);
				pstmt.setInt(6, userId);

				rs = pstmt.executeQuery();
				while (rs.next()) {
					jsonObject.put(rs.getString("CHALLAN_GRADE").replaceAll("\\s", ""),
							df.format(rs.getDouble("QTY_IN_TONS")));
				}
				jsonArray.put(jsonObject);
			} catch (Exception e) {
				e.printStackTrace();
			} finally {
				DBConnection.releaseConnectionToDB(null, pstmt, rs);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(connection, null, null);
		}
		return jsonArray;
	}

	public JSONArray getOperationType(int systemId, int userId) {
		JSONArray JsonArray = new JSONArray();
		JSONObject JsonObject = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			JsonArray = new JSONArray();
			JsonObject = new JSONObject();
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(IronMiningStatement.GET_PERMIT_NO_FROM_USER_SETTING);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, userId);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				String str = rs.getString("OPERATION_TYPE");
				if (str.equals("A")) {
					JsonObject.put("Name", "APPLICATION");
					JsonObject.put("Value", "APPLICATION");
					JsonArray.put(JsonObject);
				} else if (str.equals("R")) {
					JsonObject.put("Name", "RFID");
					JsonObject.put("Value", "RFID");
					JsonArray.put(JsonObject);
				} else if (str.equals("B")) {
					JsonObject.put("Name", "APPLICATION");
					JsonObject.put("Value", "APPLICATION");
					JsonArray.put(JsonObject);
					JSONObject JsonObject1 = new JSONObject();
					JsonObject1.put("Name", "RFID");
					JsonObject1.put("Value", "RFID");
					JsonArray.put(JsonObject1);
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return JsonArray;
	}

	public JSONArray getVehiclesForTripTransfer(String clientId, int systemId) {
		JSONArray JsonArray = new JSONArray();
		JSONObject JsonObject = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(IronMiningStatement.GET_VEHICLES_FOR_TRIP_TRANSFER);
			pstmt.setInt(1, systemId);
			pstmt.setString(2, clientId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				JsonObject = new JSONObject();
				JsonObject.put("vehicleName", rs.getString("ASSET_NUMBER"));
				JsonObject.put("tripNo", rs.getInt("ID"));
				JsonObject.put("tripSheetNo", rs.getString("TRIP_NO"));
				JsonArray.put(JsonObject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return JsonArray;
	}

	public JSONArray getOrgRoyaltyForDashBoard(int systemId, int CustomerId, int userId, String financialYear) {

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Connection con = null;
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject = new JSONObject();
		DecimalFormat df = new DecimalFormat("##0.00");
		con = DBConnection.getConnectionToDB("AMS");
		int count = 0;
		try {
			if (financialYear.contains("-")) {
				pstmt = con.prepareStatement(IronMiningStatement.GET_ORG_ROYALTY.replace("##",
						"and a.FINANCIAL_YEAR='" + financialYear + "'"));
			} else {
				pstmt = con.prepareStatement(IronMiningStatement.GET_ORG_ROYALTY.replace("##", ""));
			}
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, CustomerId);
			pstmt.setInt(3, userId);
			pstmt.setInt(4, userId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				jsonObject = new JSONObject();
				jsonObject.put("SLNO", ++count);
				jsonObject.put("ORG", rs.getString("ORGANIZATION_NAME"));
				jsonObject.put("ROYALTY", df.format(rs.getDouble("ROYALTY")));
				jsonObject.put("DMF", df.format(rs.getDouble("ROYALTY") * 0.3));
				jsonObject.put("NMET", df.format(rs.getDouble("ROYALTY") * 0.02));
				jsonObject.put("GIOPF", df.format(rs.getDouble("GIOPF")));
				jsonObject.put("PROCESSING FEE", df.format(rs.getDouble("PROCESSING_FEE")));
				jsonArray.put(jsonObject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jsonArray;
	}

	public JSONArray getAccountDetailsForDashBoard(int systemId, int CustomerId, int userId, String financialYear) {

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Connection con = null;
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject = new JSONObject();
		DecimalFormat df = new DecimalFormat("##0.00");
		con = DBConnection.getConnectionToDB("AMS");
		try {
			if (financialYear.contains("-")) {
				pstmt = con.prepareStatement(IronMiningStatement.GET_ACCOUNT_DETAILS.replace("##",
						"and a.FINANCIAL_YEAR='" + financialYear + "'"));
			} else {
				pstmt = con.prepareStatement(IronMiningStatement.GET_ACCOUNT_DETAILS.replace("##", ""));
			}
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, CustomerId);
			pstmt.setInt(3, userId);
			pstmt.setInt(4, userId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				jsonObject = new JSONObject();
				jsonObject.put("ROYALTY", rs.getDouble("ROYALTY"));
				jsonObject.put("DMF", rs.getDouble("ROYALTY") * 0.3);
				jsonObject.put("NMET", rs.getDouble("ROYALTY") * 0.02);
				jsonObject.put("GIOPF", rs.getDouble("GIOPF"));
				jsonObject.put("PROCESSING_FEE", rs.getDouble("PROCESSING_FEE"));
				jsonArray.put(jsonObject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jsonArray;
	}

	public JSONArray getMonthlyAccountDetailsForDashBoard(int systemId, int CustomerId, int userId,
			String financialYear) {

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Connection con = null;
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject = new JSONObject();
		DecimalFormat df = new DecimalFormat("##0.00");
		con = DBConnection.getConnectionToDB("AMS");
		String[] arr = financialYear.split("-");
		if (!financialYear.contains("-")) {
			arr = new String[2];
			arr[0] = "";
			arr[1] = "";
		}
		try {
			jsonArray.put(new JSONObject().put("MONTH", "APR " + arr[0]).put("ROYALTY", 0).put("DMF", 0).put("NMET", 0)
					.put("GIOPF", 0).put("PROCESSING FEE", 0).put("YEAR", arr[0]));//0
			jsonArray.put(new JSONObject().put("MONTH", "MAY " + arr[0]).put("ROYALTY", 0).put("DMF", 0).put("NMET", 0)
					.put("GIOPF", 0).put("PROCESSING FEE", 0).put("YEAR", arr[0]));//1
			jsonArray.put(new JSONObject().put("MONTH", "JUN " + arr[0]).put("ROYALTY", 0).put("DMF", 0).put("NMET", 0)
					.put("GIOPF", 0).put("PROCESSING FEE", 0).put("YEAR", arr[0]));//2
			jsonArray.put(new JSONObject().put("MONTH", "JUL " + arr[0]).put("ROYALTY", 0).put("DMF", 0).put("NMET", 0)
					.put("GIOPF", 0).put("PROCESSING FEE", 0).put("YEAR", arr[0]));//3
			jsonArray.put(new JSONObject().put("MONTH", "AUG " + arr[0]).put("ROYALTY", 0).put("DMF", 0).put("NMET", 0)
					.put("GIOPF", 0).put("PROCESSING FEE", 0).put("YEAR", arr[0]));//4
			jsonArray.put(new JSONObject().put("MONTH", "SEP " + arr[0]).put("ROYALTY", 0).put("DMF", 0).put("NMET", 0)
					.put("GIOPF", 0).put("PROCESSING FEE", 0).put("YEAR", arr[0]));//5
			jsonArray.put(new JSONObject().put("MONTH", "OCT " + arr[0]).put("ROYALTY", 0).put("DMF", 0).put("NMET", 0)
					.put("GIOPF", 0).put("PROCESSING FEE", 0).put("YEAR", arr[0]));//6
			jsonArray.put(new JSONObject().put("MONTH", "NOV " + arr[0]).put("ROYALTY", 0).put("DMF", 0).put("NMET", 0)
					.put("GIOPF", 0).put("PROCESSING FEE", 0).put("YEAR", arr[0]));//7
			jsonArray.put(new JSONObject().put("MONTH", "DEC " + arr[0]).put("ROYALTY", 0).put("DMF", 0).put("NMET", 0)
					.put("GIOPF", 0).put("PROCESSING FEE", 0).put("YEAR", arr[0]));//8
			jsonArray.put(new JSONObject().put("MONTH", "JAN " + arr[1]).put("ROYALTY", 0).put("DMF", 0).put("NMET", 0)
					.put("GIOPF", 0).put("PROCESSING FEE", 0).put("YEAR", arr[1]));//9
			jsonArray.put(new JSONObject().put("MONTH", "FEB " + arr[1]).put("ROYALTY", 0).put("DMF", 0).put("NMET", 0)
					.put("GIOPF", 0).put("PROCESSING FEE", 0).put("YEAR", arr[1]));//10
			jsonArray.put(new JSONObject().put("MONTH", "MAR " + arr[1]).put("ROYALTY", 0).put("DMF", 0).put("NMET", 0)
					.put("GIOPF", 0).put("PROCESSING FEE", 0).put("YEAR", arr[1]));//11
			if (financialYear.contains("-")) {
				pstmt = con.prepareStatement(IronMiningStatement.GET_MONTHLY_ACCOUNT_DETAILS.replace("##",
						"and a.FINANCIAL_YEAR='" + financialYear + "'"));
			} else {
				pstmt = con.prepareStatement(IronMiningStatement.GET_MONTHLY_ACCOUNT_DETAILS.replace("##", ""));
			}
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, CustomerId);
			pstmt.setInt(3, userId);
			pstmt.setInt(4, userId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				JSONObject jObjDB = new JSONObject();
				jObjDB.put("MONTH", rs.getInt("MONTH"));
				double royalty = rs.getDouble("ROYALTY");

				switch (rs.getInt("MONTH")) {
				case 1: {
					jsonObject = jsonArray.getJSONObject(9);
					jsonObject.put("ROYALTY", df.format(royalty));
					jsonObject.put("DMF", df.format(royalty * 0.3));
					jsonObject.put("NMET", df.format(royalty * 0.02));
					jsonObject.put("GIOPF", df.format(rs.getDouble("GIOPF")));
					jsonObject.put("PROCESSING FEE", df.format(rs.getDouble("PROCESSING_FEE")));
					break;
				}
				case 2: {
					jsonObject = jsonArray.getJSONObject(10);
					jsonObject.put("ROYALTY", df.format(royalty));
					jsonObject.put("DMF", df.format(royalty * 0.3));
					jsonObject.put("NMET", df.format(royalty * 0.02));
					jsonObject.put("GIOPF", df.format(rs.getDouble("GIOPF")));
					jsonObject.put("PROCESSING FEE", df.format(rs.getDouble("PROCESSING_FEE")));
					break;
				}
				case 3: {
					jsonObject = jsonArray.getJSONObject(11);
					jsonObject.put("ROYALTY", df.format(royalty));
					jsonObject.put("DMF", df.format(royalty * 0.3));
					jsonObject.put("NMET", df.format(royalty * 0.02));
					jsonObject.put("GIOPF", df.format(rs.getDouble("GIOPF")));
					jsonObject.put("PROCESSING FEE", df.format(rs.getDouble("PROCESSING_FEE")));
					break;
				}
				case 4: {
					jsonObject = jsonArray.getJSONObject(0);
					jsonObject.put("ROYALTY", df.format(royalty));
					jsonObject.put("DMF", df.format(royalty * 0.3));
					jsonObject.put("NMET", df.format(royalty * 0.02));
					jsonObject.put("GIOPF", df.format(rs.getDouble("GIOPF")));
					jsonObject.put("PROCESSING FEE", df.format(rs.getDouble("PROCESSING_FEE")));
					break;
				}
				case 5: {
					jsonObject = jsonArray.getJSONObject(1);
					jsonObject.put("ROYALTY", df.format(royalty));
					jsonObject.put("DMF", df.format(royalty * 0.3));
					jsonObject.put("NMET", df.format(royalty * 0.02));
					jsonObject.put("GIOPF", df.format(rs.getDouble("GIOPF")));
					jsonObject.put("PROCESSING FEE", df.format(rs.getDouble("PROCESSING_FEE")));
					break;
				}
				case 6: {
					jsonObject = jsonArray.getJSONObject(2);
					jsonObject.put("ROYALTY", df.format(royalty));
					jsonObject.put("DMF", df.format(royalty * 0.3));
					jsonObject.put("NMET", df.format(royalty * 0.02));
					jsonObject.put("GIOPF", df.format(rs.getDouble("GIOPF")));
					jsonObject.put("PROCESSING FEE", df.format(rs.getDouble("PROCESSING_FEE")));
					break;
				}
				case 7: {
					jsonObject = jsonArray.getJSONObject(3);
					jsonObject.put("ROYALTY", df.format(royalty));
					jsonObject.put("DMF", df.format(royalty * 0.3));
					jsonObject.put("NMET", df.format(royalty * 0.02));
					jsonObject.put("GIOPF", df.format(rs.getDouble("GIOPF")));
					jsonObject.put("PROCESSING FEE", df.format(rs.getDouble("PROCESSING_FEE")));
					break;
				}
				case 8: {
					jsonObject = jsonArray.getJSONObject(4);
					jsonObject.put("ROYALTY", df.format(royalty));
					jsonObject.put("DMF", df.format(royalty * 0.3));
					jsonObject.put("NMET", df.format(royalty * 0.02));
					jsonObject.put("GIOPF", df.format(rs.getDouble("GIOPF")));
					jsonObject.put("PROCESSING FEE", df.format(rs.getDouble("PROCESSING_FEE")));
					break;
				}
				case 9: {
					jsonObject = jsonArray.getJSONObject(5);
					jsonObject.put("ROYALTY", df.format(royalty));
					jsonObject.put("DMF", df.format(royalty * 0.3));
					jsonObject.put("NMET", df.format(royalty * 0.02));
					jsonObject.put("GIOPF", df.format(rs.getDouble("GIOPF")));
					jsonObject.put("PROCESSING FEE", df.format(rs.getDouble("PROCESSING_FEE")));
					break;
				}
				case 10: {
					jsonObject = jsonArray.getJSONObject(6);
					jsonObject.put("ROYALTY", df.format(royalty));
					jsonObject.put("DMF", df.format(royalty * 0.3));
					jsonObject.put("NMET", df.format(royalty * 0.02));
					jsonObject.put("GIOPF", df.format(rs.getDouble("GIOPF")));
					jsonObject.put("PROCESSING FEE", df.format(rs.getDouble("PROCESSING_FEE")));
					break;
				}
				case 11: {
					jsonObject = jsonArray.getJSONObject(7);
					jsonObject.put("ROYALTY", df.format(royalty));
					jsonObject.put("DMF", df.format(royalty * 0.3));
					jsonObject.put("NMET", df.format(royalty * 0.02));
					jsonObject.put("GIOPF", df.format(rs.getDouble("GIOPF")));
					jsonObject.put("PROCESSING FEE", df.format(rs.getDouble("PROCESSING_FEE")));
					break;
				}
				case 12: {
					jsonObject = jsonArray.getJSONObject(8);
					jsonObject.put("ROYALTY", df.format(royalty));
					jsonObject.put("DMF", df.format(royalty * 0.3));
					jsonObject.put("NMET", df.format(royalty * 0.02));
					jsonObject.put("GIOPF", df.format(rs.getDouble("GIOPF")));
					jsonObject.put("PROCESSING FEE", df.format(rs.getDouble("PROCESSING_FEE")));
					break;
				}
				}

			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jsonArray;
	}

	public JSONArray getLatest7DaysProduction(int systemId, int CustomerId, int userId) {

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Connection con = null;
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject = new JSONObject();
		DecimalFormat df = new DecimalFormat("##0.00");
		con = DBConnection.getConnectionToDB("AMS");
		Date date = new Date();
		//date.setMonth(4);
		//date.setDate(8);
		System.out.println(new SimpleDateFormat("dd MMM yyyy").format(date));
		long currDate = date.getTime();
		SimpleDateFormat sdf = new SimpleDateFormat("dd MMM");
		try {
			jsonArray.put(new JSONObject().put("DAY", 7).put("DATE", sdf.format(new Date(currDate - (7 * 86400000L))))
					.put("PRODUCTION_QTY", 0));//0
			jsonArray.put(new JSONObject().put("DAY", 6).put("DATE", sdf.format(new Date(currDate - (6 * 86400000L))))
					.put("PRODUCTION_QTY", 0));//1
			jsonArray.put(new JSONObject().put("DAY", 5).put("DATE", sdf.format(new Date(currDate - (5 * 86400000L))))
					.put("PRODUCTION_QTY", 0));//2
			jsonArray.put(new JSONObject().put("DAY", 4).put("DATE", sdf.format(new Date(currDate - (4 * 86400000L))))
					.put("PRODUCTION_QTY", 0));//3
			jsonArray.put(new JSONObject().put("DAY", 3).put("DATE", sdf.format(new Date(currDate - (3 * 86400000L))))
					.put("PRODUCTION_QTY", 0));//4
			jsonArray.put(new JSONObject().put("DAY", 2).put("DATE", sdf.format(new Date(currDate - (2 * 86400000L))))
					.put("PRODUCTION_QTY", 0));//5
			jsonArray.put(new JSONObject().put("DAY", 1).put("DATE", sdf.format(new Date(currDate - (1 * 86400000L))))
					.put("PRODUCTION_QTY", 0));//6

			pstmt = con.prepareStatement(IronMiningStatement.GET_LATEST_7DAYS_PRODUCTION);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, CustomerId);
			pstmt.setDate(3, new java.sql.Date(currDate));
			pstmt.setDate(4, new java.sql.Date(currDate));
			pstmt.setInt(5, userId);
			pstmt.setInt(6, userId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				double production = rs.getDouble("PRODUCTION_QTY");
				switch (rs.getInt("DAY")) {
				case 1: {
					jsonObject = jsonArray.getJSONObject(6);
					jsonObject.put("PRODUCTION_QTY", df.format(production));
					break;
				}
				case 2: {
					jsonObject = jsonArray.getJSONObject(5);
					jsonObject.put("PRODUCTION_QTY", df.format(production));
					break;
				}
				case 3: {
					jsonObject = jsonArray.getJSONObject(4);
					jsonObject.put("PRODUCTION_QTY", df.format(production));
					break;
				}
				case 4: {
					jsonObject = jsonArray.getJSONObject(3);
					jsonObject.put("PRODUCTION_QTY", df.format(production));
					break;
				}
				case 5: {
					jsonObject = jsonArray.getJSONObject(2);
					jsonObject.put("PRODUCTION_QTY", df.format(production));
					break;
				}
				case 6: {
					jsonObject = jsonArray.getJSONObject(1);
					jsonObject.put("PRODUCTION_QTY", df.format(production));
					break;
				}
				case 7: {
					jsonObject = jsonArray.getJSONObject(0);
					jsonObject.put("PRODUCTION_QTY", df.format(production));
					break;
				}
				}
			}

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jsonArray;
	}

	public JSONArray getMotherRoute(int customerId, int systemId, String buttonValue, String routeId) {
		JSONArray JsonArray = null;
		JSONObject JsonObject = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			JsonArray = new JSONArray();
			con = DBConnection.getConnectionToDB("AMS");
			if (buttonValue.equalsIgnoreCase("modify")) {
				pstmt = con.prepareStatement(
						IronMiningStatement.GET_MOTHER_ROUTE.replaceAll("&&", "and rd.ID not in (" + routeId + ")"));
				pstmt.setInt(1, systemId);
				pstmt.setInt(2, customerId);
				rs = pstmt.executeQuery();
			} else {
				pstmt = con.prepareStatement(IronMiningStatement.GET_MOTHER_ROUTE.replaceAll("&&", ""));
				pstmt.setInt(1, systemId);
				pstmt.setInt(2, customerId);
				rs = pstmt.executeQuery();
			}

			while (rs.next()) {
				JsonObject = new JSONObject();
				JsonObject.put("motherRouteName", rs.getString("MOTHER_ROUTE_NAME"));
				JsonObject.put("motherRLimit", rs.getInt("MOTHER_ROUTE_TS_LIMIT"));
				JsonObject.put("motherRBal", rs.getInt("MOTHER_ROUTE_TS_LIMIT") - rs.getInt("TOTAL_COUNT"));//Mother Route Balance
				JsonObject.put("id", rs.getInt("ID"));
				JsonArray.put(JsonObject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return JsonArray;
	}

	public JSONArray getTripLimitDetails(int id) {
		JSONArray JsonArray = null;
		JSONObject JsonObject = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int count = 0;
		try {
			JsonArray = new JSONArray();
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(IronMiningStatement.GET_ROUTE_TIME_DETAILS);
			pstmt.setInt(1, id);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				count++;
				JsonObject = new JSONObject();
				JsonObject.put("SLNOIndex", count);
				JsonObject.put("fromTimeIndex", rs.getString("FROM_TIME"));
				JsonObject.put("toTimeIndex", rs.getString("TO_TIME"));
				JsonObject.put("limitIndex", rs.getString("TRIPSHEET_LIMIT"));
				JsonObject.put("uidIndex", rs.getInt("ID"));
				JsonArray.put(JsonObject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return JsonArray;
	}

	public String activeInactiveRoutes(int customerId, int systemId, int userId, int id, String remarks,
			String status) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String message = "";
		int updated = 0;
		String updatedStatus;
		try {
			if (status.equalsIgnoreCase("active")) {
				updatedStatus = "Inactive";
			} else {
				updatedStatus = "Active";
			}
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(IronMiningStatement.UPDATE_STATUS_FOR_SUB_ROUTE);
			pstmt.setString(1, updatedStatus);
			pstmt.setString(2, remarks);
			pstmt.setInt(3, userId);
			pstmt.setInt(4, id);
			updated = pstmt.executeUpdate();
			if (updated > 0) {
				message = "Status updated Successfully";
			} else {
				message = "Error while updating status";
			}
		} catch (Exception e) {
			e.printStackTrace();
			message = "Error while updating status";
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return message;
	}

	public ArrayList<Object> getRouteDensityDetails(int systemId, int custId, int userId) {
		ArrayList<ReportHelper> reportsList = new ArrayList<ReportHelper>();
		ArrayList<String> headersList = new ArrayList<String>();
		ReportHelper finalreporthelper = new ReportHelper();
		ArrayList<Object> finlist = new ArrayList<Object>();
		JSONArray JsonArray = null;
		JSONObject JsonObject = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int count = 0;
		try {
			headersList.add("SL NO");
			headersList.add("ID");
			headersList.add("Route Name");
			headersList.add("Organization Name");
			headersList.add("Mother Route Name");
			headersList.add("Open TripSheet Count");
			headersList.add("Status");
			JsonArray = new JSONArray();

			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(IronMiningStatement.GET_ROUTE_DENSITY_REPORT);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, custId);
			pstmt.setInt(3, systemId);
			pstmt.setInt(4, custId);
			pstmt.setInt(5, userId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				count++;
				ReportHelper reporthelper = new ReportHelper();
				JsonObject = new JSONObject();
				ArrayList<Object> informationList = new ArrayList<Object>();

				JsonObject.put("slnoIndex", count);
				informationList.add(count);

				informationList.add(rs.getInt("ID"));
				JsonObject.put("idIndex", rs.getInt("ID"));

				informationList.add(rs.getString("ROUTE_NAME"));
				JsonObject.put("routeNameIndex", rs.getString("ROUTE_NAME"));

				informationList.add(rs.getString("ORGANIZATION_NAME"));
				JsonObject.put("OrganizationNameIndex", rs.getString("ORGANIZATION_NAME"));

				informationList.add(rs.getString("MOTHER_R_NAME"));
				JsonObject.put("motherRNameNameIndex", rs.getString("MOTHER_R_NAME"));

				informationList.add(rs.getInt("TRIP_COUNT"));
				JsonObject.put("tripsheetCountIndex", rs.getInt("TRIP_COUNT"));

				informationList.add(rs.getString("STATUS"));
				JsonObject.put("statusIndex", rs.getString("STATUS"));

				JsonObject.put("motherRStatus", rs.getString("M_STATUS"));

				JsonArray.put(JsonObject);
				reporthelper.setInformationList(informationList);
				reportsList.add(reporthelper);
			}
			finalreporthelper.setReportsList(reportsList);
			finalreporthelper.setHeadersList(headersList);
			finlist.add(JsonArray);
			finlist.add(finalreporthelper);

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return finlist;
	}

	public ArrayList<Object> getRouteTripDetails(int systemId, int custId, int userId, int routeId) {
		ArrayList<ReportHelper> reportsList = new ArrayList<ReportHelper>();
		ArrayList<String> headersList = new ArrayList<String>();
		ReportHelper finalreporthelper = new ReportHelper();
		ArrayList<Object> finlist = new ArrayList<Object>();
		SimpleDateFormat diffddMMyyyyHHmmss = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
		JSONArray JsonArray = null;
		JSONObject JsonObject = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int count = 0;
		try {
			headersList.add("SL NO");
			headersList.add("TripSheet No");
			headersList.add("Vehicle No");
			headersList.add("Inserted DateTime");
			headersList.add("Route Name");
			headersList.add("Quantity");
			JsonArray = new JSONArray();

			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(IronMiningStatement.GET_ROUTE_TRIP_DETAILS);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, custId);
			pstmt.setInt(3, routeId);
			pstmt.setInt(4, userId);
			pstmt.setInt(5, userId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				count++;
				ReportHelper reporthelper = new ReportHelper();
				JsonObject = new JSONObject();
				ArrayList<Object> informationList = new ArrayList<Object>();

				JsonObject.put("slnoIndex", count);
				informationList.add(count);

				informationList.add(rs.getString("TRIP_NO"));
				JsonObject.put("tripNoIndex", rs.getString("TRIP_NO"));

				informationList.add(rs.getString("ASSET_NUMBER"));
				JsonObject.put("vehicleNoIndex", rs.getString("ASSET_NUMBER"));

				JsonObject.put("issuedDateIndex", diffddMMyyyyHHmmss.format(rs.getTimestamp(("ISSUE_DATE"))));
				informationList.add(diffddMMyyyyHHmmss.format(rs.getTimestamp(("ISSUE_DATE"))));

				informationList.add(rs.getString("ROUTE_NAME"));
				JsonObject.put("routeNameIndex", rs.getString("ROUTE_NAME"));

				informationList.add(rs.getFloat("QUANTITY"));
				JsonObject.put("qtyIndex", rs.getFloat("QUANTITY"));

				JsonArray.put(JsonObject);
				reporthelper.setInformationList(informationList);
				reportsList.add(reporthelper);
			}
			finalreporthelper.setReportsList(reportsList);
			finalreporthelper.setHeadersList(headersList);
			finlist.add(JsonArray);
			finlist.add(finalreporthelper);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return finlist;
	}

	public ArrayList<Object> getWalletReconciliationReport(int systemId, int custId, int orgId) {
		ArrayList<ReportHelper> reportsList = new ArrayList<ReportHelper>();
		ArrayList<String> headersList = new ArrayList<String>();
		ReportHelper finalreporthelper = new ReportHelper();
		ArrayList<Object> finlist = new ArrayList<Object>();
		JSONArray JsonArray = null;
		JSONObject JsonObject = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int count = 0;
		SimpleDateFormat diffddMMyyyyHHmmss = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
		try {
			headersList.add("SLNO");
			headersList.add("Challan/Permit No");
			headersList.add("Type");
			headersList.add("Date");
			headersList.add("Organization Name");
			headersList.add("Quantity");
			headersList.add("Rate");
			headersList.add("Credit Amount");
			headersList.add("Debit Amount");

			JsonArray = new JSONArray();

			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(IronMiningStatement.GET_WALLET_RECONCILIATION_REPORT);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, custId);
			pstmt.setInt(3, orgId);
			pstmt.setInt(4, systemId);
			pstmt.setInt(5, custId);
			pstmt.setInt(6, orgId);
			pstmt.setInt(7, orgId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				count++;
				ReportHelper reporthelper = new ReportHelper();
				JsonObject = new JSONObject();
				ArrayList<Object> informationList = new ArrayList<Object>();

				JsonObject.put("slnoIndex", count);
				informationList.add(count);

				informationList.add(rs.getString("NUMBER"));
				JsonObject.put("challanPermitIndex", rs.getString("NUMBER"));

				informationList.add(rs.getString("TYPE"));
				JsonObject.put("typeIndex", rs.getString("TYPE"));

				informationList.add(diffddMMyyyyHHmmss.format(rs.getTimestamp(("INSERTED_DATETIME"))));
				JsonObject.put("issuedDateIndex", diffddMMyyyyHHmmss.format(rs.getTimestamp(("INSERTED_DATETIME"))));

				informationList.add(rs.getString("ORGANIZATION_NAME"));
				JsonObject.put("orgNameIndex", rs.getString("ORGANIZATION_NAME"));

				informationList.add(rs.getString("QUANTITY"));
				JsonObject.put("qtyIndex", rs.getString("QUANTITY"));

				informationList.add(rs.getString("RATE"));
				JsonObject.put("rateIndex", rs.getString("RATE"));

				informationList.add(rs.getString("CREDIT_AMOUNT"));
				JsonObject.put("creditamountIndex", rs.getString("CREDIT_AMOUNT"));

				informationList.add(rs.getString("DEBIT_AMOUNT"));
				JsonObject.put("debitamountIndex", rs.getString("DEBIT_AMOUNT"));

				JsonArray.put(JsonObject);
				reporthelper.setInformationList(informationList);
				reportsList.add(reporthelper);
			}
			finalreporthelper.setReportsList(reportsList);
			finalreporthelper.setHeadersList(headersList);
			finlist.add(JsonArray);
			finlist.add(finalreporthelper);

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return finlist;
	}

	public ArrayList<Object> getDMFfieldValues(int systemId, int Userid) {

		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject = null;
		ArrayList<Object> finlist = new ArrayList<Object>();
		int count = 0;
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(IronMiningStatement.GET_DMF_FIELD_VALUES);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				count++;
				jsonObject = new JSONObject();
				jsonObject.put("SLNOIndex", count);
				jsonObject.put("typeIndex", rs.getString("VALUE"));
				jsonObject.put("southDmfIndex", "");
				jsonObject.put("northDmfIndex", "");
				jsonArray.put(jsonObject);
			}
			finlist.add(jsonArray);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return finlist;
	}

	public JSONArray getDMFAmount(int systemId, int userId, int customerId) {

		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject = null;
		DecimalFormat df = new DecimalFormat("##0.00");
		String NtotalRoyalty = "0";
		String StotalRoyalty = "0";

		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(IronMiningStatement.GET_DMF.replace("##", ""));
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, customerId);
			pstmt.setInt(3, userId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				jsonObject = new JSONObject();
				NtotalRoyalty = df.format(rs.getDouble("NORTH_ROYALTY") * 0.3);
				StotalRoyalty = df.format(rs.getDouble("SOUTH_ROYALTY") * 0.3);
				jsonObject.put("NDMF", NtotalRoyalty);
				jsonObject.put("SDMF", StotalRoyalty);
				jsonObject.put("BAL_NDMF", df.format(Double.parseDouble(NtotalRoyalty) - rs.getDouble("DMF_NORTH")));
				jsonObject.put("BAL_SDMF", df.format(Double.parseDouble(StotalRoyalty) - rs.getDouble("DMF_SOUTH")));
				jsonObject.put("TOTAL_ROYALTY", df.format(rs.getDouble("TOTAL_ROYALTY")));

				jsonArray.put(jsonObject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jsonArray;
	}

	public ArrayList getDMFDetails(int CustomerId, int systemId, String startDate, String endDate) {
		JSONArray JsonArray = new JSONArray();
		JSONObject JsonObject = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		ArrayList<Object> finlist = new ArrayList<Object>();
		ArrayList<ReportHelper> reportsList = new ArrayList<ReportHelper>();
		ArrayList<String> headersList = new ArrayList<String>();
		ReportHelper finalreporthelper = new ReportHelper();
		SimpleDateFormat diffddMMyyyyHHmmss = new SimpleDateFormat("dd-MM-yyyy");
		JSONObject jObjGet = null;
		List<JSONObject> DMFList = null;
		DMFDetailsBean ieBean = null;
		List<DMFDetailsBean> beanList = null;

		headersList.add("Sl No");
		headersList.add("Finanacial Year");
		//headersList.add("Type");
		headersList.add("North DMF");
		headersList.add("South DMF");
		headersList.add("Total DMF ");
		//headersList.add("C/F Value");
		//headersList.add("Total DMF");

		headersList.add("Education North DMF");
		headersList.add("Education South DMF");
		headersList.add("Infrastructure North DMF");
		headersList.add("Infrastructure South DMF");
		headersList.add("Afforestation North DMF");
		headersList.add("Afforestation South DMF");
		headersList.add("Drinking Water North DMF");
		headersList.add("Drinking Water South DMF");
		headersList.add("Electrification North DMF");
		headersList.add("Electrification South DMF");
		headersList.add("Environment North DMF");
		headersList.add("Environment South DMF");
		headersList.add("Health Care North DMF");
		headersList.add("Health Care South DMF");
		headersList.add("Housing North DMF");
		headersList.add("Housing South DMF");
		headersList.add("Irrigation North DMF");
		headersList.add("Irrigation South DMF");
		headersList.add("Sanitation North DMF");
		headersList.add("Sanitation South DMF");
		headersList.add("Skill Development North DMF");
		headersList.add("Skill Development South DMF");
		headersList.add("Sports North DMF");
		headersList.add("Sports South DMF");
		DecimalFormat df = new DecimalFormat("0.00");
		int count = 0;
		try {
			HashSet<Date> orgSet = new HashSet<Date>();
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(IronMiningStatement.GET_DMF_DETAILS);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, CustomerId);
			pstmt.setString(3, startDate);
			pstmt.setString(4, endDate);
			rs = pstmt.executeQuery();
			DMFList = new ArrayList<JSONObject>();
			while (rs.next()) {
				jObjGet = new JSONObject();
				jObjGet.put("financialYearIndex", (rs.getTimestamp(("DATE"))));
				jObjGet.put("fieldValuesIndex", rs.getString("TYPE"));
				jObjGet.put("dateIndex", rs.getString("DATE"));
				jObjGet.put("totalnorthDMFIndex", df.format(rs.getDouble("TOTAL_NORTH_DMF")));
				jObjGet.put("totalsouthDMFIndex", df.format(rs.getDouble("TOTAL_SOUTH_DMF")));
				jObjGet.put("northDMFIndex", df.format(rs.getDouble("DMF_NORTH")));
				jObjGet.put("southDMFIndex", df.format(rs.getDouble("DMF_SOUTH")));
				jObjGet.put("DMFIndex", df.format(rs.getDouble("TOTAL_DMF")));
				//jObjGet.put("cfvalueIndex", df.format(rs.getDouble("CF_VALUE")));

				DMFList.add(jObjGet);
				orgSet.add((rs.getTimestamp(("DATE"))));
			}

			beanList = new ArrayList<DMFDetailsBean>();
			for (Date date : orgSet) {
				ieBean = new DMFDetailsBean();
				for (JSONObject obj : DMFList) {
					if (obj.get("financialYearIndex").equals(date)) {
						ieBean.setDate(date);
						ieBean.setNorth(obj.getDouble("totalnorthDMFIndex"));
						ieBean.setSouth(obj.getDouble("totalsouthDMFIndex"));
						ieBean.setTotalNS(obj.getDouble("DMFIndex"));
						if (obj.getString("fieldValuesIndex").equals("EDUCATION")) {
							ieBean.setEDUNorth(obj.getDouble("northDMFIndex"));
							ieBean.setEDUSouth(obj.getDouble("southDMFIndex"));
						} else if (obj.getString("fieldValuesIndex").equals("INFRASTRUCTURE")) {
							ieBean.setINFNorth(obj.getDouble("northDMFIndex"));
							ieBean.setINFSouth(obj.getDouble("southDMFIndex"));
						} else if (obj.getString("fieldValuesIndex").equals("AFORRESTATION")) {
							ieBean.setAFFNorth(obj.getDouble("northDMFIndex"));
							ieBean.setAFFSouth(obj.getDouble("southDMFIndex"));
						} else if (obj.getString("fieldValuesIndex").equals("DRINKING WATER")) {
							ieBean.setDRINorth(obj.getDouble("northDMFIndex"));
							ieBean.setDRISouth(obj.getDouble("southDMFIndex"));
						} else if (obj.getString("fieldValuesIndex").equals("ELECTRIFICATION")) {
							ieBean.setELENorth(obj.getDouble("northDMFIndex"));
							ieBean.setELESouth(obj.getDouble("southDMFIndex"));
						} else if (obj.getString("fieldValuesIndex").equals("ENVIRONMENT")) {
							ieBean.setENVNorth(obj.getDouble("northDMFIndex"));
							ieBean.setENVSouth(obj.getDouble("southDMFIndex"));
						} else if (obj.getString("fieldValuesIndex").equals("HEALTH CARE")) {
							ieBean.setHEANorth(obj.getDouble("northDMFIndex"));
							ieBean.setHEASouth(obj.getDouble("southDMFIndex"));
						} else if (obj.getString("fieldValuesIndex").equals("HOUSING")) {
							ieBean.setHOUNorth(obj.getDouble("northDMFIndex"));
							ieBean.setHOUSouth(obj.getDouble("southDMFIndex"));
						} else if (obj.getString("fieldValuesIndex").equals("IRRIGATION")) {
							ieBean.setIRRNorth(obj.getDouble("northDMFIndex"));
							ieBean.setIRRSouth(obj.getDouble("southDMFIndex"));
						} else if (obj.getString("fieldValuesIndex").equals("SANITATION")) {
							ieBean.setSANNorth(obj.getDouble("northDMFIndex"));
							ieBean.setSANSouth(obj.getDouble("southDMFIndex"));
						} else if (obj.getString("fieldValuesIndex").equals("SKILL DEVELOPMENT")) {
							ieBean.setSKILLNorth(obj.getDouble("northDMFIndex"));
							ieBean.setSKILLSouth(obj.getDouble("southDMFIndex"));
						} else if (obj.getString("fieldValuesIndex").equals("SPORTS")) {
							ieBean.setSPORTNorth(obj.getDouble("northDMFIndex"));
							ieBean.setSPORTSouth(obj.getDouble("southDMFIndex"));
						}
					}
				}
				beanList.add(ieBean);
			}
			for (DMFDetailsBean bean : beanList) {
				JsonObject = new JSONObject();
				ArrayList<Object> informationList = new ArrayList<Object>();
				ReportHelper reporthelper = new ReportHelper();
				count++;
				JsonObject.put("slnoIndex", count);
				informationList.add(count);

				informationList.add(diffddMMyyyyHHmmss.format(bean.getDate()));
				JsonObject.put("financialYearIndex", diffddMMyyyyHHmmss.format(bean.getDate()));

				//JsonObject.put("fieldValuesIndex", rs.getString("TYPE"));
				//informationList.add(rs.getString("TYPE"));

				JsonObject.put("northDMFIndex", df.format(bean.getNorth()));
				informationList.add(df.format(bean.getNorth()));

				JsonObject.put("southDMFIndex", df.format(bean.getSouth()));
				informationList.add(df.format(bean.getSouth()));

				JsonObject.put("DMFIndex", df.format(bean.getTotalNS()));
				informationList.add(df.format(bean.getTotalNS()));

				//JsonObject.put("cfvalueIndex", df.format(rs.getDouble("CF_VALUE")));
				//informationList.add(df.format(rs.getDouble("CF_VALUE")));

				//JsonObject.put("totalDMFIndex", df.format(rs.getDouble("TOTAL_ROYALTY")*0.3));
				//informationList.add(df.format(rs.getDouble("TOTAL_ROYALTY")*0.3));

				JsonObject.put("ENDIndex", df.format(bean.getEDUNorth()));
				informationList.add(df.format(bean.getEDUNorth()));

				JsonObject.put("ESDIndex", df.format(bean.getEDUSouth()));
				informationList.add(df.format(bean.getEDUSouth()));

				JsonObject.put("INDIndex", df.format(bean.getINFNorth()));
				informationList.add(df.format(bean.getINFNorth()));

				JsonObject.put("ISDIndex", df.format(bean.getINFSouth()));
				informationList.add(df.format(bean.getINFSouth()));

				JsonObject.put("ANDIndex", df.format(bean.getAFFNorth()));
				informationList.add(df.format(bean.getAFFNorth()));

				JsonObject.put("ASDIndex", df.format(bean.getAFFSouth()));
				informationList.add(df.format(bean.getAFFSouth()));

				JsonObject.put("DWNDIndex", df.format(bean.getDRINorth()));
				informationList.add(df.format(bean.getDRINorth()));

				JsonObject.put("DWSDIndex", df.format(bean.getDRISouth()));
				informationList.add(df.format(bean.getDRISouth()));

				JsonObject.put("EleNDIndex", df.format(bean.getELENorth()));
				informationList.add(df.format(bean.getELENorth()));

				JsonObject.put("EleSDIndex", df.format(bean.getELESouth()));
				informationList.add(df.format(bean.getELESouth()));

				JsonObject.put("EnvNDIndex", df.format(bean.getENVNorth()));
				informationList.add(df.format(bean.getENVNorth()));

				JsonObject.put("EnvSDIndex", df.format(bean.getENVSouth()));
				informationList.add(df.format(bean.getENVSouth()));

				JsonObject.put("HCNDIndex", df.format(bean.getHEANorth()));
				informationList.add(df.format(bean.getHEANorth()));

				JsonObject.put("HCSDIndex", df.format(bean.getHEASouth()));
				informationList.add(df.format(bean.getHEASouth()));

				JsonObject.put("HNDIndex", df.format(bean.getHOUNorth()));
				informationList.add(df.format(bean.getHOUNorth()));

				JsonObject.put("HSDIndex", df.format(bean.getHOUSouth()));
				informationList.add(df.format(bean.getHOUSouth()));

				JsonObject.put("IrrNDIndex", df.format(bean.getIRRNorth()));
				informationList.add(df.format(bean.getIRRNorth()));

				JsonObject.put("IrrSDIndex", df.format(bean.getIRRSouth()));
				informationList.add(df.format(bean.getIRRSouth()));

				JsonObject.put("SanNDIndex", df.format(bean.getSANNorth()));
				informationList.add(df.format(bean.getSANNorth()));

				JsonObject.put("SanSDIndex", df.format(bean.getSANSouth()));
				informationList.add(df.format(bean.getSANSouth()));

				JsonObject.put("SDNDIndex", df.format(bean.getSKILLNorth()));
				informationList.add(df.format(bean.getSKILLNorth()));

				JsonObject.put("SDSDIndex", df.format(bean.getSKILLSouth()));
				informationList.add(df.format(bean.getSKILLSouth()));

				JsonObject.put("SportNDIndex", df.format(bean.getSPORTNorth()));
				informationList.add(df.format(bean.getSPORTNorth()));

				JsonObject.put("SportSDIndex", df.format(bean.getSPORTSouth()));
				informationList.add(df.format(bean.getSPORTSouth()));

				//ASSIGN=diffddMMyyyyHHmmss.format(rs.getTimestamp(("DATE")))
				JsonArray.put(JsonObject);
				reporthelper.setInformationList(informationList);
				reportsList.add(reporthelper);

			}
			finlist.add(JsonArray);
			finalreporthelper.setReportsList(reportsList);
			finalreporthelper.setHeadersList(headersList);
			finlist.add(finalreporthelper);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return finlist;
	}

	public String saveDMFDetails(int systemId, int CustId, JSONArray js, String date, int userId, String TotalNorthdmf,
			String TotalSouthdmf, String Totaldmf) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String message = "";
		JSONObject obj = null;
		String type = "";
		String southDmf = "";
		String northDmf = "";
		try {
			con = DBConnection.getConnectionToDB("AMS");
			for (int i = 0; i < js.length(); i++) {
				obj = js.getJSONObject(i);
				type = obj.getString("typeIndex");
				southDmf = obj.getString("southDmfIndex") != null && !obj.getString("southDmfIndex").equals("")
						? obj.getString("southDmfIndex")
						: "0";
				northDmf = obj.getString("northDmfIndex") != null && !obj.getString("northDmfIndex").equals("")
						? obj.getString("northDmfIndex")
						: "0";
				pstmt = con.prepareStatement(IronMiningStatement.INSERT_INTO_DMF_DETAILS);
				pstmt.setString(1, date);
				pstmt.setString(2, type);
				pstmt.setString(3, southDmf);
				pstmt.setString(4, northDmf);
				pstmt.setString(5, TotalNorthdmf);
				pstmt.setString(6, TotalSouthdmf);
				pstmt.setString(7, Totaldmf);
				pstmt.setInt(8, systemId);
				pstmt.setInt(9, CustId);
				pstmt.setInt(10, userId);
				int inserted = pstmt.executeUpdate();
				if (inserted > 0) {
					message = "Saved Successfully";
				}
			}
		} catch (Exception e) {
			message = "Error in Adding";
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return message;
	}

	public JSONArray getDMFDetailsForDashBoard(int systemId, int CustomerId, int userId, String financialYear) {

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Connection con = null;
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject = new JSONObject();
		DecimalFormat df = new DecimalFormat("##0.00");
		con = DBConnection.getConnectionToDB("AMS");
		try {
			jsonArray.put(new JSONObject().put("TYPE", "AFORRESTATION").put("NORTHDMF", 0).put("SOUTHDMF", 0)
					.put("TOTALDMF", 0));//0
			jsonArray.put(new JSONObject().put("TYPE", "DRINKING WATER").put("NORTHDMF", 0).put("SOUTHDMF", 0)
					.put("TOTALDMF", 0));//1
			jsonArray.put(
					new JSONObject().put("TYPE", "EDUCATION").put("NORTHDMF", 0).put("SOUTHDMF", 0).put("TOTALDMF", 0));//2
			jsonArray.put(new JSONObject().put("TYPE", "ELECTRIFICATION").put("NORTHDMF", 0).put("SOUTHDMF", 0)
					.put("TOTALDMF", 0));//3
			jsonArray.put(new JSONObject().put("TYPE", "ENVIRONMENT").put("NORTHDMF", 0).put("SOUTHDMF", 0)
					.put("TOTALDMF", 0));//4
			jsonArray.put(new JSONObject().put("TYPE", "HEALTH CARE").put("NORTHDMF", 0).put("SOUTHDMF", 0)
					.put("TOTALDMF", 0));//5
			jsonArray.put(
					new JSONObject().put("TYPE", "HOUSING").put("NORTHDMF", 0).put("SOUTHDMF", 0).put("TOTALDMF", 0));//6
			jsonArray.put(new JSONObject().put("TYPE", "INFRASTRUCTURE").put("NORTHDMF", 0).put("SOUTHDMF", 0)
					.put("TOTALDMF", 0));//7
			jsonArray.put(new JSONObject().put("TYPE", "IRRIGATION").put("NORTHDMF", 0).put("SOUTHDMF", 0)
					.put("TOTALDMF", 0));//8
			jsonArray.put(new JSONObject().put("TYPE", "SANITATION").put("NORTHDMF", 0).put("SOUTHDMF", 0)
					.put("TOTALDMF", 0));//9
			jsonArray.put(new JSONObject().put("TYPE", "SKILL DEVELOPMENT").put("NORTHDMF", 0).put("SOUTHDMF", 0)
					.put("TOTALDMF", 0));//10
			jsonArray.put(
					new JSONObject().put("TYPE", "SPORTS").put("NORTHDMF", 0).put("SOUTHDMF", 0).put("TOTALDMF", 0));//11

			pstmt = con.prepareStatement(IronMiningStatement.GET_DMF_DETAILS_FOR_DASHBOARD);
			pstmt.setInt(1, systemId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				double southDmf = rs.getDouble("SOUTH_DMF");
				double northDmf = rs.getDouble("NORTH_DMF");

				switch (rs.getInt("F_TYPE")) {
				case 1: {
					jsonObject = jsonArray.getJSONObject(0);
					jsonObject.put("NORTHDMF", df.format(northDmf));
					jsonObject.put("SOUTHDMF", df.format(southDmf));
					jsonObject.put("TOTALDMF", df.format(southDmf + northDmf));
					break;
				}
				case 2: {
					jsonObject = jsonArray.getJSONObject(1);
					jsonObject.put("NORTHDMF", df.format(northDmf));
					jsonObject.put("SOUTHDMF", df.format(southDmf));
					jsonObject.put("TOTALDMF", df.format(southDmf + northDmf));
					break;
				}
				case 3: {
					jsonObject = jsonArray.getJSONObject(2);
					jsonObject.put("NORTHDMF", df.format(northDmf));
					jsonObject.put("SOUTHDMF", df.format(southDmf));
					jsonObject.put("TOTALDMF", df.format(southDmf + northDmf));
					break;
				}
				case 4: {
					jsonObject = jsonArray.getJSONObject(3);
					jsonObject.put("NORTHDMF", df.format(northDmf));
					jsonObject.put("SOUTHDMF", df.format(southDmf));
					jsonObject.put("TOTALDMF", df.format(southDmf + northDmf));
					break;
				}
				case 5: {
					jsonObject = jsonArray.getJSONObject(4);
					jsonObject.put("NORTHDMF", df.format(northDmf));
					jsonObject.put("SOUTHDMF", df.format(southDmf));
					jsonObject.put("TOTALDMF", df.format(southDmf + northDmf));
					break;
				}
				case 6: {
					jsonObject = jsonArray.getJSONObject(5);
					jsonObject.put("NORTHDMF", df.format(northDmf));
					jsonObject.put("SOUTHDMF", df.format(southDmf));
					jsonObject.put("TOTALDMF", df.format(southDmf + northDmf));
					break;
				}
				case 7: {
					jsonObject = jsonArray.getJSONObject(6);
					jsonObject.put("NORTHDMF", df.format(northDmf));
					jsonObject.put("SOUTHDMF", df.format(southDmf));
					jsonObject.put("TOTALDMF", df.format(southDmf + northDmf));
					break;
				}
				case 8: {
					jsonObject = jsonArray.getJSONObject(7);
					jsonObject.put("NORTHDMF", df.format(northDmf));
					jsonObject.put("SOUTHDMF", df.format(southDmf));
					jsonObject.put("TOTALDMF", df.format(southDmf + northDmf));
					break;
				}
				case 9: {
					jsonObject = jsonArray.getJSONObject(8);
					jsonObject.put("NORTHDMF", df.format(northDmf));
					jsonObject.put("SOUTHDMF", df.format(southDmf));
					jsonObject.put("TOTALDMF", df.format(southDmf + northDmf));
					break;
				}
				case 10: {
					jsonObject = jsonArray.getJSONObject(9);
					jsonObject.put("NORTHDMF", df.format(northDmf));
					jsonObject.put("SOUTHDMF", df.format(southDmf));
					jsonObject.put("TOTALDMF", df.format(southDmf + northDmf));
					break;
				}
				case 11: {
					jsonObject = jsonArray.getJSONObject(10);
					jsonObject.put("NORTHDMF", df.format(northDmf));
					jsonObject.put("SOUTHDMF", df.format(southDmf));
					jsonObject.put("TOTALDMF", df.format(southDmf + northDmf));
					break;
				}
				case 12: {
					jsonObject = jsonArray.getJSONObject(11);
					jsonObject.put("NORTHDMF", df.format(northDmf));
					jsonObject.put("SOUTHDMF", df.format(southDmf));
					jsonObject.put("TOTALDMF", df.format(southDmf + northDmf));
					break;
				}
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jsonArray;
	}

	public JSONArray getTotalDmfForFinancialYear(int systemId, int CustomerId, int userId, String financialYear) {

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Connection con = null;
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject = new JSONObject();
		con = DBConnection.getConnectionToDB("AMS");
		DecimalFormat df = new DecimalFormat("##0.00");
		int count = 0;
		try {
			pstmt = con.prepareStatement(IronMiningStatement.GET_DMF);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, CustomerId);
			pstmt.setInt(3, userId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				count++;
				jsonObject = new JSONObject();
				jsonObject.put("SLNO", count);
				jsonObject.put("NORTHDMF", df.format(rs.getDouble("NORTH_ROYALTY") * 0.3));
				jsonObject.put("SOUTHDMF", df.format(rs.getDouble("SOUTH_ROYALTY") * 0.3));
				jsonArray.put(jsonObject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jsonArray;
	}

	public ArrayList<Object> getStockReconciliationReport(int systemId, int custId, int hubId, int orgId,
			String mineralType) {
		ArrayList<ReportHelper> reportsList = new ArrayList<ReportHelper>();
		ArrayList<String> headersList = new ArrayList<String>();
		ReportHelper finalreporthelper = new ReportHelper();
		ArrayList<Object> finlist = new ArrayList<Object>();
		JSONArray JsonArray = null;
		JSONObject JsonObject = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int count = 0;
		SimpleDateFormat diffddMMyyyyHHmmss = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
		DecimalFormat df = new DecimalFormat("#.##");
		try {
			headersList.add("SLNO");
			headersList.add("Stock Name");
			headersList.add("Issued Date");
			headersList.add("Organization Name");
			headersList.add("Buying Organization Name");
			headersList.add("Route Name");
			headersList.add("Source");
			headersList.add("Destination");
			headersList.add("Permit No");
			headersList.add("Permit Type");
			headersList.add("Status");
			headersList.add("Permit Qty");
			headersList.add("Grade Type");
			headersList.add("Incoming Qty");
			headersList.add("Outgoing Qty");

			JsonArray = new JSONArray();
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(IronMiningStatement.GET_STOCK_RECONCILIATION_REPORT);

			pstmt.setInt(1, systemId);
			pstmt.setInt(2, custId);
			pstmt.setString(3, mineralType);
			pstmt.setInt(4, orgId);
			pstmt.setInt(5, hubId);
			pstmt.setInt(6, hubId);
			pstmt.setInt(7, systemId);
			pstmt.setInt(8, custId);
			pstmt.setString(9, mineralType);
			pstmt.setInt(10, orgId);
			pstmt.setInt(11, hubId);
			pstmt.setInt(12, hubId);
			pstmt.setInt(13, orgId);
			pstmt.setInt(14, hubId);

			rs = pstmt.executeQuery();
			while (rs.next()) {
				count++;
				ReportHelper reporthelper = new ReportHelper();
				JsonObject = new JSONObject();
				ArrayList<Object> informationList = new ArrayList<Object>();

				JsonObject.put("slnoIndex", count);
				informationList.add(count);

				informationList.add("");
				JsonObject.put("stockNameIndex", "");

				informationList.add(diffddMMyyyyHHmmss.format(rs.getTimestamp(("INSERTED_DATETIME"))));
				JsonObject.put("issuedDateIndex", diffddMMyyyyHHmmss.format(rs.getTimestamp(("INSERTED_DATETIME"))));

				informationList.add(rs.getString("ORGANIZATION_NAME"));
				JsonObject.put("orgNameIndex", rs.getString("ORGANIZATION_NAME"));

				informationList.add(rs.getString("BUYING_ORG_NAME"));
				JsonObject.put("buyingOrgNameIndex", rs.getString("BUYING_ORG_NAME"));

				informationList.add(rs.getString("ROUTE_NAME"));
				JsonObject.put("routeNameIndex", rs.getString("ROUTE_NAME"));

				informationList.add(rs.getString("SOURCE"));
				JsonObject.put("sourceIndex", rs.getString("SOURCE"));

				informationList.add(rs.getString("DESTINATION"));
				JsonObject.put("destinationIndex", rs.getString("DESTINATION"));

				informationList.add(rs.getString("PERMIT_NO"));
				JsonObject.put("permitNoIndex", rs.getString("PERMIT_NO"));

				informationList.add(rs.getString("PERMIT_TYPE"));
				JsonObject.put("typeIndex", rs.getString("PERMIT_TYPE"));

				informationList.add(rs.getString("STATUS"));
				JsonObject.put("statusIndex", rs.getString("STATUS"));

				informationList.add(df.format(rs.getDouble("PERMIT_QUANTITY")));
				JsonObject.put("permitQtyIndex", df.format(rs.getDouble("PERMIT_QUANTITY")));

				informationList.add(rs.getString("GRADE_TYPE"));
				JsonObject.put("gradeTypeIndex", rs.getString("GRADE_TYPE"));

				informationList.add(df.format(rs.getDouble("INCOMING_QTY")));
				JsonObject.put("creditQtyIndex", df.format(rs.getDouble("INCOMING_QTY")));

				informationList.add(df.format(rs.getDouble("OUTGOING_QTY")));
				JsonObject.put("debitQtyIndex", df.format(rs.getDouble("OUTGOING_QTY")));

				JsonArray.put(JsonObject);
				reporthelper.setInformationList(informationList);
				reportsList.add(reporthelper);
			}
			finalreporthelper.setReportsList(reportsList);
			finalreporthelper.setHeadersList(headersList);
			finlist.add(JsonArray);
			finlist.add(finalreporthelper);

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return finlist;
	}

	public String getValidationStatus(Connection con, String nonCommHrs, String assetNo, int customerId, int systemId) {
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String commStatus = "";
		String lastCommDate = "";
		String lastCommLoc = "";
		String message = "";
		String finalMsg = "";
		try {
			pstmt = con.prepareStatement(IronMiningStatement.GET_COMM_STATUS);
			pstmt.setInt(1, Integer.parseInt(nonCommHrs));
			pstmt.setString(2, assetNo);
			pstmt.setInt(3, systemId);
			pstmt.setInt(4, customerId);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				commStatus = rs.getString("COMM_STATUS");
				lastCommDate = rs.getString("GPS_DATETIME");
				lastCommLoc = rs.getString("LOCATION");
			}
			if (commStatus.equals("NOT_APPLICABLE")) {
				message = "Vehicle is not communicating";
			} else if (lastCommLoc.equalsIgnoreCase("No GPS Device Connected")) {
				message = "GPS Device is not connected to the vehicle.";
			} else {
				pstmt = con.prepareStatement(IronMiningStatement.GET_ALERT_DETAILS);
				pstmt.setInt(1, systemId);
				pstmt.setInt(2, Integer.parseInt(nonCommHrs));
				pstmt.setString(3, assetNo);
				rs = pstmt.executeQuery();
				if (rs.next()) {
					if (rs.getInt("TYPE_OF_ALERT") == 154) {
						message = "Internal battery is not charged.Can not take trip sheet";
					}
				} else {
					message = "Success";
				}
			}
			finalMsg = message + "##" + lastCommDate + "##" + lastCommLoc + "##" + commStatus;
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(null, pstmt, rs);
		}
		return finalMsg;
	}

	public JSONArray getBargeStatus(int clientId, int systemId, int userId) {
		JSONArray JsonArray = new JSONArray();
		JSONObject JsonObject = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		try {
			JsonObject = new JSONObject();
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(IronMiningStatement.GET_BARGE_STATUS);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, clientId);
			pstmt.setInt(3, userId);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				JsonObject = new JSONObject();
				JsonObject.put("status", true);
				JsonArray.put(JsonObject);
			} else {
				JsonObject = new JSONObject();
				JsonObject.put("status", false);
				JsonArray.put(JsonObject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}

		return JsonArray;
	}

	public JSONArray getBargeStatus1(int clientId, int systemId, String bargeNo) {
		JSONArray JsonArray = new JSONArray();
		JSONObject JsonObject = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		try {
			JsonObject = new JSONObject();
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(IronMiningStatement.GET_BARGE_STATUS_FOR_START_BLO);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, clientId);
			pstmt.setString(3, bargeNo);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				JsonObject = new JSONObject();
				JsonObject.put("status", true);
				JsonObject.put("bargeName", rs.getString("ASSET_NUMBER"));
				JsonArray.put(JsonObject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}

		return JsonArray;
	}

	public ArrayList getRestrictiveHoursTripDetails(String dateDT, int systemId, int clientId, int offset) {

		ArrayList<ReportHelper> reportsList = new ArrayList<ReportHelper>();
		ArrayList<String> headersList = new ArrayList<String>();
		ReportHelper finalreporthelper = new ReportHelper();
		ArrayList<Object> finlist = new ArrayList<Object>();
		JSONArray JsonArray = null;
		JSONObject JsonObject = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int count = 0;
		SimpleDateFormat diffddMMyyyyHHmmss = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

		try {
			String date = "";
			String[] dt = dateDT.split("T");
			date = dt[0];
			Date DATE = sdf.parse(date);
			long currDate = DATE.getTime();
			String NextDate = sdf.format(new Date(currDate + (1 * 86400000L)));
			headersList.add("SLNO");
			headersList.add("Vehicle No");
			headersList.add("Trip No");
			headersList.add("Inserted Time");
			headersList.add("Validity Date");
			headersList.add("Route Name");
			headersList.add("Organization Name");
			con = DBConnection.getConnectionToDB("AMS");
			JsonArray = new JSONArray();
			String query = IronMiningStatement.GET_RESTRICTIVE_HOURS_TRIP_DETAILS;
			pstmt = con.prepareStatement(query);
			pstmt.setInt(1, offset);
			pstmt.setInt(2, offset);
			pstmt.setInt(3, systemId);
			pstmt.setInt(4, clientId);
			pstmt.setInt(5, systemId);
			pstmt.setInt(6, clientId);
			pstmt.setInt(7, offset);
			pstmt.setString(8, date);
			pstmt.setInt(9, offset);
			pstmt.setString(10, date);
			pstmt.setInt(11, offset);
			pstmt.setString(12, date);
			pstmt.setInt(13, offset);
			pstmt.setString(14, NextDate);
			pstmt.setInt(15, offset);
			pstmt.setInt(16, offset);
			pstmt.setInt(17, systemId);
			pstmt.setInt(18, clientId);
			pstmt.setInt(19, systemId);
			pstmt.setInt(20, clientId);
			pstmt.setInt(21, offset);
			pstmt.setString(22, date);
			pstmt.setInt(23, offset);
			pstmt.setString(24, date);
			pstmt.setInt(25, offset);
			pstmt.setString(26, date);
			pstmt.setInt(27, offset);
			pstmt.setString(28, NextDate);

			rs = pstmt.executeQuery();
			while (rs.next()) {
				count++;
				ReportHelper reporthelper = new ReportHelper();
				JsonObject = new JSONObject();
				ArrayList<Object> informationList = new ArrayList<Object>();

				JsonObject.put("slnoIndex", count);
				informationList.add(count);

				JsonObject.put("vehicleNoDataIndex", rs.getString("VEHICLE_NO"));
				informationList.add(rs.getString("VEHICLE_NO"));

				JsonObject.put("tripNoDataIndex", rs.getString("TRIP_NO"));
				informationList.add(rs.getString("TRIP_NO"));

				JsonObject.put("insertedTimeDataIndex", diffddMMyyyyHHmmss.format(rs.getTimestamp("INSERTED_TIME")));
				informationList.add(diffddMMyyyyHHmmss.format(rs.getTimestamp("INSERTED_TIME")));

				JsonObject.put("validityDateDataIndex", diffddMMyyyyHHmmss.format(rs.getTimestamp("VALIDITY_DATE")));
				informationList.add(diffddMMyyyyHHmmss.format(rs.getTimestamp("VALIDITY_DATE")));

				JsonObject.put("routeNameDataIndex", rs.getString("ROUTE_NAME"));
				informationList.add(rs.getString("ROUTE_NAME"));

				JsonObject.put("orgNameDataIndex", rs.getString("ORG_NAME"));
				informationList.add(rs.getString("ORG_NAME"));

				JsonArray.put(JsonObject);
				reporthelper.setInformationList(informationList);
				reportsList.add(reporthelper);
			}
			finalreporthelper.setReportsList(reportsList);
			finalreporthelper.setHeadersList(headersList);
			finlist.add(JsonArray);
			finlist.add(finalreporthelper);

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return finlist;
	}

	public JSONArray getDMFMonth(int systemId, int userId, int customerId, String date) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String Flag = "false";
		JSONArray JsonArray = new JSONArray();
		JSONObject JsonObject = new JSONObject();
		date = date.replaceAll("T", " ");
		try {
			Date checkdate = new SimpleDateFormat("yyyy-MM-dd").parse(date);
			int month = checkdate.getMonth() + 1;
			int year = checkdate.getYear() + 1900;
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(IronMiningStatement.GET_VALID_MONTH_FROM_DMF_DETAILS);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, customerId);
			pstmt.setInt(3, month);
			pstmt.setInt(4, year);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				Flag = "true";
				JsonObject.put("flag", Flag);
			}
			JsonArray.put(JsonObject);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}

		return JsonArray;
	}

	public JSONArray getProductionBalance(int systemId, int custId, String tcId) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		JSONArray jArry = new JSONArray();
		JSONObject jObj = new JSONObject();
		try {
			con = DBConnection.getConnectionToDB("AMS");

			pstmt = con.prepareStatement(IronMiningStatement.GET_PRODUCTION_BAL);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, custId);
			pstmt.setString(3, tcId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				jObj = new JSONObject();
				jObj.put("PRODUCTION_BAL", rs.getString("PRODUCTION_BAL"));
				jArry.put(jObj);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jArry;
	}

	public String upadteAssetEnrollmentStatus(String assetNo, String enrollstatus, int sysId) {
		String message = "";
		Connection conAdmin = null;
		PreparedStatement pstmt = null;
		int updated = 0;
		try {
			conAdmin = DBConnection.getConnectionToDB("AMS");
			pstmt = conAdmin.prepareStatement(IronMiningStatement.UPDATE_STATUS_FOR_ENROLLMENT);
			pstmt.setString(1, enrollstatus);
			pstmt.setString(2, assetNo);
			pstmt.setInt(3, sysId);
			updated = pstmt.executeUpdate();
			if (updated > 0) {
				message = "Successfully Updated";
			}
		} catch (Exception e) {
			e.printStackTrace();
			System.out.println("Inside upadteAssetEnrollmentStatus function" + e.toString());
		} finally {
			DBConnection.releaseConnectionToDB(conAdmin, pstmt, null);
		}
		return message;
	}
}