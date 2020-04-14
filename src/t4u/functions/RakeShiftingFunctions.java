package t4u.functions;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashSet;
import java.util.Set;

import org.json.JSONArray;
import org.json.JSONObject;

import t4u.beans.RakeShiftDetails;
import t4u.beans.ReportHelper;
import t4u.common.DBConnection;
import t4u.statements.RakeShiftingStatements;

public class RakeShiftingFunctions {
	
	public String addRakeExpenseDetails(String location,int loadType, double fuelLtrs, double fuelRates, double incentives, int systemId,int custId,int userId){
		Connection con = null;
		PreparedStatement pstmt= null;
		ResultSet rs = null;
		String message="";
		
		try{
			con = DBConnection.getConnectionToDB("LMS");
			pstmt = con.prepareStatement(RakeShiftingStatements.CHECK_LOCATION_ALREADY_EXIST);
			pstmt.setString(1, location);
			pstmt.setInt(2, loadType);
			pstmt.setInt(3, systemId);
			pstmt.setInt(4, custId);
			rs = pstmt.executeQuery(); 
			if(rs.next()){
				message="Record already exist...";
				return message; 
			}else {
				pstmt = con.prepareStatement(RakeShiftingStatements.INSERT_RAKE);
				pstmt.setString(1, location.toUpperCase());
				pstmt.setInt(2, loadType);
				pstmt.setDouble(3, fuelLtrs);
				pstmt.setDouble(4, fuelRates);
				pstmt.setDouble(5,incentives);
				pstmt.setInt(6, userId);
				pstmt.setInt(7, systemId);
				pstmt.setInt(8, custId);
				int inserted = pstmt.executeUpdate();
				if (inserted > 0) {
					message = "Record saved successfully...";
				}
			}
		} catch (Exception e){
			System.out.println("error in:-save RouteMaster details "+e.toString());
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
	    }
		return message;
	}
	
	public String modifyRakeExpenseDetails(double fuelLtrs, double fuelRates, double incentives,int userId,int systemId, int custId, int id){
		Connection con=null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		String message="";
		try{
			con=DBConnection.getConnectionToDB("LMS");
				
			pstmt=con.prepareStatement(RakeShiftingStatements.UPDATE_RAKE);
			pstmt.setDouble(1,fuelLtrs);
			pstmt.setDouble(2,fuelRates);
			pstmt.setDouble(3,incentives);
			pstmt.setInt(4, userId);
			pstmt.setInt(5,systemId);
			pstmt.setInt(6, custId);
			pstmt.setInt(7,id);
			int updated=pstmt.executeUpdate();
			if(updated>0){
				message = "Record updated successfully...";
			}
		}catch(Exception e){
			System.out.println("error in :-update RakeExpenseMaster details "+e.toString());
			e.printStackTrace();
		}finally{
			DBConnection.releaseConnectionToDB(con,pstmt,rs);
		}
		return message;
	}
	public JSONArray getLocation(int systemId, int ClientId) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		JSONArray jsArr = new JSONArray();		
		try {
			con = DBConnection.getConnectionToDB("LMS");
			pstmt = con.prepareStatement(RakeShiftingStatements.GET_LOCATION_LIST);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, ClientId);
			
			rs = pstmt.executeQuery();
			JSONObject jsObj = new JSONObject();
			while(rs.next()) {
				jsObj = new JSONObject();
				jsObj.put("LocationId", rs.getString("LoadId"));
				jsObj.put("LocationName", rs.getString("LoadingorOffloading"));
				jsArr.put(jsObj);
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
            DBConnection.releaseConnectionToDB(con, pstmt, rs);
        }
		return jsArr;
	}
	public JSONArray getBranchList(int systemId, int ClientId) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		JSONArray jsArr = new JSONArray();		
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(RakeShiftingStatements.GET_BRANCH_LIST);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, ClientId);
			
			rs = pstmt.executeQuery();
			JSONObject jsObj = new JSONObject();
			while(rs.next()) {
				jsObj = new JSONObject();
				jsObj.put("BranchID", rs.getString("BranchId"));
				jsObj.put("BranchName", rs.getString("BranchName"));
				jsArr.put(jsObj);
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
            DBConnection.releaseConnectionToDB(con, pstmt, rs);
        }
		return jsArr;
	}
	public ArrayList<Object> getRakeMasterDetails(int systemId,int custId,int offset){
		SimpleDateFormat sdfyyyymmddhhmmss=new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
		SimpleDateFormat simpleDateFormatddMMYYYYDB = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
    	Connection con = null;
    	PreparedStatement pstmt = null;
    	ResultSet rs = null;
    	JSONArray jsArr = new JSONArray();
    	JSONObject obj = new JSONObject();
    	int slcount = 0; 
    	ArrayList<ReportHelper> reportsList = new ArrayList<ReportHelper>();
    	ArrayList<String> headersList = new ArrayList<String>();
    	ReportHelper finalreporthelper = new ReportHelper();
    	ArrayList<Object> finlist = new ArrayList<Object>();
    	
    	headersList.add("SLNO");
    	headersList.add("ID");
    	headersList.add("Location");
    	headersList.add("Load Type");
    	headersList.add("Fuel Ltrs");
    	headersList.add("Fuel Amount");
    	headersList.add("Incentive");
    	headersList.add("Created By");
    	headersList.add("Created Date");
    	headersList.add("Updated By");
    	headersList.add("Updated Date");
    	
    	try{
    		con = DBConnection.getConnectionToDB("LMS");
    		pstmt = con.prepareStatement(RakeShiftingStatements.GET_RAKE_MASTER_DETAILS);
    		pstmt.setInt(1, offset);
	    	pstmt.setInt(2, offset);
    		pstmt.setInt(3, systemId);
	    	pstmt.setInt(4, custId);
	    	rs = pstmt.executeQuery();
    		while (rs.next()) {
    			obj = new JSONObject();
    			ArrayList<Object> informationList=new ArrayList<Object>();
    			ReportHelper reporthelper=new ReportHelper();
    			slcount++;
    			
    			informationList.add(Integer.toString(slcount));
    			obj.put("slnoIndex", slcount);
    			
    			informationList.add(rs.getString("ID"));
    			obj.put("uniqueIdDataIndex", rs.getString("ID"));
    			
    			informationList.add(rs.getString("LOCATION"));
    			obj.put("locationIndex", rs.getString("LOCATION"));
    			
    			if(rs.getInt("LOAD_TYPE")==1){
    				informationList.add("Loaded");
    				obj.put("loadTypeIndex", "Loaded");
    			}else{
    				informationList.add("Empty");
        			obj.put("loadTypeIndex", "Empty");
    			}
    			informationList.add(rs.getString("FUEL_LTRS"));
    			obj.put("fuelLtrsIndex", rs.getString("FUEL_LTRS"));
    			
    			informationList.add(rs.getString("FUEL_AMT"));
    			obj.put("fuelRateIndex", rs.getString("FUEL_AMT"));
    			
    			informationList.add(rs.getString("INCENTIVE"));
    			obj.put("incentivesIndex", rs.getString("INCENTIVE"));
    			
    			informationList.add(rs.getString("INSERTED_BY"));
    			obj.put("createdByIndex", rs.getString("INSERTED_BY"));
    			
    			if(!rs.getString("INSERTED_DATE").contains("1900")){
    			informationList.add(sdfyyyymmddhhmmss.format(simpleDateFormatddMMYYYYDB.parseObject(rs.getString("INSERTED_DATE"))));
    			obj.put("createdDateIndex", sdfyyyymmddhhmmss.format(simpleDateFormatddMMYYYYDB.parse(rs.getString("INSERTED_DATE"))));
    			}else{
					obj.put("createdDateIndex", "");
					informationList.add("");
				}
    			informationList.add(rs.getString("UPDATED_BY"));
    			obj.put("updatedByIndex", rs.getString("UPDATED_BY"));
    			
    			if(!rs.getString("UPDATED_DATE").contains("1900")){
    			informationList.add(sdfyyyymmddhhmmss.format(simpleDateFormatddMMYYYYDB.parseObject(rs.getString("UPDATED_DATE"))));
    			obj.put("updatedDateIndex", sdfyyyymmddhhmmss.format(simpleDateFormatddMMYYYYDB.parse(rs.getString("UPDATED_DATE"))));
    			}else{
    				obj.put("updatedDateIndex", "");
    				informationList.add("");
    			}
    			jsArr.put(obj);
    			reporthelper.setInformationList(informationList);
    			reportsList.add(reporthelper);
    		}
    		finlist.add(jsArr);
    		finalreporthelper.setReportsList(reportsList);
    		finalreporthelper.setHeadersList(headersList);
    		finlist.add(finalreporthelper);
    	} catch (Exception e) {
    		e.printStackTrace();
    	} finally {
    		DBConnection.releaseConnectionToDB(con, pstmt, rs);
    	}
    		return finlist;
    }
	public String addRakeShiftBookingDetails(String jsonData, int systemId,	int clientId, int userId, String bookingType,String branch) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		PreparedStatement pstmt1 = null;
		ResultSet rs1 = null;
		String message = "";
		JSONArray jsonArray = null;
		int newBookingId = 0;
		int temp = 0;
		try {
			con = DBConnection.getConnectionToDB("LMS");
			String slNo = "";
			String bookingDate = "";
			String rakeNo = "";
			String railNo = "";
			String arrivalDate = "";
			String departureDate = "";
			String from = "";
			String to = "";
			String noOfContainers = "";
			String billingCustId = "";
			String shipperName = "";
			int inserted = 0;
			String uid = "";
			if (jsonData != null) {
				String st = "[" + jsonData + "]";
				jsonArray = new JSONArray(st.toString());
			}
			for (int i = 0; i < jsonArray.length(); i++) {
				JSONObject obj = jsonArray.getJSONObject(i);
				slNo = obj.getString("SLNODataIndex");
				bookingDate = obj.getString("BookingDateDataIndex");
				rakeNo = obj.getString("RakeNoDataIndex");
				railNo = obj.getString("RailNoDataIndex");
				arrivalDate = obj.getString("ArrivalDateDataIndex");
				departureDate = obj.getString("DepartureDateDataIndex");
				from = obj.getString("FromDataIndex");
				to = obj.getString("ToDataIndex");
				billingCustId = obj.getString("billingCustomerDataIndex");
				shipperName = obj.getString("shipperNameDataIndex");
				noOfContainers = obj.getString("ContainersDataIndex");
				uid = obj.getString("UidDataIndex");
				if (slNo.contains("new")) {
					pstmt1 = con.prepareStatement(RakeShiftingStatements.GET_BOOKING_ID);
					pstmt1.setInt(1, systemId);
					pstmt1.setInt(2, clientId);
					rs1 = pstmt1.executeQuery();
					if (rs1.next()) {
						temp = rs1.getInt("MAX_BOOKING_NO");
						newBookingId = temp + 1;
					}
					pstmt = con.prepareStatement(RakeShiftingStatements.INSERT_RAKE_SHIFTING_BOOKING);
					pstmt.setInt(1, systemId);
					pstmt.setInt(2, clientId);
					pstmt.setInt(3, newBookingId);
					pstmt.setString(4, bookingType);
					pstmt.setString(5, bookingDate);
					pstmt.setString(6, rakeNo);
					pstmt.setString(7, railNo);
					pstmt.setString(8, arrivalDate);
					pstmt.setString(9, departureDate);
					pstmt.setString(10, from);
					pstmt.setString(11, to);
					pstmt.setString(12, noOfContainers);
					pstmt.setInt(13, userId);
					pstmt.setString(14, billingCustId);
					pstmt.setString(15, shipperName);
					pstmt.setString(16, branch);
					inserted = pstmt.executeUpdate();
				} else {
					pstmt = con.prepareStatement(RakeShiftingStatements.UPDATE_RAKE_SHIFTING_BOOKING);
					pstmt.setString(1, bookingDate);
					pstmt.setString(2, rakeNo);
					pstmt.setString(3, railNo);
					pstmt.setString(4, arrivalDate);
					pstmt.setString(5, departureDate);
					pstmt.setString(6, from);
					pstmt.setString(7, to);
					pstmt.setString(8, noOfContainers);
					pstmt.setInt(9, userId);
					pstmt.setString(10, billingCustId);
					pstmt.setString(11, shipperName);
					pstmt.setString(12, uid);
					inserted = pstmt.executeUpdate();
				}
			}
			if (inserted > 0) {
				message = "Saved Successfully";
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return message;
	}

	public JSONArray getBookingDetails(String bookingType, int systemId, int clientId,String branch) {
		JSONArray JsonArray = new JSONArray();
		JSONObject JsonObject = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			int count = 0;
			con = DBConnection.getConnectionToDB("LMS");
			pstmt = con.prepareStatement(RakeShiftingStatements.GET_BOOKING_DETAILS);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, clientId);
			pstmt.setString(3, bookingType);
			pstmt.setString(4, branch);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				JsonObject = new JSONObject();
				count++;
				JsonObject.put("UidDataIndex", rs.getString("UID"));
				JsonObject.put("SLNODataIndex", count);
				JsonObject.put("BookingNoDataIndex", rs.getString("BOOKING_NO"));
				JsonObject.put("BookingTypeDataIndex", rs.getString("BOOKING_TYPE"));
				JsonObject.put("BookingDateDataIndex", rs.getString("BOOKING_DATE"));
				JsonObject.put("RakeNoDataIndex", rs.getString("RAKE_NO"));
				JsonObject.put("RailNoDataIndex", rs.getString("RAIL_NO"));
				JsonObject.put("ArrivalDateDataIndex", rs.getString("ARRIVAL_DATE"));
				JsonObject.put("DepartureDateDataIndex", rs.getString("DEPARTURE_DATE"));
				JsonObject.put("FromDataIndex", rs.getString("FROM_PLACE"));
				JsonObject.put("ToDataIndex", rs.getString("TO_PLACE"));
				JsonObject.put("billingCustomerDataIndex", rs.getInt("billingCust"));
				JsonObject.put("shipperNameDataIndex", rs.getString("shipperName"));
				JsonObject.put("BranchDataIndex", rs.getString("BRANCH_ID"));
				JsonObject.put("ContainersDataIndex", rs.getString("NO_OF_CONTAINER"));
				JsonArray.put(JsonObject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return JsonArray;
	}
	
	public JSONArray  getDriverName(int systemid, String VehicleNo)
	{
		JSONArray jsonArray = new JSONArray();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try 
		{
			con = DBConnection.getConnectionToDB("AMS");
			String stmt = "";
			stmt = RakeShiftingStatements.SELECT_DRIVER_NAMES;
			
			pstmt = con.prepareStatement(stmt);
			pstmt.setInt(1, systemid);
			pstmt.setString(2, VehicleNo);

			rs = pstmt.executeQuery();
			while (rs.next()) {
				JSONObject obj1 = new JSONObject();
				obj1 = new JSONObject();
				obj1.put("DriverName", rs.getString("Fullname"));
				jsonArray.put(obj1);
			}

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jsonArray;
	}

	public String addTripCreation(String tripType,int userId,int SystemId,int customerId,String vehicleNumber, String driverName,String ownerName,String driverContact,String TPTCombo,String drivingLicence,int branchId)
	{
		Connection con = null;
		PreparedStatement pstmt= null;
		ResultSet rs=null;
		String message="";
		String Trip_ChartNo=generateTripChartNo(SystemId,customerId,con,tripType);
		int inserted=0;
		if(tripType.equals("TDP Vehicle"))
		{
			tripType="TDP";
			TPTCombo="0";
			driverContact="0";
		}
		else if(tripType.equals("Market Vehicle"))
		{
			tripType="MKT";
		}
		try
		{
			 con = DBConnection.getConnectionToDB("LMS");
			 pstmt = con.prepareStatement(RakeShiftingStatements.INSERT_TRIP);
			 pstmt.setInt(1,userId);
			 pstmt.setInt(2,SystemId);
			 pstmt.setInt(3,customerId);
			 pstmt.setString(4,vehicleNumber);
			 pstmt.setString(5,Trip_ChartNo);
			 pstmt.setString(6,driverName);
			 pstmt.setString(7,ownerName);
			 pstmt.setString(8,tripType);
			 pstmt.setLong(9,Long.parseLong(driverContact));
			 pstmt.setInt(10, Integer.parseInt(TPTCombo));
			 pstmt.setString(11, drivingLicence);
			 pstmt.setInt(12, branchId);
			 
			 inserted=pstmt.executeUpdate();
			 if(inserted>0)
			 {
				 message="Trip Inserted Successfully.";
			 }
		}
		catch(Exception e){
			e.printStackTrace();
		}
		finally
		{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return message;
	}
	
	public String modifyTripCreation(String uniqueId,String tripType,int userId,int SystemId,int customerId,String vehicleNumber, String driverName,String ownerName,String driverContact,String TPTCombo,String drivingLicence,int branchId)
	{
		Connection con=null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		String message="";
			try
			{
				con=DBConnection.getConnectionToDB("LMS");
				
					pstmt=con.prepareStatement(RakeShiftingStatements.UPDATE_TRIP);
					pstmt.setString(1,vehicleNumber);
					pstmt.setString(2,driverName);
					pstmt.setString(3,ownerName);
					pstmt.setLong(4,Long.parseLong(driverContact));
					pstmt.setInt(5, Integer.parseInt(TPTCombo));
				    pstmt.setString(6, drivingLicence);
				    pstmt.setInt(7,userId);
					
				    pstmt.setInt(8,Integer.parseInt(uniqueId));
					pstmt.setInt(9,SystemId);
					pstmt.setInt(10,customerId);
				    
					int updated=pstmt.executeUpdate();
					if(updated>0)
					{
							message = "Updated Successfully";
					}
			}
			catch(Exception e){
				System.out.println("error in :-update Tripcreation TDP details "+e.toString());
				e.printStackTrace();
			}
			finally
			{
				DBConnection.releaseConnectionToDB(con,pstmt,rs);
			}
		return message;
	}
	
	@SuppressWarnings("deprecation")
	public String generateTripChartNo(int SystemId,int CustomerId,Connection con, String tripType)
	{
		String tripNo = "";
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String tripCode = "";
		
		if(tripType.equals("TDP Vehicle"))
		{
			tripCode="TDP";
		}
		else if(tripType.equals("Market Vehicle"))
		{
			tripCode="MKT";
		}
		try {
			
			int RunningNo = 0;
			con=DBConnection.getConnectionToDB("LMS");
			pstmt = con.prepareStatement(RakeShiftingStatements.GET_TRIP_NO);
			pstmt.setInt(1, CustomerId);
			pstmt.setInt(2, SystemId);
			pstmt.setString(3,tripType);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				RunningNo = rs.getInt("TRIP_NO");
			}
			rs.close();
			
			RunningNo++;
			Date D = new Date();
			int month = D.getMonth();
			int year = D.getYear();
			int yearTemp = D.getYear();
			if (month > 2) {
				yearTemp++;
			} else {
				year--;
			}
			String Year = String.valueOf(year);
			String YearTemp = String.valueOf(yearTemp);
			YearTemp = YearTemp.substring(1, 3);
			Year = Year.substring(1, 3);

			tripNo = tripCode + "/" + Year + "-" + YearTemp + "/" + RunningNo;
			
			boolean recordPresent = false;
			
			pstmt = con.prepareStatement(RakeShiftingStatements.IS_PRESENT_TRIP_NO);
			pstmt.setInt(1, CustomerId);
			pstmt.setInt(2, SystemId);
			pstmt.setString(3,tripType);
			rs = pstmt.executeQuery();
			if (rs.next())
			{
				recordPresent = true;
			}
			if (recordPresent) {
				pstmt = con.prepareStatement(RakeShiftingStatements.UPDATE_TRIP_NO);
				pstmt.setInt(1, RunningNo);
				pstmt.setInt(2, CustomerId);
				pstmt.setInt(3, SystemId);
				pstmt.setString(4,tripType);
				pstmt.executeUpdate();
			} else {
				pstmt = con.prepareStatement(RakeShiftingStatements.INSERT_TRIP_NO);
				pstmt.setInt(1, RunningNo);
				pstmt.setInt(2, CustomerId);
				pstmt.setInt(3, SystemId);
				pstmt.setString(4,tripType);
				pstmt.executeUpdate();
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
	}
		return tripNo;
}
	
	public ArrayList<Object> getRakeTripDetails(int systemId,int custId,String VehicleType,int branchName)
	{
		SimpleDateFormat sdfyyyymmddhhmmss=new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
		DecimalFormat df=new DecimalFormat("##.##");
		SimpleDateFormat simpleDateFormatddMMYYYYDB = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
    	Connection con = null;
    	PreparedStatement pstmt = null;
    	ResultSet rs = null;
    	JSONArray jsArr = new JSONArray();
    	JSONObject obj = new JSONObject();
    	int slcount = 0; 
    	
    	ArrayList<ReportHelper> reportsList = new ArrayList<ReportHelper>();
    	ArrayList<String> headersList = new ArrayList<String>();
    	ReportHelper finalreporthelper = new ReportHelper();
    	ArrayList<Object> finlist = new ArrayList<Object>();
    	
    	headersList.add("SLNO");
    	headersList.add("Trip ID");
    	headersList.add("Trip Chart No");
    	headersList.add("Vehicle No");
    	headersList.add("Driver Name");
    	headersList.add("Driver Contact");
    	headersList.add("TPT Name");
    	headersList.add("Driving Licence");
    	headersList.add("Owner Name");
    	headersList.add("created By");
    	headersList.add("created Date");
    	headersList.add("Closed By");
    	headersList.add("Closed Date");
    	headersList.add("Status");
    	
    	try
    	{ 
    		   if(VehicleType.equalsIgnoreCase("TDP Vehicle")){
    			   VehicleType = "TDP";
    		   } else if(VehicleType.equalsIgnoreCase("Market Vehicle")){
    			   VehicleType = "MKT";
    		   }
    		
    			con = DBConnection.getConnectionToDB("LMS");
    			pstmt = con.prepareStatement(RakeShiftingStatements.GET_RAKE_TRIP_DETAILs);
    			pstmt.setInt(1, systemId);
	    		pstmt.setInt(2, custId);
	    		pstmt.setString(3, VehicleType);
	    		pstmt.setInt(4, branchName);
	    		rs = pstmt.executeQuery();
    		
	    		while (rs.next()) {
    			obj = new JSONObject();
    			ArrayList<Object> informationList=new ArrayList<Object>();
    			ReportHelper reporthelper=new ReportHelper();
    			slcount++;
    			
    			informationList.add(Integer.toString(slcount));
    			obj.put("slnoIndex", slcount);
    			
    			informationList.add(rs.getString("UID"));
    			obj.put("uniqueIdDataIndex", rs.getString("UID"));
    			
    			informationList.add(rs.getString("tripNo"));
    			obj.put("TripIdIndex", rs.getString("tripNo"));
    			
    			informationList.add(rs.getString("TripChartNO"));
    			obj.put("TripChartNoIndex", rs.getString("TripChartNO"));
    			
    			informationList.add(rs.getString("VehicleNO"));
    			obj.put("vehicleNoIndex", rs.getString("VehicleNO"));
    			
    			informationList.add(rs.getString("DriverName"));
    			obj.put("driverNameIndex", rs.getString("DriverName"));
    			
    			informationList.add(rs.getString("DriverContact"));
    			obj.put("driverContactIndex", rs.getString("DriverContact"));
    			
    			informationList.add(rs.getString("TPTName"));
    			obj.put("TPTNameIndex", rs.getString("TPTName"));
    			
    			informationList.add(rs.getString("DriverLicence"));
    			obj.put("driverLicenceIndex", rs.getString("DriverLicence"));
    			
    			informationList.add(rs.getString("OwnerName"));
    			obj.put("OwnerNameIndex", rs.getString("OwnerName"));
    			
    			informationList.add(rs.getString("CreatedBy"));
    			obj.put("createdByIndex", rs.getString("CreatedBy"));
    			
    			if(!rs.getString("createdDate").contains("1900"))
    			{
    				informationList.add(sdfyyyymmddhhmmss.format(simpleDateFormatddMMYYYYDB.parseObject(rs.getString("createdDate"))));
    				obj.put("createdDateIndex", sdfyyyymmddhhmmss.format(simpleDateFormatddMMYYYYDB.parse(rs.getString("createdDate"))));
    			}
    			else{
					obj.put("createdDateIndex", "");
					informationList.add("");
				}
    			
    			informationList.add(rs.getString("closedBy"));
    			obj.put("closedByIndex", rs.getString("closedBy"));
    			
    			if(!rs.getString("closedDate").contains("1900"))
    			{
    				informationList.add(sdfyyyymmddhhmmss.format(simpleDateFormatddMMYYYYDB.parseObject(rs.getString("closedDate"))));
    				obj.put("closedDateIndex", sdfyyyymmddhhmmss.format(simpleDateFormatddMMYYYYDB.parse(rs.getString("closedDate"))));
    			}
    			else{
					obj.put("closedDateIndex", "");
					informationList.add("");
				}
    			
    			informationList.add(rs.getString("Status"));
    			obj.put("statusIndex", rs.getString("Status"));
    			
    			jsArr.put(obj);
    			reporthelper.setInformationList(informationList);
    			reportsList.add(reporthelper);
    			
    		}
    			finlist.add(jsArr);
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


public JSONArray getBranchNames(int systemId,int customerId)
	{
		JSONArray jsonArray = new JSONArray();
		
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String branchId="";
		String branchName="";
		try {
			
			con = DBConnection.getConnectionToDB("LMS");
			pstmt = con.prepareStatement(RakeShiftingStatements.GET_BRANCH_NAME);		
			
			pstmt.setInt(1, systemId);
			pstmt.setInt(2,customerId);
			
			rs = pstmt.executeQuery();
			JSONObject obj1 = new JSONObject();
			while (rs.next()) {
				obj1 = new JSONObject();
				branchId =rs.getString(1);
				branchName=rs.getString(2);
				obj1.put("branchId", branchId);
				obj1.put("branchName", branchName);
				jsonArray.put(obj1);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jsonArray;
	}

	
	public JSONArray getVehicleNo(String VehicleType,int systemid, int customerId,int userId) {
		JSONArray jsonArray = new JSONArray();
		
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String vehicleNo="";
		
		if(VehicleType!=null)
		{
			if(VehicleType.equalsIgnoreCase("TDP Vehicle"))
			{
				try {
					
					con = DBConnection.getConnectionToDB("LMS");
					pstmt = con.prepareStatement(RakeShiftingStatements.GET_VEHICLE_NUMBERS_TDP);		
					
					pstmt.setInt(1, customerId);
					pstmt.setInt(2, systemid);
					pstmt.setInt(3, userId);
					pstmt.setInt(4, customerId);
					pstmt.setInt(5, systemid);
					pstmt.setInt(6, customerId);
					pstmt.setInt(7, systemid);
					
					rs = pstmt.executeQuery();
					JSONObject obj1 = new JSONObject();
					while (rs.next()) {
						obj1 = new JSONObject();
						vehicleNo =rs.getString(1);
						obj1.put("VehicleNo", vehicleNo);
						
						jsonArray.put(obj1);
						
					}
				} catch (Exception e) {
					e.printStackTrace();
				} finally {
					DBConnection.releaseConnectionToDB(con, pstmt, rs);
				}
			}
			else if(VehicleType.equalsIgnoreCase("Market Vehicle"))
			{
				try 
				{
					
					con = DBConnection.getConnectionToDB("LMS");
					pstmt = con.prepareStatement(RakeShiftingStatements.GET_VEHICLE_NUMBERS_MV);		
					
					pstmt.setInt(1, customerId);
					pstmt.setInt(2, systemid);
					pstmt.setInt(3, systemid);
					pstmt.setInt(4, customerId);
					pstmt.setInt(5, systemid);
					pstmt.setInt(6, customerId);
					
					rs = pstmt.executeQuery();
					JSONObject obj1 = new JSONObject();
					while (rs.next()) {
						obj1 = new JSONObject();
						vehicleNo =rs.getString(1);
						obj1.put("VehicleNo", vehicleNo);
						
						jsonArray.put(obj1);
						
					}
				} catch (Exception e) {
					e.printStackTrace();
				} finally {
					DBConnection.releaseConnectionToDB(con, pstmt, rs);
				}
			}
		}
		return jsonArray;
	}
	
	
	public JSONArray getActiveTransporters(int systemid, int clientId)
	{

	JSONArray jsonArray = new JSONArray();
	
	Connection con = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	try {
		
		con = DBConnection.getConnectionToDB("LMS");
		String stmt = "";
		stmt = RakeShiftingStatements.SELECT_ACTIVE_TRANSPORTERS;
		/*
		 * if(Transporters>0){ stmt=stmt+" and CustomerId="+Transporters; }
		 */
		stmt = stmt
		+ " and CustomerType like '%Transporters%' order by CustomerName";
		pstmt = con.prepareStatement(stmt);
		pstmt.setInt(1, systemid);
		pstmt.setInt(2, clientId);

		rs = pstmt.executeQuery();

		while (rs.next()) {
			JSONObject obj1 = new JSONObject();
			obj1 = new JSONObject();
			obj1.put("Transportersid", rs.getString("CustomerId"));
			obj1.put("Transportersname", rs.getString("CustomerName"));
			jsonArray.put(obj1);
		}

	} catch (Exception e) {
		e.printStackTrace();
	} finally {
		DBConnection.releaseConnectionToDB(con, pstmt, rs);
	}
	return jsonArray;
	}
	
	public JSONArray getBillingCustomer(int systemId, int custId, int userId) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		JSONArray jsArr = new JSONArray();
		JSONObject jsObj = null;
		
		try {
			con = DBConnection.getConnectionToDB("LMS");
			pstmt = con.prepareStatement(RakeShiftingStatements.GET_BILLING_CUSTOMER_LIST);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, custId);
		
			rs = pstmt.executeQuery();

			while(rs.next()) {
				jsObj = new JSONObject();
				jsObj.put("BillingCustomerId", rs.getString("customerId"));
				jsObj.put("BillingCustomerName", rs.getString("customerName"));
				jsArr.put(jsObj);
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
            DBConnection.releaseConnectionToDB(con, pstmt, rs);
        }
		return jsArr;
	}
	public String addModifyContainerDetails(String completejsonData,String jsonData, int systemId,	int clientId, int userId, String bookingId,String bookingType) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String message = "";
		JSONArray jsonArray = null;
		JSONArray CompletejsonArray = null;

		try {
			con = DBConnection.getConnectionToDB("LMS");
			String slno = "";
			String containerNo = "";
			String size = "";
			String loadType = "";
			String location = "";
			String shipperName = "";
			String billingCustomer = "";
			String weight = "";
			String sbblNo = "";
			String remarks = "";
			int inserted = 0;
			String uid = "";
			if (jsonData != null) {
				String st = "[" + jsonData + "]";
				jsonArray = new JSONArray(st.toString());
			}
			if (completejsonData != null) {
				String st1 = "[" + completejsonData + "]";
				CompletejsonArray = new JSONArray(st1.toString());
			}
			String[] containerNu = new String[ CompletejsonArray.length()] ;
			for (int i1 = 0; i1 < CompletejsonArray.length(); i1++) {
				JSONObject obj1 = CompletejsonArray.getJSONObject(i1);
				String cc =  obj1.getString("ContainerNoIndex");
				containerNu[i1] = cc;
			}
			
			if(bookingType.equalsIgnoreCase("1")){
				if(checkDuplicated_withSet(containerNu)){
					message = "Duplicate Container number not allowed";
					return message ;
				}
				}
			for (int i = 0; i < jsonArray.length(); i++) {
				JSONObject obj = jsonArray.getJSONObject(i);
				slno = obj.getString("slnoIndex");
				uid = obj.getString("uidIndex");
				containerNo = obj.getString("ContainerNoIndex");
				size = obj.getString("sizeIndex");
				loadType = obj.getString("loadTypeIndex");
				location = obj.getString("locationIndex");
				shipperName = obj.getString("shipperNameIndex");
				billingCustomer = obj.getString("billingCustIndex");
				weight = obj.getString("weightIndex");
				sbblNo = obj.getString("sbblNoIndex");
				remarks = obj.getString("remarksIndex");
				
				if(weight.equals("") || weight==null){
					weight="0";
				}
				if (slno.contains("new")) {
					pstmt = con.prepareStatement(RakeShiftingStatements.INSERT_CONTAINER_DETAILS);
					pstmt.setInt(1, systemId);
					pstmt.setInt(2, clientId);
					pstmt.setInt(3, Integer.parseInt(bookingId));
					pstmt.setString(4, containerNo);
					pstmt.setString(5, size);
					pstmt.setInt(6, Integer.parseInt(loadType));
					pstmt.setString(7, location);
					pstmt.setString(8, shipperName);
					pstmt.setString(9, billingCustomer);
					pstmt.setDouble(10, Double.parseDouble(weight));
					pstmt.setString(11, sbblNo);
					pstmt.setString(12, remarks);
					pstmt.setInt(13, userId);
					inserted = pstmt.executeUpdate();
				} else {
					pstmt = con.prepareStatement(RakeShiftingStatements.UPDATE_CONTAINER_DETAILS);
					pstmt.setString(1, containerNo);
					pstmt.setString(2, size);
					pstmt.setInt(3, Integer.parseInt(loadType));
					pstmt.setString(4, location);
					pstmt.setString(5, shipperName);
					pstmt.setString(6, billingCustomer);
					pstmt.setDouble(7, Double.parseDouble(weight));
					pstmt.setString(8, sbblNo);
					pstmt.setString(9, remarks);
					pstmt.setInt(10, userId);
					pstmt.setInt(11, systemId);
					pstmt.setInt(12, clientId);
					pstmt.setInt(13, Integer.parseInt(uid));
					inserted = pstmt.executeUpdate();
				}
			}
			if (inserted > 0) {
				message = "Saved Successfully";
			}
		} catch (Exception e) {
			System.out.println("error in:-save Rake Shift Booking Add Details "
					+ e.toString());
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return message;
	}
	
	private static boolean checkDuplicated_withSet(String[] sValueTemp)
			{
		for (int i = 0; i < sValueTemp.length; i++) {
			String sValueToCheck = sValueTemp[i];
			if(sValueToCheck==null || sValueToCheck.equals(""))continue; //empty ignore
			for (int j = 0; j < sValueTemp.length; j++) {
					if(i==j)continue; //same line ignore
					String sValueToCompare = sValueTemp[j];
					if (sValueToCheck.equals(sValueToCompare)){
							return true;
					}
			}
			}
		return false;
			}
			
		
	//	for (int i = 0; i < names.length; i++) { for (int j = i + 1 ; j < names.length; j++) { if (names[i].equals(names[j])) { // got the duplicate element } } }

		
//			for(String tempValueSet : sValueTemp)
//			{
//				Set sValueSet = new HashSet();
//				if (sValueSet.contains(tempValueSet))
//					return true;
//				else
//					if(!tempValueSet.equals(""))
//						sValueSet.add(tempValueSet);
//			}
//			return false;
//			}
		

	public JSONArray getContainerDetails(String bookingId, int systemId, int clientId) {
		JSONArray JsonArray = new JSONArray();
		JSONObject JsonObject = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			int count = 0;
			con = DBConnection.getConnectionToDB("LMS");
			pstmt = con.prepareStatement(RakeShiftingStatements.GET_CONTAINER_DETAILS);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, clientId);
			pstmt.setInt(3, Integer.parseInt(bookingId));
			rs = pstmt.executeQuery();
			while (rs.next()) {
				JsonObject = new JSONObject();
				count++;
				JsonObject.put("slnoIndex", count);
				JsonObject.put("uidIndex", rs.getString("UID"));
				JsonObject.put("AllocatedIndex", rs.getString("ALLOCATED"));
				JsonObject.put("ContainerNoIndex", rs.getString("containerNo"));
				JsonObject.put("sizeIndex", rs.getString("containerSize"));
				JsonObject.put("loadTypeIndex", rs.getString("LOAD_TYPE"));
				JsonObject.put("locationIndex", rs.getString("LOCATION"));
				JsonObject.put("shipperNameIndex", rs.getString("SHIPPING_NAME"));
				JsonObject.put("billingCustIndex", rs.getString("BILLING_CUSTOMER"));
				JsonObject.put("weightIndex", rs.getString("WEIGHT"));
				JsonObject.put("sbblNoIndex", rs.getString("SB_BL_NO"));
				JsonObject.put("remarksIndex", rs.getString("REMARKS"));
				JsonObject.put("statusIndex", rs.getString("STATUS"));
				JsonArray.put(JsonObject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return JsonArray;
	}

	public JSONArray getApproveDetails(int systemId, int clientId,String Branch) {
		SimpleDateFormat sdfyyyymmddhhmmss=new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
		DecimalFormat df=new DecimalFormat("##.##");
		SimpleDateFormat simpleDateFormatddMMYYYYDB = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		JSONArray JsonArray = new JSONArray();
		JSONObject JsonObject = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			int count = 0;
			String loadType="";
			con = DBConnection.getConnectionToDB("LMS");
			pstmt = con.prepareStatement(RakeShiftingStatements.GET_APPROVE_DETAILS);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, clientId);
			pstmt.setString(3, Branch);
			rs = pstmt.executeQuery();
			
			while (rs.next()) {
				JsonObject = new JSONObject();
				
				if(rs.getInt("LOAD_TYPE")==1){
					loadType="Loaded";
				} else{
					loadType="Empty";
				}
				count++;
				JsonObject.put("uidIndex", rs.getString("UID"));
				JsonObject.put("slnoIndex", count);
				JsonObject.put("containerNoIndex", rs.getString("CONTAINER_NO"));
				JsonObject.put("sizeIndex", rs.getString("CONTAINER_SIZE"));
				JsonObject.put("loadTypeIndex", loadType);
				JsonObject.put("locationIndex", rs.getString("LOCATION"));
				JsonObject.put("shipperNameIndex", rs.getString("SHIPPING_NAME"));
				JsonObject.put("billingCustomerIndex", rs.getString("BILLING_CUSTOMER"));
				JsonObject.put("weightIndex", rs.getString("WEIGHT"));
				JsonObject.put("sbblNoIndex", rs.getString("SB_BL_NO"));
				JsonObject.put("bookingNoIndex", rs.getString("BOOKING_ID"));
				if(!rs.getString("BOOKING_DATE").contains("1900")){
					JsonObject.put("bookingDateIndex", sdfyyyymmddhhmmss.format(simpleDateFormatddMMYYYYDB.parse(rs.getString("BOOKING_DATE"))));
	    			}else{
	    				JsonObject.put("createdDateIndex", "");
					}
				JsonArray.put(JsonObject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return JsonArray;
	}
	
	public String approveContainerDetails(String jsonData, int systemId,int clientId, int userId,String status) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String message = "";
		JSONArray jsonArray = null;

		try {
			con = DBConnection.getConnectionToDB("LMS");
			String containerNo = "";
			int inserted = 0;
			String uid = "";
			String bookingId="";
			if (jsonData != null) {
				String st = "[" + jsonData + "]";
				jsonArray = new JSONArray(st.toString());
			}
			for (int i = 0; i < jsonArray.length(); i++) {
				JSONObject obj = jsonArray.getJSONObject(i);
				uid = obj.getString("uidIndex");
				containerNo = obj.getString("containerNoIndex");
				bookingId = obj.getString("bookingNoIndex");
					
					pstmt = con.prepareStatement(RakeShiftingStatements.UPDATE_CONTAINER_INFO_STATUS);
					pstmt.setString(1, status);
					pstmt.setInt(2, userId);
					pstmt.setInt(3, systemId);
					pstmt.setInt(4, clientId);
					pstmt.setInt(5, Integer.parseInt(uid));
					
					inserted = pstmt.executeUpdate();
			}
			if (inserted > 0) {
				message = "Updated Successfully";
			}
		} catch (Exception e) {
			System.out.println("error in:-save Rake Shift Approving/Cancelling "
					+ e.toString());
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return message;
	}
	public JSONArray getVendorDetailsForAllocateFuel(int systemId, int custId) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		JSONArray jsArr = new JSONArray();
		JSONObject jsObj = null;
		
		try {
			con = DBConnection.getConnectionToDB("LMS");
			pstmt = con.prepareStatement(RakeShiftingStatements.GET_VENDOR_NAMES_FOR_ALLOCATE_FUEL);
			pstmt.setInt(1, custId);
			pstmt.setInt(2, systemId);
			rs = pstmt.executeQuery();

			while(rs.next()) {
				jsObj = new JSONObject();
				jsObj.put("vendorid", rs.getString(1));
				jsObj.put("vendorname", rs.getString(2));
				jsObj.put("priceperlit", rs.getString(3));
				jsArr.put(jsObj);
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
            DBConnection.releaseConnectionToDB(con, pstmt, rs);
        }
		return jsArr;
	}
	public JSONArray getActiveVendorDetailsForAllocateFuel(int systemId, int custId) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		JSONArray jsArr = new JSONArray();
		JSONObject jsObj = null;
		
		try {
			con = DBConnection.getConnectionToDB("LMS");
			pstmt = con.prepareStatement(RakeShiftingStatements.GET_ACTIVE_VENDOR_NAMES_FOR_ALLOCATE_FUEL);
			pstmt.setInt(1, custId);
			pstmt.setInt(2, systemId);
			rs = pstmt.executeQuery();

			while(rs.next()) {
				jsObj = new JSONObject();
				jsObj.put("vendorid", rs.getString(1));
				jsObj.put("vendorname", rs.getString(2));
				jsObj.put("priceperlit", rs.getString(3));
				jsArr.put(jsObj);
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
            DBConnection.releaseConnectionToDB(con, pstmt, rs);
        }
		return jsArr;
	}
		public JSONArray getInnerGridTripApprovalDetails(int systemid, int custId,int uniqueId)
	{
		SimpleDateFormat sdfyyyymmddhhmmss=new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
		SimpleDateFormat simpleDateFormatddMMYYYYDB = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
    	Connection con = null;
    	PreparedStatement pstmt = null;
    	ResultSet rs = null;
    	JSONArray jsArr = new JSONArray();
    	JSONObject obj = new JSONObject();
    	int slcount = 0; 
    	
    	try
    	{ 
    		
    			con = DBConnection.getConnectionToDB("LMS");
    			pstmt = con.prepareStatement(RakeShiftingStatements.GET_TRIP_APPROVAL_DETAILS);
    			pstmt.setInt(1, systemid);
	    		pstmt.setInt(2, custId);
	    		pstmt.setInt(3,uniqueId);
	    		
	    		
	    		rs = pstmt.executeQuery();
    		
	    		while (rs.next()) 
	    		{
	    			obj = new JSONObject();
	    			ArrayList<Object> informationList=new ArrayList<Object>();
	    			slcount++;
	    			
	    			obj.put("innerslnoIndex", slcount);
	    			
	    			obj.put("innerUniqueIdIndex",rs.getInt("UID"));
	    			
	    			obj.put("innerbookingNoIndex", rs.getString("BOOKING_NO"));
	    			
	    			if(!rs.getString("BOOKING_DATE").contains("1900")) 
	    			{
	    				obj.put("innerbookingDateIndex", sdfyyyymmddhhmmss.format(simpleDateFormatddMMYYYYDB.parse(rs.getString("BOOKING_DATE"))));
	    			}
	    			else
	    			{
						obj.put("innerbookingDateIndex", "");
					}
	    			
	    			obj.put("innercontainerNoIndex", rs.getString("CONTAINER_NO"));
	    			
	    			obj.put("sizeIndex", rs.getString("SIZE"));
	    			
	    			String loadType="";
	    			if(rs.getInt("LOAD_TYPE")==1)
	    			{
	    				loadType="Loaded";
	    			}
	    			else if(rs.getInt("LOAD_TYPE")==2)
	    			{
	    				loadType="Empty";
	    			}
	    			
	    			obj.put("innerloadtypeIndex", loadType);
	    			
	    			obj.put("locationIndex", rs.getString("LOCATION"));
	    			
	    			obj.put("shippingnameIndex", rs.getString("SHIPPING_NAME"));
	    			
	    			obj.put("billingcustomerIndex", rs.getString("BILLING_CUSTOMER"));
	    			
	    			obj.put("weightIndex", rs.getInt("WEIGHT"));
	    			
	    			obj.put("sbblnoIndex", rs.getString("SB_BL_NO"));
	    			
	    			obj.put("fuelLtrsIndex", rs.getInt("FUEL_LTRS"));
	    			
	    			obj.put("fuelAmtIndex", rs.getInt("FUEL_AMT"));
	    			
	    			obj.put("incentivesIndex", rs.getInt("INCENTIVE"));
	    			
	    			jsArr.put(obj);
    			
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
    		return jsArr;
	}
	
	public String allocateOrCancelTripDetails(String jsonData, int systemId,int clientId, int userId,String allocated,String uniqueId) {
        Connection con = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String message = "";
        JSONArray jsonArray = null;

        try {
            con = DBConnection.getConnectionToDB("LMS");
            int inserted = 0;
            String uid = "";
          
            if (jsonData != null) {
                String st = "[" + jsonData + "]";
                jsonArray = new JSONArray(st.toString());
            }
            for (int i = 0; i < jsonArray.length(); i++) {
                JSONObject obj = jsonArray.getJSONObject(i);
                uid = obj.getString("innerUniqueIdIndex");
                
                    
                    pstmt = con.prepareStatement(RakeShiftingStatements.UPDATE_TRIP_ALLOCATION_DETAILS);
                    pstmt.setString(1, allocated);
                    pstmt.setInt(2, Integer.parseInt(uniqueId));
                    pstmt.setInt(3, systemId);
                    pstmt.setInt(4, clientId);
                    pstmt.setInt(5, Integer.parseInt(uid));
                    
                    inserted = pstmt.executeUpdate();
            }
            if (inserted > 0) {
                message = "Updated Successfully";
            }
        } catch (Exception e) {
            System.out.println("error in:-save Rake Shift Approving/Cancelling "
                    + e.toString());
            e.printStackTrace();
        } finally {
            DBConnection.releaseConnectionToDB(con, pstmt, rs);
        }
        return message;
    }
	public JSONArray getAllocationDetails(int systemid, int custId,int uid)
	{
		SimpleDateFormat sdfyyyymmddhhmmss=new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
		SimpleDateFormat simpleDateFormatddMMYYYYDB = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
    	Connection con = null;
    	PreparedStatement pstmt = null;
    	ResultSet rs = null;
    	JSONArray jsArr = new JSONArray();
    	JSONObject obj = new JSONObject();
    	int slcount = 0; 
    	
    	try
    	{ 
    		
    			con = DBConnection.getConnectionToDB("LMS");
    			pstmt = con.prepareStatement(RakeShiftingStatements.GET_ALLOCATED_TRIP_DETAILS);
    			pstmt.setInt(1, systemid);
	    		pstmt.setInt(2, custId);
	    		pstmt.setInt(3, uid);
	    		
	    		rs = pstmt.executeQuery();
    		
	    		while (rs.next()) 
	    		{
	    			obj = new JSONObject();
	    			slcount++;
	    			
	    			obj.put("viewContainerSnoIndex", slcount);
	    			
	    			obj.put("viewContainerUniqueIdIndex",rs.getString("UID"));
	    			
	    			obj.put("viewContainerbookingIdIndex", rs.getString("BOOKING_ID"));
	    			
	    			obj.put("viewContainerbookingDateIndex", rs.getString("BOOKING_DATE"));
	    			
	    			obj.put("viewContainerContainerNoIndex", rs.getString("CONTAINER_NO"));
	    			
	    			obj.put("viewContainerSizeIndex",rs.getString("SIZE"));
	    			
	    			obj.put("viewContainerLoadTypeIndex", rs.getString("LOAD_TYPE"));
	    			
	    			obj.put("viewContainerLocationIndex", rs.getString("LOCATION"));
	    			
	    			obj.put("viewContainerShippingIndex", rs.getString("SHIPPING_NAME"));
	    			
	    			obj.put("viewContainerBillingCustIndex", rs.getString("BILLING_CUSTOMER"));
	    			
	    			obj.put("viewContainerWeightIndex", rs.getString("WEIGHT"));
	    				    			
	    			obj.put("viewContainersbblnoIndex", rs.getString("SB_BL_NO"));
	    			
	    			obj.put("viewContainerAllocatedIndex", rs.getString("ALLOCATED"));
	    			
	    			obj.put("viewContainerTripNoIndex", rs.getString("TRIP_NO"));
	    			
	    			jsArr.put(obj);
    			
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
    		return jsArr;
	}
	
	public String addAdditionalCash(double additionalAmt,int systemId,int customerId,int uniqueId)
	{
		
		Connection con = null;
		PreparedStatement pstmt= null;
		ResultSet rs = null;
		String message="";
		try
		{
			 con = DBConnection.getConnectionToDB("LMS");
			 pstmt = con.prepareStatement(RakeShiftingStatements.ADD_ADDITIONAL_AMOUNT);
			 pstmt.setDouble(1, additionalAmt);
			 pstmt.setInt(2, uniqueId);
			 pstmt.setInt(3, systemId);
			 pstmt.setInt(4, customerId);
			 
			 int updated = pstmt.executeUpdate();
			 if (updated > 0) 
			 {
                  message = "Amount Added Successfully";
             }
		}
		catch(Exception e)
		{
			System.out.println("error in:-save RouteMaster details "+e.toString());
			e.printStackTrace();
		}
		finally
		{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return message;
	}
	public String addAdditionalFuelAndFuelAmount(double addtnalFuel,double addtnalFuelAmt,int systemId, int customerId,int uniqueId)
	{
		
		Connection con = null;
		PreparedStatement pstmt= null;
		ResultSet rs = null;
		String message="";
		try
		{
			 con = DBConnection.getConnectionToDB("LMS");
			 pstmt = con.prepareStatement(RakeShiftingStatements.ADD_ADDITIONAL_FUEL_AND_AMOUNT);
			 pstmt.setDouble(1, addtnalFuel);
			 pstmt.setDouble(2,addtnalFuelAmt);
			 pstmt.setInt(3, uniqueId);
			 pstmt.setInt(4, systemId);
			 pstmt.setInt(5, customerId);
			 
			 int updated = pstmt.executeUpdate();
			 if (updated > 0) 
			 {
                  message = "Fuel and Amt added Successfully";
             }
		}
		catch(Exception e)
		{
			System.out.println("error in:-save RouteMaster details "+e.toString());
			e.printStackTrace();
		}
		finally
		{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		
		return message;
	}
	public String closeRakeShiftTripDetails(int uniqueid, int clientId, int systemId, String status) {
	    Connection con = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
	    String message = "";
	    JSONArray jsonArray = null;
	    int inserted = 0;
	    
	    try {
	        con = DBConnection.getConnectionToDB("LMS");
	        
	        pstmt = con.prepareStatement(RakeShiftingStatements.UPDATE_RAKE_SHIFT_TRIP_STATUS);
	        pstmt.setString(1, status);
	        pstmt.setInt(2, systemId);
	        pstmt.setInt(3, clientId);
	        pstmt.setInt(4, uniqueid);
	                
	        inserted = pstmt.executeUpdate();
	        if (inserted > 0) {
	            message = "Updated Successfully";
	        }else{
	            message = "Error";
	        }
	    }catch (Exception e) {
	        e.printStackTrace();
	        message = "error";
	    }  finally {
	        DBConnection.releaseConnectionToDB(con, pstmt, rs);
	    }
	    return message;
	}
	public JSONArray getActiveBillingCustStore(int systemId, int clientId) {
	    Connection con = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
	    JSONArray jsonArray = new JSONArray();
	    JSONObject obj = null;
	    try {
	        con = DBConnection.getConnectionToDB("LMS");
	        pstmt = con.prepareStatement(RakeShiftingStatements.GET_ACTIVE_BILLING_CUSTOMER);
	        pstmt.setInt(1, systemId);
	        pstmt.setInt(2, clientId);
	        rs = pstmt.executeQuery();
	        while(rs.next()){
	        	obj = new JSONObject();
	        	obj.put("BillingCustId", rs.getInt("customerId"));
	        	obj.put("BillingCustName", rs.getString("customerName"));
	        	jsonArray.put(obj);
	        }
	    }catch (Exception e) {
	        e.printStackTrace();
	    }  finally {
	        DBConnection.releaseConnectionToDB(con, pstmt, rs);
	    }
	    return jsonArray;
	}
	public String saveImportedILMSDetails(int systemId,int customerId,String bookingId,int userId,ArrayList<RakeShiftDetails> allILMSImporteddetails,
			String bookingType) {
		
		Connection con = null;
		PreparedStatement pstmt=null;
		ResultSet rs = null;
		int loadType;
		int billingCustId=0;
		double weight = 0;
		String msg="Error"; 
		try {
			con = DBConnection.getConnectionToDB("AMS");	
			for (int i = 0; i < allILMSImporteddetails.size(); i++) {
			RakeShiftDetails iml= allILMSImporteddetails.get(i);
			if(iml.status1.equals("Valid")){
				if(!bookingType.equals("2")){
					pstmt = con.prepareStatement("select isnull(CustomerId,0) as customerId,isnull(CustomerName,'') as customerName from LMS.dbo.Customer_Information where SystemId=? and ClientId=? and customerName=? and STATUS='Active'");
					pstmt.setInt(1, systemId);
					pstmt.setInt(2, customerId);
					pstmt.setString(3, iml.billingCustomer);
					rs=pstmt.executeQuery();
					if(rs.next())
					{
						billingCustId=rs.getInt("customerId");
					}
				}
				
				pstmt = con.prepareStatement(RakeShiftingStatements.INSERT_RAKE_SHIFT_IMPORT_DETAILS);
				
				if(iml.loadType.equalsIgnoreCase("Empty"))
				{
					loadType=1;
				}
				else{
					loadType=2;
				}
				if(iml.weight!=null && !iml.weight.equals(""))
				{
					weight = Double.parseDouble(iml.weight);
				}
				
				pstmt.setInt(1, systemId);
				pstmt.setInt(2, customerId);
				pstmt.setInt(3, Integer.parseInt(bookingId));
				pstmt.setString(4, iml.containerNo);
				pstmt.setString(5,iml.ContainerSize);
				pstmt.setInt(6,loadType);
				pstmt.setString(7,iml.location);
				pstmt.setString(8,iml.shipperName);
				pstmt.setInt(9,billingCustId);
				pstmt.setDouble(10,weight);
				pstmt.setString(11,iml.sb_blNo);
				pstmt.setInt(12,userId);
				pstmt.setString(13,iml.remarks);
				
				
				int p = pstmt.executeUpdate();
				if (p > 0) {
					msg="Inserted Successfully..!!";
				}
			}
		}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, null);
		}
		return msg;
	}

	public JSONArray getOwnerName(String vehicleNo, int systemid, int clientid) {
		JSONArray jsonArray = new JSONArray();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String registerOwnerName="";
		
		try {
			con = DBConnection.getConnectionToDB("AMS");	
			pstmt = con.prepareStatement(RakeShiftingStatements.GET_MVNO1);		
			pstmt.setInt(1, clientid);
			pstmt.setInt(2, systemid);
			pstmt.setString(3, vehicleNo);
			rs = pstmt.executeQuery();
			JSONObject obj1 = new JSONObject();
			while (rs.next()) {
				obj1 = new JSONObject();
				registerOwnerName =rs.getString("RegOwnerName");
				obj1.put("RegNo", registerOwnerName);
				jsonArray.put(obj1);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jsonArray;
	}
}
