package t4u.functions;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.Properties;

import org.json.JSONArray;
import org.json.JSONObject;

import t4u.common.ApplicationListener;
import t4u.common.DBConnection;
import t4u.statements.CreateTripStatement;
import t4u.statements.DashBoardStatements;
import t4u.statements.SemiAutoTripStatements;
import t4u.util.TemperatureConfiguration;
import t4u.util.TemperatureConfigurationBean;

import com.google.gson.internal.LinkedTreeMap;

public class SemiAutoTripFunctions {
	CommonFunctions cf = new CommonFunctions();
	SimpleDateFormat ddmmyyyy = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
	SimpleDateFormat yyyymmdd = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	public static Object lock = new Object();
	public String saveTripMuscat(String assetNumber,String productLine,List desTripDetailsList,LinkedTreeMap trackTripSub,
			List tempeartureArray,int tripCustomerId,String customerName,String custReference,String sourceName,String tripStartTime,String routeName,
			int systemId,int customerId,int userId,int offset, LogWriter logWriter){
		    SimpleDateFormat ddmmyyyyhhmm = new SimpleDateFormat("dd/MM/yyyy HH:mm");
		 	Connection con=null;
			con = DBConnection.getConnectionToDB("AMS");
			PreparedStatement pstmt = null;
			PreparedStatement pstmt1 = null;
			ResultSet rs= null;
			int tripId = 0;
			String message = "";
			int inserted = 0;
			try {
				if (assetNumber == null || assetNumber.trim().equals("") || assetNumber.length() ==0){
					message = "Invlaid Vehicle Number!!";
					return message;
				}
				pstmt = con.prepareStatement(SemiAutoTripStatements.CHECK_VEHICLE_AVALABILITY);
				pstmt.setString(1,assetNumber);
				rs = pstmt.executeQuery();
				if(rs.next())
				{
					message = "Vehicle already in trip!!";
					return message;
				}
				//check if vehicle already on trip
				SimpleDateFormat ddmmhhmm = new SimpleDateFormat("ddMMHHmm");
				Date date = new Date();
				String curdate = ddmmhhmm.format(date);
				String[] sourceSplit = sourceName.split(",");
				if(sourceSplit.length > 0) {
					sourceName = sourceSplit[0];
				}
				String shipmentId = sourceName+"-"+assetNumber+"-"+curdate; 
				String addorderId = getUniqueOrderNo(systemId, customerId, con,customerName);
				pstmt = con.prepareStatement(SemiAutoTripStatements.INSERT_TRIP_DETAILS_MUSCAT,PreparedStatement.RETURN_GENERATED_KEYS);
				pstmt.setString(1,assetNumber);
				pstmt.setString(2,productLine);
				pstmt.setInt(3,offset);
				pstmt.setString(4,yyyymmdd.format(ddmmyyyyhhmm.parse(tripStartTime)));
				pstmt.setString(5,custReference);
				pstmt.setString(6,customerName);
				pstmt.setString(7,addorderId);
				pstmt.setString(8,shipmentId);
				pstmt.setString(9,routeName);
				pstmt.setInt(10,systemId);
				pstmt.setInt(11,customerId);
				pstmt.setInt(12,userId);
				inserted = pstmt.executeUpdate();
				rs = pstmt.getGeneratedKeys();
				if(rs.next())
				{
					tripId = rs.getInt(1);
				}
				pstmt = con.prepareStatement(SemiAutoTripStatements.INSERT_TRACK_TRIP_DETAILS_SUB_MUSCAT);
				pstmt.setInt(1,tripId);
				pstmt.setInt(2,offset);
				pstmt.setString(3,yyyymmdd.format(ddmmyyyyhhmm.parse((String)trackTripSub.get("loadStartTime"))));
				pstmt.setInt(4,offset);
				pstmt.setString(5,yyyymmdd.format(ddmmyyyyhhmm.parse((String)trackTripSub.get("loadEndTime"))));
				pstmt.executeUpdate();

				insertCheckPointsForUnplannedTrip(con,desTripDetailsList,tripId,systemId,customerId);
				
				if (productLine.equalsIgnoreCase("TCL") || productLine.equalsIgnoreCase("Chiller") || productLine.equalsIgnoreCase("Freezer")){				 
					pstmt = con.prepareStatement(SemiAutoTripStatements.CHECK_R232_ASSOCIATION);
					pstmt.setString(1, assetNumber);
					pstmt.setInt(2,systemId);
					pstmt.setInt(3,customerId);
					rs = pstmt.executeQuery();
					if(rs.next()){
						List<TemperatureConfigurationBean> tempConfigDetails = TemperatureConfiguration.getTemperatureConfigurationDetails(systemId,customerId,assetNumber);
			        	 for (int i = 0 ; i < tempConfigDetails.size(); i++) {
			        		TemperatureConfigurationBean tempObj = tempConfigDetails.get(i);
			        		// JSONObject obj = array.getJSONObject(0);
			        		LinkedTreeMap temperatureSetting = (LinkedTreeMap)tempeartureArray.get(0);
			        		String minNeg = ((Double)temperatureSetting.get("minNegativeTemp")).toString();
			        		String maxNeg = ((Double)temperatureSetting.get("maxNegativeTemp")).toString();
			        		String minPos = ((Double)temperatureSetting.get("minPositiveTemp")).toString();
			        		String maxPos = ((Double)temperatureSetting.get("maxPositiveTemp")).toString();
			        		
			        		pstmt1 = con.prepareStatement(CreateTripStatement.INSERT_TRIP_VEHICLE_TEMPERATURE_DETAILS);
			    			pstmt1.setInt(1,tripId);
			    			pstmt1.setString(2,assetNumber);
			    			pstmt1.setString(3,tempObj.getName());
			    			pstmt1.setString(4,tempObj.getSensorName());
			    			pstmt1.setString(5,minNeg);
			    			pstmt1.setString(6,minPos);
			    			pstmt1.setString(7,maxNeg);
			    			pstmt1.setString(8,maxPos);
			    			pstmt1.setString(9, "Y");
			    			pstmt1.executeUpdate();
			        	}
					}
					else{
						// JSONObject obj = array.getJSONObject(0);
		        		LinkedTreeMap temperatureSetting = (LinkedTreeMap)tempeartureArray.get(0);
		        		String minNeg = ((Double)temperatureSetting.get("minNegativeTemp")).toString();
		        		String maxNeg = ((Double)temperatureSetting.get("maxNegativeTemp")).toString();
		        		String minPos = ((Double)temperatureSetting.get("minPositiveTemp")).toString();
		        		String maxPos = ((Double)temperatureSetting.get("maxPositiveTemp")).toString();
		        		
		        		pstmt1 = con.prepareStatement(CreateTripStatement.INSERT_TRIP_VEHICLE_TEMPERATURE_DETAILS);
		    			pstmt1.setInt(1,tripId);
		    			pstmt1.setString(2,assetNumber);
		    			pstmt1.setString(3,"Analog Input");
		    			pstmt1.setString(4,"ANALOG_INPUT_2");
		    			pstmt1.setString(5,minNeg);
		    			pstmt1.setString(6,minPos);
		    			pstmt1.setString(7,maxNeg);
		    			pstmt1.setString(8,maxPos);
		    			pstmt1.setString(9, "Y");
		    			pstmt1.executeUpdate();
					}
				}
				if (inserted > 0) {
					message = "success";
				}else{
					message = "error";
				}
					logWriter.log("Trip Saved ::"+tripId, LogWriter.ERROR);
				}
				catch (Exception e) {
					logWriter.log("Error in SemiAutoTripFunction.saveTrip :"+e.getMessage(), LogWriter.ERROR);
					e.printStackTrace();
				} 
				finally {
					DBConnection.releaseConnectionToDB(con, pstmt, rs);
				}
			return message;
		}
	
	private void  insertCheckPointsForUnplannedTrip(Connection con,List desTripDetailsList,int tripId,int systemId,int customerId) throws SQLException{
		int count=0;
		int sequence=0;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		 for(int i=0; i <desTripDetailsList.size(); i++){ 
 			LinkedTreeMap desTripDetailMap = (LinkedTreeMap)desTripDetailsList.get(i);
			count++;
			pstmt = con.prepareStatement(SemiAutoTripStatements.INSERT_TRIP_POINTS_CHECK_POINTS,PreparedStatement.RETURN_GENERATED_KEYS);
			pstmt.setInt(1, tripId);
	        pstmt.setString(2, (String)desTripDetailMap.get("hubId"));
	        pstmt.setString(3, (String)desTripDetailMap.get("name"));
	        pstmt.setString(4, (String)desTripDetailMap.get("latitude"));
	        pstmt.setString(5, (String)desTripDetailMap.get("longitude"));
	        pstmt.setString(6, (String)desTripDetailMap.get("radius"));
	        pstmt.setString(7, (String)desTripDetailMap.get("detentionTime"));
	        pstmt.setInt(8, sequence);
	        //pstmt.setString(6, (String)desTripDetailMap.get("detentionTime"));put name
	        pstmt.executeUpdate();
	        rs = pstmt.getGeneratedKeys();
	        int desTripId = 0;
			if(rs.next())
			{
				desTripId = rs.getInt(1);
			}
	        LinkedTreeMap tripOrderDetails = (LinkedTreeMap)desTripDetailMap.get("tripOrderDetails");
	        if(tripOrderDetails != null){
		        pstmt = con.prepareStatement(SemiAutoTripStatements.INSERT_INTO_TRIP_ORDER_DETAILS);
		        pstmt.setInt(1, desTripId);
		        pstmt.setInt(2, tripId);
		        pstmt.setString(3, (String)tripOrderDetails.get("scanId"));
		        pstmt.setString(4, (String)tripOrderDetails.get("orderNo"));
		        pstmt.setString(5, (String)tripOrderDetails.get("deliveryTicketNo"));
		        pstmt.setString(6, (String)tripOrderDetails.get("deliveryNoteNo"));
		        pstmt.setString(7, (String)tripOrderDetails.get("tripCustomerId"));
		        pstmt.setString(8, "PENDING");
		        pstmt.setString(9, (String)tripOrderDetails.get("tripCustomerName"));
		        pstmt.setString(10, "N");
		        pstmt.setInt(11, systemId);
		        pstmt.setInt(12, customerId);
		        pstmt.executeUpdate();
	        }
	        sequence++;
		}
	}
	
	public ArrayList < Object > getSemiTripDetails(int systemId, int customerId,String startDate,String endDate,int offset, int userId, 
			String statusType,String zone) {
		JSONArray JsonArray = new JSONArray();
	    JSONObject JsonObject = null;
	    Connection con = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
	    PreparedStatement pstmt1 = null;
	    ResultSet rs1 = null;
	    ArrayList<String> tableNames = new ArrayList<String>();
	    String remarks = "";
	    ArrayList < Object > finlist = new ArrayList < Object > ();
	    String condition = "";
	    if(statusType.equalsIgnoreCase("OPEN")){
	    	condition = "and a.STATUS = 'OPEN'";
	    }else if(statusType.equalsIgnoreCase("CLOSED")){
	    	condition = "and a.STATUS = 'CLOSED'";
	    }else if(statusType.equalsIgnoreCase("CANCELLED")){
	    	condition = "and a.STATUS = 'CANCEL'";
	    }
	    try {
	    	int count = 0;
	        con = DBConnection.getConnectionToDB("AMS");
	        pstmt = con.prepareStatement(SemiAutoTripStatements.GET_SEMI_AUTO_TRIP_DETAILS.replace("#", condition).replace("LOCATION_ZONE", "LOCATION_ZONE_"+zone));
	        pstmt.setInt(1, offset);
	        pstmt.setInt(2, offset);
	        pstmt.setInt(3, offset);
	        pstmt.setInt(4, offset);
	        pstmt.setInt(5, offset);
	        pstmt.setInt(6, offset);
	        pstmt.setInt(7, offset);
	        pstmt.setInt(8, offset);
	        pstmt.setInt(9, offset);
	        pstmt.setInt(10, systemId);
	        pstmt.setInt(11, customerId);
	        pstmt.setInt(12, offset);
	        pstmt.setString(13, startDate);
	        pstmt.setInt(14, offset);
	        pstmt.setString(15, endDate);
	        rs = pstmt.executeQuery();
	        
	        SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm");
			
	        while (rs.next()) {
	            JsonObject = new JSONObject();
	            count++;
	            JsonObject.put("slnoIndex", count);
	            JsonObject.put("uniqueIdIndex",rs.getInt("ID"));
	            JsonObject.put("shipmentIdIndex",rs.getString("SHIPMENT_ID"));
	            JsonObject.put("routeNameDataIndex", rs.getString("RouteName"));
	            JsonObject.put("vehicleDataIndex", rs.getString("ASSET_NO"));
	            JsonObject.put("insertedByDataIndex", rs.getString("INSERTED_BY"));
	            JsonObject.put("insertedTimeDataIndex",sdf.format(rs.getTimestamp("INSERTED_TIME"))); 
	            if(rs.getTimestamp("TRIP_START_TIME") != null){
	            	JsonObject.put("plannedDateTimeIndex",sdf.format(rs.getTimestamp("TRIP_START_TIME"))); 
	            }else{
	            	JsonObject.put("plannedDateTimeIndex",""); 
	            }
	            JsonObject.put("customerNameIndex",rs.getString("CUSTOMER_NAME"));
	            JsonObject.put("orderIdIndex",rs.getString("ORDER_ID"));
	            JsonObject.put("custRefIdIndex",rs.getString("CUSTOMER_REF_ID"));
	            JsonObject.put("statusDataIndex", rs.getString("STATUS"));
	            JsonObject.put("avgSpeedIndex", rs.getDouble("avgSpeed"));
	            if(rs.getString("sourceHubName") != null && !rs.getString("sourceHubName").equals("")){
	            	JsonObject.put("sourceHubName", rs.getString("sourceHubName"));
	            }else{
	            	JsonObject.put("sourceHubName", "");
	            }

	            pstmt1 = con.prepareStatement(CreateTripStatement.GET_TRIP_VEHICLE_TEMPERATURE_DETAILS);
	            pstmt1.setInt(1, rs.getInt("ID"));
	            pstmt1.setString(2, rs.getString("ASSET_NO"));
	            rs1 = pstmt1.executeQuery();
	            
            	String tblData = "";
            	if(rs1.next()){
            		double negativeMaxTemp=rs1.getDouble("MAX_NEGATIVE_TEMP");
    	            double negativeMinTemp=rs1.getDouble("MIN_NEGATIVE_TEMP");
    	            double positiveMaxTemp=rs1.getDouble("MAX_POSITIVE_TEMP");
    	            double positiveMinTemp=rs1.getDouble("MIN_POSITIVE_TEMP");
    	            double positiveMaxTemp2=positiveMaxTemp;//+1;
    	            double negativeMinTemp2=negativeMinTemp;//-1;
    	            tblData = tblData + "<tr><td style='color:green;'><b>"+"  "+"</b><b>GREEN :</b></td><td>"+negativeMaxTemp+" to "+positiveMinTemp+"</td><td style='color:yellow;'><b>    YELLOW :</b></td><td>"+negativeMinTemp+" to "+negativeMaxTemp+"; "+positiveMinTemp+" to "+positiveMaxTemp+"</td><td style='color:red;'><b>    RED :</b></td><td>-70 to "+negativeMinTemp2+"; "+positiveMaxTemp2+" to 70</td></tr>";
            	}
            	 tblData = tblData.length() > 0 ? tblData : "N/A";
            	JsonObject.put("tempRangeDataIndex", "<table style='white-space: nowrap;'>"+tblData+"</table> ");
            	pstmt1.close();
            	rs1.close();
	            String atd = "";
	            if(rs.getString("STATUS").equals("OPEN")){
	            	if(rs.getString("ACTUAL_TRIP_START_TIME")==null){
	            		atd = "";
	            		JsonObject.put("actionIndex", "<button data-toggle='modal'  onclick='getTripCancellationRemarks();' class='btn btn-warning' style='background-color:#da2618; border-color:#da2618;'>Cancel</button> " );
	            		JsonObject.put("modifyIndex", "<button data-toggle='modal'  class='btn btn-warning' style='background-color:#158e1a; border-color:#158e1a;'>Modify</button> " );
	            	}else{
	            		atd = rs.getString("ACTUAL_TRIP_START_TIME");
	            		JsonObject.put("actionIndex", "<button data-toggle='modal' onclick='loadTripDetails();'  class='btn btn-warning'  id='close"+rs.getInt("ID")+"'style='background-color:#da2618; border-color:#da2618;'>Close</button> " );
	            		JsonObject.put("modifyIndex", "<button data-toggle='modal'  class='btn btn-warning' style='background-color:#158e1a; border-color:#158e1a;'>Modify</button> " );
	            	}
	            }else{
	            	JsonObject.put("actionIndex", "<button onclick='cancleTrip()' class='btn btn-warning' disabled style='background-color:#da2618; border-color:#da2618;'>Cancelled</button> " );
	            	JsonObject.put("modifyIndex", "<button  data-toggle='modal'  class='btn btn-warning' style='background-color:#158e1a; border-color:#158e1a;'>View</button> " );
	            }
	            JsonObject.put("preLoadTempIndex", rs.getString("preLoadTemp"));
	            JsonObject.put("routeIdIndex", rs.getInt("routeId"));
	            JsonObject.put("productLineIndex", rs.getString("productLine"));
	            JsonObject.put("atdIndex", atd);
	            JsonObject.put("tripCustId", rs.getString("tripCustId"));
	            JsonObject.put("cancelledRemarks", rs.getString("CANCELLED_REMARKS"));
	            JsonObject.put("actualTripEndTime", rs.getTimestamp("ACTUAL_TRIP_END_TIME") != null ? sdf.format(rs.getTimestamp("ACTUAL_TRIP_END_TIME")): "");
	            JsonObject.put("actionByDate", rs.getTimestamp("CANCELLED_DATE") != null ? rs.getString("CANCELLED_BY") + "-"+  sdf.format(rs.getTimestamp("CANCELLED_DATE")): "");
	            //For Semi automated trip 
	            if(rs.getTimestamp("LOAD_START_TIME") != null){
	            	JsonObject.put("loadStartTime", sdf.format(rs.getTimestamp("LOAD_START_TIME")));
	            }else{
	            	JsonObject.put("loadStartTime","");
	            }
	            if(rs.getTimestamp("LOAD_END_TIME") != null){
	            	JsonObject.put("loadEndTime", sdf.format(rs.getTimestamp("LOAD_END_TIME")));
	            }else{
	            	JsonObject.put("loadEndTime","");
	            }
	            if(rs.getTimestamp("tripEndTime") != null){
	            	JsonObject.put("tripEndTime", sdf.format(rs.getTimestamp("tripEndTime")));
	            }else{
	            	JsonObject.put("tripEndTime","");
	            }
	            JsonArray.put(JsonObject);
	        }
	        tableNames.add("Select"+"##"+"dbo.TRACK_TRIP_DETAILS");
	        remarks = "Viewing all semi auto trips";
	        
	        finlist.add(JsonArray);
	    	} catch (Exception e) {
	        e.printStackTrace();
	    	} finally {
	        DBConnection.releaseConnectionToDB(con, pstmt, rs);
	        DBConnection.releaseConnectionToDB(null, pstmt1, rs1);
	    }
	    return finlist;
	}
	
	public String closeSemiAutoMatedTrip(int userId, int tripId, int systemId, int clientId, int offset,
			String vehicleNo, String remarksData,String tripCloseDate,  LogWriter logWriter) {
		logWriter.log("Start of SemiAutoTripFunction.closeRunningTrip" +  "::tripId:" + tripId + "::vehicleNo:" + vehicleNo
						, LogWriter.INFO);
		Connection con = null;
		PreparedStatement pstmt = null, pstmt1 = null;
		ResultSet rs1 = null;
		String message = "";
		ArrayList<String> tableName = new ArrayList<String>();
		int update = 0;
		String remarks = "";
		String action = "";
		try {
			con = DBConnection.getConnectionToDB("AMS");
			tableName.add("Update" + "##" + "TRACK_TRIP_DETAILS");
			String endLocation = getEndLocation(vehicleNo, systemId, clientId, tripId, con);
			SimpleDateFormat yyyymmdd = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			SimpleDateFormat sdfFormatDate = new SimpleDateFormat("dd/MM/yyyy HH:mm");
			pstmt = con.prepareStatement(CreateTripStatement.CLOSE_SEMI_AUTOMATED_TRIP);
			pstmt.setString(1, "CLOSED");
			pstmt.setInt(2, offset);
			pstmt.setString(3, yyyymmdd.format(sdfFormatDate.parse(tripCloseDate )));
			pstmt.setString(4, "N");
			pstmt.setInt(5, userId);
			pstmt.setString(6, remarksData);
			pstmt.setString(7, endLocation);
			pstmt.setInt(8, tripId);
			update = pstmt.executeUpdate();
			
			remarks = "Closing Trip : "+tripId;
			action = "Closing Trip";
			//boolean isExist = isVehicleOnTrip(con, offset, vehicleNo, systemId, clientId, tripId); Check this step!!!
			//if(!isExist){
				cf.updateVehicleStatus(con, vehicleNo, 16, 0,logWriter);
			//}
			if (update > 0) {
				message = "Trip Closed";
				logWriter.log("Successfully closed the trip Vehicle No : "+vehicleNo+". Trip Id : "+tripId+ "remarksData :"+remarksData, LogWriter.ERROR);
				try {
					cf.insertDataIntoAuditLogReport("", tableName,"Trip Solution", action, userId,"", systemId, clientId, remarks);
				} catch (final Exception e) {
					logWriter.log("Exception in audit log report : "+e.getMessage()+". Vehicle No : "+vehicleNo+". Trip Id : "+tripId, LogWriter.ERROR);
					e.printStackTrace();
				}
			}
		} catch (final Exception e) {
			logWriter.log("Error in SemiAutoTripFunction.closeRunningTrip" + e.getMessage(), LogWriter.ERROR);
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, null);
			DBConnection.releaseConnectionToDB(null, pstmt1, rs1);
		}
		logWriter.log("End of SemiAutoTripFunction.closeRunningTrip" ,LogWriter.INFO);
		return message;
	}
	
	public String getEndLocation(String vehicleNumber,int systemId, int customerId,int tripId ,Connection con) throws SQLException {
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String loc = "";
		try{
			pstmt = con.prepareStatement(CreateTripStatement.GET_CURRENT_LOCATION);
			pstmt.setString(1, vehicleNumber);
			pstmt.setInt(2, systemId);
			pstmt.setInt(3, customerId);
			rs = pstmt.executeQuery();
			if(rs.next()){
				 loc = rs.getString("END_LOCATION");
			}
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			pstmt.close();
			rs.close();
		}	
		return loc;
	}
	
	public String cancelTrip(int userID,int tripId, String sessionId, String serverName, int userId, int systemId, int custId, String vehicleNo, String remarks,LogWriter logWriter,String reasonId,int offset){
		logWriter.log("Start of creatTripFunc.cancelTrip method "+sessionId+" :: tripId:"+tripId+"::vehicleNo:"+vehicleNo ,LogWriter.INFO);
		Connection con=null;
		PreparedStatement pstmt=null,pstmt1 = null;
		ResultSet rs , rs1 = null;
		String message="";
		String lrNo = "";
		ArrayList<String> tableNames = new ArrayList<String>();
		String Remarks = "";
		try {
			String reason = remarks.length() > 0 ? reasonId+"-"+remarks : reasonId;
			con = DBConnection.getConnectionToDB("AMS");
			String endlocation = getEndLocation(vehicleNo, systemId, custId, tripId, con);
			pstmt = con.prepareStatement(CreateTripStatement.UPDATE_TO_CLOSE_TRIP);
			pstmt.setInt(1, userID);
			pstmt.setString(2, reason);
			pstmt.setString(3, endlocation);
			pstmt.setInt(4, tripId);
			
			int updated=pstmt.executeUpdate();
			
			if (updated > 0) {
				message = "Trip Cancelled";
		    }else{
		    	 message = "Error While Cancelling Trip";
		    }
			tableNames.add("Update"+"##"+"AMS.dbo.TRACK_TRIP_DETAILS");
			Remarks = "Cancelled the trip "+lrNo +" because of the reason : "+ reason;
			try{
				cf.insertDataIntoAuditLogReport(sessionId, tableNames, "Trip Solution", "Cancelling Trip", userId, serverName, systemId, custId, Remarks);
			}catch(Exception e){
				e.printStackTrace();
			}
			logWriter.log("End of SemiAutoTripFunction.cancelTrip method :"+sessionId+ "message:"+ message ,LogWriter.INFO);
		}catch (Exception e) {
			logWriter.log("Error in SemiAutoTripFunction.cancelTrip method :"+sessionId+ "message:"+ e.getMessage() ,LogWriter.ERROR);
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, null);
			DBConnection.releaseConnectionToDB(null, pstmt1, rs1);
		 }
		return message;
	}
	
	public  String getUniqueOrderNo(int systemId,int customerId,Connection con,String customerName) throws SQLException {
		PreparedStatement pstmt=null,pstmt1=null;
		ResultSet rs = null;
		String lrNo = "";
		DecimalFormat df = new DecimalFormat("000000");
		DecimalFormat df1 = new DecimalFormat("00");
		int count = 0;
		try{
			synchronized (lock) {
				pstmt = con.prepareStatement(CreateTripStatement.GET_COUNT_FOR_LR_NO_FROM_LOOK_UP_TABLE);
				pstmt.setInt(1, systemId);
				pstmt.setInt(2, customerId);
				rs = pstmt.executeQuery();
				if (rs.next()) {
					 count = rs.getInt("TRIP_COUNT");
					 count = count + 1;
					 pstmt1 = con.prepareStatement(CreateTripStatement.UPDATE_LR_COUNT_FOR_LOOK_UP_TABLE);
					 pstmt1.setInt(1, count);
					 pstmt1.setInt(2, systemId);
					 pstmt1.setInt(3, customerId);
					 pstmt1.executeUpdate();
				}
				Calendar c = Calendar.getInstance();
				int year = (c.get(Calendar.YEAR));
				//int month = c.get(Calendar.MONTH) + 1;

				lrNo = customerName + year + df.format(count);

			}
		}catch(Exception e){
			e.printStackTrace();
		}	
		finally{
			pstmt.close();
			pstmt1.close();
			rs.close();
		}	
		return lrNo;
	}
	
	public boolean checkRS232Association(String vehicleNumber,int systemId, int customerId) throws SQLException {
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Connection con=null;
		try{
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(SemiAutoTripStatements.CHECK_R232_ASSOCIATION);
			pstmt.setString(1, vehicleNumber);
			pstmt.setInt(2, systemId);
			pstmt.setInt(3, customerId);
			rs = pstmt.executeQuery();
			if(rs.next()){
				return true;
			}
		}catch(Exception e){
			e.printStackTrace();
		}	
		finally{
			pstmt.close();
			rs.close();
		}	
		return false;
	}
	public JSONArray getAvailableVehicles(int systemId, int clientId,int userId, String productLine) {
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject = new JSONObject();
		Connection con=null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;

		try {
			con = DBConnection.getConnectionToDB("AMS");
			jsonArray = new JSONArray();
			jsonObject = new JSONObject();
				if(productLine.equalsIgnoreCase("TCL")|| productLine.equalsIgnoreCase("Chiller") || productLine.equalsIgnoreCase("Freezer"))
				{
					
					pstmt = con.prepareStatement(SemiAutoTripStatements.GET_AVAILABLE_VEHICLES);
					pstmt.setInt(1, systemId);
					pstmt.setInt(2, clientId);
					pstmt.setInt(3, userId);
					pstmt.setInt(4, systemId);
					pstmt.setInt(5, clientId);
					pstmt.setInt(6, userId);
				}
		        rs = pstmt.executeQuery();
			
		        jsonObject = new JSONObject();
				jsonObject.put("vehicleName", "-- select vehicle number --");
				jsonObject.put("vehicleModel", "");
				jsonObject.put("vehicleType", "");
				jsonArray.put(jsonObject);	
				while (rs.next()) {
					jsonObject = new JSONObject();
					jsonObject.put("vehicleName", rs.getString("REGISTRATION_NUMBER"));
					jsonObject.put("vehicleModel", rs.getString("Model"));
					jsonObject.put("vehicleType", rs.getString("VehicleType"));
					jsonObject.put("minTempLimit", rs.getString("MinTempLimit"));
					jsonObject.put("maxTempLimit", rs.getString("MaxTempLimit"));
					jsonObject.put("isRS232Assoc", rs.getString("IS_RS232_ASSOC"));
					jsonArray.put(jsonObject);	
					
				}

		} // end of try

		catch (Exception e) {
			
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);			
		}

		return jsonArray;

	}
	public JSONArray getCustomers() {
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject = new JSONObject();
		Connection con=null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;

		try {
			con = DBConnection.getConnectionToDB("AMS");
			jsonArray = new JSONArray();
			jsonObject = new JSONObject();
			pstmt = con.prepareStatement(SemiAutoTripStatements.GET_CUSTOMERS);
			//pstmt.setInt(1, systemId);
	        rs = pstmt.executeQuery();
	        jsonObject = new JSONObject();
			jsonObject.put("name", "-- select customer --");
			jsonObject.put("id", "0");
			jsonArray.put(jsonObject);	
			while (rs.next()) {
				jsonObject = new JSONObject();
				jsonObject.put("id", rs.getString("CUSTOMER_ID"));
				jsonObject.put("name", rs.getString("NAME"));
				jsonObject.put("systemId", rs.getString("SYSTEM_ID"));
				jsonArray.put(jsonObject);	
			}
		} // end of try
		catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);			
		}
		return jsonArray;
	}

	/*
	 *  "INSERT INTO TRIP_CONFIGURATION (SYSTEM_ID,CUSTOMER_ID,TRIP_START_CRITERIA,TRIP_END_CRITERIA,TRIP_START_CRITERIA_PARAM,TRIP_END_CRITERIA_PARAM,ROUTE_TYPE," +
		" SEND_SMS_ONTRIP_START,HEAD_QUATERS,SMS_URL,SMS_USERNAME,SMS_PASSWORD,TRIP_CREATION_TYPE) " +
		" VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?)";
	 */

	public String saveTripConfiguration(String systemId1, String customerId,String tripStartCriteria, String tripEndCriteria,String tripStartCriteriaParam,String tripEndCriteriaParam,String routeType) {
		JSONArray jsonArray = new JSONArray();
		Connection con=null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		String message = "";
		int inserted = 0;
		try {
			con = DBConnection.getConnectionToDB("AMS");
			jsonArray = new JSONArray();
			pstmt = con.prepareStatement(SemiAutoTripStatements.INSERT_TRIP_CONFIGURATION);
			pstmt.setString(1, systemId1);
			pstmt.setString(2, customerId);
			pstmt.setString(3, tripStartCriteria);
			pstmt.setString(4, tripEndCriteria);
			pstmt.setString(5, tripStartCriteriaParam);
			pstmt.setString(6, tripEndCriteriaParam);
			pstmt.setString(7, routeType);
	        
			inserted = pstmt.executeUpdate();
			if (inserted > 0) {
				message = "success";
			}else{
				message = "error";
			}
			
		} // end of try
		catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);			
		}
		return message;
		
	}
	
	public String modifyTripConfiguration(int systemId, int clientId, String tripStartCriteria, String tripEndCriteria,String tripStartCriteriaParam,String tripEndCriteriaParam,String routeType
			,String sendSMsOnTripStart, String headQuaters,String smsUrl,String smsUsername, String smsPassword, String tripCreationType){
			Connection con=null;
			con = DBConnection.getConnectionToDB("AMS");
			PreparedStatement pstmt = null;
			ResultSet rs= null;
			String message = "";
			int updated = 0;
			try {
				pstmt = con.prepareStatement(SemiAutoTripStatements.UPDATE_TRIP_CONFIGURATION);
				pstmt.setInt(1, systemId);
				pstmt.setInt(2, clientId);
				pstmt.setString(3, tripStartCriteria);
				pstmt.setString(4, tripEndCriteria);
				pstmt.setString(5, tripStartCriteriaParam);
				pstmt.setString(6, tripEndCriteriaParam);
				pstmt.setString(7, routeType);
				pstmt.setString(8, sendSMsOnTripStart);
				pstmt.setString(9, headQuaters);
				pstmt.setString(10, smsUrl);
				pstmt.setString(11, smsUsername);
				pstmt.setString(12, smsPassword);
				pstmt.setString(13, tripCreationType);
				pstmt.executeUpdate();
				updated = pstmt.executeUpdate();
				if (updated > 0) {
					message = "success";
				}else{
					message = "error";
				}
				
			} // end of try
			catch (Exception e) {
				e.printStackTrace();
			} finally {
				DBConnection.releaseConnectionToDB(con, pstmt, rs);			
			}
			return message;
			
		}
	public JSONArray getTripConfigurationDetails() {
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject = new JSONObject();
		Connection con=null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;

		try {
			con = DBConnection.getConnectionToDB("AMS");
			jsonArray = new JSONArray();
			jsonObject = new JSONObject();
			pstmt = con.prepareStatement(SemiAutoTripStatements.GET_TRIP_CONFIGURATION);
			//pstmt.setInt(1, systemId);
	        rs = pstmt.executeQuery();	
			while (rs.next()) {
				jsonObject = new JSONObject();
				jsonObject.put("sId", rs.getString("SYSTEM_ID"));
				jsonObject.put("cId", rs.getString("CUSTOMER_ID"));
				jsonObject.put("tripStart", rs.getString("TRIP_START_CRITERIA"));
				jsonObject.put("tripEnd", rs.getString("TRIP_END_CRITERIA"));
				jsonObject.put("tripStartParam", rs.getString("TRIP_START_CRITERIA_PARAM"));
				jsonObject.put("tripEndParam", rs.getString("TRIP_END_CRITERIA_PARAM"));
				jsonObject.put("routType", rs.getString("ROUTE_TYPE"));
				
				jsonObject.put("smsUrl", rs.getString("SMS_URL"));
				jsonObject.put("smsUserName", rs.getString("SMS_USERNAME"));
				jsonObject.put("smsPassword", rs.getString("SMS_PASSWORD"));
				
				jsonArray.put(jsonObject);	
			}
		} // end of try
		catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);			
		}
		return jsonArray;
	}
	
	public JSONObject getTripConfiguration(Connection con,Integer systemId,Integer customerId) {
		JSONObject jsonObject = null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;

		try {
			
			pstmt = con.prepareStatement(SemiAutoTripStatements.GET_TRIP_CONFIGURATION_BY_SYSTEM_AND_CUSTOMER_ID);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, customerId);
	        rs = pstmt.executeQuery();	
			if (rs.next()) {
				jsonObject = new JSONObject();
				jsonObject.put("sId", rs.getString("SYSTEM_ID"));
				jsonObject.put("cId", rs.getString("CUSTOMER_ID"));
				jsonObject.put("tripStart", rs.getString("TRIP_START_CRITERIA"));
				jsonObject.put("tripEnd", rs.getString("TRIP_END_CRITERIA"));
				jsonObject.put("tripStartParam", rs.getString("TRIP_START_CRITERIA_PARAM"));
				jsonObject.put("tripEndParam", rs.getString("TRIP_END_CRITERIA_PARAM"));
				jsonObject.put("routType", rs.getString("ROUTE_TYPE"));
				
				jsonObject.put("smsUrl", rs.getString("SMS_URL"));
				jsonObject.put("smsUserName", rs.getString("SMS_USERNAME"));
				jsonObject.put("smsPassword", rs.getString("SMS_PASSWORD"));
				
				jsonObject.put("mtmBufferMins", rs.getString("MTM_BUFFER_MINS"));
				jsonObject.put("mtmBufferDays", rs.getString("MTM_BUFFER_DAYS"));
				jsonObject.put("mtmSMSBufferMins", rs.getString("MTM_SMS_BUFFER_MINS"));
				
				jsonObject.put("enableMTM",rs.getString("ENABLE_MTM"));
				jsonObject.put("enableCustCollection",rs.getString("ENABLE_COLLECTION"));
				jsonObject.put("enableBorderAlert",rs.getString("ENABLE_BORDER_ALERT"));
				return jsonObject;
			}
		} 
		catch (Exception e) {
			e.printStackTrace();
		} 
		return jsonObject;
	}
	public JSONArray getTripConfiguration(Integer systemId,Integer customerId) {
		Connection con = null;
		try{
			con = DBConnection.getConnectionToDB("AMS");
			JSONArray jsonArray = new JSONArray();
			return jsonArray.put(getTripConfiguration(con,systemId,customerId));
		}catch (Exception e) {
			e.printStackTrace();
		}
		finally {
			if(con!=null){
				try {
					con.close();
				} catch (SQLException e) {
					e.printStackTrace();
				}
			}
		}
		return null;
	}

	public JSONArray getTripCustomer(int clientId, int systemId) {
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		try {
			con = DBConnection.getConnectionToDB("AMS");
			jsonArray = new JSONArray();
			jsonObject = new JSONObject();
			pstmt = con.prepareStatement(SemiAutoTripStatements.GET_TRIP_CUSTOMERS);
			pstmt.setInt(1, clientId);
			pstmt.setInt(2, systemId);
			rs = pstmt.executeQuery();

			while (rs.next()) {
				jsonObject = new JSONObject();
				jsonObject.put("CustId", rs.getString("ID"));
				jsonObject.put("CustName", rs.getString("NAME"));
				jsonArray.put(jsonObject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jsonArray;
	}
	
	public String updateMapViewSettings(List mapViewSettingList,Integer systemId, Integer customerId){
		Connection con=null;
		con = DBConnection.getConnectionToDB("AMS");
		PreparedStatement pstmt = null;
		ResultSet rs= null;
		try {
			pstmt = con.prepareStatement(SemiAutoTripStatements.DELETE_FROM_MAP_VIEW_SETTINGS);
			pstmt.executeUpdate();
		}catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}
	
	public JSONArray getMapViewSettings(Integer systemId, Integer customerId,String zone){
		Connection con=null;
		con = DBConnection.getConnectionToDB("AMS");
		PreparedStatement pstmt = null;
		ResultSet rs= null;
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject = null;
		try {
			pstmt = con.prepareStatement(SemiAutoTripStatements.SELECT_FROM_MAP_VIEW_SETTINGS.replace("#", zone));
			pstmt.setInt(1, systemId);
			pstmt.setInt(2,customerId);
			rs = pstmt.executeQuery();
			while(rs.next()){
				
				jsonObject = new JSONObject();
				jsonObject.put("alertType", rs.getString("ALERT_TYPE"));
				jsonObject.put("duration",  cf.convertMinutesToHHMMFormat(Integer.parseInt(rs.getString("DURATION"))));
				jsonObject.put("iconColour", rs.getString("ICON_COLOUR"));
				jsonObject.put("blink", rs.getString("BLINK"));
				jsonObject.put("region", rs.getString("NAME"));
				jsonObject.put("hubId", rs.getString("REGION"));
				jsonObject.put("blinkDuration", Integer.parseInt(rs.getString("BLINK_DURATION"))== 0 ? 0:cf.convertMinutesToHHMMFormat(Integer.parseInt(rs.getString("BLINK_DURATION"))) );
				jsonArray.put(jsonObject);
			}
		}catch (Exception e) {
			e.printStackTrace();
		}
		return jsonArray;
	}
	
	public String saveMapViewSettings(List mapViewSettingList,Integer systemId, Integer customerId, String zone){
			Connection con=null;
			con = DBConnection.getConnectionToDB("AMS");
			PreparedStatement pstmt = null;
			ResultSet rs= null;
			String message = "Failed";
			
			try {
				//check if setting already exists for this system id and customer is
				 pstmt = con.prepareStatement(SemiAutoTripStatements.SELECT_FROM_MAP_VIEW_SETTINGS.replace("#", zone));
				 pstmt.setInt(1, systemId);
				 pstmt.setInt(2,customerId);
				 rs = pstmt.executeQuery();
				 if(rs.next()){
					 pstmt = con.prepareStatement(SemiAutoTripStatements.DELETE_FROM_MAP_VIEW_SETTINGS);
					 pstmt.setInt(1, systemId);
					 pstmt.setInt(2, customerId);
					 pstmt.executeUpdate();
				 }
				 for(int i=0; i <mapViewSettingList.size(); i++){ 
			 		LinkedTreeMap mapViewSetting = (LinkedTreeMap)mapViewSettingList.get(i);
			 		con = DBConnection.getConnectionToDB("AMS");
			 		//INSERT INTO [AMS].[dbo].[MAP_VIEW_SETTINGS] (ALERT_TYPE, DURATION ,ICON_COLOUR ,BLINK ,REGION ,SYSTEM_ID,CUSTOMER_ID) VALUES (?,?,?,?,?,?,?)
					pstmt = con.prepareStatement(SemiAutoTripStatements.INSERT_INTO_MAP_VIEW_SETTINGS);
					pstmt.setString(1, (String)mapViewSetting.get("alertType"));
					pstmt.setString(2, String.valueOf(cf.convertHHMMToMinutes1((String)mapViewSetting.get("duration"))));
					pstmt.setString(3, (String)mapViewSetting.get("iconColour"));
					pstmt.setString(4, (String)mapViewSetting.get("blink"));
					pstmt.setString(5, (String)mapViewSetting.get("hubId"));
					pstmt.setString(6, String.valueOf(cf.convertHHMMToMinutes1((String)mapViewSetting.get("blinkDuration"))));
					pstmt.setInt(7, systemId);
					pstmt.setInt(8, customerId);
					pstmt.executeUpdate();
				 }
				 
				 message = "Success";
			}
			catch (Exception e) {
				e.printStackTrace();
			} 
			finally {
				DBConnection.releaseConnectionToDB(con, pstmt, rs);
			}
			return message;
		}
}
