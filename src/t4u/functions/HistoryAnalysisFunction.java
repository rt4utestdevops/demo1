package t4u.functions;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.text.DecimalFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.LinkedList;
import java.util.TimeZone;

import org.json.JSONArray;
import org.json.JSONObject;

import com.t4u.activity.VehicleActivity;
import com.t4u.activity.VehicleActivity.DataListBean;

import t4u.common.DBConnection;
import t4u.statements.HistoryAnalysisStatements;

public class HistoryAnalysisFunction {
	
	@SuppressWarnings("unchecked")
	public JSONArray getVehicleTrackingHistory(String vehicleNo,String startDateTime,String endDateTime,int offSet,int systemId,int clientId,long timeBandInMill,String recordForTwoMin,String recordForSixhrs,int userid ){

		CommonFunctions commonFunctions = new CommonFunctions();
		SimpleDateFormat sdf = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
		SimpleDateFormat yyyyMMdd = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		SimpleDateFormat ddmmyyyy = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
		SimpleDateFormat sdfFormatDate = new SimpleDateFormat("MM/dd/yyyy HH:mm:ss");
		//System.out.println(" came here for getVehicleTrackingHistory  function!!!!!!!1");
		//System.out.println(" userID ==== "+userid+"  systemId ====== "+systemId);
		boolean impreciseSetting = false;
		impreciseSetting = commonFunctions.CheckImpreciseSetting(userid, systemId);
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject1 = null;
		JSONObject jsonObject2 = null;
		JSONObject jsonObject3 = null;
		JSONObject jsonObject4 = null;
		JSONObject jsonObject5 = null;
		String startDate = "";
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		PreparedStatement pstmt1 = null;
		ResultSet rs1 = null;
		String complete = "no";
		con = DBConnection.getConnectionToDB("AMS");
		
		if(recordForTwoMin.equals("recordForTwoMin")){
			startDateTime = getFormattedDateStartingFromMonth(startDateTime);
			startDateTime = commonFunctions.getLocalDateTime(startDateTime, offSet);
			
			ddmmyyyy.setTimeZone(TimeZone.getTimeZone("UTC"));
			endDateTime = ddmmyyyy.format(new Date());	
			endDateTime = getFormattedDateStartingFromMonth(endDateTime);
			
		}else if(recordForSixhrs.equals("recordForSixhrs")){
			
			ddmmyyyy.setTimeZone(TimeZone.getTimeZone("UTC"));
			startDateTime = ddmmyyyy.format(new Date());
			Date gmtDateTime = null;
			try {
				gmtDateTime = ddmmyyyy.parse(startDateTime);
			} catch (ParseException e) {
				e.printStackTrace();
			}
			Calendar startCalendar = Calendar.getInstance();
			startCalendar.setTime(gmtDateTime);
			startCalendar.add(Calendar.HOUR,-6);
			startDate = ddmmyyyy.format(startCalendar.getTime());
			startDateTime = getFormattedDateStartingFromMonth(startDate);
			startDate = startDateTime;
			
			ddmmyyyy.setTimeZone(TimeZone.getTimeZone("UTC"));
			endDateTime = ddmmyyyy.format(new Date());	
			endDateTime = getFormattedDateStartingFromMonth(endDateTime);
			
		}else if(recordForSixhrs.equals("recordForGivenDate")){
			
			startDateTime = getFormattedDateStartingFromMonth(startDateTime);
			startDateTime = commonFunctions.getGMTDateTime(startDateTime, offSet);
			endDateTime = getFormattedDateStartingFromMonth(endDateTime);
			endDateTime = commonFunctions.getGMTDateTime(endDateTime, offSet);
			
		}else if(recordForSixhrs.equals("recordForHalfAnhr")){
			int ignition = 0;
			float speed = 0;
			float speedLimit = 0;
			endDateTime = "01/01/1900 00:00:00";
			startDate = "01/01/1900 00:00:00";
			startDateTime = "01/01/1900 00:00:00";
			endDateTime = "01/01/1900 00:00:00";
			try {
				pstmt = con.prepareStatement(HistoryAnalysisStatements.GET_VEHICLE_STATUS);
				pstmt.setString(1, vehicleNo);
				rs = pstmt.executeQuery();
				while (rs.next()) {
					ignition = rs.getInt("IGNITION");
					speed = rs.getFloat("SPEED");
					speedLimit = rs.getFloat("SPEED_LIMIT");
				}
				if(clientId == 5179)
				{
					if(speed > speedLimit)
					{
						pstmt1 = con.prepareStatement(HistoryAnalysisStatements.GET_START_END_DATE.replace("dbo.HISTORY_DATA", "dbo.HISTORY_DATA_"+systemId));
						pstmt1.setString(1, vehicleNo);
						rs1 = pstmt1.executeQuery();
						while (rs1.next()) {
							ignition = rs1.getInt("IGNITION");
							speed = rs1.getFloat("SPEED");
							if(complete.equals("no"))
							{
								if(speed>speedLimit)
								{
									if(rs1.getRow()==1)
									{
										endDateTime = ddmmyyyy.format(yyyyMMdd.parse(rs1.getString("GMT")));
									} else {
										startDate = ddmmyyyy.format(yyyyMMdd.parse(rs1.getString("GMT")));
									}
								}else{
										startDate = ddmmyyyy.format(yyyyMMdd.parse(rs1.getString("GMT")));
										complete = "yes";
							    }
						    }
					   }
						startDateTime = getFormattedDateStartingFromMonth(startDate);
						endDateTime = getFormattedDateStartingFromMonth(endDateTime);
					}
				} else {
				if(ignition > 0)
				{
						pstmt1 = con.prepareStatement(HistoryAnalysisStatements.GET_START_END_DATE.replace("dbo.HISTORY_DATA", "dbo.HISTORY_DATA_"+systemId));
						pstmt1.setString(1, vehicleNo);
						rs1 = pstmt1.executeQuery();
						while (rs1.next()) {
							ignition = rs1.getInt("IGNITION");
							speed = rs1.getFloat("SPEED");
							if(complete.equals("no"))
							{
								if(ignition == 1)
								{
									if(rs1.getRow()==1)
									{
										endDateTime = ddmmyyyy.format(yyyyMMdd.parse(rs1.getString("GMT")));
									} else {
										startDate = ddmmyyyy.format(yyyyMMdd.parse(rs1.getString("GMT")));
									}
								}else{
										startDate = ddmmyyyy.format(yyyyMMdd.parse(rs1.getString("GMT")));
										complete = "yes";
							    }
						    }
					   }
						startDateTime = getFormattedDateStartingFromMonth(startDate);
						endDateTime = getFormattedDateStartingFromMonth(endDateTime);
				}
				
			} 
			}catch (Exception e) {
				e.printStackTrace();
			}
		}else{
			startDateTime = getFormattedDateStartingFromMonth(startDateTime);
			startDateTime = commonFunctions.getLocalDateTime(startDateTime, offSet);

			endDateTime = getFormattedDateStartingFromMonth(endDateTime);
			endDateTime = commonFunctions.getLocalDateTime(endDateTime, offSet);
		}
		//System.out.println(startDateTime+" "+endDateTime);
		
		String unitname ;
		double ConversionFactor;
		if(systemId==15){
		 ArrayList<String> list = GetVehicleIdDistanceUnitName(systemId, con,vehicleNo);		
		 unitname = list.get(1).toString();
		 ConversionFactor = Double.parseDouble(list.get(2).toString());
		}else{
		 ArrayList<String> list = getUnitDetails(systemId);
		 unitname = list.get(0).toString();
		 ConversionFactor = Double.parseDouble(list.get(1).toString());
		}
		try {
			LinkedList<DataListBean> HistoryAnalysis = new LinkedList<DataListBean>();
			VehicleActivity vi = null;
			 if(impreciseSetting == true){
				  System.out.println(" imprecise true!!!!!!!!!!!");
				  vi = new VehicleActivity(con, vehicleNo, sdfFormatDate.parse(startDateTime), sdfFormatDate.parse(endDateTime),offSet, systemId, clientId, timeBandInMill,userid);
				  }else{
				  vi = new VehicleActivity(con, vehicleNo, sdfFormatDate.parse(startDateTime), sdfFormatDate.parse(endDateTime),offSet, systemId, clientId, timeBandInMill);
				  }
				  HistoryAnalysis = vi.getFinalList();
	
			ArrayList pointslist = new ArrayList();
			ArrayList returnList = new ArrayList();
			ArrayList sortedList = new ArrayList();
			ArrayList distanceList = new ArrayList();
		
			
			
		
			jsonObject1 = new JSONObject();
			jsonObject2 = new JSONObject();
			jsonObject3 = new JSONObject();
			jsonObject4 = new JSONObject();
			jsonObject5 = new JSONObject();
			
			DecimalFormat df = new DecimalFormat("#.##");
			
			for (int i = 0; i < HistoryAnalysis.size(); i++) {
				
				String location = "";
				DataListBean dlb = HistoryAnalysis.get(i);

				double latitude = dlb.getLatitude();
				double longitude = dlb.getLongitude();

				if (latitude != 0 && longitude != 0) {
					if (dlb.getLocation() != null) {
						location = dlb.getLocation().toString();
					}
					String dateTime = sdf.format(dlb.getGpsDateTime());
					String speed = df.format(dlb.getSpeed() * ConversionFactor);
					long stopVal = dlb.getStopTime();
					long idleVal = dlb.getIdleTime();
					String distanceTravelled = df.format(dlb.getDistanceTravelled()* ConversionFactor);
					distanceList.add(distanceTravelled);
					returnList.add(latitude);
					returnList.add(longitude);
					// if(stopVal > 0 || idleVal > 0)
					if (stopVal > 0) {
						// stop record
						returnList.add("1");
					} else if (idleVal > 0) {
						// idle record
						returnList.add("3");
					} else if (location.contains("OVERSPEED")) {
						returnList.add("2");
					} else {
						returnList.add("0");
					}

					sortedList.add("'" + dateTime + "'");
					sortedList.add(latitude);
					sortedList.add(longitude);
					if(recordForSixhrs.equals("recordForHalfAnhr") && i==(HistoryAnalysis.size()-1) && location.toString().trim().equals(""))
					{
						if(impreciseSetting == true){
							  System.out.println(" imprecise true!!!!!!!!!!!");
								pstmt1 = con.prepareStatement(HistoryAnalysisStatements.GET_LIVE_LOCATION_FOR_IMPRECISE_LOCATION);
							  }else{
							   pstmt1 = con.prepareStatement(HistoryAnalysisStatements.GET_LIVE_LOCATION); 
							  }
						
						pstmt1.setString(1, vehicleNo);
						pstmt1.setInt(2, systemId);
						rs1 = pstmt1.executeQuery();
						if(rs1.next())
						{
							sortedList.add("'"+ rs1.getString("LOCATION").toString().trim().replace("'", " ")+ "'");
						} else {
							sortedList.add("'"+ location.toString().trim().replace("'", " ")+ "'");
						}
					} else {
						sortedList.add("'"+ location.toString().trim().replace("'", " ")+ "'");
					}
					sortedList.add(Double.parseDouble(speed));

					if (stopVal > 0) {
						stopVal = stopVal / (60 * 1000);
						String stopformat = HrsMinsFormat(stopVal);
						sortedList.add(stopformat);
					} else {
						idleVal = idleVal / (60 * 1000);
						String idleformat = HrsMinsFormat(idleVal);
						sortedList.add(idleformat);
					}
					if(i == (HistoryAnalysis.size()-1)){
						SimpleDateFormat mmddyyyy = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
						SimpleDateFormat yyyymmdd = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
						String stDate = "";
						if(!startDate.equals("")){
							Calendar cal = Calendar.getInstance();
							cal.setTime(sdfFormatDate.parse(startDate));
							cal.add(Calendar.MINUTE, offSet);
							stDate = yyyymmdd.format(cal.getTime());
							
						}
						jsonObject4.put("startDate",stDate);
						String endDate = yyyymmdd.format(mmddyyyy.parse(dateTime));
						jsonObject5.put("endDate",endDate );
						
					}
				}
			}
			pointslist.add(returnList);
			pointslist.add(sortedList);
			pointslist.add(distanceList);
			
		

			jsonObject1.put("datalist", (ArrayList) pointslist.get(0));
			jsonObject2.put("infolist", (ArrayList) pointslist.get(1));
			jsonObject3.put("distanceList", (ArrayList) pointslist.get(2));
			
			
			jsonArray.put(jsonObject1);
			jsonArray.put(jsonObject2);
			jsonArray.put(jsonObject3);
			jsonArray.put(jsonObject4);
			jsonArray.put(jsonObject5);
			
		} catch (Exception e) {
			System.out.println("Exception in History tracking : " + e);
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, null, null);
		}
		return jsonArray;
		
	}
	public JSONArray getVehicles(int userid,int customerId, int systemId,int ltsp) {

		JSONArray VehicleDetailsArray = new JSONArray();
		JSONObject VehicleDetailsObject = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			VehicleDetailsArray = new JSONArray();
			con = DBConnection.getConnectionToDB("AMS");
			if(ltsp == 0 && customerId == 0){
				pstmt = con.prepareStatement(HistoryAnalysisStatements.GET_ALL_VEHICLE_FOR_LTSP);
				pstmt.setInt(1, systemId);
				pstmt.setInt(2, userid);
			}else if(ltsp == 0 && customerId > 0){
				pstmt = con.prepareStatement(HistoryAnalysisStatements.GET_ALL_VEHICLE_FOR_CLIENT_WITH_ACTIVE.concat("order by a.VehicleNo"));
				pstmt.setInt(1, userid);
				pstmt.setInt(2, systemId);
				pstmt.setInt(3, customerId);
			}else{
				pstmt = con.prepareStatement(HistoryAnalysisStatements.GET_ALL_VEHICLE_FOR_CLIENT_WITH_ACTIVE.concat(" and  a.Status='Active' order by a.VehicleNo "));
				pstmt.setInt(1, userid);
				pstmt.setInt(2, systemId);
				pstmt.setInt(3, customerId);
			}
			rs = pstmt.executeQuery();
			while (rs.next()) {
				VehicleDetailsObject = new JSONObject();	
				if(!rs.getString("VEHICLE_ID").equals(""))
				{
					VehicleDetailsObject.put("vehicleNo", rs.getString("REGISTRATION_NO")+"["+rs.getString("VEHICLE_ID")+"]");	
					VehicleDetailsArray.put(VehicleDetailsObject);
				} else {
					VehicleDetailsObject.put("vehicleNo", rs.getString("REGISTRATION_NO"));	
					VehicleDetailsArray.put(VehicleDetailsObject);
				}
			}			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return VehicleDetailsArray;
	}
	
	@SuppressWarnings("unchecked")
	public ArrayList getDistanceUnitDetail(int SystemId, String VehicleNo) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		double distanceConversionFactor = 1.0;
		String distanceUnitName = "kms";
		ArrayList DistanceUnitDetail = new ArrayList();
		try{
		con= DBConnection.getConnectionToDB("AMS");
		pstmt=con.prepareStatement(HistoryAnalysisStatements.GET_DISTANCE_CONVERSION_FACTOR_FROM_VEHICLE_TYPE);
		pstmt.setInt(1, SystemId);
		pstmt.setString(2, VehicleNo);
		rs = pstmt.executeQuery();
		while(rs.next())
		{
			distanceUnitName = rs.getString("UnitName");
			distanceConversionFactor = rs.getDouble("ConversionFactor");			
		}
		DistanceUnitDetail.add(distanceUnitName);
		DistanceUnitDetail.add(distanceConversionFactor);
		}
		catch (Exception e) 
		{
			e.printStackTrace();
		}
		finally
		{
			DBConnection.releaseConnectionToDB(con,pstmt,rs);
		}
		return DistanceUnitDetail;
	}
	
	public ArrayList getUnitDetails(int SystemId) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String distanceConversionFactor = "1";
		String distanceUnitName = "kms";
		ArrayList DistanceUnitDetail = new ArrayList();
		try{
		con= DBConnection.getConnectionToDB("AMS");
		pstmt=con.prepareStatement("select UnitName,ConversionFactor from tblDistanceUnitMaster where UnitId = (select DistanceUnitId from System_Master where System_id=?)");
		pstmt.setInt(1, SystemId);
		rs = pstmt.executeQuery();
		while(rs.next())
		{
			distanceUnitName = rs.getString("UnitName");
			distanceConversionFactor = rs.getString("ConversionFactor");			
		}
		DistanceUnitDetail.add(distanceUnitName);
		DistanceUnitDetail.add(distanceConversionFactor);
		}
		catch (Exception e) 
		{
			e.printStackTrace();
		}
		finally
		{
			DBConnection.releaseConnectionToDB(con,pstmt,rs);
		}
		return DistanceUnitDetail;
	}
	public ArrayList<String> GetVehicleIdDistanceUnitName(int SystemId,Connection con, String registrationNo) {
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String distanceUnitName;
		double distanceConversionFactor;
		@SuppressWarnings("unused")
		double distCorrectionFactor;
		distanceConversionFactor = 1.0;
		distanceUnitName = "kms";
		String vehicleid = "";
		ArrayList<String> list = new ArrayList<String>();
		try {
			pstmt = con.prepareStatement(HistoryAnalysisStatements.GET_DISTANCE_CONVERSION_FACTOR_FROM_VEHICLE_TYPES);
			pstmt.setInt(1, SystemId);
			pstmt.setString(2, registrationNo);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				vehicleid = rs.getString("VehicleAlias");
				distanceUnitName = rs.getString("UnitName");
				distanceConversionFactor = rs.getDouble("ConversionFactor");
			}
			list.add(vehicleid);
			list.add(distanceUnitName);
			list.add(String.valueOf(distanceConversionFactor));
			DBConnection.releaseConnectionToDB(null, pstmt, rs);
		} catch (Exception e) {
			DBConnection.releaseConnectionToDB(null, pstmt, rs);
			e.printStackTrace();
		}
		return list;
	}

	public String getFormattedDateStartingFromMonth(String inputDate) {
		String formattedDate = "";
		SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
		SimpleDateFormat sdfFormatDate = new SimpleDateFormat("MM/dd/yyyy HH:mm:ss");
		SimpleDateFormat sdf1 = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
		
		try {
			if (inputDate != null && !inputDate.equals("")) {
				boolean fmt2= inputDate.contains("-");
				java.util.Date d = (fmt2)?sdf1.parse(inputDate):sdf.parse(inputDate);
				formattedDate = sdfFormatDate.format(d);
			}
		} catch (Exception e) {
			System.out.println("Error in getFormattedDateStartingFromMonth() method"+ e);
			e.printStackTrace();
		}
		return formattedDate;
	}

	public String HrsMinsFormat(long stopIdleMinute) {
		String stopDura = "0.0";
		String minstr = "0";
		try {
			if (stopIdleMinute > 0) {
				long hour = stopIdleMinute / 60;
				long min = stopIdleMinute % 60;

				if (min < 10) {
					minstr = "0" + min;
				} else {
					minstr = String.valueOf(min);
				}
				stopDura = String.valueOf(hour) + "." + minstr;
			}
		} catch (Exception e) {
			System.out.println("Exception in daysHrsMinsFormat(): " + e);
		}
		return stopDura;
	}
	
	public JSONArray getOptionNames()
	{
		JSONArray optionDetailsArray = new JSONArray();
		JSONObject optionDetailsObject = new JSONObject();
		try {
				optionDetailsObject.put("optionIdIndex", 1);
				optionDetailsObject.put("optionNameIndex", "Trace Path");
				optionDetailsArray.put(optionDetailsObject);
				optionDetailsObject = new JSONObject();
				optionDetailsObject.put("optionIdIndex", 2);
				optionDetailsObject.put("optionNameIndex", "Speed");
				optionDetailsArray.put(optionDetailsObject);
				optionDetailsObject = new JSONObject();
				optionDetailsObject.put("optionIdIndex", 3);
				optionDetailsObject.put("optionNameIndex", "Hubs");
				optionDetailsArray.put(optionDetailsObject);
				optionDetailsObject = new JSONObject();
				optionDetailsObject.put("optionIdIndex", 4);
				optionDetailsObject.put("optionNameIndex", "Boarders");
				optionDetailsArray.put(optionDetailsObject);
				optionDetailsObject = new JSONObject();
				optionDetailsObject.put("optionIdIndex", 5);
				optionDetailsObject.put("optionNameIndex", "Stop/Idle");
				optionDetailsArray.put(optionDetailsObject);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
		}
		return optionDetailsArray;
	}
	
	public JSONArray getVehicleTrackingHistoryMaps(String vehicleNo,String startDateTime,String endDateTime,int offSet,int systemId,int clientId,long timeBandInMill,
			String recordForTwoMin,String recordForSixhrs,int userid, String reqStartTime){
		//t4u506
		CommonFunctions commonFunctions = new CommonFunctions();
		SimpleDateFormat sdf = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
		SimpleDateFormat yyyyMMdd = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		SimpleDateFormat ddmmyyyy = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
		SimpleDateFormat sdfFormatDate = new SimpleDateFormat("MM/dd/yyyy HH:mm:ss");
		//System.out.println(" came here for getVehicleTrackingHistory  function!!!!!!!1");
		//System.out.println(" userID ==== "+userid+"  systemId ====== "+systemId);
		boolean impreciseSetting = false;
		impreciseSetting = commonFunctions.CheckImpreciseSetting(userid, systemId);
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject1 = null;
		JSONObject jsonObject2 = null;
		JSONObject jsonObject3 = null;
		JSONObject jsonObject4 = null;
		JSONObject jsonObject5 = null;
		String startDate = "";
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		PreparedStatement pstmt1 = null;
		ResultSet rs1 = null;
		String complete = "no";
		con = DBConnection.getConnectionToDB("AMS");
		
		if(recordForTwoMin.equals("recordForTwoMin")){
			startDateTime = getFormattedDateStartingFromMonth(startDateTime);
			startDateTime = commonFunctions.getLocalDateTime(startDateTime, offSet);
			
			ddmmyyyy.setTimeZone(TimeZone.getTimeZone("UTC"));
			endDateTime = ddmmyyyy.format(new Date());	
			endDateTime = getFormattedDateStartingFromMonth(endDateTime);
			
		}else if(recordForSixhrs.equals("recordForSixhrs")){
			
			ddmmyyyy.setTimeZone(TimeZone.getTimeZone("UTC"));
			startDateTime = ddmmyyyy.format(new Date());
			Date gmtDateTime = null;
			try {
				gmtDateTime = ddmmyyyy.parse(startDateTime);
			} catch (ParseException e) {
				e.printStackTrace();
			}
			Calendar startCalendar = Calendar.getInstance();
			startCalendar.setTime(gmtDateTime);
			startCalendar.add(Calendar.HOUR,-6);
			startDate = ddmmyyyy.format(startCalendar.getTime());
			startDateTime = getFormattedDateStartingFromMonth(startDate);
			startDate = startDateTime;
			
			ddmmyyyy.setTimeZone(TimeZone.getTimeZone("UTC"));
			endDateTime = ddmmyyyy.format(new Date());	
			endDateTime = getFormattedDateStartingFromMonth(endDateTime);
			
		}else if(recordForSixhrs.equals("recordForGivenDate")){
			
			startDateTime = getFormattedDateStartingFromMonth(startDateTime);
			startDateTime = commonFunctions.getGMTDateTime(startDateTime, offSet);
			endDateTime = getFormattedDateStartingFromMonth(endDateTime);
			endDateTime = commonFunctions.getGMTDateTime(endDateTime, offSet);
			
		}else if(recordForSixhrs.equals("recordForHalfAnhr")){
			int ignition = 0;
			float speed = 0;
			float speedLimit = 0;
			endDateTime = "01/01/1900 00:00:00";
			startDate = "01/01/1900 00:00:00";
			startDateTime = "01/01/1900 00:00:00";
			endDateTime = "01/01/1900 00:00:00";
			try {
				pstmt = con.prepareStatement(HistoryAnalysisStatements.GET_VEHICLE_STATUS);
				pstmt.setString(1, vehicleNo);
				rs = pstmt.executeQuery();
				while (rs.next()) {
					ignition = rs.getInt("IGNITION");
					speed = rs.getFloat("SPEED");
					speedLimit = rs.getFloat("SPEED_LIMIT");
				}
				if(clientId == 5179)
				{
					if(speed > speedLimit)
					{
						pstmt1 = con.prepareStatement(HistoryAnalysisStatements.GET_START_END_DATE.replace("dbo.HISTORY_DATA", "dbo.HISTORY_DATA_"+systemId));
						pstmt1.setString(1, vehicleNo);
						rs1 = pstmt1.executeQuery();
						while (rs1.next()) {
							ignition = rs1.getInt("IGNITION");
							speed = rs1.getFloat("SPEED");
							if(complete.equals("no"))
							{
								if(speed>speedLimit)
								{
									if(rs1.getRow()==1)
									{
										endDateTime = ddmmyyyy.format(yyyyMMdd.parse(rs1.getString("GMT")));
									} else {
										startDate = ddmmyyyy.format(yyyyMMdd.parse(rs1.getString("GMT")));
									}
								}else{
										startDate = ddmmyyyy.format(yyyyMMdd.parse(rs1.getString("GMT")));
										complete = "yes";
							    }
						    }
					   }
						startDateTime = getFormattedDateStartingFromMonth(startDate);
						endDateTime = getFormattedDateStartingFromMonth(endDateTime);
					}
				} else {
				if(ignition > 0)
				{
						pstmt1 = con.prepareStatement(HistoryAnalysisStatements.GET_START_END_DATE.replace("dbo.HISTORY_DATA", "dbo.HISTORY_DATA_"+systemId));
						pstmt1.setString(1, vehicleNo);
						rs1 = pstmt1.executeQuery();
						while (rs1.next()) {
							ignition = rs1.getInt("IGNITION");
							speed = rs1.getFloat("SPEED");
							if(complete.equals("no"))
							{
								if(ignition == 1)
								{
									if(rs1.getRow()==1)
									{
										endDateTime = ddmmyyyy.format(yyyyMMdd.parse(rs1.getString("GMT")));
									} else {
										startDate = ddmmyyyy.format(yyyyMMdd.parse(rs1.getString("GMT")));
									}
								}else{
										startDate = ddmmyyyy.format(yyyyMMdd.parse(rs1.getString("GMT")));
										complete = "yes";
							    }
						    }
					   }
						startDateTime = getFormattedDateStartingFromMonth(startDate);
						endDateTime = getFormattedDateStartingFromMonth(endDateTime);
				}
				
			} 
			}catch (Exception e) {
				e.printStackTrace();
			}
		}else{
			startDateTime = getFormattedDateStartingFromMonth(startDateTime);
			startDateTime = commonFunctions.getLocalDateTime(startDateTime, offSet);

			endDateTime = getFormattedDateStartingFromMonth(endDateTime);
			endDateTime = commonFunctions.getLocalDateTime(endDateTime, offSet);
		}
		//System.out.println(startDateTime+" "+endDateTime);
		
		String unitname ;
		double ConversionFactor;
		if(systemId==15){
		 ArrayList<String> list = GetVehicleIdDistanceUnitName(systemId, con,vehicleNo);		
		 unitname = list.get(1).toString();
		 ConversionFactor = Double.parseDouble(list.get(2).toString());
		}else{
		 ArrayList<String> list = getUnitDetails(systemId);
		 unitname = list.get(0).toString();
		 ConversionFactor = Double.parseDouble(list.get(1).toString());
		}
		try {
			LinkedList<DataListBean> HistoryAnalysis = new LinkedList<DataListBean>();
			VehicleActivity vi = null;
			 if(impreciseSetting == true){
				  System.out.println(" imprecise true!!!!!!!!!!!");
				  vi = new VehicleActivity(con, vehicleNo, sdfFormatDate.parse(startDateTime), sdfFormatDate.parse(endDateTime),offSet, systemId, clientId, timeBandInMill,userid);
				  }else{
				  vi = new VehicleActivity(con, vehicleNo, sdfFormatDate.parse(startDateTime), sdfFormatDate.parse(endDateTime),offSet, systemId, clientId, timeBandInMill);
				  }
				  HistoryAnalysis = vi.getFinalList();
	
			ArrayList pointslist = new ArrayList();
			ArrayList returnList = new ArrayList();
			ArrayList sortedList = new ArrayList();
			ArrayList distanceList = new ArrayList();
		
			
			
		
			jsonObject1 = new JSONObject();
			jsonObject2 = new JSONObject();
			jsonObject3 = new JSONObject();
			jsonObject4 = new JSONObject();
			jsonObject5 = new JSONObject();
			
			DecimalFormat df = new DecimalFormat("#.##");
			
			for (int i = 0; i < HistoryAnalysis.size(); i++) {
				
				String location = "";
				DataListBean dlb = HistoryAnalysis.get(i);

				double latitude = dlb.getLatitude();
				double longitude = dlb.getLongitude();

				if (latitude != 0 && longitude != 0) {
					if (dlb.getLocation() != null) {
						location = dlb.getLocation().toString();
					}
					String dateTime = sdf.format(dlb.getGpsDateTime());
					String speed = df.format(dlb.getSpeed() * ConversionFactor);
					long stopVal = dlb.getStopTime();
					long idleVal = dlb.getIdleTime();
					String distanceTravelled = df.format(dlb.getDistanceTravelled()* ConversionFactor);
					distanceList.add(distanceTravelled);
					returnList.add(latitude);
					returnList.add(longitude);
					// if(stopVal > 0 || idleVal > 0)
					if (stopVal > 0) {
						// stop record
						returnList.add("1");
					} else if (idleVal > 0) {
						// idle record
						returnList.add("3");
					} else if (location.contains("OVERSPEED")) {
						returnList.add("2");
					} else {
						returnList.add("0");
					}

					sortedList.add("'" + dateTime + "'");
					sortedList.add(latitude);
					sortedList.add(longitude);
					if(recordForSixhrs.equals("recordForHalfAnhr") && i==(HistoryAnalysis.size()-1) && location.toString().trim().equals(""))
					{
						if(impreciseSetting == true){
							  System.out.println(" imprecise true!!!!!!!!!!!");
								pstmt1 = con.prepareStatement(HistoryAnalysisStatements.GET_LIVE_LOCATION_FOR_IMPRECISE_LOCATION);
							  }else{
							   pstmt1 = con.prepareStatement(HistoryAnalysisStatements.GET_LIVE_LOCATION); 
							  }
						
						pstmt1.setString(1, vehicleNo);
						pstmt1.setInt(2, systemId);
						rs1 = pstmt1.executeQuery();
						if(rs1.next())
						{
							sortedList.add("'"+ rs1.getString("LOCATION").toString().trim().replace("'", " ")+ "'");
						} else {
							sortedList.add("'"+ location.toString().trim().replace("'", " ")+ "'");
						}
					} else {
						sortedList.add("'"+ location.toString().trim().replace("'", " ")+ "'");
					}
					sortedList.add(Double.parseDouble(speed));

					if (stopVal > 0) {
						stopVal = stopVal / (60 * 1000);
						String stopformat = HrsMinsFormat(stopVal);
						sortedList.add(stopformat);
					} else {
						idleVal = idleVal / (60 * 1000);
						String idleformat = HrsMinsFormat(idleVal);
						sortedList.add(idleformat);
					}
					if(i == (HistoryAnalysis.size()-1)){
						SimpleDateFormat mmddyyyy = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
						SimpleDateFormat yyyymmdd = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
						String stDate = "";
						if(!startDate.equals("")){
							Calendar cal = Calendar.getInstance();
							cal.setTime(sdfFormatDate.parse(startDate));
							cal.add(Calendar.MINUTE, offSet);
							stDate = yyyymmdd.format(cal.getTime());
							
						}
						jsonObject4.put("startDate",stDate);
						String endDate = yyyymmdd.format(mmddyyyy.parse(dateTime));
						jsonObject5.put("endDate",endDate );
						
					}
				}
			}
			pointslist.add(returnList);
			pointslist.add(sortedList);
			pointslist.add(distanceList);
			
		

			jsonObject1.put("datalist", (ArrayList) pointslist.get(0));
			jsonObject2.put("infolist", (ArrayList) pointslist.get(1));
			jsonObject3.put("distanceList", (ArrayList) pointslist.get(2));
			//t4u506
		//	jsonObject6.put("reqresptime", (ArrayList) pointslist.get(3));
			
			jsonArray.put(jsonObject1);
			jsonArray.put(jsonObject2);
			jsonArray.put(jsonObject3);
			jsonArray.put(jsonObject4);
			jsonArray.put(jsonObject5);
			
		} catch (Exception e) {
			System.out.println("Exception in History tracking : " + e);
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, null, null);
		}
		return jsonArray;
		
	}
	
}
