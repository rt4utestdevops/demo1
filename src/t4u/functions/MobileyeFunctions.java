package t4u.functions;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;

import org.json.JSONArray;
import org.json.JSONObject;

import t4u.common.DBConnection;
import t4u.statements.CommonStatements;

/**
 * @author sharath.s
 *
 */
public class MobileyeFunctions {

	DecimalFormat Dformatter = new DecimalFormat("#.##");
	CashVanManagementFunctions cvsfn=new CashVanManagementFunctions();
	CommonFunctions cf=new CommonFunctions();
	SimpleDateFormat sdfDB = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
	
	public JSONArray getMobileyeValidData(String vehicle,String startTime,String endTime,int offmin,int  systemId,int customerId) 
	{
		PreparedStatement pstmt = null;
		ResultSet rs = null;	
		PreparedStatement pstmto = null;
		ResultSet rso = null;	
		String alarmTypeDesc=null;
		JSONArray recordsArray=new JSONArray();
		String regNoCondition="";
		Connection con=null;
		try {
			con= DBConnection.getConnectionToDB("AMS");
			
			if(!vehicle.equalsIgnoreCase("-- ALL --")){
				regNoCondition="REGISTRATION_NO='"+vehicle+"' and ";
			}
				pstmto = con.prepareStatement("select distinct isnull(REGISTRATION_NO,'') as registrationNo,isnull(UNIT_NO,'') as unitNo,LATITUDE as latitude,LONGITUDE as longitude,DATEDIFF(s, '1970-01-01 00:00:00', GMT)  as sateliteTime,GMT as gmt,dateadd(mi,?,GMT) as gpsTime,cast(ME_XML as xml).value('(/ME_DATA/MEYE_SPEED)[1]','varchar(10)') as speed, "+
						" cast(ME_XML as xml).value('(/ME_DATA/MEYE_SOUND_TYPE)[1]','varchar(10)') as alarmType,'' as MOBILEYE_TYPE  "+
						" from AMS.dbo.MOBILEYE_HISTORY  "+
						" where  "+regNoCondition+"GMT between dateadd(mi,-?,?) and dateadd(mi,-?,?) and SYSTEM_ID=? and CLIENT_ID=? and cast(ME_XML as xml).value('(/ME_DATA/MEYE_SOUND_TYPE)[1]','varchar(10)')!='0.0'  "+
						" and cast(ME_XML as xml).value('(/ME_DATA/MEYE_SOUND_TYPE)[1]','float') !=0 " +
						" union  "+
						" select isnull(REGISTRATION_NO,'') as registrationNo,isnull(UNIT_NO,'') as unitNo,LATITUDE as latitude,LONGITUDE as longitude,DATEDIFF(s, '1970-01-01 00:00:00', GMT)  as sateliteTime,GMT as gmt,dateadd(mi,?,GMT) as gpsTime,isNull(cast(ME_XML as xml).value('(/ME_DATA/MEYE_SPEED)[1]','varchar(10)'),cast(ME_SEC as xml).value('(/ME_SEC/MEYE_SPEED)[1]','varchar(10)')) as speed,  "+
						" '' as alarmType,isNull(cast(ME_XML as xml).value('(/ME_DATA/PACKET_TYPE)[1]','varchar(30)'),cast(ME_SEC as xml).value('(/ME_SEC/PACKET_TYPE)[1]','varchar(30)')) as MOBILEYE_TYPE  "+
						" from AMS.dbo.MOBILEYE_HISTORY with (nolock) where "+
						" DATETIME between dateadd(mi,-?,?) and dateadd(mi,-?,?) and "+regNoCondition+" (cast(ME_XML as xml).value('(/ME_DATA/PACKET_TYPE)[1]','varchar(30)') in ('ERROR','ERROR_CLEARED','FAILSAFE','FAILSAFE_CLEARED','MAINTENANCE','MAINTENANCE_CLEARED','TAMPER_ALERT','TAMPER_CLEARED') "+ 
						" or  cast(ME_SEC as xml).value('(/ME_SEC/PACKET_TYPE)[1]','varchar(30)') in ('SPEED_AVAILABLE','NOT_AVAILABLE')) and SYSTEM_ID=?  "+
						" order by registrationNo , sateliteTime");
				
				pstmto.setInt(1, offmin);
				pstmto.setInt(2, offmin);
				pstmto.setString(3, startTime);
				pstmto.setInt(4, offmin);
				pstmto.setString(5, endTime);
				pstmto.setInt(6, systemId);
				pstmto.setInt(7, customerId);
				pstmto.setInt(8, offmin);
				pstmto.setInt(9, offmin);
				pstmto.setString(10, startTime);
				pstmto.setInt(11, offmin);
				pstmto.setString(12, endTime);
				pstmto.setInt(13, systemId);
				rso = pstmto.executeQuery();
				JSONObject oneRecord = null;
				int count=0;
				while(rso.next()){	
					alarmTypeDesc="";
					count++;
					oneRecord = new JSONObject();
					oneRecord.put("slNoindex",count);
					oneRecord.put("registrationNo",rso.getString("registrationNo"));
					oneRecord.put("unitNo",rso.getString("unitNo"));
					oneRecord.put("gmt",sdf.format(sdfDB.parse(rso.getString("gmt"))));
					oneRecord.put("gpsTime",sdf.format(sdfDB.parse(rso.getString("gpsTime"))));
					oneRecord.put("latitude",rso.getFloat("latitude"));	
					oneRecord.put("longitude",rso.getFloat("longitude"));
					oneRecord.put("sateliteTime",rso.getLong("sateliteTime"));
					oneRecord.put("speed",rso.getFloat("speed"));
					
					if(rso.getString("MOBILEYE_TYPE").isEmpty()){
						
						switch((int)rso.getFloat("alarmType")){
						case 0: alarmTypeDesc="SILENT";
								break;
						case 1: alarmTypeDesc="LDW Left";
								break;
						case 2: alarmTypeDesc="LDW Right";
								break;
						case 3: alarmTypeDesc="HMW";
								break;
						case 4: alarmTypeDesc="Not Used";
								break;
						case 5: alarmTypeDesc="UFCW";
								break;
						case 6: alarmTypeDesc="FCW";
								break;
						case 7: alarmTypeDesc="Not Used";
								break;
						
						}
					}else
					alarmTypeDesc=rso.getString("MOBILEYE_TYPE");
					
					oneRecord.put("alarmType",alarmTypeDesc);
					recordsArray.put(oneRecord);
				}
			
				
		}
		catch(Exception e){
			e.printStackTrace();
		}
		finally{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return recordsArray;
	}
	
	public JSONArray getMobileyeInValidData(String vehicle,String startTime,String endTime,int offmin,int  systemId,int customerId) 
	{
		PreparedStatement pstmt = null;
		ResultSet rs = null;	
		PreparedStatement pstmto = null;
		ResultSet rso = null;	
		boolean detailsPresent=false;
		String alarmTypeDesc=null;
		JSONArray recordsArray=new JSONArray();
		String regNoCondition="";
		Connection con=null;
		try {
			String qry= "";
			con= DBConnection.getConnectionToDB("AMS");
			
			if(!vehicle.equalsIgnoreCase("-- ALL --")){
				regNoCondition="REGISTRATION_NO='"+vehicle+"' and ";
			}
				pstmto = con.prepareStatement("select  isnull(REGISTRATION_NO,'') as registrationNo,isnull(UNIT_NO,'') as unitNo,PACKET as packet,INSERTED_GMT as insertedGmt,dateadd(mi,?,INSERTED_GMT) as insertedGpsTime from dbo.ERRATIC_OBD_DATA where "+regNoCondition+" INSERTED_GMT between dateadd(mi,-?,?) and dateadd(mi,-?,?) and SYSTEM_ID=? and CLIENT_ID=? ");
				pstmto.setInt(1, offmin);
				pstmto.setInt(2, offmin);
				pstmto.setString(3, startTime);
				pstmto.setInt(4, offmin);
				pstmto.setString(5, endTime);
				pstmto.setInt(6, systemId);
				pstmto.setInt(7, customerId);
				rso = pstmto.executeQuery();
				JSONObject oneRecord = null;
				int count=0;
				while(rso.next()){	
					alarmTypeDesc="";
					count++;
					detailsPresent=true;
					oneRecord = new JSONObject();
					oneRecord.put("slNoindex",count);
					oneRecord.put("registrationNo",rso.getString("registrationNo"));
					oneRecord.put("unitNo",rso.getString("unitNo"));
					oneRecord.put("insertedGmt",sdf.format(sdfDB.parse(rso.getString("insertedGmt"))));
					oneRecord.put("insertedGpsTime",sdf.format(sdfDB.parse(rso.getString("insertedGpsTime"))));
					oneRecord.put("packet",rso.getString("packet"));
					recordsArray.put(oneRecord);
				}
		}
		catch(Exception e){
			e.printStackTrace();
		}
		finally{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return recordsArray;
	}
	
	public JSONArray getMobileyeTransactionDataPush(String vehicle,String startTime,String endTime,int offmin,int  systemId,int customerId) 
	{
		PreparedStatement pstmt = null;
		ResultSet rs = null;	
		PreparedStatement pstmto = null;
		ResultSet rso = null;	
		JSONArray recordsArray=new JSONArray();
		String regNoCondition="";
		Connection con= null;
		try {
			String qry= "";
			con= DBConnection.getConnectionToDB("AMS");
			
			// since REQUEST_TIME is server/indian time
			 offmin=offmin-330;
			
			if(!vehicle.equalsIgnoreCase("-- ALL --")){
				regNoCondition="mt.REGISTRATION_NO='"+vehicle+"' and ";
			}
				pstmto = con.prepareStatement("select isnull(mt.REGISTRATION_NO,'') as registrationNo,isnull(mt.UNIT_NO,'') as unitNo,REQUEST_TIME as requesttime,REQ_START_TIME as fromtime,REQ_END_TIME as totime, CASE when (STATUS=200 OR STATUS=201) THEN 'SUCCESS' ELSE 'FAILED' END  as status,isNull(NO_OF_RECORDS,0) as num_of_records from MOBILEYE_TRANSACTION mt " +
						" where "+regNoCondition+" REQUEST_TIME between dateadd(mi,-?,?) and dateadd(mi,-?,?) and SYSTEM_ID=? and CLIENT_ID=? and TYPE = 'PUSH' ");
				pstmto.setInt(1, offmin);
				pstmto.setString(2, startTime);
				pstmto.setInt(3, offmin);
				pstmto.setString(4, endTime);
				pstmto.setInt(5, systemId);
				pstmto.setInt(6, customerId);
				rso = pstmto.executeQuery();
				JSONObject oneRecord = null;
				int count=0;
				while(rso.next()){	
					count++;
					oneRecord = new JSONObject();
					oneRecord.put("slNoindex",count);
					oneRecord.put("registrationNo",rso.getString("registrationNo"));
					oneRecord.put("unitNo",rso.getString("unitNo"));
					oneRecord.put("fromtime",sdf.format(sdfDB.parse(rso.getString("fromtime"))));
					oneRecord.put("totime",sdf.format(sdfDB.parse(rso.getString("totime"))));
					oneRecord.put("requesttime",sdf.format(sdfDB.parse(rso.getString("requesttime"))));
					oneRecord.put("status",rso.getString("status"));
					oneRecord.put("num_of_records",rso.getInt("num_of_records"));
					recordsArray.put(oneRecord);
				}
		}
		catch(Exception e){
			e.printStackTrace();
		}
		finally{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return recordsArray;
	}
	
	
	public JSONArray getRegistrationNoBasedOnUser(int custId, int ltspId, int userId) {
		JSONArray jsonArray = null;
		JSONObject jsonObject = null;

		Connection conAms = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {

			jsonArray = new JSONArray();
			jsonObject = new JSONObject();
			conAms = DBConnection.getConnectionToDB("AMS");
			pstmt = conAms.prepareStatement(CommonStatements.GET_REGISTRATION_NO_BASED_ON_USER);
			pstmt.setInt(1, custId);
			pstmt.setInt(2, ltspId);
			pstmt.setInt(3, userId);
			rs = pstmt.executeQuery();
			jsonObject = new JSONObject();
			jsonObject.put("VehicleNo", "-- ALL --");
			jsonArray.put(jsonObject);
			while (rs.next()) {
				jsonObject = new JSONObject();
				jsonObject.put("VehicleNo", rs.getString("REGISTRATION_NUMBER"));
				jsonArray.put(jsonObject);
			}

		} catch (Exception e) {
			System.out.println("Error in CommonFunctions:-getRegistrationNoBasedOnUser "+ e.toString());
		} finally {
			DBConnection.releaseConnectionToDB(conAms, pstmt, rs);
		}
		return jsonArray;
	}
	
	public JSONArray getMobileyeTransactionDataPull(String vehicle,String startTime,String endTime,int offmin,int  systemId,int customerId) 
	{
		PreparedStatement pstmt = null;
		ResultSet rs = null;	
		PreparedStatement pstmto = null;
		ResultSet rso = null;	
		JSONArray recordsArray=new JSONArray();
		String regNoCondition="";
		Connection con= null;
		try {
			String qry= "";
			con= DBConnection.getConnectionToDB("AMS");
			
			// since REQUEST_TIME is server/indian time
			 offmin=offmin-330;
			
			if(!vehicle.equalsIgnoreCase("-- ALL --")){
				regNoCondition="mt.REGISTRATION_NO='"+vehicle+"' and ";
			}
				pstmto = con.prepareStatement("select isnull(mt.REGISTRATION_NO,'') as registrationNo,isnull(mt.UNIT_NO,'') as unitNo,REQUEST_TIME as requesttime,REQ_START_TIME as fromtime,REQ_END_TIME as totime, CASE when (STATUS=200 OR STATUS=201) THEN 'SUCCESS' ELSE 'FAILED' END  as status,isNull(NO_OF_RECORDS,0) as num_of_records from MOBILEYE_TRANSACTION mt " +
						" where "+regNoCondition+" REQUEST_TIME between dateadd(mi,-?,?) and dateadd(mi,-?,?) and SYSTEM_ID=? and CLIENT_ID=? and TYPE = 'PULL'"); 
				pstmto.setInt(1, offmin);
				pstmto.setString(2, startTime);
				pstmto.setInt(3, offmin);
				pstmto.setString(4, endTime);
				pstmto.setInt(5, systemId);
				pstmto.setInt(6, customerId);
				rso = pstmto.executeQuery();
				JSONObject oneRecord = null;
				int count=0;
				while(rso.next()){	
					count++;
					oneRecord = new JSONObject();
					oneRecord.put("slNoindex",count);
					oneRecord.put("registrationNo",rso.getString("registrationNo"));
					oneRecord.put("unitNo",rso.getString("unitNo"));
					oneRecord.put("fromtime",sdf.format(sdfDB.parse(rso.getString("fromtime"))));
					oneRecord.put("totime",sdf.format(sdfDB.parse(rso.getString("totime"))));
					oneRecord.put("requesttime",sdf.format(sdfDB.parse(rso.getString("requesttime"))));
					oneRecord.put("status",rso.getString("status"));
					oneRecord.put("num_of_records",rso.getInt("num_of_records"));
					recordsArray.put(oneRecord);
				}
		}
		catch(Exception e){
			e.printStackTrace();
		}
		finally{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return recordsArray;
	}
	
}

