package t4u.functions;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import org.json.JSONArray;
import org.json.JSONObject;

import t4u.common.DBConnection;

public class WebVideoStreamFunction {
	
	public static final String GET_LINKS = "select * from CAMERA_LINKS where SYSTEM_ID=? AND CUSTOMER_ID=? AND STATUS='Active'";
	
	
	public JSONArray getLinks(int systemId, int clientId) {
		JSONArray JsonArray = null;
		JSONObject JsonObject = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			int i=0;
			JsonArray = new JSONArray();
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(GET_LINKS);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, clientId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				i++;
				JsonObject = new JSONObject();
				JsonObject.put("rtsplinks", rs.getString("RTSP_LINK"));
				JsonArray.put(JsonObject);
			}
			JsonObject = new JSONObject();
			JsonObject.put("count", i);
			JsonArray.put(JsonObject);

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return JsonArray;
	}
	
}
