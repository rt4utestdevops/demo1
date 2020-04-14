package t4u.util;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.List;
import java.util.Properties;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.xpath.XPath;
import javax.xml.xpath.XPathConstants;
import javax.xml.xpath.XPathExpression;
import javax.xml.xpath.XPathExpressionException;
import javax.xml.xpath.XPathFactory;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.w3c.dom.Document;
import org.xml.sax.SAXException;

import com.t4u.graphhopper.GraphHopperDistanceAndDurationBean;
import com.t4u.graphhopper.GraphHopperDistanceAndDurationJar;

import t4u.beans.MapAPIConfigBean;
import t4u.common.ApplicationListener;

public class TimeAndDistanceCalculator {

	GraphHopperDistanceAndDurationJar graphHopperDistanceAndDurationJar = new GraphHopperDistanceAndDurationJar();

	private Properties getProperties() {
		Properties properties = null;
		try {
			properties = ApplicationListener.prop;
		} catch (Exception e) {
			e.printStackTrace();
		}

		return properties;

	}

	public Integer getvehicleSpeed() {
		Integer vehicleAvgSpeed = null;
		Properties prop = null;
		try {
			prop = getProperties();
			if (prop != null) {
				try {
					vehicleAvgSpeed = Integer.parseInt(prop.getProperty("vehicleAvgSpeed"));
				} catch (Exception e) {
					vehicleAvgSpeed = null;
				}
			}

		} catch (Exception e) {
			e.printStackTrace();
		}
		return vehicleAvgSpeed;

	}

	public JSONObject calculateTimeAndDistance(List<LatLng> latlongs, MapAPIConfigBean mapAPIConfigBean) {
		JSONObject jsonObject = new JSONObject();
		try {
			String type = mapAPIConfigBean.getMapName();
			if (type.equalsIgnoreCase("GOOGLE")) {
				jsonObject = getGoogleDistanceMatrix(latlongs, mapAPIConfigBean);
			} else if (type.equalsIgnoreCase("HERE")) {
				jsonObject = getHERERoutingAPI(latlongs, mapAPIConfigBean);
			} else {
				jsonObject = getGraphHopperDistanceAndDuration(latlongs, mapAPIConfigBean);
			}

		} catch (Exception e) {
			e.printStackTrace();
		}
		return jsonObject;
	}

	public JSONArray calculateTimeAndDistanceMultipleLatlongs(List<LatLng> latlongs, MapAPIConfigBean mapAPIConfigBean) {
		JSONArray jsonArray = new JSONArray();
		try {
			String type = mapAPIConfigBean.getMapName();
			if (type.equalsIgnoreCase("GOOGLE")) {
				jsonArray = getGoogleDistanceMatrixMultipleLatlongs(latlongs, mapAPIConfigBean);
			} else if (type.equalsIgnoreCase("HERE")) {
				jsonArray = getHERERoutingAPIMultipleLatlongs(latlongs, mapAPIConfigBean);
			} else {
				jsonArray = getGraphHopperDistanceAndDurationMultipleLatlongs(latlongs, mapAPIConfigBean);
			}

		} catch (Exception e) {
			e.printStackTrace();
		}
		return jsonArray;
	}

	public ArrayList<String> getLatLongFromAddress(String address, MapAPIConfigBean mapAPIConfigBean) throws IOException, ParserConfigurationException, SAXException,
			XPathExpressionException {

		ArrayList<String> arr = new ArrayList<String>();
		try {
			String type = mapAPIConfigBean.getMapName();
			if (type.equalsIgnoreCase("GOOGLE")) {
				arr = getLatLongFromAddressGoogleGeocoder(address, mapAPIConfigBean);
			} else if (type.equalsIgnoreCase("HERE")) {
				arr = getLatLongFromAddressHereGeocoder(address, mapAPIConfigBean);
			} else {

			}

		} catch (Exception e) {
			e.printStackTrace();
		}
		return arr;

	}

	public String getCityFromLatLongs(String lat, String lng, MapAPIConfigBean mapAPIConfigBean) throws IOException, ParserConfigurationException, SAXException,
			XPathExpressionException {

		String city = "";
		try {
			String type = mapAPIConfigBean.getMapName();
			if (type.equalsIgnoreCase("GOOGLE")) {
				city = getCityFromLatLongsGoogleGeocoder(lat, lng, mapAPIConfigBean);
			} else if (type.equalsIgnoreCase("HERE")) {
				city = getCityFromLatLongsHereGeocoder(lat, lng, mapAPIConfigBean);
			} else {

			}

		} catch (Exception e) {
			e.printStackTrace();
		}
		return city;

	}

	public List<LatLng> getLegPathLatLongs(String source, String destination, MapAPIConfigBean mapAPIConfigBean) throws IOException, ParserConfigurationException, SAXException,
			XPathExpressionException {

		List<LatLng> arr = new ArrayList<LatLng>();

		try {
			String type = mapAPIConfigBean.getMapName();
			if (type.equalsIgnoreCase("GOOGLE")) {
				arr = getLegPathLatLongsGoogle(source, destination, mapAPIConfigBean);
			} else if (type.equalsIgnoreCase("HERE")) {
				arr = getLegPathLatLongsHere(source, destination, mapAPIConfigBean);
			} else {
				// jsonObject = getGraphHopperDistanceAndDuration(latlongs,
				// mapAPIConfigBean);
			}

		} catch (Exception e) {
			e.printStackTrace();
		}
		return arr;

	}

	private JSONObject getGoogleDistanceMatrix(List<LatLng> latlongs, MapAPIConfigBean mapAPIConfigBean) {
		JSONObject json = new JSONObject();

		double kms = 0;
		long durationMins = 0;
		long durationMinsWithTraffic = 0;
		HttpURLConnection conn = null;
		String mode = "driving";
		String traffic = "";
		String googleKey = mapAPIConfigBean.getAPIKey();// prop.getProperty("DHL_KEY").trim();
		//googleKey = "AIzaSyCyYEUU6pc21YSjckg3bB41p2EFLCDARGg";
		Integer vehicleAvgSpeed = null;

		try {
			vehicleAvgSpeed = getvehicleSpeed();

			if (mapAPIConfigBean.isWalkingMode()) {
				mode = "walking";
			} else {
				mode = "driving";
			}
			if (mapAPIConfigBean.isLiveTraffic()) {
				traffic = "&departure_time=now";
			} else {
				traffic = "";
			}
			String source = latlongs.get(0).getLat() + "," + latlongs.get(0).getLng();
			String destination = latlongs.get(1).getLat() + "," + latlongs.get(1).getLng();
			String url1 = "https://maps.googleapis.com/maps/api/distancematrix/json?mode=" + mode + "&origins=" + source + "&destinations=" + destination + "&key=" + googleKey
					+ traffic;
			URL url = new URL(url1);
			JSONArray elements = getGoogleDistanceMatrixJSONArray(conn, url);
			JSONObject jsonObject = new JSONObject(elements.getString(0));
			if ("OK".equals(jsonObject.getString("status"))) {
				JSONObject metersjson = new JSONObject(jsonObject.getString("distance"));
				JSONObject durJson = new JSONObject(jsonObject.getString("duration"));
				JSONObject durWithTrafficJson = null;
				try {
					durWithTrafficJson = new JSONObject(jsonObject.getString("duration_in_traffic"));
				} catch (Exception e) {
					durWithTrafficJson = new JSONObject(jsonObject.getString("duration"));
				}

				kms = (metersjson.getDouble("value") / 1000);
				durationMins = (durJson.getLong("value") / 60);
				durationMinsWithTraffic = (durWithTrafficJson.getLong("value") / 60);
				json.put("distanceInKms", kms);
				json.put("durationInMins", vehicleAvgSpeed != null ? Math.round((kms / vehicleAvgSpeed) * 60) : durationMins);
				json.put("durationMinsWithTraffic", vehicleAvgSpeed != null ? Math.round((kms / vehicleAvgSpeed) * 60) : durationMinsWithTraffic);

			} else {
				json.put("distanceInKms", kms);
				json.put("durationInMins", durationMins);
				json.put("durationMinsWithTraffic", durationMinsWithTraffic);
			}
		} catch (Exception ex) {
			ex.printStackTrace();
			try {
				json.put("distanceInKms", kms);
				json.put("durationInMins", durationMins);
				json.put("durationMinsWithTraffic", durationMinsWithTraffic);
			} catch (JSONException e) {
				e.printStackTrace();
			}

		}
		return json;

	}

	private JSONArray getGoogleDistanceMatrixJSONArray(HttpURLConnection conn, URL url) throws IOException, JSONException {
		conn = (HttpURLConnection) url.openConnection();
		conn.setRequestMethod("GET");
		String line;
		StringBuilder buffer = new StringBuilder();
		try {
			BufferedReader reader = new BufferedReader(new InputStreamReader(conn.getInputStream()));
			while ((line = reader.readLine()) != null) {
				buffer.append(line);
			}
			reader.close();
			JSONArray elements = new JSONArray(new JSONObject(buffer.toString()).getString("rows"));
			return new JSONArray(new JSONObject(elements.getString(0)).getString("elements"));
		} catch (Exception e) {
			return new JSONArray();
		}

	}

	private JSONObject getHERERoutingAPI(List<LatLng> latlongs, MapAPIConfigBean mapAPIConfigBean) {
		JSONObject json = new JSONObject();

		double kms = 0;
		long durationMins = 0;
		long durationMinsWithTraffic = 0;
		HttpURLConnection conn = null;
		String traffic = "";
		Integer vehicleAvgSpeed = null;
		String waypoints = "";

		try {
			vehicleAvgSpeed = getvehicleSpeed();
			if (mapAPIConfigBean.isWalkingMode()) {
				mapAPIConfigBean.setVehicleType("pedestrian");
			}
			if (mapAPIConfigBean.isLiveTraffic()) {
				traffic = "&departure=now";
			} else {
				traffic = "";
			}
			for (LatLng latLng : latlongs) {
				if (latlongs.indexOf(latLng) == 0) {
					waypoints = "waypoint" + (latlongs.indexOf(latLng)) + "=" + latLng.getLat() + "," + latLng.getLng();
				} else {
					waypoints = waypoints + "&waypoint" + (latlongs.indexOf(latLng)) + "=" + latLng.getLat() + "," + latLng.getLng();
				}

			}
			String url1 = "https://route.api.here.com/routing/7.2/calculateroute.json?" + waypoints + "&mode=" + mapAPIConfigBean.getRoutingType().trim() + ";"
					+ mapAPIConfigBean.getVehicleType().trim() + ";traffic:" + mapAPIConfigBean.getTrafficType().trim() + "&app_id=" + mapAPIConfigBean.getAPIKey().trim()
					+ "&app_code=" + mapAPIConfigBean.getAppCode().trim() + traffic;
			URL url = new URL(url1);
			JSONArray array = getHEREMapRoutingAPIJSONArray(conn, url);
			if (array.length() > 0) {
				JSONObject obj = array.getJSONObject(0);
				JSONObject summary = obj.getJSONObject("summary");
				kms = summary.getDouble("distance") / 1000;
				durationMins = (summary.getLong("baseTime") / 60);
				try {
					durationMinsWithTraffic = (summary.getLong("trafficTime") / 60);
				} catch (Exception e) {
					durationMinsWithTraffic = durationMins;
				}
				json.put("distanceInKms", kms);
				json.put("durationInMins", vehicleAvgSpeed != null ? Math.round((kms / vehicleAvgSpeed) * 60) : durationMins);
				json.put("durationMinsWithTraffic", vehicleAvgSpeed != null ? Math.round((kms / vehicleAvgSpeed) * 60) : durationMinsWithTraffic);
			} else {
				json.put("distanceInKms", kms);
				json.put("durationInMins", durationMins);
				json.put("durationMinsWithTraffic", durationMinsWithTraffic);
			}

		} catch (Exception ex) {
			ex.printStackTrace();
			try {
				json.put("distanceInKms", kms);
				json.put("durationInMins", durationMins);
				json.put("durationMinsWithTraffic", durationMinsWithTraffic);
			} catch (JSONException e) {
				e.printStackTrace();
			}

		}
		return json;

	}

	private JSONArray getHEREMapRoutingAPIJSONArray(HttpURLConnection conn, URL url) throws IOException, JSONException {
		JSONArray jArr = new JSONArray();
		try {
			conn = (HttpURLConnection) url.openConnection();
			conn.setRequestMethod("GET");
			String line;
			StringBuilder buffer = new StringBuilder();
			try {
				BufferedReader reader = new BufferedReader(new InputStreamReader(conn.getInputStream()));
				while ((line = reader.readLine()) != null) {
					buffer.append(line);
				}
				reader.close();
				JSONObject obj = new JSONObject(buffer.toString());

				if (obj.has("response")) {
					JSONObject response = obj.getJSONObject("response");
					jArr = response.getJSONArray("route");
					System.out.println("" + jArr);
				}
			} catch (Exception e) {
				e.printStackTrace();
			}

		} catch (Exception e) {
			e.printStackTrace();
		}

		return jArr;
	}

	private JSONArray getHEREMapGeocoderAPIJSONArray(HttpURLConnection conn, URL url) throws IOException, JSONException {
		JSONArray jArr = new JSONArray();
		try {
			conn = (HttpURLConnection) url.openConnection();
			conn.setRequestMethod("GET");
			String line;
			StringBuilder buffer = new StringBuilder();
			try {
				BufferedReader reader = new BufferedReader(new InputStreamReader(conn.getInputStream()));
				while ((line = reader.readLine()) != null) {
					buffer.append(line);
				}
				reader.close();
				JSONObject obj = new JSONObject(buffer.toString());

				if (obj.has("Response")) {
					JSONObject response = obj.getJSONObject("Response");
					jArr = response.getJSONArray("View");
				}
			} catch (Exception e) {
				e.printStackTrace();
			}

		} catch (Exception e) {
			e.printStackTrace();
		}

		return jArr;
	}

	private JSONObject getGraphHopperDistanceAndDuration(List<LatLng> latlongs, MapAPIConfigBean mapAPIConfigBean) {
		Double distance = 0.0;
		long durationMins = 0;
		JSONObject json = new JSONObject();
		Integer vehicleAvgSpeed = null;
		try {
			vehicleAvgSpeed = getvehicleSpeed();
			GraphHopperDistanceAndDurationBean db = graphHopperDistanceAndDurationJar.getDistance(latlongs.get(0).getLat(), latlongs.get(0).getLng(), latlongs.get(1).getLat(),
					latlongs.get(1).getLng(), mapAPIConfigBean.getGraphHopperMapFile().trim());
			if (db != null) {
				durationMins = db.getTimeinMins();
				distance = db.getDistanceinKms();
				json.put("distanceInKms", distance);
				json.put("durationInMins", vehicleAvgSpeed != null ? Math.round((distance / vehicleAvgSpeed) * 60) : durationMins);
				json.put("durationMinsWithTraffic", vehicleAvgSpeed != null ? Math.round((distance / vehicleAvgSpeed) * 60) : durationMins);
			} else {
				json.put("distanceInKms", distance);
				json.put("durationInMins", durationMins);
				json.put("durationMinsWithTraffic", durationMins);
			}
		} catch (Exception e) {
			e.printStackTrace();
			try {
				json.put("distanceInKms", distance);
				json.put("durationInMins", durationMins);
				json.put("durationMinsWithTraffic", durationMins);
			} catch (JSONException e1) {
				e1.printStackTrace();
			}

		}
		return json;
	}

	private JSONArray getGoogleDistanceMatrixMultipleLatlongs(List<LatLng> latlongs, MapAPIConfigBean mapAPIConfigBean) {
		JSONArray elements = null;
		String source = "";
		StringBuilder destLatLongs = new StringBuilder();

		try {
			for (LatLng latLng : latlongs) {
				if (latlongs.indexOf(latLng) == 0) {
					source = latLng.getLat() + "," + latLng.getLng();
				} else {
					destLatLongs.append(latLng.getLat());
					destLatLongs.append(",");
					destLatLongs.append(latLng.getLng());
					destLatLongs.append("|");
				}
			}

			URL url = new URL("https://maps.googleapis.com/maps/api/distancematrix/json?key=" + mapAPIConfigBean.getAPIKey().trim() + "&origins=" + source + "&destinations="
					+ destLatLongs);
			HttpURLConnection conn = (HttpURLConnection) url.openConnection();
			conn.setRequestMethod("GET");
			String line = "";
			StringBuffer outputString = new StringBuffer();
			BufferedReader reader = new BufferedReader(new InputStreamReader(conn.getInputStream()));
			while ((line = reader.readLine()) != null) {
				outputString.append(line);
			}
			reader.close();
			JSONArray rows = new JSONArray(new JSONObject(outputString.toString()).getString("rows"));
			if (rows != null && !"".equals(rows)) {
				elements = new JSONArray(new JSONObject(rows.getString(0)).getString("elements"));
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return elements;

	}

	private JSONArray getHERERoutingAPIMultipleLatlongs(List<LatLng> latlongs, MapAPIConfigBean mapAPIConfigBean) {

		JSONArray jsonArray = new JSONArray();
		HttpURLConnection conn = null;
		String traffic = "";
		String waypoints = "";

		try {
			if (mapAPIConfigBean.isWalkingMode()) {
				mapAPIConfigBean.setVehicleType("pedestrian");
			}
			if (mapAPIConfigBean.isLiveTraffic()) {
				traffic = "&departure=now";
			} else {
				traffic = "";
			}

			for (LatLng latLng : latlongs) {
				if (latlongs.indexOf(latLng) == 0) {
					waypoints = "waypoint" + (latlongs.indexOf(latLng)) + "=" + latLng.getLat() + "," + latLng.getLng();
				} else {
					waypoints = waypoints + "&waypoint" + (latlongs.indexOf(latLng)) + "=" + latLng.getLat() + "," + latLng.getLng();
				}

			}

			String url1 = "https://route.api.here.com/routing/7.2/calculateroute.json?" + waypoints + "&mode=" + mapAPIConfigBean.getRoutingType().trim() + ";"
					+ mapAPIConfigBean.getVehicleType().trim() + ";traffic:" + mapAPIConfigBean.getTrafficType().trim() + "&app_id=" + mapAPIConfigBean.getAPIKey().trim()
					+ "&app_code=" + mapAPIConfigBean.getAppCode().trim() + traffic;
			URL url = new URL(url1);
			JSONArray array = getHEREMapRoutingAPIJSONArray(conn, url);
			if (array.length() > 0) {
				JSONObject obj = array.getJSONObject(0);
				jsonArray = obj.getJSONArray("leg");
			}

		} catch (Exception ex) {
			ex.printStackTrace();

		}
		return jsonArray;

	}

	private JSONArray getGraphHopperDistanceAndDurationMultipleLatlongs(List<LatLng> latlongs, MapAPIConfigBean mapAPIConfigBean) {
		// TODO Auto-generated method stub
		return null;
	}

	private ArrayList<String> getLatLongFromAddressHereGeocoder(String address, MapAPIConfigBean mapAPIConfigBean) throws Exception {
		ArrayList<String> latLongs = null;
		HttpURLConnection conn = null;
		String api = "https://geocoder.api.here.com/6.2/geocode.json?app_id=" + mapAPIConfigBean.getAPIKey().trim() + "&app_code=" + mapAPIConfigBean.getAppCode().trim()
				+ "&searchtext=" + URLEncoder.encode(address, "UTF-8");
		URL url = new URL(api);
		JSONArray array = getHEREMapGeocoderAPIJSONArray(conn, url);
		if (array.length() > 0) {
			JSONObject object = array.getJSONObject(0);
			if (object.length() > 0) {
				JSONArray result = object.getJSONArray("Result");
				if (result.length() > 0) {
					JSONObject obj1 = result.getJSONObject(0);
					if (obj1.length() > 0) {
						JSONObject location = obj1.getJSONObject("Location");
						if (location.length() > 0) {
							JSONObject displayPosition = location.getJSONObject("DisplayPosition");
							if (displayPosition.length() > 0) {
								latLongs = new ArrayList<String>();
								latLongs.add(displayPosition.getString("Latitude"));
								latLongs.add(displayPosition.getString("Longitude"));
							}
						}
					}
				}
			}

		}

		return latLongs;
	}

	private ArrayList<String> getLatLongFromAddressGoogleGeocoder(String address, MapAPIConfigBean mapAPIConfigBean) throws Exception {
		ArrayList<String> latLongs = null;
		int responseCode = 0;
		String api = "https://maps.googleapis.com/maps/api/geocode/xml?key=" + mapAPIConfigBean.getAPIKey().trim() + "=&address=" + URLEncoder.encode(address, "UTF-8")
				+ "&sensor=true";
		URL url = new URL(api);
		HttpURLConnection httpConnection = (HttpURLConnection) url.openConnection();
		httpConnection.connect();
		responseCode = httpConnection.getResponseCode();
		if (responseCode == 200) {
			DocumentBuilder builder = DocumentBuilderFactory.newInstance().newDocumentBuilder();
			;
			Document document = builder.parse(httpConnection.getInputStream());
			XPathFactory xPathfactory = XPathFactory.newInstance();
			XPath xpath = xPathfactory.newXPath();
			XPathExpression expr = xpath.compile("/GeocodeResponse/status");
			String status = (String) expr.evaluate(document, XPathConstants.STRING);
			if (status.equals("OK")) {
				latLongs = new ArrayList<String>();
				latLongs.add((String) xpath.compile("//geometry/location/lat").evaluate(document, XPathConstants.STRING));
				latLongs.add((String) xpath.compile("//geometry/location/lng").evaluate(document, XPathConstants.STRING));
			}
		}
		return latLongs;
	}

	private List<LatLng> getLegPathLatLongsGoogle(String source, String destination, MapAPIConfigBean mapAPIConfigBean) throws Exception {

		String URL = "https://maps.googleapis.com/maps/api/directions/json?key=" + mapAPIConfigBean.getAPIKey().trim() + "&origin=" + source + "&destination=" + destination
				+ "&sensor=false";
		URL obj = new URL(URL);
		HttpURLConnection con = (HttpURLConnection) obj.openConnection();
		con.setRequestMethod("GET");
		BufferedReader in = new BufferedReader(new InputStreamReader(con.getInputStream()));
		String inputLine;
		StringBuffer response = new StringBuffer();
		while ((inputLine = in.readLine()) != null) {
			response.append(inputLine);
		}
		List<LatLng> points = new ArrayList<LatLng>();
		JSONObject myResponse = new JSONObject(response.toString());
		JSONArray jRoutes = myResponse.getJSONArray("routes");
		for (int i = 0; i < 1; i++) {
			JSONObject jLegs = ((JSONObject) jRoutes.get(i)).getJSONObject("overview_polyline");
			String jSteps = ((JSONObject) jLegs).getString("points");
			List<LatLng> list = decodePoly(jSteps);
			for (int l = 0; l < list.size(); l++) {
				double lat = ((LatLng) list.get(l)).getLat();
				double lng = ((LatLng) list.get(l)).getLng();
				LatLng position = new LatLng(lat, lng);
				points.add(position);
			}
		}
		return points;
	}

	private List<LatLng> decodePoly(String encoded) {

		List<LatLng> poly = new ArrayList<LatLng>();
		int index = 0, len = encoded.length();
		int lat = 0, lng = 0;

		while (index < len) {
			int b, shift = 0, result = 0;
			do {
				b = encoded.charAt(index++) - 63;
				result |= (b & 0x1f) << shift;
				shift += 5;
			} while (b >= 0x20);
			int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
			lat += dlat;

			shift = 0;
			result = 0;
			do {
				b = encoded.charAt(index++) - 63;
				result |= (b & 0x1f) << shift;
				shift += 5;
			} while (b >= 0x20);
			int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
			lng += dlng;

			LatLng p = new LatLng((((double) lat / 1E5)), (((double) lng / 1E5)));
			poly.add(p);
		}

		return poly;
	}

	private List<LatLng> getLegPathLatLongsHere(String source, String destination, MapAPIConfigBean mapAPIConfigBean) {

		HttpURLConnection conn = null;
		String traffic = "";
		List<LatLng> latLngs = new ArrayList<LatLng>();

		try {
			if (mapAPIConfigBean.isWalkingMode()) {
				mapAPIConfigBean.setVehicleType("pedestrian");
			}
			if (mapAPIConfigBean.isLiveTraffic()) {
				traffic = "&departure=now";
			} else {
				traffic = "";
			}
			String url1 = "https://route.api.here.com/routing/7.2/calculateroute.json?waypoint0=" + source + "&waypoint1=" + destination + "&mode="
					+ mapAPIConfigBean.getRoutingType().trim() + ";" + mapAPIConfigBean.getVehicleType().trim() + ";traffic:" + mapAPIConfigBean.getTrafficType().trim()
					+ "&app_id=" + mapAPIConfigBean.getAPIKey().trim() + "&app_code=" + mapAPIConfigBean.getAppCode().trim() + traffic;
			URL url = new URL(url1);
			JSONArray route = getHEREMapRoutingAPIJSONArray(conn, url);

			for (int i = 0; i < route.length(); i++) {
				JSONObject object = route.getJSONObject(i);
				if (object.length() > 0) {
					JSONArray legArray = object.getJSONArray("leg");
					if (legArray.length() > 0) {
						for (int j = 0; j < legArray.length(); j++) {
							JSONObject legArrayObj = legArray.getJSONObject(j);
							if (legArrayObj.length() > 0) {
								JSONArray maneuver = legArrayObj.getJSONArray("maneuver");
								if (maneuver.length() > 0) {
									for (int k = 0; k < maneuver.length(); k++) {
										JSONObject manuverObject = maneuver.getJSONObject(k);
										if (manuverObject.length() > 0) {
											JSONObject position = manuverObject.getJSONObject("position");
											if (position.length() > 0) {
												latLngs.add(new LatLng(position.getDouble("latitude"), position.getDouble("longitude")));
											}
										}
									}

								}
							}

						}

					}
				}

			}

		} catch (Exception ex) {
			ex.printStackTrace();
		}
		return latLngs;

	}

	private String getCityFromLatLongsHereGeocoder(String lat, String lng, MapAPIConfigBean mapAPIConfigBean) throws Exception {

		HttpURLConnection conn = null;

		String city = "";

		try {

			String api = "https://reverse.geocoder.api.here.com/6.2/reversegeocode.json?prox=" + lat + "," + lng + ",250&mode=retrieveAddresses&maxresults=1&gen=9&app_id="
					+ mapAPIConfigBean.getAPIKey().trim() + "&app_code=" + mapAPIConfigBean.getAppCode().trim();
			URL url = new URL(api);
			JSONArray array = getHEREMapGeocoderAPIJSONArray(conn, url);
			if (array.length() > 0) {
				JSONObject obj = array.getJSONObject(0);
				if (obj.length() > 0) {

					JSONArray result = obj.getJSONArray("Result");
					if (result.length() > 0) {
						for (int i = 0; i < result.length(); i++) {
							JSONObject object = result.getJSONObject(i);
							if (object.length() > 0) {
								JSONObject location = object.getJSONObject("Location");
								if (location.length() > 0) {
									JSONObject address = location.getJSONObject("Address");
									if (address.length() > 0) {
										city = address.getString("City");
									}
								}
							}

						}
					}
				}

			}

		} catch (Exception ex) {
			ex.printStackTrace();
		}
		return city;

	}

	private String getCityFromLatLongsGoogleGeocoder(String lat, String lng, MapAPIConfigBean mapAPIConfigBean) {
		String city = "";
		try {

			URL url = new URL("https://maps.googleapis.com/maps/api/geocode/json?latlng=" + lat + "," + lng + "&sensor=false&&key=" + mapAPIConfigBean.getAPIKey().trim());

			HttpURLConnection conn = (HttpURLConnection) url.openConnection();
			conn.setRequestMethod("GET");
			conn.setRequestProperty("Accept", "application/json");

			if (conn.getResponseCode() != 200) {
				throw new RuntimeException("Failed : HTTP error code : " + conn.getResponseCode());
			}

			BufferedReader br = new BufferedReader(new InputStreamReader((conn.getInputStream())));

			String output;
			StringBuffer outputRest = new StringBuffer();
			while ((output = br.readLine()) != null) {
				outputRest.append(output);
			}
			String st = new String(outputRest);
			JSONObject jsonObject = new JSONObject(st);
			JSONArray results = (JSONArray) jsonObject.get("results");
			if (results.length() > 0) {
				JSONObject address = (JSONObject) results.get(0);

				JSONArray address_comps = (JSONArray) address.get("address_components");

				for (int ac = 0; ac < address_comps.length(); ac++) {
					JSONObject component = (JSONObject) address_comps.get(ac);
					JSONArray types = (JSONArray) component.get("types");
					if (types.get(0) != null && types.get(0).equals("locality")) {
						city = component.get("long_name").toString();
						break;
					} else if (types.get(0) != null && types.get(0).equals("administrative_area_level_2")) {
						city = component.get("long_name").toString();
						break;
					}
				}
			}
			conn.disconnect();

		} catch (MalformedURLException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return city;
	}
}
