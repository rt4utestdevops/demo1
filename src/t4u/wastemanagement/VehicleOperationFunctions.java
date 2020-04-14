package t4u.wastemanagement;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

import org.json.JSONArray;
import org.json.JSONObject;

import t4u.beans.ReportHelper;
import t4u.common.DBConnection;
import t4u.common.LocationLocalization;
import t4u.functions.CommonFunctions;

public class VehicleOperationFunctions {
	
	Connection con = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	CommonFunctions cf = new CommonFunctions();
	LocationLocalization locationLocalization = new LocationLocalization();


	public JSONArray getVehicleNo(int systemid, int clientId,int userId) {
		
		JSONObject obj = null;
		JSONArray jsonArray = new JSONArray();
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(VehicleOperationStatements.GET_VEHICLE_NO);
			pstmt.setInt(1, systemid);
			pstmt.setInt(2, clientId);
			pstmt.setInt(3, userId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				obj = new JSONObject();
				obj.put("vehicleNo",rs.getString("VehicleNo"));
				obj.put("assetType",rs.getString("AssetType"));
				obj.put("driverName",rs.getString("DriverName"));
				obj.put("driverContactNo",rs.getString("DriverContactNo"));
				jsonArray.put(obj);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jsonArray;
	}
	
	  public String insertVehicleDetails(int systemId,int customerId,int userId, String vehicleNo, String vehicleType, String driverName,String driverContactNo,
			  String district, String department, String governate, String deptContactNo, String deptSupervisor, String contractor, String deptManager) {
		  
			String message = null;
			try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(VehicleOperationStatements.INSERT_VEHICLE_DETAILS);
			pstmt.setString(1, vehicleNo);
			pstmt.setString(2, vehicleType);
			pstmt.setString(3, driverName);
			pstmt.setString(4, driverContactNo);
			pstmt.setString(5, district);
			pstmt.setString(6, department);
			pstmt.setString(7, governate);
			pstmt.setString(8, deptContactNo);
			pstmt.setString(9, deptSupervisor);
			pstmt.setString(10, contractor);
			pstmt.setString(11, deptManager);
			pstmt.setInt(12, systemId);
			pstmt.setInt(13, customerId);
			pstmt.setInt(14, userId);
			int inserted = pstmt.executeUpdate();
			if (inserted > 0) {
			message = "Saved Successfully";
			}
			else{
			message="Error While Saving Records";
			}
			} catch (Exception e) {
			e.printStackTrace();
			} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		    }
			return message;
   }

	public String modifyVehicleDetails(int systemId,int customerId,int userId, String vehicleNo, String vehicleType, String driverName,String driverContactNo,
			  String district, String department, String governate, String deptContactNo, String deptSupervisor, String contractor, String deptManager, int id) {
		
		String message = "";
		try {
		con = DBConnection.getConnectionToDB("AMS");
		
		pstmt = con.prepareStatement(VehicleOperationStatements.UPDATE_VEHICLE_DETAILS);
		pstmt.setString(1, vehicleNo);
		pstmt.setString(2, vehicleType);
		pstmt.setString(3, driverName);
		pstmt.setString(4, driverContactNo);
		pstmt.setString(5, district);
		pstmt.setString(6, department);
		pstmt.setString(7, governate);
		pstmt.setString(8, deptContactNo);
		pstmt.setString(9, deptSupervisor);
		pstmt.setString(10, contractor);
		pstmt.setString(11, deptManager);
		pstmt.setInt(12, userId);
		pstmt.setInt(13, systemId);
		pstmt.setInt(14, customerId);
		pstmt.setInt(15, id);
		int updated = pstmt.executeUpdate();
		if (updated > 0) {
		message = "Updated Successfully";
		}
		
		} catch (Exception e) {
		e.printStackTrace();
		} finally {
		DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return message;
	}		
		public ArrayList < Object > getVehicleDetails(int systemId, int customerId,String language) {
		   
			JSONArray JsonArray = new JSONArray();
		    JSONObject JsonObject = null;
		   
		    ArrayList<ReportHelper> reportsList = new ArrayList<ReportHelper>();
			ArrayList<String> headersList = new ArrayList<String>();
			ReportHelper finalreporthelper = new ReportHelper();
		    ArrayList < Object > finlist = new ArrayList < Object > ();
		    try {
		    	headersList.add(cf.getLabelFromDB("SLNO", language));
		    	headersList.add(cf.getLabelFromDB("Id", language));
		    	headersList.add(cf.getLabelFromDB("Asset_Number", language));
		    	headersList.add(cf.getLabelFromDB("Asset_Type", language));
		    	headersList.add(cf.getLabelFromDB("Driver_Name", language));
		    	headersList.add(cf.getLabelFromDB("Driver_Number", language));
		    	headersList.add(cf.getLabelFromDB("District", language));
		    	headersList.add(cf.getLabelFromDB("Department", language));
		    	headersList.add(cf.getLabelFromDB("Governate", language));
		    	headersList.add(cf.getLabelFromDB("Department_Office_Contact_Number", language));
		    	headersList.add(cf.getLabelFromDB("Department_Supervisor", language));
		    	headersList.add(cf.getLabelFromDB("Contractor", language));
		    	headersList.add(cf.getLabelFromDB("Department_Manager", language));
		        int count = 0;
		        con = DBConnection.getConnectionToDB("AMS");
		        pstmt = con.prepareStatement(VehicleOperationStatements.GET_VEHICLE_DETAILS);
		        pstmt.setInt(1, systemId);
		        pstmt.setInt(2, customerId);
		        rs = pstmt.executeQuery();
		        while (rs.next()) {
		        	ArrayList<Object> informationList = new ArrayList<Object>();
					ReportHelper reporthelper = new ReportHelper();
		            JsonObject = new JSONObject();
		            count++;
		            
		            informationList.add(count);
		            JsonObject.put("slnoIndex", count);
		            
		            informationList.add(rs.getString("ID"));
		            JsonObject.put("idDataIndex", rs.getString("ID"));
		            
		            informationList.add(rs.getString("ASSET_NUMBER"));
		            JsonObject.put("vehicleNoDataIndex", rs.getString("ASSET_NUMBER"));
		            
		            informationList.add(rs.getString("ASSET_TYPE"));
		            JsonObject.put("vehicleTypeDataIndex", rs.getString("ASSET_TYPE"));
		            
		            informationList.add(rs.getString("DRIVER_NAME"));
		            JsonObject.put("driverNameDataIndex", rs.getString("DRIVER_NAME"));
		            
		            informationList.add(rs.getString("DRIVER_MOBILE_NUMBER"));
		            JsonObject.put("driverContactNoDataIndex", rs.getString("DRIVER_MOBILE_NUMBER"));
		            
		            informationList.add(rs.getString("DISTRICT"));
		            JsonObject.put("districtDataIndex", rs.getString("DISTRICT"));
		            
		            informationList.add(rs.getString("DEPARTMENT"));
		            JsonObject.put("departmentDataIndex", rs.getString("DEPARTMENT"));
		            
		            informationList.add(rs.getString("GOVERNATE"));
		            JsonObject.put("governateDataIndex", rs.getString("GOVERNATE"));
		            
		            informationList.add(rs.getString("DEPT_OFFICE_NUMBER"));
		            JsonObject.put("deptOfficeContactNumberDataIndex", rs.getString("DEPT_OFFICE_NUMBER"));
		            
		            informationList.add(rs.getString("DEPT_SUPERVISOR"));
		            JsonObject.put("deptSupervisorDataIndex", rs.getString("DEPT_SUPERVISOR"));
		            
		            informationList.add(rs.getString("CONTRACTOR"));
		            JsonObject.put("ContractorDataIndex", rs.getString("CONTRACTOR"));
		            
		            informationList.add(rs.getString("DEPT_MANAGER"));
		            JsonObject.put("deptManagerDataIndex", rs.getString("DEPT_MANAGER"));
		            
		            
		            JsonArray.put(JsonObject);
		            reporthelper.setInformationList(informationList);
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
}
