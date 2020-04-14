package t4u.functions;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;


import org.json.JSONArray;
import org.json.JSONObject;


import t4u.common.LocationLocalization;

import t4u.beans.ReportHelper;
import t4u.common.DBConnection;
import t4u.statements.WastemanagementStatements;

/**
 * 
 * This class is used to write sql related functions of waste management module
 *
 */
public class WastemanagementFunctions {
	SimpleDateFormat sdfddmmyy=new SimpleDateFormat("dd-MM-yyyy");
	SimpleDateFormat sdfddmmyyhhmmss=new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
	SimpleDateFormat sdfyyyymmddhhmmss=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	CommonFunctions cf = new CommonFunctions();
	LocationLocalization locationLocalization = new LocationLocalization();

	
	/**
	 * To fetch trader id and name from database
	 * @param SystemId
	 * @param CustomerId
	 * @return
	 */
	public JSONArray getTrader(int SystemId,String CustomerId){
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject = new JSONObject();
		Connection conAms=null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		try{
			jsonArray = new JSONArray();
			jsonObject = new JSONObject();
			
			conAms=DBConnection.getConnectionToDB("AMS");
			
			pstmt=conAms.prepareStatement(WastemanagementStatements.GET_TRADER);
			pstmt.setInt(1, SystemId);
			pstmt.setString(2, CustomerId);
			rs=pstmt.executeQuery();
			while(rs.next()){
				jsonObject = new JSONObject();
				int traderId=rs.getInt("ID");
				String traderName=rs.getString("LICENCE_HOLDER_NAME");
				jsonObject.put("TraderId", traderId);
				jsonObject.put("TraderName", traderName);
				jsonArray.put(jsonObject);				
			}
		}catch(Exception e){
			System.out.println("Error in getTrader "+e.toString());
		}	
		finally{
			DBConnection.releaseConnectionToDB(conAms, pstmt, rs);
		}	
		return jsonArray;
	}
	
	/**
	 * Fetching Trader details from database
	 * @param SystemId
	 * @param CustomerId
	 * @param TraderId
	 * @return
	 */
	public JSONArray getTraderDetails(int SystemId,String CustomerId,String TraderId){
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject = new JSONObject();
		Connection conAms=null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		try{
			jsonArray = new JSONArray();
			jsonObject = new JSONObject();
			
			conAms=DBConnection.getConnectionToDB("AMS");
			
			pstmt=conAms.prepareStatement(WastemanagementStatements.GET_TRADER_DETAILS);
			pstmt.setInt(1, SystemId);
			pstmt.setString(2, CustomerId);
			pstmt.setString(3, TraderId);
			rs=pstmt.executeQuery();
			if(rs.next()){
				jsonObject = new JSONObject();
				String Licence_No="";
				if(rs.getString("LICENCE_NO")!=null){
					Licence_No=rs.getString("LICENCE_NO");
				}
				jsonObject.put("Licence_No", Licence_No);
				
				String Address="";
				if(rs.getString("ADDRESS")!=null){
					Address=rs.getString("ADDRESS");
				}
				jsonObject.put("Address", Address);
				
				String Trade="";
				if(rs.getString("TRADE")!=null){
					Trade=rs.getString("TRADE");
				}
				jsonObject.put("Trade", Trade);
				
				String Trade_Name="";
				if(rs.getString("TRADE_NAME")!=null){
					Trade_Name=rs.getString("TRADE_NAME");
				}
				jsonObject.put("Trade_Name", Trade_Name);
				
				String Door_No="";
				if(rs.getString("DOOR_NO")!=null){
					Door_No=rs.getString("DOOR_NO");
				}
				jsonObject.put("Door_No", Door_No);
				
				String Ward_Name="";
				if(rs.getString("WARD_NAME")!=null){
					Ward_Name=rs.getString("WARD_NAME");
				}
				jsonObject.put("Ward_Name", Ward_Name);
				
				String Ward_No="";
				if(rs.getString("WARD_NO")!=null){
					Ward_No=rs.getString("WARD_NO");
				}
				jsonObject.put("Ward_No", Ward_No);
				
				String Area="";
				if(rs.getString("AREA")!=null){
					Area=rs.getString("AREA");
				}
				jsonObject.put("Area", Area);
				
				String Mobile_No="";
				if(rs.getString("MOBILE_NO")!=null){
					Mobile_No=rs.getString("MOBILE_NO");
				}
				jsonObject.put("Mobile_No", Mobile_No);
				
				String Rfid_Code="";
				if(rs.getString("RFID_CODE")!=null){
					Rfid_Code=rs.getString("RFID_CODE");
				}
				jsonObject.put("Rfid_Code", Rfid_Code);
				
				String Status="";
				if(rs.getString("STATUS")!=null){
					Status=rs.getString("STATUS");
				}
				jsonObject.put("Status", Status);				
				
				jsonArray.put(jsonObject);				
			}
		}catch(Exception e){
			System.out.println("Error in getTraderdetails "+e.toString());
		}	
		finally{
			DBConnection.releaseConnectionToDB(conAms, pstmt, rs);
		}	
		return jsonArray;
	}
	
	/**
	 * saving or updating trader master details in database 
	 * @param systemId
	 * @param createdUser
	 * @param buttonValue
	 * @param custId
	 * @param tradername
	 * @param newtradername
	 * @param licno
	 * @param address
	 * @param trade
	 * @param tradename
	 * @param doorno
	 * @param wardname
	 * @param wardno
	 * @param area
	 * @param mobile
	 * @param rfidcode
	 * @param status
	 * @return
	 */
	public String saveTraderDetails(int systemId,int createdUser,String buttonValue,String custId,String tradername,String newtradername,String licno,String address,String trade,String tradename,String doorno,String wardname,String wardno,String area,String mobile,String rfidcode,String status){
		String message="";
		Connection conAms=null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		try{
			conAms=DBConnection.getConnectionToDB("AMS");
			if(buttonValue.equals("add")){
			pstmt=conAms.prepareStatement(WastemanagementStatements.SAVE_TRADER);
			pstmt.setString(1, tradername);
			pstmt.setString(2, licno);
			pstmt.setString(3, address);
			pstmt.setString(4, trade);
			pstmt.setString(5, tradename);
			pstmt.setString(6, doorno);
			pstmt.setString(7, wardname);
			pstmt.setString(8, wardno);
			pstmt.setString(9, area);
			pstmt.setString(10, mobile);
			pstmt.setString(11, rfidcode);
			pstmt.setString(12, status);
			pstmt.setInt(13,systemId);
			pstmt.setString(14, custId);
			pstmt.setInt(15, createdUser);
			int i=pstmt.executeUpdate();
			if(i>0){
				 message="saved successfully";
			}else{
				 message="error";
			}
			}else if(buttonValue.equals("modify")){
				pstmt=conAms.prepareStatement(WastemanagementStatements.UPDATE_TRADER);
				pstmt.setString(1, newtradername);
				pstmt.setString(2, licno);
				pstmt.setString(3, address);
				pstmt.setString(4, trade);
				pstmt.setString(5, tradename);
				pstmt.setString(6, doorno);
				pstmt.setString(7, wardname);
				pstmt.setString(8, wardno);
				pstmt.setString(9, area);
				pstmt.setString(10, mobile);
				pstmt.setString(11, rfidcode);
				pstmt.setString(12, status);
				pstmt.setInt(13,systemId);
				pstmt.setString(14, custId);
				pstmt.setString(15, tradername);
				int i=pstmt.executeUpdate();
				if(i>0){
					 message="Updated Successfully";
				}else{
					 message="error";
				}
			}			
		}catch(Exception e){
			System.out.println("error in save trader details "+e.toString());
			message="error";
		}
		finally{
			DBConnection.releaseConnectionToDB(conAms, pstmt, rs);
		}		
		return message;
	}
	
	/**
	 * deletes the trader details from database
	 * @param systemId
	 * @param CustId
	 * @param TraderId
	 * @return
	 */
	public String deleteTraderDetails(int systemId,String CustId,String TraderId){
		String message="";
		Connection conAms=null;
		PreparedStatement pstmt=null;
		try {
			conAms=DBConnection.getConnectionToDB("AMS");
			pstmt=conAms.prepareStatement(WastemanagementStatements.DELETE_TRADER);
			pstmt.setInt(1, systemId);
			pstmt.setString(2, CustId);
			pstmt.setString(3, TraderId);
			int del=pstmt.executeUpdate();
			if(del>0){
				message="Deleted Successfully";
			}else{
				 message="Error";
			}			
		} catch (Exception e) {
			System.out.println("Exception in deleteTraderDetails "+e.toString());
			message="error";
		}
		finally{
			DBConnection.releaseConnectionToDB(conAms, pstmt, null);
		}
		return message;		
	}
	
	/**
	 * Fetching Daily Attendance Report data from database 
	 * @param systemId
	 * @param customerId
	 * @param startDate
	 * @param endDate
	 * @param language
	 * @return
	 */
	public ArrayList<Object> getDailyAttendanceReport(int systemId,String customerId,String startDate,String endDate,String language,int userId){
		
		 ArrayList<ReportHelper> reportsList = new ArrayList<ReportHelper>();
		 ArrayList<String> headersList = new ArrayList<String>();
		 ReportHelper finalreporthelper = new ReportHelper();
		 ArrayList<Object> finlist = new ArrayList<Object>();
		 
		 headersList.add(cf.getLabelFromDB("SLNO",language));
		 headersList.add(cf.getLabelFromDB("Date",language));
		 headersList.add(cf.getLabelFromDB("Registration_No",language));
		 headersList.add(cf.getLabelFromDB("Trade_Name",language));
		 headersList.add(cf.getLabelFromDB("Licence_holder_name",language));
		 headersList.add(cf.getLabelFromDB("Swipe_Location",language));
		 headersList.add(cf.getLabelFromDB("Mobile_No",language));
		 headersList.add(cf.getLabelFromDB("Ward_Name",language));
		 headersList.add(cf.getLabelFromDB("Ward_No",language));
		 headersList.add(cf.getLabelFromDB("Swipe_Date",language));
	
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject = new JSONObject();
		Connection conAms=null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		int count = 0;
		try{
			jsonArray = new JSONArray();
			jsonObject = new JSONObject();
			
			conAms=DBConnection.getConnectionToDB("AMS");
			
			startDate=startDate.replaceAll("T", " ");
			
			endDate=endDate.replaceAll("T", " ");
			
			pstmt=conAms.prepareStatement(WastemanagementStatements.GET_DAILY_ATTENDANCE_REPORT_DATA);
			pstmt.setInt(1, systemId);
			pstmt.setString(2, customerId);
			pstmt.setString(3, startDate);
			pstmt.setString(4,endDate);
			pstmt.setInt(5, userId);
			rs=pstmt.executeQuery();
			
			while(rs.next()){
				jsonObject = new JSONObject();
				ArrayList<String> informationList=new ArrayList<String>();
				ReportHelper reporthelper=new ReportHelper();
				count++;
				 
				informationList.add(Integer.toString(count));
				jsonObject.put("slnoIndex", Integer.toString(count));
			
				String date="";
				if(rs.getString("date")!=null || rs.getString("date").contains("1900-01-01")){
					Date dd=rs.getDate("date");
					date=sdfddmmyy.format(dd);
				}
				jsonObject.put("Date", date);
				informationList.add(date);
				
				
				String REGISTRATION_NO=rs.getString("REGISTRATION_NO");				
				jsonObject.put("VehicleNo", REGISTRATION_NO);
				informationList.add(REGISTRATION_NO);
				
				String Trade_Name="";
				if(rs.getString("TRADE_NAME")!=null){
					Trade_Name=rs.getString("TRADE_NAME");
				}
				jsonObject.put("TradeName", Trade_Name);
				informationList.add(Trade_Name);
				
				String LICENCE_HOLDER_NAME="";
				if(rs.getString("LICENCE_HOLDER_NAME")!=null){
					LICENCE_HOLDER_NAME=rs.getString("LICENCE_HOLDER_NAME");
				}
				jsonObject.put("LicenceHolderName", LICENCE_HOLDER_NAME);
				informationList.add(LICENCE_HOLDER_NAME);
				
				String LOCATION="";
				if(rs.getString("LOCATION")!=null){
					LOCATION=rs.getString("LOCATION");
				}
				jsonObject.put("SwipeLocation", LOCATION);
				informationList.add(LOCATION);
				
				String MOBILE_NO="";
				if(rs.getString("MOBILE_NO")!=null){
					MOBILE_NO=rs.getString("MOBILE_NO");
				}
				jsonObject.put("MobileNo", MOBILE_NO);
				informationList.add(MOBILE_NO);
				
				
				String WARD_NAME="";
				if(rs.getString("WARD_NAME")!=null){
					WARD_NAME=rs.getString("WARD_NAME");
				}
				jsonObject.put("WardName", WARD_NAME);
				informationList.add(WARD_NAME);
				
				String WARD_NO="";
				if(rs.getString("WARD_NO")!=null){
					WARD_NO=rs.getString("WARD_NO");
				}
				jsonObject.put("WardNo", WARD_NO);
				informationList.add(WARD_NO);
				
				String GMT="";
				if(rs.getString("GMT")!=null || rs.getString("GMT").contains("1900-01-01")){
					Date dd1=rs.getTimestamp("GMT");
					GMT=sdfddmmyyhhmmss.format(dd1);
				}
				jsonObject.put("SwipeDate", GMT);
				informationList.add(GMT);				
				
				jsonArray.put(jsonObject);
				reporthelper.setInformationList(informationList);  
				reportsList.add(reporthelper);
			}
			finlist.add(jsonArray);
		    finalreporthelper.setReportsList(reportsList);
			finalreporthelper.setHeadersList(headersList);
			finlist.add(finalreporthelper);
		}catch(Exception e){
			System.out.println("Error in getDailyAttendanceReport "+e.toString());
		}	
		finally{
			DBConnection.releaseConnectionToDB(conAms, pstmt, rs);
		}	
		return finlist;
	}
	
	public JSONArray getAssetTypeDetails(int systemId, int customerId, int userId) {
	    JSONArray JsonArray = null;
	    JSONObject JsonObject = null;

	    Connection con = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;

	    int count = 0;

	    try {
	        JsonArray = new JSONArray();

	        con = DBConnection.getConnectionToDB("AMS");

	        pstmt = con.prepareStatement(WastemanagementStatements.GET_ASSET_TYPE);
	        pstmt.setInt(1, customerId);
	        pstmt.setInt(2, systemId);
	        pstmt.setInt(3, userId);
	        rs = pstmt.executeQuery();
	        while (rs.next()) {
	            count++;

	            JsonObject = new JSONObject();

	           // JsonObject.put("slnoIndex", count);
	            JsonObject.put("AssetType", rs.getString("VehicleType"));
	          //  JsonObject.put("assetnumber", rs.getString("REGISTRATION_NUMBER"));

	            JsonArray.put(JsonObject);
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	        DBConnection.releaseConnectionToDB(con, pstmt, rs);
	    }
	    return JsonArray;
	}
	
	public JSONArray getAssetNumberDetails(int systemId, int customerId, int userId, String assettype) {
	    JSONArray JsonArray = null;
	    JSONObject JsonObject = null;

	    Connection con = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;

	    int count = 0;

	    try {
	        JsonArray = new JSONArray();

	        con = DBConnection.getConnectionToDB("AMS");

	        pstmt = con.prepareStatement(WastemanagementStatements.GET_ASSET_NUMBER);
	        pstmt.setInt(1, customerId);
	        pstmt.setInt(2, systemId);
	        pstmt.setInt(3, userId);
	        pstmt.setString(4, assettype);
	        rs = pstmt.executeQuery();
	        while (rs.next()) {
	            count++;

	            JsonObject = new JSONObject();

	            JsonObject.put("slnoIndex", count);
	          //  JsonObject.put("AssetType", rs.getString("ModelName"));
	            JsonObject.put("assetnumber", rs.getString("REGISTRATION_NUMBER"));

	            JsonArray.put(JsonObject);
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	        DBConnection.releaseConnectionToDB(con, pstmt, rs);
	    }
	    return JsonArray;
	}

	public ArrayList<Object> getSweepingOperationSummaryReportDetails(JSONArray firstGridData,
			String startdate, String enddate, int offset, String language,
			int systemId,int custid)
			{
		JSONArray SweepingManagementJsonArray = new JSONArray();
		JSONObject SweepingManagementJsonObject = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		DecimalFormat decformat = new DecimalFormat("#0.00");
		ArrayList<ReportHelper> reportsList = new ArrayList<ReportHelper>();
		ArrayList<String> headersList = new ArrayList<String>();
		ReportHelper finalreporthelper = new ReportHelper();
		ArrayList<Object> finlist = new ArrayList<Object>();
		headersList.add(cf.getLabelFromDB("SLNO", language));
		headersList.add(cf.getLabelFromDB("Asset_Number", language));
		headersList.add(cf.getLabelFromDB("Date", language));
		headersList.add(cf.getLabelFromDB("Asset_Group", language));
		headersList.add(cf.getLabelFromDB("Total_Running_Time(HH:MM)", language));
		headersList.add(cf.getLabelFromDB("Total_Brush_Time(HH:MM)", language));
		
		try {
			SweepingManagementJsonArray = new JSONArray();
			SweepingManagementJsonObject = new JSONObject();
			con = DBConnection.getConnectionToDB("AMS");
			if (startdate.contains("T")) {
				startdate = startdate.substring(0,startdate.indexOf("T"));
				startdate = startdate+" 00:00:00";
			}else{
				startdate = startdate.substring(0,startdate.indexOf(" "));
				startdate = startdate+" 00:00:00";
			}
			
			if (enddate.contains("T")) {
				enddate = enddate.substring(0,enddate.indexOf("T"));
				enddate = enddate+" 00:00:00";
			}else{
				enddate = enddate.substring(0,enddate.indexOf(" "));
				enddate = enddate+" 00:00:00";
			}
			String assetnos = "";
			for (int i = 0; i < firstGridData.length(); i++) {
				JSONObject obj = firstGridData.getJSONObject(i);
				assetnos = assetnos+",'"+obj.getString("assetnumber")+"'";
			}
			if (assetnos.length()>0) {
				assetnos = assetnos.substring(1,assetnos.length());
			}
			pstmt = con.prepareStatement(WastemanagementStatements.GET_SWEEPING_MANAGEMENT_REPORT.replace("#", assetnos));
			pstmt.setInt(1, offset);
			pstmt.setInt(2, systemId);
			pstmt.setInt(3, custid);
			pstmt.setInt(4, offset);
			pstmt.setString(5, startdate);
			pstmt.setInt(6, offset);
			pstmt.setString(7, enddate);
			
			rs = pstmt.executeQuery();
			int count = 0;
			while (rs.next()) {
				SweepingManagementJsonObject = new JSONObject();
				ArrayList<String> informationList = new ArrayList<String>();
				ReportHelper reporthelper = new ReportHelper();
				count++;

				informationList.add(Integer.toString(count));
				SweepingManagementJsonObject.put("slnoIndex1", Integer.toString(count));
				
				Date Date = rs.getTimestamp("Date");
				String Asset_Number = rs.getString("Asset_Number");
				float TotalRunningTime = rs.getFloat("TotalRunningTime");
				float TotalBrushTime = rs.getFloat("TotalBrushTime");
				
				SweepingManagementJsonObject.put("registrationNo", Asset_Number);
				informationList.add(Asset_Number);
				
				SweepingManagementJsonObject.put("date",  sdfddmmyy.format(Date));
				informationList.add(sdfddmmyy.format(Date));
				
				String Asset_Group = LocationLocalization.getLocationLocalization(rs.getString("Asset_Group"), language);				
				SweepingManagementJsonObject.put("assetGroupDataindex", Asset_Group);
				informationList.add(Asset_Group);
				
				int enginepmh = (int) (TotalRunningTime * 60);// min

				String engineHrsFormated = enginepmh > 0 ? convertMinutesToHHMMFormat(enginepmh): "0.0";
				
					
				SweepingManagementJsonObject.put("totalrunningtime", engineHrsFormated);
				informationList.add(engineHrsFormated);
				
				SweepingManagementJsonObject.put("totalbrushtime", decformat.format(TotalBrushTime));
				informationList.add(decformat.format(TotalBrushTime));
				
				SweepingManagementJsonArray.put(SweepingManagementJsonObject);
				reporthelper.setInformationList(informationList);
				reportsList.add(reporthelper);
			}
			finlist.add(SweepingManagementJsonArray);
			finalreporthelper.setReportsList(reportsList);
			finalreporthelper.setHeadersList(headersList);
			finlist.add(finalreporthelper);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}

		return finlist;
	}
	
	public ArrayList<Object> getWasteManagementReport(JSONArray firstGridData,
		String startdate, String enddate, int offset, String language,
			int systemId,int custid) {
		
		
		JSONArray SweepingManagementJsonArray = new JSONArray();
		JSONObject SweepingManagementJsonObject = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		DecimalFormat decformat = new DecimalFormat("#0.00");
		
		ArrayList<ReportHelper> reportsList = new ArrayList<ReportHelper>();
		ArrayList<String> headersList = new ArrayList<String>();
		ReportHelper finalreporthelper = new ReportHelper();
		ArrayList<Object> finlist = new ArrayList<Object>();
		headersList.add(cf.getLabelFromDB("SLNO", language));
		headersList.add(cf.getLabelFromDB("Asset_Number", language));
		headersList.add(cf.getLabelFromDB("Date", language));
	    headersList.add(cf.getLabelFromDB("Asset_Group", language));
		headersList.add(cf.getLabelFromDB("Total_Running_Time", language));
		headersList.add(cf.getLabelFromDB("Total_Weight_Carried", language));
		headersList.add("ID");
		
		try {
			
			if (startdate.contains("T")) {
				startdate = startdate.substring(0,startdate.indexOf("T"));
				startdate = startdate+" 12:00:00";
			}else{
				startdate = startdate.substring(0,startdate.indexOf(" "));
				startdate = startdate+" 12:00:00";
			}
			
			if (enddate.contains("T")) {
				enddate = enddate.substring(0,enddate.indexOf("T"));
				enddate = enddate+" 12:00:00";
			}else{
				enddate = enddate.substring(0,enddate.indexOf(" "));
				enddate = enddate+" 12:00:00";
			}
			SweepingManagementJsonArray = new JSONArray();
			SweepingManagementJsonObject = new JSONObject();
			con = DBConnection.getConnectionToDB("AMS");
			String assetnos = "";
			for (int i = 0; i < firstGridData.length(); i++) {
				JSONObject obj = firstGridData.getJSONObject(i);
				assetnos = assetnos+",'"+obj.getString("assetnumber")+"'";
			}
			if (assetnos.length()>0) {
				assetnos = assetnos.substring(1,assetnos.length());
			}
			
			pstmt = con.prepareStatement(WastemanagementStatements.GET_WASTE_MANAGEMENT_REPORT.replace("#", assetnos));
			pstmt.setInt(1, offset);
			pstmt.setInt(2, offset);
			pstmt.setString(3, startdate);
			pstmt.setInt(4, offset);
			pstmt.setString(5, enddate);
			
			rs = pstmt.executeQuery();
			int count = 0;
			while (rs.next()) {
				SweepingManagementJsonObject = new JSONObject();
				ArrayList<String> informationList = new ArrayList<String>();
				ReportHelper reporthelper = new ReportHelper();
				count++;
				
				Date Date = rs.getTimestamp("Date");
				String Asset_Number = rs.getString("Asset_Number");
				float TotalRunningTime = rs.getFloat("TotalRunningTime");
				float TotalWeightCarried = rs.getFloat("TotalWeightCarried");

				informationList.add(Integer.toString(count));
				SweepingManagementJsonObject.put("slnoIndex1", Integer.toString(count));
				
				SweepingManagementJsonObject.put("registrationNoDataIndex", Asset_Number);
				informationList.add(Asset_Number);
				
				SweepingManagementJsonObject.put("dateDataIndex", sdfddmmyy.format(Date));
				informationList.add(sdfddmmyy.format(Date));

				String assetgroup = LocationLocalization.getLocationLocalization(rs.getString("Asset_Group"), language);
				SweepingManagementJsonObject.put("assetGroupDataIndex", assetgroup);
				informationList.add(assetgroup);

				SweepingManagementJsonObject.put("totalRunningTimeDataIndex", decformat.format(TotalRunningTime));
				informationList.add(decformat.format(TotalRunningTime));

				SweepingManagementJsonObject.put("totalWeightCarriedDataIndex", decformat.format(TotalWeightCarried));
				informationList.add(decformat.format(TotalWeightCarried));

				SweepingManagementJsonObject.put("uniqueIdDataIndex", rs.getString("Id"));
				informationList.add(rs.getString("Id"));

				SweepingManagementJsonArray.put(SweepingManagementJsonObject);
				reporthelper.setInformationList(informationList);
				reportsList.add(reporthelper);
			}
			finlist.add(SweepingManagementJsonArray);
			finalreporthelper.setReportsList(reportsList);
			finalreporthelper.setHeadersList(headersList);
			finlist.add(finalreporthelper);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}

		return finlist;
	}
	
	public String modifywasteManagementInformation(int uniqueId,String totalWeightCarried,String remarks,int userId) {
	    Connection con = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
	    String message = "";
	    try {
	        con = DBConnection.getConnectionToDB("ADMINISTRATOR");
	        
	        pstmt = con.prepareStatement(WastemanagementStatements.UPDATE_WASTE_INFORMATION_INFORMATION);
	        pstmt.setString(1, totalWeightCarried);
            pstmt.setInt(2, uniqueId);
		   int updated = pstmt.executeUpdate();
	        if (updated > 0) {
	        	 pstmt = con.prepareStatement(WastemanagementStatements.INSERT_REMARKS_INTO_SUMMARY_HISTORY);
	        	 pstmt.setString(1, remarks);
	        	 pstmt.setInt(2, userId);
	        	 pstmt.setInt(3, uniqueId);
	        	 pstmt.executeUpdate();
	             message = "Updated Successfully";
	        }
	       
	    } catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	        DBConnection.releaseConnectionToDB(con, pstmt, rs);
	    }
	    return message;
	}						

	
	

	/**
	* coverts minutes into HH:MM format
	* @param minutes
	* @return
	*/
	public String convertMinutesToHHMMFormat(int minutes)
	{
	String duration="0.0";

	long durationHrslong = minutes / 60;
	String durationHrs = String.valueOf(durationHrslong);
	if(durationHrs.length()==1)
	{
	durationHrs = "0"+ durationHrs;
	}

	long durationMinsLong = minutes % 60;
	String durationMins = String.valueOf(durationMinsLong);
	if(durationMins.length()==1)
	{
	durationMins = "0"+ durationMins;
	}

	duration = durationHrs + "." + durationMins;

	return duration;
	}
	
	
}
