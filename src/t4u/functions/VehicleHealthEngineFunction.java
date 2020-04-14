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
import t4u.statements.VehicleHealthEngineStatement;
import t4u.statements.CreateTripStatement;

public class VehicleHealthEngineFunction {
	
	CommonFunctions cfuncs = new CommonFunctions();
	SimpleDateFormat sdfFormatDate = new SimpleDateFormat("MM/dd/yyyy HH:mm:ss");
	SimpleDateFormat sdfyyyymmddhhmmss=new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
	SimpleDateFormat sdfyyyymmdd=new SimpleDateFormat("dd-MM-yyyy");
	SimpleDateFormat sdfmmddyyyyhhmmss=new SimpleDateFormat("MM/dd/yyyy HH:mm:ss");
	SimpleDateFormat sdfddmmyyyy = new SimpleDateFormat("dd/MM/yyyy");
	SimpleDateFormat sdfmmddyyyy = new SimpleDateFormat("MM/dd/yyyy");
	SimpleDateFormat sfddMMYYYY = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
	SimpleDateFormat yyyymmdd = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	SimpleDateFormat ddmmyyyy = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
	CommonFunctions cf = new CommonFunctions();
	DecimalFormat doubleformat = new DecimalFormat("#.##");
	DecimalFormat singleformat = new DecimalFormat("#.#");
	
	public JSONArray getOBDVehicle(int systemId,int customerId,int reportId) {

		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject = new JSONObject();
		Connection con=null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		try{
			con = DBConnection.getConnectionToDB("AMS");
			jsonArray = new JSONArray();
			jsonObject = new JSONObject();
			if(reportId==5){
				pstmt = con.prepareStatement(VehicleHealthEngineStatement.GET_ACCIDENT_VEHICLE_LIST);
				pstmt.setInt(1,systemId);
				pstmt.setInt(2,customerId);
				pstmt.setInt(3,systemId);
				pstmt.setInt(4,customerId);
			}else{
			pstmt = con.prepareStatement(VehicleHealthEngineStatement.GET_OBD_VEHICLE_LIST);
			pstmt.setInt(1,systemId);
			pstmt.setInt(2,customerId);
			}
			rs=pstmt.executeQuery();
			while(rs.next()){
				jsonObject = new JSONObject();
				jsonObject.put("vehicleNo", rs.getString("REGISTRATION_NO"));
				jsonArray.put(jsonObject);				
			}
		}catch(Exception e){
			System.out.println("Error in getOBDVehicle "+e.toString());
		}	
		finally{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}	
		return jsonArray;
	
	}
	
	public ArrayList < Object > getCoolentTempDetails(int systemId, int customerId,int offset,String vehicleNo,String startDate,String endDate) {
	    JSONArray JsonArray = new JSONArray();
	    JSONObject JsonObject = null;
	    Connection con = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
	   
	    ArrayList < Object > finlist = new ArrayList < Object > ();
	    try {
	    	int count = 0;
	        con = DBConnection.getConnectionToDB("AMS");
	        pstmt = con.prepareStatement(VehicleHealthEngineStatement.GET_COOLENT_TEMP_DETAILS);
	        pstmt.setInt(1, offset);
	        pstmt.setInt(2, offset);
	        pstmt.setInt(3, systemId);
	        pstmt.setInt(4, customerId);
	        pstmt.setString(5, vehicleNo);
	        pstmt.setInt(6, offset);
	        pstmt.setString(7, startDate);
	        pstmt.setInt(8, offset);
	        pstmt.setString(9, endDate);
	        rs = pstmt.executeQuery();
	        
	        SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm");
			
	        while (rs.next()) {
	            JsonObject = new JSONObject();
	            count++;
	           
	            JsonObject.put("slnoIndex", count);
	            
	            JsonObject.put("VehicleNoIndex",rs.getString("REGISTRATION_NO"));
	            
	            JsonObject.put("startDateDataIndex",sdf.format(rs.getTimestamp("START_GMT"))); 
	            
	            JsonObject.put("endDateDataIndex",sdf.format(rs.getTimestamp("END_GMT")));
	            
	            JsonObject.put("collentValueDataIndex",rs.getString("MAX_COOLANT"));
	            
	            JsonObject.put("durationDataIndex", rs.getString("DURTION"));
	            
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
	
	public ArrayList < Object > getEngineErrorCodeDetails(int systemId, int customerId,int offset,String vehicleNo,String startDate,String endDate) {
	    JSONArray JsonArray = new JSONArray();
	    JSONObject JsonObject = null;
	    Connection con = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
	   
	    ArrayList < Object > finlist = new ArrayList < Object > ();
	    try {
	    	int count = 0;
	        con = DBConnection.getConnectionToDB("AMS");
	        pstmt = con.prepareStatement(VehicleHealthEngineStatement.GET_ENGINE_ERROR_CODE_DETAILS);
	        pstmt.setInt(1, offset);
	        pstmt.setInt(2, offset);
	        pstmt.setInt(3, offset);
	        pstmt.setInt(4, systemId);
	        pstmt.setInt(5, customerId);
	        pstmt.setString(6, vehicleNo);
	        pstmt.setInt(7, offset);
	        pstmt.setString(8, startDate);
	        pstmt.setInt(9, offset);
	        pstmt.setString(10, endDate);
	        rs = pstmt.executeQuery();
	        
	        SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm");
			
	        while (rs.next()) {
	            JsonObject = new JSONObject();
	            count++;
	           
	            JsonObject.put("slnoerrorIndex", count);
	            
	            JsonObject.put("vehicleNoErrorIndex",rs.getString("REGISTRATION_NO"));
	            
	            JsonObject.put("errorCodeDataIndex",rs.getString("ERROR_CODE"));
	            
	            JsonObject.put("errorDescDataIndex",rs.getString("ERROR_DESC"));
	            
	            JsonObject.put("startDateErrorDataIndex",sdf.format(rs.getTimestamp("START_GMT"))); 
	            
	            JsonObject.put("endDateErrorDataIndex",sdf.format(rs.getTimestamp("END_GMT")));
	            
	            JsonObject.put("imactDataIndex", rs.getString("IMPACT"));
	            
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
	public ArrayList < Object > getMileageDetails(int systemId, int customerId,int offset,String vehicleNo,String startDate,String endDate) {
	    JSONArray JsonArray = new JSONArray();
	    JSONObject JsonObject = null;
	    Connection con = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
	   
	    ArrayList < Object > finlist = new ArrayList < Object > ();
	    try {
	    	int count = 0;
	        con = DBConnection.getConnectionToDB("AMS");
	        pstmt = con.prepareStatement(VehicleHealthEngineStatement.GET_MILEAGE_DETAILS);
	        pstmt.setInt(1, systemId);
	        pstmt.setInt(2, customerId);
	        pstmt.setString(3, vehicleNo);
	        rs = pstmt.executeQuery();
	        
	        SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
			
	        while (rs.next()) {
	            JsonObject = new JSONObject();
	            count++;
	           
	            JsonObject.put("slnoMileageIndex", count);
	            
	            JsonObject.put("vehicleNoMileageIndex",rs.getString("REGISTRATION_NO"));
	            
	            JsonObject.put("dateMileageDataIndex",rs.getString("Month")); 
	            
	            JsonObject.put("fuelDataIndex",rs.getString("FUEL_CONSUMED"));
	            
	            JsonObject.put("distanceMileageDataIndex",rs.getString("DISTANCE_TRAVELLED"));
	            
	            JsonObject.put("mileageDataIndex", rs.getString("MILEAGE"));
	            
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
	public ArrayList < Object > getElectricalHealthDetails(int systemId, int customerId,int offset,String vehicleNo,String startDate,String endDate) {
	    JSONArray JsonArray = new JSONArray();
	    JSONObject JsonObject = null;
	    Connection con = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
	   
	    ArrayList < Object > finlist = new ArrayList < Object > ();
	    try {
	    	int count = 0;
	        con = DBConnection.getConnectionToDB("AMS");
	        pstmt = con.prepareStatement(VehicleHealthEngineStatement.GET_BATTERY_DETAILS.replace("#", " and AVG_VALUE > 15.5"));
	        pstmt.setInt(1, offset);
	        pstmt.setInt(2, systemId);
	        pstmt.setInt(3, customerId);
	        pstmt.setString(4, vehicleNo);
	        pstmt.setInt(5, offset);
	        pstmt.setString(6, startDate);
	        pstmt.setInt(7, offset);
	        pstmt.setString(8, endDate);
	        rs = pstmt.executeQuery();
	        
	        SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm");
			
	        while (rs.next()) {
	            JsonObject = new JSONObject();
	            count++;
	           
	            JsonObject.put("slnoElectricalIndex", count);
	            
	            JsonObject.put("vehicleNoElectricalIndex",rs.getString("REGISTRATION_NO"));
	            
	            JsonObject.put("dateBatteryDataIndex",sdf.format(rs.getTimestamp("GMT"))); 
	            
	            JsonObject.put("batteryDataIndex",rs.getString("AVG_VALUE")); 
	            
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
	public ArrayList < Object > getBatteryHealthDetails(int systemId, int customerId,int offset,String vehicleNo,String startDate,String endDate) {
	    JSONArray JsonArray = new JSONArray();
	    JSONObject JsonObject = null;
	    Connection con = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
	   
	    ArrayList < Object > finlist = new ArrayList < Object > ();
	    try {
	    	int count = 0;
	        con = DBConnection.getConnectionToDB("AMS");
	        pstmt = con.prepareStatement(VehicleHealthEngineStatement.GET_BATTERY_DETAILS.replace("#", "and AVG_VALUE < 12.5"));
	        pstmt.setInt(1, offset);
	        pstmt.setInt(2, systemId);
	        pstmt.setInt(3, customerId);
	        pstmt.setString(4, vehicleNo);
	        pstmt.setInt(5, offset);
	        pstmt.setString(6, startDate);
	        pstmt.setInt(7, offset);
	        pstmt.setString(8, endDate);
	        rs = pstmt.executeQuery();
	        
	        SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
			
	        while (rs.next()) {
	            JsonObject = new JSONObject();
	            count++;
	           
	            JsonObject.put("slnoElectricalIndex2", count);
	            
	            JsonObject.put("vehicleNoElectricalIndex2",rs.getString("REGISTRATION_NO"));
	            
	            JsonObject.put("dateBatteryDataIndex2",sdf.format(rs.getTimestamp("GMT"))); 
	            
	            JsonObject.put("batteryDataIndex2",rs.getString("AVG_VALUE")); 
	            
	            JsonObject.put("distanceDataIndex2",rs.getString("DISTANCE")); 
	            
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
	public ArrayList < Object > getAccidentDetails(int systemId, int customerId,int offset,String vehicleNo,String startDate,String endDate) {
	    JSONArray JsonArray = new JSONArray();
	    JSONObject JsonObject = null;
	    Connection con = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
	   
	    ArrayList < Object > finlist = new ArrayList < Object > ();
	    try {
	    	int count = 0;
	        con = DBConnection.getConnectionToDB("AMS");
	        pstmt = con.prepareStatement(VehicleHealthEngineStatement.GET_ACCIDENT_VEHICLE_DETAILS);
	        pstmt.setInt(1, offset);
	        pstmt.setInt(2, systemId);
	        pstmt.setInt(3, customerId);
	        pstmt.setInt(4, offset);
	        pstmt.setString(5, startDate);
	        pstmt.setInt(6, offset);
	        pstmt.setString(7, endDate);
	        pstmt.setString(8, vehicleNo);
	        pstmt.setInt(9, offset);
	        pstmt.setInt(10, systemId);
	        pstmt.setInt(11, customerId);
	        pstmt.setInt(12, offset);
	        pstmt.setString(13, startDate);
	        pstmt.setInt(14, offset);
	        pstmt.setString(15, endDate);
	        pstmt.setString(16, vehicleNo);
	        rs = pstmt.executeQuery();
	        
	        SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm");
			
	        while (rs.next()) {
	            JsonObject = new JSONObject();
	            count++;
	           
	            JsonObject.put("slnoAccidentIndex", count);
	            
	            JsonObject.put("vehicleNoAccidentIndex",rs.getString("REGISTRATION_NO"));
	            
	            JsonObject.put("accidentDateDataIndex",sdf.format(rs.getTimestamp("GMT"))); 
	            
	            JsonObject.put("accidentLocationDataIndex",rs.getString("LOCATION")); 
	            
	            JsonObject.put("accidentDescDataIndex",rs.getString("REMARKS")); 
	            
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
	

}
