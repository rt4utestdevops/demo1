package t4u.functions;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;

import org.json.JSONArray;
import org.json.JSONObject;

import t4u.beans.ReportHelper;
import t4u.common.DBConnection;
import t4u.statements.OilAndGasStatements;

public class OilAndGasFunctions {
	
	CommonFunctions cfuncs = new CommonFunctions();
	SimpleDateFormat sdfyyyymmddhhmmss=new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
	SimpleDateFormat sdfFormatDate = new SimpleDateFormat("MM/dd/yyyy HH:mm:ss");
	CommonFunctions cf = new CommonFunctions();
	
	
	public JSONArray getAssetNumber(int systemid,int clientid,int userId,String types) {

		JSONArray jsonArray = new JSONArray();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String VehicleNo = "";
		int alertType = 0;
			try {
			      if (!types.equals(null)) {
						alertType = Integer.parseInt(types);
					}
			con = DBConnection.getConnectionToDB("AMS");
			if (alertType!=0) {
				pstmt = con.prepareStatement(OilAndGasStatements.GET_VEHICLE_WHICH_HAS_ALERT_TYPE);
				pstmt.setInt(1, systemid);
				pstmt.setInt(2, clientid);
				pstmt.setString(3, types);
			} else {
				pstmt = con.prepareStatement(OilAndGasStatements.GET_ALL_VEHICLE);
				pstmt.setInt(1, systemid);
				pstmt.setInt(2, clientid);
			}

			rs = pstmt.executeQuery();
			JSONObject obj1 = new JSONObject();
			while (rs.next()) {
				obj1 = new JSONObject();

				VehicleNo = rs.getString("ASSET_NUMBER");
				obj1.put("assetnumber", VehicleNo);
				jsonArray.put(obj1);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		// System.out.println("jsonArray ---"+jsonArray);
		return jsonArray;
	}

		
	public ArrayList < Object > getOilAndGasReport(int systemId, int customerId,int userId,String language,String startDate,String endDate,String assetNumber,String type,int offset,String zone) {

	    JSONArray JsonArray = new JSONArray();
	    JSONObject JsonObject = null;

	    Connection con = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
	    DecimalFormat decformat = new DecimalFormat("#0.00");
	    ArrayList < ReportHelper > reportsList = new ArrayList < ReportHelper > ();
	    ArrayList < String > headersList = new ArrayList < String > ();
	    ReportHelper finalreporthelper = new ReportHelper();
	    ArrayList < Object > finlist = new ArrayList < Object > ();
	    String alertType = "";
	    int alertTypes = 0;
		try {
		      if (!type.equals(null)) {
					alertTypes = Integer.parseInt(type);
				}
 
	        headersList.add(cf.getLabelFromDB("SLNO", language));
	        headersList.add(cf.getLabelFromDB("Asset_Number", language));
	        headersList.add(cf.getLabelFromDB("Type", language));
	        headersList.add(cf.getLabelFromDB("Time_Of_Opening", language));
	        headersList.add(cf.getLabelFromDB("Time_Of_Closing", language));
	        headersList.add(cf.getLabelFromDB("Start_Location", language));
	        headersList.add(cf.getLabelFromDB("Duration", language));
	        headersList.add(cf.getLabelFromDB("Distance_Travelled", language));
	        
	        con = DBConnection.getConnectionToDB("AMS"); 
	        int count = 0;
	        if (alertTypes!=0) {
		        pstmt = con.prepareStatement(OilAndGasStatements.GET_OIL_AND_GAS_REPORT);
		        pstmt.setInt(1, offset);
		        pstmt.setInt(2, offset);
		        pstmt.setInt(3, systemId);
		    	pstmt.setInt(4, customerId);
		    	pstmt.setInt(5, offset);
		    	pstmt.setString(6, startDate);
		    	pstmt.setInt(7, offset);
		    	pstmt.setString(8, endDate);
		        pstmt.setString(9, assetNumber);
		        pstmt.setString(10, type);
	        }else
	        {
	        	pstmt = con.prepareStatement(OilAndGasStatements.GET_OIL_AND_GAS_REPORT_FOR_BOTH);
		        pstmt.setInt(1, offset);
		        pstmt.setInt(2, offset);
		        pstmt.setInt(3, systemId);
		    	pstmt.setInt(4, customerId);
		    	pstmt.setInt(5, offset);
		    	pstmt.setString(6, startDate);
		    	pstmt.setInt(7, offset);
		    	pstmt.setString(8, endDate);
		        pstmt.setString(9, assetNumber);
		      }
	        
	        rs = pstmt.executeQuery();
	        while (rs.next()) {
	            JsonObject = new JSONObject();
	            ArrayList < Object > informationList = new ArrayList < Object > ();
	            ReportHelper reporthelper = new ReportHelper();
	            count++;
	           
	            float duration= rs.getFloat("DURATION");
	            float distanceTravelled=rs.getFloat("DISTANCE_TRAVELLED");
	            Date timeOfOpening = rs.getTimestamp("TIME_OF_OPENING");
	            Date timeOfClosing = rs.getTimestamp("TIME_OF_CLOSING");
	            
	            informationList.add(count);
	            JsonObject.put("slnoIndex1", count);

	            JsonObject.put("assetNumberDataIndex", rs.getString("ASSET_NUMBER"));
	            informationList.add(rs.getString("ASSET_NUMBER"));
	            
	            if(rs.getInt("TYPE") == 72)
	            {
	            	alertType = "Lid";
	            }
	            else if(rs.getInt("TYPE") == 73)
	            {
	            	alertType = "Valves";
	            } 
	            else {
	            	alertType = "";
	            }
	            
	            JsonObject.put("typeDataIndex", alertType);
	            informationList.add(alertType);
	            
	            JsonObject.put("timeOfOpeningDataIndex",  sdfyyyymmddhhmmss.format(timeOfOpening));
				informationList.add(sdfyyyymmddhhmmss.format(timeOfOpening));
	            
				
				
				if (rs.getString("TIME_OF_CLOSING") == null || rs.getString("TIME_OF_CLOSING").equals("") || rs.getString("TIME_OF_CLOSING").contains("1900")) {
					JsonObject.put("timeOfClosingDataIndex", "");
					informationList.add("");
				} else {
					JsonObject.put("timeOfClosingDataIndex", sdfyyyymmddhhmmss.format(rs.getTimestamp("TIME_OF_CLOSING")));
					informationList.add(sdfyyyymmddhhmmss.format(rs.getTimestamp("TIME_OF_CLOSING")));
				}
				
		         
	            JsonObject.put("locationDataIndex", rs.getString("LOCATION"));
	            informationList.add(rs.getString("LOCATION"));
	            
	            JsonObject.put("durationDataIndex", decformat.format(duration));
	            informationList.add(decformat.format(duration));
	            
	            JsonObject.put("distanceTravelledDataIndex", decformat.format(distanceTravelled));
	            informationList.add(decformat.format(distanceTravelled));
	            
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
}

	
	
	
	
