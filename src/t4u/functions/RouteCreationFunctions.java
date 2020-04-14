package t4u.functions;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.json.JSONArray;
import org.json.JSONObject;

import t4u.beans.ReportHelper;
import t4u.common.DBConnection;
import t4u.statements.CashVanManagementStatements;
import t4u.statements.CommonStatements;
import t4u.statements.GeneralVerticalStatements;
import t4u.statements.RouteCreationStatements;

public class RouteCreationFunctions {

	public String saveRoute(String sourceAlias,
			String sourceLatLng, String destAlias, String destLatLng,
			String routeName, String routeDesc, String actualDist,
			String expectedDist, String expectedTime, String actualTime,
			int routeRadius, int systemId, int clientId,int userId, String[] routeLatLng,
			String[] checkpointArray, String checkPtDur,String sHub,String dHub) {
		Connection con = null;
		PreparedStatement pstmt = null;
		PreparedStatement pstmt1 = null;
		ResultSet rs1 = null;
		ResultSet rs = null;
		int routeId = 0;
		int routeSequence = 1;
		int checkPointSequence = 1;
		int insertResult1 = 0;
		int insertResult2 = 0;
		String message = "";
		RouteCreationFunctions rcf = new RouteCreationFunctions();
		ArrayList<String> routeArrayList = new ArrayList<String>();
		CommonFunctions cf = new CommonFunctions();
		DecimalFormat df = new DecimalFormat("##0.00");
		con = DBConnection.getConnectionToDB("AMS");
		float actualDistNew = 0;
		float expectedDistNew = 0;
		if (actualDist.contains("MI")) {
			String tempDist = actualDist.replace("MI", "").replace("KM", "")
					.replace(" ", "");
			float distFactor = 0.62137f;
			actualDistNew = (Float.parseFloat(tempDist)) / distFactor;
			expectedDistNew = (Float.parseFloat(expectedDist)) / distFactor;
			expectedDist = String.valueOf(expectedDistNew);
			} else {
			String tempDist = actualDist.replace("MI", "").replace("KM", "")
					.replace(" ", "");
			actualDistNew = Float.parseFloat(tempDist);
		}
		double actualTimeF = Double.parseDouble(actualTime);
		double expectedTimeF = Double.parseDouble(expectedTime);
		try {
			pstmt1 = con
					.prepareStatement(RouteCreationStatements.GET_MAX_ROUTE_ID);
			rs1 = pstmt1.executeQuery();
			if (rs1.next()) {
				routeId = rs1.getInt(1) + 1;
			}
			System.out.println("MAX RT ID : " + routeId);
			pstmt = con.prepareStatement(RouteCreationStatements.SAVE_ROUTE_ID);
			pstmt.setInt(1, routeId);
			pstmt.setString(2, routeName.toUpperCase());
			pstmt.setInt(3, systemId);
			pstmt.setInt(4, clientId);
			pstmt.setString(5, routeDesc);
			pstmt.setFloat(6, actualDistNew);
			pstmt.setString(7, expectedDist);
			pstmt.setDouble(8, cf.convertHHMMToMinutes(df.format(actualTimeF)));
			pstmt.setDouble(9, cf
					.convertHHMMToMinutes(df.format(expectedTimeF)));
			pstmt.setString(10, "Active");
			pstmt.setInt(11, routeRadius);
			pstmt.setInt(12, userId);
			insertResult1 = pstmt.executeUpdate();
			sourceLatLng = sourceLatLng.replace("(", " ").replace(")", " ");
			destLatLng = destLatLng.replace("(", " ").replace(")", " ");

			routeArrayList.add("1," + routeSequence + "," + sourceLatLng
					+ ",SOURCE," + sourceAlias + " ,0"+ ","+0+ ","+" "+ ","+" "+ ","+sHub);

			for (int i = 0; i < routeLatLng.length; i++) {
				routeSequence++;
				String tempLatLng = routeLatLng[i];
				tempLatLng = tempLatLng.replace("{", "").replace("}", "");
				String latLngData[] = tempLatLng.split(",");
				// System.out.println("1,"+routeSequence+","+latLngData[1].trim()+","+latLngData[2].trim()+", , ,0");

				routeArrayList.add("1," + routeSequence + ","
						+ latLngData[1].trim() + "," + latLngData[2].trim()
						+ ", , ,0"+ ","+0+ ","+" "+ ","+" "+ ","+" "+ ","+0);

			}
			String tempDuration = "0";

			if (!checkPtDur.isEmpty() && checkPtDur != null) {
				String checkPointDur[] = checkPtDur.split(",");
				tempDuration = checkPointDur[checkPointDur.length - 1];
				if(tempDuration.contains("day")){
					float dayInHours = 0;String [] dayStr = tempDuration.split("day");
					float totalHours = 0;
					String day = dayStr[0].replace("day", "").replace("s", "").replace(" ", "");
					String hours=dayStr[1].replace("hour", "").replace("min", "").replace("s", "").replace(
							" ", "");
					dayInHours = Float.parseFloat(day)*24;
					totalHours = dayInHours + (Float.parseFloat(hours));
					tempDuration = String.valueOf(totalHours);
				}else{
				tempDuration = tempDuration.replace("hour", ".").replace("min",
						"").replace("s", "").replace(" ", "");
				String tempStr[]=tempDuration.split("\\.");
				if(tempStr.length!=1){
				if(tempStr[1].length()==1){
					tempStr[1]="0"+tempStr[1];
					tempDuration = tempStr[0]+"."+tempStr[1];
				}
				}
				}
			}
			routeArrayList.add("2," + routeSequence + "," + destLatLng
					+ ",DESTINATION," + destAlias + "," + tempDuration+ ","+0+ ","+" "+ ","+" "+ ","+dHub);

			if (checkpointArray != null && checkpointArray.length != 0) {
				for (int i = 0; i < checkpointArray.length; i++) {
					tempDuration = "0";
					if (!checkPtDur.isEmpty() && checkPtDur != null) {
						
						String checkPointDur[] = checkPtDur.split(",");
						tempDuration = checkPointDur[i];
						if(tempDuration.contains("day")){
							float dayInHours = 0;String [] dayStr = tempDuration.split("day");
							float totalHours = 0;
							String day = dayStr[0].replace("day", "").replace("s", "").replace(" ", "");
							String hours=dayStr[1].replace("hour", "").replace("min", "").replace("s", "").replace(
									" ", "");
							dayInHours = Float.parseFloat(day)*24;
							totalHours = dayInHours + (Float.parseFloat(hours));
							tempDuration = String.valueOf(totalHours);
						}else{
						tempDuration = tempDuration.replace("hour", ".")
								.replace("min", "").replace("s", "").replace(
										" ", "");
						String tempStr[] = tempDuration.split("\\.");
						if (tempStr.length != 1) {
							if (tempStr[1].length() == 1) {
								tempStr[1] = "0" + tempStr[1];
								tempDuration = tempStr[0] + "." + tempStr[1];
							}
						}
						}
					}
					String CPLatLng = checkpointArray[i];

					CPLatLng = CPLatLng.replace("{", "").replace("}", "")
							.replace("(", "").replace(")", "");
					String checkPointData[] = CPLatLng.split(",");
					routeArrayList.add("3," + checkPointSequence + ","
							+ checkPointData[1].trim() + ","
							+ checkPointData[2].trim() + ",CHECK POINT , "
							+ checkPointData[0] + "," + tempDuration+ ","+checkPointData[3]+ ","+checkPointData[4]+ ","+checkPointData[5]+ ","+checkPointData[6]);
					checkPointSequence++;
				}
			}
			for (int i = 0; i < routeArrayList.size(); i++) {

				String routeList = (String) routeArrayList.get(i);
				String routeData[] = routeList.split(",");
				String routeSegment = routeData[0].trim();
				String routeSeq = routeData[1].trim();
				String routeLat = routeData[2].trim();
				String routeLng = routeData[3].trim();
				String routeType = routeData[4].trim();
				String shortName = routeData[5].toUpperCase().trim();
				String routeDuration = routeData[6].trim();
				double radius=Double.parseDouble(routeData[7].trim());
				String type=routeData[8].trim();
				String detentionTime=routeData[9].trim();
				String hubid=routeData[10].trim();
				int detentionTimeT=0;
//				if(!detentionTime.equals("")){
//					detentionTimeT=cf.convertHHMMToMinutes1(detentionTime);
//				}
				double routeDurationF = Double.parseDouble(routeDuration);
				double routeDurationNew = 0;
				if (!routeDuration.equals("") && routeDuration.contains(".")) {
					routeDurationNew = cf.convertHHMMToMinutes(df
							.format(routeDurationF));
				} else if (!routeDuration.equals("")
						&& !routeDuration.contains(".")) {
					routeDurationNew = Double.parseDouble(routeDuration);
				} else {
					routeDurationNew = 0;
				}
				pstmt = null;
				rs = null;
				pstmt = con
						.prepareStatement(RouteCreationStatements.SAVE_ROUTE_DETAIL);
				pstmt.setInt(1, routeId);
				pstmt.setInt(2, Integer.parseInt(routeSegment));
				pstmt.setInt(3, Integer.parseInt(routeSeq));
				pstmt.setString(4, routeLat);
				pstmt.setString(5, routeLng);
				pstmt.setString(6, routeType);
				pstmt.setString(7, shortName);
				pstmt.setDouble(8, routeDurationNew);
				pstmt.setDouble(9, radius);
				pstmt.setString(10, type);
				pstmt.setString(11, detentionTime);
				pstmt.setString(12, hubid);
				insertResult2 = pstmt.executeUpdate();
			}
			if (insertResult1 == 1 && insertResult2 == 1) {
				message = "Route Created";
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
			DBConnection.releaseConnectionToDB(null, pstmt1, rs1);
		}
		return message;
	}

	public ArrayList<Object> getRouteDetails(int customerId, int systemId, String zone) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject = new JSONObject();
		CommonFunctions cf = new CommonFunctions();
		RouteCreationFunctions rcf = new RouteCreationFunctions();
		float distFactor = 0.62137f;
		DecimalFormat df = new DecimalFormat("0.##");
		int count=0;
		ArrayList<Object> list=new ArrayList<Object>();
		ArrayList<ReportHelper> reportsList = new ArrayList<ReportHelper>();
		ArrayList<String> headersList = new ArrayList<String>();
		ReportHelper finalreporthelper = new ReportHelper();
		headersList.add("Sl No");
		headersList.add("RouteId");		
		headersList.add("Route Description");
		headersList.add("Route Name");
		headersList.add("Source");
		headersList.add("Destination");
		headersList.add("Actual Distance");
		headersList.add("Expected Distance");
		headersList.add("Actual Time");
		headersList.add("Expected Time");
		headersList.add("Status");		
		headersList.add("Created By");
		headersList.add("Radius");
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(rcf.getLocationQuery(
					RouteCreationStatements.GET_ROUTE_DETAILS_FOR_GRID, zone));
			pstmt.setInt(1, customerId);
			pstmt.setInt(2, systemId);
			rs = pstmt.executeQuery();
			String distUnits = cf.getUnitOfMeasure(systemId);
			while (rs.next()) {
				jsonObject = new JSONObject();
				ArrayList<Object> informationList = new ArrayList<Object>();
	            ReportHelper reporthelper = new ReportHelper();
	            count++;
	            jsonObject.put("slnoIndex", count);
	            informationList.add(count);
				jsonObject.put("routeIdDataIndex", rs.getString("RouteID"));
				informationList.add(rs.getString("RouteID"));
				jsonObject.put("despDataIndex", rs.getString("ROUTE_DESCRIPTION"));
				informationList.add(rs.getString("ROUTE_DESCRIPTION"));
				jsonObject.put("routeNameDataIndex", rs.getString("ROUTE_NAME"));
				informationList.add(rs.getString("ROUTE_NAME"));
				jsonObject.put("routeFromDataIndex", rs.getString("SOURCE_NAME"));
				informationList.add(rs.getString("SOURCE_NAME"));
				jsonObject.put("routeToDataIndex", rs.getString("DESTINATION_NAME"));
				informationList.add(rs.getString("DESTINATION_NAME"));
				if (distUnits.equalsIgnoreCase("miles")) {
					float tempActual = distFactor
							* (Float
									.parseFloat(rs.getString("ACTUAL_DISTANCE")));
					float tempexpected = distFactor
							* (Float.parseFloat(rs
									.getString("EXPECTED_DISTANCE")));
					jsonObject.put("actualDistanceDataIndex", df
							.format(tempActual));
					informationList.add(df.format(tempActual));
					jsonObject.put("tempDistanceDataIndex", df
							.format(tempexpected));
					informationList.add(df.format(tempexpected));
				} else {
					jsonObject.put("actualDistanceDataIndex", df.format(Double
							.parseDouble(rs.getString("ACTUAL_DISTANCE"))));
					informationList.add(df.format(Double.parseDouble(rs.getString("ACTUAL_DISTANCE"))));
					jsonObject.put("tempDistanceDataIndex", rs
							.getString("EXPECTED_DISTANCE"));
					informationList.add(rs.getString("EXPECTED_DISTANCE"));
				}
				String aTemp = "";
				aTemp = rs.getString("ACTUAL_DURATION");
				String eTemp = "";
				eTemp = rs.getString("EXPECTED_DURATION");
				if (aTemp.contains(".")) {
					String[] actualStr = aTemp.split("\\.");
					String actualDur = rcf.convertMinutesToHHMMFormat(Integer
							.parseInt(actualStr[0]));
					jsonObject.put("actualTimeDataIndex", actualDur);
					informationList.add(actualDur);
				} else{
					jsonObject.put("actualTimeDataIndex", rs
							.getString("ACTUAL_DURATION"));
					informationList.add(rs.getString("ACTUAL_DURATION"));
				} 
				if  (eTemp.contains(".")) {
					String[] expectedStr = eTemp.split("\\.");
					String ExpectedDur = rcf.convertMinutesToHHMMFormat(Integer
							.parseInt(expectedStr[0]));
					jsonObject.put("tempTimeDataIndex", ExpectedDur);
					informationList.add(ExpectedDur);
					
				}else{
					jsonObject.put("tempTimeDataIndex", rs
							.getString("EXPECTED_DURATION"));
					informationList.add(rs.getString("EXPECTED_DURATION"));
				}
				jsonObject.put("statusDataIndex", rs.getString("STATUS"));
				informationList.add(rs.getString("STATUS"));				
				// jsonObject.put("trigger2DataIndex", rs
				// .getString("TRIGGER_POINT_2"));
				// jsonObject.put("trigger1DataIndex", rs
				// .getString("TRIGGER_POINT_1"));	
				jsonObject.put("createdByIndex", rs.getString("CREATED_BY"));
				informationList.add(rs.getString("CREATED_BY"));
				jsonObject.put("radiusDataIndex", rs.getString("ROUTE_RADIUS"));
				informationList.add(rs.getString("ROUTE_RADIUS"));
				// jsonObject.put("SourceRadiusDataIndex", rs
				// .getString("SOURCE_RADIUS"));
				// jsonObject.put("destRadiusDataIndex", rs
				// .getString("DESTINATION_RADIUS"));				
				jsonArray.put(jsonObject);
				reporthelper.setInformationList(informationList);
				reportsList.add(reporthelper);
			}
			finalreporthelper.setReportsList(reportsList);
			finalreporthelper.setHeadersList(headersList);
			list.add(jsonArray);
			list.add(finalreporthelper);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return list;
	}

	public JSONArray getLatLongs(int routeId, int cutomerId, int systemId,
			String zone) {

		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		RouteCreationFunctions rcf = new RouteCreationFunctions();
		try {
			con = DBConnection.getConnectionToDB("AMS");
			jsonArray = new JSONArray();
			jsonObject = new JSONObject();
			pstmt = con.prepareStatement(rcf.getLocationQuery(
					RouteCreationStatements.GET_LAT_LNGS, zone));
			pstmt.setInt(1, routeId);
			pstmt.setInt(2, cutomerId);
			pstmt.setInt(3, systemId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				jsonObject = new JSONObject();
				jsonObject.put("sequence", rs.getString("Route_sequence"));
				jsonObject.put("lat", rs.getString("Latitude"));
				jsonObject.put("long", rs.getString("Longitude"));
				jsonObject.put("type", rs.getString("TYPE"));
				jsonObject.put("alias", rs.getString("SHORT_NAME"));

				jsonArray.put(jsonObject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jsonArray;

	}

	public JSONArray getCustomer(int SystemId, String ltsp, int customerIdlogin) {
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject = new JSONObject();
		Connection conAdmin = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			jsonArray = new JSONArray();
			jsonObject = new JSONObject();

			conAdmin = DBConnection.getConnectionToDB("ADMINISTRATOR");
			if (customerIdlogin > 0) {
				pstmt = conAdmin
						.prepareStatement(RouteCreationStatements.GET_CUSTOMER_FOR_LOGGED_IN_CUST);
				pstmt.setInt(1, SystemId);
				pstmt.setInt(2, customerIdlogin);
			} else {
				pstmt = conAdmin
						.prepareStatement(RouteCreationStatements.GET_CUSTOMER);
				pstmt.setInt(1, SystemId);
			}
			rs = pstmt.executeQuery();
			// if we want to give option to select whole ltsp
			if (ltsp.equals("yes") && customerIdlogin == 0) {
				jsonObject = new JSONObject();
				jsonObject.put("CustId", 0);
				jsonObject.put("CustName", "LTSP");
				jsonArray.put(jsonObject);
			}
			while (rs.next()) {
				jsonObject = new JSONObject();
				int custId = rs.getInt("CUSTOMER_ID");
				String custName = rs.getString("NAME");
				String status = rs.getString("STATUS");
				String activationstatus = rs.getString("ACTIVATION_STATUS");
				jsonObject.put("CustId", custId);
				jsonObject.put("CustName", custName);
				jsonObject.put("Status", status);
				jsonObject.put("ActivationStatus", activationstatus);
				jsonArray.put(jsonObject);
			}
		} catch (Exception e) {
			System.out.println("Error in getCustomer " + e.toString());
		} finally {
			DBConnection.releaseConnectionToDB(conAdmin, pstmt, rs);
		}
		return jsonArray;
	}

	public String getLocationQuery(CharSequence query, String zone) {
		String retValue = query.toString();
		retValue = query.toString().replaceAll("LOCATION_ZONE",
				"LOCATION_ZONE" + "_" + zone);
		return retValue;
	}

	public String convertMinutesToHHMMFormat(int minutes) {
		String duration = "0.0";

		long durationHrslong = minutes / 60;
		String durationHrs = String.valueOf(durationHrslong);
		if (durationHrs.length() == 1) {
			durationHrs = "0" + durationHrs;
		}

		long durationMinsLong = minutes % 60;
		String durationMins = String.valueOf(durationMinsLong);
		if (durationMins.length() == 1) {
			durationMins = "0" + durationMins;
		}

		duration = durationHrs + "." + durationMins;

		return duration;
	}
	public JSONArray getType(int custId ,int systemId) {

		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject = null;
		Connection con=null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		try{
			jsonArray = new JSONArray();
			jsonObject = new JSONObject();
			
			con=DBConnection.getConnectionToDB("AMS");
			pstmt=con.prepareStatement(GeneralVerticalStatements.GET_TYPES);
			rs=pstmt.executeQuery();
			while(rs.next()){
				jsonObject = new JSONObject();
				jsonObject.put("type", rs.getString("VALUE"));
				jsonArray.put(jsonObject);				
			}
		}catch(Exception e){
			System.out.println("Error in getCustNames "+e.toString());
		}	
		finally{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}	
		return jsonArray;

	}
	 public JSONArray getSourceDestination(int clientId,int systemId,String zone) {
	    	Connection con = null;
			PreparedStatement pstmt = null;
			ResultSet rs=null;
			JSONArray jsonArray = new JSONArray();
		    JSONObject jsonObject = null;
		    CommonFunctions cf=new CommonFunctions();
			try {
				con = DBConnection.getConnectionToDB("AMS");
				pstmt = con.prepareStatement(cf.getLocationQuery(GeneralVerticalStatements.GET_SOURCE_DESTINATION, zone));
				pstmt.setInt(1,clientId);
				pstmt.setInt(2, systemId);
				rs = pstmt.executeQuery();
				while (rs.next()) {
					jsonObject = new JSONObject();
					jsonObject.put("Hub_Id",rs.getInt("HUBID"));
					jsonObject.put("Hub_Name",rs.getString("NAME"));
					jsonObject.put("latitude",rs.getString("LATITUDE"));
					jsonObject.put("longitude",rs.getString("LONGITUDE"));
					jsonObject.put("radius",rs.getString("RADIUS"));
					jsonObject.put("detention", rs.getString("Standard_Duration"));
					jsonArray.put(jsonObject);
				}
			} catch (Exception e) {
				e.printStackTrace();
			} finally {
				DBConnection.releaseConnectionToDB(con, pstmt, rs);
			}
		  return jsonArray;
		}
	 public JSONArray getCheckPoints(int clientId,int systemId,String zone) {
	    	Connection con = null;
			PreparedStatement pstmt = null;
			ResultSet rs=null;
			JSONArray jsonArray = new JSONArray();
		    JSONObject jsonObject = null;
		    CommonFunctions cf=new CommonFunctions();
			try {
				con = DBConnection.getConnectionToDB("AMS");
				pstmt = con.prepareStatement(cf.getLocationQuery(GeneralVerticalStatements.GET_CHECK_POINT, zone));
				pstmt.setInt(1,clientId);
				pstmt.setInt(2, systemId);
				rs = pstmt.executeQuery();
				while (rs.next()) {
					jsonObject = new JSONObject();
					jsonObject.put("Hub_Id",rs.getInt("HUBID"));
					jsonObject.put("Hub_Name",rs.getString("NAME"));
					jsonObject.put("latitude",rs.getString("LATITUDE"));
					jsonObject.put("longitude",rs.getString("LONGITUDE"));
					jsonObject.put("radius",rs.getString("RADIUS"));
					jsonObject.put("detention", rs.getString("Standard_Duration"));
					jsonArray.put(jsonObject);
				}
			} catch (Exception e) {
				e.printStackTrace();
			} finally {
				DBConnection.releaseConnectionToDB(con, pstmt, rs);
			}
		  return jsonArray;
		}
	 
	 public JSONArray getRouteNames(int systemId, int clientId){
		 JSONArray array = new JSONArray();
		 
		   Connection con = null;
		   PreparedStatement pstmt = null;
		   ResultSet rs=null;
		   JSONObject obj;
		   try {
				con = DBConnection.getConnectionToDB("AMS");
				pstmt = con.prepareStatement(RouteCreationStatements.GET_ROUTE_NAMES);
				pstmt.setInt(1, systemId);
				pstmt.setInt(2, clientId);
				rs = pstmt.executeQuery();
				while(rs.next()){
					obj = new JSONObject();
					obj.put("Route_Id", rs.getString("ROUTE_ID"));
					obj.put("Route_Name", rs.getString("ROUTE_NAME"));
					array.put(obj);
				}
				
		   }catch (Exception e) {
				e.printStackTrace();
			} finally {
				DBConnection.releaseConnectionToDB(con, pstmt, rs);
			}
			return array;
			
	 }
	 
	 public boolean checkIfRouteAlreadyExists(String[] checkpointArray,String shubId, String dhubId){
			 List<String> checkpointsequence = new ArrayList<String>();
			 if (checkpointArray != null && checkpointArray.length != 0) {
					for (int i = 0; i < checkpointArray.length; i++) {
						String checkPoint = checkpointArray[i].replace("{", "").replace("}", "").replace("(", "").replace(")", "");
						String checkPointData[] = checkPoint.split(",");
						checkpointsequence.add(checkPointData[6]); //get hub id
					}
			 }
		   Connection con = null;
		   PreparedStatement pstmt = null;
		   ResultSet rs=null;
			try {
				con = DBConnection.getConnectionToDB("AMS");
				pstmt = con.prepareStatement(RouteCreationStatements.GET_ROUTE_BY_SOURCE_DEST);
				pstmt.setInt(1, Integer.parseInt(shubId));
				pstmt.setInt(2, Integer.parseInt(dhubId));
				rs = pstmt.executeQuery();
				List<Integer> routeIdList =new ArrayList<Integer>();
				while(rs.next()) {
					routeIdList.add(rs.getInt("ROUTE_ID"));
				}
				if(routeIdList.size() == 0)// No route for given source and destination exists.
				{
					return false;
				}
				
				Map<String, List<String>> routeIdToHubIdsMapDB = new HashMap<String, List<String>>();
				pstmt = con.prepareStatement(RouteCreationStatements.GET_CHECKPOINTS_BY_ROUTE_ID.replace("#", sqlParams(routeIdList.size())));
				int paramIndex =1;
		        for(Integer route : routeIdList){
		        	pstmt.setInt(paramIndex, route);
		        	paramIndex++;
		        }
				rs = pstmt.executeQuery();
				
				while(rs.next()){
					if(routeIdToHubIdsMapDB.get(rs.getString("ROUTE_ID")) == null){
						List<String> list = new ArrayList<String>();
						list.add(rs.getString("HUB_ID"));
						routeIdToHubIdsMapDB.put(rs.getString("ROUTE_ID") , list);
					}else{
						routeIdToHubIdsMapDB.get(rs.getString("ROUTE_ID")).add(rs.getString("HUB_ID"));
					}
				}
				if(checkpointsequence.isEmpty()){
					if(routeIdToHubIdsMapDB.keySet().size() != routeIdList.size()){
						//means there are route id for which no check points..route already exists
						return true;
					}
					
				}
				
				Set<String> routeIdsDB = routeIdToHubIdsMapDB.keySet();
				for(String routeIdDB : routeIdsDB){
					List<String> hubSequenceDB = routeIdToHubIdsMapDB.get(routeIdDB);
					if(hubSequenceDB.equals(checkpointsequence)){
						return true;
					}
				}
				
			} catch (Exception e) {
				e.printStackTrace();
			} finally {
				DBConnection.releaseConnectionToDB(con, pstmt, rs);
			}
		 
		 
		 return false;
	 }
	 
	 private String sqlParams(int numParams) {
		    StringBuilder sb = new StringBuilder();
		    if(numParams <= 0) return sb.toString();
		    for(int ctr = 0; ctr < numParams - 1; ++ctr) {
		        sb.append("?,");
		    }
		    sb.append("?");
		    return sb.toString();
		}
}
