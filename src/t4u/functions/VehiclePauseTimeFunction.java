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
import t4u.statements.SandMiningStatements;

public class VehiclePauseTimeFunction {

	CommonFunctions cf = new CommonFunctions();	
	SimpleDateFormat simpleDateFormatYYYY = new SimpleDateFormat(
	"MM/dd/yyyy HH:mm:ss");
	SimpleDateFormat simpleDateFormatddMMYYYYDB = new SimpleDateFormat(
	"yyyy-MM-dd HH:mm:ss");
	SimpleDateFormat simpleDateFormatddMMYYYYDB1 = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");

	SimpleDateFormat simpleDateFormatddMMYY = new SimpleDateFormat(
	"dd/MM/yyyy HH:mm:ss");
	SimpleDateFormat simpleDateFormatddMMYYAMPM = new SimpleDateFormat(
	"dd/MM/yyyy hh:mm aa");
	SimpleDateFormat simpleDateFormatddMMYY1 = new SimpleDateFormat(
	"dd/MM/yyyy");
	SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
	SimpleDateFormat simpleDateFormatdd_MM_YY = new SimpleDateFormat(
	"dd-MM-yyyy");
	DecimalFormat df = new DecimalFormat("#.##");

public JSONArray getVehicleNo(int systemId,int clientId,int userId,int offset) {
	Connection con=null;
	PreparedStatement pstmt=null;
	ResultSet rs=null;
	JSONArray JsonArray = null;
	JSONObject obj1 = null; 
	try {
		JsonArray = new JSONArray();
		con = DBConnection.getConnectionToDB("AMS");
		pstmt = con.prepareStatement(SandMiningStatements.GET_VEHICLE_NO);
		pstmt.setInt(1, systemId);
		pstmt.setInt(2, clientId);
		rs = pstmt.executeQuery();

		while (rs.next()) {
			obj1 = new JSONObject();
			obj1.put("PermitNoNew", rs.getString("REGISTRATION_NO"));

			JsonArray.put(obj1);
		} // end of while rs
	} catch (Exception e) {
		e.printStackTrace();
	} finally {
		DBConnection.releaseConnectionToDB(con, pstmt, rs);
	}
	return JsonArray;
}

public String addVehiclePauseTimeDetails(int systemId,int customerId,int userId, String vehicleNo,String startDate,String endDate,String Reason,String remarks ){
	Connection con=null;
	PreparedStatement pstmt=null;
	ResultSet rs=null;
	JSONArray JsonArray = null;
	String message = "";
	
	try{	 
		JsonArray = new JSONArray();
		con = DBConnection.getConnectionToDB("AMS");	
		
		pstmt=con.prepareStatement(SandMiningStatements.CHECK_DUPLICATE_VEHICLE_PAUSE_TIME);
        pstmt.setInt(1,systemId);
        pstmt.setInt(2,customerId);
        pstmt.setString(3,vehicleNo);
        pstmt.setString(4,startDate);
        pstmt.setString(5,startDate);
        rs=pstmt.executeQuery();
        if(rs.next())
        {
        	message="Vehicle No is already exist for the specified date,You can modify";
        	return message;
        }
        pstmt=null;
		
		pstmt=con.prepareStatement(SandMiningStatements.INSERT_VEHICLE_PAUSE_TIME_DETAILS);
		pstmt.setString(1,vehicleNo.toUpperCase());
        pstmt.setString(2, startDate);	
		pstmt.setString(3, endDate);
		pstmt.setString(4, Reason);
		pstmt.setInt(5,systemId);
        pstmt.setInt(6,customerId);
        pstmt.setInt(7,userId);
        pstmt.setString(8, remarks);
		int inserted = pstmt.executeUpdate(); 
		if(inserted > 0){
			message = "Saved Successfully";
		}
	}catch(Exception e){
		System.out.println("Error when saving addVehiclePauseTimeDetails.."+e);
		e.printStackTrace();
	}
	finally{
		DBConnection.releaseConnectionToDB(con, pstmt, rs);
	}
	return message;  			
}
public String modifyPauseTimeDetails(int systemId,int customerId,int userId, String vehicleNo,String startDate,String endDate,String reason,int id){
	Connection con=null;
	PreparedStatement pstmt=null;
	ResultSet rs=null;
	JSONArray JsonArray = null;
	String message = "";

	try{	 
		JsonArray = new JSONArray();
		con = DBConnection.getConnectionToDB("AMS");	
		pstmt=con.prepareStatement(SandMiningStatements.UPDATE_VEHICLE_PAUSE_TIME_DETAILS);
		
        pstmt.setString(1, startDate);	
		pstmt.setString(2, endDate);
		pstmt.setInt(3,userId);
		pstmt.setString(4,vehicleNo.toUpperCase());
		pstmt.setInt(5,systemId);
        pstmt.setInt(6,customerId);
        pstmt.setInt(7,id);
		int inserted = pstmt.executeUpdate();   		  
		if(inserted > 0){
			message = "Updated Successfully";
		}
	}catch(Exception e){
		System.out.println("Error when modifyPauseTimeDetails.."+e);
	}
	finally{
		DBConnection.releaseConnectionToDB(con, pstmt, rs);
	}
	return message;  			
}
 public ArrayList < Object > getVehiclePauseTimeDetails(int systemId,int customerId,String startDate,String endDate)
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
	
	try {
		headersList.add("SLNO");
		headersList.add("ID");
	    headersList.add("Vehicle No");
	    headersList.add("Pause Start Date/Time");
	    headersList.add("Pause End Date/Time");
	    headersList.add("Reason");
	    headersList.add("Inserted By");
	    headersList.add("Inserted Date/Time");
	    headersList.add("Remarks");
	    
	    Date date = simpleDateFormatddMMYYYYDB1.parse(startDate);
	    startDate=simpleDateFormatddMMYYYYDB.format(date); 
	    Date date1 = simpleDateFormatddMMYYYYDB1.parse(endDate);
	    endDate=simpleDateFormatddMMYYYYDB.format(date1); 
	    
	JsonArray=new JSONArray();	
	con = DBConnection.getConnectionToDB("AMS");
	pstmt=con.prepareStatement(SandMiningStatements.GET_VEHICLE_PAUSE_TIME_DETAILS);
	pstmt.setInt(1,systemId);
	pstmt.setInt(2,customerId);
	pstmt.setString(3, startDate);
	pstmt.setString(4, endDate);
	rs=pstmt.executeQuery();
	while(rs.next())
	{
	count++;
	obj=new JSONObject();
	ArrayList informationList = new ArrayList();
	ReportHelper reporthelper = new ReportHelper();
	
	obj.put("SLNODataIndex", count);
	informationList.add(count);
	
	obj.put("IdDataIndex", rs.getString("ID"));
	informationList.add(rs.getString("ID"));
	
	obj.put("VehicleNoDataIndex", rs.getString("VEHICLE_NO"));
	informationList.add(rs.getString("VEHICLE_NO"));
	
	if (rs.getString("PAUSE_START_DATE").contains("1900") || rs.getString("PAUSE_START_DATE")== null || rs.getString("PAUSE_START_DATE").equals("")) {
		obj.put("pauseStartTimeDataIndex", "");
		informationList.add("");
	}else{
		obj.put("pauseStartTimeDataIndex", simpleDateFormatddMMYYYYDB1.format(rs.getTimestamp("PAUSE_START_DATE")));
		informationList.add(simpleDateFormatddMMYYYYDB1.format(rs.getTimestamp("PAUSE_START_DATE")));
	}
	if (rs.getString("PAUSE_END_DATE").contains("1900") || rs.getString("PAUSE_END_DATE")== null || rs.getString("PAUSE_END_DATE").equals("")) {
		obj.put("pauseEndTimeDataIndex", "");
		informationList.add("");
	}else{
		obj.put("pauseEndTimeDataIndex", simpleDateFormatddMMYYYYDB1.format(rs.getTimestamp("PAUSE_END_DATE")));
		informationList.add(simpleDateFormatddMMYYYYDB1.format(rs.getTimestamp("PAUSE_END_DATE")));
	}
	
	obj.put("reasonDataIndex", rs.getString("REASON"));
	informationList.add(rs.getString("REASON"));
	
	obj.put("insertedByDataIndex", rs.getString("INSERTED_BY"));
	informationList.add(rs.getString("INSERTED_BY"));
	
	if (rs.getString("INSERTED_DATE").contains("1900") || rs.getString("INSERTED_DATE")== null || rs.getString("INSERTED_DATE").equals("")) {
		obj.put("insertedTimeDataIndex", "");
		informationList.add("");
	}else{
		obj.put("insertedTimeDataIndex", simpleDateFormatddMMYYYYDB1.format(rs.getTimestamp("INSERTED_DATE")));
		informationList.add(simpleDateFormatddMMYYYYDB1.format(rs.getTimestamp("INSERTED_DATE")));
	}
	obj.put("remarksDataIndex", rs.getString("REMARKS"));
	informationList.add(rs.getString("REMARKS"));
	
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





}