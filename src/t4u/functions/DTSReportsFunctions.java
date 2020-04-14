package t4u.functions;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;

import org.json.JSONArray;
import org.json.JSONObject;

import t4u.common.DBConnection;
import t4u.statements.DTSReportsStatements;

public class DTSReportsFunctions {
	SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
	DecimalFormat df = new DecimalFormat("00.00");
	CommonFunctions cf = new CommonFunctions();

	public ArrayList<Object> getPendingDeliveriesReport(String startDate,
			String endDate, String tripCust, int offset, String distUnits,
			String orderNo,int systemId, int clientId) {
		
		//Report changed to only for Not Delivered
		JSONArray JsonArray = new JSONArray();
		JSONObject JsonObject = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		ArrayList<Object> finlist = new ArrayList<Object>();
		double distance = 0;
		String cond = "";
		String cond1 = "";
		String cond2 = "";
		try {
			int count = 0;
			con = DBConnection.getConnectionToDB("AMS");
			cond = " and DELIVERY_STATUS='NOT_DELIVERED' ";
			if(orderNo.equals("0")){
				cond1="";
			}else{
				cond1="and tod.ORDER_NO='"+orderNo+"'";
			}
			if(tripCust.equals("0")){
				cond2="";
			}else{
				cond2="and tod.TRIP_CUSTOMER_ID="+tripCust;
			}
			
			pstmt = con.prepareStatement(DTSReportsStatements.GET_DELIVERY_REPORT_DATA.replace("#", cond).replace("$", cond1).replace("%", cond2));
			pstmt.setInt(1, offset);
			pstmt.setInt(2, offset);
			pstmt.setInt(3, offset);
			pstmt.setInt(4, systemId);
			pstmt.setInt(5, clientId);
			pstmt.setInt(6, offset);
			pstmt.setString(7, startDate);
			pstmt.setInt(8, offset);
			pstmt.setString(9, endDate);
			rs = pstmt.executeQuery();
			while (rs.next()) {

				JsonObject = new JSONObject();
				count++;

				String deliveredTime = "";
				if (!rs.getString("DELIVERED_TIME").contains("1900")) {
					deliveredTime = sdf.format(rs.getTimestamp("DELIVERED_TIME"));
				}

				String dispatchTime = "";
				if (!rs.getString("DISPATCH_TIME").contains("1900")) {
					dispatchTime = sdf.format(rs.getTimestamp("DISPATCH_TIME"));
				}

				JsonObject.put("slnoIndex", count);
				
				JsonObject.put("orderNoIndex", rs.getString("ORDER_NO"));

				JsonObject.put("dtNoIndex", rs.getInt("DELIVERY_TICKET"));

				JsonObject.put("dnNoIndex", rs.getString("DELIVERY_NOTE"));

				JsonObject.put("driverNameIndex", rs.getString("DRIVER_NAME"));

				JsonObject.put("driverContactIndex", rs.getString("DRIVER_NUMBER"));

				JsonObject.put("loadingPartnerIndex", rs.getString("LOADING_PARTNER"));
				
				JsonObject.put("customerNameIndex", rs.getString("TRIP_CUSTOMER_NAME"));

				JsonObject.put("dispatchTime",dispatchTime);

				JsonObject.put("deliveredTime", deliveredTime);
				
				JsonObject.put("remarks", rs.getString("REMARKS"));

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
	
	
	public ArrayList<Object> getDriverEfficiencyReport(String startDate,
			String endDate, int offset, String distUnits,
			String vehicleNo,int systemId, int clientId, int userId) {
		JSONArray JsonArray = new JSONArray();
		JSONObject JsonObject = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		ArrayList<Object> finlist = new ArrayList<Object>();
		String cond = "";
		try {
			int count = 0;
			con = DBConnection.getConnectionToDB("AMS");
			if (vehicleNo.equals("0")) {
				cond = "";
			}else{
				cond = " and DRIVER_ID = '"+vehicleNo+"'  ";
			} 
			pstmt = con.prepareStatement(DTSReportsStatements.GET_DRIVER_EFFICIENCY_REPORT.replace("#", cond));
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, clientId);
			pstmt.setInt(3, offset);
			pstmt.setString(4, startDate);
			pstmt.setInt(5, offset);
			pstmt.setString(6, endDate);

			rs = pstmt.executeQuery();
			while (rs.next()) {

				JsonObject = new JSONObject();
				count++;

				JsonObject.put("slnoIndex", count);

				JsonObject.put("driverNameIndex",(rs.getString("DRIVER_NAME") == null)?"":rs.getString("DRIVER_NAME"));

				JsonObject.put("noOfTripsIndex", rs.getInt("NO_OF_TRIPS"));

				JsonObject.put("totalTimeIndex", cf.convertMinutesToHHMMFormat(rs.getInt("DURATION")));

				String avgTime=cf.convertMinutesToHHMMFormat(rs.getInt("DURATION")/rs.getInt("NO_OF_TRIPS"));
				
				JsonObject.put("avgTimeIndex",avgTime );

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
	
	public ArrayList<Object> getOrderDetailReport(String startDate,
		String endDate, String status, String tripCust, int offset, String distUnits,
		String orderNo,int systemId, int clientId) {
	JSONArray JsonArray = new JSONArray();
	JSONObject JsonObject = null;
	Connection con = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	ArrayList<Object> finlist = new ArrayList<Object>();
	double distance = 0;
	String cond = "";
	String cond1 = "";
	String cond2 = "";
	try {
		int count = 0;
		con = DBConnection.getConnectionToDB("AMS");
		if (status.equals("0")) {
			cond = "";
		} else if (status.equals("1")) {
			cond = "  and  tod.ACKNOWLEDGE_ORDER is null and ttd.STATUS = 'CLOSED'"; // DELIVERY_STATUS='PENDING' and
		} else if (status.equals("2")) {
			cond = "  and DELIVERY_STATUS='DELIVERED' ";
		} else if (status.equals("3")) {
			cond = " and DELIVERY_STATUS='NOT_DELIVERED' ";
		}
		if(orderNo.equals("0")){
			cond1="";
		}else{
			cond1="and tod.ORDER_NO='"+orderNo+"'";
		}
		if(tripCust.equals("0")){
			cond2="";
		}else{
			cond2="and tod.TRIP_CUSTOMER_ID="+tripCust;
		}
		
		pstmt = con.prepareStatement(DTSReportsStatements.GET_DELIVERY_REPORT_DATA.replace("#", cond).replace("$", cond1).replace("%", cond2));
		pstmt.setInt(1, offset);
		pstmt.setInt(2, offset);
		pstmt.setInt(3, offset);
		pstmt.setInt(4, systemId);
		pstmt.setInt(5, clientId);
		pstmt.setInt(6, offset);
		pstmt.setString(7, startDate);
		pstmt.setInt(8, offset);
		pstmt.setString(9, endDate);
		rs = pstmt.executeQuery();
		while (rs.next()) {

			JsonObject = new JSONObject();
			count++;

			String deliveredTime = "";
			if (!rs.getString("DELIVERED_TIME").contains("1900")) {
				deliveredTime = sdf.format(rs.getTimestamp("DELIVERED_TIME"));
			}
			String dispatchTime = "";
			if (!rs.getString("DISPATCH_TIME").contains("1900")) {
				dispatchTime = sdf.format(rs.getTimestamp("DISPATCH_TIME"));
			}
			String ackDate = "";
			if (!rs.getString("ACK_DATE").contains("1900")) {
				ackDate = sdf.format(rs.getTimestamp("ACK_DATE"));
			}

			JsonObject.put("slnoIndex", count);
			
			JsonObject.put("orderNoIndex", rs.getString("ORDER_NO"));

			JsonObject.put("dtNoIndex", rs.getString("DELIVERY_TICKET"));

			JsonObject.put("dnNoIndex", rs.getString("DELIVERY_NOTE"));

			JsonObject.put("driverNameIndex", rs.getString("DRIVER_NAME"));

			JsonObject.put("driverContactIndex", rs.getString("DRIVER_NUMBER"));
			if(rs.getString("ORDER_TYPE") != null && rs.getString("ORDER_TYPE").equals("COLLECTIONS")){
				JsonObject.put("loadingPartnerIndex", rs.getString("CUST_COLL_LOADING_PARTNER"));
			}else{
				JsonObject.put("loadingPartnerIndex", rs.getString("LOADING_PARTNER"));
			}
			JsonObject.put("customerNameIndex", rs.getString("TRIP_CUSTOMER_NAME"));

			JsonObject.put("dispatchTime",dispatchTime);

			JsonObject.put("deliveredTime", deliveredTime);
			
			JsonObject.put("ackDateTime", ackDate);
			
			JsonObject.put("remarks", rs.getString("REMARKS"));
			JsonObject.put("orderType", rs.getString("ORDER_TYPE"));
			JsonObject.put("collectedBy", rs.getString("COLLECTED_BY"));
			JsonObject.put("mobileNumber", rs.getString("MOBILE_NUMBER"));
			JsonObject.put("vehicleNumber", rs.getString("VEHICLE_NUMBER"));
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
	
	public JSONArray getOrderNo(int systemId, int clientId,String startDate,String endDate) {
		JSONArray JsonArray = new JSONArray();
		JSONObject JsonObject = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(DTSReportsStatements.GET_ALL_ORDER_NO);
			pstmt.setString(1, startDate);
			pstmt.setString(2, endDate);
			pstmt.setInt(3, systemId);
			pstmt.setInt(4, clientId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				JsonObject = new JSONObject();
				JsonObject.put("orderNo", rs.getString("ORDER_NO"));
				JsonArray.put(JsonObject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return JsonArray;
	}
	
	public JSONArray getDriverNames(int systemId, int clientId,int userId) {
		JSONArray JsonArray = new JSONArray();
		JSONObject JsonObject = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(DTSReportsStatements.GET_DRIVER_NAMES);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, clientId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				JsonObject = new JSONObject();
				JsonObject.put("driverId", rs.getString("Driver_id"));
				JsonObject.put("driverName", rs.getString("DRIVER_NAME"));
				JsonArray.put(JsonObject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return JsonArray;
	}
}