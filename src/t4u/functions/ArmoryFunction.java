package t4u.functions;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.DateFormat;
import java.text.DecimalFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import t4u.beans.ReportHelper;
import t4u.common.DBConnection;
import t4u.statements.ArmoryStatements;
import t4u.statements.CashVanManagementStatements;
/**
 * 
 * @author amit.g
 *     used in cash van management
 */
public class ArmoryFunction {
	CommonFunctions cf=new CommonFunctions();
	String message;
	SimpleDateFormat sdfyyyymmddhhmmss=new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
	SimpleDateFormat yyyymmdd = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	SimpleDateFormat simpleDateFormatddMMYYYYDB = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	SimpleDateFormat sdfFormatDate = new SimpleDateFormat("MM/dd/yyyy HH:mm:ss");
	DecimalFormat df=new DecimalFormat("##.##");
	SimpleDateFormat ddmmyyyy = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
	ArmoryStatements armoryStatements;
	
	public boolean saveArmory(String jsonData, Integer branchId,
			String vendorName, Integer assetItemId, String dateString,
			int systemId, String custId, int userId) {
		//(ASSET_NO,QR_CODE,STATUS,BRANCH_ID,VENDOR_NAME,CREATED_BY_ID,SYSTEM_ID,CLIENT_ID) VALUES(?,?,?,?,?,?,?,?)

	long dateLongValue;
	Connection conAdmin=null;
	PreparedStatement pstmt=null;
	//ResultSet rs=null;

	conAdmin=DBConnection.getConnectionToDB("AMS");
	String assets[]=jsonData.split(",");
	try {
		pstmt=conAdmin.prepareStatement(ArmoryStatements.INSERT_ARMORY_INVENTORY);
		//dateLongValue=new Date().getTime();
		for (int i = 0; i < assets.length; i++) {

			
			pstmt.setString(1, assets[i]);
			pstmt.setLong(2, System.nanoTime());
			pstmt.setInt(3, assetItemId);
			pstmt.setString(4, "IN ARMORY");
			pstmt.setInt(5, branchId);
			pstmt.setString(6, vendorName);
			pstmt.setInt(7, userId);
			pstmt.setInt(8, systemId);
			pstmt.setInt(9, Integer.parseInt(custId));
			try {
				pstmt.execute();
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		return true;
	}catch(Exception e){
		e.printStackTrace();
	}finally{
		DBConnection.releaseConnectionToDB(conAdmin, pstmt, null);
	}
	
		return false;
	}


	public String saveArmoryItem(String item, Integer systemId, Integer custId,Integer userId,String itemType) {
		Connection conAdmin=null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		conAdmin=DBConnection.getConnectionToDB("AMS");
		try {
			
            pstmt = conAdmin.prepareStatement(ArmoryStatements.CHECK_ASSET_IF_ALREADY_EXIST);			
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, custId);
			pstmt.setString(3, item);
			 rs = pstmt.executeQuery();
			 if(rs.next())
			 
			 {
				 message="Item Name Already Exist";
				 return message;
			 }
			 else {
			
			
			pstmt=conAdmin.prepareStatement(ArmoryStatements.INSERT_ARMORY_ITEM);
			pstmt.setString(1, item);
			pstmt.setInt(2, systemId);
			pstmt.setInt(3, custId);
			pstmt.setInt(4, userId);
			pstmt.setString(5, itemType);
			int inserted = pstmt.executeUpdate();
			if (inserted > 0) {
                  message = "Saved Successfully";
                  
              }
			 }
		}
	 catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}finally{
			DBConnection.releaseConnectionToDB(conAdmin, pstmt, null);
		}
		return message;
		
		
	}

/**
 * 
 * @param systemId
 * @param custId
 * @return jsonArray on assets name
 */
	
	public JSONArray getAssetNames(int systemId, Integer custId) {
		Connection conAdmin=null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		 JSONArray JsonArray = new JSONArray();
		 JSONObject JsonObject = null;
		conAdmin=DBConnection.getConnectionToDB("AMS");
		try {
			pstmt=conAdmin.prepareStatement(ArmoryStatements.GET_ALL_ASSET_NO);			
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, custId);
			rs=pstmt.executeQuery();
			  while (rs.next()) {
				  JsonObject = new JSONObject();
				  JsonObject.put("AssetNo", rs.getString("ASSET_NO"));		          
		          JsonArray.put(JsonObject);				
			}
                 
                  
             
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (JSONException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}finally{
			DBConnection.releaseConnectionToDB(conAdmin, pstmt, rs);
		}
		return JsonArray;
	}
	
	public JSONArray getArmoryItems(int systemId, Integer custId) {
		Connection conAdmin=null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		 JSONArray JsonArray = new JSONArray();
		 JSONObject JsonObject = null;
		conAdmin=DBConnection.getConnectionToDB("AMS");
		try {
			pstmt=conAdmin.prepareStatement(ArmoryStatements.GET_ARMORY_ITEMS);
			
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, custId);
			rs=pstmt.executeQuery();
			  while (rs.next()) {
				  JsonObject = new JSONObject();
				  JsonObject.put("itemId", rs.getString("Id"));
		            JsonObject.put("itemName", rs.getString("ITEM_NAME"));
		            JsonArray.put(JsonObject);
				
			}
                 
                  
             
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (JSONException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}finally{
			DBConnection.releaseConnectionToDB(conAdmin, pstmt, rs);
		}
		return JsonArray;
	}
	/**
	 * 
	 * @param systemId
	 * @param custId
	 * @return Branches for armory inward
	 */
	public JSONArray getBranches(Integer systemId, Integer custId) {
		Connection conAdmin=null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		 JSONArray JsonArray = new JSONArray();
		 JSONObject JsonObject = null;
		conAdmin=DBConnection.getConnectionToDB("AMS");
		try {
			pstmt=conAdmin.prepareStatement(ArmoryStatements.GET_BRANCHES);
			
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, custId);
			rs=pstmt.executeQuery();
			  while (rs.next()) {
				  JsonObject = new JSONObject();
		            JsonObject.put("branchId", rs.getString("BranchId"));
		            JsonObject.put("branchName", rs.getString("BranchName"));
		            JsonArray.put(JsonObject);
				 
			}
                 
                  
             
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (JSONException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}finally{
			DBConnection.releaseConnectionToDB(conAdmin, pstmt, rs);
		}
		return JsonArray;
	}
	

/**
 * 
 * @param systemId
 * @param customerId
 * @return list of armory with other details from inventory
 */

	public ArrayList<Object> getArmoryInventory(Integer offset,Integer systemId, Integer customerId) {
		JSONArray ServiceTypeJsonArray = new JSONArray();
		JSONObject ServiceTypeJsonObject = new JSONObject();
		Connection conAdmin=null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		int count=0;
		String active="";
		String inactive="";
		String activestatus="";
		SimpleDateFormat sdf=new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
		SimpleDateFormat sdf1=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		String updateddate="";
		ArrayList<Object> informationList = new ArrayList<Object>();
		ArrayList < ReportHelper > reportsList = new ArrayList < ReportHelper > ();
		ArrayList < String > headersList = new ArrayList < String > ();
		ReportHelper finalreporthelper = new ReportHelper();
		ArrayList < Object > aslist = new ArrayList < Object > ();
		 JSONArray JsonArray = new JSONArray();
		 JSONObject JsonObject = null;
		conAdmin=DBConnection.getConnectionToDB("AMS");
		try {
			headersList.add("SLNO");
            headersList.add("Asset Number");
            headersList.add("ASSET NAME");
            headersList.add("QR CODE");
            headersList.add("STATUS");
            headersList.add("DATE");
            headersList.add("VENDOR NAME");
            headersList.add("BRANCH NAME");
            headersList.add("REASON");
            headersList.add("IS ACTIVE");
            
            ServiceTypeJsonArray = new JSONArray();
			ServiceTypeJsonObject = new JSONObject();
			pstmt=conAdmin.prepareStatement(ArmoryStatements.GET_ARMORY_INVENTORY);
			pstmt.setInt(1, offset);
			pstmt.setInt(2, systemId);
			pstmt.setInt(3, customerId);
			rs=pstmt.executeQuery();
			  while (rs.next()) 
			  {
				  updateddate = rs.getString("date");
			   	
			   	if(updateddate.equals("1900-01-01 00:00:00.0")){
			   	
			   	updateddate="";
			   	}
			   	else
			   	{
			   	
			   	updateddate =sdf.format(sdf1.parse(rs.getString("date")));
			   	}
			   	

			   	activestatus = rs.getString("isActive");
			   	
			   	if(activestatus.equals("1")){
			   	
			   		activestatus="ACTIVE";
			   	}
			   	else
			   	{
			   	
			   		activestatus ="INACTIVE";
			   	}
			   			   	
				  int Count=++count;
				  JsonObject = new JSONObject();
				  informationList = new ArrayList<Object>();
				  ServiceTypeJsonObject = new JSONObject();
				  
					  JsonObject.put("slnoIndex",Count);
				  	  informationList.add(Count);
			  	  
		            JsonObject.put("assetNo", rs.getString("assetNo"));
		            informationList.add(rs.getString("assetNo"));
		            
		            JsonObject.put("assetName", rs.getString("assetName"));
		            informationList.add(rs.getString("assetName"));
		            
		            
		            JsonObject.put("qrCode", rs.getString("qrCode"));
		            informationList.add(rs.getString("qrCode"));
		            
		            JsonObject.put("status", rs.getString("status"));
		            informationList.add(rs.getString("status"));
		            
		            JsonObject.put("date", updateddate);
		            informationList.add(updateddate);
		            
		            JsonObject.put("vendorName", rs.getString("vendorName"));
		            informationList.add(rs.getString("vendorName"));
		            
		            
		           JsonObject.put("branchName", rs.getString("branchName"));
		            informationList.add(rs.getString("branchName"));
		            
		           JsonObject.put("reason", rs.getString("reason"));
		            informationList.add(rs.getString("reason"));
		            
		            JsonObject.put("isActive", activestatus);
		            informationList.add(activestatus);
		            
		            ServiceTypeJsonArray.put(JsonObject);
		            ReportHelper reporthelper = new ReportHelper();
					reporthelper.setInformationList(informationList);
					reportsList.add(reporthelper);
			        }
			       
			        aslist.add(ServiceTypeJsonArray);
			        finalreporthelper.setReportsList(reportsList);
					finalreporthelper.setHeadersList(headersList);
					aslist.add(finalreporthelper);
				
				}
			        catch (Exception e) {
						e.printStackTrace();
					}
		
		finally{
			DBConnection.releaseConnectionToDB(conAdmin, pstmt, rs);
		}
		return aslist;
	}

	public String saveStatusOfArmory(int systemId,int customerId,int userId, String status,String jsonData) {
		Connection conAdmin=null;
		PreparedStatement pstmt=null;
		//ResultSet rs=null;
		
		try {
			conAdmin=DBConnection.getConnectionToDB("AMS");
			jsonData = jsonData.substring(0, jsonData.lastIndexOf(","));
			pstmt=conAdmin.prepareStatement(ArmoryStatements.UPDATE_ARMORY_ITEMS.replace("#", jsonData));
			pstmt.setInt(1, Integer.parseInt(status));
			pstmt.setInt(2, customerId);
			pstmt.setInt(3, systemId);
			
			int rs=pstmt.executeUpdate();
			  if (rs > 0) {
                  message = "Status Updated Successfully";
                  
              }else{
            	  message = "Status Not Updated Successfully";
              }
		} catch (SQLException e) {
			e.printStackTrace();
		}finally{
			DBConnection.releaseConnectionToDB(conAdmin, pstmt, null);
		}
		return message;
		
		
	}

	public ArrayList<Object> getPendingArmories(int systemId, int customerId, int userId) {
	JSONArray ServiceTypeJsonArray = new JSONArray();
	JSONObject ServiceTypeJsonObject = new JSONObject();
	Connection conAdmin=null;
	PreparedStatement pstmt=null;
	ResultSet rs=null;
	int count=0;
	String updatedate="";
	SimpleDateFormat sdf=new SimpleDateFormat("dd/MM/yyyy HH:mm");
	SimpleDateFormat sdf1=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	ArrayList<Object> informationList = new ArrayList<Object>();
	ArrayList < ReportHelper > reportsList = new ArrayList < ReportHelper > ();
	ArrayList < String > headersList = new ArrayList < String > ();
	ReportHelper finalreporthelper = new ReportHelper();
	ArrayList < Object > aslist = new ArrayList < Object > ();
	 JSONArray JsonArray = new JSONArray();
	 JSONObject JsonObject = null;
	
		conAdmin=DBConnection.getConnectionToDB("AMS");
		try {
			ServiceTypeJsonArray = new JSONArray();
			ServiceTypeJsonObject = new JSONObject();
			pstmt=conAdmin.prepareStatement(ArmoryStatements.GET_PENDING_ARMORIES);
			
			 headersList.add("SLNO");
			 headersList.add("TRIP NUMBER");
		     headersList.add("ASSET NAME");
		     headersList.add("ASSET NUMBER");
		     headersList.add("BRANCH");
		     headersList.add("CUSTOMER");
		     headersList.add("DATE");
			
			pstmt.setString(1, "PENDING");
			pstmt.setInt(2, systemId);
			pstmt.setInt(3, customerId);
			pstmt.setInt(4, systemId);
			pstmt.setInt(5, customerId);
			rs=pstmt.executeQuery();
			  while (rs.next()) {
				  
				  if(updatedate.equals("1900-01-01 00:00:00.0")){
					   	
					   	updatedate="";
					   	}
					   	else
					   	{
					   	
					   	updatedate =sdf.format(sdf1.parse(rs.getString("date")));
					   	}
				  int Count=++count;
				  JsonObject = new JSONObject();
				  informationList = new ArrayList<Object>();
				  ServiceTypeJsonObject = new JSONObject();
				  
					  JsonObject.put("slnoIndex",Count);
				  	  informationList.add(Count);
				  
				  JsonObject.put("tripNo", rs.getString("tripNo"));
				  informationList.add(rs.getString("tripNo"));
				  
				  JsonObject.put("assetName", rs.getString("assetName"));
				  informationList.add(rs.getString("assetName"));
				  
		            JsonObject.put("assetNo", rs.getString("assetNo"));
		            informationList.add(rs.getString("assetNo"));
		            
		            JsonObject.put("branchName", rs.getString("BranchName"));
		            informationList.add(rs.getString("branchName"));
		            
		            JsonObject.put("customerName", rs.getString("CustomerName"));
		            informationList.add(rs.getString("customerName"));
		            
		            JsonObject.put("date", rs.getString("date"));
		            informationList.add(rs.getString("date"));
		            
		            JsonArray.put(JsonObject);
				
		            ServiceTypeJsonArray.put(JsonObject);
		            ReportHelper reporthelper = new ReportHelper();
					reporthelper.setInformationList(informationList);
					reportsList.add(reporthelper);
			        }
			       
			        aslist.add(ServiceTypeJsonArray);
			        finalreporthelper.setReportsList(reportsList);
					finalreporthelper.setHeadersList(headersList);
					aslist.add(finalreporthelper);
				
				}
	 catch (Exception e) {			
			e.printStackTrace();
		} finally{
			DBConnection.releaseConnectionToDB(conAdmin, pstmt, rs);
		}
		return aslist;
	}
	public JSONArray getVaultInward(Integer systemId, Integer custId,String startDate,String endDate,int offset) {
		Connection conAdmin=null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		JSONArray JsonArray = new JSONArray();
		JSONObject JsonObject = null;
		int count = 0;
		SimpleDateFormat sdf=new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
		SimpleDateFormat sdf1=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		try {
			conAdmin=DBConnection.getConnectionToDB("AMS");
			pstmt=conAdmin.prepareStatement(ArmoryStatements.GET_VAULT_INWARD);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, custId);
			pstmt.setString(3, startDate);
			pstmt.setString(4, endDate);
			rs=pstmt.executeQuery();
			  while (rs.next()) {
				  count++;
				  JsonObject = new JSONObject();
			  	  JsonObject.put("slnoDataIndex", count);
			  	  JsonObject.put("inwardModeDataIndex", rs.getString("INWARD_MODE"));
				  JsonObject.put("cashTypeDataIndex", rs.getString("CASH_TYPE"));
				  JsonObject.put("TripSheetNoDataIndex", rs.getString("TRIP_SHEET_NO"));
				  JsonObject.put("inwardIdDataIndex", rs.getString("INWARD_ID"));
				  JsonObject.put("customernameindex", rs.getString("CustomerName"));
				  JsonObject.put("cvsCustIdDataIndex", rs.getInt("CVS_CUST_ID"));
				  
				  String date = rs.getString("INWARD_DATE");
				  if(rs.getString("INWARD_DATE")!= null && !rs.getString("INWARD_DATE").equals("") && !rs.getString("INWARD_DATE").contains("1900-01-01")){
			    		date =sdf.format(sdf1.parse(rs.getString("INWARD_DATE")));
				  }else{
				  date = "";
				  }		 
				  JsonObject.put("dateindex", date);
				  String slNo = "";
				  if(rs.getString("CASH_TYPE").equals("CASH")){
					  slNo =  rs.getString("CASH_SEAL_NO");  
				  }else{
					  slNo =  rs.getString("SEAL_NO");  
				  }
				  
				  JsonObject.put("sealnumberindex", slNo);
				  JsonObject.put("totalamountindex", rs.getString("TOTAL_AMOUNT"));
				  JsonArray.put(JsonObject);
			}
                 
		}catch (Exception e) {			
			e.printStackTrace();
		}finally{
			DBConnection.releaseConnectionToDB(conAdmin, pstmt, rs);
		}
		return JsonArray;
	}
	public JSONArray getCustomerName(Integer systemId, Integer custId) {
		Connection conAdmin=null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		JSONArray JsonArray = new JSONArray();
		JSONObject JsonObject = null;
		
		try {
			conAdmin=DBConnection.getConnectionToDB("LMS");
			pstmt=conAdmin.prepareStatement(ArmoryStatements.GET_CUSTOMER_NAME );
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, custId);
			rs=pstmt.executeQuery();
			  while (rs.next()) {
				  
				  JsonObject = new JSONObject();
			  	 
				  JsonObject.put("custId", rs.getString("CustomerId"));
				  JsonObject.put("CustName", rs.getString("CustomerName"));
				  
				  JsonArray.put(JsonObject);
			}
                 
		}catch (Exception e) {			
			e.printStackTrace();
		}finally{
			DBConnection.releaseConnectionToDB(conAdmin, pstmt, rs);
		}
		return JsonArray;
	}


	public JSONArray getArmoryAndStationaryItems(int systemId, int customerId) {

		Connection conAdmin=null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		 JSONArray JsonArray = new JSONArray();
		 JSONObject JsonObject = null;
		conAdmin=DBConnection.getConnectionToDB("AMS");
		try {
			pstmt=conAdmin.prepareStatement(ArmoryStatements.GET_ARMORY_STATIONARY_ITEMS);
			
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, customerId);
			rs=pstmt.executeQuery();
			  while (rs.next()) {
				  JsonObject = new JSONObject();
				  JsonObject.put("itemId", rs.getString("Id"));
		            JsonObject.put("itemName", rs.getString("ITEM_NAME"));
		            JsonObject.put("type", rs.getString("ASSET_TYPE"));
		            JsonArray.put(JsonObject);
				
			}
                 
                  
             
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (JSONException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}finally{
			DBConnection.releaseConnectionToDB(conAdmin, pstmt, rs);
		}
		return JsonArray;
	
	}
}


