package t4u.functions;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Date;
import java.util.List;

import org.json.JSONArray;
import org.json.JSONObject;

import t4u.beans.ReportHelper;
import t4u.cashvanmanagement.FuelMileageData;
import t4u.common.DBConnection;
import t4u.statements.FuelMileageStatements;

public class FuelMileageFunctions {
	
	FuelMileageStatements fuelMileageStatements = new FuelMileageStatements();
	CommonFunctions commFunctions = new CommonFunctions();
	
	SimpleDateFormat diffddMMyyyyHHmmss = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
	SimpleDateFormat ddMMyyyyHHmmss = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
	SimpleDateFormat yyyyMMddHHmmss = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

	DecimalFormat df = new DecimalFormat("0.##");
	
	public ArrayList<Object> getFuelMileageDetails(String groupId, String startDate, String endDate, int systemId, int clientId, int offset, String language) {
		JSONArray fuelMileageJsonArray = null;
		JSONObject fuelMileageJsonObject = null;
		DecimalFormat decimalformat = new DecimalFormat("#.###");
		ArrayList<ReportHelper> fuelMileageReportsList = new ArrayList<ReportHelper>();
		ArrayList<String> fuelMileageHeadersList = new ArrayList<String>();
		ReportHelper finalreporthelper = new ReportHelper();
		ArrayList<Object> fuelMileageFinalList = new ArrayList<Object>();
		double amountperltr=0;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		ResultSet rs1 = null;
		
		int count = 0;
		
		fuelMileageHeadersList.add(commFunctions.getLabelFromDB("SLNO", language));
		fuelMileageHeadersList.add(commFunctions.getLabelFromDB("Registration_No", language));
		fuelMileageHeadersList.add(commFunctions.getLabelFromDB("Vehicle_Model", language));
		fuelMileageHeadersList.add(commFunctions.getLabelFromDB("Driver_Name", language));
		fuelMileageHeadersList.add(commFunctions.getLabelFromDB("Date", language));
		fuelMileageHeadersList.add(commFunctions.getLabelFromDB("Odometer", language));
		fuelMileageHeadersList.add(commFunctions.getLabelFromDB("Fuel", language));
		fuelMileageHeadersList.add(commFunctions.getLabelFromDB("Amount", language));
		fuelMileageHeadersList.add(commFunctions.getLabelFromDB("Amount_Per_Ltr", language));
		fuelMileageHeadersList.add(commFunctions.getLabelFromDB("Fuel_Type", language));
		fuelMileageHeadersList.add(commFunctions.getLabelFromDB("Slip_No", language));
		fuelMileageHeadersList.add(commFunctions.getLabelFromDB("Fuel_Station_Name", language));
		fuelMileageHeadersList.add(commFunctions.getLabelFromDB("Mileage", language));
		fuelMileageHeadersList.add(commFunctions.getLabelFromDB("Approximate_Mileage", language));
		fuelMileageHeadersList.add(commFunctions.getLabelFromDB("Deviation", language));
		fuelMileageHeadersList.add(commFunctions.getLabelFromDB("Petro_Card_Number", language));
		
		try {
			fuelMileageJsonArray = new JSONArray();
			fuelMileageJsonObject = new JSONObject();
			
			con = DBConnection.getConnectionToDB("AMS");
			String getFuelMileageDetails = fuelMileageStatements.GET_FUEL_MILEAGE_DETAILS;
			
			if(groupId.equals("0")){
				getFuelMileageDetails = getFuelMileageDetails + " order by a.vehicleNo,a.Odometer";
			} else {
				getFuelMileageDetails = getFuelMileageDetails + " and a.GroupId = " + groupId + " order by a.vehicleNo,a.Odometer";
			}
			pstmt = con.prepareStatement(getFuelMileageDetails);
			pstmt.setInt(1, offset);
			pstmt.setInt(2, clientId);
			pstmt.setInt(3, systemId);
			pstmt.setInt(4, offset);
			pstmt.setString(5, startDate);
			pstmt.setInt(6, offset);
			pstmt.setString(7, endDate);
			rs = pstmt.executeQuery();
			while (rs.next()) {					
				count++;	
								
				ArrayList<Object> informationList = new ArrayList<Object>();
				ReportHelper reporthelper = new ReportHelper();
				
				fuelMileageJsonObject = new JSONObject();
				String vehicleNumber = rs.getString("VehicleNo");
				String vehicleModel = rs.getString("VehicleModel");
				String driverName = rs.getString("DriverName");
				String dateTime = diffddMMyyyyHHmmss.format(rs.getTimestamp("Date"));				
				double amount = rs.getDouble("Amount");
				String slipNo = rs.getString("SlipNo");
				String fuelStationName = rs.getString("FuelStationName");
				double mileage = rs.getDouble("Mileage");
				double approximateMileage = rs.getDouble("Approx_Mileage_With_Load");
				double deviation=rs.getDouble("Deviation");		
				String petroCardNumber = rs.getString("PetroCardNumber");
				int odometer = rs.getInt("Odometer");
				double fuel = rs.getDouble("Fuel");
				 
								
				fuelMileageJsonObject.put("slnoIndex", count);
				informationList.add(count);
				
				fuelMileageJsonObject.put("registrationNo", vehicleNumber);
				informationList.add(vehicleNumber);
				
				fuelMileageJsonObject.put("vehicleModel", vehicleModel);
				informationList.add(vehicleModel);
				
				fuelMileageJsonObject.put("driverName", driverName);
				informationList.add(driverName);
				
				fuelMileageJsonObject.put("date", dateTime);
				informationList.add(dateTime);
				
				fuelMileageJsonObject.put("odometer", odometer);
				informationList.add(odometer);
				
				fuelMileageJsonObject.put("fuel", fuel);
				informationList.add(fuel);
				
				fuelMileageJsonObject.put("amount", decimalformat.format(amount));
				informationList.add(decimalformat.format(amount));			
				if(amount>0.0){
				amountperltr=Double.parseDouble(new DecimalFormat("##.###").format((amount/fuel)));
			    }else{
			    	amountperltr = 0.0;	
			    }
				fuelMileageJsonObject.put("amountperltr", amountperltr);
				informationList.add(amountperltr);
				
				fuelMileageJsonObject.put("fuelType", rs.getString("Fuel_Type"));
				informationList.add(rs.getString("Fuel_Type"));
				
				fuelMileageJsonObject.put("slipNo", slipNo);
				informationList.add(slipNo);
				
				fuelMileageJsonObject.put("fuelStationName", fuelStationName);
				informationList.add(fuelStationName);
				
				fuelMileageJsonObject.put("mileage", df.format(mileage));
				informationList.add(df.format(mileage));
				
				fuelMileageJsonObject.put("approximateMileage", approximateMileage);
				informationList.add(approximateMileage);
				
				fuelMileageJsonObject.put("deviation", deviation);
				informationList.add(deviation);
				
				fuelMileageJsonObject.put("petroCardNumber", petroCardNumber);
				informationList.add(petroCardNumber);

				fuelMileageJsonArray.put(fuelMileageJsonObject);
				reporthelper.setInformationList(informationList);
				fuelMileageReportsList.add(reporthelper);				
			}
			
			fuelMileageFinalList.add(fuelMileageJsonArray);
			finalreporthelper.setReportsList(fuelMileageReportsList);
			finalreporthelper.setHeadersList(fuelMileageHeadersList);
			fuelMileageFinalList.add(finalreporthelper);
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return fuelMileageFinalList;
	}
	
	public ArrayList<Object> getFuelMileageSummaryDetails(String groupId, String startDate, String endDate, int systemId, int clientId, int offset, String language) {
		JSONArray fuelMileageJsonArray = null;
		JSONObject fuelMileageJsonObject = null;
		
		ArrayList<ReportHelper> fuelMileageReportsList = new ArrayList<ReportHelper>();
		ArrayList<String> fuelMileageHeadersList = new ArrayList<String>();
		ReportHelper finalreporthelper = new ReportHelper();
		ArrayList<Object> fuelMileageFinalList = new ArrayList<Object>();
		
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		int count = 0;
		
		fuelMileageHeadersList.add(commFunctions.getLabelFromDB("SLNO", language));
		fuelMileageHeadersList.add(commFunctions.getLabelFromDB("Registration_No", language));
		fuelMileageHeadersList.add(commFunctions.getLabelFromDB("Vehicle_Model", language));
		fuelMileageHeadersList.add(commFunctions.getLabelFromDB("Average_Mileage", language));
		fuelMileageHeadersList.add(commFunctions.getLabelFromDB("Total_Fuel_Up", language));
		fuelMileageHeadersList.add(commFunctions.getLabelFromDB("Total_Amount", language));
		fuelMileageHeadersList.add(commFunctions.getLabelFromDB("Total_Refuel", language));
		
		try {
			fuelMileageJsonArray = new JSONArray();
			fuelMileageJsonObject = new JSONObject();
			
			con = DBConnection.getConnectionToDB("AMS");
			String getFuelMileageSummaryDetails = fuelMileageStatements.GET_FUEL_MILEAGE_SUMMARY_DETAILS;
			
			if(groupId.equals("0")){
				getFuelMileageSummaryDetails = getFuelMileageSummaryDetails +  "  group by a.vehicleNo,c.ModelName order by a.vehicleNo";
			} else {
				getFuelMileageSummaryDetails = getFuelMileageSummaryDetails +  "  and a.GroupId = " + groupId + " group by a.vehicleNo,c.ModelName order by a.vehicleNo";
			}
			
			pstmt = con.prepareStatement(getFuelMileageSummaryDetails);
			pstmt.setInt(1, clientId);
			pstmt.setInt(2, systemId);
			pstmt.setInt(3, offset);
			pstmt.setString(4, startDate);
			pstmt.setInt(5, offset);
			pstmt.setString(6, endDate);
			rs = pstmt.executeQuery();
			while (rs.next()) {					
				count++;	
							
				ArrayList<Object> informationList = new ArrayList<Object>();
				ReportHelper reporthelper = new ReportHelper();
				
				fuelMileageJsonObject = new JSONObject();
				String vehicleNumber = rs.getString("VehicleNo");
				String vehicleModel = rs.getString("VehicleModel");
				int totalFuelUps = rs.getInt("Count");
				double totalMileage = rs.getDouble("TotalMileage");
				double totalAmount = rs.getDouble("TotalAmount");
				double totalRefuel = rs.getDouble("TotalRefuel");
				
							
				fuelMileageJsonObject.put("slnoIndexSummary", count);
				informationList.add(count);
				
				fuelMileageJsonObject.put("registrationNoSummary", vehicleNumber);
				informationList.add(vehicleNumber);
				
				fuelMileageJsonObject.put("vehicleModelSummary", vehicleModel);
				informationList.add(vehicleModel);
								
				fuelMileageJsonObject.put("averageMileage", df.format(totalMileage/totalFuelUps));
				informationList.add(df.format(totalMileage/totalFuelUps));
				
				fuelMileageJsonObject.put("totalFuelUps", totalFuelUps);
				informationList.add(totalFuelUps);
				
				fuelMileageJsonObject.put("totalAmount", totalAmount);
				informationList.add(totalAmount);
				
				fuelMileageJsonObject.put("fuelInLiters", totalRefuel);
				informationList.add(totalRefuel);
				
				fuelMileageJsonArray.put(fuelMileageJsonObject);
				reporthelper.setInformationList(informationList);
				fuelMileageReportsList.add(reporthelper);				
			}
			
			fuelMileageFinalList.add(fuelMileageJsonArray);
			finalreporthelper.setReportsList(fuelMileageReportsList);
			finalreporthelper.setHeadersList(fuelMileageHeadersList);
			fuelMileageFinalList.add(finalreporthelper);
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return fuelMileageFinalList;
	}
	
	public JSONArray getValidationFuelMileageDetails(int clientId, int systemId, JSONArray js) {

		List<FuelMileageData> list = new ArrayList<FuelMileageData>();
		JSONArray fuelMileageJsonArray = null;
		JSONObject fuelMileageJsonObject = null;

		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int count = 0;
		int previousOdometer = 0;
		
		try {
			fuelMileageJsonArray = new JSONArray();
			fuelMileageJsonObject = new JSONObject();
			
			con = DBConnection.getConnectionToDB("AMS");
			
			for (int i = 0; i < js.length(); i++) {	
				
				JSONObject obj = js.getJSONObject(i);
				String assetNumber = obj.getString("registrationNo");
				String date = obj.getString("date");
				String odometer = obj.getString("odometer");
				String fuel = obj.getString("fuel");
				String amount = obj.getString("amount");
				String slipNo = obj.getString("slipNo");
				String fuelStationName = obj.getString("fuelStationName");
				String petroCardNumber = obj.getString("petroCardNumber");
				
				list.add(new FuelMileageData(assetNumber, date, Integer.parseInt(odometer), Double.parseDouble(fuel), Double.parseDouble(amount), slipNo, fuelStationName, petroCardNumber));							
			}
			Collections.sort(list, new FuelMileageData());
			
			String existingVehicleNo = "";
			
			for(FuelMileageData fuelDetails: list) {
				count++;
				fuelMileageJsonObject = new JSONObject();
				String validAssetNumber = fuelDetails.vehicle;
				int validOdometer = fuelDetails.odometer;
				String dateTime = fuelDetails.date;
							
				if (dateTime.contains("T")) {
					dateTime = dateTime.substring(0, dateTime.indexOf("T")) + " "+ dateTime.substring(dateTime.indexOf("T") + 1, dateTime.length());	
					Date d1 = yyyyMMddHHmmss.parse(dateTime);					
					dateTime = diffddMMyyyyHHmmss.format(d1);
				} 
				
				if (!validAssetNumber.equals(existingVehicleNo)) {
					existingVehicleNo = validAssetNumber;			
					pstmt = con.prepareStatement(fuelMileageStatements.GET_TOP_ODOMETER);				
					pstmt.setString(1, validAssetNumber);
					pstmt.setInt(2, clientId);
					pstmt.setInt(3, systemId);
					rs = pstmt.executeQuery();
					if (rs.next()) {
						previousOdometer = rs.getInt("Odometer");
					} else {
						previousOdometer = 0;
					}
					rs.close();					
					if (previousOdometer <= validOdometer) {
						fuelMileageJsonObject.put("slnoIndex", count);
						fuelMileageJsonObject.put("registrationNo", validAssetNumber);
						fuelMileageJsonObject.put("date", dateTime);
						fuelMileageJsonObject.put("odometer", validOdometer);
						fuelMileageJsonObject.put("fuel", fuelDetails.fuel);
						fuelMileageJsonObject.put("amount", fuelDetails.amount);
						fuelMileageJsonObject.put("slipNo", fuelDetails.slipNo);
						fuelMileageJsonObject.put("fuelStationName", fuelDetails.fuelStationName);
						fuelMileageJsonObject.put("petroCardNumber", fuelDetails.petroCardNumber);
						fuelMileageJsonObject.put("validOrInvalid", "Valid");//Valid
						fuelMileageJsonArray.put(fuelMileageJsonObject);
					} else {
						fuelMileageJsonObject.put("slnoIndex", count);
						fuelMileageJsonObject.put("registrationNo", validAssetNumber);
						fuelMileageJsonObject.put("date", dateTime);
						fuelMileageJsonObject.put("odometer", validOdometer);
						fuelMileageJsonObject.put("fuel", fuelDetails.fuel);
						fuelMileageJsonObject.put("amount", fuelDetails.amount);
						fuelMileageJsonObject.put("slipNo", fuelDetails.slipNo);
						fuelMileageJsonObject.put("fuelStationName", fuelDetails.fuelStationName);
						fuelMileageJsonObject.put("petroCardNumber", fuelDetails.petroCardNumber);
						fuelMileageJsonObject.put("validOrInvalid", "Invalid"); //Invalid
						fuelMileageJsonArray.put(fuelMileageJsonObject);
					}
				} else {
					int checkpreviousOdometer = 0;
					pstmt = con.prepareStatement(fuelMileageStatements.GET_TOP_ODOMETER);				
					pstmt.setString(1, validAssetNumber);
					pstmt.setInt(2, clientId);
					pstmt.setInt(3, systemId);
					rs = pstmt.executeQuery();
					if (rs.next()) {
						checkpreviousOdometer = rs.getInt("Odometer");
					}
					rs.close();
					if(checkpreviousOdometer < validOdometer && previousOdometer < validOdometer) {
						fuelMileageJsonObject.put("slnoIndex", count);
						fuelMileageJsonObject.put("registrationNo", validAssetNumber);
						fuelMileageJsonObject.put("date", dateTime);
						fuelMileageJsonObject.put("odometer", validOdometer);
						fuelMileageJsonObject.put("fuel", fuelDetails.fuel);
						fuelMileageJsonObject.put("amount", fuelDetails.amount);
						fuelMileageJsonObject.put("slipNo", fuelDetails.slipNo);
						fuelMileageJsonObject.put("fuelStationName", fuelDetails.fuelStationName);
						fuelMileageJsonObject.put("petroCardNumber", fuelDetails.petroCardNumber);
						fuelMileageJsonObject.put("validOrInvalid", "Valid");//Valid
						fuelMileageJsonArray.put(fuelMileageJsonObject);
					} else {
						fuelMileageJsonObject.put("slnoIndex", count);
						fuelMileageJsonObject.put("registrationNo", validAssetNumber);
						fuelMileageJsonObject.put("date", dateTime);
						fuelMileageJsonObject.put("odometer", validOdometer);
						fuelMileageJsonObject.put("fuel", fuelDetails.fuel);
						fuelMileageJsonObject.put("amount", fuelDetails.amount);
						fuelMileageJsonObject.put("slipNo", fuelDetails.slipNo);
						fuelMileageJsonObject.put("fuelStationName", fuelDetails.fuelStationName);
						fuelMileageJsonObject.put("petroCardNumber", fuelDetails.petroCardNumber);
						fuelMileageJsonObject.put("validOrInvalid", "Invalid");//Valid
						fuelMileageJsonArray.put(fuelMileageJsonObject);
					}
				}
				previousOdometer = validOdometer;
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return fuelMileageJsonArray;
	}
	
	public String savefuelMileageDetails(int customerId, int systemId, int offset, int userId, JSONArray js) {
		List<FuelMileageData> list = new ArrayList<FuelMileageData>();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		String message = "";

		try {
			con = DBConnection.getConnectionToDB("AMS");
			
			for (int i = 0; i < js.length(); i++) {	
				
				JSONObject obj = js.getJSONObject(i);
				String assetNumber = obj.getString("registrationNo");
				String date = obj.getString("date");
				String odometer = obj.getString("odometer");
				String fuel = obj.getString("fuel");
				String amount = obj.getString("amount");
				String slipNo = obj.getString("slipNo");
				String fuelStationName = obj.getString("fuelStationName");
				String petroCardNumber = obj.getString("petroCardNumber");
				String validOrInvalid = obj.getString("validOrInvalid");
				
				if(validOrInvalid.equals("Valid")) {
					list.add(new FuelMileageData(assetNumber, date, Integer.parseInt(odometer), Double.parseDouble(fuel), Double.parseDouble(amount), slipNo, fuelStationName, petroCardNumber));							
				}				
			}
						
			Collections.sort(list, new FuelMileageData());
			
			String existingVehicleNo = "";
			int previousOdometer = 0;
			//double previousFuel = 0;
						
			for(FuelMileageData fuelDetails: list) {
				
				double mileage = 0;
				String dateTime = fuelDetails.date;
				
				if (dateTime.contains("T")) {
					dateTime = dateTime.substring(0, dateTime.indexOf("T")) + " "+ dateTime.substring(dateTime.indexOf("T") + 1, dateTime.length());
					dateTime = commFunctions.getFormattedDateStartingFromMonth(dateTime);
					dateTime = commFunctions.getGMTDateTime(dateTime, offset);
				} else {
					Date start = ddMMyyyyHHmmss.parse(dateTime);
					dateTime = ddMMyyyyHHmmss.format(start);
					dateTime = commFunctions.getGMTDateTime(dateTime, offset);
				}
				
				if (!fuelDetails.vehicle.equals(existingVehicleNo)) {
					existingVehicleNo = fuelDetails.vehicle;

					pstmt = con.prepareStatement(fuelMileageStatements.GET_TOP_ODOMETER);
					pstmt.setString(1, fuelDetails.vehicle);
					pstmt.setInt(2, customerId);
					pstmt.setInt(3, systemId);					
					rs = pstmt.executeQuery();
					if (rs.next()) {
						previousOdometer = rs.getInt("Odometer");
						//previousFuel = rs.getDouble("Disel");
					} else {
						previousOdometer = 0;
						//previousFuel = 0;
					}
					if (fuelDetails.fuel != 0 && previousOdometer != 0 && fuelDetails.odometer != 0 && previousOdometer < fuelDetails.odometer) {
						//mileage = (fuelDetails.odometer - previousOdometer) / previousFuel;
						mileage = (fuelDetails.odometer - previousOdometer) / fuelDetails.fuel;
					}

				} else {
					if(fuelDetails.fuel != 0 && previousOdometer != 0 && fuelDetails.odometer != 0 && previousOdometer < fuelDetails.odometer){
						//mileage = (fuelDetails.odometer - previousOdometer) / previousFuel;
						mileage = (fuelDetails.odometer - previousOdometer) / fuelDetails.fuel;
					}					
				}
				previousOdometer = fuelDetails.odometer;
				//previousFuel = fuelDetails.fuel;
				
				int groupId = 0;
				try {
					
					pstmt = con.prepareStatement(fuelMileageStatements.GET_GROUP_ID_BASED_ON_ASSET_NUMBER);
					pstmt.setString(1, fuelDetails.vehicle);
					pstmt.setInt(2, customerId);
					pstmt.setInt(3, systemId);
					rs = pstmt.executeQuery();
					if (rs.next()) {
						groupId = rs.getInt("GROUP_ID");
					}
					
					pstmt = con.prepareStatement(fuelMileageStatements.INSERT_FUEL_DETAILS);
					pstmt.setString(1, fuelDetails.vehicle);
					pstmt.setString(2, "");
					pstmt.setInt(3, fuelDetails.odometer);
					pstmt.setDouble(4, mileage);
					pstmt.setDouble(5, fuelDetails.fuel);
					pstmt.setDouble(6, fuelDetails.amount);
					pstmt.setString(7, fuelDetails.slipNo);
					pstmt.setString(8, dateTime);
					pstmt.setString(9, fuelDetails.fuelStationName);
					pstmt.setInt(10, customerId);
					pstmt.setInt(11, systemId);
					pstmt.setDouble(12, 0);
					pstmt.setDouble(13, 0);
					pstmt.setString(14, fuelDetails.petroCardNumber);
					pstmt.setInt(15, groupId);
					pstmt.setInt(16, userId);
					int inserted = pstmt.executeUpdate();
					if (inserted > 0) {
						message = "Added " +  fuelDetails.vehicle + " Fuel Mileage Details Successfully";
					}
				} catch (Exception e) {
					e.printStackTrace();
				}				
			}
		} catch(Exception e){
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}		
		return message;
	}
	
	public JSONArray getPetroCardNumber(int systemId, String vehicleNo) {
		Connection conAms = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject = null;
		try {
			conAms = DBConnection.getConnectionToDB("AMS");
			pstmt = conAms.prepareStatement(fuelMileageStatements.GET_PETRO_CARD_NUMBER);
			pstmt.setString(1, vehicleNo);
			pstmt.setInt(2, systemId);
			rs = pstmt.executeQuery();
			if(rs.next()){
				jsonObject = new JSONObject();
				jsonObject.put("PetroCardNumber", rs.getString("PetrolCardNumber"));
				jsonArray.put(jsonObject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(conAms, pstmt, rs);
		}
		return jsonArray;
	}

	public String deleteFuelData(int clientId, int systemId, int userId, String deleteRegNo, String deleteOdometer, int offset) {

		int previousOdometer = 0;
		int odometerToDelete = 0;
		int mileagueHistoryId = 0;
		String date = "";
		int update = 0 ;
		String message = "";
		Connection conAms = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		try {

			conAms = DBConnection.getConnectionToDB("AMS");
			conAms.setAutoCommit(false);

			pstmt = conAms.prepareStatement(fuelMileageStatements.GET_TOP_ODOMETER_WHILE_DELETE);
			pstmt.setInt(1, offset);
			pstmt.setString(2, deleteRegNo);
			pstmt.setInt(3, clientId);
			pstmt.setInt(4, systemId);					
			rs = pstmt.executeQuery();
			if (rs.next()) {
				previousOdometer = rs.getInt("Odometer");
				date = diffddMMyyyyHHmmss.format(rs.getTimestamp("DateTime"));
				date = date.substring(0, 10);
			}
			pstmt.close();
			rs.close();

			odometerToDelete = Integer.parseInt(deleteOdometer);

			if(odometerToDelete == previousOdometer){
				//push data into delete table and then delete from Master
				pstmt = conAms.prepareStatement(fuelMileageStatements.INSERT_FUEL_MILEAGUE_HISTORY_DETAIL);
				pstmt.setString(1, deleteRegNo);
				pstmt.setInt(2, clientId);
				pstmt.setInt(3, systemId);
				int insert = pstmt.executeUpdate();
				pstmt.close();
				
				if(insert > 0){
					pstmt = conAms.prepareStatement(fuelMileageStatements.GET_MILEAGUE_HISTORY_ID);
					rs = pstmt.executeQuery();
					if(rs.next()){
						mileagueHistoryId = rs.getInt("MileagueHistoryId");
					}
					pstmt.close();
					
					
					if(mileagueHistoryId > 0){
						pstmt = conAms.prepareStatement(fuelMileageStatements.UPDATE_MILEAGUE_HISTORY);
						pstmt.setInt(1, userId);
						pstmt.setInt(2, mileagueHistoryId);
						update = pstmt.executeUpdate();
					}
					pstmt.close();
										
					if(update > 0){
						//delete fuel data from MileagueMaster table
						pstmt = conAms.prepareStatement(fuelMileageStatements.DELETE_MILEAGUE_MASTER_DETAILS);
						pstmt.setString(1, deleteRegNo);
						pstmt.setInt(2, odometerToDelete);
						pstmt.setInt(3, clientId);
						pstmt.setInt(4, systemId);
						int deleted = pstmt.executeUpdate();

						if(insert > 0 && update > 0 && deleted > 0){
							conAms.commit();
							message = "Deleted Successfully.";
						} else {
							try {
								conAms.rollback();
								message = "Unable to delete.";
							} catch(Exception ex) {
								message = "Unable to delete.";
								ex.printStackTrace();
							}
						}
					}
				}
			} else {
				message = "Unable to delete fuel odometer " + deleteOdometer + " due to latest fuel odometer " + previousOdometer + " exists on " + date + ".";
			}
		} catch (Exception e) {
			if (conAms != null) {
				try {
					conAms.rollback();
					message = "Unable to delete.";
				} catch(Exception ex) {
					message = "Unable to delete.";
					ex.printStackTrace();
				}
				e.printStackTrace();
			}

		} finally {
			DBConnection.releaseConnectionToDB(conAms, pstmt, rs);
		}

		return message;
	}
}
