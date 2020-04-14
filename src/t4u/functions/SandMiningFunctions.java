package t4u.functions;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Properties;

import org.apache.commons.lang.StringUtils;
import org.json.JSONArray;
import org.json.JSONObject;

import t4u.beans.ReportHelper;
import t4u.common.ApplicationListener;
import t4u.common.DBConnection;
import t4u.statements.AdminStatements;
import t4u.statements.CommonStatements;
import t4u.statements.IronMiningStatement;
import t4u.statements.SandMiningStatements;

/**
 * @author Nikhil
 * 
 */
public class SandMiningFunctions {

	CommonFunctions cfuncs = new CommonFunctions();
	SimpleDateFormat sdfyyyymmddhhmmss = new SimpleDateFormat(
			"dd-MM-yyyy HH:mm:ss");
	SimpleDateFormat sdfyyyymmddhhmmss1 = new SimpleDateFormat(
	"yyyy-MM-dd HH:mm:ss");
	SimpleDateFormat sdfyyyymmdd = new SimpleDateFormat("dd-MM-yyyy");
	SimpleDateFormat sdfmmddyyyyhhmmss = new SimpleDateFormat(
			"MM/dd/yyyy HH:mm:ss");
	SimpleDateFormat sdfddmmyyyy = new SimpleDateFormat("dd/MM/yyyy");
	SimpleDateFormat sdfmmddyyyy = new SimpleDateFormat("MM/dd/yyyy");
	SimpleDateFormat sfddMMYYYY = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
	SimpleDateFormat ddMMyyyyHHmmss = new SimpleDateFormat(
			"dd-MM-yyyy HH:mm:ss");
	CommonFunctions cf = new CommonFunctions();
	AlertFunctions alfunc=new AlertFunctions();
	DecimalFormat df = new DecimalFormat("#.##");
	/**
	 * Get details for vehicle non communicating more then 24hrs
	 * 
	 * @param customerid
	 * @param systemId
	 * @param zone
	 * @return
	 */
	public ArrayList<Object> getGridNonCommunicatingRep(String customerid,
			int systemId, int offmin, String language, int userId) {
		JSONArray JsonArray = new JSONArray();
		JSONObject JsonObject = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String totalVehicles = "";
		int noncommhours = 360;
		int count = 0;

		ArrayList<ReportHelper> reportsList = new ArrayList<ReportHelper>();
		ArrayList<String> headersList = new ArrayList<String>();
		ReportHelper finalreporthelper = new ReportHelper();
		ArrayList<Object> finlist = new ArrayList<Object>();
		headersList.add(cf.getLabelFromDB("SLNO", language));
		headersList
				.add(cf.getLabelFromDB("Non_Communicating_Assets", language));
		headersList.add(cf.getLabelFromDB("Last_Location", language));
		headersList.add(cf.getLabelFromDB("Last_Communicated_Date_Time",
				language));
		headersList.add(cf.getLabelFromDB("Owner_Name", language));
		headersList.add(cf.getLabelFromDB("Contact_Number", language));
		try {
			JsonArray = new JSONArray();
			JsonObject = new JSONObject();
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con
					.prepareStatement(SandMiningStatements.GET_NON_COMM_PERCENTAGE);
			pstmt.setInt(1, Integer.parseInt(customerid));
			pstmt.setInt(2, systemId);
			pstmt.setInt(3, userId);
			pstmt.setInt(4, Integer.parseInt(customerid));
			pstmt.setInt(5, systemId);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				totalVehicles = rs.getString("REGISTRATION_NO");
				if (rs.getInt("NON_COMM_HOURS") != 0) {
					noncommhours = rs.getInt("NON_COMM_HOURS");
				}
			}
			pstmt = null;
			rs = null;
			pstmt = con
					.prepareStatement(SandMiningStatements.GET_TOTAL_NON_COMM_VEHICLES);
			pstmt.setInt(1, offmin);
			pstmt.setInt(2, userId);
			pstmt.setInt(3, Integer.parseInt(customerid));
			pstmt.setInt(4, systemId);
			pstmt.setInt(5, noncommhours);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				JsonObject = new JSONObject();
				ArrayList<String> informationList = new ArrayList<String>();
				ReportHelper reporthelper = new ReportHelper();
				count++;
				informationList.add(Integer.toString(count));
				JsonObject.put("slnoIndex", Integer.toString(count));
				String regno = rs.getString("REGISTRATION_NO");
				String location = rs.getString("LOCATION");
				Date lastcommdatetime = rs.getTimestamp("GMT");
				String ownername = rs.getString("OwnerName");
				String ownercontactno = rs.getString("OwnerContactNo");
				JsonObject.put("totalvehicles", totalVehicles);
				JsonObject.put("noncommhours", noncommhours);
				JsonObject.put("noncomid", regno);
				informationList.add(regno);
				JsonObject.put("lastloc", location);
				informationList.add(location);
				JsonObject.put("lastcondatetime", sdfyyyymmddhhmmss
						.format(lastcommdatetime));
				informationList.add(sdfyyyymmddhhmmss.format(lastcommdatetime));
				JsonObject.put("ownername", ownername);
				informationList.add(ownername);
				JsonObject.put("contactnumber", ownercontactno);
				informationList.add(ownercontactno);
				JsonArray.put(JsonObject);
				reporthelper.setInformationList(informationList);
				reportsList.add(reporthelper);
			}
			finlist.add(JsonArray);
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
	public ArrayList<Object> getGridNonCommunicatingVehData(String customerid,int systemId, int offmin, String language, int userId,String startdate,String enddate) {
		JSONArray JsonArray = new JSONArray();
		JSONObject JsonObject = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		PreparedStatement pstmt1 = null;
		ResultSet rs1 = null;
		String vehicleNo="";
		int noncommminutes = 30;
		int count = 0;
		ArrayList<ReportHelper> reportsList = new ArrayList<ReportHelper>();
		ArrayList<String> headersList = new ArrayList<String>();
		ReportHelper finalreporthelper = new ReportHelper();
		ArrayList<Object> finlist = new ArrayList<Object>();
		headersList.add(cf.getLabelFromDB("SLNO", language));
		headersList.add("Vehicle/Boat RegistrationNo");
		headersList.add("Start of NonCommunication");
		headersList.add("Stop of NonCommunication");
		headersList.add("Non Communicating Hrs");
		try {
			JsonArray = new JSONArray();
			JsonObject = new JSONObject();
			con = DBConnection.getConnectionToDB("AMS");
			pstmt1 = null;
			rs1 = null;
			pstmt1=con.prepareStatement("select distinct REGISTRATION_NO from dbo.gpsdata_history_latest where System_id=? and CLIENTID=? order by REGISTRATION_NO ");
			pstmt1.setInt(1, systemId);
			pstmt1.setString(2, customerid);
			rs1 = pstmt1.executeQuery();
			while(rs1.next()){
				vehicleNo=rs1.getString("REGISTRATION_NO");
				//vehicleNo=vehicleNo+"'"+rs.getString("REGISTRATION_NO")+"',";
				//vehicleNo=vehicleNo.substring(0,vehicleNo.lastIndexOf(","));
				pstmt = con.prepareStatement("with CTE AS(SELECT g.REGISTRATION_NO,g.GMT FROM HISTORY_DATA_"+systemId+" g where g.REGISTRATION_NO=? and g.GMT between ? and ? and g.CLIENTID=? "+ 
						"union SELECT gps.REGISTRATION_NO,gps.GMT FROM AMS_Archieve.dbo.GE_DATA_"+systemId+" gps where gps.REGISTRATION_NO=? and gps.GMT between ? and ? and gps.CLIENTID=? ), "+ 
						"CTE2 as(select REGISTRATION_NO,rownum = ROW_NUMBER() OVER (ORDER BY GMT ),GMT from CTE) SELECT isnull(cur.REGISTRATION_NO,'') as VehicleNo,isnull(DATEDIFF(mi,prev.GMT,cur.GMT),'')as NONCOMMMIN,dateadd(mi,?,cur.GMT) as STOPTIME, "+
						"dateadd(mi,?,prev.GMT) as STARTTIME FROM CTE2 cur INNER JOIN CTE2 prev on prev.rownum = cur.rownum - 1 and prev.REGISTRATION_NO=cur.REGISTRATION_NO where DATEDIFF(mi,prev.GMT,cur.GMT)>? ");
				pstmt.setString(1, vehicleNo);
				pstmt.setString(2, startdate);
				pstmt.setString(3, enddate);
				pstmt.setString(4, customerid);
				pstmt.setString(5, vehicleNo);
				pstmt.setString(6, startdate);
				pstmt.setString(7, enddate);
				pstmt.setString(8, customerid);
				pstmt.setInt(9, offmin);
				pstmt.setInt(10, offmin);
				pstmt.setInt(11, noncommminutes);
				rs = pstmt.executeQuery();
				while (rs.next()) {
					JsonObject = new JSONObject();
					ArrayList<String> informationList = new ArrayList<String>();
					ReportHelper reporthelper = new ReportHelper();
					count++;
					informationList.add(Integer.toString(count));
					JsonObject.put("slnoIndex", Integer.toString(count));
					informationList.add(rs.getString("VehicleNo"));
					JsonObject.put("vehnoIndex", rs.getString("VehicleNo"));
					informationList.add(rs.getString("STARTTIME"));
					JsonObject.put("startnoncomdatetime",rs.getString("STARTTIME"));
					informationList.add(rs.getString("STOPTIME"));
					JsonObject.put("stopnoncomdatetime", rs.getString("STOPTIME"));
					informationList.add(rs.getString("NONCOMMMIN"));
					JsonObject.put("noncommHrs", rs.getString("NONCOMMMIN"));
					JsonArray.put(JsonObject);
					reporthelper.setInformationList(informationList);
					reportsList.add(reporthelper);
				}}
			finlist.add(JsonArray);
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
	public ArrayList<Object> getUnauthorizedPortEntryReport(String customerid,
			 String startdate, String enddate, int systemId,
			String zone, int offset, String language, int userId,JSONArray js) {
		JSONArray JsonArray = new JSONArray();
		JSONObject JsonObject = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;
		PreparedStatement pstmt1 = null;
		ResultSet rs = null;
		int count = 0;
		String vehicleNos="";
		startdate=startdate.replace('T', ' ');
		enddate=enddate.replace('T', ' ');
		ArrayList<ReportHelper> reportsList = new ArrayList<ReportHelper>();
		ArrayList<String> headersList = new ArrayList<String>();
		ReportHelper finalreporthelper = new ReportHelper();
		ArrayList<Object> finlist = new ArrayList<Object>();
		headersList.add(cf.getLabelFromDB("SLNO", language));
		headersList.add(cf.getLabelFromDB("Asset_No", language));
		headersList.add("Asset Group");
		headersList.add(cf.getLabelFromDB("Sand_Block_Name", language));
		headersList.add(cf.getLabelFromDB("Arriving_Date_Time", language));
		headersList.add(cf.getLabelFromDB("Detention", language));
		headersList.add(cf.getLabelFromDB("Remarks", language));
		try {
			for (int i = 0; i < js.length(); i++) {
				 JSONObject obj = js.getJSONObject(i);
				 vehicleNos=vehicleNos+"'"+obj.getString("AssetNoIndex")+"',";
			 }
			vehicleNos=vehicleNos.substring(0,vehicleNos.lastIndexOf(","));
			JsonArray = new JSONArray();
			JsonObject = new JSONObject();
			con = DBConnection.getConnectionToDB("AMS");

            	pstmt = con.prepareStatement("select ASSET_NUMBER,isnull(u.REMARKS,'') as REMARKS,s.Port_Name as SAND_BLOCK,l.NAME,dateadd(mi,?,ARRIVAL_TIME) as ARRIVAL_TIME,isnull(DETENTION,0) as DETENTION,isnull(lvs.GROUP_NAME,'') as ASSET_GROUP from dbo.UNAUTHORIZED_PORT_ENTRY u "
            			+ "left outer join dbo.LOCATION_ZONE_A l on l.HUBID=u.HUB_ID "
            			+ "left outer join dbo.Sand_Port_Details s on s.UniqueId=u.PORT_NO "
            			+ " left outer join AMS.dbo.Live_Vision_Support lvs on lvs.REGISTRATION_NO=u.ASSET_NUMBER "
            			+ "where u.SYSTEM_ID=? and u.CUSTOMER_ID=? and  ARRIVAL_TIME between dateadd(mi,-?,?) and dateadd(mi,-?,?) and ASSET_NUMBER in ("+vehicleNos+") order by ASSET_NUMBER desc");
				pstmt.setInt(1, offset);
				pstmt.setInt(2, systemId);
				pstmt.setInt(3, Integer.parseInt(customerid));
				pstmt.setInt(4, offset);
				pstmt.setString(5, startdate);
				pstmt.setInt(6, offset);
				pstmt.setString(7, enddate);
				//pstmt.setString(8, vehicleNos);
				rs = pstmt.executeQuery();
            
			
			while (rs.next()) {
				count++;
				ArrayList<String> informationList = new ArrayList<String>();
				
				ReportHelper reporthelper = new ReportHelper();
				JsonObject = new JSONObject();
				
				JsonObject.put("slnoIndex", Integer.toString(count));
				informationList.add(Integer.toString(count));
				String asset = rs.getString("ASSET_NUMBER");
				String sand = rs.getString("SAND_BLOCK");
				Date date = rs.getTimestamp("ARRIVAL_TIME");
				// String detention=rs.getString("DETENTION");
				int detention1 = Integer.parseInt(rs.getString("DETENTION"));
				// int detention1=Integer.parseInt(detention);
				String detention = cfuncs.convertMinutesToHHMMFormat(detention1);
				String remarks=rs.getString("REMARKS");
				String groupName = rs.getString("ASSET_GROUP");
				JsonObject.put("AssetNo", asset);
				informationList.add(asset);
				JsonObject.put("assetGroupName", groupName);
				informationList.add(groupName);
				JsonObject.put("SandBlockName", sand);
				informationList.add(sand); 
				JsonObject.put("ArrivingDateTime", sdfyyyymmddhhmmss1
						.format(date));
				informationList.add(sdfyyyymmddhhmmss.format(date));
				JsonObject.put("Detention(HH:MM)", detention);
				informationList.add(detention);
				JsonObject.put("Remarks", remarks);
				informationList.add(remarks);
				JsonArray.put(JsonObject);
				reporthelper.setInformationList(informationList);
				reportsList.add(reporthelper);
			}
			finlist.add(JsonArray);
			finalreporthelper.setReportsList(reportsList);
			finalreporthelper.setHeadersList(headersList);
			finlist.add(finalreporthelper);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
			DBConnection.releaseConnectionToDB(con, pstmt1, rs);
		}

		return finlist;
	}

	public JSONArray getSandPortWisePermitCount(String customerid,
			String startdate, String enddate, int systemId, String zone,
			int offmin, String lang, int userId) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		JSONArray jsonarray = new JSONArray();
		JSONObject jsonobject = null;
		String portname = "";
		int tripsheetcount = 0;
		String groupname = "";
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con
					.prepareStatement(SandMiningStatements.GET_PORT_WISE_COUNT_BTW_DATES);
			pstmt.setInt(1, offmin);
			pstmt.setString(2, startdate);
			pstmt.setInt(3, offmin);
			pstmt.setString(4, enddate);
			pstmt.setString(5, customerid);
			pstmt.setInt(6, systemId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				jsonobject = new JSONObject();
				portname = rs.getString("Port_Name");
				tripsheetcount = rs.getInt("TRIPSHEET_COUNT");
				groupname = rs.getString("GROUP_NAME");
				jsonobject.put("port", portname);
				jsonobject.put("count", tripsheetcount);
				jsonobject.put("groupname", groupname);
				jsonarray.put(jsonobject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jsonarray;
	}

	public String insertVehicleInformation(String ApplicationNo, String Date,
			String VehicleRegistrationNo, String InsuranceNo,
			String InsuranceexpDate, String FitnessExpdate,
			String PollutionexpDate, String NameOfRegowner,
			String PermanentAdd, String TemporaryAdd, String ContactNumber,
			String GrossWeight, String UnLadenWeight, String Rto,
			String PermitNo, String PermitExpDate, String LoadingCapacity,
			String YearOfManf, int systemId, int offset, String sms, int userId) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String message = "";

		int maxuid = 1;
		try {

			con = DBConnection.getConnectionToDB("AMS");

			pstmt = con.prepareStatement(SandMiningStatements.SELECT_MAXUID);
			pstmt.setInt(1, systemId);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				maxuid = rs.getInt("MAXUID") + 1;
			}
			pstmt = null;
			pstmt = con
					.prepareStatement(SandMiningStatements.INSERT_VEHICLE_DETAILS);
			pstmt.setString(1, ApplicationNo);
			pstmt.setString(2, Date);
			pstmt.setString(3, VehicleRegistrationNo);
			pstmt.setString(4, InsuranceNo);
			pstmt.setString(5, InsuranceexpDate);
			pstmt.setString(6, FitnessExpdate);
			pstmt.setString(7, PollutionexpDate);
			pstmt.setString(8, NameOfRegowner);
			pstmt.setString(9, PermanentAdd);
			pstmt.setString(10, TemporaryAdd);
			pstmt.setString(11, ContactNumber);
			pstmt.setString(12, GrossWeight);
			pstmt.setString(13, UnLadenWeight);
			pstmt.setString(14, Rto);
			pstmt.setString(15, PermitNo);
			pstmt.setString(16, PermitExpDate);
			pstmt.setString(17, LoadingCapacity);
			pstmt.setString(18, YearOfManf);
			pstmt.setInt(19, systemId);
			pstmt.setInt(20, maxuid);
			pstmt.setInt(21, userId);
			// pstmt.setInt(22,userId);

			int result = pstmt.executeUpdate();
			if (result > 0) {

				if (sms.equals("true")) {

					pstmt = null;
					pstmt = con
							.prepareStatement(SandMiningStatements.FETCH_VALUE_FOR_SENDING_SMS);
					pstmt.setInt(1, systemId);
					rs = pstmt.executeQuery();
					String name = "";
					String unumber = String.valueOf(maxuid);
					unumber = getFormated4DigitNumber(unumber);
					if (rs.next()) {
						name = rs.getString("value");
					}
					pstmt = null;
					pstmt = con
							.prepareStatement(SandMiningStatements.FETCH_CLIENTID_FOR_SENDING_SMS);
					pstmt.setInt(1, systemId);
					rs = pstmt.executeQuery();
					int Client = 0;

					if (rs.next()) {

						Client = rs.getInt("Client_Id");
					}
					if (Client > 0) {
						String Message = "Asset "
								+ VehicleRegistrationNo
								+ " has been enlisted and associated unique id is "
								+ name + "-" + unumber;
						pstmt = null;
						pstmt = con
								.prepareStatement(SandMiningStatements.INSERT_SMS);
						pstmt.setString(1, ContactNumber.trim());
						pstmt.setString(2, Message);
						pstmt.setString(3, "N");
						pstmt.setInt(4, Client);
						pstmt.setInt(5, systemId);
						pstmt.setString(6, VehicleRegistrationNo);
						pstmt.setString(7, name + "-" + unumber);
						pstmt.setString(8, NameOfRegowner);
						pstmt.executeUpdate();
					}

				}
				message = "Saved Successfully";
			} else {
				message = "error";
			}
		} catch (Exception e) {

			message = "error";
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, null);
		}
		return message;
	}

	public String modifyVehicleInformation(String ApplicationNo, String Date,
			String InsuranceNo, String InsuranceexpDate, String FitnessExpdate,
			String PollutionexpDate, String NameOfRegowner,
			String PermanentAdd, String TemporaryAdd, String ContactNumber,
			String GrossWeight, String UnLadenWeight, String Rto,
			String PermitNo, String PermitExpDate, String LoadingCapacity,
			String YearOfManf, int systemId, String VehicleRegistrationNo,
			int offset, String UniqueNo) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String message = "";
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con
					.prepareStatement(SandMiningStatements.UPDATE_VEHICAL_ENLISTING_DETAILS);
			pstmt.setString(1, ApplicationNo);

			pstmt.setString(2, Date);

			pstmt.setString(3, InsuranceNo);

			pstmt.setString(4, InsuranceexpDate.replaceAll("T", " "));

			pstmt.setString(5, FitnessExpdate.replaceAll("T", " "));

			pstmt.setString(6, PollutionexpDate.replaceAll("T", " "));

			pstmt.setString(7, NameOfRegowner);

			pstmt.setString(8, PermanentAdd);

			pstmt.setString(9, TemporaryAdd);

			pstmt.setString(10, ContactNumber);

			pstmt.setString(11, GrossWeight);

			pstmt.setString(12, UnLadenWeight);

			pstmt.setString(13, Rto);

			pstmt.setString(14, PermitNo);

			pstmt.setString(15, PermitExpDate.replaceAll("T", " "));

			pstmt.setString(16, LoadingCapacity);

			pstmt.setString(17, YearOfManf);

			pstmt.setInt(18, systemId);
			pstmt.setString(19, VehicleRegistrationNo);

			pstmt.setString(20, UniqueNo);
			int result = pstmt.executeUpdate();
			if (result > 0) {
				message = "Update Successfull";
			} else {
				message = "Error";
			}

		} catch (Exception e) {
			e.printStackTrace();
			message = "error";
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, null);
		}
		return message;
	}

	public ArrayList<Object> getVehicleEnlistingDetails(String language,
			int offset, int systemId) {
		JSONArray JsonArray = new JSONArray();
		JSONObject JsonObject = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int count = 0;
		ArrayList<ReportHelper> reportsList = new ArrayList<ReportHelper>();
		ArrayList<String> headersList = new ArrayList<String>();
		ReportHelper finalreporthelper = new ReportHelper();
		ArrayList<Object> finlist = new ArrayList<Object>();
		try {
			headersList.add(cf.getLabelFromDB("SLNO", language));
			headersList.add(cf.getLabelFromDB("Application_No", language));
			headersList.add(cf.getLabelFromDB("Date", language));
			headersList.add(cf.getLabelFromDB("Registration_Number", language));
			headersList.add(cf.getLabelFromDB("Insurance_Number", language));
			headersList.add(cf.getLabelFromDB("Insurance_Expdate", language));
			headersList.add(cf.getLabelFromDB("Fitness_Expdate", language));
			headersList.add(cf.getLabelFromDB("Pollution_Expdate", language));
			headersList.add(cf.getLabelFromDB("Years_Permit-No", language));
			headersList.add(cf
					.getLabelFromDB("Years_Permit_Date_Exp", language));
			headersList.add(cf.getLabelFromDB("Name_Of_Reg_Owner", language));
			headersList.add(cf.getLabelFromDB("Permanent_Add", language));
			headersList.add(cf.getLabelFromDB("Temporary_Add", language));
			headersList.add(cf.getLabelFromDB("Contact_No", language));
			headersList.add(cf.getLabelFromDB("Gross_Weight", language));
			headersList.add(cf.getLabelFromDB("Unladen_Weight", language));
			headersList.add(cf.getLabelFromDB("RTO", language));
			headersList.add(cf.getLabelFromDB("Permit_No", language));
			headersList.add(cf.getLabelFromDB("Permit_Expdate", language));
			headersList.add(cf.getLabelFromDB("year_Of_Manf", language));
			headersList.add(cf.getLabelFromDB("Loading_Capacity", language));
			headersList.add(cf.getLabelFromDB("UniqueId_No", language));
			headersList.add(cf.getLabelFromDB("UNIOQUEID", language));
			headersList.add(cf.getLabelFromDB("Enlisting_UID", language));
			JsonArray = new JSONArray();
			JsonObject = new JSONObject();
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = null;
			pstmt = con
					.prepareStatement(SandMiningStatements.FETCH_VALUE_FOR_SENDING_SMS);
			pstmt.setInt(1, systemId);
			rs = pstmt.executeQuery();
			String name = "";
			if (rs.next()) {
				name = rs.getString("value");
			}
			pstmt = con
					.prepareStatement(SandMiningStatements.GET_VEHICAL_ENLISTING_DETAILS);
			pstmt.setInt(1, systemId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				count++;
				ArrayList<Object> informationList = new ArrayList<Object>();
				ReportHelper reporthelper = new ReportHelper();
				JsonObject = new JSONObject();
				int application = rs.getInt("APPLICATION_NO");
				Date date = rs.getTimestamp("DATE");
				String regis = rs.getString("ASSET_NUMBER");
				String inno = rs.getString("INSURANACE_NO");
				Date inexp = rs.getTimestamp("INSURANACE_EXP_DATE");
				Date fit = rs.getTimestamp("FITNESS_EXP_DATE");
				Date poll = rs.getTimestamp("POLLUTION_EXP_DATE");
				String perno = "";
				Date permit = new Date();
				String owner = rs.getString("OWNER_NAME");
				String padd = rs.getString("PERMANENT_ADD");
				String temp = rs.getString("TEMP_ADD");
				String mob = rs.getString("MOBILE_NO");
				String gross = rs.getString("GROSS_WEIGHT");
				String unladen = rs.getString("UNLADEN_WEIGHT");
				String rto = rs.getString("RTO");
				String pno = rs.getString("PERMIT_NO");
				Date pexp = rs.getTimestamp("PERMIT_EXP_DATE");
				String year = rs.getString("year_of_manf");
				double load = rs.getDouble("LOADING_CAPACITY");
				String unumber = rs.getString("UNIQUE_ID");
				String enlistingUid = rs.getString("ENLISTING_UID");
				unumber = getFormated4DigitNumber(unumber);
				String uid = name + unumber;
				int unique_id = rs.getInt("UNIQUE_ID");
				JsonObject.put("slnoIndex", count);
				informationList.add(count);
				JsonObject.put("APPLICATIONNO", application);
				informationList.add(application);
				JsonObject.put("DATE", sdfyyyymmdd.format(date));
				informationList.add(sdfyyyymmdd.format(date));
				JsonObject.put("VEHICLEREGISTRATIONNO", regis);
				informationList.add(regis);
				JsonObject.put("INSURANACENUMBER", inno);
				informationList.add(inno);
				JsonObject.put("INSURANCEEXPDATE", sdfyyyymmdd.format(inexp));
				informationList.add(sdfyyyymmdd.format(inexp));
				JsonObject.put("FITNESSEXPDATE", sdfyyyymmdd.format(fit));
				informationList.add(sdfyyyymmdd.format(fit));
				JsonObject.put("POLLUTIONEXPDATE", sdfyyyymmdd.format(poll));
				informationList.add(sdfyyyymmdd.format(poll));
				JsonObject.put("YEARSPERMITNO", perno);
				informationList.add(perno);
				JsonObject
						.put("YEARSPERMITDATEEXP", sdfyyyymmdd.format(permit));
				informationList.add(sdfyyyymmdd.format(permit));
				JsonObject.put("NAMEOFREGOWNER", owner);
				informationList.add(owner);
				JsonObject.put("PERMANENTADD", padd);
				informationList.add(padd);
				JsonObject.put("TEMPORARYADD", temp);
				informationList.add(temp);
				JsonObject.put("CONTACTNO", mob);
				informationList.add(mob);
				JsonObject.put("GROSSWEIGHT", gross);
				informationList.add(gross);
				JsonObject.put("UNLADENWEIGHT", unladen);
				informationList.add(unladen);
				JsonObject.put("RTO", rto);
				informationList.add(rto);
				JsonObject.put("PERMITNO", pno);
				informationList.add(pno);
				JsonObject.put("PERMITEXPDATE", sdfyyyymmdd.format(pexp));
				informationList.add(sdfyyyymmdd.format(pexp));
				JsonObject.put("yearofmanf", year);
				informationList.add(year);
				JsonObject.put("LOADINDCAPACITY", load);
				informationList.add(load);
				JsonObject.put("UNIQUEIDNO", uid);
				informationList.add(uid);
				JsonObject.put("UID", unique_id);
				informationList.add(unique_id);
				JsonObject.put("ENLISTINGUID", enlistingUid);
				informationList.add(enlistingUid);

				JsonArray.put(JsonObject);
				reporthelper.setInformationList(informationList);
				reportsList.add(reporthelper);
			}
			finlist.add(JsonArray);
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

	public String VechicleDelist(String VehicleRegistrationNo, int systemId,
			String UniqueIdNo, String ContactNumber, String NameOfRegowner,
			int userId) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String message = "";

		int maxuid = 1;
		try {
			con = DBConnection.getConnectionToDB("AMS");

			pstmt = con.prepareStatement(SandMiningStatements.SELECT_MAXUID);
			pstmt.setInt(1, systemId);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				maxuid = rs.getInt("MAXUID") + 1;
			}

			pstmt = null;
			pstmt = con
					.prepareStatement(SandMiningStatements.UPDATE_VEHICAL_DELISTING_DETAILS);
			pstmt.setInt(1, userId);
			pstmt.setString(2, VehicleRegistrationNo);
			pstmt.setInt(3, systemId);
			pstmt.setString(4, UniqueIdNo);
			pstmt.setString(5, ContactNumber);
			pstmt.setString(6, NameOfRegowner);

			int result = pstmt.executeUpdate();
			if (result > 0) {
				pstmt = null;
				pstmt = con
						.prepareStatement(SandMiningStatements.FETCH_VALUE_FOR_SENDING_SMS);
				pstmt.setInt(1, systemId);
				rs = pstmt.executeQuery();
				String name = "";
				String unumber = String.valueOf(maxuid);
				unumber = getFormated4DigitNumber(unumber);
				if (rs.next()) {
					name = rs.getString("value");
				}
				pstmt = null;
				pstmt = con
						.prepareStatement(SandMiningStatements.FETCH_CLIENTID_FOR_SENDING_SMS);
				pstmt.setInt(1, systemId);
				rs = pstmt.executeQuery();
				int Client = 0;

				if (rs.next()) {

					Client = rs.getInt("Client_Id");
				}
				if (Client > 0) {
					String Message = "Asset " + VehicleRegistrationNo
							+ " has been delisted and associated unique id is "
							+ name + "-" + unumber;
					pstmt = null;
					pstmt = con
							.prepareStatement(SandMiningStatements.INSERT_SMS);
					pstmt.setString(1, ContactNumber.trim());
					pstmt.setString(2, Message);
					pstmt.setString(3, "N");
					pstmt.setInt(4, Client);
					pstmt.setInt(5, systemId);
					pstmt.setString(6, VehicleRegistrationNo);
					pstmt.setString(7, name + "-" + unumber);
					pstmt.setString(8, NameOfRegowner);
					pstmt.executeUpdate();
				}

				message = "Vehicle Delisted";
			} else {
				message = "Error";
			}
		} catch (Exception e) {
			e.printStackTrace();
			System.out.println("Error in Admin Functions:- assetGroupExist "
					+ e.toString());
			message = "error";
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return message;
	}

	public JSONArray getRegistrationNoBasedOnUser(int ltspId, int userId) {
		JSONArray jsonArray = null;
		JSONObject jsonObject = null;

		Connection conAms = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {

			jsonArray = new JSONArray();
			jsonObject = new JSONObject();
			conAms = DBConnection.getConnectionToDB("AMS");
			pstmt = conAms
					.prepareStatement(SandMiningStatements.GET_REGISTRATION_NO_BASED_ON_USER);
			pstmt.setInt(1, userId);
			pstmt.setInt(2, ltspId);
			rs = pstmt.executeQuery();

			while (rs.next()) {
				jsonObject = new JSONObject();
				jsonObject
						.put("VehicleNo", rs.getString("REGISTRATION_NUMBER"));
				jsonArray.put(jsonObject);
			}

		} catch (Exception e) {
			System.out
					.println("Error in CommonFunctions:-getRegistrationNoBasedOnUser "
							+ e.toString());
		} finally {
			DBConnection.releaseConnectionToDB(conAms, pstmt, rs);
		}
		return jsonArray;
	}

	public String getFormated4DigitNumber(String unumber) {
		int len = unumber.length();
		if (len == 1) {
			unumber = "000" + unumber;
		} else if (len == 2) {
			unumber = "00" + unumber;
		} else if (len == 3) {
			unumber = "0" + unumber;
		}
		return unumber;
	}

	public ArrayList<Object> getMonthlyRevenueReport(String customerid,
			String startdate, String enddate, int systemId, int offmin,
			String language, String groupId) {

		JSONArray JsonArray = new JSONArray();
		JSONObject JsonObject = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String portname = "";
		String groupname = "";
		String permitcount = "";
		String revenue = "";
		int count = 0;
		ArrayList<ReportHelper> reportsList = new ArrayList<ReportHelper>();
		ArrayList<String> headersList = new ArrayList<String>();
		ReportHelper finalreporthelper = new ReportHelper();
		ArrayList<Object> finlist = new ArrayList<Object>();
		headersList.add("SLNO");
		headersList.add("Sub Division");
		headersList.add("Sand Block_Name");
		headersList.add("Total Revenue");
		headersList.add("Total Permits");
		try {
			JsonArray = new JSONArray();
			JsonObject = new JSONObject();
			con = DBConnection.getConnectionToDB("AMS");
			if (groupId.equals("ALL")) {
				pstmt = con
						.prepareStatement(SandMiningStatements.GET_REVENUE_AND_PERMITS_PER_SANDBLOCK_ALL_GROUP);
				pstmt.setInt(1, offmin);
				pstmt.setString(2, startdate);
				pstmt.setInt(3, offmin);
				pstmt.setString(4, enddate);
				pstmt.setInt(5, Integer.parseInt(customerid));
				pstmt.setInt(6, systemId);
			} else {
				pstmt = con
						.prepareStatement(SandMiningStatements.GET_REVENUE_AND_PERMITS_PER_SANDBLOCK);
				pstmt.setInt(1, offmin);
				pstmt.setString(2, startdate);
				pstmt.setInt(3, offmin);
				pstmt.setString(4, enddate);
				pstmt.setString(5, groupId);
				pstmt.setInt(6, Integer.parseInt(customerid));
				pstmt.setInt(7, systemId);
			}
			rs = pstmt.executeQuery();
			while (rs.next()) {
				JsonObject = new JSONObject();
				ArrayList<String> informationList = new ArrayList<String>();
				ReportHelper reporthelper = new ReportHelper();
				count++;
				informationList.add(Integer.toString(count));
				JsonObject.put("slnoIndex", Integer.toString(count));
				portname = rs.getString("Port_Name");
				groupname = rs.getString("GROUP_NAME");
				permitcount = rs.getString("TRIPSHEET_COUNT");
				revenue = rs.getString("AMOUNT");
				JsonObject.put("subdivisionIndex", groupname);
				informationList.add(groupname);
				JsonObject.put("sandblockIndex", portname);
				informationList.add(portname);
				JsonObject.put("revenueIndex", revenue);
				informationList.add(revenue);
				JsonObject.put("permitIndex", permitcount);
				informationList.add(permitcount);
				JsonArray.put(JsonObject);
				reporthelper.setInformationList(informationList);
				reportsList.add(reporthelper);
			}
			finlist.add(JsonArray);
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

	public ArrayList<Object> getDelistingDetails(String language, int systemId,
			int offset) {
		JSONArray JsonArray = new JSONArray();
		JSONObject JsonObject = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int count = 0;
		ArrayList<ReportHelper> reportsList = new ArrayList<ReportHelper>();
		ArrayList<String> headersList = new ArrayList<String>();
		ReportHelper finalreporthelper = new ReportHelper();
		ArrayList<Object> finlist = new ArrayList<Object>();
		try {
			headersList.add(cf.getLabelFromDB("SLNO", language));
			headersList.add(cf.getLabelFromDB("Application_No", language));
			headersList.add(cf.getLabelFromDB("Registration_Number", language));
			headersList.add(cf.getLabelFromDB("Name_Of_Reg_Owner", language));
			headersList.add(cf.getLabelFromDB("Permanent_Add", language));
			headersList.add(cf.getLabelFromDB("Temporary_Add", language));
			headersList.add(cf.getLabelFromDB("Contact_No", language));
			headersList.add(cf.getLabelFromDB("RTO", language));
			headersList.add(cf.getLabelFromDB("Delisting_Date", language));
			headersList.add(cf.getLabelFromDB("Delisting_UID", language));

			JsonArray = new JSONArray();
			JsonObject = new JSONObject();
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con
					.prepareStatement(SandMiningStatements.GET_DELISTING_DETAILS);
			pstmt.setInt(1, offset);
			pstmt.setInt(2, systemId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				JsonObject = new JSONObject();
				ArrayList<Object> informationList = new ArrayList<Object>();
				ReportHelper reporthelper = new ReportHelper();
				count++;
				informationList.add(Integer.toString(count));
				JsonObject.put("slnoIndex", Integer.toString(count));

				JsonObject.put("APPLICATIONNO", rs.getInt("APPLICATION_NO"));
				informationList.add(rs.getInt("APPLICATION_NO"));

				JsonObject.put("VEHICLEREGISTRATIONNO", rs
						.getString("ASSET_NUMBER"));
				informationList.add(rs.getString("ASSET_NUMBER"));

				JsonObject.put("NAMEOFREGOWNER", rs.getString("OWNER_NAME"));
				informationList.add(rs.getString("OWNER_NAME"));

				JsonObject.put("PERMANENTADD", rs.getString("PERMANENT_ADD"));
				informationList.add(rs.getString("PERMANENT_ADD"));

				JsonObject.put("TEMPORARYADD", rs.getString("TEMP_ADD"));
				informationList.add(rs.getString("TEMP_ADD"));

				JsonObject.put("CONTACTNO", rs.getString("MOBILE_NO"));
				informationList.add(rs.getString("MOBILE_NO"));

				JsonObject.put("RTO", rs.getString("RTO"));
				informationList.add(rs.getString("RTO"));

				if (rs.getString("DELISTING_DATETIME").contains("1900")
						|| rs.getString("DELISTING_DATETIME") == null) {
					JsonObject.put("DELISTINGDATETIME", "");
					informationList.add("");
				} else {
					JsonObject.put("DELISTINGDATETIME", ddMMyyyyHHmmss
							.format(rs.getTimestamp("DELISTING_DATETIME")));
					informationList.add(ddMMyyyyHHmmss.format(rs
							.getTimestamp("DELISTING_DATETIME")));
				}

				JsonObject.put("DELISTINGUID", rs.getString("DELISTING_UID"));
				informationList.add(rs.getString("DELISTING_UID"));

				JsonArray.put(JsonObject);
				reporthelper.setInformationList(informationList);
				reportsList.add(reporthelper);
			}
			finlist.add(JsonArray);
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

	public ArrayList<Object> getYearlyRevenueReport(String customerid,
			String startdate, String enddate, int systemId, int offmin,
			String language, String groupId) {

		JSONArray JsonArray = new JSONArray();
		JSONObject JsonObject = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String portname = "";
		String groupname = "";
		String permitcount = "";
		String revenue = "";
		String MonthlyWise = "";
		int count = 0;
		int Month = 0;
		int portNo = 0;
		String janAmount = "0";
		String febAmount = "0";
		String marAmount = "0";
		String aprAmount = "0";
		String mayAmount = "0";
		String junAmount = "0";
		String julAmount = "0";
		String augAmount = "0";
		String sepAmount = "0";
		String octAmount = "0";
		String novAmount = "0";
		String decAmount = "0";
		double sandPortAmount = 0;
		double janTotalAmount = 0;
		double febTotalAmount = 0;
		double marTotalAmount = 0;
		double aprTotalAmount = 0;
		double mayTotalAmount = 0;
		double junTotalAmount = 0;
		double julTotalAmount = 0;
		double augTotalAmount = 0;
		double sepTotalAmount = 0;
		double octTotalAmount = 0;
		double novTotalAmount = 0;
		double decTotalAmount = 0;
		ArrayList<ReportHelper> reportsList = new ArrayList<ReportHelper>();
		ArrayList<String> headersList = new ArrayList<String>();
		ReportHelper finalreporthelper = new ReportHelper();
		ArrayList<Object> finlist = new ArrayList<Object>();
		headersList.add("SLNO");
		headersList.add("Sub_Division");
		headersList.add("Sand_Block_Name");
		headersList.add("APR");
		headersList.add("MAY");
		headersList.add("JUN");
		headersList.add("JUL");
		headersList.add("AUG");
		headersList.add("SEP");
		headersList.add("OCT");
		headersList.add("NOV");
		headersList.add("DEC");
		headersList.add("JAN");
		headersList.add("FEB");
		headersList.add("MAR");
		headersList.add("Annual_Revenue");
		try {
			JsonArray = new JSONArray();
			JsonObject = new JSONObject();
			ArrayList<String> informationList = null;
			ReportHelper reporthelper = null;
			con = DBConnection.getConnectionToDB("AMS");
			if (groupId.equals("ALL")) {
				pstmt = con
						.prepareStatement(SandMiningStatements.GET_YEARLY_REVENUE_AND_PERMITS_PER_SANDBLOCK_ALL_GROUP);
				pstmt.setInt(1, offmin);
				pstmt.setString(2, startdate);
				pstmt.setInt(3, offmin);
				pstmt.setString(4, enddate);
				pstmt.setInt(5, Integer.parseInt(customerid));
				pstmt.setInt(6, systemId);
			} else {
				pstmt = con
						.prepareStatement(SandMiningStatements.GET_YEARLY_REVENUE_AND_PERMITS_PER_SANDBLOCK);
				pstmt.setInt(1, offmin);
				pstmt.setString(2, startdate);
				pstmt.setInt(3, offmin);
				pstmt.setString(4, enddate);
				pstmt.setString(5, groupId);
				pstmt.setInt(6, Integer.parseInt(customerid));
				pstmt.setInt(7, systemId);
			}
			rs = pstmt.executeQuery();
			while (rs.next()) {
				Month = rs.getInt("Month");
				if (portNo != rs.getInt("PORT_NO")) {
					JsonObject = new JSONObject();
					informationList = new ArrayList<String>();
					reporthelper = new ReportHelper();
					count++;
					informationList.add(Integer.toString(count));
					JsonObject.put("slnoIndex", Integer.toString(count));
					portname = rs.getString("Port_Name");
					groupname = rs.getString("GROUP_NAME");
					permitcount = rs.getString("TRIPSHEET_COUNT");
					revenue = rs.getString("AMOUNT");
					JsonObject.put("subdivisionIndex", groupname);
					informationList.add(groupname);
					JsonObject.put("sandblockIndex", portname);
					informationList.add(portname);
				}
				switch (Month)

				{
				case 4:
					JsonObject.put("aprIndex", rs.getString("AMOUNT"));
					aprAmount = rs.getString("AMOUNT");
					sandPortAmount = sandPortAmount + rs.getDouble("AMOUNT");
					aprTotalAmount = aprTotalAmount + rs.getDouble("AMOUNT");
					break;
				case 5:
					JsonObject.put("mayIndex", rs.getString("AMOUNT"));
					mayAmount = rs.getString("AMOUNT");
					sandPortAmount = sandPortAmount + rs.getDouble("AMOUNT");
					mayTotalAmount = mayTotalAmount + rs.getDouble("AMOUNT");
					break;
				case 6:
					JsonObject.put("junIndex", rs.getString("AMOUNT"));
					junAmount = rs.getString("AMOUNT");
					sandPortAmount = sandPortAmount + rs.getDouble("AMOUNT");
					junTotalAmount = junTotalAmount + rs.getDouble("AMOUNT");
					break;
				case 7:
					JsonObject.put("julIndex", rs.getString("AMOUNT"));
					julAmount = rs.getString("AMOUNT");
					sandPortAmount = sandPortAmount + rs.getDouble("AMOUNT");
					julTotalAmount = julTotalAmount + rs.getDouble("AMOUNT");
					break;
				case 8:
					JsonObject.put("augIndex", rs.getString("AMOUNT"));
					augAmount = rs.getString("AMOUNT");
					sandPortAmount = sandPortAmount + rs.getDouble("AMOUNT");
					augTotalAmount = augTotalAmount + rs.getDouble("AMOUNT");
					break;
				case 9:
					JsonObject.put("sepIndex", rs.getString("AMOUNT"));
					sepAmount = rs.getString("AMOUNT");
					sandPortAmount = sandPortAmount + rs.getDouble("AMOUNT");
					sepTotalAmount = sepTotalAmount + rs.getDouble("AMOUNT");
					break;
				case 10:
					JsonObject.put("octIndex", rs.getString("AMOUNT"));
					octAmount = rs.getString("AMOUNT");
					sandPortAmount = sandPortAmount + rs.getDouble("AMOUNT");
					octTotalAmount = octTotalAmount + rs.getDouble("AMOUNT");
					break;
				case 11:
					JsonObject.put("novIndex", rs.getString("AMOUNT"));
					novAmount = rs.getString("AMOUNT");
					sandPortAmount = sandPortAmount + rs.getDouble("AMOUNT");
					novTotalAmount = novTotalAmount + rs.getDouble("AMOUNT");
					break;
				case 12:
					JsonObject.put("decIndex", rs.getString("AMOUNT"));
					decAmount = rs.getString("AMOUNT");
					sandPortAmount = sandPortAmount + rs.getDouble("AMOUNT");
					decTotalAmount = decTotalAmount + rs.getDouble("AMOUNT");
					break;
				case 1:
					JsonObject.put("janIndex", rs.getString("AMOUNT"));
					janAmount = rs.getString("AMOUNT");
					sandPortAmount = sandPortAmount + rs.getDouble("AMOUNT");
					janTotalAmount = janTotalAmount + rs.getDouble("AMOUNT");
					break;
				case 2:
					JsonObject.put("febIndex", rs.getString("AMOUNT"));
					febAmount = rs.getString("AMOUNT");
					sandPortAmount = sandPortAmount + rs.getDouble("AMOUNT");
					febTotalAmount = febTotalAmount + rs.getDouble("AMOUNT");
					break;
				case 3:
					JsonObject.put("marIndex", rs.getString("AMOUNT"));
					marAmount = rs.getString("AMOUNT");
					sandPortAmount = sandPortAmount + rs.getDouble("AMOUNT");
					marTotalAmount = marTotalAmount + rs.getDouble("AMOUNT");
					break;
				}
				JsonObject.put("annualrevenueIndex", sandPortAmount);

				if (portNo != rs.getInt("PORT_NO")) {
					informationList.add(aprAmount);
					informationList.add(mayAmount);
					informationList.add(junAmount);
					informationList.add(julAmount);
					informationList.add(augAmount);
					informationList.add(sepAmount);
					informationList.add(octAmount);
					informationList.add(novAmount);
					informationList.add(decAmount);
					informationList.add(janAmount);
					informationList.add(febAmount);
					informationList.add(marAmount);
					informationList.add(Double.toString(sandPortAmount));
					aprAmount = "";
					mayAmount = "";
					junAmount = "";
					julAmount = "";
					augAmount = "";
					sepAmount = "";
					octAmount = "";
					novAmount = "";
					decAmount = "";
					janAmount = "";
					febAmount = "";
					marAmount = "";
					sandPortAmount = 0;
					JsonArray.put(JsonObject);
					reporthelper.setInformationList(informationList);
					reportsList.add(reporthelper);
				}

				portNo = rs.getInt("PORT_NO");
			}
			JsonObject = new JSONObject();
			informationList = new ArrayList<String>();
			JsonObject.put("slnoIndex", Integer.toString(count) + 1);
			informationList.add(Integer.toString(count) + 1);
			JsonObject.put("subdivisionIndex", "");
			informationList.add("");
			JsonObject.put("sandblockIndex", "Total");
			informationList.add("Total");
			JsonObject.put("aprIndex", aprTotalAmount);
			informationList.add(Double.toString(aprTotalAmount));
			JsonObject.put("mayIndex", mayTotalAmount);
			informationList.add(Double.toString(mayTotalAmount));
			JsonObject.put("junIndex", junTotalAmount);
			informationList.add(Double.toString(junTotalAmount));
			JsonObject.put("julIndex", julTotalAmount);
			informationList.add(Double.toString(julTotalAmount));
			JsonObject.put("augIndex", augTotalAmount);
			informationList.add(Double.toString(augTotalAmount));
			JsonObject.put("sepIndex", sepTotalAmount);
			informationList.add(Double.toString(sepTotalAmount));
			JsonObject.put("octIndex", octTotalAmount);
			informationList.add(Double.toString(octTotalAmount));
			JsonObject.put("novIndex", novTotalAmount);
			informationList.add(Double.toString(novTotalAmount));
			JsonObject.put("decIndex", decTotalAmount);
			informationList.add(Double.toString(decTotalAmount));
			JsonObject.put("janIndex", janTotalAmount);
			informationList.add(Double.toString(janTotalAmount));
			JsonObject.put("febIndex", febTotalAmount);
			informationList.add(Double.toString(febTotalAmount));
			JsonObject.put("marIndex", marTotalAmount);
			informationList.add(Double.toString(marTotalAmount));
			JsonObject.put("annualrevenueIndex", janTotalAmount
					+ febTotalAmount + marTotalAmount + aprTotalAmount
					+ mayTotalAmount + junTotalAmount + julTotalAmount
					+ augTotalAmount + sepTotalAmount + octTotalAmount
					+ novTotalAmount + decTotalAmount);
			informationList.add(Double.toString(janTotalAmount
					+ febTotalAmount + marTotalAmount + aprTotalAmount
					+ mayTotalAmount + junTotalAmount + julTotalAmount
					+ augTotalAmount + sepTotalAmount + octTotalAmount
					+ novTotalAmount + decTotalAmount));
			JsonArray.put(JsonObject);
			finlist.add(JsonArray);
			reporthelper.setInformationList(informationList);
			reportsList.add(reporthelper);
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
	
	public JSONArray getDashboardElementsCount(int systemId, int customerId, int userId,int offset, int isLtsp,String zone) {
		JSONArray jsonArray = null;
		JSONObject jsonObject = null;

		Connection connection = null;
		PreparedStatement pstmt = null,pstmt1 = null,pstmt2 = null,pstmt3 = null,pstmt4 = null;
		ResultSet rs = null;
		
		try {
			int totalAssetCount = 0;
			int commCount = 0;
			int nonCommLessThan24hrCount = 0;
			int nonCommGreaterThan24hrCount = 0;
			int noGpsCount = 0;
			int alertsCount = 0;
			int sandPermitsCount = 0;
			int assetArrivalSandPortCount = 0;
			String maximumPermitDivision = "No Permit";
			String minimumPermitDivision = "No Permit";
			String quantity="";
			String qntarr[];
			double dbQuantity=0;
			int totalewaybills=0;
			Date date=new Date();
			String hubIds="";
			String existingVehicle="";
		    String startDate=cf.getGMTDateTime(sdfmmddyyyy.format(date)+" 00:00:00", offset);
		    String endDate=cf.getGMTDateTime(cf.setNextDateForReportsNew()+" 00:00:00", offset);
			//int alertID=0;
			String CustName = cf.getCustomerName(String.valueOf(customerId),systemId);
			jsonArray = new JSONArray();
			//StringBuilder alertListsb=new StringBuilder();
			connection = DBConnection.getConnectionToDB("AMS");
					
			try {
				if(customerId == 0 || isLtsp == 0){
					
					pstmt = connection.prepareStatement(SandMiningStatements.GET_TOTAL_ASSET_COUNT_FOR_LTSP);
					pstmt1 = connection.prepareStatement(SandMiningStatements.GET_COMMUNICATION_COUNT_FOR_LTSP);
					pstmt2 = connection.prepareStatement(SandMiningStatements.GET_NON_COM_LESS_THAN_24HRS_COUNT_FOR_LTSP);
					pstmt3 = connection.prepareStatement(SandMiningStatements.GET_NON_COM_GREATER_THAN_24HRS_COUNT_FOR_LTSP);
					pstmt4 = connection.prepareStatement(SandMiningStatements.GET_NO_GPS_COUNT_FOR_LTSP);
				}else{
					
					pstmt = connection.prepareStatement(SandMiningStatements.GET_TOTAL_ASSET_COUNT_FOR_CLIENT);
					pstmt1 = connection.prepareStatement(SandMiningStatements.GET_COMMUNICATION_COUNT_FOR_CLIENT);
					pstmt2 = connection.prepareStatement(SandMiningStatements.GET_NON_COM_LESS_THAN_24HRS_COUNT_FOR_CLIENT);
					pstmt3 = connection.prepareStatement(SandMiningStatements.GET_NON_COM_GREATER_THAN_24HRS_COUNT_FOR_CLIENT);
					pstmt4 = connection.prepareStatement(SandMiningStatements.GET_NO_GPS_COUNT_FOR_CLIENT);
				}				
				pstmt.setInt(1, systemId);
				pstmt.setInt(2, customerId);
				pstmt.setInt(3, userId);
				rs = pstmt.executeQuery();
				if (rs.next()) {
					totalAssetCount = rs.getInt("COUNT");
				}
				rs.close();


				pstmt1.setInt(1, systemId);
				pstmt1.setInt(2, customerId);
				pstmt1.setInt(3, userId);
				rs = pstmt1.executeQuery();
				if (rs.next()) {
					commCount = rs.getInt("COUNT");
				}
				rs.close();


				pstmt2.setInt(1, systemId);
				pstmt2.setInt(2, customerId);
				pstmt2.setInt(3, userId);
				rs = pstmt2.executeQuery();
				if (rs.next()) {
					nonCommLessThan24hrCount = rs.getInt("COUNT");
				}
				rs.close();


				pstmt3.setInt(1, systemId);
				pstmt3.setInt(2, customerId);
				pstmt3.setInt(3, userId);
				rs = pstmt3.executeQuery();
				if (rs.next()) {
					nonCommGreaterThan24hrCount = rs.getInt("COUNT");
				}
				rs.close();


				pstmt4.setInt(1, systemId);
				pstmt4.setInt(2, customerId);
				pstmt4.setInt(3, userId);
				rs = pstmt4.executeQuery();
				if (rs.next()) {
					noGpsCount = rs.getInt("COUNT");
				}
				rs.close();

//				pstmt = connection.prepareStatement(AlertStatements.GET_ALERT_COMPONENTS);
//				pstmt.setInt(1, systemId);
//				rs = pstmt.executeQuery();
//				while (rs.next()) {
//					alertListsb.append(rs.getInt("AlertId") + ",");
//				}
//				rs.close();
//
//				try {
//					String[] alert = alertListsb.toString().split(",");
//					for (String alertId : alert) {
//						alertID = Integer.parseInt(alertId);
//						alertsCount = alertsCount+ alfunc.getAlertComponentCount(alertID, systemId,customerId, userId, offset);
//					}
//				} catch (Exception e) {
//					e.printStackTrace();
//				}
				
                if(systemId==229)
                {
                pstmt = connection.prepareStatement(SandMiningStatements.GET_SAND_PERMITS_COUNT1);	
                }
                else pstmt = connection.prepareStatement(SandMiningStatements.GET_SAND_PERMITS_COUNT);
				pstmt.setInt(1, systemId);
				pstmt.setInt(2, customerId);
				pstmt.setInt(3, offset);
				rs = pstmt.executeQuery();
				if (rs.next()) {
					sandPermitsCount = rs.getInt("COUNT");
				}
				rs.close();
				 pstmt=connection.prepareStatement(SandMiningStatements.GET_ASSOCIATED_HUBS_NEW.replace("LOCATION", "LOCATION_ZONE_"+zone));
				    pstmt.setInt(1,userId);
				    pstmt.setInt(2,systemId);
				    pstmt.setInt(3,customerId);
				    rs=pstmt.executeQuery();
				    while(rs.next())
				    {
				    hubIds=rs.getString("HUBID")+","+hubIds;	
				    }
				    rs.close();
				    if(hubIds.length()==0)
				    {
				    pstmt=connection.prepareStatement(SandMiningStatements.GET_HUB_NAMES_FOR_CLIENT.replace("LOCATION", "LOCATION_ZONE_"+zone));
				    pstmt.setInt(1,systemId);
				    pstmt.setInt(2,customerId);
				    rs=pstmt.executeQuery();
				    while(rs.next())
				    {
				    hubIds=rs.getString("HUBID")+","+hubIds;
				    }
				    }
				    if(hubIds.length()>0)
				    {hubIds=hubIds.substring(0,hubIds.length()-1);}
				    else
				    {hubIds="0";}
				    pstmt1=connection.prepareStatement(SandMiningStatements.SELECT_REGISTRATION_NO_FROM_USER_VEHICLE);
				    pstmt1.setInt(1,customerId);
				    pstmt1.setInt(2,systemId);
				    rs=pstmt1.executeQuery();
				    while(rs.next())
				    {
				    String veh = rs.getString("Registration_no");
					if (!veh.equals("")) {
					existingVehicle = existingVehicle + "'" + veh + "'" + ",";
					}	
				    }
				    if(existingVehicle.length()>0)
				    {
				    existingVehicle=existingVehicle.substring(0,existingVehicle.length()-1);
				    }
				    else
				    { existingVehicle="0";}
				 String HUB_ARR_DEP_COUNT= "select count(*) as COUNT from HUB_REPORT (nolock) "+
				 "outer apply dbo.GetStandardandDeviationTime(HUB_ID,CONVERT(numeric,SUBSTRING(CONVERT(VARCHAR(8),dateadd(mi,?,ACTUAL_ARRIVAL),108),1,2)),CONVERT(numeric,SUBSTRING(CONVERT(VARCHAR(8),dateadd(mi,?,ACTUAL_ARRIVAL),108),4,2))) stdtime "+
				 "left outer join dbo.tblVehicleMaster vm on HUB_REPORT.REGISTRATION_NO=vm.VehicleNo where "+
				 "(ACTUAL_ARRIVAL between ? and ? or ACTUAL_DEPARTURE between ? and ?) and HUB_ID in ("+hubIds+") "+
				 "and REGISTRATION_NO in ("+existingVehicle+") and SYSTEM_ID=? ";
				 
				pstmt = connection.prepareStatement(HUB_ARR_DEP_COUNT);
				pstmt.setInt(1, offset);
				pstmt.setInt(2, offset);
				pstmt.setString(3, startDate);
				pstmt.setString(4, endDate);
				pstmt.setString(5, startDate);
				pstmt.setString(6, endDate);
				pstmt.setInt(7, systemId);	
				
				
				rs = pstmt.executeQuery();
				if (rs.next()) {
					assetArrivalSandPortCount = rs.getInt("COUNT");
				}
				rs.close();

				pstmt = connection.prepareStatement(SandMiningStatements.GET_MIN_PERMIT_DIVISION);
				pstmt.setInt(1, systemId);
				pstmt.setInt(2, customerId);
				pstmt.setInt(3, offset);
				rs = pstmt.executeQuery();
				if (rs.next()) {
					minimumPermitDivision = rs.getString("Group_Name");
				}
				rs.close();

				pstmt = connection.prepareStatement(SandMiningStatements.GET_MAX_PERMIT_DIVISION);
				pstmt.setInt(1, systemId);
				pstmt.setInt(2, customerId);
				pstmt.setInt(3, offset);
				rs = pstmt.executeQuery();
				if (rs.next()) {
					maximumPermitDivision = rs.getString("Group_Name");
				}
				
				pstmt = connection.prepareStatement(SandMiningStatements.GET_TOTAL_QUANTITY);
				pstmt.setInt(1, systemId);
				pstmt.setInt(2, customerId);
				pstmt.setInt(3, offset);
				rs = pstmt.executeQuery();
				while (rs.next()) {
					quantity = rs.getString("Quantity");
					
					qntarr=quantity.split(" ");
					
					if(rs.getString("Quantity").contains(" ")){  
						dbQuantity=dbQuantity+Double.parseDouble(qntarr[0]);
					}
					else{
						dbQuantity=dbQuantity+Double.parseDouble(quantity);
					}
				}
				rs.close();
				
				pstmt = connection.prepareStatement(SandMiningStatements.GET_TOTAL_EWAYBILLS_NOGPS);
				pstmt.setInt(1, systemId);
				pstmt.setString(2, CustName);
		
				rs = pstmt.executeQuery();
				while (rs.next()) {
					totalewaybills = rs.getInt("COUNT");
					
					
				}
				rs.close();
				
			} catch (Exception e) {
				e.printStackTrace();
			}

			jsonObject = new JSONObject();
			jsonObject.put("totalAssetCount", totalAssetCount);
			jsonObject.put("commCount", commCount);
			jsonObject.put("nonCommLessThan24hrCount", nonCommLessThan24hrCount);
			jsonObject.put("nonCommGreaterThan24hrCount", nonCommGreaterThan24hrCount);
			jsonObject.put("noGpsCount", noGpsCount);
			jsonObject.put("alertsCount", alertsCount);
			jsonObject.put("sandPermitsCount", sandPermitsCount);
			jsonObject.put("assetArrivalSandPortCount", assetArrivalSandPortCount);
			jsonObject.put("minimumPermitDivision", minimumPermitDivision);
			jsonObject.put("maximumPermitDivision", maximumPermitDivision);
			jsonObject.put("totalsandquantityId", df.format(dbQuantity));
			jsonObject.put("totalewaybillsnogps", totalewaybills);
			
			jsonArray.put(jsonObject);

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(connection, pstmt, rs);
			DBConnection.releaseConnectionToDB(null, pstmt1, null);
			DBConnection.releaseConnectionToDB(null, pstmt2, null);
			DBConnection.releaseConnectionToDB(null, pstmt3, null);
			DBConnection.releaseConnectionToDB(null, pstmt4, null);
			
		}
		return jsonArray;
	}
	
	public JSONArray getWeeklyRevenue(int customerId, String startdate, String enddate, int systemId, int offmin) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int count=0;
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject = new JSONObject();
		try {			
			con = DBConnection.getConnectionToDB("AMS");
			if (systemId==229)
			{
				 pstmt = con.prepareStatement(SandMiningStatements.GET_REVENUE_FOR_DASHBOARD_CHART1);	
				 pstmt.setInt(1, customerId);
					pstmt.setInt(2, systemId);
					pstmt.setInt(3, customerId);
					pstmt.setInt(4, systemId);
					rs = pstmt.executeQuery();
				 
			}
			else {
				pstmt = con.prepareStatement(SandMiningStatements.GET_REVENUE_FOR_DASHBOARD_CHART);
				pstmt.setInt(1, customerId);
				pstmt.setInt(2, systemId);
				rs = pstmt.executeQuery();}
			while (rs.next()) {
				count++;
						if(count==1)
						jsonObject.put("sunrevenueIndex", rs.getString("AMOUNT"));	
					
						if(count==2)
						jsonObject.put("monrevenueIndex", rs.getString("AMOUNT"));	
						
						if(count==3)
						jsonObject.put("tuerevenueIndex", rs.getString("AMOUNT"));	
					
						if(count==4)
						jsonObject.put("wedrevenueIndex", rs.getString("AMOUNT"));	
						
						if(count==5)
						jsonObject.put("thurevenueIndex", rs.getString("AMOUNT"));
						 
						if(count==6)
						jsonObject.put("frirevenueIndex", rs.getString("AMOUNT"));
						
						if(count==7)
						jsonObject.put("satrevenueIndex", rs.getString("AMOUNT"));	
						
				
				
			}
			jsonArray.put(jsonObject);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jsonArray;
	}
	
	public JSONArray getWeeklyPermit(int customerId, String startdate, String enddate, int systemId, int offmin) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int count=0;
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject = new JSONObject();
		try {			
			con = DBConnection.getConnectionToDB("AMS");
			if(systemId==229)
			{
				pstmt = con.prepareStatement(SandMiningStatements.GET_PERMIT_FOR_DASHBOARD_CHART1);	
				 pstmt.setInt(1, customerId);
					pstmt.setInt(2, systemId);
					pstmt.setInt(3, customerId);
					pstmt.setInt(4, systemId);
					rs = pstmt.executeQuery();
			}
			else
			{
				pstmt = con.prepareStatement(SandMiningStatements.GET_PERMIT_FOR_DASHBOARD_CHART);
				pstmt.setInt(1, customerId);
				pstmt.setInt(2, systemId);
				rs = pstmt.executeQuery();
			}
			while (rs.next()) {
				count++;
				
						if(count==1)
						jsonObject.put("sunpermitIndex", rs.getString("TRIPSHEET_COUNT"));	
						if(count==2)
						jsonObject.put("monpermitIndex", rs.getString("TRIPSHEET_COUNT"));	
						if(count==3)
						jsonObject.put("tuepermitIndex", rs.getString("TRIPSHEET_COUNT"));	
						if(count==4)
						jsonObject.put("wedpermitIndex", rs.getString("TRIPSHEET_COUNT"));	
						if(count==5)
						jsonObject.put("thupermitIndex", rs.getString("TRIPSHEET_COUNT"));
						if(count==6)
						jsonObject.put("fripermitIndex", rs.getString("TRIPSHEET_COUNT"));
						if(count==7)
						jsonObject.put("satpermitIndex", rs.getString("TRIPSHEET_COUNT"));	
				
				
			}
			jsonArray.put(jsonObject);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jsonArray;
	}

	public JSONArray  getDailyMonitorReport(int systemId,String clientId,String date,int offmin){

		JSONArray JsonArray = new JSONArray();
		JSONObject JsonObject = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int count = 0;

		String assetNumber ="";
		String liveStatus="";
		String overSpeedStatus="";
		String permitStatus="";
		String portEntryStatus ="";
		String multipleMDP="";
		String nearToBorder="";
		String crossBorder="";
		String restrictivePortEntry="";
		String insuranceStatus="";
		String assetFitnesStatus="";
		String emmissionStatus="";	
		try {
		    		 
			JsonArray = new JSONArray();		
			JsonObject = new JSONObject();	
			
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(SandMiningStatements.GET_DAILY_MONITORING_DETAILS);
			pstmt.setInt(1, systemId);
			pstmt.setString(2, clientId);
			pstmt.setInt(3,-offmin);
			pstmt.setString(4, date);			
			rs = pstmt.executeQuery();
			
			while (rs.next()) {				
				JsonObject = new JSONObject();				
			count++;
			String slNo = Integer.toString(count);
			assetNumber = rs.getString("ASSET_NUMBER");			
			liveStatus = rs.getString("LIVE_STATUS");
			overSpeedStatus = rs.getString("OVERSPEED_STATUS");
			permitStatus = rs.getString("PARMIT_STATUS");
			portEntryStatus = rs.getString("PORT_ENTRY_STATUS");
			multipleMDP = rs.getString("MULTIPLE_MDP");
			nearToBorder = rs.getString("NEAR_TO_BORDER");
			crossBorder = rs.getString("CROSS_BORDER");
			restrictivePortEntry = rs.getString("RESTRICTIVE_PORT_ENTRY");
			insuranceStatus = rs.getString("INSURENCE_STATUS");
			assetFitnesStatus = rs.getString("ASSET_FITNESS_STATUS");
			emmissionStatus = rs.getString("EMISSION_STATUS");
			
			JsonObject.put("slnoIndex",slNo);			
			JsonObject.put("assetNumber",assetNumber);			
			JsonObject.put("liveStatus",liveStatus);
			JsonObject.put("overSpeedStatus",overSpeedStatus);		
			JsonObject.put("permitStatus",permitStatus);			
			JsonObject.put("portEntryStatus",portEntryStatus);			
			JsonObject.put("multipleMDP",multipleMDP);		
			JsonObject.put("nearToBorder",nearToBorder);		
			JsonObject.put("CrossBorder",crossBorder);		
			JsonObject.put("restrictivePortEntry",restrictivePortEntry);			
			JsonObject.put("insuranceStatus",insuranceStatus);	
			JsonObject.put("assetFitnesStatus",assetFitnesStatus);		
			JsonObject.put("emissionStatus",emmissionStatus);
				
			JsonArray.put(JsonObject);								
		}						
	}
		
	 catch (Exception e) {
		e.printStackTrace();
	  } finally {
		DBConnection.releaseConnectionToDB(con, pstmt, rs);
	   }
	  
		 return JsonArray;
		 
	    }
	
//***************************************************************SANDBLOCKMANAGEMENTACTIONS******************************************************************************************************************//	
	
	public JSONArray getDistirctList(int stateId) {
        Connection conAdmin = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        JSONArray jsonArray = new JSONArray();
        JSONObject jsonObject = new JSONObject();
        try {
            conAdmin = DBConnection.getConnectionToDB("ADMINISTRATOR");
            pstmt = conAdmin.prepareStatement(SandMiningStatements.GET_DISTRICT_LIST);
            pstmt.setInt(1, stateId);
            rs = pstmt.executeQuery();
            while (rs.next()) {
                jsonObject = new JSONObject();
                jsonObject.put("districtID", rs.getString("DISTRICT_ID"));
                jsonObject.put("districtName", rs.getString("DISTRICT_NAME"));
                jsonArray.put(jsonObject);
            }

        } catch (Exception e) {
        	 e.printStackTrace();
        } finally {
            DBConnection.releaseConnectionToDB(conAdmin, pstmt, rs);
        }
        return jsonArray;
    }	
	
	public JSONArray getTaluka(int districtId) {
        Connection conAdmin = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        JSONArray jsonArray = new JSONArray();
        JSONObject jsonObject = new JSONObject();
        try {
            conAdmin = DBConnection.getConnectionToDB("ADMINISTRATOR");
            pstmt = conAdmin.prepareStatement(SandMiningStatements.GET_TALUKA_LIST);
            pstmt.setInt(1, districtId);
            rs = pstmt.executeQuery();
            while (rs.next()) {
                jsonObject = new JSONObject();
                jsonObject.put("TalukaId", rs.getString("TALUK_ID"));
                jsonObject.put("TalukaName", rs.getString("TALUK_NAME"));
                jsonArray.put(jsonObject);
            }

        } catch (Exception e) {
        	 e.printStackTrace();
        } finally {
            DBConnection.releaseConnectionToDB(conAdmin, pstmt, rs);
        }
        return jsonArray;
    }		
	
	
	public JSONArray getGeoFence(int custId,int systemId) {
        Connection conAdmin = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        JSONArray jsonArray = new JSONArray();
        JSONObject jsonObject = new JSONObject();
        try {
            conAdmin = DBConnection.getConnectionToDB("ADMINISTRATOR");
            pstmt = conAdmin.prepareStatement(SandMiningStatements.GET_GEO_FENCE_LIST);
            pstmt.setInt(1, custId);
            pstmt.setInt(2, systemId);
            pstmt.setInt(3, systemId);
            pstmt.setInt(4, custId);
            rs = pstmt.executeQuery();
            while (rs.next()) {
                jsonObject = new JSONObject();
                jsonObject.put("geoFenceId", rs.getString("HUBID"));
                jsonObject.put("geoFenceName", rs.getString("NAME"));
                jsonArray.put(jsonObject);
            }

        } catch (Exception e) {
        	 e.printStackTrace();
        } finally {
            DBConnection.releaseConnectionToDB(conAdmin, pstmt, rs);
        }
        return jsonArray;
    }		
	
	public JSONArray getGeoFence1(int custId,int systemId) {
        Connection conAdmin = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        JSONArray jsonArray = new JSONArray();
        JSONObject jsonObject = new JSONObject();
        try {
            conAdmin = DBConnection.getConnectionToDB("ADMINISTRATOR");
            pstmt = conAdmin.prepareStatement(SandMiningStatements.GET_GEO_FENCE_LIST1);
            pstmt.setInt(1, custId);
            pstmt.setInt(2, systemId);
            pstmt.setInt(3, systemId);
            pstmt.setInt(4, custId);
            rs = pstmt.executeQuery();
            while (rs.next()) {
                jsonObject = new JSONObject();
                jsonObject.put("geoFenceId", rs.getString("HUBID"));
                jsonObject.put("geoFenceName", rs.getString("NAME"));
                jsonArray.put(jsonObject);
            }

        } catch (Exception e) {
        	 e.printStackTrace();
        } finally {
            DBConnection.releaseConnectionToDB(conAdmin, pstmt, rs);
        }
        return jsonArray;
    }	
	
	public String insertSandBlockInformation(int custId,String state,String district,String subDivision,String taluka,String gramPanchayat,String village,
          	String sandBlockName,String sandBlockNo,String surveyNo,String sandBlockAddress,String riverName,String environmentalClearence,String sandBlockType,String sandBlockStatus,String assessedQuantityMetric,String assessedQuantity,
            String directLoading,String associatedGeoFence,int systemId,int userId) {
	    Connection con = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
	    String message = "";
	    try {
	        con = DBConnection.getConnectionToDB("ADMINISTRATOR");
	        pstmt = con.prepareStatement(SandMiningStatements.INSERT_SAND_BLOCK_INFORMATION);
	        pstmt.setString(1, state);
	        pstmt.setString(2, district);
	        pstmt.setString(3, subDivision);
	        pstmt.setString(4, taluka);
	        pstmt.setString(5, gramPanchayat);
	        pstmt.setString(6, village);
	        pstmt.setString(7, sandBlockName);
	        pstmt.setString(8, sandBlockNo);
	        pstmt.setString(9, surveyNo);
	        pstmt.setString(10, sandBlockAddress);
	        pstmt.setString(11, riverName);
	        pstmt.setString(12, environmentalClearence);
	        pstmt.setString(13, sandBlockType);
	        pstmt.setString(14, sandBlockStatus);
	        pstmt.setString(15, assessedQuantityMetric);
	        pstmt.setString(16, assessedQuantity);
	        pstmt.setString(17, directLoading);
	        pstmt.setString(18, associatedGeoFence);
	        pstmt.setInt(19, systemId);
	        pstmt.setInt(20, custId);
	        pstmt.setInt(21, userId);
	        int inserted = pstmt.executeUpdate();
	        if (inserted > 0) {
	            message = "Saved Successfully";
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	        DBConnection.releaseConnectionToDB(con, pstmt, rs);
	    }
	    return message;
	}
	
	public String modifySandBlockInformation(int custId,String state,String district,String subDivision,String taluka,String gramPanchayat,String village,
	           String sandBlockName,String sandBlockNo,String surveyNo,String sandBlockAddress,String riverName,String environmentalClearence,String sandBlockType,String sandBlockStatus,String assessedQuantityMetric,String assessedQuantity,
	           String directLoading,String associatedGeoFence,int systemId,int uniqueId,int userId) {
		    Connection con = null;
		    PreparedStatement pstmt = null;
		    PreparedStatement pstmt1 = null;
		    PreparedStatement pstmt2 = null;
		    PreparedStatement pstmt3 = null;
		    ResultSet rs = null;
		    String message = "";
		    try {
		        con = DBConnection.getConnectionToDB("ADMINISTRATOR");
		        pstmt = con.prepareStatement(SandMiningStatements.UPDATE_SAND_BLOCK_INFORMATION);
		        pstmt.setString(1, state);
	            pstmt.setString(2, district);
	            pstmt.setString(3, subDivision);
				pstmt.setString(4, taluka);
				pstmt.setString(5, gramPanchayat);
				pstmt.setString(6, village);
				pstmt.setString(7, sandBlockName);
				pstmt.setString(8, sandBlockNo);
				pstmt.setString(9, surveyNo);
				pstmt.setString(10, sandBlockAddress);
				pstmt.setString(11, riverName);
				pstmt.setString(12, environmentalClearence);
				pstmt.setString(13, sandBlockType);
				pstmt.setString(14, sandBlockStatus);
				pstmt.setString(15, assessedQuantityMetric);
				pstmt.setString(16, assessedQuantity);
				pstmt.setString(17, directLoading);
				pstmt.setString(18, associatedGeoFence);
				pstmt.setInt(19, userId);
				pstmt.setInt(20, systemId);
				pstmt.setInt(21, custId);
				pstmt.setInt(22, uniqueId);
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
	
	public ArrayList < Object > getSandBlockManagementReport(int clientId, int systemid,int userId,String language) {
	    JSONArray JsonArray = new JSONArray();
	    JSONObject JsonObject = null;
	    Connection con = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
		ArrayList < Object > finlist = new ArrayList < Object > ();
	    ArrayList < Object > reportsList = new ArrayList < Object > ();
		ArrayList < Object > headersList = new ArrayList < Object > ();
		ReportHelper finalreporthelper = new ReportHelper();
	    DecimalFormat df = new DecimalFormat("##.##");
	    try {
	        int count = 0;
	        headersList.add(cf.getLabelFromDB("SLNO", language));
	        headersList.add(cf.getLabelFromDB("State", language));
	        headersList.add(cf.getLabelFromDB("District", language));
	        headersList.add(cf.getLabelFromDB("Sub_Division", language));
	        headersList.add(cf.getLabelFromDB("Taluka", language));
	        headersList.add(cf.getLabelFromDB("Gram_Panchayat", language));
	        headersList.add(cf.getLabelFromDB("Village", language));
	        headersList.add(cf.getLabelFromDB("Sand_Block_Name", language));
	        headersList.add(cf.getLabelFromDB("Sand_Block_No", language));
	        headersList.add(cf.getLabelFromDB("Survey_No", language));
	        headersList.add(cf.getLabelFromDB("Sand_Block_Address", language));
	        headersList.add(cf.getLabelFromDB("River_Name", language));
	        headersList.add(cf.getLabelFromDB("Environmental_Clearance", language));
	        headersList.add(cf.getLabelFromDB("Sand_Block_Type", language));
	        headersList.add(cf.getLabelFromDB("Sand_Block_Status", language));
	        headersList.add(cf.getLabelFromDB("Assessed_Quantity_Metric", language));
	        headersList.add("Assessed Quantity");
	        headersList.add("Dispatched Quantity");
	        headersList.add(cf.getLabelFromDB("Direct_Loading", language));
	        headersList.add(cf.getLabelFromDB("Associated_Geofence", language));
	   
	        con = DBConnection.getConnectionToDB("AMS");
	            pstmt = con.prepareStatement(SandMiningStatements.GET_SAND_BLOCK_MANAGEMENT_DETAILS);
	            pstmt.setInt(1, systemid);
	            pstmt.setInt(2, clientId);
	            pstmt.setInt(3, systemid);
	            pstmt.setInt(4, clientId);
	            pstmt.setInt(5, systemid);
	            pstmt.setInt(6, clientId);
	            rs = pstmt.executeQuery();
	        while (rs.next()) {
	            JsonObject = new JSONObject();
	            count++;
	        	ArrayList<Object> informationList = new ArrayList<Object>();
				ReportHelper reporthelper = new ReportHelper();
				
				String sandblock= rs.getString("SandBlockName");
				
	        	informationList.add(count);
			    JsonObject.put("slnoIndex", count);
			    
			    informationList.add(rs.getString("PortState"));
	            JsonObject.put("stateDataIndex", rs.getString("PortState"));
	            
	            informationList.add(rs.getString("PortDistrict"));
 	            JsonObject.put("districtDataIndex", rs.getString("PortDistrict"));
 	            
 	            informationList.add(rs.getString("SubDivision"));
	            JsonObject.put("subDivisionDataIndex", rs.getString("SubDivision"));
	            
	            informationList.add(rs.getString("Taluka"));
	            JsonObject.put("talukaDataIndex", rs.getString("Taluka"));
	            
	            informationList.add(rs.getString("GramPanchayat"));
				JsonObject.put("gramPanchyatDataIndex", rs.getString("GramPanchayat"));
				
				informationList.add(rs.getString("Village"));
				JsonObject.put("villageDataIndex", rs.getString("Village"));
				
				informationList.add(rs.getString("SandBlockName"));
				JsonObject.put("sandBlockNameDataIndex", rs.getString("SandBlockName"));
				
				informationList.add(rs.getString("SandBlockNumber"));
				JsonObject.put("sandBlockNoDataIndex", rs.getString("SandBlockNumber"));
				
				informationList.add(rs.getString("SurveyNo"));
				JsonObject.put("surveyNoDataIndex", rs.getString("SurveyNo"));
				
				informationList.add(rs.getString("SandBlockAddress"));
				JsonObject.put("sandBlockAddressDataIndex", rs.getString("SandBlockAddress"));
				
				informationList.add(rs.getString("RiverName"));
				JsonObject.put("riverNameDataIndex", rs.getString("RiverName"));
				
				informationList.add(rs.getString("EnvironmentalClearence"));
				JsonObject.put("environmentalClearenceDataIndex", rs.getString("EnvironmentalClearence"));
				
				informationList.add(rs.getString("SandBlockType"));
				JsonObject.put("sandBlockTypeDataIndex", rs.getString("SandBlockType"));
				
				informationList.add(rs.getString("SandBlockStatus"));
				JsonObject.put("sandBlockStatusDataIndex", rs.getString("SandBlockStatus"));
				
				informationList.add(rs.getString("AssessedQuantityMetrix"));
				JsonObject.put("assessedQuantityMetrixDataIndex", rs.getString("AssessedQuantityMetrix"));
				//JsonObject.put("assessedQuantityDataIndex", rs.getString("AssessedQuantity"));
				
			    float assessedQuantity1 = rs.getFloat("AssessedQuantity");
	            if (rs.getString("AssessedQuantity") == null || rs.getString("AssessedQuantity").equals("")) {
	            	informationList.add(rs.getString(""));
	                JsonObject.put("assessedQuantityDataIndex", "");
	            } else {
	            	informationList.add(assessedQuantity1);
	                JsonObject.put("assessedQuantityDataIndex",  df.format(assessedQuantity1));
	            }
	        	if(rs.getString("Total")!=null){
	        	 JsonObject.put("dispatchedQuantityDataIndex", rs.getString("Total"));
	        	 informationList.add(rs.getString("Total"));
	        	}
	        	else{
	        		JsonObject.put("dispatchedQuantityDataIndex", 0);
	        		informationList.add(0);
	        	}
	            informationList.add(rs.getString("DirectLoading"));
				JsonObject.put("wethereDirectLoadingIsAllowedDataIndex", rs.getString("DirectLoading"));
				
				informationList.add(rs.getString("AssociatedGeoFence"));
				JsonObject.put("associatedGeofenceDataIndex", rs.getString("AssociatedGeoFence"));
				JsonObject.put("uniqueIdDataIndex", rs.getString("UniqueId"));
				
				JsonObject.put("stateIdDataIndex", rs.getString("PortId"));
				JsonObject.put("districtIdDataIndex", rs.getString("PortDistrictID"));
				JsonObject.put("subDivisionIdDataIndex", rs.getString("SubDivisionId"));
				JsonObject.put("geoFenceIdDataIndex", rs.getString("geoFenceId"));
				
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
	
	public String insertContractorInformation(int custId, String state, String district,String subDivision, String taluka, String village, String gramPanchayat, String contractorName, String contractNo,String contractStartDate,String contractEndDate, String contractorStatus, String contractAddress, int systemId, int userId, String sandBlock, float contractorSandExcavationLimit) {
	    Connection con = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
	    String message = "";
	    try {
	        con = DBConnection.getConnectionToDB("ADMINISTRATOR");
	        pstmt = con.prepareStatement(SandMiningStatements.INSERT_CONTRACTOR_INFORMATION);
	        pstmt.setString(1, state);
	        pstmt.setString(2, district);
	        pstmt.setString(3, subDivision);
	        pstmt.setString(4, taluka);
	        pstmt.setString(5, village);
	        pstmt.setString(6, gramPanchayat);
	        pstmt.setString(7, contractorName);
	        pstmt.setString(8, contractNo);
	        pstmt.setString(9, contractStartDate);
	        pstmt.setString(10, contractEndDate);
	        pstmt.setString(11, contractorStatus);
            pstmt.setString(12, contractAddress);
            pstmt.setString(13, sandBlock);
            pstmt.setFloat(14, contractorSandExcavationLimit);
            pstmt.setInt(15, systemId);
	        pstmt.setInt(16, custId);
	        pstmt.setInt(17, userId);
	        int inserted = pstmt.executeUpdate();
	        if (inserted > 0) {
	            message = "Saved Successfully";
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	        DBConnection.releaseConnectionToDB(con, pstmt, rs);
	    }
	    return message;
	}

	public String modifyContractorInformation(int custId, int state, int district,int subDivision, String taluka, String village, String gramPanchayat, String contractorName, String contractNo, String contractStartDate,String contractEndDate, String contractorStatus, String contractAddress, int systemId, int userId ,int uniqueid,int sandBlock, float contractorSandExcavationLimit) {
	    Connection con = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
	    String message = "";
	    try {
	        con = DBConnection.getConnectionToDB("ADMINISTRATOR");
	        pstmt = con.prepareStatement(SandMiningStatements.UPDATE_CONTRACTOR_INFORMATION);
	        pstmt.setInt(1, state);
	        pstmt.setInt(2, district);
	        pstmt.setInt(3, subDivision);
	        pstmt.setString(4, taluka);
	        pstmt.setString(5, village);
	        pstmt.setString(6, gramPanchayat);
	        pstmt.setString(7, contractorName);
	        pstmt.setString(8, contractNo);
	        pstmt.setString(9, contractStartDate);
	        pstmt.setString(10, contractEndDate);
	        pstmt.setString(11, contractorStatus);
            pstmt.setString(12, contractAddress);
            pstmt.setInt(13, sandBlock);
            pstmt.setFloat(14, contractorSandExcavationLimit);
            pstmt.setInt(15, userId);
            pstmt.setInt(16, systemId);
	        pstmt.setInt(17, custId);
	        pstmt.setInt(18, uniqueid);
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

	public ArrayList < Object > getContractorReport(int systemId, int customerId,String language) {
	    JSONArray JsonArray = new JSONArray();
	    JSONObject JsonObject = null;
	    Connection con = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
	    ArrayList < Object > finlist = new ArrayList < Object > ();
		ArrayList < Object > reportsList = new ArrayList < Object > ();
		ArrayList < Object > headersList = new ArrayList < Object > ();
		ReportHelper finalreporthelper = new ReportHelper();
	    try {
	        int count = 0;
	        headersList.add(cf.getLabelFromDB("SLNO", language));
	        headersList.add(cf.getLabelFromDB("UniqueId_No", language));
	        headersList.add(cf.getLabelFromDB("State", language));
	        headersList.add(cf.getLabelFromDB("District", language));
	        headersList.add(cf.getLabelFromDB("Sub_Division", language));
	        headersList.add(cf.getLabelFromDB("Taluka", language));
	        headersList.add(cf.getLabelFromDB("Village", language));
	        headersList.add(cf.getLabelFromDB("Gram_Panchayat", language));
	        headersList.add(cf.getLabelFromDB("Contractor_Name", language));
	        headersList.add(cf.getLabelFromDB("Contract_No", language));
	        headersList.add(cf.getLabelFromDB("Contract_Start_Date", language));
	        headersList.add(cf.getLabelFromDB("Contract_End_Date", language));
	        headersList.add(cf.getLabelFromDB("Contractor_Status", language));
	        headersList.add(cf.getLabelFromDB("Contractor_Adress", language));
	        headersList.add(cf.getLabelFromDB("Sand_Block", language));
	        headersList.add(cf.getLabelFromDB("Contractor_Sand_Excavation_Limit", language));
	        
	        con = DBConnection.getConnectionToDB("ADMINISTRATOR");
	        //SimpleDateFormat sdf = new SimpleDateFormat("dd-MM-yyyy");
	        SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
	        pstmt = con.prepareStatement(SandMiningStatements.GET_CONTRACTOR_REPORT);
	        pstmt.setInt(1, systemId);
	        pstmt.setInt(2, customerId);
	        rs = pstmt.executeQuery();
	        while (rs.next()) {
	            JsonObject = new JSONObject();
	            count++;
	           	ArrayList<Object> informationList = new ArrayList<Object>();
				ReportHelper reporthelper = new ReportHelper();
				
				informationList.add(count);
	            JsonObject.put("slnoIndex", count);
	            
	            informationList.add(rs.getString("UNIQUEID"));
	            JsonObject.put("UniqueidIndex", rs.getString("UNIQUEID"));
	            
	            informationList.add(rs.getString("STATEID"));
	            JsonObject.put("stateIndex",rs.getString("STATEID"));
	            
	            informationList.add(rs.getString("DISTRICTID"));
	            JsonObject.put("districtDataIndex", rs.getString("DISTRICTID"));
	            
	            informationList.add(rs.getString("SUBDIVISION"));
	            JsonObject.put("subDivisionDataIndex", rs.getString("SUBDIVISION"));
	            
	            informationList.add(rs.getString("TALUKA"));
	            JsonObject.put("talukaDataIndex", rs.getString("TALUKA"));
	            
	            informationList.add(rs.getString("VILLAGE"));
	            JsonObject.put("villageDataIndex", rs.getString("VILLAGE"));
	            
	            informationList.add(rs.getString("GRAMPANCHAYAT"));
	            JsonObject.put("gramPanchayatDataIndex", rs.getString("GRAMPANCHAYAT"));
	            
	            informationList.add(rs.getString("CONTRACTORNAME"));
	            JsonObject.put("contractorNameDataIndex", rs.getString("CONTRACTORNAME"));
	            
	            informationList.add(rs.getString("CONTRACTNO"));
	            JsonObject.put("contractNoDataIndex", rs.getString("CONTRACTNO"));
	            
	            if (rs.getString("CONTRACTSTARTDATE") == null || rs.getString("CONTRACTSTARTDATE").equals("") || rs.getString("CONTRACTSTARTDATE").contains("1900")) {
	            	informationList.add("");
	                JsonObject.put("contractStartDateDataIndex", "");
	            } else {
	            	informationList.add(rs.getString("CONTRACTSTARTDATE"));
	                JsonObject.put("contractStartDateDataIndex", sdf.format(rs.getTimestamp("CONTRACTSTARTDATE")));
	            }
	          //  JsonObject.put("contractStartDateDataIndex", rs.getString("CONTRACTSTARTDATE"));
	         
	          //  JsonObject.put("contractEndDateDataIndex", rs.getString("CONTRACTENDDATE"));
	            
	            if (rs.getString("CONTRACTENDDATE") == null || rs.getString("CONTRACTENDDATE").equals("") || rs.getString("CONTRACTENDDATE").contains("1900")) {
	            	informationList.add("");
	            	JsonObject.put("contractEndDateDataIndex", "");
	            } else {
	            	informationList.add(rs.getString("CONTRACTENDDATE"));
	                JsonObject.put("contractEndDateDataIndex", sdf.format(rs.getTimestamp("CONTRACTENDDATE")));
	            }
	            
	            informationList.add(rs.getString("CONTRACTORSTATUS"));
	            JsonObject.put("contractorStatusDataIndex", rs.getString("CONTRACTORSTATUS"));
	            
	            informationList.add(rs.getString("CONTRACTADDRESS"));
	            JsonObject.put("contractAddressDataIndex", rs.getString("CONTRACTADDRESS"));
	            
	            informationList.add(rs.getString("SANDBLOCKNAME"));
	            JsonObject.put("sandBlockDataIndex", rs.getString("SANDBLOCKNAME"));
	            
	            informationList.add(rs.getString("SANDEXCAVATIONLIMIT"));
	            JsonObject.put("ContractorSandExcavationLimitDataIndex", rs.getString("SANDEXCAVATIONLIMIT"));
	            
	            
	            JsonObject.put("stateId1DataIndex", rs.getString("StateID1"));
	            JsonObject.put("districtId1Index", rs.getString("DistrictId1"));
	            JsonObject.put("subDivisionId1DataIndex", rs.getString("SUBDIVISIONID"));
	            JsonObject.put("sandBlockId1DataIndex", rs.getString("SANDBLOCKID"));
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
	public JSONArray getSandBlocks(int custId,int systemId) {
        Connection conAdmin = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        JSONArray jsonArray = new JSONArray();
        JSONObject jsonObject = new JSONObject();
        try {
            conAdmin = DBConnection.getConnectionToDB("ADMINISTRATOR");
            pstmt = conAdmin.prepareStatement(SandMiningStatements.GET_SAND_BLOCKS);
            pstmt.setInt(1, systemId);
            pstmt.setInt(2, custId);
            pstmt.setString(3,"Cleared");
            pstmt.setString(4,"Active");
            pstmt.setString(5,"No");
            rs = pstmt.executeQuery();
            while (rs.next()) {
                jsonObject = new JSONObject();
                jsonObject.put("sandBlocksId", rs.getString("portNumber"));
                jsonObject.put("sandBlocksName", rs.getString("associatedSandBlocks"));
                jsonArray.put(jsonObject);
            }

        } catch (Exception e) {
        	 e.printStackTrace();
        } finally {
            DBConnection.releaseConnectionToDB(conAdmin, pstmt, rs);
        }
        return jsonArray;
    }
	public JSONArray getSandBlocksForContractor(int custId,int systemId) {
        Connection conAdmin = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        JSONArray jsonArray = new JSONArray();
        JSONObject jsonObject = new JSONObject();
        try {
            conAdmin = DBConnection.getConnectionToDB("AMS");
            pstmt = conAdmin.prepareStatement(SandMiningStatements.GET_SAND_BLOCKS_FOR_CONTRACTOR);
            pstmt.setInt(1, systemId);
            pstmt.setInt(2, custId);
            pstmt.setString(3,"Cleared");
            pstmt.setString(4,"Active");
            pstmt.setString(5,"No");
            rs = pstmt.executeQuery();
            while (rs.next()) {
                jsonObject = new JSONObject();
                jsonObject.put("sandBlockId", rs.getString("portNumber"));
                jsonObject.put("sandBlockName", rs.getString("associatedSandBlocks"));
                jsonArray.put(jsonObject);
            }

        } catch (Exception e) {
        	 e.printStackTrace();
        } finally {
            DBConnection.releaseConnectionToDB(conAdmin, pstmt, rs);
        }
        return jsonArray;
    }
	
	public JSONArray getAssignedContractor(int custId,int systemId) {
        Connection conAdmin = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        JSONArray jsonArray = new JSONArray();
        JSONObject jsonObject = new JSONObject();
        try {
            conAdmin = DBConnection.getConnectionToDB("ADMINISTRATOR");
            pstmt = conAdmin.prepareStatement(SandMiningStatements.GET_ASSGN_CONTRACTOR);
            pstmt.setInt(1, systemId);
            pstmt.setInt(2, custId);
           
            rs = pstmt.executeQuery();
            while (rs.next()) {
                jsonObject = new JSONObject();
                jsonObject.put("assignedContractorId", rs.getString("assignedContractor"));
                jsonObject.put("assignedContractorName", rs.getString("assignedContractor"));
                jsonArray.put(jsonObject);
            }

        } catch (Exception e) {
        	 e.printStackTrace();
        } finally {
            DBConnection.releaseConnectionToDB(conAdmin, pstmt, rs);
        }
        return jsonArray;
    }
    
	public String insertDivisionInformation(int custId, String state,String district,String subDivision,String taluk,String gramPanchayat,String village,
			String sandStockyardName,String sandstockyardAddress,String riverName,String capacityofStockyard,String capacityMetric,String associatedGeofence,
			String associatedSandBlocks,String estimatedSandQuantity,String rateMetric,String rates,String assignedContractor,int userId,int systemId) {
	    Connection con = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
	    String message = "";
	    try {
	        con = DBConnection.getConnectionToDB("ADMINISTRATOR");
	        pstmt = con.prepareStatement(SandMiningStatements.INSERT_DIVISION_INFORMATION);
	       
	        pstmt.setInt(1,Integer.parseInt(state));
	        pstmt.setInt(2,Integer.parseInt( district));
	        pstmt.setInt(3,Integer.parseInt( subDivision));
	        pstmt.setString(4, taluk);
	        pstmt.setString(5, gramPanchayat);
	        pstmt.setString(6, village);
	        pstmt.setString(7, sandStockyardName);
	        pstmt.setString(8, sandstockyardAddress);
	        pstmt.setString(9, riverName);
	        pstmt.setString(10, capacityofStockyard);
	        pstmt.setString(11, capacityMetric);
	        pstmt.setString(12, associatedGeofence);
	        pstmt.setString(13, associatedSandBlocks);
	        pstmt.setString(14, estimatedSandQuantity);
	        pstmt.setString(15, rateMetric);
	        pstmt.setString(16,rates);
	        pstmt.setString(17,assignedContractor);
	        pstmt.setInt(18, systemId);
	        pstmt.setInt(19, custId);
	        pstmt.setInt(20,userId);
	        
	        int inserted = pstmt.executeUpdate();
	        if (inserted > 0) {
	            message = "Saved Successfully";
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	        DBConnection.releaseConnectionToDB(con, pstmt, rs);
	    }
	    return message;
	}
	
	public String modifyDivisionInformation(int custId, String state,String district,String subDivision,String taluk,String gramPanchayat,String village,
			String sandStockyardName,String sandstockyardAddress,String riverName,String capacityofStockyard,String capacityMetric,String associatedGeofence,
			String associatedSandBlocks,String estimatedSandQuantity,String rateMetric,String rates,String assignedContractor,int userId,int systemId,int id) {
	    Connection con = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
	    String message = "";
	    try {
	        con = DBConnection.getConnectionToDB("ADMINISTRATOR");
	        pstmt = con.prepareStatement(SandMiningStatements.UPDATE_DIVISION_INFORMATION);
	        pstmt.setInt(1,Integer.parseInt(state));
	        pstmt.setInt(2,Integer.parseInt( district));
	        pstmt.setInt(3,Integer.parseInt( subDivision));
	        pstmt.setString(4, taluk);
	        pstmt.setString(5, gramPanchayat);
	        pstmt.setString(6, village);
	        pstmt.setString(7, sandStockyardName);
	        pstmt.setString(8, sandstockyardAddress);
	        pstmt.setString(9, riverName);
	        pstmt.setString(10, capacityofStockyard);
	        pstmt.setString(11, capacityMetric);
	        pstmt.setString(12,associatedGeofence);
	        pstmt.setString(13, associatedSandBlocks);
	        pstmt.setString(14, estimatedSandQuantity);
	        pstmt.setString(15, rateMetric);
	        pstmt.setString(16,rates);
	        pstmt.setString(17,assignedContractor);
	        pstmt.setInt(18,userId);
	        pstmt.setInt(19, systemId);
	        pstmt.setInt(20, custId);
	        
	        pstmt.setInt(21,id);
	        
	        
	        int updated = pstmt.executeUpdate();
	        if (updated > 0) {
	        	message = "Updated Successfully";
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	    	   DBConnection.releaseConnectionToDB(con, pstmt, null);
	    }
	    return message;
	}
	public ArrayList < Object > getDivisionMasterReport(int systemId, int customerId,String language) {
	    JSONArray JsonArray = new JSONArray();
	    JSONObject JsonObject = null;
	    Connection con = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
	    PreparedStatement pstmt1 = null;
	    ResultSet rs1 = null;
	    PreparedStatement pstmt2 = null;
	    ResultSet rs2 = null;
	    
	    ArrayList < Object > finlist = new ArrayList < Object > ();
	    ArrayList< Object > reportsList = new ArrayList < Object > ();
		ArrayList < Object > headersList = new ArrayList < Object > ();
		ReportHelper finalreporthelper = new ReportHelper();
	    DecimalFormat df = new DecimalFormat("##.##");
	    float SandQuantityAvailableStockyard =0.0f;
	    float SandQuantityAvailable = 0.0f;
	    float SeizedQuantity=0.0f;
	    float DirectQuantity=0;
	    try {
	    	int count = 0;
	        headersList.add(cf.getLabelFromDB("SLNO", language));
	       // headersList.add(cf.getLabelFromDB("UniqueId_No", language));
	        headersList.add(cf.getLabelFromDB("State", language));
	        headersList.add(cf.getLabelFromDB("District", language));
	        headersList.add(cf.getLabelFromDB("Sub_Division", language));
	        headersList.add(cf.getLabelFromDB("Taluka", language));
	        headersList.add(cf.getLabelFromDB("Gram_Panchayat", language));
	        headersList.add(cf.getLabelFromDB("Village", language));
	        headersList.add(cf.getLabelFromDB("Sand_Stockyard_Name", language));
	        headersList.add(cf.getLabelFromDB("Sand_Stockyard_Address", language));
	        headersList.add(cf.getLabelFromDB("River_Name", language));
	        headersList.add(cf.getLabelFromDB("Capacity_Of_Stockyard", language));
	        headersList.add(cf.getLabelFromDB("Capacity_Metric", language));
	        headersList.add(cf.getLabelFromDB("Associated_Geofence", language));
	        headersList.add(cf.getLabelFromDB("Associated_Sand_Blocks", language));
	        headersList.add(cf.getLabelFromDB("Estimated_Sand_Quantity_Available", language));
	        headersList.add("Seized Quantity");
	        headersList.add("Direct Quantity");
	        headersList.add("Dispatched Quantity");
	        headersList.add("Available Quantity");
	        headersList.add(cf.getLabelFromDB("Rate_Metric", language));
	        headersList.add(cf.getLabelFromDB("Rate", language));
	        headersList.add(cf.getLabelFromDB("Assigned_Contractor", language));
	        
	  
	        con = DBConnection.getConnectionToDB("ADMINISTRATOR");
	        pstmt = con.prepareStatement(SandMiningStatements.GET_DIVISION_MASTER_REPORT);
	        pstmt.setInt(1, systemId);
	        pstmt.setInt(2, customerId);
	        rs = pstmt.executeQuery();
	        while (rs.next()) {
	            JsonObject = new JSONObject();
	            count++;
	            ArrayList<Object> informationList = new ArrayList<Object>();
				ReportHelper reporthelper = new ReportHelper();
				
				String stockyard = rs.getString("SandStockYardName");
				String uniqueid=rs.getString("uniqueId");
				
	            informationList.add(count);
	            JsonObject.put("slnoIndex", count);
	            
	           // informationList.add(rs.getString("uniqueId"));
	            JsonObject.put("UniqueIdDataIndex",Integer.parseInt(rs.getString("uniqueId")));
	            
	            informationList.add(rs.getString("StateName"));
	            JsonObject.put("StateDataIndex", rs.getString("StateName"));
	            
	            informationList.add(rs.getString("DistrictName"));
	            JsonObject.put("DistrictDataIndex", rs.getString("DistrictName"));
	            
	            informationList.add(rs.getString("GroupName"));
	            JsonObject.put("SubDivisionDataIndex", rs.getString("GroupName"));
	            
	            informationList.add(rs.getString("Taluka"));
	            JsonObject.put("TalukDataIndex", rs.getString("Taluka"));
	            
	            informationList.add(rs.getString("GramPanchayat"));
	            JsonObject.put("GramPanchayatDataIndex", rs.getString("GramPanchayat"));
	            
	            informationList.add(rs.getString("Village"));
	            JsonObject.put("VillageDataIndex", rs.getString("Village"));
	            
	            informationList.add(rs.getString("SandStockYardName"));
	            JsonObject.put("SandStockyardNameDataIndex", rs.getString("SandStockYardName"));
	            
	            informationList.add(rs.getString("SandStockYardAddress"));
	            JsonObject.put("SandStockyardAddressDataIndex", rs.getString("SandStockYardAddress"));
	            
	            informationList.add(rs.getString("RiverName"));
	            JsonObject.put("RiverNameDataIndex", rs.getString("RiverName"));
	            
	            float capacityOfStockyard = rs.getFloat("capacityOfStockyard");
	            if (rs.getString("capacityOfStockyard") == null || rs.getString("capacityOfStockyard").equals("")) {
	            	informationList.add("");
	                JsonObject.put("CapacityofStockyardDataIndex", "");
	            } else {
	            	informationList.add(capacityOfStockyard);
	                JsonObject.put("CapacityofStockyardDataIndex",  df.format(capacityOfStockyard));
	            }
	            //JsonObject.put("CapacityofStockyardDataIndex", rs.getString("capacityOfStockyard"));
	            informationList.add(rs.getString("capacityMetric"));
	            JsonObject.put("CapacityMetricDataIndex", rs.getString("capacityMetric")); 
	            
	            informationList.add(rs.getString("associatedGeofence"));
	            JsonObject.put("AssociatedGeofenceDataIndex", rs.getString("associatedGeofence"));
	            
	            informationList.add(rs.getString("associatedSandBlocks"));
	            JsonObject.put("AssociatedSandBlocksDataIndex",rs.getString("associatedSandBlocks"));
	            
//	            JsonObject.put("EstimatedSandQuantityAvailableDataIndex", rs.getString("estimatedSandQuantity"));
//	            
//	            float estimatedSandQuantity = rs.getFloat("estimatedSandQuantity");
//	            if (rs.getString("estimatedSandQuantity") == null || rs.getString("estimatedSandQuantity").equals("")) {
//	            	informationList.add("");
//	                JsonObject.put("EstimatedSandQuantityAvailableDataIndex", "");
//	            } else {
//	            	informationList.add(estimatedSandQuantity);
//	                JsonObject.put("EstimatedSandQuantityAvailableDataIndex",  df.format(estimatedSandQuantity));
//	            }
	            pstmt2 = con.prepareStatement("select isnull(sum(QUANTITY),0) as Dumped_Quantity from AMS.dbo.SAND_INWARD_TRIP_SHEET where SYSTEM_ID=? AND CUSTOMER_ID=? AND STOCKYARD_ID=? and PRINTED='Y'");
	            pstmt2.setInt(1, systemId);
		        pstmt2.setInt(2, customerId);
		        pstmt2.setString(3, uniqueid);
		        rs2 = pstmt2.executeQuery();
		        if(rs2.next()){
		        	 JsonObject.put("EstimatedSandQuantityAvailableDataIndex", rs2.getString("Dumped_Quantity"));
			            
			            float estimatedSandQuantity = rs2.getFloat("Dumped_Quantity");
			            if (rs2.getString("Dumped_Quantity") == null || rs2.getString("Dumped_Quantity").equals("")) {
			            	informationList.add("");
			                JsonObject.put("EstimatedSandQuantityAvailableDataIndex", "");
		                } else {
			            	informationList.add(estimatedSandQuantity);
			                JsonObject.put("EstimatedSandQuantityAvailableDataIndex",  df.format(estimatedSandQuantity));
			            }
		        }
	            if(rs.getString("REMARKS").equals("SIEZED")){
	            	SeizedQuantity=rs.getFloat("SeizedQuantity");
	            	DirectQuantity=0;
		            informationList.add(df.format(SeizedQuantity));
		            JsonObject.put("SeizedQuantityDataIndex",df.format(SeizedQuantity));
		            informationList.add(0);
		            JsonObject.put("DirectQuantityDataIndex",0);
		            
	            }else if(rs.getString("REMARKS").equals("DIRECT")){
	            	informationList.add(0);
		            JsonObject.put("SeizedQuantityDataIndex",0);
	            	DirectQuantity=rs.getFloat("SeizedQuantity");
	            	SeizedQuantity=0;
		            informationList.add(df.format(DirectQuantity));
		            JsonObject.put("DirectQuantityDataIndex",df.format(DirectQuantity));
	            }else{
	            	DirectQuantity=0;
	            	SeizedQuantity=0;
	            	informationList.add(0);
		            JsonObject.put("SeizedQuantityDataIndex",0);
		            informationList.add(0);
		            JsonObject.put("DirectQuantityDataIndex",0);
	            }
	            
		        pstmt1 = con.prepareStatement("select isnull(sum(TotalQuantity),0 ) as Total from "
		        	+"	(select sum (cast(Left(SubString(Quantity, PatIndex('%[0-9.-]%', Quantity), 8000), PatIndex('%[^0-9.-]%', SubString(Quantity, PatIndex('%[0-9.-]%', Quantity), 8000)  + 'X')-1) AS decimal (18,2))) as TotalQuantity "
		        		+ "from AMS.dbo.Sand_Mining_Trip_Sheet_History "
		        			+"	where System_Id=? and Client_Id=? and From_Place=? "
		        			+"	union all "
		        			+"	select sum (cast(Left(SubString(Quantity, PatIndex('%[0-9.-]%', Quantity), 8000), PatIndex('%[^0-9.-]%', SubString(Quantity, PatIndex('%[0-9.-]%', Quantity), 8000)  + 'X')-1) AS decimal (18,2))) as TotalQuantity "
		        			+"	from AMS.dbo.Sand_Mining_Trip_Sheet "
		        			+"	where System_Id=? and Client_Id=? and From_Place=?) sm ");
		        pstmt1.setInt(1, systemId);
		        pstmt1.setInt(2, customerId);
		        pstmt1.setString(3, stockyard);
		        pstmt1.setInt(4, systemId);
		        pstmt1.setInt(5, customerId);
		        pstmt1.setString(6, stockyard);
		        rs1 = pstmt1.executeQuery();
				
		        if(rs1.next()){
		        	if(rs1.getString("Total")!=null){
		        	 SandQuantityAvailable = rs2.getFloat("Dumped_Quantity");
		        	 SandQuantityAvailableStockyard = (SandQuantityAvailable+SeizedQuantity+DirectQuantity) -  Float.parseFloat(rs1.getString("Total"));
		        	 JsonObject.put("DispatchedQtyDataIndex", rs1.getString("Total"));
		        	 informationList.add(rs1.getString("Total"));
		        	 JsonObject.put("AvailableQtyDataIndex", df.format(SandQuantityAvailableStockyard));
		        	 informationList.add(df.format(SandQuantityAvailableStockyard));
		        	}
		        	else{
		        		SandQuantityAvailable = rs2.getFloat("Dumped_Quantity");
		        		JsonObject.put("DispatchedQtyDataIndex", 0);
		        		informationList.add(0);
		        		JsonObject.put("AvailableQtyDataIndex", df.format(SandQuantityAvailable));
		        		informationList.add(df.format(SandQuantityAvailable));
		        	}
		        }
				
	            
	            informationList.add(rs.getString("rateMetric"));
	            JsonObject.put("RateMetricDataIndex", rs.getString("rateMetric"));
	            
	            informationList.add(rs.getString("rate"));
	            JsonObject.put("RateDataIndex", rs.getString("rate"));
	            
	            informationList.add(rs.getString("assignedContractor"));
	            JsonObject.put("AssignedContractorDataIndex", rs.getString("assignedContractor"));
	            
	            JsonObject.put("StateIdDataIndex", rs.getString("StateId"));
	            JsonObject.put("DistrictIdDataIndex", rs.getString("DistrictId"));
	            JsonObject.put("groupIdDataIndex", rs.getString("groupId"));
	            JsonObject.put("AssociatedGeofenceIdDataIndex", rs.getString("geofenceId"));
	            
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
	    	DBConnection.releaseConnectionToDB(null, pstmt1, rs1);
	        DBConnection.releaseConnectionToDB(con, pstmt, rs);
	    }
	    return finlist;
	}
	
	public ArrayList<Object> getHubArrDepReportNew(int systemId,int clientId,int userId,String zone,int offset,String language)
	{
		    JSONArray JsonArray = null;
		    Connection con = null;
		    PreparedStatement pstmt = null;
		    PreparedStatement pstmt1 = null;
		    JSONObject hubdetails = null;
		    ArrayList < String > headersList = new ArrayList < String > ();
		    String hubIds="";
		    String hubidsnew="";
		    String HUB_ARR_DEP="";
		    String existingVehicle="";
		    int count=0;
		    ResultSet rs = null;
		    ResultSet rs1 = null;
		    
		    ArrayList < ReportHelper > reportsList = new ArrayList < ReportHelper > ();
			ReportHelper finalreporthelper = new ReportHelper();
			ArrayList < Object > finlist = new ArrayList < Object > ();
            
		    try {
		    JsonArray = new JSONArray();
		    headersList.add(cf.getLabelFromDB("SLNO", language));
		    headersList.add(cf.getLabelFromDB("Registration_No", language));
		    headersList.add(cf.getLabelFromDB("Location", language));
		    headersList.add(cf.getLabelFromDB("Actual_Arrival", language));
		    headersList.add(cf.getLabelFromDB("Actual_Departure", language));
		    headersList.add(cf.getLabelFromDB("Detention_Duration(HH:MM)", language));
		    headersList.add(cf.getLabelFromDB("Owner_Name", language));
		    
		    con = DBConnection.getConnectionToDB("AMS");	
		    pstmt=con.prepareStatement(SandMiningStatements.GET_ASSOCIATED_HUBS_NEW.replace("LOCATION", "LOCATION_ZONE_"+zone));
		    pstmt.setInt(1,userId);
		    pstmt.setInt(2,systemId);
		    pstmt.setInt(3,clientId);
		    rs=pstmt.executeQuery();
		    while(rs.next())
		    {
		    hubIds=rs.getString("HUBID")+","+hubIds;	
		    }
		    if(hubIds.length()==0)
		    {
		    pstmt=con.prepareStatement(SandMiningStatements.GET_HUB_NAMES_FOR_CLIENT.replace("LOCATION", "LOCATION_ZONE_"+zone));
		    pstmt.setInt(1,systemId);
		    pstmt.setInt(2,clientId);
		    rs=pstmt.executeQuery();
		    while(rs.next())
		    {
		    hubIds=rs.getString("HUBID")+","+hubIds;
		    }
		    }
		    if(hubIds.length()>0)
		    {hubIds=hubIds.substring(0,hubIds.length()-1);}
		    else
		    {hubIds="0";}
		    pstmt1=con.prepareStatement(SandMiningStatements.SELECT_REGISTRATION_NO_FROM_USER_VEHICLE);
		    pstmt1.setInt(1,clientId);
		    pstmt1.setInt(2,systemId);
		    rs1=pstmt1.executeQuery();
		    while(rs1.next())
		    {
		    String veh = rs1.getString("Registration_no");
			if (!veh.equals("")) {
			existingVehicle = existingVehicle + "'" + veh + "'" + ",";
			}
		    }
		    if(existingVehicle.length()>0)
		    existingVehicle=existingVehicle.substring(0,existingVehicle.length()-1);
		    else
		    existingVehicle="0";
		    HUB_ARR_DEP="select REGISTRATION_NO as[REGISTRATION NO],LOCATION,dateadd(mi,?,ACTUAL_ARRIVAL)"
					+ " as [ACTUAL ARRIVAL],ACTUAL_ARRIVAL as ARRIVALGMT,ARRIVAL_TEMPERATURE as ARRIVAL_TEMPERATURE,dateadd(mi,?,ACTUAL_DEPARTURE) as [ACTUAL DEPARTURE],DEPARTURE_TEMPERATURE as DEPARTURE_TEMPERATURE,DATEDIFF(mi,ACTUAL_ARRIVAL,ACTUAL_DEPARTURE)"
					+ " as [DURATION], case when ACTUAL_DEPARTURE is null then  DATEDIFF(mi,ACTUAL_ARRIVAL,getUTCdate()) else 0 end as [DETENTION],'' as DRIVER, "
					+ " isnull(stdtime.scht,'NA') as [STANDARD],isnull(stdtime.diffhh,'NA') [DEVIATION],STANDARD_DURATION as [STANDARD_DURATION],isnull(vm.OwnerName,'')as OwnerName from HUB_REPORT (nolock) "
					+ " outer apply dbo.GetStandardandDeviationTime(HUB_ID,CONVERT(numeric,SUBSTRING(CONVERT(VARCHAR(8),dateadd(mi,?,ACTUAL_ARRIVAL),108),1,2)),CONVERT(numeric,SUBSTRING(CONVERT(VARCHAR(8),dateadd(mi,?,ACTUAL_ARRIVAL),108),4,2))) stdtime"
					+ " left outer join dbo.tblVehicleMaster vm on HUB_REPORT.REGISTRATION_NO=vm.VehicleNo where"
					+ " (ACTUAL_ARRIVAL between ? and ? or ACTUAL_DEPARTURE between ? and ?) and HUB_ID in ("
					+ hubIds
					+ ")and REGISTRATION_NO in ("
					+ existingVehicle
					+ ")and SYSTEM_ID=?"
					+ " group by REGISTRATION_NO,LOCATION,ACTUAL_ARRIVAL,ACTUAL_DEPARTURE,ARRIVAL_TEMPERATURE,DEPARTURE_TEMPERATURE,stdtime.scht,stdtime.diffhh,STANDARD_DURATION,vm.OwnerName"
					+ " order by REGISTRATION_NO,[ACTUAL ARRIVAL]";
		    
		    Date date=new Date();
		    String startDate=cf.getGMTDateTime(sdfmmddyyyy.format(date)+" 00:00:00", offset);
		    String endDate=cf.getGMTDateTime(cf.setNextDateForReportsNew()+" 00:00:00", offset);
		    pstmt = con.prepareStatement(HUB_ARR_DEP);
			pstmt.setInt(1, offset);
			pstmt.setInt(2, offset);
			pstmt.setInt(3, offset);
			pstmt.setInt(4, offset);
			pstmt.setString(5, startDate);
			pstmt.setString(6, endDate);
			pstmt.setString(7, startDate);
			pstmt.setString(8, endDate);
			pstmt.setInt(9, systemId);
			
			rs=pstmt.executeQuery();
			while(rs.next())
			{
			ArrayList < Object > informationList = new ArrayList < Object > ();
		    ReportHelper reporthelper = new ReportHelper();
			count++;
			hubdetails=new JSONObject();
			hubdetails.put("slnoIndex",count);
			informationList.add(count);
			hubdetails.put("assetNumberDataIndex", rs.getString("REGISTRATION NO"));
			informationList.add(rs.getString("REGISTRATION NO"));
			hubdetails.put("locationIndex",rs.getString("LOCATION"));
			informationList.add(rs.getString("LOCATION"));
			hubdetails.put("actualarrivalIndex",rs.getString("ACTUAL ARRIVAL"));
			informationList.add(rs.getString("ACTUAL ARRIVAL"));
			if(rs.getString("ACTUAL DEPARTURE")!=null && rs.getString("ACTUAL DEPARTURE")!="")
			{hubdetails.put("actualdepartureIndex",rs.getString("ACTUAL DEPARTURE"));
			informationList.add(rs.getString("ACTUAL DEPARTURE"));
			hubdetails.put("detentionIndex",cf.convertMinutesToHHMMFormat1(Integer.parseInt(rs.getString("DURATION"))));
			}
			else
			{
			hubdetails.put("actualdepartureIndex","");
			informationList.add("");	
			hubdetails.put("detentionIndex",cf.convertMinutesToHHMMFormat1(Integer.parseInt(rs.getString("DETENTION"))));
			}
			
			informationList.add(cf.convertMinutesToHHMMFormat1(Integer.parseInt(rs.getString("DETENTION"))));
			hubdetails.put("ownernameIndex",rs.getString("OwnerName"));
			informationList.add(rs.getString("OwnerName"));
			
			JsonArray.put(hubdetails);
			reporthelper.setInformationList(informationList);
			reportsList.add(reporthelper);
			}
			finalreporthelper.setReportsList(reportsList);
	        finalreporthelper.setHeadersList(headersList);
	        finlist.add(JsonArray);
	        finlist.add(finalreporthelper);
		    }
		catch (Exception e) {
			// TODO: handle exception
		}finally {
	        DBConnection.releaseConnectionToDB(con, pstmt, rs);
	    }
		return finlist;
	}
	
	public JSONArray getcontractorBasedOnCustomer(int systemId, int custId) {
	    JSONArray JsonArray = null;
	    JSONObject JsonObject = null;
	    Connection con = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
	    try {
	        JsonArray = new JSONArray();
	        con = DBConnection.getConnectionToDB("AMS");
	        pstmt = con.prepareStatement(SandMiningStatements.GET_CONTRACTORS);
	        pstmt.setInt(1, systemId);
	        pstmt.setInt(2, custId);
	        rs = pstmt.executeQuery();
	        while (rs.next()) {
	            JsonObject = new JSONObject();
	            JsonObject.put("contractorId", rs.getInt("UNIQUE_ID"));
	            JsonObject.put("contractorName", rs.getString("CONTRACTOR_NAME"));
	            JsonArray.put(JsonObject);
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	        DBConnection.releaseConnectionToDB(con, pstmt, rs);
	    }
	    return JsonArray;
	}		 
	
	public JSONArray getDataForNonAssociation(int systemId,int customerId, int contractorId, int userId) {
	     JSONArray JsonArray = new JSONArray();
	     JSONObject JsonObject = null;
	     Connection con = null;
	     PreparedStatement pstmt = null;
	     ResultSet rs = null;
	     try {
	         int count = 0;
	         con = DBConnection.getConnectionToDB("AMS");
	             pstmt = con.prepareStatement(SandMiningStatements.GET_NON_ASSOCIATION_DATA);
	             pstmt.setInt(1, systemId);
	             pstmt.setInt(2, customerId);
	             pstmt.setInt(3, userId);
	             pstmt.setInt(4, customerId);
	             pstmt.setInt(5, systemId);
	             pstmt.setInt(6, contractorId);
	             rs = pstmt.executeQuery();
	         while (rs.next()) {
	             JsonObject = new JSONObject();
	             count++;
	             JsonObject.put("slnoIndex", count);
	             JsonObject.put("vehicleNoDataIndex", rs.getString("VehicleNo"));
	             JsonArray.put(JsonObject);
	         }
	         //finlist.add(JsonArray);
	     } catch (Exception e) {
	         e.printStackTrace();
	     } finally {
	         DBConnection.releaseConnectionToDB(con, pstmt, rs);
	     }
	     return JsonArray;
	 }
	 
	public JSONArray getDataForAssociation(int systemId,int customerId, int contractorId) {
	     JSONArray JsonArray = new JSONArray();
	     JSONObject JsonObject = null;
	     Connection con = null;
	     PreparedStatement pstmt = null;
	     ResultSet rs = null;
	     try {
	         int count = 0;
	         con = DBConnection.getConnectionToDB("AMS");
	             pstmt = con.prepareStatement(SandMiningStatements.GET_ASSOCIATION_DATA);
	             pstmt.setInt(1, systemId);
	             pstmt.setInt(2, customerId);
	             pstmt.setInt(3, contractorId);
	             rs = pstmt.executeQuery();
	         while (rs.next()) {
	             JsonObject = new JSONObject();
	             count++;
	             JsonObject.put("slnoIndex2", count);
	             JsonObject.put("vehicleNoDataIndex2", rs.getString("REGISTRATION_NO"));
	             JsonArray.put(JsonObject);
	         }
	     } catch (Exception e) {
	         e.printStackTrace();
	     } finally {
	         DBConnection.releaseConnectionToDB(con, pstmt, rs);
	     }
	     return JsonArray;
	 }
	 
	public String associateVehicle(int customerId, int systemId, int contractorIdFromJsp, JSONArray js,int userId) {
	    Connection con = null;
	    PreparedStatement pstmt3 = null;
	    String message = "";
	    ArrayList < String > vehicleList = new ArrayList < String > ();
	    try {
	        con = DBConnection.getConnectionToDB("AMS");
	        for (int i = 0; i < js.length(); i++) {
	            vehicleList.clear();
	            JSONObject obj = js.getJSONObject(i);
	            String vehicleNo = obj.getString("vehicleNoDataIndex");
	            
	                pstmt3 = con.prepareStatement(SandMiningStatements.INSERT_INTO_CONTRACTOR_VEHICLE_ASSOCIATION);
	                pstmt3.setInt(1, systemId);
	                pstmt3.setInt(2, customerId);
	                pstmt3.setInt(3, contractorIdFromJsp);
	                pstmt3.setString(4, vehicleNo);
	                pstmt3.setInt(5, userId);
	                pstmt3.executeUpdate();
	        }
	        message = "Associated Successfully.";
	    } catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	        DBConnection.releaseConnectionToDB(con, pstmt3, null);
	    }
	    return message;
	}
	public String dissociateVehicle(int customerId, int systemId, int contractorIdFromJsp, JSONArray js,int userId) {
	    Connection con = null;
	    PreparedStatement pstmt2 = null;
	    PreparedStatement pstmt = null;
	    PreparedStatement pstmt1=null;
	    ResultSet rs = null;
	    ResultSet rs1 = null;
	    String message = "";
	    ArrayList < String > vehicleList = new ArrayList < String > ();
	    try {
	        con = DBConnection.getConnectionToDB("AMS");
	        for (int i = 0; i < js.length(); i++) {
	            JSONObject obj = js.getJSONObject(i);
	            vehicleList.clear();
	            String vehicleNo = obj.getString("vehicleNoDataIndex2");
	            
	            pstmt1=con.prepareStatement(SandMiningStatements.SELECT_DATA_FROM_CONTRACTOR_VEHICLE_ASSOCIATION);
	            pstmt1.setInt(1, contractorIdFromJsp);
	            pstmt1.setString(2, vehicleNo);
	            rs1 = pstmt1.executeQuery();
	            if (rs1.next()) {
	            	
	            pstmt = con.prepareStatement(SandMiningStatements.MOVE_DATA_TO_CONTRACTOR_VEHICLE_ASSOCIATION_HISTORY);
	            pstmt.setInt(1, systemId);
                pstmt.setInt(2, customerId);
                pstmt.setInt(3, contractorIdFromJsp);
                pstmt.setString(4, vehicleNo);
                pstmt.setString(5, rs1.getString("ASSOCIATED_TIME"));
                pstmt.setInt(6, rs1.getInt("ASSOCIATED_BY"));
                pstmt.setInt(7, userId);
                
	            int inserted1 =pstmt.executeUpdate();
	            if(inserted1 > 0)
	            {
	            pstmt2 = con.prepareStatement(SandMiningStatements.DELETE_FROM_CONTRACTOR_VEHICLE_ASSOCIATION);
	            pstmt2.setInt(1, contractorIdFromJsp);
	            pstmt2.setInt(2, customerId);
	            pstmt2.setInt(3, systemId);
	            pstmt2.setString(4, vehicleNo);
	            pstmt2.executeUpdate();
	            }
	            }
	        }
	        message = "Disassociated Successfully.";
	    } catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	        DBConnection.releaseConnectionToDB(null, pstmt2, null);
	        DBConnection.releaseConnectionToDB(null, pstmt, null);
	        DBConnection.releaseConnectionToDB(con, pstmt1, rs1);
	    }
	    return message;
	}
	
	public JSONArray getContractor(int custId,int systemId) {
        Connection conAdmin = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        JSONArray jsonArray = new JSONArray();
        JSONObject jsonObject = new JSONObject();
        try {
            conAdmin = DBConnection.getConnectionToDB("AMS");
            pstmt = conAdmin.prepareStatement(SandMiningStatements.GET_CONTRACTORS);
           // pstmt.setInt(1, custId);
            pstmt.setInt(1, systemId);
          //  pstmt.setInt(3, systemId);
             pstmt.setInt(2, custId);
            rs = pstmt.executeQuery();
            while (rs.next()) {
                jsonObject = new JSONObject();
                jsonObject.put("contractor_id", rs.getString("UNIQUE_ID"));
                jsonObject.put("contractor_name", rs.getString("CONTRACTOR_NAME"));
                jsonArray.put(jsonObject);
            }

        } catch (Exception e) {
        	 e.printStackTrace();
        } finally {
            DBConnection.releaseConnectionToDB(conAdmin, pstmt, rs);
        }
        return jsonArray;
    }	
	public String getContractNo(int custId,int systemId,int contractorId) {
        Connection conAdmin = null;
        PreparedStatement pstmt = null;
        String contractNo="";
        ResultSet rs = null;
        try {
            conAdmin = DBConnection.getConnectionToDB("AMS");
            pstmt = conAdmin.prepareStatement(SandMiningStatements.GET_CONTRACTOR_NO);
            pstmt.setInt(1, systemId);
            pstmt.setInt(2, custId);
            pstmt.setInt(3, contractorId);
            rs = pstmt.executeQuery();
            while (rs.next()) {
            	contractNo=rs.getString("CONTRACT_NO") ; 
            }

        } catch (Exception e) {
        	 e.printStackTrace();
        } finally {
            DBConnection.releaseConnectionToDB(conAdmin, pstmt, rs);
        }
        return contractNo;
    }
	
	public JSONArray getSandBlocksFrom(int custId,int systemId,String contractorId) {
		 Connection conAdmin = null;
	        PreparedStatement pstmt = null;
	        ResultSet rs = null;
	        JSONArray jsonArray = new JSONArray();
	        JSONObject jsonObject = new JSONObject();
        try {
        	 
                 conAdmin = DBConnection.getConnectionToDB("AMS");
                 pstmt = conAdmin.prepareStatement(SandMiningStatements.GET_SANDBLOCKS_FROM);
               
                 pstmt.setInt(1, systemId);
                 pstmt.setInt(2, custId);
                 pstmt.setString(3, contractorId);
                 rs = pstmt.executeQuery();
                 while (rs.next()) {
                     jsonObject = new JSONObject();
                     jsonObject.put("sandblock_name", rs.getString("Port_Name"));
                     jsonObject.put("sandblock_id", rs.getString("UniqueId"));
                     jsonArray.put(jsonObject);
                 }

             } catch (Exception e) {
             	 e.printStackTrace();
             } finally {
                 DBConnection.releaseConnectionToDB(conAdmin, pstmt, rs);
             }
             return jsonArray;
         }	
	
	public JSONArray getStockyardsTo(int custId,int systemId) {
		 Connection conAdmin = null;
	        PreparedStatement pstmt = null;
	        ResultSet rs = null;
	        JSONArray jsonArray = new JSONArray();
	        JSONObject jsonObject = new JSONObject();
	        
       try {
       	 
                conAdmin = DBConnection.getConnectionToDB("AMS");
                pstmt = conAdmin.prepareStatement(SandMiningStatements.GET_STOCKYARDS_TO);
              
               pstmt.setInt(1, systemId);
               pstmt.setInt(2, custId);
                rs = pstmt.executeQuery();
                while (rs.next()) {
                    jsonObject = new JSONObject();
                    jsonObject.put("stockyard_name", rs.getString("SAND_STOCKYARD_NAME"));
                    jsonObject.put("stockyard_id", rs.getString("UNIQUE_ID"));
                    jsonArray.put(jsonObject);
                }

            } catch (Exception e) {
            	 e.printStackTrace();
            } finally {
                DBConnection.releaseConnectionToDB(conAdmin, pstmt, rs);
            }
            return jsonArray;
        }	
	
	public JSONArray getVehicleNos(int custId,int systemId,int contractorId) {
		 Connection conAdmin = null;
	        PreparedStatement pstmt = null;
	        ResultSet rs = null;
	        JSONArray jsonArray = new JSONArray();
	        JSONObject jsonObject = new JSONObject();
      try {
      	 
               conAdmin = DBConnection.getConnectionToDB("AMS");
               pstmt = conAdmin.prepareStatement(SandMiningStatements.GET_VEHICLE_NOS);
               pstmt.setInt(1, systemId);
               pstmt.setInt(2, custId);
               pstmt.setInt(3, contractorId);
               rs = pstmt.executeQuery();
               while (rs.next()) {
                   jsonObject = new JSONObject();
                   jsonObject.put("vehicle_no", rs.getString("REGISTRATION_NO"));
                   jsonObject.put("vehicle_id", rs.getString("REGISTRATION_NO"));
                   jsonArray.put(jsonObject);
               }

           } catch (Exception e) {
           	 e.printStackTrace();
           } finally {
               DBConnection.releaseConnectionToDB(conAdmin, pstmt, rs);
           }
           return jsonArray;
       }	
	public double getQuantity(int systemId,String vehicleNO) {
        Connection conAdmin = null;
        PreparedStatement pstmt = null;
        double loadCapacity=0.0;
        ResultSet rs = null;
        try {
            conAdmin = DBConnection.getConnectionToDB("AMS");
            pstmt = conAdmin.prepareStatement(SandMiningStatements.GET_VEHICLE_CAPACITY);
           
           pstmt.setInt(1, systemId);
           pstmt.setString(2, vehicleNO);
          
            rs = pstmt.executeQuery();
            while (rs.next()) {
            	loadCapacity=rs.getDouble("LoadingCapacity") ; 
            }

        } catch (Exception e) {
        	 e.printStackTrace();
        } finally {
            DBConnection.releaseConnectionToDB(conAdmin, pstmt, rs);
        }
        return loadCapacity;
    }
	public JSONArray getDistirctListForConsumer() {
        Connection conAdmin = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        JSONArray jsonArray = new JSONArray();
        JSONObject jsonObject = new JSONObject();
        try {
            conAdmin = DBConnection.getConnectionToDB("ADMINISTRATOR");
            pstmt = conAdmin.prepareStatement(SandMiningStatements.GET_DISTRICT_LIST_FOR_CONSUMERS);
            rs = pstmt.executeQuery();
            while (rs.next()) {
                jsonObject = new JSONObject();
                jsonObject.put("distID", rs.getString("DISTRICT_ID"));
                jsonObject.put("distName", rs.getString("DISTRICT_NAME"));
                jsonArray.put(jsonObject);
            }

        } catch (Exception e) {
        	 e.printStackTrace();
        } finally {
            DBConnection.releaseConnectionToDB(conAdmin, pstmt, rs);
        }
        return jsonArray;
    }	
	
	public String insertSandConsumerDetails(int customerId, String consumerType, int district, int taluka, String village, String mobileNo, String emailId, String address, String identityProofType,
			                                 String identityProofNo, String sandConsumerName, String contractorName, String projectName, String projectDurationFrom, String projectDurationTo,
			                                 String governmentDeptName,String deptContactName,int workdistrict, int worktaluka, String workvillage,String workaddress,String workLocation, String housingApprovalAuthority,
			                                 String housingApprovalPlanNumber, String projectApprovalAuthority, String projectApprovalPlanNumber, double totalBuiltupArea, 
			                                 int noOfBuildings, double estimatedSandRequirement, double approvedSandQunatity, int systemId, int userId, float latitude, float longitude, int fromDistrict, int fromTaluka, String tpNumber, String tpNumberID, String checkpost,String stockyard, String propertyAssessmentNum) {
	    Connection con = null;
	    PreparedStatement pstmt = null;
	    PreparedStatement pstmt1 = null;
	    PreparedStatement pstmt2 = null;
	    PreparedStatement pstmt3 = null;
	    ResultSet rs = null;
	    ResultSet rs1 = null;
	    ResultSet rs2 = null;
	    ResultSet rs3 = null;
	    String message = null;
	    int maxId=0;
	    String applcationNo="1";
	    boolean isAadharOneTimeValid = false;
	    try {
	        con = DBConnection.getConnectionToDB("AMS");
	        pstmt1=con.prepareStatement("select TOP 1 ISNULL ((CONSUMER_APPLICATION_NO),'') as CONSUMER_APPLICATION_NO from dbo.SAND_CONSUMER_ENROLMENT where SYSTEM_ID=? AND CUSTOMER_ID=? ORDER BY CREATED_DATE DESC");
	        pstmt1.setInt(1,systemId);
	        pstmt1.setInt(2, customerId);
	        rs1=pstmt1.executeQuery();
	        if(rs1.next()){
	        	
	        	applcationNo=rs1.getString("CONSUMER_APPLICATION_NO");
	        	String array[]=applcationNo.split("-");
	        	if(array.length>1)
	        	{
	        		applcationNo=array[1];	
	        		maxId=Integer.parseInt(applcationNo)+1;
	        	}
	        	else
	        	{applcationNo="1";
	        	maxId=Integer.parseInt(applcationNo);}
	        	
	        }
	        
	        String unumber = String.valueOf(maxId);
	        unumber = getFormated4DigitNumber(unumber);
	        pstmt2 = con.prepareStatement(SandMiningStatements.FETCH_VALUE_FOR_SENDING_SMS);
	        pstmt2.setInt(1, systemId);
	        rs2=pstmt2.executeQuery();
	        String value=null;
	        if(rs2.next()){
	        	value=rs2.getString("value");
	        }
	        else{
	        	value="APPNO";
	        }
	        value=value+"-"+unumber;
	        
	        pstmt2 = con.prepareStatement("select value from General_Settings where name='AADHAR_VALIDITY' and System_Id=? ");
	        pstmt2.setInt(1, systemId);
			rs2 = pstmt2.executeQuery();
			if (rs2.next()) {
				String AadharOneTimeValid = rs2.getString("value");
				if (AadharOneTimeValid.equals("Y")) {
					isAadharOneTimeValid = true;
				}
			}
	        
	        if(identityProofType.equalsIgnoreCase("AADHAR")){
	        	
	        	if(!validateVerhoeff(identityProofNo))
	        		return "AADHAR Number Invalid";
	        	if(isAadharOneTimeValid){
	        		pstmt = con.prepareStatement(SandMiningStatements.CHECK_FOR_ADHAR_NUM.replace(" and BALANCE_SAND_QUANTITY!=0", ""));
	        	}else{
	        		pstmt = con.prepareStatement(SandMiningStatements.CHECK_FOR_ADHAR_NUM);
	        	}
		        pstmt.setString(1, identityProofNo);
		        rs3 = pstmt.executeQuery();
		        if(rs3.next()){
		        	return "AADHAR CARD ALREADY EXISTED FOR "+rs3.getString("CONSUMER_APPLICATION_NO")+",";
		        }
		        
	        }
	        
	        Integer otp = (int)((Math.random() * 900000000)+100000000);
	        String otp2 = otp.toString().substring(0,6);
	        
	        pstmt = con.prepareStatement(SandMiningStatements.INSERT_CONSUMER_INFORMATION);
	        pstmt.setInt(1, customerId);
	        pstmt.setString(2, consumerType);
	        pstmt.setInt(3, district);
	        pstmt.setInt(4, taluka);
	        pstmt.setString(5, village);
	        pstmt.setString(6, address);
	        pstmt.setString(7, mobileNo);
	        pstmt.setString(8, emailId);
	        pstmt.setString(9, identityProofType);
	        pstmt.setString(10, identityProofNo);
	        pstmt.setString(11, sandConsumerName);
	        pstmt.setString(12, contractorName);
	        pstmt.setString(13, projectName);
	        pstmt.setString(14, projectDurationFrom);
	        pstmt.setString(15, projectDurationTo);
	        pstmt.setString(16, governmentDeptName);
	        pstmt.setString(17, deptContactName);
	        pstmt.setInt(18, workdistrict);
	        pstmt.setInt(19, worktaluka);
	        pstmt.setString(20, workvillage);
	        pstmt.setString(21, workaddress);
	        pstmt.setString(22, workLocation);
	        pstmt.setString(23, housingApprovalAuthority);
	        pstmt.setString(24, housingApprovalPlanNumber);
	        pstmt.setString(25, projectApprovalAuthority);
	        pstmt.setString(26, projectApprovalPlanNumber);
	        pstmt.setDouble(27, totalBuiltupArea);
	        pstmt.setInt(28, noOfBuildings);
	        pstmt.setDouble(29, estimatedSandRequirement);
	        pstmt.setDouble(30, approvedSandQunatity);
	        pstmt.setInt(31, systemId);
	        pstmt.setInt(32, userId);
	        pstmt.setString(33, value);
	        pstmt.setFloat(34, latitude);
	        pstmt.setFloat(35, longitude);
	        pstmt.setDouble(36, approvedSandQunatity);
	        pstmt.setInt(37, fromDistrict);
	        pstmt.setInt(38, fromTaluka);
	        pstmt.setString(39, tpNumber);
	        pstmt.setString(40, "pending");
	        pstmt.setInt(41, userId);
	        pstmt.setString(42, tpNumberID);
	        pstmt.setString(43, checkpost);
	        pstmt.setString(44,stockyard);
	        pstmt.setString(45, propertyAssessmentNum);
	        pstmt.setString(46, otp2);
	        
	        int inserted = pstmt.executeUpdate();
	        if (inserted > 0) {
	        	message=sendOTPMessage(mobileNo,customerId,systemId,value,otp2,con );
	        }
	        else{
	        	message="Error While Saving Records,";
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	        DBConnection.releaseConnectionToDB(con, pstmt, rs);
	        DBConnection.releaseConnectionToDB(null, pstmt1, rs1);
	        DBConnection.releaseConnectionToDB(null, pstmt2, rs2);
	        DBConnection.releaseConnectionToDB(null, pstmt3, rs3);
	    }
	    return message;
	}
	
	//getMDPCheckingReport
	public ArrayList < Object > getMDPCheckingReport(int systemId, int customerId,String language,int userId){       
		JSONArray JsonArray = new JSONArray();
	    JSONObject JsonObject = null;
	    Connection con = null;
	    PreparedStatement pstmt1 = null;
	    ResultSet rs1 = null;
	    int count = 0;
	    ArrayList < Object > finlist = new ArrayList < Object > ();
	    ArrayList<Object> headersList = new ArrayList<Object>();
	    ArrayList<Object> reportsList = new ArrayList<Object>();
		ReportHelper finalreporthelper = new ReportHelper();
		HashMap<String, ArrayList<String>> hashMap=new HashMap<String, ArrayList<String>>();
	    try {
	    	
	    	headersList.add(cf.getLabelFromDB("SLNO", language));
		    headersList.add(cf.getLabelFromDB("Registration_No", language));
		    headersList.add(cf.getLabelFromDB("Customer_Name", language));
		    headersList.add(cf.getLabelFromDB("Group_Name", language));
		    headersList.add(cf.getLabelFromDB("Location", language));
		    headersList.add(cf.getLabelFromDB("Latest_Date_and_Time", language));
		    headersList.add(cf.getLabelFromDB("Latest_MDP_Issued_Date_and_Time", language));
		    
	        con = DBConnection.getConnectionToDB("AMS");
	    
	        pstmt1=con.prepareStatement(SandMiningStatements.GET_MDP_CHECKING_REPORT);
	        pstmt1.setInt(1, systemId);
			pstmt1.setInt(2, customerId);
			pstmt1.setInt(3, systemId);
			pstmt1.setInt(4, customerId);
			pstmt1.setInt(5, systemId);
			pstmt1.setInt(6, customerId);
			pstmt1.setInt(7, userId);
			pstmt1.setInt(8, systemId);
			pstmt1.setInt(9, customerId);
			pstmt1.setInt(10, systemId);
			pstmt1.setInt(11, customerId);
			pstmt1.setInt(12, systemId);
			pstmt1.setInt(13, customerId);
			pstmt1.setInt(14, userId);
						
	        	    	rs1 = pstmt1.executeQuery();
	        			      
	        while (rs1.next()) {
				ArrayList<String> arrayList=new ArrayList<String>();
				arrayList.add(rs1.getString("Vehicle_No"));
				arrayList.add(rs1.getString("CUSTOMER_NAME"));
				arrayList.add(rs1.getString("Group_Name"));
				arrayList.add(rs1.getString("LOCATION"));
				arrayList.add(ddMMyyyyHHmmss
						.format(rs1.getTimestamp("GPS_DATETIME")));
				arrayList.add(ddMMyyyyHHmmss
						.format(rs1.getTimestamp("Printed_Date")));
				hashMap.put(rs1.getString("Vehicle_No"), arrayList);
	        	
	         }
	        
	        pstmt1=con.prepareStatement(SandMiningStatements.DISTINCT_VEH_NO);
	        pstmt1.setInt(1, systemId);
			pstmt1.setInt(2, customerId);
			pstmt1.setInt(3, systemId);
			pstmt1.setInt(4, customerId);
			pstmt1.setInt(5, systemId);
			pstmt1.setInt(6, customerId);
			pstmt1.setInt(7, userId);
			pstmt1.setInt(8, systemId);
			pstmt1.setInt(9, customerId);
			pstmt1.setInt(10, systemId);
			pstmt1.setInt(11, customerId);
			pstmt1.setInt(12, systemId);
			pstmt1.setInt(13, customerId);
			pstmt1.setInt(14, userId);
			rs1 = pstmt1.executeQuery();
			ArrayList<String> list=new ArrayList<String>();
			while (rs1.next())
			{
			list=hashMap.get(rs1.getString("Vehicle_No"))	;
			count++;
        	JsonObject = new JSONObject();
        	ArrayList<Object> informationList = new ArrayList<Object>();
        	ReportHelper reporthelper = new ReportHelper();
     	
        	JsonObject.put("slnoIndex",count);
            JsonObject.put("PermitNoDataIndex",list.get(0));
            JsonObject.put("CustomerNameDataIndex",list.get(1));
            JsonObject.put("GroupNmaeDataIndex",list.get(2));
            JsonObject.put("LocationDataIndex", list.get(3));
            JsonObject.put("LatestDateDataIndex",list.get(4));
			
            JsonObject.put("MDPIssuedDataIndex", list.get(5));
            
            informationList.add(count);
            informationList.add(list.get(0));
            informationList.add(list.get(1));
            informationList.add(list.get(2));
            informationList.add(list.get(3));
            informationList.add(list.get(4));
            informationList.add(list.get(5));
         
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
	        DBConnection.releaseConnectionToDB(con, pstmt1, rs1);
	    }
	    return finlist;
	}
	
	public ArrayList < Object > getConsumerReport(int systemId, int customerId,String startdate,String enddate,int offset) {
	    JSONArray JsonArray = new JSONArray();
	    JSONObject JsonObject = null;
	    Connection con = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
	    String startDate=null;
	    String endDate=null;
	    ArrayList < Object > finlist = new ArrayList < Object > ();
	    ArrayList headersList = new ArrayList();
	    ArrayList reportsList = new ArrayList();
		ReportHelper finalreporthelper = new ReportHelper();
		
	    try {
	        int count = 0;
	        headersList.add("SLNO");
	        headersList.add("CONSUMER TYPE");
	        headersList.add("CONSUMER APPLICATION NO");
	        headersList.add("DISTRICT");
	        headersList.add("TALUKA");
	        headersList.add("VILLAGE");
	        headersList.add("MOBILE NUMBER");
	        headersList.add("EMAIL ID");
	        headersList.add("ADDRESS");
	        headersList.add("SAND CONSUMER NAME");
	        headersList.add("CONTRACTOR NAME");
	        headersList.add("PROJECT NAME");
	        headersList.add("START DATE");
	        headersList.add("END DATE");
	        headersList.add("GOVERNMENT DEPT NAME");
	        headersList.add("DEPT CONTACT NAME");
	        headersList.add("WORK LOCATION");
	        headersList.add("HOUSING APPROVAL AUTHORITY");
	        headersList.add("HOUSING APPROVAL PLAN NUMBER");
	        headersList.add("PROJECT APPROVAL AUTHORITY");
	        headersList.add("PROJECT APPROVAL PLAN NUMBER");
	        headersList.add("TOTAL BUILTUP AREA");
	        headersList.add("NO OF BUILDINGS");
	        headersList.add("ESTIMATED SAND REQUIREMENT");
	        headersList.add("APPROVED SAND QUNATITY");
	        headersList.add("BALANCE SAND QUANTITY");
	        headersList.add("CREATED DATE");
	        headersList.add("STOCKYARD NAME");
	        headersList.add("STATUS");
	        headersList.add("APPLICATION STATUS");
	        headersList.add("ID PROOF TYPE");
	        headersList.add("ID PROOF NUMBER");
		       
	         con = DBConnection.getConnectionToDB("AMS");
	        pstmt = con.prepareStatement(SandMiningStatements.GET_CONSUMER_REPORT);
	        pstmt.setInt(1, systemId);
	        pstmt.setInt(2, customerId);
	        pstmt.setInt(3, offset);
	        pstmt.setString(4, startdate);
	        pstmt.setInt(5, offset); 
	        pstmt.setString(6, enddate);
	        rs = pstmt.executeQuery();
	        while (rs.next()) {
	            JsonObject = new JSONObject();
	            ArrayList informationList = new ArrayList();
				ReportHelper reporthelper = new ReportHelper();

	            count++;
	            if(rs.getString("PROJECT_START_DATE").contains("1900"))
	            {
	            startDate="";	
	            }
	            else startDate=sdfyyyymmdd.format(rs.getTimestamp("PROJECT_START_DATE"));
	            if(rs.getString("PROJECT_END_DATE").contains("1900"))
	            {
	            	endDate="";	
	            }
	            else endDate=sdfyyyymmdd.format(rs.getTimestamp("PROJECT_END_DATE"));
	            	
	            JsonObject.put("slnoIndex", count);
	            JsonObject.put("consumerTypeDataIndex",rs.getString("CONSUMER_TYPE"));
	            JsonObject.put("appNoDataIndex",rs.getString("CONSUMER_APPLICATION_NO"));
	            JsonObject.put("district1DataIndex", rs.getString("DISTRICTID"));
	            JsonObject.put("taluka1DataIndex", rs.getString("TALUKID"));
	            JsonObject.put("villageDataIndex", rs.getString("VILLAGE"));
	            JsonObject.put("mobileNoDataIndex", rs.getString("MOBILE_NUMBER"));
	            JsonObject.put("emailIdDataIndex", rs.getString("EMAIL_ID"));
	            JsonObject.put("addressDataIndex", rs.getString("ADDRESS"));
	            JsonObject.put("sandConsumerNameDataIndex", rs.getString("SAND_CONSUMER_NAME"));
	            JsonObject.put("contractorNameDataIndex", rs.getString("CONTRACTOR_NAME"));
	            JsonObject.put("projectNameDataIndex", rs.getString("PROJECT_NAME"));
	            JsonObject.put("projectDurationFromDataIndex", startDate);
	            JsonObject.put("projectDurationToDataIndex", endDate);
	            JsonObject.put("governmentDeptNameDataIndex", rs.getString("GOVERNMENT_DEPT_NAME"));
	            JsonObject.put("deptContactNameDataIndex", rs.getString("DEPT_CONTACT_NAME"));
	            JsonObject.put("workLocationDataIndex", rs.getString("WORK_LOCATION"));
	            JsonObject.put("housingApprovalAuthorityDataIndex", rs.getString("HOUSING_APPROVAL_AUTHORITY"));
	            JsonObject.put("housingApprovalPlanNumberDataIndex", rs.getString("HOUSING_APPROVAL_PLAN_NUMBER"));
	            JsonObject.put("projectApprovalAuthorityDataIndex", rs.getString("PROJECT_APPROVAL_AUTHORITY"));
	            JsonObject.put("projectApprovalPlanNumberDataIndex", rs.getString("PROJECT_APPROVAL_PLAN_NUMBER"));
	            JsonObject.put("totalBuiltupAreaDataIndex", rs.getString("TOTAL_BUILTUP_AREA"));
	            JsonObject.put("noOfBuildingsDataIndex", rs.getString("NO_OF_BUILDINGS"));
	            JsonObject.put("estimatedSandRequirementDataIndex", rs.getString("ESTIMATED_SAND_REQUIREMENT"));
	            JsonObject.put("approvedSandQunatityDataIndex", rs.getString("APPROVED_SAND_QUNATITY"));
	            JsonObject.put("remainingQunatityDataIndex", rs.getString("BALANCE_SAND_QUANTITY"));
	            JsonObject.put("CreatedDateDataIndex", ddMMyyyyHHmmss.format(rs.getTimestamp("CREATED_DATE")));
	            JsonObject.put("stockyardIndex", rs.getString("ADHAR_NO"));
	            JsonObject.put("statusIndex", rs.getString("STATUS"));
	            JsonObject.put("appstatusIndex", rs.getString("CONSUMER_STATUS"));
	            JsonObject.put("idProofTypeIndex", rs.getString("IDENTITY_PROOF_TYPE"));
	            JsonObject.put("idProofNoIndex", rs.getString("IDENTITY_PROOF_NO"));
	            
	            informationList.add(count);
	            informationList.add(rs.getString("CONSUMER_TYPE"));
	            informationList.add(rs.getString("CONSUMER_APPLICATION_NO"));
	            informationList.add(rs.getString("DISTRICTID"));
	            informationList.add(rs.getString("TALUKID"));
	            informationList.add(rs.getString("VILLAGE"));
	            informationList.add(rs.getString("MOBILE_NUMBER"));
	            informationList.add(rs.getString("EMAIL_ID"));
	            informationList.add(rs.getString("ADDRESS"));
	            informationList.add(rs.getString("SAND_CONSUMER_NAME"));
	            informationList.add(rs.getString("CONTRACTOR_NAME"));
	            informationList.add(rs.getString("PROJECT_NAME"));
	            informationList.add(startDate);
	            informationList.add(endDate);
	            informationList.add(rs.getString("GOVERNMENT_DEPT_NAME"));
	            informationList.add(rs.getString("DEPT_CONTACT_NAME"));
	            informationList.add(rs.getString("WORK_LOCATION"));
	            informationList.add(rs.getString("HOUSING_APPROVAL_AUTHORITY"));
	            informationList.add(rs.getString("HOUSING_APPROVAL_PLAN_NUMBER"));
	            informationList.add(rs.getString("PROJECT_APPROVAL_AUTHORITY"));
	            informationList.add(rs.getString("PROJECT_APPROVAL_PLAN_NUMBER"));
	            informationList.add(rs.getString("TOTAL_BUILTUP_AREA"));
	            informationList.add(rs.getString("NO_OF_BUILDINGS"));
	            informationList.add(rs.getString("ESTIMATED_SAND_REQUIREMENT"));
	            informationList.add(rs.getString("APPROVED_SAND_QUNATITY"));
	            informationList.add(rs.getString("BALANCE_SAND_QUANTITY"));
	            informationList.add(ddMMyyyyHHmmss.format(rs.getTimestamp("CREATED_DATE")));
	            informationList.add(rs.getString("ADHAR_NO"));
	            informationList.add(rs.getString("STATUS"));
	            informationList.add(rs.getString("CONSUMER_STATUS"));
	            informationList.add(rs.getString("IDENTITY_PROOF_TYPE"));
	            informationList.add(rs.getString("IDENTITY_PROOF_NO"));
	            
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
	
//******************************************************* SandMiningSummary Report *******************************
	public ArrayList < Object > getSandMiningSummaryReport(String sdate,String edate,String language){       
		JSONArray JsonArray = new JSONArray();
	    JSONObject JsonObject = null;
	    Connection con = null;
	    PreparedStatement pstmt1 = null;
	    ResultSet rs1 = null;
	    int count = 0;
	    ArrayList < Object > finlist = new ArrayList < Object > ();
	    ArrayList<Object> headersList = new ArrayList<Object>();
	    ArrayList<Object> reportsList = new ArrayList<Object>();
		ReportHelper finalreporthelper = new ReportHelper();
		DecimalFormat fm=new DecimalFormat("0.00");
	    try {
	    	  String ltsps[]=null;
	    	  Properties properties = ApplicationListener.prop;
	    	  String sandMiningLTSPs = properties.getProperty("SandMiningLTSPs").trim();
	    	  if(sandMiningLTSPs !=null && sandMiningLTSPs!=""){
	    		 ltsps=sandMiningLTSPs.split(",");
	    	  }
	    	
	    	headersList.add(cf.getLabelFromDB("SLNO", language));
		    headersList.add(cf.getLabelFromDB("District_Name", language));
		    headersList.add(cf.getLabelFromDB("Total_Vehicles", language));
		    headersList.add(cf.getLabelFromDB("No_GPS", language));
		    headersList.add(cf.getLabelFromDB("Communication", language));
		    headersList.add(cf.getLabelFromDB("Non_Communicating", language));
		    headersList.add(cf.getLabelFromDB("Total_MDP", language));
		    headersList.add(cf.getLabelFromDB("Quantity", language));
		    headersList.add(cf.getLabelFromDB("Total_Price", language));
		    
	        con = DBConnection.getConnectionToDB("AMS");
	        for (int i = 0; i < ltsps.length; i++) {
		    	count++;
		    	JsonObject = new JSONObject();
	        	ArrayList<Object> informationList = new ArrayList<Object>();
	        	ReportHelper reporthelper = new ReportHelper();
        	
	        	JsonObject.put("slnoIndex",count);
		    	informationList.add(count);
		    	
			    pstmt1=con.prepareStatement(SandMiningStatements.GET_LTSP_DISTRICT);
			       			pstmt1.setString(1, ltsps[i]);
			       			rs1=pstmt1.executeQuery();
		       				while(rs1.next()){
			       				 JsonObject.put("DistrictNameDataIndex", rs1.getString("DISTRICT_NAME"));
			       				 informationList.add(rs1.getString("DISTRICT_NAME"));
		       				}
	    	
		        pstmt1=con.prepareStatement(SandMiningStatements.GET_SANDMINING_SUMMARY_REPORT);	
							pstmt1.setString(1, ltsps[i]);
							pstmt1.setString(2, ltsps[i]);
							pstmt1.setString(3, ltsps[i]);
							pstmt1.setString(4, ltsps[i]);
		        	    	
							rs1 = pstmt1.executeQuery();
		        	    	while(rs1.next()){
			        			switch(rs1.getInt("flag")){
			        			case 1:JsonObject.put("TotalVehiclesDataIndex",rs1.getString("COUNT"));
			        				   informationList.add(rs1.getString("COUNT"));
			        				   break;
			        				   
			        			case 2:JsonObject.put("NoGPSDataIndex",rs1.getString("COUNT"));
			        				   informationList.add(rs1.getString("COUNT"));
			        				   break;
			        				
			        			case 3:JsonObject.put("CommunicationDataIndex", rs1.getString("COUNT"));
			        				   informationList.add(rs1.getString("COUNT"));
			        				   break;
			        				   
			        			case 4:JsonObject.put("NonCommunicatingDataIndex",rs1.getString("COUNT"));
			        			 	   informationList.add(rs1.getString("COUNT"));
			        				   break;
			        			}
		        	    	}
	        			
		       pstmt1=con.prepareStatement(SandMiningStatements.GET_TOTAL_MDP_ISSUED_REPORT);
		       				pstmt1.setString(1, sdate.replaceAll("T", " "));
		       				pstmt1.setString(2, edate.replaceAll("T", " "));
		       				pstmt1.setString(3, ltsps[i]);
		       				pstmt1.setString(4, sdate.replaceAll("T", " "));
		       				pstmt1.setString(5, edate.replaceAll("T", " "));
		       				pstmt1.setString(6, ltsps[i]);
		       				rs1=pstmt1.executeQuery();
		       				while(rs1.next()){
		       					JsonObject.put("TotalMDPDataIndex",rs1.getString("COUNT"));
		       					informationList.add(rs1.getString("COUNT"));
		       				}
	        	    	
		      pstmt1=con.prepareStatement(SandMiningStatements.GET_TOTAL_QUANTITY_REPORT);
						    pstmt1.setString(1, ltsps[i]);
							pstmt1.setString(2, sdate.replaceAll("T", " "));
		       				pstmt1.setString(3, edate.replaceAll("T", " "));
						    pstmt1.setString(4, ltsps[i]);
							pstmt1.setString(5, sdate.replaceAll("T", " "));
		       				pstmt1.setString(6, edate.replaceAll("T", " "));
		       				rs1=pstmt1.executeQuery();
		     				while(rs1.next()){
			       				 JsonObject.put("QuantityDataIndex",rs1.getString("COUNT"));
			     				 informationList.add(rs1.getString("COUNT"));
		       				}
	       				
		       pstmt1=con.prepareStatement(SandMiningStatements.GET_TOTAL_FEES_REPORT);
					       pstmt1.setString(1, ltsps[i]);
					       pstmt1.setString(2, sdate.replaceAll("T", " "));
					       pstmt1.setString(3, edate.replaceAll("T", " "));
					       pstmt1.setString(4, ltsps[i]);
					       pstmt1.setString(5, sdate.replaceAll("T", " "));
					       pstmt1.setString(6, edate.replaceAll("T", " "));
		      
		       				rs1=pstmt1.executeQuery();
		       				while(rs1.next()){
		       						JsonObject.put("TotalPriceDataIndex",fm.format(rs1.getDouble("COUNT")));
		       						informationList.add(rs1.getString("COUNT"));
		       				}
	      
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
	        DBConnection.releaseConnectionToDB(con, pstmt1, rs1);
	    }
	    return finlist;
	}
	         
//-----------------------------********************Sand Inward Report***********************-----------------------------
	public ArrayList < Object > getSandInwardReport(int systemId, String customerId,String sdate, String edate) {
	    JSONArray JsonArray = new JSONArray();
	    JSONObject JsonObject = null;
	    Connection con = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
	    ArrayList < Object > finlist = new ArrayList < Object > ();
	    ArrayList headersList = new ArrayList();
	    ArrayList reportsList = new ArrayList();
		ReportHelper finalreporthelper = new ReportHelper();
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
		SimpleDateFormat sdf1 = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
	    try {
	        int count = 0;
	        headersList.add("SLNO");
	        headersList.add("CONTRACTOR");
	        headersList.add("SAND BLOCK");
	        headersList.add("STOCKYARD");
	        headersList.add("PERMIT NO");
	        headersList.add("CONTRACTOR NO");
	        headersList.add("PERMIT DATE");
	        headersList.add("VEHICLE NO");
	        headersList.add("QUANTITY");
	        headersList.add("PRINTED DATE");
	        headersList.add("VALID FROM");
	        headersList.add("VALID TO");
	        		       
	        con = DBConnection.getConnectionToDB("AMS");
	        pstmt = con.prepareStatement(SandMiningStatements.GET_SAND_INWARD_REPORT);
	        pstmt.setInt(1, systemId);
	        pstmt.setString(2, customerId);
	        pstmt.setString(3, sdate);
	        pstmt.setString(4, edate);
	        
	        rs = pstmt.executeQuery();
	        while (rs.next()) {
	            JsonObject = new JSONObject();
	            ArrayList informationList = new ArrayList();
				ReportHelper reporthelper = new ReportHelper();

	            count++;
	           	            	
	            JsonObject.put("slnoIndex", count);
	            JsonObject.put("ContractorNameDataIndex",rs.getString("CONTRACTOR_ID"));
	            JsonObject.put("SandBlockFromDataIndex",rs.getString("SAND_BLOCK_ID"));
	            JsonObject.put("StockyardToDataIndex", rs.getString("STOCKYARD_ID"));
	            JsonObject.put("PermitNoDataIndex", rs.getString("PERMIT_NO"));
	            JsonObject.put("ContractNoDataIndex", rs.getString("CONTRACT_NO"));
	            JsonObject.put("PermitDataIndex", sdf.format(rs.getTimestamp("PERMIT_DATE")));
	            JsonObject.put("VehicleNoDataIndex", rs.getString("VEHICLE_NO"));
	            JsonObject.put("QuantityDataIndex", rs.getString("QUANTITY"));
	            JsonObject.put("PrintedDataIndex", sdf.format(rs.getTimestamp("PRINTED_DATE")));
	            JsonObject.put("ValidFromDataIndex", sdf.format(rs.getTimestamp("VALID_FROM")));
	            JsonObject.put("ValidToDataIndex", sdf.format(rs.getTimestamp("VALID_TO")));
	            
	            informationList.add(count);
	            informationList.add(rs.getString("CONTRACTOR_ID"));
	            informationList.add(rs.getString("SAND_BLOCK_ID"));
	            informationList.add(rs.getString("STOCKYARD_ID"));
	            informationList.add(rs.getString("PERMIT_NO"));
	            informationList.add(rs.getString("CONTRACT_NO"));
	            informationList.add( sdf1.format(rs.getTimestamp("PERMIT_DATE")));
	            informationList.add(rs.getString("VEHICLE_NO"));
	            informationList.add(rs.getString("QUANTITY"));
	            informationList.add( sdf1.format(rs.getTimestamp("PRINTED_DATE")));
	            informationList.add(sdf1.format(rs.getTimestamp("VALID_FROM")));
	            informationList.add(sdf1.format(rs.getTimestamp("VALID_TO")));
	         
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
	
	public ArrayList < Object > getSandBoatReport(int systemId, String customerId,String sdate, String edate) {
	    JSONArray JsonArray = new JSONArray();
	    JSONObject JsonObject = null;
	    Connection con = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
	    ArrayList < Object > finlist = new ArrayList < Object > ();
	    ArrayList headersList = new ArrayList();
	    ArrayList reportsList = new ArrayList();
		ReportHelper finalreporthelper = new ReportHelper();
		try {
	        int count = 0;
	        headersList.add("SLNO");
	        headersList.add("BOAT NO");
	        headersList.add("ALERT DATETIME");
	        headersList.add("TP OWNER");
	        headersList.add("PARKINGHUB");
	        headersList.add("LOADINGHUB");
	        headersList.add("DISTANCE FROM PARKINGHUB");
	        headersList.add("DISTANCE FROM LOADINGHUB");
	        headersList.add("STOPPAGE DURATION");
	        headersList.add("MAPVIEW");
	        		       
	        con = DBConnection.getConnectionToDB("AMS");
	        pstmt = con.prepareStatement(SandMiningStatements.GET_SAND_BOAT_REPORT);
	        pstmt.setInt(1, systemId);
	        pstmt.setString(2, customerId);
	        pstmt.setString(3, sdate);
	        pstmt.setString(4, edate);
	        
	        rs = pstmt.executeQuery();
	        while (rs.next()) {
	            JsonObject = new JSONObject();
	            ArrayList informationList = new ArrayList();
				ReportHelper reporthelper = new ReportHelper();
	            count++;
	            JsonObject.put("slnoIndex", count);
	            JsonObject.put("BoatNoDataIndex",rs.getString("BOAT_NO"));
	            JsonObject.put("AlertDateDataIndex",rs.getString("STOPPAGE_ALERT_TIME"));
	            JsonObject.put("TpOwnerDataIndex",rs.getString("TP_OWNER"));
	            JsonObject.put("ParkinghubDataIndex",rs.getString("PARKING_HUB"));
	            JsonObject.put("LoadinghubDataIndex",rs.getString("LOADING_HUB"));
	            JsonObject.put("DistanceFromParkingDataIndex", df.format(rs.getFloat("PARKING_HUB_DISTANCE")));
	            JsonObject.put("DistanceFromLoadingDataIndex", df.format(rs.getFloat("LOADING_HUB_DISTANCE")));
	            JsonObject.put("StoppageDataIndex", rs.getString("STOPPAGE_DURATION"));
	            JsonObject.put("IdDataIndex", rs.getString("ID"));
	            JsonObject.put("MapDataIndex","<p><a href=\"#\"  onclick=displayMap("+"'"+rs.getString("BOAT_NO")+"'"+","+rs.getString("ID")+")>"+"MAP VIEW"+"</a></p>");
	            
	            informationList.add(count);
	            informationList.add(rs.getString("BOAT_NO"));
	            informationList.add(rs.getString("STOPPAGE_ALERT_TIME"));
	            informationList.add(rs.getString("TP_OWNER"));
	            informationList.add(rs.getString("PARKING_HUB"));
	            informationList.add(rs.getString("LOADING_HUB"));
	            informationList.add(rs.getFloat("PARKING_HUB_DISTANCE"));
	            informationList.add(rs.getFloat("LOADING_HUB_DISTANCE"));
	            informationList.add(rs.getString("STOPPAGE_DURATION"));
	            informationList.add("");
	         
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
	
	public ArrayList< Object > getInfo(String vehicleNo,String ID)
	{
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		ArrayList arrayList=new ArrayList();
		try
		{
			con= DBConnection.getConnectionToDB("AMS");
			pstmt=con.prepareStatement(SandMiningStatements.GET_SAND_BOAT_MAP);
			pstmt.setString(1, vehicleNo);
			pstmt.setString(2, ID);
			rs = pstmt.executeQuery();
			while(rs.next())
			{
				arrayList.add(rs.getString("LONGITUDE"));
				arrayList.add(rs.getString("LATITUDE"));
				arrayList.add(rs.getString("LOCATION"));
				arrayList.add(sdfyyyymmddhhmmss.format(rs.getTimestamp("GPS_DATETIME")));
				arrayList.add(rs.getString("SYSTEM_ID"));
				arrayList.add(rs.getString("PARKING_HUB"));
				arrayList.add(rs.getString("parkinglat"));
				arrayList.add(rs.getString("parkinglong"));
				arrayList.add(rs.getString("PARKING_HUBID"));
				arrayList.add(rs.getString("LOADING_HUB"));
				arrayList.add(rs.getString("loadinglat"));
				arrayList.add(rs.getString("loadinglong"));
				arrayList.add(rs.getString("LOADING_HUBID"));
				arrayList.add(rs.getString("STOPPAGE_DURATION"));
				arrayList.add(rs.getString("PARKING_HUB_DISTANCE"));
				arrayList.add(rs.getString("LOADING_HUB_DISTANCE"));
			}
		}
		catch (Exception e) 
		{
			e.printStackTrace();
		}
		finally
		{
			DBConnection.releaseConnectionToDB(con,pstmt,rs);
		}
		
		return arrayList;
	}
//***************************************Vehicle without GPS Report*********************
	public ArrayList < Object > getNoGPSVehicleReport(int systemId, int customerId, int userID ,int offset,String sdate, String edate) {
	    JSONArray JsonArray = new JSONArray();
	    JSONObject JsonObject = null;
	    Connection con = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
	    ArrayList < Object > finlist = new ArrayList < Object > ();
	    ArrayList headersList = new ArrayList();
	    ArrayList reportsList = new ArrayList();
		ReportHelper finalreporthelper = new ReportHelper();
		String customerName=cf.getCustomerName(String.valueOf(customerId),systemId);
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
		SimpleDateFormat sdf1 = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
	    try {
	        int count = 0;
	        headersList.add("SLNOO");
	        headersList.add("VEHICLE NO");
	        headersList.add("eWayBill Number");
	        headersList.add("eWayBill Date");
	        headersList.add("From Place");
	        headersList.add("To Place");
	        headersList.add("Valid From");
	        headersList.add("Valid To");
	        headersList.add("Driver Name");
	        headersList.add("Customer Name");
	        headersList.add("Quantity");
	        headersList.add("Royalty");
	        
	        con = DBConnection.getConnectionToDB("AMS");
	        pstmt = con.prepareStatement(SandMiningStatements.GET_VEHICLES_WITHOUT_GPS_REPORT);
	        pstmt.setString(1, sdate);
	        pstmt.setString(2, edate);
	        pstmt.setInt(3, systemId);
	        pstmt.setString(4, customerName);
	        pstmt.setString(5, sdate);
	        pstmt.setString(6, edate);
	        pstmt.setInt(7, systemId);
	        pstmt.setString(8, customerName);
	       

	        rs = pstmt.executeQuery();
	        while (rs.next()) {
	            JsonObject = new JSONObject();
	            ArrayList informationList = new ArrayList();
				ReportHelper reporthelper = new ReportHelper();

	            count++;
	           	            	
	            JsonObject.put("slnoIndex", count);
	            JsonObject.put("assetNumberDataIndex",rs.getString("Vehicle_No"));
	            JsonObject.put("DriverNameIndex",rs.getString("Driver_Name"));
	            JsonObject.put("TSNumberIndex",rs.getString("Trip_Sheet_No"));
	            JsonObject.put("DateTSIndex", ddMMyyyyHHmmss.format(rs.getTimestamp("Date_TS")));
	            JsonObject.put("FromPlaceIndex", rs.getString("From_Place"));
	            JsonObject.put("ToPlaceIndex", rs.getString("To_Palce"));
	            JsonObject.put("CustomerNameIndex", rs.getString("CUSTOMER_NAME"));
	            JsonObject.put("QuantityIndex", rs.getString("Quantity"));
	            JsonObject.put("ValidFromIndex", ddMMyyyyHHmmss.format(rs.getTimestamp("From_Date")));
	            JsonObject.put("ValidToIndex", ddMMyyyyHHmmss.format(rs.getTimestamp("To_Date")));
	            JsonObject.put("RoyaltyIndex", rs.getString("Royalty"));
	           
	            informationList.add(count);
	            informationList.add(rs.getString("Vehicle_No"));
	            informationList.add(rs.getString("Trip_Sheet_No"));
	            informationList.add( sdf1.format(rs.getTimestamp("Date_TS")));
	            informationList.add(rs.getString("From_Place"));
	            informationList.add(rs.getString("To_Palce"));
	            informationList.add(rs.getString("From_Date"));
	            informationList.add(rs.getString("To_Date"));
	            informationList.add(rs.getString("Driver_Name"));
	            informationList.add(rs.getString("CUSTOMER_NAME"));
	            informationList.add(rs.getString("Quantity"));
	            informationList.add(rs.getString("Royalty"));
	           
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
	
	public JSONArray getSerpDashboardElements(int systemId, int customerId, int userId,int offset, int isLtsp,String zone) {
		
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		Connection connection=null;
		JSONArray jsonArray=new JSONArray();
		JSONObject jsonObject=new JSONObject();
		try
		{
		 connection = DBConnection.getConnectionToDB("AMS");
		 //ewaybill data
		 pstmt=connection.prepareStatement("select count(*) as COUNT,flag=1 from AMS.dbo.Sand_Mining_Trip_Sheet where Date_TS between dateadd(mi,-330,DATEADD(day, DATEDIFF(day, 0, GETDATE()), 0)) and getDate() and System_Id=229 "+
         "union all "+
         "select count(*) as COUNT,flag=2  from AMS.dbo.Sand_Mining_Trip_Sheet where Date_TS between dateadd(mi,-330,DATEADD(day, DATEDIFF(day, 0, GETDATE()), 0)) and getDate() and System_Id=229 and Remarks!='NOT AVAILABLE' "+
         "union all "+
         "select count(*) as COUNT,flag=3  from AMS.dbo.Sand_Mining_Trip_Sheet where Date_TS between dateadd(mi,-330,DATEADD(day, DATEDIFF(day, 0, GETDATE()), 0)) and getDate() and System_Id=229 and Remarks='NOT AVAILABLE' order by flag ");
		 rs=pstmt.executeQuery();
		 
		 while(rs.next())
		 {
			 switch(rs.getInt("flag"))
			 {
			 case 1 : jsonObject.put("totalEwaybills", String.format("%05d",rs.getInt("COUNT")));
			          break;
			 case 2 : jsonObject.put("registerdEwaybills", String.format("%05d",rs.getInt("COUNT")));
	                  break;
			 case 3 : jsonObject.put("NonregisterdEwaybills", String.format("%05d",rs.getInt("COUNT")));
	                  break;
			 }
		 }
		 pstmt.close();
		 rs.close();
		 
		//waiting and Loading Time
		 pstmt=connection.prepareStatement("select sum(WAITING_TIME)/COUNT(WAITING_TIME) as AVG,flag=1 FROM AMS.dbo.WAITING_LOADING_TIME WHERE WAITING_TIME < 8 AND SYSTEM_ID=229 and INSERTED_TIME between dateadd(mi,-330,DATEADD(day, DATEDIFF(day, 0, GETDATE()), 0)) and getDate() " +
		 		" UNION ALL select sum(LOADING_TIME)/COUNT(LOADING_TIME) AS AVG,flag=2 FROM AMS.dbo.WAITING_LOADING_TIME WHERE LOADING_TIME < 8 AND SYSTEM_ID=229 and INSERTED_TIME between dateadd(mi,-330,DATEADD(day, DATEDIFF(day, 0, GETDATE()), 0)) and getDate() order by flag ");
		 rs=pstmt.executeQuery();
		 while(rs.next())
		 {      
			 switch(rs.getInt("flag"))
		 
		  {
			     case 1 : jsonObject.put("avgWaitingltsp", cf.convertMinutesToHHMMFormat((int)(cf.convertHHMMToMinutes(hhMMformat(rs.getDouble("AVG"))))));
				          break;
				 case 2 : jsonObject.put("avgLoadingTime", cf.convertMinutesToHHMMFormat((int)(cf.convertHHMMToMinutes(hhMMformat(rs.getDouble("AVG"))))));
		                  break;
		  }
		}
		 pstmt.close();
		 rs.close();
		 //unauthorized reach entry
		 pstmt=connection.prepareStatement("Select count(*) as COUNT from AMS.dbo.NO_OF_EWAYBILLS_AND_VISITS where REACH_NAME IS NOT NULL AND (WAY_BILL_NO IS NULL OR WAY_BILL_NO='') AND SYSTEM_ID=229 "+
                                           "AND REACH_ENTRY_DATE between  dateadd(mi,-330,DATEADD(day, DATEDIFF(day, 0, GETDATE()), 0)) and getDate() AND DETENTION > 0.30") ;
		 rs=pstmt.executeQuery();
		 if(rs.next())
		 {
			 jsonObject.put("unauthorisedCount", rs.getInt("COUNT"));
		 }
		 
		 pstmt.close();
		 rs.close();
		 
		//top 1 unauthorized reach entry
		 pstmt=connection.prepareStatement("Select top 1 count(a.CUSTOMER_ID) AS UNAUTHORISED,NAME from AMS.dbo.NO_OF_EWAYBILLS_AND_VISITS a "+
             "inner join ADMINISTRATOR.dbo.CUSTOMER_MASTER b on a.CUSTOMER_ID=b.CUSTOMER_ID where REACH_NAME IS NOT NULL AND (WAY_BILL_NO IS NULL OR WAY_BILL_NO='') AND a.SYSTEM_ID=229  "+
              "AND REACH_ENTRY_DATE between dateadd(mi,-330,DATEADD(day, DATEDIFF(day, 0, GETDATE()), 0)) and getutcDate() AND DETENTION > 0.20 GROUP BY a.CUSTOMER_ID,NAME order by UNAUTHORISED desc ") ;
         rs=pstmt.executeQuery();
         if(rs.next())
         {
         jsonObject.put("topCount", rs.getInt("UNAUTHORISED"));
         jsonObject.put("topDistrict", rs.getString("NAME"));
         }
         
         pstmt.close();
         rs.close();
		 
		 pstmt=connection.prepareStatement(" select count(VEHICLE_NO) as COUNT,  flag=1,ORDER_STATUS='Completed' from AMS.dbo.SAND_ORDER_COMPLETION where ORDER_STATUS='Completed' and VALID_FROM_DATE between dateadd(mi,0,DATEADD(day, DATEDIFF(day, 0, GETDATE()), 0)) and getDate() "+
		 "union all "+ 
		 "select count(VEHICLE_NO) as COUNT, flag=2,ORDER_STATUS='Not Completed' from AMS.dbo.SAND_ORDER_COMPLETION where ORDER_STATUS='Not Completed' and VALID_FROM_DATE between  dateadd(mi,0,DATEADD(day, DATEDIFF(day, 0, GETDATE()), 0)) and getDate() "+
		 "union all "+ 
		 "select count(VEHICLE_NO) as COUNT, flag=3,ORDER_STATUS='In Progress' from AMS.dbo.SAND_ORDER_COMPLETION where ORDER_STATUS='In Progress' and VALID_FROM_DATE between  dateadd(mi,0,DATEADD(day, DATEDIFF(day, 0, GETDATE()), 0)) and getDate() "+
		 "union all "+
		 "select count(VEHICLE_NO) as COUNT, flag=4,ORDER_STATUS='Completed With Delay' from AMS.dbo.SAND_ORDER_COMPLETION where ORDER_STATUS='Completed With Delay' and VALID_FROM_DATE between  dateadd(mi,0,DATEADD(day, DATEDIFF(day, 0, GETDATE()), 0)) and getDate() "+
		 "union all "+
		 "select count(VEHICLE_NO) as COUNT, flag=5,ORDER_STATUS='Destination Not Available' from AMS.dbo.SAND_ORDER_COMPLETION where ORDER_STATUS='Destination Not Availabe' and VALID_FROM_DATE between  dateadd(mi,0,DATEADD(day, DATEDIFF(day, 0, GETDATE()), 0)) and getDate() order by flag  ");
         
		 rs=pstmt.executeQuery();
		 
		 while(rs.next())
		 {
			 switch(rs.getInt("flag"))
			 {
			 case 1 : jsonObject.put("completed", rs.getInt("COUNT"));
			          break;
			 case 2 : jsonObject.put("notcompleted", rs.getInt("COUNT"));
	                  break;
			 case 3 : jsonObject.put("inprogress", rs.getInt("COUNT"));
	                  break;
			 case 4 : jsonObject.put("delaycompleted", rs.getInt("COUNT"));
                      break;
			 case 5 : jsonObject.put("destnotfound", rs.getInt("COUNT"));
                      break;
			 }
		 }		 
		 pstmt.close();
		 rs.close();
		 
		 pstmt=connection.prepareStatement("select sum(r.TRIPSHEET_COUNT) as TRIPSHEET_COUNT,r.Day from ( select DATEPART(dd,dateadd(mi,330,Date_TS)) AS Day,count(a.Trip_Sheet_No) as TRIPSHEET_COUNT from dbo.Sand_Mining_Trip_Sheet a  "+
          "where a.Date_TS between dateadd(mi,-330,dateadd(dd,datediff(dd,7,getdate()),0)) and dateadd(mi,-330,dateadd(dd,datediff(dd,0,getutcdate()),0))  and Printed='Y' and isnull(a.CROSS_PLATFORM,'N')<>'Y' "+
          "and a.System_Id=229 group by DATEPART(dd,dateadd(mi,330,Date_TS))  "+
          "union all "+
          "select DATEPART(dd,dateadd(mi,330,Date_TS)) AS Day,count(a.Trip_Sheet_No) as TRIPSHEET_COUNT from dbo.Sand_Mining_Trip_Sheet_History a  "+
          "where a.Date_TS between dateadd(mi,-330,dateadd(dd,datediff(dd,7,getdate()),0))  and dateadd(mi,-330,dateadd(dd,datediff(dd,0,getutcdate()),0)) and Printed='Y' and isnull(a.CROSS_PLATFORM,'N')<>'Y'  "+
          "and a.System_Id=229 group by DATEPART(dd,dateadd(mi,330,Date_TS)) ) r group by r.Day ");
		 int count=0;
		 rs=pstmt.executeQuery();
		 while(rs.next())
		 {
			 count++;
			 if(count==1)
					jsonObject.put("waybill7", rs.getString("TRIPSHEET_COUNT"));	
					if(count==2)
					jsonObject.put("waybill6", rs.getString("TRIPSHEET_COUNT"));	
					if(count==3)
					jsonObject.put("waybill5", rs.getString("TRIPSHEET_COUNT"));	
					if(count==4)
					jsonObject.put("waybill4", rs.getString("TRIPSHEET_COUNT"));	
					if(count==5)
					jsonObject.put("waybill3", rs.getString("TRIPSHEET_COUNT"));
					if(count==6)
					jsonObject.put("waybill2", rs.getString("TRIPSHEET_COUNT"));
					if(count==7)
					jsonObject.put("waybill1", rs.getString("TRIPSHEET_COUNT"));	
		 }
		 pstmt.close();
		 rs.close();
		 
		 pstmt=connection.prepareStatement(" select sum(r.AMOUNT) as AMOUNT,r.Day from (select DATEPART(dd,dateadd(mi,330,Date_TS)) AS Day,SUM(a.Royalty) as AMOUNT from dbo.Sand_Mining_Trip_Sheet a  "+
     "where a.Date_TS between dateadd(mi,-330,dateadd(dd,datediff(dd,7,getdate()),0)) and dateadd(mi,-330,dateadd(dd,datediff(dd,0,getdate()),0)) "+  
     "and a.System_Id=229 group by DATEPART(dd,dateadd(mi,330,Date_TS)) "+ 
     "union all "+
     "select DATEPART(dd,dateadd(mi,330,Date_TS)) AS Day,SUM(a.Royalty) as AMOUNT from dbo.Sand_Mining_Trip_Sheet_History a  "+ 
     "where a.Date_TS between dateadd(mi,-330,dateadd(dd,datediff(dd,7,getdate()),0)) and dateadd(mi,-330,dateadd(dd,datediff(dd,0,getdate()),0))  "+ 
     "and a.System_Id=229 group by DATEPART(dd,dateadd(mi,330,Date_TS)) ) r group by r.Day") ;
		 
		 rs=pstmt.executeQuery();
		 count=0;
		 while(rs.next())
		 {

			 count++;
			 if(count==1)
					jsonObject.put("revenue7", rs.getString("AMOUNT"));	
					if(count==2)
					jsonObject.put("revenue6", rs.getString("AMOUNT"));	
					if(count==3)
					jsonObject.put("revenue5", rs.getString("AMOUNT"));	
					if(count==4)
					jsonObject.put("revenue4", rs.getString("AMOUNT"));	
					if(count==5)
					jsonObject.put("revenue3", rs.getString("AMOUNT"));
					if(count==6)
					jsonObject.put("revenue2", rs.getString("AMOUNT"));
					if(count==7)
					jsonObject.put("revenue1", rs.getString("AMOUNT"));	
		 
		 }
		 jsonArray.put(jsonObject);
		}
		catch (Exception e) {
			e.printStackTrace();// TODO: handle exception
		}
		finally
		{
			 DBConnection.releaseConnectionToDB(connection, pstmt, rs);
		}
		return jsonArray;
	}
	
public  JSONArray waitingLoadingTime() {
		
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		Connection connection=null;
		JSONArray jsonArray=new JSONArray();
		
		try
		{
		 connection = DBConnection.getConnectionToDB("AMS");
		 pstmt=connection.prepareStatement("select sum(WAITING_TIME)/COUNT(WAITING_TIME) as WAITING,sum(LOADING_TIME)/COUNT(LOADING_TIME) AS LOADING,NAME FROM AMS.dbo.WAITING_LOADING_TIME a "+
         " inner join ADMINISTRATOR.dbo.CUSTOMER_MASTER b on a.CUSTOMER_ID=b.CUSTOMER_ID WHERE WAITING_TIME < 8 AND LOADING_TIME < 8 AND a.SYSTEM_ID=229 and a.INSERTED_TIME between dateadd(mi,-330,DATEADD(day, DATEDIFF(day, 0, GETDATE()), 0)) and getDate() group by a.CUSTOMER_ID,NAME order by WAITING " );
		 rs=pstmt.executeQuery();
		 
		 String waitingTime=null;
		 String loadingTime=null;
		 
		 while(rs.next())
		 {   JSONObject jsonObject=new JSONObject();
		     waitingTime = cf.convertMinutesToHHMMFormat((int)(cf.convertHHMMToMinutes(hhMMformat(rs.getDouble("WAITING")))));
		     loadingTime= cf.convertMinutesToHHMMFormat((int)(cf.convertHHMMToMinutes(hhMMformat(rs.getDouble("LOADING")))));
			 jsonObject.put("custnameId", rs.getString("NAME"));
			 jsonObject.put("waitingDistrict", waitingTime);
			 jsonObject.put("loadingDistrict", loadingTime);
			 jsonArray.put(jsonObject);
		 }
		 
		}
		catch (Exception e) {
			e.printStackTrace();// TODO: handle exception
		}
		finally
		{
			 DBConnection.releaseConnectionToDB(connection, pstmt, rs);
		}
	return jsonArray;
}

public JSONArray reachwaitingLoadingTime(String customerName) {
	
	PreparedStatement pstmt=null;
	ResultSet rs=null;
	Connection connection=null;
	JSONArray jsonArray=new JSONArray();
	
	try
	{
	 connection = DBConnection.getConnectionToDB("AMS");
	 pstmt=connection.prepareStatement("SELECT REACH_NAME,sum(WAITING_TIME)/COUNT(WAITING_TIME) as WAITING , sum(LOADING_TIME)/COUNT(LOADING_TIME) AS LOADING FROM AMS.dbo.WAITING_LOADING_TIME WHERE WAITING_TIME < 8 AND WAITING_TIME > 0  AND LOADING_TIME < 8 "+
     "AND SYSTEM_ID=229 and CUSTOMER_ID in (Select CUSTOMER_ID from ADMINISTRATOR.dbo.CUSTOMER_MASTER  where NAME=? AND SYSTEM_ID=229 ) and INSERTED_TIME between dateadd(mi,-330,DATEADD(day, DATEDIFF(day, 0, GETDATE()), 0)) and getDate() "+
     "GROUP BY REACH_NAME order by WAITING ");
	 pstmt.setString(1, customerName);
	 rs=pstmt.executeQuery();
	 
	 String waitingTime=null;
	 String loadingTime=null;
	 
	 while(rs.next())
		 {   JSONObject jsonObject=new JSONObject();
		     waitingTime = cf.convertMinutesToHHMMFormat((int)(cf.convertHHMMToMinutes(hhMMformat(rs.getDouble("WAITING")))));
		     loadingTime= cf.convertMinutesToHHMMFormat((int)(cf.convertHHMMToMinutes(hhMMformat(rs.getDouble("LOADING")))));
			 jsonObject.put("reachName", rs.getString("REACH_NAME"));
			 jsonObject.put("waitingReach", waitingTime);
			 jsonObject.put("loadingReach", loadingTime);
			 jsonArray.put(jsonObject);
		 }
	 
	}
	catch (Exception e) {
		e.printStackTrace();// TODO: handle exception
	}
	finally
	{
		 DBConnection.releaseConnectionToDB(connection, pstmt, rs);
	}
	
return jsonArray;
}


public String hhMMformat(double number)
{
	
	int b=(int)number;
	double c=number-b;
	int x=(int)(Double.parseDouble(df.format(c))*60);
	String hhMM=b+"."+String.valueOf((x));
	return hhMM;
}


//un-Authourized Reach Entry
public JSONArray unAuthourizedReachEntry() {
	
	PreparedStatement pstmt=null;
	ResultSet rs=null;
	Connection connection=null;
	JSONArray jsonArray=new JSONArray();
	
	try
	{
	 connection = DBConnection.getConnectionToDB("AMS");
	 pstmt=connection.prepareStatement("select isnull(VEHICLE_NO,'') as VEHICLE_NO,isnull(REACH_NAME,'') as REACH_NAME,ISNULL(DATEADD(mi,330,REACH_ENTRY_DATE),'') as REACH_ENTRY_DATE,ISNULL(DATEADD(mi,330,REACH_EXIT_DATE),'') as REACH_EXIT_DATE , DETENTION "
	+ "from dbo.NO_OF_EWAYBILLS_AND_VISITS where SYSTEM_ID=229 and (WAY_BILL_NO IS NULL OR WAY_BILL_NO='') and REACH_ENTRY_DATE between dateadd(mi,-330,DATEADD(day, DATEDIFF(day, 0, GETDATE()), 0)) and getutcDate() and DETENTION > 0.30 ");

	
	 rs=pstmt.executeQuery();
	 
	 String waitingTime=null;
	 String loadingTime=null;
	 
	 while(rs.next())
		 {   JSONObject jsonObject=new JSONObject();
		     jsonObject.put("vehicleNo", rs.getString("VEHICLE_NO"));
			 jsonObject.put("reachName", rs.getString("REACH_NAME"));
			 jsonObject.put("reachEntryDate", rs.getString("REACH_ENTRY_DATE"));
			 jsonObject.put("reachExitDate", rs.getString("REACH_EXIT_DATE"));
			 jsonObject.put("detention", rs.getString("DETENTION"));
			 jsonArray.put(jsonObject);
		 }
	 
	}
	catch (Exception e) {
		e.printStackTrace();// TODO: handle exception
	}
	finally
	{
		 DBConnection.releaseConnectionToDB(connection, pstmt, rs);
	}
	
return jsonArray;
}



//un-Authourized Reach Entry
public ArrayList<Object> getUnauthorizedHubCount(int systemId, int customerId, int userID ,int offset,String startDate,String endDate) {
	
	PreparedStatement pstmt=null;
	ResultSet rs=null;
	Connection connection=null;
	JSONArray jsonArray=new JSONArray();
	startDate=startDate.replace('T', ' ');
	endDate=endDate.replace('T', ' ');
	ArrayList<ReportHelper> reportsList = new ArrayList<ReportHelper>();
	ArrayList<String> headersList = new ArrayList<String>();
	ReportHelper finalreporthelper = new ReportHelper();
	ArrayList < Object > finlist = new ArrayList < Object > ();
	headersList.add("SL NO");
	headersList.add("Asset Number");
	headersList.add("Asset Group");
	headersList.add("Hub Arr/Dep Count");
	try
	{
	 connection = DBConnection.getConnectionToDB("AMS");
	 pstmt=connection.prepareStatement(SandMiningStatements.UNAUTHORIZED_HUB_COUNT);
	 pstmt.setInt(1, systemId);
	 pstmt.setInt(2, customerId);
	 pstmt.setInt(3, offset);
	 pstmt.setString(4, startDate);
	 pstmt.setInt(5, offset);
	 pstmt.setString(6, endDate);
	 rs=pstmt.executeQuery();
	 
	 String waitingTime=null;
	 String loadingTime=null;
	 int count=0;
	 while(rs.next())
		 {   count++;
		     JSONObject jsonObject=new JSONObject();
		     ArrayList informationList = new ArrayList();
			 ReportHelper reporthelper = new ReportHelper();
		     jsonObject.put("slnoIndex", count);
		     informationList.add(count);
		     jsonObject.put("AssetNoIndex", rs.getString("ASSET_NUMBER"));
			 informationList.add(rs.getString("ASSET_NUMBER"));
			 jsonObject.put("AssetGroupIndex", rs.getString("ASSET_GROUP"));
			 informationList.add(rs.getString("ASSET_GROUP"));
			 jsonObject.put("HubCountIndex", rs.getString("COUNT"));
			 informationList.add(rs.getString("COUNT"));
			 
			 jsonArray.put(jsonObject);
			 reporthelper.setInformationList(informationList);
			 reportsList.add(reporthelper);
		 }
	 finalreporthelper.setReportsList(reportsList);
     finalreporthelper.setHeadersList(headersList);
     finlist.add(jsonArray);
     finlist.add(finalreporthelper);
	 
	}
	catch (Exception e) {
		e.printStackTrace();// TODO: handle exception
	}
	finally
	{
		 DBConnection.releaseConnectionToDB(connection, pstmt, rs);
	}
	
return finlist;
}

public String sendSMS()
{
	PreparedStatement pstmt=null;
	ResultSet rs=null;
	Connection connection=null;
	String countMDP="";
	String countQuantity="";
	String countTotalFees="";
	String msg="";
	try{
		connection = DBConnection.getConnectionToDB("AMS");
		
		pstmt=connection.prepareStatement(SandMiningStatements.GET_TOTAL_MDP_ISSUED_REPORT_SMS);
		pstmt.setInt(1, 183);
		pstmt.setInt(2, 183);
		rs=pstmt.executeQuery();
		while(rs.next())
		{
			countMDP=rs.getString("COUNT");
		}
		rs.close();
		pstmt.close();
		pstmt=connection.prepareStatement(SandMiningStatements.GET_TOTAL_FEES_REPORT_SMS);
		pstmt.setInt(1, 183);
		pstmt.setInt(2, 183);
		rs=pstmt.executeQuery();
		while(rs.next())
		{
			countTotalFees=rs.getString("COUNT");
		}
		rs.close();
		pstmt.close();
		pstmt=connection.prepareStatement(SandMiningStatements.GET_TOTAL_QUANTITY_REPORT_SMS);
		pstmt.setInt(1, 183);
		pstmt.setInt(2, 183);
		rs=pstmt.executeQuery();
		while(rs.next())
		{
			countQuantity=rs.getString("COUNT");
		}
		rs.close();
		pstmt.close();
		 String mobileNo="8147051251,8904788574,9448140021,9449094491,9449732424,8892273374,7760265920,9481560939,9480804258,9480804257,9880770880,9480804222,9741695388,9480804258,9686148155,8553259544";
		 String MobileNos[]=mobileNo.split(",");
		 for (int i = 0; i < MobileNos.length; i++) {
		 String Sms="Daily Sand Summary"+"\n"+"Total MDPs: "+countMDP+"\n"+"Total Fees Collected: "+countTotalFees +" Rs"+"\n"+"Total Quantity: "+countQuantity+" Cubic Meters" ;
	        pstmt = connection.prepareStatement(SandMiningStatements.UPDATE_SMS);
	        pstmt.setString(1, MobileNos[i]);
	        pstmt.setString(2, Sms);
	        pstmt.setString(3, "N");
	        pstmt.setInt(4, 3762);
	        pstmt.setInt(5, 183);
	        int insert=pstmt.executeUpdate(); 
		   if(insert>0)
			   msg="SMS Sent Successfully";
		       //System.out.println(msg);
		       //System.out.println(MobileNos[i]);
		 }
	}
	catch (Exception e) {
		e.printStackTrace();// TODO: handle exception
	}
	return msg;
	
}
public String CheckBlockedVehicles(String vehicleNo,int systemId,int CustID){
	PreparedStatement pstmtop=null;
	ResultSet rs=null;
	Connection con=null;
	String message="";
	try{
		con = DBConnection.getConnectionToDB("AMS");
		pstmtop = con.prepareStatement(SandMiningStatements.CHECK_RECORD_EXISTS);
		pstmtop.setInt(1, systemId);
		pstmtop.setInt(2, CustID);
		pstmtop.setString(3, vehicleNo);
		rs = pstmtop.executeQuery();
		if (rs.next()) {
		message = "Vehicle Already Blocked";
		}
	}catch (Exception e) {
	e.printStackTrace();
	message = "error";
	} finally {
	DBConnection.releaseConnectionToDB(con, pstmtop, null);
	}
	return message;
	}
public String InsertBlockedVehicles(String vehicleNo,String blockreason,String Remarks,int systemId,int CustID,int userId){
	PreparedStatement pstmt=null;
	ResultSet rs=null;
	Connection con=null;
	String message="";
	try{
		con = DBConnection.getConnectionToDB("AMS");
		pstmt=con.prepareStatement(SandMiningStatements.INSERT_INTO_SAND_BLOCKED_VEHICLE_DETAILS);
		pstmt.setString(1, vehicleNo);
		pstmt.setString(2, blockreason);
		pstmt.setString(3, Remarks);
		pstmt.setInt(4, userId);
		pstmt.setInt(5, systemId);
		pstmt.setInt(6,CustID);
		
	    int updated=pstmt.executeUpdate();
	if (updated>0) {
		message = "Vehicle Blocked Successfully";
	}
	}catch (Exception e) {
	e.printStackTrace();
	message = "error";
	} finally {
	DBConnection.releaseConnectionToDB(con, pstmt, null);
	}
	return message;
	}
public ArrayList<Object> getBlockedVehicleDetails(int systemId,int clientId,int userId,int offmin,String startdate,String enddate) {
	
	PreparedStatement pstmt=null;
	ResultSet rs=null;
	Connection connection=null;
	JSONArray jsonArray=new JSONArray();
	SimpleDateFormat yyyymmdd = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	SimpleDateFormat ddmmyyyy = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
	ArrayList<ReportHelper> reportsList = new ArrayList<ReportHelper>();
	ArrayList<String> headersList = new ArrayList<String>();
	ReportHelper finalreporthelper = new ReportHelper();
	ArrayList < Object > finlist = new ArrayList < Object > ();
	headersList.add("SL NO");
	headersList.add("Vehicle No");
	headersList.add("Vehicle Group");
	headersList.add("Blocked Reason");
	headersList.add("Blocked Remarks");
	headersList.add("Blocked Date");
	headersList.add("Blocked By");
	headersList.add("Id");
	try
	{
	 connection = DBConnection.getConnectionToDB("AMS");
	 pstmt=connection.prepareStatement(SandMiningStatements.GET_SAND_BLOCKED_VEHICLE_DETAILS);
	 pstmt.setInt(1, offmin);
	 pstmt.setInt(2, systemId);
	 pstmt.setInt(3, clientId);
	 pstmt.setString(4, startdate);
	 pstmt.setString(5, enddate);
	 rs=pstmt.executeQuery();
	 int count=0;
	 while(rs.next())
		 {   
		 	 count++;
		     JSONObject jsonObject=new JSONObject();
		     ArrayList informationList = new ArrayList();
			 ReportHelper reporthelper = new ReportHelper();  
			 jsonObject.put("SNOIndex", count);
		     informationList.add(count);
			 
		     jsonObject.put("VehicleNoIndex", rs.getString("VehicleNo"));
		     informationList.add( rs.getString("VehicleNo"));
			 jsonObject.put("VehicleGroupIndex", rs.getString("ASSET_GROUP"));
			 informationList.add( rs.getString("ASSET_GROUP"));
			 jsonObject.put("BlockedReasonIndex", rs.getString("BLOCKED_REASON"));
			 informationList.add( rs.getString("BLOCKED_REASON"));
			 jsonObject.put("BlockedRemarksIndex", rs.getString("BLOCKED_REMARKS"));
			 informationList.add( rs.getString("BLOCKED_REMARKS"));
			 jsonObject.put("BlockedByIndex", rs.getString("BLOCKED_BY"));
			 jsonObject.put("BlockedDateIndex", ddmmyyyy.format(yyyymmdd.parse(rs.getString("BLOKED_DATETIME"))));
			 informationList.add(ddmmyyyy.format(yyyymmdd.parse(rs.getString("BLOKED_DATETIME"))));
			 jsonObject.put("IdIndex", rs.getString("ID"));
			 informationList.add(rs.getString("BLOCKED_BY"));
			 informationList.add(rs.getString("ID"));
			 jsonArray.put(jsonObject);
			 reporthelper.setInformationList(informationList);
			 reportsList.add(reporthelper);
		 }
		finalreporthelper.setReportsList(reportsList);
		finalreporthelper.setHeadersList(headersList);
		finlist.add(jsonArray);
		finlist.add(finalreporthelper);
	}
	catch (Exception e) {
		e.printStackTrace();
	}
	finally
	{
		 DBConnection.releaseConnectionToDB(connection, pstmt, rs);
	}
	
return finlist;
}
public String UnBlockVehicles(String vehicleNo,String blockreason,String blockedremarks,String blockeddate,int blockedby,String unblockingReason,String Remarks,int systemId,int CustID,int userId,int id,String penalty,String penaltyAmt){
	PreparedStatement pstmt=null;
	PreparedStatement pstmtop=null;
	ResultSet rs=null;
	ResultSet rs1=null;
	Connection con=null;
	String message="";
	SimpleDateFormat yyyymmdd = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	SimpleDateFormat ddmmyyyy = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
	
	try{
		con = DBConnection.getConnectionToDB("AMS");
		pstmt=con.prepareStatement(SandMiningStatements.INSERT_INTO_SAND_BLOCKED_VEHICLE_DETAILS_HISTORY);
		pstmt.setInt(1, id);
		pstmt.setString(2, vehicleNo);
		pstmt.setString(3, blockreason);
		pstmt.setString(4, blockedremarks);
		pstmt.setString(5, yyyymmdd.format(ddmmyyyy.parse(blockeddate)));
		pstmt.setInt(6, blockedby);
		pstmt.setInt(7, systemId);
		pstmt.setInt(8,CustID);
		pstmt.setString(9,unblockingReason);
		pstmt.setString(10, Remarks);
		pstmt.setInt(11, userId);
		pstmt.setString(12, penalty);
		pstmt.setString(13, penaltyAmt);
		
       int update= pstmt.executeUpdate();
		if (update>0) {
			message = "Vehicle UnBlocked Successfully";
			pstmtop = con.prepareStatement(SandMiningStatements.DELETE_UNBLOCKED_VEHICLE);
			pstmtop.setInt(1, CustID);
			pstmtop.setInt(2, systemId);
			pstmtop.setString(3, vehicleNo);
			pstmtop.executeUpdate();
		}else{
			message = "Error while unblocking vehicle.";
		}
	}catch (Exception e) {
		e.printStackTrace();
	} finally {
		DBConnection.releaseConnectionToDB(null, pstmt, rs);
		DBConnection.releaseConnectionToDB(con, pstmtop, rs1);
	}
	return message;
	}

public ArrayList<Object> getBlockedUnblockedReport(int systemId,int clientId,int userId,int offset,String startdate,String enddate,String type) {
	
	PreparedStatement pstmt=null;
	ResultSet rs=null;
	Connection connection=null;
	JSONArray jsonArray=new JSONArray();
	SimpleDateFormat yyyymmdd = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	SimpleDateFormat ddmmyyyy = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
	ArrayList<ReportHelper> reportsList = new ArrayList<ReportHelper>();
	ArrayList<String> headersList = new ArrayList<String>();
	ReportHelper finalreporthelper = new ReportHelper();
	ArrayList < Object > finlist = new ArrayList < Object > ();
	headersList.add("SL NO");
	headersList.add("Vehicle No");
	headersList.add("Blocked Reason");
	headersList.add("Blocked Remarks");
	headersList.add("Blocked Date");
	headersList.add("Blocked By");
	headersList.add("Unblocked Reason");
	headersList.add("Unblocked Remarks");
	headersList.add("Unblocked Date");
	headersList.add("Unblocked By");
	headersList.add("Panalty");
	headersList.add("Panalty Amount");
	try
	{
	 connection = DBConnection.getConnectionToDB("AMS");
	 if(type.equalsIgnoreCase("Blocked")){
		 pstmt=connection.prepareStatement(SandMiningStatements.GET_BLOCKED_VEHICLES_REPORT);
		 pstmt.setInt(1, offset);
		 pstmt.setInt(2, systemId);
		 pstmt.setInt(3, clientId);
		 pstmt.setInt(4,offset);
		 pstmt.setString(5, startdate);
		 pstmt.setInt(6,offset);
		 pstmt.setString(7, enddate);
		 rs=pstmt.executeQuery();
	 }else if(type.equalsIgnoreCase("Unblocked")){
		 pstmt=connection.prepareStatement(SandMiningStatements.GET_UNBLOCKED_VEHICLES_REPORT);
		 pstmt.setInt(1, offset);
		 pstmt.setInt(2, systemId);
		 pstmt.setInt(3, clientId);
		 pstmt.setInt(4,offset);
		 pstmt.setString(5, startdate);
		 pstmt.setInt(6,offset);
		 pstmt.setString(7, enddate);
		 rs=pstmt.executeQuery();
	 }else {
	 pstmt=connection.prepareStatement(SandMiningStatements.GET_BLOCKED_UNBLOCKED_VEHICLES_REPORT);
	 pstmt.setInt(1, offset);
	 pstmt.setInt(2, systemId);
	 pstmt.setInt(3, clientId);
	 pstmt.setInt(4,offset);
	 pstmt.setString(5, startdate);
	 pstmt.setInt(6,offset);
	 pstmt.setString(7, enddate);
	 pstmt.setInt(8, offset);
	 pstmt.setInt(9, systemId);
	 pstmt.setInt(10, clientId);
	 pstmt.setInt(11,offset);
	 pstmt.setString(12, startdate);
	 pstmt.setInt(13,offset);
	 pstmt.setString(14, enddate);
	 rs=pstmt.executeQuery();
	 }
	 
	 int count=0;
	 if(rs!=null){
	 while(rs.next())
		 {   
		 	 count++;
		     JSONObject jsonObject=new JSONObject();
		     ArrayList informationList = new ArrayList();
			 ReportHelper reporthelper = new ReportHelper();  
			 jsonObject.put("SNOIndex", count);
		     informationList.add(count);
			 
		     jsonObject.put("VehicleNoIndex", rs.getString("VehicleNo"));
		     informationList.add( rs.getString("VehicleNo"));
		     if (rs.getString("BLOCKED_REASON") != null) {
					informationList.add(rs.getString("BLOCKED_REASON"));
					jsonObject.put("BlockedReasonIndex", rs.getString("BLOCKED_REASON"));
					}
		     if (rs.getString("BLOCKED_REMARKS") == null || rs.getString("BLOCKED_REMARKS").equals("")) {
		    	 	informationList.add("");
					jsonObject.put("BlockedRemarksIndex", "");
					}else{
					informationList.add(rs.getString("BLOCKED_REMARKS"));
					jsonObject.put("BlockedRemarksIndex", rs.getString("BLOCKED_REMARKS"));
					}
		     if (rs.getString("BLOCKED_DATETIME").contains("1900") || rs.getString("BLOCKED_DATETIME")== null || rs.getString("BLOCKED_DATETIME").equals("")) {
		    	 	informationList.add("");
					jsonObject.put("BlockedDateIndex", "");
					}else{
					informationList.add(ddmmyyyy.format(yyyymmdd.parse(rs.getString("BLOCKED_DATETIME"))));
					jsonObject.put("BlockedDateIndex", ddmmyyyy.format(yyyymmdd.parse(rs.getString("BLOCKED_DATETIME"))));
					}
		     if (rs.getString("BLOCKED_BY") == null || rs.getString("BLOCKED_BY").equals("")) {
		    	 	informationList.add("");
					jsonObject.put("BlockedByIndex", "");
					}else{
					informationList.add(rs.getString("BLOCKED_BY"));
					jsonObject.put("BlockedByIndex", rs.getString("BLOCKED_BY"));
					}
		     if (rs.getString("UNBLOCK_REASON") == null || rs.getString("UNBLOCK_REASON").equals("")) {
		    	 	informationList.add("");
					jsonObject.put("UnblockedReasonIndex", "");
					}else{
					informationList.add(rs.getString("UNBLOCK_REASON"));
					jsonObject.put("UnblockedReasonIndex", rs.getString("UNBLOCK_REASON"));
					}
		     if (rs.getString("UNBLOCK_REMARKS") == null || rs.getString("UNBLOCK_REMARKS").equals("")) {
		    	 	informationList.add("");
					jsonObject.put("UnblockedRemarksIndex", "");
					}else{
					informationList.add(rs.getString("UNBLOCK_REMARKS"));
					jsonObject.put("UnblockedRemarksIndex", rs.getString("UNBLOCK_REMARKS"));
					}
			 if (rs.getString("UNBLOCK_DATETIME").contains("1900")|| rs.getString("UNBLOCK_DATETIME") == null || rs.getString("UNBLOCK_DATETIME").equals("")) {
				 	jsonObject.put("UnblockedDateIndex", "");
					informationList.add("");
					} else {
					jsonObject.put("UnblockedDateIndex", ddmmyyyy.format(yyyymmdd.parse(rs.getString("UNBLOCK_DATETIME"))));
					informationList.add(ddmmyyyy.format(yyyymmdd.parse(rs.getString("UNBLOCK_DATETIME"))));
				}
			 if (rs.getString("UNBLOCKED_BY") == null || rs.getString("UNBLOCKED_BY").equals("") ) {
				 	informationList.add("");
					jsonObject.put("UnblockedByIndex", "");
					}else{
					informationList.add(rs.getString("UNBLOCKED_BY"));
					jsonObject.put("UnblockedByIndex", rs.getString("UNBLOCKED_BY"));
					}
			 if (rs.getString("PENALTY") == null || rs.getString("PENALTY").equals("") ) {
				 	informationList.add("");
					jsonObject.put("PenaltyIndex", "");
					}else{
					informationList.add(rs.getString("PENALTY"));
					jsonObject.put("PenaltyIndex", rs.getString("PENALTY"));
					}
			 if (rs.getString("PENALTY_AMOUNT") == null || rs.getString("PENALTY_AMOUNT").equals("") ) {
				 	informationList.add("");
					jsonObject.put("PenaltyAmountIndex", "");
					}else{
					informationList.add(rs.getString("PENALTY_AMOUNT"));
					jsonObject.put("PenaltyAmountIndex", rs.getString("PENALTY_AMOUNT"));
					}
			 
			 jsonArray.put(jsonObject);
			 reporthelper.setInformationList(informationList);
			 reportsList.add(reporthelper);
		 }
	 }
		finalreporthelper.setReportsList(reportsList);
		finalreporthelper.setHeadersList(headersList);
		finlist.add(jsonArray);
		finlist.add(finalreporthelper);
	}
	catch (Exception e) {
		e.printStackTrace();
	}
	finally
	{
		 DBConnection.releaseConnectionToDB(connection, pstmt, rs);
	}
	
return finlist;
}

public boolean status(int systemId) {
	PreparedStatement pstmt=null;
	ResultSet rs=null;
	Connection con = null;
	boolean CONSUMER_MDP_FEATURE = false;
	String message = null;
	try {
		 con = DBConnection.getConnectionToDB("AMS");
		pstmt = con
				.prepareStatement("select value from General_Settings where name='CONSUMER_MDP_FEATURE' and System_Id=? ");
		pstmt.setInt(1, systemId);
		rs = pstmt.executeQuery();
		if (rs.next()) {
			String ConsumerMdpStatus = rs.getString("value");
			if (ConsumerMdpStatus.equals("Y")) {
				CONSUMER_MDP_FEATURE = true;
			}
		}

	} catch (Exception e) {
		e.printStackTrace();
	} finally {
		//releaseConnection(con, pstmt, rs);
		DBConnection.releaseConnectionToDB(con, pstmt, rs);
	}
	return CONSUMER_MDP_FEATURE;
}

public boolean AadharMandatory(int systemId) {
	PreparedStatement pstmt=null;
	ResultSet rs=null;
	Connection con = null;
	boolean aadharMandatory = false;
	String message = null;
	try {
		 con = DBConnection.getConnectionToDB("AMS");
		pstmt = con
				.prepareStatement("select value from General_Settings where name='AADHAR_MANDATORY' and System_Id=? ");
		pstmt.setInt(1, systemId);
		rs = pstmt.executeQuery();
		if (rs.next()) {
			String aadharMandatoryStatus = rs.getString("value");
			if (aadharMandatoryStatus.equals("Y")) {
				aadharMandatory = true;
			}
		}

	} catch (Exception e) {
		e.printStackTrace();
	} finally {
		DBConnection.releaseConnectionToDB(con, pstmt, rs);
	}
	return aadharMandatory;
}

public JSONArray getSandPortList(String custId,int systemId) {
    Connection conAdmin = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    JSONArray jsonArray = new JSONArray();
    JSONObject jsonObject = new JSONObject();
    try {
        conAdmin = DBConnection.getConnectionToDB("AMS");
        pstmt = conAdmin.prepareStatement(SandMiningStatements.GET_SAND_PORT);
        pstmt.setInt(1, systemId);
        pstmt.setString(2, custId);
        pstmt.setString(3, "Active");
        rs = pstmt.executeQuery();
        while (rs.next()) {
            jsonObject = new JSONObject();
            jsonObject.put("PortName", rs.getString("Port_Name"));
            jsonObject.put("PortId", rs.getString("UniqueId"));
            jsonArray.put(jsonObject);
        }

    } catch (Exception e) {
    	 e.printStackTrace();
    } finally {
        DBConnection.releaseConnectionToDB(conAdmin, pstmt, rs);
    }
    return jsonArray;
}	

public String saveSandPortQuantity(String dateVal, String sandPort, String sandPortId, String excavatedQty, String qtyMeasure, int custId, int systemId, int userId) {
	Connection con = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	String message = "Failure";
	
	try {
		con = DBConnection.getConnectionToDB("AMS");
		
		pstmt = con.prepareStatement(SandMiningStatements.CHECK_SANDPORT_QUANTITY_DETAILS);
		pstmt.setString(1, sandPort);
		pstmt.setString(2, dateVal);
		pstmt.setString(3, dateVal);
		pstmt.setInt(4, systemId);
		pstmt.setInt(5, custId);
		rs = pstmt.executeQuery();
		if (rs.next()) {
			return "Excavated Quantity alredy updated for selected Port in selected Date";
		}
		
		pstmt = con.prepareStatement(SandMiningStatements.INSERT_INTO_SANDPORT_QUANTITY_DETAILS);
		pstmt.setString(1, dateVal);
		pstmt.setString(2, sandPort);
		pstmt.setString(3, sandPortId);
		pstmt.setString(4, excavatedQty);
		pstmt.setString(5, qtyMeasure);
		pstmt.setInt(6, systemId);
		pstmt.setInt(7, custId);
		pstmt.setInt(8, userId);
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

public ArrayList < Object > getSandPortQuantityData(int clientId, int systemid,String startDate,String endDate) {
    JSONArray JsonArray = new JSONArray();
    JSONObject JsonObject = null;
    Connection con = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    SimpleDateFormat yyyymmdd = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	SimpleDateFormat ddmmyyyy = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
	ArrayList < Object > finlist = new ArrayList < Object > ();
    ArrayList < Object > reportsList = new ArrayList < Object > ();
	ArrayList < Object > headersList = new ArrayList < Object > ();
	ReportHelper finalreporthelper = new ReportHelper();
    DecimalFormat df = new DecimalFormat("##.##");
    try {
        int count = 0;
        headersList.add("SLNO");
        headersList.add("Date Of Excavation");
        headersList.add("Sand Port");
        headersList.add("Excavated Quantity");
        headersList.add("Quantity Measure");
        headersList.add("Created By");
        headersList.add("Created Date");
        double total=0.0;   
        con = DBConnection.getConnectionToDB("AMS");
            pstmt = con.prepareStatement(SandMiningStatements.GET_SANDPORT_QUANTITY_DETAILS);
            pstmt.setInt(1, systemid);
            pstmt.setInt(2, clientId);
			pstmt.setString(3, startDate);
			pstmt.setString(4, endDate);
            rs = pstmt.executeQuery();
        while (rs.next()) {
            JsonObject = new JSONObject();
            count++;
        	ArrayList<Object> informationList = new ArrayList<Object>();
			ReportHelper reporthelper = new ReportHelper();
			
        	informationList.add(count);
		    JsonObject.put("slnoIndex", count);
		    
		    informationList.add(ddmmyyyy.format(yyyymmdd.parseObject(rs.getString("EXCAVATION_DATE"))));
		    JsonObject.put("dateExcavationIndex", ddmmyyyy.format(yyyymmdd.parse(rs.getString("EXCAVATION_DATE"))));
			
            informationList.add(rs.getString("SAND_PORT_NAME"));
	        JsonObject.put("sandPortIndex", rs.getString("SAND_PORT_NAME"));
	            
	        informationList.add(rs.getString("SAND_QUANTITY"));
            JsonObject.put("excavatedQtyIndex", rs.getString("SAND_QUANTITY"));
            total+=rs.getDouble("SAND_QUANTITY");
            
            informationList.add(rs.getString("QUANTITY_MEASURE"));
            JsonObject.put("QtyMeasureIndex", rs.getString("QUANTITY_MEASURE"));
            
            informationList.add(rs.getString("INSERTED_BY"));
			JsonObject.put("createdByIndex", rs.getString("INSERTED_BY"));
			
			informationList.add(ddmmyyyy.format(yyyymmdd.parseObject(rs.getString("INSERTED_DATETIME"))));
		    JsonObject.put("createdDateIndex", ddmmyyyy.format(yyyymmdd.parse(rs.getString("INSERTED_DATETIME"))));
			
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

public JSONArray getTotalDispatchedDetails(String custId,int systemId,String startDate,String endDate) {
    Connection conAdmin = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    JSONArray jsonArray = new JSONArray();
    JSONObject jsonObject = new JSONObject();
    try {
        conAdmin = DBConnection.getConnectionToDB("AMS");
        pstmt = conAdmin.prepareStatement(SandMiningStatements.GET_TOTAL_DISPATCHED_DETAILS);
        pstmt.setInt(1, systemId);
        pstmt.setString(2, custId);
        pstmt.setString(3, "Y");
        pstmt.setString(4, startDate);
		pstmt.setString(5, endDate);
		pstmt.setInt(6, systemId);
        pstmt.setString(7, custId);
        pstmt.setString(8, "Y");
        pstmt.setString(9, startDate);
		pstmt.setString(10, endDate);
        rs = pstmt.executeQuery();
        while (rs.next()) {
            jsonObject = new JSONObject();
            jsonObject.put("quantity", rs.getString("Quantity"));
            jsonArray.put(jsonObject);
        }

    } catch (Exception e) {
    	 e.printStackTrace();
    } finally {
        DBConnection.releaseConnectionToDB(conAdmin, pstmt, rs);
    }
    return jsonArray;
}	

public JSONArray getstockLocation(int customerId,int systemId) {
    JSONArray JsonArray = null;
    JSONObject JsonObject = null;
    Connection con = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    try {
        JsonArray = new JSONArray();
        con = DBConnection.getConnectionToDB("AMS");
        pstmt = con.prepareStatement(SandMiningStatements.GET_STOCKYARD_LOCATION);
        pstmt.setInt(1, systemId);
        pstmt.setInt(2,customerId);
        rs = pstmt.executeQuery();
        while (rs.next()) {
            JsonObject = new JSONObject();
            JsonObject.put("stockname", rs.getString("SAND_STOCKYARD_NAME"));
            JsonObject.put("uniqueid", rs.getString("UNIQUE_ID"));
           JsonArray.put(JsonObject);
        }
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        DBConnection.releaseConnectionToDB(con, pstmt, rs);
    }
    return JsonArray;
}

public JSONArray getAbstactDetails(String startDate,String endDate,String Stockname,int uniqueid) {
    
	JSONArray JsonArray = null;
    JSONObject JsonObject = null;
    Connection con = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    String date="";
    try {
    	int count = 0;
        JsonArray = new JSONArray();
        con = DBConnection.getConnectionToDB("AMS");
        pstmt = con.prepareStatement(SandMiningStatements.GET_ABSTACT_DETAILS);
        pstmt.setInt(1, uniqueid);
        pstmt.setInt(2, uniqueid);
        pstmt.setInt(3, uniqueid);
        pstmt.setString(4, startDate);
        pstmt.setString(5,endDate);
        pstmt.setString(6, Stockname);
        rs = pstmt.executeQuery();
        while (rs.next()) {
        	count++;
            JsonObject = new JSONObject();
            date = rs.getString("DATE");
	    	
	    	if(date.equals("1900-01-01 00:00:00.0")){
	    		date="";
	    	}
	    	else if(!date.equals("")){
	    		date =sdfyyyymmddhhmmss.format(sdfyyyymmddhhmmss1.parse(rs.getString("DATE")));
	    	}
            JsonObject.put("slno1",count);
            JsonObject.put("date",date);
            JsonObject.put("noofimg", rs.getString("IMAGE_PATH"));
            JsonObject.put("noid", rs.getString("ASSET_NUMBER"));
            JsonObject.put("gpsfitted", rs.getString("GPS_FITTED"));
            JsonObject.put("gpsnotfitted",rs.getString("GPS_NOT_FITTED"));
            JsonArray.put(JsonObject);
        }

    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        DBConnection.releaseConnectionToDB(con, pstmt, rs);
    }
    return JsonArray;
}

public JSONArray getDetailedDetails(String Stockname,String startDate,String endDate) {
    
	JSONArray JsonArray = null;
    JSONObject JsonObject = null;
    Connection con = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    String dateTime="";
    String GPSFitted="";
    try {
    	int count = 0;
        JsonArray = new JSONArray();
        con = DBConnection.getConnectionToDB("AMS");
        pstmt = con.prepareStatement(SandMiningStatements.GET_DETAILED_DETAILS);
        pstmt.setString(1, Stockname);
        pstmt.setString(2, startDate);
        pstmt.setString(3,endDate);
        rs = pstmt.executeQuery();
        while (rs.next()) {
        	count++;
            JsonObject = new JSONObject();
            dateTime = rs.getString("DATE");
	    	
	    	if(dateTime.equals("1900-01-01 00:00:00.0")){
	    		dateTime="";
	    	}
	    	else if(!dateTime.equals("")){
	    		dateTime =sdfyyyymmddhhmmss.format(sdfyyyymmddhhmmss1.parse(rs.getString("DATE")));
	    	}
           
	    	if(rs.getString("GPS_FITTED").equals("N")){
        	   GPSFitted="No";
	    	}
	    	else{
	    		GPSFitted="Yes";
	    	}
           JsonObject.put("slno", count);
            JsonObject.put("datendtime", dateTime);
            JsonObject.put("vehicleimg", "<html><body><img src='ftp://172.16.5.28/123Sand/SoftwareTesting/"+rs.getString("IMAGE_PATH").substring(rs.getString("IMAGE_PATH").lastIndexOf("\\")+1)+"' width='300' height='100'></body></html>");//rs.getString("IMAGE_PATH"));
            JsonObject.put("vehno",  rs.getString("ASSET_NUMBER"));
            JsonObject.put("gpsfitted",  GPSFitted);
            JsonArray.put(JsonObject);
        }

    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        DBConnection.releaseConnectionToDB(con, pstmt, rs);
    }
    return JsonArray;
}


public boolean isChikkmagalurModel(int systemId) {
	PreparedStatement pstmt=null;
	ResultSet rs=null;
	Connection con = null;
	boolean CONSUMER_MDP_FEATURE = false;
	String message = null;
	try {
		 con = DBConnection.getConnectionToDB("AMS");
		pstmt = con
				.prepareStatement("select value from General_Settings where name='CONSUMER_MDP_CHIKKMAGALUR_MODEL' and System_Id=? ");
		pstmt.setInt(1, systemId);
		rs = pstmt.executeQuery();
		if (rs.next()) {
			String ConsumerMdpStatusModelCKM = rs.getString("value");
			if (ConsumerMdpStatusModelCKM.equals("Y")) {
				CONSUMER_MDP_FEATURE = true;
			}
		}

	} catch (Exception e) {
		e.printStackTrace();
	} finally {
		//releaseConnection(con, pstmt, rs);
		DBConnection.releaseConnectionToDB(con, pstmt, rs);
	}
	return CONSUMER_MDP_FEATURE;
}

public boolean validateVerhoeff(String num){
	int[][] d  = new int[][]
	             {
				  {0, 1, 2, 3, 4, 5, 6, 7, 8, 9},
                  {1, 2, 3, 4, 0, 6, 7, 8, 9, 5},
                  {2, 3, 4, 0, 1, 7, 8, 9, 5, 6},
                  {3, 4, 0, 1, 2, 8, 9, 5, 6, 7},
                  {4, 0, 1, 2, 3, 9, 5, 6, 7, 8},
                  {5, 9, 8, 7, 6, 0, 4, 3, 2, 1},
                  {6, 5, 9, 8, 7, 1, 0, 4, 3, 2},
                  {7, 6, 5, 9, 8, 2, 1, 0, 4, 3},
                  {8, 7, 6, 5, 9, 3, 2, 1, 0, 4},
                  {9, 8, 7, 6, 5, 4, 3, 2, 1, 0}
	             };
	                      int[][] p = new int[][]
	                              {
	                                      {0, 1, 2, 3, 4, 5, 6, 7, 8, 9},
	                                      {1, 5, 7, 6, 2, 8, 3, 0, 9, 4},
	                                      {5, 8, 0, 3, 7, 9, 6, 1, 4, 2},
	                                      {8, 9, 1, 6, 0, 4, 3, 5, 2, 7},
	                                      {9, 4, 5, 3, 1, 2, 6, 8, 7, 0},
	                                      {4, 2, 8, 6, 5, 7, 3, 9, 0, 1},
	                                      {2, 7, 9, 3, 8, 0, 6, 4, 1, 5},
	                                      {7, 0, 4, 6, 9, 1, 3, 2, 5, 8}
	                              };
	                      int[] inv = {0, 4, 3, 2, 1, 5, 6, 7, 8, 9};
	
    int c = 0;
    int[] myArray = StringToReversedIntArray(num);
    for (int i = 0; i < myArray.length; i++){
        c = d[c][p[(i % 8)][myArray[i]]];
    }

    return (c == 0);
}


private static int[] StringToReversedIntArray(String num) {
	// TODO Auto-generated method stub
	 int[] myArray = new int[num.length()];
     for(int i = 0; i < num.length(); i++){
         myArray[i] = Integer.parseInt(num.substring(i, i + 1));
     }
     myArray = Reverse(myArray);
     return myArray;
}

private static int[] Reverse(int[] myArray) {
	// TODO Auto-generated method stub
    int[] reversed = new int[myArray.length];
    for(int i = 0; i < myArray.length ; i++){
        reversed[i] = myArray[myArray.length - (i + 1)];
    }
    return reversed;

}
public String activeOrInactiveDetails(String applicationNo, int clientId, int systemId, String status,String reasonForInactive) {
	Connection con = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	String message = "";
	JSONArray jsonArray = null;
	int inserted = 0;
	
	try {
		con = DBConnection.getConnectionToDB("AMS");
		
		pstmt = con.prepareStatement(SandMiningStatements.UPDATE_CONSUMER_ENROL_STATUS);
		pstmt.setString(1, status);
		pstmt.setString(2, reasonForInactive);
		pstmt.setInt(3, systemId);
		pstmt.setInt(4, clientId);
		pstmt.setString(5, applicationNo);
				
		inserted = pstmt.executeUpdate();
		if (inserted > 0) {
			message = "Updated Successfully";
		}else{
			message = "Error";
		}
	}catch (Exception e) {
		e.printStackTrace();
		message = "error";
	}  finally {
		DBConnection.releaseConnectionToDB(con, pstmt, rs);
	}
	return message;
}

public JSONArray getPermitNo(int systemId, int clientId, int userId) {

	JSONArray jsonArray = new JSONArray();
	JSONObject obj1 = null;
	Connection con = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;

	try {
		con = DBConnection.getConnectionToDB("AMS");
		pstmt = con.prepareStatement(SandMiningStatements.GET_TEMPROVERY_PERMIT_NO);
		pstmt.setInt(1, systemId);
		pstmt.setInt(2, clientId);
		rs = pstmt.executeQuery();

		while (rs.next()) {
			obj1 = new JSONObject();

			obj1.put("Permitid", rs.getString("Permit_NoNEW"));
			obj1.put("OName", rs.getString("LO_Name"));
			obj1.put("OType", rs.getString("Owner_Type"));
			jsonArray.put(obj1);

		} // end of while rs

	} catch (Exception e) {
		e.printStackTrace();
	} finally {
		DBConnection.releaseConnectionToDB(con, pstmt, rs);
	}
	return jsonArray;
}

public ArrayList<Object> getYearlyPermitReport(int customerid,
		String startdate, String enddate, int systemId,String permitNo) {

	JSONArray JsonArray = null;
	JSONObject JsonObject = null;
	Connection con = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	PreparedStatement pstmt1 = null;
	ResultSet rs1 = null;
	int count = 0;
	int Month = 0;
	
	ArrayList<ReportHelper> reportsList = new ArrayList<ReportHelper>();
	ArrayList<String> headersList = new ArrayList<String>();
	ReportHelper finalreporthelper = new ReportHelper();
	ArrayList<Object> finlist = new ArrayList<Object>();
	headersList.add("SLNO");
	headersList.add("TP Number");
	headersList.add("Month");
	headersList.add("Carry Forward Quantity");
	headersList.add("Approved Quantity");
	headersList.add("Dispatched Quantity");
	headersList.add("Remaining Quantity");
	
	int month[]= {1,2,3,4,5,6,7,8,9,10,11,12};
	double approvedQty[] ={0,0,0,0,0,0,0,0,0,0,0,0};
	double dispatchedQty[] = {0,0,0,0,0,0,0,0,0,0,0,0};
	double remaining[] = {0,0,0,0,0,0,0,0,0,0,0,0};
	double previouscarryforward[] = {0,0,0,0,0,0,0,0,0,0,0,0};
	double prevappo =0;
	double prevdisp =0;
	String monthName[] = {"Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"};
	
	double appTotal= 0.0;
	double dispatchTotal = 0.0;
	double remainingTotal = 0.0;
	try {
		JsonArray = new JSONArray();
		ArrayList<String> informationList = null;
		ReportHelper reporthelper = null;
		con = DBConnection.getConnectionToDB("AMS");
		//-----carry forward logic done for only previous year----
		pstmt = con.prepareStatement(SandMiningStatements.GET_TP_PREV_YEARLY_APPROVED_AMOUNT);
		pstmt.setInt(1, systemId);
		pstmt.setInt(2, customerid);
		pstmt.setString(3, permitNo);
		pstmt.setString(4, startdate);
		pstmt.setString(5, startdate);		
		rs = pstmt.executeQuery();
		while(rs.next()) {
					Double appQty = rs.getDouble("total_amount")/60 ;
					prevappo = prevappo+appQty;
				}
		pstmt1 = con.prepareStatement(SandMiningStatements.GET_TP_PREV_YEARLY_DISPATCHED_QTY);
		pstmt1.setInt(1, systemId);
		pstmt1.setInt(2, customerid);
		pstmt1.setString(3, permitNo);
		pstmt1.setString(4, startdate);
		pstmt1.setString(5, startdate);
		rs1 = pstmt1.executeQuery();
		while (rs1.next()) {
			prevdisp = prevdisp+rs1.getDouble("TotalQuantity");
			}
		
		previouscarryforward[0] = prevappo - prevdisp;
		if(previouscarryforward[0]<0){
			previouscarryforward[0]=0;
		}
		//------------------------------carry forward for only one year end------------
		pstmt = con.prepareStatement(SandMiningStatements.GET_TP_YEARLY_APPROVED_AMOUNT);
		pstmt.setInt(1, systemId);
		pstmt.setInt(2, customerid);
		pstmt.setString(3, permitNo);
		pstmt.setString(4, startdate);
		pstmt.setString(5, enddate);
		rs = pstmt.executeQuery();
		while (rs.next()) {
				int mm = rs.getInt("Month");
					Double appQty = rs.getDouble("total_amount")/60 ;
					approvedQty[mm-1]=appQty;
				}
		
		
			pstmt1 = con.prepareStatement(SandMiningStatements.GET_TP_YEARLY_DISPATCHED_QTY);
			pstmt1.setInt(1, systemId);
			pstmt1.setInt(2, customerid);
			pstmt1.setString(3, permitNo);
			pstmt1.setString(4, startdate);
			pstmt1.setString(5, enddate);
			rs1 = pstmt1.executeQuery();
			while (rs1.next()) {
				int mm = rs1.getInt("Month");
				dispatchedQty[mm-1]=rs1.getDouble("TotalQuantity");				

		} // end of while rs
		
		double rem = 0.0;	
		for(int i=0 ; i<12 ; i++){
			count++;
			JsonObject = new JSONObject();
			informationList = new ArrayList<String>();
			reporthelper = new ReportHelper();
			if(i==0){
				remaining[i]=(approvedQty[i]+previouscarryforward[i]-dispatchedQty[i]);
				
				JsonObject.put("slnoIndex",count);
				informationList.add(Integer.toString(count));
				
				JsonObject.put("TpNumberIndex",permitNo);
				informationList.add(permitNo);
				
				JsonObject.put("monthIndex",monthName[i]);
				informationList.add(monthName[i]);

				JsonObject.put("carryforwardQtyIndex",previouscarryforward[i]);
				informationList.add(Double.toString(previouscarryforward[i]));
				
				JsonObject.put("approvedQtyIndex",approvedQty[i]);
				informationList.add(Double.toString(approvedQty[i]));
				
				JsonObject.put("dispatchedQtyIndex",dispatchedQty[i]);
				informationList.add(Double.toString(dispatchedQty[i]));
				
				JsonObject.put("remainingQtyIndex",remaining[i]);
				informationList.add(Double.toString(remaining[i]));
				
			}else{
				remaining[i]=((approvedQty[i]+remaining[i-1])-dispatchedQty[i]);
				previouscarryforward[i]=remaining[i-1];
				
				JsonObject.put("slnoIndex",count);
				informationList.add(Integer.toString(count));
				
				JsonObject.put("TpNumberIndex",permitNo);
				informationList.add(permitNo);
				
				JsonObject.put("monthIndex",monthName[i]);
				informationList.add(monthName[i]);
				
				JsonObject.put("carryforwardQtyIndex",previouscarryforward[i]);
				informationList.add(Double.toString(previouscarryforward[i]));
				
				JsonObject.put("approvedQtyIndex",approvedQty[i]);
				informationList.add(Double.toString(approvedQty[i]));
				
				JsonObject.put("dispatchedQtyIndex",dispatchedQty[i]);
				informationList.add(Double.toString(dispatchedQty[i]));
				
				JsonObject.put("remainingQtyIndex",remaining[i]);
				informationList.add(Double.toString(remaining[i]));
				
			}
			
			JsonArray.put(JsonObject);
			finlist.add(JsonArray);
			reporthelper.setInformationList(informationList);
			reportsList.add(reporthelper);
			finalreporthelper.setReportsList(reportsList);
			finalreporthelper.setHeadersList(headersList);
			finlist.add(finalreporthelper);
		}

	} catch (Exception e) {
		e.printStackTrace();
	} finally {
		DBConnection.releaseConnectionToDB(con, pstmt, rs);
		DBConnection.releaseConnectionToDB(con, pstmt1, rs1);
	}
	return finlist;

}
public String insertSandBoatInfo(int systemId,int custId,String regNo,String sandBlock,String detentionMin,int userId) {
	Connection con = null;
	PreparedStatement pstmt = null;
	ResultSet rs=null;
	String message="";
	try {
		con = DBConnection.getConnectionToDB("AMS");
    	pstmt = con.prepareStatement(SandMiningStatements.INSERT_INTO_SAND_BOAT_ASSOCIATION);
     	pstmt.setString(1, regNo);
		pstmt.setInt(2, Integer.parseInt(sandBlock));
		pstmt.setString(3, detentionMin);
		pstmt.setInt(4, systemId);
		pstmt.setInt(5, custId);
		pstmt.setInt(6, userId);
		int inserted = pstmt.executeUpdate();
		if (inserted > 0) {
			message = "Saved Successfully";
		}else{
			message="Error in Saving";
		}
	} catch (Exception e) {
		e.printStackTrace();
	} finally {
		DBConnection.releaseConnectionToDB(con, pstmt, rs);
	}

	return message;
}
public String updateSandBoatInformation(int systemId,int custId,String sandBlockMod,String detentionMin,int userId,int id){
	String message="";
	Connection conAdmin = null;
	PreparedStatement pstmt = null;
	try {
		conAdmin = DBConnection.getConnectionToDB("AMS");
		int updated=0;
		pstmt=conAdmin.prepareStatement(SandMiningStatements.UPDATE_SAND_BOAT_DETAILS);
		pstmt.setInt(1, Integer.parseInt(sandBlockMod));
		pstmt.setString(2, detentionMin);
		pstmt.setInt(3, userId);
		pstmt.setInt(4,id);
		
		updated=pstmt.executeUpdate();
		if(updated>0){
			message="Updated Successfully";
		}else{
			message="Updation Failed";
		}
	} catch (Exception e) {
		System.out.println("error in Updating SandBoat Information "+e.toString());
		e.printStackTrace();
	}finally{
		DBConnection.releaseConnectionToDB(conAdmin, pstmt, null);
	}
	return message;
}
public JSONArray getSandBlock(int customerId,int systemId) {
    JSONArray JsonArray = null;
    JSONObject JsonObject = null;
    Connection con = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    try {
        JsonArray = new JSONArray();
        con = DBConnection.getConnectionToDB("AMS");
        pstmt = con.prepareStatement(SandMiningStatements.GET_SAND_BLOCKS1);
        pstmt.setInt(1, systemId);
        pstmt.setInt(2,customerId);
        rs = pstmt.executeQuery();
        while (rs.next()) {
            JsonObject = new JSONObject();
            JsonObject.put("sandBlockName", rs.getString("NAME"));
            JsonObject.put("sandBlockId", rs.getInt("HUBID"));
            JsonArray.put(JsonObject);
        }
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        DBConnection.releaseConnectionToDB(con, pstmt, rs);
    }
    return JsonArray;
}
public JSONArray getRegistrationNo(int customerId,int systemId) {
    JSONArray JsonArray = null;
    JSONObject JsonObject = null;
    Connection con = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    try {
        JsonArray = new JSONArray();
        con = DBConnection.getConnectionToDB("AMS");
        pstmt = con.prepareStatement(SandMiningStatements.GET_REGISTRATION_NO);
        pstmt.setInt(1, systemId);
        //pstmt.setInt(2,customerId);
        rs = pstmt.executeQuery();
        while (rs.next()) {
            JsonObject = new JSONObject();
            JsonObject.put("REG_NO", rs.getString("REGISTRATION_NO"));
            JsonObject.put("REG_STATUS", rs.getString("REG_STATUS"));
            
            JsonArray.put(JsonObject);
        }
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        DBConnection.releaseConnectionToDB(con, pstmt, rs);
    }
    return JsonArray;
}
public ArrayList < Object > getSandBoatDetails(int systemId, int customerId){
	JSONArray JsonArray = new JSONArray();
	JSONObject JsonObject = null;
	Connection con = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	int slcount = 0;
	ReportHelper finalreporthelper = new ReportHelper();
	ArrayList < Object > finlist = new ArrayList < Object > ();
	ArrayList<ReportHelper> reportsList = new ArrayList<ReportHelper>();
	ArrayList<String> headersList = new ArrayList<String>();
	headersList.add("Sl No");
	headersList.add("ID");
	headersList.add("Registration No");
	headersList.add("Sand Block Name");
	headersList.add("Detention Time(Mins)");
	
	try {
		con = DBConnection.getConnectionToDB("AMS");
		pstmt = con.prepareStatement(SandMiningStatements.GET_SAND_BOAT_DETAILS);
		pstmt.setInt(1,systemId);
		pstmt.setInt(2,customerId);
		rs = pstmt.executeQuery();
		while (rs.next()) {
			ArrayList<Object> informationList = new ArrayList<Object>();
			ReportHelper reporthelper = new ReportHelper();
			JsonObject = new JSONObject();
			slcount++;
			JsonObject.put("slnoIndex", slcount);
			informationList.add(slcount);

			JsonObject.put("uidIndex", rs.getString("ID"));
			informationList.add(rs.getString("ID"));
			
			JsonObject.put("hubIdIndex", rs.getString("HUB_ID"));
			
			JsonObject.put("regNoIndex", rs.getString("REGISTRATION_NO"));
			informationList.add(rs.getString("REGISTRATION_NO"));
			
			JsonObject.put("sandBlockIndex", rs.getString("SAND_BLOCK"));
			informationList.add(rs.getString("SAND_BLOCK"));

			JsonObject.put("detentionTimeIndex", rs.getString("DETENTION_TIME"));
			informationList.add(rs.getString("DETENTION_TIME"));

			JsonArray.put(JsonObject);
			reporthelper.setInformationList(informationList);
		    reportsList.add(reporthelper);
		}
		finlist.add(JsonArray);
		finalreporthelper.setReportsList(reportsList);
		finalreporthelper.setHeadersList(headersList);
		finlist.add(finalreporthelper);

	} catch (Exception e) {
		e.printStackTrace();
	}finally {

		DBConnection.releaseConnectionToDB(con, pstmt, rs);
	}
	return finlist;
	}

public ArrayList<Object> getUnAuthEntryOrRedZoneDetails(int systemId,int customerId,String report,String startDate,String enddate) {
	JSONArray JsonArray = new JSONArray();
	JSONObject JsonObject = null;
	Connection con = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	int slcount = 0;
	ReportHelper finalreporthelper = new ReportHelper();
	ArrayList < Object > finlist = new ArrayList < Object > ();
	ArrayList<ReportHelper> reportsList = new ArrayList<ReportHelper>();
	ArrayList<String> headersList = new ArrayList<String>();
	
	headersList.add("SlNo");
	headersList.add("Vehicle NO");
	headersList.add("Authorized Sand Block");
	headersList.add("Un Authorized Sand Block");
	headersList.add("Red Zone");
	headersList.add("Arival Time");
	headersList.add("Departure Time");
	headersList.add("Detention Time");
		
	try{
		con = DBConnection.getConnectionToDB("AMS");
		if(report.equalsIgnoreCase("Red Zone Entry")){
			pstmt = con.prepareStatement(SandMiningStatements.GET_UNAUTH_ENTRY_OR_RED_ZONE_ENTRY.concat("and AUTH_SANPORT_ID=0"));
		}else{
			pstmt = con.prepareStatement(SandMiningStatements.GET_UNAUTH_ENTRY_OR_RED_ZONE_ENTRY);
		}
		
		pstmt.setInt(1, systemId);
		pstmt.setInt(2, customerId);
		pstmt.setString(3, startDate);
		pstmt.setString(4, enddate);
		rs=pstmt.executeQuery();
		while(rs.next())
		{
			ArrayList<Object> informationList = new ArrayList<Object>();
			ReportHelper reporthelper = new ReportHelper();
			JsonObject = new JSONObject();
			slcount++;
			JsonObject.put("slnoIndex", slcount);
			informationList.add(slcount);

			JsonObject.put("vehicleNoIndex", rs.getString("REGISTRATION_NO"));
			informationList.add(rs.getString("REGISTRATION_NO"));
			
			JsonObject.put("authSandBlockIndex", rs.getString("AUTH_SANDPORT"));
			informationList.add(rs.getString("AUTH_SANDPORT"));
			
			JsonObject.put("unAuthSandBlockIndex", rs.getString("UNAUTH_SANDPORT"));
			informationList.add(rs.getString("UNAUTH_SANDPORT"));
			
			JsonObject.put("redZoneIndex", rs.getString("REDZONE_ENTRY"));
			informationList.add(rs.getString("REDZONE_ENTRY"));

			JsonObject.put("arivalTimeIndex", sdfyyyymmddhhmmss.format(rs.getTimestamp("ACTUAL_ARRIVAL")));
			informationList.add(sdfyyyymmddhhmmss.format(rs.getTimestamp("ACTUAL_ARRIVAL")));
			
			JsonObject.put("departureTimeIndex", sdfyyyymmddhhmmss.format(rs.getTimestamp("ACTUAL_DEPARTURE")));
			informationList.add(sdfyyyymmddhhmmss.format(rs.getTimestamp("ACTUAL_DEPARTURE")));
			
			String hhmm=cf.convertMinutesToHHMMFormat(rs.getInt("DIFF_IN_MINS"));
			
			JsonObject.put("detentionTimeIndex", hhmm);
			informationList.add(hhmm);

			JsonArray.put(JsonObject);
			reporthelper.setInformationList(informationList);
		    reportsList.add(reporthelper);
		}
		finlist.add(JsonArray);
		finalreporthelper.setReportsList(reportsList);
		finalreporthelper.setHeadersList(headersList);
		finlist.add(finalreporthelper);
	}
	catch(Exception e){
		e.printStackTrace();
	}
	finally {
		DBConnection.releaseConnectionToDB(con, pstmt, rs);
	}
	return finlist;
}

//******************************************************************TP Owner ASSET ASSOCIATION****************************************************

public JSONArray getTpownerBasedOnCustomer(int systemId, int custId) {
    JSONArray JsonArray = null;
    JSONObject JsonObject = null;
    Connection con = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    try {
        JsonArray = new JSONArray();
        con = DBConnection.getConnectionToDB("AMS");
        pstmt = con.prepareStatement(SandMiningStatements.GET_TP_OWNER_DETAILS);
        pstmt.setInt(1, systemId);
        rs = pstmt.executeQuery();
        while (rs.next()) {
            JsonObject = new JSONObject();
            JsonObject.put("tpOwnerId", rs.getInt("TP_ID"));
            JsonObject.put("tpOwnerName", rs.getString("permitNoNew"));
            JsonArray.put(JsonObject);
        }
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        DBConnection.releaseConnectionToDB(con, pstmt, rs);
    }
    return JsonArray;
}		 
	

public JSONArray getHubBasedOnCustomer(int systemId, int custId) {
    JSONArray JsonArray = null;
    JSONObject JsonObject = null;
    Connection con = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    try {
        JsonArray = new JSONArray();
        con = DBConnection.getConnectionToDB("AMS");
        pstmt = con.prepareStatement(SandMiningStatements.GET_HUB_DETAILS);
        pstmt.setInt(1, systemId);
        pstmt.setInt(2, custId);
        rs = pstmt.executeQuery();
        while (rs.next()) {
            JsonObject = new JSONObject();
            JsonObject.put("hubOwnerId", rs.getInt("HUBID"));
            JsonObject.put("hubOwnerName", rs.getString("HUB_NAME"));
            JsonArray.put(JsonObject);
        }
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        DBConnection.releaseConnectionToDB(con, pstmt, rs);
    }
    System.out.println(JsonArray);
    return JsonArray;
}	







public JSONArray getRegDataForNonAssociation(int customerId, int systemId, int tpownerId, int userId) {
    JSONArray JsonArray = new JSONArray();
    JSONObject JsonObject = null;
    Connection con = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    try {
        int count = 0;
        con = DBConnection.getConnectionToDB("AMS");
            pstmt = con.prepareStatement(SandMiningStatements.GET_TP_NON_ASSOCIATION_DATA);
            pstmt.setInt(1, systemId);
            pstmt.setInt(2, customerId);
            pstmt.setInt(3, userId);
            pstmt.setInt(4, systemId);
            pstmt.setInt(5, customerId);
            //pstmt.setInt(6, tpownerId);
            rs = pstmt.executeQuery();
        while (rs.next()) {
            JsonObject = new JSONObject();
            count++;
            JsonObject.put("slnoIndex", count);
            JsonObject.put("registrationNoIndex1", rs.getString("REGISTRATION_NUMBER"));
            JsonArray.put(JsonObject);
        }
        //finlist.add(JsonArray);
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        DBConnection.releaseConnectionToDB(con, pstmt, rs);
    }
    return JsonArray;
}

public JSONArray getRegDataForAssociation(int systemId,int customerId, int contractorId) {
    JSONArray JsonArray = new JSONArray();
    JSONObject JsonObject = null;
    Connection con = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    try {
        int count = 0;
        con = DBConnection.getConnectionToDB("AMS");
            pstmt = con.prepareStatement(SandMiningStatements.GET_TP_ASSOCIATION_DATA);
            pstmt.setInt(1, systemId);
            pstmt.setInt(2, customerId);
            pstmt.setInt(3, contractorId);
            rs = pstmt.executeQuery();
        while (rs.next()) {
            JsonObject = new JSONObject();
            count++;
            JsonObject.put("slnoIndex2", count);
            JsonObject.put("registrationNoIndex2", rs.getString("REGISTRATION_NO"));
            JsonArray.put(JsonObject);
        }
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        DBConnection.releaseConnectionToDB(con, pstmt, rs);
    }
    return JsonArray;
}
public String associateTpVehicle(int customerId, int systemId, int tpownerId, JSONArray js,int userId, int parkingHubId, int loadingHubId) {
    Connection con = null;
    PreparedStatement pstmt = null;
    PreparedStatement pstmt1 = null;
    ResultSet rs1 = null;
    String message = "";
    ArrayList < String > vehicleList = new ArrayList < String > ();
    try {
        con = DBConnection.getConnectionToDB("AMS");
        for (int i = 0; i < js.length(); i++) {
            vehicleList.clear();
            JSONObject obj = js.getJSONObject(i);
            String vehicleNo = obj.getString("registrationNoIndex1");
            
            pstmt = con.prepareStatement(SandMiningStatements.CHECK_ASSET_NO_PRESENT);
            pstmt.setString(1, vehicleNo);
            pstmt.setInt(2, systemId);
            pstmt.setInt(3, customerId);
            rs1 = pstmt.executeQuery();
            if (!rs1.next()) {
                pstmt1 = con.prepareStatement(SandMiningStatements.INSERT_INTO_TP_OWNER_ASSET_ASSOCIATION);
                pstmt1.setInt(1, systemId);
                pstmt1.setInt(2, customerId);
                pstmt1.setInt(3, tpownerId);
                pstmt1.setString(4, vehicleNo);
                pstmt1.setInt(5, userId);
                pstmt1.setInt(6, parkingHubId);
                pstmt1.setInt(7, loadingHubId);
                pstmt1.executeUpdate();
            }else{
            	message = "vehicle "+rs1.getString("REGISTRATION_NO") +" aleredy associated to TP owner "+rs1.getString("Permit_NoNEW");
            	return message;
            }
        }
        message = "Associated Successfully.";
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        DBConnection.releaseConnectionToDB(con, pstmt1, null);
    }
    return message;
}
public String dissociateTpVehicle(int customerId, int systemId, int tpownerId, JSONArray js,int userId, int parkingHubId, int loadingHubId) {
    Connection con = null;
    PreparedStatement pstmt2 = null;
    PreparedStatement pstmt = null;
    PreparedStatement pstmt1=null;
    ResultSet rs = null;
    ResultSet rs1 = null;
    String message = "";
    ArrayList < String > vehicleList = new ArrayList < String > ();
    try {
        con = DBConnection.getConnectionToDB("AMS");
        for (int i = 0; i < js.length(); i++) {
            JSONObject obj = js.getJSONObject(i);
            vehicleList.clear();
            String vehicleNo = obj.getString("registrationNoIndex2");
            
            pstmt1=con.prepareStatement(SandMiningStatements.SELECT_DATA_FROM_TP_OWNER_ASSET_ASSOCIATION);
            pstmt1.setInt(1, tpownerId);
            pstmt1.setString(2, vehicleNo);
            rs1 = pstmt1.executeQuery();
            if (rs1.next()) {
            	
            pstmt = con.prepareStatement(SandMiningStatements.MOVE_DATA_TO_TP_OWNER_ASSET_DISASSOCIATION);
            pstmt.setInt(1, systemId);
            pstmt.setInt(2, customerId);
            pstmt.setInt(3, tpownerId);
            pstmt.setString(4, vehicleNo);
            pstmt.setInt(5, rs1.getInt("INSERTED_BY"));
            pstmt.setString(6, rs1.getString("INSERTED_DATETIME"));
            pstmt.setInt(7, userId);
            pstmt.setInt(8, rs1.getInt("PLANT_HUB_ID"));
            pstmt.setInt(9, rs1.getInt("LOADING_HUB_ID"));
            
            int inserted1 =pstmt.executeUpdate();
            if(inserted1 > 0)
            {
            pstmt2 = con.prepareStatement(SandMiningStatements.DELETE_FROM_TP_OWNER_ASSET_ASSOCIATION);
            pstmt2.setInt(1, tpownerId);
            pstmt2.setInt(2, customerId);
            pstmt2.setInt(3, systemId);
            pstmt2.setString(4, vehicleNo);
            pstmt2.executeUpdate();
            }
            }
        }
        message = "Disassociated Successfully.";
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        DBConnection.releaseConnectionToDB(null, pstmt2, null);
        DBConnection.releaseConnectionToDB(null, pstmt, null);
        DBConnection.releaseConnectionToDB(con, pstmt1, rs1);
    }
    return message;
}

public ArrayList < Object > getTPOwnerAssetDetails(int systemId,int customerId)
{ 
	JSONArray JsonArray = null;
	JSONObject obj = null;
	Connection con = null;
	PreparedStatement pstmt = null;
	int count=0;
	ResultSet rs = null;
	
	ArrayList < Object > finlist = new ArrayList < Object > ();
	ArrayList headersList = new ArrayList();
	ArrayList reportsList = new ArrayList();
	ReportHelper finalreporthelper = new ReportHelper();
	int lastCommHrs=0;
	String commStatus="";
	
	try {
		headersList.add("SLNO");
		headersList.add("TP ID");
	    headersList.add("TP Owner");
	    headersList.add("Vehicle No");
	    headersList.add("Location");
	    headersList.add("Communication Status");
	    headersList.add("TP owner status");  
		
		JsonArray=new JSONArray();	
		con = DBConnection.getConnectionToDB("AMS");
		pstmt=con.prepareStatement(SandMiningStatements.GET_TP_OWNER_ASSET_DETAILS);
		pstmt.setInt(1, systemId);
		pstmt.setInt(2, customerId);
		rs=pstmt.executeQuery();
		while(rs.next())
		{
			count++;
			obj=new JSONObject();
			ArrayList informationList = new ArrayList();
			ReportHelper reporthelper = new ReportHelper();
			
			obj.put("slnoIndex", count);
			informationList.add(count);
			
			obj.put("tpownerIDindex", rs.getString("TP_ID"));
			informationList.add(rs.getString("TP_ID"));
			
			obj.put("tpownerindex", rs.getString("Permit_NoNEW"));
			informationList.add(rs.getString("Permit_NoNEW"));
			
			obj.put("vehiclenoindex", rs.getString("REGISTRATION_NO"));
			informationList.add(rs.getString("REGISTRATION_NO"));
			
			obj.put("locationindex", rs.getString("LOCATION"));
			informationList.add(rs.getString("LOCATION"));
			
			lastCommHrs=rs.getInt("hours");
			if(lastCommHrs <= 48 && !rs.getString("LOCATION").equalsIgnoreCase("No GPS Device Connected")){
				commStatus = "Communicating";	
			}else{
				commStatus = "Non-Communicating ";	
			}
			
			obj.put("communicationindex", commStatus);
			informationList.add(commStatus);
			
			obj.put("tpstatusindex", rs.getString("MDP_ISSUING_STATUS"));
			informationList.add(rs.getString("MDP_ISSUING_STATUS"));
			
			
			JsonArray.put(obj);
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
	}
	return finlist;
	}

public String activeOrInactiveTPOwnerStarus(int tpId, int clientId, int systemId, String status) {
	Connection con = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	String message = "";
	JSONArray jsonArray = null;
	int inserted = 0;
	
	try {
		con = DBConnection.getConnectionToDB("AMS");
		
		pstmt = con.prepareStatement(SandMiningStatements.UPDATE_TP_MASTER_STATUS);
		pstmt.setString(1, status);
		pstmt.setInt(2, tpId);
		pstmt.setInt(3, systemId);

		inserted = pstmt.executeUpdate();
		if (inserted > 0) {
			message = "Updated Successfully";
		}else{
			message = "Error";
		}
	}catch (Exception e) {
		e.printStackTrace();
		message = "error";
	}  finally {
		DBConnection.releaseConnectionToDB(con, pstmt, rs);
	}
	return message;
}

public JSONArray getMiningTimes(int customerId,int systemId) {
    JSONArray JsonArray = null;
    JSONObject JsonObject = null;
    Connection con = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    CommonFunctions cf= new CommonFunctions();
    try {
        JsonArray = new JSONArray();
        con = DBConnection.getConnectionToDB("AMS");
        pstmt = con.prepareStatement(SandMiningStatements.GET_MDP_TIMENGS);
        pstmt.setInt(1,systemId);
        pstmt.setInt(2,customerId);
        rs = pstmt.executeQuery();
        int startHrs=0;
        int startMnt=0;
        int endHrs=0;
        int endMnt=0;
        int brStartHrs=0;
        int brStartMnt=0;
        int nonCommunicatingHrs=0;
        int nonCommunicatingMnt=0;
        boolean nonCommunicationCheck=false;
        boolean blockedVehicleCheck=false;
        boolean insideHubCheck=false;
        String quantityMeasure="";
        float bufferDistance=0;
        String vehGroupId="";
        float MDPbufferDistance=0;
        String paymentDuration = ""; 
        String[] payment = {"00","00","00"};
       
        if (rs.next()) {
            String sTime=rs.getString("START_TIME");
            if(sTime!=null && !sTime.equals("")){
            	String []arr=sTime.split(":");
            	startHrs=Integer.parseInt(arr[0]);
            	startMnt=Integer.parseInt(arr[1]);
            }
            String eTime=rs.getString("END_TIME");
            if(eTime!=null && !eTime.equals("")){
            	String []arr=eTime.split(":");
            	endHrs=Integer.parseInt(arr[0]);
            	endMnt=Integer.parseInt(arr[1]);
            }
            String brSTime=rs.getString("VALID_TIME");
            if(brSTime!=null && !brSTime.equals("")){
            	String []arr=brSTime.split(":");
            	brStartHrs=Integer.parseInt(arr[0]);
            	brStartMnt=Integer.parseInt(arr[1]);
            }
            String nonCommunicatingTime=cf.convertMinutesToHHMMFormat(Integer.parseInt(rs.getString("NON_COMMUNICATING_HOURS")));
            if(nonCommunicatingTime!=null && !nonCommunicatingTime.equals("")){
            	String []arr=nonCommunicatingTime.split(":");
            	nonCommunicatingHrs=Integer.parseInt(arr[0]);
            	nonCommunicatingMnt=Integer.parseInt(arr[1]);
            }
            
           String blockedVehicle=rs.getString("BLOCKED_VEHICLE");
           blockedVehicleCheck=blockedVehicle.equalsIgnoreCase("Y")?true : false;
           
           String nonCommunicationchk=rs.getString("NON_COMMUNICATING_CHECK");
           nonCommunicationCheck=nonCommunicationchk.equalsIgnoreCase("Y")?true : false;
           
           String insideHub=rs.getString("INSIDE_HUB");
           insideHubCheck=insideHub.equalsIgnoreCase("Y")?true : false;
           
           quantityMeasure=rs.getString("QUANTITY_MEASURE");
           
           bufferDistance=rs.getFloat("BUFFER_DISTANCE");
           
           vehGroupId=rs.getString("GROUP_NAME");
           
           MDPbufferDistance=rs.getFloat("MDP_BUFFER_DISTANCE");
           payment = null;
           paymentDuration = rs.getInt("PAYMENT_DURATION") == 0 ? "00:00:00" : cf.formattedDaysHoursMinutes(rs.getInt("PAYMENT_DURATION") * 60000);
           payment = paymentDuration.split(":");
        }
        JsonObject = new JSONObject();
        JsonObject.put("startHrsInx", startHrs);
        JsonObject.put("startMntInx", startMnt);
        JsonObject.put("endHrsInx", endHrs);
        JsonObject.put("endMntInx", endMnt);
        JsonObject.put("brStartHrsInx", brStartHrs);
        JsonObject.put("brStartMntInx", brStartMnt);
        JsonObject.put("nonCommunicatingHrsInx", nonCommunicatingHrs == 0? "00" : nonCommunicatingHrs);
        JsonObject.put("nonCommunicatingMntInx", nonCommunicatingMnt == 0?"00" : nonCommunicatingMnt );
        JsonObject.put("blockedVehicleInx", blockedVehicleCheck);
        JsonObject.put("nonCommunicatingInx", nonCommunicationCheck);
        JsonObject.put("insideHubInx", insideHubCheck);
        JsonObject.put("quantityMeasureInx", quantityMeasure);
        JsonObject.put("bufferDistanceInx", bufferDistance);
        JsonObject.put("vehGroupInx", vehGroupId);
        JsonObject.put("MDPbufferDistanceInx", MDPbufferDistance);
        
        JsonObject.put("paymentDaysIndex", payment[0]);
        JsonObject.put("paymentHoursIndex", payment[1]);
        JsonObject.put("paymentMinutesIndex", payment[2]);
        
        JsonArray.put(JsonObject);
        
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        DBConnection.releaseConnectionToDB(con, pstmt, rs);
    }
    return JsonArray;
}
public String saveUserSettings(int systemId,String MDPLimit,String TalukName,String custId){
	Connection con = null;
	PreparedStatement pstmt= null;
	ResultSet rs= null;
	String message="";
	CommonFunctions cf = new CommonFunctions();
	try
	{
		con = DBConnection.getConnectionToDB("AMS");
		pstmt = con.prepareStatement(SandMiningStatements.IF_MDP_LIMIT_EXISTS);
        pstmt.setInt(1,systemId);
        pstmt.setString(2,custId);
        pstmt.setString(3,TalukName);
        rs = pstmt.executeQuery();
        if(rs.next()){
        	//Update
        	pstmt = con.prepareStatement(SandMiningStatements.UPDATE_MDP_USERSETTINGS);
        	pstmt.setString(1, MDPLimit);
        	pstmt.setInt(2,systemId);
            pstmt.setString(3,custId);
            pstmt.setString(4,TalukName);
	        int updated= pstmt.executeUpdate();
	        message = updated>0?"Updated Successfully":"Error in Updation";
        }else{
        	//Insert
        	pstmt = con.prepareStatement(SandMiningStatements.INSERT_MDP_SETTINGS);
        	pstmt.setString(1, TalukName);
        	pstmt.setInt(2, systemId);
        	pstmt.setString(3, custId);
        	pstmt.setString(4, MDPLimit);
	        int inserted= pstmt.executeUpdate();
	        message = inserted>0?"New Record Inserted Successfully":"Error in Insertion";
		
	}
	}
	 catch (Exception e)
	 {
			e.printStackTrace();
	 }      
	finally {
		DBConnection.releaseConnectionToDB(con, pstmt, rs);
    }
	return message;
}
public String saveMiningTimes(int systemId,int custId,String startTime,String endTime,String brStartTime ,String blockedVehicles, String nonCommunicatingId,
		String nonCommunicationTime ,String insideHub , String quantityMeasureId,String bufferDistance,String vehGroup,String MDPbufferDistance,int totalLoadingCapacityType1Vehicle,int totalLoadingCapacityType2Vehicle,int totalLoadingCapacityType3Vehicle,int totalMDPCountType1Vehicle,int totalMDPCountType2Vehicle,int totalMDPCountType3Vehicle,String stockYards,
		String paymentDurationString){
	Connection con = null;
	PreparedStatement pstmt = null,pstmtCheck=null,pstmtUpdate=null,pstmtInsert=null;
	ResultSet rs= null;
	String message="";
	CommonFunctions cf = new CommonFunctions();
	int paymentDuration = 0;
	try
	{
		paymentDuration = cf.convertDDHHMMToMinutes(paymentDurationString);
		 
		con = DBConnection.getConnectionToDB("AMS");
		String[] stockyardList = stockYards.split(",");
		int inserted=0,inserted1=0,updated=0,updated1=0;
		pstmt = con.prepareStatement(SandMiningStatements.GET_MDP_TIMENGS);
        pstmt.setInt(1,systemId);
        pstmt.setInt(2,custId);
        rs = pstmt.executeQuery();
        if(rs.next()){
        	//Update
        	pstmt = con.prepareStatement(SandMiningStatements.UPDATE_MDP_TIMENGS);
        	pstmt.setString(1, startTime);
        	pstmt.setString(2, endTime);
        	pstmt.setString(3, brStartTime);
        	pstmt.setString(4,blockedVehicles);
        	pstmt.setString(5,nonCommunicatingId);
        	pstmt.setInt(6,cf.convertHHMMToMinutes1(nonCommunicationTime));
        	pstmt.setString(7,insideHub);
	        pstmt.setString(8,quantityMeasureId);
	        pstmt.setString(9,bufferDistance);
	        pstmt.setString(10,vehGroup);
	        pstmt.setString(11,MDPbufferDistance);
	       // pstmt.setDouble(12, totalLoadingCapacity);
	       // pstmt.setInt(13, totalMDPCount);
	        pstmt.setInt(12,paymentDuration);
	        pstmt.setInt(13,systemId);
	        pstmt.setInt(14,custId);
	       
	        updated= pstmt.executeUpdate();
	        //message = updated>0?"Updated Successfully":"Error in Updation";
        }else{
        	//Insert
        	pstmt = con.prepareStatement(SandMiningStatements.INSERT_MDP_TIMES);
        	pstmt.setString(1, startTime);
        	pstmt.setString(2, endTime);
        	pstmt.setString(3, brStartTime);
        	pstmt.setString(4,blockedVehicles);
        	pstmt.setString(5,nonCommunicatingId);
        	pstmt.setInt(6,cf.convertHHMMToMinutes1(nonCommunicationTime));
        	pstmt.setString(7,insideHub);
	        pstmt.setString(8,quantityMeasureId);
	        pstmt.setString(9,bufferDistance);
	        pstmt.setString(10,vehGroup);
	        pstmt.setString(11,MDPbufferDistance);
	       // pstmt.setDouble(12, totalLoadingCapacity);
	       // pstmt.setInt(13, totalMDPCount);
	        pstmt.setInt(12,systemId);
	        pstmt.setInt(13,custId);
	        pstmt.setInt(14,paymentDuration);
	        inserted= pstmt.executeUpdate();
	        //message = inserted>0?"New Record Inserted Successfully":"Error in Insertion";
        }
        if(totalLoadingCapacityType1Vehicle != 0 || totalMDPCountType1Vehicle != 0  || totalLoadingCapacityType2Vehicle != 0 || totalMDPCountType2Vehicle != 0  || totalLoadingCapacityType3Vehicle != 0 || totalMDPCountType3Vehicle != 0  || stockyardList.toString().isEmpty()){
        	for (String stockYard : stockyardList) {
    			pstmtCheck = con.prepareStatement(SandMiningStatements.GET_STOCKYARD_DETAILS_CHECK);
    			pstmtCheck.setInt(1, systemId);
    			pstmtCheck.setInt(2, custId);
    			pstmtCheck.setString(3, stockYard);
    			rs = pstmtCheck.executeQuery();
    			if (rs.next()) {
    				pstmtUpdate = con.prepareStatement(SandMiningStatements.UPDATE_MDP_STOCKYARD_DETAILS);
    				pstmtUpdate.setInt(1, totalLoadingCapacityType1Vehicle);
    				pstmtUpdate.setInt(2, totalMDPCountType1Vehicle);
    				pstmtUpdate.setInt(3, totalLoadingCapacityType2Vehicle);
    				pstmtUpdate.setInt(4, totalMDPCountType2Vehicle);
    				pstmtUpdate.setInt(5, totalLoadingCapacityType3Vehicle);
    				pstmtUpdate.setInt(6, totalMDPCountType3Vehicle);
    				pstmtUpdate.setString(7, stockYard);
    				pstmtUpdate.setInt(8, systemId);
    				pstmtUpdate.setInt(9, custId);
    				updated1= pstmtUpdate.executeUpdate();
    		
    			} else {
    				pstmtInsert = con.prepareStatement(SandMiningStatements.INSERT_MDP_STOCKYARD_DETAILS);
    				pstmtInsert.setInt(1, Integer.parseInt(stockYard));
    				pstmtInsert.setInt(2, totalLoadingCapacityType1Vehicle);
    				pstmtInsert.setInt(3, totalMDPCountType1Vehicle);
    				pstmtInsert.setInt(4, totalLoadingCapacityType2Vehicle);
    				pstmtInsert.setInt(5, totalMDPCountType2Vehicle);
    				pstmtInsert.setInt(6, totalLoadingCapacityType3Vehicle);
    				pstmtInsert.setInt(7, totalMDPCountType3Vehicle);
    				pstmtInsert.setInt(8, systemId);
    				pstmtInsert.setInt(9, custId);
    				inserted1= pstmtInsert.executeUpdate();
    				
    			}
    		}
        }
        else{
        	inserted1 = 1;
        	updated1 = 1;
        }
        if(inserted>0 && inserted1>0){
			message = "New Record Inserted Successfully";
		}
		else if(updated>0 && updated1>0){
			message="Updated Successfully";
		}
		else{
			message= "Error while Inserting or Updating";
		}
		
	}
	 catch (Exception e)
	 {
			e.printStackTrace();
	 }      
	finally {
		DBConnection.releaseConnectionToDB(con, pstmt, rs);
		DBConnection.releaseConnectionToDB(null, pstmtCheck, null);
		DBConnection.releaseConnectionToDB(null, pstmtUpdate, null);
		DBConnection.releaseConnectionToDB(null, pstmtInsert, null);

    }
	return message;
}
public JSONArray getTPownerName(int systemId, int clientId) {
	JSONArray jsonArray = new JSONArray();
	JSONObject jsonObject = new JSONObject();
	Connection con = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;

	try {
		con = DBConnection.getConnectionToDB("AMS");
		jsonArray = new JSONArray();
		jsonObject = new JSONObject();

		pstmt = con
				.prepareStatement(SandMiningStatements.GET_TP_OWNER_NAME);
		pstmt.setInt(1, systemId);

		rs = pstmt.executeQuery();

		while (rs.next()) {
			jsonObject = new JSONObject();
			jsonObject.put("tpId", rs.getString("TP_ID"));
			jsonObject.put("tpName", rs.getString("Permit_NoNEW"));
			jsonArray.put(jsonObject);

		}

	} // end of try

	catch (Exception e) {

		e.printStackTrace();
	} finally {
		DBConnection.releaseConnectionToDB(con, pstmt, rs);
	}

	return jsonArray;

}

public ArrayList < Object > getSandExcavationReport(int systemId, int customerId,String startDate,String endDate,int offset,int tpId) {
    JSONArray JsonArray = new JSONArray();
    JSONObject JsonObject = null;
    Connection con = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
   
    ArrayList < Object > finlist = new ArrayList < Object > ();
    try {
    	int count = 0;
        con = DBConnection.getConnectionToDB("AMS");
        if(tpId == 0){
        	 pstmt = con.prepareStatement(SandMiningStatements.GET_SAND_EXCAVATION_REPORT.replace("and TP=?", ""));
            pstmt.setInt(1, systemId);
     		pstmt.setInt(2, customerId);
     		pstmt.setInt(3, offset);
     		pstmt.setString(4, startDate);
     		pstmt.setInt(5, offset);
     		pstmt.setString(6, endDate);
        }else{
        pstmt = con.prepareStatement(SandMiningStatements.GET_SAND_EXCAVATION_REPORT);
        pstmt.setInt(1, systemId);
		pstmt.setInt(2, customerId);
		pstmt.setInt(3, tpId);
		pstmt.setInt(4, offset);
		pstmt.setString(5, startDate);
		pstmt.setInt(6, offset);
		pstmt.setString(7, endDate);
        }
        rs = pstmt.executeQuery();
        
        SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm");
        
		
        while (rs.next()) {
            JsonObject = new JSONObject();
            count++;
           
            JsonObject.put("slnoIndex", count);
            
            JsonObject.put("tpOwnerIndex", rs.getString("Permit_NoNEW"));
            
            JsonObject.put("boatNumberIndex",rs.getString("ASSET_NUMBER"));	           
            
            JsonObject.put("noOfTripsIndex",rs.getString("tripCount"));
            
            double quantityExcavated = (rs.getDouble("QTY"));
            
            JsonObject.put("quantityExcavatedIndex",quantityExcavated);
            
            JsonObject.put("statusDataIndex", rs.getString("STATUS"));
            
            JsonArray.put(JsonObject);
            
        }
       
        finlist.add(JsonArray);
        
      
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        DBConnection.releaseConnectionToDB(con, pstmt, rs);
    }
    return finlist;
}

public ArrayList<Object> getSandBoatReconciliationReport(
		int systemId, int customerId, String startDate, String endDate,
		int offset, int tpId, String tpName) {
	JSONArray JsonArray = new JSONArray();
	JSONObject JsonObject = null;
	Connection con = null;
	PreparedStatement pstmt = null;

	ResultSet rs = null;

	ArrayList<Object> finlist = new ArrayList<Object>();
	try {
		int count = 0;
		con = DBConnection.getConnectionToDB("AMS");
		pstmt = con
				.prepareStatement(SandMiningStatements.SAND_BOAT_RECONSILATION_REPORT);

		pstmt.setInt(1, systemId);
		pstmt.setString(2, tpName);
		pstmt.setInt(3, offset);
		pstmt.setString(4, startDate);
		pstmt.setInt(5, offset);
		pstmt.setString(6, endDate);
		pstmt.setInt(7, systemId);
		pstmt.setInt(8, tpId);
		pstmt.setInt(9, offset);
		pstmt.setString(10, startDate);
		pstmt.setInt(11, offset);
		pstmt.setString(12, endDate);

		rs = pstmt.executeQuery();

		while (rs.next()) {
			JsonObject = new JSONObject();
			count++;

			String activityCount = rs.getString("activityCount");
			if (activityCount != null) {
			} else {
				activityCount = "0";
			}
			String totalQuantity = rs.getString("totalQuantity");
			if (totalQuantity != null) {
			} else {
				totalQuantity = "0";
			}

			String tripCount = rs.getString("tripCount");
			if (tripCount != null) {
			} else {
				tripCount = "0";
			}

			String qty = rs.getString("QTY");
			if (qty != null) {
			} else {
				qty = "0";
			}

			JsonObject.put("slnoIndex", count);

			JsonObject.put("numberOfMDPIndex", activityCount);

			JsonObject.put("quantityAsPerMDPIndex", totalQuantity);

			JsonObject.put("numberOfTripsIndex", tripCount);

			JsonObject.put("quantityAsPerNoOfTripsIndex", qty);

			JsonArray.put(JsonObject);

		}

		finlist.add(JsonArray);

	} catch (Exception e) {
		e.printStackTrace();
	} finally {
		DBConnection.releaseConnectionToDB(con, pstmt, rs);

	}
	return finlist;
}
public String regenerateOTP(String applicationNo, int clientId, int systemId,String mobileNo ) {
	Connection con = null;
	PreparedStatement pstmt = null;
	PreparedStatement pstmt1 = null;
	ResultSet rs = null;
	String message = "";
	JSONArray jsonArray = null;
	int inserted = 0;
	
	try {
		con = DBConnection.getConnectionToDB("AMS");
		
		Integer otp = (int)((Math.random() * 900000000)+100000000);
        String otp2 = otp.toString().substring(0,6);
        System.out.println(otp2);
		pstmt = con.prepareStatement(SandMiningStatements.REGENERATE_OTP);
		pstmt.setString(1, otp2);
		pstmt.setString(2, applicationNo);
		pstmt.setInt(3, systemId);
		pstmt.setInt(4, clientId);
		inserted = pstmt.executeUpdate();
		if (inserted > 0) {
			String Sms="SAND:OTP for Sand Application Enrolment is:"+otp2+". Do not share it with anyone ";
	        pstmt1 = con.prepareStatement(SandMiningStatements.UPDATE_SMS);
	        pstmt1.setString(1, mobileNo);
	        pstmt1.setString(2, Sms);
	        pstmt1.setString(3, "N");
	        pstmt1.setInt(4, clientId);
	        pstmt1.setInt(5, systemId);
	        int insert=pstmt1.executeUpdate();
	        //int insert = 1;
	        if (insert > 0) {
				message = "Updated & OTP Sent successfully";
			}else {
				message = "Updated & Error in sending OTP,";
			}
		}else{
			message = "Error";
		}
	}catch (Exception e) {
		e.printStackTrace();
		message = "error";
	}  finally {
		DBConnection.releaseConnectionToDB(con, pstmt, rs);
		DBConnection.releaseConnectionToDB(null, pstmt1, null);
	}
	return message;
}
public String verifyOTP(String applicationNo, int clientId, int systemId,String mobileNo,String otp,int userId ) {
	Connection con = null;
	PreparedStatement pstmt = null;
	PreparedStatement pstmt1 = null;
	ResultSet rs = null;
	String message = "";
	JSONArray jsonArray = null;
	int inserted = 0;
	String value = "";
	String sandConsumerName = "";
	double estimatedSandRequirement=0;
	double approvedSandQty=0; 
	String tpNo="";
	String stockyard="";
	String consumerType="";
	try {
		con = DBConnection.getConnectionToDB("AMS");
		
		pstmt = con.prepareStatement(SandMiningStatements.VERIFY_OTP);
		pstmt.setString(1, applicationNo);
		pstmt.setInt(2, systemId);
		pstmt.setInt(3, clientId);
		pstmt.setString(4, otp);
		rs = pstmt.executeQuery();
		
		if (rs.next()) {
			value = rs.getString("CONSUMER_APPLICATION_NO");
			sandConsumerName = rs.getString("SAND_CONSUMER_NAME");
			estimatedSandRequirement = rs.getDouble("ESTIMATED_SAND_REQUIREMENT");
			approvedSandQty = rs.getDouble("APPROVED_SAND_QUNATITY");
			tpNo  = rs.getString("TP_NO");
			stockyard = rs.getString("STOCKYARD");
			consumerType = rs.getString("CONSUMER_TYPE");
			
			pstmt = con.prepareStatement(SandMiningStatements.UPDATE_CONSUMER_ENROLMENT_STATUS);
			pstmt.setInt(1, userId);
			pstmt.setString(2, applicationNo);
			pstmt.setInt(3, systemId);
			pstmt.setInt(4, clientId);
			inserted = pstmt.executeUpdate();
			if (inserted > 0) {
			String Sms="SAND:Your Application Successfully Enrolled and Approved \nAPP No:"+value+", Name: "+sandConsumerName +", Requested Qty: "+estimatedSandRequirement +",Approved Qty: "+approvedSandQty+"\n"+"District Sand Committee ";
	        pstmt1 = con.prepareStatement(SandMiningStatements.UPDATE_SMS);
	        pstmt1.setString(1, mobileNo);
	        pstmt1.setString(2, Sms);
	        pstmt1.setString(3, "N");
	        pstmt1.setInt(4, clientId);
	        pstmt1.setInt(5, systemId);
	        int insert=pstmt1.executeUpdate();
	        //int insert = 1;
	        if (insert > 0) {
				message = "OTP Verified & SMS Sent successfully";
			}else {
				message = "OTP Verified & Error in sending SMS,";
			}
		  }else{
			  message = "Error While Updating!!!";
		  }
		}else{
			message = "Invalid OTP !!!";
		}
	}catch (Exception e) {
		e.printStackTrace();
		message = "error";
	}  finally {
		DBConnection.releaseConnectionToDB(con, pstmt, rs);
		DBConnection.releaseConnectionToDB(null, pstmt1, null);
	}
	return message;
}
public String sendOTPMessage(String mobileNo, int customerId, int systemId,String value,String otp,Connection con ) {
	PreparedStatement pstmt = null;
	String message = "";
	try {
	 String Sms="SAND:OTP for Sand Consumer Application NO: "+value+" is:"+otp+". Do not share it with anyone ";
	 pstmt = con.prepareStatement(SandMiningStatements.UPDATE_SMS);
	 pstmt.setString(1, mobileNo);
	 pstmt.setString(2, Sms);
	 pstmt.setString(3, "N");
	 pstmt.setInt(4, customerId);
	 pstmt.setInt(5, systemId);
     int insert=pstmt.executeUpdate();
     //int insert = 1;
     if (insert > 0) {
			message = "Saved & OTP Sent successfully,";
		}else {
			message = "Saved & Error in sending OTP,";
		}
	}catch (Exception e) {
		e.printStackTrace();
		message = "error";
	}  finally {
		DBConnection.releaseConnectionToDB(null, pstmt, null);
	}
	return message;
}
public boolean Quantity_Measure(int systemId) {
	PreparedStatement pstmt=null;
	ResultSet rs=null;
	Connection con = null;
	boolean QUANTITY_MEASURE = false;
	String message = null;
	try {
		 con = DBConnection.getConnectionToDB("AMS");
		pstmt = con
				.prepareStatement(" select value from General_Settings where name='QUANTITY_MEASURE' and System_Id=?");
		pstmt.setInt(1, systemId);
		rs = pstmt.executeQuery();
		if (rs.next()) {
			String Quantity = rs.getString("value");
			if (Quantity.equalsIgnoreCase("TONS")) {
				QUANTITY_MEASURE = true;
			}
		}

	} catch (Exception e) {
		e.printStackTrace();
	} finally {
		//releaseConnection(con, pstmt, rs);
		DBConnection.releaseConnectionToDB(con, pstmt, rs);
	}
	return QUANTITY_MEASURE;
}
public JSONArray getGroupName(int systemId, int clientId) {
	JSONArray jsonArray = new JSONArray();
	JSONObject jsonObject = new JSONObject();
	Connection con = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;

	try {
		con = DBConnection.getConnectionToDB("AMS");
		jsonArray = new JSONArray();
		jsonObject = new JSONObject();
		pstmt = con.prepareStatement(SandMiningStatements.GET_GROUP_ID);
		pstmt.setInt(1, systemId);
		pstmt.setInt(2, clientId);
		rs = pstmt.executeQuery();
		jsonObject = new JSONObject();
		jsonObject.put("groupId",0);
		jsonObject.put("groupName","None");
		jsonArray.put(jsonObject);
		while (rs.next()) {
			jsonObject = new JSONObject();
			jsonObject.put("groupId", rs.getString("GROUP_ID"));
			jsonObject.put("groupName", rs.getString("GROUP_NAME"));
			jsonArray.put(jsonObject);
		}
	} // end of try
	catch (Exception e) {
		e.printStackTrace();
	} finally {
		DBConnection.releaseConnectionToDB(con, pstmt, rs);
	}
	return jsonArray;
}

//******************** hub group associtation ***************//

public JSONArray getGrouNameBasedOnCustomer(int systemId, int custId) {
    JSONArray JsonArray = null;
    JSONObject JsonObject = null;
    Connection con = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    try {
        JsonArray = new JSONArray();
        con = DBConnection.getConnectionToDB("AMS");
        pstmt = con.prepareStatement(SandMiningStatements.GET_GROUP_DETAILS);
        pstmt.setInt(1, systemId);
        pstmt.setInt(2, custId);
        rs = pstmt.executeQuery();
        while (rs.next()) {
            JsonObject = new JSONObject();
            JsonObject.put("groupId", rs.getInt("GROUP_ID"));
            JsonObject.put("groupName", rs.getString("GROUP_NAME"));
            JsonArray.put(JsonObject);
        }
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        DBConnection.releaseConnectionToDB(con, pstmt, rs);
    }
    return JsonArray;
}

public JSONArray getHubNameForNonAssociation(int customerId, int systemId, int groupId, int userId) {
    JSONArray JsonArray = new JSONArray();
    JSONObject JsonObject = null;
    Connection con = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    try {
        int count = 0;
        con = DBConnection.getConnectionToDB("AMS");
            pstmt = con.prepareStatement(SandMiningStatements.GET_NON_ASSOCIATED_HUB_DETAILS);
            pstmt.setInt(1, systemId);
            pstmt.setInt(2, customerId);
            pstmt.setInt(3, systemId);
            pstmt.setInt(4, customerId);
            rs = pstmt.executeQuery();
        while (rs.next()) {
            JsonObject = new JSONObject();
            count++;
            JsonObject.put("slnoIndex", count);
            JsonObject.put("hubIdIndex1", rs.getString("HUBID"));
            JsonObject.put("hubNameIndex1", rs.getString("HUB_NAME"));
            JsonArray.put(JsonObject);
        }
        //finlist.add(JsonArray);
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        DBConnection.releaseConnectionToDB(con, pstmt, rs);
    }
    return JsonArray;
}

public JSONArray getHubNameForAssociation(int systemId,int customerId, int groupId) {
    JSONArray JsonArray = new JSONArray();
    JSONObject JsonObject = null;
    Connection con = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    try {
        int count = 0;
        con = DBConnection.getConnectionToDB("AMS");
            pstmt = con.prepareStatement(SandMiningStatements.GET_ASSOCIATED_HUB_DETAILS);
            pstmt.setInt(1, systemId);
            pstmt.setInt(2, customerId);
            pstmt.setInt(3, groupId);
            rs = pstmt.executeQuery();
        while (rs.next()) {
            JsonObject = new JSONObject();
            count++;
            JsonObject.put("slnoIndex2", count);
            JsonObject.put("hubIdIndex2", rs.getString("HUB_ID"));
            JsonObject.put("hubNameIndex2", rs.getString("NAME"));
            JsonArray.put(JsonObject);
        }
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        DBConnection.releaseConnectionToDB(con, pstmt, rs);
    }
    return JsonArray;
}
public String associateHubName(int customerId, int systemId, int groupId, JSONArray js,int userId) {
    Connection con = null;
    PreparedStatement pstmt = null;
    PreparedStatement pstmt1 = null;
    ResultSet rs1 = null;
    String message = "";
    ArrayList < String > vehicleList = new ArrayList < String > ();
    try {
        con = DBConnection.getConnectionToDB("AMS");
        for (int i = 0; i < js.length(); i++) {
            vehicleList.clear();
            JSONObject obj = js.getJSONObject(i);
            String hubId = obj.getString("hubIdIndex1");
            
            pstmt = con.prepareStatement(SandMiningStatements.CHECK_HUB_NAME_PRESENT);
            pstmt.setString(1, hubId);
            pstmt.setInt(2, systemId);
            pstmt.setInt(3, customerId);
            rs1 = pstmt.executeQuery();
            if (!rs1.next()) {
                pstmt1 = con.prepareStatement(SandMiningStatements.INSERRT_HUB_GROUP_ASSOCIATION);
                pstmt1.setInt(1, groupId);
                pstmt1.setString(2, hubId);
                pstmt1.setInt(3, systemId);
                pstmt1.setInt(4, customerId);
                pstmt1.setInt(5, userId);
                pstmt1.executeUpdate();
            }else{
            	message = "Hub Name "+rs1.getString("HUB_NAME") +" aleredy associated to group name "+rs1.getString("GROUP_NAME");
            	return message;
            }
        }
        message = "Associated Successfully.";
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        DBConnection.releaseConnectionToDB(con, pstmt, rs1);
        DBConnection.releaseConnectionToDB(null, pstmt1, null);
    }
    return message;
}
public String dissociateHubFromGroup(int customerId, int systemId, int groupId, JSONArray js,int userId) {
    Connection con = null;
    PreparedStatement pstmt2 = null;
    PreparedStatement pstmt = null;
    PreparedStatement pstmt1=null;
    ResultSet rs = null;
    ResultSet rs1 = null;
    String message = "";
    ArrayList < String > vehicleList = new ArrayList < String > ();
    try {
        con = DBConnection.getConnectionToDB("AMS");
        for (int i = 0; i < js.length(); i++) {
            JSONObject obj = js.getJSONObject(i);
            vehicleList.clear();
            String hubId = obj.getString("hubIdIndex2");
            
            pstmt1=con.prepareStatement(SandMiningStatements.SELECT_DATA_FROM_HUB_GROUP_ASSOCIATION);
            pstmt1.setInt(1, groupId);
            pstmt1.setString(2, hubId);
            pstmt1.setInt(3, systemId);
            pstmt1.setInt(4, customerId);
            rs1 = pstmt1.executeQuery();
            if (rs1.next()) {
            	
            pstmt2 = con.prepareStatement(SandMiningStatements.DELETE_FROM_HUB_GROUP_ASSOCIATION);
            pstmt2.setInt(1, groupId);
            pstmt2.setString(2, hubId);
            pstmt2.setInt(3, systemId);
            pstmt2.setInt(4, customerId);
            pstmt2.executeUpdate();
       
            }
        }
        message = "Disassociated Successfully.";
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        DBConnection.releaseConnectionToDB(null, pstmt2, null);
        DBConnection.releaseConnectionToDB(null, pstmt, null);
        DBConnection.releaseConnectionToDB(con, pstmt1, rs1);
    }
    return message;
}

public JSONArray getBoatHubBufferData(int customerId,int systemId) {
    JSONArray JsonArray = null;
    JSONObject JsonObject = null;
    Connection con = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    CommonFunctions cf= new CommonFunctions();
    int startHrs=0;
    int startMnt=0;
    try {
        JsonArray = new JSONArray();
        con = DBConnection.getConnectionToDB("AMS");
        pstmt = con.prepareStatement(SandMiningStatements.GET_BOAT_HUB_BUFFER_DISTANCE_DATA);
        pstmt.setInt(1,systemId);
        pstmt.setInt(2,customerId);
        rs = pstmt.executeQuery();
        
        float bufferDistance=0;
       
        if (rs.next()) {
           bufferDistance=rs.getFloat("BUFFER_DISTANCE");
           String detentionTime=rs.getString("DETENTION_TIME");
           if(detentionTime!=null && !detentionTime.equals("")){
           	String []arr=detentionTime.split(":");
           	startHrs=Integer.parseInt(arr[0]);
           	startMnt=Integer.parseInt(arr[1]);
           }
        }
        JsonObject = new JSONObject();
        JsonObject.put("bufferDistanceInx", bufferDistance);
        JsonObject.put("startHrsInx", startHrs);
        JsonObject.put("startMntInx", startMnt);
        JsonArray.put(JsonObject);
        
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        DBConnection.releaseConnectionToDB(con, pstmt, rs);
    }
    return JsonArray;
}

public String saveBoatHubBufferSettings(int systemId,int custId,String bufferDistance,String detentionTime){
	Connection con = null;
	PreparedStatement pstmt= null;
	ResultSet rs= null;
	String message="";
	CommonFunctions cf = new CommonFunctions();
	
	try
	{
		con = DBConnection.getConnectionToDB("AMS");
		pstmt = con.prepareStatement(SandMiningStatements.GET_BOAT_HUB_BUFFER_DISTANCE_DATA);
        pstmt.setInt(1,systemId);
        pstmt.setInt(2,custId);
        rs = pstmt.executeQuery();
        if(rs.next()){
        	//Update
        	pstmt = con.prepareStatement(SandMiningStatements.UPDATE_BOAT_HUB_BUFFER_DISTANCE_DATA);
	        pstmt.setString(1,bufferDistance);
	        pstmt.setString(2,detentionTime);
	        pstmt.setInt(3,systemId);
	        pstmt.setInt(4,custId);
	        int updated= pstmt.executeUpdate();
	        message = updated>0?"Updated Successfully":"Error in Updation";
        }else{
        	//Insert
        	pstmt = con.prepareStatement(SandMiningStatements.INSERT_BOAT_HUB_BUFFER_DISTANCE_DATA);
	        pstmt.setInt(1,systemId);
	        pstmt.setInt(2,custId);
	        pstmt.setString(3,bufferDistance);
	        pstmt.setString(4,detentionTime);
	        int inserted= pstmt.executeUpdate();
	        message = inserted>0?"New Record Inserted Successfully":"Error in Insertion";
        }
		
	}
	 catch (Exception e)
	 {
			e.printStackTrace();
	 }      
	finally {
		DBConnection.releaseConnectionToDB(con, pstmt, rs);
    }
	return message;
}

	public JSONArray getJSMDCDistrict()
	{
		Connection con = null;
		PreparedStatement pstmt= null;
		ResultSet rs= null;
		con=DBConnection.getConnectionMysToMysqlDBJSMDC("sand_consumer_model");
		try {
			pstmt=con.prepareStatement(SandMiningStatements.GET_DISTRICT);
			rs=pstmt.executeQuery();
			 JSONArray JsonArray=new JSONArray();
			JSONObject jsonObj= null;
			while(rs.next())
			{
				jsonObj=new JSONObject();
				jsonObj.put("id", rs.getInt(1));
				jsonObj.put("districtName",rs.getString(2));
				JsonArray.put(jsonObj);
			}
			return JsonArray;
			
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
	    }
	return null;
	}
	
	public JSONArray getJSMDCStockyardByDistrictId(Integer id)
	{
		Connection con = null;
		PreparedStatement pstmt= null;
		ResultSet rs= null;
		con=DBConnection.getConnectionMysToMysqlDBJSMDC("sand_consumer_model");
		try {
			if(id==0)
			{	
			pstmt=con.prepareStatement(SandMiningStatements.GET_ALL_STOCKYARD);
			}
			else
			{
				pstmt=con.prepareStatement(SandMiningStatements.GET_STOCKYARD_BY_DISTRICT);
				pstmt.setInt(1, id);
			}
			rs=pstmt.executeQuery();
			 JSONArray JsonArray=new JSONArray();
			JSONObject jsonObj= null;
			while(rs.next())
			{
				jsonObj=new JSONObject();
				jsonObj.put("id", rs.getInt(1));
				jsonObj.put("stockyard",rs.getString(2));
				jsonObj.put("hubId",rs.getInt(22));
				JsonArray.put(jsonObj);
			}
			return JsonArray;
			
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
	    }
	return null;
	}
	
	public JSONArray getJSMDCStockyardInfoById(Integer id,Integer systemId,Integer customerId,Integer userId,int nonCommHrs)
	{
		Connection con = null;
		PreparedStatement pstmt= null;
		PreparedStatement pstmt1= null;
		PreparedStatement pstmt2= null;
		PreparedStatement pstmt3= null;
		PreparedStatement pstmt4= null;
		ResultSet rs= null;
		ResultSet rs1= null;
		ResultSet rs2= null;
		ResultSet rs3= null;
		int totalVehicle=0;
		int NonCommunicatingVehicle=0;
		int communicationVeicle=0;
		int onTrip=0;
		int activeSandCount = 0;
		con=DBConnection.getConnectionMysToMysqlDBJSMDC("sand_consumer_model");
		try {
			pstmt=con.prepareStatement(SandMiningStatements.GET_ACTIVE_SAND_COUNTS);
			rs=pstmt.executeQuery();
			while (rs.next()){
				activeSandCount = rs.getInt("count");
			}
			pstmt.close();
			rs.close();
			if(id==0)
			{
				pstmt=con.prepareStatement(SandMiningStatements.GET_ALL_STOCKYARD_INFO);
			}
			else
			{
				pstmt=con.prepareStatement(SandMiningStatements.GET_STOCKYARD_INFO_BY_ID);
				pstmt.setInt(1, id);
			}
			
			rs=pstmt.executeQuery();
			 JSONArray JsonArray=new JSONArray();
			JSONObject jsonObj= null;
			int tripCount=0;
			List<Integer>hubIds=new ArrayList<Integer>();
			if(rs.next())
			{
				if(id==0)
				{
					pstmt1=con.prepareStatement(SandMiningStatements.GET_ALL_STOCKYARDS_HUBID);
				}
				else
				{
					pstmt1=con.prepareStatement(SandMiningStatements.GET_STOCKYARDS_HUBID);
					pstmt1.setInt(1, id);
				}
				
				rs1=pstmt1.executeQuery();
				while(rs1.next())
				{
					int hubId=0;
					 hubId=rs1.getInt(1);
					 hubIds.add(hubId);
					Connection connection = null;
					connection = DBConnection.getConnectionToDB("AMS");
					pstmt2=connection.prepareStatement(SandMiningStatements.GET_DISTINCT_VEHICLE_ON_HUBID);
					pstmt2.setInt(1, hubId);
					rs2=pstmt2.executeQuery();
					while(rs2.next())
					{
						String registrationNo=rs2.getString(1);
						pstmt3=connection.prepareStatement(SandMiningStatements.GET_TRIP_COUNT_OF_VEHICLE);
						pstmt3.setString(1, registrationNo);
						rs3=pstmt3.executeQuery();
						if(rs3.next())
						{
							tripCount+=rs3.getInt(1);
						}
						pstmt3.close();
						rs3.close();
					}
					pstmt2.close();
					rs2.close();
				}
				pstmt1.close();
				rs1.close();
				jsonObj=new JSONObject();
				jsonObj.put("totalAmmount", rs.getInt(1));
				jsonObj.put("totalDispatchedSandQuantity",rs.getInt(2));
				jsonObj.put("Royalty",rs.getInt(3));
				jsonObj.put("GSTFee",rs.getInt(4));
				jsonObj.put("CapacityOfStockyard",rs.getInt(5));
				jsonObj.put("AvailableSandQuantity",rs.getInt(6));
				jsonObj.put("ReservedSandQuantity",rs.getInt(7));
				jsonObj.put("DispatchedSandQuantity", rs.getInt(8));
				jsonObj.put("tripCount",tripCount);	
				jsonObj.put("activeSandCount",activeSandCount);
				JsonArray.put(jsonObj);
			}
			rs.close();
			Connection connection = null;
			connection = DBConnection.getConnectionToDB("AMS");
			pstmt1 = connection.prepareStatement(SandMiningStatements.GET_CUSTOMER_ID_BY_HUBID.replace("#", StringUtils.join(hubIds.iterator(), ",")));
			rs=pstmt1.executeQuery();
			List<Integer>customerIds=new ArrayList<Integer>();
			while(rs.next())
			{
				customerIds.add(rs.getInt(1));
			}
			rs.close();
			//pstmt1 = connection.prepareStatement(SandMiningStatements.GET_TOTAL_ASSET_COUNT_FOR_LTSP);
//			pstmt1 = connection.prepareStatement(SandMiningStatements.GET_TOTAL_ASSET_COUNT_FOR_LTSP_NEW.replace("#", StringUtils.join(customerIds.iterator(), ",")));
//			//pstmt2 = connection.prepareStatement(SandMiningStatements.GET_COMMUNICATION_COUNT_FOR_LTSP);
//			pstmt2 = connection.prepareStatement(SandMiningStatements.GET_COMMUNICATION_COUNT_FOR_LTSP_NEW.replace("#", StringUtils.join(customerIds.iterator(), ",")));
////			pstmt2 = connection.prepareStatement(SandMiningStatements.GET_NON_COM_LESS_THAN_24HRS_COUNT_FOR_LTSP); 
//			//pstmt3 = connection.prepareStatement(SandMiningStatements.GET_NON_COM_GREATER_THAN_24HRS_COUNT_FOR_LTSP);
//			pstmt3 = connection.prepareStatement(SandMiningStatements.GET_NON_COM_GREATER_THAN_24HRS_COUNT_FOR_LTSP_NEW.replace("#", StringUtils.join(customerIds.iterator(), ",")));
//			pstmt4 = connection.prepareStatement(SandMiningStatements.GET_NO_GPS_COUNT_FOR_LTSP.replace("#", StringUtils.join(customerIds.iterator(), ",")));
//			
//			pstmt1.setInt(1, systemId);
////			pstmt1.setInt(2, customerId);
//			//pstmt1.setInt(3, userId);
//			rs = pstmt1.executeQuery();
//			if (rs.next()) {
//				totalVehicle = rs.getInt("COUNT");  // to be changed
//			}
//			rs.close();
//
//
//			pstmt2.setInt(1, systemId);
//		//	pstmt2.setInt(2, customerId);
//			//pstmt2.setInt(3, userId);
//			rs = pstmt2.executeQuery();
//			if (rs.next()) {
//				communicationVeicle = rs.getInt("COUNT");
//			}
//			rs.close();
//
//
////			pstmt2.setInt(1, systemId);
////			pstmt2.setInt(2, customerId);
////			pstmt2.setInt(3, userId);
////			rs = pstmt2.executeQuery();
////			if (rs.next()) {
////				nonCommLessThan24hrCount = rs.getInt("COUNT");
////			}
////			rs.close();
//
//
//			pstmt3.setInt(1, systemId);
//		//	pstmt3.setInt(2, customerId);
//			//pstmt3.setInt(3, userId);
//			rs = pstmt3.executeQuery();
//			if (rs.next()) {
//				NonCommunicatingVehicle = rs.getInt("COUNT");
//			}
//			rs.close();
//
//
//			pstmt4.setInt(1, systemId);
			//pstmt4.setInt(2, customerId);
//			pstmt4.setInt(2, userId);
//			rs = pstmt4.executeQuery();
//			if (rs.next()) {
//				onTrip = rs.getInt("COUNT");
//			}
			
			//new logic
			pstmt4 = connection.prepareStatement(SandMiningStatements.GET_CUSTOMER_BASED_ON_ID.replace("#", StringUtils.join(customerIds.iterator(), ",")));
			pstmt4.setInt(1, nonCommHrs);
			pstmt4.setInt(2, nonCommHrs);
			pstmt4.setInt(3, systemId);
			rs.close();
			rs = pstmt4.executeQuery();
			int totalCount=0,communicating=0,nonCommunicating=0,noGps=0;
			if (rs.next()) {
				
				totalCount=rs.getInt("TOTAL_VEHICLES");
				communicating=rs.getInt("COMM");
				nonCommunicating=rs.getInt("NONCOMM");
				//noGps=rs.getInt("NOGPS");
			}
			rs.close();
			jsonObj=new JSONObject();
			jsonObj.put("totalVehicle", totalCount);
			jsonObj.put("NonCommunicating", communicating);
			jsonObj.put("communicating", nonCommunicating);
			jsonObj.put("onTrip", onTrip);
			jsonObj.put("customersIds", StringUtils.join(customerIds.iterator(), ","));
			JsonArray.put(jsonObj);
			
			if(id==0)
			{
				pstmt=con.prepareStatement(SandMiningStatements.GET_ALL_TOKENS_COUNT_AND_OTHERS_INFO_FOR_STOCKYARD);
			}
			else
			{
				pstmt=con.prepareStatement(SandMiningStatements.GET_TOKENS_COUNT_AND_OTHERS_INFO_FOR_STOCKYARD);
				pstmt.setInt(1, id);
				pstmt.setInt(2, id);
			}

			rs=pstmt.executeQuery();
			if(rs.next())
			{
			jsonObj=new JSONObject();
			jsonObj.put("tokens",rs.getInt(1) );
			jsonObj.put("loadingVehicles", rs.getInt(2));
			jsonObj.put("delivery", rs.getInt(3));
			JsonArray.put(jsonObj);
			}
			rs.close();
		
			if(id==0)
			{
				pstmt=con.prepareStatement(SandMiningStatements.GET_ALL_REPRINT_TOKEN_HISTORY_COUNT);
			}
			else
			{
				pstmt=con.prepareStatement(SandMiningStatements.GET_REPRINT_TOKEN_HISTORY_COUNT);
				pstmt.setInt(1, id);
			}
		rs=pstmt.executeQuery();
		if(rs.next())
		{
		jsonObj=new JSONObject();
		jsonObj.put("reprintTokenHistory",rs.getInt(1) );
		JsonArray.put(jsonObj);
		}
		return JsonArray;
		
	} catch (Exception e) {
		// TODO Auto-generated catch block
		e.printStackTrace();
	}
	finally {
		DBConnection.releaseConnectionToDB(con, pstmt, rs);
    }
	return null;
	}
	
	public JSONArray getJSMDCStockyardDetails()
	{
		Connection con = null;
		PreparedStatement pstmt= null;
		ResultSet rs= null;
		con=DBConnection.getConnectionMysToMysqlDBJSMDC("sand_consumer_model");
		try {
			pstmt=con.prepareStatement(SandMiningStatements.GET_ALL_STOCKYARD_DISTRICT);
			rs=pstmt.executeQuery();
			 JSONArray JsonArray=new JSONArray();
			JSONObject jsonObj= null;
			while(rs.next())
			{
				jsonObj=new JSONObject();
				jsonObj.put("Id", rs.getInt(1));
				jsonObj.put("Name",rs.getString(2));
				jsonObj.put("Latitude",rs.getDouble(3));
				jsonObj.put("Longitude",rs.getDouble(4));
				jsonObj.put("DistrictName",rs.getString(5));
//				jsonObj.put("StockyardName",rs.getString("StockyardName"));
				jsonObj.put("AvailableSandQuantity",rs.getString(6));
				jsonObj.put("ReservedSandQuantity",rs.getString(7));
				JsonArray.put(jsonObj);
			}
			return JsonArray;
			
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
	    }
	return null;
	}
	
	public JSONArray getReportDetails(Integer id,Integer systemId,Integer customerId,Integer userId)
	{
		Connection con = null;
		PreparedStatement pstmt= null;
		ResultSet rs= null;
	
		con=DBConnection.getConnectionMysToMysqlDBJSMDC("sand_consumer_model");
		try {
			if(id == 0){
				pstmt=con.prepareStatement(SandMiningStatements.GET_ALL_SOLD_DISPATCHED_DETAILS);
			}else{
				pstmt=con.prepareStatement(SandMiningStatements.GET_SOLD_DISPATCHED_DETAILS);
				pstmt.setInt(1,id);
				//pstmt.setString(2, startDate);
				//pstmt.setString(3, endDate);
			}
			rs=pstmt.executeQuery();
			JSONArray JsonArray=new JSONArray();
			JSONObject jsonObj= null;
			while(rs.next())
			{
				jsonObj=new JSONObject();
				jsonObj.put("bookingId",rs.getString("BookingId"));
				jsonObj.put("consumerMobileNo",rs.getString("ConsumerMobileNo"));
				jsonObj.put("fromPlace",rs.getString("FromPlace"));
				jsonObj.put("toPlace",rs.getString("ToPlace"));
				jsonObj.put("bookedSandQty",rs.getDouble("BookedSandQuantity"));
				jsonObj.put("dispatchedSandQty",rs.getDouble("DispatchedSandQuantity"));
				jsonObj.put("royalty",rs.getString("Royalty"));
				jsonObj.put("gstFee", rs.getString("GSTFee"));
				jsonObj.put("totalAmount", rs.getString("totalAmount"));
				jsonObj.put("remainingSandQuantity", rs.getString("RemainingSandQuantity"));
				JsonArray.put(jsonObj);
			}
			System.out.println("JsonArray length" + JsonArray.length() + " JsonArray" + JsonArray);
			return JsonArray;
			
		} catch (Exception e) {
		// TODO Auto-generated catch block
		e.printStackTrace();
	}
	finally {
		DBConnection.releaseConnectionToDB(con, pstmt, rs);
    }
	return null;
	}
	
	public JSONArray getSandStockReportDetails(Integer id,Integer systemId,Integer customerId,Integer userId)
	{
		Connection con = null;
		PreparedStatement pstmt= null;
		ResultSet rs= null;
	
		con=DBConnection.getConnectionMysToMysqlDBJSMDC("sand_consumer_model");
		try {
			if(id == 0){
				pstmt=con.prepareStatement(SandMiningStatements.GET_ALL_SAND_STOCK_DETAILS);
				//pstmt.setString(1, startDate);
				//pstmt.setString(2, endDate);
			}else{
				pstmt=con.prepareStatement(SandMiningStatements.GET_SAND_STOCK_DETAILS);
				pstmt.setInt(1,id);
				//pstmt.setString(2, startDate);
				//pstmt.setString(3, endDate);
			}
			rs=pstmt.executeQuery();
			JSONArray JsonArray=new JSONArray();
			JSONObject jsonObj= null;
			while(rs.next())
			{
				jsonObj=new JSONObject();
				jsonObj.put("availableSandQty",rs.getString("AvailableSandQty"));
				jsonObj.put("dispatchedSandQty",rs.getString("DispatchedSandQty"));
				jsonObj.put("reservedSandQty",rs.getString("ReservedSandQty"));
				jsonObj.put("name",rs.getString("HubName"));
				JsonArray.put(jsonObj);
			}
			return JsonArray;
			
		} catch (Exception e) {
		// TODO Auto-generated catch block
		e.printStackTrace();
	}
	finally {
		DBConnection.releaseConnectionToDB(con, pstmt, rs);
    }
	return null;
	}
	public JSONArray getVehicleReportDetails(Integer id,Integer systemId,Integer customerId,Integer userId,String customerIds)
	{
		Connection con = null;
		PreparedStatement pstmt= null;
		ResultSet rs= null;
	
		con = DBConnection.getConnectionToDB("AMS");
		try {
			pstmt=con.prepareStatement(SandMiningStatements.GET_VEHICLE_DETAILS.replace("#", customerIds));
			pstmt.setInt(1,systemId);
//			pstmt.setString(2, customerIds);
			//pstmt.setString(3, endDate);
			rs=pstmt.executeQuery();
			JSONArray JsonArray=new JSONArray();
			JSONObject jsonObj= null;
			while(rs.next())
			{
				jsonObj=new JSONObject();
				jsonObj.put("registrationNo",rs.getString("REGISTRATION_NO"));
				jsonObj.put("gpsDateTime",rs.getString("GPS_DATETIME"));
				jsonObj.put("gmt",rs.getString("GMT"));
				jsonObj.put("ignition",rs.getString("IGNITION"));
				jsonObj.put("location",rs.getString("LOCATION"));
				JsonArray.put(jsonObj);
			}
			return JsonArray;
			
		} catch (Exception e) {
		// TODO Auto-generated catch block
		e.printStackTrace();
	}
	finally {
		DBConnection.releaseConnectionToDB(con, pstmt, rs);
    }
	return null;
	}
	
	
	public JSONArray getTripReportDetails(Integer id,Integer systemId,Integer customerId,Integer userId)
	{
		Connection con = null;
		PreparedStatement pstmt= null;
		ResultSet rs= null;
	
		con = DBConnection.getConnectionToDB("AMS");
		try {
			pstmt=con.prepareStatement(SandMiningStatements.GET_TRIP_DETAILS);
			pstmt.setInt(1,customerId);
			pstmt.setInt(2, systemId);
			rs=pstmt.executeQuery();
			JSONArray JsonArray=new JSONArray();
			JSONObject jsonObj= null;
			while(rs.next())
			{
				jsonObj=new JSONObject();
				jsonObj.put("registrationNo",rs.getString("REGISTRATION_NO"));
				jsonObj.put("hubId",rs.getString("HUB_ID"));
				jsonObj.put("location",rs.getString("NAME"));
				JsonArray.put(jsonObj);
			}
			return JsonArray;
			
		} catch (Exception e) {
		// TODO Auto-generated catch block
		e.printStackTrace();
	}
	finally {
		DBConnection.releaseConnectionToDB(con, pstmt, rs);
    }
	return null;
	}
	
	public JSONArray getStockyardReportDetails(Integer id,Integer systemId,Integer customerId,Integer userId)
	{
		Connection con = null;
		PreparedStatement pstmt= null;
		ResultSet rs= null;
	
		con=DBConnection.getConnectionMysToMysqlDBJSMDC("sand_consumer_model");
		try {
			if(id == 0) {
				pstmt=con.prepareStatement(SandMiningStatements.GET_ALL_STOCKYARD_DETAILS);
			}else{
				pstmt=con.prepareStatement(SandMiningStatements.GET_STOCKYARD_DETAILS);
				pstmt.setInt(1,id);
			}
			rs=pstmt.executeQuery();
			JSONArray JsonArray=new JSONArray();
			JSONObject jsonObj= null;
			while(rs.next())
			{
				jsonObj=new JSONObject();
				jsonObj.put("tokenNumber",rs.getString("TokenNumber"));
				jsonObj.put("vehicleNumber",rs.getString("VehicleNumber"));
				jsonObj.put("qtyTaken",rs.getString("QuantityTaken"));
				jsonObj.put("vehicleType",rs.getString("VehicleType"));
				jsonObj.put("status",rs.getString("Status"));
				JsonArray.put(jsonObj);
			}
			return JsonArray;
			
		} catch (Exception e) {
		// TODO Auto-generated catch block
		e.printStackTrace();
	}
	finally {
		DBConnection.releaseConnectionToDB(con, pstmt, rs);
    }
	return null;
	}

	public JSONArray getActiveSandReportDetails(Integer id,Integer systemId,Integer customerId,Integer userId)
	{
		Connection con = null;
		PreparedStatement pstmt= null;
		ResultSet rs= null;
	
		con=DBConnection.getConnectionMysToMysqlDBJSMDC("sand_consumer_model");
		try {
			if(id == 0) {
				pstmt=con.prepareStatement(SandMiningStatements.GET_ALL_ACTIVE_SAND_DETAILS);
				pstmt.setInt(1, systemId);
			}else{
				pstmt=con.prepareStatement(SandMiningStatements.GET_ACTIVE_SAND_DETAILS);
				pstmt.setInt(1,id);
				pstmt.setInt(2, systemId);
			}
			rs=pstmt.executeQuery();
			JSONArray JsonArray=new JSONArray();
			JSONObject jsonObj= null;
			while(rs.next())
			{
				jsonObj=new JSONObject();
				jsonObj.put("hubName",rs.getString("HubName"));
				jsonObj.put("address",rs.getString("Address"));
				jsonObj.put("availableSandQty",rs.getString("AvailableSandQuantity"));
				jsonObj.put("reservedSandQty",rs.getString("ReservedSandQuantity"));
				jsonObj.put("dispatchedSandQty",rs.getString("DispatchedSandQuantity"));
				JsonArray.put(jsonObj);
			}
			return JsonArray;
			
		} catch (Exception e) {
		// TODO Auto-generated catch block
		e.printStackTrace();
	}
	finally {
		DBConnection.releaseConnectionToDB(con, pstmt, rs);
    }
	return null;
	}
	
	public JSONArray getAllJSMDCUsers()
	{
		Connection con = null;
		PreparedStatement pstmt= null;
		ResultSet rs= null;
		con=DBConnection.getConnectionMysToMysqlDBJSMDC("sand_consumer_model");
		try {
			pstmt=con.prepareStatement(SandMiningStatements.GET_ALL_JSMDC_USERS);
			rs=pstmt.executeQuery();
			 JSONArray JsonArray=new JSONArray();
			JSONObject jsonObj= null;
			while(rs.next())
			{
				jsonObj=new JSONObject();
				jsonObj.put("Id", rs.getInt(1));
				jsonObj.put("UserName",rs.getString("UserName"));
				jsonObj.put("FullName",rs.getString("FullName"));
				jsonObj.put("TypeOfBuyer",rs.getString("TypeOfBuyer"));
				jsonObj.put("MobileNo",rs.getString("MobileNo"));
				jsonObj.put("Address",rs.getString("Address"));
				jsonObj.put("City",rs.getString("City"));
				jsonObj.put("Pincode",rs.getString("Pincode"));
				jsonObj.put("Email",rs.getString("Email"));
				jsonObj.put("typeOfDocument",rs.getString("typeOfDocument"));
				jsonObj.put("ProofOfIdentity",rs.getString("ProofOfIdentity"));
				jsonObj.put("IsActive",rs.getBoolean("IsActive"));
				JsonArray.put(jsonObj);
			}
			return JsonArray;
			
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
	    }
	return null;
	}
	
	public JSONArray getJSMDCHubsOnDistrict(int districtId)
	{
		Connection con = null;
		PreparedStatement pstmt= null;
		ResultSet rs= null;
		con=DBConnection.getConnectionMysToMysqlDBJSMDC("sand_consumer_model");
		try {
			if(districtId==0)
			{
			pstmt=con.prepareStatement(SandMiningStatements.GET_ALL_JSMDC_STOCKYARD);
			}
			else
			{
				pstmt=con.prepareStatement(SandMiningStatements.GET_ALL_JSMDC_STOCKYARD_DISTRICT_ID);
				pstmt.setInt(1, districtId);
			}
			rs=pstmt.executeQuery();
			 JSONArray JsonArray=new JSONArray();
			JSONObject jsonObj= null;
			while(rs.next())
			{
				jsonObj=new JSONObject();
				jsonObj.put("Id", rs.getInt(1));
				jsonObj.put("HubName",rs.getString("HubName"));
				jsonObj.put("Address",rs.getString("Address"));
				jsonObj.put("IsActive",rs.getInt("IsActive"));
				JsonArray.put(jsonObj);
			}
			return JsonArray;
			
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
	    }
	return null;
	}
	public int activeInactiveStockyardOrUser(Integer id,String type,Boolean value)
	{
		Connection con = null;
		PreparedStatement pstmt= null;
		ResultSet rs= null;
		con=DBConnection.getConnectionMysToMysqlDBJSMDC("sand_consumer_model");
		try {
			if(type.equalsIgnoreCase("hub"))
			{
				pstmt=con.prepareStatement(SandMiningStatements.ACTIVE_INACTIVE_JSMDC_STOCKYAD);
				pstmt.setBoolean(1, value);
				pstmt.setInt(2,id);
			}
			else
			{
				pstmt=con.prepareStatement(SandMiningStatements.ACTIVE_INACTIVE_JSMDC_USER);
				pstmt.setBoolean(1, value);
				pstmt.setInt(2,id);
			}
						return pstmt.executeUpdate();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			return 0;
		}
		finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
	    }
	}
	public int configureStockyard(Integer totalPermit,Integer bookingLimit,Integer noOfTripsForDay,Integer id)
	{
		Connection con = null;
		PreparedStatement pstmt= null;
		ResultSet rs= null;
		con=DBConnection.getConnectionMysToMysqlDBJSMDC("sand_consumer_model");
		try {
				pstmt=con.prepareStatement(SandMiningStatements.CONFIGURE_STOCKYARD);
				pstmt.setInt(1, totalPermit);
				pstmt.setInt(2,bookingLimit);
				pstmt.setInt(3,noOfTripsForDay);
				pstmt.setInt(4,id);
				return pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
			return 0;
		}
		finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
	    }
	}
	
	public JSONArray getStockyardInfoForConfiguration(Integer stockyardId)
	{
		Connection con = null;
		PreparedStatement pstmt= null;
		ResultSet rs= null;
		con=DBConnection.getConnectionMysToMysqlDBJSMDC("sand_consumer_model");
		try {
				pstmt=con.prepareStatement(SandMiningStatements.GET_STOCKYARD_INFO_FOR_CONFIGURATION);
				pstmt.setInt(1, stockyardId);
				rs=pstmt.executeQuery();
				 JSONArray JsonArray=new JSONArray();
				JSONObject jsonObj= null;
				if(rs.next())
				{
					jsonObj=new JSONObject();
					jsonObj.put("Id", rs.getInt(1));
					jsonObj.put("HubName",rs.getString("HubName"));
					jsonObj.put("Address",rs.getString("Address"));
					jsonObj.put("IsActive",rs.getInt("IsActive"));
					jsonObj.put("CapacityOfStockyard",rs.getInt("CapacityOfStockyard"));
					jsonObj.put("AvailableSandQuantity",rs.getInt("AvailableSandQuantity"));
					jsonObj.put("AssociatedGeofence",rs.getInt("AssociatedGeofence"));
					jsonObj.put("ReservedSandQuantity",rs.getInt("ReservedSandQuantity"));
					jsonObj.put("DispatchedSandQuantity",rs.getInt("DispatchedSandQuantity"));
					jsonObj.put("GeoFenceId",rs.getInt("GeoFenceId"));
					jsonObj.put("HubId",rs.getInt("HubId"));
					JsonArray.put(jsonObj);
				}
				return JsonArray;
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
		finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
	    }
	}
	public int updateIndiUserTypePerDay(Integer noOfTripsForDay)
	{
		Connection con = null;
		PreparedStatement pstmt= null;
		ResultSet rs= null;
		con=DBConnection.getConnectionMysToMysqlDBJSMDC("sand_consumer_model");
		try {
				pstmt=con.prepareStatement(SandMiningStatements.UPDATE_IND_USER_TYPE_PER_DAY);
				pstmt.setInt(1,noOfTripsForDay);
				return pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
			return 0;
		}
		finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
	    }
	}
	public int updateIndiUserTypePerWeek(Integer noOfTripsForPerWeek)
	{
		Connection con = null;
		PreparedStatement pstmt= null;
		ResultSet rs= null;
		con=DBConnection.getConnectionMysToMysqlDBJSMDC("sand_consumer_model");
		try {
				pstmt=con.prepareStatement(SandMiningStatements.UPDATE_IND_USER_TYPE_PER_WEEK);
				pstmt.setInt(1,noOfTripsForPerWeek);
				return pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
			return 0;
		}
		finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
	    }
	}
	public int updateIndiUserTypePerMonth(Integer noOfTripsForPerMonth)
	{
		Connection con = null;
		PreparedStatement pstmt= null;
		ResultSet rs= null;
		con=DBConnection.getConnectionMysToMysqlDBJSMDC("sand_consumer_model");
		try {
				pstmt=con.prepareStatement(SandMiningStatements.UPDATE_IND_USER_TYPE_PER_MONTH);
				pstmt.setInt(1,noOfTripsForPerMonth);
				return pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
			return 0;
		}
		finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
	    }
	}
	public JSONArray getIndividualUserTypePerDayForConfiguration()
	{
		Connection con = null;
		PreparedStatement pstmt= null;
		ResultSet rs= null;
		con=DBConnection.getConnectionMysToMysqlDBJSMDC("sand_consumer_model");
		try {
				pstmt=con.prepareStatement(SandMiningStatements.GET_IND_INFO_PER_DAY_FOR_CONFIGURATION);
				rs=pstmt.executeQuery();
				 JSONArray JsonArray=new JSONArray();
				JSONObject jsonObj= null;
				if(rs.next())
				{
					jsonObj=new JSONObject();
					jsonObj.put("KeyValue",rs.getString("KeyValue"));
					JsonArray.put(jsonObj);
				}
				return JsonArray;
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
		finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
	    }
	}
	public JSONArray getIndividualUserTypePerWeekForConfiguration()
	{
		Connection con = null;
		PreparedStatement pstmt= null;
		ResultSet rs= null;
		con=DBConnection.getConnectionMysToMysqlDBJSMDC("sand_consumer_model");
		try {
				pstmt=con.prepareStatement(SandMiningStatements.GET_IND_INFO_PER_WEEK_FOR_CONFIGURATION);
				rs=pstmt.executeQuery();
				 JSONArray JsonArray=new JSONArray();
				JSONObject jsonObj= null;
				if(rs.next())
				{
					jsonObj=new JSONObject();
					jsonObj.put("KeyValue",rs.getString("KeyValue"));
					JsonArray.put(jsonObj);
				}
				return JsonArray;
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
		finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
	    }
	}
	public JSONArray getIndividualUserTypePerMonthForConfiguration()
	{
		Connection con = null;
		PreparedStatement pstmt= null;
		ResultSet rs= null;
		con=DBConnection.getConnectionMysToMysqlDBJSMDC("sand_consumer_model");
		try {
				pstmt=con.prepareStatement(SandMiningStatements.GET_IND_INFO_PER_MONTH_FOR_CONFIGURATION);
				rs=pstmt.executeQuery();
				 JSONArray JsonArray=new JSONArray();
				JSONObject jsonObj= null;
				if(rs.next())
				{
					jsonObj=new JSONObject();
					jsonObj.put("KeyValue",rs.getString("KeyValue"));
					JsonArray.put(jsonObj);
				}
				return JsonArray;
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
		finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
	    }
	}
	public int updateGovtUserTypePerDay(Integer noOfTripsForPerDay)
	{
		Connection con = null;
		PreparedStatement pstmt= null;
		ResultSet rs= null;
		con=DBConnection.getConnectionMysToMysqlDBJSMDC("sand_consumer_model");
		try {
				pstmt=con.prepareStatement(SandMiningStatements.UPDATE_GOVT_USER_TYPE_PER_DAY);
				pstmt.setInt(1,noOfTripsForPerDay);
				return pstmt.executeUpdate();
		}catch (Exception e) {
			e.printStackTrace();
			return 0;
		}
		finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
	    }
	}
	public int updateGovtUserTypePerWeek(Integer noOfTripsForPerWeek)
	{
		Connection con = null;
		PreparedStatement pstmt= null;
		ResultSet rs= null;
		con=DBConnection.getConnectionMysToMysqlDBJSMDC("sand_consumer_model");
		try {
				pstmt=con.prepareStatement(SandMiningStatements.UPDATE_GOVT_USER_TYPE_PER_WEEK);
				pstmt.setInt(1,noOfTripsForPerWeek);
				return pstmt.executeUpdate();
		}catch (Exception e) {
			e.printStackTrace();
			return 0;
		}
		finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
	    }
	}
	public int updateGovtUserTypePerMonth(Integer noOfTripsForPerMonth)
	{
		Connection con = null;
		PreparedStatement pstmt= null;
		ResultSet rs= null;
		con=DBConnection.getConnectionMysToMysqlDBJSMDC("sand_consumer_model");
		try {
				pstmt=con.prepareStatement(SandMiningStatements.UPDATE_GOVT_USER_TYPE_PER_MONTH);
				pstmt.setInt(1,noOfTripsForPerMonth);
				return pstmt.executeUpdate();
		}catch (Exception e) {
			e.printStackTrace();
			return 0;
		}
		finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
	    }
	}
	public JSONArray getGovtUserTypePerDayForConfiguration()
	{
		Connection con = null;
		PreparedStatement pstmt= null;
		ResultSet rs= null;
		con=DBConnection.getConnectionMysToMysqlDBJSMDC("sand_consumer_model");
		try {
				pstmt=con.prepareStatement(SandMiningStatements.GET_GOVT_INFO_PER_DAY_FOR_CONFIGURATION);
				rs=pstmt.executeQuery();
				JSONArray JsonArray=new JSONArray();
				JSONObject jsonObj= null;
				if(rs.next())
				{
					jsonObj=new JSONObject();
					jsonObj.put("KeyValue",rs.getString("KeyValue"));
					JsonArray.put(jsonObj);
				}
				return JsonArray;
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
		finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
	    }
	}
	public JSONArray getGovtUserTypePerWeekForConfiguration()
	{
		Connection con = null;
		PreparedStatement pstmt= null;
		ResultSet rs= null;
		con=DBConnection.getConnectionMysToMysqlDBJSMDC("sand_consumer_model");
		try {
				pstmt=con.prepareStatement(SandMiningStatements.GET_GOVT_INFO_PER_WEEK_FOR_CONFIGURATION);
				rs=pstmt.executeQuery();
				JSONArray JsonArray=new JSONArray();
				JSONObject jsonObj= null;
				if(rs.next())
				{
					jsonObj=new JSONObject();
					jsonObj.put("KeyValue",rs.getString("KeyValue"));
					JsonArray.put(jsonObj);
				}
				return JsonArray;
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
		finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
	    }
	}
	public JSONArray getGovtUserTypePerMonthForConfiguration()
	{
		Connection con = null;
		PreparedStatement pstmt= null;
		ResultSet rs= null;
		con=DBConnection.getConnectionMysToMysqlDBJSMDC("sand_consumer_model");
		try {
				pstmt=con.prepareStatement(SandMiningStatements.GET_GOVT_INFO_PER_MONTH_FOR_CONFIGURATION);
				rs=pstmt.executeQuery();
				JSONArray JsonArray=new JSONArray();
				JSONObject jsonObj= null;
				if(rs.next())
				{
					jsonObj=new JSONObject();
					jsonObj.put("KeyValue",rs.getString("KeyValue"));
					JsonArray.put(jsonObj);
				}
				return JsonArray;
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
		finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
	    }
	}
	public JSONArray getRegisteredVehicles(int systemId,int clientId, int userId) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject = new JSONObject();
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(SandMiningStatements.GET_REGISTERED_VEHICLES);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, userId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				jsonObject = new JSONObject();
				jsonObject.put("vehicleNo", rs.getString("ASSET_NUMBER"));
				jsonArray.put(jsonObject);
			}

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jsonArray;
	}
	public JSONArray getAnalyticalWeighBridgeReportDetails(int systemId,int clientId,String startDate,String endDate){
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject = new JSONObject();
		
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(SandMiningStatements.GET_ANALYTICAL_WEIGH_BRIDGE_DEFERENCE);
			//pstmt.setInt(1, 332);
			//pstmt.setInt(2, 5915);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, clientId);
//			pstmt.setDate(3, (java.sql.Date) startDate);
//			pstmt.setDate(4, (java.sql.Date) endDate);
			pstmt.setString(3,  startDate);
			pstmt.setString(4, endDate);
			rs = pstmt.executeQuery();
			int count = 1;
			while (rs.next()) {
				jsonObject = new JSONObject();
				jsonObject.put("ID", count++);
				jsonObject.put("MMPS_TRIPSHEET_CODE", rs.getString("MMPS_TRIPSHEET_CODE"));
				jsonObject.put("LEASE_CODE", rs.getString("LEASE_CODE"));
				jsonObject.put("LEASE_NAME", rs.getString("LEASE_NAME"));
				jsonObject.put("BUYER", rs.getString("BUYER"));
				jsonObject.put("SOURCE", rs.getString("SOURCE"));
				jsonObject.put("DESTINATION", rs.getString("DESTINATION"));
				jsonObject.put("VEHICLE_NO", rs.getString("VEHICLE_NO"));
				jsonObject.put("PASS_ISSUE_DATE", rs.getString("PASS_ISSUE_DATE"));
				jsonObject.put("ACTUAL_WEIGHT", rs.getString("ACTUAL_WEIGHT"));
				jsonObject.put("NET_WEIGHT", rs.getString("NET_WEIGHT"));
				jsonObject.put("DIFFERENCE_WEIGHT", rs.getString("DIFFERENCE_WEIGHT"));
				jsonObject.put("INSERTED_DATE", rs.getString("INSERTED_DATE"));
				jsonArray.put(jsonObject);
			}
		}
		catch(Exception e){
			e.printStackTrace();
		}
		return jsonArray;
	}

}
				

