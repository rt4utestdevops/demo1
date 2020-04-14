package t4u.functions;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
//import java.sql.Timestamp;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
//import java.util.TreeMap;
//import java.util.Map.Entry;

//import com.mysql.jdbc.*;
import org.json.JSONArray;
import org.json.JSONObject;

import t4u.beans.MarineVesselBean;
import t4u.beans.ReportHelper;
import t4u.common.DBConnection;
import t4u.statements.CommonStatements;
import t4u.statements.MarineVesselStatements;

public class MarineVesselFunctions {
	
	MarineVesselStatements marineStatements = new MarineVesselStatements();
	CommonFunctions commonFunctions = new CommonFunctions();
	static MarineVesselBean marineVesselBean = new MarineVesselBean();
	
	SimpleDateFormat ddMMYYYYHHMMSS = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
	SimpleDateFormat ddMMYYYY = new SimpleDateFormat("dd-MM-yyyy");
	SimpleDateFormat yyyyMMddHHMMSS = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

	DecimalFormat df = new DecimalFormat("00.##");

	public JSONArray getMarineVesselDetails(int systemId, int customerId, int userId) {
		JSONArray marineVesselJsonArray = null;
		JSONObject marineVesselJsonObject = null;
				
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		int count = 0;
			
		try {
			marineVesselJsonArray = new JSONArray();
			
			con = DBConnection.getConnectionToDB("AMS");
			
			pstmt = con.prepareStatement(marineStatements.GET_MARINE_VESSEL);
			pstmt.setInt(1, customerId);
			pstmt.setInt(2, systemId);
			pstmt.setInt(3, userId);
			rs = pstmt.executeQuery();
			while (rs.next()) {					
				count++;	
												
				marineVesselJsonObject = new JSONObject();
				
				marineVesselJsonObject.put("slnoIndex", count);	
				marineVesselJsonObject.put("vesselId", rs.getString("VEHICLE_ID"));	
				marineVesselJsonObject.put("vesselName", rs.getString("REGISTRATION_NUMBER"));		

				marineVesselJsonArray.put(marineVesselJsonObject);			
			}			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return marineVesselJsonArray;
	}

	public JSONArray getMarineLiveInformation(int systemId, int customerId, int userId, String assetNumber) {
		JSONArray marineLiveInfoJsonArray = null;
		JSONObject marineLiveInfoJsonObject = null;
				
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
			
		try {
			marineLiveInfoJsonArray = new JSONArray();
			
			con = DBConnection.getConnectionToDB("AMS");
			
			pstmt = con.prepareStatement(marineStatements.GET_MARINE_LIVE_INFORMATION);
			pstmt.setString(1, assetNumber);
			pstmt.setInt(2, systemId);
			pstmt.setInt(3, customerId);

			rs = pstmt.executeQuery();
			if (rs.next()) {																
				marineLiveInfoJsonObject = new JSONObject();

				marineLiveInfoJsonObject.put("GroupName", rs.getString("GROUP_NAME"));	
				marineLiveInfoJsonObject.put("LastCommunicatedTime", ddMMYYYYHHMMSS.format(rs.getTimestamp("GPS_DATETIME")));

				if(rs.getDouble("LATITUDE") == 0){
					marineLiveInfoJsonObject.put("Latitude", "N/A");	
				} else {
					marineLiveInfoJsonObject.put("Latitude", rs.getDouble("LATITUDE"));	
				}				
				if(rs.getDouble("LONGITUDE") == 0){
					marineLiveInfoJsonObject.put("Longitude", "N/A");	
				} else {
					marineLiveInfoJsonObject.put("Longitude", rs.getDouble("LONGITUDE"));	
				}	
				marineLiveInfoJsonObject.put("DriverName", rs.getString("DRIVER_NAME"));
				marineLiveInfoJsonObject.put("DriverNumber", rs.getString("DRIVER_NUMBER"));	
				marineLiveInfoJsonObject.put("OwnerName", rs.getString("OWNER_NAME"));	
				marineLiveInfoJsonObject.put("OwnerNumber", rs.getString("OWNER_NUMBER"));	
				marineLiveInfoJsonObject.put("OwnerNumber", rs.getString("OWNER_NUMBER"));
				
				Date lastCommunicatedDate = ddMMYYYYHHMMSS.parse(ddMMYYYYHHMMSS.format(rs.getTimestamp("GPS_DATETIME")));				
				Date currentDate = new Date();
				String communicationStatus= "Non Communicating";
				if(currentDate.getTime() - lastCommunicatedDate.getTime() < 6 * 3600 * 1000){
					communicationStatus = "Communicating";
				}				
				marineLiveInfoJsonObject.put("Communication", communicationStatus);

				marineLiveInfoJsonArray.put(marineLiveInfoJsonObject);				
			}			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return marineLiveInfoJsonArray;
	}

	public ArrayList<Object> getMarineLiveDetailsBasedOnProximity(int systemId, int customerId, String assetNumber, int proximityValue, int userId, String language) {
		JSONArray marineLiveInfoJsonArray = null;
		JSONObject marineLiveInfoJsonObject = null;
		
		ArrayList<ReportHelper> marineLiveList = new ArrayList<ReportHelper>();
		ArrayList<String> marineLiveHeadersList = new ArrayList<String>();
		ReportHelper finalreporthelper = new ReportHelper();
		ArrayList<Object> marineLiveFinalList = new ArrayList<Object>();
				
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		int count = 0;
		double vehicleLatitude = 0.0;
		double vehicleLongitude = 0.0;
		
		marineLiveHeadersList.add(commonFunctions.getLabelFromDB("SLNO", language));
		marineLiveHeadersList.add(commonFunctions.getLabelFromDB("Vessel_ID", language));
		marineLiveHeadersList.add(commonFunctions.getLabelFromDB("Vessel_Name", language));
		marineLiveHeadersList.add(commonFunctions.getLabelFromDB("Distance", language));
		marineLiveHeadersList.add(commonFunctions.getLabelFromDB("Speed_Nauticle", language));
		marineLiveHeadersList.add(commonFunctions.getLabelFromDB("Group_Name", language));
		marineLiveHeadersList.add(commonFunctions.getLabelFromDB("Driver_Name", language));
		marineLiveHeadersList.add(commonFunctions.getLabelFromDB("Owner_Name", language));
		marineLiveHeadersList.add(commonFunctions.getLabelFromDB("Latitude", language));
		marineLiveHeadersList.add(commonFunctions.getLabelFromDB("Longitude", language));

		try {
			marineLiveInfoJsonArray = new JSONArray();
			
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(marineStatements.GET_LIVE_VEHICLE_DATA);
			pstmt.setString(1, assetNumber);
			pstmt.setInt(2, systemId);
			pstmt.setInt(3, customerId);
			rs = pstmt.executeQuery();
			if(rs.next()){
				vehicleLatitude = rs.getDouble("LATITUDE");
				vehicleLongitude = rs.getDouble("LONGITUDE");
			}
			pstmt.close();
			rs.close();
			
			if(vehicleLatitude > 0 && vehicleLongitude > 0){
								
				pstmt = con.prepareStatement(marineStatements.GET_OTHER_ASSET_LIVE_DATA);
				pstmt.setString(1, assetNumber);
				pstmt.setInt(2, systemId);
				pstmt.setInt(3, customerId);		
				pstmt.setInt(4, userId);
				rs = pstmt.executeQuery();
				while (rs.next()) {
					
					try {
						double distance = commonFunctions.distanceCalculate(vehicleLongitude, vehicleLatitude, rs.getDouble("LONGITUDE"), rs.getDouble("LATITUDE"));
						
						if(distance <= proximityValue){
							count++;
							ArrayList<Object> informationList = new ArrayList<Object>();
							ReportHelper reporthelper = new ReportHelper();
							
							marineLiveInfoJsonObject = new JSONObject();
							
							marineLiveInfoJsonObject.put("slnoIndex", count);	
							informationList.add(count);
							
							marineLiveInfoJsonObject.put("vesselId", rs.getString("VEHICLE_ID"));	
							informationList.add(rs.getString("VEHICLE_ID"));
							
							marineLiveInfoJsonObject.put("vesselName", rs.getString("REGISTRATION_NO"));
							informationList.add(rs.getString("REGISTRATION_NO"));
							
							marineLiveInfoJsonObject.put("distance", df.format(distance));	
							informationList.add(df.format(distance));
							
							marineLiveInfoJsonObject.put("speed", rs.getInt("SPEED"));	
							informationList.add(rs.getInt("SPEED"));
							
							marineLiveInfoJsonObject.put("groupName", rs.getString("GROUP_NAME"));
							informationList.add(rs.getString("GROUP_NAME"));
							
							marineLiveInfoJsonObject.put("driverName", rs.getString("DRIVER_NAME"));
							informationList.add(rs.getString("DRIVER_NAME"));
							
							marineLiveInfoJsonObject.put("ownerName", rs.getString("OWNER_NAME"));
							informationList.add(rs.getString("OWNER_NAME"));
							
							marineLiveInfoJsonObject.put("latitude", rs.getDouble("LATITUDE"));	
							informationList.add(rs.getDouble("LATITUDE"));
							
							marineLiveInfoJsonObject.put("longitude", rs.getDouble("LONGITUDE"));
							informationList.add(rs.getDouble("LONGITUDE"));
							
							marineLiveInfoJsonArray.put(marineLiveInfoJsonObject);	
							reporthelper.setInformationList(informationList);
							marineLiveList.add(reporthelper);
							
						}
					} catch (Exception e) {
						e.printStackTrace();
					}		
				}				
			}
			marineLiveFinalList.add(marineLiveInfoJsonArray);
			finalreporthelper.setReportsList(marineLiveList);
			finalreporthelper.setHeadersList(marineLiveHeadersList);
			marineLiveFinalList.add(finalreporthelper);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {			
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return marineLiveFinalList;
	}

	public ArrayList<Object> getMarineHistoryDetails(int systemId,int customerId, String assetNumber, String startDate, String endDate, int offset, String language) {
		JSONArray marineHistoryInfoJsonArray = null;
		JSONObject marineHistoryInfoJsonObject = null;
		
		ArrayList<ReportHelper> marineHistoryList = new ArrayList<ReportHelper>();
		ArrayList<String> marineHistoryHeadersList = new ArrayList<String>();
		ReportHelper finalreporthelper = new ReportHelper();
		ArrayList<Object> marineHistoryFinalList = new ArrayList<Object>();
				
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
//		com.mysql.jdbc.Connection mycon = null;
//		com.mysql.jdbc.PreparedStatement mypstmt = null;
//		com.mysql.jdbc.ResultSet myrs = null;
		
		
		int count = 0;
		
		marineHistoryHeadersList.add(commonFunctions.getLabelFromDB("SLNO", language));
		marineHistoryHeadersList.add(commonFunctions.getLabelFromDB("DateTime", language));
		marineHistoryHeadersList.add(commonFunctions.getLabelFromDB("Speed_Nauticle", language));
		marineHistoryHeadersList.add(commonFunctions.getLabelFromDB("Latitude", language));
		marineHistoryHeadersList.add(commonFunctions.getLabelFromDB("Longitude", language));
		
		try {
			marineHistoryInfoJsonArray = new JSONArray();

			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(commonFunctions.getHistoryQuery(marineStatements.GET_HISTORY_VEHICLE_DATA, systemId));
			pstmt.setString(1, assetNumber);
			pstmt.setInt(2, offset);
			pstmt.setString(3, startDate);
			pstmt.setInt(4, offset);
			pstmt.setString(5, endDate);
			pstmt.setInt(6, systemId);
			pstmt.setInt(7, customerId);
			pstmt.setString(8, assetNumber);
			pstmt.setInt(9, offset);
			pstmt.setString(10, startDate);
			pstmt.setInt(11, offset);
			pstmt.setString(12, endDate);
			pstmt.setInt(13, systemId);
			pstmt.setInt(14, customerId);
			pstmt.setString(15, assetNumber);
			pstmt.setInt(16, offset);
			pstmt.setString(17, startDate);
			pstmt.setInt(18, offset);
			pstmt.setString(19, endDate);
			pstmt.setInt(20, systemId);
			pstmt.setInt(21, customerId);
			rs = pstmt.executeQuery();
			while (rs.next()) {

				count++;
				ArrayList<Object> informationList = new ArrayList<Object>();
				ReportHelper reporthelper = new ReportHelper();

				marineHistoryInfoJsonObject = new JSONObject();

				marineHistoryInfoJsonObject.put("slnoIndex", count);
				informationList.add(count);

				marineHistoryInfoJsonObject.put("dateTime", ddMMYYYYHHMMSS.format(rs.getTimestamp("GPS_DATETIME")));
				informationList.add(rs.getString("GPS_DATETIME"));

				marineHistoryInfoJsonObject.put("speed", rs.getInt("SPEED"));
				informationList.add(rs.getInt("SPEED"));
				
				marineHistoryInfoJsonObject.put("latitude", rs.getDouble("LATITUDE"));
				informationList.add(rs.getDouble("LATITUDE"));

				marineHistoryInfoJsonObject.put("longitude", rs.getDouble("LONGITUDE"));
				informationList.add(rs.getDouble("LONGITUDE"));

				marineHistoryInfoJsonArray.put(marineHistoryInfoJsonObject);
				reporthelper.setInformationList(informationList);
				marineHistoryList.add(reporthelper);
			}
			marineHistoryFinalList.add(marineHistoryInfoJsonArray);
			finalreporthelper.setReportsList(marineHistoryList);
			finalreporthelper.setHeadersList(marineHistoryHeadersList);
			marineHistoryFinalList.add(finalreporthelper);
			
//comented for migration			
//			TreeMap<String,Object> hm=new TreeMap<String,Object>();  			
//			marineHistoryInfoJsonArray = new JSONArray();
//			        
//			mycon = DBConnection.getConnectionMysql();
//			mypstmt = (com.mysql.jdbc.PreparedStatement) mycon.prepareStatement(commonFunctions.getGeQuery(marineStatements.GET_GE_VEHICLE_DATA, systemId));
//			
//			mypstmt.setString(1, assetNumber);			
//			mypstmt.setString(2, startDate);
//			mypstmt.setInt(3, offset);			
//			mypstmt.setString(4, endDate);
//			mypstmt.setInt(5, offset);
//			mypstmt.setInt(6, systemId);
//			mypstmt.setInt(7, customerId);
//			
//			myrs = (com.mysql.jdbc.ResultSet) mypstmt.executeQuery();
//			while (myrs.next()) {
//				
//				count++;
//				ArrayList<Object> informationList = new ArrayList<Object>();
//
//				informationList.add(count);
//				informationList.add(myrs.getString("GPS_DATETIME"));
//				informationList.add(myrs.getInt("SPEED"));				
//				informationList.add(myrs.getDouble("LATITUDE"));
//				informationList.add(myrs.getDouble("LONGITUDE"));
//				hm.put(myrs.getString("GMT"),informationList);
//							
//			}
//           
//            con = DBConnection.getConnectionToDB("AMS");
//			pstmt = con.prepareStatement(commonFunctions.getHistoryQuery(marineStatements.GET_HISTORY_VEHICLE_DATA, systemId));
//			pstmt.setString(1, assetNumber);
//			pstmt.setInt(2, offset);
//			pstmt.setString(3, startDate);
//			pstmt.setInt(4, offset);
//			pstmt.setString(5, endDate);
//			pstmt.setInt(6, systemId);
//			pstmt.setInt(7, customerId);
//			pstmt.setString(8, assetNumber);
//			pstmt.setInt(9, offset);
//			pstmt.setString(10, startDate);
//			pstmt.setInt(11, offset);
//			pstmt.setString(12, endDate);
//			pstmt.setInt(13, systemId);
//			pstmt.setInt(14, customerId);
//			rs = pstmt.executeQuery();
//			while (rs.next()) {
//
//				count++;
//				ArrayList<Object> informationList = new ArrayList<Object>();
//
//				informationList.add(count);
//				informationList.add(myrs.getString("GPS_DATETIME"));
//				informationList.add(myrs.getInt("SPEED"));				
//				informationList.add(myrs.getDouble("LATITUDE"));
//				informationList.add(myrs.getDouble("LONGITUDE"));
//				hm.put(myrs.getString("GMT"),informationList);
//
//			}
//
//			 for(String oldKey : hm.keySet()) { 
//				 
//				 ArrayList<Object> innerList = new ArrayList<Object>();
//				 innerList = (ArrayList<Object>) hm.get(oldKey);
//
//					ArrayList<Object> informationList = new ArrayList<Object>();
//					ReportHelper reporthelper = new ReportHelper();
//	
//					marineHistoryInfoJsonObject = new JSONObject();
//	
//					marineHistoryInfoJsonObject.put("slnoIndex", innerList.get(0));
//					informationList.add(innerList.get(0));
//	
//					Date date_time  = Timestamp.valueOf(innerList.get(1).toString());
//					marineHistoryInfoJsonObject.put("dateTime", ddMMYYYYHHMMSS.format(date_time));
//					informationList.add(innerList.get(1));
//	
//					marineHistoryInfoJsonObject.put("speed", innerList.get(2));
//					informationList.add(innerList.get(2));
//					
//					marineHistoryInfoJsonObject.put("latitude", innerList.get(3));
//					informationList.add(innerList.get(3));
//	
//					marineHistoryInfoJsonObject.put("longitude", innerList.get(4));
//					informationList.add(innerList.get(4));
//				 
//				 
//				 
//					marineHistoryInfoJsonArray.put(marineHistoryInfoJsonObject);
//					reporthelper.setInformationList(informationList);
//					marineHistoryList.add(reporthelper);
//				 
//				 }
//			
//			marineHistoryFinalList.add(marineHistoryInfoJsonArray);			
//			finalreporthelper.setReportsList(marineHistoryList);
//			finalreporthelper.setHeadersList(marineHistoryHeadersList);
//			marineHistoryFinalList.add(finalreporthelper);
			
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
			//DBConnection.releaseConnectionToMysqlDB(mycon, mypstmt, myrs);
		}
		return marineHistoryFinalList;
	}

	public ArrayList<Object> getMarineLocationDetails(int systemId,int customerId, int userId, double latitude, double longitude, String date, int proximity, int offset, String language) {
		JSONArray marineLocationInfoJsonArray = null;
		JSONObject marineLocationInfoJsonObject = null;
		
		ArrayList<ReportHelper> marineLocationList = new ArrayList<ReportHelper>();
		ArrayList<String> marineLocationHeadersList = new ArrayList<String>();
		ReportHelper finalreporthelper = new ReportHelper();
		ArrayList<Object> marineLocationFinalList = new ArrayList<Object>();
				
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rsReg = null;
		ResultSet rs = null;
		
		int count = 0;
		
		marineLocationHeadersList.add(commonFunctions.getLabelFromDB("SLNO", language));
		marineLocationHeadersList.add(commonFunctions.getLabelFromDB("Vessel_ID", language));
		marineLocationHeadersList.add(commonFunctions.getLabelFromDB("Vessel_Name", language));
		marineLocationHeadersList.add(commonFunctions.getLabelFromDB("Distance", language));
		marineLocationHeadersList.add(commonFunctions.getLabelFromDB("Speed_Nauticle", language));
		marineLocationHeadersList.add(commonFunctions.getLabelFromDB("Group_Name", language));
		marineLocationHeadersList.add(commonFunctions.getLabelFromDB("Latitude", language));
		marineLocationHeadersList.add(commonFunctions.getLabelFromDB("Longitude", language));
		marineLocationHeadersList.add(commonFunctions.getLabelFromDB("Driver_Name", language));
		marineLocationHeadersList.add(commonFunctions.getLabelFromDB("Driver_Number", language));
		marineLocationHeadersList.add(commonFunctions.getLabelFromDB("Owner_Name", language));
		marineLocationHeadersList.add(commonFunctions.getLabelFromDB("Owner_Number", language));

		try {
			marineLocationInfoJsonArray = new JSONArray();
				
			Date startDate = null;
			Date endDate = null;
						
			Date paramDate = yyyyMMddHHMMSS.parse(date);
			
			Calendar cal = Calendar.getInstance();			
			cal.setTime(paramDate);
			cal.add(Calendar.MINUTE, -5);
			startDate = cal.getTime();
			
			cal.setTime(paramDate);
			cal.add(Calendar.MINUTE, 5);
			endDate = cal.getTime();
			
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(CommonStatements.GET_REGISTRATION_NO_BASED_ON_USER_FOR_MARINE);
			pstmt.setInt(1, customerId);
			pstmt.setInt(2, systemId);
			pstmt.setInt(3, userId);
			rsReg = pstmt.executeQuery();
			while (rsReg.next()) {
				

				pstmt = con.prepareStatement(commonFunctions.getHistoryQuery(marineStatements.GET_LOCATION_VEHICLE_DATA, systemId));
				pstmt.setInt(1, systemId);
				pstmt.setInt(2, customerId);
				pstmt.setString(3, rsReg.getString("REGISTRATION_NUMBER"));
				pstmt.setInt(4, offset);
				pstmt.setString(5, yyyyMMddHHMMSS.format(startDate));
				pstmt.setInt(6, offset);
				pstmt.setString(7, yyyyMMddHHMMSS.format(endDate));
				pstmt.setInt(8, systemId);
				pstmt.setInt(9, customerId);
				pstmt.setString(10, rsReg.getString("REGISTRATION_NUMBER"));
				pstmt.setInt(11, offset);
				pstmt.setString(12, yyyyMMddHHMMSS.format(startDate));
				pstmt.setInt(13, offset);
				pstmt.setString(14, yyyyMMddHHMMSS.format(endDate));
				pstmt.setInt(15, systemId);
				pstmt.setInt(16, customerId);
				pstmt.setString(17, rsReg.getString("REGISTRATION_NUMBER"));
				pstmt.setInt(18, offset);
				pstmt.setString(19, yyyyMMddHHMMSS.format(startDate));
				pstmt.setInt(20, offset);
				pstmt.setString(21, yyyyMMddHHMMSS.format(endDate));

				rs = pstmt.executeQuery();
				while (rs.next()) {
					count++;

					double distance = commonFunctions.distanceCalculate(longitude, latitude, rs.getDouble("LONGITUDE"), rs.getDouble("LATITUDE"));
					if (distance <= proximity) {
						ArrayList<Object> informationList = new ArrayList<Object>();
						ReportHelper reporthelper = new ReportHelper();

						marineLocationInfoJsonObject = new JSONObject();

						marineLocationInfoJsonObject.put("slnoIndex", count);
						informationList.add(count);

						marineLocationInfoJsonObject.put("assetId", rs.getString("VEHICLE_ID"));
						informationList.add(rs.getString("VEHICLE_ID"));

						marineLocationInfoJsonObject.put("assetNumber", rs.getString("REGISTRATION_NO"));
						informationList.add(rs.getString("REGISTRATION_NO"));

						marineLocationInfoJsonObject.put("distance", df.format(distance));
						informationList.add(df.format(distance));
						
						marineLocationInfoJsonObject.put("speed", rs.getInt("SPEED"));
						informationList.add(rs.getInt("SPEED"));

						marineLocationInfoJsonObject.put("groupName", rs.getString("GROUP_NAME"));
						informationList.add(rs.getString("GROUP_NAME"));

						marineLocationInfoJsonObject.put("latitude", rs.getDouble("LATITUDE"));
						informationList.add(rs.getDouble("LATITUDE"));

						marineLocationInfoJsonObject.put("longitude", rs.getDouble("LONGITUDE"));
						informationList.add(rs.getDouble("LONGITUDE"));

						marineLocationInfoJsonObject.put("driverName", rs.getString("DRIVER_NAME"));
						informationList.add(rs.getString("DRIVER_NAME"));

						marineLocationInfoJsonObject.put("driverNumber", rs.getString("DRIVER_NUMBER"));
						informationList.add(rs.getString("DRIVER_NUMBER"));

						marineLocationInfoJsonObject.put("ownerName", rs.getString("OWNER_NAME"));
						informationList.add(rs.getString("OWNER_NAME"));

						marineLocationInfoJsonObject.put("ownerNumber", "");
						informationList.add("");

						marineLocationInfoJsonArray.put(marineLocationInfoJsonObject);
						reporthelper.setInformationList(informationList);
						marineLocationList.add(reporthelper);
					}
					break;
				}
			}
			marineLocationFinalList.add(marineLocationInfoJsonArray);
			finalreporthelper.setReportsList(marineLocationList);
			finalreporthelper.setHeadersList(marineLocationHeadersList);
			marineLocationFinalList.add(finalreporthelper);

//			marineLocationInfoJsonArray = new JSONArray();
//				
//			Date startDate = null;
//			Date endDate = null;
//						
//			Date paramDate = yyyyMMddHHMMSS.parse(date);
//			
//			Calendar cal = Calendar.getInstance();			
//			cal.setTime(paramDate);
//			cal.add(Calendar.MINUTE, -5);
//			startDate = cal.getTime();
//			
//			cal.setTime(paramDate);
//			cal.add(Calendar.MINUTE, 5);
//			endDate = cal.getTime();
//			
//			
//			com.mysql.jdbc.Connection mycon = null;
//			com.mysql.jdbc.PreparedStatement mypstmt = null;
//			com.mysql.jdbc.ResultSet myrs = null;
//			
//			mycon = DBConnection.getConnectionMysql();
//			con = DBConnection.getConnectionToDB("AMS");
//
//			
//			TreeMap<String,Object> hm=new TreeMap<String,Object>();  
//			TreeMap<String,Object> hm2=new TreeMap<String,Object>();  
//			marineLocationInfoJsonArray = new JSONArray();
//			ArrayList<Object> driverIdList = null;
//			
//			pstmt = con.prepareStatement(CommonStatements.GET_REGISTRATION_NO_BASED_ON_USER);
//			pstmt.setInt(1, customerId);
//			pstmt.setInt(2, systemId);
//			pstmt.setInt(3, userId);
//			rsReg = pstmt.executeQuery();
//			while (rsReg.next()) {
//				
//				driverIdList = new ArrayList<Object>();
//				mypstmt = (com.mysql.jdbc.PreparedStatement) mycon.prepareStatement(commonFunctions.getGeQuery(marineStatements.GET_GE_LOCATION_VEHICLE_DATA, systemId));
//				
//				mypstmt.setInt(1, systemId);
//				mypstmt.setInt(2, customerId);
//				mypstmt.setString(3, rsReg.getString("REGISTRATION_NUMBER"));
//				mypstmt.setInt(5, offset);
//				mypstmt.setString(4, yyyyMMddHHMMSS.format(startDate));
//				mypstmt.setInt(7, offset);
//				mypstmt.setString(6, yyyyMMddHHMMSS.format(endDate));
//				
//				myrs = (com.mysql.jdbc.ResultSet) mypstmt.executeQuery();
//				while (myrs.next()) {
//					
//					count++;
//
//					double distance = commonFunctions.distanceCalculate(longitude, latitude, myrs.getDouble("LONGITUDE"), myrs.getDouble("LATITUDE"));
//					if (distance <= proximity) {
//						ArrayList<Object> informationList = new ArrayList<Object>();
//						
//						informationList.add(myrs.getString("GMT"));						
//						informationList.add(count);
//						informationList.add("");
//						informationList.add(myrs.getString("REGISTRATION_NO"));
//						informationList.add(df.format(distance));						
//						informationList.add(myrs.getInt("SPEED"));
//						informationList.add("");
//						informationList.add(myrs.getDouble("LATITUDE"));
//						informationList.add(myrs.getDouble("LONGITUDE"));                       
//						informationList.add(myrs.getString("MESSAGE_NUMBER"));						
//						driverIdList.add(myrs.getString("MESSAGE_NUMBER"));												
//						informationList.add("");
//						informationList.add("");
//						informationList.add("");
//						
//						hm2.put(myrs.getString("GMT"),informationList);												
//					}	
//					break;
//				}
//				
//
//				HashMap<Integer, String> st = new HashMap<Integer, String>();
//				st = getDriverNames(driverIdList,con,pstmt,rs);
//				 
//				
//				for(String oldKey : hm2.keySet()) { 
//					
//					 ArrayList<Object> innerList = new ArrayList<Object>();
//					 innerList = (ArrayList<Object>) hm2.get(oldKey);
//											 
//						 for ( Integer key1 : st.keySet() ) {							   							
//						 if(key1.equals(innerList.get(9))){
//						  innerList.set(9, st.get(key1));
//							break;
//						 }		
//						 }
//						   hm.put(innerList.get(0).toString(),innerList);					          
//				 }
//				
//				
//				pstmt = con.prepareStatement(commonFunctions.getHistoryQuery(marineStatements.GET_LOCATION_VEHICLE_DATA, systemId));
//				pstmt.setInt(1, systemId);
//				pstmt.setInt(2, customerId);
//				pstmt.setString(3, rsReg.getString("REGISTRATION_NUMBER"));
//				pstmt.setInt(4, offset);
//				pstmt.setString(5, yyyyMMddHHMMSS.format(startDate));
//				pstmt.setInt(6, offset);
//				pstmt.setString(7, yyyyMMddHHMMSS.format(endDate));
//				pstmt.setInt(8, systemId);
//				pstmt.setInt(9, customerId);
//				pstmt.setString(10, rsReg.getString("REGISTRATION_NUMBER"));
//				pstmt.setInt(11, offset);
//				pstmt.setString(12, yyyyMMddHHMMSS.format(startDate));
//				pstmt.setInt(13, offset);
//				pstmt.setString(14, yyyyMMddHHMMSS.format(endDate));
//
//
//				rs = pstmt.executeQuery();
//				while (rs.next()) {
//					
//					count++;
//
//					double distance = commonFunctions.distanceCalculate(longitude, latitude, rs.getDouble("LONGITUDE"), rs.getDouble("LATITUDE"));
//					if (distance <= proximity) {
//						ArrayList<Object> informationList = new ArrayList<Object>();
//						
//						informationList.add(myrs.getString(myrs.getString("GMT")));						
//						informationList.add(count);
//						informationList.add(rs.getString("VEHICLE_ID"));
//						informationList.add(rs.getString("REGISTRATION_NO"));
//						informationList.add(df.format(distance));						
//						informationList.add(rs.getInt("SPEED"));
//						informationList.add(rs.getString("GROUP_NAME"));
//						informationList.add(rs.getDouble("LATITUDE"));
//						informationList.add(rs.getDouble("LONGITUDE"));
//						informationList.add(rs.getString("DRIVER_NAME"));
//						informationList.add(rs.getString("DRIVER_NUMBER"));
//						informationList.add(rs.getString("OWNER_NAME"));
//						informationList.add("");
//						
//						hm.put(rs.getString("GMT"),informationList);
//						
//					}	
//					break;
//					
//				}
//			}
//			
//			 for(String oldKey : hm.keySet()) { 
//			 
//			 ArrayList<Object> innerList = new ArrayList<Object>();
//			 innerList = (ArrayList<Object>) hm.get(oldKey);
//
//				ArrayList<Object> informationList = new ArrayList<Object>();
//				ReportHelper reporthelper = new ReportHelper();
//
//				marineLocationInfoJsonObject = new JSONObject();
//
//				marineLocationInfoJsonObject.put("slnoIndex", innerList.get(1));
//				informationList.add(innerList.get(0));
//
//				marineLocationInfoJsonObject.put("assetId", innerList.get(2));
//				informationList.add(innerList.get(1));
//
//				marineLocationInfoJsonObject.put("assetNumber", innerList.get(3));
//				informationList.add(innerList.get(2));
//
//				marineLocationInfoJsonObject.put("distance", innerList.get(4));
//				informationList.add(innerList.get(3));
//				
//				marineLocationInfoJsonObject.put("speed", innerList.get(5));
//				informationList.add(innerList.get(4));
//
//				marineLocationInfoJsonObject.put("groupName", innerList.get(6));
//				informationList.add(innerList.get(5));
//
//				marineLocationInfoJsonObject.put("latitude", innerList.get(7));
//				informationList.add(innerList.get(6));
//
//				marineLocationInfoJsonObject.put("longitude", innerList.get(8));
//				informationList.add(innerList.get(7));
//
//				marineLocationInfoJsonObject.put("driverName", innerList.get(9));
//				informationList.add(innerList.get(8));
//
//				marineLocationInfoJsonObject.put("driverNumber", innerList.get(10));
//				informationList.add(innerList.get(9));
//
//				marineLocationInfoJsonObject.put("ownerName", innerList.get(11));
//				informationList.add(innerList.get(10));
//
//				marineLocationInfoJsonObject.put("ownerNumber", "");
//				informationList.add("");
//
//				marineLocationInfoJsonArray.put(marineLocationInfoJsonObject);
//				reporthelper.setInformationList(informationList);
//				marineLocationList.add(reporthelper);
//			 
//			 }
//		
//			marineLocationFinalList.add(marineLocationInfoJsonArray);
//			finalreporthelper.setReportsList(marineLocationList);
//			finalreporthelper.setHeadersList(marineLocationHeadersList);
//			marineLocationFinalList.add(finalreporthelper);
//		
		
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
			DBConnection.releaseConnectionToDB(null, null, rsReg);
			//DBConnection.releaseConnectionToMysqlDB(mycon, mypstmt, myrs);
		}
		return marineLocationFinalList;
	}

//	public HashMap<Integer, String> getDriverNames(ArrayList<Object> driverList,Connection con,PreparedStatement pstmt,ResultSet rs){
//		HashMap<Integer, String> st = new HashMap<Integer, String>();
//		
//		
//		
//		
//		return st;
//		}	
//	
	
	public JSONArray getFindByLocation(int systemId) {
		JSONArray findByLocationJsonArray = new JSONArray();
		JSONObject findByLocationJsonObject = new JSONObject();
		
				
		try {
			if(String.valueOf(systemId).equals(marineVesselBean.getSystemId())){
				findByLocationJsonObject.put("FindByCustomerId", marineVesselBean.getCustomerId());
				findByLocationJsonObject.put("FindByLatitude", marineVesselBean.getLatitude());
				findByLocationJsonObject.put("FindByLongitude", marineVesselBean.getLongitude());
				findByLocationJsonObject.put("FindByDate", marineVesselBean.getDate());
			}
			findByLocationJsonArray.put(findByLocationJsonObject);
		} catch (Exception e) {
			e.printStackTrace();
		} 
		return findByLocationJsonArray;
	}

	public void setFindByLocation(int systemId, String customerId, String latitude, String longitude, String dateTime) {
		
		try {
				if (dateTime.contains("T")) {
					dateTime = dateTime.substring(0, dateTime.indexOf("T")) + " " + dateTime.substring(dateTime.indexOf("T") + 1, dateTime.length());
				}
				
				marineVesselBean.setSystemId(String.valueOf(systemId));
				marineVesselBean.setCustomerId(customerId);
				marineVesselBean.setLatitude(latitude);
				marineVesselBean.setLongitude(longitude);
				marineVesselBean.setDate(ddMMYYYYHHMMSS.format(yyyyMMddHHMMSS.parse(dateTime)));
				
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}
