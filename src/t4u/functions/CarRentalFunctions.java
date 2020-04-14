package t4u.functions;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.Map;

import org.json.JSONArray;
import org.json.JSONObject;

import com.google.gson.Gson;

import t4u.beans.ReportHelper;
import t4u.common.DBConnection;
import t4u.google.GoogleApiDisAndTime;
import t4u.google.GsToTs;
import t4u.google.TeToge;
import t4u.google.TsTote;
import t4u.statements.CarRentalStatements;
import t4u.statements.CashVanManagementStatements;

/**
 * @author amith.n
 *
 */
public class CarRentalFunctions {

	SimpleDateFormat ddmmyyyy = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
	SimpleDateFormat yyyymmdd = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	SimpleDateFormat sdfyyyymmddhhmmss=new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
	DecimalFormat Dformatter = new DecimalFormat("#.##");
	CashVanManagementFunctions cvsfn=new CashVanManagementFunctions();
	CommonFunctions cf=new CommonFunctions();
	
	public HashMap<Object, Object> getAlertComponents(int systemId,int customerId,int userId,int offset,String language) {
		HashMap<Object, Object> alert=new LinkedHashMap <Object, Object>();
		HashMap<Object, Object> alertList=new LinkedHashMap <Object, Object>();
		Connection conAdmin=null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		int count=0;
		try {
			conAdmin=DBConnection.getConnectionToDB("AMS");
			pstmt=conAdmin.prepareStatement(CarRentalStatements.GET_ALERT_NAMES);
			pstmt.setInt(1, systemId);
			rs=pstmt.executeQuery();
			while(rs.next()){
				count++;
				alert.put(rs.getString("AlertName"),rs.getInt("AlertId"));				
			}
            if(count==0)
            {
            	pstmt=conAdmin.prepareStatement(CarRentalStatements.GET_ALERT_NAMES);
    			pstmt.setInt(1, -1);
    			rs=pstmt.executeQuery();
    			while(rs.next()){
    				count++;
    				alert.put(rs.getString("AlertName"),rs.getInt("AlertId"));				
    			}
            }
            alertList.put(alert,1);
		} catch (Exception e) {
			e.printStackTrace();
		}finally{
			DBConnection.releaseConnectionToDB(conAdmin, pstmt, rs);
		}
		
		
		return alertList;
		}
	
	public JSONArray getAlertCount(String alertList,int systemId,int customerId, int userId, int offset) {
		Connection conAdmin = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		JSONObject alertcountObject=null;
		JSONArray alertcountArray=new JSONArray();
		int overspeed=0;
		int distress=0;
		int mainPower=0;
		int idleAlert=0;
		int border=0;
		int nonComm12=0;
		int uberCount = 0;
		int hubArrival =0;
		int hubDeparture =0;
		int offRoad = 0;
		int deviceBatCount = 0;
		int gpsTampCrossBorderCount = 0;
		int nonCommCount = 0;
		int proactiveMainCount = 0;
		try {
			final long startTime = System.currentTimeMillis();
			conAdmin = DBConnection.getConnectionToDB("AMS");
			/**
			 * OverSpeed
			 ***/
			if(alertList.contains("OverSpeed"))
			{
				pstmt = conAdmin.prepareStatement(CarRentalStatements.GET_OVER_SPEED_ALERT_COUNT);
				pstmt.setInt(1, customerId);
				pstmt.setInt(2, systemId);
				pstmt.setInt(3, userId);
				pstmt.setInt(4, customerId);
				pstmt.setInt(5, systemId);
				pstmt.setInt(6, userId);
				rs = pstmt.executeQuery();
				if (rs.next()) {
					overspeed=rs.getInt("ALERT_COUNT");
				}
				rs.close();
				pstmt.close();
			}
			if(alertList.contains("Distress"))
			{
				pstmt = conAdmin.prepareStatement(CarRentalStatements.GET_DISTRESS_COUNT);
				pstmt.setInt(1, customerId);
				pstmt.setInt(2, systemId);
				pstmt.setInt(3, userId);
				pstmt.setInt(4, customerId);
				pstmt.setInt(5, systemId);
				pstmt.setInt(6, userId);
				rs = pstmt.executeQuery();
				if (rs.next()) {
					distress=rs.getInt("ALERT_COUNT");
				}
				rs.close();
				pstmt.close();
			}
			pstmt = conAdmin.prepareStatement(CarRentalStatements.GET_ALERT_COUNT);
			pstmt.setInt(1, userId);
			pstmt.setInt(2, systemId);
			pstmt.setInt(3, customerId);
			pstmt.setInt(4, userId);
			pstmt.setInt(5, systemId);
			pstmt.setInt(6, customerId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				if(rs.getInt("TYPE_OF_ALERT")== 39){
					idleAlert=rs.getInt("ALERT_COUNT");
				}
				if(rs.getInt("TYPE_OF_ALERT")== 84){
					border=rs.getInt("ALERT_COUNT");
				}
				if(rs.getInt("TYPE_OF_ALERT")== 139){
					uberCount=rs.getInt("ALERT_COUNT");
				}
			}
			
			rs.close();
			pstmt.close();
			
			pstmt = conAdmin.prepareStatement(CarRentalStatements.GET_ALERT_COUNT_NON_COMMUNICATING);
			pstmt.setInt(1, userId);
			pstmt.setInt(2, systemId);
			pstmt.setInt(3, customerId);
			pstmt.setInt(4, userId);
			pstmt.setInt(5, systemId);
			pstmt.setInt(6, customerId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				if(rs.getInt("TYPE_OF_ALERT")== 145){
					mainPower=rs.getInt("ALERT_COUNT");
				}
				else if(rs.getInt("TYPE_OF_ALERT")== 85){
					nonComm12=rs.getInt("ALERT_COUNT");
				}
				else if(rs.getInt("TYPE_OF_ALERT")== 148){
					gpsTampCrossBorderCount=rs.getInt("ALERT_COUNT");
				}
			}
			rs.close();
			pstmt.close();
			
			pstmt = conAdmin.prepareStatement(CarRentalStatements.GET_HUB_ARRIVAL_COUNT);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, customerId);
			pstmt.setInt(3, userId);
			pstmt.setInt(4, systemId);
			pstmt.setInt(5, customerId);
			pstmt.setInt(6, userId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				if(rs.getInt("TYPE_OF_ALERT")== 17){
					hubArrival=rs.getInt("COUNT");
				}
				
				if(rs.getInt("TYPE_OF_ALERT")== 18){
					hubDeparture=rs.getInt("COUNT");
				}
			}
			rs.close();
			pstmt.close();
			
			pstmt = conAdmin.prepareStatement(CarRentalStatements.GET_ALERT_COUNT_DEVICE_BATERY_CONNECTION);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2,customerId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
					deviceBatCount=rs.getInt("AlertCount");
			}
			rs.close();
			pstmt.close();
			
			pstmt = conAdmin.prepareStatement(CarRentalStatements.GET_NON_COMMUNICATING_COUNT);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2,customerId);
			pstmt.setInt(3, userId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				nonCommCount=rs.getInt("NON_COMMUNICATING");
			}
			rs.close();
			pstmt.close();
			
			pstmt = conAdmin.prepareStatement(CarRentalStatements.GET_PROACTIVE_MAINTENANCE_COUNT.replace("#", ""+systemId));
			pstmt.setInt(1, systemId);
			pstmt.setInt(2,customerId);
			pstmt.setInt(3,customerId);
			pstmt.setInt(4, userId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				proactiveMainCount=rs.getInt("PROACTIVE_COUNT");
			}
			rs.close();
			pstmt.close();
			
			pstmt = conAdmin.prepareStatement(CarRentalStatements.GET_OFF_ROAD_COUNT);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, customerId);
			pstmt.setInt(3, userId);
			pstmt.setInt(4, systemId);
			pstmt.setInt(5, customerId);
			pstmt.setInt(6, userId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				if(rs.getInt("TYPE_OF_ALERT")== 17){
					offRoad=rs.getInt("COUNT");
				}
			}
			
				alertcountObject=new JSONObject();
				alertcountObject.put("overspeedAlertCount", overspeed);
				alertcountObject.put("distressAlertCount", distress);
				alertcountObject.put("mainPowerAlertCount", mainPower);
				alertcountObject.put("idleAlertCount", idleAlert);
				alertcountObject.put("crossBorderlertCount", border);
				alertcountObject.put("noncommunicating_12",nonComm12);
				alertcountObject.put("uberAlertCount",uberCount);
				alertcountObject.put("hubArrivalCount",hubArrival);
				alertcountObject.put("hubDepartureCount",hubDeparture);
				alertcountObject.put("vehicleoffRoadCount",offRoad);
				alertcountObject.put("deviceBateryCount",deviceBatCount);
				alertcountObject.put("gpsTampCrossBorderCount",gpsTampCrossBorderCount);
				alertcountObject.put("nonCommunicationCount",nonCommCount);
				alertcountObject.put("proactiveMaintenanceCount",proactiveMainCount);
				alertcountArray.put(alertcountObject);
				
			final long endTime = System.currentTimeMillis();
			
			System.out.println("-Total execution time: " + (endTime - startTime)/1000 );
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(conAdmin, pstmt, rs);
		}
		return alertcountArray;
	}
 
	public JSONArray getCommNonCommVehicles(String customerid, int systemId,int userId,int isLtsp,int offset,String zone, int nonCommHrs) {
		Connection con = null;
		PreparedStatement pstmt = null,pstmt1 = null,pstmt2 = null,pstmt3 = null,pstmt4 = null,pstmt5 = null,pstmt6 = null,pstmtop = null;
		ResultSet rs = null;		
		JSONArray commnoncommJSONArray=new JSONArray();
		JSONObject commnoncommJSONObject;
		try {		
			int nonCommunicatingCount=0;
			int communicatingVehicles=0;
			int noGpsConnected=0;
			int totalAssetCount=0;
			int immobilized=0;
			int highUsage=0;
			int underMaintanceCount=0;
			int voltagedrain=0;
			String hubIds=null;
			StringBuffer sb=new StringBuffer();
			commnoncommJSONObject=new JSONObject();
			con = DBConnection.getDashboardConnection("AMS");
				pstmt = con.prepareStatement(CarRentalStatements.GET_TOTAL_ASSET_COUNT);
				pstmt1 = con.prepareStatement(CarRentalStatements.GET_NON_COMMUNICATING);					
				pstmt2 = con.prepareStatement(CarRentalStatements.GET_NOGPS_VEHICLES);
				pstmt4 = con.prepareStatement(CarRentalStatements.GET_IMMOBILIZED_DATA);
			    pstmt5 = con.prepareStatement(CarRentalStatements.GET_HIGH_USAGE_DATA);
			    pstmt6 = con.prepareStatement(CarRentalStatements.GET_VOLTAGE_DRAIN);
		
			rs=null;
			pstmt.setInt(1, systemId);
			pstmt.setString(2, customerid);
			pstmt.setInt(3,userId);
			rs = pstmt.executeQuery();
			if (rs.next()) {			
				totalAssetCount=rs.getInt("COUNT");
			}
			rs=null;
			pstmt1.setString(1, customerid);
			pstmt1.setInt(2, systemId);
			pstmt1.setInt(3, nonCommHrs);
			pstmt1.setInt(4,userId);
			rs = pstmt1.executeQuery();
			if (rs.next()) {			
				nonCommunicatingCount=rs.getInt("NON_COMMUNICATING");
			}			
			rs=null;		
			pstmt2.setString(1,customerid);
			pstmt2.setInt(2, systemId);
			pstmt2.setInt(3,userId);
			rs = pstmt2.executeQuery();
			if (rs.next()) {			
				noGpsConnected=rs.getInt("NOGPS");
			}	
			pstmtop = con.prepareStatement(cf.getLocationQuery(CarRentalStatements.GET_UNDER_MAINTANCE_COUNT, zone));
			rs=null;
			pstmtop.setInt(1, systemId);
			pstmtop.setString(2, customerid);
			rs = pstmtop.executeQuery();
			while (rs.next()) {			
				String hubId = rs.getString("HUBID");
				sb.append(hubId+",");
			}
			if(hubIds!=null){
			 hubIds=sb.substring(0,sb.length()-1);
		    }
			
			pstmt3 = con.prepareStatement("select count(distinct a.REGISTRATION_NO) as COUNT from AMS.dbo.HUB_REPORT a " +
					" inner join AMS.dbo.VEHICLE_CLIENT b on b.SYSTEM_ID=a.SYSTEM_ID and a.REGISTRATION_NO=b.REGISTRATION_NUMBER " +
					" inner join AMS.dbo.Vehicle_User c on c.System_id=a.SYSTEM_ID and c.Registration_no=a.REGISTRATION_NO " +
					" where a.SYSTEM_ID=? and b.CLIENT_ID=? and c.User_id=? and ACTUAL_ARRIVAL<dateadd(hh,-48,getutcdate()) " +
					" and ACTUAL_DEPARTURE is null and HUB_ID in (" +hubIds +")");
			rs=null;
			pstmt3.setInt(1, systemId);
			pstmt3.setString(2, customerid);
			pstmt3.setInt(3, userId);
			rs = pstmt3.executeQuery();
			if (rs.next()) {			
				underMaintanceCount=rs.getInt("COUNT");
			}
			rs=null;
			pstmt4.setInt(1, systemId);
			pstmt4.setString(2, customerid);
			pstmt4.setInt(3, userId);
			rs = pstmt4.executeQuery();
			if (rs.next()) {			
				immobilized=rs.getInt("COUNT");
			}
			rs=null;
			pstmt5.setInt(1, systemId);
			pstmt5.setString(2, customerid);
			pstmt5.setInt(3, userId);
			pstmt5.setInt(4, offset);
			rs = pstmt5.executeQuery();
			if (rs.next()) {			
				highUsage=rs.getInt("COUNT");
			}
			rs=null;
			pstmt6.setInt(1, systemId);
			pstmt6.setString(2, customerid);
			pstmt6.setInt(3,userId);
			rs = pstmt6.executeQuery();
			if (rs.next()) {			
				voltagedrain=rs.getInt("COUNT");
			}
			communicatingVehicles=totalAssetCount-(nonCommunicatingCount+noGpsConnected);			
			commnoncommJSONObject.put("totalAssets",totalAssetCount);
			commnoncommJSONObject.put("communicating", communicatingVehicles);
			commnoncommJSONObject.put("noncommunicating",nonCommunicatingCount);
			commnoncommJSONObject.put("immobilizedCount",immobilized);
			commnoncommJSONObject.put("highUsageCount",highUsage);
			commnoncommJSONObject.put("underMaintanceCount",underMaintanceCount);
			commnoncommJSONObject.put("voltagedrain",voltagedrain);
			commnoncommJSONArray.put(commnoncommJSONObject);		
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
			DBConnection.releaseConnectionToDB(null, pstmt1, null);
			DBConnection.releaseConnectionToDB(null, pstmt2, null);	
		    DBConnection.releaseConnectionToDB(null, pstmtop, null);	
			DBConnection.releaseConnectionToDB(null, pstmt3, null);	
			DBConnection.releaseConnectionToDB(null, pstmt4, null);
			DBConnection.releaseConnectionToDB(null, pstmt5, null);
			DBConnection.releaseConnectionToDB(null, pstmt6, null);
		}	
		return commnoncommJSONArray;	
	}
	public Map<String,Integer> getDashBoardDetails(int systemId){
		Map<String,Integer> alert=new LinkedHashMap <String,Integer>();
		Connection conAdmin=null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		int count=0;
		try {
			conAdmin=DBConnection.getConnectionToDB("AMS");
			pstmt=conAdmin.prepareStatement(CarRentalStatements.GET_CVS_DASHBOARD_SETTING);
			pstmt.setInt(1, systemId);
			rs=pstmt.executeQuery();
			while(rs.next()){
				count++;
				alert.put(rs.getString("ALERT_NAME_LABEL_ID"),rs.getInt("ALERT_ID"));				
			}
            if(count==0)
            {
            	pstmt=conAdmin.prepareStatement(CarRentalStatements.GET_CVS_DASHBOARD_SETTING);
    			pstmt.setInt(1, -1);
    			rs=pstmt.executeQuery();
    			while(rs.next()){
    				count++;
    				alert.put(rs.getString("ALERT_NAME_LABEL_ID"),rs.getInt("ALERT_ID"));				
    			}
            }
		} catch (Exception e) {
			e.printStackTrace();
		}finally{
			DBConnection.releaseConnectionToDB(conAdmin, pstmt, rs);
		}
		return alert;
		}
	
	public JSONArray getPreventiveExpiryVehicles(String customerid, int systemId,int userId) {

		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int expired=0;
		int dueforExpiry=0;
		JSONArray preventiveJSONArray=new JSONArray();
		JSONObject preventiveJSONObject;
		try {
			preventiveJSONObject=new JSONObject();
			con = DBConnection.getDashboardConnection("AMS");
			pstmt = con.prepareStatement(CarRentalStatements.PREVENTIVE_EXPIRED_FROM_PREVENTIVE_EVENTS,ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, Integer.parseInt(customerid));
			pstmt.setInt(3, userId);
			pstmt.setInt(4, systemId);
			pstmt.setInt(5, Integer.parseInt(customerid));
			pstmt.setInt(6, userId);
			rs = pstmt.executeQuery();
			if (rs.next()) {			
				expired=rs.getInt("PREVENTIVE_EXPIRED");
			}
			pstmt=null;
			rs=null;
			pstmt = con.prepareStatement(CarRentalStatements.PREVENTIVE_DUE_FOR_EXPIRY_FROM_PREVENTIVE_EVENTS,ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, Integer.parseInt(customerid));
			pstmt.setInt(3, userId);
			rs = pstmt.executeQuery();
			if (rs.next()) {			
				dueforExpiry=rs.getInt("PREVENTIVE_DUR_FOR_EXPIRED");
			}
			preventiveJSONObject.put("expired", expired);
			preventiveJSONObject.put("dueforexpiry",dueforExpiry);
			preventiveJSONArray.put(preventiveJSONObject);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}

		return preventiveJSONArray;
	
	}

	public JSONArray getStatutoryDetails(String customerid, int systemId,int offset) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int insuranceDOE=0;
		int insuranceExp=0;
		int goodstokentaxDOE=0;
		int goodstokentaxExp=0;
		int FCIDOE=0;
		int FCIExp=0;
		int EmissionDOE=0;
		int EmissionExp=0;
		int PermitDOE=0;
		int PermitExp=0;
		int RegistrationDOE=0;
		int RegistrationExp=0;
		int roadTaxDOE=0;
		int roadTaxExp=0;
		int stateTaxDOE=0;
		int stateTaxExp=0;
		int DriverLicenseDOE=0;
		int DriverLicenseExp=0;
		JSONArray statutoryJSONArray=new JSONArray();
		JSONObject statutoryJSONObject;
		try {
			statutoryJSONObject=new JSONObject();
			con = DBConnection.getDashboardConnection("AMS");
			pstmt = con.prepareStatement(CarRentalStatements.GET_STATUTORY_ALERT_COUNT);
			pstmt.setInt(1, Integer.parseInt(customerid));
			pstmt.setInt(2, systemId);
			pstmt.setInt(3, Integer.parseInt(customerid));
			pstmt.setInt(4, systemId);
			rs = pstmt.executeQuery();
			if (rs.next()) {			
				insuranceDOE=rs.getInt("INSURANCE_DOE");
				insuranceExp=rs.getInt("INSURANCE_EXP");
				goodstokentaxDOE=rs.getInt("GOODS_TOKEN_TAX_DOE");
				goodstokentaxExp=rs.getInt("GOODS_TOKEN_TAX_EXP");
				FCIDOE=rs.getInt("FCI_DOE");
				FCIExp=rs.getInt("FCI_EXP");
				EmissionDOE=rs.getInt("EMISSION_DOE");
				EmissionExp=rs.getInt("EMISSION_EXP");
				PermitDOE=rs.getInt("PERMIT_DOE");
				PermitExp=rs.getInt("PERMIT_EXP");
				RegistrationDOE=rs.getInt("REGISTRATION_DOE");
				RegistrationExp=rs.getInt("REGISTRATION_EXP");
				roadTaxDOE=rs.getInt("ROAD_TAX_DOE");
				roadTaxExp=rs.getInt("ROAD_TAX_EXP");
				stateTaxDOE=rs.getInt("STATE_TAX_DOE");
				stateTaxExp=rs.getInt("STATE_TAX_EXP");
				DriverLicenseDOE=rs.getInt("DRIVER_LICENSE_DOE");
				DriverLicenseExp=rs.getInt("DRIVER_LICENSE_EXP");
			}
			statutoryJSONObject.put("insuranceDOE", insuranceDOE);
			statutoryJSONObject.put("insuranceExp",insuranceExp);
			statutoryJSONObject.put("goodstokentaxDOE",goodstokentaxDOE);
			statutoryJSONObject.put("goodstokentaxExp", goodstokentaxExp);
			statutoryJSONObject.put("FCIDOE",FCIDOE);
			statutoryJSONObject.put("FCIExp",FCIExp);
			statutoryJSONObject.put("EmissionDOE", EmissionDOE);
			statutoryJSONObject.put("EmissionExp",EmissionExp);
			statutoryJSONObject.put("PermitDOE",PermitDOE);
			statutoryJSONObject.put("PermitExp", PermitExp);
			statutoryJSONObject.put("RegistrationDOE",RegistrationDOE);
			statutoryJSONObject.put("RegistrationExp", RegistrationExp);
			statutoryJSONObject.put("roadTaxDOE", roadTaxDOE);
			statutoryJSONObject.put("roadTaxExp", roadTaxExp);
			statutoryJSONObject.put("stateTaxDOE", stateTaxDOE);
			statutoryJSONObject.put("stateTaxExp", stateTaxExp);
			statutoryJSONObject.put("DriverLicenseDOE",DriverLicenseDOE);
			statutoryJSONObject.put("DriverLicenseExp",DriverLicenseExp);
			statutoryJSONArray.put(statutoryJSONObject);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}

		return statutoryJSONArray;
	}

	public JSONArray getAlertDetails(int offset, String alertID, int systemId,int customerId, int userId,String type) {
		Connection con = null;
		PreparedStatement pstmt = null;
		PreparedStatement pstmt1 = null;
		ResultSet rs = null;
		ResultSet rs1 = null;
		String vehicleNo = "";
		String alertDetails = "";
        int alertId;
		CommonFunctions commonFunctions = new CommonFunctions();
		JSONArray alertdetailsJSONArray = new JSONArray();
		JSONObject alertdetailsJSONObject = null;
		try {
			con = DBConnection.getConnectionToDB("AMS");
			alertId = Integer.parseInt(alertID);
			
			if (alertId == 17 || alertId == 18) {
				if(type.equals("Actioned")){
					pstmt = con.prepareStatement((CarRentalStatements.GET_HUB_ARRIVAL_DETAIL).replaceAll("REMARK is null", "REMARK!='' "));
				}else if (type.equals("Un-Actioned")){
				    pstmt = con.prepareStatement(CarRentalStatements.GET_HUB_ARRIVAL_DETAIL);
				}else if (type.equals("All")){
					pstmt = con.prepareStatement((CarRentalStatements.GET_HUB_ARRIVAL_DETAIL).replaceAll("and REMARK is null", ""));
				}
				pstmt.setInt(1, systemId);
				pstmt.setInt(2, customerId);
				pstmt.setInt(3, userId);
				pstmt.setInt(4, alertId);
				pstmt.setInt(5, systemId);
				pstmt.setInt(6, customerId);
				pstmt.setInt(7, userId);
				pstmt.setInt(8, alertId);
				rs = pstmt.executeQuery();
				while (rs.next()) {
					alertdetailsJSONObject = new JSONObject();
					vehicleNo = rs.getString("REGISTRATION_NO");
					alertDetails = vehicleNo  +" "+ rs.getString("LOCATION") + " On " + ddmmyyyy.format(yyyymmdd.parse(rs.getString("GPS_DATETIME")));
					alertdetailsJSONObject.put("alertdetails", alertDetails);
					alertdetailsJSONObject.put("alertslno",rs.getString("SLNO"));
					alertdetailsJSONObject.put("vehicleNo",vehicleNo);
					alertdetailsJSONObject.put("gmt",rs.getString("GMT"));
					alertdetailsJSONObject.put("alertType",rs.getString("ALERT_TYPE"));
					alertdetailsJSONObject.put("Remarks",rs.getString("REMARKS"));
					alertdetailsJSONArray.put(alertdetailsJSONObject);
				}
			}
			
			else if (alertId == 2) {
				if(type.equals("Actioned")){
					pstmt = con.prepareStatement((CarRentalStatements.GET_OVER_SPEED_ALERT).replaceAll("REMARK is null", "REMARK!='' "));
				}else if (type.equals("Un-Actioned")){
				    pstmt = con.prepareStatement(CarRentalStatements.GET_OVER_SPEED_ALERT);
				}else if (type.equals("All")){
					pstmt = con.prepareStatement((CarRentalStatements.GET_OVER_SPEED_ALERT).replaceAll("and REMARK is null", ""));
				}
				pstmt.setInt(1, customerId);
				pstmt.setInt(2, systemId);
				pstmt.setInt(3, userId);
				pstmt.setInt(4, customerId);
				pstmt.setInt(5, systemId);
				pstmt.setInt(6, userId);
				rs = pstmt.executeQuery();
				while (rs.next()) {
					alertdetailsJSONObject = new JSONObject();
					vehicleNo = rs.getString("REGISTRATION_NO");
					alertDetails = vehicleNo + " overspeeded " + rs.getString("LOCATION") + " On " + ddmmyyyy.format(yyyymmdd.parse(rs.getString("GPS_DATETIME"))) + " with Speed "+rs.getString("SPEED")+" km/h" ;
					alertdetailsJSONObject.put("alertdetails", alertDetails);
					alertdetailsJSONObject.put("alertslno",rs.getString("SLNO"));
					alertdetailsJSONObject.put("vehicleNo",vehicleNo);
					alertdetailsJSONObject.put("gmt",rs.getString("GMT"));
					alertdetailsJSONObject.put("alertType",rs.getString("ALERT_TYPE"));
					alertdetailsJSONObject.put("Remarks",rs.getString("REMARKS"));
					alertdetailsJSONArray.put(alertdetailsJSONObject);
				}
			}
			
			else if (alertId == 3) {
				if(type.equals("Actioned")){
					pstmt = con.prepareStatement((CarRentalStatements.GET_DISTRESS_ALERT_DETAILS).replaceAll("REMARK is null", "REMARK is not null"));
				}else if (type.equals("Un-Actioned")){
				    pstmt = con.prepareStatement(CarRentalStatements.GET_DISTRESS_ALERT_DETAILS);
				}else{
					pstmt = con.prepareStatement((CarRentalStatements.GET_DISTRESS_ALERT_DETAILS).replaceAll("and REMARK is null", ""));
				}
				pstmt.setInt(1, systemId);
				pstmt.setInt(2, customerId);
				pstmt.setInt(3, alertId);
				pstmt.setInt(4, userId);
				pstmt.setInt(5, systemId);
				pstmt.setInt(6, customerId);
				pstmt.setInt(7, alertId);
				pstmt.setInt(8, userId);
				rs = pstmt.executeQuery();
				while (rs.next()) {
					alertdetailsJSONObject = new JSONObject();
					vehicleNo = rs.getString("REGISTRATION_NO");
					alertDetails = vehicleNo + " " + rs.getString("LOCATION") + " Under Distress On " + ddmmyyyy.format(yyyymmdd.parse(rs.getString("GMT")));
					alertdetailsJSONObject.put("alertdetails", alertDetails);
					alertdetailsJSONObject.put("alertslno",rs.getString("SLNO"));
					alertdetailsJSONObject.put("vehicleNo",vehicleNo);
					alertdetailsJSONObject.put("gmt",rs.getString("GMT"));
					alertdetailsJSONObject.put("alertType",rs.getString("ALERT_TYPE"));
					alertdetailsJSONObject.put("Remarks",rs.getString("REMARKS"));
					alertdetailsJSONArray.put(alertdetailsJSONObject);
					
				}
			}
			else if(alertId == 145 || alertId == 85 || alertId == 148){
					if(type.equals("Actioned")){
						pstmt = con.prepareStatement((CarRentalStatements.GET_NON_COMMUNICATING_ALERT_DETAILS).replaceAll("\\(MONITOR_STATUS is null or MONITOR_STATUS='N'\\)", "(MONITOR_STATUS is not null and MONITOR_STATUS!='N')"));
					}else if (type.equals("Un-Actioned")){
					    pstmt = con.prepareStatement(CarRentalStatements.GET_NON_COMMUNICATING_ALERT_DETAILS);
					}else{
						pstmt = con.prepareStatement((CarRentalStatements.GET_NON_COMMUNICATING_ALERT_DETAILS).replaceAll("and \\(MONITOR_STATUS is null or MONITOR_STATUS='N'\\)", " "));
					}
				
				pstmt.setInt(1, offset);
				pstmt.setInt(2, systemId);
				pstmt.setInt(3, customerId);
				pstmt.setInt(4, alertId);
				pstmt.setInt(5, userId);
				pstmt.setInt(6, offset);
				pstmt.setInt(7, systemId);
				pstmt.setInt(8, customerId);
				pstmt.setInt(9, alertId);
				pstmt.setInt(10, userId);
				rs = pstmt.executeQuery();
				while (rs.next()) {
					alertdetailsJSONObject = new JSONObject();
					vehicleNo = rs.getString("REGISTRATION_NO");
					
					switch(alertId){
					
						//Main Power OnOff
						case 7 :
							
							
								if(rs.getInt("HUB_ID") == 0){
									alertDetails = vehicleNo + " main power is Off " + rs.getString("LOCATION") + " On " + ddmmyyyy.format(yyyymmdd.parse(rs.getString("GPS_DATETIME")));
								} else if(rs.getInt("HUB_ID") == 1){
									alertDetails = vehicleNo + " main power is On " + rs.getString("LOCATION") + " On " + ddmmyyyy.format(yyyymmdd.parse(rs.getString("GPS_DATETIME")));
								} else if(rs.getInt("HUB_ID") == 2){
									alertDetails = vehicleNo + " main power input for the device has been tampered " + rs.getString("LOCATION") + " On " + ddmmyyyy.format(yyyymmdd.parse(rs.getString("GPS_DATETIME")));
								}
							
						break;
						
						case 85 : alertDetails = vehicleNo + " is not communicating since " + ddmmyyyy.format(yyyymmdd.parse(rs.getString("GMT"))) + " and last communicated " + rs.getString("LOCATION");
						break;
						
					    default: alertDetails = vehicleNo + " " + rs.getString("LOCATION") +" on "+ ddmmyyyy.format(yyyymmdd.parse(rs.getString("GPS_DATETIME")));
	                    break;
					}

					alertdetailsJSONObject.put("alertdetails", alertDetails);
					alertdetailsJSONObject.put("alertslno",rs.getString("SLNO"));
					alertdetailsJSONObject.put("vehicleNo",vehicleNo);
					alertdetailsJSONObject.put("gmt",rs.getString("GMT"));
					alertdetailsJSONObject.put("alertType",rs.getString("ALERT_TYPE"));
					alertdetailsJSONObject.put("Remarks",rs.getString("MONITOR_STATUS"));
					alertdetailsJSONArray.put(alertdetailsJSONObject);
				}
			
		}
		
		else 
		{
			if(type.equals("Actioned")){
				pstmt = con.prepareStatement((CarRentalStatements.GET_ALERT_DETAILS).replaceAll("\\(MONITOR_STATUS is null or MONITOR_STATUS='N'\\)", "(MONITOR_STATUS is not null and MONITOR_STATUS!='N')"));
			}else if (type.equals("Un-Actioned")){
			    pstmt = con.prepareStatement(CarRentalStatements.GET_ALERT_DETAILS);
			}else{
				pstmt = con.prepareStatement((CarRentalStatements.GET_ALERT_DETAILS).replaceAll("and  \\(MONITOR_STATUS is null or MONITOR_STATUS='N'\\)", ""));
			}
			pstmt.setInt(1, offset);
			pstmt.setInt(2, systemId);
			pstmt.setInt(3, customerId);
			pstmt.setInt(4, alertId);
			pstmt.setInt(5, userId);
			pstmt.setInt(6, offset);
			pstmt.setInt(7, systemId);
			pstmt.setInt(8, customerId);
			pstmt.setInt(9, alertId);
			pstmt.setInt(10, userId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				alertdetailsJSONObject = new JSONObject();
				vehicleNo = rs.getString("REGISTRATION_NO");
				
				switch(alertId){
					//Stoppage
					case 1 :	alertDetails = vehicleNo + " stopped " + rs.getString("LOCATION") + " On " + ddmmyyyy.format(yyyymmdd.parse(rs.getString("GPS_DATETIME"))) + " stopped for " + commonFunctions.getDayHrMinFormat(rs.getDouble("STOP_HOURS")) + "(dd:hh:mm)";
					break;
					
					//Main Power OnOff
					
					case 38 : int alertType = rs.getInt("HUB_ID");
							  String alertStatus = "OPEN";
							  if(alertType == 1){
								  alertStatus = "CLOSE";
							  }
					
						     alertDetails = "Asset " + vehicleNo + ", Door was " + alertStatus + " " + rs.getString("LOCATION") + " On " + ddmmyyyy.format(yyyymmdd.parse(rs.getString("GPS_DATETIME")));
					break;
					
					
					case 82 : alertDetails = vehicleNo + " inside border " + rs.getString("LOCATION") + " On " + ddmmyyyy.format(yyyymmdd.parse(rs.getString("GPS_DATETIME")));
					break;
					
					case 83 : alertDetails = vehicleNo + " near to border " + rs.getString("LOCATION") + " On " + ddmmyyyy.format(yyyymmdd.parse(rs.getString("GPS_DATETIME")));
					break;
					
					case 84 : alertDetails = vehicleNo + " crossed border " + rs.getString("LOCATION") + " On " + ddmmyyyy.format(yyyymmdd.parse(rs.getString("GPS_DATETIME")));
					break;
					
					case 139 :	alertDetails = vehicleNo + " stopped " + rs.getString("LOCATION") + " On " + ddmmyyyy.format(yyyymmdd.parse(rs.getString("GPS_DATETIME"))) + " stopped for " + commonFunctions.getDayHrMinFormat(rs.getDouble("STOP_HOURS")) + "(dd:hh:mm)";
					break;
					
				    default: alertDetails = vehicleNo + " " + rs.getString("LOCATION") +" on "+ ddmmyyyy.format(yyyymmdd.parse(rs.getString("GPS_DATETIME")));
                    break;
				}

					alertdetailsJSONObject.put("alertdetails", alertDetails);
					alertdetailsJSONObject.put("alertslno",rs.getString("SLNO"));
					alertdetailsJSONObject.put("vehicleNo",vehicleNo);
					alertdetailsJSONObject.put("gmt",rs.getString("GMT"));
					alertdetailsJSONObject.put("alertType",rs.getString("ALERT_TYPE"));
					alertdetailsJSONObject.put("Remarks",rs.getString("MONITOR_STATUS"));
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
			int systemId,String type,int userId) {
		Connection con=null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		int result=0;
		try {
			con=DBConnection.getConnectionToDB("AMS");
			if((Integer.parseInt(typeofalert))==2){
				if (type.equals("Alert")) {
					pstmt = con.prepareStatement(CarRentalStatements.SAVE_OVERSPEED_REMARKS);
					pstmt.setString(1, remark);
					pstmt.setInt(2, Integer.parseInt(alertslno));
					pstmt.setString(3, regno);
					pstmt.setInt(4, clientId);
					pstmt.setInt(5, systemId);
				}else{
					pstmt = con.prepareStatement(CarRentalStatements.SAVE_OVERSPEED_HISTORY_REMARKS);
					pstmt.setString(1, remark);
					pstmt.setInt(2, Integer.parseInt(alertslno));
					pstmt.setString(3, regno);
					pstmt.setInt(4, clientId);
					pstmt.setInt(5, systemId);
				}
				
			}
			else if((Integer.parseInt(typeofalert))==3){
				if (type.equals("Alert")) {
					pstmt = con.prepareStatement(CarRentalStatements.SAVE_DISTRESS_REMARKS);
					pstmt.setString(1, remark);
					pstmt.setInt(2, Integer.parseInt(alertslno));
					pstmt.setString(3, regno);
					pstmt.setInt(4, clientId);
					pstmt.setInt(5, systemId);
				}else{
					pstmt = con.prepareStatement(CarRentalStatements.SAVE_DISTRESS_HISTORY_REMARKS);
					pstmt.setString(1, remark);
					pstmt.setInt(2, Integer.parseInt(alertslno));
					pstmt.setString(3, regno);
					pstmt.setInt(4, clientId);
					pstmt.setInt(5, systemId);
				}
			}
			
			else if((Integer.parseInt(typeofalert))== 17 || (Integer.parseInt(typeofalert))== 18 || (Integer.parseInt(typeofalert))== 23 ){
				if (type.equals("Alert")) {
					pstmt = con.prepareStatement(CarRentalStatements.SAVE_HUB_ALERT_REMARKS);
					pstmt.setString(1, remark);
					pstmt.setInt(2, Integer.parseInt(alertslno));
					pstmt.setString(3, regno);
					pstmt.setInt(4, clientId);
					pstmt.setInt(5, systemId);
				}else{
					pstmt = con.prepareStatement(CarRentalStatements.SAVE_HUB_ALERT_HISTORY_REMARKS);
					pstmt.setString(1, remark);
					pstmt.setInt(2, Integer.parseInt(alertslno));
					pstmt.setString(3, regno);
					pstmt.setInt(4, clientId);
					pstmt.setInt(5, systemId);
				}
			}
			
			else {
				if (type.equals("Alert")) {
					pstmt=con.prepareStatement(CarRentalStatements.SAVE_ALERT_REMARK);
					pstmt.setString(1, remark);
					pstmt.setString(2, remark);
					pstmt.setInt(3, userId);
					pstmt.setInt(4, Integer.parseInt(alertslno));
					pstmt.setString(5, regno);
					pstmt.setInt(6, Integer.parseInt(typeofalert));
					pstmt.setInt(7, clientId);
					pstmt.setInt(8, systemId);
				}else{
					pstmt=con.prepareStatement(CarRentalStatements.SAVE_ALERT_HISTORY_REMARK);
					pstmt.setString(1, remark);
					pstmt.setString(2, remark);
					pstmt.setInt(3, userId);
					pstmt.setInt(4, Integer.parseInt(alertslno));
					pstmt.setString(5, regno);
					pstmt.setInt(6, Integer.parseInt(typeofalert));
					pstmt.setInt(7, clientId);
					pstmt.setInt(8, systemId);
				}
			
			}
			result=pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		}finally{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return result;
	
	}
	

	public JSONArray getHighUsageAlertDetails(int offset, String alertID, int systemId,int customerId, int userId) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		JSONObject HighUsageDetails=null;
		JSONArray jsonArray=new JSONArray();
		int count=0;
		try{
		con = DBConnection.getConnectionToDB("AMS");	
		if(alertID.equals("-2"))
		{
		pstmt=con.prepareStatement(CarRentalStatements.GET_HIGH_USAGE_DETAILS);
		pstmt.setInt(1, systemId);
		pstmt.setInt(2, customerId);
		pstmt.setInt(3, userId);
		pstmt.setInt(4, offset);
		}
		else 
		{
		pstmt=con.prepareStatement(CarRentalStatements.GET_IMMOBILIZED_DETAILS);
		pstmt.setInt(1, systemId);
		pstmt.setInt(2, customerId);
		pstmt.setInt(3, userId);
		}	
		rs=pstmt.executeQuery();
		while(rs.next())
		{
			HighUsageDetails = new JSONObject();
			HighUsageDetails.put("slnoIndex", ++count);
			HighUsageDetails.put("vehicleNoDI", rs.getString("REGISTRATION_NO"));
			HighUsageDetails.put("groupDI", rs.getString("GROUP_NAME"));
			HighUsageDetails.put("drivernamerDI", rs.getString("DRIVER_NAME"));
			HighUsageDetails.put("drivernumberDI", rs.getString("REGISTRATION_NO"));
			HighUsageDetails.put("drivernamerDI", rs.getString("DRIVER_NAME"));
			HighUsageDetails.put("drivernumberDI", "");
			if(!rs.getString("DRIVER_NAME").isEmpty())
			{
			HighUsageDetails.put("drivernamerDI", rs.getString("DRIVER_NAME").substring(0, rs.getString("DRIVER_NAME").indexOf("(")));
			HighUsageDetails.put("drivernumberDI", rs.getString("DRIVER_NAME").substring(rs.getString("DRIVER_NAME").indexOf("(")+1, rs.getString("DRIVER_NAME").indexOf(")")));
			}
			if(alertID.equals("-2")){
			HighUsageDetails.put("travelledDI", rs.getString("TotalDistanceTravelled"));
			HighUsageDetails.put("ImmobilizedDI", "");
			HighUsageDetails.put("dateTimeDI", "");
			}else {
			HighUsageDetails.put("travelledDI", "");
			HighUsageDetails.put("ImmobilizedDI", rs.getString("LOCATION"));
			HighUsageDetails.put("dateTimeDI", rs.getString("GPS_DATETIME"));
			}
		jsonArray.put(HighUsageDetails);
		}
			
			
		}
		catch (Exception e) {
			e.printStackTrace();
		}finally{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jsonArray;
	}
	
	public ArrayList<Object> getOffRoadAlertDetails(int offset, String alertID, int systemId,int customerId, int userId) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		ArrayList<String> headersList = new ArrayList<String>();
		ArrayList<ReportHelper> reportList = new ArrayList<ReportHelper>();
		ArrayList<Object> finalist = new ArrayList<Object>();
		ReportHelper finalReportHelper = new ReportHelper();
		JSONObject alertdetailsJSONObject = null;
		JSONArray jsonArray=new JSONArray();
		SimpleDateFormat MMddYY = new SimpleDateFormat("MM/dd/yyyy HH:mm:ss");
		int count=0;
		try {
			headersList.add("SL NO");
			headersList.add("Alert Sl No");
			headersList.add("Vehicle No");
			headersList.add("Location");
			headersList.add("Stockyard Arrival Date & Time");
			
			
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(CarRentalStatements.GET_OFFROAD_DETAIL);
			
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, customerId);
			pstmt.setInt(3, userId);
			pstmt.setInt(4, 17);
			pstmt.setInt(5, systemId);
			pstmt.setInt(6, customerId);
			pstmt.setInt(7, userId);
			pstmt.setInt(8, 17);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				count++;
				alertdetailsJSONObject = new JSONObject();
				ArrayList<Object> informationList = new ArrayList<Object>();
				ReportHelper reportHelper = new ReportHelper();
				String date="";
				String date1="";
				date = MMddYY.format(yyyymmdd.parse(rs.getString("GPS_DATETIME")));
				date1 = ddmmyyyy.format(yyyymmdd.parse(rs.getString("GPS_DATETIME")));
				if (date.substring(6, 10).equals("1900")){
					date = "";
					date1 ="";
				}
				alertdetailsJSONObject.put("slnoIndex", count);
				informationList.add(count);
				alertdetailsJSONObject.put("alertslno",rs.getString("SLNO"));
				informationList.add(rs.getString("SLNO"));
				alertdetailsJSONObject.put("vehicleNo", rs.getString("REGISTRATION_NO")!=null?rs.getString("REGISTRATION_NO"):"");
				informationList.add(rs.getString("REGISTRATION_NO")!=null?rs.getString("REGISTRATION_NO"):"");
				alertdetailsJSONObject.put("location", rs.getString("LOCATION"));
				informationList.add(rs.getString("LOCATION")!=null?rs.getString("LOCATION"):"");
				alertdetailsJSONObject.put("arrivalTime", date);
				informationList.add(date1);
				
				jsonArray.put(alertdetailsJSONObject);
			    reportHelper.setInformationList(informationList);
				reportList.add(reportHelper);
			}
			finalReportHelper.setHeadersList(headersList);
			finalReportHelper.setReportsList(reportList);
			finalist.add(jsonArray);
			finalist.add(finalReportHelper);
			
			
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return finalist;
		}
			
	
	public ArrayList<Object> getVoltageBatteryDetails(int offset, String alertID, int systemId,int customerId, int userId, String language) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		ArrayList<String> headersList = new ArrayList<String>();
		ArrayList<ReportHelper> reportList = new ArrayList<ReportHelper>();
		ArrayList<Object> finalist = new ArrayList<Object>();
		ReportHelper finalReportHelper = new ReportHelper();
		JSONObject BatteryVoltageDetails=null;
		JSONArray jsonArray=new JSONArray();
		int count=0;
		try{
			headersList.add(cf.getLabelFromDB("SLNO", language));
			headersList.add(cf.getLabelFromDB("Vehicle_No", language));
			headersList.add(cf.getLabelFromDB("Battery_Voltage", language));
			headersList.add(cf.getLabelFromDB("Location", language));
			headersList.add(cf.getLabelFromDB("Driver_Name", language));
			headersList.add(cf.getLabelFromDB("Driver_Mobile_No", language));
			
		con = DBConnection.getConnectionToDB("AMS");	
		pstmt=con.prepareStatement(CarRentalStatements.GET_VOLTAGE_DRAIN_DETAILS);
		pstmt.setInt(1, systemId);
		pstmt.setInt(2, customerId);
		pstmt.setInt(3, userId);
		rs=pstmt.executeQuery();
		while(rs.next())
		{
			BatteryVoltageDetails = new JSONObject();
			ArrayList<Object> informationList = new ArrayList<Object>();
			ReportHelper reportHelper = new ReportHelper();
			
			
			BatteryVoltageDetails.put("slnoIndex", ++count);
			informationList.add(count);
			BatteryVoltageDetails.put("vehicleNoDI", rs.getString("REGISTRATION_NO"));
			informationList.add(rs.getString("REGISTRATION_NO"));
			BatteryVoltageDetails.put("batteryVoltageDI", Dformatter.format(rs.getDouble("VOLTAGE")));
			informationList.add(Dformatter.format(rs.getDouble("VOLTAGE")));
			BatteryVoltageDetails.put("locationDI", rs.getString("LOCATION"));
			informationList.add(rs.getString("LOCATION"));
			BatteryVoltageDetails.put("drivernamerDI", rs.getString("DRIVER_NAME"));
			informationList.add(rs.getString("DRIVER_NAME"));
			BatteryVoltageDetails.put("drivernumberDI", rs.getString("DRIVER_MOBILE"));
			informationList.add(rs.getString("DRIVER_MOBILE"));
			
			
		    jsonArray.put(BatteryVoltageDetails);
		    reportHelper.setInformationList(informationList);
			reportList.add(reportHelper);
		}
		finalReportHelper.setHeadersList(headersList);
		finalReportHelper.setReportsList(reportList);
		finalist.add(jsonArray);
		finalist.add(finalReportHelper);
			
		}
		catch (Exception e) {
			e.printStackTrace();
		}finally{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return finalist;
	}
	
	public JSONArray getUndermaintanceDetails(int clientId, int systemId,int userId,String zone) {
		JSONArray JsonArray = new JSONArray();
		JSONObject JsonObject = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;	
		PreparedStatement pstmt1 = null;
		ResultSet rs = null;	
		ResultSet rs1 = null;
		int count=0;
		String hubIds=null;
		StringBuffer sb= new StringBuffer();
		try {
			JsonArray = new JSONArray();
			JsonObject = new JSONObject();
			con = DBConnection.getConnectionToDB("AMS");
			pstmt1 = con.prepareStatement(cf.getLocationQuery(CarRentalStatements.GET_UNDER_MAINTANCE_COUNT, zone));
			rs=null;
			pstmt1.setInt(1, systemId);
			pstmt1.setInt(2, clientId);
			rs1 = pstmt1.executeQuery();
			while (rs1.next()) {			
				String hubId = rs1.getString("HUBID");
				sb.append(hubId+",");
			}
			if(hubIds!=null){
			hubIds=sb.substring(0,sb.length()-1);
			}
			pstmt = con.prepareStatement(" select isnull(dm.Fullname,'') as DRIVER_NAME,a.REGISTRATION_NO,a.LOCATION,a.ACTUAL_ARRIVAL from AMS.dbo.HUB_REPORT a " +
					" inner join AMS.dbo.VEHICLE_CLIENT b on b.SYSTEM_ID=a.SYSTEM_ID and a.REGISTRATION_NO=b.REGISTRATION_NUMBER " +
					" inner join AMS.dbo.Vehicle_User c on c.System_id=a.SYSTEM_ID and c.Registration_no=a.REGISTRATION_NO " +
					" left outer join AMS.dbo.Driver_Master dm on a.DRIVER_ID=dm.Driver_id and dm.System_id=a.SYSTEM_ID " +
					" where a.SYSTEM_ID=? and b.CLIENT_ID=? and c.User_id=? and ACTUAL_ARRIVAL<dateadd(hh,-48,getutcdate()) " + 
					" and ACTUAL_DEPARTURE is null  " +
					" and HUB_ID in ("+hubIds+ ")" +
				    " group by REGISTRATION_NO,LOCATION,ACTUAL_ARRIVAL,dm.Fullname " );
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, clientId);
			pstmt.setInt(3, userId);
			rs=pstmt.executeQuery();
			while(rs.next())
			{
				count++;
				JsonObject = new JSONObject();
				JsonObject.put("alertslno", count);
				JsonObject.put("regNoDataIndex", rs.getString("REGISTRATION_NO"));
				JsonObject.put("locationDataIndex", rs.getString("LOCATION"));
				JsonObject.put("arrivalDataIndex", rs.getString("ACTUAL_ARRIVAL"));
				JsonObject.put("driverName", rs.getString("DRIVER_NAME"));
				JsonArray.put(JsonObject);
			}
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			DBConnection.releaseConnectionToDB(null, pstmt1, rs1);
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return JsonArray ;
	}

	public JSONArray getStateWiseStatutoryCount(String alertId,String customerId,int systemId,int offset)
	{

		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String state="";
		String alertcount="";
		JSONArray statutorystateJSONArray=new JSONArray();
		JSONObject statutorystateJSONObject;
		try {
			con = DBConnection.getDashboardConnection("AMS");
			if(alertId.equals("142") || alertId.equals("143")){
				pstmt = con.prepareStatement(CarRentalStatements.GET_STATUTORY_STATEWISE_COUNT_FOR_STATE_TAX);
			}else{
			    pstmt = con.prepareStatement(CarRentalStatements.GET_STATUTORY_STATEWISE_COUNT);
			}
			pstmt.setString(1, alertId);
			pstmt.setString(2, customerId);
			pstmt.setInt(3, systemId);
			pstmt.setInt(4, offset);
			rs = pstmt.executeQuery();
			while(rs.next()) {	
			statutorystateJSONObject=new JSONObject();
			state=rs.getString("STATE_NAME");
			alertcount=rs.getString("STATUTORY_COUNT");
			statutorystateJSONObject.put("state", state);
			statutorystateJSONObject.put("count",alertcount);
			statutorystateJSONArray.put(statutorystateJSONObject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}

		return statutorystateJSONArray;
		
	}
	public JSONArray getStateWiseStatutoryDetails(String typeofalert,
			String state,int offset,String clientId, int systemId) {
		Connection con = null;
		PreparedStatement pstmt = null;
		PreparedStatement pstmt1 = null;
		ResultSet rs = null;
		ResultSet rs1 = null;
		String vehicleNo="";
		Date alertdate=new Date();;
		String location="";
		String speed="";
		String remarks="";
		String groupname="";
		int alertslno=0;
		int driverId=0;
		JSONArray alertdetailsJSONArray=new JSONArray();
		JSONObject alertdetailsJSONObject;
		try {
			con = DBConnection.getConnectionToDB("AMS");
			if(!typeofalert.equals("142") && !typeofalert.equals("143")){
			if(state.equalsIgnoreCase("Other"))
			{
			pstmt = con.prepareStatement(CarRentalStatements.GET_STATUTORRY_STATEWISE_DETAILS_OTHERS);
			pstmt.setInt(1, offset);
			pstmt.setInt(2, Integer.parseInt(clientId));
			pstmt.setInt(3, systemId);
			pstmt.setInt(4, offset);
			pstmt.setInt(5, Integer.parseInt(typeofalert));
			//pstmt.setInt(6, offset);
			//pstmt.setInt(7, Integer.parseInt(clientId));
			//pstmt.setInt(8, systemId);
			//pstmt.setInt(9, offset);
			//pstmt.setInt(10, Integer.parseInt(typeofalert));
			}
			else
			{	
			pstmt = con.prepareStatement(CashVanManagementStatements.GET_STATUTORY_ALERT_DETAILS);
			pstmt.setInt(1, offset);
			pstmt.setInt(2, Integer.parseInt(clientId));
			pstmt.setInt(3, systemId);
			pstmt.setInt(4, offset);
			pstmt.setInt(5, Integer.parseInt(typeofalert));
			pstmt.setString(6, state);
			//pstmt.setInt(7, offset);
			//pstmt.setInt(8, Integer.parseInt(clientId));
			//pstmt.setInt(9, systemId);
			//pstmt.setInt(10, offset);
			//pstmt.setInt(11, Integer.parseInt(typeofalert));
			//pstmt.setString(12, state);
			}
			}else{
					pstmt = con.prepareStatement(CarRentalStatements.GET_STATUTORRY_STATEWISE_DETAILS_STATETAX);
					pstmt.setInt(1, offset);
					pstmt.setInt(2, Integer.parseInt(clientId));
					pstmt.setInt(3, systemId);
					pstmt.setInt(4, offset);
					pstmt.setInt(5, Integer.parseInt(typeofalert));
					pstmt.setString(6, state);
			}
			rs = pstmt.executeQuery();
			int count=0;
			while (rs.next()) {
				count++;
				alertdetailsJSONObject=new JSONObject();
				alertslno=rs.getInt("SLNO");
				vehicleNo=rs.getString("REGISTRATION_NO");
				alertdate=rs.getTimestamp("ALERT_DATE");
				location=rs.getString("LOCATION");
				speed=rs.getString("SPEED");
				remarks=rs.getString("REMARKS");
				driverId = rs.getInt("DRIVER NAME");
				groupname=rs.getString("GROUP_NAME");
				String driverName = "";

					if (driverId > 0) {
						pstmt1 = con.prepareStatement("select case when Mobile is not null and Mobile<>'' then Fullname+' ('+(Mobile)+')' else Fullname end as DriverName from Driver_Master where System_id=? and Driver_id=?");
						pstmt1.setInt(1, systemId);
						pstmt1.setInt(2, driverId);
						rs1 = pstmt1.executeQuery();
						if (rs1.next()) {
							driverName = rs1.getString("DriverName");
						}
					}
					if (remarks.equals("N")) {
						remarks = "";
					}
			alertdetailsJSONObject.put("alertslno", alertslno);
			alertdetailsJSONObject.put("VehicleNo", vehicleNo);
			alertdetailsJSONObject.put("groupname",groupname);
			alertdetailsJSONObject.put("alertdate",sdfyyyymmddhhmmss.format(alertdate));
			alertdetailsJSONObject.put("location",location);
			alertdetailsJSONObject.put("speed", speed);
			alertdetailsJSONObject.put("remarks",remarks);
			alertdetailsJSONObject.put("drivername",driverName);
			alertdetailsJSONArray.put(alertdetailsJSONObject);
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

	public int saveCVSRemarks(String alertslno, String remark, String regno,String date,
			String typeofalert,int offset,String clientId, int systemId) {
		Connection conAdmin=null;
		PreparedStatement pstmt=null;
		int result=0;
		ArrayList<Integer> statutoryalertList=new ArrayList<Integer>();
		String AlertDATEG = "";
		String AlertDATEP="";
		try {
			statutoryalertList.add(10);
			statutoryalertList.add(11);
			statutoryalertList.add(12);
			statutoryalertList.add(13);
			statutoryalertList.add(15);
			statutoryalertList.add(130);
			statutoryalertList.add(66);
			statutoryalertList.add(32);
			statutoryalertList.add(33);
			statutoryalertList.add(34);
			statutoryalertList.add(35);
			statutoryalertList.add(36);
			statutoryalertList.add(131);
			statutoryalertList.add(67);
			statutoryalertList.add(140);
			statutoryalertList.add(141);
			statutoryalertList.add(142);
			statutoryalertList.add(143);
			conAdmin=DBConnection.getConnectionToDB("AMS");
			if(typeofalert.equals("-5")) // Preventive Alert 
			{
				pstmt=conAdmin.prepareStatement(CashVanManagementStatements.SAVE_PREVENTIVE_REMARKS);
				pstmt.setString(1, remark);
				pstmt.setInt(2, Integer.parseInt(alertslno));
				pstmt.setString(3, regno);
				pstmt.setInt(4, Integer.parseInt(clientId));
				pstmt.setInt(5, systemId);
			}
			else if(statutoryalertList.contains(Integer.parseInt(typeofalert))) // Statuatory Alert 
			{
				pstmt=conAdmin.prepareStatement(CashVanManagementStatements.SAVE_STATUTORY_REMARKS);
				pstmt.setString(1, remark);
				pstmt.setInt(2, Integer.parseInt(alertslno));
				pstmt.setInt(3, Integer.parseInt(clientId));
				pstmt.setInt(4, systemId);
			}
			else if((Integer.parseInt(typeofalert))==2){
				pstmt = conAdmin.prepareStatement(CashVanManagementStatements.SAVE_OVERSPEED_REMARKS);
				pstmt.setString(1, remark);
				pstmt.setInt(2, Integer.parseInt(alertslno));
				pstmt.setString(3, regno);
				pstmt.setInt(4, Integer.parseInt(clientId));
				pstmt.setInt(5, systemId);
			}
			else
			{
				if (date.contains("T")) {
					date = date.substring(0, date.indexOf("T")) + " "+ date.substring(date.indexOf("T") + 1, date.length());
					AlertDATEP = getFormattedDateStartingFromMonth(date);
					AlertDATEG = cf.getLocalDateTime(AlertDATEP, offset);
					AlertDATEG = getFormattedDateStartingFromyear(AlertDATEG);
				} else {
					AlertDATEP = getFormattedDateStartingFromMonth(date);
					AlertDATEG = cf.getLocalDateTime(AlertDATEP, offset);
					AlertDATEG = getFormattedDateStartingFromyear(AlertDATEG);
				}	
			pstmt=conAdmin.prepareStatement(CashVanManagementStatements.SAVE_ALERT_REMARK);
			pstmt.setString(1, remark);
			pstmt.setString(2, AlertDATEG);
			pstmt.setString(3, regno);
			pstmt.setInt(4, Integer.parseInt(typeofalert));
			pstmt.setInt(5, Integer.parseInt(clientId));
			pstmt.setInt(6, systemId);
			}
			result=pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		}finally{
			DBConnection.releaseConnectionToDB(conAdmin, pstmt, null);
		}
		return result;
	
	}
	public String getFormattedDateStartingFromMonth(String inputDate) {
		String formattedDate = "";
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

		SimpleDateFormat sdfFormatDate = new SimpleDateFormat("MM/dd/yyyy HH:mm:ss");
		try {
			if (inputDate != null && !inputDate.equals("")) {
				java.util.Date d = sdf.parse(inputDate);
				formattedDate = sdfFormatDate.format(d);
			}
		} catch (Exception e) {
			System.out
					.println("Error in getFormattedDateStartingFromMonth() method"
							+ e);
		}
		return formattedDate;
	}

	public String getFormattedDateStartingFromyear(String inputDate) {
		String formattedDate = "";
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

		SimpleDateFormat sdfFormatDate = new SimpleDateFormat("MM/dd/yyyy HH:mm:ss");
		try {
			if (inputDate != null && !inputDate.equals("")) {
				java.util.Date d = sdfFormatDate.parse(inputDate);
				formattedDate = sdf.format(d);
			}
		} catch (Exception e) {
			System.out
					.println("Error in getFormattedDateStartingFromMonth() method"
							+ e);
		}
		return formattedDate;
	}

	public ArrayList<Object> getTripExceptionReportdetails(int systemId, int clientId,String startDate, String endDate,String language,int offset) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		PreparedStatement pstmte = null;
		ResultSet rse = null;
		JSONObject obj = null;
		JSONArray jsonArray = new JSONArray();
		ArrayList<String> headersList = new ArrayList<String>();
		ArrayList<ReportHelper> reportList = new ArrayList<ReportHelper>();
		ArrayList<Object> finalist = new ArrayList<Object>();
		ReportHelper finalReportHelper = new ReportHelper();
		double g2gDistance = 0;
		double g2gTime = 0;
		double p2pDistance = 0;
		double p2pTime = 0;
		
		try{
			headersList.add(cf.getLabelFromDB("RA_ID", language));
			headersList.add(cf.getLabelFromDB("Booking_No", language));
			headersList.add(cf.getLabelFromDB("Duty_Type", language));
			headersList.add(cf.getLabelFromDB("Asset_No", language));
			headersList.add(cf.getLabelFromDB("Driver_Name", language));
			headersList.add(cf.getLabelFromDB("Driver_Mobile_No", language));
			headersList.add(cf.getLabelFromDB("Scheduled_Pickup_Time", language));
			headersList.add(cf.getLabelFromDB("Status", language));
			headersList.add(cf.getLabelFromDB("G2G_ODO_Kms", language));
			headersList.add(cf.getLabelFromDB("G2G_GPS_Kms", language));
			headersList.add(cf.getLabelFromDB("G2G_Distance_Difference", language));
			headersList.add(cf.getLabelFromDB("G2G_Time", language)+"(HH:MM)");
			headersList.add(cf.getLabelFromDB("P2P_GPS_Kms", language));
			headersList.add(cf.getLabelFromDB("P2P_ODO_Kms", language));
			headersList.add(cf.getLabelFromDB("P2P_Kms_Difference", language));
			headersList.add(cf.getLabelFromDB("P2P_Time", language)+"(HH:MM)");
			headersList.add(cf.getLabelFromDB("Exception_Remarks", language));
			headersList.add(cf.getLabelFromDB("Vehicle_Status", language));
			headersList.add(cf.getLabelFromDB("G2G_Google_Distance", language)+"(Kms)");
			headersList.add(cf.getLabelFromDB("G2G_Google_Time", language)+"(HH:MM)");
			headersList.add(cf.getLabelFromDB("P2P_Google_Distance", language)+"(Kms)");
			headersList.add(cf.getLabelFromDB("P2P_Google_Time", language)+"(HH:MM)");

			
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(CarRentalStatements.GET_TRIP_EXCEPTION_REPORT);
			pstmt.setInt(1, offset);
			pstmt.setInt(2, systemId);
			pstmt.setInt(3, clientId);
			pstmt.setInt(4, offset);
			pstmt.setString(5, startDate.replace("T", " "));
			pstmt.setInt(6, offset);
			pstmt.setString(7, endDate.replace("T", " "));
			rs = pstmt.executeQuery();
			while(rs.next()){
				try {
					obj = new JSONObject();
					g2gDistance = 0;
					g2gTime = 0;
					p2pDistance = 0;
					p2pTime = 0;
					
					ArrayList<Object> informationList = new ArrayList<Object>();
					ReportHelper reportHelper = new ReportHelper();

					obj.put("raidDI", rs.getInt("Raid"));
					informationList.add(rs.getInt("Raid"));
					
					obj.put("bookingNoDI", rs.getInt("BookingNo"));
					informationList.add(rs.getInt("BookingNo"));
					
					obj.put("dutyTypeDI", rs.getString("DutyType"));
					informationList.add(rs.getString("DutyType"));
					
					obj.put("vehicleRegNoDI", rs.getString("RegistrationNo"));
					informationList.add(rs.getString("RegistrationNo"));
					
					obj.put("driverNameDI", rs.getString("DriverName"));
					informationList.add(rs.getString("DriverName"));
					
					if(rs.getString("MobileNo").length() == 12){
						obj.put("driverMobNoDI", rs.getString("MobileNo").substring(2, 12));
						informationList.add(rs.getString("MobileNo").substring(2, 12));
					}else{
						obj.put("driverMobNoDI", rs.getString("MobileNo"));
						informationList.add(rs.getString("MobileNo"));
					}
					if(rs.getString("scheduledPickUpTime").contains("1900")){
						obj.put("pickUpTimeDI", "");
						informationList.add("");
					}else{
						obj.put("pickUpTimeDI", rs.getString("scheduledPickUpTime"));
						informationList.add(ddmmyyyy.format(yyyymmdd.parse(rs.getString("scheduledPickUpTime"))));
					}
					obj.put("StatusDI", rs.getString("Status"));
					informationList.add(rs.getString("Status"));
					
					obj.put("g2gOdoKmsDI", Dformatter.format(rs.getDouble("g2godoKms")));
					informationList.add(Dformatter.format(rs.getDouble("g2godoKms")));
					
					obj.put("g2gGpsKmsDI", Dformatter.format(rs.getDouble("g2gGPSKms")));
					informationList.add(Dformatter.format(rs.getDouble("g2gGPSKms")));
					
					obj.put("g2gDistDiffDI", Dformatter.format(Double.parseDouble(Dformatter.format(rs.getDouble("g2godoKms"))) - Double.parseDouble(Dformatter.format(rs.getDouble("g2gGPSKms")))));
					informationList.add(Dformatter.format(Double.parseDouble(Dformatter.format(rs.getDouble("g2godoKms"))) - Double.parseDouble(Dformatter.format(rs.getDouble("g2gGPSKms")))));
					
					obj.put("g2gTimeDI", rs.getString("g2gTime"));
					informationList.add(rs.getString("g2gTime"));
					
					obj.put("p2pOdoKms", Dformatter.format(rs.getDouble("p2pOdoKms")));
					informationList.add(Dformatter.format(rs.getDouble("p2pOdoKms")));
					
					obj.put("p2pGpsKmsDI", Dformatter.format(rs.getDouble("p2pGPSKms")));
					informationList.add(Dformatter.format(rs.getDouble("p2pGPSKms")));
					
					obj.put("p2pKmsDiffDI", Dformatter.format(Double.parseDouble(Dformatter.format(rs.getDouble("p2pOdoKms"))) - Double.parseDouble(Dformatter.format(rs.getDouble("p2pGPSKms")))));
					informationList.add(Dformatter.format(Double.parseDouble(Dformatter.format(rs.getDouble("p2pOdoKms"))) - Double.parseDouble(Dformatter.format(rs.getDouble("p2pGPSKms")))));
					
					obj.put("p2pTimeDI", rs.getString("p2pTime"));
					informationList.add(rs.getString("p2pTime"));
					
					//-----------------------------------------------------------------------------
					pstmte = con.prepareStatement(CarRentalStatements.GET_JETFLEET_EXCEPTION);
					pstmte.setInt(1, systemId);
					pstmte.setInt(2, clientId);
					pstmte.setInt(3, rs.getInt("Raid"));
					pstmte.setString(4, "G2G");
					rse = pstmte.executeQuery();
					if(rse.next()) {
						obj.put("excpetionRemarksDI", "Deviation : "+rse.getString("DistExcep"));
						informationList.add("Deviation : "+rse.getString("DistExcep"));
					} else{
						obj.put("excpetionRemarksDI", "");
						informationList.add("");
					}
					
					obj.put("vehicleStatusDI", rs.getString("vehicleStatus"));
					informationList.add(rs.getString("vehicleStatus"));
					
					if(!rs.getString("GoogleJson").equals("")) {
						Gson gson = new Gson();
						GoogleApiDisAndTime googleApiDisAndTimeBean = gson.fromJson(rs.getString("GoogleJson"), GoogleApiDisAndTime.class);
						GsToTs gsToTs = googleApiDisAndTimeBean.getGsToTs();
						TsTote tsTote = googleApiDisAndTimeBean.getTsTote();
						TeToge teToge = googleApiDisAndTimeBean.getTeToge();
						
						g2gDistance = g2gDistance + Double.parseDouble(gsToTs.getGDis());
						g2gDistance = g2gDistance + Double.parseDouble(tsTote.getGDis());
						g2gDistance = g2gDistance + Double.parseDouble(teToge.getGDis());
						
						p2pDistance = p2pDistance + Double.parseDouble(tsTote.getGDis());
						
						g2gTime = g2gTime + Double.parseDouble(gsToTs.getGTime());
						g2gTime = g2gTime + Double.parseDouble(tsTote.getGTime());
						g2gTime = g2gTime + Double.parseDouble(teToge.getGTime());
						
						p2pTime = p2pTime + Double.parseDouble(tsTote.getGTime());
						
					} 
					
					obj.put("g2GGoogleDistanceDI", Double.parseDouble(Dformatter.format(g2gDistance)));
					informationList.add(Double.parseDouble(Dformatter.format(g2gDistance)));
					
					obj.put("g2GGoogleTimeDI", cf.convertMinutesToHHMMFormat((int)g2gTime));
					informationList.add(cf.convertMinutesToHHMMFormat((int)g2gTime));
					
					obj.put("p2PGoogleDistanceDI", Double.parseDouble(Dformatter.format(p2pDistance)));
					informationList.add(Double.parseDouble(Dformatter.format(p2pDistance)));
					
					obj.put("p2PGoogleTimeDI", cf.convertMinutesToHHMMFormat((int)p2pTime));
					informationList.add(cf.convertMinutesToHHMMFormat((int)p2pTime));
					
					jsonArray.put(obj);	
					reportHelper.setInformationList(informationList);
					reportList.add(reportHelper);
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
			finalReportHelper.setHeadersList(headersList);
			finalReportHelper.setReportsList(reportList);
			finalist.add(jsonArray);
			finalist.add(finalReportHelper);
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
			DBConnection.releaseConnectionToDB(null, pstmte, rse);
		}
		return finalist;
	}
	
	public ArrayList<Object> getJFTripDetailsReport(int systemId,int ClientId,String startDate, String endDate,String zone,String language,int offset) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		JSONObject obj = null;
		JSONArray jsonArray = new JSONArray();
		ArrayList<Object> finalist = new ArrayList<Object>();
		ArrayList<String> headersList = new ArrayList<String>();
		ArrayList<ReportHelper> reportList = new ArrayList<ReportHelper>();
		ReportHelper finalReportHelper = new ReportHelper();
		int count = 0;
		
		try{
			headersList.add(cf.getLabelFromDB("SLNO", language));
			headersList.add(cf.getLabelFromDB("RA_ID", language));
			headersList.add(cf.getLabelFromDB("Booking_No", language));
			headersList.add(cf.getLabelFromDB("Duty_Type", language));
			headersList.add(cf.getLabelFromDB("Asset_No", language));
			headersList.add(cf.getLabelFromDB("Driver_Name", language));
			headersList.add(cf.getLabelFromDB("Driver_Mobile_No", language));
			headersList.add(cf.getLabelFromDB("Scheduled_Pickup_Time", language));
			headersList.add(cf.getLabelFromDB("Status", language));
			headersList.add(cf.getLabelFromDB("G2G_ODO_Kms", language));
			headersList.add(cf.getLabelFromDB("G2G_GPS_Kms", language));
			headersList.add(cf.getLabelFromDB("G2G_Distance_Difference", language));
			headersList.add(cf.getLabelFromDB("G2G_Time", language)+"(HH:MM)");
			headersList.add(cf.getLabelFromDB("P2P_ODO_Kms", language));
			headersList.add(cf.getLabelFromDB("P2P_GPS_Kms", language));
			headersList.add(cf.getLabelFromDB("P2P_Kms_Difference", language));
			headersList.add(cf.getLabelFromDB("P2P_Time", language)+"(HH:MM)");
			headersList.add(cf.getLabelFromDB("Exception_Remarks", language));
			headersList.add(cf.getLabelFromDB("G_Out_Date", language));
			headersList.add(cf.getLabelFromDB("G_Out_Odometer", language));
			headersList.add(cf.getLabelFromDB("PickUp_Date", language));
			headersList.add(cf.getLabelFromDB("Pick_Odometer", language));
			headersList.add(cf.getLabelFromDB("DropUp_Date", language));
			headersList.add(cf.getLabelFromDB("Drop_Odometer", language));
			headersList.add(cf.getLabelFromDB("G_In_Date", language));
			headersList.add(cf.getLabelFromDB("G_In_Odometer", language));
			headersList.add(cf.getLabelFromDB("GS_Latitude", language));
			headersList.add(cf.getLabelFromDB("GS_Longitude", language));
			headersList.add(cf.getLabelFromDB("GS_GPS_Dist", language));
			headersList.add(cf.getLabelFromDB("TS_Latitude", language));
			headersList.add(cf.getLabelFromDB("TS_Longitude", language));
			headersList.add(cf.getLabelFromDB("TS_GPS_Dist", language));
			headersList.add(cf.getLabelFromDB("TE_Latitude", language));
			headersList.add(cf.getLabelFromDB("TE_Longitude", language));
			headersList.add(cf.getLabelFromDB("TE_GPS_Dist", language));
			headersList.add(cf.getLabelFromDB("GI_Latitude", language));
			headersList.add(cf.getLabelFromDB("GI_Longitude", language));
			headersList.add(cf.getLabelFromDB("GI_GPS_Dist", language));
			headersList.add(cf.getLabelFromDB("Feedback", language));
			headersList.add(cf.getLabelFromDB("Remarks", language));
			headersList.add(cf.getLabelFromDB("Comments", language));
			
			
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(CarRentalStatements.GET_JETFLEET_TRIP_REPORT_DETAILS);
			pstmt.setInt(1, offset);
			pstmt.setInt(2, offset);
			pstmt.setInt(3, offset);
			pstmt.setInt(4, offset);
			pstmt.setInt(5, offset);
			pstmt.setInt(6, systemId);
			pstmt.setInt(7, ClientId);
			pstmt.setInt(8, offset);
			pstmt.setString(9, startDate.replace("T", " "));
			pstmt.setInt(10, offset);
			pstmt.setString(11, endDate.replace("T", " "));
			rs = pstmt.executeQuery();
			while(rs.next()){
				count ++;
				obj = new JSONObject();
				ArrayList<Object> informationList = new ArrayList<Object>();
				ReportHelper reportHelper = new ReportHelper();
				obj.put("slnoIndex", count);
				informationList.add(count);
				
				obj.put("raidIndex", rs.getString("RA_ID"));
				informationList.add(rs.getString("RA_ID"));
				
				obj.put("bookingNoIndex", rs.getString("BOOKING_ID"));
				informationList.add(rs.getString("BOOKING_ID"));
				
				obj.put("dutyTypeIndex", rs.getString("DUTY_TYPE"));
				informationList.add(rs.getString("DUTY_TYPE"));
				
				obj.put("vehicleRegNoIndex", rs.getString("REGISTRATION_NO"));
				informationList.add(rs.getString("REGISTRATION_NO"));
				
				obj.put("driverNameIndex", rs.getString("USER_NAME"));
				informationList.add(rs.getString("USER_NAME"));
				
				obj.put("driverMobileNoIndex", rs.getString("USER_MOBILE"));
				informationList.add(rs.getString("USER_MOBILE"));
				
				if(rs.getString("SCHD_PICK_UP_DATE_TIME").contains("1900")){
					obj.put("scheduledPickUpTimeIndex", "");
					informationList.add("");
				}else{
					obj.put("scheduledPickUpTimeIndex", rs.getString("SCHD_PICK_UP_DATE_TIME"));
					informationList.add(ddmmyyyy.format(yyyymmdd.parse(rs.getString("SCHD_PICK_UP_DATE_TIME"))));
				}
				
				String STATUS=rs.getString("STATUS");
				String G2G_ODO_KMS="0";
				String G2G_GPS_KMS="0";
				String P2P_ODO_KMS="";
				String P2P_GPS_KMS="";
				String G2G_GPS_TIME="";
				String P2P_GPS_TIME="";
				String G2G_DIS_DIFFERENCE="";
				String P2P_KMS_DIFFERENCE="";
				
				obj.put("statusIndex", STATUS);
				informationList.add(STATUS);
				
				if(STATUS.equals("IN")){
					G2G_ODO_KMS=rs.getString("G2G_ODO_KMS");
					G2G_GPS_KMS=rs.getString("G2G_GPS_KMS");
					P2P_ODO_KMS=rs.getString("P2P_ODO_KMS");
					P2P_GPS_KMS=rs.getString("P2P_GPS_KMS");
					G2G_GPS_TIME=cf.convertMinutesToHHMMFormat(Integer.parseInt(rs.getString("G2G_GPS_TIME")));
					P2P_GPS_TIME=cf.convertMinutesToHHMMFormat(Integer.parseInt(rs.getString("P2P_GPS_TIME")));
					G2G_DIS_DIFFERENCE=Dformatter.format(Float.parseFloat(G2G_ODO_KMS)-Float.parseFloat(G2G_GPS_KMS));
					P2P_KMS_DIFFERENCE=Dformatter.format(Float.parseFloat(P2P_ODO_KMS)-Float.parseFloat(P2P_GPS_KMS));
				}else if(STATUS.equals("END")){
					P2P_ODO_KMS=rs.getString("P2P_ODO_KMS");
					P2P_GPS_KMS=rs.getString("P2P_GPS_KMS");
					P2P_GPS_TIME=cf.convertMinutesToHHMMFormat(Integer.parseInt(rs.getString("P2P_GPS_TIME")));
					P2P_KMS_DIFFERENCE=Dformatter.format(Float.parseFloat(P2P_ODO_KMS)-Float.parseFloat(P2P_GPS_KMS));
				}
				
				obj.put("G2G_ODO_KMS_Index", G2G_ODO_KMS);
				informationList.add(G2G_ODO_KMS);
				
				obj.put("G2G_GPS_KMS_Index", G2G_GPS_KMS);
				informationList.add(G2G_GPS_KMS);
				
				obj.put("G2G_DIS_DIFFERENCE_Index", G2G_DIS_DIFFERENCE);
				informationList.add(G2G_DIS_DIFFERENCE);
				
				obj.put("G2G_GPS_TIME_Index", G2G_GPS_TIME);
				informationList.add(G2G_GPS_TIME);

				obj.put("P2P_ODO_KMS_Index", P2P_ODO_KMS);
				informationList.add(P2P_ODO_KMS);
				
				obj.put("P2P_GPS_KMS_Index", P2P_GPS_KMS);
				informationList.add(P2P_GPS_KMS);
				
				obj.put("P2P_KMS_DIFFERENCE_Index", P2P_KMS_DIFFERENCE);
				informationList.add(P2P_KMS_DIFFERENCE);
				
				obj.put("P2P_GPS_TIME_Index", P2P_GPS_TIME);
				informationList.add(P2P_GPS_TIME);
				
				if((Float.parseFloat(G2G_ODO_KMS)-Float.parseFloat(G2G_GPS_KMS))>15 || (Float.parseFloat(G2G_ODO_KMS)-Float.parseFloat(G2G_GPS_KMS))<-15){
					obj.put("ExceptionRemarksIndex", "DEVIATED");
					informationList.add("DEVIATED");
				}else{
					obj.put("ExceptionRemarksIndex", "");
					informationList.add("");
				}
				
				if(rs.getString("ACTUAL_GARAGE_OUT_DATE_TIME").contains("1900")){
					obj.put("G_OUT_DATE_Index", "");
					informationList.add("");
				}else{
					obj.put("G_OUT_DATE_Index", rs.getString("ACTUAL_GARAGE_OUT_DATE_TIME"));
					informationList.add(ddmmyyyy.format(yyyymmdd.parse(rs.getString("ACTUAL_GARAGE_OUT_DATE_TIME"))));
				}
				
				obj.put("G_OUT_ODOMETER_Index", rs.getString("GARAGE_OUT_ODOMETER"));
				informationList.add(rs.getString("GARAGE_OUT_ODOMETER"));
				
				if(rs.getString("ACTUAL_PICK_UP_DATE_TIME").contains("1900")){
					obj.put("PICKUP_DATE_Index", "");
					informationList.add("");
				}else{
					obj.put("PICKUP_DATE_Index", rs.getString("ACTUAL_PICK_UP_DATE_TIME"));
					informationList.add(ddmmyyyy.format(yyyymmdd.parse(rs.getString("ACTUAL_PICK_UP_DATE_TIME"))));
				}
				
				obj.put("PICK_ODOMETER_Index", rs.getString("PICK_UP_ODOMETER"));
				informationList.add(rs.getString("PICK_UP_ODOMETER"));
				
				if(rs.getString("DROP_UP_DATE_TIME").contains("1900")){
					obj.put("DROP_UPDATE_Index", "");
					informationList.add("");
				}else{
					obj.put("DROP_UPDATE_Index", rs.getString("DROP_UP_DATE_TIME"));
					informationList.add(ddmmyyyy.format(yyyymmdd.parse(rs.getString("DROP_UP_DATE_TIME"))));
				}
				
				obj.put("DROP_ODOMETER_Index", rs.getString("DROP_UP_ODOMETER"));
				informationList.add(rs.getString("DROP_UP_ODOMETER"));
				
				if(rs.getString("GARAGE_IN_DATE_TIME").contains("1900")){
					obj.put("G_IN_DATE_Index", "");
					informationList.add("");
				}else{
					obj.put("G_IN_DATE_Index", rs.getString("GARAGE_IN_DATE_TIME"));
					informationList.add(ddmmyyyy.format(yyyymmdd.parse(rs.getString("GARAGE_IN_DATE_TIME"))));
				}
				
				obj.put("G_IN_ODOMETER_Index", rs.getString("GARAGE_IN_ODOMETER"));
				informationList.add(rs.getString("GARAGE_IN_ODOMETER"));
				
				if(rs.getString("GS_LATITUDE")!=null){
					obj.put("GS_LATITUDE_Index", rs.getString("GS_LATITUDE"));
					informationList.add(rs.getString("GS_LATITUDE"));
				}else{
					obj.put("GS_LATITUDE_Index", "");
					informationList.add("");
				}
				if(rs.getString("GS_LONGITUDE")!=null){
					obj.put("GS_LONGITUDE_Index", rs.getString("GS_LONGITUDE"));
					informationList.add(rs.getString("GS_LONGITUDE"));
				}else{
					obj.put("GS_LONGITUDE_Index", "");
					informationList.add("");
				}
				if(rs.getString("GS_GPS_DISTANCE")!=null){
					obj.put("GPS_DIS_GS_Index", rs.getString("GS_GPS_DISTANCE"));
					informationList.add(rs.getString("GS_GPS_DISTANCE"));
				}else{
					obj.put("GPS_DIS_GS_Index", "");
					informationList.add("");
				}
				
				if(rs.getString("TS_LATITUDE")!=null){
					obj.put("TS_LATITUDE_Index", rs.getString("TS_LATITUDE"));
					informationList.add(rs.getString("TS_LATITUDE"));
				}else{
					obj.put("TS_LATITUDE_Index", "");
					informationList.add("");
				}
				
				if(rs.getString("TS_LONGITUDE")!=null){
					obj.put("TS_LONGITUDE_Index", rs.getString("TS_LONGITUDE"));
					informationList.add(rs.getString("TS_LONGITUDE"));
				}else{
					obj.put("TS_LONGITUDE_Index", "");
					informationList.add("");
				}
				
				if(rs.getString("TS_GPS_DISTANCE")!=null){
					obj.put("GPS_DIS_TS_Index", rs.getString("TS_GPS_DISTANCE"));
				informationList.add(rs.getString("TS_GPS_DISTANCE"));
				}else{
					obj.put("GPS_DIS_TS_Index", "");
					informationList.add("");
				}
				
				if(rs.getString("TE_LATITUDE")!=null){
					obj.put("TE_LATITUDE_Index", rs.getString("TE_LATITUDE"));
					informationList.add(rs.getString("TE_LATITUDE"));
				}else{
					obj.put("TE_LATITUDE_Index", "");
					informationList.add("");
				}
				
				if(rs.getString("TE_LONGITUDE")!=null){
					obj.put("TE_LONGITUDE_Index", rs.getString("TE_LONGITUDE"));
					informationList.add(rs.getString("TE_LONGITUDE"));
				}else{
					obj.put("TE_LONGITUDE_Index", "");
					informationList.add("");
				}
				if(rs.getString("TE_GPS_DISTANCE")!=null){
					obj.put("GPS_DIS_TE_Index", rs.getString("TE_GPS_DISTANCE"));
					informationList.add(rs.getString("TE_GPS_DISTANCE"));
				}else{
					obj.put("GPS_DIS_TE_Index", "");
					informationList.add("");
				}
				
				if(rs.getString("GI_LATITUDE")!=null){
					obj.put("GI_LATITUDE_Index", rs.getString("GI_LATITUDE"));
					informationList.add(rs.getString("GI_LATITUDE"));
				}else{
					obj.put("GI_LATITUDE_Index", "");
					informationList.add("");
				}
				
				if(rs.getString("GI_LONGITUDE")!=null){
					obj.put("GI_LONGITUDE_Index", rs.getString("GI_LONGITUDE"));
					informationList.add(rs.getString("GI_LONGITUDE"));
				}else{
					obj.put("GI_LONGITUDE_Index", "");
					informationList.add("");
				}
				
				if(rs.getString("GI_GPS_DISTANCE")!=null){
					obj.put("GPS_DIS_GI_Index", rs.getString("GI_GPS_DISTANCE"));
					informationList.add(rs.getString("GI_GPS_DISTANCE"));
				}else{
					obj.put("GPS_DIS_GI_Index", "");
					informationList.add("");
				}
				
				obj.put("feedbackIndex", rs.getString("FEEDBACK"));
				informationList.add(rs.getString("FEEDBACK"));
				
				obj.put("remarkIndex", rs.getString("REMARK"));
				informationList.add(rs.getString("REMARK"));

				obj.put("commentIndex", rs.getString("COMMENTS"));
				informationList.add(rs.getString("COMMENTS"));
				
				jsonArray.put(obj);
				reportHelper.setInformationList(informationList);
				reportList.add(reportHelper);
			}
			finalReportHelper.setHeadersList(headersList);
			finalReportHelper.setReportsList(reportList);
			finalist.add(jsonArray);
			finalist.add(finalReportHelper);
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return finalist;
	} 
	public JSONArray getDeviceBateryAlertDetails(int offset, int systemId,int clientId,String type) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String vehicleNo = "";
		String alertDetails = "";
		JSONArray alertdetailsJSONArray = new JSONArray();
		JSONObject alertdetailsJSONObject = null;
		int alertslno=0;
		try {
			con = DBConnection.getConnectionToDB("AMS");
			if(type.equals("Actioned")){
					pstmt = con.prepareStatement((CarRentalStatements.GET_ALERT_DETAILS_DEVICE_BATERY_CONNECTION).replaceAll("REMARKS is null", "(REMARKS!='' or REMARKS is not null)"));
				}else if (type.equals("Un-Actioned")){
				    pstmt = con.prepareStatement((CarRentalStatements.GET_ALERT_DETAILS_DEVICE_BATERY_CONNECTION).replaceAll("REMARKS is null", "(REMARKS='' or REMARKS is null)"));
				}else if (type.equals("All")){
					pstmt = con.prepareStatement((CarRentalStatements.GET_ALERT_DETAILS_DEVICE_BATERY_CONNECTION).replaceAll("and REMARKS is null", ""));
				}
				pstmt.setInt(1, systemId);
				pstmt.setInt(2, clientId);
				rs = pstmt.executeQuery();
				while (rs.next()) {
					alertdetailsJSONObject = new JSONObject();
					alertslno=rs.getInt("ID");
					vehicleNo = rs.getString("REGISTRATION_NO");
					alertDetails = vehicleNo  +" "+ rs.getString("LOCATION") + " On " + ddmmyyyy.format(yyyymmdd.parse(rs.getString("GPS_DATETIME")));
					alertdetailsJSONObject.put("alertdetails", alertDetails);
					alertdetailsJSONObject.put("alertslno", alertslno);
					alertdetailsJSONObject.put("vehicleNo",vehicleNo);
					alertdetailsJSONObject.put("gmt",ddmmyyyy.format(yyyymmdd.parse(rs.getString("GMT"))));
					alertdetailsJSONObject.put("Remarks",rs.getString("REMARKS"));
					alertdetailsJSONObject.put("alertType","Alert");
					alertdetailsJSONArray.put(alertdetailsJSONObject);
				}

		} catch (Exception e) {
		e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return alertdetailsJSONArray;
		}
	
	public ArrayList<Object> getDeviceWireConnectionReport(int systemId,String customerid,String startDate,String endDate,int offSet,String language) {
		JSONArray ServiceTypeJsonArray = new JSONArray();
		JSONObject ServiceTypeJsonObject = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int count=0;
		ArrayList < ReportHelper > reportsList = new ArrayList < ReportHelper > ();
		ArrayList < String > headersList = new ArrayList < String > ();
		ReportHelper finalreporthelper = new ReportHelper();
		ArrayList < Object > aslist = new ArrayList < Object > ();
		SimpleDateFormat sdf=new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
		SimpleDateFormat sdf2=new SimpleDateFormat("MM/dd/yyyy HH:mm:ss"); 
		SimpleDateFormat sdf1=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		String datetime="";
		String datetime1="";
		String updatedTime1="";
		String updatedTime="";
		
		try {
			ServiceTypeJsonArray = new JSONArray();
			ServiceTypeJsonObject = new JSONObject();
			con = DBConnection.getConnectionToDB("AMS");
			
			headersList.add(cf.getLabelFromDB("SLNO", language));
            headersList.add(cf.getLabelFromDB("Registration_No", language));
            headersList.add(cf.getLabelFromDB("Group_Name", language));
            headersList.add(cf.getLabelFromDB("Vehicle_Model", language));
            headersList.add(cf.getLabelFromDB("Event_Date_Time", language));
            headersList.add(cf.getLabelFromDB("Event_Voltage", language));
            headersList.add(cf.getLabelFromDB("Location", language));
            headersList.add(cf.getLabelFromDB("Action_Taken", language));
			headersList.add(cf.getLabelFromDB("Remarks", language));
			headersList.add(cf.getLabelFromDB("Updated_By", language));
			headersList.add(cf.getLabelFromDB("Updated_Date_Time", language));
			
			 ServiceTypeJsonObject = new JSONObject();
			 pstmt = con.prepareStatement(CarRentalStatements.GET_VEHICLE_WISE_DETAILS);
			 
			 pstmt.setInt(1, offSet);
			 pstmt.setInt(2, systemId);
			 pstmt.setString(3, customerid);
	         pstmt.setString(4, startDate);
			 pstmt.setString(5, endDate);
			 
			 rs = pstmt.executeQuery();
			     
			    while (rs.next()) {	
			    	 updatedTime = rs.getString("UPDATED_DATETIME");
			    	
			    	if(updatedTime.equals("1900-01-01 00:00:00.0")){
			    		
			    		updatedTime="";
			    	}
			    	
			    	
			    	datetime = rs.getString("GPS_DATETIME");
			    	if(!datetime.equals("")){
			    		datetime =sdf.format(sdf1.parse(rs.getString("GPS_DATETIME")));
			    		datetime1 =sdf2.format(sdf1.parse(rs.getString("GPS_DATETIME")));
			    	}
			    	
			    	
			    	
			    	int Count=++count;
			    	  ArrayList < Object >  informationList = new ArrayList < Object > ();
		        	  JSONObject  jsonObject = new JSONObject();	
		        	  String action="Yes";
		        	  
		        if(rs.getString("REMARKS").equals(""))
		        {
		        	 action="No";
		        }
		      jsonObject.put("slnoDataIndex",Count);
		  	  informationList.add(Count);
		  	  
			jsonObject.put("RegistrationDataIndex",rs.getString("REGISTRATION_NO"));
	        informationList.add(rs.getString("REGISTRATION_NO"));
	        
	        jsonObject.put("GroupnameDataIndex",rs.getString("GROUP_NAME"));
	        informationList.add(rs.getString("GROUP_NAME"));
	        
	        jsonObject.put("VehiclemodelDataIndex",rs.getString("ModelName"));
	        informationList.add(rs.getString("ModelName"));
	        
	        jsonObject.put("Eventdate&timeDataIndex",datetime1);
	        informationList.add(datetime);
	        
	        jsonObject.put("EventvoltageDataIndex",rs.getString("VOLTAGE"));
	        informationList.add(rs.getString("VOLTAGE"));
	        
	        jsonObject.put("LocationDataIndex",rs.getString("LOCATION"));
	        informationList.add(rs.getString("LOCATION"));
	        
	        jsonObject.put("ActiontakenDataIndex",action);
	        informationList.add(action);
	        
            jsonObject.put("RemarksDataIndex",rs.getString("REMARKS"));
	        informationList.add(rs.getString("REMARKS"));
	        
            jsonObject.put("UsernameDataIndex",rs.getString("UPDATED_BY"));
	        informationList.add(rs.getString("UPDATED_BY"));
	        
	        if(!rs.getString("UPDATED_DATETIME").equals("") && !rs.getString("UPDATED_DATETIME").contains("1900-01-01") && !rs.getString("UPDATED_DATETIME").equals(null)){
	    		updatedTime =sdf.format(sdf1.parse(rs.getString("UPDATED_DATETIME")));
	    		updatedTime1 =sdf2.format(sdf1.parse(rs.getString("UPDATED_DATETIME")));
	    		jsonObject.put("UpdatedtimeDataIndex",sdf2.format(sdf1.parse(rs.getString("UPDATED_DATETIME"))));
		        informationList.add(sdf.format(sdf1.parse(rs.getString("UPDATED_DATETIME"))));
	    	}else{
	    		jsonObject.put("UpdatedtimeDataIndex","");
		        informationList.add("");
	    	}
            
	        
            ServiceTypeJsonArray.put(jsonObject);
            ReportHelper reporthelper = new ReportHelper();
			reporthelper.setInformationList(informationList);
			reportsList.add(reporthelper);
	        }
	       
	        aslist.add(ServiceTypeJsonArray);
	        finalreporthelper.setReportsList(reportsList);
			finalreporthelper.setHeadersList(headersList);
			aslist.add(finalreporthelper);
		
		}
	        catch (Exception e) {
				e.printStackTrace();
			}
			finally {
				DBConnection.releaseConnectionToDB(con, pstmt, rs);
	 		}  

	return aslist;
}

	
	public int saveAlertRemarksForDevice(String alertslno, String remark, String regno, int clientId,int systemId,int userId) {
		Connection con=null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		int result=0;
		try {
			con=DBConnection.getConnectionToDB("AMS");
					pstmt = con.prepareStatement(CarRentalStatements.SAVE_DEVICE_BATERY_REMARKS);                                 
					pstmt.setString(1, remark);
					pstmt.setInt(2, userId);
					pstmt.setInt(3, Integer.parseInt(alertslno));
					pstmt.setString(4, regno);
					pstmt.setInt(5, clientId);
					pstmt.setInt(6, systemId);
			        result=pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		}finally{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return result;
	
	}
	
	public ArrayList<Object> getPowerConnectionReport(int systemId, int clientId,String startDate, String endDate,String language,int offset) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		PreparedStatement pstmte = null;
		ResultSet rse = null;
		JSONObject obj = null;
		JSONArray jsonArray = new JSONArray();
		ArrayList<String> headersList = new ArrayList<String>();
		ArrayList<ReportHelper> reportList = new ArrayList<ReportHelper>();
		ArrayList<Object> finalist = new ArrayList<Object>();
		ReportHelper finalReportHelper = new ReportHelper();
		int count=0;
		
		try{
			headersList.add(cf.getLabelFromDB("SLNO", language));
			headersList.add(cf.getLabelFromDB("Asset_No", language));
			headersList.add(cf.getLabelFromDB("Group_Name", language));
			headersList.add(cf.getLabelFromDB("Vehicle_Model", language));
			headersList.add(cf.getLabelFromDB("Power_Disconnected_Date_Time", language));
			headersList.add(cf.getLabelFromDB("Power_Disconnection_Voltage", language));
			headersList.add(cf.getLabelFromDB("Power_Disconnection_Location", language));
			headersList.add(cf.getLabelFromDB("Power_Reconnection_Date_Time", language));
			headersList.add(cf.getLabelFromDB("Power_Reconnection_Voltage", language));
			headersList.add(cf.getLabelFromDB("Power_Reconnection_Location", language));
						
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(CarRentalStatements.GET_POWER_CONNECTION_REPORT_DETAILS);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, clientId);
	        pstmt.setString(3, startDate.replace("T", " "));
			pstmt.setString(4, endDate.replace("T", " "));
			pstmt.setString(5, startDate.replace("T", " "));
			pstmt.setString(6, endDate.replace("T", " "));
			
			rs = pstmt.executeQuery();
			while(rs.next()){
				try {
					count++;
					obj = new JSONObject();
					ArrayList<Object> informationList = new ArrayList<Object>();
					ReportHelper reportHelper = new ReportHelper();
					
					obj.put("slnoDataIndex",count);
				  	informationList.add(count);

					obj.put("regNoInd", rs.getString("REG_NO"));
					informationList.add(rs.getString("REG_NO"));
					
					obj.put("groupNameInd", rs.getString("GROUP_NAME"));
					informationList.add(rs.getString("GROUP_NAME"));
					
					obj.put("vehicleModelInd", rs.getString("MODEL_NAME"));
					informationList.add(rs.getString("MODEL_NAME"));
					
					if(rs.getString("DIS_CON_TIME").contains("1900")){
						obj.put("powerDisConTimeInd", "");
						informationList.add("");
					}else{
						obj.put("powerDisConTimeInd", rs.getString("DIS_CON_TIME"));
						informationList.add(ddmmyyyy.format(yyyymmdd.parse(rs.getString("DIS_CON_TIME"))));
					}
					
					obj.put("powerDisConVoltsInd", rs.getDouble("DIS_CON_VOLTAGE"));
					informationList.add(rs.getDouble("DIS_CON_VOLTAGE"));
					
					obj.put("powerDisConLocationInd", rs.getString("DIS_CON_LOCATION"));
					informationList.add(rs.getString("DIS_CON_LOCATION"));
					
					if(rs.getString("RE_CON_TIME").contains("1900")){
						obj.put("powerReConTimeInd", "");
						informationList.add("");
					}else{
						obj.put("powerReConTimeInd", rs.getString("RE_CON_TIME"));
						informationList.add(ddmmyyyy.format(yyyymmdd.parse(rs.getString("RE_CON_TIME"))));
					}
					
					obj.put("powerReConVoltsInd", rs.getString("RE_CON_VOLTAGE"));
					informationList.add(rs.getString("RE_CON_VOLTAGE"));
					
					obj.put("powerReConLocationInd", rs.getString("RE_CON_LOCATION"));
					informationList.add(rs.getString("RE_CON_LOCATION"));
					
					jsonArray.put(obj);	
					reportHelper.setInformationList(informationList);
					reportList.add(reportHelper);
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
			finalReportHelper.setHeadersList(headersList);
			finalReportHelper.setReportsList(reportList);
			finalist.add(jsonArray);
			finalist.add(finalReportHelper);
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return finalist;
	}
	
	public ArrayList<Object> getGPSCrossBorderReport(int systemId, int customerId,String startDate, String endDate,int offset) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		PreparedStatement pstmte = null;
		ResultSet rse = null;
		JSONObject obj = null;
		JSONArray jsonArray = new JSONArray();
		ArrayList<String> headersList = new ArrayList<String>();
		ArrayList<ReportHelper> reportList = new ArrayList<ReportHelper>();
		ArrayList<Object> finalist = new ArrayList<Object>();
		ReportHelper finalReportHelper = new ReportHelper();
		int count=0;
		
		try{
			headersList.add("SLNO");
			headersList.add("Registration No");
			headersList.add("Group Name");
			headersList.add("Vehicle Model");
			headersList.add("GPS Tampered Date & Time");
			headersList.add("GPS Tampered Location");
			headersList.add("Crossed Border Date & Time");
			headersList.add("Crossed Border Location");
			headersList.add("Action Taken");
			headersList.add("User Name");
			headersList.add("Updated Time");
			
						
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(CarRentalStatements.GET_TAMPERED_CROSS_BORDER_REPORT);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, customerId);
	        pstmt.setInt(3, offset);
			pstmt.setString(4, startDate.replace("T", " "));
			pstmt.setInt(5, offset);
			pstmt.setString(6, endDate.replace("T", " "));
			
			rs = pstmt.executeQuery();
			while(rs.next()){
				try {
					count++;
					obj = new JSONObject();
					ArrayList<Object> informationList = new ArrayList<Object>();
					ReportHelper reportHelper = new ReportHelper();
					
					obj.put("slnoDataIndex",count);
				  	informationList.add(count);

					obj.put("regNoIndex", rs.getString("REGISTRATION_NO"));
					informationList.add(rs.getString("REGISTRATION_NO"));
					
					obj.put("groupNameIndex", rs.getString("GROUP_NAME"));
					informationList.add(rs.getString("GROUP_NAME"));
					
					obj.put("vehicleModelIndex", rs.getString("MODEL_NAME"));
					informationList.add(rs.getString("MODEL_NAME"));
					
					if(rs.getString("GPS_TAMPERED_DATETIME").contains("1900")){
						obj.put("gpsTamperedDateIndex", "");
						informationList.add("");
					}else{
						obj.put("gpsTamperedDateIndex", rs.getString("GPS_TAMPERED_DATETIME"));
						informationList.add(ddmmyyyy.format(yyyymmdd.parse(rs.getString("GPS_TAMPERED_DATETIME"))));
					}
					
					obj.put("gpsTamperedLocIndex", rs.getString("TAMPERED_LOCATION"));
					informationList.add(rs.getString("TAMPERED_LOCATION"));
					
					if(rs.getString("CROSS_BORDER_DATE").contains("1900")){
						obj.put("crossBorderDateIndex", "");
						informationList.add("");
					}else{
						obj.put("crossBorderDateIndex", rs.getString("CROSS_BORDER_DATE"));
						informationList.add(ddmmyyyy.format(yyyymmdd.parse(rs.getString("CROSS_BORDER_DATE"))));
					}
					
					obj.put("crossborderLocIndex", rs.getString("CROSS_BORDER_LOACTION"));
					informationList.add(rs.getString("CROSS_BORDER_LOACTION"));
					
					obj.put("actionTakenIndex", rs.getString("ACTION_TAKEN"));
					informationList.add(rs.getString("ACTION_TAKEN"));
					
					obj.put("userNameIndex", rs.getString("UPDATED_BY"));
					informationList.add(rs.getString("UPDATED_BY"));

					if(rs.getString("UPDATED_DATETIME").contains("1900")){
						obj.put("UpdatedTimeIndex", "");
						informationList.add("");
					}else{
						obj.put("UpdatedTimeIndex", rs.getString("UPDATED_DATETIME"));
						informationList.add(ddmmyyyy.format(yyyymmdd.parse(rs.getString("UPDATED_DATETIME"))));
					}
					jsonArray.put(obj);	
					reportHelper.setInformationList(informationList);
					reportList.add(reportHelper);
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
			finalReportHelper.setHeadersList(headersList);
			finalReportHelper.setReportsList(reportList);
			finalist.add(jsonArray);
			finalist.add(finalReportHelper);
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return finalist;
	}
	
public JSONArray getgroupnamesForAlert(int clientid, int systemid,int userId)
	{
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject = new JSONObject();
		Connection con=null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		try 
		{
			con = DBConnection.getConnectionToDB("AMS");
			jsonArray = new JSONArray();
			jsonObject = new JSONObject();
			pstmt = con.prepareStatement(CarRentalStatements.GET_GROUP_NAME_FOR_CLIENT);
			pstmt.setInt(1,systemid);
			pstmt.setInt(2,clientid);
			pstmt.setInt(3, userId);
			pstmt.setInt(4, systemid);
			pstmt.setInt(5, clientid);
			rs = pstmt.executeQuery();

			while (rs.next()) 
			{
				jsonObject = new JSONObject();
				jsonObject.put("groupId", rs.getString("GROUP_ID"));
				jsonObject.put("groupName", rs.getString("GROUP_NAME"));
				jsonArray.put(jsonObject);	
			}
		} 
		catch (Exception e) 
		{
			e.printStackTrace();
		} 
		finally 
		{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jsonArray;
	}
public ArrayList<Object> getCityWisereports(int custid, int systemId,String CityId,String startdate,String enddate)
{
	Connection con = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	JSONObject obj = null;
	String activestatus="";
	JSONArray jsonArray = new JSONArray();
	ArrayList < ReportHelper > reportsList = new ArrayList < ReportHelper > ();
	ArrayList < String > headersList = new ArrayList < String > ();
	ReportHelper finalreporthelper = new ReportHelper();
	ArrayList < Object > aslist = new ArrayList < Object > ();
    JSONObject jsonObject = new JSONObject();
    int count=0;
    
	
    enddate=enddate.substring(0, enddate.length()-8)+"23:59:59";
    SimpleDateFormat sdf=new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
	SimpleDateFormat sdf1=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	String datetime="";
   
     try 
	{
    	    headersList.add("SLNO");
    	    headersList.add("City");
			headersList.add("VehicleNo");
			headersList.add("Group Name");
			headersList.add("Crossed Border Date and Time");
			headersList.add("Alert Location");
			headersList.add("Returned To Border Date");
			
			con = DBConnection.getConnectionToDB("AMS");
			jsonArray = new JSONArray();
			jsonObject = new JSONObject();
			pstmt = con.prepareStatement(CarRentalStatements.GET_CITY_WISE_DATA.replace("#", CityId));
			pstmt.setInt(1,systemId);
			pstmt.setInt(2,systemId);
			pstmt.setInt(3, custid);
			pstmt.setString(4,startdate);
			pstmt.setString(5,enddate);
			pstmt.setInt(6,systemId);
			pstmt.setInt(7,systemId);
			pstmt.setInt(8,systemId);
			pstmt.setInt(9, custid);
			pstmt.setString(10,startdate);
			pstmt.setString(11,enddate);			
			rs = pstmt.executeQuery();
			
		while (rs.next()) 
		{
			count++;
			ArrayList<Object> informationList = new ArrayList<Object>();
			ReportHelper reportHelper = new ReportHelper();
			jsonObject = new JSONObject();
			
			datetime = rs.getString("GPS_DATETIME");
	    	if(!datetime.equals("")){
	    		datetime =sdf.format(sdf1.parse(rs.getString("GPS_DATETIME")));
	    		
	    	}
	    	
			jsonObject.put("slnoDataIndex",count);
			informationList.add(count);
			
			jsonObject.put("citydataindex",rs.getString("CityName"));
			informationList.add(rs.getString("CityName"));
			
			jsonObject.put("VehiclenoDataIndex",rs.getString("REGISTRATION_NO"));
			informationList.add(rs.getString("REGISTRATION_NO"));
			
			jsonObject.put("GroupnameDataIndex",rs.getString("GROUP_NAME"));
			informationList.add(rs.getString("GROUP_NAME"));
			
			jsonObject.put("crossedborderDataIndex",datetime);
			informationList.add(datetime);
			
			jsonObject.put("alertlocationDataIndex",rs.getString("LOCATION"));
			informationList.add(rs.getString("LOCATION"));
			
			if(rs.getString("ReturnStatus")==null||rs.getString("ReturnStatus").equals("1900-01-01 00:00:00")){
				activestatus="";
			}else{
				activestatus=rs.getString("ReturnStatus");
			}
			
			jsonObject.put("returnstatusetDataIndex",activestatus);
			informationList.add(activestatus);
			
			jsonArray.put(jsonObject);
            ReportHelper reporthelper = new ReportHelper();
			reporthelper.setInformationList(informationList);
			reportsList.add(reporthelper);
	        }
	       
	        aslist.add(jsonArray);
	        finalreporthelper.setReportsList(reportsList);
			finalreporthelper.setHeadersList(headersList);
			aslist.add(finalreporthelper);
		
		}
	catch (Exception e) 
	{
		e.printStackTrace();
	} 
	finally 
	{
		DBConnection.releaseConnectionToDB(con, pstmt, rs);
	}
	return aslist;
}
	public JSONArray getcitynames(int custid, int systemId)
{
	JSONArray jsonArray = new JSONArray();
	JSONObject jsonObject = new JSONObject();
	Connection con=null;
	PreparedStatement pstmt=null;
	ResultSet rs=null;
	String cityids="";
	try 
	{
		con = DBConnection.getConnectionToDB("AMS");
		jsonArray = new JSONArray();
		jsonObject = new JSONObject();
		pstmt = con.prepareStatement(CarRentalStatements.GET_CITY_NAMES);
		pstmt.setInt(1,custid);
		pstmt.setInt(2,systemId);		
		rs = pstmt.executeQuery();
		while (rs.next()) 
		{
			jsonObject = new JSONObject();
			jsonObject.put("CityId",rs.getString("CityId"));
			jsonObject.put("CityName",rs.getString("CityName"));
			cityids = cityids+rs.getString("CityId")+",";
			jsonArray.put(jsonObject);
	    }
		if (cityids.length()>0) {
			cityids=cityids.substring(0,cityids.length()-1);
		}
			jsonObject = new JSONObject();
			jsonObject.put("CityId",cityids);
			jsonObject.put("CityName","All");
			jsonArray.put(jsonObject);
		}
	catch (Exception e) 
	{
		e.printStackTrace();
	} 
	finally 
	{
		DBConnection.releaseConnectionToDB(con, pstmt, rs);
	}
	return jsonArray;
}
 

	public ArrayList<Object> getOperationSummaryReport(int cusId, int systemId,
			String cityId, String cityname, String startdate, String enddate) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		ResultSet rs1 = null;
		JSONArray jsonArray = new JSONArray();
		ArrayList<ReportHelper> reportsList = new ArrayList<ReportHelper>();
		ArrayList<String> headersList = new ArrayList<String>();
		ReportHelper finalreporthelper = new ReportHelper();
		ArrayList<Object> aslist = new ArrayList<Object>();
		int count = 0;
		
		enddate = enddate.substring(0, enddate.length() - 8) + "23:59:59";

		try {
			headersList.add("Sl No");
			headersList.add("CityName");
			headersList.add("GPS Wiring Tampered");
			headersList.add("Vehicles Not Communicating For The Whole Day");
			headersList.add("Border Crossed And Not Returned By Midnight");
			headersList.add("GPS Tampered Crossed Border");
			JSONObject jsonObject = new JSONObject();
			con = DBConnection.getConnectionToDB("AMS");
			jsonArray = new JSONArray();
			ArrayList<Object> informationList = null;
			// Getting data for CityName column....
			pstmt = con.prepareStatement(CarRentalStatements.GET_CITY_Name
					.replace("#", cityId));
			pstmt.setInt(1, cusId);
			pstmt.setInt(2, systemId);
			rs1 = pstmt.executeQuery();
			while (rs1.next()) {
				jsonObject = new JSONObject();
				String gpswiringTamper = "";
				String nonCommunicating = "";
				String crossborder = "";
				String GPStampCross = "";
				count++;
				jsonObject.put("slnoIndex", count);
				String city = rs1.getString("CityName");
				jsonObject.put("cityIndex", city);
				// Getting data for Cross Border column....
				String inloopcityid = rs1.getString("CityId");
				pstmt = con
						.prepareStatement(CarRentalStatements.GET_BORDERCROSS_DATA);
				pstmt.setInt(1, systemId);
				pstmt.setString(2, startdate);
				pstmt.setString(3, enddate);
				pstmt.setInt(4, systemId);
				pstmt.setString(5, startdate);
				pstmt.setString(6, enddate);
				pstmt.setInt(7, systemId);
				pstmt.setString(8, startdate);
				pstmt.setString(9, enddate);
				pstmt.setString(10, inloopcityid);
				pstmt.setInt(11, systemId);
				pstmt.setString(12, startdate);
				pstmt.setString(13, enddate);
				pstmt.setInt(14, systemId);
				pstmt.setString(15, startdate);
				pstmt.setString(16, enddate);
				pstmt.setInt(17, systemId);
				pstmt.setString(18, startdate);
				pstmt.setString(19, enddate);
				pstmt.setString(20, inloopcityid);
				rs = pstmt.executeQuery();
				while (rs.next()) {
					crossborder = rs
							.getString("BorderCrossedandNotreturnedbyMidnight");
					jsonObject.put("borderIndex", crossborder);
				}
				// Getting data for GPSWiringTampered column
				pstmt = con
						.prepareStatement(CarRentalStatements.GET_GPSWIRING_DATA);
				pstmt.setInt(1, systemId);
				pstmt.setString(2, startdate);
				pstmt.setString(3, enddate);
				pstmt.setInt(4, cusId);
				pstmt.setString(5, inloopcityid);
				pstmt.setInt(6, systemId);
				pstmt.setString(7, startdate);
				pstmt.setString(8, enddate);
				pstmt.setInt(9, cusId);
				pstmt.setString(10, inloopcityid);
				rs = pstmt.executeQuery();
				while (rs.next()) {
					gpswiringTamper = rs.getString("GPSWiringTampered");
					jsonObject.put("GPSIndex", gpswiringTamper);
				}
				// Getting data for GpsTamperingCrossBorderAlert column
				pstmt = con
						.prepareStatement(CarRentalStatements.GET_GPSTAMPER_DATA);
				pstmt.setInt(1, systemId);
				pstmt.setString(2, startdate);
				pstmt.setString(3, enddate);
				pstmt.setInt(4, cusId);
				pstmt.setString(5, inloopcityid);
				pstmt.setInt(6, systemId);
				pstmt.setString(7, startdate);
				pstmt.setString(8, enddate);
				pstmt.setInt(9, cusId);
				pstmt.setString(10, inloopcityid);
				rs = pstmt.executeQuery();
				while (rs.next()) {
					GPStampCross = rs.getString("GpsTamperingCrossBorderAlert");
					jsonObject.put("GPSTmpIndex", GPStampCross);
				}
				// Getting data for VehiclesNotcommunicatingforwholeday column
				pstmt = con
						.prepareStatement(CarRentalStatements.GET_VEHICLES_DATA);
				pstmt.setInt(1, systemId);
				pstmt.setString(2, startdate);
				pstmt.setInt(3, cusId);
				pstmt.setString(4, inloopcityid);
				rs = pstmt.executeQuery();
				while (rs.next()) {
					nonCommunicating = rs
							.getString("VehiclesNotcommunicatingforwholeday");
					jsonObject.put("vehiclesIndex", nonCommunicating);
				}
				informationList = new ArrayList<Object>();
				informationList.add(count);
				informationList.add(city);
				informationList.add(gpswiringTamper);
				informationList.add(nonCommunicating);
				informationList.add(crossborder);
				informationList.add(GPStampCross);
				ReportHelper reporthelper = new ReportHelper();
				reporthelper.setInformationList(informationList);
				reportsList.add(reporthelper);
				jsonArray.put(jsonObject);
				aslist.add(jsonArray);
				finalreporthelper.setReportsList(reportsList);
				finalreporthelper.setHeadersList(headersList);
				aslist.add(finalreporthelper);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return aslist;
	}
	public String addFieldTamperingDetails(int systemId,int customerId,int userId,int cityId,String reason,String vehicleNo,String resolution,String attendanceDate,String filePath) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String message = "";
		int inserted=0;
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt=con.prepareStatement(CarRentalStatements.SAVE_FIELD_TAMPERING_DETAILS);
			pstmt.setInt(1, cityId);
			pstmt.setString(2, vehicleNo);
			pstmt.setString(3, reason);
			pstmt.setString(4, resolution);
			pstmt.setString(5, attendanceDate);
			pstmt.setString(6, filePath);
			pstmt.setInt(7, systemId);
			pstmt.setInt(8, customerId);
			pstmt.setInt(9, userId);
			inserted = pstmt.executeUpdate();
			if(inserted>0){
				message="Saved Successfully";
			}else{
				message="Error while saving.";
			}
		} catch (Exception e) {
			e.printStackTrace();
		}finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return message;
	}
	public ArrayList < Object > getFieldTamperingDetails(int customerId,int systemId,int userId,String startDate,String endDate,int cityId) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs=null;
		ArrayList < ReportHelper > reportsList = new ArrayList < ReportHelper > ();
		ArrayList < String > headersList = new ArrayList < String > ();		
		ReportHelper finalreporthelper = new ReportHelper();
		ArrayList < Object > finalList = new ArrayList < Object > ();
		SimpleDateFormat diffddMMyyyyHHmmss = new SimpleDateFormat("dd-MM-yyyy");
		if(startDate.contains("T")){
			startDate=startDate.replace("T"," ");
		}
		if(endDate.contains("T")){
			endDate=endDate.replace("T"," ");
		}
		headersList.add("SLNO");
		headersList.add("City Name");
		headersList.add("Vehicle No");
		headersList.add("Vehicle Model");
		headersList.add("Attended Date");
		headersList.add("Reason For NC");
		headersList.add("Action Taken");
		
		JSONArray JsonArray = new JSONArray();
		JSONObject JsonObject = null;
		ReportHelper reporthelper = null;
		ArrayList < Object > informationList = null;
		try {
			int count = 0;
			con = DBConnection.getConnectionToDB("AMS");
			if(cityId==0){
				pstmt = con.prepareStatement(CarRentalStatements.GET_GPS_TAMPERING_DETAILS);
			}else{
				pstmt = con.prepareStatement(CarRentalStatements.GET_GPS_TAMPERING_DETAILS.concat("and tc.CityID="+cityId));
			}
			pstmt.setInt(1,systemId);
			pstmt.setInt(2, customerId);
			//pstmt.setString(4, endDate);
		    rs = pstmt.executeQuery();
		    while(rs.next()){
		    	JsonObject = new JSONObject();
		    	reporthelper = new ReportHelper();
				informationList = new ArrayList < Object > ();
				
				count++;
				JsonObject.put("slnoIndex", count);
				informationList.add(count);
				
		    	JsonObject.put("cityNameIndex",rs.getString("CityName"));
		    	informationList.add(rs.getString("CityName"));
		    	
		    	JsonObject.put("vehicleNoIndex",rs.getString("REGISTRATION_NO"));
		    	informationList.add(rs.getString("REGISTRATION_NO"));
		    	
		    	JsonObject.put("veheModelIndex",rs.getString("VEHICLE_MODEL"));
		    	informationList.add(rs.getString("VEHICLE_MODEL"));
		    	
		    	if (rs.getTimestamp("ATTENDED_DATE") == null || rs.getString("ATTENDED_DATE").equals("") || rs.getString("ATTENDED_DATE").contains("1900")) {
					JsonObject.put("attendedDateIndex", "");
					informationList.add("");
				}else{
					JsonObject.put("attendedDateIndex",diffddMMyyyyHHmmss.format(rs.getTimestamp("ATTENDED_DATE")));
					informationList.add(diffddMMyyyyHHmmss.format(rs.getTimestamp("ATTENDED_DATE")));
				}
		    	JsonObject.put("reasonIndex",rs.getString("NC_REASON"));
		    	informationList.add(rs.getString("NC_REASON"));
		    	
		    	JsonObject.put("resolutionIndex",rs.getString("ACTION_TAKEN"));
		    	informationList.add(rs.getString("ACTION_TAKEN"));
		    	
		    	JsonArray.put(JsonObject);
		    	reporthelper.setInformationList(informationList);
				reportsList.add(reporthelper);
		    }
		    finalreporthelper.setReportsList(reportsList);
			finalreporthelper.setHeadersList(headersList);
			finalList.add(JsonArray);
			finalList.add(finalreporthelper);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return finalList;
	}
	public JSONArray getCityDetails() {
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject = null;
		Connection conAdmin=null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		try {
			conAdmin=DBConnection.getConnectionToDB("AMS");
			pstmt=conAdmin.prepareStatement(CarRentalStatements.GET_CITY_DETAILS);
			rs=pstmt.executeQuery();
			while(rs.next()){
				jsonObject=new JSONObject();
				jsonObject.put("cityId", rs.getString("CITY_ID"));
				jsonObject.put("cityName", rs.getString("CITY_NAME"));
				jsonArray.put(jsonObject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		finally{
			DBConnection.releaseConnectionToDB(conAdmin, pstmt, rs);
		}
		return jsonArray;
	}
	public JSONArray getVehicleNo(int customerId,int systemId,int cityId) {
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject = null;
		Connection con=null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		SimpleDateFormat diffddMMyyyyHHmmss = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
		try {
			con=DBConnection.getConnectionToDB("AMS");
			pstmt=con.prepareStatement(CarRentalStatements.GET_VEHICLE_DETAILS);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, customerId);
			pstmt.setInt(3, cityId);
			rs=pstmt.executeQuery();
			while(rs.next()){
				jsonObject=new JSONObject();
				jsonObject.put("vehicleNo", rs.getString("REGISTRATION_NO"));
				jsonObject.put("lastCommDate", diffddMMyyyyHHmmss.format(rs.getTimestamp("LAT_COMM_TIME")));
				jsonArray.put(jsonObject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		finally{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jsonArray;
	}
	 public JSONArray getTamperedDeviceDetails(int customerId, int systemId) {
     JSONArray JsonArray = new JSONArray();
     JSONObject JsonObject = null;
     Connection con = null;
     PreparedStatement pstmt = null;
     ResultSet rs = null;
     try {
         int count = 0;
         con = DBConnection.getConnectionToDB("AMS");
         pstmt = con.prepareStatement(CarRentalStatements.GET_CITYWISE_COUNT);
         pstmt.setInt(1, systemId);
		 pstmt.setInt(2, customerId);
         rs=pstmt.executeQuery();
         while (rs.next()) {
             JsonObject = new JSONObject();
             count++;
             JsonObject.put("slnoIndex", count);
             JsonObject.put("cityNameIndex", rs.getString("CityName"));
             JsonObject.put("countIndex", rs.getString("COUNT"));
             JsonObject.put("cityIdIndex", rs.getString("CityID"));
             JsonArray.put(JsonObject);
         }
     } catch (Exception e) {
         e.printStackTrace();
     } finally {
         DBConnection.releaseConnectionToDB(con, pstmt, rs);
     }
     return JsonArray;
 }
	 public JSONArray getNonCommunicationAlertCount(int systemId,int customerId, int userId, int offset) {
			Connection conAdmin = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			JSONObject alertcountObject=null;
			JSONArray alertcountArray=new JSONArray();
			int simRelatedCount = 0;
			int ncMoreThan48hrsCount = 0;
			int insideYardCount = 0;
			int onRoadCount = 0;
			int tamperingCount = 0;
			StringBuffer sb=new StringBuffer();
			String regList="";
			try {
				final long startTime = System.currentTimeMillis();
				conAdmin = DBConnection.getConnectionToDB("AMS");
				
				//*****************count for non communicating >48 hrs******************
				pstmt = conAdmin.prepareStatement(CarRentalStatements.GET_NC_MORE_THAN_48_HRS_COUNT);
				pstmt.setInt(1, systemId);
				pstmt.setInt(2,customerId);
				pstmt.setInt(3, userId);
				rs = pstmt.executeQuery();
				int count=0;
				int a=0;
				while(rs.next()){
					ncMoreThan48hrsCount = rs.getInt("NON_COMMUNICATING");			
					System.out.println(ncMoreThan48hrsCount);
				}
				rs.close();
				pstmt.close(); 
				
				//************************count for inside yard vehicles*************************
				pstmt = conAdmin.prepareStatement(CarRentalStatements.GET_INSIDE_YARD_COUNT);
				pstmt.setInt(1, systemId);
				pstmt.setInt(2,customerId);
				pstmt.setInt(3, userId);
				rs = pstmt.executeQuery();
				count=0;
				StringBuffer sb2=new StringBuffer();
				int b=0;
				a=0;
				while (rs.next()) {
					
					count++;
					insideYardCount=count;
					String vehicleNo1 = rs.getString("YARD_VEHICLES");			
					
				    if(a==0){
				    	sb.append("'"+vehicleNo1+"'");
				    	a=1;
				    }else{
				    	 sb.append(",'"+vehicleNo1+"'");
				    }
				    if(b==0){
				    	sb2.append("'"+vehicleNo1+"'");
				    	b=1;
				    }else{
				    	 sb2.append(",'"+vehicleNo1+"'");
				    }
				}
				regList=sb.toString();
				
				if(regList.equals("")){
					 regList="''";
				}
				String insideVehList=sb2.toString();
				if(insideVehList.equals("")){
					insideVehList="''";
				}
				//System.out.println("insideregList::"+insideVehList);
				rs.close();
				pstmt.close();
				//System.out.println("resg sim=="+regList);
				//**************************count for sim related issue*****************************
				pstmt = conAdmin.prepareStatement(CarRentalStatements.GET_SIM_RELATED_ISSUE_COUNT.concat(" and REGISTRATION_NO not in ("+regList+" )"));
				pstmt.setInt(1, systemId);
				pstmt.setInt(2,customerId);
				pstmt.setInt(3, userId);
				rs = pstmt.executeQuery();
				count=0;
				sb2=new StringBuffer("");
				b=0;a=0;
				while (rs.next()) {
					count++;
					simRelatedCount=count;
					String vehicleNo1 = rs.getString("SPEED_COUNT");			
					if(a==0){
				    	sb.append("'"+vehicleNo1+"'");
				    	a=1;
				    }else{
				    	 sb.append(",'"+vehicleNo1+"'");
				    }
					if(b==0){
				    	sb2.append("'"+vehicleNo1+"'");
				    	b=1;
				    }else{
				    	 sb2.append(",'"+vehicleNo1+"'");
				    }
				}
				regList=sb.toString();
				if(regList.equals("")){
					 regList="''";
				}
				String simVehList=sb2.toString();
				if(simVehList.equals("")){
					simVehList="''";
				}
				//System.out.println("simVehList::"+simVehList);
				rs.close();
				pstmt.close();
				
				//************************count for suspected tampering ***********************
				pstmt = conAdmin.prepareStatement(CarRentalStatements.GET_SUSPECTED_TAMPERING_COUNT.concat(" and g.REGISTRATION_NO not in ("+regList+" )"));
				pstmt.setInt(1, systemId);
				pstmt.setInt(2, customerId);
				pstmt.setInt(3, userId);
				
				rs = pstmt.executeQuery();
				count=0;
				sb2=new StringBuffer("");
				b=0;a=0;
				while (rs.next()) {
					count++;
					tamperingCount=count;
					String vehicleNo1 = rs.getString("ALERT_COUNT");			
					if(a==0){
				    	sb.append("'"+vehicleNo1+"'");
				    	a=1;
				    }else{
				    	 sb.append(",'"+vehicleNo1+"'");
				    }
					if(b==0){
				    	sb2.append("'"+vehicleNo1+"'");
				    	b=1;
				    }else{
				    	 sb2.append(",'"+vehicleNo1+"'");
				    }
				}
				regList=sb.toString();
				if(regList.equals("")){
					 regList="''";
				}
				String tamperingVehList=sb2.toString();
				if(tamperingVehList.equals("")){
					tamperingVehList="''";
				}
				//System.out.println("tamperingVehList::"+tamperingVehList);
				rs.close();
				pstmt.close();
				
				//*******************************count for on road vehicles*************************************
				pstmt = conAdmin.prepareStatement(CarRentalStatements.GET_ON_ROAD_VEHICLE_COUNT.concat(" and REGISTRATION_NO not in ("+regList+" )"));
				pstmt.setInt(1, systemId);
				pstmt.setInt(2,customerId);
				pstmt.setInt(3, userId);
				rs = pstmt.executeQuery();
				count=0;
				sb2=new StringBuffer("");
				b=0;a=0;
				while (rs.next()) {
					count++;
					onRoadCount=count;
					String vehicleNo1 = rs.getString("ON_ROAD_COUNT");			
					if(b==0){
				    	sb2.append("'"+vehicleNo1+"'");
				    	b=1;
				    }else{
				    	 sb2.append(",'"+vehicleNo1+"'");
				    }
					
				}
				String onRoadVehList=sb2.toString();
				if(onRoadVehList.equals("")){
					onRoadVehList="''";
				}
				//System.out.println("onRoadVehList::"+onRoadVehList);
				
					alertcountObject=new JSONObject();
					alertcountObject.put("suspectedSIMCount", simRelatedCount);
					alertcountObject.put("insideYardCount", insideYardCount);
					alertcountObject.put("onRoadCount", onRoadCount);
					alertcountObject.put("nonComm48HrsCount", ncMoreThan48hrsCount);
					alertcountObject.put("suspectedTamperingCount", tamperingCount);
					alertcountObject.put("insideYardVehicle", insideVehList);
					alertcountObject.put("simRelatedVehicle", simVehList);
					alertcountObject.put("tamperingVehicle", tamperingVehList);
					alertcountObject.put("onRoadVehicle", onRoadVehList);
					
					alertcountArray.put(alertcountObject);
					
				//final long endTime = System.currentTimeMillis();
				
				//System.out.println("-Total execution time: " + (endTime - startTime)/1000 );
			} catch (Exception e) {
				e.printStackTrace();
			} finally {
				DBConnection.releaseConnectionToDB(conAdmin, pstmt, rs);
			}
			return alertcountArray;
		}
		
		public JSONArray getNonCommunicationAlertDetails(int offset, String alertID, int systemId,int customerId, int userId,String regNo) {
			Connection con = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;
	        int alertId;
	        int count = 0;
			JSONArray alertdetailsJSONArray = new JSONArray();
			JSONObject alertdetailsJSONObject = null;
			SimpleDateFormat diffddMMyyyyHHmmss = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
			try {
				con = DBConnection.getConnectionToDB("AMS");
				alertId = Integer.parseInt(alertID);
				
				if(alertId == 1){
					pstmt = con.prepareStatement(CarRentalStatements.GET_NON_COMMUNICATING_DETAILS);
					
					pstmt.setInt(1, systemId);
					pstmt.setInt(2, customerId);
					pstmt.setInt(3, userId);
					
					rs = pstmt.executeQuery();
				}
				else if (alertId == 2) {
					pstmt = con.prepareStatement(CarRentalStatements.GET_INSIDE_YARD_VEHICLE_DETAILS.concat("and g.REGISTRATION_NO in ("+regNo+" )"));
					
					pstmt.setInt(1, systemId);
					pstmt.setInt(2, customerId);
					pstmt.setInt(3, userId);
					
					rs = pstmt.executeQuery();
				}
				else if (alertId == 3) {
					
					pstmt = con.prepareStatement(CarRentalStatements.GET_SIM_RELATED_ISSUE_DETAILS.concat("and g.REGISTRATION_NO in ("+regNo+" )"));
					pstmt.setInt(1, systemId);
					pstmt.setInt(2, customerId);
					pstmt.setInt(3, userId);
					rs = pstmt.executeQuery(); 
				}
				else if (alertId == 4) {
					pstmt = con.prepareStatement(CarRentalStatements.GET_SUSPECTED_TAMPERING_DETAILS.concat("and g.REGISTRATION_NO in ("+regNo+" )"));
					
					pstmt.setInt(1, systemId);
					pstmt.setInt(2, customerId);
					pstmt.setInt(3, userId);
					
					rs = pstmt.executeQuery();
					
				}
				else if (alertId == 5) {
					
					pstmt = con.prepareStatement(CarRentalStatements.GET_ON_ROAD_VEHICLE_DETAILS.concat("and g.REGISTRATION_NO in ("+regNo+" )"));
					
					pstmt.setInt(1, systemId);
					pstmt.setInt(2, customerId);
					pstmt.setInt(3, userId);
					rs = pstmt.executeQuery();
				}
				else if(alertId == 6){
					pstmt = con.prepareStatement(CarRentalStatements.GET_PROACTIVE_DETAILS);
					
					pstmt.setInt(1, systemId);
					pstmt.setInt(2, customerId);
					pstmt.setInt(3, customerId);
					pstmt.setInt(4, userId);
					rs = pstmt.executeQuery();
				}
					while (rs.next()) {
						alertdetailsJSONObject = new JSONObject();
						count++;
						alertdetailsJSONObject.put("alertslno", count);
						alertdetailsJSONObject.put("vehicleNoIndex",rs.getString("REGISTRATION_NO"));
						alertdetailsJSONObject.put("locationIndex",rs.getString("LOCATION"));
						alertdetailsJSONObject.put("groupNameIndex",rs.getString("GROUP_NAME"));
						alertdetailsJSONObject.put("dateTimeIndex",rs.getString("GMT"));
						alertdetailsJSONObject.put("cityIndex",rs.getString("CityName"));
						alertdetailsJSONObject.put("speedIndex",rs.getString("SPEED")+" km/h");
						if(alertId==4){
							alertdetailsJSONObject.put("gpsTamperingdateIndex",diffddMMyyyyHHmmss.format(rs.getTimestamp(("GPS_TAMPERED_DATE"))));
							alertdetailsJSONObject.put("gpsTamperingLocationIndex",rs.getString("GPS_TAMPERED_LOC"));
						}else{
							alertdetailsJSONObject.put("gpsTamperingdateIndex","");
							alertdetailsJSONObject.put("gpsTamperingLocationIndex","");
						}
						if(rs.getInt("IGNITION")==0){
							alertdetailsJSONObject.put("ignaionIndex","OFF");
						}else if(rs.getInt("IGNITION")==1){
							alertdetailsJSONObject.put("ignaionIndex","ON");
						}
						alertdetailsJSONArray.put(alertdetailsJSONObject);
					}
			} catch (Exception e) {
				e.printStackTrace();
			} finally {
				DBConnection.releaseConnectionToDB(con, pstmt, rs);
			}
			return alertdetailsJSONArray;
		}
}

