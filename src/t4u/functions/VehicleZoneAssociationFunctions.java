/**
 * 
 */
package t4u.functions;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;

import org.json.JSONArray;
import org.json.JSONObject;

import t4u.common.DBConnection;
import t4u.statements.CashVanManagementStatements;
import t4u.statements.TripCreationStatements;
import t4u.statements.VehicleZoneAssociationStatements;;

/**
 * @author praveen.j
 *
 */
public class VehicleZoneAssociationFunctions {
	CommonFunctions cf=new CommonFunctions();
	SimpleDateFormat sdfyyyymmddhhmmss=new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
	SimpleDateFormat yyyymmdd = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	SimpleDateFormat simpleDateFormatddMMYYYYDB = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	SimpleDateFormat sdfFormatDate = new SimpleDateFormat("MM/dd/yyyy HH:mm:ss");
	DecimalFormat df=new DecimalFormat("##.##");
	SimpleDateFormat ddmmyyyy = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
	
	/**
	 * getting Vehicle which is associated with zone
	 * @param customerid
	 * @param systemid
	 * @return Json Array
	 * @author praveen.j
	 */
	
	public JSONArray getVehicleZoneDetails(int custID, int systemId) {
		
		Connection conAdmin=null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		JSONArray vihicleZoneDetailsJSONArray=new JSONArray();
		try {
			conAdmin=DBConnection.getDashboardConnection("AMS");
			pstmt=conAdmin.prepareStatement(VehicleZoneAssociationStatements.GETVEHICLEZONEASSOCATION_DETAILS);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, custID);
			rs=pstmt.executeQuery();
			
			JSONObject vihicleZoneDetailsJSONObject;
			
			while (rs.next()) {
				vihicleZoneDetailsJSONObject=new JSONObject();
				vihicleZoneDetailsJSONObject.put("idIndex", rs.getString("ID"));
				vihicleZoneDetailsJSONObject.put("VehicleNoDataIndex", rs.getString("VEHICLE_NO"));
				vihicleZoneDetailsJSONObject.put("VehicleGroupDataIndex", rs.getString("VEHICLE_GROUP"));
				vihicleZoneDetailsJSONObject.put("ZoneDataIndex", rs.getString("ZONE_NAME"));
				vihicleZoneDetailsJSONObject.put("ZoneDataIndexId", rs.getString("ZONE_OR_HUB_ID"));
				vihicleZoneDetailsJSONObject.put("CreateDateDataIndex", rs.getDate("CREATED_TIME"));
				vihicleZoneDetailsJSONObject.put("CreateByDataIndex", rs.getString("CREATED_BY"));
				vihicleZoneDetailsJSONArray.put(vihicleZoneDetailsJSONObject);	
				
			}
		} catch (Exception e) {
			e.printStackTrace();
		}finally{
			DBConnection.releaseConnectionToDB(conAdmin, pstmt, rs);
		}
		return vihicleZoneDetailsJSONArray;
		
		
		
	}
	
	/** Get details for vehicle  
	 * @param customerid
	 * @param systemId
	 * @param userId
	 * @return
	 */
	public JSONArray getVehicleNoWithVendorName(String customerid, int systemId ,int userId) {

		JSONArray JsonArray = new JSONArray();
		JSONObject JsonObject = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;		 
		ResultSet rs = null;	
		try {
			JsonArray = new JSONArray();
			JsonObject = new JSONObject();

			con = DBConnection.getConnectionToDB("AMS");
			/*if (StartDate!=null && !StartDate.equals("")) {
				pstmt = con.prepareStatement(VehicleZoneAssociationStatements.GET_VEHILCE_NUMBER_FOR_TRIP_DETAILS_WITH_DATE);
				pstmt.setInt(1, systemId);
				pstmt.setInt(2, Integer.parseInt(customerid));
				pstmt.setInt(3, userId);
				pstmt.setInt(4, systemId);
				pstmt.setInt(5, Integer.parseInt(customerid));
				pstmt.setString(6, StartDate);
			} else {*/
				pstmt = con.prepareStatement(VehicleZoneAssociationStatements.GET_VEHILCE_NUMBER_FOR_TRIP_DETAILS);
				pstmt.setInt(1, systemId);
				pstmt.setInt(2, Integer.parseInt(customerid));
				pstmt.setInt(3, userId);
			//}
			rs = pstmt.executeQuery();
			while(rs.next())
			{
				JsonObject = new JSONObject();
				JsonObject.put("Registration_No", rs.getString("REGISTRATION_NUMBER"));
				JsonObject.put("Vehicle_group", rs.getString("GROUP_NAME"));
				JsonObject.put("odoMeter", rs.getString("OPENING_ODOMETER"));
				JsonArray.put(JsonObject);
			}

		}catch(Exception e){
			e.printStackTrace();
		}finally{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}

		return JsonArray;
	}
	/** Get details for vehicle  
	 * @param customerid
	 * @param systemId
	 * @param userId
	 * @return
	 */
	public JSONArray getZone_HUBID(String customerid, int systemId ,int userId,String zone) {

		JSONArray JsonArray = new JSONArray();
		JSONObject JsonObject = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;		 
		ResultSet rs = null;	
		try {
			JsonArray = new JSONArray();
			JsonObject = new JSONObject();

			con = DBConnection.getConnectionToDB("AMS");
			
				pstmt = con.prepareStatement(VehicleZoneAssociationStatements.GET_ZONE_HUBID.replace("LOCATION", "LOCATION_ZONE_"+zone));
				pstmt.setInt(1, systemId);
				pstmt.setInt(2, Integer.parseInt(customerid));
				//pstmt.setInt(3, userId);
		
			rs = pstmt.executeQuery();
			while(rs.next())
			{
				JsonObject = new JSONObject();
				JsonObject.put("Zone_Name", rs.getString("ZONE_NAME"));
				JsonObject.put("HUBID", rs.getString("HUBID"));
				JsonArray.put(JsonObject);
			}

		}catch(Exception e){
			e.printStackTrace();
		}finally{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}

		return JsonArray;
	}
	public String addVenicleTOZone(String vehicleNo,String vehicleGroup,String zoneOrHubId,String zoneName,int systemId,int custId,String userName){
	    Connection con = null;
		PreparedStatement pstmt= null;
		ResultSet rs = null;
		String message="";
		
		try
		{
			 con = DBConnection.getConnectionToDB("AMS");
			 pstmt = con.prepareStatement(VehicleZoneAssociationStatements.CHECK_VEHICLE_ZONE_ALREADY_EXIST);
			 pstmt.setString(1, vehicleNo);
			 pstmt.setInt(3, systemId);
			 pstmt.setInt(2, custId);
			 pstmt.setString(4,zoneOrHubId);
			 rs = pstmt.executeQuery();
			 if(rs.next())
			 {
				 message="Vehicle Already Associated to Zone";
				 return message;
			 }
			 pstmt = con.prepareStatement(VehicleZoneAssociationStatements.ADD_VEHICLE_ZONE);
			 
			 pstmt.setInt(1, systemId);
			 pstmt.setInt(2, custId);
			
			 pstmt.setString(3, vehicleNo);
			 pstmt.setString(4, vehicleGroup);
			 pstmt.setString(5, zoneOrHubId);
			 pstmt.setString(6, zoneName);
			 pstmt.setString(7, userName);	
			int inserted = pstmt.executeUpdate();
			if (inserted > 0) {
               message = "Saved Successfully";
          }
		}
		 catch (Exception e)
		 {
				//System.out.println("error in:-save Map Vehicle and Zone  details "+e.toString());
				e.printStackTrace();
		 }      
		finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
	    }
		return message;
				
	 
 }
	
	public String modifyVenicleTOZone(String vehicleNo,String vehicleGroup,String zoneOrHubId,String zoneName,int systemId,int custId,String userName,int id){
	    Connection con = null;
		PreparedStatement pstmt= null;
		ResultSet rs = null;
		String message="";
		
		try
		{
			 con = DBConnection.getConnectionToDB("AMS");
			 pstmt = con.prepareStatement(VehicleZoneAssociationStatements.CHECK_VEHICLE_ZONE_ALREADY_EXIST);
			 pstmt.setString(1, vehicleNo);
			 pstmt.setInt(2, custId);
			 pstmt.setInt(3, systemId);
			 pstmt.setString(4,zoneOrHubId);
			 rs = pstmt.executeQuery();
			 if(rs.next())
			 {
				 message="Vehicle Already Associated to Zone";
				 return message;
			 }
			 pstmt = con.prepareStatement(VehicleZoneAssociationStatements.UPDATE_VEHICL_ZONE);
			 
			 
			 pstmt.setString(1, zoneOrHubId);
			 pstmt.setString(2, zoneName);
			 pstmt.setString(3, userName);	
			 
			pstmt.setString(4, vehicleNo);
			pstmt.setString(5, vehicleGroup);
			 pstmt.setInt(6, systemId);
			 pstmt.setInt(7, custId);
			 pstmt.setInt(8, id);
		
			int inserted = pstmt.executeUpdate();
			if (inserted > 0) {
               message = "Modified Successfully";
          }
		}
		 catch (Exception e)
		 {
				//System.out.println("error in:-save Map Vehicle and Zone  details "+e.toString());
				e.printStackTrace();
		 }      
		finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
	    }
		return message;
				
	 
 }
}
