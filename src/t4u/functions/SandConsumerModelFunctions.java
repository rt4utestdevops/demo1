package t4u.functions;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.text.SimpleDateFormat;
import org.json.JSONArray;
import org.json.JSONObject;

import t4u.common.DBConnection;
import t4u.statements.SandConsumerModelStatements;

public class SandConsumerModelFunctions {

    CommonFunctions cfuncs = new CommonFunctions();
    SimpleDateFormat sdfyyyymmddhhmmss = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
    SimpleDateFormat sdfyyyymmddhhmmss1 = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
    SimpleDateFormat sdfyyyymmdd = new SimpleDateFormat("dd-MM-yyyy");
    SimpleDateFormat sdfmmddyyyyhhmmss = new SimpleDateFormat("MM/dd/yyyy HH:mm:ss");
    SimpleDateFormat sdfddmmyyyy = new SimpleDateFormat("dd/MM/yyyy");
    SimpleDateFormat sdfmmddyyyy = new SimpleDateFormat("MM/dd/yyyy");
    SimpleDateFormat sfddMMYYYY = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
    SimpleDateFormat ddMMyyyyHHmmss = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
    CommonFunctions cf = new CommonFunctions();

    public JSONArray getSATDetails(Integer systemId, Integer customerId, Integer userId) {
        Connection con = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        JSONArray jsonarray = new JSONArray();
        JSONObject jsonobject = null;
        try {
            con = DBConnection.getConnectionToDB("AMS");
            pstmt = con.prepareStatement(SandConsumerModelStatements.getSATDetils);
            pstmt.setInt(1, systemId);
            pstmt.setInt(2, customerId);
            pstmt.setInt(3, userId);
            rs = pstmt.executeQuery();
            while (rs.next()) {
                jsonobject = new JSONObject();

                jsonobject.put("vehicleNumber", rs.getString("REGISTRATION_NO"));
                jsonobject.put("groupId", rs.getString("GROUP_ID"));
                jsonobject.put("location", rs.getString("LOCATION"));
                jsonobject.put("actualArrival", rs.getString("ACTUAL_ARRIVAL"));
                jsonobject.put("actualDeparture", rs.getString("ACTUAL_DEPARTURE"));
                jsonobject.put("hubId", rs.getString("HUB_ID"));
                jsonobject.put("typeOfHub", rs.getString("TYPE_OF_HUB"));
                jsonobject.put("standardDuration", rs.getString("STANDARD_DURATION"));
                jsonobject.put("status", rs.getString("STATUS"));
                jsonobject.put("latitude", rs.getString("LATITUDE"));
                jsonobject.put("longitude", rs.getString("LONGITUDE"));
                jsonobject.put("driverId", rs.getString("DRIVER_ID"));
                jsonarray.put(jsonobject);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            DBConnection.releaseConnectionToDB(con, pstmt, rs);
        }
        return jsonarray;
    }

}