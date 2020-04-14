package t4u.functions;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.text.SimpleDateFormat;
import java.util.ArrayList;

import org.json.JSONArray;
import org.json.JSONObject;

import t4u.common.DBConnection;
import t4u.statements.SandMiningStatements;

public class SandExcavationFunction {
	public static final String GET_CUSTOMERS=" select CUSTOMER_ID,NAME from ADMINISTRATOR.dbo.CUSTOMER_MASTER where CUSTOMER_ID in ( select CUSTOMER_ID from AMS.dbo.TP_OWNER_ASSET_ASSOCIATION ) and SYSTEM_ID=? and CUSTOMER_ID=? ";
	
	public static final String GET_TPOWNERS= " select distinct  a.TP_ID as tpId,b.Permit_NoNEW as TpOwner FROM  AMS.dbo.TP_OWNER_ASSET_ASSOCIATION a "+ 
	"inner join  AMS.dbo.Temporary_Permit_Master b on a.SYSTEM_ID=b.System_Id and b.TP_ID=a.TP_ID "+
	"where a.SYSTEM_ID=? and a.CUSTOMER_ID=?  ";
	
	
	public static final String GET_EXCAVATION_DETAILS=" select EXCAVATED_LOCATION,dateadd(mi,?,EXCAVATED_TIME) as EXCAVATED_TIME,EXCAVATED_DURATION, "+
	" cast(ASSC_HUB_DISTANCE as numeric(32,2))  'ASSC_HUB_DISTANCE',ASSC_HUB_NAME,cast(UNASSC_HUB_DISTANCE as numeric(32,2))  'UNASSC_HUB_DISTANCE',UNASSC_HUB_NAME,cast( AVG_DEVICE_BATTERY_VOLTAGE  as numeric(32,2) )  'AVG_DEVICE_BATTERY_VOLTAGE' "+
	" from AMS.dbo.EXCAVATION_TRIP_DETAILS "+
	" where SYSTEM_ID=? and CUSTOMER_ID=? and TRIP_NUMBER=? and ASSET_NUMBER=? ";

	public static String GET_TRIP_EXCAVATION=" select distinct a.TP as TP_NO,a.ASSET_NUMBER as ASSET_NUMBER,a.ID as ID,dateadd(mi,?,a.START_TIME) as START_TIME,isnull(dateadd(mi,?,a.END_TIME),'') as END_TIME,datediff(hh,a.START_TIME,END_TIME) as totalTripTime ,  "+
	" isnull(a.TOTAL_EXCAVATION_TIME,'') as TOTAL_EXCAVATION_TIME,isnull(a.TOTAL_EXCAVATION_COUNT,'') as TOTAL_EXCAVATION_COUNT,  "+
	" isnull(a.REAMRKS,'') as REAMRKS ,cast( a.AVG_DEVICE_BATTERY_VOLTAGE  as numeric(32,2) )  'AVG_DEVICE_BATTERY_VOLTAGE',a.STATUS  "+
	" from AMS.dbo.SAND_EXCAVATION_TRIP_SUMMARY a "+
	" left outer join AMS.dbo.EXCAVATION_TRIP_DETAILS b on a.ID=b.TRIP_NUMBER "+  
	" where a.SYSTEM_ID=? and a.CUSTOMER_ID=?   "+
	" and a.INSERTED_DATETIME between dateadd(mi,-?,? ) and dateadd(mi,-?,? )  ";
	
	
	
	public JSONArray getCustomer(int cutomerId, int systemId) {

		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject = new JSONObject();
		Connection con=null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		try{
			con = DBConnection.getConnectionToDB("AMS");
			jsonArray = new JSONArray();
			jsonObject = new JSONObject();
			pstmt = con.prepareStatement(GET_CUSTOMERS);
			pstmt.setInt(1,systemId);
			pstmt.setInt(2,cutomerId);
			rs=pstmt.executeQuery();
			while(rs.next()){
				jsonObject = new JSONObject();
				jsonObject.put("CustId", rs.getString("CUSTOMER_ID"));
				jsonObject.put("CustName", rs.getString("NAME"));
				jsonArray.put(jsonObject);				
			}
		}catch(Exception e){
			e.printStackTrace();
			System.out.println("Error in getCustomer "+e.toString());
		}	
		finally{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}	
		return jsonArray;
	
	}
	
	public JSONArray getTPOwners(int systemId,int cutomerId) {

		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject = new JSONObject();
		Connection con=null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		try{
			con = DBConnection.getConnectionToDB("AMS");
			jsonArray = new JSONArray();
			jsonObject = new JSONObject();
			pstmt = con.prepareStatement(GET_TPOWNERS);
			pstmt.setInt(1,systemId);
			pstmt.setInt(2,cutomerId);
			rs=pstmt.executeQuery();
			while(rs.next()){
				jsonObject = new JSONObject();
				jsonObject.put("tpId", rs.getString("tpId"));
				jsonObject.put("tpOwner", rs.getString("TpOwner"));
				jsonArray.put(jsonObject);				
			}
		}catch(Exception e){
			e.printStackTrace();
			System.out.println("Error in getting tp owners "+e.toString());
		}	
		finally{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}	
		return jsonArray;
	
	}
	
	public JSONArray getBoatNames(int systemId,int cutomerId,int tpId) {

		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject = new JSONObject();
		Connection con=null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		try{
			con = DBConnection.getConnectionToDB("AMS");
			jsonArray = new JSONArray();
			jsonObject = new JSONObject();
					if(tpId==1){
						pstmt = con.prepareStatement("select REGISTRATION_NO,ISNULL(LOADING_HUB_ID,'') AS LOADING_HUB_ID  FROM  AMS.dbo.TP_OWNER_ASSET_ASSOCIATION where  SYSTEM_ID=? and  CUSTOMER_ID=? ");
						
					}else{
						pstmt = con.prepareStatement("select REGISTRATION_NO,ISNULL(LOADING_HUB_ID,'') AS LOADING_HUB_ID  FROM  AMS.dbo.TP_OWNER_ASSET_ASSOCIATION where  SYSTEM_ID=? and  CUSTOMER_ID=? and TP_ID="+tpId+"  ");
					}
			pstmt.setInt(1,systemId);
			pstmt.setInt(2,cutomerId);
			rs=pstmt.executeQuery();
			while(rs.next()){
				jsonObject = new JSONObject();
				jsonObject.put("hubId", rs.getString("LOADING_HUB_ID"));
				jsonObject.put("boatName", rs.getString("REGISTRATION_NO"));
				jsonArray.put(jsonObject);				
			}
		}catch(Exception e){
			e.printStackTrace();
			System.out.println("Error in getting tp owners "+e.toString());
		}	
		finally{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}	
		return jsonArray;
	
	}
	
	public JSONArray getAssociatedHub(int systemId,int cutomerId,int hubId) {
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject = new JSONObject();
		Connection con=null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		try{
			con = DBConnection.getConnectionToDB("AMS");
			jsonArray = new JSONArray();
			jsonObject = new JSONObject();
					if(hubId==1){
						pstmt = con.prepareStatement("select HUBID,NAME from AMS.dbo.LOCATION_ZONE_A where  SYSTEMID=?  and CLIENTID=?  ");
						
					}else{
						pstmt = con.prepareStatement("select HUBID,NAME from AMS.dbo.LOCATION_ZONE_A where  SYSTEMID=?  and CLIENTID=? and HUBID="+hubId+" ");
					}
			pstmt.setInt(1,systemId);
			pstmt.setInt(2,cutomerId);
			rs=pstmt.executeQuery();
			while(rs.next()){
				jsonObject = new JSONObject();
				jsonObject.put("hubId", rs.getString("HUBID"));
				jsonObject.put("hubName", rs.getString("NAME"));
				jsonArray.put(jsonObject);				
			}
		}catch(Exception e){
			e.printStackTrace();
			System.out.println("Error in getting tp owners "+e.toString());
		}	
		finally{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}	
		return jsonArray;
	
	}
	
	public JSONArray getDisAssociatedHub(int systemId,int cutomerId,int hubId) {
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject = new JSONObject();
		Connection con=null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		try{
			con = DBConnection.getConnectionToDB("AMS");
			jsonArray = new JSONArray();
			jsonObject = new JSONObject();
					if(hubId==1){
						pstmt = con.prepareStatement("select HUBID,NAME from AMS.dbo.LOCATION_ZONE_A where  SYSTEMID=?  and CLIENTID=?  ");
						
					}else{
						pstmt = con.prepareStatement("select HUBID,NAME from AMS.dbo.LOCATION_ZONE_A where  SYSTEMID=?  and CLIENTID=? and HUBID not in ("+hubId+") ");
					}
			pstmt.setInt(1,systemId);
			pstmt.setInt(2,cutomerId);
			rs=pstmt.executeQuery();
			while(rs.next()){
				jsonObject = new JSONObject();
				jsonObject.put("hubId", rs.getString("HUBID"));
				jsonObject.put("hubName", rs.getString("NAME"));
				jsonArray.put(jsonObject);				
			}
		}catch(Exception e){
			e.printStackTrace();
			System.out.println("Error in getting tp owners "+e.toString());
		}	
		finally{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}	
		return jsonArray;
	
	}
	
	public JSONArray getExcavationTrip(int systemId, int cutomerId,
			int tpId, String assetNumber, int assetId, int startDur,
			int endDur, int startAsscDistanace, int endAsscDistance, int startDisAsscDistance,
			int endDisAsscDistance, int associatedHubId, int disAsscHubId, String startDate,
			String endDate,String aHubName,String uHubName,int offset) {
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject = new JSONObject();
		Connection con=null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		try{
			con = DBConnection.getConnectionToDB("AMS");
			jsonArray = new JSONArray();
			jsonObject = new JSONObject();
			int count=0;
			System.out.println(startDur+" --- "+endDur);
			SimpleDateFormat db = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			SimpleDateFormat ui = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
			StringBuffer sbf = new StringBuffer();
			sbf.append(GET_TRIP_EXCAVATION);
			if(tpId!=1){
				sbf.append("and a.TP="+tpId+" ");	
			}if(assetId!=1){
				sbf.append("and a.ASSET_NUMBER='"+assetNumber+"' ");	
			}if(associatedHubId!=0){
				sbf.append("and b.ASSC_HUB_NAME='"+aHubName+"' ");	
			}if(disAsscHubId!=0){
				sbf.append("and b.UNASSC_HUB_NAME='"+uHubName+"' ");	
			}
			if(endDur>0){
				sbf.append(" and a.TOTAL_EXCAVATION_TIME between "+startDur+"  and "+endDur+" ");	
			}
			if(endAsscDistance>0){
				sbf.append(" and b.ASSC_HUB_DISTANCE between "+startAsscDistanace+"  and "+endAsscDistance+" ");	
			}
			if(endDisAsscDistance>0){
				sbf.append(" and b.UNASSC_HUB_DISTANCE between "+startDisAsscDistance+"  and "+endDisAsscDistance+" ");	
			}
			pstmt = con.prepareStatement(sbf.toString());
			pstmt.setInt(1,offset);
			pstmt.setInt(2,offset);
			pstmt.setInt(3,systemId);
			pstmt.setInt(4,cutomerId);
			pstmt.setInt(5,offset);
			pstmt.setString(6,db.format(ui.parse(startDate)));
			pstmt.setInt(7,offset);
			pstmt.setString(8,db.format(ui.parse(endDate)));
			rs=pstmt.executeQuery();
			while(rs.next()){
				jsonObject = new JSONObject();
				jsonObject.put("slno", ++count);
				jsonObject.put("tpOwner", rs.getInt("TP_NO"));
				jsonObject.put("assetNumber", rs.getString("ASSET_NUMBER"));
				jsonObject.put("tripNumber", rs.getString("ID"));
				jsonObject.put("startTime", ui.format(db.parse(rs.getString("START_TIME"))));
				if(rs.getString("END_TIME").contains("1900-01-01 00:00:00.0")){
					jsonObject.put("endTime", "");
				}else{
					jsonObject.put("endTime", ui.format(db.parse(rs.getString("END_TIME"))));
					
				}
				if(rs.getString("totalTripTime")==null){
					jsonObject.put("totalTrip",0);
				}else{
					jsonObject.put("totalTrip", rs.getString("totalTripTime"));
					
				}
				jsonObject.put("totalEtime", rs.getString("TOTAL_EXCAVATION_TIME"));
				jsonObject.put("totalEcount", rs.getString("TOTAL_EXCAVATION_COUNT"));
				jsonObject.put("remarks", rs.getString("REAMRKS"));
				jsonObject.put("voltage", rs.getString("AVG_DEVICE_BATTERY_VOLTAGE"));
				jsonObject.put("status", rs.getString("STATUS"));
				jsonObject.put("details", "");

				jsonArray.put(jsonObject);				
			}
			
		}catch(Exception e){
			e.printStackTrace();
			System.out.println("Error in getting tp owners "+e.toString());
		}	
		finally{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}	
		return jsonArray;
	
	}
	
	public JSONArray getExcavatioDetails(int cutomerId, int systemId,int tripNO,String assetNumber,int offset) {
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject = new JSONObject();
		Connection con=null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		try{
			int count=0;
			con = DBConnection.getConnectionToDB("AMS");
			SimpleDateFormat db = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			SimpleDateFormat ui = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
			jsonArray = new JSONArray();
			jsonObject = new JSONObject();
			pstmt = con.prepareStatement(GET_EXCAVATION_DETAILS);
			pstmt.setInt(1,offset);
			pstmt.setInt(2,systemId);
			pstmt.setInt(3,cutomerId);
			pstmt.setInt(4,tripNO);
			pstmt.setString(5,assetNumber);
			rs=pstmt.executeQuery();
			while(rs.next()){
				jsonObject = new JSONObject();
				jsonObject.put("slno", ++count);
				jsonObject.put("eloc", rs.getString("EXCAVATED_LOCATION"));
				jsonObject.put("etime", rs.getString("EXCAVATED_TIME"));
				jsonObject.put("edur", rs.getInt("EXCAVATED_DURATION"));
				if(rs.getString("EXCAVATED_TIME").contains("1900-01-01 00:00:00.0")){
					jsonObject.put("etime",  "");
				}else{
					jsonObject.put("etime",  ui.format(db.parse(rs.getString("EXCAVATED_TIME"))));
				}
				
				jsonObject.put("adist", rs.getDouble("ASSC_HUB_DISTANCE"));
				jsonObject.put("ahubName", rs.getString("ASSC_HUB_NAME"));
				jsonObject.put("udis", rs.getDouble("UNASSC_HUB_DISTANCE"));
				jsonObject.put("uhubName", rs.getString("UNASSC_HUB_NAME"));
				jsonObject.put("voltage", rs.getDouble("AVG_DEVICE_BATTERY_VOLTAGE"));
				jsonArray.put(jsonObject);				
			}
		}catch(Exception e){
			e.printStackTrace();
			System.out.println("Error in getCustomer "+e.toString());
		}	
		finally{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}	
		return jsonArray;
	
	}
	
	public JSONArray getTPWiseBoatAssociationDetails(String customerId, int systemId) {
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			int count = 0;
			con = DBConnection.getConnectionToDB("AMS");
			jsonArray = new JSONArray();
			pstmt = con.prepareStatement(SandMiningStatements.GET_TP_WISE_BOAT_ASSOCIATION_REPORT);
			pstmt.setInt(1, systemId);
			pstmt.setString(2, customerId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				jsonObject = new JSONObject();
				count++;
				jsonObject.put("slnoIndex", count);
				jsonObject.put("regNoIndex", rs.getString("RegistrationNumber"));
				jsonObject.put("permitNoIndex", rs.getString("PermitNumber"));
				jsonObject.put("loadingHubIndex", rs.getString("ParkingHub"));
				jsonArray.put(jsonObject);
			}
		} catch (Exception e) {
			e.printStackTrace();
			System.out.println("Error in getTPWiseBoatAssociationDetails " + e.toString());
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jsonArray;
	}
	
	public JSONArray getZeroValueCooordinatesDetails(String customerId, int systemId) {
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			int count = 0;
			con = DBConnection.getConnectionToDB("AMS");
			jsonArray = new JSONArray();
			pstmt = con.prepareStatement(SandMiningStatements.GET_ZERO_VALUE_COORDINATES);
			pstmt.setInt(1, systemId);
			pstmt.setString(2, customerId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				jsonObject = new JSONObject();
				count++;
				jsonObject.put("slnoIndex", count);
				jsonObject.put("regNoIndex", rs.getString("REGISTRATION_NO"));
				jsonObject.put("unitNoIndex", rs.getString("UNIT_NO"));
				jsonObject.put("longitudeIndex", rs.getString("LONGITUDE"));
				jsonObject.put("latitudeIndex", rs.getString("LATITUDE"));
				jsonObject.put("altitudeIndex", rs.getString("ALTITUDE"));
				jsonObject.put("speedIndex", rs.getString("SPEED"));
				jsonObject.put("satelliteIndex", rs.getString("SATELLITE"));
				jsonObject.put("gpsDateTimeIndex", rs.getString("GPS_DATETIME"));
				jsonArray.put(jsonObject);
			}
		} catch (Exception e) {
			e.printStackTrace();
			System.out.println("Error in getZeroValueCooordinatesDetails " + e.toString());
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jsonArray;
	}
	
	
}
