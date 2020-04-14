package t4u.functions;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;

import org.json.JSONArray;
import org.json.JSONObject;

import t4u.common.DBConnection;
import t4u.statements.RouteMasterStatements;

public class RouteMasterFunction {
	
	CommonFunctions cofun = new CommonFunctions();
	
	JSONArray jsonArray = new JSONArray();
	JSONObject jsonObject = null;
	
	Connection con = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	
	public JSONArray getVehicleType(int systemId,int clientId){
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(RouteMasterStatements.GET_VEHICLE_TYPE);
			pstmt.setInt(1,systemId);
			pstmt.setInt(2, clientId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				jsonObject = new JSONObject();
				jsonObject.put("Vehicle_Type",rs.getString("VehicleType"));
				jsonArray.put(jsonObject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
	   return jsonArray;
    }

	public JSONArray getSourdeDestinationAndCheckPoints(int clientId,int systemId,String zone) {
		
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(cofun.getLocationQuery(RouteMasterStatements.GET_SOURCE_DESTINATION_AND_CHECK_POINTS, zone));
			pstmt.setInt(1,clientId);
			pstmt.setInt(2, systemId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				jsonObject = new JSONObject();
				jsonObject.put("Hub_Id",rs.getInt("HUBID"));
				jsonObject.put("Hub_Name",rs.getString("NAME"));
				jsonArray.put(jsonObject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
	  return jsonArray;
	}
	
	public int saveRouteMasterDetails(String vehicleType,String routeMode,String routeName,String routeNameETA,double routeKMS,String source,
			String destination,int systemId,int clientId,int userId,String type,int ba){
		
		int inserted = 0; 
		
		try{
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(RouteMasterStatements.SAVE_ROUTE_MASTER_DETAILS,Statement.RETURN_GENERATED_KEYS);
			pstmt.setString(1,routeName);
			pstmt.setString(2,routeMode);
			pstmt.setString(3,source);
			pstmt.setString(4,destination);
			pstmt.setString(5, routeNameETA);
			pstmt.setDouble(6, routeKMS);
			pstmt.setString(7,vehicleType);
			pstmt.setInt(8, systemId);
			pstmt.setInt(9, clientId);
			pstmt.setInt(10, userId);
			pstmt.setString(11, type);
			pstmt.setInt(12, ba);
			pstmt.executeUpdate();
			rs = pstmt.getGeneratedKeys();
			if(rs.next())
			{
			 inserted = rs.getInt(1);
			}
		}catch (Exception e) {
			e.printStackTrace();
		}finally{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return inserted;
	}
	
	public void saveCheckPoint(int systemId,int clientId,int routeId,String checkPoint,double checkPointETA,int seqPoint){
		
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(RouteMasterStatements.SAVE_CHECK_POINT);
			pstmt.setInt(1, routeId);
			pstmt.setString(2, checkPoint);
			pstmt.setDouble(3,checkPointETA);
			pstmt.setInt(4,seqPoint);
			pstmt.setInt(5,clientId);
			pstmt.setInt(6,systemId);
			pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		}finally{
			DBConnection.releaseConnectionToDB(con, pstmt, null);
		}
	}
	
	public String modifyRouteMasterDetails(String vehicleType,String routeMode,String routeName,String routeNameETA,double routeKMS,String source,
			String destination,int systemId,int clientId,int userId,String type,int routeCode,int ba){
		
		String message = "";
		int updated = 0 ;
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(RouteMasterStatements.UPDATE_ROUTE_MASTER);
			pstmt.setString(1,routeName);
			pstmt.setString(2,routeMode);
			pstmt.setString(3,source);
			pstmt.setString(4,destination);
			pstmt.setString(5, routeNameETA);
			pstmt.setDouble(6, routeKMS);
			pstmt.setString(7,vehicleType);
			pstmt.setInt(8, ba);
			pstmt.setInt(9, systemId);
			pstmt.setInt(10, clientId);
			pstmt.setString(11, type);
			pstmt.setInt(12,routeCode);
			updated = pstmt.executeUpdate();
			if(updated>0){
				message = "Updated Successfully";
			}
		} catch (Exception e) {
			e.printStackTrace();
		}finally{
			DBConnection.releaseConnectionToDB(con, pstmt, null);
		}
		return message;
	}
	
	public int deleteCheckPoint(int systemId,int clientId,int routeId){
		
		int deleted = 0 ;
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(RouteMasterStatements.DELETE_CHECK_POINT);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2,clientId);
			pstmt.setInt(3,routeId);
			deleted = pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		}finally{
			DBConnection.releaseConnectionToDB(con, pstmt, null);
		}
		return deleted;
	}
	
	public JSONArray getRouteMasterDetails(int systemId,int clientId,String type,String language,String zone){

		int count = 0;
		PreparedStatement pstmt1 = null;
		ResultSet rs1 = null;
		
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(RouteMasterStatements.GET_ROUTE_MASTER_DETAILS.replaceAll("#", zone));
			pstmt.setInt(1,systemId);
			pstmt.setInt(2, clientId);
			pstmt.setString(3,type);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				count++;
				jsonObject = new JSONObject();
				jsonObject.put("slnoIndex",count);
				jsonObject.put("BaDataIndex",rs.getString("GROUP_NAME"));
				jsonObject.put("BaDataIdIndex",rs.getString("GROUP_ID"));
				jsonObject.put("RouteIdDataIndex",rs.getString("ROUTE_ID"));
				jsonObject.put("VehicleTypeDataIndex",rs.getString("VEHICLE_TYPE"));
				jsonObject.put("RouteModeDataIndex",rs.getString("TRIP_CODE"));
				jsonObject.put("RouteNameDataIndex",rs.getString("TRIP_NAME"));
				jsonObject.put("ETADataIndex",rs.getString("DESTINATION_DEPARTURE").trim());
				jsonObject.put("KMSDataIndex",rs.getString("DISTANCE"));
				jsonObject.put("SourceDataIndex",rs.getString("SOURCE"));
				jsonObject.put("SourceIdDataIndex",rs.getString("ORIGIN"));
				jsonObject.put("DestinationDataIndex",rs.getString("DESTINATIONNAME"));
				jsonObject.put("DestinationIdDataIndex",rs.getString("DESTINATION"));
				jsonObject.put("NoofCheckPointDataIndex",rs.getString("NOOFCHECKPOINT"));
				
				pstmt1 = con.prepareStatement(RouteMasterStatements.GET_CHECKPOINTS);
				pstmt1.setInt(1,systemId);
				pstmt1.setInt(2, clientId);
				pstmt1.setInt(3,rs.getInt("ROUTE_ID"));
				rs1 = pstmt1.executeQuery();
				while(rs1.next()){
					String ETA = rs1.getString("TRANSITION_POINT_ARRIVAL");
					if(ETA.length()<3) {
						ETA = ETA+".00";
					}
					if(ETA.charAt(2)!='.'){
						ETA = "0"+ETA;
					}
					if(ETA.length()<5) {
						ETA=ETA + "0";
					}
					ETA = ETA.replace('.', ':');
					jsonObject.put("CheckPoint"+rs1.getInt("SEQUENCE")+"DataIndex", rs1.getString("TRANSITION_POINT"));
					jsonObject.put("CheckPointETA"+rs1.getInt("SEQUENCE")+"DataIndex",ETA);
					
				/*switch(rs1.getInt("SEQUENCE")){
					case 1 : 
						jsonObject.put("CheckPoint1DataIndex", rs1.getString("TRANSITION_POINT"));
						jsonObject.put("CheckPointETA1DataIndex", rs1.getString("TRANSITION_POINT_ARRIVAL").replace('.', ':'));
						break;
					case 2 : 
						jsonObject.put("CheckPoint2DataIndex", rs1.getString("TRANSITION_POINT"));
						jsonObject.put("CheckPointETA2DataIndex", rs1.getString("TRANSITION_POINT_ARRIVAL").replace('.', ':'));
						break;
					case 3 : 
						jsonObject.put("CheckPoint3DataIndex", rs1.getString("TRANSITION_POINT"));
						jsonObject.put("CheckPointETA3DataIndex", rs1.getString("TRANSITION_POINT_ARRIVAL").replace('.', ':'));
						break;
					case 4 : 
						jsonObject.put("CheckPoint4DataIndex", rs1.getString("TRANSITION_POINT"));
						jsonObject.put("CheckPointETA4DataIndex", rs1.getString("TRANSITION_POINT_ARRIVAL").replace('.', ':'));
						break;
					case 5 : 
						jsonObject.put("CheckPoint5DataIndex", rs1.getString("TRANSITION_POINT"));
						jsonObject.put("CheckPointETA5DataIndex", rs1.getString("TRANSITION_POINT_ARRIVAL").replace('.', ':'));
						break;
					case 6 : 
						jsonObject.put("CheckPoint6DataIndex", rs1.getString("TRANSITION_POINT"));
						jsonObject.put("CheckPointETA6DataIndex", rs1.getString("TRANSITION_POINT_ARRIVAL").replace('.', ':'));
						break;
					case 7 : 
						jsonObject.put("CheckPoint7DataIndex", rs1.getString("TRANSITION_POINT"));
						jsonObject.put("CheckPointETA7DataIndex", rs1.getString("TRANSITION_POINT_ARRIVAL").replace('.', ':'));
						break;
					case 8 : 
						jsonObject.put("CheckPoint8DataIndex", rs1.getString("TRANSITION_POINT"));
						jsonObject.put("CheckPointETA8DataIndex", rs1.getString("TRANSITION_POINT_ARRIVAL").replace('.', ':'));
						break;
					case 9 : 
						jsonObject.put("CheckPoint9DataIndex", rs1.getString("TRANSITION_POINT"));
						jsonObject.put("CheckPointETA9DataIndex", rs1.getString("TRANSITION_POINT_ARRIVAL").replace('.', ':'));
						break;
					case 10 : 
						jsonObject.put("CheckPoint10DataIndex", rs1.getString("TRANSITION_POINT"));
						jsonObject.put("CheckPointETA10DataIndex", rs1.getString("TRANSITION_POINT_ARRIVAL").replace('.', ':'));
						break;
					case 11 : 
						jsonObject.put("CheckPoint11DataIndex", rs1.getString("TRANSITION_POINT"));
						jsonObject.put("CheckPointETA11DataIndex", rs1.getString("TRANSITION_POINT_ARRIVAL").replace('.', ':'));
						break;
					case 12 : 
						jsonObject.put("CheckPoint12DataIndex", rs1.getString("TRANSITION_POINT"));
						jsonObject.put("CheckPointETA12DataIndex", rs1.getString("TRANSITION_POINT_ARRIVAL").replace('.', ':'));
						break;
					case 13 : 
						jsonObject.put("CheckPoint13DataIndex", rs1.getString("TRANSITION_POINT"));
						jsonObject.put("CheckPointETA13DataIndex", rs1.getString("TRANSITION_POINT_ARRIVAL").replace('.', ':'));
						break;
					case 14 : 
						jsonObject.put("CheckPoint14DataIndex", rs1.getString("TRANSITION_POINT"));
						jsonObject.put("CheckPointETA14DataIndex", rs1.getString("TRANSITION_POINT_ARRIVAL").replace('.', ':'));
						break;
					case 15 : 
						jsonObject.put("CheckPoint15DataIndex", rs1.getString("TRANSITION_POINT"));
						jsonObject.put("CheckPointETA15DataIndex", rs1.getString("TRANSITION_POINT_ARRIVAL").replace('.', ':'));
						break;
					case 16 : 
						jsonObject.put("CheckPoint16DataIndex", rs1.getString("TRANSITION_POINT"));
						jsonObject.put("CheckPointETA16DataIndex", rs1.getString("TRANSITION_POINT_ARRIVAL").replace('.', ':'));
						break;
					case 17 : 
						jsonObject.put("CheckPoint17DataIndex", rs1.getString("TRANSITION_POINT"));
						jsonObject.put("CheckPointETA17DataIndex", rs1.getString("TRANSITION_POINT_ARRIVAL").replace('.', ':'));
						break;
					case 18 : 
						jsonObject.put("CheckPoint18DataIndex", rs1.getString("TRANSITION_POINT"));
						jsonObject.put("CheckPointETA18DataIndex", rs1.getString("TRANSITION_POINT_ARRIVAL").replace('.', ':'));
						break;
					case 19 : 
						jsonObject.put("CheckPoint19DataIndex", rs1.getString("TRANSITION_POINT"));
						jsonObject.put("CheckPointETA19DataIndex", rs1.getString("TRANSITION_POINT_ARRIVAL").replace('.', ':'));
						break;
					case 20 : 
						jsonObject.put("CheckPoint20DataIndex", rs1.getString("TRANSITION_POINT"));
						jsonObject.put("CheckPointETA20DataIndex", rs1.getString("TRANSITION_POINT_ARRIVAL").replace('.', ':'));
						break;
				  }*/
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
	
}

