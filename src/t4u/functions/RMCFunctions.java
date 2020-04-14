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

import t4u.beans.ReportHelper;
import t4u.common.DBConnection;
import t4u.statements.RMCStatements;

/**
 * @author Nikhil
 *
 */
public class RMCFunctions {
	CommonFunctions cfuncs = new CommonFunctions();
	SimpleDateFormat sdfyyyymmddhhmmss=new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
	SimpleDateFormat sdfmmddyyyyhhmmss=new SimpleDateFormat("MM/dd/yyyy HH:mm:ss");
	SimpleDateFormat sdfFormatDate = new SimpleDateFormat("MM/dd/yyyy");
	CommonFunctions cf = new CommonFunctions();
	/** Insert RMC Plant Association
	 * @param customerid
	 * @param plantid
	 * @param systemId
	 * @param userId
	 * @param status
	 * @return
	 */
	public int insertPlantAssociation(String customerid, String plantid,
			int systemId, int userId,String status) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int insertResult=0;
		try
		{	
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(RMCStatements.INSERT_PLANT_ASSOCIATION);
			pstmt.setString(1,plantid);
			pstmt.setString(2,customerid);
			pstmt.setInt(3,systemId);
			pstmt.setString(4,status);
			pstmt.setInt(5,userId);
			insertResult=pstmt.executeUpdate();	
			
		}
		catch(Exception e)
		{
		e.printStackTrace();	
		}
		finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return insertResult;
	}

	/** Get details from RMC Plant Association 
	 * @param customerid
	 * @param systemId
	 * @param zone
	 * @return
	 */
	public JSONArray getGridRMCPlantAssociation(String customerid, int systemId,String zone) {
		JSONArray RMCPlantJsonArray = new JSONArray();
		JSONObject RMCPlantJsonObject = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			RMCPlantJsonArray = new JSONArray();
			RMCPlantJsonObject = new JSONObject();
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(cfuncs.getLocationQuery(RMCStatements.GET_PLANT_ASSOCIATION,zone));
			pstmt.setInt(1, Integer.parseInt(customerid));
			pstmt.setInt(2, systemId);
			rs = pstmt.executeQuery();
			while (rs.next()) {			
				RMCPlantJsonObject = new JSONObject();
				String plantid = rs.getString("HUB_ID");
				String plantname = rs.getString("NAME");
				String status=rs.getString("STATUS");
				RMCPlantJsonObject.put("plantid", plantid);
				RMCPlantJsonObject.put("plantname", plantname);
				RMCPlantJsonObject.put("status", status);	
				RMCPlantJsonArray.put(RMCPlantJsonObject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}

		return RMCPlantJsonArray;
	}

	/** Updates RMC Plant Association 
	 * @param customerid
	 * @param plantid
	 * @param systemId
	 * @param userId
	 * @param status
	 * @return
	 */
	public int updatePlantAssociation(String customerid, String plantid,
			int systemId, int userId, String status) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int updateResult=0;
		try
		{	
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(RMCStatements.UPDATE_PLANT_ASSOCIATION);
			pstmt.setString(1,status);
			pstmt.setString(2,plantid);
			pstmt.setString(3,customerid);
			pstmt.setInt(4,systemId);
			updateResult=pstmt.executeUpdate();	
			
		}
		catch(Exception e)
		{
		e.printStackTrace();	
		}
		finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return updateResult;
	}

	/** Inserts RMC Settings
	 * @param customerid
	 * @param vehicleno
	 * @param systemId
	 * @param loading
	 * @param unloading
	 * @param userId
	 * @return
	 */
	public int insertPlantSettings(String customerid, String vehicleno,
			int systemId, String loading, String unloading, int userId) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int insertResult=0;
		try
		{	
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(RMCStatements.INSERT_PLANT_SETTINGS);
			pstmt.setString(1,vehicleno);
			pstmt.setString(2,loading);
			pstmt.setString(3,unloading);
			pstmt.setInt(4,systemId);
			pstmt.setString(5,customerid);
			pstmt.setInt(6,userId);
			insertResult=pstmt.executeUpdate();	
			
		}
		catch(Exception e)
		{
		e.printStackTrace();	
		}
		finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return insertResult;
	}

	/**  Updates RMC Settings
	 * @param customerid
	 * @param vehicleno
	 * @param systemId
	 * @param loading
	 * @param unloading
	 * @return
	 */
	public int updatePlantSetting(String customerid, String vehicleno,
			int systemId, String loading, String unloading) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int updateResult=0;
		try
		{	
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(RMCStatements.UPDATE_PLANT_SETTINGS);
			pstmt.setString(1,loading);
			pstmt.setString(2,unloading);
			pstmt.setString(3,vehicleno);
			pstmt.setInt(4,systemId);
			pstmt.setString(5,customerid);
			updateResult=pstmt.executeUpdate();	
			
		}
		catch(Exception e)
		{
		e.printStackTrace();	
		}
		finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return updateResult;
	}

	/** Get Details for RMC Settings
	 * @param customerid
	 * @param systemId
	 * @param zone
	 * @return
	 */
	public JSONArray getGridRMCSettings(String customerid, int systemId,
			String zone,int userId) {
		JSONArray RMCSettingJsonArray = new JSONArray();
		JSONObject RMCSettingJsonObject = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			RMCSettingJsonArray = new JSONArray();
			RMCSettingJsonObject = new JSONObject();
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(RMCStatements.GET_PLANT_SETTING);
			pstmt.setInt(1, Integer.parseInt(customerid));
			pstmt.setInt(2, systemId);
			pstmt.setInt(3, userId);
			rs = pstmt.executeQuery();
			while (rs.next()) {			
				RMCSettingJsonObject = new JSONObject();
				String regNo = rs.getString("REGISTRATION_NO");
				String loading = rs.getString("LOADING");
				String unloading=rs.getString("UNLOADING");
				RMCSettingJsonObject.put("vehicleno", regNo);
				RMCSettingJsonObject.put("loadingid", loading);
				RMCSettingJsonObject.put("unloadingid", unloading);	
				RMCSettingJsonArray.put(RMCSettingJsonObject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}

		return RMCSettingJsonArray;
	}

	/**  Deletes RMC Settings
	 * @param customerid
	 * @param vehicleno
	 * @param systemId
	 * @param loading
	 * @param unloading
	 * @param userId
	 * @return
	 */
	public int deletePlantSettings(String customerid, String vehicleno,
			int systemId, String loading, String unloading, int userId) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int deleteResult=0;
		try
		{	
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(RMCStatements.DELETE_PLANT_SETTINGS);
			pstmt.setString(1,vehicleno);
			pstmt.setString(2,loading);
			pstmt.setString(3,unloading);
			pstmt.setInt(4,systemId);
			pstmt.setString(5,customerid);
			deleteResult=pstmt.executeUpdate();	
			
		}
		catch(Exception e)
		{
		e.printStackTrace();	
		}
		finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return deleteResult;
	}

	/** Get all  Vehicles except those in  RMC Settings
	 * @param custId
	 * @param ltspId
	 * @return
	 */
	public JSONArray getVehicleDetails(String custId, String ltspId,String unitTypeCode,int userId) {
		JSONArray jsonArray=null;
		JSONObject jsonObject=null;
		Connection conAms=null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		StringBuilder sb=null;
		String stmt="";
		try {
			stmt=RMCStatements.GET_VEHICLES;
		    sb=new StringBuilder(stmt);
		    stmt=sb.toString().replace("unitTypeCodeReplace",unitTypeCode);
			jsonArray=new JSONArray();
			jsonObject=new JSONObject();
			conAms=DBConnection.getConnectionToDB("AMS");
			pstmt=conAms.prepareStatement(stmt);
			int customerId=Integer.parseInt(custId.trim());			
			int ltsp=Integer.parseInt(ltspId.trim());
			pstmt.setInt(1, ltsp);
			pstmt.setInt(2, customerId);
			pstmt.setInt(3, userId);
			rs=pstmt.executeQuery();
			
			
			while(rs.next()){
				jsonObject = new JSONObject();
				jsonObject.put("VehicleNo", rs.getString("Registration_no"));
				jsonObject.put("IMEINo", rs.getString("Unit_Number"));
				jsonObject.put("DeviceType", rs.getString("Unit_type_desc"));
				if(rs.getString("VehicleAlias")!=null && rs.getString("VehicleAlias")!=""){
				jsonObject.put("VehicleAlias", rs.getString("VehicleAlias"));
				}else{
				jsonObject.put("VehicleAlias", "");
				}
				jsonArray.put(jsonObject);
			}
			
		} catch (Exception e) {
			System.out.println("Error in RMC:-getVehicleDetails "+e.toString());
		}finally{
			DBConnection.releaseConnectionToDB(conAms, pstmt, rs);
		}
		
		return jsonArray;
	}
	/** Get all Hubs except those in RMC Plant Association
	 * @param custID
	 * @param zone
	 * @return
	 */
	public JSONArray getHubs(String custID, String zone) {
		JSONArray hubJsonArray = new JSONArray();
		JSONObject hubJsonObject = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			hubJsonArray = new JSONArray();
			hubJsonObject = new JSONObject();
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(cfuncs.getLocationQuery(
					RMCStatements.GET_TOTAL_HUBS, zone));
			pstmt.setInt(1, Integer.parseInt(custID));
			rs = pstmt.executeQuery();
			while (rs.next()) {
				hubJsonObject = new JSONObject();
				int hubId = rs.getInt("HUBID");
				String hubName = rs.getString("NAME");
				hubJsonObject.put("HubId", hubId);
				hubJsonObject.put("HubName", hubName);
				hubJsonArray.put(hubJsonObject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}

		return hubJsonArray;
	}

	/** Returns the Daily RMCReport
	 * @param vehicleNo
	 * @param startdate
	 * @param enddate
	 * @param language
	 * @return
	 */
	public ArrayList<Object> getRMCReportDetails(String groupid,String startdate,String enddate,int offset,String language,int systemId,int userId) {
		JSONArray RMCSettingJsonArray = new JSONArray();
		JSONObject RMCSettingJsonObject = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		ArrayList<ReportHelper> reportsList = new ArrayList<ReportHelper>();
		ArrayList<String> headersList = new ArrayList<String>();
		ReportHelper finalreporthelper = new ReportHelper();
		ArrayList<Object> finlist = new ArrayList<Object>();
		DecimalFormat formatter = new DecimalFormat("00.00");
		headersList.add(cf.getLabelFromDB("SLNO",language));
		headersList.add(cf.getLabelFromDB("Date",language));
		headersList.add(cf.getLabelFromDB("Registration_No",language));
		headersList.add(cf.getLabelFromDB("Mixing_Hours",language));
		headersList.add(cf.getLabelFromDB("Mixing_Percentage",language));
		headersList.add(cf.getLabelFromDB("Discharging_Hours",language));
		headersList.add(cf.getLabelFromDB("Discharging_Percentage",language));
		headersList.add(cf.getLabelFromDB("Empty_Hours",language));
		headersList.add(cf.getLabelFromDB("Empty_Percentage",language));
		try {
			RMCSettingJsonArray = new JSONArray();
			RMCSettingJsonObject = new JSONObject();
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(RMCStatements.GET_DAILY_REPORT);
			pstmt.setInt(1,offset);
			pstmt.setInt(2,systemId);
			pstmt.setString(3,groupid);
			pstmt.setInt(4,offset);
			pstmt.setString(5,startdate);
			pstmt.setInt(6,offset);
			pstmt.setString(7,enddate);
			pstmt.setInt(8, userId);
			rs = pstmt.executeQuery();
			int count = 0;
			while (rs.next()) {			
				RMCSettingJsonObject = new JSONObject();
				ArrayList<String> informationList=new ArrayList<String>();
				ReportHelper reporthelper=new ReportHelper();
				count++;
				
				informationList.add(Integer.toString(count));
				RMCSettingJsonObject.put("slnoIndex", Integer.toString(count));
				
				Date date = rs.getTimestamp("DATE");
				String regNo = rs.getString("REGISTRATION_NO");
				String loadinghour = rs.getString("LOADING_HOUR");
				String unloadinghour=rs.getString("UNLOADING_HOUR");
				String emptyHour=rs.getString("EMPTY_HOUR");
				String loadingpercent = rs.getString("LOADING_HOUR");
				String unloadingpercent= rs.getString("UNLOADING_HOUR");
				String emptypercent= rs.getString("EMPTY_HOUR");
				double loading= 0.00;
				double unloading= 0.00;
				double empty= 0.00;
				loading = cfuncs.convertHHMMToMinutes(loadingpercent);
				unloading = cfuncs.convertHHMMToMinutes(unloadingpercent);
				empty = cfuncs.convertHHMMToMinutes(emptypercent);
				loadingpercent = formatter.format(((loading/1440.00)*100));
				unloadingpercent = formatter.format(((unloading/1440.00)*100));
				emptypercent = formatter.format(((empty/1440.00)*100));
				RMCSettingJsonObject.put("Date",sdfyyyymmddhhmmss.format(date));
				informationList.add(sdfyyyymmddhhmmss.format(date).substring(0, sdfyyyymmddhhmmss.format(date).indexOf(" ")));
				RMCSettingJsonObject.put("VehicleNo", regNo);
				informationList.add(regNo);
				RMCSettingJsonObject.put("loadinghour", loadinghour);
				informationList.add(loadinghour);
				RMCSettingJsonObject.put("loadingpercent", loadingpercent);
				informationList.add(loadingpercent);
				RMCSettingJsonObject.put("unloadinghour", unloadinghour);	
				informationList.add(unloadinghour);
				RMCSettingJsonObject.put("unloadingpercent", unloadingpercent);	
				informationList.add(unloadingpercent);
				RMCSettingJsonObject.put("emptyhour", emptyHour);
				informationList.add(emptyHour);
				RMCSettingJsonObject.put("emptypercent", emptypercent);
				informationList.add(emptypercent);
				RMCSettingJsonArray.put(RMCSettingJsonObject);
				reporthelper.setInformationList(informationList);  
				reportsList.add(reporthelper);
			}
			finlist.add(RMCSettingJsonArray);
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

	public ArrayList<Object> getRMCActivityReportDetails(String vehicleNo,
			String startdate, String enddate, int offset, String language,
			int systemId) {
		JSONArray RMCSettingJsonArray = new JSONArray();
		JSONObject RMCSettingJsonObject = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String loadingOnEvent = "";
		String loadingOffEvent = "";
		String unloadingOnEvent = "";
		String unloadingOffEvent = "";
		Date tempLoadingOndate = null;
		Date tempUnloadingOndate = null;
		boolean loadingOffFlag = false;
		boolean unloadingOffFlag = false;
		ArrayList<String> rmcEvents = null;
		ArrayList<ReportHelper> reportsList = new ArrayList<ReportHelper>();
		ArrayList<String> headersList = new ArrayList<String>();
		ReportHelper finalreporthelper = new ReportHelper();
		ArrayList<Object> finlist = new ArrayList<Object>();
		headersList.add(cf.getLabelFromDB("SLNO", language));
		headersList.add(cf.getLabelFromDB("Date&Time", language));
		headersList.add(cf.getLabelFromDB("Location", language));
		headersList.add(cf.getLabelFromDB("Drum_Activity", language));
		headersList.add(cf.getLabelFromDB("Duration", language));
		headersList.add(cf.getLabelFromDB("Speed", language));
		try {
			RMCSettingJsonArray = new JSONArray();
			RMCSettingJsonObject = new JSONObject();
			con = DBConnection.getConnectionToDB("AMS");
			rmcEvents = new ArrayList<String>();
			rmcEvents = getLoadingUnloadingEvents(con, vehicleNo, systemId);
			loadingOnEvent = rmcEvents.get(0).trim();
			loadingOffEvent = rmcEvents.get(1).trim();
			unloadingOnEvent = rmcEvents.get(2).trim();
			unloadingOffEvent = rmcEvents.get(3).trim();
			pstmt = con.prepareStatement(RMCStatements.GET_RMC_ACTIVITY_REPORT);
			pstmt.setInt(1, offset);
			pstmt.setString(2, vehicleNo);
			pstmt.setInt(3, offset);
			pstmt.setString(4, startdate);
			pstmt.setInt(5, offset);
			pstmt.setString(6, enddate);
			pstmt.setInt(7, systemId);
			pstmt.setInt(8, offset);
			pstmt.setString(9, vehicleNo);
			pstmt.setInt(10, offset);
			pstmt.setString(11, startdate);
			pstmt.setInt(12, offset);
			pstmt.setString(13, enddate);
			pstmt.setInt(14, systemId);
			rs = pstmt.executeQuery();
			int count = 0;
			while (rs.next()) {
				RMCSettingJsonObject = new JSONObject();
				ArrayList<String> informationList = new ArrayList<String>();
				ReportHelper reporthelper = new ReportHelper();
				count++;

				informationList.add(Integer.toString(count));
				RMCSettingJsonObject.put("slnoIndex", Integer.toString(count));
				Date localtime = rs.getTimestamp("LOCAL_TIME");
				String location = rs.getString("LOCATION");
				String eventno = rs.getString("EVENT_NUMBER").trim();
				String speed = rs.getString("SPEED");
				String duration = "";
				String drumActivity = "";
				int diffMinutes = 0;
				if (eventno.equals(loadingOnEvent)) {
					drumActivity = "Mixing On";
					loadingOffFlag = true;
					tempLoadingOndate = localtime;
				} else if (eventno.equals(loadingOffEvent)) {
					drumActivity = "Mixing Off";
					if (loadingOffFlag) {
						loadingOffFlag = false;
						diffMinutes = cfuncs.getTimeDiffrence(
								tempLoadingOndate, localtime);
						duration = cfuncs
								.convertMinutesToHHMMFormat(diffMinutes);
					}
				} else if (eventno.equals(unloadingOnEvent)) {
					drumActivity = "Discharging On";
					unloadingOffFlag = true;
					tempUnloadingOndate = localtime;
				} else if (eventno.equals(unloadingOffEvent)) {
					drumActivity = "Discharging Off";
					if (unloadingOffFlag) {
						unloadingOffFlag = false;
						diffMinutes = cfuncs.getTimeDiffrence(
								tempUnloadingOndate, localtime);
						duration = cfuncs
								.convertMinutesToHHMMFormat(diffMinutes);
					}
				}
				RMCSettingJsonObject.put("Date", sdfyyyymmddhhmmss
						.format(localtime));
				informationList.add(sdfyyyymmddhhmmss.format(localtime));
				RMCSettingJsonObject.put("Location", location);
				informationList.add(location);
				RMCSettingJsonObject.put("DrumActivity", drumActivity);
				informationList.add(drumActivity);
				RMCSettingJsonObject.put("Duration", duration);
				informationList.add(duration);
				RMCSettingJsonObject.put("Speed", speed);
				informationList.add(speed);
				RMCSettingJsonArray.put(RMCSettingJsonObject);
				reporthelper.setInformationList(informationList);
				reportsList.add(reporthelper);
			}
			finlist.add(RMCSettingJsonArray);
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

	/**
	 * Returns Loading & Unloading events(Mixing & Discharging) for a vehicle
	 * 
	 * @param connectionAMS
	 * @param vehicleNo
	 * @param systemId
	 * @return
	 */
	public ArrayList<String> getLoadingUnloadingEvents(
			Connection connectionAMS, String vehicleNo, int systemId) {
		ArrayList<String> RMCEvents = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		ResultSet rs1 = null;
		String LoadingOn = "";
		String LoadingOff = "";
		String UnloadingOn = "";
		String UnloadingOff = "";
		try {
			RMCEvents = new ArrayList<String>();
			pstmt = connectionAMS
					.prepareStatement(RMCStatements.GET_RMC_EVENTS);
			pstmt.setString(1, vehicleNo);
			rs1 = pstmt.executeQuery();
			if (rs1.next()) {
				String Loading = rs1.getString("LOADING");
				String Unloading = rs1.getString("UNLOADING");
				pstmt = connectionAMS
						.prepareStatement(RMCStatements.GET_RMC_LOADING_AND_UNLOADING);
				pstmt.setString(1, vehicleNo);
				pstmt.setInt(2, systemId);
				rs = pstmt.executeQuery();
				while (rs.next()) {
					if (Loading.equals("EVENTA") & Unloading.equals("EVENTB")) {
						if (rs.getString("EVENT_TYPE").equals("LOADING_ON")) {
							LoadingOn = rs.getString("EVENT_ID");
						} else if (rs.getString("EVENT_TYPE").equals(
								"LOADING_OFF")) {
							LoadingOff = rs.getString("EVENT_ID");
						} else if (rs.getString("EVENT_TYPE").equals(
								"UNLOADING_ON")) {
							UnloadingOn = rs.getString("EVENT_ID");
						} else if (rs.getString("EVENT_TYPE").equals(
								"UNLOADING_OFF")) {
							UnloadingOff = rs.getString("EVENT_ID");
						}
					} else if (Loading.equals("EVENTB")
							& Unloading.equals("EVENTA")) {
						if (rs.getString("EVENT_TYPE").equals("LOADING_ON")) {
							UnloadingOn = rs.getString("EVENT_ID");
						} else if (rs.getString("EVENT_TYPE").equals(
								"LOADING_OFF")) {
							UnloadingOff = rs.getString("EVENT_ID");
						} else if (rs.getString("EVENT_TYPE").equals(
								"UNLOADING_ON")) {
							LoadingOn = rs.getString("EVENT_ID");
						} else if (rs.getString("EVENT_TYPE").equals(
								"UNLOADING_OFF")) {
							LoadingOff = rs.getString("EVENT_ID");
						}
					}
				}
			}
			RMCEvents.add(LoadingOn);
			RMCEvents.add(LoadingOff);
			RMCEvents.add(UnloadingOn);
			RMCEvents.add(UnloadingOff);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return RMCEvents;
	}
}

