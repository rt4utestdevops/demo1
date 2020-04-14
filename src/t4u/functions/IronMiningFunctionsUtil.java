package t4u.functions;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import t4u.statements.IronMiningStatement;

/**
 * 
 * @author Praveen K Chepuri
 *
 */

public class IronMiningFunctionsUtil implements IronMiningStatement {

	public synchronized ResultSet getPermitTripSheet(int customerId, String assetNo, int systemId, int pId,
			Connection conAdmin, String permitNo1) throws SQLException {
		PreparedStatement pstmt = conAdmin.prepareStatement(GET_PERMIT_QTY_TRIP_SHEET.replaceAll("#", permitNo1));
		pstmt.setInt(1, systemId);
		pstmt.setInt(2, customerId);
		pstmt.setString(3, assetNo);
		pstmt.setInt(4, pId);
		pstmt.setInt(5, systemId);
		pstmt.setInt(6, customerId);
		return pstmt.executeQuery();
	}

	public synchronized ResultSet getPermitCount(int systemId, int pId, Connection conAdmin) throws SQLException {
		PreparedStatement pstmt = conAdmin.prepareStatement(GET_TRIP_COUNT);
		pstmt.setInt(1, systemId);
		pstmt.setInt(2, pId);
		pstmt.setInt(3, systemId);
		pstmt.setInt(4, pId);
		return pstmt.executeQuery();
	}

	public synchronized void insertActualQuantity(int pId, float actualQuantity, Connection conAdmin, int tripSheetNo)
			throws SQLException {
		PreparedStatement pstmt = conAdmin.prepareStatement(INSERT_ACTUAL_QUANTITY);
		pstmt.setInt(1, tripSheetNo);
		pstmt.setFloat(2, actualQuantity);
		pstmt.setInt(3, pId);
		pstmt.executeUpdate();
	}

	public synchronized ResultSet getPermitNo(int customerId, int userId, int systemId, Connection conAdmin)
			throws SQLException {
		PreparedStatement pstmt = conAdmin
				.prepareStatement(GET_PERMIT_NO.replace("and ts.TYPE!='Close'", "and ts.TYPE!='Open'"));
		pstmt.setInt(1, systemId);
		pstmt.setInt(2, customerId);
		pstmt.setInt(3, userId);
		return pstmt.executeQuery();
	}

	public synchronized int updateQuantityForTareAndCloseTrip(String assetNo, String quantity, int userId,
			String closingType, String closeQuantity, String type, int tripNo, String closeReason, Connection conAdmin,
			String lastCommDate, String lastCommLoc) throws SQLException {
		PreparedStatement pstmt = conAdmin.prepareStatement(UPDATE_QUANTITY_FOR_TARE_AND_CLOSE_TRIP);
		pstmt.setString(1, quantity);
		pstmt.setString(2, closeQuantity);
		pstmt.setInt(3, userId);
		pstmt.setString(4, closingType);
		pstmt.setString(5, type);
		pstmt.setString(6, closeReason);
		pstmt.setString(7, lastCommLoc);
		pstmt.setString(8, lastCommDate);
		pstmt.setInt(9, tripNo);
		pstmt.setString(10, assetNo);
		return pstmt.executeUpdate();
	}

	public synchronized void updateImportQuantityInOrgMaster(Connection conAdmin, int orgCode, float impFines,
			float impLumps, float impConc, float impTailings) throws SQLException {
		PreparedStatement pstmt = conAdmin.prepareStatement(UPDATE_IMPORT_QTY_IN_ORG_MASTER);
		pstmt.setFloat(1, impFines);
		pstmt.setFloat(2, impLumps);
		pstmt.setFloat(3, impConc);
		pstmt.setFloat(4, impTailings);
		pstmt.setInt(5, orgCode);
		pstmt.executeUpdate();
	}

	public synchronized void updateROMQuantityInPlantMaster(int customerId, int systemId, Connection conAdmin,
			String mineraltype, float netQty, int plantId) throws SQLException {
		PreparedStatement pstmt = conAdmin.prepareStatement(UPDATE_ROM_QTY_IN_PLANT_MASTER);
		pstmt.setFloat(1, netQty);
		pstmt.setInt(2, plantId);
		pstmt.setInt(3, systemId);
		pstmt.setInt(4, customerId);
		pstmt.setString(5, mineraltype);
		pstmt.executeUpdate();
	}

	public synchronized void insertStockDetailsForROM(int customerId, int systemId, Connection conAdmin,
			String mineraltype, int orgCode, float netQty, int destinationhub) throws SQLException {
		PreparedStatement pstmt = conAdmin.prepareStatement(INSERT_INTO_STOCK_DEATILS_FOR_ROM);
		pstmt.setInt(1, destinationhub);
		pstmt.setInt(2, orgCode);
		pstmt.setFloat(3, netQty);
		pstmt.setInt(4, systemId);
		pstmt.setInt(5, customerId);
		pstmt.setString(6, mineraltype);
		pstmt.executeUpdate();
	}

	public synchronized void updateROMQuantityInMaster(int customerId, int systemId, Connection conAdmin,
			String mineraltype, int orgCode, float netQty, int destinationhub) throws SQLException {
		PreparedStatement pstmt = conAdmin.prepareStatement(UPDATE_ROM_QTY_IN_MASTER);
		pstmt.setFloat(1, netQty);
		pstmt.setInt(2, systemId);
		pstmt.setInt(3, customerId);
		pstmt.setInt(4, destinationhub);
		pstmt.setInt(5, orgCode);
		pstmt.setString(6, mineraltype);
		pstmt.executeUpdate();
	}

	public synchronized int modifyTripSheetNoInformation(int customerId, String validityDateTime, String grade,
			int systemId, String routeModify, String uniqueId, String order, Connection conAdmin) throws SQLException {
		PreparedStatement pstmt = conAdmin.prepareStatement(MODIFY_TRIP_SHEET_NO_INFORMATION);
		pstmt.setString(1, validityDateTime);
		pstmt.setString(2, grade);
		pstmt.setInt(3, Integer.parseInt(routeModify));
		pstmt.setString(4, order);
		pstmt.setInt(5, systemId);
		pstmt.setInt(6, customerId);
		pstmt.setString(7, uniqueId);
		return pstmt.executeUpdate();
	}

	public synchronized void updateTripStatusInAssetEnrollment(int customerId, String assetNo, int systemId,
			Connection conAdmin, String status) throws SQLException {
		PreparedStatement pstmt = conAdmin.prepareStatement(UPDATE_TRIP_STATUS_IN_ASSET_ENROLMENT);
		pstmt.setString(1, status);
		pstmt.setString(2, assetNo);
		pstmt.setInt(3, systemId);
		pstmt.setInt(4, customerId);
		pstmt.executeUpdate();
	}

	public synchronized void insertIntoStockYardMaster(int customerId, int systemId, Connection conAdmin,
			String mineraltype, int orgCode, int destinationhub, float fines, float lumps, float concentrates,
			float tailings, float totalqty) throws SQLException {
		PreparedStatement pstmt = conAdmin.prepareStatement(INSERT_INTO_STOCK_DEATILS);
		pstmt.setInt(1, destinationhub);
		pstmt.setInt(2, orgCode);
		pstmt.setFloat(3, lumps);
		pstmt.setFloat(4, fines);
		pstmt.setFloat(5, totalqty);
		pstmt.setInt(6, systemId);
		pstmt.setInt(7, customerId);
		pstmt.setString(8, mineraltype);
		pstmt.setFloat(9, concentrates);
		pstmt.setFloat(10, tailings);
		pstmt.executeUpdate();
	}

	public synchronized int updateQuantiryForTare(String assetNo, String quantity, Connection conAdmin)
			throws SQLException {
		PreparedStatement pstmt = conAdmin.prepareStatement(UPDATE_QUANTITY_FOR_TARE);
		pstmt.setString(1, quantity);
		pstmt.setString(2, assetNo);
		return pstmt.executeUpdate();
	}

	public synchronized void updateMiningStockYardMaster(int customerId, int systemId, Connection conAdmin,
			String mineraltype, int orgCode, int destinationhub, float fines, float lumps, float concentrates,
			float tailings, float totalqty) throws SQLException {
		PreparedStatement pstmt = conAdmin.prepareStatement(UPDATE_MINING_STOCKYARD_MASTER);
		pstmt.setFloat(1, fines);
		pstmt.setFloat(2, lumps);
		pstmt.setFloat(3, concentrates);
		pstmt.setFloat(4, tailings);
		pstmt.setFloat(5, totalqty);
		pstmt.setInt(6, systemId);
		pstmt.setInt(7, customerId);
		pstmt.setInt(8, destinationhub);
		pstmt.setInt(9, orgCode);
		pstmt.setString(10, mineraltype);
		pstmt.executeUpdate();
	}

	public synchronized ResultSet getCurrentLocation(int customerId, String assetNo, int systemId, Connection conAdmin)
			throws SQLException {
		PreparedStatement pstmt;
		pstmt = conAdmin.prepareStatement(GET_CURRENT_LOC);
		pstmt.setString(1, assetNo);
		pstmt.setInt(2, systemId);
		pstmt.setInt(3, customerId);
		return pstmt.executeQuery();
	}

	public synchronized int updatQuantityForClose(String assetNo, String quantity, int userId, String closingType,
			String type, int tripNo, String closeReason, Connection conAdmin, String lastCommLoc, String lastCommDate)
			throws SQLException {
		PreparedStatement pstmt = conAdmin.prepareStatement(UPDATE_QUANTITY_FOR_CLOSE);
		pstmt.setString(1, quantity);
		pstmt.setInt(2, userId);
		pstmt.setString(3, closingType);
		pstmt.setString(4, type);
		pstmt.setString(5, closeReason);
		pstmt.setString(6, lastCommLoc);
		pstmt.setString(7, lastCommDate);
		pstmt.setInt(8, tripNo);
		pstmt.setString(9, assetNo);
		return pstmt.executeUpdate();
	}

	public synchronized int updateQuantiryForTareAndTripClose(String assetNo, int userId, String tareqty,
			String grossQty, String closingType, String type, int tripNo, Connection conAdmin, String lastCommLoc,
			String lastCommDate) throws SQLException {
		PreparedStatement pstmt = conAdmin.prepareStatement(UPDATE_QUANTITY_FOR_TARE_AND_CLOSE_TRIP);
		pstmt.setString(1, tareqty);
		pstmt.setString(2, grossQty);
		pstmt.setInt(3, userId);
		pstmt.setString(4, closingType);
		pstmt.setString(5, type);
		pstmt.setString(6, "");
		pstmt.setString(7, lastCommLoc);
		pstmt.setString(8, lastCommDate);
		pstmt.setInt(9, tripNo);
		pstmt.setString(10, assetNo);
		return pstmt.executeUpdate();
	}

	public synchronized void updateImportQuantiryInOrgMaster(Connection conAdmin, int orgCode, float impFines,
			float impLumps, float impConc, float impTailings) throws SQLException {
		PreparedStatement pstmt = conAdmin.prepareStatement(UPDATE_IMPORT_QTY_IN_ORG_MASTER);
		pstmt.setFloat(1, impFines);
		pstmt.setFloat(2, impLumps);
		pstmt.setFloat(3, impConc);
		pstmt.setFloat(4, impTailings);
		pstmt.setInt(5, orgCode);
		pstmt.executeUpdate();
	}
	
	public synchronized void updateBargeStatusAndRouteToTripDetails(int clientId, int systemId, int bargeId, Connection con, String routeId) throws SQLException {
		PreparedStatement pstmt = con.prepareStatement(UPDATE_BARGE_STATUS_AND_ROUTE_TO_TRIP_DETAILS);
		pstmt.setInt(1, Integer.parseInt(routeId));
		pstmt.setInt(2, systemId);
		pstmt.setInt(3, clientId);
		pstmt.setInt(4, bargeId);
		pstmt.executeUpdate();
	}
	
	public synchronized void updateBargeQuantityToTripDetails(int customerId, int systemId, float actualQuantity, int bargeId,
			Connection conAdmin) throws SQLException {
		PreparedStatement pstmt = conAdmin.prepareStatement(UPDATE_BARGE_QUANTITY_TO_TRIP_DETAILS);
		pstmt.setFloat(1, actualQuantity);
		pstmt.setInt(2, systemId);
		pstmt.setInt(3, customerId);
		pstmt.setInt(4, bargeId);
		pstmt.executeUpdate();
	}
	
	public synchronized void updatePRQuantityInOrgmaster(int buyOrgId, Connection con, float permitqty)
			throws SQLException {
		PreparedStatement pstmt = con.prepareStatement(UPDATE_PR_QTY_IN_ORG_MASTER);
		pstmt.setFloat(1, permitqty);
		pstmt.setInt(2, buyOrgId);
		pstmt.executeUpdate();
	}
	
	public synchronized void updateStockDetailsForPermitClosure(float fines, float lumps, float concentrates,
			float tailings, int customerId, int systemId, String orgCode, String mineralType, Connection con, float qty,
			String stockType) throws SQLException {
		PreparedStatement pstmt = con.prepareStatement(UPDATE_STOCK_DETAILS_FOR_PERMIT_CLOSURE);
		pstmt.setFloat(1, fines);
		pstmt.setFloat(2, lumps);
		pstmt.setFloat(3, concentrates);
		pstmt.setFloat(4, tailings);
		if (fines == 0 && lumps == 0 && concentrates == 0 && tailings == 0) {
			pstmt.setFloat(5, 0);
			pstmt.setFloat(6, qty);
		} else {
			pstmt.setFloat(5, qty);
			pstmt.setFloat(6, 0);
		}
		pstmt.setInt(7, systemId);
		pstmt.setInt(8, customerId);
		pstmt.setInt(9, Integer.parseInt(stockType));
		pstmt.setInt(10, Integer.parseInt(orgCode));
		pstmt.setString(11, mineralType);
		pstmt.executeUpdate();
	}
	
	public synchronized int updatePermitClosureDetails(String permitno, int userId, String closedqty, String permitQty,
			String refundType, Connection con, String status) throws SQLException {
		int updated;
		PreparedStatement pstmt = con.prepareStatement(UPDATE_PERMIT_CLOSURE_DETAILS);
		pstmt.setString(1, closedqty);
		pstmt.setInt(2, userId);
		pstmt.setInt(3, userId);
		pstmt.setString(4, permitQty);
		pstmt.setString(5, status);
		pstmt.setString(6, refundType);
		pstmt.setInt(7, Integer.parseInt(permitno));
		updated = pstmt.executeUpdate();
		return updated;
	}
	
	public synchronized void updateEWalletForROMClosure(int tcid, Connection con, float usedAmt,
			float mplBalance) throws SQLException {
		PreparedStatement pstmt = con.prepareStatement(UPDATE_E_WALLET_FOR_ROM_CLOSURE);
		pstmt.setFloat(1, usedAmt);
		pstmt.setFloat(2, mplBalance);
		pstmt.setFloat(3, mplBalance);
		pstmt.setInt(4, tcid);
		pstmt.executeUpdate();
	}
	
	public synchronized void updateProcessingFeeInOrgMaster(int customerId, int systemId, String orgCode, String processingFee,
			Connection con) throws SQLException {
		PreparedStatement pstmt = con.prepareStatement(UPDATE_PROCESSING_FEE_IN_ORG_MASTER);
		pstmt.setFloat(1, Float.parseFloat(processingFee));
		pstmt.setInt(2, Integer.parseInt(orgCode));
		pstmt.setInt(3, systemId);
		pstmt.setInt(4, customerId);
		pstmt.executeUpdate();
	}

	
	public synchronized void updateOrgDetails(int customerId, int systemId, Connection con,
			String stockType, float lumps, float fines, float concentrates, float tailings) throws SQLException {
		PreparedStatement pstmt = con.prepareStatement(UPDATE_ORG_DETAILS);
		pstmt.setFloat(1, fines);
		pstmt.setFloat(2, lumps);
		pstmt.setFloat(3, concentrates);
		pstmt.setFloat(4, tailings);
		pstmt.setInt(5, systemId);
		pstmt.setInt(6, customerId);
		pstmt.setInt(7, Integer.parseInt(stockType));
		pstmt.executeUpdate();
	}

	public synchronized ResultSet saveMiningTripSheetInformation(int customerId, String type, String assetNo,
			String leaseName, String quantity, String validityDateTime, String grade, String routeId, int userId,
			int systemId, String quantity1, String srcHubId, String desHubId, String permitNo, int pId,
			int userSettingId, int orgCode, String rsSource, String rsDestination, String transactionNo, String order,
			Connection conAdmin, String lastCommDate, String lastCommLoc, String commStatus, int tripSheetNo,
			String tripSheetNotoGrid) throws SQLException {
		PreparedStatement pstmt = conAdmin.prepareStatement(SAVE_MINING_TRIP_SHEET_INFORMATION,
				PreparedStatement.RETURN_GENERATED_KEYS);
		pstmt.setString(1, permitNo + "-" + tripSheetNotoGrid);
		pstmt.setString(2, type);
		pstmt.setString(3, assetNo);
		pstmt.setInt(4, Integer.parseInt(leaseName));
		pstmt.setString(5, validityDateTime);
		pstmt.setString(6, grade);
		pstmt.setString(7, quantity);
		pstmt.setInt(8, Integer.parseInt(routeId));
		pstmt.setInt(9, systemId);
		pstmt.setInt(10, customerId);
		pstmt.setString(11, quantity1);
		pstmt.setString(12, srcHubId);
		pstmt.setString(13, desHubId);
		pstmt.setInt(14, pId);
		pstmt.setInt(15, userId);
		pstmt.setInt(16, userSettingId);
		pstmt.setInt(17, orgCode);
		pstmt.setString(18, rsSource);
		pstmt.setString(19, rsDestination);
		pstmt.setString(20, transactionNo);
		pstmt.setInt(21, tripSheetNo);
		pstmt.setString(22, commStatus);
		pstmt.setString(23, order);
		pstmt.setString(24, lastCommLoc);
		pstmt.setString(25, lastCommDate);
		pstmt.executeUpdate();
		return pstmt.getGeneratedKeys();
	}
}
