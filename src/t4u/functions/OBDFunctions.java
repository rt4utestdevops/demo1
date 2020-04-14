package t4u.functions;
import java.io.File;
import java.io.FileOutputStream;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Properties;
import java.util.Set;
import java.util.regex.Pattern;

import org.apache.poi.hssf.usermodel.HSSFCellStyle;

import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.hssf.util.CellRangeAddress;
import org.apache.poi.hssf.util.Region;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.CreationHelper;
import org.apache.poi.ss.usermodel.DataFormat;
import org.apache.poi.ss.usermodel.Font;
import org.apache.poi.ss.usermodel.IndexedColors;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Workbook;
import org.json.JSONArray;
import org.json.JSONObject;

import t4u.beans.ReportHelper;
import t4u.common.ApplicationListener;
import t4u.common.DBConnection;
import t4u.statements.OBDStatements;
import t4u.functions.CommonFunctions;

public class OBDFunctions {
	static SimpleDateFormat ddmmyyyy = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
	static SimpleDateFormat yyyymmdd = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	SimpleDateFormat sdfyyyymmddhhmmss=new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
	DecimalFormat Dformatter = new DecimalFormat("#.##");
	DecimalFormat Dformatter1 = new DecimalFormat("#.###");
	DecimalFormat Dformatter2 = new DecimalFormat("0.000");
	JSONArray OBDDetailsArray = new JSONArray();
	JSONObject OBDDetailsObject = new JSONObject();
	CommonFunctions cf=new CommonFunctions();
	SimpleDateFormat sdfDBMMDD = new SimpleDateFormat("yyyy-MM-dd");
	SimpleDateFormat sdfDB = new SimpleDateFormat("yyyy-MM-ddHH:mm:ss");
	public static JSONArray getErrorCodAggregate(int systemId,int customerId,int userId) {
		
		JSONArray OBDDetailsArray = new JSONArray();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			ArrayList<Object> ar = null;
			String sql="select count(*) as Count from CANIQ_ERROR_CODES where SYSTEM_ID=? and CLIENT_ID=? and ERROR_CODE like 'P%' and REGISTRATION_NO in (select Registration_no from Vehicle_User where System_id=? and User_id=?)";
			
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(sql);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, customerId);
			pstmt.setInt(3, systemId);
			pstmt.setInt(4, userId);
		    rs = pstmt.executeQuery();
			if (rs.next()) {
					ar = new ArrayList<Object>();
					ar.add("Power train");
					ar.add(rs.getInt("Count"));
					OBDDetailsArray.put(ar);
			}else{
				ar = new ArrayList<Object>();
				ar.add("Power train");
				ar.add(0);
				OBDDetailsArray.put(ar);
			}
			pstmt.close();
			rs.close();
			
			sql="select count(*) as Count from CANIQ_ERROR_CODES where SYSTEM_ID=? and CLIENT_ID=? and ERROR_CODE like 'C%' and REGISTRATION_NO in (select Registration_no from Vehicle_User where System_id=? and User_id=?)";
			pstmt = con.prepareStatement(sql);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, customerId);
			pstmt.setInt(3, systemId);
			pstmt.setInt(4, userId);
	    	rs = pstmt.executeQuery();
		if (rs.next()) {
				ar = new ArrayList<Object>();
				ar.add("Chassis");
				ar.add(rs.getInt("Count"));
				OBDDetailsArray.put(ar);
		}else{
			ar = new ArrayList<Object>();
			ar.add("Chassis");
			ar.add(0);
			OBDDetailsArray.put(ar);
		}
		pstmt.close();
		rs.close();
			
		sql="select count(*) as Count from CANIQ_ERROR_CODES where SYSTEM_ID=? and CLIENT_ID=? and ERROR_CODE like 'B%' and REGISTRATION_NO in (select Registration_no from Vehicle_User where System_id=? and User_id=?)";
		pstmt = con.prepareStatement(sql);
		pstmt.setInt(1, systemId);
		pstmt.setInt(2, customerId);
		pstmt.setInt(3, systemId);
		pstmt.setInt(4, userId);
    	rs = pstmt.executeQuery();
		if (rs.next()) {
				ar = new ArrayList<Object>();
				ar.add("Body");
				ar.add(rs.getInt("Count"));
				OBDDetailsArray.put(ar);
		}else{
			ar = new ArrayList<Object>();
			ar.add("Body");
			ar.add(0);
			OBDDetailsArray.put(ar);
		}
		pstmt.close();
		rs.close();
			
		sql="select count(*) as Count from CANIQ_ERROR_CODES where SYSTEM_ID=? and CLIENT_ID=? and ERROR_CODE like 'U%' and REGISTRATION_NO in (select Registration_no from Vehicle_User where System_id=? and User_id=?)";
		pstmt = con.prepareStatement(sql);
    	pstmt.setInt(1, systemId);
		pstmt.setInt(2, customerId);
		pstmt.setInt(3, systemId);
		pstmt.setInt(4, userId);
		rs = pstmt.executeQuery();
		if (rs.next()) {
				ar = new ArrayList<Object>();
				ar.add("Network");
				ar.add(rs.getInt("Count"));
				OBDDetailsArray.put(ar);
		}else{
			ar = new ArrayList<Object>();
			ar.add("Network");
			ar.add(0);
			OBDDetailsArray.put(ar);
		}
		pstmt.close();
		rs.close();
		
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return OBDDetailsArray;
	}


	public static JSONArray getAlertCount(String alertList,int systemId,int customerId, int userId, int offset) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		JSONObject alertcountObject=null;
		JSONArray alertcountArray=new JSONArray();
		int border=0;
		int nonComm12=0;
		int deviceBatCount = 0;
		int gpsTampCrossBorderCount = 0;
		try {
			conn = DBConnection.getConnectionToDB("AMS");
			/**
			 * OverSpeed
			 ***/
			int unitType=68;
			pstmt = conn.prepareStatement(OBDStatements.GET_ALERT_COUNT);
			pstmt.setInt(1, userId);
			pstmt.setInt(2, systemId);
			pstmt.setInt(3, customerId);
			pstmt.setInt(4, unitType);
			pstmt.setInt(5, userId);
			pstmt.setInt(6, systemId);
			pstmt.setInt(7, customerId);
			pstmt.setInt(8, unitType);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				if(rs.getInt("TYPE_OF_ALERT")== 84){
					border=rs.getInt("ALERT_COUNT");
				}
			}
			
			rs.close();
			pstmt.close();
			
			pstmt = conn.prepareStatement(OBDStatements.GET_ALERT_COUNT_NON_COMMUNICATING);
			pstmt.setInt(1, userId);
			pstmt.setInt(2, systemId);
			pstmt.setInt(3, customerId);
			pstmt.setInt(4, unitType);
			pstmt.setInt(5, userId);
			pstmt.setInt(6, systemId);
			pstmt.setInt(7, customerId);
			pstmt.setInt(8, unitType);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				 if(rs.getInt("TYPE_OF_ALERT")== 85){
					nonComm12=rs.getInt("ALERT_COUNT");
				}
				else if(rs.getInt("TYPE_OF_ALERT")== 148){
					gpsTampCrossBorderCount=rs.getInt("ALERT_COUNT");
				}
			}
			rs.close();
			pstmt.close();
			
			
			pstmt = conn.prepareStatement(OBDStatements.GET_ALERT_COUNT_DEVICE_BATERY_CONNECTION);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2,customerId);
			pstmt.setInt(3,unitType);
			rs = pstmt.executeQuery();
			while (rs.next()) {
					deviceBatCount=rs.getInt("AlertCount");
			}
			rs.close();
			pstmt.close();
			
			
				alertcountObject=new JSONObject();
				alertcountObject.put("CrossBorder", border);
				alertcountObject.put("Noncomm",nonComm12);
				alertcountObject.put("DeviceBattery",deviceBatCount);
				alertcountObject.put("TamperCrossBorder",gpsTampCrossBorderCount);
				alertcountArray.put(alertcountObject);
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(conn, pstmt, rs);
		}
		return alertcountArray;
	}
	
	public static JSONArray getAlertCountSecondary(String alertList, int systemId,int customerId, int userId, int offmin) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int overspeed=0;
		JSONObject alertcountObject=null;
		JSONArray alertcountArray=new JSONArray();
		
		try {
			conn = DBConnection.getConnectionToDB("AMS");
			/**
			 * OverSpeed
			 ***/
			int unitType=68;
			if(alertList.contains("OverSpeed"))
			{
				pstmt = conn.prepareStatement(OBDStatements.GET_OVER_SPEED_ALERT_COUNT);
				pstmt.setInt(1, customerId);
				pstmt.setInt(2, systemId);
				pstmt.setInt(3, userId);
				pstmt.setInt(4, unitType);
				pstmt.setInt(5, customerId);
				pstmt.setInt(6, systemId);
				pstmt.setInt(7, userId);
				pstmt.setInt(8, unitType);
				rs = pstmt.executeQuery();
				if (rs.next()) {
					overspeed=rs.getInt("ALERT_COUNT");
				}
				rs.close();
				pstmt.close();
			}
			alertcountObject=new JSONObject();
			alertcountObject.put("OverSpeed", overspeed);
			alertcountArray.put(alertcountObject);
		}catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(conn, pstmt, rs);
		}
		return alertcountArray;	
	}
	
	public static JSONArray getCommNonCommVehicles(String customerid, int systemId,int userId,int isLtsp,int offset,String zone) {
		Connection con = null;
		PreparedStatement pstmt = null,pstmt1 = null,pstmt2 = null,pstmt6 = null;
		ResultSet rs = null;		
		JSONArray commnoncommJSONArray=new JSONArray();
		JSONObject commnoncommJSONObject;
		try {		
			int nonCommunicatingCount=0;
			int communicatingVehicles=0;
			int noGpsConnected=0;
			int totalAssetCount=0;
			int voltagedrain=0;
			commnoncommJSONObject=new JSONObject();
			
			int unitType=68;
			
			
			con = DBConnection.getConnectionToDB("AMS");
				pstmt = con.prepareStatement(OBDStatements.GET_TOTAL_ASSET_COUNT);
				pstmt1 = con.prepareStatement(OBDStatements.GET_NON_COMMUNICATING);					
				pstmt2 = con.prepareStatement(OBDStatements.GET_NOGPS_VEHICLES);
			    pstmt6 = con.prepareStatement(OBDStatements.GET_VOLTAGE_DRAIN);
		
			rs=null;
			pstmt.setInt(1, systemId);
			pstmt.setString(2, customerid);
			pstmt.setInt(3, unitType);
			pstmt.setInt(4,userId);
			rs = pstmt.executeQuery();
			if (rs.next()) {			
				totalAssetCount=rs.getInt("COUNT");
			}
			rs=null;
			pstmt1.setString(1, customerid);
			pstmt1.setInt(2, systemId);
			pstmt1.setInt(3, unitType);
			pstmt1.setInt(4,userId);
			rs = pstmt1.executeQuery();
			if (rs.next()) {			
				nonCommunicatingCount=rs.getInt("NON_COMMUNICATING");
			}			
			rs=null;		
			pstmt2.setString(1,customerid);
			pstmt2.setInt(2, systemId);
			pstmt2.setInt(3, unitType);
			pstmt2.setInt(4,userId);
			rs = pstmt2.executeQuery();
			if (rs.next()) {			
				noGpsConnected=rs.getInt("NOGPS");
			}	
			rs=null;
			pstmt6.setInt(1, systemId);
			pstmt6.setString(2, customerid);
			pstmt6.setInt(3, unitType);
			pstmt6.setInt(4,userId);
			rs = pstmt6.executeQuery();
			if (rs.next()) {			
				voltagedrain=rs.getInt("COUNT");
			}
			communicatingVehicles=totalAssetCount-(nonCommunicatingCount+noGpsConnected);			
			commnoncommJSONObject.put("totalAssets",totalAssetCount);
			commnoncommJSONObject.put("communicating", communicatingVehicles);
			commnoncommJSONObject.put("noncommunicating",nonCommunicatingCount);
			commnoncommJSONObject.put("voltagedrain",voltagedrain);
			commnoncommJSONObject.put("noGpsConnected",noGpsConnected);
			commnoncommJSONArray.put(commnoncommJSONObject);		
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
			DBConnection.releaseConnectionToDB(null, pstmt1, null);
			DBConnection.releaseConnectionToDB(null, pstmt2, null);	
			DBConnection.releaseConnectionToDB(null, pstmt6, null);
		}	
		return commnoncommJSONArray;	
	}
	
	public static JSONArray getAlertDetails(int offset, String alertID, int systemId,int customerId, int userId,String type) {
		Connection con = null;
		PreparedStatement pstmt = null;
		PreparedStatement pstmt1 = null;
		ResultSet rs = null;
		ResultSet rs1 = null;
		String vehicleNo = "";
		String alertDetails = "";
        int alertId;
		JSONArray alertdetailsJSONArray = new JSONArray();
		JSONObject alertdetailsJSONObject = null;
		try {
			con = DBConnection.getConnectionToDB("AMS");
			int unitType=68;
			int count=0;
			if(alertID.equals("DeviceBattery")){
				pstmt = con.prepareStatement(OBDStatements.DEVICE_BATERY_CONNECTION_DETAIL);
				pstmt.setInt(1, systemId);
				pstmt.setInt(2,customerId);
				pstmt.setInt(3,unitType);
				rs = pstmt.executeQuery();
				while (rs.next()) {
					alertdetailsJSONObject = new JSONObject();
					count++;
					vehicleNo = rs.getString("REGISTRATION_NO");
					alertdetailsJSONObject.put("slNo",count);
					alertdetailsJSONObject.put("location",  rs.getString("LOCATION") );
					alertdetailsJSONObject.put("gpstime", ddmmyyyy.format(yyyymmdd.parse(rs.getString("GPS_DATETIME"))));
					alertdetailsJSONObject.put("vehicleNo",vehicleNo);
					alertdetailsJSONObject.put("speed",rs.getFloat("SPEED"));
					alertdetailsJSONObject.put("alertdetails","Device Battery");
					alertdetailsJSONArray.put(alertdetailsJSONObject);
				}
				rs.close();
				pstmt.close();
				
			}else{
					alertId = Integer.parseInt(alertID);
					
					if (alertId == 2) {
						if(type.equals("Actioned")){
							pstmt = con.prepareStatement((OBDStatements.GET_OVER_SPEED_ALERT).replaceAll("REMARK is null", "REMARK!='' "));
						}else if (type.equals("Un-Actioned")){
						    pstmt = con.prepareStatement(OBDStatements.GET_OVER_SPEED_ALERT);
						}else if (type.equals("All")){
							pstmt = con.prepareStatement((OBDStatements.GET_OVER_SPEED_ALERT).replaceAll("and REMARK is null", ""));
						}
						pstmt.setInt(1, customerId);
						pstmt.setInt(2, systemId);
						pstmt.setInt(3, unitType);
						pstmt.setInt(4, userId);
						pstmt.setInt(5, customerId);
						pstmt.setInt(6, systemId);
						pstmt.setInt(7, unitType);
						pstmt.setInt(8, userId);
						rs = pstmt.executeQuery();
						while (rs.next()) {
							alertdetailsJSONObject = new JSONObject();
							vehicleNo = rs.getString("REGISTRATION_NO");
							count++;
							alertdetailsJSONObject.put("slNo",count);
							alertDetails = "overspeeded"; //vehicleNo + " overspeeded " + rs.getString("LOCATION") + " On " + ddmmyyyy.format(yyyymmdd.parse(rs.getString("GPS_DATETIME"))) + " with Speed "+rs.getString("SPEED")+" km/h" ;
							alertdetailsJSONObject.put("location",  rs.getString("LOCATION") );
							alertdetailsJSONObject.put("gpstime", ddmmyyyy.format(yyyymmdd.parse(rs.getString("GPS_DATETIME"))));
							alertdetailsJSONObject.put("speed", rs.getString("SPEED"));
							alertdetailsJSONObject.put("alertdetails", alertDetails);
							alertdetailsJSONObject.put("alertslno",rs.getString("SLNO"));
							alertdetailsJSONObject.put("vehicleNo",vehicleNo);
							alertdetailsJSONObject.put("alertType",rs.getString("ALERT_TYPE"));
							alertdetailsJSONObject.put("Remarks",rs.getString("REMARKS"));
							alertdetailsJSONArray.put(alertdetailsJSONObject);
						}
					}
					else if(alertId == 145 || alertId == 85 || alertId == 148){
							if(type.equals("Actioned")){
								pstmt = con.prepareStatement((OBDStatements.GET_NON_COMMUNICATING_ALERT_DETAILS).replaceAll("\\(MONITOR_STATUS is null or MONITOR_STATUS='N'\\)", "(MONITOR_STATUS is not null and MONITOR_STATUS!='N')"));
							}else if (type.equals("Un-Actioned")){
							    pstmt = con.prepareStatement(OBDStatements.GET_NON_COMMUNICATING_ALERT_DETAILS);
							}else{
								pstmt = con.prepareStatement((OBDStatements.GET_NON_COMMUNICATING_ALERT_DETAILS).replaceAll("and \\(MONITOR_STATUS is null or MONITOR_STATUS='N'\\)", " "));
							}
						
						pstmt.setInt(1, offset);
						pstmt.setInt(2, systemId);
						pstmt.setInt(3, customerId);
						pstmt.setInt(4, unitType);
						pstmt.setInt(5, alertId);
						pstmt.setInt(6, userId);
						pstmt.setInt(7, offset);
						pstmt.setInt(8, systemId);
						pstmt.setInt(9, customerId);
						pstmt.setInt(10, unitType);
						pstmt.setInt(11, alertId);
						pstmt.setInt(12, userId);
						rs = pstmt.executeQuery();
						while (rs.next()) {
							alertdetailsJSONObject = new JSONObject();
							vehicleNo = rs.getString("REGISTRATION_NO");
							
							switch(alertId){
							
								//Main Power OnOff
								case 7 :
									
									
										if(rs.getInt("HUB_ID") == 0){
											alertDetails = " main power is Off ";
										} else if(rs.getInt("HUB_ID") == 1){
											alertDetails =  " main power is On ";
										} else if(rs.getInt("HUB_ID") == 2){
											alertDetails = " main power input for the device has been tampered ";
										}
								break;
								
								case 85 : alertDetails =" Not communicating ";
										alertdetailsJSONObject.put("gpstime", ddmmyyyy.format(yyyymmdd.parse(rs.getString("GMT")))); //Offset already added
								break;
								
							    default: alertDetails = vehicleNo + " " + rs.getString("LOCATION") +" on "+ ddmmyyyy.format(yyyymmdd.parse(rs.getString("GPS_DATETIME")));
			                    break;
							}
		
							vehicleNo = rs.getString("REGISTRATION_NO");
							count++;
							alertdetailsJSONObject.put("slNo",count);
							alertdetailsJSONObject.put("location",  rs.getString("LOCATION") );
							if(alertId!=85){
								alertdetailsJSONObject.put("gpstime", ddmmyyyy.format(yyyymmdd.parse(rs.getString("GPS_DATETIME"))));
							}
							alertdetailsJSONObject.put("alertdetails", alertDetails);
							alertdetailsJSONObject.put("alertslno",rs.getString("SLNO"));
							alertdetailsJSONObject.put("vehicleNo",vehicleNo);
							alertdetailsJSONObject.put("alertType",rs.getString("ALERT_TYPE"));
							alertdetailsJSONObject.put("Remarks",rs.getString("REMARKS"));
							alertdetailsJSONArray.put(alertdetailsJSONObject);
						}
					
				}
				else  
				{
					if(type.equals("Actioned")){
						pstmt = con.prepareStatement((OBDStatements.GET_ALERT_DETAILS).replaceAll("\\(MONITOR_STATUS is null or MONITOR_STATUS='N'\\)", "(MONITOR_STATUS is not null and MONITOR_STATUS!='N')"));
					}else if (type.equals("Un-Actioned")){
					    pstmt = con.prepareStatement(OBDStatements.GET_ALERT_DETAILS);
					}else{
						pstmt = con.prepareStatement((OBDStatements.GET_ALERT_DETAILS).replaceAll("and  \\(MONITOR_STATUS is null or MONITOR_STATUS='N'\\)", ""));
					}
					pstmt.setInt(1, offset);
					pstmt.setInt(2, systemId);
					pstmt.setInt(3, customerId);
					pstmt.setInt(4, unitType);
					pstmt.setInt(5, alertId);
					pstmt.setInt(6, userId);
					pstmt.setInt(7, offset);
					pstmt.setInt(8, systemId);
					pstmt.setInt(9, customerId);
					pstmt.setInt(10, unitType);
					pstmt.setInt(11, alertId);
					pstmt.setInt(12, userId);
					rs = pstmt.executeQuery();
					while (rs.next()) {
						alertdetailsJSONObject = new JSONObject();
						vehicleNo = rs.getString("REGISTRATION_NO");
						
						switch(alertId){
							//Stoppage
							case 1 :	alertDetails = "Stoppage";
										alertdetailsJSONObject.put("Stoppage Duration",getDayHrMinFormat(rs.getDouble("STOP_HOURS")) + "(dd:hh:mm)");
										break;
							
							//Main Power OnOff
							
							case 38 : int alertType = rs.getInt("HUB_ID");
									  String alertStatus = "OPEN";
									  if(alertType == 1){
										  alertStatus = "CLOSE";
									  }
							
								     alertDetails = "Door was " + alertStatus ;
							break;
							
							
							case 82 : alertDetails =  " inside border";
							break;
							
							case 83 : alertDetails =  " near to border";
							break;
							
							case 84 : alertDetails = " crossed border" ;
							break;
							
							case 139 :	alertDetails = "stopped";
										alertdetailsJSONObject.put("Stoppage Duration",getDayHrMinFormat(rs.getDouble("STOP_HOURS")) + "(dd:hh:mm)");
							break;
							
						    default: alertDetails =  rs.getString("LOCATION") ;
		                    break;
						}
							if(alertId!=38){
								alertdetailsJSONObject.put("location", alertDetails);
							}
							count++;
							alertdetailsJSONObject.put("alertdetails", alertDetails);
							alertdetailsJSONObject.put("slNo",count);
							alertdetailsJSONObject.put("alertslno",rs.getString("SLNO"));
							alertdetailsJSONObject.put("vehicleNo",vehicleNo);
							alertdetailsJSONObject.put("gpstime",rs.getString("GPS_DATETIME"));
							alertdetailsJSONObject.put("alertType",rs.getString("ALERT_TYPE"));
							alertdetailsJSONObject.put("Remarks",rs.getString("MONITOR_STATUS"));
							alertdetailsJSONArray.put(alertdetailsJSONObject);
						}
		
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
	
	public static JSONArray getErrorCodeDetails(int systemId, int customerId,int offset,String type,int userId) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		JSONObject errorCodeObject=null;
		JSONArray errorCodeArray=new JSONArray();
		
		try {
			conn = DBConnection.getConnectionToDB("AMS");
			int count=0;
			String errorCodeQuery=OBDStatements.GET_ERRORCODE_DETAILS;
			if(type!=""){
				if(type.equalsIgnoreCase("Network")){
					errorCodeQuery+=" and ERROR_CODE like 'U%' and REGISTRATION_NO in (select Registration_no from Vehicle_User where System_id=? and User_id=?)";
				}else{
					errorCodeQuery+=" and ERROR_CODE like '"+type.charAt(0)+"%' and REGISTRATION_NO in (select Registration_no from Vehicle_User where System_id=? and User_id=?)";
				}
				
			}
				pstmt = conn.prepareStatement(errorCodeQuery);
				pstmt.setInt(1, offset);
				pstmt.setInt(2, systemId);
				pstmt.setInt(3, customerId);
				pstmt.setInt(4, systemId);
				pstmt.setInt(5, userId);
				rs = pstmt.executeQuery();
				while (rs.next()) {
					count++;
					errorCodeObject=new JSONObject();
					errorCodeObject.put("slNo", count);
					errorCodeObject.put("vehicleNo", rs.getString("REGISTRATION_NO"));
					errorCodeObject.put("errorCode", rs.getString("ERROR_CODE"));
					errorCodeObject.put("codeDesc", rs.getString("ERROR_DESC"));
					errorCodeObject.put("gpsTime", rs.getString("GPS_TIME"));
					errorCodeObject.put("remarks", rs.getString("REMARKS"));
					errorCodeObject.put("vehType", rs.getString("VEHTYPE"));
					errorCodeObject.put("vehModel", rs.getString("MODEL"));
					errorCodeArray.put(errorCodeObject);
				}
				rs.close();
				pstmt.close();
			
		}catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(conn, pstmt, rs);
		}
		return errorCodeArray;
	}
	public static String getDayHrMinFormat(Double strDays) {
		String ConvertDaysToDuration = "";
		try {
			double iDays, lHrMinSec, lMinSec;
			int lDays, lHours, lMinutes;
	
			if (strDays == 0) {
				iDays = 0;
			} else {
				iDays = strDays/24;
			}

			lDays = (int) iDays;
			lHrMinSec = (iDays - lDays) * 24;
			lHours = (int) lHrMinSec;
			lMinSec = (lHrMinSec - lHours) * 60;
			lMinutes = (int) lMinSec;

			String Days = lDays <= 9 ? "0" + lDays : String.valueOf(lDays);
			String Hours = lHours <= 9 ? "0" + lHours : String.valueOf(lHours);
			String Minutes = lMinutes <= 9 ? "0" + lMinutes : String.valueOf(lMinutes);

			ConvertDaysToDuration = Days + " : " + Hours + " : " + Minutes;
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		return ConvertDaysToDuration;
	}
	public synchronized JSONArray getVehicleDiagnosticDeatails(int systemId, int clientId,String vehicleNo) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		PreparedStatement pstmt1 = null;
		ResultSet rs1 = null;
		PreparedStatement pstmt2 = null;
		ResultSet rs2 = null;
		JSONArray jArr = new JSONArray();
		JSONObject obj = null;
		String regex = "[0-9]+(.[0-9][0-9]+)";
		String parameterValue = "NA";
		
		double convertionFactor=cf.getUnitOfMeasureConvertionsfactor(systemId);
		try{
			con = DBConnection.getConnectionToDB("AMS");
			
			String vehicleModel = "";
			pstmt = con.prepareStatement(OBDStatements.GET_VEHICLE_DETAILS);
			pstmt.setInt(1, systemId);
			pstmt.setString(2, vehicleNo);
			rs = pstmt.executeQuery();
			if(rs.next()){
				vehicleModel = rs.getString("modelId");
			}
			pstmt.close();
			rs.close();
			
			pstmt = con.prepareStatement(OBDStatements.GET_VEHICLLE_LOOKUP_DETAILS);
			pstmt.setInt(1, systemId);
			pstmt.setString(2, vehicleModel);
			rs = pstmt.executeQuery();
			boolean odometer = false;
			while(rs.next()){
				parameterValue = "NA";
				String value = "NA";
				String icon = "icon-grey";
				String field = "";
				String unit = "";
				double pValue=0.0;
				obj = new JSONObject();
				String paramterName= rs.getString("PARAMETER_NAME");
				String columnName = "isnull("+rs.getString("fieldLabel")+",'')";
				String statement = "select "+columnName+" as value from dbo.GPSDATA_LIVE_CANIQ where System_id=? and CLIENTID=? and REGISTRATION_NO=? and LONGITUDE is not null and LATITUDE is not null";

				pstmt1 = con.prepareStatement(statement);
				pstmt1.setInt(1, systemId);
				pstmt1.setInt(2, clientId);
				pstmt1.setString(3, vehicleNo);
				 
				rs1 = pstmt1.executeQuery();
				if(rs1.next()){
					value = rs1.getString("value");
				}
				field = rs.getString("fieldLabel");
				if(field.equalsIgnoreCase("VEHICLE_SPEED")||field.equalsIgnoreCase("ODOMETER")||field.equalsIgnoreCase("DISTANCE_MIL")||field.equalsIgnoreCase("DISTANCE_SCC"))
				{	
					if(!value.isEmpty() && value!=null){
						if(!value.equalsIgnoreCase("NA"))
					pValue=Double.parseDouble(value)*convertionFactor;
					}
					value=value.valueOf(pValue);
				}
				if (field.equalsIgnoreCase("ODOMETER")){
					odometer = true;
				}
				if(!value.equals("")){
				unit = rs.getString("unit");
				pstmt2 = con.prepareStatement(OBDStatements.GET_VEHICLE_MAP_DETAILS);
				pstmt2.setInt(1, systemId);
				pstmt2.setInt(2, clientId);
				pstmt2.setString(3, rs.getString("parameterId"));
				rs2 = pstmt2.executeQuery();
				if(rs2.next()){
					switch (rs2.getInt("limitType")){
					case 1 : if(field.equals("BLINKER_LIGHT") || field.equals("CLUTCH") || field.equals("BRAKE_PEDAL") || field.equals("DOOR_LOCK") || field.equals("SEAT_BELT") ||
							 	field.equals("PARK_BRAKE") ||field.equals("GEAR") || field.equals("HEAD_LIGHT") || field.equals("CRUISE_CONTROL") || field.equals("AC") || field.equals("ACC_PEDAL_SWITCH")){
							 		if(value.equals("1")){
							 			parameterValue = "ON";
							 		}else{
							 			parameterValue = "OFF";
							 		}
							  }else if(field.equals("DOOR_P") || field.equals("DOOR")){
								  	if(value.equals("1")){
							 			parameterValue = "OPEN";
							 		}else{
							 			parameterValue = "CLOSE";
							 		}
							  }else if(field.equals("GEAR")){
								  	if(value.equals("0")){
							 			parameterValue = "NEUTRAL";
							 		}else if(value.equals("1")){
							 			parameterValue = "FORWARD";
							 		}else if(value.equals("2")){
							 			parameterValue = "REVERSE";
							 		}else{
							 			parameterValue = "BOOST";
							 		}
							  }else{
								 parameterValue = Dformatter.format(Double.parseDouble(value));
							  }
							  icon = "icon-green";
							  break;
							 
					case 2 : if(!value.equals("NA")){
							 	parameterValue = Dformatter.format(Double.parseDouble(value));
							 	if(Double.parseDouble(value) > rs2.getDouble("limitValue")){
							 		icon = "icon-red";
							 	}else{
							 		icon = "icon-green";
							 	}
							 }	
							 break;
							 
					case 3 : if(!value.equals("NA")){
							 	parameterValue = Dformatter.format(Double.parseDouble(value));
							 	if(Double.parseDouble(value) < rs2.getDouble("limitValue")){
							 		icon = "icon-red";
							 	}else{
							 		icon = "icon-green";
							 	}
							 }	
					 		 break;
					 
					case 4 : if(!value.equals("NA")){
								parameterValue = value;
								String[] range = parameterValue.split("-");
								String minvalue = range[0];
								String maxValue = range[1];
								if(Double.parseDouble(value) > Double.parseDouble(minvalue) && Double.parseDouble(value) < Double.parseDouble(maxValue)){
									icon = "icon-red";
								}else{
									icon = "icon-green";
								}
							 }	
							 break;
							 
					case 5: if(!value.equals("NA")){
								if(Double.parseDouble(value) == 0){
									parameterValue = "OFF";
								}else{
									parameterValue = "ON";
								}
								if(Double.parseDouble(value) == rs2.getDouble("limitValue")){
									icon = "icon-red";
								}else{
									icon = "icon-green";
								}
							}
							break;
							
					case 6: if(!value.equals("NA")){
								if(Double.parseDouble(value) == 0){
									parameterValue = "CLOSE";
								}else{
									parameterValue = "ON";
								}
								if(Double.parseDouble(value) == rs2.getDouble("limitValue")){
									icon = "icon-red";
								}else{
										icon = "icon-green";
								}
							}
							break;
					
					default : parameterValue = "NA";		
							  icon = "icon-grey";
					}
				}else{
					if(field.equals("BLINKER_LIGHT") || field.equals("CLUTCH") || field.equals("BRAKE_PEDAL") || field.equals("DOOR_LOCK") || field.equals("SEAT_BELT") ||
						 	field.equals("PARK_BRAKE") || field.equals("HEAD_LIGHT") || field.equals("CRUISE_CONTROL") || field.equals("AC") || field.equals("ACC_PEDAL_SWITCH")){
						 		if(value.equals("1")){
						 			parameterValue = "ON";
						 		}else{
						 			parameterValue = "OFF";
						 		}
					}else if(field.equals("DOOR_P") || field.equals("DOOR")){
						if(value.equals("1")){
							parameterValue = "OPEN";
						}else{
							parameterValue = "CLOSE";
						}
					}else if(field.equals("GEAR")){
					  	if(value.equals("0")){
				 			parameterValue = "NEUTRAL";
				 		}else if(value.equals("1")){
				 			parameterValue = "FORWARD";
				 		}else if(value.equals("2")){
				 			parameterValue = "REVERSE";
				 		}else{
				 			parameterValue = "BOOST";
				 		}
					}else{
						if(parameterValue.contains("NA") || parameterValue.equals("")){
							parameterValue = value;
						}else{
							parameterValue = Dformatter.format(value);
						}
					}
					icon = "icon-green";	
				}
				if(field.equals("SPEED") || field.equals("VEHICLE_SPEED")){
					field = "SPEED";
				}
				}
				
				if(parameterValue.matches(regex))  // checking and formating the value if it is decimal and value has not have a limit value
					parameterValue = String.format("%.2f",Double.parseDouble(parameterValue));
				
				
				
				obj.put("id", field);
				if(unit.equals("") || parameterValue.equals("NA")){
					obj.put("value", parameterValue);
				}else{
					obj.put("value", parameterValue+" "+unit);
				}
				obj.put("color", icon);
				obj.put("paramName", paramterName);
				jArr.put(obj);
			}
			
			if ((odometer == false)){
				DBConnection.releaseConnectionToDB(null, pstmt1, rs1);
				String value = "";
				String statementOdometer = "SELECT ODOMETER FROM AMS.dbo.gpsdata_history_latest where System_id=? and CLIENTID=? and REGISTRATION_NO=? and LONGITUDE is not null and LATITUDE is not null";
				 pstmt1 = con.prepareStatement(statementOdometer);
				 pstmt1.setInt(1, systemId);
				 pstmt1.setInt(2, clientId);
				 pstmt1.setString(3, vehicleNo);
				 rs1 = pstmt1.executeQuery();
				 if (rs1.next()){
					 value = rs1.getString("ODOMETER");
				 }
				obj = new JSONObject();
				obj.put("id", "ODOMETER");
				obj.put("value", value+" kms");
				obj.put("color", "icon-green");
				obj.put("paramName", "GPS-ODOMETER *");
				if (jArr.length() > 0){  /// GPS Odometer should show only when  OBD Odometer is not defined as param and at least one param is defined for given vehicle number and vehicle model
					jArr.put(obj);
				}
				
			}
			
		}catch(Exception e){
			
			e.printStackTrace();
		}finally{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
			DBConnection.releaseConnectionToDB(null, pstmt1, rs1);
			DBConnection.releaseConnectionToDB(null, pstmt2, rs2);
		}
		return jArr;
	}

	public synchronized JSONArray getErrorDeatails(int systemId, int clientId,String vehicleNo, int offset) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		JSONArray jArr = new JSONArray();
		JSONObject obj = null;
		int count = 0;
		try{
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(OBDStatements.GET_ERROR_CODES);
			pstmt.setInt(1, offset);
			pstmt.setString(2, vehicleNo);
			pstmt.setInt(3, systemId);
			pstmt.setInt(4, clientId);
			rs = pstmt.executeQuery();
			while(rs.next()){
				obj = new JSONObject();
				obj.put("slNoIndex", ++count);
				obj.put("codeIndex", rs.getString("codeId"));
				obj.put("descIndex", rs.getString("codeDesc"));
				obj.put("codegeneratedIndex", ddmmyyyy.format(yyyymmdd.parseObject(rs.getString("codeDateTime"))));
				obj.put("remarksIndex", rs.getString("remarks"));
				jArr.put(obj);
			}
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jArr;
	}

	public JSONArray getFuelLevelDetails(int systemId, int clientId) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		JSONArray jArr = new JSONArray();
		JSONArray FArr = new JSONArray();
		try{
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement("select top 10 isnull(UNIT_MODE,'') as level,isnull(dateadd(mi,330,GMT),'') as date from dbo.HISTORY_DATA_201 where CLIENTID=3355 and REGISTRATION_NO='KA01AF7956' and GPS_DATETIME > getdate()-5 order by GMT desc");
			rs = pstmt.executeQuery();
			while(rs.next()){
				jArr = new JSONArray();
				jArr.put(ddmmyyyy.format(yyyymmdd.parse(rs.getString("date"))));
				jArr.put(rs.getString("level"));
				FArr.put(jArr);
			}
			
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return FArr;
	}

	public JSONArray getParameterConfigDetails(int systemId, int clientId, String vehicleModel) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		JSONArray jArr = new JSONArray();
		JSONObject obj = null;
		int count = 0;
		double convertionFactor= cf.getUnitOfMeasureConvertionsfactor(systemId);
		try{
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(OBDStatements.GET_PARAMETER_CONFIG_DETAILS);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, clientId);
			pstmt.setInt(3, Integer.parseInt(vehicleModel));
			rs = pstmt.executeQuery();
			while(rs.next()){
				obj = new JSONObject();
				obj.put("slNoIndex", ++count);
				obj.put("UIDDI", rs.getInt("UID"));
				obj.put("parameterNameDI", rs.getString("parameterName"));
				obj.put("parameterIdDI", rs.getInt("parameterId"));
				obj.put("unitDI", rs.getString("unit"));
				obj.put("parameterLimitTypeDI", rs.getString("limitType"));
				String limitValue = rs.getString("limitValue");
				
				
				if(rs.getString("limitTypeId").equals("5")) {
					if(rs.getString("limitValue").equals("1")){
						limitValue = "ON";
					}else{
						limitValue = "OFF";
					}
					obj.put("limitValueDI", limitValue);
				}else if(rs.getString("limitTypeId").equals("6")) {
					if(rs.getString("limitValue").equals("1")){
						limitValue = "OPEN";
					}else{
						limitValue = "CLOSE";
					}
					obj.put("limitValueDI", limitValue);
				}
				else if(rs.getString("limitTypeId").equals("4"))
				{
					
					String var=obj.getString("limitValueDI");
					String var1[]=var.split("-");
					
					Double f=Math.floor(Double.parseDouble(var1[0]) * convertionFactor);
					Double s=Math.floor(Double.parseDouble(var1[1]) * convertionFactor);
					
					String limVal= f+"-"+s;
					obj.put("limitValueDI", limVal);
				}
				else if(!limitValue.equals(""))
				{
					obj.put("limitValueDI", Math.floor(Double.parseDouble(limitValue) * convertionFactor));
				}
				else 
				{
					obj.put("limitValueDI", "");
				}
				jArr.put(obj);
			}
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jArr;
	}
	public JSONArray getVehicleMake(int systemId, int clientId) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		JSONArray jArr = new JSONArray();
		JSONObject obj = null;
		try{
			con = DBConnection.getConnectionToDB("FMS");
			pstmt = con.prepareStatement(OBDStatements.GET_VEHICLE_MAKE);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, clientId);
			rs = pstmt.executeQuery();
			while(rs.next()){
				obj = new JSONObject();
				obj.put("vehicleMakeName", rs.getString("vehicleMake"));
				jArr.put(obj);
			}
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jArr;
	}
	public JSONArray getVehicleModel(int systemId, int clientId, String vehicleMake) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		JSONArray jArr = new JSONArray();
		JSONObject obj = null;
		try{
			con = DBConnection.getConnectionToDB("FMS");
			pstmt = con.prepareStatement(OBDStatements.GET_VEHICLE_MODEL);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, clientId);
			pstmt.setString(3, vehicleMake);
			rs = pstmt.executeQuery();
			while(rs.next()){
				obj = new JSONObject();
				obj.put("modelId", rs.getInt("id"));
				obj.put("modelName", rs.getString("vehicleModel"));
				jArr.put(obj);
			}
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jArr;
	}
	public JSONArray getLimitType() {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		JSONArray jArr = new JSONArray();
		JSONObject obj = null;
		try{
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(OBDStatements.GET_LIMT_TYPE);
			pstmt.setString(1, "OBD_LIMIT_TYPES");
			rs = pstmt.executeQuery();
			while(rs.next()){
				obj = new JSONObject();
				obj.put("typeId", rs.getInt("type"));
				obj.put("typeName", rs.getString("value"));
				jArr.put(obj);
			}
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jArr;
	}
	public String saveParameterSetting(int systemId, int clientId, String json,	String vehicleModel, int userId) {
		Connection con = null;
		PreparedStatement pstmt = null;
		JSONObject obj = null;
		String message = "";
		String st = "["+json+"]";
		JSONArray js = null;
		int inserted = 0;
		double convertionFactor= cf.getUnitOfMeasureConvertionsfactor(systemId);
		//double convertionFactor= 0.62137;
		try{
			js = new JSONArray(st.toString());
			
			con = DBConnection.getConnectionToDB("AMS");
			//move previous record to history
			pstmt = con.prepareStatement(OBDStatements.MOVE_TO_PARAMETER_SETTING_HISTORY);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, clientId);
			pstmt.setInt(3, Integer.parseInt(vehicleModel));
			pstmt.executeUpdate();
			
			// Remove previous details wrt Vehicle Model 
			pstmt = con.prepareStatement(OBDStatements.DELETE_PARAMETER_SETTING);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, clientId);
			pstmt.setInt(3, Integer.parseInt(vehicleModel));
			pstmt.executeUpdate();
			
			//insert new set of details
			for(int i= 0; i<js.length(); i++){
				obj = js.getJSONObject(i);
				pstmt = con.prepareStatement(OBDStatements.SAVE_PARAMETER_SETTING);
				pstmt.setInt(1, systemId);
				pstmt.setInt(2, clientId);
				pstmt.setInt(3, obj.getInt("parameterIdDI"));
				pstmt.setString(4, obj.getString("unitDI"));
				pstmt.setInt(5, obj.getInt("parameterLimitTypeDI"));
				String limitValue = obj.getString("limitValueDI");
				if(obj.getInt("parameterLimitTypeDI") == 5 || obj.getInt("parameterLimitTypeDI") == 6) {
					if(obj.getString("limitValueDI").toUpperCase().trim().equals("ON") || obj.getString("limitValueDI").toUpperCase().trim().equals("OPEN")){
						limitValue = "1";
					}else{
						limitValue = "0";
					}
					pstmt.setString(6, limitValue);
				}
				else if(obj.getInt("parameterLimitTypeDI") == 4)
				{
					String var=obj.getString("limitValueDI");
					String var1[]=var.split("-");
					
					int f=(int)Math.ceil(Integer.parseInt(var1[0]) / convertionFactor);
					int s=(int)Math.ceil(Integer.parseInt(var1[1]) / convertionFactor);
					limitValue= f+"-"+s;
					pstmt.setString(6, limitValue);
				}
				else
				{
					Integer limitVal=(int)(Math.ceil(Integer.parseInt(limitValue) / convertionFactor));
					pstmt.setString(6, limitVal.toString());
				}
				
				pstmt.setInt(7, Integer.parseInt(vehicleModel));
				pstmt.setInt(8, userId);
				inserted = pstmt.executeUpdate();
			}
			if(inserted > 0){
				message = "Paratemer details inserted successfully";
			}else{
				message = "Error while inserting parameter details";
			}
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			DBConnection.releaseConnectionToDB(con, pstmt, null);
		}
		return message;
	}
	public ArrayList<Object> getErrorCodeReportDetails(int systemId, int clientId,	String startDate, String endDate, int offmin,int userId) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		JSONArray jArr = new JSONArray();
		JSONObject obj = null;
		int count = 0;
		ArrayList<String> headersList = new ArrayList<String>();
		ArrayList<Object> informationList = null;
		ReportHelper reportHelper = null;
		ArrayList<ReportHelper> reportsList = new ArrayList<ReportHelper>();
		ReportHelper finalreportHelper = new ReportHelper();
		ArrayList<Object> finalist = new ArrayList<Object>();
		try{
			headersList.add("SLNO");
			headersList.add("UID");
			headersList.add("Asset No");
			headersList.add("Error Code");
			headersList.add("Error Description");
			headersList.add("Date Time");
			headersList.add("Remarks");
			
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(OBDStatements.GET_ERROR_CODE_DETAILS);
			pstmt.setInt(1, offmin);
			pstmt.setInt(2, systemId);
			pstmt.setInt(3, clientId);
			pstmt.setInt(4, offmin);
			pstmt.setString(5, startDate.replace("T", " "));
			pstmt.setInt(6, offmin);
			pstmt.setString(7, endDate.replace("T", " "));
			pstmt.setInt(8, systemId);
			pstmt.setInt(9, userId);
			pstmt.setInt(10, offmin);
			pstmt.setInt(11, systemId);
			pstmt.setInt(12, clientId);
			pstmt.setInt(13, offmin);
			pstmt.setString(14, startDate.replace("T", " "));
			pstmt.setInt(15, offmin);
			pstmt.setString(16, endDate.replace("T", " "));
			pstmt.setInt(17, systemId);
			pstmt.setInt(18, userId);
			rs = pstmt.executeQuery();
			while(rs.next()){
				++count;
				obj = new JSONObject();
				informationList = new ArrayList<Object>();
				reportHelper = new ReportHelper();
				
				obj.put("slnoDataIndex", count);
				informationList.add(count);
				obj.put("UIDDI", rs.getInt("UID"));
				informationList.add(rs.getInt("UID"));
				obj.put("vehicleNoDI", rs.getString("vehicleNo"));
				informationList.add(rs.getString("vehicleNo"));
				obj.put("errorCodeDI", rs.getString("errorCode"));
				informationList.add(rs.getString("errorCode"));
				obj.put("errorDescDI", rs.getString("errorDesc"));
				informationList.add(rs.getString("errorDesc"));
				if(rs.getString("dateTime").contains("1900")){
					obj.put("dateTimeDI", "");
					informationList.add("");
				}else{
					obj.put("dateTimeDI", ddmmyyyy.format(yyyymmdd.parseObject(rs.getString("dateTime"))));
					informationList.add(ddmmyyyy.format(yyyymmdd.parseObject(rs.getString("dateTime"))));
				}
				obj.put("remarksDI", rs.getString("remarks"));
				informationList.add(rs.getString("remarks"));
				
				jArr.put(obj);
				reportHelper.setInformationList(informationList);
				reportsList.add(reportHelper);
			}
			finalreportHelper.setHeadersList(headersList);
			finalreportHelper.setReportsList(reportsList);
			
			finalist.add(jArr);
			finalist.add(finalreportHelper);
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return finalist;
	}
	
	public JSONArray getOBDAssetNumberList(int systemId,int customerId, int userId) {
		PreparedStatement pstmt = null;
		Connection con = null;
		ResultSet rs = null;
		JSONArray jsonArray = new JSONArray();
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(OBDStatements.Get_OBD_ASSET_NUMBER_LIST);
			pstmt.setInt(1,userId);
			pstmt.setInt(2,systemId);
			pstmt.setInt(3,customerId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				JSONObject jsonObject = new JSONObject();
				jsonObject.put("Registration_no", rs.getString("ASSET_NUMBER"));
				jsonArray.put(jsonObject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jsonArray;
	}


	public ArrayList<Object> OBDFuelReport(int parseInt, int systemId, int offmin, String startDate, String endDate,String vehNo) {
		PreparedStatement pstmt = null;
		Connection con = null;
		ResultSet rs = null;
		JSONArray jsonArray = new JSONArray();
		String date="";
		int count=-1;
		ArrayList<String> headersList = new ArrayList<String>();
		ArrayList<Object> informationList = null;
		ReportHelper reportHelper = null;
		ArrayList<ReportHelper> reportsList = new ArrayList<ReportHelper>();
		ReportHelper finalreportHelper = new ReportHelper();
		ArrayList<Object> finalist = new ArrayList<Object>();
		try {
			headersList.add("SL No");
			headersList.add("Asset No");
			headersList.add("Distance (Kms)");
			headersList.add("Fuel");
			headersList.add("Date");
			
			con = DBConnection.getConnectionToDB("AMS");
			String query="select isNull(ODOMETER,0) as ODOMETER,isNull(FUEL_QTY,0) as FUEL_QTY,dateadd(mi,?,GMT) as Date from CANIQ_HISTORY_"+systemId+ 
					" where REGISTRATION_NO=? and GMT between dateadd(mi,-?,?) and dateadd(mi,-?,?) " +
					"UNION " +
					"select isNull(ODOMETER,0) as ODOMETER,isNull(FUEL_QTY,0) as FUEL_QTY,dateadd(mi,?,GMT) as Date from AMS_Archieve.dbo.GE_CANIQ_" +systemId+
					" where REGISTRATION_NO=? and GMT between dateadd(mi,-?,?) and dateadd(mi,-?,?) order by Date asc";
			pstmt = con.prepareStatement(query);
			pstmt.setInt(1,offmin);
			pstmt.setString(2,vehNo);
			pstmt.setInt(3,offmin);
			pstmt.setString(4,startDate.replaceAll("T", " "));
			pstmt.setInt(5,offmin);
			pstmt.setString(6,endDate.replaceAll("T", " "));
			pstmt.setInt(7,offmin);
			pstmt.setString(8,vehNo);
			pstmt.setInt(9,offmin);
			pstmt.setString(10,startDate.replaceAll("T", " "));
			pstmt.setInt(11,offmin);
			pstmt.setString(12,endDate.replaceAll("T", " "));
			
			float distance=0,fuelQty=0;
			float odo1=0,fuel1=0,odo2=0,fuel2=0;
			rs = pstmt.executeQuery();
			if(rs.next()){
				count=0;
				odo1=rs.getFloat("ODOMETER");
				fuel1=rs.getFloat("FUEL_QTY");
				date=rs.getString("Date").substring(0,rs.getString("Date").indexOf(" "));
			}
			while (rs.next()) {
				odo2=rs.getFloat("ODOMETER");
				fuel2=rs.getFloat("FUEL_QTY");
				if(!date.equals(rs.getString("Date").substring(0,rs.getString("Date").indexOf(" ")))){
					JSONObject jsonObject = new JSONObject();
					informationList = new ArrayList<Object>();
					reportHelper = new ReportHelper();
					
					count++;
					jsonObject.put("slnoIndex", count);
					informationList.add(count);
					jsonObject.put("registrationNoDataIndex", vehNo);
					informationList.add(vehNo);
					jsonObject.put("distanceDataIndex", Dformatter.format(distance));
					informationList.add(distance);
					jsonObject.put("fuelDataIndex", fuelQty);
					informationList.add(fuelQty);
					jsonObject.put("fuelDateDataIndex", date);
					informationList.add(date);
					
					jsonArray.put(jsonObject);
					reportHelper.setInformationList(informationList);
					reportsList.add(reportHelper);
					
					finalreportHelper.setHeadersList(headersList);
					finalreportHelper.setReportsList(reportsList);
					finalist.add(jsonArray);
					finalist.add(finalreportHelper);
					
					distance=0;
					fuelQty=0;
					date=rs.getString("Date").substring(0,rs.getString("Date").indexOf(" "));
					odo1=odo2;
					continue;
				}
				if(odo2>odo1){
					if(odo1!=0 && odo2!=0)
					distance+=odo2-odo1;
				}
				if(fuel2<fuel1){
					fuelQty+=(fuel1-fuel2);
				}else {
					if(fuel2-fuel1<=4){
						odo1=odo2;
						continue;
					}
				}
				odo1=odo2;
				fuel1=fuel2;
			}
			JSONObject jsonObject = new JSONObject();
			informationList = new ArrayList<Object>();
			reportHelper = new ReportHelper();
			if(count>=0){
				count++;
				jsonObject.put("slnoIndex", count);
				informationList.add(count);
				jsonObject.put("registrationNoDataIndex", vehNo);
				informationList.add(vehNo);
				jsonObject.put("distanceDataIndex", Dformatter.format(distance));
				informationList.add(distance);
				jsonObject.put("fuelDataIndex", fuelQty);
				informationList.add(fuelQty);
				jsonObject.put("fuelDateDataIndex", date);
				informationList.add(date);
				
				jsonArray.put(jsonObject);
				reportHelper.setInformationList(informationList);
				reportsList.add(reportHelper);
				
				finalreportHelper.setHeadersList(headersList);
				finalreportHelper.setReportsList(reportsList);
				finalist.add(jsonArray);
				finalist.add(finalreportHelper);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return finalist;
	}
	
	public JSONArray getCountofDTCAlerts(int systemId, int clientId, int userId ,String vehicle) {
		// TODO Auto-generated method stub
		 Connection conAMS = null;
	     PreparedStatement pstmt = null;
	     ResultSet rs = null;
	     JSONArray jsonArray = new JSONArray();
	     JSONObject jsonObject = new JSONObject();
	     String Qeury1 =null;
	     String Qeury2 =null;
	     String Qeury3 =null;
	     String Qeury4 =null;
	     String Qeury5 =null;
	     String Qeury6 =null;
	     String Qeury7 =null;
	     String Qeury8 =null;
	     String Qeury9 =null;
	     String Qeury10=null;
	     
	     try {
	     
	     
	     if (vehicle.equals(""))
	     {
	    	 
	    	
	    	 Qeury1 = OBDStatements.GET_COUNT_OF_DTC_ERROR_OF_POWER.replaceAll("#", " ");
	    	 Qeury2 = OBDStatements.GET_COUNT_OF_DTC_ERROR_OF_BODY.replaceAll("#", " ");
	    	 Qeury3 = OBDStatements.GET_COUNT_OF_DTC_ERROR_OF_CHASSIS.replaceAll("#", " ");
	    	 Qeury4 = OBDStatements.GET_COUNT_OF_DTC_ERROR_OF_NETWORK.replaceAll("#", " ");
	    	
	    	 Qeury5 = OBDStatements.GET_NON_COMMUNICATING_NEW.replaceAll("#", " ");
	    	 Qeury6 = OBDStatements.GET_NON_COMMUNICATING_LESS.replaceAll("#", " ");
	    	 
	    	 Qeury7 =OBDStatements.GET_COUNT_MAIN_BATTERY_LOW.replaceAll("#", " ");
	    	 Qeury8 =OBDStatements.GET_COUNT_OF_ALERTS_CROSS_BOR_TAMP.replaceAll("#", " ");
	    	 Qeury9 =OBDStatements.GET_COUNT_OF_ALERTS_MAJOR_OBD.replaceAll("#", " ");
	    	 
	     }
	     else {
	    	 Qeury1 = OBDStatements.GET_COUNT_OF_DTC_ERROR_OF_POWER.replaceAll("#", " and REGISTRATION_NO='"+vehicle+"' ");
	    	 Qeury2 = OBDStatements.GET_COUNT_OF_DTC_ERROR_OF_BODY.replaceAll("#", " and REGISTRATION_NO='"+vehicle+"' ");
	    	 Qeury3 = OBDStatements.GET_COUNT_OF_DTC_ERROR_OF_CHASSIS.replaceAll("#", " and REGISTRATION_NO='"+vehicle+"' ");
	    	 Qeury4 = OBDStatements.GET_COUNT_OF_DTC_ERROR_OF_NETWORK.replaceAll("#", " and REGISTRATION_NO='"+vehicle+"' ");
	    	
	    	 Qeury5 =OBDStatements.GET_NON_COMMUNICATING_NEW.replaceAll("#", " REGISTRATION_NO='"+vehicle+"' and ");
	    	 Qeury6 =OBDStatements.GET_NON_COMMUNICATING_LESS.replaceAll("#", " REGISTRATION_NO='"+vehicle+"' and ");
	    	 
	    	 Qeury7 =OBDStatements.GET_COUNT_MAIN_BATTERY_LOW.replaceAll("#", " and REGISTRATION_NO='"+vehicle+"' ");
	    	 Qeury8 =OBDStatements.GET_COUNT_OF_ALERTS_CROSS_BOR_TAMP.replaceAll("#", " and REGISTRATION_NO='"+vehicle+"' ");
	    	 Qeury9 = OBDStatements.GET_COUNT_OF_ALERTS_MAJOR_OBD.replaceAll("#", " and REGISTRATION_NO='"+vehicle+"' ");
	    	 
	     }
	     
	     	Qeury10 = OBDStatements.GET_COUNT_OF_ALL_OBD_ASSETS;
			 
	   
	    	 conAMS = DBConnection.getConnectionToDB("AMS");
	    	 pstmt = conAMS.prepareStatement(Qeury1);
	    	 pstmt.setInt(1, systemId);
	    	 pstmt.setInt(2, clientId);
	    	 pstmt.setInt(3, userId);
	    	
	    	 rs = pstmt.executeQuery();
	    	 int countPow=0;
	    	 while(rs.next()){
	    		 /*jsonObject.put("poweer", rs.getString("Poweer"));
	    		 jsonObject.put("chasis", rs.getString("Chasis"));
	    		 jsonObject.put("body", rs.getString("Body"));
	    		 jsonObject.put("network", rs.getString("Network"));*/
	    		 
	    		 countPow++;
	    		 
	    	 }
	    	 jsonObject.put("poweer",countPow);
	    	 
	    	 pstmt.close();
	    	 rs.close();
	    	 
	    	 
	    	 pstmt = conAMS.prepareStatement(Qeury2);
	    	 pstmt.setInt(1, systemId);
	    	 pstmt.setInt(2, clientId);
	    	 pstmt.setInt(3, userId);
	    	 rs = pstmt.executeQuery();
	    	 int countBod=0;
	    	 while(rs.next()){
	    		 /*jsonObject.put("poweer", rs.getString("Poweer"));
	    		 jsonObject.put("chasis", rs.getString("Chasis"));
	    		 jsonObject.put("body", rs.getString("Body"));
	    		 jsonObject.put("network", rs.getString("Network"));*/
	    		 
	    		 countBod++;
	    		 
	    	 }
	    	 jsonObject.put("body",countBod);
	    	 
	    	 pstmt.close();
	    	 rs.close();
	    	 
	    	 
	    	 pstmt = conAMS.prepareStatement(Qeury3);
	    	 pstmt.setInt(1, systemId);
	    	 pstmt.setInt(2, clientId);
	    	 pstmt.setInt(3, userId);
	    	 rs = pstmt.executeQuery();
	    	 int countCha=0;
	    	 while(rs.next()){
	    		 /*jsonObject.put("poweer", rs.getString("Poweer"));
	    		 jsonObject.put("chasis", rs.getString("Chasis"));
	    		 jsonObject.put("body", rs.getString("Body"));
	    		 jsonObject.put("network", rs.getString("Network"));*/
	    		 
	    		 countCha++;
	    		 
	    	 }
	    	 jsonObject.put("chasis",countCha);
	    	 
	    	 pstmt.close();
	    	 rs.close();
	    	 
	    	 pstmt = conAMS.prepareStatement(Qeury4);
	    	 pstmt.setInt(1, systemId);
	    	 pstmt.setInt(2, clientId);
	    	 pstmt.setInt(3, userId);
	    	 rs = pstmt.executeQuery();
	    	 int countNet=0;
	    	 while(rs.next()){
	    		 /*jsonObject.put("poweer", rs.getString("Poweer"));
	    		 jsonObject.put("chasis", rs.getString("Chasis"));
	    		 jsonObject.put("body", rs.getString("Body"));
	    		 jsonObject.put("network", rs.getString("Network"));*/
	    		 
	    		 countNet++;
	    		 
	    	 }
	    	 jsonObject.put("network",countNet);
	    	 pstmt.close();
	    	 rs.close();
	    	 
	    	 
	    	 pstmt = conAMS.prepareStatement(Qeury5);
	    	 pstmt.setInt(1, systemId);
	    	 pstmt.setInt(2, clientId);
	    	 pstmt.setInt(3, userId);
	    	 rs = pstmt.executeQuery();
	    	 if(rs.next()){
	    		 jsonObject.put("nonCom", rs.getString("NON_COMMUNICATING"));
	    		 
	    	 } 
	    	 pstmt.close();
	    	 rs.close();
	    	 
	    	 pstmt = conAMS.prepareStatement(Qeury6);
	    	 pstmt.setInt(1, systemId);
	    	 pstmt.setInt(2, clientId);
	    	 pstmt.setInt(3, userId);
	    	 rs = pstmt.executeQuery();
	    	 if(rs.next()){
	    		 jsonObject.put("nonComLs", rs.getString("NON_COMMUNICATING_LS"));
	    		 
	    	 } 
	    	 pstmt.close();
	    	 rs.close();
	    	 
	    	 
	    	 pstmt = conAMS.prepareStatement(Qeury7);
	    	 pstmt.setInt(1, systemId);
	    	 pstmt.setInt(2, clientId);
	    	 pstmt.setInt(3, userId);
	    	 rs = pstmt.executeQuery();
	    	 if(rs.next()){
	    		 jsonObject.put("lowBatteryBackup", rs.getString("cnt"));
	    		 
	    	 } 
	    	 pstmt.close();
	    	 rs.close();
	    	 
	    	 pstmt = conAMS.prepareStatement(Qeury8);
		    	
	    	 pstmt.setInt(1, systemId);
	    	 pstmt.setInt(2, clientId);
	    	 pstmt.setInt(3, userId);
	    	 
	    	 int t=0;
	    	 int r=0;
	    	 int s=0;
	    	 
	    	 String gpsTamp="0";
	    	 rs = pstmt.executeQuery();
	    	 while(rs.next()){
	    		 if(rs.getInt("TYPE_OF_ALERT")==145)
	    			 t= rs.getInt("cnt");
	    		 if(rs.getInt("TYPE_OF_ALERT")==148)
	    			 r= rs.getInt("cnt");
	    		 if(rs.getInt("TYPE_OF_ALERT")==84)
	    			 s= rs.getInt("cnt");
	    	 }
	    	 
	    	 jsonObject.put("gpsTamp",t);
	    		
			 jsonObject.put("gpsTampAndCross", r);
		 
			 jsonObject.put("crossBord",s);
	    	 
	    	 pstmt.close();
	    	 rs.close();
	    	 
	    	 
	    	 pstmt = conAMS.prepareStatement(Qeury9);
	    	
	    	 pstmt.setInt(1, systemId);
	    	 pstmt.setInt(2, clientId);
	    	 pstmt.setInt(3, userId);
	    	 int a=0;
	    	 int b=0;
	    	 int c=0;
	    	 int d=0;
	    	 rs = pstmt.executeQuery();
	    	 while(rs.next()){
	    		 
	    		 if(rs.getInt("TYPE_OF_ALERT")==159)
	    			 a= rs.getInt("cnt");
	    		 if(rs.getInt("TYPE_OF_ALERT")==172)
	    			 b= rs.getInt("cnt");
	    		 if(rs.getInt("TYPE_OF_ALERT")==175)
	    			c= rs.getInt("cnt");
	    		 if(rs.getInt("TYPE_OF_ALERT")==167)
	    			 d=rs.getInt("cnt");
	    		
	    	 } 
	    	 
	    	
    			 jsonObject.put("coolantTemp",a);
    		
    			 jsonObject.put("parkBrake", b);
    		 
    			 jsonObject.put("towing",c);
    		
    			 jsonObject.put("lowFuelQty",d);
	    	 pstmt.close();
	    	 rs.close();
	    	 
	    	 
	    	 pstmt = conAMS.prepareStatement(Qeury10);
	    	 pstmt.setInt(1, systemId);
	    	 pstmt.setInt(2, clientId);
	    	 pstmt.setInt(3, userId);
	    	 rs = pstmt.executeQuery();
	    	 if(rs.next()){
	    		 jsonObject.put("allVehCount", rs.getString("ALL_ASSET"));
	    		 
	    	 } 
	    	 pstmt.close();
	    	 rs.close();
	    	 
	    	 
	    	 jsonArray.put(jsonObject);
	    	 
	     }catch (Exception e) {
	       	 e.printStackTrace();
	        } finally {
	            DBConnection.releaseConnectionToDB(conAMS, pstmt, rs);
	        }
		
		return jsonArray;
	     
	}


	public JSONArray getShowDataInPopUp(int systemId, int clientId , String popId, int userId, String regisNo) {
		// TODO Auto-generated method stub
		 Connection conAMS = null;
	     PreparedStatement pstmt = null;
	     ResultSet rs = null;
	     JSONArray jsonArray = new JSONArray();
	     JSONObject jsonObject = new JSONObject();
	     String Stas=null;
	     String Qeury1 =null;
	     String Qeury2 =null;
	     String Qeury3 =null;
	     String Qeury4 =null;
	     String Qeury5 =null;
	     String Qeury6 =null;
	     String Qeury7 =null;
	     String Qeury8 =null;
	     String Qeury9 =null;
	     String Qeury10 =null;
	     String Qeury11 =null;
	     String Qeury12 =null;
	     String Qeury13 =null;
	     String Qeury14 =null;
	     
	     
	     try {
	    	 if(regisNo.equals("")) {
	    		 Stas="0";
	    	 	
			    	 Qeury1 = OBDStatements.GET_LIST_OF_POWER_TRAIN_FINAL.replaceAll("#", " ");
		  	    	 Qeury2 = OBDStatements.GET_LIST_OF_POWER_BODY_FINAL.replaceAll("#", " ");
		  	    	 Qeury3 = OBDStatements.GET_LIST_OF_POWER_CHASSIS_FINAL.replaceAll("#", " ");
		  	    	 Qeury4 = OBDStatements.GET_LIST_OF_POWER_NETWORK_FINAL.replaceAll("#", " ");
		  	    	
		  	    	 Qeury5 = OBDStatements.GET_LIST_OF_NON_COMM.replaceAll("#", " ");
		  	    	 Qeury6 = OBDStatements.GET_LIST_OF_NON_COMM_LS.replaceAll("#", " ");
		  	    	 
		  	    	 Qeury7 =OBDStatements.GET_LIST_OF_COOL_QTY.replaceAll("#", " ");
		  	    	 Qeury8 =OBDStatements.GET_LIST_OF_TOWING.replaceAll("#", " ");
		  	    	 Qeury9 =OBDStatements.GET_LIST_OF_FUEL_QTY.replaceAll("#", " ");
		  	    	 Qeury10 = OBDStatements.GET_LIST_OF_PARK_BRAKE.replaceAll("#", " ");
		  	    	 Qeury11 = OBDStatements.GET_LIST_MAIN_BATTERY_LOW.replaceAll("#", " ");
		  	    	 Qeury12 = OBDStatements.GET_LIST_OF_CROSS_BORDER.replaceAll("#", " ");
		  	    	 Qeury13 = OBDStatements.GET_LIST_OF_GPS_TAMP.replaceAll("#", " ");
		  	    	 Qeury14 = OBDStatements.GET_LIST_OF_GPS_TAMP_AND_CROSS_BORD.replaceAll("#", " ");
	    	 }
	    	 else {
	    		 Stas="1";
	    		 
		    		 Qeury1 = OBDStatements.GET_LIST_OF_POWER_TRAIN_FINAL.replaceAll("#", " and REGISTRATION_NO='"+regisNo+"' ");
		  	    	 Qeury2 = OBDStatements.GET_LIST_OF_POWER_BODY_FINAL.replaceAll("#", " and REGISTRATION_NO='"+regisNo+"' ");
		  	    	 Qeury3 = OBDStatements.GET_LIST_OF_POWER_CHASSIS_FINAL.replaceAll("#", " and REGISTRATION_NO='"+regisNo+"' ");
		  	    	 Qeury4 = OBDStatements.GET_LIST_OF_POWER_NETWORK_FINAL.replaceAll("#", " and REGISTRATION_NO='"+regisNo+"' ");
		  	    	
		  	    	 Qeury5 =OBDStatements.GET_LIST_OF_NON_COMM.replaceAll("#", " REGISTRATION_NO='"+regisNo+"' and ");
		  	    	 Qeury6 =OBDStatements.GET_LIST_OF_NON_COMM_LS.replaceAll("#", " REGISTRATION_NO='"+regisNo+"' and ");
		  	    	 
		  	    	 Qeury7 =OBDStatements.GET_LIST_OF_COOL_QTY.replaceAll("#", " and REGISTRATION_NO='"+regisNo+"' ");
		  	    	 Qeury8 =OBDStatements.GET_LIST_OF_TOWING.replaceAll("#", " and REGISTRATION_NO='"+regisNo+"' ");
		  	    	 Qeury9 = OBDStatements.GET_LIST_OF_FUEL_QTY.replaceAll("#", " and REGISTRATION_NO='"+regisNo+"' ");
		  	    	 Qeury10 = OBDStatements.GET_LIST_OF_PARK_BRAKE.replaceAll("#", " and REGISTRATION_NO='"+regisNo+"' ");
		  	    	 Qeury11 = OBDStatements.GET_LIST_MAIN_BATTERY_LOW.replaceAll("#", " and REGISTRATION_NO='"+regisNo+"' ");
		  	    	 Qeury12 = OBDStatements.GET_LIST_OF_CROSS_BORDER.replaceAll("#", " and REGISTRATION_NO='"+regisNo+"' ");
		  	    	 Qeury13 = OBDStatements.GET_LIST_OF_GPS_TAMP.replaceAll("#", " and REGISTRATION_NO='"+regisNo+"' ");
		  	    	 Qeury14 = OBDStatements.GET_LIST_OF_GPS_TAMP_AND_CROSS_BORD.replaceAll("#", " and REGISTRATION_NO='"+regisNo+"' ");
		  	    	 
		  	    	
	    		 
	    	 }
	    	   
	    	 
	    	 if(popId.equals("powerId"))
	    	 {
	    	  conAMS = DBConnection.getConnectionToDB("AMS");
	    	  pstmt = conAMS.prepareStatement(Qeury1);
	    	  pstmt.setInt(1, systemId);
	    	  pstmt.setInt(2, clientId);
	    	  pstmt.setInt(3, userId);
	    	 
	            rs = pstmt.executeQuery();
	            while (rs.next()) {
	                jsonObject = new JSONObject();
	             //   jsonObject.put("slno", "");
	             //   jsonObject.put("registrationNo", rs.getString("REGISTRATION_NO"));
	                String regNo=rs.getString("REGISTRATION_NO");
	                jsonObject.put("registrationNo", "<a href='VehicleDiagnosticDashBoard.jsp?RegNo="+regNo+"&ParamId="+popId+"&Sts="+Stas+" '> "+regNo+"  </a>"  );
	                jsonObject.put("value", rs.getString("ERROR_CODE"));
	                jsonObject.put("gpsDateTime", rs.getString("GPS_DATETIME"));
	                jsonObject.put("location", rs.getString("ERROR_DESC"));
	                jsonArray.put(jsonObject);
	            }
	            pstmt.close();
		    	 rs.close();
	    	 }
	    	 
	    	 else if(popId.equals("bodyId"))
	    	 {
		    	  conAMS = DBConnection.getConnectionToDB("AMS");
		    	  pstmt = conAMS.prepareStatement(Qeury2);
		    	  pstmt.setInt(1, systemId);
		    	  pstmt.setInt(2, clientId);
		    	  pstmt.setInt(3, userId);
		    	  
		            rs = pstmt.executeQuery();
		            while (rs.next()) {
		                jsonObject = new JSONObject();
		               // jsonObject.put("registrationNo", rs.getString("REGISTRATION_NO"));
		                String regNo=rs.getString("REGISTRATION_NO");
		                jsonObject.put("registrationNo", "<a href='VehicleDiagnosticDashBoard.jsp?RegNo="+regNo+"&ParamId="+popId+"&Sts="+Stas+" '> "+regNo+"  </a>"  );
		                jsonObject.put("value", rs.getString("ERROR_CODE"));
		                jsonObject.put("gpsDateTime", rs.getString("GPS_DATETIME"));
		                jsonObject.put("location", rs.getString("ERROR_CODE"));
		                jsonArray.put(jsonObject);
		            }
		            pstmt.close();
			    	 rs.close();
	    	  }
	    	 
	    	 else if(popId.equals("chasisId"))
	    	 {
		    	  conAMS = DBConnection.getConnectionToDB("AMS");
		    	  pstmt = conAMS.prepareStatement(Qeury3);
		    	  pstmt.setInt(1, systemId);
		    	  pstmt.setInt(2, clientId);
		    	  pstmt.setInt(3, userId);
		    	
		            rs = pstmt.executeQuery();
		            while (rs.next()) {
		                jsonObject = new JSONObject();
		              //  jsonObject.put("registrationNo", rs.getString("REGISTRATION_NO"));
		                String regNo=rs.getString("REGISTRATION_NO");
		                jsonObject.put("registrationNo", "<a href='VehicleDiagnosticDashBoard.jsp?RegNo="+regNo+"&ParamId="+popId+"&Sts="+Stas+" '> "+regNo+"  </a>"  );
		                jsonObject.put("value", rs.getString("ERROR_CODE"));
		                jsonObject.put("gpsDateTime", rs.getString("GPS_DATETIME"));
		                jsonObject.put("location", rs.getString("ERROR_DESC"));
		                jsonArray.put(jsonObject);
		            }
		            pstmt.close();
			    	 rs.close();
	    	  }
	    	 
	    	 else if(popId.equals("networkId"))
	    	 {
	    		 int count=0;
		    	  conAMS = DBConnection.getConnectionToDB("AMS");
		    	  pstmt = conAMS.prepareStatement(Qeury4);
		    	  pstmt.setInt(1, systemId);
		    	  pstmt.setInt(2, clientId);
		    	  pstmt.setInt(3, userId);
		            rs = pstmt.executeQuery();
		            
		            while (rs.next()) {
		                jsonObject = new JSONObject();
		          //      jsonObject.put("slno", count++);
		           //     jsonObject.put("registrationNo", rs.getString("REGISTRATION_NO"));
		                String regNo=rs.getString("REGISTRATION_NO");
		                jsonObject.put("registrationNo", "<a href='VehicleDiagnosticDashBoard.jsp?RegNo="+regNo+"&ParamId="+popId+"&Sts="+Stas+" '> "+regNo+"  </a>"  );
		                jsonObject.put("value", rs.getString("ERROR_CODE"));
		                jsonObject.put("gpsDateTime", rs.getString("GPS_DATETIME"));
		                jsonObject.put("location", rs.getString("ERROR_DESC"));
		                jsonArray.put(jsonObject);
		            }
		            pstmt.close();
			    	 rs.close();
	    	  }
	    	 else if (popId.equals("nonCommId"))
	    	 {
	    		 conAMS = DBConnection.getConnectionToDB("AMS");
		    	  pstmt = conAMS.prepareStatement(Qeury5);
		    	  pstmt.setInt(1, systemId);
		    	  pstmt.setInt(2, clientId);
		    	  pstmt.setInt(3, userId);
		            rs = pstmt.executeQuery();
		            while (rs.next()) {
		                jsonObject = new JSONObject();
		           //     jsonObject.put("registrationNo", rs.getString("REGISTRATION_NO"));
		                String regNo=rs.getString("REGISTRATION_NO");
		                jsonObject.put("registrationNo", "<a href='VehicleDiagnosticDashBoard.jsp?RegNo="+regNo+"&ParamId="+popId+"&Sts="+Stas+" '> "+regNo+"  </a>"  );
		                jsonObject.put("value", rs.getString("VALUE"));
		                jsonObject.put("gpsDateTime", rs.getString("GPS_DATETIME"));
		                jsonObject.put("location", rs.getString("LOCATION"));
		                jsonArray.put(jsonObject);
		            }
		            pstmt.close();
			    	rs.close();
	    	 }
	    	 else if (popId.equals("nonCommLsId"))
	    	 {
	    		 conAMS = DBConnection.getConnectionToDB("AMS");
		    	  pstmt = conAMS.prepareStatement(Qeury6);
		    	  pstmt.setInt(1, systemId);
		    	  pstmt.setInt(2, clientId);
		    	  pstmt.setInt(3, userId);
		            rs = pstmt.executeQuery();
		            while (rs.next()) {
		                jsonObject = new JSONObject();
		            //    jsonObject.put("registrationNo", rs.getString("REGISTRATION_NO"));
		                String regNo=rs.getString("REGISTRATION_NO");
		                jsonObject.put("registrationNo", "<a href='VehicleDiagnosticDashBoard.jsp?RegNo="+regNo+"&ParamId="+popId+"&Sts="+Stas+" '> "+regNo+"  </a>"  );
		                jsonObject.put("value", rs.getString("VALUE"));
		                jsonObject.put("gpsDateTime", rs.getString("GPS_DATETIME"));
		                jsonObject.put("location", rs.getString("LOCATION"));
		                jsonArray.put(jsonObject);
		            }
		            pstmt.close();
			    	rs.close();
	    	 }
	    	 
	    	 else if(popId.equals("highCoolId"))
	    	 {
	    	  conAMS = DBConnection.getConnectionToDB("AMS");
	    	  pstmt = conAMS.prepareStatement(Qeury7);
	    	  pstmt.setInt(1, systemId);
	    	  pstmt.setInt(2, clientId);
	    	  pstmt.setInt(3, userId);
	            rs = pstmt.executeQuery();
	            while (rs.next()) {
	                jsonObject = new JSONObject();
	             //   jsonObject.put("registrationNo", rs.getString("REGISTRATION_NO"));
	                String regNo=rs.getString("REGISTRATION_NO");
	                jsonObject.put("registrationNo", "<a href='VehicleDiagnosticDashBoard.jsp?RegNo="+regNo+"&ParamId="+popId+"&Sts="+Stas+" '> "+regNo+"  </a>"  );
	                jsonObject.put("value", rs.getString("VALUE"));
	                jsonObject.put("gpsDateTime", rs.getString("GPS_DATETIME"));
	                jsonObject.put("location", rs.getString("LOCATION"));
	                jsonArray.put(jsonObject);
	            }
	            pstmt.close();
		    	rs.close();
	    	 }
	    	 else if (popId.equals("towingId"))
	    	 {
	    		 conAMS = DBConnection.getConnectionToDB("AMS");
		    	  pstmt = conAMS.prepareStatement(Qeury8);
		    	  pstmt.setInt(1, systemId);
		    	  pstmt.setInt(2, clientId);
		    	  pstmt.setInt(3, userId);
		            rs = pstmt.executeQuery();
		            while (rs.next()) {
		                jsonObject = new JSONObject();
		          //      jsonObject.put("registrationNo", rs.getString("REGISTRATION_NO"));
		                String regNo=rs.getString("REGISTRATION_NO");
		                jsonObject.put("registrationNo", "<a href='VehicleDiagnosticDashBoard.jsp?RegNo="+regNo+"&ParamId="+popId+"&Sts="+Stas+" '> "+regNo+"  </a>"  );
		                jsonObject.put("value", rs.getString("VALUE"));
		                jsonObject.put("gpsDateTime", rs.getString("GPS_DATETIME"));
		                jsonObject.put("location", rs.getString("LOCATION"));
		                jsonArray.put(jsonObject);
		            }
		            pstmt.close();
			    	rs.close();
	    	 }
	    	 else if (popId.equals("lowFuelId"))
	    	 {
	    		 conAMS = DBConnection.getConnectionToDB("AMS");
		    	  pstmt = conAMS.prepareStatement(Qeury9);
		    	  pstmt.setInt(1, systemId);
		    	  pstmt.setInt(2, clientId);
		    	  pstmt.setInt(3, userId);
		            rs = pstmt.executeQuery();
		            while (rs.next()) {
		                jsonObject = new JSONObject();
		          //      jsonObject.put("registrationNo", rs.getString("REGISTRATION_NO"));
		                String regNo=rs.getString("REGISTRATION_NO");
		                jsonObject.put("registrationNo", "<a href='VehicleDiagnosticDashBoard.jsp?RegNo="+regNo+"&ParamId="+popId+"&Sts="+Stas+" '> "+regNo+"  </a>"  );
		                jsonObject.put("value", rs.getString("VALUE"));
		                jsonObject.put("gpsDateTime", rs.getString("GPS_DATETIME"));
		                jsonObject.put("location", rs.getString("LOCATION"));
		                jsonArray.put(jsonObject);
		            }
		            pstmt.close();
			    	rs.close();
	    	 }
	    	 else if (popId.equals("prakeBrakeId"))
	    	 {
	    		 conAMS = DBConnection.getConnectionToDB("AMS");
		    	  pstmt = conAMS.prepareStatement(Qeury10);
		    	  pstmt.setInt(1, systemId);
		    	  pstmt.setInt(2, clientId);
		    	  pstmt.setInt(3, userId);
		            rs = pstmt.executeQuery();
		            while (rs.next()) {
		                jsonObject = new JSONObject();
		            //    jsonObject.put("registrationNo", rs.getString("REGISTRATION_NO"));
		                String regNo=rs.getString("REGISTRATION_NO");
		                jsonObject.put("registrationNo", "<a href='VehicleDiagnosticDashBoard.jsp?RegNo="+regNo+"&ParamId="+popId+"&Sts="+Stas+" '> "+regNo+"  </a>"  );
		                jsonObject.put("value", rs.getString("VALUE"));
		                jsonObject.put("gpsDateTime", rs.getString("GPS_DATETIME"));
		                jsonObject.put("location", rs.getString("LOCATION"));
		                jsonArray.put(jsonObject);
		            }
		            pstmt.close();
			    	rs.close();
	    	 }else if (popId.equals("lowBattId"))
	    	 {
	    		 conAMS = DBConnection.getConnectionToDB("AMS");
		    	  pstmt = conAMS.prepareStatement(Qeury11);
		    	  pstmt.setInt(1, systemId);
		    	  pstmt.setInt(2, clientId);
		    	  pstmt.setInt(3, userId);
		            rs = pstmt.executeQuery();
		            while (rs.next()) {
		                jsonObject = new JSONObject();
		         //       jsonObject.put("registrationNo", rs.getString("REGISTRATION_NO"));
		                String regNo=rs.getString("REGISTRATION_NO");
		                jsonObject.put("registrationNo", "<a href='VehicleDiagnosticDashBoard.jsp?RegNo="+regNo+"&ParamId="+popId+"&Sts="+Stas+" '> "+regNo+"  </a>"  );
		                jsonObject.put("value", rs.getString("VALUE"));
		                jsonObject.put("gpsDateTime", rs.getString("GPS_DATETIME"));
		                jsonObject.put("location", rs.getString("LOCATION"));
		                jsonArray.put(jsonObject);
		            }
		            pstmt.close();
			    	rs.close();
	    	 }else if (popId.equals("crossBordId"))
	    	 {
	    		 conAMS = DBConnection.getConnectionToDB("AMS");
		    	  pstmt = conAMS.prepareStatement(Qeury12);
		    	  pstmt.setInt(1, systemId);
		    	  pstmt.setInt(2, clientId);
		    	  pstmt.setInt(3, userId);
		            rs = pstmt.executeQuery();
		            while (rs.next()) {
		                jsonObject = new JSONObject();
		              //  jsonObject.put("registrationNo", rs.getString("REGISTRATION_NO"));
		                String regNo=rs.getString("REGISTRATION_NO");
		                jsonObject.put("registrationNo", "<a href='VehicleDiagnosticDashBoard.jsp?RegNo="+regNo+"&ParamId="+popId+"&Sts="+Stas+" '> "+regNo+"  </a>"  );
		                jsonObject.put("value", rs.getString("VALUE"));
		                jsonObject.put("gpsDateTime", rs.getString("GPS_DATETIME"));
		                jsonObject.put("location", rs.getString("LOCATION"));
		                jsonArray.put(jsonObject);
		            }
		            pstmt.close();
			    	rs.close();
	    	 }else if (popId.equals("gpsTampId"))
	    	 {
	    		 conAMS = DBConnection.getConnectionToDB("AMS");
		    	  pstmt = conAMS.prepareStatement(Qeury13);
		    	  pstmt.setInt(1, systemId);
		    	  pstmt.setInt(2, clientId);
		    	  pstmt.setInt(3, userId);
		            rs = pstmt.executeQuery();
		            while (rs.next()) {
		                jsonObject = new JSONObject();
		            //    jsonObject.put("registrationNo", rs.getString("REGISTRATION_NO"));
		                String regNo=rs.getString("REGISTRATION_NO");
		                jsonObject.put("registrationNo", "<a href='VehicleDiagnosticDashBoard.jsp?RegNo="+regNo+"&ParamId="+popId+"&Sts="+Stas+" '> "+regNo+"  </a>"  );
		                jsonObject.put("value", rs.getString("VALUE"));
		                jsonObject.put("gpsDateTime", rs.getString("GPS_DATETIME"));
		                jsonObject.put("location", rs.getString("LOCATION"));
		                jsonArray.put(jsonObject);
		            }
		            pstmt.close();
			    	rs.close();
	    	 }else if (popId.equals("gpsTampAndCrosId"))
	    	 {
	    		 conAMS = DBConnection.getConnectionToDB("AMS");
		    	  pstmt = conAMS.prepareStatement(Qeury14);
		    	  pstmt.setInt(1, systemId);
		    	  pstmt.setInt(2, clientId);
		    	  pstmt.setInt(3, userId);
		            rs = pstmt.executeQuery();
		            while (rs.next()) {
		                jsonObject = new JSONObject();
		            //    jsonObject.put("registrationNo", rs.getString("REGISTRATION_NO"));
		                String regNo=rs.getString("REGISTRATION_NO");
		                jsonObject.put("registrationNo", "<a href='VehicleDiagnosticDashBoard.jsp?RegNo="+regNo+"&ParamId="+popId+"&Sts="+Stas+" '> "+regNo+"  </a>"  );
		                jsonObject.put("value", rs.getString("VALUE"));
		                jsonObject.put("gpsDateTime", rs.getString("GPS_DATETIME"));
		                jsonObject.put("location", rs.getString("LOCATION"));
		                jsonArray.put(jsonObject);
		            }
		            pstmt.close();
			    	rs.close();
	    	 }
	    	 
	     } catch (Exception e) {
       	 e.printStackTrace();
	        } finally {
	            DBConnection.releaseConnectionToDB(conAMS, pstmt, rs);
	        }

		
		
		return jsonArray;
	}


	public JSONArray getShowDataInPopUpInAlert(int systemId, int clientId, String popidVal, int userId ) {
		
		 Connection conAMS = null;
	     PreparedStatement pstmt = null;
	     ResultSet rs = null;
	     JSONArray jsonArray = new JSONArray();
	     JSONObject jsonObject = new JSONObject();
	     try {
	    	 
	    	
	    	  if(popidVal.equals("highCoolId"))
	    	 {
	    	  conAMS = DBConnection.getConnectionToDB("AMS");
	    	  pstmt = conAMS.prepareStatement(OBDStatements.GET_LIST_OF_COOL_QTY);
	    	  pstmt.setInt(1, systemId);
	    	  pstmt.setInt(2, userId);
	            rs = pstmt.executeQuery();
	            while (rs.next()) {
	                jsonObject = new JSONObject();
	                jsonObject.put("registrationNo", rs.getString("REGISTRATION_NO"));
	                jsonObject.put("value", rs.getString("VALUE"));
	                jsonObject.put("gpsDateTime", rs.getString("GMT"));
	                jsonObject.put("location", rs.getString("LOCATION"));
	                jsonArray.put(jsonObject);
	            }
	            pstmt.close();
		    	rs.close();
	    	 }
	    	
	     } catch (Exception e) {
       	 e.printStackTrace();
	        } finally {
	            DBConnection.releaseConnectionToDB(conAMS, pstmt, rs);
	        }
		return jsonArray;
	}	

	public String saveRemarks(int systemId, int clientId, String remarks, String uID) {
		Connection con = null;
		PreparedStatement pstmt = null;
		String message = "";
		int inserted = 0;
		try{
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(OBDStatements.UPDATE_REMARKS);
			pstmt.setString(1, remarks);
			pstmt.setInt(2, systemId);
			pstmt.setInt(3, clientId);
			pstmt.setInt(4, Integer.parseInt(uID));
			inserted = pstmt.executeUpdate();
			if(inserted > 0){
				message = "Remarks added successfully";
			}else{
				message = "Error while adding remarks";
			}
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			DBConnection.releaseConnectionToDB(con, pstmt, null);
		}
		return message;
	}
	public JSONArray getVehicleUser(int systemId, int clientId, int userId) {
		PreparedStatement pstmt = null;
		Connection con = null;
		ResultSet rs = null;
		JSONArray jArr = new JSONArray();
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(OBDStatements.GET_OBD_USER_VEHICLE);
			pstmt.setInt(1,userId);
			pstmt.setInt(2,systemId);
			pstmt.setInt(3,clientId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				jArr.put(rs.getString("vehicleNo"));
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jArr;
	}
	public JSONArray getErrorCodeDetails(int systemId, int clientId, String vehicleNo) {
		PreparedStatement pstmt = null;
		Connection con = null;
		ResultSet rs = null;
		JSONObject obj = null;
		JSONArray jArr = new JSONArray();
		String powerTrain = "NA";
		String chasis = "NA";
		String body = "NA";
		String network = "NA";
		String AIL= "NA";
		String MIL= "NA";
		String RSL= "NA";
		String PL= "NA";
		try{
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(OBDStatements.GET_ERROR_CODE_DTAILS);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, clientId);
			pstmt.setString(3, vehicleNo);
			rs = pstmt.executeQuery();
			int isJ1939=0;
			String isRECENT="N";
			boolean flag=false;
			while(rs.next()){
				flag=true;
				String errorCode = rs.getString("errorCode");
				isJ1939=rs.getInt("IS_J1939");
				isRECENT=rs.getString("IS_RECENT");
				char errorType = errorCode.charAt(0);
				if(isRECENT.equals("Y")){
				if(isJ1939==0){
				switch(errorType){
					case 'P' : powerTrain = errorCode;
							   break;
					case 'C' : chasis = errorCode;
							   break;
					case 'B' : body = errorCode;
							   break;
					case 'N' : network = errorCode;
							   break;
					default: break;		   
				}
				}
				else if(isJ1939==1)
				{
					switch(errorType){
					case 'A' : AIL = errorCode;
							   break;
					case 'M' : MIL = errorCode;
							   break;
					case 'R' : RSL = errorCode;
							   break;
					case 'L' : PL = errorCode;
							   break;
					default: break;		   
				}
				}
			}
				else if(isRECENT.equals("N"))
				{
					if(isJ1939==0||isJ1939==1){
							powerTrain = "NA";
							chasis = "NA";
							body = "NA";
							network = "NA";
							AIL= "NA";
							MIL= "NA";
							RSL= "NA";
							PL= "NA";
					}
				}
			}
			if(isJ1939==1&&flag==true){
				obj = new JSONObject();
				obj.put("AIL", AIL);
				obj.put("MIL", MIL);
				obj.put("RSL", RSL);
				obj.put("LP", PL);
				obj.put("isJ1939", "1");
				obj.put("flag", true);
				jArr.put(obj);
			}
			else if(isJ1939==0&&flag==true){
				obj = new JSONObject();
				obj.put("powerTrain", powerTrain);
				obj.put("chasis", chasis);
				obj.put("body", body);
				obj.put("network", network);
				obj.put("isJ1939", "0");
				obj.put("flag", true);
				jArr.put(obj);
			}
			else if(isJ1939==0&&flag==false){
				obj = new JSONObject();
				obj.put("isJ1939", "0");
				obj.put("flag", false);
				jArr.put(obj);
			}
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jArr;
	}
	public String getIgnitionStatus(int systemId, int clientId, String vehicleNo) {
		PreparedStatement pstmt = null;
		Connection con = null;
		ResultSet rs = null;
		String ignitionStatus = "";
		String gpsDate = "";
		try{
			con = DBConnection.getConnectionToDB("AMS");

			pstmt = con.prepareStatement(OBDStatements.GET_IGNITION_STATUS);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, clientId);
			pstmt.setString(3, vehicleNo);
			rs = pstmt.executeQuery();
			Pattern pattern=Pattern.compile(" - ");
			while(rs.next()){
				if(!rs.getString("gpsDate").contains("1900") && !rs.getString("gpsDate").equals("")){
					gpsDate = sdfyyyymmddhhmmss.format(yyyymmdd.parse(rs.getString("gpsDate")));
				}
				ignitionStatus = rs.getString("ignitionStatus").toUpperCase()+ pattern +"GPS Date" +" ("+gpsDate+")";
			}
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return ignitionStatus;
	}
	
	public String getVoltage(int systemId, int clientId, String vehicleNo) {
		PreparedStatement pstmt = null;
		Connection con = null;
		ResultSet rs = null;
		String battery = "";
		try{
			con = DBConnection.getConnectionToDB("AMS");

			pstmt = con.prepareStatement(OBDStatements.GET_VOLTAGE);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, clientId);
			pstmt.setString(3, vehicleNo);
			rs = pstmt.executeQuery();
			while(rs.next()){
				battery = Dformatter.format(Double.parseDouble(rs.getString("Battery")));
			}
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return battery;
	}
	
	public JSONArray getGroupNameList(int systemId, int clientId, int userId) {
		JSONArray JsonArray = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			JsonArray = new JSONArray();
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(OBDStatements.SELECT_GROUP_LIST_FOR_ASSET);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, clientId);
			pstmt.setInt(3, userId);
			rs = pstmt.executeQuery();
			JSONObject jsonObject = new JSONObject();
			//jsonObject.put("groupId","0");
			jsonObject.put("groupName","Select Vehicle No");
			JsonArray.put(jsonObject);
			while (rs.next()) {
				jsonObject = new JSONObject();
				jsonObject.put("groupId", rs.getString("REGISTRATION_NO"));
				jsonObject.put("groupName", rs.getString("REGISTRATION_NO"));
				JsonArray.put(jsonObject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return JsonArray;
	}

	public ArrayList<Object> getDetailsofOBDVehicle(int systemId, int clientId, int userId,String RegNo,String StartDate,String EndDate,int offmin) {
	 Connection conAMS = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    JSONArray jsonArray = new JSONArray();
    JSONObject jsonObject = new JSONObject();
    int count = 0;
    ArrayList < ReportHelper > reportsList = new ArrayList < ReportHelper > ();
	ArrayList < String > headersList = new ArrayList < String > ();
	ReportHelper finalreporthelper = new ReportHelper();
	ArrayList < Object > finlist = new ArrayList < Object > ();
	String Value="";
    try {  
    	headersList.add("Sl No");
    	headersList.add("GPS Date Time");
		headersList.add("Speed(Km/h)");
		headersList.add("ABS AMBER WARN");
		headersList.add("ABS Switch");
    	headersList.add("AC");
    	headersList.add("Accelerator Pedal Position (%)");
    	headersList.add("Accelerator Pedal Switch");
    	headersList.add("Actual TORQ");
		headersList.add("Airflow Rate");
    	headersList.add("Anti Lock Brake");
    	headersList.add("ASR Switch");
    	headersList.add("Brake Pedal");
		headersList.add("Clutch");
		headersList.add("Coolant Temperature (°C)");
		headersList.add("Distance Malfunction Indicator (Km)");
		headersList.add("Distance since code cleared");
		headersList.add("Door");
		headersList.add("Door Lock");
		headersList.add("Door Passanger");
		headersList.add("Door RL");
		headersList.add("Door RR");
		headersList.add("Driver Demand TORQ");
		headersList.add("Engine Demand TORQ");
		headersList.add("Engine Fuel Economy");
		headersList.add("Engine Brake");
		headersList.add("Engine Coolant Percentage (%)");
		headersList.add("Engine Instantaneous Fuel Economy (L/h)");
		headersList.add("Engine IMF Temperature (°C)");
        headersList.add("Engine Load (%)");
		headersList.add("Engine Speed (rpm)");
		headersList.add("Fuel Consumed (L/h)");
		headersList.add("Fuel Level(%)");
		headersList.add("Fuel Pressure(kPa)");
		headersList.add("Fuel Rate");
		headersList.add("Fuel Temperature (°C)");
    	headersList.add("Head Light");
    	headersList.add("IMA Pressure (kPa)");
    	headersList.add("Intake Air Temperature (°C)");
    	headersList.add("Oil Pressure (kPa)");
		headersList.add("Odometer (Km)");
    	headersList.add("Power Input (V)");
    	headersList.add("Park Brake");
    	headersList.add("Reverse");
		headersList.add("Seat Belt");
		headersList.add("Vehicle Speed (Km/h)");

		
		
		
	   	  conAMS = DBConnection.getConnectionToDB("AMS");
	   	  pstmt = conAMS.prepareStatement(OBDStatements.SELECT_OBD_DETAILS.replace("#", ""+systemId+""));
	   	  pstmt.setInt(1, offmin);
	   	  pstmt.setString(2, RegNo);
	   	  pstmt.setInt(3, offmin);
	   	  pstmt.setString(4, StartDate);
	   	  pstmt.setInt(5, offmin);
	   	  pstmt.setString(6, EndDate);
	   	  pstmt.setInt(7, clientId);
	   	  pstmt.setInt(8, offmin);
	   	  pstmt.setString(9, RegNo);
	   	  pstmt.setInt(10, offmin);
	   	  pstmt.setString(11, StartDate);
	   	  pstmt.setInt(12, offmin);
	   	  pstmt.setString(13, EndDate);
	   	  pstmt.setInt(14, clientId);
	      rs = pstmt.executeQuery();
	           while (rs.next()) {
	        	   count++;
					ReportHelper reporthelper = new ReportHelper();
					jsonObject = new JSONObject();
					ArrayList < Object > informationList = new ArrayList < Object > ();
					
					jsonObject.put("SLNODataIndex", count);
					informationList.add(count);
					
					
		            	   jsonObject.put("GPSDATETIMEDataIndex", rs.getString("GPS_DATE_TIME"));
			               informationList.add(rs.getString("GPS_DATE_TIME"));
		               
			         if(rs.getString("SPEED").contains("-999")){
			            jsonObject.put("SPEEDDataIndex"," ");
				        informationList.add(" "); 
			          }else{
				        jsonObject.put("SPEEDDataIndex",Dformatter1.format( rs.getFloat("SPEED")));
				        informationList.add(Dformatter1.format(rs.getFloat("SPEED")));
			          }
			               
					if(rs.getString("ABS_AMBER_WARN").contains("-999")){
		            	   jsonObject.put("ABSAMBERWARNDataIndex"," ");
			               informationList.add(" "); 
		               }else{
			               jsonObject.put("ABSAMBERWARNDataIndex", Dformatter1.format(rs.getFloat("ABS_AMBER_WARN")));
			               informationList.add(Dformatter1.format(rs.getFloat("ABS_AMBER_WARN")));
		               }
					
					if(rs.getString("ABS_SWITCH").contains("-999")){
		            	   jsonObject.put("ABSSWITCHDataIndex"," ");
			               informationList.add(" "); 
		               }else{
			               jsonObject.put("ABSSWITCHDataIndex", rs.getFloat("ABS_SWITCH"));
			               informationList.add(Dformatter1.format(rs.getFloat("ABS_SWITCH")));
		               }
					
					if(rs.getString("AC").contains("-999")){
		            	   jsonObject.put("ACDataIndex"," ");
			               informationList.add(" "); 
		               }else{
		            	   if(rs.getString("AC").equals("0")){
		            		   Value="OFF";
		            	   }else{
		            		   Value="ON";
		            	   }
			               jsonObject.put("ACDataIndex", Value);
			               informationList.add(Value);
		               }
					
					if(rs.getString("ACC_PEDAL_POS").contains("-999")){
		            	   jsonObject.put("ACCPEDALPOSDataIndex"," ");
			               informationList.add(" "); 
		               }else{
			               jsonObject.put("ACCPEDALPOSDataIndex", Dformatter1.format(rs.getFloat("ACC_PEDAL_POS")));
			               informationList.add(Dformatter1.format(rs.getFloat("ACC_PEDAL_POS")));
		               }
					
					if(rs.getString("ACC_PEDAL_SWITCH").contains("-999")){
		            	   jsonObject.put("ACCPEDALSWITCHDataIndex"," ");
			               informationList.add(" "); 
		               }else{
		            	   if(rs.getString("ACC_PEDAL_SWITCH").equals("0")){
		            		   Value="OFF";
		            	   }else{
		            		   Value="ON";
		            	   }
			               jsonObject.put("ACCPEDALSWITCHDataIndex", Value);
			               informationList.add(Value);
		               }
					
					if(rs.getString("ACT_TORQ").contains("-999")){
		            	   jsonObject.put("ACTTORQDataIndex"," ");
			               informationList.add(" "); 
		               }else{
			               jsonObject.put("ACTTORQDataIndex", Dformatter1.format(rs.getFloat("ACT_TORQ")));
			               informationList.add(Dformatter1.format(rs.getFloat("ACT_TORQ")));
		               }
					
					if(rs.getString("AIRFLOW_RATE").contains("-999")){
		            	   jsonObject.put("AIRFLOWRATEDataIndex"," ");
			               informationList.add(" "); 
		               }else{
			               jsonObject.put("AIRFLOWRATEDataIndex", Dformatter1.format(rs.getFloat("AIRFLOW_RATE")));
			               informationList.add(Dformatter1.format(rs.getFloat("AIRFLOW_RATE")));
		               }
					if(rs.getString("ANTI_LOCK_BRAKE").contains("-999")){
		            	   jsonObject.put("ANTILOCKBRAKEDataIndex"," ");
			               informationList.add(" "); 
		               }else{
			               jsonObject.put("ANTILOCKBRAKEDataIndex", Dformatter1.format(rs.getFloat("ANTI_LOCK_BRAKE")));
			               informationList.add(Dformatter1.format(rs.getFloat("ANTI_LOCK_BRAKE")));
		               }
					if(rs.getString("ASR_SWITCH").contains("-999")){
		            	   jsonObject.put("ASRSWITCHDataIndex"," ");
			               informationList.add(" "); 
		               }else{
		  	               jsonObject.put("ASRSWITCHDataIndex", Dformatter1.format(rs.getFloat("ASR_SWITCH")));
		  	               informationList.add(Dformatter1.format(rs.getFloat("ASR_SWITCH")));
		               }
					
					if(rs.getString("BRAKE_PEDAL").contains("-999")){
		            	   jsonObject.put("BRAKEPEDALDataIndex"," ");
			               informationList.add(" "); 
		               }else{          	   
		            	  
		            	   if(rs.getString("BRAKE_PEDAL").equals("0")){
		            		   Value="OFF";
		            	   }else{
		            		   Value="ON";
		            	   }
			               jsonObject.put("BRAKEPEDALDataIndex", Value);
			               informationList.add(Value);
		               }
					
					if(rs.getString("CLUTCH").contains("-999")){
		            	   jsonObject.put("CLUTCHDataIndex"," ");
			               informationList.add(" "); 
		               }else{		            	   
		            	   if(rs.getString("CLUTCH").equals("0")){
		            		   Value="OFF";
		            	   }else{
		            		   Value="ON";
		            	   }
			               jsonObject.put("CLUTCHDataIndex",Value );
			               informationList.add(Value);
		               }
					
					if(rs.getString("COOLANT_TEMP").contains("-999")){
		            	   jsonObject.put("COOLANTTEMPDataIndex"," ");
			               informationList.add(" "); 
		               }else{
			               jsonObject.put("COOLANTTEMPDataIndex",Dformatter1.format(rs.getFloat("COOLANT_TEMP")));  
			               informationList.add(Dformatter1.format(rs.getFloat("COOLANT_TEMP")));
		               }
					
					if(rs.getString("DISTANCE_MIL").contains("-999")){
		            	   jsonObject.put("DISTANCEMILDataIndex"," ");
			               informationList.add(" "); 
		               }else{
			               jsonObject.put("DISTANCEMILDataIndex", Dformatter1.format(rs.getFloat("DISTANCE_MIL")));
			               informationList.add(Dformatter1.format(rs.getFloat("DISTANCE_MIL")));
		               }
					
					if(rs.getString("DISTANCE_SCC").contains("-999")){
		            	   jsonObject.put("DISTANCESCCDataIndex"," ");
			               informationList.add(" "); 
		               }else{
			               jsonObject.put("DISTANCESCCDataIndex", Dformatter1.format(rs.getFloat("DISTANCE_SCC")));
			               informationList.add(Dformatter1.format(rs.getFloat("DISTANCE_SCC")));
		               }
					
					if(rs.getString("DOOR").contains("-999")){
		            	   jsonObject.put("DOORDataIndex"," ");
			               informationList.add(" "); 
		               }else{
		            	   if(rs.getString("DOOR").equals("0")){
		            		   Value="CLOSE";
		            	   }else{
		            		   Value="OPEN";
		            	   }
			               jsonObject.put("DOORDataIndex", Value);
			               informationList.add(Value);
		               }
					
					if(rs.getString("DOOR_LOCK").contains("-999")){
		            	   jsonObject.put("DOORLOCKDataIndex"," ");
			               informationList.add(" "); 
		               }else{
		            	   if(rs.getString("DOOR_LOCK").equals("0")){
		            		   Value="OFF";
		            	   }else{
		            		   Value="ON";
		            	   }
			               jsonObject.put("DOORLOCKDataIndex", Value);
			               informationList.add(Value);
		               }
					
					if(rs.getString("DOOR_P").contains("-999")){
		            	   jsonObject.put("DOORPDataIndex"," ");
			               informationList.add(" "); 
		               }else{
		            	   if(rs.getString("DOOR_P").equals("0")){
		            		   Value="CLOSE";
		            	   }else{
		            		   Value="OPEN";
		            	   }
			               jsonObject.put("DOORPDataIndex",Value);
			               informationList.add(Value);
		               }
					
					if(rs.getString("DOOR_RL").contains("-999")){
		            	   jsonObject.put("DOORRLDataIndex"," ");
			               informationList.add(" "); 
		               }else{
			               jsonObject.put("DOORRLDataIndex",Dformatter1.format( rs.getFloat("DOOR_RL")));
			               informationList.add(Dformatter1.format(rs.getFloat("DOOR_RL")));
		               }
					
					if(rs.getString("DOOR_RR").contains("-999")){
		            	   jsonObject.put("DOORRRDataIndex"," ");
			               informationList.add(" "); 
		               }else{
			               jsonObject.put("DOORRRDataIndex", Dformatter1.format(rs.getFloat("DOOR_RR")));
			               informationList.add( Dformatter1.format(rs.getFloat("DOOR_RR")));
		               }
					
					if(rs.getString("DR_DEM_TORQ").contains("-999")){
		            	   jsonObject.put("DRDEMTORQDataIndex"," ");
			               informationList.add(" "); 
		               }else{
			               jsonObject.put("DRDEMTORQDataIndex", Dformatter1.format(rs.getFloat("DR_DEM_TORQ")));
			               informationList.add(Dformatter1.format(rs.getFloat("DR_DEM_TORQ")));
		               }
					
					if(rs.getString("ENG_DEM_TORQ").contains("-999")){
		            	   jsonObject.put("ENGDEMTORQDataIndex"," ");
			               informationList.add(" "); 
		               }else{
			               jsonObject.put("ENGDEMTORQDataIndex",Dformatter1.format( rs.getFloat("ENG_DEM_TORQ")));
			               informationList.add(Dformatter1.format(rs.getFloat("ENG_DEM_TORQ")));
		               }
					
					if(rs.getString("ENG_FUEL_ECO").contains("-999")){
		            	   jsonObject.put("ENGFUELECODataIndex"," ");
			               informationList.add(" "); 
		               }else{
			               jsonObject.put("ENGFUELECODataIndex", Dformatter1.format(rs.getFloat("ENG_FUEL_ECO")));
			               informationList.add(Dformatter1.format(rs.getFloat("ENG_FUEL_ECO")));
		               }
					
					if(rs.getString("ENGINE_BRAKE").contains("-999")){
		            	   jsonObject.put("ENGINEBRAKEDataIndex"," ");
			               informationList.add(" "); 
		               }else{
			               jsonObject.put("ENGINEBRAKEDataIndex",Dformatter1.format( rs.getFloat("ENGINE_BRAKE")));
			               informationList.add( Dformatter1.format(rs.getFloat("ENGINE_BRAKE")));
		               }
					
					if(rs.getString("ENGINE_COOLANT_PER").contains("-999")){
		            	   jsonObject.put("ENGINECOOLANTPERDataIndex"," ");
			               informationList.add(" "); 
		               }else{
			               jsonObject.put("ENGINECOOLANTPERDataIndex", Dformatter1.format(rs.getFloat("ENGINE_COOLANT_PER")));
			               informationList.add(Dformatter1.format( rs.getFloat("ENGINE_COOLANT_PER")));
		               }
					
					if(rs.getString("ENGINE_INS_FUEL_ECO").contains("-999")){
		            	   jsonObject.put("ENGINEINSFUELECODataIndex"," ");
			               informationList.add(" "); 
		               }else{
			               jsonObject.put("ENGINEINSFUELECODataIndex", Dformatter1.format(rs.getFloat("ENGINE_INS_FUEL_ECO")));
			               informationList.add( Dformatter1.format(rs.getFloat("ENGINE_INS_FUEL_ECO")));
		               }
					
					if(rs.getString("ENG_IMF_TEMP").contains("-999")){
		            	   jsonObject.put("ENGIMFTEMPDataIndex"," ");
			               informationList.add(" "); 
		               }else{
			               jsonObject.put("ENGIMFTEMPDataIndex", Dformatter1.format(rs.getFloat("ENG_IMF_TEMP")));
			               informationList.add(Dformatter1.format(rs.getFloat("ENG_IMF_TEMP")));	               
		               }
					if(rs.getString("ENGINE_LOAD").contains("-999")){
		            	   jsonObject.put("ENGINELOADDataIndex"," ");
			               informationList.add(" "); 
		               }else{
			               jsonObject.put("ENGINELOADDataIndex", Dformatter1.format(rs.getFloat("ENGINE_LOAD")));
			               informationList.add(Dformatter1.format(rs.getFloat("ENGINE_LOAD")));
		               }
					
					if(rs.getString("ENGINE_SPEED").contains("-999")){
		            	   jsonObject.put("ENGINESPEEDDataIndex"," ");
			               informationList.add(" "); 
		               }else{
			               jsonObject.put("ENGINESPEEDDataIndex",Dformatter1.format( rs.getFloat("ENGINE_SPEED")));
			               informationList.add(Dformatter1.format(rs.getFloat("ENGINE_SPEED")));
		               }
					
					if(rs.getString("FUEL_CONSUMED").contains("-999")){
		            	   jsonObject.put("FUELCONSUMEDDataIndex"," ");
			               informationList.add(" "); 
		               }else{
			               jsonObject.put("FUELCONSUMEDDataIndex",Dformatter1.format( rs.getFloat("FUEL_CONSUMED")));
			               informationList.add(Dformatter1.format(rs.getFloat("FUEL_CONSUMED")));
		               }
					
					if(rs.getString("FUEL_LEVEL").contains("-999")){
		            	   jsonObject.put("FUELLEVELDataIndex"," ");
			               informationList.add(" "); 
		               }else{
			               jsonObject.put("FUELLEVELDataIndex", Dformatter1.format(rs.getFloat("FUEL_LEVEL")));
			               informationList.add(Dformatter1.format(rs.getFloat("FUEL_LEVEL")));
		               }
					
					if(rs.getString("FUEL_PRESSURE").contains("-999")){
		            	   jsonObject.put("FUELPRESSUREDataIndex"," ");
			               informationList.add(" "); 
		               }else{
			               jsonObject.put("FUELPRESSUREDataIndex", Dformatter1.format(rs.getFloat("FUEL_PRESSURE")));
			               informationList.add(Dformatter1.format(rs.getFloat("FUEL_PRESSURE")));
		               }
					
					if(rs.getString("FUEL_RATE").contains("-999")){
		            	   jsonObject.put("FUELRATEDataIndex"," ");
			               informationList.add(" "); 
		               }else{
			               jsonObject.put("FUELRATEDataIndex",Dformatter1.format( rs.getFloat("FUEL_RATE")));
			               informationList.add(Dformatter1.format(rs.getFloat("FUEL_RATE")));
		               }
					
					if(rs.getString("FUEL_TEMP").contains("-999")){
		            	   jsonObject.put("FUELTEMPDataIndex"," ");
			               informationList.add(" "); 
		               }else{
			               jsonObject.put("FUELTEMPDataIndex", Dformatter1.format(rs.getFloat("FUEL_TEMP")));
			               informationList.add(Dformatter1.format(rs.getFloat("FUEL_TEMP")));
		               }
					
					if(rs.getString("HEAD_LIGHT").contains("-999")){
		            	   jsonObject.put("HEADLIGHTDataIndex"," ");
			               informationList.add(" "); 
		               }else{
		            	   if(rs.getString("HEAD_LIGHT").equals("0")){
		            		   Value="OFF";
		            	   }else{
		            		   Value="ON";
		            	   }
			               jsonObject.put("HEADLIGHTDataIndex", Value);
			               informationList.add(Value);
		               }
					
					if(rs.getString("IMA_PRESSURE").contains("-999")){
		            	   jsonObject.put("IMAPRESSUREDataIndex"," ");
			               informationList.add(" "); 
		               }else{
			               jsonObject.put("IMAPRESSUREDataIndex",Dformatter1.format( rs.getFloat("IMA_PRESSURE")));
			               informationList.add( Dformatter1.format(rs.getFloat("IMA_PRESSURE")));
		               }
					
					if(rs.getString("IN_AIRTEMP").contains("-999")){
		            	   jsonObject.put("INAIRTEMPDataIndex"," ");
			               informationList.add(" "); 
		               }else{
			               jsonObject.put("INAIRTEMPDataIndex",Dformatter1.format( rs.getFloat("IN_AIRTEMP")));
			               informationList.add(Dformatter1.format(rs.getFloat("IN_AIRTEMP")));
		               }
					
					if(rs.getString("OIL_PRESSURE").contains("-999")){
		            	   jsonObject.put("OILPRESSUREDataIndex"," ");
			               informationList.add(" "); 
		               }else{
			               jsonObject.put("OILPRESSUREDataIndex", Dformatter1.format(rs.getFloat("OIL_PRESSURE")));
			               informationList.add(Dformatter1.format(rs.getFloat("OIL_PRESSURE")));
		               }
					
					if(rs.getString("ODOMETER").contains("-999")){
		            	   jsonObject.put("ODOMETERDataIndex"," ");
			               informationList.add(" "); 
		               }else{
			               jsonObject.put("ODOMETERDataIndex",Dformatter1.format( rs.getFloat("ODOMETER")));
			               informationList.add( Dformatter1.format(rs.getFloat("ODOMETER")));
		               }
					
					if(rs.getString("POWER_INPUT").contains("-999")){
		            	   jsonObject.put("POWERINPUTDataIndex"," ");
			               informationList.add(" "); 
		               }else{
			               jsonObject.put("POWERINPUTDataIndex",Dformatter1.format( rs.getFloat("POWER_INPUT")));
			               informationList.add(Dformatter1.format(rs.getFloat("POWER_INPUT")));
		               }
					
					if(rs.getString("PARK_BRAKE").contains("-999")){
		            	   jsonObject.put("PARKBRAKEDataIndex"," ");
			               informationList.add(" "); 
		               }else{
		            	   if(rs.getString("PARK_BRAKE").equals("0")){
		            		   Value="OFF";
		            	   }else{
		            		   Value="ON";
		            	   }
			               jsonObject.put("PARKBRAKEDataIndex", Value);
			               informationList.add(Value);
		               }
					
					if(rs.getString("REVERSE").contains("-999")){
		            	   jsonObject.put("REVERSEDataIndex"," ");
			               informationList.add(" "); 
		               }else{
			               jsonObject.put("REVERSEDataIndex", Dformatter1.format(rs.getFloat("REVERSE")));
			               informationList.add(Dformatter1.format(rs.getFloat("REVERSE")));
		               }
	               if(rs.getString("SEAT_BELT").contains("-999")){
	            	   jsonObject.put("SEATBELTDataIndex"," ");
		               informationList.add(" "); 
	               }else{
	            	   
	            	   if(rs.getString("SEAT_BELT").equals("0")){
	            		   Value="OFF";
	            	   }else{
	            		   Value="ON";
	            	   }
		               jsonObject.put("SEATBELTDataIndex", Value);
		               informationList.add(Value);
	               }               
	             
	               
	               if(rs.getString("VEHICLE_SPEED").contains("-999")){
	            	   jsonObject.put("VEHICLESPEEDDataIndex"," ");
		               informationList.add(" "); 
	               }else{
		               jsonObject.put("VEHICLESPEEDDataIndex",Dformatter1.format( rs.getFloat("VEHICLE_SPEED")));
		               informationList.add(Dformatter1.format(rs.getFloat("VEHICLE_SPEED")));
	               }
	               jsonArray.put(jsonObject);
					reporthelper.setInformationList(informationList);
					reportsList.add(reporthelper);
				}
			finalreporthelper.setReportsList(reportsList);
			finalreporthelper.setHeadersList(headersList);
			finlist.add(jsonArray);
			finlist.add(finalreporthelper);
	           pstmt.close();
		    	rs.close();
	    } catch (Exception e) {
	  	 e.printStackTrace();
	       } finally {
	           DBConnection.releaseConnectionToDB(conAMS, pstmt, rs);
	       }
		return finlist;
	}
	
public ArrayList<Object> getIndexesofOBDVehicle(int systemId, int clientId, int userId,String VehicleNo) {
        Connection conAMS = null;
       PreparedStatement pstmt = null;
       ResultSet rs = null;
       JSONArray jsonArray = new JSONArray();
       JSONObject jsonObject = new JSONObject();
       int count = 0;
       ArrayList < ReportHelper > reportsList = new ArrayList < ReportHelper > ();
       ReportHelper finalreporthelper = new ReportHelper();
       ArrayList < Object > finlist = new ArrayList < Object > ();
       String Value="";
       try {  
           
                conAMS = DBConnection.getConnectionToDB("AMS");
                pstmt = conAMS.prepareStatement(OBDStatements.SELECT_OBD_INDEX_DETAILS);
                pstmt.setInt(1, systemId);
                pstmt.setInt(2, clientId);
                pstmt.setString(3, VehicleNo);
             rs = pstmt.executeQuery();

                  while (rs.next()) {
                	  ReportHelper reporthelper = new ReportHelper();
  					jsonObject = new JSONObject();
  					ArrayList < Object > informationList = new ArrayList < Object > ();
      				
  					jsonObject.put("DataListIndex",rs.getString("fieldLabel").replace("_", "")+"DataIndex");
      				jsonArray.put(jsonObject);
      				reportsList.add(reporthelper);
                  }
               finalreporthelper.setReportsList(reportsList);
               finlist.add(jsonArray);
               finlist.add(finalreporthelper);
                  pstmt.close();
                   rs.close();
           } catch (Exception e) {
              e.printStackTrace();
              } finally {
                  DBConnection.releaseConnectionToDB(conAMS, pstmt, rs);
              }
           return finlist;
       }	

public String getOBDExcelNew(int systemId, int clientId, int userId,String regNo,String startDate,String endDate,int offmin) {
	
	 Connection con = null;
     PreparedStatement pstmt = null;
     ResultSet rs = null;
     PreparedStatement pstmt1 = null;
     ResultSet rs1 = null;
   // Get vehicle model
     String vehicleModel = "";
     String completePath = null;
	try {
		startDate = yyyymmdd.format(ddmmyyyy.parse(startDate));
		endDate = yyyymmdd.format(ddmmyyyy.parse(endDate));		
		con =  DBConnection.getConnectionToDB("AMS");
		pstmt = con.prepareStatement(OBDStatements.GET_VEHICLE_DETAILS);
		pstmt.setInt(1, systemId);
		pstmt.setString(2, regNo);
		rs = pstmt.executeQuery();
		if (rs.next()) {
			vehicleModel = rs.getString("modelId");
		}
		pstmt.close();
		rs.close();
		
		pstmt = con.prepareStatement(OBDStatements.GET_VEHICLLE_LOOKUP_DETAILS_EXPORT);
		pstmt.setInt(1, systemId);
		pstmt.setString(2, vehicleModel);
		rs = pstmt.executeQuery();
		
		StringBuffer columnNames = new StringBuffer();
		String columnName = "";
		ArrayList<String> headerList = new ArrayList<String>();
		ArrayList<String> parameterNames = new ArrayList<String>();
		HashMap<String, String> nameToTypeMap = new HashMap<String, String>();
		headerList.add("SL NO");
		headerList.add("GPS DATE TIME");
		parameterNames.add("GPS_DATE_TIME");
		nameToTypeMap.put("GPS_DATE_TIME", "date");
		 boolean odometer = false;
		 boolean paramsDefined = false;
		while(rs.next()){
			paramsDefined = true;
			columnNames.append("isnull("+rs.getString("fieldLabel")+",'') as "+rs.getString("fieldLabel")+", ");
			if(rs.getString("unit") != null && !rs.getString("unit").equals("")){
				headerList.add(rs.getString("PARAMETER_NAME") +"("+rs.getString("unit")+")");
			}else{
				headerList.add(rs.getString("PARAMETER_NAME"));
			}
			parameterNames.add(rs.getString("fieldLabel"));
			nameToTypeMap.put(rs.getString("fieldLabel"), rs.getString("TYPE").trim());
			if (rs.getString("fieldLabel").equalsIgnoreCase("ODOMETER")){
				odometer = true;
			}
			
		}
		
		if ((paramsDefined) && (odometer == false)){
			parameterNames.add("GPS-ODOMETER");
			headerList.add("GPS-ODOMETER");
			nameToTypeMap.put("GPS-ODOMETER", "");
		}
		// if !odometer add GPS ODOMETER
		if(columnNames.lastIndexOf(",") >0){
			columnName = ", "+columnNames.substring(0, columnNames.lastIndexOf(","));
		}
		//Get values
		 if (parameterNames.get(parameterNames.size()-1).equalsIgnoreCase("GPS-ODOMETER")){
         	String odometerValue = "";
         	DBConnection.releaseConnectionToDB(null, pstmt1, rs1);
         	String statementOdometer = "select *,(select max(ODOMETER) from (select ODOMETER from HISTORY_DATA_# WITH (NOLOCK) where GPS_DATETIME between  "+
         	" dateadd(mi,-2,GPS_DATE_TIME) and dateadd(mi,2,GPS_DATE_TIME) and REGISTRATION_NO=? "+
         	" union all "+
         	" select ODOMETER from AMS_Archieve.dbo.GE_DATA_# WITH (NOLOCK) where GPS_DATETIME between "+ 
         	" dateadd(mi,-2,GPS_DATE_TIME) and dateadd(mi,2,GPS_DATE_TIME) and REGISTRATION_NO=?) t "+
         	" ) as ODO from ( select isnull(dateadd(mi,?,GMT),'') as GPS_DATE_TIME "+columnName+" "+ 
         	" from AMS.dbo.CANIQ_HISTORY_# WITH (NOLOCK) where  "+
         	" REGISTRATION_NO=? and GMT between dateadd(mi,-?,?) and dateadd(mi,-?,?) "+ 
         	" and LONGITUDE is not null and LATITUDE is not null "+
         	" union all "+
         	" select isnull(dateadd(mi,?,GMT),'')as GPS_DATE_TIME "+columnName+" "+ 
         	" from AMS_Archieve.dbo.GE_CANIQ_# WITH (NOLOCK) where  "+ 
         	" REGISTRATION_NO=? and GMT between dateadd(mi,-?,?) and  dateadd(mi,-?,?) "+
         	" and LONGITUDE is not null and LATITUDE is not null ) r order by GPS_DATE_TIME asc";
         	
         	
         			pstmt = con.prepareStatement(statementOdometer.replace("#", ""+systemId+""));
         			pstmt.setString(1, regNo);
         			pstmt.setString(2, regNo);
         			pstmt.setInt(3, offmin);
         			pstmt.setString(4, regNo);
         			pstmt.setInt(5, offmin);
         			pstmt.setString(6, startDate);
         			pstmt.setInt(7, offmin);
         			pstmt.setString(8, endDate);
         			pstmt.setInt(9, offmin);
         			pstmt.setString(10, regNo);
         			pstmt.setInt(11, offmin);
         			pstmt.setString(12, startDate);
         			pstmt.setInt(13, offmin);
         			pstmt.setString(14, endDate);}
		 else{
			 
		String statement = "select isnull(dateadd(mi,?,GMT),' ' )as GPS_DATE_TIME "+columnName+"  from AMS.dbo.CANIQ_HISTORY_# where " +
							" System_id=? and CLIENTID=? and REGISTRATION_NO=? and GMT between dateadd(mi,-?,?) and  dateadd(mi,-?,?) and LONGITUDE is not null and LATITUDE is not null"+
							" union all "+
							"select isnull(dateadd(mi,?,GMT),' ' )as GPS_DATE_TIME "+columnName+"  from AMS_Archieve.dbo.GE_CANIQ_# where " +
							" System_id=? and CLIENTID=? and REGISTRATION_NO=? and GMT between dateadd(mi,-?,?) and  dateadd(mi,-?,?) and LONGITUDE is not null and LATITUDE is not null"+
							" order by GPS_DATE_TIME asc ";
				pstmt = con.prepareStatement(statement.replace("#", ""+systemId+""));
    	pstmt.setInt(1, offmin);
		pstmt.setInt(2, systemId);
		pstmt.setInt(3, clientId);
		pstmt.setString(4, regNo);
		pstmt.setInt(5, offmin);
		pstmt.setString(6, startDate);
		pstmt.setInt(7, offmin);
		pstmt.setString(8, endDate);
		pstmt.setInt(9, offmin);
		pstmt.setInt(10, systemId);
		pstmt.setInt(11, clientId);
		pstmt.setString(12, regNo);
		pstmt.setInt(13, offmin);
		pstmt.setString(14, startDate);
		pstmt.setInt(15, offmin);
		pstmt.setString(16, endDate); 
		}
		rs = pstmt.executeQuery();
        if(rs.next()){
		//create excel
		Properties properties = ApplicationListener.prop;
		String name = "OBD Report Details";
		String rootPath =  properties.getProperty("obdExcelExport");
		completePath = rootPath + "//" + name + ".xls";
		File f = new File(rootPath);
		if (!f.exists()) {
			f.mkdir();
		}
		FileOutputStream fileOut = new FileOutputStream(completePath);
		Workbook workbook = new HSSFWorkbook();
		CreationHelper createHelper = workbook.getCreationHelper();
		HSSFSheet sheet = (HSSFSheet) workbook.createSheet("OBD Report");
		
		// Create a Font for styling header cells
		Font headerFont = workbook.createFont();
		headerFont.setBoldweight((short) 5);
		headerFont.setFontHeightInPoints((short) 10);
		headerFont.setColor(IndexedColors.BLUE.getIndex());
		// Create a CellStyle with the font
		CellStyle headerCellStyle = workbook.createCellStyle();
		headerCellStyle.setFont(headerFont);
		headerCellStyle.setFillForegroundColor(IndexedColors.BLUE.getIndex());
		DataFormat fmt = workbook.createDataFormat();
		CellStyle stringStyle = workbook.createCellStyle();
		stringStyle.setAlignment(HSSFCellStyle.ALIGN_LEFT);
		stringStyle.setDataFormat(fmt.getFormat("@"));
		
		CellStyle numericStyle = workbook.createCellStyle();
		numericStyle.setAlignment(HSSFCellStyle.ALIGN_RIGHT);
		numericStyle.setDataFormat(fmt.getFormat("#"));
		
		CellStyle decimalStyle = workbook.createCellStyle();
		decimalStyle.setAlignment(HSSFCellStyle.ALIGN_LEFT);
		decimalStyle.setDataFormat(fmt.getFormat("0.00"));
		
		CellStyle decimalStyle1 = workbook.createCellStyle();
		decimalStyle1.setAlignment(HSSFCellStyle.ALIGN_LEFT);
		decimalStyle1.setDataFormat(fmt.getFormat("0.000"));
		
		CellStyle dateStyle = workbook.createCellStyle();
		dateStyle.setAlignment(HSSFCellStyle.ALIGN_LEFT);
		dateStyle.setDataFormat(fmt.getFormat("dd/MM/yyyy HH:mm:ss"));
		
		
		CellStyle headerStyle = workbook.createCellStyle();
		headerStyle.setAlignment(CellStyle.ALIGN_CENTER);
		
		HSSFCellStyle orangeStyle = (HSSFCellStyle) workbook.createCellStyle();
		orangeStyle.setAlignment(CellStyle.ALIGN_CENTER);
		orangeStyle.setFillForegroundColor(IndexedColors.LIGHT_ORANGE.index);
		orangeStyle.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
		orangeStyle.setBorderTop((short) 1); // single line border
		orangeStyle.setBorderBottom((short) 1); // single line border
		
		Row rowHeading=sheet.createRow(0);
		sheet.createFreezePane(0, 5);
		
		Cell titleCellC1 = rowHeading.createCell(0);
		titleCellC1.setCellValue("OBD Report Details");
		titleCellC1.setCellStyle(orangeStyle);
		sheet.addMergedRegion(new CellRangeAddress(0,(short)0,0,(short)20));
		
		Row row1=sheet.createRow(1);
		
		Cell titleCellC2 = row1.createCell(0);
		titleCellC2.setCellValue("Start Date : " + startDate+"         " + "End Date : " +endDate);		
		
		/*Cell titleCellC3 = row1.createCell(45);
		titleCellC3.setCellValue("End Date : "+EndDate+"");*/
		
		Row row2=sheet.createRow(2);						
		Cell titleCellC4 = row2.createCell(0);
		titleCellC4.setCellValue("Vehicle No : "+regNo+"");
		sheet.addMergedRegion(new CellRangeAddress(1,(short)1,0,(short)45));
		
		sheet.addMergedRegion(new CellRangeAddress(2,(short)2,0,(short)45));
		
		 Row headerRow = sheet.createRow(4);
		// Create cells
		for (int i = 0; i <headerList.size(); i++) {
			 Cell cell = headerRow.createCell(i);
			   cell.setCellValue(headerList.get(i));
	            cell.setCellStyle(headerCellStyle);
		}
		int rowNum = 5;
		int i=1;
		Cell cell;
		Set<String> headerSet = nameToTypeMap.keySet();
		String type = "";
		String value = "";
		String parameterName = "";
		int slCount = 1;
		String gpsDateTime = "";
		while(rs.next()){
			 Row row = sheet.createRow(rowNum++);
			 cell = row.createCell(0);
			 cell.setCellValue(slCount);
         	 cell.setCellStyle(stringStyle);
			 for(i =0; i<parameterNames.size();i++){
				    cell = row.createCell(i+1);
				    parameterName = parameterNames.get(i);
				    if (!parameterName.equalsIgnoreCase("GPS-ODOMETER")){
				    	
				    if(parameterName.equals("GPS_DATE_TIME")){
				    	gpsDateTime = rs.getString(parameterName);
				    }
		            type = nameToTypeMap.get(parameterName);
		            if("date".equalsIgnoreCase(type)){
		            	cell.setCellValue(sdfyyyymmddhhmmss.format(yyyymmdd.parse(rs.getString(parameterName))));
		            	cell.setCellStyle(dateStyle);
		            }
		            else if("decimal".equalsIgnoreCase(type)){
		            	cell.setCellValue(rs.getString(parameterName));
		            	cell.setCellStyle(decimalStyle);
		            }else if("boolean".equalsIgnoreCase(nameToTypeMap.get(parameterName))){
		            	if(rs.getString(parameterName).equals("0")){
		            		   value="OFF";
		            	   }else{
		            		   value="ON";
		            	   }
		            	cell.setCellValue(value);
		            	cell.setCellStyle(stringStyle);
		            }else if ("door".equalsIgnoreCase(type)){
		            	if(rs.getString(parameterName).equals("0")){
		            		   value="CLOSE";
		            	   }else{
		            		   value="OPEN";
		            	   }
		            	cell.setCellValue(value);
		            	cell.setCellStyle(stringStyle);
		            }else if ("gear".equalsIgnoreCase(type)){
		            	if(rs.getString(parameterName).equals("0")){
		            		value = "NEUTRAL";
				 		}else if(rs.getString(parameterName).equals("1")){
				 			value = "FORWARD";
				 		}else if(rs.getString(parameterName).equals("2")){
				 			value = "REVERSE";
				 		}else{
				 			value = "BOOST";
				 		}
		            	cell.setCellValue(value);
		            	cell.setCellStyle(stringStyle);
		            }else if("string".equalsIgnoreCase(type)){
		            	cell.setCellValue(rs.getString(parameterName));
		            	cell.setCellStyle(stringStyle);
		            }else{
		            	cell.setCellValue(rs.getString(parameterName));
		            	cell.setCellStyle(stringStyle);
		            }
				    } 
		     }
			 if(parameterNames.get(parameterNames.size()-1).equalsIgnoreCase("GPS-ODOMETER")){
				 
					 String odometerValue = rs.getString("ODO");
				 
				 cell = row.createCell(parameterNames.size());
				 cell.setCellValue(odometerValue);
	             cell.setCellStyle(decimalStyle);
				
			 
			 
			 }
			 slCount++;
		}
		
		workbook.write(fileOut);
		fileOut.flush();
		fileOut.close();
        }else{
        	completePath = "No Records Found";
        }
		
	} catch (Exception e) {
		e.printStackTrace();
	}

	return completePath;
}

public String getOBDExcel(int systemId, int clientId, int userId,String RegNo,String StartDate,String EndDate,int offmin) {
   Connection conAMS = null;
   PreparedStatement pstmt = null;
   ResultSet rs = null;
   JSONArray jsonArray = new JSONArray();
   JSONObject jsonObject = new JSONObject();
   int count = 0;
   String completePath=null;
   ArrayList < ReportHelper > reportsList = new ArrayList < ReportHelper > ();
	ArrayList < String > headersList = new ArrayList < String > ();
	ReportHelper finalreporthelper = new ReportHelper();
	ArrayList < Object > finlist = new ArrayList < Object > ();
	String Value="";
   try {  
   	headersList.add("Sl No");
   	headersList.add("GPS Date Time");
		headersList.add("Speed(Km/h)");
		headersList.add("ABS AMBER WARN");
		headersList.add("ABS Switch");
   	headersList.add("AC");
   	headersList.add("Accelerator Pedal Position (%)");
   	headersList.add("Accelerator Pedal Switch");
   	headersList.add("Actual TORQ");
		headersList.add("Airflow Rate");
   	headersList.add("Anti Lock Brake");
   	headersList.add("ASR Switch");
   	headersList.add("Brake Pedal");
		headersList.add("Clutch");
		headersList.add("Coolant Temperature (°C)");
		headersList.add("Distance Malfunction Indicator (Km)");
		headersList.add("Distance since code cleared");
		headersList.add("Door");
		headersList.add("Door Lock");
		headersList.add("Door Passanger");
		headersList.add("Door RL");
		headersList.add("Door RR");
		headersList.add("Driver Demand TORQ");
		headersList.add("Engine Demand TORQ");
		headersList.add("Engine Fuel Economy");
		headersList.add("Engine Brake");
		headersList.add("Engine Coolant Percentage (%)");
		headersList.add("Engine Instantaneous Fuel Economy (L/h)");
		headersList.add("Engine IMF Temperature (°C)");
       headersList.add("Engine Load (%)");
		headersList.add("Engine Speed (rpm)");
		headersList.add("Fuel Consumed (L/h)");
		headersList.add("Fuel Level(%)");
		headersList.add("Fuel Pressure(kPa)");
		headersList.add("Fuel Rate");
		headersList.add("Fuel Temperature (°C)");
   	headersList.add("Head Light");
   	headersList.add("IMA Pressure (kPa)");
   	headersList.add("Intake Air Temperature (°C)");
   	headersList.add("Oil Pressure (kPa)");
		headersList.add("Odometer (Km)");
   	headersList.add("Power Input (V)");
   	headersList.add("Park Brake");
   	headersList.add("Reverse");
		headersList.add("Seat Belt");
		headersList.add("Vehicle Speed (Km/h)");
		
		String name = "OBD Report Details";
		Properties properties = ApplicationListener.prop;
	
		String rootPath =  properties.getProperty("driverPerformanceLegwiseExcelExport");
		//System.out.println("R P " + rootPath + "Name " + name);
		completePath = rootPath + "//" + name + ".xls";
		
		
		File f = new File(rootPath);
		if (!f.exists()) {
			f.mkdir();
		}
		
		FileOutputStream fileOut = new FileOutputStream(completePath);

		Workbook workbook = new HSSFWorkbook(); //new XSSFWorkbook() for generating `.xls` file

		/* CreationHelper helps us create instances of various things like DataFormat, 
	           Hyperlink, RichTextString etc, in a format (HSSF, XSSF) independent way */
		CreationHelper createHelper = workbook.getCreationHelper();

		// Create a Sheet
		HSSFSheet sheet = (HSSFSheet) workbook.createSheet("OBD Report");

		// Create a Font for styling header cells
		Font headerFont = workbook.createFont();
		// headerFont.setBoldweight(); //.setBoldweight(true);
		headerFont.setFontHeightInPoints((short) 12);
		headerFont.setColor(IndexedColors.BLUE.getIndex());

		// Create a CellStyle with the font
		CellStyle headerCellStyle = workbook.createCellStyle();
		headerCellStyle.setFont(headerFont);
		
		
		DataFormat fmt = workbook.createDataFormat();
		CellStyle stringStyle = workbook.createCellStyle();
		stringStyle.setAlignment(HSSFCellStyle.ALIGN_LEFT);
		stringStyle.setDataFormat(fmt.getFormat("@"));
		
		CellStyle numericStyle = workbook.createCellStyle();
		numericStyle.setAlignment(HSSFCellStyle.ALIGN_RIGHT);
		numericStyle.setDataFormat(fmt.getFormat("#"));
		
		CellStyle decimalStyle = workbook.createCellStyle();
		decimalStyle.setAlignment(HSSFCellStyle.ALIGN_LEFT);
		decimalStyle.setDataFormat(fmt.getFormat("0.00"));
		
		CellStyle decimalStyle1 = workbook.createCellStyle();
		decimalStyle1.setAlignment(HSSFCellStyle.ALIGN_LEFT);
		decimalStyle1.setDataFormat(fmt.getFormat("0.000"));
		
		CellStyle dateStyle = workbook.createCellStyle();
		dateStyle.setAlignment(HSSFCellStyle.ALIGN_LEFT);
		dateStyle.setDataFormat(fmt.getFormat("dd/MM/yyyy HH:mm:ss"));
		
		
		CellStyle headerStyle = workbook.createCellStyle();
		headerStyle.setAlignment(CellStyle.ALIGN_CENTER);
		
		HSSFCellStyle orangeStyle = (HSSFCellStyle) workbook.createCellStyle();
		orangeStyle.setAlignment(CellStyle.ALIGN_CENTER);
		orangeStyle.setFillForegroundColor(IndexedColors.ORANGE.index);
		orangeStyle.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
		orangeStyle.setBorderTop((short) 1); // single line border
		orangeStyle.setBorderBottom((short) 1); // single line border
		
		Row rowHeading=sheet.createRow(0);
		sheet.createFreezePane(0, 5);
		
		Cell titleCellC1 = rowHeading.createCell(0);
		titleCellC1.setCellValue("OBD Report Details");
		titleCellC1.setCellStyle(orangeStyle);
		sheet.addMergedRegion(new CellRangeAddress(0,(short)0,0,(short)45));
		//sheet.getMergedRegion(45);
		
		Row row1=sheet.createRow(1);
		
		Cell titleCellC2 = row1.createCell(0);
		titleCellC2.setCellValue("Start Date : " + StartDate+"         " + "End Date : " +EndDate);		
		
		/*Cell titleCellC3 = row1.createCell(45);
		titleCellC3.setCellValue("End Date : "+EndDate+"");*/
		
		Row row2=sheet.createRow(2);						
		Cell titleCellC4 = row2.createCell(0);
		titleCellC4.setCellValue("Vehicle No : "+RegNo+"");
		sheet.addMergedRegion(new CellRangeAddress(1,(short)1,0,(short)45));
		
		sheet.addMergedRegion(new CellRangeAddress(2,(short)2,0,(short)45));
		
		 Row headerRow = sheet.createRow(4);

			// Create cells
			
			for (int i = 0; i <headersList.size(); i++) {
				 Cell cell = headerRow.createCell(i);
		            cell.setCellValue(headersList.get(i));
		            cell.setCellStyle(headerCellStyle);
			}
		
			int rowNum = 5;
						
		
	   	  conAMS = DBConnection.getConnectionToDB("AMS");
	   	  pstmt = conAMS.prepareStatement(OBDStatements.SELECT_OBD_DETAILS.replace("#", ""+systemId+""));
	   	  pstmt.setInt(1, offmin);
	   	  pstmt.setString(2, RegNo);
	   	  pstmt.setInt(3, offmin);
	   	  pstmt.setString(4, StartDate);
	   	  pstmt.setInt(5, offmin);
	   	  pstmt.setString(6, EndDate);
	   	  pstmt.setInt(7, clientId);
	   	  pstmt.setInt(8, offmin);
	   	  pstmt.setString(9, RegNo);
	   	  pstmt.setInt(10, offmin);
	   	  pstmt.setString(11, StartDate);
	   	  pstmt.setInt(12, offmin);
	   	  pstmt.setString(13, EndDate);
	   	  pstmt.setInt(14, clientId);
	      rs = pstmt.executeQuery();	      
	           while (rs.next()) {
	        	   count++;
	        	   
	        	   Row row = sheet.createRow(rowNum++);
	        	   
	        	   
					ReportHelper reporthelper = new ReportHelper();
					jsonObject = new JSONObject();
					ArrayList < Object > informationList = new ArrayList < Object > ();
					
					jsonObject.put("SLNODataIndex", count);
					informationList.add(count);
					Cell cell0 = row.createCell(0);
		        	cell0.setCellValue(count);
		        
							        	
					Cell cell1 = row.createCell(1);
			        cell1.setCellValue(sdfyyyymmddhhmmss.format(yyyymmdd.parse(rs.getString("GPS_DATE_TIME"))));
			        cell1.setCellStyle(dateStyle);
			       
			        	 		              			       			              
					Cell cell2 = row.createCell(2);
				    cell2.setCellValue(rs.getString("SPEED").contains("-999") ? "" : Dformatter1.format(rs.getFloat("SPEED")));
				    cell2.setCellStyle(decimalStyle);
					
				    				    
					Cell cell3 = row.createCell(3);
				    cell3.setCellValue(rs.getString("ABS_AMBER_WARN").contains("-999") ? "" : Dformatter1.format(rs.getFloat("ABS_AMBER_WARN")));
				    cell3.setCellStyle(decimalStyle);
				    
					
					Cell cell4 = row.createCell(4);
				    cell4.setCellValue(rs.getString("ABS_SWITCH").contains("-999") ? "" : Dformatter1.format(rs.getFloat("ABS_SWITCH")));
				    cell4.setCellStyle(decimalStyle);
				   
					if(rs.getString("AC").contains("-999")){
						 Value="";
		               }else{
		            	   if(rs.getString("AC").equals("0")){
		            		   Value="OFF";
		            	   }else{
		            		   Value="ON";
		            	   }
			               
		               }
					
					Cell cell5 = row.createCell(5);
				    cell5.setCellValue(Value);
				    cell5.setCellStyle(stringStyle);
					
					
					Cell cell6 = row.createCell(6);
				    cell6.setCellValue(rs.getString("ACC_PEDAL_POS").contains("-999")? "" :  Dformatter1.format(rs.getFloat("ACC_PEDAL_POS")));
				    cell6.setCellStyle(decimalStyle);
				    
				   Value = "";
					if(rs.getString("ACC_PEDAL_SWITCH").contains("-999")){
		            	   
		               }else{
		            	   if(rs.getString("ACC_PEDAL_SWITCH").equals("0")){
		            		   Value="OFF";
		            	   }else{
		            		   Value="ON";
		            	   }			              
		               }
					Cell cell7 = row.createCell(7);
				    cell7.setCellValue(Value);
				    cell7.setCellStyle(stringStyle);

					
					Cell cell8 = row.createCell(8);
				    cell8.setCellValue(rs.getString("ACT_TORQ").contains("-999") ? "" :  Dformatter1.format(rs.getFloat("ACT_TORQ")));
				    cell8.setCellStyle(decimalStyle);
					
					
					
					Cell cell9 = row.createCell(9);
				    cell9.setCellValue(rs.getString("AIRFLOW_RATE").contains("-999") ? "" :  Dformatter1.format(rs.getFloat("AIRFLOW_RATE")));
				    cell9.setCellStyle(decimalStyle);
				
					Cell cell10 = row.createCell(10);
				    cell10.setCellValue(rs.getString("ANTI_LOCK_BRAKE").contains("-999") ? "" :  Dformatter1.format(rs.getFloat("ANTI_LOCK_BRAKE")));
				    cell10.setCellStyle(decimalStyle);
				    
													
					Cell cell11 = row.createCell(11);
				    cell11.setCellValue(rs.getString("ASR_SWITCH").contains("-999") ? "" :  Dformatter1.format(rs.getFloat("ASR_SWITCH")));
				    cell11.setCellStyle(decimalStyle);
				    
				    Value = "";
					if(rs.getString("BRAKE_PEDAL").contains("-999")){
		            	  
		               }else{          	   		            	  
		            	   if(rs.getString("BRAKE_PEDAL").equals("0")){
		            		   Value="OFF";
		            	   }else{
		            		   Value="ON";
		            	   }			              
		               }
					Cell cell12 = row.createCell(12);
				    cell12.setCellValue(Value);
				    cell12.setCellStyle(stringStyle);
				    
				    Value = "";
					if(rs.getString("CLUTCH").contains("-999")){
		            	   
		               }else{		            	   
		            	   if(rs.getString("CLUTCH").equals("0")){
		            		   Value="OFF";
		            	   }else{
		            		   Value="ON";
		            	   }			               
		               }
					Cell cell13 = row.createCell(13);
				    cell13.setCellValue(Value);
				    cell13.setCellStyle(stringStyle);
					
					
					Cell cell14 = row.createCell(14);
				    cell14.setCellValue(rs.getString("COOLANT_TEMP").contains("-999") ? "" :  Dformatter1.format(rs.getFloat("COOLANT_TEMP")));
				    cell14.setCellStyle(decimalStyle);
					
				
					Cell cell15 = row.createCell(15);
				    cell15.setCellValue(rs.getString("DISTANCE_MIL").contains("-999") ? "" :  Dformatter1.format(rs.getFloat("DISTANCE_MIL")));
				    cell15.setCellStyle(decimalStyle);
					
					
					Cell cell16 = row.createCell(16);
				    cell16.setCellValue(rs.getString("DISTANCE_SCC").contains("-999") ? "" :  Dformatter1.format(rs.getFloat("DISTANCE_SCC")));
				    cell16.setCellStyle(decimalStyle);
				    	
					Value = "";
					if(rs.getString("DOOR").contains("-999")){
		            	   
		               }else{
		            	   if(rs.getString("DOOR").equals("0")){
		            		   Value="CLOSE";
		            	   }else{
		            		   Value="OPEN";
		            	   }			               
		               }
					Cell cell17 = row.createCell(17);
				    cell17.setCellValue(Value);
				    cell17.setCellStyle(stringStyle);

					
					Value = "";
					if(rs.getString("DOOR_LOCK").contains("-999")){
		            	    
		               }else{
		            	   if(rs.getString("DOOR_LOCK").equals("0")){
		            		   Value="OFF";
		            	   }else{
		            		   Value="ON";
		            	   }			               
		               }
					Cell cell18 = row.createCell(18);
				    cell18.setCellValue(Value);
				    cell18.setCellStyle(stringStyle);

				    Value = "";
					if(rs.getString("DOOR_P").contains("-999")){
		            	   
		               }else{
		            	   if(rs.getString("DOOR_P").equals("0")){
		            		   Value="CLOSE";
		            	   }else{
		            		   Value="OPEN";
		            	   }			               
		               }
					Cell cell19 = row.createCell(19);
				    cell19.setCellValue(Value);
				    cell19.setCellStyle(stringStyle);
				    
										
					Cell cell20 = row.createCell(20);
				    cell20.setCellValue(rs.getString("DOOR_RL").contains("-999") ? "" :  Dformatter1.format(rs.getFloat("DOOR_RL")));
				    cell20.setCellStyle(decimalStyle);
				    
					
					Cell cell21 = row.createCell(21);
				    cell21.setCellValue(rs.getString("DOOR_RR").contains("-999") ? "" :  Dformatter1.format(rs.getFloat("DOOR_RR")));
				    cell21.setCellStyle(decimalStyle);	
					
					
					Cell cell22 = row.createCell(22);
				    cell22.setCellValue(rs.getString("DR_DEM_TORQ").contains("-999") ? "" :  Dformatter1.format(rs.getFloat("DR_DEM_TORQ")));
				    cell22.setCellStyle(decimalStyle);
					
					
					Cell cell23 = row.createCell(23);
				    cell23.setCellValue(rs.getString("ENG_DEM_TORQ").contains("-999") ? "" :  Dformatter1.format(rs.getFloat("ENG_DEM_TORQ")));
				    cell23.setCellStyle(decimalStyle);
				    
									
					Cell cell24 = row.createCell(24);
				    cell24.setCellValue(rs.getString("ENG_FUEL_ECO").contains("-999") ? "" :  Dformatter1.format(rs.getFloat("ENG_FUEL_ECO")));
				    cell24.setCellStyle(decimalStyle);
				    
										
					Cell cell25 = row.createCell(25);
				    cell25.setCellValue(rs.getString("ENGINE_BRAKE").contains("-999") ? "" :  Dformatter1.format(rs.getFloat("ENGINE_BRAKE")));
				    cell25.setCellStyle(decimalStyle);
				    
										
					Cell cell26 = row.createCell(26);
				    cell26.setCellValue(rs.getString("ENGINE_COOLANT_PER").contains("-999") ? "" :  Dformatter1.format( rs.getFloat("ENGINE_COOLANT_PER")));
				    cell26.setCellStyle(decimalStyle);
				    
				    					
					Cell cell27 = row.createCell(27);
				    cell27.setCellValue(rs.getString("ENGINE_INS_FUEL_ECO").contains("-999") ? "" :  Dformatter1.format(rs.getFloat("ENGINE_INS_FUEL_ECO")));
				    cell27.setCellStyle(decimalStyle);
					
					
					Cell cell28 = row.createCell(28);
				    cell28.setCellValue(rs.getString("ENG_IMF_TEMP").contains("-999") ? "" :  Dformatter1.format(rs.getFloat("ENG_IMF_TEMP")));
				    cell28.setCellStyle(decimalStyle);
				    
					
					Cell cell29 = row.createCell(29);
				    cell29.setCellValue(rs.getString("ENGINE_LOAD").contains("-999") ? "" :  Dformatter1.format(rs.getFloat("ENGINE_LOAD")));
				    cell29.setCellStyle(decimalStyle);
				    
					
					Cell cell30 = row.createCell(30);
				    cell30.setCellValue(rs.getString("ENGINE_SPEED").contains("-999") ? "" :  Dformatter1.format(rs.getFloat("ENGINE_SPEED")));
				    cell30.setCellStyle(decimalStyle);
				    
										
					Cell cell31 = row.createCell(31);
				    cell31.setCellValue(rs.getString("FUEL_CONSUMED").contains("-999") ? "" :  Dformatter1.format(rs.getFloat("FUEL_CONSUMED")));
				    cell31.setCellStyle(decimalStyle);
				    
										
					Cell cell32 = row.createCell(32);
				    cell32.setCellValue(rs.getString("FUEL_LEVEL").contains("-999") ? "" :  Dformatter1.format(rs.getFloat("FUEL_LEVEL")));
				    cell32.setCellStyle(decimalStyle);
				    
					
					Cell cell33 = row.createCell(33);
				    cell33.setCellValue(rs.getString("FUEL_PRESSURE").contains("-999") ? "" :  Dformatter1.format(rs.getFloat("FUEL_PRESSURE")));
				    cell33.setCellStyle(decimalStyle);
				    
				    					
					Cell cell34 = row.createCell(34);
				    cell34.setCellValue(rs.getString("FUEL_RATE").contains("-999") ? "" :  Dformatter1.format(rs.getFloat("FUEL_RATE")));
				    cell34.setCellStyle(decimalStyle);
				    
				    					
					Cell cell35 = row.createCell(35);
				    cell35.setCellValue(rs.getString("FUEL_TEMP").contains("-999") ? "" :  Dformatter1.format(rs.getFloat("FUEL_TEMP")));
				    cell35.setCellStyle(decimalStyle);
				    
				    
					Value = "";
					if(rs.getString("HEAD_LIGHT").contains("-999")){
		            	   
		               }else{
		            	   if(rs.getString("HEAD_LIGHT").equals("0")){
		            		   Value="OFF";
		            	   }else{
		            		   Value="ON";
		            	   }
			               
		               }
					Cell cell36 = row.createCell(36);
				    cell36.setCellValue(Value);
				    cell36.setCellStyle(stringStyle);

				   
					Cell cell37 = row.createCell(37);
				    cell37.setCellValue(rs.getString("IMA_PRESSURE").contains("-999") ? "" :  Dformatter1.format(rs.getFloat("IMA_PRESSURE")));
				    cell37.setCellStyle(decimalStyle);
					
					
					Cell cell38 = row.createCell(38);
				    cell38.setCellValue(rs.getString("IN_AIRTEMP").contains("-999") ? "" :  Dformatter1.format(rs.getFloat("IN_AIRTEMP")));
				    cell38.setCellStyle(decimalStyle);
				    	
				    
					Cell cell39 = row.createCell(39);
				    cell39.setCellValue(rs.getString("OIL_PRESSURE").contains("-999") ? "" :  Dformatter1.format(rs.getFloat("OIL_PRESSURE")));
				    cell39.setCellStyle(decimalStyle);
				    
					
					Cell cell40 = row.createCell(40);					
				    cell40.setCellValue(rs.getString("ODOMETER").contains("-999")  ? "" :  Dformatter2.format(rs.getFloat("ODOMETER")));
				    cell40.setCellStyle(decimalStyle1);
				    
										
					Cell cell41 = row.createCell(41);
				    cell41.setCellValue(rs.getString("POWER_INPUT").contains("-999")  ? "" :  Dformatter2.format(rs.getFloat("POWER_INPUT")));
				    cell41.setCellStyle(decimalStyle1);
				    
					Value = "";
					if(rs.getString("PARK_BRAKE").contains("-999")){
		            	   
		               }else{
		            	   if(rs.getString("PARK_BRAKE").equals("0")){
		            		   Value="OFF";
		            	   }else{
		            		   Value="ON";
		            	   }
			               
		               }
					Cell cell42 = row.createCell(42);
				    cell42.setCellValue(Value);
				    cell42.setCellStyle(stringStyle);
					
					
					Cell cell43 = row.createCell(43);
				    cell43.setCellValue(rs.getString("REVERSE").contains("-999")  ? "" :  Dformatter1.format(rs.getFloat("REVERSE")));
				    cell43.setCellStyle(decimalStyle);
				    
	               if(rs.getString("SEAT_BELT").contains("-999")){
	            	   
	               }else{
	            	   
	            	   if(rs.getString("SEAT_BELT").equals("0")){
	            		   Value="OFF";
	            	   }else{
	            		   Value="ON";
	            	   }
		               
	               }      
	               
					Cell cell44 = row.createCell(44);
				    cell44.setCellValue(Value);
				    cell44.setCellStyle(stringStyle);
				    
	               	              
					Cell cell45 = row.createCell(45);
				    cell45.setCellValue(rs.getString("VEHICLE_SPEED").contains("-999")  ? "" :  Dformatter1.format(rs.getFloat("VEHICLE_SPEED")));
				    cell45.setCellStyle(decimalStyle);
				    	              
				}
	           //System.out.println("count=="+count+" jsonarray=="+jsonArray.length());
	           
	           workbook.write(fileOut);
				fileOut.flush();
				fileOut.close();
				
			
	           pstmt.close();
		    	rs.close();
	    } catch (Exception e) {
	  	 e.printStackTrace();
	       } finally {
	           DBConnection.releaseConnectionToDB(conAMS, pstmt, rs);
	       }
		return completePath;
	}
	public JSONArray getVehicleDiagnosticDeatails2x2(int systemId,int clientId,String vehicleNo){

		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		PreparedStatement pstmt1 = null;
		ResultSet rs1 = null;
		PreparedStatement pstmt2 = null;
		ResultSet rs2 = null;
		JSONArray jArr = new JSONArray();
		JSONObject obj = null;
		String regex = "[0-9]+(.[0-9][0-9]+)";
		String parameterValue = "NA";
		
		double convertionFactor=cf.getUnitOfMeasureConvertionsfactor(systemId);
		try{
			con = DBConnection.getConnectionToDB("AMS");
			String ignitionStatus = getIgnitionStatus(systemId,clientId,vehicleNo);
			
			String vehicleModel = "";
			pstmt = con.prepareStatement(OBDStatements.GET_VEHICLE_DETAILS);
			pstmt.setInt(1, systemId);
			pstmt.setString(2, vehicleNo);
			rs = pstmt.executeQuery();
			if(rs.next()){
				vehicleModel = rs.getString("modelId");
			}
			pstmt.close();
			rs.close();
			
			pstmt = con.prepareStatement(OBDStatements.GET_VEHICLLE_LOOKUP_DETAILS_FOR_2X2);
			pstmt.setInt(1, systemId);
			pstmt.setString(2, vehicleModel);
			rs = pstmt.executeQuery();
			while(rs.next()){
				parameterValue = "NA";
				String value = "NA";
				String icon = "icon-grey";
				String field = "";
				String unit = "";
				double pValue=0.0;
				obj = new JSONObject();
				String paramterName= rs.getString("PARAMETER_NAME");
				String columnName = "isnull("+rs.getString("fieldLabel")+",'')";
				String statement = "select "+columnName+" as value from dbo.GPSDATA_LIVE_CANIQ where System_id=? and CLIENTID=? and REGISTRATION_NO=? and LONGITUDE is not null and LATITUDE is not null";
				pstmt1 = con.prepareStatement(statement);
				pstmt1.setInt(1, systemId);
				pstmt1.setInt(2, clientId);
				pstmt1.setString(3, vehicleNo);
				rs1 = pstmt1.executeQuery();
				if(rs1.next()){
					value = rs1.getString("value");
				}
				field = rs.getString("fieldLabel");
				if(field.equalsIgnoreCase("VEHICLE_SPEED")||field.equalsIgnoreCase("ODOMETER")||field.equalsIgnoreCase("DISTANCE_MIL")||field.equalsIgnoreCase("DISTANCE_SCC"))
				{	
					
					if(field.equalsIgnoreCase("ODOMETER")){
						
						if(!value.isEmpty() && value!=null){
							if(!value.equalsIgnoreCase("NA"))
						pValue=Double.parseDouble(value)*convertionFactor;
							pValue=Math.round(pValue);
						}
						value=value.valueOf((int) pValue);
					}else{
						if(!value.isEmpty() && value!=null){
							if(!value.equalsIgnoreCase("NA"))
						pValue=Double.parseDouble(value)*convertionFactor;
						}
						value=value.valueOf(pValue);
					}
				}
				if(field.equalsIgnoreCase("ENG_AVG_FUEL_ECO")){
					
					if(vehicleNo.equalsIgnoreCase("MH12NX6172"))
					value="3.25";
					else if (vehicleNo.equalsIgnoreCase("MH12NX6174")){
					value ="3.2";
					}
				}
				
				
				if(!value.equals("")){
				unit = rs.getString("unit");
				pstmt2 = con.prepareStatement(OBDStatements.GET_VEHICLE_MAP_DETAILS);
				pstmt2.setInt(1, systemId);
				pstmt2.setInt(2, clientId);
				pstmt2.setString(3, rs.getString("parameterId"));
				rs2 = pstmt2.executeQuery();
				if(rs2.next()){
					switch (rs2.getInt("limitType")){
					case 1 : if(field.equals("BLINKER_LIGHT") || field.equals("CLUTCH") || field.equals("BRAKE_PEDAL") || field.equals("DOOR_LOCK") || field.equals("SEAT_BELT") ||
							 	field.equals("PARK_BRAKE") || field.equals("HEAD_LIGHT") || field.equals("CRUISE_CONTROL") || field.equals("AC") || field.equals("ACC_PEDAL_SWITCH")){
							 		if(value.equals("1")){
							 			parameterValue = "ON";
							 		}else{
							 			parameterValue = "OFF";
							 		}
							  }else if(field.equals("DOOR_P") || field.equals("DOOR")){
								  	if(value.equals("1")){
							 			parameterValue = "OPEN";
							 		}else{
							 			parameterValue = "CLOSE";
							 		}
							  }else{
								 parameterValue = Dformatter.format(Double.parseDouble(value));
							  }
							  icon = "icon-green";
							  break;
							 
					case 2 : if(!value.equals("NA")){
							 	parameterValue = Dformatter.format(Double.parseDouble(value));
							 	if(Double.parseDouble(value) > rs2.getDouble("limitValue")){
							 		icon = "icon-red";
							 	}else{
							 		icon = "icon-green";
							 	}
							 }	
							 break;
							 
					case 3 : if(!value.equals("NA")){
							 	parameterValue = Dformatter.format(Double.parseDouble(value));
							 	if(Double.parseDouble(value) < rs2.getDouble("limitValue")){
							 		icon = "icon-red";
							 	}else{
							 		icon = "icon-green";
							 	}
							 }	
					 		 break;
					 
					case 4 : if(!value.equals("NA")){
								parameterValue = value;
								String[] range = parameterValue.split("-");
								String minvalue = range[0];
								String maxValue = range[1];
								if(Double.parseDouble(value) > Double.parseDouble(minvalue) && Double.parseDouble(value) < Double.parseDouble(maxValue)){
									icon = "icon-red";
								}else{
									icon = "icon-green";
								}
							 }	
							 break;
							 
					case 5: if(!value.equals("NA")){
								if(Double.parseDouble(value) == 0){
									parameterValue = "OFF";
								}else{
									parameterValue = "ON";
								}
								if(Double.parseDouble(value) == rs2.getDouble("limitValue")){
									icon = "icon-red";
								}else{
									icon = "icon-green";
								}
							}
							break;
							
					case 6: if(!value.equals("NA")){
								if(Double.parseDouble(value) == 0){
									parameterValue = "CLOSE";
								}else{
									parameterValue = "ON";
								}
								if(Double.parseDouble(value) == rs2.getDouble("limitValue")){
									icon = "icon-red";
								}else{
										icon = "icon-green";
								}
							}
							break;
					
					default : parameterValue = "NA";		
							  icon = "icon-grey";
					}
				}else{
					if(field.equals("BLINKER_LIGHT") || field.equals("CLUTCH") || field.equals("BRAKE_PEDAL") || field.equals("DOOR_LOCK") || field.equals("SEAT_BELT") ||
						 	field.equals("PARK_BRAKE") || field.equals("HEAD_LIGHT") || field.equals("CRUISE_CONTROL") || field.equals("AC") || field.equals("ACC_PEDAL_SWITCH")){
						 		if(value.equals("1")){
						 			parameterValue = "ON";
						 		}else{
						 			parameterValue = "OFF";
						 		}
					}else if(field.equals("DOOR_P") || field.equals("DOOR")){
						if(value.equals("1")){
							parameterValue = "OPEN";
						}else{
							parameterValue = "CLOSE";
						}
					}else{
						if(parameterValue.contains("NA") || parameterValue.equals("")){
							parameterValue = value;
						}else{
							parameterValue = Dformatter.format(value);
						}
					}
					icon = "icon-green";	
				}
				if(field.equals("SPEED") || field.equals("VEHICLE_SPEED")){
					field = "SPEED";
				}
				}
				
				if(parameterValue.matches(regex))  // checking and formating the value if it is decimal and value has not have a limit value
				
					if(!field.equalsIgnoreCase("ODOMETER")){
						parameterValue = String.format("%.2f",Double.parseDouble(parameterValue));
					
					}
				
				obj.put("id", field);
				if(unit.equals("") || parameterValue.equals("NA")){
					obj.put("value", parameterValue);
				}else{
					obj.put("value", parameterValue+" "+unit);
				}
				obj.put("color", icon);
				obj.put("paramName", paramterName);
							
				if ((ignitionStatus.contains("STOPPAGE")||ignitionStatus.contains("IDLE"))){
					if((obj.get("id").toString().equalsIgnoreCase("SPEED"))||obj.get("id").toString().equalsIgnoreCase("ENGINE_SPEED")){
						obj.remove("value");
						obj.put("value", 0 +" "+unit);						
						
					} else if((obj.get("id").toString().equalsIgnoreCase("ENG_DEM_TORQ"))||(obj.get("id").toString().equalsIgnoreCase("ENG_INST_FUEL_ECO"))||(obj.get("id").toString().equalsIgnoreCase("COOLANT_TEMP"))||(obj.get("id").toString().equalsIgnoreCase("OIL_PRESSURE"))||(obj.get("id").toString().equalsIgnoreCase("IMA_PRESSURE"))){
						obj.remove("value");
						obj.put("value","- ");
						
					}
					
				}
				jArr.put(obj);
			}

			String vtg = getVoltage(systemId,clientId,vehicleNo);
			obj = new JSONObject();
			obj.put("id", "BATTERY");
			obj.put("value", vtg+" "+"V");
			obj.put("color", "icon-green");
			obj.put("paramName", "BATTERY VOLTAGE");
			jArr.put(obj);
		}catch(Exception e){
			
			e.printStackTrace();
		}finally{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
			DBConnection.releaseConnectionToDB(null, pstmt1, rs1);
			DBConnection.releaseConnectionToDB(null, pstmt2, rs2);
		}
		return jArr;
	
	}


	public String getIgnitionStatus1(int systemId, int clientId,
			String vehicleNo, int offset) {
		PreparedStatement pstmt = null;
		Connection con = null;
		ResultSet rs = null;
		String ignitionStatus1 = "";
		String gmt = "";
		try{
			con = DBConnection.getConnectionToDB("AMS");

			pstmt = con.prepareStatement(OBDStatements.GET_IGNITION_STATUS1);
			pstmt.setInt(1, offset);
			pstmt.setInt(2, systemId);
			pstmt.setInt(3, clientId);
			pstmt.setString(4, vehicleNo);
			rs = pstmt.executeQuery();
			while(rs.next()){
				if(!rs.getString("gmt").contains("1900") && !rs.getString("gmt").equals("")){
					gmt= sdfyyyymmddhhmmss.format(yyyymmdd.parse(rs.getString("gmt")));
				}
				ignitionStatus1 = rs.getString("ignitionStatus").toUpperCase()+"("+gmt+")";
			}
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return ignitionStatus1;
	}


	public String getIgnitionStatus(int systemId, int clientId,
			String vehicleNo, int offset) {
		// TODO Auto-generated method stub
		return null;
	}
	
}
