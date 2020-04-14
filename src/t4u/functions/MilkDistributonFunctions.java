package t4u.functions;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.text.SimpleDateFormat;
import java.util.ArrayList;

import org.json.JSONArray;
import org.json.JSONObject;

import t4u.beans.ReportHelper;
import t4u.common.DBConnection;
import t4u.statements.MilkDistributionStatments;

public class MilkDistributonFunctions {
	SimpleDateFormat ddmmyyyy = new SimpleDateFormat("dd-MM-yyyy");
	SimpleDateFormat yyyymmddhhiiss = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	SimpleDateFormat ddmmyyyyhhiiss = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
	
	public JSONArray getDistributionPoints(int systemId, int clientId,String btnValue,String routeId) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		JSONArray jArray = new JSONArray();
		JSONObject obj = null;
		int count = 1;
		try{
			if(btnValue.equals("Modify")){
				con = DBConnection.getConnectionToDB("AMS");
				pstmt = con.prepareStatement(MilkDistributionStatments.GET_DISTRIBUTION_DETAILS);
				pstmt.setInt(1, systemId);
				pstmt.setInt(2, clientId);
				pstmt.setInt(3, Integer.parseInt(routeId));
				rs = pstmt.executeQuery();
				while(rs.next()){
					obj = new JSONObject();
					obj.put("slNoDI", count);
					obj.put("UIDDI", rs.getInt("UID"));
					obj.put("distributionPointDI", "Distribution PT"+count);
					obj.put("locationNameDI", rs.getString("locationName"));
					obj.put("arrivalTimeDI", rs.getString("distArrTime"));
					obj.put("permittedBufferDI", rs.getString("distBufferTime"));
					obj.put("priorityDI", rs.getString("priority"));
					jArray.put(obj);
					count++;
				}
			}
			for(int i = count; i < 21; i++){
				obj = new JSONObject();
				obj.put("slNoDI", i);
				obj.put("UIDDI", 0);
				obj.put("distributionPointDI", "Distribution PT "+i);
				obj.put("locationNameDI", "");
				obj.put("arrivalTimeDI", "");
				obj.put("permittedBufferDI", "");
				obj.put("priorityDI", "");
				jArray.put(obj);
				count++;
			}
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		
		return jArray;
	}

	public JSONArray getSourceLocationNames(int systemId, int clientId, int type,String zone) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		JSONArray jArray = new JSONArray();
		JSONObject obj = null;
		try{
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(MilkDistributionStatments.GET_LOCATION_NAMES.replace("AMS.dbo.LOCATION", "AMS.dbo.LOCATION_ZONE_"+zone));
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, clientId);
			pstmt.setInt(3, type);
			rs = pstmt.executeQuery();
			while(rs.next()){
				obj = new JSONObject();
				obj.put("sourceId", rs.getInt("hubId"));
				obj.put("sourceName", rs.getString("name"));
				jArray.put(obj);
			}
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jArray;
	}

	public String insertOrModifyRouteDetails(int systemId, int clientId, int userId, String json, String routeName, String sourceHub, String sourceDep,
			String sourceBffer,String btnValue,int routeId) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String message = "";
		int inserted = 0;
		int generatedRouteId = 0;
		JSONObject obj = null;
		JSONObject objNew = null;
		int insert = 0;
		int update = 0;
		try{
			String st = "["+json+"]";
			JSONArray js = new JSONArray(st.toString());
			con = DBConnection.getConnectionToDB("AMS");
			if(btnValue.equals("Add")){
				pstmt = con.prepareStatement(MilkDistributionStatments.CHECK_EXISTING_ROUTE_NAME);
				pstmt.setInt(1, systemId);
				pstmt.setInt(2, clientId);
				pstmt.setString(3, routeName.toUpperCase());
				rs = pstmt.executeQuery();
				if(rs.next()){
					return "Route Error";
				}
				pstmt = con.prepareStatement(MilkDistributionStatments.INSERT_ROUTE_DETAILS,Statement.RETURN_GENERATED_KEYS);
				pstmt.setInt(1, systemId);
				pstmt.setInt(2, clientId);
				pstmt.setString(3, routeName.toUpperCase());
				pstmt.setInt(4, Integer.parseInt(sourceHub));
				pstmt.setString(5, sourceDep);
				pstmt.setInt(6, Integer.parseInt(sourceBffer));
				pstmt.setInt(7, 1);
				pstmt.setInt(8, userId);
				pstmt.setInt(9 ,js.length());
				inserted = pstmt.executeUpdate();
				rs = pstmt.getGeneratedKeys();
				if(rs.next()){
					generatedRouteId = rs.getInt(1);
				}
				if(inserted > 0){
		            for(int j = 0; j < js.length(); j++){
		            	objNew = js.getJSONObject(j);
						pstmt = con.prepareStatement(MilkDistributionStatments.INSERT_DISTRIBUTION_DETAILS);
						pstmt.setInt(1, systemId);
						pstmt.setInt(2, clientId);
						pstmt.setInt(3, generatedRouteId);
						pstmt.setInt(4, objNew.getInt("locationNameDI"));
						pstmt.setString(5, objNew.getString("arrivalTimeDI"));
						pstmt.setInt(6, objNew.getInt("permittedBufferDI"));
						pstmt.setInt(7, objNew.getInt("priorityDI"));
						pstmt.setInt(8, userId);
						insert = pstmt.executeUpdate();
					}
				}
				if(insert > 0 && inserted > 0){
					message = "Route Details Inserted Successfully";
				}else{
					message = "Error while inserting Route Details";
				}
			}else{
				pstmt = con.prepareStatement(MilkDistributionStatments.CHECK_FOR_RUNNING_TRIPS);
				pstmt.setInt(1, routeId);
				rs = pstmt.executeQuery();
				if(rs.next()){
					return "Cannot modify the route since trip is running for this route";
				}
				for(int i = 0; i < js.length(); i++){
					obj = js.getJSONObject(i);
					if(obj.getString("UIDDI").equals("0")){
						pstmt = con.prepareStatement(MilkDistributionStatments.INSERT_DISTRIBUTION_DETAILS);
						pstmt.setInt(1, systemId);
						pstmt.setInt(2, clientId);
						pstmt.setInt(3, routeId);
						pstmt.setInt(4, obj.getInt("locationNameDI"));
						pstmt.setString(5, obj.getString("arrivalTimeDI"));
						pstmt.setInt(6, obj.getInt("permittedBufferDI"));
						pstmt.setInt(7, obj.getInt("priorityDI"));
						pstmt.setInt(8, userId);
						insert = pstmt.executeUpdate();
					}else{
						pstmt = con.prepareStatement(MilkDistributionStatments.UPDATE_DISTRIBUTION_DETAILS);
						pstmt.setInt(1, obj.getInt("locationNameDI"));
						pstmt.setString(2, obj.getString("arrivalTimeDI"));
						pstmt.setInt(3, obj.getInt("permittedBufferDI"));
						pstmt.setInt(4, obj.getInt("priorityDI"));
						pstmt.setInt(5, Integer.parseInt(obj.getString("UIDDI")));
						pstmt.executeUpdate();
					}
				}
				if(sourceHub.matches("[0-9]+")){
					pstmt = con.prepareStatement(MilkDistributionStatments.UPDATE_ROUTE_DETAILS);
					pstmt.setString(1, sourceHub);
					pstmt.setString(2, sourceDep);
					pstmt.setInt(3, Integer.parseInt(sourceBffer));
					pstmt.setInt(4, routeId);
					pstmt.setInt(5, userId);
					pstmt.setInt(6, routeId);
				}else{
					pstmt = con.prepareStatement(MilkDistributionStatments.UPDATE_ROUTE_DETAILS_EXCEPT_SRC_HUB);
					pstmt.setString(1, sourceDep);
					pstmt.setInt(2, Integer.parseInt(sourceBffer));
					pstmt.setInt(3, routeId);
					pstmt.setInt(4, userId);
					pstmt.setInt(5, routeId);
				}
				update = pstmt.executeUpdate();
				if(update > 0){
					message = "Route Details updated Successfully";
				}else{
					message = "Error while updating Route Details";
				}
			}
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return message;
	}

	public JSONArray getActiveRotes(int systemId, int clientId,String page) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		JSONArray jArray = new JSONArray();
		JSONObject obj = null;
		try{
			con = DBConnection.getConnectionToDB("AMS");
			if(page.equals("trip")){
				pstmt = con.prepareStatement(MilkDistributionStatments.GET_ACTIVE_ROUTES_FOR_TRIP);
				pstmt.setInt(1, systemId);
				pstmt.setInt(2, clientId);
				pstmt.setInt(3, systemId);
				pstmt.setInt(4, clientId);
			}else{
				pstmt = con.prepareStatement(MilkDistributionStatments.GET_ACTIVE_ROUTES);
				pstmt.setInt(1, systemId);
				pstmt.setInt(2, clientId);
			}
			rs = pstmt.executeQuery();
			while(rs.next()){
				obj = new JSONObject();
				obj.put("routeId", rs.getInt("routeId"));
				obj.put("routeName", rs.getString("routeName"));
				jArray.put(obj);
			}
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jArray;
	}

	public JSONArray getActiveRoutes(int systemId, int clientId, int userId) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		JSONArray jArray = new JSONArray();
		JSONObject obj = null;
		try{
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(MilkDistributionStatments.GET_VEHICLES);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, clientId);
			pstmt.setInt(3, userId);
			rs = pstmt.executeQuery();
			while(rs.next()){
				obj = new JSONObject();
				obj.put("assetNo", rs.getString("assetNo"));
				jArray.put(obj);
			}
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jArray;
	}

	public String saveTripDetails(int systemId, int clientId, String vehicleNo,	String routeIds, int userId) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String message = "";
		int inserted = 0;
		try{
			String[] routeId = routeIds.split(",");
			con = DBConnection.getConnectionToDB("AMS");
			for(int i = 0; i < routeId.length; i++){
				pstmt = con.prepareStatement(MilkDistributionStatments.CHECK_EXISTING_ROUTE_AND_ASSET);
				pstmt.setString(1, vehicleNo);
				pstmt.setInt(2, Integer.parseInt(routeId[i]));
				pstmt.setInt(3, systemId);
				pstmt.setInt(4, clientId);
				rs = pstmt.executeQuery();
				if(rs.next()){
					return  "Trip already exists for this Vehicle and Route";
				}
				pstmt = con.prepareStatement(MilkDistributionStatments.INSERT_TRIP_DETAILS);
				pstmt.setInt(1, systemId);
				pstmt.setInt(2, clientId);
				pstmt.setString(3, vehicleNo);
				pstmt.setInt(4, Integer.parseInt(routeId[i]));
				pstmt.setInt(5, 1);
				pstmt.setInt(6, userId);
				inserted = pstmt.executeUpdate();
			}
			if(inserted > 0){
				message = "Trip assigned successfully...";
			}else{
				message = "Error while assigning the trip...";
			}
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return message;
	}

	public ArrayList<Object> getTripDetails(int systemId, int clientId) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		JSONArray jArray = new JSONArray();
		JSONObject obj = null;
		int count = 0;
		ArrayList<Object> informationList = null;
		ReportHelper reportHelper = null;
		ArrayList <ReportHelper> reportsList = new ArrayList <ReportHelper> ();
		ArrayList <String> headersList = new ArrayList <String> ();
		ReportHelper finalreporthelper = new ReportHelper();
		ArrayList <Object> finlist = new ArrayList <Object> ();	
		try{
			headersList.add("UID");
			headersList.add("SL NO");
			headersList.add("Vehicle Number");
			headersList.add("Route Name");
			headersList.add("Status");
			
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(MilkDistributionStatments.GET_TRIP_DETAILS);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, clientId);
			rs = pstmt.executeQuery();
			while(rs.next()){
				obj = new JSONObject();
				informationList = new ArrayList<Object>();
				reportHelper = new ReportHelper();
				++count;
				obj.put("UIDDI", rs.getInt("UID"));
				informationList.add(rs.getInt("UID"));
				obj.put("slnoDataIndex", count);
				informationList.add(count);
				obj.put("vehicleNoDI", rs.getString("assetNo"));
				informationList.add(rs.getString("assetNo"));
				obj.put("routeNameDI", rs.getString("routeName"));
				informationList.add(rs.getString("routeName"));
				obj.put("statusDI", rs.getString("status"));
				informationList.add(rs.getString("status"));
				jArray.put(obj);
				reportHelper.setInformationList(informationList);
				reportsList.add(reportHelper);
			}
			finalreporthelper.setHeadersList(headersList);
			finalreporthelper.setReportsList(reportsList);
			
			finlist.add(jArray);
			finlist.add(finalreporthelper);
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return finlist;
	}

	public ArrayList<Object> getRouteMasterDetails(int systemId, int clientId,String zone) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		JSONArray jArray = new JSONArray();
		JSONObject obj = null;
		int count = 0;
		ArrayList<Object> informationList = null;
		ReportHelper reportHelper = null;
		ArrayList <ReportHelper> reportsList = new ArrayList <ReportHelper> ();
		ArrayList <String> headersList = new ArrayList <String> ();
		ReportHelper finalreporthelper = new ReportHelper();
		ArrayList <Object> finlist = new ArrayList <Object> ();	
		try{
			headersList.add("UID");
			headersList.add("SL NO");
			headersList.add("Route Name");
			headersList.add("Source");
			headersList.add("Source Dep Time");
			headersList.add("No. of Distribution Points");
			headersList.add("Status");
			headersList.add("Permitted Buffer");
			
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(MilkDistributionStatments.GET_ROUTE_MASTER_DETAILS.replace("AMS.dbo.LOCATION", "AMS.dbo.LOCATION_ZONE_"+zone));
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, clientId);
			rs = pstmt.executeQuery();
			while(rs.next()){
				obj = new JSONObject();
				informationList = new ArrayList<Object>();
				reportHelper = new ReportHelper();
				++count;
				obj.put("UIDDI", rs.getInt("UID"));
				informationList.add(rs.getInt("UID"));
				obj.put("slnoDataIndex", count);
				informationList.add(count);
				obj.put("routeNameDI", rs.getString("routeName"));
				informationList.add(rs.getString("routeName"));
				obj.put("sourceDI", rs.getString("source"));
				informationList.add(rs.getString("source"));
				obj.put("depTimeDI", rs.getString("depTime"));
				informationList.add(rs.getString("depTime"));
				obj.put("pointsDI", rs.getString("noOfPoints"));
				informationList.add(rs.getString("noOfPoints"));
				obj.put("statusDI", rs.getString("status"));
				informationList.add(rs.getString("status"));
				obj.put("bufferDI", rs.getInt("srcBufferTime"));
				informationList.add(rs.getInt("srcBufferTime"));
				jArray.put(obj);
				reportHelper.setInformationList(informationList);
				reportsList.add(reportHelper);
			}
			finalreporthelper.setHeadersList(headersList);
			finalreporthelper.setReportsList(reportsList);
			
			finlist.add(jArray);
			finlist.add(finalreporthelper);
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return finlist;
	}

	public ArrayList<Object> getDistributionReportDetails(int systemId, int clientId, String fromDate, String toDate, String vehicleNo,
				String routeId,int offset,String zone) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		JSONArray jArray = new JSONArray();
		JSONObject obj = null;
		int count = 0;
		String query = "";
		ArrayList<Object> informationList = null;
		ReportHelper reportHelper = null;
		ArrayList <ReportHelper> reportsList = new ArrayList <ReportHelper> ();
		ArrayList <String> headersList = new ArrayList <String> ();
		ReportHelper finalreporthelper = new ReportHelper();
		ArrayList <Object> finlist = new ArrayList <Object> ();	
		try{
			headersList.add("UID");
			headersList.add("SLNO");
			headersList.add("Vehicle No");
			headersList.add("Date");
			headersList.add("Route Name");
			headersList.add("Source");
			headersList.add("Scheduled Dep Time");
			headersList.add("Actual Dep Time");
			headersList.add("No of Distribution Points");
			headersList.add("Distance Travelled");
			headersList.add("Scheduled Route Time");
			headersList.add("Total Time Taken");
			headersList.add("Total Delay");
			headersList.add("Permtted Buffer");
			
			con = DBConnection.getConnectionToDB("AMS");
			query =  MilkDistributionStatments.GET_MILK_DISTRIBUTION_REPORT_DETAILS.replace("AMS.dbo.LOCATION", "AMS.dbo.LOCATION_ZONE_"+zone);
			if(!vehicleNo.equals("")){
				query = query.replace("#", " and sd.ASSET_NO="+"'"+vehicleNo+"'");
			}
			else if(!routeId.equals("")){
				query = query.replace("#"," and sd.ROUTE_ID="+routeId);
			}else{
				query = query.replace("#"," ");
			}
			pstmt = con.prepareStatement(query);
			pstmt.setInt(1, offset);
			pstmt.setInt(2, offset);
			pstmt.setInt(3, offset);
			pstmt.setInt(4, systemId);
			pstmt.setInt(5, clientId);
			pstmt.setInt(6, offset);
			pstmt.setString(7, fromDate.replace("T", " "));
			pstmt.setInt(8, offset);
			pstmt.setString(9, toDate.replace("T", " "));
			rs = pstmt.executeQuery();
			while(rs.next()){
				obj = new JSONObject();
				informationList = new ArrayList<Object>();
				reportHelper = new ReportHelper();
				++count;
				obj.put("UIDDI", rs.getInt("UID"));
				informationList.add(rs.getInt("UID"));
				obj.put("slnoDataIndex", count);
				informationList.add(count);
				obj.put("vehicleNoDI", rs.getString("assetNo"));
				informationList.add(rs.getString("assetNo"));
				obj.put("dateDI", ddmmyyyy.format(yyyymmddhhiiss.parse(rs.getString("date"))));
				informationList.add(ddmmyyyy.format(yyyymmddhhiiss.parse(rs.getString("date"))));
				obj.put("routeNameDI", rs.getString("routeName"));
				informationList.add(rs.getString("routeName"));
				obj.put("sourceDI", rs.getString("source"));
				informationList.add(rs.getString("source"));
				obj.put("schdDepTimeDI", rs.getString("scheduledDepTime"));
				informationList.add(rs.getString("scheduledDepTime"));
				obj.put("actualDepTime", rs.getString("actualDepTime"));
				informationList.add(rs.getString("actualDepTime"));
				obj.put("distrPtsDI", rs.getString("distributionPts"));
				informationList.add(rs.getString("distributionPts"));
				obj.put("distanceDI", rs.getString("distanceTravelled"));
				informationList.add(rs.getString("distanceTravelled"));
				long schdldDuration = rs.getInt("tripDuration");
				long schdldhh = schdldDuration / 3600;
				long schdldmm = (schdldDuration - schdldhh * 3600) / 60;
				long actualDuration = rs.getInt("actualDuration");
				long actualhh = actualDuration / 3600;
				long actualmm = (actualDuration - actualhh * 3600) / 60;
				long delayhh = (actualDuration - schdldDuration) / 3600;
				long delaymm = ((actualDuration - schdldDuration) - delayhh * 3600) / 60;
				String schdldHH = "";
				String schdldMM = "";
				String actualdHH = "";
				String actualdMM = "";
				String delayHH = "";
				String delayMM = "";
				
				if(schdldhh < 10){
					schdldHH = "0"+ String.valueOf(schdldhh);
				}else{
					schdldHH = String.valueOf(schdldhh);
				}
				if(schdldmm < 10){
					schdldMM = "0"+ String.valueOf(schdldmm);
				}else{
					schdldMM = String.valueOf(schdldmm);
				}
				
				if(actualhh < 10){
					actualdHH = "0"+ String.valueOf(actualhh);
				}else{
					actualdHH = String.valueOf(actualhh);
				}
				if(actualmm < 10){
					actualdMM = "0"+ String.valueOf(actualmm);
				}else{
					actualdMM = String.valueOf(actualmm);
				}
				
				if(Math.abs(delayhh) < 10){
					delayHH = "0"+ String.valueOf(Math.abs(delayhh));
				}else{
					delayHH = String.valueOf(Math.abs(delayhh));
				}
				if(Math.abs(delaymm) < 10){
					delayMM = "0"+ String.valueOf(Math.abs(delaymm));
				}else{
					delayMM = String.valueOf(Math.abs(delaymm));
				}
				obj.put("routeTimeDI", schdldHH+" : "+schdldMM);
				informationList.add(schdldHH+" : "+schdldMM);
				obj.put("totalTimeDI", actualdHH+" : "+actualdMM);
				informationList.add(actualdHH+" : "+actualdMM);
				if(delayhh < 0 || delaymm < 0){
					obj.put("totalDelayDI", "- " +delayHH+" : "+delayMM);
					informationList.add("- " +delayHH+" : "+delayMM);
				}else{
					obj.put("totalDelayDI", delayHH+" : "+delayMM);
					informationList.add(delayHH+" : "+delayMM);
				}
				obj.put("permittedBufferDI", rs.getInt("bufferTime"));
				informationList.add(rs.getInt("bufferTime"));
				jArray.put(obj);
				reportHelper.setInformationList(informationList);
				reportsList.add(reportHelper);
			}
			finalreporthelper.setHeadersList(headersList);
			finalreporthelper.setReportsList(reportsList);
			finlist.add(jArray);
			finlist.add(finalreporthelper);
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return finlist;
	}

	public ArrayList<Object> getDistributionPointDetails(int systemId, int clientId, String tripId, String zone,int offset) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		JSONArray jArray = new JSONArray();
		JSONObject obj = null;
		int count = 0;
		ArrayList<Object> informationList = null;
		ReportHelper reportHelper = null;
		ArrayList <ReportHelper> reportsList = new ArrayList <ReportHelper> ();
		ArrayList <String> headersList = new ArrayList <String> ();
		ReportHelper finalreporthelper = new ReportHelper();
		ArrayList <Object> finlist = new ArrayList <Object> ();	
		try{
			headersList.add("SLNO");
			headersList.add("Distribution Point Name");
			headersList.add("Scheduled Arrival Time");
			headersList.add("Permitted Buffer");
			headersList.add("ActualArrival Time");
			headersList.add("Actual Arrival Variance");
			headersList.add("Actual Departure Time");
			headersList.add("Temprature");
			
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(MilkDistributionStatments.GET_MILK_DISTRIBUTION_POINTS_DETAILS.replace("AMS.dbo.LOCATION", "AMS.dbo.LOCATION_ZONE_"+zone));
			pstmt.setInt(1, offset);
			pstmt.setInt(2, offset);
			pstmt.setInt(3, offset);
			pstmt.setInt(4, systemId);
			pstmt.setInt(5, clientId);
			pstmt.setInt(6, Integer.parseInt(tripId));
			rs = pstmt.executeQuery();
			while(rs.next()){
				obj = new JSONObject();
				informationList = new ArrayList<Object>();
				reportHelper = new ReportHelper();
				++count;
				obj.put("slNoDI", count);
				informationList.add(count);
				obj.put("distributionPointDI", rs.getString("distributionPointName"));
				informationList.add(rs.getString("distributionPointName"));
				obj.put("scheduledArrivalTimeDII", rs.getString("scheduledArrTime"));
				informationList.add(rs.getString("scheduledArrTime"));
				obj.put("permittedBufferDI", rs.getString("buffer"));
				informationList.add(rs.getString("buffer"));
				obj.put("actulaArrivalTimeDI", rs.getString("actualArrTime"));
				informationList.add(rs.getString("actualArrTime"));
				long hh = 0;
				long mm = 0;
	            String durHH = "";
	            String durMM = "";
				String[] src = rs.getString("scheduledArrTime").split(":");
				String[] dest = rs.getString("actualArrTime").split(":");
				long srcmili = (Integer.parseInt(src[0]) * 3600) + (Integer.parseInt(src[1]) * 60);
				long destmili = (Integer.parseInt(dest[0]) * 3600) + (Integer.parseInt(dest[1]) * 60);
				if(srcmili > destmili){
					hh = (srcmili - destmili) / 3600;
					mm = ((srcmili - destmili) - hh * 3600) / 60;
				}else{
					hh = (destmili - srcmili) / 3600;
					mm = ((destmili - srcmili) - hh * 3600) / 60;
				}	
				if(hh < 10){
					durHH = "0"+ String.valueOf(hh);
				}else{
					durHH = String.valueOf(hh);
				}
				if(mm < 10){
					durMM = "0"+ String.valueOf(mm);
				}else{
					durMM = String.valueOf(mm);
				}
				obj.put("actulaArrivalVarianceDI", durHH+":"+durMM);
				informationList.add(durHH+":"+durMM);
				obj.put("actulaDepartureTimeDI", rs.getString("actualDepTime"));
				informationList.add(rs.getString("actualDepTime"));
				obj.put("tempDI", rs.getInt("temprature"));
				informationList.add(rs.getInt("temprature"));
				
				jArray.put(obj);
				reportHelper.setInformationList(informationList);
				reportsList.add(reportHelper);
			}
			finalreporthelper.setHeadersList(headersList);
			finalreporthelper.setReportsList(reportsList);
			finlist.add(jArray);
			finlist.add(finalreporthelper);
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return finlist;
	}

	public String changeStatusOfTrip(String uID, String status) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String message = "";
		int update = 0;
		int statusBit = 1;
		try{
			if(status.equals("Active")){
				statusBit = 0;
			}
			con = DBConnection.getConnectionToDB("AMS");
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(MilkDistributionStatments.CHECK_FOR_RUNNING_TRIPS_NEW);
			pstmt.setInt(1, Integer.parseInt(uID));
			rs = pstmt.executeQuery();
			if(rs.next()){
				return "Cannot change the trip status, since trip is open";
			}
			pstmt = con.prepareStatement(MilkDistributionStatments.CHANGE_TRIP_STATUS);
			pstmt.setInt(1, statusBit);
			pstmt.setInt(2, Integer.parseInt(uID));
			update = pstmt.executeUpdate();
			if(update > 0){
				message = "Status has been changes successfully";
			}else{
				message = "Error while changing the status";
			}
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			DBConnection.releaseConnectionToDB(con, pstmt, null);
		}
		return message;
	}

	public String changeStatusOfRoute(String uID, String status) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String message = "";
		int update = 0;
		int statusBit = 1;
		try{
			if(status.equals("Active")){
				statusBit = 0;
			}
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(MilkDistributionStatments.CHECK_FOR_RUNNING_TRIPS);
			pstmt.setInt(1, Integer.parseInt(uID));
			rs = pstmt.executeQuery();
			if(rs.next()){
				return "Cannot change the route status, since trip is running for this route";
			}
			pstmt = con.prepareStatement(MilkDistributionStatments.CHANGE_ROUTE_STATUS);
			pstmt.setInt(1, statusBit);
			pstmt.setInt(2, Integer.parseInt(uID));
			update = pstmt.executeUpdate();
			if(update > 0){
				message = "Status has been changed successfully";
			}else{
				message = "Error while changing the status";
			}
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			DBConnection.releaseConnectionToDB(con, pstmt, null);
		}
		return message;
	}
}
