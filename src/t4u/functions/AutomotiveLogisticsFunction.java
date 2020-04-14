package t4u.functions;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Properties;

import org.json.JSONArray;
import org.json.JSONObject;

import t4u.beans.MapAPIConfigBean;
import t4u.beans.ReportHelper;
import t4u.common.ApplicationListener;
import t4u.common.DBConnection;
import t4u.statements.AutomotiveLogisticsStatements;
import t4u.util.LatLng;
import t4u.util.MapAPIUtil;
import t4u.util.TimeAndDistanceCalculator;

public class AutomotiveLogisticsFunction {
	SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	SimpleDateFormat ddmmyyyy = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
	CommonFunctions cf = new CommonFunctions();
	MapAPIUtil mapAPIUtil = new MapAPIUtil();
	TimeAndDistanceCalculator tdc = new TimeAndDistanceCalculator();

	public JSONArray getSourdeDestination(int clientId,int systemId,String zone) {
		JSONArray JsonArray = null;
		JSONObject JsonObject = null;
		Connection con = null;
	    ResultSet rs = null;
	    PreparedStatement pstmt = null;
	    CommonFunctions cofun = new CommonFunctions();
		try {
			JsonArray = new JSONArray();
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(cofun.getLocationQuery(AutomotiveLogisticsStatements.GET_SOURCE_DESTINATION,zone));
			pstmt.setInt(1,clientId);
			pstmt.setInt(2, systemId);
			JSONObject JsonObject1 = new JSONObject();
			JsonObject1.put("Hub_Id", 0);
			JsonObject1.put("Hub_Name","Any");
			JsonArray.put(JsonObject1);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				JsonObject = new JSONObject();
				JsonObject.put("Hub_Id",rs.getInt("HUBID"));
				JsonObject.put("Hub_Name",rs.getString("NAME"));
				JsonArray.put(JsonObject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
	  return JsonArray;	
	  }
	
	public JSONArray getDashboardCountOverspeed(String fromDate,String toDate,int clientId,int systemId,int userId) {
		JSONArray JsonArray = null;
		JSONObject JsonObject = null;
		Connection con = null;
	    ResultSet rs = null;
	    PreparedStatement pstmt = null;
		try {
			
			JsonArray = new JSONArray();
			con = DBConnection.getConnectionToDB("AMS");
		
			pstmt = con.prepareStatement(AutomotiveLogisticsStatements.GET_OVERSPEED_COUNT);
			pstmt.setInt(1,systemId);
			pstmt.setInt(2, clientId);
			pstmt.setInt(3, userId);
			pstmt.setString(4, fromDate);
			pstmt.setString(5, toDate);
			
			rs = pstmt.executeQuery();
			while (rs.next()) {
				JsonObject = new JSONObject();
				JsonObject.put("overspeedcountIndex",rs.getString("OVERSPEEDCOUNT"));
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
	
	public JSONArray getDashboardStoppageCount(String fromDate,String toDate,int clientId,int systemId,int userId) {
		JSONArray JsonArray = null;
		JSONObject JsonObject = null;
		Connection con = null;
	    ResultSet rs = null;
	    PreparedStatement pstmt = null;
		try {
			
			JsonArray = new JSONArray();
			con = DBConnection.getConnectionToDB("AMS");
		
			pstmt = con.prepareStatement(AutomotiveLogisticsStatements.GET_STOPPAGE_COUNT);
			pstmt.setInt(1,systemId);
			pstmt.setInt(2, clientId);
			pstmt.setInt(3, userId);
			pstmt.setString(4, fromDate);
			pstmt.setString(5, toDate);
			
			rs = pstmt.executeQuery();
			while (rs.next()) {
				JsonObject = new JSONObject();
				JsonObject.put("stoppagecountIndex",rs.getString("Stoppagecount"));
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
	
	public JSONArray getDashboardCount(String fromDate,String toDate,String type,int fromLocationId,int toLocationId,int clientId,int systemId,int userId) {
		JSONArray JsonArray = null;
		JSONObject JsonObject = null;
		Connection con = null;
	    ResultSet rs = null;
	    PreparedStatement pstmt = null;
		try {
			JsonArray = new JSONArray();
			con = DBConnection.getConnectionToDB("AMS");
			if(fromLocationId == 0 && toLocationId == 0){
				if(type.equalsIgnoreCase("In Transit")){
					pstmt = con.prepareStatement(AutomotiveLogisticsStatements.GET_DASHBOARD_COUNT);
					pstmt.setInt(1,systemId);
					pstmt.setInt(2, clientId);
					pstmt.setInt(3, userId);
					pstmt.setString(4, fromDate);
					pstmt.setString(5, toDate);
				}else if (type.equalsIgnoreCase("Delivered")){
					pstmt = con.prepareStatement(AutomotiveLogisticsStatements.GET_DASHBOARD_COUNT.replace("STATUS='Open' ","(STATUS='Closed' or (CARGO_STATUS = 'CLOSED' AND CUSTOMER_ID='5015'))"));
					pstmt.setInt(1,systemId);
					pstmt.setInt(2, clientId);
					pstmt.setInt(3, userId);
					pstmt.setString(4, fromDate);
					pstmt.setString(5, toDate);
				}else if(type.equalsIgnoreCase("All")){
					pstmt = con.prepareStatement(AutomotiveLogisticsStatements.GET_DASHBOARD_COUNT.replace("and STATUS='Open' "," "));
					pstmt.setInt(1,systemId);
					pstmt.setInt(2, clientId);
					pstmt.setInt(3, userId);
					pstmt.setString(4, fromDate);
					pstmt.setString(5, toDate);
				}
			}else{
				if (fromLocationId != 0 && toLocationId != 0) {
					if(type.equalsIgnoreCase("In Transit")){
						pstmt = con.prepareStatement(AutomotiveLogisticsStatements.GET_DASHBOARD_COUNT.replace("STATUS='Open' " ," STATUS='Open' and ROUTE_ID in (select distinct ROUTE_ID from dbo.ROUTE_SKELETON where TYPE='MLL SCM' and SYSTEM_ID=? and CUSTOMER_ID=? and ORIGIN=? and DESTINATION=?)"));
						pstmt.setInt(1,systemId);
						pstmt.setInt(2, clientId);
						pstmt.setInt(3, userId);
						pstmt.setString(4, fromDate);
						pstmt.setString(5, toDate);
						pstmt.setInt(6, systemId);
						pstmt.setInt(7, clientId);
						pstmt.setInt(8, fromLocationId);
						pstmt.setInt(9, toLocationId);
					}else if (type.equalsIgnoreCase("Delivered")){
						pstmt = con.prepareStatement(AutomotiveLogisticsStatements.GET_DASHBOARD_COUNT.replace("STATUS='Open' ","STATUS='Closed' and ROUTE_ID in (select distinct ROUTE_ID from dbo.ROUTE_SKELETON where TYPE='MLL SCM' and SYSTEM_ID=? and CUSTOMER_ID=? and ORIGIN=? and DESTINATION=?)"));
						pstmt.setInt(1,systemId);
						pstmt.setInt(2, clientId);
						pstmt.setInt(3, userId);
						pstmt.setString(4, fromDate);
						pstmt.setString(5, toDate);
						pstmt.setInt(6, systemId);
						pstmt.setInt(7, clientId);
						pstmt.setInt(8, fromLocationId);
						pstmt.setInt(9, toLocationId);
					}else if(type.equalsIgnoreCase("All")){
						pstmt = con.prepareStatement(AutomotiveLogisticsStatements.GET_DASHBOARD_COUNT.replace("STATUS='Open' "," ROUTE_ID in (select distinct ROUTE_ID from dbo.ROUTE_SKELETON where TYPE='MLL SCM' and SYSTEM_ID=? and CUSTOMER_ID=? and ORIGIN=? and DESTINATION=?)"));
						pstmt.setInt(1,systemId);
						pstmt.setInt(2, clientId);
						pstmt.setInt(3, userId);
						pstmt.setString(4, fromDate);
						pstmt.setString(5, toDate);
						pstmt.setInt(6, systemId);
						pstmt.setInt(7, clientId);
						pstmt.setInt(8, fromLocationId);
						pstmt.setInt(9, toLocationId);
					}
				}
				if (fromLocationId != 0 && toLocationId == 0) {
					if(type.equalsIgnoreCase("In Transit")){
						pstmt = con.prepareStatement(AutomotiveLogisticsStatements.GET_DASHBOARD_COUNT.replace("STATUS='Open' " ," STATUS='Open' and ROUTE_ID in (select distinct ROUTE_ID from dbo.ROUTE_SKELETON where TYPE='MLL SCM' and SYSTEM_ID=? and CUSTOMER_ID=? and ORIGIN=? )"));
						pstmt.setInt(1,systemId);
						pstmt.setInt(2, clientId);
						pstmt.setInt(3, userId);
						pstmt.setString(4, fromDate);
						pstmt.setString(5, toDate);
						pstmt.setInt(6, systemId);
						pstmt.setInt(7, clientId);
						pstmt.setInt(8, fromLocationId);
					}else if (type.equalsIgnoreCase("Delivered")){
						pstmt = con.prepareStatement(AutomotiveLogisticsStatements.GET_DASHBOARD_COUNT.replace("STATUS='Open' ","STATUS='Closed' and ROUTE_ID in (select distinct ROUTE_ID from dbo.ROUTE_SKELETON where TYPE='MLL SCM' and SYSTEM_ID=? and CUSTOMER_ID=? and ORIGIN=? )"));
						pstmt.setInt(1,systemId);
						pstmt.setInt(2, clientId);
						pstmt.setInt(3, userId);
						pstmt.setString(4, fromDate);
						pstmt.setString(5, toDate);
						pstmt.setInt(6, systemId);
						pstmt.setInt(7, clientId);
						pstmt.setInt(8, fromLocationId);
					}else if(type.equalsIgnoreCase("All")){
						pstmt = con.prepareStatement(AutomotiveLogisticsStatements.GET_DASHBOARD_COUNT.replace("STATUS='Open' "," ROUTE_ID in (select distinct ROUTE_ID from dbo.ROUTE_SKELETON where TYPE='MLL SCM' and SYSTEM_ID=? and CUSTOMER_ID=? and ORIGIN=? )"));
						pstmt.setInt(1,systemId);
						pstmt.setInt(2, clientId);
						pstmt.setInt(3, userId);
						pstmt.setString(4, fromDate);
						pstmt.setString(5, toDate);
						pstmt.setInt(6, systemId);
						pstmt.setInt(7, clientId);
						pstmt.setInt(8, fromLocationId);
					}
				}
				if (fromLocationId == 0 && toLocationId != 0) {
					if(type.equalsIgnoreCase("In Transit")){
						pstmt = con.prepareStatement(AutomotiveLogisticsStatements.GET_DASHBOARD_COUNT.replace("STATUS='Open' " ," STATUS='Open' and ROUTE_ID in (select distinct ROUTE_ID from dbo.ROUTE_SKELETON where TYPE='MLL SCM' and SYSTEM_ID=? and CUSTOMER_ID=? and DESTINATION=?)"));
						pstmt.setInt(1,systemId);
						pstmt.setInt(2, clientId);
						pstmt.setInt(3, userId);
						pstmt.setString(4, fromDate);
						pstmt.setString(5, toDate);
						pstmt.setInt(6, systemId);
						pstmt.setInt(7, clientId);
						pstmt.setInt(8, toLocationId);
					}else if (type.equalsIgnoreCase("Delivered")){
						pstmt = con.prepareStatement(AutomotiveLogisticsStatements.GET_DASHBOARD_COUNT.replace("STATUS='Open' ","STATUS='Closed' and ROUTE_ID in (select distinct ROUTE_ID from dbo.ROUTE_SKELETON where TYPE='MLL SCM' and SYSTEM_ID=? and CUSTOMER_ID=? and DESTINATION=?)"));
						pstmt.setInt(1,systemId);
						pstmt.setInt(2, clientId);
						pstmt.setInt(3, userId);
						pstmt.setString(4, fromDate);
						pstmt.setString(5, toDate);
						pstmt.setInt(6, systemId);
						pstmt.setInt(7, clientId);
						pstmt.setInt(8, toLocationId);
					}else if(type.equalsIgnoreCase("All")){
						pstmt = con.prepareStatement(AutomotiveLogisticsStatements.GET_DASHBOARD_COUNT.replace("STATUS='Open' "," ROUTE_ID in (select distinct ROUTE_ID from dbo.ROUTE_SKELETON where TYPE='MLL SCM' and SYSTEM_ID=? and CUSTOMER_ID=? and DESTINATION=?)"));
						pstmt.setInt(1,systemId);
						pstmt.setInt(2, clientId);
						pstmt.setInt(3, userId);
						pstmt.setString(4, fromDate);
						pstmt.setString(5, toDate);
						pstmt.setInt(6, systemId);
						pstmt.setInt(7, clientId);
						pstmt.setInt(8, toLocationId);
					}
				}
				
			}
			rs = pstmt.executeQuery();
			while (rs.next()) {
				JsonObject = new JSONObject();
				JsonObject.put("totalcountIndex",rs.getString("COUNTS"));
				JsonObject.put("tripstatusIndex",rs.getString("TRIP_STATUS"));
				JsonArray.put(JsonObject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
	  return JsonArray;
	}
	public ArrayList getVehicleDetailsForDashboard(String fromDate,String toDate,String type,int fromLocationId,int toLocationId,int clientId,int systemId,int userId,String tripStatus) {
		JSONArray JsonArray = null;
		JSONObject JsonObject = null;
		Connection con = null;
	    ResultSet rs = null;
	    PreparedStatement pstmt = null;
	    int count = 0;
		ArrayList<Object> assetList = new ArrayList<Object>();
		ArrayList<ReportHelper> reportsList = new ArrayList<ReportHelper>();
		ArrayList<String> headersList = new ArrayList<String>();
		ReportHelper finalreporthelper = new ReportHelper();

		headersList.add("Sl No");
		headersList.add("Details (From Location_To Location_Vehicle No_Shipment Id)");
		headersList.add("Details (From Location_To Location_Vehicle No_Shipment Id)");
		headersList.add("Details (From Location_To Location_Vehicle No_Shipment Id)");

		try {
			JsonArray = new JSONArray();
			con = DBConnection.getConnectionToDB("AMS");
			if(fromLocationId == 0 && toLocationId == 0){
				if(systemId==214 || systemId==219 || (systemId==200 && clientId==5009)){
					if(type.equalsIgnoreCase("In Transit")){
						pstmt = con.prepareStatement(AutomotiveLogisticsStatements.GET_VEHICLE_DETAILS_FOR_DASHBOARD_NEW);
						pstmt.setInt(1,systemId);
						pstmt.setInt(2, clientId);
						pstmt.setInt(3, userId);
						pstmt.setString(4, fromDate);
						pstmt.setString(5, toDate);
						pstmt.setString(6, tripStatus);
					}else if (type.equalsIgnoreCase("Delivered")){
						pstmt = con.prepareStatement(AutomotiveLogisticsStatements.GET_VEHICLE_DETAILS_FOR_DASHBOARD_NEW.replace("STATUS='Open' ","(STATUS='Closed' or (CARGO_STATUS = 'CLOSED' AND CUSTOMER_ID='5015'))"));
						pstmt.setInt(1,systemId);
						pstmt.setInt(2, clientId);
						pstmt.setInt(3, userId);
						pstmt.setString(4, fromDate);
						pstmt.setString(5, toDate);
						pstmt.setString(6, tripStatus);
					}else if(type.equalsIgnoreCase("All")){
						pstmt = con.prepareStatement(AutomotiveLogisticsStatements.GET_VEHICLE_DETAILS_FOR_DASHBOARD_NEW.replace("and STATUS='Open' "," "));
						pstmt.setInt(1,systemId);
						pstmt.setInt(2, clientId);
						pstmt.setInt(3, userId);
						pstmt.setString(4, fromDate);
						pstmt.setString(5, toDate);
						pstmt.setString(6, tripStatus);
					}
				}
				else {
				if(type.equalsIgnoreCase("In Transit")){
					pstmt = con.prepareStatement(AutomotiveLogisticsStatements.GET_VEHICLE_DETAILS_FOR_DASHBOARD);
					pstmt.setInt(1,systemId);
					pstmt.setInt(2, clientId);
					pstmt.setInt(3, userId);
					pstmt.setString(4, fromDate);
					pstmt.setString(5, toDate);
					pstmt.setString(6, tripStatus);
				}else if (type.equalsIgnoreCase("Delivered")){
					pstmt = con.prepareStatement(AutomotiveLogisticsStatements.GET_VEHICLE_DETAILS_FOR_DASHBOARD.replace("STATUS='Open' ","STATUS='Closed' "));
					pstmt.setInt(1,systemId);
					pstmt.setInt(2, clientId);
					pstmt.setInt(3, userId);
					pstmt.setString(4, fromDate);
					pstmt.setString(5, toDate);
					pstmt.setString(6, tripStatus);
				}else if(type.equalsIgnoreCase("All")){
					pstmt = con.prepareStatement(AutomotiveLogisticsStatements.GET_VEHICLE_DETAILS_FOR_DASHBOARD.replace("and STATUS='Open' "," "));
					pstmt.setInt(1,systemId);
					pstmt.setInt(2, clientId);
					pstmt.setInt(3, userId);
					pstmt.setString(4, fromDate);
					pstmt.setString(5, toDate);
					pstmt.setString(6, tripStatus);
				}
				}
			}else{
				if (fromLocationId != 0 && toLocationId != 0) {
					if(type.equalsIgnoreCase("In Transit")){
						pstmt = con.prepareStatement(AutomotiveLogisticsStatements.GET_VEHICLE_DETAILS_FOR_DASHBOARD.concat(" and a.ROUTE_ID in (select distinct ROUTE_ID from dbo.ROUTE_SKELETON where TYPE='MLL SCM' and SYSTEM_ID=? and CUSTOMER_ID=? and ORIGIN=? and DESTINATION=?)"));
						pstmt.setInt(1,systemId);
						pstmt.setInt(2, clientId);
						pstmt.setInt(3, userId);
						pstmt.setString(4, fromDate);
						pstmt.setString(5, toDate);
						pstmt.setString(6, tripStatus);
						pstmt.setInt(7, systemId);
						pstmt.setInt(8, clientId);
						pstmt.setInt(9, fromLocationId);
						pstmt.setInt(10, toLocationId);
					}else if (type.equalsIgnoreCase("Delivered")){
						pstmt = con.prepareStatement(AutomotiveLogisticsStatements.GET_VEHICLE_DETAILS_FOR_DASHBOARD.replace("STATUS='Open' ", " STATUS='Closed' and a.ROUTE_ID in (select distinct ROUTE_ID from dbo.ROUTE_SKELETON where TYPE='MLL SCM' and SYSTEM_ID=? and CUSTOMER_ID=? and ORIGIN=? and DESTINATION=?)"));
						pstmt.setInt(1,systemId);
						pstmt.setInt(2, clientId);
						pstmt.setInt(3, userId);
						pstmt.setString(4, fromDate);
						pstmt.setString(5, toDate);
						pstmt.setString(6, tripStatus);
						pstmt.setInt(7, systemId);
						pstmt.setInt(8, clientId);
						pstmt.setInt(9, fromLocationId);
						pstmt.setInt(10, toLocationId);
					}else if(type.equalsIgnoreCase("All")){
						pstmt = con.prepareStatement(AutomotiveLogisticsStatements.GET_VEHICLE_DETAILS_FOR_DASHBOARD.replace("and STATUS='Open' ", "and a.ROUTE_ID in (select distinct ROUTE_ID from dbo.ROUTE_SKELETON where TYPE='MLL SCM' and SYSTEM_ID=? and CUSTOMER_ID=? and ORIGIN=? and DESTINATION=?)"));
						pstmt.setInt(1,systemId);
						pstmt.setInt(2, clientId);
						pstmt.setInt(3, userId);
						pstmt.setString(4, fromDate);
						pstmt.setString(5, toDate);
						pstmt.setString(6, tripStatus);
						pstmt.setInt(7, systemId);
						pstmt.setInt(8, clientId);
						pstmt.setInt(9, fromLocationId);
						pstmt.setInt(10, toLocationId);
					}
				}
				if (fromLocationId != 0 && toLocationId == 0) {
					if(type.equalsIgnoreCase("In Transit")){
						pstmt = con.prepareStatement(AutomotiveLogisticsStatements.GET_VEHICLE_DETAILS_FOR_DASHBOARD.concat(" and a.ROUTE_ID in (select distinct ROUTE_ID from dbo.ROUTE_SKELETON where TYPE='MLL SCM' and SYSTEM_ID=? and CUSTOMER_ID=? and ORIGIN=? )"));
						pstmt.setInt(1,systemId);
						pstmt.setInt(2, clientId);
						pstmt.setInt(3, userId);
						pstmt.setString(4, fromDate);
						pstmt.setString(5, toDate);
						pstmt.setString(6, tripStatus);
						pstmt.setInt(7, systemId);
						pstmt.setInt(8, clientId);
						pstmt.setInt(9, fromLocationId);
					}else if (type.equalsIgnoreCase("Delivered")){
						pstmt = con.prepareStatement(AutomotiveLogisticsStatements.GET_VEHICLE_DETAILS_FOR_DASHBOARD.replace("STATUS='Open' ", " STATUS='Closed' and a.ROUTE_ID in (select distinct ROUTE_ID from dbo.ROUTE_SKELETON where TYPE='MLL SCM' and SYSTEM_ID=? and CUSTOMER_ID=? and ORIGIN=? )"));
						pstmt.setInt(1,systemId);
						pstmt.setInt(2, clientId);
						pstmt.setInt(3, userId);
						pstmt.setString(4, fromDate);
						pstmt.setString(5, toDate);
						pstmt.setString(6, tripStatus);
						pstmt.setInt(7, systemId);
						pstmt.setInt(8, clientId);
						pstmt.setInt(9, fromLocationId);
					}else if(type.equalsIgnoreCase("All")){
						pstmt = con.prepareStatement(AutomotiveLogisticsStatements.GET_VEHICLE_DETAILS_FOR_DASHBOARD.replace("and STATUS='Open' ", "and a.ROUTE_ID in (select distinct ROUTE_ID from dbo.ROUTE_SKELETON where TYPE='MLL SCM' and SYSTEM_ID=? and CUSTOMER_ID=? and ORIGIN=? )"));
						pstmt.setInt(1,systemId);
						pstmt.setInt(2, clientId);
						pstmt.setInt(3, userId);
						pstmt.setString(4, fromDate);
						pstmt.setString(5, toDate);
						pstmt.setString(6, tripStatus);
						pstmt.setInt(7, systemId);
						pstmt.setInt(8, clientId);
						pstmt.setInt(9, fromLocationId);
					}
				}
				if (fromLocationId == 0 && toLocationId != 0) {
					if(type.equalsIgnoreCase("In Transit")){
						pstmt = con.prepareStatement(AutomotiveLogisticsStatements.GET_VEHICLE_DETAILS_FOR_DASHBOARD.concat(" and a.ROUTE_ID in (select distinct ROUTE_ID from dbo.ROUTE_SKELETON where TYPE='MLL SCM' and SYSTEM_ID=? and CUSTOMER_ID=? and DESTINATION=?)"));
						pstmt.setInt(1,systemId);
						pstmt.setInt(2, clientId);
						pstmt.setInt(3, userId);
						pstmt.setString(4, fromDate);
						pstmt.setString(5, toDate);
						pstmt.setString(6, tripStatus);
						pstmt.setInt(7, systemId);
						pstmt.setInt(8, clientId);
						pstmt.setInt(9, toLocationId);
					}else if (type.equalsIgnoreCase("Delivered")){
						pstmt = con.prepareStatement(AutomotiveLogisticsStatements.GET_VEHICLE_DETAILS_FOR_DASHBOARD.replace("STATUS='Open' ", " STATUS='Closed' and a.ROUTE_ID in (select distinct ROUTE_ID from dbo.ROUTE_SKELETON where TYPE='MLL SCM' and SYSTEM_ID=? and CUSTOMER_ID=? and DESTINATION=?)"));
						pstmt.setInt(1,systemId);
						pstmt.setInt(2, clientId);
						pstmt.setInt(3, userId);
						pstmt.setString(4, fromDate);
						pstmt.setString(5, toDate);
						pstmt.setString(6, tripStatus);
						pstmt.setInt(7, systemId);
						pstmt.setInt(8, clientId);
						pstmt.setInt(9, toLocationId);
					}else if(type.equalsIgnoreCase("All")){
						pstmt = con.prepareStatement(AutomotiveLogisticsStatements.GET_VEHICLE_DETAILS_FOR_DASHBOARD.replace("and STATUS='Open' ", "and a.ROUTE_ID in (select distinct ROUTE_ID from dbo.ROUTE_SKELETON where TYPE='MLL SCM' and SYSTEM_ID=? and CUSTOMER_ID=? and DESTINATION=?)"));
						pstmt.setInt(1,systemId);
						pstmt.setInt(2, clientId);
						pstmt.setInt(3, userId);
						pstmt.setString(4, fromDate);
						pstmt.setString(5, toDate);
						pstmt.setString(6, tripStatus);
						pstmt.setInt(7, systemId);
						pstmt.setInt(8, clientId);
						pstmt.setInt(9, toLocationId);
					}
				}
					
				}
				rs = pstmt.executeQuery();
				while (rs.next()) {
					JsonObject = new JSONObject();
					count++;
					JsonObject.put("slnoIndex", count);
					ArrayList<Object> informationList = new ArrayList<Object>();
					ReportHelper reporthelper = new ReportHelper();
					informationList.add(count);
					
					JsonObject.put("detailsOneIndex",rs.getString("TRIP_NAME")+" --- "+rs.getString("ASSET_NUMBER")+" --- "+rs.getString("SHIPMENNT_ID"));
					informationList.add(rs.getString("TRIP_NAME")+" --- "+rs.getString("ASSET_NUMBER")+" --- "+rs.getString("SHIPMENNT_ID"));

					if(rs.next()){
						JsonObject.put("detailsTwoIndex",rs.getString("TRIP_NAME")+" --- "+rs.getString("ASSET_NUMBER")+" --- "+rs.getString("SHIPMENNT_ID"));
						informationList.add(rs.getString("TRIP_NAME")+" --- "+rs.getString("ASSET_NUMBER")+" --- "+rs.getString("SHIPMENNT_ID"));

					}
					if(rs.next()){
						JsonObject.put("detailsThreeIndex",rs.getString("TRIP_NAME")+" --- "+rs.getString("ASSET_NUMBER")+" --- "+rs.getString("SHIPMENNT_ID"));
						informationList.add(rs.getString("TRIP_NAME")+" --- "+rs.getString("ASSET_NUMBER")+" --- "+rs.getString("SHIPMENNT_ID"));

					} 
					JsonArray.put(JsonObject);
					reporthelper.setInformationList(informationList);
					reportsList.add(reporthelper);
				}
				finalreporthelper.setReportsList(reportsList);
				finalreporthelper.setHeadersList(headersList);
				assetList.add(JsonArray);
				assetList.add(finalreporthelper);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
	  return assetList;
	}
	public JSONArray getTransitPointForTrip(String vehicleNo,String shipmentId,int systemId,int custId,int offset) {
		JSONArray JsonArray = null;
		JSONObject JsonObject = null;
		Connection con = null;
	    ResultSet rs = null;
	    PreparedStatement pstmt = null;
	    String actualTime="";
	    SimpleDateFormat ddmmyyyy = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
	    SimpleDateFormat ddmmyyyy1 = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
		SimpleDateFormat yyyymmdd = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		String ETA="";
		String TruckType="";
		String Mode="";
		String transitTime="";
		try {
			JsonArray = new JSONArray();
			con = DBConnection.getConnectionToDB("AMS");
			if((systemId==214 && custId!=5015 && custId!=5019) || systemId==200 && custId==5009 ){
				pstmt = con.prepareStatement(AutomotiveLogisticsStatements.GET_TRANSIT_POINT_FOR_TRIP_NEW);
				pstmt.setString(1,shipmentId);
				pstmt.setString(2,shipmentId);
				pstmt.setString(3,shipmentId);
				pstmt.setInt(4,offset);
				pstmt.setInt(5,offset);
				pstmt.setInt(6,offset);
				pstmt.setInt(7,offset);
				pstmt.setInt(8,offset);
				pstmt.setInt(9,offset);
				pstmt.setInt(10,offset);
				pstmt.setInt(11,offset);
				pstmt.setInt(12,systemId);
				pstmt.setInt(13,custId);
				pstmt.setString(14,vehicleNo);
				pstmt.setString(15, shipmentId);
				}
			else {
			pstmt = con.prepareStatement(AutomotiveLogisticsStatements.GET_TRANSIT_POINT_FOR_TRIP);
			
			pstmt.setInt(1,offset);
			pstmt.setInt(2,offset);
			pstmt.setInt(3,offset);
			pstmt.setInt(4,offset);
			pstmt.setInt(5,offset);
			pstmt.setInt(6,offset);
			pstmt.setInt(7,offset);
			pstmt.setInt(8,offset);
			pstmt.setInt(9,systemId);
			pstmt.setInt(10,custId);
			pstmt.setString(11,vehicleNo);
			pstmt.setString(12, shipmentId);
			}
			rs = pstmt.executeQuery();
			int count = 0;
			String etaSource = "";
			String etaDest = "";
			int mins=0;
			int mins1=0;
			int hrs = 0;
			int hrs1 = 0;
		
			while (rs.next()) {
				if (rs.getInt("SEQUENCE")==100) {
					etaDest = rs.getString("PLANNED_TIME");
					transitTime = getTimeDiffrence(etaSource,etaDest);
				}
				JsonObject = new JSONObject();
				ETA=rs.getString("ETA");
				TruckType=rs.getString("VehicleType");
				Mode=rs.getString("MODE");
				JsonObject.put("SLNOIndex",count++);
				JsonObject.put("IdIndex",rs.getInt("ID"));
				if((systemId==214) && (rs.getInt("SEQUENCE") == 100) && custId!=5015){
					JsonObject.put("nameIndex",rs.getString("NAME_1"));
					JsonObject.put("transitIndex",transitTime);
					JsonObject.put("hubLAT",rs.getString("LAST_LAT"));
					JsonObject.put("hubLONG",rs.getString("LAST_LONG"));
				}
				else{
				JsonObject.put("nameIndex",rs.getString("NAME"));
				JsonObject.put("transitIndex",ETA);
				JsonObject.put("hubLAT",rs.getString("HUB_LAT"));
				JsonObject.put("hubLONG",rs.getString("HUB_LONG"));
				}
				JsonObject.put("hubIdIndex",rs.getInt("HUB_ID"));
				JsonObject.put("tripIdIndex",rs.getInt("TRIP_ID"));
				JsonObject.put("revisedTimeIndex",ddmmyyyy.format(yyyymmdd.parse(rs.getString("REVISED_ETA"))));
				if(rs.getString("PLANNED_TIME") == null || rs.getString("PLANNED_TIME").contains("1900-01-01") || rs.getString("PLANNED_TIME").contains("1899-12-31")){
					JsonObject.put("plannedTimeIndex","--");
				}else{
					JsonObject.put("plannedTimeIndex",ddmmyyyy.format(yyyymmdd.parse(rs.getString("PLANNED_TIME"))));				
				}
				if (rs.getInt("SEQUENCE")==0) {
					etaSource = rs.getString("PLANNED_TIME");
					if(rs.getString("ACT_DEP_DATETIME") == null){
						actualTime = "";
					}else{
						actualTime = ddmmyyyy.format(yyyymmdd.parse(rs.getString("ACT_DEP_DATETIME")));				
					}
				}else{
					if(rs.getString("ACTUAL_TIME") == null){
						actualTime = "";
					}else{
						actualTime = ddmmyyyy.format(yyyymmdd.parse(rs.getString("ACTUAL_TIME")));				
					}
				}
				JsonObject.put("actualTimeIndex",actualTime);
				JsonObject.put("sequenceIndex",rs.getInt("SEQUENCE"));
				if (rs.getInt("SEQUENCE")==0) {
					mins1=rs.getInt("MINS_DIFF1");
					hrs1 = mins1/60;
					JsonObject.put("minsdiffIndex", hrs1);	
				}
				else{
					mins=rs.getInt("MINS_DIFF");
					hrs = mins/60;
					JsonObject.put("minsdiffIndex", hrs);
				}
				//JsonObject.put("minsdiffIndex", rs.getInt("MINS_DIFF"));
				JsonObject.put("remarksIndex", rs.getString("REMARKS"));
				JsonObject.put("actionStatusIndex", rs.getString("ACTION_STATUS"));
				JsonObject.put("issuesType",rs.getString("ISSUE"));
				JsonObject.put("tripstatus",rs.getString("TRIP_STATUS"));
				JsonObject.put("shipmentStatusIndex",rs.getString("SHIPMENT_STATUS"));
				JsonObject.put("latitudeIndex",rs.getString("LATITUDE"));
				JsonObject.put("longitudeIndex",rs.getString("LONGITUDE"));
				JsonObject.put("gpsDateTimeIndex",ddmmyyyy.format(yyyymmdd.parse(rs.getString("GPS_DATETIME"))));
				JsonObject.put("locationIndex",rs.getString("LOCATION"));
				JsonObject.put("categoryIndex", rs.getString("CATEGORY"));
				JsonObject.put("speedIndex", rs.getString("SPEED"));
				if (rs.getInt("SEQUENCE")==0) {
					JsonObject.put("pointStatusIndex", "DELAYED");	
				}
				else{
					JsonObject.put("pointStatusIndex", rs.getString("pointstatus"));
				}
				//JsonObject.put("pointStatusIndex", rs.getString("pointstatus"));
				//JsonObject.put("transitIndex",ETA);
				JsonObject.put("truckTypeIndex",TruckType);
				JsonObject.put("modeIndex",Mode);
				JsonObject.put("startDate",ddmmyyyy1.format(yyyymmdd.parse(rs.getString("START_TIME"))));
				JsonObject.put("endDate",ddmmyyyy1.format(yyyymmdd.parse(rs.getString("END_TIME"))));
				JsonArray.put(JsonObject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
	  return JsonArray;	
	  }
	public String insertRemarks(int ID,String remarks,String actionStatus,int tripid,String issues){
	    Connection con = null;
	    PreparedStatement pstmt = null; 
	    ResultSet rs = null;
	    int inserted=0;
	    String message = "";
	    try {
		    	con = DBConnection.getConnectionToDB("AMS");
		    	pstmt = con.prepareStatement(AutomotiveLogisticsStatements.UPDATE_REMARKS_AND_ACTION_STATUS);
		    	pstmt.setString(1,issues);
		    	pstmt.setString(2,remarks);
		    	pstmt.setString(3,actionStatus);
		    	pstmt.setInt(4, ID);
			    inserted = pstmt.executeUpdate();
		        if (inserted > 0) {
		        	if (actionStatus.equalsIgnoreCase("Closed")) {
		        		pstmt = con.prepareStatement(AutomotiveLogisticsStatements.CHECK_ACTION_STATUS_CLOSED);
				    	pstmt.setInt(1,tripid);
				    	rs = pstmt.executeQuery();
					    if (!rs.next()) {
					    	pstmt = con.prepareStatement(AutomotiveLogisticsStatements.UPDATE_TRIP_STATUS_AS_DELAYED_ADDRESSED);
					    	pstmt.setInt(1, tripid);
						    inserted = pstmt.executeUpdate();
						}
					}
		            message = "Updated Successfully";
		        }else{
		        	message = "Error";
		        }
	    	} 	    	
	        catch (Exception e) {	        	
	        	e.printStackTrace();
	        } finally {
	        DBConnection.releaseConnectionToDB(con, pstmt,rs);	       
	    }
	    return message;
	}
	public JSONArray getIssueList() {
		JSONArray JsonArray = null;
		JSONObject JsonObject = null;
		Connection con = null;
	    ResultSet rs = null;
	    PreparedStatement pstmt = null;	   
		try {
			JsonArray = new JSONArray();
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(AutomotiveLogisticsStatements.GET_ISSUES_LIST);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				JsonObject = new JSONObject();
				JsonObject.put("value",rs.getString("VALUE"));
				JsonArray.put(JsonObject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
	  return JsonArray;	
	  }

	
	
	//SimpleDateFormat ddmmyyyy = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
	 DateFormat df6 = new SimpleDateFormat("E MMM dd yyyy HH:mm:ss");
	//SimpleDateFormat yyyymmdd = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	//CashVanManagementFunctions cvsfn=new CashVanManagementFunctions();
	//CommonFunctions cf=new CommonFunctions();
	
	

	public JSONArray getAlertDetails(int offset, String alertID, int systemId ,int customerId , int userId,String fromDate, String toDate,String fromDashboard) {
		Connection con = null;
		PreparedStatement pstmt = null;
		PreparedStatement pstmt1 = null;
		ResultSet rs = null;
		ResultSet rs1 = null;
		String vehicleNo = "";
		String alertDetails = "";
        
		int alertId;
		CommonFunctions commonFunctions = new CommonFunctions();
		JSONArray alertdetailsJSONArray = new JSONArray();
		JSONObject alertdetailsJSONObject = null;
		try {
			Date frmdt=df6.parse(fromDate);
			Date todt=df6.parse(toDate);
			con = DBConnection.getConnectionToDB("AMS");
			alertId = Integer.parseInt(alertID);
			/**
			 * OverSpeed
			 ***/
			if (alertId == 2) {
				
				if(fromDashboard.equals("new") || fromDashboard.equals("MRDASHBOARD")){
					pstmt = con.prepareStatement(AutomotiveLogisticsStatements.GET_OVERSPEED_DETAILS.replace("and a.TRIP_START_TIME between ? and ?", ""));
					pstmt.setInt(1,systemId);
					pstmt.setInt(2, customerId);
					pstmt.setInt(3, userId);
				}
				else{
				pstmt = con.prepareStatement(AutomotiveLogisticsStatements.GET_OVERSPEED_DETAILS);
				pstmt.setInt(1,systemId);
				pstmt.setInt(2, customerId);
				pstmt.setInt(3, userId);
				pstmt.setString(4, sdf.format(frmdt));
				pstmt.setString(5, sdf.format(todt));
				}
				
				rs = pstmt.executeQuery();
				while (rs.next()) {
					alertdetailsJSONObject = new JSONObject();
					vehicleNo = rs.getString("ASSET_NUMBER");
					alertDetails = vehicleNo + " overspeeded " + rs.getString("LOCATION") + " On " + ddmmyyyy.format(sdf.parse(rs.getString("GPS_DATETIME"))) + " with Speed "+rs.getString("SPEED")+" km/h" ;
					alertdetailsJSONObject.put("alertdetails", alertDetails);
					alertdetailsJSONObject.put("alertslno",rs.getString("ID"));
					alertdetailsJSONObject.put("vehicleNo",vehicleNo);
					alertdetailsJSONObject.put("gmt",rs.getString("GMT"));
					alertdetailsJSONArray.put(alertdetailsJSONObject);
				
				}
			}
			
			 
			else if (alertId == 1)
				
			{
				if(fromDashboard.equals("new") || fromDashboard.equals("MRDASHBOARD")){
					pstmt = con.prepareStatement(AutomotiveLogisticsStatements.GET_STOPPAGE_DETAILS.replace("and a.TRIP_START_TIME between ? and ?", ""));
					pstmt.setInt(1,systemId);
					pstmt.setInt(2, customerId);
					pstmt.setInt(3, userId);
				}
				else{
				pstmt = con.prepareStatement(AutomotiveLogisticsStatements.GET_STOPPAGE_DETAILS);
				pstmt.setInt(1,systemId);
				pstmt.setInt(2, customerId);
				pstmt.setInt(3, userId);
				pstmt.setString(4, sdf.format(frmdt));
				pstmt.setString(5, sdf.format(todt));
				}
				rs = pstmt.executeQuery();
				while (rs.next()) {
					alertdetailsJSONObject = new JSONObject();
					vehicleNo = rs.getString("ASSET_NUMBER");
					alertDetails = vehicleNo + " stopped " + rs.getString("LOCATION") + " On " + ddmmyyyy.format(sdf.parse(rs.getString("GPS_DATETIME"))) + " stopped for " + commonFunctions.getDayHrMinFormat(rs.getDouble("STOP_HOURS")) + "(dd:hh:mm)";
					alertdetailsJSONObject.put("alertdetails", alertDetails);
					alertdetailsJSONObject.put("alertslno",rs.getString("SLNO"));
					alertdetailsJSONObject.put("vehicleNo",vehicleNo);
					alertdetailsJSONObject.put("gmt",rs.getString("GMT"));
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

	@SuppressWarnings("unchecked")
	public ArrayList<ArrayList> getActionLogDetails(String clientId, int systemId,
			String startDate, String endDate, int offset) {
		
	    Connection con = null;
	    PreparedStatement pstmt = null; 
	    ResultSet rs = null;
	    PreparedStatement pstmt1 = null; 
	    ResultSet rs1 = null;
	    String shipmentid="";
	    String tripname="";
	    String assetnumber="";
	    String vehicletype="";
	    String groupname="";
	    String gateinatsource="";
	    String gateoutatsource="";
	    String scheduledarriatdest="";
	    String actarrivaldest="";
	    String plannedTripStartTime = "";
	    double stoppagetime=0;
	    int inplanttat=0;
	    String tripstarttime="";
	    String tripendtime="";
	    int scheduledtat=0;
	    int actualtat=0;
	    String deliverystatus = "";
	    int totaldelay = 0;
	    String comments = "";
	    
	    CommonFunctions cf = new CommonFunctions();
	    ArrayList<ArrayList> datalist = new ArrayList<ArrayList>();
	    
	    try {
	    	con = DBConnection.getConnectionToDB("AMS");
	    	ArrayList<Object> informationList = new ArrayList<Object>();
	    	String sys[]=null;
	    	boolean systemExist=false;
	    	Properties properties = ApplicationListener.prop;
			String MllActionLogSystemIds = properties.getProperty("MllActionLogSystemIds").trim();
	    	  if(MllActionLogSystemIds !=null && MllActionLogSystemIds!=""){
	    		  sys=MllActionLogSystemIds.split(",");
	    	  }

	    	for(int i=0;i<sys.length;i++){
			int sysId=Integer.parseInt(sys[i]);
			if(systemId==sysId){
				systemExist=true;
				break;
				}
			}
	    	//if(systemId==214 || systemId==291){
	    	if(systemExist || (systemId==200 && Integer.parseInt(clientId)==5009)){
	        pstmt = con.prepareStatement(AutomotiveLogisticsStatements.GET_TRIP_DETAILS);
	    	}
	    	else{
	    		 pstmt = con.prepareStatement(AutomotiveLogisticsStatements.GET_HUB_REPORT);	
	    	}
	        pstmt.setInt(1, systemId);
	        pstmt.setString(2, clientId);
	        pstmt.setString(3, startDate);
	        pstmt.setString(4, endDate);
	        rs=pstmt.executeQuery();
	        int count=1;
	        int checkpoints=0;
	        int diff=0;
	    	while(rs.next())
	    	{
	    	    gateinatsource="";
	    	    gateoutatsource="";
	    	    scheduledarriatdest="";
	    	    actarrivaldest="";
	    	    inplanttat=0;
	    	    tripstarttime="";
	    	    tripendtime="";
	    	    scheduledtat=0;
	    	    actualtat=0;
	    	    deliverystatus = "";
	    	    totaldelay = 0;
	    	    comments = "";
	    	    plannedTripStartTime = "";
	    		informationList = new ArrayList<Object>();
	    		shipmentid=rs.getString("SHIPMENNT_ID");
	    		tripname=rs.getString("TRIP_NAME");
	    		assetnumber=rs.getString("ASSET_NUMBER");
	    		vehicletype=rs.getString("VehicleType");
	    		groupname=rs.getString("GROUP_NAME");
	    		stoppagetime=rs.getDouble("STOPPAGE_TIME");
	    		
	    		informationList.add(count++);
	    		informationList.add(shipmentid);
	    		informationList.add(tripname);
	    		informationList.add(assetnumber);
	    		informationList.add(vehicletype);
	    		informationList.add(groupname);
	    		//if(systemId==214 || systemId==291){
	    		if(systemExist || (systemId==200 && Integer.parseInt(clientId)==5009)){
	    	        pstmt1 = con.prepareStatement(AutomotiveLogisticsStatements.GET_CHECKPOINT_DETAILS_NEW);
	    	    	}
	    	    	else{
	    		 pstmt1 = con.prepareStatement(AutomotiveLogisticsStatements.GET_CHECKPOINT_DETAILS);
	    	    	}
	    		 pstmt1.setInt(1, offset);
	    		 pstmt1.setInt(2, offset);
	    		 pstmt1.setInt(3, offset);
	    		 pstmt1.setInt(4, offset);
	    		 pstmt1.setInt(5, offset);
			        pstmt1.setInt(6, systemId);
			        pstmt1.setString(7, clientId);
			        pstmt1.setInt(8, rs.getInt("TRIP_ID"));
			        rs1=pstmt1.executeQuery();
			        while(rs1.next())
			    	{  
			        	if (rs1.getInt("SEQUENCE")!=0 && rs1.getInt("SEQUENCE")!=100) {
			        		checkpoints++;
				        	diff=(rs1.getInt("diffhh"))/60;
				        	informationList.add(rs1.getString("NAME"));
				        	if(rs1.getString("ETA").equals("")|| rs1.getString("ETA").contains("1900"))
							{
				        		informationList.add("");
							}
							else
							{	
								   informationList.add(ddmmyyyy.format(rs1.getTimestamp("ETA")));
							}
				        	if(rs1.getString("actualtime").equals("")|| rs1.getString("actualtime").contains("1900"))
							{
				        		informationList.add("");
							}
							else
							{	
								   informationList.add(ddmmyyyy.format(rs1.getTimestamp("actualtime")));
							}
				        	
				        	if ((diff >= 1) && (rs1.getString("STATUS").equalsIgnoreCase("DELAYED"))) {
				        		informationList.add(diff+" Hours and More");
							}else {
								informationList.add("");
							}
				        	
				        	informationList.add(rs1.getString("issues"));
				        	informationList.add(rs1.getString("remarks"));
				        	informationList.add(rs1.getString("actionstatus"));
						}
			        	 
			        	if (rs1.getInt("SEQUENCE")==0) {
			        		plannedTripStartTime =ddmmyyyy.format(rs1.getTimestamp("ETA"));
			        		if(rs1.getString("actualtime").equals("") || rs1.getString("actualtime").contains("1900"))
							{
			        			gateinatsource="";
							}
							else
							{	
								gateinatsource=ddmmyyyy.format(rs1.getTimestamp("actualtime"));
							}
			        		if(rs1.getString("actualtimedep").equals("") || rs1.getString("actualtimedep").contains("1900"))
							{
			        			if(rs1.getString("ETA").equals("") || rs1.getString("ETA").contains("1900"))
								{
				        			gateoutatsource=ddmmyyyy.format(rs.getTimestamp("TRIP_START_TIME"));
					        	    tripstarttime=ddmmyyyy.format(rs.getTimestamp("TRIP_START_TIME"));
								}else{
									gateoutatsource=ddmmyyyy.format(rs1.getTimestamp("ETA"));
					        	    tripstarttime=ddmmyyyy.format(rs1.getTimestamp("ETA"));
								}
							}
							else
							{	
								gateoutatsource=ddmmyyyy.format(rs1.getTimestamp("actualtimedep"));
				        	    tripstarttime=ddmmyyyy.format(rs1.getTimestamp("actualtimedep"));
							}
						}
			        	if (rs1.getInt("SEQUENCE")==100) {
			        		scheduledarriatdest=ddmmyyyy.format(rs1.getTimestamp("ETA"));
			        		if(rs1.getString("actualtime").equals("")|| rs1.getString("actualtime").contains("1900"))
							{
			        			actarrivaldest="";
				        	    tripendtime="";
							}
							else
							{	
								 actarrivaldest=ddmmyyyy.format(rs1.getTimestamp("actualtime"));
					        	    tripendtime=ddmmyyyy.format(rs1.getTimestamp("actualtime"));
							}
						}
			    	}
			       
			        if(checkpoints<25){
				        for(int i=0;i<25-checkpoints;i++)
				        {
				        	informationList.add("");
				        	informationList.add("");
				        	informationList.add("");
				        	informationList.add("");
				        	informationList.add("");
				        	informationList.add("");
				        	informationList.add("");
				        }
			        
			        }
			        if(tripstarttime!="" && !tripstarttime.contains("1900") && scheduledarriatdest!="" && !scheduledarriatdest.contains("1900"))
					{
			        	scheduledtat = cf.getTimeDiffrence(ddmmyyyy.parse(plannedTripStartTime), ddmmyyyy.parse(scheduledarriatdest));
					}
			        if(tripstarttime!="" && !tripstarttime.contains("1900") && tripendtime!="" && !tripendtime.contains("1900"))
					{
			        	actualtat = cf.getTimeDiffrence(ddmmyyyy.parse(tripstarttime), ddmmyyyy.parse(tripendtime));
			        	totaldelay = scheduledtat - actualtat;
				        if (totaldelay<0) {
				        	totaldelay = actualtat - scheduledtat;
							deliverystatus = "DELAYED";
						}else if (totaldelay>1) {
							totaldelay = 0;
							deliverystatus = "BEFORE TIME";
						}else{
							totaldelay = 0;
							deliverystatus = "ON TIME";
						}
					}
			        
			        if(gateinatsource!="" && !gateinatsource.contains("1900") && gateinatsource!="" && !gateinatsource.contains("1900"))
					{
			        	inplanttat= cf.getTimeDiffrence(ddmmyyyy.parse(gateinatsource), ddmmyyyy.parse(gateoutatsource));
					}
			        	    informationList.add(gateinatsource);
				        	informationList.add(gateoutatsource);
				        	informationList.add(scheduledarriatdest);
				        	informationList.add(actarrivaldest);
				        	informationList.add(cf.convertMinutesToHHMMFormat1(inplanttat));
				        	informationList.add(stoppagetime);
				        	informationList.add(tripstarttime);
				        	informationList.add(tripendtime);
				        	informationList.add(cf.convertMinutesToHHMMFormat1(scheduledtat));
				        	informationList.add(cf.convertMinutesToHHMMFormat1(actualtat));
				        	informationList.add(deliverystatus);
				        	informationList.add(cf.convertMinutesToHHMMFormat1(totaldelay));
				        	informationList.add(comments);
				        	
			        		datalist.add(informationList);
			        		checkpoints=0;
			      
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt1, rs1);
			DBConnection.releaseConnectionToDB(null, pstmt, rs);
		}
		return datalist;
	}
	
	@SuppressWarnings("unchecked")
	public ArrayList<ArrayList> getActionLogDetailsNew(String clientId, int systemId,
			String startDate, String endDate, int offset) {
		 
	    Connection con = null;
	    PreparedStatement pstmt = null; 
	    ResultSet rs = null;
	    PreparedStatement pstmt1 = null; 
	    ResultSet rs1 = null;
	    String shipmentid="";
	    String tripname="";
	    String assetnumber="";
	    String vehicletype="";
	    String groupname="";
	    String gateinatsource="";
	    String gateoutatsource="";
	    String scheduledarriatdest="";
	    String actarrivaldest="";
	    String plannedTripStartTime = "";
	    double stoppagetime=0;
	    int inplanttat=0;
	    String tripstarttime="";
	    String tripendtime="";
	    int scheduledtat=0;
	    int actualtat=0;
	    String deliverystatus = "";
	    int totaldelay = 0;
	    String comments = "";
	    int MAX_POINT = 0;
	    
	    CommonFunctions cf = new CommonFunctions();
	    ArrayList<ArrayList> datalist = new ArrayList<ArrayList>();
	    
	    try {
	    	con = DBConnection.getConnectionToDB("AMS");
	    	ArrayList<Object> informationList = new ArrayList<Object>();
	    	String sys[]=null;
	    	boolean systemExist=false;
	    	Properties properties = ApplicationListener.prop;
	    				String MllActionLogSystemIds = properties.getProperty("MllActionLogSystemIds").trim();
	    		    	  if(MllActionLogSystemIds !=null && MllActionLogSystemIds!=""){
	    		    		  sys=MllActionLogSystemIds.split(",");
	    		    	  }

	    	for(int i=0;i<sys.length;i++){
	    				int sysId=Integer.parseInt(sys[i]);
	    				if(systemId==sysId){
	    					systemExist=true;
	    					break;
	    				}
	    				}
	    	//if(systemId==214 || systemId==291){
	    	if(systemExist || (systemId==200 && Integer.parseInt(clientId)==5009)){
	        pstmt = con.prepareStatement(AutomotiveLogisticsStatements.GET_TRIP_DETAILS);
	    	}
	    	else{
	    		 pstmt = con.prepareStatement(AutomotiveLogisticsStatements.GET_HUB_REPORT);	
	    	}
	        pstmt.setInt(1, systemId);
	        pstmt.setString(2, clientId);
	        pstmt.setString(3, startDate);
	        pstmt.setString(4, endDate);
	        rs=pstmt.executeQuery();
	        int count=1;
	        int checkpoints=0;
	        int diff=0;
	    	while(rs.next())
	    	{
	    		checkpoints=0;
	    		if(MAX_POINT<(rs.getInt("MAX_TRANSIT_POINT")-2)){
        		MAX_POINT = rs.getInt("MAX_TRANSIT_POINT")-2; 
        		}
	    	    gateinatsource="";
	    	    gateoutatsource="";
	    	    scheduledarriatdest="";
	    	    actarrivaldest="";
	    	    inplanttat=0;
	    	    tripstarttime="";
	    	    tripendtime="";
	    	    scheduledtat=0;
	    	    actualtat=0;
	    	    deliverystatus = "";
	    	    totaldelay = 0;
	    	    comments = "";
	    	    plannedTripStartTime = "";
	    		informationList = new ArrayList<Object>();
	    		shipmentid=rs.getString("SHIPMENNT_ID");
	    		tripname=rs.getString("TRIP_NAME");
	    		assetnumber=rs.getString("ASSET_NUMBER");
	    		vehicletype=rs.getString("VehicleType");
	    		groupname=rs.getString("GROUP_NAME");
	    		stoppagetime=rs.getDouble("STOPPAGE_TIME");
	    		
	    		informationList.add(count++);
	    		informationList.add(shipmentid);
	    		informationList.add(tripname);
	    		informationList.add(assetnumber);
	    		informationList.add(vehicletype);
	    		informationList.add(groupname);
	    		//if(systemId==214 || systemId==291){
	    		if(systemExist || (systemId==200 && Integer.parseInt(clientId)==5009)){
	    	        pstmt1 = con.prepareStatement(AutomotiveLogisticsStatements.GET_CHECKPOINT_DETAILS_New);
	    	        pstmt1.setInt(1, offset);
		    		 pstmt1.setInt(2, offset);
		    		 pstmt1.setInt(3, offset);
		    		 pstmt1.setInt(4, offset);
				        pstmt1.setInt(5, systemId);
				        pstmt1.setString(6, clientId);
				        pstmt1.setInt(7, rs.getInt("TRIP_ID"));
				        rs1=pstmt1.executeQuery();
	    	    	}
	    	    	else{
	    		 pstmt1 = con.prepareStatement(AutomotiveLogisticsStatements.GET_CHECKPOINT_DETAILS);
	    		 pstmt1.setInt(1, offset);
	    		 pstmt1.setInt(2, offset);
	    		 pstmt1.setInt(3, offset);
	    		 pstmt1.setInt(4, offset);
	    		 pstmt1.setInt(5, offset);
			        pstmt1.setInt(6, systemId);
			        pstmt1.setString(7, clientId);
			        pstmt1.setInt(8, rs.getInt("TRIP_ID"));
			        rs1=pstmt1.executeQuery();
	    	    	}
	    		
			        while(rs1.next())
			    	{ 
			        	if (rs1.getInt("SEQUENCE")!=0 && rs1.getInt("SEQUENCE")!=100) {
			        		checkpoints++;
				        	diff=(rs1.getInt("diffhh"))/60;
				        	informationList.add(rs1.getString("NAME"));
				        	if(rs1.getString("ETA").equals("")|| rs1.getString("ETA").contains("1900"))
							{
				        		informationList.add("");
							}
							else
							{	
								   informationList.add(ddmmyyyy.format(rs1.getTimestamp("ETA")));
							}
				        	if(rs1.getString("actualtime").equals("")|| rs1.getString("actualtime").contains("1900"))
							{
				        		informationList.add("");
							}
							else
							{	
								   informationList.add(ddmmyyyy.format(rs1.getTimestamp("actualtime")));
							}
				        	if ((diff >= 1) && (rs1.getString("STATUS").equalsIgnoreCase("DELAYED"))) {
				        		informationList.add(diff+" Hours and More");
							}else {
								informationList.add("");
							}
				        	
				        	if(rs1.getString("planneDepTime").equals("")|| rs1.getString("planneDepTime").contains("1900"))
							{
				        		informationList.add("");
							}
							else
							{	
								   informationList.add(ddmmyyyy.format(rs1.getTimestamp("planneDepTime")));
							}
				        	if(rs1.getString("actualtimedep").equals("")|| rs1.getString("actualtimedep").contains("1900"))
							{
				        		informationList.add("");
							}
							else
							{	
								   informationList.add(ddmmyyyy.format(rs1.getTimestamp("actualtimedep")));
							}
				        	
				        	
				        	informationList.add(rs1.getString("issues"));
				        	informationList.add(rs1.getString("remarks"));
				        	informationList.add(rs1.getString("actionstatus"));
						}
			        	 
			        	if (rs1.getInt("SEQUENCE")==0) {
			        		/*if(MAX_POINT<rs1.getInt("MAX_TRANSIT_POINT")){
				        		MAX_POINT = rs1.getInt("MAX_TRANSIT_POINT"); 
				        		}*/
			        		
			        		diff=(rs1.getInt("diffhh"))/60;
				        	informationList.add(rs1.getString("NAME"));
				        	if(rs1.getString("planneDepTime").equals("")|| rs1.getString("planneDepTime").contains("1900"))
							{
				        		informationList.add("");
							}
							else
							{	
								   informationList.add(ddmmyyyy.format(rs1.getTimestamp("planneDepTime")));
							}
				        	
				        	if(rs1.getString("actualtime").equals("")|| rs1.getString("actualtime").contains("1900"))
							{
				        		informationList.add("");
							}
							else
							{	
								   informationList.add(ddmmyyyy.format(rs1.getTimestamp("actualtime")));
							}
				        	if ((diff >= 1) && (rs1.getString("STATUS").equalsIgnoreCase("DELAYED"))) {
				        		informationList.add(diff+" Hours and More");
							}else {
								informationList.add("");
							}
				        	
				        	if(rs1.getString("ETA").equals("")|| rs1.getString("ETA").contains("1900"))
							{
				        		informationList.add("");
							}
							else
							{	
								   informationList.add(ddmmyyyy.format(rs1.getTimestamp("ETA")));
							}
				        	
				        	if(rs1.getString("actualtimedep").equals("")|| rs1.getString("actualtimedep").contains("1900"))
							{
				        		informationList.add("");
							}
							else
							{	
								   informationList.add(ddmmyyyy.format(rs1.getTimestamp("actualtimedep")));
							}
				        	
				        	informationList.add(rs1.getString("issues"));
				        	informationList.add(rs1.getString("remarks"));
				        	informationList.add(rs1.getString("actionstatus"));
			        		
			        		
			        		plannedTripStartTime =ddmmyyyy.format(rs1.getTimestamp("ETA"));
			        		if(rs1.getString("actualtime").equals("") || rs1.getString("actualtime").contains("1900"))
							{
			        			gateinatsource="";
							}
							else
							{	
								gateinatsource=ddmmyyyy.format(rs1.getTimestamp("actualtime"));
							}
			        		if(rs1.getString("actualtimedep").equals("") || rs1.getString("actualtimedep").contains("1900"))
							{
			        			if(rs1.getString("ETA").equals("") || rs1.getString("ETA").contains("1900"))
								{
				        			gateoutatsource=ddmmyyyy.format(rs.getTimestamp("TRIP_START_TIME"));
					        	    tripstarttime=ddmmyyyy.format(rs.getTimestamp("TRIP_START_TIME"));
								}else{
									gateoutatsource=ddmmyyyy.format(rs1.getTimestamp("ETA"));
					        	    tripstarttime=ddmmyyyy.format(rs1.getTimestamp("ETA"));
								}
							}
							else
							{	
								gateoutatsource=ddmmyyyy.format(rs1.getTimestamp("actualtimedep"));
				        	    tripstarttime=ddmmyyyy.format(rs1.getTimestamp("actualtimedep"));
							}
						}
			        	if (rs1.getInt("SEQUENCE")==100) {
			        		
			        		//if(MAX_POINT<20){
						        for(int i=0;i<MAX_POINT-checkpoints;i++)
						        {
						        	informationList.add("");
						        	informationList.add("");
						        	informationList.add("");
						        	informationList.add("");
						        	informationList.add("");
						        	informationList.add("");
						        	informationList.add("");
						        	informationList.add("");
						        	informationList.add("");
						        }
					        
					       // }
			        		
			        		diff=(rs1.getInt("diffhh"))/60;
				        	informationList.add(rs1.getString("NAME"));
				        	if(rs1.getString("ETA").equals("")|| rs1.getString("ETA").contains("1900"))
							{
				        		informationList.add("");
							}
							else
							{	
								   informationList.add(ddmmyyyy.format(rs1.getTimestamp("ETA")));
							}
				        	if(rs1.getString("actualtime").equals("")|| rs1.getString("actualtime").contains("1900"))
							{
				        		informationList.add("");
							}
							else
							{	
								   informationList.add(ddmmyyyy.format(rs1.getTimestamp("actualtime")));
							}
				        	
				        	if ((diff >= 1) && (rs1.getString("STATUS").equalsIgnoreCase("DELAYED"))) {
				        		informationList.add(diff+" Hours and More");
							}else {
								informationList.add("");
							}
				        	if(rs1.getString("planneDepTime").equals("")|| rs1.getString("planneDepTime").contains("1900"))
							{
				        		informationList.add("");
							}
							else
							{	
								   informationList.add(ddmmyyyy.format(rs1.getTimestamp("planneDepTime")));
							}
				        	if(rs1.getString("actualtimedep").equals("")|| rs1.getString("actualtimedep").contains("1900"))
							{
				        		informationList.add("");
							}
							else
							{	
								   informationList.add(ddmmyyyy.format(rs1.getTimestamp("actualtimedep")));
							}
				        	
				        	informationList.add(rs1.getString("issues"));
				        	informationList.add(rs1.getString("remarks"));
				        	informationList.add(rs1.getString("actionstatus"));
			        		
			        		scheduledarriatdest=ddmmyyyy.format(rs1.getTimestamp("ETA"));
			        		if(rs1.getString("actualtime").equals("")|| rs1.getString("actualtime").contains("1900"))
							{
			        			actarrivaldest="";
				        	    tripendtime="";
							}
							else
							{	
								 actarrivaldest=ddmmyyyy.format(rs1.getTimestamp("actualtime"));
					        	    tripendtime=ddmmyyyy.format(rs1.getTimestamp("actualtime"));
							}
						}
			    	}
			       
			        
			        if(tripstarttime!="" && !tripstarttime.contains("1900") && scheduledarriatdest!="" && !scheduledarriatdest.contains("1900"))
					{
			        	scheduledtat = cf.getTimeDiffrence(ddmmyyyy.parse(plannedTripStartTime), ddmmyyyy.parse(scheduledarriatdest));
					}
			        if(tripstarttime!="" && !tripstarttime.contains("1900") && tripendtime!="" && !tripendtime.contains("1900"))
					{
			        	actualtat = cf.getTimeDiffrence(ddmmyyyy.parse(tripstarttime), ddmmyyyy.parse(tripendtime));
			        	totaldelay = scheduledtat - actualtat;
				        if (totaldelay<0) {
				        	totaldelay = actualtat - scheduledtat;
							deliverystatus = "DELAYED";
						}else if (totaldelay>1) {
							totaldelay = 0;
							deliverystatus = "BEFORE TIME";
						}else{
							totaldelay = 0;
							deliverystatus = "ON TIME";
						}
					}
			        
			        if(gateinatsource!="" && !gateinatsource.contains("1900") && gateinatsource!="" && !gateinatsource.contains("1900"))
					{
			        	inplanttat= cf.getTimeDiffrence(ddmmyyyy.parse(gateinatsource), ddmmyyyy.parse(gateoutatsource));
					}
			        	   /* informationList.add(gateinatsource);
				        	informationList.add(gateoutatsource);
				        	informationList.add(scheduledarriatdest);
				        	informationList.add(actarrivaldest);
				        	informationList.add(cf.convertMinutesToHHMMFormat1(inplanttat));*/
				        	informationList.add(stoppagetime);
				        	informationList.add(tripstarttime);
				        	informationList.add(tripendtime);
				        	informationList.add(cf.convertMinutesToHHMMFormat1(scheduledtat));
				        	informationList.add(cf.convertMinutesToHHMMFormat1(actualtat));
				        	informationList.add(deliverystatus);
				        	informationList.add(cf.convertMinutesToHHMMFormat1(totaldelay));
				        	informationList.add(comments);
				        	//informationList.add(MAX_POINT);
			        		datalist.add(informationList);
			        		checkpoints=0;
			      
			}
	    	informationList = new ArrayList<Object>();
	    	informationList.add(MAX_POINT);
	    	datalist.add(informationList);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt1, rs1);
			DBConnection.releaseConnectionToDB(null, pstmt, rs);
		}
		return datalist;
	}
	
	public  String getTimeDiffrence(String stopIn,String stopOut)
	{
		long diffhrs=0;
		long mins=0;
		Date stopIndate=null;
		Date stopOutDate=null;
		String diffhrsString ="";
		String minsString ="";
		try{
		SimpleDateFormat dateformat2 = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		stopIndate=dateformat2.parse(stopIn);
		stopOutDate =dateformat2.parse(stopOut);
		}
		catch(Exception e){
			
			e.printStackTrace();
		}
		
		long difference = stopOutDate.getTime() - stopIndate.getTime();
		diffhrs = (difference/(1000*60*60));
		mins=(difference/(1000*60))%60;
		
		if(diffhrs<10){
			diffhrsString = "0"+diffhrs;
		}
		else{
			diffhrsString = ""+diffhrs;
		}
		if(mins<10){
			minsString = "0"+mins;
		}
		else{
			minsString = ""+mins;
		}
		
		return diffhrsString +":"+minsString;
	}
	
	public ArrayList<Object> getVehicleAvailabilityAndInTransitDetails(int systemId,int customerId,String startDate, String endDate,String reportType, int offset,String language) {
		SimpleDateFormat ddmmyyyy = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
		SimpleDateFormat mmddyyyy = new SimpleDateFormat("MM/dd/yyyy HH:mm:ss");
		//System.out.println("systemId="+systemId+"customerId="+customerId+"startDate ="+startDate+" ,endDate ="+endDate);
		
	    Connection con = null;
	    PreparedStatement pstmt = null; 
	    ResultSet rs = null;
	    
	    JSONObject obj = null;
		JSONArray jsonArray = new JSONArray();
		ArrayList<Object> finalist = new ArrayList<Object>();
		ArrayList<String> headersList = new ArrayList<String>();
		ArrayList<ReportHelper> reportList = new ArrayList<ReportHelper>();
		ArrayList<Object> informationList =null;
		ReportHelper finalReportHelper = new ReportHelper();
		int count = 0;
	    
	    try {
	    	headersList.add(cf.getLabelFromDB("SLNO", language));
			headersList.add(cf.getLabelFromDB("Source", language));
			headersList.add(cf.getLabelFromDB("Destination", language));
			headersList.add(cf.getLabelFromDB("Arrival_Date_Time", language));
			headersList.add(cf.getLabelFromDB("Vehicle_No", language));
			headersList.add(cf.getLabelFromDB("Current_Location", language));
			headersList.add(cf.getLabelFromDB("Expected_Date_Time", language));
	    	
	    	
	    	con = DBConnection.getConnectionToDB("AMS");
	    	if(reportType.equals("Vehicle Availability")){
	    		informationList = new ArrayList<Object>();
		        pstmt = con.prepareStatement(AutomotiveLogisticsStatements.GET_VEHICLE_AVAILABILITY_DETAILS);
		        pstmt.setInt(1, systemId);
		        pstmt.setInt(2, customerId);
		        pstmt.setInt(3, systemId);
		        pstmt.setInt(4, customerId);
		        rs=pstmt.executeQuery();
		    	while(rs.next())
		    	{
		    		count ++;
					obj = new JSONObject();
					informationList = new ArrayList<Object>();
					ReportHelper reportHelper = new ReportHelper();
					
					obj.put("slnoIndex", count);
					informationList.add(count);
					
					obj.put("sourceIndex", "");
					informationList.add("");
					
					obj.put("destinationIndex", rs.getString("DESTINATION"));
					informationList.add(rs.getString("DESTINATION"));
					
					if(rs.getString("ACT_ARR_DATETIME").contains("1900")){
						obj.put("arrivalTimeIndex", "");
						informationList.add("");
					}else{
						obj.put("arrivalTimeIndex", mmddyyyy.format(sdf.parse(rs.getString("ACT_ARR_DATETIME"))));
						informationList.add(ddmmyyyy.format(sdf.parse(rs.getString("ACT_ARR_DATETIME"))));
					}
					
					obj.put("assetNoIndex", rs.getString("ASSET_NUMBER"));
					informationList.add(rs.getString("ASSET_NUMBER"));
					
					obj.put("currentLocationIndex", rs.getString("LOCATION"));
					informationList.add(rs.getString("LOCATION"));
					
					obj.put("expectedDateTimeIndex", "");
					informationList.add("");				
				
		    		jsonArray.put(obj);
					reportHelper.setInformationList(informationList);
					reportList.add(reportHelper);
				}
				finalReportHelper.setHeadersList(headersList);
				finalReportHelper.setReportsList(reportList);
				finalist.add(jsonArray);
				finalist.add(finalReportHelper);
	    	}else if(reportType.equals("In Transit Vehicles")){
	    		informationList = new ArrayList<Object>();
		        pstmt = con.prepareStatement(AutomotiveLogisticsStatements.GET_IN_TRANSIT_VEHICLE_DETAILS);
		        pstmt.setInt(1, systemId);
		        pstmt.setInt(2, customerId);
		        pstmt.setString(3, startDate);
		        pstmt.setString(4, endDate);
		        rs=pstmt.executeQuery();
		    	while(rs.next())
		    	{
		    		count ++;
					obj = new JSONObject();
					informationList = new ArrayList<Object>();
					ReportHelper reportHelper = new ReportHelper();
					
					obj.put("slnoIndex", count);
					informationList.add(count);
					
					obj.put("sourceIndex", rs.getString("SOURCE"));
					informationList.add(rs.getString("SOURCE"));
					
					obj.put("destinationIndex", rs.getString("DESTINATION"));
					informationList.add(rs.getString("DESTINATION"));
					
					obj.put("arrivalTimeIndex", "");
					informationList.add("");
					
					obj.put("assetNoIndex", rs.getString("ASSET_NUMBER"));
					informationList.add(rs.getString("ASSET_NUMBER"));
					
					obj.put("currentLocationIndex", rs.getString("LOCATION"));
					informationList.add(rs.getString("LOCATION"));
					
					if(rs.getString("EXP_ARR_DATETIME").contains("1900")){
						obj.put("expectedDateTimeIndex", "");
						informationList.add("");
					}else{
						obj.put("expectedDateTimeIndex", mmddyyyy.format(sdf.parse(rs.getString("EXP_ARR_DATETIME"))));
						informationList.add(ddmmyyyy.format(sdf.parse(rs.getString("EXP_ARR_DATETIME"))));
					}
		    		jsonArray.put(obj);
					reportHelper.setInformationList(informationList);
					reportList.add(reportHelper);
				}
				finalReportHelper.setHeadersList(headersList);
				finalReportHelper.setReportsList(reportList);
				finalist.add(jsonArray);
				finalist.add(finalReportHelper);
	    	}
	    	
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return finalist;
	}

	
	public String getCloseTrip(int offset, int systemId, int clientId,
			int userId, String shipmentId, String tripId, String vehicleNo) {
		Connection con = null;
	    PreparedStatement pstmt = null; 
	    ResultSet rs = null;
	    String message ="Trip not closed";
	    String sourcelat="";
	    String sourcelong="";
	    String currlat="";
	    String currlong="";
	    boolean sameSourceDest=false;
	    double travelledDist = 0 ;
	    MapAPIConfigBean mapAPIConfigBean = null;
	    List<LatLng> latLngs  = null;
	    
	    try{
	    		con = DBConnection.getConnectionToDB("AMS");
	    		
	    		mapAPIConfigBean = mapAPIUtil.getConfiguration(systemId);
	    		
	    		pstmt = con.prepareStatement(AutomotiveLogisticsStatements.GET_SEQUENCE_DETAILS);
	        	pstmt.setString(1, tripId);
	        	pstmt.setString(2, tripId);
	        	pstmt.setString(3, tripId);
	        	pstmt.setString(4, tripId);
	           	pstmt.setInt(5, systemId);
	        	pstmt.setInt(6, clientId);
	        	
	        	rs=pstmt.executeQuery();
	        	while(rs.next())
	        	{
	        		if(rs.getInt("SOURCE_HUB") == rs.getInt("DEST_HUB")){
	        			sameSourceDest = true;	
	        		}
	        		
	        		if(rs.getInt("CURRENT_LOC_SEQ")>=rs.getInt("SEQUENCE")){
	        			travelledDist =travelledDist+ rs.getDouble("DISTANCE");
	        			currlat = rs.getString("LATITUDE");
	        			currlong =rs.getString("LONGITUDE");
	        		}
	        		
	        		if(rs.getInt("SEQUENCE")==0){
	        			sourcelat = rs.getString("LATITUDE");
	        			sourcelong =rs.getString("LONGITUDE");
	        		}
	        	}
	        	
	        	if(sameSourceDest && travelledDist>0){
	        		//dISTANCE 
	        		
	        		latLngs = new ArrayList<LatLng>();
	        		latLngs.add(new LatLng(Double.parseDouble(sourcelat), Double.parseDouble(sourcelong)));
	        		latLngs.add(new LatLng(Double.parseDouble(currlat), Double.parseDouble(currlat)));
	        		
	        		JSONObject obj = tdc.calculateTimeAndDistance(latLngs, mapAPIConfigBean);
	        		if (obj.length() >0){
	        			// converting to miles   
	        			travelledDist =  travelledDist + (Double.parseDouble(obj.getString("distanceInKms")) / 1.609344);   
	        		}
	        		
	        		
	        		
//	        		String source = sourcelat+","+sourcelong;
//	        		String destination =currlat+","+currlong;
//	        		URL url = new URL("https://maps.googleapis.com/maps/api/distancematrix/json?origins="+source+"&destinations="+destination);
//	        		HttpURLConnection conn = (HttpURLConnection) url.openConnection();
//	        		conn.setRequestMethod("GET");
//	        		String line, outputString = "";
//	        		BufferedReader reader = new BufferedReader(
//	        		new InputStreamReader(conn.getInputStream()));
//	        		while ((line = reader.readLine()) != null) {
//	        		     outputString += line;
//	        		}
//	        		
//	        		JSONObject json =new JSONObject(outputString);
//	        		JSONArray elements =new JSONArray(json.getString("rows").toString());
//	        		JSONObject distancejson =new JSONObject(elements.getString(0));
//	        		JSONArray distance =new JSONArray(distancejson.getString("elements").toString());
//	        		JSONObject distancmeters = new JSONObject(distance.getString(0));
//	        		JSONObject metersjson = new JSONObject(distancmeters.getString("distance"));
//	        		String meters= metersjson.getString("value");
//	        		System.out.println(meters);
	        		
	        	}
	        		pstmt = con.prepareStatement(AutomotiveLogisticsStatements.END_TRIP);
	        		pstmt.setDouble(1,travelledDist);
		        	pstmt.setString(2, tripId);
		        	pstmt.setString(3, shipmentId);
		        	pstmt.setInt(4, systemId);	
		        	int update = pstmt.executeUpdate();
		        	if(update>0){
		        		message = "Trip Closed Successfully";
		        		if(systemId== 291 && clientId == 5492){
		        		String subject = "Forcibly Trip Close Notification for "+ vehicleNo;
		        		String emailList = "";
		        		emailList="mnja@amazon.com,vikkalsi@amazon.com,muthuraman.r@telematics4u.com,namrata.d@telematics4u.com,narendra.k@telematics4u.com,manjunath.k@telematics4u.com";
		        		
		        		try{
		        			StringBuilder body = new StringBuilder();
		        			body.append("<html><body>" +
		        					//Generic body for email
		        					"<table border = 0 align=center width=100% height=50 bgcolor=#F80000>" +
		        					"<tr><td align=left><font style=font-family:arial size=5 bgcolor=#000000<b>Alert Notification</b></font></td></tr>" +
		        					"</table>" +
		        					"<p><b>Dear Customer,</b></p>" +
		        					"<table>" +
		        					"<tr>" +
		        					"<td><b>Asset Number</td>" +
		        					"<td>:&nbsp; "+ vehicleNo+"</td>" +
		        					"<tr>" +
		        					"<td><b>Trip No</td>" +
		        					"<td>:&nbsp; "+ shipmentId+"</td>" +
		        					"<tr>" +
		        					"<td><b>Trip End Date Time</td>" +
		        					"<td>:&nbsp; "+ sdf.format(new Date()) +"</td>" +
		        					"</tr></table>" +
		        					//To show map link on the body of email, this hyper link will show the location of the vehicle where alert has generated
		        				    "<tr><br><br><br><td align=left><font style=font-style:italic size=2 bgcolor=#4447A6<b>For any queries please write to <a href='support@telematics4u.com'>support@telematics4u.com</a></b></font></td>" +
		        					"<tr><br><td align=left><font style=font-style:italic size=2 bgcolor=#4447A6<b>Please do not reply to this mail. This is an auto generated mail and replies to this email id are not attended too.</b></font></td>" +
		        					//Completed tags
		        			"</body></html>");
		        			 
		        			pstmt = con.prepareStatement(AutomotiveLogisticsStatements.INSERT_TO_EMAIL_QUEUE);
		        			pstmt.setString(1, subject);
		        			pstmt.setString(2, body.toString());
		        			pstmt.setString(3, emailList);
		        			pstmt.setInt(4, 0);
		        			pstmt.setInt(5, systemId);
		        			pstmt.setString(6, vehicleNo);
		        			pstmt.executeUpdate();
		        		}catch (Exception e) {
		        			e.printStackTrace();
		        		 }
		        		}
		        	}
	    }
	  
	    catch (Exception e) {
			e.printStackTrace();
		}
	    finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return message;
	}

	public ArrayList<ArrayList> getHistoricalTripReport(String clientId,
			int systemId, String startDate, String endDate, int offset) {
		 
	    Connection con = null;
	    PreparedStatement pstmt = null; 
	    ResultSet rs = null;
	    PreparedStatement pstmt1 = null; 
	    ResultSet rs1 = null;
	    String shipmentid="";
	    String tripname="";
	    String assetnumber="";
	    String vehicletype="";
	    String groupname="";
	    String gateinatsource="";
	    String gateoutatsource="";
	    String scheduledarriatdest="";
	    String actarrivaldest="";
	    String plannedTripStartTime = "";
	    double stoppagetime=0;
	    int inplanttat=0;
	    String tripstarttime="";
	    String tripendtime="";
	    int scheduledtat=0;
	    int actualtat=0;
	    String deliverystatus = "";
	    int totaldelay = 0;
	    String comments = "";
	    int MAX_POINT = 0;
	    String autoClose="";
	   // int MAX_TOUCHOINT = 0;
	    
	    CommonFunctions cf = new CommonFunctions();
	    ArrayList<ArrayList> datalist = new ArrayList<ArrayList>();
	    
	    try {
	    	con = DBConnection.getConnectionToDB("AMS");
	    	ArrayList<Object> informationList = new ArrayList<Object>();
	    	
	    	String cust[]=null;
	    	boolean custExist=false;
	    	Properties properties = ApplicationListener.prop;
	    				String MllCustomers = properties.getProperty("MllCustomers").trim();
	    		    	  if(MllCustomers !=null && MllCustomers!=""){
	    		    		  cust=MllCustomers.split(",");
	    		    	  }

	    	for(int i=0;i<cust.length;i++){
	    				int custId=Integer.parseInt(cust[i]);
	    				if(Integer.parseInt(clientId)==custId){
	    					custExist=true;
	    					break;
	    				}
	    				}
	   // if((systemId==214 && clientId.equals("5015")) || (systemId==291 && clientId.equals("5492"))){
	    	if(custExist){
		        pstmt = con.prepareStatement(AutomotiveLogisticsStatements.GET_TRIP_DETAILS_MM);
		    	}
	        pstmt.setInt(1, systemId);
	        pstmt.setString(2, clientId);
	        pstmt.setString(3, startDate);
	        pstmt.setString(4, endDate);
	        rs=pstmt.executeQuery();
	        int count=1;
	        int checkpoints=0;
	        int diff=0;
	        int firstrow=0;
	        double planneddistance =0;
	        double actualdistance =0;
	    	while(rs.next())
	    	{
	    		planneddistance=rs.getDouble("PLANNED_DISTANCE");
	    		actualdistance=rs.getDouble("ACT_DIST");
	    		autoClose=rs.getString("AUTO_CLOSE");
	    		/*if(firstrow==0){
	    		MAX_TOUCHOINT=rs.getInt("MAX_TRANSIT_POINT");
	    		}*/
	    		checkpoints=0;
	    		if(MAX_POINT<(rs.getInt("MAX_TRANSIT_POINT"))){
        		MAX_POINT = rs.getInt("MAX_TRANSIT_POINT"); 
        		}
	    	    gateinatsource="";
	    	    gateoutatsource="";
	    	    scheduledarriatdest="";
	    	    actarrivaldest="";
	    	    inplanttat=0;
	    	    tripstarttime="";
	    	    tripendtime="";
	    	    scheduledtat=0;
	    	    actualtat=0;
	    	    deliverystatus = "";
	    	    totaldelay = 0;
	    	    comments = "";
	    	    plannedTripStartTime = "";
	    		informationList = new ArrayList<Object>();
	    		shipmentid=rs.getString("SHIPMENNT_ID");
	    		tripname=rs.getString("TRIP_NAME");
	    		assetnumber=rs.getString("ASSET_NUMBER");
	    		vehicletype=rs.getString("VehicleType");
	    		groupname=rs.getString("GROUP_NAME");
	    		stoppagetime=rs.getDouble("STOPPAGE_TIME");
	    		
	    		informationList.add(count++);
	    		informationList.add(shipmentid);
	    		informationList.add(tripname);
	    		informationList.add(assetnumber);
	    		informationList.add(vehicletype);
	    		informationList.add(groupname);
	    		 pstmt1 = con.prepareStatement(AutomotiveLogisticsStatements.GET_CHECKPOINT_DETAILS);
	    		 pstmt1.setInt(1, offset);
	    		 pstmt1.setInt(2, offset);
	    		 pstmt1.setInt(3, offset);
	    		 pstmt1.setInt(4, offset);
	    		 pstmt1.setInt(5, offset);
			        pstmt1.setInt(6, systemId);
			        pstmt1.setString(7, clientId);
			        pstmt1.setInt(8, rs.getInt("TRIP_ID"));
			        rs1=pstmt1.executeQuery();
			        while(rs1.next())
			    	{ 
			        	if(rs.getDouble("ACT_DIST")==0){
			        		actualdistance=actualdistance+rs1.getDouble("DISTANCE");
			        	}
			        	if (rs1.getInt("SEQUENCE")!=0 && rs1.getInt("SEQUENCE")!=100) {
			        		checkpoints++;
				        	diff=(rs1.getInt("diffhh"))/60;
				        	informationList.add(rs1.getString("NAME"));
				        	if(rs1.getString("ETA").equals("")|| rs1.getString("ETA").contains("1900"))
							{
				        		informationList.add("");
							}
							else
							{	
								   informationList.add(ddmmyyyy.format(rs1.getTimestamp("ETA")));
							}
				        	if(rs1.getString("actualtime").equals("")|| rs1.getString("actualtime").contains("1900"))
							{
				        		informationList.add("");
							}
							else
							{	
								   informationList.add(ddmmyyyy.format(rs1.getTimestamp("actualtime")));
							}
				        	if ((diff >= 1) && (rs1.getString("STATUS").equalsIgnoreCase("DELAYED"))) {
				        		informationList.add(diff+" Hours and More");
							}else {
								informationList.add("");
							}
				        	
				        	/*if(rs1.getString("planneDepTime").equals("")|| rs1.getString("planneDepTime").contains("1900"))
							{
				        		informationList.add("");
							}
							else
							{	
								   informationList.add(ddmmyyyy.format(rs1.getTimestamp("planneDepTime")));
							}*/
				        	if(rs1.getString("actualtimedep").equals("")|| rs1.getString("actualtimedep").contains("1900"))
							{
				        		informationList.add("");
							}
							else
							{	
								   informationList.add(ddmmyyyy.format(rs1.getTimestamp("actualtimedep")));
							}
				        	
				        	
				        	informationList.add(rs1.getString("issues"));
				        	informationList.add(rs1.getString("remarks"));
				        	informationList.add(rs1.getString("actionstatus"));
						}
			        	 
			        	if (rs1.getInt("SEQUENCE")==0) {
			        		/*if(MAX_POINT<rs1.getInt("MAX_TRANSIT_POINT")){
				        		MAX_POINT = rs1.getInt("MAX_TRANSIT_POINT"); 
				        		}*/
			        		
			        		diff=(rs1.getInt("diffhh"))/60;
				        	informationList.add(rs1.getString("NAME"));
				        	if(rs1.getString("planneDepTime").equals("")|| rs1.getString("planneDepTime").contains("1900"))
							{
				        		informationList.add("");
							}
							else
							{	
								   informationList.add(ddmmyyyy.format(rs1.getTimestamp("planneDepTime")));
							}
				        	
				        	if(rs1.getString("actualtime").equals("")|| rs1.getString("actualtime").contains("1900"))
							{
				        		informationList.add("");
							}
							else
							{	
								   informationList.add(ddmmyyyy.format(rs1.getTimestamp("actualtime")));
							}
				        	if ((diff >= 1) && (rs1.getString("STATUS").equalsIgnoreCase("DELAYED"))) {
				        		informationList.add(diff+" Hours and More");
							}else {
								informationList.add("");
							}
				        	
				        	if(rs1.getString("ETA").equals("")|| rs1.getString("ETA").contains("1900"))
							{
				        		informationList.add("");
							}
							else
							{	
								   informationList.add(ddmmyyyy.format(rs1.getTimestamp("ETA")));
							}
				        	
				        	if(rs1.getString("actualtimedep").equals("")|| rs1.getString("actualtimedep").contains("1900"))
							{
				        		informationList.add("");
							}
							else
							{	
								   informationList.add(ddmmyyyy.format(rs1.getTimestamp("actualtimedep")));
							}
				        	
				        	informationList.add(rs1.getString("issues"));
				        	informationList.add(rs1.getString("remarks"));
				        	informationList.add(rs1.getString("actionstatus"));
				        	informationList.add(rs.getInt("MAX_TRANSIT_POINT"));
			        		
			        		
			        		plannedTripStartTime =ddmmyyyy.format(rs1.getTimestamp("ETA"));
			        		if(rs1.getString("actualtime").equals("") || rs1.getString("actualtime").contains("1900"))
							{
			        			gateinatsource="";
							}
							else
							{	
								gateinatsource=ddmmyyyy.format(rs1.getTimestamp("actualtime"));
							}
			        		if(rs1.getString("actualtimedep").equals("") || rs1.getString("actualtimedep").contains("1900"))
							{
			        			if(rs1.getString("ETA").equals("") || rs1.getString("ETA").contains("1900"))
								{
				        			gateoutatsource=ddmmyyyy.format(rs.getTimestamp("TRIP_START_TIME"));
					        	    tripstarttime=ddmmyyyy.format(rs.getTimestamp("TRIP_START_TIME"));
								}else{
									gateoutatsource=ddmmyyyy.format(rs1.getTimestamp("ETA"));
					        	    tripstarttime=ddmmyyyy.format(rs1.getTimestamp("ETA"));
								}
							}
							else
							{	
								gateoutatsource=ddmmyyyy.format(rs1.getTimestamp("actualtimedep"));
				        	    tripstarttime=ddmmyyyy.format(rs1.getTimestamp("actualtimedep"));
							}
						}
			        	if (rs1.getInt("SEQUENCE")==100) {
			        		
			        		//if(MAX_POINT<20){
						        for(int i=0;i<MAX_POINT-checkpoints;i++)
						        {
						        	informationList.add("");
						        	informationList.add("");
						        	informationList.add("");
						        	informationList.add("");
						        	//informationList.add("");
						        	informationList.add("");
						        	informationList.add("");
						        	informationList.add("");
						        	informationList.add("");
						        }
					        
					       // }
			        		
			        		diff=(rs1.getInt("diffhh"))/60;
				        	informationList.add(rs1.getString("NAME"));
				        	if(rs1.getString("ETA").equals("")|| rs1.getString("ETA").contains("1900"))
							{
				        		informationList.add("");
							}
							else
							{	
								   informationList.add(ddmmyyyy.format(rs1.getTimestamp("ETA")));
							}
				        	if(rs1.getString("actualtime").equals("")|| rs1.getString("actualtime").contains("1900"))
							{
				        		informationList.add("");
							}
							else
							{	
								   informationList.add(ddmmyyyy.format(rs1.getTimestamp("actualtime")));
							}
				        	
				        	if ((diff >= 1) && (rs1.getString("STATUS").equalsIgnoreCase("DELAYED"))) {
				        		informationList.add(diff+" Hours and More");
							}else {
								informationList.add("");
							}
				        	/*if(rs1.getString("planneDepTime").equals("")|| rs1.getString("planneDepTime").contains("1900"))
							{
				        		informationList.add("");
							}
							else
							{	
								   informationList.add(ddmmyyyy.format(rs1.getTimestamp("planneDepTime")));
							}*/
				        	if(rs1.getString("actualtimedep").equals("")|| rs1.getString("actualtimedep").contains("1900"))
							{
				        		informationList.add("");
							}
							else
							{	
								   informationList.add(ddmmyyyy.format(rs1.getTimestamp("actualtimedep")));
							}
				        	
				        	informationList.add(rs1.getString("issues"));
				        	informationList.add(rs1.getString("remarks"));
				        	informationList.add(rs1.getString("actionstatus"));
			        		
			        		scheduledarriatdest=ddmmyyyy.format(rs1.getTimestamp("ETA"));
			        		if(rs1.getString("actualtime").equals("")|| rs1.getString("actualtime").contains("1900"))
							{
			        			actarrivaldest="";
				        	    tripendtime="";
							}
							else
							{	
								 actarrivaldest=ddmmyyyy.format(rs1.getTimestamp("actualtime"));
					        	    tripendtime=ddmmyyyy.format(rs1.getTimestamp("actualtime"));
							}
						}
			    	}
			       
			        
			        if(tripstarttime!="" && !tripstarttime.contains("1900") && scheduledarriatdest!="" && !scheduledarriatdest.contains("1900"))
					{
			        	scheduledtat = cf.getTimeDiffrence(ddmmyyyy.parse(plannedTripStartTime), ddmmyyyy.parse(scheduledarriatdest));
					}
			        if(tripstarttime!="" && !tripstarttime.contains("1900") && tripendtime!="" && !tripendtime.contains("1900"))
					{
			        	actualtat = cf.getTimeDiffrence(ddmmyyyy.parse(tripstarttime), ddmmyyyy.parse(tripendtime));
			        	totaldelay = scheduledtat - actualtat;
				        if (totaldelay<0) {
				        	totaldelay = actualtat - scheduledtat;
							deliverystatus = "DELAYED";
						}else if (totaldelay>1) {
							totaldelay = 0;
							deliverystatus = "BEFORE TIME";
						}else{
							totaldelay = 0;
							deliverystatus = "ON TIME";
						}
					}
			        
			        if(gateinatsource!="" && !gateinatsource.contains("1900") && gateinatsource!="" && !gateinatsource.contains("1900"))
					{
			        	inplanttat= cf.getTimeDiffrence(ddmmyyyy.parse(gateinatsource), ddmmyyyy.parse(gateoutatsource));
					}
			        	   /* informationList.add(gateinatsource);
				        	informationList.add(gateoutatsource);
				        	informationList.add(scheduledarriatdest);
				        	informationList.add(actarrivaldest);
				        	informationList.add(cf.convertMinutesToHHMMFormat1(inplanttat));*/
				        	informationList.add(stoppagetime);
				        	informationList.add(tripstarttime);
				        	informationList.add(tripendtime);
				        	informationList.add(cf.convertMinutesToHHMMFormat1(scheduledtat));
				        	informationList.add(cf.convertMinutesToHHMMFormat1(actualtat));
				        	informationList.add(deliverystatus);
				        	informationList.add(cf.convertMinutesToHHMMFormat1(totaldelay));
				        	informationList.add(comments);
				        	informationList.add(planneddistance);
				        	informationList.add(actualdistance);
				        	informationList.add(autoClose);
				        	//informationList.add(MAX_POINT);
			        		datalist.add(informationList);
			        		checkpoints=0;
			        		firstrow++;
			}
	    	
	    	informationList = new ArrayList<Object>();
	    	informationList.add(MAX_POINT);
	    	datalist.add(informationList);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt1, rs1);
			DBConnection.releaseConnectionToDB(null, pstmt, rs);
		}
		return datalist;
	
	}

}
