package t4u.functions;

import java.io.File;
import java.io.FileOutputStream;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;


import org.apache.commons.lang.SystemUtils;
import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.hssf.util.CellRangeAddress;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.CreationHelper;
import org.apache.poi.ss.usermodel.DataFormat;
import org.apache.poi.ss.usermodel.Font;
import org.apache.poi.ss.usermodel.IndexedColors;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.json.JSONArray;
import org.json.JSONObject;

import com.t4u.activity.VehicleActivity;
import com.t4u.activity.VehicleActivity.DataListBean;

import t4u.GeneralVertical.CommonUtil;
import t4u.beans.MapAPIConfigBean;
import t4u.common.DBConnection;
import t4u.statements.ReportBuilderStatements;
import t4u.util.MapAPIUtil;
import t4u.util.TimeAndDistanceCalculator;

public class ReportBuilderFunctions {
	SimpleDateFormat ddmmyyyy = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
	SimpleDateFormat ddmmyyyyhhmmss = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
	SimpleDateFormat ddmmyyyyhhmmss1 = new SimpleDateFormat("ddMMyyyyHHmmss");
	SimpleDateFormat yyyymmdd = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	DecimalFormat df = new DecimalFormat("00.00");
	SimpleDateFormat sdfFormatDate = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
	CommonFunctions cf = new CommonFunctions();
	MapAPIUtil mapAPIUtil = new MapAPIUtil();
	TimeAndDistanceCalculator tdc  = new TimeAndDistanceCalculator();
	CommonUtil commonUtil = new CommonUtil();
	
	public JSONObject getUserVehicles(int systemId, int clientId, int userId,String zone) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		JSONArray vehArray = new JSONArray();
		JSONArray tripArray = new JSONArray();
		JSONArray hubArray = new JSONArray();
		JSONObject objVeh = null;
		JSONObject objTrip = null;
		JSONObject objHub = null;
		JSONObject finalObj = new JSONObject();
		try{
			con = DBConnection.getConnectionToDB("AMS");
			
			pstmt = con.prepareStatement(ReportBuilderStatements.GET_USER_VEHICLE);
			pstmt.setInt(1, userId);
			pstmt.setInt(2, systemId);
			pstmt.setInt(3, clientId);
			rs = pstmt.executeQuery();
			while(rs.next()){
				objVeh = new JSONObject();
				objVeh.put("key", rs.getString("REGISTRATION_NUMBER"));
				objVeh.put("value", rs.getString("REGISTRATION_NUMBER"));
				vehArray.put(objVeh);
			}
			pstmt.close();
			rs.close();
			
			pstmt = con.prepareStatement(ReportBuilderStatements.GET_TRIP_NAMES);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, clientId);
			rs = pstmt.executeQuery();
			while(rs.next()){
				objTrip = new JSONObject();
				objTrip.put("key", rs.getInt("TRIP_ID"));
				objTrip.put("value", rs.getString("SHIPMENT_ID"));
				tripArray.put(objTrip);
			}
			pstmt.close();
			rs.close();
			
			pstmt = con.prepareStatement(ReportBuilderStatements.GET_HUB_NAMES.replace("#", zone));
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, clientId);
			rs = pstmt.executeQuery();
			while(rs.next()){
				objHub = new JSONObject();
				objHub.put("key", rs.getInt("HUBID"));
				objHub.put("value", rs.getString("NAME"));
				hubArray.put(objHub);
			}
			
			finalObj.put("vehicles", vehArray);
			finalObj.put("trips", tripArray);
			finalObj.put("hubs", hubArray);
		}catch(Exception e){
			e.printStackTrace();
		}
		finally{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return finalObj;
	}

	public JSONArray getReportMaster(int systemId, int clientId, int userId) {
		Connection con = null;
		PreparedStatement pstmt = null, pstmt1 = null, pstmt2 = null;
		ResultSet rs = null, rs1 = null, rs2 = null;
		JSONArray jArr = new JSONArray();
		JSONArray reportArray = null;
		JSONObject obj = null;
		JSONObject objReports = null;
		JSONObject paramObj = null;
		JSONArray paramArr = null;
		try{
			con = DBConnection.getConnectionToDB("AMS");
			// To check Customer Login
			
			pstmt = con.prepareStatement(ReportBuilderStatements.GET_REPORT_CATEGORIES);
			rs = pstmt.executeQuery();
			while(rs.next()){
				obj = new JSONObject();
				reportArray = new JSONArray();
				obj.put("categoryId", rs.getString("CATEGORY_ID"));
				obj.put("categoryName", rs.getString("CATEGORY_NAME"));
				obj.put("enabledSearchCriteria", "Vehicle");
				
				pstmt1 = con.prepareStatement(ReportBuilderStatements.GET_REPORT_MASTER.replace("#", ""));
				pstmt1.setInt(1, rs.getInt("CATEGORY_ID"));
				rs1 = pstmt1.executeQuery();
				while(rs1.next()){
					objReports = new JSONObject();
					paramArr = new JSONArray();
					objReports.put("reportId", rs1.getString("REPORT_ID"));
					objReports.put("reportName", rs1.getString("REPORT_NAME"));
					objReports.put("selectionCriteria", rs1.getString("SELECTION_TYPE"));
					String extraFields = rs1.getString("EXTRA_INPUT_FIELDS");
					if(extraFields != null){
						if(extraFields.equals("radius")){
							objReports.put("showRadius", "true");
						}
					}
					pstmt2 = con.prepareStatement(ReportBuilderStatements.GET_PARAMETERS);
					pstmt2.setInt(1, rs1.getInt("REPORT_ID"));
					rs2 = pstmt2.executeQuery();
					while(rs2.next()){
						paramObj = new JSONObject();
						String index = rs2.getString("PARAMETER_ID");
						paramObj.put(index, rs2.getString("PARAMETER_ALIAS"));
						paramArr.put(paramObj);
					}
					objReports.put("parameters", paramArr);
					objReports.put("selectionType", rs1.getString("singleMulti"));
					objReports.put("reportInfo", rs1.getString("REPORT_INFO"));
					reportArray.put(objReports);
				}
				obj.put("reports", reportArray);
				jArr.put(obj);
			}
		}catch(Exception e){
			e.printStackTrace();
		}
		finally{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
			DBConnection.releaseConnectionToDB(null, pstmt1, rs1);
			DBConnection.releaseConnectionToDB(null, pstmt2, rs2);
		}
		return jArr;
	}

	public JSONArray getGenerateReportDetails(int systemId, int clientId, String reportId, String parameterSelected, String vehicleNo, String startDate,
			String endDate, String trips, int offset) {
		Connection con = null;
		PreparedStatement pstmt = null, pstmt1 = null, pstmt2 = null;
		ResultSet rs = null, rs1 = null, rs2 = null;
		JSONArray arrHeading = new JSONArray();
		JSONArray reportArray = new JSONArray();
		JSONObject objReports = null;
		String stmt = ""; 
		//String[] parameter = parameterSelected.split(",");
		String[] vehicleNos = vehicleNo.split(",");
		try{
			con = DBConnection.getConnectionToDB("AMS");
			String vehicle = "";
			for(int i = 0; i < vehicleNos.length; i++){
				vehicle = vehicle+",'"+vehicleNos[i]+"'";
			}
			pstmt = con.prepareStatement(ReportBuilderStatements.GET_SQL_QUERY);
			pstmt.setString(1, reportId);
			pstmt.setString(2, parameterSelected);
			rs = pstmt.executeQuery();
			if(rs.next()){
				stmt = rs.getString("SQL_QUERY");
				pstmt1 = con.prepareStatement(stmt.replace("#", "and rb.ASSET_NUMBER in ("+vehicle.substring(1,vehicle.length())+")"));
				pstmt1.setInt(1, systemId);
				pstmt1.setInt(2, clientId);
				pstmt1.setInt(3, offset);
				pstmt1.setString(4, yyyymmdd.format(ddmmyyyy.parse(startDate)));
				pstmt1.setInt(5, offset);
				pstmt1.setString(6, yyyymmdd.format(ddmmyyyy.parse(endDate)));
				rs1 = pstmt1.executeQuery();
				List<Integer> timeFiledIndexes = new ArrayList<Integer>();
				List<Integer> dateTimeFieldIndexes = new ArrayList<Integer>();
				
				while(rs1.next()){
					ResultSetMetaData rsmd = rs1.getMetaData();
					if(rs1.getRow() == 1){
						objReports = new JSONObject();
						for(int i = 0; i < rsmd.getColumnCount(); i++){
							arrHeading = getHeadingArray(con, rsmd.getColumnName(i + 1));
							JSONObject heading = arrHeading.getJSONObject(0);
							if (heading.getString("filterType") != null	&& heading.getString("filterType").equals("Time")) {
								timeFiledIndexes.add(i);
							} else if (heading.getString("filterType") != null && heading.getString("filterType").equals("DateTime")) {
								dateTimeFieldIndexes.add(i);
							}
							objReports.put(String.valueOf(i), arrHeading);

						}
						reportArray.put(objReports);
					}
					objReports = new JSONObject();
					for(int j = 0; j < rsmd.getColumnCount(); j++){
						if(timeFiledIndexes.contains(j)){
							objReports.put(String.valueOf(j), rs1.getLong(j+1) >= 0 ?formattedHoursMinutes(rs1.getLong(j+1)) : "-"+ formattedHoursMinutes( -(rs1.getLong(j+1))));
						}else if(dateTimeFieldIndexes.contains(j)){
							if(!rs1.getString(j+1).contains("1900")){
								objReports.put(String.valueOf(j), ddmmyyyy.format(yyyymmdd.parse(rs1.getString(j+1))));
							}else{
								objReports.put(String.valueOf(j),"");
							}
						}
						else{
							objReports.put(String.valueOf(j), rs1.getString(j+1));
						}
					}
					reportArray.put(objReports);
				}
				
				
			/*	
				
				
				while(rs1.next()){
					ResultSetMetaData rsmd = rs1.getMetaData();
					if(rs1.getRow() == 1){
						objReports = new JSONObject();
						for(int i = 0; i < rsmd.getColumnCount(); i++){
							arrHeading = getHeadingArray(con,rsmd.getColumnName(i+1));
							objReports.put(String.valueOf(i), arrHeading);
						}
						reportArray.put(objReports);
					}
					objReports = new JSONObject();
					for(int j = 0; j < rsmd.getColumnCount(); j++){
						 arrHeading = getHeadingArray(con,rsmd.getColumnName(j+1));
							JSONObject heading = arrHeading.getJSONObject(0);
							System.out.println(heading.toString());
							if(heading.getString("filterType") != null && heading.getString("filterType").equals("Time")){
								
							} 
						if (rsmd.getColumnName(j+1).equals("unloadingWaitingTime")){
							objReports.put(String.valueOf(j), formattedDaysHoursMinutes(rs1.getLong(j+1)));
						}else if (rsmd.getColumnName(j+1).equals("clearanceTimeUnloading")){
							objReports.put(String.valueOf(j), rs1.getLong(j+1) >= 0 ?formattedHoursMinutes(rs1.getLong(j+1)) : "-"+ formattedHoursMinutes( -(rs1.getLong(j+1))));
						}else if (rsmd.getColumnName(j+1).equals("unloadingTime")){
							objReports.put(String.valueOf(j), rs1.getLong(j+1) >= 0 ?formattedHoursMinutes(rs1.getLong(j+1)) : "-"+ formattedHoursMinutes( -(rs1.getLong(j+1))));
						}else if (rsmd.getColumnName(j+1).equals("travelDelayTime")){ 
							objReports.put(String.valueOf(j), rs1.getLong(j+1) >= 0 ?formattedHoursMinutes(rs1.getLong(j+1)) : "-"+ formattedHoursMinutes( -(rs1.getLong(j+1))));
						}else if (rsmd.getColumnName(j+1).equals("travelTime")){ 
							objReports.put(String.valueOf(j), rs1.getLong(j+1) >= 0 ?formattedHoursMinutes(rs1.getLong(j+1)) : "-"+ formattedHoursMinutes( -(rs1.getLong(j+1))));
						}else if (rsmd.getColumnName(j+1).equals("unscheduledStoppgae")){ 
							objReports.put(String.valueOf(j), rs1.getLong(j+1) >= 0 ?formattedHoursMinutes(rs1.getLong(j+1)) : "-"+ formattedHoursMinutes( -(rs1.getLong(j+1))));
						}else if (rsmd.getColumnName(j+1).equals("delayDeparture")){ 
							objReports.put(String.valueOf(j), rs1.getLong(j+1) >= 0 ?formattedHoursMinutes(rs1.getLong(j+1)) : "-"+ formattedHoursMinutes( -(rs1.getLong(j+1))));
						}else if (rsmd.getColumnName(j+1).equals("loadingClearance")){ 
							objReports.put(String.valueOf(j), rs1.getLong(j+1) >= 0 ?formattedHoursMinutes(rs1.getLong(j+1)) : "-"+ formattedHoursMinutes( -(rs1.getLong(j+1))));
						}else if (rsmd.getColumnName(j+1).equals("LoadingDuration")){ 
							objReports.put(String.valueOf(j), rs1.getLong(j+1) >= 0 ?formattedHoursMinutes(rs1.getLong(j+1)) : "-"+ formattedHoursMinutes( -(rs1.getLong(j+1))));
						}else if (rsmd.getColumnName(j+1).equals("WaitingForLoading")){ 
							objReports.put(String.valueOf(j), rs1.getLong(j+1) >= 0 ?formattedHoursMinutes(rs1.getLong(j+1)) : "-"+ formattedHoursMinutes( -(rs1.getLong(j+1))));
						}else if (rsmd.getColumnName(j+1).equals("avgPlacementTime")){ 
							objReports.put(String.valueOf(j), rs1.getLong(j+1) >= 0 ?formattedHoursMinutes(rs1.getLong(j+1)) : "-"+ formattedHoursMinutes( -(rs1.getLong(j+1))));
						}else{ 
							objReports.put(String.valueOf(j), rs1.getString(j+1));
						}
					}
					reportArray.put(objReports);
				}*/
			}
		}catch(Exception e){
			e.printStackTrace();
		}
		finally{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
			DBConnection.releaseConnectionToDB(null, pstmt1, rs1);
			DBConnection.releaseConnectionToDB(null, pstmt2, rs2);
		}
		return reportArray;
	}
	
	public JSONArray getGenerateReportDetailsFromTrackTrip(int systemId, int clientId, String reportId, String parameterSelected, String vehicleNo, String startDate,
			String endDate, String trips, int offset) {
		Connection con = null;
		PreparedStatement pstmt = null, pstmt1 = null, pstmt2 = null;
		ResultSet rs = null, rs1 = null, rs2 = null;
		JSONArray arrHeading = new JSONArray();
		JSONArray reportArray = new JSONArray();
		JSONObject objReports = null;
		String stmt = ""; 
		//String[] parameter = parameterSelected.split(",");
		String[] vehicleNos = vehicleNo.split(",");
		try{
			con = DBConnection.getConnectionToDB("AMS");
			String vehicle = "";
			for(int i = 0; i < vehicleNos.length; i++){
				vehicle = vehicle+",'"+vehicleNos[i]+"'";
			}
			pstmt = con.prepareStatement(ReportBuilderStatements.GET_SQL_QUERY);
			pstmt.setString(1, reportId);
			pstmt.setString(2, parameterSelected);
			rs = pstmt.executeQuery();
			if(rs.next()){
				stmt = rs.getString("SQL_QUERY");
				pstmt1 = con.prepareStatement(stmt.replace("#", "and td.ASSET_NUMBER in ("+vehicle.substring(1,vehicle.length())+")"));
				pstmt1.setInt(1, systemId);
				pstmt1.setInt(2, clientId);
				pstmt1.setInt(3, offset);
				pstmt1.setString(4, yyyymmdd.format(ddmmyyyy.parse(startDate)));
				pstmt1.setInt(5, offset);
				pstmt1.setString(6, yyyymmdd.format(ddmmyyyy.parse(endDate)));
				rs1 = pstmt1.executeQuery();
				List<Integer> timeFiledIndexes = new ArrayList<Integer>();
				List<Integer> dateTimeFieldIndexes = new ArrayList<Integer>();
				while(rs1.next()){
					ResultSetMetaData rsmd = rs1.getMetaData();
					if(rs1.getRow() == 1){
						objReports = new JSONObject();
						for(int i = 0; i < rsmd.getColumnCount(); i++){
							arrHeading = getHeadingArray(con, rsmd.getColumnName(i + 1));
							JSONObject heading = arrHeading.getJSONObject(0);
							if (heading.getString("filterType") != null	&& heading.getString("filterType").equals("Time")) {
								timeFiledIndexes.add(i);
							} else if (heading.getString("filterType") != null && heading.getString("filterType").equals("DateTime")) {
								dateTimeFieldIndexes.add(i);
							}
							objReports.put(String.valueOf(i), arrHeading);

						}
						reportArray.put(objReports);
					}
					objReports = new JSONObject();
					for(int j = 0; j < rsmd.getColumnCount(); j++){
						if(timeFiledIndexes.contains(j)){
							objReports.put(String.valueOf(j), rs1.getLong(j+1) >= 0 ?formattedHoursMinutes(rs1.getLong(j+1)) : "-"+ formattedHoursMinutes( -(rs1.getLong(j+1))));
						}else if(dateTimeFieldIndexes.contains(j)){
							if(!rs1.getString(j+1).contains("1900")){
								objReports.put(String.valueOf(j), ddmmyyyy.format(yyyymmdd.parse(rs1.getString(j+1))));
							}else{
								objReports.put(String.valueOf(j),"");
							}
						}
						else{
							objReports.put(String.valueOf(j), rs1.getString(j+1));
						}
					}
					reportArray.put(objReports);
				}
			}
		}catch(Exception e){
			e.printStackTrace();
		}
		finally{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
			DBConnection.releaseConnectionToDB(null, pstmt1, rs1);
			DBConnection.releaseConnectionToDB(null, pstmt2, rs2);
		}
		return reportArray;
	}
		
	public JSONArray getGenerateReportDetails1(int systemId, int clientId, String reportId, String parameterSelected, String vehicleNo, String startDate,
			String endDate, String trips, int offset) {
		Connection con = null;
		PreparedStatement pstmt = null, pstmt1 = null, pstmt2 = null;
		ResultSet rs = null, rs1 = null, rs2 = null;
		JSONArray arrHeading = new JSONArray();
		JSONArray reportArray = new JSONArray();
		JSONObject objReports = null;
		String stmt = ""; 
		String[] vehicleNos = vehicleNo.split(",");
		try{
			con = DBConnection.getConnectionToDB("AMS");
			String vehicle = "";
			for(int i = 0; i < vehicleNos.length; i++){
				vehicle = vehicle+",'"+vehicleNos[i]+"'";
			}
			pstmt = con.prepareStatement(ReportBuilderStatements.GET_SQL_QUERY);
			pstmt.setString(1, reportId);
			pstmt.setString(2, parameterSelected);
			rs = pstmt.executeQuery();
			if(rs.next()){
				stmt = rs.getString("SQL_QUERY");
				pstmt1 = con.prepareStatement(stmt.replace("#", "and rb.ASSET_NUMBER in ("+vehicle.substring(1,vehicle.length())+")"));
				pstmt1.setString(1, yyyymmdd.format(ddmmyyyy.parse(endDate)));
				pstmt1.setString(2, yyyymmdd.format(ddmmyyyy.parse(startDate)));
				pstmt1.setString(3, yyyymmdd.format(ddmmyyyy.parse(endDate)));
				pstmt1.setString(4, yyyymmdd.format(ddmmyyyy.parse(startDate)));
				pstmt1.setInt(5, clientId);
				pstmt1.setInt(6, systemId);
				pstmt1.setInt(7, systemId);
				pstmt1.setInt(8, clientId);
				pstmt1.setInt(9, offset);
				pstmt1.setString(10, yyyymmdd.format(ddmmyyyy.parse(startDate)));
				pstmt1.setInt(11, offset);
				pstmt1.setString(12, yyyymmdd.format(ddmmyyyy.parse(endDate)));
				pstmt1.setString(13, yyyymmdd.format(ddmmyyyy.parse(startDate)));
				rs1 = pstmt1.executeQuery();
				while(rs1.next()){
					ResultSetMetaData rsmd = rs1.getMetaData();
					if(rs1.getRow() == 1){
						objReports = new JSONObject();
						for(int i = 0; i < rsmd.getColumnCount(); i++){
							arrHeading = getHeadingArray(con,rsmd.getColumnName(i+1));
							objReports.put(String.valueOf(i), arrHeading);
						}
						reportArray.put(objReports);
					}
					objReports = new JSONObject();
					for(int j = 0; j < rsmd.getColumnCount(); j++){
						int finalObject=rsmd.getColumnCount()-1;
						if(j==finalObject){
							objReports.put(String.valueOf(j), formattedDaysHoursMinutes(rs1.getLong(j+1)));
						}else{
							objReports.put(String.valueOf(j), rs1.getString(j+1));
						}
						
					}
					reportArray.put(objReports);
				}
			}
		}catch(Exception e){
			e.printStackTrace();
		}
		finally{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
			DBConnection.releaseConnectionToDB(null, pstmt1, rs1);
			DBConnection.releaseConnectionToDB(null, pstmt2, rs2);
		}
		return reportArray;
	}

	public JSONArray getLoadingUnloadingTimeReport(int systemId, int clientId, String reportId, String parameterSelected, String vehicleNo, String startDate,
			String endDate, String trips, int offset) {
		Connection con = null;
		PreparedStatement pstmt = null, pstmt1 = null, pstmt2 = null;
		ResultSet rs = null, rs1 = null, rs2 = null;
		JSONArray arrHeading = new JSONArray();
		JSONArray reportArray = new JSONArray();
		JSONObject objReports = null;
		String stmt = ""; 
		String[] vehicleNos = vehicleNo.split(",");
		try{
			con = DBConnection.getConnectionToDB("AMS");
			String vehicle = "";
			for(int i = 0; i < vehicleNos.length; i++){
				vehicle = vehicle+",'"+vehicleNos[i]+"'";
			}
			pstmt = con.prepareStatement(ReportBuilderStatements.GET_SQL_QUERY);
			pstmt.setString(1, reportId);
			pstmt.setString(2, parameterSelected);
			rs = pstmt.executeQuery();
			if(rs.next()){
				stmt = rs.getString("SQL_QUERY");
				pstmt1 = con.prepareStatement(stmt.replaceAll("#", "and td.ASSET_NUMBER in ("+vehicle.substring(1,vehicle.length())+")"));
				if(parameterSelected.equals("customer")){
					pstmt1.setInt(1, systemId);
					pstmt1.setInt(2, clientId);
					pstmt1.setInt(3, offset);
					pstmt1.setString(4, yyyymmdd.format(ddmmyyyy.parse(startDate)));
					pstmt1.setInt(5, offset);
					pstmt1.setString(6, yyyymmdd.format(ddmmyyyy.parse(endDate)));
				}
				else{
					pstmt1.setInt(1, offset);
					pstmt1.setString(2, yyyymmdd.format(ddmmyyyy.parse(startDate)));
					pstmt1.setInt(3, offset);
					pstmt1.setString(4, yyyymmdd.format(ddmmyyyy.parse(endDate)));
					pstmt1.setInt(5, systemId);
					pstmt1.setInt(6, clientId);
					pstmt1.setInt(7, offset);
					pstmt1.setString(8, yyyymmdd.format(ddmmyyyy.parse(startDate)));
					pstmt1.setInt(9, offset);
					pstmt1.setString(10, yyyymmdd.format(ddmmyyyy.parse(endDate)));
				}
				rs1 = pstmt1.executeQuery();
				List<Integer> datetimeFiledIndexes = new ArrayList<Integer>();
				while(rs1.next()){
					ResultSetMetaData rsmd = rs1.getMetaData();
					if(rs1.getRow() == 1){
						objReports = new JSONObject();
						for(int i = 0; i < rsmd.getColumnCount(); i++){
							arrHeading = getHeadingArray(con,rsmd.getColumnName(i+1));
							JSONObject heading = arrHeading.getJSONObject(0);
							if(heading.getString("filterType") != null && heading.getString("filterType").equals("Time")){
								datetimeFiledIndexes.add(i);
							}
							objReports.put(String.valueOf(i), arrHeading);
						}
						reportArray.put(objReports);
					}
					objReports = new JSONObject();
					for(int j = 0; j < rsmd.getColumnCount(); j++){
						if(datetimeFiledIndexes.contains(j)){
							objReports.put(String.valueOf(j), rs1.getLong(j+1) >= 0 ?formattedHoursMinutes(rs1.getLong(j+1)) : "-"+ formattedHoursMinutes( -(rs1.getLong(j+1))));
						}else{
							objReports.put(String.valueOf(j), rs1.getString(j+1));
						}
					}
					reportArray.put(objReports);
				}
			}
		}catch(Exception e){
			e.printStackTrace();
		}
		finally{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
			DBConnection.releaseConnectionToDB(null, pstmt1, rs1);
			DBConnection.releaseConnectionToDB(null, pstmt2, rs2);
		}
		return reportArray;
	}

	public JSONArray getUnloadingToNextLoadReport(int systemId, int clientId, String reportId, String parameterSelected, String vehicleNo, String startDate,
			String endDate, String trips, int offset) {
		Connection con = null;
		PreparedStatement pstmt = null, pstmt1 = null, pstmt2 = null;
		ResultSet rs = null, rs1 = null, rs2 = null;
		JSONArray reportArray = new JSONArray();
		JSONObject objReports = null;
		String stmt = ""; 
		String[] vehicleNos = vehicleNo.split(",");
		try{
			con = DBConnection.getConnectionToDB("AMS");
			String vehicle = "";
			for(int i = 0; i < vehicleNos.length; i++){
				vehicle = vehicle+",'"+vehicleNos[i]+"'";
			}
			//Get all asset types
			ArrayList<String> assetTypeList = new ArrayList<String>();
			pstmt = con.prepareStatement(ReportBuilderStatements.GET_VEHICLE_TYPES);
			pstmt.setInt(1, systemId);
			rs = pstmt.executeQuery();
			objReports = new JSONObject();
			int i=1;
			JSONArray jArr = new JSONArray();
			JSONObject obj = new JSONObject();
			if(parameterSelected.equals("customerHub")){
				obj.put("title", "CUSTOMER HUB");
			}
			else if(parameterSelected.equals("hubCity")){
				obj.put("title", "LOCATION(CITY)");
			}
			obj.put("filter", "FALSE");
			jArr.put(obj);
			objReports.put("0", jArr);
			while(rs.next()){
				jArr = new JSONArray();
				obj = new JSONObject();
				assetTypeList.add(rs.getString("VehicleType"));
				obj.put("title", rs.getString("VehicleType")+" (DD:HH:MM)");
				obj.put("filter", "FALSE");
				jArr.put(obj);
				objReports.put(String.valueOf(i), jArr);
				i++;
			}
			reportArray.put(objReports);
			pstmt = con.prepareStatement(ReportBuilderStatements.GET_SQL_QUERY);
			pstmt.setString(1, reportId);
			pstmt.setString(2, parameterSelected);
			rs = pstmt.executeQuery();
			if(rs.next()){
				stmt = rs.getString("SQL_QUERY");
				pstmt1 = con.prepareStatement(stmt.replaceAll("#", "and td.ASSET_NUMBER in ("+vehicle.substring(1,vehicle.length())+")"));
				pstmt1.setInt(1, systemId);
				pstmt1.setInt(2, clientId);
				pstmt1.setInt(3, offset);
				pstmt1.setString(4, yyyymmdd.format(ddmmyyyy.parse(startDate)));
				pstmt1.setInt(5, offset);
				pstmt1.setString(6, yyyymmdd.format(ddmmyyyy.parse(endDate)));
				rs1 = pstmt1.executeQuery();
				//Get asset types
				HashMap<String,JSONObject> hubToTimeMap = new HashMap<String, JSONObject>();
				while(rs1.next()){
					String name = "";
					if(parameterSelected.equals("customerHub")){
						name = rs1.getString("CustomerHub");
					}
					else if(parameterSelected.equals("hubCity")){
						name = rs1.getString("hubCity");
					}
					int index = assetTypeList.indexOf(rs1.getString("TruckType"));
					if(hubToTimeMap.containsKey(name)){
						obj = hubToTimeMap.get(name);
						obj.put(String.valueOf(index+1), formattedDaysHoursMinutes(rs1.getLong("unloadingToNextLoad")));
					}else{
						obj = new JSONObject();
						obj.put("0", name);
						for(int j=1;j<=assetTypeList.size();j++){
							obj.put(String.valueOf(j), "");
						}
						obj.put(String.valueOf(index+1), formattedDaysHoursMinutes(rs1.getLong("unloadingToNextLoad")));
						hubToTimeMap.put(name, obj);
					}
				}
				//Itertae thru map and put JSONObj in reportArray
				for (JSONObject value : hubToTimeMap.values()){
					reportArray.put(value);
			    }
			}
		}catch(Exception e){
			e.printStackTrace();
		}
		finally{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
			DBConnection.releaseConnectionToDB(null, pstmt1, rs1);
			DBConnection.releaseConnectionToDB(null, pstmt2, rs2);
		}
		return reportArray;
	}


	public JSONArray getUnloadingTimeDetentionReport(int systemId, int clientId, String reportId, String parameterSelected, String vehicleNo, String startDate,
			String endDate, String trips, int offset) {
		Connection con = null;
		PreparedStatement pstmt = null, pstmt1 = null, pstmt2 = null;
		ResultSet rs = null, rs1 = null, rs2 = null;
		JSONArray reportArray = new JSONArray();
		JSONObject objReports = null;
		JSONArray arrHeading = new JSONArray();
		String stmt = ""; 
		String[] vehicleNos = vehicleNo.split(",");
		try{
			con = DBConnection.getConnectionToDB("AMS");
			String vehicle = "";
			for(int i = 0; i < vehicleNos.length; i++){
				vehicle = vehicle+",'"+vehicleNos[i]+"'";
			}
			
			pstmt = con.prepareStatement(ReportBuilderStatements.GET_SQL_QUERY);
			pstmt.setString(1, reportId);
			pstmt.setString(2, parameterSelected);
			rs = pstmt.executeQuery();
			if(rs.next()){
				stmt = rs.getString("SQL_QUERY");
				pstmt1 = con.prepareStatement(stmt.replaceAll("#", "and td.ASSET_NUMBER in ("+vehicle.substring(1,vehicle.length())+")"));
				pstmt1.setInt(1, systemId);
				pstmt1.setInt(2, clientId);
				pstmt1.setInt(3, offset);
				pstmt1.setString(4, yyyymmdd.format(ddmmyyyy.parse(startDate)));
				pstmt1.setInt(5, offset);
				pstmt1.setString(6, yyyymmdd.format(ddmmyyyy.parse(endDate)));
				pstmt1.setInt(7, systemId);
				pstmt1.setInt(8, clientId);
				pstmt1.setInt(9, offset);
				pstmt1.setString(10, yyyymmdd.format(ddmmyyyy.parse(startDate)));
				pstmt1.setInt(11, offset);
				pstmt1.setString(12, yyyymmdd.format(ddmmyyyy.parse(endDate)));
				pstmt1.setInt(13, systemId);
				pstmt1.setInt(14, clientId);
				pstmt1.setInt(15, offset);
				pstmt1.setString(16, yyyymmdd.format(ddmmyyyy.parse(startDate)));
				pstmt1.setInt(17, offset);
				pstmt1.setString(18, yyyymmdd.format(ddmmyyyy.parse(endDate)));
				pstmt1.setInt(19, systemId);
				pstmt1.setInt(20, clientId);
				pstmt1.setInt(21, offset);
				pstmt1.setString(22, yyyymmdd.format(ddmmyyyy.parse(startDate)));
				pstmt1.setInt(23, offset);
				pstmt1.setString(24, yyyymmdd.format(ddmmyyyy.parse(endDate)));
				pstmt1.setInt(25, systemId);
				pstmt1.setInt(26, clientId);
				pstmt1.setInt(27, offset);
				pstmt1.setString(28, yyyymmdd.format(ddmmyyyy.parse(startDate)));
				pstmt1.setInt(29, offset);
				pstmt1.setString(30, yyyymmdd.format(ddmmyyyy.parse(endDate)));
				rs1 = pstmt1.executeQuery();
				//Get asset types
				HashMap<String,JSONObject> hubToTimeMap = new HashMap<String, JSONObject>();
				while(rs1.next()){
					ResultSetMetaData rsmd = rs1.getMetaData();
					if(rs1.getRow() == 1){
						objReports = new JSONObject();
						for(int i = 0; i < rsmd.getColumnCount(); i++){
							System.out.println(rsmd.getColumnName(i+1));
//							if (rsmd.getColumnName(i+1).equalsIgnoreCase("truck") || rsmd.getColumnName(i+1).equalsIgnoreCase("detentiontime")) {
//								arrHeading = getHeadingArray(con,"0to8 Hours");
//								objReports.put(String.valueOf(i), arrHeading);
//								i++;
//								arrHeading = getHeadingArray(con,"8to16_Hours");
//								objReports.put(String.valueOf(i), arrHeading);
//								i++;
//								arrHeading = getHeadingArray(con,"16to24_Hours");
//								objReports.put(String.valueOf(i), arrHeading);
//								i++;
//								arrHeading = getHeadingArray(con,"24to48_Hours");
//								objReports.put(String.valueOf(i), arrHeading);
//								i++;
//								arrHeading = getHeadingArray(con,"grt48_Hours");
//								objReports.put(String.valueOf(i), arrHeading);
//								i++;
//							}else{
//								arrHeading = getHeadingArray(con,rsmd.getColumnName(i+1));
//								objReports.put(String.valueOf(i), arrHeading);
//							}
							arrHeading = getHeadingArray(con,rsmd.getColumnName(i+1));
							objReports.put(String.valueOf(i), arrHeading);
						}
						reportArray.put(objReports);
					}
					objReports = new JSONObject();
					for(int j = 0; j < rsmd.getColumnCount(); j++){
//						System.out.println(rs1.getString(j+1));
						objReports.put(String.valueOf(j), rs1.getString(j+1));
					}
					reportArray.put(objReports);
				}
				//Itertae thru map and put JSONObj in reportArray
				for (JSONObject value : hubToTimeMap.values()){
					reportArray.put(value);
			    }
			}
		}catch(Exception e){
			e.printStackTrace();
		}
		finally{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
			DBConnection.releaseConnectionToDB(null, pstmt1, rs1);
			DBConnection.releaseConnectionToDB(null, pstmt2, rs2);
		}
		return reportArray;
	}
	
	private JSONArray getHeadingArray(Connection con,String columnName) {
		JSONArray jArr = new JSONArray();
		PreparedStatement pstmt = null;
		JSONObject obj = null;
		ResultSet rs = null;
		try{
			pstmt = con.prepareStatement(ReportBuilderStatements.GET_COLUMN_DESC);
			pstmt.setString(1, columnName.toUpperCase());
			rs = pstmt.executeQuery();
			if(rs.next()){
				obj = new JSONObject();
				obj.put("title", rs.getString("COLUMN_NAME"));
				obj.put("filter", rs.getString("FILTER"));
				if(!rs.getString("FILTER_TYPE").equals("")){
					obj.put("filterType", rs.getString("FILTER_TYPE"));
				}else{
					obj.put("filterType", "");
				}
				jArr.put(obj);
			}
		}catch(Exception e){
			e.printStackTrace();
		}
		return jArr;
	}

	public JSONArray getGenerateReportDetailsUsingVehicleActivity(int systemId,	int clientId, String reportId, String parameterSelected, String vehicleNo,
			String startDate, String endDate, String trips,	int offset) {
		Connection con = null;
		PreparedStatement pstmt = null, pstmt1 = null;
		ResultSet rs = null, rs1 = null;
		JSONArray arrHeading = new JSONArray();
		JSONArray reportArray = new JSONArray();
		JSONObject objReports = null;
		JSONObject objHeading = null;
		//String[] parameter = parameterSelected.split(",");
		String[] vehicleNos = vehicleNo.split(",");
		String stmt = "";
		try{
			con = DBConnection.getConnectionToDB("AMS");
			
			String vehicle = "";
			for(int i = 0; i < vehicleNos.length; i++){
				vehicle = vehicle+",'"+vehicleNos[i]+"'";
			}
			
			switch(Integer.parseInt(reportId)){
				case 38:
					try{
						LinkedList<DataListBean> activityReportList = new LinkedList<DataListBean>();
						VehicleActivity vi = new VehicleActivity(con,vehicleNos[0], ddmmyyyyhhmmss.parse(startDate), ddmmyyyyhhmmss.parse(endDate), offset, systemId, clientId, 0);
						activityReportList = vi.getFinalList();
						
						objReports = new JSONObject();
						
						objHeading = new JSONObject();
						arrHeading = new JSONArray();
						objHeading.put("title", "Date Time");
						objHeading.put("filter", "TRUE");
						objHeading.put("filterType", "Date");
						arrHeading.put(objHeading);
						objReports.put("0", arrHeading);
						
						objHeading = new JSONObject();
						arrHeading = new JSONArray();
						objHeading.put("title", "Location");
						objHeading.put("filter", "TRUE");
						objHeading.put("filterType", "Text");
						arrHeading.put(objHeading);
						objReports.put("1", arrHeading);
						
						objHeading = new JSONObject();
						arrHeading = new JSONArray();
						objHeading.put("title", "Speed(km/h)");
						objHeading.put("filter", "TRUE");
						objHeading.put("filterType", "Number");
						arrHeading.put(objHeading);
						objReports.put("2", arrHeading);
						
						reportArray.put(objReports);
						
						for (int i = 0; i < activityReportList.size(); i++) {
							DataListBean dlb = activityReportList.get(i);
							if (dlb.getSpeed() > 0) {
								JSONObject obj = new JSONObject();
								obj.put("0", ddmmyyyy.format(dlb.getGpsDateTime()));
								String loc = "";
								if (dlb.getLocation() == null) {
									loc = "";
								} else {
									loc = dlb.getLocation().toString();
								}
								obj.put("1", loc);
	
								String speeddetails = df.format(dlb.getSpeed());
								obj.put("2", speeddetails);
								reportArray.put(obj);
							}
						}
					}
					catch(Exception e){
						e.printStackTrace();
					}
					break;
				
				case 39:
					try{
						pstmt = con.prepareStatement(ReportBuilderStatements.GET_SQL_QUERY);
						pstmt.setString(1, reportId);
						pstmt.setString(2, parameterSelected);
						rs = pstmt.executeQuery();
						if(rs.next()){
						stmt = rs.getString("SQL_QUERY");
						if(parameterSelected.equals("truck") || parameterSelected.equals("truckOEM")){
							pstmt1 = con.prepareStatement(stmt.replaceAll("#", " and RegistrationNo in ("+vehicle.substring(1,vehicle.length())+")"));
							pstmt1.setInt(1, systemId);
							pstmt1.setInt(2, clientId);
							pstmt1.setInt(3, offset);
							pstmt1.setString(4, yyyymmdd.format(ddmmyyyy.parse(startDate)));
							pstmt1.setInt(5, offset);
							pstmt1.setString(6, yyyymmdd.format(ddmmyyyy.parse(endDate)));
							pstmt1.setInt(7, systemId);
							pstmt1.setInt(8, clientId);
							pstmt1.setInt(9, offset);
							pstmt1.setString(10, yyyymmdd.format(ddmmyyyy.parse(startDate)));
							pstmt1.setInt(11, offset);
							pstmt1.setString(12, yyyymmdd.format(ddmmyyyy.parse(endDate)));
							rs1 = pstmt1.executeQuery();
							while(rs1.next()){
								ResultSetMetaData rsmd = rs1.getMetaData();
								if(rs1.getRow() == 1){
									objReports = new JSONObject();
									for(int i = 0; i < rsmd.getColumnCount(); i++){
										arrHeading = getHeadingArray(con,rsmd.getColumnName(i+1));
										objReports.put(String.valueOf(i), arrHeading);
									}
									reportArray.put(objReports);
								}
								objReports = new JSONObject();
								objReports.put("0", rs1.getString(1));
								String totalDur = rs1.getString(2).replace(".", ":");
								String [] dur = totalDur.split(":");
								long minutes = Long.parseLong(dur[0]) * 60 + Long.parseLong(dur[1]) / 60 + Long.parseLong(dur[1]) % 60;
								objReports.put("1", formattedDaysHoursMinutes(minutes));
								reportArray.put(objReports);
							}
						}else{
							pstmt1 = con.prepareStatement(stmt.replace("#", " and rb.ASSET_NUMBER in ("+vehicle.substring(1,vehicle.length())+")"));
							pstmt1.setInt(1, systemId);
							pstmt1.setInt(2, clientId);
							pstmt1.setInt(3, offset);
							pstmt1.setString(4, yyyymmdd.format(ddmmyyyy.parse(startDate)));
							pstmt1.setInt(5, offset);
							pstmt1.setString(6, yyyymmdd.format(ddmmyyyy.parse(endDate)));
							rs1 = pstmt1.executeQuery();
							while(rs1.next()){
								ResultSetMetaData rsmd = rs1.getMetaData();
								if(rs1.getRow() == 1){
									objReports = new JSONObject();
									for(int i = 0; i < rsmd.getColumnCount(); i++){
										arrHeading = getHeadingArray(con,rsmd.getColumnName(i+1));
										objReports.put(String.valueOf(i), arrHeading);
									}
									reportArray.put(objReports);
								}
								objReports = new JSONObject();
								objReports.put("0", rs1.getString(1));
								objReports.put("1", formattedDaysHoursMinutes(rs1.getLong(2)));
								reportArray.put(objReports);
							}
						}
					}
					}catch(Exception e){
						e.printStackTrace();
					}	
					break;
				case 30 :
					try{
						pstmt = con.prepareStatement(ReportBuilderStatements.GET_SQL_QUERY);
						pstmt.setString(1, reportId);
						pstmt.setString(2, parameterSelected);
						rs = pstmt.executeQuery();
						if(rs.next()){
							stmt = rs.getString("SQL_QUERY");
							pstmt1 = con.prepareStatement(stmt.replaceAll("#", " and RegistrationNo in ("+vehicle.substring(1,vehicle.length())+")"));
							pstmt1.setInt(1, systemId);
							pstmt1.setInt(2, clientId);
							pstmt1.setInt(3, offset);
							pstmt1.setString(4, yyyymmdd.format(ddmmyyyy.parse(startDate)));
							pstmt1.setInt(5, offset);
							pstmt1.setString(6, yyyymmdd.format(ddmmyyyy.parse(endDate)));
							pstmt1.setInt(7, systemId);
							pstmt1.setInt(8, clientId);
							pstmt1.setInt(9, offset);
							pstmt1.setString(10, yyyymmdd.format(ddmmyyyy.parse(startDate)));
							pstmt1.setInt(11, offset);
							pstmt1.setString(12, yyyymmdd.format(ddmmyyyy.parse(endDate)));
							rs1 = pstmt1.executeQuery();
							while(rs1.next()){
								ResultSetMetaData rsmd = rs1.getMetaData();
								if(rs1.getRow() == 1){
									objReports = new JSONObject();
									for(int i = 0; i < rsmd.getColumnCount(); i++){
										arrHeading = getHeadingArray(con,rsmd.getColumnName(i+1));
										objReports.put(String.valueOf(i), arrHeading);
									}
									reportArray.put(objReports);
								}
								objReports = new JSONObject();
								objReports.put("0", rs1.getString(1));
								objReports.put("1", rs1.getString(2));
								reportArray.put(objReports);
							}
						}	
					}catch(Exception e){
						e.printStackTrace();
					}
					break;
				case 2:
					try{
						pstmt = con.prepareStatement(ReportBuilderStatements.GET_SQL_QUERY);
						pstmt.setString(1, reportId);
						pstmt.setString(2, parameterSelected);
						rs = pstmt.executeQuery();
						if(rs.next()){
							stmt = rs.getString("SQL_QUERY");
							pstmt1 = con.prepareStatement(stmt.replaceAll("#", " and VEHICLE_NUMBER in ("+vehicle.substring(1,vehicle.length())+")"));
							pstmt1.setInt(1, offset);
							pstmt1.setString(2, yyyymmdd.format(ddmmyyyy.parse(startDate)));
							pstmt1.setInt(3, offset);
							pstmt1.setString(4, yyyymmdd.format(ddmmyyyy.parse(startDate)));
							pstmt1.setInt(5, offset);
							pstmt1.setString(6, yyyymmdd.format(ddmmyyyy.parse(endDate)));
							pstmt1.setInt(7, offset);
							pstmt1.setString(8, yyyymmdd.format(ddmmyyyy.parse(endDate)));
							pstmt1.setInt(9, systemId);
							pstmt1.setInt(10, clientId);
							pstmt1.setInt(11, offset);
							pstmt1.setString(12, yyyymmdd.format(ddmmyyyy.parse(startDate)));
							pstmt1.setInt(13, offset);
							pstmt1.setString(14, yyyymmdd.format(ddmmyyyy.parse(endDate)));
							rs1 = pstmt1.executeQuery();
							while(rs1.next()){
								ResultSetMetaData rsmd = rs1.getMetaData();
								if(rs1.getRow() == 1){
									objReports = new JSONObject();
									for(int i = 0; i < rsmd.getColumnCount(); i++){
										arrHeading = getHeadingArray(con,rsmd.getColumnName(i+1));
										objReports.put(String.valueOf(i), arrHeading);
									}
									reportArray.put(objReports);
								}
								objReports = new JSONObject();
								objReports.put("0", rs1.getString(1));
								objReports.put("1", formattedDaysHoursMinutes(rs1.getLong(2)));
								reportArray.put(objReports);
							}
						}	
					}catch(Exception e){
						e.printStackTrace();
					}
					break;
				case 40:   // SLA report
					try{
						pstmt = con.prepareStatement(ReportBuilderStatements.GET_SQL_QUERY);  
						pstmt.setString(1, reportId);
						pstmt.setString(2, parameterSelected);
						rs = pstmt.executeQuery();
						if(rs.next()){
							stmt = rs.getString("SQL_QUERY");
							// dont use $ symbol in query as it has been used for offset
							stmt  = stmt.replace("$", ""+offset+"");
							pstmt1 = con.prepareStatement(stmt.replaceAll("#", " and ASSET_NUMBER in ("+vehicle.substring(1,vehicle.length())+")"));
							pstmt1.setInt(1, systemId);
							pstmt1.setInt(2, clientId);
							pstmt1.setString(3, yyyymmdd.format(ddmmyyyy.parse(startDate)));
							pstmt1.setString(4, yyyymmdd.format(ddmmyyyy.parse(endDate)));

							rs1 = pstmt1.executeQuery();
							List<Integer> timeFiledIndexes = new ArrayList<Integer>();
							List<Integer> dateTimeFieldIndexes = new ArrayList<Integer>();
							while(rs1.next()){
								ResultSetMetaData rsmd = rs1.getMetaData();
								if(rs1.getRow() == 1){
									objReports = new JSONObject();
									for(int i = 0; i < rsmd.getColumnCount(); i++){
										arrHeading = getHeadingArray(con,rsmd.getColumnName(i+1));
										JSONObject heading = arrHeading.getJSONObject(0);
										if(heading.getString("filterType") != null && heading.getString("filterType").equals("Time")){
											timeFiledIndexes.add(i);
										}else if(heading.getString("filterType") != null && heading.getString("filterType").equals("DateTime")){
											dateTimeFieldIndexes.add(i);
										}
										objReports.put(String.valueOf(i), arrHeading);
									}
									reportArray.put(objReports);
								}
								objReports = new JSONObject();
								for(int j = 0; j < rsmd.getColumnCount(); j++){
									if(timeFiledIndexes.contains(j)){
										if(rs1.getInt(j+1) >0){
											objReports.put(String.valueOf(j), cf.convertMinutesToHHMMFormat(rs1.getInt(j+1)));
										}else{
											objReports.put(String.valueOf(j), cf.convertMinutesToHHMMFormatNegative(rs1.getInt(j+1)));
										}
									}else if(dateTimeFieldIndexes.contains(j)){
										if(!rs1.getString(j+1).contains("1900")){
											objReports.put(String.valueOf(j), ddmmyyyy.format(yyyymmdd.parse(rs1.getString(j+1))));
										}else{
											objReports.put(String.valueOf(j),"");
										}
									}
									else{
										objReports.put(String.valueOf(j), rs1.getString(j+1));
									}
								}
								reportArray.put(objReports);
							}
						}	
					}catch(Exception e){
						e.printStackTrace();
					}
					break;
				case 41:
					try{
						pstmt = con.prepareStatement(ReportBuilderStatements.GET_SQL_QUERY);
						pstmt.setString(1, reportId);
						pstmt.setString(2, parameterSelected);
						rs = pstmt.executeQuery();
						if(rs.next()){
						stmt = rs.getString("SQL_QUERY");
						if(parameterSelected.equals("truck") || parameterSelected.equals("truckOEM")){
							pstmt1 = con.prepareStatement(stmt.replaceAll("#", " and RegistrationNo in ("+vehicle.substring(1,vehicle.length())+")"));
							pstmt1.setInt(1, systemId);
							pstmt1.setInt(2, clientId);
							pstmt1.setInt(3, offset);
							pstmt1.setString(4, yyyymmdd.format(ddmmyyyy.parse(startDate)));
							pstmt1.setInt(5, offset);
							pstmt1.setString(6, yyyymmdd.format(ddmmyyyy.parse(endDate)));
							pstmt1.setInt(7, systemId);
							pstmt1.setInt(8, clientId);
							pstmt1.setInt(9, offset);
							pstmt1.setString(10, yyyymmdd.format(ddmmyyyy.parse(startDate)));
							pstmt1.setInt(11, offset);
							pstmt1.setString(12, yyyymmdd.format(ddmmyyyy.parse(endDate)));
							rs1 = pstmt1.executeQuery();
							while(rs1.next()){
								ResultSetMetaData rsmd = rs1.getMetaData();
								if(rs1.getRow() == 1){
									objReports = new JSONObject();
									for(int i = 0; i < rsmd.getColumnCount(); i++){
										arrHeading = getHeadingArray(con,rsmd.getColumnName(i+1));
										objReports.put(String.valueOf(i), arrHeading);
									}
									reportArray.put(objReports);
								}
								objReports = new JSONObject();
								objReports.put("0", rs1.getString(1));
								String totalDur = rs1.getString(2).replace(".", ":");
								String [] dur = totalDur.split(":");
								long minutes = Long.parseLong(dur[0]) * 60 + Long.parseLong(dur[1]) / 60 + Long.parseLong(dur[1]) % 60;
								objReports.put("1", formattedDaysHoursMinutes(minutes));
								reportArray.put(objReports);
							}
						}else{
							pstmt1 = con.prepareStatement(stmt.replace("#", " and rb.ASSET_NUMBER in ("+vehicle.substring(1,vehicle.length())+")"));
							pstmt1.setInt(1, systemId);
							pstmt1.setInt(2, clientId);
							pstmt1.setInt(3, offset);
							pstmt1.setString(4, yyyymmdd.format(ddmmyyyy.parse(startDate)));
							pstmt1.setInt(5, offset);
							pstmt1.setString(6, yyyymmdd.format(ddmmyyyy.parse(endDate)));
							rs1 = pstmt1.executeQuery();
							while(rs1.next()){
								ResultSetMetaData rsmd = rs1.getMetaData();
								if(rs1.getRow() == 1){
									objReports = new JSONObject();
									for(int i = 0; i < rsmd.getColumnCount(); i++){
										arrHeading = getHeadingArray(con,rsmd.getColumnName(i+1));
										objReports.put(String.valueOf(i), arrHeading);
									}
									reportArray.put(objReports);
								}
								objReports = new JSONObject();
								objReports.put("0", rs1.getString(1));
								objReports.put("1", formattedDaysHoursMinutes(rs1.getLong(2)));
								reportArray.put(objReports);
							}
						}
					}
					}catch(Exception e){
						e.printStackTrace();
					}	
					break;
				case 43:
					reportArray = getRevenueNonRevenueReport(con,reportId,parameterSelected,systemId,clientId,offset,startDate,endDate,vehicle);
					break;
				case 20:
					reportArray = getSmartHubPercentOnTimeDelayed(con,reportId,parameterSelected,systemId,clientId,offset,startDate,endDate,vehicle);
					break;
				case 21:
					reportArray = getSmartHubPercentOnTimeDelayed(con,reportId,parameterSelected,systemId,clientId,offset,startDate,endDate,vehicle);
					break;
				case 22:
					reportArray = getSmartHubPercentOnTimeDelayed(con,reportId,parameterSelected,systemId,clientId,offset,startDate,endDate,vehicle);
					break;
					
				case 50:   // SLA Delay report
					try{
						pstmt = con.prepareStatement(ReportBuilderStatements.GET_SQL_QUERY);  
						pstmt.setString(1, reportId);
						pstmt.setString(2, parameterSelected);
						rs = pstmt.executeQuery();
						if(rs.next()){
							stmt = rs.getString("SQL_QUERY");
							pstmt1 = con.prepareStatement(stmt.replace("#", " and ds.HUB_ID in ("+vehicle.substring(1,vehicle.length())+")"));
							pstmt1.setInt(1, systemId);
							pstmt1.setInt(2, clientId);
							
							rs1 = pstmt1.executeQuery();
							/*while(rs1.next()){
								ResultSetMetaData rsmd = rs1.getMetaData();
								if(rs1.getRow() == 1){
									objReports = new JSONObject();
									for(int i = 0; i < rsmd.getColumnCount(); i++){
										arrHeading = getHeadingArray(con,rsmd.getColumnName(i+1));
										objReports.put(String.valueOf(i), arrHeading);
									}
									reportArray.put(objReports);
								}
								objReports = new JSONObject();
								for(int j = 0; j < rsmd.getColumnCount(); j++){
									objReports.put(String.valueOf(j), rs1.getString(j+1));
								}
								reportArray.put(objReports);
							}*/
							List<Integer> timeFiledIndexes = new ArrayList<Integer>();
							List<Integer> dateTimeFieldIndexes = new ArrayList<Integer>();
							while(rs1.next()){
								ResultSetMetaData rsmd = rs1.getMetaData();
								if(rs1.getRow() == 1){
									objReports = new JSONObject();
									for(int i = 0; i < rsmd.getColumnCount(); i++){
										arrHeading = getHeadingArray(con,rsmd.getColumnName(i+1));
										JSONObject heading = arrHeading.getJSONObject(0);
										if(heading.getString("filterType") != null && heading.getString("filterType").equals("Time")){
											timeFiledIndexes.add(i);
										}else if(heading.getString("filterType") != null && heading.getString("filterType").equals("DateTime")){
											dateTimeFieldIndexes.add(i);
										}
										objReports.put(String.valueOf(i), arrHeading);
									}
									reportArray.put(objReports);
								}
								objReports = new JSONObject();
								for(int j = 0; j < rsmd.getColumnCount(); j++){
									if(timeFiledIndexes.contains(j)){
										if(rs1.getInt(j+1) >0){
											objReports.put(String.valueOf(j), cf.convertMinutesToHHMMFormat(rs1.getInt(j+1)));
										}else{
											objReports.put(String.valueOf(j), cf.convertMinutesToHHMMFormatNegative(rs1.getInt(j+1)));
										}
									}else if(dateTimeFieldIndexes.contains(j)){
										if(!rs1.getString(j+1).contains("1900")){
											objReports.put(String.valueOf(j), ddmmyyyy.format(yyyymmdd.parse(rs1.getString(j+1))));
										}else{
											objReports.put(String.valueOf(j),"");
										}
									}
									else{
										objReports.put(String.valueOf(j), rs1.getString(j+1));
									}
								}
								reportArray.put(objReports);
							}
						}	
					}catch(Exception e){
						e.printStackTrace();
					}
					break;
			}
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return reportArray;
	}
	
	private JSONArray getSmartHubPercentOnTimeDelayed(Connection con,String reportId, String parameterSelected, int systemId,
														int clientId, int offset, String startDate, String endDate,String vehicle) {
		JSONArray arrHeading = new JSONArray();
		JSONArray reportArray = new JSONArray();
		try{
			PreparedStatement pstmt = con.prepareStatement(ReportBuilderStatements.GET_SQL_QUERY);
			pstmt.setString(1, reportId);
			pstmt.setString(2, parameterSelected);
			ResultSet rs = pstmt.executeQuery();
			JSONObject objReports;
			if(rs.next()){
			String stmt = rs.getString("SQL_QUERY");
			PreparedStatement pstmt1 = null;
				pstmt1 = con.prepareStatement(stmt.replaceAll("#","and ttd.ASSET_NUMBER in ("+vehicle.substring(1,vehicle.length())+")"));
				
				pstmt1.setInt(1, systemId);
				pstmt1.setInt(2, clientId);
				pstmt1.setInt(3, offset);
				pstmt1.setString(4, yyyymmdd.format(ddmmyyyyhhmmss.parse(startDate)));
				pstmt1.setInt(5, offset);
				pstmt1.setString(6, yyyymmdd.format(ddmmyyyyhhmmss.parse(endDate)));
				pstmt1.setInt(7, offset);
				pstmt1.setString(8, yyyymmdd.format(ddmmyyyyhhmmss.parse(startDate)));
				pstmt1.setInt(9, offset);
				pstmt1.setString(10, yyyymmdd.format(ddmmyyyyhhmmss.parse(endDate)));
				ResultSet rs1 = pstmt1.executeQuery();
				
				while(rs1.next()){
					ResultSetMetaData rsmd = rs1.getMetaData();
					if(rs1.getRow() == 1){
						objReports = new JSONObject();
						for(int i = 0; i < rsmd.getColumnCount(); i++){
							arrHeading = getHeadingArray(con,rsmd.getColumnName(i+1));
							objReports.put(String.valueOf(i), arrHeading);
						}
						reportArray.put(objReports);
					}
					objReports = new JSONObject();
					for(int j = 0; j < rsmd.getColumnCount(); j++){
						if (rsmd.getColumnName(j+1).equals("avgChangeOver")){
							objReports.put(String.valueOf(j), rs1.getLong(j+1) >= 0 ?formattedHoursMinutes(rs1.getLong(j+1)) : "-"+ formattedHoursMinutes( -(rs1.getLong(j+1))));
						}else{
							objReports.put(String.valueOf(j), rs1.getString(j+1));
						}
						
					}
					reportArray.put(objReports);
				}
		}
		}catch(Exception e){
			e.printStackTrace();
		}	
		return reportArray;
	}

	private JSONArray getRevenueNonRevenueReport(Connection con,String reportId,String parameterSelected,
												int systemId,int clientId,int offset,String startDate,String endDate,String vehicle){
		JSONArray arrHeading = new JSONArray();
		JSONArray reportArray = new JSONArray();
		try{
			PreparedStatement pstmt = con.prepareStatement(ReportBuilderStatements.GET_SQL_QUERY);
			pstmt.setString(1, reportId);
			pstmt.setString(2, parameterSelected);
			ResultSet rs = pstmt.executeQuery();
			JSONObject objReports;
			if(rs.next()){
			String stmt = rs.getString("SQL_QUERY");
			PreparedStatement pstmt1 = null;
				pstmt1 = con.prepareStatement(stmt.replace("#","and RegistrationNo in ("+vehicle.substring(1,vehicle.length())+")"));
				pstmt1.setInt(1, offset);
				pstmt1.setString(2, yyyymmdd.format(ddmmyyyyhhmmss.parse(startDate)));
				pstmt1.setInt(3, offset);
				pstmt1.setString(4, yyyymmdd.format(ddmmyyyyhhmmss.parse(endDate)));
				pstmt1.setInt(5, systemId);
				pstmt1.setInt(6, clientId);
				ResultSet rs1 = pstmt1.executeQuery();
				while(rs1.next()){
					ResultSetMetaData rsmd = rs1.getMetaData();
					if(rs1.getRow() == 1){
						objReports = new JSONObject();
						for(int i = 0; i < rsmd.getColumnCount(); i++){
							arrHeading = getHeadingArray(con,rsmd.getColumnName(i+1));
							objReports.put(String.valueOf(i), arrHeading);
						}
						reportArray.put(objReports);
					}
					objReports = new JSONObject();
					for(int j = 0; j < rsmd.getColumnCount(); j++){
						objReports.put(String.valueOf(j), rs1.getString(j+1));
					}
					reportArray.put(objReports);
				}
		}
		}catch(Exception e){
			e.printStackTrace();
		}	
		return reportArray;
	}
	
	public JSONArray getIncomingVehicleReport(int systemId,int clientId,String reportId, String parameterSelected,String hubId,String startDate,String endDate,String trips,int offset,int radius,String key){
				JSONArray arrHeading = new JSONArray();
				JSONArray reportArray = new JSONArray();
				Connection con = null;
				MapAPIConfigBean mapAPIConfigBean  = null;
				try{
				con = DBConnection.getConnectionToDB("AMS");
				mapAPIConfigBean  = mapAPIUtil.getConfiguration(systemId);
				PreparedStatement pstmt = con.prepareStatement(ReportBuilderStatements.GET_SQL_QUERY);
				pstmt.setString(1, reportId);
				pstmt.setString(2, parameterSelected);
				ResultSet rs = pstmt.executeQuery();
				JSONObject objReports;
				if(rs.next()){
						String stmt = rs.getString("SQL_QUERY");
						PreparedStatement pstmt1 = null;
						pstmt1 = con.prepareStatement(stmt.replace("#", " and ds.HUB_ID="+hubId));
						pstmt1.setInt(1, offset);
						ResultSet rs1 = pstmt1.executeQuery();
						while(rs1.next()){
							ResultSetMetaData rsmd = rs1.getMetaData();
								if(rs1.getRow() == 1){
									objReports = new JSONObject();
									for(int i = 0; i < rsmd.getColumnCount(); i++){
									//if column name not equal to  vehicleLng, vehicleLat,hubLng,hubLat
									if(rsmd.getColumnName(i+1).equals("vehicleLng") ||rsmd.getColumnName(i+1).equals("vehicleLat")
										||rsmd.getColumnName(i+1).equals("hubLng") || rsmd.getColumnName(i+1).equals("hubLat")|| rsmd.getColumnName(i+1).equals("speed")){
										continue;
									}
									else{
										arrHeading = getHeadingArray(con,rsmd.getColumnName(i+1));
										objReports.put(String.valueOf(i), arrHeading);
									}
								}
									reportArray.put(objReports);
							}
						objReports = new JSONObject();
						
						
						double distance = 0;
						ArrayList<Double>  list = commonUtil.getDistanceFromOsm(Double.parseDouble(rs1.getString("vehicleLat")), Double.parseDouble(rs1.getString("vehicleLng")), 
								Double.parseDouble(rs1.getString("hubLat")), Double.parseDouble(rs1.getString("hubLng")));

						if(list != null && list.size()>0){
							distance = list.get(0);
						}
						if(distance == 0){
							distance = commonUtil.getDistanceFromGoogleAPI(Double.parseDouble(rs1.getString("vehicleLat")), Double.parseDouble(rs1.getString("vehicleLng")), 
																			Double.parseDouble(rs1.getString("hubLat")), Double.parseDouble(rs1.getString("hubLng")),key,mapAPIConfigBean).get(0);
						}
						
						//Show the vehicles which are present inside the radius
						if(distance <= radius){
							for(int j = 0; j < rsmd.getColumnCount(); j++){
								if(rsmd.getColumnName(j+1).equals("vehicleLng") ||rsmd.getColumnName(j+1).equals("vehicleLat")
										||rsmd.getColumnName(j+1).equals("hubLng") || rsmd.getColumnName(j+1).equals("hubLat")){
										continue;
									}
								if(rsmd.getColumnName(j+1).equals("distance")){
									objReports.put(String.valueOf(j), distance);
								}else if(rsmd.getColumnName(j+1).equals("speed")){
//									String speed = rs1.getString(j+1); //calulate ETA
//									objReports.put(String.valueOf(j), distance);
								}else if (rsmd.getColumnName(j+1).equals("ETA")){
									objReports.put(String.valueOf(j), ddmmyyyy.format(yyyymmdd.parse(rs1.getString(j+1))));
								}else{
									objReports.put(String.valueOf(j), rs1.getString(j+1));
								}
							}
							reportArray.put(objReports);
						}
						
				}
			}
			}catch(Exception e){
					e.printStackTrace();
			}	
		return reportArray;
}
	

	public String formattedDaysHoursMinutes(long fromMin) {
		String formateddaysHoursMinutes = "";
		try {
			long day = fromMin / (1440);
			long hours = (fromMin / 60) % 24;
			long minutes = fromMin % 60;
			String min=String.valueOf(minutes);
			String hr=String.valueOf(hours);
			String dd=String.valueOf(day);
			if(String.valueOf(minutes).length()==1){min = "0"+ minutes;}
			if(String.valueOf(hours).length()==1){hr = "0"+ hours;}
			if(String.valueOf(day).length()==1){dd = "0"+ day;}
	        formateddaysHoursMinutes = dd + ":" + hr + ":" + min;    

		} catch (Exception e) {
			e.printStackTrace();
		}
		return formateddaysHoursMinutes;
	}
	
	public String formattedHoursMinutes(long fromMin) {
		String formateddaysHoursMinutes = "";
		try {
			long seconds=fromMin*60;
			long hr = seconds / 60;
			long min = hr % 60;
			hr = hr / 60;
			String minutes= "";
			if(min <0){
				minutes = String.valueOf(Math.abs(min));
			}else{
				minutes = String.valueOf(min);
			}
			String hour=String.valueOf(hr);
			if(String.valueOf(min).length()==1){minutes = "0"+ min;}
			if(String.valueOf(hr).length()==1){hour = "0"+ hr;}
			
			if(min < 0  && hr >=0){
				formateddaysHoursMinutes = "-"+ hour + ":" + minutes ;    
			}else{
				formateddaysHoursMinutes = hour + ":" + minutes ;
			}

		} catch (Exception e) {
			e.printStackTrace();
		}
		return formateddaysHoursMinutes;
	}
	

	public String DownloadExcel(int systemId, int clientId, int userId,
			JSONArray tableData,String reportName,String startDate,String endDate,String reportInfo,String vehicleNo) {
		String message=null;
		try {
			ArrayList<String> columnArray =null;
			ArrayList<String> dataTypeArray =null;
			//JSONObject obj = new JSONObject(tableData.toString());
			JSONArray jsonArray = tableData;//(JSONArray) obj.get("tableReponsejson");


			Workbook workbook = new HSSFWorkbook(); //new XSSFWorkbook() for generating `.xls` file

			/* CreationHelper helps us create instances of various things like DataFormat, 
		           Hyperlink, RichTextString etc, in a format (HSSF, XSSF) independent way */
			CreationHelper createHelper = workbook.getCreationHelper();
			
			String[] vehArr = vehicleNo.split(",");
						
			// Create a Sheet
			Sheet sheet = workbook.createSheet("Report");
			Row rowHeading=sheet.createRow(0);
			sheet.createFreezePane(0, 5);
			
			HSSFCellStyle orangeStyle = (HSSFCellStyle) workbook.createCellStyle();
			orangeStyle.setAlignment(CellStyle.ALIGN_CENTER);
			orangeStyle.setFillForegroundColor(IndexedColors.ORANGE.index);
			orangeStyle.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
			orangeStyle.setBorderTop((short) 1); // single line border
			orangeStyle.setBorderBottom((short) 1); // single line border
			Cell titleCellC1 = rowHeading.createCell(0);
			titleCellC1.setCellStyle(orangeStyle);
			titleCellC1.setCellValue(reportName + (vehicleNo.split(",").length == 1 ? ("--" + vehicleNo) : ""));
			sheet.addMergedRegion(new CellRangeAddress(0,(short)0,0,(short)20));
			
			Row row1=sheet.createRow(1);
			
			Cell titleCellC2 = row1.createCell(0);
			titleCellC2.setCellValue("Start Date : " + startDate+"         " + "End Date : " +endDate);
			
			// Create a Font for styling header cells
			Font headerFont = workbook.createFont();
			// headerFont.setBoldweight(); //.setBoldweight(true);
			headerFont.setFontHeightInPoints((short) 12);
			headerFont.setColor(IndexedColors.BLUE.getIndex());

			// Create a CellStyle with the font
			CellStyle headerCellStyle = workbook.createCellStyle();
			headerCellStyle.setFont(headerFont);


			int rowNum = 5;
			JSONObject columnObj = new JSONObject(jsonArray.get(0).toString());
			columnArray = new ArrayList<String>();
			dataTypeArray = new ArrayList<String>();
			 columnArray.add("Sl No.");
			for (int i = 0; i < columnObj.length(); i++) {

				JSONArray colArray = (JSONArray) columnObj.get(String.valueOf(i));
				
				for (int j = 0; j < colArray.length(); j++) {
					JSONObject headerobj = new JSONObject(colArray.get(j).toString());
					columnArray.add(headerobj.get("title").toString());
					dataTypeArray.add((headerobj.has("filterType"))?headerobj.get("filterType").toString():"Text");
				}
			}
			
			// Create a Row
			 Row headerRow = sheet.createRow(4);

			// Create cells
			
			for (int i = 0; i <columnArray.size(); i++) {
				 Cell cell = headerRow.createCell(i);
		            cell.setCellValue(columnArray.get(i));
		            cell.setCellStyle(headerCellStyle);
			}
			

			// Create Cell Style for formatting Date
			CellStyle dateCellStyle = workbook.createCellStyle();
			dateCellStyle.setDataFormat(createHelper.createDataFormat().getFormat("dd/MM/yyyy HH:mm:ss"));

			// Create Cell Style for formatting as Text
			CellStyle timeCellStyle = workbook.createCellStyle();
			DataFormat fmt = workbook.createDataFormat();
			timeCellStyle.setDataFormat( fmt.getFormat("@"));



			for (int i = 1; i < jsonArray.length(); i++) {
				JSONObject rowData = new JSONObject(jsonArray.get(i).toString());
				int eleLength=rowData.length();
				Row row = sheet.createRow(rowNum++);
				row.createCell(0).setCellValue(i);
				for (int j = 0; j < eleLength; j++) {
					//System.out.println(rowData.get(String.valueOf(j)));
					int  cellNo=j+1;
					
					Cell cell = row.createCell(cellNo);
					String value = rowData.get(String.valueOf(j)).toString();
					
					if(dataTypeArray.get(j).equalsIgnoreCase("Number")){
						cell.setCellValue(Double.valueOf(value));
					}else{
						cell.setCellValue(value);
						cell.setCellStyle(timeCellStyle);
					}
					
				}

			}
			rowNum++;
			Row rowInfo=sheet.createRow(rowNum++);
			if(reportInfo != null && !reportInfo.equals("")){
				reportInfo = reportInfo.replaceAll("\\<.*?\\>", "");
				Cell titleCellC3 = rowInfo.createCell(0);
				titleCellC3.setCellValue("Info:"+reportInfo);
				sheet.addMergedRegion(new CellRangeAddress(0,(short)0,0,(short)30));
			}
			Date date = new Date();
			String path = "";
			if(SystemUtils.IS_OS_LINUX || SystemUtils.IS_OS_UNIX){
				path = "/opt/cluster/platform/filePath/Reports/CrystalReports/ReportBuilder"+ddmmyyyyhhmmss1.format(date)+".xls";
			}else{
				path = "c://Reports/CrystalReports/ReportBuilder"+ddmmyyyyhhmmss1.format(date)+".xls";
			}
			FileOutputStream fileOut = new FileOutputStream(path);
			workbook.write(fileOut);
			fileOut.close();
			// ((FileOutputStream) workbook).close();
			String tempPath = "";
			if(SystemUtils.IS_OS_LINUX || SystemUtils.IS_OS_UNIX){
				tempPath = "/opt/cluster/platform/filePath/Reports/CrystalReports/ReportBuilder"+ddmmyyyyhhmmss1.format(date)+".xls";
			}else{
				tempPath = "c://Reports/CrystalReports/ReportBuilder"+ddmmyyyyhhmmss1.format(date)+".xls";
			}
			File tmpDir = new File(tempPath);
			boolean exists = tmpDir.exists();
			if (exists) {
				if (SystemUtils.IS_OS_LINUX || SystemUtils.IS_OS_UNIX) {
					message = "/opt/cluster/platform/filePath/Reports/CrystalReports/ReportBuilder"
							+ ddmmyyyyhhmmss1.format(date) + ".xls";
				} else {
					message = "c://Reports/CrystalReports/ReportBuilder" + ddmmyyyyhhmmss1.format(date) + ".xls";
				}
			}


		} catch (Exception e) {
			e.printStackTrace();
			message="Failed to Download Report";
		}
		return message;
	}

	public JSONArray getReportWithRegistrationNo(int systemId, int clientId, String reportId, String parameterSelected, String vehicleNo,
			String startDate, String endDate, String trips, int offset) {
		Connection con = null;
		PreparedStatement pstmt = null, pstmt1 = null;
		ResultSet rs = null, rs1 = null;
		JSONArray arrHeading = new JSONArray();
		JSONArray reportArray = new JSONArray();
		JSONObject objReports = null;
		String stmt = ""; 
		//String[] parameter = parameterSelected.split(",");
		String[] vehicleNos = vehicleNo.split(",");
		try{
			con = DBConnection.getConnectionToDB("AMS");
			String vehicle = "";
			for(int i = 0; i < vehicleNos.length; i++){
				vehicle = vehicle+",'"+vehicleNos[i]+"'";
			}
			pstmt = con.prepareStatement(ReportBuilderStatements.GET_SQL_QUERY);
			pstmt.setString(1, reportId);
			pstmt.setString(2, parameterSelected);
			rs = pstmt.executeQuery();
			if(rs.next()){
				stmt = rs.getString("SQL_QUERY");
				pstmt1 = con.prepareStatement(stmt.replace("#", "and rb.REGISTRATION_NO in ("+vehicle.substring(1,vehicle.length())+")"));
				pstmt1.setInt(1, systemId);
				pstmt1.setInt(2, clientId);
				pstmt1.setInt(3, offset);
				pstmt1.setString(4, yyyymmdd.format(ddmmyyyy.parse(startDate)));
				pstmt1.setInt(5, offset);
				pstmt1.setString(6, yyyymmdd.format(ddmmyyyy.parse(endDate)));
				rs1 = pstmt1.executeQuery();
				while(rs1.next()){
					ResultSetMetaData rsmd = rs1.getMetaData();
					if(rs1.getRow() == 1){
						objReports = new JSONObject();
						for(int i = 0; i < rsmd.getColumnCount(); i++){
							arrHeading = getHeadingArray(con,rsmd.getColumnName(i+1));
							objReports.put(String.valueOf(i), arrHeading);
						}
						reportArray.put(objReports);
					}
					objReports = new JSONObject();
					for(int j = 0; j < rsmd.getColumnCount(); j++){
						String value = rs1.getString(j+1);
						if(rs1.getString(j+1).contains("1900") || rs1.getString(j+1).contains("1899")){
							value = "";
						}
						objReports.put(String.valueOf(j), value);
					}
					reportArray.put(objReports);
				}
			}
		}catch(Exception e){
			e.printStackTrace();
		}
		finally{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
			DBConnection.releaseConnectionToDB(null, pstmt1, rs1);
		}
		return reportArray;
	}
	
	public JSONArray consolidatedDelayReport(int systemId, int clientId, String reportId, String parameterSelected, String vehicleNo,
			String startDate, String endDate, String trips, int offset,int userId) {
		Connection con = null;
		PreparedStatement pstmt = null, pstmt1 = null;
		ResultSet rs = null, rs1 = null;
		JSONArray arrHeading = new JSONArray();
		JSONArray reportArray = new JSONArray();
		JSONArray ja1,ja2,ja3,ja4,ja5,ja6,ja7,ja8,ja9,ja10,ja11 ;
		ja1 = new JSONArray();
		ja2 = new JSONArray();
		ja3 = new JSONArray();
		ja4 = new JSONArray();
		ja5 = new JSONArray();
		ja6 = new JSONArray();
		ja7 = new JSONArray();
		ja8 = new JSONArray();
		ja9 = new JSONArray();
		ja10 = new JSONArray();
		ja11 = new JSONArray();
		List<JSONArray> jar = new ArrayList<JSONArray>();
		JSONObject objReports = null;
		String[] vehicleNos = vehicleNo.split(",");
		try{
			con = DBConnection.getConnectionToDB("AMS");
			int timeBandInt = 0;
			//timeBandInt = timeBandInt * 60 * 1000;
			boolean impreciseSetting = false;
            impreciseSetting = CheckImpreciseSetting(userId, systemId,con);
			String vehicle = "";
			for(int i = 0; i < vehicleNos.length; i++){
				vehicle = vehicle+",'"+vehicleNos[i]+"'";
			}
			
			ArrayList<String> headers = new ArrayList<String>();
			//headers.add("TripId");
			headers.add("category");
			headers.add("startDateAndTime");
			headers.add("startLocation");
			headers.add("endDateAndTime");
			headers.add("endLocation");
			headers.add("duration");
			
			objReports = new JSONObject();
			for(int i = 0; i < headers.size(); i++){
				arrHeading = getHeadingArray(con,headers.get(i));
				objReports.put(String.valueOf(i), arrHeading);
			}
			
			startDate = getLocalDateTime(startDate,offset);
			endDate = getLocalDateTime(endDate,offset);
			
			reportArray.put(objReports);
			
			
			pstmt = con.prepareStatement(ReportBuilderStatements.GET_TRIP_DETAILS_FOR_GIVEN_TRIP_IDS);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, clientId);
			pstmt.setString(3, vehicleNo);
			
			rs = pstmt.executeQuery();
			while(rs.next()){
				String tripId = rs.getString("SHIPMENT_ID");
				String vehicleNumber = rs.getString("ASSET_NUMBER");
				String tripstarttime = rs.getString("ACTUAL_TRIP_START_TIME");
				String tripendtime = rs.getString("ACTUAL_TRIP_END_TIME");
				LinkedList<DataListBean> activityReportList = new LinkedList<DataListBean>();
				VehicleActivity vi = null;
				if(impreciseSetting == true){
					  vi = new VehicleActivity(con,
								vehicleNumber, yyyymmdd.parse(tripstarttime),
								yyyymmdd.parse(tripendtime), offset, systemId,
								clientId, timeBandInt,userId);
					  }else{
						  vi = new VehicleActivity(con,
									vehicleNumber, yyyymmdd.parse(tripstarttime),
									yyyymmdd.parse(tripendtime), offset, systemId,
									clientId, timeBandInt);
					  }
				
				activityReportList = vi.getFinalList();
				
				try {
					double speed = 0;
					String startloc = "";
					String endloc = "";
		            Date startDateOfPacket = null;
		            Date endDateOfPacket = null;
		            String category = "";
		            String category1 = "";
		            String category2 = "";
		            String previousCategory = "";
		            int counter = 0;
		            if (activityReportList.size() > 0){
					for (int i = 0; i < activityReportList.size(); i++) {

						DataListBean dlb = activityReportList.get(i);

						if (i == 0) {
							startloc = dlb.getLocation() == null ? "" : dlb.getLocation().toString();
						}
						if (i == (activityReportList.size() - 1)) {
							endloc = dlb.getLocation() == null ? "" : dlb.getLocation().toString();
						}

						String cat = dlb.getCategory();
						
						if (cat.equals("STOPPAGE")){
							Calendar calendar1 = Calendar.getInstance();
							calendar1.setTime(dlb.getGpsDateTime());
							calendar1.add(calendar1.MILLISECOND, (int) dlb.getStopTime());
							objReports = new JSONObject();
							//objReports.put("0", tripId);
							objReports.put("0", "STOPPAGE");
							objReports.put("1", ddmmyyyyhhmmss.format(dlb.getGpsDateTime()));
							objReports.put("2", dlb.getLocation().toString());
							objReports.put("3", ddmmyyyyhhmmss.format(calendar1.getTime()));
							objReports.put("4", dlb.getLocation().toString());
							objReports.put("5",	cf.convertMillisecondsToHHMMSSFormat(dlb.getStopTime()));
							ja1.put(objReports);
							
						}else if (cat.equals("IDLE")){
							Calendar calende = Calendar.getInstance();
							calende.setTime(dlb.getGpsDateTime());
							calende.add(calende.MILLISECOND, (int) dlb.getIdleTime());
							objReports = new JSONObject();
							//objReports.put("0", tripId);
							objReports.put("0", "IDLE");
							objReports.put("1", ddmmyyyyhhmmss.format(dlb.getGpsDateTime()));
							objReports.put("2", dlb.getLocation().toString());
							objReports.put("3", ddmmyyyyhhmmss.format(calende.getTime()));
							objReports.put("4", dlb.getLocation().toString());
							objReports.put("5",	cf.convertMillisecondsToHHMMSSFormat(dlb.getIdleTime()));
							ja2.put(objReports);
							
						}else if (cat.equals("RUNNING")){
						speed = dlb.getSpeed();
						category = checkCategory((int) (speed));
						if (i == 0) {
							previousCategory = category;
							startDateOfPacket = dlb.getGpsDateTime();
							endDateOfPacket = dlb.getGpsDateTime();
							endloc = dlb.getLocation().toString();
						}
						if ((!category.equals("category0"))) {
							if (previousCategory.equals(category)) {
								category1 = category;
							} else {
								endDateOfPacket = dlb.getGpsDateTime();
								endloc = dlb.getLocation().toString();
								category2 = getCategory(category1);
								if (category2.length() > 0) {
									counter++;
									objReports = new JSONObject();
									//objReports.put("0", tripId);
									objReports.put("0", category2);
									objReports.put("1", ddmmyyyy.format(startDateOfPacket));
									objReports.put("2", startloc);
									objReports.put("3", ddmmyyyy.format(endDateOfPacket));
									objReports.put("4", endloc);
									objReports.put("5",	cf.convertMillisecondsToHHMMSSFormat(endDateOfPacket.getTime() - startDateOfPacket.getTime()));

									if (category1.equals("category1")) {
										ja3.put(objReports);
									}
									else if (category1.equals("category2")) {
										ja4.put(objReports);
									}
									else if (category1.equals("category3")) {
										ja5.put(objReports);
									}
									else if (category1.equals("category4")) {
										ja6.put(objReports);
									}
									else if (category1.equals("category5")) {
										ja7.put(objReports);
									}
									else if (category1.equals("category6")) {
										ja8.put(objReports);
									}
									else if (category1.equals("category7")) {
										ja9.put(objReports);
									}
									else if (category1.equals("category8")) {
										ja10.put(objReports);
									}
									else if (category1.equals("category9")) {
										ja11.put(objReports);
									}
								}
								startDateOfPacket = dlb.getGpsDateTime();
								startloc = dlb.getLocation().toString();
							}

							previousCategory = category;
							category1 = category;
						}
					}

					}
					jar.add(ja1);
					jar.add(ja2);
					jar.add(ja3);
					jar.add(ja4);
					jar.add(ja5);
					jar.add(ja6);
					jar.add(ja7);
					jar.add(ja8);
					jar.add(ja9);
					jar.add(ja10);
					jar.add(ja11);
					
						for (int i = 0;i<(jar.size());i++){
							for (int j = 0; j < (jar.get(i).length()); j++) {
								JSONObject obj = jar.get(i).getJSONObject(j);
								reportArray.put(obj);
							}
						}

					}
										
				} catch (Exception e) {
					e.printStackTrace();
				}
				
			}
			
		}catch(Exception e){
			e.printStackTrace();
		}
		finally{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
			DBConnection.releaseConnectionToDB(null, pstmt1, rs1);
		}
		return reportArray;
	}
	
	public boolean CheckImpreciseSetting(int userId, int systemId,Connection conn ) {
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		PreparedStatement pstmt2=null;
		ResultSet rs2=null;
		boolean isimprecise = false;
		boolean locset = false;
		try {
			conn = DBConnection.getConnectionToDB("AMS");
			pstmt=conn.prepareStatement("select isnull(Imprecise_Location_Setting,0) as Location_Setting from  AMS.dbo.System_Master where System_id = ?");
			pstmt.setInt(1, systemId);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				if(rs.getString("Location_Setting").equals("1")){
				locset = true;
				}else{
					locset = false;	
				}
				if(locset == true){
				
					pstmt2=conn.prepareStatement("select isnull(Imprecise_Location_Setting,0) as Location_Setting from AMS.dbo.Users where System_id = ? and  User_id = ? ");
					pstmt2.setInt(1, systemId);
					pstmt2.setInt(2, userId);
					rs2 = pstmt2.executeQuery();
					if(rs2.next()){						
						if(rs2.getString("Location_Setting").equals("1")){
							isimprecise = true;	
							}else{
							isimprecise = false;	
							}
					}
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(null,pstmt2,rs2);
			DBConnection.releaseConnectionToDB(null,pstmt,rs);
		}
		return isimprecise;
	}
	
	public String getLocalDateTime(String inputDate, int offSet) throws Exception {
		String retValue = inputDate;
		Date convDate = null;
		convDate = ddmmyyyyhhmmss.parse(inputDate);
		if (convDate != null) {
			Calendar cal = Calendar.getInstance();
			cal.setTime(convDate);
			cal.add(Calendar.MINUTE, -offSet);

			int day = cal.get(Calendar.DATE);
			int y = cal.get(Calendar.YEAR);
			int m = cal.get(Calendar.MONTH) + 1;
			int h = cal.get(Calendar.HOUR_OF_DAY);
			int mi = cal.get(Calendar.MINUTE);
			int s = cal.get(Calendar.SECOND);

			String yyyy = String.valueOf(y);
			String month = String.valueOf(m > 9 ? String.valueOf(m) : "0"
					+ String.valueOf(m));
			String date = String.valueOf(day > 9 ? String.valueOf(day) : "0"
					+ String.valueOf(day));
			String hour = String.valueOf(h > 9 ? String.valueOf(h) : "0"
					+ String.valueOf(h));
			String minute = String.valueOf(mi > 9 ? String.valueOf(mi) : "0"
					+ String.valueOf(mi));
			String second = String.valueOf(s > 9 ? String.valueOf(s) : "0"
					+ String.valueOf(s));

			retValue = month + "/" + date + "/" + yyyy + " " + hour + ":"
					+ minute + ":" + second;
			// System.out.println("New Date:::"+retValue);

		}
		return retValue;
	}
	
	
	public String checkCategory(int  speed) {
		String category = "";
		
		if (speed > 0 && speed <= 10){
			category = "category1";
		}
		else if (speed > 10 && speed <= 20){
			category = "category2";
		}
		else if (speed > 20 && speed <= 30){
			category = "category3";
		}
		else if (speed > 30 && speed <= 40){
			category = "category4";
		}
		else if (speed > 40 && speed <= 50){
			category = "category5";
		}
		else if (speed > 50 && speed <= 60){
			category = "category6";
		}
		else if (speed > 60 && speed <= 70){
			category = "category7";
		}
		else if (speed > 70 && speed <= 80){
			category = "category8";
		}
		else if (speed > 80){
			category = "category9";
		}else{
			category = "category0";
		}

		return category;
	}
	
	public String getCategory(String  category) {
		
		if (category.equals("category1")){
			category = "speed > 0 && speed <= 10";
		}
		else if (category.equals("category2")){
			category = "speed > 10 && speed <= 20";
		}
		else if (category.equals("category3")){
			category = "speed > 20 && speed <= 30";
		}
		else if (category.equals("category4")){
			category = "speed > 30 && speed <= 40";
		}
		else if (category.equals("category5")){
			category = "speed > 40 && speed <= 50";
		}
		else if (category.equals("category6")){
			category = "speed > 50 && speed <= 60";
		}
		else if (category.equals("category7")){
			category = "speed > 60 && speed <= 70";
		}
		else if (category.equals("category8")){
			category = "speed > 70 && speed <= 80";
		}
		else if (category.equals("category9")){
			category = "speed > 80";
		}

		return category;
	}
	
	public JSONArray getEmployeeSwipeDetailsReport(int systemId, int clientId, String reportId, String parameterSelected, String vehicleNo,
			String startDate, String endDate, String trips, int offset) {
		Connection con = null;
		PreparedStatement pstmt = null, pstmt1 = null;
		ResultSet rs = null, rs1 = null;
		JSONArray arrHeading = new JSONArray();
		JSONArray reportArray = new JSONArray();
		JSONObject objReports = null;
		String stmt = ""; 
		//String[] parameter = parameterSelected.split(",");
		String[] vehicleNos = vehicleNo.split(",");
		try{
			con = DBConnection.getConnectionToDB("AMS");
			String vehicle = "";
			for(int i = 0; i < vehicleNos.length; i++){
				vehicle = vehicle+",'"+vehicleNos[i]+"'";
			}
			pstmt = con.prepareStatement(ReportBuilderStatements.GET_SQL_QUERY);
			pstmt.setString(1, reportId);
			pstmt.setString(2, parameterSelected);
			rs = pstmt.executeQuery();
			if(rs.next()){
				stmt = rs.getString("SQL_QUERY");
				pstmt1 = con.prepareStatement(stmt.replace("#", "and rb.REGISTRATION_NO in ("+vehicle.substring(1,vehicle.length())+")"));
				pstmt1.setInt(1, offset);
				pstmt1.setInt(2, systemId);
				pstmt1.setInt(3, clientId);
				pstmt1.setInt(4, offset);
				pstmt1.setString(5, yyyymmdd.format(ddmmyyyy.parse(startDate)));
				pstmt1.setInt(6, offset);
				pstmt1.setString(7, yyyymmdd.format(ddmmyyyy.parse(endDate)));
				pstmt1.setInt(8, offset);
				pstmt1.setInt(9, systemId);
				pstmt1.setInt(10, clientId);
				pstmt1.setInt(11, offset);
				pstmt1.setString(12, yyyymmdd.format(ddmmyyyy.parse(startDate)));
				pstmt1.setInt(13, offset);
				pstmt1.setString(14, yyyymmdd.format(ddmmyyyy.parse(endDate)));
				rs1 = pstmt1.executeQuery();
				while(rs1.next()){
					ResultSetMetaData rsmd = rs1.getMetaData();
					if(rs1.getRow() == 1){
						objReports = new JSONObject();
						for(int i = 0; i < rsmd.getColumnCount(); i++){
							arrHeading = getHeadingArray(con,rsmd.getColumnName(i+1));
							objReports.put(String.valueOf(i), arrHeading);
						}
						reportArray.put(objReports);
					}
					objReports = new JSONObject();
					for(int j = 0; j < rsmd.getColumnCount(); j++){
						objReports.put(String.valueOf(j), rs1.getString(j+1));
					}
					reportArray.put(objReports);
				}
			}
		}catch(Exception e){
			e.printStackTrace();
		}
		finally{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
			DBConnection.releaseConnectionToDB(null, pstmt1, rs1);
		}
		return reportArray;
	}


	public JSONArray getGenerateDryRunKmReport(int systemId, int clientId, String reportId, String parameterSelected, String vehicleNo, String startDate,
			String endDate, String trips, int offset) {
		Connection con = null;
		PreparedStatement pstmt = null, pstmt1 = null, pstmt2 = null;
		ResultSet rs = null, rs1 = null, rs2 = null;
		JSONArray arrHeading = new JSONArray();
		JSONArray reportArray = new JSONArray();
		JSONObject objReports = null;
		String stmt = ""; 
		//String[] parameter = parameterSelected.split(",");
		String[] vehicleNos = vehicleNo.split(",");
		try{
			con = DBConnection.getConnectionToDB("AMS");
			String vehicle = "";
			for(int i = 0; i < vehicleNos.length; i++){
				vehicle = vehicle+",'"+vehicleNos[i]+"'";
			}
			pstmt = con.prepareStatement(ReportBuilderStatements.GET_SQL_QUERY);
			pstmt.setString(1, reportId);
			pstmt.setString(2, parameterSelected);
			rs = pstmt.executeQuery();
			if(rs.next()){
				stmt = rs.getString("SQL_QUERY");
				pstmt1 = con.prepareStatement(stmt.replace("#", "and rb.ASSET_NUMBER in ("+vehicle.substring(1,vehicle.length())+")"));
				pstmt1.setInt(1, systemId);
				pstmt1.setInt(2, clientId);
				pstmt1.setInt(3, offset);
				pstmt1.setString(4, yyyymmdd.format(ddmmyyyy.parse(startDate)));
				pstmt1.setInt(5, offset);
				pstmt1.setString(6, yyyymmdd.format(ddmmyyyy.parse(endDate)));
				rs1 = pstmt1.executeQuery();
				while(rs1.next()){
					ResultSetMetaData rsmd = rs1.getMetaData();
					if(rs1.getRow() == 1){
						objReports = new JSONObject();
						int i = 0;
						for(i = 0; i < rsmd.getColumnCount(); i++){
							arrHeading = getHeadingArray(con,rsmd.getColumnName(i+1));
							objReports.put(String.valueOf(i), arrHeading);
						}
						arrHeading = getHeadingArray(con,"lastTripNum");
						objReports.put(String.valueOf(i), arrHeading);
						i++;
						arrHeading = getHeadingArray(con,"lastTripId");
						objReports.put(String.valueOf(i), arrHeading);
						i++;
						arrHeading = getHeadingArray(con,"lastTripCustName");
						objReports.put(String.valueOf(i), arrHeading);
						i++;
						arrHeading = getHeadingArray(con,"lastTripEndTime");
						objReports.put(String.valueOf(i), arrHeading);
						i++;
						arrHeading = getHeadingArray(con,"locationAtTripClosure");
						objReports.put(String.valueOf(i), arrHeading);
						i++;
						arrHeading = getHeadingArray(con,"newTripId");
						objReports.put(String.valueOf(i), arrHeading);
						i++;
						arrHeading = getHeadingArray(con,"newTripNum");
						objReports.put(String.valueOf(i), arrHeading);
						i++;
						arrHeading = getHeadingArray(con,"newTripCustName");
						objReports.put(String.valueOf(i), arrHeading);
						i++;
						arrHeading = getHeadingArray(con,"newTripStartTime");
						objReports.put(String.valueOf(i), arrHeading);
						i++;
						arrHeading = getHeadingArray(con,"locationAtTripCreation");
						objReports.put(String.valueOf(i), arrHeading);
						i++;
						arrHeading = getHeadingArray(con,"atp");
						objReports.put(String.valueOf(i), arrHeading);
						
						reportArray.put(objReports);
					}
					objReports = new JSONObject();
					for(int j = 0; j < rsmd.getColumnCount(); j++){
						if( rs1.getString(j+1) != null){
							objReports.put(String.valueOf(j), rs1.getString(j+1));
						}else{
							objReports.put(String.valueOf(j),"NA");
						}
					}
					pstmt2 = con.prepareStatement(ReportBuilderStatements.GET_LAST_AND_NEW_TRIP_FOR_VEHICLE);
					pstmt2.setInt(1, offset);
					pstmt2.setInt(2, offset);
					pstmt2.setString(3, rs1.getString("truck"));
					pstmt2.setString(4, rs1.getString("truck"));
					pstmt2.setInt(5, offset);
					pstmt2.setString(6, rs1.getString("truck"));
					//pstmt2.setInt(7, offset);
					//pstmt2.setString(8, yyyymmdd.format(ddmmyyyy.parse(startDate)));
					//pstmt2.setInt(9, offset);
					//pstmt2.setString(10, yyyymmdd.format(ddmmyyyy.parse(endDate)));
					pstmt2.setInt(7, offset);
					pstmt2.setInt(8, offset);
					pstmt2.setString(9, rs1.getString("truck"));
					pstmt2.setString(10, rs1.getString("truck"));
					pstmt2.setInt(11, offset);
					pstmt2.setString(12, rs1.getString("truck"));
					pstmt2.setInt(13, offset);
					pstmt2.setString(14, yyyymmdd.format(ddmmyyyy.parse(startDate)));
					pstmt2.setInt(15, offset);
					pstmt2.setString(16, yyyymmdd.format(ddmmyyyy.parse(endDate)));
					rs2 = pstmt2.executeQuery();
					if(rs2.next()){
							objReports.put("9",rs2.getString("ORDER_ID"));//lastTripNum
							objReports.put("10",rs2.getString("SHIPMENT_ID"));//lastTripId
							objReports.put("11",rs2.getString("CUSTOMER_NAME"));//lastTripCustName
							if(rs2.getString("ACTUAL_TRIP_END_TIME") != null){
								objReports.put("12",ddmmyyyyhhmmss.format(rs2.getDate("ACTUAL_TRIP_END_TIME")));//lastTripEndTime
							}else{
								objReports.put("12","NA");
							}
							if(rs2.getString("LOCATION") != null){
								objReports.put("13",rs2.getString("LOCATION"));//locationAtTripClosure
							}else{
								objReports.put("13","NA");
							}
						if(rs2.next()){//If has new trip(OPEN trip for same vehicle) 
							objReports.put("14",rs2.getString("SHIPMENT_ID"));// newTripId
							objReports.put("15",rs2.getString("ORDER_ID"));//newTripNum
							objReports.put("16",rs2.getString("CUSTOMER_NAME"));//newTripCustName
							if(rs2.getString("INSERTED_TIME") != null){
								objReports.put("17",ddmmyyyyhhmmss.format(rs2.getDate("INSERTED_TIME")));//newTripStartTime
							}else{
								objReports.put("17","NA");
							}
							if(rs2.getString("LOCATION") != null){
								objReports.put("18",rs2.getString("LOCATION"));//locationAtTripCreation
							}else{
								objReports.put("18","NA");
							}if(rs2.getString("ACT_SRC_ARR_DATETIME") != null ){
								objReports.put("19",rs2.getString("ACT_SRC_ARR_DATETIME"));
							}else{
								objReports.put("19","NA");
							}
						}
						else{
							objReports.put("14","NA");
							objReports.put("15","NA");
							objReports.put("16","NA");
							objReports.put("17","NA");
							objReports.put("18","NA");
							objReports.put("19","NA");
						}
					}
					reportArray.put(objReports);
				}
			}
		}catch(Exception e){
			e.printStackTrace();
		}
		finally{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
			DBConnection.releaseConnectionToDB(null, pstmt1, rs1);
			DBConnection.releaseConnectionToDB(null, pstmt2, rs2);
		}
		return reportArray;
	}

	public JSONArray generateMultipleReports(int systemId, int clientId,String categoryId,
			String reportId, String parameterSelected, String vehicleNo,
			String startDate, String endDate, String trips, int offset) {
		Connection con = null;
		PreparedStatement pstmt = null, pstmt1 = null, pstmt2 = null;
		ResultSet rs = null, rs1 = null, rs2 = null;
		String baseQuery = "";
		StringBuffer selectParams = new StringBuffer();
		StringBuffer groupByParams =  new StringBuffer();
		StringBuffer orderByParams = new StringBuffer();
		JSONArray arrHeading = new JSONArray();
		JSONArray reportArray = new JSONArray();
		JSONObject objReports = null;
		String[] vehicleNos = vehicleNo.split(",");
		String vehicle = "";
		for(int i = 0; i < vehicleNos.length; i++){
			vehicle = vehicle+",'"+vehicleNos[i]+"'";
		}
		try{
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(ReportBuilderStatements.GET_BASE_QUERY);
			pstmt.setString(1, categoryId);
			rs = pstmt.executeQuery();
			//1. Get Base query
			if(rs.next()){
				baseQuery = rs.getString("BASE_QUERY");
			}
			//2. Get the group by parameters
			pstmt = con.prepareStatement(ReportBuilderStatements.GET_GROUP_BY_PARAMS.
														replace("#", CommonFunctions.getSqlParams(parameterSelected.split(",").length)));
			pstmt.setString(1,categoryId);
			int paramIndex =2;
	        for(String parameter : parameterSelected.split(",")){
	        	pstmt.setString(paramIndex, parameter);
	        	paramIndex++;
	        }
			rs = pstmt.executeQuery();
			while(rs.next()){
				groupByParams.append(rs.getString("PARAMETER_QUERY"));
				groupByParams.append(",");
				orderByParams.append(rs.getString("PARAMETER_QUERY"));
				orderByParams.append(",");
				selectParams.append("isnull("+rs.getString("PARAMETER_QUERY")+",'NA') as "+rs.getString("PARAMETER_ID"));
				selectParams.append(",");
			}
			if(groupByParams.lastIndexOf(",") >0){
				groupByParams = new StringBuffer(groupByParams.substring(0, groupByParams.lastIndexOf(",")));
			}
			if(orderByParams.lastIndexOf(",") >0){
				orderByParams = new StringBuffer(orderByParams.substring(0, orderByParams.lastIndexOf(",")));
			}
			//3. Get the select parameters
			pstmt = con.prepareStatement(ReportBuilderStatements.GET_SELECT_PARAMS.replace("#", reportId));
			rs = pstmt.executeQuery();
			while(rs.next()){
				selectParams.append(rs.getString("SELECT_PARAM"));
				selectParams.append(",");
			}
			if(selectParams.lastIndexOf(",") >0){
				selectParams = new StringBuffer(selectParams.substring(0, selectParams.lastIndexOf(",")));
			}
			String finalQuery = baseQuery.replace("SELECT_PARAM", selectParams.toString())
													.replace("GROUP_BY", groupByParams.toString())
													.replace("ORDER_BY", orderByParams.toString());
			pstmt1 = con.prepareStatement(finalQuery.replace("#", "and rb.ASSET_NUMBER in ("+vehicle.substring(1,vehicle.length())+")"));
			pstmt1.setInt(1, systemId);
			pstmt1.setInt(2, clientId);
			pstmt1.setInt(3, offset);
			pstmt1.setString(4, yyyymmdd.format(ddmmyyyy.parse(startDate)));
			pstmt1.setInt(5, offset);
			pstmt1.setString(6, yyyymmdd.format(ddmmyyyy.parse(endDate)));
			rs1 = pstmt1.executeQuery();
			List<Integer> timeFiledIndexes = new ArrayList<Integer>();
			List<Integer> dateTimeFieldIndexes = new ArrayList<Integer>();
			
			while(rs1.next()){
				ResultSetMetaData rsmd = rs1.getMetaData();
				if(rs1.getRow() == 1){
					objReports = new JSONObject();
					for(int i = 0; i < rsmd.getColumnCount(); i++){
						arrHeading = getHeadingArray(con, rsmd.getColumnName(i + 1));
						JSONObject heading = arrHeading.getJSONObject(0);
						if (heading.getString("filterType") != null	&& heading.getString("filterType").equals("Time")) {
							timeFiledIndexes.add(i);
						} else if (heading.getString("filterType") != null && heading.getString("filterType").equals("DateTime")) {
							dateTimeFieldIndexes.add(i);
						}
						objReports.put(String.valueOf(i), arrHeading);

					}
					reportArray.put(objReports);
				}
				objReports = new JSONObject();
				for(int j = 0; j < rsmd.getColumnCount(); j++){
					if(timeFiledIndexes.contains(j)){
						objReports.put(String.valueOf(j), rs1.getLong(j+1) >= 0 ?formattedHoursMinutes(rs1.getLong(j+1)) : "-"+ formattedHoursMinutes( -(rs1.getLong(j+1))));
					}else if(dateTimeFieldIndexes.contains(j)){
						if(!rs1.getString(j+1).contains("1900")){
							objReports.put(String.valueOf(j), ddmmyyyy.format(yyyymmdd.parse(rs1.getString(j+1))));
						}else{
							objReports.put(String.valueOf(j),"");
						}
					}
					else{
						objReports.put(String.valueOf(j), rs1.getString(j+1));
					}
				}
				reportArray.put(objReports);
			}
		}catch(Exception e){
			e.printStackTrace();
		}
		finally{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
			DBConnection.releaseConnectionToDB(null, pstmt1, rs1);
			DBConnection.releaseConnectionToDB(null, pstmt2, rs2);
		}
		
		return reportArray;
	}
	
	public JSONArray generateMultipleReportsForLoading(int systemId, int clientId,String categoryId,
			String reportId, String parameterSelected, String vehicleNo,
			String startDate, String endDate, String trips, int offset) {
		Connection con = null;
		PreparedStatement pstmt = null, pstmt1 = null, pstmt2 = null;
		ResultSet rs = null, rs1 = null, rs2 = null;
		String baseQuery = "";
		StringBuffer selectParams = new StringBuffer();
		StringBuffer groupByParams =  new StringBuffer();
		StringBuffer orderByParams = new StringBuffer();
		JSONArray arrHeading = new JSONArray();
		JSONArray reportArray = new JSONArray();
		JSONObject objReports = null;
		String[] vehicleNos = vehicleNo.split(",");
		String vehicle = "";
		String newBaseQuery = "";
		for(int i = 0; i < vehicleNos.length; i++){
			vehicle = vehicle+",'"+vehicleNos[i]+"'";
		}
		try{
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(ReportBuilderStatements.GET_BASE_QUERY);
			pstmt.setString(1, categoryId);
			rs = pstmt.executeQuery();
			//1. Get Base query
			if(rs.next()){
				baseQuery = rs.getString("BASE_QUERY");
			}
		String repId = "";	
		Boolean a = true;
		String[] reportIds = reportId.split(",");
		for(int i=0; i< reportIds.length; i++){
			repId = reportIds[i];
			if(repId.equalsIgnoreCase("10") || repId.equalsIgnoreCase("12")){
				a = false;
			}
		}
		if(a == false){	
			baseQuery = baseQuery.replace("$", "left outer join DES_TRIP_DETAILS de on de.TRIP_ID=rb.TRIP_ID and de.SEQUENCE=100");
		}else {
			baseQuery = baseQuery.replace("$", "");
		}  
			
			//2. Get the group by parameters
			pstmt = con.prepareStatement(ReportBuilderStatements.GET_GROUP_BY_PARAMS.
														replace("#", CommonFunctions.getSqlParams(parameterSelected.split(",").length)));
			pstmt.setString(1,categoryId);
			int paramIndex =2;
	        for(String parameter : parameterSelected.split(",")){
	        	pstmt.setString(paramIndex, parameter);
	        	paramIndex++;
	        }
			rs = pstmt.executeQuery();
			while(rs.next()){
				groupByParams.append(rs.getString("PARAMETER_QUERY"));
				groupByParams.append(",");
				orderByParams.append(rs.getString("PARAMETER_QUERY"));
				orderByParams.append(",");
				selectParams.append("isnull("+rs.getString("PARAMETER_QUERY")+",'NA') as "+rs.getString("PARAMETER_ID"));
				selectParams.append(",");
			}
			if(groupByParams.lastIndexOf(",") >0){
				groupByParams = new StringBuffer(groupByParams.substring(0, groupByParams.lastIndexOf(",")));
			}
			if(orderByParams.lastIndexOf(",") >0){
				orderByParams = new StringBuffer(orderByParams.substring(0, orderByParams.lastIndexOf(",")));
			}
			//3. Get the select parameters
			pstmt = con.prepareStatement(ReportBuilderStatements.GET_SELECT_PARAMS.replace("#", reportId));
			rs = pstmt.executeQuery();
			while(rs.next()){
				selectParams.append(rs.getString("SELECT_PARAM")); 
				selectParams.append(",");
			}
			if(selectParams.lastIndexOf(",") >0){
				selectParams = new StringBuffer(selectParams.substring(0, selectParams.lastIndexOf(",")));
			}
			String finalQuery = baseQuery.replace("SELECT_PARAM", selectParams.toString())
													.replace("GROUP_BY", groupByParams.toString())
													.replace("ORDER_BY", orderByParams.toString());
			finalQuery = finalQuery.replace("#", "and rb.ASSET_NUMBER in ("+vehicle.substring(1,vehicle.length())+")");
			//System.out.println("final query : " + finalQuery);
			
			pstmt1 = con.prepareStatement(finalQuery);
			pstmt1.setInt(1, systemId);
			pstmt1.setInt(2, clientId);
			pstmt1.setInt(3, offset);
			pstmt1.setString(4, yyyymmdd.format(ddmmyyyy.parse(startDate)));
			pstmt1.setInt(5, offset);
			pstmt1.setString(6, yyyymmdd.format(ddmmyyyy.parse(endDate)));
			rs1 = pstmt1.executeQuery();
			List<Integer> timeFiledIndexes = new ArrayList<Integer>();
			List<Integer> dateTimeFieldIndexes = new ArrayList<Integer>();
			
			while(rs1.next()){
				ResultSetMetaData rsmd = rs1.getMetaData();
				if(rs1.getRow() == 1){
					objReports = new JSONObject();
					for(int i = 0; i < rsmd.getColumnCount(); i++){
						arrHeading = getHeadingArray(con, rsmd.getColumnName(i + 1));
						JSONObject heading = arrHeading.getJSONObject(0);
						if (heading.getString("filterType") != null	&& heading.getString("filterType").equals("Time")) {
							timeFiledIndexes.add(i);
						} else if (heading.getString("filterType") != null && heading.getString("filterType").equals("DateTime")) {
							dateTimeFieldIndexes.add(i);
						}
						objReports.put(String.valueOf(i), arrHeading);

					}
					reportArray.put(objReports);
				}
				objReports = new JSONObject();
				for(int j = 0; j < rsmd.getColumnCount(); j++){
					if(timeFiledIndexes.contains(j)){
						objReports.put(String.valueOf(j), rs1.getLong(j+1) >= 0 ?formattedHoursMinutes(rs1.getLong(j+1)) : "-"+ formattedHoursMinutes( -(rs1.getLong(j+1))));
					}else if(dateTimeFieldIndexes.contains(j)){
						if(!rs1.getString(j+1).contains("1900")){
							objReports.put(String.valueOf(j), ddmmyyyy.format(yyyymmdd.parse(rs1.getString(j+1))));
						}else{
							objReports.put(String.valueOf(j),"");
						}
					}
					else{
						objReports.put(String.valueOf(j), rs1.getString(j+1));
					}
				}
				reportArray.put(objReports);
			}
		}catch(Exception e){
			e.printStackTrace();
		}
		finally{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
			DBConnection.releaseConnectionToDB(null, pstmt1, rs1);
			DBConnection.releaseConnectionToDB(null, pstmt2, rs2);
		}
		
		return reportArray;
	}
	
	
	public JSONArray generateMultipleReportsForOnRoute(int systemId, int clientId,String categoryId,
			String reportId, String parameterSelected, String vehicleNo,
			String startDate, String endDate, String trips, int offset) {
		Connection con = null;
		PreparedStatement pstmt = null, pstmt1 = null, pstmt2 = null;
		ResultSet rs = null, rs1 = null, rs2 = null;
		String baseQuery = "";
		StringBuffer selectParams = new StringBuffer();
		StringBuffer groupByParams =  new StringBuffer();
		StringBuffer orderByParams = new StringBuffer();
		JSONArray arrHeading = new JSONArray();
		JSONArray reportArray = new JSONArray();
		JSONObject objReports = null;
		String[] vehicleNos = vehicleNo.split(",");
		String vehicle = "";
		for(int i = 0; i < vehicleNos.length; i++){
			vehicle = vehicle+",'"+vehicleNos[i]+"'";
		}
		try{
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(ReportBuilderStatements.GET_BASE_QUERY);
			pstmt.setString(1, categoryId);
			rs = pstmt.executeQuery();
			//1. Get Base query
			if(rs.next()){
				baseQuery = rs.getString("BASE_QUERY");
			}
			//System.out.println("reportId :: " + reportId + " base qu ::::" + baseQuery);
			
			//2. Get the group by parameters
			pstmt = con.prepareStatement(ReportBuilderStatements.GET_GROUP_BY_PARAMS.
														replace("#", CommonFunctions.getSqlParams(parameterSelected.split(",").length)));
			pstmt.setString(1,categoryId);
			int paramIndex =2;
	        for(String parameter : parameterSelected.split(",")){
	        	pstmt.setString(paramIndex, parameter);
	        	paramIndex++;
	        }
			rs = pstmt.executeQuery();
			while(rs.next()){
				groupByParams.append(rs.getString("PARAMETER_QUERY"));
				groupByParams.append(",");
				orderByParams.append(rs.getString("PARAMETER_QUERY"));
				orderByParams.append(",");
				selectParams.append("isnull("+rs.getString("PARAMETER_QUERY")+",'NA') as "+rs.getString("PARAMETER_ID"));
				selectParams.append(",");
			}
			if(groupByParams.lastIndexOf(",") >0){
				groupByParams = new StringBuffer(groupByParams.substring(0, groupByParams.lastIndexOf(",")));
			}
			if(orderByParams.lastIndexOf(",") >0){
				orderByParams = new StringBuffer(orderByParams.substring(0, orderByParams.lastIndexOf(",")));
			}
			//3. Get the select parameters
			pstmt = con.prepareStatement(ReportBuilderStatements.GET_SELECT_PARAMS.replace("#", reportId));
			rs = pstmt.executeQuery();
			while(rs.next()){
				selectParams.append(rs.getString("SELECT_PARAM")); 
				selectParams.append(",");
			}
			if(selectParams.lastIndexOf(",") >0){
				selectParams = new StringBuffer(selectParams.substring(0, selectParams.lastIndexOf(",")));
			}
			String finalQuery = baseQuery.replace("SELECT_PARAM", selectParams.toString())
													.replace("GROUP_BY", groupByParams.toString())
													.replace("ORDER_BY", orderByParams.toString());
			finalQuery = finalQuery.replace("#", "and rb.ASSET_NUMBER in ("+vehicle.substring(1,vehicle.length())+")");
			//System.out.println("final query : " + finalQuery);
			
			pstmt1 = con.prepareStatement(finalQuery);
			pstmt1.setInt(1, systemId);
			pstmt1.setInt(2, clientId);
			pstmt1.setInt(3, offset);
			pstmt1.setString(4, yyyymmdd.format(ddmmyyyy.parse(startDate)));
			pstmt1.setInt(5, offset);
			pstmt1.setString(6, yyyymmdd.format(ddmmyyyy.parse(endDate)));
			rs1 = pstmt1.executeQuery();
			List<Integer> timeFiledIndexes = new ArrayList<Integer>();
			List<Integer> dateTimeFieldIndexes = new ArrayList<Integer>();
			
			while(rs1.next()){
				ResultSetMetaData rsmd = rs1.getMetaData();
				if(rs1.getRow() == 1){
					objReports = new JSONObject();
					for(int i = 0; i < rsmd.getColumnCount(); i++){
						arrHeading = getHeadingArray(con, rsmd.getColumnName(i + 1));
						JSONObject heading = arrHeading.getJSONObject(0);
						if (heading.getString("filterType") != null	&& heading.getString("filterType").equals("Time")) {
							timeFiledIndexes.add(i);
						} else if (heading.getString("filterType") != null && heading.getString("filterType").equals("DateTime")) {
							dateTimeFieldIndexes.add(i);
						}
						objReports.put(String.valueOf(i), arrHeading);

					}
					reportArray.put(objReports);
				}
				objReports = new JSONObject();
				for(int j = 0; j < rsmd.getColumnCount(); j++){
					if(timeFiledIndexes.contains(j)){
						objReports.put(String.valueOf(j), rs1.getLong(j+1) >= 0 ?formattedHoursMinutes(rs1.getLong(j+1)) : "-"+ formattedHoursMinutes( -(rs1.getLong(j+1))));
					}else if(dateTimeFieldIndexes.contains(j)){
						if(!rs1.getString(j+1).contains("1900")){
							objReports.put(String.valueOf(j), ddmmyyyy.format(yyyymmdd.parse(rs1.getString(j+1))));
						}else{
							objReports.put(String.valueOf(j),"");
						}
					}
					else{
						objReports.put(String.valueOf(j), rs1.getString(j+1));
					}
				}
				reportArray.put(objReports);
			}
		}catch(Exception e){
			e.printStackTrace();
		}
		finally{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
			DBConnection.releaseConnectionToDB(null, pstmt1, rs1);
			DBConnection.releaseConnectionToDB(null, pstmt2, rs2);
		}
		
		return reportArray;
	}
	
	
	public JSONArray generateMultipleReportsForUnAssignedPlacement(int systemId, int clientId,String categoryId,
			String reportId, String parameterSelected, String vehicleNo,
			String startDate, String endDate, String trips, int offset) {
		Connection con = null;
		PreparedStatement pstmt = null, pstmt1 = null, pstmt2 = null;
		ResultSet rs = null, rs1 = null, rs2 = null;
		String baseQuery = "";
		StringBuffer selectParams = new StringBuffer();
		StringBuffer groupByParams =  new StringBuffer();
		StringBuffer orderByParams = new StringBuffer();
		JSONArray arrHeading = new JSONArray();
		JSONArray reportArray = new JSONArray();
		JSONObject objReports = null;
		String[] vehicleNos = vehicleNo.split(",");
		String vehicle = "";
		//String newBaseQuery = "";
		for(int i = 0; i < vehicleNos.length; i++){
			vehicle = vehicle+",'"+vehicleNos[i]+"'";
		}
		try{
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(ReportBuilderStatements.GET_BASE_QUERY);
			pstmt.setString(1, categoryId);
			rs = pstmt.executeQuery();
			//1. Get Base query
			if(rs.next()){
				baseQuery = rs.getString("BASE_QUERY");
			}
		String repId = "";	
		Boolean a = true;
		String[] reportIds = reportId.split(",");
		for(int i=0; i< reportIds.length; i++){
			repId = reportIds[i];
			if(repId.equalsIgnoreCase("6")){
				a = false;
			}
		}
		if(a == false){	
			baseQuery = baseQuery.replace("$", "left outer join DES_TRIP_DETAILS de on de.TRIP_ID=rb.TRIP_ID and de.SEQUENCE=100");
		}else {
			baseQuery = baseQuery.replace("$", "");
		}  
		//System.out.println(" base qu " + baseQuery);
			
			//2. Get the group by parameters
			pstmt = con.prepareStatement(ReportBuilderStatements.GET_GROUP_BY_PARAMS.
														replace("#", CommonFunctions.getSqlParams(parameterSelected.split(",").length)));
			pstmt.setString(1,categoryId);
			int paramIndex =2;
	        for(String parameter : parameterSelected.split(",")){
	        	pstmt.setString(paramIndex, parameter);
	        	paramIndex++;
	        }
			rs = pstmt.executeQuery();
			while(rs.next()){
				groupByParams.append(rs.getString("PARAMETER_QUERY"));
				groupByParams.append(",");
				orderByParams.append(rs.getString("PARAMETER_QUERY"));
				orderByParams.append(",");
				selectParams.append("isnull("+rs.getString("PARAMETER_QUERY")+",'NA') as "+rs.getString("PARAMETER_ID"));
				selectParams.append(",");
			}
			if(groupByParams.lastIndexOf(",") >0){
				groupByParams = new StringBuffer(groupByParams.substring(0, groupByParams.lastIndexOf(",")));
			}
			if(orderByParams.lastIndexOf(",") >0){
				orderByParams = new StringBuffer(orderByParams.substring(0, orderByParams.lastIndexOf(",")));
			}
			//3. Get the select parameters
			pstmt = con.prepareStatement(ReportBuilderStatements.GET_SELECT_PARAMS.replace("#", reportId));
			rs = pstmt.executeQuery();
			while(rs.next()){
				selectParams.append(rs.getString("SELECT_PARAM")); 
				selectParams.append(",");
			}
			if(selectParams.lastIndexOf(",") >0){
				selectParams = new StringBuffer(selectParams.substring(0, selectParams.lastIndexOf(",")));
			}
			String finalQuery = baseQuery.replace("SELECT_PARAM", selectParams.toString())
													.replace("GROUP_BY", groupByParams.toString())
													.replace("ORDER_BY", orderByParams.toString());
			finalQuery = finalQuery.replace("#", "and rb.ASSET_NUMBER in ("+vehicle.substring(1,vehicle.length())+")");
			//System.out.println("final query : " + finalQuery);
			
			pstmt1 = con.prepareStatement(finalQuery);
			pstmt1.setInt(1, systemId);
			pstmt1.setInt(2, clientId);
			pstmt1.setInt(3, offset);
			pstmt1.setString(4, yyyymmdd.format(ddmmyyyy.parse(startDate)));
			pstmt1.setInt(5, offset);
			pstmt1.setString(6, yyyymmdd.format(ddmmyyyy.parse(endDate)));
			rs1 = pstmt1.executeQuery();
			List<Integer> timeFiledIndexes = new ArrayList<Integer>();
			List<Integer> dateTimeFieldIndexes = new ArrayList<Integer>();
			
			while(rs1.next()){
				ResultSetMetaData rsmd = rs1.getMetaData();
				if(rs1.getRow() == 1){
					objReports = new JSONObject();
					for(int i = 0; i < rsmd.getColumnCount(); i++){
						arrHeading = getHeadingArray(con, rsmd.getColumnName(i + 1));
						JSONObject heading = arrHeading.getJSONObject(0);
						if (heading.getString("filterType") != null	&& heading.getString("filterType").equals("Time")) {
							timeFiledIndexes.add(i);
						} else if (heading.getString("filterType") != null && heading.getString("filterType").equals("DateTime")) {
							dateTimeFieldIndexes.add(i);
						}
						objReports.put(String.valueOf(i), arrHeading);

					}
					reportArray.put(objReports);
				}
				objReports = new JSONObject();
				for(int j = 0; j < rsmd.getColumnCount(); j++){
					if(timeFiledIndexes.contains(j)){
						objReports.put(String.valueOf(j), rs1.getLong(j+1) >= 0 ?formattedHoursMinutes(rs1.getLong(j+1)) : "-"+ formattedHoursMinutes( -(rs1.getLong(j+1))));
					}else if(dateTimeFieldIndexes.contains(j)){
						if(!rs1.getString(j+1).contains("1900")){
							objReports.put(String.valueOf(j), ddmmyyyy.format(yyyymmdd.parse(rs1.getString(j+1))));
						}else{
							objReports.put(String.valueOf(j),"");
						}
					}
					else{
						objReports.put(String.valueOf(j), rs1.getString(j+1));
					}
				}
				reportArray.put(objReports);
			}
		}catch(Exception e){
			e.printStackTrace();
		}
		finally{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
			DBConnection.releaseConnectionToDB(null, pstmt1, rs1);
			DBConnection.releaseConnectionToDB(null, pstmt2, rs2);
		}
		
		return reportArray;
	}
	
}
