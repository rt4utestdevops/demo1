package t4u.functions;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import t4u.common.DBConnection;
import t4u.statements.CreateTripStatement;

public class UpdateTrip implements Runnable {
	private int offset;
	private String atp;
	private String atd;
	private int tripId;
	private String remarks;
	private int userId;
	private boolean atdChanged;
	private boolean ataChanged;
	private String ata;
	private boolean atpChanged;
	
	public UpdateTrip(int offset, String atp, String atd,int tripId, String remarks,int userId, boolean ataChanged, boolean atdChanged,
			String ata, boolean atpChanged) {
		this.offset = offset;
		this.atp = atp;
		this.atd = atd;
		this.tripId = tripId;
		this.remarks = remarks;
		this.userId = userId;
		this.atdChanged = atdChanged;
		this.ataChanged = ataChanged;
		this.ata = ata;
		this.atpChanged = atpChanged;
	}

	private PreparedStatement pstmt = null;

	public void run() {
		Connection con = null;
		try {
			con = DBConnection.getConnectionToDB("AMS");
			updateATPATDAndATA(con);
		} catch (final Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, null);
		}
	}

	private void updateATPATDAndATA(Connection con) throws SQLException {
		try {
			String statement = CreateTripStatement.UPDATE_MAIN_ATP_ATD;
			if(atpChanged){
				statement = statement.replace("#", ",ACT_SRC_ARR_DATETIME=dateadd(mi,-"+offset+",'"+atp+"') # ");
			}
			if(atdChanged){
				statement = statement.replace("#", ",ACTUAL_TRIP_START_TIME=dateadd(mi,-"+offset+",'"+atd+"')," +
						"DEST_ARR_TIME_ON_ATD=dateadd(mi,-"+offset+",dateadd(mi,PLANNED_DURATION,'"+atd+"')) # ");
			}
			if(atpChanged || atdChanged){
				statement = statement.replace("#", ",OVERRIDDEN_BY="+userId+",OVERRIDDEN_DATETIME=getutcDate() # ");
			}
			if(ataChanged){//UPDATE ETA as ATA
				statement = statement.replace("#", ",ATA_OVERIDDEN_BY="+userId+",ATA_OVERIDDEN_DATETIME=getutcdate()," +
						"DESTINATION_ETA="+"dateadd(mi,-"+offset+",'"+ata+"')"+",NEXT_LEG_ETA="+"dateadd(mi,-"+offset+",'"+ata+"')");
			}
			statement = statement.replace("#", "");
			pstmt = con.prepareStatement(statement);
			pstmt.setString(1, remarks);
			pstmt.setInt(2, offset);
			pstmt.setString(3, atd);
			pstmt.setInt(4, offset);
			pstmt.setString(5, ata);
			pstmt.setInt(6, tripId);
			pstmt.executeUpdate();

			//ATP Des Table ATP
			if(atpChanged){
				pstmt = con.prepareStatement(CreateTripStatement.UPDATE_DES_ATP);
				pstmt.setInt(1, offset);
				pstmt.setString(2, atp);
				pstmt.setInt(3, tripId);
				pstmt.setInt(4, 0);
				pstmt.executeUpdate();
			}
			//ATD Des Table ATD
			if(atdChanged){
				pstmt = con.prepareStatement(CreateTripStatement.UPDATE_DES_ATD);
				pstmt.setInt(1, offset);
				pstmt.setString(2, atd);
				pstmt.setInt(3, tripId);
				pstmt.executeUpdate();
			}
			//ATD LEG
			if(atdChanged){
				pstmt = con.prepareStatement(CreateTripStatement.UPDATE_LEG_ATD);
				pstmt.setInt(1, offset);
				pstmt.setString(2, atd);
				pstmt.setInt(3, tripId);
				pstmt.setInt(4, tripId);
				pstmt.executeUpdate();
			}
			if(ataChanged){
				pstmt = con.prepareStatement(CreateTripStatement.UPDATE_DES_ATA);
				pstmt.setInt(1, offset);
				pstmt.setString(2, ata);
				pstmt.setInt(3, tripId);
				pstmt.executeUpdate();
				
				pstmt = con.prepareStatement(CreateTripStatement.UPDATE_TRIP_LEG_DETAILS_WHILE_CLOSING);
				pstmt.setInt(1, offset);
				pstmt.setString(2, ata);
				pstmt.setInt(3, tripId);
				pstmt.setInt(4, tripId);
				pstmt.executeUpdate();
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, null);
		}
	}
}
