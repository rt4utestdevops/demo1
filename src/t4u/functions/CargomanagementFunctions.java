package t4u.functions;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.StringTokenizer;
import java.util.Calendar;
import org.json.JSONArray;
import org.json.JSONObject;

import com.t4u.activity.VehicleActivity;
import com.t4u.activity.VehicleSummaryBean;

import t4u.beans.ReportHelper;
import t4u.beans.Vehicle;
import t4u.common.DBConnection;
import t4u.statements.CargomanagementStatements;
import t4u.statements.ContainerCargoManagementStatements;

/**
 * @author Nikhil
 *
 */
public class CargomanagementFunctions {
	CommonFunctions cfuncs = new CommonFunctions();
	SimpleDateFormat sdfyyyymmddhhmmss=new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
	SimpleDateFormat sdfFormatDate = new SimpleDateFormat("MM/dd/yyyy HH:mm:ss");
	CommonFunctions cf = new CommonFunctions();
	DecimalFormat df=new DecimalFormat("##.##");
	SimpleDateFormat simpleDateFormatddMMYYYYDB = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");


	/**Returns the Hub list based on the customer
	 * @param  custID
	 * @param  zone
	 * @return hubJsonArray
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
					CargomanagementStatements.GET_TOTAL_HUBS, zone));
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

	/**Inserts Cargo Trip 
	 * @param custmastcomboId
	 * @param cargotripnametxt
	 * @param cargotripcode
	 * @param cargoorgin
	 * @param transitions
	 * @param cargodestination
	 * @param cargototaltime
	 * @param cargoapproxdistance
	 * @return insertResult
	 */
	public int insertCargoTrip(String cargotripnametxt,
			String cargotripcode, String cargoorgin, String transitions,
			String cargodestination, String cargototaltime,
			String cargoapproxdistance,String customerId,int systemId,int createdby,String cargoaveragespeed) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int insertResult=0;
		try
		{
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(CargomanagementStatements.INSERT_CARGO_ROUTE_SKELETON);
			pstmt.setString(1,cargotripnametxt);
			pstmt.setString(2,cargotripcode);
			pstmt.setInt(3,Integer.parseInt(cargoorgin));
			pstmt.setInt(4,Integer.parseInt(cargodestination));
			pstmt.setString(5,transitions);
			pstmt.setInt(6,Integer.parseInt(cargototaltime));
			pstmt.setInt(7,Integer.parseInt(cargoapproxdistance));
			pstmt.setInt(8,Integer.parseInt(cargoaveragespeed));
			pstmt.setInt(9,Integer.parseInt(customerId));
			pstmt.setInt(10,systemId);
			pstmt.setInt(11,createdby);
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

	/**Returns the Trip Names based on the customer
	 * @param  custID
	 * @param  systemID
	 * @return tripJsonArray
	 */
	public JSONArray getTripnames(String custID, int systemId) {
		JSONArray tripJsonArray = new JSONArray();
		JSONObject tripJsonObject = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			tripJsonArray = new JSONArray();
			tripJsonObject = new JSONObject();
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(CargomanagementStatements.GET_CARGO_TRIP_NAMES);
			pstmt.setInt(1, Integer.parseInt(custID));
			pstmt.setInt(2,systemId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				tripJsonObject = new JSONObject();
				String tripName = rs.getString("TRIP_NAME");
				tripJsonObject.put("TripName", tripName);
				tripJsonArray.put(tripJsonObject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}

		return tripJsonArray;
	}
	/**Returns the Trip Details based on the Trip
	 * @param  custID
	 * @param  tripname
	 * @return tripJsonArray
	 */
	public JSONArray getTripDetails(String customerid, String tripname) {
		JSONArray tripJsonArray = new JSONArray();
		JSONObject tripJsonObject = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			tripJsonArray = new JSONArray();
			tripJsonObject = new JSONObject();
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(CargomanagementStatements.GET_TRIP_DETAILS);
			pstmt.setInt(1, Integer.parseInt(customerid));
			pstmt.setString(2,tripname);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				tripJsonObject = new JSONObject();
				String tripName = rs.getString("TRIP_CODE");
				String orgin = rs.getString("ORIGIN");
				String destination = rs.getString("DESTINATION");
				String transitions = rs.getString("TRANSITION_POINT");
				String time = rs.getString("STD_TIME");
				String distance = rs.getString("DISTANCE");
				String avgSpeed= rs.getString("AVG_SPEED");
				tripJsonObject.put("cargotripcode", tripName);
				tripJsonObject.put("cargotriporgin", orgin);
				tripJsonObject.put("cargotransitions", transitions);
				tripJsonObject.put("cargotripdestination", destination);
				tripJsonObject.put("cargototaltime", time);
				tripJsonObject.put("cargoapproxdistance", distance);
				tripJsonObject.put("cargoaveragespeed", avgSpeed);
				tripJsonArray.put(tripJsonObject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}

		return tripJsonArray;
	}

	/** Updates Cargo Trip
	 * @param cargotripname
	 * @param cargotripcode
	 * @param cargoorgin
	 * @param transitions
	 * @param cargodestination
	 * @param cargototaltime
	 * @param cargoapproxdistance
	 * @param custmastcomboId
	 * @param systemId
	 * @param userId
	 * @return
	 */
	public int updateCargoTrip(String cargotripname,String cargotripcode, String cargoorgin,
			String transitions, String cargodestination, String cargototaltime,
			String cargoapproxdistance, String custmastcomboId, int systemId,
			int userId,String cargoaveragespeed) {
		Connection con = null;
		PreparedStatement pstmt = null;
		int updateResult=0;
		ResultSet rs = null;
		try
		{
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(CargomanagementStatements.UPDATE_CARGO_ROUTE_SKELETON);
			pstmt.setString(1,cargotripcode);
			pstmt.setInt(2,Integer.parseInt(cargoorgin));
			pstmt.setInt(3,Integer.parseInt(cargodestination));
			pstmt.setString(4,transitions);
			pstmt.setInt(5,Integer.parseInt(cargototaltime));
			pstmt.setInt(6,Integer.parseInt(cargoapproxdistance));
			pstmt.setInt(7,Integer.parseInt(cargoaveragespeed));
			pstmt.setString(8,cargotripname);
			pstmt.setInt(9,Integer.parseInt(custmastcomboId));
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

	/** Deletes Cargo Trip 
	 * @param custmastcomboId
	 * @param cargotripname
	 * @return
	 */
	public int deleteCargoTrip(String custmastcomboId, String cargotripname) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int deleteResult=0;
		try
		{
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(CargomanagementStatements.DELETE_CARGO_ROUTE_SKELETON);
			pstmt.setInt(1,Integer.parseInt(custmastcomboId));
			pstmt.setString(2,cargotripname);
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

	/** Returns Routes for Trip Allocation
	 * @param customerid
	 * @param systemId
	 * @return
	 */
	public JSONArray getRoutesforTripAllocation(String customerid, int systemId) {
		JSONArray routesJsonArray = new JSONArray();
		JSONObject routesJsonObject = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			routesJsonArray = new JSONArray();
			routesJsonObject = new JSONObject();
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(CargomanagementStatements.GET_TOTAL_ROUTES);
			pstmt.setInt(1, Integer.parseInt(customerid));
			pstmt.setInt(2,systemId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				routesJsonObject = new JSONObject();
				String routeID = rs.getString("ROUTE_ID");
				String routeName = rs.getString("TRIP_NAME");
				routesJsonObject.put("RouteID", routeID);
				routesJsonObject.put("RouteName", routeName);
				routesJsonArray.put(routesJsonObject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}

	
		return routesJsonArray;
	}

	/** Insert new Trip Allocation
	 * @param vehicleno
	 * @param routename
	 * @param starttime
	 * @param assetgroup
	 * @param systemId
	 * @param custID
	 * @param userID
	 * @return
	 */
	public String insertTripAllocation(String vehicleno, String routename,int systemId, String custID,int userID,int offSet) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int insertResult=0;
		String msg="";
		try
		{	
			con = DBConnection.getConnectionToDB("AMS");
			pstmt=con.prepareStatement(CargomanagementStatements.TRIP_ALREADY_EXIST);
			pstmt.setString(1,vehicleno);
			pstmt.setString(2,routename);
			pstmt.setString(3,custID);
		    rs=pstmt.executeQuery();
		    if(rs.next())
		    {
		    	msg="Trip Already Exist";
		    }
		    else
		    {
			pstmt = con.prepareStatement(CargomanagementStatements.INSERT_TRIP_ALLOCATION);
			pstmt.setString(1,vehicleno);
			pstmt.setString(2,routename);
			pstmt.setString(3,custID);
			pstmt.setInt(4,systemId);		
			pstmt.setInt(5,userID);
			insertResult=pstmt.executeUpdate();	
			if(insertResult>0)
			{
				msg="Trip Allocated Successfully";
			}
			else{
				msg="Error In Trip Allocation";
			}
		    }
		}
		catch(Exception e)
		{
		e.printStackTrace();	
		}
		finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return msg;
	}
	/**Return the List of Vehicles
	 * @param custId
	 * @param ltspId
	 * @return
	 */
	public JSONArray getVehicleDetails(String custId, String ltspId,int userId) {
		JSONArray jsonArray=null;
		JSONObject jsonObject=null;
		Connection conAms=null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		try {
		
			jsonArray=new JSONArray();
			jsonObject=new JSONObject();
			conAms=DBConnection.getConnectionToDB("AMS");
			pstmt=conAms.prepareStatement(CargomanagementStatements.GET_VEHICLES);
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
			System.out.println("Error in EmployeetrackingFunction:-getVehicleDetails "+e.toString());
		}finally{
			DBConnection.releaseConnectionToDB(conAms, pstmt, rs);
		}
		
		return jsonArray;
	}
	/** Returns Trip details for Grid
	 * @param customerid
	 * @param assetID
	 * @param systemID
	 * @return tripAllocationJsonArray
	 */
	public JSONArray getGridTripDetails(String customerid,int systemID,int userId,int offset,String zone) {
		JSONArray tripAllocationJsonArray = new JSONArray();
		JSONObject tripAllocationJsonObject = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			tripAllocationJsonArray = new JSONArray();
			tripAllocationJsonObject = new JSONObject();
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(CargomanagementStatements.GET_TRIP_ALLOCATION);
			pstmt.setInt(1, offset);
			pstmt.setInt(2, systemID);
			pstmt.setInt(3, Integer.parseInt(customerid));
			pstmt.setInt(4, userId);
			rs = pstmt.executeQuery();
			while (rs.next()) {			
				tripAllocationJsonObject = new JSONObject();
				String id = rs.getString("ID");
				String regNo = rs.getString("REGISTRATION_NO");
				String tripName = rs.getString("TRIP_NAME");
				String status = rs.getString("STATUS");	
				String tripId=rs.getString("ROUTE_ID");
				String tripcode=rs.getString("TRIP_CODE");
				Date assetAllocationDate=rs.getTimestamp("CREATED_TIME");
				String arrivalTime=rs.getString("ORIGIN_ARRIVAL");
				String departureTime=rs.getString("ORIGIN_DEPARTURE");
				if(arrivalTime!=null || arrivalTime!="" || arrivalTime!="0")
				{   long arrival=convertToMinutes(arrivalTime);
					arrivalTime=convertMinutesToHHMMFormat(arrival);
				}
				if(departureTime!=null || departureTime!="" || departureTime!="0")
				{
					long departure=convertToMinutes(departureTime);
					departureTime=convertMinutesToHHMMFormat(departure);
				}
				tripAllocationJsonObject.put("id", id);
				tripAllocationJsonObject.put("vehicleno", regNo);
				tripAllocationJsonObject.put("routename", tripName);
				tripAllocationJsonObject.put("routeid",tripId);
				tripAllocationJsonObject.put("status", status);	
				tripAllocationJsonObject.put("routecode",tripcode);
				tripAllocationJsonObject.put("arrivaltime", arrivalTime);
				tripAllocationJsonObject.put("departuretime", departureTime);
				if(assetAllocationDate!=null)
				{
				String createdTime=sdfyyyymmddhhmmss.format(assetAllocationDate);
				tripAllocationJsonObject.put("assetallocationdate", createdTime);
				}
				else
				{
				tripAllocationJsonObject.put("assetallocationdate", "");	
				}
				tripAllocationJsonArray.put(tripAllocationJsonObject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}

		return tripAllocationJsonArray;
	}

	/** Updates Trip Alloted
	 * @param vehicleno
	 * @param routename
	 * @param starttime
	 * @param assetgroup
	 * @param systemId
	 * @param custID
	 * @param userId
	 * @param id
	 * @return
	 */
	public int updateTripAllocation(String vehicleno, String routename,int systemId, String custID,
			int userId,String id,int offset,String status) {
		Connection con = null;
		PreparedStatement pstmt = null;
		PreparedStatement pstmt1 = null;
		PreparedStatement pstmt3 = null;
		ResultSet rs = null;
		int updateResult=0;
		String std_time=null;
		String std_distance=null;
		String TripStartTime=null;
		int maxtripid=0;
		String actArr=null;
		
		try
		{	
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(CargomanagementStatements.UPDATE_TRIP_ALLOCATION);
			pstmt.setString(1,vehicleno);
			pstmt.setInt(2,Integer.parseInt(routename));
			pstmt.setString(3,status);
			pstmt.setInt(4,systemId);
			pstmt.setString(5,custID);			
			pstmt.setString(6,id);
			updateResult=pstmt.executeUpdate();	
			
			
			if (updateResult>0 && status.equalsIgnoreCase("Inactive")) {
				
				pstmt1 = con.prepareStatement(CargomanagementStatements.CHECK_TRIP_OPENED);
				pstmt1.setInt(1,systemId);
				pstmt1.setInt(2,Integer.parseInt(custID));
				pstmt1.setString(3,vehicleno);
				pstmt1.setString(4,routename);
				rs = pstmt1.executeQuery();
				if(rs.next())
				{
					TripStartTime = rs.getString("START_TIME");
					maxtripid = rs.getInt("CUSTOMER_TRIP_ID");
					actArr=rs.getString("CUR_DATE");
					std_time=rs.getString("STANDARD_DURATION");
					std_distance=rs.getString("STANDARD_DISTANCE");
					
					String tripstatus = "Closed";
					Date curGMT=new Date();
					String sCurGMT=curGMT.toGMTString();
					SimpleDateFormat sdfmt=new SimpleDateFormat("dd MMM yyyy HH:mm:ss ");
					curGMT=sdfmt.parse(sCurGMT);
					VehicleActivity vi=new VehicleActivity(con, vehicleno, simpleDateFormatddMMYYYYDB.parse(TripStartTime), curGMT,offset, systemId, Integer.parseInt(custID),0);
					VehicleSummaryBean vsb = vi.getVehicleSummaryBean();

					String totalrunningTime = vsb.getTravelTimeFormated();
					String runningTimeHrs = gethoursfromstrformat(totalrunningTime);
					
					String idleTimeStr = vsb.getTotalIdleDurationFormated();
					String idleTimeHrs = gethoursfromstrformat(idleTimeStr);
					
					String stoppageTimeStr = vsb.getTotalStopDurationFormated();
					String stoppageTimeHrs = gethoursfromstrformat(stoppageTimeStr);
					
					double ConversionFactor = initializedistanceConversionFactor(systemId, con, vehicleno);
					double totaldistance = (vsb.getTotalDistanceTravelled()* ConversionFactor);
					totaldistance = Double.parseDouble(df.format(totaldistance));
					
					Double runningtime = Double.parseDouble(runningTimeHrs);
					double idletime = Double.parseDouble(idleTimeHrs);
					double stoppagetime = Double.parseDouble(stoppageTimeHrs);
					runningtime = Double.parseDouble(df.format(runningtime));
					
					int diffmin = cf.getTimeDiffrence(simpleDateFormatddMMYYYYDB.parse(TripStartTime),curGMT);
					double diffHHMM = Double.parseDouble(convertMinutesToHHMMFormat(diffmin));
					double avgspeed = (totaldistance/diffHHMM);
					
					int std_time_min = (int) (Double.parseDouble(std_time)*60);
					
					int delaytimeinmin = getDelayTime(std_time_min, Double.parseDouble(std_distance), diffmin, totaldistance);
					double delaytime = Double.parseDouble(convertMinutesToHHMMFormat(delaytimeinmin));

					pstmt3 = con.prepareStatement(CargomanagementStatements.CLOSE_TRIP_IN_CARGO_SUMMARY);
					pstmt3.setString(1, actArr);
					pstmt3.setDouble(2, idletime);
					pstmt3.setDouble(3, stoppagetime);
					pstmt3.setDouble(4, runningtime);
					pstmt3.setDouble(5, totaldistance);
					pstmt3.setString(6, tripstatus);
					pstmt3.setDouble(7, avgspeed);
					pstmt3.setString(8, actArr);
					pstmt3.setDouble(9, delaytime);
					pstmt3.setString(10, vehicleno);
					pstmt3.setString(11, TripStartTime);
					pstmt3.setInt(12, systemId);
					pstmt3.setInt(13, Integer.parseInt(custID));
					pstmt3.setString(14, routename);
					pstmt3.setInt(15, maxtripid);
					updateResult=pstmt3.executeUpdate();
				}
			
				
			}
			
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


	/** Deletes the Trip Allotted
	 * @param custID
	 * @param vehicleno
	 * @param routename
	 * @param endtime
	 * @param assetgroup
	 * @param systemID
	 * @return
	 */
	public int deleteAllottedTrip(String custID, String vehicleno,
			String routename, String endtime,int systemID,int offset) {
		Connection con = null;
		PreparedStatement pstmt=null;
		PreparedStatement pstmt1=null;
		PreparedStatement pstmt3=null;
		ResultSet rs = null;
		int updateResult=0;
		String std_time=null;
		String std_distance=null;
		String TripStartTime=null;
		int maxtripid=0;
		String actArr=null;
		try
		{	
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(CargomanagementStatements.CLOSE_TRIP_ALLOCATION);
			pstmt.setInt(1,offset);
			pstmt.setString(2,endtime);
			pstmt.setString(3,"Closed");
			pstmt.setString(4,vehicleno);
			pstmt.setString(5,routename);
			pstmt.setString(6,custID);
			updateResult=pstmt.executeUpdate();
			if (updateResult > 0) {
				
				pstmt1 = con.prepareStatement(CargomanagementStatements.CHECK_TRIP_OPENED);
				pstmt1.setInt(1,systemID);
				pstmt1.setInt(2,Integer.parseInt(custID));
				pstmt1.setString(3,vehicleno);
				pstmt1.setString(4,routename);
				rs = pstmt1.executeQuery();
				if(rs.next())
				{
					TripStartTime = rs.getString("START_TIME");
					maxtripid = rs.getInt("CUSTOMER_TRIP_ID");
					actArr=rs.getString("CUR_DATE");
					std_time=rs.getString("STANDARD_DURATION");
					std_distance=rs.getString("STANDARD_DISTANCE");
					
					String tripstatus = "Closed";
					Date curGMT=new Date();
					String sCurGMT=curGMT.toGMTString();
					SimpleDateFormat sdfmt=new SimpleDateFormat("dd MMM yyyy HH:mm:ss ");
					curGMT=sdfmt.parse(sCurGMT);
					VehicleActivity vi=new VehicleActivity(con, vehicleno, simpleDateFormatddMMYYYYDB.parse(TripStartTime), curGMT,offset, systemID, Integer.parseInt(custID),0);
					VehicleSummaryBean vsb = vi.getVehicleSummaryBean();

					String totalrunningTime = vsb.getTravelTimeFormated();
					String runningTimeHrs = gethoursfromstrformat(totalrunningTime);
					
					String idleTimeStr = vsb.getTotalIdleDurationFormated();
					String idleTimeHrs = gethoursfromstrformat(idleTimeStr);
					
					String stoppageTimeStr = vsb.getTotalStopDurationFormated();
					String stoppageTimeHrs = gethoursfromstrformat(stoppageTimeStr);
					
					double ConversionFactor = initializedistanceConversionFactor(systemID, con, vehicleno);
					double totaldistance = (vsb.getTotalDistanceTravelled()* ConversionFactor);
					totaldistance = Double.parseDouble(df.format(totaldistance));
					
					Double runningtime = Double.parseDouble(runningTimeHrs);
					double idletime = Double.parseDouble(idleTimeHrs);
					double stoppagetime = Double.parseDouble(stoppageTimeHrs);
					runningtime = Double.parseDouble(df.format(runningtime));
					
					int diffmin = cf.getTimeDiffrence(simpleDateFormatddMMYYYYDB.parse(TripStartTime),curGMT);
					double diffHHMM = Double.parseDouble(convertMinutesToHHMMFormat(diffmin));
					double avgspeed = (totaldistance/diffHHMM);
					
					int std_time_min = (int) (Double.parseDouble(std_time)*60);
					
					int delaytimeinmin = getDelayTime(std_time_min, Double.parseDouble(std_distance), diffmin, totaldistance);
					double delaytime = Double.parseDouble(convertMinutesToHHMMFormat(delaytimeinmin));

					pstmt3 = con.prepareStatement(CargomanagementStatements.CLOSE_TRIP_IN_CARGO_SUMMARY);
					pstmt3.setString(1, actArr);
					pstmt3.setDouble(2, idletime);
					pstmt3.setDouble(3, stoppagetime);
					pstmt3.setDouble(4, runningtime);
					pstmt3.setDouble(5, totaldistance);
					pstmt3.setString(6, tripstatus);
					pstmt3.setDouble(7, avgspeed);
					pstmt3.setString(8, actArr);
					pstmt3.setDouble(9, delaytime);
					pstmt3.setString(10, vehicleno);
					pstmt3.setString(11, TripStartTime);
					pstmt3.setInt(12, systemID);
					pstmt3.setInt(13, Integer.parseInt(custID));
					pstmt3.setString(14, routename);
					pstmt3.setInt(15, maxtripid);
					updateResult=pstmt3.executeUpdate();
				}
			}
		}
		catch(Exception e)
		{
		e.printStackTrace();	
		}
		finally {
			DBConnection.releaseConnectionToDB(con, pstmt, null);
			DBConnection.releaseConnectionToDB(null, pstmt1, rs);
			DBConnection.releaseConnectionToDB(null, pstmt3, null);
		}
		return updateResult;
	}

	/** Returns DashBoard details
	 * @param customerid
	 * @param systemId
	 * @param zone
	 * @return dashBoardJsonArray
	 */
	public JSONArray getDashBoardDetails(String customerid, int systemId,String zone,int offset) {
		JSONArray dashBoardJsonArray = new JSONArray();
		JSONObject dashBoardJsonObject = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int Tripcount=0;
		ArrayList<Integer> positionList=null;
		ArrayList<String> transitionLocations=null;
		try {
			dashBoardJsonArray = new JSONArray();
			dashBoardJsonObject = new JSONObject();
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(cfuncs.getLocationQuery(CargomanagementStatements.GET_DASHBOARD_DETAILS,zone));
			pstmt.setInt(1, systemId);
			pstmt.setString(2,customerid);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				dashBoardJsonObject = new JSONObject();
				positionList=new ArrayList<Integer>();
				transitionLocations=new ArrayList<String>();
				Tripcount++;
				String regNo=rs.getString("REGISTRATION_NO");
				Date starttime=rs.getTimestamp("START_TIME");
				Date tentativeendtime=rs.getTimestamp("PLANNED_ENDDATE");
				String tripName=rs.getString("TRIP_NAME");
				int orgin=rs.getInt("ORIGIN");
				String orginName=rs.getString("ORGIN_NAME");
				String transition=rs.getString("TRANSITION_POINT");
				int destination=rs.getInt("DESTINATION");
				String destinationName=rs.getString("DESTINATION_NAME");
				int distance=rs.getInt("DISTANCE");
				int transitioncount=0;
				if(transition!=null)
				{	
				StringTokenizer st = new StringTokenizer(transition,",");
				while (st.hasMoreElements()) {
					int transitionLocation=Integer.parseInt((String) st.nextElement());
					transitionLocations.add(getTransitionLocation(con,transitionLocation,systemId,customerid,zone));
					transitioncount++;
				}	
				}
				Vehicle vehicle = cfuncs.getLiveData(regNo);
				String vehicledetails=regNo+" Location : "+vehicle.getLocation()+" at  Speed : "+vehicle.getSpeed();
				positionList=getVehiclePositionDashBoard(con,regNo,starttime,tentativeendtime,orgin,transitioncount,transition,destination,systemId,customerid,offset,distance);
				int vehiclePosition=positionList.get(0);
				int reversePosition=positionList.get(1);
				dashBoardJsonObject.put("orgin", orginName);
				dashBoardJsonObject.put("destination", destinationName);
				dashBoardJsonObject.put("transitions",transitioncount);
				dashBoardJsonObject.put("vehicleposition",vehiclePosition);
				dashBoardJsonObject.put("totaldistance",distance);
				dashBoardJsonObject.put("tripname",tripName);
				dashBoardJsonObject.put("reversePosition",reversePosition);
				dashBoardJsonObject.put("transitionLocations",transitionLocations);
				dashBoardJsonObject.put("vehicledetails",vehicledetails);
				dashBoardJsonArray.put(dashBoardJsonObject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}

		return dashBoardJsonArray;
	}

	/** Returns the Vehicle Position for DashBoard
	 * @param regNo
	 * @param starttime
	 * @param orgin
	 * @param transitioncount
	 * @param transition
	 * @param destination
	 * @param systemId
	 * @return vehiclePosition
	 */
	public ArrayList<Integer> getVehiclePositionDashBoard(Connection con,String regNo,Date starttime,Date tentativeendtime,int orgin,int transitioncount,String transition,
			int destination,int systemId,String customerid,int offset,int distance)
	{
	int reversePosition=0;
	double vehiclePositiondouble=0.0;
	ArrayList<Integer> positionList=null;
	try {
		positionList=new ArrayList<Integer>();
		Date startdate=(Date)sdfFormatDate.parse(sdfFormatDate.format(starttime));
		Date enddate=(Date)sdfFormatDate.parse(sdfFormatDate.format(tentativeendtime));
		VehicleActivity vi = new VehicleActivity(con,regNo,startdate,enddate,offset, systemId, Integer.parseInt(customerid), 0);
		VehicleSummaryBean vsb = vi.getVehicleSummaryBean();
		double distanceTravelled=vsb.getTotalDistanceTravelled();
		if(distance>distanceTravelled)
		{
			vehiclePositiondouble=distanceTravelled*(500/(double)distance);
		}
		else if(distanceTravelled>(2*distance) )
		{
			vehiclePositiondouble=0;
			reversePosition=1;
		}
		else
		{
			vehiclePositiondouble=((2*distance)-distanceTravelled)*(500/(double)distance);
			reversePosition=1;
		}
		positionList.add((int)vehiclePositiondouble);
		positionList.add(reversePosition);
	} catch (Exception e) {
		e.printStackTrace();
	} 			
	return positionList;
	}

	/** To check whether trip name already exist or not 
	 * @param custmastcomboId
	 * @param cargotripnametxt
	 * @param systemId
	 * @return
	 */
	public boolean tripNamealreadyexist(String custmastcomboId,
			String cargotripnametxt, int systemId) {
    boolean tripname=false;
    Connection con = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	try {
		con = DBConnection.getConnectionToDB("AMS");
		pstmt = con.prepareStatement(CargomanagementStatements.GET_TRIP_NAME);
		pstmt.setString(1, custmastcomboId);
		pstmt.setInt(2,systemId);
		pstmt.setString(3,cargotripnametxt.trim());
		rs = pstmt.executeQuery();
		if (rs.next()) {
			tripname=true;				
		}
	} catch (Exception e) {
		e.printStackTrace();
	} finally {
		DBConnection.releaseConnectionToDB(con, pstmt, rs);
	}
    
		return tripname;
	}
	
 /** Returns the Location Name for the HUB ID 
 * @param transitionPoint
 * @param systemId
 * @param customerid
 * @param zone
 * @return
 */
public String getTransitionLocation(Connection con,int transitionPoint,int systemId,String customerid,String zone)
 {
 String transitionLocation="";
 PreparedStatement pstmt = null;
	ResultSet rs = null;
	try {
		pstmt = con.prepareStatement(cfuncs.getLocationQuery(CargomanagementStatements.GET_TRANSITION_LOCATION,zone));
		pstmt.setInt(1, transitionPoint);
		pstmt.setInt(2,systemId);
		pstmt.setString(3,customerid);
		rs = pstmt.executeQuery();
		if (rs.next()) {
			transitionLocation=rs.getString("NAME");				
		}
	} catch (Exception e) {
		e.printStackTrace();
	}
 return transitionLocation;
 }



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
		
		pstmt = con.prepareStatement(CargomanagementStatements.GET_GROUP_NAME_FOR_CLIENT);
    	pstmt.setInt(1, clientid);
		pstmt.setInt(2, systemid);
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



public JSONArray getAssetNumber(int systemid,
		int clientid, String groupid, int userId) {

	JSONArray jsonArray = new JSONArray();
	Connection con = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	String VehicleNo = "";
	boolean Status = false;
	int count=0;
	try {
		con = DBConnection.getConnectionToDB("AMS");
		if (groupid != null) {
			pstmt = con.prepareStatement(CargomanagementStatements.GET_VEHICLE_WHICH_IS_BELONG_GROUP);
			pstmt.setInt(1, clientid);
			pstmt.setInt(2, systemid);
			pstmt.setInt(3, userId);
			pstmt.setString(4, groupid);
		} else {
			pstmt = con.prepareStatement(CargomanagementStatements.GET_VEHICLE_FOR_CLIENT);
			pstmt.setInt(1, clientid);
			pstmt.setInt(2, systemid);
			pstmt.setInt(3, userId);
		}

		rs = pstmt.executeQuery();
		JSONObject obj1 = new JSONObject();
		while (rs.next()) {
			count++;
			obj1 = new JSONObject();
			obj1.put("slnoIndex", count);
			VehicleNo = rs.getString("REGISTRATION_NUMBER");
			obj1.put("assetnumber", VehicleNo);
			jsonArray.put(obj1);
		}
	} catch (Exception e) {
		e.printStackTrace();
	} finally {
		DBConnection.releaseConnectionToDB(con, pstmt, rs);
	}
	// System.out.println("jsonArray ---"+jsonArray);
	return jsonArray;
}


public ArrayList < Object > getPlantMovementReport(int systemId, int customerId,int userId, JSONArray firstGridData,String language,String startDate,String endDate,int offset,String zone) {

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
        headersList.add(cf.getLabelFromDB("Asset_Number", language));
        headersList.add(cf.getLabelFromDB("Route_Name", language));
        headersList.add(cf.getLabelFromDB("Start_Date", language));
        headersList.add(cf.getLabelFromDB("Start_Location", language));
        headersList.add(cf.getLabelFromDB("End_Date", language));
        headersList.add(cf.getLabelFromDB("End_Location", language));
        headersList.add(cf.getLabelFromDB("Running_Durations", language));
        headersList.add(cf.getLabelFromDB("Travel_Time", language));
        headersList.add(cf.getLabelFromDB("Travel_Distance", language));
   
        int count = 0;
        con = DBConnection.getConnectionToDB("AMS");
        String assetnos = "";
		for (int i = 0; i < firstGridData.length(); i++) {
			JSONObject obj = firstGridData.getJSONObject(i);
			assetnos = assetnos+",'"+obj.getString("assetnumber")+"'";
		}
		if (assetnos.length()>0) {
			assetnos = assetnos.substring(1,assetnos.length());
		}
		String query = CargomanagementStatements.GET_PLANT_MOVEMENT_DETAILS.replaceAll("#", zone);
        pstmt = con.prepareStatement(query.replaceAll("@", assetnos));
        pstmt.setInt(1, offset);
        pstmt.setInt(2, offset);
        pstmt.setInt(3,customerId);
        pstmt.setInt(4, systemId);
        pstmt.setInt(5, offset);
        pstmt.setString(6,startDate);
        pstmt.setInt(7, offset);
        pstmt.setString(8, endDate);
        
        rs = pstmt.executeQuery();
        while (rs.next()) {
            JsonObject = new JSONObject();
            ArrayList < Object > informationList = new ArrayList < Object > ();
            ReportHelper reporthelper = new ReportHelper();
            count++;
            
             float runningTime= rs.getFloat("RUNNING_TIME");
             float travelTime=rs.getFloat("TRAVEL_TIME");
             float distance=rs.getFloat("DISTANCE");
             
            informationList.add(count);
            
            JsonObject.put("slnoIndex1", count);

            JsonObject.put("assetNumberDataIndex", rs.getString("ASSET_NUMBER"));
            informationList.add(rs.getString("ASSET_NUMBER"));
            
            JsonObject.put("tripNameDataIndex", rs.getString("TRIP_NAME"));
            informationList.add(rs.getString("TRIP_NAME"));
            
            
            Date START_TIME = rs.getTimestamp("START_TIME");
            JsonObject.put("startTimeDataIndex", sdfyyyymmddhhmmss.format(START_TIME));
            informationList.add(sdfyyyymmddhhmmss.format(START_TIME));
            
            JsonObject.put("startLocationDataIndex", rs.getString("STARTLOCATION"));
            informationList.add(rs.getString("STARTLOCATION"));
            
            Date END_TIME = rs.getTimestamp("END_TIME");
            if(END_TIME!=null)
			{
            	JsonObject.put("endTimeDataIndex", sdfyyyymmddhhmmss.format(END_TIME));
                informationList.add(sdfyyyymmddhhmmss.format(END_TIME));
                
			}
			else
			{
				JsonObject.put("endTimeDataIndex","");
				informationList.add("");
				
			}
          
            JsonObject.put("endLocationDataIndex", rs.getString("ENDLOCATION"));
            informationList.add(rs.getString("ENDLOCATION"));
            
            JsonObject.put("runningDurationDataIndex", decformat.format(runningTime));
            informationList.add(decformat.format(runningTime));

            JsonObject.put("travelTimeDataIndex", decformat.format(travelTime));
            informationList.add(decformat.format(travelTime));
            
            JsonObject.put("travelDistanceDataIndex", decformat.format(distance));
            informationList.add(decformat.format(distance));
      
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
/**
 * coverts minutes(60) into HH:MM(01:00) format
 * @param minutes
 * @return
 */
public String convertMinutesToHHMMFormat(long minutes) 
{
	String duration="";
	
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
	
	duration = durationHrs + ":" + durationMins;
	
	return duration;
}
/**
 * coverts string hours(1.5) into minutes(110) format
 * @param hours
 * @return
 */
public long convertToMinutes(String hours)
{
	if(hours.equals(""))
	hours="0";
	String[] hourMin = hours.split("\\.");
	long hour = Long.parseLong(hourMin[0]);
    long hoursInMins = hour * 60;
    if(hours.trim().contains("."))
    {
    String s2=hourMin[1].trim();
    s2.trim();
    if(s2.length()==2){
    long mins = Long.parseLong(hourMin[1].trim());
    return hoursInMins + mins;
    }
    else{
    s2=s2.trim()+"0";
    long mins = Long.parseLong(s2.trim());
    return hoursInMins + mins;
    }
    }
    else return hoursInMins;
}

public JSONArray getExecutiveDashboardElementsCount(int systemId, int customerId, int userId,int isLtsp) {
	JSONArray jsonArray = null;
	JSONObject jsonObject = null;

	Connection connection = null;
	PreparedStatement pstmt = null,pstmt1=null,pstmt2=null;
	ResultSet rs = null;
	
	try {
		int totalAssetCount = 0;
		int noGpsCount = 0;
		int nonComm=0;
		int onSchedule = 0;
		int bsvAction = 0;
		int bsvUnder=0;
		
		jsonArray = new JSONArray();
		connection = DBConnection.getDashboardConnection("AMS");
				
		try {	if(customerId==0 || isLtsp == 0){
			pstmt = connection.prepareStatement(CargomanagementStatements.GET_TOTAL_ASSET_COUNT_FOR_LTSP,ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
			pstmt1 = connection.prepareStatement(CargomanagementStatements.GET_NO_GPS_COUNT_FOR_LTSP,ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
			pstmt2 = connection.prepareStatement(CargomanagementStatements.GET_NON_COMMUNICATING_FOR_LTSP,ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
		}else
		{
			pstmt = connection.prepareStatement(CargomanagementStatements.GET_TOTAL_ASSET_COUNT_FOR_CLIENT,ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
			pstmt1 = connection.prepareStatement(CargomanagementStatements.GET_NO_GPS_COUNT_FOR_CLIENT,ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
			pstmt2 = connection.prepareStatement(CargomanagementStatements.GET_NON_COMMUNICATING_FOR_CLIENT,ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
		}
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, customerId);
			pstmt.setInt(3, userId);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				totalAssetCount = rs.getInt("COUNT");
			}
			rs.close();
			pstmt1.setInt(1, customerId);
			pstmt1.setInt(2, systemId);
			pstmt1.setInt(3, userId);
			rs = pstmt1.executeQuery();
			if (rs.next()) {
				noGpsCount = rs.getInt("COUNT");
			}
			rs.close();			
			pstmt2.setInt(1, customerId);
			pstmt2.setInt(2, systemId);
			pstmt2.setInt(3, userId);
			rs = pstmt2.executeQuery();
			if (rs.next()) {
				nonComm = rs.getInt("NON_COMMUNICATING");
			}
						
			pstmt = connection.prepareStatement(CargomanagementStatements.GET_ON_SCHEDULE_COUNT);
			pstmt.setInt(1, customerId);
			pstmt.setInt(2, systemId);
			pstmt.setInt(3, userId);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				onSchedule = rs.getInt("SCHEDULE");
			}			
			rs.close();
			pstmt = connection.prepareStatement(CargomanagementStatements.GET_BSV_ACTION_REQUIRED_COUNT);
			pstmt.setInt(1, customerId);
			pstmt.setInt(2, systemId);
			pstmt.setInt(3, userId);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				bsvAction = rs.getInt("ACTION_REQUIRED");
			}			
			rs.close();
			pstmt = connection.prepareStatement(CargomanagementStatements.GET_BSV_UNDER_OBSERVATION_COUNT);
			pstmt.setInt(1, customerId);
			pstmt.setInt(2, systemId);
			pstmt.setInt(3, userId);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				bsvUnder = rs.getInt("UNDER_OBSERVATION");
			}
}
		catch (Exception e) {
			e.printStackTrace();
		}
		jsonObject = new JSONObject();
		jsonObject.put("totalAssetCount", totalAssetCount);
		jsonObject.put("noGpsCount", noGpsCount);
		jsonObject.put("nonComm", nonComm);
		jsonObject.put("onSchedule", onSchedule);
		jsonObject.put("bsvAction", bsvAction);
		jsonObject.put("bsvUnder", bsvUnder);
		jsonArray.put(jsonObject);
	}catch (Exception e) {
		e.printStackTrace();
	} finally {
		DBConnection.releaseConnectionToDB(connection, pstmt, rs);
		DBConnection.releaseConnectionToDB(null, pstmt1, null);
		DBConnection.releaseConnectionToDB(null, pstmt2, null);
	}
	return jsonArray;
}

public ArrayList < Object > getRouteSkeletonReport(int systemId, int customerId, int userId, String language,int offset, String zone) {

    JSONArray JsonArray = new JSONArray();
    JSONObject JsonObject = null;

    Connection con = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    PreparedStatement pstmt1 = null;
    ResultSet rs1 = null;
    DecimalFormat decformat = new DecimalFormat("#0.00");
    ArrayList < ReportHelper > reportsList = new ArrayList < ReportHelper > ();
    ArrayList < String > headersList = new ArrayList < String > ();
    ReportHelper finalreporthelper = new ReportHelper();
    ArrayList < Object > finlist = new ArrayList < Object > ();
    try {
        int count = 0;
        con = DBConnection.getConnectionToDB("AMS");
        pstmt = con.prepareStatement(CargomanagementStatements.GET_ROUTE_SKELETON_REPORT);
        pstmt.setInt(1, customerId);
        pstmt.setInt(2, systemId);
        rs = pstmt.executeQuery();

        while (rs.next()) {
            JsonObject = new JSONObject();
            ArrayList < Object > informationList = new ArrayList < Object > ();
            ReportHelper reporthelper = new ReportHelper();
            count++;

            informationList.add(count);
            JsonObject.put("slnoIndex", count);
            JsonObject.put("routeCodeId", rs.getString("ROUTE_ID"));
            informationList.add(rs.getString("ROUTE_ID"));
            
            JsonObject.put("routeCodeIndex", rs.getString("ROUTE_CODE"));
            informationList.add(rs.getString("ROUTE_CODE"));
            
            JsonObject.put("routeNameIndex", rs.getString("ROUTE_NAME"));
            informationList.add(rs.getString("ROUTE_NAME"));
            
            JsonObject.put("routeOriginIndex", rs.getString("ROUTE_ORIGIN"));
            informationList.add(rs.getString("ROUTE_ORIGIN"));
            
            JsonObject.put("routeDestinationIndex", rs.getString("ROUTE_DESTINATION"));
            informationList.add(rs.getString("ROUTE_DESTINATION"));
            
            JsonObject.put("totalTimeIndex", rs.getString("TOTAL_TIME"));
            informationList.add(rs.getString("TOTAL_TIME"));
            
            JsonObject.put("approximateDistanceIndex", rs.getString("APPROX_DISTANCE"));
            informationList.add(rs.getString("APPROX_DISTANCE"));
            
            
            float distance = Integer.parseInt(rs.getString("APPROX_DISTANCE"));
            float time = Integer.parseInt(rs.getString("TOTAL_TIME"));
            
            float averagespeed = distance/time;
            
            JsonObject.put("averageSpeedIndex", decformat.format(averagespeed));
            informationList.add (decformat.format(averagespeed));
            
            String arrival= rs.getString("ORIGIN_ARRIVAL");
            String depart= rs.getString("ORIGIN_DEPARTURE");
            
            if(arrival!=null || arrival!="" || arrival!="0")
			 { 
            long arrivals=convertToMinutes(arrival);
			 arrival=convertMinutesToHHMMFormat(arrivals);
			 }
			 if(depart!=null || depart!="" || depart!="0")
			 {
			 long departures=convertToMinutes(depart);
			 depart=convertMinutesToHHMMFormat(departures);
			 }
            
            JsonObject.put("originArrivalIndex", arrival);
            informationList.add(arrival);
            
            JsonObject.put("originDepartIndex", depart);
            informationList.add(depart);
            
            String darrival= rs.getString("DESTINATION_ARRIVAL");
            String ddepart= rs.getString("DESTINATION_DEPARTURE");
          
            
         
            if(ddepart.contains("") || ddepart.equals(null) || ddepart.equals(""))
            {
            	ddepart="0.0";
            }
            if(darrival!=null || darrival!="" || darrival!="0")
			 { long darrivals=convertToMinutes(darrival);
			 darrival=convertMinutesToHHMMFormat(darrivals);
			 }
			 if(ddepart!=null || ddepart!="" || ddepart!="0")
			 {
			 long ddeparture=convertToMinutes(ddepart);
			 ddepart=convertMinutesToHHMMFormat(ddeparture);
			 }
            
            JsonObject.put("destArrivalIndex",darrival );
            informationList.add(darrival);
            
            JsonObject.put("destDepartIndex",ddepart );
            informationList.add(ddepart);
            
            JsonObject.put("originidIndex", rs.getString("ORIGIN"));
            informationList.add(rs.getString("ORIGIN"));
            
            JsonObject.put("destidIndex", rs.getString("DESTINATION"));
            informationList.add(rs.getString("DESTINATION"));
            
          
            
            pstmt1 = con.prepareStatement(CargomanagementStatements.GET_ROUTE_TRANSITION_POINTS);
            pstmt1.setInt(1,rs.getInt("ROUTE_ID"));
            pstmt1.setInt(2, customerId);
            pstmt1.setInt(3, systemId);
            rs1 = pstmt1.executeQuery();
            while (rs1.next()) {
            	
            	String arrival1= rs1.getString("TRANSITION_POINT_ARRIVAL");
                String depart1= rs1.getString("TRANSITION_POINT_DEPARTURE");
                
                if(arrival1!=null || arrival1!="" || arrival1!="0")
    			 { long arrivals1=convertToMinutes(arrival1);
    			 arrival1=convertMinutesToHHMMFormat(arrivals1);
    			 }
    			 if(depart1!=null || depart1!="" || depart1!="0")
    			 {
    			 long departures1=convertToMinutes(depart1);
    			 depart1=convertMinutesToHHMMFormat(departures1);
    			 }
				if  (!(rs1.getString("TRANSITION_POINT")).equals("0"))
			{
				switch(rs1.getInt("SEQUENCE")){
				case 1 : 
					JsonObject.put("transPoint1Index", rs1.getString("TRANSITION_POINT"));
					JsonObject.put("transArrival1Index", arrival1);
					JsonObject.put("transDepart1Index", depart1);
					break;
				case 2 : 
					JsonObject.put("transPoint2Index", rs1.getString("TRANSITION_POINT"));
					JsonObject.put("transArrival2Index", arrival1);
					JsonObject.put("transDepart2Index", depart1);
					break;
				case 3 : 
					JsonObject.put("transPoint3Index", rs1.getString("TRANSITION_POINT"));
					JsonObject.put("transArrival3Index", arrival1);
					JsonObject.put("transDepart3Index", depart1);
					break;
				case 4 : 
					JsonObject.put("transPoint4Index", rs1.getString("TRANSITION_POINT"));
					JsonObject.put("transArrival4Index", arrival1);
					JsonObject.put("transDepart4Index", depart1);
					break;	
				case 5 : 
					JsonObject.put("transPoint5Index", rs1.getString("TRANSITION_POINT"));
					JsonObject.put("transArrival5Index", arrival1);
					JsonObject.put("transDepart5Index", depart1);
					break;
				case 6 : 
					JsonObject.put("transPoint6Index", rs1.getString("TRANSITION_POINT"));
					JsonObject.put("transArrival6Index", arrival1);
					JsonObject.put("transDepart6Index", depart1);
					break;	
				case 7 : 
					JsonObject.put("transPoint7Index", rs1.getString("TRANSITION_POINT"));
					JsonObject.put("transArrival7Index", arrival1);
					JsonObject.put("transDepart7Index", depart1);
					break;
				case 8 : 
					JsonObject.put("transPoint8Index", rs1.getString("TRANSITION_POINT"));
					JsonObject.put("transArrival8Index",arrival1);
					JsonObject.put("transDepart8Index", depart1);
					break;
				case 9 : 
					JsonObject.put("transPoint9Index", rs1.getString("TRANSITION_POINT"));
					JsonObject.put("transArrival9Index", arrival1);
					JsonObject.put("transDepart9Index", depart1);
					break;
				case 10 : 
					JsonObject.put("transPoint10Index", rs1.getString("TRANSITION_POINT"));
					JsonObject.put("transArrival10Index", arrival1);
					JsonObject.put("transDepart10Index", depart1);
					break;	
			}
				}
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

        DBConnection.releaseConnectionToDB(con, pstmt, rs);
        DBConnection.releaseConnectionToDB(null, pstmt1, rs1);
    }
    return finlist;
}

public int deletetranspoints(int inserresult, String custmastcomboId, int systemId ) {
	Connection con = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	int deleteResult=0;
	try
	{
		con = DBConnection.getConnectionToDB("AMS");
		pstmt = con.prepareStatement(CargomanagementStatements.DELETE_TRANSITION);
		pstmt.setInt(1,inserresult);
		pstmt.setInt(2,Integer.parseInt(custmastcomboId));
		pstmt.setInt(3,systemId);
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

public int insertroutetransitionpoints(int inserResult,String transpoints,String arrivals,String departures,int i, String customerId,int systemId) {
	Connection con = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	int insertResult=0;
	
	try
	{
		con = DBConnection.getConnectionToDB("AMS");
		pstmt = con.prepareStatement(CargomanagementStatements.INSERT_ROUTE_TRANSITION_POINTS);
		pstmt.setInt(1,inserResult);
		pstmt.setString(2,transpoints);
		pstmt.setString(3,arrivals);
		pstmt.setString(4,departures);
		pstmt.setInt(5,i);
		pstmt.setString(6,customerId);
		pstmt.setInt(7,systemId);
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
public int updateRouteSkeleton(String cargotripcode,String cargotripname, String cargoorgin,
		String originarrival , String origindepart,String cargodestination, String cargototaltime,
		String cargoapproxdistance, String custmastcomboId, int systemId,
		int userId,String cargoaveragespeed, String destarrival,String destdepart,int routeId) {
	Connection con = null;
	PreparedStatement pstmt = null;
	PreparedStatement pstmt1 = null;
	int updateResult=0;
	ResultSet rs = null;
	try
	{
		con = DBConnection.getConnectionToDB("AMS");
		pstmt = con.prepareStatement(CargomanagementStatements.UPDATE_ROUTE_SKELETON);
		pstmt.setString(1,(cargotripcode));
		pstmt.setString(2,(cargotripname));
		pstmt.setString(3,(cargoorgin));
		pstmt.setString(4,(cargodestination));
		pstmt.setString(5,(cargototaltime));
		pstmt.setString(6,(cargoapproxdistance));
		pstmt.setString(7,(cargoaveragespeed));
		pstmt.setString(8,(originarrival));
		pstmt.setString(9,(origindepart));
		pstmt.setString(10,(destarrival));
		pstmt.setString(11,(destdepart));
		pstmt.setInt(12,(systemId));
		pstmt.setString(13,(custmastcomboId));
		pstmt.setInt(14,(routeId));
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

public int insertrouteskeleton(String cargotripcode,String cargotripnametxt, String cargoorgin,
		String cargodestination, String cargototaltime,
		String cargoapproxdistance,String customerId,int systemId,int createdby,String cargoaveragespeed,String originarrival,String origindepart,
		String destarrival,String destdepart) {
	Connection con = null;
	PreparedStatement pstmt = null;
	PreparedStatement pstmt1 = null;
	ResultSet rs = null;
	ResultSet rs1=null;
	int insertResult=0;
	int id=0;
	DecimalFormat decformat = new DecimalFormat("#0.00");
	float distance = Integer.parseInt(cargoapproxdistance);
    float time = Integer.parseInt(cargototaltime);
    float averagespeed = distance/time;
	
	try
	{
		con = DBConnection.getConnectionToDB("AMS");
		pstmt = con.prepareStatement(CargomanagementStatements.INSERT_ROUTE_SKELETON,Statement.RETURN_GENERATED_KEYS);
		pstmt.setString(1,(cargotripcode));
		pstmt.setString(2,(cargotripnametxt));
		pstmt.setString(3,(cargoorgin));
		pstmt.setString(4,(cargodestination));
		pstmt.setString(5,(cargototaltime));
		pstmt.setString(6,(cargoapproxdistance));
		pstmt.setString(7,(decformat.format(averagespeed)));
		pstmt.setString(8,(originarrival));
		pstmt.setString(9,(origindepart));
		pstmt.setString(10,(destarrival));
		pstmt.setString(11,(destdepart));
		pstmt.setString(12,(customerId));
		pstmt.setInt(13,systemId);
		pstmt.setInt(14,createdby);
		insertResult=pstmt.executeUpdate();
		rs1=pstmt.getGeneratedKeys();
		if(rs1.next())
		{
		id=rs1.getInt(1);
		}
		
		
		//insertResult=pstmt.executeUpdate();	
	}
	catch(Exception e)
	{
	e.printStackTrace();	
	}
	finally {
		DBConnection.releaseConnectionToDB(con, pstmt, rs);
	}
	return id;
}


public String getlasthubname(String vehicleno,int systemid)
{
	Connection con = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	String hubName="";
	try 
	{
		con = DBConnection.getConnectionToDB("AMS");
		pstmt = con.prepareStatement(CargomanagementStatements.GET_LAST_HUBNAME);
    	pstmt.setString(1,vehicleno);
		pstmt.setInt(2,systemid);
		rs = pstmt.executeQuery();
		
		if (rs.next()) 
		{
			hubName=rs.getString("LAST_HUB_NAME");
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
	return hubName;
}

public ArrayList < Object > getExecutiveDashBoardDetails(int customerId, int systemId, int userId, int offset, String type,int isLtsp) {
	JSONArray jsonArray = null;
	JSONObject jsonObject = null;

	Connection connection = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	int count=0;
	ArrayList<ReportHelper> reportsList = new ArrayList<ReportHelper>();
	ArrayList<String> headersList = new ArrayList<String>();
	ReportHelper finalreporthelper = new ReportHelper();
    ArrayList < Object > finlist = new ArrayList < Object > ();
	
	try {
		
		String VehicleNo="";
		String RouteName="";
		String RouteCode="";
		String LastHubName="";
		String CurrentLocation="";
		String AverageSpeed="";
		String arrival="";
		String idleTime="";
		String delayTime="";
		String idleTimehhmm="";
		String delayTimehhmm="";
		jsonObject= new JSONObject();
		jsonArray = new JSONArray();
		SimpleDateFormat ddmmyyyy = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
		SimpleDateFormat yyyymmdd = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
				
		try {
			
			connection = DBConnection.getConnectionToDB("AMS");
			count++;
			
			if(type.equals("onschedule"))
			{
				headersList.add("SLNO");
				headersList.add("Vehicle No");
				headersList.add("Route Name");
				headersList.add("Route Code");
				headersList.add("Trip Start Time");
				headersList.add("Last Hub Name");
				headersList.add("Average Speed");
				headersList.add("Scheduled Arrival(Date,Time)");
				headersList.add("From Source Location");
				headersList.add("To Destination");
				headersList.add("Current Location");
				headersList.add("Distance Travelled(Kms)");
				headersList.add("Delay Time(HH:MM)");
				headersList.add("Idle Time(HH:MM)");
				headersList.add("Last Communicated(Date,Time)");
				headersList.add("Status");
				
			pstmt = connection.prepareStatement(CargomanagementStatements.GET_ON_SCHEDULE_DETAILS);
			pstmt.setInt(1,offset);
			pstmt.setInt(2,offset);
			pstmt.setInt(3,offset);
			pstmt.setInt(4,customerId);
			pstmt.setInt(5,systemId);
			pstmt.setInt(6, userId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				ArrayList<Object> informationList = new ArrayList<Object>();
				ReportHelper reporthelper = new ReportHelper();
	            count++;
	            
	            jsonObject= new JSONObject();
				VehicleNo=rs.getString("VEHICLE_NUMBER");
				RouteName=rs.getString("ROUTE_NAME");
				RouteCode=rs.getString("ROUTE_CODE");
				CurrentLocation=rs.getString("CURRENT_LOCATION");
				AverageSpeed=rs.getString("AVERAGE_SPEED");
				idleTime=rs.getString("IDLE_TIME").replace(".", ":");
				delayTime=rs.getString("DELAY_TIME").replace(".", ":");
				idleTimehhmm= getHHMMFormat(idleTime);
				delayTimehhmm=getHHMMFormat(delayTime);
					
				informationList.add(count);
				jsonObject.put("slno", count);

				informationList.add(VehicleNo);
				jsonObject.put("VehicleNo", VehicleNo);
				
				informationList.add(RouteName);
				jsonObject.put("RouteName", RouteName);

				informationList.add(RouteCode);
				jsonObject.put("RouteCode", RouteCode);
				
				if(rs.getString("TRIP_START_TIME")==""|| rs.getString("TRIP_START_TIME").contains("1900"))
				{
				informationList.add("");
				jsonObject.put("TripStartTime","");	
				}
				else
				{	
					informationList.add(ddmmyyyy.format(yyyymmdd.parse(rs.getString("TRIP_START_TIME"))));
					jsonObject.put("TripStartTime",ddmmyyyy.format(yyyymmdd.parse(rs.getString("TRIP_START_TIME"))));
				}
				
				informationList.add(getlasthubname(VehicleNo,systemId));
				jsonObject.put("LastHubName",getlasthubname(VehicleNo,systemId));
				
				informationList.add(AverageSpeed);
				jsonObject.put("AverageSpeed", AverageSpeed);
				
				if(rs.getString("SCHEDULED_ARRIVAL")==""|| rs.getString("SCHEDULED_ARRIVAL").contains("1900"))
				{
				informationList.add("");
				jsonObject.put("ScheduledArrivalDateTime","");	
				}
				else
				{	
				informationList.add(ddmmyyyy.format(yyyymmdd.parse(rs.getString("SCHEDULED_ARRIVAL"))));
				jsonObject.put("ScheduledArrivalDateTime",ddmmyyyy.format(yyyymmdd.parse(rs.getString("SCHEDULED_ARRIVAL"))));
				}
				
				informationList.add(rs.getString("FROM_PLACE"));
				jsonObject.put("fromSourceLocation", rs.getString("FROM_PLACE"));
				
				informationList.add(rs.getString("TO_DESTINATION"));
				jsonObject.put("toDestionation", rs.getString("TO_DESTINATION"));
				
				informationList.add(CurrentLocation);
				jsonObject.put("CurrentLocation", CurrentLocation);
				
				informationList.add(rs.getString("DISTANCE_TRAVELLED"));
				jsonObject.put("distanceTravelled", rs.getString("DISTANCE_TRAVELLED"));
				
				informationList.add(delayTimehhmm);
				jsonObject.put("delayTime", delayTimehhmm);
				
				informationList.add(idleTimehhmm);
				jsonObject.put("idleTime", idleTimehhmm);
				
				informationList.add(ddmmyyyy.format(yyyymmdd.parse(rs.getString("LAST_COMMUNICATED"))));
				jsonObject.put("LastCommunicatedDateTime",ddmmyyyy.format(yyyymmdd.parse(rs.getString("LAST_COMMUNICATED"))));
				
				informationList.add("");
				jsonObject.put("status", "");
				
				jsonArray.put(jsonObject);
				reporthelper.setInformationList(informationList);
				reportsList.add(reporthelper);
			}
			finalreporthelper.setReportsList(reportsList);
			finalreporthelper.setHeadersList(headersList);
			finlist.add(jsonArray);
			finlist.add(finalreporthelper);
			rs.close();
			}
			
			else if(type.equals("bsvactionreq"))
			{
				headersList.add("SLNO");
				headersList.add("Vehicle No");
				headersList.add("Route Name");
				headersList.add("Route Code");
				headersList.add("Trip Start Time");
				headersList.add("Last Hub Name");
				headersList.add("Average Speed");
				headersList.add("Scheduled Arrival(Date,Time)");
				headersList.add("From Source Location");
				headersList.add("To Destination");
				headersList.add("Current Location");
				headersList.add("Distance Travelled(Kms)");
				headersList.add("Delay Time(HH:MM)");
				headersList.add("Idle Time(HH:MM)");
				headersList.add("Last Communicated(Date,Time)");
				headersList.add("Status");
				
			pstmt = connection.prepareStatement(CargomanagementStatements.GET_BSV_ACTION_REQUIRED_DETAILS);
			pstmt.setInt(1,offset);
			pstmt.setInt(2,offset);
			pstmt.setInt(3,offset);
			pstmt.setInt(4,customerId);
			pstmt.setInt(5,systemId);
			pstmt.setInt(6, userId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				ArrayList<Object> informationList = new ArrayList<Object>();
				ReportHelper reporthelper = new ReportHelper();
	            count++;
	            
	            jsonObject= new JSONObject();
				VehicleNo=rs.getString("VEHICLE_NUMBER");
				RouteName=rs.getString("ROUTE_NAME");
				RouteCode=rs.getString("ROUTE_CODE");
				CurrentLocation=rs.getString("CURRENT_LOCATION");
				AverageSpeed=rs.getString("AVERAGE_SPEED");
				idleTime=rs.getString("IDLE_TIME").replace(".", ":");
				delayTime=rs.getString("DELAY_TIME").replace(".", ":");
				idleTimehhmm= getHHMMFormat(idleTime);
				delayTimehhmm=getHHMMFormat(delayTime);
				
				informationList.add(count);
				jsonObject.put("slno", count);

				informationList.add(VehicleNo);
				jsonObject.put("VehicleNo", VehicleNo);
				
				informationList.add(RouteName);
				jsonObject.put("RouteName", RouteName);

				informationList.add(RouteCode);
				jsonObject.put("RouteCode", RouteCode);
				
				if(rs.getString("TRIP_START_TIME")==""|| rs.getString("TRIP_START_TIME").contains("1900"))
				{
				informationList.add("");
				jsonObject.put("TripStartTime","");	
				}
				else
				{	
					informationList.add(ddmmyyyy.format(yyyymmdd.parse(rs.getString("TRIP_START_TIME"))));
					jsonObject.put("TripStartTime",ddmmyyyy.format(yyyymmdd.parse(rs.getString("TRIP_START_TIME"))));
				}
				
				informationList.add(getlasthubname(VehicleNo,systemId));
				jsonObject.put("LastHubName",getlasthubname(VehicleNo,systemId));
				
				informationList.add(AverageSpeed);
				jsonObject.put("AverageSpeed", AverageSpeed);
				
			    if(rs.getString("SCHEDULED_ARRIVAL")==""|| rs.getString("SCHEDULED_ARRIVAL").contains("1900"))
				{
				informationList.add("");
				jsonObject.put("ScheduledArrivalDateTime","");	
				}
				else
				{	
				informationList.add(ddmmyyyy.format(yyyymmdd.parse(rs.getString("SCHEDULED_ARRIVAL"))));
				jsonObject.put("ScheduledArrivalDateTime",ddmmyyyy.format(yyyymmdd.parse(rs.getString("SCHEDULED_ARRIVAL"))));
				}
				
				informationList.add(rs.getString("FROM_PLACE"));
				jsonObject.put("fromSourceLocation", rs.getString("FROM_PLACE"));
				
				informationList.add(rs.getString("TO_DESTINATION"));
				jsonObject.put("toDestionation", rs.getString("TO_DESTINATION"));
				
				informationList.add(CurrentLocation);
				jsonObject.put("CurrentLocation", CurrentLocation);
				
				informationList.add(rs.getString("DISTANCE_TRAVELLED"));
				jsonObject.put("distanceTravelled", rs.getString("DISTANCE_TRAVELLED"));
				
				informationList.add(delayTimehhmm);
				jsonObject.put("delayTime", delayTimehhmm);
				
				informationList.add(idleTimehhmm);
				jsonObject.put("idleTime",idleTimehhmm );
				
				informationList.add(ddmmyyyy.format(yyyymmdd.parse(rs.getString("LAST_COMMUNICATED"))));
				jsonObject.put("LastCommunicatedDateTime",ddmmyyyy.format(yyyymmdd.parse(rs.getString("LAST_COMMUNICATED"))));
				
				informationList.add("");
				jsonObject.put("status", "");
				
				jsonArray.put(jsonObject);
				reporthelper.setInformationList(informationList);
				reportsList.add(reporthelper);
			}
			finalreporthelper.setReportsList(reportsList);
			finalreporthelper.setHeadersList(headersList);
			finlist.add(jsonArray);
			finlist.add(finalreporthelper);
			rs.close();
			}
			
			else if(type.equals("bsvunderobv"))
			{
				headersList.add("SLNO");
				headersList.add("Vehicle No");
				headersList.add("Route Name");
				headersList.add("Route Code");
				headersList.add("Trip Start Time");
				headersList.add("Last Hub Name");
				headersList.add("Average Speed");
				headersList.add("Scheduled Arrival(Date,Time)");
				headersList.add("From Source Location");
				headersList.add("To Destination");
				headersList.add("Current Location");
				headersList.add("Distance Travelled(Kms)");
				headersList.add("Delay Time(HH:MM)");
				headersList.add("Idle Time(HH:MM)");
				headersList.add("Last Communicated(Date,Time)");
				headersList.add("Status");
				
			pstmt = connection.prepareStatement(CargomanagementStatements.GET_BSV_UNDER_OBSERVATION_DETAILS);
			pstmt.setInt(1,offset);
			pstmt.setInt(2,offset);
			pstmt.setInt(3,offset);
			pstmt.setInt(4,customerId);
			pstmt.setInt(5,systemId);
			pstmt.setInt(6, userId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				ArrayList<Object> informationList = new ArrayList<Object>();
				ReportHelper reporthelper = new ReportHelper();
	            count++;
	            
	            jsonObject= new JSONObject();
				VehicleNo=rs.getString("VEHICLE_NUMBER");
				RouteName=rs.getString("ROUTE_NAME");
				RouteCode=rs.getString("ROUTE_CODE");
				CurrentLocation=rs.getString("CURRENT_LOCATION");
				AverageSpeed=rs.getString("AVERAGE_SPEED");
				idleTime=rs.getString("IDLE_TIME").replace(".", ":");
				delayTime=rs.getString("DELAY_TIME").replace(".", ":");
				idleTimehhmm= getHHMMFormat(idleTime);
				delayTimehhmm=getHHMMFormat(delayTime);
				
				informationList.add(count);
				jsonObject.put("slno", count);

				informationList.add(VehicleNo);
				jsonObject.put("VehicleNo", VehicleNo);
				
				informationList.add(RouteName);
				jsonObject.put("RouteName", RouteName);

				informationList.add(RouteCode);
				jsonObject.put("RouteCode", RouteCode);
				
				if(rs.getString("TRIP_START_TIME")==""|| rs.getString("TRIP_START_TIME").contains("1900"))
				{
				informationList.add("");
				jsonObject.put("TripStartTime","");	
				}
				else
				{	
				informationList.add(ddmmyyyy.format(yyyymmdd.parse(rs.getString("TRIP_START_TIME"))));
				jsonObject.put("TripStartTime",ddmmyyyy.format(yyyymmdd.parse(rs.getString("TRIP_START_TIME"))));
				}
				
				informationList.add(getlasthubname(VehicleNo,systemId));
				jsonObject.put("LastHubName",getlasthubname(VehicleNo,systemId));
				
				informationList.add(AverageSpeed);
				jsonObject.put("AverageSpeed", AverageSpeed);
				
				if(rs.getString("SCHEDULED_ARRIVAL")==""|| rs.getString("SCHEDULED_ARRIVAL").contains("1900"))
				{
				informationList.add("");
				jsonObject.put("ScheduledArrivalDateTime","");	
				}
				else
				{	
				informationList.add(ddmmyyyy.format(yyyymmdd.parse(rs.getString("SCHEDULED_ARRIVAL"))));
				jsonObject.put("ScheduledArrivalDateTime",ddmmyyyy.format(yyyymmdd.parse(rs.getString("SCHEDULED_ARRIVAL"))));
				}
				
				informationList.add(rs.getString("FROM_PLACE"));
				jsonObject.put("fromSourceLocation", rs.getString("FROM_PLACE"));
				
				informationList.add(rs.getString("TO_DESTINATION"));
				jsonObject.put("toDestionation", rs.getString("TO_DESTINATION"));
				
				informationList.add(CurrentLocation);
				jsonObject.put("CurrentLocation", CurrentLocation);
				
				informationList.add(rs.getString("DISTANCE_TRAVELLED"));
				jsonObject.put("distanceTravelled", rs.getString("DISTANCE_TRAVELLED"));
				
				informationList.add(delayTimehhmm);
				jsonObject.put("delayTime", delayTimehhmm);
				
				informationList.add(idleTimehhmm);
				jsonObject.put("idleTime", idleTimehhmm);
				
				informationList.add(ddmmyyyy.format(yyyymmdd.parse(rs.getString("LAST_COMMUNICATED"))));
				jsonObject.put("LastCommunicatedDateTime",ddmmyyyy.format(yyyymmdd.parse(rs.getString("LAST_COMMUNICATED"))));
				
				informationList.add("");
				jsonObject.put("status", "");
				
				jsonArray.put(jsonObject);
				reporthelper.setInformationList(informationList);
				reportsList.add(reporthelper);
			}
			finalreporthelper.setReportsList(reportsList);
			finalreporthelper.setHeadersList(headersList);
			finlist.add(jsonArray);
			finlist.add(finalreporthelper);
			rs.close();
			}
			else if(type.equals("totalasset")){
				
				headersList.add("SLNO");
				headersList.add("Vehicle No");
				headersList.add("Route Name");
				headersList.add("Route Code");
				headersList.add("Trip Start Time");
				headersList.add("Last Hub Name");
				headersList.add("Average Speed");
				headersList.add("Scheduled Arrival(Date,Time)");
				headersList.add("From Source Location");
				headersList.add("To Destination");
				headersList.add("Current Location");
				headersList.add("Distance Travelled(Kms)");
				headersList.add("Delay Time(HH:MM)");
				headersList.add("Idle Time(HH:MM)");
				headersList.add("Last Communicated(Date,Time)");
				headersList.add("Status");
				
				
					if(customerId==0 || isLtsp == 0){					
						pstmt = connection.prepareStatement(CargomanagementStatements.GET_TOTAL_ASSET_DETAILS_FOR_LTSP);			
					}
					else{					
						pstmt = connection.prepareStatement(CargomanagementStatements.GET_TOTAL_ASSET_DETAILS_FOR_CLIENT);
					}
			pstmt.setInt(1,offset);
			pstmt.setInt(2,offset);
			pstmt.setInt(3,offset);
			pstmt.setInt(4,systemId);
			pstmt.setInt(5,customerId);
			pstmt.setInt(6,userId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				ArrayList<Object> informationList = new ArrayList<Object>();
				ReportHelper reporthelper = new ReportHelper();
	            count++;
	            
				jsonObject= new JSONObject();
				VehicleNo=rs.getString("VEHICLE_NUMBER");
				RouteName=rs.getString("ROUTE_NAME");
				RouteCode=rs.getString("ROUTE_CODE");
				CurrentLocation=rs.getString("CURRENT_LOCATION");
				AverageSpeed=rs.getString("AVERAGE_SPEED");
				idleTime=rs.getString("IDLE_TIME").replace(".", ":");
				delayTime=rs.getString("DELAY_TIME").replace(".", ":");
				idleTimehhmm= getHHMMFormat(idleTime);
				delayTimehhmm=getHHMMFormat(delayTime);
				
				informationList.add(count);
				jsonObject.put("slno", count);

				informationList.add(VehicleNo);
				jsonObject.put("VehicleNo", VehicleNo);
				
				informationList.add(RouteName);
				jsonObject.put("RouteName", RouteName);

				informationList.add(RouteCode);
				jsonObject.put("RouteCode", RouteCode);
			
				if(rs.getString("TRIP_START_TIME")==""|| rs.getString("TRIP_START_TIME").contains("1900"))
				{
				informationList.add("");
				jsonObject.put("TripStartTime","");	
				}
				else
				{	
				informationList.add(ddmmyyyy.format(yyyymmdd.parse(rs.getString("TRIP_START_TIME"))));
				jsonObject.put("TripStartTime",ddmmyyyy.format(yyyymmdd.parse(rs.getString("TRIP_START_TIME"))));
				}
				
				informationList.add("");
				jsonObject.put("LastHubName","");
				
				informationList.add(AverageSpeed);
				jsonObject.put("AverageSpeed", AverageSpeed);
				
				if(rs.getString("SCHEDULED_ARRIVAL")==""|| rs.getString("SCHEDULED_ARRIVAL").contains("1900"))
				{
				informationList.add("");
				jsonObject.put("ScheduledArrivalDateTime","");	
				}
				else
				{	
				informationList.add(ddmmyyyy.format(yyyymmdd.parse(rs.getString("SCHEDULED_ARRIVAL"))));
				jsonObject.put("ScheduledArrivalDateTime",ddmmyyyy.format(yyyymmdd.parse(rs.getString("SCHEDULED_ARRIVAL"))));
				}
				
				informationList.add(rs.getString("FROM_PLACE"));
				jsonObject.put("fromSourceLocation", rs.getString("FROM_PLACE"));
				
				informationList.add(rs.getString("TO_DESTINATION"));
				jsonObject.put("toDestionation", rs.getString("TO_DESTINATION"));
				
				informationList.add(CurrentLocation);
				jsonObject.put("CurrentLocation", CurrentLocation);
				
				informationList.add(rs.getString("DISTANCE_TRAVELLED"));
				jsonObject.put("distanceTravelled",rs.getString("DISTANCE_TRAVELLED"));
				
				informationList.add(delayTimehhmm);
				jsonObject.put("delayTime", delayTimehhmm);
				
				informationList.add(idleTimehhmm);
				jsonObject.put("idleTime", idleTimehhmm);
				
				if(rs.getString("LAST_COMMUNICATED")==""|| rs.getString("LAST_COMMUNICATED").contains("1900"))
				{
				informationList.add("");
				jsonObject.put("LastCommunicatedDateTime","");	
				}
				else
				{	
				informationList.add(ddmmyyyy.format(yyyymmdd.parse(rs.getString("LAST_COMMUNICATED"))));
				jsonObject.put("LastCommunicatedDateTime",ddmmyyyy.format(yyyymmdd.parse(rs.getString("LAST_COMMUNICATED"))));
				}
                  
				informationList.add(rs.getString("STATUS"));
				jsonObject.put("status", rs.getString("STATUS"));
				
				jsonArray.put(jsonObject);
				reporthelper.setInformationList(informationList);
				reportsList.add(reporthelper);
			}
			finalreporthelper.setReportsList(reportsList);
			finalreporthelper.setHeadersList(headersList);
			finlist.add(jsonArray);
			finlist.add(finalreporthelper);
			rs.close();
			}
			
			
			else if(type.equals("noncommunicating")){
				
				headersList.add("SLNO");
				headersList.add("Vehicle No");
				headersList.add("Route Name");
				headersList.add("Route Code");
				headersList.add("Trip Start Time");
				headersList.add("Last Hub Name");
				headersList.add("Average Speed");
				headersList.add("Scheduled Arrival(Date,Time)");
				headersList.add("From Source Location");
				headersList.add("To Destination");
				headersList.add("Current Location");
				headersList.add("Distance Travelled(Kms)");
				headersList.add("Delay Time(HH:MM)");
				headersList.add("Idle Time(HH:MM)");
				headersList.add("Last Communicated(Date,Time)");
				headersList.add("Status");
				
			if(customerId==0 || isLtsp==0){					
				pstmt = connection.prepareStatement(CargomanagementStatements.GET_NON_COMMUNICATING_DETAILS_FOR_LTSP);	
			}else{					
				pstmt = connection.prepareStatement(CargomanagementStatements.GET_NON_COMMUNICATING_DETAILS_FOR_CLIENT);	
			}		
			
			pstmt.setInt(1,offset);
			pstmt.setInt(2,offset);
			pstmt.setInt(3,offset);
			pstmt.setInt(4,systemId);
			pstmt.setInt(5,customerId);
			pstmt.setInt(6,userId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				ArrayList<Object> informationList = new ArrayList<Object>();
				ReportHelper reporthelper = new ReportHelper();
	            count++;
	            
				jsonObject= new JSONObject();
				VehicleNo=rs.getString("VEHICLE_NUMBER");
				RouteName=rs.getString("ROUTE_NAME");
				RouteCode=rs.getString("ROUTE_CODE");
				CurrentLocation=rs.getString("CURRENT_LOCATION");
				AverageSpeed=rs.getString("AVERAGE_SPEED");
				idleTime=rs.getString("IDLE_TIME").replace(".", ":");
				delayTime=rs.getString("DELAY_TIME").replace(".", ":");
				idleTimehhmm= getHHMMFormat(idleTime);
				delayTimehhmm=getHHMMFormat(delayTime);
				
				informationList.add(count);
				jsonObject.put("slno", count);

				informationList.add(VehicleNo);
				jsonObject.put("VehicleNo", VehicleNo);
				
				informationList.add(RouteName);
				jsonObject.put("RouteName", RouteName);

				informationList.add(RouteCode);
				jsonObject.put("RouteCode", RouteCode);
				
				if(rs.getString("TRIP_START_TIME")==""|| rs.getString("TRIP_START_TIME").contains("1900"))
				{
				informationList.add("");
				jsonObject.put("TripStartTime","");	
				}
				else
				{	
				informationList.add(ddmmyyyy.format(yyyymmdd.parse(rs.getString("TRIP_START_TIME"))));
				jsonObject.put("TripStartTime",ddmmyyyy.format(yyyymmdd.parse(rs.getString("TRIP_START_TIME"))));
				}
				
				informationList.add("");
				jsonObject.put("LastHubName","");
				
				informationList.add(AverageSpeed);
				jsonObject.put("AverageSpeed", AverageSpeed);
				
				if(rs.getString("SCHEDULED_ARRIVAL")==""|| rs.getString("SCHEDULED_ARRIVAL").contains("1900"))
				{
				informationList.add("");
				jsonObject.put("ScheduledArrivalDateTime","");	
				}
				else
				{	
				informationList.add(ddmmyyyy.format(yyyymmdd.parse(rs.getString("SCHEDULED_ARRIVAL"))));
				jsonObject.put("ScheduledArrivalDateTime",ddmmyyyy.format(yyyymmdd.parse(rs.getString("SCHEDULED_ARRIVAL"))));
				}
				
				informationList.add(rs.getString("FROM_PLACE"));
				jsonObject.put("fromSourceLocation", rs.getString("FROM_PLACE"));
				
				informationList.add(rs.getString("TO_DESTINATION"));
				jsonObject.put("toDestionation", rs.getString("TO_DESTINATION"));
				
				informationList.add(CurrentLocation);
				jsonObject.put("CurrentLocation", CurrentLocation);
				
				informationList.add(rs.getString("DISTANCE_TRAVELLED"));
				jsonObject.put("distanceTravelled", rs.getString("DISTANCE_TRAVELLED"));
				
				informationList.add(delayTimehhmm);
				jsonObject.put("delayTime", delayTimehhmm);
				
				informationList.add(idleTimehhmm);
				jsonObject.put("idleTime", idleTimehhmm);
				
				if(rs.getString("LAST_COMMUNICATED")==""|| rs.getString("LAST_COMMUNICATED").contains("1900"))
				{
				informationList.add("");
				jsonObject.put("LastCommunicatedDateTime","");	
				}
				else
				{	
				informationList.add(ddmmyyyy.format(yyyymmdd.parse(rs.getString("LAST_COMMUNICATED"))));
				jsonObject.put("LastCommunicatedDateTime",ddmmyyyy.format(yyyymmdd.parse(rs.getString("LAST_COMMUNICATED"))));
				}

				informationList.add("");
				jsonObject.put("status", "");
				
				jsonArray.put(jsonObject);
				reporthelper.setInformationList(informationList);
				reportsList.add(reporthelper);
			}
			finalreporthelper.setReportsList(reportsList);
			finalreporthelper.setHeadersList(headersList);
			finlist.add(jsonArray);
			finlist.add(finalreporthelper);
			rs.close();
			}
			
			else if(type.equals("nogps")){
				
				headersList.add("SLNO");
				headersList.add("Vehicle No");
				headersList.add("Route Name");
				headersList.add("Route Code");
				headersList.add("Trip Start Time");
				headersList.add("Last Hub Name");
				headersList.add("Average Speed");
				headersList.add("Scheduled Arrival(Date,Time)");
				headersList.add("From Source Location");
				headersList.add("To Destination");
				headersList.add("Current Location");
				headersList.add("Distance Travelled(Kms)");
				headersList.add("Delay Time(HH:MM)");
				headersList.add("Idle Time(HH:MM)");
				headersList.add("Last Communicated(Date,Time)");
				headersList.add("Status");
		
			if(customerId==0 || isLtsp == 0){
				pstmt = connection.prepareStatement(CargomanagementStatements.GET_NO_GPS_DETAILS_FOR_LTSP);
			}else{
				pstmt = connection.prepareStatement(CargomanagementStatements.GET_NO_GPS_DETAILS_FOR_CLIENT);					
			}
			
			pstmt.setInt(1,offset);
			pstmt.setInt(2,offset);
			pstmt.setInt(3,offset);
			pstmt.setInt(4,systemId);
			pstmt.setInt(5,customerId);
			pstmt.setInt(6,userId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				ArrayList<Object> informationList = new ArrayList<Object>();
				ReportHelper reporthelper = new ReportHelper();
	            count++;
	            
				jsonObject= new JSONObject();
				VehicleNo=rs.getString("VEHICLE_NUMBER");
				RouteName=rs.getString("ROUTE_NAME");
				RouteCode=rs.getString("ROUTE_CODE");
				CurrentLocation=rs.getString("CURRENT_LOCATION");
				AverageSpeed=rs.getString("AVERAGE_SPEED");
				idleTime=rs.getString("IDLE_TIME").replace(".", ":");
				delayTime=rs.getString("DELAY_TIME").replace(".", ":");
				idleTimehhmm= getHHMMFormat(idleTime);
				delayTimehhmm=getHHMMFormat(delayTime);
				
				informationList.add(count);
				jsonObject.put("slno", count);

				informationList.add(VehicleNo);
				jsonObject.put("VehicleNo", VehicleNo);
				
				informationList.add(RouteName);
				jsonObject.put("RouteName", RouteName);

				informationList.add(RouteCode);
				jsonObject.put("RouteCode", RouteCode);
				
				if(rs.getString("TRIP_START_TIME")==""|| rs.getString("TRIP_START_TIME").contains("1900"))
				{
				informationList.add("");
				jsonObject.put("TripStartTime","");	
				}
				else
				{	
				informationList.add(ddmmyyyy.format(yyyymmdd.parse(rs.getString("TRIP_START_TIME"))));
				jsonObject.put("TripStartTime",ddmmyyyy.format(yyyymmdd.parse(rs.getString("TRIP_START_TIME"))));
				}
				
				informationList.add("");
				jsonObject.put("LastHubName","");
				
				informationList.add(AverageSpeed);
				jsonObject.put("AverageSpeed", AverageSpeed);
				
				if(rs.getString("SCHEDULED_ARRIVAL")==""|| rs.getString("SCHEDULED_ARRIVAL").contains("1900"))
				{
				informationList.add("");
				jsonObject.put("ScheduledArrivalDateTime","");	
				}
				else
				{	
				informationList.add(ddmmyyyy.format(yyyymmdd.parse(rs.getString("SCHEDULED_ARRIVAL"))));
				jsonObject.put("ScheduledArrivalDateTime",ddmmyyyy.format(yyyymmdd.parse(rs.getString("SCHEDULED_ARRIVAL"))));
				}
				
				informationList.add(rs.getString("FROM_PLACE"));
				jsonObject.put("fromSourceLocation", rs.getString("FROM_PLACE"));
				
				informationList.add(rs.getString("TO_DESTINATION"));
				jsonObject.put("toDestionation", rs.getString("TO_DESTINATION"));
				
				informationList.add(CurrentLocation);
				jsonObject.put("CurrentLocation", CurrentLocation);
				
				informationList.add(rs.getString("DISTANCE_TRAVELLED"));
				jsonObject.put("distanceTravelled", rs.getString("DISTANCE_TRAVELLED"));
				
				informationList.add(delayTimehhmm);
				jsonObject.put("delayTime", delayTimehhmm);
				
				informationList.add(idleTimehhmm);
				jsonObject.put("idleTime", idleTimehhmm);
				
				if(rs.getString("LAST_COMMUNICATED")==""|| rs.getString("LAST_COMMUNICATED").contains("1900"))
				{
				informationList.add("");
				jsonObject.put("LastCommunicatedDateTime","");	
				}
				else
				{	
				informationList.add(ddmmyyyy.format(yyyymmdd.parse(rs.getString("LAST_COMMUNICATED"))));
				jsonObject.put("LastCommunicatedDateTime",ddmmyyyy.format(yyyymmdd.parse(rs.getString("LAST_COMMUNICATED"))));
				}
                
				informationList.add("");
				jsonObject.put("status", "");
				
				jsonArray.put(jsonObject);
				reporthelper.setInformationList(informationList);
				reportsList.add(reporthelper);
			}
			finalreporthelper.setReportsList(reportsList);
			finalreporthelper.setHeadersList(headersList);
			finlist.add(jsonArray);
			finlist.add(finalreporthelper);
			rs.close();
					}
}
		catch (Exception e) {
			e.printStackTrace();
		}
		
	}
	catch (Exception e) {
		e.printStackTrace();
	} finally {
		DBConnection.releaseConnectionToDB(connection, pstmt, rs);
	}
	return finlist;
}

	public JSONArray getPrincipalStore(int systemId, int clientId) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		JSONObject obj = null;
		JSONArray jsonArray = new JSONArray();
		try{
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(CargomanagementStatements.GET_PRINCIPAL_STORE_DETAILS);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, clientId);
			pstmt.setString(3, "PRINCIPAL");
			rs = pstmt.executeQuery();
			while(rs.next()){
				obj = new JSONObject();
				obj.put("principalId", rs.getString("principalId"));
				obj.put("principalName", rs.getString("principalName"));
				jsonArray.put(obj);
			}
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jsonArray;
	}
	
	public JSONArray getConsigneeStore(int systemId, int clientId) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		JSONObject obj = null;
		JSONArray jsonArray = new JSONArray();
		try{
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(CargomanagementStatements.GET_CONSIGNEE_STORE_DETAILS);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, clientId);
			pstmt.setString(3, "CONSIGNEE");
			rs = pstmt.executeQuery();
			while(rs.next()){
				obj = new JSONObject();
				obj.put("consigneeId", rs.getString("principalId"));
				obj.put("consigneeName", rs.getString("principalName"));
				jsonArray.put(obj);
			}
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jsonArray;
	}
	
	public String addAssignedVehicledetails(String vehicle,int principal,int systemId,int consignee,int customerId,int userId)
	 {
		Connection con = null;
		PreparedStatement pstmt= null;
		ResultSet rs= null;
		String message="";
		int count;
		
		try
		{
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(CargomanagementStatements.CHECK_VEHICLE_ASSIGNED);
			pstmt.setString(1, vehicle);
			pstmt.setInt(2, systemId);
			pstmt.setInt(3, customerId);
			rs = pstmt.executeQuery();
			if(! rs.next()){
				pstmt = con.prepareStatement(CargomanagementStatements.SAVE_ASSIGN_VEHICLE_DETAILS);
				pstmt.setString(1, vehicle);
				pstmt.setInt(2, principal);
				pstmt.setInt(3, consignee);
				pstmt.setInt(4, systemId);
				pstmt.setInt(5, customerId);
				pstmt.setInt(6, userId);
				count=pstmt.executeUpdate();
				if(count>0)
				{
					message="Vehicle Assigned Successfully.";
				}
				else
					message="Error While Assigning";
			}
			else{
				message= "Vehicle is already assigned.";
			}
			
		}
		catch (Exception e)
		{
			System.out.println("error in:- Assigning Assign Vehicle Details "+e.toString());
				e.printStackTrace();
		}      
		finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return message;
				
	}
	
	public String modifyAssignedVehicledetails(String vehicle,int principal,int systemId,int consignee,int customerId,int userId,int uniqueId)
	 {
		
		Connection con = null;
		PreparedStatement pstmt= null;
		ResultSet rs= null;
		String message="";
		int count;
		
		try
		{
			con = DBConnection.getConnectionToDB("AMS");
				pstmt = con.prepareStatement(CargomanagementStatements.MODIFY_ASSIGN_VEHICLE_DETAILS);
				pstmt.setInt(1, principal);
				pstmt.setInt(2, consignee);
				pstmt.setInt(3, userId);
				pstmt.setInt(4, uniqueId);
				pstmt.setInt(5, systemId);
				pstmt.setInt(6, customerId);
				count=pstmt.executeUpdate();
				if(count>0)
				{
					message="Updated Successfully.";
				}
				else
					message="Error While Updating";			
		}
		catch (Exception e)
		{
			System.out.println("error in:-Updating Assigning Vehicle Details "+e.toString());
				e.printStackTrace();
		}      
		finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return message;
				
	}
	public ArrayList<Object> getAssignedVehiclesDetails(int systemId, int customerId, int offset){
		JSONArray JsonArray = new JSONArray();
		JSONObject JsonObject = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int slcount = 0;
		String updatedDate = null;
		ArrayList<Object> finalList = new ArrayList<Object>();
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(CargomanagementStatements.GET_ASSIGNED_VEHICLE_DETAILS);
			pstmt.setInt(1, offset);
			pstmt.setInt(2, offset);
			pstmt.setInt(3, systemId);
			pstmt.setInt(4, customerId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				JsonObject = new JSONObject();
				slcount++;
				JsonObject.put("slnoIndex", slcount);

				JsonObject.put("uniqueIdDataIndex", rs.getString("UID"));
				
				JsonObject.put("vehicleNoIndex", rs.getString("VEHICLE_NO"));
				
				JsonObject.put("principalNameIndex", rs.getString("Principal"));
				
				JsonObject.put("consigneeNameIndex", rs.getString("Consignee"));

				JsonObject.put("associatedByIndex", rs.getString("createdBy").toUpperCase());
				
				JsonObject.put("associatedTimeIndex", getFormattedDateStartingFromYearToDate(rs.getString("createdDate")));
				
				JsonObject.put("modifiedByIndex", rs.getString("updatedBy").toUpperCase());
				
				updatedDate = rs.getString("updatedDate");
				String substr = updatedDate.substring(0, 4);
				if (substr.equals("1900")) {
					updatedDate = "";
				}else{
					updatedDate = getFormattedDateStartingFromYearToDate(rs.getString("updatedDate"));
				}
				
				JsonObject.put("modifiedTimeIndex", updatedDate);

				JsonArray.put(JsonObject);
			}
			finalList.add(JsonArray);

		} catch (Exception e) {
			e.printStackTrace();
		}finally {

			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return finalList;
		}
	
	public ArrayList<Object> getExpenseDetails(int systemId, int customerId, int offset,String Status){
		JSONArray JsonArray = new JSONArray();
		JSONObject JsonObject = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int slcount = 0;
		ArrayList<Object> finalList = new ArrayList<Object>();
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(CargomanagementStatements.GET_EXPENSE_DETAILS);
			pstmt.setInt(1, offset);
			pstmt.setInt(2, systemId);
			pstmt.setInt(3, customerId);
			pstmt.setString(4, Status);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				JsonObject = new JSONObject();
				slcount++;
				JsonObject.put("slnoIndex", slcount);

				JsonObject.put("uniqueIdDataIndex", rs.getString("UID"));
				
				JsonObject.put("tripNoindex", rs.getString("TRIP_NO"));
				
				JsonObject.put("tripDateIndex", getFormattedDateStartingFromYearToDate(rs.getString("TripDate")));
				
				JsonObject.put("principalNameIndex", rs.getString("Principal"));

				JsonObject.put("consigneeNameIndex", rs.getString("Consignee"));
				
				JsonObject.put("amountIndex", rs.getString("Amount"));
				
				JsonObject.put("descriptionIndex", rs.getString("Description"));
				
				JsonObject.put("approvedAmountIndex", rs.getString("Approved_Amount"));
				
				JsonObject.put("accountHeaderIndex", rs.getString("AccHeader"));
				
				JsonObject.put("principalNameIndex", rs.getString("Consignee"));
				
				JsonObject.put("remarksIndex", rs.getString("Remarks"));
				
				JsonArray.put(JsonObject);
			}
			finalList.add(JsonArray);

		} catch (Exception e) {
			e.printStackTrace();
		}finally {

			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return finalList;
		}
	
	
	public String addApproveDetails() {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int insertResult=0;
		String message="";
		try
		{
			con = DBConnection.getConnectionToDB("AMS");
//			pstmt = con.prepareStatement(CargomanagementStatements.INSERT_CARGO_ROUTE_SKELETON);
//			pstmt.setString(1,cargotripnametxt);
//			pstmt.setString(2,cargotripcode);
//			pstmt.setInt(3,Integer.parseInt(cargoorgin));
//			pstmt.setInt(4,Integer.parseInt(cargodestination));
//			pstmt.setString(5,transitions);
//			pstmt.setInt(6,Integer.parseInt(cargototaltime));
//			pstmt.setInt(7,Integer.parseInt(cargoapproxdistance));
//			pstmt.setInt(8,Integer.parseInt(cargoaveragespeed));
//			pstmt.setInt(9,Integer.parseInt(customerId));
//			pstmt.setInt(10,systemId);
//			pstmt.setInt(11,createdby);
//			insertResult=pstmt.executeUpdate();	
		}
		catch(Exception e)
		{
		e.printStackTrace();	
		}
		finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return message;
	}
	
	public String addRejectDetails() {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int insertResult=0;
		String message="";
		try
		{
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(CargomanagementStatements.INSERT_CARGO_ROUTE_SKELETON);
//			pstmt.setString(1,cargotripnametxt);
//			pstmt.setString(2,cargotripcode);
//			pstmt.setInt(3,Integer.parseInt(cargoorgin));
//			pstmt.setInt(4,Integer.parseInt(cargodestination));
//			pstmt.setString(5,transitions);
//			pstmt.setInt(6,Integer.parseInt(cargototaltime));
//			pstmt.setInt(7,Integer.parseInt(cargoapproxdistance));
//			pstmt.setInt(8,Integer.parseInt(cargoaveragespeed));
//			pstmt.setInt(9,Integer.parseInt(customerId));
//			pstmt.setInt(10,systemId);
//			pstmt.setInt(11,createdby);
			insertResult=pstmt.executeUpdate();	
		}
		catch(Exception e)
		{
		e.printStackTrace();	
		}
		finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return message;
	}
	
	
	public String getFormattedDateStartingFromYearToDate(String inputDate) {
		String formattedDate = "";
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		SimpleDateFormat sdfFormatDate = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
		try {
			if (inputDate != null && !inputDate.equals("")) {
				java.util.Date d = sdf.parse(inputDate);
				formattedDate = sdfFormatDate.format(d);
			}

		} catch (Exception e) {
			System.out.println("Error in getFormattedDateStartingFromYear() method"+ e);
		}
		return formattedDate;
	}
	
	
public String getHHMMFormat(String time){
	if(time.length()==4){
		time="0"+time;
	}
	return time;
}
public static String gethoursfromstrformat(String str) 
{
	String returnhrsstr = "";
	try 
	{
		if (!str.equals("")) 
		 {
			String s1[] = str.split(" ");
			String dd = s1[0].substring(0, s1[0].indexOf('d'));
			String hh = s1[1].substring(0, s1[1].indexOf('h'));
			String mm = s1[2].substring(0, s1[2].indexOf('m'));
			int returnhrs = Integer.parseInt(dd) * 24
					+ Integer.parseInt(hh);
			int returnmin = Integer.parseInt(mm);
			if (returnmin < 10) 
			{
				returnhrsstr = String.valueOf(returnhrs) + ".0"+ String.valueOf(returnmin);
			}
			else 
			{
				returnhrsstr = String.valueOf(returnhrs) + "."+ String.valueOf(returnmin);
			}
		}
	} 
	catch (Exception e) 
	{
		e.printStackTrace();
	}
	return returnhrsstr;
}
public static int getDelayTime(int std_time_min, double std_distance, int actualtimeinmin, double actualcovereddistance)
{
	int delaytimeinmin = 0;
	
	try{
		double std_avgdistance = std_distance/std_time_min;
		double stdtimetaken =actualcovereddistance/std_avgdistance;
		delaytimeinmin = (int) (actualtimeinmin - stdtimetaken);
		
		if (delaytimeinmin<0) {
			delaytimeinmin=0;
		}
	}catch (Exception e) {
		e.printStackTrace();
	}
	
	return delaytimeinmin;
}

public String convertMinutesToHHMMFormat(int minutes)
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

public boolean checkdatediff(Date startdate,Date enddate) 
{
	boolean flag = false;
	Calendar cal = Calendar.getInstance();
	cal.setTime(startdate);
	cal.add(Calendar.HOUR, 3);
	
	Date date = cal.getTime();
	flag=cf.isDateAfterDate(enddate, date);
	return flag;
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

public ArrayList<Object> getNtcTripDetails(int systemId,
		int userId,  int isLtsp,String cusName, int cusId,int offset) {
	Connection con = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	JSONArray jsonArray = new JSONArray();
	ArrayList<ReportHelper> reportsList = new ArrayList<ReportHelper>();
	ArrayList<String> headersList = new ArrayList<String>();
	ReportHelper finalreporthelper = new ReportHelper();
	ArrayList<Object> aslist = new ArrayList<Object>();
	
	SimpleDateFormat ddmmyyyy = new SimpleDateFormat("dd-MM-yyyy");
	SimpleDateFormat ddmmyyyy1 = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
	SimpleDateFormat yyyymmdd = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	
	int count = 0;
	
	    headersList.add("Sl No");
	    headersList.add("CUSTOMER NAME");
	    headersList.add("Vehicle Number");
	    headersList.add("Trip No");
	    headersList.add("Trip Inserted Date");
	    headersList.add("Today Location");
	    headersList.add("Speed");
	    headersList.add("Date Time");
	    headersList.add("Status Of Vehicle");
	    headersList.add("From");
	    headersList.add("To");
	    headersList.add("Yesterday Location");
	    headersList.add("Trip Start Date");
	    headersList.add("Trip Route Code");
	    headersList.add("Trip Sales Channel");
	    headersList.add("Trip Type");
	    headersList.add("Trip Remarks");
	    headersList.add("LR Number");
	    headersList.add("Material");
	    headersList.add("Dimensions");
	    headersList.add("Transit days");
	    headersList.add("Driver Code No");
	    headersList.add("Driver Analysis Code");
	    headersList.add("Driver Name");
	    headersList.add("DL No");
	    headersList.add("Driver Mobile No");
	    headersList.add("Crew Type");
	    headersList.add("Operator Name");
	    headersList.add("Vehicle Mode");
	    headersList.add("Vehicle Make");
	    headersList.add("Vehicle Model");
	    headersList.add("Vehicle Incharge");
	    headersList.add("Vehicle Type");
	    headersList.add("Co-Driver Code");
	    headersList.add("Co-Driver Analysis Code");
	    headersList.add("Co-Driver Name");
	    headersList.add("Co-Crew Type");
	    headersList.add("Co-Driver Mobile No");
	    headersList.add("Co-Driver DL No");
	    headersList.add("Crew Consultancy Name");
	    headersList.add("Trailer No");
	    headersList.add("Trailer Mode");
	    headersList.add("Trailer Make");
	    headersList.add("Trailer Model");
	    headersList.add("Trailer Incharge");
	    headersList.add("Trailer Type");
	    headersList.add("LP In Date");
	    headersList.add("LP Out Date");
	    headersList.add("UL In Date");
	    headersList.add("UL Out Date");
	    headersList.add("ATM Card No");
	    headersList.add("Diesel Card No");
	    headersList.add("Trip Milleage");
	    headersList.add("Reason For Halting");
	    headersList.add("Driver Grade");
	    headersList.add("Operator Code");
	try{
	JSONObject obj = new JSONObject();
	con = DBConnection.getConnectionToDB("AMS");
	jsonArray = new JSONArray();
	
	 pstmt = con.prepareStatement(CargomanagementStatements.GET_NTC_TRIP_DETAILS);
	 pstmt.setInt(1, offset);
     pstmt.setInt(2, systemId);
     pstmt.setInt(3, cusId);
    
     rs = pstmt.executeQuery();
     
     while(rs.next()) {
     	
     	ArrayList<Object> informationList = new ArrayList<Object>();
		ReportHelper reporthelper = new ReportHelper();	
			
		count++;
     	obj = new JSONObject();
     	obj.put("slnoIndex", count);
     	informationList.add(count);
     	
     	obj.put("custIndex", rs.getString("COUSTOMER_NAME"));
     	informationList.add(rs.getString("COUSTOMER_NAME"));
     	
     	obj.put("vehNoIndex", rs.getString("VEHICLE_NO"));
     	informationList.add(rs.getString("VEHICLE_NO"));
     	
     	obj.put("tripNoIndex", rs.getString("TRIPSHEET_NO"));
     	informationList.add(rs.getString("TRIPSHEET_NO"));
     	
     	String inserted_DATE=rs.getString("TRIPSHEET_DATE");
     	inserted_DATE=ddmmyyyy.format(yyyymmdd.parse(inserted_DATE));
     	obj.put("tripInsertIndex", inserted_DATE);
     	informationList.add(inserted_DATE);
     	
     	obj.put("todLocIndex", rs.getString("LOCATION"));
     	informationList.add(rs.getString("LOCATION"));
     	
     	obj.put("speedIndex", rs.getInt("SPEED"));
     	informationList.add(rs.getInt("SPEED"));
     	
    	String date_TIME= rs.getString("GPS_DATETIME");
    	date_TIME=ddmmyyyy1.format(yyyymmdd.parse(date_TIME));
    	obj.put("dateTimeIndex", date_TIME);
     	informationList.add(date_TIME);
     	
     	obj.put("statusOfVehIndex", rs.getString("CATEGORY"));
     	informationList.add(rs.getString("CATEGORY"));
     	
     	obj.put("fromIndex", rs.getString("LOCATION_FROM"));
     	informationList.add(rs.getString("LOCATION_FROM"));
     	
     	obj.put("toIndex", rs.getString("LOCATION_TO"));
     	informationList.add(rs.getString("LOCATION_TO"));
     	
     	obj.put("yesterLocIndex", rs.getString("YEST_LOCATION"));
     	informationList.add(rs.getString("YEST_LOCATION"));
     
     	String trip_DATE= rs.getString("START_DATE");
     	trip_DATE=ddmmyyyy1.format(yyyymmdd.parse(trip_DATE));
    	obj.put("tripStartIndex", trip_DATE);
     	informationList.add(trip_DATE);
     	
     	obj.put("tripRouteIndex", rs.getString("ROUTE_CODE"));
     	informationList.add(rs.getString("ROUTE_CODE"));
     	
     	obj.put("tripSalesIndex", rs.getString("SALES_CHANNEL"));
     	informationList.add(rs.getString("SALES_CHANNEL"));
     	
     	obj.put("tripTypeIndex", rs.getString("TRIP_SHEET_TYPE"));
     	informationList.add(rs.getString("TRIP_SHEET_TYPE"));
     	
     	obj.put("tripRemarksIndex", rs.getString("REMARKS"));
     	informationList.add(rs.getString("REMARKS"));
     	
     	obj.put("lrNoIndex", rs.getString("REF_CODE_NO"));
     	informationList.add(rs.getString("REF_CODE_NO"));
     	
     	obj.put("materialIndex", rs.getString("MATERIAL_NAME"));
     	informationList.add(rs.getString("MATERIAL_NAME"));
     	
     	obj.put("dimensionIndex", rs.getString("DIMENSIONS"));
     	informationList.add(rs.getString("DIMENSIONS"));
     	
     	obj.put("transitDaysIndex", rs.getString("TRANSIT_DAYS"));
     	informationList.add(rs.getString("TRANSIT_DAYS"));
     
     	obj.put("driCodeNoIndex", rs.getString("CREW_CODE"));
     	informationList.add(rs.getString("CREW_CODE"));
     	
     	obj.put("driAnaCodeIndex", rs.getString("CREW_ANAL_CODE"));
     	informationList.add(rs.getString("CREW_ANAL_CODE"));
     	
     	obj.put("driNameIndex", rs.getString("CREW_NAME"));
     	informationList.add(rs.getString("CREW_NAME"));
     	
     	obj.put("dlNoIndex", rs.getString("CREW_DL_NO"));
     	informationList.add(rs.getString("CREW_DL_NO"));
     	
     	obj.put("driMobNoIndex", rs.getString("CREW_MOBILE"));
     	informationList.add(rs.getString("CREW_MOBILE"));
     	
     	obj.put("crewTypeIndex", rs.getString("CREW_TYPE"));
     	informationList.add(rs.getString("CREW_TYPE"));
     	
     	obj.put("OperatorIndex", rs.getString("CREW_CONSULT_NAME"));
     	informationList.add(rs.getString("CREW_CONSULT_NAME"));
     	
     	obj.put("vehModeIndex", rs.getString("VEHICLE_MODE"));
     	informationList.add(rs.getString("VEHICLE_MODE"));
     	
     	obj.put("vehMakeIndex", rs.getString("VEHICLE_MAKE"));
     	informationList.add(rs.getString("VEHICLE_MAKE"));
     	
     	obj.put("vehModelIndex", rs.getString("VEHICLE_MODEL"));
     	informationList.add(rs.getString("VEHICLE_MODEL"));
     
     	obj.put("vehInchargeIndex", rs.getString("VEHICLE_INCHARGE"));
     	informationList.add(rs.getString("VEHICLE_INCHARGE"));
     	
     	obj.put("vehTypeIndex", rs.getString("VEHICLE_TYPE"));
     	informationList.add(rs.getString("VEHICLE_TYPE"));
     	
     	obj.put("co-Dri1Index", rs.getString("CO_CREW_CODE"));
     	informationList.add(rs.getString("CO_CREW_CODE"));
     	
     	obj.put("co-Dri1AnaIndex", rs.getString("CO_CREW_ANAL_CODE"));
     	informationList.add(rs.getString("CO_CREW_ANAL_CODE"));
     	
     	obj.put("co-Dri1NameIndex", rs.getString("CO_CREW_NAME"));
     	informationList.add(rs.getString("CO_CREW_NAME"));
     	
     	obj.put("co-CreTypIndex", rs.getString("CO_CREW_TYPE"));
     	informationList.add(rs.getString("CO_CREW_TYPE"));
     	
     	obj.put("co-DriMobNoIndex", rs.getString("CO_CREW_MOBILE"));
     	informationList.add(rs.getString("CO_CREW_MOBILE"));
     	
     	obj.put("co-DriDlNoIndex", rs.getString("CO_CREW_DL_NO"));
     	informationList.add(rs.getString("CO_CREW_DL_NO"));
     	
     	obj.put("creConNameIndex", rs.getString("CO_CREW_CONSULT_NAME"));
     	informationList.add(rs.getString("CO_CREW_CONSULT_NAME"));
     	
     	obj.put("trailerNoIndex", rs.getString("TRAILER_NO"));
     	informationList.add(rs.getString("TRAILER_NO"));
     
     	obj.put("trailerModIndex", rs.getString("TRAILER_MODE"));
     	informationList.add(rs.getString("TRAILER_MODE"));
     	
     	obj.put("trailerMakIndex", rs.getString("TRAILER_MAKE"));
     	informationList.add(rs.getString("TRAILER_MAKE"));
     	
     	obj.put("trailerModelIndex", rs.getString("TRAILER_MODEL"));
     	informationList.add(rs.getString("TRAILER_MODEL"));
     	
     	obj.put("trailerInchrgIndex", rs.getString("TRAILER_INCHARGE"));
     	informationList.add(rs.getString("TRAILER_INCHARGE"));
     	
     	obj.put("trialerTypeIndex", rs.getString("TRAILER_TYPE"));
     	informationList.add(rs.getString("TRAILER_TYPE"));
     	
     	obj.put("lpInIndex", "");
     	informationList.add("");
     	
    	obj.put("lpOutIndex", "");
     	informationList.add("");
     	
     	obj.put("ulInIndex", "");
    	informationList.add("");
     	
     	obj.put("ulOutIndex", "");
     	informationList.add("");
     	
     	obj.put("atmCardIndex","");
     	informationList.add("");
    
    	obj.put("dieselIndex", "");
     	informationList.add("");
     	
     	obj.put("tripMillIndex","");
     	informationList.add("");
     	
     	obj.put("haltingReasonIndex","");
     	informationList.add("");
     	
    	obj.put("driGradeIndex", "");
     	informationList.add("");
    	
     	obj.put("operatorCodeIndex", "");
    	informationList.add("");
     	
   	
   	
     	jsonArray.put(obj);
     	
     	reporthelper.setInformationList(informationList);
     	reportsList.add(reporthelper);
     	aslist.add(jsonArray);
		finalreporthelper.setReportsList(reportsList);
		finalreporthelper.setHeadersList(headersList);
		aslist.add(finalreporthelper);
     }
     
	}
	catch(Exception e)
	{
		e.printStackTrace();
		System.out.println(e);
	}
	finally{
		DBConnection.releaseConnectionToDB(con, pstmt, rs);
	}
	return aslist;
}
}


//*********************************************************Nikhil:Function not in use currently because Logic for Calculating Vehicle Position is by Distance and Time not by HUB***********************************
//public int getVehiclePositionDashBoard(String regNo,String starttime,int orgin,int transitioncount,String transition,int destination,int systemId)
//{
//int vehiclePosition=0;	
//Connection con = null;
//PreparedStatement pstmt = null;
//ResultSet rs = null;
//int hubID=0;
//boolean transitionflag=false;
//try {
//	con = DBConnection.getConnectionToDB("AMS");
//	pstmt = con.prepareStatement(CargomanagementStatements.GET_TOP_HUB_REPORT);
//	pstmt.setString(1, regNo);
//	pstmt.setInt(2,systemId);
//	rs = pstmt.executeQuery();
//	if (rs.next()) {
//	hubID=rs.getInt("HUB_ID");				
//	}
//	if(hubID==orgin)
//	{
//	vehiclePosition=1;
//	}
//	else if(hubID==destination)
//	{
//	vehiclePosition=transitioncount+1;
//	}
//	else 
//	{
//		StringTokenizer st = new StringTokenizer(transition, ",");
//		int count=1;
//		while (st.hasMoreElements()) {
//			count++;
//			int transitionHub=Integer.parseInt(st.nextToken());
//			if(hubID==transitionHub)
//			{
//			transitionflag=true;
//			break;
//			}
//		}			
//		vehiclePosition=count;
//		if(transitionflag==false)
//		{
//			vehiclePosition=1;	
//		}
//	}
//} catch (Exception e) {
//	e.printStackTrace();
//} finally {
//	DBConnection.releaseConnectionToDB(con, pstmt, rs);
//}
//return vehiclePosition;
//}
