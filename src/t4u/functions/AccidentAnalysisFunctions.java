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
import t4u.statements.AccidentAnalysisStatements;

public class AccidentAnalysisFunctions {
	
	AccidentAnalysisStatements analysisStatements = new AccidentAnalysisStatements();
	CommonFunctions commonFunctions = new CommonFunctions();
	
	SimpleDateFormat ddMMYYYYHHMMSS = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
	SimpleDateFormat ddMMYYYY = new SimpleDateFormat("dd-MM-yyyy");
	DecimalFormat df = new DecimalFormat("00.##");
	
	public JSONArray getcaseInformationDetails(int systemId, int customerId, int offset, String language) {
		JSONArray caseInfoJsonArray = null;
		JSONObject caseInfoJsonObject = null;
				
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		int count = 0;
			
		try {
			caseInfoJsonArray = new JSONArray();
			
			con = DBConnection.getConnectionToDB("AMS");
			
			pstmt = con.prepareStatement(analysisStatements.GET_CASE_INFORMATION_DETAILS);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, customerId);
			rs = pstmt.executeQuery();
			while (rs.next()) {					
				count++;	
												
				caseInfoJsonObject = new JSONObject();
				
				caseInfoJsonObject.put("slnoIndex", count);	
				caseInfoJsonObject.put("caseId", rs.getString("CASE_ID"));	
				caseInfoJsonObject.put("caseNumber", rs.getString("CASE_NUMBER"));		
				caseInfoJsonObject.put("assetNumber", rs.getString("ASSET_NUMBER"));
				caseInfoJsonObject.put("IdDriverName", rs.getInt("DRIVER_ID"));	
				caseInfoJsonObject.put("driverName", rs.getString("DRIVER_NAME").toUpperCase());		
				caseInfoJsonObject.put("IdAccidentalType", rs.getInt("ACCIDENTAL_TYPE_ID"));			
				caseInfoJsonObject.put("accidentalType", rs.getString("ACCIDENTAL_TYPE"));	
				caseInfoJsonObject.put("IdCollatedWith", rs.getInt("COLLATED_WITH_ID"));	
				caseInfoJsonObject.put("collatedWith", rs.getString("COLLATED_WITH"));	
				caseInfoJsonObject.put("otherAssetNumber", rs.getString("SECONDARY_ASSET_NUMBER"));				
				caseInfoJsonObject.put("otherDriverName", rs.getString("SECONDARY_DRIVER_NAME"));
				caseInfoJsonObject.put("otherDetails", rs.getString("OTHER_DETAILS"));				
				caseInfoJsonObject.put("location", rs.getString("ACCIDENT_LOCATION"));	
				caseInfoJsonObject.put("date", ddMMYYYYHHMMSS.format(rs.getTimestamp("ACCIDENT_DATE")));
				caseInfoJsonObject.put("lossOfLife", rs.getInt("LOSS_OF_LIFE"));
				caseInfoJsonObject.put("injured", rs.getInt("INJURED"));
				caseInfoJsonObject.put("insuranceClaimedAmount", rs.getDouble("INSURANCE_AMOUNT"));	
				caseInfoJsonObject.put("faultyVehicle", rs.getString("FAULTY_ASSET"));
				caseInfoJsonObject.put("IdSettlement", rs.getInt("SETTELMENT_ID"));	
				caseInfoJsonObject.put("settlement", rs.getString("SETTELMENT"));	
				caseInfoJsonObject.put("IdCaseStatus", rs.getInt("CASE_STATUS_ID"));	
				caseInfoJsonObject.put("caseStatus", rs.getString("CASE_STATUS"));											

				caseInfoJsonArray.put(caseInfoJsonObject);			
			}			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return caseInfoJsonArray;
	}
	
	public JSONArray getCompensationInformationDetails(int caseId, int customerId) {
		JSONArray compensationInfoJsonArray = null;
		JSONObject compensationInfoJsonObject = null;
				
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		int count = 0;
			
		try {
			compensationInfoJsonArray = new JSONArray();
			
			con = DBConnection.getConnectionToDB("AMS");
			
			pstmt = con.prepareStatement(analysisStatements.GET_COMPENSATION_INFORMATION_DETAILS);
			pstmt.setInt(1, customerId);
			pstmt.setInt(2, caseId);
			rs = pstmt.executeQuery();
			while (rs.next()) {					
				count++;	
												
				compensationInfoJsonObject = new JSONObject();
				
				compensationInfoJsonObject.put("slnoIndex", count);	
				compensationInfoJsonObject.put("compensationId", rs.getString("COMPENSATION_ID"));	
				compensationInfoJsonObject.put("compensationCaseNumber", rs.getString("CASE_NUMBER"));		
				compensationInfoJsonObject.put("compensationAssetNumber", rs.getString("ASSET_NUMBER"));
				compensationInfoJsonObject.put("referenceNumber", rs.getString("REFERENCE_NUMBER"));	
				compensationInfoJsonObject.put("IdCompensationType", rs.getInt("COMPENSATION_TYPE_ID"));			
				compensationInfoJsonObject.put("compensationType", rs.getString("COMPENSATION_TYPE"));	
				compensationInfoJsonObject.put("IdModeOftransaction", rs.getInt("MODE_OF_TRANSACTION_ID"));	
				compensationInfoJsonObject.put("modeOfTransaction", rs.getString("MODE_OF_TRANSACTION"));	
				compensationInfoJsonObject.put("IdTransactionType", rs.getInt("TRANSACTION_TYPE_ID"));	
				compensationInfoJsonObject.put("transactionType", rs.getString("TRANSACTION_TYPE"));	
				compensationInfoJsonObject.put("transactionDate", ddMMYYYYHHMMSS.format(rs.getTimestamp("TRANSACTION_DATE")));
				compensationInfoJsonObject.put("transactionAmount", rs.getDouble("TRANSACTION_AMOUNT"));	
				compensationInfoJsonObject.put("checkOrDD", rs.getString("TRANSACTION_NUMBER"));	
				compensationInfoJsonObject.put("compensationPaidIn", rs.getDouble("COMPENSATION_PAID_IN"));
				compensationInfoJsonObject.put("compensationPaidOut", rs.getDouble("COMPENSATION_PAID_OUT"));
				compensationInfoJsonObject.put("internalExpenses", rs.getDouble("INTERNAL_EXPENSES"));
				if(ddMMYYYY.format(rs.getTimestamp("NEXT_HEARING_DATE")).equals("01-01-1900")){
					compensationInfoJsonObject.put("nextHearingDate", "");
				} else {
					compensationInfoJsonObject.put("nextHearingDate", ddMMYYYY.format(rs.getTimestamp("NEXT_HEARING_DATE")));
				}
				compensationInfoJsonArray.put(compensationInfoJsonObject);			
			}			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return compensationInfoJsonArray;
	}

	public String saveAccidentCaseInformation(int systemId, int customerId, int userId, String caseNumber , String assetNo, String driverId,
			String accidentalType, String collatedWith,String otherDetails, String location,String dateTime, String lossOfLife, String injured, String insuranceClaimedAmt,
			String faultyVehicle, String settlement, String caseStatus,String secondaryAssetNumber, String secondaryDriverName) {
		String message = "";
		
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		try {			
			con = DBConnection.getConnectionToDB("AMS");
			
			int count = 0;
			pstmt = con.prepareStatement(analysisStatements.GET_CASE_ID_TO_INCREMENT);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, customerId);
			rs = pstmt.executeQuery();
			if(rs.next()){
				count = rs.getInt("CASE_ID");
				count++;
			} else {
				count++;
			}
			pstmt = con.prepareStatement(analysisStatements.SAVE_ACCIDENT_CASE_INFORMATION);
			pstmt.setInt(1, count);
			pstmt.setString(2, caseNumber);
			pstmt.setString(3, assetNo);
			pstmt.setString(4, driverId);
			pstmt.setString(5, accidentalType);
			pstmt.setString(6, collatedWith);
			pstmt.setString(7, secondaryAssetNumber);
			pstmt.setString(8, secondaryDriverName);
			pstmt.setString(9, otherDetails);
			pstmt.setString(10, location);
			pstmt.setString(11, dateTime);
			pstmt.setString(12, lossOfLife);
			pstmt.setString(13, injured);
			pstmt.setString(14, insuranceClaimedAmt);		
			pstmt.setString(15, faultyVehicle);
			pstmt.setString(16, settlement);
			pstmt.setString(17, caseStatus);			
			pstmt.setInt(18, systemId);
			pstmt.setInt(19, customerId);
			pstmt.setInt(20, userId);
			int inserted = pstmt.executeUpdate();
			if (inserted > 0) {
				message = "Added " +  assetNo + " Accident Case Information Successfully";
			} else {
				message = "Unable To Add Accident Case Information";
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return message;
	}

	public String upadteAccidentCaseInformation(int systemId, int customerId, int userId, String caseId, String caseNumber, String assetNo, String driverId,
			String accidentalType, String collatedWith,String otherDetails, String location,String dateTime, String lossOfLife, String injured, String insuranceClaimedAmt,
			String faultyVehicle, String settlement, String caseStatus,String secondaryAssetNumber, String secondaryDriver) {

		String message = "";
		Connection con = null;
		PreparedStatement pstmt = null;
		
		try {
			con = DBConnection.getConnectionToDB("AMS");
			
			pstmt = con.prepareStatement(analysisStatements.UPDATE_ACCIDENT_CASE_INFORMATION);
			pstmt.setString(1, driverId);
			pstmt.setString(2, accidentalType);
			pstmt.setString(3, collatedWith);
			pstmt.setString(4, secondaryAssetNumber);
			pstmt.setString(5, secondaryDriver);
			pstmt.setString(6, otherDetails);
			pstmt.setString(7, location);
			pstmt.setString(8, dateTime);
			pstmt.setString(9, lossOfLife);
			pstmt.setString(10, injured);
			pstmt.setString(11, insuranceClaimedAmt);		
			pstmt.setString(12, faultyVehicle);
			pstmt.setString(13, settlement);
			pstmt.setString(14, caseStatus);
			pstmt.setInt(15, userId);
			pstmt.setInt(16, systemId);
			pstmt.setInt(17, customerId);
			pstmt.setString(18, assetNo);
			pstmt.setString(19, caseNumber);
			pstmt.setString(20, caseId);					
			int update = pstmt.executeUpdate();
			if (update > 0) {
				message = "Modified " +  assetNo + " Accident Case Information Successfully";
			} else {
				message = "Unable To Modify Accident Case Information";
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, null);
		}
		return message;	
	}

	public JSONArray getAccidentLookUpMaster(int systemId, int customerId, String type) {
		JSONArray jsonArray = null;
		JSONObject jsonObject = null;

		Connection conAms = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			jsonArray = new JSONArray();
			
			conAms = DBConnection.getConnectionToDB("AMS");
			pstmt = conAms.prepareStatement(analysisStatements.GET_ACCIDENT_LOOKUP_MASTER);
			pstmt.setString(1, type);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				jsonObject = new JSONObject();
				jsonObject.put("id", rs.getInt("ID"));
				jsonObject.put("name", rs.getString("VALUE"));
				jsonArray.put(jsonObject);
			}

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(conAms, pstmt, rs);
		}
		return jsonArray;
	}

	public JSONArray getCaseNumber(int systemId, int customerId) {
		JSONArray jsonArray = null;
		JSONObject jsonObject = null;

		Connection conAms = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			jsonArray = new JSONArray();
			conAms = DBConnection.getConnectionToDB("AMS");
			pstmt = conAms.prepareStatement(analysisStatements.GET_CASE_NUMBER);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, customerId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				jsonObject = new JSONObject();
				jsonObject.put("CaseId", rs.getInt("CASE_ID"));
				jsonObject.put("CaseNumber", rs.getString("CASE_NUMBER"));
				jsonArray.put(jsonObject);
			}

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(conAms, pstmt, rs);
		}
		return jsonArray;
	}

	public String saveAccidentCompensationInformation(int customerId, int userId, int caseId,
			String referenceNumber, String compensationType,String modeOfTransaction, String transactionType, 
			String transactionDateTime, String transactionAmt, String checkOrDD, String nextHearingDate, String compensationPaidIn,String compensationPaidOut,String InternalExpenses) {
		String message = "";
		
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		try {			
			con = DBConnection.getConnectionToDB("AMS");
			
			int count = 0;
			pstmt = con.prepareStatement(analysisStatements.GET_COMPENSATION_ID_TO_INCREMENT);
			pstmt.setInt(1, caseId);
			pstmt.setInt(2, customerId);
			rs = pstmt.executeQuery();
			if(rs.next()){
				count = rs.getInt("COMPENSATION_ID");
				count++;
			} else {
				count++;
			}
			pstmt = con.prepareStatement(analysisStatements.SAVE_ACCIDENT_COMPENSATION_INFORMATION);
			pstmt.setInt(1, count);
			pstmt.setInt(2, caseId);
			pstmt.setString(3, referenceNumber);
			pstmt.setString(4, compensationType);
			pstmt.setString(5, modeOfTransaction);
			pstmt.setString(6, transactionType);
			pstmt.setString(7, transactionDateTime);
			pstmt.setString(8, transactionAmt);
			pstmt.setString(9, checkOrDD);
			pstmt.setString(10, compensationPaidIn);
			pstmt.setString(11, compensationPaidOut);
			pstmt.setString(12, InternalExpenses);
			pstmt.setString(13, nextHearingDate);
			pstmt.setInt(14, customerId);
			pstmt.setInt(15, userId);
			int inserted = pstmt.executeUpdate();
			if (inserted > 0) {
				message = "Added Accident Compensation Information Successfully";
			} else {
				message = "Unable To Add Accident Compensation Information";
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return message;
	}

	public String upadteAccidentCompensationInformation(int customerId,int userId, int caseId, int compensationId,
			String referenceNumber, String compensationType,String modeOfTransaction, String transactionType,
			String transactionDateTime, String transactionAmt,String checkOrDD, String nextHearingDate,String compensationPaidIn,String compensationPaidOut,String InternalExpenses) {

		String message = "";
		Connection con = null;
		PreparedStatement pstmt = null;
		
		try {
			con = DBConnection.getConnectionToDB("AMS");
			
			pstmt = con.prepareStatement(analysisStatements.UPDATE_ACCIDENT_COMPENSATION_INFORMATION);
			pstmt.setString(1, referenceNumber);
			pstmt.setString(2, compensationType);
			pstmt.setString(3, modeOfTransaction);
			pstmt.setString(4, transactionType);
			pstmt.setString(5, transactionDateTime);
			pstmt.setString(6, transactionAmt);
			pstmt.setString(7, checkOrDD);
			pstmt.setString(8, compensationPaidIn);
			pstmt.setString(9, compensationPaidOut);
			pstmt.setString(10, InternalExpenses);
			pstmt.setString(11, nextHearingDate);
			pstmt.setInt(12, userId);		
			pstmt.setInt(13, compensationId);
			pstmt.setInt(14, caseId);
			pstmt.setInt(15, customerId);								
			int update = pstmt.executeUpdate();
			if (update > 0) {
				message = "Modified Accident Case Information Successfully";
			} else {
				message = "Unable To Modify Accident Case Information";
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, null);
		}
		return message;	
	}

	public ArrayList<Object> getAccidentExpenditureSummary(int systemId, int customerId, String language) {
		
		JSONArray summaryJsonArray = null;
		JSONObject summaryJsonObject = null;
				
		ArrayList<ReportHelper> summaryReportsList = new ArrayList<ReportHelper>();
		ArrayList<String> summaryHeadersList = new ArrayList<String>();
		ReportHelper finalreporthelper = new ReportHelper();
		ArrayList<Object> summaryFinalList = new ArrayList<Object>();
		
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		int count = 0;
			
		try {
			int totalNoOfAccidents = 0;
			double totalPayments = 0;
			double totalReceipts = 0;
			int totalLossOfLife = 0;
			int totalInjured = 0;
			int totalCasesOpened = 0;
			int totalCasesClosed = 0;
			
			summaryJsonArray = new JSONArray();
					
			summaryHeadersList.add(commonFunctions.getLabelFromDB("SLNO", language));
			summaryHeadersList.add(commonFunctions.getLabelFromDB("Asset_Number", language));
			summaryHeadersList.add(commonFunctions.getLabelFromDB("No_Of_Accidents", language));
			summaryHeadersList.add(commonFunctions.getLabelFromDB("Total_Payments", language));
			summaryHeadersList.add(commonFunctions.getLabelFromDB("Total_Receipts", language));
			summaryHeadersList.add(commonFunctions.getLabelFromDB("Total_Loss_Of_Life", language));
			summaryHeadersList.add(commonFunctions.getLabelFromDB("Total_Injured", language));
			summaryHeadersList.add(commonFunctions.getLabelFromDB("Total_Cases_Opened", language));
			summaryHeadersList.add(commonFunctions.getLabelFromDB("Total_Cases_Closed", language));
									
			con = DBConnection.getConnectionToDB("AMS");		
			pstmt = con.prepareStatement(analysisStatements.GET_ACCIDENT_EXPENDITURE_SUMMARY);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, customerId);
			rs = pstmt.executeQuery();
			while (rs.next()) {	
				summaryJsonObject = new JSONObject();
				count++;	
				
				ArrayList<Object> informationList = new ArrayList<Object>();
				ReportHelper reporthelper = new ReportHelper();	

				summaryJsonObject.put("slnoIndex", count);	
				informationList.add(count);
				
				summaryJsonObject.put("assetNumber", rs.getString("ASSET_NUMBER"));	
				informationList.add(rs.getString("ASSET_NUMBER"));
				
				summaryJsonObject.put("noOfAccidents", rs.getInt("NO_OF_ACCIDENTS"));
				informationList.add(rs.getInt("NO_OF_ACCIDENTS"));
				totalNoOfAccidents = totalNoOfAccidents + rs.getInt("NO_OF_ACCIDENTS");
				
				summaryJsonObject.put("totalPayments", df.format(rs.getDouble("PAYMENT")));
				informationList.add(df.format(rs.getDouble("PAYMENT")));
				totalPayments = totalPayments + rs.getDouble("PAYMENT");
				
				summaryJsonObject.put("totalReceipts", df.format(rs.getDouble("RECEIPT")));	
				informationList.add(df.format(rs.getDouble("RECEIPT")));
				totalReceipts = totalReceipts + rs.getDouble("RECEIPT");
				
				summaryJsonObject.put("totalLossOfLife", rs.getInt("TOTAL_LOSS_OF_LIFE"));		
				informationList.add(rs.getInt("TOTAL_LOSS_OF_LIFE"));
				totalLossOfLife = totalLossOfLife + rs.getInt("TOTAL_LOSS_OF_LIFE");
				
				summaryJsonObject.put("totalInjured", rs.getInt("TOTAL_INJURED"));		
				informationList.add(rs.getInt("TOTAL_INJURED"));
				totalInjured = totalInjured + rs.getInt("TOTAL_INJURED");
				
				summaryJsonObject.put("totalCasesOpened", rs.getInt("TOTAL_CASES_OPENED"));	
				informationList.add(rs.getInt("TOTAL_CASES_OPENED"));
				totalCasesOpened = totalCasesOpened + rs.getInt("TOTAL_CASES_OPENED");
				
				summaryJsonObject.put("totalCasesClosed", rs.getInt("TOTAL_CASES_CLOSED"));	
				informationList.add(rs.getInt("TOTAL_CASES_CLOSED"));
				totalCasesClosed = totalCasesClosed + rs.getInt("TOTAL_CASES_CLOSED");
										
				summaryJsonArray.put(summaryJsonObject);	
				reporthelper.setInformationList(informationList);
				summaryReportsList.add(reporthelper);
			}
			
			if(count > 0){	
				summaryJsonObject = new JSONObject();
				count++;	
				
				ArrayList<Object> informationList = new ArrayList<Object>();
				ReportHelper reporthelper = new ReportHelper();	

				summaryJsonObject.put("slnoIndex", count);	
				informationList.add(count);
				
				summaryJsonObject.put("assetNumber", "TOTAL");	
				informationList.add("TOTAL");
				
				summaryJsonObject.put("noOfAccidents", totalNoOfAccidents);
				informationList.add(totalNoOfAccidents);
				
				summaryJsonObject.put("totalPayments", df.format(totalPayments));
				informationList.add(df.format(totalPayments));
				
				summaryJsonObject.put("totalReceipts", df.format(totalReceipts));	
				informationList.add(df.format(totalReceipts));
				
				summaryJsonObject.put("totalLossOfLife", totalLossOfLife);		
				informationList.add(totalLossOfLife);
				
				summaryJsonObject.put("totalInjured", totalInjured);		
				informationList.add(totalInjured);
				
				summaryJsonObject.put("totalCasesOpened", totalCasesOpened);	
				informationList.add(totalCasesOpened);
				
				summaryJsonObject.put("totalCasesClosed", totalCasesClosed);	
				informationList.add(totalCasesClosed);
										
				summaryJsonArray.put(summaryJsonObject);	
				reporthelper.setInformationList(informationList);
				summaryReportsList.add(reporthelper);
			}
			
			summaryFinalList.add(summaryJsonArray);
			finalreporthelper.setReportsList(summaryReportsList);
			finalreporthelper.setHeadersList(summaryHeadersList);
			summaryFinalList.add(finalreporthelper);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return summaryFinalList;
	}

	public JSONArray getAccidentVehicleNo(int systemId, int customerId) {
		JSONArray jsonArray = null;
		JSONObject jsonObject = null;

		Connection conAms = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			jsonArray = new JSONArray();
			conAms = DBConnection.getConnectionToDB("AMS");
			pstmt = conAms.prepareStatement(analysisStatements.GET_ACCIDENT_ASSET_NUMBER);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, customerId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				jsonObject = new JSONObject();
				jsonObject.put("VehicleNo", rs.getString("ASSET_NUMBER"));
				jsonArray.put(jsonObject);
			}

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(conAms, pstmt, rs);
		}
		return jsonArray;
	}

	public ArrayList<Object> getAccidentExpenditureDetails(int systemId,int customerId, String language, String assetNumber) {
		
		JSONArray detailsJsonArray = null;
		JSONObject detailsJsonObject = null;
				
		ArrayList<ReportHelper> detailsReportsList = new ArrayList<ReportHelper>();
		ArrayList<String> detailsHeadersList = new ArrayList<String>();
		ReportHelper finalreporthelper = new ReportHelper();
		ArrayList<Object> detailsFinalList = new ArrayList<Object>();
		
		Connection con = null;
		PreparedStatement pstmt = null;
		PreparedStatement pstmt1 = null;
		ResultSet rs = null;
		ResultSet rs1 = null;
		
		int count = 0;
			
		try {
			double totalPayments = 0;
			double totalReceipts = 0;
			double totalInsuranceAmount = 0;
			int totalLossOfLife = 0;
			int totalInjured = 0;
			
			detailsJsonArray = new JSONArray();
			
			detailsHeadersList.add(commonFunctions.getLabelFromDB("SLNO", language));
			detailsHeadersList.add(commonFunctions.getLabelFromDB("Asset_Number", language));
			detailsHeadersList.add(commonFunctions.getLabelFromDB("Case_Number", language));
			detailsHeadersList.add(commonFunctions.getLabelFromDB("Driver_Name", language));
			detailsHeadersList.add(commonFunctions.getLabelFromDB("Accidental_Type", language));
			detailsHeadersList.add(commonFunctions.getLabelFromDB("DateTime", language));
			detailsHeadersList.add(commonFunctions.getLabelFromDB("Location", language));
			detailsHeadersList.add(commonFunctions.getLabelFromDB("Total_Payments", language));
			detailsHeadersList.add(commonFunctions.getLabelFromDB("Total_Receipts", language));
			detailsHeadersList.add(commonFunctions.getLabelFromDB("Insurance_Claimed_Amount", language));
			detailsHeadersList.add(commonFunctions.getLabelFromDB("Total_Loss_Of_Life", language));
			detailsHeadersList.add(commonFunctions.getLabelFromDB("Total_Injured", language));
			detailsHeadersList.add(commonFunctions.getLabelFromDB("Case_Status", language));
									
			con = DBConnection.getConnectionToDB("AMS");		
			pstmt = con.prepareStatement(analysisStatements.GET_ACCIDENT_EXPENDITURE_DETAILS);
			pstmt.setString(1, assetNumber);
			pstmt.setInt(2, systemId);
			pstmt.setInt(3, customerId);
			rs = pstmt.executeQuery();
			while (rs.next()) {	
				detailsJsonObject = new JSONObject();
				count++;	
								
				ArrayList<Object> informationList = new ArrayList<Object>();
				ReportHelper reporthelper = new ReportHelper();	
				
				double totalPayment = 0;
				double totalReceipt = 0;
				
				pstmt1 = con.prepareStatement(analysisStatements.GET_AMOUNT_BASED_ON_TRANSACTION_TYPE);
				pstmt1.setInt(1,  rs.getInt("CASE_ID"));
				pstmt1.setInt(2, customerId);
				rs1 = pstmt1.executeQuery();
				while(rs1.next()){
					if(rs1.getInt("COMPENSATION_TYPE") == 10){
						totalPayment = rs1.getDouble("TRANSACTION_AMOUNT");
					} else if(rs1.getInt("COMPENSATION_TYPE") == 11){
						totalReceipt = rs1.getDouble("TRANSACTION_AMOUNT");
					}
				}
				

				detailsJsonObject.put("slnoIndex", count);	
				informationList.add(count);
				
				detailsJsonObject.put("assetNumber", rs.getString("ASSET_NUMBER"));	
				informationList.add(rs.getString("ASSET_NUMBER"));
				
				detailsJsonObject.put("caseNumber", rs.getString("CASE_NUMBER"));	
				informationList.add(rs.getString("CASE_NUMBER"));
				
				detailsJsonObject.put("driverName", rs.getString("DRIVER_NAME").toUpperCase());	
				informationList.add(rs.getString("DRIVER_NAME").toUpperCase());
				
				detailsJsonObject.put("accidentalType", rs.getString("ACCIDENTAL_TYPE"));	
				informationList.add(rs.getString("ACCIDENTAL_TYPE"));
				
				detailsJsonObject.put("dateTime", ddMMYYYYHHMMSS.format(rs.getTimestamp("ACCIDENT_DATE")));	
				informationList.add(ddMMYYYYHHMMSS.format(rs.getTimestamp("ACCIDENT_DATE")));
				
				detailsJsonObject.put("location", rs.getString("ACCIDENT_LOCATION"));	
				informationList.add(rs.getString("ACCIDENT_LOCATION"));
				
				detailsJsonObject.put("totalPayments", df.format(totalPayment));	
				informationList.add(df.format(totalPayment));
				totalPayments = totalPayments + totalPayment;
				
				detailsJsonObject.put("totalReceipts", df.format(totalReceipt));	
				informationList.add(df.format(totalReceipt));
				totalReceipts = totalReceipts + totalReceipt;
				
				detailsJsonObject.put("insuranceClaimedAmount", rs.getDouble("INSURANCE_AMOUNT"));	
				informationList.add(rs.getDouble("INSURANCE_AMOUNT"));
				totalInsuranceAmount = totalInsuranceAmount + rs.getDouble("INSURANCE_AMOUNT");
				
				detailsJsonObject.put("totalLossOfLife", rs.getInt("LOSS_OF_LIFE"));	
				informationList.add(rs.getInt("LOSS_OF_LIFE"));
				totalLossOfLife = totalLossOfLife + rs.getInt("LOSS_OF_LIFE");
				
				detailsJsonObject.put("totalInjured", rs.getInt("INJURED"));	
				informationList.add(rs.getInt("INJURED"));
				totalInjured = totalInjured + rs.getInt("INJURED");
				
				detailsJsonObject.put("caseStatus", rs.getString("CASE_STATUS"));	
				informationList.add(rs.getString("CASE_STATUS"));
														
				detailsJsonArray.put(detailsJsonObject);	
				reporthelper.setInformationList(informationList);
				detailsReportsList.add(reporthelper);
			}
			if(count > 0){	
				detailsJsonObject = new JSONObject();
				count++;	
								
				ArrayList<Object> informationList = new ArrayList<Object>();
				ReportHelper reporthelper = new ReportHelper();					

				detailsJsonObject.put("slnoIndex", count);	
				informationList.add(count);
				
				detailsJsonObject.put("assetNumber", "TOTAL");	
				informationList.add("TOTAL");
				
				detailsJsonObject.put("caseNumber", "");	
				informationList.add("");
				
				detailsJsonObject.put("driverName", "");	
				informationList.add("");
				
				detailsJsonObject.put("accidentalType", "");	
				informationList.add("");
				
				detailsJsonObject.put("dateTime", "");	
				informationList.add("");
				
				detailsJsonObject.put("location", "");	
				informationList.add("");
				
				detailsJsonObject.put("totalPayments", df.format(totalPayments));	
				informationList.add(df.format(totalPayments));
				
				detailsJsonObject.put("totalReceipts", df.format(totalReceipts));	
				informationList.add(df.format(totalReceipts));
				
				detailsJsonObject.put("insuranceClaimedAmount", totalInsuranceAmount);	
				informationList.add(totalInsuranceAmount);
				
				detailsJsonObject.put("totalLossOfLife", totalLossOfLife);	
				informationList.add(totalLossOfLife);
				
				detailsJsonObject.put("totalInjured", totalInjured);	
				informationList.add(totalInjured);
				
				detailsJsonObject.put("caseStatus", "");	
				informationList.add("");
														
				detailsJsonArray.put(detailsJsonObject);	
				reporthelper.setInformationList(informationList);
				detailsReportsList.add(reporthelper);
			}
			detailsFinalList.add(detailsJsonArray);
			finalreporthelper.setReportsList(detailsReportsList);
			finalreporthelper.setHeadersList(detailsHeadersList);
			detailsFinalList.add(finalreporthelper);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
			DBConnection.releaseConnectionToDB(null, pstmt1, rs1);
		}
		return detailsFinalList;
	}
}
