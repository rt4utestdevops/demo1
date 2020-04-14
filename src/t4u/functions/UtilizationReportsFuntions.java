package t4u.functions;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;

import org.json.JSONArray;
import org.json.JSONObject;

import t4u.beans.ReportHelper;
import t4u.common.DBConnection;
import t4u.statements.UtilizationReportsStatements;

public class UtilizationReportsFuntions {

	CommonFunctions cfuncs = new CommonFunctions();
	SimpleDateFormat sdfyyyymmddhhmmss=new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
	SimpleDateFormat sdfFormatDate = new SimpleDateFormat("MM/dd/yyyy HH:mm:ss");
	CommonFunctions cf = new CommonFunctions();

	public JSONArray getAssetGroup(int systemid, int clientid,int userId)
	{
		JSONArray jsonArray = new JSONArray();
		JSONObject obj1 = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try 
		{
			con = DBConnection.getConnectionToDB("AMS");

			pstmt = con.prepareStatement(UtilizationReportsStatements.GET_GROUP_NAME_FOR_CLIENT);
			pstmt.setInt(1, clientid);
			pstmt.setInt(2, userId);
			pstmt.setInt(3, systemid);
			rs = pstmt.executeQuery();
			obj1.put("groupId", "0");
			obj1.put("groupName", "ALL");
			jsonArray.put(obj1);
			while (rs.next()) 
			{
				obj1 = new JSONObject();
				obj1.put("groupId", rs.getString("GROUP_ID"));
				obj1.put("groupName", rs.getString("GROUP_NAME"));
				jsonArray.put(obj1);
			}
		} 
		catch (Exception e) 
		{
			e.printStackTrace();
		} 
		finally 
		{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jsonArray;
	}
	
	
	public JSONArray getAssetGroupExceptAll(int systemid, int clientid,int userId)
	{
		JSONArray jsonArray = new JSONArray();
		JSONObject obj1 = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try 
		{
			con = DBConnection.getConnectionToDB("AMS");

			pstmt = con.prepareStatement(UtilizationReportsStatements.GET_GROUP_NAME_FOR_CLIENT);
			pstmt.setInt(1, clientid);
			pstmt.setInt(2, userId);
			pstmt.setInt(3, systemid);
			rs = pstmt.executeQuery();
			while (rs.next()) 
			{
				obj1 = new JSONObject();
				obj1.put("groupId", rs.getString("GROUP_ID"));
				obj1.put("groupName", rs.getString("GROUP_NAME"));
				jsonArray.put(obj1);
			}
		} 
		catch (Exception e) 
		{
			e.printStackTrace();
		} 
		finally 
		{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jsonArray;
	}
	public ArrayList < Object > getUtilizationWorkingHolidaysAndWeekendReport(int systemId, int customerId,int assetGruopId,int userId,String language,String startDate,String endDate,int offset) {
		JSONArray JsonArray = new JSONArray();
		JSONObject JsonObject = null;

		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		PreparedStatement pstmt1 = null;
		ResultSet rs1 = null;
		PreparedStatement pstmt2 = null;
		ResultSet rs2 = null;
		DecimalFormat decformat = new DecimalFormat("#0.00");
		ArrayList < ReportHelper > reportsList = new ArrayList < ReportHelper > ();
		ArrayList < String > headersList = new ArrayList < String > ();
		ReportHelper finalreporthelper = new ReportHelper();
		ArrayList < Object > alist = new ArrayList < Object > ();


		headersList.add(cf.getLabelFromDB("SLNO", language));
		headersList.add(cf.getLabelFromDB("Asset_Group", language));
		headersList.add(cf.getLabelFromDB("Asset_Number", language));
		headersList.add(cf.getLabelFromDB("Asset_Type", language));
		headersList.add(cf.getLabelFromDB("Asset_Model", language));
		headersList.add(cf.getLabelFromDB("Selected_Days", language));
		headersList.add(cf.getLabelFromDB("Working_Days", language));
		headersList.add(cf.getLabelFromDB("Non_Working_Days", language));
		headersList.add(cf.getLabelFromDB("Utilized_During_Working_Days", language));
		headersList.add(cf.getLabelFromDB("Non_Utilization_During_Working_Days", language));
		headersList.add(cf.getLabelFromDB("Utilized_On_Holidays", language));
		headersList.add(cf.getLabelFromDB("HRS_of_Ignition_ON", language));
		headersList.add(cf.getLabelFromDB("Travel_Time", language));
		headersList.add(cf.getLabelFromDB("Distance_Travelled", language));
		headersList.add(cf.getLabelFromDB("Utilizations", language));

		try {
			String groupstr = "";
			if (assetGruopId!=0) {
				groupstr = " and vc.GROUP_ID="+assetGruopId +" ";
			}
			int count = 0;
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(UtilizationReportsStatements.GET_UTILIZATION_WORKING_HOLIDAYS_AND_WEEKENDS_REPORT.replace("#",groupstr));
			pstmt.setInt(1, offset);
			pstmt.setString(2, startDate);
			pstmt.setInt(3, offset);
			pstmt.setString(4, endDate);
			pstmt.setInt(5, systemId);
			pstmt.setInt(6, customerId);
			pstmt.setInt(7, userId);
			pstmt.setInt(8, offset);
			pstmt.setString(9, startDate);
			pstmt.setInt(10, offset);
			pstmt.setString(11, endDate);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				JsonObject = new JSONObject();
				ArrayList < Object > informationList = new ArrayList < Object > ();
				ReportHelper reporthelper = new ReportHelper();
				count++;
				int WORKINGDAYS=rs.getInt("SELECTED_DAYS")-rs.getInt("NON_WORKING_DAYS");
				
				
				float HRSofIGNITIONON =0;
				int ignitionHrsOn=rs.getInt("HRS_OF_IGNITION_ON");
				if (ignitionHrsOn!=0) {
				 String ignitionHrsON=convertMinutesToHHMMFormatNew(ignitionHrsOn);
				 HRSofIGNITIONON=Float.parseFloat(ignitionHrsON);
				}
				
				float travelTime=0;
				int travelTimeInInt=rs.getInt("TRAVEL_TIME");
				if (travelTimeInInt!=0) {
					String travel=convertMinutesToHHMMFormatNew(travelTimeInInt);
					travelTime=Float.parseFloat(travel);
				}

				float distanceTravelled=rs.getFloat("DISTANCE_TRAVELLED");


				informationList.add(count);
				JsonObject.put("slnoIndex", count);

				JsonObject.put("groupNameDataIndex", rs.getString("GROUP_NAME"));
				informationList.add(rs.getString("GROUP_NAME"));


				JsonObject.put("assetNumberDataIndex", rs.getString("ASSET_NUMBER"));
				informationList.add(rs.getString("ASSET_NUMBER"));


				JsonObject.put("assetTypeDataIndex", rs.getString("ASSET_TYPE"));
				informationList.add(rs.getString("ASSET_TYPE"));

				JsonObject.put("assetModelDataIndex", rs.getString("ASSET_MODEL"));
				informationList.add(rs.getString("ASSET_MODEL"));


				JsonObject.put("selectedDaysDataIndex", rs.getInt("SELECTED_DAYS"));
				informationList.add(rs.getInt("SELECTED_DAYS"));


				JsonObject.put("workingDaysDataIndex",WORKINGDAYS);
				informationList.add(WORKINGDAYS);


				JsonObject.put("nonWorkingDaysDataIndex", rs.getInt("NON_WORKING_DAYS"));
				informationList.add(rs.getInt("NON_WORKING_DAYS"));



				int UTILIZATIONDURINGWORKINGDAYS=0;
				pstmt1 = con.prepareStatement(UtilizationReportsStatements.GET_UTILIZATION_DURING_WORKING_DAYS);
				String AssetNumber=rs.getString("ASSET_NUMBER");
				pstmt1.setInt(1, offset);
				pstmt1.setString(2, startDate);
				pstmt1.setInt(3, offset);
				pstmt1.setString(4, endDate);
				pstmt1.setString(5, AssetNumber);
				rs1=pstmt1.executeQuery();
				if(rs1.next()){
					UTILIZATIONDURINGWORKINGDAYS=rs1.getInt("UTILIZATION_DURING_WORKING_DAYS");
				}
				int NONUTILIZATIONDURINGWORKINGDAYS=WORKINGDAYS-UTILIZATIONDURINGWORKINGDAYS;

				JsonObject.put("utilizationDuringWorkingdaysDataIndex", UTILIZATIONDURINGWORKINGDAYS);
				informationList.add(UTILIZATIONDURINGWORKINGDAYS);

				JsonObject.put("nonUtilizationDuringWorkingdaysDataIndex",NONUTILIZATIONDURINGWORKINGDAYS);
				informationList.add(NONUTILIZATIONDURINGWORKINGDAYS);

				int UtilizedOnHolidays=0;
				int NONWORKINGDAYS=rs.getInt("NON_WORKING_DAYS");
				pstmt2 = con.prepareStatement(UtilizationReportsStatements.GET_Utilized_On_Holidays);
				pstmt2.setInt(1, offset);
				pstmt2.setString(2, startDate);
				pstmt2.setInt(3, offset);
				pstmt2.setString(4, endDate);
				pstmt2.setString(5, AssetNumber);
				rs2=pstmt2.executeQuery();
				if (rs2.next()) {

					UtilizedOnHolidays=rs2.getInt("Utilized_On_Holidays");
				}
				int utilizationPercentage=(int)Math.round((((double)UtilizedOnHolidays/(double)NONWORKINGDAYS)*100));


				JsonObject.put("UtilizedOnHolidaysDataIndex",UtilizedOnHolidays);
				informationList.add(UtilizedOnHolidays);

				JsonObject.put("HRSofIgnitionONDataIndex",decformat.format(HRSofIGNITIONON));
				informationList.add(decformat.format(HRSofIGNITIONON));

				JsonObject.put("travelTimeDataIndex",decformat.format(travelTime));
				informationList.add(decformat.format(travelTime));

				JsonObject.put("distanceTravelledDataIndex", decformat.format(distanceTravelled));
				informationList.add(decformat.format(distanceTravelled));

				JsonObject.put("utilizationPersentDataIndex",utilizationPercentage);
				informationList.add(utilizationPercentage);

				JsonArray.put(JsonObject);
				reporthelper.setInformationList(informationList);
				reportsList.add(reporthelper);
			}

			finalreporthelper.setReportsList(reportsList);
			finalreporthelper.setHeadersList(headersList);
			alist.add(JsonArray);
			alist.add(finalreporthelper);

		} catch (Exception e) {
			e.printStackTrace();
		} finally {

			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return alist;
	}

	public ArrayList < Object > getDataForWorkingDaysWorkingHrsReport(int systemid, int clientid,int assetGruopId,String startdate,String enddate,String language,int offset,int userId)
	{
		JSONArray JsonArray = new JSONArray();
		JSONObject JsonObject = null;

		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		ResultSet rs1 = null;

		ArrayList < ReportHelper > reportsList = new ArrayList < ReportHelper > ();
		ArrayList < String > headersList = new ArrayList < String > ();
		ReportHelper finalreporthelper = new ReportHelper();
		ArrayList < Object > finlist = new ArrayList < Object > ();
		headersList.add(cf.getLabelFromDB("SLNO", language));
		headersList.add(cf.getLabelFromDB("Asset_Group", language));
		headersList.add(cf.getLabelFromDB("Asset_Number", language));
		headersList.add(cf.getLabelFromDB("Asset_Type", language));
		headersList.add(cf.getLabelFromDB("Asset_Model", language));
		headersList.add(cf.getLabelFromDB("Selected_Days", language));
		headersList.add(cf.getLabelFromDB("Working_Days", language));
		headersList.add(cf.getLabelFromDB("Non_Working_Days", language));
		headersList.add(cf.getLabelFromDB("Utilization_In_Working_Days", language));
		headersList.add(cf.getLabelFromDB("Non_Utilization_In_Working_Days", language));
		headersList.add(cf.getLabelFromDB("Utilized_Hrs", language));
		headersList.add(cf.getLabelFromDB("Travel_Time", language));
		headersList.add(cf.getLabelFromDB("Distance_Travelled", language));
		headersList.add(cf.getLabelFromDB("Utilizations", language));
		headersList.add(cf.getLabelFromDB("Non_Utilization_Percentage", language));

		try 
		{
			int count=0;
			String groupstr = "";
			if (assetGruopId !=0) {
				groupstr = " and vc.GROUP_ID="+assetGruopId+" ";
			}
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(UtilizationReportsStatements.GET_DATA_FOR_WORKINGDAYS_WORKINGHRS_REPORT.replace("#", groupstr));
			pstmt.setInt(1,offset);
			pstmt.setString(2,startdate);
			pstmt.setInt(3,offset);
			pstmt.setString(4,enddate);
			pstmt.setInt(5,offset);
			pstmt.setString(6,startdate);
			pstmt.setInt(7,offset);
			pstmt.setString(8,enddate);
			pstmt.setInt(9,systemid);
			pstmt.setInt(10,clientid);
			pstmt.setInt(11,userId);
			pstmt.setInt(12,offset);
			pstmt.setString(13,startdate);
			pstmt.setInt(14,offset);
			pstmt.setString(15,enddate);
			rs = pstmt.executeQuery();
			while (rs.next()) 
			{
				JsonObject = new JSONObject();
				ArrayList < Object > informationList = new ArrayList < Object > ();
				ReportHelper reporthelper = new ReportHelper();
				count++;
				DecimalFormat decformat = new DecimalFormat("#0.00");
				float travelTime=0;
				String assetNumber=rs.getString("ASSET_NUMBER");
				float distanceTravelled=0;
				int utilisedworkinghrs=0;
				pstmt = con.prepareStatement(UtilizationReportsStatements.GET_DATA_FOR_WORKINGDAYS_AND_WORKING_HOURS);
				pstmt.setInt(1,offset);
				pstmt.setString(2,startdate);
				pstmt.setInt(3,offset);
				pstmt.setString(4,enddate);
				pstmt.setString(5,assetNumber);
				rs1 = pstmt.executeQuery();
				if (rs1.next()) 
				{
					int travelTimeInInt=rs1.getInt("TRAVELLED_TIME");
                    
				if (travelTimeInInt!=0) {
					String travel=convertMinutesToHHMMFormatNew(travelTimeInInt);
					travelTime=Float.parseFloat(travel);
		        }
					distanceTravelled=rs1.getFloat("DISTANCE_TRAVELLED");
					utilisedworkinghrs=rs1.getInt("UTILIZED_HOURS");
				}

				informationList.add(count);
				JsonObject.put("slnoIndex", count);

				JsonObject.put("groupIndex", rs.getString("GROUP_NAME"));
				informationList.add(rs.getString("GROUP_NAME"));

				JsonObject.put("registrationIndex",rs.getString("ASSET_NUMBER") );
				informationList.add(rs.getString("ASSET_NUMBER"));

				JsonObject.put("vehicleTypeIndex",rs.getString("ASSET_TYPE"));
				informationList.add(rs.getString("ASSET_TYPE"));
				
				JsonObject.put("assetModelIndex",rs.getString("ASSET_MODEL"));
				informationList.add(rs.getString("ASSET_MODEL"));

				JsonObject.put("selectedDaysIndex",rs.getInt("SELECTED_DAYS"));
				informationList.add(rs.getInt("SELECTED_DAYS"));

				JsonObject.put("workingDaysIndex", rs.getInt("WORKING_DAYS"));
				informationList.add(rs.getInt("WORKING_DAYS"));

				int selectedays=rs.getInt("SELECTED_DAYS");
				int workingdays=rs.getInt("WORKING_DAYS");
				int nonworkingdays=selectedays-workingdays;
				int utilization=rs.getInt("UTILIZATION");

				JsonObject.put("nonWorkingDaysIndex", nonworkingdays);
				informationList.add(nonworkingdays);

				JsonObject.put("utilizationIndex", rs.getInt("UTILIZATION"));
				informationList.add(rs.getInt("UTILIZATION"));

				int nonUtilization=workingdays-utilization;

				JsonObject.put("nonUtilizationIndex", nonUtilization);
				informationList.add(nonUtilization);

				JsonObject.put("utilizedhrsIndex",utilisedworkinghrs);
				informationList.add(utilisedworkinghrs);


				JsonObject.put("travelTimeIndex", decformat.format(travelTime));
				informationList.add(decformat.format(travelTime));

				JsonObject.put("distanceTravelledIndex", decformat.format(distanceTravelled));
				informationList.add(decformat.format(distanceTravelled));

				int utilizationPercent=(int)Math.round((((double)utilisedworkinghrs)/((double)workingdays)*100));

				JsonObject.put("utilizationPercentageIndex",utilizationPercent);
				informationList.add(utilizationPercent);

				int nonUtilizationPercent=100-utilizationPercent;

				JsonObject.put("nonUtilizationPercentageIndex",nonUtilizationPercent);
				informationList.add(nonUtilizationPercent);

				JsonArray.put(JsonObject);
				reporthelper.setInformationList(informationList);
				reportsList.add(reporthelper);
			}
			finalreporthelper.setReportsList(reportsList);
			finalreporthelper.setHeadersList(headersList);
			finlist.add(JsonArray);
			finlist.add(finalreporthelper);
		}
		catch (Exception e) {
			e.printStackTrace();
		} finally {

			DBConnection.releaseConnectionToDB(con, pstmt, rs);
			DBConnection.releaseConnectionToDB(null, null, rs1);
		}
		return finlist;
	}  

	public ArrayList  < Object >  getDataForWorkingDaysAfterWorkingHrsReport(int systemid, int clientid,int assetgroupid,String lang,String startDate,String endDate,int offset,int userId)
	{
		JSONArray JsonArray = new JSONArray();
		JSONObject JsonObject = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		ResultSet rs1 = null;

		ArrayList<ReportHelper> reportsList = new ArrayList<ReportHelper>();
		ArrayList<String> headersList = new ArrayList<String>();
		ReportHelper finalreporthelper = new ReportHelper();
		ArrayList < Object > finlist = new ArrayList < Object > ();

		headersList.add(cf.getLabelFromDB("SLNO", lang));
		headersList.add(cf.getLabelFromDB("Asset_Group", lang));
		headersList.add(cf.getLabelFromDB("Asset_Number", lang));
		headersList.add(cf.getLabelFromDB("Asset_Type", lang));
		headersList.add(cf.getLabelFromDB("Asset_Model", lang));
		headersList.add(cf.getLabelFromDB("Selected_Days", lang));
		headersList.add(cf.getLabelFromDB("Working_Days", lang));
		headersList.add(cf.getLabelFromDB("Non_Working_Days", lang));
		headersList.add(cf.getLabelFromDB("Utilization_In_Working_Days", lang));
		headersList.add(cf.getLabelFromDB("Non_Utilization_In_Working_Days", lang));
		headersList.add(cf.getLabelFromDB("Utilized_On_Non_Working_Hrs", lang));
		headersList.add(cf.getLabelFromDB("Travel_Time", lang));
		headersList.add(cf.getLabelFromDB("Distance_Travelled", lang));
		headersList.add(cf.getLabelFromDB("Utilizations", lang));

		try {
			int count = 0;
			String groupstr = "";
			if (assetgroupid !=0) {
				groupstr = " and vc.GROUP_ID="+assetgroupid+" ";
			}
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(UtilizationReportsStatements.GET_REPORT_FOR_WORKINGDAYS_AFTER_WORKINGHRS.replace("#", groupstr));
			pstmt.setInt(1,offset);
			pstmt.setString(2,startDate);
			pstmt.setInt(3,offset);
			pstmt.setString(4,endDate);
			pstmt.setInt(5,offset);
			pstmt.setString(6,startDate);
			pstmt.setInt(7,offset);
			pstmt.setString(8,endDate);
			pstmt.setInt(9,systemid);
			pstmt.setInt(10,clientid);
			pstmt.setInt(11,userId);
			pstmt.setInt(12,offset);
			pstmt.setString(13,startDate);
			pstmt.setInt(14,offset);
			pstmt.setString(15,endDate);
			rs = pstmt.executeQuery();
			while (rs.next()) {

				JsonObject = new JSONObject();
				ArrayList < Object > informationList = new ArrayList < Object > ();
				ReportHelper reporthelper = new ReportHelper();
				count++;
				DecimalFormat decformat = new DecimalFormat("#0.00");

				String assetNumber=rs.getString("ASSET_NUMBER");
				float distanceTravelled=0;
				int utilisedworkinghrs=0;
				pstmt = con.prepareStatement(UtilizationReportsStatements.GET_DATA_FOR_TRAVEL_TIME_AND_DISTANCE);
				pstmt.setInt(1,offset);
				pstmt.setString(2,startDate);
				pstmt.setInt(3,offset);
				pstmt.setString(4,endDate);
				pstmt.setString(5,assetNumber);
				rs1 = pstmt.executeQuery();
				float travelTime=0;
				if (rs1.next()) 
				{
					int travelTimeInInt=rs1.getInt("TRAVEL_TIME");

					if (travelTimeInInt!=0) {
					String travel=convertMinutesToHHMMFormatNew(travelTimeInInt);
					travelTime=Float.parseFloat(travel);
					}
					distanceTravelled=rs1.getFloat("DISTANCE_TRAVELLED");
					utilisedworkinghrs=rs1.getInt("UTILIZED_HRS");
					}

				informationList.add(count);
				JsonObject.put("slnoIndex", count);

				JsonObject.put("groupnameIndex", rs.getString("GROUP_NAME"));
				informationList.add(rs.getString("GROUP_NAME"));

				JsonObject.put("AssetnumberIndex", rs.getString("ASSET_NUMBER"));
				informationList.add(rs.getString("ASSET_NUMBER"));

				JsonObject.put("AssettypeIndex", rs.getString("ASSET_TYPE"));
				informationList.add(rs.getString("ASSET_TYPE"));
				
				JsonObject.put("AssetmodelIndex", rs.getString("ASSET_MODEL"));
				informationList.add(rs.getString("ASSET_MODEL"));

				JsonObject.put("selecteddaysIndex", rs.getInt("SELECTED_DAYS"));
				informationList.add(rs.getInt("SELECTED_DAYS"));

				JsonObject.put("workingdaysIndex",rs.getInt("WORKING_DAYS"));
				informationList.add(rs.getInt("WORKING_DAYS"));

				int selectedDays=rs.getInt("SELECTED_DAYS");
				int workingDays=rs.getInt("WORKING_DAYS");
				int nonWorkingDays=selectedDays-workingDays;

				JsonObject.put("nonworkingdaysIndex", nonWorkingDays);
				informationList.add(nonWorkingDays);

				JsonObject.put("utilizationperdayIndex", rs.getInt("UTILIZATION"));
				informationList.add(rs.getInt("UTILIZATION"));

				int utilization=rs.getInt("UTILIZATION");
				int nonUtilization=workingDays-utilization;

				JsonObject.put("nonutilizationperdayIndex", nonUtilization);
				informationList.add(nonUtilization);

				JsonObject.put("utilizedonnonworkinghrsIndex", utilisedworkinghrs);
				informationList.add(utilisedworkinghrs);

				int UtilizationPercentage=(int)Math.round((((double)utilisedworkinghrs)/((double)workingDays)*100));

				JsonObject.put("TraveltimeIndex",decformat.format(travelTime));
				informationList.add(decformat.format(travelTime));

				JsonObject.put("distancetravelledIndex", decformat.format(distanceTravelled));
				informationList.add(decformat.format(distanceTravelled));

				JsonObject.put("utilizationIndex", UtilizationPercentage);
				informationList.add(UtilizationPercentage);

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
			DBConnection.releaseConnectionToDB(null, null, rs1);
		}
		return finlist;
	}

	public ArrayList < Object > getUtilizationSummaryReport(int systemId, int customerId,int assetGroupId,int userId,String language,String startDate,String endDate,int offset) {

		JSONArray JsonArray = new JSONArray();
		JSONObject JsonObject = null;

		Connection con = null;
		PreparedStatement pstmt4 = null;
		ResultSet rs4 = null;

		PreparedStatement pstmt5 = null;
		ResultSet rs5 = null;

		PreparedStatement pstmt6 = null;
		ResultSet rs6 = null;

		PreparedStatement pstmt7 = null;
		ResultSet rs7 = null;

		PreparedStatement pstmt8 = null;
		ResultSet rs8 = null;

		DecimalFormat decformat = new DecimalFormat("#0.00");
		ArrayList < ReportHelper > reportsList = new ArrayList < ReportHelper > ();
		ArrayList < String > headersList = new ArrayList < String > ();
		ReportHelper finalreporthelper = new ReportHelper();
		ArrayList < Object > aslist = new ArrayList < Object > ();

		headersList.add(cf.getLabelFromDB("SLNO", language));
		headersList.add(cf.getLabelFromDB("Asset_Group", language));
		headersList.add(cf.getLabelFromDB("Asset_Number", language));
		headersList.add(cf.getLabelFromDB("Asset_Type", language));
		headersList.add(cf.getLabelFromDB("Asset_Model", language));
		headersList.add(cf.getLabelFromDB("Selected_Days", language));
		headersList.add(cf.getLabelFromDB("Working_Days", language));
		headersList.add(cf.getLabelFromDB("Non_Working_Days", language));
		headersList.add(cf.getLabelFromDB("Utilization_During_Working_Days", language));
		headersList.add(cf.getLabelFromDB("Utilization_During_Working_Hrs", language));
		headersList.add(cf.getLabelFromDB("Utilization_After_Working_Hrs", language));
		headersList.add(cf.getLabelFromDB("Utilization_During_Working_Holidays_And_Weekends", language));
		try {
			String groupstr = "";
			if (assetGroupId!=0) {
				groupstr = " and vc.GROUP_ID="+assetGroupId +" ";
			}

			int count = 0;
			con = DBConnection.getConnectionToDB("AMS");
			pstmt4 = con.prepareStatement(UtilizationReportsStatements.GET_UTILIZATION_SUMMARY_REPORT.replace("#", groupstr));
			pstmt4.setInt(1, offset);
			pstmt4.setString(2, startDate);
			pstmt4.setInt(3, offset);
			pstmt4.setString(4, endDate);
			pstmt4.setInt(5, systemId);
			pstmt4.setInt(6, customerId);
			pstmt4.setInt(7, userId);
			pstmt4.setInt(8, offset);
			pstmt4.setString(9, startDate);
			pstmt4.setInt(10, offset);
			pstmt4.setString(11, endDate);
			rs4 = pstmt4.executeQuery();
			while (rs4.next()) {
				JsonObject = new JSONObject();
				ArrayList < Object > informationList = new ArrayList < Object > ();
				ReportHelper reporthelper = new ReportHelper();
				count++;
				String AssetNumber=rs4.getString("ASSET_NUMBER");

				int selectedDays=rs4.getInt("SELECTED_DAYS");
				int WorkingDays=rs4.getInt("WORKING_DAYS");
				int NON_WORKING_DAYS=selectedDays-WorkingDays;

				informationList.add(count);
				JsonObject.put("slnoIndex", count);

				JsonObject.put("groupNameDataIndex", rs4.getString("GROUP_NAME"));
				informationList.add(rs4.getString("GROUP_NAME"));

				JsonObject.put("assetNumberDataIndex", rs4.getString("ASSET_NUMBER"));
				informationList.add(rs4.getString("ASSET_NUMBER"));

				JsonObject.put("assetTypeDataIndex", rs4.getString("ASSET_TYPE"));
				informationList.add(rs4.getString("ASSET_TYPE"));
				
				JsonObject.put("assetModelDataIndex", rs4.getString("ASSET_MODEL"));
				informationList.add(rs4.getString("ASSET_MODEL"));
				
				JsonObject.put("selectedDaysDataIndex",selectedDays);
				informationList.add(selectedDays);

				JsonObject.put("workingDaysDataIndex",WorkingDays);
				informationList.add(WorkingDays);

				JsonObject.put("nonWorkingDaysDataIndex", NON_WORKING_DAYS);
				informationList.add(NON_WORKING_DAYS);

				int UTILIZATION_DURING_WORKINGDAYS=0;
				pstmt5 = con.prepareStatement(UtilizationReportsStatements.GET_SUMMARY_UTILIZATION_DURING_WORKING_DAYS);
				pstmt5.setInt(1, offset);
				pstmt5.setString(2, startDate);
				pstmt5.setInt(3, offset);
				pstmt5.setString(4, endDate);
				pstmt5.setString(5, AssetNumber);
				rs5=pstmt5.executeQuery();
				if(rs5.next()){
					UTILIZATION_DURING_WORKINGDAYS=rs5.getInt("UTILIZATION_DURING_WORKING_DAYS");
				}

				//---------formula---------
				int UTILIZATION_PERCENTAGE_DURING_WORKINGDAYS=(int)Math.round((((double)UTILIZATION_DURING_WORKINGDAYS/(double)WorkingDays)*100));

				JsonObject.put("UtilizationDuringWorkingDaysDataIndex", UTILIZATION_PERCENTAGE_DURING_WORKINGDAYS);
				informationList.add(UTILIZATION_PERCENTAGE_DURING_WORKINGDAYS);

				int UTILIZATION_DURING_WORKING_HRS=0;
				pstmt6 = con.prepareStatement(UtilizationReportsStatements.GET_UTILIZATION_DURING_WORKING_HRS);
				pstmt6.setInt(1,offset);
				pstmt6.setString(2,startDate);
				pstmt6.setInt(3, offset);
				pstmt6.setString(4,endDate);
				pstmt6.setString(5,AssetNumber);
				rs6=pstmt6.executeQuery();
				if(rs6.next()){
					UTILIZATION_DURING_WORKING_HRS=rs6.getInt("UTILIZATION_DURING_WORKING_HRS");
				}
				int UTILIZATION_PERCENTAGE_DURING_WORKING_HRS=(int)Math.round((((double)UTILIZATION_DURING_WORKING_HRS/(double)WorkingDays)*100));

				JsonObject.put("UtilizationDuringWorkingHrsDataIndex", UTILIZATION_PERCENTAGE_DURING_WORKING_HRS);
				informationList.add(UTILIZATION_PERCENTAGE_DURING_WORKING_HRS);

				int UTILIZATIONAFTERWORKINGHRS=0;
				pstmt7 = con.prepareStatement(UtilizationReportsStatements.GET_UTILIZATION_AFTER_WORKING_HRS);
				pstmt7.setInt(1, offset);
				pstmt7.setString(2, startDate);
				pstmt7.setInt(3, offset);
				pstmt7.setString(4, endDate);
				pstmt7.setString(5, AssetNumber);
				rs7=pstmt7.executeQuery();
				if(rs7.next()){

					UTILIZATIONAFTERWORKINGHRS=rs7.getInt("UTILIZATION_AFTER_WORKING_HRS");
				}
				int UTILIZATIONPERCENTAGEAFTERWORKINGHRS=(int)Math.round((((double)UTILIZATIONAFTERWORKINGHRS/(double)WorkingDays)*100));

				JsonObject.put("UtilizationAfterWorkingHrsDataIndex", UTILIZATIONPERCENTAGEAFTERWORKINGHRS);
				informationList.add(UTILIZATIONPERCENTAGEAFTERWORKINGHRS);

				int UTILIZATION_DURING_WORKING_HOLIDAYS=0;
				pstmt8 = con.prepareStatement(UtilizationReportsStatements.GET_UTILIZATION_DURING_WORKING_HOLIDAYS_AND_WEEKEDS);
				pstmt8.setInt(1, offset);
				pstmt8.setString(2, startDate);
				pstmt8.setInt(3, offset);
				pstmt8.setString(4, endDate);
				pstmt8.setString(5, AssetNumber);
				rs8=pstmt8.executeQuery();
				if(rs8.next()){
					UTILIZATION_DURING_WORKING_HOLIDAYS=rs8.getInt("UTILIZATION_DURING_WORKING_HOLIDAYS_AND_WEEKEDS");
				}

				int UTILIZATION_PERCENTAGE_DURING_WORKING_HOLIDAYS=(int)Math.round((((double)UTILIZATION_DURING_WORKING_HOLIDAYS/(double)NON_WORKING_DAYS)*100));

				JsonObject.put("UtilizationDuringWorkingHolidaysAndWeekendsDataIndex", UTILIZATION_PERCENTAGE_DURING_WORKING_HOLIDAYS);
				informationList.add(UTILIZATION_PERCENTAGE_DURING_WORKING_HOLIDAYS);

				JsonArray.put(JsonObject);
				reporthelper.setInformationList(informationList);
				reportsList.add(reporthelper);
			}

			finalreporthelper.setReportsList(reportsList);
			finalreporthelper.setHeadersList(headersList);
			aslist.add(JsonArray);
			aslist.add(finalreporthelper);

		} catch (Exception e) {
			e.printStackTrace();
		} finally {

			DBConnection.releaseConnectionToDB(con, pstmt8, rs8);
			DBConnection.releaseConnectionToDB(null, pstmt7, rs7);
			DBConnection.releaseConnectionToDB(null, pstmt6, rs6);
			DBConnection.releaseConnectionToDB(null, pstmt5, rs5);
			DBConnection.releaseConnectionToDB(null, pstmt4, rs4);
		}
		return aslist;
	}

	public ArrayList < Object > getUtilizationWorkingReport(int systemId, int customerId,int userId,String language,String startDate,String endDate,int offset,String zone,int groupId) {

		JSONArray JsonArray = new JSONArray();
		JSONObject JsonObject = null;

		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		DecimalFormat decformat = new DecimalFormat("#0.00");
		ArrayList < ReportHelper > reportsList = new ArrayList < ReportHelper > ();
		ArrayList < String > headersList = new ArrayList < String > ();
		ReportHelper finalreporthelper = new ReportHelper();
		ArrayList < Object > finlist = new ArrayList < Object > ();
		try {

			headersList.add(cf.getLabelFromDB("SLNO", language));
			headersList.add(cf.getLabelFromDB("Asset_Group", language));
			headersList.add(cf.getLabelFromDB("Asset_Number", language));
			headersList.add(cf.getLabelFromDB("Asset_Type", language));
			headersList.add(cf.getLabelFromDB("Asset_Model", language));
			headersList.add(cf.getLabelFromDB("Selected_Days", language));
			headersList.add(cf.getLabelFromDB("Working_Days", language));
			headersList.add(cf.getLabelFromDB("Non_Working_Days", language));
			headersList.add(cf.getLabelFromDB("Utilization", language));
			headersList.add(cf.getLabelFromDB("Non_Utilization", language));
			headersList.add(cf.getLabelFromDB("Travel_Time", language));
			headersList.add(cf.getLabelFromDB("Distance_Travelled", language));
			headersList.add(cf.getLabelFromDB("Utilizations", language));

			int count = 0;
			String groupstr = "";
			if (groupId !=0) {
				groupstr = " and vc.GROUP_ID="+groupId+" ";
			}
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(UtilizationReportsStatements.GET_UTILIZATION_WORKING_REPORT.replace("#", groupstr));
			pstmt.setInt(1, offset);
			pstmt.setString(2, startDate);
			pstmt.setInt(3, offset);
			pstmt.setString(4, endDate);
			pstmt.setInt(5, offset);
			pstmt.setString(6, startDate);
			pstmt.setInt(7, offset);
			pstmt.setString(8, endDate);
			pstmt.setInt(9, offset);
			pstmt.setString(10, startDate);
			pstmt.setInt(11, offset);
			pstmt.setString(12, endDate);
			pstmt.setInt(13, systemId);
			pstmt.setInt(14, customerId);
			pstmt.setInt(15, userId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				JsonObject = new JSONObject();
				ArrayList < Object > informationList = new ArrayList < Object > ();
				ReportHelper reporthelper = new ReportHelper();
				count++;
				
				 int travelTimeInInt=rs.getInt("TRAVEL_TIME");
	             float travelTime=0;
				 if (travelTimeInInt!=0) {
						String travel=convertMinutesToHHMMFormatNew(travelTimeInInt);
						travelTime=Float.parseFloat(travel);
				     }
					
				float distanceTravelled=rs.getFloat("DISTANCE_TRAVELLED");

				informationList.add(count);
				JsonObject.put("slnoIndex", count);

				JsonObject.put("groupNameDataIndex", rs.getString("GROUP_NAME"));
				informationList.add(rs.getString("GROUP_NAME"));

				JsonObject.put("assetNumberDataIndex", rs.getString("ASSET_NUMBER"));
				informationList.add(rs.getString("ASSET_NUMBER"));

				JsonObject.put("vehicleTypeDataIndex", rs.getString("ASSET_TYPE"));
				informationList.add(rs.getString("ASSET_TYPE"));
				
				JsonObject.put("assetModelDataIndex", rs.getString("ASSET_MODEL"));
				informationList.add(rs.getString("ASSET_MODEL"));

				JsonObject.put("selectedDaysDataIndex", rs.getInt("SELECTED_DAYS"));
				informationList.add(rs.getInt("SELECTED_DAYS"));

				JsonObject.put("workingDaysDataIndex",rs.getInt("WORKING_DAYS"));
				informationList.add(rs.getInt("WORKING_DAYS"));

				int workingDays=rs.getInt("WORKING_DAYS");
				int selectedDays=rs.getInt("SELECTED_DAYS");
				int nonWorkingDays=selectedDays-workingDays;

				int utilization=rs.getInt("UTILIZATION");

				int nonUtilization=workingDays-utilization;

				int utilizationPercent=(int)Math.round((((double)utilization)/((double)workingDays)*100));

				JsonObject.put("nonWorkingDaysDataIndex", nonWorkingDays);
				informationList.add(nonWorkingDays);

				JsonObject.put("utilizationDataIndex", rs.getInt("UTILIZATION"));
				informationList.add(rs.getInt("UTILIZATION"));

				JsonObject.put("nonUtilizationDataIndex", nonUtilization);
				informationList.add(nonUtilization);

				
				JsonObject.put("travelTimeDataIndex",decformat.format(travelTime));
				informationList.add(decformat.format(travelTime));
				
				JsonObject.put("distanceTravelledDataIndex", decformat.format(distanceTravelled));
				informationList.add(decformat.format(distanceTravelled));

				JsonObject.put("utilizationPersentDataIndex", utilizationPercent);
				informationList.add(utilizationPercent);

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

	public String convertMinutesToHHMMFormatNew(int minutes)
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
