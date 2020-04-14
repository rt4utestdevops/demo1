package t4u.GeneralVertical;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;
import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.List;

import org.json.JSONException;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.JSONValue;

import t4u.beans.MapAPIConfigBean;
import t4u.util.LatLng;
import t4u.util.TimeAndDistanceCalculator;

import com.t4u.osm.DistanceBean;
import com.t4u.osm.DistanceJar;


public class CommonUtil {
	
	/*
	 * 
	 * method to get distance 
	 */
	TimeAndDistanceCalculator tdc = new TimeAndDistanceCalculator();
	public    ArrayList<Double> getDistanceFromOsm(double srclat,double srclng,double deslat,double deslng)
	{
		ArrayList<Double> disDur= null;
		try {
			disDur=new ArrayList<Double>();
			DistanceJar distanceJar = new DistanceJar();
			DistanceBean db = distanceJar.getDistance(srclat, srclng, deslat, deslng);
			if(db!=null){
				double  eta=(double) db.getTimeinMins();
				disDur.add(db.getDistanceinKms()>1?db.getDistanceinKms():1.0);
				disDur.add(eta>1?eta:1);
			}
			
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		return disDur;
	}
	
	/*
	 * 
	 * method to get distance from google API
	 */
	public    ArrayList<Double> getDistanceFromGoogleAPI(double srclat,double srclng,double deslat,double deslng,String key,MapAPIConfigBean mapAPIConfigBean)
	{
		ArrayList<Double> disDur= new ArrayList<Double>();
		Long dd1= 0l;
		Long dd2=0l;
		List<LatLng> latlongs = new ArrayList<LatLng>();
		double distance1 = 0;
		double  duration1 = 0;
		latlongs.add(new LatLng(srclat, srclng));
		latlongs.add(new LatLng(deslat, deslng));
		try {
			
			org.json.JSONObject json = tdc.calculateTimeAndDistance(latlongs, mapAPIConfigBean);
			
			if (json.length() > 0){
				  try {
					 // converting to miles    
					distance1=(json.getDouble("distanceInKms"))/ 1.609344;  
					duration1=json.getDouble("durationInMins");
				} catch (JSONException e) {
					e.printStackTrace();
				}
				  
			}
			

//			URL url = new URL("https://maps.googleapis.com/maps/api/distancematrix/json?units=imperial&origins="+srclat+","+srclng+"&destinations="+deslat+","+deslng+"&mode=driving&key="+key);
//			HttpURLConnection conn = (HttpURLConnection) url.openConnection();
//			conn.setRequestMethod("GET");
//			conn.setRequestProperty("Accept", "application/json");
//
//			if (conn.getResponseCode() != 200) {
//				throw new RuntimeException("Failed : HTTP error code : "
//						+ conn.getResponseCode());
//			}
//
//			BufferedReader br = new BufferedReader(new InputStreamReader(
//					(conn.getInputStream())));
//
//			String output;
//
//			StringBuffer outputRest=new StringBuffer();
//			while ((output = br.readLine()) != null) {
//				outputRest.append(output);
//			}
//			String st=new String(outputRest);
//			Object obj=JSONValue.parse(st.trim());
//			JSONObject jsonObject = (JSONObject) obj;
//			JSONArray slideContent = (JSONArray) jsonObject.get("rows");
//
//			JSONObject jobj=(JSONObject)slideContent.get(0);
//			JSONArray title = (JSONArray) jobj.get("elements");
//			JSONObject dur= (JSONObject)title.get(0);
//			JSONObject value=(JSONObject)dur.get("distance");
//			JSONObject value01=(JSONObject)dur.get("duration");
//
//			if(value==null){
//
//			}else{
//				dd1=(Long)value.get("value");
//				dd2=(Long)value01.get("value");
//			}
//			double distance1=(double) dd1/1000;
//			double duration1=(double) dd2/60;
			disDur.add(distance1>1?distance1:1);
			disDur.add(duration1>1?duration1:1);
		//	conn.disconnect();

		} catch (Exception e) {

			e.printStackTrace();
		}
		return disDur;
	}

	public static double checkDistance(double initialLat, double initialLong, double finalLat, double finalLong){
		
		double latDiff = finalLat - initialLat;
		double longDiff = finalLong - initialLong;
		double earthRadius = 6371; //In Km if you want the distance in km
		
		double distance = 2*earthRadius*Math.asin(Math.sqrt(Math.pow(Math.sin(latDiff/2.0),2)+Math.cos(initialLat)*Math.cos(finalLat)*Math.pow(Math.sin(longDiff/2),2)));

		distance = ((distance*1.85200)/100);
		DecimalFormat twoDForm = new DecimalFormat("#.##");
		
		return Double.valueOf(twoDForm.format(distance));
	}
	
	/*
	 * 
	 * method to get city from google API
	 */
	public  static String getCityFomGoogleAPI(double lat,double lng,String key)
	{
		String city = "";
		try {

			URL url = new URL("https://maps.googleapis.com/maps/api/geocode/json?latlng="+lat+","+lng+"&sensor=false&&key="+key);
			HttpURLConnection conn = (HttpURLConnection) url.openConnection();
			conn.setRequestMethod("GET");
			conn.setRequestProperty("Accept", "application/json");

			if (conn.getResponseCode() != 200) {
				throw new RuntimeException("Failed : HTTP error code : "
						+ conn.getResponseCode());
			}

			BufferedReader br = new BufferedReader(new InputStreamReader(
					(conn.getInputStream())));

			String output;
			StringBuffer outputRest=new StringBuffer();
			while ((output = br.readLine()) != null) {
				outputRest.append(output);
			}
			String st=new String(outputRest);
			Object obj=JSONValue.parse(st.trim());
			JSONObject jsonObject = (JSONObject) obj;
			JSONArray results = (JSONArray) jsonObject.get("results");
			if(results.size() > 0){
				JSONObject address=(JSONObject)results.get(0);
				
				JSONArray address_comps = (JSONArray) address.get("address_components");
				
				for (int ac = 0; ac < address_comps.size(); ac++) {
					JSONObject component = (JSONObject)address_comps.get(ac);
					JSONArray types = (JSONArray) component.get("types");
	                if(types.get(0) != null && types.get(0).equals("locality")){
	                	city =  component.get("long_name").toString();
	                	break;
	                }
	            }
			}
			conn.disconnect();

		} catch (MalformedURLException e) {
			e.getMessage();
		} catch (IOException e) {
			e.getMessage();
		}catch (Exception e) {
			e.getMessage();
		}
		return city;
	}


	public static void main(String[] args) {
		
	}

}
			