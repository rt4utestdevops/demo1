package t4u.functions;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.TreeMap;
import java.util.Map.Entry;

import org.json.JSONArray;
import org.json.JSONObject;

import t4u.GeneralVertical.HubshiftsupervisorData;
import t4u.GeneralVertical.SupervisorSchedule.SupervisorScheduleModel;
import t4u.GeneralVertical.aggrasivetat.PinCodeOriginDestinationModel;
import t4u.beans.SmartHubDetails;
import t4u.common.DBConnection;
import t4u.statements.CTDashboardStatements;

public class CTDashboardFunctions {
	SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
	SimpleDateFormat sdfDB = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	SimpleDateFormat MMddyyyyHHmmss = new SimpleDateFormat("MM/dd/yyyy HH:mm:ss");
	DecimalFormat df = new DecimalFormat("00.00");
	CommonFunctions cf = new CommonFunctions();
	String errorMessage = "An error occured while associating the vehicles.. Please contact the administrator.";

	public JSONArray getCTAdminDashboardCounts(int clientId, int systemId, int userId, int nonCommHrs) {
		JSONArray jsonArray = new JSONArray();
		JSONObject obj = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int intransit = 0;
		int planned = 0;
		int available = 0;
		int inMaintenance = 0;
		int nonComm = 0;
		int intransitTCL = 0;
		int plannedTCL = 0;
		int availableTCL = 0;
		int inMaintenanceTCL = 0;
		int nonCommTCL = 0;
		int unloading = 0;
		int unloadingTCL = 0;
		try {
			con = DBConnection.getConnectionToDB("AMS");
			String stmt = CTDashboardStatements.GET_CT_DASHBOARD_COUNTS.replaceAll("##", String.valueOf(nonCommHrs));
			pstmt = con.prepareStatement(stmt);
			for (int i = 1; i < 25; i++) {
				if (i % 2 == 0) {
					pstmt.setInt(i, clientId);
				} else {
					pstmt.setInt(i, systemId);
				}
			}
			rs = pstmt.executeQuery();
			while (rs.next()) {
				if (rs.getString("TYPE").equals("INTRANSIT")) {
					intransit = rs.getInt("COUNT");
				}
				if (rs.getString("TYPE").equals("PLANNED")) {
					planned = rs.getInt("COUNT");
				}
				if (rs.getString("TYPE").equals("AVAILABLE")) {
					available = rs.getInt("COUNT");
				}
				inMaintenance = 0;
				if (rs.getString("TYPE").equals("NON_COMM")) {
					nonComm = rs.getInt("COUNT");
				}
				if (rs.getString("TYPE").equals("INTRANSIT_TCL")) {
					intransitTCL = rs.getInt("COUNT");
				}
				if (rs.getString("TYPE").equals("PLANNED_TCL")) {
					plannedTCL = rs.getInt("COUNT");
				}
				if (rs.getString("TYPE").equals("AVAILABLE_TCL")) {
					availableTCL = rs.getInt("COUNT");
				}
				inMaintenanceTCL = 0;
				if (rs.getString("TYPE").equals("NON_COMM_TCL")) {
					nonCommTCL = rs.getInt("COUNT");
				}
				if (rs.getString("TYPE").equals("UNLOADING")) {
					unloading = rs.getInt("COUNT");
				}
				if (rs.getString("TYPE").equals("UNLOADING_TCL")) {
					unloadingTCL = rs.getInt("COUNT");
				}
			}
			obj = new JSONObject();
			obj.put("inTransit", intransit);
			obj.put("planned", planned);
			obj.put("available", available);
			obj.put("inMaintenance", inMaintenance);
			obj.put("nonComm", nonComm);
			obj.put("inTransitTCL", intransitTCL);
			obj.put("plannedTCL", plannedTCL);
			obj.put("availableTCL", availableTCL);
			obj.put("inMaintenanceTCL", inMaintenanceTCL);
			obj.put("nonCommTCL", nonCommTCL);
			obj.put("inTransitDry", intransit - intransitTCL);
			obj.put("plannedDry", planned - plannedTCL);
			obj.put("availableDry", available - availableTCL);
			obj.put("inMaintenanceDry", inMaintenance - inMaintenanceTCL);
			obj.put("nonCommDry", nonComm - nonCommTCL);
			obj.put("unloading", unloading);
			obj.put("unloadingTCL", unloadingTCL);
			obj.put("unloadingDry", unloading - unloadingTCL);
			jsonArray.put(obj);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jsonArray;
	}

	public JSONArray getRegistrationNo(int systemId, int customerId, int userId, String tripCustIds, String custType, String vehType, String vehicleCategory) {
		JSONArray jsonArray = new JSONArray();
		JSONObject obj = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			String customerList = "";
			String custTypelist = "";
			String vehTypeList = "";
			String vehCategoryList = "";
			StringBuilder query = new StringBuilder();
			String leftJoin = " left outer join AMS.dbo.TRACK_TRIP_DETAILS(nolock) td on td.ASSET_NUMBER = gps.REGISTRATION_NO";
			query.append(CTDashboardStatements.GET_REGISTRATION_NO);

			if (!tripCustIds.equals("")) {
				String tripCustArr = tripCustIds;
				customerList = "'" + tripCustArr.toString().replace(",", "','") + "'";
				query.append(" and TRIP_CUSTOMER_ID in (" + customerList + ")");
			}

			if (!custType.equals("")) {
				String custTypeArr = custType;
				custTypelist = "'" + custTypeArr.toString().replace(",", "','") + "'";
				query.append(" and TRIP_CUSTOMER_TYPE in (" + custTypelist + ")");
			}

			if (!vehType.equals("")) {
				String vehTypeArr = vehType;
				vehTypeList = "'" + vehTypeArr.toString().replace(",", "','") + "'";
				query.append(" and tb.VehicleType in (" + vehTypeList + ")");
			}

			if (!vehicleCategory.equals("")) {
				String vehCategoryArr = vehicleCategory;
				vehCategoryList = "'" + vehCategoryArr.toString().replace(",", "','") + "'";
				query.append(" and PRODUCT_LINE in (" + vehCategoryList + ")");
			}
			int start = query.indexOf("##");
			query.replace(start, start + 2, leftJoin);
			con = DBConnection.getConnectionToDB("AMS");

			pstmt = con.prepareStatement(query.toString().replace("##", ""));
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, customerId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				obj = new JSONObject();
				obj.put("vehicleNo", rs.getString("VehicleNo"));
				obj.put("tripId", rs.getString("TRIP_ID"));
				jsonArray.put(obj);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jsonArray;
	}

	public JSONArray getVehicleType(int systemId, int customerId) {
		JSONArray jsonArray = new JSONArray();
		JSONObject obj = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(CTDashboardStatements.GET_VEHICLE_TYPE);
			pstmt.setInt(1, systemId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				obj = new JSONObject();
				obj.put("vehicleTypeCode", rs.getString("Category_code"));
				obj.put("vehicleType", rs.getString("Category_name"));
				jsonArray.put(obj);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jsonArray;
	}

	public JSONArray getCustNames(int systemId, int clientId) {

		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(CTDashboardStatements.GET_CUSTOMERS);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, clientId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				jsonObject = new JSONObject();
				jsonObject.put("custId", rs.getString("TRIP_CUSTOMER_ID"));
				jsonObject.put("custName", rs.getString("NAME"));
				jsonArray.put(jsonObject);
			}
		} catch (Exception e) {
			System.out.println("Error in getCustomer :: " + e.toString());
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jsonArray;
	}

	public JSONArray getUsers(int systemId, int custId) {
		JSONArray JsonArray = null;
		JSONObject JsonObject = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			JsonArray = new JSONArray();
			con = DBConnection.getConnectionToDB("ADMINISTRATOR");
			pstmt = con.prepareStatement(CTDashboardStatements.GET_USERS);
			pstmt.setInt(1, systemId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				JsonObject = new JSONObject();
				JsonObject.put("userId", rs.getInt("User_id"));
				JsonObject.put("userName", rs.getString("User_Name"));
				JsonObject.put("criteriaId", rs.getString("CRITERIA_ID"));
				JsonArray.put(JsonObject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return JsonArray;
	}

	public String associateVehiclesToUsers(int systemId, int clientId, String vehicleList, String user) {
		Connection con = null;
		PreparedStatement pstmt = null;
		String message = "";
		try {
			con = DBConnection.getConnectionToDB("AMS");
			String[] vehicles = vehicleList.split(",");
			pstmt = con.prepareStatement(CTDashboardStatements.SAVE_USER_VEHICLE_ASSOCIATION);
			for (String vehicle : vehicles) {
				try {
					pstmt.setInt(1, Integer.parseInt(user));
					pstmt.setString(2, vehicle);
					pstmt.setInt(3, systemId);
					pstmt.setInt(4, clientId);
					pstmt.setInt(5, 0);
					pstmt.setInt(6, 0);
					pstmt.addBatch();
				} catch (Exception e) {
					e.getMessage();
				}
			}
			int[] updated = pstmt.executeBatch();
			if (updated.length > 0) {
				message = updated.length + " vehicles are associated to the user";
			}
			return message;
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, null);
		}
		return errorMessage;
	}

	public List<JSONObject> getHubDetails(int systemId, int clientId) {

		JSONObject obj = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		List<JSONObject> sList = new ArrayList<JSONObject>();
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(CTDashboardStatements.GET_HUB_DETAILS);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, clientId);
			rs = pstmt.executeQuery();
			obj = new JSONObject();
			while (rs.next()) {
				obj = new JSONObject();
				obj.put("hubName", rs.getString("NAME"));
				obj.put("hubId", rs.getString("HUBID"));
				sList.add(obj);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return sList;

	}

	public void saveUploadedHubDetails(int systemId, int clientId, HubshiftsupervisorData supervisordataDetails, int userId, Connection con) {
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			pstmt = con.prepareStatement(CTDashboardStatements.SAVE_SUPERVISOR_HUB_DETAILS);
			pstmt.setString(1, supervisordataDetails.getHubId());
			pstmt.setString(2, supervisordataDetails.getHubName());
			pstmt.setString(3, supervisordataDetails.getSupervisorName());
			pstmt.setString(4, supervisordataDetails.getHubCode());
			pstmt.setString(5, supervisordataDetails.getShiftStartTiming());
			pstmt.setString(6, supervisordataDetails.getShiftEndTiming());
			pstmt.setString(7, supervisordataDetails.getContactNumber());
			pstmt.setInt(8, systemId);
			pstmt.setInt(9, clientId);
			pstmt.setInt(10, userId);
			pstmt.executeUpdate();

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(null, pstmt, rs);
		}
	}

	public JSONArray getAssociationData(int systemId, int clientId, String userList, String criteriaId) {
		JSONObject obj = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		JSONArray jArr = new JSONArray();
		try {
			con = DBConnection.getConnectionToDB("AMS");
			userList = userList.substring(0, userList.length() - 1);
			pstmt = con.prepareStatement(CTDashboardStatements.GET_ASSOCIATION_DATA.concat(" and USER_ID in ("+userList+")"));
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, clientId);
			pstmt.setString(3, criteriaId);
			rs = pstmt.executeQuery();
			obj = new JSONObject();
			while (rs.next()) {
				obj = new JSONObject();
				obj.put("vehicleNo", rs.getString("ASSET_NUMBER"));
				obj.put("vehicleType", rs.getString("VEHICLE_TYPE"));
				obj.put("customerName", rs.getString("CUSTOMER_NAME"));
				obj.put("vehicleCategory", rs.getString("VEHICLE_CATEGORY"));
				if (rs.getInt("AGGRESSIVE_TAT") > 0) {
					obj.put("TAT", "<b>" + cf.convertMinutesToHHMMFormat(rs.getInt("AGGRESSIVE_TAT")) + "<b>");
				} else {
					obj.put("TAT", cf.convertMinutesToHHMMFormat(rs.getInt("TAT")));
				}
				String vehicleNo = "'" + rs.getString("ASSET_NUMBER") + "'";
				obj.put("disassociate", "<div class='fas fa-unlink' style='margin-left: 78px;font-size: 15px;cursor:pointer;white-space: nowrap;color:red;allign:center;' "
						+ " onclick=disAssociateVehicle(" + vehicleNo + ",'1'" + ")> </div>");
				obj.put("criteriaName", rs.getString("CRITERIA_NAME"));
				jArr.put(obj);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jArr;
	}

	public JSONArray getUnassignedVehicles(int systemId, int clientId) {
		JSONObject obj = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		JSONArray jArr = new JSONArray();
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(CTDashboardStatements.GET_UNASSIGNED_VEHICLES);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, clientId);
			pstmt.setInt(3, systemId);
			pstmt.setInt(4, clientId);
			rs = pstmt.executeQuery();
			obj = new JSONObject();
			while (rs.next()) {
				obj = new JSONObject();
				obj.put("vehicleNo", rs.getString("ASSET_NUMBER"));
				obj.put("tripNo", rs.getString("ORDER_ID"));
				obj.put("customerName", rs.getString("CUSTOMER_NAME"));
				obj.put("vehicleCategory", rs.getString("VEHICLE_CATEGORY"));
				obj.put("vehicleType", rs.getString("VEHICLE_TYPE"));
				jArr.put(obj);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jArr;
	}

	public JSONArray getAvailableVehicles(int systemId, int clientId, int offset, String type) {
		JSONObject obj = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		JSONArray jArr = new JSONArray();
		try {
			con = DBConnection.getConnectionToDB("AMS");
			if ("TCL".equals(type)) {
				pstmt = con.prepareStatement(CTDashboardStatements.GET_AVAILABLE_VEHICLES.replace("##",
						" inner join Live_Vision_Support lvs on lvs.REGISTRATION_NO=a.REGISTRATION_NO and lvs.GROUP_NAME='TCL' "));
			} else if ("DRY".equals(type)) {
				pstmt = con.prepareStatement(CTDashboardStatements.GET_AVAILABLE_VEHICLES.replace("##",
						" inner join Live_Vision_Support lvs on lvs.REGISTRATION_NO=a.REGISTRATION_NO and lvs.GROUP_NAME!='TCL' "));
			} else if ("TOTAL".equals(type)) {
				pstmt = con.prepareStatement(CTDashboardStatements.GET_AVAILABLE_VEHICLES.replace("##", ""));
			}
			pstmt.setInt(1, offset);
			pstmt.setInt(2, systemId);
			pstmt.setInt(3, clientId);
			pstmt.setInt(4, systemId);
			pstmt.setInt(5, clientId);
			rs = pstmt.executeQuery();
			obj = new JSONObject();
			while (rs.next()) {
				obj = new JSONObject();
				obj.put("vehicleNo", rs.getString("REGISTRATION_NO"));
				obj.put("location", rs.getString("LOCATION"));
				obj.put("lastCommunication", sdf.format(sdfDB.parse(rs.getString("LAST_COMM"))));
				jArr.put(obj);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jArr;
	}

	public JSONArray getNonCommunicationVehicles(int systemId, int clientId, int offset, String type) {
		JSONObject obj = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		JSONArray jArr = new JSONArray();
		try {
			con = DBConnection.getConnectionToDB("AMS");
			if ("TCL".equals(type)) {
				pstmt = con.prepareStatement(CTDashboardStatements.GET_NON_COMM_VEHICLES.replace("##",
						" inner join Live_Vision_Support lvs on lvs.REGISTRATION_NO=a.REGISTRATION_NO and lvs.GROUP_NAME='TCL' "));
			} else if ("DRY".equals(type)) {
				pstmt = con.prepareStatement(CTDashboardStatements.GET_NON_COMM_VEHICLES.replace("##",
						" inner join Live_Vision_Support lvs on lvs.REGISTRATION_NO=a.REGISTRATION_NO and lvs.GROUP_NAME!='TCL' "));
			} else if ("TOTAL".equals(type)) {
				pstmt = con.prepareStatement(CTDashboardStatements.GET_NON_COMM_VEHICLES.replace("##", ""));
			}
			pstmt.setInt(1, offset);
			pstmt.setInt(2, systemId);
			pstmt.setInt(3, clientId);
			rs = pstmt.executeQuery();
			obj = new JSONObject();
			while (rs.next()) {
				obj = new JSONObject();
				obj.put("vehicleNo", rs.getString("REGISTRATION_NO"));
				obj.put("location", rs.getString("LOCATION"));
				obj.put("lastCommunication", sdf.format(sdfDB.parse(rs.getString("LAST_COMM"))));
				obj.put("status", rs.getString("STATUS"));
				jArr.put(obj);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jArr;
	}

	public JSONArray getSourceAndDestination(int systemId, int clientId) {

		JSONObject obj = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		JSONArray jArr = new JSONArray();
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(CTDashboardStatements.GET_SOURCE_AND_DESTINATION);
			rs = pstmt.executeQuery();
			obj = new JSONObject();
			while (rs.next()) {
				obj = new JSONObject();
				obj.put("cityName", rs.getString("NAME"));
				jArr.put(obj);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jArr;

	}

	public String saveAggressiveTatDetails(int systemId, int clientId, String source, String destination, String TAT) {
		Connection con = null;
		PreparedStatement pstmt = null;
		PreparedStatement pstmt1 = null;
		String message = "No available routes";
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(CTDashboardStatements.UPDATE_TAT_FOR_ROUTES);
			pstmt.setInt(1, cf.convertHHMMToMinutes1(TAT));
			pstmt.setInt(2, systemId);
			pstmt.setInt(3, clientId);
			pstmt.setString(4, source);
			pstmt.setString(5, destination);
			int updated = pstmt.executeUpdate();
			if (updated > 0) {
				message = updated + " Routes updated successfully";
				pstmt1 = con.prepareStatement(CTDashboardStatements.SAVE_AGGRESSIVE_TAT_DETAILS);
				pstmt1.setString(1, source);
				pstmt1.setString(2, destination);
				pstmt1.setInt(3, cf.convertHHMMToMinutes1(TAT));
				pstmt1.executeUpdate();
			}
			return message;
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, null);
			DBConnection.releaseConnectionToDB(null, pstmt1, null);
		}
		return errorMessage;
	}

	public String saveDelayDetails(int systemId, int clientId, String issueType, String delayCode, String subIssue) {
		Connection con = null;
		PreparedStatement pstmt = null;
		String message = "";
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(CTDashboardStatements.SAVE_DELAY_DATA);
			pstmt.setString(1, issueType);
			pstmt.setString(2, delayCode);
			pstmt.setString(3, subIssue);
			pstmt.setInt(4, systemId);
			pstmt.setInt(5, clientId);
			int updated = pstmt.executeUpdate();
			if (updated > 0) {
				message = "Delay details updated successfully";
			}
			return message;
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, null);
		}
		return errorMessage;
	}

	public JSONArray getTATDetails(int systemId, int clientId) {

		JSONObject obj = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		JSONArray jArr = new JSONArray();
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(CTDashboardStatements.GET_TAT_DETAILS);
			rs = pstmt.executeQuery();
			obj = new JSONObject();
			while (rs.next()) {
				obj = new JSONObject();
				obj.put("source", rs.getString("SOURCE"));
				obj.put("destination", rs.getString("DESTINATION"));
				obj.put("TAT", cf.convertMinutesToHHMMFormat(rs.getInt("TAT")));
				jArr.put(obj);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jArr;
	}
	
	

	public String updateAggressiveTatDetails(int systemId, int clientId, String source, String destination, String tAT) {

		Connection con = null;
		PreparedStatement pstmt = null;
		PreparedStatement pstmt1 = null;
		String message = "No available routes ";
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(CTDashboardStatements.UPDATE_TAT_FOR_ROUTES);
			pstmt.setInt(1, cf.convertHHMMToMinutes1(tAT));
			pstmt.setInt(2, systemId);
			pstmt.setInt(3, clientId);
			pstmt.setString(4, source);
			pstmt.setString(5, destination);
			int updated = pstmt.executeUpdate();
			if (updated > 0) {
				message = updated + " Routes updated successfully";
				pstmt1 = con.prepareStatement(CTDashboardStatements.UPDATE_AGGRESSIVE_TAT_DETAILS);
				pstmt1.setInt(1, cf.convertHHMMToMinutes1(tAT));
				pstmt1.setString(2, source);
				pstmt1.setString(3, destination);
				pstmt1.executeUpdate();
			}
			return message;
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, null);
			DBConnection.releaseConnectionToDB(null, pstmt1, null);
		}
		return errorMessage;

	}

	public JSONArray getUserWiseVehicleCount(int systemId, int clientId) {

		JSONObject obj = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		JSONArray jArr = new JSONArray();
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(CTDashboardStatements.GET_USER_WISE_VEHICLE_COUNT);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, clientId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				obj = new JSONObject();
				obj.put("count", rs.getString("COUNT"));
				obj.put("userName", rs.getString("User_Name"));
				jArr.put(obj);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jArr;
	}

	public JSONArray getAllAssociatedVehicles(int systemId, int clientId) {

		JSONObject obj = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		JSONArray jArr = new JSONArray();
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(CTDashboardStatements.GET_ALL_ASSOCIATED_VEHICLES);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, clientId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				obj = new JSONObject();
				obj.put("vehicleNo", rs.getString("VEHICLE_NO"));
				obj.put("userName", rs.getString("User_Name"));
				obj.put("vehCategory", rs.getString("VEHICLE_CATEGORY"));
				obj.put("customerName", rs.getString("CUSTOMER_NAME"));
				obj.put("vehType", rs.getString("VEHICLE_TYPE"));
				jArr.put(obj);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jArr;
	}

	public JSONArray getDelayDetails(int systemId, int clientId) {
		JSONObject obj = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		JSONArray jArr = new JSONArray();
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(CTDashboardStatements.GET_DELAY_DATA);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, clientId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				obj = new JSONObject();
				obj.put("delayCategory", rs.getString("DELAY_CATEGORY"));
				obj.put("delayCode", rs.getString("DELAY_CODE"));
				obj.put("delaytype", rs.getString("DELAY_TYPE"));
				jArr.put(obj);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jArr;
	}

	public JSONArray getUnloadingVehicles(int systemId, int clientId, int offset, String type) {
		JSONObject obj = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		JSONArray jArr = new JSONArray();
		try {
			con = DBConnection.getConnectionToDB("AMS");
			if ("TCL".equals(type)) {
				pstmt = con.prepareStatement(CTDashboardStatements.GET_UNLOADING_VEHICLES.replace("##", " and PRODUCT_LINE = 'TCL'"));
			} else if ("DRY".equals(type)) {
				pstmt = con.prepareStatement(CTDashboardStatements.GET_UNLOADING_VEHICLES.replace("##", " and PRODUCT_LINE != 'TCL'"));
			} else if ("TOTAL".equals(type)) {
				pstmt = con.prepareStatement(CTDashboardStatements.GET_UNLOADING_VEHICLES.replace("##", ""));
			}
			pstmt.setInt(1, offset);
			pstmt.setInt(2, offset);
			pstmt.setInt(3, systemId);
			pstmt.setInt(4, clientId);
			rs = pstmt.executeQuery();
			obj = new JSONObject();
			while (rs.next()) {
				obj = new JSONObject();
				obj.put("vehicleNo", rs.getString("REGISTRATION_NO"));
				obj.put("location", rs.getString("LOCATION"));
				obj.put("lastCommunication", sdf.format(sdfDB.parse(rs.getString("LAST_COMM"))));
				obj.put("ETA", sdf.format(sdfDB.parse(rs.getString("ETA"))));
				obj.put("detention", cf.convertMinutesToHHMMFormat(rs.getInt("DETENTION_TIME")));
				jArr.put(obj);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jArr;
	}

	public JSONArray getCTUserDashboardTripCount(int systemId, int clientId, int userId) {
		JSONArray jArr = new JSONArray();
		JSONObject obj = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		int onTime = 0;
		int delayedLessThanHr = 0;
		int delayedGreaterThanHr = 0;
		int unloadingLessThan = 0;
		int unloadingGreaterThan = 0;
		int loadingLessThan = 0;
		int loadingGreaterThan = 0;
		int breakdown = 0;
		int accident = 0;
		try {
			if (con == null) {
				con = DBConnection.getConnectionToDB("AMS");
			}
			/* Vinay H
			 * Below query fetches all trip related details based on USER_VEHICLE_ASSOCIATION
			 * i.e On Time, Delayed, Stopped, At Unloading. 
			 * Used Tables are GPS_Live, Track Trip Details, DES Trip Details and User Vehicle Association. 
			 */
			String statement = CTDashboardStatements.GET_CT_USER_TRIP_COUNTS;
			if (userId == 0) {
				statement = statement.replaceAll("#", "");
			} else {
				statement = statement.replaceAll("#", " and uva.USER_ID=" + userId);
			}
			pstmt = con.prepareStatement(statement);
			for (int i = 1; i <= 18; i++) {
				if (i % 2 == 0) {
					pstmt.setInt(i, clientId);
				} else {
					pstmt.setInt(i, systemId);
				}
			}
			rs = pstmt.executeQuery();
			while (rs.next()) {
				if ("ONTIME".equals(rs.getString("TYPE"))) {
					onTime = rs.getInt("COUNT");
				}
				if ("DELAYEDLESS".equals(rs.getString("TYPE"))) {
					delayedLessThanHr = rs.getInt("COUNT");
				}
				if ("DELAYEDGREATER".equals(rs.getString("TYPE"))) {
					delayedGreaterThanHr = rs.getInt("COUNT");
				}
				if ("UNLOADINGLESS".equals(rs.getString("TYPE"))) {
					unloadingLessThan = rs.getInt("COUNT");
				}
				if ("UNLOADINGGREATER".equals(rs.getString("TYPE"))) {
					unloadingGreaterThan = rs.getInt("COUNT");
				}
				if ("LOADINGLESS".equals(rs.getString("TYPE"))) {
					loadingLessThan = rs.getInt("COUNT");
				}
				if ("LOADINGGREATER".equals(rs.getString("TYPE"))) {
					loadingGreaterThan = rs.getInt("COUNT");
				}
				if ("BREAKDOWN".equals(rs.getString("TYPE"))) {
					breakdown = rs.getInt("COUNT");
				}
				if ("ACCIDENT".equals(rs.getString("TYPE"))) {
					accident = rs.getInt("COUNT");
				}
			}
			obj = new JSONObject();
			obj.put("ontime", onTime);
			obj.put("delayed", delayedGreaterThanHr + delayedLessThanHr);
			obj.put("delayedLessThan", delayedLessThanHr);
			obj.put("delayedGreaterThan", delayedGreaterThanHr);
			obj.put("unloading", unloadingLessThan + unloadingGreaterThan);
			obj.put("unloadingLessThan", unloadingLessThan);
			obj.put("unloadingGreater", unloadingGreaterThan);
			obj.put("loading", loadingLessThan + loadingGreaterThan);
			obj.put("loadingLessThan", loadingLessThan);
			obj.put("loadingGreater", loadingGreaterThan);
			obj.put("breakdown", breakdown);
			obj.put("accident", accident);
			//obj.put("delayedDeparture", delayedDeparture);
			jArr.put(obj);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jArr;
	}

	public JSONArray getCTUserDashboardListDetails(int systemId, int clientId, int userId, int offset, int nonCommHrs, String type) {
		JSONArray jArr = new JSONArray();
		JSONObject obj = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int count = 0;
		SimpleDateFormat dateFormatForArguements = new SimpleDateFormat("dd/MM/yyyy-HH:mm:ss");
		GeneralVerticalFunctions gf = new GeneralVerticalFunctions();
		try {
			if (con == null) {
				con = DBConnection.getConnectionToDB("AMS");
			}

			String condition = getConditionForMainQuery(type, nonCommHrs);

			String statement = CTDashboardStatements.GET_CT_USER_DASHBOARD_LIST_DETAILS;
			if (userId == 0) {
				statement = statement.replaceAll("#", "");
			} else {
				statement = statement.replaceAll("#", " and uva.USER_ID=" + userId);
			}
			pstmt = con.prepareStatement(statement.replace("condition", condition));
			pstmt.setInt(1, offset);
			pstmt.setInt(2, offset);
			pstmt.setInt(3, offset);
			pstmt.setInt(4, offset);
			pstmt.setInt(5, offset);
			pstmt.setInt(6, offset);
			pstmt.setInt(7, offset);
			pstmt.setInt(8, systemId);
			pstmt.setInt(9, clientId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				++count;
				obj = new JSONObject();
				obj.put("slNo", count);
				obj.put("customername", rs.getString("customerName"));

				String param = rs.getInt("TRIP_ID") + "," + "'" + rs.getString("vehicleNo") + "'" + "," + "'" + dateFormatForArguements.format(sdfDB.parse(rs.getString("INSERTED_TIME"))) + "'" + ","
						+ "'" + dateFormatForArguements.format(sdfDB.parse(rs.getString("endDate"))) + "'" + "," + "'" + rs.getString("status") + "'" + "," + rs.getInt("routeId");
				obj.put("tripno", "<p><a href='javascript:void(0);' onclick=showTripAndAlertDetails(" + param + ");>" + rs.getString("tripNo") + "</a></p>");

				obj.put("vehicleno", rs.getString("vehicleNo"));

				String gpsStatus = "Communicating";
				if (rs.getInt("lastCommunication") >= nonCommHrs) {
					gpsStatus = "Non Communicating";
				}
				obj.put("gpsstatus", gpsStatus);
				obj.put("routekey", rs.getString("routeKey"));
				obj.put("allTouchPoints", "<button id='addBtnId' " + "onclick=viewTouchPoints(" + rs.getInt("TRIP_ID") + "); class='btn btn-primary btn-sm text-center'>All Touch Points</button>");

				//obj.put("nexttouchingpoint", rs.getString("nexttouchPoint"));
				obj.put("currentspeed", rs.getDouble("speed"));
				obj.put("status", rs.getString("tripStatus"));

				String ATD = "";
				if (!rs.getString("ATD").contains("1900")) {
					ATD = sdf.format(sdfDB.parse(rs.getString("ATD")));
				}
				obj.put("ATD", ATD);

				String destinationEta = "";
				if (!rs.getString("destinationETA").contains("1900")) {
					destinationEta = sdf.format(sdfDB.parse(rs.getString("destinationETA")));
				}
				obj.put("destinationeta", destinationEta);
				obj.put("drivers", rs.getString("driverName"));
				obj.put("drivercontacts", rs.getString("driverMobile"));
				obj.put("delayReason", "<div class='col-lg-1 col-md-1 col-xs-1' style='white-space: nowrap'><button id='addBtnId' onclick=addRemarks(" + rs.getString("TRIP_ID") + "," + "'"
						+ rs.getString("TRIP_CUSTOMER_REF_ID") + "'" + "," + "'" + rs.getString("vehicleNo") + "'" + "," + "); class='btn btn-primary btn-sm text-center'>Add</button>"
						+ "<button id='viewBtnId' onclick=viewRemarks(" + rs.getString("TRIP_ID") + "); "
						+ "class='btn btn-info btn-sm text-center'>View</button></div>");

				if (rs.getString("PRODUCT_LINE").equals("TCL")) {
					String actualTemperature = "NA";
					String plannedTempStr = getPlannedTemperature(rs.getInt("TRIP_ID"), con);
					if(!"NA".equalsIgnoreCase(plannedTempStr)){
						String[] plannedTemp = plannedTempStr.split("to");
						double PlannedTemp = (Double.parseDouble(plannedTemp[0].trim()) + Double.parseDouble(plannedTemp[1].trim())) / 2;
						actualTemperature = String.valueOf(getActualTemperature(rs.getString("vehicleNo"), PlannedTemp, con));
					}
					obj.put("plannedTemperature", plannedTempStr);
					obj.put("actualTemperature", String.valueOf(actualTemperature));
				} else {
					obj.put("plannedTemperature", "NA");
					obj.put("actualTemperature", "NA");
				}
				if (!rs.getString("DELAY_TIME").contains("1900")) {
					obj.put("lastDelayUpdatedTime", sdf.format(sdfDB.parse(rs.getString("DELAY_TIME"))));
				} else {
					obj.put("lastDelayUpdatedTime", "");
				}
				obj.put("delayType", rs.getString("DELAY_TYPE"));

				String STA = "";
				if (!rs.getString("STA").contains("1900")) {
					STA = sdf.format(sdfDB.parse(rs.getString("STA")));
				}
				
				String STA_ON_ATD = STA;
				if (!rs.getString("STA_ON_ATD").contains("1900")) {
					STA_ON_ATD = sdf.format(sdfDB.parse(rs.getString("STA_ON_ATD")));
				}
				
				String td = gf.getTransitDealy("",destinationEta, STA_ON_ATD);
				obj.put("transitDelay", td);
				
				jArr.put(obj);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jArr;
	}

	private String getConditionForMainQuery(String type, int nonCommHrs) {
		String condition = "";
		if ("inTransit".equalsIgnoreCase(type)) {
			condition = " and td.ACTUAL_TRIP_START_TIME is not null and de.ACT_ARR_DATETIME is null";
		} else if ("planned".equalsIgnoreCase(type)) {
			condition = " and td.ACT_SRC_ARR_DATETIME is null";
		} else if ("nonCommunicating".equalsIgnoreCase(type)) {
			condition = " and DATEDIFF(hh,GMT,getutcdate()) >=" + nonCommHrs;
		} else if ("ontime".equalsIgnoreCase(type)) {
			condition = " and td.TRIP_STATUS='ON TIME' and td.ACTUAL_TRIP_START_TIME is not null and de.ACT_ARR_DATETIME is null ";
		} else if ("delayed".equalsIgnoreCase(type)) {
			condition = " and td.TRIP_STATUS='DELAYED' and td.ACTUAL_TRIP_START_TIME is not null and de.ACT_ARR_DATETIME is null ";
		} else if ("delayedLess".equalsIgnoreCase(type)) {
			condition = " and td.TRIP_STATUS='DELAYED' and td.ACTUAL_TRIP_START_TIME is not null and de.ACT_ARR_DATETIME is null and td.DELAY <= 60 ";
		} else if ("delayedGreater".equalsIgnoreCase(type)) {
			condition = " and td.TRIP_STATUS='DELAYED' and td.ACTUAL_TRIP_START_TIME is not null and de.ACT_ARR_DATETIME is null and td.DELAY > 60 ";
		} else if ("unloading".equalsIgnoreCase(type)) {
			condition = " and de.ACT_ARR_DATETIME is not null ";
		} else if ("unloadingLess".equalsIgnoreCase(type)) {
			condition = " and de.ACT_ARR_DATETIME is not null and datediff(HOUR,de.ACT_ARR_DATETIME,GETUTCDATE()) <= 24";
		} else if ("unloadingGeater".equalsIgnoreCase(type)) {
			condition = " and de.ACT_ARR_DATETIME is not null and datediff(HOUR,de.ACT_ARR_DATETIME,GETUTCDATE()) > 24";
		} else if ("loading".equalsIgnoreCase(type)) {
			condition = " and td.ACT_SRC_ARR_DATETIME is not null and ACTUAL_TRIP_START_TIME is null ";
		} else if ("loadingLess".equalsIgnoreCase(type)) {
			condition = " and td.ACT_SRC_ARR_DATETIME is not null and ACTUAL_TRIP_START_TIME is null and datediff(HOUR,td.ACT_SRC_ARR_DATETIME,GETUTCDATE()) <= 24";
		} else if ("loadingGreater".equalsIgnoreCase(type)) {
			condition = " and td.ACT_SRC_ARR_DATETIME is not null and ACTUAL_TRIP_START_TIME is null and datediff(HOUR,td.ACT_SRC_ARR_DATETIME,GETUTCDATE()) > 24";
		} else if ("breakdown".equalsIgnoreCase(type)) {
			condition = " and td.TRIP_ID in ( select TRIP_ID from TRIP_REMARKS_DETAILS where SUBISSUE_TYPE IN ('VEHICLE BREAKDOWN'))";
		} else if ("accident".equalsIgnoreCase(type)) {
			condition = " and td.TRIP_ID in ( select TRIP_ID from TRIP_REMARKS_DETAILS where SUBISSUE_TYPE IN ('VEHICLE ACCIDENT'))";
		} else if ("departuredelay".equalsIgnoreCase(type)) {
			condition = "and TRIP_STATUS='DELAYED' and de.SEQUENCE=100 and (ACTUAL_TRIP_START_TIME>td.TRIP_START_TIME and (DATEDIFF(mi,isnull(td.DEST_ARR_TIME_ON_ATD, "
				+ " de.PLANNED_ARR_DATETIME),DESTINATION_ETA) < DATEDIFF(mi,td.TRIP_START_TIME,ACTUAL_TRIP_START_TIME)))";
		}
		return condition;
	}

	public JSONArray getAllTouchPointsofTrip(String tripId) {
		JSONArray jArr = new JSONArray();
		JSONObject obj = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			if (con == null) {
				con = DBConnection.getConnectionToDB("AMS");
			}
			pstmt = con.prepareStatement(CTDashboardStatements.GET_TRIP_TOUCHPOINT_DETAILS);
			pstmt.setString(1, tripId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				obj = new JSONObject();
				obj.put("touchpointname", rs.getString("NAME"));
				obj.put("detention", cf.convertMinutesToHHMMFormat(rs.getInt("detentionTime")));
				jArr.put(obj);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jArr;
	}

	public JSONArray getSnoozeCounts(int systemId, int clientId, int userId) {
		JSONArray jArr = new JSONArray();
		JSONObject obj = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int pausedAlert= 0;
		int snoozeTime = 0;
		try {
			if (con == null) {
				con = DBConnection.getConnectionToDB("AMS");
			}
			
			String statement = CTDashboardStatements.GET_SNOOZE_ALERT_COUNTS;
			if (userId == 0) {
				statement = statement.replaceAll("#", "");
			} else {
				statement = statement.replaceAll("#", " and uva.USER_ID=" + userId);
			}
			pstmt = con.prepareStatement(statement);
			for (int i = 1; i <= 8; i++) {
				if (i % 2 == 0) {
					pstmt.setInt(i, clientId);
				} else {
					pstmt.setInt(i, systemId);
				}
			}
			rs = pstmt.executeQuery();
			while (rs.next()) {
				if ("SNOOZE".equals(rs.getString("TYPE"))) {
					pausedAlert = rs.getInt("COUNT");
				}
				if("SNOOZE_TIME".equals(rs.getString("TYPE"))){
					snoozeTime = rs.getInt("COUNT");
				}
			}
			obj = new JSONObject();
			obj.put("pausedAlert", pausedAlert);
			obj.put("snoozeTime", snoozeTime);
			jArr.put(obj);
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jArr;
		
	}
	public JSONArray getCTUserDashboardAlertCount(int systemId, int clientId, int userId) {
		JSONArray jArr = new JSONArray();
		JSONObject obj = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		int enrouteSHDetention = 0;
		int routeDeviation = 0;
		int customerHubMissed = 0;
		int smartHubMissed = 0;
		int stoppage = 0;
		int temperatureDeviation = 0;
		int nonCommunicating = 0;
		int idleAlert = 0;
		
		try {
			if (con == null) {
				con = DBConnection.getConnectionToDB("AMS");
			}
			/* Vinay H
			 * Below query will get the Alert details such as :
			 * 1. Enroute customer hub detention - 204 (not yet implemented)
			 * 2. Enroute smart hub detention  - 204
			 * 3. Route Deviation - 5
			 * 4. Touch Point Miss - 205,206
			 */
			String statement = CTDashboardStatements.GET_TRIP_ALERT_COUNTS;
			if (userId == 0) {
				statement = statement.replaceAll("#", "");
			} else {
				statement = statement.replaceAll("#", " and uva.USER_ID=" + userId);
			}
			pstmt = con.prepareStatement(statement);
			for (int i = 1; i <= 32; i++) {
				if (i % 2 == 0) {
					pstmt.setInt(i, clientId);
				} else {
					pstmt.setInt(i, systemId);
				}
			}
			rs = pstmt.executeQuery();
			while (rs.next()) {
				if ("STOPPAGESH".equals(rs.getString("TYPE"))) {
					enrouteSHDetention = rs.getInt("COUNT");
				}
				if ("ROUTEDEVIATE".equals(rs.getString("TYPE"))) {
					routeDeviation = rs.getInt("COUNT");
				}
				if ("CHMISSED".equals(rs.getString("TYPE"))) {
					customerHubMissed = rs.getInt("COUNT");
				}
				if ("SHMISSED".equals(rs.getString("TYPE"))) {
					smartHubMissed = rs.getInt("COUNT");
				}
				if ("STOPPAGE".equals(rs.getString("TYPE"))) {
					stoppage = rs.getInt("COUNT");
				}
				if ("TEMPERATUREDEVIATION".equals(rs.getString("TYPE"))) {
					temperatureDeviation = rs.getInt("COUNT");
				}
				if ("NONCOMM".equals(rs.getString("TYPE"))) {
					nonCommunicating = rs.getInt("COUNT");
				}
				if ("IDLEALERT".equals(rs.getString("TYPE"))) {
					idleAlert = rs.getInt("COUNT");
				}
				
			}
			obj = new JSONObject();
			obj.put("enrouteSHDetention", enrouteSHDetention);
			obj.put("routeDeviation", routeDeviation);
			obj.put("touchPointMissing", customerHubMissed);
			obj.put("smartHubMiss", smartHubMissed);
			obj.put("unplannedStoppage", stoppage);
			obj.put("tempDeviation", temperatureDeviation);
			obj.put("nonCommunicatingVehicle", nonCommunicating);
			obj.put("idleAlert", idleAlert);
			jArr.put(obj);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jArr;
	}

	public JSONArray getCTUserDashboardVehicleCount(int systemId, int clientId, int userId, int nonCommHrs) {
		JSONArray jArr = new JSONArray();
		JSONObject obj = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		int totalVehicles = 0;
		int planned = 0;
		int inTransit = 0;
		int nonCommunicating = 0;
		try {
			if (con == null) {
				con = DBConnection.getConnectionToDB("AMS");
			}
			/* Vinay H
			 * Below query fetches all vehicle related details based on USER_VEHICLE_ASSOCIATION
			 * i.e Total, Planned, In Transit, Non Communicating.
			 * Used Tables are GPS_Live, Track Trip Details and User Vehicle Association. 
			 */
			String statement = CTDashboardStatements.GET_CT_USER_VEHICLE_COUNTS;
			if (userId == 0) {
				statement = statement.replaceAll("#", "");
			} else {
				statement = statement.replaceAll("#", " and uva.USER_ID=" + userId);
			}
			pstmt = con.prepareStatement(statement);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, clientId);
			pstmt.setInt(3, systemId);
			pstmt.setInt(4, clientId);
			pstmt.setInt(5, systemId);
			pstmt.setInt(6, clientId);
			pstmt.setInt(7, nonCommHrs);
			pstmt.setInt(8, systemId);
			pstmt.setInt(9, clientId);
			pstmt.setInt(10, nonCommHrs);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				if ("TOTAL_VEHICLES".equals(rs.getString("TYPE"))) {
					totalVehicles = rs.getInt("COUNT");
				}
				if ("PLANNED".equals(rs.getString("TYPE"))) {
					planned = rs.getInt("COUNT");
				}
				if ("INTRANSIT".equals(rs.getString("TYPE"))) {
					inTransit = rs.getInt("COUNT");
				}
				if ("NON_COMM".equals(rs.getString("TYPE"))) {
					nonCommunicating = rs.getInt("COUNT");
				}
			}
			obj = new JSONObject();
			obj.put("totalVehicle", totalVehicles);
			obj.put("planned", planned);
			obj.put("intransit", inTransit);
			obj.put("nonCommunicating", nonCommunicating);

			jArr.put(obj);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jArr;
	}

	public JSONArray getIssueTypeFromCTAdmin(int systemId, int clientId) {
		JSONArray jArr = new JSONArray();
		JSONObject obj = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			if (con == null) {
				con = DBConnection.getConnectionToDB("AMS");
			}
			String statement = CTDashboardStatements.GET_ISSUE_TYPE_FROM_CT_ADMIN;
			pstmt = con.prepareStatement(statement);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, clientId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				obj = new JSONObject();
				obj.put("issueType", rs.getString("DELAY_CATEGORY"));
				jArr.put(obj);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jArr;
	}

	public JSONArray getSubIssueTypeFromCTAdmin(int systemId, int clientId) {
		JSONArray jArr = new JSONArray();
		JSONObject obj = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			if (con == null) {
				con = DBConnection.getConnectionToDB("AMS");
			}
			String statement = CTDashboardStatements.GET_SUB_ISSUE_TYPE_FROM_CT_ADMIN;
			pstmt = con.prepareStatement(statement);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, clientId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				obj = new JSONObject();
				obj.put("subIssueType", rs.getString("DELAY_TYPE"));
				jArr.put(obj);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jArr;
	}

	public String saveRemarksDetails(int systemId, int clientId, int userId, String startDate, String endDate, String delayType, String delaytime, String remarks, String tripId, int offset,
			String vehicleNo) {
		Connection con = null;
		PreparedStatement pstmt = null;
		String message = "";
		String location = "";
		PreparedStatement pstmt1 = null;
		ResultSet rs = null;
		try {
			con = DBConnection.getConnectionToDB("AMS");
			String sDate = cf.getLocalDateTime(MMddyyyyHHmmss.format(sdf.parse(startDate)), offset);
			String eDate = cf.getLocalDateTime(MMddyyyyHHmmss.format(sdf.parse(endDate)), offset);

			//To get first location where delay started
			location = getLocationFromStartandEndDate(con, clientId, sDate, vehicleNo, eDate, systemId);

			pstmt = con.prepareStatement(CTDashboardStatements.INSERT_REMARK_DETAILS);
			pstmt.setString(1, remarks);
			pstmt.setString(2, location);
			pstmt.setString(3, sdfDB.format(MMddyyyyHHmmss.parse(sDate)));
			pstmt.setString(4, sdfDB.format(MMddyyyyHHmmss.parse(eDate)));
			pstmt.setString(5, delaytime);
			pstmt.setString(6, delayType);
			pstmt.setInt(7, systemId);
			pstmt.setInt(8, clientId);
			pstmt.setInt(9, userId);
			pstmt.setString(10, tripId);
			int inserted = pstmt.executeUpdate();
			if (inserted > 0) {
				message = "Delay reason saved successfully";
				if (delayType.equals("VEHICLE BREAKDOWN") || delayType.equals("VEHICLE ACCIDENT")) {
					String orderId = "";
					String routeKey = "";
					String latitude = "";
					String longitude = "";
					String drivers = "";
					String driverContacts = "";
					pstmt1 = con.prepareStatement(CTDashboardStatements.GET_TRIP_DETAILS);
					pstmt1.setString(1, tripId);
					rs = pstmt1.executeQuery();
					if (rs.next()) {
						location = rs.getString("LOCATION");
						orderId = rs.getString("TRIP_NO");
						routeKey = rs.getString("ROUTE_KEY");
						latitude = rs.getString("LATITUDE");
						longitude = rs.getString("LONGITUDE");
						drivers = rs.getString("DRIVERS");
						driverContacts = rs.getString("DRIVER_CONTACTS");
					}
					List<SmartHubDetails> smartHubDetails = getAllSmartHubs(con, systemId, clientId);
					SmartHubDetails nearestSmartHub = getNearestSmartHub(smartHubDetails, Double.parseDouble(latitude), Double.parseDouble(longitude));
					sendMail(systemId, delayType, sdf.format(MMddyyyyHHmmss.parse(sDate)), sdf.format(MMddyyyyHHmmss.parse(eDate)), vehicleNo, con,
							location, orderId, routeKey, nearestSmartHub.getHubId(), drivers, driverContacts);
				}
			} else {
				message = errorMessage;
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
			DBConnection.releaseConnectionToDB(null, pstmt1, null);
		}
		return message;
	}

	private SmartHubDetails getNearestSmartHub(List<SmartHubDetails> routePoints, double vehicleLat, double vehicleLon) {
		Map<Double, SmartHubDetails> map = new TreeMap<Double, SmartHubDetails>();
		for (SmartHubDetails smartHubDetails : routePoints) {
			double distance = calculateDistance(vehicleLat, smartHubDetails.getLatitude(), vehicleLon, smartHubDetails.getLongitude());
			map.put(distance, smartHubDetails);
		}
		Entry<Double, SmartHubDetails> entry = null;
		if (map.entrySet().iterator().hasNext()) {
			entry = map.entrySet().iterator().next();
			return entry.getValue();
		}
		return null;
	}

	private double calculateDistance(double lat1, double lat2, double lon1, double lon2) {

		final int R = 6378100; // Radius of the earth
		double pi = 3.141593;
		double toRad = pi / 180;
		double latDistance = (lat2 * toRad) - (lat1 * toRad);
		double lonDistance = (lon2 * toRad) - (lon1 * toRad);
		double a = Math.sin(latDistance / 2) * Math.sin(latDistance / 2) + Math.cos(lat1 * toRad) * Math.cos(lat2 * toRad) * Math.sin(lonDistance / 2) * Math.sin(lonDistance / 2);
		double c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
		double distance = R * c;

		return Double.parseDouble(df.format(distance));
	}

	private List<SmartHubDetails> getAllSmartHubs(Connection con, int systemId, int custId) throws SQLException {
		List<SmartHubDetails> hubDetails = new ArrayList<SmartHubDetails>();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		pstmt = con.prepareStatement(CTDashboardStatements.GET_ALL_SMART_HUB_DETAILS);
		pstmt.setInt(1, systemId);
		pstmt.setInt(2, custId);
		rs = pstmt.executeQuery();
		while (rs.next()) {
			SmartHubDetails smartHubDetails = new SmartHubDetails(rs.getDouble("LATITUDE"), rs.getDouble("LONGITUDE"), rs.getInt("HUBID"));
			hubDetails.add(smartHubDetails);
		}
		DBConnection.releaseConnectionToDB(null, pstmt, rs);
		return hubDetails;
	}

	private void sendMail(int systemId, String delayType, String sDate, String eDate, String vehicleNo, Connection con, String location,
			String orderId, String routeKey, int hubId, String drivers, String driverContacts) {
		PreparedStatement pstmtMail = null;
		PreparedStatement pstmtUserList = null;
		String userList = "";
		ResultSet rs = null;
		try {
			pstmtUserList = con.prepareStatement("select Emailed as EMAILS from Users where ROLE_ID in (" + 15 + ")" +
					" union " +
					" select EMAILS from HUB_ROLE_USER_ASSOCIATE where HUB_ID=? and SYSTEM_ID=? and LEVEL_NO<4");
			pstmtUserList.setInt(1, hubId);
			pstmtUserList.setInt(2, systemId);
			rs = pstmtUserList.executeQuery();
			while (rs.next()) {
				userList = rs.getString("EMAILS") + "," + userList ;
			}
			userList = userList.substring(0, userList.length() - 1);
			String subject = "";
			String body = "";
			if (delayType.equals("VEHICLE BREAKDOWN")) {
				subject = "Vehicle Breakdown - "+vehicleNo;
				body = "<html><head><title>Alert</title></head><body><h1 style='color:red;'>Breakdown!</h1><p><b>Trip No</b> :: " + orderId + "</p><p><b>Vehicle No</b> :: " + vehicleNo
				+ "</p><p><b>Current location</b> :: " + location + "</p><p><b>Route Key</b> :: " + routeKey + "</p><p><b>Drivers</b> :: " + drivers + "</p><p><b>Driver Contacts</b> :: " + driverContacts + "</p><p><b>Incident recorded time</b> :: " + sDate + "</p></body></html> ";
			} else if (delayType.equals("VEHICLE ACCIDENT")) {
				subject = "Vehicle Accident - "+vehicleNo;
				body = "<html><head><title>Alert</title></head><body><h1 style='color:red;'>Accident!</h1><p><b>Trip No</b> :: " + orderId + "</p><p><b>Vehicle No</b> :: " + vehicleNo
						+ "</p><p><b>Current location</b> :: " + location + "</p><p><b>Route Key</b> :: " + routeKey + "</p><p><b>Drivers</b> :: " + drivers + "</p><p><b>Driver Contacts</b> :: " + driverContacts + "</p><p><b>Incident recorded time</b> :: " + sDate + "</p></body></html> ";
			}
			pstmtMail = con.prepareStatement("insert into AMS.dbo.EmailQueue(Subject,Body,EmailList,SystemId) values (?,?,?,?)");
			pstmtMail.setString(1, subject);
			pstmtMail.setString(2, body);
			pstmtMail.setString(3, userList);
			pstmtMail.setInt(4, systemId);
			pstmtMail.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(null, pstmtMail, rs);
			DBConnection.releaseConnectionToDB(null, pstmtUserList, null);
		}
	}

	private String getLocationFromStartandEndDate(Connection con, int clientId, String sDate, String vehicleNo, String eDate, int systemId) {
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String location = "";
		try {
			pstmt = con.prepareStatement(CTDashboardStatements.GET_LOCATION_FROM_GPS_DATA.replaceAll("#", String.valueOf(systemId)));
			pstmt.setInt(1, clientId);
			pstmt.setString(2, vehicleNo);
			pstmt.setString(3, sdfDB.format(MMddyyyyHHmmss.parse(sDate)));
			pstmt.setString(4, sdfDB.format(MMddyyyyHHmmss.parse(eDate)));
			pstmt.setInt(5, clientId);
			pstmt.setString(6, vehicleNo);
			pstmt.setString(7, sdfDB.format(MMddyyyyHHmmss.parse(sDate)));
			pstmt.setString(8, sdfDB.format(MMddyyyyHHmmss.parse(eDate)));
			rs = pstmt.executeQuery();
			if (rs.next()) {
				location = rs.getString("LOCATION");
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(null, pstmt, rs);
		}
		return location;
	}

	public JSONArray getDelayRasons(String tripId, int offset) {
		JSONArray jArr = new JSONArray();
		JSONObject obj = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int count = 0;
		try {
			if (con == null) {
				con = DBConnection.getConnectionToDB("AMS");
			}
			pstmt = con.prepareStatement(CTDashboardStatements.GET_DELAY_REASONS);
			pstmt.setInt(1, offset);
			pstmt.setInt(2, offset);
			pstmt.setInt(3, offset);
			pstmt.setString(4, tripId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				++count;
				obj = new JSONObject();
				obj.put("slNo", count);
				obj.put("customername", rs.getString("CUSTOMER_NAME"));
				obj.put("tripno", rs.getString("ORDER_ID"));
				obj.put("vehicleno", rs.getString("ASSET_NUMBER"));
				obj.put("delayType", rs.getString("delayType"));
				obj.put("delayCategory", rs.getString("DELAY_CATEGORY"));
				obj.put("location", rs.getString("LOCATION_OF_DELAY"));
				obj.put("delayStart", sdf.format(sdfDB.parse(rs.getString("delayStart"))));
				obj.put("delayEnd", sdf.format(sdfDB.parse(rs.getString("delayEnd"))));
				obj.put("delayTime", rs.getString("DELAYTIME"));
				obj.put("remarks", rs.getString("remarks"));
				obj.put("addedBy", rs.getString("addedBy"));
				obj.put("addedDate", sdf.format(sdfDB.parse(rs.getString("addedDate"))));
				jArr.put(obj);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jArr;
	}

	public void disassociateVehicles(Connection con, int systemId, int clientId, String vehicleNo, Integer tripId, LogWriter logWriter) {
		PreparedStatement pstmt = null;
		PreparedStatement pstmtMove = null;
		ResultSet rs = null;
		try {
			if (con == null) {
				con = DBConnection.getConnectionToDB("AMS");
			}
			pstmtMove = con.prepareStatement(CTDashboardStatements.MOVE_VEHICLE_ASSOCIATION_DATA);
			pstmtMove.setInt(1, tripId);
			int updated = pstmtMove.executeUpdate();
			if (updated > 0) {
				pstmt = con.prepareStatement(CTDashboardStatements.DISASSOCIATE_VEHICLE_DATA);
				pstmt.setInt(1, tripId);
				pstmt.setInt(2, systemId);
				pstmt.setInt(3, clientId);
				pstmt.executeUpdate();
				logWriter.log("Disociated vehicle from users " + tripId, LogWriter.INFO);
			}
		} catch (Exception e) {
			logWriter.log("Disocciation Failed : " + tripId+". "+e.getMessage(), LogWriter.ERROR);
		} finally {
			DBConnection.releaseConnectionToDB(null, pstmt, rs);
			DBConnection.releaseConnectionToDB(null, pstmtMove, null);
			logWriter.log("Disociated vehicle from users block ended. " + tripId, LogWriter.INFO);
		}
	}

	public String uploadSupervisorScheduleTableFromExcel(List<SupervisorScheduleModel> supervisorScheduleList) {
		Connection con = null;
		PreparedStatement prepStmt = null;
		PreparedStatement pstmtDelete = null;
		try {
			con = DBConnection.getConnectionToDB("AMS");

			con.setAutoCommit(false);

			prepStmt = con.prepareStatement(CTDashboardStatements.INSERT_SUPERVISOR_SCHEDULE);
			pstmtDelete = con.prepareStatement(CTDashboardStatements.DELETE_SUPERVISOR_SCHEDULE);
			pstmtDelete.executeUpdate();
			for (int i = 0; i < supervisorScheduleList.size(); i++) {
				prepStmt.setString(1, supervisorScheduleList.get(i).getSupervisorName());
				prepStmt.setString(2, supervisorScheduleList.get(i).getHubName());
				prepStmt.setString(3, supervisorScheduleList.get(i).getHubCode());
				prepStmt.setString(4, supervisorScheduleList.get(i).getShiftStartTiming());
				prepStmt.setString(5, supervisorScheduleList.get(i).getShiftEndTiming());
				prepStmt.setString(6, supervisorScheduleList.get(i).getContactNumber());
				prepStmt.setInt(7, supervisorScheduleList.get(i).getSystemId());
				prepStmt.setInt(8, supervisorScheduleList.get(i).getCustomerId());
				prepStmt.addBatch();
			}
			prepStmt.executeBatch();
			con.commit();

			return "Inserted.";
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, prepStmt, null);
			DBConnection.releaseConnectionToDB(con, pstmtDelete, null);
		}
		return errorMessage;
	}
	


	public JSONArray loadAllSupervisorSchedule(int systemId, int customerId) {

		JSONObject obj = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		JSONArray jArr = new JSONArray();
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(CTDashboardStatements.GET_SUPERVISOR_SCHEDULE);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, customerId);

			rs = pstmt.executeQuery();
			while (rs.next()) {
				obj = new JSONObject();

				obj.put("supervisorName", rs.getString("SUPERVISOR_NAME"));
				obj.put("hubName", rs.getString("HUB_NAME"));
				obj.put("hubCode", rs.getString("HUB_CODE"));
				obj.put("shiftStartTiming", rs.getString("SHIFT_START_TIMING"));
				obj.put("shiftEndTiming", rs.getString("SHIFT_END_TIME"));
				obj.put("contactNumber", rs.getString("CONTACT_NUMBER"));
				obj.put("excelUploadTime", rs.getString("EXCEL_UPLOAD_TIME"));
				jArr.put(obj);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jArr;
	}

	public JSONArray getAlertDetails(int systemId, int customerId, int alertId, int userId) {

		JSONObject obj = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		JSONArray jArr = new JSONArray();
		String statement = "";
		
		try {
			con = DBConnection.getConnectionToDB("AMS");
			if (alertId == 5) {
				statement = CTDashboardStatements.GET_ALERT_DETAILS_FOR_ROUTE_DEVIATION;
			} else if (alertId == 202) {
				statement = CTDashboardStatements.GET_ALERT_DETAILS_FOR_STOPPAGE;
			} else if (alertId == 85) {
				statement = CTDashboardStatements.GET_ALERT_DETAILS_FOR_NONCOMM;
			} else if (alertId == 206 || alertId == 205) {
				statement = CTDashboardStatements.GET_ALERT_DETAILS_FOR_CH_SH_MISSED;
			} else if (alertId == 216) {
				statement = CTDashboardStatements.GET_ALERT_DETAILS_FOR_TEMP_DEVIATION;
			} else if (alertId == 204) {
				statement = CTDashboardStatements.GET_ALERT_DETAILS_FOR_SH_DETENTION;
			} else if (alertId == 39) {
				statement = CTDashboardStatements.GET_ALERT_DETAILS_FOR_IDLE;
			} else if(alertId == 0){
				statement = CTDashboardStatements.GET_ALERT_DETAILS_FOR_SNOOZE;
			}
			if (userId == 0) {
				statement = statement.replaceAll("#", "");
			} else {
				statement = statement.replaceAll("#", " and uva.USER_ID=" + userId);
			}
			if(alertId!=0){
			pstmt = con.prepareStatement(statement);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, customerId);
			pstmt.setInt(3, alertId);
			pstmt.setInt(4, systemId);
			pstmt.setInt(5, customerId);
			}else{
			pstmt = con.prepareStatement(statement);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, customerId);
			pstmt.setInt(3, systemId);
			pstmt.setInt(4, customerId);
			}
			rs = pstmt.executeQuery();
			
			ResultSetMetaData rsmd = rs.getMetaData();
			int columnCount = rsmd.getColumnCount();
			for (int i = 1; i <= columnCount; i++) {
				obj.put(String.valueOf(i), rsmd.getColumnName(i));
			}
			jArr.put(obj);
			while (rs.next()) {
				obj = new JSONObject();
				for (int i = 1; i <= columnCount; i++) {
					if (alertId == 216 && i == 11) {
						String[] plannedTemp = rs.getString("Planned Temperature(°C)").split("to");
						double PlannedTemp = (Double.parseDouble(plannedTemp[0].trim()) + Double.parseDouble(plannedTemp[1].trim())) / 2;
						String actualTemperature = String.valueOf(getActualTemperature(rs.getString("Vehicle No"), PlannedTemp,con));
						obj.put(String.valueOf(i), actualTemperature);
					} else {
						obj.put(String.valueOf(i), rs.getString(rsmd.getColumnName(i)));
					}
				}
				jArr.put(obj);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jArr;
	}

	private String getPlannedTemperature(int tripId, Connection con) throws SQLException {
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String plannedTemp = "NA";
		pstmt = con.prepareStatement(CTDashboardStatements.GET_PLANNED_TEMP);
		pstmt.setInt(1, tripId);
		rs = pstmt.executeQuery();
		if (rs.next()) {
			plannedTemp = rs.getString("MIN_POSITIVE_TEMP")+" to "+rs.getString("MAX_NEGATIVE_TEMP");
		}
		return plannedTemp;
	}
 
	private Double getActualTemperature(String regNo, double plannedTemp, Connection con) {
		Double[] temp = new Double[3];
		int j = 0;
		int index = 0;
		try {
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			pstmt = con.prepareStatement(CTDashboardStatements.GET_LIVE_TEMPERATURE);
			pstmt.setString(1, regNo);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				if (rs.getString("IO_VALUE").equals("NA")) {
					temp[j] = 0.0;
				} else {
					temp[j] = rs.getDouble("IO_VALUE");
				}
				j++;
			}
			double meanTemp = plannedTemp;
			double diff1;
			double diff2 = Math.abs(temp[0] - meanTemp);

			for (int i = 1; i < temp.length; i++) {
				diff1 = Math.abs(temp[i] - meanTemp);
				if (diff1 < diff2) {
					index = i;
					diff2 = diff1;
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		return temp[index];
	}

	public JSONArray getRoles(int systemId, int clientId) {
		JSONArray jArr = new JSONArray();
		JSONObject obj = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			if (con == null) {
				con = DBConnection.getConnectionToDB("AMS");
			}
			String statement = CTDashboardStatements.GET_ROLES;
			pstmt = con.prepareStatement(statement);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, clientId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				obj = new JSONObject();
				obj.put("roleName", rs.getString("ROLE_NAME"));
				obj.put("roleId", rs.getString("ROLE_ID"));
				jArr.put(obj);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jArr;
	}

	public JSONArray updateRemarks(int systemId, String remarksList, String userName, String alertId) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String slno = "";
		String remarks = "";
		String oldRemarks = "";
		String snooze = "";
		int count = 0;
		int snoozeCount = 0;
		int alertSnoozecnt = 0;
		int cnt = 0;
		int oldRmrkCnt = 0;
		JSONArray snoozedArr = new JSONArray();
		JSONArray updatedRemarksArr = new JSONArray();
		JSONArray oldRemarksArr = new JSONArray();
		JSONArray alreadySnoozedArr = new JSONArray();
		JSONArray errorList = new JSONArray();
		JSONArray finalArray = new JSONArray();
		String regNo = "";
		try {
			con = DBConnection.getConnectionToDB("AMS");
			JSONArray arr = new JSONArray(remarksList);
			
			for (int i = 0; i < arr.length(); i++) {
				JSONObject obj = arr.getJSONObject(i);
				slno = obj.getString("slNo");
				remarks = obj.getString("remarks");
				snooze = obj.getString("snooze");
				if(snooze!=null && Integer.parseInt(snooze) == 0){
					if (!(slno.equals("")) && !(remarks.equals(""))) {
						pstmt = con.prepareStatement(CTDashboardStatements.GET_REMARKS_FROM_ALERT);
						pstmt.setString(1, slno);
						rs = pstmt.executeQuery();
						if (rs.next()) {
							oldRemarks = rs.getString("TEMP_REMARKS");
						}
						if ( oldRemarks == null || !(oldRemarks.equals(remarks)) ) {
							pstmt = con.prepareStatement(CTDashboardStatements.UPDATE_REMARKS_ALERT);
							try {
								pstmt.setString(1, remarks);
								pstmt.setString(2, userName);
								pstmt.setString(3, slno);
								pstmt.executeUpdate();
								count++;
								updatedRemarksArr.put("");
							} catch (Exception e) {
								e.printStackTrace();
							}
						}else{
							oldRmrkCnt++;
							oldRemarksArr.put("");
						}
					}
				} else {
					snoozeCount = 0;
					alertSnoozecnt = 0;
					if (!snooze.equals("")) {
						snoozeCount++;
						pstmt = con.prepareStatement(CTDashboardStatements.GET_SNOOZE_COUNT_FROM_ALERT);
						pstmt.setString(1, slno);
						rs = pstmt.executeQuery();
						if (rs.next()) {
							alertSnoozecnt = rs.getInt("SNOOZE_COUNT");
							regNo = rs.getString("REGISTRATION_NO");
						}
						snoozeCount = (alertSnoozecnt + snoozeCount);

						if (!(slno.equals("")) && !(remarks.equals(""))) {
							if (snoozeCount <= 2) {
								try {
									pstmt = con.prepareStatement(CTDashboardStatements.UPDATE_TEMPORARY_REMARKS_ALERT);
									pstmt.setString(1, remarks);
									pstmt.setInt(2, Integer.parseInt(snooze));
									pstmt.setInt(3, snoozeCount);
									pstmt.setString(4, slno);
									int j = pstmt.executeUpdate();
									if (j == 1) {
										count++;
										snoozedArr.put(regNo);
									}

								} catch (Exception e) {
									e.printStackTrace();
								}
							} else if (snoozeCount > 2) {
								cnt++;
								alreadySnoozedArr.put(regNo);
							} else {
								errorList.put("Error while acknowledging the alerts!!");
							}
						}
					}
				}
			}
			finalArray.put(snoozedArr);
			finalArray.put(alreadySnoozedArr);
			finalArray.put(errorList);
			finalArray.put(updatedRemarksArr);
			finalArray.put(oldRemarksArr);

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, null);
		}
		return finalArray;
	}
	
	
	public JSONArray getCriteriaDetails(int systemId, int clientId) {
		JSONObject obj = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		JSONArray jArr = new JSONArray();
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(CTDashboardStatements.GET_CRITERIA_DETAILS);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, clientId);
			rs = pstmt.executeQuery();
			obj = new JSONObject();
			while (rs.next()) {
				obj = new JSONObject();
				obj.put("criteriaName", rs.getString("NAME"));
				obj.put("customerName", rs.getString("CUSTOMER_NAME"));
				obj.put("customerType", rs.getString("CUSTOMER_TYPE"));
				obj.put("vehicleType", rs.getString("VEHICLE_TYPE"));
				obj.put("vehicleCategory", rs.getString("VEHICLE_CATEGORY"));
				obj.put("editBtn", "<div class='fas fa-pencil-alt' style='color: #3F51B5;margin-left: 78px;font-size: 2em;cursor:pointer;white-space: nowrap;allign:center;' "
						+ " onclick=modifyCriteria(" + rs.getInt("ID") + ")> </div>");
				jArr.put(obj);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jArr;
	}
	
	public String saveCriteria(int systemId, int customerId, int userId, String tripCustIds, String custType, String vehType, String vehicleCategory,
			String criteriaName, String buttonValue, String criteriaId) {
		Connection con = null;
		PreparedStatement pstmt = null,pstmtCheck = null;
		PreparedStatement pstmtDelete = null;
		PreparedStatement pstmt1 = null;
		ResultSet rs = null;
		String selectedUserList="";
		try {
			con = DBConnection.getConnectionToDB("AMS");
			String tripCustArr = "";
			String custTypeArr = "";
			String vehTypeArr = "";
			String vehCategoryArr = "";
			if (tripCustIds!= null && !tripCustIds.equals("") ) {
				tripCustArr = tripCustIds.substring(0, tripCustIds.length() - 1);
			}
			if (custType != null && !custType.equals("")) {
				custTypeArr = custType.substring(0, custType.length() - 1);
			}
			if (vehType != null && !vehType.equals("")) {
				vehTypeArr = vehType.substring(0, vehType.length() - 1);
			}
			if (vehicleCategory != null && !vehicleCategory.equals("")) {
				vehCategoryArr = vehicleCategory.substring(0, vehicleCategory.length() - 1);
			}
			if (buttonValue.contains("Freeze Criteria")) {
				pstmtCheck = con.prepareStatement(CTDashboardStatements.GET_CRITERIA.concat(" and NAME = '"+criteriaName+"'"));
				pstmtCheck.setInt(1, systemId);
				pstmtCheck.setInt(2, customerId);
				rs = pstmtCheck.executeQuery();
				if (!rs.next()) {
					pstmt = con.prepareStatement(CTDashboardStatements.SAVE_CRITERIA);
					pstmt.setString(1, criteriaName);
					pstmt.setString(2, tripCustArr);
					pstmt.setString(3, custTypeArr);
					pstmt.setString(4, vehTypeArr);
					pstmt.setString(5, vehCategoryArr);
					pstmt.setInt(6, systemId);
					pstmt.setInt(7, customerId);
					pstmt.executeUpdate();
					return "Criteria details saved successfully";
				} else {
					return "Criteria name already exists";
				}
				
			} else if (buttonValue.contains("Modify Criteria")) {
				pstmt = con.prepareStatement(CTDashboardStatements.MODIFY_CRITERIA);
				pstmt.setString(1, tripCustArr);
				pstmt.setString(2, custTypeArr);
				pstmt.setString(3, vehTypeArr);
				pstmt.setString(4, vehCategoryArr);
				pstmt.setString(5, criteriaId);
				pstmt.executeUpdate();
				
				pstmt1 = con.prepareStatement(CTDashboardStatements.GET_USERS_FOR_A_CRITERIA);
				pstmt1.setString(1, criteriaId);
				rs = pstmt1.executeQuery();
				while (rs.next()) {
					selectedUserList = rs.getInt("USER_ID") + "," + selectedUserList;
				}
				if(selectedUserList.length() > 1) {
					selectedUserList = selectedUserList.substring(0, selectedUserList.length() - 1);
					
					pstmtDelete = con.prepareStatement(CTDashboardStatements.DELETE_ASSOCIATION_FOR_CRITERIA);
					pstmtDelete.setString(1, criteriaId);
					pstmtDelete.executeUpdate();
					
					associateCriteria(systemId, customerId, userId, selectedUserList, criteriaId, con);
				}
				return "Criteria details modified successfully";
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
			DBConnection.releaseConnectionToDB(null, pstmtDelete, null);
			DBConnection.releaseConnectionToDB(null, pstmt1, null);
		}
		return errorMessage;
	}
	
	public void associateCriteria(int systemId, int customerId, int userId, String selectedUserList, String criteriaId, Connection con) {
		PreparedStatement pstmtSave = null;
		try {
			JSONArray regNoList = getRegNoListBasedOnCriteria(systemId, customerId, userId, criteriaId, con);
			if (regNoList.length() > 0) {
				String[] userList = selectedUserList.split(","); 
				for (String user : userList) {
					//saveUserCriteriaDetails(criteriaId, user, con, systemId, customerId);
					pstmtSave = con.prepareStatement(CTDashboardStatements.SAVE_USER_VEHICLE_ASSOCIATION);
					for (int i = 0; i < regNoList.length(); i++) {
						try {
							String regNo  = regNoList.getJSONObject(i).getString("vehicleNo");
							String tripId  = regNoList.getJSONObject(i).getString("tripId");
							boolean recordExists = checkRecordExists(con,user,regNo);
							if (!recordExists) {
								pstmtSave.setInt(1, Integer.parseInt(user));
								pstmtSave.setString(2, regNo);
								pstmtSave.setInt(3, systemId);
								pstmtSave.setInt(4, customerId);
								pstmtSave.setString(5, criteriaId);
								pstmtSave.setString(6, tripId);
								pstmtSave.addBatch();
							}
						} catch (Exception e) {
							e.getMessage();
						}
					}
					pstmtSave.executeBatch();
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(null, pstmtSave, null);
		}
	}

	public String associateCriteriaToUser(int systemId, int customerId, int userId, String selectedUserList, String criteriaId) {
		Connection con = null;
		PreparedStatement pstmtSave = null, pstmtDelete = null;
		String message = "";
		try {
			con = DBConnection.getConnectionToDB("AMS");
			
			JSONArray regNoList = getRegNoListBasedOnCriteria(systemId, customerId, userId, criteriaId, con);
			if (regNoList.length() > 0) {
				String[] userList = selectedUserList.split(","); 
				for (String user : userList) {
					saveUserCriteriaDetails(criteriaId, user, con, systemId, customerId);
					
					pstmtDelete = con.prepareStatement(CTDashboardStatements.DISASSOCIATE_CRITERIA);
					pstmtDelete.setInt(1, Integer.parseInt(user));
					//pstmtDelete.setString(2, criteriaId);
					pstmtDelete.executeUpdate();
					
					pstmtSave = con.prepareStatement(CTDashboardStatements.SAVE_USER_VEHICLE_ASSOCIATION);
					for (int i = 0; i < regNoList.length(); i++) {
						try {
							String regNo  = regNoList.getJSONObject(i).getString("vehicleNo");
							String tripId  = regNoList.getJSONObject(i).getString("tripId");
							pstmtSave.setInt(1, Integer.parseInt(user));
							pstmtSave.setString(2, regNo);
							pstmtSave.setInt(3, systemId);
							pstmtSave.setInt(4, customerId);
							pstmtSave.setString(5, criteriaId);
							pstmtSave.setString(6, tripId);
							pstmtSave.addBatch();
						} catch (Exception e) {
							e.getMessage();
						}
					}
					int[] updated = pstmtSave.executeBatch();
					if (updated.length > 0) {
						message = updated.length + " vehicles are associated to the user";
					}
				}
			} else {
				message = "No vehicles found for this criteria";
			}
			return message;
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmtSave, null);
			DBConnection.releaseConnectionToDB(null, pstmtDelete, null);
		}
		return errorMessage;
	}

	private void saveUserCriteriaDetails(String criteriaId, String userId, Connection con, int systemId, int customerId) {
		PreparedStatement pstmtSave = null,pstmtDelete = null;
		
		try {
			pstmtDelete = con.prepareStatement(CTDashboardStatements.DELETE_USER_CRITERIA_DETAILS);
			pstmtDelete.setString(1, userId);
			//pstmtDelete.setString(2, criteriaId);
			pstmtDelete.executeUpdate();
			
			pstmtSave = con.prepareStatement(CTDashboardStatements.SAVE_USER_CRITERIA_DETAILS);
			pstmtSave.setString(1, userId);
			pstmtSave.setString(2, criteriaId);
			pstmtSave.setInt(3, systemId);
			pstmtSave.setInt(4, customerId);
			pstmtSave.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(null, pstmtDelete, null);
			DBConnection.releaseConnectionToDB(null, pstmtSave, null);
		}
		
	}

	private boolean checkRecordExists(Connection con, String user, String regNo) throws SQLException {
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		pstmt = con.prepareStatement(CTDashboardStatements.CHECK_RECORD_EXISTS);
		pstmt.setString(1, user);
		pstmt.setString(2, regNo);
		rs = pstmt.executeQuery();
		if(rs.next()){
			return true;
		}
		return false;
	}

	private JSONArray getRegNoListBasedOnCriteria(int systemId, int customerId, int userId, String criteriaId, Connection con) {
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		JSONArray regNoList = new JSONArray();
		try {
			pstmt = con.prepareStatement(CTDashboardStatements.GET_CRITERIA_DETAILS_TO_ASSOCIATE);
			pstmt.setString(1, criteriaId);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				regNoList = getRegistrationNo(systemId, customerId, userId, rs.getString("TRIP_CUSTOMER_ID"), 
						rs.getString("CUSTOMER_TYPE"), rs.getString("VEHICLE_TYPE"), rs.getString("VEHICLE_CATEGORY"));
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(null, pstmt, rs);
		}
		return regNoList;
	}
	public JSONArray getCriteria(int systemId, int clientId) {
		JSONArray jArr = new JSONArray();
		JSONObject obj = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			if (con == null) {
				con = DBConnection.getConnectionToDB("AMS");
			}
			pstmt = con.prepareStatement(CTDashboardStatements.GET_CRITERIA);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, clientId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				obj = new JSONObject();
				obj.put("criteriaName", rs.getString("NAME"));
				obj.put("criteriaId", rs.getString("ID"));
				jArr.put(obj);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jArr;
	}
	
	public JSONArray getCriteriaForEdit(int systemId, int clientId, String criteriaId) {
		JSONArray jArr = new JSONArray();
		JSONObject obj = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			if (con == null) {
				con = DBConnection.getConnectionToDB("AMS");
			}
			pstmt = con.prepareStatement(CTDashboardStatements.GET_CRITERIA.concat(" and ID=?"));
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, clientId);
			pstmt.setString(3, criteriaId);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				obj = new JSONObject();
				obj.put("criteriaName", rs.getString("NAME"));
				obj.put("criteriaId", rs.getString("ID"));
				obj.put("tripCustId", rs.getString("TRIP_CUSTOMER_ID"));
				obj.put("custType", rs.getString("CUSTOMER_TYPE"));
				obj.put("vehicleType", rs.getString("VEHICLE_TYPE"));
				obj.put("vehicleCategory", rs.getString("VEHICLE_CATEGORY"));
				jArr.put(obj);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jArr;
	}
	
	public JSONArray uploadPinCodeOriginDestinationFromList(List<PinCodeOriginDestinationModel> pinCodeOriginDestinationList) {
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Connection con = null;
		PreparedStatement pstmtForOriginDestination = null;
		JSONArray finalArray = new JSONArray();
		JSONArray newCityArr = new JSONArray();
		JSONObject pinCodeObj = new JSONObject();
		JSONArray errorList = new JSONArray();
		try {
			if (con == null) {
				con = DBConnection.getConnectionToDB("AMS");
			}
			List<Integer> existingPinCodes = new ArrayList<Integer>();
			pstmt = con.prepareStatement(CTDashboardStatements.CHECK_DUPLICATE_EXISTS);
			rs = pstmt.executeQuery();

			while (rs.next()) {
				existingPinCodes.add(Integer.parseInt(rs.getString("PIN_CODE")));
			}
			for (PinCodeOriginDestinationModel pinCodeOriginDestinationModel : pinCodeOriginDestinationList) {
				if(pinCodeOriginDestinationModel.getName().toUpperCase().equals("")){
					errorList.put("City name not entered.");
					continue;
				}
				String userEntrdRegion = pinCodeOriginDestinationModel.getName().toUpperCase();
				pstmtForOriginDestination = con.prepareStatement(CTDashboardStatements.GET_REGION_DETAILS);
				pstmtForOriginDestination.setString(1, userEntrdRegion);
				rs = pstmtForOriginDestination.executeQuery();
				if (rs.next()) {
					if (existingPinCodes.contains(pinCodeOriginDestinationModel.getPinCode())) {
						errorList.put(pinCodeOriginDestinationModel.getPinCode());
					} else {
						pinCodeOriginDestinationModel.setOriginDestinationId(rs.getInt("ID"));
						insertPincodeDetails(con, pinCodeOriginDestinationModel);
					}
				} else {
					if (existingPinCodes.contains(pinCodeOriginDestinationModel.getPinCode())) {
						errorList.put(pinCodeOriginDestinationModel.getPinCode());
						continue;
					}
					pinCodeObj = new JSONObject();
					pinCodeObj.put("name", pinCodeOriginDestinationModel.getName().toUpperCase());
					pinCodeObj.put("pinCode", pinCodeOriginDestinationModel.getPinCode());
					newCityArr.put(pinCodeObj);
				}

			}
			finalArray.put(newCityArr);
			finalArray.put(errorList);

		} catch (Exception e) {
			e.printStackTrace();
			errorList.put(errorMessage);
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmtForOriginDestination, rs);
			DBConnection.releaseConnectionToDB(null, pstmt, null);
		}
		return finalArray;
	}

	private PreparedStatement insertPincodeDetails(Connection con, PinCodeOriginDestinationModel pinCodeOriginDestinationModel) throws SQLException {
		PreparedStatement pstmt;

		pstmt = con.prepareStatement(CTDashboardStatements.INSERT_PINCODE_REGION_DETAILS);
		pstmt.setInt(1, pinCodeOriginDestinationModel.getPinCode());
		pstmt.setInt(2, pinCodeOriginDestinationModel.getOriginDestinationId());
		pstmt.setString(3, pinCodeOriginDestinationModel.getName().toUpperCase());
		pstmt.executeUpdate();
		return pstmt;
	}

	public String saveNewCityDetails(String cityList) {
		PreparedStatement pstmt = null;
		Connection con = null;
		ResultSet rs = null;
		int autoGeneratedKey = 0;
		try {
			if (con == null) {
				con = DBConnection.getConnectionToDB("AMS");
			}
			JSONArray cityArr = new JSONArray(cityList);
			for (int i = 0; i < cityArr.length(); i++) {
				PinCodeOriginDestinationModel pinCodeOriginDestinationModel = new PinCodeOriginDestinationModel();
				JSONObject jobj = cityArr.getJSONObject(i);
				pinCodeOriginDestinationModel.setName(jobj.getString("name"));
				pinCodeOriginDestinationModel.setPinCode(Integer.parseInt(jobj.getString("pinCode")));

				pstmt = con.prepareStatement(CTDashboardStatements.INSERT_REGION_DETAILS, Statement.RETURN_GENERATED_KEYS);
				pstmt.setString(1, jobj.getString("name"));
				pstmt.executeUpdate();
				rs = pstmt.getGeneratedKeys();
				if (rs.next()) {
					autoGeneratedKey = rs.getInt(1);
					pinCodeOriginDestinationModel.setOriginDestinationId(autoGeneratedKey);
				}
				insertPincodeDetails(con, pinCodeOriginDestinationModel);
			}
			return "New City Details Saved Successfuly";
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return errorMessage;
	}

}
