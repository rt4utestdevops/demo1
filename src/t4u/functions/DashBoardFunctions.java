package t4u.functions;


import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Calendar;
import java.util.Collections;
import java.util.Comparator;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import t4u.GeneralVertical.DriverDetentionTimeComparator;
import t4u.beans.DriverDetentionTime;
import t4u.common.DBConnection;
import t4u.statements.DashBoardStatements;
import t4u.util.SMSUtil;

import com.google.gson.internal.LinkedTreeMap;
import com.t4u.activity.VehicleActivity;
import com.t4u.activity.VehicleSummaryBean;
import com.t4u.activity.VehicleActivity.DataListBean;
import com.vividsolutions.jts.geom.Coordinate;
import com.vividsolutions.jts.geom.GeometryFactory;
import com.vividsolutions.jts.geom.LinearRing;
import com.vividsolutions.jts.geom.Point;
import com.vividsolutions.jts.geom.Polygon;
/**
 * @author Nikhil
 *
 */
public class DashBoardFunctions {
	CommonFunctions cuf=new CommonFunctions();
	SimpleDateFormat ddmmyyyy = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
	SimpleDateFormat yyyymmdd = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	SimpleDateFormat ddmmyyyyhhmmss = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
	String DEGREE  = " \u00b0";
	public JSONArray getDistressAlert(String customerid, int systemId,String previousDistressCount,String prevClientID,int userid,int offset) {
		JSONArray distressJSONArray= new JSONArray();
		JSONObject distressJSONObject = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String distressflag="false";
		int distressCount=-1;
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(DashBoardStatements.GET_DISTRESS_ALERT);
			pstmt.setInt(1, offset);
			pstmt.setInt(2, Integer.parseInt(customerid));
			pstmt.setInt(3, systemId);
			pstmt.setInt(4, userid);
			rs = pstmt.executeQuery();
			if (rs.next()) {		
				distressCount=rs.getInt("COUNT");				
			}
			if(distressCount>Integer.parseInt(previousDistressCount)&&Integer.parseInt(customerid)==Integer.parseInt(prevClientID))
			{
				distressflag="true";
			}
			distressJSONObject.put("distresscount",Integer.toString(distressCount));	
			distressJSONObject.put("distressflag", distressflag);	
			distressJSONArray.put(distressJSONObject);
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}

		return distressJSONArray;
	}

	public int getOverSpeedAlert(String customerid, int systemId) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int distressCount=0;
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(DashBoardStatements.GET_OVERSPEED_ALERT);
			pstmt.setInt(1, Integer.parseInt(customerid));
			pstmt.setInt(2, systemId);
			rs = pstmt.executeQuery();
			if (rs.next()) {			
				distressCount=rs.getInt("OVERSPEED_COUNT");
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}

		return distressCount;
	}
	
	public int getVehicleIdleeAlert(String customerid, int systemId) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int vehicleIdle=0;
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(DashBoardStatements.GET_VEHICLE_IDLE);
			pstmt.setInt(1, Integer.parseInt(customerid));
			pstmt.setInt(2, systemId);
			rs = pstmt.executeQuery();
			if (rs.next()) {			
				vehicleIdle=rs.getInt("VEHICLE_IDLE_COUNT");
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}

		return vehicleIdle;
	}
	public int getTotalVehicles(String customerid, int systemId, int userid,int isLtsp) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int totalVehiclecount=0;
		try {
			con = DBConnection.getConnectionToDB("AMS");
			if(customerid.equals("0") || isLtsp == 0){
				pstmt = con.prepareStatement(DashBoardStatements.GET_TOTAL_NO_VEHICLES_FOR_LTSP);
			}
			else{
				pstmt = con.prepareStatement(DashBoardStatements.GET_TOTAL_NO_VEHICLES_FOR_CLIENT);	
			}
			pstmt.setInt(1, Integer.parseInt(customerid));
			pstmt.setInt(2, systemId);
			pstmt.setInt(3,userid);
			rs = pstmt.executeQuery();
			if (rs.next()) {			
				totalVehiclecount=rs.getInt("VEHICLE_COUNT");
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}

		return totalVehiclecount;
	}
	
	public int getNonCommunicatinVehicles(String customerid, int systemId, int userid,int isLtsp) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int nonCommunicatingCount=0;
		try {
			con = DBConnection.getConnectionToDB("AMS");
			if(customerid.equals("0") || isLtsp == 0){
				pstmt = con.prepareStatement(DashBoardStatements.GET_NON_COMMUNICATING_FOR_LTSP);
			
			}else{
				pstmt = con.prepareStatement(DashBoardStatements.GET_NON_COMMUNICATING_FOR_CLIENT);
					
			}
			pstmt.setInt(1, Integer.parseInt(customerid));
			pstmt.setInt(2, systemId);
			pstmt.setInt(3, userid);
			rs = pstmt.executeQuery();
			if (rs.next()) {			
				nonCommunicatingCount=rs.getInt("NON_COMMUNICATING");
				
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}

		return nonCommunicatingCount;
	}
	public int getFirstLadyPickup(String customerid, int systemId) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int firstLadypickupcount=0;
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(DashBoardStatements.FIRST_LADY_PICKUP);
			pstmt.setInt(1, Integer.parseInt(customerid));
			pstmt.setInt(2, systemId);
			rs = pstmt.executeQuery();
			if (rs.next()) {			
				firstLadypickupcount=rs.getInt("LADY_PICKUP");
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}

		return firstLadypickupcount;
	}
	
	public int getHIDnotSwiped(String customerid, int systemId) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int HIDcount=0;
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(DashBoardStatements.HID_NOT_SWIPED);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, Integer.parseInt(customerid));
			pstmt.setInt(3, systemId);
			pstmt.setInt(4, Integer.parseInt(customerid));
			rs = pstmt.executeQuery();
			while (rs.next()) {			
				HIDcount=rs.getInt("HID_COUNTS");
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}

		return HIDcount;
	}
	
	public JSONArray getTripDetails(String customerid, int systemId) {

		JSONArray TripJSONArray = new JSONArray();
		JSONObject TripJSONObject = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;
		PreparedStatement pstmt1 = null;
		ResultSet rs = null;
		ResultSet rs1 = null;
		try {
			String shifttime="";
			String vehiclesontrip="";
			String vehiclesontripcomm="";
			String vehiclesarrived="";
			String swipetime="";
			String shiftstatus="";
			String currentstatus="";
			String employeesontrip="";
			String employeesonswipe="";
			TripJSONArray = new JSONArray();
			TripJSONObject = new JSONObject();
			int firsttime=0;
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(DashBoardStatements.GET_TRIP_DETAILS);
			pstmt.setInt(1, Integer.parseInt(customerid));
			pstmt.setInt(2, systemId);
			pstmt.setInt(3, Integer.parseInt(customerid));
			pstmt.setInt(4, systemId);
			rs = pstmt.executeQuery();
			while (rs.next()) {			
				TripJSONObject = new JSONObject();
				shifttime = rs.getString("SHIFT_TIME");
				vehiclesontrip = rs.getString("VEHICLES_ON_TRIP");
				vehiclesontripcomm = rs.getString("COMMUNICATING");
				vehiclesarrived=rs.getString("Closed");
				swipetime=rs.getString("TIMES");
				shiftstatus=rs.getString("SHIFT_STATUS").trim();
				currentstatus="N";
				if(shiftstatus.equals("Y")&&firsttime==0)
				{
					currentstatus="Y";
					firsttime=1;
				}
				pstmt1 = con.prepareStatement(DashBoardStatements.EMPLOYEES_ON_TRIP);
				pstmt1.setString(1, swipetime);
				pstmt1.setInt(2, Integer.parseInt(customerid));
				pstmt1.setInt(3, systemId);
				pstmt1.setString(4, swipetime);
				pstmt1.setInt(5, Integer.parseInt(customerid));
				pstmt1.setInt(6, systemId);
				rs1 = pstmt1.executeQuery();
				if(rs1.next())
				{
				employeesontrip = rs1.getString("EMPLOYEE_ON_TRIP");	
				}
				pstmt1=null;
				rs1=null;
				pstmt1 = con.prepareStatement(DashBoardStatements.EMPLOYEES_SWIPED);
				pstmt1.setString(1, swipetime);
				pstmt1.setInt(2, Integer.parseInt(customerid));
				pstmt1.setInt(3, systemId);
				pstmt1.setString(4, swipetime);
				pstmt1.setInt(5, Integer.parseInt(customerid));
				pstmt1.setInt(6, systemId);
				rs1 = pstmt1.executeQuery();
				if(rs1.next())
				{
				employeesonswipe=rs1.getString("EMPLOYEES_SWIPED");
				}
				pstmt1=null;
				rs1=null;
				TripJSONObject.put("shifttime", shifttime);
				TripJSONObject.put("vehiclesontrip", vehiclesontrip);
				TripJSONObject.put("vehiclesontripcomm", vehiclesontripcomm);
				TripJSONObject.put("vehiclesarrived", vehiclesarrived);
				TripJSONObject.put("employeesontrip", employeesontrip);
				TripJSONObject.put("employeesonswipe", employeesonswipe);	
				TripJSONObject.put("shiftstatus", currentstatus);	
				TripJSONArray.put(TripJSONObject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
			DBConnection.releaseConnectionToDB(null, pstmt1, rs1);
		}

		return TripJSONArray;
	
	}

	public JSONArray getMapVehicleDetails(String customerid,String facility,int systemId,String shifttime) {


		JSONArray MapVehicleArray = new JSONArray();
		JSONObject MapVehicleObject = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Map<String,String> vehicleList=null;
		int employeesOnTrip=0;
		String shift="";
		try {
			MapVehicleArray = new JSONArray();
			vehicleList=new HashMap<String,String> ();
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(DashBoardStatements.GET_NEXT_TRIP_VEHICLES);
			pstmt.setString(1, facility);
			pstmt.setInt(2, systemId);
			pstmt.setString(3, shifttime);
			rs = pstmt.executeQuery();
			while (rs.next()) {			
				vehicleList.put(rs.getString("VehicleNo"),rs.getString("ACCTripId"));
				shift=rs.getString("Shift");
			}
			pstmt=null;
			rs=null;
			Iterator<Entry<String, String>> i = vehicleList.entrySet().iterator();
			while(i.hasNext()) {
			Map.Entry<String,String> vehicleMap = (Map.Entry<String,String>)i.next();
			
				pstmt = con.prepareStatement(DashBoardStatements.EMPLOYESS_ON_TRIP_FOR_MAP);
				pstmt.setString(1, (String) vehicleMap.getKey());
				pstmt.setString(2,shift);
				pstmt.setString(3, customerid);
				pstmt.setInt(4, systemId);
				rs = pstmt.executeQuery();
				if (rs.next()) {
					employeesOnTrip=rs.getInt("EMPLOYEE_ON_TRIP");	
				}
				pstmt=null;
				rs=null;
				
				pstmt = con.prepareStatement(DashBoardStatements.GET_TRIP_VEHICLE_DETAILS);
				pstmt.setString(1, customerid);
				pstmt.setInt(2, systemId);
				pstmt.setString(3, vehicleMap.getKey());
				rs = pstmt.executeQuery();
				if (rs.next()) {	
					MapVehicleObject = new JSONObject();
					MapVehicleObject.put("lattitude", rs.getString("LATITUDE"));
					MapVehicleObject.put("longittude", rs.getString("LONGITUDE"));	
					MapVehicleObject.put("regNo", vehicleMap.getKey());	
					MapVehicleObject.put("tripId", vehicleMap.getValue());	
					MapVehicleObject.put("employeesOnTrip", employeesOnTrip);
					MapVehicleObject.put("vehicleId",rs.getString("VehicleAlias"));
					MapVehicleArray.put(MapVehicleObject);
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}

		return MapVehicleArray;
	
	
	}

	public JSONArray getcustomerLatLong(String facility, int systemId) {
		JSONArray MapCustomerArray = new JSONArray();
		JSONObject MapCustomerObject = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			MapCustomerArray = new JSONArray();
				con = DBConnection.getConnectionToDB("AMS");
				pstmt = con.prepareStatement(DashBoardStatements.GET_CUSTOMER_LAT_LONG);
				pstmt.setString(1, facility);
				pstmt.setInt(2, systemId);
				rs = pstmt.executeQuery();
				if (rs.next()) {	
					MapCustomerObject = new JSONObject();
					MapCustomerObject.put("lattitude", rs.getString("Latitude"));
					MapCustomerObject.put("longittude", rs.getString("Longitude"));	
					MapCustomerObject.put("facility", rs.getString("Facility"));	
					MapCustomerArray.put(MapCustomerObject);
				}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}

		return MapCustomerArray;
	
	
	
	}
	
	public JSONArray getShifts(String facility, int systemId) {
		JSONArray ShiftArray = new JSONArray();
		JSONObject ShiftObject = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			ShiftArray = new JSONArray();
				con = DBConnection.getConnectionToDB("AMS");
				pstmt = con.prepareStatement(DashBoardStatements.GET_FACILITY_SHIFT);
				pstmt.setString(1, facility);
				pstmt.setInt(2, systemId);
				rs = pstmt.executeQuery();
				while (rs.next()) {	
					ShiftObject = new JSONObject();
					ShiftObject.put("shift", rs.getString("Shift"));
					ShiftArray.put(ShiftObject);
				}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}

		return ShiftArray;
		
	}
	
	public JSONArray getMapVehicleDetails(String routeName) {
		JSONArray MapVehicleArray = new JSONArray();
		JSONObject MapVehicleObject = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;
		PreparedStatement pstmttop = null;
		ResultSet rs = null;
		ResultSet rs1 = null;
		String locname="";
		String location="";
		try {
			con = DBConnection.getConnectionToDB("AMS");
			   pstmttop = con.prepareStatement(DashBoardStatements.GET_ROUTE_DETAILS);
			   pstmttop.setString(1, routeName);
			   rs1 = pstmttop.executeQuery();
			   if(rs1.next()){
				MapVehicleArray = new JSONArray();
				pstmt = con.prepareStatement(DashBoardStatements.GET_LIVE_VEHICLE_DETAILS);
				pstmt.setString(1, routeName);
				rs = pstmt.executeQuery();
				if(rs.next()) {
					location=rs.getString("LOCATION");
				    
					if(location.length()> 0 && location.contains(",") && location.split(",").length > 2){
						location = location.substring(0, location.lastIndexOf(","));
						if(location.contains(",") && location.split(",").length > 2){
						location = location.substring(0, location.lastIndexOf(","));
						if(location.contains(",") && location.split(",").length > 2){
						location = location.substring(0, location.lastIndexOf(","));
						}
					}
				}
					locname=location;
					MapVehicleObject = new JSONObject();
					MapVehicleObject.put("regno", rs.getString("REGISTRATION_NO"));
					MapVehicleObject.put("lattitude", rs.getString("LATITUDE"));
					MapVehicleObject.put("longittude", rs.getString("LONGITUDE"));	
					MapVehicleObject.put("location",locname);
					MapVehicleObject.put("gmt", ddmmyyyy.format(yyyymmdd.parse(rs.getString("GPS_DATETIME"))));
					MapVehicleObject.put("facLatitude1",rs.getString("FacilityLat"));
					MapVehicleObject.put("facLongitude1",rs.getString("FacilityLong"));
					MapVehicleObject.put("facility",rs.getString("Facility"));
					MapVehicleObject.put("type",rs.getString("TYPE"));
					MapVehicleObject.put("TripStartDate",rs.getString("TripStartDate"));
					MapVehicleObject.put("clientId",rs.getString("ClientId"));
					MapVehicleArray.put(MapVehicleObject);
				}
			   }
			   else{
				   MapVehicleObject = new JSONObject();
				   String message="Route is not Available";
				   MapVehicleObject.put("msg", message);
				   MapVehicleArray.put(MapVehicleObject);
			   }
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
			DBConnection.releaseConnectionToDB(null, pstmttop, rs1);
		}

		return MapVehicleArray;
	}
	
	public JSONArray getRouteDetails(String routeName,String vehicleNo,int systemId,int offset) {
		JSONArray array = new JSONArray();
		JSONObject obj = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			array = new JSONArray();
				con = DBConnection.getConnectionToDB("AMS");
				pstmt = con.prepareStatement(DashBoardStatements.GET_TRANSIT_POINTS_FOR_ROUTE_DETAILS);
				pstmt.setInt(1, offset);
				pstmt.setString(2, vehicleNo);
				pstmt.setInt(3, 2);
				pstmt.setString(4, "Open");
				rs = pstmt.executeQuery();
				while (rs.next()) {
					obj = new JSONObject();
					obj.put("longitude", rs.getString("Longitude"));	
					obj.put("latitude", rs.getString("Latitude"));	
					obj.put("location", rs.getString("EmployeeName"));
					if(rs.getString("ArrivalDateTime")==null){
						obj.put("arrTime",rs.getString("ArrivalDateTime"));
					}else{
					obj.put("arrTime", ddmmyyyy.format(yyyymmdd.parse(rs.getString("ArrivalDateTime"))));
					}
					obj.put("count", rs.getString("NO_OF_NOTNULL_VALUES"));
					obj.put("empName", rs.getString("EmployeeName"));
					obj.put("sequence", rs.getString("EID"));
					obj.put("LAST_VISITED", rs.getString("LAST_VISITED"));
					array.put(obj);
				}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}

		return array;
	}
	public JSONArray getLatlongs(String routeName,String vehicleNo,String StartDate,int offset,int custID,String lon,String lat) {
		JSONArray array = new JSONArray();
		JSONObject obj = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		SimpleDateFormat simpleDateFormatddMMYYYYDB = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

		try {
			array = new JSONArray();
			obj = new JSONObject();
				con = DBConnection.getConnectionToDB("AMS");
				if (StartDate!=null && !StartDate.equals("") && !StartDate.contains("1900-01")) {
					Date curGMT=new Date();
					String sCurGMT=curGMT.toGMTString();
					SimpleDateFormat sdfmt=new SimpleDateFormat("dd MMM yyyy HH:mm:ss ");
					curGMT=sdfmt.parse(sCurGMT);
					VehicleActivity vi=new VehicleActivity(con, vehicleNo, simpleDateFormatddMMYYYYDB.parse(StartDate), curGMT,offset, 105, custID,5);
					VehicleSummaryBean vsb = vi.getVehicleSummaryBean();
					LinkedList<DataListBean> activityReportList = vi.getFinalList();
					for (int i = 0; i < activityReportList.size(); i++) {
						DataListBean dlb = activityReportList.get(i);
						obj = new JSONObject();
						obj.put("longitudee", dlb.getLongitude());	
						obj.put("latitudee", dlb.getLatitude());	
						array.put(obj);
					}
				}
				obj.put("longitudee", lon);	
				obj.put("latitudee", lat);	
				array.put(obj);
				
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}

		return array;
	}

	public JSONArray getDashBoardCounts(int clientId, int systemId, int userId) {
		JSONArray jsonArray = new JSONArray();
		JSONObject obj = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
	
		int inTransit=0;
		int ontimeCount=0;
		int delayLess=0;
		int stoppageDelayLess=0;
		int deviationDelayless=0;
		int delayGreater=0;
		int stoppagedelayGreater=0;
		int deviationDelayGreater=0;
		int loadingUnloading=0;
		int loadUnloadOnTime=0;
		int loadUnloadLess=0;
		int loadUnloadGreater=0;
		int speedAlertCount=0;
		int delayedLateDeparture=0;
		int enrouteOnTime = 0;
		int enrouteDelayed = 0;
		int unUtilizedVeh = 0;
		
		try {
				con = DBConnection.getConnectionToDB("AMS");
				String stage = DashBoardStatements.GET_DASHBOARD_STAGE;
				pstmt = con.prepareStatement(stage);
				pstmt.setInt(1, systemId);
				pstmt.setInt(2, clientId);
				rs = pstmt.executeQuery();
				while (rs.next()) {
					if(rs.getInt("STATUS_ID")==2 ){
						ontimeCount=rs.getInt("COUNT");
					}if(rs.getInt("STATUS_ID")==3 ){
						delayLess=rs.getInt("COUNT");
					}if(rs.getInt("STATUS_ID")==4 ){
						delayGreater=rs.getInt("COUNT");
					}if(rs.getInt("STATUS_ID")==7 ){
					   stoppageDelayLess = rs.getInt("COUNT");
					}if(rs.getInt("STATUS_ID")==8 ){
						deviationDelayless=rs.getInt("COUNT");
					}if(rs.getInt("STATUS_ID")==9 ){
						stoppagedelayGreater= rs.getInt("COUNT");
					}if(rs.getInt("STATUS_ID")==10 ){
						deviationDelayGreater= rs.getInt("COUNT");
					}if(rs.getInt("STATUS_ID")==11 ){
						loadUnloadOnTime= rs.getInt("COUNT");
					}if(rs.getInt("STATUS_ID")==12 ){
						loadUnloadLess= rs.getInt("COUNT");
					}if(rs.getInt("STATUS_ID")==13 ){
						loadUnloadGreater= rs.getInt("COUNT");
					}if(rs.getInt("STATUS_ID")==30 ){
						delayedLateDeparture= rs.getInt("COUNT");
					}if(rs.getInt("STATUS_ID")==0 ){
						enrouteOnTime= rs.getInt("COUNT");
					}if(rs.getInt("STATUS_ID")==1 ){
						enrouteDelayed= rs.getInt("COUNT");
					}
				}
				obj = new JSONObject();
				obj.put("inTransit",(ontimeCount+delayLess+delayGreater+delayedLateDeparture));
				obj.put("ontimeCount", ontimeCount);
				obj.put("delayLess", delayLess);
				obj.put("stoppageDelayLess", stoppageDelayLess);
				obj.put("deviationDelayless", deviationDelayless);
				obj.put("delayGreater", delayGreater);
				obj.put("stoppagedelayGreater", stoppagedelayGreater);
				obj.put("deviationDelayGreater",deviationDelayGreater);
				obj.put("loadingUnloading", (loadUnloadOnTime+loadUnloadLess+loadUnloadGreater));
				obj.put("loadUnloadOnTime", loadUnloadOnTime);
				obj.put("loadUnloadLess", loadUnloadLess);
				obj.put("loadUnloadGreater", loadUnloadGreater);
				obj.put("speedAlertCount", speedAlertCount);
				obj.put("delayedLateDeparture", delayedLateDeparture);
				obj.put("enroute", (enrouteOnTime+enrouteDelayed));
				
				pstmt = con.prepareStatement(DashBoardStatements.GET_UN_UTILIZED_VEHICLE);
				pstmt.setInt(1, systemId);
				pstmt.setInt(2, clientId);
				pstmt.setInt(3, systemId);
				pstmt.setInt(4, clientId);
				
				rs = pstmt.executeQuery();
				if(rs.next()){
					unUtilizedVeh= rs.getInt("COUNT");
					obj.put("unUtilizedVeh", rs.getString("COUNT"));
				}
				obj.put("unUtilizedVehTotal", (unUtilizedVeh+enrouteOnTime+enrouteDelayed));
				pstmt = con.prepareStatement(DashBoardStatements.GET_NON_REPORTING_VEHICLE);
				pstmt.setInt(1, systemId);
				pstmt.setInt(2, clientId);
				pstmt.setInt(3, systemId);
				pstmt.setInt(4, clientId);
				
				rs = pstmt.executeQuery();
				if(rs.next()){
					obj.put("nonReporting", rs.getString("COUNT"));
				}
				
				//Get vehicle saftey queries
				pstmt = con.prepareStatement(DashBoardStatements.GET_VEHICLE_SAFTEY_COUNTS);
				pstmt.setInt(1, systemId);
				pstmt.setInt(2, clientId);
				pstmt.setInt(3, systemId);
				pstmt.setInt(4, clientId);
				pstmt.setInt(5, systemId);
				pstmt.setInt(6, clientId);
				pstmt.setInt(7, systemId);
				pstmt.setInt(8, clientId);
				pstmt.setInt(9, systemId);
				pstmt.setInt(10, clientId);
				pstmt.setInt(11, systemId);
				pstmt.setInt(12, clientId);
				pstmt.setInt(13, systemId);
				pstmt.setInt(14, clientId);
				pstmt.setInt(15, systemId);
				pstmt.setInt(16, clientId);
				
				rs = pstmt.executeQuery();
				while(rs.next()){
					if("LOW_FUEL".equals(rs.getString("ALERT_TYPE"))){
						obj.put("lowFuelCount",rs.getInt("COUNT"));
					}
					if("LOW_BAT".equals(rs.getString("ALERT_TYPE"))){
						obj.put("lowBatteryCount",rs.getInt("COUNT"));
					}
					if("OVER_SPEED".equals(rs.getString("ALERT_TYPE"))){
						obj.put("overSpeedCount",rs.getInt("COUNT"));
					}
					if("COOLANT_TEMP".equals(rs.getString("ALERT_TYPE"))){
						obj.put("coolantTempCount",rs.getInt("COUNT"));
					}
				}
				jsonArray.put(obj);
			} 
			 catch (Exception e) {
				e.printStackTrace();
			}finally {
				DBConnection.releaseConnectionToDB(con, pstmt, rs);
			}
		return jsonArray;
	}
	
	public JSONArray getAlertDetailsForDashboard(int clientId, int systemId,ArrayList<String> statusID) {
		Connection con = null;
		PreparedStatement pstmt1 = null;
		ResultSet rs1 = null;
		JSONArray alertDetailsArray=new JSONArray();
		JSONObject alertDetailsObj;
		String id = "";
		String condition = "";
		try {
			con = DBConnection.getConnectionToDB("AMS");
			if(statusID.isEmpty()){
				id = "";
			}else{
				id = convertListToSqlINParam(statusID);
			}
			if( id.isEmpty()){
				condition="";
			}else{
				condition = "and ds.STATUS_ID in ("+id+")";
			}
			pstmt1 = con.prepareStatement(DashBoardStatements.GET_ALERT_DETAILS_FOR_DASHBOARD.replace("#", condition));
			pstmt1.setInt(1, systemId);
			pstmt1.setInt(2, clientId);
			//pstmt1.setString(3, id);
			rs1 = pstmt1.executeQuery();
			alertDetailsArray = new JSONArray();
			while (rs1.next()) {
				alertDetailsObj = new JSONObject();
				alertDetailsObj.put("tripId",rs1.getString("TRIP_ID"));
				alertDetailsObj.put("shipmentId",rs1.getString("SHIPMENT_ID"));
				alertDetailsObj.put("routeDesc",rs1.getString("ROUTE_NAME"));
				alertDetailsObj.put("alertDesc",rs1.getString("ALERT_DESC"));
				alertDetailsObj.put("alertType",rs1.getString("ALERT_TYPE"));
				alertDetailsObj.put("vehicleNo",rs1.getString("ASSET_NUMBER"));
				alertDetailsObj.put("driverName",rs1.getString("DRIVER_NAME"));
				alertDetailsObj.put("driverContact",rs1.getString("DRIVER_NUMBER"));
				alertDetailsObj.put("latitude",rs1.getString("LATITUDE"));
				alertDetailsObj.put("longitude",rs1.getString("LONGITUDE"));
				alertDetailsObj.put("remarks",rs1.getString("REMARKS"));
				alertDetailsObj.put("status","");
				alertDetailsObj.put("routeId",rs1.getString("ROUTE_ID"));
				alertDetailsArray.put(alertDetailsObj);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt1, rs1);
		}
		return alertDetailsArray;
	}
	
	private String convertListToSqlINParam(List<String> list){
		StringBuffer sb = new StringBuffer();
		String str= new String();
		for(String id : list){
			sb.append(id);
			sb.append(",");
		}
		if(sb.lastIndexOf(",") >0){
			str = sb.substring(0, sb.lastIndexOf(","));
		}
		return str;
	}
	
	private String convertListToSqlINParamString(List<String> list){
		StringBuffer sb = new StringBuffer();
		String str= new String();
		for(String id : list){
			sb.append("'"+id+"'");
			sb.append(",");
		}
		if(sb.lastIndexOf(",") >0){
			str = sb.substring(0, sb.lastIndexOf(","));
		}
		return str;
	}
	
	public String saveRemarksForDashboard(int clientId,int systemId,int userId,String dashboardRemarks,String tripId,String alertType){
		Connection con = null;
		PreparedStatement pstmt1 = null;
		ResultSet rs1 = null;
		String message = "";
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt1 = con.prepareStatement(DashBoardStatements.INSERT_REMARKS_FOR_DASHBOARD);
			pstmt1.setString(1, dashboardRemarks);
			pstmt1.setString(2, alertType);
			pstmt1.setInt(3, systemId);
			pstmt1.setInt(4, userId);
			pstmt1.setString(5, tripId);
			int val = pstmt1.executeUpdate();
			if(val == 1){
				message = "Remarks Saved Successfully";
			}else{
				message = "Remarks not Saved";
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt1, rs1);
		}
		return message;
		
	}
	
	public JSONArray getMapData(int clientId, int systemId,ArrayList<String> statusId) {
		Connection con = null;
		PreparedStatement pstmt1 = null;
		ResultSet rs1 = null;
		JSONArray alertDetailsArray=new JSONArray();
		JSONObject JsonObject;
		String id = "";
		String condition = "";
		ArrayList<String> vehicleList = new ArrayList<String>();
		HashMap<String, String> lowfuelAlertMap = new HashMap<String, String>();
		HashMap<String, String> lowBatAlertMap = new HashMap<String, String>();
		HashMap<String, String> overSpeedAlertMap = new HashMap<String, String>();
		HashMap<String, String> coolantTempAlertMap = new HashMap<String, String>();
		try {
			con = DBConnection.getConnectionToDB("AMS");
			//Get Vehicle safety alert - Low fuel, Low battery,overspeed, coolant temp alerts
			pstmt1 = con.prepareStatement(DashBoardStatements.GET_VEHICLE_SAFTEY_DETAILS);
			pstmt1.setInt(1, systemId);
			pstmt1.setInt(2, clientId);
			pstmt1.setInt(3, systemId);
			pstmt1.setInt(4, clientId);
			pstmt1.setInt(5, systemId);
			pstmt1.setInt(6, clientId);
			pstmt1.setInt(7, systemId);
			pstmt1.setInt(8, clientId);
			pstmt1.setInt(9, systemId);
			pstmt1.setInt(10, clientId);
			pstmt1.setInt(11, systemId);
			pstmt1.setInt(12, clientId);
			pstmt1.setInt(13, systemId);
			pstmt1.setInt(14, clientId);
			pstmt1.setInt(15, systemId);
			pstmt1.setInt(16, clientId);
			rs1 = pstmt1.executeQuery();
			while(rs1.next()){
				if("LOW_FUEL".equals(rs1.getString("ALERT_TYPE"))){
					lowfuelAlertMap.put(rs1.getString("REGISTRATION_NO"), rs1.getString("VALUE"));
				}
				if("LOW_BAT".equals(rs1.getString("ALERT_TYPE"))){
					lowBatAlertMap.put(rs1.getString("REGISTRATION_NO"), rs1.getString("VALUE"));
				}
				if("OVER_SPEED".equals(rs1.getString("ALERT_TYPE"))){
					if(rs1.getInt("NO_OF_ALERTS") >0)
						overSpeedAlertMap.put(rs1.getString("REGISTRATION_NO"), (rs1.getString("NO_OF_ALERTS")+" Times " +"Max Val:"+((rs1.getString("MAX_VALUE") == null)?"NA":rs1.getString("MAX_VALUE"))+"Km/hr"));
					else
						overSpeedAlertMap.put(rs1.getString("REGISTRATION_NO"), "1 Time Max Val:"+rs1.getString("VALUE")+" Km/hr");
				}
				if("COOLANT_TEMP".equals(rs1.getString("ALERT_TYPE"))){
					coolantTempAlertMap.put(rs1.getString("REGISTRATION_NO"), rs1.getString("VALUE"));
				}
			}
			//
			if(statusId.isEmpty()){
				id = "";
			}else{
				id = convertListToSqlINParam(statusId);
			}
			if( id.isEmpty()){
				condition="";
			}else{
				condition = " and ds.STATUS_ID in ("+id+")";
			}
			pstmt1 = con.prepareStatement(DashBoardStatements.GET_MAP_DETAILS.replace("#", condition));
			pstmt1.setInt(1, systemId);
			pstmt1.setInt(2, clientId);
			//pstmt1.setString(3, id);
			rs1 = pstmt1.executeQuery();
			alertDetailsArray = new JSONArray();
			
			while (rs1.next()) {
				JsonObject = new JSONObject();
				StringBuffer alertDesc = new StringBuffer();
				String alertStr = "";
				vehicleList.add(rs1.getString("ASSET_NUMBER"));
				JsonObject.put("tripId",rs1.getString("TRIP_ID"));
				JsonObject.put("shipmentId",rs1.getString("SHIPMENT_ID"));
				JsonObject.put("routeDesc",rs1.getString("ROUTE_NAME"));
				alertDesc.append(rs1.getString("ALERT_DESC"));
				JsonObject.put("hasVehicleSafteyAlert","false");
				if(lowfuelAlertMap.containsKey(rs1.getString("ASSET_NUMBER"))){
					alertDesc.append(" Low Fuel("+lowfuelAlertMap.get(rs1.getString("ASSET_NUMBER"))+" ltr)");
					JsonObject.put("hasVehicleSafteyAlert","true");
				}if(lowBatAlertMap.containsKey(rs1.getString("ASSET_NUMBER"))){
					alertDesc.append(", Low Battery ("+lowBatAlertMap.get(rs1.getString("ASSET_NUMBER"))+" V)");
					JsonObject.put("hasVehicleSafteyAlert","true");
				}if(overSpeedAlertMap.containsKey(rs1.getString("ASSET_NUMBER"))){
					alertDesc.append(", Over speed ("+overSpeedAlertMap.get(rs1.getString("ASSET_NUMBER"))+")");
					JsonObject.put("hasVehicleSafteyAlert","true");
				}if(coolantTempAlertMap.containsKey(rs1.getString("ASSET_NUMBER"))){
					alertDesc.append(", Coolant Temperature ("+coolantTempAlertMap.get(rs1.getString("ASSET_NUMBER"))+ DEGREE+"C) ");
					JsonObject.put("hasVehicleSafteyAlert","true");
				}		
				alertStr = alertDesc.toString();
				if(alertStr.length() >0 && alertDesc.toString().charAt(0) == ','){
					alertStr = alertStr.replaceFirst(",", "");
				}
				JsonObject.put("alertDesc",alertDesc.toString());
				JsonObject.put("alertType",rs1.getString("ALERT_TYPE"));
				JsonObject.put("vehicleNo",rs1.getString("ASSET_NUMBER"));
				JsonObject.put("driverName",rs1.getString("DRIVER_NAME"));
				JsonObject.put("driverContact",rs1.getString("DRIVER_NUMBER"));
				JsonObject.put("latitude",rs1.getString("LATITUDE"));
				JsonObject.put("longitude",rs1.getString("LONGITUDE"));
				if(rs1.getInt("ALERT_ID")==2 || rs1.getInt("ALERT_ID")==11 || rs1.getInt("ALERT_ID")==0 || rs1.getInt("ALERT_ID")==1){
					JsonObject.put("status","green");
				}
				else if (rs1.getInt("ALERT_ID")==3 || rs1.getInt("ALERT_ID")==7 || rs1.getInt("ALERT_ID")==8 || rs1.getInt("ALERT_ID")==12 )
				{
					JsonObject.put("status","orange");
				}
				else if (rs1.getInt("ALERT_ID")==4 || rs1.getInt("ALERT_ID")==9 || rs1.getInt("ALERT_ID")==10 || rs1.getInt("ALERT_ID")==13)
				{
					JsonObject.put("status","red");
				}
				else if (rs1.getInt("ALERT_ID")==30)
				{
					JsonObject.put("status","lightgreen");
				}
				else{
					JsonObject.put("status","");
				}
				JsonObject.put("remarks",rs1.getString("REMARKS"));
				//getDriverName(con, systemId, clientId, Integer.parseInt(rs1.getString("TRIP_ID")), JsonObject);
				alertDetailsArray.put(JsonObject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt1, rs1);
		}
		return alertDetailsArray;
	}
	public JSONArray getUnUtilizedVehicles(int clientId, int systemId,String statusId) {
		Connection con = null;
		PreparedStatement pstmt1 = null;
		ResultSet rs1 = null;
		JSONArray alertDetailsArray=new JSONArray();
		JSONObject JsonObject;
		try {
			con = DBConnection.getConnectionToDB("AMS");
			if(statusId.equals("33"))
				pstmt1 = con.prepareStatement(DashBoardStatements.GET_UN_UTILIZED_VEHICLE_MAP_DATA);
			else if(statusId.equals("44"))
				pstmt1 = con.prepareStatement(DashBoardStatements.GET_NON_REPORTING_VEHICLE_MAP_DATA);
			pstmt1.setInt(1, systemId);
			pstmt1.setInt(2, clientId);
			pstmt1.setInt(3, systemId);
			pstmt1.setInt(4, clientId);
			rs1 = pstmt1.executeQuery();
			alertDetailsArray = new JSONArray();
			while (rs1.next()) {
				JsonObject = new JSONObject();
//				JsonObject.put("tripId",rs1.getString("TRIP_ID"));
//				JsonObject.put("shipmentId","");
				JsonObject.put("routeDesc","");
				JsonObject.put("alertDesc","");
				JsonObject.put("alertType","");
				JsonObject.put("vehicleNo",rs1.getString("REGISTRATION_NO"));
				JsonObject.put("driverName","");
				JsonObject.put("driverContact","");
				JsonObject.put("latitude",rs1.getString("LATITUDE"));
				JsonObject.put("longitude",rs1.getString("LONGITUDE"));
//				if(rs1.getInt("ALERT_ID")==2 || rs1.getInt("ALERT_ID")==11 || rs1.getInt("ALERT_ID")==30 || rs1.getInt("ALERT_ID")==0 || rs1.getInt("ALERT_ID")==1){
					JsonObject.put("status","green");
//				}
				//getDriverName(con, systemId, clientId, Integer.parseInt(rs1.getString("TRIP_ID")), JsonObject);
				alertDetailsArray.put(JsonObject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt1, rs1);
		}
		return alertDetailsArray;
	}
	public JSONArray getMapDataDelay(int clientId, int systemId,String statusId) {
		Connection con = null;
		PreparedStatement pstmt1 = null;
		ResultSet rs1 = null;
		JSONArray alertDetailsArray=new JSONArray();
		JSONObject JsonObject;
		HashMap<String, String> lowfuelAlertMap = new HashMap<String, String>();
		HashMap<String, String> lowBatAlertMap = new HashMap<String, String>();
		HashMap<String, String> overSpeedAlertMap = new HashMap<String, String>();
		HashMap<String, String> coolantTempAlertMap = new HashMap<String, String>();
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt1 = con.prepareStatement(DashBoardStatements.GET_VEHICLE_SAFTEY_DETAILS);
			pstmt1.setInt(1, systemId);
			pstmt1.setInt(2, clientId);
			pstmt1.setInt(3, systemId);
			pstmt1.setInt(4, clientId);
			pstmt1.setInt(5, systemId);
			pstmt1.setInt(6, clientId);
			pstmt1.setInt(7, systemId);
			pstmt1.setInt(8, clientId);
			pstmt1.setInt(9, systemId);
			pstmt1.setInt(10, clientId);
			pstmt1.setInt(11, systemId);
			pstmt1.setInt(12, clientId);
			pstmt1.setInt(13, systemId);
			pstmt1.setInt(14, clientId);
			pstmt1.setInt(15, systemId);
			pstmt1.setInt(16, clientId);
			rs1 = pstmt1.executeQuery();
			while(rs1.next()){
				if("LOW_FUEL".equals(rs1.getString("ALERT_TYPE"))){
					lowfuelAlertMap.put(rs1.getString("REGISTRATION_NO"), rs1.getString("VALUE"));
				}
				if("LOW_BAT".equals(rs1.getString("ALERT_TYPE"))){
					lowBatAlertMap.put(rs1.getString("REGISTRATION_NO"), rs1.getString("VALUE"));
				}
				if("OVER_SPEED".equals(rs1.getString("ALERT_TYPE"))){
					if(rs1.getInt("NO_OF_ALERTS") > 0)
						overSpeedAlertMap.put(rs1.getString("REGISTRATION_NO"), (rs1.getString("NO_OF_ALERTS")+" Times " +"Max Val:"+((rs1.getString("MAX_VALUE") == null)?"NA":rs1.getString("MAX_VALUE"))+"Km/hr"));
					else
						overSpeedAlertMap.put(rs1.getString("REGISTRATION_NO"),"1 Time Max Val:"+rs1.getString("VALUE")+" Km/hr");
				}
				if("COOLANT_TEMP".equals(rs1.getString("ALERT_TYPE"))){
					coolantTempAlertMap.put(rs1.getString("REGISTRATION_NO"), rs1.getString("VALUE"));
				}
			}
			pstmt1 = con.prepareStatement(DashBoardStatements.GET_MAP_DETAILS_DELAY);
			if(statusId.equals("3")){
				pstmt1.setInt(1, 7);
				pstmt1.setInt(2, 8);
			}else if(statusId.equals("4")){
				pstmt1.setInt(1, 9);
				pstmt1.setInt(2, 10);
			}
			pstmt1.setInt(3, systemId);
			pstmt1.setInt(4, clientId);
			pstmt1.setString(5, statusId);
			rs1 = pstmt1.executeQuery();
			alertDetailsArray = new JSONArray();
			
			while (rs1.next()) {
				JsonObject = new JSONObject();
				StringBuffer alertDesc = new StringBuffer();
				String alertStr = "";
				JsonObject.put("tripId",rs1.getString("TRIP_ID"));
				JsonObject.put("shipmentId",rs1.getString("SHIPMENT_ID"));
				JsonObject.put("routeDesc",rs1.getString("ROUTE_NAME"));
				
				if(lowfuelAlertMap.containsKey(rs1.getString("ASSET_NUMBER"))){
					alertDesc.append(" Low Fuel("+lowfuelAlertMap.get(rs1.getString("ASSET_NUMBER"))+" ltr)");
					JsonObject.put("hasVehicleSafteyAlert","true");
				}if(lowBatAlertMap.containsKey(rs1.getString("ASSET_NUMBER"))){
					alertDesc.append(", Low Battery ("+lowBatAlertMap.get(rs1.getString("ASSET_NUMBER"))+" V)");
					JsonObject.put("hasVehicleSafteyAlert","true");
				}if(overSpeedAlertMap.containsKey(rs1.getString("ASSET_NUMBER"))){
					alertDesc.append(", Over speed ("+overSpeedAlertMap.get(rs1.getString("ASSET_NUMBER"))+")");
					JsonObject.put("hasVehicleSafteyAlert","true");
				}if(coolantTempAlertMap.containsKey(rs1.getString("ASSET_NUMBER"))){
					alertDesc.append(", Coolant Temperature ("+coolantTempAlertMap.get(rs1.getString("ASSET_NUMBER"))+") "+DEGREE+"C");
					JsonObject.put("hasVehicleSafteyAlert","true");
				}		
				alertStr = alertDesc.toString();
				if(alertStr.length() >0 && alertDesc.toString().charAt(0) == ','){
					alertStr = alertStr.replaceFirst(",", "");
				}
				JsonObject.put("alertDesc",alertStr);
				JsonObject.put("alertType",rs1.getString("ALERT_TYPE"));
				JsonObject.put("vehicleNo",rs1.getString("ASSET_NUMBER"));
				JsonObject.put("driverName",rs1.getString("DRIVER_NAME"));
				JsonObject.put("driverContact",rs1.getString("DRIVER_NUMBER"));
				JsonObject.put("latitude",rs1.getString("LATITUDE"));
				JsonObject.put("longitude",rs1.getString("LONGITUDE"));
				if(rs1.getInt("ALERT_ID")==2 || rs1.getInt("ALERT_ID")==11){
					JsonObject.put("status","green");
				}
				else if (rs1.getInt("ALERT_ID")==3 || rs1.getInt("ALERT_ID")==7 || rs1.getInt("ALERT_ID")==8 || rs1.getInt("ALERT_ID")==12 )
				{
					JsonObject.put("status","orange");
				}
				else if (rs1.getInt("ALERT_ID")==4 || rs1.getInt("ALERT_ID")==9 || rs1.getInt("ALERT_ID")==10 || rs1.getInt("ALERT_ID")==13)
				{
					JsonObject.put("status","red");
				}
				else if (rs1.getInt("ALERT_ID")==30)
				{
					JsonObject.put("status","lightgreen");
				}
				else{
					JsonObject.put("status","");
				}
				JsonObject.put("remarks",rs1.getString("REMARKS"));
				//getDriverName(con, systemId, clientId, Integer.parseInt(rs1.getString("TRIP_ID")), JsonObject);
				alertDetailsArray.put(JsonObject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt1, rs1);
		}
		return alertDetailsArray;
	}
	
	public JSONArray getVehicleNoDetailsForOpenTrips(Integer customerId , Integer systemId,int offset) {
	    JSONArray JsonArray = null;
	    JSONObject JsonObject = null;
	    Connection con = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
	    try {
	        JsonArray = new JSONArray();
	        con = DBConnection.getConnectionToDB("AMS");
	        pstmt = con.prepareStatement(DashBoardStatements.GET_VEHICLE_DETAILS_FOR_OPEN_TRIPS);
	        pstmt.setInt(1, offset);
	        pstmt.setInt(2, offset);
	        pstmt.setInt(3, systemId);
	        pstmt.setInt(4, customerId);
	        rs = pstmt.executeQuery();
	        while (rs.next()) {
	        	String tripStartTime="";
	            JsonObject = new JSONObject();
	            if(!rs.getString("ACTUAL_TRIP_START_TIME").contains("1900")){
	            	tripStartTime = rs.getString("ACTUAL_TRIP_START_TIME");
				}
	            else{
	            	tripStartTime =rs.getString("TRIP_START_TIME");
	            }
	            JsonObject.put("tripId", rs.getString("TRIP_ID"));
	            JsonObject.put("vehicleNo", rs.getString("ASSET_NUMBER"));
	            JsonObject.put("shipmentId", rs.getString("SHIPMENT_ID"));
	            JsonObject.put("routeId", rs.getString("ROUTE_ID"));
	            JsonObject.put("tripStartTime", tripStartTime);
	            JsonArray.put(JsonObject);
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	        DBConnection.releaseConnectionToDB(con, pstmt, rs);
	    }
	    return JsonArray;
	}
	
	public JSONArray getShipmentDetails(Integer customerId , Integer systemId,String tripId,int offset) {
	    JSONArray JsonArray = null;
	    JSONObject JsonObject = null;
	    Connection con = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
	    try {
	        JsonArray = new JSONArray();
	        con = DBConnection.getConnectionToDB("AMS");
	        pstmt = con.prepareStatement(DashBoardStatements.GET_SHIPMENT_DETAILS);
	        pstmt.setInt(1, offset);
	        pstmt.setInt(2, Integer.parseInt(tripId));
	        pstmt.setInt(3, systemId);
	        pstmt.setInt(4, customerId);
	        pstmt.setInt(5, Integer.parseInt(tripId));
	        
	        rs = pstmt.executeQuery();
	        while (rs.next()) {
	        	
	        	String ETA = "";
	        	if(!rs.getString("ETA").contains("1900")){
	        		ETA = ddmmyyyy.format(yyyymmdd.parse(rs.getString("ETA")));
				}	        	
	            JsonObject = new JSONObject();
	            String routeKey=rs.getString("ROUTE_KEY");
				String[] srcDes =routeKey.split("_");
				String orginCity = (srcDes.length>=2)?srcDes[0]:"";
				String destCity= (srcDes.length>=2)?srcDes[1]:"";
	            JsonObject.put("vehicleNo", rs.getString("ASSET_NUMBER"));
	            JsonObject.put("shipmentId", rs.getString("SHIPMENT_ID"));
	            if(rs.getString("VEHICLE_MODEL").equals("")){
	            	JsonObject.put("vehicleType", rs.getString("VEHICLE_TYPE"));
	            }
	            else{
	            	JsonObject.put("vehicleType", rs.getString("VEHICLE_TYPE")+" ("+rs.getString("VEHICLE_MODEL")+")");
	            }
	            JsonObject.put("routeName", rs.getString("ROUTE_NAME"));
	            JsonObject.put("custRefId", rs.getString("CUST_REF_ID"));
	            JsonObject.put("source", orginCity);
	            JsonObject.put("destination", destCity);
	            JsonObject.put("distance", rs.getString("DISTANCE"));
	            JsonObject.put("duration", cuf.convertMinutesToHHMMSSFormat(rs.getLong("TAT"))+" ("+ETA+")");
	            //JsonObject.put("currentStatus", rs.getString("TRIP_STATUS"));
	            if(rs.getInt("STATUS_ID")==2 || rs.getInt("STATUS_ID")==30 ){
	            	 if(rs.getInt("STATUS_ID")==2 ){
	            		 JsonObject.put("currentStatus", "On Time");
	            		 JsonObject.put("status","green");
	            	 }else if(rs.getInt("STATUS_ID")==30 ){
	            		 JsonObject.put("currentStatus", "Delayed Hub Exit");
	            		 JsonObject.put("status","lightgreen");
	            	 }else{
	            		 JsonObject.put("currentStatus", "");
	            		 JsonObject.put("status","red");
	            	 }
					
				}
				else if (rs.getInt("STATUS_ID")==3 )
				{
					JsonObject.put("currentStatus", "Delayed < 1 hr");
					JsonObject.put("status","orange");
				}
				else if (rs.getInt("STATUS_ID")==4 )
				{
					JsonObject.put("currentStatus", "Delayed > 1 hr");
					JsonObject.put("status","red");
				}
				else{
					JsonObject.put("currentStatus", "");
					JsonObject.put("status","red");
				}
	            //JsonObject.put("driverId", "");
	            //JsonObject.put("driverName", "");
	            //JsonObject.put("driverContact", "");
	            getDriverName( con , systemId, customerId, rs.getInt("TRIP_ID"), JsonObject);
	          //  getVehicleStatusFlag( con , systemId, customerId, rs.getInt("TRIP_ID"), JsonObject);
	            JsonArray.put(JsonObject);
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	        DBConnection.releaseConnectionToDB(con, pstmt, rs);
	    }
	    return JsonArray;
	}
	
	public JSONObject getDriverName(Connection con ,int systemId,int customerId,int tripId, JSONObject JsonObject){
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		int count=0;
		try {
			pstmt=con.prepareStatement(DashBoardStatements.GET_DRIVER_DETAILS);
			pstmt.setInt(1, tripId);
			pstmt.setInt(2, tripId);
			pstmt.setInt(3, systemId);
			rs=pstmt.executeQuery();
			if(rs.next()){
				if(!rs.getString("DriverName").equals("")){
					JsonObject.put("driverName", rs.getString("DriverName"));
					JsonObject.put("driverContact", rs.getString("Mobile"));
					JsonObject.put("driverId", rs.getString("EmployeeID"));
					//break;
				}
				else{
					JsonObject.put("driverName", "");
					JsonObject.put("driverContact", "");
					JsonObject.put("driverId", "");
				}
			}
			else{
				JsonObject.put("driverName", "");
				JsonObject.put("driverContact", "");
				JsonObject.put("driverId", "");
			}
		} 
		catch (Exception e) {
			e.printStackTrace();
		}
		finally{
			DBConnection.releaseConnectionToDB(null, pstmt, rs);
		}
		return JsonObject;
	}
	
	public JSONArray getAlertsOnTrip(int clientId, int tripId, int systemId,int offset) {
		Connection con = null;
		PreparedStatement pstmt1 = null;
		ResultSet rs1 = null;
		JSONArray alertDetailsArray=new JSONArray();
		JSONObject alertDetailsObj;
		try {
			con = DBConnection.getConnectionToDB("AMS");
			int count=0;
			pstmt1 = con.prepareStatement(DashBoardStatements.GET_ALERTS_ON_TRIP);
			pstmt1.setInt(1, offset);
			pstmt1.setInt(2, tripId);
			rs1 = pstmt1.executeQuery();
			alertDetailsArray = new JSONArray();
			while (rs1.next()) {
				count++;
				alertDetailsObj = new JSONObject();
				String timestamp="";
				if(!rs1.getString("TIME_STAMP").contains("1900")){
					timestamp = ddmmyyyy.format(yyyymmdd.parse(rs1.getString("TIME_STAMP")));
				}
				alertDetailsObj.put("slno",count);
				alertDetailsObj.put("timestamp",timestamp);
				alertDetailsObj.put("routeDesc",rs1.getString("ALERT_NAME"));
				alertDetailsObj.put("remarks",rs1.getString("REMARKS"));
				alertDetailsArray.put(alertDetailsObj);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt1, rs1);
		}
		
		return alertDetailsArray;
	}

	public JSONArray getVehicleHealthCounts(int systemId,int clientId,String tripStartTime,int offset,int tripId)
	{
			JSONObject jsonobject = new JSONObject();
			JSONArray jsonArray = null;
			Connection con = null;
			try {
					jsonArray = new JSONArray();
					con = DBConnection.getConnectionToDB("AMS");
					jsonobject = new JSONObject();
					PreparedStatement pstmt = null;
					ResultSet rs = null;
					try {
						pstmt=con.prepareStatement(DashBoardStatements.GET_ERROR_ALERT_DETAILS_COUNT);//todo
						pstmt.setInt(1, systemId);
						pstmt.setInt(2, clientId);
						//pstmt.setInt(3, offset);
						//pstmt.setString(4, tripStartTime);
						pstmt.setInt(3, tripId);
						rs = pstmt.executeQuery();
						while (rs.next())
						{
							jsonobject.put("errorCodeCount", rs.getString("errorCodeCount"));	
						}
						pstmt=con.prepareStatement(DashBoardStatements.GET_ACTUAL_VEHICLE_DATA);
						pstmt.setInt(1, tripId);
						pstmt.setInt(2, systemId);
						pstmt.setInt(3, clientId);
						rs = pstmt.executeQuery();
						while (rs.next())
						{
							jsonobject.put("fuelLevel", rs.getString("FUEL_LEVEL"));	
							jsonobject.put("batteryVoltage", rs.getString("BATTERY_VOLTAGE"));	
							jsonobject.put("coolantTemp", rs.getString("COOLANT_TEMP"));	
							jsonobject.put("mileage", rs.getString("MILEAGE"));	
							jsonobject.put("odometer", rs.getString("ODOMETER"));	
							jsonobject.put("engineRPM",rs.getString("ENGINE_SPEED"));
						}
						pstmt=con.prepareStatement(DashBoardStatements.GET_ENGINE_RPM_GPS_TAMPER);
						pstmt.setInt(1, systemId);
						pstmt.setInt(2, clientId);
						pstmt.setInt(3, offset);
						pstmt.setString(4, tripStartTime);
						pstmt.setInt(5, tripId);
						pstmt.setInt(6, systemId);
						pstmt.setInt(7, clientId);
						pstmt.setInt(8, offset);
						pstmt.setString(9, tripStartTime);
						pstmt.setInt(10, tripId);
						if (rs.next())
						{
							//jsonobject.put("engineRPM", rs.getString("engineRPMCount"));//rs.getString("BATTERY_VOLTAGE"));	
							jsonobject.put("gpsTampering", rs.getString("gpsTamperCount"));//rs.getString("ENG_FUEL_ECO"));		
						}else{
							//jsonobject.put("engineRPM", "0");
							jsonobject.put("gpsTampering","0");
						}
						
					} catch (Exception e) {
						e.printStackTrace();
					}finally {
						DBConnection.releaseConnectionToDB(null, pstmt, rs);
					}
					
					jsonobject.put("co2EmissionCount", 0);
					jsonobject.put("tyreAmcAlertCount", 0);
					jsonobject.put("truckAmcAlertCount", 0);
					jsonobject.put("complianceAlertCount", 0);
					jsonArray.put(jsonobject);
			} catch (Exception e) {
					e.printStackTrace();
			}finally {
					DBConnection.releaseConnectionToDB(con, null, null);
			}
			return jsonArray;
	}
	
	public ArrayList<Integer> getVehicleHealthDBDetails1(Connection con,int systemId,int clientId,String tripStartTime,int offset,int tripId)
	{
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			ArrayList<Integer> alert=null;
			String sql=null;
			try {
				alert= new ArrayList<Integer>();
				con = DBConnection.getConnectionToDB("AMS");
				sql=DashBoardStatements.GET_ERROR_ALERT_DETAILS_COUNT;
				pstmt=con.prepareStatement(sql);
				pstmt.setInt(1, systemId);
				pstmt.setInt(2, clientId);
				pstmt.setInt(3, offset);
				pstmt.setString(4, tripStartTime);
				pstmt.setInt(5, tripId);
				rs = pstmt.executeQuery();
				while (rs.next())
				{
					alert.add(rs.getInt("PowerTrain"));
					alert.add(rs.getInt("Chasis"));
					alert.add(rs.getInt("Body"));
				}
					
			} catch (Exception e) {
				e.printStackTrace();
			}finally {
				DBConnection.releaseConnectionToDB(null, pstmt, rs);
			}
			return alert;
	}
	
	public ArrayList<Integer> getVehicleHealthDBDetails2(Connection con,int systemId,int clientId,String tripStartTime,int offset,int tripId,String replaceString)
	{
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			ArrayList<Integer> alert=null;
			String sql=null;
			try {
				alert= new ArrayList<Integer>();
				con = DBConnection.getConnectionToDB("AMS");
				sql=DashBoardStatements.GET_POWER_COOLANT_COUNT;
				sql=sql.replace("#", replaceString);
				pstmt=con.prepareStatement(sql);
				pstmt.setInt(1, systemId);
				pstmt.setInt(2, clientId);
				pstmt.setInt(3, offset);
				pstmt.setString(4, tripStartTime);
				pstmt.setInt(5, tripId);
				rs = pstmt.executeQuery();
				while (rs.next())
				{
					alert.add(rs.getInt("CoolantCount"));
				}
				
			} catch (Exception e) {
				e.printStackTrace();
			}finally {
				DBConnection.releaseConnectionToDB(null, pstmt, rs);
			}
			return alert;
	}
	
	public ArrayList<Integer> getVehicleHealthDBDetailsFuel(Connection con,int systemId,int clientId,String tripStartTime,int offset,int tripId,String replaceString)
	{
				PreparedStatement pstmt = null;
				ResultSet rs = null;
				ArrayList<Integer> alert=null;
				String sql=null;
				try {
					alert= new ArrayList<Integer>();
					sql=DashBoardStatements.GET_LOW_FUEL_ALERT_COUNT;
					sql=sql.replace("#", replaceString);
					pstmt=con.prepareStatement(sql);
					pstmt.setInt(1, systemId);
					pstmt.setInt(2, clientId);
					pstmt.setInt(3, offset);
					pstmt.setString(4, tripStartTime);
					pstmt.setInt(5, tripId);
					rs = pstmt.executeQuery();
					while (rs.next())
					{
						alert.add(rs.getInt("LowFuelAlert"));
					}
					
				} catch (Exception e) {
					e.printStackTrace();
				}finally {
					DBConnection.releaseConnectionToDB(null, pstmt, rs);
				}
				return alert;
	}
	
	
	public JSONArray getVehicleHealthGridDetails(int clientId, int tripId, int systemId,int offset,String tripStartTime,int alertKey) {
		Connection con = null;
		PreparedStatement pstmt1 = null;
		ResultSet rs1 = null;
		JSONArray alertDetailsArray=new JSONArray();
		JSONObject alertDetailsObj;
		String condition="";
		try {
			con = DBConnection.getConnectionToDB("AMS");
			int count=0;
			pstmt1 = con.prepareStatement(DashBoardStatements.GET_ERROR_ALERT_DETAILS);
			pstmt1.setInt(1, offset);
			pstmt1.setInt(2, systemId);
			pstmt1.setInt(3, clientId);
			//pstmt1.setInt(4, offset);
			//pstmt1.setString(5, tripStartTime);
			pstmt1.setInt(4,tripId );
			rs1 = pstmt1.executeQuery();
			alertDetailsArray = new JSONArray();
			while (rs1.next()) {
				count++;
				alertDetailsObj = new JSONObject();
				String timestamp="";
				if(!rs1.getString("TIME_STAMP").contains("1900")){
					timestamp = ddmmyyyy.format(yyyymmdd.parse(rs1.getString("TIME_STAMP")));
				}
				alertDetailsObj.put("slno",count);
				alertDetailsObj.put("timestamp",timestamp);
				alertDetailsObj.put("errorDesc",rs1.getString("ERROR_DESC"));
				alertDetailsArray.put(alertDetailsObj);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt1, rs1);
		}
		return alertDetailsArray;
	}

	public JSONObject getVehicleStatusFlag(Connection con ,int systemId,int customerId,int tripId, JSONObject JsonObject){
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		int count=0;
		try {
			pstmt=con.prepareStatement(DashBoardStatements.GET_DRIVER_DETAILS);
			pstmt.setInt(1, tripId);
			pstmt.setInt(2, tripId);
			pstmt.setInt(3, systemId);
			rs=pstmt.executeQuery();
			if(rs.next()){
				if(!rs.getString("DriverName").equals("")){
					JsonObject.put("driverName", rs.getString("DriverName"));
					JsonObject.put("driverContact", rs.getString("Mobile"));
					JsonObject.put("driverId", rs.getString("EmployeeID"));
					//break;
				}
				else{
					JsonObject.put("driverName", "");
					JsonObject.put("driverContact", "");
					JsonObject.put("driverId", "");
				}
			}
			else{
				JsonObject.put("driverName", "");
				JsonObject.put("driverContact", "");
				JsonObject.put("driverId", "");
			}
		} 
		catch (Exception e) {
			e.printStackTrace();
		}
		finally{
			DBConnection.releaseConnectionToDB(null, pstmt, rs);
		}
		return JsonObject;
	}
	
	public JSONArray getAlertDetailsIntransitTrips(int clientId, int systemId,ArrayList<String> statusID) {
		Connection con = null;
		PreparedStatement pstmt1 = null;
		ResultSet rs1 = null;
		JSONArray alertDetailsArray=new JSONArray();
		JSONObject alertDetailsObj;
		String id = "";
		String condition = "";
		try {
			con = DBConnection.getConnectionToDB("AMS");
			if(statusID.isEmpty()){
				id = "";
			}else{
				id = convertListToSqlINParam(statusID);
			}
			if( id.isEmpty()){
				condition="";
			}else{
				condition = "and ds.STATUS_ID in ("+id+")";
			}
			pstmt1 = con.prepareStatement(DashBoardStatements.GET_ALERT_DETAILS_INTANSIT_DELAY.replace("#", condition));
			pstmt1.setInt(1, systemId);
			pstmt1.setInt(2, clientId);
			pstmt1.setInt(3, systemId);
			pstmt1.setInt(4, clientId);
			pstmt1.setInt(5, systemId);
			pstmt1.setInt(6, clientId);
			//pstmt1.setString(3, id);
			rs1 = pstmt1.executeQuery();
			alertDetailsArray = new JSONArray();
			while (rs1.next()) {
				alertDetailsObj = new JSONObject();
				alertDetailsObj.put("tripId",rs1.getString("TRIP_ID"));
				alertDetailsObj.put("shipmentId",rs1.getString("SHIPMENT_ID"));
				alertDetailsObj.put("routeDesc",rs1.getString("ROUTE_NAME"));
				alertDetailsObj.put("alertDesc",rs1.getString("ALERT_DESC"));
				alertDetailsObj.put("alertType",rs1.getString("ALERT_TYPE"));
				alertDetailsObj.put("vehicleNo",rs1.getString("ASSET_NUMBER"));
				alertDetailsObj.put("driverName",rs1.getString("DRIVER_NAME"));
				alertDetailsObj.put("driverContact",rs1.getString("DRIVER_NUMBER"));
				alertDetailsObj.put("latitude",rs1.getString("LATITUDE"));
				alertDetailsObj.put("longitude",rs1.getString("LONGITUDE"));
				alertDetailsObj.put("remarks",rs1.getString("REMARKS"));
				alertDetailsObj.put("status","");
				alertDetailsObj.put("routeId",rs1.getString("ROUTE_ID"));
				alertDetailsArray.put(alertDetailsObj);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt1, rs1);
		}
		return alertDetailsArray;
	}

	public JSONArray getVehicleSafteyAlertDetails(int clientId, int systemId,String alertId) {
		Connection con = null;
		PreparedStatement pstmt1 = null;
		ResultSet rs1 = null;
		JSONArray alertDetailsArray=new JSONArray();
		JSONObject JsonObject;
		ArrayList<String> vehicleList = new ArrayList<String>();
		try {
			con = DBConnection.getConnectionToDB("AMS");
			
			pstmt1 = con.prepareStatement(DashBoardStatements.GET_VEHICLE_SAFTEY_ALERT_DETAIL);
			pstmt1.setInt(1, systemId);
			pstmt1.setInt(2, clientId);
			pstmt1.setString(3, alertId);
			pstmt1.setInt(4, systemId);
			pstmt1.setInt(5, clientId);
			rs1 = pstmt1.executeQuery();
			alertDetailsArray = new JSONArray();
			
			while (rs1.next()) {
				JsonObject = new JSONObject();
				vehicleList.add(rs1.getString("ASSET_NUMBER"));
				JsonObject.put("tripId",rs1.getString("TRIP_ID"));
				JsonObject.put("shipmentId",rs1.getString("SHIPMENT_ID"));
				JsonObject.put("routeDesc",rs1.getString("ROUTE_NAME"));
				if(alertId.equals(DashBoardStatements.LOW_FUEL_ALERT_ID)){
					JsonObject.put("alertType","Low Fuel");
					JsonObject.put("alertDesc","Low Fuel ("+rs1.getString("VALUE")+" ltr)");
				}else if(alertId.equals(DashBoardStatements.LOW_BATTERY_ALERT_ID)){
					JsonObject.put("alertType","Low Battery");
					JsonObject.put("alertDesc","Low Battery("+rs1.getString("VALUE")+" V)");
				}else if(alertId.equals(DashBoardStatements.OVER_SPEED_ALERT_ID)){
					JsonObject.put("alertType","Over Speed("+rs1.getString("VALUE")+" )");
				}else if(alertId.equals(DashBoardStatements.COOLANT_TEMP_ALERT_ID)){
					JsonObject.put("alertType","Coolant Temperature Alert");
					JsonObject.put("alertDesc","Coolant Temperature("+rs1.getString("VALUE") +DEGREE+ "C)");
				}
				JsonObject.put("vehicleNo",rs1.getString("ASSET_NUMBER"));
				JsonObject.put("driverName",rs1.getString("DRIVER_NAME"));
				JsonObject.put("driverContact",rs1.getString("DRIVER_NUMBER"));
				JsonObject.put("latitude",rs1.getString("LATITUDE"));
				JsonObject.put("longitude",rs1.getString("LONGITUDE"));
				//JsonObject.put("remarks",rs1.getString("REMARKS"));
				alertDetailsArray.put(JsonObject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt1, rs1);
		}
		return alertDetailsArray;
	}
	
	public JSONArray getOverSpeedAlertDetails(int clientId, int systemId,String alertId) {
		Connection con = null;
		PreparedStatement pstmt1 = null;
		ResultSet rs1 = null;
		JSONArray alertDetailsArray=new JSONArray();
		JSONObject JsonObject;
		ArrayList<String> vehicleList = new ArrayList<String>();
		try {
			con = DBConnection.getConnectionToDB("AMS");
			
			pstmt1 = con.prepareStatement(DashBoardStatements.GET_OVER_SPEED_ALERT_DETAIL);
			pstmt1.setInt(1, systemId);
			pstmt1.setInt(2, clientId);
			pstmt1.setString(3, alertId);
			pstmt1.setInt(4, systemId);
			pstmt1.setInt(5, clientId);
			rs1 = pstmt1.executeQuery();
			alertDetailsArray = new JSONArray();
			
			while (rs1.next()) {
				JsonObject = new JSONObject();
				vehicleList.add(rs1.getString("ASSET_NUMBER"));
				JsonObject.put("tripId",rs1.getString("TRIP_ID"));
				JsonObject.put("shipmentId",rs1.getString("SHIPMENT_ID"));
				JsonObject.put("routeDesc",rs1.getString("ROUTE_NAME"));
				JsonObject.put("alertType","Over Speed ");
				if(rs1.getInt("NO_OF_ALERTS") >0)
					JsonObject.put("alertDesc","Over Speed( "+rs1.getString("NO_OF_ALERTS")+ " times " +" Max Val:"+((rs1.getString("MAX_VALUE") == null)?"NA":rs1.getString("MAX_VALUE")+" Km/hr)"));
				else
					JsonObject.put("alertDesc","Over Speed (1 Time Max Val:"+rs1.getString("VALUE")+" Km/hr)");
				JsonObject.put("vehicleNo",rs1.getString("ASSET_NUMBER"));
				JsonObject.put("driverName",rs1.getString("DRIVER_NAME"));
				JsonObject.put("driverContact",rs1.getString("DRIVER_NUMBER"));
				JsonObject.put("latitude",rs1.getString("LATITUDE"));
				JsonObject.put("longitude",rs1.getString("LONGITUDE"));
				//JsonObject.put("remarks",rs1.getString("REMARKS"));
				alertDetailsArray.put(JsonObject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt1, rs1);
		}
		return alertDetailsArray;
	}
	
	public JSONArray getVehicleSafteyAlertActionDetails(int clientId, int systemId) {
		Connection con = null;
		PreparedStatement pstmt1 = null;
		ResultSet rs1 = null;
		JSONArray alertDetailsArray=new JSONArray();
		JSONObject alertDetailsObj;
		String id = "";
		String condition = "";
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt1 = con.prepareStatement(DashBoardStatements.GET_VEHICLE_SAFTEY_ACTION_DETAILS);
			pstmt1.setInt(1, systemId);
			pstmt1.setInt(2, clientId);
			pstmt1.setInt(3, systemId);
			pstmt1.setInt(4, clientId);
			rs1 = pstmt1.executeQuery();
			alertDetailsArray = new JSONArray();
			while (rs1.next()) {
				alertDetailsObj = new JSONObject();
				alertDetailsObj.put("tripId",rs1.getString("TRIP_ID"));
				alertDetailsObj.put("shipmentId",rs1.getString("SHIPMENT_ID"));
				alertDetailsObj.put("routeDesc",rs1.getString("ROUTE_NAME"));
				alertDetailsObj.put("alertDesc","");//rs1.getString("ALERT_DESC"));
				if(rs1.getString("TYPE_OF_ALERT").equals(DashBoardStatements.LOW_FUEL_ALERT_ID)){
					alertDetailsObj.put("alertType","Low Fuel");
				}else if(rs1.getString("TYPE_OF_ALERT").equals(DashBoardStatements.LOW_BATTERY_ALERT_ID)){
					alertDetailsObj.put("alertType","Low Battery");
				}else if(rs1.getString("TYPE_OF_ALERT").equals(DashBoardStatements.OVER_SPEED_ALERT_ID)){
					alertDetailsObj.put("alertType","Over Speed");
				}else if(rs1.getString("TYPE_OF_ALERT").equals(DashBoardStatements.COOLANT_TEMP_ALERT_ID)){
					alertDetailsObj.put("alertType","Coolant Temperature");
				}
				alertDetailsObj.put("vehicleNo",rs1.getString("ASSET_NUMBER"));
				alertDetailsObj.put("driverName",rs1.getString("DRIVER_NAME"));
				alertDetailsObj.put("driverContact",rs1.getString("DRIVER_NUMBER"));
				alertDetailsObj.put("latitude",rs1.getString("LATITUDE"));
				alertDetailsObj.put("longitude",rs1.getString("LONGITUDE"));
				alertDetailsObj.put("remarks",rs1.getString("REMARKS"));
				alertDetailsObj.put("status","");
				alertDetailsObj.put("routeId",rs1.getString("ROUTE_ID"));
				alertDetailsArray.put(alertDetailsObj);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt1, rs1);
		}
		return alertDetailsArray;
	}
	
	public JSONArray getSATDashBoardCounts(int clientId, int systemId, int userId,int nonCommHrs) {
		JSONArray jsonArray = new JSONArray();
		JSONObject obj = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int available=0;
		int enroutePlacement=0;
		int onTrip=0;
		int waitingForLoading=0;
		int notReadyForLoading=0;
		int temperatureAlert=0;
		int nonCommVehicles=0;
		
		try {
				con = DBConnection.getConnectionToDB("AMS");
				String stage = DashBoardStatements.GET_DASHBOARD_COUNT_DETAILS;
				pstmt = con.prepareStatement(stage);
				pstmt.setInt(1, clientId);
				pstmt.setInt(2, systemId);
				pstmt.setInt(3, systemId);
				pstmt.setInt(4, clientId);
				pstmt.setInt(5, clientId);
				pstmt.setInt(6, systemId);
				pstmt.setInt(7, clientId);
				pstmt.setInt(8, systemId);
				pstmt.setInt(9, clientId);
				pstmt.setInt(10, systemId);
				pstmt.setInt(11, clientId);
				pstmt.setInt(12, systemId);
				pstmt.setInt(13, nonCommHrs);
				pstmt.setInt(14, clientId);
				pstmt.setInt(15, systemId);
				pstmt.setInt(16, clientId);
				pstmt.setInt(17, systemId);
				rs = pstmt.executeQuery();
				while (rs.next()) {
					if(rs.getString("COUNT_TYPE").equals("AVAILABLE") ){
						available=rs.getInt("COUNT");
					}if(rs.getString("COUNT_TYPE").equals("ENROUTE") ){
						enroutePlacement=rs.getInt("COUNT");
					}if(rs.getString("COUNT_TYPE").equals("ON_TRIP") ){
						onTrip=rs.getInt("COUNT");
					}if(rs.getString("COUNT_TYPE").equals("WAITING_FOR_LOAD") ){
					   waitingForLoading = rs.getInt("COUNT");
					}if(rs.getString("COUNT_TYPE").equals("NOT_READY_FOR_LOAD") ){
						notReadyForLoading=rs.getInt("COUNT");
					}if(rs.getString("COUNT_TYPE").equals("TEMP_ALERT") ){
						temperatureAlert= rs.getInt("COUNT");
					}if(rs.getString("COUNT_TYPE").equals("NON_COMM") ){
						nonCommVehicles= rs.getInt("COUNT");
					}
				}
				obj = new JSONObject();
				obj.put("available",available);
				obj.put("enroute", enroutePlacement);
				obj.put("onTrip", onTrip);
				obj.put("waitingForLoading", waitingForLoading);
				obj.put("notReadyForLoading",  notReadyForLoading);
				obj.put("tempAlert", temperatureAlert);
				obj.put("nonCommVehicles", nonCommVehicles);
				jsonArray.put(obj);
			} 
			 catch (Exception e) {
				e.printStackTrace();
			}finally {
				DBConnection.releaseConnectionToDB(con, pstmt, rs);
			}
		return jsonArray;
	}
	
	public JSONArray getSATDashboardMapDetails(int clientId, int systemId, int userId, String status) {
		//MUSCAT PHARMACY 
		JSONArray jsonArray = new JSONArray();
		JSONObject obj = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String cond="";
		try {
			con = DBConnection.getConnectionToDB("AMS");
			if(status.equals("available")){
				pstmt = con.prepareStatement(DashBoardStatements.GET_AVAILABLE_VEHICLES_MAP_DETAILS);
				pstmt.setInt(1, clientId);
				pstmt.setInt(2, systemId );
				pstmt.setInt(3, systemId);
				pstmt.setInt(4, clientId);
			}
			else if(status.equals("onTrip")){
				cond = "and ACTUAL_TRIP_START_TIME is not null";
				pstmt = con.prepareStatement(DashBoardStatements.GET_VEHICLES_TRIP_MAP_DETAILS.replace("#", cond));
				pstmt.setInt(1, clientId);
				pstmt.setInt(2, systemId);
			}
			else if(status.equals("enroute")){
				cond = "and ACT_SRC_ARR_DATETIME is null ";
				pstmt = con.prepareStatement(DashBoardStatements.GET_VEHICLES_TRIP_MAP_DETAILS.replace("#", cond));
				pstmt.setInt(1, clientId);
				pstmt.setInt(2, systemId);
			}
			else if(status.equals("waiting")){
				cond = "and ttds.IS_PRECOOL_ACHIEVED = 'Y' ";
				pstmt = con.prepareStatement(DashBoardStatements.GET_LOADING_VEHICLES_MAP_DETAILS.replace("#", cond));
				pstmt.setInt(1, clientId);
				pstmt.setInt(2, systemId);
			}
			else if(status.equals("notReady")){
				cond="and ttds.IS_PRECOOL_ACHIEVED = 'N' ";
				pstmt = con.prepareStatement(DashBoardStatements.GET_LOADING_VEHICLES_MAP_DETAILS.replace("#", cond));
				pstmt.setInt(1, clientId);
				pstmt.setInt(2, systemId);
			}
			rs = pstmt.executeQuery();
			jsonArray = new JSONArray();
			while(rs.next()){
				obj = new JSONObject();
				obj.put("tripId",rs.getString("TRIP_ID"));
				obj.put("lat",rs.getString("LATITUDE"));
				obj.put("lon",rs.getString("LONGITUDE"));
				obj.put("location",rs.getString("LOCATION"));
				obj.put("vehicleNo",rs.getString("REG_NO"));
				obj.put("status",status);
				obj.put("driverName",rs.getString("DRIVER_NAME"));
				obj.put("driverContact",rs.getString("DRIVER_CONTACT"));
				
				if(rs.getString("IO_VALUE") == null || rs.getString("IO_VALUE").equals("NA") ){
					obj.put("temperature",rs.getString("ANALOG_INPUT_2"));
				}else{
					obj.put("temperature",rs.getString("IO_VALUE"));
				}
				jsonArray.put(obj);
			}
		}
		 catch (Exception e) {
				e.printStackTrace();
			}finally {
				DBConnection.releaseConnectionToDB(con, pstmt, rs);
			}
		return jsonArray;
}
	public JSONArray getVehicleNoList(int clientId, int systemId,int offset, int userId) {
		
		JSONArray jsonArray = new JSONArray();
		JSONObject obj = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String cond="";
		try {
			 pstmt = con.prepareStatement(DashBoardStatements.GET_VEHICLES_LIST);
		        pstmt.setInt(1, systemId);
		        pstmt.setInt(2, clientId);
		        pstmt.setInt(3, userId);
		        rs=pstmt.executeQuery();
		        while(rs.next()){
		    	   obj=new JSONObject();
		    	   obj.put("vehicleNo", rs.getString("REGISTRATION_NUMBER"));
		        }
		        jsonArray.put(obj);
		}
		 catch (Exception e) {
				e.printStackTrace();
			}finally {
				DBConnection.releaseConnectionToDB(con, pstmt, rs);
			}
			return jsonArray;
	}
	
	public ArrayList<Object> getTempAlertDetails(int systemId, int clientId) {
		JSONArray JsonArray = new JSONArray();
		JSONObject JsonObject = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		ArrayList<Object> finlist = new ArrayList<Object>();
		try {
			//int count = 0;
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(DashBoardStatements.GET_TEMP_ALERT_DATA);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, clientId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
			JsonObject = new JSONObject();
			
			String alertDateTime = "";
			if(!rs.getString("GMT").contains("1900")){
				alertDateTime = ddmmyyyy.format(yyyymmdd.parse(rs.getString("GMT")));
			}	
			String ackDate = "";
			if(!rs.getString("ACK_DATE").contains("1900")){
				ackDate = ddmmyyyy.format(yyyymmdd.parse(rs.getString("ACK_DATE")));
			}
			JsonObject.put("tripNo", rs.getString("TRIP_ID"));
			JsonObject.put("vehicleNo", rs.getString("VEHICLE_NO"));
			JsonObject.put("shipmentId", rs.getString("SHIPMENT_ID"));
			JsonObject.put("alertDatetime", alertDateTime);
			JsonObject.put("updatedBy", rs.getString("ACK_BY"));
			JsonObject.put("updatedDate", ackDate);
			JsonObject.put("remarks", rs.getString("REMARKS"));
			JsonObject.put("id", rs.getString("ID"));
			//JsonObject.put("ack", "");
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

	public JSONArray getDriversByStatus(int systemId, int clientId, String status, Integer userId) {
		JSONArray jsonArray = new JSONArray();
		JSONObject obj = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			con = DBConnection.getConnectionToDB("AMS");
			if (status.equals("AVAILABLE")) {
				pstmt = con.prepareStatement(DashBoardStatements.GET_AVAILABLE_DRIVERS.replace("##", getVehiclesByCondition(userId, con, systemId, clientId, 0,"")));
				pstmt.setInt(1, systemId);
				pstmt.setInt(2, clientId);
				pstmt.setInt(3, systemId);
				pstmt.setInt(4, clientId);
			} else if (status.equals("ON_TRIP")) {// ATD happened
				pstmt = con.prepareStatement(DashBoardStatements.GET_ON_TRIP_DRIVERS.replace("##", getVehiclesByDerivingCondition(userId, con, systemId, clientId)));
				pstmt.setInt(1, systemId);
				pstmt.setInt(2, clientId);
			} else if (status.equals("TRIP_ASSIGNED")) {
				pstmt = con.prepareStatement(DashBoardStatements.GET_TRIP_ASSIGNED_DRIVERS.replace("##", getVehiclesByDerivingCondition(userId, con, systemId, clientId)));
				pstmt.setInt(1, systemId);
				pstmt.setInt(2, clientId);
			}
			rs = pstmt.executeQuery();
			while (rs.next()) {
				obj = new JSONObject();
				obj.put("vehicleNo", rs.getString("REGISTRATION_NO"));
				obj.put("driverName", rs.getString("DRIVER_NAME"));
				obj.put("tripId", rs.getString("TRIP_ID"));
				obj.put("driverId", rs.getString("DRIVER_ID"));
				obj.put("driverContact", rs.getString("DRIVER_CONTACT"));
				jsonArray.put(obj);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jsonArray;
	}

	public JSONArray getLoadingPartners(int systemId, int customerId) {
		JSONArray jsonArray = new JSONArray();
		JSONObject obj = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(DashBoardStatements.GET_LOADING_PARTNERS);
	        pstmt.setInt(1, systemId);
	        pstmt.setInt(2, customerId);
	        rs=pstmt.executeQuery();
	        while(rs.next()){
	    	   obj=new JSONObject();
	    	   obj.put("id", rs.getString("ID"));
	    	   obj.put("name", rs.getString("NAME"));
	    	   jsonArray.put(obj);
	        }
		}
		 catch (Exception e) {
				e.printStackTrace();
			}finally {
				DBConnection.releaseConnectionToDB(con, pstmt, rs);
			}
		return jsonArray;
	}
	
	public JSONArray getHubsByTripCustomer(int systemId, int customerId,String tripCustomerId,String zone) {
		JSONArray jsonArray = new JSONArray();
		JSONObject obj = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(DashBoardStatements.GET_HUBS_BY_TRIP_CUSTOMER.replace("LOCATION_ZONE", "LOCATION_ZONE_"+zone));
	        pstmt.setInt(1, systemId);
	        pstmt.setInt(2, customerId);
	        pstmt.setString(3, tripCustomerId);
	        rs=pstmt.executeQuery();
	        while(rs.next()){
	    	   obj=new JSONObject();
	    	   obj.put("hubId", rs.getString("HUBID"));
	    	   obj.put("latitude", rs.getString("LATITUDE"));
	    	   obj.put("longitude", rs.getString("LONGITUDE"));
	    	   obj.put("name", rs.getString("NAME"));
	    	   obj.put("radius", rs.getString("RADIUS"));
	    	   obj.put("detentionTime", rs.getString("DETENTION"));
	    	   obj.put("address", rs.getString("HUBID"));
	    	   jsonArray.put(obj);
	        }
		}
		 catch (Exception e) {
				e.printStackTrace();
			}finally {
				DBConnection.releaseConnectionToDB(con, pstmt, rs);
			}
		return jsonArray;
	}
	
	public JSONArray getDashBoardCountsForJotun(int clientId, int systemId, int userId,int nonCommHrs,String zone,String regionsId) {
		JSONArray jsonArray = new JSONArray();
		JSONObject obj = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		PreparedStatement pstmt1 = null;
		PreparedStatement pstmt2 = null;
		ResultSet rs = null;
		ResultSet rs1 = null;
		ResultSet rs2 = null;
		int availableLess=0;
		int availableGreater=0;
		int onTrip=0;
		int tripAssigned=0;
		int insideHq=0;
		int total=0;
		int totalAvailable=0;
		int insideHqTripAssigned=0;
		int availableLessMain=0;
		int atBorder=0;
		int stopped=0;
		Coordinate[] cord = null;
		String condition = "";

		String vehiclesByCondition = "";
		String vehicles = "";
		List<String>vehiclesList=new ArrayList<String>();
		try {
				con = DBConnection.getConnectionToDB("AMS");
				
//				if(regionsId.equalsIgnoreCase("0"))
//				condition = getVehiclesByDerivingCondition(userId, con, systemId, clientId);
//				else
//					condition = getVehiclesByDerivingCondition(userId, con, systemId, clientId,regionsId);
//				
				if(regionsId.equalsIgnoreCase("0"))
				{
					vehiclesByCondition = getVehiclesByAssciation(userId, con, systemId, clientId);
					condition = getVehiclesByDerivingCondition(userId, con, systemId, clientId);
					//vehicles = getVehiclesByCondition(userId, con, systemId, clientId, 0,"");
				}
				else
				{
					vehiclesByCondition = getVehiclesByAssciation(userId, con, systemId, clientId);
					condition = getVehiclesByDerivingCondition(userId, con, systemId, clientId,regionsId);
				
				//vehicles = getVehiclesByCondition(userId, con, systemId, clientId, 0,regionsId);
				}
				pstmt = con.prepareStatement(DashBoardStatements.GET_DASHBOARD_COUNT_JOTUN.replace("LOCATION_ZONE", "LOCATION_ZONE_"+zone).replace("##", condition).replace("ADMINCVEHILCES", vehiclesByCondition));
//				else
//					pstmt = con.prepareStatement(DashBoardStatements.GET_DASHBOARD_COUNT_JOTUN_FILTER_BY_REGION.replace("LOCATION_ZONE", "LOCATION_ZONE_"+zone).replace("##", condition).replace("REGIONSID", regionsId));
			if(condition.length()>0)
			{
				vehiclesList=Arrays.asList(condition.split(","));
				pstmt.setInt(1, clientId);
				pstmt.setInt(2, systemId);
				pstmt.setInt(3, clientId);
				pstmt.setInt(4, systemId);
				pstmt.setInt(5, clientId);
				pstmt.setInt(6, systemId);
				pstmt.setInt(7, clientId);
				pstmt.setInt(8, systemId);
				pstmt.setInt(9, clientId);
				pstmt.setInt(10, systemId);
				pstmt.setInt(11, clientId);
				pstmt.setInt(12, systemId);
				pstmt.setInt(13, clientId);
				pstmt.setInt(14, systemId);
				pstmt.setInt(15, clientId);
				pstmt.setInt(16, systemId);
				pstmt.setInt(17, clientId);
				pstmt.setInt(18, systemId);
				pstmt.setInt(19, clientId);
				pstmt.setInt(20, systemId);
				rs = pstmt.executeQuery();
				while (rs.next()) {
					if(rs.getString("COUNT_TYPE").equals("AVAILABLE_GREATER") ){
						availableGreater=rs.getInt("COUNT");
					}if(rs.getString("COUNT_TYPE").equals("ON_TRIP") ){
						onTrip=rs.getInt("COUNT");
					}if(rs.getString("COUNT_TYPE").equals("TRIP_ASSIGNED") ){
						tripAssigned = rs.getInt("COUNT");
					}if(rs.getString("COUNT_TYPE").equals("TOTAL") ){
						total=rs.getInt("COUNT");
					}if(rs.getString("COUNT_TYPE").equals("TOTAL_AVAILABLE") ){
						totalAvailable=rs.getInt("COUNT");
					}
					if(rs.getString("COUNT_TYPE").equals("INSIDE_HQ") ){
					insideHq=0; // taking from detention driver count
					}
					if(rs.getString("COUNT_TYPE").equals("AT_BORDER") ){
						atBorder=rs.getInt("COUNT");
						}
//					if(rs.getString("COUNT_TYPE").equals("INSIDE_HQ_TRIP_ASSIGNED") ){
//						insideHqTripAssigned=rs.getInt("COUNT");
//					}
				}
			//	if(regionsId.equalsIgnoreCase("0"))
				pstmt=con.prepareStatement(DashBoardStatements.GET_STOPPED_VEHICLE_FOR_JOTUN.replace("LOCATION_ZONE", "LOCATION_ZONE_"+zone).replace("#", condition));
//				else
//					pstmt = con.prepareStatement(DashBoardStatements.GET_STOPPED_VEHICLE_FOR_JOTUN_FILTER_BY_REGIONS.replace("LOCATION_ZONE", "LOCATION_ZONE_"+zone).replace("#", condition).replace("REGIONSID", regionsId));
				pstmt.setInt(1, clientId);
				pstmt.setInt(2, systemId);
				rs=pstmt.executeQuery();
				while(rs.next())
				{
					int hours=(int) Math.floor((Float.parseFloat(rs.getString("DURATION"))));
					float min=Float.parseFloat(new DecimalFormat("##.##").format((Float.parseFloat(rs.getString("DURATION"))-hours)));
					int min1= Math.round((min*60));
					float time=Float.parseFloat(hours+"."+min1);
					/*if(rs.getInt("OPERATION_ID")==2)
					{
						if(time >24)
							stopped++;
					}
					else if(time>8)*/
					{
						stopped++;
					}
				}
			}
				obj = new JSONObject();
				obj.put("availableLess",(totalAvailable-availableGreater));

				obj.put("availableGreater", availableGreater);
				obj.put("onTrip", onTrip);
				obj.put("tripAssigned", tripAssigned);
				obj.put("insideHq", insideHq);
				obj.put("totalAvailable", totalAvailable);
				obj.put("atBorder",atBorder);//GetAtBorderVehicles(con,pstmt,rs,condition,clientId,systemId,"",null, null,false).length());
				obj.put("stopped", stopped);
				jsonArray.put(obj);
			} 
			 catch (Exception e) {
				e.printStackTrace();
			}finally {
				DBConnection.releaseConnectionToDB(con, pstmt, rs);
			}
		return jsonArray;
	}
	
	public JSONArray getDashboardMapForJotun(int clientId, int systemId, int userId, String status ,String zone,String regionsId) {
		JSONArray jsonArray = new JSONArray();
		JSONObject obj = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String cond="";
		String vehiclesByCondition = "";
		String vehicles = "";
		try {
			con = DBConnection.getConnectionToDB("AMS");
			if(regionsId.equalsIgnoreCase("0"))
			{
				vehiclesByCondition = getVehiclesByDerivingCondition(userId, con, systemId, clientId);
				vehicles = getVehiclesByAssciation(userId, con, systemId, clientId);
			}
			else
			{
			vehiclesByCondition = getVehiclesByDerivingCondition(userId, con, systemId, clientId,regionsId);
			vehicles = getVehiclesByAssciation(userId, con, systemId, clientId);
			}
			if(vehiclesByCondition.length()>0)
			{
			HashMap<String,ArrayList<String>> mapViewAlertSettingsMap = new HashMap<String,ArrayList<String>>(); 
			ArrayList<Integer> durationList = new ArrayList<Integer>();
			HashMap<String,Coordinate[]> hubIdToCoordinates =  new HashMap<String,Coordinate[]>();
				con = DBConnection.getConnectionToDB("AMS");
			    pstmt = con.prepareStatement("SELECT * FROM MAP_VIEW_SETTINGS WHERE SYSTEM_ID=? and CUSTOMER_ID=?");
			    pstmt.setInt(1, systemId);
				pstmt.setInt(2, clientId);
				rs = pstmt.executeQuery();
				while(rs.next()){
					ArrayList<String> configlist = new ArrayList<String>();
					configlist.add(rs.getString("DURATION"));
					configlist.add(rs.getString("ICON_COLOUR"));
					configlist.add(rs.getString("BLINK"));
					configlist.add(rs.getString("BLINK_DURATION"));
					mapViewAlertSettingsMap.put(rs.getString("ALERT_TYPE")+":"+rs.getString("REGION"), configlist);
					durationList.add(rs.getInt("DURATION"));
					hubIdToCoordinates.put(rs.getString("REGION"), getPolygonLocation(rs.getInt("REGION"), con)) ;
				}
			if(status.equals("available")){
				//cond = "and ETA_SOURCE_HUB < 30";
				pstmt = con.prepareStatement(DashBoardStatements.GET_AVAILABLE_VEHICLES_FOR_JOTUN.replace("ADMINCVEHILCES", vehicles));
				pstmt.setInt(1, systemId);
				pstmt.setInt(2, clientId);
				pstmt.setInt(3, systemId);
				pstmt.setInt(4, clientId);
			}
			else if(status.equals("onTrip")){
				cond = "and ACTUAL_TRIP_START_TIME is not null AND ttd.ASSET_NUMBER IN ("+ vehiclesByCondition +")";
			//	if(regionsId.equalsIgnoreCase("0"))
				pstmt = con.prepareStatement(DashBoardStatements.GET_OPEN_TRIPS_VEHICLES.replace("#", cond));
//				else
//					pstmt = con.prepareStatement(DashBoardStatements.GET_OPEN_TRIPS_VEHICLES_BY_REGION_FILTER.replace("#", cond).replace("REGIONSID", regionsId));
				pstmt.setInt(1, clientId);
				pstmt.setInt(2, systemId);
			}
			else if(status.equals("tripAssigned")){
				cond = "and ACTUAL_TRIP_START_TIME is null AND ttd.ASSET_NUMBER IN ("+ vehiclesByCondition +")";
			//	if(regionsId.equalsIgnoreCase("0"))
				pstmt = con.prepareStatement(DashBoardStatements.GET_OPEN_TRIPS_VEHICLES.replace("#", cond));
//				else
//					pstmt = con.prepareStatement(DashBoardStatements.GET_OPEN_TRIPS_VEHICLES_BY_REGION_FILTER.replace("#", cond).replace("REGIONSID", regionsId));
				pstmt.setInt(1, clientId);
				pstmt.setInt(2, systemId);
			}

			else if(status.equals("stopped"))
			{
			//	if(regionsId.equalsIgnoreCase("0"))
				pstmt = con.prepareStatement(DashBoardStatements.GET_STOPPED_VEHICLE_FOR_JOTUN.replace("LOCATION_ZONE", "LOCATION_ZONE_"+zone).replace("#", vehiclesByCondition));
//				else
//					pstmt = con.prepareStatement(DashBoardStatements.GET_STOPPED_VEHICLE_FOR_JOTUN_FILTER_BY_REGIONS.replace("LOCATION_ZONE", "LOCATION_ZONE_"+zone).replace("#", vehiclesByCondition).replace("REGIONSID", regionsId));
				pstmt.setInt(1, clientId);
				pstmt.setInt(2, systemId);
			}
			 if(status.equals("atBorder")){
				cond = "and ACTUAL_TRIP_START_TIME is null ";
				//if(regionsId.equalsIgnoreCase("0"))
				List<String>vehiclesList=Arrays.asList(vehiclesByCondition.split(","));
				
				jsonArray = new JSONArray();
				jsonArray=GetAtBorderVehicles(con,pstmt,rs,vehiclesByCondition,clientId,systemId,status,hubIdToCoordinates, mapViewAlertSettingsMap,true);
			 }
			 else
			 {
			
			rs = pstmt.executeQuery();
			jsonArray = new JSONArray();
			while(rs.next()){
				obj = new JSONObject();
				obj.put("tripId",rs.getString("TRIP_ID"));
				obj.put("lat",rs.getString("LATITUDE"));
				obj.put("lon",rs.getString("LONGITUDE"));
				obj.put("direction",getDirection(rs.getString("DIRECTION")));
				obj.put("location",rs.getString("LOCATION"));
				obj.put("vehicleNo",rs.getString("REG_NO"));
				obj.put("status",status);
				obj.put("driverName",rs.getString("DRIVER_NAME"));
				obj.put("driverContact",rs.getString("DRIVER_CONTACT"));
				if(status.equals("available") && rs.getString("eta_source_hub") != null){
					if(Integer.parseInt(rs.getString("eta_source_hub")) == 0){
						obj.put("etaSourceHub","Reached HQ");
					}else{
						obj.put("etaSourceHub",cuf.convertMinutesToHHMMFormat(Integer.parseInt(rs.getString("eta_source_hub"))));
					}
					obj.put("etaSourceHubMin",rs.getString("eta_source_hub"));
				}else{
					obj.put("etaSourceHub","");
					obj.put("etaSourceHubMin","");
				}
				if(rs.getString("DURATION") != null){
					if(rs.getString("CATEGORY").equals("stoppage") || rs.getString("CATEGORY").equals("idle")){
						obj.put("duration" ,convertToHHMM(rs.getDouble("DURATION")));
					}else{
						obj.put("duration" ,"NA");
					}
					obj.put("category" ,capitalizeFirstLetter(rs.getString("CATEGORY")));
				}else{
					obj.put("duration" ,"NA");
				}
				checkForStoppageOrIdle(rs, hubIdToCoordinates, mapViewAlertSettingsMap, obj);
				jsonArray.put(obj);
				}
			}
			}
		}
		 catch (Exception e) {
				e.printStackTrace();
			}finally {
				DBConnection.releaseConnectionToDB(con, pstmt, rs);
			}
			
			
			
			
		return jsonArray;
}
	
	public JSONArray getDashboardMapAllForJotun(int clientId, int systemId, int userId, String status,String regionsId) {
		long startTime = System.currentTimeMillis();
		JSONArray jsonArray = new JSONArray();
		JSONObject obj = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		jsonArray = new JSONArray();
		String vehicles = "";
		String vehiclesByCondition = "";
		try {
			HashMap<String,ArrayList<String>> mapViewAlertSettingsMap = new HashMap<String,ArrayList<String>>(); 
			ArrayList<Integer> durationList = new ArrayList<Integer>();
			HashMap<String,Coordinate[]> hubIdToCoordinates =  new HashMap<String,Coordinate[]>();
				con = DBConnection.getConnectionToDB("AMS");
				
				if(regionsId.equalsIgnoreCase("0"))
				{
				vehiclesByCondition = getVehiclesByDerivingCondition(userId, con, systemId, clientId);
				vehicles = getVehiclesByAssciation(userId, con, systemId, clientId);
				}
				else
				{
				vehiclesByCondition = getVehiclesByDerivingCondition(userId, con, systemId, clientId,regionsId);
				vehicles =getVehiclesByAssciation(userId, con, systemId, clientId);
				}
			if(vehiclesByCondition.length()>0)
			{
			    pstmt = con.prepareStatement("SELECT * FROM MAP_VIEW_SETTINGS WHERE SYSTEM_ID=? and CUSTOMER_ID=?");
			    pstmt.setInt(1, systemId);
				pstmt.setInt(2, clientId);
				rs = pstmt.executeQuery();
				while(rs.next()){
					ArrayList<String> configlist = new ArrayList<String>();
					configlist.add(rs.getString("DURATION"));
					configlist.add(rs.getString("ICON_COLOUR"));
					configlist.add(rs.getString("BLINK"));
					configlist.add(rs.getString("BLINK_DURATION"));
					mapViewAlertSettingsMap.put(rs.getString("ALERT_TYPE")+":"+rs.getString("REGION"), configlist);
					durationList.add(rs.getInt("DURATION"));
					hubIdToCoordinates.put(rs.getString("REGION"), getPolygonLocation(rs.getInt("REGION"), con)) ;
				}
				//sort the collection ad put back
				//if(regionsId.equalsIgnoreCase("0"))
				pstmt = con.prepareStatement(DashBoardStatements.GET_AVAILABLE_VEHICLES_FOR_JOTUN.replace("ADMINCVEHILCES", vehicles));
//				else
//					pstmt = con.prepareStatement(DashBoardStatements.GET_AVAILABLE_VEHICLES_FOR_JOTUN_BY_REGION_FILTER.replace("##", vehicles).replace("REGIONSID", regionsId));
				pstmt.setInt(1, systemId); 
				pstmt.setInt(2, clientId);
				pstmt.setInt(3, systemId);
				pstmt.setInt(4, clientId);
				rs = pstmt.executeQuery();
				while(rs.next()){
					obj = new JSONObject();
					obj.put("tripId",rs.getString("TRIP_ID"));
					obj.put("lat",rs.getString("LATITUDE"));
					obj.put("lon",rs.getString("LONGITUDE"));
					obj.put("direction",getDirection(rs.getString("DIRECTION")));
					obj.put("location",rs.getString("LOCATION"));
					obj.put("vehicleNo",rs.getString("REG_NO"));
					obj.put("driverName",rs.getString("DRIVER_NAME"));
					obj.put("driverContact",rs.getString("DRIVER_CONTACT"));
					obj.put("status","available");
					if(rs.getString("eta_source_hub") != null){
						if(Integer.parseInt(rs.getString("eta_source_hub")) == 0){
							obj.put("etaSourceHub","Reached HQ");
						}else{
							obj.put("etaSourceHub",cuf.convertMinutesToHHMMFormat(Integer.parseInt(rs.getString("eta_source_hub"))));
						}
						obj.put("etaSourceHubMin",rs.getString("eta_source_hub"));
					}else{
						obj.put("etaSourceHub","");
						obj.put("etaSourceHubMin","");
					}
					if(rs.getString("DURATION") != null){
						if(rs.getString("CATEGORY").equals("stoppage") || rs.getString("CATEGORY").equals("idle")){
							obj.put("duration" ,convertToHHMM(rs.getDouble("DURATION")));
						}else{
							obj.put("duration" ,"NA");
						}
						obj.put("category" ,capitalizeFirstLetter(rs.getString("CATEGORY")));
					}else{
						obj.put("duration" ,"NA");
					}
					checkForStoppageOrIdle(rs, hubIdToCoordinates, mapViewAlertSettingsMap, obj);
					jsonArray.put(obj);
				}
				
			//	if(regionsId.equalsIgnoreCase("0"))
				pstmt = con.prepareStatement(DashBoardStatements.GET_OPEN_TRIPS_VEHICLES.replace("#", " AND ttd.ASSET_NUMBER IN ( " + vehiclesByCondition + " )"));
//				else
//					pstmt = con.prepareStatement(DashBoardStatements.GET_OPEN_TRIPS_VEHICLES_BY_REGION_FILTER.replace("#", " AND ttd.ASSET_NUMBER IN ( " + vehiclesByCondition + " )").replace("REGIONSID",regionsId ));
				pstmt.setInt(1, clientId);
				pstmt.setInt(2, systemId);
				rs = pstmt.executeQuery();
				while(rs.next()){
					obj = new JSONObject();
					obj.put("tripId",rs.getString("TRIP_ID"));
					obj.put("lat",rs.getString("LATITUDE"));
					obj.put("lon",rs.getString("LONGITUDE"));
					obj.put("location",rs.getString("LOCATION"));
					obj.put("vehicleNo",rs.getString("REG_NO"));
					obj.put("driverName",rs.getString("DRIVER_NAME"));
					obj.put("driverContact",rs.getString("DRIVER_CONTACT"));
					obj.put("etaSourceHub","");
					if(rs.getString("ACTUAL_TRIP_START_TIME") == null){
						obj.put("status","tripAssigned");
					}else{
						obj.put("status","onTrip");
					}
					if(rs.getString("DURATION") != null){
						if(rs.getString("CATEGORY").equals("stoppage") || rs.getString("CATEGORY").equals("idle")){
							obj.put("duration" ,convertToHHMM(rs.getDouble("DURATION")));
						}else{
							obj.put("duration" ,"NA");
						}
						obj.put("category" ,capitalizeFirstLetter(rs.getString("CATEGORY")));
					}else{
						obj.put("duration" ,"NA");
					}
					checkForStoppageOrIdle(rs, hubIdToCoordinates, mapViewAlertSettingsMap, obj);
					jsonArray.put(obj);
				}
			}	
		}
		 catch (Exception e) {
				e.printStackTrace();
			}finally {
				DBConnection.releaseConnectionToDB(con, pstmt, rs);
			}
			
			//System.out.println("Total time taken "+(System.currentTimeMillis()-  startTime));
		return jsonArray;
	}
	
	public void checkForStoppageOrIdle(ResultSet rs,
			HashMap<String, Coordinate[]> hubIdToCoordinates,
			HashMap<String, ArrayList<String>> mapViewAlertSettingsMap,
			JSONObject obj) throws NumberFormatException, SQLException,
			JSONException {
		String category = "";
		if (rs.getString("CATEGORY") != null && ((rs.getString("CATEGORY").equals("stoppage") || (rs.getString("CATEGORY").equals("idle"))))) {
			if (rs.getString("CATEGORY").equals("stoppage")) {
				category = "Stop";
			} else if (rs.getString("CATEGORY").equals("idle")) {
				category = "Idle";
			}
			for (String hubId : hubIdToCoordinates.keySet()) {
				Coordinate vehiCoord = new Coordinate(rs.getDouble("LATITUDE"),
						rs.getDouble("LONGITUDE"));
				boolean isInside = isVehicleInsidePolygon(vehiCoord,
						hubIdToCoordinates.get(hubId));
				if (isInside) {
					ArrayList<String> list = mapViewAlertSettingsMap
							.get(category + ":" + hubId);
					if (list != null) {
						if (rs.getString("DURATION") != null && convertHHMMToMinutes(rs.getDouble("DURATION")) >= Integer.parseInt(list.get(0))) {
							obj.put("iconColour", list.get(1));
							if ("Y".equals(list.get(2))) {
								if (convertHHMMToMinutes(rs.getDouble("DURATION")) >= Integer.parseInt(list.get(3))) {
									obj.put("blink", "Y");
								} else {
									obj.put("blink", "N");
								}
							}
						}
					}
					break;
				}
			}
		}
	}

	public JSONArray getDriverDetentionDetailsForJotun(int clientId, int systemId,int userId,String regionsId) {

		List<JSONObject> jsonArray = new ArrayList<JSONObject>();
		JSONArray sortedArray = new JSONArray();
		JSONObject obj = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String status = "redStatus";
		String vehiclesByCondition = "";
		String vehicles = "";
		try {
			con = DBConnection.getConnectionToDB("AMS");
			if(regionsId.equalsIgnoreCase("0"))
			{
			vehiclesByCondition = getVehiclesByDerivingCondition(userId, con, systemId, clientId);
			///vehicles = getVehiclesByCondition(userId, con, systemId, clientId, 0,"");
			}
			else
			{
			vehiclesByCondition = getVehiclesByDerivingCondition(userId, con, systemId, clientId,regionsId);
		//	vehicles = getVehiclesByCondition(userId, con, systemId, clientId, 0,regionsId);
			}
			if(vehiclesByCondition.length()>0)
			{
			pstmt = con.prepareStatement(DashBoardStatements.GET_DRIVER_DETENTION.replace("##", vehiclesByCondition));
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, clientId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				obj = new JSONObject();
				obj.put("driverName", rs.getString("DRIVER_NAME") + " (" + rs.getString("REGISTRATION_NO") + ")");
				/* 17 is hub arrival */
				obj.put("detention", cuf.convertMinutesToHHMMFormat(rs.getInt("DETENTION")));
				obj.put("detentionInMins", rs.getInt("DETENTION"));

				if (rs.getInt("DETENTION") >= 15 && rs.getInt("DETENTION") <= 45) {
					status = "orangeStatus";
				} else if (rs.getInt("DETENTION") < 15) {
					status = "greenStatus";
				} else {
					status = "redStatus";
				}

				obj.put("status", status);
				jsonArray.add(obj);
			}
			}
			Collections.sort(jsonArray, new Comparator<JSONObject>() {
				private static final String KEY_NAME = "detentionInMins";

				public int compare(JSONObject a, JSONObject b) {
					Integer valA = null;
					Integer valB = null;
					try {
						valA = (Integer) a.get(KEY_NAME);
						valB = (Integer) b.get(KEY_NAME);
					} catch (JSONException e) {
						// do something
					}
					// return valA.compareTo(valB);
					return -valA.compareTo(valB);
				}
			});

			for (int i = 0; i < jsonArray.size(); i++) {
				sortedArray.put(jsonArray.get(i));
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return sortedArray;
	}
	
	public ArrayList<String> getVehicleCurrentLocation(int tripId, int tripCustomerId) {
		JSONArray jsonArray = new JSONArray();
		JSONObject obj = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		PreparedStatement pstmt1 = null;
		ResultSet rs1 = null;
		ArrayList<String> vehicleInfo =  new ArrayList<String>();
		try {
				con = DBConnection.getConnectionToDB("AMS");
				pstmt = con.prepareStatement(DashBoardStatements.CHECK_HUB_DEPARTURE); //Comment thesee lines
				pstmt.setInt(1, tripId);
				pstmt.setInt(2, tripCustomerId);
				rs = pstmt.executeQuery();
				if (rs.next()) {
					if(rs.getDate("ACT_DEP_DATETIME") == null){
						pstmt1 = con.prepareStatement(DashBoardStatements.GET_CURRENT_LOCATION);
						pstmt1.setInt(1, tripId);
						rs1 = pstmt1.executeQuery();
						if(rs1.next()){
							vehicleInfo.add(rs1.getString("LATITUDE"));
							vehicleInfo.add(rs1.getString("LONGITUDE"));
							vehicleInfo.add(rs1.getString("REGISTRATION_NO"));
							vehicleInfo.add(rs1.getString("DRIVER_NAME"));
							vehicleInfo.add(rs1.getString("DRIVER_CONTACT"));
							vehicleInfo.add(rs1.getString("LOCATION"));
						}
					}
				}
			}
			catch (Exception e) {
				e.printStackTrace();
			}finally {
				DBConnection.releaseConnectionToDB(con, pstmt, rs);
				DBConnection.releaseConnectionToDB(con, pstmt1, rs1);
			}
		return vehicleInfo;
	}
	public String saveTripJotun(String assetNumber,String productLine,List desTripDetailsList,LinkedTreeMap trackTripSub,
		int systemId,int customerId,int userId,String tripType,LogWriter logWriter,JSONObject missedTripJSON,Integer offset,Integer tripDestination){
		Connection con=null;
		con = DBConnection.getConnectionToDB("AMS");
		PreparedStatement pstmt = null;
		ResultSet rs= null;
		int tripId = 0;
		String message = "";
		int inserted = 0;
		String checkScanId="";
		
		try {
			if (assetNumber == null || assetNumber.trim().equals("") || assetNumber.length() ==0){
				message = "Invlaid Vehicle Number!!";
				return message;
			}
			checkScanId = checkForDuplicateScanID(con, desTripDetailsList);
			if(!checkScanId.equals("checked")){
				return checkScanId;
			}
			if(tripType != null && tripType.equals("COLLECTIONS")){
				pstmt = con.prepareStatement(DashBoardStatements.INSERT_TRIP_DETAILS_CUSTOMER_COLLECTION,PreparedStatement.RETURN_GENERATED_KEYS);
				assetNumber = "NA";
			}else if (tripType != null && tripType.equals("MTM")){
				pstmt = con.prepareStatement(DashBoardStatements.INSERT_TRIP_DETAILS_JOTUN_MISSED_TRIP,PreparedStatement.RETURN_GENERATED_KEYS);
				pstmt.setInt(6,offset);
				pstmt.setString(7,missedTripJSON.getString("tripStartTime"));
				pstmt.setString(8,(String)trackTripSub.get("driverName"));
				pstmt.setString(9,(String)trackTripSub.get("driverContact"));
				pstmt.setString(10,(String)trackTripSub.get("driverId"));
			}else{
				pstmt = con.prepareStatement(DashBoardStatements.INSERT_TRIP_DETAILS_JOTUN,PreparedStatement.RETURN_GENERATED_KEYS);
				pstmt.setString(6,(String)trackTripSub.get("driverName"));
				pstmt.setString(7,(String)trackTripSub.get("driverContact"));
				pstmt.setString(8,(String)trackTripSub.get("driverId"));
			}
			pstmt.setString(1,assetNumber);
			pstmt.setString(2,productLine);
			pstmt.setInt(3,systemId);
			pstmt.setInt(4,customerId);
			pstmt.setInt(5,userId);
			inserted = pstmt.executeUpdate();
			rs = pstmt.getGeneratedKeys();
			if(rs.next())
			{
				tripId = rs.getInt(1);
			}
			pstmt = con.prepareStatement(DashBoardStatements.INSERT_TRACK_TRIP_DETAILS_SUB_JOTUN);
			pstmt.setInt(1,tripId);
			pstmt.setString(2,(String)trackTripSub.get("loadingPartner"));
			pstmt.executeUpdate();
			if(tripType != null && tripType.equals("COLLECTIONS")){
				insertCheckPointsForCustomerCollection(con,desTripDetailsList,tripId,systemId,customerId);
			}else{
				insertCheckPointsForUnplannedTrip(con,desTripDetailsList,tripId,systemId,customerId,tripType,missedTripJSON,offset,logWriter,tripDestination);
			}
			if (inserted > 0) {
				message = "success";
			}else{
				message = "error";
			}
				logWriter.log("Trip Saved ::"+tripId, LogWriter.ERROR);
				
			}
			catch (Exception e) {
				logWriter.log("Error in DashboardFunction.saveTrip :"+e.getMessage(), LogWriter.ERROR);
				e.printStackTrace();
			} 
			finally {
				DBConnection.releaseConnectionToDB(con, pstmt, rs);
			}
		return message;
	}
	public String modifyTripJotun(int tripId,List desTripDetailsList,LinkedTreeMap trackTripSub,
		int systemId,int customerId,int userId,LogWriter logWriter,Integer tripDestination){
		Connection con=null;
		con = DBConnection.getConnectionToDB("AMS");
		PreparedStatement pstmt = null;
		ResultSet rs= null;
		String message = "";
		String checkScanId="";
		try {
			pstmt = con.prepareStatement(DashBoardStatements.MODIFY_TRACK_TRIP);
			pstmt.setInt(1,userId);
			pstmt.setInt(2,tripId);
			pstmt.executeUpdate();
			
			pstmt = con.prepareStatement(DashBoardStatements.MODIFY_TRIP_SUB);
			pstmt.setString(1,(String)trackTripSub.get("loadingPartner"));
			pstmt.setInt(2,tripId);
			pstmt.executeUpdate();
			
			pstmt = con.prepareStatement(DashBoardStatements.DELETE_FROM_DESTRIP);
			pstmt.setInt(1,tripId);
			pstmt.executeUpdate();
			pstmt = con.prepareStatement(DashBoardStatements.DELETE_FROM_TRIP_ORDER);
			pstmt.setInt(1,tripId);
			pstmt.executeUpdate();
			
//			checkScanId = checkForDuplicateScanID(con, desTripDetailsList);
//			if(!checkScanId.equals("checked")){
//				return checkScanId;
//			}
			insertCheckPointsForUnplannedTrip(con,desTripDetailsList,tripId,systemId,customerId,null,null,null,logWriter,tripDestination);
				message = "success";
				logWriter.log("Trip modified -- "+tripId,LogWriter.INFO);
			}
			catch (Exception e) {
				message = "Trip not modified";
			 logWriter.log("Error in CreateTripFunction.addTripDetails :"+e.getMessage(), LogWriter.ERROR);
			e.printStackTrace();
		
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return message;
	}
	private void  insertCheckPointsForUnplannedTrip(Connection con,List desTripDetailsList,int tripId,int systemId,int customerId,String tripType,JSONObject missedTripJSON,Integer offset,LogWriter logWriter,Integer tripDestination) throws SQLException, Exception, JSONException{
		int count=0;
		int sequence=0;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		SemiAutoTripFunctions semiAutoTripFunctions = new SemiAutoTripFunctions();
		JSONObject tripConfig = null;
		JSONObject tripCustomer = null;
		if(tripType != null && tripType.equals("MTM")){
			tripConfig = semiAutoTripFunctions.getTripConfiguration(con,systemId,customerId);
			 
		}
		
		 for(int i=0; i <desTripDetailsList.size(); i++){ 
 			LinkedTreeMap desTripDetailMap = (LinkedTreeMap)desTripDetailsList.get(i);
			count++;
			pstmt = con.prepareStatement(DashBoardStatements.INSERT_TRIP_POINTS_CHECK_POINTS_JOTUN,PreparedStatement.RETURN_GENERATED_KEYS);
			pstmt.setInt(1, tripId);
	        pstmt.setString(2, (String)desTripDetailMap.get("hubId"));
	        pstmt.setString(3, (String)desTripDetailMap.get("latitude"));
	        pstmt.setString(4, (String)desTripDetailMap.get("longitude"));
	        pstmt.setString(5, (String)desTripDetailMap.get("radius"));
	        pstmt.setString(6, (String)desTripDetailMap.get("detentionTime"));
	        pstmt.setInt(7, sequence);
	        if (tripType != null && (tripType.equalsIgnoreCase("MTM")) && (sequence == 0)) {
	        	pstmt.setString(8, "Y");
			} else {
				pstmt.setNull(8, java.sql.Types.VARCHAR);
			}
	        pstmt.setInt(9, tripDestination);
	        
	        //pstmt.setString(6, (String)desTripDetailMap.get("detentionTime"));put name
	        pstmt.executeUpdate();
	        rs = pstmt.getGeneratedKeys();
	        int desTripId = 0;
			if(rs.next())
			{
				desTripId = rs.getInt(1);
			}
	        LinkedTreeMap tripOrderDetails = (LinkedTreeMap)desTripDetailMap.get("tripOrderDetails");
	        if(tripOrderDetails != null){
		        pstmt = con.prepareStatement(DashBoardStatements.INSERT_INTO_TRIP_ORDER_DETAILS);
		        pstmt.setInt(1, desTripId);
		        pstmt.setInt(2, tripId);
		        pstmt.setString(3, (String)tripOrderDetails.get("scanId"));
		        pstmt.setString(4, (String)tripOrderDetails.get("orderNo"));
		        pstmt.setString(5, (String)tripOrderDetails.get("deliveryTicketNo"));
		        pstmt.setString(6, (String)tripOrderDetails.get("deliveryNoteNo"));
		        pstmt.setString(7, (String)tripOrderDetails.get("tripCustomerId"));
		        pstmt.setString(8, "PENDING");
		        pstmt.setString(9, (String)tripOrderDetails.get("tripCustomerName"));
		        pstmt.setString(10, "N");
		        pstmt.setInt(11, systemId);
		        pstmt.setInt(12, customerId);
		        pstmt.executeUpdate();
	        }
	        sequence++;
	        
	        try{
				if(tripType != null && tripType.equals("MTM")){
					if (missedTripJSON !=null && tripConfig !=null){
						
						int	bufferMins =  tripConfig.getInt("mtmSMSBufferMins");
						Calendar tripStartTime = Calendar.getInstance();
						tripStartTime.setTime(yyyymmdd.parse(missedTripJSON.getString("tripStartTime")));
						tripStartTime.set(Calendar.MINUTE, -offset);
						
						Calendar currentTime = Calendar.getInstance();
						currentTime.add(Calendar.MINUTE, -offset);
						
						Calendar currentTimeBuffer = Calendar.getInstance();
						currentTimeBuffer.add(Calendar.MINUTE, -(offset+bufferMins));
						String domainName = "www.telematics4u.in/Telematics4uApp"; 
						String message = "Dear Customer, Your order "+ (String)tripOrderDetails.get("orderNo") +" is out for delivery.Track your order below ";
						String link = "<a href='" + domainName + "/Jsps/GeneralVertical/VehicleLocationMap.jsp?tripId="+tripId+"&tripCustomerId="+(String)tripOrderDetails.get("tripCustomerId");
						
						
						if((tripStartTime.after(currentTimeBuffer)) && (tripStartTime.before(currentTime))){
							tripCustomer = cuf.getTripCustomerDetails(con, (Integer)tripOrderDetails.get("tripCustomerId"));
							if (tripCustomer !=null && tripConfig !=null){
								try{
									SMSUtil.sendSMS(tripCustomer.getString("CONTACT_NO"), message, tripConfig.getString("smsUrl"), tripConfig.getString("smsUserName"), tripConfig.getString("smsPassword"),logWriter);
									logWriter.log("MTM SMS sent to ::  "+tripCustomer.getString("CONTACT_NO") , LogWriter.INFO);
								}catch (Exception e) {
									e.printStackTrace();
									logWriter.log("Error while sending SMS ::  "+e.getMessage(), LogWriter.ERROR);
									continue;
								}
								
							}
						}
					}
				}
			}catch (Exception e) {
				logWriter.log("Error in DashboardFunction saveTrip  SMS sending for Missed trip:"+e.getMessage(), LogWriter.ERROR);
				continue;
			}
		}
	}
	
	private void  insertCheckPointsForCustomerCollection(Connection con,List desTripDetailsList,int tripId,int systemId,int customerId) throws SQLException{
		int count=0;
		int sequence=0;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		 for(int i=0; i <desTripDetailsList.size(); i++){ 
 			LinkedTreeMap desTripDetailMap = (LinkedTreeMap)desTripDetailsList.get(i);
			count++;
			pstmt = con.prepareStatement(DashBoardStatements.INSERT_TRIP_POINTS_CUSTOMER_COLL,PreparedStatement.RETURN_GENERATED_KEYS);
			pstmt.setInt(1, tripId);
	        pstmt.setInt(2, sequence);
	        pstmt.executeUpdate();
	        rs = pstmt.getGeneratedKeys();
	        int desTripId = 0;
			if(rs.next())
			{
				desTripId = rs.getInt(1);
			}
	        LinkedTreeMap tripOrderDetails = (LinkedTreeMap)desTripDetailMap.get("tripOrderDetails");
	        if(tripOrderDetails != null){
	        	pstmt = con.prepareStatement(DashBoardStatements.INSERT_INTO_TRIP_ORDER_CUST_COLLECTION);
		        pstmt.setInt(1, desTripId);
		        pstmt.setInt(2, tripId);
		        pstmt.setString(3, (String)tripOrderDetails.get("scanId"));
		        pstmt.setString(4, (String)tripOrderDetails.get("orderNo"));
		        pstmt.setString(5, (String)tripOrderDetails.get("deliveryTicketNo"));
		        pstmt.setString(6, (String)tripOrderDetails.get("deliveryNoteNo"));
		        pstmt.setString(7, (String)tripOrderDetails.get("tripCustomerId"));
		        pstmt.setString(8, "DELIVERED");
		        pstmt.setString(9, (String)tripOrderDetails.get("tripCustomerName"));
		        pstmt.setString(10, "N");
		        pstmt.setInt(11, systemId);
		        pstmt.setInt(12, customerId);
		        pstmt.setString(13, (String)tripOrderDetails.get("remarks"));
		        pstmt.setString(14, "COLLECTIONS");
		        pstmt.setString(15, (String)tripOrderDetails.get("collectionOrderLoadPartner"));
		        pstmt.setString(16, (String)tripOrderDetails.get("collectedBy"));
		        pstmt.setString(17, (String)tripOrderDetails.get("mobileNumber"));
		        pstmt.setString(18, (String)tripOrderDetails.get("vehicleNumber"));
		        pstmt.executeUpdate();
	        }
	        sequence++;
		}
	}
	
	public JSONObject getTripDetailsByTripId(int tripId,int offset,String zone) {
		Connection con = null;
		PreparedStatement pstmt = null;
		PreparedStatement pstmt1 = null;
		ResultSet rs = null;
		ResultSet rs1 = null;
		JSONObject jsonObject = new JSONObject();
		int count = 0;
		SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm");
		try{
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(DashBoardStatements.GET_TRACK_TRIP_BY_TRIP_ID);
			pstmt.setInt(1, offset);
			pstmt.setInt(2, offset);
			pstmt.setInt(3, tripId);
			rs = pstmt.executeQuery();
			if(rs.next()){
				jsonObject.put("assetNumber", rs.getString("ASSET_NUMBER"));
				jsonObject.put("tripId", tripId);
				jsonObject.put("insertedByUser", rs.getString("INSERTED_BY"));
				if(rs.getTimestamp("INSERTED_TIME") != null){
					jsonObject.put("insertedDate", sdf.format(rs.getTimestamp("INSERTED_TIME")));
				}else{
					jsonObject.put("insertedDate","");
				}
				if(rs.getTimestamp("UPDATED_DATETIME") != null){
					jsonObject.put("updatedDate", sdf.format(rs.getTimestamp("UPDATED_DATETIME")));
				}else{
					jsonObject.put("updatedDate", "");
				}
			}
			pstmt = con.prepareStatement(DashBoardStatements.GET_TRACK_TRIP_SUB_BY_TRIP_ID);
			pstmt.setInt(1, tripId);
			rs = pstmt.executeQuery();
			if(rs.next()){
				JSONObject trackTripSubJson = new JSONObject();
				trackTripSubJson.put("loadingPartner", rs.getString("LOADING_PARTNER"));
				jsonObject.put("trackTripDetailsSub", trackTripSubJson);
			}
			pstmt = con.prepareStatement(DashBoardStatements.GET_DES_TRIP_DETAILS_BY_TRIP_ID.replace("LOCATION_ZONE", "LOCATION_ZONE_"+zone));
			pstmt.setInt(1, tripId);
			rs = pstmt.executeQuery();
			JSONArray jsonArray = new JSONArray();
			while(rs.next()){
				JSONObject desTripJson = new JSONObject();
				desTripJson.put("hubId", rs.getString("HUB_ID"));
				desTripJson.put("latitude", rs.getString("LATITUDE"));
				desTripJson.put("longitude", rs.getString("LONGITUDE"));
				desTripJson.put("radius", rs.getString("RADIUS"));
				desTripJson.put("detentionTime", rs.getString("DETENTION_TIME"));
				desTripJson.put("name", rs.getString("LOCATION_NAME"));
				desTripJson.put("tripDestination", rs.getString("TRIP_DESTINATION"));
				pstmt1 = con.prepareStatement(DashBoardStatements.GET_DES_TRIP_ORDER_DETAILS);
				pstmt1.setInt(1, rs.getInt("ID"));
				rs1 = pstmt1.executeQuery();
				if(rs1.next()){
					JSONObject tripOrderJson = new JSONObject();
					tripOrderJson.put("desTripId", rs1.getString("DES_TRIP_ID"));
					tripOrderJson.put("scanId", rs1.getString("SCAN_ID"));
					tripOrderJson.put("orderNo", rs1.getString("ORDER_NO"));
					tripOrderJson.put("deliveryTicketNo", rs1.getString("DELIVERY_TICKET_NO"));
					tripOrderJson.put("deliveryNoteNo", rs1.getString("DELIVERY_NOTE_NO"));
					tripOrderJson.put("tripCustomerId", rs1.getString("TRIP_CUSTOMER_ID"));
					tripOrderJson.put("tripCustomerName", rs1.getString("TRIP_CUSTOMER_NAME"));
					//if(rs1.getString("DELIVERY_STATUS").equals("DELIVERED")){
						tripOrderJson.put("deliveryStatus","Y"); 
					//}else{
					//	tripOrderJson.put("deliveryStatus","N");
					//}
					tripOrderJson.put("customerLoc", rs1.getString("TRIP_CUSTOMER_NAME"));
					desTripJson.put("tripOrderDetails", tripOrderJson);
				}
				jsonArray.put(desTripJson);
			}
			jsonObject.put("desTripDetails", jsonArray);
		}catch(Exception e){
			e.printStackTrace();
		}	
		finally{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}	
		return jsonObject;
	}
	public JSONArray getHubsByOperationId(int systemId, int customerId,int operationId,String zone) {
		// for Loading Jotun Head Quaters  
		JSONArray jsonArray = new JSONArray();
		JSONObject obj = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(DashBoardStatements.GET_HUBS_BY_OPERATION_ID.replace("LOCATION", "LOCATION_ZONE_"+zone));
	        pstmt.setInt(1, systemId);
	        pstmt.setInt(2, customerId);
	        pstmt.setInt(3, operationId);
	        rs=pstmt.executeQuery();
	        while(rs.next()){
	    	   obj=new JSONObject();
	    	   obj.put("hubid", rs.getString("HUB_ID"));
	    	   obj.put("name", rs.getString("NAME"));
	    	   obj.put("latitude", rs.getString("LATITUDE"));
	    	   obj.put("longitude", rs.getString("LONGITUDE"));
	    	   obj.put("address", rs.getString("ADDRESS"));
	    	   obj.put("standard_Duration", rs.getString("STD_DUR"));
	    	   obj.put("radius", rs.getString("RADIUS"));
	    	   jsonArray.put(obj);
	        }
		}
		 catch (Exception e) {
				e.printStackTrace();
			}finally {
				DBConnection.releaseConnectionToDB(con, pstmt, rs);
			}
		return jsonArray;
	}
	
	public String closeTripJotun(String remarks,int tripId,List desTripDetailsList,int systemId,int customerId,int userId,LogWriter logWriter){
			Connection con=null;
			con = DBConnection.getConnectionToDB("AMS");
			PreparedStatement pstmt = null;
			ResultSet rs= null;
			String message = "";
			int inserted = 0;
			try {
				
				//update main trip
				pstmt = con.prepareStatement(DashBoardStatements.UPDATE_TRIP_TRIP_DETAIL);
				pstmt.setString(1, remarks);
				pstmt.setInt(2, userId);
				pstmt.setInt(3, tripId);
				pstmt.executeUpdate();
			/*	for(int i=0; i <desTripDetailsList.size(); i++){ 
					LinkedTreeMap desTripDetailMap = (LinkedTreeMap)desTripDetailsList.get(i);
					LinkedTreeMap tripOrderDetails = (LinkedTreeMap)desTripDetailMap.get("tripOrderDetails");
					if(tripOrderDetails != null){
						pstmt = con.prepareStatement(DashBoardStatements.UPDATE_TRIP_ORDER_DETAIL);
						if(((String)tripOrderDetails.get("deliveryStatus")).equals("Y")){
							pstmt.setString(1, "DELIVERED");
						}else if(((String)tripOrderDetails.get("deliveryStatus")).equals("N")){
							pstmt.setString(1, "NOT_DELIVERED");
						}  
						pstmt.setString(2, (String)tripOrderDetails.get("desTripId"));
						pstmt.executeUpdate();
					}
				}   */
				message = "success";
				logWriter.log("Trip Closed :: tripId"+tripId, LogWriter.INFO);
			}catch (Exception e) {
				logWriter.log("Error in CreateTripFunction.addTripDetails :"+e.getMessage(), LogWriter.ERROR);
				e.printStackTrace();
			} finally {
				DBConnection.releaseConnectionToDB(con, pstmt, rs);
			}
			return message;
	}
	
	public void deleteOrderNoForCancel(int tripId){
			Connection con=null;
			con = DBConnection.getConnectionToDB("AMS");
			PreparedStatement pstmt = null;
			ResultSet rs= null;
			try {
				pstmt = con.prepareStatement(DashBoardStatements.DELETE_FROM_DESTRIP);
				pstmt.setInt(1,tripId);
				pstmt.executeUpdate();
				pstmt = con.prepareStatement(DashBoardStatements.DELETE_FROM_TRIP_ORDER);
				pstmt.setInt(1,tripId);
				pstmt.executeUpdate();
				}
				catch (Exception e) {
				e.printStackTrace();
			} finally {
				DBConnection.releaseConnectionToDB(con, pstmt, rs);
			}
	}

	public String checkForDuplicateScanID(Connection con,List desTripDetailsList) {
		// check for duplicate order no
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String message = "checked";
		try {
			for (int i = 0; i < desTripDetailsList.size(); i++) {
				LinkedTreeMap desTripDetailMap = (LinkedTreeMap) desTripDetailsList.get(i);
				LinkedTreeMap tripOrderDetails = (LinkedTreeMap) desTripDetailMap.get("tripOrderDetails");
				if (tripOrderDetails != null) {
					// String orderNo = (String)tripOrderDetails.get("orderNo");
					String scanId = (String) tripOrderDetails.get("scanId");
					pstmt = con.prepareStatement(DashBoardStatements.CHECK_FOR_DUPLICATE_ORDER_NO);
					pstmt.setString(1, scanId);
					rs = pstmt.executeQuery();
					if (rs.next()) {
						message = "Order with " + scanId + " already scanned";
						return message;
					}
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		} 
		return message;
	}
	
	public JSONArray getAllDrivers(int systemId, int clientId) {
		JSONArray jsonArray = new JSONArray();
		JSONObject obj = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
				con = DBConnection.getConnectionToDB("AMS");
				pstmt = con.prepareStatement(DashBoardStatements.GET_ALL_DRIVERS);
				pstmt.setInt(1, systemId);
			    pstmt.setInt(2, clientId);
		        rs=pstmt.executeQuery();
		        while(rs.next()){
		    	   obj=new JSONObject();
		    	   obj.put("vehicleNo", rs.getString("REGISTRATION_NO"));
		    	   obj.put("driverId", rs.getString("DRIVER_ID"));
		    	   obj.put("driverName", rs.getString("DRIVER_NAME"));
		    	   obj.put("driverContact", rs.getString("DRIVER_CONTACT"));
		    	   jsonArray.put(obj);
		        }
		}
		 catch (Exception e) {
				e.printStackTrace();
			}finally {
				DBConnection.releaseConnectionToDB(con, pstmt, rs);
			}
		return jsonArray;
	}

	public JSONArray getOrderDetailsForAcknowledge(int systemId, int clientId, String assetNo, int offset) {
		JSONArray jsonArray = new JSONArray();
		JSONObject obj = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		PreparedStatement pstmt1 = null;
		ResultSet rs = null;
		ResultSet rs1 = null;
		int count=0;
		JSONObject tripOrderJson = new JSONObject();
		try {
				con = DBConnection.getConnectionToDB("AMS");
		    	   pstmt = con.prepareStatement(DashBoardStatements.GET_ORDER_DETAILS_FOR_DRIVER);
		    	   	pstmt.setInt(1,offset);
					pstmt.setString(2, assetNo);
					rs = pstmt.executeQuery();
					while(rs.next()){
						count++;
						 tripOrderJson = new JSONObject();
						//tripOrderJson.put("desTripId", rs.getString("DES_TRIP_ID"));
						tripOrderJson.put("slNoIndex", count);
						tripOrderJson.put("scanId", rs.getString("SCAN_ID"));
						tripOrderJson.put("orderNo", rs.getString("ORDER_NO"));
						tripOrderJson.put("deliveryTicketNo", rs.getString("DELIVERY_TICKET_NO"));
						tripOrderJson.put("deliveryNoteNo", rs.getString("DELIVERY_NOTE_NO"));
						tripOrderJson.put("tripCustomerId", rs.getString("TRIP_CUSTOMER_ID"));
						tripOrderJson.put("tripCustomerName", rs.getString("TRIP_CUSTOMER_NAME"));
						if(rs.getString("DELIVERY_STATUS").equalsIgnoreCase("DELIVERED")) {
							tripOrderJson.put("deliveryStatus","Y");
						}else {
							tripOrderJson.put("deliveryStatus","N");
						}
						
						tripOrderJson.put("customerLoc", rs.getString("TRIP_CUSTOMER_NAME"));
						tripOrderJson.put("scannedBy", rs.getString("INSERTED_BY"));
						tripOrderJson.put("scannedDate", rs.getString("INSERTED_TIME"));//obj.put("tripOrderDetails", tripOrderJson);
						jsonArray.put(tripOrderJson);
					}
		}
		 catch (Exception e) {
				e.printStackTrace();
			}finally {
				DBConnection.releaseConnectionToDB(con, pstmt, rs);
			}
		return jsonArray;
	}
	
	public String saveAcknowlegdedOrders(int systemId, int clientId, String scanId,List gridData, String remarksForAck) {
		
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String message = "";// "Orders Acknowledged";
		String newScanId = scanId.substring(1, scanId.length());
		newScanId= newScanId.replaceAll("\\s+", "");
		String wordsWithQuotes[] = newScanId.split(",");
		int count = wordsWithQuotes.length;
		try {
			con = DBConnection.getConnectionToDB("AMS");
			if(gridData.size() != 0){
		    for(int i=0; i <gridData.size(); i++){ 
	 			LinkedTreeMap gridDataMap = (LinkedTreeMap)gridData.get(i);
	 			//System.out.println(gridDataMap);
	 		
			    pstmt = con.prepareStatement(DashBoardStatements.SAVE_ACK_ORDERS.replace("#", newScanId));
			    if(((String) gridDataMap.get("status")).equals("Y")) {
			    	pstmt.setString(1,"DELIVERED");
			    }else {
			    	pstmt.setString(1,"NOT_DELIVERED");
			    }
			   
			    pstmt.setString(2, remarksForAck);
			    pstmt.setString(3,(String)gridDataMap.get("scanId"));
			    pstmt.setInt(4,systemId);
			    pstmt.setInt(5,clientId);
				pstmt.executeUpdate();
				//message =  count + " Orders Acknowledged";
				message = "Orders Acknowledged";
			}
			}
			else {
				message = "Please Scan Order!!";
			}
			
		 }
		catch (Exception e) {
			e.printStackTrace();
			message= "Error in Orders Acknowledgement";
	}finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
	}
		return message;
	}
	
	public JSONArray getDriverDetentionDetailsForJotunOld(int clientId, int systemId, String zone) {
		JSONArray jsonArray = new JSONArray();
		JSONObject obj = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		PreparedStatement pstmt1 = null;
		PreparedStatement pstmt2 = null;
		ResultSet rs1 = null;
		ResultSet rs2 = null;
		String status = "redStatus";
		Coordinate[] cord = null;
		List<DriverDetentionTime> detentionTimeList = new ArrayList<DriverDetentionTime>();
		try {
				con = DBConnection.getConnectionToDB("AMS");
				pstmt2=con.prepareStatement(DashBoardStatements.GET_HEADQUARTERS_HUBID.replace("LOCATION", "LOCATION_ZONE_"+zone));
				pstmt2.setInt(1, systemId);
				pstmt2.setInt(2, clientId);
				rs2 = pstmt2.executeQuery();
				if (rs2.next()) {
					cord = getPolygonLocation(rs2.getInt("HUBID"), con);
				}
				pstmt = con.prepareStatement(DashBoardStatements.GET_ALL_AVAILABLE_AND_TRIP_ASSIGNED_VEHICLES);
				pstmt.setInt(1, systemId);
				pstmt.setInt(2, clientId);
				pstmt.setInt(3, systemId);
				pstmt.setInt(4, clientId);
				pstmt.setInt(5, systemId);
				pstmt.setInt(6, clientId);
				rs = pstmt.executeQuery();
				while (rs.next()) {
					Coordinate vechcord = new Coordinate(rs.getDouble("LATITUDE"), rs.getDouble("LONGITUDE"));
					boolean poly = isVehicleInsidePolygon(vechcord, cord);
					if (poly == true) {
						pstmt1 = con.prepareStatement(DashBoardStatements.GET_HEADQUARTERS_ARRIVAL_DATETIME);
						pstmt1.setInt(1, systemId);
						pstmt1.setInt(2,clientId );
						pstmt1.setString(3, rs.getString("REGISTRATION_NO"));
						rs1 = pstmt1.executeQuery();
						if(rs1.next()) {
							detentionTimeList.add(new DriverDetentionTime(rs1.getInt("HQ_ARRIVAL_DATETIME"), rs1.getString("DRIVER_NAME")+" ("+rs1.getString("ASSET_NUMBER")));
						}
					}
				}
				//Comparator used to sort the arraylist based on detention time - Swaroop Tewari
				Collections.sort(detentionTimeList, new DriverDetentionTimeComparator());
				//reverse sorting to get detention time in descending order. 
				for (int i=detentionTimeList.size()-1; i>=0; i--){
					obj = new JSONObject();
					obj.put("driverName",detentionTimeList.get(i).name);
					obj.put("detention", cuf.convertMinutesToHHMMFormat(detentionTimeList.get(i).detentionTime));
					if (detentionTimeList.get(i).detentionTime >= 15 && detentionTimeList.get(i).detentionTime <= 45) {
						status = "orangeStatus";
					} else if (detentionTimeList.get(i).detentionTime < 15) {
						status = "greenStatus";
					}
					obj.put("status", status);
					jsonArray.put(obj);
				}
			} 
			 catch (Exception e) {
				e.printStackTrace();
			}finally {
				DBConnection.releaseConnectionToDB(con, pstmt, rs);
				DBConnection.releaseConnectionToDB(con, pstmt1, rs1);
			}
		return jsonArray;
	}
	// to get polygon details for Jotun HQ
	public static Coordinate[] getPolygonLocation(int hubId, Connection con) {
		ArrayList<Coordinate> PolygonDetails = new ArrayList<Coordinate>();
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		final String GET_POLYGON_LOCATION_DETAILS = "select LATITUDE,LONGITUDE,HUBID from AMS.dbo.POLYGON_LOCATION_DETAILS where HUBID=? order by SEQUENCE_ID";
		Coordinate[] PolygonDetailsArray = null;
		try {
			
			pstmt = con.prepareStatement(GET_POLYGON_LOCATION_DETAILS);
			pstmt.setInt(1, hubId);
			rs = pstmt.executeQuery();

			while (rs.next()) {
				if (rs.getString("LATITUDE") != null
						&& rs.getString("LONGITUDE") != null) {
					Coordinate coord = new Coordinate(
							rs.getDouble("LATITUDE"), rs.getDouble("LONGITUDE"));
					PolygonDetails.add(coord);
				}
			}

			if (PolygonDetails.size() > 1) {
				PolygonDetailsArray = new Coordinate[PolygonDetails.size() + 1];
				int i = 0;

				for (i = 0; i < PolygonDetails.size(); i++) {
					PolygonDetailsArray[i] = (Coordinate) PolygonDetails.get(i);
				}

				PolygonDetailsArray[i] = (Coordinate) PolygonDetails.get(0);
			}
		}

		catch (Exception e) {
			e.printStackTrace();
		}

		return PolygonDetailsArray;
	}
	//To check if vehicle is inside the HQ
	public static boolean isVehicleInsidePolygon(Coordinate vehCoord,
			Coordinate[] coords) {
		boolean boo = false;
		try {
			GeometryFactory geomFac = new GeometryFactory();
			Point pt = geomFac.createPoint(vehCoord);
			LinearRing ring = geomFac.createLinearRing(coords);
			Polygon polygon = geomFac.createPolygon(ring, null);
			boo = polygon.contains(pt);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return boo;
	}
	
	public JSONArray getDashboardCountsForNTC(int clientId, int systemId, int userId, int nonCommHrs) {
		JSONArray jsonArray = new JSONArray();
		JSONObject obj = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		PreparedStatement pstmt1 = null;
		ResultSet rs1 = null;
		int totalCount=0;
		int communicating=0;
		int nonCommunicating=0;
		int noGps=0;
		int loadedVehicles = 0;
		int emptyVehicles = 0;
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(DashBoardStatements.GET_COMMU_NONCOMMU_COUNT_FOR_LTSP);
			pstmt.setInt(1, nonCommHrs);
			pstmt.setInt(2, nonCommHrs);
			pstmt.setInt(3, systemId);	
			pstmt.setInt(4, clientId);	
			rs = pstmt.executeQuery();
			if (rs.next()) {
				totalCount=rs.getInt("TOTAL_VEHICLES");
				communicating=rs.getInt("COMM");
				nonCommunicating=rs.getInt("NONCOMM");
				noGps=rs.getInt("NOGPS");
			}
			pstmt = con.prepareStatement(DashBoardStatements.GET_DASHBOARD_COUNTS);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, clientId);
			pstmt.setInt(3, systemId);	
			pstmt.setInt(4, clientId);
			
			rs = pstmt.executeQuery();
			while(rs.next()){
				if(rs.getString("STATUS").equals("LOADED")){
					loadedVehicles = rs.getInt("COUNT");
				}
				if(rs.getString("STATUS").equals("EMPTY")){
					emptyVehicles = rs.getInt("COUNT");
				}
			}
			obj = new JSONObject();
			obj.put("total", totalCount);
			obj.put("communicating", communicating);
			obj.put("noncommunicating", nonCommunicating);
			obj.put("noGps", noGps);
			obj.put("loaded", loadedVehicles);
			obj.put("empty", emptyVehicles);
			
			jsonArray.put(obj);
		}
		 catch (Exception e) {
			e.printStackTrace();
		}finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
			DBConnection.releaseConnectionToDB(con, pstmt1, rs1);
		}
		return jsonArray;
	}
	public JSONArray getMapViewDataForNTCByStatus(int clientId, int systemId, int userId, int nonCommHrs, String status) {
		JSONArray jsonArray = new JSONArray();
		JSONObject obj = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		PreparedStatement pstmt1 = null;
		ResultSet rs1 = null;
		try {
			con = DBConnection.getConnectionToDB("AMS");
			if(status.equalsIgnoreCase("HIGHPRIORITY"))
			{
				pstmt = con.prepareStatement(DashBoardStatements.GET_HIGH_PRIORITY_VEHICLE_DETAILS_FOR_MAPVIEW);
				pstmt.setString(3, "Y");	
				pstmt.setInt(1, systemId);	
				pstmt.setInt(2, clientId);	
				rs = pstmt.executeQuery();
				while(rs.next()){
					obj = new JSONObject();
					obj.put("latitude", rs.getString("LATITUDE"));
					obj.put("longitude", rs.getString("LONGITUDE"));
					obj.put("location", rs.getString("LOCATION"));
					obj.put("status", rs.getString("STATUS"));
					obj.put("speed", rs.getString("SPEED"));
					obj.put("driverName", rs.getString("CREW_NAME"));
					obj.put("driverMobile", rs.getString("CREW_MOBILE"));
					obj.put("materialName", rs.getString("MATERIAL_NAME"));
					obj.put("tripType", rs.getString("TRIP_SHEET_TYPE"));
					obj.put("customerName", rs.getString("COUSTOMER_NAME"));
					obj.put("registrationNo",rs.getString("REGISTRATION_NO"));
					jsonArray.put(obj);
				}
			}
			else if(status.equalsIgnoreCase("ALLVEHICLEINFO"))
			{
				pstmt = con.prepareStatement(DashBoardStatements.GET_All_VEHICLE_INFO_FOR_NTC);
				pstmt.setInt(1, systemId);	
				pstmt.setInt(2, clientId);	
				rs = pstmt.executeQuery();
				
				while(rs.next()){
					obj = new JSONObject();
					obj.put("latitude", rs.getString("LATITUDE"));
					obj.put("longitude", rs.getString("LONGITUDE"));
					obj.put("driverName", rs.getString("DRIVER_NAME")==null?"": rs.getString("DRIVER_NAME"));
					obj.put("location", rs.getString("LOCATION"));
					obj.put("registrationNo",rs.getString("REGISTRATION_NO"));
					obj.put("speed",rs.getString("SPEED"));
					jsonArray.put(obj);
				}
			}
			
			else if(status.equalsIgnoreCase("ONLINEVEHICLEINFO"))
			{
				pstmt = con.prepareStatement(DashBoardStatements.GET_ONLINE_VEHICLE_INFO_FOR_NTC);
				pstmt.setInt(1, systemId);	
				pstmt.setInt(2, clientId);
				pstmt.setInt(3,nonCommHrs);
				rs = pstmt.executeQuery();
				
				while(rs.next()){
					obj = new JSONObject();
					obj.put("latitude", rs.getString("LATITUDE"));
					obj.put("longitude", rs.getString("LONGITUDE"));
					obj.put("driverName",rs.getString("DRIVER_NAME")==null?"": rs.getString("DRIVER_NAME"));
					obj.put("location", rs.getString("LOCATION"));
					obj.put("registrationNo",rs.getString("REGISTRATION_NO"));
					obj.put("speed",rs.getString("SPEED"));
					jsonArray.put(obj);
				}
			}
			else if(status.equalsIgnoreCase("OFFLINEVEHICLEINFO"))
			{
				pstmt = con.prepareStatement(DashBoardStatements.GET_OFFLINE_VEHICLE_INFO_FOR_NTC);
				pstmt.setInt(1, systemId);	
				pstmt.setInt(2, clientId);
				pstmt.setInt(3,nonCommHrs);
				rs = pstmt.executeQuery();
				
				while(rs.next()){
					obj = new JSONObject();
					obj.put("latitude", rs.getString("LATITUDE"));
					obj.put("longitude", rs.getString("LONGITUDE"));
					obj.put("driverName",rs.getString("DRIVER_NAME")==null?"": rs.getString("DRIVER_NAME"));
					obj.put("location", rs.getString("LOCATION"));
					obj.put("registrationNo",rs.getString("REGISTRATION_NO"));
					obj.put("speed",rs.getString("SPEED"));
					jsonArray.put(obj);
				}
			}
			
			else if(status.equalsIgnoreCase("LOADEDVEHICLEINFO"))
			{
				pstmt = con.prepareStatement(DashBoardStatements.GET_lOADED_VEHICLE_INFO_FOR_NTC);
				pstmt.setInt(1, systemId);	
				pstmt.setInt(2, clientId);
				rs = pstmt.executeQuery();
				
				while(rs.next()){
					obj = new JSONObject();
					obj.put("latitude", rs.getString("LATITUDE"));
					obj.put("longitude", rs.getString("LONGITUDE"));
					obj.put("driverName", rs.getString("CREW_NAME"));
					obj.put("location", rs.getString("LOCATION"));
					obj.put("registrationNo",rs.getString("REGISTRATION_NO"));
					obj.put("speed",rs.getString("SPEED"));
					jsonArray.put(obj);
				}
			}
			else if(status.equalsIgnoreCase("EMPTYVEHICLEINFO"))
			{
				pstmt = con.prepareStatement(DashBoardStatements.GET_EMPTY_VEHICLE_INFO_FOR_NTC);
				pstmt.setInt(1, systemId);	
				pstmt.setInt(2, clientId);
				rs = pstmt.executeQuery();
				
				while(rs.next()){
					obj = new JSONObject();
					obj.put("latitude", rs.getString("LATITUDE"));
					obj.put("longitude", rs.getString("LONGITUDE"));
					obj.put("driverName", rs.getString("CREW_NAME"));
					obj.put("location", rs.getString("LOCATION"));
					obj.put("registrationNo",rs.getString("REGISTRATION_NO"));
					obj.put("speed",rs.getString("SPEED"));
					jsonArray.put(obj);
				}
			}
			else if(status.equalsIgnoreCase("getDataForTable"))
			{
				pstmt = con.prepareStatement(DashBoardStatements.GET_VEHICLE_INFO_BY_SPEED);
				pstmt.setInt(1, systemId);	
				pstmt.setInt(2, clientId);
				pstmt.setInt(3, systemId);	
				pstmt.setInt(4, clientId);
				rs = pstmt.executeQuery();
				
				while(rs.next()){
					obj = new JSONObject();
					obj.put("registrationNo", rs.getString("REGISTRATION_NO"));
					obj.put("driverName", rs.getString("CREW_NAME"));
					obj.put("highPriority", rs.getString("HIGH_PRIORITY")=="Y"?true:false);
					obj.put("loaded", rs.getString("TRIP_SHEET_TYPE").equalsIgnoreCase("Loaded")?true:false);
					obj.put("speed",rs.getString("SPEED"));
					jsonArray.put(obj);
				}
			}
			else
			{
				pstmt = con.prepareStatement(DashBoardStatements.GET_VEHICLE_DETAILS_FOR_MAPVIEW);
			pstmt.setInt(1, systemId);	
			pstmt.setInt(2, clientId);	
			rs = pstmt.executeQuery();
			
			while(rs.next()){
				obj = new JSONObject();
				obj.put("latitude", rs.getString("LATITUDE"));
				obj.put("longitude", rs.getString("LONGITUDE"));
				obj.put("location", rs.getString("LOCATION"));
				obj.put("status", rs.getString("STATUS"));
				obj.put("speed", rs.getString("SPEED"));
				obj.put("driverName", rs.getString("CREW_NAME"));
				obj.put("driverMobile", rs.getString("CREW_MOBILE"));
				obj.put("materialName", rs.getString("MATERIAL_NAME"));
				obj.put("tripType", rs.getString("TRIP_SHEET_TYPE"));
				obj.put("customerName", rs.getString("COUSTOMER_NAME"));
				obj.put("registrationNo",rs.getString("REGISTRATION_NO"));
				jsonArray.put(obj);
			}
			}
		}
		 catch (Exception e) {
			e.printStackTrace();
		}finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
			DBConnection.releaseConnectionToDB(con, pstmt1, rs1);
		}
		return jsonArray;
	}
	
	public JSONArray getPieChartsDataForNTC(int clientId, int systemId, int userId, int nonCommHrs, String piechartName,int isLtsp) {
		JSONArray jsonArray = new JSONArray();
		JSONObject obj = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		PreparedStatement pstmt1 = null;
		ResultSet rs1 = null;
		try {
			con = DBConnection.getConnectionToDB("AMS");
			if(piechartName.equalsIgnoreCase("chart1"))
			{
				pstmt = con.prepareStatement(DashBoardStatements.GET_HIGH_PRIORITY_COUNT_CHART);
				pstmt.setInt(1, systemId);	
				pstmt.setInt(2, clientId);	
				pstmt.setInt(3, systemId);	
				pstmt.setInt(4, clientId);
				rs = pstmt.executeQuery();
				
				while(rs.next()){
					obj = new JSONObject();
					int totalHighPriority=rs.getInt(1);
					obj.put("highPriority", totalHighPriority);
					jsonArray.put(obj);
				}
				pstmt = con.prepareStatement(DashBoardStatements.GET_HIGH_PRIORITY_CHART);
				pstmt.setInt(1, systemId);	
				pstmt.setInt(2, clientId);	
				rs = pstmt.executeQuery();
				JSONArray jsonArray1 = new JSONArray();
				while(rs.next()){
					obj = new JSONObject();
					int noOfTrips =rs.getInt(1);
					String customerName =rs.getString(2);
					obj.put("noOfTrips", noOfTrips);
					//jsonArray2.put(obj);
					obj.put("customerName", customerName);
					jsonArray1.put(obj);
				}
				jsonArray.put(jsonArray1);
				//return jsonArray;
		}
		else if(piechartName.equalsIgnoreCase("chart2"))
		{
			
			pstmt = con.prepareStatement(DashBoardStatements.GET_ONLINE_CHART);
			pstmt.setInt(1, nonCommHrs);
			pstmt.setInt(2, systemId);	
			pstmt.setInt(3, clientId);
//			pstmt.setInt(4, userId);
			obj = new JSONObject();
			int i=0;
			rs = pstmt.executeQuery();
			while(rs.next()){
				if(i==0)
				{
				int online=rs.getInt(1);
					obj.put("online", online);
				}
				i++;
			}
			if(isLtsp == 0){
				pstmt = con.prepareStatement(DashBoardStatements.GET_VEHICLE_LIVE_STATUS_FOR_LTSP);	
			}else{
				pstmt = con.prepareStatement(DashBoardStatements.GET_VEHICLE_LIVE_STATUS_FOR_CLIENT);	
			}
//			pstmt = con.prepareStatement(DashBoardStatements.GET_ONLINE_CHART);
//			pstmt.setInt(1, nonCommHrs);	
//			pstmt.setInt(2, systemId);	
//			pstmt.setInt(3, clientId);	
//			pstmt.setInt(4, systemId);	
//			pstmt.setInt(5, clientId);
//			pstmt.setInt(6, systemId);	
//			pstmt.setInt(7, clientId);	
//			rs = pstmt.executeQuery();
			pstmt.setInt(1, clientId);
			pstmt.setInt(2, systemId);
			pstmt.setInt(3, nonCommHrs);
			pstmt.setInt(4,userId);
			rs = pstmt.executeQuery();
//			obj = new JSONObject();
//			 i=0;
			while(rs.next()){
					obj.put("parked", rs.getInt(1));
					obj.put("idle", rs.getInt(2));
					obj.put("running", rs.getInt(3));
			
			}
			jsonArray.put(obj);
		}
			else  if(piechartName.equalsIgnoreCase("chart3"))
				{
					pstmt = con.prepareStatement(DashBoardStatements.GET_POOR_SATELLITE_COUNT_FOR_LTSP);
					pstmt.setInt(1, clientId);
					pstmt.setInt(2, systemId);	
					pstmt.setInt(3, nonCommHrs);
					pstmt.setInt(4,userId);
					rs = pstmt.executeQuery();
					obj = new JSONObject();
					while(rs.next()){
						int poorSat=rs.getInt(1);
						obj.put("poorSat", poorSat);
					}
					pstmt = con.prepareStatement(DashBoardStatements.GET_OFFLINE_CHART);
					pstmt.setInt(1, nonCommHrs);
					pstmt.setInt(2, systemId);	
					pstmt.setInt(3, clientId);
					rs = pstmt.executeQuery();
//					JSONArray jsonArray1 = new JSONArray();
					while(rs.next()){
						int noComm=rs.getInt(1);
						obj.put("noComm", noComm);
					}
					
					pstmt = con.prepareStatement(DashBoardStatements.GET_DISCONNECTED_COUNT);
					pstmt.setInt(1, systemId);
					pstmt.setInt(2, clientId);
					pstmt.setInt(3, nonCommHrs);
					rs = pstmt.executeQuery();
					int i=0,j=0,totalDisConnected=0;
//					obj = new JSONObject();
					while(rs.next()){
						if(rs.getString(2)!=null && rs.getString(2).equalsIgnoreCase("0"))
						{
							totalDisConnected++;
						}
					}
					obj.put("disConnected",totalDisConnected);
					jsonArray.put(obj);
					//return jsonArray;
			}
			else if(piechartName.equalsIgnoreCase("chart4"))
			{
				pstmt = con.prepareStatement(DashBoardStatements.GET_All_VEHICLE_COUNT_BY_LOCATION);
				pstmt.setInt(1, systemId);	
				pstmt.setInt(2, clientId);	
				pstmt.setInt(3, systemId);	
				pstmt.setInt(4, clientId);	
				pstmt.setInt(5, systemId);	
				pstmt.setInt(6, clientId);	
				pstmt.setInt(7, systemId);	
				pstmt.setInt(8, clientId);	
				pstmt.setInt(9, systemId);	
				pstmt.setInt(10, clientId);
				rs = pstmt.executeQuery();
				obj = new JSONObject();
				int i=0;
				while(rs.next()){
					if(i==0)
					{
					int totalTrip=rs.getInt(1);
						obj.put("totalTrip", totalTrip);
					}
					else if(i==1)
					{	
					int loading=rs.getInt(1);
						obj.put("loading", loading);
					}
					else if(i==2)
					{
					int unLoading=rs.getInt(1);		
						obj.put("unLoading", unLoading);
					}
					else if(i==3)
					{
					int serviceCenter=rs.getInt(1);		
						obj.put("serviceCenter", serviceCenter);
					}
					i++;
				}
				jsonArray.put(obj);
			}
			if(piechartName.equalsIgnoreCase("chart8"))
			{
				pstmt = con.prepareStatement(DashBoardStatements.GET_TOP_TRIP_BY_MATERIAL);
				pstmt.setInt(1, systemId);	
				pstmt.setInt(2, clientId);
				pstmt.setInt(3, systemId);	
				pstmt.setInt(4, clientId);
				pstmt.setInt(5, systemId);	
				pstmt.setInt(6, clientId);
				pstmt.setInt(7, systemId);	
				pstmt.setInt(8, clientId);
				pstmt.setInt(9, systemId);	
				pstmt.setInt(10, clientId);
				rs = pstmt.executeQuery();
				//JSONArray jsonArray1 = new JSONArray();
				obj = new JSONObject();
				int i=0,total=0,others=0,sum=0;
				while(rs.next()){
					if(i==0)
					{
					int blade=rs.getInt(1);
					sum+=blade;
						obj.put("blade", blade);
					}
					else if(i==1)
					{	
					int tower=rs.getInt(1);
					sum+=tower;
						obj.put("tower", tower);
					}
					else if(i==2)
					{
					int hub=rs.getInt(1);	
					sum+=hub;
						obj.put("hub", hub);
					}
					else if(i==3)
					{
					int nacelle=rs.getInt(1);	
					sum+=nacelle;
						obj.put("nacelle", nacelle);
					}
					else if(i==4)
					{
					 total=rs.getInt(1);		
//						obj.put("nacelle", nacelle);
					}
					i++;
				}
				obj.put("others", (total-sum));
				jsonArray.put(obj);
				//return jsonArray;
		}
			else if(piechartName.equalsIgnoreCase("chart7"))
			{
				pstmt = con.prepareStatement(DashBoardStatements.GET_CUSTOMER_COUNT_CHART);
				pstmt.setInt(1, systemId);	
				pstmt.setInt(2, clientId);
				rs = pstmt.executeQuery();
				JSONArray jsonArray1 = new JSONArray();
				while(rs.next()){
					obj = new JSONObject();
					int noOfTrips =rs.getInt(1);
					String customerName =rs.getString(2);
					obj.put("noOfTrips", noOfTrips);
					//jsonArray2.put(obj);
					obj.put("customerName", customerName);
					jsonArray1.put(obj);
				}
				jsonArray.put(jsonArray1);
				//return jsonArray;
		}

		}
		 catch (Exception e) {
			e.printStackTrace();
		}finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
			DBConnection.releaseConnectionToDB(con, pstmt1, rs1);
		}
		return jsonArray;
	}
	public JSONArray getOpenTrips(int clientId, int systemId) {
		JSONArray jsonArray = new JSONArray();
		JSONObject obj = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		PreparedStatement pstmt1 = null;
		ResultSet rs1 = null;
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(DashBoardStatements.GET_OPEN_TRIPS);
			pstmt.setInt(1, systemId);	
			pstmt.setInt(2, clientId);	
			pstmt.setInt(3, systemId);	
			pstmt.setInt(4, clientId);
			rs = pstmt.executeQuery();
			//VEHICLE_NO,CREW_NAME,HIGH_PRIORITY,COUSTOMER_NAME,MATERIAL_NAME
			while(rs.next()){
				obj = new JSONObject();
				obj.put("id",rs.getString("ID"));
				obj.put("vehicleNo",rs.getString("VEHICLE_NO"));
				obj.put("driverName",rs.getString("CREW_NAME"));
				obj.put("isPriority",rs.getString("HIGH_PRIORITY"));
				obj.put("customerName",rs.getString("COUSTOMER_NAME"));
				obj.put("material",rs.getString("MATERIAL_NAME"));
				jsonArray.put(obj);
			}
		}
		 catch (Exception e) {
			e.printStackTrace();
		}finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
			DBConnection.releaseConnectionToDB(con, pstmt1, rs1);
		}
		return jsonArray;
	}
	public JSONArray saveHighPrioritySetting(List<String> highPriorityList) {
		JSONArray jsonArray = new JSONArray();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		PreparedStatement pstmt1 = null;
		ResultSet rs1 = null;
		try {
			con = DBConnection.getConnectionToDB("AMS");
			if(highPriorityList.size() > 0){
				 String params = convertListToSqlINParam(highPriorityList);
				 pstmt = con.prepareStatement(DashBoardStatements.UPDATE_HIGH_PRIORITY_SETTINGS.replace("#", params));
				 pstmt.executeUpdate();
				 
				 pstmt = con.prepareStatement(DashBoardStatements.UPDATE_HIGH_PRIORITY_SETTINGS_OFF.replace("#", params));
				 pstmt.executeUpdate();
			}else{
				 pstmt = con.prepareStatement(DashBoardStatements.REMOVE_HIGH_PRIORITY_SETTINGS);
				 pstmt.executeUpdate();
			}
		}
		 catch (Exception e) {
			e.printStackTrace();
		}finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
			DBConnection.releaseConnectionToDB(con, pstmt1, rs1);
		}
		return jsonArray;
	}
	
	public JSONArray getCurrentLocationsForVehicles(String vehicleNos) {
		JSONArray jsonArray = new JSONArray();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		PreparedStatement pstmt1 = null;
		ResultSet rs1 = null;
		try {
			con = DBConnection.getConnectionToDB("AMS");
			String[] vehicleNumers = vehicleNos.split(",");
	    	pstmt = con.prepareStatement(DashBoardStatements.GET_VEHICLE_LOCATION.replace("#", convertListToSqlINParamString(Arrays.asList(vehicleNumers))));
		    rs = pstmt.executeQuery();
		    JSONObject obj = new JSONObject();
			while(rs.next()){
				obj = new JSONObject();
				obj.put("latitude", rs.getString("LATITUDE"));
				obj.put("longitude", rs.getString("LONGITUDE"));
				obj.put("location", rs.getString("LOCATION"));
				obj.put("vehicleNo", rs.getString("REGISTRATION_NO"));
				obj.put("speed", rs.getString("SPEED"));
				jsonArray.put(obj);
			}
		}
		 catch (Exception e) {
			e.printStackTrace();
		}finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
			DBConnection.releaseConnectionToDB(con, pstmt1, rs1);
		}
		return jsonArray;
	}
	public String manualTripStart(String actualTripStartTime,int tripId,Integer userId,LogWriter logWriter,Integer offset,Integer systemId,Integer clientId){
		Connection con=null;
		PreparedStatement pstmt = null;
		ResultSet rs= null;
		PreparedStatement pstmt1 = null;
		PreparedStatement pstmt2 = null;
		JSONObject tripConfig = null;
		String message = "";
		JSONObject tripCustomer = null;
		
		try {
			logWriter.log("Inside manual trip start trip id :: "+tripId +" actualTripStartTime :: "+actualTripStartTime, LogWriter.INFO);
			SemiAutoTripFunctions semiAutoTripFunctions = new SemiAutoTripFunctions();
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(DashBoardStatements.UPDATE_ACTUAL_TRIP_START_TIME);
			pstmt.setInt(1, offset);
			pstmt.setString(2, actualTripStartTime);
			pstmt.setInt(3, userId);
			pstmt.setInt(4, tripId);
			int i = pstmt.executeUpdate();
			if (i >0){
				pstmt1 = con.prepareStatement(DashBoardStatements.UPDATE_MANUAL_TRIP_START_TO_SUB_TABLE);
				pstmt1.setInt(1, tripId);
				pstmt1.executeUpdate();
				
				pstmt2 = con.prepareStatement(DashBoardStatements.UPDATE_DISTANCE_FLAG_MANUAL_TRIP_START_TO_SUB_TABLE);
				pstmt2.setInt(1, tripId);
				pstmt2.executeUpdate();
			}
			try{
				tripConfig = semiAutoTripFunctions.getTripConfiguration(con,systemId,clientId);
			}catch (Exception e) {
				e.printStackTrace();
			}
			message = "success";
			if (tripConfig != null){
				pstmt1 = con.prepareStatement(DashBoardStatements.GET_DES_TRIP_ORDER_DETAILS_BY_TRIP_ID);
				pstmt1.setInt(1, tripId);
				rs = pstmt1.executeQuery();
				while (rs.next()){
					tripCustomer = cuf.getTripCustomerDetails(con, rs.getInt("TRIP_CUSTOMER_ID"));
					try{
						logWriter.log("Manual Trip Start sending SMS SMS ::  "+tripCustomer.getString("CONTACT_NO"), LogWriter.INFO);
						SMSUtil.sendSMS(tripCustomer.getString("CONTACT_NO"), message, tripConfig.getString("smsUrl"), tripConfig.getString("smsUserName"), tripConfig.getString("smsPassword"),logWriter);
						logWriter.log("Manual Trip Start SMS sent to ::  "+tripCustomer.getString("CONTACT_NO"), LogWriter.INFO);
					}catch (Exception e) {
						logWriter.log(" Error while sending Manual Trip Start SMS ::  "+ e.getMessage(), LogWriter.INFO);
						continue;
					}
					
				}
			}
			
			
			
			logWriter.log("Trip Manually Started  :: tripId"+tripId, LogWriter.INFO);
		}catch (Exception e) {
			logWriter.log("Error in Manual Trip Start :"+e.getMessage(), LogWriter.ERROR);
			e.printStackTrace();
			message = "failed";
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
			DBConnection.releaseConnectionToDB(con, pstmt1, rs);
			DBConnection.releaseConnectionToDB(con, pstmt2, rs);
		}
		return message;
	}
	
	public JSONArray getHubDepartures(String approxTripDate, String assetNumber, Integer hubId, int offset, Integer systemId, Integer clientId, LogWriter logWriter) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		JSONArray jsonArray = new JSONArray();
		Integer bufferDays = 0;
		Integer bufferMins = 0;
		List<Date> hubDepartures = new ArrayList<Date>();
		List<Date> tripDepartures = new ArrayList<Date>();
		List<Date> removableItems = new ArrayList<Date>();
		JSONObject tripConfig = null;
		SemiAutoTripFunctions semiAutoTripFunctions = new SemiAutoTripFunctions();

		try {
			logWriter.log("----MTM  Checking Missed Trips Starts-----------" + hubId, LogWriter.INFO);

			con = DBConnection.getConnectionToDB("AMS");
			tripConfig = semiAutoTripFunctions.getTripConfiguration(con, systemId, clientId);
			bufferDays = tripConfig.getInt("mtmBufferDays");
			bufferMins = tripConfig.getInt("mtmBufferMins");
			pstmt = con.prepareStatement(DashBoardStatements.GET_HUB_DEPARTURES_FROM_HUB_REPORT);
			pstmt.setInt(1, offset);
			pstmt.setInt(2, systemId);
			pstmt.setInt(3, hubId);
			pstmt.setString(4, assetNumber);
			pstmt.setInt(5, bufferDays);
			pstmt.setInt(6, offset);
			pstmt.setString(7, yyyymmdd.format(ddmmyyyyhhmmss.parse(approxTripDate)));
			pstmt.setInt(8, offset);
			pstmt.setString(9, yyyymmdd.format(ddmmyyyyhhmmss.parse(approxTripDate)));

			pstmt.setInt(10, offset);
			pstmt.setInt(11, systemId);
			pstmt.setInt(12, hubId);
			pstmt.setString(13, assetNumber);
			pstmt.setInt(14, bufferDays);
			pstmt.setInt(15, offset);
			pstmt.setString(16, yyyymmdd.format(ddmmyyyyhhmmss.parse(approxTripDate)));
			pstmt.setInt(17, offset);
			pstmt.setString(18, yyyymmdd.format(ddmmyyyyhhmmss.parse(approxTripDate)));

			rs = pstmt.executeQuery();
			logWriter.log("---------HUB------------", LogWriter.INFO);
			while (rs.next()) {
				hubDepartures.add(rs.getTimestamp("ACTUAL_DEPARTURE"));
				logWriter.log(rs.getTimestamp("ACTUAL_DEPARTURE").toString(), LogWriter.INFO);
			}
			pstmt.close();
			rs.close();

			pstmt = con.prepareStatement(DashBoardStatements.GET_TRIPS_BETWEEN_DATES);
			pstmt.setInt(1, offset);
			pstmt.setInt(2, systemId);
			pstmt.setInt(3, clientId);
			pstmt.setString(4, assetNumber);
			pstmt.setInt(5, bufferDays);
			pstmt.setInt(6, offset);
			pstmt.setString(7, yyyymmdd.format(ddmmyyyyhhmmss.parse(approxTripDate)));
			pstmt.setInt(8, offset);
			pstmt.setString(9, yyyymmdd.format(ddmmyyyyhhmmss.parse(approxTripDate)));
			rs = pstmt.executeQuery();
			logWriter.log("--------TRIP------------", LogWriter.INFO);
			while (rs.next()) {
				tripDepartures.add(rs.getTimestamp("ACTUAL_TRIP_START_TIME"));
				logWriter.log(rs.getTimestamp("ACTUAL_TRIP_START_TIME").toString(), LogWriter.INFO);
			}
			logWriter.log(" Hub :: " + hubDepartures.size(), LogWriter.INFO);
			logWriter.log(" Trip :: " + tripDepartures.size(), LogWriter.INFO);

			Calendar fromDate = null;
			Calendar toDate = null;

			for (Date hubDate : hubDepartures) {
				for (Date tripDate : tripDepartures) {
					fromDate = Calendar.getInstance();
					fromDate.setTime(hubDate);
					fromDate.add(Calendar.MINUTE, -bufferMins);

					toDate = Calendar.getInstance();
					toDate.setTime(hubDate);
					toDate.add(Calendar.MINUTE, bufferMins);
					if ((tripDate.after(fromDate.getTime())) && (tripDate.before(toDate.getTime()))) {
						logWriter.log( "---- fromDate :: " + yyyymmdd.format(fromDate.getTime()) + "----tripDate :: " + yyyymmdd.format(tripDate) + "----- toDate :: "
								+ yyyymmdd.format(toDate.getTime()), LogWriter.INFO);
						removableItems.add(hubDate);

					}
				}
			}
			hubDepartures.removeAll(removableItems);
			for (Date hub : hubDepartures) {
				jsonArray.put(ddmmyyyyhhmmss.format(hub));
			}

		} catch (Exception e) {
			e.printStackTrace();
			logWriter.log("----Error-----------" + e.getMessage(), LogWriter.ERROR);
		} finally {
			logWriter.log("----MTM  Checking Missed Trips Ends-----------", LogWriter.INFO);
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jsonArray;
	}
		
		private String convertToHHMM(double d){
		double value = 0.00;
		
		int hrs = (int)d;
		int min = (int)((d - hrs) * 60);
		String idletime="0.0";
		if(min < 10){
		idletime=String.valueOf(hrs)+".0"+String.valueOf(min);
		}else{
		idletime=String.valueOf(hrs)+"."+String.valueOf(min);
		}
		return (idletime+"").replace(".", ":");
	}
	private double convertHHMMToMinutes(double d){
		double value = 0.00;
		
		int hrs = (int)d;
		int min = (int)((d - hrs) * 60);
		
		double totalMin = (hrs *60)+min;
		
		
		return totalMin;
	}
	
	public String getVehiclesByDerivingCondition(Integer userId, Connection con, Integer systemId, Integer customerId) {
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Integer roleType = 0;
		String vehicles = "";
		try {
			pstmt = con.prepareStatement(DashBoardStatements.GET_ROLE_TYPE);
			pstmt.setInt(1, userId);
			pstmt.setInt(2, systemId);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				roleType = rs.getInt("ROLE_TYPE");
				vehicles = getVehiclesByCondition(userId, con, systemId, customerId, roleType,"");
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return vehicles;

	}
	
	public String getVehiclesByDerivingCondition(Integer userId, Connection con, Integer systemId, Integer customerId,String regionsId) {
		String vehicles = "";
		
			vehicles = getVehiclesByCondition(userId, con, systemId, customerId, 0,regionsId);
			return vehicles;

	}

	private String getVehiclesByCondition(Integer userId, Connection con, Integer systemId, Integer customerId, Integer roleType,String regionsId) {
		PreparedStatement pstmt1 = null;
		ResultSet rs1 = null;
		String vehicles = "";
		try {
			if (roleType > 0 || regionsId.length()>2) {
				if(regionsId.length()>2)
				pstmt1 = con.prepareStatement(DashBoardStatements.GET_VEHICLES_BY_TRIP_BASED_REGION.replace("##", regionsId));
				else
					pstmt1 = con.prepareStatement(DashBoardStatements.GET_VEHICLES_BY_TRIP_BASED_REGION.replace("##", roleType.toString()));
				pstmt1.setInt(1, systemId);
				pstmt1.setInt(2, customerId);
//				if(regionsId.length()>2)
//				pstmt1.setString(3, regionsId);
//				else
//					pstmt1.setInt(3, roleType);
				rs1 = pstmt1.executeQuery();
				while (rs1.next()) {
					vehicles = vehicles + "'" + rs1.getString("ASSET_NUMBER") + "',";
				}
			} else {
				pstmt1 = con.prepareStatement(DashBoardStatements.GET_VEHICLE_FROM_ASSOCIATED_VEHICLE_GROUP);
				pstmt1.setInt(1, userId);
				pstmt1.setInt(2, systemId);
				pstmt1.setInt(3, systemId);
				pstmt1.setInt(4, customerId);
				rs1 = pstmt1.executeQuery();
				while (rs1.next()) {
					vehicles = vehicles + "'" + rs1.getString("Registration_no") + "',";
				}
			}
			vehicles = vehicles.length() > 0 ? (vehicles.substring(0, vehicles.length() - 1)) : "";
		} catch (Exception e) {
			e.printStackTrace();
		}

		return vehicles;
	}
	
	
	private String getVehiclesByAssciation(Integer userId, Connection con, Integer systemId, Integer customerId) {
		PreparedStatement pstmt1 = null;
		ResultSet rs1 = null;
		String vehicles = "";
		try {
				pstmt1 = con.prepareStatement(DashBoardStatements.GET_VEHICLE_FROM_ASSOCIATED_VEHICLE_GROUP);
				pstmt1.setInt(1, userId);
				pstmt1.setInt(2, systemId);
				pstmt1.setInt(3, systemId);
				pstmt1.setInt(4, customerId);
				rs1 = pstmt1.executeQuery();
				while (rs1.next()) {
					vehicles = vehicles + "'" + rs1.getString("Registration_no") + "',";
				}
			vehicles = vehicles.length() > 0 ? (vehicles.substring(0, vehicles.length() - 1)) : "";
		} catch (Exception e) {
			e.printStackTrace();
		}

		return vehicles;
	}
	
	public String capitalizeFirstLetter(String original) {
	    if (original == null || original.length() == 0) {
	        return original;
	    }
	    return original.substring(0, 1).toUpperCase() + original.substring(1);
	}
	
	public JSONArray GetAtBorderVehicles(Connection con ,PreparedStatement pstmt,ResultSet rs,String vehiclesList,int clientId,int systemId,
			String status,HashMap<String,Coordinate[]> hubIdToCoordinates,HashMap<String,ArrayList<String>> mapViewAlertSettingsMap,boolean forMap)
	{
		JSONArray jsonArray = new JSONArray();
		try
		{
		JSONObject obj = new JSONObject();
		pstmt = con.prepareStatement(DashBoardStatements.GET_LATEST_RECORD_OF_ALL_VEHICLE_FOR_BORDER.replace("#", vehiclesList));
		pstmt.setInt(1, clientId);
		pstmt.setInt(2, systemId);
		rs = pstmt.executeQuery();
		while(rs.next()){
			obj = new JSONObject();
			//obj.put("tripId",rs.getString("TRIP_ID"));
			obj.put("lat",rs.getString("LATITUDE"));
			obj.put("lon",rs.getString("LONGITUDE"));
			obj.put("direction",getDirection(rs.getString("DIRECTION")));
			//obj.put("location",rs.getString("LOCATION"));
			obj.put("vehicleNo",rs.getString("REGISTRATION_NO"));
			//obj.put("status",status);
			obj.put("driverName",rs.getString("DRIVER_NAME"));
			obj.put("driverContact",rs.getString("DRIVER_CONTACT"));
			obj.put("detention", cuf.convertMinutesToHHMMFormat(Integer.parseInt(rs.getString("DETENTION"))));
			obj.put("location",rs.getString("HUB_NAME"));
			if(rs.getString("DURATION") != null){
				if(rs.getString("CATEGORY").equals("stoppage") || rs.getString("CATEGORY").equals("idle")){
					obj.put("duration" ,convertToHHMM(rs.getDouble("DURATION")));
				}else{
					obj.put("duration" ,"NA");
				}
				obj.put("category" ,capitalizeFirstLetter(rs.getString("CATEGORY")));
			}else{
				obj.put("duration" ,"NA");
			}
			obj.put("status", "onTrip");
			if(forMap){
				checkForStoppageOrIdle(rs, hubIdToCoordinates, mapViewAlertSettingsMap, obj);
			}
			jsonArray.put(obj);
		}
		
		return jsonArray;
	}
	catch(Exception e)
	{
		e.printStackTrace();
	}
	return null;
	}
	
	public static String getDirection(String direction) {
		String angle  = "";
		if(direction == null){
			return "90";
		}
		if(direction.equals("N"))
		{
			angle = "0";
		}else if(direction.equals("E")){
			angle = "90";
		}else if(direction.equals("W")){
			angle = "270";
		}else if(direction.equals("S")){
			angle = "180";
		}else if(direction.equals("NE")){
			angle = "45";
		}else if(direction.equals("SE")){
			angle = "135";
		}else if(direction.equals("SW")){
			angle = "225";
		}else if(direction.equals("NW")){
			angle = "315";
		}else if(direction.equals("EN")){
			angle = "45";
		}
		return angle;
	}
	
}
