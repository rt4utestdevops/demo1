package t4u.functions;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Date;
import java.util.HashMap;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Map;

import org.json.JSONArray;
import org.json.JSONObject;

import t4u.GeneralVertical.TemperatureBean;
import t4u.common.DBConnection;
import t4u.statements.CreateTripStatement;
import t4u.statements.GeneralVerticalStatements;
import t4u.statements.SemiAutoTripStatements;
import t4u.statements.TemperatureReportStatements;
import t4u.util.TemperatureConfiguration;
import t4u.util.TemperatureConfigurationBean;

public class TemperatureReportFunction {
	SimpleDateFormat sdfDB = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
	SimpleDateFormat sdf1 = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
	SimpleDateFormat sdfDBMMDD = new SimpleDateFormat("yyyy-MM-dd");
	SimpleDateFormat timef = new SimpleDateFormat("HH:mm");
	DecimalFormat df = new DecimalFormat("00.00");
	DecimalFormat df1=new DecimalFormat("#.##");
	DecimalFormat df2=new DecimalFormat("0.00");
	CommonFunctions cf = new CommonFunctions();

	public JSONArray getTemperatureReport(int systemId,int clientId,int offset,int userId,String startDate,String endDate,String regNo){

		JSONArray JsonArray = new JSONArray();
		JSONObject JsonObject = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;		 
		ResultSet rs = null;	
		
		DecimalFormat df = new DecimalFormat("##0.00");
		List<JSONObject>expList =null;
		List<TemperatureBean> beanList =null;
		TemperatureBean ieBean=null;
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(SemiAutoTripStatements.CHECK_R232_ASSOCIATION);
			pstmt.setString(1, regNo);
			pstmt.setInt(2,systemId);
			pstmt.setInt(3,clientId);
			rs = pstmt.executeQuery();
			if(rs.next()){
				List<TemperatureConfigurationBean> tempConfigDetails = TemperatureConfiguration.getTemperatureConfigurationDetails(systemId, clientId, regNo);
				if(tempConfigDetails== null || tempConfigDetails.isEmpty()){
					return JsonArray;
				}
				StringBuffer sensorNamesStr = new StringBuffer();
				for (TemperatureConfigurationBean aTempConfigDetails : tempConfigDetails) {
					sensorNamesStr.append("'"+aTempConfigDetails.getSensorName()+"',");
				}
				if(sensorNamesStr.lastIndexOf(",") >0){
					sensorNamesStr = new StringBuffer(sensorNamesStr.substring(0, sensorNamesStr.lastIndexOf(",")));
				}
				
				
				pstmt = con.prepareStatement(TemperatureReportStatements.GET_TEMPERATURE_REPORT.replaceAll("#", sensorNamesStr.toString()));
				pstmt.setInt(1, offset);
				pstmt.setString(2, regNo);
				pstmt.setInt(3, offset);
				pstmt.setString(4, startDate);
				pstmt.setInt(5, offset);
				pstmt.setString(6, endDate);
				pstmt.setInt(7, offset);
				pstmt.setString(8, regNo);
				pstmt.setInt(9, offset);
				pstmt.setString(10, startDate);
				pstmt.setInt(11, offset);
				pstmt.setString(12, endDate);
				rs = pstmt.executeQuery();
			    expList = new ArrayList<JSONObject>();
			}else{
			    con = DBConnection.getConnectionToDB("AMS");
			    expList = new ArrayList<JSONObject>();
				pstmt = con.prepareStatement(TemperatureReportStatements.GET_ANALOG_TEMPERATURE_REPORT.replace("#", Integer.toString(systemId)));
				pstmt.setInt(1, offset);
				pstmt.setString(2, regNo);
				pstmt.setInt(3, offset);
				pstmt.setString(4, startDate);
				pstmt.setInt(5, offset);
				pstmt.setString(6, endDate);
				pstmt.setInt(7, offset);
				pstmt.setString(8, regNo);
				pstmt.setInt(9, offset);
				pstmt.setString(10, startDate);
				pstmt.setInt(11, offset);
				pstmt.setString(12, endDate);
				rs = pstmt.executeQuery();
			}
		    LinkedHashSet<Date> tempSet =new LinkedHashSet<Date>();
		    int count=0;
		    while(rs.next()){
		    	count++;
		    	 JsonObject = new JSONObject();
				 JsonObject.put("datetime", rs.getTimestamp("GMT"));
				 JsonObject.put("ioValue", rs.getString("IO_VALUE"));
				 JsonObject.put("location", rs.getString("LOCATION"));
				 JsonObject.put("category", rs.getString("IO_CATEGORY"));
				 JsonObject.put("ioID", rs.getString("IO_ID"));
				 
				 expList.add(JsonObject);
		    	 tempSet.add(rs.getTimestamp("GMT"));
		    }
		    beanList =new ArrayList<TemperatureBean>();
		    for (Date date : tempSet) {
		    	ieBean =new TemperatureBean();
		    	HashMap<String, String> sensorNameToValue = new HashMap<String, String>();
		    	for (JSONObject obj : expList) {
		    		if(obj.get("datetime").equals(date)){
		    			ieBean.setGmt(obj.getString("datetime"));
		    			ieBean.setLocation(obj.getString("location"));
		    			sensorNameToValue.put(obj.getString("ioID"), obj.getString("ioValue"));
		    		}
				}
		    	ieBean.setSensorNameToValue(sensorNameToValue);
		    	beanList.add(ieBean);		    	
			}
		    int i=0;
		   Collections.sort(beanList);
		    for(TemperatureBean bean  : beanList) {
		    	 i++;
		    	 JsonObject = new JSONObject();
		    	 JsonObject.put("slno",i);
				 JsonObject.put("datetime", sdf1.format(sdfDB.parseObject((bean.getGmt()))));
				 for (Map.Entry<String,String> entry : bean.getSensorNameToValue().entrySet())  {
			            JsonObject.put(entry.getKey(),entry.getValue());
			    }
				 JsonObject.put("map", bean.getSensorNameToValue());
				 JsonObject.put("reefer", bean.getReefer());
				 JsonObject.put("location", bean.getLocation());
				 JsonObject.put("gmt", timef.format(sdfDB.parseObject((bean.getGmt()))));
				 JsonArray.put(JsonObject);
		    }
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return JsonArray;
}
	public JSONArray getTempDetails(int systemId,int clientId,int offset,int userId,String startDate,String endDate,String regNo,String category){

		JSONArray JsonArray = new JSONArray();
		JSONObject JsonObject = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;		 
		ResultSet rs = null;	
		try {
			JsonArray = new JSONArray();
			JsonObject = new JSONObject();

			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(SemiAutoTripStatements.CHECK_R232_ASSOCIATION);
			pstmt.setString(1, regNo);
			pstmt.setInt(2,systemId);
			pstmt.setInt(3,clientId);
			rs = pstmt.executeQuery();
			
			if(rs.next()){
				pstmt = con.prepareStatement(TemperatureReportStatements.GET_TEMPERATURE_FROM_HISTORY_DATA);
				pstmt.setInt(1, offset);
				pstmt.setString(2, regNo);
				pstmt.setString(3, category);
				pstmt.setInt(4, offset);
				pstmt.setString(5, startDate);
				pstmt.setInt(6, offset);
				pstmt.setString(7, endDate);
				pstmt.setInt(8, offset);
				pstmt.setString(9, regNo);
				pstmt.setString(10, category);
				pstmt.setInt(11, offset);
				pstmt.setString(12, startDate);
				pstmt.setInt(13, offset);
				pstmt.setString(14, endDate);
				
			}else{
				pstmt = con.prepareStatement(TemperatureReportStatements.GET_ANALOG_TEMPERATURE_FROM_HISTORY_DATA.replaceAll("#","" +systemId));
				pstmt.setInt(1, offset);
				pstmt.setString(2, regNo);
				pstmt.setInt(3, offset);
				pstmt.setString(4, startDate);
				pstmt.setInt(5, offset);
				pstmt.setString(6, endDate);
				pstmt.setInt(7, offset);
				pstmt.setString(8, regNo);
				pstmt.setInt(9, offset);
				pstmt.setString(10, startDate);
				pstmt.setInt(11, offset);
				pstmt.setString(12, endDate);
			}
			
			rs = pstmt.executeQuery();
			while(rs.next())
			{
				 JsonObject = new JSONObject();
				 JsonObject.put("DATE", timef.format(rs.getTimestamp("GMT")));
				 JsonObject.put("TEMP", rs.getString("IO_VALUE"));
				 JsonArray.put(JsonObject);
			}
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return JsonArray;
}
	
	public JSONArray getTrip(int systemId,int clientId,int offset,int userId){

		JSONArray JsonArray = new JSONArray();
		Connection con = null;
		PreparedStatement pstmt = null;		 
		ResultSet rs = null;	
		try {
			JsonArray = new JSONArray();
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(TemperatureReportStatements.GET_TRIP_NAMES);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, clientId);
			rs = pstmt.executeQuery();
			JSONObject obj1 = new JSONObject();
			while (rs.next()) 
			{
				obj1 = new JSONObject();
				obj1.put("tripId", rs.getString("TRIP_ID"));
				obj1.put("tripName", rs.getString("TRIP_NAME"));
				JsonArray.put(obj1);
			}
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return JsonArray;
}
	
	public JSONArray getTripData(int offset,int tripId,int clientId) {
		JSONArray jsonArray = new JSONArray();
		JSONObject obj = null;
		Connection con = null;
		PreparedStatement pstmt = null ;
		PreparedStatement pstmt1 = null ;
		ResultSet rs = null;
		ResultSet rs1 = null;
		String vehicleNumber = "";
		String stmt;
		try {
			con = DBConnection.getConnectionToDB("AMS");
			if(clientId==5516){
		    stmt = TemperatureReportStatements.GET_TRIP_DATA_MUSCAT;
			}else{
			 stmt = TemperatureReportStatements.GET_TRIP_DATA;
			}
			
			pstmt=con.prepareStatement(stmt);
			pstmt.setInt(1, offset);
			pstmt.setInt(2, offset);
			pstmt.setInt(3, offset);
			pstmt.setInt(4, offset);
			pstmt.setInt(5, tripId);
			rs = pstmt.executeQuery();
			obj = new JSONObject();
			if (rs.next()) {
				
				String STD="";
				String endDate="";
				if(!rs.getString("STD").contains("1900")){
					STD = sdf.format(sdfDB.parse(rs.getString("STD")));
				}
				if(!rs.getString("END_DATE").contains("1900")){
					endDate = sdf.format(sdfDB.parse(rs.getString("END_DATE")));
				}
				obj.put("tripName", rs.getString("TRIP_NAME"));
				obj.put("tripName1", rs.getString("TRIP_NAME"));
				obj.put("assetNo", rs.getString("ASSET_NUMBER"));
				obj.put("referenceNo", rs.getString("CUSTOMER_REF_ID"));
				obj.put("DriverName", rs.getString("DRIVER_NAME"));
				obj.put("startDate", STD);
				obj.put("endDate", endDate);
				obj.put("vehicleType", rs.getString("MAKE"));
				obj.put("status", rs.getString("STATUS"));
				vehicleNumber = rs.getString("ASSET_NUMBER");
			}
			pstmt1 = con.prepareStatement(TemperatureReportStatements.GET_TRIP_VEHICLE_TEMPERATURE_DETAILS);
            pstmt1.setInt(1, tripId);
            pstmt1.setString(2, vehicleNumber);
            rs1 = pstmt1.executeQuery();
            
            String tblData = "";
            String tblDataExport = "";
            double minGreenRange=0;
            double maxGreenRange=0;
            boolean data = false;
            	while(rs1.next()){
            		data = true;
            		double negativeMaxTemp=rs1.getDouble("MAX_NEGATIVE_TEMP");
    	            double negativeMinTemp=rs1.getDouble("MIN_NEGATIVE_TEMP");
    	            double positiveMaxTemp=rs1.getDouble("MAX_POSITIVE_TEMP");
    	            double positiveMinTemp=rs1.getDouble("MIN_POSITIVE_TEMP");
    	            String displayName = rs1.getString("DISPLAY_NAME");
    	            double positiveMaxTemp2=positiveMaxTemp;//+1;
    	            double negativeMinTemp2=negativeMinTemp;//-1;
    	            
    	            obj.put("tempRangeDataIndex", negativeMaxTemp + " to "+positiveMinTemp );
    	            minGreenRange=rs1.getDouble("MIN_POSITIVE_TEMP");
    	            maxGreenRange = rs1.getDouble("MAX_NEGATIVE_TEMP");
    	            tblData = tblData + "<tr><td style = 'padding-left: 50px;'><b> "+ displayName + "</b></td><td><b style='color:green;'>&nbsp;GREEN : &nbsp;</b></td><td>"+negativeMaxTemp+" to "+positiveMinTemp+"</td><td><b style='color:#f7b704 ;'>&nbsp; &nbsp;&nbsp;YELLOW : &nbsp;</b></td><td>"+negativeMinTemp+" to "+negativeMaxTemp+"; "+positiveMinTemp+" to "+positiveMaxTemp+"</td><td><b style='color:red;'> &nbsp;&nbsp;&nbsp;RED :&nbsp;</b></td><td>-70 to "+negativeMinTemp2+"; "+positiveMaxTemp2+" to 70</td></tr>";
    	            tblDataExport = tblDataExport + "            "+displayName + "     GREEN :  "+negativeMaxTemp+" to "+positiveMinTemp+"   YELLOW :  "+negativeMinTemp+" to "+negativeMaxTemp+"; "+positiveMinTemp+" to "+positiveMaxTemp+"   RED : -70 to "+negativeMinTemp2+"; "+positiveMaxTemp2+" to 70 \n";
            	}
            	if (data){
            		obj.put("tblData", "<table><tr><td style='font-size: 15px;'><b>Temperature Range :  &nbsp; &nbsp;   </b></td></tr>"+tblData+"</table> ");
                	obj.put("tblDataExport", "Temperature Range : \n" +tblDataExport);
            	}else{
            		obj.put("tblData", "<table><tr><td style='font-size: 15px;'><b>Temperature Range :  NA   </b></td></tr></table> ");
                	obj.put("tblDataExport", "Temperature Range : NA ");
            	}
            	
            	obj.put("minGreenRange", minGreenRange);
            	obj.put("maxGreenRange", maxGreenRange);
            	jsonArray.put(obj);
			
		} catch (Exception e) {
			e.printStackTrace();
		}finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
			DBConnection.releaseConnectionToDB(null, pstmt1, rs1);
		}
		return jsonArray;
	}
	public JSONArray getVehicles(int systemId,int clientId,int offset,int userId){

		JSONArray JsonArray = new JSONArray();
		JSONObject JsonObject = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;		 
		ResultSet rs = null;	
		try {
			JsonArray = new JSONArray();
			JsonObject = new JSONObject();
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(TemperatureReportStatements.GET_VEHICLES_FOR_TEMP_REPORT);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, clientId);
			rs = pstmt.executeQuery();
			while(rs.next())
			{
				 JsonObject = new JSONObject();
				 JsonObject.put("vehicleNo", rs.getString("REGISTRATION_NO"));
				 JsonArray.put(JsonObject);
			}
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return JsonArray;
}
}
