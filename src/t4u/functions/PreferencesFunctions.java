package t4u.functions;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;

import org.json.JSONArray;
import org.json.JSONObject;

import t4u.beans.ReportHelper;
import t4u.common.DBConnection;
import t4u.statements.PreferencesStatements;

public class PreferencesFunctions {
	
	CommonFunctions cfuncs = new CommonFunctions();
	SimpleDateFormat sdfyyyymmddhhmmss = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
	SimpleDateFormat sdfFormatDate = new SimpleDateFormat("MM/dd/yyyy HH:mm:ss");
	SimpleDateFormat sdfddmmyy = new SimpleDateFormat("dd-MM-yyyy");
	CommonFunctions cf = new CommonFunctions();

	public ArrayList < Object > getPreferenceReport(int systemId, int customerId, int userId, String language, String startDate, String endDate, int offset, String zone) {

	    JSONArray JsonArray = new JSONArray();
	    JSONObject JsonObject = null;

	    Connection con = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
	    ArrayList < ReportHelper > reportsList = new ArrayList < ReportHelper > ();
	    ArrayList < String > headersList = new ArrayList < String > ();
	    ReportHelper finalreporthelper = new ReportHelper();
	    ArrayList < Object > finlist = new ArrayList < Object > ();
	    try {
	        int count = 0;
	        con = DBConnection.getConnectionToDB("AMS");
	        pstmt = con.prepareStatement(PreferencesStatements.GET_PREFERENCE_REPORT);
	        pstmt.setInt(1, offset);
	        pstmt.setInt(2, customerId);
	        pstmt.setInt(3, systemId);
	        pstmt.setInt(4, offset);
	        pstmt.setString(5, startDate);
	        pstmt.setInt(6, offset);
	        pstmt.setString(7, endDate);
	        rs = pstmt.executeQuery();

	        while (rs.next()) {
	            JsonObject = new JSONObject();
	            ArrayList < Object > informationList = new ArrayList < Object > ();
	            ReportHelper reporthelper = new ReportHelper();
	            count++;

	            informationList.add(count);
	            JsonObject.put("slnoIndex", count);

	            if (rs.getString("DATE") == null || rs.getString("DATE").equals("") || rs.getString("DATE").contains("1900")) {
	                JsonObject.put("dateDataIndex", "");
	                informationList.add("");
	            } else {
	                JsonObject.put("dateDataIndex", sdfddmmyy.format(rs.getTimestamp("DATE")));
	                informationList.add(sdfddmmyy.format(rs.getTimestamp("DATE")));
	            }

	            JsonObject.put("reasonsDataIndex", rs.getString("REASON"));
	            informationList.add(rs.getString("REASON"));

	            JsonObject.put("idDataIndex", rs.getInt("ID"));
	            informationList.add(rs.getInt("ID"));

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


	public String insertPreferencesInformation(int custId, int systemId, String date, String reasons, int userId,int offset) {
	    Connection con = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
	    String message = "";

	    try {
	        con = DBConnection.getConnectionToDB("AMS");
	        pstmt = con.prepareStatement(PreferencesStatements.INSERT_PREFERENCE_DETAILS);
	        pstmt.setInt(1, offset);
	        pstmt.setString(2, date);
	        pstmt.setString(3, reasons);
	        pstmt.setInt(4, custId);
	        pstmt.setInt(5, systemId);
	        pstmt.setInt(6, userId);
	        int inserted = pstmt.executeUpdate();
	        if (inserted > 0) {
	            message = "Saved Successfully";
	        }

	    } catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	        DBConnection.releaseConnectionToDB(con, pstmt, rs);
	    }
	    return message;
	}


	public String modifyPreferencesInformation(int id, int custId, int systemId, String date, String reasons, int userId,int offset) {
	    Connection con = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
	    String message = "";
	    try {
	        con = DBConnection.getConnectionToDB("AMS");
	        pstmt = con.prepareStatement(PreferencesStatements.UPDATE_PREFERENCES_DETAILS);
	        pstmt.setInt(1, offset);
	        pstmt.setString(2, date);
	        pstmt.setString(3, reasons);
	        pstmt.setInt(4, userId);
	        pstmt.setInt(5, custId);
	        pstmt.setInt(6, systemId);
	        pstmt.setInt(7, id);

	        int updated = pstmt.executeUpdate();
	        if (updated > 0) {
	            message = "Updated Successfully";
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	        DBConnection.releaseConnectionToDB(con, pstmt, rs);
	    }
	    return message;
	}
	}