package t4u.functions;
import java.io.File;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Collections;
import java.util.Comparator;
import java.util.Date;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;
import java.util.Set;
import java.util.TreeSet;

import org.apache.commons.io.FileUtils;
import org.json.JSONArray;
import org.json.JSONObject;

import com.t4u.activity.VehicleActivity;
import com.t4u.activity.VehicleSummaryBean;

import t4u.beans.PTDashboardVehicleBean;
import t4u.beans.ReportHelper;
import t4u.common.ApplicationListener;
import t4u.common.DBConnection;
import t4u.statements.ContainerCargoManagementStatements;
public class ContainerCargoManagementFunctions {

	SimpleDateFormat ddmmyyyy = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
	SimpleDateFormat ddmmyy = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
	SimpleDateFormat yyyymmdd = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	SimpleDateFormat monthFormat = new SimpleDateFormat("MMM yyyy");
	DecimalFormat doubleDecimalFormat = new DecimalFormat("0.00");
	CommonFunctions commonFunctions = new CommonFunctions();
	
    public JSONArray getClientNames(int systemid, int clientid) {
        JSONArray jsonArray = new JSONArray();
        Connection con = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String stmt = "";
        try {
            con = DBConnection.getConnectionToDB("AMS");
            stmt = ContainerCargoManagementStatements.GET_CLIENT_NAMES;
            if (clientid > 0) {
                stmt = stmt + " and CustomerId=" + clientid;
            }
            stmt = stmt + " order by CustomerName";
            pstmt = con.prepareStatement(stmt);
            pstmt.setInt(1, systemid);
            rs = pstmt.executeQuery();
            JSONObject obj1 = new JSONObject();
            while (rs.next()) {
                obj1 = new JSONObject();
                obj1.put("clientId", rs.getString("CustomerId"));
                obj1.put("clientName", rs.getString("CustomerName"));
                jsonArray.put(obj1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            DBConnection.releaseConnectionToDB(con, pstmt, rs);
        }
        return jsonArray;
    }
    public JSONArray getBookingCount(int systemid, int clientIdInt, String sDate, String eDate, int offset) {
        JSONArray jsonArray = new JSONArray();
        HashMap < Integer, String > map = new HashMap < Integer, String > ();
        ArrayList < String > bookingArray = new ArrayList < String > ();
        Connection con = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        JSONObject obj1 = new JSONObject();
        try {
            con = DBConnection.getConnectionToDB("AMS");
            if (clientIdInt > 0) {
                pstmt = con.prepareStatement(ContainerCargoManagementStatements.GET_BRANCH_NAME);
                pstmt.setInt(1, systemid);
                pstmt.setInt(2, clientIdInt);
                rs = pstmt.executeQuery();
                while (rs.next()) {
                    map.put(rs.getInt("BranchId"), rs.getString("BranchName"));
                }
                pstmt.close();
                rs.close();
                pstmt = con.prepareStatement(ContainerCargoManagementStatements.GET_BOOKING_TYPE);
                pstmt.setInt(1, systemid);
                pstmt.setInt(2, clientIdInt);
                rs = pstmt.executeQuery();
                while (rs.next()) {
                    bookingArray.add(rs.getString("BookingType"));
                }
                pstmt.close();
                rs.close();
                for (int i = 0; i < bookingArray.size(); i++) {
                    obj1 = new JSONObject();
                    for (int key: map.keySet()) {
                        pstmt = con.prepareStatement(ContainerCargoManagementStatements.GET_BOOKING_COUNT);
                        pstmt.setInt(1, clientIdInt);
                        pstmt.setInt(2, systemid);
                        pstmt.setInt(3, key);
                        pstmt.setString(4, bookingArray.get(i));
                        pstmt.setInt(5, offset);
                        pstmt.setString(6, sDate);
                        pstmt.setInt(7, offset);
                        pstmt.setString(8, eDate);
                        rs = pstmt.executeQuery();
                        if (rs.next()) {
                            switch (key) {
                                case 193:
                                    obj1.put(map.get(key), rs.getInt("count"));
                                    break;
                                case 206:
                                    obj1.put(map.get(key), rs.getInt("count"));
                                    break;
                                case 213:
                                    obj1.put(map.get(key), rs.getInt("count"));
                                    break;
                                case 214:
                                    obj1.put(map.get(key), rs.getInt("count"));
                                    break;
                                case 215:
                                    obj1.put(map.get(key), rs.getInt("count"));
                                    break;
                                case 216:
                                    obj1.put(map.get(key), rs.getInt("count"));
                                    break;
                                case 217:
                                    obj1.put(map.get(key), rs.getInt("count"));
                                    break;
                                case 218:
                                    obj1.put(map.get(key), rs.getInt("count"));
                                    break;
                                case 226:
                                    obj1.put(map.get(key), rs.getInt("count"));
                                    break;
                            }
                        }
                    }
                    obj1.put("bookingType", bookingArray.get(i));
                    jsonArray.put(obj1);
                }
            } else {
                jsonArray.put("");
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            DBConnection.releaseConnectionToDB(con, pstmt, rs);
        }
        return jsonArray;
    }
    public ArrayList<Object> getFuelLogData(int custId, int systemId,int offset, String vehId, String startDate, String endDate,String language) {
		SimpleDateFormat sdfyyyymmddhhmmss=new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
		DecimalFormat df=new DecimalFormat("##.##");
		SimpleDateFormat simpleDateFormatddMMYYYYDB = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		CommonFunctions commFunctions = new CommonFunctions();
    	Connection con = null;
    	PreparedStatement pstmt = null;
    	ResultSet rs = null;
    	JSONArray jsArr = new JSONArray();
    	JSONObject obj = new JSONObject();
    	int slcount = 0; 
    	
    	ArrayList<ReportHelper> reportsList = new ArrayList<ReportHelper>();
    	ArrayList<String> headersList = new ArrayList<String>();
    	ReportHelper finalreporthelper = new ReportHelper();
    	ArrayList<Object> finlist = new ArrayList<Object>();
    	
    	headersList.add(commFunctions.getLabelFromDB("SLNO", language));
    	headersList.add(commFunctions.getLabelFromDB("Vehicle_No", language));
    	headersList.add(commFunctions.getLabelFromDB("Date", language));
    	headersList.add(commFunctions.getLabelFromDB("Vendor_Name", language));
    	headersList.add(commFunctions.getLabelFromDB("Fuel_Rate", language));
    	headersList.add(commFunctions.getLabelFromDB("Refill_Quantity", language));
    	headersList.add(commFunctions.getLabelFromDB("Refill_Amount", language));
    	
    	try {
    		con = DBConnection.getConnectionToDB("AMS");
    		if ("All".equals(vehId)) {
	    		pstmt = con.prepareStatement(ContainerCargoManagementStatements.GET_FUEL_LOG_DETAILS_ALL);
	    		pstmt.setInt(1, offset);
	    		pstmt.setInt(2, systemId);
	    		pstmt.setInt(3, custId);
	    		pstmt.setInt(4, offset);
	    		pstmt.setString(5, startDate);
	    		pstmt.setInt(6, offset);
	    		pstmt.setString(7, endDate);
	    		pstmt.setInt(8, offset);
	    		pstmt.setInt(9, systemId);
	    		pstmt.setInt(10, custId);
	    		pstmt.setInt(11, 1);
	    		pstmt.setInt(12, offset);
	    		pstmt.setString(13, startDate);
	    		pstmt.setInt(14, offset);
	    		pstmt.setString(15, endDate);
    		}else{
    			pstmt = con.prepareStatement(ContainerCargoManagementStatements.GET_FUEL_LOG_DETAILS);
	    		pstmt.setInt(1, offset);
	    		pstmt.setInt(2, systemId);
	    		pstmt.setInt(3, custId);
	    		pstmt.setString(4, vehId);
	    		pstmt.setInt(5, offset);
	    		pstmt.setString(6, startDate);
	    		pstmt.setInt(7, offset);
	    		pstmt.setString(8, endDate);
	    		pstmt.setInt(9, offset);
	    		pstmt.setInt(10, systemId);
	    		pstmt.setInt(11, custId);
	    		pstmt.setString(12, vehId);
	    		pstmt.setInt(13, 1);
	    		pstmt.setInt(14, offset);
	    		pstmt.setString(15, startDate);
	    		pstmt.setInt(16, offset);
	    		pstmt.setString(17, endDate);
    		}
    		rs = pstmt.executeQuery();
    		
    		double totalFuelRequired = 0;
    		double totalAmount = 0;
    		
    		while (rs.next()) {
    			obj = new JSONObject();
    			ArrayList<Object> informationList=new ArrayList<Object>();
    			ReportHelper reporthelper=new ReportHelper();
    			slcount++;
    			
    			informationList.add(Integer.toString(slcount));
    			obj.put("slnoIndex", slcount);
    			
    			informationList.add(rs.getString("VehicleNo"));
    			obj.put("VehicleNoIndex", rs.getString("VehicleNo"));
    			
    			informationList.add(sdfyyyymmddhhmmss.format(simpleDateFormatddMMYYYYDB.parseObject(rs.getString("Date"))));
    			obj.put("dateIndex", sdfyyyymmddhhmmss.format(simpleDateFormatddMMYYYYDB.parse(rs.getString("Date"))));
    			
    			informationList.add(rs.getString("VendorName"));
    			obj.put("vendorNameIndex", rs.getString("VendorName"));
    			
    			informationList.add(rs.getString("FuelRate"));
    			obj.put("fuelRateIndex", rs.getString("FuelRate"));
    			
    			informationList.add(rs.getString("FuelRequired"));
    			obj.put("refillQtyIndex", rs.getString("FuelRequired"));
    			totalFuelRequired = totalFuelRequired + rs.getDouble("FuelRequired");
    			
    			informationList.add(rs.getString("Amount"));
    			obj.put("refillAmountIndex", rs.getString("Amount"));
    			totalAmount = totalAmount + rs.getDouble("Amount");
    			jsArr.put(obj);
    			reporthelper.setInformationList(informationList);
    			reportsList.add(reporthelper);	
    		}
    		if(slcount > 0){
    			obj = new JSONObject();
    			ArrayList<Object> informationList=new ArrayList<Object>();
    			ReportHelper reporthelper=new ReportHelper();
    			slcount++;
    			
    			informationList.add(Integer.toString(slcount));
    			obj.put("slnoIndex", slcount);
    			
    			informationList.add("");
    			obj.put("VehicleNoIndex", "");
    			
    			informationList.add("");
    			obj.put("dateIndex", "");
    			
    			informationList.add("");
    			obj.put("vendorNameIndex", "");
    			
    			informationList.add("TOTAL");
    			obj.put("fuelRateIndex","<b>TOTAL</b>");
    			
    			informationList.add(df.format(totalFuelRequired));
    			obj.put("refillQtyIndex", "<b>" + df.format(totalFuelRequired) + "</b>");			
    			
    			informationList.add(df.format(totalAmount));
    			obj.put("refillAmountIndex", "<b>" + df.format(totalAmount) + "</b>");
    			
    			jsArr.put(obj);
    			reporthelper.setInformationList(informationList);
    			reportsList.add(reporthelper);	
    		}	
    			finlist.add(jsArr);
    			finalreporthelper.setReportsList(reportsList);
    			finalreporthelper.setHeadersList(headersList);
    			finlist.add(finalreporthelper);
    		} 	catch (Exception e) {
    			e.printStackTrace();
    		} 	finally {
    			DBConnection.releaseConnectionToDB(con, pstmt, rs);
    		}
    			return finlist;
    	}    
    
    public JSONArray getVehicleNo(int custId, int systemId, int userId) {
    	
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		JSONArray jsArr = new JSONArray();
		JSONObject obj = new JSONObject();
	
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(ContainerCargoManagementStatements.GET_UNASSIGNED_VEHICLES);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, custId);
			pstmt.setInt(3, userId);
			pstmt.setInt(4, systemId);
			pstmt.setInt(5, custId);
			pstmt.setInt(6, systemId);
			pstmt.setInt(7, custId);
			rs = pstmt.executeQuery();
	
			while (rs.next()) {
				obj = new JSONObject();
				obj.put("vehicleNo", rs.getString("REGISTRATION_NUMBER"));
				jsArr.put(obj);
			}
	
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
	
		return jsArr;
	}
	
	public JSONArray getPrincipalStore(int systemId, int clientId) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		JSONObject obj = null;
		JSONArray jsonArray = new JSONArray();
		try{
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(ContainerCargoManagementStatements.GET_PRINCIPAL_DETAILS);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, clientId);
			pstmt.setString(3, "PRINCIPAL");
			rs = pstmt.executeQuery();
			while(rs.next()){
				obj = new JSONObject();
				obj.put("principalId", rs.getString("principalId"));
				obj.put("principalName", rs.getString("principalName"));
				obj.put("invoiceType", rs.getInt("invoiceType"));
				jsonArray.put(obj);
			}
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jsonArray;
	}
	
	public JSONArray getConsigneeStore(int systemId, int clientId) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		JSONObject obj = null;
		JSONArray jsonArray = new JSONArray();
		try{
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(ContainerCargoManagementStatements.GET_CONSIGNEE_STORE_DETAILS);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, clientId);
			pstmt.setString(3, "CONSIGNEE");
			rs = pstmt.executeQuery();
			while(rs.next()){
				obj = new JSONObject();
				obj.put("consigneeId", rs.getString("principalId"));
				obj.put("consigneeName", rs.getString("principalName"));
				jsonArray.put(obj);
			}
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jsonArray;
	}
	
	public String addAssignedVehicledetails(String vehicle,int principal,int systemId,int consignee,int customerId,int userId)
	 {
		Connection con = null;
		PreparedStatement pstmt= null;
		ResultSet rs= null;
		String message="";
		int count;
		
		try
		{
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(ContainerCargoManagementStatements.CHECK_VEHICLE_ASSIGNED);
			pstmt.setString(1, vehicle);
			pstmt.setInt(2, systemId);
			pstmt.setInt(3, customerId);
			rs = pstmt.executeQuery();
			if(! rs.next()){
				pstmt = con.prepareStatement(ContainerCargoManagementStatements.SAVE_ASSIGN_VEHICLE_DETAILS);
				pstmt.setString(1, vehicle);
				pstmt.setInt(2, principal);
				pstmt.setInt(3, consignee);
				pstmt.setInt(4, systemId);
				pstmt.setInt(5, customerId);
				pstmt.setInt(6, userId);
				count=pstmt.executeUpdate();
				if(count>0)
				{
					message="Vehicle Assigned Successfully.";
				}
				else
					message="Error While Assigning";
			}
			else{
				message= "Vehicle is already assigned.";
			}
			
		}
		catch (Exception e)
		{
			System.out.println("error in:- Assigning Assign Vehicle Details "+e.toString());
				e.printStackTrace();
		}      
		finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return message;
				
	}
	
	public String modifyAssignedVehicledetails(String vehicle,int principal,int systemId,int consignee,int customerId,int userId,int uniqueId)
	 {
		
		Connection con = null;
		PreparedStatement pstmt= null;
		ResultSet rs= null;
		String message="";
		int count;
		
		try
		{
			con = DBConnection.getConnectionToDB("AMS");
				pstmt = con.prepareStatement(ContainerCargoManagementStatements.MODIFY_ASSIGN_VEHICLE_DETAILS);
				pstmt.setInt(1, principal);
				pstmt.setInt(2, consignee);
				pstmt.setInt(3, userId);
				pstmt.setInt(4, uniqueId);
				pstmt.setInt(5, systemId);
				pstmt.setInt(6, customerId);
				count=pstmt.executeUpdate();
				if(count>0)
				{
					message="Updated Successfully.";
				}
				else
					message="Error While Updating";			
		}
		catch (Exception e)
		{
			System.out.println("error in:-Updating Assigning Vehicle Details "+e.toString());
				e.printStackTrace();
		}      
		finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return message;
				
	}
	public ArrayList<Object> getAssignedVehiclesDetails(int systemId, int customerId, int offset){
		JSONArray JsonArray = new JSONArray();
		JSONObject JsonObject = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int slcount = 0;
		String updatedDate = null;
		ArrayList<Object> finalList = new ArrayList<Object>();
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(ContainerCargoManagementStatements.GET_ASSIGNED_VEHICLE_DETAILS);
			pstmt.setInt(1, offset);
			pstmt.setInt(2, offset);
			pstmt.setInt(3, systemId);
			pstmt.setInt(4, customerId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				JsonObject = new JSONObject();
				slcount++;
				JsonObject.put("slnoIndex", slcount);

				JsonObject.put("uniqueIdDataIndex", rs.getString("UID"));
				
				JsonObject.put("vehicleNoIndex", rs.getString("VEHICLE_NO"));
				
				JsonObject.put("principalNameIndex", rs.getString("Principal"));
				
				JsonObject.put("consigneeNameIndex", rs.getString("Consignee"));

				JsonObject.put("associatedByIndex", rs.getString("createdBy").toUpperCase());
				
				JsonObject.put("associatedTimeIndex", getFormattedDateStartingFromYearToDate(rs.getString("createdDate")));
				
				JsonObject.put("modifiedByIndex", rs.getString("updatedBy").toUpperCase());
				
				updatedDate = rs.getString("updatedDate");
				String substr = updatedDate.substring(0, 4);
				if (substr.equals("1900")) {
					updatedDate = "";
				}else{
					updatedDate = getFormattedDateStartingFromYearToDate(rs.getString("updatedDate"));
				}
				
				JsonObject.put("modifiedTimeIndex", updatedDate);

				JsonArray.put(JsonObject);
			}
			finalList.add(JsonArray);

		} catch (Exception e) {
			e.printStackTrace();
		}finally {

			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return finalList;
		}
	
	
	public String getFormattedDateStartingFromYearToDate(String inputDate) {
		String formattedDate = "";
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		SimpleDateFormat sdfFormatDate = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
		try {
			if (inputDate != null && !inputDate.equals("")) {
				java.util.Date d = sdf.parse(inputDate);
				formattedDate = sdfFormatDate.format(d);
			}

		} catch (Exception e) {
			System.out.println("Error in getFormattedDateStartingFromYear() method"+ e);
		}
		return formattedDate;
	}
	
	public JSONArray getVehicles(int systemId, String custId, int userId) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		JSONArray jsArr = new JSONArray();
		JSONObject jsObj = null;
		
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(ContainerCargoManagementStatements.GET_VEHICLE_LIST);
			pstmt.setInt(1, systemId);
			pstmt.setString(2, custId);
			pstmt.setInt(3, userId);
			rs = pstmt.executeQuery();

			while(rs.next()) {
				jsObj = new JSONObject();
				jsObj.put("vehicleId", rs.getString("REGISTRATION_NUMBER"));
				jsObj.put("VehicleNo", rs.getString("REGISTRATION_NUMBER"));
				
				jsArr.put(jsObj);
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
            DBConnection.releaseConnectionToDB(con, pstmt, rs);
        }
		return jsArr;
	}
	
	public JSONArray getVehiclesAll(int systemId, String custId, int userId) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		JSONArray jsArr = new JSONArray();
		JSONObject jsObj = null;
		
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(ContainerCargoManagementStatements.GET_VEHICLE_LIST);
			pstmt.setInt(1, systemId);
			pstmt.setString(2, custId);
			pstmt.setInt(3, userId);
			rs = pstmt.executeQuery();
			jsObj = new JSONObject(); 
			jsObj.put("vehicleId",0); 
			jsObj.put("VehicleNo","All");
			jsArr.put(jsObj);
			while(rs.next()) {
				jsObj = new JSONObject();
				jsObj.put("vehicleId", rs.getString("REGISTRATION_NUMBER"));
				jsObj.put("VehicleNo", rs.getString("REGISTRATION_NUMBER"));
				
				jsArr.put(jsObj);
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
            DBConnection.releaseConnectionToDB(con, pstmt, rs);
        }
		return jsArr;
	}
	
	public JSONArray getBranch(int systemId, String custId) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		JSONArray jsArr = new JSONArray();
		JSONObject jsObj = null;
		
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(ContainerCargoManagementStatements.GET_BRANCH_NAME);
			pstmt.setInt(1, systemId);
			pstmt.setString(2, custId);
			rs = pstmt.executeQuery();
			while(rs.next()) {
				jsObj = new JSONObject();
				jsObj.put("BranchId", rs.getString("BranchId"));
				jsObj.put("BranchName", rs.getString("BranchName"));
				jsArr.put(jsObj);
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
            DBConnection.releaseConnectionToDB(con, pstmt, rs);
        }
		return jsArr;
	}
	public ArrayList<Object> getTripHistoryData(int custId, int systemId,int offset, String branchNameId, String vehId, String startDate, String endDate,String language) {
		DecimalFormat df=new DecimalFormat("##.##");
		CommonFunctions commFunctions = new CommonFunctions();
    	Connection con = null;
    	PreparedStatement pstmt = null;
    	ResultSet rs = null;
    	JSONArray jsArr = new JSONArray();
    	JSONObject obj = new JSONObject();
    	int slcount = 0; 
    	
    	ArrayList<ReportHelper> reportsList = new ArrayList<ReportHelper>();
    	ArrayList<String> headersList = new ArrayList<String>();
    	ReportHelper finalreporthelper = new ReportHelper();
    	ArrayList<Object> finlist = new ArrayList<Object>();
    	
    	headersList.add(commFunctions.getLabelFromDB("SLNO", language));
    	headersList.add(commFunctions.getLabelFromDB("Loading_Branch", language));
    	headersList.add(commFunctions.getLabelFromDB("Vehicle_Number", language));
    	headersList.add(commFunctions.getLabelFromDB("Vehicle_Model", language));
    	headersList.add(commFunctions.getLabelFromDB("Trip_No", language));
    	headersList.add(commFunctions.getLabelFromDB("Principal_Name", language));
    	headersList.add(commFunctions.getLabelFromDB("Consignee_Name", language));
    	headersList.add(commFunctions.getLabelFromDB("Driver_Name", language));
    	headersList.add(commFunctions.getLabelFromDB("Driver_Contact_No", language));
    	headersList.add(commFunctions.getLabelFromDB("Trip_Start_Date", language));
    	headersList.add(commFunctions.getLabelFromDB("Trip_End_Date", language));
    	headersList.add(commFunctions.getLabelFromDB("GR_Number", language));
    	headersList.add(commFunctions.getLabelFromDB("Total_Drums", language));
    	headersList.add(commFunctions.getLabelFromDB("Master_Kms", language));
    	headersList.add(commFunctions.getLabelFromDB("Fuel_Consumption", language));
    	headersList.add(commFunctions.getLabelFromDB("R_Fee", language));
    	headersList.add(commFunctions.getLabelFromDB("B_Fee", language));
    	headersList.add(commFunctions.getLabelFromDB("Toll", language));
    	headersList.add(commFunctions.getLabelFromDB("Driver_Incentive", language));
    	headersList.add(commFunctions.getLabelFromDB("Police", language));
    	headersList.add(commFunctions.getLabelFromDB("Escort", language));
    	headersList.add(commFunctions.getLabelFromDB("Loading", language));
    	headersList.add(commFunctions.getLabelFromDB("Labour_Charges", language));
    	headersList.add(commFunctions.getLabelFromDB("Octroi", language));
    	headersList.add(commFunctions.getLabelFromDB("Other_Expenses", language));
    	headersList.add(commFunctions.getLabelFromDB("Morning_Incentive", language));
    	headersList.add(commFunctions.getLabelFromDB("Conveyance", language));
    	headersList.add(commFunctions.getLabelFromDB("Total_Approved_Additional_Expenses", language));
    	headersList.add(commFunctions.getLabelFromDB("Total_Trip_Expense", language));
    	headersList.add(commFunctions.getLabelFromDB("Driver_Advance", language));
    	headersList.add(commFunctions.getLabelFromDB("Billing_Tariff", language));
    	headersList.add(commFunctions.getLabelFromDB("Unloading_Charges", language));
    	headersList.add(commFunctions.getLabelFromDB("Detention_Charges", language));
    	headersList.add(commFunctions.getLabelFromDB("Receipted_Charges", language));
    	headersList.add(commFunctions.getLabelFromDB("Total_Bill", language));
    	headersList.add(commFunctions.getLabelFromDB("Profit_And_Loss", language));
    	
    	try {
    		con = DBConnection.getConnectionToDB("LMS");
    		if(vehId.equals("All")){
    			pstmt = con.prepareStatement(ContainerCargoManagementStatements.GET_TRIP_HISTORY_DETAILS.replace("and td.ASSET_NO=?", ""));
        		pstmt.setInt(1, offset);
        		pstmt.setInt(2, offset);
        		pstmt.setInt(3, systemId);
        		pstmt.setInt(4, custId);
        		pstmt.setInt(5, systemId);
        		pstmt.setInt(6, custId);
        		pstmt.setInt(7, systemId);
        		pstmt.setInt(8, custId);
        		pstmt.setString(9, branchNameId);
        		pstmt.setString(10, startDate);
        		pstmt.setString(11, endDate);
        		pstmt.setInt(12, systemId);
        		pstmt.setInt(13, custId);
        		rs = pstmt.executeQuery();
    		}
    		else{
    		pstmt = con.prepareStatement(ContainerCargoManagementStatements.GET_TRIP_HISTORY_DETAILS);
    		pstmt.setInt(1, offset);
    		pstmt.setInt(2, offset);
    		pstmt.setInt(3, systemId);
    		pstmt.setInt(4, custId);
    		pstmt.setInt(5, systemId);
    		pstmt.setInt(6, custId);
    		pstmt.setInt(7, systemId);
    		pstmt.setInt(8, custId);
    		pstmt.setString(9, branchNameId);
    		pstmt.setString(10, vehId);
    		pstmt.setString(11, startDate);
    		pstmt.setString(12, endDate);
    		pstmt.setInt(13, systemId);
    		pstmt.setInt(14, custId);
    		rs = pstmt.executeQuery();
    		}
    		while (rs.next()) {
    			obj = new JSONObject();
    			ArrayList<Object> informationList=new ArrayList<Object>();
    			ReportHelper reporthelper=new ReportHelper();
    			slcount++;
    			
    			informationList.add(Integer.toString(slcount));
    			obj.put("slnoIndex", slcount);
    			
    			informationList.add(rs.getString("BranchName"));
    			obj.put("loadingBranchIndex",rs.getString("BranchName"));
    			
    			informationList.add(rs.getString("AssetNo"));
    			obj.put("vehicalNoIndex", rs.getString("AssetNo"));
    			
    			informationList.add(rs.getString("Model"));
    			obj.put("vehicalModelIndex",rs.getString("Model"));
    			
    			informationList.add(rs.getString("TripNo"));
    			obj.put("tripNoIndex", rs.getString("TripNo"));
    			
    			informationList.add(rs.getString("PrincipleName"));
    			obj.put("principalNameIndex", rs.getString("PrincipleName"));
    			
    			informationList.add(rs.getString("ConsigneeName"));
    			obj.put("consigneeNameIndex", rs.getString("ConsigneeName"));
    			
    			informationList.add(rs.getString("DriverName"));
    			obj.put("driverNameIndex", rs.getString("DriverName"));
    			
    			informationList.add(rs.getString("DriverMobile"));
    			obj.put("driverContactNoIndex", rs.getString("DriverMobile"));
    			
    			informationList.add(ddmmyyyy.format(yyyymmdd.parseObject(rs.getString("TripStartTime"))));
    			obj.put("tripStartDateIndex", ddmmyyyy.format(yyyymmdd.parse(rs.getString("TripStartTime"))));
    			
    			informationList.add(ddmmyyyy.format(yyyymmdd.parseObject(rs.getString("TripEndTime"))));
    			obj.put("tripEndDateIndex", ddmmyyyy.format(yyyymmdd.parse(rs.getString("TripEndTime"))));
    			
    			informationList.add(rs.getString("GRNo"));
    			obj.put("grNoIndex", rs.getString("GRNo"));
    			
    			informationList.add(rs.getString("Drums"));
    			obj.put("totalDrumsIndex", rs.getString("Drums"));
    			
    			informationList.add(df.format(rs.getDouble("MasterKms")));
    			obj.put("masterKMSIndex", df.format(rs.getDouble("MasterKms")));
    			
    			informationList.add(df.format(rs.getDouble("FuelConsumption")));
    			obj.put("fuelConsumptionIndex", df.format(rs.getDouble("FuelConsumption")));
    			
    			informationList.add(df.format(rs.getDouble("RFee")));
    			obj.put("rFeeIndex", df.format(rs.getDouble("RFee")));
    			
    			informationList.add(df.format(rs.getDouble("BFee")));
    			obj.put("bFeeIndex", df.format(rs.getDouble("BFee")));
    			
    			informationList.add(df.format(rs.getDouble("Toll")));
    			obj.put("tollIndex", df.format(rs.getDouble("Toll")));
    			
    			informationList.add(df.format(rs.getDouble("DriverIncentive")));
    			obj.put("driverIncentiveIndex", df.format(rs.getDouble("DriverIncentive")));
    			
    			informationList.add(df.format(rs.getDouble("Police")));
    			obj.put("policeIndex", df.format(rs.getDouble("Police")));
    			
    			informationList.add(df.format(rs.getDouble("Escort")));
    			obj.put("escortIndex", df.format(rs.getDouble("Escort")));
    			
    			informationList.add(df.format(rs.getDouble("Loading")));
    			obj.put("loadingIndex", df.format(rs.getDouble("Loading")));
    			
    			informationList.add(df.format(rs.getDouble("LabourCharges")));
    			obj.put("labourChargesIndex", df.format(rs.getDouble("LabourCharges")));
    			
    			informationList.add(df.format(rs.getDouble("Octroi")));
    			obj.put("octroiIndex", df.format(rs.getDouble("Octroi")));
    			
    			informationList.add(df.format(rs.getDouble("OtherExpenses")));
    			obj.put("otherExpensesIndex", df.format(rs.getDouble("OtherExpenses")));
    			
    			informationList.add(df.format(rs.getDouble("MrngIncentive")));
    			obj.put("morningIncentiveIndex", df.format(rs.getDouble("MrngIncentive")));
    			
    			informationList.add(df.format(rs.getDouble("Conveyance")));
    			obj.put("conveyanceIndex", df.format(rs.getDouble("Conveyance")));
    			
    			informationList.add(df.format(rs.getDouble("ApprovedAddExpenses")));
    			obj.put("totalApprovedAdditionalExpensesIndex", df.format(rs.getDouble("ApprovedAddExpenses")));
    			
    			informationList.add(df.format(rs.getDouble("TotalTripExp")));
    			obj.put("totalTripExpenseIndex", df.format(rs.getDouble("TotalTripExp")));
    			
    			informationList.add(df.format(rs.getDouble("DriverAdv")));
    			obj.put("driverAdvanceIndex", df.format(rs.getDouble("DriverAdv")));
    			
    			informationList.add(df.format(rs.getDouble("BillingAmount")));
    			obj.put("billingTariffIndex", df.format(rs.getDouble("BillingAmount")));
    			
    			informationList.add(df.format(rs.getDouble("UnloadingAmount")));
    			obj.put("unloadingChargesIndex", df.format(rs.getDouble("UnloadingAmount")));
    			
    			informationList.add(df.format(rs.getDouble("DetentionAmount")));
    			obj.put("detentionChargesIndex", df.format(rs.getDouble("DetentionAmount")));
    			
    			informationList.add(df.format(rs.getDouble("ReceiptedAmount")));
    			obj.put("receiptedChargesIndex", df.format(rs.getDouble("ReceiptedAmount")));
    			
    			informationList.add(df.format(rs.getDouble("TotalBill")));
    			obj.put("totalBillIndex", df.format(rs.getDouble("TotalBill")));
    			
    			informationList.add(rs.getString("ProfitLoss"));
    			obj.put("profitLossIndex", rs.getString("ProfitLoss"));
    			
    			jsArr.put(obj);
    			reporthelper.setInformationList(informationList);
    			reportsList.add(reporthelper);	
    		}
    		finlist.add(jsArr);
			finalreporthelper.setReportsList(reportsList);
			finalreporthelper.setHeadersList(headersList);
			finlist.add(finalreporthelper);
		} 	catch (Exception e) {
			e.printStackTrace();
		} 	finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
			return finlist;
	}    
	public ArrayList<Object> getProfitAndLossDetails(int systemId,int clientId,int offset,String vehicleNo,String fromDate,String toDate) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		JSONObject obj = null;
		JSONArray jArr = new JSONArray();
		DecimalFormat df=new DecimalFormat("##.##");
		String prevDate = "";
		String currDate = "";
		double invoiceReceived = 0;
		double tripExpense = 0;
		int tripCount = 0;
		double profitLoss = 0;
		String prevVehNo = "";
		String currVehNo = "";
		String prevTripNo = "";
		String currTripNo = "";
		boolean flag = false;
		double totalKms = 0;
		double totalInvoiceReceived = 0;
		double totalTripExpense = 0; 
		double totalProfitLoss = 0;
		int count = 0;
		int countExp = 0;
		ArrayList< Object > informationList = null;
		ReportHelper reportHelper = new ReportHelper();
		ArrayList<ReportHelper> reportList = new ArrayList<ReportHelper>();
		ReportHelper finalReportHelper = new ReportHelper();
		ArrayList<Object> finlist = new ArrayList<Object>();
		ArrayList<String> headersList = new ArrayList<String>();
		try{
			headersList.add("SL No");
			headersList.add("Vehicle");
			headersList.add("Month");
			headersList.add("Sum of Trips");
			headersList.add("Sum of Total Master Kms");
			headersList.add("Sum of Total Invoice Received");
			headersList.add("Sum of Total Trip Expenses");
			headersList.add("Sum of Total Profit and Loss");
			String[] vehicleNos  = null;
			String vehicleNumber = "";
			vehicleNos = vehicleNo.split(",");
			for(String s:vehicleNos){
				vehicleNumber = vehicleNumber+"'"+s+"'"+",";
			}
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(ContainerCargoManagementStatements.GET_PROFIT_LOSS_DETAILS.replace("#", vehicleNumber.substring(0,vehicleNumber.length()-1)));
			pstmt.setInt(1, offset);
			pstmt.setInt(2, offset);
			pstmt.setInt(3, systemId);
			pstmt.setInt(4, clientId);
			pstmt.setInt(5, offset);
			pstmt.setString(6, fromDate.replace("T", " "));
			pstmt.setInt(7, offset);
			pstmt.setString(8, toDate.replace("T", " "));
			pstmt.setInt(9, systemId);
			pstmt.setInt(10, clientId);
			rs = pstmt.executeQuery();
			while(rs.next()){
				count++;
				if(!flag){
					obj = new JSONObject();
					informationList = new ArrayList<Object>();
					prevVehNo = rs.getString("vehicleNo");
					currVehNo = rs.getString("vehicleNo");
					prevTripNo = rs.getString("tripNo");
					currTripNo = rs.getString("tripNo");
					prevDate = monthFormat.format(yyyymmdd.parse(rs.getString("tripClosedTime")));
					currDate = monthFormat.format(yyyymmdd.parse(rs.getString("tripClosedTime")));
					invoiceReceived = rs.getDouble("invoiceReceived");
					tripExpense = rs.getDouble("expenses");
					totalKms = rs.getDouble("Kms");
					profitLoss = invoiceReceived - tripExpense;
					tripCount++;
				}else{
					prevVehNo = currVehNo;
					currVehNo = rs.getString("vehicleNo");
					prevTripNo = currTripNo;
					currTripNo = rs.getString("tripNo");
					prevDate = currDate;
					currDate = monthFormat.format(yyyymmdd.parse(rs.getString("tripClosedTime")));
				}
				if(prevVehNo.equals(currVehNo)){
					if(!prevDate.equals(currDate)){
						countExp++;
						obj = new JSONObject();
						informationList = new ArrayList<Object>();
						reportHelper = new ReportHelper();
						
						obj.put("SLNODI", countExp);
						informationList.add(countExp);
						
						obj.put("vehicleDI", prevVehNo);
						informationList.add(prevVehNo);
						
						obj.put("monthDI", prevDate);
						informationList.add(prevDate);
						
						obj.put("sumOfTripsDI", tripCount);
						informationList.add(tripCount);
						
						obj.put("kmsDI", df.format(totalKms));
						informationList.add(df.format(totalKms));
						
						obj.put("invoiceReceivedDI", df.format(invoiceReceived));
						informationList.add(df.format(invoiceReceived));
						
						obj.put("expenseDI", df.format(tripExpense));
						informationList.add(df.format(tripExpense));
						
						obj.put("profitLossDI", df.format(profitLoss));
						informationList.add(df.format(profitLoss));
						
						jArr.put(obj);
						reportHelper.setInformationList(informationList);
						reportList.add(reportHelper);
						
						totalInvoiceReceived += invoiceReceived;
						totalTripExpense += tripExpense;
						totalProfitLoss += profitLoss;
						
						invoiceReceived = 0;
						tripCount = 0;
						tripExpense = 0;
						profitLoss = 0;
						totalKms = 0;
						//for 2nd Row
						totalKms += rs.getDouble("Kms");
						invoiceReceived += rs.getDouble("invoiceReceived");
						tripExpense += rs.getDouble("expenses");
						profitLoss += rs.getDouble("invoiceReceived") - rs.getDouble("expenses");
						tripCount++;
					}else{
						if(!prevTripNo.equals(currTripNo)){
							totalKms += rs.getDouble("Kms");
							invoiceReceived += rs.getDouble("invoiceReceived");
							tripExpense += rs.getDouble("expenses");
							profitLoss += rs.getDouble("invoiceReceived") - rs.getDouble("expenses");
							tripCount++;
						}else{
							if(flag){
								invoiceReceived += rs.getDouble("invoiceReceived");
								tripExpense += rs.getDouble("expenses");
								profitLoss += rs.getDouble("invoiceReceived") - rs.getDouble("expenses");
							}
						}
						
					}	
				}else{
					countExp++;
					obj = new JSONObject();
					informationList = new ArrayList<Object>();
					reportHelper = new ReportHelper();
					
					obj.put("SLNODI", countExp);
					informationList.add(countExp);
					
					obj.put("vehicleDI", prevVehNo);
					informationList.add(prevVehNo);
					
					obj.put("monthDI", prevDate);
					informationList.add(prevDate);
					
					obj.put("sumOfTripsDI", tripCount);
					informationList.add(tripCount);
					
					obj.put("kmsDI", df.format(totalKms));
					informationList.add(df.format(totalKms));
					
					obj.put("invoiceReceivedDI", df.format(invoiceReceived));
					informationList.add(df.format(invoiceReceived));
					
					obj.put("expenseDI", df.format(tripExpense));
					informationList.add(df.format(tripExpense));
					
					obj.put("profitLossDI", df.format(profitLoss));
					informationList.add(df.format(profitLoss));
					
					jArr.put(obj);
					reportHelper.setInformationList(informationList);
					reportList.add(reportHelper);
					
					totalInvoiceReceived += invoiceReceived;
					totalTripExpense += tripExpense;
					totalProfitLoss += profitLoss;
					
					invoiceReceived = 0;
					tripCount = 0;
					tripExpense = 0;
					profitLoss = 0;
					totalKms = 0;
					//for 2nd Row
					totalKms += rs.getDouble("Kms");
					invoiceReceived += rs.getDouble("invoiceReceived");
					tripExpense += rs.getDouble("expenses");
					profitLoss += rs.getDouble("invoiceReceived") - rs.getDouble("expenses");
					tripCount++;
				}
				flag = true;
			}	
			if(count > 0){
				countExp++;
				obj = new JSONObject();
				informationList = new ArrayList<Object>();
				reportHelper = new ReportHelper();
				
				obj.put("SLNODI", countExp);
				informationList.add(countExp);
				
				obj.put("vehicleDI", currVehNo);
				informationList.add(currVehNo);
				
				obj.put("monthDI", currDate);
				informationList.add(currDate);
				
				obj.put("sumOfTripsDI", tripCount);
				informationList.add(tripCount);
				
				obj.put("kmsDI", df.format(totalKms));
				informationList.add(df.format(totalKms));
				
				obj.put("invoiceReceivedDI", df.format(invoiceReceived));
				informationList.add(df.format(invoiceReceived));
				
				obj.put("expenseDI", df.format(tripExpense));
				informationList.add(df.format(tripExpense));
				
				obj.put("profitLossDI", df.format(profitLoss));
				informationList.add(df.format(profitLoss));
				
				jArr.put(obj);
				reportHelper.setInformationList(informationList);
				reportList.add(reportHelper);
				
				totalInvoiceReceived += invoiceReceived;
				totalTripExpense += tripExpense;
				totalProfitLoss += profitLoss;
				
				countExp++;
				obj = new JSONObject();
				informationList = new ArrayList<Object>();
				reportHelper = new ReportHelper();
				
				obj.put("SLNODI", countExp);
				informationList.add(countExp);
				
				obj.put("vehicleDI", "");
				informationList.add("");
				
				obj.put("monthDI", "<b>Total</b>");
				informationList.add("Total");
				
				obj.put("sumOfTripsDI", "");
				informationList.add("");
				
				obj.put("kmsDI", "");
				informationList.add("");
				
				obj.put("invoiceReceivedDI", df.format(totalInvoiceReceived));
				informationList.add(df.format(totalInvoiceReceived));
				
				obj.put("expenseDI", df.format(totalTripExpense));
				informationList.add(df.format(totalTripExpense));
				
				obj.put("profitLossDI", df.format(totalProfitLoss));
				informationList.add(df.format(totalProfitLoss));
				
				jArr.put(obj);
				reportHelper.setInformationList(informationList);
				reportList.add(reportHelper);
				
				finalReportHelper.setHeadersList(headersList);
				finalReportHelper.setReportsList(reportList);
			}
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			 DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		finlist.add(jArr);
		finlist.add(finalReportHelper);
		return finlist;
	}
	
	public JSONArray getUserBranchList(int systemId, String custId, int userId) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		JSONArray jsArr = new JSONArray();
		JSONObject jsObj = null;
		
		try {
			con = DBConnection.getConnectionToDB("LMS");
			pstmt = con.prepareStatement(ContainerCargoManagementStatements.GET_USER_BRANCH_LIST);
			pstmt.setInt(1, systemId);
			pstmt.setString(2, custId);
			pstmt.setInt(3, userId);
			rs = pstmt.executeQuery();
			while(rs.next()) {
				jsObj = new JSONObject();
				jsObj.put("BranchId", rs.getInt("BranchId"));
				jsObj.put("BranchName", rs.getString("BranchName"));
				
				jsArr.put(jsObj);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
            DBConnection.releaseConnectionToDB(con, pstmt, rs);
        }
		return jsArr;
	}
	public JSONArray getTransactionTypeList(int systemId, String custId, int userId) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		JSONArray jsArr = new JSONArray();
		JSONObject jsObj = null;
		
		try {
			con = DBConnection.getConnectionToDB("LMS");
			pstmt = con.prepareStatement(ContainerCargoManagementStatements.GET_LOOK_UP_LIST);
			pstmt.setInt(1, systemId);
			pstmt.setString(2, custId);
			pstmt.setString(3, "TransactionType");
			rs = pstmt.executeQuery();
			while(rs.next()) {
				jsObj = new JSONObject();
				jsObj.put("transTypeID", rs.getInt("ID"));
				jsObj.put("transTypeName", rs.getString("DATA"));
				
				jsArr.put(jsObj);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
            DBConnection.releaseConnectionToDB(con, pstmt, rs);
        }
		return jsArr;
	}
	public JSONArray getAccountHeaderList(int systemId, String custId, int userId) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		JSONArray jsArr = new JSONArray();
		JSONObject jsObj = null;
		
		try {
			con = DBConnection.getConnectionToDB("LMS");
			pstmt = con.prepareStatement(ContainerCargoManagementStatements.GET_LOOK_UP_LIST);
			pstmt.setInt(1, systemId);
			pstmt.setString(2, custId);
			pstmt.setString(3, "AccountHeader");
			rs = pstmt.executeQuery();
			while(rs.next()) {
				jsObj = new JSONObject();
				jsObj.put("accHeaderID", rs.getInt("ID"));
				jsObj.put("accHeaderName", rs.getString("DATA"));
				
				jsArr.put(jsObj);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
            DBConnection.releaseConnectionToDB(con, pstmt, rs);
        }
		return jsArr;
	}
	
	public JSONArray getCleaners(int systemId, String custId) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		JSONArray jsArr = new JSONArray();
		JSONObject jsObj = null;
		
		try {
			con = DBConnection.getConnectionToDB("LMS");
			pstmt = con.prepareStatement(ContainerCargoManagementStatements.GET_CLEANERS_LIST);
			pstmt.setInt(1, systemId);
			pstmt.setString(2, custId);
			rs = pstmt.executeQuery();
			while(rs.next()) {
				jsObj = new JSONObject();
				jsObj.put("cleanerID", rs.getInt("_ID"));
				jsObj.put("cleanerName", rs.getString("CONDUCTOR_NAME"));
				
				jsArr.put(jsObj);
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
            DBConnection.releaseConnectionToDB(con, pstmt, rs);
        }
		return jsArr;
	}
	
	public JSONArray getDrivers(int systemId, String custId) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		JSONArray jsArr = new JSONArray();
		JSONObject jsObj = null;
		
		try {
			con = DBConnection.getConnectionToDB("LMS");
			pstmt = con.prepareStatement(ContainerCargoManagementStatements.GET_DRIVER_LIST);
			pstmt.setInt(1, systemId);
			pstmt.setString(2, custId);
			rs = pstmt.executeQuery();
			while(rs.next()) {
				jsObj = new JSONObject();
				jsObj.put("driverID", rs.getInt("Driver_id"));
				jsObj.put("driverName", rs.getString("DriverName"));
				
				jsArr.put(jsObj);
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
            DBConnection.releaseConnectionToDB(con, pstmt, rs);
        }
		return jsArr;
	}
	
	public int saveCashBookDetails(Connection con, int systemId, String custId, int userId, String branchId, String transacTypeId, String transactionDate, String amount, 
			String accHeaderId, String description, String vehicleId, String driverId, String cleanerId, String billNo, int offset, String status) {
		
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        int id = 0;
        try {
            pstmt = con.prepareStatement(ContainerCargoManagementStatements.ADD_CASH_BOOK_DETAILS, Statement.RETURN_GENERATED_KEYS);
            pstmt.setInt(1, systemId);
            pstmt.setString(2, custId);
            pstmt.setString(3, branchId);
            pstmt.setString(4, transacTypeId);
            pstmt.setInt(5, offset);
            pstmt.setString(6, transactionDate);
            pstmt.setDouble(7, Double.parseDouble(amount));
            pstmt.setString(8, accHeaderId);
            pstmt.setString(9, description);
            pstmt.setString(10, billNo);
            pstmt.setString(11, vehicleId);
            pstmt.setString(12, driverId);
            pstmt.setString(13, cleanerId);
            pstmt.setInt(14, userId);
            pstmt.setInt(15, 0);
            pstmt.setString(16,"");
            pstmt.setString(17,"CASH_BOOK");
            pstmt.setString(18,status);
            
            pstmt.executeUpdate();
			rs = pstmt.getGeneratedKeys();
            if(rs.next()) {
            	id = rs.getInt(1);
            }
            
          //ADD DETAILS IN CASH_BOOK_MONTHLY TABLE FOR BRANCH WISE
        	
        	insertIntoCashBookMonthlyDetails(con, systemId, Integer.parseInt(custId), transactionDate, transacTypeId, Double.parseDouble(amount), branchId, offset, "CASH_BOOK", 0, "");
        } catch (Exception e) {
        	try {
        		if(con != null){
        			con.rollback();
        		}
			} catch (Exception e2) {
				e2.printStackTrace();
			}
        	e.printStackTrace();
        } finally {
            DBConnection.releaseConnectionToDB(null, pstmt, rs);
        }
		return id;
	}
	
	private void insertIntoCashBookMonthlyDetails(Connection con, int systemId, int custId, String date, String transacTypeId, double amount, String branchId, int offset, String type, double remainingAmount, String cbTransacType) {

		/*check for the month, year, branch data exists or not 
		 * if exists then update else insert */

		PreparedStatement pstmt = null;
		ResultSet rs = null;

		try {
			pstmt = con.prepareStatement(ContainerCargoManagementStatements.GET_CB_DETAILS_EXISTS);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, custId);
			pstmt.setString(3, branchId);
			pstmt.setInt(4, offset);
			pstmt.setString(5, date);
			pstmt.setInt(6, offset);
			pstmt.setString(7, date);
			rs = pstmt.executeQuery();

			if(rs.next()) {
				//update
				pstmt = con.prepareStatement(ContainerCargoManagementStatements.UPDATE_CB_MONTHLY_DETAILS);
				if(!type.equals("CASH_BOOK")) {
					if(cbTransacType.equals("Debit")) {
						if(transacTypeId.equals("1")) {
							pstmt.setDouble(1, -amount);
							pstmt.setDouble(2, remainingAmount);
							pstmt.setDouble(3, -amount);
						}/* else {
							pstmt.setDouble(1,  amount);
							pstmt.setDouble(2, - remainingAmount);
							pstmt.setDouble(3,  amount);
						}*/
					} else {
						if(transacTypeId.equals("1")) {
							pstmt.setDouble(1, amount);
							pstmt.setDouble(2, remainingAmount);
							pstmt.setDouble(3, amount);
						} else {
							pstmt.setDouble(1,  amount);
							pstmt.setDouble(2, - remainingAmount);
							pstmt.setDouble(3,  amount);
						}
					}
					
				} else {
					pstmt.setDouble(1, 0);
					
					if(transacTypeId.equals("1")) 
						pstmt.setDouble(2, amount);
					else 
						pstmt.setDouble(2, -amount);
					
					pstmt.setDouble(3, 0);

				} 
				
				pstmt.setInt(4, systemId);
				pstmt.setInt(5, custId);
				pstmt.setString(6, branchId);
				pstmt.setInt(7, offset);
				pstmt.setString(8, date);
				pstmt.setInt(9, offset);
				pstmt.setString(10, date);
				pstmt.executeUpdate();
			} else {
				//insert
				double closingBal = 0;

				pstmt = con.prepareStatement(ContainerCargoManagementStatements.GET_CBMD_LAST_MONTH_RECORD);
				pstmt.setInt(1, systemId);
				pstmt.setInt(2, custId);
				pstmt.setString(3, branchId);
				rs = pstmt.executeQuery();
				if(rs.next()) {
					closingBal = rs.getDouble("CLOSING_BAL");
				}

				pstmt = con.prepareStatement(ContainerCargoManagementStatements.INSERT_INTO_CBMD);
				pstmt.setInt(1, systemId);
				pstmt.setInt(2, custId);
				pstmt.setString(3, branchId);
				pstmt.setString(4, date);
				pstmt.setString(5, date);
				if(!type.equals("CASH_BOOK")) {
					if(transacTypeId.equals("1")) {
						pstmt.setDouble(6, amount);
						pstmt.setDouble(7, closingBal);
						pstmt.setDouble(8, closingBal + amount);
						pstmt.setDouble(9, closingBal + amount);
					} else {
						pstmt.setDouble(6, -amount);
						pstmt.setDouble(7, closingBal);
						pstmt.setDouble(8, closingBal - amount);
						pstmt.setDouble(9, closingBal - amount);
					}
				} else {
					pstmt.setDouble(6, 0);
					pstmt.setDouble(7, closingBal);
					
					if(transacTypeId.equals("1")) 
						pstmt.setDouble(8, closingBal + amount);
					else 
						pstmt.setDouble(8, closingBal - amount);
					
					pstmt.setDouble(9, closingBal);
				}
				pstmt.executeUpdate();
			}
		} catch (Exception e) {
			e.printStackTrace();
			try {
        		if(con != null){
        			con.rollback();
        		}
			} catch (Exception e2) {
				e2.printStackTrace();
			}
		} finally {
			DBConnection.releaseConnectionToDB(null, pstmt, rs);
		}

	}
	
	public int updateFileDetails(Connection con, String fileName, int id, int custId, int systemId, int userId, String fileExtension) {
        PreparedStatement pstmt = null;
        int i = 0;
        try {
            pstmt = con.prepareStatement(ContainerCargoManagementStatements.UPDATE_CASH_BOOK);
            pstmt.setString(1, fileName);
            pstmt.setString(2, fileExtension);
            pstmt.setInt(3, id);
            i = pstmt.executeUpdate();
        } catch (Exception e) {
        	try {
        		if(con != null){
        			con.rollback();
        		}
			} catch (Exception e2) {
				e2.printStackTrace();
			}
        	e.printStackTrace();
        }
		return i;
	}
	
	public ArrayList<Object> getCashBookDetails(int systemId, String custId, int userId, String branchId, int offset, String startDate, String endDate, String language) {
		Connection con = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        JSONArray jsArr = new JSONArray();
        JSONObject obj = null;
        int count = 0;
        
        ArrayList<ReportHelper> summaryReportsList = new ArrayList<ReportHelper>();
		ArrayList<String> summaryHeadersList = new ArrayList<String>();
		ReportHelper finalreporthelper = new ReportHelper();
		ArrayList<Object> summaryFinalList = new ArrayList<Object>();
		
        try {
        	
			summaryHeadersList.add(commonFunctions.getLabelFromDB("SLNO", language));
			summaryHeadersList.add(commonFunctions.getLabelFromDB("UID", language));
			summaryHeadersList.add(commonFunctions.getLabelFromDB("Transaction_Date", language));
			summaryHeadersList.add(commonFunctions.getLabelFromDB("Branch_Code", language));
			summaryHeadersList.add(commonFunctions.getLabelFromDB("Account_Header", language));
			summaryHeadersList.add(commonFunctions.getLabelFromDB("Trip_No", language));
			summaryHeadersList.add(commonFunctions.getLabelFromDB("Vehicle_No", language));
			summaryHeadersList.add(commonFunctions.getLabelFromDB("Driver", language));
			summaryHeadersList.add(commonFunctions.getLabelFromDB("Cleaner", language));
			summaryHeadersList.add(commonFunctions.getLabelFromDB("Bill_No", language));
			summaryHeadersList.add(commonFunctions.getLabelFromDB("Description", language));
			summaryHeadersList.add(commonFunctions.getLabelFromDB("Amount", language));
			summaryHeadersList.add(commonFunctions.getLabelFromDB("Transaction_Type", language));
			
            con = DBConnection.getConnectionToDB("LMS");
            pstmt = con.prepareStatement(ContainerCargoManagementStatements.GET_CASH_BOOK_DETAILS);
            pstmt.setInt(1, offset);
            pstmt.setInt(2, systemId);
            pstmt.setString(3, custId);
            pstmt.setString(4, branchId);
            pstmt.setInt(5, offset);
            pstmt.setString(6, startDate);
            pstmt.setInt(7, offset);
            pstmt.setString(8, endDate);
            rs = pstmt.executeQuery();
            
            while(rs.next()) {
            	
            	ArrayList<Object> informationList = new ArrayList<Object>();
				ReportHelper reporthelper = new ReportHelper();	
				
				count++;
				
            	obj = new JSONObject();
            	obj.put("slnoIndex", count);
            	informationList.add(count);
            	
            	obj.put("idIndex", rs.getInt("ID"));
            	informationList.add(rs.getInt("ID"));
            	
            	obj.put("transactionDateIndex", yyyymmdd.format(yyyymmdd.parse(rs.getString("TRANSAC_DATE"))));
            	informationList.add(yyyymmdd.format(yyyymmdd.parse(rs.getString("TRANSAC_DATE"))));
            	
            	obj.put("branchCodeIndex", rs.getString("BranchCode"));
            	informationList.add(rs.getString("BranchCode"));
            	
            	obj.put("accountHeaderIndex", rs.getString("ACC_HEADER"));
            	informationList.add(rs.getString("ACC_HEADER"));
            	
            	obj.put("tripNoIndex", rs.getString("TRIP_NO"));
            	informationList.add(rs.getString("TRIP_NO"));
            	
            	obj.put("vehicleIndex", rs.getString("ASSET_NO"));
            	informationList.add(rs.getString("ASSET_NO"));
            	
            	obj.put("driverIndex", rs.getString("DRIVER"));
            	informationList.add(rs.getString("DRIVER"));
            	
            	obj.put("cleanerIndex", rs.getString("CLEANER_NAME"));
            	informationList.add(rs.getString("CLEANER_NAME"));
            	
            	obj.put("billNoIndex", rs.getString("BILL_NO"));
            	informationList.add(rs.getString("BILL_NO"));
            	
            	obj.put("descriptionIndex", rs.getString("DESCRIPTION"));
            	informationList.add(rs.getString("DESCRIPTION"));
            	
            	obj.put("amountIndex", rs.getDouble("AMOUNT"));
            	informationList.add(rs.getDouble("AMOUNT"));
            	
            	obj.put("transactionTypeIndex", rs.getString("TRANSAC_TYPE"));
            	informationList.add(rs.getString("TRANSAC_TYPE"));
            	
            	jsArr.put(obj);
            	
            	reporthelper.setInformationList(informationList);
            	summaryReportsList.add(reporthelper);
            }
            pstmt.close();
            rs.close();
            
            summaryFinalList.add(jsArr);
			finalreporthelper.setReportsList(summaryReportsList);
			finalreporthelper.setHeadersList(summaryHeadersList);
			summaryFinalList.add(finalreporthelper);
            
        } catch (Exception e) {
        	e.printStackTrace();
        } finally {
            DBConnection.releaseConnectionToDB(con, pstmt, rs);
        }
		return summaryFinalList;
	}
	
	public JSONObject getDocuments(String custId, String id, String systemId) {

		JSONObject jsonObject = new JSONObject();
		Connection conAdmin=null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		String fileName = null;
		String destinationPath = new File(System.getProperty("catalina.base"))+ "/webapps/ApplicationImages/TempImageFile/";
		String localUrl = null;
		String dateTime = null;
		try {
			Properties properties = ApplicationListener.prop;
			String path = properties.getProperty("DocumentUploadPath").trim();
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			
			String fileExtension = null;
			conAdmin = DBConnection.getConnectionToDB("AMS");
			pstmt = conAdmin.prepareStatement(ContainerCargoManagementStatements.GET_UPLOADED_INVOICE);
			pstmt.setString(1, id);
			pstmt.setString(2, systemId);
			pstmt.setString(3, custId);
			rs = pstmt.executeQuery();
			Calendar cal = null;
			int day = 0;
			int month = 0;
			int year = 0;
			if(rs.next()){
				try {
					fileName = rs.getString("FILE_NAME");
					fileExtension = rs.getString("EXTENSION");
					dateTime = rs.getString("CREATED_DATE");
					if (dateTime!=null) {
						Date d = sdf.parse(dateTime);
						cal = Calendar.getInstance();
						cal.setTime(d);
						day = cal.get(Calendar.DAY_OF_MONTH);
						month = cal.get(Calendar.MONTH);
						year = cal.get(Calendar.YEAR);
						month+=1;
						File trgDir = new File(destinationPath);
						File srcDir = new File(path+"/"+"Padma_Invoice"+"/"+year+"/"+month+"/"+day+"/"+id+fileExtension);
						
						if(srcDir.exists()) {
							FileUtils.copyFileToDirectory(srcDir, trgDir);

							localUrl = trgDir+"/"+id+fileExtension;

							jsonObject = new JSONObject();
							jsonObject.put("id", id);
							jsonObject.put("name", fileName);
							jsonObject.put("fileExtension", fileExtension);
							jsonObject.put("url", localUrl);
						} else {
							jsonObject = new JSONObject();
							jsonObject.put("id", "No File Founds...");
						}
					}
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}finally{
			DBConnection.releaseConnectionToDB(conAdmin, pstmt, rs);
		}
		return jsonObject;
	
	}
	
	public HashMap<String, Integer> getVehicleCountWithStatus(int systemId, int custId, int offset) {
		HashMap<String, Integer> vehicleCountWithStatus = new HashMap<String, Integer>();
		Connection con = null;
		PreparedStatement pstmt = null;
		CallableStatement cstmt = null;
		
		ResultSet rs = null;
		
		try {
			con = DBConnection.getConnectionToDB("LMS");
			cstmt = con.prepareCall("{call IdleVehiclesDashboard (?,?,?)}",ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
			cstmt.setInt(1, systemId);
			cstmt.setInt(2, custId);
			cstmt.setInt(3, offset);
			rs = cstmt.executeQuery();
			
			if(rs.next()) {
				rs.last();
				vehicleCountWithStatus.put("Idle Vehicle", rs.getRow());
			} else {
				vehicleCountWithStatus.put("Idle Vehicle", 0);
			}
			rs.close();
			cstmt.close();
			
			cstmt = con.prepareCall("{call OnTripVehiclesDashboard (?,?,?)}",ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
			cstmt.setInt(1, systemId);
			cstmt.setInt(2, custId);
			cstmt.setInt(3, offset);
			rs = cstmt.executeQuery();
			
			if(rs.next()) {
				rs.last();
				vehicleCountWithStatus.put("On Trip", rs.getRow());
			} else {
				vehicleCountWithStatus.put("On Trip", 0);
			}
			rs.close();
			cstmt.close();
			
			cstmt = con.prepareCall("{call ReachedConsigneeVehiclesDashboard (?,?,?)}",ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
			cstmt.setInt(1, systemId);
			cstmt.setInt(2, custId);
			cstmt.setInt(3, offset);
			rs = cstmt.executeQuery();
			if(rs.next()) {
				rs.last();
				vehicleCountWithStatus.put("Reached Consignee", rs.getRow());
			} else {
				vehicleCountWithStatus.put("Reached Consignee", 0);
			}
			rs.close();
			cstmt.close();

			pstmt = con.prepareStatement(ContainerCargoManagementStatements.GET_VEHICLE_COUNT_WITH_STATUS);
		
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, custId);
			pstmt.setInt(3, systemId);
			pstmt.setInt(4, custId);
			pstmt.setInt(5, systemId);
			pstmt.setInt(6, custId);
			pstmt.setInt(7, systemId);
			pstmt.setInt(8, custId);
			pstmt.setInt(9, systemId);
			pstmt.setInt(10, custId);
			pstmt.setInt(11, systemId);
			pstmt.setInt(12, custId);
			rs = pstmt.executeQuery();
			while(rs.next()) {
				vehicleCountWithStatus.put(rs.getString("Status"), rs.getInt("CountOfVehicles"));
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return vehicleCountWithStatus;
	}
	
	public ArrayList<String> getIdleVehicleDetails(int systemId, int custId, int offset) {
		ArrayList<String> vehDetails = new ArrayList<String>();
		Connection con = null;
		CallableStatement cstmt = null;
		ResultSet rs = null;
		
		try {
			con = DBConnection.getConnectionToDB("LMS");
			cstmt = con.prepareCall("{call IdleVehiclesDashboard (?,?,?)}");
			cstmt.setInt(1, systemId);
			cstmt.setInt(2, custId);
			cstmt.setInt(3, offset);
			rs = cstmt.executeQuery();
			
			while(rs.next()) {
				String hubDep = ddmmyyyy.format(yyyymmdd.parse(rs.getString("HubDeparture")));
				if(hubDep.contains("1900")) {
					hubDep = "";
				}
				vehDetails.add(rs.getString("AssetNo") + " ( " + hubDep + " )");
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, cstmt, rs);
		}
		return vehDetails;
	}
	
	public Map<String, ArrayList<String>> getAssignedVehicleDetails(int systemId, int custId, int offset) {
		Map<String, ArrayList<String>> vehicleCountWithStatus = new LinkedHashMap<String, ArrayList<String>>();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		try {
			
			con = DBConnection.getConnectionToDB("AMS");
			
			//get all principle customer and create box for each
			pstmt = con.prepareStatement(ContainerCargoManagementStatements.GET_CUSTOMER_BASED_ON_TYPE);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, custId);
			pstmt.setString(3, "PRINCIPAL");
			rs = pstmt.executeQuery();
			Set<String> custSet = new TreeSet<String>();
			while(rs.next()) {
				custSet.add(rs.getString("CustCode"));
			}
			
			pstmt = con.prepareStatement(ContainerCargoManagementStatements.GET_DASHBOARD_ASSIGNED_VEHICLE_DETAILS);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, custId);
			rs = pstmt.executeQuery();
			
			ArrayList<String> vehDetails = new ArrayList<String>();
			
			int prevPrincId = 0;
			int nextPrincId = 0;
			String companyCode = "";
			while(rs.next()) {
				if(rs.getRow() == 1){
					vehDetails = new ArrayList<String>();
					prevPrincId = rs.getInt("PrincipalId");
					nextPrincId = rs.getInt("PrincipalId");
					companyCode = rs.getString("PrincipalCode");
				} else {
					prevPrincId = nextPrincId;
					nextPrincId = rs.getInt("PrincipalId");
				}
				
				if(prevPrincId == nextPrincId) {
					vehDetails.add(rs.getString("AssetNoWithCustCode"));
				} else {
					vehicleCountWithStatus.put(prevPrincId + "," + companyCode, vehDetails);
					companyCode = rs.getString("PrincipalCode");
					vehDetails = new ArrayList<String>();
					vehDetails.add(rs.getString("AssetNoWithCustCode"));
				}
			}
			vehicleCountWithStatus.put(nextPrincId + "," + companyCode, vehDetails);
			
			custSet.removeAll(vehicleCountWithStatus.keySet());
			for(String key : custSet) {
				vehicleCountWithStatus.put(key, new ArrayList<String>());
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return vehicleCountWithStatus;
	}
    
	public ArrayList<String> getOnTripVehicleDetails(int systemId, int custId, int offset) {
		ArrayList<String> vehDetails = new ArrayList<String>();
		Connection con = null;
		CallableStatement cstmt = null;
		ResultSet rs = null;
		
		try {
			con = DBConnection.getConnectionToDB("LMS");
			cstmt = con.prepareCall("{call OnTripVehiclesDashboard (?,?,?)}");
			cstmt.setInt(1, systemId);
			cstmt.setInt(2, custId);
			cstmt.setInt(3, offset);
			rs = cstmt.executeQuery();
			
			while(rs.next()) {
				vehDetails.add(rs.getString("AssetAndCust"));
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, cstmt, rs);
		}
		return vehDetails;
	}
	
	public ArrayList<String> getReachedConsigneeVehicleDetails(int systemId, int custId, int offset) {
		Connection con = null;
		CallableStatement cstmt = null;
		ResultSet rs = null;
		ArrayList<String> vehDetails = new ArrayList<String>();
		
		try {
			con = DBConnection.getConnectionToDB("LMS");//need to change query
			cstmt = con.prepareCall("{call ReachedConsigneeVehiclesDashboard (?,?,?)}");
			cstmt.setInt(1, systemId);
			cstmt.setInt(2, custId);
			cstmt.setInt(3, offset);
			rs = cstmt.executeQuery();
			
			while(rs.next()) {
				vehDetails.add(rs.getString("AssetNo") + "(" + rs.getString("CustCode") + "-" + ddmmyyyy.format(yyyymmdd.parse(rs.getString("HubArrival"))) + ")");
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, cstmt, rs);
		}
		return vehDetails;
	}
	
	public ArrayList<String> getUnderMaintenanceVehicleDetails(int systemId, int custId, int offset) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		ArrayList<String> vehDetails = new ArrayList<String>();
		
		try {
			con = DBConnection.getConnectionToDB("AMS");

			pstmt = con.prepareStatement(ContainerCargoManagementStatements.GET_DASHOBORD_UNDER_MAINTENANCE_VEHICLE_DETAILS);

			pstmt.setInt(1, offset);
			pstmt.setInt(2, systemId);
			pstmt.setInt(3, custId);
			rs = pstmt.executeQuery();

			while(rs.next()) {
				vehDetails.add(rs.getString("AssetNo") + "(" + ddmmyyyy.format(yyyymmdd.parse(rs.getString("RST"))) + ")");
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return vehDetails;
	}
	
	public ArrayList<String> getRepairedVehicleDetails(int systemId, int custId, int offset) {
		ArrayList<String> vehDetails = new ArrayList<String>();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		try {
			con = DBConnection.getConnectionToDB("AMS");

			pstmt = con.prepareStatement(ContainerCargoManagementStatements.GET_DASHOBORD_REPAIRED_VEHICLE_DETAILS);
			
			pstmt.setInt(1, offset);
			pstmt.setInt(2, systemId);
			pstmt.setInt(3, custId);
			pstmt.setInt(4, systemId);
			pstmt.setInt(5, custId);
			pstmt.setInt(6, systemId);
			pstmt.setInt(7, custId);
			pstmt.setInt(8, systemId);
			pstmt.setInt(9, custId);
			rs = pstmt.executeQuery();
			
			while(rs.next()) {
				vehDetails.add(rs.getString("AssetNo") + "(" + ddmmyyyy.format(yyyymmdd.parse(rs.getString("RET"))) + ")");
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return vehDetails;
	}
	
	public ArrayList<PTDashboardVehicleBean> getDAIdleVehicleDetailsWithDuration(int systemId, int custId, int offset) {
		ArrayList<PTDashboardVehicleBean> vehDetails = new ArrayList<PTDashboardVehicleBean>();
		Connection con = null;
		CallableStatement cstmt = null;
		ResultSet rs = null;
		
		try {
			con = DBConnection.getConnectionToDB("LMS");
			cstmt = con.prepareCall("{call IdleVehiclesDashboard (?,?,?)}");
			cstmt.setInt(1, systemId);
			cstmt.setInt(2, custId);
			cstmt.setInt(3, offset);
			rs = cstmt.executeQuery();
			while(rs.next()) {
				PTDashboardVehicleBean veh = new PTDashboardVehicleBean();
				veh.setAssetNo(rs.getString("AssetNo"));
				veh.setDuration(rs.getDouble("Duration"));
				vehDetails.add(veh);
			}
			Collections.sort(vehDetails, new Comparator<PTDashboardVehicleBean>() {
				public int compare(PTDashboardVehicleBean v1, PTDashboardVehicleBean v2) {
					return v2.getDuration().compareTo(v1.getDuration());
				}
			});
			
			if(vehDetails.size() > 5) {
				ArrayList<PTDashboardVehicleBean> vehList = new ArrayList<PTDashboardVehicleBean>();
				for(int i=0; i<5; i++) {
					vehList.add(vehDetails.get(i));
				}
				vehDetails = vehList;
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, cstmt, rs);
		}
		return vehDetails;
	}
	
	public ArrayList<Object> getDAAssignedVehicleDetails(int systemId, int custId, int offset) {
		ArrayList<Object> assignedVehicleCount = new ArrayList<Object>();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		try {
			
			con = DBConnection.getConnectionToDB("AMS");
			
			pstmt = con.prepareStatement(ContainerCargoManagementStatements.GET_DA_ASSIGNED_VEHICLE_DETAILS);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, custId);
			rs = pstmt.executeQuery();
			
			while(rs.next()) {
				assignedVehicleCount.add(rs.getString("PrincipalCode"));
				assignedVehicleCount.add(rs.getInt("CountOfVehicles"));
			}
			
//			System.out.println("GET_DA_ASSIGNED_VEHICLE_DETAILS : "+assignedVehicleCount.toString());
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return assignedVehicleCount;
	}
    
	public ArrayList<PTDashboardVehicleBean> getDAReachedConsigneeVehicleDetails(int systemId, int custId, int offset) {
		Connection con = null;
		CallableStatement cstmt = null;
		ResultSet rs = null;
		ArrayList<PTDashboardVehicleBean> vehDetails = new ArrayList<PTDashboardVehicleBean>();
		
		try {
			con = DBConnection.getConnectionToDB("LMS");
			cstmt = con.prepareCall("{call ReachedConsigneeVehiclesDashboard (?,?,?)}");
			cstmt.setInt(1, systemId);
			cstmt.setInt(2, custId);
			cstmt.setInt(3, offset);
			rs = cstmt.executeQuery();
			
			while(rs.next()) {
				PTDashboardVehicleBean veh = new PTDashboardVehicleBean();
				veh.setAssetNo(rs.getString("AssetNo"));
				veh.setDuration(rs.getDouble("Duration"));
				vehDetails.add(veh);
			}
			Collections.sort(vehDetails, new Comparator<PTDashboardVehicleBean>() {
				public int compare(PTDashboardVehicleBean v1, PTDashboardVehicleBean v2) {
					return v2.getDuration().compareTo(v1.getDuration());
				}
			});
			
			if(vehDetails.size() > 5) {
				ArrayList<PTDashboardVehicleBean> vehList = new ArrayList<PTDashboardVehicleBean>();
				for(int i=0; i<5; i++) {
					vehList.add(vehDetails.get(i));
				}
				vehDetails = vehList;
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, cstmt, rs);
		}
		return vehDetails;
	}
    
	public ArrayList<PTDashboardVehicleBean> getDAOnTripVehicleDetails(int systemId, int custId, int offset) {
		ArrayList<PTDashboardVehicleBean> vehDetails = new ArrayList<PTDashboardVehicleBean>();
		Connection con = null;
		CallableStatement cstmt = null;
		ResultSet rs = null;
		
		try {
			con = DBConnection.getConnectionToDB("LMS");
			cstmt = con.prepareCall("{call OnTripVehiclesDashboard (?,?,?)}");
			cstmt.setInt(1, systemId);
			cstmt.setInt(2, custId);
			cstmt.setInt(3, offset);
			rs = cstmt.executeQuery();
			
			while(rs.next()) {
				PTDashboardVehicleBean veh = new PTDashboardVehicleBean();
				veh.setAssetNo(rs.getString("AssetNo"));
				veh.setDuration(rs.getDouble("Duration"));
				vehDetails.add(veh);
			}
			Collections.sort(vehDetails, new Comparator<PTDashboardVehicleBean>() {
				public int compare(PTDashboardVehicleBean v1, PTDashboardVehicleBean v2) {
					return v2.getDuration().compareTo(v1.getDuration());
				}
			});
			
			if(vehDetails.size() > 5) {
				ArrayList<PTDashboardVehicleBean> vehList = new ArrayList<PTDashboardVehicleBean>();
				for(int i=0; i<5; i++) {
					vehList.add(vehDetails.get(i));
				}
				vehDetails = vehList;
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, cstmt, rs);
		}
		return vehDetails;
	}
	
	public ArrayList<String> getNumberOfTripsInLastMonths(int systemId, int custId, int offset) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		ArrayList<String> vehDetails = new ArrayList<String>();
		
		try {
			con = DBConnection.getConnectionToDB("AMS");
			String query = ContainerCargoManagementStatements.GET_TRIP_DONE_IN_LAST_THREE_MONTHS;
			query = query.replaceFirst("\\?", String.valueOf(offset));
			query = query.replaceFirst("\\?", String.valueOf(systemId));
			query = query.replaceFirst("\\?", String.valueOf(custId));
			query = query.replaceFirst("\\?", String.valueOf(offset));
			query = query.replaceFirst("\\?", String.valueOf(offset));
			query = query.replaceFirst("\\?", String.valueOf(offset));
			pstmt = con.prepareStatement(query);
			rs = pstmt.executeQuery();
			
			while(rs.next()) {
				vehDetails.add(rs.getString("NoOfTrips"));
				vehDetails.add(rs.getString("Date"));
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return vehDetails;
	}
	public ArrayList<Object> getExpenseDetails(int systemId, int customerId, int offset,String Status, String startDate, String endDate, String language){
		JSONArray JsonArray = new JSONArray();
		JSONObject JsonObject = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int slcount = 0;
		CommonFunctions commFunctions = new CommonFunctions();
		
		ArrayList<ReportHelper> reportsList = new ArrayList<ReportHelper>();
    	ArrayList<String> headersList = new ArrayList<String>();
    	ReportHelper finalreporthelper = new ReportHelper();
		ArrayList<Object> finalList = new ArrayList<Object>();
		
		headersList.add(commFunctions.getLabelFromDB("SLNO", language));
    	headersList.add(commFunctions.getLabelFromDB("Unique_Id", language));
    	headersList.add(commFunctions.getLabelFromDB("Trip_No", language));
    	headersList.add(commFunctions.getLabelFromDB("Trip_Date", language));
    	headersList.add(commFunctions.getLabelFromDB("Principal_Name", language));
    	headersList.add(commFunctions.getLabelFromDB("Consignee_Name", language));
		headersList.add(commFunctions.getLabelFromDB("Amount", language));
    	headersList.add(commFunctions.getLabelFromDB("Description", language));
    	
    	if(Status.equalsIgnoreCase("Rejected"))
    		headersList.add("Rejected Amount");
    	else
    		headersList.add(commFunctions.getLabelFromDB("Approved_Amount", language));
    	
    	headersList.add(commFunctions.getLabelFromDB("Account_Header", language));
    	headersList.add("Account Header Name");
    	headersList.add(commFunctions.getLabelFromDB("Remarks", language));
		headersList.add(commFunctions.getLabelFromDB("BranchID", language));
    	headersList.add(commFunctions.getLabelFromDB("Driver_Id", language));
    	headersList.add("Add Exp Date");
    	headersList.add(commFunctions.getLabelFromDB("Asset_No", language));
    	headersList.add("Billing Type");
		try {
			
			con = DBConnection.getConnectionToDB("AMS");
			if(Status.equalsIgnoreCase("Pending")) {
				pstmt = con.prepareStatement(ContainerCargoManagementStatements.GET_PENDING_EXPENSE_DETAILS);
				pstmt.setInt(1, offset);
				pstmt.setInt(2, offset);
				pstmt.setInt(3, systemId);
				pstmt.setInt(4, customerId);
				pstmt.setString(5, Status);
				pstmt.setInt(6, offset);
				pstmt.setString(7, startDate);
				pstmt.setInt(8, offset);
				pstmt.setString(9, endDate);
			} else if (Status.equalsIgnoreCase("APPROVED")) {
				pstmt = con.prepareStatement(ContainerCargoManagementStatements.GET_APPROVED_EXPENSE_DETAILS);
				pstmt.setInt(1, offset);
				pstmt.setInt(2, offset);
				pstmt.setInt(3, systemId);
				pstmt.setInt(4, customerId);
				pstmt.setString(5, Status);
				pstmt.setInt(6, offset);
				pstmt.setString(7, startDate);
				pstmt.setInt(8, offset);
				pstmt.setString(9, endDate);
			} else if(Status.equalsIgnoreCase("REJECTED")) {
				pstmt = con.prepareStatement(ContainerCargoManagementStatements.GET_REJECTED_EXPENSE_DETAILS);
				pstmt.setInt(1, offset);
				pstmt.setInt(2, offset);
				pstmt.setInt(3, systemId);
				pstmt.setInt(4, customerId);
				pstmt.setInt(5, offset);
				pstmt.setString(6, startDate);
				pstmt.setInt(7, offset);
				pstmt.setString(8, endDate);
			}
			rs = pstmt.executeQuery();
			while (rs.next()) {
				JsonObject = new JSONObject();
				ArrayList<Object> informationList=new ArrayList<Object>();
    			ReportHelper reporthelper=new ReportHelper();
				slcount++;
				
				informationList.add(Integer.toString(slcount));
				JsonObject.put("slnoIndex", slcount);

				informationList.add(rs.getString("UID"));
				JsonObject.put("uniqueIdDataIndex", rs.getString("UID"));
				
				informationList.add(rs.getString("TRIP_NO"));
				JsonObject.put("tripNoindex", rs.getString("TRIP_NO"));
				
				informationList.add(getFormattedDateStartingFromYearToDate(rs.getString("TripDate")));
				JsonObject.put("tripDateIndex", getFormattedDateStartingFromYearToDate(rs.getString("TripDate")));
				
				informationList.add(rs.getString("Principal"));
				JsonObject.put("principalNameIndex", rs.getString("Principal"));

				informationList.add(rs.getString("Consignee"));
				JsonObject.put("consigneeNameIndex", rs.getString("Consignee"));
				
				informationList.add(rs.getString("Amount"));
				JsonObject.put("amountIndex", rs.getString("Amount"));
				
				informationList.add(rs.getString("Description"));
				JsonObject.put("descriptionIndex", rs.getString("Description"));
				
				informationList.add(rs.getString("Approved_Amount"));
				JsonObject.put("approvedAmountIndex", rs.getString("Approved_Amount"));
				
				informationList.add(rs.getString("AccHeader"));
				JsonObject.put("accountHeaderIndex", rs.getString("AccHeader"));
				
				informationList.add(rs.getString("AccHeader"));
				JsonObject.put("accountHeaderNameIndex", rs.getString("AccHeader"));
				
				informationList.add(rs.getString("Remarks"));
				JsonObject.put("remarksIndex", rs.getString("Remarks"));
				
				informationList.add(rs.getString("BranchId"));
				JsonObject.put("branchIndex", rs.getString("BranchId"));
				
				informationList.add(rs.getString("DriverId"));
				JsonObject.put("driverIndex", rs.getString("DriverId"));
				
				informationList.add(getFormattedDateStartingFromYearToDate(rs.getString("INSERTED_DATE")));
				JsonObject.put("addExpDateIndex", getFormattedDateStartingFromYearToDate(rs.getString("INSERTED_DATE")));
				
				informationList.add(rs.getString("Asset_No"));
				JsonObject.put("assetNoIndex", rs.getString("Asset_No"));
				
				if(rs.getInt("BILLING_TYPE_ID")==1){
					informationList.add("Bill to Customer");
					JsonObject.put("billingTypeIndex", "Bill to Customer");
				}else{
					informationList.add("Bill to Self");
					JsonObject.put("billingTypeIndex", "Bill to Self");
				}
				
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
	
	
	public JSONArray getAccHeaderDetails(int systemId, int clientId) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		JSONObject obj = null;
		JSONArray jsonArray = new JSONArray();
		try{
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(ContainerCargoManagementStatements.GET_ACC_HEADER_DETAILS);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, clientId);
			pstmt.setString(3, "AccountHeader");
			rs = pstmt.executeQuery();
			while(rs.next()){
				obj = new JSONObject();
				obj.put("accHeaderId", rs.getString("typeId"));
				obj.put("accHeaderName", rs.getString("typeName"));
				jsonArray.put(obj);
			}
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jsonArray;
	}
	
	
	public String addApproveDetails(String UID,String tripNo,String tripDate,String amount,String description, String approvedAmount, String accHeader, String remarks, String branchId, String driverId, int userId, int clientId, int systemId,  int offset, String addExpDate, String assetNo) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String message="failure";
		
		try
		{	
			tripDate = addExpDate;
			double remainingAmt ;
			double amt,appAmt;
			amt = Double.parseDouble(amount);
			appAmt = Double.parseDouble(approvedAmount);
			remainingAmt = amt - appAmt;
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(ContainerCargoManagementStatements.UPDATE_ADDITIONAL_EXPENSE);
			pstmt.setString(1,approvedAmount);
			pstmt.setString(2,"APPROVED");
			pstmt.setInt(3,systemId);
			pstmt.setInt(4,clientId);
			pstmt.setInt(5,Integer.parseInt(UID));
			pstmt.executeUpdate();	

			pstmt = con.prepareStatement(ContainerCargoManagementStatements.ADD_CASH_BOOK_DETAILS);
			pstmt.setInt(1,systemId);
			pstmt.setInt(2,clientId);
			pstmt.setString(3,branchId);
			pstmt.setInt(4, 2);
			pstmt.setInt(5,offset);
			pstmt.setString(6,yyyymmdd.format(ddmmyy.parse(tripDate)));
			pstmt.setString(7,approvedAmount);
			pstmt.setString(8,accHeader);
			pstmt.setString(9,remarks); 
			pstmt.setString(10,"");
			pstmt.setString(11,assetNo);
			pstmt.setString(12,driverId);
			pstmt.setString(13,"");
			pstmt.setInt(14, userId);
			pstmt.setInt(15,Integer.parseInt(UID));
			pstmt.setString(16,tripNo);
			pstmt.setString(17,"EXP_APP");
			pstmt.setString(18,"APPROVED");
			pstmt.executeUpdate();

			if(remainingAmt > 0){
				pstmt = con.prepareStatement(ContainerCargoManagementStatements.ADD_CASH_BOOK_DETAILS);
				pstmt.setInt(1,systemId);
				pstmt.setInt(2,clientId);
				pstmt.setString(3,branchId);
				pstmt.setInt(4, 2);
				pstmt.setInt(5,offset);
				pstmt.setString(6,yyyymmdd.format(ddmmyy.parse(tripDate)));
				pstmt.setDouble(7,remainingAmt);
				pstmt.setInt(8,15);
				pstmt.setString(9,"Rej Amt of Add. Exp."); 
				pstmt.setString(10,"");
				pstmt.setString(11,assetNo);
				pstmt.setString(12,driverId);
				pstmt.setString(13,"");
				pstmt.setInt(14, userId);
				pstmt.setInt(15,Integer.parseInt(UID));
				pstmt.setString(16,tripNo);
				pstmt.setString(17,"EXP_APP");
				pstmt.setString(18,"APPROVED");
				pstmt.executeUpdate();
			}
			
			pstmt = con.prepareStatement(ContainerCargoManagementStatements.UPDATE_TRIP_DETAILS);
			pstmt.setInt(1,systemId);
			pstmt.setInt(2,clientId);
			pstmt.setString(3,tripNo);
			pstmt.setInt(4,systemId);
			pstmt.setInt(5,clientId);
			pstmt.setString(6,tripNo);
			pstmt.executeUpdate();
			
			message = "Updated Successfully";

		} catch(Exception e) {
			message = "Error occurred while approving...";
			try {
				if(con != null){
					con.rollback();
				}
			} catch (Exception e2) {
				e2.printStackTrace();
			}
			e.printStackTrace();	
		}
		finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return message;
	}
	
	public String addRejectDetails(String UID,String tripNo,String tripDate,String amount, String description, String remarks, String branchId, String driverId, int userId, int clientId, int systemId,  int offset, String addExpDate,String assetNo){
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String message="failure";
		
		try
		{	
			tripDate = addExpDate;			
			con = DBConnection.getConnectionToDB("AMS");
			con.setAutoCommit(false);
			pstmt = con.prepareStatement(ContainerCargoManagementStatements.UPDATE_ADDITIONAL_EXPENSE);
			pstmt.setInt(1,0);
			pstmt.setString(2,"REJECTED");
			pstmt.setInt(3,systemId);
			pstmt.setInt(4,clientId);
			pstmt.setInt(5,Integer.parseInt(UID));
			pstmt.executeUpdate();	

			pstmt = con.prepareStatement(ContainerCargoManagementStatements.ADD_CASH_BOOK_DETAILS);
			pstmt.setInt(1,systemId);
			pstmt.setInt(2,clientId);
			pstmt.setString(3,branchId);
			pstmt.setInt(4, 2);
			pstmt.setInt(5,offset);
			pstmt.setString(6,yyyymmdd.format(ddmmyy.parse(tripDate)));
			pstmt.setString(7,amount);
			pstmt.setInt(8,15);
			pstmt.setString(9,remarks); 
			pstmt.setString(10,"");
			pstmt.setString(11,assetNo);
			pstmt.setString(12,driverId);
			pstmt.setString(13,"");
			pstmt.setInt(14, userId);
			pstmt.setInt(15,Integer.parseInt(UID));
			pstmt.setString(16,tripNo);
			pstmt.setString(17,"EXP_APP");
			pstmt.setString(18,"APPROVED");
			pstmt.executeUpdate();			
			con.commit();
			message = "Updated Successfully";

		} catch(Exception e) {
			message = "Error occurred while rejecting...";
			try {
				if(con != null){
					con.rollback();
				}
			} catch (Exception e2) {
				e2.printStackTrace();
			}
			e.printStackTrace();	
		}
		finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return message;
	}
	
	
	public JSONArray getFuelVendor(String custId, int systemId) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		JSONArray jsArr = new JSONArray();
		JSONObject jsObj = null;
		
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(ContainerCargoManagementStatements.GET_FUEL_VENDOR);
			pstmt.setInt(1, systemId);
			pstmt.setString(2, custId);
			pstmt.setString(3, "Active");
			rs = pstmt.executeQuery();
			while(rs.next()) {
				jsObj = new JSONObject();
				jsObj.put("VendorId", rs.getString("VendorId"));
				jsObj.put("VendorName", rs.getString("VendorName"));	
				jsObj.put("fuelRate", rs.getString("FuelPricePerLitre"));
				jsArr.put(jsObj);
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
            DBConnection.releaseConnectionToDB(con, pstmt, rs);
        }
		return jsArr;
	}
	public String saveFuelLogDetails(String fuelVendorName, String fuelVendorId, String netPrice, String refillQty, String refillAmt, String dateVal, int custId, int systemId, String vhitxt, int offset) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String message = "Failure";
		
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(ContainerCargoManagementStatements.SAVE_FUEL_LOG_DETAILS);
			pstmt.setString(1, fuelVendorName);
			pstmt.setString(2, fuelVendorId);
			pstmt.setString(3, netPrice);
			pstmt.setString(4, refillQty);
			pstmt.setString(5, refillAmt);
			pstmt.setInt(6, offset);
			pstmt.setString(7, dateVal);
			pstmt.setInt(8, custId);
			pstmt.setInt(9, systemId);
			pstmt.setString(10, vhitxt);
			pstmt.setInt(11, 1);
			int updated = pstmt.executeUpdate();
			if(updated>0){
			message ="Added Successfully";
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
            DBConnection.releaseConnectionToDB(con, pstmt, rs);
        }
		return message;
	}

	public JSONArray getUserAssociatedBranches(int systemId, int clientId, int userId) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		JSONArray jArray = new JSONArray();
		JSONObject obj = null;
		try{
			con = DBConnection.getConnectionToDB("LMS");
			pstmt = con.prepareStatement(ContainerCargoManagementStatements.GET_USERS_BRANCH);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, clientId);
			pstmt.setInt(3, userId);
			rs = pstmt.executeQuery();
			while(rs.next()){
				obj = new JSONObject();
				obj.put("Id", rs.getInt("id"));
				obj.put("Name", rs.getString("branchName"));
				jArray.put(obj);
			}
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jArray;
	}
	public ArrayList<Object> getVehicleLedgerData(int custId, int systemId, int offset, String vehId, String startDate, String endDate,String language) {
		DecimalFormat df=new DecimalFormat("##.##");
		CommonFunctions commFunctions = new CommonFunctions();
    	Connection con = null;
    	PreparedStatement pstmt = null;
    	ResultSet rs = null;
    	JSONArray jsArr = new JSONArray();
    	JSONObject obj = new JSONObject();
    	JSONObject obj1 = new JSONObject();
    	JSONObject obj2 = new JSONObject();
    	JSONObject obj3 = new JSONObject();
    	int slcount = 0; 
    	
    	ArrayList<ReportHelper> reportsList = new ArrayList<ReportHelper>();
    	ArrayList<String> headersList = new ArrayList<String>();
    	ReportHelper finalreporthelper = new ReportHelper();
    	ArrayList<Object> finlist = new ArrayList<Object>();
    	
    	headersList.add(commFunctions.getLabelFromDB("SLNO", language));
    	headersList.add(commFunctions.getLabelFromDB("Trip_Start_Date", language));
    	headersList.add(commFunctions.getLabelFromDB("Trip_No", language));
    	headersList.add(commFunctions.getLabelFromDB("Principal_Name", language));
    	headersList.add(commFunctions.getLabelFromDB("Consignee_Name", language));
    	headersList.add(commFunctions.getLabelFromDB("R_Fee", language));
    	headersList.add(commFunctions.getLabelFromDB("B_Fee", language));
    	headersList.add(commFunctions.getLabelFromDB("Toll", language));
    	headersList.add(commFunctions.getLabelFromDB("Driver_Incentive", language));
    	headersList.add(commFunctions.getLabelFromDB("Police", language));
    	headersList.add(commFunctions.getLabelFromDB("Escort", language));
    	headersList.add(commFunctions.getLabelFromDB("Loading", language));
		headersList.add(commFunctions.getLabelFromDB("Unloading_Charges", language));
		headersList.add(commFunctions.getLabelFromDB("Octroi", language));
    	headersList.add(commFunctions.getLabelFromDB("Labour_Charges", language)); 
    	headersList.add(commFunctions.getLabelFromDB("Other_Expenses", language));
		headersList.add(commFunctions.getLabelFromDB("Total_Trip_Expense", language));
		headersList.add(commFunctions.getLabelFromDB("Advance_Cash", language));
    	headersList.add(commFunctions.getLabelFromDB("Total_Approved_Additional_Expenses", language));
    	headersList.add(commFunctions.getLabelFromDB("Morning_Incentive", language));
    	headersList.add(commFunctions.getLabelFromDB("Conveyance", language));
    	
    	try {
    		con = DBConnection.getConnectionToDB("AMS");
    		if(vehId.equals("All")) {
    			pstmt = con.prepareStatement(ContainerCargoManagementStatements.GET_VEHICLE_LEDGER_DETAILS.replace("and td.ASSET_NO=?", ""));
    		} else {
    			pstmt = con.prepareStatement(ContainerCargoManagementStatements.GET_VEHICLE_LEDGER_DETAILS);
    			pstmt.setString(8, vehId);
    		}
    		
    		pstmt.setInt(1, offset);
    		pstmt.setInt(2, systemId);
    		pstmt.setInt(3, custId);
    		pstmt.setString(4, startDate);
    		pstmt.setString(5, endDate);
    		pstmt.setInt(6, systemId);
    		pstmt.setInt(7, custId);
    		
    		rs = pstmt.executeQuery();
    		
    		double totalRFee = 0;
			double totalBFee = 0;
			double totalTollFee = 0;
			double totalDriverIncentive = 0;
			double totalPolice = 0;
			double totalEscort = 0;
			double totalLoading = 0;
			double totalUnloading = 0;
			double totalOctroi = 0;
			double totalLabourCost = 0;
			double totalOthersCost = 0;
			double totalTotalExpense = 0;
			double totalAdvanceCash = 0;
			double totalApprovedAddExpense = 0;
			double totalMrngIncentive = 0;
			double totalConveyance = 0;
			String CurDriver="";
			String PreDriver="";
			
    		while (rs.next()) {
    			obj = new JSONObject();
    			ArrayList<Object> informationList=new ArrayList<Object>();
    			ReportHelper reporthelper=new ReportHelper();
    			slcount++;
    			CurDriver = rs.getString("DriverName");
    			
    			if(!(PreDriver.equals("")) && !(PreDriver.equalsIgnoreCase(CurDriver))){
                     
					obj2 = new JSONObject();
					ArrayList<Object> informationList2=new ArrayList<Object>();
					ReportHelper reporthelper2=new ReportHelper();
					 
	    			informationList2.add(Integer.toString(slcount));
	    			obj2.put("slnoIndex", slcount);
	    			
	    			informationList2.add("");
	    			obj2.put("tripStartDateIndex", "");
	    			    			
	    			informationList2.add("");
	    			obj2.put("tripNoIndex", "");
	    			
	    			informationList2.add("");
	    			obj2.put("principalNameIndex", "");
	    			
	    			informationList2.add("TOTAL");
	    			obj2.put("consigneeNameIndex", "<b>TOTAL</b>");
	    			   			
	    			informationList2.add(df.format(totalRFee));
	    			obj2.put("rFeeIndex","<b>" + df.format(totalRFee) + "</b>");
					   			
	    			informationList2.add(df.format(totalBFee));
	    			obj2.put("bFeeIndex", "<b>" + df.format(totalBFee) + "</b>");
	    			
	    			informationList2.add(df.format(totalTollFee));
	    			obj2.put("tollIndex", "<b>" + df.format(totalTollFee) + "</b>");
	    			
	    			informationList2.add(df.format(totalDriverIncentive));
	    			obj2.put("driverIncentiveIndex",  "<b>" + df.format(totalDriverIncentive) + "</b>");
	    			
	    			informationList2.add(df.format(totalPolice));
	    			obj2.put("policeIndex", "<b>" + df.format(totalPolice) + "</b>");
	    			
	    			informationList2.add(df.format(totalEscort));
	    			obj2.put("escortIndex","<b>" + df.format(totalEscort) + "</b>");
	    			
	    			informationList2.add(df.format(totalLoading));
	    			obj2.put("loadingIndex", "<b>" + df.format(totalLoading) + "</b>");
					
					informationList2.add(df.format(totalUnloading));
	    			obj2.put("unloadingChargesIndex", "<b>" + df.format(totalUnloading) + "</b>");
					
					informationList2.add(df.format(totalOctroi));
	    			obj2.put("octroiIndex","<b>" + df.format(totalOctroi) + "</b>");
	    			
	    			informationList2.add(df.format(totalLabourCost));
	    			obj2.put("labourChargesIndex","<b>" + df.format(totalLabourCost) + "</b>");
	    			   			    			
	    			informationList2.add(df.format(totalOthersCost));
	    			obj2.put("otherExpensesIndex", "<b>" + df.format(totalOthersCost) + "</b>");
					
					informationList2.add(df.format(totalTotalExpense));
	    			obj2.put("totalTripExpenseIndex", "<b>" + df.format(totalTotalExpense) + "</b>");
	    			
	    			informationList2.add(df.format(totalAdvanceCash));
	    			obj2.put("driverAdvanceIndex", "<b>" + df.format(totalAdvanceCash) + "</b>");
					
					informationList2.add(df.format(totalApprovedAddExpense));
	    			obj2.put("totalApprovedAdditionalExpensesIndex", "<b>" + df.format(totalApprovedAddExpense) + "</b>");
	    			
	    			informationList2.add(df.format(totalMrngIncentive));
	    			obj2.put("morningIncentiveIndex", "<b>" + df.format(totalMrngIncentive) + "</b>");
	    			
	    			informationList2.add(df.format(totalConveyance));
	    			obj2.put("conveyanceIndex","<b>" + df.format(totalConveyance) + "</b>");
	    			
	    			jsArr.put(obj2);
	    			reporthelper2.setInformationList(informationList2);
	    			reportsList.add(reporthelper2);
	    				
	    			 totalRFee = 0;
	    			 totalBFee = 0;
	    			 totalTollFee = 0;
	    			 totalDriverIncentive = 0;
	    			 totalPolice = 0;
	    			 totalEscort = 0;
	    			 totalLoading = 0;
	    			 totalUnloading = 0;
	    			 totalOctroi = 0;
	    			 totalLabourCost = 0;
	    			 totalOthersCost = 0;
	    			 totalTotalExpense = 0;
	    			 totalAdvanceCash = 0;
	    			 totalApprovedAddExpense = 0;
	    			 totalMrngIncentive = 0;
	    			 totalConveyance = 0;
				}
    			if(!PreDriver.equalsIgnoreCase(CurDriver))
    			{ 
    				for(int i=0;i<2;i++ ){
    					if(i==0){
    						obj1 = new JSONObject();
    						ArrayList<Object> informationList1=new ArrayList<Object>();
    						ReportHelper reporthelper1=new ReportHelper();
    						slcount++;
    						
    						informationList1.add(Integer.toString(slcount));
    		    			obj1.put("slnoIndex", slcount);

    		    			informationList1.add("");
    		    			obj1.put("tripStartDateIndex", "");
    		    			    			
    		    			informationList1.add(CurDriver);
    		    			obj1.put("tripNoIndex", "<b style=color:BLUE;>" + CurDriver + "<b>");
    		    			
    		    			informationList1.add("");
    		    			obj1.put("principalNameIndex", "");
    		    			
    		    			informationList1.add("");
    		    			obj1.put("consigneeNameIndex", "");
    		    			   			
    		    			informationList1.add("");
    		    			obj1.put("rFeeIndex","");
    		    			
    		    			informationList1.add("");
    		    			obj1.put("bFeeIndex", "");
    		    			
    		    			informationList1.add("");
    		    			obj1.put("tollIndex", "");
    		    			
    		    			informationList1.add("");
    		    			obj1.put("driverIncentiveIndex","");
    		    			
    		    			informationList1.add("");
    		    			obj1.put("policeIndex", "");
    		    			
    		    			informationList1.add("");
    		    			obj1.put("escortIndex", "");
    		    			
    		    			informationList1.add("");
    		    			obj1.put("loadingIndex","");
    		    			
    						informationList1.add("");
    		    			obj1.put("unloadingChargesIndex","");
    		    			
    						informationList1.add("");
    		    			obj1.put("octroiIndex", "");
    		    			
    		    			informationList1.add("");
    		    			obj1.put("labourChargesIndex","");
    		    			
    		    			informationList1.add("");
    		    			obj1.put("otherExpensesIndex","");
    		    			
    						informationList1.add("");
    		    			obj1.put("totalTripExpenseIndex", "");
    		    			
    		    			informationList1.add("");
    		    			obj1.put("driverAdvanceIndex","");
    		    			
    						informationList1.add("");
    		    			obj1.put("totalApprovedAdditionalExpensesIndex","");
    		    			
    		    			informationList1.add("");
    		    			obj1.put("morningIncentiveIndex","");
    		    			
    		    			informationList1.add("");
    		    			obj1.put("conveyanceIndex","");
    		    			
    		    			jsArr.put(obj1);
    		    			reporthelper1.setInformationList(informationList1);
    		    			reportsList.add(reporthelper1);
    		    		
    					}else{
    						slcount++;
    						
    		    			informationList.add(Integer.toString(slcount));
    		    			obj.put("slnoIndex", slcount);
    		    			
    		    			informationList.add(ddmmyyyy.format(yyyymmdd.parseObject(rs.getString("TripStartDate"))));
    		    			obj.put("tripStartDateIndex", ddmmyyyy.format(yyyymmdd.parse(rs.getString("TripStartDate"))));
    		    			    			
    		    			informationList.add(rs.getString("TripNo"));
    		    			obj.put("tripNoIndex", rs.getString("TripNo"));
    		    			
    		    			informationList.add(rs.getString("Principle"));
    		    			obj.put("principalNameIndex", rs.getString("Principle"));
    		    			
    		    			informationList.add(rs.getString("Consignee"));
    		    			obj.put("consigneeNameIndex", rs.getString("Consignee"));
    		    			   			
    		    			informationList.add(df.format(rs.getDouble("RFee")));
    		    			obj.put("rFeeIndex", df.format(rs.getDouble("RFee")));
    		    			totalRFee = totalRFee + rs.getDouble("RFee");
    		    			
    		    			informationList.add(df.format(rs.getDouble("BFee")));
    		    			obj.put("bFeeIndex", df.format(rs.getDouble("BFee")));
    		    			totalBFee = totalBFee + rs.getDouble("BFee");
    		    			
    		    			informationList.add(df.format(rs.getDouble("TollFee")));
    		    			obj.put("tollIndex", df.format(rs.getDouble("TollFee")));
    		    			totalTollFee = totalTollFee + rs.getDouble("TollFee");
    		    			
    		    			informationList.add(df.format(rs.getDouble("DriverIncentive")));
    		    			obj.put("driverIncentiveIndex", df.format(rs.getDouble("DriverIncentive")));
    		    			totalDriverIncentive = totalDriverIncentive + rs.getDouble("DriverIncentive");
    		    			
    		    			informationList.add(df.format(rs.getDouble("Police")));
    		    			obj.put("policeIndex", df.format(rs.getDouble("Police")));
    		    			totalPolice = totalPolice + rs.getDouble("Police");
    		    			
    		    			informationList.add(df.format(rs.getDouble("Escort")));
    		    			obj.put("escortIndex", df.format(rs.getDouble("Escort")));
    		    			totalEscort = totalEscort + rs.getDouble("Escort");
    		    			
    		    			informationList.add(df.format(rs.getDouble("Loading")));
    		    			obj.put("loadingIndex", df.format(rs.getDouble("Loading")));
    		    			totalLoading = totalLoading + rs.getDouble("Loading");
    						
    						informationList.add(df.format(rs.getDouble("Unloading")));
    		    			obj.put("unloadingChargesIndex", df.format(rs.getDouble("Unloading")));
    		    			totalUnloading = totalUnloading + rs.getDouble("Unloading");
    						
    						informationList.add(df.format(rs.getDouble("Octroi")));
    		    			obj.put("octroiIndex", df.format(rs.getDouble("Octroi")));
    		    			totalOctroi = totalOctroi + rs.getDouble("Octroi");
    		    			
    		    			informationList.add(df.format(rs.getDouble("LabourCost")));
    		    			obj.put("labourChargesIndex", df.format(rs.getDouble("LabourCost")));
    		    			totalLabourCost = totalLabourCost + rs.getDouble("LabourCost");
    		    			   			    			
    		    			informationList.add(df.format(rs.getDouble("OthersCost")));
    		    			obj.put("otherExpensesIndex", df.format(rs.getDouble("OthersCost")));
    		    			totalOthersCost = totalOthersCost + rs.getDouble("OthersCost");
    						
    						informationList.add(df.format(rs.getDouble("TotalExpense")));
    		    			obj.put("totalTripExpenseIndex", df.format(rs.getDouble("TotalExpense")));
    		    			totalTotalExpense = totalTotalExpense + rs.getDouble("TotalExpense");
    		    			
    		    			informationList.add(df.format(rs.getDouble("AdvanceCash")));
    		    			obj.put("driverAdvanceIndex", df.format(rs.getDouble("AdvanceCash")));
    		    			totalAdvanceCash = totalAdvanceCash + rs.getDouble("AdvanceCash");
    						
    						informationList.add(df.format(rs.getDouble("ApprovedAddExpense")));
    		    			obj.put("totalApprovedAdditionalExpensesIndex", df.format(rs.getDouble("ApprovedAddExpense")));
    		    			totalApprovedAddExpense = totalApprovedAddExpense + rs.getDouble("ApprovedAddExpense");
    		    			
    		    			informationList.add(df.format(rs.getDouble("MrngIncentive")));
    		    			obj.put("morningIncentiveIndex", df.format(rs.getDouble("MrngIncentive")));
    		    			totalMrngIncentive = totalMrngIncentive + rs.getDouble("MrngIncentive");
    		    			
    		    			informationList.add(df.format(rs.getDouble("Conveyance")));
    		    			obj.put("conveyanceIndex", df.format(rs.getDouble("Conveyance")));
    		    			totalConveyance = totalConveyance + rs.getDouble("Conveyance");
    		    			
    		    			jsArr.put(obj);
    		    			reporthelper.setInformationList(informationList);
    		    			reportsList.add(reporthelper);	
    		    		
    					}
    				}
    				
    			}else{
    				slcount++;
    				
        			informationList.add(Integer.toString(slcount));
        			obj.put("slnoIndex", slcount);
        			
        			informationList.add(ddmmyyyy.format(yyyymmdd.parseObject(rs.getString("TripStartDate"))));
        			obj.put("tripStartDateIndex", ddmmyyyy.format(yyyymmdd.parse(rs.getString("TripStartDate"))));
        			    			
        			informationList.add(rs.getString("TripNo"));
        			obj.put("tripNoIndex", rs.getString("TripNo"));
        			
        			informationList.add(rs.getString("Principle"));
        			obj.put("principalNameIndex", rs.getString("Principle"));
        			
        			informationList.add(rs.getString("Consignee"));
        			obj.put("consigneeNameIndex", rs.getString("Consignee"));
        			   			
        			informationList.add(df.format(rs.getDouble("RFee")));
        			obj.put("rFeeIndex", df.format(rs.getDouble("RFee")));
        			totalRFee = totalRFee + rs.getDouble("RFee");
        			
        			informationList.add(df.format(rs.getDouble("BFee")));
        			obj.put("bFeeIndex", df.format(rs.getDouble("BFee")));
        			totalBFee = totalBFee + rs.getDouble("BFee");
        			
        			informationList.add(df.format(rs.getDouble("TollFee")));
        			obj.put("tollIndex", df.format(rs.getDouble("TollFee")));
        			totalTollFee = totalTollFee + rs.getDouble("TollFee");
        			
        			informationList.add(df.format(rs.getDouble("DriverIncentive")));
        			obj.put("driverIncentiveIndex", df.format(rs.getDouble("DriverIncentive")));
        			totalDriverIncentive = totalDriverIncentive + rs.getDouble("DriverIncentive");
        			
        			informationList.add(df.format(rs.getDouble("Police")));
        			obj.put("policeIndex", df.format(rs.getDouble("Police")));
        			totalPolice = totalPolice + rs.getDouble("Police");
        			
        			informationList.add(df.format(rs.getDouble("Escort")));
        			obj.put("escortIndex", df.format(rs.getDouble("Escort")));
        			totalEscort = totalEscort + rs.getDouble("Escort");
        			
        			informationList.add(df.format(rs.getDouble("Loading")));
        			obj.put("loadingIndex", df.format(rs.getDouble("Loading")));
        			totalLoading = totalLoading + rs.getDouble("Loading");
    				
    				informationList.add(df.format(rs.getDouble("Unloading")));
        			obj.put("unloadingChargesIndex", df.format(rs.getDouble("Unloading")));
        			totalUnloading = totalUnloading + rs.getDouble("Unloading");
    				
    				informationList.add(df.format(rs.getDouble("Octroi")));
        			obj.put("octroiIndex", df.format(rs.getDouble("Octroi")));
        			totalOctroi = totalOctroi + rs.getDouble("Octroi");
        			
        			informationList.add(df.format(rs.getDouble("LabourCost")));
        			obj.put("labourChargesIndex", df.format(rs.getDouble("LabourCost")));
        			totalLabourCost = totalLabourCost + rs.getDouble("LabourCost");
        			   			    			
        			informationList.add(df.format(rs.getDouble("OthersCost")));
        			obj.put("otherExpensesIndex", df.format(rs.getDouble("OthersCost")));
        			totalOthersCost = totalOthersCost + rs.getDouble("OthersCost");
    				
    				informationList.add(df.format(rs.getDouble("TotalExpense")));
        			obj.put("totalTripExpenseIndex", df.format(rs.getDouble("TotalExpense")));
        			totalTotalExpense = totalTotalExpense + rs.getDouble("TotalExpense");
        			
        			informationList.add(df.format(rs.getDouble("AdvanceCash")));
        			obj.put("driverAdvanceIndex", df.format(rs.getDouble("AdvanceCash")));
        			totalAdvanceCash = totalAdvanceCash + rs.getDouble("AdvanceCash");
    				
    				informationList.add(df.format(rs.getDouble("ApprovedAddExpense")));
        			obj.put("totalApprovedAdditionalExpensesIndex", df.format(rs.getDouble("ApprovedAddExpense")));
        			totalApprovedAddExpense = totalApprovedAddExpense + rs.getDouble("ApprovedAddExpense");
        			
        			informationList.add(df.format(rs.getDouble("MrngIncentive")));
        			obj.put("morningIncentiveIndex", df.format(rs.getDouble("MrngIncentive")));
        			totalMrngIncentive = totalMrngIncentive + rs.getDouble("MrngIncentive");
        			
        			informationList.add(df.format(rs.getDouble("Conveyance")));
        			obj.put("conveyanceIndex", df.format(rs.getDouble("Conveyance")));
        			totalConveyance = totalConveyance + rs.getDouble("Conveyance");
        			
        			jsArr.put(obj);
        			reporthelper.setInformationList(informationList);
        			reportsList.add(reporthelper);	
        		
    			}
    			PreDriver=CurDriver;
    		}	
    		if(slcount > 0){
    		obj3 = new JSONObject();
    		ArrayList<Object> informationList3=new ArrayList<Object>();
    		ReportHelper reporthelper3=new ReportHelper();
    		slcount++;
    		
			informationList3.add(Integer.toString(slcount));
			obj3.put("slnoIndex", slcount);
			
			informationList3.add("");
			obj3.put("tripStartDateIndex", "");
			    			
			informationList3.add("");
			obj3.put("tripNoIndex", "");
			
			informationList3.add("");
			obj3.put("principalNameIndex", "");
			
			informationList3.add("TOTAL");
			obj3.put("consigneeNameIndex", "<b>TOTAL</b>");
			   			
			informationList3.add(df.format(totalRFee));
			obj3.put("rFeeIndex","<b>" + df.format(totalRFee) + "</b>");
			   			
			informationList3.add(df.format(totalBFee));
			obj3.put("bFeeIndex", "<b>" + df.format(totalBFee) + "</b>");
			
			informationList3.add(df.format(totalTollFee));
			obj3.put("tollIndex", "<b>" + df.format(totalTollFee) + "</b>");
			
			informationList3.add(df.format(totalDriverIncentive));
			obj3.put("driverIncentiveIndex",  "<b>" + df.format(totalDriverIncentive) + "</b>");
			
			informationList3.add(df.format(totalPolice));
			obj3.put("policeIndex", "<b>" + df.format(totalPolice) + "</b>");
			
			informationList3.add(df.format(totalEscort));
			obj3.put("escortIndex","<b>" + df.format(totalEscort) + "</b>");
			
			informationList3.add(df.format(totalLoading));
			obj3.put("loadingIndex", "<b>" + df.format(totalLoading) + "</b>");
			
			informationList3.add(df.format(totalUnloading));
			obj3.put("unloadingChargesIndex", "<b>" + df.format(totalUnloading) + "</b>");
			
			informationList3.add(df.format(totalOctroi));
			obj3.put("octroiIndex","<b>" + df.format(totalOctroi) + "</b>");
			
			informationList3.add(df.format(totalLabourCost));
			obj3.put("labourChargesIndex","<b>" + df.format(totalLabourCost) + "</b>");
			   			    			
			informationList3.add(df.format(totalOthersCost));
			obj3.put("otherExpensesIndex", "<b>" + df.format(totalOthersCost) + "</b>");
			
			informationList3.add(df.format(totalTotalExpense));
			obj3.put("totalTripExpenseIndex", "<b>" + df.format(totalTotalExpense) + "</b>");
			
			informationList3.add(df.format(totalAdvanceCash));
			obj3.put("driverAdvanceIndex", "<b>" + df.format(totalAdvanceCash) + "</b>");
			
			informationList3.add(df.format(totalApprovedAddExpense));
			obj3.put("totalApprovedAdditionalExpensesIndex", "<b>" + df.format(totalApprovedAddExpense) + "</b>");
			
			informationList3.add(df.format(totalMrngIncentive));
			obj3.put("morningIncentiveIndex", "<b>" + df.format(totalMrngIncentive) + "</b>");
			
			informationList3.add(df.format(totalConveyance));
			obj3.put("conveyanceIndex","<b>" + df.format(totalConveyance) + "</b>");
			
			
			jsArr.put(obj3);
			reporthelper3.setInformationList(informationList3);
			reportsList.add(reporthelper3);	
    	  }
    		finlist.add(jsArr);
			finalreporthelper.setReportsList(reportsList);
			finalreporthelper.setHeadersList(headersList);
			finlist.add(finalreporthelper);
		} 	catch (Exception e) {
			e.printStackTrace();
		} 	finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
			return finlist;
	}
	public ArrayList<Object> getDetentionChargesDetails(int systemId,int clientId, int branchId, String vehicleNo, String startDate,String endDate,int offset) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		JSONArray jArr = new JSONArray();
		JSONObject obj = null;
		int count = 0;
		ArrayList<String> headersList = new ArrayList<String>();
		DecimalFormat doubleDecimal = new DecimalFormat("00.00");
		ArrayList<Object> informationList = null;
		ArrayList<ReportHelper> reportList = new ArrayList<ReportHelper>();
		ReportHelper reportHelper = null;
		ReportHelper finalReoprtHelper = new ReportHelper();
		ArrayList<Object> finlist = new ArrayList<Object>();
		try{
			headersList.add("SL NO");
			headersList.add("Loading Branch");
			headersList.add("Vehicle No");
			headersList.add("Driver Name");
			headersList.add("Driver No");
			headersList.add("Trip No");
			headersList.add("Principal Name");
			headersList.add("Consignee Name");
			headersList.add("Consignee Arrival Time");
			headersList.add("Consignee Departure Time");
			headersList.add("Detention Duration(HH:MM)");
			headersList.add("Detention Charges");
			
			con = DBConnection.getConnectionToDB("LMS");
			
			if(vehicleNo.equals("All")) {
				pstmt = con.prepareStatement(ContainerCargoManagementStatements.GET_DETENTION_CHARGES_DETAILS.replace("and td.ASSET_NO=?", ""));
			} else {
				pstmt = con.prepareStatement(ContainerCargoManagementStatements.GET_DETENTION_CHARGES_DETAILS);
				pstmt.setString(10, vehicleNo);
			}
			pstmt.setInt(1, offset);
			pstmt.setInt(2, offset);
			pstmt.setInt(3, systemId);
			pstmt.setInt(4, clientId);
			pstmt.setInt(5, branchId);
			pstmt.setInt(6, offset);
			pstmt.setString(7, startDate.replace("T", " "));
			pstmt.setInt(8, offset);
			pstmt.setString(9, endDate.replace("T", " "));
			
			rs = pstmt.executeQuery();
			while(rs.next()){
				count++;
				obj = new JSONObject();
				informationList = new ArrayList<Object>();
				reportHelper = new ReportHelper();
				
				obj.put("SLNODataIndex", count);
				informationList.add(count);
				obj.put("LoadingBranchIndex", rs.getString("branchName"));
				informationList.add(rs.getString("branchName"));
				obj.put("VehicleNoIndex", rs.getString("vehicleNo"));
				informationList.add(rs.getString("vehicleNo"));
				obj.put("DriverNameIndex", rs.getString("driverName"));
				informationList.add(rs.getString("driverName"));
				obj.put("DriverNoIndex", rs.getString("driverNo"));
				informationList.add(rs.getString("driverNo"));
				obj.put("TripNoIndex", rs.getString("tripNo"));
				informationList.add(rs.getString("tripNo"));
				obj.put("PrincipalNameIndex", rs.getString("principalName"));
				informationList.add(rs.getString("principalName"));
				obj.put("ConsigneeNameIndex", rs.getString("consigneeName"));
				informationList.add(rs.getString("consigneeName"));
				if(!rs.getString("arrivalTime").contains("1900")){
					obj.put("ConsigneeArrivalTimeIndex", ddmmyyyy.format(yyyymmdd.parse(rs.getString("arrivalTime"))));
					informationList.add(ddmmyyyy.format(yyyymmdd.parse(rs.getString("arrivalTime"))));
				}else{
					obj.put("ConsigneeArrivalTimeIndex", "");
					informationList.add("");
				}
				if(!rs.getString("depTime").contains("1900")){
					obj.put("ConsigneeDepartureTimeIndex", ddmmyyyy.format(yyyymmdd.parse(rs.getString("depTime"))));
					informationList.add(ddmmyyyy.format(yyyymmdd.parse(rs.getString("depTime"))));
				}else{
					obj.put("ConsigneeDepartureTimeIndex", "");
					informationList.add("");
				}
				obj.put("DetentionDurationIndex", rs.getString("detentionHrs").replace(".", ":"));
				informationList.add(rs.getString("detentionHrs").replace(".", ":"));
				
				obj.put("DetentionChargeIndex", doubleDecimal.format(rs.getDouble("detentionCharge")));
				informationList.add(doubleDecimal.format(rs.getDouble("detentionCharge")));
				jArr.put(obj);
				reportHelper.setInformationList(informationList);
				reportList.add(reportHelper);
			}
			finalReoprtHelper.setHeadersList(headersList);
			finalReoprtHelper.setReportsList(reportList);
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		finlist.add(jArr);
		finlist.add(finalReoprtHelper);
		return finlist;
	}

	public ArrayList<Object> getCashBookReportDetails(int systemId, String custId, String branchId, String transactionTypeId, String year, int offset, String language) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		JSONArray jsonArr = new JSONArray();
		JSONObject jsonObj = new JSONObject();
		
		double janMonthTotal = 0;
		double febMonthTotal = 0;
		double marMonthTotal = 0;
		double aprMonthTotal = 0;
		double mayMonthTotal = 0;
		double junMonthTotal = 0;
		double julMonthTotal = 0;
		double augMonthTotal = 0;
		double sepMonthTotal = 0;
		double octMonthTotal = 0;
		double novMonthTotal = 0;
		double decMonthTotal = 0;
		
		double janMonthOpeningBal = 0;
		double febMonthOpeningBal = 0;
		double marMonthOpeningBal = 0;
		double aprMonthOpeningBal = 0;
		double mayMonthOpeningBal = 0;
		double junMonthOpeningBal = 0;
		double julMonthOpeningBal = 0;
		double augMonthOpeningBal = 0;
		double sepMonthOpeningBal = 0;
		double octMonthOpeningBal = 0;
		double novMonthOpeningBal = 0;
		double decMonthOpeningBal = 0;
		
		double janMonthClosingBal = 0;
		double febMonthClosingBal = 0;
		double marMonthClosingBal = 0;
		double aprMonthClosingBal = 0;
		double mayMonthClosingBal = 0;
		double junMonthClosingBal = 0;
		double julMonthClosingBal = 0;
		double augMonthClosingBal = 0;
		double sepMonthClosingBal = 0;
		double octMonthClosingBal = 0;
		double novMonthClosingBal = 0;
		double decMonthClosingBal = 0;
		
		long janMonth = 0;
		long febMonth = 0;
		long marMonth = 0;
		long aprMonth = 0;
		long mayMonth = 0;
		long junMonth = 0;
		long julMonth = 0;
		long augMonth = 0;
		long sepMonth = 0;
		long octMonth = 0;
		long novMonth = 0;
		long decMonth = 0;
		
		double prevMarMonthClosingBal = 0;
		String prevAccHeader = "";
		String currAccHeader = "";
		ArrayList<Object> informationList = null;	

		ArrayList<ReportHelper> summaryReportsList = new ArrayList<ReportHelper>();
		ArrayList<String> summaryHeadersList = new ArrayList<String>();
		ReportHelper finalreporthelper = new ReportHelper();
		ArrayList<Object> summaryFinalList = new ArrayList<Object>();
		ReportHelper reporthelper = null;
		
		Map<String, Long> expValues = new HashMap<String, Long>();

		try {

			summaryHeadersList.add(commonFunctions.getLabelFromDB("SLNO", language));
			summaryHeadersList.add(commonFunctions.getLabelFromDB("Account_Header", language));
			summaryHeadersList.add("Apr - " + year.split("-")[0].trim());
			summaryHeadersList.add("May - " + year.split("-")[0].trim());
			summaryHeadersList.add("Jun - " + year.split("-")[0].trim());
			summaryHeadersList.add("Jul - " + year.split("-")[0].trim());
			summaryHeadersList.add("Aug - " + year.split("-")[0].trim());
			summaryHeadersList.add("Sep - " + year.split("-")[0].trim());
			summaryHeadersList.add("Oct - " + year.split("-")[0].trim());
			summaryHeadersList.add("Nov - " + year.split("-")[0].trim());
			summaryHeadersList.add("Dec - " + year.split("-")[0].trim());
			summaryHeadersList.add("Jan - " + year.split("-")[1].trim());
			summaryHeadersList.add("Feb - " + year.split("-")[1].trim());
			summaryHeadersList.add("Mar - " + year.split("-")[1].trim());
			
			expValues.put("aprIndex", 0L);
			expValues.put("mayIndex", 0L);
			expValues.put("juneIndex", 0L);
			expValues.put("julyIndex", 0L);
			expValues.put("augIndex", 0L);
			expValues.put("sepIndex", 0L);
			expValues.put("octIndex", 0L);
			expValues.put("novIndex", 0L);
			expValues.put("decIndex", 0L);
			expValues.put("janIndex", 0L);
			expValues.put("febIndex", 0L);
			expValues.put("marIndex", 0L);
			
			con = DBConnection.getConnectionToDB("LMS");
			
			//get opening balance for the current year from previous year
			pstmt = con.prepareStatement(ContainerCargoManagementStatements.GET_OPENING_BALANCE_FOR_CUURENT_YEAR);
			pstmt.setInt(1, systemId);
			pstmt.setString(2, custId);
			pstmt.setString(3, branchId);
			pstmt.setInt(4, 3);
			pstmt.setString(5, year.split("-")[0].trim());
			rs = pstmt.executeQuery();
			if(rs.next()) {
				prevMarMonthClosingBal = rs.getDouble("CLOSING_BAL");
			}
			pstmt.close();
			rs.close();

			if(transactionTypeId.equals("0")) {
				transactionTypeId = "1,2";
			}

			String query = ContainerCargoManagementStatements.GET_MONTHLY_CASHBOOK_REPORT;

			query = query.replaceFirst("#", String.valueOf(offset));
			query = query.replaceFirst("#", String.valueOf(offset));
			query = query.replaceFirst("#", String.valueOf(systemId));
			query = query.replaceFirst("#", custId);
			query = query.replaceFirst("#", branchId);
			query = query.replaceFirst("#", transactionTypeId);
			query = query.replaceFirst("#", String.valueOf(offset));
			query = query.replaceFirst("#", "3");
			query = query.replaceFirst("#", String.valueOf(offset));
			query = query.replaceFirst("#", year.split("-")[0].trim());
			query = query.replaceFirst("#", String.valueOf(offset));
			query = query.replaceFirst("#", "4");
			query = query.replaceFirst("#", String.valueOf(offset));
			query = query.replaceFirst("#", year.split("-")[1].trim());
			query = query.replaceFirst("#", String.valueOf(offset));
			query = query.replaceFirst("#", String.valueOf(offset));
			query = query.replaceFirst("#", String.valueOf(offset));
			query = query.replaceFirst("#", String.valueOf(offset));
			query = query.replaceFirst("#", String.valueOf(offset));
			query = query.replaceFirst("#", "3");
			query = query.replaceFirst("#", String.valueOf(offset));
			query = query.replaceFirst("#", year.split("-")[0].trim());
			query = query.replaceFirst("#", String.valueOf(offset));
			query = query.replaceFirst("#", "4");
			query = query.replaceFirst("#", String.valueOf(offset));
			query = query.replaceFirst("#", year.split("-")[1].trim());
			query = query.replaceFirst("#", branchId);
			query = query.replaceFirst("#", String.valueOf(systemId));
			query = query.replaceFirst("#", custId);
			query = query.replaceFirst("#", String.valueOf(offset));
			query = query.replaceFirst("#", String.valueOf(offset));
			
			if(transactionTypeId.equals("1")) {
				query = query.substring(0, query.indexOf("union"));
			}
			pstmt = con.prepareStatement(query);
			rs = pstmt.executeQuery();

			int count = 0;
			while(rs.next()) {
				
				if(rs.getRow() == 1) {
					prevAccHeader = rs.getString("ACC_HEADER");
					currAccHeader = rs.getString("ACC_HEADER");
					++count;
					jsonObj = new JSONObject();
					informationList = new ArrayList<Object>();
					reporthelper = new ReportHelper();	
					
					informationList.add(count);
					informationList.add(rs.getString("ACC_HEADER"));
					
					jsonObj.put("slnoIndex", count);
					jsonObj.put("accHeaderIndex", rs.getString("ACC_HEADER"));
					
				} else {
					prevAccHeader = currAccHeader;
					currAccHeader = rs.getString("ACC_HEADER");
				}

				if(!prevAccHeader.equals(currAccHeader)) {
					jsonArr.put(jsonObj);
					
					informationList.add(expValues.get("aprIndex"));
					informationList.add(expValues.get("mayIndex"));
					informationList.add(expValues.get("juneIndex"));
					informationList.add(expValues.get("julyIndex"));
					informationList.add(expValues.get("augIndex"));
					informationList.add(expValues.get("sepIndex"));
					informationList.add(expValues.get("octIndex"));
					informationList.add(expValues.get("novIndex"));
					informationList.add(expValues.get("decIndex"));
					informationList.add(expValues.get("janIndex"));
					informationList.add(expValues.get("febIndex"));
					informationList.add(expValues.get("marIndex"));

					reporthelper.setInformationList(informationList);
					summaryReportsList.add(reporthelper);
					
					expValues.put("aprIndex", 0L);
					expValues.put("mayIndex", 0L);
					expValues.put("juneIndex", 0L);
					expValues.put("julyIndex", 0L);
					expValues.put("augIndex", 0L);
					expValues.put("sepIndex", 0L);
					expValues.put("octIndex", 0L);
					expValues.put("novIndex", 0L);
					expValues.put("decIndex", 0L);
					expValues.put("janIndex", 0L);
					expValues.put("febIndex", 0L);
					expValues.put("marIndex", 0L);
					
					janMonth = 0;
					febMonth = 0;
					marMonth = 0;
					aprMonth = 0;
					mayMonth = 0;
					junMonth = 0;
					julMonth = 0;
					augMonth = 0;
					sepMonth = 0;
					octMonth = 0;
					novMonth = 0;
					decMonth = 0;
					
					++count;
					jsonObj = new JSONObject();
					informationList = new ArrayList<Object>();
					reporthelper = new ReportHelper();	
					
					informationList.add(count);
					informationList.add(rs.getString("ACC_HEADER"));
					
					jsonObj.put("slnoIndex", count);
					jsonObj.put("accHeaderIndex", rs.getString("ACC_HEADER"));
				}

				switch(rs.getInt("MonthNo")) {
				case 1: 
					if(prevAccHeader.equals(currAccHeader)) {
						janMonth = janMonth + rs.getLong("AMOUNT");
					} else {
						janMonth = rs.getLong("AMOUNT");
					}
					
					jsonObj.put("janIndex", Math.abs(janMonth));
					expValues.put("janIndex", janMonth);
					janMonthTotal = janMonthTotal + rs.getLong("AMOUNT");
					janMonthOpeningBal = decMonthTotal + decMonthOpeningBal;
					janMonthClosingBal = janMonthTotal + janMonthOpeningBal ;
					break;
				case 2:
					if(prevAccHeader.equals(currAccHeader)) {
						febMonth = febMonth + rs.getLong("AMOUNT");
					} else {
						febMonth = rs.getLong("AMOUNT");
					}
					
					jsonObj.put("febIndex", Math.abs(febMonth));
					expValues.put("febIndex", febMonth);
					febMonthTotal = febMonthTotal + rs.getLong("AMOUNT");
					febMonthOpeningBal = janMonthTotal + janMonthOpeningBal;
					febMonthClosingBal = febMonthTotal + febMonthOpeningBal ;
					break;
				case 3: 
					if(prevAccHeader.equals(currAccHeader)) {
						marMonth = marMonth + rs.getLong("AMOUNT");
					} else {
						marMonth = rs.getLong("AMOUNT");
					}
					
					jsonObj.put("marIndex", Math.abs(marMonth));
					expValues.put("marIndex", marMonth);
					marMonthTotal = marMonthTotal + rs.getLong("AMOUNT");
					marMonthOpeningBal = febMonthTotal + febMonthOpeningBal;
					marMonthClosingBal = marMonthTotal + marMonthOpeningBal ;
					break;
				case 4: 
					if(prevAccHeader.equals(currAccHeader)) {
						aprMonth = aprMonth + rs.getLong("AMOUNT");
					} else {
						aprMonth = rs.getLong("AMOUNT");
					}
					
					jsonObj.put("aprIndex", Math.abs(aprMonth));
					expValues.put("aprIndex", aprMonth);
					aprMonthTotal = aprMonthTotal + rs.getLong("AMOUNT");
					aprMonthOpeningBal = prevMarMonthClosingBal;
					aprMonthClosingBal = aprMonthTotal + aprMonthOpeningBal ;
					break;
				case 5: 
					if(prevAccHeader.equals(currAccHeader)) {
						mayMonth = mayMonth + rs.getLong("AMOUNT");
					} else {
						mayMonth = rs.getLong("AMOUNT");
					}
					
					jsonObj.put("mayIndex", Math.abs(mayMonth));
					expValues.put("mayIndex", mayMonth);
					mayMonthTotal = mayMonthTotal + rs.getLong("AMOUNT");
					mayMonthOpeningBal = aprMonthTotal + aprMonthOpeningBal;
					mayMonthClosingBal = mayMonthTotal + mayMonthOpeningBal ;
					break;
				case 6: 
					if(prevAccHeader.equals(currAccHeader)) {
						junMonth = junMonth + rs.getLong("AMOUNT");
					} else {
						junMonth = rs.getLong("AMOUNT");
					}
					jsonObj.put("juneIndex", Math.abs(junMonth));
					expValues.put("juneIndex", junMonth);
					junMonthTotal = junMonthTotal + rs.getLong("AMOUNT");
					junMonthOpeningBal = mayMonthTotal + mayMonthOpeningBal;
					junMonthClosingBal = junMonthTotal + junMonthOpeningBal ;
					break;
				case 7: 
					if(prevAccHeader.equals(currAccHeader)) {
						julMonth = julMonth + rs.getLong("AMOUNT");
					} else {
						julMonth = rs.getLong("AMOUNT");
					}
					jsonObj.put("julyIndex", Math.abs(julMonth));
					expValues.put("julyIndex", julMonth);
					julMonthTotal = julMonthTotal + rs.getLong("AMOUNT");
					julMonthOpeningBal = junMonthTotal + junMonthOpeningBal;
					julMonthClosingBal = julMonthTotal + julMonthOpeningBal ;
					break;
				case 8:
					if(prevAccHeader.equals(currAccHeader)) {
						augMonth = augMonth + rs.getLong("AMOUNT");
					} else {
						augMonth = rs.getLong("AMOUNT");
					}
					
					jsonObj.put("augIndex", Math.abs(augMonth));
					expValues.put("augIndex", augMonth);
					augMonthTotal = augMonthTotal + rs.getLong("AMOUNT");
					augMonthOpeningBal = julMonthTotal + julMonthOpeningBal;
					augMonthClosingBal = augMonthTotal + augMonthOpeningBal ;
					break;
				case 9: 
					if(prevAccHeader.equals(currAccHeader)) {
						sepMonth = sepMonth + rs.getLong("AMOUNT");
					} else {
						sepMonth = rs.getLong("AMOUNT");
					}
					
					jsonObj.put("sepIndex", Math.abs(sepMonth));
					expValues.put("sepIndex", sepMonth);
					sepMonthTotal = sepMonthTotal + rs.getLong("AMOUNT");
					sepMonthOpeningBal = augMonthTotal + augMonthOpeningBal;
					sepMonthClosingBal = sepMonthTotal + sepMonthOpeningBal ;
					break;
				case 10: 
					if(prevAccHeader.equals(currAccHeader)) {
						octMonth = octMonth + rs.getLong("AMOUNT");
					} else {
						octMonth = rs.getLong("AMOUNT");
					}
					
					jsonObj.put("octIndex", Math.abs(octMonth));
					expValues.put("octIndex", octMonth);
					octMonthTotal = octMonthTotal + rs.getLong("AMOUNT");
					octMonthOpeningBal = sepMonthTotal + sepMonthOpeningBal;
					octMonthClosingBal = octMonthTotal + octMonthOpeningBal ;
					break;
				case 11: 
					if(prevAccHeader.equals(currAccHeader)) {
						novMonth = novMonth + rs.getLong("AMOUNT");
					} else {
						novMonth = rs.getLong("AMOUNT");
					}
					
					jsonObj.put("novIndex", Math.abs(novMonth));
					expValues.put("novIndex", novMonth);
					novMonthTotal = novMonthTotal + rs.getLong("AMOUNT");
					novMonthOpeningBal = octMonthTotal + octMonthOpeningBal;
					novMonthClosingBal = novMonthTotal + novMonthOpeningBal ;
					break;
				case 12: 
					if(prevAccHeader.equals(currAccHeader)) {
						decMonth = decMonth + rs.getLong("AMOUNT");
					} else {
						decMonth = rs.getLong("AMOUNT");
					}
					
					jsonObj.put("decIndex", Math.abs(decMonth));
					expValues.put("decIndex", decMonth);
					decMonthTotal = decMonthTotal + rs.getLong("AMOUNT");
					decMonthOpeningBal = novMonthTotal + novMonthOpeningBal;
					decMonthClosingBal = decMonthTotal + decMonthOpeningBal ;
					break;
				default :
					break;
				}

			}
			
			//Monthly balance
			if(count > 0) {
				jsonArr.put(jsonObj);
				
				informationList.add(expValues.get("aprIndex"));
				informationList.add(expValues.get("mayIndex"));
				informationList.add(expValues.get("juneIndex"));
				informationList.add(expValues.get("julyIndex"));
				informationList.add(expValues.get("augIndex"));
				informationList.add(expValues.get("sepIndex"));
				informationList.add(expValues.get("octIndex"));
				informationList.add(expValues.get("novIndex"));
				informationList.add(expValues.get("decIndex"));
				informationList.add(expValues.get("janIndex"));
				informationList.add(expValues.get("febIndex"));
				informationList.add(expValues.get("marIndex"));

				reporthelper.setInformationList(informationList);
				summaryReportsList.add(reporthelper);
				
				jsonObj = new JSONObject();
				jsonObj.put("slnoIndex", ++count);
				jsonObj.put("accHeaderIndex", "<b>Monthly Total</b>");
				jsonObj.put("aprIndex", "<b>"+aprMonthTotal+"</b>");
				jsonObj.put("mayIndex", "<b>"+mayMonthTotal+"</b>");
				jsonObj.put("juneIndex", "<b>"+junMonthTotal+"</b>");
				jsonObj.put("julyIndex", "<b>"+julMonthTotal+"</b>");
				jsonObj.put("augIndex", "<b>"+augMonthTotal+"</b>");
				jsonObj.put("sepIndex", "<b>"+sepMonthTotal+"</b>");
				jsonObj.put("octIndex", "<b>"+octMonthTotal+"</b>");
				jsonObj.put("novIndex", "<b>"+novMonthTotal+"</b>");
				jsonObj.put("decIndex", "<b>"+decMonthTotal+"</b>");
				jsonObj.put("janIndex", "<b>"+janMonthTotal+"</b>");
				jsonObj.put("febIndex", "<b>"+febMonthTotal+"</b>");
				jsonObj.put("marIndex", "<b>"+marMonthTotal+"</b>");
				jsonArr.put(jsonObj);

				informationList = new ArrayList<Object>();
				reporthelper = new ReportHelper();	
				informationList.add(count);
				informationList.add("Monthly Total");
				informationList.add(aprMonthTotal);
				informationList.add(mayMonthTotal);
				informationList.add(junMonthTotal);
				informationList.add(julMonthTotal);
				informationList.add(augMonthTotal);
				informationList.add(sepMonthTotal);
				informationList.add(octMonthTotal);
				informationList.add(novMonthTotal);
				informationList.add(decMonthTotal);
				informationList.add(janMonthTotal);
				informationList.add(febMonthTotal);
				informationList.add(marMonthTotal);
				
				reporthelper.setInformationList(informationList);
				summaryReportsList.add(reporthelper);

				//Opening Balance
				jsonObj = new JSONObject();
				jsonObj.put("slnoIndex", ++count);
				
				jsonObj.put("accHeaderIndex", "<b>Opening Balance</b>");
				jsonObj.put("aprIndex", "<b>"+aprMonthOpeningBal+"</b>");
				jsonObj.put("mayIndex", "<b>"+mayMonthOpeningBal+"</b>");
				jsonObj.put("juneIndex", "<b>"+junMonthOpeningBal+"</b>");
				jsonObj.put("julyIndex", "<b>"+julMonthOpeningBal+"</b>");
				jsonObj.put("augIndex", "<b>"+augMonthOpeningBal+"</b>");
				jsonObj.put("sepIndex", "<b>"+sepMonthOpeningBal+"</b>");
				jsonObj.put("octIndex", "<b>"+octMonthOpeningBal+"</b>");
				jsonObj.put("novIndex", "<b>"+novMonthOpeningBal+"</b>");
				jsonObj.put("decIndex", "<b>"+decMonthOpeningBal+"</b>");
				jsonObj.put("janIndex", "<b>"+janMonthOpeningBal+"</b>");
				jsonObj.put("febIndex", "<b>"+febMonthOpeningBal+"</b>");
				jsonObj.put("marIndex", "<b>"+marMonthOpeningBal+"</b>");
				
				jsonArr.put(jsonObj);

				informationList = new ArrayList<Object>();
				reporthelper = new ReportHelper();	
				informationList.add(count);
				informationList.add("Opening Balance");
				informationList.add(aprMonthOpeningBal);
				informationList.add(mayMonthOpeningBal);
				informationList.add(junMonthOpeningBal);
				informationList.add(julMonthOpeningBal);
				informationList.add(augMonthOpeningBal);
				informationList.add(sepMonthOpeningBal);
				informationList.add(octMonthOpeningBal);
				informationList.add(novMonthOpeningBal);
				informationList.add(decMonthOpeningBal);
				informationList.add(janMonthOpeningBal);
				informationList.add(febMonthOpeningBal);
				informationList.add(marMonthOpeningBal);
				
				reporthelper.setInformationList(informationList);
				summaryReportsList.add(reporthelper);
				
				//Closing Balance
				jsonObj = new JSONObject();
				jsonObj.put("slnoIndex", ++count);
				jsonObj.put("accHeaderIndex", "<b>Closing Balance</b>");
				jsonObj.put("aprIndex", "<b>"+aprMonthClosingBal+"</b>");
				jsonObj.put("mayIndex", "<b>"+mayMonthClosingBal+"</b>");
				jsonObj.put("juneIndex", "<b>"+junMonthClosingBal+"</b>");
				jsonObj.put("julyIndex", "<b>"+julMonthClosingBal+"</b>");
				jsonObj.put("augIndex", "<b>"+augMonthClosingBal+"</b>");
				jsonObj.put("sepIndex", "<b>"+sepMonthClosingBal+"</b>");
				jsonObj.put("octIndex", "<b>"+octMonthClosingBal+"</b>");
				jsonObj.put("novIndex", "<b>"+novMonthClosingBal+"</b>");
				jsonObj.put("decIndex", "<b>"+decMonthClosingBal+"</b>");
				jsonObj.put("janIndex", "<b>"+janMonthClosingBal+"</b>");
				jsonObj.put("febIndex", "<b>"+febMonthClosingBal+"</b>");
				jsonObj.put("marIndex", "<b>"+marMonthClosingBal+"</b>");

				jsonArr.put(jsonObj);

				informationList = new ArrayList<Object>();
				reporthelper = new ReportHelper();	
				informationList.add(count);
				informationList.add("Closing Balance");
				
				informationList.add(aprMonthClosingBal);
				informationList.add(mayMonthClosingBal);
				informationList.add(junMonthClosingBal);
				informationList.add(julMonthClosingBal);
				informationList.add(augMonthClosingBal);
				informationList.add(sepMonthClosingBal);
				informationList.add(octMonthClosingBal);
				informationList.add(novMonthClosingBal);
				informationList.add(decMonthClosingBal);
				informationList.add(janMonthClosingBal);
				informationList.add(febMonthClosingBal);
				informationList.add(marMonthClosingBal);
				
				reporthelper.setInformationList(informationList);
				summaryReportsList.add(reporthelper);
			}
			
			summaryFinalList.add(jsonArr);
			finalreporthelper.setReportsList(summaryReportsList);
			finalreporthelper.setHeadersList(summaryHeadersList);
			summaryFinalList.add(finalreporthelper);

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}

		return summaryFinalList;
	}
	public JSONArray getBranchCurrentBalance(int systemId, String custId, String branchId) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		JSONArray jsArr = new JSONArray();
		JSONObject jsObj = new JSONObject();
		try {
			con = DBConnection.getConnectionToDB("LMS");
			pstmt = con.prepareStatement(ContainerCargoManagementStatements.GET_BRANCH_CURRENT_BALANCE);
			pstmt.setInt(1, systemId);
			pstmt.setString(2, custId);
			pstmt.setString(3, branchId);
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				jsObj.put("currentBalance", rs.getDouble("CurrentBalance") + " " + rs.getString("Currency"));
				jsObj.put("ledgerBalance", rs.getDouble("LedgerBalance") + " " + rs.getString("Currency"));
				jsArr.put(jsObj);
			} else {
				jsObj.put("currentBalance", 0 + " " + rs.getString("Currency"));
				jsObj.put("ledgerBalance", 0 + " " + rs.getString("Currency"));
				jsArr.put(jsObj);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jsArr;
	}
	
	public ArrayList<Object> getCashBookApproveRejectDetails(int systemId, String custId, int userId, String status, int offset, String startDate, String endDate, String language, String branchId) {
		Connection con = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        JSONArray jsArr = new JSONArray();
        JSONObject obj = null;
        int count = 0;
        
        ArrayList<ReportHelper> summaryReportsList = new ArrayList<ReportHelper>();
		ArrayList<String> summaryHeadersList = new ArrayList<String>();
		ReportHelper finalreporthelper = new ReportHelper();
		ArrayList<Object> summaryFinalList = new ArrayList<Object>();
		
        try {
        	
			summaryHeadersList.add(commonFunctions.getLabelFromDB("SLNO", language));
			summaryHeadersList.add(commonFunctions.getLabelFromDB("UID", language));
			summaryHeadersList.add(commonFunctions.getLabelFromDB("Branch_Code", language));
			summaryHeadersList.add(commonFunctions.getLabelFromDB("BranchID", language));
			summaryHeadersList.add(commonFunctions.getLabelFromDB("Transaction_Type", language));
			summaryHeadersList.add(commonFunctions.getLabelFromDB("Transaction_Date", language));
			summaryHeadersList.add(commonFunctions.getLabelFromDB("Account_Header", language));
			summaryHeadersList.add(commonFunctions.getLabelFromDB("Vehicle_No", language));
			summaryHeadersList.add(commonFunctions.getLabelFromDB("Driver", language));
			summaryHeadersList.add(commonFunctions.getLabelFromDB("Cleaner", language));
			summaryHeadersList.add(commonFunctions.getLabelFromDB("Amount", language));
			summaryHeadersList.add(commonFunctions.getLabelFromDB("Approve_Reject_Amount", language));
			summaryHeadersList.add(commonFunctions.getLabelFromDB("Description", language));
			summaryHeadersList.add(commonFunctions.getLabelFromDB("Bill_No", language));
			
            con = DBConnection.getConnectionToDB("LMS");
            pstmt = con.prepareStatement(ContainerCargoManagementStatements.GET_CASH_BOOK_APPROVE_REJECT_DETAILS);
            pstmt.setInt(1, offset);
            pstmt.setInt(2, systemId);
            pstmt.setString(3, custId);
            pstmt.setString(4, status);
            pstmt.setInt(5, offset);
            pstmt.setString(6, startDate);
            pstmt.setInt(7, offset);
            pstmt.setString(8, endDate);
            pstmt.setString(9, branchId);
            rs = pstmt.executeQuery();
            
            while(rs.next()) {
            	
            	ArrayList<Object> informationList = new ArrayList<Object>();
				ReportHelper reporthelper = new ReportHelper();	
				
				count++;
				
            	obj = new JSONObject();
            	obj.put("slnoIndex", count);
            	informationList.add(count);
            	
            	obj.put("idIndex", rs.getInt("ID"));
            	informationList.add(rs.getInt("ID"));
            	
            	obj.put("branchCodeIndex", rs.getString("BranchCode"));
            	informationList.add(rs.getString("BranchCode"));
            	
            	obj.put("branchIdIndex", rs.getString("BRANCH_ID"));
            	informationList.add(rs.getString("BRANCH_ID"));
            	
            	obj.put("transactionTypeIndex", rs.getString("TRANSAC_TYPE"));
            	informationList.add(rs.getString("TRANSAC_TYPE"));
            	
            	obj.put("transactionDateIndex", yyyymmdd.format(yyyymmdd.parse(rs.getString("TRANSAC_DATE"))));
            	informationList.add(yyyymmdd.format(yyyymmdd.parse(rs.getString("TRANSAC_DATE"))));
            	
            	obj.put("accountHeaderIndex", rs.getString("ACC_HEADER"));
            	informationList.add(rs.getString("ACC_HEADER"));
            	
            	obj.put("vehicleIndex", rs.getString("ASSET_NO"));
            	informationList.add(rs.getString("ASSET_NO"));
            	
            	obj.put("driverIndex", rs.getString("DRIVER"));
            	informationList.add(rs.getString("DRIVER"));
            	
            	obj.put("cleanerIndex", rs.getString("CLEANER_NAME"));
            	informationList.add(rs.getString("CLEANER_NAME"));
            	
            	obj.put("amountIndex", rs.getDouble("AMOUNT"));
            	informationList.add(rs.getDouble("AMOUNT"));
            	
            	obj.put("appAmountIndex", rs.getDouble("AppRejAmount"));
            	informationList.add(rs.getDouble("AppRejAmount"));
            	
            	obj.put("descriptionIndex", rs.getString("DESCRIPTION"));
            	informationList.add(rs.getString("DESCRIPTION"));
            	
            	obj.put("billNoIndex", rs.getString("BILL_NO"));
            	informationList.add(rs.getString("BILL_NO"));
            	
            	jsArr.put(obj);
            	
            	reporthelper.setInformationList(informationList);
            	summaryReportsList.add(reporthelper);
            }
            pstmt.close();
            rs.close();
            
            summaryFinalList.add(jsArr);
			finalreporthelper.setReportsList(summaryReportsList);
			finalreporthelper.setHeadersList(summaryHeadersList);
			summaryFinalList.add(finalreporthelper);
            
        } catch (Exception e) {
        	e.printStackTrace();
        } finally {
            DBConnection.releaseConnectionToDB(con, pstmt, rs);
        }
		return summaryFinalList;
	}
	
	public String approveCashBook(int systemId, int customerId, String uniqueId, String transacType, double amount, double appAmount, int userId, int offset, String branchId, String transacDate) {
		String msg = "";
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		double remainingAmount = amount - appAmount;
		
		try {
			con = DBConnection.getConnectionToDB("LMS");
			con.setAutoCommit(false);
			if(transacType.equals("Debit")) {
				//update amount with approved amount
				pstmt = con.prepareStatement(ContainerCargoManagementStatements.APPROVE_CASH_BOOK);
				pstmt.setDouble(1, appAmount);
				pstmt.setDouble(2, remainingAmount);
				pstmt.setInt(3, userId);
				pstmt.setString(4, "APPROVED");
				pstmt.setString(5, uniqueId);
				pstmt.executeUpdate();

				insertIntoCashBookMonthlyDetails(con, systemId, customerId, transacDate, "1", appAmount, branchId, offset, "DEBIT_CB", remainingAmount, transacType);
			} else {
				//Credit Entry Approval
				String transType = "0";
				
				if(transacType.equals("Debit")) {
					transType = "2";
				} else {
					transType = "1";
				}

				//update amount with approved amount
				pstmt = con.prepareStatement(ContainerCargoManagementStatements.APPROVE_CASH_BOOK);
				pstmt.setDouble(1, appAmount);
				pstmt.setDouble(2, remainingAmount);
				pstmt.setInt(3, userId);
				pstmt.setString(4, "APPROVED");
				pstmt.setString(5, uniqueId);
				pstmt.executeUpdate();

				if(remainingAmount > 0) {
					transType = "2";
				} else if(remainingAmount < 0) {
					transType = "1";
				}
				
				insertIntoCashBookMonthlyDetails(con, systemId, customerId, transacDate, transType, appAmount, branchId, offset, "CREDIT_CB", Math.abs(remainingAmount), transacType);
			}
			con.commit();
		} catch (Exception e) {
			rollBack(con);
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		
		return msg;
	}
	public String rejectCashBook(int systemId, int customerId, String uniqueId, String transacType, double amount, double appAmount, int userId, int offset, String branchId, String transacDate) {
		String msg = "";
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String transType = "";
		
		try {
			con = DBConnection.getConnectionToDB("LMS");
			con.setAutoCommit(false);
			
			if(transacType.equals("Debit")) {
				transType = "1";//credit transaction type
			} else {
				transType = "2";//debit transaction type
			}

			//status will be Approved
			pstmt = con.prepareStatement(ContainerCargoManagementStatements.APPROVE_CASH_BOOK);
			pstmt.setDouble(1, appAmount);
			pstmt.setDouble(2, amount);
			pstmt.setInt(3, userId);
			pstmt.setString(4, "REJECTED");
			pstmt.setString(5, uniqueId);
			pstmt.executeUpdate();
			pstmt.close();

			insertIntoCashBookMonthlyDetails(con, systemId, customerId, transacDate, transType, appAmount, branchId, offset, "REJECT_CB", Math.abs(amount-appAmount), transacType);
			con.commit();
		} catch (Exception e) {
			rollBack(con);
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		
		return msg;
	}
	
	public void rollBack(Connection con) {
		try {
			if(con != null){
				con.rollback();
				con.close();
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	public JSONArray getMasterList(int systemId, int custId) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		JSONArray jsArr = new JSONArray();
		JSONObject jsObj = null;
		
		try {
			con = DBConnection.getConnectionToDB("LMS");
			pstmt = con.prepareStatement(ContainerCargoManagementStatements.GET_LOOK_UP_LIST);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, custId);
			pstmt.setString(3, "Master");
			rs = pstmt.executeQuery();
			while(rs.next()) {
				jsObj = new JSONObject();
				jsObj.put("masterId", rs.getInt("ID"));
				jsObj.put("masterName", rs.getString("DATA"));
				
				jsArr.put(jsObj);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
            DBConnection.releaseConnectionToDB(con, pstmt, rs);
        }
		return jsArr;
	}
	public JSONArray getPendingFuelRate(int systemId, int custId) {
		JSONArray jsArr = new JSONArray();
		JSONObject jsObj = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		try {
			con = DBConnection.getConnectionToDB("LMS");
			pstmt = con.prepareStatement(ContainerCargoManagementStatements.GET_PENDING_FUEL_RATE);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, custId);
			pstmt.setString(3, "PENDING");
			rs = pstmt.executeQuery();
			
			while(rs.next()){
				jsObj = new JSONObject();
				jsObj.put("slnoIndex", rs.getRow());
		        jsObj.put("IdIndex", rs.getInt("FuelTypeId"));
		        jsObj.put("fuelCmpnyNameIndex", rs.getString("FuelCompanyName"));
				jsObj.put("fuelTypeIndex", rs.getString("FuelType"));
				jsObj.put("statusIndex", rs.getString("Status"));
				
				jsArr.put(jsObj);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jsArr;
	}
	
	public JSONArray getPendingFuelRateBasedOnId(int systemId, int custId, String id, int offset) {

		JSONArray jsArr = new JSONArray();
		JSONObject jsObj = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		try {
			con = DBConnection.getConnectionToDB("LMS");
			pstmt = con.prepareStatement(ContainerCargoManagementStatements.GET_PENDING_FUEL_RATE_BASED_ON_ID);
			pstmt.setInt(1, offset);
			pstmt.setInt(2, offset);
			pstmt.setInt(3, systemId);
			pstmt.setInt(4, custId);
			pstmt.setString(5, id);
			pstmt.setInt(6, offset);
			pstmt.setInt(7, offset);
			pstmt.setInt(8, systemId);
			pstmt.setInt(9, custId);
			pstmt.setString(10, id);
			pstmt.setInt(11, systemId);
			pstmt.setInt(12, custId);
			pstmt.setString(13, id);
			rs = pstmt.executeQuery();
			
			while(rs.next()){
				jsObj = new JSONObject();
				jsObj.put("rowDetailsIndex", rs.getString("FT"));
				jsObj.put("vendorNameIndex", rs.getString("VendorName"));
				jsObj.put("locationIndex", rs.getString("Location"));
				jsObj.put("fuelTypeIndex", rs.getString("FuelType"));
				jsObj.put("rateIndex", rs.getString("FuelPricePerLitre"));
				jsObj.put("cityIndex", rs.getString("City"));
				jsObj.put("stateIndex", rs.getString("State"));
				jsObj.put("effectiveFromIndex", rs.getString("EffectiveFrom"));
				jsObj.put("effectiveToIndex", rs.getString("EffectiveTo"));
				
				jsArr.put(jsObj);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jsArr;
	
	}
	
	public String approveFuelRateMaster(int systemId, int custId, String id) {
		String msg = "Error";
		Connection con = null;
		PreparedStatement pstmt = null;

		try {
			con = DBConnection.getConnectionToDB("LMS");
			pstmt = con.prepareStatement(ContainerCargoManagementStatements.APPROVE_FUEL_RATE);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, custId);
			pstmt.setString(3, id);
			pstmt.executeUpdate();
			msg = "Approved successfully";
		} catch (Exception e) {
			msg = "Error";
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, null);
		}
		return msg;
	}
	
	public String rejectFuelRateMaster(int systemId, int custId, String id, int userId) {
		String msg = "Error";
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		try {
			con = DBConnection.getConnectionToDB("LMS");
			con.setAutoCommit(false);
			pstmt = con.prepareStatement(ContainerCargoManagementStatements.GET_TOP_1_FUEL_RATE_BASED_ON_ID);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, custId);
			pstmt.setString(3, id);
			rs = pstmt.executeQuery();
			if(rs.next()) {
			//if it going to be rejected then update current data with previous data
			
				pstmt = con.prepareStatement(ContainerCargoManagementStatements.UPDATE_FUEL_RATE_MASTER);
				pstmt.setString(1, rs.getString("FuelTypeName"));
				pstmt.setDouble(2, rs.getDouble("FuelPricePerLitre"));
				pstmt.setString(3, rs.getString("FuelType"));
				pstmt.setString(4, rs.getString("VendorId"));
				pstmt.setString(5, rs.getString("EffectiveFrom"));
				pstmt.setString(6, rs.getString("EffectiveTo"));
				pstmt.setInt(7, userId);
				pstmt.setString(8, rs.getString("State"));
				pstmt.setString(9, rs.getString("City"));
				pstmt.setString(10, rs.getString("Location"));
				pstmt.setString(11, rs.getString("STATUS"));
				pstmt.setString(12, "APPROVED");
				pstmt.setInt(13, systemId);
				pstmt.setInt(14, custId);
				pstmt.setString(15, id);
				pstmt.executeUpdate();
				
			} else {
				//if records are new then no data will be there in history, in that case while rejecting delete the records
				
				pstmt = con.prepareStatement(ContainerCargoManagementStatements.DELETE_FUEL_RATE_MASTER);
				pstmt.setInt(1, systemId);
				pstmt.setInt(2, custId);
				pstmt.setString(3, id);
				pstmt.execute();
			}
			
			msg = "Rejected successfully";
			con.commit();
		} catch (Exception e) {
			msg = "Error";
			rollBack(con);
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return msg;
	}
	public JSONArray getPendingBillingAndUnloadingData(int systemId, int custId, int type) {

		JSONArray jsArr = new JSONArray();
		JSONObject jsObj = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		try {
			con = DBConnection.getConnectionToDB("LMS");
			pstmt = con.prepareStatement(ContainerCargoManagementStatements.GET_PENDING_BILLING_AND_UNLOADING_DATA);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, custId);
			pstmt.setInt(3, type);
			pstmt.setString(4, "PENDING");
			rs = pstmt.executeQuery();
			
			while(rs.next()){
				jsObj = new JSONObject();
				jsObj.put("slnoIndex", rs.getRow());
				jsObj.put("IdIndex", rs.getInt("UniqueId"));;
				jsObj.put("principalNameIndex", rs.getString("PrincipalName"));
				jsObj.put("consigneeNameIndex", rs.getString("ConsigneeName"));
				
				jsArr.put(jsObj);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jsArr;
	}
	
	public JSONArray getPendingBillingAndUnloadingDetails(int systemId, int custId, String id, int offset, int type) {

		JSONArray jsArr = new JSONArray();
		JSONObject jsObj = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		try {
			con = DBConnection.getConnectionToDB("LMS");
			pstmt = con.prepareStatement(ContainerCargoManagementStatements.GET_PENDING_BILLING_AND_UNLOADING_DETAILS_BASED_ON_ID);
			pstmt.setInt(1, offset);
			pstmt.setInt(2, offset);
			pstmt.setInt(3, systemId);
			pstmt.setInt(4, custId);
			pstmt.setInt(5, type);
			pstmt.setString(6, id);
			pstmt.setInt(7, offset);
			pstmt.setInt(8, offset);
			pstmt.setInt(9, systemId);
			pstmt.setInt(10, custId);
			pstmt.setInt(11, type);
			pstmt.setString(12, id);
			pstmt.setInt(13, systemId);
			pstmt.setInt(14, custId);
			pstmt.setInt(15, type);
			pstmt.setString(16, id);
			rs = pstmt.executeQuery();
			rs = pstmt.executeQuery();
			
			while(rs.next()){
				jsObj = new JSONObject();
				jsObj.put("rowDetailsIndex", rs.getString("FT"));
				jsObj.put("fixedRateIndex", rs.getString("FixedRate"));
				jsObj.put("ratePerDrumIndex", rs.getString("RatePerDrum"));
				jsObj.put("effectiveFromIndex", rs.getString("EffecFrom"));
				jsObj.put("effectiveToIndex", rs.getString("EffecTo"));
				
				jsArr.put(jsObj);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jsArr;
	}
	public String approveBillingAndUnloadingMaster(int systemId, int custId, String id, int type) {
		String msg = "Error";
		Connection con = null;
		PreparedStatement pstmt = null;

		try {
			con = DBConnection.getConnectionToDB("LMS");
			pstmt = con.prepareStatement(ContainerCargoManagementStatements.APPROVE_BILLING_AND_UPLOADING_MASTER);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, custId);
			pstmt.setString(3, id);
			pstmt.setInt(4, type);
			pstmt.executeUpdate();
			msg = "Approved successfully";
		} catch (Exception e) {
			msg = "Error";
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, null);
		}
		return msg;
	}
	public String rejectBillingAndUnloadingMaster(int systemId, int custId, String id, int userId) {
		String msg = "Error";
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		try {
			con = DBConnection.getConnectionToDB("LMS");
			con.setAutoCommit(false);
			pstmt = con.prepareStatement(ContainerCargoManagementStatements.GET_TOP_1_BILLING_AND_UNLOADING_MASTER_BASED_ON_ID);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, custId);
			pstmt.setString(3, id);
			rs = pstmt.executeQuery();
			if(rs.next()) {
			//if it going to be rejected then update current data with previous data
				pstmt = con.prepareStatement(ContainerCargoManagementStatements.UPDATE_BILLING_AND_UNLOADING_DETAILS);
				pstmt.setDouble(1, rs.getDouble("Rate"));
				pstmt.setDouble(2, rs.getDouble("RATE_PERMT"));
				pstmt.setString(3, rs.getString("EffectiveFrom"));
				pstmt.setString(4, rs.getString("EffectiveTo"));
				pstmt.setString(5, "APPROVED");
				pstmt.setInt(6, userId);
				pstmt.setInt(7, systemId);
				pstmt.setInt(8, custId);
				pstmt.setString(9, id);
				pstmt.executeUpdate();
				
			} else {
				//if records are new then no data will be there in history, in that case while rejecting delete the records
				
				pstmt = con.prepareStatement(ContainerCargoManagementStatements.DELETE_BILLING_AND_UNLOADING_DETAILS);
				pstmt.setInt(1, systemId);
				pstmt.setInt(2, custId);
				pstmt.setString(3, id);
				pstmt.execute();
			}
			
			msg = "Rejected successfully";
			con.commit();
		} catch (Exception e) {
			msg = "Error";
			rollBack(con);
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return msg;
	}
	public JSONArray getPendingHSCMaster(int systemId, int custId) {
		JSONArray jsArr = new JSONArray();
		JSONObject jsObj = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		try {
			con = DBConnection.getConnectionToDB("LMS");
			pstmt = con.prepareStatement(ContainerCargoManagementStatements.GET_PENDING_HSC_MASTER_DETAILS);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, custId);
			pstmt.setString(3, "PENDING");
			rs = pstmt.executeQuery();
			
			while(rs.next()){
				jsObj = new JSONObject();
				jsObj.put("slnoIndex", rs.getRow());
		        jsObj.put("IdIndex", rs.getInt("Id"));
		        jsObj.put("companyNameIndex", rs.getString("CompanyName"));
				jsObj.put("customerTypeIndex", rs.getString("CompanyType"));
				
				jsArr.put(jsObj);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jsArr;
	}
	public JSONArray getPendingHSCMasterBasedOnId(int systemId, int custId, String id) {

		JSONArray jsArr = new JSONArray();
		JSONObject jsObj = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		try {
			con = DBConnection.getConnectionToDB("LMS");
			pstmt = con.prepareStatement(ContainerCargoManagementStatements.GET_PENDING_HSC_MASTER_BASED_ON_ID);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, custId);
			pstmt.setString(3, id);
			pstmt.setInt(4, systemId);
			pstmt.setInt(5, custId);
			pstmt.setString(6, id);
			
			rs = pstmt.executeQuery();

			while(rs.next()){
				jsObj = new JSONObject();
				jsObj.put("rowDetailsIndex", rs.getString("FT"));
				jsObj.put("licenseIndex", rs.getString("LICENCE"));
				jsObj.put("insuranceIndex", rs.getString("INSURANCE"));
				jsObj.put("pollutionIndex", rs.getString("POLLUTION"));
				jsObj.put("shoesIndex", rs.getString("SHOES"));
				jsObj.put("fluroscentJacketIndex", rs.getString("F_JACKET"));
				jsObj.put("reverseHornIndex", rs.getString("REVERSE_HORN"));
				jsObj.put("noSmokingAndFireIndex", rs.getString("NO_SMOKING_NO_FIRE"));
				jsObj.put("fitnessIndex", rs.getString("FITNESS"));
				
				jsArr.put(jsObj);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jsArr;
	
	}
	public String approveHSCMaster(int systemId, int custId, String id) {
		String msg = "Error";
		Connection con = null;
		PreparedStatement pstmt = null;

		try {
			con = DBConnection.getConnectionToDB("LMS");
			pstmt = con.prepareStatement(ContainerCargoManagementStatements.APPROVE_HSC_MASTER);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, custId);
			pstmt.setString(3, id);
			pstmt.executeUpdate();
			msg = "Approved successfully";
		} catch (Exception e) {
			msg = "Error";
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, null);
		}
		return msg;
	}
	public String rejectHSCMaster(int systemId, int custId, String id, int userId) {
		String msg = "Error";
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		try {
			con = DBConnection.getConnectionToDB("LMS");
			con.setAutoCommit(false);
			pstmt = con.prepareStatement(ContainerCargoManagementStatements.GET_HSC_MASTER_BASED_ON_ID);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, custId);
			pstmt.setString(3, id);
			rs = pstmt.executeQuery();
			if(rs.next()) {
			//if it going to be rejected then update current data with previous data
			
				pstmt = con.prepareStatement(ContainerCargoManagementStatements.UPDATE_HSC_MASTER);
				pstmt.setString(1, rs.getString("COMPANY_ID"));
				pstmt.setString(2, rs.getString("COMPANY_TYPE_ID"));
				pstmt.setInt(3, rs.getInt("LICENCE"));
				pstmt.setInt(4, rs.getInt("INSURANCE"));// 
				pstmt.setInt(5, rs.getInt("POLLUTION"));
				pstmt.setInt(6, rs.getInt("SHOES"));
				pstmt.setInt(7, rs.getInt("F_JACKET"));
				pstmt.setString(8, "APPROVED");
				pstmt.setInt(9, userId);
				pstmt.setInt(10, systemId);
				pstmt.setInt(11, custId);
				pstmt.setString(12, id);
				pstmt.executeUpdate();
				
			} else {
				//if records are new then no data will be there in history, in that case while rejecting delete the records
				
				pstmt = con.prepareStatement(ContainerCargoManagementStatements.DELETE_HSC_MASTER);
				pstmt.setInt(1, systemId);
				pstmt.setInt(2, custId);
				pstmt.setString(3, id);
				pstmt.execute();
			}
			
			msg = "Rejected successfully";
			con.commit();
		} catch (Exception e) {
			msg = "Error";
			rollBack(con);
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return msg;
	}
	public JSONArray getPendingLeaveMaster(int systemId, int custId) {
		JSONArray jsArr = new JSONArray();
		JSONObject jsObj = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(ContainerCargoManagementStatements.GET_PENDING_LEAVE_MASTER_DETAILS);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, custId);
			pstmt.setString(3, "PENDING");
			rs = pstmt.executeQuery();
			
			while(rs.next()){
				jsObj = new JSONObject();
				jsObj.put("slnoIndex", rs.getRow());
		        jsObj.put("IdIndex", rs.getInt("Id"));
		        jsObj.put("holidayNameIndex", rs.getString("HolidayName"));
				
				jsArr.put(jsObj);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jsArr;
	}
	public JSONArray getPendingLeaveMasterBasedOnId(int systemId, int custId, String id, int offset) {

		JSONArray jsArr = new JSONArray();
		JSONObject jsObj = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(ContainerCargoManagementStatements.GET_PENDING_LEAVE_MASTER_BASED_ON_ID);
			pstmt.setInt(1, offset);
			pstmt.setInt(2, systemId);
			pstmt.setInt(3, custId);
			pstmt.setString(4, id);
			pstmt.setInt(5, offset);
			pstmt.setInt(6, systemId);
			pstmt.setInt(7, custId);
			pstmt.setString(8, id);
			rs = pstmt.executeQuery();

			while(rs.next()){
				jsObj = new JSONObject();
				jsObj.put("rowDetailsIndex", rs.getString("FT"));
				jsObj.put("holidayDateIndex", rs.getString("HolidayDate"));
				
				jsArr.put(jsObj);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jsArr;
	
	}
	public String approveLeaveMaster(int systemId, int custId, String id) {
		String msg = "Error";
		Connection con = null;
		PreparedStatement pstmt = null;

		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(ContainerCargoManagementStatements.APPROVE_LEAVE_MASTER);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, custId);
			pstmt.setString(3, id);
			pstmt.executeUpdate();
			msg = "Approved successfully";
		} catch (Exception e) {
			msg = "Error";
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, null);
		}
		return msg;
	}
	public String rejectLeaveMaster(int systemId, int custId, String id, int userId) {
		String msg = "Error";
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		try {
			con = DBConnection.getConnectionToDB("AMS");
			con.setAutoCommit(false);
			pstmt = con.prepareStatement(ContainerCargoManagementStatements.GET_LEAVE_MASTER_BASED_ON_ID);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, custId);
			pstmt.setString(3, id);
			rs = pstmt.executeQuery();
			if(rs.next()) {
			//if it going to be rejected then update current data with previous data
			
				pstmt = con.prepareStatement(ContainerCargoManagementStatements.UPDATE_LEAVE_MASTER);
				pstmt.setString(1, rs.getString("DATE"));
				pstmt.setString(2, rs.getString("REASON"));
				pstmt.setString(3, "APPROVED");
				pstmt.setInt(4, userId);
				pstmt.setInt(5, systemId);
				pstmt.setInt(6, custId);
				pstmt.setString(7, id);
				pstmt.executeUpdate();
				
			} else {
				//if records are new then no data will be there in history, in that case while rejecting delete the records
				
				pstmt = con.prepareStatement(ContainerCargoManagementStatements.DELETE_LEAVE_MASTER);
				pstmt.setInt(1, systemId);
				pstmt.setInt(2, custId);
				pstmt.setString(3, id);
				pstmt.execute();
			}
			
			msg = "Rejected successfully";
			con.commit();
		} catch (Exception e) {
			msg = "Error";
			rollBack(con);
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return msg;
	}
	public JSONArray getPendingConductorMaster(int systemId, int custId) {
		JSONArray jsArr = new JSONArray();
		JSONObject jsObj = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(ContainerCargoManagementStatements.GET_PENDING_CONDUCTOR_MASTER_DETAILS);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, custId);
			pstmt.setString(3, "PENDING");
			rs = pstmt.executeQuery();
			
			while(rs.next()){
				jsObj = new JSONObject();
				jsObj.put("slnoIndex", rs.getRow());
		        jsObj.put("IdIndex", rs.getInt("Id"));
		        jsObj.put("conductorNameIndex", rs.getString("ConductorName"));
		        jsObj.put("conductorAddressIndex", rs.getString("Address"));
		        jsObj.put("statusIndex", rs.getString("Status"));
				
				jsArr.put(jsObj);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jsArr;
	}
	public JSONArray getPendingConductorMasterBasedOnId(int systemId, int custId, String id, int offset) {

		JSONArray jsArr = new JSONArray();
		JSONObject jsObj = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(ContainerCargoManagementStatements.GET_PENDING_CONDUCTOR_MASTER_BASED_ON_ID);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, custId);
			pstmt.setString(3, id);
			pstmt.setInt(4, systemId);
			pstmt.setInt(5, custId);
			pstmt.setString(6, id);
			rs = pstmt.executeQuery();

			while(rs.next()){
				jsObj = new JSONObject();
				jsObj.put("rowDetailsIndex", rs.getString("FT"));
				jsObj.put("stateIndex", rs.getString("State"));
				jsObj.put("phoneNo1Index", rs.getString("PhoneNo"));
				jsObj.put("cleanerIdIndex", rs.getString("CleanerId"));
				jsObj.put("salaryIndex", rs.getString("Salary"));
				
				jsArr.put(jsObj);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jsArr;
	
	}
	public String approveConductorMaster(int systemId, int custId, String id) {
		String msg = "Error";
		Connection con = null;
		PreparedStatement pstmt = null;

		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(ContainerCargoManagementStatements.APPROVE_CONDUCTOR_MASTER);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, custId);
			pstmt.setString(3, id);
			pstmt.executeUpdate();
			msg = "Approved successfully";
		} catch (Exception e) {
			msg = "Error";
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, null);
		}
		return msg;
	}
	public String rejectConductorMaster(int systemId, int custId, String id, int userId) {
		String msg = "Error";
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		try {
			con = DBConnection.getConnectionToDB("AMS");
			con.setAutoCommit(false);
			pstmt = con.prepareStatement(ContainerCargoManagementStatements.GET_CONDUCTOR_MASTER_BASED_ON_ID);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, custId);
			pstmt.setString(3, id);
			rs = pstmt.executeQuery();
			if(rs.next()) {
			//if it going to be rejected then update current data with previous data
				pstmt = con.prepareStatement(ContainerCargoManagementStatements.UPDATE_CONDUCTOR_MASTER);
				pstmt.setString(1, rs.getString("EMPLOYEE_ID"));
				pstmt.setString(2, rs.getString("CONDUCTOR_NAME"));
				pstmt.setString(3, rs.getString("ADDRESS"));
				pstmt.setString(4, rs.getString("DOB"));
				pstmt.setString(5, rs.getString("FATHER_NAME"));
				pstmt.setString(6, rs.getString("NATIONALITY"));
				pstmt.setString(7, rs.getString("GENDER"));
				pstmt.setString(8, rs.getString("PHONE_NO"));
				pstmt.setString(9, rs.getString("COUNTRY"));
				pstmt.setString(10, rs.getString("STATE"));
				pstmt.setString(11, rs.getString("CITY"));
				pstmt.setString(12, rs.getString("OTHERCITY"));
				pstmt.setString(13, rs.getString("CONTACT_PERSON"));
				pstmt.setString(14, rs.getString("CONTACT_PERSON_PHNO"));
				pstmt.setString(15, rs.getString("SALARY"));
				pstmt.setString(16, "APPROVED");
				pstmt.setInt(17, userId);
				pstmt.setString(18, rs.getString("STATUS"));
				pstmt.setInt(19, systemId);
				pstmt.setInt(20, custId);
				pstmt.setString(21, id);
				pstmt.executeUpdate();
				
			} else {
				//if records are new then no data will be there in history, in that case while rejecting delete the records
				
				pstmt = con.prepareStatement(ContainerCargoManagementStatements.DELETE_CONDUCTOR_MASTER);
				pstmt.setInt(1, systemId);
				pstmt.setInt(2, custId);
				pstmt.setString(3, id);
				pstmt.execute();
			}
			
			msg = "Rejected successfully";
			con.commit();
		} catch (Exception e) {
			msg = "Error";
			rollBack(con);
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return msg;
	}
	public JSONArray getPendingTollModelRateMaster(int systemId, int custId) {
		JSONArray jsArr = new JSONArray();
		JSONObject jsObj = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		try {
			con = DBConnection.getConnectionToDB("LMS");
			pstmt = con.prepareStatement(ContainerCargoManagementStatements.GET_PENDING_TOLL_MODEL_RATE_MASTER_DETAILS);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, custId);
			pstmt.setString(3, "PENDING");
			rs = pstmt.executeQuery();
			
			while(rs.next()){
				jsObj = new JSONObject();
				jsObj.put("slnoIndex", rs.getRow());
		        jsObj.put("IdIndex", rs.getInt("Id"));
		        jsObj.put("locationIndex", rs.getString("Location"));
		        jsObj.put("vehicleModelIndex", rs.getString("Model"));
				
				jsArr.put(jsObj);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jsArr;
	}
	public JSONArray getPendingTollModelRateBasedOnId(int systemId, int custId, String id, int offset) {

		JSONArray jsArr = new JSONArray();
		JSONObject jsObj = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		try {
			con = DBConnection.getConnectionToDB("LMS");
			pstmt = con.prepareStatement(ContainerCargoManagementStatements.GET_PENDING_TOLL_MODEL_RATE_MASTER_BASED_ON_ID);
			pstmt.setInt(1, offset);
			pstmt.setInt(2, offset);
			pstmt.setString(3, id);
			pstmt.setInt(4, offset);
			pstmt.setInt(5, offset);
			pstmt.setString(6, id);
			pstmt.setString(7, id);
			rs = pstmt.executeQuery();

			while(rs.next()){
				jsObj = new JSONObject();
				jsObj.put("rowDetailsIndex", rs.getString("FT"));
				jsObj.put("tollFeeIndex", rs.getString("TollRate"));
				jsObj.put("effectiveFromIndex", rs.getString("EffecFrom"));
				jsObj.put("effectiveToIndex", rs.getString("EffecTo"));
				
				jsArr.put(jsObj);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jsArr;
	
	}
	
	public String approveTollModelRateMaster(int systemId, int custId, String id, int offset) {
		String msg = "Error";
		Connection con = null;
		PreparedStatement pstmt = null;

		try {
			con = DBConnection.getConnectionToDB("LMS");
			con.setAutoCommit(false);
			pstmt = con.prepareStatement(ContainerCargoManagementStatements.APPROVE_TOLL_MODEL_RATE_MASTER);
			pstmt.setString(1, id);
			pstmt.executeUpdate();
			
			//after approving update the expense master toll and total
			
			msg = updateTollRateInExpenseMaster(con, systemId, custId, id, offset);
			
			if(!msg.equals("Error")) {
				con.commit();
				msg = "Approved successfully";
			}
		} catch (Exception e) {
			rollBack(con);
			msg = "Error";
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, null);
		}
		return msg;
	}
	
	private String updateTollRateInExpenseMaster(Connection con, int systemId, int custId, String id, int offset) {
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		double prevToll = 0;
		double currToll = 0;
		int tollId = 0;
		int model = 0;
		String msg = "";
		try {
			pstmt = con.prepareStatement(ContainerCargoManagementStatements.GET_PENDING_TOLL_MODEL_RATE_MASTER_BASED_ON_ID);
			pstmt.setInt(1, offset);
			pstmt.setInt(2, offset);
			pstmt.setString(3, id);
			pstmt.setInt(4, offset);
			pstmt.setInt(5, offset);
			pstmt.setString(6, id);
			pstmt.setString(7, id);
			rs = pstmt.executeQuery();
			while(rs.next()) {
				tollId = rs.getInt("TollId");
				model = rs.getInt("Model");
				if(rs.getString("FT").equals("Current"))
					currToll = rs.getDouble("TollRate");
				if(rs.getString("FT").equals("Previous"))
					prevToll = rs.getDouble("TollRate");
			}
			
			//if it going to be rejected then update current data with previous data
			pstmt = con.prepareStatement(ContainerCargoManagementStatements.UPDATE_TOLL_MODEL_RATE_IN_EXPENSE_MASTER);
			pstmt.setDouble(1, prevToll);
			pstmt.setDouble(2, currToll);
			pstmt.setInt(3, systemId);
			pstmt.setInt(4, custId);
			pstmt.setInt(5, model);
			pstmt.setString(6, "%" + tollId + "%");
			pstmt.executeUpdate();
			
		} catch (Exception e) {
			rollBack(con);
			msg = "Error";
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(null, pstmt, rs);
		}
		return msg;
	}
	public String rejectTollModelRateMaster(int systemId, int custId, String id, int userId) {
		String msg = "Error";
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		try {
			con = DBConnection.getConnectionToDB("LMS");
			con.setAutoCommit(false);
			pstmt = con.prepareStatement(ContainerCargoManagementStatements.GET_TOP_1_TOLL_MODEL_RATE_MASTER_BASED_ON_ID);
			pstmt.setString(1, id);
			rs = pstmt.executeQuery();
			if(rs.next()) {
			//if it going to be rejected then update current data with previous data
				pstmt = con.prepareStatement(ContainerCargoManagementStatements.UPDATE_TOLL_MODEL_RATE_MASTER);
				pstmt.setString(1, rs.getString("TOLL_RATE"));
				pstmt.setInt(2, userId);
				pstmt.setString(3, rs.getString("EFFECTIVE_FROM"));
				pstmt.setString(4, rs.getString("EFFECTIVE_TO"));
				pstmt.setString(5, "APPROVED");
				pstmt.setString(6, id);
				pstmt.executeUpdate();
				
			} else {
				//if records are new in that case while rejecting delete the records
				
				pstmt = con.prepareStatement(ContainerCargoManagementStatements.DELETE_TOLL_MODEL_RATE_MASTER);
				pstmt.setString(1, id);
				pstmt.execute();
			}
			
			msg = "Rejected successfully";
			con.commit();
		} catch (Exception e) {
			msg = "Error";
			rollBack(con);
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return msg;
	}
	public JSONArray getPendingCustomerMaster(int systemId, int custId) {

		JSONArray jsArr = new JSONArray();
		JSONObject jsObj = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		try {
			con = DBConnection.getConnectionToDB("LMS");
			pstmt = con.prepareStatement(ContainerCargoManagementStatements.GET_PENDING_CUSTOMER_MASTER_DETAILS);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, custId);
			pstmt.setString(3, "PENDING");
			rs = pstmt.executeQuery();
			
			while(rs.next()){
				jsObj = new JSONObject();
				jsObj.put("slnoIndex", rs.getRow());
				jsObj.put("IdIndex", rs.getInt("CustomerId"));
				jsObj.put("companyNameIndex", rs.getString("CustName"));
				jsObj.put("companyCodeIndex", rs.getString("CmpnyCode"));
				jsObj.put("customerTypeIndex", rs.getString("CustType"));
				jsObj.put("invTypeIndex", rs.getString("InvType"));
				jsObj.put("statusIndex", rs.getString("Status"));
				jsArr.put(jsObj);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jsArr;
	
	}
	public JSONArray getPendingCustomerMasterBasedOnId(int systemId, int custId, String id) {
		JSONArray jsArr = new JSONArray();
		JSONObject jsObj = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		try {
			con = DBConnection.getConnectionToDB("LMS");
			pstmt = con.prepareStatement(ContainerCargoManagementStatements.GET_PENDING_CUSTOMER_MASTER_BASED_ON_ID);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, custId);
			pstmt.setString(3, id);
			pstmt.setInt(4, systemId);
			pstmt.setInt(5, custId);
			pstmt.setString(6, id);
			rs = pstmt.executeQuery();
			
			while(rs.next()){
				jsObj = new JSONObject();
				jsObj.put("slnoIndex", rs.getRow());
				jsObj.put("rowDetailsIndex", rs.getString("FT"));
				jsObj.put("addressIndex", rs.getString("Address"));
				jsObj.put("cityIndex", rs.getString("City"));
				jsObj.put("stateIndex", rs.getString("State"));
				jsObj.put("countryIndex", rs.getString("COUNTRY_ID"));
				jsObj.put("factory1Index", rs.getString("Factory1"));
				jsObj.put("mobile1Index", rs.getString("Mobile"));
				jsObj.put("email1Index", rs.getString("EmailId"));
				jsObj.put("phoneNo1Index", rs.getString("PhoneNo"));
				jsObj.put("contactPersonIndex", rs.getString("ContactPerson"));
				jsObj.put("contactPersonPhoneNoIndex", rs.getString("ContactPersonPhoneNo"));
				jsObj.put("panNoIndex", rs.getString("PanNo"));
				jsObj.put("stNoIndex", rs.getString("TinNo"));
				jsObj.put("tinNoIndex", rs.getString("STNo"));
				
				jsArr.put(jsObj);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jsArr;
	}
	public String approveCustomerMaster(int systemId, int custId, String id, int offset) {
		String msg = "Error";
		Connection con = null;
		PreparedStatement pstmt = null;

		try {
			con = DBConnection.getConnectionToDB("LMS");
			pstmt = con.prepareStatement(ContainerCargoManagementStatements.APPROVE_CUSTOMER_MASTER);
			pstmt.setString(1, id);
			pstmt.executeUpdate();
			msg = "Approved successfully";
			
		} catch (Exception e) {
			msg = "Error";
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, null);
		}
		return msg;
	}
	public String rejectCustomerMaster(int systemId, int custId, String id, int userId) {
		String msg = "Error";
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		try {
			con = DBConnection.getConnectionToDB("LMS");
			con.setAutoCommit(false);
			pstmt = con.prepareStatement(ContainerCargoManagementStatements.GET_CUSTOMER_MASTER_BASED_ON_ID);
			pstmt.setString(1, id);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				
			//if it going to be rejected then update current data with previous data
				 pstmt = con.prepareStatement(ContainerCargoManagementStatements.UPDATE_LMSCUSTOMER_MASTER_WITH_CLIENT);
					pstmt.setString(1, rs.getString("CUSTOMER_NAME"));
					pstmt.setString(2, rs.getString("COMPANY_NAME"));
					pstmt.setString(3, rs.getString("COUNTRY_ID"));
					pstmt.setString(4, rs.getString("CITY"));
					pstmt.setString(5, rs.getString("STATE"));
					pstmt.setString(6,  rs.getString("CUSTOMER_TYPE"));
					pstmt.setString(7, rs.getString("PAYMENT_TYPE"));
					pstmt.setString(8, rs.getString("BILLING_TYPE"));
					pstmt.setString(9, rs.getString("ADDRESS"));
					pstmt.setString(10, rs.getString("PHONE_NO"));
					pstmt.setString(11, rs.getString("FAX"));
					pstmt.setString(12, rs.getString("MOBILE"));
					pstmt.setString(13, rs.getString("EMAIL_ID"));
					pstmt.setString(14, rs.getString("CONTACT_PERSON"));
					pstmt.setString(15, rs.getString("CONTACT_PERSON_PHONE_NO"));
					pstmt.setString(16, rs.getString("FACTORY1"));
					pstmt.setString(17, rs.getString("FACTORY2"));
					pstmt.setString(18, rs.getString("FACTORY3"));
					pstmt.setString(19, rs.getString("FACTORY4"));
					pstmt.setString(20, rs.getString("PAN_Number"));
					pstmt.setString(21, rs.getString("TIN_Number"));
					pstmt.setInt(22, userId);
					pstmt.setString(23, rs.getString("PHONE_NO2"));
					pstmt.setString(24, rs.getString("MOBILE2"));
					pstmt.setString(25, rs.getString("EMAIL_ID2"));
					pstmt.setString(26, rs.getString("STATUS"));
					pstmt.setString(27, "APPROVED");
					pstmt.setInt(28,rs.getInt("INVOICE_TARIFF"));
					pstmt.setString(29, rs.getString("PDA_ACCOUNT_NO"));
					pstmt.setInt(30,rs.getInt("TAX_LIABILITY"));
					pstmt.setString(31,rs.getString("TAX_NO"));
					pstmt.setInt(32, rs.getInt("INCLUSIVE_TAX"));
					pstmt.setInt(33, rs.getInt("CUSTOMER_ID"));
					pstmt.setInt(34, rs.getInt("SYSTEM_ID"));
					pstmt.setInt(35, rs.getInt("CLIENT_ID"));
					pstmt.executeUpdate();
				
			} else {
				//if records are new in that case while rejecting delete the records
				
				pstmt = con.prepareStatement(ContainerCargoManagementStatements.DELETE_CUSTOMER_MASTER);
				pstmt.setString(1, id);
				pstmt.execute();
			}
			
			msg = "Rejected successfully";
			con.commit();
		} catch (Exception e) {
			msg = "Error";
			rollBack(con);
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return msg;
	}
	public JSONArray getPendingExpenseMaster(int systemId, int custId) {

		JSONArray jsArr = new JSONArray();
		JSONObject jsObj = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		try {
			con = DBConnection.getConnectionToDB("LMS");
			pstmt = con.prepareStatement(ContainerCargoManagementStatements.GET_PENDING_EXPENSE_MASTER_DETAILS);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, custId);
			pstmt.setString(3, "PENDING");
			rs = pstmt.executeQuery();
			
			while(rs.next()){
				jsObj = new JSONObject();
				jsObj.put("slnoIndex", rs.getRow());
				jsObj.put("IdIndex", rs.getInt("UID"));
				jsObj.put("vehicleModelIndex", rs.getString("VehModel"));
				jsObj.put("principalNameIndex", rs.getString("PrincipalName"));
				jsObj.put("consigneeNameIndex", rs.getString("ConsigneeName"));
				jsObj.put("fuelConsumptionIndex", rs.getString("FuelConsumption"));
				jsArr.put(jsObj);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jsArr;
	
	}
	public JSONArray getPendingExpenseMasterBasedOnId(int systemId, int custId, String id, int offset) {
		JSONArray jsArr = new JSONArray();
		JSONObject jsObj = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		try {
			con = DBConnection.getConnectionToDB("LMS");
			pstmt = con.prepareStatement(ContainerCargoManagementStatements.GET_PENDING_EXPENSE_MASTER_BASED_ON_ID);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, custId);
			pstmt.setString(3, id);
			pstmt.setInt(4, systemId);
			pstmt.setInt(5, custId);
			pstmt.setString(6, id);
			rs = pstmt.executeQuery();

			while(rs.next()){
				jsObj = new JSONObject();
				jsObj.put("slnoIndex", rs.getRow());
				jsObj.put("rowDetailsIndex", rs.getString("FT"));
				jsObj.put("kmsIndex", rs.getString("Kms"));
				jsObj.put("rFeeIndex", rs.getString("RFee"));
				jsObj.put("bFeeIndex", rs.getString("BFee"));
				jsObj.put("tollFeeIndex", rs.getString("TFee"));
				jsObj.put("driverIncentiveIndex", rs.getString("DriverIncentive"));
				jsObj.put("policeIndex", rs.getString("Police"));
				jsObj.put("escortIndex", rs.getString("Escort"));
				jsObj.put("labourChargesIndex", rs.getString("LabourCharges"));
				jsObj.put("othersExpIndex", rs.getString("OthersExp"));
				jsObj.put("totalIndex", rs.getString("Total"));
				
				jsArr.put(jsObj);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jsArr;
	}
	public String approveExpenseMaster(int systemId, int custId, String id, int offset) {
		String msg = "Error";
		Connection con = null;
		PreparedStatement pstmt = null;

		try {
			con = DBConnection.getConnectionToDB("LMS");
			pstmt = con.prepareStatement(ContainerCargoManagementStatements.APPROVE_EXPENSE_MASTER);
			pstmt.setString(1, id);
			pstmt.executeUpdate();
			msg = "Approved successfully";
			
		} catch (Exception e) {
			msg = "Error";
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, null);
		}
		return msg;
	}
	public String rejectExpenseMaster(int systemId, int custId, String id, int userId) {
		String msg = "Error";
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		try {
			con = DBConnection.getConnectionToDB("LMS");
			con.setAutoCommit(false);
			pstmt = con.prepareStatement(ContainerCargoManagementStatements.GET_EXPENSE_MASTER_BASED_ON_ID);
			pstmt.setString(1, id);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				
			//if it going to be rejected then update current data with previous data
				pstmt = con.prepareStatement(ContainerCargoManagementStatements.UPDATE_EXPENSE_DETAILS);
				pstmt.setDouble(1, rs.getDouble("KMS"));
				pstmt.setDouble(2, rs.getDouble("DIESEL_REQ"));
				pstmt.setDouble(3, rs.getDouble("RTO_FEE"));
				pstmt.setDouble(4, rs.getDouble("BORDER_FEE"));
				pstmt.setDouble(5, rs.getDouble("TOLL_FEE"));
				pstmt.setDouble(6, rs.getDouble("OTHER_EXPENSES"));
				pstmt.setDouble(7, rs.getDouble("DRIVER_INCENTIVE"));
				pstmt.setDouble(8, rs.getDouble("POLICE"));
				pstmt.setDouble(9, rs.getDouble("ESCORT"));
				pstmt.setDouble(10, rs.getDouble("LOADING"));
				pstmt.setDouble(11, rs.getDouble("OCTROI"));
				pstmt.setDouble(12, rs.getDouble("LABOUR_CHARGES"));
				pstmt.setString(13, "APPROVED");
				pstmt.setInt(14, userId);
				pstmt.setInt(15, systemId);
				pstmt.setInt(16, custId);
				pstmt.setInt(17, Integer.parseInt(id));
				pstmt.executeUpdate();
				
			} else {
				//if records are new in that case while rejecting delete the records
				
				pstmt = con.prepareStatement(ContainerCargoManagementStatements.DELETE_EXPENSE_MASTER);
				pstmt.setString(1, id);
				pstmt.execute();
			}
			
			msg = "Rejected successfully";
			con.commit();
		} catch (Exception e) {
			msg = "Error";
			rollBack(con);
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return msg;
	}
	public JSONArray getPendingDetentionMaster(int systemId, int custId) {

		JSONArray jsArr = new JSONArray();
		JSONObject jsObj = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		try {
			con = DBConnection.getConnectionToDB("LMS");
			pstmt = con.prepareStatement(ContainerCargoManagementStatements.GET_PENDING_DETENTION_MASTER_DETAILS);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, custId);
			pstmt.setString(3, "PENDING");
			rs = pstmt.executeQuery();
				
			while(rs.next()){
				jsObj = new JSONObject();
				jsObj.put("slnoIndex", rs.getRow());
				jsObj.put("IdIndex", rs.getInt("PrincipalFrom"));
				jsObj.put("principalNameIndex", rs.getString("PrincipalName"));
				jsObj.put("consigneeNameIndex", rs.getString("ConsigneeName"));
				jsObj.put("principalIdIndex", rs.getString("PrincipalId"));
				jsObj.put("consigneeIdIndex", rs.getString("ConsigneeId"));
				jsObj.put("detentionTypeIndex", rs.getString("DetentionType"));
				jsObj.put("detentionTypeIdIndex", rs.getString("DetentionTypeId"));
				jsArr.put(jsObj);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jsArr;
	}
	
	public JSONArray getPendingDetentionMasterBasedOnId(int systemId, int custId, String principalFrom, String principalId, String consigneeId, String detentionType) {
		JSONArray jsArr = new JSONArray();
		JSONObject jsObj = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		try {
			con = DBConnection.getConnectionToDB("LMS");
			pstmt = con.prepareStatement(ContainerCargoManagementStatements.GET_PENDING_DETENTION_MASTER_BASED_ON_ID);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, custId);
			pstmt.setString(3, principalFrom);
			pstmt.setString(4, principalId);
			pstmt.setString(5, consigneeId);
			pstmt.setString(6, detentionType);
			pstmt.setInt(7, systemId);
			pstmt.setInt(8, custId);
			pstmt.setString(9, principalFrom);
			pstmt.setString(10, principalId);
			pstmt.setString(11, consigneeId);
			pstmt.setString(12, detentionType);
			rs = pstmt.executeQuery();

			while(rs.next()){
				jsObj = new JSONObject();
				jsObj.put("slnoIndex", rs.getRow());
				jsObj.put("rowDetailsIndex", rs.getString("FT"));
				jsObj.put("principalFromIndex", rs.getString("PrincipalFrom"));
				jsObj.put("principalToIndex", rs.getString("PrincipalTo"));
				jsObj.put("principalCostIndex", rs.getString("PrincipalCost"));
				jsObj.put("consigneeFromIndex", rs.getString("ConsigneeFrom"));
				jsObj.put("consigneeToIndex", rs.getString("ConsigneeTo"));
				jsObj.put("consigneeCostIndex", rs.getString("ConsigneeCost"));
				
				jsArr.put(jsObj);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jsArr;
	}
	public String approveDetentionMaster(int systemId, int custId, String principalFrom, String principalId, String consigneeId, String detentionType) {
		String msg = "Error";
		Connection con = null;
		PreparedStatement pstmt = null;

		try {
			con = DBConnection.getConnectionToDB("LMS");
			pstmt = con.prepareStatement(ContainerCargoManagementStatements.APPROVE_DETENTION_MASTER);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, custId);
			pstmt.setString(3, principalFrom);
			pstmt.setString(4, principalId);
			pstmt.setString(5, consigneeId);
			pstmt.setString(6, detentionType);
			
			pstmt.executeUpdate();
			msg = "Approved successfully";
			
		} catch (Exception e) {
			msg = "Error";
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, null);
		}
		return msg;
	}
	public String rejectDetentionMaster(int systemId, int custId, String principalFrom, int userId, String principalId, String consigneeId, String detentionType) {
		String msg = "Error";
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		try {
			con = DBConnection.getConnectionToDB("LMS");
			con.setAutoCommit(false);
			pstmt = con.prepareStatement(ContainerCargoManagementStatements.GET_DETENTION_MASTER_BASED_ON_ID);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, custId);
			pstmt.setString(3, principalFrom);
			pstmt.setString(4, principalId);
			pstmt.setString(5, consigneeId);
			pstmt.setString(6, detentionType);
			rs = pstmt.executeQuery();
			if(rs.next()) {

				//if it going to be rejected then update current data with previous data
				pstmt = con.prepareStatement(ContainerCargoManagementStatements.UPDATE_DETENTION_CHARGES_DETAILS);
				pstmt.setDouble(1, rs.getDouble("PRINCIPAL_CHARGE"));
				pstmt.setDouble(2, rs.getDouble("CONSIGNEE_CHARGE"));
				pstmt.setInt(3, userId);
				pstmt.setString(4,"APPROVED");
				pstmt.setInt(5, systemId);
				pstmt.setInt(6, custId);
				pstmt.setInt(7, rs.getInt("DETENTION_TYPE"));
				pstmt.setInt(8, rs.getInt("PRINCIPAL_ID"));
				pstmt.setInt(9, rs.getInt("CONSIGNEE_ID"));
				pstmt.setDouble(10, rs.getDouble("PRINCIPAL_FROM"));
				pstmt.executeUpdate();
				
			} else {
				//if records are new in that case while rejecting delete the records
				
				pstmt = con.prepareStatement(ContainerCargoManagementStatements.DELETE_DETENTION_MASTER);
				pstmt.setInt(1, systemId);
				pstmt.setInt(2, custId);
				pstmt.setString(3, principalFrom);
				pstmt.setString(4, principalId);
				pstmt.setString(5, consigneeId);
				pstmt.setString(6, detentionType);
				pstmt.execute();
			}
			
			msg = "Rejected successfully";
			con.commit();
		} catch (Exception e) {
			msg = "Error";
			rollBack(con);
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return msg;
	}
	
	public List<Object> getStartingFuel(int systemId, int custId, String assetNo, int offset) {
		Connection con = null;
		PreparedStatement pstmt = null;
		PreparedStatement pstmt1 = null;
		ResultSet rs = null;
		ResultSet rs1 = null;
		double startingFuel = 0;
		double startingFuelCost = 0;
		double nonTripFuelConsumed = 0;
//		double nonTripFuelConsumedCost = 0;
		double totDisTravelled = 0;
		double nonTripFilledFuel = 0;
		double nonTripFilledFuelCost = 0;
		List<Object> fuelList = new ArrayList<Object>();
		String tripNo = "";
		
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(ContainerCargoManagementStatements.GET_AVAILABLE_FUEL_IN_LAST_TRIP);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, custId);
			pstmt.setString(3, assetNo);
			pstmt.setString(4, "CLOSED");
			rs = pstmt.executeQuery();
			if(rs.next()) {
				tripNo = rs.getString("TripNo");
				double ConversionFactor = initializedistanceConversionFactor(systemId,con,assetNo);
				VehicleActivity va = new VehicleActivity(con, assetNo, rs.getTimestamp("CLOSED_TIME"), rs.getTimestamp("CurrentTime"), offset, systemId, custId, 0);
				VehicleSummaryBean vsb = va.getVehicleSummaryBean();
				totDisTravelled = vsb.getTotalDistanceTravelled()*ConversionFactor;
				double approxMileageWithLoad = getApproxMileage(con, assetNo, systemId);
//				System.out.println("totDisTravelled : "+totDisTravelled +" start : "+rs.getTimestamp("CLOSED_TIME") +" close : "+ rs.getTimestamp("CurrentTime")+" mileage : "+approxMileageWithLoad);
				if(approxMileageWithLoad > 0)
					nonTripFuelConsumed = totDisTravelled/ approxMileageWithLoad;
				
				//non trip filled fuel
				pstmt = con.prepareStatement(ContainerCargoManagementStatements.GET_NON_TRIP_FILLED_FUEL);
				pstmt.setInt(1, systemId);
				pstmt.setInt(2, custId);
				pstmt.setString(3, assetNo);
				pstmt.setString(4,rs.getString("CREATED_TIME"));
				rs1 = pstmt.executeQuery();
				while(rs1.next()) {
					nonTripFilledFuel = nonTripFilledFuel + rs1.getDouble("NTFilledFuel");
					nonTripFilledFuelCost = nonTripFilledFuelCost + + rs1.getDouble("Amount");
				}
				startingFuel = rs.getDouble("TripClosingFuel") + nonTripFilledFuel - nonTripFuelConsumed ;
				double totFuelCost = rs.getDouble("TripClosingFuelCost") + nonTripFilledFuelCost ;
				double totFuel = rs.getDouble("TripClosingFuel") + nonTripFilledFuel;
				
				if(totFuel > 0) {
//					nonTripFuelConsumedCost = (totFuelCost/totFuel) * nonTripFuelConsumed;
					startingFuelCost = (totFuelCost/totFuel) * startingFuel;
				}
				
			}
			
			fuelList.add(tripNo);
			fuelList.add(startingFuel);
			fuelList.add(startingFuelCost);
			fuelList.add(nonTripFilledFuel);
			fuelList.add(nonTripFilledFuelCost);
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
			DBConnection.releaseConnectionToDB(null, pstmt1, rs1);
		}
		
		return fuelList;
	}
	
	public double initializedistanceConversionFactor(int SystemId,Connection con,String registrationNo){
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		double distanceConversionFactor;
		distanceConversionFactor = 1.0;
		try{	
			pstmt=con.prepareStatement(ContainerCargoManagementStatements.GET_DISTANCE_CONVERSION_FACTOR_FROM_VEHICLE_TYPE);
			pstmt.setInt(1,SystemId);
			pstmt.setString(2,registrationNo);
			rs = pstmt.executeQuery();
			while(rs.next()){
				distanceConversionFactor=rs.getDouble("ConversionFactor");
			}
			DBConnection.releaseConnectionToDB(null,pstmt,rs);	
		}
		catch(Exception e){
			DBConnection.releaseConnectionToDB(null,pstmt,rs);	
			e.printStackTrace();
		}
		return distanceConversionFactor;
	}
	
	public double getApproxMileage(Connection con, String vehicleNumber, int systemId) {
		double appMileageWithLoad = 0.00;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			pstmt = con.prepareStatement("select Approx_Mileage_With_Load from tblVehicleMaster where  VehicleNo = ? and System_id=? ");
			pstmt.setString(1, vehicleNumber);
			pstmt.setInt(2, systemId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				appMileageWithLoad = rs.getDouble("Approx_Mileage_With_Load");
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(null, pstmt, rs);
		}
		return appMileageWithLoad;
	}
	
	public String saveFuelResetDetails(int systemId, int customerId, String resetFuel, String availFuel, String assetNo, String tripNo, String availFuelCost, int userId) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String msg = "";
		
		try {
			con = DBConnection.getConnectionToDB("LMS");
			con.setAutoCommit(false);

			boolean flag = isFuelReset(con, systemId, customerId, tripNo, assetNo);
			
			if(flag) {
				return "Fuel reset already happened.";
			}
			//insert reset fuel details in reset_fuel table
			
			double availableFuel = 0;
			double availableFuelCost = 0;
			double rFuelCost = 0;
			double resetFuelCost = 0;
			
			if(!availFuel.equals("") && !availFuel.equals("undefined")) {
				availableFuel = Double.parseDouble(availFuel);
			}
			if(!availFuelCost.equals("") && !availFuelCost.equals("undefined")) {
				availableFuelCost = Double.parseDouble(availFuelCost);
			}
			if(!resetFuel.equals("") && !resetFuel.equals("undefined")) {
				rFuelCost = Double.parseDouble(resetFuel);
			}
			
			if(availableFuel  > 0) 
				resetFuelCost = (availableFuelCost/availableFuel)*rFuelCost;
			
			pstmt = con.prepareStatement(ContainerCargoManagementStatements.SAVE_FUEL_RESET);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, customerId);
			pstmt.setString(3, assetNo);
			pstmt.setString(4, tripNo);
			pstmt.setString(5, availFuel);
			pstmt.setString(6, availFuelCost);
			pstmt.setString(7, resetFuel);
			pstmt.setDouble(8, resetFuelCost);
			pstmt.setInt(9, userId);
			pstmt.executeUpdate();
			pstmt.close();
			
			//update reset details in trip_details table 
			
			pstmt = con.prepareStatement(ContainerCargoManagementStatements.UPDATE_RESET_FUEL_IN_TRIP_DETAILS);
			pstmt.setString(1, resetFuel);
			pstmt.setDouble(2, resetFuelCost);
			pstmt.setInt(3, 1);//is_reset_fuel
			pstmt.setInt(4, systemId);
			pstmt.setInt(5, customerId);
			pstmt.setString(6, assetNo);
			pstmt.setString(7, tripNo);
			pstmt.executeUpdate();
			con.commit();
			
			msg = "Success";
		} catch (Exception e) {
			rollBack(con);
			msg = "Error";
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		
		return msg;
	}
	
	private boolean isFuelReset(Connection con, int systemId, int customerId, String tripNo, String assetNo) {
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		boolean flag = false;
		try {
			pstmt = con.prepareStatement(ContainerCargoManagementStatements.IS_FUEL_RESET);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, customerId);
			pstmt.setString(3, assetNo);
			pstmt.setString(4, tripNo);
			pstmt.setInt(5, 1);
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				flag = true;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return flag;
	}
	public ArrayList<Object> getFuelResetData(int custId, int systemId, int offset, String vehId, String startDate, String endDate, String language) {

		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		JSONArray jsArr = new JSONArray();
		JSONObject obj = new JSONObject();

		ArrayList<ReportHelper> reportsList = new ArrayList<ReportHelper>();
		ArrayList<String> headersList = new ArrayList<String>();
		ReportHelper finalreporthelper = new ReportHelper();
		ArrayList<Object> finlist = new ArrayList<Object>();

		headersList.add(commonFunctions.getLabelFromDB("SLNO", language));
		headersList.add(commonFunctions.getLabelFromDB("Vehicle_No", language));
		headersList.add(commonFunctions.getLabelFromDB("Date", language));
		headersList.add(commonFunctions.getLabelFromDB("Available_Fuel", language));
		headersList.add(commonFunctions.getLabelFromDB("Reset_Fuel", language));
		headersList.add(commonFunctions.getLabelFromDB("Reset_By", language));

		try { 
			con = DBConnection.getConnectionToDB("LMS");
			if ("All".equals(vehId)) {
				pstmt = con.prepareStatement(ContainerCargoManagementStatements.GET_FUEL_RESET_DETAILS);
			}else{
				pstmt = con.prepareStatement(ContainerCargoManagementStatements.GET_FUEL_RESET_DETAILS + " and ASSET_NO=?");
				pstmt.setString(8, vehId);
			}
			pstmt.setInt(1, offset);
			pstmt.setInt(2, systemId);
			pstmt.setInt(3, custId);
			pstmt.setInt(4, offset);
			pstmt.setString(5, startDate);
			pstmt.setInt(6, offset);
			pstmt.setString(7, endDate);
			rs = pstmt.executeQuery();

			while (rs.next()) {
				obj = new JSONObject();
				ArrayList<Object> informationList=new ArrayList<Object>();
				ReportHelper reporthelper=new ReportHelper();

				informationList.add(rs.getRow());
				obj.put("slnoIndex", rs.getRow());

				informationList.add(rs.getString("AssetNo"));
				obj.put("assetNoIndex", rs.getString("AssetNo"));

				informationList.add(ddmmyyyy.format(yyyymmdd.parseObject(rs.getString("ResetDate"))));
				obj.put("resetDateIndex", ddmmyyyy.format(yyyymmdd.parse(rs.getString("ResetDate"))));

				informationList.add(rs.getString("AvailFuel"));
				obj.put("availableFuelIndex", rs.getString("AvailFuel"));

				informationList.add(rs.getString("ResetFuel"));
				obj.put("resetFuelIndex", rs.getString("ResetFuel"));

				informationList.add(rs.getString("ResetBy"));
				obj.put("resetByIndex", rs.getString("ResetBy"));

				jsArr.put(obj);
				reporthelper.setInformationList(informationList);
				reportsList.add(reporthelper);	
			}
			finlist.add(jsArr);
			finalreporthelper.setReportsList(reportsList);
			finalreporthelper.setHeadersList(headersList);
			finlist.add(finalreporthelper);

		} 	catch (Exception e) {
			e.printStackTrace();
		} 	finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return finlist;
	}
	
	public JSONArray getVehiclesNotOnTrip(int systemId, int custId, int userId) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		JSONArray jsArr = new JSONArray();
		JSONObject jsObj = null;
		
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(ContainerCargoManagementStatements.GET_VEHICLES_NOT_ON_TRIP);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, custId);
			pstmt.setInt(3, userId);
			pstmt.setInt(4, systemId);
			pstmt.setInt(5, custId);
			rs = pstmt.executeQuery();
			
			while(rs.next()) {
				jsObj = new JSONObject();
				jsObj.put("VehicleNo", rs.getString("REGISTRATION_NUMBER"));
				
				jsArr.put(jsObj);
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
            DBConnection.releaseConnectionToDB(con, pstmt, rs);
        }
		return jsArr;
	}
	public JSONArray getSumarryInvoiceDetails(int systemId, int clientId, String principalId, String typeId, String startDate, String endDate,int offset, String invoiceType){
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		JSONArray jsArr = new JSONArray();
		JSONObject obj = null;
		try {
			int type = 2;
			String remarks = "Unloading Charges Invoice";
			
			if(typeId.equals("1")){
				type = 1;
				remarks = "Billing Tariff Invoice";
			}
			con = DBConnection.getConnectionToDB("LMS");
			if(invoiceType.equals("1")){
				remarks = "Summary Invoice";
				if(type == 1){
					pstmt = con.prepareStatement(ContainerCargoManagementStatements.GET_SUMMARY_INVOICE_DETAILS_SINGLE.replace("#", "isnull(sum(ind.BILLING_RATE),0)"));
				}else{
					pstmt = con.prepareStatement(ContainerCargoManagementStatements.GET_SUMMARY_INVOICE_DETAILS_SINGLE.replace("#", "isnull(sum(ind.ORIGINAL_BILLING_RATE),0)"));
				}
				
			}else{
				pstmt = con.prepareStatement(ContainerCargoManagementStatements.GET_SUMMARY_INVOICE_DETAILS_MULTIPLE);
			}
			pstmt.setInt(1, type);
			pstmt.setInt(2, systemId);
			pstmt.setInt(3, clientId);
			pstmt.setInt(4, Integer.parseInt(principalId));
			pstmt.setInt(5, offset);
			pstmt.setString(6, startDate.replace("T", " "));
			pstmt.setInt(7, offset);
			pstmt.setString(8, endDate.replace("T", " "));
			pstmt.setString(9, remarks);
			rs = pstmt.executeQuery();
			while(rs.next()) {
				obj = new JSONObject();
				obj.put("consigneeDI", rs.getString("consignee"));
				obj.put("quantityDI", rs.getDouble("qty"));
				obj.put("typeDI", rs.getString("billingType"));
				if(rs.getString("billingType").equals("Fixed")){
					obj.put("rateDI", doubleDecimalFormat.format(rs.getDouble("amount")));
				}else{
					obj.put("rateDI", doubleDecimalFormat.format(rs.getDouble("rate")));
				}
				obj.put("amountDI", doubleDecimalFormat.format(rs.getDouble("amount")));
				jsArr.put(obj);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
            DBConnection.releaseConnectionToDB(con, pstmt, rs);
        }
		return jsArr;
	}
	public ArrayList<String> invoiceHeaderDetails(int systemId, int clientId, String invoiceType){
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		ArrayList<String> invoiceTitleDetails = new ArrayList<String>();
		try {
			con = DBConnection.getConnectionToDB("LMS");
			pstmt = con.prepareStatement(ContainerCargoManagementStatements.GET_INVOICE_HEADER_DETAILS);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, clientId);
			pstmt.setString(3, invoiceType);
			rs = pstmt.executeQuery();
			while(rs.next()){
				invoiceTitleDetails.add(rs.getString("DATA"));
			}
		} catch (Exception e) {
			e.printStackTrace();
		}finally{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return invoiceTitleDetails;
	}
	
	public synchronized String generateInvoiceNumber(int systemId, int clientId,String type) {
		String invoiceNo = "";
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			con = DBConnection.getConnectionToDB("LMS");
			int RunningNo = 0;
			pstmt = con.prepareStatement(ContainerCargoManagementStatements.GET_INVOICE_NO);
			pstmt.setInt(1, clientId);
			pstmt.setInt(2, systemId);
			pstmt.setString(3, type);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				RunningNo = rs.getInt("invoiceNo");
			}
			rs.close();
			RunningNo++;
			invoiceNo = type+"/"+RunningNo;
			boolean recordPresent = false;
			pstmt = con.prepareStatement(ContainerCargoManagementStatements.IS_PRESENT_INVOICE_NO);
			pstmt.setInt(1, clientId);
			pstmt.setInt(2, systemId);
			pstmt.setString(3, type);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				recordPresent = true;
			}
			if (recordPresent) {
				pstmt = con.prepareStatement(ContainerCargoManagementStatements.UPDATE_INVOICE_NO);
				pstmt.setInt(1, RunningNo);
				pstmt.setInt(2, clientId);
				pstmt.setInt(3, systemId);
				pstmt.setString(4, type);
				pstmt.executeUpdate();
			} else {
				pstmt = con.prepareStatement(ContainerCargoManagementStatements.INSERT_INVOICE_NO);
				pstmt.setInt(1, RunningNo);
				pstmt.setInt(2, clientId);
				pstmt.setInt(3, systemId);
				pstmt.setString(4, type);
				pstmt.executeUpdate();
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return invoiceNo;
	}
	public ArrayList<String> getPrincipalDetails(int systemId, int clientId, String principalId) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		ArrayList<String> principalDetails = new ArrayList<String>();
		try {
			con = DBConnection.getConnectionToDB("LMS");
			pstmt = con.prepareStatement(ContainerCargoManagementStatements.GET_PRINCIPAL_ADDRESS);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, clientId);
			pstmt.setString(3, principalId);
			rs = pstmt.executeQuery();
			principalDetails.add("To,");
			while(rs.next()){
				principalDetails.add(rs.getString("name"));
				principalDetails.add(rs.getString("address"));
			}
		} catch (Exception e) {
			e.printStackTrace();
		}finally{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return principalDetails;
	}
	
public JSONArray getOpeningAndClosingBal(int systemId, String custId, String branchId, String startDate, String endDate, int offset) {
		
		JSONArray ja = new JSONArray();
		JSONObject obj = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		double ledgerBalOfPrevMonth = 0;
		double openingBalance = 0;
		double closingBalance = 0;
		
		try {
			con = DBConnection.getConnectionToDB("LMS");
			//System.out.println("start " + startDate+"\tend "+endDate);
			pstmt = con.prepareStatement(ContainerCargoManagementStatements.GET_LEDGER_BAL_OF_PREV_MONTH);
			pstmt.setInt(1, systemId);
			pstmt.setString(2, custId);
			pstmt.setString(3, branchId);
			pstmt.setString(4, startDate);
			pstmt.setString(5, startDate);
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				ledgerBalOfPrevMonth = rs.getDouble("LEDGER_BAL");
			}
			rs.close();
			pstmt.close();
			
			//get all transac sum from 1 st day of selected start date to selected start date
			pstmt = con.prepareStatement(ContainerCargoManagementStatements.GET_APPROVED_TRANSAC_TILL_START_DATE);
			pstmt.setInt(1, systemId);
			pstmt.setString(2, custId);
			pstmt.setString(3, branchId);
			pstmt.setInt(4, offset);
			pstmt.setString(5, startDate);//1ST DATE OF START DATE
			pstmt.setInt(6, offset);
			pstmt.setString(7, startDate);//START DATE
			rs = pstmt.executeQuery();
			while(rs.next()) {
				openingBalance = openingBalance + rs.getDouble("AMOUNT");
			}
			
			pstmt = con.prepareStatement(ContainerCargoManagementStatements.GET_APPROVED_TRANSAC_TILL_END_DATE);
			pstmt.setInt(1, systemId);
			pstmt.setString(2, custId);
			pstmt.setString(3, branchId);
			pstmt.setInt(4, offset);
			pstmt.setString(5, startDate);//1ST DATE OF START DATE
			pstmt.setInt(6, offset);
			pstmt.setString(7, endDate);//END DATE
			rs = pstmt.executeQuery();
			while(rs.next()) {
				closingBalance = closingBalance + rs.getDouble("AMOUNT");
			}
			//System.out.println("ledgerBalOfPrevMonth \t"+ledgerBalOfPrevMonth+"\topeningBalance\t"+openingBalance+"\tclosingBalance\t"+closingBalance);
			openingBalance = openingBalance + ledgerBalOfPrevMonth;
			closingBalance = closingBalance + ledgerBalOfPrevMonth;
			
			obj.put("openingBal", doubleDecimalFormat.format(openingBalance));
			obj.put("closingBal", doubleDecimalFormat.format(closingBalance));
			ja.put(obj);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return ja;
		
	}

	public JSONObject getAddExpDocuments(String id) {
	

		JSONObject jsonObject = new JSONObject();
		Connection conAdmin=null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		String fileName = null;
		String destinationPath = new File(System.getProperty("catalina.base"))+ "/webapps/ApplicationImages/TempImageFile/";
		String localUrl = null;
		String dateTime = null;
		try {
			Properties properties = ApplicationListener.prop;
			String path = properties.getProperty("DocumentUploadPath").trim();
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			
			String fileExtension = null;
			conAdmin = DBConnection.getConnectionToDB("AMS");
			pstmt = conAdmin.prepareStatement(ContainerCargoManagementStatements.GET_ADD_EXP_INVOICE);
			pstmt.setString(1, id);
			rs = pstmt.executeQuery();
			Calendar cal = null;
			int day = 0;
			int month = 0;
			int year = 0;
			if(rs.next()){
				try {
					fileName = rs.getString("FILE_NAME");
					if(fileName.length() > 0) {
						fileExtension = fileName.substring(fileName.indexOf("."));
					}
					dateTime = rs.getString("INSERTED_DATE");
					if (dateTime!=null) {
						Date d = sdf.parse(dateTime);
						cal = Calendar.getInstance();
						cal.setTime(d);
						day = cal.get(Calendar.DAY_OF_MONTH);
						month = cal.get(Calendar.MONTH);
						year = cal.get(Calendar.YEAR);
						month+=1;
						File trgDir = new File(destinationPath);
						File srcDir = new File(path+"/"+"Padma_Add_Expense"+"/"+year+"/"+month+"/"+day+"/"+id+fileExtension);
						
						if(srcDir.exists()) {
							FileUtils.copyFileToDirectory(srcDir, trgDir);
	
							localUrl = trgDir+"/"+id+fileExtension;
	
							jsonObject = new JSONObject();
							jsonObject.put("id", id);
							jsonObject.put("name", fileName);
							jsonObject.put("fileExtension", fileExtension);
							jsonObject.put("url", localUrl);
						} else {
							jsonObject = new JSONObject();
							jsonObject.put("id", "No File Founds...");
						}
					}
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}finally{
			DBConnection.releaseConnectionToDB(conAdmin, pstmt, rs);
		}
		return jsonObject;
	
	}
}