package t4u.functions;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.text.SimpleDateFormat;
import java.util.ArrayList;

import org.json.JSONArray;
import org.json.JSONObject;

import t4u.beans.ReportHelper;
import t4u.common.DBConnection;
import t4u.sandmining.ILMSDetails;
import t4u.statements.SandMiningStatements;

public class ILMSDetailsImportFunctions {

	public String saveImportedILMSDetails(int systemId, int customerId, int userId, JSONArray fuelJs, int offset,
			ArrayList<ILMSDetails> allILMSImporteddetails) {

		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String msg = "Error";
		SimpleDateFormat sdfFrom = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		SimpleDateFormat sdfTo = new SimpleDateFormat("dd-MM-yyyy HH:mm");
		String vehicleStatus = " ";
		try {
			con = DBConnection.getConnectionToDB("AMS");
			for (int i = 0; i < allILMSImporteddetails.size(); i++) {
				ILMSDetails iml = allILMSImporteddetails.get(i);
				if (iml.status.equals("Valid")) {
					String imlsVehicleNo = iml.vehicleNo.toUpperCase();
					pstmt = con.prepareStatement(
							SandMiningStatements.CHECK_VEHICLE_COMMUNICATION.replace("#", String.valueOf(systemId)));

					pstmt.setString(1, imlsVehicleNo);
					pstmt.setString(2, sdfFrom.format(sdfTo.parse(iml.passIssueDate)));
					pstmt.setString(3, sdfFrom.format(sdfTo.parse(iml.passIssueDate)));
					pstmt.setInt(4, systemId);
					pstmt.setInt(5, customerId);
					pstmt.setString(6, imlsVehicleNo);
					pstmt.setString(7, sdfFrom.format(sdfTo.parse(iml.passIssueDate)));
					pstmt.setString(8, sdfFrom.format(sdfTo.parse(iml.passIssueDate)));
					pstmt.setInt(9, systemId);
					pstmt.setInt(10, customerId);
					rs = pstmt.executeQuery();
					if (rs.next()) {
						vehicleStatus = "Communicating";
					} else {
						pstmt = con.prepareStatement(SandMiningStatements.CHECK_VEHICLE_NON_COMMUNICATION);
						pstmt.setString(1, imlsVehicleNo);
						//pstmt.setInt(2, systemId);
						//pstmt.setInt(3, customerId);
						rs = pstmt.executeQuery();
						if (rs.next()) {

							int SystemId = rs.getInt("SYSTEM_ID");
							int CustomerId = rs.getInt("CLIENT_ID");
							if (systemId != SystemId) {
								pstmt = con.prepareStatement(SandMiningStatements.CHECK_VEHICLE_COMMUNICATION
										.replace("#", String.valueOf(SystemId)));

								pstmt.setString(1, imlsVehicleNo);
								pstmt.setString(2, sdfFrom.format(sdfTo.parse(iml.passIssueDate)));
								pstmt.setString(3, sdfFrom.format(sdfTo.parse(iml.passIssueDate)));
								pstmt.setInt(4, SystemId);
								pstmt.setInt(5, CustomerId);
								pstmt.setString(6, imlsVehicleNo);
								pstmt.setString(7, sdfFrom.format(sdfTo.parse(iml.passIssueDate)));
								pstmt.setString(8, sdfFrom.format(sdfTo.parse(iml.passIssueDate)));
								pstmt.setInt(9, SystemId);
								pstmt.setInt(10, CustomerId);
								rs = pstmt.executeQuery();
								if (rs.next()) {
									vehicleStatus = "Communicating In Different Platform";
								} else {
									vehicleStatus = "Non Communicating In Different Platform";
								}
							} else {
								vehicleStatus = "Non Communicating";
							}

						} else {
							vehicleStatus = "Not Registered";
						}
					}
					pstmt = con.prepareStatement(SandMiningStatements.INSERT_ILMS_DETAILS);

					pstmt.setString(1, iml.MMPS_Tripsheet_Id);
					pstmt.setString(2, iml.MMPS_TripsheetCode);
					pstmt.setString(3, iml.PermitNo);
					pstmt.setString(4, iml.LeaseCode);
					pstmt.setString(5, iml.Leasee_Name);
					pstmt.setString(6, iml.mineral);
					pstmt.setString(7, iml.grade);
					pstmt.setString(8, iml.miningPlace_E);
					pstmt.setString(9, iml.TotalQuantity);
					pstmt.setString(10, iml.issueStatus);
					pstmt.setString(11, sdfFrom.format(sdfTo.parse(iml.journyStartDate)));
					pstmt.setString(12, sdfFrom.format(sdfTo.parse(iml.journyEndDate)));
					pstmt.setString(13, iml.buyer);
					pstmt.setString(14, iml.destination);
					pstmt.setString(15, iml.hologramCode);
					pstmt.setString(16, imlsVehicleNo);
					pstmt.setString(17, sdfFrom.format(sdfTo.parse(iml.passIssueDate)));
					pstmt.setString(18, iml.actualWeight);
					pstmt.setString(19, iml.transporterName);
					pstmt.setString(20, iml.distance);
					pstmt.setString(21, iml.TSrNo);
					pstmt.setString(22, iml.villageName);
					pstmt.setString(23, iml.routeDescription);
					pstmt.setString(24, iml.pwdFees);
					pstmt.setString(25, iml.weighWeight);
					pstmt.setString(26, iml.appType);
					pstmt.setString(27, iml.tripSheetType);
					pstmt.setString(28, iml.unit);
					pstmt.setString(29, iml.cancelReason);
					pstmt.setString(30, iml.printReason);
					pstmt.setString(31, iml.transferReason);
					pstmt.setString(32, iml.certNo);
					pstmt.setInt(33, systemId);
					pstmt.setInt(34, customerId);
					pstmt.setInt(35, userId);
					pstmt.setString(36, vehicleStatus);

					int p = pstmt.executeUpdate();
					if (p > 0) {
						msg = " Inserted Successfully..!!";
					}
				}

			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, null);
		}
		return msg;
	}

	@SuppressWarnings({ "unchecked", "rawtypes" })
	public ArrayList getIlmsCountDetails(int systemId, int customerId, String startDate, String endDate,
			JSONObject jsonObject, int offset) {

		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		JSONObject obj = null;
		JSONArray jsonarr = new JSONArray();

		ArrayList reportsList = new ArrayList();
		ArrayList headersList = new ArrayList();
		ReportHelper finalreporthelper = new ReportHelper();
		ArrayList finlist = new ArrayList();

		headersList.add("SLNO");
		headersList.add("Date Of Upload");
		headersList.add("Total ILMS passes issued (as per upload data)");
		headersList.add("Passes issued for GPS communicating vehicle");
		headersList.add("Passes issued for GPS Non-communicating vehicle");
		headersList.add("Vehicle number not matched or vehicle not registered ");

		con = DBConnection.getConnectionToDB("AMS");

		try {

			pstmt = con.prepareStatement(SandMiningStatements.GET_ILMS_VEHICLE_DETAILS_COUNT);
			pstmt.setString(1, startDate);
			pstmt.setString(2, endDate);
			pstmt.setInt(3, systemId);
			pstmt.setInt(4, customerId);
			rs = pstmt.executeQuery();
			int slnocount = 0;
			while (rs.next()) {
				obj = new JSONObject();
				ArrayList informationList = new ArrayList();
				ReportHelper reporthelper = new ReportHelper();

				slnocount++;
				obj.put("slnoIndex", slnocount);
				informationList.add(slnocount);

				obj.put("dateOfUploadIndex", rs.getString("PDATE"));
				informationList.add(rs.getString("PDATE"));

				int totcount = rs.getInt("Communicating") + rs.getInt("NonCommunicating") + rs.getInt("NotRegistered");
				obj.put("TotalILMSIndex", totcount);
				informationList.add(totcount);

				obj.put("GPScommunicatingIndex", rs.getInt("Communicating"));
				informationList.add(rs.getInt("Communicating"));

				obj.put("GPSnonCommunicationIndex", rs.getInt("NonCommunicating"));
				informationList.add(rs.getInt("NonCommunicating"));

				obj.put("VehicleNotmatchedIndex", rs.getInt("NotRegistered"));
				informationList.add(rs.getInt("NotRegistered"));

				jsonarr.put(obj);
				reporthelper.setInformationList(informationList);
				reportsList.add(reporthelper);
			}

			finalreporthelper.setReportsList(reportsList);
			finalreporthelper.setHeadersList(headersList);
		} catch (Exception ex) {
			ex.printStackTrace();
		} finally {
			finlist.add(jsonarr);
			finlist.add(finalreporthelper);
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return finlist;
	}

	@SuppressWarnings({ "unchecked", "rawtypes" })
	public ArrayList getInnerGridILMSDetails(int systemId, int customerId, String uploadedDate) {

		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		JSONObject obj = null;
		JSONArray jsonarr = new JSONArray();
		SimpleDateFormat sdfFrom = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		SimpleDateFormat sdfTo = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");

		ArrayList reportsList = new ArrayList();
		ArrayList headersList = new ArrayList();
		ReportHelper finalreporthelper = new ReportHelper();
		ArrayList finlist = new ArrayList();

		headersList.add("SLNO");
		headersList.add("Date Of Upload");
		headersList.add("Vehicle Number");
		headersList.add("MMPS Trip Sheet Id");
		headersList.add("MMPS Trip Sheet Code");
		headersList.add("Permit No.");
		headersList.add("Lease Code");
		headersList.add("Mining Place_E");
		headersList.add("Pass Issue Date");
		headersList.add("Journey Start Date");
		headersList.add("Journey End Date");
		headersList.add("Vehicle Status");

		con = DBConnection.getConnectionToDB("AMS");
		try {
			int count = 0;
			pstmt = con.prepareStatement(SandMiningStatements.GET_ILMS_VEHICLE_DETAILS);
			pstmt.setString(1, uploadedDate);
			pstmt.setString(2, uploadedDate + " 23:59:59");
			pstmt.setInt(3, systemId);
			pstmt.setInt(4, customerId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				obj = new JSONObject();
				ArrayList informationList = new ArrayList();
				ReportHelper reporthelper = new ReportHelper();
				count++;

				obj.put("grid2slnoIndex", count);
				informationList.add(count);

				obj.put("dateofuploadIndex", rs.getString("upload_date"));
				informationList.add(rs.getString("upload_date"));

				obj.put("VehicleNoindex", rs.getString("vehicle_no"));
				informationList.add(rs.getString("vehicle_no"));

				obj.put("mmpstripsheetIdIndex", rs.getString("tripsheet_id"));
				informationList.add(rs.getString("tripsheet_id"));

				obj.put("mmpstripsheetCodeIndex", rs.getString("tripsheet_code"));
				informationList.add(rs.getString("tripsheet_code"));

				obj.put("permitNoIndex", rs.getString("permit_no"));
				informationList.add(rs.getString("permit_no"));

				obj.put("leaseCodeIndex", rs.getString("lease_code"));
				informationList.add(rs.getString("lease_code"));

				obj.put("miningplaceIndex", rs.getString("mining_place"));
				informationList.add(rs.getString("mining_place"));

				obj.put("passIssueDateindex", sdfTo.format(sdfFrom.parse(rs.getString("pass_issue_date"))));
				informationList.add(sdfTo.format(sdfFrom.parseObject(rs.getString("pass_issue_date"))));

				obj.put("journeyStartDateindex", sdfTo.format(sdfFrom.parse(rs.getString("journey_start_date"))));
				informationList.add(sdfTo.format(sdfFrom.parseObject(rs.getString("journey_start_date"))));

				obj.put("journeyEndDateindex", sdfTo.format(sdfFrom.parse(rs.getString("journey_end_date"))));
				informationList.add(sdfTo.format(sdfFrom.parseObject(rs.getString("journey_end_date"))));

				obj.put("vehicleStatusIndex", rs.getString("vehicleStatus"));
				informationList.add(rs.getString("vehicleStatus"));

				jsonarr.put(obj);
				reporthelper.setInformationList(informationList);
				reportsList.add(reporthelper);

			}
			finalreporthelper.setReportsList(reportsList);
			finalreporthelper.setHeadersList(headersList);

		} catch (Exception ex) {
			ex.printStackTrace();
		} finally {
			finlist.add(jsonarr);
			finlist.add(finalreporthelper);
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return finlist;
	}
}
