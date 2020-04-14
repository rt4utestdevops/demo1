package t4u.util;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import t4u.beans.MapAPIConfigBean;
import t4u.common.DBConnection;

/**
 * @author T4u525
 * 
 *         This utility class gives map configurations by systemId if configured
 * 
 */
public class MapAPIUtil {

	private static final String GET_MAP_API_CONFIGURATION = "SELECT * FROM AMS.dbo.MAP_API_CONFIGURATION WHERE SYSTEM_ID = ? and STATUS='Active' ";
	private static final String GET_GRAPHHOPPER_MAP_CONFIGURATION = "SELECT ISNULL(GRAPHHOPPER_MAP_FILE,'Asia/India/india-latest.osm.pbf') AS GRAPHHOPPER_MAP_FILE,* FROM System_Master WHERE System_id = ? ";

	public MapAPIConfigBean getConfiguration(Integer systemId) {

		MapAPIConfigBean apiConfiguration = new MapAPIConfigBean();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		PreparedStatement pstmt1 = null;
		ResultSet rs1 = null;
		Connection con = null;

		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(GET_MAP_API_CONFIGURATION);
			pstmt.setInt(1, systemId);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				apiConfiguration.setSystemId(systemId);
				apiConfiguration.setAPIKey(rs.getString("API_KEY"));
				apiConfiguration.setAppCode(rs.getString("APP_CODE"));
				apiConfiguration.setMapName(rs.getString("MAP_NAME"));
				apiConfiguration.setTrafficType(rs.getString("TRAFFIC_TYPE"));
				apiConfiguration.setVehicleType(rs.getString("VEHICLE_TYPE"));
				apiConfiguration.setRoutingType(rs.getString("ROUTING_TYPE"));
				apiConfiguration.setGraphHopperMapFile("");
			} else {
				apiConfiguration.setSystemId(systemId);
				apiConfiguration.setAPIKey("");
				apiConfiguration.setAppCode("");
				apiConfiguration.setMapName("OSM");
				apiConfiguration.setTrafficType("");
				apiConfiguration.setVehicleType("");
				apiConfiguration.setRoutingType("");
				pstmt1 = con.prepareStatement(GET_GRAPHHOPPER_MAP_CONFIGURATION);
				pstmt1.setInt(1, systemId);
				rs1 = pstmt1.executeQuery();
				if (rs1.next()) {
					apiConfiguration.setGraphHopperMapFile(rs1.getString("GRAPHHOPPER_MAP_FILE"));
				} else {
					apiConfiguration.setGraphHopperMapFile("Asia/India/india-latest.osm.pbf");
				}
			}

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return apiConfiguration;

	}
}
