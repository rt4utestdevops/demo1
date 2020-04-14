package t4u.functions;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import t4u.common.DBConnection;
import t4u.statements.CommonStatements;
import t4u.statements.CreateTripStatement;

public class TripCloseOrReopenThread implements Runnable{
	private String action;
	private int userId;
	private String remarksData;
	private int tripId;
	private String vehicleNo;
	private LogWriter logWriter;
	private String tripStatus; 
	private String endLocation;
	private String ata;
	private int offset;
	private int systemId;
	private int clientId;
	private String status;
	private String tripEndTime;
	private String atp;
	private String atd;
	private boolean atpChanged;
	private boolean atdChanged;
	private boolean ataChanged;
	private boolean tripEndTimeChanged;
	
	SimpleDateFormat sdfDB = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
	
	public TripCloseOrReopenThread(String action, int userId, String remarksData, int tripId, String vehicleNo, LogWriter logWriter, 
			String tripStatus, String endLocation, String ata, int offset, int systemId, int clientId, String status) {
		this(action, userId, remarksData, tripId, vehicleNo, logWriter, tripStatus, endLocation, ata, offset, systemId, 
				clientId, status, null, null, null, false, false, false, false);
	}
	public TripCloseOrReopenThread(String action, int userId, String remarksData, int tripId, String vehicleNo, LogWriter logWriter, 
			String tripStatus, String endLocation, String ata, int offset, int systemId, int clientId, String status,
			String tripEndTime,String atp, String atd,boolean atpChanged, boolean atdChanged, boolean ataChanged, boolean tripEndTimeChanged) {
		this.action = action;
		this.userId = userId;
		this.remarksData = remarksData;
		this.tripId = tripId;
		this.vehicleNo = vehicleNo;
		this.logWriter = logWriter;
		this.tripStatus = tripStatus;
		this.endLocation = endLocation;
		this.ata = ata;
		this.offset = offset;
		this.systemId = systemId;
		this.clientId = clientId;
		this.status = status;
		this.tripEndTime = tripEndTime;
		this.atp = atp;
		this.atd = atd;
		this.atpChanged = atpChanged;
		this.atdChanged =atdChanged;
		this.ataChanged = ataChanged;
		this.tripEndTimeChanged = tripEndTimeChanged;
	}
	private PreparedStatement pstmt, pstmt1;
	private ResultSet rs;
	SimpleDateFormat yyyymmdd = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	SimpleDateFormat sfddMMYYYY = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
	CTDashboardFunctions ctf = new CTDashboardFunctions();
	CommonFunctions cf = new CommonFunctions();
	public void run() {
		Connection con = null;
		try{
			con = DBConnection.getConnectionToDB("AMS");
			if(action.equals("REOPEN")){
				reopenTripMethod(con);
			} else if(action.equals("CLOSE")){
				closeTripMethod(con);
			} else if (action.equals("CANCEL")){
				cancelTripMethod(con);
			}else if(action.equals("ACTUALSUPDATE")){
				updateActuals(con);
			}
		}catch(final Exception e){
			e.printStackTrace();
		}finally{
			DBConnection.releaseConnectionToDB(con, pstmt, null);
		}
	}

	private void updateActuals(Connection con) throws SQLException, ParseException {
		String atpLocal = yyyymmdd.format(sfddMMYYYY.parse(atp + ":00"));
		String atdLocal = yyyymmdd.format(sfddMMYYYY.parse(atd + ":00"));
		String ataLocal = yyyymmdd.format(sfddMMYYYY.parse(ata + ":00"));
		String localTripEnd = yyyymmdd.format(sfddMMYYYY.parse(tripEndTime + ":00"));
		
		String statement = CreateTripStatement.UPDATE_TRACK_TRIP_DETAILS_ON_UPDATE_ACTUALS;
		if(atpChanged || atdChanged){
			statement = statement.replace("#", ",ACT_SRC_ARR_DATETIME=dateadd(mi,-"+offset+",'"+atpLocal+"'),ACTUAL_TRIP_START_TIME=dateadd(mi,-"+offset+",'"+atdLocal+"')," +
					"DEST_ARR_TIME_ON_ATD=dateadd(mi,PLANNED_DURATION,dateadd(mi,-"+offset+",'"+atdLocal+"')),OVERRIDDEN_BY="+userId+",OVERRIDDEN_DATETIME=getutcDate() # ");
		}
		if(ataChanged){//UPDATE ETA
			String ataUpdate = yyyymmdd.format(sfddMMYYYY.parse(ata + ":00"));
			statement = statement.replace("#", ",ATA_OVERIDDEN_BY="+userId+",ATA_OVERIDDEN_DATETIME=getutcdate(),DESTINATION_ETA="+"dateadd(mi,-"+offset+",'"+ataUpdate+"')"+",NEXT_LEG_ETA="+"dateadd(mi,-"+offset+",'"+ataUpdate+"')"+"#");
			//statement = statement.replace("#", ",ATA_OVERIDDEN_BY="+userId+",ATA_OVERIDDEN_DATETIME=getutcdate() # ");
		}
		if(tripEndTimeChanged){
			statement = statement.replace("#", ", ACTUAL_TRIP_END_TIME=dateadd(mi,-"+offset+",'"+localTripEnd+"')");
		}
		statement = statement.replace("#", "");
		pstmt = con.prepareStatement(statement);
		pstmt.setInt(1, offset);
		pstmt.setString(2, atdLocal);
		pstmt.setInt(3, offset);
		pstmt.setString(4, ataLocal);
		pstmt.setInt(5, tripId);
		pstmt.executeUpdate();
		
		//update DES_TRIP_DETAILS ATP, ATD & ATA 
		if(atpChanged || atdChanged){
			updateATPAndATDToTDesTripTable(con);
			updateATDToTripLegDetails(con);
		}
		if(ataChanged){
			updateDestinationATA(con,yyyymmdd.format(sfddMMYYYY.parse(ata + ":00")));
			updateATAToTripLegDetails(con, yyyymmdd.format(sfddMMYYYY.parse(ata + ":00")));
		}
		
		updateSubTripTableForStatusAndSLARecalculate(con,"CLOSED","Y",tripId);
		
	}
	private void cancelTripMethod(Connection con) throws SQLException {
		pstmt = con.prepareStatement(CreateTripStatement.UPDATE_TO_CLOSE_TRIP);
		pstmt.setInt(1, userId);
		pstmt.setString(2, remarksData);
		pstmt.setString(3, endLocation);
		pstmt.setInt(4, tripId);
		int updated=pstmt.executeUpdate();
		if(updated > 0){
			if(systemId == 268){
				try {
					ctf.disassociateVehicles(con,systemId, clientId, vehicleNo,tripId,logWriter);
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
			pstmt1 = con.prepareStatement("UPDATE dbo.gpsdata_history_latest set DRIVER_NAME = '', DRIVER_MOBILE='' " +
			"where REGISTRATION_NO = ? and  System_id=?");
			pstmt1.setString(1, vehicleNo);
			pstmt1.setInt(2, systemId);
			pstmt1.executeUpdate();
				
			if(!status.equals("UPCOMING")){	
				pstmt1 = con.prepareStatement(CreateTripStatement.GET_VEHICLE_NO_AND_ACT_ARR_DATETIME_FOR_TRIP_CREATION_VALIDATION.replace("#", "AND td.TRIP_ID != ?"));
				pstmt1.setInt(1,offset);
				pstmt1.setString(2,vehicleNo);
				pstmt1.setInt(3,systemId);
				pstmt1.setInt(4,clientId);
				pstmt1.setInt(5,tripId);
				rs = pstmt1.executeQuery();
				if(rs.next()){
						updateVehicleStatus(con, vehicleNo, 8, 0,logWriter,0);
				}else{
					updateVehicleStatus(con, vehicleNo, 16, 0, logWriter,0);
				}
				/*Vinay H
				 * updating the coming trips status to 'OPEN'
				 */
				try{
					cf.updateUpcomingTripStatusToOpen(con,vehicleNo,tripId,clientId,logWriter);
				}catch(final Exception e){
					logWriter.log("Exception occurred while updating the upcoming trip :"+tripId, LogWriter.ERROR);
				}
			}
		}
	}

	private void closeTripMethod(Connection con) throws SQLException, ParseException {
		String atpLocal = yyyymmdd.format(sfddMMYYYY.parse(atp + ":00"));
		String atdLocal = yyyymmdd.format(sfddMMYYYY.parse(atd + ":00"));
		String ataLocal = yyyymmdd.format(sfddMMYYYY.parse(ata + ":00"));
		if ("REOPEN".equalsIgnoreCase(tripStatus)) {
			String statement = CreateTripStatement.UPDATE_TRACK_TRIP_DETAILS;
			if(atpChanged || atdChanged){
				statement = statement.replace("#", ",ACT_SRC_ARR_DATETIME=dateadd(mi,-"+offset+",'"+atpLocal+"'),ACTUAL_TRIP_START_TIME=dateadd(mi,-"+offset+",'"+atdLocal+"')," +
						"DEST_ARR_TIME_ON_ATD=dateadd(mi,PLANNED_DURATION,dateadd(mi,-"+offset+",'"+atdLocal+"')),OVERRIDDEN_BY="+userId+",OVERRIDDEN_DATETIME=getutcDate() # ");
			}
			if(ataChanged){
				statement = statement.replace("#", ",ATA_OVERIDDEN_BY="+userId+",ATA_OVERIDDEN_DATETIME=getutcdate() ");
			}
			statement = statement.replace("#", "");
			pstmt = con.prepareStatement(statement);
			pstmt.setInt(1, userId);
			pstmt.setString(2, remarksData);
			pstmt.setString(3, "CLOSED");
			pstmt.setInt(4, offset);
			pstmt.setString(5, atdLocal);
			pstmt.setInt(6, offset);
			pstmt.setString(7, ataLocal);
			pstmt.setInt(8, tripId);
			pstmt.executeUpdate();
			
			//update DES_TRIP_DETAILS ATP, ATD & ATA 
			if(atpChanged || atdChanged){
				updateATPAndATDToTDesTripTable(con);
				
				updateATDToTripLegDetails(con);
			}
			if(ataChanged){
				updateDestinationATA(con,yyyymmdd.format(sfddMMYYYY.parse(ata + ":00")));
				
				updateATAToTripLegDetails(con, yyyymmdd.format(sfddMMYYYY.parse(ata + ":00")));
			}
		} else {
			if(con == null){
				con = DBConnection.getConnectionToDB("AMS");
			}
			// ATA is mandatory, hence always flow go to if block
			ata = yyyymmdd.format(sfddMMYYYY.parse(ata + ":00"));
			String mainTripQuery = CreateTripStatement.UPDATE_MAIN_TRIP;
			if(atpChanged || atdChanged){
				mainTripQuery = mainTripQuery.replace("#", ",ACT_SRC_ARR_DATETIME=dateadd(mi,-"+offset+",'"+atpLocal+"'),ACTUAL_TRIP_START_TIME=dateadd(mi,-"+offset+",'"+atdLocal+"')," +
						"DEST_ARR_TIME_ON_ATD=dateadd(mi,PLANNED_DURATION,dateadd(mi,-"+offset+",'"+atdLocal+"')),OVERRIDDEN_BY="+userId+",OVERRIDDEN_DATETIME=getutcDate() # ");
			}
			if(ataChanged){//UPDATE ETA
				mainTripQuery = mainTripQuery.replace("#", ",ATA_OVERIDDEN_BY="+userId+",ATA_OVERIDDEN_DATETIME=getutcdate(),DESTINATION_ETA="+"dateadd(mi,-"+offset+",'"+ata+"')"+",NEXT_LEG_ETA="+"dateadd(mi,-"+offset+",'"+ata+"')");
				//mainTripQuery = mainTripQuery.replace("#", ",ATA_OVERIDDEN_BY="+userId+",ATA_OVERIDDEN_DATETIME=getutcdate() ");
			}
			mainTripQuery = mainTripQuery.replace("#", "");
			pstmt = con.prepareStatement(mainTripQuery);
			pstmt.setString(1, "CLOSED");
			pstmt.setString(2, "N");
			pstmt.setInt(3, userId);
			pstmt.setString(4, remarksData);
			pstmt.setString(5, endLocation);
			pstmt.setInt(6, offset);
			pstmt.setString(7, yyyymmdd.format(sfddMMYYYY.parse(atd + ":00")));
			pstmt.setInt(8, offset);
			pstmt.setString(9, ata);
			pstmt.setInt(10, tripId);
			pstmt.executeUpdate();
			logWriter.log("Closed Trip. Updated main table : "+tripId, LogWriter.INFO);
			
			//update DES_TRIP_DETAILS ATP,ATD & ATA
			if(atpChanged || ataChanged){
				updateATPAndATDToTDesTripTable(con);
				updateATDToTripLegDetails(con);
			}
			if(ataChanged){
				updateDestinationATA(con,ata);
				updateATAToTripLegDetails(con,ata);
			}
			logWriter.log("Closed Trip. Updated DES details : "+tripId, LogWriter.INFO);
			
			logWriter.log("Closed Trip. Updated leg details : "+tripId, LogWriter.INFO);
		}
		if(con == null){
			con = DBConnection.getConnectionToDB("AMS");
		}
		updateSubTripTableForStatusAndSLARecalculate(con,"CLOSED","Y",tripId);
		logWriter.log("Closed Trip. Updated sub trip table : "+tripId, LogWriter.INFO);
		
		//Vinay H :-  updating the coming trips status to 'OPEN'
		try{
			cf.updateUpcomingTripStatusToOpen(con,vehicleNo,tripId,clientId,logWriter);
		}catch(final Exception e){
			logWriter.log("Exception occurred while updating the upcoming trip :"+tripId, LogWriter.ERROR);
		}
		try {
			ctf.disassociateVehicles(con,systemId, clientId, vehicleNo,tripId,logWriter);
		} catch (Exception e) {
			logWriter.log("Disassociation of CT user and vehicle failed : "+tripId, LogWriter.INFO);
		}
		boolean isExist = isVehicleOnTrip(con, offset, vehicleNo, systemId, clientId, tripId);
		if(!isExist){
			updateVehicleStatus(con,vehicleNo, 16, 0, logWriter,0);
		}
	}
	private void updateATDToTripLegDetails(Connection con) throws SQLException, ParseException {
		pstmt = con.prepareStatement(CreateTripStatement.UPDATE_ATD_TO_TRIP_LEG_DETAILS);
		pstmt.setInt(1, offset);
		pstmt.setString(2, yyyymmdd.format(sfddMMYYYY.parse(atd + ":00")));
		pstmt.setInt(3, tripId);
		pstmt.setInt(4, tripId);
		pstmt.executeUpdate();
	}
	private void reopenTripMethod(Connection con) throws SQLException {
		logWriter.log("Reopeneing Trip : "+tripId, LogWriter.INFO);
		pstmt = con.prepareStatement(CreateTripStatement.UPDATE_TRACK_TRIP_DETAILS_ON_REOPEN);
		pstmt.setInt(1, userId);
		pstmt.setString(2, remarksData);
		pstmt.setString(3, "OPEN");
		pstmt.setInt(4, tripId);
		pstmt.executeUpdate();
		logWriter.log("Reopening Trip. Main Trip updated : "+tripId, LogWriter.INFO);
		
		updateSubTripTableForStatusAndSLARecalculate(con,"REOPEN","N",tripId);
		logWriter.log("Reopening Trip. Sub Trip table updated : "+tripId, LogWriter.INFO);

		pstmt = con.prepareStatement(CreateTripStatement.UPDATE_DES_TRIP_DETAILS_ON_REOPEN);
		pstmt.setInt(1, tripId);
		pstmt.executeUpdate();
		logWriter.log("Reopening Trip. des table updated : "+tripId, LogWriter.INFO);
		
		updateVehicleStatus(con,vehicleNo, 8, 0,logWriter,0);
	}
	private void updateATAToTripLegDetails(Connection con, String ata) throws SQLException {
		pstmt1 = con.prepareStatement(CreateTripStatement.UPDATE_TRIP_LEG_DETAILS_WHILE_CLOSING);
		pstmt1.setInt(1, offset);
		pstmt1.setString(2, ata);
		pstmt1.setInt(3, tripId);
		pstmt1.setInt(4, tripId);
		pstmt1.executeUpdate();
	}
	private void updateDestinationATA(Connection con, String ata) throws SQLException {
		pstmt = con.prepareStatement(CreateTripStatement.UPDATE_DES_ATA);
		pstmt.setInt(1, offset);
		pstmt.setString(2, ata);
		pstmt.setInt(3, tripId);
		pstmt.executeUpdate();
	}
	
	private void updateATPAndATDToTDesTripTable(Connection con) throws SQLException, ParseException {
		pstmt = con.prepareStatement(CreateTripStatement.UPDATE_DES_ATP_AND_ATD);
		pstmt.setInt(1, offset);
		pstmt.setString(2, yyyymmdd.format(sfddMMYYYY.parse(atp + ":00")));
		pstmt.setInt(3, offset);
		pstmt.setString(4, yyyymmdd.format(sfddMMYYYY.parse(atd + ":00")));
		pstmt.setInt(5, tripId);
		pstmt.executeUpdate();
	}
	private void updateSubTripTableForStatusAndSLARecalculate(Connection con,String status, String slaCalculate,int tripId) throws SQLException {
		pstmt = con.prepareStatement(CreateTripStatement.UPDATE_SUB_TRIP_DETAILS);
		pstmt.setString(1, status);
		pstmt.setString(2, slaCalculate);
		pstmt.setString(3, slaCalculate);
		pstmt.setInt(4, tripId);
		pstmt.executeUpdate();
	}
	public boolean isVehicleOnTrip(Connection con, int offset, String vehicleNo,int systemId,int clientId,int tripId) throws SQLException{
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		boolean exist = false;
		if(con == null){
			con = DBConnection.getConnectionToDB("AMS");
		}
		pstmt = con.prepareStatement(CreateTripStatement.GET_VEHICLE_NO_AND_ACT_ARR_DATETIME_FOR_TRIP_CREATION_VALIDATION.replace("#", "AND td.TRIP_ID != ?"));
		pstmt.setInt(1, offset);
		pstmt.setString(2, vehicleNo);
		pstmt.setInt(3, systemId);
		pstmt.setInt(4, clientId);
		pstmt.setInt(5, tripId);
		rs = pstmt.executeQuery();
		if(rs.next()){
			exist = true;
		}
		pstmt.close();
		rs.close();
		logWriter.log("Checking for vehicle already on another trip "+tripId, LogWriter.INFO);
		return exist;
	}
	public void updateVehicleStatus(Connection con,String vehicleNo, int status, int tripId, LogWriter logWriter, int count) {
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try{
			if(con == null){
				con = DBConnection.getConnectionToDB("AMS");
			}
			pstmt = con.prepareStatement(CommonStatements.CHECK_VEHICLE_STATUS);
			pstmt.setString(1, vehicleNo);
			rs = pstmt.executeQuery();
			if(rs.next()){
				con = DBConnection.getConnectionToDB("AMS");
				pstmt = con.prepareStatement(CommonStatements.UPDATE_VEHICLE_STATUS);
				pstmt.setInt(1, status);
				pstmt.setInt(2, tripId);
				pstmt.setString(3, vehicleNo);
				pstmt.executeUpdate();
				
				pstmt = con.prepareStatement(CommonStatements.MOVE_TO_HISTORY);
				pstmt.setString(1, vehicleNo);
				pstmt.executeUpdate();
				
				logWriter.log("Vehicle Status Updated. Vehicle No : "+vehicleNo+" and Trip Id : "+tripId+", Status : "+status, LogWriter.INFO);
			}else{
				if(con == null){
					con = DBConnection.getConnectionToDB("AMS");
				}
				pstmt = con.prepareStatement(CommonStatements.INSERT_INTO_VEHICLE_STATUS);
				pstmt.setInt(1, status);
				pstmt.setString(2, vehicleNo);
				pstmt.setInt(3, tripId);
				pstmt.executeUpdate();
				
				logWriter.log("Vehicle Status Added. Vehicle No : "+vehicleNo+" and Trip Id : "+tripId+", Status : "+status, LogWriter.INFO);
			}
		}catch(Exception e){
			logWriter.log("Exception while Vehicle Status update. Vehicle No : "+vehicleNo+" and Trip Id : "+tripId+", Status : "+status, LogWriter.INFO);
			if(count <= 3){
				updateVehicleStatus(con,vehicleNo,status,tripId,logWriter,++count);
				logWriter.log("Retrying Vehicle Status update : "+ e.getMessage()+" Vehicle No : "+vehicleNo+" and Trip Id : "+tripId, LogWriter.ERROR);
			}
		}
		finally{
			logWriter.log("Vehicle Status update ended. Vehicle No : "+vehicleNo+" and Trip Id : "+tripId, LogWriter.INFO);
		}
	}
}
