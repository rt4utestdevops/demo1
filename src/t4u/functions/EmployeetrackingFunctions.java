package t4u.functions;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;

import java.util.ArrayList;
import java.util.Date;
import java.util.Hashtable;
import java.util.List;

import org.apache.struts.util.LabelValueBean;
import org.json.JSONArray;
import org.json.JSONObject;


import com.sun.rowset.CachedRowSetImpl;

import t4u.beans.ReportHelper;
import t4u.beans.StatusReportBean;
import t4u.beans.StatusReportTaskBean;
import t4u.beans.StatusReportVehicleBean;
import t4u.common.DBConnection;

import t4u.statements.AdminStatements;
import t4u.statements.EmployeetrackingStatements;

/**
 * 
 * @author Administrator
 *this class is used for fetching records of EmployeeTracking from db
 */
public class EmployeetrackingFunctions {

	SimpleDateFormat sdfyyyymmdd=new SimpleDateFormat("yyyy-MM-dd");
	SimpleDateFormat sdfyyyymmddhhmmss=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	SimpleDateFormat sdfddmmyyhhmm=new SimpleDateFormat("dd-MM-yyyy HH:mm");
	
	/**
	 * getting all LTSP from db in JsonArray
	 * @return
	 */

	public JSONArray getLTSP() {
		JSONArray jsonArray = null;
		JSONObject jsonObject = null;
		Connection conAms=null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		try {
			jsonArray = new JSONArray();
			jsonObject = new JSONObject();
            conAms=DBConnection.getConnectionToDB("AMS");
			pstmt=conAms.prepareStatement(EmployeetrackingStatements.GET_LTSP);
			rs=pstmt.executeQuery();
			while(rs.next()){
				jsonObject = new JSONObject();
				jsonObject.put("LTSPId", rs.getString("System_id"));
				jsonObject.put("LTSPName", rs.getString("System_Name"));
				jsonArray.put(jsonObject);
			}
		} catch (Exception e) {
			System.out.println("Error in EmployeetrackingFunction:-getLTSP "+e.toString());
		}finally{
			DBConnection.releaseConnectionToDB(conAms, pstmt, rs);
		}
		return jsonArray;
	}

/**
 * getting all user record from db in JsonArray
 * @return
 */

	public JSONArray getUser() {
		JSONArray jsonArray = null;
		JSONObject jsonObject = null;
		Connection conAms=null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		try {
			jsonArray=new JSONArray();
			jsonObject=new JSONObject();
			conAms=DBConnection.getConnectionToDB("AMS");
			pstmt=conAms.prepareStatement(EmployeetrackingStatements.GET_USER);
			rs=pstmt.executeQuery();
			while(rs.next()){
				jsonObject = new JSONObject();
				jsonObject.put("UserId", rs.getString("USER_ID"));
				jsonObject.put("UserName", rs.getString("USER_NAME"));
				jsonArray.put(jsonObject);
			}
		} catch (Exception e) {
			System.out.println("Error in EmployeetrackingFunction:-getUser "+e.toString());
		}finally{
			DBConnection.releaseConnectionToDB(conAms, pstmt, rs);
		}
		
		return jsonArray;
	}

/**
 * fetching all vehicle records on the basis of customerid and ltsp id
 * @param custId
 * @param ltspId
 * @return
 */

	public JSONArray getVehicleDetails(String custId, String ltspId) {
		JSONArray jsonArray=null;
		JSONObject jsonObject=null;
		Connection conAms=null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		try {
		
			jsonArray=new JSONArray();
			jsonObject=new JSONObject();
			conAms=DBConnection.getConnectionToDB("AMS");
			pstmt=conAms.prepareStatement(EmployeetrackingStatements.GET_VEHICLES);
			int customerId=Integer.parseInt(custId.trim());
			
			int ltsp=Integer.parseInt(ltspId.trim());
			pstmt.setInt(1, ltsp);
			pstmt.setInt(2, customerId);
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
			System.out.println("Error in EmployeetrackingFunction:-getVehicleDetails "+e.toString());
		}finally{
			DBConnection.releaseConnectionToDB(conAms, pstmt, rs);
		}
		
		return jsonArray;
	}
/**
 * saving the employee tracking records into the db
 * @param ltsp
 * @param customer
 * @param user
 * @param vehicleNo
 * @param reptime
 * @param exitTime
 * @param newReInstall
 * @param unInstall
 * @param upkeep
 * @param software
 * @param imei
 * @param devType
 * @param gPSTIMEREMARKS
 * @param lOCATIONREMARKS
 * @param lASTSWIPEREMARKS
 * @param lASTPANICREMARKS
 * @param lASTOSREMARKS
 * @param lASTTRIPSHEETREMARKS
 * @param lASTOSEMAILREMARKS
 * @param lASTOSSMSREMARKS
 * @param lASTPANICEMAILREMARKS
 * @param lASTPANICSMSREMARKS
 * @return
 */
	public String saveEmployeeTrackingDetails(String ltsp, String customer,
			String user, String vehicleNo, String reptime, String exitTime,
			String newReInstall, String unInstall, String upkeep, String software,
			String imei, String devType, String gPSTIMEREMARKS,
			String lOCATIONREMARKS, String lASTSWIPEREMARKS,
			String lASTPANICREMARKS, String lASTOSREMARKS,
			String lASTTRIPSHEETREMARKS, String lASTOSEMAILREMARKS,
			String lASTOSSMSREMARKS, String lASTPANICEMAILREMARKS,
			String lASTPANICSMSREMARKS) {
		String message="";
		Connection conAms=null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		
		try {
			
			conAms=DBConnection.getConnectionToDB("AMS");
			//checking whether tracking record has setup in the same date or not
			pstmt=conAms.prepareStatement(EmployeetrackingStatements.CHECK_EMP_TRACKING_EXISTS);
			pstmt.setInt(1, Integer.parseInt(ltsp));
			pstmt.setInt(2, Integer.parseInt(customer));
			pstmt.setInt(3, Integer.parseInt(user));
			pstmt.setString(4, vehicleNo);
			pstmt.setString(5,reptime);
			rs=pstmt.executeQuery();
			if(rs.next()){
				 message="Tracking Record Already Exist!!";
			}else{
				message="New Tracking record is Saving!!";
				pstmt=null;
				//saving Emp Tracking record into the dbo.DAILY_TASK_TRACKER
				pstmt=conAms.prepareStatement(EmployeetrackingStatements.SAVE_EMPLOYEETRACKING_DETAILS);
				pstmt.setInt(1, Integer.parseInt(ltsp));
				pstmt.setInt(2, Integer.parseInt(customer));
				pstmt.setInt(3, Integer.parseInt(user));
				pstmt.setString(4, vehicleNo);
				pstmt.setString(5, reptime);
				pstmt.setString(6, exitTime);
				pstmt.setString(7, newReInstall);
				pstmt.setString(8, unInstall);
				pstmt.setString(9, upkeep);
				pstmt.setString(10, software);
				pstmt.setString(11, imei);
				pstmt.setString(12, devType);
				pstmt.setString(13, gPSTIMEREMARKS);
				pstmt.setString(14, lOCATIONREMARKS);
				pstmt.setString(15, lASTSWIPEREMARKS);
				pstmt.setString(16, lASTPANICREMARKS);
				pstmt.setString(17, lASTOSREMARKS);
				pstmt.setString(18, lASTTRIPSHEETREMARKS);
				pstmt.setString(19, lASTOSEMAILREMARKS);
				pstmt.setString(20, lASTOSSMSREMARKS);
				pstmt.setString(21, lASTPANICEMAILREMARKS);
				pstmt.setString(22, lASTPANICSMSREMARKS);
				int i=pstmt.executeUpdate();
				if(i>0){
					 message="save";
				}else{
					 message="error";
				}
			}
		
		} catch (Exception e) {
			System.out.println("error in data saving:-EmployeetrackingFunction"+e);
		}
		finally{
			DBConnection.releaseConnectionToDB(conAms, pstmt, rs);
		}
		return message;
	}


/**
 * getting facility daily task list update records from db
 * @param ltspId
 * @param customerId
 * @param vehicleId
 * @return
 */

public JSONArray getFacilityDailyTaskListUpdate(String ltspId, String customerId, String vehicleId) {

	JSONArray jsonArray = new JSONArray();
	JSONObject jsonObject = new JSONObject();
	Connection conAms=null;
	PreparedStatement pstmt=null;
	ResultSet rs=null;
	
	try {
		jsonArray = new JSONArray();
		jsonObject = new JSONObject();
		
		String lastPakDt="Last Packet Date Time";
		String location="Location";
		String hidd="HID";
		String panic_label="Panic";
		String overspeed_label="Overspeed";
		String tripsheet_label="Tripsheet Data";
		String overspeeedemailalert_label="Over speed Email Alerts";
		String overspeedsmsAlert_label="Over speed SMS Alerts";
		String disemailAlert_label="Distress Email Alerts";
		String dissmsalert_label="Distress SMS Alerts";
		
		conAms=DBConnection.getConnectionToDB("AMS");
		
		//function To fetch Vehicle Last Packet Date Time and Location from dbo.gpsdata_history_latest table depending on Registration No and System Id
		pstmt=conAms.prepareStatement(EmployeetrackingStatements.GET_GPS_DATETIME_LOCATION);
		pstmt.setString(1, vehicleId);
		pstmt.setInt(2, Integer.parseInt(ltspId));
		pstmt.setInt(3, Integer.parseInt(customerId));
		rs=pstmt.executeQuery();
		jsonObject = new JSONObject();
		JSONObject jsonObject1 = new JSONObject();
		jsonObject.put("ITEMS", lastPakDt);
		jsonObject1.put("ITEMS", location);
		if(rs.next()){
			String LastPacketDatetime=rs.getString("GPS_DATETIME");
			jsonObject.put("DETAILS", LastPacketDatetime);
			String loc=rs.getString("LOCATION");
			jsonObject1.put("DETAILS", loc);
		}
		jsonArray.put(jsonObject);
		jsonArray.put(jsonObject1);
		pstmt=null;
		rs=null;
		//db function To fetch hid  from ALERT.dbo.SWIPE_DATA table depending on Registration No and System Id and customerId
		pstmt=conAms.prepareStatement(EmployeetrackingStatements.GET_HID);
		pstmt.setString(1, vehicleId);
		pstmt.setInt(2, Integer.parseInt(ltspId));
		pstmt.setInt(3, Integer.parseInt(customerId));
		rs=pstmt.executeQuery();
		jsonObject=new JSONObject();
		jsonObject.put("ITEMS", hidd);
		if(rs.next()){
			
			String hid=rs.getString("LOCAL_TIME");
			jsonObject.put("DETAILS", hid);
		}
		jsonArray.put(jsonObject);
		
		pstmt=null;
		rs=null;
		//function To fetch panic data from dbo.Alert table depending on Registration No and System Id
		pstmt=conAms.prepareStatement(EmployeetrackingStatements.GET_PANIC);
		pstmt.setString(1, vehicleId);
		pstmt.setInt(2, Integer.parseInt(ltspId));
		rs=pstmt.executeQuery();
		jsonObject=new JSONObject();
		jsonObject.put("ITEMS", panic_label);
		while(rs.next()){
			
			String panic=rs.getString("GPS_DATETIME");
			jsonObject.put("DETAILS", panic);
		}
		jsonArray.put(jsonObject);
			
		pstmt=null;
		rs=null;
		//function To fetch overspeed from dbo.Alert and table depending on Registration No and System Id
		pstmt=conAms.prepareStatement(EmployeetrackingStatements.GET_OVERSPEED);
		pstmt.setString(1, vehicleId);
		pstmt.setInt(2, Integer.parseInt(ltspId));
		rs=pstmt.executeQuery();
		jsonObject=new JSONObject();
		jsonObject.put("ITEMS", overspeed_label);
		while(rs.next()){
			
			String overSpeed=rs.getString("GPS_DATETIME");
			jsonObject.put("DETAILS", overSpeed);
		}
		jsonArray.put(jsonObject);
				
		pstmt=null;
		rs=null;
		//function To fetch tripsheet from System_Master table depending on Registration No and System Id and clientId
		pstmt=conAms.prepareStatement(EmployeetrackingStatements.GET_TRIPSHEET);
		pstmt.setString(1, vehicleId);
		pstmt.setInt(2, Integer.parseInt(ltspId));
		pstmt.setInt(3, Integer.parseInt(customerId));
		rs=pstmt.executeQuery();
		jsonObject=new JSONObject();
		while(rs.next()){
			
			String tripsheet=rs.getString("Date");
			jsonObject.put("DETAILS", tripsheet);
		}
		jsonObject.put("ITEMS", tripsheet_label);
		jsonArray.put(jsonObject);
	
		
		pstmt=null;
		rs=null;
		//function To fetch overspeed email from dbo.Alert table depending on Registration No and System Id
		pstmt=conAms.prepareStatement(EmployeetrackingStatements.GET_OVERSPEED_EMAIL);
		pstmt.setString(1, vehicleId);
		pstmt.setInt(2, Integer.parseInt(ltspId));
		rs=pstmt.executeQuery();
		jsonObject=new JSONObject();
		while(rs.next()){
			String overspeeedemailalert=rs.getString("GPS_DATETIME");
			jsonObject.put("DETAILS", overspeeedemailalert);
		}
		jsonObject.put("ITEMS", overspeeedemailalert_label);
		jsonArray.put(jsonObject);
			
		pstmt=null;
		rs=null;
		//function To fetch overspeed SMS from dbo.Alert table depending on Registration No and System Id
		pstmt=conAms.prepareStatement(EmployeetrackingStatements.GET_OVERSPEED_SMS);
		pstmt.setString(1, vehicleId);
		pstmt.setInt(2, Integer.parseInt(ltspId));
		rs=pstmt.executeQuery();
		jsonObject=new JSONObject();
		jsonObject.put("ITEMS", overspeedsmsAlert_label);
		while(rs.next()){
			String overspeedsmsAlert=rs.getString("GPS_DATETIME");
			jsonObject.put("DETAILS", overspeedsmsAlert);
		}
		jsonArray.put(jsonObject);
			
		pstmt=null;
		rs=null;
		//function to fetch distress email from dbo.Alert table depending on Registration No and System Id
		pstmt=conAms.prepareStatement(EmployeetrackingStatements.GET_DISTRESS_EMAIL);
		pstmt.setString(1, vehicleId);
		pstmt.setInt(2, Integer.parseInt(ltspId));
		rs=pstmt.executeQuery();
		jsonObject=new JSONObject();
		jsonObject.put("ITEMS", disemailAlert_label);
		while(rs.next()){
			String disemailAlert=rs.getString("GPS_DATETIME");
			jsonObject.put("DETAILS", disemailAlert);
		}
		jsonArray.put(jsonObject);
		
		
		pstmt=null;
		rs=null;
		//function To fetch  distress alert from dbo.Alert table depending on Registration No and System Id
		pstmt=conAms.prepareStatement(EmployeetrackingStatements.GET_DISTRESS_SMS);
		pstmt.setString(1, vehicleId);
		pstmt.setInt(2, Integer.parseInt(ltspId));
		rs=pstmt.executeQuery();
		jsonObject=new JSONObject();
		jsonObject.put("ITEMS", dissmsalert_label);
		while(rs.next()){
			String dissmsalert=rs.getString("GPS_DATETIME");
			jsonObject.put("DETAILS", dissmsalert);
		}
		jsonArray.put(jsonObject);
	
	
		
	} catch (Exception e) {
		System.out.println("Error in EmployeetrackingFunction:-getFacilityDailyTaskListUpdate"+e);
	}finally{
		DBConnection.releaseConnectionToDB(conAms, pstmt, rs);
	}
	return jsonArray;
	
}

/**
 * getting reporting and exit time daily task list update records from db
 * @param ltspId
 * @param userId
 * @return
 */
public JSONArray getReportingExittime(String ltspId, String userId) {
	JSONArray jsonArray=null;
	JSONObject jsonObject=null;
	Connection conAms=null;
	PreparedStatement pstmt=null;
	ResultSet rs=null;
	try {
	
		jsonArray=new JSONArray();
		jsonObject=new JSONObject();
		conAms=DBConnection.getConnectionToDB("AMS");
		int user=Integer.parseInt(userId.trim());
		int ltsp=Integer.parseInt(ltspId.trim());
		pstmt=conAms.prepareStatement(EmployeetrackingStatements.GET_REPORTEXITTIME);
        pstmt.setInt(1, ltsp);
        pstmt.setInt(2, user);
		rs=pstmt.executeQuery();
		if(rs.next()){
			jsonObject = new JSONObject();
			jsonObject.put("UserId", rs.getString("USER_ID"));
			String REPORTING_TIME="";
			if(rs.getString("REPORTING_TIME")!=null || rs.getString("REPORTING_TIME").contains("1900-01-01")){
				Date dd1=rs.getTimestamp("REPORTING_TIME");
				REPORTING_TIME=sdfddmmyyhhmm.format(dd1);
			}
			jsonObject.put("ReportTime", REPORTING_TIME);
			String EXIT_TIME="";
			if(rs.getString("EXIT_TIME")!=null || rs.getString("EXIT_TIME").contains("1900-01-01")){
				Date dd1=rs.getTimestamp("EXIT_TIME");
				EXIT_TIME=sdfddmmyyhhmm.format(dd1);
			}
			jsonObject.put("ExitTime", EXIT_TIME);
			jsonArray.put(jsonObject);
		}
		
		
	}catch(Exception e){
		System.out.println("Error in EmployeetrackingFunction:-getReportingExittime"+e);
		}finally{
			DBConnection.releaseConnectionToDB(conAms, pstmt, rs);
		}
	
	return jsonArray;
	}
	
@SuppressWarnings("unchecked")
public ArrayList<ArrayList> getStatusDetails(String clientId, int systemId,
		String startDate, String endDate, int offset) {
	Connection conAms=null;
	PreparedStatement pstmt=null;
	ResultSet rs=null;
	CachedRowSetImpl crs = null;
	ArrayList<ArrayList> finalReturnList = null;
	ArrayList<ArrayList> finalDataList = null;
	ArrayList<String> dateList = null;
	ArrayList<String> regNo = null;
	ArrayList dataList= null;
	Hashtable<String, StatusReportBean> dataTable = null;
	Hashtable<String, StatusReportTaskBean> taskTable = null;
	Hashtable<String, StatusReportVehicleBean> vehicleTable = null;
	StatusReportBean srb = null;
	StatusReportVehicleBean svb = null;
	StatusReportTaskBean stb = null;
	Date d = null;
	try {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		SimpleDateFormat sdfFormatDate = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
		
		finalReturnList = new ArrayList<ArrayList>();
		startDate=startDate.replaceAll("T", " ");
		endDate=endDate.replaceAll("T", " ");
		
		dataTable = new Hashtable<String, StatusReportBean>();
		taskTable = new Hashtable<String, StatusReportTaskBean>();
		vehicleTable = new Hashtable<String, StatusReportVehicleBean>();
		svb = new StatusReportVehicleBean();
		stb = new StatusReportTaskBean();
		dataList = new ArrayList();
		dateList = new ArrayList<String>();
		regNo = new ArrayList<String>();
		finalDataList = new ArrayList<ArrayList>();
		crs = new CachedRowSetImpl();
		conAms=DBConnection.getConnectionToDB("AMS");
		pstmt = conAms.prepareStatement(EmployeetrackingStatements.GET_DISTINCT_DATE);
		pstmt.setString(1, startDate);
		pstmt.setString(2, endDate);
		pstmt.setInt(3, systemId);
		pstmt.setString(4, clientId);
		rs=pstmt.executeQuery();
		String temp = null;
		while (rs.next()) {
			dateList.add(rs.getString("DATE"));
		}
		
		pstmt = conAms.prepareStatement(EmployeetrackingStatements.GET_STATUS_REPORT.toString());
		pstmt.setString(1, startDate);
		pstmt.setString(2, endDate);
		pstmt.setInt(3, systemId);
		pstmt.setString(4, clientId);
		rs = pstmt.executeQuery();
		crs.populate(rs);
		
		while (crs.next()) {
			srb = new StatusReportBean();
			svb = new StatusReportVehicleBean();
			if (!regNo.contains(crs.getString("REGISTRATION_NO"))) {
				regNo.add(crs.getString("REGISTRATION_NO"));
			}
			svb.setVehicleId(crs.getString("VEHICLE_ID"));
			svb.setUnitNo(crs.getString("Unit_Number"));
			svb.setUnitType(crs.getString("Unit_Type"));
			svb.setOwnerName(crs.getString("OwnerName"));
			vehicleTable.put(crs.getString("REGISTRATION_NO"), svb);
			
			if (crs.getString("LAST_OS")!=null) {
				d = sdf.parse(crs.getString("LAST_OS"));
				temp = sdfFormatDate.format(d);
				srb.setOverSpeed(temp);
			} else {
				srb.setOverSpeed("");
			}
			if (crs.getString("LAST_PANIC")!=null) {
				d = sdf.parse(crs.getString("LAST_PANIC"));
				temp = sdfFormatDate.format(d);
				srb.setPanic(temp);
			} else {
				srb.setPanic("");
			}
			if (crs.getString("LAST_SWIPE")!=null) {
				d = sdf.parse(crs.getString("LAST_SWIPE"));
				temp = sdfFormatDate.format(d);
				srb.setSwipe(temp);
			} else {
				srb.setSwipe("");
			}
			if (crs.getString("LAST_TRIP_SHEET")!=null) {
				d = sdf.parse(crs.getString("LAST_TRIP_SHEET"));
				temp = sdfFormatDate.format(d);
				srb.setLastTripSheet(temp);
			} else {
				srb.setLastTripSheet("");
			}
			if (crs.getString("LAST_OS_EMAIL")!=null) {
				d = sdf.parse(crs.getString("LAST_OS_EMAIL"));
				temp = sdfFormatDate.format(d);
				srb.setOverSpeedEmail(temp);
			} else {
				srb.setOverSpeedEmail("");
			}
			if (crs.getString("LAST_OS_SMS")!=null) {
				d = sdf.parse(crs.getString("LAST_OS_SMS"));
				temp = sdfFormatDate.format(d);
				srb.setOverSpeedSMS(temp);
			} else {
				srb.setOverSpeedSMS("");
			}
			if (crs.getString("LAST_PANIC_SMS")!=null) {
				d = sdf.parse(crs.getString("LAST_PANIC_SMS"));
				temp = sdfFormatDate.format(d);
				srb.setPanicSMS(temp);
			} else {
				srb.setPanicSMS("");
			}
			
			if (crs.getString("LAST_PANIC_EMAIL")!=null) {
				d = sdf.parse(crs.getString("LAST_PANIC_EMAIL"));
				temp = sdfFormatDate.format(d);
				srb.setPanicEmail(temp);
			} else {
				srb.setPanicEmail("");
			}
			if (crs.getString("GMT")!=null) {
				d = sdf.parse(crs.getString("GMT"));
				temp = sdfFormatDate.format(d);
				srb.setGmt(temp);
			} else {
				srb.setGmt("");
			}
			if (crs.getString("LOCATION")!=null) {
				srb.setLocation(crs.getString("LOCATION"));
			} else {
				srb.setLocation("");
			}
			dataTable.put(crs.getString("DATE")+" "+crs.getString("REGISTRATION_NO"), srb);
		}
		if (crs!= null) {
			crs.close();
		}
		
		crs = new CachedRowSetImpl();
		pstmt = conAms.prepareStatement(EmployeetrackingStatements.GET_TRACKER_REPORT.toString());
		pstmt.setString(1, startDate);
		pstmt.setString(2, endDate);
		pstmt.setInt(3, systemId);
		pstmt.setString(4, clientId);
		rs = pstmt.executeQuery();
		crs.populate(rs);
		DBConnection.releaseConnectionToDB(conAms, pstmt, rs);
		while (crs.next()) {
			
			if (taskTable.containsKey(crs.getString("DATE")+" "+crs.getString("REGISTRATION_NO"))) {
				continue;
			}
			
			stb = new StatusReportTaskBean();
			
			if (crs.getString("LAST_OS_REMARKS")!=null) {
				stb.setOverSpeed(crs.getString("LAST_OS_REMARKS"));
			} else {
				stb.setOverSpeed("");
			}
			if (crs.getString("LAST_PANIC_REMARKS")!=null) {
				stb.setPanic(crs.getString("LAST_PANIC_REMARKS"));
			} else {
				stb.setPanic("");
			}
			if (crs.getString("LAST_SWIPE_REMARKS")!=null) {
				stb.setSwipe(crs.getString("LAST_SWIPE_REMARKS"));
			} else {
				stb.setSwipe("");
			}
			if (crs.getString("LAST_TRIP_SHEET_REMARKS")!=null) {
				stb.setLastTripSheet(crs.getString("LAST_TRIP_SHEET_REMARKS"));
			} else {
				stb.setLastTripSheet("");
			}
			if (crs.getString("LAST_OS_EMAIL_REMARKS")!=null) {
				stb.setOverSpeedEmail(crs.getString("LAST_OS_EMAIL_REMARKS"));
			} else {
				stb.setOverSpeedEmail("");
			}
			if (crs.getString("LAST_OS_SMS_REMARKS")!=null) {
				stb.setOverSpeedSMS(crs.getString("LAST_OS_SMS_REMARKS"));
			} else {
				stb.setOverSpeedSMS("");
			}
			if (crs.getString("LAST_PANIC_SMS_REMARKS")!=null) {
				stb.setPanicSMS(crs.getString("LAST_PANIC_SMS_REMARKS"));
			} else {
				stb.setPanicSMS("");
			}
			if (crs.getString("LAST_PANIC_EMAIL_REMARKS")!=null) {
				stb.setPanicEmail(crs.getString("LAST_PANIC_EMAIL_REMARKS"));
			} else {
				stb.setPanicEmail("");
			}
			
			taskTable.put(crs.getString("DATE")+" "+crs.getString("REGISTRATION_NO"), stb);
		}
		
		srb = new StatusReportBean();
		svb = new StatusReportVehicleBean();
		stb = new StatusReportTaskBean();
		for (String vehicleNo : regNo) {
			svb=vehicleTable.get(vehicleNo);
			dataList = new ArrayList();
			dataList.add(vehicleNo);
			dataList.add(svb.getVehicleId());
			dataList.add(svb.getOwnerName());
			dataList.add(svb.getUnitNo());
			dataList.add(svb.getUnitType());
			for (int i=0; i<8; i++) {
				if (i==0) {
					dataList.add("Location");
				} else if (i==1) {
					dataList = new ArrayList();
					dataList.add("");
					dataList.add("");
					dataList.add("");
					dataList.add("");
					dataList.add("");
					dataList.add("GMT");
				} else if (i==2) {
					dataList = new ArrayList();
					dataList.add("");
					dataList.add("");
					dataList.add("");
					dataList.add("");
					dataList.add("");
					dataList.add("Over Speed");
				} else if (i==3) {
					dataList = new ArrayList();
					dataList.add("");
					dataList.add("");
					dataList.add("");
					dataList.add("");
					dataList.add("");
					dataList.add("Panic");
				} else if (i==4) {
					dataList = new ArrayList();
					dataList.add("");
					dataList.add("");
					dataList.add("");
					dataList.add("");
					dataList.add("");
					dataList.add("Swipe");
				} else if (i==5) {
					dataList = new ArrayList();
					dataList.add("");
					dataList.add("");
					dataList.add("");
					dataList.add("");
					dataList.add("");
					dataList.add("Trip Sheet");
				} else if (i==6) {
					dataList = new ArrayList();
					dataList.add("");
					dataList.add("");
					dataList.add("");
					dataList.add("");
					dataList.add("");
					dataList.add("Over Speed Email");
				} else if (i==7) {
					dataList = new ArrayList();
					dataList.add("");
					dataList.add("");
					dataList.add("");
					dataList.add("");
					dataList.add("");
					dataList.add("Over Speed SMS");
				} else if (i==8) {
					dataList = new ArrayList();
					dataList.add("");
					dataList.add("");
					dataList.add("");
					dataList.add("");
					dataList.add("");
					dataList.add("Panic Email");
				} else if (i==9) {
					dataList = new ArrayList();
					dataList.add("");
					dataList.add("");
					dataList.add("");
					dataList.add("");
					dataList.add("");
					dataList.add("Panic SMS");
				}
				
				for (String date : dateList) {
					if (dataTable.get(date+" "+vehicleNo)!=null) {
						srb = dataTable.get(date+" "+vehicleNo);
						if (i==0) {
							dataList.add(srb.getLocation());
						} else if (i==1) {
							dataList.add(srb.getGmt());
						} else if (i==2) {
							dataList.add(srb.getOverSpeed());
						} else if (i==3) {
							dataList.add(srb.getPanic());
						} else if (i==4) {
							dataList.add(srb.getSwipe());
						} else if (i==5) {
							dataList.add(srb.getLastTripSheet());
						} else if (i==6) {
							dataList.add(srb.getOverSpeedEmail());
						} else if (i==7) {
							dataList.add(srb.getOverSpeedSMS());
						} else if (i==8) {
							dataList.add(srb.getPanicEmail());
						} else if (i==9) {
							dataList.add(srb.getPanicSMS());
						}
					} else {
						dataList.add("");
					}
					
					if (taskTable.get(date+" "+vehicleNo)!=null) {
						stb = taskTable.get(date+" "+vehicleNo);
						if (i==0) {
							dataList.add("-");
						} else if (i==1) {
							dataList.add("-");
						} else if (i==2) {
							dataList.add(stb.getOverSpeed());
						} else if (i==3) {
							dataList.add(stb.getPanic());
						} else if (i==4) {
							dataList.add(stb.getSwipe());
						} else if (i==5) {
							dataList.add(stb.getLastTripSheet());
						} else if (i==6) {
							dataList.add(stb.getOverSpeedEmail());
						} else if (i==7) {
							dataList.add(stb.getOverSpeedSMS());
						} else if (i==8) {
							dataList.add(stb.getPanicEmail());
						} else if (i==9) {
							dataList.add(stb.getPanicSMS());
						}
					} else {
						dataList.add("");
					}
				}
				finalDataList.add(dataList);
			}
		}
	} catch (Exception e) {
		e.printStackTrace();
	} finally {
		finalReturnList.add(finalDataList);
		finalReturnList.add(dateList);
		DBConnection.releaseConnectionToDB(conAms, pstmt, rs);
	}
	return finalReturnList;
}
public List getVehiclesforManageRoute(String systemid,String clientid,int userId)
{
	List VehicleList=new ArrayList();
	Connection con=null;
	PreparedStatement pstmt=null;
	ResultSet rs=null;
	
	try
	{
	    con=DBConnection.getConnectionToDB("AMS");
	    
		pstmt=con.prepareStatement(EmployeetrackingStatements.GET_VEHICLE_USING_CLIENTID_FOR_MANAGE_ROUTE);
		pstmt.setInt(1,Integer.parseInt(clientid));
		pstmt.setInt(2,Integer.parseInt(systemid));
		pstmt.setInt(3,userId);

		rs=pstmt.executeQuery();
		
		VehicleList.add(new LabelValueBean("All","0"));
		
		while(rs.next())
		{
			VehicleList.add(new LabelValueBean(rs.getString(1),rs.getString(1)));
		}
	}
	catch(Exception e)
	{
		e.printStackTrace();
	  System.out.println("Error getting Vehicle List using client Id  : " + e);
	}
	finally
	{
		DBConnection.releaseConnectionToDB(con, pstmt, rs);
	}
	return VehicleList;
}
public String insertRouteInformation(int custId, String routeCode, String startTime, String endTime, String approxDistance, String approxTime, String assetNumber, int systemId, int userId,String pickDrop) {
    Connection con = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    PreparedStatement pstmt1 = null;
    PreparedStatement pstmt2 = null;
    ResultSet rs1 = null;
    String message = "";
    try {
    	startTime = startTime.replace(":", ".");
    	endTime = endTime.replace(":", ".");
    	approxTime = approxTime.replace(":", ".");
    	float sTime = Float.parseFloat(startTime);
    	float eTime = Float.parseFloat(endTime);
    	float aTime = Float.parseFloat(approxTime);
    	float aDist = Float.parseFloat(approxDistance);
    	int routeId = 0;
    	con = DBConnection.getConnectionToDB("AMS");
    	con.setAutoCommit(false);
    	pstmt = con.prepareStatement(EmployeetrackingStatements.CHECK_ROUTE_INFORMATION);
    	pstmt.setString(1,routeCode.toUpperCase());
    	pstmt.setString(2,pickDrop);
    	rs=pstmt.executeQuery();
     	if(!rs.next())
    	{
        pstmt1 = con.prepareStatement(EmployeetrackingStatements.INSERT_ROUTE_INFORMATION,Statement.RETURN_GENERATED_KEYS);
        pstmt1.setString(1, routeCode.toUpperCase());
        pstmt1.setString(2, routeCode.toUpperCase());
        pstmt1.setFloat(3, sTime);
        pstmt1.setFloat(4, eTime);
        pstmt1.setFloat(5, aTime);
        pstmt1.setFloat(6, aDist);
        pstmt1.setInt(7, systemId);
        pstmt1.setInt(8, custId);
        pstmt1.setInt(9, userId);
        pstmt1.setString(10, pickDrop);
        pstmt1.executeUpdate();
        rs=pstmt1.getGeneratedKeys();
        if(rs.next())
		{
        	routeId=rs.getInt(1);
		}
        pstmt2 = con.prepareStatement(EmployeetrackingStatements.INSERT_ASSET_INFORMATION);
        pstmt2.setInt(1, routeId);
        pstmt2.setString(2, assetNumber);
        int inserted = pstmt2.executeUpdate();
        con.commit();
        if (inserted > 0) {
            message = "Saved Successfully";
        }
    	} 
    	else {
    		 message = "Route Code already exists";
    	}
        } catch (Exception e) {
        	if (con!=null) {
    			try {
    				con.rollback();
    			} catch (SQLException e1) {
    				e1.printStackTrace();
    			}
    		}
       e.printStackTrace();
        } finally {
        DBConnection.releaseConnectionToDB(con, pstmt, rs);
        DBConnection.releaseConnectionToDB(null, pstmt1, null);
        DBConnection.releaseConnectionToDB(null, pstmt2, null);
    }
    return message;
}

public String modifyRouteInformation(int custId, String routeCode, String startTime, String endTime, String approxDistance, String approxTime, String assetNumber, int systemId,int Id,String pickDrop,int userId) {
    Connection con = null;
    PreparedStatement pstmt = null;
    PreparedStatement pstmt1 = null;
    PreparedStatement pstmt2 = null;
    ResultSet rs = null;
    String message = "";
    try {
        con = DBConnection.getConnectionToDB("AMS");
        startTime = startTime.replace(":", ".");
    	endTime = endTime.replace(":", ".");
    	approxTime = approxTime.replace(":", ".");
    	float sTime = Float.parseFloat(startTime);
    	float eTime = Float.parseFloat(endTime);
    	float aTime = Float.parseFloat(approxTime);
    	float aDist = Float.parseFloat(approxDistance);
    	con.setAutoCommit(false);

    	
    	pstmt = con.prepareStatement(EmployeetrackingStatements.CHECK_ROUTE_CODE_INFORMATION);
    	pstmt.setString(1,routeCode.toUpperCase());
    	pstmt.setString(2,pickDrop);
    	pstmt.setInt(3,Id);
    	rs=pstmt.executeQuery();

    	if(!rs.next())
    	{
        pstmt1 = con.prepareStatement(EmployeetrackingStatements.UPDATE_ROUTE_INFORMATION);
        pstmt1.setFloat(1, sTime);
        pstmt1.setFloat(2, eTime);
        pstmt1.setFloat(3, aDist);
        pstmt1.setFloat(4, aTime);
        pstmt1.setString(5, routeCode.toUpperCase());
        pstmt1.setString(6, pickDrop);
        pstmt1.setString(7, routeCode.toUpperCase());
        pstmt1.setInt(8, userId);
        pstmt1.setInt(9, Id);
        pstmt1.setInt(10, systemId);
        pstmt1.setInt(11, custId);
        pstmt1.executeUpdate();
        
        pstmt2 = con.prepareStatement(EmployeetrackingStatements.UPDATE_ASSET_INFORMATION);
        pstmt2.setString(1, assetNumber);
        pstmt2.setInt(2, Id);
        int updated = pstmt2.executeUpdate();
        con.commit();
        if (updated > 0) {
        	message = "Updated Successfully";
        	}
        
        } 

    else {
    	message = "Route Code already exists";
    }
    }
    catch (Exception e) {
    	if (con!=null) {
			try {
				con.rollback();
			} catch (SQLException e1) {
				e1.printStackTrace();
			}
		}

        e.printStackTrace();
        }
    finally {
    	DBConnection.releaseConnectionToDB(null, pstmt1, null);
        DBConnection.releaseConnectionToDB(con, pstmt, rs);
        DBConnection.releaseConnectionToDB(null, pstmt2, null);
    }
    return message;
}

public String deleteRecord(int custId, int systemId,int Id) {
    Connection con = null;
    PreparedStatement pstmt = null;
    PreparedStatement pstmt1 = null;
    String message = "";
    try {
        con = DBConnection.getConnectionToDB("AMS");
        con.setAutoCommit(false);
        pstmt = con.prepareStatement(EmployeetrackingStatements.DELETE_ROUTE_INFORMATION);
        pstmt.setInt(1, Id);
        pstmt.setInt(2, systemId);
        pstmt.setInt(3, custId);
        pstmt.executeUpdate();
        
        pstmt = con.prepareStatement(EmployeetrackingStatements.DELETE_ASSET_INFORMATION);
        pstmt.setInt(1, Id);
        pstmt.executeUpdate();
        
        pstmt1 = con.prepareStatement(EmployeetrackingStatements.DELETE_ETMS_EMPLOYEE_ROUTE_MAPPING);
        pstmt1.setInt(1, Id);
        int inserted = pstmt1.executeUpdate();
        con.commit();
        if (inserted > 0) {
        	 message = "Deleted Successfully";
        }
        } catch (Exception e) {
        	if (con!=null) {
    			try {
    				con.rollback();
    			} catch (SQLException e1) {
    				e1.printStackTrace();
    			}
    		}
        e.printStackTrace();
        
    } finally {
        DBConnection.releaseConnectionToDB(con, pstmt, null);
        DBConnection.releaseConnectionToDB(null, pstmt1, null);
    }
    return message;
}

public ArrayList getManageRouteDetails(int customerId,int systemId,int offset) {
	JSONArray jsonArray=null;
	JSONObject jsonObject=null;
	Connection conAms=null;
	PreparedStatement pstmt=null;
	ResultSet rs=null;
	DecimalFormat dc = new DecimalFormat("00.00");
	SimpleDateFormat sdf = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
	int count = 0;
	ArrayList<Object> assetList = new ArrayList<Object>();
	ArrayList<ReportHelper> reportsList = new ArrayList<ReportHelper>();
	ArrayList<String> headersList = new ArrayList<String>();
	ReportHelper finalreporthelper = new ReportHelper();

	headersList.add("Sl No");
	headersList.add("Route Code");
	headersList.add("Start Time(HH:MM)");
	headersList.add("End Time(HH:MM)");
	headersList.add("Approximate Distance(Kms)");
	headersList.add("Approximate Time(HH:MM)");
	headersList.add("Asset Number");
	headersList.add("Type");
	headersList.add("Updated Time");
	headersList.add("ID");
	try {
	
		jsonArray=new JSONArray();
		jsonObject=new JSONObject();
		conAms=DBConnection.getConnectionToDB("AMS");
		pstmt=conAms.prepareStatement(EmployeetrackingStatements.GET_MANAGE_ROUTE_DETAILS);
		pstmt.setInt(1, offset);
		pstmt.setInt(2, systemId);
        pstmt.setInt(3, customerId);
        
        rs=pstmt.executeQuery();
		while(rs.next()){
			jsonObject = new JSONObject();
			count++;
			jsonObject.put("slnoIndex", count);
			ArrayList<Object> informationList = new ArrayList<Object>();
			ReportHelper reporthelper = new ReportHelper();
			informationList.add(count);
			
			jsonObject.put("routeCodeIndex", rs.getString("CUSTOMER_ROUTE_ID"));
			informationList.add(rs.getString("CUSTOMER_ROUTE_ID"));
			
			jsonObject.put("startTimeIndex",dc.format(rs.getFloat("START_TIME")).replace(".",":"));
			informationList.add(dc.format(rs.getFloat("START_TIME")).replace(".",":"));
			
			jsonObject.put("endTimeIndex",dc.format(rs.getFloat("END_TIME")).replace(".",":"));
			informationList.add(dc.format(rs.getFloat("END_TIME")).replace(".",":"));
			
			jsonObject.put("approximateDistanceIndex", rs.getString("DISTANCE"));
			informationList.add(rs.getString("DISTANCE"));
			
			jsonObject.put("approximateTimeIndex", dc.format(rs.getFloat("DURATION")).replace(".",":"));
			informationList.add(dc.format(rs.getFloat("DURATION")).replace(".",":"));
			
			jsonObject.put("assetNumberIndex", rs.getString("ASSET_NUMBER"));
			informationList.add(rs.getString("ASSET_NUMBER"));
			
			jsonObject.put("pickDropDataIndex", rs.getString("TYPE"));
			informationList.add(rs.getString("TYPE"));
			
			String UPDATED_DATETIME="";
			if(rs.getString("UPDATED_DATETIME")!=null && !rs.getString("UPDATED_DATETIME").contains("1900-01-01")){
				Date dd1=rs.getTimestamp("UPDATED_DATETIME");
				UPDATED_DATETIME=sdf.format(dd1);
			}
			jsonObject.put("updatedDatetimeDataIndex", UPDATED_DATETIME);
			informationList.add(UPDATED_DATETIME);
			
			jsonObject.put("idDataIndex", rs.getInt("ROUTE_ID"));
			informationList.add(rs.getInt("ROUTE_ID"));
			
			jsonArray.put(jsonObject);
			reporthelper.setInformationList(informationList);
			reportsList.add(reporthelper);
		}
		finalreporthelper.setReportsList(reportsList);
		finalreporthelper.setHeadersList(headersList);
		assetList.add(jsonArray);
		assetList.add(finalreporthelper);
		
	}catch(Exception e){
		System.out.println("Error in EmployeetrackingFunction:-getReportingExittime"+e);
		}finally{
			DBConnection.releaseConnectionToDB(conAms, pstmt, rs);
		}
	
	return assetList;
	}

public JSONArray getRouteName(int customerId,int systemId,int type) {
	JSONArray jsonArray = null;
	JSONObject jsonObject = null;
	Connection conAms=null;
	PreparedStatement pstmt=null;
	ResultSet rs=null;
	String routeType="";
	try {
		jsonArray = new JSONArray();
		jsonObject = new JSONObject();
        conAms=DBConnection.getConnectionToDB("AMS");
        if(type==1)
        {
        	routeType="PickUp%";
        }else if(type==2)
        {
        	routeType="Drop%";
        }
		pstmt=conAms.prepareStatement(EmployeetrackingStatements.GET_ROUTE_NAME);
		pstmt.setInt(1,customerId);
		pstmt.setInt(2,systemId);
		pstmt.setString(3, routeType);
		rs=pstmt.executeQuery();
		while(rs.next()){
			jsonObject = new JSONObject();
			jsonObject.put("Route_Id", rs.getString("ROUTE_ID"));
			jsonObject.put("Route_Name", rs.getString("ROUTE_NAME"));
			jsonArray.put(jsonObject);
		}
	} catch (Exception e) {
		System.out.println("Error in EmployeetrackingFunction:-getLTSP "+e.toString());
	}finally{
		DBConnection.releaseConnectionToDB(conAms, pstmt, rs);
	}
	return jsonArray;
}

public String insertEmployeeInformation(int custId, String employeeName, String employeeId, String mobileNo, String rfidKey, 
		String latitude, String longitude, int systemId, String emailId,String gender,String routeId,String dropRouteName) {
    Connection con = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    PreparedStatement pstmt1 = null;
    PreparedStatement pstmt2 = null;
    PreparedStatement pstmt3 = null;
    String message = "";
    int empId=0;
    float flatitude = 0;
    float flongitude = 0;
    try {
    	con = DBConnection.getConnectionToDB("AMS");
    	con.setAutoCommit(false);
    	pstmt = con.prepareStatement(EmployeetrackingStatements.CHECK_EMPLOYEE_INFORMATION);
    	pstmt.setString(1,employeeId);
    	rs=pstmt.executeQuery();
    	if(!latitude.equals(""))
    	{
    	flatitude = Float.parseFloat(latitude);
    	}
    	if(!longitude.equals(""))
    	{
    	flongitude = Float.parseFloat(longitude);
    	}
    	if(!rs.next())
    	{
        pstmt1 = con.prepareStatement(EmployeetrackingStatements.INSERT_EMPLOYEE_INFORMATION,Statement.RETURN_GENERATED_KEYS);
        pstmt1.setString(1, employeeName);
        pstmt1.setString(2, employeeId);
        pstmt1.setString(3, mobileNo);
        pstmt1.setString(4, rfidKey.toUpperCase());
        pstmt1.setFloat(5, flatitude);
        pstmt1.setFloat(6, flongitude);
        pstmt1.setString(7, emailId);
        pstmt1.setString(8, gender);
        pstmt1.setInt(9, systemId);
        pstmt1.setInt(10, custId);
        pstmt1.executeUpdate();
        rs=pstmt1.getGeneratedKeys();
        if(rs.next())
		{
        	empId=rs.getInt(1);
		}
        pstmt2 = con.prepareStatement(EmployeetrackingStatements.INSERT_EMPLOYEE_ID_INFORMATION);
        pstmt2.setInt(1, empId);
        pstmt2.setString(2, routeId);
        pstmt2.setString(3, "PickUp");
        pstmt2.executeUpdate();
        
        pstmt3 = con.prepareStatement(EmployeetrackingStatements.INSERT_EMPLOYEE_ID_INFORMATION);
        pstmt3.setInt(1, empId);
        pstmt3.setString(2, dropRouteName);
        pstmt3.setString(3, "Drop");
        int inserted = pstmt3.executeUpdate();
        con.commit();
        if (inserted > 0) {
            message = "Saved Successfully";
        }
    	} else {
    		 message = "Employee Id already exists";
    	}
        } catch (Exception e) {
        	if (con!=null) {
    			try {
    				con.rollback();
    			} catch (SQLException e1) {
    				e1.printStackTrace();
    			}
    		}
        e.printStackTrace();
        } finally {
        DBConnection.releaseConnectionToDB(con, pstmt, rs);
        DBConnection.releaseConnectionToDB(null, pstmt1, null);
        DBConnection.releaseConnectionToDB(null, pstmt2, null);
        DBConnection.releaseConnectionToDB(null, pstmt3, null);
    }
    return message;
}

public String modifyEmployeeInformation(int custId, String employeeName, String employeeId, String mobileNo, String rfidKey, 
		String latitude, String longitude, int systemId,int Id,String emailId,String gender,String routeId,String gridRouteId,String gridGender,String dropRouteName,String gridRouteIdForDrop) {
    Connection con = null;
    PreparedStatement pstmt = null;
    PreparedStatement pstmt1 = null;
    PreparedStatement pstmt2 = null;
    PreparedStatement pstmt3 = null;
    ResultSet rs = null;
    ResultSet rs1 = null;
    String message = "";
    float flatitude = 0;
    float flongitude = 0;
    int updated=0;
    try {
        con = DBConnection.getConnectionToDB("AMS");
        con.setAutoCommit(false);
        pstmt = con.prepareStatement(EmployeetrackingStatements.CHECK_EMPLOYEE_ID_INFORMATION);
    	pstmt.setString(1,employeeId);
    	pstmt.setInt(2,Id);
    	rs=pstmt.executeQuery();
    	if(!latitude.equals(""))
    	{
    	flatitude = Float.parseFloat(latitude);
    	}
    	if(!longitude.equals(""))
    	{
    	flongitude = Float.parseFloat(longitude);
    	}
    	if(!rs.next())
    	{
        pstmt1 = con.prepareStatement(EmployeetrackingStatements.UPDATE_EMPLOYEE_INFORMATION);
        pstmt1.setString(1, employeeName);
        pstmt1.setString(2, employeeId);
        pstmt1.setString(3, mobileNo);
        pstmt1.setString(4, rfidKey.toUpperCase());
        pstmt1.setFloat(5, flatitude);
        pstmt1.setFloat(6, flongitude);
        pstmt1.setString(7, emailId);
        pstmt1.setString(8, gridGender);
        pstmt1.setInt(9, Id);
        pstmt1.setInt(10, systemId);
        pstmt1.setInt(11, custId);
        pstmt1.executeUpdate();
        
        
        pstmt2 = con.prepareStatement(EmployeetrackingStatements.CHECK_IF_PRESENT);
        pstmt2.setInt(1, Id);
        pstmt2.setString(2, "PickUp");
        rs=pstmt2.executeQuery();
        if(rs.next())
        {
            pstmt2 = con.prepareStatement(EmployeetrackingStatements.UPDATE_EMPLOYEE_ID_INFORMATION);
            pstmt2.setString(1, gridRouteId);
            pstmt2.setInt(2, Id);
            pstmt2.setString(3, "PickUp");
            updated = pstmt2.executeUpdate();
        }else
        { 
        pstmt2 = con.prepareStatement(EmployeetrackingStatements.INSERT_EMPLOYEE_ID_INFORMATION_FOR_PICKUP);
        pstmt2.setString(1, gridRouteId);
        pstmt2.setInt(2, Id);
        pstmt2.setString(3, "PickUp");
        updated = pstmt2.executeUpdate();
        }
        
        
        pstmt2 = con.prepareStatement(EmployeetrackingStatements.CHECK_IF_PRESENT);
        pstmt2.setInt(1, Id);
        pstmt2.setString(2, "Drop");
        rs1=pstmt2.executeQuery();
        if(rs1.next())
        {
         pstmt3 = con.prepareStatement(EmployeetrackingStatements.UPDATE_EMPLOYEE_ID_INFORMATION);
         pstmt3.setString(1, gridRouteIdForDrop);
         pstmt3.setInt(2, Id);
         pstmt3.setString(3, "Drop");
         updated = pstmt3.executeUpdate();
        }else
        {
            pstmt2 = con.prepareStatement(EmployeetrackingStatements.INSERT_EMPLOYEE_ID_INFORMATION_FOR_PICKUP);
            pstmt2.setString(1, gridRouteIdForDrop);
            pstmt2.setInt(2, Id);
            pstmt2.setString(3, "Drop");
            updated = pstmt2.executeUpdate();

        }
         con.commit();
         if (updated > 0) {
        	message = "Updated Successfully";
        	}
    	}
      else {
    	message = "Employee Id already exists";
    }
    }
    catch (Exception e) {
    	if (con!=null) {
			try {
				con.rollback();
			} catch (SQLException e1) {
				e1.printStackTrace();
			}
		}
        e.printStackTrace();
        }
    finally {
    	DBConnection.releaseConnectionToDB(null, pstmt1, null);
        DBConnection.releaseConnectionToDB(con, pstmt, rs);
        DBConnection.releaseConnectionToDB(null, pstmt2, null);
        DBConnection.releaseConnectionToDB(null, pstmt3, null);
    }
    return message;
}

public String deleteRecordForEmployee(int custId, int systemId,int Id) {
    Connection con = null;
    PreparedStatement pstmt = null;
    PreparedStatement pstmt1 = null;
    String message = "";
    try {
        con = DBConnection.getConnectionToDB("AMS");
        con.setAutoCommit(false);
        pstmt = con.prepareStatement(EmployeetrackingStatements.DELETE_EMPLOYEE_INFORMATION);
        pstmt.setInt(1, Id);
        pstmt.setInt(2, systemId);
        pstmt.setInt(3, custId);
        pstmt.executeUpdate();
        
        pstmt1 = con.prepareStatement(EmployeetrackingStatements.DELETE_EMPLOYEE_ID_INFORMATION);
        pstmt1.setInt(1, Id);
        int deleted = pstmt1.executeUpdate();
        con.commit();
        if (deleted > 0) {
        	 message = "Deleted Successfully";
        }
        
        } catch (Exception e) {
        	if (con!=null) {
    			try {
    				con.rollback();
    			} catch (SQLException e1) {
    				e1.printStackTrace();
    			}
    		}
        e.printStackTrace();
        
    } finally {
        DBConnection.releaseConnectionToDB(con, pstmt, null);
        DBConnection.releaseConnectionToDB(null, pstmt1, null);
    }
    return message;
}

public ArrayList < Object >  getEmployeeRouteDetails(int customerId,int systemId,String language) {
	JSONArray jsonArray=null;
	JSONObject jsonObject=null;
	Connection conAms=null;
	PreparedStatement pstmt=null;
	ResultSet rs=null;
	CommonFunctions cf=new CommonFunctions();
	ArrayList < ReportHelper > reportsList = new ArrayList < ReportHelper > ();
	ArrayList < String > headersList = new ArrayList < String > ();
	ReportHelper finalreporthelper = new ReportHelper();
	ArrayList < Object > alist = new ArrayList < Object > ();
	DecimalFormat dc = new DecimalFormat("00.00");
	int count=0;
	try {
		
		
	headersList.add(cf.getLabelFromDB("SLNO", language));
	headersList.add(cf.getLabelFromDB("Employee_Name", language));
	headersList.add(cf.getLabelFromDB("Employee_Id", language));
	headersList.add(cf.getLabelFromDB("Mobile_No", language));
	headersList.add(cf.getLabelFromDB("Rfid_Key", language));
	headersList.add(cf.getLabelFromDB("Latitude", language));
	headersList.add(cf.getLabelFromDB("Longitude", language));
	headersList.add(cf.getLabelFromDB("Email_ID", language));
	headersList.add(cf.getLabelFromDB("Gender", language));
	headersList.add(cf.getLabelFromDB("Id", language));
	headersList.add(cf.getLabelFromDB("PickUp_Route_Name", language));
	headersList.add(cf.getLabelFromDB("Drop_Route_Name", language));
	headersList.add(cf.getLabelFromDB("Route_Id", language));
	headersList.add(cf.getLabelFromDB("Route_Id_For_Drop", language));
	headersList.add(cf.getLabelFromDB("Gender_Id", language));
	
	
		jsonArray=new JSONArray();
		jsonObject=new JSONObject();
		conAms=DBConnection.getConnectionToDB("AMS");
		pstmt=conAms.prepareStatement(EmployeetrackingStatements.GET_EMPLOYEE_ROUTE_DETAILS);
        pstmt.setInt(1, systemId);
        pstmt.setInt(2, customerId);
        rs=pstmt.executeQuery();
		while(rs.next()){
			ReportHelper reporthelper = new ReportHelper();
			count++;
			jsonObject = new JSONObject();
			ArrayList < Object > informationList = new ArrayList < Object > ();
		
			informationList.add(count);
			jsonObject.put("slnoIndex", count);
		///.put("slnoIndex", count);

			//informationList.add(count);
			
			
			jsonObject.put("employeeNameIndex", rs.getString("EMPLOYEE_NAME"));
			informationList.add(rs.getString("EMPLOYEE_NAME"));
			
			jsonObject.put("employeeIdIndex",rs.getString("EMPLOYEE_ID"));
			informationList.add(rs.getString("EMPLOYEE_ID"));
			
			jsonObject.put("mobileNoIndex",rs.getString("MOBILE_NO"));
			informationList.add(rs.getString("MOBILE_NO"));
			
			jsonObject.put("rfidKeyIndex", rs.getString("RFID_KEY").toUpperCase());
			informationList.add(rs.getString("RFID_KEY").toUpperCase());
			
			jsonObject.put("lattitudeIndex", rs.getFloat("LATITUDE"));
			informationList.add(rs.getString("LATITUDE"));
			
			jsonObject.put("longitudeIndex", rs.getFloat("LONGITUDE"));
			informationList.add(rs.getString("LONGITUDE"));
			
			jsonObject.put("emailIndex", rs.getString("EMAIL"));
			informationList.add(rs.getString("EMAIL"));
			
			if(rs.getString("GENDER").equals("M"))
			{
			jsonObject.put("genderIndex","Male" );
			informationList.add("MALE");
			} else if(rs.getString("GENDER").equals("F"))
			{
			jsonObject.put("genderIndex","Female" );
			informationList.add("FEMALE");
			} else {
			jsonObject.put("genderIndex","" );	
			informationList.add("");
			}
			
			jsonObject.put("idIndex", rs.getInt("ID"));
			informationList.add(rs.getInt("ID"));
			
			if(rs.getString("ROUTE_NAME").equals("") || rs.getString("ROUTE_NAME")== null )
			{
				jsonObject.put("pickUpRouteNameIndex", "");	
				informationList.add("");
			}else
			{
				jsonObject.put("pickUpRouteNameIndex", rs.getString("ROUTE_NAME"));
				informationList.add(rs.getString("ROUTE_NAME"));
			}
			
			if(rs.getString("ROUTE_NAME_FOR_DROP").equals("") || rs.getString("ROUTE_NAME_FOR_DROP")== null )
			{
				jsonObject.put("dropRouteNameIndex", "");
				informationList.add("");
			}else
			{
				jsonObject.put("dropRouteNameIndex", rs.getString("ROUTE_NAME_FOR_DROP"));
				informationList.add(rs.getString("ROUTE_NAME_FOR_DROP"));
			}

			
			
			//jsonObject.put("pickUpRouteNameIndex", rs.getString("ROUTE_NAME"));
			//jsonObject.put("dropRouteNameIndex", rs.getString("ROUTE_NAME_FOR_DROP"));
	
			jsonObject.put("routeIdIndex", rs.getString("ROUTE_ID"));
			informationList.add(rs.getString("ROUTE_ID"));
			jsonObject.put("routeIdIndexForDrop", rs.getString("ROUTE_ID_FOR_DROP"));
			informationList.add(rs.getString("ROUTE_ID_FOR_DROP"));
			jsonObject.put("genderIdIndex", rs.getString("GENDER"));
			informationList.add(rs.getString("GENDER"));
			jsonArray.put(jsonObject);
			reporthelper.setInformationList(informationList);
			
			reportsList.add(reporthelper);
		}
		
		finalreporthelper.setReportsList(reportsList);
		finalreporthelper.setHeadersList(headersList);
		alist.add(jsonArray);
		alist.add(finalreporthelper);
	}catch(Exception e){
		System.out.println("Error in EmployeetrackingFunction:-getReportingExittime"+e);
		}finally{
			DBConnection.releaseConnectionToDB(conAms, pstmt, rs);
		}
	return alist;
	}
}
	




