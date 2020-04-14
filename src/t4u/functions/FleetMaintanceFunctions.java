package t4u.functions;


import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import org.json.JSONArray;
import org.json.JSONObject;


import java.text.DateFormat;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;





import t4u.beans.ReportHelper;
import t4u.common.DBConnection;
import t4u.statements.CashVanManagementStatements;


public class FleetMaintanceFunctions {
	SimpleDateFormat sdfyyyymmddhhmmss=new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
	DecimalFormat dftwodigit = new DecimalFormat("0.00");
	public JSONArray getBranches(int systemId, int clientId, int userId) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		JSONArray jsonArray = new JSONArray();
        JSONObject jsonObject = new JSONObject();
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(FleetMaintanceStatements.GET_BRANCH_NAME_USER);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, userId);
			rs = pstmt.executeQuery();
			JSONObject obj1 = new JSONObject();
			if (rs.next()) {
				if (rs.getString("Category").equalsIgnoreCase("0")) {
					obj1 = new JSONObject();
					obj1.put("BranchId", -1);
					obj1.put("BranchName", "All");
					jsonArray.put(obj1);
					obj1 = new JSONObject();
					obj1.put("BranchId", 0);
					obj1.put("BranchName", "Head Office");
					jsonArray.put(obj1);
					jsonArray = getBranchName(systemId, clientId, jsonArray);

				} else {
					obj1 = new JSONObject();
					obj1.put("BranchId", rs.getString("BranchId"));
					obj1.put("BranchName", rs.getString("BranchName"));
					jsonArray.put(obj1);
				}
			} else {
				obj1 = new JSONObject();
				obj1.put("BranchId", 0);
				obj1.put("BranchName", "Head Office");
				jsonArray.put(obj1);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jsonArray;

	}
	
	public JSONArray getVehicleTypesFromMaster(int systemId, int clientId) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		JSONArray jsonArray = new JSONArray();
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(FleetMaintanceStatements.GET_VEHICLE_TYPES);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, clientId);
			rs = pstmt.executeQuery();
			JSONObject obj1 = new JSONObject();
			obj1 = new JSONObject();
			int count = 0;
			obj1.put("VehicleTypeId", count);
			obj1.put("VehicleTypeName", "ALL");
			jsonArray.put(obj1);
			while (rs.next()) {	
				count++;
					obj1 = new JSONObject();
					obj1.put("VehicleTypeId", count);
					obj1.put("VehicleTypeName", rs.getString("VehicleType"));
					jsonArray.put(obj1);				
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jsonArray;

	}
	
	public JSONArray getBranchName(int systemid, int clientid,
			JSONArray jsonArray) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			con = DBConnection.getConnectionToDB("AMS");
			String stmt = "";
			stmt = "select BranchId,BranchName from Maple.dbo.tblBranchMaster where SystemId="
					+ systemid;
			if (clientid > 0) {
				stmt = stmt + " and ClientId=" + clientid;
			}
			stmt = stmt + "  order by BranchName";
			pstmt = con.prepareStatement(stmt);
			rs = pstmt.executeQuery();
			JSONObject obj1 = new JSONObject();
			while (rs.next()) {
				obj1 = new JSONObject();
				obj1.put("BranchId", rs.getString("BranchId"));
				obj1.put("BranchName", rs.getString("BranchName"));
				jsonArray.put(obj1);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jsonArray;
	}
	
	public ArrayList < Object > getPartsPendingDetails(int systemId ,int custId,int userid,int branch,int offset) {
        Connection con = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        JSONArray JsonArray = new JSONArray();
	    JSONObject JsonObject = null;
	    SimpleDateFormat ddmmyyyy = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
	    SimpleDateFormat yyyymmdd = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        ArrayList<ReportHelper> reportsList = new ArrayList<ReportHelper>();
		ArrayList<String> headersList = new ArrayList<String>();
		ReportHelper finalreporthelper = new ReportHelper();
	    ArrayList < Object > finlist = new ArrayList < Object > ();
	    String query="";
	    
        try {
        	headersList.add("SLNO");
        	headersList.add("Requisition SlipNo");
        	headersList.add("Item Type");
			headersList.add("Part Name");
			headersList.add("Part Number");
			headersList.add("Part Category");
			headersList.add("Manufacturer");
			headersList.add("UOM(unit of measure)");
			headersList.add("Quantity Requested");
			headersList.add("Current QIH(Quantity In Hand)");
			headersList.add("Branch Name");
			headersList.add("Requested By");
			headersList.add("Requested Date");
			
        	int count = 0;
            con = DBConnection.getConnectionToDB("AMS");
            if (branch==-1)
			{
				query = FleetMaintanceStatements.GET_PARTS_PENDING_DETAILS;
			} else {
				query = FleetMaintanceStatements.GET_PARTS_PENDING_DETAILS + " and a.BranchName="+branch ;
			}
            pstmt = con.prepareStatement(query);
            pstmt.setInt(1, offset);
            pstmt.setInt(2, systemId);
            pstmt.setInt(3, systemId);
            pstmt.setInt(4, custId);
            rs = pstmt.executeQuery();
            while (rs.next()) {
            	ArrayList<Object> informationList = new ArrayList<Object>();
				ReportHelper reporthelper = new ReportHelper();
	            count++;
	            JsonObject = new JSONObject();
                
	            informationList.add(count);
	            JsonObject.put("slnoIndex", count);
                
	            informationList.add(rs.getString("REQUISITION_NO"));	            
                JsonObject.put("SlipNoDataIndex", rs.getString("REQUISITION_NO"));
                
	            informationList.add(rs.getString("ITEM_TYPE"));
                JsonObject.put("itemTypeDataIndex", rs.getString("ITEM_TYPE"));
                
                informationList.add(rs.getString("PART_NAME"));
                JsonObject.put("partNameDataIndex", rs.getString("PART_NAME"));
                
                informationList.add(rs.getString("PART_NUMBER"));
                JsonObject.put("partNumberDataIndex", rs.getString("PART_NUMBER"));
                
                informationList.add(rs.getString("PART_CATEGORY"));
                JsonObject.put("partCategoryDataIndex", rs.getString("PART_CATEGORY"));
                
                informationList.add(rs.getString("MANUFACTURER"));
                JsonObject.put("manufacturerDataIndex", rs.getString("MANUFACTURER"));
                
                informationList.add(rs.getString("UOM"));
                JsonObject.put("UOMDataIndex", rs.getString("UOM"));
                
                informationList.add(rs.getString("REQUESTED_QUANTITY"));
                JsonObject.put("quantityDataIndex", rs.getString("REQUESTED_QUANTITY"));
                
                informationList.add(rs.getString("QIH"));
                JsonObject.put("QTHDataIndex", rs.getString("QIH"));
                
                if(rs.getString("BRANCH_NAME").equals(""))
	            {
            	informationList.add("Head Office");
                JsonObject.put("branchNameDataIndex", "Head Office");
                }
	            else
                {
            	informationList.add(rs.getString("BRANCH_NAME"));
                JsonObject.put("branchNameDataIndex", rs.getString("BRANCH_NAME"));
                } 
                
                informationList.add(rs.getString("REQUESTED_BY"));
                JsonObject.put("requestedByDataIndex", rs.getString("REQUESTED_BY"));
                
                if(rs.getString("INSERTED_DATE")==""|| rs.getString("INSERTED_DATE").contains("1900"))
				{
				informationList.add("");
				JsonObject.put("requestedDateDataIndex","");	
				}
				else
				{	
				informationList.add(ddmmyyyy.format(yyyymmdd.parse(rs.getString("INSERTED_DATE"))));
                JsonObject.put("requestedDateDataIndex", rs.getString("INSERTED_DATE"));
				}
                
                JsonArray.put(JsonObject);
	            reporthelper.setInformationList(informationList);
				reportsList.add(reporthelper);
            }
            finalreporthelper.setReportsList(reportsList);
			finalreporthelper.setHeadersList(headersList);
			finlist.add(JsonArray);
			finlist.add(finalreporthelper);

        } catch (Exception e) {
        	 e.printStackTrace();
        } finally {
            DBConnection.releaseConnectionToDB(con, pstmt, rs);
        }
        return finlist;
    }
	
	
	
	public JSONArray getIdlingDetails(int reportType ,String customerid, int systemId,int offset,String vehicleType,String startDate,String endDate,int userId) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String region = "";
		double percentage = 0.0;
		JSONArray idlingJSONArray=new JSONArray();
		JSONObject idlingJSONObject;
		String footer = "";
		try {
			con = DBConnection.getDashboardConnection("AMS");
			if(reportType == 1){
				footer ="Idling %";
			}else if(reportType == 3){
				footer ="Average Ovespeed Count";
			}else if(reportType == 7){
				footer ="";
			}
			
			if(reportType == 1){
				HashMap<String, Integer> regionVehicleCountMap = new HashMap<String, Integer>();
				HashMap<String, Double> regionidleCountMap = new HashMap<String, Double>();
				percentage = 0.0;
				String replaceString = "";
				if(!vehicleType.equalsIgnoreCase("ALL")){
					replaceString = "and vt.VehicleType = '"+vehicleType+"' ";
				}
//			 if(vehicleType.contains("CAR")){
//				 replaceString = " and vt.VehicleType = 'CAR' ";
//			 }else if (vehicleType.contains("TRUCK")) {
//				 replaceString = " and vt.VehicleType = 'TRUCK' "; 
//			 }
			 
			 pstmt = con.prepareStatement(FleetMaintanceStatements.GET_VEHICLE_COUNT.replace("#", replaceString));	
				pstmt.setInt(1, systemId);
				pstmt.setInt(2, Integer.parseInt(customerid));
				pstmt.setInt(3, userId);
             rs = pstmt.executeQuery();
			
			while(rs.next()) {
				
				
				region = rs.getString("GROUP_NAME");
				regionVehicleCountMap.put(region, rs.getInt("VEHICLE_COUNT"));				
				
			}		
			 
				pstmt = con.prepareStatement(FleetMaintanceStatements.GET_IDLING_PERCENTAGE.replace("#", replaceString));
				pstmt.setInt(1, -offset);
				pstmt.setString(2, startDate+" 00:00:00");
				pstmt.setInt(3, -offset);
				pstmt.setString(4, endDate+" 23:59:59");
				pstmt.setInt(5, systemId);
				pstmt.setInt(6, Integer.parseInt(customerid));
				pstmt.setInt(7, userId);
				pstmt.setInt(8, -offset);
				pstmt.setString(9, startDate+" 00:00:00");
				pstmt.setInt(10, -offset);
				pstmt.setString(11, endDate+" 23:59:59");
				pstmt.setInt(12, systemId);
				pstmt.setInt(13, Integer.parseInt(customerid));
				pstmt.setInt(14, userId);
			rs = pstmt.executeQuery();
			
			while(rs.next()) {	
				
				region = rs.getString("GROUP_NAME");
				percentage = 0;
				if(rs.getDouble("IDLE_HRS") != 0.0 && rs.getDouble("ENGINE_HRS") !=0.0){
					if(rs.getDouble("IDLE_HRS") < rs.getDouble("ENGINE_HRS")){
				percentage = ((rs.getDouble("IDLE_HRS")/rs.getDouble("ENGINE_HRS"))*100);
					}else if(rs.getDouble("IDLE_HRS")>=rs.getDouble("ENGINE_HRS")){
						percentage = 100;
					}
				}
				regionidleCountMap.put(region, percentage);
				
				
			}
			if(regionVehicleCountMap.size()>0){
				int count = 0;
			    for(Map.Entry<String, Integer> entry: regionVehicleCountMap.entrySet()){
			    	count++;
					region = entry.getKey();
					if(regionidleCountMap.containsKey(region)){
						percentage = regionidleCountMap.get(region);					
					}else{
						percentage = 0;
					}				
				
				if( count == 1){
					
				idlingJSONObject=new JSONObject();
				idlingJSONObject.put("groupName","Types");		
				idlingJSONObject.put("percentage",footer);
				idlingJSONArray.put(idlingJSONObject);
				
				idlingJSONObject=new JSONObject();
				idlingJSONObject.put("groupName",region);		
				idlingJSONObject.put("percentage",percentage);
				idlingJSONArray.put(idlingJSONObject);
				
				}else{
					idlingJSONObject=new JSONObject();
					idlingJSONObject.put("groupName",region);		
					idlingJSONObject.put("percentage",percentage);
					idlingJSONArray.put(idlingJSONObject);
				}
			}
			}else {
				idlingJSONObject=new JSONObject();
				idlingJSONObject.put("groupName","Types");		
				idlingJSONObject.put("percentage",footer);
				idlingJSONArray.put(idlingJSONObject);
				idlingJSONObject=new JSONObject();
				idlingJSONObject.put("groupName","");		
				idlingJSONObject.put("percentage",0);
				idlingJSONArray.put(idlingJSONObject);
			}
		}else if(reportType == 3){
			percentage = 0.0;
			HashMap<String, Integer> regionVehicleCountMap = new HashMap<String, Integer>();
			HashMap<String, int[]> regionOverSpeedCountMap = new HashMap<String, int[]>();
			
			String replaceString = "";
			if(!vehicleType.equalsIgnoreCase("ALL")){
				replaceString = "and vt.VehicleType = '"+vehicleType+"' ";
			}
			 int vehcount = 0;
			 
//			 if(vehicleType.contains("CAR")){
//				 replaceString = " and vt.VehicleType = 'CAR' ";
//			 }else if (vehicleType.contains("TRUCK")) {
//				 replaceString = " and vt.VehicleType = 'TRUCK' "; 
//			 }
				pstmt = con.prepareStatement(FleetMaintanceStatements.GET_VEHICLE_COUNT.replace("#", replaceString));			
				pstmt.setInt(1, systemId);
				pstmt.setInt(2, Integer.parseInt(customerid));
				pstmt.setInt(3, userId);
                rs = pstmt.executeQuery();
			
			while(rs.next()) {
				
				
				region = rs.getString("GROUP_NAME");
				vehcount = rs.getInt("VEHICLE_COUNT");				
				regionVehicleCountMap.put(region, vehcount);				
				
			}

		pstmt = con.prepareStatement(FleetMaintanceStatements.GET_OVERSPEED_COUNT_ORC.replace("#", replaceString));
		pstmt.setInt(1, -offset);
		pstmt.setString(2, startDate+" 00:00:00");
		pstmt.setInt(3, -offset);
		pstmt.setString(4, endDate+" 23:59:59");
		pstmt.setInt(5, systemId);
		pstmt.setInt(6, Integer.parseInt(customerid));
		pstmt.setInt(7, userId);
		pstmt.setInt(8, -offset);
		pstmt.setString(9, startDate+" 00:00:00");
		pstmt.setInt(10, -offset);
		pstmt.setString(11, endDate+" 23:59:59");
		pstmt.setInt(12, systemId);
		pstmt.setInt(13, Integer.parseInt(customerid));
		pstmt.setInt(14, userId);
        rs = pstmt.executeQuery();
	
	while(rs.next()) {
				
		region = rs.getString("GROUP_NAME");
		int Count[] = {rs.getInt("OVERSPEED_COUNT"),rs.getInt("OSVEHICLE_COUNT")};
		regionOverSpeedCountMap.put(region, Count);				
		
	}	
	    percentage = 0;
		int count = 0;
		int vehicleCount = 0;
		int overspeedCount = 0;
		if(regionVehicleCountMap.size()>0){
	    for(Map.Entry<String, Integer> entry: regionVehicleCountMap.entrySet()){
		count++;
		region = entry.getKey();
		if(regionOverSpeedCountMap.containsKey(region)){
		int Count [] = regionOverSpeedCountMap.get(region);
		overspeedCount = Count [0];
		vehicleCount =  Count [1];
		if(vehicleCount !=0 ){
			percentage = overspeedCount/vehicleCount;
			}
		}else{
			percentage = 0;
		}
		
		if( count == 1){
			
			idlingJSONObject=new JSONObject();
			idlingJSONObject.put("groupName","Types");		
			idlingJSONObject.put("percentage",footer);
			idlingJSONArray.put(idlingJSONObject);
			
			idlingJSONObject=new JSONObject();
			idlingJSONObject.put("groupName",region);		
			idlingJSONObject.put("percentage",percentage);
			idlingJSONArray.put(idlingJSONObject);
			
			}else{
				idlingJSONObject=new JSONObject();
				idlingJSONObject.put("groupName",region);		
				idlingJSONObject.put("percentage",percentage);
				idlingJSONArray.put(idlingJSONObject);
			}
	     }
		}
		else{
			idlingJSONObject=new JSONObject();
			idlingJSONObject.put("groupName","Types");		
			idlingJSONObject.put("percentage",footer);
			idlingJSONArray.put(idlingJSONObject);
			
			idlingJSONObject=new JSONObject();
			idlingJSONObject.put("groupName","");		
			idlingJSONObject.put("percentage",0);
			idlingJSONArray.put(idlingJSONObject);
	    }
	    
	
		}else if(reportType == 7){
			
			percentage = 0.0;
			String footer1 = "PM COMPLETED AFTER EXPIRY";
			String footer2 = "PM COMPLETED BEFORE EXPIRY";
			HashMap<String, Integer> regionVehiclePMCountMap = new HashMap<String, Integer>();
			HashMap<String, Integer> regionPMExpiredCountMap = new HashMap<String, Integer>();
			HashMap<String, Integer> regionNonPMExpiredCountMap = new HashMap<String, Integer>();
			HashMap<String, Integer> regionVehiclePMCountMapTemp = new HashMap<String, Integer>();
			HashMap<String, Integer> regionAssetCountAll = new HashMap<String, Integer>();

			
			String replaceString = "";
			if(!vehicleType.equalsIgnoreCase("ALL")){
				replaceString = "and vt.VehicleType = '"+vehicleType+"' ";
			}
			 int vehcount = 0;
//			 if(vehicleType.contains("CAR")){
//				 replaceString = " and vt.VehicleType = 'CAR' ";
//			 }else if (vehicleType.contains("TRUCK")) {
//				 replaceString = " and vt.VehicleType = 'TRUCK' "; 
//			 }
				
			pstmt = con.prepareStatement(FleetMaintanceStatements.GET_PM_SCHEDULED_ALL_VEHICLE_FOR_COMPLIANCE.replace("#", replaceString));
			//pstmt.setInt(1, 32);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, Integer.parseInt(customerid));
			pstmt.setInt(3, userId);
			pstmt.setInt(4, -0);
			pstmt.setString(5, startDate);
			pstmt.setInt(6, -0);
			pstmt.setString(7, endDate);	
			//pstmt.setInt(9, 32);
//			pstmt.setInt(8, systemId);
//			pstmt.setInt(9, Integer.parseInt(customerid));
//			pstmt.setInt(10, userId);
//			pstmt.setInt(11, -offset);
//			pstmt.setString(12, startDate);
//			pstmt.setInt(13, -offset);
//			pstmt.setString(14, endDate);	
			 rs = pstmt.executeQuery();
				
				while(rs.next()) {							
					regionVehiclePMCountMapTemp.put(rs.getString("GROUP_NAME"),rs.getInt("VEHICLE_COUNT"));
				}
				pstmt = con.prepareStatement(FleetMaintanceStatements.GET_PM_SCHEDULED_ALL_VEHICLE.replace("#", replaceString));
				pstmt.setInt(1, systemId);
				pstmt.setInt(2, Integer.parseInt(customerid));
				pstmt.setInt(3, userId);
				 rs = pstmt.executeQuery();
					
					while(rs.next()) {							
						regionAssetCountAll.put(rs.getString("All_GROUP"),rs.getInt("VEHICLE_COUNT"));
					}	
				
					for(Map.Entry<String, Integer> entry: regionAssetCountAll.entrySet()){
					String reg = 	entry.getKey();
					if(regionVehiclePMCountMapTemp.containsKey(reg)){
						regionVehiclePMCountMap.put(reg, regionVehiclePMCountMapTemp.get(reg));
					}else{
						regionVehiclePMCountMap.put(reg, 0);
					}
					}
		pstmt = con.prepareStatement(FleetMaintanceStatements.GET_PM_EXPIRED_COUNT.replace("#", replaceString));
		//pstmt.setInt(1, 32);
		pstmt.setInt(1, systemId);
		pstmt.setInt(2, Integer.parseInt(customerid));
		pstmt.setInt(3, userId);
		pstmt.setInt(4, -0);
		pstmt.setString(5, startDate);
		pstmt.setInt(6, -0);
		pstmt.setString(7, endDate);		
		rs = pstmt.executeQuery();
		while(rs.next()) {
				
			 region = rs.getString("GROUP_NAME");
			 vehcount = rs.getInt("VEHICLE_COUNT");				
			 regionPMExpiredCountMap.put(region, vehcount);				
		
		 }	
	pstmt = con.prepareStatement(FleetMaintanceStatements.GET_PM_NON_EXPIRED_COUNT.replace("#", replaceString));
	//pstmt.setInt(1, 32);
	pstmt.setInt(1, systemId);
	pstmt.setInt(2, Integer.parseInt(customerid));
	pstmt.setInt(3, userId);
	pstmt.setInt(4, -0);
	pstmt.setString(5, startDate);
	pstmt.setInt(6, -0);
	pstmt.setString(7, endDate);
	//pstmt.setInt(9, 32);
//	pstmt.setInt(8, systemId);
//	pstmt.setInt(9, Integer.parseInt(customerid));
//	pstmt.setInt(10, userId);
//	pstmt.setInt(11, -offset);
//	pstmt.setString(12, startDate);
//	pstmt.setInt(13, -offset);
//	pstmt.setString(14, endDate);
	rs = pstmt.executeQuery();
	while(rs.next()) {
			
	region = rs.getString("GROUP_NAME");
	vehcount = rs.getInt("VEHICLE_COUNT");				
	regionNonPMExpiredCountMap.put(region, vehcount);				
	
}	
		int count = 0;
		if(regionVehiclePMCountMap.size()>0){
	    for(Map.Entry<String, Integer> entry: regionVehiclePMCountMap.entrySet()){
		count++;
		float  percentage1 = 0.0f;
		float  percentage2 = 0.0f;
		int vehicleCount = 0;
		int pmexpiredCount = 0;
		int pmnonexpiredCount = 0;
		region = entry.getKey();		
		vehicleCount = entry.getValue();
		if(regionPMExpiredCountMap.containsKey(region)){
			pmexpiredCount = regionPMExpiredCountMap.get(region);
		}else{
			pmexpiredCount = 0;
		}
		if(regionNonPMExpiredCountMap.containsKey(region)){
			pmnonexpiredCount = regionNonPMExpiredCountMap.get(region);
		}else{
			pmnonexpiredCount = 0;
		}
		
		if(vehicleCount !=0 && pmexpiredCount !=0 ){
			//percentage1 = (( (float) pmexpiredCount/  vehicleCount)*100);
			percentage1=pmexpiredCount;
		}
		if(vehicleCount !=0 && pmnonexpiredCount !=0 ){
			//percentage2 = (( (float) pmnonexpiredCount/  vehicleCount)*100);
			percentage2=pmnonexpiredCount;
		}
		
		if( count == 1){
			
			idlingJSONObject=new JSONObject();
			idlingJSONObject.put("groupName","Types");			
			idlingJSONObject.put("percentage1",footer1);
			idlingJSONObject.put("percentage2",footer2);
			idlingJSONArray.put(idlingJSONObject);
			
			idlingJSONObject=new JSONObject();
			idlingJSONObject.put("groupName",region);		
			idlingJSONObject.put("percentage1",percentage1);
			idlingJSONObject.put("percentage2",percentage2);
			idlingJSONArray.put(idlingJSONObject);
			
			}else{
				idlingJSONObject=new JSONObject();
				idlingJSONObject.put("groupName",region);		
				idlingJSONObject.put("percentage1",percentage1);
				idlingJSONObject.put("percentage2",percentage2);
				idlingJSONArray.put(idlingJSONObject);
			}
	     }
	
		}else{
		
		idlingJSONObject=new JSONObject();
		idlingJSONObject.put("groupName","Types");			
		idlingJSONObject.put("percentage1",footer1);
		idlingJSONObject.put("percentage2",footer2);
		idlingJSONArray.put(idlingJSONObject);
		
		idlingJSONObject=new JSONObject();
		idlingJSONObject.put("groupName","");		
		idlingJSONObject.put("percentage1",0);
		idlingJSONObject.put("percentage2",0);
		idlingJSONArray.put(idlingJSONObject);
		
		}
			
		}

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return idlingJSONArray;
	
	
	}
	
	
	public JSONArray getIdlingTrend(int reportType ,String customerid, int systemId,int offset,String vehicleType,String duration,String selectedDateString,int userId) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String region = "";
		double percentage1 = 0.0f;
		double percentage2 = 0.0f;
		double percentage3 = 0.0f;
		JSONArray idlingJSONArray=new JSONArray();
		JSONObject idlingJSONObject;
		DateFormat dateFormat = new SimpleDateFormat("yyyy/MM/dd");
		DateFormat dateFormatNew = new SimpleDateFormat("dd/MM/yyyy");
		DateFormat dateFormatq = new SimpleDateFormat("yyyy-MM-dd");
		DateFormat monthFormat = new SimpleDateFormat("MMM-yyyy");
		DateFormat mnthFormat = new SimpleDateFormat("M");
		Date selectedDate = null;		
		try {
			selectedDate = dateFormatq.parse(selectedDateString);

			   con = DBConnection.getDashboardConnection("AMS");			
			   if(duration.equalsIgnoreCase("DAILY")){	
				   HashMap<String, Integer> regionVehicleCountMap = new HashMap<String, Integer>();
					HashMap<String, double[]> regionidleCountMap = new HashMap<String, double[]>();
				   String day1 = "";
				   String day2 = "";
				   String day3 = "";
				   String day1q = "";
				   String day2q = "";
				   String day3q = "";
				  percentage1 = 0.0f;
				  percentage2 = 0.0f;
				  percentage3 = 0.0f;
				    Calendar cal = Calendar.getInstance();
				    cal.setTime(selectedDate);
				    cal.add(Calendar.DATE, -1);
				    Date date = cal.getTime();
				    day1 = dateFormatNew.format(date);
				    day1q = dateFormatq.format(date);				    
				    cal.add(Calendar.DATE, -1);
				    date = cal.getTime();
				    day2 = dateFormatNew.format(date);
				    day2q = dateFormatq.format(date);
				    cal.add(Calendar.DATE, -1);
				    date = cal.getTime();
				    day3 = dateFormatNew.format(date);
				    day3q = dateFormatq.format(date);
				    
					idlingJSONObject=new JSONObject();
					idlingJSONObject.put("groupName","Types");		
					idlingJSONObject.put("percentage1",day3);
					idlingJSONObject.put("percentage2",day2);
					idlingJSONObject.put("percentage3",day1);
					idlingJSONArray.put(idlingJSONObject);  
					String replaceString = "";
					if(!vehicleType.equalsIgnoreCase("ALL")){
						replaceString = "and vt.VehicleType = '"+vehicleType+"' ";
					}
//					 if(vehicleType.contains("CAR")){
//						 replaceString = " and vt.VehicleType = 'CAR' ";
//					 }else if (vehicleType.contains("TRUCK")) {
//						 replaceString = " and vt.VehicleType = 'TRUCK' "; 
//					 }
					 
					 pstmt = con.prepareStatement(FleetMaintanceStatements.GET_VEHICLE_COUNT.replace("#", replaceString));						
						pstmt.setInt(1, systemId);
						pstmt.setInt(2, Integer.parseInt(customerid));
						pstmt.setInt(3, userId);
		             rs = pstmt.executeQuery();
					
					while(rs.next()) {											
						region = rs.getString("GROUP_NAME");
						regionVehicleCountMap.put(region, rs.getInt("VEHICLE_COUNT"));										
					}		
					 
						HashMap<String, Double> regionDistanceCountMap1 = new HashMap<String, Double>();
						HashMap<String, Double> regionDistanceCountMap2 = new HashMap<String,  Double>();
						HashMap<String, Double> regionDistanceCountMap3 = new HashMap<String,  Double>();						
						replaceString = "";
						if(!vehicleType.equalsIgnoreCase("ALL")){
							replaceString = "and vt.VehicleType = '"+vehicleType+"' ";
						}
						 ArrayList<Integer> arr = new ArrayList<Integer>();
						 ArrayList<Double> arrr = new ArrayList<Double>();
//						 if(vehicleType.contains("CAR")){
//							 replaceString = " and vt.VehicleType = 'CAR' ";
//						 }else if (vehicleType.contains("TRUCK")) {
//							 replaceString = " and vt.VehicleType = 'TRUCK' "; 
//						 }
						   	pstmt = con.prepareStatement(FleetMaintanceStatements.GET_IDLING_PERCENTAGE_TREND.replace("#", replaceString));
							pstmt.setInt(1, -offset);
							pstmt.setString(2, day1q+" 00:00:00");
							pstmt.setInt(3, -offset);
							pstmt.setString(4, day1q+" 23:59:59");
							pstmt.setInt(5, systemId);
							pstmt.setInt(6, Integer.parseInt(customerid));
							pstmt.setInt(7, userId);
							pstmt.setInt(8, -offset);
							pstmt.setString(9, day1q+" 00:00:00");
							pstmt.setInt(10, -offset);
							pstmt.setString(11, day1q+" 23:59:59");
							pstmt.setInt(12, systemId);
							pstmt.setInt(13, Integer.parseInt(customerid));
							pstmt.setInt(14, userId);
							rs = pstmt.executeQuery();
						  
							while(rs.next()) {
								region = rs.getString("GROUP_NAME");
								percentage1 = 0.0f;	
								
								if(rs.getDouble("IDLE_HRS1") != 0.0 && rs.getDouble("ENGINE_HRS1") !=0.0){
									if(rs.getDouble("IDLE_HRS1") < rs.getDouble("ENGINE_HRS1")){
								percentage1 = ((rs.getFloat("IDLE_HRS1")/rs.getFloat("ENGINE_HRS1"))*100);
									}else if(rs.getDouble("IDLE_HRS1") >= rs.getDouble("ENGINE_HRS1")){
										percentage1 = 100.0f;	
									}
								}	
								regionDistanceCountMap1.put(region, percentage1);
							}	
					
							pstmt = con.prepareStatement(FleetMaintanceStatements.GET_IDLING_PERCENTAGE_TREND.replace("#", replaceString));
							pstmt.setInt(1, -offset);
							pstmt.setString(2, day2q+" 00:00:00");
							pstmt.setInt(3, -offset);
							pstmt.setString(4, day2q+" 23:59:59");
							pstmt.setInt(5, systemId);
							pstmt.setInt(6, Integer.parseInt(customerid));
							pstmt.setInt(7, userId);
							pstmt.setInt(8, -offset);
							pstmt.setString(9, day2q+" 00:00:00");
							pstmt.setInt(10, -offset);
							pstmt.setString(11, day2q+" 23:59:59");
							pstmt.setInt(12, systemId);
							pstmt.setInt(13, Integer.parseInt(customerid));
							pstmt.setInt(14, userId);
							rs = pstmt.executeQuery();
						  
							while(rs.next()) {
								region = rs.getString("GROUP_NAME");
								percentage1 = 0.0f;	
								
								if(rs.getDouble("IDLE_HRS1") != 0.0 && rs.getDouble("ENGINE_HRS1") !=0.0){
									if(rs.getDouble("IDLE_HRS1") < rs.getDouble("ENGINE_HRS1")){
								percentage1 = ((rs.getDouble("IDLE_HRS1")/rs.getDouble("ENGINE_HRS1"))*100);
									}else if(rs.getDouble("IDLE_HRS1") >= rs.getDouble("ENGINE_HRS1")){
										percentage1 = 100.0f;	
									}
								}	
								regionDistanceCountMap2.put(region, percentage1);
							}	
					
							
							pstmt = con.prepareStatement(FleetMaintanceStatements.GET_IDLING_PERCENTAGE_TREND.replace("#", replaceString));
							pstmt.setInt(1, -offset);
							pstmt.setString(2, day3q+" 00:00:00");
							pstmt.setInt(3, -offset);
							pstmt.setString(4, day3q+" 23:59:59");
							pstmt.setInt(5, systemId);
							pstmt.setInt(6, Integer.parseInt(customerid));
							pstmt.setInt(7, userId);
							pstmt.setInt(8, -offset);
							pstmt.setString(9, day3q+" 00:00:00");
							pstmt.setInt(10, -offset);
							pstmt.setString(11, day3q+" 23:59:59");
							pstmt.setInt(12, systemId);
							pstmt.setInt(13, Integer.parseInt(customerid));
							pstmt.setInt(14, userId);
							rs = pstmt.executeQuery();
						  
							while(rs.next()) {
								region = rs.getString("GROUP_NAME");
								percentage1 = 0.0f;	
								
								if(rs.getDouble("IDLE_HRS1") != 0.0 && rs.getDouble("ENGINE_HRS1") !=0.0){
									if(rs.getDouble("IDLE_HRS1") < rs.getDouble("ENGINE_HRS1")){
								percentage1 = ((rs.getDouble("IDLE_HRS1")/rs.getDouble("ENGINE_HRS1"))*100);
									}else if(rs.getDouble("IDLE_HRS1") >= rs.getDouble("ENGINE_HRS1")){
										percentage1 = 100.0f;	
									}
								}	
								regionDistanceCountMap3.put(region, percentage1);
							}	
					
							int checkSize = regionDistanceCountMap1.size();
							HashMap<String, Double> loopmap = regionDistanceCountMap1;
							if(checkSize<regionDistanceCountMap2.size()){
								checkSize=regionDistanceCountMap2.size();
								loopmap = regionDistanceCountMap2;
							}
							if(checkSize<regionDistanceCountMap3.size()){
								checkSize=regionDistanceCountMap3.size();
								loopmap = regionDistanceCountMap3;
							}
						
							for(Map.Entry<String, Double> entry: loopmap.entrySet()){
								double arr2[] = {0,0,0};
								double per1 = 0.0f;
								double per2 =  0.0f;
								double per3 =  0.0f;
								region = entry.getKey();
								per1 = entry.getValue();
								if(regionDistanceCountMap1.containsKey(region)){
									per1 = regionDistanceCountMap1.get(region);	
								}else{
									per1 = 0;	
								}
								if(regionDistanceCountMap2.containsKey(region)){
									per2 = regionDistanceCountMap2.get(region);	
								}else{
									per2 = 0;	
								}if(regionDistanceCountMap3.containsKey(region)){
									per3 = regionDistanceCountMap3.get(region);	
								}else{
									per3 = 0;	
								}
								arr2[0] =per1;
								arr2[1] =per2;
								arr2[2] =per3;
								
								regionidleCountMap.put(region, arr2);	
								
							}
							
						
						
						if(regionVehicleCountMap.size()>0){
							int count = 0;
						    for(Map.Entry<String, Integer> entry: regionVehicleCountMap.entrySet()){
						    	count++;
								region = entry.getKey();
								if(regionidleCountMap.containsKey(region)){
									double perarr[] = regionidleCountMap.get(region);
									percentage1 = perarr[0];
									percentage2= perarr[1];
									percentage3= perarr[2];
								}else{
									percentage1 = 0;
									percentage2= 0;
									percentage3= 0;
								}				
							
							idlingJSONObject=new JSONObject();					
							idlingJSONObject.put("groupName",region);		
							idlingJSONObject.put("percentage1",percentage3);
							idlingJSONObject.put("percentage2",percentage2);
							idlingJSONObject.put("percentage3",percentage1);
							idlingJSONArray.put(idlingJSONObject);	
						}
						}else {
							idlingJSONObject=new JSONObject();
										idlingJSONObject.put("groupName","");		
										idlingJSONObject.put("percentage1",0);
										idlingJSONObject.put("percentage2",0);
										idlingJSONObject.put("percentage3",0);
										idlingJSONArray.put(idlingJSONObject);  
						}
						
						
			   }
			
			   else if(duration.equalsIgnoreCase("WEEKLY")){
				   HashMap<String, Integer> regionVehicleCountMap = new HashMap<String, Integer>();
					HashMap<String, double[]> regionidleCountMap = new HashMap<String, double[]>();
				   String week1 = "";
				   String week2 = "";
				   String week3 = "";
				   String week0 = "";
				   String week1stdt = "";
				   String week1endt = "";
				   String week2stdt = "";
				   String week2endt = "";
				   String week3stdt = "";
				   String week3endt = "";
				   percentage1 = 0.0f;
				   percentage2 = 0.0f;
				   percentage3 = 0.0f;
				   String replaceString ="";
				   
				    Calendar cal = Calendar.getInstance();
				    cal.setTime(selectedDate);
				   
				    int daysBackToSat = cal.get(Calendar.DAY_OF_WEEK );
				    cal.add(Calendar.DATE, daysBackToSat*-1);
				    Date date = cal.getTime();
				    week3 = dateFormat.format(date);
				    String week3New = dateFormatNew.format(date);
				    daysBackToSat = cal.get(Calendar.DAY_OF_WEEK );
				    cal.add(Calendar.DATE, daysBackToSat*-1);
				    date = cal.getTime();
				    week2 = dateFormat.format(date);
				    String 	week2New = 		dateFormatNew.format(date);	    
				    Calendar caltoshowWeek2 = Calendar.getInstance();
				    caltoshowWeek2.setTime(date);
				    caltoshowWeek2.add(Calendar.DATE, 1);
				    date = caltoshowWeek2.getTime();
				    String week1t2shw = dateFormatNew.format(date);
				    week1t2shw=week1t2shw+" TO "+week3New;
				    
				    daysBackToSat = cal.get(Calendar.DAY_OF_WEEK );
				    cal.add(Calendar.DATE, daysBackToSat*-1);
				    date = cal.getTime();
				    week1 = dateFormat.format(date);
				    String week1New = dateFormatNew.format(date);
				    Calendar caltoshowWeek1 = Calendar.getInstance();
				    caltoshowWeek1.setTime(date);
				    caltoshowWeek1.add(Calendar.DATE, 1);
				    date = caltoshowWeek1.getTime();
				    String week1toshw = dateFormatNew.format(date);
				    week1toshw=week1toshw+" TO "+week2New;
				    
				    daysBackToSat = cal.get(Calendar.DAY_OF_WEEK );
				    cal.add(Calendar.DATE, daysBackToSat*-1);
				    date = cal.getTime();
				    week0 = dateFormat.format(date);
				    
				    Calendar caltoshowWeek0 = Calendar.getInstance();
				    caltoshowWeek0.setTime(date);
				    caltoshowWeek0.add(Calendar.DATE, 1);
				    date = caltoshowWeek0.getTime();
				    String week0toshw = dateFormatNew.format(date);
				    week0toshw=week0toshw+" TO "+week1New;
				  	
				    week1stdt = week0+" 00:00:00";
					week1endt = week1+" 23:59:59";				    
					week2stdt = week1+" 23:59:59";
					week2endt = week2+" 23:59:59";					
					week3stdt =  week2+" 23:59:59";
					week3endt =  week3+" 23:59:59";
				    
				    
					idlingJSONObject=new JSONObject();
					idlingJSONObject.put("groupName","Types");		
					idlingJSONObject.put("percentage1",week0toshw);
					idlingJSONObject.put("percentage2",week1toshw);
					idlingJSONObject.put("percentage3",week1t2shw);
					idlingJSONArray.put(idlingJSONObject);  
					
					replaceString = "";
					if(!vehicleType.equalsIgnoreCase("ALL")){
						replaceString = "and vt.VehicleType = '"+vehicleType+"' ";
					}
//					 if(vehicleType.contains("CAR")){
//						 replaceString = " and vt.VehicleType = 'CAR' ";
//					 }else if (vehicleType.contains("TRUCK")) {
//						 replaceString = " and vt.VehicleType = 'TRUCK' "; 
//					 }
					 
					 pstmt = con.prepareStatement(FleetMaintanceStatements.GET_VEHICLE_COUNT.replace("#", replaceString));				
						pstmt.setInt(1, systemId);
						pstmt.setInt(2, Integer.parseInt(customerid));
						pstmt.setInt(3, userId);
		             rs = pstmt.executeQuery();
					
					while(rs.next()) {											
						region = rs.getString("GROUP_NAME");
						regionVehicleCountMap.put(region, rs.getInt("VEHICLE_COUNT"));										
					}		
					 
						HashMap<String, Double> regionDistanceCountMap1 = new HashMap<String, Double>();
						HashMap<String, Double> regionDistanceCountMap2 = new HashMap<String,  Double>();
						HashMap<String, Double> regionDistanceCountMap3 = new HashMap<String,  Double>();						
						replaceString = "";
						if(!vehicleType.equalsIgnoreCase("ALL")){
							replaceString = "and vt.VehicleType = '"+vehicleType+"' ";
						}
						 ArrayList<Integer> arr = new ArrayList<Integer>();
						 ArrayList<Double> arrr = new ArrayList<Double>();
//						 if(vehicleType.contains("CAR")){
//							 replaceString = " and vt.VehicleType = 'CAR' ";
//						 }else if (vehicleType.contains("TRUCK")) {
//							 replaceString = " and vt.VehicleType = 'TRUCK' "; 
//						 }
						   	pstmt = con.prepareStatement(FleetMaintanceStatements.GET_IDLING_PERCENTAGE_TREND.replace("#", replaceString));
							pstmt.setInt(1, -offset);
							pstmt.setString(2, week1stdt);
							pstmt.setInt(3, -offset);
							pstmt.setString(4, week1endt);
							pstmt.setInt(5, systemId);
							pstmt.setInt(6, Integer.parseInt(customerid));
							pstmt.setInt(7, userId);
							pstmt.setInt(8, -offset);
							pstmt.setString(9, week1stdt);
							pstmt.setInt(10, -offset);
							pstmt.setString(11, week1endt);
							pstmt.setInt(12, systemId);
							pstmt.setInt(13, Integer.parseInt(customerid));
							pstmt.setInt(14, userId);
							rs = pstmt.executeQuery();
						  
							while(rs.next()) {
								region = rs.getString("GROUP_NAME");
								percentage1 = 0.0f;	
								
								if(rs.getDouble("IDLE_HRS1") != 0.0 && rs.getDouble("ENGINE_HRS1") !=0.0){
									if(rs.getDouble("IDLE_HRS1") < rs.getDouble("ENGINE_HRS1")){
								percentage1 = ((rs.getDouble("IDLE_HRS1")/rs.getDouble("ENGINE_HRS1"))*100);
									}else if(rs.getDouble("IDLE_HRS1") >= rs.getDouble("ENGINE_HRS1")){
										percentage1 = 100.0f;	
									}
								}	
								regionDistanceCountMap1.put(region, percentage1);
							}	
					
							pstmt = con.prepareStatement(FleetMaintanceStatements.GET_IDLING_PERCENTAGE_TREND.replace("#", replaceString));
							pstmt.setInt(1, -offset);
							pstmt.setString(2, week2stdt);
							pstmt.setInt(3, -offset);
							pstmt.setString(4, week2endt);
							pstmt.setInt(5, systemId);
							pstmt.setInt(6, Integer.parseInt(customerid));
							pstmt.setInt(7, userId);
							pstmt.setInt(8, -offset);
							pstmt.setString(9, week2stdt);
							pstmt.setInt(10, -offset);
							pstmt.setString(11, week2endt);
							pstmt.setInt(12, systemId);
							pstmt.setInt(13, Integer.parseInt(customerid));
							pstmt.setInt(14, userId);
							rs = pstmt.executeQuery();
						  
							while(rs.next()) {
								region = rs.getString("GROUP_NAME");
								percentage1 = 0.0;	
								
								if(rs.getDouble("IDLE_HRS1") != 0.0 && rs.getDouble("ENGINE_HRS1") !=0.0){
									if(rs.getDouble("IDLE_HRS1") < rs.getDouble("ENGINE_HRS1")){
								percentage1 = ((rs.getDouble("IDLE_HRS1")/rs.getDouble("ENGINE_HRS1"))*100);
									}else if(rs.getDouble("IDLE_HRS1") >= rs.getDouble("ENGINE_HRS1")){
										percentage1 = 100.0f;	
									}
								}	
								regionDistanceCountMap2.put(region, percentage1);
							}	
					
							
							pstmt = con.prepareStatement(FleetMaintanceStatements.GET_IDLING_PERCENTAGE_TREND.replace("#", replaceString));
							pstmt.setInt(1, -offset);
							pstmt.setString(2, week3stdt);
							pstmt.setInt(3, -offset);
							pstmt.setString(4, week3endt);
							pstmt.setInt(5, systemId);
							pstmt.setInt(6, Integer.parseInt(customerid));
							pstmt.setInt(7, userId);
							pstmt.setInt(8, -offset);
							pstmt.setString(9, week3stdt);
							pstmt.setInt(10, -offset);
							pstmt.setString(11, week3endt);
							pstmt.setInt(12, systemId);
							pstmt.setInt(13, Integer.parseInt(customerid));
							pstmt.setInt(14, userId);
							rs = pstmt.executeQuery();
						  
							while(rs.next()) {
								region = rs.getString("GROUP_NAME");
								percentage1 = 0.0;	
								
								if(rs.getDouble("IDLE_HRS1") != 0.0 && rs.getDouble("ENGINE_HRS1") !=0.0){
									if(rs.getDouble("IDLE_HRS1") < rs.getDouble("ENGINE_HRS1")){
								percentage1 = ((rs.getFloat("IDLE_HRS1")/rs.getDouble("ENGINE_HRS1"))*100);
									}else if(rs.getDouble("IDLE_HRS1") >= rs.getDouble("ENGINE_HRS1")){
										percentage1 = 100.0f;	
									}
								}	
								regionDistanceCountMap3.put(region, percentage1);
							}	
					
							int checkSize = regionDistanceCountMap1.size();
							HashMap<String, Double> loopmap = regionDistanceCountMap1;
							if(checkSize<regionDistanceCountMap2.size()){
								checkSize=regionDistanceCountMap2.size();
								loopmap = regionDistanceCountMap2;
							}
							if(checkSize<regionDistanceCountMap3.size()){
								checkSize=regionDistanceCountMap3.size();
								loopmap = regionDistanceCountMap3;
							}
						
							for(Map.Entry<String, Double> entry: loopmap.entrySet()){
								double arr2[] = {0,0,0};
								double per1 = 0.0f;
								double per2 =  0.0f;
								double per3 =  0.0f;
								region = entry.getKey();
								per1 = entry.getValue();
								if(regionDistanceCountMap1.containsKey(region)){
									per1 = regionDistanceCountMap1.get(region);	
								}else{
									per1 = 0;	
								}
								if(regionDistanceCountMap2.containsKey(region)){
									per2 = regionDistanceCountMap2.get(region);	
								}else{
									per2 = 0;	
								}if(regionDistanceCountMap3.containsKey(region)){
									per3 = regionDistanceCountMap3.get(region);	
								}else{
									per3 = 0;	
								}
								arr2[0] =per1;
								arr2[1] =per2;
								arr2[2] =per3;
								
								regionidleCountMap.put(region, arr2);	
								
							}
							
						
						
						if(regionVehicleCountMap.size()>0){
							int count = 0;
						    for(Map.Entry<String, Integer> entry: regionVehicleCountMap.entrySet()){
						    	count++;
								region = entry.getKey();
								if(regionidleCountMap.containsKey(region)){
									double perarr[] = regionidleCountMap.get(region);
									percentage1 = perarr[0];
									percentage2= perarr[1];
									percentage3= perarr[2];
								}else{
									percentage1 = 0;
									percentage2= 0;
									percentage3= 0;
								}				
							
							idlingJSONObject=new JSONObject();
										idlingJSONObject.put("groupName",region);		
										idlingJSONObject.put("percentage1",percentage1);
										idlingJSONObject.put("percentage2",percentage2);
										idlingJSONObject.put("percentage3",percentage3);
										idlingJSONArray.put(idlingJSONObject);		
							
							
						}
						}else {
							idlingJSONObject=new JSONObject();
										idlingJSONObject.put("groupName","");		
										idlingJSONObject.put("percentage1",0);
										idlingJSONObject.put("percentage2",0);
										idlingJSONObject.put("percentage3",0);
										idlingJSONArray.put(idlingJSONObject);  
						}
							
					
					
			   }
			   else if(duration.equalsIgnoreCase("MONTHLY")){
				   HashMap<String, Integer> regionVehicleCountMap = new HashMap<String, Integer>();
					HashMap<String, double[]> regionidleCountMap = new HashMap<String, double[]>();
				   String month1 = "";
				   String month2 = "";
				   String month3 = "";
				   
				   String month1stdt = "";
				   String month1endt = "";
				   String month2stdt = "";
				   String month2endt = "";
				   String month3stdt = "";
				   String month3endt = "";
				   int mn1 = 0;
				   int mn2 = 0;
				   int mn3 = 0;
				   percentage1 = 0.0f;
				   percentage2 = 0.0f;
				    percentage3 = 0.0f;
				    Calendar cal = Calendar.getInstance();
				    cal.setTime(selectedDate);
				    
				    cal.add(Calendar.MONTH, -1);
				    Date date = cal.getTime();
				    mn1 = Integer.parseInt(mnthFormat.format(date));
				    month1 = monthFormat.format(date);
				    				    
				    cal.add(Calendar.MONTH, -1);
				    date = cal.getTime();
				    mn2 = Integer.parseInt(mnthFormat.format(date));
				    month2 = monthFormat.format(date);
				   
				    cal.add(Calendar.MONTH, -1);
				    date = cal.getTime();
				    mn3 =Integer.parseInt(mnthFormat.format(date));
				    month3 = monthFormat.format(date);
				    
				 
					idlingJSONObject=new JSONObject();
					idlingJSONObject.put("groupName","Types");		
					idlingJSONObject.put("percentage1",month3);
					idlingJSONObject.put("percentage2",month2);
					idlingJSONObject.put("percentage3",month1);
					idlingJSONArray.put(idlingJSONObject);  		
					 Calendar cala = Calendar.getInstance();
					 cala.setTime(selectedDate);
					
					 cala.add(Calendar.MONTH, -1);					 
					 cala.set(Calendar.DAY_OF_MONTH,cala.getActualMaximum(Calendar.DAY_OF_MONTH));
					 setTimeToEndofDay(cala);
				     Date end = cala.getTime();
				     month1endt = dateFormatq.format(end);
				     
				     cala.add(Calendar.MONTH, -1);					 
					 cala.set(Calendar.DAY_OF_MONTH,cala.getActualMaximum(Calendar.DAY_OF_MONTH));
					 setTimeToEndofDay(cala);
				     end = cala.getTime();
				     month2endt = dateFormatq.format(end);
				     
				     cala.add(Calendar.MONTH, -1);					 
					 cala.set(Calendar.DAY_OF_MONTH,cala.getActualMaximum(Calendar.DAY_OF_MONTH));
					 setTimeToEndofDay(cala);
				     end = cala.getTime();
				     month3endt = dateFormatq.format(end);
				     
				     
				     Calendar cala2 = Calendar.getInstance();
					 cala2.setTime(selectedDate);
					 
					 cala2.add(Calendar.MONTH, -1);					 
					 cala2.set(Calendar.DAY_OF_MONTH,cala2.getActualMinimum(Calendar.DAY_OF_MONTH));
					 setTimeToBeginningOfDay(cala2);
				     Date start = cala2.getTime();
				     month1stdt = dateFormatq.format(start);
				        
				     cala2.add(Calendar.MONTH, -1);					 
					 cala2.set(Calendar.DAY_OF_MONTH,cala2.getActualMinimum(Calendar.DAY_OF_MONTH));
					 setTimeToBeginningOfDay(cala2);
				     start = cala2.getTime();
				     month2stdt = dateFormatq.format(start);
				     
				     cala2.add(Calendar.MONTH, -1);					 
					 cala2.set(Calendar.DAY_OF_MONTH,cala2.getActualMinimum(Calendar.DAY_OF_MONTH));
					 setTimeToBeginningOfDay(cala2);
				     start = cala2.getTime();
				     month3stdt = dateFormatq.format(start);
				     String replaceString = "";
						if(!vehicleType.equalsIgnoreCase("ALL")){
							replaceString = "and vt.VehicleType = '"+vehicleType+"' ";
						}
//					 if(vehicleType.contains("CAR")){
//						 replaceString = " and vt.VehicleType = 'CAR' ";
//					 }else if (vehicleType.contains("TRUCK")) {
//						 replaceString = " and vt.VehicleType = 'TRUCK' "; 
//					 }
				     if (reportType == 2){				    	 				    	 
				    	
					 
						 pstmt = con.prepareStatement(FleetMaintanceStatements.GET_VEHICLE_COUNT.replace("#", replaceString));					
							pstmt.setInt(1, systemId);
							pstmt.setInt(2, Integer.parseInt(customerid));
							pstmt.setInt(3, userId);
			             rs = pstmt.executeQuery();
						
						while(rs.next()) {											
							region = rs.getString("GROUP_NAME");
							regionVehicleCountMap.put(region, rs.getInt("VEHICLE_COUNT"));										
						}		
						 
							HashMap<String, Double> regionDistanceCountMap1 = new HashMap<String, Double>();
							HashMap<String, Double> regionDistanceCountMap2 = new HashMap<String,  Double>();
							HashMap<String, Double> regionDistanceCountMap3 = new HashMap<String,  Double>();						
							
							   	pstmt = con.prepareStatement(FleetMaintanceStatements.GET_IDLING_PERCENTAGE_TREND.replace("#", replaceString));
								pstmt.setInt(1, -offset);
								pstmt.setString(2, month1stdt+" 00:00:00");
								pstmt.setInt(3, -offset);
								pstmt.setString(4, month1endt+" 23:59:59");
								pstmt.setInt(5, systemId);
								pstmt.setInt(6, Integer.parseInt(customerid));
								pstmt.setInt(7, userId);
								pstmt.setInt(8, -offset);
								pstmt.setString(9, month1stdt+" 00:00:00");
								pstmt.setInt(10, -offset);
								pstmt.setString(11, month1endt+" 23:59:59");
								pstmt.setInt(12, systemId);
								pstmt.setInt(13, Integer.parseInt(customerid));
								pstmt.setInt(14, userId);
								rs = pstmt.executeQuery();
							  
								while(rs.next()) {
									region = rs.getString("GROUP_NAME");
									percentage1 = 0.0;	
									
									if(rs.getDouble("IDLE_HRS1") != 0.0 && rs.getDouble("ENGINE_HRS1") !=0.0){
										if(rs.getDouble("IDLE_HRS1") < rs.getDouble("ENGINE_HRS1")){
									percentage1 = ((rs.getDouble("IDLE_HRS1")/rs.getDouble("ENGINE_HRS1"))*100);
										}else if(rs.getDouble("IDLE_HRS1") >= rs.getDouble("ENGINE_HRS1")){
											percentage1 = 100.0f;	
										}
									}	
									regionDistanceCountMap1.put(region, percentage1);
								}	
						
								pstmt = con.prepareStatement(FleetMaintanceStatements.GET_IDLING_PERCENTAGE_TREND.replace("#", replaceString));
								pstmt.setInt(1, -offset);
								pstmt.setString(2, month2stdt+" 00:00:00");
								pstmt.setInt(3, -offset);
								pstmt.setString(4, month2endt+" 23:59:59");
								pstmt.setInt(5, systemId);
								pstmt.setInt(6, Integer.parseInt(customerid));
								pstmt.setInt(7, userId);
								pstmt.setInt(8, -offset);
								pstmt.setString(9, month2stdt+" 00:00:00");
								pstmt.setInt(10, -offset);
								pstmt.setString(11, month2endt+" 23:59:59");
								pstmt.setInt(12, systemId);
								pstmt.setInt(13, Integer.parseInt(customerid));
								pstmt.setInt(14, userId);
								rs = pstmt.executeQuery();
							  
								while(rs.next()) {
									region = rs.getString("GROUP_NAME");
									percentage1 = 0.0;	
									
									if(rs.getDouble("IDLE_HRS1") != 0.0 && rs.getDouble("ENGINE_HRS1") !=0.0){
										if(rs.getDouble("IDLE_HRS1") < rs.getDouble("ENGINE_HRS1")){
									percentage1 = ((rs.getFloat("IDLE_HRS1")/rs.getDouble("ENGINE_HRS1"))*100);
										}else if(rs.getDouble("IDLE_HRS1") >= rs.getDouble("ENGINE_HRS1")){
											percentage1 = 100.0f;	
										}
									}	
									regionDistanceCountMap2.put(region, percentage1);
								}	
						
								
								pstmt = con.prepareStatement(FleetMaintanceStatements.GET_IDLING_PERCENTAGE_TREND.replace("#", replaceString));
								pstmt.setInt(1, -offset);
								pstmt.setString(2, month3stdt+" 00:00:00");
								pstmt.setInt(3, -offset);
								pstmt.setString(4, month3endt+" 23:59:59");
								pstmt.setInt(5, systemId);
								pstmt.setInt(6, Integer.parseInt(customerid));
								pstmt.setInt(7, userId);
								pstmt.setInt(8, -offset);
								pstmt.setString(9, month3stdt+" 00:00:00");
								pstmt.setInt(10, -offset);
								pstmt.setString(11, month3endt+" 23:59:59");
								pstmt.setInt(12, systemId);
								pstmt.setInt(13, Integer.parseInt(customerid));
								pstmt.setInt(14, userId);
								rs = pstmt.executeQuery();
							  
								while(rs.next()) {
									region = rs.getString("GROUP_NAME");
									percentage1 = 0.0;	
									
									if(rs.getDouble("IDLE_HRS1") != 0.0 && rs.getDouble("ENGINE_HRS1") !=0.0){
										if(rs.getDouble("IDLE_HRS1") < rs.getDouble("ENGINE_HRS1")){
									percentage1 = ((rs.getDouble("IDLE_HRS1")/rs.getDouble("ENGINE_HRS1"))*100);
										}else if(rs.getDouble("IDLE_HRS1") >= rs.getDouble("ENGINE_HRS1")){
											percentage1 = 100.0f;	
										}
									}	
									regionDistanceCountMap3.put(region, percentage1);
								}	
						
								int checkSize = regionDistanceCountMap1.size();
								HashMap<String, Double> loopmap = regionDistanceCountMap1;
								if(checkSize<regionDistanceCountMap2.size()){
									checkSize=regionDistanceCountMap2.size();
									loopmap = regionDistanceCountMap2;
								}
								if(checkSize<regionDistanceCountMap3.size()){
									checkSize=regionDistanceCountMap3.size();
									loopmap = regionDistanceCountMap3;
								}
							
								for(Map.Entry<String, Double> entry: loopmap.entrySet()){
									double arr2[] = {0,0,0};
									double per1 = 0.0f;
									double per2 =  0.0f;
									double per3 =  0.0f;
									region = entry.getKey();
									per1 = entry.getValue();
									if(regionDistanceCountMap1.containsKey(region)){
										per1 = regionDistanceCountMap1.get(region);	
									}else{
										per1 = 0;	
									}
									if(regionDistanceCountMap2.containsKey(region)){
										per2 = regionDistanceCountMap2.get(region);	
									}else{
										per2 = 0;	
									}if(regionDistanceCountMap3.containsKey(region)){
										per3 = regionDistanceCountMap3.get(region);	
									}else{
										per3 = 0;	
									}
									arr2[0] =per1;
									arr2[1] =per2;
									arr2[2] =per3;
									
									regionidleCountMap.put(region, arr2);	
									
								}
								
							
							
							if(regionVehicleCountMap.size()>0){
								int count = 0;
							    for(Map.Entry<String, Integer> entry: regionVehicleCountMap.entrySet()){
							    	count++;
									region = entry.getKey();
									if(regionidleCountMap.containsKey(region)){
										double perarr[] = regionidleCountMap.get(region);
										percentage1 = perarr[0];
										percentage2= perarr[1];
										percentage3= perarr[2];
									}else{
										percentage1 = 0;
										percentage2= 0;
										percentage3= 0;
									}				
								
								idlingJSONObject=new JSONObject();	
								idlingJSONObject.put("groupName",region);		
								idlingJSONObject.put("percentage1",percentage3);
								idlingJSONObject.put("percentage2",percentage2);
								idlingJSONObject.put("percentage3",percentage1);
								idlingJSONArray.put(idlingJSONObject);								
								
							}
							}else {
								idlingJSONObject=new JSONObject();
											idlingJSONObject.put("groupName","");		
											idlingJSONObject.put("percentage1",0);
											idlingJSONObject.put("percentage2",0);
											idlingJSONObject.put("percentage3",0);
											idlingJSONArray.put(idlingJSONObject);  
							}
				    	 
				    	 
				    	 
				     }else if(reportType == 4 ){
				   percentage1 = 0.0f;
					  percentage2 = 0.0f;
					  percentage3 = 0.0f;
				    region = "";
					HashMap<String, ArrayList<Double>> regionFuelCountMap = new HashMap<String,  ArrayList<Double>>();
					HashMap<String, Double> regionFuelCountMap1 = new HashMap<String,  Double>();
					HashMap<String, Double> regionFuelCountMap2 = new HashMap<String,  Double>();
					HashMap<String, Double> regionFuelCountMap3 = new HashMap<String,  Double>();
					 ArrayList<String> vehicleList = new ArrayList<String>();
					 String vehicleList1 = "";
					 String vehicleList2 = "";
					 String vehicleList3 ="";
					 
					 replaceString = "";
						if(!vehicleType.equalsIgnoreCase("ALL")){
							replaceString = "and vt.VehicleType = '"+vehicleType+"' ";
						}
					 ArrayList<Double> arr = new ArrayList<Double>();
					 ArrayList<Double> arrr = new ArrayList<Double>();
//					 if(vehicleType.contains("CAR")){
//						 replaceString = " and vt.VehicleType = 'CAR' ";
//					 }else if (vehicleType.contains("TRUCK")) {
//						 replaceString = " and vt.VehicleType = 'TRUCK' "; 
//					 }
					 
					 
					 pstmt = con.prepareStatement(FleetMaintanceStatements.GET_FUEL.replace("#", replaceString));							
					 pstmt.setInt(1, -offset);  
					 pstmt.setString(2, month1stdt+" 00:00:00");
					 pstmt.setInt(3, -offset);
					 pstmt.setString(4, month1endt+" 23:59:59");
					 pstmt.setInt(5, systemId);
					 pstmt.setInt(6, Integer.parseInt(customerid));
					 pstmt.setInt(7, userId);
			         rs = pstmt.executeQuery();
			           
			           String group= "";
			           String prevGroup = "";
			           double fuel = 0;
			           double prevFuel = 0;
			           int count = 0;
					    while(rs.next()) {	
					    	count++;
					    	if(count == 1){
					    		prevFuel = rs.getDouble("FUEL");
					    		fuel = rs.getDouble("FUEL");
					    		vehicleList = new ArrayList<String>();
					    		group = rs.getString("GROUP_NAME");
					    		prevGroup = group;
					    		vehicleList.add("'"+rs.getString("ASSET_NUMBER")+"'");						    		
					    	}else{
					    		
					    		group = rs.getString("GROUP_NAME");
					    		fuel = rs.getDouble("FUEL");
					    		
					    		if(prevGroup.equals(group)){
					    			prevFuel = prevFuel+fuel;
					    			vehicleList.add("'"+rs.getString("ASSET_NUMBER")+"'");	
					    		}else{
					    			regionFuelCountMap1.put(prevGroup, prevFuel);
					    			//vehicleList = new ArrayList<String>();
						    		
					    			group = rs.getString("GROUP_NAME");
					    			fuel = rs.getDouble("FUEL");

						    		prevGroup = group;
						    		prevFuel = fuel;
						    		
						    		vehicleList.add("'"+rs.getString("ASSET_NUMBER")+"'");	
					    		}
					    	}
					    									
					}					
					    regionFuelCountMap1.put(prevGroup, prevFuel);
					    for(String vehicleNumber:vehicleList){
					    	vehicleList1 = vehicleList1+","+vehicleNumber;
					    }
					 pstmt = con.prepareStatement(FleetMaintanceStatements.GET_FUEL.replace("#", replaceString));							
					 pstmt.setInt(1, -offset);  
					 pstmt.setString(2, month2stdt+" 00:00:00");
					 pstmt.setInt(3, -offset);
					 pstmt.setString(4, month2endt+" 23:59:59");
					 pstmt.setInt(5, systemId);
					 pstmt.setInt(6, Integer.parseInt(customerid));
					 pstmt.setInt(7, userId);
			         rs = pstmt.executeQuery();
			           
			           group= "";
			           prevGroup = "";
			           fuel = 0;
			           prevFuel = 0;
			           count = 0;
					    while(rs.next()) {	
					    	count++;
					    	if(count == 1){
					    		prevFuel = rs.getDouble("FUEL");
					    		fuel = rs.getDouble("FUEL");
					    		vehicleList = new ArrayList<String>();
					    		group = rs.getString("GROUP_NAME");
					    		prevGroup = group;
					    		vehicleList.add("'"+rs.getString("ASSET_NUMBER")+"'");						    		
					    	}else{
					    		
					    		group = rs.getString("GROUP_NAME");
					    		fuel = rs.getDouble("FUEL");
					    		
					    		if(prevGroup.equals(group)){
					    			prevFuel = prevFuel+fuel;
					    			vehicleList.add("'"+rs.getString("ASSET_NUMBER")+"'");	
					    		}else{
					    			regionFuelCountMap2.put(prevGroup, prevFuel);
					    			//vehicleList = new ArrayList<String>();
						    		
					    			group = rs.getString("GROUP_NAME");
					    			fuel = rs.getDouble("FUEL");

						    		prevGroup = group;
						    		prevFuel = fuel;
						    		
						    		vehicleList.add("'"+rs.getString("ASSET_NUMBER")+"'");	
					    		}
					    	}
					    									
					}		
					    for(String vehicleNumber:vehicleList){
					    	vehicleList2 = vehicleList2+","+vehicleNumber;
					    }
					    regionFuelCountMap2.put(prevGroup, prevFuel);
			
						 pstmt = con.prepareStatement(FleetMaintanceStatements.GET_FUEL.replace("#", replaceString));							
						 pstmt.setInt(1, -offset);  
						 pstmt.setString(2, month3stdt+" 00:00:00");
						 pstmt.setInt(3, -offset);
						 pstmt.setString(4, month3endt+" 23:59:59");
						 pstmt.setInt(5, systemId);
						 pstmt.setInt(6, Integer.parseInt(customerid));
						 pstmt.setInt(7, userId);
				         rs = pstmt.executeQuery();
				           
				           group= "";
				           prevGroup = "";
				           fuel = 0;
				           prevFuel = 0;
				           count = 0;
						    while(rs.next()) {	
						    	count++;
						    	if(count == 1){
						    		prevFuel = rs.getDouble("FUEL");
						    		fuel = rs.getDouble("FUEL");
						    		vehicleList = new ArrayList<String>();
						    		group = rs.getString("GROUP_NAME");
						    		prevGroup = group;
						    		vehicleList.add("'"+rs.getString("ASSET_NUMBER")+"'");						    		
						    	}else{
						    		
						    		group = rs.getString("GROUP_NAME");
						    		fuel = rs.getDouble("FUEL");
						    		
						    		if(prevGroup.equals(group)){
						    			prevFuel = prevFuel+fuel;
						    			vehicleList.add("'"+rs.getString("ASSET_NUMBER")+"'");	
						    		}else{
						    			regionFuelCountMap3.put(prevGroup, prevFuel);
						    			//vehicleList = new ArrayList<String>();
							    		
						    			group = rs.getString("GROUP_NAME");
						    			fuel = rs.getDouble("FUEL");

							    		prevGroup = group;
							    		prevFuel = fuel;
							    		
							    		vehicleList.add("'"+rs.getString("ASSET_NUMBER")+"'");	
						    		}
						    	}
						    									
						}					
						    regionFuelCountMap3.put(prevGroup, prevFuel);	
						    for(String vehicleNumber:vehicleList){
						    	vehicleList3 = vehicleList3+","+vehicleNumber;
						    }
						    
						    
					int checkSize = regionFuelCountMap1.size();
					HashMap<String, Double> loopmap = regionFuelCountMap1;
					if(checkSize<regionFuelCountMap2.size()){
						checkSize=regionFuelCountMap2.size();
						loopmap = regionFuelCountMap2;
					}
					if(checkSize<regionFuelCountMap3.size()){
						checkSize=regionFuelCountMap3.size();
						loopmap = regionFuelCountMap3;
					}
					
					for(Map.Entry<String, Double> entry: loopmap.entrySet()){
						arr = new ArrayList<Double>();
						 double fuel1 = 0;
						 double fuel2 = 0;
						 double fuel3 = 0;
						region = entry.getKey();
						fuel1 = entry.getValue();
						if(regionFuelCountMap1.containsKey(region)){
							fuel1 = regionFuelCountMap1.get(region);	
						}else{
							fuel1 = 0;	
						}
						if(regionFuelCountMap2.containsKey(region)){
							fuel2 = regionFuelCountMap2.get(region);	
						}else{
							fuel2 = 0;	
						}if(regionFuelCountMap3.containsKey(region)){
							fuel3 = regionFuelCountMap3.get(region);	
						}else{
							fuel3 = 0;	
						}
						arr.add(fuel1);
						arr.add(fuel2);
						arr.add(fuel3);
						
						regionFuelCountMap.put(region, arr);
						
					}
					
					 percentage1 = 0.0f;
					  percentage2 = 0.0f;
					  percentage3 = 0.0f;
				    region = "";
					HashMap<String,  ArrayList<Double>> regionDistanceCountMap = new HashMap<String,  ArrayList<Double>>();
					HashMap<String, Double> regionDistanceCountMap1 = new HashMap<String, Double>();
					HashMap<String, Double> regionDistanceCountMap2 = new HashMap<String,  Double>();
					HashMap<String, Double> regionDistanceCountMap3 = new HashMap<String,  Double>();
					
					replaceString = "";
					if(!vehicleType.equalsIgnoreCase("ALL")){
						replaceString = "and vt.VehicleType = '"+vehicleType+"' ";
					}
					  arr = new ArrayList<Double>();
//					 if(vehicleType.contains("CAR")){
//						 replaceString = " and vt.VehicleType = 'CAR' ";
//					 }else if (vehicleType.contains("TRUCK")) {
//						 replaceString = " and vt.VehicleType = 'TRUCK' "; 
//					 }
					 if(vehicleList1.length()>1){
					 vehicleList1 = vehicleList1.substring(1);
					 }else{
					    	vehicleList1 = "' '";
					    }

					    pstmt = con.prepareStatement(FleetMaintanceStatements.GET_DISTANCE_COUNT_NEW_LOGIC.replace("#", replaceString).replace("$", vehicleList1));
						pstmt.setInt(1, -offset);  
						pstmt.setString(2, month1stdt+" 00:00:00");					
						pstmt.setInt(3, -offset);  
						pstmt.setString(4, month1endt+" 23:59:59");
	                    pstmt.setInt(5, systemId);
						pstmt.setInt(6, Integer.parseInt(customerid));
						pstmt.setInt(7, userId);
						pstmt.setInt(8, -offset);  
						pstmt.setString(9, month1stdt+" 00:00:00");					
						pstmt.setInt(10, -offset);  
						pstmt.setString(11, month1endt+" 23:59:59");
	                    pstmt.setInt(12, systemId);
						pstmt.setInt(13, Integer.parseInt(customerid));
						pstmt.setInt(14, userId);
						rs = pstmt.executeQuery();				
					while(rs.next()) {
						fuel = 0;
						region = rs.getString("GROUP_NAME");						
						fuel =  rs.getDouble("DISTANCE");
						regionDistanceCountMap1.put(region, fuel);						
					}	
					 if(vehicleList2.length()>1){
					 vehicleList2 = vehicleList2.substring(1);
					 }else{
						 vehicleList2 = "' '";
					    }

					 pstmt = con.prepareStatement(FleetMaintanceStatements.GET_DISTANCE_COUNT_NEW_LOGIC.replace("#", replaceString).replace("$", vehicleList2));
						pstmt.setInt(1, -offset);  
						pstmt.setString(2, month2stdt+" 00:00:00");					
						pstmt.setInt(3, -offset);  
						pstmt.setString(4, month2endt+" 23:59:59");
	                    pstmt.setInt(5, systemId);
						pstmt.setInt(6, Integer.parseInt(customerid));
						pstmt.setInt(7, userId);
						pstmt.setInt(8, -offset);  
						pstmt.setString(9, month2stdt+" 00:00:00");					
						pstmt.setInt(10, -offset);  
						pstmt.setString(11, month2endt+" 23:59:59");
	                    pstmt.setInt(12, systemId);
						pstmt.setInt(13, Integer.parseInt(customerid));
						pstmt.setInt(14, userId);
						rs = pstmt.executeQuery();				
					while(rs.next()) {
						fuel = 0;
						region = rs.getString("GROUP_NAME");						
						fuel =  rs.getDouble("DISTANCE");					
						regionDistanceCountMap2.put(region, fuel);						
					}	
					 if(vehicleList3.length()>1){
					 vehicleList3 = vehicleList3.substring(1);
					 }else{
						 vehicleList3 = "' '";
					 }
					 pstmt = con.prepareStatement(FleetMaintanceStatements.GET_DISTANCE_COUNT_NEW_LOGIC.replace("#", replaceString).replace("$", vehicleList3));
						pstmt.setInt(1, -offset);  
						pstmt.setString(2, month3stdt+" 00:00:00");					
						pstmt.setInt(3, -offset);  
						pstmt.setString(4, month3endt+" 23:59:59");
	                    pstmt.setInt(5, systemId);
						pstmt.setInt(6, Integer.parseInt(customerid));	 
						pstmt.setInt(7, userId);
						pstmt.setInt(8, -offset);  
						pstmt.setString(9, month3stdt+" 00:00:00");					
						pstmt.setInt(10, -offset);  
						pstmt.setString(11, month3endt+" 23:59:59");
	                    pstmt.setInt(12, systemId);
						pstmt.setInt(13, Integer.parseInt(customerid));
						pstmt.setInt(14, userId);
						rs = pstmt.executeQuery();
				
					while(rs.next()) {
						fuel = 0;
						region = rs.getString("GROUP_NAME");						
						fuel =  rs.getDouble("DISTANCE");					
						regionDistanceCountMap3.put(region, fuel);		
						
					}
					checkSize = regionDistanceCountMap1.size();
					loopmap = regionDistanceCountMap1;
					if(checkSize<regionDistanceCountMap2.size()){
						checkSize=regionDistanceCountMap2.size();
						loopmap = regionDistanceCountMap2;
					}
					if(checkSize<regionDistanceCountMap3.size()){
						checkSize=regionDistanceCountMap3.size();
						loopmap = regionDistanceCountMap3;
					}
					
					for(Map.Entry<String, Double> entry: loopmap.entrySet()){
						ArrayList<Double> arr2 = new ArrayList<Double>();
						double fuel1 = 0;
						double fuel2 = 0;
						double fuel3 = 0;
						region = entry.getKey();
						fuel1 = entry.getValue();
						if(regionDistanceCountMap1.containsKey(region)){
							fuel1 = regionDistanceCountMap1.get(region);	
						}else{
							fuel1 = 0;	
						}
						if(regionDistanceCountMap2.containsKey(region)){
							fuel2 = regionDistanceCountMap2.get(region);	
						}else{
							fuel2 = 0;	
						}if(regionDistanceCountMap3.containsKey(region)){
							fuel3 = regionDistanceCountMap3.get(region);	
						}else{
							fuel3 = 0;	
						}
						arr2.add(fuel1);
						arr2.add(fuel2);
						arr2.add(fuel3);
						
						regionDistanceCountMap.put(region, arr2);
						
					}
					
				
			double distance1 = 0;
			double distance2 = 0;
			double distance3 = 0;
			double fuel1 = 0;
			double fuel2 = 0;
			double fuel3 = 0;
			if(regionFuelCountMap.size()>0){
			    for(Map.Entry<String, ArrayList<Double>> entry: regionFuelCountMap.entrySet()){
				
			    	 distance1 = 0;
					 distance2 = 0;
					 distance3 = 0;
					 fuel1 = 0;
					 fuel2 = 0;
					 fuel3 = 0;
					 percentage1 = 0;
					 percentage2 = 0;
					 percentage3 = 0;
					// calculate percentages
					 region = entry.getKey();
					 ArrayList<Double> fuelarr = entry.getValue();
					 fuel1 =fuelarr.get(0);
					 fuel2 =fuelarr.get(1);
					 fuel3 =fuelarr.get(2);
					 if(regionDistanceCountMap.containsKey(entry.getKey())){
					 ArrayList<Double> distanceArr = regionDistanceCountMap.get(entry.getKey());
					 distance1 = distanceArr.get(0);
					 distance2 = distanceArr.get(1);
					 distance3 = distanceArr.get(2);
					 }					
					 if(fuel1!=0 && distance1 !=0){
					 percentage1 =(float) (distance1/fuel1); 
					 }if(fuel2!=0 && distance2 !=0){
					 percentage2 =(float) (distance2/fuel2); 
					 }if(fuel3!=0 && distance3 !=0){
					 percentage3 =(float) (distance3/fuel3); 
					 }
				idlingJSONObject=new JSONObject();
				idlingJSONObject.put("groupName",region);		
				idlingJSONObject.put("percentage1",percentage3);
				idlingJSONObject.put("percentage2",percentage2);
				idlingJSONObject.put("percentage3",percentage1);
				idlingJSONArray.put(idlingJSONObject);		
					
			     }
			   }else{
				    idlingJSONObject=new JSONObject();
					idlingJSONObject.put("groupName","");		
					idlingJSONObject.put("percentage1",0);
					idlingJSONObject.put("percentage2",0);
					idlingJSONObject.put("percentage3",0);
					idlingJSONArray.put(idlingJSONObject);		
						 
			   }
			   }
					
			   }

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return idlingJSONArray;
	}
	
	
	public JSONArray getPMTrend(int reportType ,String customerid, int systemId,int offset,String vehicleType,String duration,String selectedDateString,int userId) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String region = "";
		
		JSONArray idlingJSONArray=new JSONArray();
		JSONObject idlingJSONObject;
		DateFormat dateFormat = new SimpleDateFormat("yyyy/MM/dd");
		DateFormat dateFormatq = new SimpleDateFormat("yyyy-MM-dd");
		DateFormat dateFormatNew = new SimpleDateFormat("dd/MM/yyyy");
		DateFormat monthFormat = new SimpleDateFormat("MMM-yyyy");
		Date selectedDate = null;		
		try {
			selectedDate = dateFormatq.parse(selectedDateString);
			HashMap<String, Integer> regionAssetCountMap1 = new HashMap<String, Integer>();
			HashMap<String, Integer> regionAssetCountMap2 = new HashMap<String,  Integer>();
			HashMap<String, Integer> p1 = new HashMap<String,  Integer>();
			ArrayList<HashMap<String, Integer>> mapArray = new ArrayList<HashMap<String, Integer>>();
			HashMap<String, Integer> regionAssetCountMap3 = new HashMap<String,  Integer>();
			HashMap<String, Integer> regionAssetCountAll = new HashMap<String,  Integer>();

			int prevPm = 0;
		
			con = DBConnection.getDashboardConnection("AMS");			
			   if(duration.equalsIgnoreCase("DAILY")){				  
				   String day1 = "";
				   String day2 = "";
				   String day3 = "";
				   String day1q = "";
				   String day2q = "";
				   String day3q = "";
				    Calendar cal = Calendar.getInstance();
				    cal.setTime(selectedDate);
				   
				    cal.add(Calendar.DATE, -1);
				    Date date = cal.getTime();
				    day1 = dateFormatNew.format(date);
				    day1q = dateFormatq.format(date);	
				    
				    cal.setTime(selectedDate);
				    cal.add(Calendar.DATE, 0);
				    date = cal.getTime();
				    day2 = dateFormatNew.format(date);
				    day2q = dateFormatq.format(date);
				    
				    cal.setTime(selectedDate);
				    cal.add(Calendar.DATE, 1);
				    date = cal.getTime();
				    day3 = dateFormatNew.format(date);
				    day3q = dateFormatq.format(date);
				  				    
					idlingJSONObject=new JSONObject();
					idlingJSONObject.put("groupName","Types");		
					idlingJSONObject.put("percentage1",day1);
					idlingJSONObject.put("percentage2",day2);
					idlingJSONObject.put("percentage3",day3);
					idlingJSONArray.put(idlingJSONObject);  
					
					 String replaceString = "";
						if(!vehicleType.equalsIgnoreCase("ALL")){
							replaceString = "and vt.VehicleType = '"+vehicleType+"' ";
						}
//					 if(vehicleType.contains("CAR")){
//						 replaceString = " and vt.VehicleType = 'CAR' ";
//					 }else if (vehicleType.contains("TRUCK")) {
//						 replaceString = " and vt.VehicleType = 'TRUCK' "; 
//					 }
					
						pstmt = con.prepareStatement(FleetMaintanceStatements.GET_PM_SCHEDULED_ALL_VEHICLE.replace("#", replaceString));
						pstmt.setInt(1, systemId);
						pstmt.setInt(2, Integer.parseInt(customerid));
						pstmt.setInt(3, userId);
						 rs = pstmt.executeQuery();
							
							while(rs.next()) {							
								regionAssetCountAll.put(rs.getString("All_GROUP"),rs.getInt("VEHICLE_COUNT"));
							}

						pstmt = con.prepareStatement(FleetMaintanceStatements.GET_PM_COMPLETED_PREVIOUS_DURATION.replace("#", replaceString));
						pstmt.setInt(1, systemId);
						pstmt.setInt(2, Integer.parseInt(customerid));
						pstmt.setInt(3, userId);
						pstmt.setInt(4, -offset);
						pstmt.setString(5, day1q+" 00:00:00");
						pstmt.setInt(6, -offset);
						pstmt.setString(7, day1q+" 23:59:59");					
						rs = pstmt.executeQuery();						
						while(rs.next()) {
							region = rs.getString("GROUP_NAME");
							prevPm = 	 rs.getInt("ASSET_COUNT");	
							regionAssetCountMap1.put(region, prevPm);
						}

						pstmt = con.prepareStatement(FleetMaintanceStatements.GET_PM_SHEDULED_CURRENT_DURATION.replace("#", replaceString));
						pstmt.setInt(1, systemId);
						pstmt.setInt(2, Integer.parseInt(customerid));
						pstmt.setInt(3, userId);
						pstmt.setInt(4, -0);
						pstmt.setString(5, day2q+" 00:00:00");
						pstmt.setInt(6, -0);
						pstmt.setString(7, day2q+" 23:59:59");	
						pstmt.setInt(8, systemId);
						pstmt.setInt(9, Integer.parseInt(customerid));
						pstmt.setInt(10, userId);
						
						rs = pstmt.executeQuery();						
						while(rs.next()) {
							prevPm = 0;
							region = rs.getString("GROUP_NAME");
							prevPm = 	 rs.getInt("ASSET_COUNT");								
							regionAssetCountMap2.put(region, prevPm);
						}
					
						pstmt = con.prepareStatement(FleetMaintanceStatements.GET_PM_SHEDULED_CURRENT_DURATION_2.replace("#", replaceString));
						pstmt.setInt(1, systemId);
						pstmt.setInt(2, Integer.parseInt(customerid));
						pstmt.setInt(3, userId);
						pstmt.setInt(4, -0);
						pstmt.setString(5, day3q+" 00:00:00");
						pstmt.setInt(6, -0);
						pstmt.setString(7, day3q+" 23:59:59");
						
						rs = pstmt.executeQuery();						
						while(rs.next()) {
							prevPm = 0;
							region = rs.getString("GROUP_NAME");
							prevPm = 	 rs.getInt("ASSET_COUNT");								
							regionAssetCountMap3.put(region, prevPm);
						}
						int checkSize = regionAssetCountMap1.size();
						HashMap<String, Integer> loopmap = regionAssetCountMap1;
						if(checkSize<regionAssetCountMap2.size()){
							checkSize=regionAssetCountMap2.size();
							loopmap = regionAssetCountMap2;
						}
						if(checkSize<regionAssetCountMap3.size()){
							checkSize=regionAssetCountMap3.size();
							loopmap = regionAssetCountMap3;
						}if(checkSize<regionAssetCountAll.size()){
							checkSize=regionAssetCountAll.size();
							loopmap = regionAssetCountAll;
						}
						if(loopmap.size()>0){												
						for(Map.Entry<String, Integer> entry: loopmap.entrySet()){
							int asset1 = 0;
							int asset2 = 0;
							int asset3 = 0;
							region = entry.getKey();
							//asset1 = entry.getValue();
							if(regionAssetCountMap1.containsKey(region)){
								asset1 = regionAssetCountMap1.get(region);	
							}else{
								asset1 = 0;	
							}
							if(regionAssetCountMap2.containsKey(region)){
								asset2 = regionAssetCountMap2.get(region);	
							}else{
								asset2 = 0;	
							}if(regionAssetCountMap3.containsKey(region)){
								asset3 = regionAssetCountMap3.get(region);	
							}else{
								asset3 = 0;	
							}
							idlingJSONObject=new JSONObject();
							idlingJSONObject.put("groupName",region);		
							idlingJSONObject.put("percentage1",asset1);
							idlingJSONObject.put("percentage2",asset2);
							idlingJSONObject.put("percentage3",asset3);
							idlingJSONArray.put(idlingJSONObject);	
							
						}				
						}else{
							
							idlingJSONObject=new JSONObject();
							idlingJSONObject.put("groupName","");		
							idlingJSONObject.put("percentage1",0);
							idlingJSONObject.put("percentage2",0);
							idlingJSONObject.put("percentage3",0);
							idlingJSONArray.put(idlingJSONObject);	
							
						}
						
					
			   }
			
			   else if(duration.equalsIgnoreCase("WEEKLY")){
				   String week1 = "";
				   String week2 = "";
				   String week3 = "";
				   String week0 = "";
				   String week1stdt = "";
				   String week1endt = "";
				   String week2stdt = "";
				   String week2endt = "";
				   String week3stdt = "";
				   String week3endt = "";
				   
				   String replaceString = "";
					if(!vehicleType.equalsIgnoreCase("ALL")){
						replaceString = "and vt.VehicleType = '"+vehicleType+"' ";
					}
				   
				    Calendar cal = Calendar.getInstance();
				    cal.setTime(selectedDate);
				   
				    int daysBackToSat = cal.get(Calendar.DAY_OF_WEEK );
				    cal.add(Calendar.DATE, daysBackToSat*-1);
				    Date date = cal.getTime();
				    week3 = dateFormat.format(date);
				    String week3New = dateFormatNew.format(date);
				    Calendar caltoshowWeek1 = Calendar.getInstance();
				    caltoshowWeek1.setTime(date);
				    caltoshowWeek1.add(Calendar.DATE, 1);
				    date = caltoshowWeek1.getTime();
				    String week1toshw = dateFormat.format(date);
				    String week1toshwNew = dateFormatNew.format(date);
				    daysBackToSat = cal.get(Calendar.DAY_OF_WEEK );
				    cal.add(Calendar.DATE, daysBackToSat*-1);
				    date = cal.getTime();
				    week2 = dateFormat.format(date);
				    				    
				    Calendar caltoshowWeek2 = Calendar.getInstance();
				    caltoshowWeek2.setTime(date);
				    caltoshowWeek2.add(Calendar.DATE, 1);
				    date = caltoshowWeek2.getTime();
				    String week1t2shw = dateFormat.format(date);
				    String week1t2shwNew = dateFormatNew.format(date);
				    Calendar cal2 = Calendar.getInstance();
				    cal2.setTime(selectedDate);
				    
				    daysBackToSat = cal2.get(Calendar.DAY_OF_WEEK );
				    daysBackToSat = 7-daysBackToSat;
				    cal2.add(Calendar.DATE, daysBackToSat);
				    date = cal2.getTime();
				    week1 = dateFormat.format(date);
                    String week1New = dateFormatNew.format(date);
				    Calendar cal4 = Calendar.getInstance();
				    cal2.setTime(selectedDate);
				    
				    daysBackToSat = cal4.get(Calendar.DAY_OF_WEEK );
				    daysBackToSat = 7-daysBackToSat;
				    cal4.add(Calendar.DATE, daysBackToSat);
				    date = cal4.getTime();
				    
				    Calendar caltoshowWeek0 = Calendar.getInstance();
				    caltoshowWeek0.setTime(date);
				    caltoshowWeek0.add(Calendar.DATE, 1);
				    date = caltoshowWeek0.getTime();
				    
				    String week0toshw = dateFormat.format(date);
				    String week0toshwNew = dateFormatNew.format(date);

				    
				    cal2.setTime(date);
				    cal2.add(Calendar.DATE, 6);
				    date = cal2.getTime();
				    week0 = dateFormat.format(date);				  			    
				    String 	week0New = 	dateFormatNew.format(date);						  
				    week3stdt = week1t2shw+" 00:00:00";
					week3endt = week3+" 23:59:59";				    
					
					week2stdt = week1toshw+" 00:00:00";
					week2endt = week1+" 23:59:59";		
				
					week1stdt =  week0toshw+" 00:00:00";
					week1endt =  week0+" 23:59:59";
				    
					week0toshw=week0toshwNew+" TO "+week0New;	   				    
					week1toshw=week1toshwNew+" TO "+week1New;
				    week1t2shw=week1t2shwNew+" TO "+week3New;				 

					idlingJSONObject=new JSONObject();
					idlingJSONObject.put("groupName","Types");		
					idlingJSONObject.put("percentage1",week1t2shw);
					idlingJSONObject.put("percentage2",week1toshw);
					idlingJSONObject.put("percentage3",week0toshw);
					idlingJSONArray.put(idlingJSONObject);  
										
//					 if(vehicleType.contains("CAR")){
//						 replaceString = " and vt.VehicleType = 'CAR' ";
//					 }else if (vehicleType.contains("TRUCK")) {
//						 replaceString = " and vt.VehicleType = 'TRUCK' "; 
//					 }			 
						pstmt = con.prepareStatement(FleetMaintanceStatements.GET_PM_SCHEDULED_ALL_VEHICLE.replace("#", replaceString));
						pstmt.setInt(1, systemId);
						pstmt.setInt(2, Integer.parseInt(customerid));
						pstmt.setInt(3, userId);
						 rs = pstmt.executeQuery();
							
							while(rs.next()) {							
								regionAssetCountAll.put(rs.getString("All_GROUP"),rs.getInt("VEHICLE_COUNT"));
							}

						pstmt = con.prepareStatement(FleetMaintanceStatements.GET_PM_COMPLETED_PREVIOUS_DURATION.replace("#", replaceString));
						pstmt.setInt(1, systemId);
						pstmt.setInt(2, Integer.parseInt(customerid));
						pstmt.setInt(3, userId);
						pstmt.setInt(4, -offset);
						pstmt.setString(5, week3stdt);
						pstmt.setInt(6, -offset);
						pstmt.setString(7, week3endt);	
						rs = pstmt.executeQuery();						
						while(rs.next()) {
							region = rs.getString("GROUP_NAME");
							prevPm = 	 rs.getInt("ASSET_COUNT");	
							regionAssetCountMap1.put(region, prevPm);
						}
						
						
						HashMap<String, Integer> regionAssetCountMap2temp = new HashMap<String, Integer>();
						String dbformatWeek2Stdate = dateFormatq.format(dateFormat.parse(week2stdt));
						String dbformatWeek2Enddate = dateFormatq.format(dateFormat.parse(week2endt));
						String dbformatWeek3Stdate = dateFormatq.format(dateFormat.parse(week1stdt));
						String dbformatWeek3Enddate = dateFormatq.format(dateFormat.parse(week1endt));
						mapArray = getp2new(con,dbformatWeek2Stdate+" 00:00:00",dbformatWeek2Enddate+" 23:59:59",offset,systemId,Integer.parseInt(customerid),replaceString,dbformatWeek3Stdate+" 00:00:00",dbformatWeek3Enddate+" 23:59:59",userId,selectedDateString);
                        if(mapArray.size()>0){
                        for(int i=0;i<2;i++){
	                    if(i==0){
	                    regionAssetCountMap2temp=	mapArray.get(0);
	                    }else{
		                regionAssetCountMap3=	mapArray.get(1);
	                    }
                        }
			           }

						  int checksize = p1.size();
						  HashMap<String, Integer> loopsmap = p1;
							if(checksize<regionAssetCountMap2temp.size()){
								checksize=regionAssetCountMap2temp.size();
								loopsmap = regionAssetCountMap2temp;
							}
							int assetCount = 0;
						for(Map.Entry<String, Integer> entry: loopsmap.entrySet()){
							 assetCount = 0;
							 region =entry.getKey(); 
							if(p1.containsKey(region)){
								assetCount = p1.get(region);	
							}if(regionAssetCountMap2temp.containsKey(region)){
								assetCount =assetCount+ regionAssetCountMap2temp.get(region);	
							}
							regionAssetCountMap2.put(region, assetCount);
						}
					
					    int checkSize = regionAssetCountMap1.size();
						HashMap<String, Integer> loopmap = regionAssetCountMap1;
						if(checkSize<regionAssetCountMap2.size()){
							checkSize=regionAssetCountMap2.size();
							loopmap = regionAssetCountMap2;
						}
						if(checkSize<regionAssetCountMap3.size()){
							checkSize=regionAssetCountMap3.size();
							loopmap = regionAssetCountMap3;
						}if(checkSize<regionAssetCountAll.size()){
							checkSize=regionAssetCountAll.size();
							loopmap = regionAssetCountAll;
						}
						if(loopmap.size()>0){												
						for(Map.Entry<String, Integer> entry: loopmap.entrySet()){
							int asset1 = 0;
							int asset2 = 0;
							int asset3 = 0;
							region = entry.getKey();
							//asset1 = entry.getValue();
							if(regionAssetCountMap1.containsKey(region)){
								asset1 = regionAssetCountMap1.get(region);	
							}else{
								asset1 = 0;	
							}
							if(regionAssetCountMap2.containsKey(region)){
								asset2 = regionAssetCountMap2.get(region);	
							}else{
								asset2 = 0;	
							}if(regionAssetCountMap3.containsKey(region)){
								asset3 = regionAssetCountMap3.get(region);	
							}else{
								asset3 = 0;	
							}
							idlingJSONObject=new JSONObject();
							idlingJSONObject.put("groupName",region);		
							idlingJSONObject.put("percentage1",asset1);
							idlingJSONObject.put("percentage2",asset2);
							idlingJSONObject.put("percentage3",asset3);
							idlingJSONArray.put(idlingJSONObject);	
							
						}				
						}else{
							
							idlingJSONObject=new JSONObject();
							idlingJSONObject.put("groupName","");		
							idlingJSONObject.put("percentage1",0);
							idlingJSONObject.put("percentage2",0);
							idlingJSONObject.put("percentage3",0);
							idlingJSONArray.put(idlingJSONObject);	
							
						}
					 
			   }
			   else if(duration.equalsIgnoreCase("MONTHLY")){
				   
				   String month1 = "";
				   String month2 = "";
				   String month3 = "";
				   
				   String month1stdt = "";
				   String month1endt = "";
				   String month2stdt = "";
				   String month2endt = "";
				   String month3stdt = "";
				   String month3endt = "";
				   
				    Calendar cal = Calendar.getInstance();
				    cal.setTime(selectedDate);
				    
				    cal.add(Calendar.MONTH, -1);
				    Date date = cal.getTime();
				    month1 = monthFormat.format(date);
				    
				    cal.setTime(selectedDate);
				    cal.add(Calendar.MONTH, 0);
				    date = cal.getTime();
				    month2 = monthFormat.format(date);
				   
				    cal.setTime(selectedDate);
				    cal.add(Calendar.MONTH, 1);
				    date = cal.getTime();
				    month3 = monthFormat.format(date);

					idlingJSONObject=new JSONObject();
					idlingJSONObject.put("groupName","Types");		
					idlingJSONObject.put("percentage1",month1);
					idlingJSONObject.put("percentage2",month2);
					idlingJSONObject.put("percentage3",month3);
					idlingJSONArray.put(idlingJSONObject);  
				
					 Calendar cala = Calendar.getInstance();
					 cala.setTime(selectedDate);
					
					 cala.add(Calendar.MONTH, -1);					 
					 cala.set(Calendar.DAY_OF_MONTH,cala.getActualMaximum(Calendar.DAY_OF_MONTH));
					 setTimeToEndofDay(cala);
				     Date end = cala.getTime();
				     month1endt = dateFormatq.format(end);
				     
				     cala.setTime(selectedDate);
				     cala.add(Calendar.MONTH, 0);					 
					 cala.set(Calendar.DAY_OF_MONTH,cala.getActualMaximum(Calendar.DAY_OF_MONTH));
					 setTimeToEndofDay(cala);
				     end = cala.getTime();
				     month2endt = dateFormatq.format(end);
				     
				     cala.setTime(selectedDate);
				     cala.add(Calendar.MONTH, +1);					 
					 cala.set(Calendar.DAY_OF_MONTH,cala.getActualMaximum(Calendar.DAY_OF_MONTH));
					 setTimeToEndofDay(cala);
				     end = cala.getTime();
				     month3endt = dateFormatq.format(end);
				     
				     
				     Calendar cala2 = Calendar.getInstance();
					 cala2.setTime(selectedDate);
					 
					 cala2.add(Calendar.MONTH, -1);					 
					 cala2.set(Calendar.DAY_OF_MONTH,cala2.getActualMinimum(Calendar.DAY_OF_MONTH));
					 setTimeToBeginningOfDay(cala2);
				     Date start = cala2.getTime();
				     month1stdt = dateFormatq.format(start);
				      
				     cala2.setTime(selectedDate);
				     cala2.add(Calendar.MONTH, 0);					 
					 cala2.set(Calendar.DAY_OF_MONTH,cala2.getActualMinimum(Calendar.DAY_OF_MONTH));
					 setTimeToBeginningOfDay(cala2);
				     start = cala2.getTime();
				     month2stdt = dateFormatq.format(start);
				     
				     cala2.setTime(selectedDate);
				     cala2.add(Calendar.MONTH, +1);					 
					 cala2.set(Calendar.DAY_OF_MONTH,cala2.getActualMinimum(Calendar.DAY_OF_MONTH));
					 setTimeToBeginningOfDay(cala2);
				     start = cala2.getTime();
				     month3stdt = dateFormatq.format(start);
				     
				     String replaceString = "";
						if(!vehicleType.equalsIgnoreCase("ALL")){
							replaceString = "and vt.VehicleType = '"+vehicleType+"' ";
						}
//					 if(vehicleType.contains("CAR")){
//						 replaceString = " and vt.VehicleType = 'CAR' ";
//					 }else if (vehicleType.contains("TRUCK")) {
//						 replaceString = " and vt.VehicleType = 'TRUCK' "; 
//					 }

						pstmt = con.prepareStatement(FleetMaintanceStatements.GET_PM_SCHEDULED_ALL_VEHICLE.replace("#", replaceString));
						pstmt.setInt(1, systemId);
						pstmt.setInt(2, Integer.parseInt(customerid));
						pstmt.setInt(3, userId);
						 rs = pstmt.executeQuery();
							
							while(rs.next()) {							
								regionAssetCountAll.put(rs.getString("All_GROUP"),rs.getInt("VEHICLE_COUNT"));
							}

						pstmt = con.prepareStatement(FleetMaintanceStatements.GET_PM_COMPLETED_PREVIOUS_DURATION.replace("#", replaceString));
						//pstmt.setInt(1, 32);
						pstmt.setInt(1, systemId);
						pstmt.setInt(2, Integer.parseInt(customerid));
						pstmt.setInt(3, userId);
						pstmt.setInt(4, -offset);
						pstmt.setString(5, month1stdt+" 00:00:00");
						pstmt.setInt(6, -offset);
						pstmt.setString(7, month1endt+" 23:59:59");	
						rs = pstmt.executeQuery();						
						while(rs.next()) {
							region = rs.getString("GROUP_NAME");
							prevPm = 	 rs.getInt("ASSET_COUNT");	
							regionAssetCountMap1.put(region, prevPm);
						}
						
						HashMap<String, Integer> regionAssetCountMap2temp = new HashMap<String, Integer>();

						mapArray = getp2new(con,month2stdt+" 00:00:00",month2endt+" 23:59:59",offset,systemId,Integer.parseInt(customerid),replaceString,month3stdt+" 00:00:00",month3endt+" 23:59:59",userId,selectedDateString);
                        if(mapArray.size()>0){
                        for(int i=0;i<2;i++){
	                    if(i==0){
	                    regionAssetCountMap2temp=mapArray.get(0);
	                    }else{
		                regionAssetCountMap3=	mapArray.get(1);
	                    }
                        }
			           }

						  int checksize = p1.size();
						  HashMap<String, Integer> loopsmap = p1;
							if(checksize<regionAssetCountMap2temp.size()){
								checksize=regionAssetCountMap2temp.size();
								loopsmap = regionAssetCountMap2temp;
							}
							int assetCount = 0;
						for(Map.Entry<String, Integer> entry: loopsmap.entrySet()){
							 assetCount = 0;
							 region =entry.getKey(); 
							if(p1.containsKey(region)){
								assetCount = p1.get(region);	
							}if(regionAssetCountMap2temp.containsKey(region)){
								assetCount =assetCount+ regionAssetCountMap2temp.get(region);	
							}
							regionAssetCountMap2.put(region, assetCount);
						}
					    int checkSize = regionAssetCountMap1.size();											
						HashMap<String, Integer> loopmap = regionAssetCountMap1;
						if(checkSize<regionAssetCountMap2.size()){
							checkSize=regionAssetCountMap2.size();
							loopmap = regionAssetCountMap2;
						}
						if(checkSize<regionAssetCountMap3.size()){
							checkSize=regionAssetCountMap3.size();
							loopmap = regionAssetCountMap3;
						}if(checkSize<regionAssetCountAll.size()){
							checkSize=regionAssetCountAll.size();
							loopmap = regionAssetCountAll;
						}
						if(loopmap.size()>0){												
						for(Map.Entry<String, Integer> entry: loopmap.entrySet()){
							int asset1 = 0;
							int asset2 = 0;
							int asset3 = 0;
							region = entry.getKey();
							//asset1 = entry.getValue();
							if(regionAssetCountMap1.containsKey(region)){
								asset1 = regionAssetCountMap1.get(region);	
							}else{
								asset1 = 0;	
							}
							if(regionAssetCountMap2.containsKey(region)){
								asset2 = regionAssetCountMap2.get(region);	
							}else{
								asset2 = 0;	
							}if(regionAssetCountMap3.containsKey(region)){
								asset3 = regionAssetCountMap3.get(region);	
							}else{
								asset3 = 0;	
							}
							idlingJSONObject=new JSONObject();
							idlingJSONObject.put("groupName",region);		
							idlingJSONObject.put("percentage1",asset1);
							idlingJSONObject.put("percentage2",asset2);
							idlingJSONObject.put("percentage3",asset3);
							idlingJSONArray.put(idlingJSONObject);	
							
						}				
						}else{
						
							idlingJSONObject=new JSONObject();
							idlingJSONObject.put("groupName","");		
							idlingJSONObject.put("percentage1",0);
							idlingJSONObject.put("percentage2",0);
							idlingJSONObject.put("percentage3",0);
							idlingJSONArray.put(idlingJSONObject);	
							
						}
						
			   }

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return idlingJSONArray;
	}
	
	
	public JSONArray getStatutoryTrend(int reportType ,String customerid, int systemId,int offset,String vehicleType,String statutoryType,String duration,String selectedDateString, int userId) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String region = "";
		int expalertId = 0;
		int duealertId = 0;
		String alertType =  " " ;
        if(statutoryType.equals("Insurance")){
        	 expalertId = 32;
    		 duealertId = 10;
    		 alertType =  " vt.Insurance  " ;
		}else if(statutoryType.equals("Goods Token Tax")){
			 expalertId = 33;
			 duealertId = 11;
			 alertType =  " vt.Goods_TokenTax " ;
		}else if(statutoryType.equals("FCI")){
			 expalertId = 34;
			 duealertId = 12;
			 alertType =  " vt.FC " ;
		}else if(statutoryType.equals("Emission")){
			 expalertId = 35;
			 duealertId = 13;
			 alertType= " vt.EmissionCheck " ;
		}else if(statutoryType.equals("Permit")){
			 expalertId = 36;
			 duealertId = 15;
			 alertType= " vt.PermitValidity " ;
		}else if(statutoryType.equals("Registration")){
			 expalertId = 131;
			 duealertId = 130;
			 alertType= " vt.RegistrationExpiryDate " ;
		}else if(statutoryType.equals("Driver Licence")){
			 expalertId = 142;
			 duealertId = 141;			
	    }else {
	    	
	    }
		
		JSONArray idlingJSONArray=new JSONArray();
		JSONObject idlingJSONObject;
		DateFormat dateFormat = new SimpleDateFormat("yyyy/MM/dd");
		DateFormat dateFormatNew = new SimpleDateFormat("dd/MM/yyyy");
		DateFormat dateFormatq = new SimpleDateFormat("yyyy-MM-dd");
		DateFormat monthFormat = new SimpleDateFormat("MMM-yyyy");
		Date selectedDate = null;		
		try {
			selectedDate = dateFormatq.parse(selectedDateString);
			HashMap<String, Integer> regionAssetCountMap1 = new HashMap<String, Integer>();
			HashMap<String, Integer> regionAssetCountMap2 = new HashMap<String,  Integer>();
			HashMap<String, Integer> regionAssetCountMap3 = new HashMap<String,  Integer>();
			HashMap<String, Integer> regionAssetCountAll = new HashMap<String,  Integer>();
			
			int prevPm = 0;
		
			con = DBConnection.getDashboardConnection("AMS");			
			   if(duration.equalsIgnoreCase("DAILY")){				  
				   String day1 = "";
				   String day2 = "";
				   String day3 = "";
				   String day1q = "";
				   String day2q = "";
				   String day3q = "";
				    Calendar cal = Calendar.getInstance();
				    cal.setTime(selectedDate);
				    cal.add(Calendar.DATE, -1);
				    Date date = cal.getTime();
				    day1 = dateFormatNew.format(date);
				    day1q = dateFormatq.format(date);	
				    
				    cal.setTime(selectedDate);
				    cal.add(Calendar.DATE, 0);
				    date = cal.getTime();
				    day2 = dateFormatNew.format(date);
				    day2q = dateFormatq.format(date);
				    
				    cal.setTime(selectedDate);
				    cal.add(Calendar.DATE, 1);
				    date = cal.getTime();
				    day3 = dateFormatNew.format(date);
				    day3q = dateFormatq.format(date);
				  				    
					idlingJSONObject=new JSONObject();
					idlingJSONObject.put("groupName","Types");		
					idlingJSONObject.put("percentage1",day1);
					idlingJSONObject.put("percentage2",day2);
					idlingJSONObject.put("percentage3",day3);
					idlingJSONArray.put(idlingJSONObject);  
					
					 String replaceString = "";
						if(!vehicleType.equalsIgnoreCase("ALL")){
							replaceString = "and vt.VehicleType = '"+vehicleType+"' ";
						}
//					 if(vehicleType.contains("CAR")){
//						 replaceString = " and vt.VehicleType = 'CAR' ";
//					 }else if (vehicleType.contains("TRUCK")) {
//						 replaceString = " and vt.VehicleType = 'TRUCK' "; 
//					 }

					 			        	
			        	   pstmt = con.prepareStatement(FleetMaintanceStatements.GET_STATUTORY_DUE_COUNT.replace("#", replaceString));
							pstmt.setInt(1, systemId);
							pstmt.setInt(2, Integer.parseInt(customerid));
							pstmt.setInt(3, userId);
							pstmt.setInt(4,expalertId);							
							pstmt.setString(5, day1q+" 00:00:00");
							pstmt.setString(6, day1q+" 23:59:59");							
							pstmt.setInt(7, systemId);
							pstmt.setInt(8, Integer.parseInt(customerid));
							pstmt.setInt(9, userId);
							pstmt.setInt(10,expalertId);							
							pstmt.setString(11, day1q+" 00:00:00");
							pstmt.setString(12, day1q+" 23:59:59");										        	   
						rs = pstmt.executeQuery();						
						while(rs.next()) {
							region = rs.getString("GROUP_NAME");
							prevPm = 	 rs.getInt("ASSET_COUNT");	
							regionAssetCountMap1.put(region, prevPm);
						}
								        	
				        	   pstmt = con.prepareStatement(FleetMaintanceStatements.GET_STATUTORY_DUE_COUNT.replace("#", replaceString));
				        	    pstmt.setInt(1, systemId);
								pstmt.setInt(2, Integer.parseInt(customerid));
								pstmt.setInt(3, userId);
								pstmt.setInt(4,expalertId);		
								pstmt.setString(5, day2q+" 00:00:00");
								pstmt.setString(6, day2q+" 23:59:59");							
								pstmt.setInt(7, systemId);
								pstmt.setInt(8, Integer.parseInt(customerid));
								pstmt.setInt(9, userId);
								pstmt.setInt(10,duealertId);		
								pstmt.setString(11, day2q+" 00:00:00");
								pstmt.setString(12, day2q+" 23:59:59");								
								rs = pstmt.executeQuery();								
								while(rs.next()) {
									region = rs.getString("GROUP_NAME");
									prevPm = 	 rs.getInt("ASSET_COUNT");	
									regionAssetCountMap2.put(region, prevPm);
								}								
				           		if(statutoryType.equals("Driver Licence")){
						        	 pstmt = con.prepareStatement(FleetMaintanceStatements.GET_STATUTORY_DUE_DRIVER_LICENSE.replace("#", replaceString));	
						        	 pstmt.setInt(1, systemId);
									 pstmt.setInt(2, Integer.parseInt(customerid));
									 pstmt.setInt(3, userId);
									 pstmt.setString(4, day3q+" 00:00:00");
									 pstmt.setString(5, day3q+" 23:59:59");	
				           		}
								else{        	
					        	pstmt = con.prepareStatement(FleetMaintanceStatements.GET_STATUTORY_DUE_COUNT_FORECASTING.replace("#", replaceString).replace("$", alertType+ " between "+"'"+day3q+" 00:00:00' and "+"'"+day3q+" 23:59:59'"+" "));
				        	    pstmt.setInt(1, systemId);
								pstmt.setInt(2, Integer.parseInt(customerid));
								pstmt.setInt(3, userId);
									
								}
								rs = pstmt.executeQuery();
								
								while(rs.next()) {
									region = rs.getString("GROUP_NAME");
									prevPm = 	 rs.getInt("ASSET_COUNT");	
									regionAssetCountMap3.put(region, prevPm);								
				           }											
								
								pstmt = con.prepareStatement(FleetMaintanceStatements.GET_PM_SCHEDULED_ALL_VEHICLE.replace("#", replaceString));
								pstmt.setInt(1, systemId);
								pstmt.setInt(2, Integer.parseInt(customerid));
								pstmt.setInt(3, userId);
								 rs = pstmt.executeQuery();
									
									while(rs.next()) {							
										regionAssetCountAll.put(rs.getString("All_GROUP"),rs.getInt("VEHICLE_COUNT"));
									} 
								
						int checkSize = regionAssetCountMap1.size();
						HashMap<String, Integer> loopmap = regionAssetCountMap1;
						if(checkSize<regionAssetCountMap2.size()){
							checkSize=regionAssetCountMap2.size();
							loopmap = regionAssetCountMap2;
						}
						if(checkSize<regionAssetCountMap3.size()){
							checkSize=regionAssetCountMap3.size();
							loopmap = regionAssetCountMap3;
						}if(checkSize<regionAssetCountAll.size()){
							checkSize=regionAssetCountAll.size();
							loopmap = regionAssetCountAll;
						}
						if(loopmap.size()>0){
						for(Map.Entry<String, Integer> entry: loopmap.entrySet()){
							int asset1 = 0;
							int asset2 = 0;
							int asset3 = 0;
							region = entry.getKey();
							asset1 = entry.getValue();
							if(regionAssetCountMap1.containsKey(region)){
								asset1 = regionAssetCountMap1.get(region);	
							}else{
								asset1 = 0;	
							}
							if(regionAssetCountMap2.containsKey(region)){
								asset2 = regionAssetCountMap2.get(region);	
							}else{
								asset2 = 0;	
							}if(regionAssetCountMap3.containsKey(region)){
								asset3 = regionAssetCountMap3.get(region);	
							}else{
								asset3 = 0;	
							}
							idlingJSONObject=new JSONObject();
							idlingJSONObject.put("groupName",region);		
							idlingJSONObject.put("percentage1",asset1);
							idlingJSONObject.put("percentage2",asset2);
							idlingJSONObject.put("percentage3",asset3);
							idlingJSONArray.put(idlingJSONObject);	
							
						}											
			   }else{
				    idlingJSONObject=new JSONObject();
					idlingJSONObject.put("groupName",region);		
					idlingJSONObject.put("percentage1",0);
					idlingJSONObject.put("percentage2",0);
					idlingJSONObject.put("percentage3",0);
					idlingJSONArray.put(idlingJSONObject);	
			   }
			   }
			
			   else if(duration.equalsIgnoreCase("WEEKLY")){
				   String week1 = "";
				   String week2 = "";
				   String week3 = "";
				   String week0 = "";
				   String week1stdt = "";
				   String week1endt = "";
				   String week2stdt = "";
				   String week2endt = "";
				   String week3stdt = "";
				   String week3endt = "";
				   
				   String replaceString = "";
					if(!vehicleType.equalsIgnoreCase("ALL")){
						replaceString = "and vt.VehicleType = '"+vehicleType+"' ";
					}
				   
				    Calendar cal = Calendar.getInstance();
				    cal.setTime(selectedDate);
				   
				    int daysBackToSat = cal.get(Calendar.DAY_OF_WEEK );
				    cal.add(Calendar.DATE, daysBackToSat*-1);
				    Date date = cal.getTime();
				    week3 = dateFormat.format(date);
				   String week3New =  dateFormatNew.format(date);
				    Calendar caltoshowWeek1 = Calendar.getInstance();
				    caltoshowWeek1.setTime(date);
				    caltoshowWeek1.add(Calendar.DATE, 1);
				    date = caltoshowWeek1.getTime();
				    String week1toshw = dateFormat.format(date);
				    String week1toshwNew = dateFormatNew.format(date); 
				    daysBackToSat = cal.get(Calendar.DAY_OF_WEEK );
				    cal.add(Calendar.DATE, daysBackToSat*-1);
				    date = cal.getTime();
				    week2 = dateFormat.format(date);
				    				    
				    Calendar caltoshowWeek2 = Calendar.getInstance();
				    caltoshowWeek2.setTime(date);
				    caltoshowWeek2.add(Calendar.DATE, 1);
				    date = caltoshowWeek2.getTime();
				    String week1t2shw = dateFormat.format(date);
				    String week1t2shwNew = dateFormatNew.format(date);
				    Calendar cal2 = Calendar.getInstance();
				    cal2.setTime(selectedDate);
				    
				    daysBackToSat = cal2.get(Calendar.DAY_OF_WEEK );
				    daysBackToSat = 7-daysBackToSat;
				    cal2.add(Calendar.DATE, daysBackToSat);
				    date = cal2.getTime();
				    week1 = dateFormat.format(date);
                    String week1New = dateFormatNew.format(date);
				    Calendar cal4 = Calendar.getInstance();
				    cal2.setTime(selectedDate);
				    
				    daysBackToSat = cal4.get(Calendar.DAY_OF_WEEK );
				    daysBackToSat = 7-daysBackToSat;
				    cal4.add(Calendar.DATE, daysBackToSat);
				    date = cal4.getTime();
				    
				    Calendar caltoshowWeek0 = Calendar.getInstance();
				    caltoshowWeek0.setTime(date);
				    caltoshowWeek0.add(Calendar.DATE, 1);
				    date = caltoshowWeek0.getTime();
				    
				    String week0toshw = dateFormat.format(date);
				    String week0toshwNew = dateFormatNew.format(date);
				    cal2.setTime(date);
				    cal2.add(Calendar.DATE, 6);
				    date = cal2.getTime();
				    week0 = dateFormat.format(date);				  			    
				    String week0New = dateFormatNew.format(date);									  
				    week3stdt = week1t2shw+" 00:00:00";
					week3endt = week3+" 23:59:59";				    
					
					week2stdt = week1toshw+" 00:00:00";
					week2endt = week1+" 23:59:59";		
				
					week1stdt =  week0toshw;
					week1endt =  week0;
				    
					week0toshw=week0toshwNew+" TO "+week0New;	   				    
					week1toshw=week1toshwNew+" TO "+week1New;
				    week1t2shw=week1t2shwNew+" TO "+week3New;				 

					idlingJSONObject=new JSONObject();
					idlingJSONObject.put("groupName","Types");		
					idlingJSONObject.put("percentage1",week1t2shw);
					idlingJSONObject.put("percentage2",week1toshw);
					idlingJSONObject.put("percentage3",week0toshw);
					idlingJSONArray.put(idlingJSONObject);  
										
//					 if(vehicleType.contains("CAR")){
//						 replaceString = " and vt.VehicleType = 'CAR' ";
//					 }else if (vehicleType.contains("TRUCK")) {
//						 replaceString = " and vt.VehicleType = 'TRUCK' "; 
//					 }
					  			        	
				        	   pstmt = con.prepareStatement(FleetMaintanceStatements.GET_STATUTORY_DUE_COUNT.replace("#", replaceString));
				        	    pstmt.setInt(1, systemId);
								pstmt.setInt(2, Integer.parseInt(customerid));
								pstmt.setInt(3,userId);	
								pstmt.setInt(4,expalertId);	
								pstmt.setString(5, week3stdt);
								pstmt.setString(6, week3endt);							
								pstmt.setInt(7, systemId);
								pstmt.setInt(8, Integer.parseInt(customerid));
								pstmt.setInt(9,userId);	
								pstmt.setInt(10,expalertId);	
								pstmt.setString(11, week3stdt);
								pstmt.setString(12, week3endt);										        	   
						rs = pstmt.executeQuery();
						
						while(rs.next()) {
							region = rs.getString("GROUP_NAME");
							prevPm = rs.getInt("ASSET_COUNT");	
							regionAssetCountMap1.put(region, prevPm);
						}
						if(statutoryType.equals("Driver Licence")){
							 pstmt = con.prepareStatement(FleetMaintanceStatements.GET_STATUTORY_DUE_DRIVER_LICENSE.replace("#", replaceString));	
				        	 pstmt.setInt(1, systemId);
							 pstmt.setInt(2, Integer.parseInt(customerid));
							 pstmt.setInt(3, userId);
							 pstmt.setString(4, week2stdt);
							 pstmt.setString(5, week2endt);	
						}
						else   {     	
						   pstmt = con.prepareStatement(FleetMaintanceStatements.GET_STATUTORY_DUE_COUNT_FORECASTING.replace("#", replaceString).replace("$", alertType+ " between "+"'"+week2stdt+"' and "+"'"+week2endt+"'"+" "));
			        	    pstmt.setInt(1, systemId);
							pstmt.setInt(2, Integer.parseInt(customerid));
							pstmt.setInt(3, userId);
			   }
							rs = pstmt.executeQuery();						
								while(rs.next()) {
									region = rs.getString("GROUP_NAME");
									prevPm = 	 rs.getInt("ASSET_COUNT");	
									regionAssetCountMap2.put(region, prevPm);
								}
								if(statutoryType.equals("Driver Licence")){
						        	 pstmt = con.prepareStatement(FleetMaintanceStatements.GET_STATUTORY_DUE_DRIVER_LICENSE.replace("#", replaceString));	
						        	 pstmt.setInt(1, systemId);
									 pstmt.setInt(2, Integer.parseInt(customerid));
									 pstmt.setInt(3, userId);
									 pstmt.setString(4, week1stdt+" 00:00:00");
									 pstmt.setString(5, week1endt+" 23:59:59");	
									 rs = pstmt.executeQuery();
				           		}
								else{        	
				        	   pstmt = con.prepareStatement(FleetMaintanceStatements.GET_STATUTORY_DUE_COUNT_FORECASTING.replace("#", replaceString).replace("$", alertType+ " between "+"'"+week1stdt+" 00:00:00' and "+"'"+week1endt+" 23:59:59'"+" "));
				        	    pstmt.setInt(1, systemId);
								pstmt.setInt(2, Integer.parseInt(customerid));
								pstmt.setInt(3, userId);														
								rs = pstmt.executeQuery();
								
								while(rs.next()) {
									region = rs.getString("GROUP_NAME");
									prevPm = 	 rs.getInt("ASSET_COUNT");	
									regionAssetCountMap3.put(region, prevPm);
								}
			   }
								pstmt = con.prepareStatement(FleetMaintanceStatements.GET_PM_SCHEDULED_ALL_VEHICLE.replace("#", replaceString));
								pstmt.setInt(1, systemId);
								pstmt.setInt(2, Integer.parseInt(customerid));
								pstmt.setInt(3, userId);
							    rs = pstmt.executeQuery();
									
									while(rs.next()) {							
										regionAssetCountAll.put(rs.getString("All_GROUP"),rs.getInt("VEHICLE_COUNT"));
									} 
								
						int checkSize = regionAssetCountMap1.size();
						HashMap<String, Integer> loopmap = regionAssetCountMap1;
						if(checkSize<regionAssetCountMap2.size()){
							checkSize=regionAssetCountMap2.size();
							loopmap = regionAssetCountMap2;
						}
						if(checkSize<regionAssetCountMap3.size()){
							checkSize=regionAssetCountMap3.size();
							loopmap = regionAssetCountMap3;
						}if(checkSize<regionAssetCountAll.size()){
							checkSize=regionAssetCountAll.size();
							loopmap = regionAssetCountAll;
						}
						if(loopmap.size()>0){
						for(Map.Entry<String, Integer> entry: loopmap.entrySet()){
							int asset1 = 0;
							int asset2 = 0;
							int asset3 = 0;
							region = entry.getKey();
							asset1 = entry.getValue();
							if(regionAssetCountMap1.containsKey(region)){
								asset1 = regionAssetCountMap1.get(region);	
							}else{
								asset1 = 0;	
							}
							if(regionAssetCountMap2.containsKey(region)){
								asset2 = regionAssetCountMap2.get(region);	
							}else{
								asset2 = 0;	
							}if(regionAssetCountMap3.containsKey(region)){
								asset3 = regionAssetCountMap3.get(region);	
							}else{
								asset3 = 0;	
							}
							idlingJSONObject=new JSONObject();
							idlingJSONObject.put("groupName",region);		
							idlingJSONObject.put("percentage1",asset1);
							idlingJSONObject.put("percentage2",asset2);
							idlingJSONObject.put("percentage3",asset3);
							idlingJSONArray.put(idlingJSONObject);	
							
						}
			   }else{
					idlingJSONObject=new JSONObject();
					idlingJSONObject.put("groupName","");		
					idlingJSONObject.put("percentage1",0);
					idlingJSONObject.put("percentage2",0);
					idlingJSONObject.put("percentage3",0);
					idlingJSONArray.put(idlingJSONObject);	
			   }
			   }
			   else if(duration.equalsIgnoreCase("MONTHLY")){
				   
				   String month1 = "";
				   String month2 = "";
				   String month3 = "";
				   
				   String month1stdt = "";
				   String month1endt = "";
				   String month2stdt = "";
				   String month2endt = "";
				   String month3stdt = "";
				   String month3endt = "";
				   
				    Calendar cal = Calendar.getInstance();
				    cal.setTime(selectedDate);
				    
				    cal.add(Calendar.MONTH, -1);
				    Date date = cal.getTime();
				    month1 = monthFormat.format(date);
				    
				    cal.setTime(selectedDate);
				    cal.add(Calendar.MONTH, 0);
				    date = cal.getTime();
				    month2 = monthFormat.format(date);
				   
				    cal.setTime(selectedDate);
				    cal.add(Calendar.MONTH, 1);
				    date = cal.getTime();
				    month3 = monthFormat.format(date);

					idlingJSONObject=new JSONObject();
					idlingJSONObject.put("groupName","Types");		
					idlingJSONObject.put("percentage1",month1);
					idlingJSONObject.put("percentage2",month2);
					idlingJSONObject.put("percentage3",month3);
					idlingJSONArray.put(idlingJSONObject);  
				
					 Calendar cala = Calendar.getInstance();
					 cala.setTime(selectedDate);
					
					 cala.add(Calendar.MONTH, -1);					 
					 cala.set(Calendar.DAY_OF_MONTH,cala.getActualMaximum(Calendar.DAY_OF_MONTH));
					 setTimeToEndofDay(cala);
				     Date end = cala.getTime();
				     month1endt = dateFormatq.format(end);
				     
				     cala.setTime(selectedDate);
				     cala.add(Calendar.MONTH, 0);					 
					 cala.set(Calendar.DAY_OF_MONTH,cala.getActualMaximum(Calendar.DAY_OF_MONTH));
					 setTimeToEndofDay(cala);
				     end = cala.getTime();
				     month2endt = dateFormatq.format(end);
				     
				     cala.setTime(selectedDate);
				     cala.add(Calendar.MONTH, +1);					 
					 cala.set(Calendar.DAY_OF_MONTH,cala.getActualMaximum(Calendar.DAY_OF_MONTH));
					 setTimeToEndofDay(cala);
				     end = cala.getTime();
				     month3endt = dateFormatq.format(end);
				     
				     
				     Calendar cala2 = Calendar.getInstance();
					 cala2.setTime(selectedDate);
					 
					 cala2.add(Calendar.MONTH, -1);					 
					 cala2.set(Calendar.DAY_OF_MONTH,cala2.getActualMinimum(Calendar.DAY_OF_MONTH));
					 setTimeToBeginningOfDay(cala2);
				     Date start = cala2.getTime();
				     month1stdt = dateFormatq.format(start);
				      
				     cala2.setTime(selectedDate);
				     cala2.add(Calendar.MONTH, 0);					 
					 cala2.set(Calendar.DAY_OF_MONTH,cala2.getActualMinimum(Calendar.DAY_OF_MONTH));
					 setTimeToBeginningOfDay(cala2);
				     start = cala2.getTime();
				     month2stdt = dateFormatq.format(start);
				     
				     cala2.setTime(selectedDate);
				     cala2.add(Calendar.MONTH, +1);					 
					 cala2.set(Calendar.DAY_OF_MONTH,cala2.getActualMinimum(Calendar.DAY_OF_MONTH));
					 setTimeToBeginningOfDay(cala2);
				     start = cala2.getTime();
				     month3stdt = dateFormatq.format(start);
				     
				     String replaceString = "";
						if(!vehicleType.equalsIgnoreCase("ALL")){
							replaceString = "and vt.VehicleType = '"+vehicleType+"' ";
						}
//					 if(vehicleType.contains("CAR")){
//						 replaceString = " and vt.VehicleType = 'CAR' ";
//					 }else if (vehicleType.contains("TRUCK")) {
//						 replaceString = " and vt.VehicleType = 'TRUCK' "; 
//					 }
							        	
			        	   pstmt = con.prepareStatement(FleetMaintanceStatements.GET_STATUTORY_DUE_COUNT.replace("#", replaceString));
			        	   pstmt.setInt(1, systemId);
						   pstmt.setInt(2, Integer.parseInt(customerid));
						   pstmt.setInt(3, userId);
							pstmt.setInt(4,expalertId);	
							pstmt.setString(5,  month1stdt+" 00:00:00");
							pstmt.setString(6, month1endt+" 23:59:59");							
							 pstmt.setInt(7, systemId);
								pstmt.setInt(8, Integer.parseInt(customerid));
								 pstmt.setInt(9, userId);
								pstmt.setInt(10,expalertId);	
								pstmt.setString(11,  month1stdt+" 00:00:00");
								pstmt.setString(12, month1endt+" 23:59:59");									        	   
							rs = pstmt.executeQuery();
							
							while(rs.next()) {
								region = rs.getString("GROUP_NAME");
								prevPm = rs.getInt("ASSET_COUNT");	
								regionAssetCountMap1.put(region, prevPm);
							}
							if(statutoryType.equals("Driver Licence")){
					        	 pstmt = con.prepareStatement(FleetMaintanceStatements.GET_STATUTORY_DUE_DRIVER_LICENSE.replace("#", replaceString));	
					        	 pstmt.setInt(1, systemId);
								 pstmt.setInt(2, Integer.parseInt(customerid));
								 pstmt.setInt(3, userId);
								 pstmt.setString(4, month2stdt+" 00:00:00");
								 pstmt.setString(5, month2endt+" 23:59:59");
								 rs = pstmt.executeQuery();
			           		}
							else{   	
				           pstmt = con.prepareStatement(FleetMaintanceStatements.GET_STATUTORY_DUE_COUNT_FORECASTING.replace("#", replaceString).replace("$", alertType + " between "+"'"+month2stdt+" 00:00:00'"+" and "+"'"+month2endt+" 23:59:59'"+" "));
			        	   pstmt.setInt(1, systemId);
							pstmt.setInt(2, Integer.parseInt(customerid));
							 pstmt.setInt(3, userId);									
							rs = pstmt.executeQuery();
							}
					        	 
									while(rs.next()) {
										region = rs.getString("GROUP_NAME");
										prevPm = 	 rs.getInt("ASSET_COUNT");	
										regionAssetCountMap2.put(region, prevPm);
									}
									if(statutoryType.equals("Driver Licence")){
							        	 pstmt = con.prepareStatement(FleetMaintanceStatements.GET_STATUTORY_DUE_DRIVER_LICENSE.replace("#", replaceString));	
							        	 pstmt.setInt(1, systemId);
										 pstmt.setInt(2, Integer.parseInt(customerid));
										 pstmt.setInt(3, userId);
										 pstmt.setString(4, month3stdt+" 00:00:00");
										 pstmt.setString(5, month3endt+" 23:59:59");
										 rs = pstmt.executeQuery();
					           		}
									else{   	
						           pstmt = con.prepareStatement(FleetMaintanceStatements.GET_STATUTORY_DUE_COUNT_FORECASTING.replace("#", replaceString).replace("$", alertType + " between "+"'"+month3stdt+" 00:00:00'"+" and "+"'"+month3endt+" 23:59:59'"+" "));
					        	   pstmt.setInt(1, systemId);
									pstmt.setInt(2, Integer.parseInt(customerid));
									 pstmt.setInt(3, userId);									
									rs = pstmt.executeQuery();
									}
									while(rs.next()) {
										region = rs.getString("GROUP_NAME");
										prevPm = 	 rs.getInt("ASSET_COUNT");	
										regionAssetCountMap3.put(region, prevPm);
									}
									
									pstmt = con.prepareStatement(FleetMaintanceStatements.GET_PM_SCHEDULED_ALL_VEHICLE.replace("#", replaceString));
									pstmt.setInt(1, systemId);
									pstmt.setInt(2, Integer.parseInt(customerid));
									 pstmt.setInt(3, userId);
									 rs = pstmt.executeQuery();
										
										while(rs.next()) {							
											regionAssetCountAll.put(rs.getString("All_GROUP"),rs.getInt("VEHICLE_COUNT"));
										}   					
																					
							int checkSize = regionAssetCountMap1.size();
							HashMap<String, Integer> loopmap = regionAssetCountMap1;
							if(checkSize<regionAssetCountMap2.size()){
								checkSize=regionAssetCountMap2.size();
								loopmap = regionAssetCountMap2;
							}
							if(checkSize<regionAssetCountMap3.size()){
								checkSize=regionAssetCountMap3.size();
								loopmap = regionAssetCountMap3;
							}if(checkSize<regionAssetCountAll.size()){
								checkSize=regionAssetCountAll.size();
								loopmap = regionAssetCountAll;
							}
							if(loopmap.size()>0){
							for(Map.Entry<String, Integer> entry: loopmap.entrySet()){
								int asset1 = 0;
								int asset2 = 0;
								int asset3 = 0;
								region = entry.getKey();
								asset1 = entry.getValue();
								if(regionAssetCountMap1.containsKey(region)){
									asset1 = regionAssetCountMap1.get(region);	
								}else{
									asset1 = 0;	
								}
								if(regionAssetCountMap2.containsKey(region)){
									asset2 = regionAssetCountMap2.get(region);	
								}else{
									asset2 = 0;	
								}if(regionAssetCountMap3.containsKey(region)){
									asset3 = regionAssetCountMap3.get(region);	
								}else{
									asset3 = 0;	
								}
								idlingJSONObject=new JSONObject();
								idlingJSONObject.put("groupName",region);		
								idlingJSONObject.put("percentage1",asset1);
								idlingJSONObject.put("percentage2",asset2);
								idlingJSONObject.put("percentage3",asset3);
								idlingJSONArray.put(idlingJSONObject);	
							}
							}else{
								idlingJSONObject=new JSONObject();
								idlingJSONObject.put("groupName","");		
								idlingJSONObject.put("percentage1",0);
								idlingJSONObject.put("percentage2",0);
								idlingJSONObject.put("percentage3",0);
								idlingJSONArray.put(idlingJSONObject);	
							}
					
			   }

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return idlingJSONArray;
	}
	
	
	
	
	public JSONArray getIdlingdetailsforclick(int reportType ,String customerid, int systemId,int offset,String vehicleType,String startDate,String endDate, String groupName,String duration, int userId,String statutoryType, int columnNum) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String region = "";
		double percentage = 0.0f;
		JSONArray idlingJSONArray=new JSONArray();
		JSONObject idlingJSONObject;
		String footer = "";
		DateFormat dateFormat2 = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss.SSS");
		DateFormat dateFormatNew = new SimpleDateFormat("dd/MM/yyyy");
		try {
			con = DBConnection.getDashboardConnection("AMS");
			 String replaceString = "";
				if(!vehicleType.equalsIgnoreCase("ALL")){
					replaceString = "and vt.VehicleType = '"+vehicleType+"' ";
				}
//			 if(vehicleType.contains("CAR")){
//				 replaceString = " and vt.VehicleType = 'CAR' ";
//			 }else if (vehicleType.contains("TRUCK")) {
//				 replaceString = " and vt.VehicleType = 'TRUCK' "; 
//			 }
			
			 
			if(reportType == 1){
				
				HashMap<String, String[]> regionidleCountMap = new HashMap<String, String []>();		
				pstmt = con.prepareStatement(FleetMaintanceStatements.GET_IDLING_PERCENTAGE_ONCLICK.replace("#", replaceString));
				pstmt.setInt(1, -offset); 
				pstmt.setString(2, startDate+" 00:00:00");
				pstmt.setInt(3, -offset); 
				pstmt.setString(4, endDate+" 23:59:59");
				pstmt.setInt(5, systemId);
				pstmt.setInt(6, Integer.parseInt(customerid));
				pstmt.setInt(7, userId);
				pstmt.setString(8, groupName);
				pstmt.setInt(9, -offset); 
				pstmt.setString(10, startDate+" 00:00:00");
				pstmt.setInt(11, -offset); 
				pstmt.setString(12, endDate+" 23:59:59");
				pstmt.setInt(13, systemId);
				pstmt.setInt(14, Integer.parseInt(customerid));
				pstmt.setInt(15, userId);
				pstmt.setString(16, groupName);
			rs = pstmt.executeQuery();
			
			while(rs.next()) {	
				String percentages = "0.0";
				if (rs.getDouble("IDLE_HRS") != 0.0
						&& rs.getDouble("ENGINE_HRS") != 0.0) {
					double idleDuration = rs.getDouble("IDLE_HRS");

					double engineDuration = rs.getDouble("ENGINE_HRS");
					percentages = dftwodigit.format(((idleDuration / engineDuration) * 100));
				} else {
					percentages = "0.0";
				}
				String arr[]= {percentages,getHHMMTimeFormat(rs.getDouble("IDLE_HRS")),getHHMMTimeFormat(rs.getDouble("ENGINE_HRS")),rs.getString("VehicleType") };
				regionidleCountMap.put(rs.getString("VEHICLE_NO"), arr);
			}

		int count = 0;
	    for(Map.Entry<String, String[]> entry: regionidleCountMap.entrySet()){
	    	count++;
			String veh = entry.getKey();
				
				String percentages[] = regionidleCountMap.get(veh);					
			
			  idlingJSONObject=new JSONObject();
				idlingJSONObject.put("vehicleNoDateIndex",veh);
				idlingJSONObject.put("groupNameDataIndex",groupName);
				idlingJSONObject.put("idlinghrsDataIndex",percentages[1]);
				idlingJSONObject.put("enginehrsDataIndex",percentages[2]);
				idlingJSONObject.put("startDateDataIndex","");
				idlingJSONObject.put("endDateDataIndex","");
				idlingJSONObject.put("idlingCountDataIndex",percentages[0]);
				idlingJSONObject.put("pmCountDataIndex",0);
				idlingJSONObject.put("pmCountbeforeexpDataIndex",0);
				idlingJSONObject.put("pmCountafterexpDataIndex",0);
				idlingJSONObject.put("vehicleTypeDateIndex",percentages[3]);
				idlingJSONArray.put(idlingJSONObject);
			
	}
	
	    
				
		}else if(reportType == 3){
			DateFormat dateFormatNew2 = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
			DateFormat dateFormatq2 = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			
			pstmt = con.prepareStatement(FleetMaintanceStatements.GET_OVERSPEED_COUNT_ORC_ONCLICK.replace("#", replaceString));
			pstmt.setInt(1, -offset);
			pstmt.setString(2, startDate+" 00:00:00");
			pstmt.setInt(3, -offset);
			pstmt.setString(4, endDate+" 23:59:59");
			pstmt.setInt(5, systemId);
			pstmt.setInt(6, Integer.parseInt(customerid));
			pstmt.setInt(7, userId);
			pstmt.setString(8, groupName);
			pstmt.setInt(9, -offset);
			pstmt.setString(10, startDate+" 00:00:00");
			pstmt.setInt(11, -offset);
			pstmt.setString(12, endDate+" 23:59:59");
			pstmt.setInt(13, systemId);
			pstmt.setInt(14, Integer.parseInt(customerid));
			pstmt.setInt(15, userId);
			pstmt.setString(16, groupName);
	        rs = pstmt.executeQuery();
		
		while(rs.next()) {

			String groupname = rs.getString("GROUP_NAME");
			String vehicle = rs.getString("REGISTRATION_NO");
			String startTime = rs.getString("START_GPS_DATETIME");
			String endTime = rs.getString("END_GPS_DATETIME");
			String startLocation = rs.getString("START_LOCATION");
			String endLocation = rs.getString("END_LOCATION");
			String vehicleTypes = rs.getString("VehicleType");
			idlingJSONObject=new JSONObject();
			idlingJSONObject.put("vehicleNoDateIndex",vehicle);
			idlingJSONObject.put("groupNameDataIndex",groupname);
			idlingJSONObject.put("startDateDataIndex","");
			idlingJSONObject.put("startDateNewDataIndex",dateFormatNew2.format(dateFormatq2.parse(startTime)));
			idlingJSONObject.put("endDateDataIndex",dateFormatNew2.format(dateFormatq2.parse(endTime)));
			idlingJSONObject.put("idlinghrsDataIndex","");
			idlingJSONObject.put("enginehrsDataIndex","");
			idlingJSONObject.put("idlingCountDataIndex","");
			idlingJSONObject.put("pmCountDataIndex","");
			idlingJSONObject.put("pmCountbeforeexpDataIndex","");
			idlingJSONObject.put("pmCountafterexpDataIndex","");
			idlingJSONObject.put("pmDateDataIndex","");
			idlingJSONObject.put("startLocationDataIndex",startLocation);
			idlingJSONObject.put("endLocationDataIndex",endLocation);
			idlingJSONObject.put("vehicleTypeDateIndex",vehicleTypes);
			idlingJSONArray.put(idlingJSONObject);			

			
		}

	    }else if(reportType == 7){
			 						
		pstmt = con.prepareStatement(FleetMaintanceStatements.GET_PM_EXPIRED_COUNT_ON_CLICK.replace("#", replaceString));
		pstmt.setInt(1, 0);
		pstmt.setInt(2, systemId);
		pstmt.setInt(3, Integer.parseInt(customerid));
		pstmt.setInt(4, userId);
		pstmt.setInt(5, -0);
		pstmt.setString(6, startDate);
		pstmt.setInt(7, -0);
		pstmt.setString(8, endDate);
		pstmt.setString(9, groupName);		
		rs = pstmt.executeQuery();
	while(rs.next()) {
				
		    idlingJSONObject=new JSONObject();
			idlingJSONObject.put("vehicleNoDateIndex",rs.getString("ASSET_NUMBER"));
			idlingJSONObject.put("groupNameDataIndex",rs.getString("GROUP_NAME"));
			idlingJSONObject.put("idlinghrsDataIndex",0);
			idlingJSONObject.put("enginehrsDataIndex",0);
			idlingJSONObject.put("startDateDataIndex","");
			idlingJSONObject.put("endDateDataIndex","");
			idlingJSONObject.put("idlingCountDataIndex",0);
			idlingJSONObject.put("pmCountDataIndex",0);
			idlingJSONObject.put("pmCountbeforeexpDataIndex","PM COMPLETED AFTER EXPIRY");
			idlingJSONObject.put("pmCountafterexpDataIndex",0);
			idlingJSONObject.put("vehicleTypeDateIndex",rs.getString("VehicleType"));
			idlingJSONObject.put("pmDateDataIndex",dateFormatNew.format(dateFormat2.parse(rs.getString("LAST_SERVICE_DATE"))));
			idlingJSONArray.put(idlingJSONObject);			
		
	}	

	pstmt = con.prepareStatement(FleetMaintanceStatements.GET_PM_NON_EXPIRED_COUNT_ON_CLICK.replace("#", replaceString));
	pstmt.setInt(1, 0);
	pstmt.setInt(2, systemId);
	pstmt.setInt(3, Integer.parseInt(customerid));
	pstmt.setInt(4, userId);
	pstmt.setInt(5, -0);
	pstmt.setString(6, startDate);
	pstmt.setInt(7, -0);
	pstmt.setString(8, endDate);
	pstmt.setString(9, groupName);
	rs = pstmt.executeQuery();
while(rs.next()) {
			
	  idlingJSONObject=new JSONObject();
		idlingJSONObject.put("vehicleNoDateIndex",rs.getString("ASSET_NUMBER"));
		idlingJSONObject.put("groupNameDataIndex",rs.getString("GROUP_NAME"));
		idlingJSONObject.put("idlinghrsDataIndex",0);
		idlingJSONObject.put("enginehrsDataIndex",0);
		idlingJSONObject.put("startDateDataIndex","");
		idlingJSONObject.put("endDateDataIndex","");
		idlingJSONObject.put("idlingCountDataIndex",0);
		idlingJSONObject.put("pmCountDataIndex",0);
		idlingJSONObject.put("pmCountbeforeexpDataIndex","PM COMPLETED BEFORE EXPIRY");
		idlingJSONObject.put("pmCountafterexpDataIndex",0);
		idlingJSONObject.put("vehicleTypeDateIndex",rs.getString("VehicleType"));
		idlingJSONObject.put("pmDateDataIndex",dateFormatNew.format(dateFormat2.parse(rs.getString("LAST_SERVICE_DATE"))));
		idlingJSONArray.put(idlingJSONObject);			
		
	
}		
	    
		}
else if(reportType == 5 || reportType == 2 || reportType == 4 || reportType == 6 ){
	
	DateFormat dateFormat = new SimpleDateFormat("yyyy/MM/dd");
	DateFormat dateFormatq = new SimpleDateFormat("yyyy-MM-dd");
	DateFormat monthFormat = new SimpleDateFormat("MMM-yyyy");
	Date selectedDate = null;		
	try {
		selectedDate = dateFormatq.parse(startDate);
	
		int prevPm = 0;
	
		con = DBConnection.getDashboardConnection("AMS");	
		
		
		
		   if(duration.equalsIgnoreCase("DAILY")){	
			   
			   HashMap<String, Integer> regionAssetCountMap1 = new HashMap<String, Integer>();
				ArrayList<String[]> regionAssetCountMap2 = new ArrayList<String[]>();
				HashMap<String, Integer> p1 = new HashMap<String,  Integer>();
				ArrayList<ArrayList<String []>>  mapArrayOnclick = new ArrayList<ArrayList<String []>> ();
				ArrayList<String[]> regionAssetCountMap3 = new ArrayList<String[]>();
				HashMap<String, Integer> regionAssetCountAll = new HashMap<String,  Integer>();

				   String day1 = "";
				   String day2 = "";
				   String day3 = "";
				   String day1q = "";
				   String day2q = "";
				   String day3q = "";
			   if(reportType == 5|| reportType == 6 ){
			   
			    Calendar cal = Calendar.getInstance();
			    cal.setTime(selectedDate);
			   
			    cal.add(Calendar.DATE, -1);
			    Date date = cal.getTime();
			    day1 = dateFormat.format(date);
			    day1q = dateFormatq.format(date);	
			    
			    cal.setTime(selectedDate);
			    cal.add(Calendar.DATE, 0);
			    date = cal.getTime();
			    day2 = dateFormat.format(date);
			    day2q = dateFormatq.format(date);
			    
			    cal.setTime(selectedDate);
			    cal.add(Calendar.DATE, 1);
			    date = cal.getTime();
			    day3 = dateFormat.format(date);
			    day3q = dateFormatq.format(date);
			   }else if(reportType == 2 || reportType == 4){
				 
			
				    Calendar cal = Calendar.getInstance();
				    cal.setTime(selectedDate);
				    cal.add(Calendar.DATE, -1);
				    Date date = cal.getTime();
				    day1 = dateFormatNew.format(date);
				    day1q = dateFormatq.format(date);				    
				    cal.add(Calendar.DATE, -1);
				    date = cal.getTime();
				    day2 = dateFormatNew.format(date);
				    day2q = dateFormatq.format(date);
				    cal.add(Calendar.DATE, -1);
				    date = cal.getTime();
				    day3 = dateFormatNew.format(date);
				    day3q = dateFormatq.format(date);
			   }
			
				
				 if(reportType == 5){
					if(columnNum == 1){ 
					pstmt = con.prepareStatement(FleetMaintanceStatements.GET_PM_COMPLETED_PREVIOUS_DURATION_ONCLICK.replace("#", replaceString));
					pstmt.setInt(1, offset);
					pstmt.setInt(2, systemId);
					pstmt.setInt(3, Integer.parseInt(customerid));
					pstmt.setInt(4, userId);
					pstmt.setString(5, groupName);
					pstmt.setInt(6, -offset);
					pstmt.setString(7, day1q+" 00:00:00");
					pstmt.setInt(8, -offset);
					pstmt.setString(9, day1q+" 23:59:59");		
					rs = pstmt.executeQuery();						
					while(rs.next()) {
						
						idlingJSONObject=new JSONObject();
						idlingJSONObject.put("vehicleNoDateIndex",rs.getString("ASSET_NUMBER"));
						idlingJSONObject.put("groupNameDataIndex",rs.getString("GROUP_NAME"));
						idlingJSONObject.put("idlinghrsDataIndex",0);
						idlingJSONObject.put("enginehrsDataIndex",0);
						idlingJSONObject.put("startDateDataIndex",dateFormatNew.format(dateFormat2.parse(rs.getString("LAST_SERVICE_DATE"))));
						idlingJSONObject.put("endDateDataIndex","");
						idlingJSONObject.put("idlingCountDataIndex",0);
						idlingJSONObject.put("pmCountDataIndex",0);
						idlingJSONObject.put("pmCountbeforeexpDataIndex",0);
						idlingJSONObject.put("pmCountafterexpDataIndex",0);
						idlingJSONObject.put("PMStatusDataIndex","SERVICE COMPLETED");
						idlingJSONObject.put("vehicleTypeDateIndex",rs.getString("VehicleType"));
						idlingJSONArray.put(idlingJSONObject);
					}
				 }
					if(columnNum == 2){
					pstmt = con.prepareStatement(FleetMaintanceStatements.GET_PM_SCHEDULED_CURRENT_DURATION_ONCLICK.replace("#", replaceString));
					pstmt.setInt(1, 0);
					pstmt.setInt(2, systemId);
					pstmt.setInt(3, Integer.parseInt(customerid));
					pstmt.setInt(4, userId);
					pstmt.setString(5, groupName);
					pstmt.setInt(6, -0);
					pstmt.setString(7, day2q+" 00:00:00");
					pstmt.setInt(8, -0);
					pstmt.setString(9, day2q+" 23:59:59");	
					pstmt.setInt(10, 0);
					pstmt.setInt(11, systemId);
					pstmt.setInt(12, Integer.parseInt(customerid));
					pstmt.setInt(13, userId);
					pstmt.setString(14, groupName);
					rs = pstmt.executeQuery();						
					while(rs.next()) {
						
						idlingJSONObject=new JSONObject();
						idlingJSONObject.put("vehicleNoDateIndex",rs.getString("ASSET_NUMBER"));
						idlingJSONObject.put("groupNameDataIndex",rs.getString("GROUP_NAME"));
						idlingJSONObject.put("idlinghrsDataIndex",0);
						idlingJSONObject.put("enginehrsDataIndex",0);
						idlingJSONObject.put("startDateDataIndex",dateFormatNew.format(dateFormat2.parse(rs.getString("LAST_SERVICE_DATE"))));
						idlingJSONObject.put("endDateDataIndex","");
						idlingJSONObject.put("idlingCountDataIndex",0);
						idlingJSONObject.put("pmCountDataIndex",0);
						idlingJSONObject.put("pmCountbeforeexpDataIndex",0);
						idlingJSONObject.put("pmCountafterexpDataIndex",0);
						idlingJSONObject.put("PMStatusDataIndex","SERVICE PENDING");
						idlingJSONObject.put("vehicleTypeDateIndex",rs.getString("VehicleType"));
						idlingJSONArray.put(idlingJSONObject);
					}
				 }
					if(columnNum == 3){
					pstmt = con.prepareStatement(FleetMaintanceStatements.GET_PM_SCHEDULED_CURRENT_DURATION_ONCLICK_2.replace("#", replaceString));
					pstmt.setInt(1, 0);
					pstmt.setInt(2, systemId);
					pstmt.setInt(3, Integer.parseInt(customerid));
					pstmt.setInt(4, userId);
					pstmt.setString(5, groupName);
					pstmt.setInt(6, -0);
					pstmt.setString(7, day3q+" 00:00:00");
					pstmt.setInt(8, -0);
					pstmt.setString(9, day3q+" 23:59:59");
					rs = pstmt.executeQuery();						
					while(rs.next()) {
						
						idlingJSONObject=new JSONObject();
						idlingJSONObject.put("vehicleNoDateIndex",rs.getString("ASSET_NUMBER"));
						idlingJSONObject.put("groupNameDataIndex",rs.getString("GROUP_NAME"));
						idlingJSONObject.put("idlinghrsDataIndex",0);
						idlingJSONObject.put("enginehrsDataIndex",0);
						idlingJSONObject.put("startDateDataIndex",dateFormatNew.format(dateFormat2.parse(rs.getString("LAST_SERVICE_DATE"))));
						idlingJSONObject.put("endDateDataIndex","");
						idlingJSONObject.put("idlingCountDataIndex",0);
						idlingJSONObject.put("pmCountDataIndex",0);
						idlingJSONObject.put("pmCountbeforeexpDataIndex",0);
						idlingJSONObject.put("pmCountafterexpDataIndex",0);
						idlingJSONObject.put("PMStatusDataIndex","SERVICE PREDICTION");
						idlingJSONObject.put("vehicleTypeDateIndex",rs.getString("VehicleType"));
						idlingJSONArray.put(idlingJSONObject);
					}
					}
                    
		   }else if(reportType == 2){
			   HashMap<String, String[]> regionidleCountMap = new HashMap<String, String []>();
			   idlingJSONArray=new JSONArray();
			   idlingJSONObject=new JSONObject();
			   if(columnNum==1){
			   regionidleCountMap = getHashMapforIdlingTrend(pstmt,rs,con,day1q+" 00:00:00",day1q+" 23:59:59", offset,userId,systemId,Integer.parseInt(customerid),groupName,replaceString); 
			   idlingJSONArray = getJosonArray(groupName, regionidleCountMap,idlingJSONArray);
			   }if(columnNum==2){
			   regionidleCountMap = getHashMapforIdlingTrend(pstmt,rs,con,day2q+" 00:00:00",day2q+" 23:59:59", offset,userId,systemId,Integer.parseInt(customerid),groupName,replaceString); 
			   idlingJSONArray = getJosonArray(groupName, regionidleCountMap,idlingJSONArray);
			   }if(columnNum==3){
			   regionidleCountMap = getHashMapforIdlingTrend(pstmt,rs,con,day3q+" 00:00:00",day3q+" 23:59:59", offset,userId,systemId,Integer.parseInt(customerid),groupName,replaceString); 
			   idlingJSONArray = getJosonArray(groupName, regionidleCountMap,idlingJSONArray);
			   }
		   }else if(reportType == 4){
			   // only monthly
		   }else if(reportType == 6){
			  
			   
			   idlingJSONArray=new JSONArray();
			   if(columnNum==1){
			   idlingJSONArray = getHashMapforStatutoryTrend(pstmt,rs,con,day1q+" 00:00:00",day1q+" 23:59:59", offset,userId,systemId,Integer.parseInt(customerid),groupName,replaceString,statutoryType,idlingJSONArray); 
			   }if(columnNum==2){
			   idlingJSONArray = getHashMapforStatutoryTrend(pstmt,rs,con,day2q+" 00:00:00",day2q+" 23:59:59", offset,userId,systemId,Integer.parseInt(customerid),groupName,replaceString,statutoryType,idlingJSONArray); 
			   }if(columnNum==3){
			   idlingJSONArray = getHashMapforStatutoryTrendForecasting(pstmt,rs,con,day3q+" 00:00:00",day3q+" 23:59:59", offset,userId,systemId,Integer.parseInt(customerid),groupName,replaceString,statutoryType,idlingJSONArray); 
			   }
		   }
	}
		
		   else if(duration.equalsIgnoreCase("WEEKLY")){
			   
			   HashMap<String, Integer> regionAssetCountMap1 = new HashMap<String, Integer>();
				ArrayList<String[]> regionAssetCountMap2 = new ArrayList<String[]>();
				HashMap<String, Integer> p1 = new HashMap<String,  Integer>();
				ArrayList<ArrayList<String []>>  mapArrayOnclick = new ArrayList<ArrayList<String []>> ();
				ArrayList<String[]> regionAssetCountMap3 = new ArrayList<String[]>();
				HashMap<String, Integer> regionAssetCountAll = new HashMap<String,  Integer>();
				DateFormat dateFormatlocal = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
				DateFormat dateFormatq2 = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			   
			   String week1 = "";
			   String week2 = "";
			   String week3 = "";
			   String week0 = "";
			   String week1stdt = "";
			   String week1endt = "";
			   String week2stdt = "";
			   String week2endt = "";
			   String week3stdt = "";
			   String week3endt = "";
			   
			   if(reportType == 5 || reportType == 6){
			   
			    Calendar cal = Calendar.getInstance();
			    cal.setTime(selectedDate);
			   
			    int daysBackToSat = cal.get(Calendar.DAY_OF_WEEK );
			    cal.add(Calendar.DATE, daysBackToSat*-1);
			    Date date = cal.getTime();
			    week3 = dateFormat.format(date);
			    
			    Calendar caltoshowWeek1 = Calendar.getInstance();
			    caltoshowWeek1.setTime(date);
			    caltoshowWeek1.add(Calendar.DATE, 1);
			    date = caltoshowWeek1.getTime();
			    String week1toshw = dateFormat.format(date);
			    
			    daysBackToSat = cal.get(Calendar.DAY_OF_WEEK );
			    cal.add(Calendar.DATE, daysBackToSat*-1);
			    date = cal.getTime();
			    week2 = dateFormat.format(date);
			    				    
			    Calendar caltoshowWeek2 = Calendar.getInstance();
			    caltoshowWeek2.setTime(date);
			    caltoshowWeek2.add(Calendar.DATE, 1);
			    date = caltoshowWeek2.getTime();
			    String week1t2shw = dateFormat.format(date);
			    
			    Calendar cal2 = Calendar.getInstance();
			    cal2.setTime(selectedDate);
			    
			    daysBackToSat = cal2.get(Calendar.DAY_OF_WEEK );
			    daysBackToSat = 7-daysBackToSat;
			    cal2.add(Calendar.DATE, daysBackToSat);
			    date = cal2.getTime();
			    week1 = dateFormat.format(date);

			    Calendar cal4 = Calendar.getInstance();
			    cal2.setTime(selectedDate);
			    
			    daysBackToSat = cal4.get(Calendar.DAY_OF_WEEK );
			    daysBackToSat = 7-daysBackToSat;
			    cal4.add(Calendar.DATE, daysBackToSat);
			    date = cal4.getTime();
			    
			    Calendar caltoshowWeek0 = Calendar.getInstance();
			    caltoshowWeek0.setTime(date);
			    caltoshowWeek0.add(Calendar.DATE, 1);
			    date = caltoshowWeek0.getTime();
			    
			    String week0toshw = dateFormat.format(date);
			    
			    cal2.setTime(date);
			    cal2.add(Calendar.DATE, 6);
			    date = cal2.getTime();
			    week0 = dateFormat.format(date);				  			    
			    								  
			    week3stdt = week1t2shw+" 00:00:00";
				week3endt = week3+" 23:59:59";				    
				
				week2stdt = week1toshw+" 00:00:00";
				week2endt = week1+" 23:59:59";		
			
				week1stdt =  week0toshw+" 00:00:00";
				week1endt =  week0+" 23:59:59";
			    
				week0toshw=week0toshw+" TO "+week0;	   				    
				week1toshw=week1toshw+" TO "+week1;
			    week1t2shw=week1t2shw+" TO "+week3;				 

			   }else if(reportType == 2 || reportType == 4){
				  
				   Calendar cal = Calendar.getInstance();
				    cal.setTime(selectedDate);
				   
				    int daysBackToSat = cal.get(Calendar.DAY_OF_WEEK );
				    cal.add(Calendar.DATE, daysBackToSat*-1);
				    Date date = cal.getTime();
				    week3 = dateFormat.format(date);
				    String week3New = dateFormatNew.format(date);
				    daysBackToSat = cal.get(Calendar.DAY_OF_WEEK );
				    cal.add(Calendar.DATE, daysBackToSat*-1);
				    date = cal.getTime();
				    week2 = dateFormat.format(date);
				    String 	week2New = 		dateFormatNew.format(date);	    
				    Calendar caltoshowWeek2 = Calendar.getInstance();
				    caltoshowWeek2.setTime(date);
				    caltoshowWeek2.add(Calendar.DATE, 1);
				    date = caltoshowWeek2.getTime();
				    String week1t2shw = dateFormatNew.format(date);
				    week1t2shw=week1t2shw+" TO "+week3New;
				    
				    daysBackToSat = cal.get(Calendar.DAY_OF_WEEK );
				    cal.add(Calendar.DATE, daysBackToSat*-1);
				    date = cal.getTime();
				    week1 = dateFormat.format(date);
				    String week1New = dateFormatNew.format(date);
				    Calendar caltoshowWeek1 = Calendar.getInstance();
				    caltoshowWeek1.setTime(date);
				    caltoshowWeek1.add(Calendar.DATE, 1);
				    date = caltoshowWeek1.getTime();
				    String week1toshw = dateFormatNew.format(date);
				    week1toshw=week1toshw+" TO "+week2New;
				    
				    daysBackToSat = cal.get(Calendar.DAY_OF_WEEK );
				    cal.add(Calendar.DATE, daysBackToSat*-1);
				    date = cal.getTime();
				    week0 = dateFormat.format(date);
				    
				    Calendar caltoshowWeek0 = Calendar.getInstance();
				    caltoshowWeek0.setTime(date);
				    caltoshowWeek0.add(Calendar.DATE, 1);
				    date = caltoshowWeek0.getTime();
				    String week0toshw = dateFormatNew.format(date);
				    week0toshw=week0toshw+" TO "+week1New;
				  	
				    week1stdt = week0+" 00:00:00";
					week1endt = week1+" 23:59:59";				    
					week2stdt = week1+" 23:59:59";
					week2endt = week2+" 23:59:59";					
					week3stdt =  week2+" 23:59:59";
					week3endt =  week3+" 23:59:59";
				   
				   
			   }
//				 if(vehicleType.contains("CAR")){
//					 replaceString = " and vt.VehicleType = 'CAR' ";
//				 }else if (vehicleType.contains("TRUCK")) {
//					 replaceString = " and vt.VehicleType = 'TRUCK' "; 
//				 }
			
				 if(reportType == 5){
					 if(columnNum==1){ 
					pstmt = con.prepareStatement(FleetMaintanceStatements.GET_PM_COMPLETED_PREVIOUS_DURATION_ONCLICK.replace("#", replaceString));
					pstmt.setInt(1, offset);
					pstmt.setInt(2, systemId);
					pstmt.setInt(3, Integer.parseInt(customerid));
					pstmt.setInt(4, userId);
					pstmt.setString(5, groupName);
					pstmt.setInt(6, -offset);
					pstmt.setString(7, dateFormatq2.format( dateFormatlocal.parse(week3stdt)));
					pstmt.setInt(8, -offset);
					pstmt.setString(9, dateFormatq2.format( dateFormatlocal.parse(week3endt)));	
					rs = pstmt.executeQuery();						
					while(rs.next()) {
						
						idlingJSONObject=new JSONObject();
						idlingJSONObject.put("vehicleNoDateIndex",rs.getString("ASSET_NUMBER"));
						idlingJSONObject.put("groupNameDataIndex",rs.getString("GROUP_NAME"));
						idlingJSONObject.put("idlinghrsDataIndex",0);
						idlingJSONObject.put("enginehrsDataIndex",0);
						idlingJSONObject.put("startDateDataIndex",dateFormatNew.format(dateFormat2.parse(rs.getString("LAST_SERVICE_DATE"))));
						idlingJSONObject.put("endDateDataIndex","");
						idlingJSONObject.put("idlingCountDataIndex",0);
						idlingJSONObject.put("pmCountDataIndex",0);
						idlingJSONObject.put("pmCountbeforeexpDataIndex",0);
						idlingJSONObject.put("pmCountafterexpDataIndex",0);
						idlingJSONObject.put("PMStatusDataIndex","SERVICE COMPLETED");
						idlingJSONObject.put("vehicleTypeDateIndex",rs.getString("VehicleType"));						
						idlingJSONArray.put(idlingJSONObject);
					}
				 }
					String dbformatWeek2Stdate = dateFormatq.format(dateFormat.parse(week2stdt));
					String dbformatWeek2Enddate = dateFormatq.format(dateFormat.parse(week2endt));
					String dbformatWeek3Stdate = dateFormatq.format(dateFormat.parse(week1stdt));
					String dbformatWeek3Enddate = dateFormatq.format(dateFormat.parse(week1endt));
						
					mapArrayOnclick = getp2newOnClick(con,dbformatWeek2Stdate+" 00:00:00",dbformatWeek2Enddate+" 23:59:59",offset,systemId,Integer.parseInt(customerid),replaceString,dbformatWeek3Stdate+" 00:00:00",dbformatWeek3Enddate+" 23:59:59",userId,groupName,startDate);
                    if(mapArrayOnclick.size()>0){
                    for(int i=0;i<2;i++){
                    if(i==0){
                    regionAssetCountMap2=	mapArrayOnclick.get(0);
                    }else{
	                regionAssetCountMap3=	mapArrayOnclick.get(1);
                    }
                    }
		           }
                    if(columnNum==2){
                    for(int i=0;i<regionAssetCountMap2.size();i++){
                    String vehDetailsArr1[] = regionAssetCountMap2.get(i);
                    idlingJSONObject=new JSONObject();
					idlingJSONObject.put("vehicleNoDateIndex",vehDetailsArr1[0]);
					idlingJSONObject.put("groupNameDataIndex",vehDetailsArr1[1]);
					idlingJSONObject.put("idlinghrsDataIndex",0);
					idlingJSONObject.put("enginehrsDataIndex",0);
					idlingJSONObject.put("startDateDataIndex",vehDetailsArr1[2]);
					idlingJSONObject.put("endDateDataIndex","");
					idlingJSONObject.put("idlingCountDataIndex",0);
					idlingJSONObject.put("pmCountDataIndex",0);
					idlingJSONObject.put("pmCountbeforeexpDataIndex",0);
					idlingJSONObject.put("pmCountafterexpDataIndex",0);
					idlingJSONObject.put("PMStatusDataIndex","SERVICE PENDING");
					idlingJSONObject.put("vehicleTypeDateIndex",vehDetailsArr1[3]);
					idlingJSONArray.put(idlingJSONObject);
                    }
                    }if(columnNum==3){
                    for(int i=0;i<regionAssetCountMap3.size();i++){
                        String vehDetailsArr2[] = regionAssetCountMap3.get(i);
                        idlingJSONObject=new JSONObject();
    					idlingJSONObject.put("vehicleNoDateIndex",vehDetailsArr2[0]);
    					idlingJSONObject.put("groupNameDataIndex",vehDetailsArr2[1]);
    					idlingJSONObject.put("idlinghrsDataIndex",0);
    					idlingJSONObject.put("enginehrsDataIndex",0);
    					idlingJSONObject.put("startDateDataIndex",vehDetailsArr2[2]);
    					idlingJSONObject.put("endDateDataIndex","");
    					idlingJSONObject.put("idlingCountDataIndex",0);
    					idlingJSONObject.put("pmCountDataIndex",0);
    					idlingJSONObject.put("pmCountbeforeexpDataIndex",0);
    					idlingJSONObject.put("pmCountafterexpDataIndex",0);
    					idlingJSONObject.put("PMStatusDataIndex","SERVICE PREDICTION");
    					idlingJSONObject.put("vehicleTypeDateIndex",vehDetailsArr2[3]);
    					idlingJSONArray.put(idlingJSONObject);
                        }	
                    }
				 }  else if(reportType == 2){
						
					   HashMap<String, String[]> regionidleCountMap = new HashMap<String, String []>();
					   if(columnNum==1){
					   regionidleCountMap = getHashMapforIdlingTrend(pstmt,rs,con,dateFormatq2.format(dateFormatlocal.parse(week3stdt)),dateFormatq2.format(dateFormatlocal.parse(week3endt)), offset,userId,systemId,Integer.parseInt(customerid),groupName,replaceString); 
					   idlingJSONArray = getJosonArray(groupName , regionidleCountMap,idlingJSONArray);
					   }if(columnNum==2){
					   regionidleCountMap = getHashMapforIdlingTrend(pstmt,rs,con,dateFormatq2.format(dateFormatlocal.parse(week2stdt)),dateFormatq2.format(dateFormatlocal.parse(week2endt)), offset,userId,systemId,Integer.parseInt(customerid),groupName,replaceString); 
					   idlingJSONArray = getJosonArray(groupName , regionidleCountMap,idlingJSONArray);
					   }if(columnNum==3){
					   regionidleCountMap = getHashMapforIdlingTrend(pstmt,rs,con,dateFormatq2.format(dateFormatlocal.parse(week1stdt)),dateFormatq2.format(dateFormatlocal.parse(week1endt)), offset,userId,systemId,Integer.parseInt(customerid),groupName,replaceString); 
					   idlingJSONArray = getJosonArray(groupName , regionidleCountMap,idlingJSONArray);
					   }
				   }else if(reportType == 4){
					   
				   }else if(reportType == 6){
					  
					   idlingJSONArray=new JSONArray();
					   if(columnNum==1){
					   idlingJSONArray = getHashMapforStatutoryTrend(pstmt,rs,con,dateFormatq2.format(dateFormatlocal.parse(week3stdt)),dateFormatq2.format(dateFormatlocal.parse(week3endt)), offset,userId,systemId,Integer.parseInt(customerid),groupName,replaceString,statutoryType,idlingJSONArray); 
					   }if(columnNum==2){
					   idlingJSONArray = getHashMapforStatutoryTrendForecasting(pstmt,rs,con,dateFormatq2.format(dateFormatlocal.parse(week2stdt)),dateFormatq2.format(dateFormatlocal.parse(week2endt)), offset,userId,systemId,Integer.parseInt(customerid),groupName,replaceString,statutoryType,idlingJSONArray); 
					   }if(columnNum==3){
					   idlingJSONArray = getHashMapforStatutoryTrendForecasting(pstmt,rs,con,dateFormatq2.format(dateFormatlocal.parse(week1stdt)),dateFormatq2.format(dateFormatlocal.parse(week1endt)), offset,userId,systemId,Integer.parseInt(customerid),groupName,replaceString,statutoryType,idlingJSONArray); 
					   }
					   }   												
				
									
		   }
		   else if(duration.equalsIgnoreCase("MONTHLY")){
			   
			   HashMap<String, Integer> regionAssetCountMap1 = new HashMap<String, Integer>();
				ArrayList<String[]> regionAssetCountMap2 = new ArrayList<String[]>();
				HashMap<String, Integer> p1 = new HashMap<String,  Integer>();
				ArrayList<ArrayList<String []>>  mapArrayOnclick = new ArrayList<ArrayList<String []>> ();
				ArrayList<String[]> regionAssetCountMap3 = new ArrayList<String[]>();
				HashMap<String, Integer> regionAssetCountAll = new HashMap<String,  Integer>();
				DateFormat dateFormatlocal = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
				DateFormat dateFormatq2 = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			   
			   String month1 = "";
			   String month2 = "";
			   String month3 = "";
			   
			   String month1stdt = "";
			   String month1endt = "";
			   String month2stdt = "";
			   String month2endt = "";
			   String month3stdt = "";
			   String month3endt = "";
			   
			   if( reportType == 5 || reportType == 6 ){
			    Calendar cal = Calendar.getInstance();
			    cal.setTime(selectedDate);
			    
			    cal.add(Calendar.MONTH, -1);
			    Date date = cal.getTime();
			    month1 = monthFormat.format(date);
			    
			    cal.setTime(selectedDate);
			    cal.add(Calendar.MONTH, 0);
			    date = cal.getTime();
			    month2 = monthFormat.format(date);
			   
			    cal.setTime(selectedDate);
			    cal.add(Calendar.MONTH, 1);
			    date = cal.getTime();
			    month3 = monthFormat.format(date);

				 Calendar cala = Calendar.getInstance();
				 cala.setTime(selectedDate);
				
				 cala.add(Calendar.MONTH, -1);					 
				 cala.set(Calendar.DAY_OF_MONTH,cala.getActualMaximum(Calendar.DAY_OF_MONTH));
				 setTimeToEndofDay(cala);
			     Date end = cala.getTime();
			     month1endt = dateFormatq.format(end);
			     
			     cala.setTime(selectedDate);
			     cala.add(Calendar.MONTH, 0);					 
				 cala.set(Calendar.DAY_OF_MONTH,cala.getActualMaximum(Calendar.DAY_OF_MONTH));
				 setTimeToEndofDay(cala);
			     end = cala.getTime();
			     month2endt = dateFormatq.format(end);
			     
			     cala.setTime(selectedDate);
			     cala.add(Calendar.MONTH, +1);					 
				 cala.set(Calendar.DAY_OF_MONTH,cala.getActualMaximum(Calendar.DAY_OF_MONTH));
				 setTimeToEndofDay(cala);
			     end = cala.getTime();
			     month3endt = dateFormatq.format(end);
			     
			     
			     Calendar cala2 = Calendar.getInstance();
				 cala2.setTime(selectedDate);
				 
				 cala2.add(Calendar.MONTH, -1);					 
				 cala2.set(Calendar.DAY_OF_MONTH,cala2.getActualMinimum(Calendar.DAY_OF_MONTH));
				 setTimeToBeginningOfDay(cala2);
			     Date start = cala2.getTime();
			     month1stdt = dateFormatq.format(start);
			      
			     cala2.setTime(selectedDate);
			     cala2.add(Calendar.MONTH, 0);					 
				 cala2.set(Calendar.DAY_OF_MONTH,cala2.getActualMinimum(Calendar.DAY_OF_MONTH));
				 setTimeToBeginningOfDay(cala2);
			     start = cala2.getTime();
			     month2stdt = dateFormatq.format(start);
			     
			     cala2.setTime(selectedDate);
			     cala2.add(Calendar.MONTH, +1);					 
				 cala2.set(Calendar.DAY_OF_MONTH,cala2.getActualMinimum(Calendar.DAY_OF_MONTH));
				 setTimeToBeginningOfDay(cala2);
			     start = cala2.getTime();
			     month3stdt = dateFormatq.format(start);
			   } else if( reportType == 2 || reportType == 4){
				   
				   Calendar cal = Calendar.getInstance();
				    cal.setTime(selectedDate);
				   
					 Calendar cala = Calendar.getInstance();
					 cala.setTime(selectedDate);
					
					 cala.add(Calendar.MONTH, -1);					 
					 cala.set(Calendar.DAY_OF_MONTH,cala.getActualMaximum(Calendar.DAY_OF_MONTH));
					 setTimeToEndofDay(cala);
				     Date end = cala.getTime();
				     month1endt = dateFormatq.format(end);
				     
				     cala.add(Calendar.MONTH, -1);					 
					 cala.set(Calendar.DAY_OF_MONTH,cala.getActualMaximum(Calendar.DAY_OF_MONTH));
					 setTimeToEndofDay(cala);
				     end = cala.getTime();
				     month2endt = dateFormatq.format(end);
				     
				     cala.add(Calendar.MONTH, -1);					 
					 cala.set(Calendar.DAY_OF_MONTH,cala.getActualMaximum(Calendar.DAY_OF_MONTH));
					 setTimeToEndofDay(cala);
				     end = cala.getTime();
				     month3endt = dateFormatq.format(end);
				     
				     
				     Calendar cala2 = Calendar.getInstance();
					 cala2.setTime(selectedDate);
					 
					 cala2.add(Calendar.MONTH, -1);					 
					 cala2.set(Calendar.DAY_OF_MONTH,cala2.getActualMinimum(Calendar.DAY_OF_MONTH));
					 setTimeToBeginningOfDay(cala2);
				     Date start = cala2.getTime();
				     month1stdt = dateFormatq.format(start);
				        
				     cala2.add(Calendar.MONTH, -1);					 
					 cala2.set(Calendar.DAY_OF_MONTH,cala2.getActualMinimum(Calendar.DAY_OF_MONTH));
					 setTimeToBeginningOfDay(cala2);
				     start = cala2.getTime();
				     month2stdt = dateFormatq.format(start);
				     
				     cala2.add(Calendar.MONTH, -1);					 
					 cala2.set(Calendar.DAY_OF_MONTH,cala2.getActualMinimum(Calendar.DAY_OF_MONTH));
					 setTimeToBeginningOfDay(cala2);
				     start = cala2.getTime();
				     month3stdt = dateFormatq.format(start);   
				   
			   }
				
				 if(reportType ==5){
					 if(columnNum==1){ 
				 pstmt = con.prepareStatement(FleetMaintanceStatements.GET_PM_COMPLETED_PREVIOUS_DURATION_ONCLICK.replace("#", replaceString));
				 pstmt.setInt(1, offset);	
					pstmt.setInt(2, systemId);
					pstmt.setInt(3, Integer.parseInt(customerid));
					pstmt.setInt(4, userId);
					pstmt.setString(5, groupName);
					pstmt.setInt(6, -offset);
					pstmt.setString(7, month1stdt+" 00:00:00");
					pstmt.setInt(8, -offset);
					pstmt.setString(9, month1endt+" 23:59:59");
					rs = pstmt.executeQuery();						
					while(rs.next()) {
						
						idlingJSONObject=new JSONObject();
						idlingJSONObject.put("vehicleNoDateIndex",rs.getString("ASSET_NUMBER"));
						idlingJSONObject.put("groupNameDataIndex",rs.getString("GROUP_NAME"));
						idlingJSONObject.put("idlinghrsDataIndex",0);
						idlingJSONObject.put("enginehrsDataIndex",0);
						idlingJSONObject.put("startDateDataIndex",dateFormatNew.format(dateFormat2.parse(rs.getString("LAST_SERVICE_DATE"))));
						idlingJSONObject.put("endDateDataIndex","");
						idlingJSONObject.put("idlingCountDataIndex",0);
						idlingJSONObject.put("pmCountDataIndex",0);
						idlingJSONObject.put("pmCountbeforeexpDataIndex",0);
						idlingJSONObject.put("pmCountafterexpDataIndex",0);
						idlingJSONObject.put("PMStatusDataIndex","SERVICE COMPLETED");
						idlingJSONObject.put("vehicleTypeDateIndex",rs.getString("VehicleType"));
						idlingJSONArray.put(idlingJSONObject);
					}
				 }
					mapArrayOnclick = getp2newOnClick(con,month2stdt+" 00:00:00",month2endt+" 23:59:59",offset,systemId,Integer.parseInt(customerid),replaceString,month3stdt+" 00:00:00",month3endt+" 00:00:00", userId,groupName,startDate);
                 if(mapArrayOnclick.size()>0){
                 for(int i=0;i<2;i++){
                 if(i==0){
                 regionAssetCountMap2=	mapArrayOnclick.get(0);
                 }else{
	                regionAssetCountMap3=	mapArrayOnclick.get(1);
                 }
                 }
		           }
                 if(columnNum==2){
                 for(int i=0;i<regionAssetCountMap2.size();i++){
                 String vehDetailsArr1[] = regionAssetCountMap2.get(i);
                 idlingJSONObject=new JSONObject();
					idlingJSONObject.put("vehicleNoDateIndex",vehDetailsArr1[0]);
					idlingJSONObject.put("groupNameDataIndex",vehDetailsArr1[1]);
					idlingJSONObject.put("idlinghrsDataIndex",0);
					idlingJSONObject.put("enginehrsDataIndex",0);
					idlingJSONObject.put("startDateDataIndex",vehDetailsArr1[2]);
					idlingJSONObject.put("endDateDataIndex","");
					idlingJSONObject.put("idlingCountDataIndex",0);
					idlingJSONObject.put("pmCountDataIndex",0);
					idlingJSONObject.put("pmCountbeforeexpDataIndex",0);
					idlingJSONObject.put("pmCountafterexpDataIndex",0);
					idlingJSONObject.put("PMStatusDataIndex","SERVICE PENDING");
					idlingJSONObject.put("vehicleTypeDateIndex",vehDetailsArr1[3]);
					idlingJSONArray.put(idlingJSONObject);
                 }
                 }if(columnNum==3){
                 for(int i=0;i<regionAssetCountMap3.size();i++){
                     String vehDetailsArr2[] = regionAssetCountMap3.get(i);
                     idlingJSONObject=new JSONObject();
 					idlingJSONObject.put("vehicleNoDateIndex",vehDetailsArr2[0]);
 					idlingJSONObject.put("groupNameDataIndex",vehDetailsArr2[1]);
 					idlingJSONObject.put("idlinghrsDataIndex",0);
 					idlingJSONObject.put("enginehrsDataIndex",0);
 					idlingJSONObject.put("startDateDataIndex",vehDetailsArr2[2]);
 					idlingJSONObject.put("endDateDataIndex","");
 					idlingJSONObject.put("idlingCountDataIndex",0);
 					idlingJSONObject.put("pmCountDataIndex",0);
 					idlingJSONObject.put("pmCountbeforeexpDataIndex",0);
 					idlingJSONObject.put("pmCountafterexpDataIndex",0);
 					idlingJSONObject.put("PMStatusDataIndex","SERVICE PREDICTION");
 					idlingJSONObject.put("vehicleTypeDateIndex",vehDetailsArr2[3]);
 					idlingJSONArray.put(idlingJSONObject);
                     }
                 }
				 }else if(reportType == 2){
					 
	                 idlingJSONArray = new JSONArray();
					
	                 HashMap<String, String[]> regionidleCountMap = new HashMap<String, String []>();
	                 if(columnNum==1){
	                 regionidleCountMap = getHashMapforIdlingTrend(pstmt,rs,con,month1stdt+" 00:00:00",month1endt+" 23:59:59", offset,userId,systemId,Integer.parseInt(customerid),groupName,replaceString); 
					 idlingJSONArray = getJosonArray(groupName, regionidleCountMap,idlingJSONArray);
	                 }if(columnNum==2){
					 regionidleCountMap = getHashMapforIdlingTrend(pstmt,rs,con,month2stdt+" 00:00:00",month2endt+" 23:59:59", offset,userId,systemId,Integer.parseInt(customerid),groupName,replaceString); 
					 idlingJSONArray = getJosonArray(groupName, regionidleCountMap,idlingJSONArray);
	                 }if(columnNum==3){
					 regionidleCountMap = getHashMapforIdlingTrend(pstmt,rs,con,month3stdt+" 00:00:00",month3endt+" 23:59:59", offset,userId,systemId,Integer.parseInt(customerid),groupName,replaceString); 
					 idlingJSONArray = getJosonArray(groupName, regionidleCountMap,idlingJSONArray);
	                 }
				   }else if(reportType == 4){
					   if(columnNum==3){
					   idlingJSONArray = getHashMapforFuelEfficiencyTrend(pstmt,rs,con,month1stdt+" 00:00:00",month1endt+" 23:59:59", offset,userId,systemId,Integer.parseInt(customerid),groupName,replaceString,idlingJSONArray); 
					   }if(columnNum==2){
					   idlingJSONArray = getHashMapforFuelEfficiencyTrend(pstmt,rs,con,month2stdt+" 00:00:00",month2endt+" 23:59:59", offset,userId,systemId,Integer.parseInt(customerid),groupName,replaceString,idlingJSONArray); 
					   }if(columnNum==1){
					   idlingJSONArray = getHashMapforFuelEfficiencyTrend(pstmt,rs,con,month3stdt+" 00:00:00",month3endt+" 23:59:59", offset,userId,systemId,Integer.parseInt(customerid),groupName,replaceString,idlingJSONArray); 
					   }
				   }else if(reportType == 6){
					   idlingJSONArray=new JSONArray();
					   if(columnNum==1){
					   idlingJSONArray = getHashMapforStatutoryTrend(pstmt,rs,con,month1stdt+" 00:00:00",month1endt+" 23:59:59", offset,userId,systemId,Integer.parseInt(customerid),groupName,replaceString,statutoryType,idlingJSONArray); 
					   }if(columnNum==2){
					   idlingJSONArray = getHashMapforStatutoryTrendForecasting(pstmt,rs,con,month2stdt+" 00:00:00",month2endt+" 23:59:59", offset,userId,systemId,Integer.parseInt(customerid),groupName,replaceString,statutoryType,idlingJSONArray); 
					   }if(columnNum==3){
					   idlingJSONArray = getHashMapforStatutoryTrendForecasting(pstmt,rs,con,month3stdt+" 00:00:00",month3endt+" 23:59:59", offset,userId,systemId,Integer.parseInt(customerid),groupName,replaceString,statutoryType,idlingJSONArray); 
					   }
 
				   }  
		   }
				 

	} catch (Exception e) {
		e.printStackTrace();
	} 
}

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}

		return idlingJSONArray;
	
	
	}
	
	public JSONArray getManagerDetails(int SystemId,int CustomerId){
		
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		JSONArray mgrJSONArray=new JSONArray();
		JSONObject mgrJsonObject;
	
		try {
			con = DBConnection.getDashboardConnection("AMS");
			
				pstmt = con.prepareStatement(FleetMaintanceStatements.GET_MANAGER_DETAILS);
				pstmt.setInt(1, SystemId);
				pstmt.setInt(2, CustomerId);
				
			rs = pstmt.executeQuery();
			
			while(rs.next()) {					
						mgrJsonObject=new JSONObject();
						mgrJsonObject.put("ManagerId", rs.getInt("ManagerId"));
						mgrJsonObject.put("ManagerName", rs.getString("ManagerName"));
						mgrJSONArray.put(mgrJsonObject);
					}
			} 
		catch (Exception e) 
		{
			e.printStackTrace();
		} 
		finally 
		{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return mgrJSONArray;
	}
	
	public ArrayList<Object> getFMSJobCardSettingsDetails(int SystemId,int CustomerId)
	{
		JSONArray JsonArray = new JSONArray();
		JSONObject JsonObject = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int slcount = 0;
		ReportHelper finalreporthelper = new ReportHelper();
		ArrayList < Object > finlist = new ArrayList < Object > ();
		ArrayList<ReportHelper> reportsList = new ArrayList<ReportHelper>();
		ArrayList<String> headersList = new ArrayList<String>();
		
		headersList.add("SLNO");
		headersList.add("ID");
		headersList.add("Customer Name");
		headersList.add("External Max Jobcard Cost");
		headersList.add("External Jobcard Sub Task");
		headersList.add("Manager Name");
		headersList.add("Manager Email");
		headersList.add("Manager Phone");
		headersList.add("Manager Id");
		
		try {
			con = DBConnection.getDashboardConnection("AMS");
				pstmt = con.prepareStatement(FleetMaintanceStatements.GET_JOBCARD_SETTINGS_DETAILS);
				pstmt.setInt(1, SystemId);
				pstmt.setInt(2, CustomerId);
				
			    rs = pstmt.executeQuery();
			
				while(rs.next()) {
					ArrayList<Object> informationList = new ArrayList<Object>();
					ReportHelper reporthelper = new ReportHelper();
					JsonObject = new JSONObject();
					slcount++;
					JsonObject.put("slnoIndex", slcount);
					informationList.add(slcount);
					
					JsonObject.put("uniqueIdDataIndex", rs.getInt("ID"));
					informationList.add(rs.getInt("ID"));
					
					JsonObject.put("customerNameIndex", rs.getString("CUSTOMER_NAME"));
					informationList.add(rs.getString("CUSTOMER_NAME"));
					
					JsonObject.put("extMaxJCcostIndex", rs.getDouble("EXT_JC_MAX_COST"));
					informationList.add(rs.getDouble("EXT_JC_MAX_COST"));
					
					String Yes_No=null;
					if(rs.getString("EXT_JC_SUB_TASK").equals("1")){
						Yes_No="YES";
					}
					else{
						Yes_No="NO";
					}
					
					JsonObject.put("extJCardSubTaskIndex", Yes_No);
					informationList.add(Yes_No);
					
					JsonObject.put("ManagerNameIndex", rs.getString("MANAGER_NAME"));
					informationList.add(rs.getString("MANAGER_NAME"));

					JsonObject.put("ManagerEmailIdnex", rs.getString("MANAGER_EMAIL"));
					informationList.add(rs.getString("MANAGER_EMAIL"));
					
					JsonObject.put("ManagerPhoneNoIndex", rs.getString("MANAGER_PHONE"));
					informationList.add(rs.getString("MANAGER_PHONE"));
					
					JsonObject.put("ManagerIDIndex", rs.getInt("MANAGER_ID"));
					informationList.add(rs.getInt("MANAGER_ID"));
					
					JsonArray.put(JsonObject);
					reporthelper.setInformationList(informationList);
				    reportsList.add(reporthelper);
				}
				finlist.add(JsonArray);
				finalreporthelper.setReportsList(reportsList);
				finalreporthelper.setHeadersList(headersList);
				finlist.add(finalreporthelper);
				
			} 
		catch (Exception e) 
		{
			e.printStackTrace();
		} 
		finally 
		{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		
		return finlist;
	}
	
	public String addFMSJobCardSettingsDetails(int SystemId,int CustomerId,double ExtJCMaxCost,String ExtJCSubtaskYesNo,String ManagerId){

		Connection con = null;
		PreparedStatement pstmt= null;
		ResultSet rs=null;
		String message="";
		boolean bitValue=false;
		if(ExtJCSubtaskYesNo.equals("YES"))
		{
			bitValue=true;
		}
		
		
		try
		{
			 con = DBConnection.getConnectionToDB("AMS");
			 pstmt= con.prepareStatement(FleetMaintanceStatements.CHECK_FMS_JC_SETTINGS_AVAILABILITY);
			 pstmt.setInt(1, SystemId);
			 pstmt.setInt(2, CustomerId);
			 rs = pstmt.executeQuery();
			 if (rs.next()) {
					return "Job Settings for this Customer Already Exists";
		     }
			 
			 pstmt = con.prepareStatement(FleetMaintanceStatements.INSERT_FMS_JC_SETTINGS);
			 pstmt.setInt(1, SystemId);
			 pstmt.setInt(2, CustomerId);
			 pstmt.setDouble(3, ExtJCMaxCost);
			 pstmt.setBoolean(4, bitValue);
			 pstmt.setString(5, ManagerId);
			 
			 int inserted = pstmt.executeUpdate();
			 if (inserted > 0) {
                  message = "Saved Successfully";
             }
		}
		catch (Exception e)
		{
				e.printStackTrace();
		}      
		finally {
			DBConnection.releaseConnectionToDB(con,pstmt, rs);
	    }
		return message;
	}
	
	
	public String modifyFMSJobCardSettingsDetails(double ExtJCMaxCost,String ExtJCSubtaskYesNo,String ManagerId,int id){

		Connection con = null;
		PreparedStatement pstmt= null;
		ResultSet rs=null;
		String message="";
		
		boolean bitValue=false;
		if(ExtJCSubtaskYesNo.equals("YES"))
		{
			bitValue=true;
		}
		try{
			 con = DBConnection.getConnectionToDB("AMS");
			 pstmt=con.prepareStatement(FleetMaintanceStatements.UPDATE_FMS_JC_SETTINGS);
				pstmt.setDouble(1,ExtJCMaxCost);
				pstmt.setBoolean(2,bitValue);
				pstmt.setString(3,ManagerId);
				pstmt.setInt(4,id);
				int updated=pstmt.executeUpdate();
				if(updated>0){
					message = "Updated Successfully";
				}
		}
		catch (Exception e)
		 {
				e.printStackTrace();
		 }      
		finally {
			DBConnection.releaseConnectionToDB(con,pstmt,rs);
	    }
		return message;
	}
	
	
	private static void setTimeToBeginningOfDay(Calendar calendar) {
	    calendar.set(Calendar.HOUR_OF_DAY, 0);
	    calendar.set(Calendar.MINUTE, 0);
	    calendar.set(Calendar.SECOND, 0);
	   
	}

	private static void setTimeToEndofDay(Calendar calendar) {
	    calendar.set(Calendar.HOUR_OF_DAY, 23);
	    calendar.set(Calendar.MINUTE, 59);
	    calendar.set(Calendar.SECOND, 59);
	    
	}
	
	public String getHHMMTimeFormat(double durationHrs) {
		String durationHrsStr = "0.0";
		if (durationHrs > 0.0) {
			int hrs = (int) durationHrs;
			int min = (int) ((durationHrs - hrs) * 60);

			if (min < 10) {
				durationHrsStr = String.valueOf(hrs) + ".0"
						+ String.valueOf(min);
			} else {
				durationHrsStr = String.valueOf(hrs) + "."
						+ String.valueOf(min);
			}
		}
		return durationHrsStr;
	}
	
	private ArrayList<HashMap<String, Integer>>  getp2new(Connection con,String time1,String time2,int offset,int systemId,int customerid,String replaceString,String futureTime1,String futureTime2, int userId,String datefromjsp){
		HashMap<String, String[]> vehicleAndTotalDistanceCount = new HashMap<String, String[]>();
		HashMap<String, Double> MonthlyAvgDistanceOfVehicle = new HashMap<String, Double>();
		HashMap<String, int[]> vehicleAndThreshouldDistanceAndDaysCount = new HashMap<String, int[]>();
		ArrayList<HashMap<String, Integer>> pendingAndForecastMapRegionWise = new ArrayList<HashMap<String, Integer>>();
		DateFormat dateFormatq = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		datefromjsp = datefromjsp+" 00:00:00";
		HashMap<String, Integer> forecast = new HashMap<String, Integer>();
		HashMap<String, Integer> pending = new HashMap<String, Integer>();
		Calendar cal = Calendar.getInstance();

		Date dt = null;
		Date min1 = null;
		Date max1 = null;
		Date min2 = null;
		Date max2 = null;
    
		try{
			
			Calendar mycal = null;
			mycal = Calendar.getInstance();
			mycal.setTime(dateFormatq.parse(time1));
			mycal.add(Calendar.MONTH, -1);
		    dt = mycal.getTime();	    
		    String time2start = dateFormatq.format(dt);
		    mycal = Calendar.getInstance();
		    mycal.setTime(dateFormatq.parse(time1));
		    mycal.add(Calendar.MONTH, -1);
		    int daysInMonth = mycal.getActualMaximum(Calendar.DAY_OF_MONTH);
		    mycal.add(Calendar.DATE, daysInMonth);
		    dt = mycal.getTime();	    
		    String time2end = dateFormatq.format(dt);
			
			cal = Calendar.getInstance();
		    cal.setTime(dateFormatq.parse(time1));			    
		    min1 = cal.getTime();	    
		  //  String mins1 = dateFormat.format(min1);
		    cal = Calendar.getInstance();
		    cal.setTime(dateFormatq.parse(time2));			    
		    max1 = cal.getTime();	    
		 //   String maxs1 = dateFormat.format(max1);
		    cal = Calendar.getInstance();
		    cal.setTime(dateFormatq.parse(futureTime1));			    
		    min2 = cal.getTime();	    
		 //   String mins2 = dateFormat.format(min2);
		    cal = Calendar.getInstance();
		    cal.setTime(dateFormatq.parse(futureTime2));			    
		    max2 = cal.getTime();	    
		   // String maxs2 = dateFormat.format(max2);
			
			HashMap<String,  ArrayList<String>> groupVehicleArrayList = new HashMap<String, ArrayList<String>>();
			 ArrayList<String> vehicleList = new ArrayList<String>();
			// getting group and respective vehicle each group	
			pstmt = con.prepareStatement(FleetMaintanceStatements.GET_VEHICLE_OF_EACH_GROUP.replace("#", replaceString));							
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, customerid);
			pstmt.setInt(3, userId);
           rs = pstmt.executeQuery();
           
           String group= "";
           String prevGroup = "";
           int count = 0;
		    while(rs.next()) {	
		    	count++;
		    	if(count == 1){
		    		vehicleList = new ArrayList<String>();
		    		group = rs.getString("GROUP_NAME");
		    		prevGroup = group;
		    		vehicleList.add(rs.getString("ASSET_NUMBER"));						    		
		    	}else{
		    		group = rs.getString("GROUP_NAME");
		    		if(prevGroup.equals(group)){
		    		vehicleList.add(rs.getString("ASSET_NUMBER"));	
		    		}else{
		    			groupVehicleArrayList.put(prevGroup, vehicleList);
		    			vehicleList = new ArrayList<String>();
			    		group = rs.getString("GROUP_NAME");
			    		prevGroup = group;
			    		vehicleList.add(rs.getString("ASSET_NUMBER"));	
		    		}
		    	}
		    									
		}					
		    groupVehicleArrayList.put(prevGroup, vehicleList);									
	
		pstmt = con.prepareStatement(FleetMaintanceStatements.get_tatal_distance_from_lastServiceDate_new.replace("#", replaceString));
		pstmt.setInt(1, systemId);
		pstmt.setInt(2, customerid);
		pstmt.setInt(3, -offset);
		pstmt.setString(4, time2);
		pstmt.setInt(5, systemId);
		pstmt.setInt(6, customerid);	
		pstmt.setInt(7, userId);
		rs = pstmt.executeQuery();						
		while(rs.next()) {
			String asset = rs.getString("ASSET_NUMBER");			
			String arr[] = {rs.getString("LAST_SERVICE_DATE"),dftwodigit.format(rs.getDouble("TOTAL_DISTANCE"))};
			vehicleAndTotalDistanceCount.put(asset, arr);
		}

		pstmt = con.prepareStatement(FleetMaintanceStatements.get_Monthly_avg_distance.replace("#", replaceString));
		pstmt.setInt(1, -offset);
		pstmt.setString(2, time2start);
		pstmt.setInt(3, -offset);
		pstmt.setString(4, time2end);
		pstmt.setInt(5, systemId);
		pstmt.setInt(6, customerid);	
		pstmt.setInt(7, userId);
		rs = pstmt.executeQuery();						
		while(rs.next()) {
			String asset = rs.getString("ASSET_NUMBER");			
			double avgdistance = Double.parseDouble(dftwodigit.format(rs.getDouble("TOTAL_DISTANCE")));
			MonthlyAvgDistanceOfVehicle.put(asset, avgdistance);
		}
		
		pstmt = con.prepareStatement(FleetMaintanceStatements.get_th_distance_and_th_days.replace("#", replaceString));
		pstmt.setInt(1, systemId);
		pstmt.setInt(2, customerid);
		pstmt.setInt(3, userId);											
		rs = pstmt.executeQuery();						
		while(rs.next()) {
			String asset = rs.getString("ASSET_NUMBER");				
			int arr[] = {rs.getInt("THRESHOULD_DISTANCE"),rs.getInt("THRESHOULD_DAYS")};
			vehicleAndThreshouldDistanceAndDaysCount.put(asset, arr);
		}
		
		Date thismonthEndTime = dateFormatq.parse(time2);
		cal = Calendar.getInstance();
	    cal.setTime(thismonthEndTime);		
	    thismonthEndTime =cal.getTime(); 
	    
	    Date nextmonthEndTime = dateFormatq.parse(futureTime2);
		cal = Calendar.getInstance();
	    cal.setTime(nextmonthEndTime);		
	    nextmonthEndTime =cal.getTime(); 
		
		for(Map.Entry<String, ArrayList<String>> entry: groupVehicleArrayList.entrySet()){
			int PendingVehCount = 0;
			int forecastVehCount = 0;
			group = entry.getKey();
			ArrayList<String> vehlist = entry.getValue();
			int vehcount = 0;
			if(vehlist.size()>0){
			for(int i=0; i<vehlist.size();i++){
				String vehno = vehlist.get(i);
				double totdistance = 0;
				double monthlyAvgDistance = 0;
				int thdistance = 0;
				int thdays = 0;				 
			    String lastServiceDate = "";
				
			    if(vehicleAndThreshouldDistanceAndDaysCount.containsKey(vehno)){
					int thdistAndDays[] = vehicleAndThreshouldDistanceAndDaysCount.get(vehno);
					thdistance =thdistAndDays[0];
					thdays = thdistAndDays[1];
				}if(vehicleAndTotalDistanceCount.containsKey(vehno)){
					String totdist[] = vehicleAndTotalDistanceCount.get(vehno);
                    lastServiceDate = totdist[0];
					totdistance = Double.parseDouble((totdist[1]));
				}
				if(MonthlyAvgDistanceOfVehicle.containsKey(vehno)){
					monthlyAvgDistance = MonthlyAvgDistanceOfVehicle.get(vehno);
                    
				}
				
				if(!lastServiceDate.equalsIgnoreCase("") && totdistance!=0 ){
				Date selectedDate = dateFormatq.parse(lastServiceDate);
				cal = Calendar.getInstance();
			    cal.setTime(selectedDate);			    
			    cal.add(Calendar.DATE, thdays);
			    Date expdate = cal.getTime();
			   
			    // logic for distance
			    cal = Calendar.getInstance();
			    cal.setTime(selectedDate);		
			    Date lastServ = cal.getTime();
			    
			    cal = Calendar.getInstance();
			    Date datefromjspd = dateFormatq.parse(datefromjsp);
			    cal.setTime(datefromjspd);		
			    Date today =cal.getTime();
			    //System.out.println(" today == "+today);
			    //System.out.println(" thismonthEndTime == "+thismonthEndTime);
			 //   int noOfDays = daysBetween(today,lastServ);			    
			    int pedingDays = daysBetween(thismonthEndTime,today);	
			    //System.out.println(" pedingDays == "+pedingDays);
			    int forecastingDays = daysBetween(nextmonthEndTime,today);
			    
			//    double perDayDistance = totdistance/noOfDays;
			    double perDayDistance = monthlyAvgDistance;
			    double pendingDistance = totdistance+(pedingDays*perDayDistance);
			    double foreCastingDistance = totdistance+(forecastingDays*perDayDistance);

//                if(expdate.after(min1) && expdate.before(max1)){
//			    	PendingVehCount++;	
//			    }else if(expdate.after(min2) && expdate.before(max2)){
//			    	forecastVehCount++;
//			    }else if(pendingDistance>thdistance){
//			    	PendingVehCount++;	
//			    }else if(foreCastingDistance>thdistance){
//			    	forecastVehCount++;
//			    }
			
			    if(pendingDistance>thdistance){
			    	PendingVehCount++;	
			    }else if(foreCastingDistance>thdistance){
			    	forecastVehCount++;
			    }
			    
				}
			}
			}
			
			pending.put(group, PendingVehCount);	
			forecast.put(group, forecastVehCount);
		}
	
		pendingAndForecastMapRegionWise.add(pending);
		pendingAndForecastMapRegionWise.add(forecast);
		}catch(Exception e){
		e.printStackTrace();	
		}finally{
			DBConnection.releaseConnectionToDB(null,pstmt,rs);
		}
		
		return pendingAndForecastMapRegionWise;
	}
	
	private ArrayList<ArrayList<String []>>  getp2newOnClick(Connection con,String time1,String time2,int offset,int systemId,int customerid,String replaceString,String futureTime1,String futureTime2,int userId,String groupName,String datefromjsp){
		HashMap<String, String[]> vehicleAndTotalDistanceCount = new HashMap<String, String[]>();
		HashMap<String, Double> MonthlyAvgDistanceOfVehicle = new HashMap<String, Double>();
		HashMap<String, int[]> vehicleAndThreshouldDistanceAndDaysCount = new HashMap<String, int[]>();
		ArrayList<ArrayList<String []>> pendingAndForecastArraylistVehicleWiseWise = new ArrayList<ArrayList<String []>>();
		DateFormat dateFormatq = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		DateFormat dateFormat2 = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss.SSS");
		DateFormat dateFormatNew = new SimpleDateFormat("dd/MM/yyyy");
		datefromjsp = datefromjsp+" 00:00:00";
		ArrayList<String []> forecast = new ArrayList<String []>();
		ArrayList<String []> pending = new ArrayList<String []>();
		
		Calendar cal = Calendar.getInstance();
		Date dt = null;
		Date min1 = null;
		Date max1 = null;
		Date min2 = null;
		Date max2 = null;
    
		try{
			Calendar mycal = null;
			mycal = Calendar.getInstance();
			mycal.setTime(dateFormatq.parse(time1));
			mycal.add(Calendar.MONTH, -1);
		    dt = mycal.getTime();	    
		    String time2start = dateFormatq.format(dt);
		    mycal = Calendar.getInstance();
		    mycal.setTime(dateFormatq.parse(time1));
		    mycal.add(Calendar.MONTH, -1);
		    int daysInMonth = mycal.getActualMaximum(Calendar.DAY_OF_MONTH);
		    mycal.add(Calendar.DATE, daysInMonth);
		    dt = mycal.getTime();	    
		    String time2end = dateFormatq.format(dt);
			
		    
			cal = Calendar.getInstance();
		    cal.setTime(dateFormatq.parse(time1));			    
		    min1 = cal.getTime();	    
		  //  String mins1 = dateFormat.format(min1);
		    cal = Calendar.getInstance();
		    cal.setTime(dateFormatq.parse(time2));			    
		    max1 = cal.getTime();	    
		 //   String maxs1 = dateFormat.format(max1);
		    cal = Calendar.getInstance();
		    cal.setTime(dateFormatq.parse(futureTime1));			    
		    min2 = cal.getTime();	    
		 //   String mins2 = dateFormat.format(min2);
		    cal = Calendar.getInstance();
		    cal.setTime(dateFormatq.parse(futureTime2));			    
		    max2 = cal.getTime();	    
		   // String maxs2 = dateFormat.format(max2);
			
			HashMap<String,  ArrayList<String>> groupVehicleArrayList = new HashMap<String, ArrayList<String>>();
			 ArrayList<String> vehicleList = new ArrayList<String>();
			// getting group and respective vehicle each group	
			pstmt = con.prepareStatement(FleetMaintanceStatements.GET_VEHICLE_OF_EACH_GROUP_WISE.replace("#", replaceString));							
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, customerid);
			pstmt.setInt(3, userId);
			pstmt.setString(4, groupName);
           rs = pstmt.executeQuery();
           
           String group= "";
           String prevGroup = "";
           int count = 0;
		    while(rs.next()) {	
		    	count++;
		    	if(count == 1){
		    		vehicleList = new ArrayList<String>();
		    		group = rs.getString("GROUP_NAME");
		    		prevGroup = group;
		    		vehicleList.add(rs.getString("ASSET_NUMBER"));						    		
		    	}else{
		    		group = rs.getString("GROUP_NAME");
		    		if(prevGroup.equals(group)){
		    		vehicleList.add(rs.getString("ASSET_NUMBER"));	
		    		}else{
		    			groupVehicleArrayList.put(prevGroup, vehicleList);
		    			vehicleList = new ArrayList<String>();
			    		group = rs.getString("GROUP_NAME");
			    		prevGroup = group;
			    		vehicleList.add(rs.getString("ASSET_NUMBER"));	
		    		}
		    	}
		    									
		}					
		    groupVehicleArrayList.put(prevGroup, vehicleList);									
	
		    
		    HashMap<String, String> VehicleTypeMap = new HashMap<String, String>();
			
			pstmt = con.prepareStatement(FleetMaintanceStatements.GET_VEHICLE_AND_VEHICLE_TYPE);							
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, customerid);
			pstmt.setInt(3, userId);
            rs = pstmt.executeQuery(); 
		    while(rs.next()){
		    	VehicleTypeMap.put(rs.getString("ASSET_NUMBER"), rs.getString("VehicleType"));	
		    }
            
		pstmt = con.prepareStatement(FleetMaintanceStatements.get_tatal_distance_from_lastServiceDate_new.replace("#", replaceString));
		//pstmt.setInt(1, 32);
		pstmt.setInt(1, systemId);
		pstmt.setInt(2, customerid);
		pstmt.setInt(3, -offset);
		pstmt.setString(4, time2);
		pstmt.setInt(5, systemId);
		pstmt.setInt(6, customerid);	
		pstmt.setInt(7, userId);
		rs = pstmt.executeQuery();						
		while(rs.next()) {
			String asset = rs.getString("ASSET_NUMBER");			
			String arr[] = {rs.getString("LAST_SERVICE_DATE"),dftwodigit.format(rs.getDouble("TOTAL_DISTANCE"))};
			vehicleAndTotalDistanceCount.put(asset, arr);
		}

		pstmt = con.prepareStatement(FleetMaintanceStatements.get_th_distance_and_th_days.replace("#", replaceString));
		//pstmt.setInt(1, 32);
		pstmt.setInt(1, systemId);
		pstmt.setInt(2, customerid);
		pstmt.setInt(3, userId);										
		rs = pstmt.executeQuery();						
		while(rs.next()) {
			String asset = rs.getString("ASSET_NUMBER");				
			int arr[] = {rs.getInt("THRESHOULD_DISTANCE"),rs.getInt("THRESHOULD_DAYS")};
			vehicleAndThreshouldDistanceAndDaysCount.put(asset, arr);
		}
		
		pstmt = con.prepareStatement(FleetMaintanceStatements.get_Monthly_avg_distance.replace("#", replaceString));		
		pstmt.setInt(1, -offset);
		pstmt.setString(2, time2start);
		pstmt.setInt(3, -offset);
		pstmt.setString(4, time2end);
		pstmt.setInt(5, systemId);
		pstmt.setInt(6, customerid);	
		pstmt.setInt(7, userId);
		rs = pstmt.executeQuery();						
		while(rs.next()) {
			String asset = rs.getString("ASSET_NUMBER");			
			double avgdistance = Double.parseDouble(dftwodigit.format(rs.getDouble("TOTAL_DISTANCE")));
			MonthlyAvgDistanceOfVehicle.put(asset, avgdistance);
		}
		
		
		Date thismonthEndTime = dateFormatq.parse(time2);
		cal = Calendar.getInstance();
	    cal.setTime(thismonthEndTime);		
	    thismonthEndTime =cal.getTime(); 
	    String time2Str =dateFormatNew.format(dateFormatq.parse(time2));
	   
	    Date nextmonthEndTime = dateFormatq.parse(futureTime2);
		cal = Calendar.getInstance();
	    cal.setTime(nextmonthEndTime);		
	    nextmonthEndTime =cal.getTime(); 
		String futureTime2str = dateFormatNew.format(dateFormatq.parse(futureTime2));
		
		for(Map.Entry<String, ArrayList<String>> entry: groupVehicleArrayList.entrySet()){
			int PendingVehCount = 0;
			int forecastVehCount = 0;
			group = entry.getKey();
			ArrayList<String> vehlist = entry.getValue();
			int vehcount = 0;
			if(vehlist.size()>0){
			for(int i=0; i<vehlist.size();i++){
				String vehno = vehlist.get(i);
				double totdistance = 0;
				double monthlyAvgDistance = 0;
				int thdistance = 0;
				int thdays = 0;				 
			    String lastServiceDate = "";
			    String vehType = "";
				if(VehicleTypeMap.containsKey(vehno)){
					vehType=VehicleTypeMap.get(vehno);
				}
			    if(vehicleAndThreshouldDistanceAndDaysCount.containsKey(vehno)){
					int thdistAndDays[] = vehicleAndThreshouldDistanceAndDaysCount.get(vehno);
					thdistance =thdistAndDays[0];
					thdays = thdistAndDays[1];
				}if(vehicleAndTotalDistanceCount.containsKey(vehno)){
					String totdist[] = vehicleAndTotalDistanceCount.get(vehno);
                    lastServiceDate = totdist[0];
					totdistance = Double.parseDouble((totdist[1]));
				}
				if(MonthlyAvgDistanceOfVehicle.containsKey(vehno)){
					monthlyAvgDistance = MonthlyAvgDistanceOfVehicle.get(vehno);
                    
				}		
				if(!lastServiceDate.equalsIgnoreCase("") && totdistance!=0 ){
				Date selectedDate = dateFormatq.parse(lastServiceDate);
				cal = Calendar.getInstance();
			    cal.setTime(selectedDate);			    
			    cal.add(Calendar.DATE, thdays);
			    Date expdate = cal.getTime();
			   
			    String expdatedbformat  = dateFormatq.format(expdate);
			    String expdatedbformatstr =dateFormatNew.format(dateFormatq.parse(expdatedbformat));
			    // logic for distance
			    cal = Calendar.getInstance();
			    cal.setTime(selectedDate);		
			    Date lastServ = cal.getTime();
			    
			    cal = Calendar.getInstance();
			    Date datefromjspd = dateFormatq.parse(datefromjsp);
			    cal.setTime(datefromjspd);		
			    Date today =cal.getTime();
			    
			   // int noOfDays = daysBetween(today,lastServ);			    
			    int pedingDays = daysBetween(thismonthEndTime,today);			    
			    int forecastingDays = daysBetween(nextmonthEndTime,today);
			    
			   // double perDayDistance = totdistance/noOfDays;
			    double perDayDistance = monthlyAvgDistance;
			    double pendingDistance = totdistance+(pedingDays*perDayDistance);
			    double foreCastingDistance = totdistance+(forecastingDays*perDayDistance);

//                if(expdate.after(min1) && expdate.before(max1)){		
//                	String vehDetails[] = {vehno,group,expdatedbformatstr};
//                	pending.add(vehDetails);	
//			    }else if(expdate.after(min2) && expdate.before(max2)){
//			    	String vehDetails[] = {vehno,group,expdatedbformatstr};
//			    	forecast.add(vehDetails);
//			    }else if(pendingDistance>thdistance){
//			    	String vehDetails[] = {vehno,group,time2Str};
//                	pending.add(vehDetails);	
//			    }else if(foreCastingDistance>thdistance){
//			    	String vehDetails[] = {vehno,group,futureTime2str};
//			    	forecast.add(vehDetails);
//			    }
			    if(pendingDistance>thdistance){
			    	String vehDetails[] = {vehno,group,time2Str,vehType};
                	pending.add(vehDetails);	
			    }else if(foreCastingDistance>thdistance){
			    	String vehDetails[] = {vehno,group,futureTime2str,vehType};
			    	forecast.add(vehDetails);
			    }
			    
				}
			}
			}
		
		}
		pendingAndForecastArraylistVehicleWiseWise.add(pending);
		pendingAndForecastArraylistVehicleWiseWise.add(forecast);

		}catch(Exception e){
		e.printStackTrace();	
		}finally{
			DBConnection.releaseConnectionToDB(null,pstmt,rs);
		}
		
		return pendingAndForecastArraylistVehicleWiseWise;
	}
	
	
	public static int daysBetween(Date d1, Date d2) {
		return (int) ((d1.getTime() - d2.getTime()) / (1000 * 60 * 60 * 24));
	}
	
public 	HashMap<String, String[]>  getHashMapforIdlingTrend(PreparedStatement pstmt,ResultSet rs,Connection con,String day1qst,String day1qend,int offset,int userId,int systemId,int customerid,String groupName,String replaceString){
	HashMap<String, String[]>  regionidleCountMap = new HashMap<String, String[]>();
	DateFormat dateFormatNew = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
	DateFormat dateFormatq = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	try{
	regionidleCountMap = new HashMap<String, String[]>();
	
    String day1qstforJsp =dateFormatNew.format(dateFormatq.parse(day1qst));
    String day1qendforJsp =dateFormatNew.format(dateFormatq.parse(day1qend));
	pstmt = con.prepareStatement(FleetMaintanceStatements.GET_IDLING_PERCENTAGE_ONCLICK.replace("#", replaceString));
	pstmt.setInt(1, -offset); 
	pstmt.setString(2, day1qst);
	pstmt.setInt(3, -offset); 
	pstmt.setString(4, day1qend);
	pstmt.setInt(5, systemId);
	pstmt.setInt(6, customerid);
	pstmt.setInt(7, userId);
	pstmt.setString(8, groupName);
	pstmt.setInt(9, -offset); 
	pstmt.setString(10, day1qst);
	pstmt.setInt(11, -offset); 
	pstmt.setString(12, day1qend);
	pstmt.setInt(13, systemId);
	pstmt.setInt(14, customerid);
	pstmt.setInt(15, userId);
	pstmt.setString(16, groupName);
rs = pstmt.executeQuery();

while(rs.next()) {	
	String percentages = "0.0";
	if (rs.getDouble("IDLE_HRS") != 0.0
			&& rs.getDouble("ENGINE_HRS") != 0.0) {
		double idleDuration = rs.getDouble("IDLE_HRS");

		double engineDuration = rs.getDouble("ENGINE_HRS");
		percentages = dftwodigit.format(((idleDuration / engineDuration) * 100));
	} else {
		percentages = "0.0";
	}
	String arr[]= {percentages,getHHMMTimeFormat(rs.getDouble("IDLE_HRS")),getHHMMTimeFormat(rs.getDouble("ENGINE_HRS")),day1qstforJsp,day1qendforJsp,rs.getString("VehicleType") };
	
	regionidleCountMap.put(rs.getString("VEHICLE_NO"), arr);
}


	}catch(Exception e){
		e.printStackTrace();
	}
	return regionidleCountMap;
}

public JSONArray getJosonArray(String groupName, HashMap<String, String[]>  regionidleCountMap,JSONArray idlingJSONArray){
	JSONObject idlingJSONObject=new JSONObject();
	int count = 0;
	try{
    for(Map.Entry<String, String[]> entry: regionidleCountMap.entrySet()){
    	count++;
		String veh = entry.getKey();
			
			String percentages[] = regionidleCountMap.get(veh);					
		   
		    idlingJSONObject=new JSONObject();
			idlingJSONObject.put("vehicleNoDateIndex",veh);
			idlingJSONObject.put("groupNameDataIndex",groupName);
			idlingJSONObject.put("idlinghrsDataIndex",percentages[1]);
			idlingJSONObject.put("enginehrsDataIndex",percentages[2]);
			idlingJSONObject.put("startDateDataIndex","");
			idlingJSONObject.put("startDateNewDataIndex",percentages[3]);
			idlingJSONObject.put("endDateDataIndex",percentages[4]);
			idlingJSONObject.put("idlingCountDataIndex",percentages[0]);
			idlingJSONObject.put("pmCountDataIndex",0);
			idlingJSONObject.put("pmCountbeforeexpDataIndex",0);
			idlingJSONObject.put("pmCountafterexpDataIndex",0);
			idlingJSONObject.put("vehicleTypeDateIndex",percentages[5]);
			idlingJSONArray.put(idlingJSONObject);
		
}
}catch(Exception e){
	e.printStackTrace();
}
	
	return idlingJSONArray;
}
public 	JSONArray getHashMapforStatutoryTrend(PreparedStatement pstmt,ResultSet rs,Connection con,String day1qst,String day1qend,int offset,int userId,int systemId,int customerid,String groupName,String replaceString,String statutoryType,JSONArray idlingJSONArray){
	HashMap<String, String[]>  regionidleCountMap = new HashMap<String, String[]>();
	DateFormat dateFormatNew = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
	DateFormat dateFormatq = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	
	int expalertId = 0;
	int duealertId = 0;
	String alertType =  " " ;
    if(statutoryType.equals("Insurance")){
    	 expalertId = 32;
		 duealertId = 10;
		 alertType =  " vt.Insurance  " ;
	}else if(statutoryType.equals("Goods Token Tax")){
		 expalertId = 33;
		 duealertId = 11;
		 alertType =  " vt.Goods_TokenTax " ;
	}else if(statutoryType.equals("FCI")){
		 expalertId = 34;
		 duealertId = 12;
		 alertType =  " vt.FC " ;
	}else if(statutoryType.equals("Emission")){
		 expalertId = 35;
		 duealertId = 13;
		 alertType= " vt.EmissionCheck " ;
	}else if(statutoryType.equals("Permit")){
		 expalertId = 36;
		 duealertId = 15;
		 alertType= " vt.PermitValidity " ;
	}else if(statutoryType.equals("Registration")){
		 expalertId = 131;
		 duealertId = 130;
		 alertType= " vt.RegistrationExpiryDate " ;
	}else if(statutoryType.equals("Driver Licence")){
		 expalertId = 142;
		 duealertId = 141;			
    }else {
    	
    }
	
	try{
	regionidleCountMap = new HashMap<String, String[]>();
	JSONObject idlingJSONObject=new JSONObject();
    String day1qstforJsp =dateFormatNew.format(dateFormatq.parse(day1qst));
    String day1qendforJsp =dateFormatNew.format(dateFormatq.parse(day1qend));
    
    pstmt = con.prepareStatement(FleetMaintanceStatements.GET_STATUTORY_DUE_COUNT_ONCLICK.replace("#", replaceString));
	pstmt.setInt(1, systemId);
	pstmt.setInt(2, customerid);
	pstmt.setInt(3, userId);
	pstmt.setInt(4,expalertId);							
	pstmt.setString(5, day1qst);
	pstmt.setString(6, day1qend);	
	pstmt.setString(7, groupName);	
	pstmt.setInt(8, systemId);
	pstmt.setInt(9, customerid);
	pstmt.setInt(10, userId);
	pstmt.setInt(11,expalertId);							
	pstmt.setString(12, day1qst);
	pstmt.setString(13, day1qend);	
	pstmt.setString(14, groupName);	
rs = pstmt.executeQuery();						
while(rs.next()) {
	String vehicle = rs.getString("VehicleNo");
	String dueDate =  rs.getString("DueDate");
	String vehicletYpes = rs.getString("VehicleType");
	idlingJSONObject=new JSONObject();
	idlingJSONObject.put("vehicleNoDateIndex",vehicle);
	idlingJSONObject.put("groupNameDataIndex",groupName);
	idlingJSONObject.put("idlinghrsDataIndex","");
	idlingJSONObject.put("enginehrsDataIndex","");
	idlingJSONObject.put("startDateDataIndex","");
	idlingJSONObject.put("startDateNewDataIndex","");
	idlingJSONObject.put("endDateDataIndex","");
	idlingJSONObject.put("idlingCountDataIndex","");
	idlingJSONObject.put("pmCountDataIndex",0);
	idlingJSONObject.put("pmCountbeforeexpDataIndex",0);
	idlingJSONObject.put("pmCountafterexpDataIndex",0);
	idlingJSONObject.put("vehicleTypeDateIndex",vehicletYpes);
	idlingJSONObject.put("DueDateDataIndex",dateFormatNew.format(dateFormatq.parse(dueDate)));
	idlingJSONArray.put(idlingJSONObject);
	
}
	}catch(Exception e){
		e.printStackTrace();
	}
	return idlingJSONArray;
}

public 	JSONArray getHashMapforStatutoryTrendForecasting(PreparedStatement pstmt,ResultSet rs,Connection con,String day1qst,String day1qend,int offset,int userId,int systemId,int customerid,String groupName,String replaceString,String statutoryType,JSONArray idlingJSONArray){
	HashMap<String, String[]>  regionidleCountMap = new HashMap<String, String[]>();
	DateFormat dateFormatNew = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
	DateFormat dateFormatq = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	
	int expalertId = 0;
	int duealertId = 0;
	String alertType =  " " ;
    if(statutoryType.equals("Insurance")){
    	 expalertId = 32;
		 duealertId = 10;
		 alertType =  " vt.Insurance  " ;
	}else if(statutoryType.equals("Goods Token Tax")){
		 expalertId = 33;
		 duealertId = 11;
		 alertType =  " vt.Goods_TokenTax " ;
	}else if(statutoryType.equals("FCI")){
		 expalertId = 34;
		 duealertId = 12;
		 alertType =  " vt.FC " ;
	}else if(statutoryType.equals("Emission")){
		 expalertId = 35;
		 duealertId = 13;
		 alertType= " vt.EmissionCheck " ;
	}else if(statutoryType.equals("Permit")){
		 expalertId = 36;
		 duealertId = 15;
		 alertType= " vt.PermitValidity " ;
	}else if(statutoryType.equals("Registration")){
		 expalertId = 131;
		 duealertId = 130;
		 alertType= " vt.RegistrationExpiryDate " ;
	}else if(statutoryType.equals("Driver Licence")){
		 expalertId = 142;
		 duealertId = 141;			
    }else {
    	
    }
	
	try{
	regionidleCountMap = new HashMap<String, String[]>();
	JSONObject idlingJSONObject=new JSONObject();
    String day1qstforJsp =dateFormatNew.format(dateFormatq.parse(day1qst));
    String day1qendforJsp =dateFormatNew.format(dateFormatq.parse(day1qend));
   
    if(statutoryType.equals("Driver Licence")){
   	 pstmt = con.prepareStatement(FleetMaintanceStatements.GET_STATUTORY_DUE_DRIVER_LICENSE_ONCLICK.replace("#", replaceString));	
   	 pstmt.setInt(1, systemId);
		 pstmt.setInt(2, customerid);
		 pstmt.setInt(3, userId);
		 pstmt.setString(4, day1qst);
		 pstmt.setString(5, day1qend);	
		 pstmt.setString(6, groupName);	
		}
	else{  
		final String GET_STATUTORY_DUE_COUNT_FORECASTING_ONCLICK = " select vt.VehicleNo,vt.VehicleType,vg.GROUP_NAME, "+alertType+" as DUE_DATE  "+
		" from AMS.dbo.tblVehicleMaster vt "+
		" inner join AMS.dbo.VEHICLE_CLIENT vc on vt.VehicleNo COLLATE DATABASE_DEFAULT  = vc.REGISTRATION_NUMBER "+
		" inner join AMS.dbo.Vehicle_User c on c.Registration_no=vc.REGISTRATION_NUMBER collate database_default "+
		" inner join AMS.dbo.VEHICLE_GROUP vg on   vc.GROUP_ID= vg.GROUP_ID  "+
		" where vt.System_id = ? and vg.CLIENT_ID =? and c.User_id = ?  and $  "+
		" # "+
		" and vg.GROUP_NAME = ? ";

  pstmt = con.prepareStatement(GET_STATUTORY_DUE_COUNT_FORECASTING_ONCLICK.replace("#", replaceString).replace("$", alertType + " between "+"'"+day1qst+"'"+" and "+"'"+day1qend+"'"+" "));
  pstmt.setInt(1, systemId);
	pstmt.setInt(2, customerid);
	 pstmt.setInt(3, userId);
	 pstmt.setString(4, groupName);	
	}
rs = pstmt.executeQuery();						
while(rs.next()) {
	String vehicle = rs.getString("VehicleNo");
	String groupNames = rs.getString("GROUP_NAME");
	String dueDate = rs.getString("DUE_DATE");
	
	idlingJSONObject=new JSONObject();
	idlingJSONObject.put("vehicleNoDateIndex",vehicle);
	idlingJSONObject.put("groupNameDataIndex",groupNames);
	idlingJSONObject.put("idlinghrsDataIndex","");
	idlingJSONObject.put("enginehrsDataIndex","");
	idlingJSONObject.put("startDateDataIndex","");
	idlingJSONObject.put("startDateNewDataIndex","");
	idlingJSONObject.put("endDateDataIndex","");
	idlingJSONObject.put("idlingCountDataIndex","");
	idlingJSONObject.put("pmCountDataIndex",0);
	idlingJSONObject.put("pmCountbeforeexpDataIndex",0);
	idlingJSONObject.put("pmCountafterexpDataIndex",0);
	idlingJSONObject.put("vehicleTypeDateIndex",rs.getString("VehicleType"));
	idlingJSONObject.put("DueDateDataIndex",dateFormatNew.format(dateFormatq.parse(dueDate)));
	idlingJSONArray.put(idlingJSONObject);
	
}
	}catch(Exception e){
		e.printStackTrace();
	}
	return idlingJSONArray;
}

public 	JSONArray getHashMapforFuelEfficiencyTrend(PreparedStatement pstmt,ResultSet rs,Connection con,String day1qst,String day1qend,int offset,int userId,int systemId,int customerid,String groupName,String replaceString,JSONArray idlingJSONArray){
	HashMap<String, String[]>  regionidleCountMap = new HashMap<String, String[]>();
	DateFormat dateFormatNew = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
	DateFormat dateFormatq = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	
	try{
	regionidleCountMap = new HashMap<String, String[]>();
	JSONObject idlingJSONObject=new JSONObject();
    String day1qstforJsp =dateFormatNew.format(dateFormatq.parse(day1qst));
    String day1qendforJsp =dateFormatNew.format(dateFormatq.parse(day1qend));
    
    HashMap< String , Double> vehicleDesielMap = new  HashMap< String , Double>();
    HashMap< String , Double> vehicleDistanceMap = new  HashMap< String , Double>();
    HashMap< String , String> vehicleTypeMap = new  HashMap< String , String>();
    ArrayList<String> vehicleList = new ArrayList<String>();
    String vehicleList1 = "";
    pstmt = con.prepareStatement(FleetMaintanceStatements.GET_FUEL_ONCLICK.replace("#", replaceString));							
	 pstmt.setInt(1, -offset);  
	 pstmt.setString(2, day1qst);
	 pstmt.setInt(3, -offset);
	 pstmt.setString(4,day1qend);
	 pstmt.setInt(5, systemId);
	 pstmt.setInt(6, customerid);
	 pstmt.setInt(7, userId);
	 pstmt.setString(8,groupName);
    rs = pstmt.executeQuery();
    while (rs.next()){
    	vehicleDesielMap.put(rs.getString("ASSET_NUMBER"), rs.getDouble("FUEL"));
    	vehicleList.add("'"+rs.getString("ASSET_NUMBER")+"'");
    }
    for(String vehicleNumber:vehicleList){
    	vehicleList1 = vehicleList1+","+vehicleNumber;
    }
    if(vehicleList1.length()>1){
		 vehicleList1 = vehicleList1.substring(1);
		 }else{
		    	vehicleList1 = "' '";
		    }
    pstmt = con.prepareStatement(FleetMaintanceStatements.GET_DISTANCE_COUNT_NEW_LOGIC_ONCLICK.replace("#", replaceString).replace("$", vehicleList1));
	pstmt.setInt(1, -offset);  
	pstmt.setString(2, day1qst);					
	pstmt.setInt(3, -offset);  
	pstmt.setString(4,day1qend);
    pstmt.setInt(5, systemId);
	pstmt.setInt(6, customerid);
	pstmt.setInt(7, userId);
	pstmt.setString(8, groupName);
	pstmt.setInt(9, -offset);  
	pstmt.setString(10, day1qst);					
	pstmt.setInt(11, -offset);  
	pstmt.setString(12, day1qend);
    pstmt.setInt(13, systemId);
	pstmt.setInt(14, customerid);
	pstmt.setInt(15, userId);
	pstmt.setString(16, groupName);
	rs = pstmt.executeQuery();	
	while (rs.next()){
		vehicleDistanceMap.put(rs.getString("VehicleNo"), rs.getDouble("DISTANCE"));
		vehicleTypeMap.put(rs.getString("VehicleNo"), rs.getString("VehicleType"));
    }
    
	
	if(vehicleDesielMap.size()>0){
	    for(Map.Entry<String, Double> entry: vehicleDesielMap.entrySet()){
		
	    	double distance1 = 0;			
			double fuel1 = 0;			
			double percentage1 = 0;
			String vehType = "";
			// calculate percentages
			 String vehicle = entry.getKey();
			
			 if(vehicleDistanceMap.containsKey(entry.getKey())){
				 vehType = vehicleTypeMap.get(entry.getKey());
				 distance1 = vehicleDistanceMap.get(entry.getKey());
				 fuel1 = entry.getValue();
				 if(fuel1>0){
			     percentage1 =Double.parseDouble(dftwodigit.format(distance1/fuel1)); 
				 }
		idlingJSONObject=new JSONObject();
		idlingJSONObject.put("groupNameDataIndex",groupName);
		idlingJSONObject.put("vehicleNoDateIndex",vehicle);	
		idlingJSONObject.put("idlinghrsDataIndex","");
		idlingJSONObject.put("enginehrsDataIndex","");
		idlingJSONObject.put("startDateDataIndex","");
		idlingJSONObject.put("startDateNewDataIndex",day1qstforJsp);
		idlingJSONObject.put("endDateDataIndex",day1qendforJsp);
		idlingJSONObject.put("idlingCountDataIndex","");
		idlingJSONObject.put("pmCountDataIndex",0);
		idlingJSONObject.put("pmCountbeforeexpDataIndex",0);
		idlingJSONObject.put("pmCountafterexpDataIndex",0);
		idlingJSONObject.put("DueDateDataIndex","");
		idlingJSONObject.put("DistanceDataIndex",Double.parseDouble(dftwodigit.format(distance1)));
		idlingJSONObject.put("FuelDataIndex",Double.parseDouble(dftwodigit.format(fuel1)));
		idlingJSONObject.put("MileageDataIndex",percentage1);
		idlingJSONObject.put("vehicleTypeDateIndex",vehType);
		idlingJSONArray.put(idlingJSONObject);		
			
	     }
	   }
	}
	
	}catch(Exception e){
		e.printStackTrace();
	}
	return idlingJSONArray;
}


}
