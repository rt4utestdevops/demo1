package t4u.functions;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashSet;
import java.util.Set;
import java.util.concurrent.TimeUnit;

import org.json.JSONArray;
import org.json.JSONObject;

import t4u.common.DBConnection;
import t4u.statements.MileageandHBAnalysisStatements;

public class MileageandHBAnalysisFunctions {
	SimpleDateFormat yyyymmdd = new SimpleDateFormat("yyyy-MM-dd");
	SimpleDateFormat ddmmyyyy = new SimpleDateFormat("dd-MM-yyyy");
	SimpleDateFormat fromDataBase = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss.sss");
	SimpleDateFormat toUI = new SimpleDateFormat("dd-MM-yyyy HH:mm");
	
	
	public JSONArray getHBAnalysisForGraph(int systemId, int clientId, String startDate, String endDate, int offset,int cityId) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		PreparedStatement pstmt1 = null;
		ResultSet rs1 = null;
		JSONArray jArr = new JSONArray();
		JSONArray jArr1 = new JSONArray();
		JSONArray jArr2 = new JSONArray();
		JSONArray vehArray = new JSONArray();
		JSONObject obj = new JSONObject();;
		try{
			Date d1 = ddmmyyyy.parse(startDate);
			Date d2 = ddmmyyyy.parse(endDate);
			long diff = d2.getTime() - d1.getTime();
			int days = (int) TimeUnit.DAYS.convert(diff, TimeUnit.MILLISECONDS);
			long sDate = d1.getTime();
			for(int i = 0; i < days; i++){
				jArr1.put(ddmmyyyy.format(new Date(sDate+(i*86400000L))));
			}
			jArr.put(jArr1);
			con = DBConnection.getConnectionToDB("AMS");
			if(cityId == 0){
				pstmt = con.prepareStatement(MileageandHBAnalysisStatements.GET_REGISTRATION_NO_ALL);
				pstmt.setInt(1, systemId);
				pstmt.setInt(2, clientId);
				pstmt.setInt(3, offset);
				pstmt.setString(4, yyyymmdd.format(ddmmyyyy.parse(startDate)));
				pstmt.setInt(5, offset);
				pstmt.setString(6, yyyymmdd.format(ddmmyyyy.parse(endDate)));
			}else{
				pstmt = con.prepareStatement(MileageandHBAnalysisStatements.GET_REGISTRATION_NO_CITY_BASED);
				pstmt.setInt(1, systemId);
				pstmt.setInt(2, clientId);
				pstmt.setInt(3, cityId);
				pstmt.setInt(4, offset);
				pstmt.setString(5, yyyymmdd.format(ddmmyyyy.parse(startDate)));
				pstmt.setInt(6, offset);
				pstmt.setString(7, yyyymmdd.format(ddmmyyyy.parse(endDate)));
			}
			rs = pstmt.executeQuery();
			while(rs.next()){
				vehArray.put(rs.getString("registrationNo"));
				pstmt1 = con.prepareStatement(MileageandHBAnalysisStatements.GET_DAYWISE_VEHICLE_HB_DETAILS);
				pstmt1.setInt(1, offset);
				pstmt1.setString(2, rs.getString("registrationNo"));
				pstmt1.setInt(3, systemId);
				pstmt1.setInt(4, clientId);
				pstmt1.setInt(5, offset);
				pstmt1.setString(6, yyyymmdd.format(ddmmyyyy.parse(startDate)));
				pstmt1.setInt(7, offset);
				pstmt1.setString(8, yyyymmdd.format(ddmmyyyy.parse(endDate)));
				rs1 = pstmt1.executeQuery();
				while(rs1.next()){
					obj.put(rs1.getString("date"), Double.parseDouble(rs1.getString("mins")+"."+rs1.getString("sec")));
				}
				jArr2.put(obj);
				obj = new JSONObject();
			}
			jArr.put(jArr2);
			jArr.put(vehArray);
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
			DBConnection.releaseConnectionToDB(null, pstmt1, rs1);
		}
		return jArr;
	}
	public  JSONArray getDayWiseMileage(){
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonobject = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Set<String> set = new HashSet<String>();
		ArrayList<String> avgMileageList = null;
		ArrayList<ArrayList<String>> dataArray =new ArrayList<ArrayList<String>>();
		try {
			jsonArray = new JSONArray();
			jsonobject = new JSONObject();
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(MileageandHBAnalysisStatements.MODELWISE_AVERAGE_MILEAGE);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				avgMileageList =new ArrayList<String>();
				String modelType=rs.getString("MODEL_TYPE");
				String  date=rs.getString("DATE");
				String avgMileage=rs.getString("AverageMileage");
				avgMileageList.add(date);
				avgMileageList.add(avgMileage);
				set.add(modelType);
				dataArray.add(avgMileageList);
			}
			System.out.println(set);
			System.out.println(dataArray);
			jsonobject.put("models", set);
			jsonobject.put("data", dataArray);
			jsonArray.put(jsonobject);
		} catch (Exception e) {
			e.printStackTrace();
		}finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		
		return jsonArray;
	}
	public JSONArray getGroupNameList(int systemId, int clientId) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		JSONArray jArr = new JSONArray();
		JSONObject obj = null;
		try{
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(MileageandHBAnalysisStatements.GET_CITY_DETAILS);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, clientId);
			rs = pstmt.executeQuery();
			obj = new JSONObject();
			while(rs.next()){
				obj = new JSONObject();
				obj.put("cityId", rs.getInt("cityId"));
				obj.put("cityName", rs.getString("cityName"));
				jArr.put(obj);
			}
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}return jArr;
	}
	 public  JSONArray getVechileWiseMileage(String city,String modelName,int systemId,int clientId){
			JSONArray jsonArray = new JSONArray();
			JSONObject jsonobject = new JSONObject();
			Connection con = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			try {
				jsonArray = new JSONArray();
				con = DBConnection.getConnectionToDB("AMS");
				pstmt = con.prepareStatement(MileageandHBAnalysisStatements.VECHILEWISE_REFUEL_AND_MILEAGE_SUMMARY);
				pstmt.setString(1, city);
				pstmt.setString(2,modelName);
				pstmt.setInt(3,systemId);
				pstmt.setInt(4,clientId);
				rs = pstmt.executeQuery();
				int slno=0;
				while (rs.next()) {
					jsonobject = new JSONObject();
					String vehicleNo=rs.getString("REGISTRATION_NO");
					long toatlRecords= rs.getLong("TOTAL_RECORDS");
					double mileage=rs.getDouble("AverageMileage");
					jsonobject.put("slno", ++slno);
					jsonobject.put("vehicleNo", vehicleNo);
					if(toatlRecords==1){
						jsonobject.put("mileage", 0);
						//jsonobject.put("details", "<a href='VehicleMileageAndRefuelSummary.jsp?vehicleNo="+vehicleNo+"' class='btn btn-info btn-xs' id="+vehicleNo+" role='button' disable >Details</a>");
					}else{
						jsonobject.put("mileage", mileage);
						//jsonobject.put("details", "<a href='VehicleMileageAndRefuelSummary.jsp?vehicleNo="+vehicleNo+"' class='btn btn-info btn-xs' id="+vehicleNo+" role='button'>Details</a>");
					}
					jsonobject.put("details", "<a href='VehicleMileageAndRefuelSummary.jsp?vehicleNo="+vehicleNo+"' class='btn btn-info btn-xs' id="+vehicleNo+" role='button' >Details</a>");
					jsonArray.put(jsonobject);
					
				}
				
			} catch (Exception e) {
				e.printStackTrace();
			}finally {
				DBConnection.releaseConnectionToDB(con, pstmt, rs);
			}
			
			return jsonArray;
		}
		 
		 public  JSONArray getVehicleFuelSummary(String vehicleNo,int systemId,int clientId){
				JSONArray jsonArray = new JSONArray();
				JSONObject jsonobject = new JSONObject();
				Connection con = null;
				PreparedStatement pstmt = null;
				ResultSet rs = null;
				try {
					jsonArray = new JSONArray();
					con = DBConnection.getConnectionToDB("AMS");
					pstmt = con.prepareStatement(MileageandHBAnalysisStatements.VEHICLE_REFUEL_DATA);
					pstmt.setString(1, vehicleNo);
					pstmt.setInt(2,systemId);
					pstmt.setInt(3,clientId);
					rs = pstmt.executeQuery();
					int slno=0;
					boolean firstRecord=true;
					while (rs.next()) {
						double refuelQty=(rs.getDouble("FUEL_QTY")-rs.getDouble("FUEL_QTY_BEFORE_REFURL"));
						if(firstRecord){
							firstRecord=false;
							String refuleDate = toUI.format(fromDataBase.parse(rs.getString("REFUEL_DATE_TIME")));
							jsonobject = new JSONObject();
							jsonobject.put("slno", ++slno);
							jsonobject.put("refuleDate", refuleDate);
							jsonobject.put("fuelQty", rs.getDouble("FUEL_QTY"));
							jsonobject.put("fuelConsumed", 0);
							jsonobject.put("beforeRefuel", 0);
							jsonobject.put("refuelInLtrs", 0);
							jsonobject.put("mileage", 0);
							jsonobject.put("odmeter", rs.getDouble("ODOMETER"));
							jsonobject.put("distanceTravelled", 0);
							jsonobject.put("refuelDuration", 0);
							jsonArray.put(jsonobject);
						}else{
							String refuleDate = toUI.format(fromDataBase.parse(rs.getString("REFUEL_DATE_TIME")));
							jsonobject = new JSONObject();
							jsonobject.put("slno", ++slno);
							jsonobject.put("refuleDate", refuleDate);
							jsonobject.put("fuelQty", rs.getDouble("FUEL_QTY"));
							jsonobject.put("fuelConsumed", rs.getDouble("FUEL_CONSUMED"));
							jsonobject.put("beforeRefuel", rs.getDouble("FUEL_QTY_BEFORE_REFURL"));
							jsonobject.put("refuelInLtrs", refuelQty);
							jsonobject.put("mileage", rs.getDouble("MILEAGE"));
							jsonobject.put("odmeter", rs.getDouble("ODOMETER"));
							jsonobject.put("distanceTravelled", rs.getDouble("DISTANCE_TRAVELLED"));
							jsonobject.put("refuelDuration", rs.getLong("REFUEL_DURATION"));
							jsonArray.put(jsonobject);
						}

					}
					
				} catch (Exception e) {
					e.printStackTrace();
				}finally {
					DBConnection.releaseConnectionToDB(con, pstmt, rs);
				}
				return jsonArray;
		 }	
		 
		 public  JSONArray getCityWiseAvgMileage(int systemId,int clientId){
				JSONArray jsonArray = new JSONArray();
				JSONObject jsonobject = new JSONObject();
				Connection con = null;
				PreparedStatement pstmt = null;
				ResultSet rs = null;
				try {
					jsonArray = new JSONArray();
					con = DBConnection.getConnectionToDB("AMS");
					pstmt = con.prepareStatement(MileageandHBAnalysisStatements.CITY_WISE_MILEAGE);
					pstmt.setInt(1,systemId);
					pstmt.setInt(2,clientId);
					rs = pstmt.executeQuery();
					int slno=0;
					while (rs.next()) {
						jsonobject = new JSONObject();
						String city=rs.getString("CITY");
						String modelName=rs.getString("MODEL_NAME");
						jsonobject.put("slno", ++slno);
						jsonobject.put("city", city);
						jsonobject.put("mileage", rs.getDouble("AverageMileage"));
						jsonobject.put("modelName", modelName);
						jsonobject.put("modelType", rs.getString("MODEL_TYPE"));
						jsonobject.put("vehicleCount", rs.getString("vehiclecount"));
						jsonobject.put("startDate", rs.getString("startDate"));
						jsonobject.put("endDate", rs.getString("endDate"));
						jsonobject.put("details", "<a href='CityAndModelWiseRefuelSummary.jsp?City="+city+"&ModelName="+modelName+"' class='btn btn-info btn-xs' role='button'>Show Vehicles</a> ");
						jsonArray.put(jsonobject);
					}
					
				} catch (Exception e) {
					e.printStackTrace();
				}finally {
					DBConnection.releaseConnectionToDB(con, pstmt, rs);
				}
				return jsonArray;
		 }
		 
		 /*added on 10-10-2017 */
		 public  JSONArray getHbCountReport(int systemId,int clientId,int offset,int cityId,String startDate,String endDate){
			
				JSONArray jsonArray = new JSONArray();
				JSONObject jsonobject = new JSONObject();
				Connection con = null;
				PreparedStatement pstmt = null;
				ResultSet rs = null;
				DecimalFormat df = new DecimalFormat("#.00");
				try {
					jsonArray = new JSONArray();
					 String s1=yyyymmdd.format(ddmmyyyy.parse(startDate))+" 00:00:00";
					 String e1=yyyymmdd.format(ddmmyyyy.parse(endDate))+" 23:59:59";
					con = DBConnection.getConnectionToDB("AMS");
					if(cityId==0){
						pstmt = con.prepareStatement(MileageandHBAnalysisStatements.GET_HB_COUNT_ALL_CITY);
						pstmt.setInt(1,offset);
						pstmt.setString(2,s1);
						pstmt.setInt(3,offset);
						pstmt.setString(4,e1);
						pstmt.setInt(5,systemId);
						pstmt.setInt(6,clientId);
						rs = pstmt.executeQuery();
					}else{
						pstmt = con.prepareStatement(MileageandHBAnalysisStatements.GET_HB_COUNT_CITY);
						pstmt.setInt(1,offset);
						pstmt.setString(2,s1);
						pstmt.setInt(3,offset);
						pstmt.setString(4,e1);
						pstmt.setInt(5,systemId);
						pstmt.setInt(6,clientId);
						pstmt.setInt(7,cityId);
						rs = pstmt.executeQuery();
					}
					
					int slno=0;
					while (rs.next()) {
						jsonobject = new JSONObject();
						int sec = rs.getInt("total_avg");
						int minutes = sec/60;
						int seconds = sec%60;
						String timeinmis=minutes+":"+seconds;
						jsonobject.put("slno", ++slno);
						jsonobject.put("regNo", rs.getString("REGISTRATION_NO"));
						jsonobject.put("count", rs.getDouble("COUNT"));
						jsonobject.put("totalAvg", sec);
						jsonobject.put("totalAvginMins", timeinmis);
						jsonArray.put(jsonobject);
					}
					
				} catch (Exception e) {
					e.printStackTrace();
				}finally {
					DBConnection.releaseConnectionToDB(con, pstmt, rs);
				}
				return jsonArray;
		 }
		 
		 public  JSONArray getHarshBrakHeatMapLatLng(int systemId,int clientId){
				JSONArray jsonArray = new JSONArray();
				JSONObject jsonobject = new JSONObject();
				Connection con = null;
				PreparedStatement pstmt = null;
				ResultSet rs = null;
				try {
					jsonArray = new JSONArray();
					con = DBConnection.getConnectionToDB("AMS");
					pstmt = con.prepareStatement(MileageandHBAnalysisStatements.HARSH_BRAKE_HEAP_MAP_POINTS);
					pstmt.setInt(1,systemId);
					pstmt.setInt(2,clientId);
					pstmt.setInt(3,systemId);
					pstmt.setInt(4,clientId);
					rs = pstmt.executeQuery();
					while (rs.next()) {
						jsonobject = new JSONObject();
						double lat=rs.getDouble("LATITUDE");
						double lng=rs.getDouble("LONGITUDE");
						jsonobject.put("lat",lat);
						jsonobject.put("lng",lng);
						jsonArray.put(jsonobject);
					}
				} catch (Exception e) {
					e.printStackTrace();
				}finally {
					DBConnection.releaseConnectionToDB(con, pstmt, rs);
				}
				return jsonArray;
			}
		 

}
