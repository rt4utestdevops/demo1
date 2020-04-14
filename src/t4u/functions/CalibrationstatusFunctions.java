package t4u.functions;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;

import org.json.JSONArray;
import org.json.JSONObject;

import t4u.beans.ReportHelper;
import t4u.common.DBConnection;
import t4u.statements.CalibrationStatements;

public class CalibrationstatusFunctions {
	
	SimpleDateFormat ddMMyyyyHHmmss = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
	CommonFunctions cf = new CommonFunctions();

	public ArrayList<Object> getCalibrationDetails(int clientId, int systemid, int offset, String language) {
		
		JSONArray JsonArray = new JSONArray();
		JSONObject JsonObject = null;
		
		Connection con = null;
		PreparedStatement pstmt = null;
		PreparedStatement pstmt1 = null;
		ResultSet rs = null;
		ResultSet rs1 = null;

		ArrayList<ReportHelper> reportsList = new ArrayList<ReportHelper>();
		ArrayList<String> headersList = new ArrayList<String>();
		ReportHelper finalreporthelper = new ReportHelper();
		ArrayList<Object> finlist = new ArrayList<Object>();
		
		try {
			int count = 0;			
						
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(CalibrationStatements.GET_CALIBRATION_DETAILS);
			pstmt.setInt(1, offset);
			pstmt.setInt(2, offset);
			pstmt.setInt(3, systemid);
			pstmt.setInt(4, clientId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				JsonObject = new JSONObject();
				
				ArrayList<Object> informationList = new ArrayList<Object>();
				ReportHelper reporthelper = new ReportHelper();
				
				boolean approvedStatusFlag = false;
				String approved = "";
				pstmt1 = con.prepareStatement(CalibrationStatements.APPROVED_STATUS);
				pstmt1.setString(1, rs.getString("VehicleNo"));
				pstmt1.setInt(2, systemid);
				pstmt1.setInt(3, clientId);
				rs1 = pstmt1.executeQuery();
				while (rs1.next()) {
					if (rs1.getInt("APPROVE_STATUS") != -1) {
						approvedStatusFlag = true;
						break;
					}
				}
				if (approvedStatusFlag == true) {
					approved = "Approved";
				}
				
				count++;
				informationList.add(Integer.toString(count));
				JsonObject.put("slnoIndex", Integer.toString(count));
				
				JsonObject.put("UIDDataIndex", rs.getInt("SLNO"));
				informationList.add(rs.getInt("SLNO"));
				
				JsonObject.put("VehicleNo", rs.getString("VehicleNo"));
				informationList.add(rs.getString("VehicleNo"));
				
				JsonObject.put("Minimumfuel", rs.getDouble("FuelWhenTankIsEmpty"));
				informationList.add(rs.getDouble("FuelWhenTankIsEmpty"));
				
				JsonObject.put("VoltageMinimumfuel", rs.getDouble("VoltageWhenTankIsEmpty"));
				informationList.add(rs.getDouble("VoltageWhenTankIsEmpty"));
				
				JsonObject.put("MaximumFuel", rs.getDouble("FuelWhenTankIsFull"));
				informationList.add(rs.getDouble("FuelWhenTankIsFull"));
				
				JsonObject.put("VoltageMaximumfuel", rs.getDouble("VoltageWhenTankIsFull"));
				informationList.add(rs.getDouble("VoltageWhenTankIsFull"));
				
				JsonObject.put("MinMileage", rs.getDouble("ApproxMileageMin"));
				informationList.add(rs.getDouble("ApproxMileageMin"));
				
				JsonObject.put("MaxMileage", rs.getDouble("ApproxMileageMax"));
				informationList.add(rs.getDouble("ApproxMileageMax"));
				
				if (rs.getString("CALIBRATION_DATE") == null || rs.getString("CALIBRATION_DATE").equals("") || rs.getString("CALIBRATION_DATE").contains("1900")) {
					JsonObject.put("Calibrationdate", "");
					informationList.add("");
				} else {
					JsonObject.put("Calibrationdate", ddMMyyyyHHmmss.format(rs.getTimestamp("CALIBRATION_DATE")));
					informationList.add(ddMMyyyyHHmmss.format(rs.getTimestamp("CALIBRATION_DATE")));
				}
				JsonObject.put("Calibratedby", rs.getString("CALIBRATED_BY"));
				informationList.add(rs.getString("CALIBRATED_BY"));
				
				JsonObject.put("EndCustomer", rs.getString("CUSTOMER_NAME"));
				informationList.add(rs.getString("CUSTOMER_NAME"));
				
				JsonObject.put("Remarks", rs.getString("REMARKS"));
				informationList.add(rs.getString("REMARKS"));
				
				if (rs.getString("Fuel_LastExeDateTime") == null || rs.getString("Fuel_LastExeDateTime").equals("") || rs.getString("Fuel_LastExeDateTime").contains("1900")) {
					JsonObject.put("Lastdate", "");
					informationList.add("");
				} else {
					JsonObject.put("Lastdate", ddMMyyyyHHmmss.format(rs.getTimestamp("Fuel_LastExeDateTime")));
					informationList.add(ddMMyyyyHHmmss.format(rs.getTimestamp("Fuel_LastExeDateTime")));
				}
				JsonObject.put("approvestatus", approved);
				informationList.add(approved);
				
				JsonObject.put("speedDataIndex", rs.getString("Speed"));
				informationList.add(rs.getString("Speed"));
				
				JsonObject.put("deltaDistanceDataIndex", rs.getFloat("DELTA_DISTANCE"));
				informationList.add(rs.getFloat("DELTA_DISTANCE"));
				
				if(rs.getInt("IGNITION")==1){
					JsonObject.put("ignitionDataIndex", "On");
				}
				else{
					JsonObject.put("ignitionDataIndex", "On/Off");
				}
				
				JsonArray.put(JsonObject);
				reporthelper.setInformationList(informationList);
				reportsList.add(reporthelper);
			}

			finlist.add(JsonArray);
			finalreporthelper.setReportsList(reportsList);
			finalreporthelper.setHeadersList(headersList);
			finlist.add(finalreporthelper);

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
			DBConnection.releaseConnectionToDB(null, pstmt1, rs1);
		}
		return finlist;
	}

	public String insertCalibrationInformation(String VehicleNo,Double Minimumfuel, Double VoltageMinimumfuel, Double MaximumFuel,Double VoltageMaximumfuel, String MinMileage, String MaxMileage,
			int offset, int clientIdint, int systemId, int speed, Double M_cof,Double C_cof, String lastdate, String Calibrationdate,String Calibratedby, String EndCustomer, String Remarks,
			int createdby, String fuelConstantFactor, String fuelVoltJson,String ignition ,float deltaDistance) {
		Connection con = null;
		PreparedStatement pstmt = null,pstmt1 = null;
		String message = "";
		SimpleDateFormat simpleDateFormatYYYY = new SimpleDateFormat("MM/dd/yyyy HH:mm:ss");
		SimpleDateFormat simpleDateFormatddMMYY = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
		int ignitionVal;
		if(ignition.equals("On")){
			ignitionVal=1;
		}
		else{
			ignitionVal=0;
		}
		try {
			
			if (lastdate.contains("T")) {
				lastdate = lastdate.substring(0, lastdate.indexOf("T"))+ " "+ lastdate.substring(lastdate.indexOf("T") + 1,lastdate.length());
				lastdate = getFormattedDateStartingFromMonth(lastdate);
				lastdate = getLocalDateTime(lastdate, offset);
			} else {
				java.util.Date lastDate = simpleDateFormatddMMYY.parse(lastdate);
				lastdate = simpleDateFormatYYYY.format(lastDate);
				lastdate = getLocalDateTime(lastdate, offset);
			}
			
			if (Calibrationdate.contains("T")) {
				Calibrationdate = Calibrationdate.substring(0, Calibrationdate.indexOf("T"))+ " "+ Calibrationdate.substring(Calibrationdate.indexOf("T") + 1,Calibrationdate.length());
				Calibrationdate = getFormattedDateStartingFromMonth(Calibrationdate);
				Calibrationdate = getLocalDateTime(Calibrationdate, offset);
			} else {
				java.util.Date calibartndate = simpleDateFormatddMMYY.parse(Calibrationdate);
				Calibrationdate = simpleDateFormatYYYY.format(calibartndate);
				Calibrationdate = getLocalDateTime(Calibrationdate, offset);
			}
			
			JSONArray fuelVoltjson = new JSONArray(fuelVoltJson);
			JSONObject lastEmptyRec = new JSONObject();
			lastEmptyRec.put("slnoIndex", 0);
			lastEmptyRec.put("fuel", "");
			lastEmptyRec.put("voltage", "");
			fuelVoltjson.put(lastEmptyRec);
			
			con = DBConnection.getConnectionToDB("AMS");
			for (int i = 0; i < fuelVoltjson.length()-1; i++) {
				
				double mVal = 0;
				double cVal = 0;
				JSONObject currfuelVolt = fuelVoltjson.getJSONObject(i);
				if(currfuelVolt.get("fuel").equals("") || currfuelVolt.get("voltage").equals("")){
					break;
				}
				
				JSONObject nextfuelVolt = fuelVoltjson.getJSONObject(i+1);
				
				if(nextfuelVolt.get("fuel").equals("") || nextfuelVolt.get("voltage").equals("")){
					if (i>0) {
						pstmt1 = con.prepareStatement(CalibrationStatements.INSERT_FUEL_MULTI_VALUE_CALIBRATION_DETAILS);
						pstmt1.setString(1, VehicleNo);
						pstmt1.setDouble(2, currfuelVolt.getDouble("voltage"));
						pstmt1.setDouble(3, currfuelVolt.getDouble("fuel"));
						pstmt1.setDouble(4, mVal);
						pstmt1.setDouble(5, cVal);
						pstmt1.executeUpdate();
					} else {
						return "Invalid Entry!!";
					}
					break;
				}
				
				if((nextfuelVolt.getDouble("voltage") - currfuelVolt.getDouble("voltage")) != 0){
					mVal = (nextfuelVolt.getDouble("fuel") - currfuelVolt.getDouble("fuel"))/ (nextfuelVolt.getDouble("voltage") - currfuelVolt.getDouble("voltage"));
				}
				
				cVal = (currfuelVolt.getDouble("fuel") - mVal * currfuelVolt.getDouble("voltage"));
	            
	            pstmt1 = con.prepareStatement(CalibrationStatements.INSERT_FUEL_MULTI_VALUE_CALIBRATION_DETAILS);
	    		pstmt1.setString(1, VehicleNo);
	            pstmt1.setDouble(2, currfuelVolt.getDouble("voltage"));
	    		pstmt1.setDouble(3, currfuelVolt.getDouble("fuel"));
	    		pstmt1.setDouble(4, mVal);
	    		pstmt1.setDouble(5, cVal);
	    		pstmt1.executeUpdate();
			}
			
			pstmt = con.prepareStatement(CalibrationStatements.INSERT_CALIBRATION_DETAILS);
			pstmt.setString(1, VehicleNo);
			pstmt.setDouble(2, Minimumfuel);
			pstmt.setDouble(3, VoltageMinimumfuel);
			pstmt.setDouble(4, MaximumFuel);                     
			pstmt.setDouble(5, VoltageMaximumfuel);
			pstmt.setString(6, MinMileage);
			pstmt.setString(7, MaxMileage);
			pstmt.setInt(8, systemId);
			pstmt.setInt(9, clientIdint);
			pstmt.setDouble(10, M_cof);
			pstmt.setDouble(11, C_cof);
			pstmt.setString(12, lastdate);
			pstmt.setString(13, Calibrationdate);
			pstmt.setString(14, Calibratedby);
			pstmt.setString(15, EndCustomer);
			pstmt.setString(16, Remarks);
			pstmt.setInt(17, createdby);
			pstmt.setString(18, fuelConstantFactor);
			pstmt.setInt(19, speed);
			pstmt.setFloat(20, deltaDistance);
			pstmt.setInt(21, ignitionVal);
			int result = pstmt.executeUpdate();
			if (result > 0) {
				message = "Saved Successfully";
			} else {
				message = "error";
			}
		} catch (Exception e) {
			message = "error";
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, null);
			DBConnection.releaseConnectionToDB(null, pstmt1, null);
		}
		return message;
	}

	public String updateCalibrationInformation(String VehicleNo,Double Minimumfuel, Double VoltageMinimumfuel, Double MaximumFuel,
			Double VoltageMaximumfuel, String MinMileage, String MaxMileage,int offset, int clientIdint, int systemId, String lastdate,
			String Calibrationdate, String Calibratedby, String EndCustomer,String Remarks, int createdby, String fuelConstantFactor,
			double M_cof, double C_cof,int speed,int uid, String fuelVoltJson,String ignition,float deltaDistance) {
		Connection con = null;
		PreparedStatement pstmt = null,pstmt1 = null;
		String message = "";
		SimpleDateFormat simpleDateFormatYYYY = new SimpleDateFormat("MM/dd/yyyy HH:mm:ss");
		SimpleDateFormat simpleDateFormatddMMYY = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
		int ignitionVal;
		if(ignition.equals("On")){
			ignitionVal=1;
		}
		else{
			ignitionVal=0;
		}
		try {
			if (lastdate.contains("T")) {
				lastdate = lastdate.substring(0, lastdate.indexOf("T"))+ " "+ lastdate.substring(lastdate.indexOf("T") + 1,lastdate.length());
				lastdate = getFormattedDateStartingFromMonth(lastdate);
				lastdate = getLocalDateTime(lastdate, offset);
			} else {
				java.util.Date lastDate = simpleDateFormatddMMYY.parse(lastdate);
				lastdate = simpleDateFormatYYYY.format(lastDate);
				lastdate = getLocalDateTime(lastdate, offset);
			}
			
			if (Calibrationdate.contains("T")) {
				Calibrationdate = Calibrationdate.substring(0, Calibrationdate.indexOf("T"))+ " "+ Calibrationdate.substring(Calibrationdate.indexOf("T") + 1,Calibrationdate.length());
				Calibrationdate = getFormattedDateStartingFromMonth(Calibrationdate);
				Calibrationdate = getLocalDateTime(Calibrationdate, offset);
			} else {
				java.util.Date calibartndate = simpleDateFormatddMMYY.parse(Calibrationdate);
				Calibrationdate = simpleDateFormatYYYY.format(calibartndate);
				Calibrationdate = getLocalDateTime(Calibrationdate, offset);
			}
			
			con = DBConnection.getConnectionToDB("AMS");
			
			
			
			if (!fuelVoltJson.isEmpty()) {
				JSONArray fuelVoltjson = new JSONArray(fuelVoltJson);
				JSONObject lastEmptyRec = new JSONObject();
				lastEmptyRec.put("slnoIndex", 0);
				lastEmptyRec.put("fuel", "");
				lastEmptyRec.put("voltage", "");
				fuelVoltjson.put(lastEmptyRec);

				pstmt1 = con.prepareStatement(CalibrationStatements.MOVE_FUEL_MULTI_VALUE_CALIBRATION_DETAILS_TO_HISTORY);
				pstmt1.setString(1, VehicleNo);
				pstmt1.executeUpdate();
				
				pstmt1 = con.prepareStatement(CalibrationStatements.DELETE_FUEL_MULTI_VALUE_CALIBRATION_DETAILS);
				pstmt1.setString(1, VehicleNo);
				pstmt1.executeUpdate();
				
				for (int i = 0; i < fuelVoltjson.length() - 1; i++) {
					JSONObject currfuelVolt = fuelVoltjson.getJSONObject(i);
					double mVal = 0;
					double cVal = 0;
					if(currfuelVolt.get("fuel").equals("") || currfuelVolt.get("voltage").equals("")){
						break;
					}
					
					JSONObject nextfuelVolt = fuelVoltjson.getJSONObject(i + 1);
					if(nextfuelVolt.get("fuel").equals("") || nextfuelVolt.get("voltage").equals("")){
						if (i>0) {
							pstmt1 = con.prepareStatement(CalibrationStatements.INSERT_FUEL_MULTI_VALUE_CALIBRATION_DETAILS);
							pstmt1.setString(1, VehicleNo);
							pstmt1.setDouble(2, currfuelVolt.getDouble("voltage"));
							pstmt1.setDouble(3, currfuelVolt.getDouble("fuel"));
							pstmt1.setDouble(4, mVal);
							pstmt1.setDouble(5, cVal);
							pstmt1.executeUpdate();
						} else {
							message = "Invalid Entry!! Fuel-Voltage values Deleted";
						}
						break;
					}
					
					if((nextfuelVolt.getDouble("voltage") - currfuelVolt.getDouble("voltage")) != 0){
						mVal = (nextfuelVolt.getDouble("fuel") - currfuelVolt.getDouble("fuel"))/ (nextfuelVolt.getDouble("voltage") - currfuelVolt.getDouble("voltage"));
					}
					
					cVal = (currfuelVolt.getDouble("fuel") - mVal * currfuelVolt.getDouble("voltage"));

					pstmt1 = con.prepareStatement(CalibrationStatements.INSERT_FUEL_MULTI_VALUE_CALIBRATION_DETAILS);
					pstmt1.setString(1, VehicleNo);
					pstmt1.setDouble(2, currfuelVolt.getDouble("voltage"));
					pstmt1.setDouble(3, currfuelVolt.getDouble("fuel"));
					pstmt1.setDouble(4, mVal);
					pstmt1.setDouble(5, cVal);
					pstmt1.executeUpdate();
				}
			}
			
			pstmt = con.prepareStatement("insert into FUEL_FORMULA_VALUE_HISTORY select * from FUEL_FORMULA_VALUE where SLNO=?");
			pstmt.setInt(1, uid);
			pstmt.executeUpdate();
			
			pstmt = con.prepareStatement(CalibrationStatements.UPDATE_CALIBRATION_DETAILS);
			pstmt.setDouble(1, Minimumfuel);
			pstmt.setDouble(2, VoltageMinimumfuel);
			pstmt.setDouble(3, MaximumFuel);
			pstmt.setDouble(4, VoltageMaximumfuel);
			pstmt.setString(5, MinMileage);
			pstmt.setString(6, MaxMileage);
			pstmt.setString(7, lastdate);
			pstmt.setString(8, Calibrationdate);
			pstmt.setString(9, Calibratedby);
			pstmt.setString(10, EndCustomer);
			pstmt.setString(11, Remarks);
			pstmt.setDouble(12, M_cof);
			pstmt.setDouble(13, C_cof);
			pstmt.setInt(14, speed);
			pstmt.setFloat(15, deltaDistance);
			pstmt.setInt(16, ignitionVal);
			pstmt.setInt(17, clientIdint);
			pstmt.setInt(18, systemId);
			pstmt.setString(19, VehicleNo);
			pstmt.setInt(20, uid);
		
			int result = pstmt.executeUpdate();
			if (result > 0) {
				message = "Updated Successfully";
			} else {
				message = "error";
			}
		} catch (Exception e) {
			message = "error";
			e.printStackTrace();

		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, null);
			DBConnection.releaseConnectionToDB(null, pstmt1, null);
		}
		return message;
	}
	
	public void updateLastExeDateTime(int offset, int clientIdint,
			int systemId, String vehicleNo, String dateTime) {
		System.out.println("updateLastExeDateTime()");
		SimpleDateFormat simpleDateFormatYYYY = new SimpleDateFormat("MM/dd/yyyy HH:mm:ss");
		SimpleDateFormat simpleDateFormatddMMYY = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");

		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
	//	com.mysql.jdbc.Connection mysqlCon=null;
	//	com.mysql.jdbc.PreparedStatement pstmt1=null;
		try {
			
			if(dateTime!=null && !dateTime.equals("")) {
				if (dateTime.contains("T")) {
					dateTime = dateTime.substring(0, dateTime.indexOf("T"))
							+ " "
							+ dateTime.substring(dateTime.indexOf("T") + 1,dateTime.length());
					dateTime = getFormattedDateStartingFromMonth(dateTime);
					dateTime = getLocalDateTime(dateTime, offset);
				} else {
					java.util.Date start = simpleDateFormatddMMYY.parse(dateTime);
					dateTime = simpleDateFormatYYYY.format(start);
					dateTime = getLocalDateTime(dateTime, offset);
				}
			}
			
			con = DBConnection.getConnectionToDB("AMS");
	//		mysqlCon = DBConnection.getConnectionMysql();
			pstmt = con.prepareStatement("select * from dbo.RefuelCalculator where REGISTRATION_NO=?");
			pstmt.setString(1, vehicleNo);
			rs=pstmt.executeQuery();
			if (rs.next()) {
				pstmt = con.prepareStatement("update dbo.RefuelCalculator set Fuel_LastExeDateTime=?,LastRefuelFuelLevel=0,LastRefuelDateTime='',IsFirstTime='true' where REGISTRATION_NO=?");
				pstmt.setString(1, dateTime);
				pstmt.setString(2, vehicleNo);
				pstmt.executeUpdate();System.out.println("RefuleCalculator updated");
			} else {
				pstmt = con.prepareStatement("insert into dbo.RefuelCalculator (Fuel_LastExeDateTime,REGISTRATION_NO,IsFirstTime) values (?,?,?)");
				pstmt.setString(1, dateTime);
				pstmt.setString(2, vehicleNo);
				pstmt.setString(3, "true");
				pstmt.executeUpdate();
			}
			
			pstmt = con.prepareStatement("delete from ALERT.dbo.FUEL_INFO where REGISTRATION_NO=? and SYSTEM_ID=? and GMT>?");
			pstmt.setString(1, vehicleNo);
			pstmt.setInt(2, systemId);
			pstmt.setString(3, dateTime);
			int deleted = pstmt.executeUpdate();
			System.out.println("deleted:"+deleted);
			pstmt = con.prepareStatement("delete from dbo.REFUEL_INFO where REGISTRATION_NO=? and SYSTEM_ID=? and GMT>?");
			pstmt.setString(1, vehicleNo);
			pstmt.setInt(2, systemId);
			pstmt.setString(3, dateTime);
			deleted=pstmt.executeUpdate();
			System.out.println("deleted:"+deleted);
			
			pstmt = con.prepareStatement("update dbo.HISTORY_DATA_"+systemId+" set COMMUNICATION_CONTROL = NULL where REGISTRATION_NO=? and GMT>=?");
			pstmt.setString(1, vehicleNo);
			pstmt.setString(2, dateTime);
			pstmt.executeUpdate();
			
			pstmt = con.prepareStatement("update AMS_Archieve.dbo.GE_DATA_"+systemId+" set COMMUNICATION_CONTROL = NULL where REGISTRATION_NO=? and GMT>=?");
			pstmt.setString(1, vehicleNo);
			pstmt.setString(2, dateTime);
			pstmt.executeUpdate();
			
//			pstmt1 = (com.mysql.jdbc.PreparedStatement) mysqlCon.prepareStatement("update ams_archieve.ge_data_"+systemId+" set COMMUNICATION_CONTROL = NULL where REGISTRATION_NO=? and GMT>=?");
//			pstmt1.setString(1, vehicleNo);
//			pstmt1.setString(2, dateTime);
//			pstmt1.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		//	DBConnection.releaseConnectionToMysqlDB(mysqlCon, pstmt1, null);
		}
	}
	
	public JSONArray getVehicleNoRefuel(int clientid, int systemId, int userId) {
		
		JSONArray JsonArray = new JSONArray();
		JSONObject JsonObject = null;
		
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		try {
			pstmt = null;
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(CalibrationStatements.GET_VEHICLE_NOT_IN_REFUEL);
			pstmt.setInt(1, clientid);
			pstmt.setInt(2, systemId);
			pstmt.setInt(3, userId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				JsonObject = new JSONObject();
				JsonObject.put("vehicleno", rs.getString("REGISTRATION_NUMBER"));
				JsonObject.put("vehicleId", rs.getString("REGISTRATION_NUMBER"));
				JsonArray.put(JsonObject);
			}

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return JsonArray;
	}

	public ArrayList<Object> getMonitoringFDASDetails(String language) {

		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		JSONArray JsonArray = new JSONArray();
		JSONObject JsonObject = null;
		int count = 0;
		ArrayList<ReportHelper> reportsList = new ArrayList<ReportHelper>();
		ArrayList<String> headersList = new ArrayList<String>();
		ReportHelper finalreporthelper = new ReportHelper();
		ArrayList<Object> finlist = new ArrayList<Object>();
		try {
			headersList.add(cf.getLabelFromDB("SLNO", language));
			headersList.add(cf.getLabelFromDB("LTSP", language));
			headersList.add(cf.getLabelFromDB("Customer_Name", language));
			headersList.add(cf.getLabelFromDB("Asset_No", language));
			headersList.add(cf.getLabelFromDB("Last_Caliberated_Date", language));
			headersList.add(cf.getLabelFromDB("No_of_Refuels_Entered_in_Check_List", language));
			headersList.add(cf.getLabelFromDB("No_of_Spurious_Refuel", language));
			headersList.add(cf.getLabelFromDB("No_of_Invalid_Voltages",language));
			headersList.add(cf.getLabelFromDB("No_of_Unexpected_Refuel",language));
			headersList.add(cf.getLabelFromDB("No_of_Probable_Pilfreges",language));
			
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(CalibrationStatements.GET_MONITORING_VEHICLE_DETAILS);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				JsonObject = new JSONObject();
				ArrayList<Object> informationList = new ArrayList<Object>();
				ReportHelper reporthelper = new ReportHelper();
				count++;
				informationList.add(count);	
				JsonObject.put("slnoIndex",count);
				
				JsonObject.put("ltspnameIndex", rs.getString("LTSP"));
				informationList.add(rs.getString("LTSP"));
				
				JsonObject.put("customernameIndex", rs.getString("CUSTOMER_NAME"));
				informationList.add(rs.getString("CUSTOMER_NAME"));
				
				JsonObject.put("assetnoIndex", rs.getString("ASSET_NO"));
				informationList.add(rs.getString("ASSET_NO"));
				
				if (rs.getString("CALIBRATION_DATE") == null || rs.getString("CALIBRATION_DATE").equals("") || rs.getString("CALIBRATION_DATE").contains("1900")) {
					JsonObject.put("daysaftercaliberation", "");
					informationList.add("");
				} else {
					JsonObject.put("daysaftercaliberation", ddMMyyyyHHmmss.format(rs.getTimestamp("CALIBRATION_DATE")));
					informationList.add(ddMMyyyyHHmmss.format(rs.getTimestamp("CALIBRATION_DATE")));
				}
				JsonObject.put("noofrefulesIndex", rs.getInt("REFUEL_DETECTED"));
				informationList.add(rs.getInt("REFUEL_DETECTED"));
				
				JsonObject.put("noofspuriousrefuelIndex", rs.getInt("SPURIOUS_REFUEL"));
				informationList.add(rs.getInt("SPURIOUS_REFUEL"));
				
				JsonObject.put("noofinvalidvoltagesIndex", rs.getInt("VOLTAGE"));
				informationList.add(rs.getInt("VOLTAGE"));
				
				JsonObject.put("noofunexpectedrefuelIndex", rs.getInt("UNEXPECTED_FUEL_VARIATION"));
				informationList.add(rs.getInt("UNEXPECTED_FUEL_VARIATION"));
				
				JsonObject.put("noofprobablepilfreges", 0);
				informationList.add(0);
				
				JsonArray.put(JsonObject);
				reporthelper.setInformationList(informationList);
				reportsList.add(reporthelper);
			}
			finlist.add(JsonArray);
			finalreporthelper.setReportsList(reportsList);
			finalreporthelper.setHeadersList(headersList);
			finlist.add(finalreporthelper);

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return finlist;
	}

	public JSONArray getVehicleNumber(int systemId, int customerId) {
		JSONArray jsonArray = null;
		JSONObject jsonObject = null;

		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			jsonArray = new JSONArray();
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(CalibrationStatements.GET_VEHICLE_NUMBER);
			pstmt.setInt(1, customerId);
			pstmt.setInt(2, systemId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				jsonObject = new JSONObject();
				jsonObject.put("vehicleno", rs.getString("VehicleNo"));
				jsonArray.put(jsonObject);
			}

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jsonArray;
	}

	public JSONArray getFuelMultiValueDetails(String vehicleNo) {
		JSONArray jsonArray = null;
		JSONObject jsonObject = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			jsonArray = new JSONArray();
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(CalibrationStatements.GET_FUEL_FORMULA_MULTI_VALUE);
			pstmt.setString(1, vehicleNo);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				jsonObject = new JSONObject();
				jsonObject.put("slnoIndex", rs.getInt("ID"));
				jsonObject.put("voltage", rs.getDouble("VOLTAGE"));
				jsonObject.put("fuel", rs.getDouble("FUEL"));
				jsonArray.put(jsonObject);
			}

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jsonArray;
	}
	
	public ArrayList<Object> getrefuelDetails(String assetno, int systemid, int customerId, String language, int offset) {
		JSONArray JsonArray = new JSONArray();
		JSONObject JsonObject = null;
		
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		ArrayList<ReportHelper> reportsList = new ArrayList<ReportHelper>();
		ArrayList<String> headersList = new ArrayList<String>();
		ReportHelper finalreporthelper = new ReportHelper();
		ArrayList<Object> finlist = new ArrayList<Object>();
		try {
			int count = 0;
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(CalibrationStatements.GET_REFUEL_DETAILS);
			pstmt.setInt(1, offset);
			pstmt.setInt(2, systemid);
			pstmt.setString(3, assetno);
			pstmt.setInt(4, customerId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				JsonObject = new JSONObject();
				ArrayList<Object> informationList = new ArrayList<Object>();
				ReportHelper reporthelper = new ReportHelper();
				count++;
				
				informationList.add(count);
				JsonObject.put("slnoIndex", count);
				
				
				if (rs.getString("REFUEL_DATE") == null || rs.getString("REFUEL_DATE").equals("") || rs.getString("REFUEL_DATE").contains("1900")) {
					JsonObject.put("refueldate", "");
					informationList.add("");
				} else {
					JsonObject.put("refueldate", ddMMyyyyHHmmss.format(rs.getTimestamp("REFUEL_DATE")));
					informationList.add(ddMMyyyyHHmmss.format(rs.getTimestamp("REFUEL_DATE")));
				}
				JsonObject.put("ltrsrefueled", rs.getDouble("REFUEL"));
				informationList.add(rs.getDouble("REFUEL"));

				JsonObject.put("source", rs.getString("SOURCE"));
				informationList.add(rs.getString("SOURCE"));

				JsonObject.put("remarks1", rs.getString("REMARKS"));
				informationList.add(rs.getString("REMARKS"));

				JsonObject.put("enteredby", rs.getString("ENTERED_BY"));
				informationList.add(rs.getString("ENTERED_BY"));
				
				
				
				
				if (rs.getString("ENTERED_DATE") == null || rs.getString("ENTERED_DATE").equals("") || rs.getString("ENTERED_DATE").contains("1900")) {
					JsonObject.put("entereddate", "");
					informationList.add("");
				} else {
					JsonObject.put("entereddate", ddMMyyyyHHmmss.format(rs.getTimestamp("ENTERED_DATE")));
					informationList.add(ddMMyyyyHHmmss.format(rs.getTimestamp("ENTERED_DATE")));
				}
				
				JsonObject.put("remarks2", rs.getString("VERIFIED_REMARKS"));
				informationList.add(rs.getString("VERIFIED_REMARKS"));

				JsonObject.put("verifiedby", rs.getString("VERIFIED_BY"));
				informationList.add(rs.getString("VERIFIED_BY"));

				JsonObject.put("approveEnteredBy", rs.getString("APPROVE_ENTERED_BY"));
				informationList.add(rs.getString("APPROVE_ENTERED_BY"));

				JsonObject.put("approveRemarks", rs.getString("APPROVED_REMARKS"));
				informationList.add(rs.getString("APPROVED_REMARKS"));

				JsonObject.put("approveBy", rs.getString("APPROVED_BY"));
				informationList.add(rs.getString("APPROVED_BY"));
				
				String approvedDate = "";
				if(!rs.getString("APPROVED_DATE").contains("1900")){
					approvedDate = ddMMyyyyHHmmss.format(rs.getTimestamp("APPROVED_DATE"));
				} 
				JsonObject.put("approveDate",  approvedDate);
				informationList.add(approvedDate);
				
				JsonObject.put("refuelCounter", rs.getInt("REFUEL_COUNTER"));
				informationList.add(rs.getInt("REFUEL_COUNTER"));

				JsonObject.put("id", rs.getInt("ID"));
				informationList.add(rs.getInt("ID"));

				JsonArray.put(JsonObject);
				reporthelper.setInformationList(informationList);
				reportsList.add(reporthelper);
			}
			finlist.add(JsonArray);
			finalreporthelper.setReportsList(reportsList);
			finalreporthelper.setHeadersList(headersList);
			finlist.add(finalreporthelper);

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return finlist;
	}

	public String insertRefuelInformation(String VehicleNo, String Refuel,String Litres, String Source, String Remarks1, int systemId, int customerId, int userId, int offset) {
		Connection con = null;
		PreparedStatement pstmt = null;
		String message = "";
		try {

			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(CalibrationStatements.INSERT_REFUEL_DETAILS);
			pstmt.setString(1, VehicleNo);
			pstmt.setInt(2, offset);
			pstmt.setString(3, Refuel);
			pstmt.setString(4, Litres);
			pstmt.setString(5, Source);
			pstmt.setString(6, Remarks1);
			pstmt.setInt(7, systemId);
			pstmt.setInt(8, customerId);
			pstmt.setInt(9, userId);
			int inserted = pstmt.executeUpdate();
			if (inserted > 0) {
				message = "Saved Successfully";
				pstmt = con.prepareStatement(CalibrationStatements.UPDATE_RFUEL_COUNT_INCREMENT);
				pstmt.setString(1, VehicleNo);
				pstmt.setInt(2, systemId);
				pstmt.setInt(3, customerId);
				pstmt.executeUpdate();				
			} else {
				message = "Unable To Save " + VehicleNo + " Details";
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, null);
		}
		return message;
	}

	public String updateRefuelInformation(int id, String VehicleNo,String Refuel, String Litres, String Source, String Remarks1,int systemId, int customerId, int userId) {
		Connection con = null;
		PreparedStatement pstmt = null;
		String message = "";
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(CalibrationStatements.UPDATE_REFUEL_DETAILS);
			pstmt.setString(1, Refuel);
			pstmt.setString(2, Litres);
			pstmt.setString(3, Source);
			pstmt.setString(4, Remarks1);
			pstmt.setInt(5, userId);
			pstmt.setString(6, VehicleNo);
			pstmt.setInt(7, systemId);
			pstmt.setInt(8, customerId);
			pstmt.setInt(9, id);
			int updated = pstmt.executeUpdate();
			if (updated > 0) {
				message = "Updated Successfully";
			} else {
				message = "Unable To Update " + VehicleNo + " Details";
			}
		} catch (Exception e) {
			e.printStackTrace();

		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, null);
		}
		return message;
	}

	public String updateapproveInformation(String VehicleNo, String enteredBy,String Remark2, int systemId, int customerId, int userId) {
		Connection con = null;
		PreparedStatement pstmt = null;
		String message = "";
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(CalibrationStatements.UPDATE_APPROVE_DETAILS);
			pstmt.setInt(1, userId);
			pstmt.setString(2, Remark2);
			pstmt.setString(3, enteredBy);
			pstmt.setInt(4, systemId);
			pstmt.setInt(5, customerId);
			pstmt.setString(6, VehicleNo);
			int result = pstmt.executeUpdate();
			if (result > 0) {
				message = "Approved Successfully";
				pstmt = con.prepareStatement(CalibrationStatements.UPDATE_RFUEL_COUNT_INCREMENT_TO_ZERO);
				pstmt.setString(1, VehicleNo);
				pstmt.setInt(2, systemId);
				pstmt.setInt(3, customerId);
				pstmt.executeUpdate();
				
				pstmt = con.prepareStatement(CalibrationStatements.INSERT_HISTORY_DATA);
				pstmt.setString(1, VehicleNo);
				pstmt.setInt(2, systemId);
				pstmt.setInt(3, customerId);
				pstmt.executeUpdate();
				
			} else {
				message = "Unable To Approve " + VehicleNo + " Details";
			}
		} catch (Exception e) {
			e.printStackTrace();

		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, null);
		}
		return message;
	}

	public String updateVerifyInformation(int id, String VehicleNo,String Remarks2, int systemId, int customerId, int userId) {
		Connection con = null;
		PreparedStatement pstmt = null;
		String message = "";
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(CalibrationStatements.UPDATE_VERIFY_DETAILS);
			pstmt.setInt(1, userId);
			pstmt.setString(2, Remarks2);
			pstmt.setInt(3, systemId);
			pstmt.setInt(4, customerId);
			pstmt.setString(5, VehicleNo);
			pstmt.setInt(6, id);
			int result = pstmt.executeUpdate();
			if (result > 0) {
				message = "Verified Successfully";
			} else {
				message = "Unable To verify " + VehicleNo + " Details";
			}
		} catch (Exception e) {
			message = "Unable To verify";
			e.printStackTrace();

		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, null);
		}
		return message;
	}

	public String getFuelConstantFactorUnitType(String vehicleNo,int systemId) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String Unit_Type_Code = "0";
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(CalibrationStatements.GET_UNIT_TYPE_CODE);
			pstmt.setString(1, vehicleNo);
			pstmt.setInt(2, systemId);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				Unit_Type_Code = rs.getString("Unit_Type_Code");
			} 
		} catch (Exception e) {
			e.printStackTrace();

		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return Unit_Type_Code;
	}
	
	public String getLocalDateTime(String inputDate, int offSet) {
		String retValue = inputDate;
		Date convDate = null;
		convDate = convertStringToDate(inputDate);
		if (convDate != null) {
			Calendar cal = Calendar.getInstance();
			cal.setTime(convDate);
			cal.add(Calendar.MINUTE, -offSet);
			int day = cal.get(Calendar.DATE);
			int y = cal.get(Calendar.YEAR);
			int m = cal.get(Calendar.MONTH) + 1;
			int h = cal.get(Calendar.HOUR_OF_DAY);
			int mi = cal.get(Calendar.MINUTE);
			int s = cal.get(Calendar.SECOND);
			String yyyy = String.valueOf(y);
			String month = String.valueOf(m > 9 ? String.valueOf(m) : "0"+ String.valueOf(m));
			String date = String.valueOf(day > 9 ? String.valueOf(day) : "0"+ String.valueOf(day));
			String hour = String.valueOf(h > 9 ? String.valueOf(h) : "0"+ String.valueOf(h));
			String minute = String.valueOf(mi > 9 ? String.valueOf(mi) : "0"+ String.valueOf(mi));
			String second = String.valueOf(s > 9 ? String.valueOf(s) : "0"+ String.valueOf(s));
			retValue = month + "/" + date + "/" + yyyy + " " + hour + ":"+ minute + ":" + second;
		}
		return retValue;
	}
	
	public Date convertStringToDate(String inputDate) {
		Date dDateTime = null;
		SimpleDateFormat sdfFormatDate = new SimpleDateFormat("MM/dd/yyyy HH:mm:ss");
		try {
			if (inputDate != null && !inputDate.equals("")) {
				dDateTime = sdfFormatDate.parse(inputDate);
				java.sql.Timestamp timest = new java.sql.Timestamp(dDateTime
						.getTime());
				dDateTime = timest;
			}
		} catch (Exception e) {
			System.out.println("Error in convertStringToDate method" + e);
			e.printStackTrace();
		}
		return dDateTime;
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
			e.printStackTrace();
		}
		return formattedDate;
	}
}
