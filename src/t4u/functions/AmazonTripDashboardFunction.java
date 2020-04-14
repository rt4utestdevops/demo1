package t4u.functions;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Date;
import java.util.HashSet;
import java.util.Iterator;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Set;

import org.json.JSONArray;
import org.json.JSONObject;

import t4u.common.DBConnection;

public class AmazonTripDashboardFunction {
	public static final String TRIPCOUNT=" select  START_LOCATION ,count(*) as VEHICLECOUNT "+
	" from  AMS.dbo.TRACK_TRIP_DETAILS "+
	" where SYSTEM_ID=? and CUSTOMER_ID=? and STATUS='OPEN'  "+
	" group by START_LOCATION "; 

	public static final String TRIPDETAILS=" select isnull(td.TRIP_ID,0) as tripId ,isnull(td.SHIPMENT_ID,'') as tripName , "+
	" isnull(td.ASSET_NUMBER,'') as vehicleNo ,tbl.VehicleAlias as vendorName, isnull(td.START_LOCATION,'') as sortCenter , "+
	" gps.GPS_DATETIME as LATEST_COMM ,isnull(dateadd(mi,?,td.DRIVER_NAME),'') AS ORIGIN,  "+
	" isnull(dateadd(mi,?,td.ACTUAL_TRIP_START_TIME),'') as START_DATE, "+
	" (isnull(td.STATUS,'')+'-'+isnull(td.TRIP_STATUS,'')) as status, "+
	" (case when td.ACTUAL_TRIP_END_TIME is null then dateadd(mi,?,getutcdate())  "+
	" else dateadd(mi,?,td.ACTUAL_TRIP_END_TIME) end) as endDate , "+
	" isnull(NEXT_LOCATION,'') as NEXT_LOCATION ,isnull(td.ACTUAL_DISTANCE,0) as actualDuration ,gps.LOCATION as CurrentLocation  "+
	" from AMS.dbo.TRACK_TRIP_DETAILS td  "+
	" left outer join AMS.dbo.gpsdata_history_latest gps on gps.REGISTRATION_NO=td.ASSET_NUMBER and gps.System_id=td.SYSTEM_ID "+
	" left outer join AMS.dbo.tblVehicleMaster  tbl on tbl.VehicleNo=td.ASSET_NUMBER  and td.SYSTEM_ID=tbl.System_id "+
	" where td.SYSTEM_ID=? and td.CUSTOMER_ID=?   ";

	public static final String TRACKHUBDETAILS="  select SEQUENCE,NAME,dateadd(mi,?, ACT_ARR_DATETIME) as ACT_ARR_DATETIME ,dateadd(mi,?, ACT_DEP_DATETIME) as ACT_DEP_DATETIME , "+
	"  DATEDIFF(MINUTE, ACT_ARR_DATETIME, ACT_DEP_DATETIME) AS STOP_DURATION "+
	"  from DES_TRIP_DETAILS  "+
	"  where  ACT_ARR_DATETIME is not null and ACT_DEP_DATETIME is not null and SEQUENCE between 1 and 3  and TRIP_ID=?  ";
	//"  order by SEQUENCE " ;

	public static final String getSortCenterNames=" SELECT NAME FROM  AMS.dbo.LOCATION_ZONE_A  WHERE OPERATION_ID=5 AND SYSTEMID=? AND CLIENTID=? order by NAME asc ";

	public static final String getHubNames=" SELECT NAME FROM  AMS.dbo.LOCATION_ZONE_A  WHERE OPERATION_ID=1 AND SYSTEMID=?  AND CLIENTID=? order by NAME asc  ";

	 //"  and DATEDIFF(MINUTE, ACT_ARR_DATETIME, ACT_DEP_DATETIME) >1 ";

	public static final String AMAZON_REPORT_DETAILS="select isnull(lvs.VEHICLE_ID,'') as Vendor_Name, COUNT(DISTINCT hd.REGISTRATION_NO) AS No_Of_Vehicles_t4u_AMZ,COUNT(hd.REGISTRATION_NO) AS No_Of_Pings FROM dbo.Live_Vision_Support lvs " +
			"inner join dbo.HISTORY_DATA_262 hd on lvs.REGISTRATION_NO=hd.REGISTRATION_NO where hd.GMT BETWEEN dateadd(mi,-?,?) AND dateadd(mi,-?,?) " +
			"group by lvs.VEHICLE_ID ";
	
	public static final String AMAZON_DATETIME_WISE_DETAILS="select isnull(lvs.VEHICLE_ID,'') as Vendor_Name, COUNT(DISTINCT hd.REGISTRATION_NO) AS No_Of_Vehicles_t4u_AMZ,COUNT(hd.REGISTRATION_NO) AS No_Of_Pings FROM dbo.Live_Vision_Support lvs " +
			"inner join dbo.HISTORY_DATA_262 hd on lvs.REGISTRATION_NO=hd.REGISTRATION_NO where hd.DATETIME BETWEEN ? AND dateadd(mi,45,?) " +
			"group by lvs.VEHICLE_ID "+
			"order by Vendor_Name ";
	
	public static final String AMAZON_DATE_WISE_DETAILS="select isnull(VENDOR_NAME,'') VENDOR_NAME,isnull(NO_OF_VEHICLES,0) NO_OF_VEHICLES,isnull(NO_OF_PINGS,0) NO_OF_PINGS from dbo.vendor_details_datewise where convert(varchar(10),DATETIME,120)=?";
	
	public static final String GET_DATE_TO_COMBO=" select distinct convert(varchar(10),DATETIME,120) as DATE from  AMS.dbo.vendor_details_datewise ";
	
	public static final String VEHICLE_COUNT_DETAILS="select COUNT(DISTINCT hd.REGISTRATION_NO) AS VehicleCount " +
			"FROM dbo.Live_Vision_Support lvs " +
			"inner join dbo.HISTORY_DATA_262 hd on lvs.REGISTRATION_NO=hd.REGISTRATION_NO " +
			"where hd.DATETIME BETWEEN ? AND dateadd(mi,45,?) ";
	
	public static final String VENDOR_COUNT_DETAILS="select COUNT(DISTINCT lvs.VEHICLE_ID) AS VendorCount " +
			"FROM dbo.Live_Vision_Support lvs " +
			"inner join dbo.HISTORY_DATA_262 hd on lvs.REGISTRATION_NO=hd.REGISTRATION_NO " +
			"where hd.DATETIME BETWEEN ? AND dateadd(mi,45,?) ";

	static SimpleDateFormat sdfDB = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	static SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
	DecimalFormat df = new DecimalFormat("00.00");


	public JSONArray getVehicleCount(int systemId, int clientId, int userId) {
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonobject = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			jsonArray = new JSONArray();
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(TRIPCOUNT);
			pstmt.setInt(1,systemId);
			pstmt.setInt(2,clientId);
			rs = pstmt.executeQuery();
			int totalCount=0;
			while (rs.next()) {
				jsonobject = new JSONObject();
				totalCount+=rs.getInt("VEHICLECOUNT");
				jsonobject.put("sortCenterName", rs.getString("START_LOCATION"));
				jsonobject.put("vehicleCount", rs.getInt("VEHICLECOUNT"));
				//jsonobject.put("total", totalVehicle);
				jsonArray.put(jsonobject);
			}
			if(totalCount>0){
				jsonobject = new JSONObject();
				jsonobject.put("sortCenterName", "Total");
				jsonobject.put("vehicleCount", totalCount);
			//	jsonobject.put("total", totalVehicle);
				jsonArray.put(jsonobject);
			}

		} catch (Exception e) {
			e.printStackTrace();
		}finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jsonArray;
	}

	public JSONArray getTripSummaryDetailsAmazon(int systemId, int clientId, int offset, String groupId, String unit,int userId,String  sortCenter,String hubLoc) {
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonobject = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int count = 0;
		String condition = "";
		String condition1 = "";
		String condition2 = "";
		double distance = 0;
		String endDate = "";
		String originTime="";
		try {
			jsonArray = new JSONArray();
			con = DBConnection.getConnectionToDB("AMS");
			StringBuffer query = new StringBuffer();
			query.append(TRIPDETAILS);
			if(groupId.equals("0")){
				condition = "and td.STATUS='OPEN' and td.TRIP_STATUS <> 'NEW' ";
			}else if(groupId.equals("1")){
				condition = "and td.TRIP_START_TIME between dateadd(dd,-2,getutcdate()) and getutcdate()";
			}else if(groupId.equals("2")){
				condition = "and td.TRIP_START_TIME between dateadd(dd,-7,getutcdate()) and getutcdate()";
			}else if(groupId.equals("3")){
				condition = "and td.TRIP_START_TIME between dateadd(dd,-15,getutcdate()) and getutcdate()";
			}else if(groupId.equals("4")){
				condition = "and td.TRIP_START_TIME between dateadd(dd,-30,getutcdate()) and getutcdate()";
			}else if(groupId.equals("5")){
				condition = "and td.STATUS in ('CLOSED','CANCELLED') and td.TRIP_START_TIME between dateadd(dd,-2,getutcdate()) and getutcdate()  ";
			}

			query.append(condition);

			if(sortCenter.equalsIgnoreCase("All")){
				condition1 = "";
			}else {
				condition1 = " and td.START_LOCATION= '"+sortCenter+"' ";
			}
			query.append(condition1);
			
			if(hubLoc.equalsIgnoreCase("All")){
				condition2 = "";
			}else  {
				condition2 =" and td.START_LOCATION like '%"+hubLoc+"%' ";
			}
			query.append(condition2);

			
			pstmt = con.prepareStatement(query.toString());
			
			pstmt.setInt(1,offset);
			pstmt.setInt(2,offset);
			pstmt.setInt(3,offset);
			pstmt.setInt(4,offset);
			pstmt.setInt(5,systemId);
			pstmt.setInt(6, clientId);
			
			rs = pstmt.executeQuery();
			while (rs.next()) {
				endDate = "";
				count++;
				jsonobject = new JSONObject();
				jsonobject.put("slNo", count);
				jsonobject.put("tripNo", rs.getString("tripId"));
				jsonobject.put("vehicleNo", rs.getString("vehicleNo"));
				jsonobject.put("vendorName", rs.getString("vendorName"));
				jsonobject.put("startLocation", rs.getString("sortCenter"));
				//jsonobject.put("currentLocation", rs.getString("currentLocation"));
				if(rs.getString("LATEST_COMM").contains("1900")){
					jsonobject.put("latestComm",  "");
				}else{
					jsonobject.put("latestComm",  sdf.format(sdfDB.parse(rs.getString("LATEST_COMM"))));
				}
				if(rs.getString("ORIGIN").contains("1900")){
					jsonobject.put("actualDate", "");
				}else{
					jsonobject.put("actualDate", sdf.format(sdfDB.parse(rs.getString("ORIGIN"))));
				}
				distance = rs.getDouble("actualDuration");
				if(unit.equals("Miles")){
					distance = rs.getDouble("actualDuration") * 0.621371; 
				}
				jsonobject.put("distanceTravelled", df.format(distance));

				//jsonobject.put("events", rs.getInt("eventsCount"));
				jsonobject.put("status", rs.getString("status"));

				if(rs.getString("endDate").contains("1900")){
					endDate = "";
				}else{
					endDate = sdf.format(sdfDB.parse(rs.getString("endDate")));
				}
				if(!rs.getString("ORIGIN").contains("1900")){
					originTime = sdf.format(sdfDB.parse(rs.getString("ORIGIN")));
				}
				
				jsonobject.put("originLocation", originTime);

				jsonobject.put("estimatedNextPoint", rs.getString("NEXT_LOCATION"));

				if(rs.getString("START_DATE").contains("1900")){
					jsonobject.put("StartDate", "");
				}else{
					jsonobject.put("StartDate", sdf.format(sdfDB.parse(rs.getString("START_DATE"))));
				}
				
				jsonobject.put("currentLoc", rs.getString("CurrentLocation"));

				if(rs.getString("status").contains("OPEN")){
					jsonobject.put("endDate", "");
					jsonobject.put("button", "<button onclick=closeTrip("+rs.getString("tripId")+"); class='btn btn-warning'>Close Trip</button> " );
				}else{
					jsonobject.put("endDate", endDate);
					jsonobject.put("button","");
				}
				//long start=System.currentTimeMillis();
				jsonobject=getTrackHubDetails(con, rs.getInt("tripId"),jsonobject,hubLoc,offset);
				//long end=System.currentTimeMillis();
				jsonArray.put(jsonobject);
				//total=total+(end-start);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jsonArray;
	}

	public static JSONObject getTrackHubDetails(Connection con,int TripId, JSONObject jsonobject,String hubName,int offset){
		PreparedStatement pstmt=null;
		ResultSet rs=null;	
		try {
			List<Integer> list =  new ArrayList<Integer>();
			StringBuffer query = new StringBuffer();
			query.append(TRACKHUBDETAILS);
			pstmt = con.prepareStatement(query.toString());
			pstmt.setInt(1, offset);
			pstmt.setInt(2, offset);
			pstmt.setInt(3, TripId);
			rs = pstmt.executeQuery();
			int seq=0;
				while (rs.next()) {
					seq=rs.getInt("SEQUENCE");
					list.add(seq);
					jsonobject.put("hubName"+seq+"",rs.getString("NAME") );
					jsonobject.put("entryTime"+seq+"",sdf.format(sdfDB.parse(rs.getString("ACT_ARR_DATETIME"))) );
					jsonobject.put("exitTime"+seq+"", sdf.format(sdfDB.parse(rs.getString("ACT_DEP_DATETIME"))));
					jsonobject.put("stopDur"+seq+"", rs.getString("STOP_DURATION"));
				}
				for (int i = 1; i < 4; i++) {
					if(list.contains(i)){

					}else{
						jsonobject.put("hubName"+i+"","" );
						jsonobject.put("entryTime"+i+"","" );
						jsonobject.put("exitTime"+i+"", "" );
						jsonobject.put("stopDur"+i+"", "" );
					}
				}

			

		} catch (Exception e) {
			e.printStackTrace();
		}
		return jsonobject;
	}

	public JSONArray getSortCenter(int cutomerId, int systemId) {

		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject = new JSONObject();
		Connection con=null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		try{
			con = DBConnection.getConnectionToDB("AMS");
			jsonArray = new JSONArray();
			jsonObject = new JSONObject();
			pstmt = con.prepareStatement(getSortCenterNames);
			pstmt.setInt(1,systemId);
			pstmt.setInt(2,cutomerId);
			rs=pstmt.executeQuery();
			while(rs.next()){
				jsonObject = new JSONObject();
				jsonObject.put("Name", rs.getString("NAME"));
				jsonArray.put(jsonObject);				
			}
		}catch(Exception e){
			e.printStackTrace();
			System.out.println("Error in get SortCenterName "+e.toString());
		}	
		finally{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}	
		return jsonArray;

	}

	public JSONArray getHubNames(int cutomerId, int systemId) {

		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject = new JSONObject();
		Connection con=null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		try{
			con = DBConnection.getConnectionToDB("AMS");
			jsonArray = new JSONArray();
			jsonObject = new JSONObject();
			pstmt = con.prepareStatement(getHubNames);
			pstmt.setInt(1,systemId);
			pstmt.setInt(2,cutomerId);
			rs=pstmt.executeQuery();
			Set<String> set = new LinkedHashSet<String>();
			while(rs.next()){
				
				String name=rs.getString("NAME");
				String[] list = name.split(",");
				set.add(list[1]);
								
			}
			ArrayList<String>  lst =  new ArrayList<String>();
			lst.addAll(set);
			Collections.sort(lst);
			Iterator<String> itr = lst.iterator();
			while(itr.hasNext()){
				jsonObject = new JSONObject();
				jsonObject.put("Name", itr.next());
				jsonArray.put(jsonObject);
				
			}
		}catch(Exception e){
			e.printStackTrace();
			System.out.println("Error in getting hub names "+e.toString());
		}	
		finally{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}	
		return jsonArray;

	}

	public JSONArray getAmazonReportDetails(int systemId,int clientId,String startDate,String endDate,int offset){
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonobject = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int count=0;
		SimpleDateFormat sdf=new SimpleDateFormat("dd/MM/yyyy HH:mm");
		SimpleDateFormat sdf1=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		
		try {
			startDate=sdf1.format(sdf.parse(startDate));
			endDate=sdf1.format(sdf.parse(endDate));
			jsonArray = new JSONArray();
			con = DBConnection.getConnectionToDB("AMS");
	
			pstmt = con.prepareStatement(AMAZON_REPORT_DETAILS);
			pstmt.setInt(1, offset);
			pstmt.setString(2, startDate);
			pstmt.setInt(3, offset);
			pstmt.setString(4, endDate);
			
			rs = pstmt.executeQuery();
			while (rs.next()) {
				count++;
				jsonobject = new JSONObject();
				jsonobject.put("slNoIndex", count);
				jsonobject.put("vendorNameIndex", rs.getString("Vendor_Name"));
				jsonobject.put("noOfVehiclesAmzT4uIndex", rs.getString("No_Of_Vehicles_t4u_AMZ"));
				jsonobject.put("noOfPingsIndex", rs.getString("No_Of_Pings"));
			    jsonArray.put(jsonobject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jsonArray;
	}
	public JSONArray getAmazonDateTimeReportDetails(int systemId,int clientId,String startDate,String endDate){
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonobject = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int count=0;
		SimpleDateFormat sdf=new SimpleDateFormat("dd/MM/yyyy HH:mm");
		SimpleDateFormat sdf1=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		
		try {
			startDate=sdf1.format(sdf.parse(startDate));
			endDate=sdf1.format(sdf.parse(endDate));
			jsonArray = new JSONArray();
			con = DBConnection.getConnectionToDB("AMS");
	
			pstmt = con.prepareStatement(AMAZON_DATETIME_WISE_DETAILS);
			pstmt.setString(1, startDate);
			pstmt.setString(2, endDate);
			
			rs = pstmt.executeQuery();
			while (rs.next()) {
				count++;
				jsonobject = new JSONObject();
				jsonobject.put("slNoIndex", count);
				jsonobject.put("vendorNameIndex", rs.getString("Vendor_Name"));
				jsonobject.put("noOfVehiclesAmzT4uIndex", rs.getString("No_Of_Vehicles_t4u_AMZ"));
				jsonobject.put("noOfPingsIndex", rs.getString("No_Of_Pings"));
			    jsonArray.put(jsonobject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jsonArray;
	}
	
	public JSONArray getVehicleAndVendorCount(int systemId,int clientId,String startDate,String endDate){
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonobject = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		SimpleDateFormat sdf=new SimpleDateFormat("dd/MM/yyyy HH:mm");
		SimpleDateFormat sdf1=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		
		try {
			startDate=sdf1.format(sdf.parse(startDate));
			endDate=sdf1.format(sdf.parse(endDate));
			jsonArray = new JSONArray();
			con = DBConnection.getConnectionToDB("AMS");
	
			pstmt = con.prepareStatement(VEHICLE_COUNT_DETAILS);
			pstmt.setString(1, startDate);
			pstmt.setString(2, endDate);
			
			rs = pstmt.executeQuery();
			if (rs.next()) {
				jsonobject = new JSONObject();
				jsonobject.put("VehicleCount", rs.getString("VehicleCount"));
			    jsonArray.put(jsonobject);
			}
			else
			{
				jsonobject = new JSONObject();
				jsonobject.put("VehicleCount", "0");
			    jsonArray.put(jsonobject);
			}
			
			pstmt = con.prepareStatement(VENDOR_COUNT_DETAILS);
			pstmt.setString(1, startDate);
			pstmt.setString(2, endDate);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				jsonobject = new JSONObject();
				jsonobject.put("VendorCount", rs.getString("VendorCount"));
			    jsonArray.put(jsonobject);
			}
			else
			{
				jsonobject = new JSONObject();
				jsonobject.put("VendorCount", "0");
			    jsonArray.put(jsonobject);
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		System.out.println(jsonArray);
		return jsonArray;
	}
	public JSONArray getAmazonDateWiseReportDetails(int systemId,int clientId,String startDate){
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonobject = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int count=0;
		SimpleDateFormat sdf=new SimpleDateFormat("dd/MM/yy");
		SimpleDateFormat sdf1=new SimpleDateFormat("yyyy-MM-dd");
		
		try {
			Date date = sdf.parse(startDate);
			startDate=sdf1.format(date);
			
			jsonArray = new JSONArray();
			con = DBConnection.getConnectionToDB("AMS");
	
			pstmt = con.prepareStatement(AMAZON_DATE_WISE_DETAILS);
			pstmt.setString(1, startDate);
			
			rs = pstmt.executeQuery();
			while (rs.next()) {
				count++;
				jsonobject = new JSONObject();
				jsonobject.put("slNoIndex", count);
				jsonobject.put("vendorNameIndex", rs.getString("VENDOR_NAME"));
				jsonobject.put("noOfVehiclesAmzT4uIndex", rs.getString("NO_OF_VEHICLES"));
				jsonobject.put("noOfPingsIndex", rs.getString("NO_OF_PINGS"));
			    jsonArray.put(jsonobject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jsonArray;
	}
	public JSONArray getDateList(){
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonobject = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		SimpleDateFormat sdf=new SimpleDateFormat("dd/MM/yy");
		SimpleDateFormat sdf1=new SimpleDateFormat("yyyy-MM-dd");
		try{
			jsonArray = new JSONArray();
			con = DBConnection.getConnectionToDB("AMS");
	
			pstmt = con.prepareStatement(GET_DATE_TO_COMBO);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				jsonobject = new JSONObject();
				jsonobject.put("date", sdf.format(sdf1.parse(rs.getString("DATE"))));
			    jsonArray.put(jsonobject);
			}
		}
		catch(Exception e){
			e.printStackTrace();
		}
		finally {
				DBConnection.releaseConnectionToDB(con, pstmt, rs);
	    }
		return jsonArray;
	}
}
