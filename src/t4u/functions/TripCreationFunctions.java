package t4u.functions;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.DateFormat;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;

import org.json.JSONArray;
import org.json.JSONObject;

import t4u.beans.ReportHelper;
import t4u.common.DBConnection;
import t4u.statements.TripCreationStatements;

import com.t4u.activity.VehicleActivity;
import com.t4u.activity.VehicleSummaryBean;


/**
 * @author santhosh
 *
 */

public class TripCreationFunctions {


	CommonFunctions cfuncs = new CommonFunctions();
	SimpleDateFormat sdfFormatDate = new SimpleDateFormat("MM/dd/yyyy HH:mm:ss");
	SimpleDateFormat sdfyyyymmddhhmmss=new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
	SimpleDateFormat sdfyyyymmdd=new SimpleDateFormat("dd-MM-yyyy");
	SimpleDateFormat sdfmmddyyyyhhmmss=new SimpleDateFormat("MM/dd/yyyy HH:mm:ss");
	SimpleDateFormat sdfddmmyyyy = new SimpleDateFormat("dd/MM/yyyy");
	SimpleDateFormat sdfmmddyyyy = new SimpleDateFormat("MM/dd/yyyy");
	SimpleDateFormat sfddMMYYYY = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
	CommonFunctions cf = new CommonFunctions();
	DecimalFormat doubleformat = new DecimalFormat("#.##");
	DecimalFormat singleformat = new DecimalFormat("#.#");		

	/** Get details for vehicle  
	 * @param customerid
	 * @param systemId
	 * @param userId
	 * @return
	 */
	public JSONArray getVehicleNoWithVendorName(String customerid, int systemId ,int userId,String StartDate) {

		JSONArray JsonArray = new JSONArray();
		JSONObject JsonObject = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;		 
		ResultSet rs = null;	
		try {
			JsonArray = new JSONArray();
			JsonObject = new JSONObject();

			con = DBConnection.getConnectionToDB("AMS");
			if (StartDate!=null && !StartDate.equals("")) {
				pstmt = con.prepareStatement(TripCreationStatements.GET_VEHILCE_NUMBER_FOR_TRIP_DETAILS_WITH_DATE);
				pstmt.setInt(1, systemId);
				pstmt.setInt(2, Integer.parseInt(customerid));
				pstmt.setInt(3, userId);
				pstmt.setInt(4, systemId);
				pstmt.setInt(5, Integer.parseInt(customerid));
				pstmt.setString(6, StartDate);
			} else {
				pstmt = con.prepareStatement(TripCreationStatements.GET_VEHILCE_NUMBER_FOR_TRIP_DETAILS);
				pstmt.setInt(1, systemId);
				pstmt.setInt(2, Integer.parseInt(customerid));
				pstmt.setInt(3, userId);
			}
			rs = pstmt.executeQuery();
			while(rs.next())
			{
				JsonObject = new JSONObject();
				JsonObject.put("Registration_No", rs.getString("REGISTRATION_NUMBER"));
				JsonObject.put("Vehicle_group", rs.getString("GROUP_NAME"));
				JsonObject.put("odoMeter", rs.getString("OPENING_ODOMETER"));
				JsonArray.put(JsonObject);
			}

		}catch(Exception e){
			e.printStackTrace();
		}finally{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}

		return JsonArray;
	}
	
	//------------------------------------------------get Trip status------------------------------------//
	/** Get details for Trip status of Vehicle
	 * @param customerid
	 * @param systemId
	 * @param type
	 * @return 
	 */

	public JSONArray getTripStatus(String customerid,int systemId,String type){
		JSONArray JsonArray = new JSONArray();
		JSONObject JsonObject = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;		
		ResultSet rs = null;
		try{
			JsonArray = new JSONArray();
			JsonObject = new JSONObject();

			con = DBConnection.getConnectionToDB("AMS");		
			pstmt=con.prepareStatement(TripCreationStatements.GET_TRIP_STATUS_DETAILS);
			pstmt.setString(1,type);
			rs=pstmt.executeQuery();
			while(rs.next())
			{
				JsonObject = new JSONObject();
				JsonObject.put("tripStatusId", rs.getString("VALUE"));
				JsonArray.put(JsonObject);
			}

		}catch(Exception e){
			e.printStackTrace();
		}finally{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return JsonArray;

	}
	//------------------------------------------------get reasons for vehicle status--------------------------//
	/** Get details for Reason of Vehicle
	 * @param customerid
	 * @param systemId
	 * @param type
	 * @return 
	 */

	public JSONArray getReasonOffRouteRoadStatus(String customerid,int systemId,String type){
		JSONArray JsonArray = new JSONArray();
		JSONObject JsonObject = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;		
		ResultSet rs = null;
		try{
			JsonArray = new JSONArray();
			JsonObject = new JSONObject();
			con = DBConnection.getConnectionToDB("AMS");		
			pstmt=con.prepareStatement(TripCreationStatements.GET_REASON_OFF_ROUTE_ROAD_DETAILS);
			pstmt.setString(1,type);
			rs=pstmt.executeQuery();
			while(rs.next())
			{
				JsonObject = new JSONObject();
				JsonObject.put("reasonId", rs.getString("VALUE"));
				JsonArray.put(JsonObject);
			}

		}catch(Exception e){
			e.printStackTrace();
		}finally{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return JsonArray;

	}

	//---------------------------------------------------Insert Details--------------------------------//
	/** Saving Trip Information 
	 * @param customerId
	 * @param systemId	
	 * @param ownerName(Vendor Name)
	 * @param startDateTime
	 * @param startLocation
	 * @param endLocation
	 * @param vehicleNumber
	 * @return 
	 */

	public String saveTripInformation(String ownVehicle,String MarketVehicle,String customerId,String startDateTime,String state,String location,String vehicleNumber,String tripStatusId,
			String reason,double openingOdo,String hiredVehicleNo,String hiredAmount,String hiredVehicleKMS,int systemId,int offset,String startTime,double marketVehicleAmount,double marketVehiclekms){

		String message="";
		Connection conAdmin = null;
		PreparedStatement pstmt = null;
		ResultSet rs=null;
		boolean flag = true;
		SimpleDateFormat sdfFormatDate = new SimpleDateFormat("MM/dd/yyyy HH:mm:ss");
		try{
			conAdmin = DBConnection.getConnectionToDB("AMS");
			if (ownVehicle.equals("true")) {
				int inserted=0;
				pstmt=conAdmin.prepareStatement(TripCreationStatements.GET_ASSET_NUMBER_TIME_VALIDATE);
				pstmt.setString(1,vehicleNumber);
				pstmt.setString(2,startDateTime);
				rs=pstmt.executeQuery();
				if(rs.next())
				{  
					flag = false;
					message = "<p>Already Trip created for this Asset number. Try some other Asset Number.</p>";
					return (message);
				}

				pstmt=conAdmin.prepareStatement(TripCreationStatements.GET_TIME_VALIDATE);
				pstmt.setInt(1,offset);
				pstmt.setString(2,vehicleNumber);
				pstmt.setInt(3,systemId);
				pstmt.setString(4,customerId);
				rs=pstmt.executeQuery();
				Date prevDate = null;
				if(rs.next())
				{   
					String AssetNo=rs.getString("ASSET_NUMBER");
					int id=rs.getInt("ID");
					prevDate=rs.getTimestamp("TRIP_START_TIME");
					String tripEndDate=sdfFormatDate.format(prevDate);
					double createdOdo=rs.getDouble("OPENING_ODOMETER");
					Date current = sdfFormatDate.parse(startDateTime);
					if(current.before(prevDate)){
						flag = false;
						message = "<p>Please select Valid date ,Back date is not allowed...</p>";
						return (message);
					}else if(current.after(prevDate)|| current.equals(prevDate)){
						if(!startDateTime.equals(tripEndDate)&& AssetNo.equals(vehicleNumber)){
							if (createdOdo > openingOdo) {
								flag = false;
								message = "<p>Opening Odometer should be greater than previous Odometer..</p>";
								return (message);
							}else{ 
								String msg = closeTrip(conAdmin,customerId,systemId,tripEndDate,startTime,vehicleNumber,offset,openingOdo,id,startDateTime);
								if (msg.equals("Error")) {
									flag = false;
								}
								flag = true;
							}
						}
					}
				}
				if (flag) {
					pstmt=conAdmin.prepareStatement(TripCreationStatements.SAVE_TRIP_INFORMATION);
					pstmt.setString(1,startDateTime);
					pstmt.setString(2,state);
					pstmt.setString(3,location);
					pstmt.setString(4,vehicleNumber);
					pstmt.setString(5,tripStatusId);
					pstmt.setDouble(6,openingOdo);
					pstmt.setString(7,reason);
					if (hiredAmount!=null && !hiredAmount.equals("") ||hiredVehicleKMS!=null && !hiredVehicleKMS.equals("")) {
						pstmt.setString(8,hiredVehicleNo);
						pstmt.setDouble(9,Double.parseDouble(hiredAmount));
						pstmt.setDouble(10,Double.parseDouble(hiredVehicleKMS));
					} else {
						pstmt.setString(8,hiredVehicleNo);
						pstmt.setDouble(9,0.0);
						pstmt.setDouble(10,0.0);
					}
					pstmt.setInt(11,systemId);
					pstmt.setString(12,customerId);
					inserted=pstmt.executeUpdate();
					conAdmin.commit();
					if(inserted>0)
					{
						message="Trip Details Saved Successfully";
					}else{
						message="Error in Saving Trip Details";
					}
				}	
			} else if(MarketVehicle.equals("true")){
				int insertedMarket=0;
				pstmt=conAdmin.prepareStatement(TripCreationStatements.GET_MARKET_ASSET_NUMBER_EXISTS);
				pstmt.setString(1,hiredVehicleNo);
				pstmt.setString(2,startDateTime);
				rs=pstmt.executeQuery();
				if(rs.next())
				{  
					flag = false;
					message = "<p>Already Trip created for this Asset number. Try some other Asset Number.</p>";
					return (message);
				}
				pstmt=conAdmin.prepareStatement(TripCreationStatements.GET_MARKET_TIME_VALIDATE);
				pstmt.setInt(1,offset);
				pstmt.setString(2,hiredVehicleNo);
				pstmt.setInt(3,systemId);
				pstmt.setString(4,customerId);
				rs=pstmt.executeQuery();
				Date MprevDate = null;
				if(rs.next())
				{   
					String AssetNo=rs.getString("ASSET_NUMBER");
					int id=rs.getInt("ID");
					MprevDate=rs.getTimestamp("TRIP_START_TIME");
					String tripEndDate=sdfFormatDate.format(MprevDate);
					double McreatedOdo=rs.getDouble("OPENING_ODOMETER");
					Date current = sdfFormatDate.parse(startDateTime);
					if(current.before(MprevDate)){
						flag = false;
						message = "<p>Please select Valid date ,Back date is not allowed...</p>";
						return (message);
					}else if(current.after(MprevDate)|| current.equals(MprevDate)){
						if(!startDateTime.equals(tripEndDate)&& AssetNo.equals(hiredVehicleNo)){
							if (McreatedOdo > marketVehiclekms) {
								flag = false;
								message = "<p>Opening Odometer should be greater than previous Odometer..</p>";
								return (message);
							}else{ 
								String msg = MarketTripClose(conAdmin,customerId,systemId,McreatedOdo,vehicleNumber,offset,marketVehiclekms,id,startDateTime);
								if (msg.equals("Error")) {
									flag = false;
								}
								flag = true;
							}
						}
					}
				}
				if (flag) {
					pstmt=conAdmin.prepareStatement(TripCreationStatements.SAVE_MARKET_TRIP_INFORMATION);
					pstmt.setString(1,startDateTime);
					pstmt.setString(2,state);
					pstmt.setString(3,location);
					pstmt.setString(4,hiredVehicleNo);
					pstmt.setDouble(5,marketVehicleAmount);
					pstmt.setDouble(6,marketVehiclekms);
					pstmt.setInt(7,systemId);
					pstmt.setString(8,customerId);
					insertedMarket=pstmt.executeUpdate();
					if(insertedMarket>0)
					{
						message="Market Trip Details Saved Successfully";
					}else{
						message="Error in Saving Market Trip Details";
					}
				}
			}
			
		}catch(Exception e){
			System.out.println("error in TripCreationFunction:-save trip details "+e.toString());
			e.printStackTrace();
		}finally{
			DBConnection.releaseConnectionToDB(conAdmin, pstmt, rs);
		}
		return message;
	}
	//------------------------------------------closing trip details--------------------------------//
	/**
	 * Close Trip Information
	 * @param SystemId
	 * @param CustId	
	 * @param uniqueId
	 * @param startDate
	 * @param endDate
	 * @param regNo
	 * @param offset
	 * @return
	 */


	public String closeTrip(Connection conAdmin,String customerId,int systemId,String startDate
			,String endDate,String regNo,int offset,double openingOdo,int id,String startDateTime){

		String message="";
		PreparedStatement pstmt=null;
		int closed=0;

		try{
			Date sdt=cf.convertStringToDate(startDate);
			Date edt=cf.convertStringToDate(endDate);
			Date startdate=(Date)sdfFormatDate.parse(sdfFormatDate.format(sdt));
			Date enddate=(Date)sdfFormatDate.parse(sdfFormatDate.format(edt));

			VehicleActivity vi = new VehicleActivity(conAdmin,regNo,startdate,enddate,offset, systemId, Integer.parseInt(customerId), 0);
			VehicleSummaryBean vsb = vi.getVehicleSummaryBean();
			double distanceTravelled=vsb.getTotalDistanceTravelled();

			double totalDistace=distanceTravelled*(cfuncs.initializedistanceConversionFactor(systemId, conAdmin, regNo));
			if(totalDistace == 0)
			{
				totalDistace=0;
			}
			pstmt=conAdmin.prepareStatement(TripCreationStatements.CLOSE_TRIP_DETAILS);
			pstmt.setString(1, startDateTime);
			pstmt.setFloat(2, (float) totalDistace);
			pstmt.setDouble(3,openingOdo);
			pstmt.setInt(4, systemId);
			pstmt.setInt(5, Integer.parseInt(customerId));
			pstmt.setInt(6, id);			
			closed=pstmt.executeUpdate();
			if(closed>0)
			{
				message="Trip Closed Successfully";
			}
		}catch(Exception e){
			message="Error";
			e.printStackTrace();
			System.out.println("Error In closeTripInformation ---- "+e.toString());
		}
		return message;
	}
	//---------------------------------------------market Trip Closed---------------------------------------//
	public String MarketTripClose(Connection conAdmin,String customerId,int systemId,double mcreatedOdo,String regNo,int offset,double openingOdo,int id,String startDateTime){
		String message="";
		PreparedStatement pstmt=null;
		int closed=0;
		try{
			//double marketTotalDistace=(openingOdo-mcreatedOdo);
			//double MtotalDistace=marketTotalDistace*(cfuncs.initializedistanceConversionFactor(systemId, conAdmin, regNo));
			//if(MtotalDistace == 0)
			//{
			//	MtotalDistace=0;
			//}
			pstmt=conAdmin.prepareStatement(TripCreationStatements.MARKET_CLOSE_TRIP_DETAILS);
			pstmt.setString(1, startDateTime);
			pstmt.setFloat(2, 0);
			pstmt.setDouble(3,openingOdo);
			pstmt.setInt(4, systemId);
			pstmt.setInt(5, Integer.parseInt(customerId));
			pstmt.setInt(6, id);			
			closed=pstmt.executeUpdate();
			if(closed>0)
			{
				message="Market Trip Closed Successfully";
			}
		}catch(Exception e){
			message="Error";
			e.printStackTrace();
			System.out.println("Error In closeTripInformation ---- "+e.toString());
		}
		return message;
	}
	//----------------------------------------update Trip details----------------------------------------//
	/** Modifying Trip Information 
	 * @param customerId
	 * @param systemId	
	 * @param ownerName(Vendor Name)
	 * @param startDateTime
	 * @param startLocation
	 * @param endLocation
	 * @param vehicleNumber
	 * @param Zone
	 * @param uniqueId
	 * @param i 
	 * @return 
	 */


	public String modifyTripInformation(String ownVehicle,String marketVehicle,String customerId,String startDateTime,String stateModify,String stateModifyName,String location,String vehicleNumber,String statusIdModify,String statusNameModify,String reasonIdsModify,
			String ReasonNameModify,String openingOdo,String hiredVehicleNo,String hiredAmount,String hiredVehicleKMS,int systemId,int uniqueId,double marketVehicleAmount,double marketVehiclekms)
	{
		String message="";
		Connection conAdmin = null;
		PreparedStatement pstmt = null;
		try{
			conAdmin = DBConnection.getConnectionToDB("AMS");
			if(ownVehicle.equals("true")){
				int updated=0;
				pstmt=conAdmin.prepareStatement(TripCreationStatements.MODIFY_TRIP_INFORMATION);
				pstmt.setString(1,stateModify);
				pstmt.setString(2,location);
				pstmt.setString(3,statusNameModify);
				pstmt.setString(4,ReasonNameModify);
				pstmt.setString(5,hiredVehicleNo);
				pstmt.setString(6,hiredAmount);
				pstmt.setString(7,hiredVehicleKMS);
				pstmt.setInt(8,systemId);
				pstmt.setString(9,customerId);
				pstmt.setInt(10, uniqueId);
				updated=pstmt.executeUpdate();
				if(updated>0)
				{
					message="Trip Details Modified Successfully";
				}else{
					message="Modifying Trip Details is not possible for Status Close Vehicles";
				}
			}else if(marketVehicle.equals("true")){
				int updatedMarket=0;
				pstmt=conAdmin.prepareStatement(TripCreationStatements.MODIFY_MARKET_TRIP_INFORMATION);
				pstmt.setString(1,stateModify);
				pstmt.setString(2,location);
				pstmt.setString(3,hiredVehicleNo);
				pstmt.setDouble(4,marketVehicleAmount);
				pstmt.setDouble(5,marketVehiclekms);
				pstmt.setInt(6,systemId);
				pstmt.setString(7,customerId);
				pstmt.setInt(8, uniqueId);
				updatedMarket=pstmt.executeUpdate();
				if(updatedMarket>0)
				{
					message="Market Trip Details Modified Successfully";
				}else{
					message="Modifying Market Trip Details is not possible for Status Close Vehicles";
				}
			}
			

		}catch(Exception e){
			System.out.println("error in TripCreationFunction:-save trip details "+e.toString());
			e.printStackTrace();
		}finally{
			DBConnection.releaseConnectionToDB(conAdmin, pstmt, null);
		}
		return message;
	}
	//----------------------------------get trip details-------------------------------------------//
	public ArrayList<Object> getTripCreationDetails(String customerid,String startdate,String enddate,int systemId,int offset,String language) {
		JSONArray JsonArray = new JSONArray();
		JSONObject JsonObject = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int count=0;
		ArrayList<ReportHelper> reportsList = new ArrayList<ReportHelper>();
		ArrayList<String> headersList = new ArrayList<String>();
		ReportHelper finalreporthelper = new ReportHelper();
		ArrayList<Object> finlist = new ArrayList<Object>();
		try {
			headersList.add(cf.getLabelFromDB("SLNO", language));
			headersList.add(cf.getLabelFromDB("Start_Date",language));
			headersList.add(cf.getLabelFromDB("State_Name",language));	
			headersList.add(cf.getLabelFromDB("Location",language));	
			headersList.add(cf.getLabelFromDB("Asset_Number",language));	
			headersList.add(cf.getLabelFromDB("Trip_Status",language));	
			headersList.add(cf.getLabelFromDB("Reason_For_Off_Road/Route",language));
			headersList.add(cf.getLabelFromDB("Opening_KMS", language));
			headersList.add(cf.getLabelFromDB("Odometer_kms", language));
			headersList.add(cf.getLabelFromDB("GPS_KMS", language));
			headersList.add(cf.getLabelFromDB("Hired_Vehicle_Number", language));
			headersList.add(cf.getLabelFromDB("Hired_Amount", language));
			headersList.add(cf.getLabelFromDB("Hired_Vehicle_KMS", language));
			headersList.add(cf.getLabelFromDB("Status", language));

			JsonArray = new JSONArray();
			JsonObject = new JSONObject();
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(TripCreationStatements.GET_TRIP_CREATION_REPORT);
			pstmt.setInt(1,systemId);
			pstmt.setString(2,customerid);
			pstmt.setString(3,startdate);
			pstmt.setString(4,enddate); 
			rs = pstmt.executeQuery();
			while (rs.next()){
				JsonObject = new JSONObject();
				ArrayList<Object> informationList = new ArrayList<Object>();
				ReportHelper reporthelper = new ReportHelper();
				count++;				
				informationList.add(Integer.toString(count));
				JsonObject.put("slnoIndex", Integer.toString(count));

				String tripStartDateTimeT="";
				if(rs.getTimestamp("TRIP_START_TIME")!=null)
				{
					Date date=rs.getTimestamp("TRIP_START_TIME");
					DateFormat sdf=new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
					tripStartDateTimeT=sdf.format(date);
					DateFormat sdf1=new SimpleDateFormat("dd-MM-yyyy");
					String StartDateTimeT=sdf1.format(date);
					JsonObject.put("sdate", tripStartDateTimeT);	
					informationList.add(StartDateTimeT);
				}
				else{
					JsonObject.put("TripStartDateTime", tripStartDateTimeT);	
					informationList.add(tripStartDateTimeT);
				}
				int stateId=rs.getInt("STATE");
				String state = "";
				if(rs.getString("STATE_NAME")!=null)
				{
					state= rs.getString("STATE_NAME");
				}else{
					state="";
				}			
				JsonObject.put("stateId", stateId);
				JsonObject.put("state", state);
				informationList.add(state);

				String tripLocation = "";
				if(rs.getString("LOCATION")!=null)
				{
					tripLocation= rs.getString("LOCATION");
				}else{
					tripLocation="";
				}
				JsonObject.put("location", tripLocation.toUpperCase());
				informationList.add(tripLocation.toUpperCase());

				String asset="";
				if(rs.getString("ASSET_NUMBER")!=null)
				{
					asset= rs.getString("ASSET_NUMBER");
				}else{
					asset="";
				}
				JsonObject.put("registrationNo", asset.toUpperCase());
				informationList.add(asset.toUpperCase());	

				String tripStatusName = "";
				if(rs.getString("TRIP_STATUS")!=null)
				{
					tripStatusName= rs.getString("TRIP_STATUS");
				}else{
					tripStatusName="";
				}
				JsonObject.put("tripStatus", tripStatusName);
				informationList.add(tripStatusName);

				String tripReasonOffRoad = "";
				if(rs.getString("REASONS_OFF_ROUTE")!=null)
				{
					tripReasonOffRoad= rs.getString("REASONS_OFF_ROUTE");
				}else{
					tripReasonOffRoad="";
				}
				JsonObject.put("reasonForOffRoad", tripReasonOffRoad);
				informationList.add(tripReasonOffRoad);

				String openingsKMS = "0.0";
				if(rs.getString("OPENING_ODOMETER")!=null)
				{
					openingsKMS= rs.getString("OPENING_ODOMETER");
				}else{
					openingsKMS="0.0";
				}

				JsonObject.put("OpeningKms",openingsKMS);
				informationList.add(openingsKMS);

				double OdoKMS = 0;
				if(rs.getString("ODO_KMS")!=null)
				{
					OdoKMS= rs.getDouble("ODO_KMS");
				}else{
					OdoKMS=0;
				}
				JsonObject.put("odoKmsRun", OdoKMS);
				informationList.add(OdoKMS);


				double gpsDistance = 0.0;
				if(rs.getString("GPS_DISTANCE")!=null)
				{
					gpsDistance= rs.getDouble("GPS_DISTANCE");
				}else{
					gpsDistance=0.0;
				}
				JsonObject.put("gpsKmsRun", gpsDistance);
				informationList.add(gpsDistance);

				String hiredAsset="";
				if(rs.getString("HIRED_ASSET_NUMBER")!=null)
				{
					hiredAsset= rs.getString("HIRED_ASSET_NUMBER");
				}else{
					hiredAsset="";
				}
				JsonObject.put("hiredVehicleNo", hiredAsset.toUpperCase());
				informationList.add(hiredAsset.toUpperCase());	

				double hiredAmount =0.00;
				if(rs.getString("HIRED_AMOUNT")!=null)
				{
					hiredAmount= rs.getDouble("HIRED_AMOUNT");
				}else{
					hiredAmount=0.00;
				}
				JsonObject.put("hiredAmount",(doubleformat.format(hiredAmount)));
				informationList.add((doubleformat.format(hiredAmount)));

				String hiredDistance = "0.0";
				if(rs.getString("HIRED_DISTANCE")!=null)
				{
					hiredDistance= rs.getString("HIRED_DISTANCE");
				}else{
					hiredDistance="0.0";
				}
				JsonObject.put("hiredVehicleKmsRun",(singleformat.format(Double.parseDouble(hiredDistance))));
				informationList.add(singleformat.format(Double.parseDouble(hiredDistance)));
				
				int uniqueId=rs.getInt("ID");
				JsonObject.put("uniqueIdDataIndex", uniqueId);

				String status ="";
				if(rs.getString("STATUS")!=null)
				{
					status= rs.getString("STATUS");
				}else{
					status=" ";
				}
				JsonObject.put("status",status);
				informationList.add(status);

				JsonArray.put(JsonObject);	
				reporthelper.setInformationList(informationList);
				reportsList.add(reporthelper);
			}

			finlist.add(JsonArray);
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

	//----------------------------------get trip details-------------------------------------------//
	public ArrayList<Object> getDayWiseNoShowTripDetails(String customerid,String startdate,int systemId,int offset,String language,int UserId) {
		JSONArray JsonArray = new JSONArray();
		JSONObject JsonObject = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int count=0;
		ArrayList<ReportHelper> reportsList = new ArrayList<ReportHelper>();
		ArrayList<String> headersList = new ArrayList<String>();
		ReportHelper finalreporthelper = new ReportHelper();
		ArrayList<Object> finlist = new ArrayList<Object>();
		try {
			headersList.add(cf.getLabelFromDB("SLNO",language));
			headersList.add(cf.getLabelFromDB("Start_Date",language));
			headersList.add(cf.getLabelFromDB("Asset_Number",language));
			headersList.add(cf.getLabelFromDB("Group_Name",language));

			JsonArray = new JSONArray();
			JsonObject = new JSONObject();
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(TripCreationStatements.GET_DAY_WISE_NO_SHOW_TRIP_REPORT);
			pstmt.setInt(1,systemId);
			pstmt.setString(2,customerid);
			pstmt.setInt(3,UserId);
			pstmt.setInt(4,systemId);
			pstmt.setString(5,customerid);
			pstmt.setString(6,startdate);
			rs = pstmt.executeQuery();
			while (rs.next()){
				JsonObject = new JSONObject();
				ArrayList<Object> informationList = new ArrayList<Object>();
				ReportHelper reporthelper = new ReportHelper();
				count++;				
				informationList.add(Integer.toString(count));
				JsonObject.put("slnoIndex", Integer.toString(count));

				/*String tripStartDateTimeT="";
				if(rs.getTimestamp("TRIP_START_TIME")!=null)
				{
					//Date date=rs.getTimestamp("TRIP_START_TIME");
					//DateFormat sdf=new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
					//tripStartDateTimeT=sdf.format(date);
					JsonObject.put("sdate", startdate);	
					informationList.add(startdate);
				}
				else{
					JsonObject.put("TripStartDateTime", tripStartDateTimeT);	
					informationList.add(tripStartDateTimeT);
				}*/
				JsonObject.put("sdate", startdate);	
				informationList.add(startdate);

				String assetNo="";
				if(rs.getString("REGISTRATION_NUMBER")!=null)
				{
					assetNo= rs.getString("REGISTRATION_NUMBER");
				}else{
					assetNo="";
				}
				JsonObject.put("registrationNo", assetNo);
				informationList.add(assetNo);	


				String gropName = "";
				if(rs.getString("GROUP_NAME")!=null)
				{
					gropName= rs.getString("GROUP_NAME");
				}else{
					gropName="";
				}
				JsonObject.put("groupNameIndex", gropName);
				informationList.add(gropName);

				JsonArray.put(JsonObject);	
				reporthelper.setInformationList(informationList);
				reportsList.add(reporthelper);
			}

			finlist.add(JsonArray);
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
	//------------------------------------------------------------------------------------------------------//

	public String getFormattedDateStartingFromMonth(String inputDate) {
		String formattedDate = "";
		SimpleDateFormat sdf = new SimpleDateFormat("dd-MM-yyyy");

		SimpleDateFormat sdfFormatDate = new SimpleDateFormat(
		"MM/dd/yyyy HH:mm:ss");
		try {
			if (inputDate != null && !inputDate.equals("")) {
				java.util.Date d = sdfFormatDate.parse(inputDate);
				formattedDate = sdf.format(d);
			}
		} catch (Exception e) {
			System.out
			.println("Error in getFormattedDateStartingFromMonth() method"
					+ e);
		}
		return formattedDate;
	}

	public String getFormattedDateStartingFromyear(String inputDate) {
		String formattedDate = "";
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

		SimpleDateFormat sdfFormatDate = new SimpleDateFormat("MM/dd/yyyy HH:mm:ss");
		try {
			if (inputDate != null && !inputDate.equals("")) {
				java.util.Date d = sdfFormatDate.parse(inputDate);
				formattedDate = sdf.format(d);
			}
		} catch (Exception e) {
			System.out
			.println("Error in getFormattedDateStartingFromMonth() method"
					+ e);
		}
		return formattedDate;
	}

	//--------------------------------------------Business Details Report--------------------//
	//---------------------------------------------get Business Type------------------------------//
	/** Get details for Business Type  
	 * @param customerid
	 * @return
	 */
	public JSONArray getBusinessType(String type) {
		Connection conAdmin = null;
		PreparedStatement pstmt = null;
		Connection con = null;
		ResultSet rs = null;
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject = new JSONObject();
		try {
			conAdmin = DBConnection.getConnectionToDB("AMS");
			pstmt = conAdmin.prepareStatement(TripCreationStatements.GET_BUSINESS_TYPE);
			pstmt.setString(1,type);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				jsonObject = new JSONObject();
				jsonObject.put("businessType", rs.getString("VALUE"));
				jsonArray.put(jsonObject);
			}

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(conAdmin, pstmt, rs);
		}
		return jsonArray;
	}
	//---------------------------------------------get Route Type------------------------------//
	/** Get details for route Type  
	 * @param customerid
	 * @return
	 */
	
	
	public JSONArray getCVSCustomerDetails(int customerid,int systemId,int cvsCustId) {
		Connection conAdmin = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject = new JSONObject();
		try {
			conAdmin = DBConnection.getConnectionToDB("AMS");
			pstmt = conAdmin.prepareStatement(TripCreationStatements.GET_CVS_CUSTOMER_DETAILS);			
			pstmt.setInt(1,customerid);
			pstmt.setInt(2,systemId);
			pstmt.setInt(3,cvsCustId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				jsonObject = new JSONObject();
				jsonObject.put("Address", rs.getString("Address"));
				jsonObject.put("Region", rs.getString("State"));
				jsonArray.put(jsonObject);
			}

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(conAdmin, pstmt, rs);
		}
		return jsonArray;
	}
	
	public JSONArray getCVSCustomer(String customerid,int systemId) {
		Connection conAdmin = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject = new JSONObject();
		try {
			conAdmin = DBConnection.getConnectionToDB("AMS");
			pstmt = conAdmin.prepareStatement(TripCreationStatements.GET_CVS_CUSTOMER);			
			pstmt.setString(1,customerid);
			pstmt.setInt(2,systemId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				jsonObject = new JSONObject();
				jsonObject.put("CVSCustId", rs.getString("CustomerId"));
				jsonObject.put("CVSCustName", rs.getString("CustomerName"));
				jsonArray.put(jsonObject);
			}

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(conAdmin, pstmt, rs);
		}
		return jsonArray;
	}
	
	public JSONArray getRouteId(String customerid,int systemId) {
		Connection conAdmin = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject = new JSONObject();
		try {
			conAdmin = DBConnection.getConnectionToDB("AMS");
			pstmt = conAdmin.prepareStatement(TripCreationStatements.GET_ROUTE_TYPE);
			pstmt.setInt(1,systemId);
			pstmt.setString(2,customerid);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				jsonObject = new JSONObject();
				jsonObject.put("uniqueRouteId", rs.getString("ID"));
				jsonObject.put("routeId", rs.getString("ROUTE_ID"));
				jsonObject.put("routeName", rs.getString("ROUTE_NAME"));
				jsonArray.put(jsonObject);
			}

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(conAdmin, pstmt, rs);
		}
		return jsonArray;
	}

	//----------------------------------get Business details-------------------------------------------//
	public ArrayList<Object> getBusinessDetails(String customerid,int systemId) {
		JSONArray JsonArray = new JSONArray();
		JSONObject JsonObject = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int count=0;
		ArrayList<Object> finlist = new ArrayList<Object>();
		try {
			JsonArray = new JSONArray();
			JsonObject = new JSONObject();
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(TripCreationStatements.GET_BUSINESS_DETAILS_REPORT);
			pstmt.setInt(1,systemId);
			pstmt.setString(2,customerid);
			rs = pstmt.executeQuery();
			while (rs.next()){
				JsonObject = new JSONObject();
				count++;				
				JsonObject.put("slnoIndex", Integer.toString(count));

				String businessId = "";
				if(rs.getString("BUSINESS_ID")!=null)
				{
					businessId= rs.getString("BUSINESS_ID");
				}else{
					businessId="";
				}			
				JsonObject.put("businessIdIndex", businessId);

				String businessType = "";
				if(rs.getString("BUSINESS_TYPE")!=null)
				{
					businessType= rs.getString("BUSINESS_TYPE");
				}else{
					businessType="";
				}
				JsonObject.put("businessTypeIndex", businessType);


				String bank = "";
				if(rs.getString("BANK")!=null)
				{
					bank= rs.getString("BANK");
				}else{
					bank="";
				}
				JsonObject.put("bankIndex", bank);

				String address = "";
				if(rs.getString("ADDRESS")!=null)
				{
					address= rs.getString("ADDRESS");
				}else{
					address="";
				}
				JsonObject.put("addressIndex", address);
				
				String email = "";
				if(rs.getString("EMAIL_IDS")!=null)
				{
					email= rs.getString("EMAIL_IDS");
				}else{
					address="";
				}
				JsonObject.put("EmailDataIndex", email);

				String region = "";
				if(rs.getString("REGION")!=null)
				{
					region= rs.getString("REGION");
				}else{
					region="";
				}
				JsonObject.put("regionIndex",region);


				String hublocation = "";
				if(rs.getString("HUB_LOCATION")!=null)
				{
					hublocation= rs.getString("HUB_LOCATION");
				}else{
					hublocation="";
				}
				JsonObject.put("hubLocationIndex",hublocation);

				String routeId = "";
				if(rs.getString("ROUTE_ID")!=null)
				{
					routeId= rs.getString("ROUTE_ID");
				}else{
					routeId="";
				}
				JsonObject.put("routeIdIndex",routeId);


				String routeName = "";
				if(rs.getString("ROUTE_NAME")!=null)
				{
					routeName= rs.getString("ROUTE_NAME");
				}else{
					routeName="";
				}
				JsonObject.put("routeNameIndex",routeName);

				double latitude = 0.0;
				if(rs.getString("LATITUDE")!=null)
				{
					latitude= rs.getDouble("LATITUDE");
				}else{
					latitude=0.0;
				}
				JsonObject.put("latitudeIndex", latitude);

				double longitude = 0.0;
				if(rs.getString("LONGITUDE")!=null)
				{
					longitude= rs.getDouble("LONGITUDE");
				}else{
					longitude=0.0;
				}
				JsonObject.put("longitudeIndex", longitude);

				int uniqueId=rs.getInt("ID");
				JsonObject.put("uniqueIdDataIndex", uniqueId);

				double radius = 0.0;
				if(rs.getString("RADIUS")!=null)
				{
					radius= rs.getDouble("RADIUS");
					JsonObject.put("radiusIndex", radius);
				}else{
					JsonObject.put("radiusIndex", "");
				}
				
				String status = "";
				if(rs.getString("STATUS")!=null)
				{
					status= rs.getString("STATUS");
				}else{
					status="";
				}
				JsonObject.put("statusIndex", status);
				
				JsonArray.put(JsonObject);
			}

			finlist.add(JsonArray);

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return finlist;
	}

	//---------------------------------------------------Insert Business Details--------------------------------//
	/** Saving Business Information 
	 * @return 
	 */

	public String saveBusinessInformation(String customerId,String businessId,String businessType,String bank,String address,String email,
			String region,String hublocation,String routeId,double latitude,double longitude,int systemId,String routeName,String status,String radius,int userid,String uniqueRouteId,String cvscustomerId){

		String message="";
		Connection conAdmin = null;
		PreparedStatement pstmt5 = null;
		ResultSet rs5 = null;
		try{
			int inserted=0;
			conAdmin = DBConnection.getConnectionToDB("AMS");
			pstmt5=conAdmin.prepareStatement(TripCreationStatements.GET_BUSINESS_ID_VALIDATE);
			pstmt5.setString(1,businessId.toUpperCase());
			rs5=pstmt5.executeQuery();
			if(rs5.next())
			{  
				message = "<p>Business ID Already Exists. Try some other Business Id.</p>";
				return (message);
			}
			
			pstmt5=conAdmin.prepareStatement(TripCreationStatements.SAVE_BUSINESS_INFORMATION);
			pstmt5.setString(1,businessId.toUpperCase());
			pstmt5.setString(2,businessType);
			pstmt5.setString(3,"");
			pstmt5.setString(4,bank.toUpperCase());
			pstmt5.setString(5,address.toUpperCase());
			pstmt5.setString(6,region.toUpperCase());
			pstmt5.setString(7,"");
			pstmt5.setString(8,hublocation.toUpperCase());
			pstmt5.setString(9,uniqueRouteId);
			pstmt5.setString(10,"");
			pstmt5.setString(11,routeName.toUpperCase());
			pstmt5.setString(12,status);
			pstmt5.setString(13,radius);
			pstmt5.setDouble(14,latitude);
			pstmt5.setDouble(15,longitude);
			pstmt5.setString(16,email);
			pstmt5.setInt(17,userid);
			pstmt5.setInt(18,systemId);
			pstmt5.setString(19,customerId);
			pstmt5.setInt(20,Integer.parseInt(cvscustomerId));
			inserted=pstmt5.executeUpdate(); 
			if(inserted>0)
			{
				message="Business Details Saved Successfully";
			}else{
				message="Error in Saving Trip Details";
			}
		}catch(Exception e){
			System.out.println("error in TripCreationFunction:-save BusinessDetails details "+e.toString());
			e.printStackTrace();
		}finally {
			DBConnection.releaseConnectionToDB(conAdmin, pstmt5,rs5);
		}
		return message;
	}

	//----------------------------------------update Trip details----------------------------------------//
	/** Modifying Trip Information 
	 * @param customerId
	 * @param routeIdModify 
	 * @param systemId	
	 * @return 
	 */


	public String modifyBusinessInformation(String customerId,String businessId,String businessType,String bankModify,String addressModify,String emailModify,
			String regionModify,String hublocation,String routeIdModify, double latitude,double longitude,int systemId,int uniqueId,
			String status,String routeName,String radius,int userid,String uniqueRouteId)
	{
		String message="";
		Connection conAdmin = null;
		PreparedStatement pstmt6 = null;
		ResultSet rs=null;
		try{
			
			conAdmin=DBConnection.getConnectionToDB("AMS");
			 pstmt6 = conAdmin.prepareStatement(TripCreationStatements.CHECK_BUSINESSID_ALREADY_EXIST_FOR_MODIFY);
			 pstmt6.setString(1, businessId);
			 pstmt6.setInt(2, uniqueId);
			 rs = pstmt6.executeQuery();
			 if(rs.next())
			 {
				 message="<p>Business ID Already Exists. Try some other Business Id.</p>";
				 return message;
			 }
			int updated=0;
		
			pstmt6=conAdmin.prepareStatement(TripCreationStatements.MODIFY_BUSINESS_INFORMATION);
			pstmt6.setString(1,businessId.toUpperCase());
			pstmt6.setString(2,businessType);
			pstmt6.setString(3,"");
			pstmt6.setString(4,bankModify.toUpperCase());
			pstmt6.setString(5,addressModify.toUpperCase());
			pstmt6.setString(6,regionModify.toUpperCase());
			pstmt6.setString(7,"");
			pstmt6.setString(8,hublocation.toUpperCase());
			pstmt6.setString(9,uniqueRouteId);
			pstmt6.setString(10,"");
			pstmt6.setString(11,routeName.toUpperCase());
			pstmt6.setString(12,status);
			pstmt6.setString(13,radius);
			pstmt6.setDouble(14,latitude);
			pstmt6.setDouble(15,longitude);
			pstmt6.setString(16,emailModify);
			pstmt6.setInt(17,userid);
			pstmt6.setInt(18,systemId);
			pstmt6.setString(19,customerId);
			pstmt6.setInt(20, uniqueId);
			updated=pstmt6.executeUpdate();
			if(updated>0)
			{
				message="Business Details Modified Successfully";
			}

		}catch(Exception e){
			System.out.println("error in TripCreationFunction:-update Business details "+e.toString());
			e.printStackTrace();
		}finally {
			DBConnection.releaseConnectionToDB(conAdmin, pstmt6,rs);
		}
		return message;
	}
	//------------------------------delete opened trip and open the closed trip---------------------//
	public String deleteOpenedTrip(String customerId,String vehicleNumber,
			int systemId,String uid){

		String message="";
		Connection conAdmin = null;
		PreparedStatement pstmt = null;
		ResultSet rs=null;
		try{
			conAdmin = DBConnection.getConnectionToDB("AMS");
				int deleted=0;
				pstmt=conAdmin.prepareStatement(TripCreationStatements.GET_OPENED_TRIP_DETAILS);
				pstmt.setInt(1,systemId);
				pstmt.setString(2,vehicleNumber);
				pstmt.setString(3,customerId);
				rs=pstmt.executeQuery();
				if(rs.next())
				{
					pstmt=conAdmin.prepareStatement(TripCreationStatements.DELETE_OPENED_TRIP);
					pstmt.setInt(1,systemId);
					pstmt.setString(2,customerId);
					pstmt.setString(3,uid);
					deleted = pstmt.executeUpdate();
					if(deleted>0){
						message="Trip Deleted Successfully";
					}else{
						message="Unable to Delete the Trip";
					}
					
					pstmt = conAdmin.prepareStatement(TripCreationStatements.OPEN_AND_UPDATE_PREVIOUS_TRIP);
					pstmt.setInt(1,systemId);
					pstmt.setString(2,vehicleNumber);
					pstmt.setString(3,rs.getString("ID"));
					pstmt.setString(4,customerId);
					pstmt.executeUpdate();
								
				}
				else{
					pstmt=conAdmin.prepareStatement(TripCreationStatements.DELETE_OPENED_TRIP);
					pstmt.setInt(1,systemId);
					pstmt.setString(2,customerId);
					pstmt.setString(3,uid);
					deleted = pstmt.executeUpdate();
					if(deleted>0){
						message="Trip Deleted Successfully";
					}else{
						message="Unable to Delete the Trip";
					}
				}
				
		}catch(Exception e){
			System.out.println("Error in deleting the trip--->"+e);
		}
		finally{
			DBConnection.releaseConnectionToDB(conAdmin, pstmt,rs);
		}
		return message;
	}

}
