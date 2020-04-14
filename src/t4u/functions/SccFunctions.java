package t4u.functions;

import java.net.InetAddress;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.text.SimpleDateFormat;

import org.json.JSONArray;
import org.json.JSONObject;

import t4u.common.DBConnection;
import t4u.statements.CommonStatements;
import t4u.statements.SccStatements;


/** 
 * @author Prasanna M R
 *  
 * */
public class SccFunctions {

	
	/**
	 * This Method is used to get all SCC Associated Device Details Based on ClientId and SystemId
	 * This Method also includes the currently associated AssetNo from dbo.Vehicle_association Table
	 * 
	 * @param systemId	 
	 * @param customerId
	 * @return JSONArray of SCC Master Details
	 * 
	 * */
	SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	public JSONArray getSccMasterDetails(int systemId, int customerId,int userId) {
		JSONArray JsonArray = new JSONArray();
		JSONObject JsonObject = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;		
		try {
			int count = 0;
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(SccStatements.GET_SCC_MASTER_DATA);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, customerId);
			pstmt.setInt(3, userId);
			pstmt.setInt(4, systemId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				JsonObject = new JSONObject();
				count++;
				JsonObject.put("slnoIndex", count);
				JsonObject.put("sccIdDataIndex", rs.getString("UID"));
				JsonObject.put("unitNoDataIndex", rs.getString("UNIT_NO"));
				JsonObject.put("vehicleNoDataIndex", rs.getString("Registration_no"));
				JsonObject.put("macAddDataIndex", rs.getString("BT_MAC_ADDRESS"));
				JsonObject.put("reorderLevelDataIndex", rs.getString("INTERVAL"));
				JsonObject.put("associatedDate", rs.getString("ASSOCIATED_DATE"));	     
				JsonObject.put("associatedBy", rs.getString("ASSOCIATED_BY"));	         
				JsonObject.put("modifiedDate", rs.getString("MODIFIED_DATE"));	         
				JsonObject.put("modifiedBy", rs.getString("MODIFIED_BY"));	        
				JsonObject.put("remarks", rs.getString("REMARKS"));	   
				JsonArray.put(JsonObject);
			}

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return JsonArray;
	}
	
	
	/**
	 * This method is used to associate new SCC to a unit No and saved these details in SCC_MASTER TABLE
	 *  before inserting we checking the sccId is already exist and if not it will associate and
	 *  gives Success message other gives error message 
	 * 
	 *  @param sccId
	 *  @param unitNo
	 *  @param reorderLevel
	 *  @param associatedby
	 *  @param remarks
	 *  @param systemId
	 *  @param customerId
	 *  @return String of Success Message or Failure Message
	 *  
	 * */

	public String associateNewSccDevice(String sccId,String unitNo,int reorderLevel,int associatedby,
			String remarks,int systemId, int customerId) {

		Connection con = null;
		PreparedStatement pstmt = null;
		PreparedStatement pstmtc = null;
		ResultSet rs = null;
		String msg="Error";
		int packetNo=0;
		int update=0;
		String mobileNo=null,regNo=null;
		try {	      
			con = DBConnection.getConnectionToDB("AMS");	        
			pstmtc = con.prepareStatement(SccStatements.CHECK_FOR_EXISTENCE);
			pstmtc.setString(1,sccId.toUpperCase().trim());
			rs = pstmtc.executeQuery();
			if(!rs.next()){
				pstmt = con.prepareStatement(SccStatements.GET_VEHICLE_MOBILE_NUM);
				pstmt.setString(1,unitNo);
				ResultSet rs1 = pstmt.executeQuery();
				if (rs1.next()) {
						mobileNo = rs1.getString("MOBILE_NUMBER");
						regNo = rs1.getString("REGISTRATION_NO");
				}
				rs1.close();
				
				pstmt = con.prepareStatement(SccStatements.INSERT_INTO_SCC_UNIT_ASSOC);
				pstmt.setString(1,sccId);
				pstmt.setString(2,unitNo);	       
				pstmt.setInt(3,reorderLevel);
				pstmt.setInt(4,associatedby);
				pstmt.setInt(5,systemId);
				pstmt.setInt(6,customerId);
				pstmt.setString(7,remarks);	
				update = pstmt.executeUpdate();
				
				pstmt = con.prepareStatement(SccStatements.DELETE_SCC_DATA_OUT);
				pstmt.setString(1,unitNo);
				update = pstmt.executeUpdate();
				
				pstmt = con.prepareStatement(SccStatements.GET_MAX_PACKET_NO_SCC);
				rs1 = pstmt.executeQuery();
				if (rs1.next()) {
					if (rs1.getString("PACKET_NO") != null) {
						packetNo = rs1.getInt("PACKET_NO");
					}
				}
				rs1.close();

				pstmt = con.prepareStatement(SccStatements.INSERT_OTA_DETAILS_SCC);
				pstmt.setInt(1, packetNo);
				pstmt.setString(2, unitNo);
				pstmt.setString(3, "SCC_CN");
				pstmt.setString(4, "SET");
				pstmt.setString(5, sccId+","+regNo);
				pstmt.setString(6, "N");
				pstmt.setInt(7, 9);			// Unit type is Cellocator
				pstmt.setString(8, InetAddress.getLocalHost().getHostAddress());
				pstmt.setString(9, mobileNo);       
				update = pstmt.executeUpdate();
				
				if(update>0){
					msg="SCC Device Associated Successfully";
				}
			}else{
				msg="SCC Device with ID "+sccId+" has already exists in the platform";
			}

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
			DBConnection.releaseConnectionToDB(null, pstmtc, null);
		}
		return msg;
	}

	/**
	 *  This method is used to modify the associated SCC Details
	 * 
	 *  @param sccId
	 *  @param unitNo
	 *  @param reorderLevel
	 *  @param associatedby
	 *  @param remarks
	 *  @param systemId
	 *  @param customerId
	 *  @return String of Success Message or Failure Message
	 *  
	 * */
	public String modifySccDeviceAssociation(String sccId,String unitNo,int reorderLevel,int modifiedBy,
			String status,int systemId, int customerId) {

		Connection con = null;
		PreparedStatement pstmt = null;			
		ResultSet rs = null;
		String msg="Error";
		int update=0,packetNo=0;
		String mobileNo=null;
		try {	      
			con = DBConnection.getConnectionToDB("AMS");      
			pstmt = con.prepareStatement(SccStatements.UPDATE_SCC_UNIT_ASSOC);
			pstmt.setInt(1,reorderLevel);
			pstmt.setString(2,status);
			pstmt.setInt(3,modifiedBy);
			pstmt.setString(4,unitNo);	      
			pstmt.setString(5,sccId);			
			pstmt.setInt(6,systemId);
			pstmt.setInt(7,customerId);			   
			update = pstmt.executeUpdate();
			
			pstmt = con.prepareStatement(SccStatements.DELETE_SCC_DATA_OUT);
			pstmt.setString(1,unitNo);
			update = pstmt.executeUpdate();
			
			pstmt = con.prepareStatement(SccStatements.GET_VEHICLE_MOBILE_NUM);
			pstmt.setString(1,unitNo);
			ResultSet rs1 = pstmt.executeQuery();
			if (rs1.next()) {
					mobileNo = rs1.getString("MOBILE_NUMBER");
			}
			rs1.close();
			 
			pstmt = con.prepareStatement(SccStatements.GET_MAX_PACKET_NO_SCC);
			rs1 = pstmt.executeQuery();
			if (rs1.next()) {
				if (rs1.getString("PACKET_NO") != null) {
					packetNo = rs1.getInt("PACKET_NO");
				}
			}
			rs1.close();
			
			pstmt = con.prepareStatement(SccStatements.INSERT_OTA_DETAILS_SCC);
			pstmt.setInt(1, packetNo);
			pstmt.setString(2, unitNo);
			pstmt.setString(3, "SCC_CT"); // To change heartbeat interval
			pstmt.setString(4, "SET");
			pstmt.setString(5, sccId+","+reorderLevel);
			pstmt.setString(6, "N");
			pstmt.setInt(7, 9);			// Unit type is Cellocator
			pstmt.setString(8, InetAddress.getLocalHost().getHostAddress());
			pstmt.setString(9, mobileNo);       
			update = pstmt.executeUpdate();
			
//			packetNo=packetNo+1;
//			pstmt = con.prepareStatement(SccStatements.INSERT_OTA_DETAILS_SCC);
//			pstmt.setInt(1, packetNo);
//			pstmt.setString(2, unitNo);
//			pstmt.setString(3, "SCC_FL");
//			pstmt.setString(4, "SET");
//			pstmt.setString(5, sccId);
//			pstmt.setString(6, "N");
//			pstmt.setInt(7, 9);			// Unit type is Cellocator
//			pstmt.setString(8, InetAddress.getLocalHost().getHostAddress());
//			pstmt.setString(9, mobileNo);       
//			update = pstmt.executeUpdate();
			
			if(update>0){
				msg="SCC Device Modified Successfully";
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return msg;
	}
	
	
	/**
	 *  This method is used to Delete the associated SCC Details before 
	 *  Deleting it will insert to History Table 
	 * 
	 *  @param sccId
	 *  @param unitNo
	 *  @param systemId
	 *  @param customerId
	 *  @return String of Success Message or Failure Message
	 *  
	 * */

	public String deleteAssociatedDevice(String sccId,String unitNo,int systemId, int customerId) {
		Connection con = null;
		PreparedStatement pstmt = null;	
		PreparedStatement pstmtD = null;
		ResultSet rs = null;
		String msg="Error";
		int delete=0;
		try {	      
			con = DBConnection.getConnectionToDB("AMS");   			     
			pstmt = con.prepareStatement(SccStatements.MOVE_TO_HISTORY);			
			pstmt.setString(1,sccId);
			pstmt.setString(2,unitNo);	  
			pstmt.setInt(3,systemId);
			pstmt.setInt(4,customerId);
			int update = pstmt.executeUpdate();
			if(update>0){
				pstmtD = con.prepareStatement(SccStatements.DELETE_FROM_SCC_UNIT_ASSOC);			
				pstmtD.setString(1,sccId);
				pstmtD.setString(2,unitNo);	 
				pstmtD.setInt(3,systemId);
				pstmtD.setInt(4,customerId);
				delete=pstmtD.executeUpdate();
			}
			
			pstmt = con.prepareStatement(SccStatements.MOVE_TO_HISTORY_MASTER);			
			pstmt.setString(1,sccId);
			pstmt.setString(2,unitNo);	  
			pstmt.setInt(3,systemId);
			pstmt.setInt(4,customerId);
			update = pstmt.executeUpdate();
			if(update>0){
				pstmtD = con.prepareStatement(SccStatements.DELETE_FROM_SCC_MASTER);			
				pstmtD.setString(1,sccId);
				pstmtD.setString(2,unitNo);	 
				pstmtD.setInt(3,systemId);
				pstmtD.setInt(4,customerId);
				delete = pstmtD.executeUpdate();
			}
			if(delete>0){
				msg="SCC Device With ID "+sccId+" has been deleted"; 
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
			DBConnection.releaseConnectionToDB(null, pstmtD, null);
		}
		return msg;
	}
	
	
	/**
	 * This Method is used in SccAssociationDetails.jsp Page for the Unit No ComboBox
	 * in this Method, we getting list of Unit No which are already associated with Asset No and 
	 * which are not associated with SCC Based on the SystemId, ClientId and UserId
	 * 
	 * @param systemId
	 * @param userId
	 * @param customerId
	 * @return JSONArray of Unit No Details
	 * 
	 * */

	public JSONArray getUnitNumber(int systemId, int userId, int customerId) {
		JSONArray JsonArray = new JSONArray();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		JSONObject obj1 = new JSONObject();
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(SccStatements.GET_UNIT_NUMBERS_FOR_SCC_MASTER);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, systemId);
			pstmt.setInt(3, customerId);
			pstmt.setInt(4, userId);
			pstmt.setInt(5, systemId);
			pstmt.setInt(6, systemId);
			pstmt.setInt(7, customerId);
			rs = pstmt.executeQuery();			
			while (rs.next()) {
				obj1 = new JSONObject();
				obj1.put("UnitNumber", rs.getString("UNIT_NUMBER"));
				obj1.put("UnitType", rs.getString("Unit_type_desc"));
				obj1.put("Manufacturer", rs.getString("Manufacture_name"));
				obj1.put("DeviceReferenceId", rs.getString("UNIT_REFERENCE_ID"));
				JsonArray.put(obj1);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return JsonArray;
	}
	
	public JSONArray getvehicleNumber(int systemId,int customerId,int userId) {
		JSONArray JsonArray = new JSONArray();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		JSONObject obj1 = new JSONObject();
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(SccStatements.GET_VEHICLE_NUMBERS_FOR_SCC_MASTER);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, customerId);
			pstmt.setInt(3, userId);
			pstmt.setInt(4, systemId);
			rs = pstmt.executeQuery();			
			while (rs.next()) {
				obj1 = new JSONObject();
				obj1.put("vehicleno", rs.getString("VehicleNo"));
				JsonArray.put(obj1);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return JsonArray;
	}
	public JSONArray getSccMasterDetailsForOTP(int systemId, int customerId,String vehicleNo) {
		//System.out.println(" systemid == "+systemId+" customerId == "+customerId+" vehicleNo == "+vehicleNo);
		JSONArray JsonArray = new JSONArray();
		JSONObject JsonObject = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;		
		try {
			int count = 0;
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(SccStatements.GET_OTP_DETAILS_LOCK);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, customerId);
			pstmt.setString(3, vehicleNo);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				JsonObject = new JSONObject();
				count++;				 
				JsonObject.put("slnoIndex", count);
				
				JsonObject.put("unitNoDataIndex", rs.getString("UNIT_NO"));
				JsonObject.put("sccIdDataIndex", rs.getString("UID"));
				JsonObject.put("otpDataIndex", rs.getString("OTP"));
				JsonObject.put("otpTypeDataIndex", rs.getString("OTP_TYPE"));
				JsonObject.put("otpStatusDataIndex", rs.getString("OTP_STATUS"));
				if(rs.getString("USED_DATETIME")==null || rs.getString("USED_DATETIME")==""|| rs.getString("USED_DATETIME").contains("1900")){
					JsonObject.put("usedTimeDataIndex", "");
				}else{	
					JsonObject.put("usedTimeDataIndex", sdf.format(rs.getTimestamp("USED_DATETIME")));
				}
				
				JsonArray.put(JsonObject);
			}
			
			pstmt = con.prepareStatement(SccStatements.GET_OTP_DETAILS);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, customerId);
			pstmt.setString(3, vehicleNo);
			pstmt.setInt(4, systemId);
			pstmt.setInt(5, customerId);
			pstmt.setString(6, vehicleNo);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				JsonObject = new JSONObject();
				count++;				 
				JsonObject.put("slnoIndex", count);
				
				JsonObject.put("unitNoDataIndex", rs.getString("UNIT_NO"));
				JsonObject.put("sccIdDataIndex", rs.getString("UID"));
				JsonObject.put("otpDataIndex", rs.getString("OTP"));
				JsonObject.put("otpTypeDataIndex", rs.getString("OTP_TYPE"));
				JsonObject.put("otpStatusDataIndex", rs.getString("OTP_STATUS"));
				if(rs.getString("USED_DATETIME")==null || rs.getString("USED_DATETIME")==""|| rs.getString("USED_DATETIME").contains("1900")){
					JsonObject.put("usedTimeDataIndex", "");
				}else{	
					JsonObject.put("usedTimeDataIndex", sdf.format(rs.getTimestamp("USED_DATETIME")));
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
	
	public JSONArray getCustomer(int SystemId,String ltsp,int customerIdlogin){
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject = new JSONObject();
		Connection conAdmin=null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		try{
			jsonArray = new JSONArray();
			jsonObject = new JSONObject();
			
			conAdmin=DBConnection.getConnectionToDB("ADMINISTRATOR");
			
				pstmt=conAdmin.prepareStatement(CommonStatements.GET_CUSTOMER);
				pstmt.setInt(1, SystemId);
			
			rs=pstmt.executeQuery();
			
			while(rs.next()){
				jsonObject = new JSONObject();
				int custId=rs.getInt("CUSTOMER_ID");
				String custName=rs.getString("NAME");			
				jsonObject.put("CustId", custId);
				jsonObject.put("CustName", custName);
				
				jsonArray.put(jsonObject);				
			}
		}catch(Exception e){
			System.out.println("Error in getCustomer "+e.toString());
		}	
		finally{
			DBConnection.releaseConnectionToDB(conAdmin, pstmt, rs);
		}	
		return jsonArray;
	}
	public JSONArray getSccLockAndUnlock(int systemId, int customerId,String vehicleNo) {
		JSONArray JsonArray = new JSONArray();
		JSONObject JsonObject = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;		
		try {
			int count = 0;
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(SccStatements.LOCK_UNLOCK_COUNT);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, customerId);
			pstmt.setInt(3, systemId);
			pstmt.setInt(4, customerId);
			pstmt.setString(5, vehicleNo);			
			rs = pstmt.executeQuery();
			while (rs.next()) {
				JsonObject = new JSONObject();
				count++;				 					
				JsonObject.put("lockcount", rs.getString("LOCK_COUNT"));
				JsonObject.put("unlockcount", rs.getString("UNLOCK_COUNT"));
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
