package t4u.functions;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Hashtable;
import java.util.List;
import java.util.StringTokenizer;
import org.json.JSONArray;
import org.json.JSONObject;

import com.itextpdf.text.log.SysoLogger;

import t4u.beans.ReportHelper;
import t4u.common.DBConnection;
import t4u.common.DESEncryptionDecryption;
import t4u.common.LocationLocalization;
import t4u.statements.AdminStatements;
import t4u.statements.CommonStatements;
import t4u.statements.BookingCustomerStatements;
import t4u.statements.SandMiningStatements;

public class BookingCustomerFunctions {
	
	public ArrayList < Object > getBookingCustomerReport(int clientId, int systemid,int userId) {
	    JSONArray JsonArray = new JSONArray();
	    JSONObject JsonObject = null;
	    Connection con = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
		ArrayList < Object > finlist = new ArrayList < Object > ();
	    try {
	        int count = 0;
	        con = DBConnection.getConnectionToDB("AMS");
	            pstmt = con.prepareStatement(BookingCustomerStatements.GET_BOOKING_CUSTOMER_DETAILS);
	            pstmt.setInt(1, systemid);
	            pstmt.setInt(2, clientId);
	            rs = pstmt.executeQuery();
	        while (rs.next()) {
	            JsonObject = new JSONObject();
	            count++;
	        	ArrayList<Object> informationList = new ArrayList<Object>();
				ReportHelper reporthelper = new ReportHelper();
				
	        	informationList.add(count);
			    JsonObject.put("slnoIndex", count);
			   
	            JsonObject.put("customerIdDataIndex", rs.getString("BOOKING_CUSTOMER_ID"));
	            
 	            JsonObject.put("customerNameDataIndex", rs.getString("BOOKING_CUSTOMER_NAME"));
 	          
	            JsonObject.put("emailDataIndex", rs.getString("EMAIL_ID"));
	           
	            JsonObject.put("phoneDataIndex", rs.getString("PHONE_NO"));
	           
	            JsonObject.put("mobileDataIndex", rs.getString("MOBILE_NO"));
	           
	            JsonObject.put("faxDataIndex", rs.getString("FAX"));
	           
				JsonObject.put("tinDataIndex", rs.getString("TIN"));
				
				JsonObject.put("addressDataIndex", rs.getString("ADDRESS"));
				
				JsonObject.put("cityDataIndex", rs.getString("CITY"));
				
				JsonObject.put("stateDataIndex", rs.getString("STATE_NAME"));
				
				JsonObject.put("uniqueIdDataIndex", rs.getString("ID"));
				
				JsonObject.put("stateIdDataIndex", rs.getString("STATE"));
				
				JsonObject.put("regionDataIndex", rs.getString("REGION"));
				
				JsonObject.put("statusDataIndex", rs.getString("STATUS"));
				
				JsonObject.put("userIdDataIndex", rs.getString("USER_ID"));
			
				JsonObject.put("passwordDataIndex", rs.getString("PASSWORD"));
			
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
	
	public String insertCustomerInformation(int custId, String customer_id,String name,String email,String phone,String mobile,String fax,String tin,String address,String city,String userid,String password,String state,String region,String status,int userId,int systemId) {
	    Connection con = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
	    String message = "";
	    try {
	        con = DBConnection.getConnectionToDB("AMS");
	        
	        pstmt = con.prepareStatement(BookingCustomerStatements.CHECK_IF_USER_ID_ALREADY_EXISTS);
	        pstmt.setString(1, userid);

	        rs = pstmt.executeQuery();
	        if (rs.next()) {
	            message = "User Id Already Exists";
	        } else {
	        	
	        	pstmt = con.prepareStatement(BookingCustomerStatements.CHECK_IF_CUSTOMER_NAME_ALREADY_EXISTS);
		        pstmt.setString(1, name.toUpperCase());
		        pstmt.setInt(2, custId);
		        pstmt.setInt(3, systemId);
		        rs = pstmt.executeQuery();
		        if (rs.next()) {
		            message = "Customer Name Already Exists";
		        }else {
	        	
	        	
	        pstmt = con.prepareStatement(BookingCustomerStatements.INSERT_CUSTOMER_INFORMATION);
	        pstmt.setString(1, customer_id);
	        pstmt.setString(2, name.toUpperCase());
	        pstmt.setString(3, email);
	        pstmt.setString(4, phone);
	        pstmt.setString(5, mobile);
	        pstmt.setString(6, fax);
	        pstmt.setString(7, tin);
	        pstmt.setString(8, address);
	        pstmt.setString(9, city);
	        pstmt.setString(10, userid);
	        pstmt.setString(11, password);
	        pstmt.setString(12, state);
	        pstmt.setString(13, region);
            pstmt.setString(14, status);
            pstmt.setInt(15, custId);
            pstmt.setInt(16, systemId);
            pstmt.setInt(17, userId);
	        int inserted = pstmt.executeUpdate();
	        if (inserted > 0) {
	            message = "Saved Successfully";
	        }
	    }}
	        } catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	        DBConnection.releaseConnectionToDB(con, pstmt, rs);
	    }
	    return message;
	}

	public String modifyCustomerInformation(int custId, String customer_id,String name,String email,String phone,String mobile,String fax,String tin,String address,String city,String userid,String password,String state,String region,String status,int systemId,int uniqueId,int userId) {
	    Connection con = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
	    String message = "";
	    try {
	        con = DBConnection.getConnectionToDB("AMS");
	        pstmt = con.prepareStatement(BookingCustomerStatements.CHECK_IF_USER_ID_ALREADY_EXISTS+" and ID!=? ");
	        pstmt.setString(1, userid);
	        pstmt.setInt(2, uniqueId);
	        rs = pstmt.executeQuery();
	        if (rs.next()) {
	            message = "User Id Already Exists";
	        } else {
	        	
	        	pstmt = con.prepareStatement(BookingCustomerStatements.CHECK_IF_CUSTOMER_NAME_ALREADY_EXISTS+" and ID!=? ");
		        pstmt.setString(1, name.toUpperCase());
		        pstmt.setInt(2, custId);
		        pstmt.setInt(3, systemId);
		        pstmt.setInt(4, uniqueId);
		        rs = pstmt.executeQuery();
		        if (rs.next()) {
		            message = "Customer Name Already Exists";
		        }else {
	        pstmt = con.prepareStatement(BookingCustomerStatements.UPDATE_CUSTOMER_INFORMATION);
	        pstmt.setString(1, customer_id);
	        pstmt.setString(2, name.toUpperCase());
	        pstmt.setString(3, email);
	        pstmt.setString(4, phone);
	        pstmt.setString(5, mobile);
	        pstmt.setString(6, fax);
	        pstmt.setString(7, tin);
	        pstmt.setString(8, address);
	        pstmt.setString(9, city);
	        pstmt.setString(10, userid);
	        pstmt.setString(11, password);
	        pstmt.setString(12, state);
	        pstmt.setString(13, region);
            pstmt.setString(14, status);
            pstmt.setInt(15, userId);
            pstmt.setFloat(16, systemId);
            pstmt.setInt(17, custId);
	        pstmt.setInt(18, uniqueId);
	        int updated = pstmt.executeUpdate();
                    if (updated > 0) {
                         message = "Updated Successfully";
                    }
	    }
	    }
	    }catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	    	DBConnection.releaseConnectionToDB(con, pstmt, rs);
	        
	    }
	    return message;
	}
	
	public JSONArray getDealers(int systemId) {
		
		JSONArray jsonArray = new JSONArray(); 
		JSONObject obj1 = null;
		Connection con = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
	    
		 try
	        {
			 	
			    con = DBConnection.getConnectionToDB("AMS");
	            pstmt=con.prepareStatement(BookingCustomerStatements.GET_DEALERS);
	            pstmt.setInt(1,systemId);
	            rs=pstmt.executeQuery();
	            obj1 = new JSONObject();
	            obj1.put("DealerId", "0") ;
	            obj1.put("DealerName", "ALL");
	            jsonArray.put(obj1);
	            while(rs.next())
	            {
	            	obj1 = new JSONObject();
	 	   			obj1.put("DealerId",rs.getString("DealerId"));
	 	   			obj1.put("DealerName", rs.getString("DealerName"));
	 	   	        jsonArray.put(obj1);
	            } // end of while rs
	        }
		 catch(Exception e)
		 {
			 e.printStackTrace(); 
		 }
		 finally
	     {
			 DBConnection.releaseConnectionToDB(con, pstmt, rs);
	     }
	        return jsonArray;
	  }
	
	public ArrayList < Object > getConsignmentTrackingUsageReport(int dealerId, int systemid,int offSet,String startDate,String endDate){
		JSONArray JsonArray = new JSONArray();
	    JSONObject JsonObject = null;
	    Connection con = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
		ArrayList<String> ConsignmentHeadersList = new ArrayList<String>();
		ArrayList<ReportHelper> ConsignmentReportsList = new ArrayList<ReportHelper>();
		ReportHelper finalreporthelper = new ReportHelper();
		ArrayList<Object> ConsignmentFinalList = new ArrayList<Object>();
		
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
		SimpleDateFormat sdff = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
		
		ConsignmentHeadersList.add("SLNO");
		ConsignmentHeadersList.add("Dealer Name");
		ConsignmentHeadersList.add("Customer Name");
		ConsignmentHeadersList.add("Consignment Number");
		ConsignmentHeadersList.add("Search DateTime");
			
		try{
			int count = 0;
			con = DBConnection.getConnectionToDB("AMS");
			if(dealerId==0){
				pstmt = con.prepareStatement(BookingCustomerStatements.GET_CONSIGNMENT_TRACKING_DETAILS_FOR_ALL_DEALERS);
	            pstmt.setInt(1, offSet);
	            pstmt.setInt(2, systemid);
	            pstmt.setInt(3, offSet);
	            pstmt.setString(4, startDate);
	            pstmt.setInt(5, offSet);
	            pstmt.setString(6, endDate);
	            rs = pstmt.executeQuery();
			}
			else{
	            pstmt = con.prepareStatement(BookingCustomerStatements.GET_CONSIGNMENT_TRACKING_DETAILS);
	            pstmt.setInt(1, offSet);
	            pstmt.setInt(2, systemid);
	            pstmt.setInt(3, dealerId);
	            pstmt.setInt(4, offSet);
	            pstmt.setString(5, startDate);
	            pstmt.setInt(6, offSet);
	            pstmt.setString(7, endDate);
	            rs = pstmt.executeQuery();
			}
	        while (rs.next()) {
	            JsonObject = new JSONObject();
	            count++;
	        	ArrayList<Object> informationList = new ArrayList<Object>();
	        	ReportHelper reporthelper = new ReportHelper();
							
	        	JsonObject.put("slnoIndex", count);
	        	informationList.add(count);
			   	                        
 	            JsonObject.put("dealerNameDataIndex", rs.getString("DealerName"));
 	           informationList.add(rs.getString("DealerName"));
 	          
	            JsonObject.put("customerNameDataIndex", rs.getString("NAME"));
	            informationList.add(rs.getString("NAME"));
	           
	            JsonObject.put("consignmentNoDataIndex", rs.getString("CONSIGNMENT_NO"));
	            informationList.add(rs.getString("CONSIGNMENT_NO"));
	           
	            JsonObject.put("searchDateTimeDataIndex",sdf.format(rs.getTimestamp("SEARCH_DATETIME")));
	            informationList.add(sdff.format(rs.getTimestamp("SEARCH_DATETIME")));
	            
	            JsonArray.put(JsonObject);
	            reporthelper.setInformationList(informationList);
	            ConsignmentReportsList.add(reporthelper);
	            
	            
	           
	    	}
	      
	        ConsignmentFinalList.add(JsonArray);
	        finalreporthelper.setReportsList(ConsignmentReportsList);
			finalreporthelper.setHeadersList(ConsignmentHeadersList);
			ConsignmentFinalList.add(finalreporthelper);
			
		} catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	        DBConnection.releaseConnectionToDB(con, pstmt, rs);
	    }
	    return ConsignmentFinalList;
	}
	
	
	public String checkLoginDetails(String userId,String password,int systemId) {
	    Connection con = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
	    String message = "";
	           
	    try {
	        con = DBConnection.getConnectionToDB("ADMINISTRATOR");
	        pstmt = con.prepareStatement(BookingCustomerStatements.CHECK_IF_USER_ID_ALREADY_EXISTS_FOR_LOGIN);
	        pstmt.setString(1, userId);
	        pstmt.setString(2, password);
	        pstmt.setInt(3, systemId);
	        rs =  pstmt.executeQuery();
	        if(rs.next())
	        {
	        	message = "Valid";
	        }else
	        {
	        	message = "UserName/Password Not Valid";
	        }
	        
	    } catch (Exception e) {
	        e.printStackTrace();
	       
	    } finally {
	        DBConnection.releaseConnectionToDB(con, pstmt, rs);
	    }
	    return message;
	}
	
	public JSONArray toGetLoginDetailsData(String userId) {
	    Connection con = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
	    JSONObject obj1 = null;  
	    JSONArray JsonArray = null;
	    try {
	    	JsonArray = new JSONArray();
	        con = DBConnection.getConnectionToDB("ADMINISTRATOR");
	        pstmt = con.prepareStatement(BookingCustomerStatements.CHECK_LOGIN_DETAILS);
	        pstmt.setString(1, userId);
	        rs =  pstmt.executeQuery();
	        if(rs.next())
	        {
	        	  obj1 = new JSONObject();
		          obj1.put("custName", rs.getString("NAME"));
		          obj1.put("bookingCustomerName", rs.getString("BOOKING_CUSTOMER_NAME"));
		          obj1.put("bookingCustomerId", rs.getString("ID"));
		          obj1.put("systemId", rs.getString("SYSTEM_ID"));
		          obj1.put("custId", rs.getString("CUSTOMER_ID"));
		          obj1.put("region", rs.getString("REGION"));
		          JsonArray.put(obj1);
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	        DBConnection.releaseConnectionToDB(con, pstmt, rs);
	    }
	    return JsonArray;
	}	

	
}
