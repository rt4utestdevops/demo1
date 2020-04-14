package t4u.util;

import java.io.BufferedReader;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.PrintWriter;
import java.net.HttpURLConnection;
import java.net.URL;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import org.json.JSONArray;
import org.json.JSONObject;

import t4u.common.ApplicationListener;
import t4u.functions.LogWriter;
import t4u.statements.CommonStatements;

public final class CommonUtility {

	public static final String GET_PROPERTY_VALUES = "SELECT ISNULL(PROPERTY,'') AS PROPERTY,ISNULL(VALUE,'') AS VALUE,ISNULL(MIN,'') AS MIN,ISNULL(MAX,'') AS MAX FROM  AMS.dbo.PROPERTY_SETTING WHERE PROPERTY = ? ";

	public static final String GET_ALL_PROPERTY_VALUES = "SELECT ISNULL(PROPERTY,'') AS PROPERTY,ISNULL(VALUE,'') AS VALUE,ISNULL(MIN,'') AS MIN,ISNULL(MAX,'') AS MAX FROM  AMS.dbo.PROPERTY_SETTING ";

	public static JSONObject getPropertyValues(Connection con, String property) throws Exception {
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		JSONObject obj = null;

		pstmt = con.prepareStatement(GET_PROPERTY_VALUES);
		pstmt.setString(1, property);
		rs = pstmt.executeQuery();
		if (rs.next()) {
			obj = new JSONObject();
			obj.put("VALUE", rs.getString("VALUE"));
			obj.put("MIN", rs.getString("MIN"));
			obj.put("MAX", rs.getString("MAX"));
		}
		return obj;
	}

	public static JSONArray getAllPropertyValues(Connection con) throws Exception {
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		JSONObject obj = null;
		JSONArray arr = new JSONArray();

		pstmt = con.prepareStatement(GET_ALL_PROPERTY_VALUES);

		rs = pstmt.executeQuery();
		while (rs.next()) {
			obj = new JSONObject();
			obj.put(rs.getString("PROPERTY"), rs.getString("PROPERTY"));
			obj.put("VALUE", rs.getString("VALUE"));
			obj.put("MIN", rs.getString("MIN"));
			obj.put("MAX", rs.getString("MAX"));
			arr.put(obj);
		}
		return arr;
	}

	public String setCurrentDateForReports(int offset) {
		java.util.Date currentdate = null;
		String currdate = "";
		currentdate = new java.util.Date();
		Date currentdate1 = new Date(new Date().getTime() + ((-330) * 60 * 1000));
		currentdate = new Date(currentdate1.getTime() + ((offset) * 60 * 1000));

		SimpleDateFormat formatter = new SimpleDateFormat("HH:mm");
		currdate = formatter.format(currentdate);
		return currdate;
	}

	public String setPreviousDateForReports(int offset) {
		java.util.Date startdate = null;
		String strdate = "";
		Date startdate1 = new Date(new Date().getTime() + ((-330) * 60 * 1000));
		startdate = new Date(startdate1.getTime() + ((offset) * 60 * 1000));
		startdate = new Date(System.currentTimeMillis() - 24 * 60 * 60 * 1000);
		SimpleDateFormat formatter = new SimpleDateFormat("dd/MM/yyyy");
		strdate = formatter.format(startdate);
		return strdate;
	}

	public String setCurrentDateForReports1(int offset) {
		java.util.Date currentdate = null;
		String currdate = "";
		currentdate = new java.util.Date();
		Date currentdate1 = new Date(new Date().getTime() + ((-330) * 60 * 1000));
		currentdate = new Date(currentdate1.getTime() + ((offset) * 60 * 1000));

		SimpleDateFormat formatter = new SimpleDateFormat("dd/MM/yyyy");
		currdate = formatter.format(currentdate);
		return currdate;
	}

	public static LogWriter getLog(LogWriter logWriter, String logFile, String logName) {
		Properties prop = ApplicationListener.prop;
		logFile = prop.getProperty(logFile).trim() + "//" + logName + ".txt";
		PrintWriter pw = null;
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		String logFileName = logFile.substring(0, logFile.lastIndexOf("."));
		String logFileExt = logFile.substring(logFile.lastIndexOf(".") + 1, logFile.length());
		logFile = logFileName + "-" + sdf.format(new Date()) + "." + logFileExt;
		if (logFile != null) {
			try {
				pw = new PrintWriter(new FileWriter(logFile, true), true);
				logWriter = new LogWriter(logName, LogWriter.INFO, pw);
				logWriter.setPrintWriter(pw);
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
		return logWriter;
	}

	public static ArrayList<String> getAPIConfigDetails(Connection con, String type) throws SQLException {
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		ArrayList<String> apiConfig = new ArrayList<String>();

		pstmt = con.prepareStatement(CommonStatements.GET_API_DETAILS);
		pstmt.setString(1, type);
		rs = pstmt.executeQuery();
		if (rs.next()) {
			apiConfig.add(rs.getString("URL"));
			apiConfig.add(rs.getString("AUTH"));
			apiConfig.add(rs.getString("METHOD"));
		}
		return apiConfig;
	}

	public JSONObject requestPayment(Connection con, int count, LogWriter logWriter, String APIType, JSONObject finalObject) throws Exception {
		ArrayList<String> apiDetails = null;
		Integer pushedStatus = 0;
		JSONObject responseJSON = null;
		try {
			apiDetails = getAPIConfigDetails(con, APIType);
			HttpURLConnection connection = null;
			java.lang.System.setProperty("https.protocols", "TLSv1,TLSv1.1,TLSv1.2");
			URL url = new URL(apiDetails.get(0));
			System.out.println("url :: " + apiDetails.get(0));
			connection = (HttpURLConnection) url.openConnection();
			connection.setReadTimeout(5000);
			connection.setRequestMethod(apiDetails.get(2));
			if (apiDetails.get(1) != null && apiDetails.get(1) != "") {
				connection.setRequestProperty("Authorization", apiDetails.get(1));
				connection.setRequestProperty("Accept", "application/json");
			}
			connection.setRequestProperty("Content-Type", "application/json");
			connection.setDoOutput(true);
			OutputStream os = connection.getOutputStream();
			os.write(finalObject.toString().getBytes());
			os.flush();
			int responseCode = connection.getResponseCode();
			InputStream inputStream;
			if (200 <= responseCode && responseCode <= 299) {
				inputStream = connection.getInputStream();
			} else {
				inputStream = connection.getErrorStream();
			}
			BufferedReader in = new BufferedReader(new InputStreamReader(inputStream));
			StringBuilder response = new StringBuilder();
			String currentLine;
			while ((currentLine = in.readLine()) != null)
				response.append(currentLine);
			in.close();
			System.out.println(response);
			pushedStatus = connection.getResponseCode();
			responseJSON = new JSONObject(response.toString());
			responseJSON.put("razor_pay_reponse_code", pushedStatus);

			if (pushedStatus == 200) {
				logWriter.log("Status : " + pushedStatus + ". Data Pushed for : " + 0, LogWriter.INFO);
			} else {
				if (count <= 0) {
					logWriter.log("Status : " + pushedStatus + ". Failed to push data for : " + 0, LogWriter.INFO);
				}
			}
			return responseJSON;
		} catch (Exception e) {
			e.printStackTrace();
			return responseJSON;
		}
	}

}
