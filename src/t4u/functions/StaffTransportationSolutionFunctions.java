package t4u.functions;


import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import java.text.DecimalFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Collections;
import java.util.Comparator;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.StringTokenizer;
import java.util.TreeMap;
import java.util.Map.Entry;
import java.util.HashMap;



import org.json.JSONArray;
import org.json.JSONObject;

import t4u.beans.ReportHelper;
import t4u.beans.VehicleUtilizationBean;
import t4u.common.DBConnection;

import t4u.statements.StaffTransportationSolutionStatements;


public class StaffTransportationSolutionFunctions {
	
	SimpleDateFormat sdfyyyymmddhhmmss=new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
	SimpleDateFormat yyyymmdd = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	SimpleDateFormat sdfFormatDate = new SimpleDateFormat("MM/dd/yyyy HH:mm:ss");
	SimpleDateFormat ddmmyyyyhhmmss = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
	DecimalFormat df=new DecimalFormat("##.##");
	CommonFunctions commonFunctions = new CommonFunctions();
	SimpleDateFormat hhmmFormat = new SimpleDateFormat("HH:mm");
	public String addShiftDetails(String shiftName,float startTime,float endTime,String status,int systemId,int custId,int userId,int branchId)
	{
		Connection con = null;
		PreparedStatement pstmt= null;
		ResultSet rs = null;
		String message="";
		
		try
		{
			 con = DBConnection.getConnectionToDB("AMS");
			 pstmt = con.prepareStatement(StaffTransportationSolutionStatements.CHECK_SHIFT_ALREADY_EXIST);
			 pstmt.setString(1, shiftName);
			 pstmt.setInt(2, systemId);
			 pstmt.setInt(3, custId);
			 pstmt.setInt(4, branchId);
			 rs = pstmt.executeQuery();
			 if(rs.next())
			 {
				 message="Shift Already Exist";
				 return message;
			 }
			 pstmt = con.prepareStatement(StaffTransportationSolutionStatements.INSERT_SHIFT);
			 pstmt.setString(1, shiftName);
			 pstmt.setFloat(2, startTime);
			 pstmt.setFloat(3, endTime);
			 pstmt.setString(4, status);
			 pstmt.setInt(5, systemId);
			 pstmt.setInt(6, custId);
			 pstmt.setInt(7, userId);
			 pstmt.setInt(8, branchId);
			 int inserted = pstmt.executeUpdate();
			if (inserted > 0) {
                  message = "Saved Successfully";
             }
		}
		 catch (Exception e)
		 {
			
				e.printStackTrace();
		 }      
		finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
	    }
		return message;
				
	}
	
	public String modifyShiftMaster(String shiftName,float startTime,float endTime,String status,int systemId,int custId,int userId,int shiftId,int branchId)
	{
		Connection con=null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		String message="";
		try
		{
			con=DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(StaffTransportationSolutionStatements.CHECK_SHIFT_ALREADY_EXIST_FOR_MODIFY);
			 pstmt.setString(1, shiftName);
			 pstmt.setInt(2, systemId);
			 pstmt.setInt(3, custId);
			 pstmt.setInt(4, shiftId);
			 rs = pstmt.executeQuery();
			 if(rs.next())
			 {
				 message="<p>Shift Name Already Exists. Try some other Shift Name.</p>";
				 return message;
			 }
			pstmt=con.prepareStatement(StaffTransportationSolutionStatements.UPDATE_SHIFT);
			 pstmt.setString(1, shiftName);
			 pstmt.setFloat(2, startTime);
			 pstmt.setFloat(3, endTime);
			 pstmt.setString(4, status);
			 pstmt.setInt(5, userId);
			 pstmt.setInt(6, branchId);
			 pstmt.setInt(7, systemId);
			 pstmt.setInt(8, custId);
			 pstmt.setInt(9,shiftId);
			int updated=pstmt.executeUpdate();
			if(updated>0)
			{
				message = "Updated Successfully";
			}
		}catch(Exception e)
		{
			e.printStackTrace();
		}
		finally
		{
			DBConnection.releaseConnectionToDB(con,pstmt,rs);
		}
		return message;
	}
	
	public ArrayList < Object > getShiftMasterDetails(int systemId, int customerId) {
	    JSONArray JsonArray = new JSONArray();
	    JSONObject JsonObject = null;
	    Connection con = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
	    ArrayList < Object > finlist = new ArrayList < Object > ();
	    try {
	        int count = 0;
	        con = DBConnection.getConnectionToDB("AMS");
	        pstmt = con.prepareStatement(StaffTransportationSolutionStatements.GET_SHIFT_DETAILS);
	        pstmt.setInt(1, systemId);
	        pstmt.setInt(2, customerId);
	        rs = pstmt.executeQuery();
	        while (rs.next()) {
	            JsonObject = new JSONObject();
	            count++;
	            JsonObject.put("slnoIndex", count);
	          
	            JsonObject.put("ShiftIdDataIndex", rs.getInt("SHIFT_ID"));
	            JsonObject.put("ShiftNameIndex", rs.getString("SHIFT_NAME").toUpperCase());
	            
	            String departureTime = String.valueOf(df.format(rs.getFloat("START_TIME")));
	            if(!departureTime.contains(".")){
	            	if(departureTime.length()==0){
	            		departureTime = "0"+departureTime+".00";	
	            	}else{
	            	departureTime =departureTime+".00";
	            	}
	            }
	            if(departureTime.charAt(2)!='.'){
					departureTime = "0"+departureTime;
				}
				if(departureTime.length()<5){
					departureTime = departureTime+"0";
				}
				 departureTime = departureTime.replace(".", ":");
		            
	            JsonObject.put("StartTimeIndex", departureTime);
	            
	            String arrivalTime = String.valueOf(df.format(rs.getFloat("END_TIME")));
	            if(!arrivalTime.contains(".")){
	            	if(arrivalTime.length()==0){
	            		arrivalTime = "0"+arrivalTime+".00";	
	            	}else{
	            		arrivalTime =arrivalTime+".00";
	            	}
	            }
	            if(arrivalTime.charAt(2)!='.'){
	            	arrivalTime = "0"+arrivalTime;
				}
				if(arrivalTime.length()<5){
					arrivalTime = arrivalTime+"0";
				}
				 arrivalTime = arrivalTime.replace(".", ":");
					
	            JsonObject.put("EndTimeIndex", arrivalTime);
	            
	            JsonObject.put("statusIndex", rs.getString("STATUS"));
	            JsonObject.put("branchIndex", rs.getString("BRANCH"));
	            JsonObject.put("branchIDIndex", rs.getString("BRANCH_ID"));
	            
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
	
	
	public String deleteShiftDetails(int systemId,int custId,int shiftId)
	{
		Connection con = null;
		PreparedStatement pstmt= null;
		ResultSet rs = null;
		String message="";
		
		try
		{
			 con = DBConnection.getConnectionToDB("AMS");
			 pstmt = con.prepareStatement(StaffTransportationSolutionStatements.DELETE_SHIFT);			
			 pstmt.setInt(1, systemId);
			 pstmt.setInt(2, custId);
			 pstmt.setInt(3, shiftId);
			int i =0;
			i = pstmt.executeUpdate();
			 if(i>0)
			 {
				 message="Shift Deleted Successfully";
				 return message;
			 }else{
				 message="Shift Didn't Deleted!!";
			 }
			
		}
		 catch (Exception e)
		 {
			
				e.printStackTrace();
		 }      
		finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
	    }
		return message;
				
	}
	public String addShiftVehicleAsscDetails(String status,int systemId,int custId,int userId,JSONArray vehicle,JSONArray shift,int branch)
	{
		Connection con = null;
		PreparedStatement pstmt= null;
		ResultSet rs = null;
		String message="";
		
		try
		{
			con = DBConnection.getConnectionToDB("AMS");
	     for (int i = 0; i < vehicle.length(); i++) {
	    	 JSONObject obj = vehicle.getJSONObject(i);
	         String vehicleNo = obj.getString("VehicleNo");
	         String vehicleGroupId = obj.getString("VehicleGroupId");
	         String vehicleGroupName = obj.getString("VehicleGroupName");
	         			
			 for (int j = 0; j < shift.length(); j++) { 
				 JSONObject obj1 = shift.getJSONObject(j);
		         int shiftId = Integer.parseInt(obj1.getString("ShiftId"));	
		         
			 
			 pstmt = con.prepareStatement(StaffTransportationSolutionStatements.CHECK_VEHICLE_ALREADY_EXIST);
			 pstmt.setString(1, vehicleNo);
			 pstmt.setInt(2, systemId);
			 pstmt.setInt(3, custId);
			 pstmt.setInt(4, shiftId);
			 rs = pstmt.executeQuery();
			 if(!rs.next()){						
				 pstmt = con.prepareStatement(StaffTransportationSolutionStatements.CHECK_IS_ASSOCIATED_WITH_OTHER_BRANCH);
				 pstmt.setString(1, vehicleNo);
				 pstmt.setInt(2, systemId);
				 pstmt.setInt(3, custId);
				 pstmt.setInt(4, branch);
				 rs = pstmt.executeQuery();
			 if(!rs.next()){		  
			 pstmt = con.prepareStatement(StaffTransportationSolutionStatements.INSERT_ASSOCIATION);
			 pstmt.setString(1, vehicleNo);
			 pstmt.setInt(2, shiftId);
			 pstmt.setString(3, status);
			 pstmt.setInt(4, userId);
			 pstmt.setInt(5, systemId);
			 pstmt.setInt(6, custId);
			 pstmt.setInt(7, branch);
			 pstmt.setString(8, vehicleGroupId);
			 pstmt.setString(9, vehicleGroupName);
			 int inserted = pstmt.executeUpdate();
			if (inserted > 0) {
                  message = "Saved Successfully";
             }
			 }else{
				 message="This Vehicle Is Already Associated With Other Branch";	 
			 }
			}else{
				 message="This Vehicle Is Already Associated";	 
			 }
		  }
		 }
		}
		 catch (Exception e)
		 {
			
				e.printStackTrace();
		 }      
		finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
	    }
		return message;
				
	}
	public String modifyShiftVehicleAsscDetails(String vehicleNo,int shiftId,String status,int systemId,int custId,int userId,int asscId)
	{
		Connection con=null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		String message="";
		try
		{
			 con=DBConnection.getConnectionToDB("AMS");
			
			 pstmt = con.prepareStatement(StaffTransportationSolutionStatements.CHECK_VEHICLE_ALREADY_EXIST);
			 pstmt.setString(1, vehicleNo);
			 pstmt.setInt(2, systemId);
			 pstmt.setInt(3, custId);
			 pstmt.setInt(4, shiftId);
			 rs = pstmt.executeQuery(); 
			 if(!rs.next()){
			 pstmt=con.prepareStatement(StaffTransportationSolutionStatements.MODIFY_ASSOCIATION);
			 pstmt.setString(1, vehicleNo);
			 pstmt.setInt(2, shiftId);
			 pstmt.setString(3, status);
			 pstmt.setInt(4, userId);
			 pstmt.setInt(5, systemId);
			 pstmt.setInt(6, custId);
			 pstmt.setInt(7,asscId);
			int updated=pstmt.executeUpdate();
			if(updated>0)
			{
				message = "Updated Successfully";
			}
		}else{
			message = "Vehicle Already Associated";
		}
		}catch(Exception e)
		{
			e.printStackTrace();
		}
		finally
		{
			DBConnection.releaseConnectionToDB(con,pstmt,rs);
		}
		return message;
	}
	
	public ArrayList < Object > getShiftVehicleAsccDetails(int systemId, int customerId) {
	    JSONArray JsonArray = new JSONArray();
	    JSONObject JsonObject = null;
	    Connection con = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
	    ArrayList < Object > finlist = new ArrayList < Object > ();
	    try {
	        int count = 0;
	        con = DBConnection.getConnectionToDB("AMS");
	        pstmt = con.prepareStatement(StaffTransportationSolutionStatements.GET_ASSOCIATIONT_DETAILS);
	        pstmt.setInt(1, systemId);
	        pstmt.setInt(2, customerId);
	        rs = pstmt.executeQuery();
	        while (rs.next()) {
	            JsonObject = new JSONObject();
	            count++;

	            JsonObject.put("slnoIndex", count);
	          
	            JsonObject.put("AsscIdDataIndex", rs.getInt("ASSC_ID"));
	            JsonObject.put("VehicleNoDataIndex", rs.getString("VEHICLE_NUMBER").toUpperCase());
	            JsonObject.put("ShiftNameIndex", rs.getString("SHIFT_NAME").toUpperCase());
	            
	            
	            String departureTime = String.valueOf(df.format(rs.getFloat("START_TIME")));
	            if(!departureTime.contains(".")){
	            	if(departureTime.length()==0){
	            		departureTime = "0"+departureTime+".00";	
	            	}else{
	            	departureTime =departureTime+".00";
	            	}
	            }
	            if(departureTime.charAt(2)!='.'){
					departureTime = "0"+departureTime;
				}
				if(departureTime.length()<5){
					departureTime = departureTime+"0";
				}
				 departureTime = departureTime.replace(".", ":");
		            
	            JsonObject.put("StartTimeIndex", departureTime);
	            
	            String arrivalTime = String.valueOf(df.format(rs.getFloat("END_TIME")));
	            if(!arrivalTime.contains(".")){
	            	if(arrivalTime.length()==0){
	            		arrivalTime = "0"+arrivalTime+".00";	
	            	}else{
	            		arrivalTime =arrivalTime+".00";
	            	}
	            }
	            if(arrivalTime.charAt(2)!='.'){
	            	arrivalTime = "0"+arrivalTime;
				}
				if(arrivalTime.length()<5){
					arrivalTime = arrivalTime+"0";
				}
				 arrivalTime = arrivalTime.replace(".", ":");
					
	            JsonObject.put("EndTimeIndex", arrivalTime);
	            
	            JsonObject.put("statusIndex", rs.getString("STATUS"));
	            JsonObject.put("vehicleGroup", rs.getString("GROUP_NAME"));
	            JsonObject.put("branchIndex", rs.getString("BRANCH"));
	            JsonObject.put("branchIDIndex", rs.getString("BRANCH_ID"));
	            JsonObject.put("ShiftIdDataIndex", rs.getString("SHIFT_ID"));
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
	
	public JSONArray getVehicleNo(int systemId, int customerId) {
	    JSONArray JsonArray = new JSONArray();
	    JSONObject JsonObject = null;
	    Connection con = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
	    try {
	     
	        con = DBConnection.getConnectionToDB("AMS");
	        pstmt = con.prepareStatement(StaffTransportationSolutionStatements.GET_ALL_VEHICLES);
	        pstmt.setInt(1, systemId);
	        pstmt.setInt(2, customerId);
	        rs = pstmt.executeQuery();
	        while (rs.next()) {
	            JsonObject = new JSONObject();
	           
	            JsonObject.put("VehicleNo", rs.getString("VEHICLE_NO"));	          	            
	            JsonArray.put(JsonObject);
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	        DBConnection.releaseConnectionToDB(con, pstmt, rs);
	    }
	    return JsonArray;
	}
	
	public JSONArray getShiftNames(int systemId, int customerId) {
	    JSONArray JsonArray = new JSONArray();
	    JSONObject JsonObject = null;
	    Connection con = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
	    try {
	     
	        con = DBConnection.getConnectionToDB("AMS");
	        pstmt = con.prepareStatement(StaffTransportationSolutionStatements.GET_ALL_SHIFTS);
	        pstmt.setInt(1, systemId);
	        pstmt.setInt(2, customerId);
	        rs = pstmt.executeQuery();
	        while (rs.next()) {
	            JsonObject = new JSONObject();
	           
	            JsonObject.put("ShiftId", rs.getInt("SHIFT_ID"));
	            JsonObject.put("ShiftName", rs.getString("SHIFT_NAME"));
	            
	            String departureTime = String.valueOf(df.format(rs.getFloat("START_TIME")));
	            if(!departureTime.contains(".")){
	            	if(departureTime.length()==0){
	            		departureTime = "0"+departureTime+".00";	
	            	}else{
	            	departureTime =departureTime+".00";
	            	}
	            }
	            if(departureTime.charAt(2)!='.'){
					departureTime = "0"+departureTime;
				}
				if(departureTime.length()<5){
					departureTime = departureTime+"0";
				}
				 departureTime = departureTime.replace(".", ":");
		            
	            JsonObject.put("StartTime", departureTime);
	            
	            String arrivalTime = String.valueOf(df.format(rs.getFloat("END_TIME")));
	            if(!arrivalTime.contains(".")){
	            	if(arrivalTime.length()==0){
	            		arrivalTime = "0"+arrivalTime+".00";	
	            	}else{
	            		arrivalTime =arrivalTime+".00";
	            	}
	            }
	            if(arrivalTime.charAt(2)!='.'){
	            	arrivalTime = "0"+arrivalTime;
				}
				if(arrivalTime.length()<5){
					arrivalTime = arrivalTime+"0";
				}
				 arrivalTime = arrivalTime.replace(".", ":");
					
	            JsonObject.put("EndTime", arrivalTime);
	            
	            JsonArray.put(JsonObject);
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	        DBConnection.releaseConnectionToDB(con, pstmt, rs);
	    }
	    return JsonArray;
	}
	
	
	public String deleteAssociateDetails(int systemId,int custId,int asscId)
	{
		Connection con = null;
		PreparedStatement pstmt= null;
		ResultSet rs = null;
		String message="";
		
		try
		{
			 con = DBConnection.getConnectionToDB("AMS");
			 pstmt = con.prepareStatement(StaffTransportationSolutionStatements.DELETE_ASSOCIATION);			
			 pstmt.setInt(1, systemId);
			 pstmt.setInt(2, custId);
			 pstmt.setInt(3, asscId);
			int i =0;
			i = pstmt.executeUpdate();
			 if(i>0)
			 {
				 message="Association Deleted Successfully";
				 return message;
			 }else{
				 message="Association Didn't Deleted!!";
			 }
			
		}
		 catch (Exception e)
		 {
			
				e.printStackTrace();
		 }      
		finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
	    }
		return message;
				
	}
	
	public JSONArray getBranchName(int systemid,int clientid){

		JSONArray jsonArray = new JSONArray(); 
		Connection con=null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;

		try{
			con = DBConnection.getConnectionToDB("AMS");
			pstmt=con.prepareStatement(StaffTransportationSolutionStatements.GET_BRANCH_NAME);
			pstmt.setInt(1, systemid);
			pstmt.setInt(2, clientid);
			rs=pstmt.executeQuery();
			JSONObject obj1 = new JSONObject();		
			while(rs.next()){
				obj1 = new JSONObject();
				obj1.put("BranchId",rs.getString("BranchId"));
				obj1.put("BranchName",rs.getString("BranchName"));
				jsonArray.put(obj1);
			}
		}
		catch(Exception e){
			e.printStackTrace();
		}
		finally{
			DBConnection.releaseConnectionToDB(con,pstmt,rs);
		}
		return jsonArray;  
	}
	public JSONArray getShiftNamesByBranch(int systemId, int customerId,int branchId) {
	    JSONArray JsonArray = new JSONArray();
	    JSONObject JsonObject = null;
	    Connection con = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
	    try {
	     
	        con = DBConnection.getConnectionToDB("AMS");
	        pstmt = con.prepareStatement(StaffTransportationSolutionStatements.GET_ALL_SHIFTS_BRANCH);
	        pstmt.setInt(1, systemId);
	        pstmt.setInt(2, customerId);
	        pstmt.setInt(3, branchId);
	        rs = pstmt.executeQuery();
	        while (rs.next()) {
	            JsonObject = new JSONObject();
	           
	            JsonObject.put("ShiftId", rs.getInt("SHIFT_ID"));
	            JsonObject.put("ShiftName", rs.getString("SHIFT_NAME"));
	            
	        	 String departureTime = String.valueOf(df.format(rs.getFloat("START_TIME")));
		            if(!departureTime.contains(".")){
		            	if(departureTime.length()==0){
		            		departureTime = "0"+departureTime+".00";	
		            	}else{
		            	departureTime =departureTime+".00";
		            	}
		            }
		            if(departureTime.charAt(2)!='.'){
						departureTime = "0"+departureTime;
					}
					if(departureTime.length()<5){
						departureTime = departureTime+"0";
					}
					 departureTime = departureTime.replace(".", ":");
			            
		            String arrivalTime = String.valueOf(df.format(rs.getFloat("END_TIME")));
		            if(!arrivalTime.contains(".")){
		            	if(arrivalTime.length()==0){
		            		arrivalTime = "0"+arrivalTime+".00";	
		            	}else{
		            		arrivalTime =arrivalTime+".00";
		            	}
		            }
		            if(arrivalTime.charAt(2)!='.'){
		            	arrivalTime = "0"+arrivalTime;
					}
					if(arrivalTime.length()<5){
						arrivalTime = arrivalTime+"0";
					}
					arrivalTime = arrivalTime.replace(".", ":");
	            	            
	            JsonObject.put("StartTime", departureTime);
	            JsonObject.put("EndTime", arrivalTime);
	           	        
	            JsonArray.put(JsonObject);
	        }
	        JSONObject JsonObject2 = new JSONObject();
	           
	        JsonObject2.put("ShiftId", 999);
	        JsonObject2.put("ShiftName", "ALL");
	        JsonObject2.put("StartTime", "00:00");
            JsonObject2.put("EndTime", "00:00");
        
            JsonArray.put(JsonObject2); 
	    } catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	        DBConnection.releaseConnectionToDB(con, pstmt, rs);
	    }
	    return JsonArray;
	}

	public ArrayList < Object > getViewDetails(int systemId, int customerId,int branchId,int shiftId,String date,String eDate,int offset,String buttonValue) {
	
	    JSONArray JsonArray = new JSONArray();
	    JSONObject JsonObject = null;
	    Connection con = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
	    Date startdate = null;
        Date endDate =null;		
        float shiftStartTime = 0.0f;
        float shiftEndTime = 0.0f;
	    ArrayList < ReportHelper > reportsList = new ArrayList < ReportHelper > ();
		ArrayList < String > headersList = new ArrayList < String > ();
		ReportHelper finalreporthelper = new ReportHelper();
		ArrayList < Object > finlist = new ArrayList < Object > ();
		ArrayList < Object > informationList = null;
		ReportHelper reporthelper = null;
		 headersList.add("SLNO");
		 headersList.add("Vehicle No");
		 //headersList.add("Vehicle Id");
		// headersList.add("Group Name");
		 headersList.add("No Of Trips");
		 headersList.add("Total Kms Travelled");
		 headersList.add("Average Kms");
		 headersList.add("Total Duration");
		 headersList.add("Average Duration");
		 headersList.add("Odometer");
		 headersList.add("Last Known Time");
		 headersList.add("Trip Duration");
		 headersList.add("Max Speed");
		 headersList.add("Speed Limit");
		 headersList.add("OS Count");
		 headersList.add("HA Count");
		 headersList.add("HB Count");
		 headersList.add("Idle Count");
		 headersList.add("SeatBelt Alert");
		 headersList.add("Idle Duration");
		 headersList.add("Path OS Duration");
		 headersList.add("Path OS Count");
		 
	    try {
	        int count = 0;
	        String vehicleNo="";
	        String vehicleId = "";
	        String groupName ="";	   
	        Date rStartDate=null;
	        Date rEndDate=null;
            ArrayList<String> dates = new ArrayList<String>();
	        con = DBConnection.getConnectionToDB("AMS");
	        if(buttonValue.equalsIgnoreCase("DateWise")){

	        	java.util.Date dateE =null;
	        	java.util.Date dateS = null;
	            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

   						date = AddOffsetToGmt(date, offset);
   						dateS = sdf.parse(date);		
	
   						eDate = AddOffsetToGmt(eDate, offset);
    					dateE = sdf.parse(eDate);	
    						
    				startdate = dateS;
    				endDate = dateE;   				
	        		shiftId = 999;
	        }
	        if(buttonValue.equalsIgnoreCase("ShiftWise")){
	        if(shiftId == 999){
	        	java.util.Date dateE =null;
	        	java.util.Date dateS = null;

	        	pstmt = con.prepareStatement(StaffTransportationSolutionStatements.SELECT_ALL_SHIFT_TIMINGS1);
				 pstmt.setInt(1, systemId);
				 pstmt.setInt(2, customerId);
				 pstmt.setInt(3, branchId);	
				 rs = pstmt.executeQuery();
			        if(rs.next()){
			        		
   					 String departureTime = String.valueOf(df.format(rs.getFloat("START_TIME")));
   			            if(!departureTime.contains(".")){
   			            	if(departureTime.length()==0){
   			            		departureTime = "0"+departureTime+".00";	
   			            	}else{
   			            	departureTime =departureTime+".00";
   			            	}
   			            }
   			            if(departureTime.charAt(2)!='.'){
   							departureTime = "0"+departureTime;
   						}
   						if(departureTime.length()<5){
   							departureTime = departureTime+"0";
   						}
   						 departureTime = departureTime.replace(".", ":");
   						 
   						date = date+" "+departureTime+":00";

   						date = AddOffsetToGmt(date, offset);
   		        		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
   						dateS = sdf.parse(date);		
   						
			        }
   					 pstmt = con.prepareStatement(StaffTransportationSolutionStatements.SELECT_ALL_SHIFT_TIMINGS);
					 pstmt.setInt(1, systemId);
					 pstmt.setInt(2, customerId);
    				 pstmt.setInt(3, branchId);
    				 rs = pstmt.executeQuery();
    				 if(rs.next()){
     					
    					 String departureTime2 = String.valueOf(df.format(rs.getFloat("START_TIME")));
    			            if(!departureTime2.contains(".")){
    			            	if(departureTime2.length()==0){
    			            		departureTime2 = "0"+departureTime2+".00";	
    			            	}else{
    			            	departureTime2 =departureTime2+".00";
    			            	}
    			            }
    			            if(departureTime2.charAt(2)!='.'){
    							departureTime2 = "0"+departureTime2;
    						}
    						if(departureTime2.length()<5){
    							departureTime2 = departureTime2+"0";
    						}
    						 departureTime2 = departureTime2.replace(".", ":");
    						 
    						 eDate = eDate+" "+departureTime2+":00";
    					 
    				   		shiftStartTime = Float.parseFloat(df.format(rs.getFloat("START_TIME")));
    				    	shiftEndTime = Float.parseFloat(df.format(rs.getFloat("END_TIME")));

    				    	float duration = 0.0f;
    		        		
    		        		if(shiftEndTime>shiftStartTime){
    		        		duration =  (shiftEndTime - shiftStartTime);
    		        		}else{
    		        			float s1 = 24-shiftStartTime;
    		        			duration =  s1+shiftEndTime;
    		        			
    		        		}
    		        		String durationS = String.valueOf(duration);
    		        		durationS = durationS.replace(".", ",");
    		        		String ds[] = durationS.split(",");
    		        		String d1 = ds[0];
    		        		String d2 = ds[1];
    		        		int duration2 = (Integer.parseInt(d1)*60)+Integer.parseInt(d2);
    		        		//System.out.println(" duration ======= "+duration);

    		        		SimpleDateFormat sdf2 = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
    						java.util.Date dateS2 = sdf2.parse(eDate);		
    						//System.out.println(" dateS ====== "+dateS2);
    						dateE = AddDurationToGmt(dateS2,  duration2);
    						String date2 = sdf2.format(dateE);
    						//System.out.println(" end  date ======= "+date2); 
    						date2 = AddOffsetToGmt(date2, offset);
    						dateE = sdf2.parse(date2);	
    						//System.out.println(" dateE ====== "+dateE);
    				 }
	
    				startdate = dateS;
    				endDate = dateE;
    				//System.out.println("startdate="+startdate);
	        		//System.out.println("endDate="+endDate);
		        	 
	        } else {
	        pstmt = con.prepareStatement(StaffTransportationSolutionStatements.GET_SHIFT_DETAILS2);
	        pstmt.setInt(1, systemId);
	        pstmt.setInt(2, customerId);
	        pstmt.setInt(3, shiftId);
	        rs = pstmt.executeQuery();
	        if(rs.next()){
	        	shiftStartTime = Float.parseFloat(df.format(rs.getFloat("START_TIME")));
	        	 String departureTime = String.valueOf(df.format(rs.getFloat("START_TIME")));
		            if(!departureTime.contains(".")){
		            	if(departureTime.length()==0){
		            		departureTime = "0"+departureTime+".00";	
		            	}else{
		            	departureTime =departureTime+".00";
		            	}
		            }
		            if(departureTime.charAt(2)!='.'){
						departureTime = "0"+departureTime;
					}
					if(departureTime.length()<5){
						departureTime = departureTime+"0";
					}
					 departureTime = departureTime.replace(".", ":");
			            
					 shiftEndTime = Float.parseFloat(df.format(rs.getFloat("END_TIME")));
		            String arrivalTime = String.valueOf(df.format(rs.getFloat("END_TIME")));
		            if(!arrivalTime.contains(".")){
		            	if(arrivalTime.length()==0){
		            		arrivalTime = "0"+arrivalTime+".00";	
		            	}else{
		            		arrivalTime =arrivalTime+".00";
		            	}
		            }
		            if(arrivalTime.charAt(2)!='.'){
		            	arrivalTime = "0"+arrivalTime;
					}
					if(arrivalTime.length()<5){
						arrivalTime = arrivalTime+"0";
					}
					arrivalTime = arrivalTime.replace(".", ":");
					
					SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
					java.util.Date dateS = sdf.parse(date);
		   		 	java.util.Date dateE = sdf.parse(eDate);		   		 	
		   	       			
		   			long interval = 24*1000 * 60 * 60; 
		   			long endTime = dateE.getTime() ; 
		   			long curTime = dateS.getTime();
		   			
		   			while (curTime <= endTime){		   				
		   				dates.add(AddOffsetToGmt(sdf.format(new Date(curTime))+" "+departureTime+":00",offset));
		   				dates.add(AddOffsetToGmt(sdf.format(new Date(curTime))+" "+arrivalTime+":00",offset));		   				
		   			    curTime += interval;
		   			} 
	        }
	        }
	    }
	        
	        if(shiftId == 999){
	        	pstmt = con.prepareStatement(StaffTransportationSolutionStatements.GET_VEHICLE_NOS2);
		        pstmt.setInt(1, systemId);
		        pstmt.setInt(2, customerId);
		        pstmt.setInt(3, branchId);	
	        }else{
	        pstmt = con.prepareStatement(StaffTransportationSolutionStatements.GET_VEHICLE_NOS);
	        pstmt.setInt(1, systemId);
	        pstmt.setInt(2, customerId);
	        pstmt.setInt(3, branchId);
	        pstmt.setInt(4, shiftId);
	        }
	        rs = pstmt.executeQuery();
	        Map<String,  ArrayList < String >> VehicleMap=new HashMap<String,  ArrayList < String >> ();
	        while (rs.next()) {	        	
	        	ArrayList<String> pmr = new ArrayList<String>();
	        	pmr.add(rs.getString("ODOMETER"));
	        	pmr.add(rs.getString("VEHICLE_ID"));
	        	pmr.add(rs.getString("GROUP_NAME"));
	        	VehicleMap.put(rs.getString("VEHICLE_NUMBER"), pmr);	        	
	        }
	        Map<String, ArrayList<String>> map = new TreeMap<String, ArrayList<String>>(VehicleMap);
	        VehicleMap =  map;
	    	if(shiftId == 999){
	    		int totalNoOfTrips=0;
	            int totalIdleCount=0;
	            double totKmsTravelled=0;
	            double totalOdometer=0;
	            long totalidleDuration=(long) 0.0;
	            long totalTripDur=(long) 0.0;
	            long duarationTotal=(long) 0.0;
	            int totalOScount =0;
	            int totalHAcount = 0;
	            int totalHBcount = 0;
	            int totalSBAlertCount = 0;

		        for (Entry<String, ArrayList<String>> entry : VehicleMap.entrySet()) {
		        	count++;
		        	int noOfTrips =0;
			        double totalKmsTravelled =0.0;
			        double avrageKms =0.0;
			        long totalDuration =(long)0.0;
			        long avrageDuration =(long) 0.0;
			        double odometer =0.0;	          
		            String lastKnwonTime ="";
		            long tripDuration =(long) 0.0;
		            long idleDuration =(long) 0.0;
		            String maxSpeed = "";
		            String speedLimit = "";
		            int OScount =0;
		            int HAcount = 0;
		            int HBcount = 0;
		            int idleCount = 0;
		            int SBAlertCount = 0;
		            
		        	JsonObject = new JSONObject();
		        	informationList = new ArrayList < Object > ();	        
					ArrayList<String> innerList = new ArrayList<String>();
					ArrayList<String> vehicleData = new ArrayList<String>();
					reporthelper = new ReportHelper();
					
					vehicleNo=entry.getKey();
					vehicleData=entry.getValue();
					odometer=Double.parseDouble(vehicleData.get(0));
					vehicleId=vehicleData.get(1);
					groupName=vehicleData.get(2);
		        					
		        		innerList = gerVehicleDetails(con,vehicleNo,startdate,endDate,offset,systemId,customerId,0,shiftId,branchId);
		        		noOfTrips+=Integer.parseInt(innerList.get(0));
		        		totalKmsTravelled +=Double.parseDouble(innerList.get(1)); 
		        		totalDuration += Long.parseLong(innerList.get(2));
		        		lastKnwonTime=innerList.get(3);
		           		tripDuration += Long.parseLong(innerList.get(4));
			            maxSpeed = innerList.get(5);
			            speedLimit = innerList.get(6);
			            OScount+= Integer.parseInt(innerList.get(7));
			            HAcount += Integer.parseInt(innerList.get(8));
			            HBcount += Integer.parseInt(innerList.get(9));
			            idleCount += Integer.parseInt(innerList.get(10));
			            SBAlertCount += Integer.parseInt(innerList.get(11));
			            idleDuration += Long.parseLong(innerList.get(12));
			         
			    	informationList.add(count);
					JsonObject.put("slnoIndex", count);
					
					informationList.add(vehicleNo);
					JsonObject.put("vehicleNoDataIndex", vehicleNo);				
					
					//informationList.add(vehicleId);
					JsonObject.put("vehicleIdDataIndex", vehicleId);
					
					//informationList.add(groupName);
					JsonObject.put("GroupNameDataIndex", groupName);
				
					informationList.add(noOfTrips);
					JsonObject.put("NoOfTripsDataIndex", noOfTrips);				
					
					totalKmsTravelled = Double.parseDouble(df.format(totalKmsTravelled));
					informationList.add(totalKmsTravelled);
					JsonObject.put("TotalKmsTravelledDataIndex", totalKmsTravelled);
					
					if(noOfTrips!=0){
						avrageKms = totalKmsTravelled/noOfTrips;
					}else{
						avrageKms	= totalKmsTravelled;
					}
					avrageKms = Double.parseDouble(df.format(avrageKms));
					informationList.add(avrageKms);
					JsonObject.put("AvrageKmPerTripDataIndex", avrageKms);				
					
				
					String totdur = AddTime(totalDuration);//PNJ

					informationList.add(totdur);
					JsonObject.put("TotalDurationDataIndex", totdur);
					
					if(noOfTrips!=0){
						avrageDuration = totalDuration/noOfTrips;	
					}else{
						avrageDuration = totalDuration;
					}
					
					String totavdur = formattedHoursMinutes(avrageDuration);
					
					informationList.add(totavdur);
					JsonObject.put("AvrageDurationDatIndex",totavdur);
					
					//odometer = Double.parseDouble(innerList.get(3));
					odometer =Double.parseDouble(df.format(odometer)); 
					informationList.add(odometer);
					JsonObject.put("OdometerDataIndex", odometer);
					
					JsonObject.put("LastKnownDateDataIndex", lastKnwonTime);
					informationList.add(lastKnwonTime);
					
					String tripdur = AddTime(tripDuration);
					
					JsonObject.put("tripDurationIndex",tripdur );
					informationList.add(tripdur);
					
					JsonObject.put("maxSpeedIndex", maxSpeed);
					informationList.add(maxSpeed);
					
					JsonObject.put("speedLimitIndex", speedLimit);
					informationList.add(speedLimit);
					
					JsonObject.put("OSCountIndex", OScount);
					informationList.add(OScount);
					
					JsonObject.put("HACountIndex", HAcount);
					informationList.add(HAcount);
					
					JsonObject.put("HBCountIndex", HBcount);
					informationList.add(HBcount);
					
					JsonObject.put("IdleCountIndex", idleCount);
					informationList.add(idleCount);
					
					JsonObject.put("SeatBeltCountIndex", SBAlertCount);
					informationList.add(SBAlertCount);
					
					String idledur = AddTime(idleDuration);
					
					JsonObject.put("IdledurationIndex",idledur);
					informationList.add(idledur);
					
					JsonObject.put("PathOSdurationIndex", "");
					informationList.add("");
					
					JsonObject.put("PathOSCountIndex", "");
					informationList.add("");
				
					JsonObject.put("startDateTimeIndex", ddmmyyyyhhmmss.format(AddDurationToGmt(startdate,offset)));
					
					JsonObject.put("endDateTimeIndex", ddmmyyyyhhmmss.format(AddDurationToGmt(endDate,offset)));
					
					JsonArray.put(JsonObject);
		            reporthelper.setInformationList(informationList);
		            reportsList.add(reporthelper);
		            
		            totalNoOfTrips=totalNoOfTrips+noOfTrips;
		            totKmsTravelled=totKmsTravelled+totalKmsTravelled;
		            totalOdometer=totalOdometer+odometer;
		            totalidleDuration=totalidleDuration+idleDuration;
		            totalIdleCount=totalIdleCount+idleCount;
		            totalTripDur=totalTripDur+tripDuration;
		            duarationTotal=duarationTotal+totalDuration;
		            totalOScount =totalOScount+OScount;
		            totalHAcount = totalHAcount+HAcount;
		            totalHBcount = totalHBcount+HBcount;
		            totalSBAlertCount = totalSBAlertCount+SBAlertCount;
		        }
		        
		        JsonObject = new JSONObject();
		        ArrayList < Object >  informationList1 = new ArrayList < Object > ();	  
		        reporthelper = new ReportHelper();
		        count++;
		        informationList1.add(count);
				JsonObject.put("slnoIndex", count);
				
				informationList1.add("TOTAL");
				JsonObject.put("vehicleNoDataIndex", "<B>"+"TOTAL"+"</B>");				
				
				//informationList.add(vehicleId);
				JsonObject.put("vehicleIdDataIndex", "");
				
				//informationList.add(groupName);
				JsonObject.put("GroupNameDataIndex", "");
			
				informationList1.add(totalNoOfTrips);
				JsonObject.put("NoOfTripsDataIndex", "<B>"+totalNoOfTrips+"</B>");				
				
				informationList1.add(df.format(totKmsTravelled));
				JsonObject.put("TotalKmsTravelledDataIndex", "<B>"+df.format(totKmsTravelled)+"</B>");
				
				informationList1.add("");
				JsonObject.put("AvrageKmPerTripDataIndex", "");				

				String totDuration=AddTime(duarationTotal);
				informationList1.add(totDuration);
				JsonObject.put("TotalDurationDataIndex", "<B>"+totDuration+"</B>");
				
				informationList1.add("");
				JsonObject.put("AvrageDurationDatIndex","");
				
				informationList1.add(df.format(totalOdometer));
				JsonObject.put("OdometerDataIndex", "<B>"+df.format(totalOdometer)+"</B>");
				
				JsonObject.put("LastKnownDateDataIndex", "");
				informationList1.add("");
				
				String totalTripDuration = AddTime(totalTripDur);
				JsonObject.put("tripDurationIndex","<B>"+totalTripDuration+"</B>");
				informationList1.add(totalTripDuration);
				
				JsonObject.put("maxSpeedIndex", "");
				informationList1.add("");
				
				JsonObject.put("speedLimitIndex", "");
				informationList1.add("");
				
				JsonObject.put("OSCountIndex", "<B>"+totalOScount+"</B>");
				informationList1.add(totalOScount);
				
				JsonObject.put("HACountIndex", "<B>"+totalHAcount+"</B>");
				informationList1.add(totalHAcount);
				
				JsonObject.put("HBCountIndex", "<B>"+totalHBcount+"</B>");
				informationList1.add(totalHBcount);
				
				JsonObject.put("IdleCountIndex", "<B>"+totalIdleCount+"</B>");
				informationList1.add(totalIdleCount);
				
				JsonObject.put("SeatBeltCountIndex", "<B>"+totalSBAlertCount+"</B>");
				informationList1.add(totalSBAlertCount);
				
				String totalIdelDur = AddTime(totalidleDuration);
				JsonObject.put("IdledurationIndex","<B>"+totalIdelDur+"</B>");
				informationList1.add(totalIdelDur);
				
				JsonObject.put("PathOSdurationIndex", "");
				informationList1.add("");
				
				JsonObject.put("PathOSCountIndex", "");
				informationList1.add("");
	        
				JsonArray.put(JsonObject);
	            reporthelper.setInformationList(informationList1);
	            reportsList.add(reporthelper);
		    
	    	}else{
	    		  
				ArrayList<String> innerList = new ArrayList<String>();
				ArrayList<String> vehicleData = new ArrayList<String>();
				int totalNoOfTrips=0;
	            int totalIdleCount=0;
	            double totKmsTravelled=0;
	            double totalOdometer=0;
	            long totalidleDuration=(long) 0.0;
	            long totalTripDur=(long) 0.0;
	            long duarationTotal=(long) 0.0;
	            int totalOScount =0;
	            int totalHAcount = 0;
	            int totalHBcount = 0;
	            int totalSBAlertCount = 0;
	            
	        for (Entry<String, ArrayList<String>> entry : VehicleMap.entrySet()) {
	        	count++;
	        	int noOfTrips =0;
		        double totalKmsTravelled =0.0;
		        double avrageKms =0.0;
		        long totalDuration =(long) 0.0;
		        long avrageDuration =(long) 0.0;
		        double odometer =0.0;	          
	            String lastKnwonTime ="";
	            long tripDuration =(long) 0.0;
	            long idleDuration =(long) 0.0;
	            String maxSpeed = "";
	            String speedLimit = "";
	            int OScount =0;
	            int HAcount = 0;
	            int HBcount = 0;
	            int idleCount = 0;
	            int SBAlertCount = 0;
	            
	        	JsonObject = new JSONObject();
	        	informationList = new ArrayList < Object > ();	    
	        	reporthelper = new ReportHelper();
				vehicleNo=entry.getKey();
				vehicleData=entry.getValue();
				odometer=Double.parseDouble(vehicleData.get(0));
				vehicleId=vehicleData.get(1);
				groupName=vehicleData.get(2);
	        	for (int j = 0; j < dates.size()-1; j=j+2) {
	        		startdate = yyyymmdd.parse(dates.get(j));
	        		endDate = yyyymmdd.parse(dates.get(j+1));
	        		float duration = 0.0f;
	        		
	        		if(shiftEndTime>shiftStartTime){
	        		duration =  (shiftEndTime - shiftStartTime);
	        		}else{
	        			float s1 = 24-shiftStartTime;
	        			duration =  s1+shiftEndTime;
	        		}
	        		String durationS = String.valueOf(duration);
	        		durationS = durationS.replace(".", ",");
	        		String ds[] = durationS.split(",");
	        		String d1 = ds[0];
	        		String d2 = ds[1];
	        		int duration2 = (Integer.parseInt(d1)*60)+Integer.parseInt(d2);
	        		endDate = AddDurationToGmt(startdate,  duration2);
	        		if(dates.size()>2){
	        			if(j==0){
	        				rStartDate=startdate;
	        			}else {
	        				rEndDate=endDate;
	        			}
	        		}else{
	        			rStartDate = startdate;
	        			rEndDate = endDate;
	        		}
	        		innerList = gerVehicleDetails(con,vehicleNo,startdate,endDate,offset,systemId,customerId,0,shiftId,branchId);
	        		noOfTrips+=Integer.parseInt(innerList.get(0));
	        		totalKmsTravelled +=Double.parseDouble(innerList.get(1)); 
	        		totalDuration += Long.parseLong(innerList.get(2));
	        		lastKnwonTime=innerList.get(3);
	        		tripDuration += Long.parseLong(innerList.get(4));
		            maxSpeed = innerList.get(5);
		            speedLimit = innerList.get(6);
		            OScount+= Integer.parseInt(innerList.get(7));
		            HAcount += Integer.parseInt(innerList.get(8));
		            HBcount += Integer.parseInt(innerList.get(9));
		            idleCount += Integer.parseInt(innerList.get(10));
		            SBAlertCount += Integer.parseInt(innerList.get(11));
		            idleDuration += Long.parseLong(innerList.get(12));
		            
				}
	        	
		    	informationList.add(count);
				JsonObject.put("slnoIndex", count);
				
				informationList.add(vehicleNo);
				JsonObject.put("vehicleNoDataIndex", vehicleNo);				
				
				//informationList.add(vehicleId);
				JsonObject.put("vehicleIdDataIndex", vehicleId);
				
				//informationList.add(groupName);
				JsonObject.put("GroupNameDataIndex", groupName);
			
				informationList.add(noOfTrips);
				JsonObject.put("NoOfTripsDataIndex", noOfTrips);				
				
				totalKmsTravelled = Double.parseDouble(df.format(totalKmsTravelled));
				informationList.add(totalKmsTravelled);
				JsonObject.put("TotalKmsTravelledDataIndex", totalKmsTravelled);
				
				if(noOfTrips!=0){
					avrageKms = totalKmsTravelled/noOfTrips;
				}else{
					avrageKms	= totalKmsTravelled;
				}
				avrageKms = Double.parseDouble(df.format(avrageKms));
				informationList.add(avrageKms);
				JsonObject.put("AvrageKmPerTripDataIndex", avrageKms);				
				
				
				//String totdur = formattedHoursMinutes(totalDuration);
				String totdur = AddTime(totalDuration);//PNJ

				informationList.add(totdur);
				JsonObject.put("TotalDurationDataIndex", totdur);
				
				if(noOfTrips!=0){
					avrageDuration = totalDuration/noOfTrips;	
				}else{
					avrageDuration = totalDuration;
				}
				
				String totavdur = formattedHoursMinutes(avrageDuration);
				
				informationList.add(totavdur);
				JsonObject.put("AvrageDurationDatIndex",totavdur);
				
				odometer =Double.parseDouble(df.format(odometer)); 
				informationList.add(odometer);
				JsonObject.put("OdometerDataIndex", odometer);
				
				JsonObject.put("LastKnownDateDataIndex", lastKnwonTime);
				informationList.add(lastKnwonTime);
				
				String tripdur = AddTime(tripDuration);
				
				JsonObject.put("tripDurationIndex",tripdur );
				informationList.add(tripdur);
				
				JsonObject.put("maxSpeedIndex", maxSpeed);
				informationList.add(maxSpeed);
				
				JsonObject.put("speedLimitIndex", speedLimit);
				informationList.add(speedLimit);
				
				JsonObject.put("OSCountIndex", OScount);
				informationList.add(OScount);
				
				JsonObject.put("HACountIndex", HAcount);
				informationList.add(HAcount);
				
				JsonObject.put("HBCountIndex", HBcount);
				informationList.add(HBcount);
				
				JsonObject.put("IdleCountIndex", idleCount);
				informationList.add(idleCount);
				
				JsonObject.put("SeatBeltCountIndex", SBAlertCount);
				informationList.add(SBAlertCount);
				
				String idledur = AddTime(idleDuration);
				
				JsonObject.put("IdledurationIndex",idledur);
				informationList.add(idledur);
				
				JsonObject.put("PathOSdurationIndex", "");
				informationList.add("");
				
				JsonObject.put("PathOSCountIndex", "");
				informationList.add("");
				
				JsonObject.put("startDateTimeIndex", ddmmyyyyhhmmss.format(AddDurationToGmt(rStartDate,offset)));
				
				JsonObject.put("endDateTimeIndex", ddmmyyyyhhmmss.format(AddDurationToGmt(rEndDate,offset)));
				
				JsonArray.put(JsonObject);
	            reporthelper.setInformationList(informationList);
	            reportsList.add(reporthelper);
	            
	            totalNoOfTrips=totalNoOfTrips+noOfTrips;
	            totKmsTravelled=totKmsTravelled+totalKmsTravelled;
	            totalOdometer=totalOdometer+odometer;
	            totalidleDuration=totalidleDuration+idleDuration;
	            totalIdleCount=totalIdleCount+idleCount;
	            totalTripDur=totalTripDur+tripDuration;
	            duarationTotal=duarationTotal+totalDuration;
	            totalOScount =totalOScount+OScount;
	            totalHAcount = totalHAcount+HAcount;
	            totalHBcount = totalHBcount+HBcount;
	            totalSBAlertCount = totalSBAlertCount+SBAlertCount;
	        }
	        
	        JsonObject = new JSONObject();
	        ArrayList < Object >  informationList1 = new ArrayList < Object > ();	  
	        reporthelper = new ReportHelper();
	        count++;
	        informationList1.add(count);
			JsonObject.put("slnoIndex", count);
			
			informationList1.add("TOTAL");
			JsonObject.put("vehicleNoDataIndex", "<B>"+"TOTAL"+"</B>");				
			
			//informationList.add(vehicleId);
			JsonObject.put("vehicleIdDataIndex", "");
			
			//informationList.add(groupName);
			JsonObject.put("GroupNameDataIndex", "");
		
			informationList1.add(totalNoOfTrips);
			JsonObject.put("NoOfTripsDataIndex", "<B>"+totalNoOfTrips+"</B>");				
			
			informationList1.add(df.format(totKmsTravelled));
			JsonObject.put("TotalKmsTravelledDataIndex", "<B>"+df.format(totKmsTravelled)+"</B>");
			
			informationList1.add("");
			JsonObject.put("AvrageKmPerTripDataIndex", "");				

			String totDuration=AddTime(duarationTotal);
			informationList1.add(totDuration);
			JsonObject.put("TotalDurationDataIndex", "<B>"+totDuration+"</B>");
			
			informationList1.add("");
			JsonObject.put("AvrageDurationDatIndex","");
			
			informationList1.add(df.format(totalOdometer));
			JsonObject.put("OdometerDataIndex", "<B>"+df.format(totalOdometer)+"</B>");
			
			JsonObject.put("LastKnownDateDataIndex", "");
			informationList1.add("");
			
			String totalTripDuration = AddTime(totalTripDur);
			JsonObject.put("tripDurationIndex","<B>"+totalTripDuration+"</B>");
			informationList1.add(totalTripDuration);
			
			JsonObject.put("maxSpeedIndex", "");
			informationList1.add("");
			
			JsonObject.put("speedLimitIndex", "");
			informationList1.add("");
			
			JsonObject.put("OSCountIndex", "<B>"+totalOScount+"</B>");
			informationList1.add(totalOScount);
			
			JsonObject.put("HACountIndex", "<B>"+totalHAcount+"</B>");
			informationList1.add(totalHAcount);
			
			JsonObject.put("HBCountIndex", "<B>"+totalHBcount+"</B>");
			informationList1.add(totalHBcount);
			
			JsonObject.put("IdleCountIndex", "<B>"+totalIdleCount+"</B>");
			informationList1.add(totalIdleCount);
			
			JsonObject.put("SeatBeltCountIndex", "<B>"+totalSBAlertCount+"</B>");
			informationList1.add(totalSBAlertCount);
			
			String totalIdelDur = AddTime(totalidleDuration);
			JsonObject.put("IdledurationIndex","<B>"+totalIdelDur+"</B>");
			informationList1.add(totalIdelDur);
			
			JsonObject.put("PathOSdurationIndex", "");
			informationList1.add("");
			
			JsonObject.put("PathOSCountIndex", "");
			informationList1.add("");
        
			JsonArray.put(JsonObject);
            reporthelper.setInformationList(informationList1);
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
	
	public JSONArray getVehicleGroup(int systemid,int clientid){

		JSONArray jsonArray = new JSONArray(); 
		Connection con=null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;

		try{
			con = DBConnection.getConnectionToDB("AMS");
			pstmt=con.prepareStatement(StaffTransportationSolutionStatements.GET_VEHICLE_GROUP_FROM_SHIFT_MASTER);
			pstmt.setInt(1, systemid);
			pstmt.setInt(2, clientid);
			rs=pstmt.executeQuery();
			JSONObject obj1 = new JSONObject();		
			while(rs.next()){
				obj1 = new JSONObject();
				obj1.put("GroupId",rs.getString("GROUP_ID"));
				obj1.put("GroupName",rs.getString("GROUP_NAME"));
				jsonArray.put(obj1);
			}
		}
		catch(Exception e){
			e.printStackTrace();
		}
		finally{
			DBConnection.releaseConnectionToDB(con,pstmt,rs);
		}
		return jsonArray;  
	} 
	
	
	public ArrayList < Object > getStaffActivitySummaryDetails(int systemId, int customerId,int groupId,String date,String eDate,int offset, int userId) {
		
	     JSONArray JsonArray = new JSONArray();
	     JSONObject JsonObject = null;
	     Connection con = null;
	     PreparedStatement pstmt = null;
	     ResultSet rs = null;
	     ArrayList < ReportHelper > reportsList = new ArrayList < ReportHelper > ();
		 ArrayList < String > headersList = new ArrayList < String > ();
		 ReportHelper finalreporthelper = new ReportHelper();
		 ArrayList < Object > finlist = new ArrayList < Object > ();
		 
		int haCount = 0;
     	int hbCount = 0;
		 
		 headersList.add("SLNO");
		 headersList.add("Vehicle No");
		 headersList.add("Days Used");
		 headersList.add("Trip Duration");
		 headersList.add("Distance");
		 headersList.add("Max Speed");
		 headersList.add("Speed Limit");
		 headersList.add("OS Count");
		 headersList.add("HA Count");
		 headersList.add("HB Count");
		 headersList.add("Idle Count");
		 headersList.add("SeatBelt Alert");
		 headersList.add("Idle Duration");
		 headersList.add("OS Duration");
		 headersList.add("Total Duration");
		 headersList.add("Last Comm Date");
		 headersList.add("Last Odo Reading");
		 
		
	    try {
	        
	    	con = DBConnection.getConnectionToDB("AMS");
	    	int count=0;
			JsonObject = new JSONObject();
			ReportHelper reporthelper = new ReportHelper();
			ArrayList<Object> informationList = new ArrayList<Object>();
			
			ArrayList<String> dataList = new ArrayList<String>();
			Map<String, ArrayList<String>> summaryData = new HashMap<String, ArrayList<String>>();
			Map<String, Integer> daysUsedMap = new HashMap<String, Integer>();
			
			Map<Integer, Integer> haHb = new HashMap<Integer, Integer>();
			ArrayList<Map<Integer, Integer>> haHbList = new ArrayList<Map<Integer,Integer>>();
			Map<String, ArrayList<Map<Integer, Integer>>> haHbMap = new HashMap<String,ArrayList<Map<Integer, Integer>>>();
			
			date = AddOffsetToGmt(yyyymmdd.format(sdfyyyymmddhhmmss.parse(date)), offset);//yyyy-MM-dd HH:mm:ss
			eDate = AddOffsetToGmt(yyyymmdd.format(sdfyyyymmddhhmmss.parse(eDate)), offset);//yyyy-MM-dd HH:mm:ss
			
			summaryData = getVehicleSummaryData(con , systemId, customerId, groupId, date, eDate, userId);
			
			daysUsedMap = getDaysUsed(con , systemId, customerId, groupId, date, eDate, userId);
			
			haHbMap = getHaHbCount(con , systemId, customerId, groupId, date, eDate, userId);
			int totalDaysUsed=0;
    		double totalTripDuration=0;
    		double totalDistance=0;
    		int totalOsCount=0;
    		int totalHACount=0;
    		int totalHBCount=0;
    		int totalIdleCount=0;
    		int totalSBCount=0;
    		double totalidleDuration=0;
    		double totalDuration=0;
	        //get vehicles based on group
	        
	        pstmt = con.prepareStatement(StaffTransportationSolutionStatements.GET_VEHICLES_BASED_ON_GROUP);
	        pstmt.setInt(1, systemId);
	        pstmt.setInt(2, customerId);
	        pstmt.setInt(3, groupId);
	        rs = pstmt.executeQuery();
	         
	        while(rs.next()) {
	        	haCount = 0;
	        	hbCount = 0;
	        	
	        	dataList = summaryData.get(rs.getString("REGISTRATION_NUMBER"));
	        	if(haHbMap.size() > 0) {
	        		haHbList = haHbMap.get(rs.getString("REGISTRATION_NUMBER"));
	        		if(haHbList != null && haHbList.size() > 0) {
	        			haHb = haHbList.get(0);
	        			try {
	        				haCount = haHb.get(105);
	        			} catch (Exception e) {
	        				haCount = 0;
	        			}
	        			try {
	        				hbCount = haHb.get(58);
	        			} catch (Exception e) {
	        				hbCount = 0;
	        			}
	        		}
	        	}
	        	if(dataList != null) {
	        		JsonObject = new JSONObject();
	        		informationList = new ArrayList<Object>();
	        		reporthelper = new ReportHelper();
	        		count=rs.getRow();

	        		informationList.add(rs.getRow());
	        		JsonObject.put("slnoIndex", rs.getRow());

	        		informationList.add(rs.getString("REGISTRATION_NUMBER"));
	        		JsonObject.put("vehicleNoDataIndex", rs.getString("REGISTRATION_NUMBER"));

	        		if(daysUsedMap.get(rs.getString("REGISTRATION_NUMBER"))!=null){
	        			informationList.add(daysUsedMap.get(rs.getString("REGISTRATION_NUMBER")));//daysused
		        		JsonObject.put("daysUsedIndex", daysUsedMap.get(rs.getString("REGISTRATION_NUMBER")));	
	        		}
	        		else{
	        			informationList.add(0);//daysused
		        		JsonObject.put("daysUsedIndex", 0);	
	        		}
	        		informationList.add(dataList.get(4));
	        		JsonObject.put("tripDurationIndex", dataList.get(4));

	        		informationList.add(df.format(Double.parseDouble(dataList.get(5))));
	        		JsonObject.put("distanceIndex", df.format(Double.parseDouble(dataList.get(5))));

	        		informationList.add(dataList.get(3));
	        		JsonObject.put("maxSpeedIndex", dataList.get(3));

	        		informationList.add(dataList.get(8));
	        		JsonObject.put("speedLimitIndex", dataList.get(8));

	        		informationList.add(dataList.get(2));
	        		JsonObject.put("OSCountIndex", dataList.get(2));
	        		
	        		informationList.add(haCount);
	        		JsonObject.put("HACountIndex", haCount);

	        		informationList.add(hbCount);
	        		JsonObject.put("HBCountIndex", hbCount);

	        		informationList.add(dataList.get(0));
	        		JsonObject.put("IdleCountIndex", dataList.get(0));	

	        		informationList.add(dataList.get(9));
	        		JsonObject.put("SeatBeltCountIndex",dataList.get(9));

	        		informationList.add(dataList.get(1));
	        		JsonObject.put("IdledurationIndex", dataList.get(1));		

	        		informationList.add(0);//once day wise activity will get change then it will receive data
	        		JsonObject.put("OSdurationIndex", 0);		

	        		informationList.add(dataList.get(10));
	        		JsonObject.put("TotaldurationIndex", dataList.get(10));		

	        		informationList.add(dataList.get(6));
	        		JsonObject.put("LastCommTimeIndex", dataList.get(6));		

	        		informationList.add(df.format(Double.parseDouble(dataList.get(7))));	
	        		JsonObject.put("LastOdometerIndex",df.format(Double.parseDouble((dataList.get(7)))));
	        		
	        		JsonArray.put(JsonObject);
		            reporthelper.setInformationList(informationList);
		            reportsList.add(reporthelper);
		            if(daysUsedMap.get(rs.getString("REGISTRATION_NUMBER"))!=null){
		            	 totalDaysUsed=totalDaysUsed+daysUsedMap.get(rs.getString("REGISTRATION_NUMBER"));
		            }else{
		            	totalDaysUsed=totalDaysUsed+0;
		            }
		           
		    	    totalTripDuration=totalTripDuration+(Double.parseDouble(dataList.get(11)));
		    	   
		    		totalDistance=totalDistance+(Double.parseDouble(dataList.get(5)));
		    		totalOsCount=totalOsCount+Integer.parseInt(dataList.get(2));
		    		totalHACount=totalHACount+haCount;
		    		totalHBCount=totalHBCount+hbCount;
		    		totalIdleCount=totalIdleCount+Integer.parseInt(dataList.get(0));
		    		totalSBCount=totalSBCount+Integer.parseInt(dataList.get(9));
		    		//totalidleDuration=totalidleDuration+(Long.parseLong(dataList.get(12)));
	        	}
	        }
	        JsonObject = new JSONObject();
    		informationList = new ArrayList<Object>();
    		reporthelper = new ReportHelper();
    		count++;

    		informationList.add(count);
    		JsonObject.put("slnoIndex", count);

    		informationList.add("TOTAL");
    		JsonObject.put("vehicleNoDataIndex", "<B>"+"TOTAL"+"</B>");

    		informationList.add(totalDaysUsed);//daysused
    		JsonObject.put("daysUsedIndex", "<B>"+totalDaysUsed+"</B>");	

    		String totalTripDurStr=formattedHoursMinutes(((long)totalTripDuration));
    		informationList.add(totalTripDurStr);
    		JsonObject.put("tripDurationIndex", "<B>"+totalTripDurStr+"</B>");

    		informationList.add(df.format(totalDistance));
    		JsonObject.put("distanceIndex", "<B>"+df.format(totalDistance)+"</B>");

    		informationList.add("");
    		JsonObject.put("maxSpeedIndex", "");

    		informationList.add("");
    		JsonObject.put("speedLimitIndex", "");

    		informationList.add(totalOsCount);
    		JsonObject.put("OSCountIndex", "<B>"+totalOsCount+"</B>");
    		
    		informationList.add(totalHACount);
    		JsonObject.put("HACountIndex", "<B>"+totalHACount+"</B>");

    		informationList.add(totalHBCount);
    		JsonObject.put("HBCountIndex", "<B>"+totalHBCount+"</B>");

    		informationList.add(totalIdleCount);
    		JsonObject.put("IdleCountIndex", "<B>"+totalIdleCount+"</B>");	

    		informationList.add(totalSBCount);
    		JsonObject.put("SeatBeltCountIndex","<B>"+totalSBCount+"</B>");

    		String totalidleDurStr=formattedHoursMinutes((long)totalidleDuration);
    		informationList.add(totalidleDurStr);
    		JsonObject.put("IdledurationIndex", "<B>"+totalidleDurStr+"</B>");		

    		informationList.add(0);//once day wise activity will get change then it will receive data
    		JsonObject.put("OSdurationIndex", 0);		

    		String totalDur=formattedHoursMinutes((long)totalidleDuration+(long)totalTripDuration);
    		informationList.add(totalDur);
    		JsonObject.put("TotaldurationIndex", "<B>"+totalDur+"</B>");		

    		informationList.add("");
    		JsonObject.put("LastCommTimeIndex", "");		

    		informationList.add("");	
    		JsonObject.put("LastOdometerIndex","");
	        
    		JsonArray.put(JsonObject);
            reporthelper.setInformationList(informationList);
            reportsList.add(reporthelper);
            
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
	
	private Map<String, ArrayList<Map<Integer, Integer>>> getHaHbCount(Connection con, int systemId, int customerId, int groupId, String date, String eDate, int userId) {
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Map<Integer, Integer> haHb = new HashMap<Integer, Integer>();
		ArrayList<Map<Integer, Integer>> haHbList = new ArrayList<Map<Integer,Integer>>();
		Map<String, ArrayList<Map<Integer, Integer>>> haHbMap = new HashMap<String,ArrayList<Map<Integer, Integer>>>();
		
		try {
			pstmt = con.prepareStatement(StaffTransportationSolutionStatements.GET_HARSH_ACC_BRK_COUNT);
	        pstmt.setInt(1, systemId);
	        pstmt.setInt(2, customerId);
	        pstmt.setString(3, date);
	        pstmt.setString(4, eDate);
	        pstmt.setInt(5, systemId);
	        pstmt.setInt(6, customerId);
	        pstmt.setInt(7, userId);
	        pstmt.setInt(8, groupId);
	        pstmt.setInt(9, systemId);
	        pstmt.setInt(10, customerId);
	        pstmt.setString(11, date);
	        pstmt.setString(12, eDate);
	        pstmt.setInt(13, systemId);
	        pstmt.setInt(14, customerId);
	        pstmt.setInt(15, userId);
	        pstmt.setInt(16, groupId);
	        rs = pstmt.executeQuery();
	        
	        String prevRegNo = "";
	        String currRegNo = "";
	        
	        while(rs.next()) {
	        	
	        	if(rs.getRow() == 1) {
	        		haHb = new HashMap<Integer, Integer>();
	        		prevRegNo = rs.getString("REGISTRATION_NO");
	        		currRegNo = rs.getString("REGISTRATION_NO");
	        	} else {
	        		prevRegNo = currRegNo;
	        		currRegNo = rs.getString("REGISTRATION_NO");
	        	}
	        	
	        	if(!prevRegNo.equals(currRegNo)) {
	        		haHbList.add(haHb);
	        		haHbMap.put(prevRegNo, haHbList);
	        		
	        		haHb = new HashMap<Integer, Integer>();
	        		haHbList = new ArrayList<Map<Integer,Integer>>();
		        	haHb.put(rs.getInt("AlertId"), rs.getInt("AlertCount"));
	        	} else {
	        		haHb.put(rs.getInt("AlertId"), rs.getInt("AlertCount"));
	        	}
	        }
	        if(haHb.size() > 0) {
		        haHbList.add(haHb);
	    		haHbMap.put(prevRegNo, haHbList);
	        }
	        
	        rs.close();
	        pstmt.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return haHbMap;
	}

	private Map<String, Integer> getDaysUsed(Connection con, int systemId, int customerId, int groupId, String date, String eDate, int userId) {
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Map<String, Integer> daysUsedMap = new HashMap<String, Integer>();
		
		try {
			pstmt = con.prepareStatement(StaffTransportationSolutionStatements.GET_DAYS_USED);
	        pstmt.setString(1, date);
	        pstmt.setString(2, eDate);
	        pstmt.setInt(3, systemId);
	        pstmt.setInt(4, customerId);
	        pstmt.setInt(5, userId);
	        pstmt.setInt(6, groupId);
	        rs = pstmt.executeQuery();
	        
	        while(rs.next()) {
	        	daysUsedMap.put(rs.getString("RegistrationNo"), rs.getInt("DaysUsed"));
	        }
	        rs.close();
	        pstmt.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return daysUsedMap;
	}

	private Map<String, ArrayList<String>> getVehicleSummaryData(Connection con, int systemId, int customerId, int groupId, String date, 
			String eDate, int userId) {
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		ArrayList<String> dataList = new ArrayList<String>();
		Map<String, ArrayList<String>> summaryData = new HashMap<String, ArrayList<String>>();

		try {
			
			pstmt = con.prepareStatement(StaffTransportationSolutionStatements.GET_STAFF_ACTIVITY_REPORT);
	        pstmt.setString(1, date);
	        pstmt.setString(2, eDate);
	        pstmt.setInt(3, systemId);
	        pstmt.setInt(4, customerId);
	        pstmt.setInt(5, userId);
	        pstmt.setInt(6, groupId);
	        rs = pstmt.executeQuery();
	        
	        while(rs.next()){
	        	dataList = new ArrayList<String>();
	        	dataList.add(rs.getString("NoOfIdle"));
	        	dataList.add(formattedHoursMinutes(rs.getLong("IdleDurationMilliSec")));
	        	dataList.add(rs.getString("NoOfOverSpeed"));
	        	dataList.add(rs.getString("MaxSpeed"));
	        	dataList.add(formattedHoursMinutes(rs.getLong("TravelTimeMilliSec")));
	        	dataList.add(rs.getString("TotalDistanceTravelled"));
	        	dataList.add(sdfyyyymmddhhmmss.format(yyyymmdd.parse(rs.getString("LastCommTime"))));
	        	dataList.add(rs.getString("Odometer"));
	        	dataList.add(rs.getString("StandardSpeed"));
	        	dataList.add(rs.getString("SBViolationCount"));
	        	dataList.add(formattedHoursMinutes(rs.getLong("IdleDurationMilliSec") + rs.getLong("TravelTimeMilliSec")));
	        	
	        	dataList.add(rs.getString("TravelTimeMilliSec"));
	        	dataList.add(rs.getString("IdleDurationMilliSec"));
	        	summaryData.put(rs.getString("RegistrationNo"), dataList);
	        }
	        
	        rs.close();
	        pstmt.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return summaryData;
	}

	public ArrayList<String> gerVehicleDetails(Connection con,String vehicleNo,Date startdate,Date endDate,int offset ,int systemId,int customerId,long i,int shiftId,int branchId){
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		ArrayList<String> vehicleDetails = null;
		try{
			String query = "";
			int noOftrips = 0;
			double totalKms = 0.0;
			long duration = 0;
			String lastKnownTime = "";
			
			if( shiftId == 999 ){
				query = StaffTransportationSolutionStatements.GET_VEHICLE_DETAILS_FROM_SHEDULAR2;
				pstmt = con.prepareStatement(query);
				pstmt.setInt(1, systemId);
				pstmt.setInt(2, customerId);
				pstmt.setString(3, vehicleNo);
				pstmt.setString(4, yyyymmdd.format(startdate));
				pstmt.setString(5, yyyymmdd.format(endDate));
			}else{
				query = StaffTransportationSolutionStatements.GET_VEHICLE_DETAILS_FROM_SHEDULAR ;
				pstmt = con.prepareStatement(query);
				pstmt.setInt(1, systemId);
				pstmt.setInt(2, customerId);
				pstmt.setString(3, vehicleNo);
				pstmt.setString(4, yyyymmdd.format(startdate));
				pstmt.setString(5, yyyymmdd.format(endDate));
				pstmt.setInt(6, shiftId);
			}
			
			rs = pstmt.executeQuery();
			while(rs.next()){
				if(rs.getString("noOfTrip") != null && !rs.getString("noOfTrip").equals("")){
				noOftrips = Integer.parseInt(rs.getString("noOfTrip"));
				}
				if(rs.getString("totalKms") != null && !rs.getString("totalKms").equals("")){
					totalKms = Double.parseDouble(rs.getString("totalKms"));
				}
					duration = rs.getLong("duration");
				if( rs.getString("lastKnownTime") !=null && !rs.getString("lastKnownTime").equals("")){
					lastKnownTime = rs.getString("lastKnownTime");
					if(lastKnownTime.contains("1900")){
						lastKnownTime = "";
					}else{
						lastKnownTime = sdfyyyymmddhhmmss.format(yyyymmdd.parse(lastKnownTime));
					}
				}
				
				vehicleDetails = new ArrayList<String>();
				vehicleDetails.add(String.valueOf(noOftrips));
				vehicleDetails.add(String.valueOf(totalKms));
				vehicleDetails.add(String.valueOf(duration));
				vehicleDetails.add(lastKnownTime);
				
				vehicleDetails.add(String.valueOf(rs.getLong("Trip_Duration")));
				vehicleDetails.add(rs.getString("Max_Speed"));
				vehicleDetails.add(rs.getString("Speed_Limit"));
				vehicleDetails.add(String.valueOf(rs.getInt("OS_COUNT")));
				vehicleDetails.add(String.valueOf(rs.getInt("HA_COUNT")));
				vehicleDetails.add(String.valueOf(rs.getInt("HB_COUNT")));
				vehicleDetails.add(String.valueOf(rs.getInt("IDLE_COUNT")));
				vehicleDetails.add(String.valueOf(rs.getInt("SB_ALERT_COUNT")));
				vehicleDetails.add(String.valueOf(rs.getLong("IDLE_DURATION")));
			}
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			DBConnection.releaseConnectionToDB(null, pstmt, rs);
		}
		return vehicleDetails;
	}


	public double getHrsFromDaysHrsMins(String daysHrsMins){
		double hrs = 0.0;
		if(!daysHrsMins.equals("N/A")){
			StringTokenizer st = new StringTokenizer(daysHrsMins," ");
			String str[] = new String[3];
			int k = 0;
			while(st.hasMoreTokens()){
				str[k] = (String)st.nextElement();
				k++;
			}
			int day = Integer.parseInt(str[0].replace("days", "").trim());
			int hour = Integer.parseInt(str[1].replace("hrs", "").trim());
			int min = Integer.parseInt(str[2].replace("mins", "").trim());
			
			//System.out.println(" day :"+day+"  hour :"+hour+" min :"+min);
			if(min >59){
				hour = hour+min/60;
				min = min%60;
			}
			String mins = String.valueOf(min);
			if(mins.length()<2){
				mins = "0"+min;
			}
			hrs = Double.parseDouble((day * 24) + hour +"."+ mins) ;
		}
		System.out.println(" hrs == "+hrs);
		return hrs;
	}
	
	public double getTotalDuration(Date startDate,Date endDate,double stopTime){
		double duration =0.0;
		
		duration = (endDate.getTime() - startDate.getTime())/ (60 * 1000);
		if(duration>stopTime){
			duration = duration-stopTime;
		}
		return duration;
	}
	public static String AddOffsetToGmt(String inputDate, int offSet) {
		String retValue = inputDate;
		Date convDate = null;
		convDate = convertStringToDate(inputDate);
		if (convDate != null) {
			Calendar cal = Calendar.getInstance();
			cal.setTime(convDate);
			cal.add(Calendar.MINUTE, -offSet);

			int day = cal.get(Calendar.DATE);
			int y = cal.get(Calendar.YEAR);
			int m = cal.get(Calendar.MONTH) + 1;
			int h = cal.get(Calendar.HOUR_OF_DAY);
			int mi = cal.get(Calendar.MINUTE);
			int s = cal.get(Calendar.SECOND);

			String yyyy = String.valueOf(y);
			String month = String.valueOf(m > 9 ? String.valueOf(m) : "0"
					+ String.valueOf(m));
			String date = String.valueOf(day > 9 ? String.valueOf(day) : "0"
					+ String.valueOf(day));
			String hour = String.valueOf(h > 9 ? String.valueOf(h) : "0"
					+ String.valueOf(h));
			String minute = String.valueOf(mi > 9 ? String.valueOf(mi) : "0"
					+ String.valueOf(mi));
			String second = String.valueOf(s > 9 ? String.valueOf(s) : "0"
					+ String.valueOf(s));

			retValue = yyyy + "-" + month + "-" + date + " " + hour + ":"
					+ minute + ":" + second;

		}
		return retValue;
	}
	
	public static Date AddDurationToGmt(Date convDate, int duration) {
		SimpleDateFormat yyyymmdd= new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		if (convDate != null) {
			Calendar cal = Calendar.getInstance();
			cal.setTime(convDate);
			cal.add(Calendar.MINUTE, +duration);
			String convDate2 = yyyymmdd.format(cal.getTime());
			try {
				convDate = yyyymmdd.parse(convDate2);
			} catch (ParseException e) {
				e.printStackTrace();
			}

		}
		return convDate;
	}
	
	
    public static Date convertStringToDate(String inputDate) {
        Date dDateTime = null;
        SimpleDateFormat sdfFormatDate = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        try {
            if (inputDate != null && !inputDate.equals("")) {
                dDateTime = sdfFormatDate.parse(inputDate);
                java.sql.Timestamp timest = new java.sql.Timestamp(dDateTime.getTime());
                dDateTime = timest;
            }
        } catch (Exception e) {         
        }
        return dDateTime;
    }
    
    
    public JSONArray getShiftsBasedOnBranch(int branch, int systemid, int clientid) {

    	   JSONArray jsonArray = new JSONArray();
    	   Connection con = null;
    	   PreparedStatement pstmt = null;
    	   ResultSet rs = null;

    	   try {
    	    con = DBConnection.getConnectionToDB("AMS");
    	    pstmt = con.prepareStatement(StaffTransportationSolutionStatements.GET_SHIFT_BASED_ON_BRANCH);
    	    pstmt.setInt(1, systemid);
    	    pstmt.setInt(2, clientid);
    	    pstmt.setInt(3, branch);
    	    rs = pstmt.executeQuery();
    	    JSONObject obj1 = new JSONObject();
    	    int cnt = 0;
    	    while (rs.next()) {
    	     obj1 = new JSONObject();
    	     cnt++;
    	     obj1.put("slnoIndex2", cnt);
    	     obj1.put("ShiftId", rs.getString("SHIFT_ID"));
    	     obj1.put("ShiftName", rs.getString("SHIFT_NAME"));

    	     String departureTime = String.valueOf(df.format(rs.getFloat("START_TIME")));
    	     if (!departureTime.contains(".")) {
    	      if (departureTime.length() == 0) {
    	       departureTime = "0" + departureTime + ".00";
    	      } else {
    	       departureTime = departureTime + ".00";
    	      }
    	     }
    	     if (departureTime.charAt(2) != '.') {
    	      departureTime = "0" + departureTime;
    	     }
    	     if (departureTime.length() < 5) {
    	      departureTime = departureTime + "0";
    	     }
    	     departureTime = departureTime.replace(".", ":");

    	     obj1.put("StartTime", departureTime);

    	     String arrivalTime = String.valueOf(df.format(rs.getFloat("END_TIME")));
    	     if (!arrivalTime.contains(".")) {
    	      if (arrivalTime.length() == 0) {
    	       arrivalTime = "0" + arrivalTime + ".00";
    	      } else {
    	       arrivalTime = arrivalTime + ".00";
    	      }
    	     }
    	     if (arrivalTime.charAt(2) != '.') {
    	      arrivalTime = "0" + arrivalTime;
    	     }
    	     if (arrivalTime.length() < 5) {
    	      arrivalTime = arrivalTime + "0";
    	     }
    	     arrivalTime = arrivalTime.replace(".", ":");

    	     obj1.put("EndTime", arrivalTime);

    	     jsonArray.put(obj1);
    	    }
    	   } catch (Exception e) {
    	    e.printStackTrace();
    	   } finally {
    	    DBConnection.releaseConnectionToDB(con, pstmt, rs);
    	   }
    	   return jsonArray;
    	  }

    	  public JSONArray getVehiclesAndGroupForAssociation(int systemid, int clientid) {

    	   JSONArray jsonArray = new JSONArray();
    	   Connection con = null;
    	   PreparedStatement pstmt = null;
    	   ResultSet rs = null;

    	   try {
    	    con = DBConnection.getConnectionToDB("AMS");
    	    pstmt = con.prepareStatement(StaffTransportationSolutionStatements.GET_VEHICLE_AND_GROUP);
    	    pstmt.setInt(1, systemid);
    	    pstmt.setInt(2, clientid);
    	    rs = pstmt.executeQuery();
    	    JSONObject obj1 = new JSONObject();
    	    int cont = 0;
    	    while (rs.next()) {
    	     obj1 = new JSONObject();
    	     cont++;
    	     obj1.put("slnoIndex", cont);
    	     obj1.put("VehicleNo", rs.getString("VEHICLE_NO"));
    	     obj1.put("VehicleGroupId", rs.getString("GROUP_ID"));
    	     obj1.put("VehicleGroupName", rs.getString("GROUP_NAME"));
    	     jsonArray.put(obj1);
    	    }
    	   } catch (Exception e) {
    	    e.printStackTrace();
    	   } finally {
    	    DBConnection.releaseConnectionToDB(con, pstmt, rs);
    	   }
    	   return jsonArray;
    	  }

    	  public JSONArray getShiftDetailsForVakidation(int systemid, int clientid, int branch) {

    	   JSONArray jsonArray = new JSONArray();
    	   Connection con = null;
    	   PreparedStatement pstmt = null;
    	   ResultSet rs = null;

    	   try {
    	    con = DBConnection.getConnectionToDB("AMS");
    	    pstmt = con.prepareStatement(StaffTransportationSolutionStatements.GET_SHIFT_DETAIS_FOR_VALIDATION);
    	    pstmt.setInt(1, systemid);
    	    pstmt.setInt(2, clientid);
    	    pstmt.setInt(3, branch);
    	    rs = pstmt.executeQuery();
    	    float total_hours = 0;
    	    JSONObject obj1 = new JSONObject();
    	    ArrayList < String > ar = new ArrayList < String > ();
    	    int cont = 0;
    	    while (rs.next()) {
    	     cont++;
    	     obj1.put("slnoIndex2", cont);
    	     String departureTime = String.valueOf(df.format(rs.getFloat("START_TIME")));
    	     if (!departureTime.contains(".")) {
    	      if (departureTime.length() == 0) {
    	       departureTime = "0" + departureTime + ".00";
    	      } else {
    	       departureTime = departureTime + ".00";
    	      }
    	     }
    	     if (departureTime.charAt(2) != '.') {
    	      departureTime = "0" + departureTime;
    	     }
    	     if (departureTime.length() < 5) {
    	      departureTime = departureTime + "0";
    	     }
    	     String startTime = departureTime.replace(".", ":");


    	     String arrivalTime = String.valueOf(df.format(rs.getFloat("END_TIME")));
    	     if (!arrivalTime.contains(".")) {
    	      if (arrivalTime.length() == 0) {
    	       arrivalTime = "0" + arrivalTime + ".00";
    	      } else {
    	       arrivalTime = arrivalTime + ".00";
    	      }
    	     }
    	     if (arrivalTime.charAt(2) != '.') {
    	      arrivalTime = "0" + arrivalTime;
    	     }
    	     if (arrivalTime.length() < 5) {
    	      arrivalTime = arrivalTime + "0";
    	     }
    	     String endTime = arrivalTime.replace(".", ":");

    	     ar.add(startTime);
    	     ar.add(endTime);
    	     total_hours += calculateTimeDiff(startTime, endTime);

    	    }
    	    if (ar.size() > 0) {
    	     obj1.put("TotalHrs", calculateTimeDiff(ar.get(0), ar.get(ar.size() - 1)));
    	     obj1.put("startTime", ar.get(0));
    	     obj1.put("endTime", ar.get(ar.size() - 1));
    	    } else {
    	     obj1.put("TotalHrs", "0.0");
    	     obj1.put("startTime", "");
    	     obj1.put("endTime", "");
    	    }

    	    jsonArray.put(obj1);

    	   } catch (Exception e) {
    	    e.printStackTrace();
    	   } finally {
    	    DBConnection.releaseConnectionToDB(con, pstmt, rs);
    	   }
    	   return jsonArray;
    	  }

    	  public float calculateTimeDiff(String startTime, String endTime) {

    	   String[] st = startTime.split("\\:");
    	   String[] et = endTime.split("\\:");

    	   int sh = 0;
    	   int sm = 0;
    	   if (st.length > 1) {
    	    sh = Integer.parseInt(st[0]);
    	    sm = Integer.parseInt(st[1]);
    	   } else {
    	    sh = Integer.parseInt(startTime);
    	    sm = 0;
    	   }

    	   int eh = 0;
    	   int em = 0;
    	   if (et.length > 1) {
    	    eh = Integer.parseInt(et[0]);
    	    em = Integer.parseInt(et[1]);
    	   } else {
    	    eh = Integer.parseInt(endTime);
    	    em = 0;
    	   }

    	   float hr = eh - sh;
    	   float mins = 0;

    	   if (hr < 0) {
    	    hr = 24 + hr;
    	   }
    	   if (em >= sm) {
    	    mins = em - sm;
    	   } else {
    	    mins = (em + 60) - sm;
    	    hr--;
    	   }
    	   mins = mins / 60;
    	   hr += mins;

    	   return hr;
    	  }
    		public JSONArray getVehicleGroupFromShiftMaster(int systemid,int clientid){

    			JSONArray jsonArray = new JSONArray(); 
    			Connection con=null;
    			PreparedStatement pstmt=null;
    			ResultSet rs=null;

    			try{
    				con = DBConnection.getConnectionToDB("AMS");
    				pstmt=con.prepareStatement(StaffTransportationSolutionStatements.GET_VEHICLE_GROUP_FROM_SHIFT_MASTER);
    				pstmt.setInt(1, systemid);
    				pstmt.setInt(2, clientid);
    				rs=pstmt.executeQuery();
    				JSONObject obj1 = new JSONObject();		
    				while(rs.next()){
    					obj1 = new JSONObject();
    					obj1.put("BranchId",rs.getString("GROUP_ID"));
    					obj1.put("BranchName",rs.getString("GROUP_NAME"));
    					jsonArray.put(obj1);
    				}
    			}
    			catch(Exception e){
    				e.printStackTrace();
    			}
    			finally{
    				DBConnection.releaseConnectionToDB(con,pstmt,rs);
    			}
    			return jsonArray;  
    		}  
    		
    		public String CheckShiftEndTime(int shiftId,String startDate, int branchId, int systemId, int customerId)
    		{
    			startDate = startDate.substring(0, startDate.indexOf("T"));
    			Connection con = null;
    			PreparedStatement pstmt= null;
    			ResultSet rs = null;
    			String message="";
    			float shiftStartTime = 0.0f;
    	        float shiftEndTime = 0.0f;

 
    			try
    			{
    				 con = DBConnection.getConnectionToDB("AMS");
    				 if(shiftId == 999){
    					 pstmt = con.prepareStatement(StaffTransportationSolutionStatements.SELECT_ALL_SHIFT_TIMINGS);
    					 pstmt.setInt(1, systemId);
    					 pstmt.setInt(2, customerId);
        				 pstmt.setInt(3, branchId);
    				 }
    				 else {
    				 pstmt = con.prepareStatement(StaffTransportationSolutionStatements.SELECT_SHIFT_TIMINGS);			
    				 pstmt.setInt(1, shiftId);
    				
    				 }
    				 rs = pstmt.executeQuery();
    				 if(rs.next()){
    					
    					 String departureTime = String.valueOf(df.format(rs.getFloat("START_TIME")));
    			            if(!departureTime.contains(".")){
    			            	if(departureTime.length()==0){
    			            		departureTime = "0"+departureTime+".00";	
    			            	}else{
    			            	departureTime =departureTime+".00";
    			            	}
    			            }
    			            if(departureTime.charAt(2)!='.'){
    							departureTime = "0"+departureTime;
    						}
    						if(departureTime.length()<5){
    							departureTime = departureTime+"0";
    						}
    						 departureTime = departureTime.replace(".", ":");
    						 
    						 startDate = startDate+" "+departureTime+":00";
    					 
    				   		shiftStartTime = Float.parseFloat(df.format(rs.getFloat("START_TIME")));
    				    	shiftEndTime = Float.parseFloat(df.format(rs.getFloat("END_TIME")));

    				    	float duration = 0.0f;
    		        		
    		        		if(shiftEndTime>shiftStartTime){
    		        		duration =  (shiftEndTime - shiftStartTime);
    		        		}else{
    		        			float s1 = 24-shiftStartTime;
    		        			duration =  s1+shiftEndTime;
    		        			
    		        		}
    		        		String durationS = String.valueOf(duration);
    		        		durationS = durationS.replace(".", ",");
    		        		String ds[] = durationS.split(",");
    		        		String d1 = ds[0];
    		        		String d2 = ds[1];
    		        		int duration2 = (Integer.parseInt(d1)*60)+Integer.parseInt(d2);
    		        		//System.out.println(" duration ======= "+duration);

    		        		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
    						java.util.Date dateS = sdf.parse(startDate);		
    						//System.out.println(" dateS ====== "+dateS);
    						java.util.Date dateE = AddDurationToGmt(dateS,  duration2);
    						//System.out.println(" dateE ====== "+dateE);
    					
    						java.util.Date dateC = new Date();
    						//System.out.println(" dateC =========== "+dateC);
    						int comp = dateC.compareTo(dateE);
    						//System.out.println(" comp == "+comp);
    						if(comp == 1 ){
    							message = "success";
    						}
    				 }
    			
    			}
    			 catch (Exception e)
    			 {
    				
    					e.printStackTrace();
    			 }      
    			finally {
    				DBConnection.releaseConnectionToDB(con, pstmt, rs);
    		    }
    			return message;
    					
    		}

			public JSONArray getVehicleUtilizationReport(int systemId, String customerId, String groupId, int offset, String startDate, String endDate, String language, int userId) {
				
				Connection con = null;
				PreparedStatement pstmt = null;
				ResultSet rs = null;
				
				JSONArray jsonArray = null;
				try {
					con = DBConnection.getConnectionToDB("AMS");

					int count = 0;
					List<VehicleUtilizationBean> objList = new ArrayList<VehicleUtilizationBean>();
					VehicleUtilizationBean vub = null;

					startDate = AddOffsetToGmt(yyyymmdd.format(sdfyyyymmddhhmmss.parse(startDate)), offset);//yyyy-MM-dd HH:mm:ss
					endDate = AddOffsetToGmt(yyyymmdd.format(sdfyyyymmddhhmmss.parse(endDate)), offset);
					
					pstmt = con.prepareStatement(StaffTransportationSolutionStatements.GET_STAFF_ACTIVITY_REPORT);
					pstmt.setString(1, startDate);
			        pstmt.setString(2, endDate);
			        pstmt.setInt(3, systemId);
			        pstmt.setString(4, customerId);
			        pstmt.setInt(5, userId);
			        pstmt.setString(6, groupId);
					rs = pstmt.executeQuery();
					
					while(rs.next()) {
						vub = new VehicleUtilizationBean();
						vub.setRegistrationNo(rs.getString("RegistrationNo"));
						vub.setTravelTime(rs.getDouble("TravelTimeMilliSec"));
						String travelTime = formattedHoursMinutes(rs.getLong("TravelTimeMilliSec"));
						vub.setTravelTimeFormatted(travelTime);
						
						objList.add(vub);
					}
					
					Collections.sort(objList, new Comparator<VehicleUtilizationBean>() {
						public int compare(VehicleUtilizationBean a1, VehicleUtilizationBean a2) {
							return a2.getTravelTime().compareTo(a1.getTravelTime());
						}
					});
					jsonArray = new JSONArray();
					JSONObject obj = null;
					double maxTime = 1L;
					double percent = 100;
					for(VehicleUtilizationBean vuBean: objList) {
						
						if(count == 0){
							maxTime = vuBean.getTravelTime();
						} else {
							percent = (vuBean.getTravelTime()*100)/maxTime;
						}

						obj = new JSONObject();
						
						obj.put("slnoIndex", ++count);
						obj.put("vehicleNoDataIndex", vuBean.getRegistrationNo());
						obj.put("TotalTripDurationDataIndex", vuBean.getTravelTimeFormatted());
						obj.put("GraphDataIndex", df.format(percent));

						jsonArray.put(obj);
					}

				} catch (Exception e) {
					e.printStackTrace();
				} finally {
					DBConnection.releaseConnectionToDB(con, pstmt, rs);
				}
				return jsonArray;
			}
			
			
			public JSONArray getVehicles(int systemId, int customerId,int branchId) {
			    JSONArray JsonArray = new JSONArray();
			    JSONObject JsonObject = null;
			    Connection con = null;
			    PreparedStatement pstmt = null;
			    ResultSet rs = null;
			    try {
			    	 JsonObject = new JSONObject();
			            JsonObject.put("VehicleNo", "ALL");	          	            
			            JsonArray.put(JsonObject);
			        con = DBConnection.getConnectionToDB("AMS");
			        pstmt = con.prepareStatement(StaffTransportationSolutionStatements.GET_VEHICLES);
			        pstmt.setInt(1, systemId);
			        pstmt.setInt(2, customerId);
			        pstmt.setInt(3, branchId);
			        rs = pstmt.executeQuery();
			        while (rs.next()) {
			            JsonObject = new JSONObject();
			            JsonObject.put("VehicleNo", rs.getString("VEHICLE_NO"));	          	            
			            JsonArray.put(JsonObject);
			        }
			    } catch (Exception e) {
			        e.printStackTrace();
			    } finally {
			        DBConnection.releaseConnectionToDB(con, pstmt, rs);
			    }
			    return JsonArray;
			}
			
			
public ArrayList < Object > getSpeedingDetails(int systemId, int customerId,int branchId,String date,String eDate,int offset,String vehicle) {
				
			    JSONArray JsonArray = new JSONArray();
			    JSONObject JsonObject = null;
			    Connection con = null;
			    PreparedStatement pstmt = null;
			    ResultSet rs = null;
			     ArrayList < ReportHelper > reportsList = new ArrayList < ReportHelper > ();
				 ArrayList < String > headersList = new ArrayList < String > ();
				 ReportHelper finalreporthelper = new ReportHelper();
				 ArrayList < Object > finlist = new ArrayList < Object > ();
				 headersList.add("SLNO");
				 headersList.add("Vehicle No");
				 headersList.add("Route");
				 headersList.add("Date and Time");
				 headersList.add("Location");
				 headersList.add("MaxSpeed(Km/h)");
				 headersList.add("Speed Limit(Km/h)");
				 headersList.add("Duration");
				 headersList.add("Driver");
				
			    try {
			        int count = 0;
			        con = DBConnection.getConnectionToDB("AMS");
			        String Date = "";
			        if(vehicle.equalsIgnoreCase("ALL")){
			    	   pstmt = con.prepareStatement(StaffTransportationSolutionStatements.GET_SPEEDING_DETAILS.replaceAll("&&", "and b.GROUP_ID="+branchId));
			        }else{
			        	pstmt = con.prepareStatement(StaffTransportationSolutionStatements.GET_SPEEDING_DETAILS.replaceAll("&&",  " and pod.VEHICLE_NUMBER="+vehicle));
			        }
			        pstmt.setInt(1, offset);
			        pstmt.setInt(2, systemId);
			        pstmt.setInt(3, customerId);
			        pstmt.setInt(4, offset);
			        pstmt.setString(5, yyyymmdd.format(sdfyyyymmddhhmmss.parse(date)));
			        pstmt.setInt(6, offset);
			        pstmt.setString(7, yyyymmdd.format(sdfyyyymmddhhmmss.parse(eDate)));
			        rs = pstmt.executeQuery();
			        while (rs.next()) {
			        	count++;
			        	
			        	JsonObject = new JSONObject();
						ReportHelper reporthelper = new ReportHelper();
						ArrayList<Object> informationList = new ArrayList<Object>();
		        	
				    	informationList.add(count);
						JsonObject.put("slnoIndex", count);
						
						informationList.add(rs.getString("VEHICLE_NUMBER"));
						JsonObject.put("vehicleNoDataIndex", rs.getString("VEHICLE_NUMBER"));
						
						informationList.add(rs.getString("ROUTE"));
						JsonObject.put("routeDataIndex", rs.getString("ROUTE"));
						
						if(rs.getString("Date") !=null && !rs.getString("Date").equals("")){
							Date = rs.getString("Date");
							if(Date.contains("1900")){
								Date = "";
							}else{
								Date = sdfyyyymmddhhmmss.format(yyyymmdd.parse(Date));
							}
						}
						
						informationList.add(Date);
						JsonObject.put("DateTimeDataIndex",Date);				
						
						informationList.add(rs.getString("LOCATION"));
						JsonObject.put("LocationDataIndex", rs.getString("LOCATION"));
						
						informationList.add(rs.getString("MAX_SPEED"));
						JsonObject.put("MaxSpeedDataIndex", rs.getString("MAX_SPEED"));
						
						informationList.add(rs.getString("SPEED_LIMIT"));
						JsonObject.put("SpeedLimitDataIndex", rs.getString("SPEED_LIMIT"));

						informationList.add(formattedHoursMinutes(rs.getLong("PATH_OS_DURATION")));
						JsonObject.put("DurationDataIndex",formattedHoursMinutes(rs.getLong("PATH_OS_DURATION")));
						
						informationList.add(rs.getString("DRIVER_NAME"));
						JsonObject.put("DriverDataIndex", rs.getString("DRIVER_NAME"));

						JsonArray.put(JsonObject);
			            reporthelper.setInformationList(informationList);
			            reportsList.add(reporthelper);
			       
			        finalreporthelper.setReportsList(reportsList);
			        finalreporthelper.setHeadersList(headersList);
			        finlist.add(JsonArray);
			        finlist.add(finalreporthelper);	       
			        } 
			    } catch (Exception e) {
			        e.printStackTrace();
			    } finally {
			        DBConnection.releaseConnectionToDB(con, pstmt, rs);
			    }
			    return finlist;
			}
			
@SuppressWarnings("unchecked")
public ArrayList getShiftWiseVehicleDetails(int systemId,int CustomerId,String startDateTime,String endDateTime,int BranchId,int ShiftId,String vehicleNo) {
	JSONArray JsonArray = new JSONArray();
	JSONObject JsonObject = null;
	Connection con = null;
	PreparedStatement pstmt=null;
	ResultSet rs=null;
	ArrayList finalList = new ArrayList();
	ArrayList<ReportHelper> reportsList = new ArrayList<ReportHelper>();
	ArrayList<String> headersList = new ArrayList<String>();
	ReportHelper finalreporthelper = new ReportHelper();
	SimpleDateFormat yyyymmdd = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	SimpleDateFormat yyyymmdd1 = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
	SimpleDateFormat ddmmyyyy = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
	SimpleDateFormat formatddmmyyyy = new SimpleDateFormat("yyyy-MM-dd");
	SimpleDateFormat ddmmyyyy1 = new SimpleDateFormat("dd/MM/yyyy");
	int count=0;
	String totalDuration="";
	headersList.add("SL NO");
	headersList.add("Vehicle No");
	headersList.add("Start Datetime");
    headersList.add("End Datetime");
	headersList.add("Total Distance");
	headersList.add("Total Duration");
	System.out.println(startDateTime);
	System.out.println(endDateTime);

	try {
		con = DBConnection.getConnectionToDB("AMS");
		if(ShiftId==999){
			pstmt = con.prepareStatement(StaffTransportationSolutionStatements.GET_SHIFTWISE_VEHICLE_DETAILS.replace("##", ""));
			pstmt.setString(1, vehicleNo);
			pstmt.setInt(2, CustomerId);
			pstmt.setInt(3, BranchId);
			pstmt.setString(4, yyyymmdd.format(ddmmyyyy.parse(startDateTime)));
			pstmt.setString(5, yyyymmdd.format(ddmmyyyy.parse(endDateTime)));
			rs = pstmt.executeQuery();
		}else{
			pstmt = con.prepareStatement(StaffTransportationSolutionStatements.GET_SHIFTWISE_VEHICLE_DETAILS.replace("##", "and SHIFT_ID=?"));
			pstmt.setString(1, vehicleNo);
			pstmt.setInt(2, CustomerId);
			pstmt.setInt(3, ShiftId);
			pstmt.setInt(4, BranchId);
			pstmt.setString(5, yyyymmdd.format(ddmmyyyy.parse(startDateTime)));
			pstmt.setString(6, yyyymmdd.format(ddmmyyyy.parse(endDateTime)));
			rs = pstmt.executeQuery();
		}
		while (rs.next()) {
			
			JsonObject = new JSONObject();
			ArrayList<Object> informationList = new ArrayList<Object>();
			ReportHelper reporthelper = new ReportHelper();
			count++;
			JsonObject.put("slnoIndex", count);
			informationList.add(count);
			
			JsonObject.put("vehicleNoIndex", rs.getString("VEHICLE_NUMBER"));
			informationList.add(rs.getString("VEHICLE_NUMBER"));
			
			JsonObject.put("startDateTimeIndex", yyyymmdd1.format(yyyymmdd.parse(rs.getString("START_DATETIME"))));
			informationList.add(yyyymmdd1.format(yyyymmdd.parse(rs.getString("START_DATETIME"))));
			
			JsonObject.put("endDateTimeIndex", yyyymmdd1.format(yyyymmdd.parse(rs.getString("END_DATETIME"))));
			informationList.add(yyyymmdd1.format(yyyymmdd.parse(rs.getString("END_DATETIME"))));
			
			JsonObject.put("totalkmIndex", rs.getString("TOTAL_KM"));
			informationList.add(rs.getString("TOTAL_KM"));
			
			totalDuration=AddTime(rs.getLong("DURATION"));
			JsonObject.put("totalDurationIndex", totalDuration);
			informationList.add(totalDuration);
			
			JsonObject.put("startDateIndex", ddmmyyyy1.format(formatddmmyyyy.parse(rs.getString("START_DATE"))));
			JsonObject.put("endDateIndex", ddmmyyyy1.format(formatddmmyyyy.parse(rs.getString("END_DATE"))));
			JsonObject.put("startTimeIndex", rs.getString("START_TIME"));
			JsonObject.put("endTimeIndex", rs.getString("END_TIME"));

			JsonArray.put(JsonObject);
			reporthelper.setInformationList(informationList);
			reportsList.add(reporthelper);
		}
		finalList.add(JsonArray);
		finalreporthelper.setReportsList(reportsList);
		finalreporthelper.setHeadersList(headersList);
		finalList.add(finalreporthelper);
	} catch (Exception e) {
		e.printStackTrace();
	}finally {

		DBConnection.releaseConnectionToDB(con, pstmt, rs);
	}
	return finalList;
}

			

    	private String formattedHoursMinutes(long totalTime) {
    		//String time1="19:01:30";
    		//String time2="20:01:35";
    		//long time = 152185000;
    		int s = (int)((totalTime/=1000) % 60);
    		int m = (int)((totalTime/=60) % 60);
    		 int h = (int)(totalTime/=60);
    		 
    		String hour=String.valueOf(h>9?String.valueOf(h):"0"+String.valueOf(h));
 			String minute=String.valueOf(m>9?String.valueOf(m):"0"+String.valueOf(m));
 			String second=String.valueOf(s>9?String.valueOf(s):"0"+String.valueOf(s));
 			
    		//System.out.format("%02d:%02d:%02d%n", h, m, s);
    		String TotalTIme=hour+":"+""+ minute+":"+ second;
    		return TotalTIme;
   }
    	
    	/**********************
    	 * Added up the time and given
    	 * String time1="19:01:30";
    	 * String time2="20:01:35";
    	 * 
    	 * *************************/
    	private String AddTime(long totalTime){
    		//String time1="19:01:30";
    		//String time2="20:01:35";
    		//long time = 152185000;
    		int s = (int)((totalTime/=1000) % 60);
    		int m = (int)((totalTime/=60) % 60);
    		 int h = (int)(totalTime/=60);
    		//System.out.format("%02d:%02d:%02d%n", h, m, s);
    		String TotalTIme=h+":"+""+ m+":"+ s;
    		return TotalTIme;
    	}
    	
    	public JSONArray getVehicleUtilizationReportForShiftWise(int systemId, String customerId, String groupId, int offset, String startDate, String endDate, String language, int userId,int shiftId) {
    		JSONArray jsonArray = new JSONArray();
    		DecimalFormat decimalf=new DecimalFormat("##.##");
           try{
			startDate = startDate.substring(0,startDate.lastIndexOf(" "));
		    endDate = endDate.substring(0,endDate.lastIndexOf(" "));
		    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		    SimpleDateFormat df = new SimpleDateFormat("dd-MM-yyyy");
			try {
				startDate = sdf.format(df.parse(startDate));
				endDate  = sdf.format(df.parse(endDate));
			} catch (ParseException e) {					
				e.printStackTrace();
			}
		ArrayList < Object > list = getViewDetails(systemId, Integer.parseInt(customerId),Integer.parseInt(groupId),shiftId, startDate,endDate,offset,"ShiftWise");
		ReportHelper reportHelper = (ReportHelper) list.get(1);
		ArrayList reportdataList = new ArrayList();

		ReportHelper Report = new ReportHelper();
		Report = reportHelper ;
		ReportHelper reportData = new ReportHelper();
		ArrayList headerList = (ArrayList) Report.getHeadersList();
		ArrayList dataLists = (ArrayList) Report.getReportsList();
		ArrayList dataList = new ArrayList();
		if( dataLists!=null && !dataLists.isEmpty()){
		for (int i = 0; i < dataLists.size(); i++) {
			reportData = (ReportHelper) dataLists.get(i);
			dataList.add(reportData.getInformationList());
		}		
		List<VehicleUtilizationBean> objList = new ArrayList<VehicleUtilizationBean>();
		VehicleUtilizationBean vub = null;
        int count = 0;
        if(dataList!=null && !dataList.isEmpty()){
		for(int i = 0; i < dataList.size(); i++){
			vub = new VehicleUtilizationBean();
			ArrayList subdataList = new ArrayList();
			subdataList = (ArrayList)dataList.get(i);
			if(!subdataList.get(1).toString().equalsIgnoreCase("TOTAL")){
			vub.setRegistrationNo(subdataList.get(1).toString());
			vub.setTravelTimeFormatted(subdataList.get(9).toString());
			double travelTimeinmili = convertToMilisec(subdataList.get(9).toString());
			vub.setTravelTime(travelTimeinmili);
			
			objList.add(vub);
			}
		}
		Collections.sort(objList, new Comparator<VehicleUtilizationBean>() {
			public int compare(VehicleUtilizationBean a1, VehicleUtilizationBean a2) {
				return a2.getTravelTime().compareTo(a1.getTravelTime());
			}
		});
		jsonArray = new JSONArray();
		JSONObject obj = null;
		double maxTime = 1L;
		double percent = 100;
		
		for(VehicleUtilizationBean vuBean: objList) {
			
			if(count == 0){
				maxTime = vuBean.getTravelTime();
			} else {
				percent = (vuBean.getTravelTime()*100)/maxTime;
			}

			obj = new JSONObject();
			
			try {
				obj.put("slnoIndex", ++count);
				obj.put("vehicleNoDataIndex", vuBean.getRegistrationNo());
				obj.put("TotalTripDurationDataIndex", vuBean.getTravelTimeFormatted());
				obj.put("GraphDataIndex", decimalf.format(percent));
			} catch (Exception e) {
				e.printStackTrace();
			}
		
		      
			jsonArray.put(obj);
		}
		}
		}
           }catch(Exception e){
        	   e.printStackTrace();
           }
		return jsonArray;
		
    		
    	}
		
    	 public double	convertToMilisec (String formattedTime){
    			double  milisecs = 0.0;
    			String time[] = formattedTime.split(":");    			
    			double totmin = (60*Integer.parseInt(time[0]))+Integer.parseInt(time[1]);
    			String totalmili = df.format(totmin*60000);
    			String milisecss = df.format(Integer.parseInt(time[2])*1000);
    			milisecs =  Double.parseDouble(df.format( Double.parseDouble(totalmili) + Double.parseDouble(milisecss)));	
    			//System.out.println(" milisecs == "+milisecs);
    			return milisecs;
    		 }
    public String[] getStartAndEndTimeForAll(String startdates,String enddates, int sysId,int custId,int groupId,int offset){
    	String timeString[] = new String[2];
    	SimpleDateFormat sdf2 = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
    	SimpleDateFormat sdf3 = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
    	Connection con = null;
  	    PreparedStatement pstmt = null;
  	    ResultSet rs = null; 
        float shiftStartTime = 0.0f;
        float shiftEndTime = 0.0f;       
    	java.util.Date dateE =null;
    	
try{
	 con = DBConnection.getConnectionToDB("AMS");
    	pstmt = con.prepareStatement(StaffTransportationSolutionStatements.SELECT_ALL_SHIFT_TIMINGS1);
		 pstmt.setInt(1, sysId);
		 pstmt.setInt(2, custId);
		 pstmt.setInt(3, groupId);	
		 rs = pstmt.executeQuery();
	        if(rs.next()){
	        		
				 String departureTime = String.valueOf(df.format(rs.getFloat("START_TIME")));
		            if(!departureTime.contains(".")){
		            	if(departureTime.length()==0){
		            		departureTime = "0"+departureTime+".00";	
		            	}else{
		            	departureTime =departureTime+".00";
		            	}
		            }
		            if(departureTime.charAt(2)!='.'){
						departureTime = "0"+departureTime;
					}
					if(departureTime.length()<5){
						departureTime = departureTime+"0";
					}
					 departureTime = departureTime.replace(".", ":");
					 
					 startdates = startdates+" "+departureTime+":00";

					 //startdates = AddOffsetToGmt(startdates, offset);
					 startdates = sdf3.format(sdf2.parse(startdates));
					
	        }
				 pstmt = con.prepareStatement(StaffTransportationSolutionStatements.SELECT_ALL_SHIFT_TIMINGS);
				 pstmt.setInt(1, sysId);
				 pstmt.setInt(2, custId);
				 pstmt.setInt(3, groupId);	
			     rs = pstmt.executeQuery();
			     if(rs.next()){
					
				 String departureTime2 = String.valueOf(df.format(rs.getFloat("START_TIME")));
		            if(!departureTime2.contains(".")){
		            	if(departureTime2.length()==0){
		            		departureTime2 = "0"+departureTime2+".00";	
		            	}else{
		            	departureTime2 =departureTime2+".00";
		            	}
		            }
		            if(departureTime2.charAt(2)!='.'){
						departureTime2 = "0"+departureTime2;
					}
					if(departureTime2.length()<5){
						departureTime2 = departureTime2+"0";
					}
					 departureTime2 = departureTime2.replace(".", ":");
					 
					 enddates = enddates+" "+departureTime2+":00";
				 
			   		shiftStartTime = Float.parseFloat(df.format(rs.getFloat("START_TIME")));
			    	shiftEndTime = Float.parseFloat(df.format(rs.getFloat("END_TIME")));

			    	float duration = 0.0f;
	        		
	        		if(shiftEndTime>shiftStartTime){
	        		duration =  (shiftEndTime - shiftStartTime);
	        		}else{
	        			float s1 = 24-shiftStartTime;
	        			duration =  s1+shiftEndTime;
	        			
	        		}
	        		String durationS = String.valueOf(duration);
	        		durationS = durationS.replace(".", ",");
	        		String ds[] = durationS.split(",");
	        		String d1 = ds[0];
	        		String d2 = ds[1];
	        		int duration2 = (Integer.parseInt(d1)*60)+Integer.parseInt(d2);
	        		//System.out.println(" duration ======= "+duration);

	        		
					java.util.Date dateS2 = sdf2.parse(enddates);		
					//System.out.println(" dateS ====== "+dateS2);
					dateE = AddDurationToGmt(dateS2,  duration2);
					String date2 = sdf2.format(dateE);
					//date2 = AddOffsetToGmt(date2, offset);					
					enddates = sdf3.format((sdf2.parse(date2)));

			 }

    		timeString[0] =startdates; 
    		timeString[1] =enddates; 
}catch(Exception e){
	e.printStackTrace();
}
    	finally{
    		 DBConnection.releaseConnectionToDB(con, pstmt, rs);
    	}
    	return timeString;
    }
}
