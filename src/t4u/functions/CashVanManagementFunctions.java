package t4u.functions;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.DecimalFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.Map;
import java.util.Properties;
import java.util.Map.Entry;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import t4u.beans.ReportHelper;
import t4u.common.ApplicationListener;
import t4u.common.DBConnection;
import t4u.statements.CargomanagementStatements;
import t4u.statements.CashVanManagementStatements;

import com.t4u.activity.VehicleActivity;
import com.t4u.activity.VehicleSummaryBean;



/**
 * @author Nikhil
 *
 */
public class CashVanManagementFunctions {
	CommonFunctions cf=new CommonFunctions();
	SimpleDateFormat sdfyyyymmddhhmmss=new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
	SimpleDateFormat yyyymmdd = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	SimpleDateFormat simpleDateFormatddMMYYYYDB = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	SimpleDateFormat sdfFormatDate = new SimpleDateFormat("MM/dd/yyyy HH:mm:ss");
	DecimalFormat df=new DecimalFormat("##.##");
	SimpleDateFormat ddmmyyyy = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
	SimpleDateFormat ddmmyy = new SimpleDateFormat("dd-MM-yyyy");
	/***
	 * this function is getting count of overspeed alert
	 * @param customerid
	 * @param systemid
	 * @return
	 */
	public int getOverSpeedCount(String customerid, int systemid,String alertID,int offset){
		Connection conAdmin=null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		double speedlimit=0;
		int overspeedCount=0;
			try {
				conAdmin=DBConnection.getConnectionToDB("AMS");
				speedlimit=getOverspeedrange(conAdmin,Integer.parseInt(customerid),systemid);
				pstmt=conAdmin.prepareStatement(CashVanManagementStatements.GET_OVER_SPEED_ALERT);
				pstmt.setInt(1, offset);
				pstmt.setInt(2, 1440);
				pstmt.setInt(3, Integer.parseInt(customerid));
				pstmt.setInt(4, systemid);
				rs=pstmt.executeQuery();
				while (rs.next()){
					int flag = 1;
					if (rs.getString("TYPE_OF_ALERT").equals("2")) {
						flag = 0;
						if (rs.getDouble("OVERSPEEDLIMIT") > 0) {
							if (rs.getDouble("OVERSPEED") >= rs
									.getDouble("OVERSPEEDLIMIT")) {
								flag = 1;
							}
						} else if (speedlimit >= 0) {
							if (rs.getDouble("OVERSPEED") >= speedlimit) {
								flag = 1;
							}
						}
					}
					if (flag == 1) {
						overspeedCount++;
					}
					}
				
		} catch (Exception e) {
			e.printStackTrace();
		}finally{
			DBConnection.releaseConnectionToDB(conAdmin, pstmt, rs);
		}
		
		
		return overspeedCount;
		}
/**
 * this function is getting the count of vehicle stoppage alert 
 * @param loggedclientid
 * @param systemId
 * @return
 */
	public String getvehicleStoppageAlertCount(String customerid, int systemid,String alertID) {
		String AlertCount="";
		Connection conAdmin=null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		try {
			conAdmin=DBConnection.getConnectionToDB("AMS");
			pstmt=conAdmin.prepareStatement(CashVanManagementStatements.GET_STOPPAGE_ALERT_DETAILS_COUNT);
			pstmt.setInt(1, Integer.parseInt(alertID));
			pstmt.setInt(2, 1440);
			pstmt.setInt(3, Integer.parseInt(customerid));
			pstmt.setInt(4, systemid);
			rs=pstmt.executeQuery();
			if(rs.next()){
				AlertCount=rs.getString("COUNT");
			}
		} catch (Exception e) {
			e.printStackTrace();
		}finally{
			DBConnection.releaseConnectionToDB(conAdmin, pstmt, rs);
		}
		return AlertCount;
	}
	/**
	 * getting crossed border alert count
	 * @param customerid
	 * @param systemid
	 * @return
	 */
	
	public String getCrossedBorderAlertCount(String customerid, int systemid,String offset,String alertID) {
		String AlertCount="";
		Connection conAdmin=null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		try {
			conAdmin=DBConnection.getConnectionToDB("AMS");
			pstmt=conAdmin.prepareStatement(CashVanManagementStatements.GET_ALERT_COUNT);
			pstmt.setInt(1, Integer.parseInt(alertID));
			pstmt.setInt(2, 1440);
			pstmt.setInt(3, Integer.parseInt(customerid));
			pstmt.setInt(4, systemid);
			rs=pstmt.executeQuery();
			if(rs.next()){
				AlertCount=rs.getString("COUNT");
			}
		} catch (Exception e) {
			e.printStackTrace();
		}finally{
			DBConnection.releaseConnectionToDB(conAdmin, pstmt, rs);
		}
		return AlertCount;
	}
	
	
	/**
	 * getting deviated from standard root alert count
	 * @param customerid
	 * @param systemid
	 * @return
	 */
	
	public String getVehicleOnOffAlertCount(String customerid, int systemid,String alertID,int userId) {
		int onTripCount1=0;
		int onTripCount2=0;
		int totalcount=0;
		String VehicleOnTrip="";
		String VehicleOffTrip="";
		String Vehicle_On_Off_Count="";
		Connection conAdmin=null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		try {
			conAdmin=DBConnection.getDashboardConnection("AMS");
			pstmt=conAdmin.prepareStatement(CashVanManagementStatements.GET_VEHICLE_ON_OFF_TRIP,ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
			pstmt.setInt(1, userId);
			pstmt.setInt(2, systemid);
			pstmt.setInt(3, Integer.parseInt(customerid));
			pstmt.setInt(4, userId);
			pstmt.setInt(5, systemid);
			pstmt.setInt(6, Integer.parseInt(customerid));
			pstmt.setInt(7, userId);
			pstmt.setInt(8, systemid);
			pstmt.setInt(9, Integer.parseInt(customerid));
			pstmt.setInt(10, userId);
			pstmt.setInt(11, systemid);
			pstmt.setInt(12, Integer.parseInt(customerid));
			rs=pstmt.executeQuery();
			if(rs.next()){
				onTripCount1=rs.getInt("intcount");
				onTripCount2=rs.getInt("extcount");
				totalcount=rs.getInt("totalcount");
				int ontripcount = rs.getInt("ontripcount");
				VehicleOnTrip=Integer.toString(totalcount-(onTripCount1+onTripCount2));
				if(Integer.parseInt(VehicleOnTrip)<0)
				VehicleOnTrip="0";
				VehicleOffTrip=Integer.toString(onTripCount1+onTripCount2);
				Vehicle_On_Off_Count=VehicleOffTrip+","+ontripcount;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}finally{
			DBConnection.releaseConnectionToDB(conAdmin, pstmt, rs);
		}
		return Vehicle_On_Off_Count;
	}
	
	
	
	/**
	 * getting deviated from standard root alert count
	 * @param customerid
	 * @param systemid
	 * @return
	 */
	public String getPoorSatelliteCount(int customerID,int systemID,int userID,int isLtsp) {
		
		String count="";
		Connection conAdmin=null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		try {
			conAdmin=DBConnection.getDashboardConnection("AMS");
			if(customerID==0 || isLtsp==0){
				pstmt=conAdmin.prepareStatement(CashVanManagementStatements.GET_POOR_SATELLITE_COUNT_FOR_LTSP);
				pstmt.setInt(1, customerID);
				pstmt.setInt(2, systemID);
				pstmt.setInt(3, userID);
			}else{
				pstmt=conAdmin.prepareStatement(CashVanManagementStatements.GET_POOR_SATELLITE_COUNT_FOR_CLIENT);
				pstmt.setInt(1, customerID);
				pstmt.setInt(2, systemID);
				pstmt.setInt(3, userID);
			}
			rs=pstmt.executeQuery();
			if(rs.next()){
				count=rs.getString("SATELLITE_COUNT");
			}
		} catch (Exception e) {
			e.printStackTrace();
		}finally{
			DBConnection.releaseConnectionToDB(conAdmin, pstmt, rs);
		}
		return count;
	}
	
	/**
	 * getting Continuous Moving Alert Count alert count
	 * @param customerid
	 * @param systemid
	 * @return
	 */
	
	public String getContinousMovingAlertCount(String customerid, int systemid,String alertID) {
		String AlertCount="";
		Connection conAdmin=null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		try {
			conAdmin=DBConnection.getConnectionToDB("AMS");
			pstmt=conAdmin.prepareStatement(CashVanManagementStatements.GET_ALERT_COUNT);
			pstmt.setInt(1, Integer.parseInt(alertID));
			pstmt.setInt(2, 1440);
			pstmt.setInt(3, Integer.parseInt(customerid));
			pstmt.setInt(4, systemid);
			rs=pstmt.executeQuery();
			if(rs.next()){
				AlertCount=rs.getString("COUNT");
			}
		} catch (Exception e) {
			e.printStackTrace();
		}finally{
			DBConnection.releaseConnectionToDB(conAdmin, pstmt, rs);
		}
		return AlertCount;
	}

	
	/**
	 * getting Idle Time Alert Count alert count
	 * @param customerid
	 * @param systemid
	 * @return
	 */
	
	public String getIdleTimeAlertCount(String customerid, int systemid,String alertID) {
		String AlertCount="";
		Connection conAdmin=null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		try {
			conAdmin=DBConnection.getConnectionToDB("AMS");
			pstmt=conAdmin.prepareStatement(CashVanManagementStatements.GET_IDLE_ALERT_DETAILS_COUNT);
			pstmt.setInt(1, Integer.parseInt(alertID));
			pstmt.setInt(2, 1440);
			pstmt.setInt(3, Integer.parseInt(customerid));
			pstmt.setInt(4, systemid);
			rs=pstmt.executeQuery();
			if(rs.next()){
				AlertCount=rs.getString("COUNT");
			}
		} catch (Exception e) {
			e.printStackTrace();
		}finally{
			DBConnection.releaseConnectionToDB(conAdmin, pstmt, rs);
		}
		return AlertCount;
	}

	
	
	/**
	 * getting Preventive Expired Count alert count
	 * @param customerid
	 * @param systemid
	 * @return
	 */
	
	public String getPreventiveExpiredAlertCount(String customerid, int systemid,String offset,String alertID) {
		String AlertCount="";
		Connection conAdmin=null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		String preventiveexpired="Preventive Expired";
		int offmin = 1440 - Integer.parseInt(offset);
		try {
			conAdmin=DBConnection.getConnectionToDB("AMS");
			String sql=CashVanManagementStatements.GET_PREVENTIVE_ALERT_COUNT;
			sql=sql+" and  upper(Description) like upper('%"+preventiveexpired+"%') "
			+ " and  [GMT]  between  dateadd(mi,-?,getutcdate()) and  dateadd(mi,"+offset+",getUTCDate()) ";
			pstmt=conAdmin.prepareStatement(sql);
			pstmt.setInt(1, systemid);
			pstmt.setInt(2, Integer.parseInt(customerid));
			pstmt.setInt(3, offmin);
			
			rs=pstmt.executeQuery();
			if(rs.next()){
				AlertCount=rs.getString("COUNT");
			}
		} catch (Exception e) {
			e.printStackTrace();
		}finally{
			DBConnection.releaseConnectionToDB(conAdmin, pstmt, rs);
		}
		return AlertCount;
	}
	/**
	 * getting Preventive Due Expired Count alert count
	 * @param customerid
	 * @param systemid
	 * @return
	 */
	
	public String getPreventiveDueForExpieryAlertCount(String customerid, int systemid,String offset,String alertID) {
		String AlertCount="";
		Connection conAdmin=null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		String preventivedueexpiary="Preventive Due For Expiry";
		int offmin = 1440 - Integer.parseInt(offset);
		try {
			conAdmin=DBConnection.getConnectionToDB("AMS");
			String sql=CashVanManagementStatements.GET_PREVENTIVE_ALERT_COUNT;
			sql=sql+" and  upper(Description) like upper('%"+preventivedueexpiary+"%') "
			+ " and  [GMT]  between  dateadd(mi,-?,getutcdate()) and  dateadd(mi,"+offset+",getUTCDate()) ";
			pstmt=conAdmin.prepareStatement(sql);
			pstmt.setInt(1, systemid);
			pstmt.setInt(2, Integer.parseInt(customerid));
			pstmt.setInt(3, offmin);
			rs=pstmt.executeQuery();
			if(rs.next()){
				AlertCount=rs.getString("COUNT");
			}
		} catch (Exception e) {
			e.printStackTrace();
		}finally{
			DBConnection.releaseConnectionToDB(conAdmin, pstmt, rs);
		}
		return AlertCount;
	}
	
	/**
	 * getting Statutory Alert Count Count alert count
	 * @param customerid
	 * @param systemid
	 * @return
	 */
	
	public String getStatutoryAlertCount(String custID, int systemId,
			String offset,String alertIDs ,int userId) {
		
		String AlertCount="";
		Connection conAdmin=null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		int offmin = 1440 - Integer.parseInt(offset);
		int alertID = 0;
		if(!alertIDs.equals("") && !alertIDs.equals(null)){
			 alertID = Integer.parseInt(alertIDs);	
		}
		try {
			conAdmin=DBConnection.getDashboardConnection("AMS");
			if( alertID == 66 || alertID == 67 ){
				pstmt=conAdmin.prepareStatement(CashVanManagementStatements.GET_STATUTORY_ALERT_COUNT,ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);			
				pstmt.setDouble(3, offmin);
				pstmt.setInt(2, Integer.parseInt(custID));
				pstmt.setInt(3, systemId);
				pstmt.setDouble(3, offmin);
				pstmt.setInt(5, Integer.parseInt(custID));
				pstmt.setInt(6, systemId);					
			}
			else{
			pstmt=conAdmin.prepareStatement(CashVanManagementStatements.GET_STATUTORY_ALERT_COUNT_NEW,ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);			
			pstmt.setDouble(3, offmin);
			pstmt.setInt(2, Integer.parseInt(custID));
			pstmt.setInt(3, systemId);
			pstmt.setDouble(3, offmin);
			pstmt.setInt(5, Integer.parseInt(custID));
			pstmt.setInt(6, systemId);
			pstmt.setInt(7, systemId);
			pstmt.setInt(8, userId);	
			}
			rs=pstmt.executeQuery();
			if(rs.next()){
				AlertCount=rs.getString("COUNT");
			}
		} catch (Exception e) {
			e.printStackTrace();
		}finally{
			DBConnection.releaseConnectionToDB(conAdmin, pstmt, rs);
		}
		return AlertCount;
		
	}
	
	/**
	 * getting Total  Alert 
	 * @param customerid
	 * @param systemid
	 * @return
	 */
	public Map<String,Integer> getAlert(int systemId){
		Map<String,Integer> alert=new LinkedHashMap <String,Integer>();
		Connection conAdmin=null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		try {
			conAdmin=DBConnection.getConnectionToDB("AMS");
			pstmt=conAdmin.prepareStatement(CashVanManagementStatements.GET_ALERT);
			pstmt.setInt(1, systemId);
			rs=pstmt.executeQuery();
			while(rs.next()){
				alert.put(rs.getString("ALERT_NAME_LABEL_ID"),rs.getInt("ALERT_ID"));				
			}

		} catch (Exception e) {
			e.printStackTrace();
		}finally{
			DBConnection.releaseConnectionToDB(conAdmin, pstmt, rs);
		}
		
		
		return alert;
		}
	
	
	public Map<String,Integer> getCVSDashboardSettings(int systemId){
		Map<String,Integer> alert=new LinkedHashMap <String,Integer>();
		Connection conAdmin=null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		int count=0;
		try {
			conAdmin=DBConnection.getConnectionToDB("AMS");
			pstmt=conAdmin.prepareStatement(CashVanManagementStatements.GET_CVS_DASHBOARD_SETTING);
			pstmt.setInt(1, systemId);
			rs=pstmt.executeQuery();
			while(rs.next()){
				count++;
				alert.put(rs.getString("ALERT_NAME_LABEL_ID"),rs.getInt("ALERT_ID"));				
			}
            if(count==0)
            {
            	pstmt=conAdmin.prepareStatement(CashVanManagementStatements.GET_CVS_DASHBOARD_SETTING);
    			pstmt.setInt(1, -1);
    			rs=pstmt.executeQuery();
    			while(rs.next()){
    				count++;
    				alert.put(rs.getString("ALERT_NAME_LABEL_ID"),rs.getInt("ALERT_ID"));				
    			}
            }
		} catch (Exception e) {
			e.printStackTrace();
		}finally{
			DBConnection.releaseConnectionToDB(conAdmin, pstmt, rs);
		}
		
		
		return alert;
		}
	/**
	 * getting Fuel Consumption record
	 * @param customerid
	 * @param systemid
	 * @return
	 */
	
	public int getFuelConsume(String custID, int systemId, int offset) {
		int AlertCount=0;
		Connection conAdmin=null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		try {
			conAdmin=DBConnection.getDashboardConnection("AMS");
			pstmt=conAdmin.prepareStatement(CashVanManagementStatements.GET_FUEL_COUNT,ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
			pstmt.setInt(1, 1440);
			pstmt.setInt(2, Integer.parseInt(custID));
			pstmt.setInt(3, systemId);
			rs=pstmt.executeQuery();
			if(rs.next()){
				AlertCount=rs.getInt("Litres");
			}
		} catch (Exception e) {
			e.printStackTrace();
		}finally{
			DBConnection.releaseConnectionToDB(conAdmin, pstmt, rs);
		}
		return AlertCount;
		
		
		
	}
	
	/**
	 * getting Fuel Consumption record
	 * @param customerid
	 * @param systemid
	 * @return
	 */
	
	public int getReFuelConsume(String custID, int systemId, int offset) {
		int AlertCount=0;
		Connection conAdmin=null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		try {
			conAdmin=DBConnection.getDashboardConnection("AMS");
			pstmt=conAdmin.prepareStatement(CashVanManagementStatements.GET_REFUEL_COUNT,ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
			pstmt.setInt(1, offset);
			pstmt.setInt(2, Integer.parseInt(custID));
			pstmt.setInt(3, systemId);
			rs=pstmt.executeQuery();
			if(rs.next()){
				AlertCount=rs.getInt("Litres");
			}
		} catch (Exception e) {
			e.printStackTrace();
		}finally{
			DBConnection.releaseConnectionToDB(conAdmin, pstmt, rs);
		}
		return AlertCount;
		
		
		
	}
	/**
	 * function for getting count for not visited vault
	 * @param custID
	 * @param systemId
	 * @param offset
	 * @param alertID
	 * @return
	 */
	public String getNotVisitedVaultCount(String custID, int systemId,
			String offset, String alertID) {
		String AlertCount="";
		Connection conAdmin=null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		try {
			conAdmin=DBConnection.getConnectionToDB("AMS");
			pstmt=conAdmin.prepareStatement(CashVanManagementStatements.GET_ALERT_COUNT);
			pstmt.setInt(1, Integer.parseInt(alertID));
			pstmt.setInt(2, 1440);
			pstmt.setInt(3, Integer.parseInt(custID));
			pstmt.setInt(4, systemId);
			rs=pstmt.executeQuery();
			if(rs.next()){
				AlertCount=rs.getString("COUNT");
			}
		} catch (Exception e) {
			e.printStackTrace();
		}finally{
			DBConnection.releaseConnectionToDB(conAdmin, pstmt, rs);
		}
		return AlertCount;
	}
	
	public JSONArray getStateWiseStatutoryCount(String alertId,String customerId,int systemId,int offset, int userId)
	{

		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String state="";
		String alertcount="";
		JSONArray statutorystateJSONArray=new JSONArray();
		JSONObject statutorystateJSONObject;
		try {
			con = DBConnection.getDashboardConnection("AMS");
			if(Integer.parseInt(alertId)== 66 || Integer.parseInt(alertId)== 67 ){
				pstmt = con.prepareStatement(CashVanManagementStatements.GET_STATUTORY_STATEWISE_COUNT,ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
				pstmt.setString(1, alertId);
				pstmt.setString(2, customerId);
				pstmt.setInt(3, systemId);
				pstmt.setInt(4, offset);	
			}else  if(alertId.equals("33") || alertId.equals("11")){
				String replace="a.AlertId in (11,127) ";
				if(alertId.equals("33")){
					replace="a.AlertId in (33,128) ";
				}
				String stmt=CashVanManagementStatements.GET_STATUTORY_STATEWISE_COUNT_NEW.replace("a.AlertId =? ", replace);
				
				pstmt = con.prepareStatement(stmt,ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
				//pstmt.setString(1, alertId);
				pstmt.setString(1, customerId);
				pstmt.setInt(2, systemId);
				pstmt.setInt(3, offset);
				pstmt.setInt(4, systemId);
				pstmt.setInt(5, userId);
				//System.out.println(stmt);
			}
				else{
			pstmt = con.prepareStatement(CashVanManagementStatements.GET_STATUTORY_STATEWISE_COUNT_NEW,ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
			pstmt.setString(1, alertId);
			pstmt.setString(2, customerId);
			pstmt.setInt(3, systemId);
			pstmt.setInt(4, offset);
			pstmt.setInt(5, systemId);
			pstmt.setInt(6, userId);
			}
			//pstmt.setString(5, alertId);
			//pstmt.setString(6, customerId);
			//pstmt.setInt(7, systemId);
			//pstmt.setInt(8, offset);
			rs = pstmt.executeQuery();
			while(rs.next()) {	
			statutorystateJSONObject=new JSONObject();
			state=rs.getString("STATE_NAME");
			alertcount=rs.getString("STATUTORY_COUNT");
			statutorystateJSONObject.put("state", state);
			statutorystateJSONObject.put("count",alertcount);
			statutorystateJSONArray.put(statutorystateJSONObject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}

		return statutorystateJSONArray;
		
	}
	/**
	 * function for getting count for not return parking alert
	 * @param custID
	 * @param systemId
	 * @param offset
	 * @param alertID
	 * @return
	 */
	public String getNotReturnToParking(String custID, int systemId,
			String offset, String alertID) {
		String AlertCount="";
		Connection conAdmin=null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		try {
			conAdmin=DBConnection.getConnectionToDB("AMS");
			pstmt=conAdmin.prepareStatement(CashVanManagementStatements.GET_ALERT_COUNT);
			pstmt.setInt(1, Integer.parseInt(alertID));
			pstmt.setInt(2, 1440);
			pstmt.setInt(3, Integer.parseInt(custID));
			pstmt.setInt(4, systemId);
			rs=pstmt.executeQuery();
			if(rs.next()){
				AlertCount=rs.getString("COUNT");
			}
		} catch (Exception e) {
			e.printStackTrace();
		}finally{
			DBConnection.releaseConnectionToDB(conAdmin, pstmt, rs);
		}
		return AlertCount;
	}
	
	/**
	 * function for getting detention alert count
	 * @param custID
	 * @param systemId
	 * @param offset
	 * @param alertID
	 * @return
	 */
	public String getDetention(String custID, int systemId, String offset,
			String alertID) {
		String AlertCount="";
		Connection conAdmin=null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		try {
			conAdmin=DBConnection.getDashboardConnection("AMS");
			pstmt=conAdmin.prepareStatement(CashVanManagementStatements.GET_DETENTION_ALERT_COUNT,ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
			pstmt.setInt(1, Integer.parseInt(alertID));
			pstmt.setInt(2, Integer.parseInt(custID));
			pstmt.setInt(3, systemId);
			rs=pstmt.executeQuery();
			if(rs.next()){
				AlertCount=rs.getString("COUNT");
			}
		} catch (Exception e) {
			e.printStackTrace();
		}finally{
			DBConnection.releaseConnectionToDB(conAdmin, pstmt, rs);
		}
		return AlertCount;
	}
	
	public JSONArray getCommNonCommVehicles(String customerid, int systemId,int userId,int isLtsp, int nonCommHrs) {
		Connection con = null;
		PreparedStatement pstmt = null,pstmt1 = null,pstmt2 = null;
		ResultSet rs = null;		
		JSONArray commnoncommJSONArray=new JSONArray();
		JSONObject commnoncommJSONObject;
		try {		
			int nonCommunicatingCount=0;
			int communicatingVehicles=0;
			int noGpsConnected=0;
			int totalAssetCount=0;
			commnoncommJSONObject=new JSONObject();
			con = DBConnection.getDashboardConnection("AMS");
			if(customerid.equals("0") || isLtsp == 0){	
				pstmt = con.prepareStatement(CashVanManagementStatements.GET_TOTAL_ASSET_COUNT_FOR_LTSP,ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
				pstmt1 = con.prepareStatement(CashVanManagementStatements.GET_NON_COMMUNICATING_FOR_LTSP,ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);					
				pstmt2 = con.prepareStatement(CashVanManagementStatements.GET_NOGPS_VEHICLES_FOR_LTSP,ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
				
			}else{
				pstmt = con.prepareStatement(CashVanManagementStatements.GET_TOTAL_ASSET_COUNT_FOR_CLIENT,ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
				pstmt1 = con.prepareStatement(CashVanManagementStatements.GET_NON_COMMUNICATING_FOR_CLIENT,ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
				pstmt2 = con.prepareStatement(CashVanManagementStatements.GET_NOGPS_VEHICLES_FOR_CLIENT,ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
				
			}			
			rs=null;
			pstmt.setString(1, customerid);
			pstmt.setInt(2, systemId);
			pstmt.setInt(3,userId);
			rs = pstmt.executeQuery();
			if (rs.next()) {			
				totalAssetCount=rs.getInt("TOTAL_ASSETS_COUNT");
			}
			rs=null;
			pstmt1.setString(1, customerid);
			pstmt1.setInt(2, systemId);
			pstmt1.setInt(3, nonCommHrs);
			pstmt1.setInt(4,userId);
			rs = pstmt1.executeQuery();
			if (rs.next()) {			
				nonCommunicatingCount=rs.getInt("NON_COMMUNICATING");
			}			
			rs=null;		
			pstmt2.setString(1,customerid);
			pstmt2.setInt(2, systemId);
			pstmt2.setInt(3,userId);
			rs = pstmt2.executeQuery();
			if (rs.next()) {			
				noGpsConnected=rs.getInt("NOGPS");
			}			
			communicatingVehicles=totalAssetCount-(nonCommunicatingCount+noGpsConnected);			
			commnoncommJSONObject.put("totalAssets",totalAssetCount);
			commnoncommJSONObject.put("communicating", communicatingVehicles);
			commnoncommJSONObject.put("noncommunicating",nonCommunicatingCount);
			commnoncommJSONObject.put("noGPS",noGpsConnected);			
			commnoncommJSONArray.put(commnoncommJSONObject);		
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
			DBConnection.releaseConnectionToDB(null, pstmt1, null);
			DBConnection.releaseConnectionToDB(null, pstmt2, null);			
		}	
		return commnoncommJSONArray;	
	}
	public JSONArray getCommisionedDeCommVehicles(String customerid,int systemId,int userId) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int commmisionedCount=0;
		int decommisionedCount=0;
		JSONArray commndecommJSONArray=new JSONArray();
		JSONObject commndecommJSONObject;
		try {
			commndecommJSONObject=new JSONObject();
			con = DBConnection.getDashboardConnection("AMS");
			pstmt = con.prepareStatement(CashVanManagementStatements.GET_COMMISIONED_VEHICLE,ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, Integer.parseInt(customerid));
			rs = pstmt.executeQuery();
			if (rs.next()) {			
				commmisionedCount=rs.getInt("COMMISIONED");
			}
			pstmt=null;
			rs=null;
			pstmt = con.prepareStatement(CashVanManagementStatements.GET_DECOMMISIONED_VEHICLE,ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, Integer.parseInt(customerid));
			rs = pstmt.executeQuery();
			if (rs.next()) {			
				decommisionedCount=rs.getInt("DECOMMISIONED");
			}
			commndecommJSONObject.put("commisioned", commmisionedCount);
			commndecommJSONObject.put("decommisioned",decommisionedCount);
			commndecommJSONArray.put(commndecommJSONObject);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}

		return commndecommJSONArray;
	}
	public JSONArray getPreventiveExpiryVehicles(String customerid, int systemId,int userId) {

		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int expired=0;
		int dueforExpiry=0;
		JSONArray preventiveJSONArray=new JSONArray();
		JSONObject preventiveJSONObject;
		try {
			preventiveJSONObject=new JSONObject();
			con = DBConnection.getDashboardConnection("AMS");
			pstmt = con.prepareStatement(CashVanManagementStatements.PREVENTIVE_EXPIRED_FROM_PREVENTIVE_EVENTS,ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, Integer.parseInt(customerid));
			pstmt.setInt(3, userId);
			pstmt.setInt(4, systemId);
			pstmt.setInt(5, Integer.parseInt(customerid));
			pstmt.setInt(6, userId);
			rs = pstmt.executeQuery();
			if (rs.next()) {			
				expired=rs.getInt("PREVENTIVE_EXPIRED");
			}
			pstmt=null;
			rs=null;
			pstmt = con.prepareStatement(CashVanManagementStatements.PREVENTIVE_DUE_FOR_EXPIRY_FROM_PREVENTIVE_EVENTS,ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, Integer.parseInt(customerid));
			pstmt.setInt(3, userId);
			rs = pstmt.executeQuery();
			if (rs.next()) {			
				dueforExpiry=rs.getInt("PREVENTIVE_DUR_FOR_EXPIRED");
			}
			preventiveJSONObject.put("expired", expired);
			preventiveJSONObject.put("dueforexpiry",dueforExpiry);
			preventiveJSONArray.put(preventiveJSONObject);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}

		return preventiveJSONArray;
	
	}
	public JSONArray getVehiclesLiveStatus(String customerid, int systemId,int userId,int isLtps) {


		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int running=0;
		int idle=0;
		int stopped=0;
		JSONArray livestatusJSONArray=new JSONArray();
		JSONObject livestatusJSONObject;
		try {
			livestatusJSONObject=new JSONObject();
			con = DBConnection.getDashboardConnection("AMS");
			if(isLtps == 0){
				pstmt = con.prepareStatement(CashVanManagementStatements.GET_VEHICLE_LIVE_STATUS_FOR_LTSP,ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);	
			}else{
				pstmt = con.prepareStatement(CashVanManagementStatements.GET_VEHICLE_LIVE_STATUS_FOR_CLIENT,ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);	
			}
			
			pstmt.setInt(1, Integer.parseInt(customerid));
			pstmt.setInt(2, systemId);
			pstmt.setInt(3,userId);
			rs = pstmt.executeQuery();
			if (rs.next()) {			
				running=rs.getInt("RUNNING");
				idle=rs.getInt("IDLE");
				stopped=rs.getInt("STOPPED_COUNT");
			}

			livestatusJSONObject.put("running", running);
			livestatusJSONObject.put("idle",idle);
			livestatusJSONObject.put("stopped",stopped);
			livestatusJSONArray.put(livestatusJSONObject);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}

		return livestatusJSONArray;
	
	
	}
	public JSONArray getStatutoryDetails(String customerid, int systemId,int offset, int userId) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int insuranceDOE=0;
		int insuranceExp=0;
		int goodstokentaxDOE=0;
		int goodstokentaxExp=0;
		int FCIDOE=0;
		int FCIExp=0;
		int EmissionDOE=0;
		int EmissionExp=0;
		int PermitDOE=0;
		int PermitExp=0;
		int RegistrationDOE=0;
		int RegistrationExp=0;
		int DriverLicenseDOE=0;
		int DriverLicenseExp=0;
		JSONArray statutoryJSONArray=new JSONArray();
		JSONObject statutoryJSONObject;
		try {
			statutoryJSONObject=new JSONObject();
			con = DBConnection.getDashboardConnection("AMS");
			pstmt = con.prepareStatement(CashVanManagementStatements.GET_STATUTORY_ALERT_COUNT_NEW);
			pstmt.setInt(1, offset);
			pstmt.setInt(2, Integer.parseInt(customerid));
			pstmt.setInt(3, systemId);
			pstmt.setInt(4, offset);
			pstmt.setInt(5, Integer.parseInt(customerid));
			pstmt.setInt(6, systemId);
			pstmt.setInt(7, systemId);
			pstmt.setInt(8, userId);
			rs = pstmt.executeQuery();
			if (rs.next()) {			
				insuranceDOE=rs.getInt("INSURANCE_DOE");
				insuranceExp=rs.getInt("INSURANCE_EXP");
				goodstokentaxDOE=rs.getInt("GOODS_TOKEN_TAX_DOE");
				goodstokentaxExp=rs.getInt("GOODS_TOKEN_TAX_EXP");
				FCIDOE=rs.getInt("FCI_DOE");
				FCIExp=rs.getInt("FCI_EXP");
				EmissionDOE=rs.getInt("EMISSION_DOE");
				EmissionExp=rs.getInt("EMISSION_EXP");
				PermitDOE=rs.getInt("PERMIT_DOE");
				PermitExp=rs.getInt("PERMIT_EXP");
				RegistrationDOE=rs.getInt("REGISTRATION_DOE");
				RegistrationExp=rs.getInt("REGISTRATION_EXP");
				DriverLicenseDOE=rs.getInt("DRIVER_LICENSE_DOE");
				DriverLicenseExp=rs.getInt("DRIVER_LICENSE_EXP");
			}
			statutoryJSONObject.put("insuranceDOE", 1); //insuranceDOE
			statutoryJSONObject.put("insuranceExp",1); //insuranceExp
			statutoryJSONObject.put("goodstokentaxDOE",1);//goodstokentaxDOE
			statutoryJSONObject.put("goodstokentaxExp", 1);//goodstokentaxExp
			statutoryJSONObject.put("FCIDOE",1);//FCIDOE
			statutoryJSONObject.put("FCIExp",1); //FCIExp
			statutoryJSONObject.put("EmissionDOE", 1);  //EmissionDOE
			statutoryJSONObject.put("EmissionExp",1);//EmissionExp
			statutoryJSONObject.put("PermitDOE",1); //PermitDOE
			statutoryJSONObject.put("PermitExp", 1);//PermitExp
			statutoryJSONObject.put("RegistrationDOE",1);//RegistrationDOE
			statutoryJSONObject.put("RegistrationExp", 1);//RegistrationExp
			statutoryJSONObject.put("DriverLicenseDOE",1);//DriverLicenseDOE
			statutoryJSONObject.put("DriverLicenseExp",1);//DriverLicenseExp
			statutoryJSONArray.put(statutoryJSONObject);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}

		return statutoryJSONArray;
	
	
	
	}
	public JSONArray getDashBoardDetails(String customerid, String alertId,
			int systemId, int offset) {

		Connection con = null;
		PreparedStatement pstmt = null;
		PreparedStatement pstmt1 = null;
		ResultSet rs = null;
		ResultSet rs1 = null;
		String vehicleNo="";
		Date alertdate=new Date();;
		String location="";
		String speed="";
		String remarks="";
		String groupname="";
		int alertslno=0;
		double speedlimit=0;
		int driverId=0;
		int offmin=1440;
		JSONArray alertdetailsJSONArray=new JSONArray();
		JSONObject alertdetailsJSONObject;
		try {
			con = DBConnection.getConnectionToDB("AMS");
			speedlimit=getOverspeedrange(con,Integer.parseInt(customerid),systemId);
			if (alertId.equals("-5")) {
				pstmt = con.prepareStatement(CashVanManagementStatements.PREVENTIVE_DETAILS);
				pstmt.setInt(1, offset);
				pstmt.setInt(2, systemId);
				pstmt.setInt(3, Integer.parseInt(customerid));
				pstmt.setInt(4, 1440);
			} else if (alertId.equals("119")) {
				pstmt = con.prepareStatement(CashVanManagementStatements.GET_DETENTION_ALERT_DETAILS);
				pstmt.setInt(1, offset);
				pstmt.setString(2, alertId);
				pstmt.setInt(3, Integer.parseInt(customerid));
				pstmt.setInt(4, systemId);
			} else if (alertId.equals("2")) {
					pstmt = con.prepareStatement(CashVanManagementStatements.GET_OVER_SPEED_ALERT);
					pstmt.setInt(1, offset);
					pstmt.setInt(2, offmin);
					pstmt.setInt(3, Integer.parseInt(customerid));
					pstmt.setInt(4, systemId);
			} else if (alertId.equals("3")) {
				pstmt = con.prepareStatement(CashVanManagementStatements.GET_DISTRESS_ALERT);
				pstmt.setInt(1, offset);
				pstmt.setString(2, alertId);
				pstmt.setInt(3, Integer.parseInt(customerid));
				pstmt.setInt(4, systemId);
			} 
			else {
					if (alertId.equals("1")) {
					pstmt = con.prepareStatement(CashVanManagementStatements.GET_STOPPAGE_ALERT_DETAILS);
				} else if (alertId.equals("39")) {
					pstmt = con.prepareStatement(CashVanManagementStatements.GET_IDLE_ALERT_DETAILS);
				}
				else if (alertId.equals("117") || alertId.equals("118")) {
					pstmt = con.prepareStatement(CashVanManagementStatements.GET_PARKING_ALERT_DETAILS);
				}else {
					pstmt = con.prepareStatement(CashVanManagementStatements.GET_ALERT_DETAILS);
				}
				pstmt.setInt(1, offset);
				pstmt.setString(2, alertId);
				pstmt.setInt(3, offmin);
				pstmt.setInt(4, Integer.parseInt(customerid));
				pstmt.setInt(5, systemId);
			}
			rs = pstmt.executeQuery();
			while (rs.next()) {
				int flag = 1;
				if (rs.getString("TYPE_OF_ALERT").equals("2")) {
					flag = 0;
					if (rs.getDouble("OVERSPEEDLIMIT") > 0) {
						if (rs.getDouble("OVERSPEED") >= rs
								.getDouble("OVERSPEEDLIMIT")) {
							flag = 1;
						}
					} else if (speedlimit >= 0) {
						if (rs.getDouble("OVERSPEED") >= speedlimit) {
							flag = 1;
						}
					}
				}
				if (flag == 1) {
				alertdetailsJSONObject=new JSONObject();
				alertslno=rs.getInt("SLNO");
				vehicleNo=rs.getString("REGISTRATION_NO");
				alertdate=rs.getTimestamp("ALERT_DATE");
				location=rs.getString("LOCATION");
				speed=rs.getString("SPEED");
				remarks=rs.getString("REMARKS");
				driverId = rs.getInt("DRIVER NAME");
				groupname=rs.getString("GROUP_NAME");
				String driverName = "";

					if (driverId > 0) {
						pstmt1 = con.prepareStatement("select case when Mobile is not null and Mobile<>'' then Fullname+' ('+(Mobile)+')' else Fullname end as DriverName from Driver_Master where System_id=? and Driver_id=?");
						pstmt1.setInt(1, systemId);
						pstmt1.setInt(2, driverId);
						rs1 = pstmt1.executeQuery();
						if (rs1.next()) {
							driverName = rs1.getString("DriverName");
						}
					}
					if (remarks.equals("N")) {
						remarks = "";
					}
			alertdetailsJSONObject.put("alertslno", alertslno);
			alertdetailsJSONObject.put("VehicleNo", vehicleNo);
			alertdetailsJSONObject.put("groupname",groupname);
			alertdetailsJSONObject.put("alertdate",sdfyyyymmddhhmmss.format(alertdate));
			alertdetailsJSONObject.put("location",location);
			alertdetailsJSONObject.put("speed", speed);
			alertdetailsJSONObject.put("remarks",remarks);
			alertdetailsJSONObject.put("drivername",driverName);
			alertdetailsJSONArray.put(alertdetailsJSONObject);
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if (pstmt1 != null) {
				pstmt1 = null;
			}
			if (rs1 != null) {
				rs1 = null;
			}
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}

		return alertdetailsJSONArray;
	}
	public int saveCVSRemarks(String alertslno, String remark, String regno,String date,
			String typeofalert,int offset,String clientId, int systemId) {
		Connection conAdmin=null;
		PreparedStatement pstmt=null;
		int result=0;
		ArrayList<Integer> statutoryalertList=new ArrayList<Integer>();
		String AlertDATEG = "";
		String AlertDATEP="";
		try {
			statutoryalertList.add(10);
			statutoryalertList.add(11);
			statutoryalertList.add(12);
			statutoryalertList.add(13);
			statutoryalertList.add(15);
			statutoryalertList.add(130);
			statutoryalertList.add(66);
			statutoryalertList.add(32);
			statutoryalertList.add(33);
			statutoryalertList.add(34);
			statutoryalertList.add(35);
			statutoryalertList.add(36);
			statutoryalertList.add(131);
			statutoryalertList.add(67);
			conAdmin=DBConnection.getConnectionToDB("AMS");
			if(typeofalert.equals("-5")) // Preventive Alert 
			{
				pstmt=conAdmin.prepareStatement(CashVanManagementStatements.SAVE_PREVENTIVE_REMARKS);
				pstmt.setString(1, remark);
				pstmt.setInt(2, Integer.parseInt(alertslno));
				pstmt.setString(3, regno);
				pstmt.setInt(4, Integer.parseInt(clientId));
				pstmt.setInt(5, systemId);
			}
			else if(statutoryalertList.contains(Integer.parseInt(typeofalert))) // Statuatory Alert 
			{
				pstmt=conAdmin.prepareStatement(CashVanManagementStatements.SAVE_STATUTORY_REMARKS);
				pstmt.setString(1, remark);
				pstmt.setInt(2, Integer.parseInt(alertslno));
				pstmt.setInt(3, Integer.parseInt(clientId));
				pstmt.setInt(4, systemId);
			}
			else if((Integer.parseInt(typeofalert))==2){
				pstmt = conAdmin.prepareStatement(CashVanManagementStatements.SAVE_OVERSPEED_REMARKS);
				pstmt.setString(1, remark);
				pstmt.setInt(2, Integer.parseInt(alertslno));
				pstmt.setString(3, regno);
				pstmt.setInt(4, Integer.parseInt(clientId));
				pstmt.setInt(5, systemId);
			}
			else
			{
				if (date.contains("T")) {
					date = date.substring(0, date.indexOf("T")) + " "+ date.substring(date.indexOf("T") + 1, date.length());
					AlertDATEP = getFormattedDateStartingFromMonth(date);
					AlertDATEG = cf.getLocalDateTime(AlertDATEP, offset);
					AlertDATEG = getFormattedDateStartingFromyear(AlertDATEG);
				} else {
					AlertDATEP = getFormattedDateStartingFromMonth(date);
					AlertDATEG = cf.getLocalDateTime(AlertDATEP, offset);
					AlertDATEG = getFormattedDateStartingFromyear(AlertDATEG);
				}	
			pstmt=conAdmin.prepareStatement(CashVanManagementStatements.SAVE_ALERT_REMARK);
			pstmt.setString(1, remark);
			pstmt.setString(2, AlertDATEG);
			pstmt.setString(3, regno);
			pstmt.setInt(4, Integer.parseInt(typeofalert));
			pstmt.setInt(5, Integer.parseInt(clientId));
			pstmt.setInt(6, systemId);
			}
			result=pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		}finally{
			DBConnection.releaseConnectionToDB(conAdmin, pstmt, null);
		}
		return result;
	
	}
	
	/**
	 * @param con
	 * @param clientId
	 * @param systemid
	 * @return
	 */
	public double getOverspeedrange(Connection con,int clientId, int systemid) {

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		double speedlimit = 0.0;
		try {
			if (clientId != 0) {
				String str1 = " select isnull(OverSpeedLimit,0) as OverSpeedLimit, isnull(OverSpeedLimitforGRCli,0) as OverSpeedLimitforGRCli from dbo.tblCustomerMaster where CustomerId=? and System_id=?  ";
				pstmt = con.prepareStatement(str1);
				pstmt.setInt(1, clientId);
				pstmt.setInt(2, systemid);
				rs = pstmt.executeQuery();
				if (rs.next()) {
					double a1 = rs.getDouble("OverSpeedLimit");
					double a2 = rs.getDouble("OverSpeedLimitforGRCli");
					if (a2 != 0) {
						if (a1 > a2) {
							speedlimit = a2;
						} else {
							speedlimit = a1;
						}
					} else {
						speedlimit = a1;
					}
				}
			}
		} catch (Exception e) {
			System.out.println("Error when saving Action Taken..in SQLFUNC:"
					+ e);
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(null, pstmt, null);
		}
		return speedlimit;
	}
	public JSONArray getStateWiseStatutoryDetails(String typeofalert,
			String state,int offset,String clientId, int systemId , int userId) {
		Connection con = null;
		PreparedStatement pstmt = null;
		PreparedStatement pstmt1 = null;
		ResultSet rs = null;
		ResultSet rs1 = null;
		String vehicleNo="";
		Date alertdate=new Date();;
		String location="";
		String speed="";
		String remarks="";
		String groupname="";
		int alertslno=0;
		int driverId=0;
		JSONArray alertdetailsJSONArray=new JSONArray();
		JSONObject alertdetailsJSONObject;
		try {
			con = DBConnection.getConnectionToDB("AMS");
			if(state.equalsIgnoreCase("Other"))
			{
				if( Integer.parseInt(typeofalert) == 66 ||  Integer.parseInt(typeofalert) == 67 ){
					pstmt = con.prepareStatement(CashVanManagementStatements.GET_STATUTORRY_STATEWISE_DETAILS_OTHERS);
					pstmt.setInt(1, offset);
					pstmt.setInt(2, Integer.parseInt(clientId));
					pstmt.setInt(3, systemId);
					pstmt.setInt(4, offset);
					pstmt.setInt(5, Integer.parseInt(typeofalert));	
				}else  if(typeofalert.equals("33") || typeofalert.equals("11")){
					String replace="a.AlertId in (11,127) ";
					if(typeofalert.equals("33")){
						replace="a.AlertId in (33,128) ";
					}
					String stmt=CashVanManagementStatements.GET_STATUTORRY_STATEWISE_DETAILS_OTHERS_NEW.replace("a.AlertId=? ", replace);

					//System.out.println(stmt);
					pstmt = con.prepareStatement(stmt);
					pstmt.setInt(1, offset);
					pstmt.setInt(2, Integer.parseInt(clientId));
					pstmt.setInt(3, systemId);
					pstmt.setInt(4, offset);
					pstmt.setInt(5, systemId);
					pstmt.setInt(6, userId);
					}
				
				else{
			pstmt = con.prepareStatement(CashVanManagementStatements.GET_STATUTORRY_STATEWISE_DETAILS_OTHERS_NEW);
			pstmt.setInt(1, offset);
			pstmt.setInt(2, Integer.parseInt(clientId));
			pstmt.setInt(3, systemId);
			pstmt.setInt(4, offset);
			pstmt.setInt(5, Integer.parseInt(typeofalert));
			pstmt.setInt(6, systemId);
			pstmt.setInt(7, userId);
			}
			//pstmt.setInt(6, offset);
			//pstmt.setInt(7, Integer.parseInt(clientId));
			//pstmt.setInt(8, systemId);
			//pstmt.setInt(9, offset);
			//pstmt.setInt(10, Integer.parseInt(typeofalert));
			}
			else
			{
				if( Integer.parseInt(typeofalert) == 66 ||  Integer.parseInt(typeofalert) == 67 ){
					pstmt = con.prepareStatement(CashVanManagementStatements.GET_STATUTORY_ALERT_DETAILS);
					pstmt.setInt(1, offset);
					pstmt.setInt(2, Integer.parseInt(clientId));
					pstmt.setInt(3, systemId);
					pstmt.setInt(4, offset);
					pstmt.setInt(5, Integer.parseInt(typeofalert));
					pstmt.setString(6, state);	
				}
			else{	
			pstmt = con.prepareStatement(CashVanManagementStatements.GET_STATUTORY_ALERT_DETAILS_NEW);
			pstmt.setInt(1, offset);
			pstmt.setInt(2, Integer.parseInt(clientId));
			pstmt.setInt(3, systemId);
			pstmt.setInt(4, offset);
			pstmt.setInt(5, Integer.parseInt(typeofalert));
			pstmt.setString(6, state);
			pstmt.setInt(7, systemId);
			pstmt.setInt(8, userId);
			}
			//pstmt.setInt(7, offset);
			//pstmt.setInt(8, Integer.parseInt(clientId));
			//pstmt.setInt(9, systemId);
			//pstmt.setInt(10, offset);
			//pstmt.setInt(11, Integer.parseInt(typeofalert));
			//pstmt.setString(12, state);
			}
			rs = pstmt.executeQuery();
			int count=0;
			while (rs.next()) {
				count++;
				alertdetailsJSONObject=new JSONObject();
				alertslno=rs.getInt("SLNO");
				vehicleNo=rs.getString("REGISTRATION_NO");
				alertdate=rs.getTimestamp("ALERT_DATE");
				location=rs.getString("LOCATION");
				speed=rs.getString("SPEED");
				remarks=rs.getString("REMARKS");
				driverId = rs.getInt("DRIVER NAME");
				groupname=rs.getString("GROUP_NAME");
				String driverName = "";

					if (driverId > 0) {
						pstmt1 = con.prepareStatement("select case when Mobile is not null and Mobile<>'' then Fullname+' ('+(Mobile)+')' else Fullname end as DriverName from Driver_Master where System_id=? and Driver_id=?");
						pstmt1.setInt(1, systemId);
						pstmt1.setInt(2, driverId);
						rs1 = pstmt1.executeQuery();
						if (rs1.next()) {
							driverName = rs1.getString("DriverName");
						}
					}
					if (remarks.equals("N")) {
						remarks = "";
					}
			alertdetailsJSONObject.put("alertslno", alertslno);
			alertdetailsJSONObject.put("VehicleNo", vehicleNo);
			alertdetailsJSONObject.put("groupname",groupname);
			alertdetailsJSONObject.put("alertdate",sdfyyyymmddhhmmss.format(alertdate));
			alertdetailsJSONObject.put("location",location);
			alertdetailsJSONObject.put("speed", speed);
			alertdetailsJSONObject.put("remarks",remarks);
			alertdetailsJSONObject.put("drivername",driverName);
			alertdetailsJSONArray.put(alertdetailsJSONObject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if (pstmt1 != null) {
				pstmt1 = null;
			}
			if (rs1 != null) {
				rs1 = null;
			}
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}

		return alertdetailsJSONArray;
	}
	public String getFormattedDateStartingFromyear(String inputDate) {
		String formattedDate = "";
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

		SimpleDateFormat sdfFormatDate = new SimpleDateFormat("MM/dd/yyyy HH:mm:ss");
		try {
			if (inputDate != null && !inputDate.equals("")) {
				java.util.Date d = sdfFormatDate.parse(inputDate);
				formattedDate = sdf.format(d);
			}
		} catch (Exception e) {
			System.out
					.println("Error in getFormattedDateStartingFromMonth() method"
							+ e);
		}
		return formattedDate;
	}
	public String getFormattedDateStartingFromMonth(String inputDate) {
		String formattedDate = "";
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

		SimpleDateFormat sdfFormatDate = new SimpleDateFormat("MM/dd/yyyy HH:mm:ss");
		try {
			if (inputDate != null && !inputDate.equals("")) {
				java.util.Date d = sdf.parse(inputDate);
				formattedDate = sdfFormatDate.format(d);
			}
		} catch (Exception e) {
			System.out
					.println("Error in getFormattedDateStartingFromMonth() method"
							+ e);
		}
		return formattedDate;
	}
	
	/*****************************************************************************************************************************************/
	
	
	public JSONArray getCustomer(int customerId, int systemId) {
	    Connection conAdmin = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
	    JSONArray jsonArray = new JSONArray();
	    JSONObject jsonObject = new JSONObject();	
	    try {
	        conAdmin = DBConnection.getConnectionToDB("AMS");
	        pstmt = conAdmin.prepareStatement(CashVanManagementStatements.GET_CVS_CUSTOMER);
	        pstmt.setInt(1, customerId);
	        pstmt.setInt(2, systemId);
	        rs = pstmt.executeQuery();
	        while (rs.next()) {
	            jsonObject = new JSONObject();
	            jsonObject.put("customerName2", rs.getString("CustomerName"));
	            jsonArray.put(jsonObject);
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	        DBConnection.releaseConnectionToDB(conAdmin, pstmt, rs);
	    }
	    return jsonArray;
	}
	
	
	
	public JSONArray getRegion(int customerId, int systemId) {
	    Connection conAdmin = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
	    JSONArray jsonArray = new JSONArray();
	    JSONObject jsonObject = new JSONObject();	
	    try {
	        conAdmin = DBConnection.getConnectionToDB("AMS");
	        pstmt = conAdmin.prepareStatement(CashVanManagementStatements.GET_REGION);
	        pstmt.setInt(1, systemId);
	        pstmt.setInt(2, customerId);
	        rs = pstmt.executeQuery();
	        while (rs.next()) {
	            jsonObject = new JSONObject();
	            jsonObject.put("regionName", rs.getString("RegionName"));
	            jsonArray.put(jsonObject);
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	        DBConnection.releaseConnectionToDB(conAdmin, pstmt, rs);
	    }
	    return jsonArray;
	}
	
	public JSONArray getLocation(int customerId, int systemId, String region) {
	    Connection conAdmin = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
	    JSONArray jsonArray = new JSONArray();
	    JSONObject jsonObject = new JSONObject();
	    try {
	        conAdmin = DBConnection.getConnectionToDB("AMS");
	        pstmt = conAdmin.prepareStatement(CashVanManagementStatements.GET_LOCATION);
	        pstmt.setInt(1, systemId);
	        pstmt.setInt(2, customerId);
	        pstmt.setString(3, region);
	        rs = pstmt.executeQuery();
	        while (rs.next()) {
	            jsonObject = new JSONObject();
	            jsonObject.put("locationName", rs.getString("LocationName"));
	            jsonArray.put(jsonObject);
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	        DBConnection.releaseConnectionToDB(conAdmin, pstmt, rs);
	    }
	    return jsonArray;
	}
	
	public JSONArray getHub(int customerId, int systemId, String region, String location) {
	    Connection conAdmin = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
	    JSONArray jsonArray = new JSONArray();
	    JSONObject jsonObject = new JSONObject();	   
	    try {
	        conAdmin = DBConnection.getConnectionToDB("AMS");
	        pstmt = conAdmin.prepareStatement(CashVanManagementStatements.GET_HUB);
	        pstmt.setInt(1, systemId);
	        pstmt.setInt(2, customerId);
	        pstmt.setString(3, region);
	        pstmt.setString(4, location);
	        rs = pstmt.executeQuery();
	        while (rs.next()) {
	            jsonObject = new JSONObject();
	            jsonObject.put("hubName", rs.getString("HubName"));
	            jsonArray.put(jsonObject);
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	        DBConnection.releaseConnectionToDB(conAdmin, pstmt, rs);
	    }
	    return jsonArray;
	}
	
	public JSONArray getHubDel(int customerId, int systemId, String TripNo) {
	    Connection conAdmin = null;
	    PreparedStatement pstmt = null,pstmt1=null;
	    ResultSet rs = null,rs1=null;
	    JSONArray jsonArray = new JSONArray();
	    JSONObject jsonObject = new JSONObject();
	   try {
	        conAdmin = DBConnection.getConnectionToDB("AMS");
	        pstmt = conAdmin.prepareStatement(CashVanManagementStatements.GET_TRIP_HUB_PLANNER);
	        String[] tripNo = TripNo.split("-");
            pstmt.setInt(1, Integer.parseInt(tripNo[1]));
            pstmt.setInt(2, systemId);
            pstmt.setInt(3, customerId);
            rs = pstmt.executeQuery();
            pstmt1 = conAdmin.prepareStatement(CashVanManagementStatements.GET_BANK); 
            while (rs.next()) {
	        	String bsnId=rs.getString("Atm");
	        	pstmt1.setInt(1, systemId);
	            pstmt1.setInt(2, customerId);
	            pstmt1.setString(3,bsnId);
	            rs1=pstmt1.executeQuery();
	            if(rs1.next())
	            {
	            	jsonObject = new JSONObject();
	            	jsonObject.put("hubDelName", rs1.getString("AtmName"));
	            	jsonArray.put(jsonObject);
	            }
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	        DBConnection.releaseConnectionToDB(conAdmin, pstmt, rs);
	        DBConnection.releaseConnectionToDB(null, pstmt1, rs1);
	    }
	    return jsonArray;
	}
	
	public JSONArray getRoute(int customerId, int systemId) {
	    Connection conAdmin = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
	    JSONArray jsonArray = new JSONArray();
	    JSONObject jsonObject = new JSONObject();
	    try {
	        conAdmin = DBConnection.getConnectionToDB("AMS");
	        pstmt = conAdmin.prepareStatement(CashVanManagementStatements.GET_ROUTE);
	        pstmt.setInt(1, systemId);
	        pstmt.setInt(2, customerId);
	      
	        rs = pstmt.executeQuery();
	        while (rs.next()) {
	            jsonObject = new JSONObject();
	            jsonObject.put("routeName", rs.getString("routeName"));
	            jsonObject.put("routeId", rs.getString("routeId"));
	            jsonArray.put(jsonObject);
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	        DBConnection.releaseConnectionToDB(conAdmin, pstmt, rs);
	    }
	    return jsonArray;
	}
	
	public JSONArray getTripSheetNo(int customerId, int systemId,int routeId, String date) {
	    Connection conAdmin = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
	    JSONArray jsonArray = new JSONArray();
	    JSONObject jsonObject = new JSONObject();
	    try {
	        conAdmin = DBConnection.getConnectionToDB("AMS");
	        pstmt = conAdmin.prepareStatement(CashVanManagementStatements.GET_TRIP_SHEET_NO);
	        pstmt.setInt(1, systemId);
	        pstmt.setInt(2, customerId);
	        pstmt.setInt(3, routeId);
	        pstmt.setString(4, yyyymmdd.format(yyyymmdd.parse(date.replace(date.substring(11,date.length()), "00:00:00"))));
	      
	        rs = pstmt.executeQuery();
	        while (rs.next()) {
	            jsonObject = new JSONObject();
	            jsonObject.put("TripSheetNo", rs.getString("TripSheetNo"));
	            jsonArray.put(jsonObject);
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	        DBConnection.releaseConnectionToDB(conAdmin, pstmt, rs);
	    }
	    return jsonArray;
	}
	
	public JSONArray getATM(int customerId, int systemId, String tripSheetNo) {
	    Connection conAdmin = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
	    JSONArray jsonArray = new JSONArray();
	    JSONObject jsonObject = new JSONObject();
        try {
	        conAdmin = DBConnection.getConnectionToDB("AMS");
	        pstmt = conAdmin.prepareStatement(CashVanManagementStatements.GET_ATMS);
	        pstmt.setInt(1, systemId);
	         pstmt.setInt(2, customerId);
	         pstmt.setString(3, tripSheetNo);

	        rs = pstmt.executeQuery();
	        while (rs.next()) {
	            jsonObject = new JSONObject();
	            jsonObject.put("Id", rs.getString("ID"));
	            jsonObject.put("atmId", rs.getString("BusinessId"));
	            jsonObject.put("atmName", rs.getString("TripType"));
	            jsonObject.put("customer", rs.getString("Customer"));
	            jsonObject.put("businessId", rs.getString("BusinessId"));
	            jsonObject.put("onAccountDataIndex",rs.getString("onAccOf"));
	            
	            jsonArray.put(jsonObject);
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	        DBConnection.releaseConnectionToDB(conAdmin, pstmt, rs);
	    }
	    return jsonArray;
	}
	
	public JSONArray getVehicleNo(int customerId, int systemId, int userId, int offset) {
	    Connection conAdmin = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
	    JSONArray jsonArray = new JSONArray();
	    JSONObject jsonObject = new JSONObject();
	    try {
	        conAdmin = DBConnection.getConnectionToDB("AMS");
	        pstmt = conAdmin.prepareStatement(CashVanManagementStatements.GET_VEHICLE_NOS);
	        pstmt.setInt(1, customerId);
	        pstmt.setInt(2, systemId);
	        pstmt.setInt(3, userId);
	        pstmt.setInt(4, systemId);
	        pstmt.setInt(5, customerId);
	        pstmt.setInt(6, offset);
	        pstmt.setInt(7, offset);
	        rs = pstmt.executeQuery();
	        while (rs.next()) {
	            jsonObject = new JSONObject();
	            jsonObject.put("vehicleNoName", rs.getString("VehicleNo"));
	            jsonArray.put(jsonObject);
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	        DBConnection.releaseConnectionToDB(conAdmin, pstmt, rs);
	    }
	    return jsonArray;
	}
	
	public JSONArray getDriverName(int customerId, int systemId, int offset) {
	    Connection conAdmin = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
	    JSONArray jsonArray = new JSONArray();
	    JSONObject jsonObject = new JSONObject();
	    try {
	        conAdmin = DBConnection.getConnectionToDB("AMS");
	        pstmt = conAdmin.prepareStatement(CashVanManagementStatements.GET_DRIVER_NAMES);
	        pstmt.setInt(1, customerId);
	        pstmt.setInt(2, systemId);
	        pstmt.setInt(3, 1);
	        pstmt.setInt(4, systemId);
	        pstmt.setInt(5, customerId);
	        pstmt.setInt(6, offset);
	        pstmt.setInt(7, offset);
	        rs = pstmt.executeQuery();
	        while (rs.next()) {
	            jsonObject = new JSONObject();
	            jsonObject.put("driverName", rs.getString("DriverName"));
	            jsonObject.put("driverId", rs.getString("DriverId"));
	            jsonArray.put(jsonObject);
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	        DBConnection.releaseConnectionToDB(conAdmin, pstmt, rs);
	    }
	    return jsonArray;
	}
	
	public JSONArray getGunman(int customerId, int systemId, int offset) {
	    Connection conAdmin = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
	    JSONArray jsonArray = new JSONArray();
	    JSONObject jsonObject = new JSONObject();
	    try {
	        conAdmin = DBConnection.getConnectionToDB("AMS");
	        pstmt = conAdmin.prepareStatement(CashVanManagementStatements.GET_GUNMAN);
	        pstmt.setInt(1, 2);
	        pstmt.setInt(2, customerId);
	        pstmt.setInt(3, systemId);
	        pstmt.setInt(4, systemId);
	        pstmt.setInt(5, customerId);
	        pstmt.setInt(6, offset);
	        pstmt.setInt(7, offset);
	        pstmt.setInt(8, systemId);
	        pstmt.setInt(9, customerId);
	        pstmt.setInt(10, offset);
	        pstmt.setInt(11, offset);
	        rs = pstmt.executeQuery();
	        while (rs.next()) {
	            jsonObject = new JSONObject();
	            jsonObject.put("gunman1Name", rs.getString("FullName"));
	            jsonObject.put("gunman1Id", rs.getString("GunmanId"));
	            jsonArray.put(jsonObject);
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	        DBConnection.releaseConnectionToDB(conAdmin, pstmt, rs);
	    }
	    return jsonArray;
	}
	
	public JSONArray getCustoName(int customerId, int systemId, String route) {
	    Connection conAdmin = null;
	    PreparedStatement pstmt = null;
	    Connection con = null;
	    ResultSet rs = null;
	    JSONArray jsonArray = new JSONArray();
	    JSONObject jsonObject = new JSONObject();
	    try {
	        conAdmin = DBConnection.getConnectionToDB("ADMINISTRATOR");
	        pstmt = conAdmin.prepareStatement(CashVanManagementStatements.GET_CUSTODIAN_NAME_FROM_BUSINESS_DETAILS);
	        pstmt.setInt(1, systemId);
	        pstmt.setInt(2, customerId);
	        pstmt.setString(3, route);
	        rs = pstmt.executeQuery();
	        while (rs.next()) {
	            jsonObject = new JSONObject();
	            jsonObject.put("custoName", rs.getString("CustodianName"));
	            jsonArray.put(jsonObject);
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	        DBConnection.releaseConnectionToDB(con, pstmt, rs);
	    }
	    return jsonArray;
	}
	public JSONArray getCustodianName(int customerId, int systemId, int offset) {
	    Connection conAdmin = null;
	    PreparedStatement pstmt = null;
	    Connection con = null;
	    ResultSet rs = null;
	    JSONArray jsonArray = new JSONArray();
	    JSONObject jsonObject = new JSONObject();
	    try {
	        conAdmin = DBConnection.getConnectionToDB("ADMINISTRATOR");
	        pstmt = conAdmin.prepareStatement(CashVanManagementStatements.GET_CUSTODIAN_NAME);
	        pstmt.setInt(1, 8);
	        pstmt.setInt(2, customerId);
	        pstmt.setInt(3, systemId);
	        pstmt.setInt(4, systemId);
	        pstmt.setInt(5, customerId);
	        pstmt.setInt(6, offset);
	        pstmt.setInt(7, offset);
	        pstmt.setInt(8, systemId);
	        pstmt.setInt(9, customerId);
	        pstmt.setInt(10, offset);
	        pstmt.setInt(11, offset);
	        rs = pstmt.executeQuery();
	        while (rs.next()) {
	            jsonObject = new JSONObject();
	            jsonObject.put("custodianName", rs.getString("Fullname"));
	            jsonObject.put("custodianId", rs.getString("Driver_id"));
	            jsonObject.put("preferedCompany", rs.getString("preferedCompany"));
	            jsonArray.put(jsonObject);
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	        DBConnection.releaseConnectionToDB(con, pstmt, rs);
	    }
	    return jsonArray;
	}
	public String insertTripPlannerInformation(int custId, String region, String location, String hub, String routeName, String vehicleNo, String driverName, int gunman1, int gunman2, int userId, int systemId,String custodianName1,String custodianName2,double openingOdometer,String tripCreationDate ,int offset,String tripsheetNo,int routeId) {
	    Connection con = null;
	    PreparedStatement pstmt = null, pstmt2 = null;
	    PreparedStatement pstmt1 = null;
	    ResultSet rs1 = null;
	    String message = "";
	    try {
	        int tripId = 0;
	        con = DBConnection.getConnectionToDB("AMS");
	        pstmt1 = con.prepareStatement(CashVanManagementStatements.SELECT_MAX_TRIP_ID);
	        pstmt1.setInt(1, systemId);
	        pstmt1.setInt(2, custId);
	        rs1 = pstmt1.executeQuery();
	        while (rs1.next()) {
	            tripId = rs1.getInt("");
	        }
	        ++tripId;
	        pstmt = con.prepareStatement(CashVanManagementStatements.INSERT_TRIPPLANNER_INFORMATION);
	        pstmt.setString(1, region);
	        pstmt.setString(2, location);
	        pstmt.setString(3, hub);
	        pstmt.setString(4, routeName);
	        pstmt.setString(5, vehicleNo);
	        pstmt.setInt(6, Integer.parseInt(driverName));
	        pstmt.setInt(7, gunman1);
	        pstmt.setInt(8, gunman2);
	        pstmt.setInt(9, userId);
	        pstmt.setInt(10, tripId);
	        pstmt.setInt(11, systemId);
	        pstmt.setInt(12, custId);
	        pstmt.setString(13, custodianName1);
	        pstmt.setString(14, custodianName2);
	        pstmt.setDouble(15, openingOdometer);
	        pstmt.setInt(16, offset);
	        pstmt.setString(17, yyyymmdd.format(yyyymmdd.parse(tripCreationDate)));
	        pstmt.setString (18,tripsheetNo);
	        pstmt.setInt (19,routeId);
	        int inserted = pstmt.executeUpdate();
            if (inserted > 0) {
	        	  message = "Saved Successfully";
	           
	           // pstmt2 = con.prepareStatement(CashVanManagementStatements.INSERT_TRIP_HUB_PLANNER);
	           pstmt2 = con.prepareStatement(CashVanManagementStatements.UPDATE_CASH_DESPENSE_DETAILS);
	           
	                pstmt2.setString(1, tripsheetNo);
	                pstmt2.setInt(2, systemId);
	                pstmt2.setInt(3, custId);
	                
	                int inserted1 = pstmt2.executeUpdate();
	                if (inserted1 > 0) {
	                    message = "Saved Successfully";
	                }
	            	 
	            
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	        DBConnection.releaseConnectionToDB(con, pstmt, null);
	        DBConnection.releaseConnectionToDB(null, pstmt1, rs1);
	        DBConnection.releaseConnectionToDB(null, pstmt2, null);
	    }
	    return message;
	}
	public String addRouteDetails(String routeId,String routeName, String status, int systemId,int custId)
	{
		Connection con = null;
		PreparedStatement pstmt= null;
		ResultSet rs = null;
		String message="";
		
		try
		{
			 con = DBConnection.getConnectionToDB("AMS");
			 pstmt = con.prepareStatement(CashVanManagementStatements.CHECK_ROUTE_ALREADY_EXIST);
			 pstmt.setString(1, routeId);
			 pstmt.setInt(2, systemId);
			 pstmt.setInt(3, custId);
			 rs = pstmt.executeQuery();
			 if(rs.next())
			 {
				 message="Route Id Already Exist";
				 return message; 
			 }else{
			 pstmt = con.prepareStatement(CashVanManagementStatements.CHECK_ROUTENAME_IF_ALREADY_EXIST);
				 pstmt.setString(1, routeName);
				 pstmt.setInt(2, systemId);
				 pstmt.setInt(3, custId);
				 rs = pstmt.executeQuery(); 
				 if(rs.next())
				 {
					 message="Route Name Already Exist";
					 return message; 
				 }
				 
				 else {
			 pstmt = con.prepareStatement(CashVanManagementStatements.INSERT_ROUTE);
			 pstmt.setString(1, routeId);
			 pstmt.setString(2, "");
			 pstmt.setString(3, routeName);
			 pstmt.setString(4, status);
			 pstmt.setInt(5, systemId);
			 pstmt.setInt(6, custId);
			 int inserted = pstmt.executeUpdate();
			if (inserted > 0) {
                  message = "Saved Successfully";
             }
		}
		}
		}
		 catch (Exception e)
		 {
				System.out.println("error in:-save RouteMaster details "+e.toString());
				e.printStackTrace();
		 }      
		finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
	    }
		return message;
				
	}
	public String modifyRouteMaster(String routeId,String routeName, String status,int systemId, int custId, int id){
		Connection con=null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		String message="";
		try{
			con=DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(CashVanManagementStatements.CHECK_ROUTE_ALREADY_EXIST_FOR_MODIFY);
			pstmt.setString(1, routeId);
			pstmt.setInt(2, id);
			rs = pstmt.executeQuery();
			if(rs.next()){
				message="<p>Route ID Already Exists.</p>";
				return message;
			}else{
				pstmt = con.prepareStatement(CashVanManagementStatements.CHECK_ROUTENAME_IF_ALREADY_EXIST_FOR_MODIFY);
				pstmt.setString(1, routeName);
				pstmt.setInt(2, id);
				rs = pstmt.executeQuery(); 
				if(rs.next()){
					message="Route Name Already Exist.";
					return message; 
				}else {
					pstmt=con.prepareStatement(CashVanManagementStatements.UPDATE_ROUTE);
					pstmt.setString(1,routeId);
					pstmt.setString(2,"");
					pstmt.setString(3,routeName);
					pstmt.setString(4,status);
					pstmt.setInt(5,systemId);
					pstmt.setInt(6,custId);
					pstmt.setInt(7,id);
					int updated=pstmt.executeUpdate();
					if(updated>0){
						message = "Updated Successfully";
					}
				}
			}
		}catch(Exception e){
			System.out.println("error in :-update RouteMaster details "+e.toString());
			e.printStackTrace();
		}finally{
			DBConnection.releaseConnectionToDB(con,pstmt,rs);
		}
		return message;
	}
	
	
	public ArrayList < Object > getRouteMasterDetails(int systemId, int customerId) {
	    JSONArray JsonArray = new JSONArray();
	    JSONObject JsonObject = null;
	    Connection con = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
	    ArrayList < Object > finlist = new ArrayList < Object > ();
	    try {
	        int count = 0;
	        con = DBConnection.getConnectionToDB("AMS");
	        pstmt = con.prepareStatement(CashVanManagementStatements.GET_ROUTE_DETAILS);
	        pstmt.setInt(1, systemId);
	        pstmt.setInt(2, customerId);
	        rs = pstmt.executeQuery();
	        while (rs.next()) {
	            JsonObject = new JSONObject();
	            count++;
	            JsonObject.put("slnoIndex", count);
	            JsonObject.put("uniqueIdDataIndex", rs.getInt("id"));
	            JsonObject.put("routeIdDataIndex", rs.getString("routeId").toUpperCase());
	            JsonObject.put("routeNameIndex", rs.getString("routeName").toUpperCase());
	            JsonObject.put("routeTypeIndex", rs.getString("routeType").toUpperCase());
	            JsonObject.put("statusIndex", rs.getString("status"));
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
	
	public String modifyTripPlannerInformation(int custId, String region, String location, String hub, String routeName, String vehicleNo, String driverName, String gunman1, String gunman2, String TripNo, int userId, int systemId, int id, String atm, String tobeDeleted) {
	    Connection con = null;
	    PreparedStatement pstmt = null, pstmt1 = null;
	    ResultSet rs = null;
	    String message = "";
	    String atm1 = "";
	    ResultSet rs1 = null;
	    String[] atms = null;
	    String[] tripNo = TripNo.split("-");
	    try {
	        con = DBConnection.getConnectionToDB("AMS");
	        con.setAutoCommit(false);

	            String[] atms11 = atm.split("\\|");
	            for (int i = 0; i < atms11.length; i++) {
	            	
	            	if(atms11[i].length()>0){
		            	String data[]=atms11[i].split(",");
	                pstmt = con.prepareStatement(CashVanManagementStatements.CHECK_PRESENT_OR_NOT);
	                pstmt.setString(1, data[0]);
	                pstmt.setInt(2, Integer.parseInt(tripNo[1]));
	                pstmt.setInt(3, custId);
	                pstmt.setInt(4, systemId);
	                rs1 = pstmt.executeQuery();
	                if (!rs1.next()) {
	                    pstmt = con.prepareStatement(CashVanManagementStatements.INSERT_ALL_TRIP_ID_TO_PLANNER_HUB);
	                    pstmt.setInt(1, Integer.parseInt(tripNo[1]));
	                    pstmt.setString(2, data[0]);
	                    pstmt.setInt(3, custId);
	                    pstmt.setInt(4, systemId);
	                    pstmt.setString(5, data[1]);
		                if(data.length>=3){
		                if(!(data[2].equals("undefined"))){
		                	 pstmt.setInt(6, Integer.parseInt(data[2]));
		                }else{
		                	 pstmt.setInt(6,0);
		                }
		                }
	                    int updated3 = pstmt.executeUpdate();
	                }
	            }}
	            message = "Updated Successfully";
	        //}
	        con.commit();
	    } catch (Exception e) {
	        e.printStackTrace();
	        try {
	            if (con != null) con.rollback();
	        } catch (Exception ex) {
	            ex.printStackTrace();
	        }
	    } finally {
	        DBConnection.releaseConnectionToDB(con, pstmt, rs);
	        DBConnection.releaseConnectionToDB(null, pstmt1, rs1);
	    }
	    return message;
	}
	
	public ArrayList < Object > getTripPlanReport(int customerId, int systemId,int offset) {
	    Connection conAdmin = null;
	    PreparedStatement pstmt = null, pstmt1 = null;
	    ResultSet rs = null, rs1 = null;
	    JSONArray jsonArray = new JSONArray();
	    JSONObject jsonObject = null;
	    ArrayList < Object > finlist = new ArrayList < Object > ();
	    SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
	    try {
	        int count = 0;
	        conAdmin = DBConnection.getConnectionToDB("AMS");
	        pstmt = conAdmin.prepareStatement(CashVanManagementStatements.GET_TRIPPLAN_REPORT);
	        pstmt.setInt(1, offset);
	        pstmt.setInt(2, offset);
	        pstmt.setInt(3, offset);
	        pstmt.setInt(4, systemId);
	        pstmt.setInt(5, customerId);
	        rs = pstmt.executeQuery();
	        pstmt1 = conAdmin.prepareStatement(CashVanManagementStatements.GET_TRIP_HUB_PLANNER);
	        while (rs.next()) {
	            count++;
	            String Atms = "";
	            jsonObject = new JSONObject();
	            jsonObject.put("slnoIndex", count);
	            jsonObject.put("tripSheetNoDataIndex", rs.getString("TRIP_SHEET_NO"));
	            jsonObject.put("uniqueIdDataIndex", rs.getString("UniqueId"));
	            jsonObject.put("tripNoDataIndex", rs.getString("TripNo"));
	            jsonObject.put("vehicleNoDataIndex", rs.getString("VehicleNo"));
	            jsonObject.put("regionDataIndex", rs.getString("Region"));
	            jsonObject.put("locationDataIndex", rs.getString("Location"));
	            jsonObject.put("hubDataIndex", rs.getString("Hub"));
	            jsonObject.put("routeNameDataIndex", rs.getString("RouteName"));
	            jsonObject.put("routeIdDataIndex", rs.getString("ROUTE_ID"));	            
	            jsonObject.put("atmsDataIndex", "Atms");
	            if(rs.getString("TripCreationDate")==""|| rs.getString("TripCreationDate").contains("1900"))
				{
	            	   jsonObject.put("tripCreationDateDataIndex", "");
				}
				else
				{	
					   jsonObject.put("tripCreationDateDataIndex", sdf.format(rs.getTimestamp("TripCreationDate")));
				}
	            jsonObject.put("openingOdometerDataIndex", rs.getString("OpeningOdometer"));
	            jsonObject.put("custodian1DataIndex", rs.getString("CustodianName1"));
	            jsonObject.put("custodian2DataIndex", rs.getString("CustodianName2"));
	            jsonObject.put("driverNameDataIndex", rs.getString("DriverName"));
	            jsonObject.put("gunman1DataIndex", rs.getString("Gunman1"));
	            jsonObject.put("gunman2DataIndex", rs.getString("Gunman2"));
	            String[] tripNo = rs.getString("TripNo").split("-");
	            pstmt1.setInt(1, Integer.parseInt(tripNo[1]));
	            pstmt1.setInt(2, systemId);
	            pstmt1.setInt(3, customerId);
	            rs1 = pstmt1.executeQuery();
	            while (rs1.next()) {
	                if (Atms.isEmpty()) {
	                    Atms = rs1.getString("Atm");
	                } else {
	                    Atms = Atms + "," + rs1.getString("Atm");
	                }
	            }
	            jsonObject.put("atmsDataIndex", Atms);
	            jsonObject.put("statusDataIndex", rs.getString("Status"));
	            jsonObject.put("closingOdometerDataIndex", rs.getString("ClosingOdometer"));
	            if (rs.getString("StartDate") == null || rs.getString("StartDate").equals("") || rs.getString("StartDate").contains("1900")) {
	                jsonObject.put("startDateDataIndex", "");
	            } else {
	                jsonObject.put("startDateDataIndex", sdf.format(rs.getTimestamp("StartDate")));
	            }
	           
	            if (rs.getString("ClosedDate") == null || rs.getString("ClosedDate").equals("") || rs.getString("ClosedDate").contains("1900")) {
	                jsonObject.put("closedDateDataIndex", "");
	            } else {
	                jsonObject.put("closedDateDataIndex", sdf.format(rs.getTimestamp("ClosedDate")));
	            }
	            jsonArray.put(jsonObject);
	        }
	        finlist.add(jsonArray);
	    } catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	        DBConnection.releaseConnectionToDB(conAdmin, pstmt, rs);
	        DBConnection.releaseConnectionToDB(null, pstmt1, rs1);
	    }
	    return finlist;
	}
	
	public String delData(int customerId, int systemId, String hubDel, String date, String TripNo,int offset,int userid,double closingOdometer,String vehicleNo,String tripStartDate,String tripshtNo) {
	    Connection conAdmin = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
	    String message = "";
	    String tripStartDategmt=null;
	    String tripEndDateTime=null;
	    String[] tripNo = TripNo.split("-");
	    int update;
	    try {
	        conAdmin = DBConnection.getConnectionToDB("AMS");
	    	if (tripStartDate!=null && !tripStartDate.equals("") && !tripStartDate.contains("1900-01")) {
				String tripStartDateeg=tripStartDate.replace("T", " ");
				tripStartDategmt=cf.getGMTDateTime(sdfFormatDate.format(yyyymmdd.parse(tripStartDateeg)), offset);
				tripEndDateTime=cf.getGMTDateTime(sdfFormatDate.format(sdfyyyymmddhhmmss.parse(date)), offset);
				
				calculateDitanceForTransitPoints(conAdmin, vehicleNo, systemId, customerId, offset, tripStartDategmt, tripEndDateTime, Integer.parseInt(tripNo[1]));
				double totaldistance = getTotalTravelledDistance(conAdmin, vehicleNo, systemId, customerId, offset, tripStartDategmt, tripEndDateTime);
		 
		        pstmt = conAdmin.prepareStatement(CashVanManagementStatements.UPDATE_TRIP_CLOSED_IN_TRIP_PLANNER);
		        pstmt.setString(1, hubDel);
		        pstmt.setInt(2, offset);
		        pstmt.setString(3, yyyymmdd.format(yyyymmdd.parse(date)));
		        pstmt.setInt(4,userid);
		        pstmt.setDouble(5,closingOdometer);
		        pstmt.setDouble(6,totaldistance);
		        pstmt.setInt(7, Integer.parseInt(tripNo[1]));
		        pstmt.setInt(8, systemId);
		        pstmt.setInt(9, customerId);
		        update = pstmt.executeUpdate();
		        if (update > 0) {
		        	 pstmt = conAdmin.prepareStatement(CashVanManagementStatements.UPDATE_CASH_DESPENSE_DETAILS_FOR_CLOSE_TRIPS);	
					  pstmt.setString(1, tripshtNo);
		                pstmt.setInt(2, systemId);
		                pstmt.setInt(3, customerId);
		                
		                int inserted1 = pstmt.executeUpdate();
		                if (inserted1 > 0) {
		                    message = "Saved Successfully";
		                }
		            message = "Trip Closed Successfully";
		        }
	    	}
	    } catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	        DBConnection.releaseConnectionToDB(conAdmin, pstmt, rs);
	    }
	    return message;
	}
	
	public double getTotalTravelledDistance(Connection conAdmin,String vehicleNo,int systemId, int customerId, int offset, String starttime,String endtime){
		double totaldistance = 0;
		try {
			VehicleActivity vi=new VehicleActivity(conAdmin, vehicleNo, sdfFormatDate.parse(starttime), sdfFormatDate.parse(endtime),offset, systemId, customerId,0);
			VehicleSummaryBean vsb = vi.getVehicleSummaryBean();
			
			double ConversionFactor = initializedistanceConversionFactor(systemId, conAdmin, vehicleNo);
			totaldistance = (vsb.getTotalDistanceTravelled()* ConversionFactor);
			totaldistance = Double.parseDouble(df.format(totaldistance));
		} catch (Exception e) {
			e.printStackTrace();
		}
		return totaldistance;
	}
	
	public void calculateDitanceForTransitPoints(Connection con,String vehicleNo,int systemId, int customerId, int offset, String starttime,String endtime,int tripId){
		PreparedStatement psmt = null;
		ResultSet rs = null;
		int count=0;
		try {
			String transitstrattime =sdfFormatDate.format(sdfFormatDate.parse(starttime));
			String transitendtime = "";
			psmt=con.prepareStatement(CashVanManagementStatements.GET_ARRIVAL_AND_DEPARTURE_DATETIME,ResultSet.TYPE_SCROLL_SENSITIVE,ResultSet.CONCUR_UPDATABLE);
			psmt.setInt(1, systemId);
			psmt.setInt(2, tripId);
			psmt.setInt(3, customerId);
			rs = psmt.executeQuery();
			while(rs.next()){
				count++;
				transitendtime = rs.getString("ATM_ARRIVAL_DATETIME");
				transitendtime = sdfFormatDate.format(yyyymmdd.parse(transitendtime));
				double totaldistance = getTotalTravelledDistance(con, vehicleNo, systemId, customerId, offset, transitstrattime, transitendtime);
				rs.updateDouble("DISTANCE_TRAVELLED", totaldistance);
				rs.updateRow();
				transitstrattime = rs.getString("ATM_DEPARTURE_DATETIME");
				transitstrattime = sdfFormatDate.format(yyyymmdd.parse(transitstrattime));
			}
		} catch (Exception e) {
			 e.printStackTrace();
		}
	}
/**********************************************************************DASHBOARD*************************************************************************************/
	
 	public JSONArray getCMSDashBoardDetails(int systemId, int custId,int offset) {
	    JSONArray JsonArray = null;
	    Connection con = null;
	    PreparedStatement pstmt = null;
	    PreparedStatement pstmt1 = null;
	    JSONObject obj1 = null;
	    ResultSet rs = null;
	    ResultSet rs1 = null;
	    SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
	    int count=0;
	    try {
	        JsonArray = new JSONArray();
	        con = DBConnection.getConnectionToDB("AMS");
			count++;
			 pstmt = con.prepareStatement(CashVanManagementStatements.GET_CMS_GRID_DETAILS);
			 pstmt.setInt(1, offset);
	         pstmt.setInt(2, systemId);
	         pstmt.setInt(3, custId);
	         rs1 = pstmt.executeQuery();
	        while (rs1.next()) {
	            obj1 = new JSONObject();
	            obj1.put("tripNumberDataIndex", rs1.getString("TripId"));
	            obj1.put("registrationNumberDataIndex", rs1.getString("assetNumber"));
	            obj1.put("hubDataIndex", rs1.getString("hub"));
	            obj1.put("routeDataIndex", rs1.getString("routeName"));
	            obj1.put("pointTovisitDataIndex", rs1.getString("pointsToVisit"));
		            if (rs1.getString("StartDateTime") == null || rs1.getString("StartDateTime").equals("") || rs1.getString("StartDateTime").contains("1900")) {
	            	 obj1.put("startDateAndTimeDataIndex", "");
	            } else {
	            	 obj1.put("startDateAndTimeDataIndex", sdf.format(rs1.getTimestamp("StartDateTime")));
	            }
	            obj1.put("gunman1DataIndex", rs1.getString("Gunman1"));
	            obj1.put("gunman2DataIndex", rs1.getString("Gunman2"));
	            obj1.put("driverNameDataIndex", rs1.getString("driverName"));
	            String custodianNames ="";
	            if(rs1.getString("custodianName1").equals("") && !rs1.getString("custodianName2").equals("") ){
	            	custodianNames = rs1.getString("custodianName2");	
	            }else if(rs1.getString("custodianName2").equals("") && !rs1.getString("custodianName1").equals("")){
	            	custodianNames = rs1.getString("custodianName1");	
	            }else if (!rs1.getString("custodianName1").equals("") && !rs1.getString("custodianName2").equals("") ){
		        custodianNames = rs1.getString("custodianName1")+","+rs1.getString("custodianName2");
	            }
	            obj1.put("custodianNameDataIndex",custodianNames );
	            obj1.put("locationDataIndex", rs1.getString("location"));
	            
	            JsonArray.put(obj1);
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	        DBConnection.releaseConnectionToDB(con, pstmt, rs1);
	    }
	    return JsonArray;
	}

	public JSONArray getDataForCMSDashBoardMap(int systemId, int custId,String tripId,String assetNumber) {
	    JSONArray JsonArray = null;
	    Connection con = null;
	    PreparedStatement pstmt = null;
	    PreparedStatement pstmt1 = null;
	    JSONObject obj1 = null;
	    ResultSet rs = null;
	    ResultSet rs1 = null;
	    String TripNo[] =null;
	    int count=0;
	    try {
	        JsonArray = new JSONArray();
	        con = DBConnection.getConnectionToDB("AMS");
			count++;
			 pstmt = con.prepareStatement(CashVanManagementStatements.GET_LATLONG_FOR_CMS_DASHBOARD);
			 pstmt.setString(1, assetNumber);
	         pstmt.setInt(2, systemId);
	         pstmt.setInt(3, custId);
	         rs1 = pstmt.executeQuery();
	        while (rs1.next()) {
	            obj1 = new JSONObject();
	            obj1.put("regNo", rs1.getString("registrationNumber"));
	            obj1.put("longitude", rs1.getString("longitude"));
	            obj1.put("latitude", rs1.getString("lattitude"));
	            obj1.put("speed", rs1.getString("speed"));
	            obj1.put("location", rs1.getString("location"));
	            obj1.put("dateTime", rs1.getString("dateTime"));
	            obj1.put("category", rs1.getString("category"));
	            JsonArray.put(obj1);
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	        DBConnection.releaseConnectionToDB(con, pstmt, rs1);
	    }
	    return JsonArray;
	}

	public JSONArray getTripPointsForCmsDasbBooard(int systemId, int custId,String tripId) {
	    JSONArray JsonArray = null;
	    Connection con = null;
	    PreparedStatement pstmt = null;
	    PreparedStatement pstmt1 = null;
	    JSONObject obj1 = null;
	    ResultSet rs = null;
	    String TripNo[] =null;
	    ResultSet rs1 = null;
	    ResultSet rs2 = null;
	    ResultSet rs3 = null;
	    int count=0;
	    try {
	        JsonArray = new JSONArray();
	        con = DBConnection.getConnectionToDB("AMS");
			count++;
			TripNo=tripId.split("-");
			 pstmt = con.prepareStatement(CashVanManagementStatements.GET_ATM_FROM_TRIP_HUB_PLANNER_FOR_VISITED);
			 pstmt.setString(1, TripNo[0]);
	         pstmt.setInt(2, systemId);
	         pstmt.setInt(3, custId);
	         rs = pstmt.executeQuery();
	        while (rs.next()) {
			   pstmt = con.prepareStatement(CashVanManagementStatements.GET_LATLONG_FOR_CMS_TRIP_POINTS_FROM_CVS_TRIP_DETAILS);
			   pstmt.setString(1, rs.getString("ATM"));
	          // pstmt.setInt(2, systemId);
	          // pstmt.setInt(3, custId);
	           rs1 = pstmt.executeQuery();
	           if(rs1.next())
	           {
	        	    obj1 = new JSONObject();
	                obj1.put("regNo", "");
	                obj1.put("longitude", rs1.getString("longitude"));
	                obj1.put("latitude", rs1.getString("lattitude"));
	                obj1.put("speed", "");
	                obj1.put("location", rs1.getString("hubLocation"));
	                obj1.put("dateTime", "");
	                obj1.put("category", "Visited");
	                JsonArray.put(obj1);
	           }
	           
 	        }
	        pstmt.close();
			 pstmt = con.prepareStatement(CashVanManagementStatements.GET_ATM_FROM_TRIP_HUB_PLANNER_FOR_PENDING);
			 pstmt.setString(1, TripNo[0]);
	         pstmt.setInt(2, systemId);
	         pstmt.setInt(3, custId);
	         rs3 = pstmt.executeQuery();
	         while (rs3.next()) {
				   pstmt = con.prepareStatement(CashVanManagementStatements.GET_LATLONG_FOR_CMS_TRIP_POINTS_FROM_CVS_TRIP_DETAILS);
				   pstmt.setString(1, rs3.getString("ATM"));
		          // pstmt.setInt(2, systemId);
		          // pstmt.setInt(3, custId);
		           rs2 = pstmt.executeQuery();
		           if(rs2.next())
		           {
		            obj1 = new JSONObject();
	                obj1.put("regNo", "");
	                obj1.put("longitude", rs2.getString("longitude"));
	                obj1.put("latitude", rs2.getString("lattitude"));
	                obj1.put("speed", "");
	                obj1.put("location", rs2.getString("hubLocation"));
	                obj1.put("dateTime", "");
	                obj1.put("category", "Pending");
	                JsonArray.put(obj1);
	 	        }
	         }
	    } catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	        DBConnection.releaseConnectionToDB(con, pstmt, rs);
	        DBConnection.releaseConnectionToDB(null, null, rs1);
	        DBConnection.releaseConnectionToDB(null, null, rs2);
	        DBConnection.releaseConnectionToDB(null, null, rs3);
	    }
	    return JsonArray;
	}
	
	public JSONArray getVehicleOffRoadDetails(int customerId, int systemId, int userId,int offset){
		 	JSONArray JsonArray = null;
		    Connection con = null;
		    PreparedStatement pstmt = null;		  
		    JSONObject obj1 = null;
		    ResultSet rs = null;
		    try{
		    	 JsonArray = new JSONArray();
		    	 con = DBConnection.getConnectionToDB("AMS");
		    	 pstmt = con.prepareStatement(CashVanManagementStatements.GET_VEHICLE_OFF_ROAD_DETAILS);
		    	 pstmt.setInt(1,offset );
		    	 pstmt.setInt(2,userId );
		         pstmt.setInt(3, systemId);
		         pstmt.setInt(4, customerId);
		         pstmt.setInt(5,offset );
		         pstmt.setInt(6,userId );
		         pstmt.setInt(7, systemId);
		         pstmt.setInt(8, customerId);
		         rs = pstmt.executeQuery();
		         while(rs.next()){
		        	 obj1 = new JSONObject();		               
		                obj1.put("VehicleNo", rs.getString("RegistrationNo"));
		                obj1.put("jobcardtypeindex", rs.getString("JobCardType"));		               
		                obj1.put("jobcarddateindex", sdfyyyymmddhhmmss.format(yyyymmdd.parse(rs.getString("JobCardDate"))));		               
		                JsonArray.put(obj1);
		         }
		    	 
		    }catch (Exception e) {
				e.printStackTrace();
			}finally{
				 DBConnection.releaseConnectionToDB(con, pstmt, rs);
			}
		    
		    return JsonArray;
	}

	public double initializedistanceConversionFactor(int SystemId,Connection con,String registrationNo){
		PreparedStatement pstmt=null;
		ResultSet rs=null;
	    double distanceConversionFactor;
		distanceConversionFactor = 1.0;
		String distanceUnitName = "kms";
		try{	
			pstmt=con.prepareStatement(CargomanagementStatements.GET_DISTANCE_CONVERSION_FACTOR);
			pstmt.setInt(1,SystemId);
			pstmt.setString(2,registrationNo);
			rs = pstmt.executeQuery();
			while(rs.next()){
				distanceUnitName = rs.getString("UnitName");
				distanceConversionFactor=rs.getDouble("ConversionFactor");
			}
		}
		catch(Exception e){			  
				e.printStackTrace();
		}
		finally{
			DBConnection.releaseConnectionToDB(null, pstmt, rs);
		}
		return distanceConversionFactor;
	}
	
	public ArrayList < Object > getTripSummaryReport(int customerId, int systemId,int offset,String startdate,String enddate,String language) {
	    Connection con = null;
	    PreparedStatement pstmt = null ;
	    ResultSet rs = null;
	    JSONArray jsonArray = new JSONArray();
	    JSONObject jsonObject = null;
	    ArrayList < Object > finlist = new ArrayList < Object > ();
	    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	    ArrayList<ReportHelper> reportsList = new ArrayList<ReportHelper>();
		ArrayList<String> headersList = new ArrayList<String>();
		ReportHelper finalreporthelper = new ReportHelper();
	    int time=0;
	    String totalHours=null;
	    double totalOdo;
	    String custodianName=null;
	    String gunMan=null;
	    try {
	    	headersList.add(cf.getLabelFromDB("SLNO", language));
        	headersList.add(cf.getLabelFromDB("Vehicle_No", language));
        	headersList.add(cf.getLabelFromDB("Trip_No", language));
        	headersList.add(cf.getLabelFromDB("Region", language));
			headersList.add(cf.getLabelFromDB("Location", language));
			headersList.add(cf.getLabelFromDB("Hub", language));
			headersList.add(cf.getLabelFromDB(" Route", language));
			headersList.add(cf.getLabelFromDB("Custodian_Name", language));
			headersList.add(cf.getLabelFromDB("Driver_Name", language));
			headersList.add(cf.getLabelFromDB("Gunman_Name", language));
			headersList.add(cf.getLabelFromDB("Trip_Start_Date_Time", language));
			headersList.add(cf.getLabelFromDB("Trip_End_Date_Time", language));
			headersList.add(cf.getLabelFromDB("Trip_Start_Veh_ODO", language));
			headersList.add(cf.getLabelFromDB("Trip_End_Veh_ODO", language));
			headersList.add(cf.getLabelFromDB("Total_Trip_Hrs", language));
			headersList.add(cf.getLabelFromDB("No_Of_Points_Visited", language));
			headersList.add(cf.getLabelFromDB("Total_Kms_By_GPS", language));
			headersList.add(cf.getLabelFromDB("Total_Kms_By_Veh_ODO", language));
			
	        int count = 0;
	        con = DBConnection.getConnectionToDB("AMS");
	        pstmt = con.prepareStatement(CashVanManagementStatements.GET_TRIP_SUMMARY_REPORT);
	        pstmt.setInt(1, offset);
	        pstmt.setInt(2, offset);
	        pstmt.setInt(3, offset);
	        pstmt.setInt(4, offset);
	        pstmt.setInt(5, systemId);
	        pstmt.setInt(6, customerId);
	        pstmt.setInt(7, offset);
	        pstmt.setString(8, startdate);
	        pstmt.setInt(9, offset);
	        pstmt.setString(10, enddate);
	        rs = pstmt.executeQuery();
	        while (rs.next()) {
	        	ArrayList<Object> informationList = new ArrayList<Object>();
	        	ReportHelper reporthelper = new ReportHelper();
	            count++;
	            double openOdo=rs.getDouble("OpeningOdometer");
	            double closeOdo=rs.getDouble("ClosingOdometer");
	            time =rs.getInt("TotalTripMins");
	            totalHours=cf.convertMinutesToHHMMFormat(time);
	            totalOdo=closeOdo-openOdo;
	            jsonObject = new JSONObject();
	            
	            informationList.add(count);
	            jsonObject.put("slnoIndex", count);
	            
	            informationList.add(rs.getString("VehicleNo"));
	            jsonObject.put("vehicleNoDataIndex", rs.getString("VehicleNo"));
	            
	            informationList.add(rs.getString("TripNo"));
	            jsonObject.put("tripNoDataIndex", rs.getString("TripNo"));
	            
	            informationList.add(rs.getString("Region"));
	            jsonObject.put("regionDataIndex", rs.getString("Region"));
	            
	            informationList.add(rs.getString("Location"));
	            jsonObject.put("locationDataIndex", rs.getString("Location"));
	            
	            informationList.add(rs.getString("Hub"));
	            jsonObject.put("hubDataIndex", rs.getString("Hub"));
	            
	            informationList.add(rs.getString("RouteName"));
	            jsonObject.put("routeDataIndex", rs.getString("RouteName"));
	            
	            
	            if(!rs.getString("CustodianName2").trim().equals("")){
	            	custodianName=rs.getString("CustodianName1")+" , "+rs.getString("CustodianName2");
	            }
	            else{
	            	custodianName=rs.getString("CustodianName1");
	            }

	            informationList.add(custodianName);
	            jsonObject.put("custodian1DataIndex",custodianName);
	            
	            informationList.add(rs.getString("DriverName"));
	            jsonObject.put("driverDataIndex", rs.getString("DriverName"));
	            
	            if(!rs.getString("Gunman2").trim().equals("")){
	            	gunMan=rs.getString("Gunman1")+" , "+rs.getString("Gunman2");
	            }
	            else{
	            	gunMan=rs.getString("Gunman1");
	            }
	            
	            informationList.add(gunMan);
	            jsonObject.put("gunMan1DataIndex", gunMan);
	            
	            if(rs.getString("StartDateTime")==""|| rs.getString("StartDateTime").contains("1900"))
				{
	            	informationList.add("");
	            	jsonObject.put("startDateDataIndex", "");
				}
				else
				{	
					informationList.add(ddmmyyyy.format(yyyymmdd.parse(rs.getString("StartDateTime"))));
					jsonObject.put("startDateDataIndex", sdf.format(rs.getTimestamp("StartDateTime")));
				}
	            if(rs.getString("CloseDateTime")==""|| rs.getString("CloseDateTime").contains("1900"))
				{
	            	informationList.add("");
	            	jsonObject.put("endDateDataIndex", "");
				}
				else
				{
					informationList.add(ddmmyyyy.format(yyyymmdd.parse(rs.getString("CloseDateTime"))));
				    jsonObject.put("endDateDataIndex", sdf.format(rs.getTimestamp("CloseDateTime")));
				}
	            
	            informationList.add(rs.getString("OpeningOdometer"));
	            jsonObject.put("startOdoDataIndex", rs.getString("OpeningOdometer"));
	            
	            informationList.add(rs.getString("ClosingOdometer"));
	            jsonObject.put("endOdoDataIndex", rs.getString("ClosingOdometer"));
	            
	            informationList.add(totalHours);
	            jsonObject.put("totalHrsDataIndex", totalHours);
	            
	            informationList.add(rs.getString("NO_OF_POINTS_VISITED"));
	            jsonObject.put("visitedPointsDataIndex", rs.getString("NO_OF_POINTS_VISITED"));
	            
	            informationList.add(rs.getString("TotalKms"));
	            jsonObject.put("totalDistanceDataIndex", rs.getString("TotalKms"));
	            
	            informationList.add(totalOdo);
	            jsonObject.put("totalOdometerDataIndex", totalOdo);
	            
	            jsonArray.put(jsonObject);
	            reporthelper.setInformationList(informationList);
				reportsList.add(reporthelper);
	            
	        }
	        finalreporthelper.setReportsList(reportsList);
			finalreporthelper.setHeadersList(headersList);
		    finlist.add(jsonArray);
			finlist.add(finalreporthelper);
	     
	    } catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	        DBConnection.releaseConnectionToDB(con, pstmt, rs);
	    }
	    return finlist;
	}
	public JSONArray getTripNo(int customerId, int systemId,String startDate,String endDate,int offSet) {
	    Connection con = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
	    JSONArray jsonArray = new JSONArray();
	    JSONObject jsonObject = new JSONObject();
	    try {
	        con = DBConnection.getConnectionToDB("AMS");
	        pstmt = con.prepareStatement(CashVanManagementStatements.GET_TRIP_NOS);
	        pstmt.setInt(1, systemId);
	        pstmt.setInt(2, customerId);
	        pstmt.setInt(3, offSet);
	        pstmt.setString(4, startDate);
	        pstmt.setInt(5, offSet);
	        pstmt.setString(6, endDate);
	        rs = pstmt.executeQuery();
	        while (rs.next()) {
	            jsonObject = new JSONObject();
	            jsonObject.put("tripNo", rs.getString("TripNo"));
	            jsonArray.put(jsonObject);
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	        DBConnection.releaseConnectionToDB(con, pstmt, rs);
	    }
	    return jsonArray;
	}
	
	public ArrayList < Object > getTripDetailsReport(int customerId, int systemId,int offset,String tripNumber) {
	    Connection con = null;
	    PreparedStatement pstmt = null ;
	    ResultSet rs = null;
	    JSONArray jsonArray = new JSONArray();
	    JSONObject jsonObject = null;
	    ArrayList < Object > finlist = new ArrayList < Object > ();
	    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	    ArrayList<ReportHelper> reportsList = new ArrayList<ReportHelper>();
		ArrayList<String> headersList = new ArrayList<String>();
		ReportHelper finalreporthelper = new ReportHelper();
		String tripNo[]=null;
	    try {
	    	headersList.add("SLNO");
        	headersList.add("Vehicle No");
        	headersList.add("Trip No");
			headersList.add("Trip Start Date");
			headersList.add("Trip End Date");
			headersList.add("Business Id");
			headersList.add("Business Type");
			headersList.add("MSP");
			headersList.add("Bank");
			headersList.add("Arrival Date Time");
			headersList.add("Departure Date Time");
			headersList.add("Duration(MM)");
			headersList.add("Distance Travelled(Kms)");
			headersList.add("On Acc Of");
			headersList.add("Job Completion Date");
			headersList.add("Location");
			headersList.add("Total Amount");
			
			tripNo=tripNumber.split("-");
	        int count = 0;
	        con = DBConnection.getConnectionToDB("AMS");
	        pstmt = con.prepareStatement(CashVanManagementStatements.GET_TRIP_DETAILS_REPORT);
	        pstmt.setInt(1, offset);
	        pstmt.setInt(2, offset);
	        pstmt.setInt(3, offset);
	        pstmt.setInt(4, systemId);
	        pstmt.setInt(5, customerId);
	        pstmt.setInt(6,Integer.parseInt(tripNo[1]));
	        rs = pstmt.executeQuery();
	        while (rs.next()) {
	        	ArrayList<Object> informationList = new ArrayList<Object>();
	        	ReportHelper reporthelper = new ReportHelper();
	            count++;
	            jsonObject = new JSONObject();
	            
	            informationList.add(count);
	            jsonObject.put("slnoIndex", count);
	            
	            informationList.add(rs.getString("VehicleNo"));
	            jsonObject.put("vehicleNumberDataIndex", rs.getString("VehicleNo"));
	            
	            informationList.add(rs.getString("TripNo"));
	            jsonObject.put("tripNoDataIndex", rs.getString("TripNo"));
	            
	            if(rs.getString("StartDateTime")==""|| rs.getString("StartDateTime").contains("1900"))
				{
	            	informationList.add("");
	            	jsonObject.put("startDtDataIndex", "");
				}
				else
				{	
					informationList.add(ddmmyyyy.format(yyyymmdd.parse(rs.getString("StartDateTime"))));
					jsonObject.put("startDtDataIndex", sdf.format(rs.getTimestamp("StartDateTime")));
				}
	            if(rs.getString("CloseDateTime")==""|| rs.getString("CloseDateTime").contains("1900"))
				{
	            	informationList.add("");
	            	jsonObject.put("endDtDataIndex", "");
				}
				else
				{
					informationList.add(ddmmyyyy.format(yyyymmdd.parse(rs.getString("CloseDateTime"))));
				    jsonObject.put("endDtDataIndex", sdf.format(rs.getTimestamp("CloseDateTime")));
				}
	            
	            informationList.add(rs.getString("Business_Id"));
	            jsonObject.put("businessIdDataIndex", rs.getString("Business_Id"));
	            
	            informationList.add(rs.getString("Business_Type"));
	            jsonObject.put("businessTypeDataIndex", rs.getString("Business_Type"));
	            
	            informationList.add("");
	            jsonObject.put("mspDataIndex", "");
	            
	            informationList.add(rs.getString("Bank"));
	            jsonObject.put("bankDataIndex", rs.getString("Bank"));
	           
            	informationList.add("");
            	jsonObject.put("arrivalTimeDataIndex", "");
			
            	informationList.add("");
            	jsonObject.put("deptTimeDataIndex", "");
	            
	            informationList.add("");
	            jsonObject.put("durationDataIndex", "" );
	            	           
	            informationList.add("");
	            jsonObject.put("kmsTravelledDataIndex","");
	            
	            informationList.add(rs.getString("On_Acc_Of"));
	            jsonObject.put("OnAccOfDataIndex",rs.getString("On_Acc_Of"));
	            
	            if(rs.getString("JobCompletionDate")==""|| rs.getString("JobCompletionDate").contains("1900")){
	            	informationList.add("");
	            	jsonObject.put("jobCompletionDataIndex", "");
				}else{	
					informationList.add(ddmmyyyy.format(yyyymmdd.parse(rs.getString("JobCompletionDate"))));
					jsonObject.put("jobCompletionDataIndex", sdf.format(rs.getTimestamp("JobCompletionDate")));
				}
	            
	            informationList.add(rs.getString("Location"));
	            jsonObject.put("locationDataIndex",rs.getString("Location"));
	            
	            informationList.add(rs.getString("TOTAL_AMOUNT"));
	            jsonObject.put("totalAmountDataIndex",rs.getString("TOTAL_AMOUNT"));
	            
	            jsonArray.put(jsonObject);
	            reporthelper.setInformationList(informationList);
				reportsList.add(reporthelper);
	            
	        }
	        finalreporthelper.setReportsList(reportsList);
			finalreporthelper.setHeadersList(headersList);
		    finlist.add(jsonArray);
			finlist.add(finalreporthelper);
	     
	    } catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	        DBConnection.releaseConnectionToDB(con, pstmt, rs);
	    }
	    return finlist;
	}
	
	
	public JSONArray getRoutenames(int cutomerId, int systemId) {

		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject = new JSONObject();
		Connection con=null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		try{
			con = DBConnection.getConnectionToDB("AMS");
			jsonArray = new JSONArray();
			jsonObject = new JSONObject();
			pstmt = con.prepareStatement(CashVanManagementStatements.GET_ROUTE_NAMES);
			pstmt.setInt(1,cutomerId);
			pstmt.setInt(2,systemId);
			rs=pstmt.executeQuery();
			while(rs.next()){
				jsonObject = new JSONObject();
				jsonObject.put("RouteId", rs.getString("RouteID"));
				jsonObject.put("RouteName", rs.getString("RouteName"));
				jsonArray.put(jsonObject);				
			}
		}catch(Exception e){
			System.out.println("Error in getCustomer "+e.toString());
		}	
		finally{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}	
		return jsonArray;
	
	}
	
	
	public JSONArray getgroupnamesForAlert(int clientid, int systemid,int userId)
	{
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject = new JSONObject();
		Connection con=null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		try 
		{
			con = DBConnection.getConnectionToDB("AMS");
			jsonArray = new JSONArray();
			jsonObject = new JSONObject();
			pstmt = con.prepareStatement(CashVanManagementStatements.GET_GROUP_NAME_FOR_CLIENT);
			pstmt.setInt(1,systemid);
			pstmt.setInt(2,clientid);
			pstmt.setInt(3, userId);
			pstmt.setInt(4, systemid);
			pstmt.setInt(5, clientid);
			rs = pstmt.executeQuery();

			while (rs.next()) 
			{
				
				jsonObject = new JSONObject();
				jsonObject.put("groupId", rs.getString("GROUP_ID"));
				jsonObject.put("groupName", rs.getString("GROUP_NAME"));
				jsonArray.put(jsonObject);	
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
	

	public JSONArray getVehiclesAndGroupForClient(int systemId, int clientId,
			int userId,int groupId) {
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject = new JSONObject();
		Connection con=null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;

		try {
			con = DBConnection.getConnectionToDB("AMS");
			jsonArray = new JSONArray();
			jsonObject = new JSONObject();
		
			if(groupId==0){
				pstmt = con.prepareStatement(CashVanManagementStatements.GET_VEHICLE_FOR_CLIENT_WITHOUT_GROUP_ID);
				pstmt.setInt(1, clientId);
				pstmt.setInt(2, systemId);
				pstmt.setInt(3, userId);
				pstmt.setInt(4, systemId);
				pstmt.setInt(5, clientId);
				pstmt.setInt(6, systemId);
				pstmt.setInt(7, clientId);
		        rs = pstmt.executeQuery();
			}
			
			while (rs.next()) {
				jsonObject = new JSONObject();
				jsonObject.put("groupId", rs.getInt("GROUP_ID"));
				jsonObject.put("vehicleName", rs.getString("REGISTRATION_NUMBER"));
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
	public synchronized String insertTripDetails(int custId,int routeName,int returnRouteName, String assignTo,
			int groupName,String vehicleNo,String guestAlert,String mobileNo,String emailId,String status, int userID,int systemId,int uniqueId,
			String tripType,int days,int auto,String alertName,String superEmailId, String superMobileNo) {
	
		Connection con=null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		String message="";
		 try {
		con = DBConnection.getConnectionToDB("AMS");
		
		pstmt = con.prepareStatement(CashVanManagementStatements.CREATE_TRIP_DETAILS);
		pstmt.setInt(1, routeName);
		
		pstmt.setInt(2,returnRouteName);
		pstmt.setString(3, assignTo);
		pstmt.setInt(4, groupName);
		pstmt.setString(5, vehicleNo);
		pstmt.setInt(6, uniqueId);
		pstmt.setString(7, guestAlert);
		pstmt.setString(8, emailId);
		pstmt.setString(9, mobileNo);
		pstmt.setString(10, status);
		pstmt.setInt(11, systemId);
		pstmt.setInt(12, custId);
		pstmt.setInt(13, userID);
		pstmt.setString(14, tripType);
		pstmt.setInt(15, days);
		pstmt.setInt(16, auto);
		pstmt.setString(17, alertName);
		pstmt.setString(18, superEmailId);
		pstmt.setString(19, superMobileNo);
        
        int inserted = pstmt.executeUpdate();
        if (inserted > 0) {
            message = "Saved Successfully";
        }
		 }
		catch (Exception e) {
			
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}

		return message;

	}
	
	
	public String modifyTripDetails(int custId, String guestAlert,String mobileNo,String emailId, int userID,int systemId,int uniqueId,String status,String superEmailId,String superMobileNo) {
		
		Connection con=null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		String message="";
		 try {
		con = DBConnection.getConnectionToDB("AMS");
		
		pstmt = con.prepareStatement(CashVanManagementStatements.MODIFY_TRIP_DETAILS);
		pstmt.setString(1, guestAlert);
		pstmt.setString(2, emailId);
		pstmt.setString(3, mobileNo);
		pstmt.setInt(4, userID);
		pstmt.setString(5, status);
		pstmt.setString(6, superEmailId);
		pstmt.setString(7, superMobileNo);
		pstmt.setInt(8, uniqueId);
		 int updated = pstmt.executeUpdate();
	        if (updated > 0) {
	            message = "Updated Successfully";
	        }
		 }
			catch (Exception e) {
				
				e.printStackTrace();
			} finally {
				DBConnection.releaseConnectionToDB(con, pstmt, rs);
			}
		return message;
	}
	
	public ArrayList < Object > getTripDetails(int systemId, int customerId,String startDate,String endDate) {
	    JSONArray JsonArray = new JSONArray();
	    JSONObject JsonObject = null;
	    Connection con = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
	    ArrayList < Object > finlist = new ArrayList < Object > ();
	    try {
	    	int count = 0;
	        
	  
	        con = DBConnection.getConnectionToDB("AMS");
	        pstmt = con.prepareStatement(CashVanManagementStatements.GET_TRIP_DETAILS);
	        pstmt.setInt(1, systemId);
	        pstmt.setInt(2, customerId);
	        pstmt.setString(3, startDate);
	        pstmt.setString(4, endDate);
	        rs = pstmt.executeQuery();
	        
	        SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
			
	        while (rs.next()) {
	            JsonObject = new JSONObject();
	            count++;
	           
	            JsonObject.put("slnoIndex", count);
	            
	            JsonObject.put("uniqueIdIndex",rs.getInt("ID"));
	            
	            
	            JsonObject.put("routeNameDataIndex", rs.getString("RouteName"));
	            
	        //    JsonObject.put("returnTripDataIndex", rs.getString("RETURN_TRIP"));
	            
	            JsonObject.put("returnrouteNameDataIndex", rs.getString("RETURN_ROUTE_NAME"));

	            JsonObject.put("assignToDataIndex", rs.getString("ASSIGN_TO"));
	            
	            
	            JsonObject.put("groupNameDataIndex", rs.getString("GROUP_NAME"));
	            JsonObject.put("groupIdDataIndex", rs.getInt("GROUP_ID"));
	            
	            JsonObject.put("vehicleDataIndex", rs.getString("ASSET_NO"));
	            
	            JsonObject.put("uniqueNoDataIndex", rs.getString("UNIQUE_ID"));
	           
	            JsonObject.put("guestAlertDataIndex", rs.getString("GUEST_ALERT"));
	            
	            JsonObject.put("mobileDataIndex", rs.getString("MOBILE_NUM"));
	            
	            JsonObject.put("emailDataIndex", rs.getString("EMAIL_ID"));
	            
	            JsonObject.put("insertedByDataIndex", rs.getString("INSERTED_BY"));
	            
	            
	            JsonObject.put("insertedTimeDataIndex",sdf.format(rs.getTimestamp("INSERTED_DATETIME"))); 	       
	            
	            JsonObject.put("tripTypeDataIndex", rs.getString("TRIP_TYPE"));
	            
	            JsonObject.put("daysDataIndex", rs.getInt("DAYS"));
	            
	            JsonObject.put("autoDataIndex", rs.getInt("AUTO_CANCEL_DAYS"));
	            
	            JsonObject.put("statusDataIndex", rs.getString("STATUS"));
	            
	            JsonObject.put("superEmailIdDataIndex", rs.getString("SUPERVISOR_EMAIL_ID"));
	            
	            JsonObject.put("superMobileNoIndex", rs.getString("SUPERVISOR_MOBILE_NO"));
	            
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
	
	
	public int getUniqueId()
	{
		  Connection con = null;
		  PreparedStatement pstmt = null;
		  ResultSet rs = null;
		  int uniqueId=0;
		  try{
			  con = DBConnection.getConnectionToDB("AMS");
		        pstmt = con.prepareStatement(CashVanManagementStatements.GET_UNIQUE_ID);
		        rs=pstmt.executeQuery();
		        while(rs.next()){
		        	uniqueId=rs.getInt("UNIQUE_ID");
		        }
		  }catch(Exception e)
		  {
			  e.printStackTrace();
		  }
		  finally {
		        DBConnection.releaseConnectionToDB(con, pstmt, rs);
		    }
		return uniqueId;
		
	}
	
	
	public String closeTrip(int systemId,int clientId, int userID,int uniqueId,String remark){
		Connection con=null;
		PreparedStatement pstmt=null;
		PreparedStatement pstmt1=null;
		String message="";
		 try {
		con = DBConnection.getConnectionToDB("AMS");
		
		pstmt = con.prepareStatement(CashVanManagementStatements.UPDATE_REMARK_FOR_TRIP_CLOASE);
		pstmt.setString(1, remark);
		pstmt.setInt(2, uniqueId);
		pstmt.setInt(3, clientId);
		pstmt.setInt(4, systemId);
		int updated=pstmt.executeUpdate();
		if (updated > 0) {
			//public static final String UPDATE_TRIP_SOLUTION=" update AMS.dbo.TRIP_SOLUTION set STATUS='CANCELED' where STATUS='OPEN' and ASSOCIATION_ID in (select ID from AMS.dbo.ROUTE_ASSET_ASSOCIATION  where ASSOCIATED_ID=? and CUSTOMER_ID=? and SYSTEM_ID=?) and SYSTEM_ID=? and CUSTOMER_ID=? ";
			pstmt1 = con.prepareStatement(CashVanManagementStatements.UPDATE_TRIP_SOLUTION);
	    	pstmt1.setInt(1, uniqueId);
	    	pstmt1.setInt(2, systemId);
	    	pstmt1.setInt(3, clientId);
	    	pstmt1.setInt(4, systemId);
	    	pstmt1.setInt(5, clientId);
	    	pstmt1.executeUpdate();
	        message = "Trip Closed";
	    }
		 }catch (Exception e) {
				
				e.printStackTrace();
		 } finally {
			 DBConnection.releaseConnectionToDB(con, pstmt, null);
			 DBConnection.releaseConnectionToDB(null, pstmt1, null);
		 }
		return message;
	}
	
	public JSONArray getVehiclesForModify(int systemId, int clientId,
			int userId,int uniqueId) {
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject = new JSONObject();
		Connection con=null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;

		try {
			con = DBConnection.getConnectionToDB("AMS");
			jsonArray = new JSONArray();
			jsonObject = new JSONObject();
		
			pstmt = con.prepareStatement(CashVanManagementStatements.GET_VEHICLES_FOR_MODIFY);
			pstmt.setInt(1, uniqueId);
			pstmt.setInt(2, clientId);
			pstmt.setInt(3, systemId);
			rs = pstmt.executeQuery();
			
			while (rs.next()) {
				jsonObject = new JSONObject();
				jsonObject.put("unique", rs.getInt("ASSOCIATED_ID"));
				jsonObject.put("vehicleNo", rs.getString("ASSET_NO"));
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
	
	public JSONArray getGroupForModify(int systemId, int clientId,
			int userId,int uniqueId) {
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject = new JSONObject();
		Connection con=null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;

		try {
			con = DBConnection.getConnectionToDB("AMS");
			jsonArray = new JSONArray();
			jsonObject = new JSONObject();
		
			pstmt = con.prepareStatement(CashVanManagementStatements.GET_GROUP_FOR_MODIFY);
			pstmt.setInt(1, uniqueId);
			pstmt.setInt(2, clientId);
			pstmt.setInt(3, systemId);
			rs = pstmt.executeQuery();
			
			while (rs.next()) {
				jsonObject = new JSONObject();
				jsonObject.put("unique", rs.getInt("ASSOCIATED_ID"));
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
	
	public String saveRouteDetails(String routeName,String[] routeArray,int systemId,int customerId,String routeDescription,Float actualDistance,Float expectedDistance,float actualDuration,float expectedDuration,int sourceId,int destinationId,int trigger1,int trigger2,String[] triggerArray,int radius,String[] haltArray
			                       ) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs=null;
		String message = "";
		String type="";
		int hubId=0;
		int routeId=0;
		int segmentId=0;
		int distance=0;
		float startlat=0;
		float startlong=0;
		float endlat=0;
		float endlong=0;
		int count=0;
		int triggerId=0;
		int i=1;
		try
		{
			con = DBConnection.getConnectionToDB("AMS");
			while(count<1)
			{
			count++;
			pstmt = con.prepareStatement(CashVanManagementStatements.GET_MAX_ROUTE_ID);
			rs=pstmt.executeQuery();	
			if(rs.next())
			{
				routeId=rs.getInt(1)+1;
			}
			pstmt=null;
			rs=null;
			if(routeId>0)
			{
				pstmt = con.prepareStatement(CashVanManagementStatements.SAVE_ROUTE_ID);
				pstmt.setInt(1,routeId);
				pstmt.setString(2,routeName);
				pstmt.setInt(3,systemId);
				pstmt.setInt(4,customerId);
				pstmt.setString(5,routeDescription);
				pstmt.setFloat(6,actualDistance);
				pstmt.setFloat(7,expectedDistance);
				pstmt.setFloat(8,actualDuration);
				pstmt.setFloat(9,expectedDuration);
				pstmt.setString(10,"Active");
				pstmt.setInt(11,radius);
				int insertResult=pstmt.executeUpdate();	
				pstmt=null;
				rs=null;
				pstmt = con.prepareStatement(CashVanManagementStatements.GET_MAX_SEGMENT_ID);
				rs=pstmt.executeQuery();	
				if(rs.next())
				{
					segmentId=rs.getInt(1)+1;
				}
				pstmt=null;
				rs=null;
				if(insertResult>0 && segmentId>0)
				{
					
					for(String routes:routeArray)
						{
							routes=routes.substring(1,routes.length()-1);
							String[] routesdetails = routes.split(",");	
							if(Integer.parseInt(routesdetails[0])==1||Integer.parseInt(routesdetails[0])==routeArray.length)
							{
								segmentId++;
								if(Integer.parseInt(routesdetails[0])==1)
								{
									startlat=Float.valueOf(routesdetails[1]);
									startlong=Float.valueOf(routesdetails[2]);
									type="SOURCE";
									hubId=sourceId;
								}
								else if(Integer.parseInt(routesdetails[0])==routeArray.length)
								{
									endlat=Float.valueOf(routesdetails[1]);
									endlong=Float.valueOf(routesdetails[2]);
									distance=(int)calculatedistance(startlat, startlong, endlat, endlong);
									type="DESTINATION";
									hubId=destinationId;
								}
								pstmt = con.prepareStatement(CashVanManagementStatements.SAVE_ROUTE_PICK_UP_POINT);
								pstmt.setInt(1,routeId);
								pstmt.setInt(2,segmentId);
								pstmt.setInt(3,1);
								pstmt.setInt(4,distance/1000);
								pstmt.executeUpdate();	
								pstmt=null;
								rs=null;
								pstmt = con.prepareStatement(CashVanManagementStatements.SAVE_ROUTE_DETAIL);
								pstmt.setInt(1,routeId);
								pstmt.setInt(2,segmentId);
								pstmt.setInt(3,1);
								pstmt.setString(4,routesdetails[1]);
								pstmt.setString(5,routesdetails[2]);
								pstmt.setString(6,type);
								pstmt.setInt(7,hubId);
								pstmt.executeUpdate();	
								pstmt=null;
								rs=null;
							}
							else
							{	
							pstmt = con.prepareStatement(CashVanManagementStatements.SAVE_ROUTE_DETAIL);
							pstmt.setInt(1,routeId);
							pstmt.setInt(2,segmentId);
							pstmt.setString(3,routesdetails[0]);
							pstmt.setString(4,routesdetails[1]);
							pstmt.setString(5,routesdetails[2]);
							pstmt.setString(6,"");
							pstmt.setInt(7,0);
							pstmt.executeUpdate();	
							pstmt=null;
							rs=null;
							}
						}
					for(String triggerPoints:triggerArray)
					{
						triggerPoints=triggerPoints.substring(1,triggerPoints.length()-1);
						String[] triggerDetails = triggerPoints.split(",");	
						if(Integer.parseInt(triggerDetails[0])==1)
						{
							type="TRIGGER POINT 1";
							triggerId=trigger1;
						}
						else if(Integer.parseInt(triggerDetails[0])==triggerArray.length)
						{
							type="TRIGGER POINT 2";
							triggerId=trigger2;
						}
						pstmt = con.prepareStatement(CashVanManagementStatements.SAVE_ROUTE_DETAIL);
						pstmt.setInt(1,routeId);
						pstmt.setInt(2,segmentId);
						pstmt.setInt(3,0);
						pstmt.setString(4,triggerDetails[1]);
						pstmt.setString(5,triggerDetails[2]);
						pstmt.setString(6,type);
						pstmt.setInt(7,triggerId);
						pstmt.executeUpdate();	
						pstmt=null;
						rs=null;
					}
					if(haltArray!=null){
					for(String haltPoints:haltArray)
					{
						
						haltPoints=haltPoints.substring(1,haltPoints.length()-1);
						String[] haltDetails = haltPoints.split(",");	
						type="HALT "+i;
						pstmt = con.prepareStatement(CashVanManagementStatements.SAVE_ROUTE_DETAIL);
						pstmt.setInt(1,routeId);
						pstmt.setInt(2,segmentId);
						pstmt.setInt(3,0);
						pstmt.setString(4,haltDetails[1]);
						pstmt.setString(5,haltDetails[2]);
						pstmt.setString(6,type);
						pstmt.setInt(7,Integer.parseInt(haltDetails[3]));
						pstmt.executeUpdate();	
						pstmt=null;
						rs=null;
						i++;
					}
				}
				}
			}
		}
					message="Route Created";
		}
		catch(Exception e)
		{
			e.printStackTrace();
		}
		finally{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}	
		return message;
	}

	public static float calculatedistance(float lat1, float lng1, float lat2, float lng2) {
	    double earthRadius = 3958.75;
	    double dLat = Math.toRadians(lat2-lat1);
	    double dLng = Math.toRadians(lng2-lng1);
	    double a = Math.sin(dLat/2) * Math.sin(dLat/2) +
	               Math.cos(Math.toRadians(lat1)) * Math.cos(Math.toRadians(lat2)) *
	               Math.sin(dLng/2) * Math.sin(dLng/2);
	    double c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a));
	    double dist = earthRadius * c;

	    int meterConversion = 1609;

	    return (float) (dist * meterConversion);
	    }
	
    public JSONArray getSourceDestination(int clientId,int systemId,String zone) {
    	Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs=null;
		JSONArray jsonArray = new JSONArray();
	    JSONObject jsonObject = null;
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(cf.getLocationQuery(CashVanManagementStatements.GET_SOURCE_DESTINATION, zone));
			pstmt.setInt(1,clientId);
			pstmt.setInt(2, systemId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				jsonObject = new JSONObject();
				jsonObject.put("Hub_Id",rs.getInt("HUBID"));
				jsonObject.put("Hub_Name",rs.getString("NAME"));
				jsonObject.put("latitude",rs.getString("LATITUDE"));
				jsonObject.put("longitude",rs.getString("LONGITUDE"));
				jsonObject.put("radius",rs.getString("RADIUS"));
				jsonArray.put(jsonObject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
	  return jsonArray;
	}
	public JSONArray getRouteDetails(int customerId, int systemId,String zone) {
	    Connection con = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
	    JSONArray jsonArray = new JSONArray();
	    JSONObject jsonObject = new JSONObject();
	    try {
	        con = DBConnection.getConnectionToDB("AMS");
	        pstmt = con.prepareStatement(cf.getLocationQuery(CashVanManagementStatements.GET_ROUTE_DETAILS_FOR_GRID, zone));
	        pstmt.setInt(1, customerId);
	        pstmt.setInt(2, systemId );
	        rs = pstmt.executeQuery();
	        while (rs.next()) {
	            jsonObject = new JSONObject();
	            jsonObject.put("routeIdDataIndex", rs.getString("RouteID"));
	            jsonObject.put("routeNameDataIndex", rs.getString("ROUTE_NAME"));
	            jsonObject.put("actualDistanceDataIndex", rs.getString("ACTUAL_DISTANCE"));
	            jsonObject.put("tempDistanceDataIndex", rs.getString("EXPECTED_DISTANCE"));
	            jsonObject.put("actualTimeDataIndex", rs.getString("ACTUAL_DURATION"));
	            jsonObject.put("tempTimeDataIndex", rs.getString("EXPECTED_DURATION"));
	            jsonObject.put("statusDataIndex", rs.getString("STATUS"));
	            jsonObject.put("routeFromDataIndex", rs.getString("SOURCE_NAME"));
	            jsonObject.put("routeToDataIndex", rs.getString("DESTINATION_NAME"));
	            jsonObject.put("trigger2DataIndex", rs.getString("TRIGGER_POINT_2"));
	            jsonObject.put("trigger1DataIndex", rs.getString("TRIGGER_POINT_1"));
	            jsonObject.put("despDataIndex", rs.getString("ROUTE_DESCRIPTION"));
	            jsonObject.put("radiusDataIndex", rs.getString("ROUTE_RADIUS"));
	            jsonObject.put("SourceRadiusDataIndex", rs.getString("SOURCE_RADIUS"));
	            jsonObject.put("destRadiusDataIndex", rs.getString("DESTINATION_RADIUS"));
	            
	            jsonArray.put(jsonObject);
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	        DBConnection.releaseConnectionToDB(con, pstmt, rs);
	    }
	    return jsonArray;
	}
	
	public JSONArray getLatLongs(int routeId,int cutomerId, int systemId,String zone) {

		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject = new JSONObject();
		Connection con=null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		try{
			con = DBConnection.getConnectionToDB("AMS");
			jsonArray = new JSONArray();
			jsonObject = new JSONObject();
			pstmt = con.prepareStatement(cf.getLocationQuery(CashVanManagementStatements.GET_LAT_LNGS, zone));
			pstmt.setInt(1,routeId);
			pstmt.setInt(2,cutomerId);
			pstmt.setInt(3,systemId);
			rs=pstmt.executeQuery();
			while(rs.next()){
				jsonObject = new JSONObject();
				jsonObject.put("sequence", rs.getString("Route_sequence"));
				jsonObject.put("lat", rs.getString("Latitude"));
				jsonObject.put("long", rs.getString("Longitude"));
				jsonObject.put("type", rs.getString("TYPE"));
				jsonArray.put(jsonObject);				
			}
		}catch(Exception e){
			e.printStackTrace();
		}	
		finally{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}	
		return jsonArray;
	
	}
	public JSONArray getTriggerPointLatLongs(int routeId,int cutomerId, int systemId,String zone) {

		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject = new JSONObject();
		Connection con=null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		try{
			con = DBConnection.getConnectionToDB("AMS");
			jsonArray = new JSONArray();
			jsonObject = new JSONObject();
			pstmt = con.prepareStatement(cf.getLocationQuery(CashVanManagementStatements.GET_TRIGGER_POINT_LATLONGS,zone));
			pstmt.setInt(1,routeId);
			pstmt.setInt(2,cutomerId);
			pstmt.setInt(3,systemId);
			rs=pstmt.executeQuery();
			while(rs.next()){
				jsonObject = new JSONObject();
				jsonObject.put("Tlat", rs.getString("Latitude"));
				jsonObject.put("Tlong", rs.getString("Longitude"));
				jsonObject.put("TRADIUS", rs.getString("RADIUS"));
				jsonArray.put(jsonObject);				
			}
		}catch(Exception e){
			e.printStackTrace();
		}	
		finally{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}	
		return jsonArray;
	
	}
	
	public JSONArray getHaltLatLongs(int routeId,int cutomerId, int systemId,String zone) {

		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject = new JSONObject();
		Connection con=null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		try{
			con = DBConnection.getConnectionToDB("AMS");
			jsonArray = new JSONArray();
			jsonObject = new JSONObject();
			pstmt = con.prepareStatement(cf.getLocationQuery(CashVanManagementStatements.GET_HALT_LATLONGS,zone));
			pstmt.setInt(1,routeId);
			pstmt.setInt(2,cutomerId);
			pstmt.setInt(3,systemId);
			rs=pstmt.executeQuery();
			while(rs.next()){
				jsonObject = new JSONObject();
				jsonObject.put("Hlat", rs.getString("Latitude"));
				jsonObject.put("Hlong", rs.getString("Longitude"));
				jsonObject.put("HRADIUS", rs.getString("RADIUS"));
				jsonArray.put(jsonObject);				
			}
		}catch(Exception e){
			e.printStackTrace();
		}	
		finally{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}	
		return jsonArray;
	
	}
	
	public String UpdateRoute(int routeId) {
	    Connection con = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
	    String message = "";
	    int update;
	    try {
	            con = DBConnection.getConnectionToDB("AMS");
		        pstmt = con.prepareStatement(CashVanManagementStatements.UPDATE_ROUTE_IN_ROUTE_MASTER);
		        pstmt.setInt(1, routeId);
		        update = pstmt.executeUpdate();
		        if (update > 0) {
		            message = "Inactive Successfully";
		        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	        DBConnection.releaseConnectionToDB(con, pstmt, rs);
	    }
	    return message;
	}
	
	public ArrayList < Object > getTripSummaryReportNew(int customerId, int systemId,int offset,String startdate,String enddate,String language) {
	    Connection con = null;
	    PreparedStatement pstmt = null ;
	    ResultSet rs = null;
	    JSONArray jsonArray = new JSONArray();
	    JSONObject jsonObject = null;
	    ArrayList < Object > finlist = new ArrayList < Object > ();
	    ArrayList<ReportHelper> reportsList = new ArrayList<ReportHelper>();
		ArrayList<String> headersList = new ArrayList<String>();
		ReportHelper finalreporthelper = new ReportHelper();
	    try {
	    	headersList.add(cf.getLabelFromDB("SLNO",language));
	    	headersList.add(cf.getLabelFromDB("Trip_Id",language));
	    	headersList.add(cf.getLabelFromDB("Trip_Name",language));
	    	headersList.add(cf.getLabelFromDB("Assignment",language));
	    	headersList.add("Return Trip/Single Trip");
	    	headersList.add(cf.getLabelFromDB("Vehicle_No",language));
	    	headersList.add(cf.getLabelFromDB("Driver_Name",language));
	    	headersList.add(cf.getLabelFromDB("Trip_Start_Date_Time",language));
	    	headersList.add(cf.getLabelFromDB("Start_Location",language));
	    	headersList.add(cf.getLabelFromDB("Trip_End_Date_Time",language));
	    	headersList.add(cf.getLabelFromDB("End_Location",language));
	    	headersList.add(cf.getLabelFromDB("Trip_Status",language));
	    	headersList.add(cf.getLabelFromDB("Total_Trip_Duration",language));
	    	headersList.add(cf.getLabelFromDB("Total_Authorize_Halt_Time",language));
	    	headersList.add(cf.getLabelFromDB("Total_Unauthorize_Halt_Time",language));
	    	headersList.add(cf.getLabelFromDB("Distance_Travelled",language));
	    	headersList.add(cf.getLabelFromDB("Driving_Time",language));
	    	headersList.add("Avg. Distance/Hr");
	    	headersList.add("Avg. Driving/Hr");
	    	headersList.add("Vehicle Type");
	    	headersList.add(cf.getLabelFromDB("Top_Speed",language));
	    	//if(systemId==15){
	    	double conversionfactor=cf.getUnitOfMeasureConvertionsfactor(systemId);
	    	//}
	        int count = 0;
	        con = DBConnection.getConnectionToDB("AMS");
	        pstmt = con.prepareStatement(CashVanManagementStatements.GET_TRIP_SUMMARY);
	        pstmt.setInt(1, offset);
	        pstmt.setInt(2, offset);
	        pstmt.setInt(3, systemId);
	        pstmt.setInt(4, customerId);
	        pstmt.setInt(5, offset);
	        pstmt.setString(6, startdate);
	        pstmt.setInt(7, offset);
	        pstmt.setString(8, enddate);
	        rs = pstmt.executeQuery();
	        while (rs.next()) {
	        	ArrayList<Object> informationList = new ArrayList<Object>();
	        	ReportHelper reporthelper = new ReportHelper();
	            count++;
	            jsonObject = new JSONObject();
	            
	            informationList.add(count);
	            jsonObject.put("slnoIndex", count);
	            
	            informationList.add(rs.getString("TripId"));
	            jsonObject.put("tripIdIndex", rs.getString("TripId"));
	            
	            informationList.add(rs.getString("TripName"));
	            jsonObject.put("tripNameIndex", rs.getString("TripName"));
	            
	            informationList.add(rs.getString("Assignement"));
	            jsonObject.put("AssignementIndex", rs.getString("Assignement"));
	            
	            if (rs.getInt("RETURN_ROUTE_ID")>0 ) {
	            	informationList.add("Return Trip");
		            jsonObject.put("SingleOrReturnTripIndex", "Return Trip");
				}else{
					informationList.add("Single Trip");
		            jsonObject.put("SingleOrReturnTripIndex", "Single Trip");
				}

	            informationList.add(rs.getString("VehicalNo"));
	            jsonObject.put("vehicalNoIndex", rs.getString("VehicalNo"));
	            
	            informationList.add(rs.getString("DriverName"));
	            jsonObject.put("driverNameIndex", rs.getString("DriverName"));

	            informationList.add(ddmmyyyy.format(yyyymmdd.parse(rs.getString("StartDateTime"))));
	            jsonObject.put("startDateDataIndex", rs.getString("StartDateTime"));
	            
	            informationList.add(rs.getString("START_LOCATION"));
	            jsonObject.put("startLocationIndex", rs.getString("START_LOCATION"));
	            
	            if(rs.getString("EndDateTime")==""|| rs.getString("EndDateTime").contains("1900"))
				{
	            	   informationList.add("");
	            	   jsonObject.put("endDateDataIndex", "");
				}
				else
				{	
					informationList.add(ddmmyyyy.format(yyyymmdd.parse(rs.getString("EndDateTime"))));
		            jsonObject.put("endDateDataIndex", rs.getString("EndDateTime"));
				}
	            
	            
	            informationList.add(rs.getString("END_LOCATION"));
	            jsonObject.put("endLocationIndex", rs.getString("END_LOCATION"));
	            
	            informationList.add(rs.getString("TripStatus"));
	            jsonObject.put("tripStatusIndex", rs.getString("TripStatus"));
	            
	            informationList.add(cf.convertMinutesToHHMMFormat1(rs.getInt("TotalTimeToCompleteTripMins")));
	            jsonObject.put("timeTakenToCompleteTripIndex", cf.convertMinutesToHHMMFormat1(rs.getInt("TotalTimeToCompleteTripMins")));
	            
	            informationList.add(0);
	            jsonObject.put("totalAuthorizeHaltTimeIndex",0);
	            
	            informationList.add(0);
	            jsonObject.put("totalUnauthorizeHaltTimeIndex", 0);
	            
	            informationList.add(rs.getDouble("TotaldistanceTravelled")*conversionfactor);
	            jsonObject.put("totalDistanceTraveledIndex", rs.getDouble("TotaldistanceTravelled")*conversionfactor);
	            
	            informationList.add(df.format(rs.getDouble("DrivingTime")));
	            jsonObject.put("drivingTimeIndex", df.format(rs.getDouble("DrivingTime")));
	            
	            informationList.add(0);
	            jsonObject.put("avgDistancePerHrIndex", 0);
	            
	            informationList.add(0);
	            jsonObject.put("avgDrivingPerHrIndex", 0);

	            informationList.add(rs.getString("VehicleType"));
	            jsonObject.put("vehicleTypeIndex", rs.getString("VehicleType"));
	            
	            informationList.add(rs.getInt("TopSpeed")*conversionfactor);
	            jsonObject.put("topSpeedIndex", rs.getInt("TopSpeed")*conversionfactor);
	            
	            jsonArray.put(jsonObject);
	            reporthelper.setInformationList(informationList);
				reportsList.add(reporthelper);
	            
	        }
	        finalreporthelper.setReportsList(reportsList);
			finalreporthelper.setHeadersList(headersList);
		    finlist.add(jsonArray);
			finlist.add(finalreporthelper);
	     
	    } catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	        DBConnection.releaseConnectionToDB(con, pstmt, rs);
	    }
	    return finlist;
	}
	public JSONArray getAlerts(int systemid)
    {
		JSONArray jsonArray =new JSONArray();
		JSONObject jsonObject =new JSONObject();
		Connection con=null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		try
		{
		
		con = DBConnection.getConnectionToDB("AMS");
		jsonArray =new JSONArray();
		jsonObject =new JSONObject();
		pstmt = con.prepareStatement(CashVanManagementStatements.GET_ALERTS_FOR_CLIENT);
		pstmt.setInt(1,systemid);
		rs = pstmt.executeQuery();
		while (rs.next())
		{
		jsonObject =new JSONObject();
		jsonObject.put("alertId", rs.getString("AlertId"));
		jsonObject.put("alertName", rs.getString("AlertName"));
		jsonArray.put(jsonObject);
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
 public JSONArray getAlertsForModify(int systemId, int clientId,
		 int userId,int uniqueId) {
		 JSONArray jsonArray = new JSONArray();
		 JSONObject jsonObject = new JSONObject();
		 Connection con=null;
		 PreparedStatement pstmtop=null;
		 ResultSet rs1=null;
		 PreparedStatement pstmt=null;
		 ResultSet rs=null;
		        String ids=null;
		        String[] id={};
		 try {
		 con = DBConnection.getConnectionToDB("AMS");
		 jsonArray = new JSONArray();
		 jsonObject = new JSONObject();

		 pstmtop = con.prepareStatement(CashVanManagementStatements.GET_ALERTS_FOR_MODIFY);
		 pstmtop.setInt(1, uniqueId);
		 pstmtop.setInt(2, clientId);
		 pstmtop.setInt(3, systemId);
		 rs = pstmtop.executeQuery();
		 if(rs.next()){
		 ids=rs.getString("ASSOCIATED_ALERTS");
		 }
		 pstmt = con.prepareStatement("select AlertId,AlertName from dbo.Alert_Master_Details where SystemId=12 and AlertId in ( " +ids + " ) order by AlertId ");
		 rs1 = pstmt.executeQuery();
		 while (rs1.next()) {
		 jsonObject = new JSONObject();
		 jsonObject.put("unique", rs.getInt("ASSOCIATED_ID"));
		 jsonObject.put("alertName", rs1.getString("AlertName"));
		 jsonArray.put(jsonObject);	

		 }

		 } // end of try

		 catch (Exception e) {

		 e.printStackTrace();
		 } finally {
			 DBConnection.releaseConnectionToDB(null, pstmtop, rs);
		 DBConnection.releaseConnectionToDB(con, pstmt, rs1);
		 }

		 return jsonArray;

		 }
public JSONArray getLocationByCountryCode(int countryCode) {
	
	 Connection con=null;
	 PreparedStatement pstmtop=null;
	
	 PreparedStatement pstmt=null;
	 ResultSet rs=null;
	 JSONArray jsonArray = new JSONArray();
	 JSONObject jsonObject = new JSONObject();
	 try {
		 con = DBConnection.getConnectionToDB("ADMINISTRATOR");
		 pstmtop = con.prepareStatement(CashVanManagementStatements.GET_lOCATION);
		 pstmtop.setInt(1, countryCode);
		 
		 rs = pstmtop.executeQuery();
		 while (rs.next()) {
		 jsonObject = new JSONObject();
		 jsonObject.put("value", rs.getString("STATE_CODE"));
		 jsonObject.put("name", rs.getString("STATE_NAME"));
		 jsonArray.put(jsonObject);	

		 }
	 }catch(Exception e){
		 e.printStackTrace();
		 
	 } finally {
	 DBConnection.releaseConnectionToDB(con, pstmt, rs);
	 }

	 return jsonArray;
	
	// TODO Auto-generated method stub
	
}

	
	
 public String addCustomerDetails(String cumpanyName,String companyType,String region,String address,String contactPesrson,String phoneNo,String mobile,String email,String status,int systemId,int custId,String userName,String Phone2,String Mobile2,String contactPesrson2){
	    Connection con = null;
		PreparedStatement pstmt= null;
		ResultSet rs = null;
		String message="";
		
		try
		{
			 con = DBConnection.getConnectionToDB("AMS");
			 pstmt = con.prepareStatement(CashVanManagementStatements.CHECK_CUSTOMER_ALREADY_EXIST);
			 pstmt.setString(1, cumpanyName);			
			 pstmt.setInt(2, custId);
			 pstmt.setInt(3, systemId);
			 rs = pstmt.executeQuery();
			 if(rs.next())
			 {
				 message="Customer Already Exist";
				 return message;
			 }
			 else {
			 pstmt = con.prepareStatement(CashVanManagementStatements.ADD_NEW_CUSTOMER);
			 pstmt.setString(1,cumpanyName);
			 pstmt.setString(2,companyType);
			 pstmt.setString(3, region);
			 pstmt.setString(4, address);
			 pstmt.setString(5, contactPesrson);
			 pstmt.setString(6, phoneNo);
			 pstmt.setString(7, mobile);
			 pstmt.setString(8, email);	
			 pstmt.setString(9, userName);	
			 pstmt.setInt(10, systemId);
			 pstmt.setInt(11, custId);
			 pstmt.setString(12, status);
			 pstmt.setString(13,Phone2);
			 pstmt.setString(14,Mobile2);
			 pstmt.setString(15, contactPesrson2);
			 int inserted = pstmt.executeUpdate();
			if (inserted > 0) {
               message = "Saved Successfully";
          }
		}
		}
		 catch (Exception e)
		 {
				System.out.println("error in:-save CustomerMaster details "+e.toString());
				e.printStackTrace();
		 }      
		finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
	    }
		return message;
				
	 
 }
 
 public String modifyCustomerDetails(String cumpanyName,String companyType,String region,String address,String contactPesrson,String phoneNo,String mobile,String email,String status,int systemId,int custId,String userName,String phoneNo2,String mobile2,String contactPerson2){
	
	 Connection con = null;
		PreparedStatement pstmt= null;
		ResultSet rs = null;
		String message="";
		
		try
		{
			 con = DBConnection.getConnectionToDB("AMS");
			
			 pstmt = con.prepareStatement(CashVanManagementStatements.UPDATE_CUSTOMER);
			
			 pstmt.setString(1,companyType);
			 pstmt.setString(2, region);
			 pstmt.setString(3, address);
			 pstmt.setString(4, contactPesrson);
			 pstmt.setString(5, phoneNo);
			 pstmt.setString(6, mobile);
			 pstmt.setString(7, email);
			 
			 pstmt.setString(8, userName);	
			 pstmt.setString(9, status);
			 pstmt.setString(10, phoneNo2);
			 pstmt.setString(11,mobile2);
			 pstmt.setString(12,contactPerson2);
			 pstmt.setString(13,cumpanyName);

			
			 pstmt.setInt(14, custId);
			 pstmt.setInt(15, systemId);
			
			 int inserted = pstmt.executeUpdate();
			if (inserted > 0) {
            message = "Saved Successfully";
       }
		}
		 catch (Exception e)
		 {
				System.out.println("error in:-save CustomerMaster details "+e.toString());
				e.printStackTrace();
		 }      
		finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
	    }
		return message;
	
 }

	public ArrayList < Object > getCustomerMasterDetails(int systemId, int customerId,int offset) {
	    JSONArray JsonArray = new JSONArray();
	    JSONObject JsonObject = null;
	    Connection con = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
	    ArrayList < Object > finlist = new ArrayList < Object > ();
	    try {
	        int count = 0;
	        con = DBConnection.getConnectionToDB("AMS");
	        pstmt = con.prepareStatement(CashVanManagementStatements.GET_CUSTOMER_DETAILS);
	        pstmt.setInt(1, offset);
	        pstmt.setInt(2, offset);
	        pstmt.setInt(3, customerId);
	        pstmt.setInt(4, systemId);
	       
	        rs = pstmt.executeQuery();
	        while (rs.next()) {
	            JsonObject = new JSONObject();
	            count++;
	           
	            JsonObject.put("slnoIndex", count);
	            
	            JsonObject.put("CustomerId", rs.getString("CustomerId"));
	            JsonObject.put("CompanyNameDataIndex",rs.getString("CustomerName"));
	            JsonObject.put("CompanyTypeDataIndex",rs.getString("CustomerType"));
	            JsonObject.put("RegionDataIndex",rs.getString("State"));
	            JsonObject.put("AddressDataIndex",rs.getString("Address"));
	            JsonObject.put("ContactPersonDataIndex",rs.getString("ContactPerson"));
	            JsonObject.put("PhoneNoDataIndex",rs.getString("PhoneNo"));
	            JsonObject.put("EmailDataIndex",rs.getString("EmailId").toLowerCase());
	            JsonObject.put("MobileDataIndex",rs.getString("Mobile").toUpperCase());
	            JsonObject.put("CreatedByDataIndex",rs.getString("CreatedBy"));
	            JsonObject.put("CreatedTimeDataIndex",ddmmyyyy.format(yyyymmdd.parse(rs.getString("InsertedDate"))));	            
	            JsonObject.put("UpdatedByDataIndex",rs.getString("UpdatedBy"));
	            JsonObject.put("PhoneNo2DataIndex",rs.getString("PhoneNo2"));
	            JsonObject.put("Mobile2DataIndex",rs.getString("Mobile2"));
	            JsonObject.put("ContactPerson2DataIndex",rs.getString("ContactPerson2"));
				if(rs.getString("UpdatedDateTime")=="" || rs.getString("UpdatedDateTime")==null || rs.getString("UpdatedDateTime").contains("1900") ){
          	    JsonObject.put("UpdatedTimeDataIndex", "");
			    }else{
	            JsonObject.put("UpdatedTimeDataIndex",ddmmyyyy.format(yyyymmdd.parse(rs.getString("UpdatedDateTime"))));	
	            }  
	            JsonObject.put("statusIndex", rs.getString("STATUS"));
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
	/**
	 * 
	 * @param systemId
	 * @param customerId
	 * @param location
	 * @return
	 * get Coustomer by location ,systemid and clientid
	 */
	public JSONArray  getCustomersByLocation(int systemId, int customerId,String location) {
	    JSONArray JsonArray = new JSONArray();
	    JSONObject JsonObject = null;
	    Connection con = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
	    ArrayList < Object > finlist = new ArrayList < Object > ();
	    try {
	        int count = 0;
	        con = DBConnection.getConnectionToDB("AMS");
	        pstmt = con.prepareStatement(CashVanManagementStatements.GET_CUSTOMER_BY_LOCATION);	       
	        pstmt.setString(1, location);
	        pstmt.setInt(2, customerId);
	        pstmt.setInt(3, systemId);
	        rs = pstmt.executeQuery();
	        while (rs.next()) {
	            JsonObject = new JSONObject();
	           
	           
	            JsonObject.put("name",rs.getString("CustomerName").toUpperCase());
	            JsonObject.put("value",rs.getString("CustomerId"));
	            JsonArray.put(JsonObject);
	        }
	       
	    } catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	        DBConnection.releaseConnectionToDB(con, pstmt, rs);
	    }
	    return JsonArray;
	}

	public String saveQuote(String quotationNo, String validFrom,String validTo, String location, String quoteFor, String customer,	String tariffType, String uploadedFile, String tariffAmt, int userId, int systemId, int customerId,int quotationCustId) {
		String message = "";   
		Connection con = null;
		int sysGeneratedQId =0;
		    PreparedStatement pstmt = null;
		    ResultSet rs = null;
		con = DBConnection.getConnectionToDB("AMS");
	        try {
				pstmt = con.prepareStatement(CashVanManagementStatements.SAVE_QUOTE,Statement.RETURN_GENERATED_KEYS);
				pstmt.setString(1, quotationNo);
				pstmt.setString(2, validFrom);
				pstmt.setString(3, validTo);
				pstmt.setString(4, location);
				pstmt.setString(5, quoteFor);
				pstmt.setString(6, customer);
				pstmt.setString(7, tariffType);
				pstmt.setString(8, tariffAmt);
				pstmt.setString(9, uploadedFile);
				pstmt.setString(10, "NEW");
				pstmt.setInt(11, userId);
				pstmt.setInt(12, systemId);
				pstmt.setInt(13, customerId);
				pstmt.setInt(14, quotationCustId);
				
				int rows = pstmt.executeUpdate();
				
				rs = pstmt.getGeneratedKeys();
	            if (rs.next()) {
	            	sysGeneratedQId = rs.getInt(1);          
	            }
				
				if(rows>0){
					message =  "Success"+"-"+sysGeneratedQId;
				}else{
					message =  "Failed";
				}
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}finally {
		        DBConnection.releaseConnectionToDB(con, pstmt, rs);
		    }
		
		return message;
	}
	public JSONArray getQuotes(int customerId,int systemId) {
		 Connection con = null;
		   PreparedStatement pstmt = null;
		    ResultSet rs = null;
		    JSONObject  JsonObject=null;
		    JSONArray JsonArray = new JSONArray();
		 con = DBConnection.getConnectionToDB("AMS");
		 try {
			 
			 pstmt = con.prepareStatement(CashVanManagementStatements.GET_QUOTES);
		     pstmt.setInt(1, customerId);
		     pstmt.setInt(2, systemId);
			
			rs=pstmt.executeQuery();
			 
			int count=0;
			while(rs.next()){
				count++;
				JsonObject=new JSONObject();
				JsonObject.put("slnoIndex",count);
			     JsonObject.put("synsQuotationNoIndex",rs.getInt("QUOTATION_ID"));
			     JsonObject.put("quotationDataIndex",rs.getString("QUOTATION_NO"));
			     JsonObject.put("validFromDataIndex",rs.getDate("VALID_FROM"));
			     JsonObject.put("validToIndex",rs.getDate("VALID_TO"));
			     JsonObject.put("locationIndex",rs.getString("LOCATION"));
			     JsonObject.put("quotForIndex",rs.getString("QUOTE_FOR"));
			     JsonObject.put("typeIndex",rs.getString("CUSTOMER_NAME"));
			     JsonObject.put("tariffTypeIndex",rs.getString("TARIFF_TYPE"));
			     JsonObject.put("tariffAmountIndex",rs.getString("TARIFF_AMOUNT"));
			     JsonObject.put("typeIdIndex2",rs.getString("QUOTATION_CUST_ID"));
			     String filePath = rs.getString("UPLOADED_FILE_PATH");
			     JsonObject.put("RevisionCountDataIndex",rs.getString("REVISION_COUNT"));
		             
			    /* JsonObject.put("quoteStatus",rs.getString("QUOTATION_STATUS"));*/
			  // filePath = filePath.substring(30, filePath.length());
			     if(filePath.contains("//")){
			   filePath = filePath.substring(filePath.lastIndexOf("//"), filePath.length());		

			   filePath = filePath.substring(2);
			     }
			    Properties properties = ApplicationListener.prop;
				
				String excelpath = properties.getProperty("DocumentDownloadPathForQuotation").trim();
			    
				excelpath = excelpath+filePath;
				JsonObject.put("uploadedFileIndex",excelpath);
		   
			     JsonArray.put(JsonObject);
			}
			
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (JSONException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}finally {
	        DBConnection.releaseConnectionToDB(con, pstmt, rs);
	    }
		return JsonArray;
		
	}
 
	
	
	public JSONArray getRevisionQuotes(int customerId,int systemId,int sysQuoteId) {
		 Connection con = null;
		   PreparedStatement pstmt = null;
		    ResultSet rs = null;
		    JSONObject  JsonObject=null;
		    JSONArray JsonArray = new JSONArray();
		 con = DBConnection.getConnectionToDB("AMS");
		 try {
			 
			 pstmt = con.prepareStatement(CashVanManagementStatements.GET_REVISION_QUOTES);
		     pstmt.setInt(1, customerId);
		     pstmt.setInt(2, systemId);
		     pstmt.setInt(3, sysQuoteId);
		     pstmt.setInt(4, customerId);
		     pstmt.setInt(5, systemId);
		     pstmt.setInt(6, sysQuoteId);
			rs=pstmt.executeQuery();
			 
			int count=0;
			while(rs.next()){
				count++;
				JsonObject=new JSONObject();
				JsonObject.put("slnoIndex",count);
			    
			     JsonObject.put("validFromDataIndex2",rs.getDate("VALID_FROM"));
			     JsonObject.put("validToIndex2",rs.getDate("VALID_TO"));
			     JsonObject.put("QuotationStatusDataIndex2",rs.getString("QUOTATION_STATUS"));
			     JsonObject.put("StatusTypeDataIndex2",rs.getString("STATUS_TYPE"));
			     JsonObject.put("locationIndex2",rs.getString("LOCATION"));
			     JsonObject.put("quotForIndex2",rs.getString("QUOTE_FOR"));
			     JsonObject.put("typeIndex2",rs.getString("CUSTOMER_NAME"));
			     JsonObject.put("tariffTypeIndex2",rs.getString("TARIFF_TYPE"));
			     JsonObject.put("tariffAmountIndex2",rs.getString("TARIFF_AMOUNT"));
			     JsonObject.put("reasonDataIndex",rs.getString("REASON"));
			     String filePath = rs.getString("UPLOADED_FILE_PATH");
			    if(filePath!=null && !filePath.equals("")){
			   filePath = filePath.substring(30, filePath.length());
						
			    
			    Properties properties = ApplicationListener.prop;
				
				String excelpath = properties.getProperty("DocumentDownloadPathForQuotation").trim();
			    
				excelpath = excelpath+filePath;
				JsonObject.put("uploadedFileIndex",excelpath);
			    }
			     JsonArray.put(JsonObject);
			}
			
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (JSONException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}finally {
	        DBConnection.releaseConnectionToDB(con, pstmt, rs);
	    }
		return JsonArray;
		
	}
 
 

	
 
	public ArrayList < Object > getQuotationMasterHistoryDetails(int systemId, int customerId) {
	    JSONArray JsonArray = new JSONArray();
	    JSONObject JsonObject = null;
	    Connection con = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
	    CommonFunctions cf=new CommonFunctions();
		ArrayList < ReportHelper > reportsList = new ArrayList < ReportHelper > ();
		ArrayList < String > headersList = new ArrayList < String > ();
		ReportHelper finalreporthelper = new ReportHelper();    
		ArrayList < Object > finlist = new ArrayList < Object > ();
	    try {
	        int count = 0;
	        headersList.add("SLNO");
	        headersList.add("System Quotation No");
	        headersList.add("Quotation No");
	        headersList.add("Quotation Status");
	        headersList.add("Status Type");
	        headersList.add("Valid From");
	        headersList.add("Valid To");
	        headersList.add("Location");
	        headersList.add("Quotation For");
	        headersList.add("Quotation Type");
	        headersList.add("Tariff Type");
	        headersList.add("Tariff Amount");
	        headersList.add("Revision No");
	        headersList.add("Reason");
	        con = DBConnection.getConnectionToDB("AMS");
	        pstmt = con.prepareStatement(CashVanManagementStatements.GET_QUOTATION_MASTER_HISTORY_DETAILS);
	        pstmt.setInt(1, systemId);
	        pstmt.setInt(2, customerId);
	        rs = pstmt.executeQuery();
	        while (rs.next()) {
	            JsonObject = new JSONObject();
	            count++;
	            ArrayList<Object> informationList = new ArrayList<Object>();
				ReportHelper reporthelper = new ReportHelper();
				
	            JsonObject.put("slnoIndex", count);
	            informationList.add(count);
	            JsonObject.put("QuotationIdDataIndex",rs.getString("QUOTATION_ID").toUpperCase());
	            informationList.add(rs.getString("QUOTATION_ID").toUpperCase());
	            JsonObject.put("QuotationNoDataIndex",rs.getString("QUOTATION_NO").toUpperCase());
	            informationList.add(rs.getString("QUOTATION_NO").toUpperCase());
	            JsonObject.put("QuotationStatusDataIndex",rs.getString("QUOTATION_STATUS").toUpperCase());
	            informationList.add(rs.getString("QUOTATION_STATUS").toUpperCase());
	            JsonObject.put("StatusTypeDataIndex",rs.getString("STATUS_TYPE"));
	            informationList.add(rs.getString("STATUS_TYPE"));
	            JsonObject.put("ValidFromDataIndex",rs.getString("VALID_FROM").toUpperCase());
	            informationList.add(rs.getString("VALID_FROM").toUpperCase());
	            JsonObject.put("ValidToDataIndex",rs.getString("VALID_TO").toUpperCase());
	            informationList.add(rs.getString("VALID_TO").toUpperCase());
	            JsonObject.put("LocationDataIndex",rs.getString("LOCATION").toLowerCase());
	            informationList.add(rs.getString("LOCATION").toLowerCase());
	            JsonObject.put("QuotationForDataIndex",rs.getString("QUOTE_FOR").toUpperCase());
	            informationList.add(rs.getString("QUOTE_FOR").toUpperCase());
	            JsonObject.put("QuotationTypeDataIndex",rs.getString("CUSTOMER_NAME").toUpperCase());
	            informationList.add(rs.getString("CUSTOMER_NAME").toUpperCase());
	            JsonObject.put("TarrifTypeDataIndex",rs.getString("TARIFF_TYPE"));
	            informationList.add(rs.getString("TARIFF_TYPE"));
	            JsonObject.put("TarrifAmountDataIndex",rs.getString("TARIFF_AMOUNT").toUpperCase());
	            informationList.add(rs.getString("TARIFF_AMOUNT").toUpperCase());
	            JsonObject.put("RevisionCountDataIndex",rs.getString("REVISION_COUNT").toUpperCase());
	            informationList.add(rs.getString("REVISION_COUNT").toUpperCase());
	            
	            JsonObject.put("reasonDataIndex",rs.getString("REASON"));
	            informationList.add(rs.getString("REASON"));
	            
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
	
	
	public String updateQuote(String systemQuoteNo, String quotationNo, String validFrom, String validTo, String location, String quoteFor, String customer, String tariffType, String tariffAmt,Integer userId,int quotationCustId) {
	
		    Connection con = null;
		    PreparedStatement pstmt = null;
		    ResultSet rs = null;
		    con = DBConnection.getConnectionToDB("AMS");
		    String message="Error Occoured";
		    
		    try {
		    	
		    	pstmt = con.prepareStatement(CashVanManagementStatements.INSERT_QUOTATION_REVISION_HISTORY);
		    	pstmt.setString(1, systemQuoteNo);
		    	int i = pstmt.executeUpdate();
		    	if(i>0){
		    	
		    	int revisionCount = 0;
		    	revisionCount = getRevisionCount(Integer.parseInt(systemQuoteNo));
		    	revisionCount=revisionCount+1;
		    	//changed  revision Count notation 1,2,3 to R1,R2,R3
		    	String rev="R"+revisionCount;
				pstmt = con.prepareStatement(CashVanManagementStatements.UPDATE_QUOTATION);
				
				pstmt.setString(1, validFrom);
				pstmt.setString(2, validTo);
				pstmt.setString(3, location);
				pstmt.setString(4, quoteFor);
				pstmt.setString(5, customer);
				pstmt.setString(6, tariffType);
				pstmt.setString(7, tariffAmt);
				pstmt.setInt(8, userId);
				pstmt.setString(9, rev);
				pstmt.setInt(10, quotationCustId);
				pstmt.setString(11, systemQuoteNo);
				
				int rows = pstmt.executeUpdate();
			if(rows>0){
				message = "Success";
			}
		    }
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}finally {
		        DBConnection.releaseConnectionToDB(con, pstmt, rs);
		    }
			return message;
		
		
	}
	
	public int getRevisionCount(int systemQuoteNo){
		int count = 0;

		 Connection con = null;
			PreparedStatement pstmt= null;
		ResultSet rs = null;
			
			try
			{
				 con = DBConnection.getConnectionToDB("AMS");
				
				 pstmt = con.prepareStatement(CashVanManagementStatements.GET_REVISION_COUNT);
				 pstmt.setInt(1, systemQuoteNo);
				rs = pstmt.executeQuery();
				if(rs.next()){
					String revCount = rs.getString("REVISION_COUNT");	
					
					count=Integer.parseInt(revCount.substring(revCount.indexOf("R")+1, revCount.length()));
				}
			} catch (Exception e)
			 {
				e.printStackTrace();
		 }      
		finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
	    }
			
		
		return count;
	}
	
	public String ApproveOrRejection(int customerId,int systemId,int userId,int quotationId, String buttonValue,String statusType,String reason){
		
		 Connection con = null;
			PreparedStatement pstmt= null;
			ResultSet rs = null;
			String message="";
			
			try
			{
				 con = DBConnection.getConnectionToDB("AMS");
				
				 pstmt = con.prepareStatement(CashVanManagementStatements.CHECK_QUOTATION_STATUS);
				 pstmt.setInt(1, systemId);
				 pstmt.setInt(2, customerId);
				 pstmt.setInt(3, quotationId);
				 rs = pstmt.executeQuery();
				 if(rs.next()){
				 pstmt = con.prepareStatement(CashVanManagementStatements.UPDATE_QUOTATION_STATUS);
				
				 pstmt.setString(1,buttonValue);
				 pstmt.setString(2, statusType);
				 pstmt.setInt(3, userId);
				 pstmt.setString(4, reason);
				 pstmt.setInt(5, systemId);
				 pstmt.setInt(6, customerId);
				 pstmt.setInt(7, quotationId);

				 int inserted = pstmt.executeUpdate();
				if (inserted > 0) {
					 pstmt = con.prepareStatement(CashVanManagementStatements.INSERTINTO_QUOTATION_HISTORY);
					 pstmt.setInt(1, systemId);
					 pstmt.setInt(2, customerId);
					 pstmt.setInt(3, quotationId);
					 int deleted = pstmt.executeUpdate();
					 if(deleted>0){
					 pstmt = con.prepareStatement(CashVanManagementStatements.DELETE_QUOTATION_FROM_MASTER);
					 pstmt.setInt(1, systemId);
					 pstmt.setInt(2, customerId);
					 pstmt.setInt(3, quotationId);
					 int removed = pstmt.executeUpdate();
					if( removed>0) {
	            message = "Updated Successfully";
					}
					 }
				}
	       }else{
	    	   pstmt = con.prepareStatement(CashVanManagementStatements.INSERTINTO_QUOTATION_HISTORY);
				 pstmt.setInt(1, systemId);
				 pstmt.setInt(2, customerId);
				 pstmt.setInt(3, quotationId);
				 int deleted = pstmt.executeUpdate();
				 if(deleted>0){
				 pstmt = con.prepareStatement(CashVanManagementStatements.DELETE_QUOTATION_FROM_MASTER);
				 pstmt.setInt(1, systemId);
				 pstmt.setInt(2, customerId);
				 pstmt.setInt(3, quotationId);
				 int removed = pstmt.executeUpdate();
				 }
	    	   message = "Quotation Already Approved/Rejected";
			}
			}
			 catch (Exception e)
			 {
					System.out.println("error in:-save CustomerMaster details "+e.toString());
					e.printStackTrace();
			 }      
			finally {
				DBConnection.releaseConnectionToDB(con, pstmt, rs);
		    }
			return message;
		
	 }
	

	public Integer updateFilepathInDB(String DestinationPath,int systemId,int CustId,int quotationId){
		int update = 0;
		 Connection con = null;
			PreparedStatement pstmt= null;
		
			
			try
			{
				 con = DBConnection.getConnectionToDB("AMS");
				
				 pstmt = con.prepareStatement(CashVanManagementStatements.UPDATE_FILE_PATH);
				 pstmt.setString(1, DestinationPath);
				 pstmt.setInt(2, systemId);
				 pstmt.setInt(3, CustId);
				 pstmt.setInt(4, quotationId);
				update =  pstmt.executeUpdate();
			} catch (Exception e)
			 {
				e.printStackTrace();
		 }      
		finally {
			DBConnection.releaseConnectionToDB(con, pstmt, null);
	    }
			
		return update;
		
		
	}

	
	public String getFilePathFromDB(int systemId,int CustId,int quotationId){
		String filepath = "";
		 Connection con = null;
			PreparedStatement pstmt= null;
		ResultSet rs = null;
			
			try
			{
				 con = DBConnection.getConnectionToDB("AMS");
				
				 pstmt = con.prepareStatement(CashVanManagementStatements.GET_FILE_PSTH);
				 pstmt.setInt(1, systemId);
				 pstmt.setInt(2, CustId);
				 pstmt.setInt(3, quotationId);
				rs = pstmt.executeQuery();
				if(rs.next()){
					filepath = rs.getString("UPLOADED_FILE_PATH");	
				}else{
					 pstmt = con.prepareStatement(CashVanManagementStatements.GET_FILE_PSTH_HISTORY);
					 pstmt.setInt(1, systemId);
					 pstmt.setInt(2, CustId);
					 pstmt.setInt(3, quotationId);
					rs = pstmt.executeQuery();
					if(rs.next()){
						filepath = rs.getString("UPLOADED_FILE_PATH");	
					}
				}
			} catch (Exception e)
			 {
				e.printStackTrace();
		 }      
		finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
	    }
			
		return filepath;
		
		
	}
public String getCustomerName(int systemId,int customerId){

	String custName = "";
	 Connection con = null;
		PreparedStatement pstmt= null;
	ResultSet rs = null;
		
		try
		{
			 con = DBConnection.getConnectionToDB("ADMINISTRATOR");
			
			 pstmt = con.prepareStatement(CashVanManagementStatements.GET_CUSTOMER_NAME_FROM_LTSP);
			 pstmt.setInt(1, systemId);
			 pstmt.setInt(2, customerId);
			rs = pstmt.executeQuery();
			if(rs.next()){
				custName = rs.getString("NAME");	
			}
		} catch (Exception e)
		 {
			e.printStackTrace();
	 }      
	finally {
		DBConnection.releaseConnectionToDB(con, pstmt, rs);
    }
		
	return custName;
	
	

}
public String saveStationary(String s, String inwardDate, String vendor,int branch, int CustId, int systemId, int inwardBy) {

    Connection con = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;   
    String message="Error Occoured";
    int itemId = 0;
    String itemName = "";
    int initailQty =0;
    int remainingQty = 0;
    int rows = 0;
    String remarks = "";
    inwardDate = inwardDate.substring(0,inwardDate.indexOf("T"));
    JSONArray jsonArray = null;

    try {
    	con = DBConnection.getConnectionToDB("AMS");
    	
		HashMap<Integer, Integer>    remainingQtyHashMap  = new HashMap<Integer, Integer> ();
		remainingQtyHashMap = getRemaingQuty(con);

    	if (s != null) {
            String st = "[" + s + "]";
        	jsonArray = new JSONArray(st.toString());
    	} 
           
    	for(int i =0;i<jsonArray.length();i++){
    		
			JSONObject obj = jsonArray.getJSONObject(i);
			
			itemId = obj.getInt("StationaryIyemDataIndex");
			itemName = obj.getString("StationaryIyemIDDataIndex");
		    initailQty =obj.getInt("QuantityDataIndex");
		    remainingQty = obj.getInt("QuantityDataIndex");
		    remarks =  obj.getString("RemarksDataIndex");
			for (Entry<Integer, Integer> entry: remainingQtyHashMap.entrySet()) {
			    if (entry.getKey() == itemId ){
			    	remainingQty = entry.getValue()+initailQty;				       
			    }
			}
    	pstmt = con.prepareStatement(CashVanManagementStatements.INSET_STATIONARY_DETAILS);
    	pstmt.setInt(1, itemId);
    	pstmt.setString(2, itemName);
    	pstmt.setInt(3, initailQty);
    	pstmt.setInt(4, remainingQty);
    	pstmt.setString(5, inwardDate);
    	pstmt.setInt(6, inwardBy);
    	pstmt.setString(7, vendor);
    	pstmt.setInt(8, branch);
    	pstmt.setInt(9, systemId);
    	pstmt.setInt(10, CustId);
    	pstmt.setString(11, remarks);
		rows = pstmt.executeUpdate();
    	}
	if(rows>0){
		message = "Details Saved Successfuly";
	}
    
	} catch (Exception e) {
		e.printStackTrace();
	}finally {
        DBConnection.releaseConnectionToDB(con, pstmt, rs);
    }
	return message;

}

public HashMap<Integer, Integer> getRemaingQuty(Connection con){
	 
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
	HashMap<Integer, Integer>    remainingQtyHashMap  = new HashMap<Integer, Integer> ();
	try {
		pstmt = con.prepareStatement(CashVanManagementStatements.GET_ALL_REMANING_QTY);
		rs = pstmt.executeQuery();
	    while (rs.next()) {
	    	remainingQtyHashMap.put(rs.getInt("ITEM_ID"), rs.getInt("REMAING_QTY"));
	     }
	} catch (SQLException e) {
		e.printStackTrace();
	}
	
	return remainingQtyHashMap;
}

public JSONArray getStationaryInwardDetails(int systemId, int customerId, String vendorName,int branchId,String inwardDate ) {
    JSONArray JsonArray = new JSONArray();
    JSONObject JsonObject = null;
    Connection con = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    try {
        int count = 0;

        con = DBConnection.getConnectionToDB("AMS");
        pstmt = con.prepareStatement(CashVanManagementStatements.GET_STATIONARY_DETAILS);
        pstmt.setInt(1, systemId);
        pstmt.setInt(2, customerId);
        pstmt.setInt(3, branchId);
        pstmt.setString(4, inwardDate);
        rs = pstmt.executeQuery();
        while (rs.next()) {
            JsonObject = new JSONObject();
            count++;
           
            JsonObject.put("StationaryIyemDataIndex",rs.getString("ITEM_ID"));
            JsonObject.put("StationaryIyemIDDataIndex",rs.getString("ITEM_NAME"));
            JsonObject.put("QuantityDataIndex",rs.getString("INITIAL_QUANTITY"));
            JsonObject.put("RemainingQuantityDataIndex","");
            JsonObject.put("RemarksDataIndex",rs.getString("REMARKS"));
            JsonObject.put("InsertedDatetimeIndex",rs.getString("ACTUAL_INWARD_DATE"));
            JsonObject.put("InsertedByIndex",rs.getString("INWARD_BY"));
			JsonObject.put("VendorNameDataIndex",rs.getString("VENDOR_NAME"));

            
            JsonArray.put(JsonObject); 
        }      
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        DBConnection.releaseConnectionToDB(con, pstmt, rs);
    }
    return JsonArray;
}
public JSONArray getStationaryInwardSummary(int systemId, int customerId, String vendorName,int branchId,String inwardDate ) {
    JSONArray JsonArray = new JSONArray();
    JSONObject JsonObject = null;
    Connection con = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    try {
        int count = 0;
        con = DBConnection.getConnectionToDB("AMS");
        pstmt = con.prepareStatement(CashVanManagementStatements.GET_STATIONARY_SUMMARY);
        pstmt.setInt(1, systemId);
        pstmt.setInt(2, customerId);
        pstmt.setInt(3, branchId);
        //pstmt.setString(4, inwardDate);
        rs = pstmt.executeQuery();
        while (rs.next()) {
            JsonObject = new JSONObject();
            count++;
           
            JsonObject.put("StationaryIyemDataIndex",rs.getString("ITEM_ID"));
            JsonObject.put("QuantityDataIndex",rs.getString("INITIAL_QUANTITY"));
            JsonObject.put("RemainingQuantityDataIndex",rs.getString("REMAINING_QTY"));
			JsonObject.put("VendorNameDataIndex",rs.getString("VENDOR_NAME"));
   
            JsonArray.put(JsonObject); 
        }      
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        DBConnection.releaseConnectionToDB(con, pstmt, rs);
    }
    return JsonArray;
}

public JSONArray getArmoryItems(int systemId, int custId,String assetType) {
	Connection con=null;
	PreparedStatement pstmt=null;
	ResultSet rs=null;
	JSONArray JsonArray = new JSONArray();
	JSONObject JsonObject = null;
	try {
		
		con=DBConnection.getConnectionToDB("AMS");
		pstmt=con.prepareStatement(CashVanManagementStatements.GET_ARMORY_ITEMS);		
		pstmt.setInt(1, systemId);
		pstmt.setInt(2, custId);
		pstmt.setString(3, assetType);
		rs=pstmt.executeQuery();
		  while (rs.next()) {
			  JsonObject = new JSONObject();
			  JsonObject.put("itemId", rs.getString("Id"));
	            JsonObject.put("itemName", rs.getString("ITEM_NAME"));
	            JsonArray.put(JsonObject);
			
		}

	} catch (Exception e) {
		e.printStackTrace();
	
	}finally{
		DBConnection.releaseConnectionToDB(con, pstmt, rs);
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
		pstmt=conAdmin.prepareStatement(CashVanManagementStatements.GET_SATTIONARY_ITEMS);
		
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
		pstmt=conAdmin.prepareStatement(CashVanManagementStatements.GET_BRANCHES);
		
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







public JSONArray getStationaryIssuance(String dateStr, String endDateStr, Integer branchId, int systemId, int customerId,Integer userId) {
	JSONObject JsonObject = new JSONObject();
	 JSONArray JsonArray = new JSONArray();
		Connection conAdmin=null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		conAdmin=DBConnection.getConnectionToDB("AMS");

		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	
		SimpleDateFormat sdf2 = new SimpleDateFormat("MM/dd/yyyy");
	  try {
		  dateStr = dateStr.replace('T', ' ');
		  Date fromDate=sdf.parse(dateStr);
		  endDateStr = endDateStr.replace('T', ' ');
		  Date toDate=sdf.parse(endDateStr);
		  
		  dateStr=sdf2.format(fromDate)+" 12:00:00 AM";
		  endDateStr=sdf2.format(toDate)+" 12:00:00 AM";
		pstmt=conAdmin.prepareStatement(CashVanManagementStatements.GET_ISSUANCE);
		pstmt.setInt(1,branchId);
		pstmt.setInt(2,userId);
		pstmt.setString(3, dateStr);
		pstmt.setString(4,endDateStr);
		rs=pstmt.executeQuery();
		
		  while (rs.next()) {
			  JsonObject=new JSONObject();
			  JsonObject.put("stationaryName",rs.getString("ITEM_NAME"));
			  
			  
			  JsonObject.put("quantity", rs.getInt("QUANTITY"));
			 
			  
			    JsonObject.put("issuedTo", rs.getString("issuedTo"));
			    
			    JsonObject.put("department", rs.getString("DEPT"));
			    
			    JsonObject.put("branchName", rs.getString("branch"));
			    
			   String tempDate =rs.getString("DATE");
			   tempDate=tempDate.substring(0, tempDate.indexOf(" "));
			  SimpleDateFormat dateFormat=new SimpleDateFormat("yyyy-MM-dd");
			  SimpleDateFormat dateFormat2=new SimpleDateFormat("dd-MM-yyyy");
			 Date date= dateFormat.parse(tempDate);
			  
			    JsonObject.put("date",dateFormat2.format(date) );
			    JsonArray.put(JsonObject);
			 		          
			
		}

		
		   
	} catch (SQLException e) {
		// TODO Auto-generated catch block
		e.printStackTrace();
	} catch (ParseException e) {
		// TODO Auto-generated catch block
		e.printStackTrace();
	} catch (JSONException e) {
		// TODO Auto-generated catch block
		e.printStackTrace();
	}
        
	return JsonArray;
}







public Integer getStationaryAvailabilityCount(Integer stationaryId,
		Integer fromBranch, int systemId, int customerId) {
	Connection conAdmin=null;
	PreparedStatement pstmt=null;
	ResultSet rs=null;
	int count=0;
	conAdmin=DBConnection.getConnectionToDB("AMS");
	try {
		pstmt=conAdmin.prepareStatement(CashVanManagementStatements.AVALIBILITY_COUNT);
		pstmt.setInt(1, stationaryId);
		pstmt.setInt(2, fromBranch);
		pstmt.setInt(3, systemId);
		pstmt.setInt(4, customerId);
	rs=	pstmt.executeQuery();
	  while (rs.next()) {
		 
		  count= rs.getInt("count");
          
		
	}
        
}
	catch (SQLException e) {
		// TODO Auto-generated catch block
		e.printStackTrace();
	}finally{
		DBConnection.releaseConnectionToDB(conAdmin, pstmt, rs);
	}
	return count;
}







public String saveIssuance(Integer stationaryId, Integer fromBranch,Integer toBranch, Integer count, String dateStr, String dept,int systemId, int customerId,int userId) {
	Connection conAdmin=null;
	PreparedStatement pstmt=null;
	ResultSet rs=null;
	String msg="Unable to save Issuance";
	conAdmin=DBConnection.getConnectionToDB("AMS");
	
	try {
		conAdmin.setAutoCommit(false);
		dateStr=dateStr.replace('T', ' ');
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		Date date=sdf.parse(dateStr);
		SimpleDateFormat sdf2 = new SimpleDateFormat("MM/dd/yyyy");
		
		
		pstmt=conAdmin.prepareStatement(CashVanManagementStatements.SAVE_ISSUANCE);
		pstmt.setInt(1,stationaryId);
		pstmt.setInt(2,count);
		pstmt.setInt(3,fromBranch);
		pstmt.setString(4,sdf2.format(date));
		pstmt.setString(5,dept);
		pstmt.setInt(6,toBranch);
		pstmt.setInt(7, userId);
		pstmt.setInt(8, systemId);
		pstmt.setInt(9, customerId);
		
		int key=pstmt.executeUpdate();
	// TODO Auto-generated method stub
	if(key>0){
		
			pstmt=null;
			rs=null;
			pstmt=conAdmin.prepareStatement(CashVanManagementStatements.AVALIBILITY_COUNT);
			pstmt.setInt(1, stationaryId);
			pstmt.setInt(2, fromBranch);
			pstmt.setInt(3, systemId);
			pstmt.setInt(4, customerId);
		rs=	pstmt.executeQuery();
		int rowId = 0;
		int avilCount = 0;
		  while (rs.next()) {
			  avilCount= rs.getInt("count");
			  rowId=rs.getInt("ID");
		}
			pstmt=null;
			rs=null;
			pstmt=conAdmin.prepareStatement(CashVanManagementStatements.UPDATE_REMAINING_QUANT);
			pstmt.setInt(1, avilCount-count);
			pstmt.setInt(2, rowId);
			int row=pstmt.executeUpdate();
			if(row>0){
				
				conAdmin.commit();
		msg="Successfully saved";
		return msg;
			}else {
				conAdmin.rollback();
				msg="Can't issue itmes right now";
				return msg;
			}
	}
	
	
}catch (SQLException e) {
	// TODO Auto-generated catch block
	try {
		conAdmin.rollback();
	} catch (SQLException e1) {
		// TODO Auto-generated catch block
		e1.printStackTrace();
	}
	e.printStackTrace();
} catch (ParseException e) {
	// TODO Auto-generated catch block
	
	e.printStackTrace();
}finally{
	
	DBConnection.releaseConnectionToDB(conAdmin, pstmt, rs);
}
	return msg;
	}

public JSONArray getCustomerForVault(int customerId, int systemId) {
    Connection conAdmin = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    JSONArray jsonArray = new JSONArray();
    JSONObject jsonObject = new JSONObject();	
    try {
        conAdmin = DBConnection.getConnectionToDB("AMS");
        pstmt = conAdmin.prepareStatement(CashVanManagementStatements.GET_CVS_CUSTOMER_FOR_VAULT);
        pstmt.setInt(1, customerId);
        pstmt.setInt(2, systemId);
        rs = pstmt.executeQuery();
        while (rs.next()) {
            jsonObject = new JSONObject();
            jsonObject.put("CustomerId", rs.getString("CustomerId"));
            jsonObject.put("CustomerName", rs.getString("CustomerName"));
            jsonArray.put(jsonObject);
        }
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        DBConnection.releaseConnectionToDB(conAdmin, pstmt, rs);
    }
    return jsonArray;
}

public JSONArray getSealNoForVault(int customerId, int systemId, int cvsCustId) {
    Connection conAdmin = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    JSONArray jsonArray = new JSONArray();
    JSONObject jsonObject = new JSONObject();	
    try {
        conAdmin = DBConnection.getConnectionToDB("AMS");
        pstmt = conAdmin.prepareStatement(CashVanManagementStatements.GET_CVS_SEAL_NO_FOR_VAULT);
        pstmt.setInt(1, systemId);
        pstmt.setInt(2, customerId);
        pstmt.setInt(3, cvsCustId);
        rs = pstmt.executeQuery();
        while (rs.next()) {
            jsonObject = new JSONObject();
            jsonObject.put("SealNo", rs.getString("SEAL_NO"));
            jsonObject.put("TotalAmount", rs.getString("TOTAL_AMOUNT"));
            jsonArray.put(jsonObject);
        }
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        DBConnection.releaseConnectionToDB(conAdmin, pstmt, rs);
    }
    return jsonArray;
}


public String saveDenomination(int inwardId,String buttonValue,String s,String inwardDate,int cVSCustId,String cashType,int customerId,int systemId,int userId,
		String sealNo, double sealedTotalAmount) throws ParseException {
    String inwardMode= "DIRECT";
	// inwardDate = inwardDate.substring(0,inwardDate.indexOf(" "));
    String indate [] = inwardDate.split(" ");
    String date2 = indate [0];
    String dates[] = date2.split("-");
    inwardDate = dates[2]+"-"+dates[1]+"-"+dates[0]+" "+indate [1];
	Connection con = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    JSONArray jsonArray = new JSONArray();
   
    String message ="";
    long twothGoodNo = 0;  
    long onethGoodNo = 0;
    long fiveHunGoodNo=0;
    long oneHunGoodNo=0;


    long twothBadNo = 0;
    long onethBadNo = 0;
    long fiveHunBadNo=0;
    long oneHunBadNo=0;


    long twothSoiledNo = 0;
    long onethSoiledNo = 0;
    long fiveHunSoiledNo=0;
    long oneHunSoiledNo=0;


    long twothCounterNo = 0;
    long onethCounterNo = 0;
    long fiveHunCounterNo=0;
    long oneHunCounterNo=0; 
  
    long fivethGoodNo = 0;  
    long fivethBadNo = 0;
    long fivethSoiledNo=0;
    long fivethCounterNo=0;
    
    long fiftyGoodNo = 0;  
    long fiftyBadNo = 0;
    long fiftySoiledNo=0;
    long fiftyCounterNo=0;
    
    long twentyGoodNo = 0;  
    long twentyBadNo = 0;
    long twentySoiledNo=0;
    long twentyCounterNo=0;
    
    long tenGoodNo = 0;  
    long tenBadNo = 0;
    long tenSoiledNo=0;
    long tenCounterNo=0;
    
    long fiveGoodNo = 0;  
    long fiveBadNo = 0;
    long fiveSoiledNo=0;
    long fiveCounterNo=0;
    
    long twoGoodNo = 0;  
    long twoBadNo = 0;
    long twoSoiledNo=0;
    long twoCounterNo=0;
    
    long oneGoodNo = 0;  
    long oneBadNo = 0;
    long oneSoiledNo=0;
    long oneCounterNo=0;
    
    double totalAmount = 0;
    int sysGeneratedId =0;
    String cashCondition ="GOOD";
    try {
        con = DBConnection.getConnectionToDB("AMS");
        if (s != null) {
            String st = "[" + s + "]";
        	jsonArray = new JSONArray(st.toString());
    	} 
    
       for(int i =0; i<jsonArray.length(); i++){
    	   JSONObject obj = jsonArray.getJSONObject(i);
    	  
    	   
    	   if(obj.getInt("DenominationDataIndex")== 5000){
    		 
    		    fivethGoodNo = obj.getLong("GoodNoOfNotesDataIndex"); 
    		    fivethBadNo =  obj.getLong("BadNoOfNotesDataIndex"); 
    		    fivethSoiledNo = obj.getLong("SoiledNoOfNotesDataIndex"); 
    		    fivethCounterNo = obj.getLong("CounterfeitNoOfNotesDataIndex"); 
    		    
			   totalAmount =totalAmount+ (fivethGoodNo*5000)+(fivethBadNo*5000)+(fivethSoiledNo*5000)+(fivethCounterNo*5000);
			}
    	  
			if(obj.getInt("DenominationDataIndex")== 2000){
				twothGoodNo = obj.getLong("GoodNoOfNotesDataIndex"); 
				twothBadNo = obj.getLong("BadNoOfNotesDataIndex"); 
				twothSoiledNo = obj.getLong("SoiledNoOfNotesDataIndex"); 
				twothCounterNo = obj.getLong("CounterfeitNoOfNotesDataIndex"); 
				totalAmount =totalAmount+ (twothGoodNo*2000)+(twothBadNo*2000)+(twothSoiledNo*2000)+(twothCounterNo*2000);
			}
			if(obj.getInt("DenominationDataIndex")== 1000){
				onethGoodNo = obj.getLong("GoodNoOfNotesDataIndex"); 
				onethBadNo = obj.getLong("BadNoOfNotesDataIndex"); 
				onethSoiledNo = obj.getLong("SoiledNoOfNotesDataIndex"); 
				onethCounterNo = obj.getLong("CounterfeitNoOfNotesDataIndex"); 
				totalAmount =totalAmount+ (onethGoodNo*1000)+(onethBadNo*1000)+(onethSoiledNo*1000)+(onethCounterNo*1000);

			}
			if(obj.getInt("DenominationDataIndex")== 500){
				fiveHunGoodNo = obj.getLong("GoodNoOfNotesDataIndex"); 
				fiveHunBadNo = obj.getLong("BadNoOfNotesDataIndex"); 
				fiveHunSoiledNo = obj.getLong("SoiledNoOfNotesDataIndex"); 
				fiveHunCounterNo = obj.getLong("CounterfeitNoOfNotesDataIndex"); 
				totalAmount =totalAmount+ (fiveHunGoodNo*500)+(fiveHunBadNo*500)+(fiveHunSoiledNo*500)+(fiveHunCounterNo*500);

			}
			if(obj.getInt("DenominationDataIndex")== 100){
				oneHunGoodNo = obj.getLong("GoodNoOfNotesDataIndex"); 
				oneHunBadNo = obj.getLong("BadNoOfNotesDataIndex"); 
				oneHunSoiledNo = obj.getLong("SoiledNoOfNotesDataIndex"); 
				oneHunCounterNo = obj.getLong("CounterfeitNoOfNotesDataIndex");
				totalAmount =totalAmount+ (oneHunGoodNo*100)+(oneHunBadNo*100)+(oneHunSoiledNo*100)+(oneHunCounterNo*100);

			}
			
			if(obj.getInt("DenominationDataIndex")== 50){
				fiftyGoodNo = obj.getLong("GoodNoOfNotesDataIndex"); 
				fiftyBadNo = obj.getLong("BadNoOfNotesDataIndex"); 
				fiftySoiledNo = obj.getLong("SoiledNoOfNotesDataIndex"); 
				fiftyCounterNo = obj.getLong("CounterfeitNoOfNotesDataIndex");
				totalAmount =totalAmount+ (fiftyGoodNo*50)+(fiftyBadNo*50)+(fiftySoiledNo*50)+(fiftyCounterNo*50);

			}
			
			if(obj.getInt("DenominationDataIndex")== 20){
				twentyGoodNo = obj.getLong("GoodNoOfNotesDataIndex"); 
				twentyBadNo = obj.getLong("BadNoOfNotesDataIndex"); 
				twentySoiledNo = obj.getLong("SoiledNoOfNotesDataIndex"); 
				twentyCounterNo = obj.getLong("CounterfeitNoOfNotesDataIndex");
				totalAmount =totalAmount+ (twentyGoodNo*20)+(twentyBadNo*20)+(twentySoiledNo*20)+(twentyCounterNo*20);

			}
			
			if(obj.getInt("DenominationDataIndex")== 10){
				tenGoodNo = obj.getLong("GoodNoOfNotesDataIndex"); 
				tenBadNo = obj.getLong("BadNoOfNotesDataIndex"); 
				tenSoiledNo = obj.getLong("SoiledNoOfNotesDataIndex"); 
				tenCounterNo = obj.getLong("CounterfeitNoOfNotesDataIndex");
				totalAmount =totalAmount+ (tenGoodNo*10)+(tenBadNo*10)+(tenSoiledNo*10)+(tenCounterNo*10);

			}
			if(obj.getInt("DenominationDataIndex")== 5){
				fiveGoodNo = obj.getLong("GoodNoOfNotesDataIndex"); 
				fiveBadNo = obj.getLong("BadNoOfNotesDataIndex"); 
				fiveSoiledNo = obj.getLong("SoiledNoOfNotesDataIndex"); 
				fiveCounterNo = obj.getLong("CounterfeitNoOfNotesDataIndex");
				totalAmount =totalAmount+ (fiveGoodNo*5)+(fiveBadNo*5)+(fiveSoiledNo*5)+(fiveCounterNo*5);

			}
			if(obj.getInt("DenominationDataIndex")== 2){
				twoGoodNo = obj.getLong("GoodNoOfNotesDataIndex"); 
				twoBadNo = obj.getLong("BadNoOfNotesDataIndex"); 
				twoSoiledNo = obj.getLong("SoiledNoOfNotesDataIndex"); 
				twoCounterNo = obj.getLong("CounterfeitNoOfNotesDataIndex");
				totalAmount =totalAmount+ (twoGoodNo*2)+(twoBadNo*2)+(twoSoiledNo*2)+(twoCounterNo*2);

			}
			if(obj.getInt("DenominationDataIndex")== 1){
				oneGoodNo = obj.getLong("GoodNoOfNotesDataIndex"); 
				oneBadNo = obj.getLong("BadNoOfNotesDataIndex"); 
				oneSoiledNo = obj.getLong("SoiledNoOfNotesDataIndex"); 
				oneCounterNo = obj.getLong("CounterfeitNoOfNotesDataIndex");
				totalAmount =totalAmount+ (oneGoodNo*1)+(oneBadNo*1)+(oneSoiledNo*1)+(oneCounterNo*1);

			}
       }
if(cashType.equalsIgnoreCase("SEALED BAG")){
    	   totalAmount = sealedTotalAmount; 
       }
       if(buttonValue.equalsIgnoreCase("Modify")){

    	    pstmt = con.prepareStatement(CashVanManagementStatements.UPDATE_CASH_INWARD_DETAILS);
    	   	pstmt.setString(1, inwardMode);
    	   	pstmt.setString(2, inwardDate);
    	   	pstmt.setInt(3, cVSCustId);
    	   	pstmt.setString(4, sealNo);
    		pstmt.setDouble(5, totalAmount);   	   	
    	   	pstmt.setString(6, cashType);
    	   	pstmt.setInt(7, customerId);
    	   	pstmt.setInt(8, systemId);
    	   	pstmt.setInt(9, userId);
    	   	pstmt.setInt(10, inwardId);
    	   	int rows = pstmt.executeUpdate();
    		
    	    	sysGeneratedId = inwardId;          
    	    
    	       if(rows>0){
    	    	  if(cashType.equals("CASH")) {
    	    	   for(int i =0; i<4; i++){
    	    		   if(i==0){
    	    			cashCondition = "GOOD";
    	    			if(oneGoodNo+twoGoodNo+fiveGoodNo+tenGoodNo+twentyGoodNo+fiftyGoodNo+oneHunGoodNo+fiveHunGoodNo+onethGoodNo+twothGoodNo+fivethGoodNo>0){
    	    				long oneGoodNoUpdate =0;
							long twoGoodNoUpdate =0;
							long fiveGoodNoUpdate=0;
							long tenGoodNoUpdate=0;
							long twentyGoodNoUpdate=0;
							long fiftyGoodNoUpdate=0;
							long oneHunGoodNoUpdate=0;
							long fiveHunGoodNoUpdate=0;
							long onethGoodNoUpdate=0;
							long twothGoodNoUpdate=0;
							long fivethGoodNoUpdate=0;
							
							long oneGoodNoOld =0;
							long twoGoodNoOld =0;
							long fiveGoodNoOld=0;
							long tenGoodNoOld=0;
							long twentyGoodNoOld=0;
							long fiftyGoodNoOld=0;
							long oneHunGoodNoOld=0;
							long fiveHunGoodNoOld=0;
							long onethGoodNoOld=0;
							long twothGoodNoOld=0;
							long fivethGoodNoOld=0;
							
							
							pstmt = con.prepareStatement(CashVanManagementStatements.CHECK_FOR_UPDATED_VALUES);
			    			pstmt.setInt(1, sysGeneratedId);
			    			pstmt.setString(2, cashCondition);
			    			rs = pstmt.executeQuery();
			    			if(rs.next()){
			    				
			    				if(oneGoodNo!=rs.getLong("DENOM_1")){
			    					oneGoodNoUpdate = oneGoodNo;
			    				   oneGoodNoOld = rs.getLong("DENOM_1");
			    				}
			    				if(twoGoodNo!=rs.getLong("DENOM_2")){
			    					twoGoodNoUpdate = twoGoodNo;
			    				    twoGoodNoOld = rs.getLong("DENOM_2");
			    				}
			    					if(fiveGoodNo!=rs.getLong("DENOM_5")){
			    						fiveGoodNoUpdate = fiveGoodNo;
			    				    fiveGoodNoOld = rs.getLong("DENOM_5");
			    					}
			    					if(tenGoodNo!=rs.getLong("DENOM_10")){
			    						tenGoodNoUpdate= tenGoodNo;
			    					   tenGoodNoOld =rs.getLong("DENOM_10");
			    					}
			    					if(twentyGoodNo!=rs.getLong("DENOM_20")){
			    						twentyGoodNoUpdate= twentyGoodNo;
			    						twentyGoodNoOld=rs.getLong("DENOM_20");
			    					}
			    					if(fiftyGoodNo!=rs.getLong("DENOM_50")){
			    						fiftyGoodNoUpdate= fiftyGoodNo;
			    						fiftyGoodNoOld = rs.getLong("DENOM_50");
			    					}
			    					if(oneHunGoodNo!=rs.getLong("DENOM_100")){
			    						oneHunGoodNoUpdate= oneHunGoodNo;
			    						oneHunGoodNoOld=rs.getLong("DENOM_100");
			    					}
			    					if(fiveHunGoodNo!=rs.getLong("DENOM_500")){
			    						fiveHunGoodNoUpdate= fiveHunGoodNo;
			    						fiveHunGoodNoOld=rs.getLong("DENOM_500");
			    					}
			    					if(onethGoodNo!=rs.getLong("DENOM_1000")){
			    						onethGoodNoUpdate= onethGoodNo;
			    						onethGoodNoOld =rs.getLong("DENOM_1000");
			    					}
			    					if(twothGoodNo!=rs.getLong("DENOM_2000")){
			    						twothGoodNoUpdate=twothGoodNo ;
			    						twothGoodNoOld=rs.getLong("DENOM_2000");
			    					}
			    					if(fivethGoodNo!=rs.getLong("DENOM_5000")){
			    						fivethGoodNoUpdate= fivethGoodNo;
			    						fivethGoodNoOld =rs.getLong("DENOM_5000") ;
			    					}
			    	    			pstmt = con.prepareStatement(CashVanManagementStatements.UPDATE_DENOMINATION_DETAILS);

			    			}else{
		    	    			pstmt = con.prepareStatement(CashVanManagementStatements.INSERT_DENOMINATION_DETAILS2);

			    			}
    	    			pstmt.setLong(1, oneGoodNo);
    	    			pstmt.setLong(2, twoGoodNo);
    	    			pstmt.setLong(3, fiveGoodNo);
    	    			pstmt.setLong(4, tenGoodNo);
    	    			pstmt.setLong(5, twentyGoodNo);
    	    			pstmt.setLong(6, fiftyGoodNo);
    	       		   	pstmt.setLong(7, oneHunGoodNo);
    	       		   	pstmt.setLong(8, fiveHunGoodNo);
    	       		   	pstmt.setLong(9, onethGoodNo);
    	       			pstmt.setLong(10, twothGoodNo);
    	       			pstmt.setLong(11, fivethGoodNo); 
    	       		   	pstmt.setString(12, cashCondition);
    	       		   	pstmt.setInt(13, sysGeneratedId);

    	       		    int updatecount = pstmt.executeUpdate();
    	       		    if(updatecount>0){
    	       		    updateVaultTrasit(con,cVSCustId,customerId,systemId,
    	       		    		oneGoodNoUpdate,twoGoodNoUpdate,fiveGoodNoUpdate,tenGoodNoUpdate,twentyGoodNoUpdate,fiftyGoodNoUpdate,oneHunGoodNoUpdate,fiveHunGoodNoUpdate,onethGoodNoUpdate,twothGoodNoUpdate,fivethGoodNoUpdate,
    	       		    		oneGoodNoOld,twoGoodNoOld,fiveGoodNoOld,tenGoodNoOld,twentyGoodNoOld,fiftyGoodNoOld,oneHunGoodNoOld,fiveHunGoodNoOld,onethGoodNoOld,twothGoodNoOld,fivethGoodNoOld,
    	       		    		userId,"Inward");
    	       		    }
    	    			}
    	    		   }
    	    		   else if(i==1){
    	       			cashCondition = "BAD";
    	    			if(oneBadNo+twoBadNo+fiveBadNo+tenBadNo+twentyBadNo+fiftyBadNo+oneHunBadNo+fiveHunBadNo+onethBadNo+twothBadNo+fivethBadNo>0){
    	    				pstmt = con.prepareStatement(CashVanManagementStatements.CHECK_FOR_UPDATED_VALUES);
    	    				pstmt.setInt(1, sysGeneratedId);
			    			pstmt.setString(2, cashCondition);
			    			rs = pstmt.executeQuery();
			    			if(rs.next()){
	    	    				pstmt = con.prepareStatement(CashVanManagementStatements.UPDATE_DENOMINATION_DETAILS);
	
			    			}else{
		    	    			pstmt = con.prepareStatement(CashVanManagementStatements.INSERT_DENOMINATION_DETAILS2);

			    			}
    	    				
    	       			pstmt.setLong(1, oneBadNo);
    	    			pstmt.setLong(2, twoBadNo);
    	    			pstmt.setLong(3, fiveBadNo);
    	    			pstmt.setLong(4, tenBadNo);
    	    			pstmt.setLong(5, twentyBadNo);
    	    			pstmt.setLong(6, fiftyBadNo);
    	       		   	pstmt.setLong(7, oneHunBadNo);
    	       		   	pstmt.setLong(8, fiveHunBadNo);
    	       		   	pstmt.setLong(9, onethBadNo);
    	       			pstmt.setLong(10, twothBadNo);
    	       			pstmt.setLong(11, fivethBadNo); 
    	       		   	pstmt.setString(12, cashCondition);
    	       		   	pstmt.setInt(13, sysGeneratedId);

    	          		  pstmt.executeUpdate();
    	       			}
    	       		   }
    	    		   else if(i==2){
    	       			cashCondition = "SOILED";
    	    			if(oneSoiledNo+twoSoiledNo+fiveSoiledNo+tenSoiledNo+twentySoiledNo+fiftySoiledNo+oneHunSoiledNo+fiveHunSoiledNo+onethSoiledNo+twothSoiledNo+fivethSoiledNo>0){
    	    				pstmt = con.prepareStatement(CashVanManagementStatements.CHECK_FOR_UPDATED_VALUES);
    	    				pstmt.setInt(1, sysGeneratedId);
			    			pstmt.setString(2, cashCondition);
			    			rs = pstmt.executeQuery();
			    			if(rs.next()){
	    	    				pstmt = con.prepareStatement(CashVanManagementStatements.UPDATE_DENOMINATION_DETAILS);
	
			    			}else{
		    	    			pstmt = con.prepareStatement(CashVanManagementStatements.INSERT_DENOMINATION_DETAILS2);

			    			}
    	       			pstmt.setLong(1, oneSoiledNo);
    	    			pstmt.setLong(2, twoSoiledNo);
    	    			pstmt.setLong(3, fiveSoiledNo);
    	    			pstmt.setLong(4, tenSoiledNo);
    	    			pstmt.setLong(5, twentySoiledNo);
    	    			pstmt.setLong(6, fiftySoiledNo);
    	       		   	pstmt.setLong(7, oneHunSoiledNo);
    	       		   	pstmt.setLong(8, fiveHunSoiledNo);
    	       		   	pstmt.setLong(9, onethSoiledNo);
    	       			pstmt.setLong(10, twothSoiledNo);
    	       			pstmt.setLong(11, fivethSoiledNo); 
    	       		   	pstmt.setString(12, cashCondition);
    	       		   	pstmt.setLong(13, sysGeneratedId);

    	          		  pstmt.executeUpdate();
    	       			}
    	       		   }
    	    		   else if(i==3){
    	       			cashCondition = "COUNTERFIET";
    	    			if(oneCounterNo+twoCounterNo+fiveCounterNo+tenCounterNo+twentyCounterNo+fiftyCounterNo+oneHunCounterNo+fiveHunCounterNo+onethCounterNo+twothCounterNo+fivethCounterNo>0){
    	    				pstmt = con.prepareStatement(CashVanManagementStatements.CHECK_FOR_UPDATED_VALUES);
    	    				pstmt.setInt(1, sysGeneratedId);
			    			pstmt.setString(2, cashCondition);
			    			rs = pstmt.executeQuery();
			    			if(rs.next()){
	    	    				pstmt = con.prepareStatement(CashVanManagementStatements.UPDATE_DENOMINATION_DETAILS);
	
			    			}else{
		    	    			pstmt = con.prepareStatement(CashVanManagementStatements.INSERT_DENOMINATION_DETAILS2);

			    			}
    	       			pstmt.setLong(1, oneCounterNo);
    	    			pstmt.setLong(2, twoCounterNo);
    	    			pstmt.setLong(3, fiveCounterNo);
    	    			pstmt.setLong(4, tenCounterNo);
    	    			pstmt.setLong(5, twentyCounterNo);
    	    			pstmt.setLong(6, fiftyCounterNo);
    	       		   	pstmt.setLong(7, oneHunCounterNo);
    	       		   	pstmt.setLong(8, fiveHunCounterNo);
    	       		   	pstmt.setLong(9, onethCounterNo);
    	       			pstmt.setLong(10, twothCounterNo);
    	       			pstmt.setLong(11, fivethCounterNo); 
    	       		   	pstmt.setString(12, cashCondition);
    	       		   	pstmt.setInt(13, sysGeneratedId);
    	          		  pstmt.executeUpdate();
    	       			}
    	       		   }    	    		
    	    	   }
    	       }
    	    	   message ="Saved Successfully!!";   
    	       }
    	    
       }else{
    	   boolean flagg = true;
    	   if(cashType.equalsIgnoreCase("SEALED BAG")){
   	    	pstmt = con.prepareStatement(CashVanManagementStatements.GET_SEAL_NO_AMOUNT2);    
    			pstmt.setString(1, sealNo.toUpperCase());    		   
    	   	   	pstmt.setInt(2, systemId);
    	   		pstmt.setInt(3, customerId);
    	   	   	rs= pstmt.executeQuery();
    	   	   	if(rs.next()){
    	   	   	flagg = false;
    	   	   	}
    	   }
   	if( flagg == true ){
   		String stmt = "";
   		if(cashType.equalsIgnoreCase("SEALED BAG")){
   			stmt = CashVanManagementStatements.ISERT_CASH_INWARD_DETAILS;
   		}else{
   			stmt = CashVanManagementStatements.ISERT_CASH_INWARD_DETAILS_UPDATED;
   		}
    pstmt = con.prepareStatement(stmt,Statement.RETURN_GENERATED_KEYS);
   	pstmt.setString(1, inwardMode);
   	//pstmt.setString(2, inwardDate);
   	pstmt.setInt(2, cVSCustId);
   	pstmt.setString(3, sealNo);
	pstmt.setDouble(4, totalAmount);   	   	
   	pstmt.setString(5, cashType);
   	pstmt.setInt(6, customerId);
   	pstmt.setInt(7, systemId);
   	pstmt.setInt(8, userId);
   	int rows = pstmt.executeUpdate();
	
	rs = pstmt.getGeneratedKeys();
    if (rs.next()) {
    	sysGeneratedId = rs.getInt(1);          
    }
       if(rows>0){
    	  if(cashType.equals("CASH")) {
    	   for(int i =0; i<4; i++){
    		   if(i==0){
    			cashCondition = "GOOD";
    			if(oneGoodNo+twoGoodNo+fiveGoodNo+tenGoodNo+twentyGoodNo+fiftyGoodNo+oneHunGoodNo+fiveHunGoodNo+onethGoodNo+twothGoodNo+fivethGoodNo>0){
    			
					long oneGoodNoOld =0;
					long twoGoodNoOld =0;
					long fiveGoodNoOld=0;
					long tenGoodNoOld=0;
					long twentyGoodNoOld=0;
					long fiftyGoodNoOld=0;
					long oneHunGoodNoOld=0;
					long fiveHunGoodNoOld=0;
					long onethGoodNoOld=0;
					long twothGoodNoOld=0;
					long fivethGoodNoOld=0;
				
    				
    			pstmt = con.prepareStatement(CashVanManagementStatements.INSERT_DENOMINATION_DETAILS);
       		   	pstmt.setInt(1, sysGeneratedId);
       		   	
       			pstmt.setLong(2, oneGoodNo);
       			pstmt.setLong(3, twoGoodNo);
       			pstmt.setLong(4, fiveGoodNo);
       			pstmt.setLong(5, tenGoodNo);
       			pstmt.setLong(6, twentyGoodNo);
       		   	pstmt.setLong(7, fiftyGoodNo);
       			pstmt.setLong(8, oneHunGoodNo);
       		   	pstmt.setLong(9, fiveHunGoodNo);
       		   	pstmt.setLong(10, onethGoodNo);
       			pstmt.setLong(11, twothGoodNo); 
       			pstmt.setLong(12, fivethGoodNo); 
       			
       		   	pstmt.setString(13, cashCondition); 
       		    int updatecount = pstmt.executeUpdate();
       		 if(updatecount>0){
	       		    updateVaultTrasit(con,cVSCustId,customerId,systemId,
	       		    		oneGoodNo,twoGoodNo,fiveGoodNo,tenGoodNo,twentyGoodNo,fiftyGoodNo,oneHunGoodNo,fiveHunGoodNo,onethGoodNo,twothGoodNo,fivethGoodNo,
	       		    		oneGoodNoOld,twoGoodNoOld,fiveGoodNoOld,tenGoodNoOld,twentyGoodNoOld,fiftyGoodNoOld,oneHunGoodNoOld,fiveHunGoodNoOld,onethGoodNoOld,twothGoodNoOld,fivethGoodNoOld,
	       		    		userId,"Inward");
	       		    }
    			}
    		   }
    		   else if(i==1){
       			cashCondition = "BAD";
    			if(oneBadNo+twoBadNo+fiveBadNo+tenBadNo+twentyBadNo+fiftyBadNo+oneHunBadNo+fiveHunBadNo+onethBadNo+twothBadNo+fivethBadNo>0){
       			pstmt = con.prepareStatement(CashVanManagementStatements.INSERT_DENOMINATION_DETAILS);
                pstmt.setInt(1, sysGeneratedId);
       		   	
       			pstmt.setLong(2, oneBadNo);
       			pstmt.setLong(3, twoBadNo);
       			pstmt.setLong(4, fiveBadNo);
       			pstmt.setLong(5, tenBadNo);
       			pstmt.setLong(6, twentyBadNo);
       		   	pstmt.setLong(7, fiftyBadNo);
       			pstmt.setLong(8, oneHunBadNo);
       		   	pstmt.setLong(9, fiveHunBadNo);
       		   	pstmt.setLong(10, onethBadNo);
       			pstmt.setLong(11, twothBadNo); 
       			pstmt.setLong(12, fivethBadNo); 
       			
       		   	pstmt.setString(13, cashCondition); 
          		  pstmt.executeUpdate();
       			}
       		   }
    		   else if(i==2){
       			cashCondition = "SOILED";
    			if(oneSoiledNo+twoSoiledNo+fiveSoiledNo+tenSoiledNo+twentySoiledNo+fiftySoiledNo+oneHunSoiledNo+fiveHunSoiledNo+onethSoiledNo+twothSoiledNo+fivethSoiledNo>0){
       			pstmt = con.prepareStatement(CashVanManagementStatements.INSERT_DENOMINATION_DETAILS);
       		    pstmt.setInt(1, sysGeneratedId);
    		   	
    			pstmt.setLong(2, oneSoiledNo);
    			pstmt.setLong(3, twoSoiledNo);
    			pstmt.setLong(4, fiveSoiledNo);
    			pstmt.setLong(5, tenSoiledNo);
    			pstmt.setLong(6, twentySoiledNo);
    		   	pstmt.setLong(7, fiftySoiledNo);
    			pstmt.setLong(8, oneHunSoiledNo);
    		   	pstmt.setLong(9, fiveHunSoiledNo);
    		   	pstmt.setLong(10, onethSoiledNo);
    			pstmt.setLong(11, twothSoiledNo); 
    			pstmt.setLong(12, fivethSoiledNo); 
    			
    		   	pstmt.setString(13, cashCondition); 
          		  pstmt.executeUpdate();
       			}
       		   }
    		   else if(i==3){
       			cashCondition = "COUNTERFIET";
    			if(oneCounterNo+twoCounterNo+fiveCounterNo+tenCounterNo+twentyCounterNo+fiftyCounterNo+oneHunCounterNo+fiveHunCounterNo+onethCounterNo+twothCounterNo+fivethCounterNo>0){
       			pstmt = con.prepareStatement(CashVanManagementStatements.INSERT_DENOMINATION_DETAILS);
                pstmt.setInt(1, sysGeneratedId);
    		   	
    			pstmt.setLong(2, oneCounterNo);
    			pstmt.setLong(3, twoCounterNo);
    			pstmt.setLong(4, fiveCounterNo);
    			pstmt.setLong(5, tenCounterNo);
    			pstmt.setLong(6, twentyCounterNo);
    		   	pstmt.setLong(7, fiftyCounterNo);
    			pstmt.setLong(8, oneHunCounterNo);
    		   	pstmt.setLong(9, fiveHunCounterNo);
    		   	pstmt.setLong(10, onethCounterNo);
    			pstmt.setLong(11, twothCounterNo); 
    			pstmt.setLong(12, fivethCounterNo); 
    			
    		   	pstmt.setString(13, cashCondition);
          		  pstmt.executeUpdate();
       			}
       		   }
    	   }
       }
    	   message ="Saved Successfully!!";   
       }
       }else{
    	   message ="Seal No Is Already Existed";     
       }
}
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        DBConnection.releaseConnectionToDB(con, pstmt, rs);
    }
    return message;
}

public JSONArray getCashInwardDetails(int inwardId ) {
    JSONArray jsonArray = new JSONArray();

    Connection con = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    try {
        int count = 0;
        
        long fivethGoodNo = 0;  
        long twothGoodNo = 0;  
        long onethGoodNo = 0;
        long fiveHunGoodNo=0;
        long oneHunGoodNo=0;
        long fiftyGoodNo=0;
        long twentyGoodNo=0;
        long tenGoodNo=0;
        long fiveGoodNo=0;
        long twoGoodNo=0;
        long oneGoodNo=0;
       
        long fivethBadNo = 0;  
        long twothBadNo = 0;
        long onethBadNo = 0;
        long fiveHunBadNo=0;
        long oneHunBadNo=0;
        long fiftyBadNo=0;
        long twentyBadNo=0;
        long tenBadNo=0;
        long fiveBadNo=0;
        long twoBadNo=0;
        long oneBadNo=0;

        long fivethSoiledNo = 0;  
        long twothSoiledNo = 0;
        long onethSoiledNo = 0;
        long fiveHunSoiledNo=0;
        long oneHunSoiledNo=0;
        long fiftySoiledNo=0;
        long twentySoiledNo=0;
        long tenSoiledNo=0;
        long fiveSoiledNo=0;
        long twoSoiledNo=0;
        long oneSoiledNo=0;

        long fivethCounterNo = 0;  
        long twothCounterNo = 0;
        long onethCounterNo = 0;
        long fiveHunCounterNo=0;
        long oneHunCounterNo=0; 
        long fiftyCounterNo=0;
        long twentyCounterNo=0;
        long tenCounterNo=0;
        long fiveCounterNo=0;
        long twoCounterNo=0;
        long oneCounterNo=0;
        
        
        JSONObject jsonObject=new JSONObject();
        con = DBConnection.getConnectionToDB("AMS");
        pstmt = con.prepareStatement(CashVanManagementStatements.GET_DENOMINATION_DETAILS);      
        pstmt.setInt(1, inwardId);
       
        rs = pstmt.executeQuery();
        while (rs.next()) {
            count++;  
          

            if(rs.getString("CASH_CONDITION").equalsIgnoreCase("GOOD")){
            fivethGoodNo = rs.getLong("DENOM_5000");  
		    twothGoodNo = rs.getLong("DENOM_2000");  
            onethGoodNo = rs.getLong("DENOM_1000");
            fiveHunGoodNo=rs.getLong("DENOM_500");
            oneHunGoodNo=rs.getLong("DENOM_100"); 
            fiftyGoodNo=rs.getLong("DENOM_50");
            twentyGoodNo=rs.getLong("DENOM_20");
            tenGoodNo=rs.getLong("DENOM_10");
            fiveGoodNo=rs.getLong("DENOM_5");
            twoGoodNo=rs.getLong("DENOM_2");
            oneGoodNo=rs.getLong("DENOM_1");
            }else if(rs.getString("CASH_CONDITION").equalsIgnoreCase("BAD")){
               fivethBadNo = rs.getLong("DENOM_5000");  
               twothBadNo = rs.getLong("DENOM_2000");  
               onethBadNo = rs.getLong("DENOM_1000");
               fiveHunBadNo=rs.getLong("DENOM_500");
               oneHunBadNo=rs.getLong("DENOM_100");
               fiftyBadNo=rs.getLong("DENOM_50");
               twentyBadNo=rs.getLong("DENOM_20");
               tenBadNo=rs.getLong("DENOM_10");
               fiveBadNo=rs.getLong("DENOM_5");
               twoBadNo=rs.getLong("DENOM_2");
               oneBadNo=rs.getLong("DENOM_1");
            }else if(rs.getString("CASH_CONDITION").equalsIgnoreCase("SOILED")){
            	 fivethSoiledNo = rs.getLong("DENOM_5000");  
                 twothSoiledNo = rs.getLong("DENOM_2000");  
                 onethSoiledNo = rs.getLong("DENOM_1000");
                 fiveHunSoiledNo=rs.getLong("DENOM_500");
                 oneHunSoiledNo=rs.getLong("DENOM_100");
                 fiftySoiledNo=rs.getLong("DENOM_50");
                 twentySoiledNo=rs.getLong("DENOM_20");
                 tenSoiledNo=rs.getLong("DENOM_10");
                 fiveSoiledNo=rs.getLong("DENOM_5");
                 twoSoiledNo=rs.getLong("DENOM_2");
                 oneSoiledNo=rs.getLong("DENOM_1");
            } else if(rs.getString("CASH_CONDITION").equalsIgnoreCase("COUNTERFIET")){
            	 fivethCounterNo = rs.getLong("DENOM_5000");  
                 twothCounterNo = rs.getLong("DENOM_2000");  
                 onethCounterNo = rs.getLong("DENOM_1000");
                 fiveHunCounterNo=rs.getLong("DENOM_500");
                 oneHunCounterNo=rs.getLong("DENOM_100");
                 fiftyCounterNo=rs.getLong("DENOM_50");
                 twentyCounterNo=rs.getLong("DENOM_20");
                 tenCounterNo=rs.getLong("DENOM_10");
                 fiveCounterNo=rs.getLong("DENOM_5");
                 twoCounterNo=rs.getLong("DENOM_2");
                 oneCounterNo=rs.getLong("DENOM_1");
                  
            }
           
        }
        jsonArray = new JSONArray();
        	
        
        jsonObject = new JSONObject();
    	
    	jsonObject.put( "DenominationDataIndex",5000);
        jsonObject.put("GoodNoOfNotesDataIndex",fivethGoodNo);
        jsonObject.put("GoodValueDataIndex",fivethGoodNo*5000);
        jsonObject.put("BadNoOfNotesDataIndex",fivethBadNo);
        jsonObject.put("BadValueDataIndex",fivethBadNo*5000);
        jsonObject.put("SoiledNoOfNotesDataIndex",fivethSoiledNo);
        jsonObject.put("SoiledValueDataIndex",fivethSoiledNo*5000);
        jsonObject.put("CounterfeitNoOfNotesDataIndex",fivethCounterNo);
        jsonObject.put("CounterfeitValueDataIndex",fivethCounterNo*5000);
        jsonObject.put("TotalAmountDataIndex",fivethGoodNo*5000+fivethBadNo*5000+fivethSoiledNo*5000+fivethCounterNo*5000);

        jsonArray.put(jsonObject)	;
        
        jsonObject = new JSONObject();
        	
        	jsonObject.put( "DenominationDataIndex",2000);
            jsonObject.put("GoodNoOfNotesDataIndex",twothGoodNo);
            jsonObject.put("GoodValueDataIndex",twothGoodNo*2000);
            jsonObject.put("BadNoOfNotesDataIndex",twothBadNo);
            jsonObject.put("BadValueDataIndex",twothBadNo*2000);
            jsonObject.put("SoiledNoOfNotesDataIndex",twothSoiledNo);
            jsonObject.put("SoiledValueDataIndex",twothSoiledNo*2000);
            jsonObject.put("CounterfeitNoOfNotesDataIndex",twothCounterNo);
            jsonObject.put("CounterfeitValueDataIndex",twothCounterNo*2000);
            jsonObject.put("TotalAmountDataIndex",twothGoodNo*2000+twothBadNo*2000+twothSoiledNo*2000+twothCounterNo*2000);

            jsonArray.put(jsonObject)	;
        	
        
 jsonObject = new JSONObject();
        	
        	jsonObject.put( "DenominationDataIndex",1000);
            jsonObject.put("GoodNoOfNotesDataIndex",onethGoodNo);
            jsonObject.put("GoodValueDataIndex",onethGoodNo*1000);
            jsonObject.put("BadNoOfNotesDataIndex",onethBadNo);
            jsonObject.put("BadValueDataIndex",onethBadNo*1000);
            jsonObject.put("SoiledNoOfNotesDataIndex",onethSoiledNo);
            jsonObject.put("SoiledValueDataIndex",onethSoiledNo*1000);
            jsonObject.put("CounterfeitNoOfNotesDataIndex",onethCounterNo);
            jsonObject.put("CounterfeitValueDataIndex",onethCounterNo*1000);
            jsonObject.put("TotalAmountDataIndex",onethGoodNo*1000+onethBadNo*1000+onethSoiledNo*1000+onethCounterNo*1000);

            jsonArray.put(jsonObject)	;
            
            
 jsonObject = new JSONObject();
        	
        	jsonObject.put( "DenominationDataIndex",500);
            jsonObject.put("GoodNoOfNotesDataIndex",fiveHunGoodNo);
            jsonObject.put("GoodValueDataIndex",fiveHunGoodNo*500);
            jsonObject.put("BadNoOfNotesDataIndex",fiveHunBadNo);
            jsonObject.put("BadValueDataIndex",fiveHunBadNo*500);
            jsonObject.put("SoiledNoOfNotesDataIndex",fiveHunSoiledNo);
            jsonObject.put("SoiledValueDataIndex",fiveHunSoiledNo*500);
            jsonObject.put("CounterfeitNoOfNotesDataIndex",fiveHunCounterNo);
            jsonObject.put("CounterfeitValueDataIndex",fiveHunCounterNo*500);
            jsonObject.put("TotalAmountDataIndex",fiveHunGoodNo*500+fiveHunBadNo*500+fiveHunSoiledNo*500+fiveHunCounterNo*500);

            jsonArray.put(jsonObject)	;
            
            jsonObject = new JSONObject();
                   	
                   	jsonObject.put( "DenominationDataIndex",100);
                       jsonObject.put("GoodNoOfNotesDataIndex",oneHunGoodNo);
                       jsonObject.put("GoodValueDataIndex",oneHunGoodNo*100);
                       jsonObject.put("BadNoOfNotesDataIndex",oneHunBadNo);
                       jsonObject.put("BadValueDataIndex",oneHunBadNo*100);
                       jsonObject.put("SoiledNoOfNotesDataIndex",oneHunSoiledNo);
                       jsonObject.put("SoiledValueDataIndex",oneHunSoiledNo*100);
                       jsonObject.put("CounterfeitNoOfNotesDataIndex",oneHunCounterNo);
                       jsonObject.put("CounterfeitValueDataIndex",oneHunCounterNo*100);
                       jsonObject.put("TotalAmountDataIndex",oneHunGoodNo*100+oneHunBadNo*100+oneHunSoiledNo*100+oneHunCounterNo*100);

                       jsonArray.put(jsonObject)	;   
                       
                       
                       jsonObject = new JSONObject();
                      	
                      	jsonObject.put( "DenominationDataIndex",50);
                          jsonObject.put("GoodNoOfNotesDataIndex",fiftyGoodNo);
                          jsonObject.put("GoodValueDataIndex",fiftyGoodNo*50);
                          jsonObject.put("BadNoOfNotesDataIndex",fiftyBadNo);
                          jsonObject.put("BadValueDataIndex",fiftyBadNo*50);
                          jsonObject.put("SoiledNoOfNotesDataIndex",fiftySoiledNo);
                          jsonObject.put("SoiledValueDataIndex",fiftySoiledNo*50);
                          jsonObject.put("CounterfeitNoOfNotesDataIndex",fiftyCounterNo);
                          jsonObject.put("CounterfeitValueDataIndex",fiftyCounterNo*50);
                          jsonObject.put("TotalAmountDataIndex",fiftyGoodNo*50+fiftyBadNo*50+fiftySoiledNo*50+fiftyCounterNo*50);

                          jsonArray.put(jsonObject)	;                
                       
                          jsonObject = new JSONObject();
                        	
                        	jsonObject.put( "DenominationDataIndex",20);
                            jsonObject.put("GoodNoOfNotesDataIndex",twentyGoodNo);
                            jsonObject.put("GoodValueDataIndex",twentyGoodNo*20);
                            jsonObject.put("BadNoOfNotesDataIndex",twentyBadNo);
                            jsonObject.put("BadValueDataIndex",twentyBadNo*20);
                            jsonObject.put("SoiledNoOfNotesDataIndex",twentySoiledNo);
                            jsonObject.put("SoiledValueDataIndex",twentySoiledNo*20);
                            jsonObject.put("CounterfeitNoOfNotesDataIndex",twentyCounterNo);
                            jsonObject.put("CounterfeitValueDataIndex",twentyCounterNo*20);
                            jsonObject.put("TotalAmountDataIndex",twentyGoodNo*20+twentyBadNo*20+twentySoiledNo*20+twentyCounterNo*20);

                            jsonArray.put(jsonObject)	;  
                            
                            jsonObject = new JSONObject();
                          	
                          	jsonObject.put( "DenominationDataIndex",10);
                              jsonObject.put("GoodNoOfNotesDataIndex",tenGoodNo);
                              jsonObject.put("GoodValueDataIndex",tenGoodNo*10);
                              jsonObject.put("BadNoOfNotesDataIndex",tenBadNo);
                              jsonObject.put("BadValueDataIndex",tenBadNo*10);
                              jsonObject.put("SoiledNoOfNotesDataIndex",tenSoiledNo);
                              jsonObject.put("SoiledValueDataIndex",tenSoiledNo*10);
                              jsonObject.put("CounterfeitNoOfNotesDataIndex",tenCounterNo);
                              jsonObject.put("CounterfeitValueDataIndex",tenCounterNo*10);
                              jsonObject.put("TotalAmountDataIndex",tenGoodNo*10+tenBadNo*10+tenSoiledNo*10+tenCounterNo*10);

                              jsonArray.put(jsonObject)	; 
                              
                              jsonObject = new JSONObject();
                            	
                            	jsonObject.put( "DenominationDataIndex",5);
                                jsonObject.put("GoodNoOfNotesDataIndex",fiveGoodNo);
                                jsonObject.put("GoodValueDataIndex",fiveGoodNo*5);
                                jsonObject.put("BadNoOfNotesDataIndex",fiveBadNo);
                                jsonObject.put("BadValueDataIndex",fiveBadNo*5);
                                jsonObject.put("SoiledNoOfNotesDataIndex",fiveSoiledNo);
                                jsonObject.put("SoiledValueDataIndex",fiveSoiledNo*5);
                                jsonObject.put("CounterfeitNoOfNotesDataIndex",fiveCounterNo);
                                jsonObject.put("CounterfeitValueDataIndex",fiveCounterNo*5);
                                jsonObject.put("TotalAmountDataIndex",fiveGoodNo*5+fiveBadNo*5+fiveSoiledNo*5+fiveCounterNo*5);

                                jsonArray.put(jsonObject)	;  
                                
                                jsonObject = new JSONObject();
                            	
                            	jsonObject.put( "DenominationDataIndex",2);
                                jsonObject.put("GoodNoOfNotesDataIndex",twoGoodNo);
                                jsonObject.put("GoodValueDataIndex",twoGoodNo*2);
                                jsonObject.put("BadNoOfNotesDataIndex",twoBadNo);
                                jsonObject.put("BadValueDataIndex",twoBadNo*2);
                                jsonObject.put("SoiledNoOfNotesDataIndex",twoSoiledNo);
                                jsonObject.put("SoiledValueDataIndex",twoSoiledNo*2);
                                jsonObject.put("CounterfeitNoOfNotesDataIndex",twoCounterNo);
                                jsonObject.put("CounterfeitValueDataIndex",twoCounterNo*2);
                                jsonObject.put("TotalAmountDataIndex",twoGoodNo*2+twoBadNo*2+twoSoiledNo*2+twoCounterNo*2);

                                jsonArray.put(jsonObject)	;  
                                
                                jsonObject = new JSONObject();
                            	
                            	jsonObject.put( "DenominationDataIndex",1);
                                jsonObject.put("GoodNoOfNotesDataIndex",oneGoodNo);
                                jsonObject.put("GoodValueDataIndex",oneGoodNo*1);
                                jsonObject.put("BadNoOfNotesDataIndex",oneBadNo);
                                jsonObject.put("BadValueDataIndex",oneBadNo*1);
                                jsonObject.put("SoiledNoOfNotesDataIndex",oneSoiledNo);
                                jsonObject.put("SoiledValueDataIndex",oneSoiledNo*1);
                                jsonObject.put("CounterfeitNoOfNotesDataIndex",oneCounterNo);
                                jsonObject.put("CounterfeitValueDataIndex",oneCounterNo*1);
                                jsonObject.put("TotalAmountDataIndex",oneGoodNo*1+oneBadNo*1+oneSoiledNo*1+oneCounterNo*1);

                                jsonArray.put(jsonObject)	;  
        
        
        
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        DBConnection.releaseConnectionToDB(con, pstmt, rs);
    }
    return jsonArray;
}

public JSONArray getVaultInventory(int systemId,int custId){
    Connection con = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    PreparedStatement pstmt3 = null;
    ResultSet rs3 = null;
    JSONObject  JsonObject= new JSONObject();
    JSONArray JsonArray = new JSONArray();
 try {
	
	 double consolidateAmount = 0.0;
	 double availableBanlance = 0.0;
	 double sealedAmount = 0.0;
	 double jewAmount = 0.0;
	 double checkAmount = 0.0;
	 double forexAmount = 0.0;
	 double tottal = 0.0;
	 String customerName="";
	 int customerId = 0;
	 
	 con = DBConnection.getConnectionToDB("AMS");
	 
	 String innerList1 = "";
	 String innerList2 = "";
	 String innerList3 = "";
	 String innerList4 = "";
	 
	 pstmt3 = con.prepareStatement(CashVanManagementStatements.GET_VAULT_INVENTORY_FOR_SEALED_BAG_TYPE_INNER_QUERY);
	 pstmt3.setInt(1, systemId);
     pstmt3.setInt(2, custId);
     rs3=pstmt3.executeQuery();	
	 while(rs3.next()){			
		 innerList1= innerList1+"'"+rs3.getString("SEAL_NO")+"'"+" , ";
	 }
	 innerList1 = innerList1.substring(0, innerList1.lastIndexOf(","));
	
	 pstmt3 = con.prepareStatement(CashVanManagementStatements.GET_VAULT_INVENTORY_FOR_SEALED_BAG_TYPE_INNER_QUERYY2);
	 pstmt3.setInt(1, systemId);
     pstmt3.setInt(2, custId);
     rs3=pstmt3.executeQuery();	
	 while(rs3.next()){			
		 innerList2= innerList2+"'"+rs3.getString("SEAL_NO")+"'"+" , ";
	 }
	 innerList2 = innerList2.substring(0, innerList2.lastIndexOf(","));
	 
	 pstmt3 = con.prepareStatement(CashVanManagementStatements.GET_VAULT_INVENTORY_FOR_SEALED_BAG_TYPE_INNER_QUERY3);
	 pstmt3.setInt(1, systemId);
     pstmt3.setInt(2, custId);
     rs3=pstmt3.executeQuery();	
	 while(rs3.next()){			
		 innerList3= innerList3+"'"+rs3.getString("SEAL_NO")+"'"+" , ";
	 }
	 innerList3 = innerList3.substring(0, innerList3.lastIndexOf(","));
	 
	 pstmt3 = con.prepareStatement(CashVanManagementStatements.GET_VAULT_INVENTORY_FOR_SEALED_BAG_TYPE_INNER_QUERY4);
	 pstmt3.setInt(1, systemId);
     pstmt3.setInt(2, custId);
     rs3=pstmt3.executeQuery();	
	 while(rs3.next()){			
		 innerList4= innerList4+"'"+rs3.getString("SEAL_NO")+"'"+" , ";
	 }
	 innerList4 = innerList4.substring(0, innerList4.lastIndexOf(","));

	 DBConnection.releaseConnectionToDB(null, pstmt3, rs3);
	 
	 pstmt = con.prepareStatement(CashVanManagementStatements.GET_VAULT_INVENTORY_NEW.replace("a.SEAL_NO IN ( # )", " a.SEAL_NO IN ( "+innerList1+" )" ).replace("j.SEAL_NO IN ( # )", "j.SEAL_NO IN ( "+innerList4+" )").replace("ch.SEAL_NO IN ( # )", "ch.SEAL_NO IN ( "+innerList2+" )").replace("fx.SEAL_NO IN ( # )", "fx.SEAL_NO IN ( "+innerList3+" )"));

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
     pstmt.setInt(13, systemId);
     pstmt.setInt(14, custId);
     pstmt.setInt(15, systemId);  
     pstmt.setInt(16, custId);
     pstmt.setInt(17, systemId);
     pstmt.setInt(18, custId);
     pstmt.setInt(19, systemId);
     pstmt.setInt(20, custId);	
     pstmt.setInt(21, systemId);
     pstmt.setInt(22, custId);	
     
	 rs=pstmt.executeQuery();

	 while(rs.next()){	
		 JsonObject = new JSONObject();
		 
		 customerId = rs.getInt("CVS_CUSTOMER_ID");
		 customerName =  rs.getString("CustomerName");
		 availableBanlance = rs.getDouble("AVAILABLE_BALANCE");
		 consolidateAmount = rs.getDouble("CASH_TOTAL_AMOUNT");
		 sealedAmount = rs.getDouble("SEALED_BAG_TOTAL_AMOUNT");
		 jewAmount =  rs.getDouble("JEW_TOTAL_AMOUNT");
		 checkAmount =  rs.getDouble("CHECK_TOTAL_AMOUNT");
		 forexAmount = rs.getDouble("FOREX_TOTAL_AMOUNT");
		 
    	 JsonObject.put("customerIDindex",customerId);
    	 JsonObject.put("customernameindex",customerName);
    	 
    	 availableBanlance = Double.parseDouble(df.format(availableBanlance));
    	 consolidateAmount = Double.parseDouble(df.format(consolidateAmount));
    	 sealedAmount = Double.parseDouble(df.format(sealedAmount));
    	 jewAmount = Double.parseDouble(df.format(jewAmount));
    	 checkAmount = Double.parseDouble(df.format(checkAmount));
    	 forexAmount = Double.parseDouble(df.format(forexAmount));
    	 
    	 JsonObject.put("availableBalance",availableBanlance);	
	     JsonObject.put("concolidatedcash",consolidateAmount);
	     JsonObject.put("sealedbagcashindex",sealedAmount);	     
	     JsonObject.put("jewellerycashindex",jewAmount);	
	     JsonObject.put("checkcashindex",checkAmount);
	     JsonObject.put("forexcashindex",forexAmount);
	     
	     tottal = consolidateAmount+sealedAmount+jewAmount+checkAmount+forexAmount;
	     JsonObject.put("totalamountindex",tottal);
	     JsonArray.put(JsonObject);	
	}		
		
	
	
} catch (Exception e) {
	e.printStackTrace();
} finally {
   DBConnection.releaseConnectionToDB(con, pstmt, rs);
}
return JsonArray;

}

public JSONArray getCashInwardDetailsSummary(int systemId,int customerId,int cvsCustId ) {

JSONArray jsonArray = new JSONArray();

Connection con = null;
PreparedStatement pstmt = null;
ResultSet rs = null;
try {
    int count = 0;
    
    long fivethGoodNo = 0;  
    long twothGoodNo = 0;  
    long onethGoodNo = 0;
    long fiveHunGoodNo=0;
    long oneHunGoodNo=0;
    long fiftyGoodNo=0;
    long twentyGoodNo=0;
    long tenGoodNo=0;
    long fiveGoodNo=0;
    long twoGoodNo=0;
    long oneGoodNo=0;
    
    
    long fivethBadNo = 0;  
    long twothBadNo = 0;  
    long onethBadNo = 0;
    long fiveHunBadNo=0;
    long oneHunBadNo=0;
    long fiftyBadNo=0;
    long twentyBadNo=0;
    long tenBadNo=0;
    long fiveBadNo=0;
    long twoBadNo=0;
    long oneBadNo=0;


    long fivethSoiledNo = 0;  
    long twothSoiledNo = 0;  
    long onethSoiledNo = 0;
    long fiveHunSoiledNo=0;
    long oneHunSoiledNo=0;
    long fiftySoiledNo=0;
    long twentySoiledNo=0;
    long tenSoiledNo=0;
    long fiveSoiledNo=0;
    long twoSoiledNo=0;
    long oneSoiledNo=0;


    long fivethCounterNo = 0;  
    long twothCounterNo = 0;  
    long onethCounterNo = 0;
    long fiveHunCounterNo=0;
    long oneHunCounterNo=0;
    long fiftyCounterNo=0;
    long twentyCounterNo=0;
    long tenCounterNo=0;
    long fiveCounterNo=0;
    long twoCounterNo=0;
    long oneCounterNo=0;
    
    
    JSONObject jsonObject=new JSONObject();
    con = DBConnection.getConnectionToDB("AMS");
    pstmt = con.prepareStatement(CashVanManagementStatements.GET_DENOMINATION_DETAILS_SUMMARY);      
    pstmt.setInt(1, systemId);
    pstmt.setInt(2, customerId);
    pstmt.setInt(3, cvsCustId);
    pstmt.setInt(4, systemId);
    pstmt.setInt(5, customerId);
    pstmt.setInt(6, cvsCustId);
    pstmt.setInt(7, systemId);
    pstmt.setInt(8, customerId);
    pstmt.setInt(9, cvsCustId);
    rs = pstmt.executeQuery();
    while (rs.next()) {
        count++;  
        if(rs.getString("CASH_CONDITION").equalsIgnoreCase("GOOD")){
        fivethGoodNo = rs.getLong("DENOM_5000");
        twothGoodNo = rs.getLong("DENOM_2000");  
        onethGoodNo = rs.getLong("DENOM_1000");
        fiveHunGoodNo=rs.getLong("DENOM_500");
        oneHunGoodNo=rs.getLong("DENOM_100"); 
        fiftyGoodNo=rs.getLong("DENOM_50");
        twentyGoodNo=rs.getLong("DENOM_20");
        tenGoodNo=rs.getLong("DENOM_10");
        fiveGoodNo=rs.getLong("DENOM_5");
        twoGoodNo=rs.getLong("DENOM_2");
        oneGoodNo=rs.getLong("DENOM_1");
        }else if(rs.getString("CASH_CONDITION").equalsIgnoreCase("BAD")){
        	 fivethBadNo = rs.getLong("DENOM_5000");
             twothBadNo = rs.getLong("DENOM_2000");  
             onethBadNo = rs.getLong("DENOM_1000");
             fiveHunBadNo=rs.getLong("DENOM_500");
             oneHunBadNo=rs.getLong("DENOM_100"); 
             fiftyBadNo=rs.getLong("DENOM_50");
             twentyBadNo=rs.getLong("DENOM_20");
             tenBadNo=rs.getLong("DENOM_10");
             fiveBadNo=rs.getLong("DENOM_5");
             twoBadNo=rs.getLong("DENOM_2");
             oneBadNo=rs.getLong("DENOM_1");
        }else if(rs.getString("CASH_CONDITION").equalsIgnoreCase("SOILED")){
        	 fivethSoiledNo = rs.getLong("DENOM_5000");
             twothSoiledNo = rs.getLong("DENOM_2000");  
             onethSoiledNo = rs.getLong("DENOM_1000");
             fiveHunSoiledNo=rs.getLong("DENOM_500");
             oneHunSoiledNo=rs.getLong("DENOM_100"); 
             fiftySoiledNo=rs.getLong("DENOM_50");
             twentySoiledNo=rs.getLong("DENOM_20");
             tenSoiledNo=rs.getLong("DENOM_10");
             fiveSoiledNo=rs.getLong("DENOM_5");
             twoSoiledNo=rs.getLong("DENOM_2");
             oneSoiledNo=rs.getLong("DENOM_1");
        } else if(rs.getString("CASH_CONDITION").equalsIgnoreCase("COUNTERFIET")){
        	 fivethCounterNo = rs.getLong("DENOM_5000");
             twothCounterNo = rs.getLong("DENOM_2000");  
             onethCounterNo = rs.getLong("DENOM_1000");
             fiveHunCounterNo=rs.getLong("DENOM_500");
             oneHunCounterNo=rs.getLong("DENOM_100"); 
             fiftyCounterNo=rs.getLong("DENOM_50");
             twentyCounterNo=rs.getLong("DENOM_20");
             tenCounterNo=rs.getLong("DENOM_10");
             fiveCounterNo=rs.getLong("DENOM_5");
             twoCounterNo=rs.getLong("DENOM_2");
             oneCounterNo=rs.getLong("DENOM_1");             
        }      
    }
    jsonArray = new JSONArray();
    	
    jsonObject = new JSONObject();
	
	jsonObject.put( "DenominationDataIndex",5000);
    jsonObject.put("GoodNoOfNotesDataIndex",fivethGoodNo);
    jsonObject.put("GoodValueDataIndex",fivethGoodNo*5000);
    jsonObject.put("BadNoOfNotesDataIndex",fivethBadNo);
    jsonObject.put("BadValueDataIndex",fivethBadNo*5000);
    jsonObject.put("SoiledNoOfNotesDataIndex",fivethSoiledNo);
    jsonObject.put("SoiledValueDataIndex",fivethSoiledNo*5000);
    jsonObject.put("CounterfeitNoOfNotesDataIndex",fivethCounterNo);
    jsonObject.put("CounterfeitValueDataIndex",fivethCounterNo*5000);
    jsonObject.put("TotalAmountDataIndex",fivethGoodNo*5000+fivethBadNo*5000+fivethSoiledNo*5000+fivethCounterNo*5000);

    jsonArray.put(jsonObject)	;
    jsonObject = new JSONObject();
    	
    	jsonObject.put( "DenominationDataIndex",2000);
        jsonObject.put("GoodNoOfNotesDataIndex",twothGoodNo);
        jsonObject.put("GoodValueDataIndex",twothGoodNo*2000);
        jsonObject.put("BadNoOfNotesDataIndex",twothBadNo);
        jsonObject.put("BadValueDataIndex",twothBadNo*2000);
        jsonObject.put("SoiledNoOfNotesDataIndex",twothSoiledNo);
        jsonObject.put("SoiledValueDataIndex",twothSoiledNo*2000);
        jsonObject.put("CounterfeitNoOfNotesDataIndex",twothCounterNo);
        jsonObject.put("CounterfeitValueDataIndex",twothCounterNo*2000);
        jsonObject.put("TotalAmountDataIndex",twothGoodNo*2000+twothBadNo*2000+twothSoiledNo*2000+twothCounterNo*2000);

        jsonArray.put(jsonObject)	;
    	
    
jsonObject = new JSONObject();
    	
    	jsonObject.put( "DenominationDataIndex",1000);
        jsonObject.put("GoodNoOfNotesDataIndex",onethGoodNo);
        jsonObject.put("GoodValueDataIndex",onethGoodNo*1000);
        jsonObject.put("BadNoOfNotesDataIndex",onethBadNo);
        jsonObject.put("BadValueDataIndex",onethBadNo*1000);
        jsonObject.put("SoiledNoOfNotesDataIndex",onethSoiledNo);
        jsonObject.put("SoiledValueDataIndex",onethSoiledNo*1000);
        jsonObject.put("CounterfeitNoOfNotesDataIndex",onethCounterNo);
        jsonObject.put("CounterfeitValueDataIndex",onethCounterNo*1000);
        jsonObject.put("TotalAmountDataIndex",onethGoodNo*1000+onethBadNo*1000+onethSoiledNo*1000+onethCounterNo*1000);

        jsonArray.put(jsonObject)	;
        
        
jsonObject = new JSONObject();
    	
    	jsonObject.put( "DenominationDataIndex",500);
        jsonObject.put("GoodNoOfNotesDataIndex",fiveHunGoodNo);
        jsonObject.put("GoodValueDataIndex",fiveHunGoodNo*500);
        jsonObject.put("BadNoOfNotesDataIndex",fiveHunBadNo);
        jsonObject.put("BadValueDataIndex",fiveHunBadNo*500);
        jsonObject.put("SoiledNoOfNotesDataIndex",fiveHunSoiledNo);
        jsonObject.put("SoiledValueDataIndex",fiveHunSoiledNo*500);
        jsonObject.put("CounterfeitNoOfNotesDataIndex",fiveHunCounterNo);
        jsonObject.put("CounterfeitValueDataIndex",fiveHunCounterNo*500);
        jsonObject.put("TotalAmountDataIndex",fiveHunGoodNo*500+fiveHunBadNo*500+fiveHunSoiledNo*500+fiveHunCounterNo*500);

        jsonArray.put(jsonObject)	;
        
                   jsonObject = new JSONObject();               	
               	   jsonObject.put( "DenominationDataIndex",100);
                   jsonObject.put("GoodNoOfNotesDataIndex",oneHunGoodNo);
                   jsonObject.put("GoodValueDataIndex",oneHunGoodNo*100);
                   jsonObject.put("BadNoOfNotesDataIndex",oneHunBadNo);
                   jsonObject.put("BadValueDataIndex",oneHunBadNo*100);
                   jsonObject.put("SoiledNoOfNotesDataIndex",oneHunSoiledNo);
                   jsonObject.put("SoiledValueDataIndex",oneHunSoiledNo*100);
                   jsonObject.put("CounterfeitNoOfNotesDataIndex",oneHunCounterNo);
                   jsonObject.put("CounterfeitValueDataIndex",oneHunCounterNo*100);
                   jsonObject.put("TotalAmountDataIndex",oneHunGoodNo*100+oneHunBadNo*100+oneHunSoiledNo*100+oneHunCounterNo*100);
                   jsonArray.put(jsonObject); 
                   
                   
                   jsonObject = new JSONObject();               	
               	   jsonObject.put( "DenominationDataIndex",50);
                   jsonObject.put("GoodNoOfNotesDataIndex",fiftyGoodNo);
                   jsonObject.put("GoodValueDataIndex",fiftyGoodNo*50);
                   jsonObject.put("BadNoOfNotesDataIndex",fiftyBadNo);
                   jsonObject.put("BadValueDataIndex",fiftyBadNo*50);
                   jsonObject.put("SoiledNoOfNotesDataIndex",fiftySoiledNo);
                   jsonObject.put("SoiledValueDataIndex",fiftySoiledNo*50);
                   jsonObject.put("CounterfeitNoOfNotesDataIndex",fiftyCounterNo);
                   jsonObject.put("CounterfeitValueDataIndex",fiftyCounterNo*50);
                   jsonObject.put("TotalAmountDataIndex",fiftyGoodNo*50+fiftyBadNo*50+fiftySoiledNo*50+fiftyCounterNo*50);
                   jsonArray.put(jsonObject); 
                   
                   
                   jsonObject = new JSONObject();               	
               	   jsonObject.put( "DenominationDataIndex",20);
                   jsonObject.put("GoodNoOfNotesDataIndex",twentyGoodNo);
                   jsonObject.put("GoodValueDataIndex",twentyGoodNo*20);
                   jsonObject.put("BadNoOfNotesDataIndex",twentyBadNo);
                   jsonObject.put("BadValueDataIndex",twentyBadNo*20);
                   jsonObject.put("SoiledNoOfNotesDataIndex",twentySoiledNo);
                   jsonObject.put("SoiledValueDataIndex",twentySoiledNo*20);
                   jsonObject.put("CounterfeitNoOfNotesDataIndex",twentyCounterNo);
                   jsonObject.put("CounterfeitValueDataIndex",twentyCounterNo*20);
                   jsonObject.put("TotalAmountDataIndex",twentyGoodNo*20+twentyBadNo*20+twentySoiledNo*20+twentyCounterNo*20);
                   jsonArray.put(jsonObject);   
                   
                   
                   jsonObject = new JSONObject();               	
               	   jsonObject.put( "DenominationDataIndex",10);
                   jsonObject.put("GoodNoOfNotesDataIndex",tenGoodNo);
                   jsonObject.put("GoodValueDataIndex",tenGoodNo*10);
                   jsonObject.put("BadNoOfNotesDataIndex",tenBadNo);
                   jsonObject.put("BadValueDataIndex",tenBadNo*10);
                   jsonObject.put("SoiledNoOfNotesDataIndex",tenSoiledNo);
                   jsonObject.put("SoiledValueDataIndex",tenSoiledNo*10);
                   jsonObject.put("CounterfeitNoOfNotesDataIndex",tenCounterNo);
                   jsonObject.put("CounterfeitValueDataIndex",tenCounterNo*10);
                   jsonObject.put("TotalAmountDataIndex",tenGoodNo*10+tenBadNo*10+tenSoiledNo*10+tenCounterNo*10);
                   jsonArray.put(jsonObject);   
                   
                   
                   jsonObject = new JSONObject();               	
               	   jsonObject.put( "DenominationDataIndex",5);
                   jsonObject.put("GoodNoOfNotesDataIndex",fiveGoodNo);
                   jsonObject.put("GoodValueDataIndex",fiveGoodNo*5);
                   jsonObject.put("BadNoOfNotesDataIndex",fiveBadNo);
                   jsonObject.put("BadValueDataIndex",fiveBadNo*5);
                   jsonObject.put("SoiledNoOfNotesDataIndex",fiveSoiledNo);
                   jsonObject.put("SoiledValueDataIndex",fiveSoiledNo*5);
                   jsonObject.put("CounterfeitNoOfNotesDataIndex",fiveCounterNo);
                   jsonObject.put("CounterfeitValueDataIndex",fiveCounterNo*5);
                   jsonObject.put("TotalAmountDataIndex",fiveGoodNo*5+fiveBadNo*5+fiveSoiledNo*5+fiveCounterNo*5);
                   jsonArray.put(jsonObject);  
                   
                   jsonObject = new JSONObject();               	
               	   jsonObject.put( "DenominationDataIndex",2);
                   jsonObject.put("GoodNoOfNotesDataIndex",twoGoodNo);
                   jsonObject.put("GoodValueDataIndex",twoGoodNo*2);
                   jsonObject.put("BadNoOfNotesDataIndex",twoBadNo);
                   jsonObject.put("BadValueDataIndex",twoBadNo*2);
                   jsonObject.put("SoiledNoOfNotesDataIndex",twoSoiledNo);
                   jsonObject.put("SoiledValueDataIndex",twoSoiledNo*2);
                   jsonObject.put("CounterfeitNoOfNotesDataIndex",twoCounterNo);
                   jsonObject.put("CounterfeitValueDataIndex",twoCounterNo*2);
                   jsonObject.put("TotalAmountDataIndex",twoGoodNo*2+twoBadNo*2+twoSoiledNo*2+twoCounterNo*2);
                   jsonArray.put(jsonObject);
                   
                   jsonObject = new JSONObject();               	
               	   jsonObject.put( "DenominationDataIndex",1);
                   jsonObject.put("GoodNoOfNotesDataIndex",oneGoodNo);
                   jsonObject.put("GoodValueDataIndex",oneGoodNo*1);
                   jsonObject.put("BadNoOfNotesDataIndex",oneBadNo);
                   jsonObject.put("BadValueDataIndex",oneBadNo*1);
                   jsonObject.put("SoiledNoOfNotesDataIndex",oneSoiledNo);
                   jsonObject.put("SoiledValueDataIndex",oneSoiledNo*1);
                   jsonObject.put("CounterfeitNoOfNotesDataIndex",oneCounterNo);
                   jsonObject.put("CounterfeitValueDataIndex",oneCounterNo*1);
                   jsonObject.put("TotalAmountDataIndex",oneGoodNo*1+oneBadNo*1+oneSoiledNo*1+oneCounterNo*1);
                   jsonArray.put(jsonObject);  
                   
    
} catch (Exception e) {
    e.printStackTrace();
} finally {
    DBConnection.releaseConnectionToDB(con, pstmt, rs);
}
return jsonArray;
}

public String updateVaultTrasit(Connection con,int cVSCustId,int customerId,int systemId,
		long oneGoodNo,long twoGoodNo,long fiveGoodNo,long tenGoodNo,long twentyGoodNo,long fiftyGoodNo,long oneHunGoodNo,long fiveHunGoodNo,long onethGoodNo,long twothGoodNo,long fivethGoodNo,
   		long oneGoodNoOld,long twoGoodNoOld,long fiveGoodNoOld,long tenGoodNoOld,long twentyGoodNoOld,long fiftyGoodNoOld,long oneHunGoodNoOld,long fiveHunGoodNoOld,long onethGoodNoOld,long twothGoodNoOld,long fivethGoodNoOld,

		int userId,String type){
	String message = "";
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	
	try {
		if(type.equals("Inward")){
		pstmt = con.prepareStatement(CashVanManagementStatements.CHECK_CVS_CUSTOMER);
		pstmt.setInt(1,cVSCustId);
		pstmt.setInt(2,systemId);
		pstmt.setInt(3,customerId);
		rs = pstmt.executeQuery();
		if(rs.next()){
			oneGoodNo = oneGoodNo+(rs.getLong("DENOM_1")-oneGoodNoOld);
			twoGoodNo = twoGoodNo+(rs.getLong("DENOM_2")-twoGoodNoOld);
			fiveGoodNo = fiveGoodNo+(rs.getLong("DENOM_5")-fiveGoodNoOld);
			tenGoodNo = tenGoodNo+(rs.getLong("DENOM_10")-tenGoodNoOld);
			twentyGoodNo = twentyGoodNo+(rs.getLong("DENOM_20")-twentyGoodNoOld);
			fiftyGoodNo = fiftyGoodNo+(rs.getLong("DENOM_50")-fiftyGoodNoOld);
			oneHunGoodNo = oneHunGoodNo+(rs.getLong("DENOM_100")-oneHunGoodNoOld);
			fiveHunGoodNo = fiveHunGoodNo+(rs.getLong("DENOM_500")-fiveHunGoodNoOld);
			onethGoodNo = onethGoodNo+(rs.getLong("DENOM_1000")-onethGoodNoOld);
			twothGoodNo = twothGoodNo+(rs.getLong("DENOM_2000")-twothGoodNoOld);
			fivethGoodNo = fivethGoodNo+(rs.getLong("DENOM_5000")-fivethGoodNoOld);
			pstmt = con.prepareStatement(CashVanManagementStatements.UPDATE_INWARD_DENOMINATIONS);
			pstmt.setLong(1,oneGoodNo);
			pstmt.setLong(2,twoGoodNo);
			pstmt.setLong(3,fiveGoodNo);
			pstmt.setLong(4,tenGoodNo);
			pstmt.setLong(5,twentyGoodNo);
			pstmt.setLong(6,fiftyGoodNo);
			pstmt.setLong(7,oneHunGoodNo);
			pstmt.setLong(8,fiveHunGoodNo);
			pstmt.setLong(9,onethGoodNo);
			pstmt.setLong(10,twothGoodNo);
			pstmt.setLong(11,fivethGoodNo);
			
			pstmt.setInt(12,userId);			
			pstmt.setInt(13,systemId);
			pstmt.setInt(14,customerId);
			pstmt.setInt(15,cVSCustId);
			int i = pstmt.executeUpdate();
			if(i>0){
				message = "updated";
			}
		}else{
			pstmt = con.prepareStatement(CashVanManagementStatements.INSERT_INWARD_DENOMINATIONS);
			pstmt.setLong(1,oneGoodNo);
			pstmt.setLong(2,twoGoodNo);
			pstmt.setLong(3,fiveGoodNo);
			pstmt.setLong(4,tenGoodNo);
			pstmt.setLong(5,twentyGoodNo);
			pstmt.setLong(6,fiftyGoodNo);
			pstmt.setLong(7,oneHunGoodNo);
			pstmt.setLong(8,fiveHunGoodNo);
			pstmt.setLong(9,onethGoodNo);
			pstmt.setLong(10,twothGoodNo);
			pstmt.setLong(11,fivethGoodNo);
			
			pstmt.setInt(12,userId);			
			pstmt.setInt(13,systemId);
			pstmt.setInt(14,customerId);
			pstmt.setInt(15,cVSCustId);
			int i = pstmt.executeUpdate();
			if(i>0){
				message = "inserted";
			}
		}
		}if(type.equals("Dispense")){
			
		}
	} catch (SQLException e) {
		e.printStackTrace();
	}
	finally{
		 DBConnection.releaseConnectionToDB(null, pstmt, rs);
	}
	
	
	
	return message;
}

public JSONArray getGridForSummaryForCashDispense(int systemId,int custId){
    Connection con = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    JSONObject  JsonObject= null;
    JSONArray JsonArray = new JSONArray();
    double cashdeltot =0.0;
    double cashPicktot = 0.0;
    double atmReptot = 0.0;
    double tot = 0.0;
   String preTripSheetNo ="";
  String  currentTripSheetNo = "";
  String tripSheetNo="";
  String date = "";
  String routeName = "";
  
 try {
	
	 con = DBConnection.getConnectionToDB("AMS");
	 pstmt = con.prepareStatement(CashVanManagementStatements.GET_SUMMARY_FOR_CASH_DISPENSE);
     pstmt.setInt(1, systemId);
     pstmt.setInt(2, custId);
    
	 rs=pstmt.executeQuery();
	 int count = 0;
	 while(rs.next()){
if(rs.getRow()==1){
currentTripSheetNo = rs.getString("TRIP_SHEET_NO");
preTripSheetNo = rs.getString("TRIP_SHEET_NO");
JsonObject = new JSONObject();	

count++;


if(rs.getString("CUSTOMER_TYPE").equals("ATM Replenishment")){
	atmReptot =atmReptot+ rs.getDouble("TOTAL_AMOUNT");
}
if(rs.getString("CUSTOMER_TYPE").equals("Cash Delivery")){
	cashdeltot =cashdeltot+ rs.getDouble("TOTAL_AMOUNT");
}
if(rs.getString("CUSTOMER_TYPE").equals("Cash pickup")){
	cashPicktot = cashPicktot+rs.getDouble("TOTAL_AMOUNT");
}


}
	else{
	preTripSheetNo = currentTripSheetNo;
	currentTripSheetNo = rs.getString("TRIP_SHEET_NO");

	if(!preTripSheetNo.equals(currentTripSheetNo)){
		
		
		JsonArray.put(JsonObject);
		JsonObject = new JSONObject();	
		count = 0;
		cashdeltot =0.0;
	    cashPicktot = 0.0;
	    atmReptot = 0.0;
	    tot = 0.0;
		count++;

		if(rs.getString("CUSTOMER_TYPE").equals("ATM Replenishment")){
			atmReptot =atmReptot+ rs.getDouble("TOTAL_AMOUNT");
		}
		if(rs.getString("CUSTOMER_TYPE").equals("Cash Delivery")){
			cashdeltot =cashdeltot+ rs.getDouble("TOTAL_AMOUNT");
		}
		if(rs.getString("CUSTOMER_TYPE").equals("Cash pickup")){
			cashPicktot = cashPicktot+rs.getDouble("TOTAL_AMOUNT");
		}

	}else{
		count++;

		if(rs.getString("CUSTOMER_TYPE").equals("ATM Replenishment")){
			atmReptot =atmReptot+ rs.getDouble("TOTAL_AMOUNT");
		}
		if(rs.getString("CUSTOMER_TYPE").equals("Cash Delivery")){
			cashdeltot =cashdeltot+ rs.getDouble("TOTAL_AMOUNT");
		}
		if(rs.getString("CUSTOMER_TYPE").equals("Cash pickup")){
			cashPicktot = cashPicktot+rs.getDouble("TOTAL_AMOUNT");
		}

	}
	 }
	tripSheetNo = rs.getString("TRIP_SHEET_NO");
	date = rs.getString("DATE");
	routeName = rs.getString("ROUTE_NAME");
	JsonObject.put( "tripsheetnoDataIndex",tripSheetNo);
	JsonObject.put( "dateDataIndex",date);
	JsonObject.put( "routeindex",routeName);
	JsonObject.put( "noofpoiindex",count);
	JsonObject.put( "atmrepamtindex",atmReptot);
	JsonObject.put( "cashdeliveryindex",cashdeltot);
	JsonObject.put( "cashpickupindex",cashPicktot);
	tot = cashdeltot+cashPicktot+atmReptot;
	JsonObject.put( "totalamountindex",tot);
	JsonObject.put( "deliveryCustomerId",rs.getString("DeliveryCustomerId"));  
	}
	if(JsonObject != null){
	JsonArray.put(JsonObject);
	}
} catch (Exception e) {
	e.printStackTrace();
} finally {
   DBConnection.releaseConnectionToDB(con, pstmt, rs);
}
return JsonArray;

}

public JSONArray getGridForSummaryEnrouteDispense(int systemId,int custId){
    Connection con = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    JSONObject  JsonObject= null;
    JSONArray JsonArray = new JSONArray();
   
   String preTripSheetNo ="";
  String  currentTripSheetNo = "";
  String tripStatus = "";
  String tripSheetNo="";
  String tripNo = "";
  String date = "";
  String routeName = "";
  int noOfPois = 0;
  String vehicleNo = "";
  String cust1 = "";
  String cust2 = "";
  String driverName = "";
  
 try {
	
	 con = DBConnection.getConnectionToDB("AMS");
	 pstmt = con.prepareStatement(CashVanManagementStatements.GET_SUMMARY_FOR_ENROUTE_CASH_DISPENSE);
     pstmt.setInt(1, systemId);
     pstmt.setInt(2, custId);
     pstmt.setInt(3, systemId);
     pstmt.setInt(4, custId);
	 rs=pstmt.executeQuery();
	 int count = 0;
	 while(rs.next()){
		 
if(rs.getRow()==1){
currentTripSheetNo = rs.getString("TRIP_SHEET_NO");
preTripSheetNo = rs.getString("TRIP_SHEET_NO");
JsonObject = new JSONObject();	
count++;


}else{
	preTripSheetNo = currentTripSheetNo;
	currentTripSheetNo = rs.getString("TRIP_SHEET_NO");

	if(!preTripSheetNo.equals(currentTripSheetNo)){
		
		
		JsonArray.put(JsonObject);
		JsonObject = new JSONObject();	
		count = 0;
	
		count++;

	

	}else{
		count++;

	

	}
	 }
	tripSheetNo = rs.getString("TRIP_SHEET_NO");
	tripStatus =rs.getString("TRIP_STATUS").toUpperCase();
	tripNo = rs.getString("TRIP_ID");
	date = rs.getString("DATE");
	routeName = rs.getString("ROUTE_NAME");
	vehicleNo = rs.getString("ASSET_NUMBER");
	cust1 = rs.getString("CUSTODIAN_1");
	cust2 = rs.getString("CUSTODIAN_2");
	driverName = rs.getString("DRIVER_NAME");
	
	JsonObject.put( "tripsheetnoDataIndex",tripSheetNo);
	JsonObject.put( "tripstatusDataIndex",tripStatus);
	JsonObject.put( "tripnoindex",tripNo);
	JsonObject.put( "dateindex",date);
	JsonObject.put( "routeindex",routeName);
	JsonObject.put( "noofpoiindex",count);
	JsonObject.put( "vehiclenoindex",vehicleNo);
	JsonObject.put( "custodian1index",cust1);
	JsonObject.put(  "custodian2index",cust2);
	JsonObject.put( "drivernameindex",driverName);
	  
	}
	if(JsonObject != null){
	JsonArray.put(JsonObject);
	}
} catch (Exception e) {
	e.printStackTrace();
} finally {
   DBConnection.releaseConnectionToDB(con, pstmt, rs);
}
return JsonArray;

}
public JSONArray getRouteNames(int clientId, int systemId) {
	Connection con = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	JSONArray jArray = new JSONArray();
	JSONObject obj = null;
	try{
		con = DBConnection.getConnectionToDB("AMS");
		pstmt = con.prepareStatement(CashVanManagementStatements.GET_ACTIVE_ROUTES);
		pstmt.setInt(1, systemId);
		pstmt.setInt(2, clientId);
		pstmt.setString(3, "Active");
		rs = pstmt.executeQuery();
		while(rs.next()){
			obj = new JSONObject();
			obj.put("routeId", rs.getInt("id"));
			obj.put("routeName", rs.getString("routeName"));
			jArray.put(obj);
		}
	}catch(Exception e){
		e.printStackTrace();
	}finally{
		DBConnection.releaseConnectionToDB(con, pstmt, rs);
	}
	return jArray;
}
public JSONArray getCashDespenseView(int systemId, int clientId, int routeId, String tripSheetNo, String date, String btnValue) {
	Connection con = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	JSONArray jArray = new JSONArray();
	JSONObject obj = null;
	int count = 0;
	try{
		con = DBConnection.getConnectionToDB("AMS");
		if(btnValue.equals("Create")){
			pstmt = con.prepareStatement(CashVanManagementStatements.GET_CASH_DEPSENSE_DETAILS_ON_CREATE);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, clientId);
			pstmt.setInt(3, routeId);
			rs = pstmt.executeQuery();
			while(rs.next()){
				obj = new JSONObject();
				count++;
				obj.put("slnoIndex", count);
				obj.put("UIDDI", rs.getInt("businessId"));
				obj.put("customerTypeDI", rs.getString("custType"));
				obj.put("customerNameDI", rs.getString("custName"));
				obj.put("customerIdDI", rs.getString("customerId"));
				obj.put("atmIdDI", rs.getString("atmId"));
				obj.put("accOfDI", "");
				obj.put("sealedBagCashDI", "");
				obj.put("locationDI", rs.getString("location"));
				obj.put("sealNoDI", "");
				obj.put("checkNoDI", "");
				obj.put("jewellaryNoDI", "");
				obj.put("foreignCurrencyDI", "");
				obj.put("denom5000DI", 0);
				obj.put("denom2000DI", 0);
				obj.put("denom1000DI", 0);
				obj.put("denom500DI", 0);
				obj.put("denom100DI", 0);
				obj.put("denom50DI", 0);
				obj.put("denom20DI", 0);
				obj.put("denom10DI", 0);
				obj.put("denom5DI", 0);
				obj.put("denom2DI", 0);
				obj.put("denom1DI", 0);
				obj.put("denom050DI", 0);
				obj.put("denom025DI", 0);
				obj.put("denom010DI", 0);
				obj.put("denom005DI", 0);
				obj.put("denom002DI", 0);
				obj.put("denom001DI", 0);
				obj.put("totalSealAmntDI", 0);
				obj.put("totalCashAmntDI", 0);
				obj.put("totalCheckAmntDI", 0);
				obj.put("totalJewellaryAmntDI", 0);
				obj.put("totalForeignAmntDI", 0);
				obj.put("totalAmntDI", 0);
				obj.put("deliveryCustomerDI", "");
				obj.put("cashDeliveryLocationDI", "");
				jArray.put(obj);
			}
		}else if(btnValue.equals("Modify")){
			pstmt = con.prepareStatement(CashVanManagementStatements.GET_CASH_DEPSENSE_DETAILS_ON_MODIFY);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, clientId);
			pstmt.setInt(3, routeId);
			pstmt.setString(4, yyyymmdd.format(ddmmyy.parse(date)));
			pstmt.setString(5, tripSheetNo);
			pstmt.setInt(6, systemId);
			pstmt.setInt(7, clientId);
			pstmt.setInt(8, routeId);
			pstmt.setInt(9, systemId);
			pstmt.setInt(10, clientId);
			pstmt.setInt(11, routeId);
			pstmt.setString(12, yyyymmdd.format(ddmmyy.parse(date)));
			pstmt.setString(13, tripSheetNo);
			rs = pstmt.executeQuery();
			while(rs.next()){
				obj = new JSONObject();
				count++;
				obj.put("slnoIndex", count);
				obj.put("UIDDI", rs.getInt("businessId"));
				obj.put("customerTypeDI", rs.getString("custType"));
				obj.put("customerNameDI", rs.getString("custName"));
				obj.put("customerIdDI", rs.getString("customerId"));
				obj.put("atmIdDI", rs.getString("atmId"));
				obj.put("accOfDI", rs.getString("onAccOf"));
				obj.put("sealedBagCashDI", rs.getString("sealedOrCash"));
				obj.put("locationDI", rs.getString("location"));
				obj.put("sealNoDI", rs.getString("sealNo"));
				obj.put("checkNoDI", rs.getString("checkNo"));
				obj.put("jewellaryNoDI", rs.getString("jewelleryNo"));
				obj.put("foreignCurrencyDI", rs.getString("foreignNo"));
				obj.put("denom5000DI", rs.getLong("denom5000"));
				obj.put("denom2000DI", rs.getLong("denom2000"));
				obj.put("denom1000DI", rs.getLong("denom1000"));
				obj.put("denom500DI", rs.getLong("denom500"));
				obj.put("denom100DI", rs.getLong("denom100"));
				obj.put("denom50DI", rs.getLong("denom50"));
				obj.put("denom20DI", rs.getLong("denom20"));
				obj.put("denom10DI", rs.getLong("denom10"));
				obj.put("denom5DI", rs.getLong("denom5"));
				obj.put("denom2DI", rs.getLong("denom2"));
				obj.put("denom1DI", rs.getLong("denom1"));
				obj.put("denom050DI",rs.getLong("denom050"));
				obj.put("denom025DI",rs.getLong("denom025"));
				obj.put("denom010DI",rs.getLong("denom010"));
				obj.put("denom005DI",rs.getLong("denom005"));
				obj.put("denom002DI",rs.getLong("denom002"));
				obj.put("denom001DI",rs.getLong("denom001"));
				obj.put("totalSealAmntDI", rs.getDouble("totalSealAmnt"));
				obj.put("totalCashAmntDI", rs.getDouble("totalCashAmnt"));
				obj.put("totalCheckAmntDI", rs.getDouble("totalCheckAmnt"));
				obj.put("totalJewellaryAmntDI", rs.getDouble("totalJewelleryAmnt"));
				obj.put("totalForeignAmntDI", rs.getDouble("totalForXAmnt"));
				obj.put("totalAmntDI", rs.getDouble("totalAmount"));
				obj.put("deliveryCustomerDI", rs.getString("DeliveryCustomerName"));
				obj.put("cashDeliveryLocationDI", rs.getString("DeliveryLocationName"));
				jArray.put(obj);
			}
		}
	}catch(Exception e){
	 	e.printStackTrace();
	}finally{
		DBConnection.releaseConnectionToDB(con, pstmt, rs);
	}
	return jArray;
}
public synchronized String saveCashDispenseDetails(JSONArray js, int systemId, int clientId,	int routeId, String date, int userId) {
	String msg = "";
	Connection con = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	int inserted = 0;
	JSONObject obj = null;
	boolean valid = true;
	HashMap<Integer, ArrayList<Integer>> temporaryDataMap = new HashMap<Integer, ArrayList<Integer>>();
	HashMap<Integer, ArrayList<Integer>> currentDataMap = new HashMap<Integer, ArrayList<Integer>>();
	ArrayList<Integer> temporaryData = new ArrayList<Integer>();
	ArrayList<Integer> currentData = new ArrayList<Integer>();
	int insert = 0;
	String customerIds = "";
	try{
		con = DBConnection.getConnectionToDB("AMS");
		pstmt = con.prepareStatement(CashVanManagementStatements.DELETE_TEMPORARY_DISPENSE_DATA);
		pstmt.setInt(1, systemId);
		pstmt.setInt(2, clientId);
		pstmt.executeUpdate();
		for(int i = 0; i < js.length(); i++){
			obj = js.getJSONObject(i);
			if(obj.getString("customerTypeDI").equals("ATM Replenishment") || obj.getString("customerTypeDI").equals("Cash Delivery")&& obj.getString("sealedBagCashDI").contains("Cash")){
				pstmt = con.prepareStatement(CashVanManagementStatements.INSERT_INTO_TEMPORARY_DISPENSE);
				pstmt.setInt(1, systemId);
				pstmt.setInt(2, clientId);
				if(obj.getString("customerTypeDI").equals("ATM Replenishment")){
					pstmt.setInt(3, Integer.parseInt(obj.getString("customerIdDI")));
				}else if(obj.getString("customerTypeDI").equals("Cash Delivery")){
					pstmt.setInt(3, Integer.parseInt(obj.getString("accOfDI")));
				}
				pstmt.setLong(4, Long.parseLong(obj.getString("UIDDI")));
				pstmt.setLong(5, Long.parseLong(obj.getString("denom5000DI")));
				pstmt.setLong(6, Long.parseLong(obj.getString("denom2000DI")));
				pstmt.setLong(7, Long.parseLong(obj.getString("denom1000DI")));
				pstmt.setLong(8, Long.parseLong(obj.getString("denom500DI")));
				pstmt.setLong(9, Long.parseLong(obj.getString("denom100DI")));
				pstmt.setLong(10, Long.parseLong(obj.getString("denom50DI")));
				pstmt.setLong(11, Long.parseLong(obj.getString("denom20DI")));
				pstmt.setLong(12, Long.parseLong(obj.getString("denom10DI")));
				pstmt.setLong(13, Long.parseLong(obj.getString("denom5DI")));
				pstmt.setLong(14, Long.parseLong(obj.getString("denom2DI")));
				pstmt.setLong(15, Long.parseLong(obj.getString("denom1DI")));
				pstmt.setLong(16, Long.parseLong(obj.getString("denom050DI")));
				pstmt.setLong(17, Long.parseLong(obj.getString("denom025DI")));
				pstmt.setLong(18, Long.parseLong(obj.getString("denom010DI")));
				pstmt.setLong(19, Long.parseLong(obj.getString("denom005DI")));
				pstmt.setLong(20, Long.parseLong(obj.getString("denom002DI")));
				pstmt.setLong(21, Long.parseLong(obj.getString("denom001DI")));
				insert = pstmt.executeUpdate();
			}
		}
		if(insert > 0){
			pstmt = con.prepareStatement(CashVanManagementStatements.GET_TEMPORARY_DISPENSE_RECORD);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, clientId);
			rs = pstmt.executeQuery();
			while(rs.next()){
				temporaryData = new ArrayList<Integer>();
				temporaryData.add(rs.getInt("DENOM_5000"));
				temporaryData.add(rs.getInt("DENOM_2000"));
				temporaryData.add(rs.getInt("DENOM_1000"));
				temporaryData.add(rs.getInt("DENOM_500"));
				temporaryData.add(rs.getInt("DENOM_100"));
				temporaryData.add(rs.getInt("DENOM_50"));
				temporaryData.add(rs.getInt("DENOM_20"));
				temporaryData.add(rs.getInt("DENOM_10"));
				temporaryData.add(rs.getInt("DENOM_5"));
				temporaryData.add(rs.getInt("DENOM_2"));
				temporaryData.add(rs.getInt("DENOM_1"));
				temporaryData.add(rs.getInt("DENOM_050"));
				temporaryData.add(rs.getInt("DENOM_025"));
				temporaryData.add(rs.getInt("DENOM_010"));
				temporaryData.add(rs.getInt("DENOM_005"));
				temporaryData.add(rs.getInt("DENOM_002"));
				temporaryData.add(rs.getInt("DENOM_001"));
				temporaryDataMap.put(rs.getInt("cvsCustId"), temporaryData);
			}
			String cvsCustomers = "";
			for (Entry<Integer, ArrayList<Integer>> entry: temporaryDataMap.entrySet()) {
				cvsCustomers = cvsCustomers +","+entry.getKey();
			}
			pstmt = con.prepareStatement(CashVanManagementStatements.GET_CURRENT_VAULT_RECORD.replace("#", cvsCustomers.substring(1, cvsCustomers.length())));
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, clientId);
			rs = pstmt.executeQuery();
			while(rs.next()){
				currentData = new ArrayList<Integer>();
				currentData.add(rs.getInt("denom5000"));
				currentData.add(rs.getInt("denom2000"));
				currentData.add(rs.getInt("denom1000"));
				currentData.add(rs.getInt("denom500"));
				currentData.add(rs.getInt("denom100"));
				currentData.add(rs.getInt("denom50"));
				currentData.add(rs.getInt("denom20"));
				currentData.add(rs.getInt("denom10"));
				currentData.add(rs.getInt("denom5"));
				currentData.add(rs.getInt("denom2"));
				currentData.add(rs.getInt("denom1"));
				currentData.add(rs.getInt("denom050"));
				currentData.add(rs.getInt("denom025"));
				currentData.add(rs.getInt("denom010"));
				currentData.add(rs.getInt("denom005"));
				currentData.add(rs.getInt("denom002"));
				currentData.add(rs.getInt("denom001"));
				currentDataMap.put(rs.getInt("cvsCustId"), currentData);
			}
			for (Entry<Integer, ArrayList<Integer>> entry: temporaryDataMap.entrySet()) {
			    if (currentDataMap.containsKey(entry.getKey())){
			    	ArrayList<Integer> tempData = entry.getValue();
			    	ArrayList<Integer> currData = currentDataMap.get(entry.getKey());
			    	for(int i=0;i<=10;i++){
			    		if(tempData.get(i) > currData.get(i)){
			    			valid = false;
			    			customerIds = customerIds+","+entry.getKey();
			    		}
			    	}
			    }else{
			    	valid = false;
			    	customerIds = customerIds+","+entry.getKey();
			    }
			}
		}
		if(valid){
			con.setAutoCommit(false);
				String tripSheetNo = getTripSheetNo(con,systemId,clientId);
				for(int i = 0; i < js.length(); i++){
					obj = js.getJSONObject(i);
					pstmt = con.prepareStatement(CashVanManagementStatements.INSERT_CASH_DISPENSE1);
					pstmt.setInt(1, systemId);
					pstmt.setInt(2, clientId);
					pstmt.setInt(3, Integer.parseInt(obj.getString("UIDDI")));
					pstmt.setString(4,tripSheetNo);
					pstmt.setString(5, obj.getString("customerTypeDI"));
					pstmt.setInt(6, Integer.parseInt(obj.getString("customerIdDI")));
					pstmt.setString(7, date);
					pstmt.setInt(8, routeId);
					pstmt.setString(9, obj.getString("accOfDI"));
					pstmt.setString(10, obj.getString("sealedBagCashDI"));
					pstmt.setString(11, obj.getString("sealNoDI"));
					pstmt.setString(12, obj.getString("checkNoDI"));
					pstmt.setString(13, obj.getString("jewellaryNoDI"));
					pstmt.setString(14, obj.getString("foreignCurrencyDI"));
					pstmt.setLong(15, Long.parseLong(obj.getString("denom5000DI")));
					pstmt.setLong(16, Long.parseLong(obj.getString("denom2000DI")));
					pstmt.setLong(17, Long.parseLong(obj.getString("denom1000DI")));
					pstmt.setLong(18, Long.parseLong(obj.getString("denom500DI")));
					pstmt.setLong(19, Long.parseLong(obj.getString("denom100DI")));
					pstmt.setLong(20, Long.parseLong(obj.getString("denom50DI")));
					pstmt.setLong(21, Long.parseLong(obj.getString("denom20DI")));
					pstmt.setLong(22, Long.parseLong(obj.getString("denom10DI")));
					pstmt.setLong(23, Long.parseLong(obj.getString("denom5DI")));
					pstmt.setLong(24, Long.parseLong(obj.getString("denom2DI")));
					pstmt.setLong(25, Long.parseLong(obj.getString("denom1DI")));
					pstmt.setLong(26, Long.parseLong(obj.getString("denom050DI")));
					pstmt.setLong(27, Long.parseLong(obj.getString("denom025DI")));
					pstmt.setLong(28, Long.parseLong(obj.getString("denom010DI")));
					pstmt.setLong(29, Long.parseLong(obj.getString("denom005DI")));
					pstmt.setLong(30, Long.parseLong(obj.getString("denom002DI")));
					pstmt.setLong(31, Long.parseLong(obj.getString("denom001DI")));
					pstmt.setDouble(32, Double.parseDouble(obj.getString("totalSealAmntDI")));
					pstmt.setDouble(33, Double.parseDouble(obj.getString("totalCashAmntDI")));
					pstmt.setDouble(34, Double.parseDouble(obj.getString("totalCheckAmntDI")));
					pstmt.setDouble(35, Double.parseDouble(obj.getString("totalJewellaryAmntDI")));
					pstmt.setDouble(36, Double.parseDouble(obj.getString("totalForeignAmntDI")));
					pstmt.setDouble(37, Double.parseDouble(obj.getString("totalSealAmntDI"))+Double.parseDouble(obj.getString("totalCashAmntDI"))+Double.parseDouble(obj.getString("totalCheckAmntDI"))
								+ Double.parseDouble(obj.getString("totalJewellaryAmntDI")) + Double.parseDouble(obj.getString("totalForeignAmntDI")));
					pstmt.setString(38, "PENDING");
					pstmt.setString(39, "PENDING");
					pstmt.setString(40, obj.getString("deliveryCustomerDI"));
					pstmt.setString(41, obj.getString("cashDeliveryLocationDI"));
					pstmt.setInt(42, userId);
					inserted = pstmt.executeUpdate();
					if(obj.getString("customerTypeDI").equals("ATM Replenishment")){
						pstmt = con.prepareStatement(CashVanManagementStatements.UPDATE_VAULT_TRANSIT_ON_DISPENSE);
						pstmt.setLong(1, Long.parseLong(obj.getString("denom5000DI")));
						pstmt.setLong(2, Long.parseLong(obj.getString("denom2000DI")));
						pstmt.setLong(3, Long.parseLong(obj.getString("denom1000DI")));
						pstmt.setLong(4, Long.parseLong(obj.getString("denom500DI")));
						pstmt.setLong(5, Long.parseLong(obj.getString("denom100DI")));
						pstmt.setLong(6, Long.parseLong(obj.getString("denom50DI")));
						pstmt.setLong(7, Long.parseLong(obj.getString("denom20DI")));
						pstmt.setLong(8, Long.parseLong(obj.getString("denom10DI")));
						pstmt.setLong(9, Long.parseLong(obj.getString("denom5DI")));
						pstmt.setLong(10, Long.parseLong(obj.getString("denom2DI")));
						pstmt.setLong(11, Long.parseLong(obj.getString("denom1DI")));
						pstmt.setLong(12, Long.parseLong(obj.getString("denom050DI")));
						pstmt.setLong(13, Long.parseLong(obj.getString("denom025DI")));
						pstmt.setLong(14, Long.parseLong(obj.getString("denom010DI")));
						pstmt.setLong(15, Long.parseLong(obj.getString("denom005DI")));
						pstmt.setLong(16, Long.parseLong(obj.getString("denom002DI")));
						pstmt.setLong(17, Long.parseLong(obj.getString("denom001DI")));
						pstmt.setInt(18, systemId);
						pstmt.setInt(19, clientId);
						pstmt.setInt(20, Integer.parseInt(obj.getString("customerIdDI")));
						pstmt.executeUpdate();
					}
					if(obj.getString("customerTypeDI").equals("Cash Delivery")&& obj.getString("sealedBagCashDI").contains("Cash")){
						pstmt = con.prepareStatement(CashVanManagementStatements.UPDATE_VAULT_TRANSIT_ON_DISPENSE);
						pstmt.setLong(1, Long.parseLong(obj.getString("denom5000DI")));
						pstmt.setLong(2, Long.parseLong(obj.getString("denom2000DI")));
						pstmt.setLong(3, Long.parseLong(obj.getString("denom1000DI")));
						pstmt.setLong(4, Long.parseLong(obj.getString("denom500DI")));
						pstmt.setLong(5, Long.parseLong(obj.getString("denom100DI")));
						pstmt.setLong(6, Long.parseLong(obj.getString("denom50DI")));
						pstmt.setLong(7, Long.parseLong(obj.getString("denom20DI")));
						pstmt.setLong(8, Long.parseLong(obj.getString("denom10DI")));
						pstmt.setLong(9, Long.parseLong(obj.getString("denom5DI")));
						pstmt.setLong(10, Long.parseLong(obj.getString("denom2DI")));
						pstmt.setLong(11, Long.parseLong(obj.getString("denom1DI")));
						pstmt.setLong(12, Long.parseLong(obj.getString("denom050DI")));
						pstmt.setLong(13, Long.parseLong(obj.getString("denom025DI")));
						pstmt.setLong(14, Long.parseLong(obj.getString("denom010DI")));
						pstmt.setLong(15, Long.parseLong(obj.getString("denom005DI")));
						pstmt.setLong(16, Long.parseLong(obj.getString("denom002DI")));
						pstmt.setLong(17, Long.parseLong(obj.getString("denom001DI")));
						pstmt.setInt(18, systemId);
						pstmt.setInt(19, clientId);
						pstmt.setInt(20, Integer.parseInt(obj.getString("accOfDI")));
						pstmt.executeUpdate();
					}
					if(obj.getString("customerTypeDI").equals("Cash Delivery")&& obj.getString("sealedBagCashDI").contains("Sealed Bag")){
						String[]  sealNo = obj.getString("sealNoDI").split(",");
						String sealNumbers = "";
						for(String s:sealNo){
							sealNumbers = sealNumbers+","+"'"+s+"'";
						}
						pstmt = con.prepareStatement(CashVanManagementStatements.UPDATE_SEALBAG_STATUS_IN_VAULT_INWARD.replace("#", sealNumbers.substring(1, sealNumbers.length())));
						pstmt.setString(1, "DISPENSED");
						pstmt.setInt(2, systemId);
						pstmt.setInt(3, clientId);
						pstmt.setInt(4, Integer.parseInt(obj.getString("accOfDI")));
						pstmt.setString(5, "SEALED BAG");
						pstmt.executeUpdate();
					}
					if(obj.getString("customerTypeDI").equals("Cash Delivery")&& obj.getString("sealedBagCashDI").contains("Cheque")){
						String[]  checkNo = obj.getString("checkNoDI").split(",");
						String checkNumbers = "";
						for(String s:checkNo){
							checkNumbers = checkNumbers+","+"'"+s+"'";
						}
						pstmt = con.prepareStatement(CashVanManagementStatements.UPDATE_SEALBAG_STATUS_IN_VAULT_INWARD.replace("#", checkNumbers.substring(1, checkNumbers.length())));
						pstmt.setString(1, "DISPENSED");
						pstmt.setInt(2, systemId);
						pstmt.setInt(3, clientId);
						pstmt.setInt(4, Integer.parseInt(obj.getString("accOfDI")));
						pstmt.setString(5, "CHEQUE");
						pstmt.executeUpdate();
					}
					if(obj.getString("customerTypeDI").equals("Cash Delivery")&& obj.getString("sealedBagCashDI").contains("Jewellery")){
						String[]  jewelleryNo = obj.getString("jewellaryNoDI").split(",");
						String jewelleryNumbers = "";
						for(String s:jewelleryNo){
							jewelleryNumbers = jewelleryNumbers+","+"'"+s+"'";
						}
						pstmt = con.prepareStatement(CashVanManagementStatements.UPDATE_SEALBAG_STATUS_IN_VAULT_INWARD.replace("#", jewelleryNumbers.substring(1, jewelleryNumbers.length())));
						pstmt.setString(1, "DISPENSED");
						pstmt.setInt(2, systemId);
						pstmt.setInt(3, clientId);
						pstmt.setInt(4, Integer.parseInt(obj.getString("accOfDI")));
						pstmt.setString(5, "JEWELLERY");
						pstmt.executeUpdate();
					}
					if(obj.getString("customerTypeDI").equals("Cash Delivery")&& obj.getString("sealedBagCashDI").contains("Foreign Currency")){
						String[]  forignNo = obj.getString("foreignCurrencyDI").split(",");
						String foreignNumbers = "";
						for(String s:forignNo){
							foreignNumbers = foreignNumbers+","+"'"+s+"'";
						}
						pstmt = con.prepareStatement(CashVanManagementStatements.UPDATE_SEALBAG_STATUS_IN_VAULT_INWARD.replace("#", foreignNumbers.substring(1, foreignNumbers.length())));
						pstmt.setString(1, "DISPENSED");
						pstmt.setInt(2, systemId);
						pstmt.setInt(3, clientId);
						pstmt.setInt(4, Integer.parseInt(obj.getString("accOfDI")));
						pstmt.setString(5, "FOREIGN CURRENCY");
						pstmt.executeUpdate();
					}
				}
		}else{
			String customerName  = "";
			pstmt = con.prepareStatement(CashVanManagementStatements.GET_CUSTOMER_NAMES.replace("#", customerIds.substring(1, customerIds.length())));
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, clientId);
			rs = pstmt.executeQuery();
			while(rs.next()){
				customerName = customerName+","+rs.getString("customerName");
			}
			return msg = "Entered dispenses are exceeding over available dispenses for the customer - "+customerName.substring(1, customerName.length());
		}
		con.commit();
		if(inserted > 0){
			msg = "Success";
		}else{
			msg = "Error while cash dipsensing...";
		}
	
	}catch(Exception e){
		e.printStackTrace();
		try{
			if(con != null){
				con.rollback();
			}
		}catch(Exception e1){
			e1.printStackTrace();
		}
	}finally{
		DBConnection.releaseConnectionToDB(con, pstmt, rs);
	}
	return msg;
}
public String getTripSheetNo(Connection con, int systemId, int clientId) {
	String referenceCode="CRT";
	ResultSet rs = null;
	PreparedStatement pstmt = null;
	try {
		int RunningNo = 0;
		pstmt = con.prepareStatement(CashVanManagementStatements.GET_RUNNING_TRIP_SHEET_NO);
		pstmt.setInt(1, clientId);
		pstmt.setInt(2, systemId);
		pstmt.setString(3, "CRT");
		rs = pstmt.executeQuery();
		if (rs.next()) {
			RunningNo = rs.getInt("tripSheetNo");
		}
		rs.close();
		RunningNo++;
		referenceCode = referenceCode+""+RunningNo;
		boolean recordPresent = false;
		pstmt = con.prepareStatement(CashVanManagementStatements.IS_PRESENT_INVOICE_NO);
		pstmt.setInt(1, clientId);
		pstmt.setInt(2, systemId);
		pstmt.setString(3, "CRT");
		rs = pstmt.executeQuery();
		if (rs.next()) {
			recordPresent = true;
		}
		if (recordPresent) {
			pstmt = con.prepareStatement(CashVanManagementStatements.UPDATE_INVOICE_NO);
			pstmt.setInt(1, RunningNo);
			pstmt.setInt(2, clientId);
			pstmt.setInt(3, systemId);
			pstmt.setString(4, "CRT");
			pstmt.executeUpdate();
		} else {
			pstmt = con.prepareStatement(CashVanManagementStatements.INSERT_INVOICE_NO);
			pstmt.setInt(1, RunningNo);
			pstmt.setInt(2, clientId);
			pstmt.setInt(3, systemId);
			pstmt.setString(4, "CRT");
			pstmt.executeUpdate();
		}
	}catch (Exception e) {    
	    e.printStackTrace();
	}finally{
		DBConnection.releaseConnectionToDB(null, pstmt, rs);
	}
	return referenceCode;
	}
public JSONArray getCurrentVaultDetails(int systemId, int clientId, int cvsCustomerId) {
	Connection con = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	JSONArray jArray = new JSONArray();
	JSONObject obj = null;
	try{
		con = DBConnection.getConnectionToDB("AMS");
		pstmt = con.prepareStatement(CashVanManagementStatements.GET_CURRENT_VAULT_RECORD.replace("#", ""));
		pstmt.setInt(1, systemId);
		pstmt.setInt(2, clientId);
		pstmt.setInt(3, cvsCustomerId);
		rs = pstmt.executeQuery();
		while(rs.next()){
			obj = new JSONObject();
			obj.put("denom5000", rs.getLong("denom5000"));
			obj.put("denom2000", rs.getLong("denom2000"));
			obj.put("denom1000", rs.getLong("denom1000"));
			obj.put("denom500", rs.getLong("denom500"));
			obj.put("denom100", rs.getLong("denom100"));
			obj.put("denom50", rs.getLong("denom50"));
			obj.put("denom20", rs.getLong("denom20"));
			obj.put("denom10", rs.getLong("denom10"));
			obj.put("denom5", rs.getLong("denom5"));
			obj.put("denom2", rs.getLong("denom2"));
			obj.put("denom1", rs.getLong("denom1"));
			jArray.put(obj);
		}
	}catch(Exception e){
		e.printStackTrace();
	}finally{
		DBConnection.releaseConnectionToDB(con, pstmt, rs);
	}
	return jArray;
}
public JSONArray getSelaNos(int systemId, int clientId, int customerId,String btn) {
	Connection con = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	JSONArray jArray = new JSONArray();
	JSONObject obj = null;
	try{
		con = DBConnection.getConnectionToDB("AMS");
		if(btn.equals("Create")){
			pstmt = con.prepareStatement(CashVanManagementStatements.GET_SEAL_NO_FOR_CREATE);
		}else{
			pstmt = con.prepareStatement(CashVanManagementStatements.GET_SEAL_NO_FOR_MODIFY);
		}
		pstmt.setInt(1, systemId);
		pstmt.setInt(2, clientId);
		pstmt.setInt(3, customerId);
		pstmt.setString(4, "SEALED BAG");
		rs = pstmt.executeQuery();
		while(rs.next()){
			obj = new JSONObject();
			obj.put("sealNoName", rs.getString("sealNo"));
			jArray.put(obj);
		}
	}catch(Exception e){
		e.printStackTrace();
	}finally{
		DBConnection.releaseConnectionToDB(con, pstmt, rs);
	}
	return jArray;
}
public JSONArray getTotalAmount(int systemId, int clientId, String sealNos, String cvsCustId) {
	Connection con = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	JSONArray jArray = new JSONArray();
	JSONObject obj = null;
	String[] sealNo = null;
	String finalSealNo = "";
	try{
		sealNo = sealNos.split(",");
		for(String s:sealNo){
			finalSealNo = finalSealNo+"'"+s+"'"+",";
		}
		con = DBConnection.getConnectionToDB("AMS");
		pstmt = con.prepareStatement(CashVanManagementStatements.GET_TOTAL_AMOUNT.replace("#", finalSealNo.substring(0, finalSealNo.length()-1)));
		pstmt.setInt(1, systemId);
		pstmt.setInt(2, clientId);
		pstmt.setString(3, cvsCustId);
		rs = pstmt.executeQuery();
		while(rs.next()){
			obj = new JSONObject();
			obj.put("totalAmt", rs.getDouble("totalAmount"));
			jArray.put(obj);
		}
	}catch(Exception e){
		e.printStackTrace();
	}finally{
		DBConnection.releaseConnectionToDB(con, pstmt, rs);
	}
	return jArray;
}
public String modifyCashDispenseDetails(JSONArray js, int systemId,	int clientId, int userId,String tripSheetNo, String date, int routeId) {
	String msg = "";
	Connection con = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	int inserted = 0;
	JSONObject obj = null;
	boolean valid = true;
	HashMap<Long, ArrayList<Long>> temporaryDataMap = new HashMap<Long, ArrayList<Long>>();
	HashMap<Long, ArrayList<Long>> currentDataMap = new HashMap<Long, ArrayList<Long>>();
	ArrayList<Long> temporaryData = new ArrayList<Long>();
	ArrayList<Long> currentData = new ArrayList<Long>();
	int insert = 0;
	String customerIds = "";
	try{
		con = DBConnection.getConnectionToDB("AMS");
		pstmt = con.prepareStatement(CashVanManagementStatements.DELETE_TEMPORARY_DISPENSE_DATA);
		pstmt.setInt(1, systemId);
		pstmt.setInt(2, clientId);
		pstmt.executeUpdate();
		for(int i = 0; i < js.length(); i++){
			obj = js.getJSONObject(i);
			if(obj.getString("customerTypeDI").equals("ATM Replenishment") || obj.getString("customerTypeDI").equals("Cash Delivery")&& obj.getString("sealedBagCashDI").contains("Cash")){
				pstmt = con.prepareStatement(CashVanManagementStatements.INSERT_INTO_TEMPORARY_DISPENSE);
				pstmt.setInt(1, systemId);
				pstmt.setInt(2, clientId);
				if(obj.getString("customerTypeDI").equals("Cash Delivery")){
					pstmt.setInt(3, Integer.parseInt(obj.getString("accOfDI")));
				}else{
					pstmt.setInt(3, Integer.parseInt(obj.getString("customerIdDI")));
				}
				pstmt.setLong(4, Long.parseLong(obj.getString("UIDDI")));
				pstmt.setLong(5, Long.parseLong(obj.getString("denom5000DI")));
				pstmt.setLong(6, Long.parseLong(obj.getString("denom2000DI")));
				pstmt.setLong(7, Long.parseLong(obj.getString("denom1000DI")));
				pstmt.setLong(8, Long.parseLong(obj.getString("denom500DI")));
				pstmt.setLong(9, Long.parseLong(obj.getString("denom100DI")));
				pstmt.setLong(10, Long.parseLong(obj.getString("denom50DI")));
				pstmt.setLong(11, Long.parseLong(obj.getString("denom20DI")));
				pstmt.setLong(12, Long.parseLong(obj.getString("denom10DI")));
				pstmt.setLong(13, Long.parseLong(obj.getString("denom5DI")));
				pstmt.setLong(14, Long.parseLong(obj.getString("denom2DI")));
				pstmt.setLong(15, Long.parseLong(obj.getString("denom1DI")));
				pstmt.setLong(10, Long.parseLong(obj.getString("denom050DI")));
				pstmt.setLong(11, Long.parseLong(obj.getString("denom025DI")));
				pstmt.setLong(12, Long.parseLong(obj.getString("denom010DI")));
				pstmt.setLong(13, Long.parseLong(obj.getString("denom005DI")));
				pstmt.setLong(14, Long.parseLong(obj.getString("denom002DI")));
				pstmt.setLong(15, Long.parseLong(obj.getString("denom001DI")));
				insert = pstmt.executeUpdate();
		}
		}
		if(insert > 0){
			pstmt = con.prepareStatement(CashVanManagementStatements.GET_TEMPORARY_DISPENSE_RECORD);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, clientId);
			rs = pstmt.executeQuery();
			while(rs.next()){
				temporaryData = new ArrayList<Long>();
				temporaryData.add(rs.getLong("DENOM_5000"));
				temporaryData.add(rs.getLong("DENOM_2000"));
				temporaryData.add(rs.getLong("DENOM_1000"));
				temporaryData.add(rs.getLong("DENOM_500"));
				temporaryData.add(rs.getLong("DENOM_100"));
				temporaryData.add(rs.getLong("DENOM_50"));
				temporaryData.add(rs.getLong("DENOM_20"));
				temporaryData.add(rs.getLong("DENOM_10"));
				temporaryData.add(rs.getLong("DENOM_5"));
				temporaryData.add(rs.getLong("DENOM_2"));
				temporaryData.add(rs.getLong("DENOM_1"));
				temporaryData.add(rs.getLong("DENOM_050"));
				temporaryData.add(rs.getLong("DENOM_025"));
				temporaryData.add(rs.getLong("DENOM_010"));
				temporaryData.add(rs.getLong("DENOM_005"));
				temporaryData.add(rs.getLong("DENOM_002"));
				temporaryData.add(rs.getLong("DENOM_001"));
				temporaryDataMap.put(rs.getLong("cvsCustId"), temporaryData);
			}
			String cvsCustomers = "";
			for (Entry<Long, ArrayList<Long>> entry: temporaryDataMap.entrySet()) {
				cvsCustomers = cvsCustomers +","+entry.getKey();
			}
			pstmt = con.prepareStatement(CashVanManagementStatements.GET_CURRENT_VAULT_RECORD_PLUS_DISPENSE_DETAILS.replace("#", cvsCustomers.substring(1, cvsCustomers.length())));
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, clientId);
			pstmt.setInt(3, systemId);
			pstmt.setInt(4, clientId);
			pstmt.setInt(5, systemId);
			pstmt.setInt(6, clientId);
			rs = pstmt.executeQuery();
			while(rs.next()){
				currentData = new ArrayList<Long>();
				currentData.add(rs.getLong("denom5000"));
				currentData.add(rs.getLong("denom2000"));
				currentData.add(rs.getLong("denom1000"));
				currentData.add(rs.getLong("denom500"));
				currentData.add(rs.getLong("denom100"));
				currentData.add(rs.getLong("denom50"));
				currentData.add(rs.getLong("denom20"));
				currentData.add(rs.getLong("denom10"));
				currentData.add(rs.getLong("denom5"));
				currentData.add(rs.getLong("denom2"));
				currentData.add(rs.getLong("denom1"));
				currentData.add(rs.getLong("denom050"));
				currentData.add(rs.getLong("denom025"));
				currentData.add(rs.getLong("denom010"));
				currentData.add(rs.getLong("denom005"));
				currentData.add(rs.getLong("denom002"));
				currentData.add(rs.getLong("denom001"));
				currentDataMap.put(rs.getLong("CVS_CUSTOMER_ID"), currentData);
			}
			for (Entry<Long, ArrayList<Long>> entry: temporaryDataMap.entrySet()) {
			    if (currentDataMap.containsKey(entry.getKey())){
			    	ArrayList<Long> tempData = entry.getValue();
			    	ArrayList<Long> currData = currentDataMap.get(entry.getKey());
			    	for(int i=0;i<=10;i++){
			    		if(tempData.get(i) > currData.get(i)){
			    			valid = false;
			    			customerIds = customerIds+","+entry.getKey();
			    		}
			    	}
			    }else{
			    	valid = false;
	    			customerIds = customerIds+","+entry.getKey();
			    }
			}
		}
		if(valid){
				/* VinLogic :- get the old dispense record based on Trip Sheet No and CVS Customer 
				 add to current vault inventory and clear dispense for new set of record insertion */
				pstmt = con.prepareStatement(CashVanManagementStatements.GET_CVS_CUS_TWISE_DISPENSE_RECORD.replace("#", "TRIP_SHEET_NO=? and TRIP_STATUS in ('PENDING')"));
				pstmt.setInt(1, systemId);
				pstmt.setInt(2, clientId);
				pstmt.setString(3, tripSheetNo);
				rs = pstmt.executeQuery();
				while(rs.next()){
					pstmt = con.prepareStatement(CashVanManagementStatements.UPDATE_VAULT_TRANSIT_BEFORE_CLEARING_DISPENSE);
					pstmt.setLong(1, rs.getLong("denom5000"));
					pstmt.setLong(2, rs.getLong("denom2000"));
					pstmt.setLong(3, rs.getLong("denom1000"));
					pstmt.setLong(4, rs.getLong("denom500"));
					pstmt.setLong(5, rs.getLong("denom100"));
					pstmt.setLong(6, rs.getLong("denom50"));
					pstmt.setLong(7, rs.getLong("denom20"));
					pstmt.setLong(8, rs.getLong("denom10"));
					pstmt.setLong(9, rs.getLong("denom5"));
					pstmt.setLong(10, rs.getLong("denom2"));
					pstmt.setLong(11, rs.getLong("denom1"));
					pstmt.setLong(12, rs.getLong("denom050"));
					pstmt.setLong(13, rs.getLong("denom025"));
					pstmt.setLong(14, rs.getLong("denom010"));
					pstmt.setLong(15, rs.getLong("denom005"));
					pstmt.setLong(16, rs.getLong("denom002"));
					pstmt.setLong(17, rs.getLong("denom001"));
					pstmt.setInt(18, systemId);
					pstmt.setInt(19, clientId);
					pstmt.setInt(20, rs.getInt("CVS_CUSTOMER_ID"));
					pstmt.executeUpdate();
				}
				pstmt = con.prepareStatement(CashVanManagementStatements.GET_SEAL_NO_FROM_DISPENSE.replace("#", "TRIP_SHEET_NO=? and TRIP_STATUS='PENDING'"));
				pstmt.setInt(1, systemId);
				pstmt.setInt(2, clientId);
				pstmt.setString(3, tripSheetNo);
				pstmt.setString(4, "%Sealed Bag%");
				rs = pstmt.executeQuery();
				while(rs.next()){
					String sealNoNew = "";
					String[] sealNo = rs.getString("sealNo").split(",");
					for(String s: sealNo){
						sealNoNew = sealNoNew+","+"'"+s+"'";
					}	
					pstmt = con.prepareStatement(CashVanManagementStatements.UPDATE_SEALBAG_STATUS_IN_VAULT_INWARD.replace("#", sealNoNew.substring(1,sealNoNew.length())));
					pstmt.setString(1, "Inward");
					pstmt.setInt(2, systemId);
					pstmt.setInt(3, clientId);
					pstmt.setInt(4, rs.getInt("custId"));
					pstmt.setString(5, "SEALED BAG");
					pstmt.executeUpdate();
				}
				pstmt = con.prepareStatement(CashVanManagementStatements.GET_SEAL_NO_FROM_DISPENSE.replace("#", "TRIP_SHEET_NO=? and TRIP_STATUS='PENDING'"));
				pstmt.setInt(1, systemId);
				pstmt.setInt(2, clientId);
				pstmt.setString(3, tripSheetNo);
				pstmt.setString(4, "%Cheque%");
				rs = pstmt.executeQuery();
				while(rs.next()){
					String checkNoNew = "";
					String[] checkNo = rs.getString("sealNo").split(",");
					for(String s: checkNo){
						checkNoNew = checkNoNew+","+"'"+s+"'";
					}	
					pstmt = con.prepareStatement(CashVanManagementStatements.UPDATE_SEALBAG_STATUS_IN_VAULT_INWARD.replace("#", checkNoNew.substring(1,checkNoNew.length())));
					pstmt.setString(1, "Inward");
					pstmt.setInt(2, systemId);
					pstmt.setInt(3, clientId);
					pstmt.setInt(4, rs.getInt("custId"));
					pstmt.setString(5, "CHEQUE");
					pstmt.executeUpdate();
				}
				pstmt = con.prepareStatement(CashVanManagementStatements.GET_SEAL_NO_FROM_DISPENSE.replace("#", "TRIP_SHEET_NO=? and TRIP_STATUS='PENDING'"));
				pstmt.setInt(1, systemId);
				pstmt.setInt(2, clientId);
				pstmt.setString(3, tripSheetNo);
				pstmt.setString(4, "%Jewellery%");
				rs = pstmt.executeQuery();
				while(rs.next()){
					String jewelleryNoNew = "";
					String[] jewelleryNo = rs.getString("sealNo").split(",");
					for(String s: jewelleryNo){
						jewelleryNoNew = jewelleryNoNew+","+"'"+s+"'";
					}	
					pstmt = con.prepareStatement(CashVanManagementStatements.UPDATE_SEALBAG_STATUS_IN_VAULT_INWARD.replace("#", jewelleryNoNew.substring(1,jewelleryNoNew.length())));
					pstmt.setString(1, "Inward");
					pstmt.setInt(2, systemId);
					pstmt.setInt(3, clientId);
					pstmt.setInt(4, rs.getInt("custId"));
					pstmt.setString(5, "JEWELLERY");
					pstmt.executeUpdate();
				}
				pstmt = con.prepareStatement(CashVanManagementStatements.GET_SEAL_NO_FROM_DISPENSE.replace("#", "TRIP_SHEET_NO=? and TRIP_STATUS='PENDING'"));
				pstmt.setInt(1, systemId);
				pstmt.setInt(2, clientId);
				pstmt.setString(3, tripSheetNo);
				pstmt.setString(4, "%Foreign Currency%");
				rs = pstmt.executeQuery();
				while(rs.next()){
					String foreignNoNew = "";
					String[] foreignNo = rs.getString("sealNo").split(",");
					for(String s: foreignNo){
						foreignNoNew = foreignNoNew+","+"'"+s+"'";
					}	
					pstmt = con.prepareStatement(CashVanManagementStatements.UPDATE_SEALBAG_STATUS_IN_VAULT_INWARD.replace("#", foreignNoNew.substring(1,foreignNoNew.length())));
					pstmt.setString(1, "Inward");
					pstmt.setInt(2, systemId);
					pstmt.setInt(3, clientId);
					pstmt.setInt(4, rs.getInt("custId"));
					pstmt.setString(5, "FOREIGN CURRENCY");
					pstmt.executeUpdate();
				}
				pstmt = con.prepareStatement(CashVanManagementStatements.DELETE_EXISTING_DISPENSE_RECORD.replace("#", "TRIP_SHEET_NO=?"));
				pstmt.setInt(1, systemId);
				pstmt.setInt(2, clientId);
				pstmt.setString(3, tripSheetNo);
				pstmt.executeUpdate();
				
				/* VinLogic:- insert all json records to dispense and deduct from Vault inventory row wise*/
				for(int i = 0; i < js.length(); i++){
					obj = js.getJSONObject(i);
					pstmt = con.prepareStatement(CashVanManagementStatements.INSERT_CASH_DISPENSE1);
					pstmt.setInt(1, systemId);
					pstmt.setInt(2, clientId);
					pstmt.setInt(3, Integer.parseInt(obj.getString("UIDDI")));
					pstmt.setString(4,tripSheetNo);
					pstmt.setString(5, obj.getString("customerTypeDI"));
					pstmt.setInt(6, Integer.parseInt(obj.getString("customerIdDI")));
					pstmt.setString(7, date);
					pstmt.setInt(8, routeId);
					pstmt.setString(9, obj.getString("accOfDI"));
					pstmt.setString(10, obj.getString("sealedBagCashDI"));
					pstmt.setString(11, obj.getString("sealNoDI"));
					pstmt.setString(12, obj.getString("checkNoDI"));
					pstmt.setString(13, obj.getString("jewellaryNoDI"));
					pstmt.setString(14, obj.getString("foreignCurrencyDI"));
					pstmt.setLong(15, Long.parseLong(obj.getString("denom5000DI")));
					pstmt.setLong(16, Long.parseLong(obj.getString("denom2000DI")));
					pstmt.setLong(17, Long.parseLong(obj.getString("denom1000DI")));
					pstmt.setLong(18, Long.parseLong(obj.getString("denom500DI")));
					pstmt.setLong(19, Long.parseLong(obj.getString("denom100DI")));
					pstmt.setLong(20, Long.parseLong(obj.getString("denom50DI")));
					pstmt.setLong(21, Long.parseLong(obj.getString("denom20DI")));
					pstmt.setLong(22, Long.parseLong(obj.getString("denom10DI")));
					pstmt.setLong(23, Long.parseLong(obj.getString("denom5DI")));
					pstmt.setLong(24, Long.parseLong(obj.getString("denom2DI")));
					pstmt.setLong(25, Long.parseLong(obj.getString("denom1DI")));
					pstmt.setLong(26, Long.parseLong(obj.getString("denom050DI")));
					pstmt.setLong(26, Long.parseLong(obj.getString("denom025DI")));
					pstmt.setLong(27, Long.parseLong(obj.getString("denom010DI")));
					pstmt.setLong(28, Long.parseLong(obj.getString("denom005DI")));
					pstmt.setLong(29, Long.parseLong(obj.getString("denom002DI")));
					pstmt.setLong(30, Long.parseLong(obj.getString("denom001DI")));
					pstmt.setDouble(31, Double.parseDouble(obj.getString("totalSealAmntDI")));
					pstmt.setDouble(32, Double.parseDouble(obj.getString("totalCashAmntDI")));
					pstmt.setDouble(33, Double.parseDouble(obj.getString("totalCheckAmntDI")));
					pstmt.setDouble(34, Double.parseDouble(obj.getString("totalJewellaryAmntDI")));
					pstmt.setDouble(35, Double.parseDouble(obj.getString("totalForeignAmntDI")));
					pstmt.setDouble(36, Double.parseDouble(obj.getString("totalSealAmntDI")) + Double.parseDouble(obj.getString("totalCashAmntDI")) + Double.parseDouble(obj.getString("totalCheckAmntDI"))
										+ Double.parseDouble(obj.getString("totalJewellaryAmntDI")) + Double.parseDouble(obj.getString("totalForeignAmntDI")));
					pstmt.setString(37, "PENDING");
					pstmt.setString(38, "PENDING");
					pstmt.setString(39, obj.getString("deliveryCustomerDI"));
					pstmt.setString(40, obj.getString("cashDeliveryLocationDI"));
					pstmt.setInt(41, userId);
					inserted = pstmt.executeUpdate();
					if(obj.getString("customerTypeDI").equals("ATM Replenishment")){
						pstmt = con.prepareStatement(CashVanManagementStatements.UPDATE_VAULT_TRANSIT_ON_DISPENSE);
						pstmt.setLong(1, Long.parseLong(obj.getString("denom5000DI")));
						pstmt.setLong(2, Long.parseLong(obj.getString("denom2000DI")));
						pstmt.setLong(3, Long.parseLong(obj.getString("denom1000DI")));
						pstmt.setLong(4, Long.parseLong(obj.getString("denom500DI")));
						pstmt.setLong(5, Long.parseLong(obj.getString("denom100DI")));
						pstmt.setLong(6, Long.parseLong(obj.getString("denom50DI")));
						pstmt.setLong(7, Long.parseLong(obj.getString("denom20DI")));
						pstmt.setLong(8, Long.parseLong(obj.getString("denom10DI")));
						pstmt.setLong(9, Long.parseLong(obj.getString("denom5DI")));
						pstmt.setLong(10, Long.parseLong(obj.getString("denom2DI")));
						pstmt.setLong(11, Long.parseLong(obj.getString("denom1DI")));
						pstmt.setLong(12, Long.parseLong(obj.getString("denom050DI")));
						pstmt.setLong(13, Long.parseLong(obj.getString("denom025DI")));
						pstmt.setLong(14, Long.parseLong(obj.getString("denom010DI")));
						pstmt.setLong(15, Long.parseLong(obj.getString("denom005DI")));
						pstmt.setLong(16, Long.parseLong(obj.getString("denom002DI")));
						pstmt.setLong(17, Long.parseLong(obj.getString("denom001DI")));
						pstmt.setInt(18, systemId);
						pstmt.setInt(19, clientId);
						pstmt.setInt(20, Integer.parseInt(obj.getString("customerIdDI")));
						pstmt.executeUpdate();
					}
					if(obj.getString("customerTypeDI").equals("Cash Delivery")&& obj.getString("sealedBagCashDI").contains("Cash")){
						pstmt = con.prepareStatement(CashVanManagementStatements.UPDATE_VAULT_TRANSIT_ON_DISPENSE);
						pstmt.setLong(1, Long.parseLong(obj.getString("denom5000DI")));
						pstmt.setLong(2, Long.parseLong(obj.getString("denom2000DI")));
						pstmt.setLong(3, Long.parseLong(obj.getString("denom1000DI")));
						pstmt.setLong(4, Long.parseLong(obj.getString("denom500DI")));
						pstmt.setLong(5, Long.parseLong(obj.getString("denom100DI")));
						pstmt.setLong(6, Long.parseLong(obj.getString("denom50DI")));
						pstmt.setLong(7, Long.parseLong(obj.getString("denom20DI")));
						pstmt.setLong(8, Long.parseLong(obj.getString("denom10DI")));
						pstmt.setLong(9, Long.parseLong(obj.getString("denom5DI")));
						pstmt.setLong(10, Long.parseLong(obj.getString("denom2DI")));
						pstmt.setLong(11, Long.parseLong(obj.getString("denom1DI")));
						pstmt.setLong(12, Long.parseLong(obj.getString("denom050DI")));
						pstmt.setLong(13, Long.parseLong(obj.getString("denom025DI")));
						pstmt.setLong(14, Long.parseLong(obj.getString("denom010DI")));
						pstmt.setLong(15, Long.parseLong(obj.getString("denom005DI")));
						pstmt.setLong(16, Long.parseLong(obj.getString("denom002DI")));
						pstmt.setLong(17, Long.parseLong(obj.getString("denom001DI")));
						pstmt.setInt(18, systemId);
						pstmt.setInt(19, clientId);
						pstmt.setInt(20, Integer.parseInt(obj.getString("accOfDI")));
						pstmt.executeUpdate();
					}
					if(obj.getString("customerTypeDI").equals("Cash Delivery")&& obj.getString("sealedBagCashDI").contains("Sealed Bag")){
						String[]  sealNo = obj.getString("sealNoDI").split(",");
						String sealNumbers = "";
						for(String s:sealNo){
							sealNumbers = sealNumbers+","+"'"+s+"'";
						}
						pstmt = con.prepareStatement(CashVanManagementStatements.UPDATE_SEALBAG_STATUS_IN_VAULT_INWARD.replace("#", sealNumbers.substring(1, sealNumbers.length())));
						pstmt.setString(1, "DISPENSED");
						pstmt.setInt(2, systemId);
						pstmt.setInt(3, clientId);
						pstmt.setInt(4, Integer.parseInt(obj.getString("accOfDI")));
						pstmt.setString(5, "SEALED BAG");
						pstmt.executeUpdate();
					}
					if(obj.getString("customerTypeDI").equals("Cash Delivery")&& obj.getString("sealedBagCashDI").contains("Cheque")){
						String[]  checkNo = obj.getString("checkNoDI").split(",");
						String checkNumbers = "";
						for(String s:checkNo){
							checkNumbers = checkNumbers+","+"'"+s+"'";
						}
						pstmt = con.prepareStatement(CashVanManagementStatements.UPDATE_SEALBAG_STATUS_IN_VAULT_INWARD.replace("#", checkNumbers.substring(1, checkNumbers.length())));
						pstmt.setString(1, "DISPENSED");
						pstmt.setInt(2, systemId);
						pstmt.setInt(3, clientId);
						pstmt.setInt(4, Integer.parseInt(obj.getString("accOfDI")));
						pstmt.setString(5, "CHEQUE");
						pstmt.executeUpdate();
					}
					if(obj.getString("customerTypeDI").equals("Cash Delivery")&& obj.getString("sealedBagCashDI").contains("Jewellery")){
						String[]  jewelleryNo = obj.getString("jewellaryNoDI").split(",");
						String jewelleryNumbers = "";
						for(String s:jewelleryNo){
							jewelleryNumbers = jewelleryNumbers+","+"'"+s+"'";
						}
						pstmt = con.prepareStatement(CashVanManagementStatements.UPDATE_SEALBAG_STATUS_IN_VAULT_INWARD.replace("#", jewelleryNumbers.substring(1, jewelleryNumbers.length())));
						pstmt.setString(1, "DISPENSED");
						pstmt.setInt(2, systemId);
						pstmt.setInt(3, clientId);
						pstmt.setInt(4, Integer.parseInt(obj.getString("accOfDI")));
						pstmt.setString(5, "JEWELLERY");
						pstmt.executeUpdate();
					}
					if(obj.getString("customerTypeDI").equals("Cash Delivery")&& obj.getString("sealedBagCashDI").contains("Foreign Currency")){
						String[]  forignNo = obj.getString("foreignCurrencyDI").split(",");
						String foreignNumbers = "";
						for(String s:forignNo){
							foreignNumbers = foreignNumbers+","+"'"+s+"'";
						}
						pstmt = con.prepareStatement(CashVanManagementStatements.UPDATE_SEALBAG_STATUS_IN_VAULT_INWARD.replace("#", foreignNumbers.substring(1, foreignNumbers.length())));
						pstmt.setString(1, "DISPENSED");
						pstmt.setInt(2, systemId);
						pstmt.setInt(3, clientId);
						pstmt.setInt(4, Integer.parseInt(obj.getString("accOfDI")));
						pstmt.setString(5, "FOREIGN CURRENCY");
						pstmt.executeUpdate();
					}
				}
		}else{
			String customerName  = "";
			pstmt = con.prepareStatement(CashVanManagementStatements.GET_CUSTOMER_NAMES.replace("#", customerIds.substring(1, customerIds.length())));
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, clientId);
			rs = pstmt.executeQuery();
			while(rs.next()){
				customerName = customerName+","+rs.getString("customerName");
			}
			return msg = "Entered dispenses are exceeding over available dispenses for the customer - "+customerName;
		}
		if(inserted > 0){
			msg = "Success1";
		}else{
			msg = "Error while cash dipsensing...";
		}
	
	}catch(Exception e){
		e.printStackTrace();
		try{
			if(con != null){
				con.rollback();
			}
		}catch(Exception e1){
			e1.printStackTrace();
		}
	}finally{
		DBConnection.releaseConnectionToDB(con, pstmt, rs);
	}
	return msg;
}
public ArrayList<String> getDataBasedOnTripSheetNo(int systemId, int clientId, String tripSheetNo){
	Connection con = null;
	PreparedStatement pstmt = null;
	ResultSet rs =null;
	ArrayList<String> dataList = new ArrayList<String>();
	try{
		con = DBConnection.getConnectionToDB("AMS");
		pstmt = con.prepareStatement(CashVanManagementStatements.GET_ROUTE_DATE_DETAILS);
		pstmt.setInt(1, systemId);
		pstmt.setInt(2, clientId);
		pstmt.setString(3, tripSheetNo);
		rs = pstmt.executeQuery();
		if(rs.next()){
			dataList.add(rs.getString("routeId"));
			dataList.add(rs.getString("routeName"));
			dataList.add(ddmmyy.format(yyyymmdd.parse(rs.getString("date"))));
		}
	}catch(Exception e){
		e.printStackTrace();
	}finally{
		DBConnection.releaseConnectionToDB(con, pstmt, rs);
	}
	return dataList;
}

public ArrayList<String> getDataBasedOnTripSheetNo2(int systemId, int clientId, String tripSheetNo){
	Connection con = null;
	PreparedStatement pstmt = null;
	ResultSet rs =null;
	ArrayList<String> dataList = new ArrayList<String>();
	try{
		con = DBConnection.getConnectionToDB("AMS");
		pstmt = con.prepareStatement(CashVanManagementStatements.GET_ROUTE_DATE_DETAILS2);
		pstmt.setInt(1, systemId);
		pstmt.setInt(2, clientId);
		pstmt.setString(3, tripSheetNo);
		rs = pstmt.executeQuery();
		if(rs.next()){
			dataList.add(rs.getString("routeId"));
			dataList.add(rs.getString("routeName"));
			dataList.add(ddmmyy.format(yyyymmdd.parse(rs.getString("date"))));
			dataList.add(rs.getString("TripNo"));
		}
	}catch(Exception e){
		e.printStackTrace();
	}finally{
		DBConnection.releaseConnectionToDB(con, pstmt, rs);
	}
	return dataList;
}




public ArrayList < Object > getCashDespenseViewForReconcilation(int systemId, int clientId, int routeId, String tripSheetNo,
		String date, String btnValue) {
	Connection con = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	JSONArray jArray = new JSONArray();
	JSONObject obj = null;
	int count = 0;
	double totalSum=0;
	String liveStatus="Yet to complete";
	ArrayList<Object> finlist = new ArrayList<Object>();
	ArrayList<ReportHelper> reportsList = new ArrayList<ReportHelper>();
	ArrayList<String> headersList = new ArrayList<String>();
	ReportHelper finalreporthelper = new ReportHelper();
    try {
    	
    	headersList.add("SLNO");
    	headersList.add("UIDDI");
    	headersList.add("Business Type");
    	headersList.add("Status");
    	headersList.add("TR Number");
    	headersList.add("Customer Name");
    	headersList.add("Customer Id");
    	headersList.add("Business ID");
    	headersList.add("On Account Of");
    	headersList.add("Delivery Customer");
    	headersList.add("Seal Bag or Cash");
    	headersList.add("Location");
    	headersList.add("Seal Number");
		headersList.add("Cheque Number");
		headersList.add("Jewellery Number");
		headersList.add("Foreign Currency Ref Number");
		headersList.add("5000");
		headersList.add("2000");
		headersList.add("1000");
		headersList.add("500");
		headersList.add("100");
		headersList.add("50");
		headersList.add("20");
		headersList.add("10");
		headersList.add("5");
		headersList.add("2");
		headersList.add("1");
		headersList.add("050");
		headersList.add("025");
		headersList.add("010");
		headersList.add("005");
		headersList.add("002");
		headersList.add("001");
		headersList.add("Total Amount");
		headersList.add("Short/Excess Status");
		
		con = DBConnection.getConnectionToDB("AMS");

			pstmt = con.prepareStatement(CashVanManagementStatements.GET_CASH_DEPSENSE_DETAILS_FOR_RECONCILATION);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, clientId);
			pstmt.setInt(3, routeId);
			pstmt.setString(4, yyyymmdd.format(ddmmyy.parse(date)));
			pstmt.setString(5, tripSheetNo);
			
			rs = pstmt.executeQuery();
			while(rs.next()){
				ArrayList<Object> informationList = new ArrayList<Object>();
				ReportHelper reporthelper = new ReportHelper();
				count++;
				obj = new JSONObject();
				liveStatus="Yet to complete";				
				
				informationList.add(count);
				obj.put("slnoIndex", count);	

				informationList.add(rs.getInt("Id"));
				obj.put("UIDDI", rs.getInt("Id"));

				informationList.add( rs.getString("custType"));
				obj.put("customerTypeDI", rs.getString("custType"));
				
				if(!btnValue.equalsIgnoreCase("realData")){
					informationList.add(rs.getString("RECONCILE_STATUS"));
				obj.put("reconcileStatusDI", rs.getString("RECONCILE_STATUS"));
				}else{
					//System.out.println("---->"+rs.getString("CompleteStatus"));
					if(rs.getString("CompleteStatus").equalsIgnoreCase("Cash Picked")){
						liveStatus="In Progress";						
					}
					else if(rs.getString("CompleteStatus").equalsIgnoreCase("COMPLETED") || rs.getString("CompleteStatus").equalsIgnoreCase("CLOSED")){
						liveStatus="Completed";						
					}
					informationList.add(liveStatus);
					obj.put("reconcileStatusDI",liveStatus );
				}
					
				informationList.add(rs.getString("TR_NUMBER"));
				obj.put("trNumberDI", rs.getString("TR_NUMBER"));
				
				informationList.add( rs.getString("custName"));
				obj.put("customerNameDI", rs.getString("custName"));
				
				informationList.add(rs.getString("customerId"));
				obj.put("customerIdDI", rs.getString("customerId"));
				
				
				informationList.add(rs.getString("atmId"));
				obj.put("atmIdDI", rs.getString("atmId"));
				
				informationList.add(rs.getString("onAccOf"));
				obj.put("accOfDI", rs.getString("onAccOf"));
				
				informationList.add(rs.getString("DeliveryCustomer"));
				obj.put("delCustDI", rs.getString("DeliveryCustomer"));
				
				informationList.add(rs.getString("sealedOrCash"));
				obj.put("sealedBagCashDI", rs.getString("sealedOrCash"));
				
				informationList.add(rs.getString("location"));
				obj.put("locationDI", rs.getString("location"));
				
				informationList.add(rs.getString("sealNo"));
				obj.put("sealNoDI", rs.getString("sealNo"));
				
				informationList.add(rs.getString("CHECK_NO"));
				obj.put("checkNoDI", rs.getString("CHECK_NO"));
				
				informationList.add(rs.getString("JEWELLERY_REF"));
				obj.put("jewelleryNoDI", rs.getString("JEWELLERY_REF"));
				
				informationList.add( rs.getString("FOREX_REF"));
				obj.put("foreignCurrencyNoDI", rs.getString("FOREX_REF"));
				
				informationList.add(rs.getLong("denom5000"));
				obj.put("denom5000DI", rs.getLong("denom5000"));
				
				informationList.add(rs.getLong("denom2000"));
				obj.put("denom2000DI", rs.getLong("denom2000"));
				
				informationList.add(rs.getLong("denom1000"));
				obj.put("denom1000DI", rs.getLong("denom1000"));
				
				informationList.add(rs.getLong("denom500"));
				obj.put("denom500DI", rs.getLong("denom500"));
				
				informationList.add(rs.getLong("denom100"));
				obj.put("denom100DI", rs.getLong("denom100"));
				
				informationList.add( rs.getLong("denom50"));
				obj.put("denom50DI", rs.getLong("denom50"));
				
				informationList.add(rs.getLong("denom20"));
				obj.put("denom20DI", rs.getLong("denom20"));
				
				informationList.add(rs.getLong("denom10"));
				obj.put("denom10DI", rs.getLong("denom10"));
				
				informationList.add(rs.getLong("denom5"));
				obj.put("denom5DI", rs.getLong("denom5"));
				
				informationList.add(rs.getLong("denom2"));
				obj.put("denom2DI", rs.getLong("denom2"));
				
				informationList.add(rs.getLong("denom1"));
				obj.put("denom1DI", rs.getLong("denom1"));
				
				informationList.add(rs.getLong("denom050"));
				obj.put("denom050DI", rs.getLong("denom050"));
				
				informationList.add(rs.getLong("denom025"));
				obj.put("denom025DI", rs.getLong("denom025"));
				
				informationList.add(rs.getLong("denom010"));
				obj.put("denom010DI", rs.getLong("denom010"));
				
				informationList.add(rs.getLong("denom005"));
				obj.put("denom005DI", rs.getLong("denom005"));
				
				informationList.add(rs.getLong("denom002"));
				obj.put("denom002DI", rs.getLong("denom002"));
				
				informationList.add(rs.getLong("denom001"));
				obj.put("denom001DI", rs.getLong("denom001"));
				
				informationList.add(String.format("%.2f",rs.getDouble("totalAmount")));
				obj.put("totalAmntDI", String.format("%.2f",rs.getDouble("totalAmount")));
				
				informationList.add(rs.getString("shortExcessStatus"));
				obj.put("shortExcessStausDI", rs.getString("shortExcessStatus"));
				if(btnValue.equalsIgnoreCase("realData")){
					if( (rs.getString("custType").equalsIgnoreCase("ATM Replenishment")) && liveStatus.equalsIgnoreCase("Yet to complete") ){
						totalSum=totalSum+rs.getDouble("totalAmount");
					}else if( (rs.getString("custType").equalsIgnoreCase("Cash Delivery")) && liveStatus.equalsIgnoreCase("Yet to complete") ){
						totalSum=totalSum+rs.getDouble("totalAmount");
					}else if( (rs.getString("custType").equalsIgnoreCase("ATM Deposit")) && liveStatus.equalsIgnoreCase("Yet to complete") ){
						totalSum=totalSum+rs.getDouble("totalAmount");
					}else if( (rs.getString("custType").equalsIgnoreCase("Cash Pickup")) && liveStatus.equalsIgnoreCase("Completed") ){
						totalSum=totalSum+rs.getDouble("totalAmount");
					}else if( (rs.getString("custType").equalsIgnoreCase("Cash Transfer")) && liveStatus.equalsIgnoreCase("In Progress") ){
						totalSum=totalSum+rs.getDouble("totalAmount");
					}
					if(totalSum<0){
						totalSum=0;
					}			
				}
				
				jArray.put(obj);
				reporthelper.setInformationList(informationList);
				reportsList.add(reporthelper);			
			}
			if(jArray.length()>0 && btnValue.equalsIgnoreCase("realData")){
				ArrayList<Object> informationList = new ArrayList<Object>();
				ReportHelper reporthelper = new ReportHelper();
				int a=++count;
				obj = new JSONObject();
				obj.put("slnoIndex",a);
				informationList.add(a);
				obj.put("UIDDI", 0);
				informationList.add(0);
				obj.put("customerTypeDI", "<b> <p style=color:DodgerBlue;>Total Amount </p></b>");
				informationList.add("Total Amount");
				obj.put("reconcileStatusDI","<b> <p style=color:DodgerBlue;>"+ String.format("%.2f",totalSum) +" </p> </b>");
				informationList.add(String.format("%.2f",totalSum) );
				informationList.add("");
				informationList.add("");
				informationList.add("");
				informationList.add("");
				informationList.add("");
				informationList.add("");
				informationList.add("");
				informationList.add("");
				informationList.add("");
				informationList.add("");
				informationList.add("");
				informationList.add("");
				informationList.add("");
				informationList.add("");
				informationList.add("");
				informationList.add("");
				informationList.add("");
				informationList.add("");
				informationList.add("");
				informationList.add("");
				informationList.add("");
				informationList.add("");
				informationList.add("");
				informationList.add("");
				informationList.add("");
				informationList.add("");
				informationList.add("");
				informationList.add("");
				informationList.add("");
				informationList.add("");
				informationList.add("");
				jArray.put(obj);
				reporthelper.setInformationList(informationList);
				reportsList.add(reporthelper);			
				}
			finalreporthelper.setReportsList(reportsList);
			finalreporthelper.setHeadersList(headersList);
			finlist.add(jArray);
			finlist.add(finalreporthelper);					
		
	}catch(Exception e){
	 	e.printStackTrace();
	}finally{
		DBConnection.releaseConnectionToDB(con, pstmt, rs);
	}
	//System.err.println(finalreporthelper);
	return finlist;
	
}

public ArrayList<String> getDataForReconcilation(int systemId,int customerId,String tripSheetNo,int UniqueId){
	Connection con = null;
	PreparedStatement pstmt = null;
	ResultSet rs =null;
	ArrayList<String> dataList = new ArrayList<String>();
	String customer = "";
	String sealNo = "";
	String totalAmount = "";
	String date = "";
	String customerType="";
	String atmId = ""; 
	String tripNo ="";
	String cashType = "";
	String cvsCustId = "0";
	String routeId = "0";
	String onaccOf = "0";
	String businessId = "";
	String checkNo = "";
	String jewNo = "";
	String forexNo = "";
	try{
		con = DBConnection.getConnectionToDB("AMS");
		pstmt = con.prepareStatement(CashVanManagementStatements.GET_RECONCILATION_DETAILS);
		pstmt.setInt(1, systemId);
		pstmt.setInt(2, customerId);
		pstmt.setString(3, tripSheetNo);
		pstmt.setInt(4, UniqueId);
		rs = pstmt.executeQuery();
		if(rs.next()){
			 cvsCustId = rs.getString("CVS_CUSTOMER_ID");
			 customer = rs.getString("CUSTOMER_NAME");
			 sealNo = rs.getString("SEAL_NO");
			 totalAmount =rs.getString("TOTAL_AMOUNT");
			 date = ddmmyy.format(yyyymmdd.parse(rs.getString("DATE")));
			 customerType=rs.getString("CUSTOMER_TYPE");
			 atmId =rs.getString("BUSINESS_ID");
			 tripNo =rs.getString("TRIP_ID");
			 if(rs.getString("SEALED_OR_CASH").equals("")|| rs.getString("SEALED_OR_CASH").equalsIgnoreCase("Cash") ){
				 cashType = "CASH"; 
			 }else{
				 cashType = rs.getString("SEALED_OR_CASH").toUpperCase(); 
			 }
			
			 routeId = rs.getString("ROUTE_ID");
			 onaccOf = rs.getString("ON_ACC_OF");
			 businessId = rs.getString("businessId");
			 String cashSealNo = rs.getString("CASH_SEAL_NO");
			 checkNo = rs.getString("CHECK_NO");
			 jewNo = rs.getString("JEWELLERY_REF");
			 forexNo = rs.getString("FOREX_REF");
			dataList.add(customer);
			dataList.add(sealNo);			
			dataList.add(totalAmount);
			dataList.add(date);
			dataList.add(customerType);
			dataList.add(atmId);
			dataList.add(tripNo);
			dataList.add(cashType);
			dataList.add(cvsCustId);
			dataList.add(routeId);
			dataList.add(rs.getString("DATE"));
			dataList.add(onaccOf);
			dataList.add(businessId);
			dataList.add(cashSealNo);
			dataList.add(checkNo);
			dataList.add(jewNo);
			dataList.add(forexNo);
		}
	}catch(Exception e){
		e.printStackTrace();
	}finally{
		DBConnection.releaseConnectionToDB(con, pstmt, rs);
	}
	return dataList;
}


public String saveDenominationForReconcilation(String tripSheetNo,int uniqueId,int systemId,int custId,String s,int userId,String cashType2,String totalAmount2,String keyPressed,String CashSealNo){

	Connection con = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    JSONArray jsonArray = new JSONArray();
   
    String message ="";
    long twothGoodNo = 0;  
    long onethGoodNo = 0;
    long fiveHunGoodNo=0;
    long oneHunGoodNo=0;


    long twothBadNo = 0;
    long onethBadNo = 0;
    long fiveHunBadNo=0;
    long oneHunBadNo=0;


    long twothSoiledNo = 0;
    long onethSoiledNo = 0;
    long fiveHunSoiledNo=0;
    long oneHunSoiledNo=0;


    long twothCounterNo = 0;
    long onethCounterNo = 0;
    long fiveHunCounterNo=0;
    long oneHunCounterNo=0; 
  
    long fivethGoodNo = 0;  
    long fivethBadNo = 0;
    long fivethSoiledNo=0;
    long fivethCounterNo=0;
    
    long fiftyGoodNo = 0;  
    long fiftyBadNo = 0;
    long fiftySoiledNo=0;
    long fiftyCounterNo=0;
    
    long twentyGoodNo = 0;  
    long twentyBadNo = 0;
    long twentySoiledNo=0;
    long twentyCounterNo=0;
    
    long tenGoodNo = 0;  
    long tenBadNo = 0;
    long tenSoiledNo=0;
    long tenCounterNo=0;
    
    long fiveGoodNo = 0;  
    long fiveBadNo = 0;
    long fiveSoiledNo=0;
    long fiveCounterNo=0;
    
    long twoGoodNo = 0;  
    long twoBadNo = 0;
    long twoSoiledNo=0;
    long twoCounterNo=0;
    
    long oneGoodNo = 0;  
    long oneBadNo = 0;
    long oneSoiledNo=0;
    long oneCounterNo=0;
    
    double totalAmount = 0;
    int sysGeneratedId =0;
    String cashCondition ="GOOD";
    
    String inwardMode= "TRIP";
    String reconciledDate = "";
    int cVSCustId = 0;
    String sealNo = "";
    String cashType="";
    int onaccoff = 0;
    String customerType = "";
   // double sealedTotalAmount=0.0;
    String jewNo = "";
    String checkNo = "";
    String forexNo = "";
    ArrayList<String> dataList = getDataForReconcilation(systemId,custId,tripSheetNo,uniqueId);
    cVSCustId = Integer.parseInt(dataList.get(8));
	 sealNo = dataList.get(1);
	 //sealedTotalAmount = Double.parseDouble(dataList.get(2));
	 reconciledDate =dataList.get(10);
	 cashType = dataList.get(7);
	 onaccoff = Integer.parseInt(dataList.get(11));
	 customerType = dataList.get(4);
	 checkNo =  dataList.get(14);
	 jewNo = dataList.get(15);
	 forexNo =  dataList.get(16);
    try {
        con = DBConnection.getConnectionToDB("AMS");
        if (s != null) {
            String st = "[" + s + "]";
        	jsonArray = new JSONArray(st.toString());
    	} 
    
       for(int i =0; i<jsonArray.length(); i++){
    	   JSONObject obj = jsonArray.getJSONObject(i);
    	  
    	   
    	   if(obj.getInt("DenominationDataIndex")== 5000){
    		 
    		    fivethGoodNo = obj.getLong("GoodNoOfNotesDataIndex"); 
    		    fivethBadNo =  obj.getLong("BadNoOfNotesDataIndex"); 
    		    fivethSoiledNo = obj.getLong("SoiledNoOfNotesDataIndex"); 
    		    fivethCounterNo = obj.getLong("CounterfeitNoOfNotesDataIndex"); 
			   totalAmount =totalAmount+ (fivethGoodNo*5000)+(fivethBadNo*5000)+(fivethSoiledNo*5000)+(fivethCounterNo*5000);
			}
    	  
			if(obj.getInt("DenominationDataIndex")== 2000){
				twothGoodNo = obj.getLong("GoodNoOfNotesDataIndex"); 
				twothBadNo = obj.getLong("BadNoOfNotesDataIndex"); 
				twothSoiledNo = obj.getLong("SoiledNoOfNotesDataIndex"); 
				twothCounterNo = obj.getLong("CounterfeitNoOfNotesDataIndex"); 
				totalAmount =totalAmount+ (twothGoodNo*2000)+(twothBadNo*2000)+(twothSoiledNo*2000)+(twothCounterNo*2000);
			}
			if(obj.getInt("DenominationDataIndex")== 1000){
				onethGoodNo = obj.getLong("GoodNoOfNotesDataIndex"); 
				onethBadNo = obj.getLong("BadNoOfNotesDataIndex"); 
				onethSoiledNo = obj.getLong("SoiledNoOfNotesDataIndex"); 
				onethCounterNo = obj.getLong("CounterfeitNoOfNotesDataIndex"); 
				totalAmount =totalAmount+ (onethGoodNo*1000)+(onethBadNo*1000)+(onethSoiledNo*1000)+(onethCounterNo*1000);

			}
			if(obj.getInt("DenominationDataIndex")== 500){
				fiveHunGoodNo = obj.getLong("GoodNoOfNotesDataIndex"); 
				fiveHunBadNo = obj.getLong("BadNoOfNotesDataIndex"); 
				fiveHunSoiledNo = obj.getLong("SoiledNoOfNotesDataIndex"); 
				fiveHunCounterNo = obj.getLong("CounterfeitNoOfNotesDataIndex"); 
				totalAmount =totalAmount+ (fiveHunGoodNo*500)+(fiveHunBadNo*500)+(fiveHunSoiledNo*500)+(fiveHunCounterNo*500);

			}
			if(obj.getInt("DenominationDataIndex")== 100){
				oneHunGoodNo = obj.getLong("GoodNoOfNotesDataIndex"); 
				oneHunBadNo = obj.getLong("BadNoOfNotesDataIndex"); 
				oneHunSoiledNo = obj.getLong("SoiledNoOfNotesDataIndex"); 
				oneHunCounterNo = obj.getLong("CounterfeitNoOfNotesDataIndex");
				totalAmount =totalAmount+ (oneHunGoodNo*100)+(oneHunBadNo*100)+(oneHunSoiledNo*100)+(oneHunCounterNo*100);

			}
			
			if(obj.getInt("DenominationDataIndex")== 50){
				fiftyGoodNo = obj.getLong("GoodNoOfNotesDataIndex"); 
				fiftyBadNo = obj.getLong("BadNoOfNotesDataIndex"); 
				fiftySoiledNo = obj.getLong("SoiledNoOfNotesDataIndex"); 
				fiftyCounterNo = obj.getLong("CounterfeitNoOfNotesDataIndex");
				totalAmount =totalAmount+ (fiftyGoodNo*50)+(fiftyBadNo*50)+(fiftySoiledNo*50)+(fiftyCounterNo*50);

			}
			
			if(obj.getInt("DenominationDataIndex")== 20){
				twentyGoodNo = obj.getLong("GoodNoOfNotesDataIndex"); 
				twentyBadNo = obj.getLong("BadNoOfNotesDataIndex"); 
				twentySoiledNo = obj.getLong("SoiledNoOfNotesDataIndex"); 
				twentyCounterNo = obj.getLong("CounterfeitNoOfNotesDataIndex");
				totalAmount =totalAmount+ (twentyGoodNo*20)+(twentyBadNo*20)+(twentySoiledNo*20)+(twentyCounterNo*20);

			}
			
			if(obj.getInt("DenominationDataIndex")== 10){
				tenGoodNo = obj.getLong("GoodNoOfNotesDataIndex"); 
				tenBadNo = obj.getLong("BadNoOfNotesDataIndex"); 
				tenSoiledNo = obj.getLong("SoiledNoOfNotesDataIndex"); 
				tenCounterNo = obj.getLong("CounterfeitNoOfNotesDataIndex");
				totalAmount =totalAmount+ (tenGoodNo*10)+(tenBadNo*10)+(tenSoiledNo*10)+(tenCounterNo*10);

			}
			if(obj.getInt("DenominationDataIndex")== 5){
				fiveGoodNo = obj.getLong("GoodNoOfNotesDataIndex"); 
				fiveBadNo = obj.getLong("BadNoOfNotesDataIndex"); 
				fiveSoiledNo = obj.getLong("SoiledNoOfNotesDataIndex"); 
				fiveCounterNo = obj.getLong("CounterfeitNoOfNotesDataIndex");
				totalAmount =totalAmount+ (fiveGoodNo*5)+(fiveBadNo*5)+(fiveSoiledNo*5)+(fiveCounterNo*5);

			}
			if(obj.getInt("DenominationDataIndex")== 2){
				twoGoodNo = obj.getLong("GoodNoOfNotesDataIndex"); 
				twoBadNo = obj.getLong("BadNoOfNotesDataIndex"); 
				twoSoiledNo = obj.getLong("SoiledNoOfNotesDataIndex"); 
				twoCounterNo = obj.getLong("CounterfeitNoOfNotesDataIndex");
				totalAmount =totalAmount+ (twoGoodNo*2)+(twoBadNo*2)+(twoSoiledNo*2)+(twoCounterNo*2);

			}
			if(obj.getInt("DenominationDataIndex")== 1){
				oneGoodNo = obj.getLong("GoodNoOfNotesDataIndex"); 
				oneBadNo = obj.getLong("BadNoOfNotesDataIndex"); 
				oneSoiledNo = obj.getLong("SoiledNoOfNotesDataIndex"); 
				oneCounterNo = obj.getLong("CounterfeitNoOfNotesDataIndex");
				totalAmount =totalAmount+ (oneGoodNo*1)+(oneBadNo*1)+(oneSoiledNo*1)+(oneCounterNo*1);

			}
       }
       int rows = 0;
       double totalAmountForSlNo = 0.0;      
if(cashType.contains("SEALED BAG")){
    	  // totalAmount = Double.parseDouble(totalAmount2) ; 
    	  if(customerType.equalsIgnoreCase("Cash Delivery")){
    		  if(keyPressed.equalsIgnoreCase("No")){
  		   	
    	  if(sealNo.contains(",")){
    		  String sealNos[] = sealNo.split(",");
    		  for(String sl: sealNos){
    			String sealNoNew = sl;
    			pstmt = con.prepareStatement(CashVanManagementStatements.GET_SEAL_NO_AMOUNT);  
    			pstmt.setInt(1, onaccoff);
    		   	pstmt.setString(2, sealNoNew.toUpperCase());    		   
    		   	pstmt.setInt(3, systemId);
    			pstmt.setInt(4, custId);
    		   	rs= pstmt.executeQuery();
    		   	if(rs.next()){
    		   	
    		    pstmt = con.prepareStatement(CashVanManagementStatements.UPDATE_CASH_INWARD_DETAILS_FOR_RECONCILATION);
    		   	pstmt.setString(1, inwardMode);
    		 	pstmt.setString(2, tripSheetNo);
    		   	pstmt.setString(3, reconciledDate);
    		   	pstmt.setInt(4, uniqueId);
    		   	pstmt.setInt(5, onaccoff);
    		   	pstmt.setString(6, sealNoNew);
    		 	pstmt.setInt(7, systemId);
    		   	pstmt.setInt(8, custId);	  
    		   	rows = pstmt.executeUpdate(); 
    		  }
    		  }
    	  }else{
    		  
    		pstmt = con.prepareStatement(CashVanManagementStatements.GET_SEAL_NO_AMOUNT);  
  			pstmt.setInt(1, onaccoff);
  		   	pstmt.setString(2, sealNo.toUpperCase());    		   
  		   	pstmt.setInt(3, systemId);
  			pstmt.setInt(4, custId);
  		   	rs= pstmt.executeQuery();
    		if(rs.next()){  
    		    pstmt = con.prepareStatement(CashVanManagementStatements.UPDATE_CASH_INWARD_DETAILS_FOR_RECONCILATION);
    		   	pstmt.setString(1, inwardMode);
    		 	pstmt.setString(2, tripSheetNo);
    		   	pstmt.setString(3, reconciledDate);
    		   	pstmt.setInt(4, uniqueId);
    		   	pstmt.setInt(5, onaccoff);
    		   	pstmt.setString(6, sealNo);
    		 	pstmt.setInt(7, systemId);
    		   	pstmt.setInt(8, custId);	  
    		   	rows = pstmt.executeUpdate();
    	  }
    	  }
    	  }else{
    		  rows = 1;
    	  }
}else{

	 if(sealNo.contains(",")){
		  String sealNos[] = sealNo.split(",");
		  for(String sl: sealNos){
			String sealNoNew = sl;
			pstmt = con.prepareStatement(CashVanManagementStatements.GET_SEAL_NO_AMOUNT);  
			pstmt.setInt(1, cVSCustId);
		   	pstmt.setString(2, sealNoNew.toUpperCase());    		   
		   	pstmt.setInt(3, systemId);
			pstmt.setInt(4, custId);
		   	rs= pstmt.executeQuery();
		   	if(rs.next()){
		   	
		    pstmt = con.prepareStatement(CashVanManagementStatements.UPDATE_CASH_INWARD_DETAILS_FOR_RECONCILATION);
		   	pstmt.setString(1, inwardMode);
		 	pstmt.setString(2, tripSheetNo);
		   	pstmt.setString(3, reconciledDate);
		   	pstmt.setInt(4, uniqueId);
		   	pstmt.setInt(5, cVSCustId);
		   	pstmt.setString(6, sealNoNew);
		 	pstmt.setInt(7, systemId);
		   	pstmt.setInt(8, custId);	  
		   	rows = pstmt.executeUpdate(); 
		  }
		  }
	  }else{
		  
		pstmt = con.prepareStatement(CashVanManagementStatements.GET_SEAL_NO_AMOUNT);  
			pstmt.setInt(1, cVSCustId);
		   	pstmt.setString(2, sealNo.toUpperCase());    		   
		   	pstmt.setInt(3, systemId);
			pstmt.setInt(4, custId);
		   	rs= pstmt.executeQuery();
		if(rs.next()){  
		    pstmt = con.prepareStatement(CashVanManagementStatements.UPDATE_CASH_INWARD_DETAILS_FOR_RECONCILATION);
		   	pstmt.setString(1, inwardMode);
		 	pstmt.setString(2, tripSheetNo);
		   	pstmt.setString(3, reconciledDate);
		   	pstmt.setInt(4, uniqueId);
		   	pstmt.setInt(5, cVSCustId);
		   	pstmt.setString(6, sealNo);
		 	pstmt.setInt(7, systemId);
		   	pstmt.setInt(8, custId);	  
		   	rows = pstmt.executeUpdate();
	  }
	  }	 
}
       }

if(cashType.contains("CHEQUE")){
	  // totalAmount = Double.parseDouble(totalAmount2) ; 
	  if(customerType.equalsIgnoreCase("Cash Delivery")){
		  if(keyPressed.equalsIgnoreCase("No")){
	   	
	  if(checkNo.contains(",")){
		  String checkNos[] = checkNo.split(",");
		  for(String sl: checkNos){
			String checkNoNew = sl;
			pstmt = con.prepareStatement(CashVanManagementStatements.GET_CHECK_AMOUNT);  
			pstmt.setInt(1, onaccoff);
		   	pstmt.setString(2, checkNoNew.toUpperCase());    		   
		   	pstmt.setInt(3, systemId);
			pstmt.setInt(4, custId);
		   	rs= pstmt.executeQuery();
		   	if(rs.next()){
		   	
		    pstmt = con.prepareStatement(CashVanManagementStatements.UPDATE_CASH_INWARD_DETAILS_FOR_RECONCILATION);
		   	pstmt.setString(1, inwardMode);
		 	pstmt.setString(2, tripSheetNo);
		   	pstmt.setString(3, reconciledDate);
		   	pstmt.setInt(4, uniqueId);
		   	pstmt.setInt(5, onaccoff);
		   	pstmt.setString(6, checkNo);
		 	pstmt.setInt(7, systemId);
		   	pstmt.setInt(8, custId);	  
		   	rows = pstmt.executeUpdate(); 
		  }
		  }
	  }else{
		  
		pstmt = con.prepareStatement(CashVanManagementStatements.GET_CHECK_AMOUNT);  
		pstmt.setInt(1, onaccoff);
	   	pstmt.setString(2, sealNo.toUpperCase());    		   
	   	pstmt.setInt(3, systemId);
		pstmt.setInt(4, custId);
	   	rs= pstmt.executeQuery();
		if(rs.next()){  
		    pstmt = con.prepareStatement(CashVanManagementStatements.UPDATE_CASH_INWARD_DETAILS_FOR_RECONCILATION);
		   	pstmt.setString(1, inwardMode);
		 	pstmt.setString(2, tripSheetNo);
		   	pstmt.setString(3, reconciledDate);
		   	pstmt.setInt(4, uniqueId);
		   	pstmt.setInt(5, onaccoff);
		   	pstmt.setString(6, checkNo);
		 	pstmt.setInt(7, systemId);
		   	pstmt.setInt(8, custId);	  
		   	rows = pstmt.executeUpdate();
	  }
	  }
	  }else{
		  rows = 1;
	  }
}else{

if(checkNo.contains(",")){
	  String checkNos[] = checkNo.split(",");
	  for(String sl: checkNos){
		String checkNoNew = sl;
		pstmt = con.prepareStatement(CashVanManagementStatements.GET_CHECK_AMOUNT);  
		pstmt.setInt(1, cVSCustId);
	   	pstmt.setString(2, checkNoNew.toUpperCase());    		   
	   	pstmt.setInt(3, systemId);
		pstmt.setInt(4, custId);
	   	rs= pstmt.executeQuery();
	   	if(rs.next()){
	   	
	    pstmt = con.prepareStatement(CashVanManagementStatements.UPDATE_CASH_INWARD_DETAILS_FOR_RECONCILATION);
	   	pstmt.setString(1, inwardMode);
	 	pstmt.setString(2, tripSheetNo);
	   	pstmt.setString(3, reconciledDate);
	   	pstmt.setInt(4, uniqueId);
	   	pstmt.setInt(5, cVSCustId);
	   	pstmt.setString(6, checkNoNew);
	 	pstmt.setInt(7, systemId);
	   	pstmt.setInt(8, custId);	  
	   	rows = pstmt.executeUpdate(); 
	  }
	  }
}else{
	  
	pstmt = con.prepareStatement(CashVanManagementStatements.GET_CHECK_AMOUNT);  
		pstmt.setInt(1, cVSCustId);
	   	pstmt.setString(2, checkNo.toUpperCase());    		   
	   	pstmt.setInt(3, systemId);
		pstmt.setInt(4, custId);
	   	rs= pstmt.executeQuery();
	if(rs.next()){  
	    pstmt = con.prepareStatement(CashVanManagementStatements.UPDATE_CASH_INWARD_DETAILS_FOR_RECONCILATION);
	   	pstmt.setString(1, inwardMode);
	 	pstmt.setString(2, tripSheetNo);
	   	pstmt.setString(3, reconciledDate);
	   	pstmt.setInt(4, uniqueId);
	   	pstmt.setInt(5, cVSCustId);
	   	pstmt.setString(6, checkNo);
	 	pstmt.setInt(7, systemId);
	   	pstmt.setInt(8, custId);	  
	   	rows = pstmt.executeUpdate();
}
}	 
}
}




if(cashType.contains("JEWELLERY")){
	  // totalAmount = Double.parseDouble(totalAmount2) ; 
	  if(customerType.equalsIgnoreCase("Cash Delivery")){
		  if(keyPressed.equalsIgnoreCase("No")){
	   	
	  if(jewNo.contains(",")){
		  String jewNos[] = jewNo.split(",");
		  for(String sl: jewNos){
			String jewNoNew = sl;
			pstmt = con.prepareStatement(CashVanManagementStatements.GET_JEWELLERY_AMOUNT);  
			pstmt.setInt(1, onaccoff);
		   	pstmt.setString(2, jewNoNew.toUpperCase());    		   
		   	pstmt.setInt(3, systemId);
			pstmt.setInt(4, custId);
		   	rs= pstmt.executeQuery();
		   	if(rs.next()){
		   	
		    pstmt = con.prepareStatement(CashVanManagementStatements.UPDATE_CASH_INWARD_DETAILS_FOR_RECONCILATION);
		   	pstmt.setString(1, inwardMode);
		 	pstmt.setString(2, tripSheetNo);
		   	pstmt.setString(3, reconciledDate);
		   	pstmt.setInt(4, uniqueId);
		   	pstmt.setInt(5, onaccoff);
		   	pstmt.setString(6, jewNo);
		 	pstmt.setInt(7, systemId);
		   	pstmt.setInt(8, custId);	  
		   	rows = pstmt.executeUpdate(); 
		  }
		  }
	  }else{
		  
		pstmt = con.prepareStatement(CashVanManagementStatements.GET_JEWELLERY_AMOUNT);  
		pstmt.setInt(1, onaccoff);
	   	pstmt.setString(2, jewNo.toUpperCase());    		   
	   	pstmt.setInt(3, systemId);
		pstmt.setInt(4, custId);
	   	rs= pstmt.executeQuery();
		if(rs.next()){  
		    pstmt = con.prepareStatement(CashVanManagementStatements.UPDATE_CASH_INWARD_DETAILS_FOR_RECONCILATION);
		   	pstmt.setString(1, inwardMode);
		 	pstmt.setString(2, tripSheetNo);
		   	pstmt.setString(3, reconciledDate);
		   	pstmt.setInt(4, uniqueId);
		   	pstmt.setInt(5, onaccoff);
		   	pstmt.setString(6, jewNo);
		 	pstmt.setInt(7, systemId);
		   	pstmt.setInt(8, custId);	  
		   	rows = pstmt.executeUpdate();
	  }
	  }
	  }else{
		  rows = 1;
	  }
}else{

if(jewNo.contains(",")){
	  String jewNos[] = jewNo.split(",");
	  for(String sl: jewNos){
		String jewNoNew = sl;
		pstmt = con.prepareStatement(CashVanManagementStatements.GET_JEWELLERY_AMOUNT);  
		pstmt.setInt(1, cVSCustId);
	   	pstmt.setString(2, jewNoNew.toUpperCase());    		   
	   	pstmt.setInt(3, systemId);
		pstmt.setInt(4, custId);
	   	rs= pstmt.executeQuery();
	   	if(rs.next()){
	   	
	    pstmt = con.prepareStatement(CashVanManagementStatements.UPDATE_CASH_INWARD_DETAILS_FOR_RECONCILATION);
	   	pstmt.setString(1, inwardMode);
	 	pstmt.setString(2, tripSheetNo);
	   	pstmt.setString(3, reconciledDate);
	   	pstmt.setInt(4, uniqueId);
	   	pstmt.setInt(5, cVSCustId);
	   	pstmt.setString(6, jewNoNew);
	 	pstmt.setInt(7, systemId);
	   	pstmt.setInt(8, custId);	  
	   	rows = pstmt.executeUpdate(); 
	  }
	  }
}else{
	  
	pstmt = con.prepareStatement(CashVanManagementStatements.GET_JEWELLERY_AMOUNT);  
		pstmt.setInt(1, cVSCustId);
	   	pstmt.setString(2, jewNo.toUpperCase());    		   
	   	pstmt.setInt(3, systemId);
		pstmt.setInt(4, custId);
	   	rs= pstmt.executeQuery();
	if(rs.next()){  
	    pstmt = con.prepareStatement(CashVanManagementStatements.UPDATE_CASH_INWARD_DETAILS_FOR_RECONCILATION);
	   	pstmt.setString(1, inwardMode);
	 	pstmt.setString(2, tripSheetNo);
	   	pstmt.setString(3, reconciledDate);
	   	pstmt.setInt(4, uniqueId);
	   	pstmt.setInt(5, cVSCustId);
	   	pstmt.setString(6, jewNo);
	 	pstmt.setInt(7, systemId);
	   	pstmt.setInt(8, custId);	  
	   	rows = pstmt.executeUpdate();
}
}	 
}
}



if(cashType.contains("FOREIGN CURRENCY")){
	  // totalAmount = Double.parseDouble(totalAmount2) ; 
	  if(customerType.equalsIgnoreCase("Cash Delivery")){
		  if(keyPressed.equalsIgnoreCase("No")){
	   	
	  if(forexNo.contains(",")){
		  String forexNos[] = forexNo.split(",");
		  for(String sl: forexNos){
			String forexNoNew = sl;
			pstmt = con.prepareStatement(CashVanManagementStatements.GET_FOREX_AMOUNT);  
			pstmt.setInt(1, onaccoff);
		   	pstmt.setString(2, forexNoNew.toUpperCase());    		   
		   	pstmt.setInt(3, systemId);
			pstmt.setInt(4, custId);
		   	rs= pstmt.executeQuery();
		   	if(rs.next()){
		   	
		    pstmt = con.prepareStatement(CashVanManagementStatements.UPDATE_CASH_INWARD_DETAILS_FOR_RECONCILATION);
		   	pstmt.setString(1, inwardMode);
		 	pstmt.setString(2, tripSheetNo);
		   	pstmt.setString(3, reconciledDate);
		   	pstmt.setInt(4, uniqueId);
		   	pstmt.setInt(5, onaccoff);
		   	pstmt.setString(6, forexNo);
		 	pstmt.setInt(7, systemId);
		   	pstmt.setInt(8, custId);	  
		   	rows = pstmt.executeUpdate(); 
		  }
		  }
	  }else{
		  
		pstmt = con.prepareStatement(CashVanManagementStatements.GET_FOREX_AMOUNT);  
		pstmt.setInt(1, onaccoff);
	   	pstmt.setString(2, forexNo.toUpperCase());    		   
	   	pstmt.setInt(3, systemId);
		pstmt.setInt(4, custId);
	   	rs= pstmt.executeQuery();
		if(rs.next()){  
		    pstmt = con.prepareStatement(CashVanManagementStatements.UPDATE_CASH_INWARD_DETAILS_FOR_RECONCILATION);
		   	pstmt.setString(1, inwardMode);
		 	pstmt.setString(2, tripSheetNo);
		   	pstmt.setString(3, reconciledDate);
		   	pstmt.setInt(4, uniqueId);
		   	pstmt.setInt(5, onaccoff);
		   	pstmt.setString(6, forexNo);
		 	pstmt.setInt(7, systemId);
		   	pstmt.setInt(8, custId);	  
		   	rows = pstmt.executeUpdate();
	  }
	  }
	  }else{
		  rows = 1;
	  }
}else{

if(forexNo.contains(",")){
	  String forexNos[] = forexNo.split(",");
	  for(String sl: forexNos){
		String forexNoNew = sl;
		pstmt = con.prepareStatement(CashVanManagementStatements.GET_FOREX_AMOUNT);  
		pstmt.setInt(1, cVSCustId);
	   	pstmt.setString(2, forexNoNew.toUpperCase());    		   
	   	pstmt.setInt(3, systemId);
		pstmt.setInt(4, custId);
	   	rs= pstmt.executeQuery();
	   	if(rs.next()){
	   	
	    pstmt = con.prepareStatement(CashVanManagementStatements.UPDATE_CASH_INWARD_DETAILS_FOR_RECONCILATION);
	   	pstmt.setString(1, inwardMode);
	 	pstmt.setString(2, tripSheetNo);
	   	pstmt.setString(3, reconciledDate);
	   	pstmt.setInt(4, uniqueId);
	   	pstmt.setInt(5, cVSCustId);
	   	pstmt.setString(6, forexNoNew);
	 	pstmt.setInt(7, systemId);
	   	pstmt.setInt(8, custId);	  
	   	rows = pstmt.executeUpdate(); 
	  }
	  }
}else{
	  
	pstmt = con.prepareStatement(CashVanManagementStatements.GET_FOREX_AMOUNT);  
		pstmt.setInt(1, cVSCustId);
	   	pstmt.setString(2, forexNo.toUpperCase());    		   
	   	pstmt.setInt(3, systemId);
		pstmt.setInt(4, custId);
	   	rs= pstmt.executeQuery();
	if(rs.next()){  
	    pstmt = con.prepareStatement(CashVanManagementStatements.UPDATE_CASH_INWARD_DETAILS_FOR_RECONCILATION);
	   	pstmt.setString(1, inwardMode);
	 	pstmt.setString(2, tripSheetNo);
	   	pstmt.setString(3, reconciledDate);
	   	pstmt.setInt(4, uniqueId);
	   	pstmt.setInt(5, cVSCustId);
	   	pstmt.setString(6, forexNo);
	 	pstmt.setInt(7, systemId);
	   	pstmt.setInt(8, custId);	  
	   	rows = pstmt.executeUpdate();
}
}	 
}
}

 if(cashType.contains("CASH")){
	if(customerType.equalsIgnoreCase("Cash Delivery") && keyPressed.equalsIgnoreCase("Yes") ){
		rows = 1;
	}else{
		
		System.out.println(" cashType == "+cashType);
		
		 pstmt = con.prepareStatement(CashVanManagementStatements.ISERT_CASH_INWARD_DETAILS_FOR_RECONCILATION,Statement.RETURN_GENERATED_KEYS);
		   	pstmt.setString(1, inwardMode);
		   	pstmt.setInt(2, cVSCustId);
		   	pstmt.setString(3, "");
			pstmt.setDouble(4, totalAmount);   	   	
		   	pstmt.setString(5, "CASH");
		   	pstmt.setInt(6, custId);
		   	pstmt.setInt(7, systemId);
		   	pstmt.setInt(8, userId);
		   	pstmt.setString(9, tripSheetNo);
		   	pstmt.setString(10, reconciledDate);
		   	pstmt.setInt(11, uniqueId);
		   	pstmt.setString(12, CashSealNo);
		   	rows = pstmt.executeUpdate();
			
			rs = pstmt.getGeneratedKeys();
		    if (rs.next()) {
		    	sysGeneratedId = rs.getInt(1);          
		    }
	
	
}
	
}


if(rows>0){
	  if(cashType.contains("CASH")) {
	   for(int i =0; i<4; i++){
		   if(i==0){
			cashCondition = "GOOD";
			if(oneGoodNo+twoGoodNo+fiveGoodNo+tenGoodNo+twentyGoodNo+fiftyGoodNo+oneHunGoodNo+fiveHunGoodNo+onethGoodNo+twothGoodNo+fivethGoodNo>0){
			
				long oneGoodNoOld =0;
				long twoGoodNoOld =0;
				long fiveGoodNoOld=0;
				long tenGoodNoOld=0;
				long twentyGoodNoOld=0;
				long fiftyGoodNoOld=0;
				long oneHunGoodNoOld=0;
				long fiveHunGoodNoOld=0;
				long onethGoodNoOld=0;
				long twothGoodNoOld=0;
				long fivethGoodNoOld=0;
			
				
			pstmt = con.prepareStatement(CashVanManagementStatements.INSERT_DENOMINATION_DETAILS);
		   	pstmt.setInt(1, sysGeneratedId);
		   	
			pstmt.setLong(2, oneGoodNo);
			pstmt.setLong(3, twoGoodNo);
			pstmt.setLong(4, fiveGoodNo);
			pstmt.setLong(5, tenGoodNo);
			pstmt.setLong(6, twentyGoodNo);
		   	pstmt.setLong(7, fiftyGoodNo);
			pstmt.setLong(8, oneHunGoodNo);
		   	pstmt.setLong(9, fiveHunGoodNo);
		   	pstmt.setLong(10, onethGoodNo);
			pstmt.setLong(11, twothGoodNo); 
			pstmt.setLong(12, fivethGoodNo); 
			
		   	pstmt.setString(13, cashCondition); 
		    int updatecount = pstmt.executeUpdate();
		 if(updatecount>0){
    		    updateVaultTrasit(con,cVSCustId,custId,systemId,
    		    		oneGoodNo,twoGoodNo,fiveGoodNo,tenGoodNo,twentyGoodNo,fiftyGoodNo,oneHunGoodNo,fiveHunGoodNo,onethGoodNo,twothGoodNo,fivethGoodNo,
    		    		oneGoodNoOld,twoGoodNoOld,fiveGoodNoOld,tenGoodNoOld,twentyGoodNoOld,fiftyGoodNoOld,oneHunGoodNoOld,fiveHunGoodNoOld,onethGoodNoOld,twothGoodNoOld,fivethGoodNoOld,
    		    		userId,"Inward");
    		    }
			}
		   }
		   else if(i==1){
			cashCondition = "BAD";
			if(oneBadNo+twoBadNo+fiveBadNo+tenBadNo+twentyBadNo+fiftyBadNo+oneHunBadNo+fiveHunBadNo+onethBadNo+twothBadNo+fivethBadNo>0){
			pstmt = con.prepareStatement(CashVanManagementStatements.INSERT_DENOMINATION_DETAILS);
         pstmt.setInt(1, sysGeneratedId);
		   	
			pstmt.setLong(2, oneBadNo);
			pstmt.setLong(3, twoBadNo);
			pstmt.setLong(4, fiveBadNo);
			pstmt.setLong(5, tenBadNo);
			pstmt.setLong(6, twentyBadNo);
		   	pstmt.setLong(7, fiftyBadNo);
			pstmt.setLong(8, oneHunBadNo);
		   	pstmt.setLong(9, fiveHunBadNo);
		   	pstmt.setLong(10, onethBadNo);
			pstmt.setLong(11, twothBadNo); 
			pstmt.setLong(12, fivethBadNo); 
			
		   	pstmt.setString(13, cashCondition); 
   		  pstmt.executeUpdate();
			}
		   }
		   else if(i==2){
			cashCondition = "SOILED";
			if(oneSoiledNo+twoSoiledNo+fiveSoiledNo+tenSoiledNo+twentySoiledNo+fiftySoiledNo+oneHunSoiledNo+fiveHunSoiledNo+onethSoiledNo+twothSoiledNo+fivethSoiledNo>0){
			pstmt = con.prepareStatement(CashVanManagementStatements.INSERT_DENOMINATION_DETAILS);
		    pstmt.setInt(1, sysGeneratedId);
		   	
			pstmt.setLong(2, oneSoiledNo);
			pstmt.setLong(3, twoSoiledNo);
			pstmt.setLong(4, fiveSoiledNo);
			pstmt.setLong(5, tenSoiledNo);
			pstmt.setLong(6, twentySoiledNo);
		   	pstmt.setLong(7, fiftySoiledNo);
			pstmt.setLong(8, oneHunSoiledNo);
		   	pstmt.setLong(9, fiveHunSoiledNo);
		   	pstmt.setLong(10, onethSoiledNo);
			pstmt.setLong(11, twothSoiledNo); 
			pstmt.setLong(12, fivethSoiledNo); 
			
		   	pstmt.setString(13, cashCondition); 
   		  pstmt.executeUpdate();
			}
		   }
		   else if(i==3){
			cashCondition = "COUNTERFIET";
			if(oneCounterNo+twoCounterNo+fiveCounterNo+tenCounterNo+twentyCounterNo+fiftyCounterNo+oneHunCounterNo+fiveHunCounterNo+onethCounterNo+twothCounterNo+fivethCounterNo>0){
			pstmt = con.prepareStatement(CashVanManagementStatements.INSERT_DENOMINATION_DETAILS);
         pstmt.setInt(1, sysGeneratedId);
		   	
			pstmt.setLong(2, oneCounterNo);
			pstmt.setLong(3, twoCounterNo);
			pstmt.setLong(4, fiveCounterNo);
			pstmt.setLong(5, tenCounterNo);
			pstmt.setLong(6, twentyCounterNo);
		   	pstmt.setLong(7, fiftyCounterNo);
			pstmt.setLong(8, oneHunCounterNo);
		   	pstmt.setLong(9, fiveHunCounterNo);
		   	pstmt.setLong(10, onethCounterNo);
			pstmt.setLong(11, twothCounterNo); 
			pstmt.setLong(12, fivethCounterNo); 
			
		   	pstmt.setString(13, cashCondition);
   		  pstmt.executeUpdate();
			}
		   }
	   }
}
   pstmt = con.prepareStatement(CashVanManagementStatements.UPDATE_DESPENSE);
   pstmt.setString(1, tripSheetNo);
   pstmt.setInt(2, uniqueId);
   int c = pstmt.executeUpdate();
   if(c>0){
	   message ="Saved Successfully!!"; 
   }
}else{
	message ="Details Didnot Saved!!"; 
}
} catch (Exception e) {
        e.printStackTrace();
    } finally {
        DBConnection.releaseConnectionToDB(con, pstmt, rs);
    }
    return message;
}

public ArrayList<String> getDataForModifyInward(int systemId,int customerId,int inwardId){
	Connection con = null;
	PreparedStatement pstmt = null;
	ResultSet rs =null;
	ArrayList<String> dataList = new ArrayList<String>();
	String cvsCustomerId = "";	
	String InwardedDate ="";	
	String SealedBagNo = "";	
	String TotalAmount = "";	
	String CustomerName = "";	
	String cashType = "";
	String inwardMode = "";
	try{
		con = DBConnection.getConnectionToDB("AMS");
		pstmt = con.prepareStatement(CashVanManagementStatements.GET_MODIFY_INWARD_DETAILS);
		pstmt.setInt(1, systemId);
		pstmt.setInt(2, customerId);
		pstmt.setInt(3, inwardId);
		rs = pstmt.executeQuery();
		if(rs.next()){

			cvsCustomerId =  rs.getString("CVS_CUST_ID");	
			InwardedDate =ddmmyyyy.format(yyyymmdd.parse(rs.getString("INWARD_DATE")));
			cashType =  rs.getString("CASH_TYPE");
			if(cashType.toUpperCase().equals("CASH")){
				SealedBagNo = rs.getString("CASH_SEAL_NO");	
			}else{
			SealedBagNo = rs.getString("SEAL_NO");	
			}
			TotalAmount =  rs.getString("TOTAL_AMOUNT");	
			CustomerName =  rs.getString("CUSTOMER_NAME");
			
			inwardMode = rs.getString("INWARD_MODE");
			dataList.add(cvsCustomerId);
			dataList.add(InwardedDate);			
			dataList.add(SealedBagNo);
			dataList.add(TotalAmount);
			dataList.add(CustomerName);
			dataList.add(cashType);
			dataList.add(inwardMode);
			
		}
	}catch(Exception e){
		e.printStackTrace();
	}finally{
		DBConnection.releaseConnectionToDB(con, pstmt, rs);
	}
	return dataList;
}
public String getCheckPoints(int systemId, int clientId, String tripSheetNo){
	String checkPoints = "";
	Connection con = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	try{
		con = DBConnection.getConnectionToDB("AMS");
		pstmt = con.prepareStatement(CashVanManagementStatements.GET_BUSINESS_ID);
		pstmt.setInt(1, systemId);
		pstmt.setInt(2, clientId);
		pstmt.setString(3, tripSheetNo);
		rs = pstmt.executeQuery();
		while(rs.next()){
			checkPoints = checkPoints+","+rs.getInt("businessId");
		}
	}catch(Exception e){
		e.printStackTrace();
	}finally{
		DBConnection.releaseConnectionToDB(con, pstmt, rs);
	}
	return checkPoints;
}


public JSONArray getVaultInventorySummary(int systemId,int custId){
    Connection con = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    PreparedStatement pstmt3 = null;
    ResultSet rs3 = null;
    JSONObject  JsonObject= new JSONObject();
    JSONArray JsonArray = new JSONArray();
    double availableBalance= 0.0;
    double ledgerAmount= 0.0;
    double sealedBagAmount= 0.0;
    double chequeAmount= 0.0;
    double jewelleryAmount= 0.0;
    double forexAmount= 0.0;
    double totalAmount= 0.0;
 try {
	 
	 con = DBConnection.getConnectionToDB("AMS");
	 
	 String innerList1 = "";
	 String innerList2 = "";
	 String innerList3 = "";
	 String innerList4 = "";
	 
	 pstmt3 = con.prepareStatement(CashVanManagementStatements.GET_VAULT_INVENTORY_FOR_SEALED_BAG_TYPE_INNER_QUERY);
	 pstmt3.setInt(1, systemId);
     pstmt3.setInt(2, custId);
     rs3=pstmt3.executeQuery();	
	 while(rs3.next()){			
		 innerList1= innerList1+"'"+rs3.getString("SEAL_NO")+"'"+" , ";
	 }
	 innerList1 = innerList1.substring(0, innerList1.lastIndexOf(","));
	
	 pstmt3 = con.prepareStatement(CashVanManagementStatements.GET_VAULT_INVENTORY_FOR_SEALED_BAG_TYPE_INNER_QUERYY2);
	 pstmt3.setInt(1, systemId);
     pstmt3.setInt(2, custId);
     rs3=pstmt3.executeQuery();	
	 while(rs3.next()){			
		 innerList2= innerList2+"'"+rs3.getString("SEAL_NO")+"'"+" , ";
	 }
	 innerList2 = innerList2.substring(0, innerList2.lastIndexOf(","));
	 
	 pstmt3 = con.prepareStatement(CashVanManagementStatements.GET_VAULT_INVENTORY_FOR_SEALED_BAG_TYPE_INNER_QUERY3);
	 pstmt3.setInt(1, systemId);
     pstmt3.setInt(2, custId);
     rs3=pstmt3.executeQuery();	
	 while(rs3.next()){			
		 innerList3= innerList3+"'"+rs3.getString("SEAL_NO")+"'"+" , ";
	 }
	 innerList3 = innerList3.substring(0, innerList3.lastIndexOf(","));
	 
	 pstmt3 = con.prepareStatement(CashVanManagementStatements.GET_VAULT_INVENTORY_FOR_SEALED_BAG_TYPE_INNER_QUERY4);
	 pstmt3.setInt(1, systemId);
     pstmt3.setInt(2, custId);
     rs3=pstmt3.executeQuery();	
	 while(rs3.next()){			
		 innerList4= innerList4+"'"+rs3.getString("SEAL_NO")+"'"+" , ";
	 }
	 innerList4 = innerList4.substring(0, innerList4.lastIndexOf(","));

	 DBConnection.releaseConnectionToDB(null, pstmt3, rs3);
	 
	 pstmt = con.prepareStatement(CashVanManagementStatements.GET_VAULT_INVENTORY_SUMMARY_NEW.replace("a.SEAL_NO IN ( # )", " a.SEAL_NO IN ( "+innerList1+" )" ).replace("j.SEAL_NO IN ( # )", "j.SEAL_NO IN ( "+innerList4+" )").replace("ch.SEAL_NO IN ( # )", "ch.SEAL_NO IN ( "+innerList2+" )").replace("fx.SEAL_NO IN ( # )", "fx.SEAL_NO IN ( "+innerList3+" )")             );
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
     pstmt.setInt(13, systemId);
     pstmt.setInt(14, custId);
     pstmt.setInt(15, systemId);  
     pstmt.setInt(16, custId);
     pstmt.setInt(17, systemId);
     pstmt.setInt(18, custId);
     pstmt.setInt(19, systemId);
     pstmt.setInt(20, custId);	
     pstmt.setInt(21, systemId);
     pstmt.setInt(22, custId); 	
	 rs=pstmt.executeQuery(); 
	if(rs.next()){	
		 availableBalance= rs.getDouble("AVAILABLE_BALANCE");
	     ledgerAmount= rs.getDouble("LEDGER_AMOUNT");
	     sealedBagAmount= rs.getDouble("SEALED_BAG_AMOUNT");
	     chequeAmount= rs.getDouble("CHECK_TOTAL_AMOUNT");
	     jewelleryAmount= rs.getDouble("JEW_TOTAL_AMOUNT");
	     forexAmount= getForex(con,systemId,custId);
	     
			     JsonObject.put("AvailableBalance",String.format("%,.2f", availableBalance));
		    	 JsonObject.put("LedgerAmount",String.format("%,.2f", ledgerAmount));
		    	 JsonObject.put("SealedBagAmount",String.format("%,.2f", sealedBagAmount));			    	 
		    	 JsonObject.put("ChequeAmount",String.format("%,.2f", chequeAmount));	
		    	 JsonObject.put("JewelleryAmount",String.format("%,.2f", jewelleryAmount));
		    	 JsonObject.put("ForeignCurrencyAmount",String.format("%,.2f", forexAmount));

			     totalAmount= ledgerAmount+sealedBagAmount+chequeAmount+jewelleryAmount+forexAmount;

			     JsonObject.put("TotalAmount",String.format("%,.2f",totalAmount));				    
			     JsonArray.put(JsonObject);		 
	}
	
} catch (Exception e) {
	e.printStackTrace();
} finally {
   DBConnection.releaseConnectionToDB(con, pstmt, rs);
}
return JsonArray;

}


public ArrayList<ArrayList<String>> getAssetDetails(int systemId,int customerId,String assetNos){
	Connection con = null;
	PreparedStatement pstmt = null;
	ResultSet rs =null;
	ArrayList<ArrayList<String>> dataList = new ArrayList<ArrayList<String>>();
	assetNos = assetNos.substring(0,assetNos.lastIndexOf(","));
	try{
		con = DBConnection.getConnectionToDB("AMS");
		pstmt = con.prepareStatement(CashVanManagementStatements.GET_ASSET_DETAILS.replace("#", assetNos));
		pstmt.setInt(1, systemId);
		pstmt.setInt(2, customerId);
		rs = pstmt.executeQuery();
		while(rs.next()){
		ArrayList<String> innerlist = new ArrayList<String>(); 
		innerlist.add(rs.getString("ASSET_NO"));
		innerlist.add(rs.getString("ASSET_ITEM"));
		innerlist.add(rs.getString("QR_CODE"));
		dataList.add(innerlist);	
		
		}
	}catch(Exception e){
		e.printStackTrace();
	}finally{
		DBConnection.releaseConnectionToDB(con, pstmt, rs);
	}
	return dataList;
}
public JSONArray getDispenseHistory(int systemId, int clientId,	String startDate, String endDate) {
	Connection con = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    JSONObject obj = null;
    JSONArray jArray = new JSONArray();
    String preTripSheetNo ="";
    String  currentTripSheetNo = "";
    String tripStatus = "";
    String tripSheetNo="";
    String tripNo = "";
    String date = "";
    String routeName = "";
    String vehicleNo = "";
    String cust1 = "";
    String cust2 = "";
    String driverName = "";
    try{
    	con = DBConnection.getConnectionToDB("AMS");
    	pstmt = con.prepareStatement(CashVanManagementStatements.GET_DISPENSE_HISTORY);
    	pstmt.setInt(1, systemId);
    	pstmt.setInt(2, clientId);
    	pstmt.setString(3, startDate);
    	pstmt.setString(4, endDate);
    	pstmt.setInt(5, systemId);
    	pstmt.setInt(6, clientId);
    	rs=pstmt.executeQuery();
    	int count = 0;
    	while(rs.next()){
    		if(rs.getRow()==1){
    			currentTripSheetNo = rs.getString("TRIP_SHEET_NO");
    			preTripSheetNo = rs.getString("TRIP_SHEET_NO");
    			obj = new JSONObject();	
    			count++;
    		}else{
    			preTripSheetNo = currentTripSheetNo;
    			currentTripSheetNo = rs.getString("TRIP_SHEET_NO");
    			if(!preTripSheetNo.equals(currentTripSheetNo)){
    				jArray.put(obj);
    				obj = new JSONObject();	
    				count = 0;
    				count++;
    			}else{
    				count++;
    			}
    		}
    		tripSheetNo = rs.getString("TRIP_SHEET_NO");
    		tripStatus =rs.getString("TRIP_STATUS").toUpperCase();
    		tripNo = rs.getString("TRIP_ID");
    		date = rs.getString("DATE");
    		routeName = rs.getString("ROUTE_NAME");
    		vehicleNo = rs.getString("ASSET_NUMBER");
    		cust1 = rs.getString("CUSTODIAN_1");
    		cust2 = rs.getString("CUSTODIAN_2");
    		driverName = rs.getString("DRIVER_NAME");
    		
    		obj.put( "tripsheetnoDataIndex",tripSheetNo);
    		obj.put( "tripstatusDataIndex",tripStatus);
    		obj.put( "tripnoindex",tripNo);
    		obj.put( "dateindex",date);
    		obj.put( "routeindex",routeName);
    		obj.put( "noofpoiindex",count);
    		obj.put( "vehiclenoindex",vehicleNo);
    		obj.put( "custodian1index",cust1);
    		obj.put(  "custodian2index",cust2);
    		obj.put( "drivernameindex",driverName);
    	}
    	if(obj != null){
    		jArray.put(obj);
    	}
    } catch (Exception e) {
    	e.printStackTrace();
    } finally {
    	DBConnection.releaseConnectionToDB(con, pstmt, rs);
    }
    return jArray;
}
public String setCurrentDateForReports(int days) {
	java.util.Date currentdate = null;
	String currdate = "";
	currentdate = new java.util.Date();
	if (days > 0) {
		if (currentdate != null) {
			Calendar cal = Calendar.getInstance();
			cal.setTime(currentdate);
			cal.add(Calendar.DAY_OF_MONTH, -days);
			currentdate = cal.getTime();
			// System.out.println("New Date:::"+retValue);

		}
	}
	SimpleDateFormat formatter = new SimpleDateFormat("dd-MM-yyyy");
	currdate = formatter.format(currentdate);
	return currdate;
}
public String getCurrentDateandTime(int days) {
	java.util.Date currentdate = null;
	String currdate = "";
	currentdate = new java.util.Date();
	if (days > 0) {
		if (currentdate != null) {
			Calendar cal = Calendar.getInstance();
			cal.setTime(currentdate);
			cal.add(Calendar.DAY_OF_MONTH, -days);
			currentdate = cal.getTime();
			// System.out.println("New Date:::"+retValue);

		}
	}
	SimpleDateFormat formatter = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
	currdate = formatter.format(currentdate);
	return currdate;
}
public JSONArray getAllCutomers(int systemId, int clientId) {
	Connection con = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	JSONArray jArr = new JSONArray();
	JSONObject obj = null;
	try{
		con = DBConnection.getConnectionToDB("AMS");
		pstmt = con.prepareStatement(CashVanManagementStatements.GET_CVS_CUSTOMER_FOR_VAULT);
		pstmt.setInt(1, clientId);
		pstmt.setInt(2, systemId);
		rs = pstmt.executeQuery();
		while(rs.next()){
			obj = new JSONObject();
			obj.put("CustId", rs.getInt("CustomerId"));
			obj.put("CustName", rs.getString("CustomerName"));
			jArr.put(obj);
		}
	}catch(Exception e){
		e.printStackTrace();
	}finally{
		DBConnection.releaseConnectionToDB(con, pstmt, rs);
	}
	return jArr;
}
public JSONArray getCutomerswithALL(int systemId, int clientId) {
	Connection con = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	JSONArray jArr = new JSONArray();
	JSONObject obj = null;
	try{
		con = DBConnection.getConnectionToDB("AMS");
		pstmt = con.prepareStatement(CashVanManagementStatements.GET_CVS_CUSTOMER_FOR_VAULT);
		pstmt.setInt(1, clientId);
		pstmt.setInt(2, systemId);
		rs = pstmt.executeQuery();
		obj = new JSONObject();
		obj.put("CustId", "0");
		obj.put("CustName", "ALL");
		jArr.put(obj);
		while(rs.next()){
			obj = new JSONObject();
			obj.put("CustId", rs.getInt("CustomerId"));
			obj.put("CustName", rs.getString("CustomerName"));
			jArr.put(obj);
		}
	}catch(Exception e){
		e.printStackTrace();
	}finally{
		DBConnection.releaseConnectionToDB(con, pstmt, rs);
	}
	return jArr;
}
public JSONArray getVaultLedgerDetails(int systemId, int clientId, int cvsCustId, String startDate, String endDate, int offset,String custType) {
	Connection con = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	JSONArray jArr = new JSONArray();
	JSONObject obj = null;
	int count = 0;
	String query = "";
	try{
		con = DBConnection.getConnectionToDB("AMS");
		if(cvsCustId == 0){
			query = CashVanManagementStatements.GET_VAULT_DETAILS.replaceAll("#", "##");
		}else{
			query = CashVanManagementStatements.GET_VAULT_DETAILS.replaceAll("#", " ## and (case when a.CUSTOMER_TYPE = 'Cash Delivery' then a.ON_ACC_OF else a.CVS_CUSTOMER_ID end)="+cvsCustId);
		}
		if(custType.equals("0")){
			query = query.replaceAll("##", "");
		}else if(custType.equals("1")){
			query = query.replaceAll("##", " and a.CUSTOMER_TYPE='ATM Replenishment'");
		}else if(custType.equals("2")){
			query = query.replaceAll("##", " and a.CUSTOMER_TYPE='Cash Delivery'");
		}else if(custType.equals("3")){
			query = query.replaceAll("##", " and a.CUSTOMER_TYPE='Cash pickup'");
		}else if(custType.equals("4")){
			query = query.replaceAll("##", " and a.CUSTOMER_TYPE='ATM Deposit'");
		}else if(custType.equals("5")){
			query = query.replaceAll("##", " and a.CUSTOMER_TYPE='Cash Transfer'");
		}else{
			query = query.replaceAll("##", "");
		}
		pstmt = con.prepareStatement(query);
		pstmt.setInt(1, offset);
		pstmt.setInt(2, systemId);
		pstmt.setInt(3, clientId);
		pstmt.setInt(4, offset);
		pstmt.setString(5, startDate);
		pstmt.setInt(6, offset);
		pstmt.setString(7, endDate);
		pstmt.setInt(8, offset);
		pstmt.setInt(9, systemId);
		pstmt.setInt(10, clientId);
		pstmt.setInt(11, offset);
		pstmt.setString(12, startDate);
		pstmt.setInt(13, offset);
		pstmt.setString(14, endDate);
		pstmt.setInt(15, offset);
		pstmt.setInt(16, systemId);
		pstmt.setInt(17, clientId);
		pstmt.setInt(18, offset);
		pstmt.setString(19, startDate);
		pstmt.setInt(20, offset);
		pstmt.setString(21, endDate);
		pstmt.setInt(22, offset);
		pstmt.setInt(23, systemId);
		pstmt.setInt(24, clientId);
		pstmt.setInt(25, offset);
		pstmt.setString(26, startDate);
		pstmt.setInt(27, offset);
		pstmt.setString(28, endDate);
		pstmt.setInt(29, offset);
		pstmt.setInt(30, systemId);
		pstmt.setInt(31, clientId);
		pstmt.setInt(32, offset);
		pstmt.setString(33, startDate);
		pstmt.setInt(34, offset);
		pstmt.setString(35, endDate);
		pstmt.setInt(36, systemId);
		pstmt.setInt(37, clientId);
		pstmt.setString(38, startDate);
		pstmt.setString(39, endDate);
		pstmt.setInt(40, systemId);
		pstmt.setInt(41, clientId);
		pstmt.setString(42, startDate);
		pstmt.setString(43, endDate);
		pstmt.setInt(44, systemId);
		pstmt.setInt(45, clientId);
		pstmt.setString(46, startDate);
		pstmt.setString(47, endDate);
		pstmt.setInt(48, systemId);
		pstmt.setInt(49, clientId);
		pstmt.setString(50, startDate);
		pstmt.setString(51, endDate);
		pstmt.setInt(52, systemId);
		pstmt.setInt(53, clientId);
		pstmt.setString(54, startDate);
		pstmt.setString(55, endDate);
		rs = pstmt.executeQuery();
		while(rs.next()){
			count++;
			obj = new JSONObject();
			obj.put("slnoIndex", count);
			obj.put("dateTimeDI", rs.getString("INSERTED_DATE"));
			obj.put("tripNoDI", rs.getString("TripNo"));
			obj.put("custTypeDI", rs.getString("CUSTOMER_TYPE"));
			obj.put("onAccOffDI", rs.getString("ONACCOF"));
			obj.put("businessIdDI", rs.getString("BUSINESS_ID"));
			obj.put("amountDI", rs.getString("TOTAL_AMOUNT"));
			obj.put("cashDispenseDI", rs.getDouble("CASH_DISPENSE"));
			obj.put("cashInwardDI", rs.getDouble("CASH_INWARD"));
			obj.put("sealedBagDispDI", rs.getDouble("SEALED_BAG_DISPENSE"));
			obj.put("sealedBagInwardDI", rs.getDouble("SEALED_BAG_INWARD"));
			obj.put("chequeInwardDI", rs.getDouble("CHEQUE_INWARD"));
			obj.put("chequeDispDI", rs.getDouble("CHEQUE_DISPENSE"));
			obj.put("jewelleryInwardDI", rs.getDouble("JEWELLERY_INWARD"));
			obj.put("jewelleryDispDI", rs.getDouble("JEWELLERY_DISPENSE"));
			obj.put("foreignCurrencyInwardDI", rs.getDouble("FOREX_INWARD"));
			obj.put("foreignCurrencyDispDI", rs.getDouble("FOREX_DISPENSE"));
			obj.put("inwardModeDI", rs.getString("INWARD_MODE"));
			jArr.put(obj);
		}
	}catch(Exception e){
		e.printStackTrace();
	}finally{
		DBConnection.releaseConnectionToDB(con, pstmt, rs);
	}
	return jArr;
}
public JSONArray getCurrentInventoryBalance(int systemId, int clientId,	int cvsCustId) {
	Connection con = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	PreparedStatement pstmt3 = null;
	ResultSet rs3 = null;
	JSONArray jArr = new JSONArray();
	JSONObject obj = null;
	try{
		con = DBConnection.getConnectionToDB("AMS");
		String innerList1 = "";
		String innerList2 = "";
		String innerList3 = "";
		String innerList4 = "";
		 
		pstmt3 = con.prepareStatement(CashVanManagementStatements.GET_VAULT_INVENTORY_FOR_SEALED_BAG_TYPE_INNER_QUERY);
		pstmt3.setInt(1, systemId);
	    pstmt3.setInt(2, clientId);
	    rs3=pstmt3.executeQuery();	
		while(rs3.next()){			
			innerList1= innerList1+"'"+rs3.getString("SEAL_NO")+"'"+" , ";
		}
		innerList1 = innerList1.substring(0, innerList1.lastIndexOf(","));
		
		 pstmt3 = con.prepareStatement(CashVanManagementStatements.GET_VAULT_INVENTORY_FOR_SEALED_BAG_TYPE_INNER_QUERYY2);
		 pstmt3.setInt(1, systemId);
		 pstmt3.setInt(2, clientId);
		 rs3=pstmt3.executeQuery();	
		 while(rs3.next()){			
			 innerList2= innerList2+"'"+rs3.getString("SEAL_NO")+"'"+" , ";
		 }
		 innerList2 = innerList2.substring(0, innerList2.lastIndexOf(","));
		 
		 pstmt3 = con.prepareStatement(CashVanManagementStatements.GET_VAULT_INVENTORY_FOR_SEALED_BAG_TYPE_INNER_QUERY3);
		 pstmt3.setInt(1, systemId);
		 pstmt3.setInt(2, clientId);
		 rs3=pstmt3.executeQuery();	
		 while(rs3.next()){			
			 innerList3= innerList3+"'"+rs3.getString("SEAL_NO")+"'"+" , ";
		 }
		 innerList3 = innerList3.substring(0, innerList3.lastIndexOf(","));
		 
		 pstmt3 = con.prepareStatement(CashVanManagementStatements.GET_VAULT_INVENTORY_FOR_SEALED_BAG_TYPE_INNER_QUERY4);
		 pstmt3.setInt(1, systemId);
		 pstmt3.setInt(2, clientId);
		 rs3=pstmt3.executeQuery();	
		 while(rs3.next()){			
			 innerList4= innerList4+"'"+rs3.getString("SEAL_NO")+"'"+" , ";
		 }
		 innerList4 = innerList4.substring(0, innerList4.lastIndexOf(","));
		DBConnection.releaseConnectionToDB(null, pstmt3, rs3);
		
		pstmt = con.prepareStatement(CashVanManagementStatements.GET_CURRENT_INVENTORY.replace("a.SEAL_NO IN ( # )", " a.SEAL_NO IN ( "+innerList1+" )" ).replace("j.SEAL_NO IN ( # )", "j.SEAL_NO IN ( "+innerList4+" )").replace("ch.SEAL_NO IN ( # )", "ch.SEAL_NO IN ( "+innerList2+" )").replace("fx.SEAL_NO IN ( # )", "fx.SEAL_NO IN ( "+innerList3+" )"));
		 pstmt.setInt(1, systemId);
	     pstmt.setInt(2, clientId);
	     pstmt.setInt(3, cvsCustId);
	     pstmt.setInt(4, systemId);
	     pstmt.setInt(5, clientId);
	     pstmt.setInt(6, cvsCustId);
	     pstmt.setInt(7, systemId);
	     pstmt.setInt(8, clientId);
	     pstmt.setInt(9, cvsCustId);
	     pstmt.setInt(10, systemId);
	     pstmt.setInt(11, clientId);
	     pstmt.setInt(12, cvsCustId);
	     pstmt.setInt(13, systemId);
	     pstmt.setInt(14, clientId);
	     pstmt.setInt(15, cvsCustId);
	     pstmt.setInt(16, systemId);
	     pstmt.setInt(17, clientId);
	     pstmt.setInt(18, cvsCustId);
	     pstmt.setInt(19, systemId);
	     pstmt.setInt(20, clientId);
	     pstmt.setInt(21, cvsCustId);
	     pstmt.setInt(22, systemId);  
	     pstmt.setInt(23, clientId);
	     pstmt.setInt(24, cvsCustId);
	     pstmt.setInt(25, systemId);
	     pstmt.setInt(26, clientId);
	     pstmt.setInt(27, cvsCustId);
	     pstmt.setInt(28, systemId);
	     pstmt.setInt(29, clientId);
	     pstmt.setInt(30, cvsCustId);
	     pstmt.setInt(31, systemId);
	     pstmt.setInt(32, clientId);
	     pstmt.setInt(33, cvsCustId);
		rs = pstmt.executeQuery();
		while(rs.next()){
			obj = new JSONObject();
			obj.put("ledgerBalance", rs.getDouble("LEDGER_AMOUNT"));
			obj.put("availableBalance", rs.getDouble("AVAILABLE_BALANCE"));
			obj.put("sealedBagBalance", rs.getDouble("SEALED_BAG_AMOUNT"));
			obj.put("chequeBalance", rs.getDouble("CHECK_TOTAL_AMOUNT"));
			obj.put("jewelleryBalance", rs.getDouble("JEW_TOTAL_AMOUNT"));
			obj.put("forexBalance", rs.getDouble("FOREX_TOTAL_AMOUNT"));
			obj.put("total", rs.getDouble("LEDGER_AMOUNT")+rs.getDouble("SEALED_BAG_AMOUNT")+rs.getDouble("CHECK_TOTAL_AMOUNT")+rs.getDouble("JEW_TOTAL_AMOUNT")+rs.getDouble("FOREX_TOTAL_AMOUNT"));
			jArr.put(obj);
		}
	}catch(Exception e){
		e.printStackTrace();
	}finally{
		DBConnection.releaseConnectionToDB(con, pstmt, rs);
	}
	return jArr;
}
private String valueWithCommas(double value){
	
	return String.format("%,.2f",value);
	
}
public ArrayList<String> getGridForSummaryForSealBag(int systemId,int customerId,int cvsCustId,String cashType ){
	Connection con = null;
	PreparedStatement pstmt = null;
	ResultSet rs =null;
	PreparedStatement pstmt3 = null;
	ResultSet rs3 =null;
	ArrayList<String> dataList = new ArrayList<String>();
	try{
		con = DBConnection.getConnectionToDB("AMS");
		
		 String innerList = "";
		 if(cashType.equalsIgnoreCase("SEALED BAG")){
		 pstmt3 = con.prepareStatement(CashVanManagementStatements.GET_VAULT_INVENTORY_FOR_SEALED_BAG_TYPE_INNER_QUERY);
		 }else if(cashType.equalsIgnoreCase("CHEQUE")){
			 pstmt3 = con.prepareStatement(CashVanManagementStatements.GET_VAULT_INVENTORY_FOR_SEALED_BAG_TYPE_INNER_QUERYY2); 
		 }else if(cashType.equalsIgnoreCase("FOREIGN CURRENCY")){
			 pstmt3 = con.prepareStatement(CashVanManagementStatements.GET_VAULT_INVENTORY_FOR_SEALED_BAG_TYPE_INNER_QUERY3); 
		 }else if(cashType.equalsIgnoreCase("JEWELLERY")){
			 pstmt3 = con.prepareStatement(CashVanManagementStatements.GET_VAULT_INVENTORY_FOR_SEALED_BAG_TYPE_INNER_QUERY4); 
		 }
		 pstmt3.setInt(1, systemId);
	     pstmt3.setInt(2, customerId);
	     rs3=pstmt3.executeQuery();	
		 while(rs3.next()){			
			 innerList= innerList+"'"+rs3.getString("SEAL_NO")+"'"+" , ";
		 }
		 innerList = innerList.substring(0, innerList.lastIndexOf(","));
		 //System.out.println(" innerList == "+innerList);
		 DBConnection.releaseConnectionToDB(null, pstmt3, rs3);
		 if(cashType.equalsIgnoreCase("FOREIGN CURRENCY")){
				pstmt = con.prepareStatement(CashVanManagementStatements.GET_SEAL_BAG_LIST_AND_CURRENCY_CODE.replace("#", innerList));
		 }else{
		pstmt = con.prepareStatement(CashVanManagementStatements.GET_SEAL_BAG_LIST.replace("#", innerList));
		 }
		pstmt.setString(1, cashType);
		pstmt.setInt(2, systemId);
		pstmt.setInt(3, customerId);
		pstmt.setString(4, cashType);
		pstmt.setInt(5, systemId);
		pstmt.setInt(6, customerId);
		//pstmt.setInt(5, systemId);
		//pstmt.setInt(6, customerId);
		pstmt.setInt(7, cvsCustId);
		rs = pstmt.executeQuery();
		while(rs.next()){
			if(cashType.equalsIgnoreCase("FOREIGN CURRENCY")){
				dataList.add(rs.getString("SEAL_NO")+" - "+valueWithCommas(rs.getDouble("TOTAL_AMOUNT"))+" - "+rs.getString("CURRENCY_CODE"));	
			}else if(cashType.equalsIgnoreCase("SEALED BAG")){
				if(rs.getString("remarks").equals("")){
					dataList.add(rs.getString("SEAL_NO")+" - "+valueWithCommas(rs.getDouble("TOTAL_AMOUNT")));
				}else{
					dataList.add(rs.getString("SEAL_NO")+" - "+valueWithCommas(rs.getDouble("TOTAL_AMOUNT"))+" - "+rs.getString("remarks"));
				}
			}else{
				dataList.add(rs.getString("SEAL_NO")+" - "+valueWithCommas(rs.getDouble("TOTAL_AMOUNT")));
			}
		}
	}catch(Exception e){
		e.printStackTrace();
	}finally{
		DBConnection.releaseConnectionToDB(con, pstmt, rs);
	}
	return dataList;
}

public ArrayList<String> getGridForSummaryForSealBagForReconcilation(int systemId,int customerId,int cvsCustId,String tripsheetNo,int dispenseId ){
	Connection con = null;
	PreparedStatement pstmt = null;
	ResultSet rs =null;
	PreparedStatement pstmt2 = null;
	ResultSet rs2 =null;
	ArrayList<String> dataList = new ArrayList<String>();
	try{
		con = DBConnection.getConnectionToDB("AMS");
		pstmt = con.prepareStatement(CashVanManagementStatements.GET_SEAL_BAG_LIST_FOR_RECONCILATION);
		pstmt.setInt(1, systemId);
		pstmt.setInt(2, customerId);		
		pstmt.setInt(3, cvsCustId);
		pstmt.setInt(4,dispenseId);
		rs = pstmt.executeQuery();
		if(rs.next()){
			String sealNo = rs.getString("SEAL_NO");
			int onaccoff = rs.getInt("ON_ACC_OF");
			if(sealNo.contains(",")){
	    		  String sealNos[] = sealNo.split(",");
	    		  for(String sl: sealNos){
	    			String sealNoNew = sl;
	    			pstmt2 = con.prepareStatement(CashVanManagementStatements.GET_SEAL_NO_AMOUNT); 
	    			if(rs.getString("CUSTOMER_TYPE").equals("Cash Delivery")){
		    			pstmt2.setInt(1, onaccoff);	
	    			}else{
	    				pstmt2.setInt(1, cvsCustId);		
	    			}
	    		   	pstmt2.setString(2, sealNoNew.toUpperCase());    		   
	    		   	pstmt2.setInt(3, systemId);
	    			pstmt2.setInt(4, customerId);
	    		   	rs2= pstmt2.executeQuery();
	    		   	if(rs2.next()){
	    		   		dataList.add(sealNoNew+" - "+valueWithCommas(rs2.getDouble("TOTAL_AMOUNT")));
	    		  }
	    		  }
	    	  }else{
	    		  
	    		pstmt2 = con.prepareStatement(CashVanManagementStatements.GET_SEAL_NO_AMOUNT);  
	    		int custType=0;
	    		if(rs.getString("CUSTOMER_TYPE").equals("Cash Delivery")){
	    			custType=onaccoff;	
    			}else{
    				custType=cvsCustId;		
    			}
	    		pstmt2.setInt(1, custType);	
	  		   	pstmt2.setString(2, sealNo.toUpperCase());    		   
	  		   	pstmt2.setInt(3, systemId);
	  			pstmt2.setInt(4, customerId);
	  		   	rs2= pstmt2.executeQuery();
	    		if(rs2.next()){  
	    			dataList.add(sealNo+" - "+valueWithCommas(rs2.getDouble("TOTAL_AMOUNT")));

	    	  }
	    	  }			
		}
	}catch(Exception e){
		e.printStackTrace();
	}finally{
		DBConnection.releaseConnectionToDB(null, pstmt, rs);
		DBConnection.releaseConnectionToDB(con, pstmt2, rs2);
	}
	return dataList;
}

public ArrayList<ArrayList<String>> getLedgerDetails(int systemId,int clientId, String cvsCustId, String startDate, String endDate,int offset,String custType) {
	Connection con = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	ArrayList<String> ledgerDetails = null;
	ArrayList<ArrayList<String>> finalledgerDetails = new ArrayList<ArrayList<String>>();
	String query = "";
	try{
		con = DBConnection.getConnectionToDB("AMS");
		query = CashVanManagementStatements.GET_VAULT_DETAILS;
		if(cvsCustId.equals("0")){
			query = query.replaceAll("#", "##");
		}else{
			query = query.replace("#", " ## and (case when a.CUSTOMER_TYPE = 'Cash Delivery' then a.ON_ACC_OF else a.CVS_CUSTOMER_ID end)="+cvsCustId);
		}
		if(custType.equals("0")){
			query = query.replaceAll("##", "");
		}else if(custType.equals("1")){
			query = query.replaceAll("##", " and a.CUSTOMER_TYPE='ATM Replenishment'");
		}else if(custType.equals("2")){
			query = query.replaceAll("##", " and a.CUSTOMER_TYPE='Cash Delivery'");
		}else if(custType.equals("3")){
			query = query.replaceAll("##", " and a.CUSTOMER_TYPE='Cash pickup'");
		}else{
			query = query.replaceAll("##", "");
		}
		pstmt = con.prepareStatement(query);
		pstmt.setInt(1, offset);
		pstmt.setInt(2, systemId);
		pstmt.setInt(3, clientId);
		pstmt.setInt(4, offset);
		pstmt.setString(5, yyyymmdd.format(sdfyyyymmddhhmmss.parse(startDate)));
		pstmt.setInt(6, offset);
		pstmt.setString(7, yyyymmdd.format(sdfyyyymmddhhmmss.parse(endDate)));
		pstmt.setInt(8, offset);
		pstmt.setInt(9, systemId);
		pstmt.setInt(10, clientId);
		pstmt.setInt(11, offset);
		pstmt.setString(12, yyyymmdd.format(sdfyyyymmddhhmmss.parse(startDate)));
		pstmt.setInt(13, offset);
		pstmt.setString(14, yyyymmdd.format(sdfyyyymmddhhmmss.parse(endDate)));
		pstmt.setInt(15, offset);
		pstmt.setInt(16, systemId);
		pstmt.setInt(17, clientId);
		pstmt.setInt(18, offset);
		pstmt.setString(19, yyyymmdd.format(sdfyyyymmddhhmmss.parse(startDate)));
		pstmt.setInt(20, offset);
		pstmt.setString(21, yyyymmdd.format(sdfyyyymmddhhmmss.parse(endDate)));
		pstmt.setInt(22, offset);
		pstmt.setInt(23, systemId);
		pstmt.setInt(24, clientId);
		pstmt.setInt(25, offset);
		pstmt.setString(26, yyyymmdd.format(sdfyyyymmddhhmmss.parse(startDate)));
		pstmt.setInt(27, offset);
		pstmt.setString(28, yyyymmdd.format(sdfyyyymmddhhmmss.parse(endDate)));
		pstmt.setInt(29, offset);
		pstmt.setInt(30, systemId);
		pstmt.setInt(31, clientId);
		pstmt.setInt(32, offset);
		pstmt.setString(33, yyyymmdd.format(sdfyyyymmddhhmmss.parse(startDate)));
		pstmt.setInt(34, offset);
		pstmt.setString(35, yyyymmdd.format(sdfyyyymmddhhmmss.parse(endDate)));
		pstmt.setInt(36, systemId);
		pstmt.setInt(37, clientId);
		pstmt.setString(38, yyyymmdd.format(sdfyyyymmddhhmmss.parse(startDate)));
		pstmt.setString(39, yyyymmdd.format(sdfyyyymmddhhmmss.parse(endDate)));
		pstmt.setInt(40, systemId);
		pstmt.setInt(41, clientId);
		pstmt.setString(42, yyyymmdd.format(sdfyyyymmddhhmmss.parse(startDate)));
		pstmt.setString(43, yyyymmdd.format(sdfyyyymmddhhmmss.parse(endDate)));
		pstmt.setInt(44, systemId);
		pstmt.setInt(45, clientId);
		pstmt.setString(46, yyyymmdd.format(sdfyyyymmddhhmmss.parse(startDate)));
		pstmt.setString(47, yyyymmdd.format(sdfyyyymmddhhmmss.parse(endDate)));
		pstmt.setInt(48, systemId);
		pstmt.setInt(49, clientId);
		pstmt.setString(50, yyyymmdd.format(sdfyyyymmddhhmmss.parse(startDate)));
		pstmt.setString(51, yyyymmdd.format(sdfyyyymmddhhmmss.parse(endDate)));
		pstmt.setInt(52, systemId);
		pstmt.setInt(53, clientId);
		pstmt.setString(54, yyyymmdd.format(sdfyyyymmddhhmmss.parse(startDate)));
		pstmt.setString(55, yyyymmdd.format(sdfyyyymmddhhmmss.parse(endDate)));
		rs = pstmt.executeQuery();
		while(rs.next()){
			ledgerDetails = new ArrayList<String>();
			ledgerDetails.add(ddmmyyyy.format(yyyymmdd.parse(rs.getString("INSERTED_DATE"))));//0
			ledgerDetails.add(rs.getString("TripNo"));//1
			ledgerDetails.add(rs.getString("CUSTOMER_TYPE"));//2
			ledgerDetails.add(rs.getString("ONACCOF"));//3
			ledgerDetails.add(rs.getString("BUSINESS_ID"));//4
			ledgerDetails.add(rs.getString("TOTAL_AMOUNT"));//5
			ledgerDetails.add(df.format(rs.getDouble("CASH_DISPENSE")));//6
			ledgerDetails.add(df.format(rs.getDouble("CASH_INWARD")));//7
			ledgerDetails.add(df.format(rs.getDouble("SEALED_BAG_DISPENSE")));//8
			ledgerDetails.add(df.format(rs.getDouble("SEALED_BAG_INWARD")));//9
			ledgerDetails.add(df.format(rs.getDouble("CHEQUE_INWARD")));//10
			ledgerDetails.add(df.format(rs.getDouble("CHEQUE_DISPENSE")));//11
			ledgerDetails.add(df.format(rs.getDouble("JEWELLERY_INWARD")));//12
			ledgerDetails.add(df.format(rs.getDouble("JEWELLERY_DISPENSE")));//13
			ledgerDetails.add(df.format(rs.getDouble("FOREX_INWARD")));//14
			ledgerDetails.add(df.format(rs.getDouble("FOREX_DISPENSE")));//15
			ledgerDetails.add(rs.getString("INWARD_MODE"));//16
			finalledgerDetails.add(ledgerDetails);
		}
	}catch(Exception e){
		e.printStackTrace();
	}
	finally{
		DBConnection.releaseConnectionToDB(con, pstmt, rs);
	}
	return finalledgerDetails;
}
public ArrayList<String> getCurrentVaultDetailsForPdf(int systemId,	int clientId, String cvsCustId) {
	Connection con = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	PreparedStatement pstmt3 = null;
	ResultSet rs3 = null;
	ArrayList<String> ledgerBalance = new ArrayList<String>();
	try{
		con = DBConnection.getConnectionToDB("AMS");
		String innerList1 = "";
		String innerList2 = "";
		String innerList3 = "";
		String innerList4 = "";
		 
		pstmt3 = con.prepareStatement(CashVanManagementStatements.GET_VAULT_INVENTORY_FOR_SEALED_BAG_TYPE_INNER_QUERY);
		pstmt3.setInt(1, systemId);
	    pstmt3.setInt(2, clientId);
	    rs3=pstmt3.executeQuery();	
		while(rs3.next()){			
			innerList1= innerList1+"'"+rs3.getString("SEAL_NO")+"'"+" , ";
		}
		innerList1 = innerList1.substring(0, innerList1.lastIndexOf(","));
		
		 pstmt3 = con.prepareStatement(CashVanManagementStatements.GET_VAULT_INVENTORY_FOR_SEALED_BAG_TYPE_INNER_QUERYY2);
		 pstmt3.setInt(1, systemId);
		 pstmt3.setInt(2, clientId);
		 rs3=pstmt3.executeQuery();	
		 while(rs3.next()){			
			 innerList2= innerList2+"'"+rs3.getString("SEAL_NO")+"'"+" , ";
		 }
		 innerList2 = innerList2.substring(0, innerList2.lastIndexOf(","));
		 
		 pstmt3 = con.prepareStatement(CashVanManagementStatements.GET_VAULT_INVENTORY_FOR_SEALED_BAG_TYPE_INNER_QUERY3);
		 pstmt3.setInt(1, systemId);
		 pstmt3.setInt(2, clientId);
		 rs3=pstmt3.executeQuery();	
		 while(rs3.next()){			
			 innerList3= innerList3+"'"+rs3.getString("SEAL_NO")+"'"+" , ";
		 }
		 innerList3 = innerList3.substring(0, innerList3.lastIndexOf(","));
		 
		 pstmt3 = con.prepareStatement(CashVanManagementStatements.GET_VAULT_INVENTORY_FOR_SEALED_BAG_TYPE_INNER_QUERY4);
		 pstmt3.setInt(1, systemId);
		 pstmt3.setInt(2, clientId);
		 rs3=pstmt3.executeQuery();	
		 while(rs3.next()){			
			 innerList4= innerList4+"'"+rs3.getString("SEAL_NO")+"'"+" , ";
		 }
		 innerList4 = innerList4.substring(0, innerList4.lastIndexOf(","));
		DBConnection.releaseConnectionToDB(null, pstmt3, rs3);
		
		pstmt = con.prepareStatement(CashVanManagementStatements.GET_CURRENT_INVENTORY.replace("a.SEAL_NO IN ( # )", " a.SEAL_NO IN ( "+innerList1+" )" ).replace("j.SEAL_NO IN ( # )", "j.SEAL_NO IN ( "+innerList4+" )").replace("ch.SEAL_NO IN ( # )", "ch.SEAL_NO IN ( "+innerList2+" )").replace("fx.SEAL_NO IN ( # )", "fx.SEAL_NO IN ( "+innerList3+" )"));
		 pstmt.setInt(1, systemId);
	     pstmt.setInt(2, clientId);
	     pstmt.setInt(3, Integer.parseInt(cvsCustId));
	     pstmt.setInt(4, systemId);
	     pstmt.setInt(5, clientId);
	     pstmt.setInt(6, Integer.parseInt(cvsCustId));
	     pstmt.setInt(7, systemId);
	     pstmt.setInt(8, clientId);
	     pstmt.setInt(9, Integer.parseInt(cvsCustId));
	     pstmt.setInt(10, systemId);
	     pstmt.setInt(11, clientId);
	     pstmt.setInt(12, Integer.parseInt(cvsCustId));
	     pstmt.setInt(13, systemId);
	     pstmt.setInt(14, clientId);
	     pstmt.setInt(15, Integer.parseInt(cvsCustId));
	     pstmt.setInt(16, systemId);
	     pstmt.setInt(17, clientId);
	     pstmt.setInt(18, Integer.parseInt(cvsCustId));
	     pstmt.setInt(19, systemId);
	     pstmt.setInt(20, clientId);
	     pstmt.setInt(21, Integer.parseInt(cvsCustId));
	     pstmt.setInt(22, systemId);  
	     pstmt.setInt(23, clientId);
	     pstmt.setInt(24, Integer.parseInt(cvsCustId));
	     pstmt.setInt(25, systemId);
	     pstmt.setInt(26, clientId);
	     pstmt.setInt(27, Integer.parseInt(cvsCustId));
	     pstmt.setInt(28, systemId);
	     pstmt.setInt(29, clientId);
	     pstmt.setInt(30, Integer.parseInt(cvsCustId));
	     pstmt.setInt(31, systemId);
	     pstmt.setInt(32, clientId);
	     pstmt.setInt(33, Integer.parseInt(cvsCustId));
		rs = pstmt.executeQuery();
		while(rs.next()){
			ledgerBalance.add(df.format(rs.getDouble("LEDGER_AMOUNT")));
			ledgerBalance.add(df.format(rs.getDouble("AVAILABLE_BALANCE")));
			ledgerBalance.add(df.format(rs.getDouble("SEALED_BAG_AMOUNT")));
			ledgerBalance.add(df.format(rs.getDouble("LEDGER_AMOUNT")+rs.getDouble("SEALED_BAG_AMOUNT")+rs.getDouble("CHECK_TOTAL_AMOUNT")+rs.getDouble("JEW_TOTAL_AMOUNT")+rs.getDouble("FOREX_TOTAL_AMOUNT")));
			ledgerBalance.add(df.format(rs.getDouble("CHECK_TOTAL_AMOUNT")));
			ledgerBalance.add(df.format(rs.getDouble("JEW_TOTAL_AMOUNT")));
			ledgerBalance.add(df.format(rs.getDouble("FOREX_TOTAL_AMOUNT")));
		}
	}catch(Exception e){
		e.printStackTrace();
	}finally{
		DBConnection.releaseConnectionToDB(con, pstmt, rs);
	}
	return ledgerBalance;
}
public String getCustomerName(int systemId, int clientId, int cvsCustId) {
	Connection con = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	String custName = "";
	try{
		con = DBConnection.getConnectionToDB("LMS");
		pstmt = con.prepareStatement(CashVanManagementStatements.GET_CUSTOMER_NAMES.replace("#", String.valueOf(cvsCustId)));
		pstmt.setInt(1, systemId);
		pstmt.setInt(2, clientId);
		rs = pstmt.executeQuery();
		if(rs.next()){
			custName = rs.getString("customerName");
		}
	}catch(Exception e){
		e.printStackTrace();
	}finally{
		DBConnection.releaseConnectionToDB(con, pstmt, rs);
	}
	return custName;
}
public JSONArray getDenominationDetails(int systemId, int clientId,	String cvsBusinessId, int uniqueId, int businessId) {
	Connection con = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	JSONArray jArr = new JSONArray();
	JSONObject obj = null;
	long denom5000 = 0;
	long denom2000 = 0;
	long denom1000 = 0;
	long denom500 = 0;
	long denom100 = 0;
	try{
		con = DBConnection.getConnectionToDB("AMS");
		pstmt = con.prepareStatement(CashVanManagementStatements.GET_PREV_DENOMINATION_DETAILS_FOR_ATM_REP);
		pstmt.setInt(1, systemId);
		pstmt.setInt(2, clientId);
		pstmt.setString(3, cvsBusinessId);
		pstmt.setInt(4, systemId);
		pstmt.setInt(5, clientId);
		pstmt.setInt(6, uniqueId);
		pstmt.setInt(7, businessId);
		rs = pstmt.executeQuery();
		while(rs.next()){
				denom5000 = rs.getLong("denom5000");
				denom2000 = rs.getLong("denom2000");
				denom1000 = rs.getLong("denom1000");
				denom500 = rs.getLong("denom500");
				denom100 = rs.getLong("denom100");
		}
		obj = new JSONObject();
		obj.put("denom5000", denom5000);
		obj.put("denom2000", denom2000);
		obj.put("denom1000", denom1000);
		obj.put("denom500", denom500);
		obj.put("denom100", denom100);
		jArr.put(obj);
	}catch(Exception e){
		e.printStackTrace();
	}finally{
		DBConnection.releaseConnectionToDB(con, pstmt, rs);
	}
	return jArr;
}

public static String[]  removeDuplicates(String[] numbersWithDuplicates) {

    // Sorting array to bring duplicates together      
    Arrays.sort(numbersWithDuplicates);     
  
    String[] result = new String[numbersWithDuplicates.length];
    String previous = numbersWithDuplicates[0];
    result[0] = previous;

    for (int i = 1; i < numbersWithDuplicates.length; i++) {
        String ch = numbersWithDuplicates[i];

        if (previous != ch) {
            result[i] = ch;
        }
        previous = ch;
    }
    return result;

}

public ArrayList<String> getGridForSummaryForJewelleryForReconcilation(int systemId,int customerId,int cvsCustId,String tripsheetNo,int dispenseId ){
	Connection con = null;
	PreparedStatement pstmt = null;
	ResultSet rs =null;
	PreparedStatement pstmt2 = null;
	ResultSet rs2 =null;
	ArrayList<String> dataList = new ArrayList<String>();
	try{
		con = DBConnection.getConnectionToDB("AMS");
		pstmt = con.prepareStatement(CashVanManagementStatements.GET_JEWELLERY_LIST_FOR_RECONCILATION);
		pstmt.setInt(1, systemId);
		pstmt.setInt(2, customerId);		
		pstmt.setInt(3, cvsCustId);
		pstmt.setInt(4,dispenseId);
		rs = pstmt.executeQuery();
		if(rs.next()){
			String sealNo = rs.getString("SEAL_NO");
			int onaccoff = rs.getInt("ON_ACC_OF");
			if(sealNo.contains(",")){
	    		  String sealNos[] = sealNo.split(",");
	    		  for(String sl: sealNos){
	    			String sealNoNew = sl;
	    			pstmt2 = con.prepareStatement(CashVanManagementStatements.GET_JEWELLERY_AMOUNT); 
	    			if(rs.getString("CUSTOMER_TYPE").equals("Cash Delivery")){
		    			pstmt2.setInt(1, onaccoff);	
	    			}else{
	    				pstmt2.setInt(1, cvsCustId);		
	    			}
	    		   	pstmt2.setString(2, sealNoNew.toUpperCase());    		   
	    		   	pstmt2.setInt(3, systemId);
	    			pstmt2.setInt(4, customerId);
	    		   	rs2= pstmt2.executeQuery();
	    		   	if(rs2.next()){
	    		   		dataList.add(sealNoNew+" - "+valueWithCommas(rs2.getDouble("TOTAL_AMOUNT")));
	    		  }
	    		  }
	    	  }else{
	    		  
	    		pstmt2 = con.prepareStatement(CashVanManagementStatements.GET_JEWELLERY_AMOUNT);  
	    		if(rs.getString("CUSTOMER_TYPE").equals("Cash Delivery")){
	    			pstmt2.setInt(1, onaccoff);	
    			}else{
    				pstmt2.setInt(1, cvsCustId);		
    			}	  		   	
	    		pstmt2.setString(2, sealNo.toUpperCase());    		   
	  		   	pstmt2.setInt(3, systemId);
	  			pstmt2.setInt(4, customerId);
	  		   	rs2= pstmt.executeQuery();
	    		if(rs2.next()){  
	    			dataList.add(sealNo+" - "+valueWithCommas(rs2.getDouble("TOTAL_AMOUNT")));

	    	  }
	    	  }			
		}
	}catch(Exception e){
		e.printStackTrace();
	}finally{
		DBConnection.releaseConnectionToDB(null, pstmt, rs);
		DBConnection.releaseConnectionToDB(con, pstmt2, rs2);
	}
	return dataList;
}
   
public ArrayList<String> getGridForSummaryForCheckForReconcilation(int systemId,int customerId,int cvsCustId,String tripsheetNo,int dispenseId ){
	Connection con = null;
	PreparedStatement pstmt = null;
	ResultSet rs =null;
	PreparedStatement pstmt2 = null;
	ResultSet rs2 =null;
	ArrayList<String> dataList = new ArrayList<String>();
	try{
		con = DBConnection.getConnectionToDB("AMS");
		pstmt = con.prepareStatement(CashVanManagementStatements.GET_CHECK_LIST_FOR_RECONCILATION);
		pstmt.setInt(1, systemId);
		pstmt.setInt(2, customerId);		
		pstmt.setInt(3, cvsCustId);
		pstmt.setInt(4,dispenseId);
		rs = pstmt.executeQuery();
		if(rs.next()){
			String sealNo = rs.getString("SEAL_NO");
			int onaccoff = rs.getInt("ON_ACC_OF");
			if(sealNo.contains(",")){
	    		  String sealNos[] = sealNo.split(",");
	    		  for(String sl: sealNos){
	    			String sealNoNew = sl;
	    			pstmt2 = con.prepareStatement(CashVanManagementStatements.GET_CHECK_AMOUNT); 
	    			if(rs.getString("CUSTOMER_TYPE").equals("Cash Delivery")){
		    			pstmt2.setInt(1, onaccoff);	
	    			}else{
	    				pstmt2.setInt(1, cvsCustId);		
	    			}
	    		   	pstmt2.setString(2, sealNoNew.toUpperCase());    		   
	    		   	pstmt2.setInt(3, systemId);
	    			pstmt2.setInt(4, customerId);
	    		   	rs2= pstmt2.executeQuery();
	    		   	if(rs2.next()){
	    		   		dataList.add(sealNoNew+" - "+valueWithCommas(rs2.getDouble("TOTAL_AMOUNT")));
	    		  }
	    		  }
	    	  }else{
	    		  
	    		pstmt2 = con.prepareStatement(CashVanManagementStatements.GET_CHECK_AMOUNT);  
	    		if(rs.getString("CUSTOMER_TYPE").equals("Cash Delivery")){
	    			pstmt2.setInt(1, onaccoff);	
    			}else{
    				pstmt2.setInt(1, cvsCustId);		
    			}
	  		   	pstmt2.setString(2, sealNo.toUpperCase());    		   
	  		   	pstmt2.setInt(3, systemId);
	  			pstmt2.setInt(4, customerId);
	  		   	rs2= pstmt.executeQuery();
	    		if(rs2.next()){  
	    			dataList.add(sealNo+" - "+valueWithCommas(rs2.getDouble("TOTAL_AMOUNT")));

	    	  }
	    	  }			
		}
	}catch(Exception e){
		e.printStackTrace();
	}finally{
		DBConnection.releaseConnectionToDB(null, pstmt, rs);
		DBConnection.releaseConnectionToDB(con, pstmt2, rs2);
	}
	return dataList;
}

public ArrayList<String> getGridForSummaryForForexForReconcilation(int systemId,int customerId,int cvsCustId,String tripsheetNo,int dispenseId ){
	Connection con = null;
	PreparedStatement pstmt = null;
	ResultSet rs =null;
	PreparedStatement pstmt2 = null;
	ResultSet rs2 =null;
	ArrayList<String> dataList = new ArrayList<String>();
	try{
		con = DBConnection.getConnectionToDB("AMS");
		pstmt = con.prepareStatement(CashVanManagementStatements.GET_FOREX_LIST_FOR_RECONCILATION);
		pstmt.setInt(1, systemId);
		pstmt.setInt(2, customerId);		
		pstmt.setInt(3, cvsCustId);
		pstmt.setInt(4,dispenseId);
		rs = pstmt.executeQuery();
		if(rs.next()){
			String sealNo = rs.getString("SEAL_NO");
			int onaccoff = rs.getInt("ON_ACC_OF");
			if(sealNo.contains(",")){
	    		  String sealNos[] = sealNo.split(",");
	    		  for(String sl: sealNos){
	    			String sealNoNew = sl;
	    			pstmt2 = con.prepareStatement(CashVanManagementStatements.GET_FOREX_AMOUNT); 
	    			if(rs.getString("CUSTOMER_TYPE").equals("Cash Delivery")){
		    			pstmt2.setInt(1, onaccoff);	
	    			}else{
	    				pstmt2.setInt(1, cvsCustId);		
	    			}
	    		   	pstmt2.setString(2, sealNoNew.toUpperCase());    		   
	    		   	pstmt2.setInt(3, systemId);
	    			pstmt2.setInt(4, customerId);
	    		   	rs2= pstmt2.executeQuery();
	    		   	if(rs2.next()){
	    		   		dataList.add(sealNoNew+" - "+valueWithCommas(rs2.getDouble("TOTAL_AMOUNT"))+" - "+rs2.getString("CURRENCY_CODE"));
	    		  }
	    		  }
	    	  }else{
	    		  
	    		pstmt2 = con.prepareStatement(CashVanManagementStatements.GET_FOREX_AMOUNT);  
	    		if(rs.getString("CUSTOMER_TYPE").equals("Cash Delivery")){
	    			pstmt2.setInt(1, onaccoff);	
    			}else{
    				pstmt2.setInt(1, cvsCustId);		
    			}
	  		   	pstmt2.setString(2, sealNo.toUpperCase());    		   
	  		   	pstmt2.setInt(3, systemId);
	  			pstmt2.setInt(4, customerId);
	  		   	rs2= pstmt.executeQuery();
	    		if(rs2.next()){  
	    			dataList.add(sealNo+" - "+valueWithCommas(rs2.getDouble("TOTAL_AMOUNT")));

	    	  }
	    	  }			
		}
	}catch(Exception e){
		e.printStackTrace();
	}finally{
		DBConnection.releaseConnectionToDB(null, pstmt, rs);
		DBConnection.releaseConnectionToDB(con, pstmt2, rs2);
	}
	return dataList;
}
public JSONArray getSuspenseReportDetails(int systemId, int clientId,	String startDate, String endDate, int offset,String type) {
	Connection con = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    JSONObject obj = null;
    JSONArray jArray = new JSONArray();
    int slcount = 0;
   
    try{
    	con = DBConnection.getConnectionToDB("AMS");
    	if(type.equals("Pending")){
    		pstmt = con.prepareStatement(CashVanManagementStatements.GET_SUSPENSE_REPORT_DETAILS.replace("#", "'PENDING'"));
    	}else{
    		pstmt = con.prepareStatement(CashVanManagementStatements.GET_SUSPENSE_REPORT_DETAILS.replace("#", "'SETTLED','SETTLEMENT PENDING'"));
    	}
    	pstmt.setInt(1, offset);
    	pstmt.setInt(2, systemId);
    	pstmt.setInt(3, clientId);
    	pstmt.setInt(4, offset);
    	pstmt.setString(5, startDate);
    	pstmt.setInt(6, offset);
    	pstmt.setString(7, endDate);
    	rs=pstmt.executeQuery();
    	while(rs.next()){
			if(rs.getString("short").equals("0")  && rs.getString("excess").equals("0") ){
			}else{
			slcount++;
			obj = new JSONObject();
			obj.put( "UIDDI", rs.getString("uniqueId"));
			obj.put( "slnoDataIndex", slcount);
			obj.put( "customerIdIndex", rs.getString("cvsCustId"));
    		obj.put( "customerDataIndex",rs.getString("customerName"));
    		obj.put( "tripsheetnoDataIndex",rs.getString("tripNo"));
    		obj.put( "dateindex",rs.getString("date"));
    		obj.put( "routeindex",rs.getString("routeName"));
    		obj.put( "businessIdIndex",rs.getString("businessId"));
    		obj.put( "businessTypeIndex",rs.getString("businessType"));
    		obj.put( "shortindex",rs.getString("short"));
    		obj.put( "excessindex",rs.getString("excess"));
    		obj.put("tripSheetDI", rs.getString("tripSheetNo"));
    		obj.put("statusIndex", rs.getString("status"));
    		jArray.put(obj);
			}	
    	}
    } catch (Exception e) {
    	e.printStackTrace();
    } finally {
    	DBConnection.releaseConnectionToDB(con, pstmt, rs);
    }
    return jArray;
}
public String saveReconciliationForAtmRep(int systemId, int clientId, String json,String uniqueId,String tripSheetNo,int userId) {
	String message = "";
	Connection con = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	int inserted = 0;
	int sysGeneratedId = 0;
	JSONArray js = null;
	JSONObject obj = null;
	long good5000 = 0;
	long good2000 = 0;
	long good1000 = 0;
	long good500 = 0;
	long good100 = 0;
	long bad5000 = 0;
	long bad2000 = 0;
	long bad1000 = 0;
	long bad500 = 0;
	long bad100 = 0;
	double totalAmount = 0;
	try{
		ArrayList<String> dataList = getDataForReconcilation(systemId,clientId,tripSheetNo,Integer.parseInt(uniqueId));
		int cVSCustId = Integer.parseInt(dataList.get(8));
		String reconciledDate =dataList.get(10);
		con = DBConnection.getConnectionToDB("AMS");
		if(json != null){
			String st = "["+json+"]";
			js = new JSONArray(st.toString());
		}
		for(int i =0; i<js.length(); i++){
			obj = js.getJSONObject(i);
			if(obj.getString("DenominationDataIndex").equals("5000")){
				good5000 = good5000 + Long.parseLong(obj.getString("goodCashPysicalDI")) + Long.parseLong(obj.getString("goodRejectedCashDI"));
				bad5000 = bad5000 + Long.parseLong(obj.getString("badPhysicalCashDI")) + Long.parseLong(obj.getString("badRejectedDI"));
			}
			if(obj.getString("DenominationDataIndex").equals("2000")){
				good2000 = good2000 + Long.parseLong(obj.getString("goodCashPysicalDI")) + Long.parseLong(obj.getString("goodRejectedCashDI"));
				bad2000 = bad2000 + Long.parseLong(obj.getString("badPhysicalCashDI")) + Long.parseLong(obj.getString("badRejectedDI"));
			}
			if(obj.getString("DenominationDataIndex").equals("1000")){
				good1000 = good1000 + Long.parseLong(obj.getString("goodCashPysicalDI")) + Long.parseLong(obj.getString("goodRejectedCashDI"));
				bad1000 = bad1000 + Long.parseLong(obj.getString("badPhysicalCashDI")) + Long.parseLong(obj.getString("badRejectedDI"));
			}
			if(obj.getString("DenominationDataIndex").equals("500")){
				good500 = good500 + Long.parseLong(obj.getString("goodCashPysicalDI")) + Long.parseLong(obj.getString("goodRejectedCashDI"));
				bad500 = bad500 + Long.parseLong(obj.getString("badPhysicalCashDI")) + Long.parseLong(obj.getString("badRejectedDI"));
			}
			if(obj.getString("DenominationDataIndex").equals("100")){
				good100 = good100 + Long.parseLong(obj.getString("goodCashPysicalDI")) + Long.parseLong(obj.getString("goodRejectedCashDI"));
				bad100 = bad100 + Long.parseLong(obj.getString("badPhysicalCashDI")) + Long.parseLong(obj.getString("badRejectedDI"));
			}
			pstmt = con.prepareStatement(CashVanManagementStatements.UPDATE_SUSPENSE_DETAILS_AFTER_RECONCILATION);
			pstmt.setLong(1, Long.parseLong(obj.getString("shortDI")));
			pstmt.setLong(2, Long.parseLong(obj.getString("excessDI")));
			pstmt.setLong(3, Long.parseLong(obj.getString("gernalDI")));
			pstmt.setLong(4, Long.parseLong(obj.getString("goodCashPysicalDI")));
			pstmt.setLong(5, Long.parseLong(obj.getString("badPhysicalCashDI")));
			pstmt.setLong(6, Long.parseLong(obj.getString("goodRejectedCashDI")));
			pstmt.setLong(7, Long.parseLong(obj.getString("badRejectedDI")));
			pstmt.setInt(8, systemId);
			pstmt.setInt(9, clientId);
			pstmt.setInt(10, Integer.parseInt(uniqueId));
			pstmt.setInt(11, Integer.parseInt(obj.getString("DenominationDataIndex")));
			pstmt.executeUpdate();
		}
		totalAmount = (good5000 * 5000)+(bad5000 * 5000)+ (good2000 * 2000) + (bad2000 * 2000) + (good1000 * 1000) + (bad1000 * 1000) + (good500 * 500) + (bad500 * 500) + (good100 * 100) + (bad100 * 100);
		pstmt = con.prepareStatement(CashVanManagementStatements.ISERT_CASH_INWARD_DETAILS_FOR_RECONCILATION,Statement.RETURN_GENERATED_KEYS);
		pstmt.setString(1, "TRIP");
		pstmt.setInt(2, cVSCustId);
		pstmt.setString(3, "");
		pstmt.setDouble(4, totalAmount);
		pstmt.setString(5, "CASH");
		pstmt.setInt(6, clientId);
		pstmt.setInt(7, systemId);
		pstmt.setInt(8, userId);
		pstmt.setString(9, tripSheetNo);
		pstmt.setString(10, reconciledDate);
		pstmt.setInt(11, Integer.parseInt(uniqueId));
		pstmt.setString(12, "");
		inserted = pstmt.executeUpdate();
		rs = pstmt.getGeneratedKeys();
		if(rs.next()){
			sysGeneratedId = rs.getInt(1);
		}
		if(inserted > 0){
			for(int i =0; i<2; i++){
				if(i == 0){
					pstmt = con.prepareStatement(CashVanManagementStatements.INSERT_DENOMINATION_DETAILS);
	       		   	pstmt.setInt(1, sysGeneratedId);
	       			pstmt.setInt(2, 0);
	       			pstmt.setInt(3, 0);
	       			pstmt.setInt(4, 0);
	       			pstmt.setInt(5, 0);
	       			pstmt.setInt(6, 0);
	       		   	pstmt.setInt(7, 0);
	       			pstmt.setLong(8, good100);
	       		   	pstmt.setLong(9, good500);
	       		   	pstmt.setLong(10, good1000);
	       			pstmt.setLong(11, good2000); 
	       			pstmt.setLong(12, good5000); 
	       		   	pstmt.setString(13, "GOOD"); 
	       		    int updatecount = pstmt.executeUpdate();
	          		
	       		    if(updatecount>0){
	 	       		    updateVaultTrasit(con,cVSCustId,clientId,systemId,0,0,0,0,0,0,good100,good500,good1000,good2000,good5000,0,0,0,0,0,0,0,0,0,0,0,userId,"Inward");
	 	       		}
	     		}
	       		if(i == 1){
	       			pstmt = con.prepareStatement(CashVanManagementStatements.INSERT_DENOMINATION_DETAILS);
	                pstmt.setInt(1, sysGeneratedId);
	       			pstmt.setInt(2, 0);
	       			pstmt.setInt(3, 0);
	       			pstmt.setInt(4, 0);
	       			pstmt.setInt(5, 0);
	       			pstmt.setInt(6, 0);
	       		   	pstmt.setInt(7, 0);
	       			pstmt.setLong(8, bad100);
	       		   	pstmt.setLong(9, bad500);
	       		   	pstmt.setLong(10, bad1000);
	       			pstmt.setLong(11, bad2000); 
	       			pstmt.setLong(12, bad5000); 
	       		   	pstmt.setString(13, "BAD"); 
	          		pstmt.executeUpdate();
	       		}
			}
		}
		pstmt = con.prepareStatement(CashVanManagementStatements.UPDATE_DESPENSE);
    	pstmt.setString(1, tripSheetNo);
        pstmt.setInt(2, Integer.parseInt(uniqueId));
        int c = pstmt.executeUpdate();
        if(c>0){
        	message = "Reconciled successfully"; 
        }else{
        	message = "Error"; 
        }
	}catch(Exception e){
		e.printStackTrace();
	}finally{
		DBConnection.releaseConnectionToDB(con, pstmt, rs);
	}
	return message;
}

public String amendMentFunction(int systemId, int clientId, int uniqueId,String lastRow,int userId,String tripSheetNo) {
	String msg = "";
	Connection con = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	int amended = 0;
	try{
		con = DBConnection.getConnectionToDB("AMS");
		pstmt = con.prepareStatement(CashVanManagementStatements.GET_CVS_CUS_TWISE_DISPENSE_RECORD.replace("#", "UNIQUE_ID=?"));
		pstmt.setInt(1, systemId);
		pstmt.setInt(2, clientId);
		pstmt.setInt(3, uniqueId);
		rs = pstmt.executeQuery();
		if(rs.next()){
			pstmt = con.prepareStatement(CashVanManagementStatements.UPDATE_VAULT_TRANSIT_BEFORE_CLEARING_DISPENSE);
			pstmt.setLong(1, rs.getLong("denom5000"));
			pstmt.setLong(2, rs.getLong("denom2000"));
			pstmt.setLong(3, rs.getLong("denom1000"));
			pstmt.setLong(4, rs.getLong("denom500"));
			pstmt.setLong(5, rs.getLong("denom100"));
			pstmt.setLong(6, rs.getLong("denom50"));
			pstmt.setLong(7, rs.getLong("denom20"));
			pstmt.setLong(8, rs.getLong("denom10"));
			pstmt.setLong(9, rs.getLong("denom5"));
			pstmt.setLong(10, rs.getLong("denom2"));
			pstmt.setLong(11, rs.getLong("denom1"));
			pstmt.setInt(12, systemId);
			pstmt.setInt(13, clientId);
			pstmt.setInt(14, rs.getInt("CVS_CUSTOMER_ID"));
			pstmt.executeUpdate();
		}
		pstmt = con.prepareStatement(CashVanManagementStatements.GET_SEAL_NO_FROM_DISPENSE.replace("#", "UNIQUE_ID=?"));
		pstmt.setInt(1, systemId);
		pstmt.setInt(2, clientId);
		pstmt.setInt(3, uniqueId);
		pstmt.setString(4, "%Sealed Bag%");
		rs = pstmt.executeQuery();
		while(rs.next()){
			String sealNoNew = "";
			String[] sealNo = rs.getString("sealNo").split(",");
			for(String s: sealNo){
				sealNoNew = sealNoNew+","+"'"+s+"'";
			}	
			pstmt = con.prepareStatement(CashVanManagementStatements.UPDATE_SEALBAG_STATUS_IN_VAULT_INWARD.replace("#", sealNoNew.substring(1,sealNoNew.length())));
			pstmt.setString(1, "Inward");
			pstmt.setInt(2, systemId);
			pstmt.setInt(3, clientId);
			pstmt.setInt(4, rs.getInt("custId"));
			pstmt.setString(5, "SEALED BAG");
			pstmt.executeUpdate();
		}
		pstmt = con.prepareStatement(CashVanManagementStatements.GET_SEAL_NO_FROM_DISPENSE.replace("#", "TRIP_SHEET_NO=? and TRIP_STATUS='PENDING'"));
		pstmt.setInt(1, systemId);
		pstmt.setInt(2, clientId);
		pstmt.setString(3, tripSheetNo);
		pstmt.setString(4, "%Cheque%");
		rs = pstmt.executeQuery();
		while(rs.next()){
			String checkNoNew = "";
			String[] checkNo = rs.getString("sealNo").split(",");
			for(String s: checkNo){
				checkNoNew = checkNoNew+","+"'"+s+"'";
			}	
			pstmt = con.prepareStatement(CashVanManagementStatements.UPDATE_SEALBAG_STATUS_IN_VAULT_INWARD.replace("#", checkNoNew.substring(1,checkNoNew.length())));
			pstmt.setString(1, "Inward");
			pstmt.setInt(2, systemId);
			pstmt.setInt(3, clientId);
			pstmt.setInt(4, rs.getInt("custId"));
			pstmt.setString(5, "CHEQUE");
			pstmt.executeUpdate();
		}
		pstmt = con.prepareStatement(CashVanManagementStatements.GET_SEAL_NO_FROM_DISPENSE.replace("#", "TRIP_SHEET_NO=? and TRIP_STATUS='PENDING'"));
		pstmt.setInt(1, systemId);
		pstmt.setInt(2, clientId);
		pstmt.setString(3, tripSheetNo);
		pstmt.setString(4, "%Jewellery%");
		rs = pstmt.executeQuery();
		while(rs.next()){
			String jewelleryNoNew = "";
			String[] jewelleryNo = rs.getString("sealNo").split(",");
			for(String s: jewelleryNo){
				jewelleryNoNew = jewelleryNoNew+","+"'"+s+"'";
			}	
			pstmt = con.prepareStatement(CashVanManagementStatements.UPDATE_SEALBAG_STATUS_IN_VAULT_INWARD.replace("#", jewelleryNoNew.substring(1,jewelleryNoNew.length())));
			pstmt.setString(1, "Inward");
			pstmt.setInt(2, systemId);
			pstmt.setInt(3, clientId);
			pstmt.setInt(4, rs.getInt("custId"));
			pstmt.setString(5, "JEWELLERY");
			pstmt.executeUpdate();
		}
		pstmt = con.prepareStatement(CashVanManagementStatements.GET_SEAL_NO_FROM_DISPENSE.replace("#", "TRIP_SHEET_NO=? and TRIP_STATUS='PENDING'"));
		pstmt.setInt(1, systemId);
		pstmt.setInt(2, clientId);
		pstmt.setString(3, tripSheetNo);
		pstmt.setString(4, "%Foreign Currency%");
		rs = pstmt.executeQuery();
		while(rs.next()){
			String foreignNoNew = "";
			String[] foreignNo = rs.getString("sealNo").split(",");
			for(String s: foreignNo){
				foreignNoNew = foreignNoNew+","+"'"+s+"'";
			}	
			pstmt = con.prepareStatement(CashVanManagementStatements.UPDATE_SEALBAG_STATUS_IN_VAULT_INWARD.replace("#", foreignNoNew.substring(1,foreignNoNew.length())));
			pstmt.setString(1, "Inward");
			pstmt.setInt(2, systemId);
			pstmt.setInt(3, clientId);
			pstmt.setInt(4, rs.getInt("custId"));
			pstmt.setString(5, "FOREIGN CURRENCY");
			pstmt.executeUpdate();
		}
		pstmt = con.prepareStatement(CashVanManagementStatements.DELETE_EXISTING_DISPENSE_RECORD.replace("#", "UNIQUE_ID=?"));
		pstmt.setInt(1, systemId);
		pstmt.setInt(2, clientId);
		pstmt.setInt(3, uniqueId);
		amended = pstmt.executeUpdate();
		if(amended > 0){
			msg = "Record has been amended successfully";
			if(lastRow.equals("yes")){
				pstmt = con.prepareStatement(CashVanManagementStatements.CLOSE_THE_TRIP);
				pstmt.setInt(1, userId);
				pstmt.setInt(2, systemId);
				pstmt.setInt(3, clientId);
				pstmt.setString(4, tripSheetNo);
				pstmt.executeUpdate();
			}
		}else{
			msg = "Error while amending the record"; 
		}
	}catch(Exception e){
		e.printStackTrace();
	}finally{
		DBConnection.releaseConnectionToDB(con, pstmt, rs);
	}
	return msg;
}
public JSONArray getCheckNos(int systemId, int clientId, int customerId, String btn) {
	Connection con = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	JSONArray jArray = new JSONArray();
	JSONObject obj = null;
	try{
		con = DBConnection.getConnectionToDB("AMS");
		if(btn.equals("Create")){
			pstmt = con.prepareStatement(CashVanManagementStatements.GET_SEAL_NO_FOR_CREATE);
		}else{
			pstmt = con.prepareStatement(CashVanManagementStatements.GET_SEAL_NO_FOR_MODIFY);
		}
		pstmt.setInt(1, systemId);
		pstmt.setInt(2, clientId);
		pstmt.setInt(3, customerId);
		pstmt.setString(4, "CHEQUE");
		rs = pstmt.executeQuery();
		while(rs.next()){
			obj = new JSONObject();
			obj.put("checkNo", rs.getString("sealNo"));
			jArray.put(obj);
		}
	}catch(Exception e){
		e.printStackTrace();
	}finally{
		DBConnection.releaseConnectionToDB(con, pstmt, rs);
	}
	return jArray;
}
public JSONArray getJewellaryNos(int systemId, int clientId, int customerId,String btn) {
	Connection con = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	JSONArray jArray = new JSONArray();
	JSONObject obj = null;
	try{
		con = DBConnection.getConnectionToDB("AMS");
		if(btn.equals("Create")){
			pstmt = con.prepareStatement(CashVanManagementStatements.GET_SEAL_NO_FOR_CREATE);
		}else{
			pstmt = con.prepareStatement(CashVanManagementStatements.GET_SEAL_NO_FOR_MODIFY);
		}
		pstmt.setInt(1, systemId);
		pstmt.setInt(2, clientId);
		pstmt.setInt(3, customerId);
		pstmt.setString(4, "JEWELLERY");
		rs = pstmt.executeQuery();
		while(rs.next()){
			obj = new JSONObject();
			obj.put("jewellary", rs.getString("sealNo"));
			jArray.put(obj);
		}
	}catch(Exception e){
		e.printStackTrace();
	}finally{
		DBConnection.releaseConnectionToDB(con, pstmt, rs);
	}
	return jArray;
}
public JSONArray getForeignCurrency(int systemId, int clientId, int customerId,String btn) {
	Connection con = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	JSONArray jArray = new JSONArray();
	JSONObject obj = null;
	try{
		con = DBConnection.getConnectionToDB("AMS");
		if(btn.equals("Create")){
			pstmt = con.prepareStatement(CashVanManagementStatements.GET_SEAL_NO_FOR_CREATE);
		}else{
			pstmt = con.prepareStatement(CashVanManagementStatements.GET_SEAL_NO_FOR_MODIFY);
		}
		pstmt.setInt(1, systemId);
		pstmt.setInt(2, clientId);
		pstmt.setInt(3, customerId);
		pstmt.setString(4, "FOREIGN CURRENCY");
		rs = pstmt.executeQuery();
		while(rs.next()){
			obj = new JSONObject();
			obj.put("foreignCurrency", rs.getString("sealNo"));
			jArray.put(obj);
		}
	}catch(Exception e){
		e.printStackTrace();
	}finally{
		DBConnection.releaseConnectionToDB(con, pstmt, rs);
	}
	return jArray;
}
public JSONArray getShortExcessDetails(int systemId, int clientId, String uId, String typeId) {
	Connection con = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	JSONArray jArray = new JSONArray();
	JSONObject obj = null;
	try{
		con = DBConnection.getConnectionToDB("AMS");
		pstmt = con.prepareStatement(CashVanManagementStatements.GET_SUSPENSE_DENOMINATION_DETAILS);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, clientId);
			pstmt.setInt(3, Integer.parseInt(uId));
			rs = pstmt.executeQuery();
			while(rs.next()){
				obj = new JSONObject();
				obj.put("UIDDI", rs.getInt("UID"));
				obj.put("DenominationDataIndex", rs.getInt("denomination"));
				obj.put("shortDI", rs.getInt("short"));
				obj.put("shortValueDI", rs.getInt("denomination") * rs.getInt("short"));
				obj.put("excessDI", rs.getInt("excess"));
				obj.put("excessValueDI", rs.getInt("denomination") * rs.getInt("excess"));
				if(typeId.equals("Closed")){
					obj.put("writeOffDI", rs.getInt("writeoff"));
					obj.put("closeDI", rs.getInt("closed"));
				}else{
					obj.put("writeOffDI", 0);
					obj.put("closeDI", 0);
				}
				jArray.put(obj);
			}
	}catch(Exception e){
		e.printStackTrace();
	}finally{
		DBConnection.releaseConnectionToDB(con, pstmt, rs);
	}
	return jArray;
}
public String updateWriteOffOrClose(int systemId, int clientId, String json, String dispenseUID, int userId, String cVSCustId, String tripSheetNo,String remarks,String chequeNo) {
	String message = "";
	Connection con = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	JSONArray js = null;
	JSONObject obj = null;
	long good5000 = 0;
	long good2000 = 0;
	long good1000 = 0;
	long good500 = 0;
	long good100 = 0;
	try{
		con = DBConnection.getConnectionToDB("AMS");
		if(json != null){
			String st = "["+json+"]";
			js = new JSONArray(st.toString());
		}
		for(int i =0; i<js.length(); i++){
			obj = js.getJSONObject(i);
			if(obj.getString("DenominationDataIndex").equals("5000")){
				good5000 = good5000 + Long.parseLong(obj.getString("writeOffDI"));
			}
			if(obj.getString("DenominationDataIndex").equals("2000")){
				good2000 = good2000 + Long.parseLong(obj.getString("writeOffDI"));
			}
			if(obj.getString("DenominationDataIndex").equals("1000")){
				good1000 = good1000 + Long.parseLong(obj.getString("writeOffDI"));
			}
			if(obj.getString("DenominationDataIndex").equals("500")){
				good500 = good500 + Long.parseLong(obj.getString("writeOffDI"));
			}
			if(obj.getString("DenominationDataIndex").equals("100")){
				good100 = good100 + Long.parseLong(obj.getString("writeOffDI"));
			}
			pstmt = con.prepareStatement(CashVanManagementStatements.UPDATE_SUSPENSE_DETAILS);
			pstmt.setLong(1, Long.parseLong(obj.getString("writeOffDI")));
			pstmt.setLong(2, Long.parseLong(obj.getString("closeDI")));
			pstmt.setInt(3, systemId);
			pstmt.setInt(4, clientId);
			pstmt.setInt(5, Integer.parseInt(obj.getString("UIDDI")));
			pstmt.executeUpdate();
		}
		pstmt = con.prepareStatement(CashVanManagementStatements.UPDATE_DISPENSE_RECORD_AFTER_SUSPENSE);
		pstmt.setString(1, "SETTLEMENT PENDING");
		pstmt.setString(2, remarks);
		pstmt.setInt(3, userId);
		pstmt.setString(4, chequeNo);
		pstmt.setInt(5, systemId);
		pstmt.setInt(6, clientId);
		pstmt.setInt(7, Integer.parseInt(dispenseUID));
		int update = pstmt.executeUpdate();
		if(update > 0){
        	message = "Closed successfully"; 
        }else{
        	message = "Error"; 
        }
	}catch(Exception e){
		e.printStackTrace();
	}finally{
		DBConnection.releaseConnectionToDB(con, pstmt, rs);
	}
	return message;
}
public  HashMap<String, Float> convertCurrency() {
	ResultSet rs  = null;
	Connection connn  = null;
	PreparedStatement pstmt = null;
	HashMap<String, Float> hm = new HashMap<String, Float>();
	try {
	connn = DBConnection.getConnectionToDB("AMS");
	pstmt = connn.prepareStatement(" select CURRENCY_CODE,LKR_RATE from  AMS.dbo.CURRENCY_RATES ");
	rs = pstmt.executeQuery();
	while(rs.next()){
		hm.put(rs.getString("CURRENCY_CODE"),rs.getFloat("LKR_RATE"));	
	}
	} catch (Exception e) {
	e.printStackTrace();
	}
	finally{
	DBConnection.releaseConnectionToDB(connn, pstmt, rs);
	}
	return hm;
	}


public double getForex(Connection con , int systemId,int custId){
	double forextotal = 0.0;
	PreparedStatement pstmt = null;
	PreparedStatement pstmt3 = null;
	ResultSet rs = null ;
	ResultSet rs3 = null ;
	
	try{
		
		 HashMap<String, Float> hmm =  convertCurrency();
		
	 String innerList = "' '";
	 pstmt3 = con.prepareStatement(CashVanManagementStatements.GET_VAULT_INVENTORY_FOR_SEALED_BAG_TYPE_INNER_QUERY3); 
	 pstmt3.setInt(1, systemId);
     pstmt3.setInt(2, custId);   
     rs3=pstmt3.executeQuery();	
	 while(rs3.next()){	
		 if(!rs3.getString("SEAL_NO").isEmpty()){
		 innerList= innerList+"'"+rs3.getString("SEAL_NO")+"'"+" , ";
		 }
	 }
	 if(innerList.contains(",")){
	 innerList = innerList.substring(0, innerList.lastIndexOf(","));
	 } 
	    
	    pstmt = con.prepareStatement(CashVanManagementStatements.GET_FOREX_WITH_CODE.replace("#", innerList));
	    
	    pstmt.setString(1, "FOREIGN CURRENCY" );
		pstmt.setInt(2, systemId);
		pstmt.setInt(3, custId);
		pstmt.setString(4, "FOREIGN CURRENCY" );
		pstmt.setInt(5, systemId);
		pstmt.setInt(6, custId);		
		rs = pstmt.executeQuery();
		while (rs.next()){
			double forextotal2 = 0.0;
			if( hmm.get(rs.getString("CURRENCY_CODE")) != null ){
				if(hmm.containsKey(rs.getString("CURRENCY_CODE"))){
				forextotal2 = rs.getDouble("TOTAL_AMOUNT") * hmm.get(rs.getString("CURRENCY_CODE")); 
				}
			}
			
			forextotal = forextotal+forextotal2;
		}

	} catch(Exception e){
		e.printStackTrace();
	}
	finally{
	    DBConnection.releaseConnectionToDB(null, pstmt3, rs3);
		DBConnection.releaseConnectionToDB(null, pstmt, rs);
	}
	return forextotal;
}

public HashMap<Integer, Double> getForexOrderByCvsCustId(int systemId,int custId){
	double forextotal = 0.0;
	PreparedStatement pstmt = null;
	PreparedStatement pstmt3 = null;
	ResultSet rs = null ;
	ResultSet rs3 = null ;
	 HashMap<Integer, Double> hmm2 =null;
	 Connection con = null;
	try{
		
		 HashMap<String, Float> hmm =  convertCurrency();
		 hmm2 =  new HashMap<Integer, Double> ();
		 con = DBConnection.getConnectionToDB("AMS");
	 String innerList = "' '";
	 pstmt3 = con.prepareStatement(CashVanManagementStatements.GET_VAULT_INVENTORY_FOR_SEALED_BAG_TYPE_INNER_QUERY3); 
	 pstmt3.setInt(1, systemId);
     pstmt3.setInt(2, custId);   
     rs3=pstmt3.executeQuery();	
	 while(rs3.next()){	
		 if(!rs3.getString("SEAL_NO").isEmpty()){
		 innerList= innerList+"'"+rs3.getString("SEAL_NO")+"'"+" , ";
		 }
	 }
	 if(innerList.contains(",")){
	 innerList = innerList.substring(0, innerList.lastIndexOf(","));
	 } 
	    
	    pstmt = con.prepareStatement(CashVanManagementStatements.GET_FOREX_WITH_CODE_ORDER_BY_CVSCUSTOMER.replace("#", innerList));
	    
	    pstmt.setString(1, "FOREIGN CURRENCY" );
		pstmt.setInt(2, systemId);
		pstmt.setInt(3, custId);
		pstmt.setString(4, "FOREIGN CURRENCY" );
		pstmt.setInt(5, systemId);
		pstmt.setInt(6, custId);		
		rs = pstmt.executeQuery();
		int preid = 0;
		while (rs.next()){
			
			int curid = rs.getInt("CVS_CUST_ID");
			if(preid == curid ){
			double forextotal2 = 0.0;
			if( hmm.get(rs.getString("CURRENCY_CODE")) != null ){
				if(hmm.containsKey(rs.getString("CURRENCY_CODE"))){
				forextotal2 = rs.getDouble("TOTAL_AMOUNT") * hmm.get(rs.getString("CURRENCY_CODE")); 
				}
			}
			
			forextotal = forextotal+forextotal2;
			hmm2.remove(rs.getInt("CVS_CUST_ID"));
			hmm2.put(rs.getInt("CVS_CUST_ID"), Double.parseDouble(df.format(forextotal)));
			}else{
				double forextotal2 = 0.0;
				if( hmm.get(rs.getString("CURRENCY_CODE")) != null ){
					if(hmm.containsKey(rs.getString("CURRENCY_CODE"))){
					forextotal2 = rs.getDouble("TOTAL_AMOUNT") * hmm.get(rs.getString("CURRENCY_CODE")); 
					}
				}
				hmm2.put(rs.getInt("CVS_CUST_ID"), Double.parseDouble(df.format(forextotal2)));
				forextotal = forextotal2;
			}
			
			preid =rs.getInt("CVS_CUST_ID"); 
			
		}

	} catch(Exception e){
		e.printStackTrace();
	}
	finally{
	    DBConnection.releaseConnectionToDB(null, pstmt3, rs3);
		DBConnection.releaseConnectionToDB(con, pstmt, rs);
	}
	return hmm2;
}

public String updateSealBag(int clientId, int systemId ,String sealNo) {
	Connection con = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
    String message = "";
	try{
		con = DBConnection.getConnectionToDB("AMS");
		pstmt = con.prepareStatement(CashVanManagementStatements.UPDATE_SEAL_BAG_STATUS);
		pstmt.setInt(1, systemId);
		pstmt.setInt(2, clientId);
		pstmt.setString(3, sealNo);
		int i = pstmt.executeUpdate();
		if(i>0){
			message = "Saved Successfully!!" ;
		}else{
			message = "Failed To Save!!" ;
		}
	}catch(Exception e){
		e.printStackTrace();
	}finally{
		DBConnection.releaseConnectionToDB(con, pstmt, rs);
	}
	return message;
}
public String settlementSuspenseRecord(int systemId, int clientId, String uniqueId,String cvsCustId, String tripSheetNo,int userId) {
	Connection con = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
    String message = "";
    double totalAmount = 0;
    long good5000 = 0;
    long good2000 = 0;
    long good1000 = 0;
    long good500 = 0;
    long good100 = 0;
    int inserted = 0;
    int sysGeneratedId = 0;
    int updatecount = 0; 
	try{
		con = DBConnection.getConnectionToDB("AMS");
		pstmt = con.prepareStatement(CashVanManagementStatements.GET_SUSPENSE_DETAIL_FOR_PARTICULAR_DISPENSE);
		pstmt.setInt(1, systemId);
		pstmt.setInt(2, clientId);
		pstmt.setInt(3, Integer.parseInt(uniqueId));
		rs = pstmt.executeQuery();
		while(rs.next()){
			if(rs.getInt("denomination") == 5000){
				good5000 = rs.getLong("writeOff");
			}
			if(rs.getInt("denomination") == 2000){
				good2000 = rs.getLong("writeOff");
			}
			if(rs.getInt("denomination") == 1000){
				good1000 = rs.getLong("writeOff");
			}
			if(rs.getInt("denomination") == 500){
				good500 = rs.getLong("writeOff");
			}
			if(rs.getInt("denomination") == 100){
				good100 = rs.getLong("writeOff");
			}
		}
		totalAmount = (good5000 * 5000)+ (good2000 * 2000) + (good1000 * 1000) + (good500 * 500) + (good100 * 100);
		pstmt = con.prepareStatement(CashVanManagementStatements.ISERT_CASH_INWARD_DETAILS_FOR_RECONCILATION,Statement.RETURN_GENERATED_KEYS);
		pstmt.setString(1, "SUSPEND TRIP");
		pstmt.setInt(2, Integer.parseInt(cvsCustId));
		pstmt.setString(3, "");
		pstmt.setDouble(4, totalAmount);
		pstmt.setString(5, "CASH");
		pstmt.setInt(6, clientId);
		pstmt.setInt(7, systemId);
		pstmt.setInt(8, userId);
		pstmt.setString(9, tripSheetNo);
		pstmt.setString(10, yyyymmdd.format(new Date()));
		pstmt.setInt(11, Integer.parseInt(uniqueId));
		pstmt.setString(12, "");
		inserted = pstmt.executeUpdate();
		rs = pstmt.getGeneratedKeys();
		if(rs.next()){
			sysGeneratedId = rs.getInt(1);
		}
		if(inserted > 0){
			pstmt = con.prepareStatement(CashVanManagementStatements.INSERT_DENOMINATION_DETAILS);
	       	pstmt.setInt(1, sysGeneratedId);
	       	pstmt.setInt(2, 0);
	       	pstmt.setInt(3, 0);
	       	pstmt.setInt(4, 0);
	       	pstmt.setInt(5, 0);
	       	pstmt.setInt(6, 0);
	       	pstmt.setInt(7, 0);
	       	pstmt.setLong(8, good100);
	       	pstmt.setLong(9, good500);
	       	pstmt.setLong(10, good1000);
	       	pstmt.setLong(11, good2000); 
	       	pstmt.setLong(12, good5000); 
	       	pstmt.setString(13, "GOOD"); 
	       	updatecount = pstmt.executeUpdate();
	        if(updatecount>0){
	        	updateVaultTrasit(con,Integer.parseInt(cvsCustId),clientId,systemId,0,0,0,0,0,0,good100,good500,good1000,good2000,good5000,0,0,0,0,0,0,0,0,0,0,0,userId,"Inward");
	 	    }
	    }
		if(inserted > 0 && updatecount > 0) {
			pstmt = con.prepareStatement(CashVanManagementStatements.UPDATE_DISPENSE_RECORD_AFTER_SETTLEMENT);
			pstmt.setString(1, "SETTLED");
			pstmt.setInt(2, systemId);
			pstmt.setInt(3, clientId);
			pstmt.setInt(4, Integer.parseInt(uniqueId));
			int update = pstmt.executeUpdate();
			if(update > 0){
	        	message = "Setteled successfully"; 
	        }else{
	        	message = "Error"; 
	        }
		}
	}catch(Exception e){
		e.printStackTrace();
	}finally{
		DBConnection.releaseConnectionToDB(con, pstmt, rs);
	}
	return message;
}
public JSONArray getNonAssignedBusinessIds(int systemId, int clientId, String routeId,String tripSheetNo) {
	Connection con = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	JSONArray jArray = new JSONArray();
	JSONObject obj = null;
	try{
		con = DBConnection.getConnectionToDB("AMS");
		pstmt = con.prepareStatement(CashVanManagementStatements.GET_NON_ASSOCIATED_BUSINESS_ID);
		pstmt.setInt(1, systemId);
		pstmt.setInt(2, clientId);
		pstmt.setInt(3, Integer.parseInt(routeId));
		pstmt.setInt(4, systemId);
		pstmt.setInt(5, clientId);
		pstmt.setString(6, tripSheetNo);
		rs = pstmt.executeQuery();
		while(rs.next()){
			obj = new JSONObject();
			obj.put("businessId", rs.getInt("Id"));
			obj.put("businessIdName", rs.getString("businessId"));
			obj.put("businessType", rs.getString("businessType"));
			obj.put("location", rs.getString("location"));
			obj.put("cvsCustomer", rs.getString("customerName"));
			obj.put("cvsCustomerId", rs.getString("customerId"));
			jArray.put(obj);
		}
	}catch(Exception e){
		e.printStackTrace();
	}finally{
		DBConnection.releaseConnectionToDB(con, pstmt, rs);
	}
	return jArray;
}
//t4u506 passing 2 parameters String DelivCustomerId, String DelCustomerName  //

public String insertNewBusinessDetail(int systemId, int clientId, String routeId, String tripSheetNo, String businessType, String businessId, int onAccOf, String sealOrCash, String sealNo,	String chequeNo, String jewelleryNo,
				String foreignCurrencyNo, int denom5000, int denom2000, int denom1000, int denom500, int denom100, int denom50, int denom20, int denom10, int denom5,int denom2, int denom1,String cvsCustomerId, String cvsCustomerName, int userId,String onAccName,String date,
				 String DelCustomerName,String DelivCustomerId) {
	String message = "";
	Connection con = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	double totalSealAmount = 0;
	double totalChequeAmount = 0;
	double totalJewellearyAmount = 0;
	double totalForeignCurrencyAmount = 0;
	double totalCashAmount = 0;
	int inserted = 0;
	String message1 = "";
	try{
		if(businessType.equals("ATM Replenishment")){
			message1 = "Entered dispenses are exceeding over available dispenses for the customer - "+cvsCustomerName;
		}else if(businessType.equals("Cash Delivery") && sealOrCash.contains("Cash")){
			message1 = "Entered dispenses are exceeding over available dispenses for the customer - "+cvsCustomerName;
		}
		con = DBConnection.getConnectionToDB("AMS");
		if(businessType.equals("ATM Replenishment") || (businessType.equals("Cash Delivery") && sealOrCash.contains("Cash"))){
		if(businessType.equals("ATM Replenishment")){
			pstmt = con.prepareStatement(CashVanManagementStatements.GET_CURRENT_VAULT_RECORD.replace("#", cvsCustomerId));
		}else if(businessType.equals("Cash Delivery") && sealOrCash.contains("Cash")){
			pstmt = con.prepareStatement(CashVanManagementStatements.GET_CURRENT_VAULT_RECORD.replace("#", String.valueOf(onAccOf)));
		}
		pstmt.setInt(1, systemId);
		pstmt.setInt(2, clientId);
		rs = pstmt.executeQuery();
		while(rs.next()){
			if(denom5000 > rs.getInt("denom5000")){
				return message1;
			}
			if(denom2000 > rs.getInt("denom2000")){
				return message1;
			}
			if(denom1000 > rs.getInt("denom1000")){
				return message1;
			}
			if(denom500 > rs.getInt("denom500")){
				return message1;
			}
			if(denom100 > rs.getInt("denom100")){
				return message1;
			}
			if(denom50 > rs.getInt("denom50")){
				return message1;
			}
			if(denom20 > rs.getInt("denom20")){
				return message1;
			}
			if(denom10 > rs.getInt("denom10")){
				return message1;
			}
			if(denom5 > rs.getInt("denom5")){
				return message1;
			}
			if(denom2 > rs.getInt("denom2")){
				return message1;
			}
			if(denom1 > rs.getInt("denom1")){
				return message1;
			}
		}
		}
		if(businessType.equals("Cash Delivery")){
			if(!sealNo.equals("")){
				String sealNos[] = sealNo.split(",");
				String SealNo = "";
				for(String s:sealNos){
					SealNo = SealNo+","+"'"+s+"'";
				}
				pstmt = con.prepareStatement(CashVanManagementStatements.GET_TOTAL_AMOUNT.replace("#", SealNo.substring(1,SealNo.length())));
				pstmt.setInt(1, systemId);
				pstmt.setInt(2, clientId);
				pstmt.setInt(3, onAccOf);
				rs = pstmt.executeQuery();
				while(rs.next()){
					totalSealAmount = rs.getDouble("totalAmount");
				}
			}
			if(!chequeNo.equals("")){
				String chequeNos[] = chequeNo.split(",");
				String ChequeNo = "";
				for(String s:chequeNos){
					ChequeNo = ChequeNo+","+"'"+s+"'";
				}
				pstmt = con.prepareStatement(CashVanManagementStatements.GET_TOTAL_AMOUNT.replace("#", ChequeNo.substring(1,ChequeNo.length())));
				pstmt.setInt(1, systemId);
				pstmt.setInt(2, clientId);
				pstmt.setInt(3, onAccOf);
				rs = pstmt.executeQuery();
				while(rs.next()){
					totalChequeAmount = rs.getDouble("totalAmount");
				}
			}
			if(!jewelleryNo.equals("")){
				String jewelleryNos[] = jewelleryNo.split(",");
				String JewelleryNos = "";
				for(String s:jewelleryNos){
					JewelleryNos = JewelleryNos+","+"'"+s+"'";
				}
				pstmt = con.prepareStatement(CashVanManagementStatements.GET_TOTAL_AMOUNT.replace("#", JewelleryNos.substring(1,JewelleryNos.length())));
				pstmt.setInt(1, systemId);
				pstmt.setInt(2, clientId);
				pstmt.setInt(3, onAccOf);
				rs = pstmt.executeQuery();
				while(rs.next()){
					totalJewellearyAmount = rs.getDouble("totalAmount");
				}
			}
			if(!foreignCurrencyNo.equals("")){
				String foreignCurrencyNos[] = foreignCurrencyNo.split(",");
				String ForeignCurrencyNo = "";
				for(String s:foreignCurrencyNos){
					ForeignCurrencyNo = ForeignCurrencyNo+","+"'"+s+"'";
				}
				pstmt = con.prepareStatement(CashVanManagementStatements.GET_TOTAL_AMOUNT.replace("#", ForeignCurrencyNo.substring(1,ForeignCurrencyNo.length())));
				pstmt.setInt(1, systemId);
				pstmt.setInt(2, clientId);
				pstmt.setInt(3, onAccOf);
				rs = pstmt.executeQuery();
				while(rs.next()){
					totalForeignCurrencyAmount = rs.getDouble("totalAmount");
				}
			}
		}
		totalCashAmount = (denom5000 * 5000) + (denom2000 * 2000) + (denom1000 * 1000) + (denom500 * 500) + (denom100 * 100) + (denom50 * 50) + (denom20 * 20) + (denom10 * 10) + (denom5 * 5) + (denom2 * 2) + (denom1 * 1);
		pstmt = con.prepareStatement(CashVanManagementStatements.INSERT_CASH_DISPENSE2);
		pstmt.setInt(1, systemId);
		pstmt.setInt(2, clientId);
		pstmt.setInt(3, Integer.parseInt(businessId));
		pstmt.setString(4,tripSheetNo);
		pstmt.setString(5, businessType);
		pstmt.setInt(6, Integer.parseInt(cvsCustomerId));
		pstmt.setString(7, yyyymmdd.format(ddmmyy.parse(date)));
		pstmt.setInt(8, Integer.parseInt(routeId));
		pstmt.setInt(9, onAccOf);
		pstmt.setString(10, sealOrCash);
		pstmt.setString(11, sealNo);
		pstmt.setString(12, chequeNo);
		pstmt.setString(13, jewelleryNo);
		pstmt.setString(14, foreignCurrencyNo);
		pstmt.setInt(15, denom5000);
		pstmt.setInt(16, denom2000);
		pstmt.setInt(17, denom1000);
		pstmt.setInt(18, denom500);
		pstmt.setInt(19, denom100);
		pstmt.setInt(20, denom50);
		pstmt.setInt(21, denom20);
		pstmt.setInt(22, denom10);
		pstmt.setInt(23, denom5);
		pstmt.setInt(24, denom2);
		pstmt.setInt(25, denom1);
		pstmt.setDouble(26, totalSealAmount);
		pstmt.setDouble(27, totalCashAmount);
		pstmt.setDouble(28, totalChequeAmount);
		pstmt.setDouble(29, totalJewellearyAmount);
		pstmt.setDouble(30, totalForeignCurrencyAmount);
		pstmt.setDouble(31, totalCashAmount + totalSealAmount + totalChequeAmount + totalJewellearyAmount + totalForeignCurrencyAmount);
		pstmt.setString(32, "CREATED");
		pstmt.setString(33, "PENDING");
        pstmt.setInt(34, userId);
		//*** t4u506 start------------------------//
	//	pstmt.setInt(35, Integer.parseInt(DelivCustomerId));
		pstmt.setString(35,DelCustomerName );
		pstmt.setString(36, DelivCustomerId);
		//********** t4u506 end-------------------//
		inserted = pstmt.executeUpdate();
		if(inserted > 0){
			if(businessType.equals("ATM Replenishment")){
				pstmt = con.prepareStatement(CashVanManagementStatements.UPDATE_VAULT_TRANSIT_ON_DISPENSE);
				pstmt.setInt(1, denom5000);
				pstmt.setInt(2, denom2000);
				pstmt.setInt(3, denom1000);
				pstmt.setInt(4, denom500);
				pstmt.setInt(5, denom100);
				pstmt.setInt(6, denom50);
				pstmt.setInt(7, denom20);
				pstmt.setInt(8, denom10);
				pstmt.setInt(9, denom5);
				pstmt.setInt(10, denom2);
				pstmt.setInt(11, denom1);
				pstmt.setInt(12, systemId);
				pstmt.setInt(13, clientId);
				pstmt.setInt(14, Integer.parseInt(cvsCustomerId));
				pstmt.executeUpdate();
			}
			if(businessType.equals("Cash Delivery") && sealOrCash.contains("Cash")){
				pstmt = con.prepareStatement(CashVanManagementStatements.UPDATE_VAULT_TRANSIT_ON_DISPENSE);
				pstmt.setInt(1, denom5000);
				pstmt.setInt(2, denom2000);
				pstmt.setInt(3, denom1000);
				pstmt.setInt(4, denom500);
				pstmt.setInt(5, denom100);
				pstmt.setInt(6, denom50);
				pstmt.setInt(7, denom20);
				pstmt.setInt(8, denom10);
				pstmt.setInt(9, denom5);
				pstmt.setInt(10, denom2);
				pstmt.setInt(11, denom1);
				pstmt.setInt(12, systemId);
				pstmt.setInt(13, clientId);
				pstmt.setInt(14, onAccOf);
				pstmt.executeUpdate();
			}
			if(businessType.equals("Cash Delivery") && sealOrCash.contains("Sealed Bag")){
				String[]  sealNos = sealNo.split(",");
				String SealNo = "";
				for(String s:sealNos){
					SealNo = SealNo+","+"'"+s+"'";
				}
				pstmt = con.prepareStatement(CashVanManagementStatements.UPDATE_SEALBAG_STATUS_IN_VAULT_INWARD.replace("#", SealNo.substring(1, SealNo.length())));
				pstmt.setString(1, "DISPENSED");
				pstmt.setInt(2, systemId);
				pstmt.setInt(3, clientId);
				pstmt.setInt(4, onAccOf);
				pstmt.setString(5, "SEALED BAG");
				pstmt.executeUpdate();
			}
			if(businessType.equals("Cash Delivery") && sealOrCash.contains("Cheque")){
				String[]  chequeNos = chequeNo.split(",");
				String checkNumbers = "";
				for(String s:chequeNos){
					checkNumbers = checkNumbers+","+"'"+s+"'";
				}
				pstmt = con.prepareStatement(CashVanManagementStatements.UPDATE_SEALBAG_STATUS_IN_VAULT_INWARD.replace("#", checkNumbers.substring(1, checkNumbers.length())));
				pstmt.setString(1, "DISPENSED");
				pstmt.setInt(2, systemId);
				pstmt.setInt(3, clientId);
				pstmt.setInt(4, onAccOf);
				pstmt.setString(5, "CHEQUE");
				pstmt.executeUpdate();
			}
			if(businessType.equals("Cash Delivery") && sealOrCash.contains("Jewellery")){
				String[]  jewelleryNos = jewelleryNo.split(",");
				String jewelleryNumbers = "";
				for(String s:jewelleryNos){
					jewelleryNumbers = jewelleryNumbers+","+"'"+s+"'";
				}
				pstmt = con.prepareStatement(CashVanManagementStatements.UPDATE_SEALBAG_STATUS_IN_VAULT_INWARD.replace("#", jewelleryNumbers.substring(1, jewelleryNumbers.length())));
				pstmt.setString(1, "DISPENSED");
				pstmt.setInt(2, systemId);
				pstmt.setInt(3, clientId);
				pstmt.setInt(4, onAccOf);
				pstmt.setString(5, "JEWELLERY");
				pstmt.executeUpdate();
			}
			if(businessType.equals("Cash Delivery") && sealOrCash.contains("Foreign Currency")){
				String[]  forignNo = foreignCurrencyNo.split(",");
				String foreignNumbers = "";
				for(String s:forignNo){
					foreignNumbers = foreignNumbers+","+"'"+s+"'";
				}
				pstmt = con.prepareStatement(CashVanManagementStatements.UPDATE_SEALBAG_STATUS_IN_VAULT_INWARD.replace("#", foreignNumbers.substring(1, foreignNumbers.length())));
				pstmt.setString(1, "DISPENSED");
				pstmt.setInt(2, systemId);
				pstmt.setInt(3, clientId);
				pstmt.setInt(4, onAccOf);
				pstmt.setString(5, "FOREIGN CURRENCY");
				pstmt.executeUpdate();
			}
			message = "Success";
		}else{
			message = "Error while cash dipsensing...";
		}
	}catch(Exception e){
		e.printStackTrace();
	}finally{
		DBConnection.releaseConnectionToDB(con, pstmt, rs);
	}
	return message;
}
public JSONArray getUserAuthorityDetails(int customerid, int systemid, int offset)
{
	JSONArray jsonArray = new JSONArray();
	JSONObject jsonObject = new JSONObject();
	Connection con=null;
	PreparedStatement pstmt=null;
	ResultSet rs=null;
	String Createddate="";
	String Updateddate="";
	try 
	{
		con = DBConnection.getConnectionToDB("AMS");
		jsonArray = new JSONArray();
		jsonObject = new JSONObject();
		pstmt = con.prepareStatement(CashVanManagementStatements.GET_USER_AUTHORITY_DETAILS);
		pstmt.setInt(1, offset);
		pstmt.setInt(2, offset);
		pstmt.setString(3,"User_Authority");
		pstmt.setString(4,"User_Authority");
		pstmt.setString(5,"User_Authority");
		pstmt.setString(6,"User_Authority");
		pstmt.setString(7,"User_Authority");
		pstmt.setInt(8, systemid);
		pstmt.setInt(9, customerid);
		rs = pstmt.executeQuery();
        while (rs.next()) 
		{
        	    Createddate = rs.getString("CreatedDate");
		    	if(Createddate.contains("1900")){
		    		Createddate="";
		    	}
		    	
                Updateddate = rs.getString("UpdatedDate");
		    	if(Updateddate.contains("1900")){
		    		Updateddate="";
		    	}
		    	
		    jsonObject = new JSONObject();
			jsonObject.put("useridindex", rs.getString("UserId"));
			jsonObject.put("usernameindex", rs.getString("UserName"));
			jsonObject.put("ledgerindex", rs.getString("LEDGER_ENTRY_AUTHORITY"));
			jsonObject.put("cashviewindex", rs.getString("CASH_VIEW_AUTHORITY"));
			jsonObject.put("reconcileindex", rs.getString("RECONCILE_AUTHORITY"));
			jsonObject.put("reconcileHeadindex", rs.getString("RECONCILE_HEAD_AUTHORITY"));
			jsonObject.put("writeOffAuthorityIndex", rs.getString("WRITE_OFF_AUTHORITY"));
			jsonObject.put("creadtedbyindex", rs.getString("CreatedBy"));
			jsonObject.put("createddateindex", Createddate);
			jsonObject.put("updatedbyindex", rs.getString("UpdatedBy"));
			jsonObject.put("updateddateindex", Updateddate);
			jsonArray.put(jsonObject);
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

public JSONArray getUserDataDetails(int customerId,int systemId) {
    JSONArray JsonArray = null;
    JSONObject JsonObject = null;
    Connection con = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    try {
        JsonArray = new JSONArray();
        con = DBConnection.getConnectionToDB("AMS");
        pstmt = con.prepareStatement(CashVanManagementStatements.GET_USER_DATA_DETAILS);
        pstmt.setInt(1, systemId);
        rs = pstmt.executeQuery();
        while (rs.next()) {
            JsonObject = new JSONObject();
            JsonObject.put("DATA", rs.getString("DATA"));
            JsonObject.put("ID", rs.getInt("ID"));
            JsonArray.put(JsonObject);
        }
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        DBConnection.releaseConnectionToDB(con, pstmt, rs);
    }
    return JsonArray;
}
public String userModify(int UserId,String ledgerauthority,String cashview,String reconcile,int customerId,int systemId,int userId,String writeOff,String reconcileHead){
	Connection con = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	String message = "";
	int Ledger=2;
	int CashAuthority=2;
	int Reconcile=2;
	int WriteOff = 2;
	int ReconcileHead = 2;
	try {  
		con = DBConnection.getConnectionToDB("AMS");
		if(ledgerauthority.equals("Yes")||ledgerauthority.equals("1")){
			Ledger=1;
		}
		if(cashview.equals("Yes")||cashview.equals("1")){
		   	CashAuthority=1;
		}
		if(reconcile.equals("Yes")||reconcile.equals("1")){
		   	Reconcile=1;
		}
		if(writeOff.equals("Yes") || writeOff.equals("1")){
			WriteOff = 1;
		}
		if(reconcileHead.equals("Yes")||reconcileHead.equals("1")){
			ReconcileHead=1;
		}
		pstmt = con.prepareStatement(CashVanManagementStatements.USER_DATA_ALREADY_EXIST);
		pstmt.setInt(1, systemId);
		pstmt.setInt(2, customerId);
		pstmt.setInt(3, UserId);
		rs = pstmt.executeQuery();
		if(rs.next()){
			pstmt = con.prepareStatement(CashVanManagementStatements.MODIFY_USER_AUTHORITY_DETAILS);
			pstmt.setInt(1, Ledger);
			pstmt.setInt(2, CashAuthority);
			pstmt.setInt(3, Reconcile);
			pstmt.setInt(4, WriteOff);
			pstmt.setInt(5, ReconcileHead);
			pstmt.setInt(6, userId);
			pstmt.setInt(7, systemId);
			pstmt.setInt(8, customerId);
			pstmt.setInt(9, UserId);
			int inserted = pstmt.executeUpdate();
			if (inserted > 0) {
				message = "Record Updated Successfully";
	        }
		}else{
			pstmt = con.prepareStatement(CashVanManagementStatements.INSERT_NEW_USER_DETAILS);
			pstmt.setInt(1, Ledger);
			pstmt.setInt(2, CashAuthority);
			pstmt.setInt(3, Reconcile);
			pstmt.setInt(4, WriteOff);
			pstmt.setInt(5, ReconcileHead);
			pstmt.setInt(6, UserId);
			pstmt.setInt(7, userId);
			pstmt.setInt(8, systemId);
			pstmt.setInt(9, customerId);
			int inserted = pstmt.executeUpdate();
			if (inserted > 0) {
				message = "Record saved Successfully";
	        }	 
		}
	}catch (Exception e){
		e.printStackTrace();
	}      
	finally {
		DBConnection.releaseConnectionToDB(con, pstmt, rs);
	}
	return message;
}
public String insertJournalData(int systemId, int clientId, int dispUid, int denom5000, int denom2000, int denom1000, int denom500, int denom100) {
	String message = "";
	Connection con = null;
	PreparedStatement pstmt = null;
	int denomiation = 0;
	int denoValue = 0;
	int updated = 0;
	try{
		con = DBConnection.getConnectionToDB("AMS");
		for(int i = 0; i < 5; i++){
			if(i == 0){
				denomiation = 5000;
				denoValue = denom5000;
			}
			if(i == 1){
				denomiation = 2000;
				denoValue = denom2000;
			}
			if(i == 2){
				denomiation = 1000;
				denoValue = denom1000;
			}
			if(i == 3){
				denomiation = 500;
				denoValue = denom500;
			}
			if(i == 4){
				denomiation = 100;
				denoValue = denom100;
			}
			pstmt = con.prepareStatement(CashVanManagementStatements.INSERT_JOURNAL_DATA);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, clientId);
			pstmt.setInt(3, dispUid);
			pstmt.setInt(4, denomiation);
			pstmt.setInt(5, denoValue);
			pstmt.executeUpdate();
		}
		pstmt = con.prepareStatement(CashVanManagementStatements.UPDATE_SHORT_EXCESS_STATUS);
		pstmt.setString(1, "JOURNAL ENTERED");
		pstmt.setInt(2, systemId);
		pstmt.setInt(3, clientId);
		pstmt.setInt(4, dispUid);
		updated = pstmt.executeUpdate();
		if(updated > 0){
			message = "Journal data entered successfully";
		}else{
			message = "Error while inserting";
		}
	}catch(Exception e){
		e.printStackTrace();
	}finally{
		DBConnection.releaseConnectionToDB(con, pstmt, null);
	}
	return message;
}
public String insertPhysicalCashDetails(int systemId, int clientId,	int dispUid, int pgdenom5000, int pgdenom2000, int pgdenom1000,	int pgdenom500, int pgdenom100, int pbdenom5000, int pbdenom2000,
		int pbdenom1000, int pbdenom500, int pbdenom100, int rgdenom5000, int rgdenom2000, int rgdenom1000, int rgdenom500, int rgdenom100,	int rbdenom5000, int rbdenom2000, int rbdenom1000, int rbdenom500, int rbdenom100) {
	String message = "";
	Connection con = null;
	PreparedStatement pstmt = null;
	int denomiation = 0;
	int pgDenoValue = 0;
	int pbDenoValue = 0;
	int rgDenoValue = 0;
	int rbDenoValue = 0;
	int updated = 0;
	try{
		con = DBConnection.getConnectionToDB("AMS");
		for(int i = 0; i < 5; i++){
			if(i == 0){
				denomiation = 5000;
				pgDenoValue = pgdenom5000;
				pbDenoValue = pbdenom5000;
				rgDenoValue = rgdenom5000;
				rbDenoValue = rbdenom5000;
			}
			if(i == 1){
				denomiation = 2000;
				pgDenoValue = pgdenom2000;
				pbDenoValue = pbdenom2000;
				rgDenoValue = rgdenom2000;
				rbDenoValue = rbdenom2000;
			}
			if(i == 2){
				denomiation = 1000;
				pgDenoValue = pgdenom1000;
				pbDenoValue = pbdenom1000;
				rgDenoValue = rgdenom1000;
				rbDenoValue = rbdenom1000;
			}
			if(i == 3){
				denomiation = 500;
				pgDenoValue = pgdenom500;
				pbDenoValue = pbdenom500;
				rgDenoValue = rgdenom500;
				rbDenoValue = rbdenom500;
			}
			if(i == 4){
				denomiation = 100;
				pgDenoValue = pgdenom100;
				pbDenoValue = pbdenom100;
				rgDenoValue = rgdenom100;
				rbDenoValue = rbdenom100;
			}
			pstmt = con.prepareStatement(CashVanManagementStatements.UPDATE_PHYSICAL_CASH_DETAILS);
			pstmt.setInt(1, pgDenoValue);
			pstmt.setInt(2, pbDenoValue);
			pstmt.setInt(3, rgDenoValue);
			pstmt.setInt(4, rbDenoValue);
			pstmt.setInt(5, systemId);
			pstmt.setInt(6, clientId);
			pstmt.setInt(7, dispUid);
			pstmt.setInt(8, denomiation);
			pstmt.executeUpdate();
		}
		pstmt = con.prepareStatement(CashVanManagementStatements.UPDATE_SHORT_EXCESS_STATUS);
		pstmt.setString(1, "CASH ENTERED");
		pstmt.setInt(2, systemId);
		pstmt.setInt(3, clientId);
		pstmt.setInt(4, dispUid);
		updated = pstmt.executeUpdate();
		if(updated > 0){
			message = "Physical cash data entered successfully";
		}else{
			message = "Error while inserting";
		}
	}catch(Exception e){
		e.printStackTrace();
	}finally{
		DBConnection.releaseConnectionToDB(con, pstmt, null);
	}
	return message;
}
public JSONArray getDenominationGrid(int systemId, int clientId, String cvsbusinessId, int dispUID, int businessId,String btnValue) {
	Connection con = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	JSONObject obj = null;
	JSONArray jArr = new JSONArray();
	int denom5000 = 0;
	int denom2000 = 0;
	int denom1000 = 0;
	int denom500 = 0;
	int denom100 = 0;
	try{
		con = DBConnection.getConnectionToDB("AMS");
	/*	if(btnValue.equals("replinshMent")){
			pstmt = con.prepareStatement(CashVanManagementStatements.GET_PREV_DENOMINATION_DETAILS_FOR_ATM_REP);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, clientId);
			pstmt.setString(3, cvsbusinessId);
			pstmt.setInt(4, systemId);
			pstmt.setInt(5, clientId);
			pstmt.setInt(6, dispUID);
			pstmt.setInt(7, businessId);
			rs = pstmt.executeQuery();
			while(rs.next()){
					denom5000 = rs.getInt("denom5000");
					denom2000 = rs.getInt("denom2000");
					denom1000 = rs.getInt("denom1000");
					denom500 = rs.getInt("denom500");
					denom100 = rs.getInt("denom100");
			}
			pstmt.close();
			rs.close();
		} */
		pstmt = con.prepareStatement(CashVanManagementStatements.GET_SUSPENSE_RECORD_DETAILS);
		pstmt.setInt(1, systemId);
		pstmt.setInt(2, clientId);
		pstmt.setInt(3, dispUID);
		rs = pstmt.executeQuery();
		while(rs.next()){
			obj = new JSONObject();
			obj.put("DenominationDataIndex", rs.getInt("denomination"));
			obj.put("gernalDI", rs.getInt("journal"));
			obj.put("gernalValueDI", (rs.getInt("journal") * rs.getInt("denomination")));
			obj.put("goodCashPysicalDI", rs.getInt("physicalGood"));
			obj.put("goodCashPhysicalValueDI", rs.getInt("physicalGood") * rs.getInt("denomination"));
			obj.put("badPhysicalCashDI", rs.getInt("physicalBad"));
			obj.put("badPhysicalCashValueDI", rs.getInt("physicalBad") * rs.getInt("denomination"));
			obj.put("goodRejectedCashDI", rs.getInt("rejectedGood"));
			obj.put("goodRejectedCashValueDI", rs.getInt("rejectedGood") * rs.getInt("denomination"));
			obj.put("badRejectedDI", rs.getInt("rejectedBad"));
			obj.put("badRejectedValueDI", rs.getInt("rejectedBad") * rs.getInt("denomination"));
		/*	if(btnValue.equals("replinshMent")){
				int currSum = rs.getInt("journal") + rs.getInt("physicalGood") + rs.getInt("physicalBad") + rs.getInt("rejectedGood") + rs.getInt("rejectedBad");
				if(rs.getInt("denomination") == 5000){
					if( currSum > denom5000){
						obj.put("shortDI", 0);
						obj.put("excessDI", currSum - denom5000);
					}else if(currSum < denom5000){
						obj.put("shortDI", denom5000 - denom5000);
						obj.put("excessDI", 0);
					}else{
						obj.put("shortDI", 0);
						obj.put("excessDI", 0);
					}
				}
				if(rs.getInt("denomination") == 2000){
					if( currSum > denom2000){
						obj.put("shortDI", 0);
						obj.put("excessDI", currSum - denom2000);
					}else if(currSum < denom2000){
						obj.put("shortDI", denom2000 - currSum);
						obj.put("excessDI", 0);
					}else{
						obj.put("shortDI", 0);
						obj.put("excessDI", 0);
					}
				}
				if(rs.getInt("denomination") == 1000){
					if( currSum > denom1000){
						obj.put("shortDI", 0);
						obj.put("excessDI", currSum - denom1000);
					}else if(currSum < denom1000){
						obj.put("shortDI", denom1000 - currSum);
						obj.put("excessDI", 0);
					}else{
						obj.put("shortDI", 0);
						obj.put("excessDI", 0);
					}
				}
				if(rs.getInt("denomination") == 500){
					if( currSum > denom500){
						obj.put("shortDI", 0);
						obj.put("excessDI", currSum - denom500);
					}else if(currSum < denom500){
						obj.put("shortDI", denom500 - currSum);
						obj.put("excessDI", 0);
					}else{
						obj.put("shortDI", 0);
						obj.put("excessDI", 0);
					}
				}
				if(rs.getInt("denomination") == 100){
					if( currSum > denom100){
						obj.put("shortDI", 0);
						obj.put("excessDI", currSum - denom100);
					}else if(currSum < denom100){
						obj.put("shortDI", denom100 - currSum);
						obj.put("excessDI", 0);
					}else{
						obj.put("shortDI", denom5000 - denom5000);
						obj.put("excessDI", 0);
					}
				}
			}else{ */
				int currSum = rs.getInt("physicalGood") + rs.getInt("physicalBad") + rs.getInt("rejectedGood") + rs.getInt("rejectedBad");
				if(rs.getInt("journal") > currSum){
					obj.put("shortDI", rs.getInt("journal") - currSum);
					obj.put("excessDI", 0);
				}else if(rs.getInt("journal") < currSum){
					obj.put("shortDI", 0);
					obj.put("excessDI", currSum - rs.getInt("journal"));
				}else{
					obj.put("shortDI", 0);
					obj.put("excessDI", 0);
				}
		//	}
				jArr.put(obj);
		}
	}catch(Exception e){
		e.printStackTrace();
	}finally{
		DBConnection.releaseConnectionToDB(con, pstmt, rs);
	}
	return jArr;
}
/*Vin Logic : Booking Edit Authority as Physical Cash Authority
 * 			  Invoice Cancel Authority as Ledger Entry Authority
 * 			  Billing Authority as Reconcile Authority
 * 			  Revenue Authority as Close/Write Off authority
 * 			  Booking Cancel Authority as Reconcile Head Authority	 */
public String getUserAuthority(int SystemId, int userId,int clientId, int authType) {
	Connection con = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	String userAuthority = "";
	try {
		con = DBConnection.getConnectionToDB("AMS");
		pstmt = con.prepareStatement(CashVanManagementStatements.GET_USER_AUTHORITY);
		pstmt.setInt(1, SystemId);
		pstmt.setInt(2, clientId);
		pstmt.setInt(3, userId);
		rs = pstmt.executeQuery();
		if (rs.next()) {
			switch(authType){
			case 1 : userAuthority = rs.getString("PROFIT_LOSS_AUTHORITY");
				break;
			case 2 : userAuthority = rs.getString("BOOKING_CANCELLATION_AUTHORITY");
				break;
			case 3 : userAuthority = rs.getString("REVENUE_AUTHORITY");
				break;
			case 4 : userAuthority = rs.getString("INVOICE_CANCEL_AUTHORITY");
				break;
			case 5 : userAuthority = rs.getString("BOOKING_EDIT_AUTHORITY");
				break;
			case 6 : userAuthority = rs.getString("BILLING_AUTHORITY");
				break;
			default: System.out.println("no match with data");
				break;
			}
		}
	} catch (Exception e) {
		e.printStackTrace();
	} finally {
		DBConnection.releaseConnectionToDB(con, pstmt, rs);
	}
	return userAuthority;
}

public String saveRouteDetails(String[] routeArray,String routeName,String startLocation,String endLocation,int systemId,int customerId,int userId) {
	String message = "";
	Connection con = null;
	PreparedStatement pstmt = null;
	ResultSet rs=null;
	int uniqueId=0;
	try {
		con = DBConnection.getConnectionToDB("AMS");
		pstmt = con.prepareStatement(CashVanManagementStatements.SAVE_NTC_ROUTE_DETAILS,PreparedStatement.RETURN_GENERATED_KEYS);
		pstmt.setString(1,routeName);
		pstmt.setString(2,startLocation);
		pstmt.setString(3,endLocation);
		pstmt.setInt(4,systemId);
		pstmt.setInt(5,customerId);
		pstmt.setInt(6,userId);
		int inserted=pstmt.executeUpdate();	
		rs=pstmt.getGeneratedKeys();
		if(rs.next()){
			uniqueId=rs.getInt(1);
		}
		if(inserted>0){
			for(String routes:routeArray)
			{
				routes=routes.substring(1,routes.length()-2);
				String[] routesdetails = routes.split(",");	
				pstmt = con.prepareStatement(CashVanManagementStatements.SAVE_ROUTE_DETAILS);
				pstmt.setInt(1,uniqueId);
				pstmt.setString(2,routesdetails[0]);
				pstmt.setString(3,routesdetails[1]);
				pstmt.setString(4,routesdetails[2]);
				int ins=pstmt.executeUpdate();	
				if(ins>0){
					message="saved successfully";
				}else{
					message="Error while saving";
				}
			}
		}
		System.out.println(message);
	} catch (Exception e) {
		e.printStackTrace();
	}
	
	return message;
}
public JSONArray getRouteNames1(int SystemId,int customerId){
	JSONArray jsonArray = new JSONArray();
	JSONObject jsonObject = new JSONObject();
	Connection con=null;
	PreparedStatement pstmt=null;
	ResultSet rs=null;
	try{
		jsonArray = new JSONArray();
		jsonObject = new JSONObject();
		
		con=DBConnection.getConnectionToDB("AMS");
		pstmt=con.prepareStatement(CashVanManagementStatements.GET_ROUTE_NAME);
		pstmt.setInt(1, SystemId);
		//pstmt.setInt(2, customerId);
		rs=pstmt.executeQuery();
		while(rs.next()){
			jsonObject = new JSONObject();
			jsonObject.put("routeId", rs.getString("RouteID"));
			jsonObject.put("routeName", rs.getString("RouteName"));
			jsonArray.put(jsonObject);				
		}
	}catch(Exception e){
		System.out.println("Error in getCustomer "+e.toString());
	}	
	finally{
		DBConnection.releaseConnectionToDB(con, pstmt, rs);
	}	
	return jsonArray;
}
public JSONArray getLatLongs(int routeId,int cutomerId, int systemId) {

	JSONArray jsonArray = new JSONArray();
	JSONObject jsonObject = new JSONObject();
	Connection con=null;
	PreparedStatement pstmt=null;
	ResultSet rs=null;
	try{
		con = DBConnection.getConnectionToDB("AMS");
		jsonArray = new JSONArray();
		jsonObject = new JSONObject();
		pstmt = con.prepareStatement(CashVanManagementStatements.GET_ROUTE_LATLNG);
		pstmt.setInt(1,routeId);
		rs=pstmt.executeQuery();
		int count=0;
		while(rs.next()){
			count++;
			jsonObject = new JSONObject();
			jsonObject.put("sequence", rs.getString("Route_sequence"));
			jsonObject.put("lat", rs.getString("Latitude"));
			jsonObject.put("lng", rs.getString("Longitude"));
			jsonArray.put(jsonObject);	
		}
	}catch(Exception e){
		e.printStackTrace();
	}	
	finally{
		DBConnection.releaseConnectionToDB(con, pstmt, rs);
	}	
	return jsonArray;

}
public JSONArray getLatLongForMarker(int routeId,int cutomerId, int systemId,String zone) {

	JSONArray jsonArray = new JSONArray();
	JSONObject jsonObject = new JSONObject();
	Connection con=null;
	PreparedStatement pstmt=null;
	ResultSet rs=null;
	int count=0;
	try{
		con = DBConnection.getConnectionToDB("AMS");
		jsonArray = new JSONArray();
		jsonObject = new JSONObject();
		pstmt = con.prepareStatement(CashVanManagementStatements.GET_MARKER_LATLNG);
		pstmt.setInt(1,routeId);
		rs=pstmt.executeQuery();
		while(rs.next()){
			count++;
			jsonObject = new JSONObject();
			jsonObject.put("hubName", rs.getString("NAME"));
			jsonObject.put("remarks", rs.getString("REMARKS"));
			jsonObject.put("alertType", rs.getString("ALERT_TYPE"));
			jsonObject.put("alertRadius", rs.getString("ALERT_RADIUS"));
			jsonObject.put("hubRadius", rs.getString("RADIUS"));
			jsonObject.put("lat", rs.getString("LATITUDE"));
			jsonObject.put("lng", rs.getString("LONGITUDE"));
			jsonObject.put("id", count);
			jsonArray.put(jsonObject);	
		}
	}catch(Exception e){
		e.printStackTrace();
	}	
	finally{
		DBConnection.releaseConnectionToDB(con, pstmt, rs);
	}	
	return jsonArray;

}

public String saveInfoWindowDetails(String hubName,String remarks,String alertType,String alertRad,int customerId, int systemId,int userId,
		String routeId,String latitude,String longitude,String hubRad) {
	String message = "";
	Connection con = null;
	PreparedStatement pstmt = null;
	try {
		con = DBConnection.getConnectionToDB("AMS");
		pstmt = con.prepareStatement(CashVanManagementStatements.SAVE_INFO_DETAILS);
		pstmt.setString(1,routeId);
		pstmt.setString(2,hubName);
		pstmt.setString(3,remarks);
		pstmt.setString(4,alertType);
		pstmt.setString(5,alertRad);
		pstmt.setString(6,hubRad);
		pstmt.setString(7,latitude);
		pstmt.setString(8,longitude);

		int inserted=pstmt.executeUpdate();	
		if(inserted>0){
			message="saved successfully";
		}else{
			message="Error while saving";
		}
		System.out.println(message);
	} catch (Exception e) {
		e.printStackTrace();
	}
	
	return message;
}
public JSONArray getVehicleCountInHub(int clientId, int systemId, int userId) {
	JSONArray jsonArray = new JSONArray();
	JSONObject jsonObject = new JSONObject();
	Connection con=null;
	PreparedStatement pstmt=null;
	ResultSet rs=null;
	int hubId = 135504; // (Jotun HQ) hard coded as per Customer Requirement. 
	int outsideHub = 0;
	int insideHub= 0;
	try{
		con = DBConnection.getConnectionToDB("AMS");
		jsonArray = new JSONArray();
		jsonObject = new JSONObject();
		pstmt = con.prepareStatement(CashVanManagementStatements.GET_VEHICLE_COUNT_IN_HUB);
		pstmt.setInt(1,userId);
		pstmt.setInt(2,systemId);
		pstmt.setInt(3,clientId);
		pstmt.setInt(4,hubId);
		pstmt.setInt(5,userId);
		pstmt.setInt(6,systemId);
		pstmt.setInt(7,clientId);
		pstmt.setInt(8,hubId);
 		rs = pstmt.executeQuery();
		while(rs.next()){
			jsonObject = new JSONObject();
			if(rs.getRow() == 1){
				insideHub = rs.getInt("vehCount");
				jsonObject.put("insideHub", insideHub);
			}else{
				outsideHub = rs.getInt("vehCount");
				jsonObject.put("outsideHub", outsideHub);
			}
			jsonArray.put(jsonObject);	
		}
	}catch(Exception e){
		e.printStackTrace();
	}finally{
		DBConnection.releaseConnectionToDB(con, pstmt, rs);
	}	
	return jsonArray;

}
public ArrayList < Object > getAtmReplenishmentReport(int customerId, int systemId,int offset,String startdate,String enddate,int crewId,String vehicleNo,int atmNo) {
    Connection con = null;
    PreparedStatement pstmt = null ;
    ResultSet rs = null;
    JSONArray jsonArray = new JSONArray();
    JSONObject jsonObject = null;
    ArrayList < Object > finlist = new ArrayList < Object > ();
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
    ArrayList<ReportHelper> reportsList = new ArrayList<ReportHelper>();
	ArrayList<String> headersList = new ArrayList<String>();
	ReportHelper finalreporthelper = new ReportHelper();
    try {
    	headersList.add("SLNO");
    	headersList.add("Atm Details");
    	headersList.add("Date");
    	headersList.add("Vehicle_No");
    	headersList.add("Driver_Name");
    	headersList.add("Custodian Name 1");
    	headersList.add("Custodian_Name 2");
    	headersList.add("Trip Number");
    	headersList.add("Number of POI's");
    	headersList.add("Business Name");
		headersList.add("Location");
		headersList.add("Total");
		
        int count = 0;
        con = DBConnection.getConnectionToDB("AMS");
      
      StringBuffer strAppend = new StringBuffer();
      
      if(crewId !=0){
      	strAppend.append("and ( d.Driver_id="+crewId +" or c1.Driver_id="+crewId +" or c1.Driver_id="+crewId+")");
      }
      if(atmNo != 0){
      	strAppend.append("and a.BUSINESS_ID="+atmNo);
      }
      if(!vehicleNo.equals("")){
      	strAppend.append("and tp.ASSET_NUMBER='"+vehicleNo +"'");
      }
      if(crewId == 0 && atmNo == 0 && vehicleNo.equals("")){
      	strAppend.append("");
      }
      
      pstmt = con.prepareStatement(CashVanManagementStatements.GET_ATM_REPLENISHMENT_DETAILS.replace("#",strAppend));
      
        
        pstmt.setInt(1, systemId);
        pstmt.setInt(2, customerId);
        pstmt.setInt(3, offset);
        pstmt.setString(4, startdate);
        pstmt.setInt(5, offset);
        pstmt.setString(6, enddate);
        rs = pstmt.executeQuery();
        while (rs.next()) {
        	ArrayList<Object> informationList = new ArrayList<Object>();
        	ReportHelper reporthelper = new ReportHelper();
            count++;
            jsonObject = new JSONObject();
            
            informationList.add(count);
            jsonObject.put("slnoIndex", count);
            
            informationList.add(rs.getString("BUSINESS_ID"));
            jsonObject.put("AtmDetailsDataIndex", rs.getString("BUSINESS_ID"));
            
            if(rs.getString("AtmRepDate")==""|| rs.getString("AtmRepDate").contains("1900"))
			{
            	informationList.add("");
            	jsonObject.put("DateDataIndex", "");
			}
			else
			{	
				informationList.add(ddmmyyyy.format(yyyymmdd.parse(rs.getString("AtmRepDate"))));
				jsonObject.put("DateDataIndex", sdf.format(rs.getTimestamp("AtmRepDate")));
			}
            
            informationList.add(rs.getString("VehicleNo"));
            jsonObject.put("vehicleNoDataIndex", rs.getString("VehicleNo"));
            
            informationList.add(rs.getString("DriverName"));
            jsonObject.put("driverDataIndex", rs.getString("DriverName"));
            
            informationList.add(rs.getString("CustodianName1"));
            jsonObject.put("custodian1DataIndex",rs.getString("CustodianName1"));
            
            informationList.add(rs.getString("CustodianName2"));
            jsonObject.put("custodian2DataIndex",rs.getString("CustodianName2"));
            
            informationList.add(rs.getString("TripNo"));
            jsonObject.put("tripNoDataIndex", rs.getString("TripNo"));
            
            informationList.add(count);
            jsonObject.put("numberOfPoiDataIndex", count);
            
            informationList.add(rs.getString("BusinessName") +"-"+ rs.getString("Location"));
            jsonObject.put("businessNameDataIndex", rs.getString("BusinessName") +"-"+ rs.getString("Location"));
            
            informationList.add(rs.getString("Location"));
            jsonObject.put("locationDataIndex", rs.getString("Location"));
            
            informationList.add(rs.getString("TOTAL_CASH_AMOUNT"));
            jsonObject.put("totalDataIndex", rs.getString("TOTAL_CASH_AMOUNT"));
            
            jsonArray.put(jsonObject);
            reporthelper.setInformationList(informationList);
			reportsList.add(reporthelper);
            
        }
        finalreporthelper.setReportsList(reportsList);
		finalreporthelper.setHeadersList(headersList);
	    finlist.add(jsonArray);
		finlist.add(finalreporthelper);
     
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        DBConnection.releaseConnectionToDB(con, pstmt, rs);
    }
    return finlist;
}
public ArrayList < Object > getTripOperationReportDetails(int customerId, int systemId,int offset,String startdate,String enddate,int crewId,int tripId,int routeId,String vehicleNo) {
    Connection con = null;
    PreparedStatement pstmt = null ;
    ResultSet rs = null;
    JSONArray jsonArray = new JSONArray();
    JSONObject jsonObject = null;
    ArrayList < Object > finlist = new ArrayList < Object > ();
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
    ArrayList<ReportHelper> reportsList = new ArrayList<ReportHelper>();
	ArrayList<String> headersList = new ArrayList<String>();
	ReportHelper finalreporthelper = new ReportHelper();
    int time=0;
    String totalHours=null;
    double totalOdo;
    String custodianName=null;
    String gunMan=null;
    try {
    	headersList.add("SLNO");
    	headersList.add("Trip Id");
    	headersList.add("Route Name");
    	headersList.add("Vehicle No");
    	headersList.add("Driver Name");
    	headersList.add("GunMan 1");
    	headersList.add("GunMan 2");
    	headersList.add("Trip Start Date Time");
    	headersList.add("Trip Closed Date Time");
    	headersList.add("Custodian Name 1");
    	headersList.add("Opening Odometer");
    	headersList.add("Distance Travelled");
    	
        int count = 0;
        con = DBConnection.getConnectionToDB("AMS");
  
        StringBuffer strAppend = new StringBuffer();
        
        if(crewId !=0){
        	strAppend.append("and (  d.Driver_id="+crewId +" or c1.Driver_id="+crewId +" or g1.Driver_id="+crewId +" or g2.Driver_id="+crewId+")");
        }
        if(routeId != 0){
        	strAppend.append("and a.ROUTE_ID ="+routeId);
        }
        if(tripId != 0){
        	strAppend.append("and a.TRIP_ID="+tripId);
        }
        if(!vehicleNo.equals("")){
        	strAppend.append("and a.ASSET_NUMBER='"+vehicleNo +"'");
        }
        if(routeId == 0 && tripId == 0 && vehicleNo.equals("")){
        	strAppend.append("");
        }
        
        pstmt = con.prepareStatement(CashVanManagementStatements.GET_TRIP_OPERATION_DETAILS.replace("#",strAppend));
        
        pstmt.setInt(1, offset);
        pstmt.setInt(2, offset);
        pstmt.setInt(3, systemId);
        pstmt.setInt(4, customerId);
        pstmt.setInt(5, offset);
        pstmt.setString(6, startdate);
        pstmt.setInt(7, offset);
        pstmt.setString(8, enddate);
        rs = pstmt.executeQuery();
        while (rs.next()) {
        	ArrayList<Object> informationList = new ArrayList<Object>();
        	ReportHelper reporthelper = new ReportHelper();
            count++;
            jsonObject = new JSONObject();
            
            informationList.add(count);
            jsonObject.put("slnoIndex", count);
            
            informationList.add(rs.getString("TripNo"));
            jsonObject.put("TripIdDataIndex", rs.getString("TripNo"));
            
            informationList.add(rs.getString("RouteName"));
            jsonObject.put("routeDataIndex", rs.getString("RouteName"));
            
            informationList.add(rs.getString("ASSET_NUMBER"));
            jsonObject.put("vehicleNoDataIndex", rs.getString("ASSET_NUMBER"));
            
            informationList.add(rs.getString("DriverName"));
            jsonObject.put("driverDataIndex", rs.getString("DriverName"));
            
            informationList.add(rs.getString("GunMan1"));
            jsonObject.put("gunMan1DataIndex",rs.getString("GunMan1"));
            
            informationList.add(rs.getString("GunMan2"));
            jsonObject.put("gunMan2DataIndex",rs.getString("GunMan2"));
            
            if(rs.getString("TripStartDate")==""|| rs.getString("TripStartDate").contains("1900"))
			{
            	informationList.add("");
            	jsonObject.put("startDateDataIndex", "");
			}
			else
			{	
				informationList.add(ddmmyyyy.format(yyyymmdd.parse(rs.getString("TripStartDate"))));
				jsonObject.put("startDateDataIndex", sdf.format(rs.getTimestamp("TripStartDate")));
			}
            
            if(rs.getString("TripClosedDate")==""|| rs.getString("TripClosedDate").contains("1900"))
			{
            	informationList.add("");
            	jsonObject.put("endDateDataIndex", "");
			}
			else
			{	
				informationList.add(ddmmyyyy.format(yyyymmdd.parse(rs.getString("TripClosedDate"))));
				jsonObject.put("endDateDataIndex", sdf.format(rs.getTimestamp("TripClosedDate")));
			}
            
            informationList.add(rs.getString("CustodianName1"));
            jsonObject.put("custodian1DataIndex",rs.getString("CustodianName1"));
            
            informationList.add(rs.getString("OpeningOdometer"));
            jsonObject.put("openingOdometerDataIndex", rs.getString("OpeningOdometer"));
            
            informationList.add(rs.getString("DistanceTravelled"));
            jsonObject.put("distanceTravelledDataIndex", rs.getString("DistanceTravelled"));
            
            jsonArray.put(jsonObject);
            reporthelper.setInformationList(informationList);
			reportsList.add(reporthelper);
            
        }
        finalreporthelper.setReportsList(reportsList);
		finalreporthelper.setHeadersList(headersList);
	    finlist.add(jsonArray);
		finlist.add(finalreporthelper);
     
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        DBConnection.releaseConnectionToDB(con, pstmt, rs);
    }
    return finlist;
}
public ArrayList < Object > getQuotationReportDetails(int customerId, int systemId,int offset,String startdate,String enddate,int quotId,String quotStatus,String cvsCustName) {
    Connection con = null;
    PreparedStatement pstmt = null ;
    ResultSet rs = null;
    JSONArray jsonArray = new JSONArray();
    JSONObject jsonObject = null;
    ArrayList < Object > finlist = new ArrayList < Object > ();
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
    ArrayList<ReportHelper> reportsList = new ArrayList<ReportHelper>();
	ArrayList<String> headersList = new ArrayList<String>();
	ReportHelper finalreporthelper = new ReportHelper();
    int time=0;
    String totalHours=null;
    double totalOdo;
    String custodianName=null;
    String gunMan=null;
    try {
    	headersList.add("SLNO");
    	headersList.add("Quotation Number");
    	headersList.add("Valid From");
    	headersList.add("Valid To");
    	headersList.add("Location");
    	headersList.add("Quote For");
    	headersList.add("Customer Name");
    	headersList.add("Tariff Type");
    	headersList.add("Tariff Amount");
    	headersList.add("Quotation Status");
    	headersList.add("Approved/Rejected By");
    	headersList.add("Reason");
    	
        int count = 0;
        con = DBConnection.getConnectionToDB("AMS");
        
        StringBuffer strAppend = new StringBuffer();
        
        if(quotId !=0){
        	strAppend.append("and QUOTATION_ID ="+quotId );
        }
        if(!cvsCustName.equals("")){
        	strAppend.append("and CUSTOMER_NAME='"+cvsCustName +"'");
        }
        if(!quotStatus.equals("")){
        	strAppend.append("and QUOTATION_STATUS='"+quotStatus +"'");
        }
        if(quotId == 0 && cvsCustName.equals("") && quotStatus.equals("")){
        	strAppend.append("");
        }
        
        pstmt = con.prepareStatement(CashVanManagementStatements.GET_QUOTATION_DETAILS.replace("#",strAppend));
        
        pstmt.setInt(1, systemId);
        pstmt.setInt(2, customerId);
        pstmt.setInt(3, offset);
        pstmt.setString(4, startdate);
        pstmt.setInt(5, offset);
        pstmt.setString(6, enddate); 
        rs = pstmt.executeQuery();
        while (rs.next()) {
        	ArrayList<Object> informationList = new ArrayList<Object>();
        	ReportHelper reporthelper = new ReportHelper();
            count++;
            jsonObject = new JSONObject();
            
            informationList.add(count);
            jsonObject.put("slnoIndex", count);
            
            informationList.add(rs.getString("QUOTATION_NO"));
            jsonObject.put("quotationNoDataIndex", rs.getString("QUOTATION_NO"));
            
            if(rs.getString("VALID_FROM")==""|| rs.getString("VALID_FROM").contains("1900"))
			{
            	informationList.add("");
            	jsonObject.put("validFromDataIndex", "");
			}
			else
			{	
				informationList.add(ddmmyyyy.format(yyyymmdd.parse(rs.getString("VALID_FROM"))));
				jsonObject.put("validFromDataIndex", sdf.format(rs.getTimestamp("VALID_FROM")));
			}
            
            if(rs.getString("VALID_TO")==""|| rs.getString("VALID_TO").contains("1900"))
			{
            	informationList.add("");
            	jsonObject.put("validToDataIndex", "");
			}
			else
			{	
				informationList.add(ddmmyyyy.format(yyyymmdd.parse(rs.getString("VALID_TO"))));
				jsonObject.put("validToDataIndex", sdf.format(rs.getTimestamp("VALID_TO")));
			}
            
            informationList.add(rs.getString("LOCATION"));
            jsonObject.put("locationDataIndex", rs.getString("LOCATION"));
            
            informationList.add(rs.getString("QUOTE_FOR"));
            jsonObject.put("quoteForDataIndex", rs.getString("QUOTE_FOR"));
            
            informationList.add(rs.getString("CUSTOMER_NAME"));
            jsonObject.put("customerNameDataIndex", rs.getString("CUSTOMER_NAME"));
            
            informationList.add(rs.getString("TARIFF_TYPE"));
            jsonObject.put("tariffTypeDataIndex",rs.getString("TARIFF_TYPE"));
            
            informationList.add(rs.getString("TARIFF_AMOUNT"));
            jsonObject.put("tariffAmountDataIndex",rs.getString("TARIFF_AMOUNT"));
           
            informationList.add(rs.getString("QUOTATION_STATUS"));
            jsonObject.put("quotationStatusDataIndex",rs.getString("QUOTATION_STATUS"));
            
            informationList.add(rs.getString("APPROVED_OR_REJECTED_BY"));
            jsonObject.put("approvedOrRejectDataIndex", rs.getString("APPROVED_OR_REJECTED_BY"));
            
            informationList.add(rs.getString("REASON"));
            jsonObject.put("reasonDataIndex", rs.getString("REASON"));
            
            jsonArray.put(jsonObject);
            reporthelper.setInformationList(informationList);
			reportsList.add(reporthelper);
            
        }  
         
        finalreporthelper.setReportsList(reportsList);
		finalreporthelper.setHeadersList(headersList);
	    finlist.add(jsonArray);
		finlist.add(finalreporthelper);
     
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        DBConnection.releaseConnectionToDB(con, pstmt, rs);
    }
    return finlist;
}
public ArrayList < Object > getArmoryOperationReportDetails(int customerId, int systemId,int offset,String startdate,String enddate,int crewId,int tripId,String vehicleNo) {
    Connection con = null;
    PreparedStatement pstmt = null ;
    ResultSet rs = null;
    JSONArray jsonArray = new JSONArray();
    JSONObject jsonObject = null;
    ArrayList < Object > finlist = new ArrayList < Object > ();
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
    ArrayList<ReportHelper> reportsList = new ArrayList<ReportHelper>();
	ArrayList<String> headersList = new ArrayList<String>();
	ReportHelper finalreporthelper = new ReportHelper();
    try {
    	headersList.add("SLNO");
    	headersList.add("Date");
    	headersList.add("Vehicle Number");
    	headersList.add("Driver Name");
    	headersList.add("Custodian Name");
    	headersList.add("Trip Id");
    	headersList.add("Route Name");
    	headersList.add("Asset Name");
    	
        int count = 0;
        con = DBConnection.getConnectionToDB("AMS");
        
        StringBuffer strAppend = new StringBuffer();
        
        if(crewId !=0){
        	strAppend.append("and ( d.Driver_id="+crewId +" or c1.Driver_id="+crewId+")");
        }
        if(tripId != 0){
        	strAppend.append("and a.TRIP_NO="+tripId);
        }
        if(!vehicleNo.equals("")){
        	strAppend.append("and b.ASSET_NUMBER='"+vehicleNo +"'");
        }
        if(crewId == 0 && tripId == 0 && vehicleNo.equals("")){
        	strAppend.append("");
        }
        
        pstmt = con.prepareStatement(CashVanManagementStatements.GET_ARMORY_OPERATION_DETAILS.replace("#",strAppend));
        
        pstmt.setInt(1, systemId);
        pstmt.setInt(2, customerId);
        pstmt.setInt(3, offset);
        pstmt.setString(4, startdate);
        pstmt.setInt(5, offset);
        pstmt.setString(6, enddate); 
        rs = pstmt.executeQuery();
        while (rs.next()) {
        	ArrayList<Object> informationList = new ArrayList<Object>();
        	ReportHelper reporthelper = new ReportHelper();
            count++;
            jsonObject = new JSONObject();
            
            informationList.add(count);
            jsonObject.put("slnoIndex", count);
            
            if(rs.getString("CreatedDate")==""|| rs.getString("CreatedDate").contains("1900"))
			{
            	informationList.add("");
            	jsonObject.put("DateDataIndex", "");
			}
			else
			{	
				informationList.add(ddmmyyyy.format(yyyymmdd.parse(rs.getString("CreatedDate"))));
				jsonObject.put("DateDataIndex", sdf.format(rs.getTimestamp("CreatedDate")));
			}
            
            informationList.add(rs.getString("VehicleNo"));
            jsonObject.put("vehicleNoDataIndex", rs.getString("VehicleNo"));
            
            informationList.add(rs.getString("DriverName"));
            jsonObject.put("driverDataIndex", rs.getString("DriverName"));
            
            informationList.add(rs.getString("CustodianName1"));
            jsonObject.put("custodian1DataIndex", rs.getString("CustodianName1"));
            
            informationList.add(rs.getString("TripId"));
            jsonObject.put("TripIdDataIndex",rs.getString("TripId"));
            
            informationList.add(rs.getString("RouteName"));
            jsonObject.put("routeDataIndex",rs.getString("RouteName"));
           
            informationList.add(rs.getString("AssetNo"));
            jsonObject.put("assetNameDataIndex",rs.getString("AssetNo"));
            
            jsonArray.put(jsonObject);
            reporthelper.setInformationList(informationList);
			reportsList.add(reporthelper);
            
        }  
         
        finalreporthelper.setReportsList(reportsList);
		finalreporthelper.setHeadersList(headersList);
	    finlist.add(jsonArray);
		finlist.add(finalreporthelper);
     
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        DBConnection.releaseConnectionToDB(con, pstmt, rs);
    }
    return finlist;
}
public JSONArray getCrew(int systemId,int clientId) {
	JSONArray jsonArray = new JSONArray();
	JSONObject Obj = new JSONObject();
	Connection con=null;
	PreparedStatement pstmt=null;
	ResultSet rs=null;
	try{
		con = DBConnection.getConnectionToDB("AMS");
		jsonArray = new JSONArray();
		pstmt = con.prepareStatement(CashVanManagementStatements.GET_CREW_DETAILS);
		pstmt.setInt(1,systemId);
		pstmt.setInt(2,clientId);
 		rs = pstmt.executeQuery();
 		Obj.put("CrewId", "0");
		Obj.put("CrewName", "ALL");
		jsonArray.put(Obj);
		while(rs.next()){
			Obj = new JSONObject();
			Obj.put("CrewId", rs.getString("Id"));
			Obj.put("CrewName", rs.getString("CrewName") +"-"+ rs.getString("EmploymentType"));
			jsonArray.put(Obj);
			}
	}catch(Exception e){
		e.printStackTrace();
	}finally{
		DBConnection.releaseConnectionToDB(con, pstmt, rs);
	}	
	return jsonArray;
}
public JSONArray getAtmNo(int systemId,int clientId) {
	JSONArray jsonArray = new JSONArray();
	JSONObject Obj = new JSONObject();
	Connection con=null;
	PreparedStatement pstmt=null;
	ResultSet rs=null;
	try{
		con = DBConnection.getConnectionToDB("AMS");
		jsonArray = new JSONArray();
		pstmt = con.prepareStatement(CashVanManagementStatements.GET_BUSINESS_DETAILS);
		pstmt.setInt(1,systemId);
		pstmt.setInt(2,clientId);
 		rs = pstmt.executeQuery();
 		Obj.put("AtmId", "0");
		Obj.put("AtmNo", "ALL");
		jsonArray.put(Obj);
		while(rs.next()){
			Obj = new JSONObject();
			Obj.put("AtmId", rs.getString("ID"));
			Obj.put("AtmNo", rs.getString("BUSINESS_ID"));
			jsonArray.put(Obj);
			}
	}catch(Exception e){
		e.printStackTrace();
	}finally{
		DBConnection.releaseConnectionToDB(con, pstmt, rs);
	}	
	return jsonArray;
}
public JSONArray getVehicleDetails(int systemId,int clientId,int userId) {
	JSONArray jsonArray = new JSONArray();
	JSONObject Obj = new JSONObject();
	Connection con=null;
	PreparedStatement pstmt=null;
	ResultSet rs=null;
	try{
		con = DBConnection.getConnectionToDB("AMS");
		jsonArray = new JSONArray();
		pstmt = con.prepareStatement(CashVanManagementStatements.GET_VEHICLE_DETAILS);
		pstmt.setInt(1,systemId);
		pstmt.setInt(2,clientId);
		pstmt.setInt(3,userId);
 		rs = pstmt.executeQuery();
		//Obj.put("VehicleNo", "ALL");
		//jsonArray.put(Obj);
		while(rs.next()){
			Obj = new JSONObject();
			Obj.put("VehicleNo", rs.getString("VehicleNo"));
			jsonArray.put(Obj);
			}
	}catch(Exception e){
		e.printStackTrace();
	}finally{
		DBConnection.releaseConnectionToDB(con, pstmt, rs);
	}	
	return jsonArray;

}
public JSONArray getAllVehicleDetails(int systemId,int clientId,int userId) {
	JSONArray jsonArray = new JSONArray();
	JSONObject Obj = new JSONObject();
	Connection con=null;
	PreparedStatement pstmt=null;
	ResultSet rs=null;
	try{
		con = DBConnection.getConnectionToDB("AMS");
		jsonArray = new JSONArray();
		pstmt = con.prepareStatement(CashVanManagementStatements.GET_VEHICLE_DETAILS);
		pstmt.setInt(1,systemId);
		pstmt.setInt(2,clientId);
		pstmt.setInt(3,userId);
 		rs = pstmt.executeQuery();
		Obj.put("VehicleNo", "ALL");
		jsonArray.put(Obj);
		while(rs.next()){
			Obj = new JSONObject();
			Obj.put("VehicleNo", rs.getString("VehicleNo"));
			jsonArray.put(Obj);
			}
	}catch(Exception e){
		e.printStackTrace();
	}finally{
		DBConnection.releaseConnectionToDB(con, pstmt, rs);
	}	
	return jsonArray;

}
public JSONArray getTripNo(int systemId,int clientId,int userId) {
	JSONArray jsonArray = new JSONArray();
	JSONObject Obj = new JSONObject();
	Connection con=null;
	PreparedStatement pstmt=null;
	ResultSet rs=null;
	try{
		con = DBConnection.getConnectionToDB("AMS");
		jsonArray = new JSONArray();
		pstmt = con.prepareStatement(CashVanManagementStatements.GET_TRIP_NO_DETAILS);
		pstmt.setInt(1,systemId);
		pstmt.setInt(2,clientId);
 		rs = pstmt.executeQuery();
		
		while(rs.next()){
			Obj = new JSONObject();
			Obj.put("TripId", rs.getString("TRIP_ID"));
			Obj.put("TripNo", rs.getString("TripNo"));
			jsonArray.put(Obj);
			}
	}catch(Exception e){
		e.printStackTrace();
	}finally{
		DBConnection.releaseConnectionToDB(con, pstmt, rs);
	}	
	return jsonArray;

}
public JSONArray getQuotationNo(int systemId,int clientId,int userId) {
	JSONArray jsonArray = new JSONArray();
	JSONObject Obj = new JSONObject();
	Connection con=null;
	PreparedStatement pstmt=null;
	ResultSet rs=null;
	try{
		con = DBConnection.getConnectionToDB("AMS");
		jsonArray = new JSONArray();
		pstmt = con.prepareStatement(CashVanManagementStatements.GET_QUOTATION_NO_DETAILS);
		pstmt.setInt(1,systemId);
		pstmt.setInt(2,clientId);
 		rs = pstmt.executeQuery();
 		Obj.put("QuotationId", "0");
		Obj.put("QuotationNo", "ALL");
		jsonArray.put(Obj);
		while(rs.next()){
			Obj = new JSONObject();
			Obj.put("QuotationId", rs.getString("QUOTATION_ID"));
			Obj.put("QuotationNo", rs.getString("QUOTATION_NO"));
			jsonArray.put(Obj);
			}
	}catch(Exception e){
		e.printStackTrace();
	}finally{
		DBConnection.releaseConnectionToDB(con, pstmt, rs);
	}	
	return jsonArray;

}
//*********************************************** t4u506 begin ****************************************//

public JSONArray getCustomerNames(int systemId, int clientId) {
	Connection con = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	JSONArray jArray = new JSONArray();
	JSONObject obj = null;
	try{
		con = DBConnection.getConnectionToDB("AMS");
		pstmt = con.prepareStatement(CashVanManagementStatements.getCustomerNames);
		pstmt.setInt(1, systemId);
		pstmt.setInt(2, clientId);
		///pstmt.setInt(3, Integer.parseInt(routeId));
		//pstmt.setInt(4, systemId);
		//pstmt.setInt(5, clientId);
		//pstmt.setString(6, tripSheetNo);
		rs = pstmt.executeQuery();
		while(rs.next()){
			obj = new JSONObject();
			obj.put("destCustomerId", rs.getString("CustomerId"));
			obj.put("destCustomerName", rs.getString("CustomerName"));
			jArray.put(obj);
		}
	}catch(Exception e){
		e.printStackTrace();
	}finally{
		DBConnection.releaseConnectionToDB(con, pstmt, rs);
	}
	return jArray;
}

//*********************************************** t4u506 end ****************************************//

//*********************************************** t4u506 begin ****************************************//

public JSONArray getDeliveryLocation(int systemId, int clientId,String customerId) {
	Connection con = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	JSONArray jArray = new JSONArray();
	JSONObject obj = null;
	try{
		con = DBConnection.getConnectionToDB("AMS");
		pstmt = con.prepareStatement(CashVanManagementStatements.getDeliveryLocation);
		pstmt.setInt(1, systemId);
		pstmt.setInt(2, clientId);
		pstmt.setString(3, customerId);
		//pstmt.setInt(4, systemId);
		//pstmt.setInt(5, clientId);
		//pstmt.setString(6, tripSheetNo);
		rs = pstmt.executeQuery();
		while(rs.next()){
			obj = new JSONObject();
			obj.put("deliveryLocId", rs.getString("ID"));
			//obj.put("deliveryLocName", rs.getString("CustomerName"));
			obj.put("deliveryCustomerName", rs.getString("Business"));
			jArray.put(obj);
		}
	}catch(Exception e){
		e.printStackTrace();
	}finally{
		DBConnection.releaseConnectionToDB(con, pstmt, rs);
	}
	return jArray;
}

	public ArrayList<Object> getVehicleWiseReportDetails(int customerId,int systemId, int offset, String startdate, String enddate,
			String vehicleNo) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject = null;
		ArrayList<Object> finlist = new ArrayList<Object>();
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		ArrayList<ReportHelper> reportsList = new ArrayList<ReportHelper>();
		ArrayList<String> headersList = new ArrayList<String>();
		ReportHelper finalreporthelper = new ReportHelper();
		try {
			headersList.add("SL NO");
			headersList.add("Vehicle Number");
			headersList.add("Bussiness Id");
			headersList.add("Customer Name");
			headersList.add("TR Number");
			headersList.add("Business Type");
			headersList.add("Delivery Customer");
			headersList.add("Address");
			headersList.add("Hub");
			headersList.add("Date");
			headersList.add("Single/Combine");
			headersList.add("One Way/Two way");
			headersList.add("Said to contain");
			headersList.add("Rate");
			headersList.add("Amount");

			int count = 0;
			con = DBConnection.getConnectionToDB("AMS");

			StringBuffer strAppend = new StringBuffer();

			if  (vehicleNo.equalsIgnoreCase("ALL")) {
				strAppend.append(" ");
			}
			else if (!vehicleNo.equals("")) {
				strAppend.append("and tp.ASSET_NUMBER='" + vehicleNo + "'");
			}

			pstmt = con.prepareStatement(CashVanManagementStatements.GET_VEHICLE_WISE_DETAILS.replace("#", strAppend));
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, customerId);
			pstmt.setInt(3, offset);
			pstmt.setString(4, startdate);
			pstmt.setInt(5, offset);
			pstmt.setString(6, enddate);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				ArrayList<Object> informationList = new ArrayList<Object>();
				ReportHelper reporthelper = new ReportHelper();
				count++;
				jsonObject = new JSONObject();

				informationList.add(count);
				jsonObject.put("slnoIndex", count);

				informationList.add(rs.getString("AssetNumber"));
				jsonObject.put("vehicleNoDataIndex", rs.getString("AssetNumber"));

				informationList.add(rs.getString("BussinessId"));
				jsonObject.put("businessIdDataIndex", rs.getString("BussinessId"));

				informationList.add(rs.getString("BankName"));
				jsonObject.put("customerNameDataIndex", rs.getString("BankName"));
				
				informationList.add(rs.getString("trNumber"));
				jsonObject.put("trNumberDataIndex", rs.getString("trNumber"));

				informationList.add(rs.getString("BusinessType"));
				jsonObject.put("businessTypeDataIndex", rs.getString("BusinessType"));
				
				informationList.add(rs.getString("delivaryCustomerName"));
				jsonObject.put("deliveryDataIndex", rs.getString("delivaryCustomerName"));

				informationList.add(rs.getString("Address"));
				jsonObject.put("locationDataIndex", rs.getString("Address"));

				informationList.add(rs.getString("Hub"));
				jsonObject.put("hubDataIndex", rs.getString("Hub"));

				if (rs.getString("CreatedDate") == ""|| rs.getString("CreatedDate").contains("1900")) {
					informationList.add("");
					jsonObject.put("DateDataIndex", "");
				} else {
					informationList.add(ddmmyyyy.format(yyyymmdd.parse(rs.getString("CreatedDate"))));
					jsonObject.put("DateDataIndex", sdf.format(rs.getTimestamp("CreatedDate")));
				}
				
				informationList.add("");
				jsonObject.put("singleDataIndex", "");
				
				informationList.add("");
				jsonObject.put("oneWayDataIndex", "");
				
				informationList.add("");
				jsonObject.put("saidtoContainDataIndex", "");
				
				informationList.add("");
				jsonObject.put("RateDataIndex", "");
				
				informationList.add("");
				jsonObject.put("AmountDataIndex", "");
				
				jsonArray.put(jsonObject);
				reporthelper.setInformationList(informationList);
				reportsList.add(reporthelper);

			}

			finalreporthelper.setReportsList(reportsList);
			finalreporthelper.setHeadersList(headersList);
			finlist.add(jsonArray);
			finlist.add(finalreporthelper);

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return finlist;
   }
	public ArrayList<Object> getCustomerWiseReportDetails(int customerId,int systemId, int offset, String startdate, String enddate,
		String CustomerId) {
	Connection con = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	JSONArray jsonArray = new JSONArray();
	JSONObject jsonObject = null;
	ArrayList<Object> finlist = new ArrayList<Object>();
	SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	ArrayList<ReportHelper> reportsList = new ArrayList<ReportHelper>();
	ArrayList<String> headersList = new ArrayList<String>();
	ReportHelper finalreporthelper = new ReportHelper();
	try {
		headersList.add("SL NO");
		headersList.add("Bussiness Id");
		headersList.add("Customer Name");
		headersList.add("TR Number");
		headersList.add("Business Type");
		headersList.add("Delivery Customer");
		headersList.add("Location");
		headersList.add("Address");
		headersList.add("Hub");
		headersList.add("Date");
		headersList.add("Vehicle Number");
		headersList.add("Single/Combine");
		headersList.add("One Way/Two way");
		headersList.add("Said to contain");
		headersList.add("Rate");
		headersList.add("Amount");

		int count = 0;
		con = DBConnection.getConnectionToDB("AMS");

		StringBuffer strAppend = new StringBuffer();
		if  (CustomerId.equals("0")) {
			strAppend.append(" ");
		}else if (!CustomerId.equals("")) {
			strAppend.append("and  b.CVS_CUSTOMER_ID="+ CustomerId );
		}

		pstmt = con.prepareStatement(CashVanManagementStatements.GET_VEHICLE_WISE_DETAILS.replace("#", strAppend));
		pstmt.setInt(1, systemId);
		pstmt.setInt(2, customerId);
		pstmt.setInt(3, offset);
		pstmt.setString(4, startdate);
		pstmt.setInt(5, offset);
		pstmt.setString(6, enddate);
		rs = pstmt.executeQuery();
		while (rs.next()) {
			ArrayList<Object> informationList = new ArrayList<Object>();
			ReportHelper reporthelper = new ReportHelper();
			count++;
			jsonObject = new JSONObject();

			informationList.add(count);
			jsonObject.put("slnoIndex", count);

			informationList.add(rs.getString("BussinessId"));
			jsonObject.put("businessIdDataIndex", rs.getString("BussinessId"));

			informationList.add(rs.getString("BankName"));
			jsonObject.put("customerNameDataIndex", rs.getString("BankName"));
			
			informationList.add(rs.getString("trNumber"));
 			jsonObject.put("trNumberDataIndex", rs.getString("trNumber"));

			informationList.add(rs.getString("BusinessType"));
			jsonObject.put("businessTypeDataIndex", rs.getString("BusinessType"));
			
			informationList.add(rs.getString("delivaryCustomerName"));
 			jsonObject.put("deliveryDataIndex", rs.getString("delivaryCustomerName"));
 			
			informationList.add(rs.getString("LOCATION"));
			jsonObject.put("locDataIndex", rs.getString("LOCATION"));

			informationList.add(rs.getString("Address"));
			jsonObject.put("locationDataIndex", rs.getString("Address"));
			
			informationList.add(rs.getString("Hub"));
			jsonObject.put("hubDataIndex", rs.getString("Hub"));

			if (rs.getString("CreatedDate") == ""|| rs.getString("CreatedDate").contains("1900")) {
				informationList.add("");
				jsonObject.put("DateDataIndex", "");
			} else {
				informationList.add(ddmmyyyy.format(yyyymmdd.parse(rs.getString("CreatedDate"))));
				jsonObject.put("DateDataIndex", sdf.format(rs.getTimestamp("CreatedDate")));
			}
			informationList.add(rs.getString("AssetNumber"));
			jsonObject.put("vehicleNoDataIndex", rs.getString("AssetNumber"));
			
			informationList.add("");
			jsonObject.put("singleDataIndex", "");
			
			informationList.add("");
			jsonObject.put("oneWayDataIndex", "");
			
			informationList.add("");
			jsonObject.put("saidtoContainDataIndex", "");
			
			informationList.add("");
			jsonObject.put("RateDataIndex", "");
			
			informationList.add("");
			jsonObject.put("AmountDataIndex", "");
			
			jsonArray.put(jsonObject);
			reporthelper.setInformationList(informationList);
			reportsList.add(reporthelper);

		}

		finalreporthelper.setReportsList(reportsList);
		finalreporthelper.setHeadersList(headersList);
		finlist.add(jsonArray);
		finlist.add(finalreporthelper);

	} catch (Exception e) {
		e.printStackTrace();
	} finally {
		DBConnection.releaseConnectionToDB(con, pstmt, rs);
	}
	return finlist;
}
	

//*********************************************** t4u506 end ****************************************//


}