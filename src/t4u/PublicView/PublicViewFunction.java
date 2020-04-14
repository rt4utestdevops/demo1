package t4u.PublicView;

import java.io.PrintWriter;
import java.io.StringWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.LinkedList;
import java.util.Properties;

import org.json.JSONArray;
import org.json.JSONObject;

import com.t4u.activity.VehicleActivity;
import com.t4u.activity.VehicleSummaryBean;
import com.t4u.activity.VehicleActivity.DataListBean;


import t4u.common.ApplicationListener;
import t4u.common.DBConnection;

public class PublicViewFunction {
	
	public static final String DAY_WISE_DISTANCE=" select sum(TotalDistanceTravelled) as TotalDistanceTravelled from AMS.dbo.VehicleSummaryData where " +
	"convert(varchar(10),dateadd(mi,?,DateGMT),120) between convert(varchar(10),GETDATE()-?,120) and convert(varchar(10),GETDATE()-?,120) and  "+
	"  SystemId=? ";
	
	private static DecimalFormat df2 = new DecimalFormat(".##");
	
	public JSONArray getEvehicleInfo(int systemId, int offset) {
		Connection con=null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		JSONArray jsonArray = new JSONArray();
		JSONObject json = null;
		double slat=22.928962;
		double slng=79.262249;
		double totalDistance=0.0;
	
		try {
			con=DBConnection.getConnectionToDB("AMS");
			pstmt=con.prepareStatement(" select REGISTRATION_NO,isnull(LONGITUDE,'') as LONGITUDE ,isnull(LATITUDE,'') as LATITUDE ,convert(varchar(10),getdate()-1,120)+ ' 18:29:59' as startGmt ,getutcdate() as GMT ,CLIENTID  from AMS.dbo.gpsdata_history_latest where System_id=? ");
			pstmt.setInt(1, systemId);
			rs=pstmt.executeQuery();
			while(rs.next()) {
				json = new JSONObject();
				double lat=rs.getDouble("LATITUDE");
				double lng=rs.getDouble("LONGITUDE");
				String vehicleNo=rs.getString("REGISTRATION_NO");
				/*int customerId=rs.getInt("CLIENTID");
				String endDate=rs.getString("GMT");
				String startDate=rs.getString("startGmt");*/
				json.put("RegNo", vehicleNo);
				json.put("lat", lat);
				json.put("lng", lng);
				int zone=bearingBetweenLocations(slat, slng, lat, lng);
			//	totalDistance+=getDistance(con, vehicleNo, startDate, endDate, systemId, customerId);
				json.put("zone", ++zone);
				jsonArray.put(json);
			}
			if(rs!=null){
				totalDistance+=getDistanceFromDayWise(con, 1, 30, systemId,offset);
			}
			if(totalDistance>0){
				long fuelSaved = (long) totalDistance/20;
				long FuelCostSaved  = (long)fuelSaved * 67;
				json = new JSONObject();
				json.put("fuelSaved", fuelSaved);
				json.put("FuelCostSaved", FuelCostSaved);
				json.put("co2inTon", round((totalDistance*0.000178667),2));
				json.put("co2inkg", round((totalDistance*0.178666667),2));
				json.put("distance", totalDistance);
				jsonArray.put(json);
				System.out.println(jsonArray);
			}else{
			//	long fuelSaved = (long) totalDistance/20;
				//long FuelCostSaved  = (long)fuelSaved * 67;
				json = new JSONObject();
				json.put("fuelSaved", 0);
				json.put("FuelCostSaved", 0);
				json.put("co2", 0);
				jsonArray.put(json);
			}

		} catch (Exception e) {
			e.printStackTrace();
		}
		//System.out.println(jsonArray);
		return jsonArray;
	}
	
	public  double getDistanceFromDayWise(Connection con,int day1,int day2,int systemId,int offset){
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		double distance=0.0;
		Properties properties =null;
		try {
		    properties = ApplicationListener.prop;
			String startDay = properties.getProperty("eeslStartDayNo");
			String endDay = properties.getProperty("eeslEndDayNo");
			if(startDay!=null){
				day1=Integer.parseInt(startDay);
			}if(endDay!=null){
				day2=Integer.parseInt(endDay);
			}
			pstmt = con.prepareStatement(DAY_WISE_DISTANCE);
			pstmt.setInt(1, offset);
			pstmt.setInt(2, day2);
			pstmt.setInt(3,  day1);
			pstmt.setInt(4,  systemId);
			rs=pstmt.executeQuery();
			if(rs.next()){
				distance+=  rs.getDouble("TotalDistanceTravelled");
			}
		}catch (Exception e) {
			e.printStackTrace();
			StringWriter errors = new StringWriter();
			e.printStackTrace(new PrintWriter(errors));
			//WriteTologFile("Method Name : getDistanceFromDayWise \n"+errors.toString());
		}finally{
			DBConnection.releaseConnectionToDB(null, pstmt, rs);
		}
		return distance;
	}
	
	public double getDistance(Connection con,String vehicleNo,String startDate,String endDate,int systemId,int customerId){
		double distance=0.0;
		try {
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			VehicleActivity vi = new VehicleActivity(con,vehicleNo, sdf.parse(startDate), sdf.parse(endDate), 0, systemId, customerId, 0);
			LinkedList<DataListBean> activityReportList = vi.getFinalList();
			if (activityReportList.size() > 0) {
				VehicleSummaryBean vehicleSummaryBean = vi.getVehicleSummaryBean();
				distance = vehicleSummaryBean.getTotalDistanceTravelled();
			}
		} catch (Exception e) {
			e.printStackTrace();
			StringWriter errors = new StringWriter();
			e.printStackTrace(new PrintWriter(errors));
			//WriteTologFile("Method Name : getDistance \n"+errors.toString());

		}
		return distance;
	}
	public static String getdate(String input,int day){
		String date="";
		SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
		try {
			Date myDate = dateFormat.parse(input);
			Calendar cal1 = Calendar.getInstance();
			cal1.setTime(myDate);
			cal1.add(Calendar.DAY_OF_YEAR, day);
			Date previousDate = cal1.getTime();
			date=dateFormat.format(previousDate);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return date;
	}
	
	public static int bearingBetweenLocations(double slat ,double slng,double dlat, double dlng) {
		double PI = 3.14159;
		double lat1 = slat * PI / 180;
		double long1 = slng * PI / 180;
		double lat2 = dlat * PI / 180;
		double long2 = dlng * PI / 180;

		double dLon = (long2 - long1);

		double y = Math.sin(dLon) * Math.cos(lat2);
		double x = Math.cos(lat1) * Math.sin(lat2) - Math.sin(lat1)
		* Math.cos(lat2) * Math.cos(dLon);

		double brng = Math.atan2(y, x);

		brng = Math.toDegrees(brng);
		//  System.out.print(l++ +"----"+brng+"----------");
		brng = (brng + 360) % 360;
		brng = (360-brng)+90;
		//   System.out.println("--------------------------"+brng);
		int zone=0;
		if(brng>0 && brng<90){
			zone=1;
		}
		else if(brng>90 && brng<180){
			zone=2;
		}else if(brng>180 && brng<270){
			zone=3;
		}else if(brng>270 && brng<360){
			zone=4;
		}else if(brng==450){
			zone=0;
		}

		return zone;
	}	
	
	public static double round(double value, int places) {
	    if (places < 0) throw new IllegalArgumentException();

	    long factor = (long) Math.pow(10, places);
	    value = value * factor;
	    long tmp = Math.round(value);
	    return (double) tmp / factor;
	}

}
