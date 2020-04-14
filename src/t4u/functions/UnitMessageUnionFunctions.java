package t4u.functions;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.DecimalFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;
import java.math.*;



import org.json.JSONArray;
import org.json.JSONObject;



import t4u.beans.ReportHelper;
import t4u.common.DBConnection;
import t4u.statements.UnitMessageUnionStatements;

@SuppressWarnings({"static-access","unchecked"})
public class UnitMessageUnionFunctions 
{
	SimpleDateFormat ddMMyyyyHHmmss = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
	CommonFunctions cf = new CommonFunctions();
	
	
	public JSONArray getAssetNumberList(int systemId,String customerId ,int userId) {
		PreparedStatement pstmt = null;
		Connection con = null;
		ResultSet rs = null;
		JSONArray jsonArray = new JSONArray();
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(UnitMessageUnionStatements.Get_ASSET_NUMBER_LIST);
			pstmt.setInt(1,systemId);
			pstmt.setString(2,customerId);
			pstmt.setInt(3,userId);
			rs = pstmt.executeQuery();
			//If there is record add VIEW ALL First and First Record
			if(rs.next()){
				JSONObject jsonObject = new JSONObject();
				jsonObject.put("Registration_no", "VIEW ALL");
				jsonArray.put(jsonObject);
				
				jsonObject = new JSONObject();
				jsonObject.put("Registration_no", rs.getString("ASSET_NUMBER"));
				jsonArray.put(jsonObject);
			}
			
			// Add Rest Of Records
			while (rs.next()) {
				JSONObject jsonObject = new JSONObject();
				jsonObject.put("Registration_no", rs.getString("ASSET_NUMBER"));
				jsonArray.put(jsonObject);
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jsonArray;
	}
	
	
	
	
	public ArrayList<Object> getMsgAssocReport(int customerid,int systemId,int offset,String vehicleNumber,String pageName,int userId) {
		JSONArray VMJsonArray = new JSONArray();
		JSONObject VMJsonObject = new JSONObject();
		ArrayList<String> VMHeadersList = new ArrayList<String>();
		ArrayList<ReportHelper> VMReportsList = new ArrayList<ReportHelper>();
		ReportHelper finalreporthelper = new ReportHelper();
		ArrayList<Object> VMFinalList = new ArrayList<Object>();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int count=0;
		int unique_id=0;
		String msgType = "";
		String gpsDate = "";
		String comport = "";
		String insertedTime = "";
		String commandType = "";
		String  purpose= "";
		String gridStatus = null;
		SimpleDateFormat yyyymmdd = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		
		VMHeadersList.add("SLNO");
		VMHeadersList.add("Asset Number");
		VMHeadersList.add("Message Type");
		VMHeadersList.add("Comport");
		VMHeadersList.add("Purpose");
		VMHeadersList.add("Unique Id");
		try {		
			VMJsonArray = new JSONArray();
			VMJsonObject = new JSONObject();
			con = DBConnection.getConnectionToDB("AMS");
				if(vehicleNumber.equalsIgnoreCase("VIEW ALL")){
					pstmt = con.prepareStatement(UnitMessageUnionStatements.GET_VEHICLE_MESSAGE_UNION_INFO);
					pstmt.setInt(1,systemId);
					pstmt.setInt(2,customerid);
					pstmt.setInt(3,userId);
				}else{
					pstmt = con.prepareStatement(UnitMessageUnionStatements.GET_VEHICLE_MESSAGE_UNION_INFO_REG);
					pstmt.setString(1,vehicleNumber);
				}
				
			rs = pstmt.executeQuery();
			while (rs.next()) {	
				ArrayList<Object> informationList = new ArrayList<Object>();
				ReportHelper reporthelper = new ReportHelper();
				VMJsonObject = new JSONObject();
				count++;
				vehicleNumber = rs.getString("REGISTRATION_NO");
				msgType = rs.getString("MESSAGE_TYPE");
				comport=rs.getString("COMPORT");
				purpose = rs.getString("PURPOSE");
				unique_id = rs.getInt("ID");
				
				VMJsonObject.put("slnoIndex",Integer.toString(count));
				informationList.add(Integer.toString(count));
				
				VMJsonObject.put("registrationNoDataIndex", vehicleNumber);
				informationList.add(vehicleNumber);
				
				VMJsonObject.put("msgTypeDataIndex", msgType);
				informationList.add(msgType);
				
				VMJsonObject.put("comportDataIndex",comport);
				informationList.add(comport);

				VMJsonObject.put("purposeDataIndex", purpose);
				informationList.add(purpose);
				
				VMJsonObject.put("uniqueIdDataIndex",unique_id);
				informationList.add(unique_id);
				
				VMJsonArray.put(VMJsonObject);
				reporthelper.setInformationList(informationList);
				VMReportsList.add(reporthelper);
				}
			VMFinalList.add(VMJsonArray);
			finalreporthelper.setReportsList(VMReportsList);
			finalreporthelper.setHeadersList(VMHeadersList);
			VMFinalList.add(finalreporthelper);
		
		} catch (Exception e) {
			e.printStackTrace();
			System.out.println("Error in UnitMessageUnion Functions:- getKERequestReport "+e.toString());
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return VMFinalList;
		
	
	}
	
public JSONArray getTypeList(String type,String rType) {
	JSONArray jArr = new JSONArray();
	JSONObject obj = null;
	Connection con = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	try {
		jArr = new JSONArray();
		con = DBConnection.getConnectionToDB("AMS");
		pstmt = con.prepareStatement(UnitMessageUnionStatements.GET_TYPE_SETTING);
		pstmt.setString(1, type);
		rs = pstmt.executeQuery();
		while(rs.next()){
			obj = new JSONObject();
			obj.put(rType, rs.getString("VALUE"));
			jArr.put(obj);
		}
	} catch (Exception e) {
		e.printStackTrace();
	}finally {
		DBConnection.releaseConnectionToDB(con, pstmt, rs);
	}
	return jArr;
}


public String insertUnionData(int CustomerId,int System_id,
		int userId, String registrationNo,String msgType,String comport,String purpose) {

	PreparedStatement pstmt = null;
    boolean shallInsert=true;
    int i=0;
    String message="Association Failed";
    Connection con = null;
    ResultSet rs1 = null;
	try {

		
		con = DBConnection.getConnectionToDB("AMS");
		
		pstmt = con.prepareStatement(UnitMessageUnionStatements.IS_UNION_PRESENT);
		pstmt.setString(1, registrationNo);
		pstmt.setString(2, msgType);
		pstmt.setString(3,comport );

		rs1 = pstmt.executeQuery();

		if (rs1.next()) {
			shallInsert = false;
			message="Same Message Type and Comport already present";
		}

		if (shallInsert) {
			pstmt = con.prepareStatement(UnitMessageUnionStatements.INSERT_UNIT_MSG_UNION);
			pstmt.setString(1, registrationNo);
			pstmt.setString(2, msgType);
			pstmt.setString(3, comport);
			pstmt.setString(4, purpose);
			pstmt.setInt(5, System_id);
			pstmt.setInt(6, CustomerId);
			pstmt.setInt(7, userId);
			i=pstmt.executeUpdate();
			con.close();
			pstmt.close();
		} 
		if(i>0){
			message="Associated Successfully";
		}

	} catch (SQLException e) {
		e.printStackTrace();
	}finally{
		DBConnection.releaseConnectionToDB(con, pstmt, rs1);
	}
	return message;
}

public String deleteUnionDetails(int CustomerId, int systemId, int userId,
		String registrationNo, String msgType, String comport, String purpose,int uniqueId) {
	// TODO Auto-generated method stub
	PreparedStatement pstmt = null;
    int i=0;
    String message="Deletion Failed";
    Connection con = null;
    ResultSet rs1 = null;
	try {

		
		con = DBConnection.getConnectionToDB("AMS");
		
		pstmt = con.prepareStatement(UnitMessageUnionStatements.UPDATE_USER_UNIT_MSG_UNION);
		pstmt.setInt(1, userId);
		pstmt.setString(2, registrationNo);
		pstmt.setInt(3, uniqueId);
		i=pstmt.executeUpdate();
		pstmt.close();
		
		pstmt = con.prepareStatement(UnitMessageUnionStatements.INS_HIST_UNIT_MSG_UNION);
		pstmt.setString(1, registrationNo);
		pstmt.setInt(2, uniqueId);
		i=pstmt.executeUpdate();
		pstmt.close();
		
		
			pstmt = con.prepareStatement(UnitMessageUnionStatements.DELETE_UNIT_MSG_UNION);
			pstmt.setString(1, registrationNo);
			pstmt.setString(2, msgType);
			pstmt.setInt(3, uniqueId);
			i=pstmt.executeUpdate();
			pstmt.close();
		if(i>0){
			message="Deleted Successfully";
		}

	} catch (SQLException e) {
		e.printStackTrace();
	}finally{
		DBConnection.releaseConnectionToDB(con, pstmt, rs1);
	}
	return message;
}

public String modifyUnionData(int CustomerId, int System_id, int userId,
		String registrationNo, String msgType, String comport, String purpose,
		int uniqueId) {
	// TODO Auto-generated method stub
	PreparedStatement pstmt = null;
    boolean isRecordPresent=false;
    boolean isduplicate=false;
    int i=0;
    String message="Modification Failed";
    Connection con = null;
    ResultSet rs1 = null;
	try {

		
		con = DBConnection.getConnectionToDB("AMS");
		// Check same complete record present
		
		pstmt = con.prepareStatement(UnitMessageUnionStatements.IS_UNION_UPDATE_PRESENT);
		pstmt.setString(1, registrationNo);
		pstmt.setLong(2, uniqueId);

		rs1 = pstmt.executeQuery();

		if (rs1.next()) {
			isRecordPresent = true;
			message="Can Update";
		}
		
		if(isRecordPresent){
			
//			pstmt = con.prepareStatement(UnitMessageUnionStatements.IS_UNION_PRESENT);
//			pstmt.setString(1, registrationNo);
//			pstmt.setString(2, msgType);
//			pstmt.setString(3,comport );
//
//			rs1 = pstmt.executeQuery();
//
//			if (rs1.next()) {
//				isduplicate = true;
//				message="Same Message Type and Comport already present";
//			}
			
//			if(!isduplicate){
			//Update UserId and then move to history
			pstmt = con.prepareStatement(UnitMessageUnionStatements.UPDATE_USER_UNIT_MSG_UNION);
			pstmt.setInt(1, userId);
			pstmt.setString(2, registrationNo);
			pstmt.setInt(3, uniqueId);
			i=pstmt.executeUpdate();
			pstmt.close();
			
			pstmt = con.prepareStatement(UnitMessageUnionStatements.INS_HIST_UNIT_MSG_UNION);
			pstmt.setString(1, registrationNo);
			pstmt.setInt(2, uniqueId);
			i=pstmt.executeUpdate();
			pstmt.close();
	
	
				pstmt = con.prepareStatement(UnitMessageUnionStatements.UPDATE_UNION_MSG);
				pstmt.setString(1, msgType);
				pstmt.setString(2, comport);
				pstmt.setString(3, purpose);
				pstmt.setInt(4, userId);
				pstmt.setString(5, registrationNo);
				pstmt.setInt(6, System_id);
				pstmt.setLong(7,uniqueId);
				i=pstmt.executeUpdate();
				con.close();
				pstmt.close();
			if(i>0){
				message="Modified Successfully";
			}
//			}
		}
	} catch (SQLException e) {
		e.printStackTrace();
	}finally{
		DBConnection.releaseConnectionToDB(con, pstmt, rs1);
	}
	return message;
}

	
}
