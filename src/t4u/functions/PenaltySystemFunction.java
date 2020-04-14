package t4u.functions;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;

import org.json.JSONArray;
import org.json.JSONObject;

import t4u.beans.ReportHelper;
import t4u.common.DBConnection;
import t4u.statements.PenaltySystemStatement;

public class PenaltySystemFunction {
	
	Connection con = null;
	PreparedStatement pstmt = null;
	ResultSet rs =null;
	CommonFunctions cf = new CommonFunctions();
	
	public JSONArray getPenaltyDetails(int systemId,int clientId){
		
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject = null;
	    try {
			con =  DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(PenaltySystemStatement.GET_PENALTY_DETAILS);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, clientId);
			rs = pstmt.executeQuery();
			while(rs.next()){
				jsonObject = new JSONObject();
				jsonObject.put("PenaltyId", rs.getString("ID"));
				jsonObject.put("PenaltyType", rs.getString("PENALTY_TYPE"));
				jsonObject.put("Amount", rs.getString("AMOUNT"));
				jsonArray.put(jsonObject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}	
		finally{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jsonArray;
	}

	public JSONArray getVehicleDetails(int systemId, int clientId) {
		
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject = null;
	    try {
			con =  DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(PenaltySystemStatement.GET_VEHICLE_DETAILS);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, clientId);
			rs = pstmt.executeQuery();
			while(rs.next()){
				jsonObject = new JSONObject();
				jsonObject.put("AssetId", rs.getString("ID"));
				jsonObject.put("VehicleNo", rs.getString("ASSET_NUMBER"));
				jsonObject.put("VehicleType", rs.getString("ASSET_TYPE"));
				jsonObject.put("DriverName", rs.getString("DRIVER_NAME"));
				jsonObject.put("DriverMobileNo", rs.getString("DRIVER_MOBILE_NUMBER"));
				jsonObject.put("District", rs.getString("DISTRICT"));
				jsonObject.put("Department", rs.getString("DEPARTMENT"));
				jsonObject.put("Government", rs.getString("GOVERNATE"));
				jsonArray.put(jsonObject);
			}  
		} catch (Exception e) {
			e.printStackTrace();
		}	
		finally{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jsonArray;
	}
	
	public String savePenaltySystemDetails(String date,int assetId,int penaltyId,int userId,int systemId, int clientId,int offset) {
		
		PreparedStatement pstmt1 = null;
		String message = "Insertion fail try after some time";
		
	    try {
			con =  DBConnection.getConnectionToDB("AMS");
			
			pstmt1 = con.prepareStatement(PenaltySystemStatement.CHECK_PENALTY_SYSTEM);
			pstmt1.setInt(1, assetId);
			pstmt1.setInt(2, penaltyId);
			pstmt1.setInt(3, systemId);
			pstmt1.setInt(4, clientId);
			rs =  pstmt1.executeQuery();
			if(rs.next()){
				message = "Record Already Exit";
			}else{
			pstmt = con.prepareStatement(PenaltySystemStatement.SAVE_PENALTY_SYATEM_DETAILS);
			pstmt.setInt(1, offset);
			pstmt.setString(2, date);
			pstmt.setInt(3, assetId);
			pstmt.setInt(4, penaltyId);
			pstmt.setInt(5, systemId);
			pstmt.setInt(6, clientId);
			pstmt.setInt(7, userId);
			int insert = pstmt.executeUpdate();
			if(insert>0){
				message = "Inserted Successfully";
			}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}	
		finally{
			DBConnection.releaseConnectionToDB(con, pstmt, null);
			DBConnection.releaseConnectionToDB(null, pstmt1, rs);
		}
		return message;
	}
	
	public ArrayList<Object> getPenaltySystemDetails(String startDate,String endDate,int systemId, int clientId,int offset,String language) {
		
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject = null;
		int count = 0;
		
		DateFormat df = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
		DateFormat ssdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		
		ArrayList<ReportHelper> reportsList = new ArrayList<ReportHelper>();
		ArrayList<String> headersList = new ArrayList<String>();
		ReportHelper finalreporthelper = new ReportHelper();
		ArrayList<Object> penaltyDetailsFinalList = new ArrayList<Object>();

		
		headersList.add(cf.getLabelFromDB("SLNO",language));
		headersList.add(cf.getLabelFromDB("Id",language));
		headersList.add(cf.getLabelFromDB("Date",language));
		headersList.add(cf.getLabelFromDB("Asset_No",language));
		headersList.add(cf.getLabelFromDB("Asset_Type",language));
		headersList.add(cf.getLabelFromDB("Driver_Name",language));
		headersList.add(cf.getLabelFromDB("Driver_Contact_No",language));
		headersList.add(cf.getLabelFromDB("District",language));
		headersList.add(cf.getLabelFromDB("Department",language));
		headersList.add(cf.getLabelFromDB("Governate",language));
		headersList.add(cf.getLabelFromDB("Penalty_Type",language));
		headersList.add(cf.getLabelFromDB("Amount",language));
		
	    try {
			con =  DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(PenaltySystemStatement.GET_PENALTY_SYATEM_REPORT_DETAILS);
			pstmt.setInt(1, offset);
			pstmt.setInt(2, systemId);
			pstmt.setInt(3, clientId);
			pstmt.setString(4, startDate);
			pstmt.setString(5, endDate);
			rs = pstmt.executeQuery();
			while(rs.next()){
				count++;
				jsonObject = new JSONObject();
				ReportHelper reporthelper = new ReportHelper();
				ArrayList<Object> informationList = new ArrayList<Object>();
				
				jsonObject.put("slnoIndex", count);
				informationList.add(count);
				
				jsonObject.put("IndexIdDataIndex", rs.getString("ID"));
				informationList.add(rs.getString("ID"));
				
				jsonObject.put("DateDataIndex", df.format(ssdf.parse(rs.getString("DATE_TIME"))));
				
				informationList.add(df.format(ssdf.parse(rs.getString("DATE_TIME"))));
				
				jsonObject.put("VehicleNoDataIndex", rs.getString("ASSET_NUMBER"));
				informationList.add(rs.getString("ASSET_NUMBER"));
				
				jsonObject.put("VehicleTypeDataIndex", rs.getString("ASSET_TYPE"));
				informationList.add(rs.getString("ASSET_TYPE"));
				
				jsonObject.put("DriverNameDataIndex", rs.getString("DRIVER_NAME"));
				informationList.add(rs.getString("DRIVER_NAME"));
				
				jsonObject.put("DriverContactNoDataIndex", rs.getString("DRIVER_MOBILE_NUMBER"));
				informationList.add( rs.getString("DRIVER_MOBILE_NUMBER"));
				
				jsonObject.put("DistrictDataIndex", rs.getString("DISTRICT"));
				informationList.add(rs.getString("DISTRICT"));
				
				jsonObject.put("DepartmentDataIndex", rs.getString("DEPARTMENT"));
				informationList.add(rs.getString("DEPARTMENT"));
				
				jsonObject.put("GovernmentDataIndex", rs.getString("GOVERNATE"));
				informationList.add(rs.getString("GOVERNATE"));
				
				jsonObject.put("PenaltyTypeDataIndex", rs.getString("PENALTY_TYPE"));
				informationList.add(rs.getString("PENALTY_TYPE"));
				
				jsonObject.put("AmountDataIndex", rs.getString("AMOUNT"));
				informationList.add(rs.getString("AMOUNT"));
				
				jsonArray.put(jsonObject);
				reporthelper.setInformationList(informationList);
				reportsList.add(reporthelper);
			}  
			
			penaltyDetailsFinalList.add(jsonArray);
			finalreporthelper.setReportsList(reportsList);
			finalreporthelper.setHeadersList(headersList);
			penaltyDetailsFinalList.add(finalreporthelper);
			
		} catch (Exception e) {
			e.printStackTrace();
		}	
		finally{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return penaltyDetailsFinalList;
	}
	public String updatePenaltySystemDetails(int id,int penaltyId,int userId,int systemId, int clientId) {
		
		String message = "Updation fail try after some time";
	    try {
			con =  DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(PenaltySystemStatement.UPDATE_PENALTY_SYATEM_DETAILS);
			pstmt.setInt(1, penaltyId);
			pstmt.setInt(2, userId);
			pstmt.setInt(3, id);
			pstmt.setInt(4, systemId);
			pstmt.setInt(5, clientId);
			int insert = pstmt.executeUpdate();
			if(insert>0){
				message = "Updated Successfully";
			}
		} catch (Exception e) {
			e.printStackTrace();
		}	
		finally{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return message;
	}
	
}

