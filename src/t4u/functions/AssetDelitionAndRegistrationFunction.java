package t4u.functions;

import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;
import java.util.Map.Entry;

import org.json.JSONArray;
import org.json.JSONObject;

import t4u.admin.AssetDetailsData;
import t4u.common.ApplicationListener;
import t4u.common.DBConnection;
import t4u.statements.AdminStatements;

public class AssetDelitionAndRegistrationFunction {
	LogWriter logWriter=null;
	
	public JSONArray getLTSP() {
		JSONArray JsonArray = null;
		JSONObject JsonObject = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;		   
		try {
			JsonArray = new JSONArray();
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(AdminStatements.GET_ALL_LTSP);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				JsonObject = new JSONObject();
				JsonObject.put("Systemid", rs.getString("SystemId"));
				JsonObject.put("SystemName", rs.getString("SystemName"));
				JsonArray.put(JsonObject);
			}		       
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return JsonArray;
	}

	public JSONArray getClientList(String systemid){
		Connection con=null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		JSONArray JsonArray = null;

		try{	 
			JsonArray = new JSONArray();
			con = DBConnection.getConnectionToDB("AMS");			   		 
			pstmt=con.prepareStatement(AdminStatements.SELECT_CLIENT_LIST);
			pstmt.setString(1, systemid);	  				
			rs=pstmt.executeQuery();		   		  
			while(rs.next()){ 
				JSONObject obj1 = new JSONObject(); 		   		
				obj1.put("clientid",rs.getString("CustomerId")); 
				obj1.put("clientname",rs.getString("CustomerName")); 
				JsonArray.put(obj1);
			}
		}catch(Exception e){
			System.out.println("Error when getClientList.."+e);
		}
		finally{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return JsonArray;  			
	}

	 
	public String DeleteFromRegistrationAndReregistration(String ltspName,String custName, int ltsp,int clientId,List<AssetDetailsData> list){
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs=null;
		String msg="Error";
		int offset=0; 
		int userId=0;
		String zone="";
		String reasonForUnregister="Unregistered by Excel Import";
		String userName="Excel Import";
		con = DBConnection.getConnectionToDB("AMS");
		
		SimpleDateFormat sdf = new SimpleDateFormat("dd-MM-yyyy");
		Properties properties = ApplicationListener.prop;
		String logFile=  properties.getProperty("LogForAssetReegistration");		
		logFile = logFile + "AssetDetails-" + sdf.format(new Date()) + ".txt";
		
		PrintWriter pw;
		
		if (logFile != null)
		{
			try
			{
				pw = new PrintWriter(new FileWriter(logFile, true), true);
		        logWriter=new LogWriter("ASSET RE-REGISTRATION",LogWriter.INFO,pw);;
		        logWriter.setPrintWriter(pw);
			}
			catch (IOException e)
			{
				logWriter.log("Can't open the log file: " + logFile + ". Using System.err instead", LogWriter.ERROR);
			}
		}
		
		

		Map<String,  ArrayList < String >> VehicleMap=new HashMap<String,  ArrayList < String >> ();

		try{
			String registrationNo = "";
			pstmt = con.prepareStatement(AdminStatements.GET_ZONE_AND_OFFSET);    	    
			pstmt.setInt(1, ltsp);
			rs=pstmt.executeQuery();
			if(rs.next()){
				offset=rs.getInt("OffsetMin");
				zone=rs.getString("Zone");
			}
			int cntT=0;
			for(AssetDetailsData assetDetails:list){
				cntT++;
				ArrayList<String> pmr = new ArrayList<String>();     	              
				registrationNo = assetDetails.oldAssetNo;
				pstmt = con.prepareStatement(AdminStatements.GET_ASSET_DETAILS_FOR_REREGISTRATION);
				pstmt.setString(1,registrationNo); 
				pstmt.setInt(2, ltsp);
				pstmt.setInt(3, clientId);
				rs=pstmt.executeQuery();
				if(rs.next()){           	       
					pmr.add(rs.getString("AssetType"));//0
					pmr.add(rs.getString("GROUP_ID"));//1
					pmr.add(rs.getString("GroupName"));//2
					pmr.add(rs.getString("Model"));//3
					pmr.add(rs.getString("OWNER_NAME"));//4
					pmr.add(rs.getString("OWNER_ADDRESS"));//5
					pmr.add(rs.getString("OWNER_PHONE_NO"));//6
					pmr.add( rs.getString("VehicleAlias"));//7
					pmr.add(rs.getString("UnitNo"));//8
					pmr.add(rs.getString("MobileNumber"));//9     	        	
					pmr.add(rs.getString("OWNER_ID"));//10
					pmr.add(rs.getString("VehicleAlias"));//11
					pmr.add(assetDetails.newAssetNo.trim());//12
					VehicleMap.put(registrationNo.trim(), pmr);		
				} 
				
				pstmt = con.prepareStatement(AdminStatements.UPDATE_ASSET_DETAILS_FOR_VEHICLEIOASSOCIATION);
				pstmt.setString(1,assetDetails.newAssetNo.trim());
				pstmt.setString(2,registrationNo); 
				pstmt.setInt(3, ltsp);
				pstmt.executeUpdate();
				
				pstmt = con.prepareStatement(AdminStatements.UPDATE_ASSET_DETAILS_FOR_VEHICLEOPASSOCIATION);
				pstmt.setString(1,assetDetails.newAssetNo.trim());
				pstmt.setString(2,registrationNo); 
				pstmt.setInt(3, ltsp);
				pstmt.executeUpdate();
				
			}
		    
			DBConnection.releaseConnectionToDB(con, pstmt, rs);//DB connection closed here

			AdminFunctions adfunc=new AdminFunctions();
			int cnt=0;
			logWriter.log("START TO RE-REGISTER TOTAL CNT=="+cntT+"------------------------------------------------------------", LogWriter.INFO);
			for (Entry<String, ArrayList<String>> entry : VehicleMap.entrySet()) {
				cnt++;
				ArrayList<String> vehicleData = new ArrayList<String>();
				String oldAssetNo=entry.getKey();			
				vehicleData=entry.getValue();
				String newAssetNo=vehicleData.get(12);			
				int flag=1;
				//Un-registration of old Asset No 
				msg = adfunc.functionToDeleteVehicle(oldAssetNo, ltsp, userId, ltspName, offset, reasonForUnregister, clientId, userName, custName, vehicleData.get(8), vehicleData.get(0),"","","",flag,newAssetNo);
				
				logWriter.log("Un-Registered ASSET_NO=="+oldAssetNo+" MSG :"+msg, LogWriter.INFO);
				
				//Registration of New Asset No  with  old Data
				msg = adfunc.registerNewVehicle(vehicleData.get(0),newAssetNo, Integer.parseInt(vehicleData.get(1)), vehicleData.get(8),  
						vehicleData.get(9), ltsp, userId, offset, clientId, ltspName, vehicleData.get(2), custName,  
						vehicleData.get(3), vehicleData.get(4), vehicleData.get(5), vehicleData.get(6), vehicleData.get(11), zone,
						Integer.parseInt(vehicleData.get(10)), "true","","","",flag,"");
			
				logWriter.log("Re-Registered ASSET_NO===="+newAssetNo+" MSG :"+msg, LogWriter.INFO);
			} 
			logWriter.log("END OF RE-REGISTER  Compleated CNT=="+cnt+"------------------------------------------------------------", LogWriter.INFO);
			 msg=cnt+" Assets Re-registered Successfully";
		}catch(Exception e){
			e.printStackTrace();
			logWriter.log("DeleteFromRegistrationAndReregistration"+e, LogWriter.ERROR);
		}
		return msg;
	}

}
