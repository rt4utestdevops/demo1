package t4u.functions;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.text.SimpleDateFormat;

import org.json.JSONArray;
import org.json.JSONObject;

import t4u.common.DBConnection;
import t4u.statements.GeneralVerticalStatements;

public class SensorHealthDashboardFunction {

	final String getTotalAlertDeatails = "select 1 as slNo,dateadd(mi,330,ALERT_DATETIME) as alertDateTime,isnull(SHIPMENT_ID,'') as tripNo,isnull(td.PRODUCT_LINE,'') as tripType,a.REGISTRATION_NO as vehicleNo,isnull(vm.ModelName,'') as make,dateadd(mi,330,ALERT_DATETIME) as lastCommunication,\r\n"
		+ " CONVERT(varchar, CAST(ALERT_VALUE * 60 AS int) / 3600) + RIGHT(CONVERT(varchar, DATEADD(s, ALERT_VALUE * 60, 0), 108), 6) as ageing,isnull(a.REMARKS,'') as remarks,isnull(ACKNOWLEDGE_DATE,'') as updatedDate,isnull(u.USER_NAME,'') as updatedBy,a.ALERT_ID as alertId,a.ID as uniqueId "
		+ " from AMS.dbo.SENSOR_HEALTH_ALERT_DETAILS a "
		+ " left outer join AMS.dbo.TRACK_TRIP_DETAILS td on td.TRIP_ID=a.TRIP_ID "
		+ " left outer join AMS.dbo.tblVehicleMaster c on a.REGISTRATION_NO=c.VehicleNo "
		+ " left outer join ADMINISTRATOR.dbo.USERS u on u.SYSTEM_ID=a.SYSTEM_ID and u.USER_ID=a.ACKNOWLEDGE_BY  "
		+ " left outer join FMS.[dbo].[Vehicle_Model] vm on vm.SystemId=c.System_id and vm.ModelTypeId=c.Model "
		+ " where a.SYSTEM_ID=? and a.CUSTOMER_ID=? and a.ALERT_ID=? ## order by ALERT_DATETIME desc ";
	
	final String getTotalAlertDeatails_Temperature_Alert = "select * from (select  ROW_NUMBER() OVER (PARTITION BY a.REGISTRATION_NO ORDER BY a.ALERT_DATETIME DESC) AS RowNum,1 as slNo, "
		+ "	dateadd(mi,330,ALERT_DATETIME) as alertDateTime,isnull(SHIPMENT_ID,'') as tripNo, "
		+ "	isnull(td.PRODUCT_LINE,'') as tripType,a.REGISTRATION_NO as vehicleNo,isnull(vm.ModelName,'') as make, "
		+ "	dateadd(mi,330,ALERT_DATETIME) as lastCommunication, "
		+ "	CONVERT(varchar, CAST(ALERT_VALUE * 60 AS int) / 3600) +"
		+ "	RIGHT(CONVERT(varchar, DATEADD(s, ALERT_VALUE * 60, 0), 108), 6) as ageing, "
		+ "	isnull(a.REMARKS,'') as remarks,isnull(ACKNOWLEDGE_DATE,'') as updatedDate,isnull(u.USER_NAME,'') as updatedBy,"
		+ "	a.ALERT_ID as alertId,a.ID as uniqueId "
		+ "	from AMS.dbo.SENSOR_HEALTH_ALERT_DETAILS a "
		+ "	left outer join AMS.dbo.TRACK_TRIP_DETAILS td on td.TRIP_ID=a.TRIP_ID "
		+ "	left outer join AMS.dbo.tblVehicleMaster c on a.REGISTRATION_NO=c.VehicleNo "
		+ "	left outer join ADMINISTRATOR.dbo.USERS u on u.SYSTEM_ID=a.SYSTEM_ID and u.USER_ID=a.ACKNOWLEDGE_BY "
		+ "	left outer join FMS.[dbo].[Vehicle_Model] vm on vm.SystemId=c.System_id and vm.ModelTypeId=c.Model "
		+ "	where a.SYSTEM_ID=? and a.CUSTOMER_ID=? and a.ALERT_ID=? ## ) r "
		+ "	where r.RowNum=1 order by r.alertDateTime desc ";


	final String getAlertDeatails = getTotalAlertDeatails.replace("##", " and a.TRIP_TYPE=? ");
	
	final String getTempAlertDeatails = getTotalAlertDeatails_Temperature_Alert.replace("##", " and a.TRIP_TYPE=? ");
	
	private final String getAlertHistoryDeatails = "select 1 as slNo,dateadd(mi,?,ALERT_DATETIME) as alertDateTime,isnull(SHIPMENT_ID,'') as tripNo,isnull(td.PRODUCT_LINE,'') as tripType,a.REGISTRATION_NO as vehicleNo,isnull(vm.ModelName,'') as make,dateadd(mi,?,ALERT_DATETIME) as lastCommunication, "
			+ " CONVERT(varchar, CAST(ALERT_VALUE * 60 AS int) / 3600) + RIGHT(CONVERT(varchar, DATEADD(s, ALERT_VALUE * 60, 0), 108), 6) as ageing,isnull(a.REMARKS,'') as remarks,isnull(ACKNOWLEDGE_DATE,'') as updatedDate,isnull(u.USER_NAME,'') as updatedBy,a.ALERT_ID as alertId,a.ID as uniqueId "			
			+ " from AMS.dbo.SENSOR_HEALTH_ALERT_HISTORY a "
			+ " left outer join AMS.dbo.TRACK_TRIP_DETAILS td on td.TRIP_ID=a.TRIP_ID "
			+ " left outer join AMS.dbo.tblVehicleMaster c on a.REGISTRATION_NO=c.VehicleNo "
			+ " left outer join ADMINISTRATOR.dbo.USERS u on u.SYSTEM_ID=a.SYSTEM_ID and u.USER_ID=a.ACKNOWLEDGE_BY  "
			+ " left outer join FMS.[dbo].[Vehicle_Model] vm on vm.SystemId=c.System_id and vm.ModelTypeId=c.Model "
			+ " where a.SYSTEM_ID=? and a.CUSTOMER_ID=? and ALERT_DATETIME between dateadd(mi,-?,?) and dateadd(mi,-?,?) order by ALERT_DATETIME desc";

	private final String getAlertCount = " select * from AMS.dbo.SENSOR_HEALTH_ALERT_COUNT where SYSTEM_ID=? and CUSTOMER_ID=? ";
	public JSONArray getDashboardCounts(int systemId, int clientId, int offset) {
		JSONArray jsonArray = new JSONArray();
		JSONObject obj = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(getAlertCount);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, clientId);
			rs = pstmt.executeQuery();
			obj = new JSONObject();
			while (rs.next()) {	
				switch (rs.getInt("ALERT_ID")) {
				case 1:
					
					obj.put("gpsTotalDryCount", rs.getInt("TOTAL_DRY_COUNT"));
					obj.put("gpsTotalTclCount", rs.getInt("TOTAL_TCL_COUNT"));
					obj.put("gpsWorkingDryCount", rs.getInt("WORKING_DRY_COUNT"));
					obj.put("gpsWorkingTclCount", rs.getInt("WORKING_TCL_COUNT"));
					obj.put("gpsNotWorkingDryCount", rs.getInt("NOT_WORKING_DRY_COUNT"));
					obj.put("gpsNotWorkingTclCount", rs.getInt("NOT_WORKING_TCL_COUNT"));
					break;
					
				case 2:
					obj.put("doorTotalDryCount", rs.getInt("TOTAL_DRY_COUNT"));
					obj.put("doorTotalTclCount", rs.getInt("TOTAL_TCL_COUNT"));
					obj.put("doorWorkingDryCount", rs.getInt("WORKING_DRY_COUNT"));
					obj.put("doorWorkingTclCount", rs.getInt("WORKING_TCL_COUNT"));
					obj.put("doorNotWorkingDryCount", rs.getInt("NOT_WORKING_DRY_COUNT"));
					obj.put("doorNotWorkingTclCount", rs.getInt("NOT_WORKING_TCL_COUNT"));
					break;
					
				case 3:
					obj.put("obdtotalDryCount", rs.getInt("TOTAL_DRY_COUNT"));
					obj.put("obdtotalTclCount", rs.getInt("TOTAL_TCL_COUNT"));
					obj.put("obdworkingDryCount", rs.getInt("WORKING_DRY_COUNT"));
					obj.put("obdworkingTclCount", rs.getInt("WORKING_TCL_COUNT"));
					obj.put("obdnotWorkingDryCount", rs.getInt("NOT_WORKING_DRY_COUNT"));
					obj.put("obdnotWorkingTclCount", rs.getInt("NOT_WORKING_TCL_COUNT"));
					break;
				case 4:
					obj.put("reeferTotalCount", rs.getInt("TOTAL_REEFER_COUNT"));
					obj.put("middleTotalCount", rs.getInt("TOTAL_MIDDLE_COUNT"));
					obj.put("doorTotalCount", rs.getInt("TOTAL_DOOR_COUNT"));
					obj.put("reeferNotWorkingCount", rs.getInt("NOT_WORKING_REEFER_COUNT"));
					obj.put("middleNotWorkingCount", rs.getInt("NOT_WORKING_MIDDLE_COUNT"));
					obj.put("doorNotWorkingCount", rs.getInt("NOT_WORKING_DOOR_COUNT"));
					obj.put("reeferWorkingCount", rs.getInt("TOTAL_REEFER_COUNT") - rs.getInt("NOT_WORKING_REEFER_COUNT"));
					obj.put("middleWorkingCount", rs.getInt("TOTAL_MIDDLE_COUNT") - rs.getInt("NOT_WORKING_MIDDLE_COUNT"));
					obj.put("doorWorkingCount", rs.getInt("TOTAL_DOOR_COUNT") - rs.getInt("NOT_WORKING_DOOR_COUNT"));
					break;
					
				default:
					break;
				}
			}
			jsonArray.put(obj);
		} catch (Exception e) {
			e.printStackTrace();
		}finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jsonArray;
	}
	public String updateAcknowledgement(int systemId, int clientId, String remarks, int uniqueId, int userId) {
		Connection con=null;
		PreparedStatement pstmt=null;
		String message="";
		try {
		con = DBConnection.getConnectionToDB("AMS");
		pstmt = con.prepareStatement(" update AMS.dbo.SENSOR_HEALTH_ALERT_DETAILS set REMARKS=?,ACKNOWLEDGE_BY=?,ACKNOWLEDGE_DATE=getdate() where ID=? ");
		pstmt.setString(1, remarks);
		pstmt.setInt(2, userId);
		pstmt.setInt(3, uniqueId);
		
		int updated=pstmt.executeUpdate();
		if (updated > 0) {
	        message = "Acknowledge Saved";
	    }else{
	    	 message = "Error.";
	    }
		 }catch (Exception e) {
			 e.printStackTrace();
		 } finally {
			 DBConnection.releaseConnectionToDB(con, pstmt, null);
		 }
		return message;
	}
	public JSONArray getHistoryDataDetails(int systemId, int clientId, String startDate, String endDate,int offset) {
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonobject = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		SimpleDateFormat sdf1 = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
		int count=0;
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(getAlertHistoryDeatails);
			pstmt.setInt(1, offset);
			pstmt.setInt(2, offset);
			pstmt.setInt(3, systemId);
			pstmt.setInt(4, clientId);
			pstmt.setInt(5, offset);
			pstmt.setString(6, startDate);
			pstmt.setInt(7, offset);
			pstmt.setString(8, endDate+" 23:59:59");
			rs = pstmt.executeQuery();
			while(rs.next()){
				count++;
				jsonobject = new JSONObject();
				jsonobject.put("alertDatetime",sdf1.format(rs.getTimestamp("alertDatetime")));
				jsonobject.put("tripNo",rs.getString("tripNo"));
				jsonobject.put("tripType",rs.getString("tripType"));
				jsonobject.put("vehicleNo",rs.getString("vehicleNo"));
				jsonobject.put("make",rs.getString("make"));
				jsonobject.put("lastCommunication",sdf1.format(rs.getTimestamp("lastCommunication")));
				jsonobject.put("ageing",rs.getString("ageing"));
				jsonobject.put("remarks",rs.getString("remarks"));
				if(rs.getString("updatedDate").contains("1900")){
					jsonobject.put("updatedDate","");
				} else {
					jsonobject.put("updatedDate",sdf1.format(rs.getTimestamp("updatedDate")));
				}
				if(rs.getString("updatedBy")!=null) {
					jsonobject.put("updatedBy",rs.getString("updatedBy"));
				} else {
					jsonobject.put("updatedBy","");
				}
				jsonobject.put("uniqueId",rs.getInt("uniqueId"));
				jsonobject.put("alertId",rs.getInt("alertId"));
				jsonArray.put(jsonobject);
			}
		
	} catch (Exception e) {
		e.printStackTrace();
	}finally {
		DBConnection.releaseConnectionToDB(con, pstmt, rs);
	}
	return jsonArray;

	}
	public JSONArray getDashboardDetails(int systemId, int clientId, String alertId, String type,int offset) {
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonobject = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		SimpleDateFormat sdf1 = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
		int count=0;
		String statement = "";
		try {
			con = DBConnection.getConnectionToDB("AMS");
			if (type.equalsIgnoreCase("total")) {
				statement = alertId.equalsIgnoreCase("4")? getTotalAlertDeatails_Temperature_Alert : getTotalAlertDeatails;
				pstmt = con.prepareStatement(statement.replace("##", "").replaceAll("330",""+offset));  
				pstmt.setInt(1, systemId);
				pstmt.setInt(2, clientId);
				pstmt.setString(3, alertId);
			} else {
				statement = alertId.equalsIgnoreCase("4")? getTempAlertDeatails : getAlertDeatails;
				pstmt = con.prepareStatement(statement.replaceAll("330",""+offset));
				pstmt.setInt(1, systemId);
				pstmt.setInt(2, clientId);
				pstmt.setString(3, alertId);
    			pstmt.setString(4, type);
			}
			rs = pstmt.executeQuery();
			while(rs.next()){
				count++;
				jsonobject = new JSONObject();
				jsonobject.put("alertDatetime",sdf1.format(rs.getTimestamp("alertDatetime")));
				jsonobject.put("tripNo",rs.getString("tripNo"));
				jsonobject.put("tripType",rs.getString("tripType"));
				jsonobject.put("vehicleNo",rs.getString("vehicleNo"));
				jsonobject.put("make",rs.getString("make"));
				jsonobject.put("lastCommunication",sdf1.format(rs.getTimestamp("lastCommunication")));
				jsonobject.put("ageing",rs.getString("ageing"));
				jsonobject.put("remarks",rs.getString("remarks"));
				if(rs.getString("updatedDate").contains("1900")){
					jsonobject.put("updatedDate","");
				} else {
					jsonobject.put("updatedDate",sdf1.format(rs.getTimestamp("updatedDate")));
				}
				jsonobject.put("updatedBy",rs.getString("updatedBy"));
				jsonobject.put("alertId",rs.getInt("alertId"));
				jsonobject.put("uniqueId",rs.getInt("uniqueId"));
				jsonArray.put(jsonobject);
			}
		
	} catch (Exception e) {
		e.printStackTrace();
	}finally {
		DBConnection.releaseConnectionToDB(con, pstmt, rs);
	}
	return jsonArray;

	}
}
