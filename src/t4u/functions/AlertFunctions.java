package t4u.functions;

import java.net.InetAddress;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.HashMap;
import java.util.StringTokenizer;

import org.json.JSONArray;
import org.json.JSONObject;

import t4u.common.DBConnection;
import t4u.statements.AlertStatements;

public class AlertFunctions {

	SimpleDateFormat ddmmyyyy = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
	SimpleDateFormat yyyymmdd = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	CashVanManagementFunctions cvsfn=new CashVanManagementFunctions();
	DecimalFormat df = new DecimalFormat();
	CommonFunctions cf=new CommonFunctions();
	public HashMap<Object, Object> getAlertComponents(int systemId,int customerId,int userId,int offset,String language) {
		Connection connection = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String alertReportPath="";
		StringBuilder sbalertComponentsCode = new StringBuilder();
		HashMap<Object, Object> alertComponents = new HashMap<Object, Object>();
		int noOfComponentsOnEachDiv = 0;
		String listOfAlertComponentCode = "";
		StringBuilder alertIDString=new StringBuilder();
		int dashboardBox=0;
		try {
			connection = DBConnection.getConnectionToDB("AMS");
			pstmt = connection.prepareStatement(AlertStatements.GET_ALERT_COMPONENTS);	
			pstmt.setInt(1, systemId);
			rs = pstmt.executeQuery();
			while(rs.next()){
				String alertName=cf.getLabelFromDB(rs.getString("AlertName").replace(" ", "_"), language);
				dashboardBox++;
				alertIDString.append(rs.getString("AlertName")+",");
				noOfComponentsOnEachDiv++;	
				if(noOfComponentsOnEachDiv == 1){
					sbalertComponentsCode.append("<div class='alertsElements'>");
				}	
				alertReportPath="gotoAlertReport('"+rs.getInt("AlertId")+"','"+rs.getString("AlertName")+"');";
				alertReportPath='"' + alertReportPath + '"';
							
				sbalertComponentsCode.append("<li href='#' class='alertbox"+dashboardBox+"' id='alertTypeId"+rs.getInt("AlertId")+"'> "+
				"<div class='alertboxicon"+dashboardBox+"' style='background-image: url(/ApplicationImages/AlertIcons/"+rs.getString("AlertName").replaceAll("\\W", "")+".png) !important;'></div>"+
				"<div class='alertdetailsbox'> "+
				"<div class='linesep'> </div> "+
				"<span class='alertcount'  id=alertId"+rs.getInt("AlertId")+">0</span> "+
				"<span class='alertnamedetails'>"+alertName.toUpperCase()+" </span> "+
				"<span class='alertdetails"+dashboardBox+"' onclick="+alertReportPath+" style='border-top: 9px solid rgba(173, 72, 72, 0) !important;'></span></div></li>");
				if(dashboardBox==12)
				{
					dashboardBox=0;	
				}
				if(noOfComponentsOnEachDiv == 4){
					sbalertComponentsCode.append("</div>");
					noOfComponentsOnEachDiv = 0;
				}
			}
			listOfAlertComponentCode = sbalertComponentsCode.toString();
			listOfAlertComponentCode = listOfAlertComponentCode.replace("@$", "\"").toString();
			alertComponents.put(alertIDString, listOfAlertComponentCode.toString());
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				DBConnection.releaseConnectionToDB(connection, pstmt, rs);
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		return alertComponents;
	}
	

	public JSONArray getAlertCountList(String alertList,int systemId,int customerId, int userId, int offset) {
		Connection conAdmin = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		JSONObject alertcountObject=null;
		JSONArray alertcountArray=new JSONArray();
		try {
			final long startTime = System.currentTimeMillis();
			conAdmin = DBConnection.getConnectionToDB("AMS");
			/**
			 * OverSpeed
			 ***/
			if(alertList.contains("OverSpeed"))
			{
				pstmt = conAdmin.prepareStatement(AlertStatements.GET_OVER_SPEED_ALERT_COUNT);
				pstmt.setInt(1, offset);
				pstmt.setInt(2, customerId);
				pstmt.setInt(3, systemId);
				pstmt.setInt(4, userId);
				rs = pstmt.executeQuery();
				if (rs.next()) {
					alertcountObject=new JSONObject();
					alertcountObject.put("alertId",2);
					alertcountObject.put("alertCount",rs.getInt("COUNT"));
					alertcountArray.put(alertcountObject);
				}
				rs.close();
				pstmt.close();
			}
			if(alertList.contains("Detention Alert"))
			{
				pstmt = conAdmin.prepareStatement(AlertStatements.GET_DETENTION_ALERT_COUNT);
				pstmt.setInt(1, userId);
				pstmt.setInt(2, customerId);
				pstmt.setInt(3, systemId);
				rs = pstmt.executeQuery();
				if (rs.next()) {
					alertcountObject=new JSONObject();
					alertcountObject.put("alertId",119);
					alertcountObject.put("alertCount",rs.getInt("COUNT"));
					alertcountArray.put(alertcountObject);
				}
				rs.close();
				pstmt.close();
			}
			if(alertList.contains("Hub Arrival")||alertList.contains("Hub Departure"))
			{
				pstmt = conAdmin.prepareStatement(AlertStatements.GET_HUB_ARRIVAL_COUNT);				
				pstmt.setInt(1, systemId);
				pstmt.setInt(2, customerId);
				pstmt.setInt(3, offset);
				pstmt.setInt(4, userId);
				rs = pstmt.executeQuery();
				while (rs.next()) {
					alertcountObject=new JSONObject();
					alertcountObject.put("alertId",rs.getInt("TYPE_OF_ALERT"));
					alertcountObject.put("alertCount",rs.getInt("COUNT"));
					alertcountArray.put(alertcountObject);
				}
				rs.close();
				pstmt.close();
			}
			if(alertList.contains("Distress"))
			{
				pstmt = conAdmin.prepareStatement(AlertStatements.GET_DISTRESS_COUNT_ALERT);
				pstmt.setInt(1, offset);
				pstmt.setInt(2, customerId);
				pstmt.setInt(3, systemId);
				pstmt.setInt(4, userId);
				pstmt.setInt(5, 3);
				rs = pstmt.executeQuery();
				if (rs.next()) {
					alertcountObject=new JSONObject();
					alertcountObject.put("alertId",3);
					alertcountObject.put("alertCount",rs.getInt("COUNT"));
					alertcountArray.put(alertcountObject);
				}
				rs.close();
				pstmt.close();
			}
			
			if(alertList.contains("Harsh Acceleration"))
			{
				pstmt = conAdmin.prepareStatement(AlertStatements.GET_HARSH_ACC_COUNT);
				pstmt.setInt(1, userId);
				pstmt.setInt(2, systemId);
				pstmt.setInt(3, customerId);
				pstmt.setInt(4, offset);
				rs = pstmt.executeQuery();
				if (rs.next()) {
					alertcountObject=new JSONObject();
					alertcountObject.put("alertId",105);
					alertcountObject.put("alertCount",rs.getInt("COUNT"));
					alertcountArray.put(alertcountObject);
				}
				rs.close();
				pstmt.close();
			}
			
			if(alertList.contains("Harsh Braking"))
			{
				pstmt = conAdmin.prepareStatement(AlertStatements.GET_HARSH_BRK_COUNT);
				pstmt.setInt(1, userId);
				pstmt.setInt(2, systemId);
				pstmt.setInt(3, customerId);
				pstmt.setInt(4, offset);
				rs = pstmt.executeQuery();
				if (rs.next()) {
					alertcountObject=new JSONObject();
					alertcountObject.put("alertId",58);
					alertcountObject.put("alertCount",rs.getInt("COUNT"));
					alertcountArray.put(alertcountObject);
				}
				rs.close();
				pstmt.close();
			}
			
			if(alertList.contains("Short Distress"))
			{
				pstmt = conAdmin.prepareStatement(AlertStatements.GET_DISTRESS_COUNT_ALERT);
				pstmt.setInt(1, offset);
				pstmt.setInt(2, customerId);
				pstmt.setInt(3, systemId);
				pstmt.setInt(4, userId);
				pstmt.setInt(5, 182);
				rs = pstmt.executeQuery();
				if (rs.next()) {
					alertcountObject=new JSONObject();
					alertcountObject.put("alertId",182);
					alertcountObject.put("alertCount",rs.getInt("COUNT"));
					alertcountArray.put(alertcountObject);
				}
				rs.close();
				pstmt.close();
			}
			
				pstmt = conAdmin.prepareStatement(AlertStatements.GET_ALERT_COUNT);
				pstmt.setInt(1, userId);
				pstmt.setInt(2, systemId);
				pstmt.setInt(3, customerId);
				pstmt.setInt(4, offset);
				rs = pstmt.executeQuery();
				while (rs.next()) {
					alertcountObject=new JSONObject();
					alertcountObject.put("alertId",rs.getInt("TYPE_OF_ALERT"));
					alertcountObject.put("alertCount",rs.getInt("COUNT"));
					alertcountArray.put(alertcountObject);
				}
			final long endTime = System.currentTimeMillis();
			
			System.out.println("-Total execution time: " + (endTime - startTime)/1000 );
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(conAdmin, pstmt, rs);
		}
		return alertcountArray;
	}

	public JSONArray getAlertDetails(int offset, String alertID, int systemId,int customerId, int userId) {
		Connection con = null;
		PreparedStatement pstmt = null;
		PreparedStatement pstmt1 = null;
		ResultSet rs = null;
		ResultSet rs1 = null;
		String eWayBillNo="";
		String vehicleNo = "";
		String alertDetails = "";
		DecimalFormat df1 = new DecimalFormat("#.##");			
		   String unitname =cf.getUnitOfMeasure(systemId);
		   Double conversion = cf.getUnitOfMeasureConvertionsfactor(systemId);
				
		int alertId;
		CommonFunctions commonFunctions = new CommonFunctions();
		JSONArray alertdetailsJSONArray = new JSONArray();
		JSONObject alertdetailsJSONObject = null;
		try {
			con = DBConnection.getConnectionToDB("AMS");
			alertId = Integer.parseInt(alertID);
			/**
			 * OverSpeed
			 ***/
			if (alertId == 2) {
				pstmt = con.prepareStatement(AlertStatements.GET_OVER_SPEED_ALERT);
				pstmt.setInt(1, offset);
				pstmt.setInt(2, offset);
				pstmt.setInt(3, customerId);
				pstmt.setInt(4, systemId);
				pstmt.setInt(5, userId);
				rs = pstmt.executeQuery();
				while (rs.next()) {
					alertdetailsJSONObject = new JSONObject();
					vehicleNo = rs.getString("REGISTRATION_NO");
					alertDetails = vehicleNo + " overspeeded " + rs.getString("LOCATION") + " On " + ddmmyyyy.format(yyyymmdd.parse(rs.getString("GPS_DATETIME"))) + " with Speed "+df1.format(Double.parseDouble(rs.getString("SPEED"))*conversion) +" "+unitname+"/h" ;
					alertdetailsJSONObject.put("alertdetails", alertDetails);
					alertdetailsJSONObject.put("alertslno",rs.getString("SLNO"));
					alertdetailsJSONObject.put("vehicleNo",vehicleNo);
					alertdetailsJSONObject.put("gmt",rs.getString("GMT"));
					alertdetailsJSONArray.put(alertdetailsJSONObject);
					if(systemId==229)
					{
					pstmt1=con.prepareStatement(AlertStatements.CHECK_VEHICLE_NO_IN_TRIP_SHEET);
					pstmt1.setString(1, vehicleNo);
					pstmt1.setInt(2,systemId);
					pstmt1.setInt(3,customerId);
					pstmt1.setInt(4,offset);
					rs1=pstmt1.executeQuery();
					if(rs1.next())
					{
						eWayBillNo=rs1.getString("Trip_Sheet_No");	
						alertDetails = vehicleNo + " with eWayBillNo : "+eWayBillNo+" overspeeded " + rs.getString("LOCATION") + " On " + ddmmyyyy.format(yyyymmdd.parse(rs.getString("GPS_DATETIME")));
						
					}
					else eWayBillNo="";
					}
				}
			}
			else if (alertId == 119) {
				pstmt = con.prepareStatement(AlertStatements.GET_DETENTION_ALERT_DETAILS);
				pstmt.setInt(1,offset);
				pstmt.setInt(2, systemId);
				pstmt.setInt(3, customerId);
				pstmt.setInt(4, alertId);
				pstmt.setInt(5, userId);
				pstmt.setInt(6,offset);
				pstmt.setInt(7, systemId);
				pstmt.setInt(8, customerId);
				pstmt.setInt(9, alertId);
				pstmt.setInt(10, userId);
				rs = pstmt.executeQuery();
				while (rs.next()) {
					alertdetailsJSONObject = new JSONObject();
					vehicleNo = rs.getString("REGISTRATION_NO");
					alertDetails = vehicleNo + " " + rs.getString("LOCATION") + " for more than 24 hours On " + ddmmyyyy.format(yyyymmdd.parse(rs.getString("GMT")));
					alertdetailsJSONObject.put("alertdetails", alertDetails);
					alertdetailsJSONObject.put("alertslno",rs.getString("SLNO"));
					alertdetailsJSONObject.put("vehicleNo",vehicleNo);
					alertdetailsJSONObject.put("gmt",rs.getString("GMT"));
					alertdetailsJSONArray.put(alertdetailsJSONObject);
					if(systemId==229)
					{
					pstmt1=con.prepareStatement(AlertStatements.CHECK_VEHICLE_NO_IN_TRIP_SHEET);
					pstmt1.setString(1, vehicleNo);
					pstmt1.setInt(2,systemId);
					pstmt1.setInt(3,customerId);
					pstmt1.setInt(4,offset);
					rs1=pstmt1.executeQuery();
					if(rs1.next())
					{
						eWayBillNo=rs1.getString("Trip_Sheet_No");	
						alertDetails = vehicleNo + " with eWayBillNo : "+eWayBillNo+" " + rs.getString("LOCATION") + " for more than 24 hours On " + ddmmyyyy.format(yyyymmdd.parse(rs.getString("GMT")));
					}
					else eWayBillNo="";
					}
				}
			}
			else if (alertId == 3||alertId == 182) {
				pstmt = con.prepareStatement(AlertStatements.GET_DISTRESS_ALERT_DETAILS);
				pstmt.setInt(1,offset);
				pstmt.setInt(2, systemId);
				pstmt.setInt(3, customerId);
				pstmt.setInt(4, alertId);
				pstmt.setInt(5,offset);
				pstmt.setInt(6, userId);
				pstmt.setInt(7,offset);
				pstmt.setInt(8, systemId);
				pstmt.setInt(9, customerId);
				pstmt.setInt(10, alertId);
				pstmt.setInt(11,offset);
				pstmt.setInt(12, userId);
				rs = pstmt.executeQuery();
				while (rs.next()) {
					alertdetailsJSONObject = new JSONObject();
					vehicleNo = rs.getString("REGISTRATION_NO");
					alertDetails = vehicleNo + " " + rs.getString("LOCATION") + " Under Distress On " + ddmmyyyy.format(yyyymmdd.parse(rs.getString("GMT")));
					alertdetailsJSONObject.put("alertdetails", alertDetails);
					alertdetailsJSONObject.put("alertslno",rs.getString("SLNO"));
					alertdetailsJSONObject.put("vehicleNo",vehicleNo);
					alertdetailsJSONObject.put("gmt",rs.getString("GMT"));
					alertdetailsJSONArray.put(alertdetailsJSONObject);
					if(systemId==229)
					{
					pstmt1=con.prepareStatement(AlertStatements.CHECK_VEHICLE_NO_IN_TRIP_SHEET);
					pstmt1.setString(1, vehicleNo);
					pstmt1.setInt(2,systemId);
					pstmt1.setInt(3,customerId);
					pstmt1.setInt(4,offset);
					rs1=pstmt1.executeQuery();
					if(rs1.next())
					{
						eWayBillNo=rs1.getString("Trip_Sheet_No");	
						alertDetails = vehicleNo + " with eWayBillNo : "+eWayBillNo+" " + rs.getString("LOCATION") + " Under Distress On " + ddmmyyyy.format(yyyymmdd.parse(rs.getString("GMT")));
						
					}
					else eWayBillNo="";
					}
				}
			}
			else if(alertId == 17 || alertId == 18 ) {			
				pstmt = con.prepareStatement(AlertStatements.GET_HUB_ARRIVAL_DETAILS);
				pstmt.setInt(1, systemId);
				pstmt.setInt(2, customerId);
				pstmt.setInt(3, offset);
				pstmt.setInt(4, userId);
				pstmt.setInt(5, alertId);				
				rs = pstmt.executeQuery();
				while(rs.next()){
					alertdetailsJSONObject = new JSONObject();
					vehicleNo = rs.getString("REGISTRATION_NO");
					alertDetails = vehicleNo + " " + rs.getString("LOCATION") +" on "+ ddmmyyyy.format(yyyymmdd.parse(rs.getString("GPS_DATETIME")));
					if(systemId==229)
					{
					pstmt1=con.prepareStatement(AlertStatements.CHECK_VEHICLE_NO_IN_TRIP_SHEET);
					pstmt1.setString(1, vehicleNo);
					pstmt1.setInt(2,systemId);
					pstmt1.setInt(3,customerId);
					pstmt1.setInt(4,offset);
					rs1=pstmt1.executeQuery();
					if(rs1.next())
					{
						eWayBillNo=rs1.getString("Trip_Sheet_No");	
						alertDetails = vehicleNo + " with eWayBillNo : "+eWayBillNo+" " + rs.getString("LOCATION") +" on "+ ddmmyyyy.format(yyyymmdd.parse(rs.getString("GPS_DATETIME")));
					}
					   else {
					eWayBillNo="";
					
					   }
					   }
					
					alertdetailsJSONObject.put("alertdetails", alertDetails);
					alertdetailsJSONObject.put("alertslno",rs.getString("SLNO"));
					alertdetailsJSONObject.put("vehicleNo",vehicleNo);
					alertdetailsJSONObject.put("gmt",rs.getString("GMT"));
					alertdetailsJSONArray.put(alertdetailsJSONObject);
					
				}
				
			}else if(alertId == 58 || alertId == 105){			
				
				pstmt = con.prepareStatement(AlertStatements.GET_HA_HB_DETAILS);
				pstmt.setInt(1,offset);
				pstmt.setInt(2, systemId);
				pstmt.setInt(3, customerId);
				pstmt.setInt(4, alertId);
				pstmt.setInt(5,offset);
				pstmt.setInt(6, userId);			
				rs = pstmt.executeQuery();
				while (rs.next()) {
					alertdetailsJSONObject = new JSONObject();
					vehicleNo = rs.getString("REGISTRATION_NO");
					alertDetails = vehicleNo + " " + rs.getString("LOCATION") +" on "+ ddmmyyyy.format(yyyymmdd.parse(rs.getString("GMT")));
					alertdetailsJSONObject.put("alertdetails", alertDetails);
					alertdetailsJSONObject.put("alertslno",rs.getString("SLNO"));
					alertdetailsJSONObject.put("vehicleNo",vehicleNo);
					alertdetailsJSONObject.put("gmt",rs.getString("GMT"));
					alertdetailsJSONArray.put(alertdetailsJSONObject);
				}			
				
			}			
			
			else
			{
				pstmt = con.prepareStatement(AlertStatements.GET_ALERT_DETAILS);
				pstmt.setInt(1, systemId);
				pstmt.setInt(2, customerId);
				pstmt.setInt(3, alertId);
				pstmt.setInt(4, offset);
				pstmt.setInt(5, userId);
				/*pstmt.setInt(6, systemId);
				pstmt.setInt(7, customerId);
				pstmt.setInt(8, alertId);
				pstmt.setInt(9, offset);
				pstmt.setInt(10, userId);*/
				rs = pstmt.executeQuery();
				while (rs.next()) {
					alertdetailsJSONObject = new JSONObject();
					vehicleNo = rs.getString("REGISTRATION_NO");
					if(systemId==229)
					{
					pstmt1=con.prepareStatement(AlertStatements.CHECK_VEHICLE_NO_IN_TRIP_SHEET);
					pstmt1.setString(1, vehicleNo);
					pstmt1.setInt(2,systemId);
					pstmt1.setInt(3,customerId);
					pstmt1.setInt(4,offset);
					rs1=pstmt1.executeQuery();
					if(rs1.next())
					{
						eWayBillNo=rs1.getString("Trip_Sheet_No");	
					}
					else eWayBillNo="";
					}
					switch(alertId){
						//Stoppage
						case 1 :if(systemId==229 && eWayBillNo!="")
						{
							alertDetails = vehicleNo + " with eWayBillNo : "+eWayBillNo+" stopped " + rs.getString("LOCATION") + " On " + ddmmyyyy.format(yyyymmdd.parse(rs.getString("GPS_DATETIME"))) + " stopped for " + commonFunctions.getDayHrMinFormat(rs.getDouble("STOP_HOURS")) + "(dd:hh:mm)";
						}
						else	alertDetails = vehicleNo + " stopped " + rs.getString("LOCATION") + " On " + ddmmyyyy.format(yyyymmdd.parse(rs.getString("GPS_DATETIME"))) + " stopped for " + commonFunctions.getDayHrMinFormat(rs.getDouble("STOP_HOURS")) + "(dd:hh:mm)";
						break;
						
						//Route Deviation
						case 5 : alertDetails = vehicleNo + " deviated the route " + rs.getString("LOCATION") + " On " + ddmmyyyy.format(yyyymmdd.parse(rs.getString("GPS_DATETIME")));
						break;
						
						//Main Power OnOff
						case 7 :
							if(systemId==229 && !eWayBillNo.equals(""))
							{
								if(rs.getInt("HUB_ID") == 0){
									alertDetails = vehicleNo  + " with eWayBillNo : "+eWayBillNo+" main power is Off " + rs.getString("LOCATION") + " On " + ddmmyyyy.format(yyyymmdd.parse(rs.getString("GPS_DATETIME")));
								} else if(rs.getInt("HUB_ID") == 1){
									alertDetails = vehicleNo + " with eWayBillNo : "+eWayBillNo+" main power is On " + rs.getString("LOCATION") + " On " + ddmmyyyy.format(yyyymmdd.parse(rs.getString("GPS_DATETIME")));
								} else if(rs.getInt("HUB_ID") == 2){
									alertDetails = vehicleNo + " with eWayBillNo : "+eWayBillNo+" main power input for the device has been tampered " + rs.getString("LOCATION") + " On " + ddmmyyyy.format(yyyymmdd.parse(rs.getString("GPS_DATETIME")));
								}	
							}
							else
							{
								if(rs.getInt("HUB_ID") == 0){
									alertDetails = vehicleNo + " main power is Off " + rs.getString("LOCATION") + " On " + ddmmyyyy.format(yyyymmdd.parse(rs.getString("GPS_DATETIME")));
								} else if(rs.getInt("HUB_ID") == 1){
									alertDetails = vehicleNo + " main power is On " + rs.getString("LOCATION") + " On " + ddmmyyyy.format(yyyymmdd.parse(rs.getString("GPS_DATETIME")));
								} else if(rs.getInt("HUB_ID") == 2){
									alertDetails = vehicleNo + " main power input for the device has been tampered " + rs.getString("LOCATION") + " On " + ddmmyyyy.format(yyyymmdd.parse(rs.getString("GPS_DATETIME")));
								}
							}
						break;
						
						case 38 : int alertType = rs.getInt("HUB_ID");
								  String alertStatus = "OPEN";
								  if(alertType == 1){
									  alertStatus = "CLOSE";
								  }
						
							      alertDetails = "Asset " + vehicleNo + ", Door was " + alertStatus + " " + rs.getString("LOCATION") + " On " + ddmmyyyy.format(yyyymmdd.parse(rs.getString("GPS_DATETIME")));
						break;
						
						case 39 : alertDetails = vehicleNo + " idle " + rs.getString("LOCATION") + " On " + ddmmyyyy.format(yyyymmdd.parse(rs.getString("GPS_DATETIME"))) + " Stopped for " + commonFunctions.getDayHrMinFormat(rs.getDouble("STOP_HOURS")) + "(dd:hh:mm)";
						break;
						
						case 46 : alertDetails = vehicleNo + " gps signal " + rs.getString("LOCATION") + " On " + ddmmyyyy.format(yyyymmdd.parse(rs.getString("GPS_DATETIME")));
						break;
						
						case 56 : alertDetails = vehicleNo + "  " + rs.getString("LOCATION") + " On " + ddmmyyyy.format(yyyymmdd.parse(rs.getString("GPS_DATETIME")));
						break;
						
						case 82 : alertDetails = vehicleNo + " inside border " + rs.getString("LOCATION") + " On " + ddmmyyyy.format(yyyymmdd.parse(rs.getString("GPS_DATETIME")));
						break;
						
						case 83 :alertDetails = vehicleNo + " near to border " + rs.getString("LOCATION") + " On " + ddmmyyyy.format(yyyymmdd.parse(rs.getString("GPS_DATETIME")));
						break;
						
						case 84 :
							if(systemId==229 && eWayBillNo!="")
						{
							alertDetails = vehicleNo + " with eWayBillNo : "+eWayBillNo+" crossed border " + rs.getString("LOCATION") + " On " + ddmmyyyy.format(yyyymmdd.parse(rs.getString("GPS_DATETIME")));
						}
						else	
							alertDetails = vehicleNo + " crossed border " + rs.getString("LOCATION") + " On " + ddmmyyyy.format(yyyymmdd.parse(rs.getString("GPS_DATETIME")));
						break;
						
						case 85 : alertDetails = vehicleNo + " is not communicating since " + ddmmyyyy.format(yyyymmdd.parse(rs.getString("GPS_DATETIME"))) + " and last communicated " + rs.getString("LOCATION");
						break;
						
						case 93 : alertDetails = "Vehicle No "+vehicleNo + " has free wheeled on " + ddmmyyyy.format(yyyymmdd.parse(rs.getString("GPS_DATETIME"))) +" "+ rs.getString("LOCATION") ;
						break;
						
						case 99 : alertDetails = "Vehicle No "+vehicleNo + " has refueled for " + rs.getString("REMARKS")+" Ltrs on " + ddmmyyyy.format(yyyymmdd.parse(rs.getString("GPS_DATETIME"))) +" "+ rs.getString("LOCATION") ;
						break;				
						
						case 102: alertDetails = "Vehicle No "+vehicleNo + " has pilferaged for " + rs.getString("REMARKS")+" Ltrs on " + ddmmyyyy.format(yyyymmdd.parse(rs.getString("GPS_DATETIME"))) +" "+ rs.getString("LOCATION") ;
						break;
						
						case 104: StringTokenizer st = new StringTokenizer(rs.getString("REMARKS"), "|");
								  String temperatureDetails[] = new String[3];
								  int k = 0;
								  while (st.hasMoreTokens()) {
									temperatureDetails[k] = (String) st.nextElement();
									k++;
								  }
								  alertDetails = "Asset " + vehicleNo + " has crossed temperature limit(degree) " + temperatureDetails[1] +" and current temperature(degree) " + temperatureDetails[2] + " " + rs.getString("LOCATION") + " on " +   ddmmyyyy.format(yyyymmdd.parse(rs.getString("GPS_DATETIME"))) ;
						break;
						
						case 117 : alertDetails = vehicleNo + " is inside parking area  " + rs.getString("LOCATION") + " on " + ddmmyyyy.format(yyyymmdd.parse(rs.getString("GMT"))) ;
						break;
						
						case 118 : alertDetails = vehicleNo + " is inside  vault  " + rs.getString("LOCATION") + " on " + ddmmyyyy.format(yyyymmdd.parse(rs.getString("GMT"))) +" refuel unit "+ rs.getString("REMARKS") ;
						break;
						
						case 119 : alertDetails = vehicleNo + " is inside parking area " + rs.getString("LOCATION") + " for more than 24 hours on " + ddmmyyyy.format(yyyymmdd.parse(rs.getString("GMT"))) +" refuel unit "+ rs.getString("REMARKS") ;
						break;
						
						case 132 : alertDetails = "Asset " + vehicleNo + " has been moved from assigned location to " + rs.getString("LOCATION") + " on " + ddmmyyyy.format(yyyymmdd.parse(rs.getString("GPS_DATETIME"))) ;
						break;
						
						default: alertDetails = vehicleNo + " " + rs.getString("LOCATION") +" on "+ ddmmyyyy.format(yyyymmdd.parse(rs.getString("GPS_DATETIME")));
	                    break;
					}

					alertdetailsJSONObject.put("alertdetails", alertDetails);
					alertdetailsJSONObject.put("alertslno",rs.getString("SLNO"));
					alertdetailsJSONObject.put("vehicleNo",vehicleNo);
					alertdetailsJSONObject.put("gmt",rs.getString("GMT"));
					alertdetailsJSONArray.put(alertdetailsJSONObject);
				}

			}

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if (pstmt1 != null) {
				pstmt1 = null;
			}
			if (rs1 != null) {
				rs1 = null;
			}
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return alertdetailsJSONArray;
	}

	public int saveAlertRemarks(String alertslno, String remark, String regno,
			String date, String typeofalert, int offset, int clientId,
			int systemId) {
		Connection con=null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		int result=0;
		try {
			con=DBConnection.getConnectionToDB("AMS");
			if((Integer.parseInt(typeofalert))==2){
				pstmt = con.prepareStatement(AlertStatements.SAVE_OVERSPEED_REMARKS);
				pstmt.setString(1, remark);
				pstmt.setInt(2, Integer.parseInt(alertslno));
				pstmt.setString(3, regno);
				pstmt.setInt(4, clientId);
				pstmt.setInt(5, systemId);
			}
			else if((Integer.parseInt(typeofalert))==3||(Integer.parseInt(typeofalert))==182){
				pstmt = con.prepareStatement(AlertStatements.SAVE_DISTRESS_REMARKS);
				pstmt.setString(1, remark);
				pstmt.setInt(2, Integer.parseInt(alertslno));
				pstmt.setString(3, regno);
				pstmt.setInt(4, clientId);
				pstmt.setInt(5, systemId);
				if(remark.equalsIgnoreCase("Panic Off")){
					
					if(rs!=null)  //Close previous resultset
					rs.close();
					
					PreparedStatement pstmt2 = con.prepareStatement("select Unit_Number,Unit_Type_Code from Vehicle_association where Registration_no=?");
					pstmt2.setString(1, regno);
					ResultSet rs2 = pstmt2.executeQuery();

					if (rs2.next()) {
						
						int unitTypeCode=rs2.getInt("Unit_Type_Code");
						String unitNumber=rs2.getString("Unit_Number");
						if(unitTypeCode == 26 || unitTypeCode == 27 || unitTypeCode == 32 || unitTypeCode == 33 || unitTypeCode == 44 || unitTypeCode == 46 || unitTypeCode == 68){
							unitTypeCode = 9;
						}
						if(unitTypeCode==9){
						int packectNo=0;
						PreparedStatement pstmt1 = con.prepareStatement("select CASE when MAX(PACKET_NO)=0 then 1 else MAX(PACKET_NO)+1 end as PACKET_NO from Data_Out");
						ResultSet rs1 = pstmt1.executeQuery();
						if (rs1.next()) {
							if (rs1.getString("PACKET_NO") != null) {
								packectNo = rs1.getInt("PACKET_NO");
							}
						}
						if(rs1!=null)
						rs1.close();
						pstmt1 = con.prepareStatement("insert into Data_Out(PACKET_NO,DEVICE_ID,PACKET_TYPE,PACKET_MODE,PACKET_PARAMS,INSERTED_DATETIME,STATUS,UNIT_TYPE,IP_ADDRESS) values (?,?,?,?,?,getUTCDATE(),?,?,?)");
						pstmt1.setInt(1, packectNo);
						pstmt1.setString(2, unitNumber);
						pstmt1.setString(3, "RES_IO3");
						pstmt1.setString(4, "SET");
						pstmt1.setString(5, "1");
						pstmt1.setString(6, "N");
						pstmt1.setInt(7, unitTypeCode);
						pstmt1.setString(8, InetAddress.getLocalHost().getHostAddress());
						pstmt1.executeUpdate();
					}
					}
					if(rs2!=null)
						rs2.close();
					
				}
				
			}
			else if((Integer.parseInt(typeofalert))==17 || (Integer.parseInt(typeofalert))== 18){				
					pstmt = con.prepareStatement(AlertStatements.UPDATE_HUB_ALERT);					
					pstmt.setString(1, remark);
					pstmt.setInt(2, Integer.parseInt(alertslno));
					pstmt.setInt(3, systemId);
					pstmt.setInt(4, clientId);
					pstmt.setInt(5, (Integer.parseInt(typeofalert)));								
			}else {
							
			pstmt=con.prepareStatement(AlertStatements.SAVE_ALERT_REMARK);
			pstmt.setString(1, remark);
			pstmt.setInt(2, Integer.parseInt(alertslno));
			pstmt.setString(3, regno);
			pstmt.setInt(4, Integer.parseInt(typeofalert));
			pstmt.setInt(5, clientId);
			pstmt.setInt(6, systemId);
			}
			result=pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		}finally{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return result;
	
	}
	
public int getDistrssAlertCount(int offset,int customerId,int systemId,int userId)
{        Connection con = null;
         PreparedStatement pstmt = null;
         ResultSet rs = null;
         int alertCount=0;
 try {
         con=DBConnection.getConnectionToDB("AMS");
         pstmt = con.prepareStatement(AlertStatements.GET_DISTRESS_COUNT);
	     pstmt.setInt(1, offset);
	     pstmt.setInt(2, customerId);
	     pstmt.setInt(3, systemId);
	     pstmt.setInt(4, userId);
	     rs = pstmt.executeQuery();
	if (rs.next()) {
		alertCount=rs.getInt("COUNT");
	}
 }
 catch (Exception e) {
	e.printStackTrace();
}
 finally
 {
	 DBConnection.releaseConnectionToDB(con, pstmt, rs);
}
 return alertCount;
}

}
