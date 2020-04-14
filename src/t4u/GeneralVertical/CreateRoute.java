package t4u.GeneralVertical;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.List;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import t4u.common.DBConnection;
import t4u.functions.AdminFunctions;
import t4u.functions.CommonFunctions;
import t4u.functions.CreateLandmarkFunctions;
import t4u.functions.CreateTripFunction;
import t4u.functions.GeneralVerticalFunctions;
import t4u.statements.GeneralVerticalStatements;

public class CreateRoute {

	SimpleDateFormat sdfDB = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
	SimpleDateFormat sdf1 = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
	SimpleDateFormat sdfDBMMDD = new SimpleDateFormat("yyyy-MM-dd");
	SimpleDateFormat mmddyyy = new SimpleDateFormat("MM/dd/yyyy HH:mm:ss");
	SimpleDateFormat timef = new SimpleDateFormat("HH:mm");
	SimpleDateFormat timenew = new SimpleDateFormat("HH:mm:ss");
	DecimalFormat df = new DecimalFormat("00.00");
	DecimalFormat df1 = new DecimalFormat("#.##");
	DecimalFormat df2 = new DecimalFormat("0.00");
	public static Object lock = new Object();

	GeneralVerticalFunctions gf = new GeneralVerticalFunctions();
	CreateTripFunction ctf = new CreateTripFunction();
	CreateLandmarkFunctions createLandmarkFunctions = new CreateLandmarkFunctions();
	AdminFunctions af = new AdminFunctions();
	CommonFunctions cf = new CommonFunctions();

	public String[] saveHub(int systemId, int userId, String sessionId, String serverName, int isLtsp, JSONObject hubObject, int clientId, double converfactor, String name, String zone) {
		String[] messageArr = null;
		try {
			String Type = hubObject.getString("geofenceType");
			String clientid = hubObject.getString("CustID");
			String radius = "";
			String latitude = hubObject.getString("latitude");
			String longitude = hubObject.getString("longitude");
			String image = "";
			String GMT = "5:30";
			String stdDuration = hubObject.getString("standardDuration");
			String city = " ";
			String state = " ";
			String country = "INDIA";
			String region = hubObject.getString("region");
			String tripCustomerId = hubObject.getString("tripCustomerId");
			String contactPerson = hubObject.getString("contactPerson");
			String address = hubObject.getString("address");
			String description = hubObject.getString("desc");
			double newradius = 0.0;
			DecimalFormat df = new DecimalFormat("#.##");
			String checkBoxValue = hubObject.getString("checkBoxValue");
			String pincode = hubObject.getString("pincode");

			if (hubObject.getString("radius") != null) {
				radius = hubObject.getString("radius");
				if (!radius.equalsIgnoreCase("-1")) {
					newradius = (Double.parseDouble(radius) / converfactor);
					radius = df.format(newradius);
				}
			}

			if (hubObject.getString("city") != null) {
				city = hubObject.getString("city").toUpperCase();
			}
			if (hubObject.getString("state") != null) {
				state = hubObject.getString("state").toUpperCase();
			}

			JSONArray countryDetails = af.getCountryId(hubObject.getString("country"));
			JSONArray stateDetails = af.getRegion(countryDetails.getJSONObject(0).getString("CountryID"), state);
			if (stateDetails.length() > 0) {
				region = stateDetails.getJSONObject(0).getString("Region");
			}

			String location = gf.getNumeralHubCode(systemId, Integer.parseInt(clientid), city, Integer.parseInt(tripCustomerId), zone);
			if (location.contains("*")) {
				location = location.replace("***1", name);
			}
			//For Generic Hub
			if (Type.equalsIgnoreCase("Generic Hub")) {
				String cityCode = gf.getIATACodeAndIRCTCCode(city);
				if (cityCode.contains("*")) {
					location = cityCode.replace("***", name.replace("-", "_"));
				} else {
					location = cityCode + "_GEN";
				}
				tripCustomerId = "0";
			}
			location = location + ',' + city + ',' + state + ',' + country;

			String response = createLandmarkFunctions.saveLocationBuffer(location, Type, clientid, radius, latitude, longitude, image, GMT, String.valueOf(systemId), stdDuration, "QTP", sessionId,
					serverName, userId, checkBoxValue, clientId, isLtsp, region, tripCustomerId, contactPerson, address, description, city, state, pincode, "");
			messageArr = response.split("##");
		} catch (Exception e) {
			e.printStackTrace();
		}
		return messageArr;
	}

	public JSONObject saveLegDetails(String legDetails, int systemId, int userId, String sessionId, String serverName, int clientId, String avgSpeed, List<String> hubList, String zone)
			throws JSONException {
		JSONObject object = new JSONObject();
		String tripCustId = "";
		String leg = "";
		JSONArray legJs = null;
		if (legDetails != null) {
			legJs = new JSONArray(legDetails.toString());
		}
		String[] legIds = new String[legJs.length()];
		try {

			for (int i = 0; i < legJs.length(); i++) {
				@SuppressWarnings("unused")
				String legId = "";
				object = legJs.getJSONObject(i);
				tripCustId = object.getString("tripCustId");
				String source = hubList.get(i).split("_")[0];
				String destination = hubList.get(i + 1).split("_")[0];
				String distance = object.getString("distance");
				String tat = String.valueOf(Math.round((Double.parseDouble(distance) / Double.parseDouble(avgSpeed)) * 60));
				String TAT = cf.convertMinutesToHHMMFormat(Integer.parseInt(tat));
				String sLat = object.getString("sLat");
				String sLon = object.getString("sLon");
				String dLat = object.getString("dLat");
				String dLon = object.getString("dLon");
				String checkPointArray = object.getString("checkPointArray");
				String jsonArray = object.getString("jsonArray");
				String dragPointArray = object.getString("dragPointArray");

				String Sarr[] = gf.getHubDetails(source, zone).split("##");
				String Darr[] = gf.getHubDetails(destination, zone).split("##");
				String sourceRad = Sarr[1];
				String destinationRad = Darr[1];
				String sourceDet = Sarr[0];
				String destinationDet = Darr[0];
				String durationArr = object.getString("durationArr");
				String distanceArray = object.getString("distanceArr");
				int legModId = 0;
				String statusA = object.getString("statusA");
				String legName = "";
				String legSource = gf.getHubName(source, zone);
				String legDestination = gf.getHubName(destination, zone);

				if (hubList.get(i).split("_")[1].equalsIgnoreCase("Generic Hub")) {
					legSource = gf.getGenericHubName(source, zone) + "_GEN";
				}
				if (hubList.get(i + 1).split("_")[1].equalsIgnoreCase("Generic Hub")) {
					legDestination = gf.getGenericHubName(destination, zone) + "_GEN";
					;
				}
				legName = legSource + "_" + legDestination;

				if (object.getString("legModId") != null && !object.getString("legModId").equals("")) {
					legModId = Integer.parseInt(object.getString("legModId"));
				}
				jsonArray = jsonArray.substring(1, jsonArray.length() - 2);
				String[] routejs = jsonArray.replaceAll("^[^{]*|[^}]*$", "").split("(?<=\\})[^{]*");

				String[] checkPointjs = null;
				String[] dragPointjs = null;
				String[] duraionPointjs = null;
				String[] distancePointjs = null;
				if (checkPointArray.length() > 2) {
					checkPointArray = checkPointArray.substring(1, checkPointArray.length() - 2);
					checkPointjs = checkPointArray.replaceAll("^[^{]*|[^}]*$", "").split("(?<=\\})[^{]*");
				}
				if (durationArr.length() > 2) {
					durationArr = durationArr.substring(1, durationArr.length() - 2);
					duraionPointjs = durationArr.replaceAll("^[^{]*|[^}]*$", "").split("(?<=\\})[^{]*");
				}
				if (dragPointArray.length() > 2) {
					dragPointArray = dragPointArray.substring(1, dragPointArray.length() - 2);
					dragPointjs = dragPointArray.replaceAll("^[^{]*|[^}]*$", "").split("(?<=\\})[^{]*");
				}
				if (distanceArray.length() > 2) {
					distanceArray = distanceArray.substring(1, distanceArray.length() - 2);
					distancePointjs = distanceArray.replaceAll("^[^{]*|[^}]*$", "").split("(?<=\\})[^{]*");
				}
				String message = gf.saveLegDetails(Integer.parseInt(tripCustId), legName, source, destination, distance, avgSpeed, TAT, checkPointjs, routejs, dragPointjs, systemId, clientId, userId,
						sLat, sLon, dLat, dLon, legModId, statusA, sourceRad, sourceDet, destinationRad, destinationDet, duraionPointjs, sessionId, serverName, "QTP", distancePointjs, zone);
				String[] res = message.split("##");

				leg = String.valueOf(i + 1) + ',' + res[1];
				legId = "{" + leg + "}";

				legIds[i] = "{" + leg + "}";
			}
			object.put("tripCustId", tripCustId);
			object.put("legIds", legIds);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return object;
	}

	public JSONObject saveRouteDetails(JSONObject routeObj, int systemId, int userId, String sessionId, String serverName, int clientId, String tripCustId, String[] legIds, String zone) {
		String message = "";
		JSONObject jobj = new JSONObject();
		try {
			int routeModId = 0;
			String routeTAT = routeObj.getString("TAT");
			String routeDistance = routeObj.getString("distance");
			String routeTripCustId = tripCustId;
			String routeName = routeObj.getString("routeName");
			String routeKey = routeObj.getString("routeKey");
			String routeStatusA = routeObj.getString("statusA");
			String routeRadius = routeObj.getString("routeRadius");
			String detentionCheckPointsArray = routeObj.getString("detentionCheckPointsArray");

			message = gf.saveRouteDetails(Integer.parseInt(routeTripCustId), routeName, routeKey, routeDistance, routeTAT, legIds, systemId, clientId, userId, routeModId, routeStatusA, routeRadius,
					sessionId, serverName, "QTP", detentionCheckPointsArray, zone);
			String[] mess = message.split("##");
			jobj.put("message", mess[0]);
			jobj.put("routeKey", mess[1]);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return jobj;
	}

	public JSONArray getSourceDestination(int clientId, int systemId, String zone, int tripCustId, String type) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject = null;
		try {
			con = DBConnection.getConnectionToDB("AMS");
			jsonObject = new JSONObject();
			jsonObject.put("Hub_Id", "");
			jsonObject.put("Hub_Name", "---select---");
			jsonObject.put("latitude", "");
			jsonObject.put("longitude", "");
			jsonObject.put("radius", "");
			jsonArray.put(jsonObject);
			String query = cf.getLocationQuery(GeneralVerticalStatements.GET_SOURCE_DESTINATION_HUBS, zone);

			query = query.replace("#", "and TRIP_CUSTOMER_ID = " + tripCustId + " ");

			pstmt = con.prepareStatement(query);
			pstmt.setInt(1, clientId);
			pstmt.setInt(2, systemId);
			pstmt.setInt(3, clientId);
			pstmt.setInt(4, systemId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				jsonObject = new JSONObject();
				jsonObject.put("Hub_Id", rs.getInt("HUBID"));
				jsonObject.put("Hub_Name", rs.getString("NAME"));
				jsonObject.put("latitude", rs.getString("LATITUDE"));
				jsonObject.put("longitude", rs.getString("LONGITUDE"));
				jsonObject.put("radius", rs.getString("RADIUS"));
				jsonObject.put("detention", rs.getString("DETENTION"));
				jsonObject.put("hubAddress", rs.getString("HUB_ADDRESS"));
				jsonObject.put("type", rs.getString("OPERATION_ID"));
				jsonArray.put(jsonObject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jsonArray;
	}

}
