package t4u.functions;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.SimpleDateFormat;

import org.json.JSONArray;
import org.json.JSONObject;
import t4u.common.DBConnection;
import t4u.statements.AdwiseStatements;
public class AdwiseManagementFunction
{
	JSONArray JsonArray = null;
	JSONObject JsonObject = null;
	SimpleDateFormat ddmmyyyy = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
	SimpleDateFormat ddmmyy = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
	SimpleDateFormat yyyymmdd = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

	public JSONArray getUID(int systemId)
	{
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			JsonArray = new JSONArray();
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(AdwiseStatements.GET_UID);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				JsonObject = new JSONObject();
				JsonObject.put("UID", rs.getString("UID"));
				JsonObject.put("IMEI", rs.getString("IMEI_NO"));
				JsonArray.put(JsonObject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return JsonArray;
	}
 public String setDetails(String Ip,String UserId,String PwdID,String IntrID,String CamFldID,String portID,String camFtpId,String uid,String imei)
{
	Connection con = null;
	PreparedStatement pstmt = null;
	PreparedStatement pstmt1 = null;
	ResultSet rs = null;
	ResultSet rs1 = null;
	String message="";
	String packet_params = null;
	String packet_type=null;
	String status="";
	
	try {
		con = DBConnection.getConnectionToDB("AMS");
		String packet_mode="SET"; 
		int count;
		count=DeviceCommunicationStatus(con,imei);
		if(count==0){
			status="Device has not communicated from past 20 minutes";
			
		}
		else{
		//################  CAM FTP ############################
		if(!camFtpId.equalsIgnoreCase("badcommand"))
		{	
			packet_params=Ip+"##"+UserId+"##"+PwdID;
			packet_type="CAM_FTP";
		}else if(!CamFldID.equalsIgnoreCase("badcommand"))
		{
			String camFLD=CamFldID.trim();
			packet_params=camFLD.replaceAll(",", "##");
			packet_type="CAM_FLD";
			
		}else if(!IntrID.equalsIgnoreCase("badcommand"))
		{
			String CamIntr=IntrID.trim();
			packet_params=CamIntr.replaceAll(",", "##").toUpperCase();
			packet_type="CAM_INTR";
		}
			double packet_no=0;
			pstmt1 = con.prepareStatement(AdwiseStatements.GET_MAX_PACKET);
			rs1=pstmt1.executeQuery();
			if(rs1.next())
			{
				packet_no=rs1.getDouble(1);
			}
			packet_no=packet_no+1;
			pstmt = con.prepareStatement(AdwiseStatements.GET_PACKET_PARAMS);
			pstmt.setString(1, imei);
		//	pstmt.setString(2, packet_type);
			rs=pstmt.executeQuery();
			if(rs.next())
			{
					status="Previous Camera Command still in Progress  ";
				
			}else{
				MoveToHistory(con,imei);
				insert(con,packet_no,imei,packet_type,packet_mode,packet_params);
				status=packet_type+" Command Sent Successfully ";
			}
			
	} 
}
 catch (Exception e) {
		e.printStackTrace();
	} finally {
		DBConnection.releaseConnectionToDB(con, pstmt, rs);
		DBConnection.releaseConnectionToDB(null, pstmt1, rs1);
	}
	return status;
}

public String getDetails(String ftpGetId,String CamStatId,String camFldGetId,String uid,String imei)
{
	Connection con = null;
	PreparedStatement pstmt = null;
	PreparedStatement pstmt1 = null;
	ResultSet rs = null;
	ResultSet rs1 = null;
	String status="";
	String packet_params=null;;
	String packet_type=null;
	try {
		con = DBConnection.getConnectionToDB("AMS");
		
		String packet_mode="GET"; 
		int count;
		count=DeviceCommunicationStatus(con,imei);
		if(count==0){
			status="Device has not communicated from past 20 minutes";
			
		}
		else{
		//################  CAM FTP GET############################
		if(!ftpGetId.equalsIgnoreCase("badcommand"))
		{
			 packet_params="1";
			 packet_type="CAM_FTP_GET";
		}else if(!CamStatId.equalsIgnoreCase("badcommand")){
			 packet_params="1";
			 packet_type="CAM_STAT_GET";
		}else if(!camFldGetId.equalsIgnoreCase("badcommand")){
			 packet_params="1";
			 packet_type="CAM_FLD_GET";
		}
			double packet_no=0;
			
			pstmt1 = con.prepareStatement(AdwiseStatements.GET_MAX_PACKET);
			rs1=pstmt1.executeQuery();
			if(rs1.next())
			{
				packet_no=rs1.getDouble(1);
			}
			packet_no=packet_no+1;
			pstmt = con.prepareStatement(AdwiseStatements.GET_PACKET_PARAMS);
			pstmt.setString(1, imei);
		//	pstmt.setString(2, packet_type);
			rs=pstmt.executeQuery();
			if(rs.next())
			{
					status="Previous Camera Command Still in Progress ";
				
			}else{
				MoveToHistory(con,imei);
				status=insert(con,packet_no,imei,packet_type,packet_mode,packet_params);
			}
	}
}
catch (Exception e) {
		e.printStackTrace();
	} finally {
		DBConnection.releaseConnectionToDB(con, pstmt, rs);
		DBConnection.releaseConnectionToDB(null, pstmt1, rs1);
	}
	return status;
}
	public String insert(Connection con,double packet_no,String imei,String packet_type,String packet_mode,String packet_params)
	{
		PreparedStatement pstmt = null;
		String message="";
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(AdwiseStatements.INSERT_DETAILS);
			pstmt.setDouble(1,packet_no );
			pstmt.setString(2, imei);
			pstmt.setString(3, packet_type);
			pstmt.setString(4, packet_mode);
			pstmt.setString(5, packet_params);
			pstmt.setString(6, "N");	
			pstmt.setString(7, "0");
			pstmt.setString(8, "50");
			int result = pstmt.executeUpdate();
			if (result > 0) {
				if(packet_type.equalsIgnoreCase("CAM_FLD")){
					message = "Command Saved and will be processed soon";
				}else{
					message = "Command Sent Successfully";
				}
			}
			else{
				message="Error While Saving Records";
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		finally {
			DBConnection.releaseConnectionToDB(con, pstmt,null);
		}
		return message;
	}	
	public void MoveToHistory(Connection con,String imei)
	{
		PreparedStatement pstmt = null;
		PreparedStatement pstmt1 = null;
		ResultSet rs = null;
		ResultSet rs1 = null;
		try {
			
			
			pstmt = con.prepareStatement(AdwiseStatements.SELECT_FROM_DATA_OUT);
			pstmt.setString(1, imei);
			rs=pstmt.executeQuery();
			String packet_type="";
			String UnitType="";
			while(rs.next())
			{
				packet_type=rs.getString("PACKET_TYPE");
				UnitType=rs.getString("UNIT_TYPE");	
				
				pstmt1 = con.prepareStatement(AdwiseStatements.INSERT_INTO_HISTORY);
				pstmt1.setString(1, imei);
				pstmt1.setString(2, packet_type);
				pstmt1.setString(3, UnitType);
				int result=pstmt1.executeUpdate();
				if(result>0)
				{
					pstmt=con.prepareStatement(AdwiseStatements.DELETE_FROM_DATA_OUT);
					pstmt.setString(1, imei);
					pstmt.setString(2, packet_type);
					pstmt.setString(3,UnitType);
					int res=pstmt.executeUpdate();
					if(res>0)
					{
						System.out.println("Data Deleted from Data_Out Table ");	
					}
				}
				else
				{
					System.out.println("Data Not Inserted into History Table");
				}
		}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		finally {
			DBConnection.releaseConnectionToDB(null, pstmt,rs);
			DBConnection.releaseConnectionToDB(null, pstmt1,rs1);
		}
	}
	public JSONArray getDetails(String imei)
	{
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int slcount = 0; 
		String attr=null,attrName=null;
		
		try {
			JsonArray = new JSONArray();
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(AdwiseStatements.GET_DETAILS);
			pstmt.setString(1, imei);
			rs = pstmt.executeQuery();
			String voltageVariable="";
			String voltage = "";
			String powerFlage = "";
			String voltageTime="";
			String powerTime="";
			while(rs.next())
			{
				
				JsonObject = new JSONObject();
				slcount++;
				JsonObject.put("slnoIndex", slcount);
				JsonObject.put("unitNoIndex", rs.getString("UNIT_NO"));
				attr=rs.getString("ATTR");
				if(attr.equalsIgnoreCase("CAM_FTP_GET")){
					attrName="Get Camera FTP";
				}else if(attr.equalsIgnoreCase("CAM_STAT_GET")){
					attrName="Get Camera Status";
				}else if(attr.equalsIgnoreCase("CAM_FLD_GET")){
					attrName="Get Camera Folders";
				}else if(attr.equalsIgnoreCase("CAM_FTP")){
					attrName="Camera FTP";
				}else if(attr.equalsIgnoreCase("CAM_INTR")){
					attrName="Set Camera Interval";
				}else if(attr.equalsIgnoreCase("CAM_RESET")){
					attrName="Reset Camera";
				}else if(attr.equalsIgnoreCase("CAM_FLD_SET")){
					attrName="Set Camera Folders";
				}
					
				JsonObject.put("attributeIndex", attrName);
				JsonObject.put("descriptionIndex", rs.getString("DESCR"));
				JsonObject.put("timeIndex", ddmmyyyy.format(yyyymmdd.parse(rs.getString("UPDATED_GPSTIME"))));
				JsonArray.put(JsonObject);
				
				voltage = rs.getString("MAIN_BATTERY_VOLTAGE") +"&nbsp;" +"V";
				voltageVariable = "MAIN BATTERY VOLTAGE";
				voltageTime=rs.getString("GPS_DATETIME");
				
//				voltage = rs.getString("IB_VOLTAGE") +"V";
//				voltageVariable = "INTERNAL BATTERY VOLTAGE";
//				voltageTime=rs.getString("GPS_DATETIME");
				
			if(rs.getString("POWER").equals("1")) {
				powerFlage="ON";
				powerTime=rs.getString("GPS_DATETIME");
			}else{
				powerFlage="OFF";
				powerTime=rs.getString("GPS_DATETIME");
			}
		}
			if(slcount > 0){
				JsonObject = new JSONObject();
				
				slcount++;
				JsonObject.put("slnoIndex", "");
				JsonObject.put("unitNoIndex", "");
				JsonObject.put("attributeIndex",voltageVariable);
				JsonObject.put("descriptionIndex", voltage);
				JsonObject.put("timeIndex", ddmmyyyy.format(yyyymmdd.parse(voltageTime)));
				JsonArray.put(JsonObject);
				
				slcount++;
				JsonObject = new JSONObject();
				JsonObject.put("slnoIndex", "");
				JsonObject.put("unitNoIndex", "" );
				JsonObject.put("attributeIndex","POWER");
				JsonObject.put("descriptionIndex", powerFlage);
				JsonObject.put("timeIndex", ddmmyyyy.format(yyyymmdd.parse(powerTime)));
				JsonArray.put(JsonObject); 
				
			}
		
	}catch (Exception e) {
		e.printStackTrace();
	} finally {
		DBConnection.releaseConnectionToDB(con, pstmt, rs);
	}
		return JsonArray;
	}
	public int getCameraDetails(String uid)
	{
	Connection con = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	int count=0;
	try {
		con = DBConnection.getConnectionToDB("ADWISE");
		pstmt = con.prepareStatement(AdwiseStatements.GET_CAMERA_DETAILS);
		pstmt.setString(1, uid);
		rs = pstmt.executeQuery();
		if(rs.next())
		{
			count=Integer.parseInt(rs.getString("CAMERA_NUMBERS"));
		}
	}
		catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		
		return count;
	}
	
	
	public int DeviceCommunicationStatus(Connection con,String imei)
	{
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	int count=0;
	try {
		con = DBConnection.getConnectionToDB("AMS");
		pstmt = con.prepareStatement(AdwiseStatements.GET_COMMUNICATION_STATUS);
		pstmt.setString(1, imei);
		rs = pstmt.executeQuery();
		if(rs.next())
		{
			count=Integer.parseInt(rs.getString("DEVICE_COMMUNICATION"));
		}
	}
		catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		
		return count;
	}
	
}
