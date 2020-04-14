package t4u.functions;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;

import org.json.JSONArray;
import org.json.JSONObject;

import t4u.common.DBConnection;


public class VehicleTrackingHistory {
	
	public static final String GET_HISTORY_DATA="select LONGITUDE,LATITUDE,SPEED,ISNULL(LOCATION,'') AS LOCATION,GPS_DATETIME "+
	"from AMS.dbo.HISTORY_DATA_262 "+
	"WHERE REGISTRATION_NO=?  "+
	"AND GPS_DATETIME between  ?  and ?   "+
	"and System_id=? and CLIENTID=? "+
	"order by GPS_DATETIME ";
		
	public JSONArray getVehicleTrackingHistory(String vehicleNo,String startDateTime,String endDateTime,int offSet,int systemId,int clientId,int userid) {
		Connection con=null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		Date d1 = new Date(); 
		int size=0;
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject1 = null;
		JSONObject jsonObject2 = null;
		JSONObject jsonObject3 = null;
		JSONObject jsonObject4 = null;
		JSONObject jsonObject5 = null;
		SimpleDateFormat ddmmyyyy1 = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
		SimpleDateFormat ddmmyyyy = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
		SimpleDateFormat yyyymmdd = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
		SimpleDateFormat yyyymmddhhmm = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		try {
			ArrayList datalist = new ArrayList();
			ArrayList infolist = new ArrayList();
			ArrayList distanceList = new ArrayList();
			
			String sdate= yyyymmddhhmm.format(ddmmyyyy.parse(startDateTime));
			String eDate = yyyymmddhhmm.format(ddmmyyyy.parse(endDateTime));
			
		con=DBConnection.getConnectionToDB("AMS");
		pstmt=con.prepareStatement(GET_HISTORY_DATA);
		pstmt.setString(1, vehicleNo);
		pstmt.setString(2, sdate);
		pstmt.setString(3, eDate);
		pstmt.setInt(4, systemId);
		pstmt.setInt(5, clientId);
		rs=pstmt.executeQuery();
		while(rs.next()){
		double	latitude=rs.getDouble("LATITUDE");
		double	longitude=rs.getDouble("LONGITUDE");
		int	speed=rs.getInt("SPEED");
		String loc=rs.getString("LOCATION");
		String dateTime=rs.getString("GPS_DATETIME");
		
		datalist.add(latitude);
		datalist.add(longitude);
		datalist.add("0"); // stop or idle : jar dependent
		
		infolist.add("'" + ddmmyyyy1.format(yyyymmddhhmm.parse(dateTime)) + "'");
		infolist.add(latitude);
		infolist.add(longitude);
		infolist.add("'"+ loc.toString().trim().replace("'", " ")+ "'");
		infolist.add(speed);
		infolist.add("0.0");
		
		distanceList.add("0");
		
		}
		jsonObject1 = new JSONObject();
		jsonObject2 = new JSONObject();
		jsonObject3 = new JSONObject();
		jsonObject4 = new JSONObject();
		jsonObject5 = new JSONObject();
		
		size=distanceList.size();
		jsonObject1.put("datalist", datalist);
		jsonObject2.put("infolist", infolist);
		jsonObject3.put("distanceList", distanceList);
		jsonObject4.put("startDate",yyyymmdd.format(ddmmyyyy.parse(startDateTime)));
		jsonObject5.put("endDate",yyyymmdd.format(ddmmyyyy.parse(endDateTime)));
		
		jsonArray.put(jsonObject1);
		jsonArray.put(jsonObject2);
		jsonArray.put(jsonObject3);
		jsonArray.put(jsonObject4);
		jsonArray.put(jsonObject5);
		
			
		} catch (Exception e) {
			e.printStackTrace();
		}finally{
			Date d2 = new Date();
			long diff=d2.getTime()-d1.getTime();
			System.out.println(diff);
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		
		//System.out.println(size+":::"+jsonArray);
		return jsonArray;
	}

}
