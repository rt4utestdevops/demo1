package t4u.functions;


import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;
import java.io.Writer;
import java.net.HttpURLConnection;
import java.net.URL;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Properties;
import java.util.Set;

import org.json.JSONArray;
import org.json.JSONObject;



import t4u.common.ApplicationListener;
import t4u.common.DBConnection;


public class TripRouteEntryService {
	

	public void saveRouteDetails(Connection con,ArrayList<ArrayList<Double>> legsArray,
			Set<Integer> set, String routeName, String routeMode, String controllingLocation,String custRefId,boolean IsCustomerSpecific,String token,String url) {
		JSONArray detailsArray = new JSONArray();
		JSONObject finalJson = new JSONObject();
		JSONObject detailsObj = new JSONObject();
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		try{
			int c=0;
			HashMap<Integer, String> hmap = new HashMap<Integer, String>();
			final StringBuilder query = new StringBuilder();
			query.append(" select HUBID,NAME from AMS.dbo.LOCATION_ZONE_A where HUBID in ( ");
			for (int i = 0; i < set.size()-1; i++) {
				query.append(" ?, ");
			}
			query.append(" ? ) ");
			pstmt=con.prepareStatement(query.toString());
			Iterator<Integer> itr = set.iterator();
			while(itr.hasNext()){
				pstmt.setInt(++c, itr.next());
			}
			rs=pstmt.executeQuery();
			while(rs.next()){
				String[] city = rs.getString("NAME").split(",");
				hmap.put(rs.getInt("HUBID"), city[1]);
			}

			String src="";
			int trasitTime=0;
			int distance=0;

			for (ArrayList<Double> legArray : legsArray) {
				detailsObj = new JSONObject();
				detailsObj.put("CityName", hmap.get(legArray.get(0).intValue()).trim());
				detailsObj.put("Distance", String.valueOf(Math.round(distance)));
				detailsObj.put("TransitHours", String.valueOf(trasitTime/60));
				detailsObj.put("TransitMin", String.valueOf(trasitTime%60));
				detailsObj.put("DetentionHours",  String.valueOf(legArray.get(4).intValue()/60));
				detailsObj.put("DetentionMin",  String.valueOf(legArray.get(4).intValue()%60));
				detailsArray.put(detailsObj);
				src= hmap.get(legArray.get(1).intValue()).trim();
				trasitTime= (int) legArray.get(2).intValue();
				distance= (int) legArray.get(3).intValue();
				//System.out.println(j+"---- "+legArray);

			}
			detailsObj = new JSONObject();
			detailsObj.put("CityName", src);
			detailsObj.put("Distance", String.valueOf(Math.round(distance)));
			detailsObj.put("TransitHours",  String.valueOf(trasitTime/60));
			detailsObj.put("TransitMin",  String.valueOf(trasitTime%60));
			detailsObj.put("DetentionHours", "0");
			detailsObj.put("DetentionMin", "0");
			detailsArray.put(detailsObj);

			finalJson.put("RouteCode", routeName);
			finalJson.put("RouteMode", routeMode);
			finalJson.put("ControllingLocation", controllingLocation);
			finalJson.put("CustomerCode", custRefId);
			finalJson.put("IsCustomerSpecific", IsCustomerSpecific);
			finalJson.put("Details", detailsArray);
			//System.out.println(finalJson);
			WriteTologFile("-------------------API Call Starts---------------");
			WriteTologFile("<===========Input===========>\t"+finalJson.toString());;
			PushRouteDetails(finalJson,token,url);
		} catch (Exception e) {
			e.printStackTrace();
		}finally {
			DBConnection.releaseConnectionToDB(null, pstmt, null);
		}

	}




	public  void PushRouteDetails(JSONObject finalJson,String token,String urlLink){
		try {
			HttpURLConnection connection = null;
			try {
				System.out.println(urlLink);
				URL url = new URL(urlLink);
				connection = (HttpURLConnection) url.openConnection();
				connection.setRequestMethod("POST");
				connection.setRequestProperty("Token", token);
				connection.setRequestProperty("Content-Type","application/json");
				connection.setDoOutput(true);

				OutputStream os = connection.getOutputStream();
				Writer wout = new OutputStreamWriter(os);
				wout.write(finalJson.toString());
				wout.flush();
				wout.close();
				os.flush();
				//System.out.println("Response status ::::::::::: "+ connection.getResponseCode());

				String status = "" + connection.getResponseCode();
				InputStreamReader reader = new InputStreamReader(connection.getInputStream());
				StringBuilder buf = new StringBuilder();
				char[] cbuf = new char[2048];
				int num;
				while (-1 != (num = reader.read(cbuf))) {
					buf.append(cbuf, 0, num);
				}

				System.out.println(status);

				//System.out.println(connection);
				
				
				
				
				WriteTologFile("<===========OutPut===========>");
				WriteTologFile("Response ::  "+connection.getResponseMessage());
				WriteTologFile("message ::  "+buf.toString());
				if (status.equals("200") ) {
					WriteTologFile("succesfull call ");
					//System.out.println("succesfull call");
				} else{
					WriteTologFile("API failed to consumes the data ");
					//System.out.println("API failed to consumes the data ");
				}

			} catch (Exception e) {
				e.printStackTrace();
			} finally {
				connection.disconnect();
				WriteTologFile("-------------------API Call Ends---------------");
			}


		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	public  void WriteTologFile(String InfomrationMessage) {
		LogWriter logWriter = null;
		Properties properties = ApplicationListener.prop;
		String folder=properties.getProperty("TripRouteEntryServiceRoot");
		File rootFolder = new File(folder);
		if (!rootFolder.exists()) {
			if (rootFolder.mkdir()) {
			} 
		}
		String logFile = properties.getProperty("TripRouteEntryServiceFile");
		String logFileName = logFile.substring(0, logFile.lastIndexOf("."));
		String logFileExt = logFile.substring(logFile.lastIndexOf(".") + 1,
				logFile.length());
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		logFile = logFileName + "-" + sdf.format(new Date()) + "." + logFileExt;

		PrintWriter pw;
		if (logFile != null) {
			try {
				pw = new PrintWriter(new FileWriter(logFile, true), true);
				logWriter = new LogWriter("RouteApi", LogWriter.INFO, pw);
				logWriter.setPrintWriter(pw);
			} catch (IOException e) {
				logWriter.log("Cannot open log File -" + logFile,
						LogWriter.ERROR);
				//System.out.println(e);
			}
		}
		logWriter.log(InfomrationMessage, LogWriter.INFO);
	}





}
