package t4u.functions;

import java.sql.Connection;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.LinkedHashSet;
import java.util.List;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.DecimalFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;

import org.json.JSONArray;
import org.json.JSONObject;

import t4u.GeneralVertical.TemperatureBean;
import t4u.beans.ReportHelper;
import t4u.common.DBConnection;
import t4u.statements.HubReportStatements;


public class HubSummaryReportFunction {
	private static DecimalFormat df = new DecimalFormat("0.00");

	public JSONArray getAllHubs(int systemId, int clientId, int userId , int offset ) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		JSONObject jsObj = null;
		JSONArray jsArr = new JSONArray();
		try {  
			con = DBConnection.getConnectionToDB("AMS");
			String zone = getSystemZone(systemId);
			String query = getLocationQuery(
					HubReportStatements.GET_ALL_HUB_FOR_SUMMARY, zone);
			pstmt = con.prepareStatement(query);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, clientId);
			pstmt.setInt(3, userId);
			pstmt.setInt(4, systemId);
			rs = pstmt.executeQuery();
			jsObj = new JSONObject();
			jsObj.put("HubID", "0");
			jsObj.put("HubName", "ALL");
  		  	jsArr.put(jsObj);
			if(rs.next()){
			while(rs.next()){
				jsObj = new JSONObject();				
				jsObj.put("HubID", rs.getString("HUBID"));
				String hubName=rs.getString("NAME").replaceAll(",", "_");
				jsObj.put("HubName", hubName);	  		  
	  		  	jsArr.put(jsObj);
			}}else{
				query = getLocationQuery(
						HubReportStatements.GET_HUB_NAMES_FOR_CLIENT, zone);
				pstmt = con.prepareStatement(query);
				pstmt.setInt(1, systemId);
				pstmt.setInt(2, clientId);
				rs = pstmt.executeQuery();

				while (rs.next()) {
					jsObj = new JSONObject();				
					jsObj.put("HubID", rs.getString("HUBID"));
					String hubName=rs.getString("NAME").replaceAll(",", "_");
					jsObj.put("HubName", hubName);	  		  
		  		  	jsArr.put(jsObj);
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jsArr;
	}
	private String getLocationQuery(CharSequence query,String zone) {
		String retValue=query.toString();
	  	if(zone.equalsIgnoreCase("")){
	  		
	  	}
	  	else{
	  		retValue=query.toString().replaceAll("LOCATION","LOCATION_ZONE_"+zone);
	  	}
	  	
	  	return retValue;
	}
	private String getSystemZone(int systemId) {

		
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Connection con = null;
		String zone = "";
		try {
			
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(HubReportStatements.GET_ZONE);
			pstmt.setInt(1, systemId);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				if (rs.getString("Zone") != null
						&& !rs.getString("Zone").equals(""))
					zone = rs.getString("Zone");
			}
		} catch (Exception e) {
			System.out.println("Error in getSystemZone()." + e);
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return zone;
	
	}
	
	public JSONArray getAllGroups(int systemId, int clientId, int userId , int offset ) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		JSONObject jsObj = null;
		JSONArray jsArr = new JSONArray();
		try {  
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(HubReportStatements.GET_GROUP_NAME_FOR_CLIENT);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, clientId);
			pstmt.setInt(3, userId);
			rs = pstmt.executeQuery();
			jsObj = new JSONObject();
			jsObj.put("groupID", "0");
			jsObj.put("groupName", "ALL");
  		  	jsArr.put(jsObj);
			
			while(rs.next()){
				jsObj = new JSONObject();				
				jsObj.put("groupID", rs.getString("GROUP_ID"));
				jsObj.put("groupName", rs.getString("GROUP_NAME"));	  		
				jsArr.put(jsObj);
			}
			
  		  	
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jsArr;
	}
	
	public JSONArray getAllRegistration(int systemId, int clientId,int userId, String groupid) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		JSONObject jsObj = null;
		JSONArray jsArr = new JSONArray();
		String stmt = "";
		try {  
		con = DBConnection.getConnectionToDB("AMS");
		if (groupid != null && !groupid.equals("") && !groupid.equals("0")) {
			stmt = "select REGISTRATION_NUMBER from VEHICLE_CLIENT a, Vehicle_User b where a.SYSTEM_ID=? and a.CLIENT_ID=? and b.User_id=? and a.GROUP_ID=? and a.SYSTEM_ID = b.System_id and a.REGISTRATION_NUMBER = b.Registration_no order by REGISTRATION_NUMBER";
		} else {
			stmt = "select REGISTRATION_NUMBER from VEHICLE_CLIENT a, Vehicle_User b where a.SYSTEM_ID=? and a.CLIENT_ID=? and b.User_id=? and a.SYSTEM_ID = b.System_id and a.REGISTRATION_NUMBER = b.Registration_no order by REGISTRATION_NUMBER";
		}
		pstmt = con.prepareStatement(stmt);
		pstmt.setInt(1, systemId);
		pstmt.setInt(2, clientId);
		pstmt.setInt(3, userId);
		if (groupid != null && !groupid.equals("") && !groupid.equals("0")) {
			pstmt.setString(4, groupid);
			}
		rs = pstmt.executeQuery();
		jsObj = new JSONObject();
		jsObj.put("vehicleNo", "ALL");
		jsArr.put(jsObj);
		while (rs.next()) {
				jsObj = new JSONObject();			
				jsObj.put("vehicleNo", rs.getString("REGISTRATION_NUMBER"));
				jsArr.put(jsObj);
				}
			
			} catch (Exception e) {
				e.printStackTrace();
			} finally {
				DBConnection.releaseConnectionToDB(con, pstmt, rs);
			}
			return jsArr;
	}
	
	public ArrayList<Object>  getHubArrivalDetails(String HubId, String RegNo,String startdate, String enddate, int systemId, int clientId, int offset)  {
			JSONArray JsonArray = new JSONArray();
			JSONObject JsonObject = new JSONObject();
			Connection con = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			int count=0;
			String typeby = "RegNo";
			String names = null;
			DecimalFormat doubleDecimalFormat = new DecimalFormat("0.00");		
			ArrayList < ReportHelper > reportsList = new ArrayList < ReportHelper > ();
			 ArrayList < String > headersList = new ArrayList < String > ();
			 ReportHelper finalreporthelper = new ReportHelper();
			 ArrayList < Object > finlist = new ArrayList < Object > ();		 
			
			 try {

				 if(!HubId.trim().equalsIgnoreCase("")){
					 names=HubId;
					 typeby = "HubId";
				 }
				 else{
					 names=RegNo;
				 }
								 
				 String[] typeNames=null;
					typeNames=names.split(",");
					String typevalue="";
					for(String s:typeNames)
					{
						typevalue=typevalue+"'"+s+"'"+",";
					}
					typevalue = typevalue.substring(0, typevalue.length() - 1);
				//	System.out.println(typevalue);
					
				 headersList.add("SLNo");
				 headersList.add("Vehicle No");
				 headersList.add("Group Name");
				 headersList.add("Vehicle Type");				 
				 headersList.add("Vehicle Id");
				 headersList.add("No of times entered");
				 headersList.add("No of time Exited ");
				 headersList.add("Time Duration spent inside the Hub");
				 headersList.add("Time Duration spent outside the Hub");
				 headersList.add("Average Detention time");
				 headersList.add("Average Detention time out side");
				 
				JsonArray = new JSONArray();
				JsonObject = new JSONObject();
				
				con = DBConnection.getConnectionToDB("AMS");
				if(typeby.equalsIgnoreCase("HubId"))
				pstmt = con.prepareStatement(HubReportStatements.GET_ALL_HUB_DATA_FOR_SUMMARY.replace("$$", "HUB_ID in ("+typevalue+")")); 
				else
				pstmt = con.prepareStatement(HubReportStatements.GET_ALL_REGNO_DATA_FOR_SUMMARY.replace("##", "VEHICLE_NUMBER in ("+typevalue+")"));
				pstmt.setInt(1,offset);
				pstmt.setString(2,startdate);
				pstmt.setInt(3,offset);
				pstmt.setString(4,enddate);
				pstmt.setInt(5,offset);
				pstmt.setString(6,startdate);
				pstmt.setInt(7,offset);
				pstmt.setString(8,enddate);
				pstmt.setInt(9,systemId);
				pstmt.setInt(10,clientId);
				pstmt.setInt(11,offset);
				pstmt.setString(12,startdate);
				pstmt.setInt(13,offset);
				pstmt.setString(14,enddate);
				rs = pstmt.executeQuery();
				while (rs.next()){
					count++;
					JsonObject = new JSONObject();
					ArrayList < Object > informationList = new ArrayList < Object > ();
			        ReportHelper reporthelper = new ReportHelper();
			       
			        
					informationList.add(Integer.toString(count));
					JsonObject.put("slnoIndex", Integer.toString(count));
					
					JsonObject.put("VehNoId", rs.getString("VEHICLE_NUMBER"));	
					informationList.add(rs.getString("VEHICLE_NUMBER"));
					
					JsonObject.put("GroupnameId", rs.getString("GROUP_NAME"));
					informationList.add(rs.getString("GROUP_NAME"));
					
					JsonObject.put("VehTypeId", rs.getString("VEHICLE_TYPE"));
					informationList.add(rs.getString("VEHICLE_TYPE"));
							
					JsonObject.put("VehId", rs.getString("VEHICLE_ID"));
					informationList.add(rs.getString("VEHICLE_ID"));
							
					JsonObject.put("NooftimesenteredId", rs.getString("ACTUAL_ARRIVAL"));
					informationList.add(rs.getString("ACTUAL_ARRIVAL"));
							
					JsonObject.put("NooftimeExitedId", rs.getString("ACTUAL_DEPARTURE"));
					informationList.add(rs.getString("ACTUAL_DEPARTURE"));
					// add
					double insideDuration = Double.parseDouble(rs.getString("INSIDE_DURATION"));
					String insideDurations = AddTime((long) insideDuration);
					System.out.println(" insideDurations == "+insideDurations);
					JsonObject.put("DurationenteredId",insideDurations );
					informationList.add(insideDuration);
					// add	
					double outsideDuration = Double.parseDouble(rs.getString("OUTSIDE_DURATION"));
					String outsideDurations = AddTime((long) outsideDuration);
					System.out.println(" outsideDurations == "+outsideDurations);
					JsonObject.put("DurationExitedId", outsideDurations);
					informationList.add(outsideDurations);
					// add
					double AvgIntime =rs.getDouble("Average_detention_inside_time");	
					String AvgIntimes = AddTime((long) AvgIntime);
					System.out.println(" AvgIntimes == "+AvgIntimes);
					JsonObject.put("averagedetentiontimeId",AvgIntimes);
					informationList.add(AvgIntimes);
                    // add
					double AvgOuttime = rs.getDouble("Average_detention_outside_time");	
					String AvgOuttimes = AddTime((long) AvgOuttime);
					System.out.println(" AvgOuttimes == "+AvgOuttimes);
					JsonObject.put("averagedetentionouttimeId",AvgOuttimes);
					informationList.add(AvgOuttimes);
					
					
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
	
	private String AddTime(long totalTime){
		//String time1="19:01:30";
		//String time2="20:01:35";
		//long time = 152185000;
		int s = (int)((totalTime/=1000) % 60);
		int m = (int)((totalTime/=60) % 60);
		 int h = (int)(totalTime/=60);
		//System.out.format("%02d:%02d:%02d%n", h, m, s);
		String TotalTIme=h+":"+""+ m+":"+ s;
		return TotalTIme;
	}
	
	public ArrayList<Object> getSandTripSummaryDetails(String regNo, String startdate, String enddate, 
 int systemId, int clientId, int offset) {
		JSONArray JsonArray = new JSONArray();
		JSONObject JsonObject = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int count = 0;
		String oldRegNo = "";
		double oldDistance = 0;
		double srcDistTrav = 0;
		double destDistTrav = 0.0;
		double totalDist = 0;
		ArrayList<ReportHelper> reportsList = new ArrayList<ReportHelper>();
		ArrayList<String> headersList = new ArrayList<String>();
		ReportHelper finalreporthelper = new ReportHelper();
		ArrayList<Object> finlist = new ArrayList<Object>();
		boolean source = true;
		boolean dest = true;
		try {

			headersList.add("SLNo");
			headersList.add("Vehicle No");
			headersList.add("Vehicle Group");
			headersList.add("Owner Information");
			headersList.add("Date");
			headersList.add("Source");
			headersList.add("Source Lat Long");
			headersList.add("Destination");
			headersList.add("Destination Lat Long");
			headersList.add("DistanceTravelled(km)");
			headersList.add("Trip Count Per Day");

			headersList.add("Total Distance Travelled");
			headersList.add("Total Trip Count");

			JsonArray = new JSONArray();
			JsonObject = new JSONObject();
			ArrayList<Object> informationList = new ArrayList<Object>();
			ReportHelper reporthelper = new ReportHelper();
			LinkedHashSet<String> tempSet =new LinkedHashSet<String>();
			List<JSONObject>expList =null;
			List<TripSummaryBean> beanList =null;
			TripSummaryBean ieBean=null;
			expList = new ArrayList<JSONObject>();
			boolean value = false;

			String[] typeNames = null;
			typeNames = regNo.split(",");
			String typevalue = "";
			for (String s : typeNames) {
				typevalue = typevalue + "'" + s + "'" + ",";
			}
			typevalue = typevalue.substring(0, typevalue.length() - 1);

			con = DBConnection.getConnectionToDB("AMS");
			//System.out.println("started:; "+new Date());
			pstmt = con.prepareStatement(HubReportStatements.GET_REPORT_DATA.replace("$", typevalue));
			pstmt.setInt(1, clientId);
			pstmt.setInt(2, clientId);
			pstmt.setString(3, startdate);
			pstmt.setString(4, enddate);
			pstmt.setInt(5, systemId);
			pstmt.setInt(6, clientId);
			pstmt.setInt(7, clientId);
			pstmt.setString(8, startdate);
			pstmt.setString(9, enddate);
			pstmt.setInt(10, systemId);
			
			rs = pstmt.executeQuery();
			while(rs.next()) {
		    	JsonObject = new JSONObject();
				JsonObject.put("VehNoId", rs.getString("REGISTRATION_NO"));
				JsonObject.put("VehicleGroupId", rs.getString("GROUP_NAME"));
				JsonObject.put("OwnerId", rs.getString("OWNER_NAME"));
				JsonObject.put("DateId", rs.getString("ARRIVAL"));
				JsonObject.put("type", rs.getString("TYPE"));
				JsonObject.put("TotalDistanceTravlledId", df.format(totalDist));
				JsonObject.put("location", rs.getString("LOCATION"));
				JsonObject.put("latlong", rs.getString("LATITUDE")+","+rs.getString("LONGITUDE"));
				 
				int tripCount = getCount(con, rs.getString("REGISTRATION_NO"), rs.getString("ARRIVAL"));
				if (rs.getString("TYPE").equals("SOURCE")) {
					srcDistTrav = rs.getDouble("DISTANCE_TRAVELLED");
				} else if (rs.getString("TYPE").equals("DESTINATION")) {
					destDistTrav = rs.getDouble("DISTANCE_TRAVELLED");
				}
				totalDist = srcDistTrav + destDistTrav;
				JsonObject.put("DistanceTravlledId",df.format(totalDist));
				JsonObject.put("TripCountId", tripCount);
				expList.add(JsonObject);
		    	tempSet.add(rs.getString("REGISTRATION_NO")+"_"+rs.getString("ARRIVAL"));
			}
			String location="";
			String latlong="";
			beanList =new ArrayList<TripSummaryBean>();
		    for (String unique : tempSet) {
		    	ieBean =new TripSummaryBean();
		    	for (JSONObject obj : expList) {
		    		String data = obj.get("VehNoId")+"_"+obj.get("DateId");
		    		if(data.equals(unique)){
		    			if(obj.get("type").equals("SOURCE")){
		    				location = (String) obj.get("location");
		    				latlong = String.valueOf(obj.get("latlong"));
		    				ieBean.setSourceLocation(location);
		    				ieBean.setSourceLatlong(latlong);
		    			} else if (obj.get("type").equals("DESTINATION")) {
		    				location = (String) obj.get("location");
		    				latlong = String.valueOf(obj.get("latlong"));
		    				ieBean.setDestinationLocation(location);
		    				ieBean.setDestinationLatlong(latlong);
		    			}
		    			ieBean.setVehicleNo(obj.getString("VehNoId"));
		    			ieBean.setVehicleGroup(obj.getString("VehicleGroupId"));
		    			ieBean.setOwnerName(obj.getString("OwnerId"));
		    			ieBean.setDate(obj.getString("DateId"));
		    			ieBean.setDistance(obj.getString("DistanceTravlledId"));
		    			ieBean.setTripCount(obj.getString("TripCountId"));
		    		}
				}
		    	ieBean.setTotalDistance(0);
		    	ieBean.setTotalTrip(0);
		    	beanList.add(ieBean);		    	
			}
		    double totalTripDistance = 0.0;
	    	int totalTripCount = 0;
		    for(TripSummaryBean bean  : beanList) {
		    	count++;
				JsonObject = new JSONObject();
				informationList = new ArrayList<Object>();
				reporthelper = new ReportHelper(); 
				
				informationList.add(count);
				JsonObject.put("slnoIndex", count);

				JsonObject.put("VehNoId", bean.getVehicleNo());
				informationList.add(bean.getVehicleNo());

				JsonObject.put("VehicleGroupId", bean.getVehicleGroup());
				informationList.add(bean.getVehicleGroup());

				JsonObject.put("OwnerId", bean.getOwnerName());
				informationList.add(bean.getOwnerName());

				JsonObject.put("DateId", bean.getDate());
				informationList.add(bean.getDate());

				if(bean.getSourceLocation() == null) {
					JsonObject.put("SourceId", "");
					informationList.add("");
				}else {
					JsonObject.put("SourceId", bean.getSourceLocation());
					informationList.add(bean.getSourceLocation());
				}
				if(bean.getSourceLatlong() == null) {
					JsonObject.put("SourceLatLongId", "");
					informationList.add("");
				}else {
					JsonObject.put("SourceLatLongId", bean.getSourceLatlong());
					informationList.add(bean.getSourceLatlong());
				}
				if(bean.getDestinationLocation() == null) {
					JsonObject.put("DestinationId", "");
					informationList.add("");
				}else {
					JsonObject.put("DestinationId", bean.getDestinationLocation());
					informationList.add(bean.getDestinationLocation());
				}
				if(bean.getDestinationLatlong() == null) {
					JsonObject.put("DestinationLatLongId","");
					informationList.add("");
				}else {
					JsonObject.put("DestinationLatLongId", bean.getDestinationLatlong());
					informationList.add(bean.getDestinationLatlong());
				}
				JsonObject.put("DistanceTravlledId", bean.getDistance());
				informationList.add(bean.getDistance());
				
				JsonObject.put("TripCountId", bean.getTripCount());
				informationList.add(bean.getTripCount());

				JsonObject.put("TotalDistanceTravlledId", "");
				informationList.add("");

				JsonObject.put("TotalTripCountId", "");
				informationList.add("");
				
				double distance = Double.parseDouble(bean.getDistance());
				int tripCount = Integer.parseInt(bean.getTripCount());
				
				if (count != 1) {
					if (oldRegNo.equals(bean.getVehicleNo())) {
						totalTripDistance = totalTripDistance + Double.parseDouble(bean.getDistance());
						totalTripCount = totalTripCount + Integer.parseInt(bean.getTripCount());
						value = true;
					} else if (!oldRegNo.equals(bean.getVehicleNo()) && value) {
						JSONObject JsonObject1 = new JSONObject();
						ArrayList<Object> informationList1 = new ArrayList<Object>();
						ReportHelper reporthelper1 = new ReportHelper();
						count++;
						JsonObject1.put("slnoIndex", count);
						informationList1.add(count);
						JsonObject1.put("VehNoId", "");
						informationList1.add("");
						JsonObject1.put("VehicleGroupId", "");
						informationList1.add("");
						JsonObject1.put("OwnerId", "");
						informationList1.add("");
						JsonObject1.put("DateId", "");
						informationList1.add("");
						JsonObject1.put("SourceId", "");
						informationList1.add("");
						JsonObject1.put("SourceLatLongId", "");
						informationList1.add("");
						JsonObject1.put("DestinationId", "");
						informationList1.add("");
						JsonObject1.put("DestinationLatLongId", "");
						informationList1.add("");
						JsonObject1.put("DistanceTravlledId", "");
						informationList1.add("");
						JsonObject1.put("TripCountId", "");
						informationList1.add("");
						JsonObject1.put("TotalDistanceTravlledId", df.format(totalTripDistance));
						informationList1.add(df.format(totalTripDistance));
						JsonObject1.put("TotalTripCountId", totalTripCount);
						informationList1.add(totalTripCount);
						
						JsonArray.put(JsonObject1);
						reporthelper1.setInformationList(informationList1);
						reportsList.add(reporthelper1);
						
						//System.out.println("informationList1 if :: ::  " + informationList1);
						
						totalTripDistance = 0;
						totalTripCount = 0;
						value = false;
					} else {
						JSONObject JsonObject1 = new JSONObject();
						ArrayList<Object> informationList1 = new ArrayList<Object>();
						ReportHelper reporthelper1 = new ReportHelper();
						count++;
						JsonObject1.put("slnoIndex", count);
						informationList1.add(count);
						JsonObject1.put("VehNoId", "");
						informationList1.add("");
						JsonObject1.put("VehicleGroupId", "");
						informationList1.add("");
						JsonObject1.put("OwnerId", "");
						informationList1.add("");
						JsonObject1.put("DateId", "");
						informationList1.add("");
						JsonObject1.put("SourceId", "");
						informationList1.add("");
						JsonObject1.put("SourceLatLongId", "");
						informationList1.add("");
						JsonObject1.put("DestinationId", "");
						informationList1.add("");
						JsonObject1.put("DestinationLatLongId", "");
						informationList1.add("");
						JsonObject1.put("DistanceTravlledId", "");
						informationList1.add("");
						JsonObject1.put("TripCountId", "");
						informationList1.add("");
						JsonObject1.put("TotalDistanceTravlledId", df.format(totalTripDistance));
						informationList1.add(df.format(totalTripDistance));
						JsonObject1.put("TotalTripCountId", totalTripCount);
						informationList1.add(totalTripCount);
						
						//System.out.println("informationList1 else :: ::  " + informationList1);
						
						JsonArray.put(JsonObject1);
						reporthelper1.setInformationList(informationList1);
						reportsList.add(reporthelper1);
						
						totalTripDistance = 0;
						totalTripCount = 0;
						value = false;
					}
				} else {
					totalTripDistance = distance;
					totalTripCount = tripCount;
				}
				if(!value){
					//System.out.println("For vehicle No :: "+bean.getVehicleNo());				
					totalTripDistance = distance;
					totalTripCount = tripCount;
				}
				oldRegNo = bean.getVehicleNo();
				oldDistance = distance;
				
				JsonArray.put(JsonObject);
				reporthelper.setInformationList(informationList);
				reportsList.add(reporthelper);
				
		    }

			JSONObject JsonObject1 = new JSONObject();
			ArrayList<Object> informationList1 = new ArrayList<Object>();
			ReportHelper reporthelper1 = new ReportHelper();
			count++;
			JsonObject1.put("slnoIndex", count);
			informationList1.add(count);
			JsonObject1.put("VehNoId", "");
			informationList1.add("");
			JsonObject1.put("VehicleGroupId", "");
			informationList1.add("");
			JsonObject1.put("OwnerId", "");
			informationList1.add("");
			JsonObject1.put("DateId", "");
			informationList1.add("");
			JsonObject1.put("SourceId", "");
			informationList1.add("");
			JsonObject1.put("SourceLatLongId", "");
			informationList1.add("");
			JsonObject1.put("DestinationId", "");
			informationList1.add("");
			JsonObject1.put("DestinationLatLongId", "");
			informationList1.add("");
			JsonObject1.put("DistanceTravlledId", "");
			informationList1.add("");
			JsonObject1.put("TripCountId", "");
			informationList1.add("");
			JsonObject1.put("TotalDistanceTravlledId", df.format(totalTripDistance));
			informationList1.add(df.format(totalTripDistance));
			JsonObject1.put("TotalTripCountId", totalTripCount);
			informationList1.add(totalTripCount);

			JsonArray.put(JsonObject1);
			reporthelper1.setInformationList(informationList1);
			reportsList.add(reporthelper1);

		
		    
			finalreporthelper.setReportsList(reportsList);
			finalreporthelper.setHeadersList(headersList);
			finlist.add(JsonArray);
			finlist.add(finalreporthelper);
			//System.out.println("ended:; "+new Date());
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return finlist;

	}
	private int getCount(Connection con, String regNo, String actualDate) throws ParseException {
		SimpleDateFormat yyyymmdd = new SimpleDateFormat("yyyy-MM-dd");
		SimpleDateFormat ddmmyyyy = new SimpleDateFormat("dd-MM-yyyy");
		ResultSet rs = null;
		int count = 0;
		PreparedStatement pstmt = null;
		try {
			pstmt = con.prepareStatement(HubReportStatements.GET_COUNT_FROM_SAND_AUTOMATED);
			pstmt.setString(1, regNo);
			pstmt.setString(2, yyyymmdd.format(ddmmyyyy.parse(actualDate)) + " 00:00:00");
			pstmt.setString(3, yyyymmdd.format(ddmmyyyy.parse(actualDate)) + " 23:59:59");
			rs = pstmt.executeQuery();
			if (rs.next()) {
				count = rs.getInt("COUNT");
			}	
		} catch (SQLException e) {
			e.printStackTrace();
		}
		DBConnection.releaseConnectionToDB(null, pstmt, rs);
		return count;
	}
	
}
