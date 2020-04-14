package t4u.functions;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.LinkedList;
import java.util.Map;
import java.util.Set;

import org.json.JSONArray;
import org.json.JSONObject;

import com.t4u.activity.VehicleActivity;
import com.t4u.activity.VehicleSummaryBean;
import com.t4u.activity.VehicleActivity.DataListBean;

import t4u.common.DBConnection;

public class DriverPerformanceReport {

	public static final String GET_TRIP_DETAILS=" SELECT  ROUTE_NAME,SHIPMENT_ID,ACTUAL_TRIP_START_TIME,ACTUAL_TRIP_END_TIME,ASSET_NUMBER From AMS.dbo.TRACK_TRIP_DETAILS "+
	" where STATUS IN ('CLOSED','CANCEL') AND  "+
	" SYSTEM_ID=?  and CUSTOMER_ID=? AND ACTUAL_TRIP_START_TIME IS NOT NULL AND "+
	" ACTUAL_TRIP_START_TIME Between dateadd(mi,-?,? ) and   dateadd(mi,-?,? ) and  "+
	" ACTUAL_TRIP_END_TIME Between dateadd(mi,-?,? ) and dateadd(mi,-?,? )  "+
	" order by ASSET_NUMBER  ";

	public static final String GET_DRIVER_DETAILS=" select a.Driver_id as DRIVER_ID ,isnull(a.Fullname,'') as DRIVER_NAME,isnull(dv.DATE_TIME,'') as STARTTIME,getutcdate() as END_TIME   "+
	" from Driver_Vehicle dv   "+
	" inner join AMS.dbo.Driver_Master a on a.Driver_id = dv.DRIVER_ID and a.System_id=dv.SYSTEM_ID   "+
	" where dv.DATE_TIME BETWEEN ? and ? AND  dv.SYSTEM_ID=? and   dv.REGISTRATION_NO=?  "+
	" union all   "+
	" select a.Driver_id as DRIVER_ID ,isnull(a.Fullname,'') as DRIVER_NAME,isnull(dv.FROM_DATE_TIME,'') as STARTTIME,TO_DATE_TIME as END_TIME   "+
	" from DRIVER_VEHICLE_HISTORY dv   "+
	" inner join AMS.dbo.Driver_Master a on a.Driver_id = dv.DRIVER_ID and a.System_id=dv.SYSTEM_ID   "+
	" where   (dv.FROM_DATE_TIME BETWEEN ? and ? or dv.TO_DATE_TIME BETWEEN ? and ? )  "+
	" and dv.SYSTEM_ID=? and   dv.REGISTRATION_NO=?              "+
	" order by STARTTIME   ASC   ";

	public static final String GET_ALERTS=" select count(*) as Total_ALERT_COUNT,ALERT_TYPE   "+
	" from TRIP_EVENT_DETAILS   "+
	" where ALERT_TYPE in (2,105,58,106)   "+
	" and VEHICLE_NO=? and GMT between ? and ?  "+
	" and SYSTEM_ID=? "+
	" group by ALERT_TYPE   ";


	public static final String GET_MAKE_MODEL=" select fvm.ModelName,fvm.VEHICLE_MAKE   "+
	" 	from AMS.dbo.GPSDATA_LIVE_CANIQ a      "+
	" 	inner join AMS.dbo.tblVehicleMaster vm on vm.VehicleNo=a.REGISTRATION_NO     "+
	" 	inner join FMS.dbo.Vehicle_Model fvm on fvm.ModelTypeId=vm.Model     "+
	" 	where a.System_id=? and REGISTRATION_NO=?  ";


	public JSONArray GetDriverPerformance(int clientId, int systemId, int offset, String startDate, String endDate) {
		Connection con = null;
		JSONArray jsonArray=null;
		try {
			System.out.println("---------starts-------");
			con = DBConnection.getConnectionToDB("AMS");
			jsonArray = GetTripDetails(con, clientId,  systemId,  offset,  startDate,  endDate);
		} catch (Exception e) {
			e.printStackTrace();
		}
		finally{
			DBConnection.releaseConnectionToDB(con, null, null);
			System.out.println("-------ends------------");
		}
		return jsonArray;
	}


	//method to get the TripDetails
	public JSONArray GetTripDetails(Connection con,int clientId, int systemId, int offset, String startDate, String endDate) {
		JSONArray jsonArray = null;
		JSONObject jsonobject = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			jsonArray = new JSONArray();
			int count=0;
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(GET_TRIP_DETAILS);
			pstmt.setInt(1,systemId);
			pstmt.setInt(2, clientId);
			pstmt.setInt(3, offset);
			pstmt.setString(4,startDate);
			pstmt.setInt(5, offset);
			pstmt.setString(6, endDate);
			pstmt.setInt(7, offset);
			pstmt.setString(8,startDate);
			pstmt.setInt(9, offset);
			pstmt.setString(10, endDate);
			rs = pstmt.executeQuery();
			while(rs.next()){
				String tripId=rs.getString("SHIPMENT_ID");
				String tripStartTime=rs.getString("ACTUAL_TRIP_START_TIME");
				String tripEndtime=rs.getString("ACTUAL_TRIP_END_TIME");
				String vehicleNumber=rs.getString("ASSET_NUMBER");
				String routeName=rs.getString("ROUTE_NAME");
				String make=GetModel(con, systemId, vehicleNumber);

				Map<String, ArrayList<Integer>> performanceReportMap = GetDriverDetails(con,systemId,tripStartTime,tripEndtime,vehicleNumber,clientId);

				if(!performanceReportMap.equals(null)){
					Set<String> driverset=performanceReportMap.keySet();
					Iterator<String> driverName = driverset.iterator();
					while(driverName.hasNext()){
						String driverName1=driverName.next();
						ArrayList<Integer> alertList=performanceReportMap.get(driverName1);
						//System.out.println("\n---------------------------------------");
						//System.out.println(driverName1);
						String[] name= driverName1.split("#");
						jsonobject = new JSONObject();
						jsonobject.put("slno", ++count);
						jsonobject.put("tripId", tripId);
						jsonobject.put("date", "date");
						jsonobject.put("driverName", name[0]);
						jsonobject.put("regNo", vehicleNumber);
						jsonobject.put("make", make);
						jsonobject.put("from", routeName);
						jsonobject.put("to", routeName);
						jsonobject.put("totalAlert", alertList.get(4));
						jsonobject.put("ha", alertList.get(1));
						jsonobject.put("hb", alertList.get(2));
						jsonobject.put("hc", alertList.get(3));
						jsonobject.put("overSpeed", alertList.get(0));
						jsonobject.put("onTimePerformance", 0);
						jsonobject.put("kmsTravelled", alertList.get(5));
						jsonobject.put("mileage", 0);
						jsonobject.put("avgSpeed", alertList.get(6));
						jsonobject.put("maxSpeed", alertList.get(7));
						jsonArray.put(jsonobject);


						//System.out.println("---------------------------------------\n");
					}
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		finally{
			DBConnection.releaseConnectionToDB(null, pstmt, rs);
		}
		return jsonArray;
	}

	//method to get the driver details
	public Map<String, ArrayList<Integer>> GetDriverDetails(Connection con,int systemId, String startDate, String endDate,String vehicleNo,int clientId) {
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Map<String, ArrayList<Integer>> driverMap =null;
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(GET_DRIVER_DETAILS);
			pstmt.setString(1,startDate);
			pstmt.setString(2,endDate);
			pstmt.setInt(3,systemId);
			pstmt.setString(4,vehicleNo);
			pstmt.setString(5,startDate);
			pstmt.setString(6,endDate);
			pstmt.setString(7,startDate);
			pstmt.setString(8,endDate);
			pstmt.setInt(9,systemId);
			pstmt.setString(10,vehicleNo);
			rs = pstmt.executeQuery();
			driverMap = new HashMap<String, ArrayList<Integer>>();
			int uniqueId=0;
			while(rs.next()){
				++uniqueId;
				//	int driverId=rs.getInt("DRIVER_ID");
				String driverName=rs.getString("DRIVER_NAME");
				driverName = driverName+"#"+uniqueId;
				String startTime=rs.getString("STARTTIME");
				String endTime=rs.getString("END_TIME");
				ArrayList<Integer> alertList = GetAlertDetails(con,systemId,startTime, endTime,vehicleNo,clientId);
				driverMap.put(driverName, alertList);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		finally{
			DBConnection.releaseConnectionToDB(null, pstmt, rs);
		}
		return driverMap;
	}


	//method to get the alertDetails
	public ArrayList<Integer> GetAlertDetails(Connection con,int systemId, String startDate, String endDate,String vehicleNo,int clientId) {
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		ArrayList<Integer> alerts = null;
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(GET_ALERTS);
			pstmt.setString(1,vehicleNo);
			pstmt.setString(2,startDate);
			pstmt.setString(3,endDate);
			pstmt.setInt(4,systemId);
			rs = pstmt.executeQuery();
			int overspeed=0;
			int ha=0;
			int hb=0;
			int hc=0;
			int total=0;
			int totalKm=0;
			int avgSpeed=0;
			int maxSpeed=0;
			alerts = new ArrayList<Integer>();
			alerts.add(overspeed);  //0
			alerts.add(ha);  //1
			alerts.add(hb);  //2
			alerts.add(hc);   //3
			alerts.add(total);  //4
			alerts.add(totalKm);  //5
			alerts.add(avgSpeed);  //6
			alerts.add(maxSpeed);  //7
			while(rs.next()){
				int alertType=rs.getInt("ALERT_TYPE");
				int alertCount=rs.getInt("Total_ALERT_COUNT");
				total+=alertCount;
				switch(alertType)
				{
				/*	case 1: stoppage=alertCount;
						break;*/
				case 2: overspeed=alertCount;
				alerts.set(0, overspeed);
				break;
				/*case 5: routeDeviaton=alertCount;
						break;*/
				case 58: hb=alertCount;
				alerts.set(2, hb);
				break;
				case 105: ha=alertCount;
				alerts.set(1, ha);
				break;
				case 106: hc=alertCount;
				alerts.set(3, hc);
				break;
				}
			}


			alerts.set(4, total);
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			VehicleActivity vi = new VehicleActivity(con,vehicleNo, sdf.parse(startDate), sdf.parse(endDate), 0, systemId, clientId, 0);
			LinkedList<DataListBean> activityReportList = vi.getFinalList();
			if (activityReportList.size() > 0) {
				VehicleSummaryBean vehicleSummaryBean = vi.getVehicleSummaryBean();
				totalKm=(int)vehicleSummaryBean.getTotalDistanceTravelled();
				avgSpeed=(int)vehicleSummaryBean.getAverageSpeedExcludingStoppageInKMPH();
				maxSpeed=(int)vehicleSummaryBean.getMaxSpeedInKMPH();
				alerts.set(5, totalKm);
				alerts.set(6, avgSpeed);
				alerts.set(7, maxSpeed);

			}

		} catch (Exception e) {
			e.printStackTrace();
		}
		finally{
			DBConnection.releaseConnectionToDB(null, pstmt, rs);
		}

		return alerts;
	}


	//method to get the make of the vehicle
	public String GetModel(Connection con,int systemId,String vehicleNo) {
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String make="";
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(GET_MAKE_MODEL);
			pstmt.setInt(1,systemId);
			pstmt.setString(2,vehicleNo);
			rs = pstmt.executeQuery();
			if(rs.next()){
				make=rs.getString("VEHICLE_MAKE");
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		finally{
			DBConnection.releaseConnectionToDB(null, pstmt, rs);
		}
		return make;
	}


}
