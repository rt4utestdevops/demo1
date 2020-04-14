package t4u.functions;

import java.awt.image.BufferedImage;
import java.io.File;
import java.io.FileOutputStream;
import java.io.OutputStream;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Properties;
import java.util.Set;

import javax.imageio.IIOImage;
import javax.imageio.ImageIO;
import javax.imageio.ImageWriteParam;
import javax.imageio.ImageWriter;
import javax.imageio.stream.ImageOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import org.json.JSONArray;
import org.json.JSONObject;

import com.google.gson.internal.LinkedTreeMap;

import t4u.beans.ReportHelper;
import t4u.common.ApplicationListener;
import t4u.common.DBConnection;
import t4u.statements.CommonStatements;
import t4u.statements.CreateTripStatement;
import t4u.statements.GeneralVerticalStatements;
import t4u.util.TemperatureConfiguration;
import t4u.util.TemperatureConfigurationBean;

public class CreateTripFunction {
	GeneralVerticalStatements gf=new GeneralVerticalStatements();
	SimpleDateFormat sdfFormatDate = new SimpleDateFormat("MM/dd/yyyy HH:mm:ss");
	SimpleDateFormat sdfyyyymmddhhmmss=new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
	SimpleDateFormat sdfyyyymmdd=new SimpleDateFormat("dd-MM-yyyy");
	SimpleDateFormat sdfmmddyyyyhhmmss=new SimpleDateFormat("MM/dd/yyyy HH:mm:ss");
	SimpleDateFormat sdfddmmyyyy = new SimpleDateFormat("dd/MM/yyyy");
	SimpleDateFormat sdfmmddyyyy = new SimpleDateFormat("MM/dd/yyyy");
	SimpleDateFormat sfddMMYYYY = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
	SimpleDateFormat yyyymmdd = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	SimpleDateFormat ddmmyyyy = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
	CommonFunctions cf = new CommonFunctions();
	CTDashboardFunctions ctf = new CTDashboardFunctions();
	DecimalFormat doubleformat = new DecimalFormat("#.##");
	DecimalFormat singleformat = new DecimalFormat("#.#");
	
	public static Object lock = new Object();
	public JSONArray getCustomer(int cutomerId, int systemId) {

		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject = new JSONObject();
		Connection con=null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		PreparedStatement pstmt1=null;
		ResultSet rs1=null;
		Properties properties = null;
		try{
			properties = ApplicationListener.prop;
			con = DBConnection.getConnectionToDB("AMS");
			jsonArray = new JSONArray();
			jsonObject = new JSONObject();
			pstmt = con.prepareStatement(CreateTripStatement.GET_CUSTOMER_NAMES);
			pstmt.setInt(1,cutomerId);
			pstmt.setInt(2,systemId);
			rs=pstmt.executeQuery();
			//jsonObject = new JSONObject();
			//jsonObject.put("CustId", 0);
			//jsonObject.put("CustName", "-- select customer --");
			//jsonArray.put(jsonObject);	
			while(rs.next()){
				jsonObject = new JSONObject();
				jsonObject.put("CustId", rs.getString("ID"));
				jsonObject.put("CustName", rs.getString("NAME"));
				jsonArray.put(jsonObject);				
			}
			/*
			 *  routeApiSystemIdList contains systemId Which needs to do dry Run  and
			 *   super Trip Customer Id Role will Generate in trip customer drop down as Admin_<logincustomerName> 
			 *  
			 *  
			 * 
			 */
			String systemIds = properties.getProperty("routeApiSystemIdList");
			List<String> idList = new ArrayList<String>(Arrays.asList(systemIds.split(",")));
			
			if(rs!=null && idList.contains(String.valueOf(systemId))){
				pstmt1 = con.prepareStatement("select NAME from ADMINISTRATOR.dbo.CUSTOMER_MASTER where SYSTEM_ID=? and CUSTOMER_ID=? ");
				pstmt1.setInt(1,systemId);
				pstmt1.setInt(2,cutomerId);
				rs1=pstmt1.executeQuery();
				if(rs1.next()){
					jsonObject = new JSONObject();
					jsonObject.put("CustId", 99999);
					jsonObject.put("CustName", "ADMIN_"+rs1.getString("NAME"));
					jsonArray.put(jsonObject);
				}
			}
		}catch(Exception e){
			System.out.println("Error in getCustomer "+e.toString());
		}	
		finally{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
			DBConnection.releaseConnectionToDB(null, pstmt1, rs1);
		}	
		return jsonArray;
	
	}
	public JSONArray getCustomerType(int clientId,int systemid) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject = null;
		try{
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(CreateTripStatement.GET_CUSTOMER_TYPE);
			pstmt.setInt(1,clientId);
			pstmt.setInt(2,systemid);
			rs=pstmt.executeQuery();
			jsonObject = new JSONObject();
			jsonObject.put("custypevalue", "Select type");
			jsonArray.put(jsonObject);	
			while(rs.next()){
				jsonObject = new JSONObject();
				jsonObject.put("custypevalue", rs.getString("TYPE"));
				jsonArray.put(jsonObject);	
			}
		}catch(Exception e){
			e.printStackTrace();
		}	
		finally{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}	
		return jsonArray;
	}
	public JSONArray getRoutenames(int cutomerId, int systemId, int clientId, int userId, String legConcept, String hubAssociatedRoutes) {

		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject = null;
		Connection con=null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		
		try{
			con = DBConnection.getConnectionToDB("AMS");
			jsonArray = new JSONArray();
			jsonObject = new JSONObject();
			if(!legConcept.equalsIgnoreCase("Y")){
				if(hubAssociatedRoutes.equalsIgnoreCase("Y")){
					pstmt = con.prepareStatement(CreateTripStatement.GET_ROUTE_NAMES_MLL);
					pstmt.setInt(1,systemId);
					pstmt.setInt(2,clientId);
					pstmt.setInt(3,systemId);
					pstmt.setInt(4,userId);
				}else{
					pstmt = con.prepareStatement(CreateTripStatement.GET_ALL_ROUTE_NAMES);
					pstmt.setInt(1,systemId);
					pstmt.setInt(2,clientId);
					//pstmt.setInt(3,systemId);
					//pstmt.setInt(4,userId);
				}

			}else{
				pstmt = con.prepareStatement(CreateTripStatement.GET_ROUTE_NAMES);
				pstmt.setInt(1,systemId);
				pstmt.setInt(2,cutomerId);
				pstmt.setInt(3,clientId);
			}
			rs=pstmt.executeQuery();
			
			jsonObject = new JSONObject();
			jsonObject.put("RouteId", "");
			jsonObject.put("RouteName", "-- select route name --");
			jsonObject.put("legCount", 0);
			jsonArray.put(jsonObject);	
			while(rs.next()){
				jsonObject = new JSONObject();
				jsonObject.put("RouteId", rs.getString("routeId"));
				jsonObject.put("RouteName", rs.getString("routeName"));
				jsonObject.put("legCount", rs.getInt("legCount"));
				jsonArray.put(jsonObject);				
			}
		}catch(Exception e){
			e.printStackTrace();
		}	
		finally{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}	
		return jsonArray;
	
	}
	
	public JSONArray getVehiclesAndGroupForClient(int systemId, int clientId,int userId, String productLine, String vehicleReporting, String date) {
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject = new JSONObject();
		Connection con=null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;

		try {
			con = DBConnection.getConnectionToDB("AMS");
			jsonArray = new JSONArray();
			jsonObject = new JSONObject();
		
			if(productLine.equalsIgnoreCase("TCL")|| productLine.equalsIgnoreCase("Chiller") || productLine.equalsIgnoreCase("Freezer"))//|| productLine.equalsIgnoreCase("Freezer"))
			{
				pstmt = con.prepareStatement(CreateTripStatement.GET_VEHICLE_FOR_CLIENT_PRODUCT_LINE);
				pstmt.setInt(1, systemId);
				pstmt.setInt(2, clientId);
				pstmt.setInt(3, userId);
			}

			else
			{
				if (vehicleReporting.equalsIgnoreCase("Y")){
					pstmt = con.prepareStatement(CreateTripStatement.GET_VEHICLES_FROM_VEHICLE_REPORTING);
					pstmt.setString(1, date);
					pstmt.setInt(2, systemId );
					pstmt.setInt(3, clientId);
					
				}else{
					pstmt = con.prepareStatement(CreateTripStatement.GET_VEHICLE_FOR_CLIENT);
					pstmt.setInt(1, systemId);
					pstmt.setInt(2, clientId);
					pstmt.setInt(3, userId);
				}						        
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
	
	public ArrayList<Object> getTripScheduleAndActualTime(int systemId, int customerId, String startDate,
			String endDate, int offset, int userId) {
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		ArrayList<Object> finlist = new ArrayList<Object>();
		SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm");
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(CreateTripStatement.GET_TRIP_SCHEDULE_ACTUAL_TIME_DETAILS);
			pstmt.setInt(1, offset);
			pstmt.setInt(2, offset);
			pstmt.setInt(3, offset);
			pstmt.setInt(4, offset);
			pstmt.setInt(5, offset);
			pstmt.setInt(6, offset);
			pstmt.setInt(7, systemId);
			pstmt.setInt(8, customerId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				jsonObject = new JSONObject();
				jsonObject.put("id", rs.getInt("ID"));
				jsonObject.put("tripNameIndex", rs.getString("ORDER_ID"));

				if (rs.getTimestamp("STP") != null)
					jsonObject.put("STP", sdf.format(rs.getTimestamp("STP")));
				else
					jsonObject.put("STP", "");

				if (rs.getTimestamp("ATP") != null)
					jsonObject.put("ATP", sdf.format(rs.getTimestamp("ATP")));
				else
					jsonObject.put("ATP", "");

				if (rs.getTimestamp("STD") != null)
					jsonObject.put("STD", sdf.format(rs.getTimestamp("STD")));
				else
					jsonObject.put("STD", "");

				if (rs.getTimestamp("ATD") != null)
					jsonObject.put("ATD", sdf.format(rs.getTimestamp("ATD")));
				else
					jsonObject.put("ATD", "");

				if (rs.getTimestamp("STA") != null)
					jsonObject.put("STA", sdf.format(rs.getTimestamp("STA")));
				else
					jsonObject.put("STA", "");

				if (rs.getTimestamp("ATA") != null)
					jsonObject.put("ATA", sdf.format(rs.getTimestamp("ATA")));
				else
					jsonObject.put("ATA", "");

				jsonObject.put("remarks", rs.getString("TRIP_REMARKS"));
				jsonObject.put("vehicleNo", rs.getString("ASSET_NUMBER"));

				jsonArray.put(jsonObject);
			}
			finlist.add(jsonArray);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return finlist;
	}
	public ArrayList < Object > getTripDetailsDHL(int systemId, int customerId,String startDate,String endDate,int offset, int userId, String sessionId, String serverName,String statusType,String vehicleNo) {
		JSONArray JsonArray = new JSONArray();
	    JSONObject JsonObject = null;
	    Connection con = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
	    PreparedStatement pstmt1 = null;
	    ResultSet rs1 = null;
	    ArrayList<String> tableNames = new ArrayList<String>();
	    ArrayList < Object > finlist = new ArrayList < Object > ();
	    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm");
	    
	    String condition = "";
	    String vehicleCondition = "";
	    
	    if(statusType.equalsIgnoreCase("OPEN")){
	    	condition = "and a.STATUS = 'OPEN'";
	    }else if(statusType.equalsIgnoreCase("CLOSED")){
	    	condition = "and a.STATUS = 'CLOSED'";
	    }else if(statusType.equalsIgnoreCase("CANCELLED")){
	    	condition = "and a.STATUS = 'CANCEL'";
	    }else if(statusType.equalsIgnoreCase("UPCOMING")){
	    	condition = "and a.STATUS = 'UPCOMING'";
	    }
	    
	    if(!vehicleNo.equals("All")){
	    	vehicleCondition = " and a.ASSET_NUMBER = '" + vehicleNo + "'" ;
	    }
	    
	    try {
	    	int count = 0;
	        con = DBConnection.getConnectionToDB("AMS");
	        List<String> tripSheeSetting = getTripSheetSettingData(systemId,customerId);
	        boolean isMaterialClient = (tripSheeSetting.get(7)!= null && tripSheeSetting.get(7).equals("Y"))? true:false;
	        if(isMaterialClient){
	        	pstmt = con.prepareStatement(CreateTripStatement.GET_TRIP_DETAILS_MATERIAL_CLIENT.replace("#", condition.concat(vehicleCondition)));
	        }else{
	        	pstmt = con.prepareStatement(CreateTripStatement.GET_TRIP_DETAILS.replace("#", condition.concat(vehicleCondition)));
	        }
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
	            
	            JsonObject.put("plannedDateTimeIndex",rs.getTimestamp("TRIP_START_TIME") == null ? "" : sdf.format(rs.getTimestamp("TRIP_START_TIME"))); 
	            
	            JsonObject.put("customerNameIndex",rs.getString("CUSTOMER_NAME"));
	            
	            JsonObject.put("orderIdIndex",rs.getString("ORDER_ID"));
	            
	            JsonObject.put("custRefIdIndex",rs.getString("CUSTOMER_REF_ID"));
	            
	            JsonObject.put("statusDataIndex", rs.getString("STATUS"));
	            
	            JsonObject.put("avgSpeedIndex", rs.getDouble("avgSpeed"));
            
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
            		//tblData = tblData + "<tr><td>"+rs1.getString("DISPLAY_NAME") +":"+rs1.getString("MIN_NEGATIVE_TEMP")+","+rs1.getString("MAX_NEGATIVE_TEMP")+","+rs1.getString("MIN_POSITIVE_TEMP")+","+rs1.getString("MAX_POSITIVE_TEMP")+"</td></tr>";
            	}
            	 tblData = tblData.length() > 0 ? tblData : "N/A";
            	JsonObject.put("tempRangeDataIndex", "<table style='white-space: nowrap;'>"+tblData+"</table> ");
            	
            	pstmt1.close();
            	rs1.close();
	            
	            String atd = "";
	            if(rs.getString("STATUS").equals("OPEN")){
	            	if(rs.getString("ACTUAL_TRIP_START_TIME")==null){
	            		atd = "";
	            		JsonObject.put("actionIndex", "<button data-toggle='modal'  onclick='getTripCancellationRemarks();' class='btn btn-warning' disabled style='background-color:#da2618; border-color:#da2618;'>Cancel</button> " );
	            		JsonObject.put("modifyIndex", "<button data-toggle='modal'  class='btn btn-warning' style='background-color:#158e1a; border-color:#158e1a;'>Modify</button> " );
	            		JsonObject.put("changeRouteIndex", "<button  data-toggle='modal' class='btn btn-warning' disabled style='background-color:#337ab7; border-color:#337ab7;'>Change Route</button> " );
	            		JsonObject.put("swapVehicleIndex", "<button  data-toggle='modal' class='btn btn-warning' disabled style='background-color:#337ab7; border-color:#337ab7;'>Swap Vehicle</button> " );
	            	}else{
	            		atd = sdf.format(rs.getTimestamp("ACTUAL_TRIP_START_TIME"));
	            		JsonObject.put("actionIndex", "<button data-toggle='modal' onclick='loadTripDetails();'  class='btn btn-warning' id='close"+rs.getInt("ID")+"'style='background-color:#da2618; border-color:#da2618;'>Close</button> " );
	            		JsonObject.put("modifyIndex", "<button data-toggle='modal'  class='btn btn-warning' style='background-color:#158e1a; border-color:#158e1a;'>Modify</button> " );
	            		JsonObject.put("changeRouteIndex", "<button  data-toggle='modal' class='btn btn-warning' style='background-color:#337ab7; border-color:#337ab7;'>Change Route</button> " );
	            		JsonObject.put("swapVehicleIndex", "<button  data-toggle='modal' class='btn btn-warning' style='background-color:#337ab7; border-color:#337ab7;'>Swap Vehicle</button> " );
	            	}
	            }else if(rs.getString("STATUS").equals("CLOSED")){
	            	JsonObject.put("actionIndex", "<button data-toggle='modal' onclick='loadTripDetails();' class='btn btn-warning'  id='close"+rs.getInt("ID")+"'style='background-color:#da2618; border-color:#da2618;'>Re open</button> " );
	            	JsonObject.put("modifyIndex", "<button data-toggle='modal'  class='btn btn-warning' style='background-color:#158e1a; border-color:#158e1a;'>View</button> " );
	            	JsonObject.put("changeRouteIndex", "<button  data-toggle='modal' class='btn btn-warning' disabled style='background-color:#337ab7; border-color:#337ab7;'>Change Route</button> " );
	            	JsonObject.put("swapVehicleIndex", "<button  data-toggle='modal' class='btn btn-warning' disabled style='background-color:#337ab7; border-color:#337ab7;'>Swap Vehicle</button> " );
	            }else if(rs.getString("STATUS").equals("UPCOMING")){
	            	JsonObject.put("actionIndex", "<button data-toggle='modal'  onclick='getTripCancellationRemarks();' class='btn btn-warning' disabled style='background-color:#da2618; border-color:#da2618;'>Cancel</button> " );
            		JsonObject.put("modifyIndex", "<button data-toggle='modal'  class='btn btn-warning' style='background-color:#158e1a; border-color:#158e1a;'>Modify</button> " );
            		JsonObject.put("changeRouteIndex", "<button  data-toggle='modal' class='btn btn-warning' disabled style='background-color:#337ab7; border-color:#337ab7;'>Change Route</button> " );
            		JsonObject.put("swapVehicleIndex", "<button  data-toggle='modal' class='btn btn-warning' disabled style='background-color:#337ab7; border-color:#337ab7;'>Swap Vehicle</button> " );
	            } else {
	            	JsonObject.put("actionIndex", "<button onclick='cancleTrip()' class='btn btn-warning' disabled style='background-color:#da2618; border-color:#da2618;'>Cancelled</button> " );
	            	JsonObject.put("modifyIndex", "<button  data-toggle='modal'  class='btn btn-warning' style='background-color:#158e1a; border-color:#158e1a;'>View</button> " );
	            	JsonObject.put("changeRouteIndex", "<button  data-toggle='modal' class='btn btn-warning' disabled style='background-color:#337ab7; border-color:#337ab7;'>Change Route</button> " );
	            	JsonObject.put("swapVehicleIndex", "<button  data-toggle='modal' class='btn btn-warning' disabled style='background-color:#337ab7; border-color:#337ab7;'>Swap Vehicle</button> " );
	            }
	            JsonObject.put("preLoadTempIndex", rs.getString("preLoadTemp"));
	            JsonObject.put("routeIdIndex", rs.getInt("routeId"));
	            JsonObject.put("productLineIndex", rs.getString("productLine"));
	            JsonObject.put("atdIndex", atd);
	            JsonObject.put("tripCustId", rs.getString("tripCustId"));
	            JsonObject.put("sealNoIndex",rs.getString("SEAL_NO"));
	            JsonObject.put("noOfBagsIndex", rs.getInt("NO_OF_BAGS"));
	            JsonObject.put("tripTypeIndex", rs.getString("TRIP_TYPE"));
	            JsonObject.put("noOfFluidBagsIndex", rs.getInt("NO_OF_FLUID_BAGS"));
	            JsonObject.put("openingKmsIndex", doubleformat.format(rs.getFloat("OPENING_KMS")));
	            JsonObject.put("tripRemarksIndex", rs.getString("TRIP_REMARKS"));
	            JsonObject.put("cancelledRemarks", rs.getString("CANCELLED_REMARKS"));
	            JsonObject.put("category", rs.getString("CATEGORY").length() > 0 ? rs.getString("CATEGORY") : "--select category--");
	            JsonObject.put("STA", sdf.format(rs.getTimestamp("STA")));
	            if(rs.getTimestamp("ATA") != null){
	            	JsonObject.put("ATA", sdf.format(rs.getTimestamp("ATA")));
	            }else{
	            	JsonObject.put("ATA","");
	            }
	            JsonObject.put("overriddenBy", rs.getString("OVERRIDDEN_BY"));
	            if(rs.getTimestamp("OVERRIDDEN_DATETIME") != null){
	            	JsonObject.put("overriddenDate", sdf.format(rs.getTimestamp("OVERRIDDEN_DATETIME")));
	            }else{
	            	JsonObject.put("overriddenDate", "");
	            }
	            JsonObject.put("overriddenRemarks", rs.getString("OVERRIDDEN_REMARKS"));
	            if (rs.getTimestamp("ACTUAL_TRIP_END_TIME") != null){
	            	
	            }
	            JsonObject.put("actualTripEndTime", rs.getTimestamp("ACTUAL_TRIP_END_TIME") != null ? sdf.format(rs.getTimestamp("ACTUAL_TRIP_END_TIME")): "");
	            JsonObject.put("actionByDate", rs.getTimestamp("CANCELLED_DATE") != null ? rs.getString("CANCELLED_BY") + "-"+  sdf.format(rs.getTimestamp("CANCELLED_DATE")): "");
	            if(isMaterialClient){
	            	JsonObject.put("routeTemplateName", rs.getString("TEMPLATE_NAME"));
	            	JsonObject.put("materialName", rs.getString("MATERIAL_NAME"));
	            	JsonObject.put("totalTAT", cf.formattedDaysHoursMinutes(rs.getLong("TotalTAT")*60000));
	            	JsonObject.put("totalRunTime", cf.formattedDaysHoursMinutes(rs.getLong("TotalRunTime")*60000));
	            }else{
	            	JsonObject.put("routeTemplateName", "");
	            	JsonObject.put("materialName", "");
	            	JsonObject.put("totalTAT", "");
	            	JsonObject.put("totalRunTime", "");
	            }
	            JsonObject.put("stpIndex", rs.getTimestamp("STP") != null ? sdf.format(rs.getTimestamp("STP")): "");
	            JsonObject.put("atpIndex", rs.getTimestamp("ATP") != null ? sdf.format(rs.getTimestamp("ATP")): "");
	            JsonArray.put(JsonObject);
	        }
	        tableNames.add("Select"+"##"+"dbo.TRACK_TRIP_DETAILS");
	        
	        try{ // commented as multiple records insert in audit logs
	        	//cf.insertDataIntoAuditLogReport(sessionId, tableNames, "Trip Solution", "View Trips", userId, serverName, systemId, customerId, remarks);
	        }catch(Exception e){
	        	e.printStackTrace();
	        }
	        finlist.add(JsonArray);
	    	} catch (Exception e) {
	        e.printStackTrace();
	    	} finally {
	        DBConnection.releaseConnectionToDB(con, pstmt, rs);
	        DBConnection.releaseConnectionToDB(null, pstmt1, rs1);
	    }
	    return finlist;
	}
	
	public String closeTrip(int systemId,int clientId, int userID,int uniqueId,String status){
		Connection con=null;
		PreparedStatement pstmt=null;
		PreparedStatement pstmt1=null;
		PreparedStatement pstmt2=null;
		ResultSet rs = null;
		String message="";
		 try {
		con = DBConnection.getConnectionToDB("AMS");
		pstmt1 = con.prepareStatement("select * from AMS.dbo.DES_TRIP_DETAILS where TRIP_ID=? and SEQUENCE=100 ");
		pstmt1.setInt(1, uniqueId);
		rs = pstmt1.executeQuery();
		if (rs.next()) {
			if (rs.getString("ACT_ARR_DATETIME")!=null && !rs.getString("ACT_ARR_DATETIME").contains("1900") && rs.getString("ACT_ARR_DATETIME")!="") {
				pstmt2 = con.prepareStatement("update AMS.dbo.DES_TRIP_DETAILS set ACT_DEP_DATETIME=getutcdate() where TRIP_ID=? and SEQUENCE=100");
				pstmt2.setInt(1, uniqueId);
				pstmt2.executeUpdate();
			}else{
				pstmt2 = con.prepareStatement(" update AMS.dbo.DES_TRIP_DETAILS set ACT_ARR_DATETIME=getutcdate(),ACT_DEP_DATETIME=getutcdate() where TRIP_ID=? and SEQUENCE=100 ");
				pstmt2.setInt(1, uniqueId);
				pstmt2.executeUpdate();
			}
		}
		
		pstmt = con.prepareStatement(CreateTripStatement.UPDATE_TO_CLOSE_TRIP);
		pstmt.setInt(1, userID);
		pstmt.setString(2, "");
		pstmt.setString(3, "");
		pstmt.setInt(4, uniqueId);
		int updated=pstmt.executeUpdate();
		if (updated > 0) {
	        message = "Trip Closed";
	    }else{
	    	 message = "Error While Closing Trip";
	    }
		 }catch (Exception e) {
			 e.printStackTrace();
		 } finally {
			 DBConnection.releaseConnectionToDB(con, pstmt, null);
			 DBConnection.releaseConnectionToDB(null, pstmt1, null);
		 }
		return message;
	}
	
	public String addTripDetails(int systemId,int custId,int userId,int routeId,String vehicleNo,String plannedDate,String alertId,String routeName,int offset,String addcustomerName,
			String custReference, String avgSpeed, String tempeartureArray,String selSensorsToAlertTrigger, String minHumidity, String maxHumidity,String preLoadTemp, String count,
			String drivers,String dateArray,String legId, String productLine, String tripCustId,String sessionId, String serverName,
			String sealNo,int noOfBags,String tripType,int noOfFluidBags,float openingKms,String tripRemarks,int routeTemplateId,int materialId,LogWriter logWriter,String category, String customerName){
    	logWriter.log("Start of CreateTripFunction.addTripDetails"+sessionId+ "::systemId :"+systemId+"::custId: "+custId+"::userId:"+userId+"::routeId:"+routeId+"::vehicleNo:"+vehicleNo+"::plannedDate:"+plannedDate+"::routeName:"+routeName 
      		  			+"::custReference:"+custReference+"::avgSpeed:"+avgSpeed
      		  			+"::productLine:"+productLine+"::tripCustId"+tripCustId+"::sessionId:"+sessionId+"::serverName:"+serverName+"::routeTemplateId:"+routeTemplateId+"::materialId:"+materialId , LogWriter.INFO);
		Connection con=null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		PreparedStatement pstmt1=null;
		ResultSet rs1=null;
		String message="";
		String startDate;
		SimpleDateFormat ddmmhhmm = new SimpleDateFormat("ddMMHHmm");
		ArrayList<String> tableList=new ArrayList<String>();
		Date date = new Date();
		String curdate = ddmmhhmm.format(date);
		int tripId=0;
		String negativeMinTemp="";
		String negativeMaxTemp="";
		String positiveMinTemp="";
		String positiveMaxTemp="";
		String arrayDriver [] = drivers.split(",");
		String arrayDate [] = dateArray.split(",");
		String arrayLeg [] = legId.split(",");
		int inserted = 0;
		String remarks = "";
		try {
			if (vehicleNo == null || vehicleNo.trim().equals("") || vehicleNo.length() ==0){
				message = "Invlaid Vehicle Number!!";
				return message;
			}
			String shipmentId="";
			String addorderId = "";
			shipmentId=routeName+"-"+vehicleNo+"-"+curdate; 
			con = DBConnection.getConnectionToDB("AMS");
			SimpleDateFormat yyyymmdd = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			SimpleDateFormat sdfFormatDate = new SimpleDateFormat("dd/MM/yyyy HH:mm");
			SimpleDateFormat sdfFormatDate1 = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
			java.util.Date start = sdfFormatDate.parse(plannedDate);
			startDate = yyyymmdd.format(start);
			
			for(int i = 0; i < Integer.parseInt(count); i++){
				String driver1 = "";
				String driver2 = "";
				String driverArr [] = arrayDriver[i].split("#");
				if(driverArr.length > 0){
					driver1 = driverArr[0];
					if(driverArr.length > 1){
						driver2 = driverArr[1];
					}
				}
				
				String dateArr []  = arrayDate[i].split("#");
				String std = dateArr[0];
				String sta = dateArr[1];
				
				Date std1 = sdfFormatDate1.parse(std);
				Date sta1 = sdfFormatDate1.parse(sta);
				ArrayList<String> driArr = new ArrayList<String>();
				driArr.add(driver1);
				driArr.add(driver2);
				for (String driver : driArr){
					if (!driver.equals("") &&Integer.parseInt(driver) != 0){
						String stmt = CreateTripStatement.VALIDATE_DRIVER_FOR_TRIP_MODIFY.replace("#", driver.equals(driver1)? "1" : "2").replace("$", "");
						pstmt = con.prepareStatement(stmt);
						pstmt.setString(1, driver);
						rs = pstmt.executeQuery();
						while(rs.next()){
							Date dbStdDate = yyyymmdd.parse(rs.getString("STD"));
							Date dbStaDate = yyyymmdd.parse(rs.getString("STA"));
							if ((std1.before(dbStaDate)) && (std1.after(dbStdDate)) || (sta1.before(dbStaDate)) && (sta1.after(dbStdDate))){
								pstmt1 = con.prepareStatement(CreateTripStatement.GET_DRIVER_NAME);
								pstmt1.setString(1, driver);
								pstmt1.setInt(2, systemId);
								rs1 = pstmt1.executeQuery();
								String driverName = "";
								if(rs1.next()){
									 driverName = rs1.getString("DRIVER_NAME");
								}
								return driverName + " Has Already Scheduled to Other Trip";
							}
						}
					}
				}
			}
			
			
			
			tableList.add("Select"+"##"+"AMS.dbo.TRACK_TRIP_DETAILS");
					
//			pstmt1 = con.prepareStatement(CreateTripStatement.GET_VEHICLE_NO_AND_ACT_ARR_DATETIME_FOR_TRIP_CREATION_VALIDATION.replace("#", ""));
//			pstmt1.setInt(1,offset);
//			pstmt1.setString(2,vehicleNo);
//			pstmt1.setInt(3,systemId);
//			pstmt1.setInt(4,custId);
			
			/* to check wheather vehicle is available for next trip or not 
			 * logic changed : Checking the status of last trip for the vehicle no if status is open can not take another trip
			 */
			pstmt1 = con.prepareStatement(CreateTripStatement.CHECK_TRIP_STATUS);
			pstmt1.setString(1,vehicleNo);
			
			rs1 = pstmt1.executeQuery();
			if(rs1.next()) {
				message = "Vehicle already on trip!!";
				return message;
				
//				String actualArrivaldDateTime = rs1.getString("ACT_ARR_DATETIME");
//				
//				if (actualArrivaldDateTime == null){
//					message = "Vehicle already in trip!!";
//					return message;
//				}else{
//					Date actualArrivaldDateTime1 = yyyymmdd.parse(actualArrivaldDateTime);
//					if(start.before( actualArrivaldDateTime1)){
//						message = "Can't Create Trip Before "+ sdfFormatDate.format(actualArrivaldDateTime1);
//						return message;
//					}
//				}
			
			}
			addorderId = getUniqueLRNo(systemId, custId, con,customerName);
			
			pstmt = con.prepareStatement(CreateTripStatement.INSERT_TRIP_DETAILS,PreparedStatement.RETURN_GENERATED_KEYS);
			pstmt.setString(1,vehicleNo);
			pstmt.setString(2,shipmentId);
			pstmt.setInt(3,offset);
			pstmt.setString(4,startDate);
			pstmt.setInt(5,systemId);
			pstmt.setInt(6,custId);
			pstmt.setInt(7,routeId);
			pstmt.setInt(8,userId);
			pstmt.setString(9,alertId);
			pstmt.setString(10,routeName);
			pstmt.setString(11,addcustomerName);
			pstmt.setString(12,addorderId);
			pstmt.setString(13,custReference);
			pstmt.setString(14, avgSpeed);
			pstmt.setString(15,negativeMinTemp);
			pstmt.setString(16,negativeMaxTemp);
			pstmt.setString(17,positiveMinTemp);
			pstmt.setString(18,positiveMaxTemp);
			pstmt.setString(19,minHumidity);
			pstmt.setString(20,maxHumidity);
			pstmt.setString(21, preLoadTemp);
			pstmt.setString(22, productLine);
			pstmt.setString(23, tripCustId);
			pstmt.setString(24, sealNo);
			pstmt.setInt(25, noOfBags);
			pstmt.setString(26, tripType);
			pstmt.setInt(27, noOfFluidBags);
			pstmt.setFloat(28, openingKms);
			pstmt.setString(29, tripRemarks);
			pstmt.setInt(30, routeTemplateId);
			pstmt.setInt(31, materialId);
			pstmt.setString(32, category);
			inserted = pstmt.executeUpdate();
		    rs = pstmt.getGeneratedKeys();
			if(rs.next())
			{
				tripId = rs.getInt(1);
				
				for(int i = 0; i < Integer.parseInt(count); i++){
					String driver1 = "";
					String driver2 = "";
					String driverArr [] = arrayDriver[i].split("#");
					if(driverArr.length > 0){
						driver1 = driverArr[0];
						if(driverArr.length > 1){
							driver2 = driverArr[1];
						}
					}
					
					String dateArr []  = arrayDate[i].split("#");
					String std = dateArr[0];
					String sta = dateArr[1];
					
					legId = arrayLeg[i];
					
					pstmt = con.prepareStatement(CreateTripStatement.INSERT_TRIP_LEG_DETAILS);
					pstmt.setInt(1,tripId);
					pstmt.setString(2,legId);
					pstmt.setInt(3,offset);
					pstmt.setString(4,yyyymmdd.format(sdfFormatDate.parse(std)));
					pstmt.setInt(5,offset);
					pstmt.setString(6,yyyymmdd.format(sdfFormatDate.parse(sta)));
					pstmt.setString(7,driver1);
					pstmt.setString(8,driver2);
					pstmt.setInt(9,userId);
					inserted = pstmt.executeUpdate();
					
					if (i == 0){  // update 1st leg  drivers to live vision once trip created
						ArrayList<String> legDrivers = new ArrayList<String>();
						legDrivers.add(driver1);
						legDrivers.add(driver2);
						String legDriver1="NA"; String legDriver2 = "NA";  String legDriver1No="NA"; String legDriver2No = "NA";
						for (String dr : legDrivers){
							if (dr.equals("")){
								dr = "0";
							}
							if (Integer.parseInt(dr) > 0){
								pstmt  = con.prepareStatement(CreateTripStatement.GET_DRIVER_NAME);
								pstmt.setString(1, dr);
								pstmt.setInt(2, systemId);
								pstmt.executeQuery();
								rs = pstmt.executeQuery();
								while(rs.next()){
									if (legDrivers.indexOf(dr) == 0){
										legDriver1 = rs.getString("DRIVER_NAME");
										legDriver1No = rs.getString("Mobile");
									}
									else{
										legDriver2 = rs.getString("DRIVER_NAME");
										legDriver2No = rs.getString("Mobile");
									}
								}
							}
						}
						updateDriversToLiveVision(legDriver1,legDriver1No,legDriver2,legDriver2No,con,vehicleNo,systemId,custId);
					}
				}
				
				cf.updateVehicleStatus(con,vehicleNo,8,tripId,logWriter);
				tableList.add("Insert"+"##"+"AMS.dbo.TRACK_TRIP_DETAILS");
				tableList.add("Insert"+"##"+"AMS.dbo.TRIP_LEG_DETAILS");
				
			
			if (productLine.equalsIgnoreCase("TCL") || productLine.equalsIgnoreCase("Chiller") || productLine.equalsIgnoreCase("Freezer")){
				JSONArray array = new JSONArray(tempeartureArray);
				List<TemperatureConfigurationBean> tempConfigDetails = TemperatureConfiguration.getTemperatureConfigurationDetails(systemId,custId,vehicleNo);
	        	 for (int i = 0 ; i < tempConfigDetails.size(); i++) {
	        		 TemperatureConfigurationBean tempObj = tempConfigDetails.get(i);
	        		 JSONObject obj = array.getJSONObject(0);
	        		String minNeg = obj.getString("minNeg");
	        		String maxNeg = obj.getString("maxNeg");
	        		String minPos = obj.getString("minPos");
	        		String maxPos = obj.getString("maxPos");
	        		
	        		pstmt1 = con.prepareStatement(CreateTripStatement.INSERT_TRIP_VEHICLE_TEMPERATURE_DETAILS);
	    			pstmt1.setInt(1,tripId);
	    			pstmt1.setString(2,vehicleNo);
	    			pstmt1.setString(3,tempObj.getName());
	    			pstmt1.setString(4,tempObj.getSensorName());
	    			pstmt1.setString(5,minNeg);
	    			pstmt1.setString(6,minPos);
	    			pstmt1.setString(7,maxNeg);
	    			pstmt1.setString(8,maxPos);
	    			if(selSensorsToAlertTrigger != null && tempObj.getSensorName() != null)
	    				pstmt1.setString(9, selSensorsToAlertTrigger.contains(tempObj.getSensorName()) ? "Y" : "N");
	    			else
	    				pstmt1.setString(9, "N");
	    			pstmt1.executeUpdate();
	        	}
			}
			
			pstmt = con.prepareStatement(CreateTripStatement.INSERT_TRACK_TRIP_DETAILS_SUB);
			pstmt.setInt(1, tripId);
			pstmt.setInt(2, userId);
			pstmt.setString(3, "Trip Created");
			pstmt.setString(4, "OPEN");
			pstmt.executeUpdate();
			remarks = "Trip :-"+addorderId+" created for "+vehicleNo+".";
		}
			try{
				cf.insertDataIntoAuditLogReport(sessionId, tableList, "Trip Solutions","Created Trip", userId, serverName, systemId, custId, remarks);
			}catch(Exception e){
				e.printStackTrace();
			}
		    if (inserted > 0) {
		        message = "Saved Successfully";
		    }else{
		    	message = "Error While Saving";
		    }
		  }
		catch (Exception e) {
			logWriter.log("Error in CreateTripFunction.addTripDetails :"+sessionId+e.getMessage(), LogWriter.ERROR);
			e.printStackTrace();
			
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
			DBConnection.releaseConnectionToDB(null, pstmt1, rs1);
		}
		logWriter.log("End of CreateTripFunction.addTripDetails :"+sessionId+"::message:"+message+"::tripId:"+tripId, LogWriter.INFO);
		return message+","+tripId;

	}
	public String modifyTripDetails(int systemId,int custId,int userId,String plannedDate,int offset,int tripId, String preLoadTemp, String count,
			String drivers, String dates, String legId, String sessionId, String serverName,String modifyAvgSpeed,LogWriter logWriter ,String vehicleNo,String routeId, String custRefId, String category,String productLine,String routeName,String tempData,String selSensorsToAlertTrigger){
			//String sealNo,int noOfBags,String tripType,int noOfFluidBags,float openingKms,String tripRemarks) {
		logWriter.log(" Start of the CreateTripFunction.modifyTripDetails method "+sessionId+"::custId:"+"::tripId:"+tripId +"::plannedDate"+plannedDate, LogWriter.INFO);
		Connection con=null;
		PreparedStatement pstmt=null ,pstmt1=null,pstmt2=null,pstmt3=null;
		ResultSet rs=null ,rs1=null,rs2 = null;
		String message="";
		String startDate;
		String arrayDriver [] = drivers.split(",");
		String arrayDate [] = dates.split(",");
		String arrayLeg [] = legId.split(",");
		String lrNo = "";
		String shipmentId = "";
		String routeNameOld = "";
		SimpleDateFormat ddmmhhmm = new SimpleDateFormat("ddMMHHmm");
		String curdate = ddmmhhmm.format(new Date());
		boolean dateEdited = true;
		ArrayList<String> tableNames = new ArrayList<String>();
		String Remarks = "";
		try {
			if (vehicleNo == null || vehicleNo.trim().equals("") || vehicleNo.length() ==0){
				message = "Invlaid Vehicle Number!!";
				return message;
			}
			if (routeId == null || routeId.trim().equals("") || routeId.length() ==0){
				message = "Invlaid Route!!";
				return message;
			}
			if (routeName == null || routeName.trim().equals("") || routeName.length() ==0){
				message = "Invlaid Route!!";
				return message;
			}
			Integer routeIdOld = null;
			String vehicleNoOld = "";
			con = DBConnection.getConnectionToDB("AMS");
			SimpleDateFormat yyyymmdd = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			SimpleDateFormat sdfFormatDate = new SimpleDateFormat("dd/MM/yyyy HH:mm");
			SimpleDateFormat sdfFormatDate1 = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
			
			java.util.Date start = sdfFormatDate.parse(plannedDate);
			startDate = yyyymmdd.format(start);
			
			for(int i = 0; i < Integer.parseInt(count); i++){
				String driver1 = "";
				String driver2 = "";
				String driverArr [] = arrayDriver[i].split("#");
				if(driverArr.length > 0){
					driver1 = driverArr[0];
					if(driverArr.length > 1){
						driver2 = driverArr[1];
					}
				}
				
				String dateArr []  = arrayDate[i].split("#");
				String std = dateArr[0];
				String sta = dateArr[1];
				
				Date std1 = sdfFormatDate1.parse(std);
				Date sta1 = sdfFormatDate1.parse(sta);
				ArrayList<String> driArr = new ArrayList<String>();
				driArr.add(driver1);
				driArr.add(driver2);
				for (String driver : driArr){
					if (!driver.equals("") &&Integer.parseInt(driver) != 0){
						String stmt = CreateTripStatement.VALIDATE_DRIVER_FOR_TRIP_MODIFY.replace("#", driver.equals(driver1)? "1" : "2").replace("$", "and TRIP_ID != ?");
						pstmt = con.prepareStatement(stmt);
						pstmt.setString(1, driver);
						pstmt.setInt(2, tripId);
						rs = pstmt.executeQuery();
						while(rs.next()){
							Date dbStdDate = yyyymmdd.parse(rs.getString("STD"));
							Date dbStaDate = yyyymmdd.parse(rs.getString("STA"));
							if ((std1.before(dbStaDate)) && (std1.after(dbStdDate)) || (sta1.before(dbStaDate)) && (sta1.after(dbStdDate))){
								pstmt1 = con.prepareStatement(CreateTripStatement.GET_DRIVER_NAME);
								pstmt1.setString(1, driver);
								pstmt1.setInt(2, systemId);
								rs1 = pstmt1.executeQuery();
								String driverName = "";
								if(rs1.next()){
									 driverName = rs1.getString("DRIVER_NAME");
								}
								return driverName + " Has Already Scheduled to Other Trip";
							}
						}
					}
				}
			}
				
			
			pstmt2 = con.prepareStatement(CreateTripStatement.GET_ROUTE_ID_AND_VEHICLE_NUMBER_BY_TRIP_ID);
			pstmt2.setInt(1, tripId);
			pstmt2.setInt(2, systemId);
			pstmt2.setInt(3, custId);
			rs2 = pstmt2.executeQuery();
			if(rs2.next()){
				routeIdOld = rs2.getInt("ROUTE_ID");
				vehicleNoOld = rs2.getString("ASSET_NUMBER");
				lrNo = rs2.getString("ORDER_ID");
				routeNameOld = rs2.getString("ROUTE_NAME");
				// route and vehicle changes started
				if ((Integer.parseInt(routeId) != routeIdOld) || (!vehicleNo.equalsIgnoreCase(vehicleNoOld))){
					
					if (!vehicleNo.equalsIgnoreCase(vehicleNoOld)){
						
						pstmt1 = con.prepareStatement(CreateTripStatement.CHECK_TRIP_STATUS);
						pstmt1.setString(1,vehicleNo);
						
						rs1 = pstmt1.executeQuery();
						if(rs1.next()) {
							message = "Vehicle already on trip!!";
							return message;
						}
//						pstmt1 = con.prepareStatement(CreateTripStatement.GET_VEHICLE_NO_AND_ACT_ARR_DATETIME_FOR_TRIP_CREATION_VALIDATION.replace("#", ""));
//						pstmt1.setInt(1,offset);
//						pstmt1.setString(2,vehicleNo);
//						pstmt1.setInt(3,systemId);
//						pstmt1.setInt(4,custId);
//						rs1 = pstmt1.executeQuery();
//						while(rs1.next()){
//							String actualArrivaldDateTime = rs1.getString("ACT_ARR_DATETIME");
//							
//							if (actualArrivaldDateTime == null){
//								message = "Vehicle already in trip!!";
//								return message;
//							}else{
//								Date actualArrivaldDateTime1 = yyyymmdd.parse(actualArrivaldDateTime);
//								if(start.before( actualArrivaldDateTime1)){
//									message = "Can't Create Trip Before "+ sdfFormatDate.format(actualArrivaldDateTime1);
//									return message;
//								}
//							}
//						}
					}
					shipmentId=routeName+"-"+vehicleNo+"-"+curdate; 
					pstmt3 = con.prepareStatement(CreateTripStatement.MODIFY_TRIP_DETAILS_ON_ROUTE_OR_VEHICLE_NUMBER_CHANGE);
					pstmt3.setInt(1,offset);
					pstmt3.setString(2,startDate);
					pstmt3.setInt(3,userId);
					pstmt3.setString(4, preLoadTemp);
					pstmt3.setString(5, modifyAvgSpeed);
					
					pstmt3.setInt(6, Integer.parseInt(routeId));
					pstmt3.setString(7, vehicleNo);
					pstmt3.setString(8, productLine);
					pstmt3.setString(9, custRefId);
					pstmt3.setString(10, category);
					pstmt3.setString(11, routeName);
					pstmt3.setString(12, shipmentId);
					pstmt3.setInt(13,systemId);
					pstmt3.setInt(14,custId);
					pstmt3.setInt(15 ,tripId);
					int inserted = pstmt3.executeUpdate();
					if (inserted > 0) {
						
						pstmt1 = con.prepareStatement(CreateTripStatement.DELETE_TRIP_LEG_DETAILS);
						pstmt1.setInt(1,tripId);
					    pstmt1.executeUpdate();
					    
						for(int i = 0; i < Integer.parseInt(count); i++){
							String driver1 = "";
							String driver2 = "";
							String driverArr [] = arrayDriver[i].split("#");
							if(driverArr.length > 0){
								driver1 = driverArr[0];
								if(driverArr.length > 1){
									driver2 = driverArr[1];
								}
							}
							
									String dateArr []  = arrayDate[i].split("#");
									String std = dateArr[0];
									String sta = dateArr[1];
									
									legId = arrayLeg[i];
									
									pstmt = con.prepareStatement(CreateTripStatement.INSERT_TRIP_LEG_DETAILS);
									pstmt.setInt(1,tripId);
									pstmt.setString(2,legId);
									pstmt.setInt(3,offset);
									pstmt.setString(4,yyyymmdd.format(sdfFormatDate.parse(std)));
									pstmt.setInt(5,offset);
									pstmt.setString(6,yyyymmdd.format(sdfFormatDate.parse(sta)));
									pstmt.setString(7,driver1);
									pstmt.setString(8,driver2);
									pstmt.setInt(9,userId);
									pstmt.executeUpdate();
						}
						
							pstmt1 = con.prepareStatement(CreateTripStatement.DELETE_DES_TRIP_DETAILS);
							pstmt1.setInt(1,tripId);
						    pstmt1.executeUpdate();
						    
						    
						    updateTemperature(tempData, productLine, con, tripId, vehicleNo,vehicleNoOld,systemId,custId,selSensorsToAlertTrigger);
						    
						    if ((Integer.parseInt(routeId) != routeIdOld)) {
						    	Remarks = "Modifying the trip "+ lrNo+" and leg details as Route changed from "+ routeNameOld +" to "+routeName+" ";
						    }if ((!vehicleNo.equalsIgnoreCase(vehicleNoOld))){
						    	Remarks = "Modifying the trip "+ lrNo+" and leg details as Vehicle No changed from "+vehicleNoOld+" to "+vehicleNo+"";
						    	//update vehicle status as "Vehicle Available" for old vehicle and "On Trip" for new vehicle
								cf.updateVehicleStatus(con, vehicleNoOld, 16, tripId,logWriter);
								cf.updateVehicleStatus(con, vehicleNo, 8, tripId,logWriter);
						    }if ((Integer.parseInt(routeId) != routeIdOld) && (!vehicleNo.equalsIgnoreCase(vehicleNoOld))){
						    	Remarks = "Modifying the trip "+ lrNo+" and leg details as Route changed from "+ routeNameOld +" to "+routeName+" and Vehicle No changed from "+vehicleNoOld+" to "+vehicleNo+" ";
						    }
							tableNames.add("Select"+"##"+"AMS.dbo.TRACK_TRIP_DETAILS");
							tableNames.add("Update"+"##"+"AMS.dbo.TRACK_TRIP_DETAILS");
							tableNames.add("Insert"+"##"+"AMS.dbo.TRIP_LEG_DETAILS");
							tableNames.add("Delete"+"##"+"AMS.dbo.DES_TRIP_DETAILS");
						    cf.insertDataIntoAuditLogReport(sessionId, tableNames, "Trip Solution", "Modified Trip ", userId, serverName, systemId, custId, Remarks);
						    logWriter.log(" End of the CreateTripFunction.modifyTripDetails method Upon Route / Vehicle No change "+sessionId+"::message:"+message, LogWriter.INFO);
						    message = "Updated Successfully";
					}else{
				    		message = "Error While Saving";
				    }
								// route and vehicle changes ends
				}else{
					
					pstmt = con.prepareStatement(CreateTripStatement.CHECK_DATE);
					pstmt.setInt(1, systemId);
					pstmt.setInt(2, custId);
					pstmt.setInt(3, offset);
					pstmt.setString(4, yyyymmdd.format(sdfFormatDate.parse(plannedDate)));
					rs = pstmt.executeQuery();
					if(rs.next()){
						dateEdited = false;
					}
					
					if(dateEdited){
						pstmt = con.prepareStatement(CreateTripStatement.MODIFY_TRIP_DETAILS_ON_DATE_CHANGE);
						pstmt.setInt(1,offset);
						pstmt.setString(2,startDate);
						pstmt.setInt(3,userId);
						pstmt.setString(4, preLoadTemp);
						pstmt.setString(5, modifyAvgSpeed);
						pstmt.setString(6, custRefId);
						pstmt.setString(7, category);
						pstmt.setString(8, productLine);
						pstmt.setInt(9,systemId);
						pstmt.setInt(10,custId);
						pstmt.setInt(11 ,tripId);
					    int inserted = pstmt.executeUpdate();
					    if (inserted > 0) {
					    	
							for(int i = 0; i < Integer.parseInt(count); i++){
								String driver1 = "";
								String driver2 = "";
								String driverArr [] = arrayDriver[i].split("#");
								if(driverArr.length > 0){
									driver1 = driverArr[0];
									if(driverArr.length > 1){
										driver2 = driverArr[1];
									}
								}
								
								String dateArr []  = arrayDate[i].split("#");
								String std = dateArr[0];
								String sta = dateArr[1];
								
								legId = arrayLeg[i];
								
								pstmt = con.prepareStatement(CreateTripStatement.UPDTAE_TRIP_LEG_DETAILS);
								pstmt.setInt(1, offset);
								pstmt.setString(2, yyyymmdd.format(sdfFormatDate.parse(std)));
								pstmt.setInt(3, offset);
								pstmt.setString(4, yyyymmdd.format(sdfFormatDate.parse(sta)));
								pstmt.setString(5, driver1);
								pstmt.setString(6, driver2);
								pstmt.setInt(7, tripId);
								pstmt.setString(8, legId);
								pstmt.executeUpdate();
								
								getDriverAndUpdate(tripId,legId,driver1,driver2,con,vehicleNo,systemId,custId);
							}
							
							pstmt = con.prepareStatement(CreateTripStatement.DELETE_DES_TRIP_DETAILS);
							pstmt.setInt(1,tripId);
						    pstmt.executeUpdate();
						    
						    updateTemperature(tempData, productLine, con, tripId, vehicleNo,vehicleNoOld,systemId,custId,selSensorsToAlertTrigger);
						    
							Remarks = "Modifying the trip "+ lrNo+" and leg details.";
							tableNames.add("Select"+"##"+"AMS.dbo.TRACK_TRIP_DETAILS");
							tableNames.add("Update"+"##"+"AMS.dbo.TRACK_TRIP_DETAILS");
							tableNames.add("Update"+"##"+"AMS.dbo.TRIP_LEG_DETAILS");
							tableNames.add("Delete"+"##"+"AMS.dbo.DES_TRIP_DETAILS");
							cf.insertDataIntoAuditLogReport(sessionId, tableNames, "Trip Solution", "Modified Trip", userId, serverName, systemId, custId, Remarks);
					    	message = "Updated Successfully";
						}else{
					    	message = "Error While Saving";
					    }  
				    } else {
				    	pstmt = con.prepareStatement(CreateTripStatement.MODIFY_TRIP_DETAILS);
						pstmt.setInt(1,offset);
						pstmt.setString(2,startDate);
						pstmt.setInt(3,userId);
						pstmt.setString(4, preLoadTemp);
						pstmt.setString(5, modifyAvgSpeed);
						pstmt.setString(6, custRefId);
						pstmt.setString(7, category);
						pstmt.setString(8, productLine);
						pstmt.setInt(9,systemId);
						pstmt.setInt(10,custId);
						pstmt.setInt(11 ,tripId);
					    int inserted = pstmt.executeUpdate();
					    if (inserted > 0) {
							for(int i = 0; i < Integer.parseInt(count); i++){
								String driver1 = "";
								String driver2 = "";
								String driverArr [] = arrayDriver[i].split("#");
								if(driverArr.length > 0){
									driver1 = driverArr[0];
									if(driverArr.length > 1){
										driver2 = driverArr[1];
									}
								}
								String dateArr []  = arrayDate[i].split("#");
								String std = dateArr[0];
								String sta = dateArr[1];
								
								legId = arrayLeg[i];
								
								pstmt = con.prepareStatement(CreateTripStatement.UPDTAE_TRIP_LEG_DETAILS);
								pstmt.setInt(1, offset);
								pstmt.setString(2, yyyymmdd.format(sdfFormatDate.parse(std)));
								pstmt.setInt(3, offset);
								pstmt.setString(4, yyyymmdd.format(sdfFormatDate.parse(sta)));
								pstmt.setString(5, driver1);
								pstmt.setString(6, driver2);
								pstmt.setInt(7, tripId);
								pstmt.setString(8, legId);
								pstmt.executeUpdate();
								
								getDriverAndUpdate(tripId,legId,driver1,driver2,con,vehicleNo,systemId,custId);
							
							}
							
							updateTemperature(tempData, productLine, con, tripId, vehicleNo,vehicleNoOld,systemId,custId,selSensorsToAlertTrigger);
							Remarks = "Modifying the trip "+ lrNo+" and leg details.";
							tableNames.add("Select"+"##"+"AMS.dbo.TRACK_TRIP_DETAILS");
							tableNames.add("Update"+"##"+"AMS.dbo.TRACK_TRIP_DETAILS");
							tableNames.add("Update"+"##"+"AMS.dbo.TRIP_LEG_DETAILS");
							
							cf.insertDataIntoAuditLogReport(sessionId, tableNames, "Trip Solution", "Modified Trip", userId, serverName, systemId, custId, Remarks);
					    	message = "Updated Successfully";
						}else{
					    	message = "Error While Saving";
					    }
					    logWriter.log(" End of the CreateTripFunction.modifyTripDetails method "+sessionId+"::message:"+message, LogWriter.INFO);
				    }
					
				}
			}
			
			
			
	  }catch (Exception e) {
		  	logWriter.log(" Error in CreateTripFunction.modifyTripDetails method "+sessionId+e.getMessage(), LogWriter.INFO);
			e.printStackTrace();
	  } finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
	  }
	  return message;

	}
	//################Trip Summary Report##########################
	
	public ArrayList < Object > getTripSummaryReportNew(int customerId, int systemId,int offset,String startdate,String enddate,String language) {
	    Connection con = null;
	    PreparedStatement pstmt = null ;
	    ResultSet rs = null;
	    JSONArray jsonArray = new JSONArray();
	    JSONObject jsonObject = null;
	    ArrayList < Object > finlist = new ArrayList < Object > ();
	    ArrayList<ReportHelper> reportsList = new ArrayList<ReportHelper>();
		ArrayList<String> headersList = new ArrayList<String>();
		ReportHelper finalreporthelper = new ReportHelper();
	    try {
	    	headersList.add("SLNO");
	    	headersList.add("Trip Id");
	    	headersList.add("Vehicle No");
	    	headersList.add("Trip Name");
	    	headersList.add("Route Name");
	    	headersList.add("Trip Start Date Time");
	    	headersList.add("Actual Trip Start Date Time");
	    	headersList.add("Start Location");
	    	headersList.add("Start Odometer");
	    	headersList.add("Trip End Date Time");
	    	headersList.add("Actual Trip End Date Time");
	    	headersList.add("End Odometer");
	    	headersList.add("Status");
	    	headersList.add("Planned Distance");
	    	headersList.add("Actual Distance");
	    	headersList.add("Vehicle Type");
	    	//double conversionfactor=cf.getUnitOfMeasureConvertionsfactor(systemId);
	    	
	        int count = 0;
	        con = DBConnection.getConnectionToDB("AMS");
	        pstmt = con.prepareStatement(CreateTripStatement.GET_TRIP_SUMMARY);
	        pstmt.setInt(1, offset);
	        pstmt.setInt(2, offset);
	        pstmt.setInt(3, offset);
	        pstmt.setInt(4, offset);
	        pstmt.setInt(5, systemId);
	        pstmt.setInt(6, customerId);
	        pstmt.setInt(7, offset);
	        pstmt.setString(8, startdate);
	        pstmt.setInt(9, offset);
	        pstmt.setString(10, enddate);
	        rs = pstmt.executeQuery();
	        while (rs.next()) {
	        	ArrayList<Object> informationList = new ArrayList<Object>();
	        	ReportHelper reporthelper = new ReportHelper();
	            count++;
	            jsonObject = new JSONObject();
	            
	            informationList.add(count);
	            jsonObject.put("slnoIndex", count);
	            
	            informationList.add(rs.getString("TRIP_ID"));
	            jsonObject.put("tripIdIndex", rs.getString("TRIP_ID"));
	            
	            informationList.add(rs.getString("ASSET_NUMBER"));
	            jsonObject.put("vehicleNoIndex", rs.getString("ASSET_NUMBER"));
	            
	            informationList.add(rs.getString("SHIPMENT_ID"));
	            jsonObject.put("shipmentIdIndex", rs.getString("SHIPMENT_ID"));
	            
	            informationList.add(rs.getString("ROUTE_NAME"));
	            jsonObject.put("roteNameIndex", rs.getString("ROUTE_NAME"));
	            
	            if(rs.getString("TRIP_START_TIME")==""|| rs.getString("TRIP_START_TIME").contains("1900"))
				{
	            	   informationList.add("");
	            	   jsonObject.put("startDateDataIndex", "");
				}
				else
				{
	            informationList.add(ddmmyyyy.format(yyyymmdd.parse(rs.getString("TRIP_START_TIME"))));
	            jsonObject.put("startDateDataIndex", rs.getString("TRIP_START_TIME"));
				}
	            
	            if(rs.getString("ACTUAL_TRIP_START_TIME")==""|| rs.getString("ACTUAL_TRIP_START_TIME").contains("1900"))
				{
	            	   informationList.add("");
	            	   jsonObject.put("actualtripStartDateIndex", "");
				}
				else
				{
	            informationList.add(ddmmyyyy.format(yyyymmdd.parse(rs.getString("ACTUAL_TRIP_START_TIME"))));
	            jsonObject.put("actualtripStartDateIndex", rs.getString("ACTUAL_TRIP_START_TIME"));
				}
	            
	            informationList.add(rs.getString("START_LOCATION"));
	            jsonObject.put("startLocationIndex", rs.getString("START_LOCATION"));
	            
	            informationList.add(rs.getDouble("START_ODOMETER"));
	            jsonObject.put("startOdometerIndex", rs.getDouble("START_ODOMETER"));

	            if(rs.getString("TRIP_END_TIME")==""|| rs.getString("TRIP_END_TIME").contains("1900"))
				{
	            	   informationList.add("");
	            	   jsonObject.put("endDateDataIndex", "");
				}
				else
				{
	            informationList.add(ddmmyyyy.format(yyyymmdd.parse(rs.getString("TRIP_END_TIME"))));
	            jsonObject.put("endDateDataIndex", rs.getString("TRIP_END_TIME"));
				}
	            
	            if(rs.getString("ACTUAL_TRIP_END_TIME")==""|| rs.getString("ACTUAL_TRIP_END_TIME").contains("1900"))
				{
	            	   informationList.add("");
	            	   jsonObject.put("actualendDateDataIndex", "");
				}
				else
				{
	            informationList.add(ddmmyyyy.format(yyyymmdd.parse(rs.getString("ACTUAL_TRIP_END_TIME"))));
	            jsonObject.put("actualendDateDataIndex", rs.getString("ACTUAL_TRIP_END_TIME"));
				}
	            
	            informationList.add(rs.getDouble("END_ODOMETER"));
	            jsonObject.put("endOdometerIndex", rs.getDouble("END_ODOMETER"));
	            
	            informationList.add(rs.getString("TRIP_STATUS"));
	            jsonObject.put("tripStatusIndex", rs.getString("TRIP_STATUS"));
	            
	            informationList.add(rs.getDouble("PLANNED_DISTANCE"));
	            jsonObject.put("plannedDistanceIndex", rs.getDouble("PLANNED_DISTANCE"));
	            
	            informationList.add(rs.getDouble("ACTUAL_DISTANCE"));
	            jsonObject.put("actualDistanceIndex", rs.getDouble("ACTUAL_DISTANCE"));
	            
	            informationList.add(rs.getString("VehicleType"));
	            jsonObject.put("vehicleTypeIndex", rs.getString("VehicleType"));
	            
	            jsonArray.put(jsonObject);
	            reporthelper.setInformationList(informationList);
				reportsList.add(reporthelper);
	            
	        }
	        finalreporthelper.setReportsList(reportsList);
			finalreporthelper.setHeadersList(headersList);
		    finlist.add(jsonArray);
			finlist.add(finalreporthelper);
	     
	    } catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	        DBConnection.releaseConnectionToDB(con, pstmt, rs);
	    }
	    return finlist;
	}
	
	
	
	public JSONArray getRouteDetails( int systemId, String routeId) { //int cutomerId,

		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject = new JSONObject();
		Connection con=null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		float distFactor = 0.62137f;
		DecimalFormat df = new DecimalFormat("0.##");
		RouteCreationFunctions rcf = new RouteCreationFunctions();
		try{
			con = DBConnection.getConnectionToDB("AMS");
			jsonArray = new JSONArray();
			jsonObject = new JSONObject();
			pstmt = con.prepareStatement(CreateTripStatement.GET_ROUTE_DETAILS);
			//pstmt.setInt(1,cutomerId);
			pstmt.setInt(1,systemId);
			pstmt.setString(2,routeId);
			rs=pstmt.executeQuery();
			while(rs.next()){
				jsonObject = new JSONObject();
				jsonObject.put("routeIdDataIndex", rs.getString("RouteID"));
				jsonObject
						.put("routeNameDataIndex", rs.getString("ROUTE_NAME"));
				String distUnits = cf.getUnitOfMeasure(systemId);
				if (distUnits.equalsIgnoreCase("miles")) {
					float tempActual = distFactor
							* (Float
									.parseFloat(rs.getString("ACTUAL_DISTANCE")));
					float tempexpected = distFactor
							* (Float.parseFloat(rs
									.getString("EXPECTED_DISTANCE")));
					jsonObject.put("actualDistanceDataIndex", df
							.format(tempActual));
					jsonObject.put("tempDistanceDataIndex", df
							.format(tempexpected));
				} else {
					jsonObject.put("actualDistanceDataIndex", df.format(Double
							.parseDouble(rs.getString("ACTUAL_DISTANCE"))));
					jsonObject.put("tempDistanceDataIndex", rs
							.getString("EXPECTED_DISTANCE"));
				}
				String aTemp = "";
				aTemp = rs.getString("ACTUAL_DURATION");
				String eTemp = "";
				eTemp = rs.getString("EXPECTED_DURATION");
				if (aTemp.contains(".")) {
					String[] actualStr = aTemp.split("\\.");
					String actualDur = rcf.convertMinutesToHHMMFormat(Integer
							.parseInt(actualStr[0]));
					jsonObject.put("actualTimeDataIndex", actualDur);

				} else{
					jsonObject.put("actualTimeDataIndex", rs
							.getString("ACTUAL_DURATION"));
					
				} 
				if  (eTemp.contains(".")) {
					String[] expectedStr = eTemp.split("\\.");
					String ExpectedDur = rcf.convertMinutesToHHMMFormat(Integer
							.parseInt(expectedStr[0]));
					jsonObject.put("tempTimeDataIndex", ExpectedDur);
					
				}else{
					jsonObject.put("tempTimeDataIndex", rs
							.getString("EXPECTED_DURATION"));
				}
				jsonObject.put("statusDataIndex", rs.getString("STATUS"));
				jsonObject.put("routeFromDataIndex", rs
						.getString("SOURCE_NAME"));
				jsonObject.put("routeToDataIndex", rs
						.getString("DESTINATION_NAME"));
				// jsonObject.put("trigger2DataIndex", rs
				// .getString("TRIGGER_POINT_2"));
				// jsonObject.put("trigger1DataIndex", rs
				// .getString("TRIGGER_POINT_1"));
				jsonObject.put("despDataIndex", rs
						.getString("ROUTE_DESCRIPTION"));
				jsonObject.put("radiusDataIndex", rs.getString("ROUTE_RADIUS"));
				// jsonObject.put("SourceRadiusDataIndex", rs
				// .getString("SOURCE_RADIUS"));
				// jsonObject.put("destRadiusDataIndex", rs
				// .getString("DESTINATION_RADIUS"));
				jsonArray.put(jsonObject);				
			}
		}catch(Exception e){
			System.out.println("Error in getCustomer "+e.toString());
		}	
		finally{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}	
		return jsonArray;
		
		
		
	
	}
	
	
	@SuppressWarnings("unchecked")
	public void imageUpload(HttpServletRequest request, HttpServletResponse response, String tripId, String filePath){
		DiskFileItemFactory factory = new DiskFileItemFactory();
		// Create a new file upload handler
		File file;
		ServletFileUpload up = new ServletFileUpload(factory);
		try {
			List fileItems = up.parseRequest(request);
			Iterator element = fileItems.iterator();
			while (element.hasNext()) {
				FileItem fi = (FileItem) element.next();
				if (!fi.isFormField()) {
					String fileName = fi.getName();
					String fileNameForSave=filePath+"/"+fileName;
					if (fileName.lastIndexOf("\\") >= 0) {
						file = new File(fileNameForSave);
					} else {
						file = new File(fileNameForSave);
					}
					fi.write(file);

					File input = new File(fileNameForSave);
				    BufferedImage image = ImageIO.read(input);

			        File compressedImageFile = new File(fileNameForSave);
			        OutputStream os =new FileOutputStream(compressedImageFile);

			        Iterator<ImageWriter>writers =  ImageIO.getImageWritersByFormatName("jpg");
			        ImageWriter writer = (ImageWriter) writers.next();

			        ImageOutputStream ios = ImageIO.createImageOutputStream(os);
			        writer.setOutput(ios);
 
			        ImageWriteParam param = writer.getDefaultWriteParam();
			      
			        param.setCompressionMode(ImageWriteParam.MODE_EXPLICIT);
			        param.setCompressionQuality(0.05f);
			        writer.write(null, new IIOImage(image, null, null), param);
			      
			        os.close();
			        ios.close();
			        writer.dispose();
				}
			}
		    response.getWriter().print("{success:true}");
		} catch (Exception e) {
			e.printStackTrace();
		}
		
	}

	public JSONArray getLegDetails(int systemId, int custId1, String routeId, String date) {
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject = null;
		Connection con=null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		String std = "";
		int tat = 0;
		int detention = 0;
		String prevStd = "";
		try{
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(CreateTripStatement.GET_ROUTE_LEG_DETAILS);
			pstmt.setString(1,routeId);
			rs=pstmt.executeQuery();
			while(rs.next()){
				jsonObject = new JSONObject();
				detention = rs.getInt("detTime");
				tat = rs.getInt("tat");
				if(rs.getRow() == 1){
					std = cf.AddOffsetToGmt(sdfmmddyyyyhhmmss.format(sfddMMYYYY.parse(date)), detention);
				}else{
					std = cf.AddOffsetToGmt(prevStd, detention);
				}
				String sta = cf.AddOffsetToGmt(std, tat);
				
				jsonObject.put("source", rs.getString("src"));
				jsonObject.put("destination", rs.getString("dest"));
				jsonObject.put("name", rs.getString("legName"));
				jsonObject.put("std", sfddMMYYYY.format(sdfmmddyyyyhhmmss.parse(std)));
				jsonObject.put("sta", sfddMMYYYY.format(sdfmmddyyyyhhmmss.parse(sta)));
				jsonObject.put("legId", rs.getInt("legId"));
				jsonArray.put(jsonObject);	
				prevStd = sta;
			}
		}catch(Exception e){
			e.printStackTrace();
		}	
		finally{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}	
		return jsonArray;
	}
	public JSONArray getDriverDetails(int systemId, int custId, int tripId) {
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject = null;
		Connection con=null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		try{
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(CreateTripStatement.GET_DRIVER_DETAILS);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, custId);
			/*pstmt.setInt(3, systemId);
			pstmt.setInt(4, custId);
			pstmt.setInt(5, tripId);
			pstmt.setInt(6, systemId);
			pstmt.setInt(7, custId);
			pstmt.setInt(8, tripId);*/
			rs=pstmt.executeQuery();
			jsonObject = new JSONObject();
			jsonObject.put("driverId", "");
			jsonObject.put("driverName", "--- Select Driver ---");
			jsonArray.put(jsonObject);	
			while(rs.next()){
				jsonObject = new JSONObject();
				jsonObject.put("driverId", rs.getString("driverId"));
				jsonObject.put("driverName", rs.getString("driverName"));
				jsonArray.put(jsonObject);				
			}
		}catch(Exception e){
			e.printStackTrace();
		}	
		finally{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}	
		return jsonArray;
	}
	public JSONArray getTripLegDetails(int systemId, int custId1, String tripId, int offset) {
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject = null;
		Connection con=null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		try{
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(CreateTripStatement.GET_TRIP_LEG_DETAILS);
			pstmt.setInt(1, offset);
			pstmt.setInt(2, offset);
			pstmt.setString(3,tripId);
			rs=pstmt.executeQuery();
			while(rs.next()){
				String driver1 = "0";
				String driver2 = "0";
				String ata = "";
				jsonObject = new JSONObject();
				jsonObject.put("source", rs.getString("src"));
				jsonObject.put("destination", rs.getString("dest"));
				jsonObject.put("name", rs.getString("legName"));
				jsonObject.put("std", sfddMMYYYY.format(yyyymmdd.parse(rs.getString("std"))));
				jsonObject.put("sta", sfddMMYYYY.format(yyyymmdd.parse(rs.getString("sta"))));
				jsonObject.put("legId", rs.getInt("legId"));
				if(!rs.getString("driver1").equals("")){
					driver1 = rs.getString("driver1");
				}
				if(!rs.getString("driver2").equals("")){
					driver2 = rs.getString("driver2");
				}
				jsonObject.put("driver1", driver1);
				jsonObject.put("driver2", driver2);
				if(!rs.getString("ata").contains("1900")){
					ata = rs.getString("ata");
				}
				jsonObject.put("ata", ata);
				jsonArray.put(jsonObject);	
			}
		}catch(Exception e){
			e.printStackTrace();
		}	
		finally{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}	
		return jsonArray;
	}
	
	public JSONArray getProductLine(int systemId, String custId) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject = null;
		try{
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(CreateTripStatement.GET_PRODUCT_LINE);
			rs = pstmt.executeQuery();
			while(rs.next()){
				jsonObject = new JSONObject();
				jsonObject.put("productname", rs.getString("VALUE"));
				jsonArray.put(jsonObject);	
			}
		}catch(Exception e){
			e.printStackTrace();
		}	
		finally{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}	
		return jsonArray;
	}
	public JSONArray getCategory(int systemId, String custId) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject = null;
		try{
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(CreateTripStatement.GET_TRIP_CATEGORY);
			rs = pstmt.executeQuery();
			jsonObject = new JSONObject();
			jsonObject.put("categoryvalue", "--select category--");
			jsonArray.put(jsonObject);	
			while(rs.next()){
				jsonObject = new JSONObject();
				jsonObject.put("categoryvalue", rs.getString("VALUE"));
				jsonArray.put(jsonObject);	
			}
		}catch(Exception e){
			e.printStackTrace();
		}	
		finally{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}	
		return jsonArray;
	}
	@SuppressWarnings("static-access")
	public JSONArray getUserAssociatedCustomer(int loggedInUserId, int systemId,String userAuthority,String custId) {

		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject = new JSONObject();
		Connection con=null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		String str="";
		try{
			con = DBConnection.getConnectionToDB("AMS");
			jsonArray = new JSONArray();
			jsonObject = new JSONObject();
			if(userAuthority.equalsIgnoreCase("true"))
			{
			 str=gf.GET_USER_ASSOCIATED_CUSTOMER.replace("#","and q2.USER_ID ="+loggedInUserId);
			 pstmt = con.prepareStatement(str);
			 pstmt.setInt(1,systemId);
			}
			else
			{
			 str=gf.GET_ASSOCIATED_CUSTOMER;
			 pstmt = con.prepareStatement(str);
			 pstmt.setInt(1,systemId);
			 pstmt.setString(2,custId);
			}
				rs=pstmt.executeQuery();
				while(rs.next()){
					jsonObject = new JSONObject();
					jsonObject.put("CustId", rs.getString("CUSTOMER_ID"));
					jsonObject.put("CustName", rs.getString("CUSTOMER_NAME"));
					jsonArray.put(jsonObject);				
				}	
			
		}catch(Exception e){
			System.out.println("Error in getCustomer "+e.toString());
			e.printStackTrace();
		}	
		finally{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}	
		return jsonArray;
	
	}

	public String cancelTrip(int userID,int tripId, String sessionId, String serverName, int userId, int systemId, int custId, 
			String vehicleNo, String remarks,LogWriter logWriter,String reasonId,int offset, String status){
		
		//return cancelTripNormally(userID, tripId, sessionId, serverName, userId, systemId, custId, vehicleNo, remarks, logWriter,
		//		reasonId, offset,status);
		
		return cancelTripUsingThread(userID, tripId, sessionId, serverName,	userId, systemId, custId, vehicleNo, remarks, logWriter,
				reasonId, offset, status);
	}
	/*private String cancelTripNormally(int userID, int tripId, String sessionId,	String serverName, int userId, int systemId, int custId,
			String vehicleNo, String remarks, LogWriter logWriter,String reasonId, int offset, String status) {
		logWriter.log("Start of creatTripFunc.cancelTrip method "+sessionId+" :: tripId:"+tripId+"::vehicleNo:"+vehicleNo ,LogWriter.INFO);
		Connection con=null;
		PreparedStatement pstmt=null,pstmt1 = null;
		ResultSet rs , rs1 = null;
		String message="";
		String lrNo = "";
		ArrayList<String> tableNames = new ArrayList<String>();
		String Remarks = "";
		String endLoc = "";
		DashBoardFunctions df = new DashBoardFunctions();
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
				if(systemId==38){//Deleting the orders for Cancelled Trips : Jotun
					df.deleteOrderNoForCancel(tripId);
					message = "Trip Closed";
				}else{
					message = "Trip Closed";
					/*Vinay H
					 * updating the coming trips status to 'OPEN'
					 
					if(!status.equals("UPCOMING")){
						try{
							cf.updateUpcomingTripStatusToOpen(con,vehicleNo,tripId,custId,logWriter);
						}catch(final Exception e){
							logWriter.log("Exception occurred while updating the upcoming trip :"+tripId, LogWriter.ERROR);
						}
						
						pstmt1 = con.prepareStatement("UPDATE dbo.gpsdata_history_latest set DRIVER_NAME = '', DRIVER_MOBILE='' " +
						"where REGISTRATION_NO = ? and  System_id=?");
						pstmt1.setString(1, vehicleNo);
						pstmt1.setInt(2, systemId);
						pstmt1.executeUpdate();
						
						if(systemId==268){
							ctf.disassociateVehicles(con, systemId, custId, vehicleNo, tripId, logWriter);
						}
					}
					
			        pstmt1 = con.prepareStatement(CreateTripStatement.GET_VEHICLE_NO_AND_ACT_ARR_DATETIME_FOR_TRIP_CREATION_VALIDATION.replace("#", "AND td.TRIP_ID != ?"));
					pstmt1.setInt(1,offset);
					pstmt1.setString(2,vehicleNo);
					pstmt1.setInt(3,systemId);
					pstmt1.setInt(4,custId);
					pstmt1.setInt(5,tripId);
					
					rs1 = pstmt1.executeQuery();
					if(rs1.next()){
							cf.updateVehicleStatus(con, vehicleNo, 8, 0,logWriter);
					}else{
						cf.updateVehicleStatus(con, vehicleNo, 16, 0, logWriter);
					}
					
					pstmt = con.prepareStatement(CreateTripStatement.GET_ROUTE_ID_AND_VEHICLE_NUMBER_BY_TRIP_ID);
					pstmt.setInt(1, tripId);
					pstmt.setInt(2, systemId);
					pstmt.setInt(3, custId);
					rs = pstmt.executeQuery();
					if (rs.next()) {
						lrNo = rs.getString("ORDER_ID");
						endLoc = rs.getString("NAME").contains(",") ? rs.getString("NAME").substring(0, rs.getString("NAME").indexOf(",")) : rs.getString("NAME");
					}
					if(systemId == 268 && !lrNo.contains("DHL")){
						ArrayList<String> apiDetails = getAPIConfiguration(con, "Trip_Exec");
						String eventCode =  "Empty Trip".equalsIgnoreCase(rs.getString("tripCustType")) ? "ARRIV_DEST" : "UNLOAD_END";
						try{
							SAPAPICall(lrNo, eventCode, endLoc, 0, logWriter, apiDetails.get(0), apiDetails.get(1));
						}catch(final Exception e){
							logWriter.log("Exception while pushing trip details to SAP :"+tripId+". Exception is "+e.getMessage(), LogWriter.ERROR);
						}
					}
				}
		    }else{
		    	 message = "Error While Closing Trip";
		    }
			tableNames.add("Update"+"##"+"AMS.dbo.TRACK_TRIP_DETAILS");
			Remarks = "Cancelled the trip "+lrNo +" because of the reason : "+ reason;
			try{
				cf.insertDataIntoAuditLogReport(sessionId, tableNames, "Trip Solution", "Cancelling Trip", userId, serverName, systemId, custId, Remarks);
			}catch(Exception e){
				e.printStackTrace();
			}
			logWriter.log("End of TripCreatAction.cancelTrip method :"+sessionId+ "message:"+ message ,LogWriter.INFO);
		}catch (Exception e) {
			logWriter.log("Error in TripCreatAction.cancelTrip method :"+sessionId+ "message:"+ e.getMessage() ,LogWriter.ERROR);
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, null);
			DBConnection.releaseConnectionToDB(null, pstmt1, rs1);
		 }
		return message;
	}*/
	private String cancelTripUsingThread(int userID, int tripId, String sessionId, String serverName, int userId, int systemId,
			int custId, String vehicleNo, String remarks, LogWriter logWriter, String reasonId, int offset,String status) {
		logWriter.log("Start of creatTripFunc.cancelTrip method "+sessionId+" :: tripId:"+tripId+"::vehicleNo:"+vehicleNo ,
				LogWriter.INFO);
		Connection con=null;
		PreparedStatement pstmt=null,pstmt1 = null;
		ResultSet rs , rs1 = null;
		String message="";
		String lrNo = "";
		ArrayList<String> tableNames = new ArrayList<String>();
		String Remarks = "";
		String endLoc = "";
		DashBoardFunctions df = new DashBoardFunctions();
		try {
			String reason = remarks.length() > 0 ? reasonId+"-"+remarks : reasonId;
			con = DBConnection.getConnectionToDB("AMS");
			if(systemId==38){
				String endlocation = getEndLocation(vehicleNo, systemId, custId, tripId, con);
				pstmt = con.prepareStatement(CreateTripStatement.UPDATE_TO_CLOSE_TRIP);
				pstmt.setInt(1, userID);
				pstmt.setString(2, reason);
				pstmt.setString(3, endlocation);
				pstmt.setInt(4, tripId);
				int updated=pstmt.executeUpdate();
				if (updated > 0) {
					df.deleteOrderNoForCancel(tripId);
					message = "Trip Closed";
				}else{
					message = "Error While Closing Trip";
				}	
			}else{
				message = "Trip cancelled Successfully";
				String endlocation = getEndLocation(vehicleNo, systemId, custId, tripId, con);
				
				TripCloseOrReopenThread tripCloseOrReopenThread = new TripCloseOrReopenThread("CANCEL", userId, reason, tripId, vehicleNo, logWriter, 
						"", endlocation, "", offset, systemId, custId, status);
				Thread thread = new Thread(tripCloseOrReopenThread);
				thread.start();
				
				pstmt = con.prepareStatement(CreateTripStatement.GET_ROUTE_ID_AND_VEHICLE_NUMBER_BY_TRIP_ID);
				pstmt.setInt(1, tripId);
				pstmt.setInt(2, systemId);
				pstmt.setInt(3, custId);
				rs = pstmt.executeQuery();
				if (rs.next()) {
					lrNo = rs.getString("ORDER_ID");
					endLoc = rs.getString("DEST_NAME").contains(",") ? rs.getString("DEST_NAME").substring(0, rs.getString("DEST_NAME").indexOf(",")) : rs.getString("DEST_NAME");
				}
				if(systemId == 268 && !lrNo.contains("DHL")){
					ArrayList<String> apiDetails = getAPIConfiguration(con, "Trip_Exec");
					String eventCode =  "Empty Trip".equalsIgnoreCase(rs.getString("tripCustType")) ? "ARRIV_DEST" : "UNLOAD_END";
					try{
						logWriter.log("SAP API is called while cancelling the Trip : "+lrNo+". Event Type : "+eventCode, LogWriter.INFO);
						cf.SAPAPICall(lrNo,"", eventCode, endLoc, 0, logWriter, apiDetails.get(0), apiDetails.get(1),"");
					}catch(final Exception e){
						logWriter.log("Exception while pushing trip details to SAP :"+tripId+". Exception is "+e.getMessage(), LogWriter.ERROR);
					}	
				}
			}
			tableNames.add("Update"+"##"+"AMS.dbo.TRACK_TRIP_DETAILS");
			Remarks = "Cancelled the trip "+lrNo +" because of the reason : "+ reason;
			try{
				cf.insertDataIntoAuditLogReport(sessionId, tableNames, "Trip Solution", "Cancelling Trip", userId, serverName, systemId, custId, Remarks);
			}catch(Exception e){
				e.printStackTrace();
			}
			logWriter.log("End of TripCreatAction.cancelTrip method :"+sessionId+ "message:"+ message ,LogWriter.INFO);
		}catch (Exception e) {
			logWriter.log("Error in TripCreatAction.cancelTrip method :"+sessionId+ "message:"+ e.getMessage() ,LogWriter.ERROR);
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, null);
			DBConnection.releaseConnectionToDB(null, pstmt1, rs1);
		 }
		return message;
	}

	public String closeSemiAutoMatedTrip(int userId, int tripId, int systemId, int clientId, int offset, String sessionId, String serverName,
			String vehicleNo, String remarksData,String tripCloseDate,  LogWriter logWriter) {
		logWriter.log("Start of CreateTripFunction.closeRunningTrip" + sessionId+ "::tripId:" + tripId + "::vehicleNo:" + vehicleNo
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
					cf.insertDataIntoAuditLogReport(sessionId, tableName,"Trip Solution", action, userId,serverName, systemId, clientId, remarks);
				} catch (final Exception e) {
					logWriter.log("Exception in audit log report : "+e.getMessage()+". Vehicle No : "+vehicleNo+". Trip Id : "+tripId, LogWriter.ERROR);
					e.printStackTrace();
				}
			}
		} catch (final Exception e) {
			logWriter.log("Error in CreateTripFunction.closeRunningTrip"+ sessionId + e.getMessage(), LogWriter.ERROR);
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, null);
			DBConnection.releaseConnectionToDB(null, pstmt1, rs1);
		}
		logWriter.log("End of CreateTripFunction.closeRunningTrip" + sessionId,LogWriter.INFO);
		return message;
	}
	public String closeTripForHardCodedValues(int userId, String remarksData, int tripId, String shipmentId,int offset, 
			String vehicleNo, int systemId, int clientId, LogWriter logWriter, String sessionId,String serverName) throws SQLException{
		PreparedStatement pstmt = null;
		String message = "";
		Connection con = null;
		ArrayList<String> tableName = new ArrayList<String>();
		tableName.add("Update" + "##" + "TRACK_TRIP_DETAILS");
		
		con = DBConnection.getConnectionToDB("AMS");
		pstmt = con.prepareStatement(CreateTripStatement.UPDATE_MAIN_TRIP_FOR_MLL);
		pstmt.setString(1, "CLOSED");
		pstmt.setString(2, "N");
		pstmt.setInt(3, userId);
		pstmt.setString(4, remarksData);
		pstmt.setInt(5, tripId);
		int update = pstmt.executeUpdate();
		
		String remarks = "Closing Trip : "+shipmentId;
		String action = "Closing Trip";
		boolean isExist = isVehicleOnTrip(con, offset, vehicleNo, systemId, clientId, tripId);
		if(!isExist){
			cf.updateVehicleStatus(con, vehicleNo, 16, 0,logWriter);
		}
		message = "Trip closed successfully";
		if (update > 0) {
			try {
				cf.insertDataIntoAuditLogReport(sessionId, tableName,"Trip Solution", action, userId,serverName, systemId, clientId, remarks);
			} catch (final Exception e) {
				logWriter.log("Exception in audit log report : "+e.getMessage()+". Vehicle No : "+vehicleNo+". Trip Id : "+tripId, LogWriter.ERROR);
				e.printStackTrace();
			}
		}
		return message;
	}
	public String closeRunningTrip(int userId, int tripId, int systemId, int clientId, int offset, String sessionId, String serverName,
			String vehicleNo, String remarksData, String ata, boolean destinationArrived, LogWriter logWriter, String shipmentId,
			String status, String lrNo, String atp, String atd, boolean atpChanged, boolean atdChanged, boolean ataChanged) {
		/*return closingorReopeningTripNormally(userId, tripId, systemId, clientId, offset, sessionId, serverName, vehicleNo, remarksData, ata,
				destinationArrived, logWriter, shipmentId, status, lrNo);*/
		
		return closingOrReopeningTripUsingThread(userId, tripId, systemId, clientId, offset, sessionId, serverName, vehicleNo,
				remarksData, ata, destinationArrived, logWriter, shipmentId, status, lrNo,atp,atd,atpChanged,atdChanged,
				ataChanged);
	}
	/*private String closingorReopeningTripNormally(int userId, int tripId, int systemId,	int clientId, int offset, String sessionId, 
			String serverName, String vehicleNo, String remarksData, String ata, boolean destinationArrived, LogWriter logWriter, 
			String shipmentId, String status, String lrNo) {
		logWriter.log("Start of CreateTripFunction.closeRunningTrip" + sessionId+ "::tripId:" + tripId + "::vehicleNo:" + vehicleNo
						+ "::ata:" + ata + "::destinationArrived:" + destinationArrived, LogWriter.INFO);
		Connection con = null;
		PreparedStatement pstmt = null, pstmt1 = null, pstmt2 = null;
		ResultSet rs, rs1 = null;
		String message = "";
		ArrayList<String> tableName = new ArrayList<String>();
		int update = 0;
		String remarks = "";
		String action = "";
		try {
			con = DBConnection.getConnectionToDB("AMS");

			tableName.add("Update" + "##" + "TRACK_TRIP_DETAILS");

			String endLocation = getEndLocation(vehicleNo, systemId, clientId,tripId, con);
			if (systemId == 214 || systemId == 266) {
				pstmt = con.prepareStatement(CreateTripStatement.UPDATE_MAIN_TRIP_FOR_MLL);
				pstmt.setString(1, "CLOSED");
				pstmt.setString(2, "N");
				pstmt.setInt(3, userId);
				pstmt.setString(4, remarksData);
				pstmt.setInt(5, tripId);
				update = pstmt.executeUpdate();
				
				remarks = "Closing Trip : "+shipmentId;
				action = "Closing Trip";
				boolean isExist = isVehicleOnTrip(con, offset, vehicleNo, systemId, clientId, tripId);
				if(!isExist){
					cf.updateVehicleStatus(con, vehicleNo, 16, 0,logWriter);
				}
				message = "Trip closed successfully";
			} else {
				ArrayList<String> APIConfig = getAPIConfiguration(con,"Trip_Exec");
				if (status.equalsIgnoreCase("CLOSED")) {
					pstmt = con.prepareStatement(CreateTripStatement.GET_VEHICLE_NO_AND_ACT_ARR_DATETIME_FOR_TRIP_CREATION_VALIDATION.replace("#", ""));
					pstmt.setInt(1, offset);
					pstmt.setString(2, vehicleNo);
					pstmt.setInt(3, systemId);
					pstmt.setInt(4, clientId);
					rs1 = pstmt.executeQuery();
					if (rs1.next()) {
						String orderId = rs1.getString("ORDER_ID");
						message = "Vehicle already assigned to "+ orderId+ " . Please close other trip before proceeding.";
						return message;
					} else {
						pstmt2 = con.prepareStatement(CreateTripStatement.UPDATE_TRACK_TRIP_DETAILS_ON_REOPEN);
						pstmt2.setInt(1, userId);
						pstmt2.setString(2, remarksData);
						pstmt2.setString(3, "OPEN");
						pstmt2.setInt(4, tripId);
						update = pstmt2.executeUpdate();
						
						pstmt2 = con.prepareStatement(CreateTripStatement.UPDATE_SUB_TRIP_DETAILS);
						pstmt2.setString(1, "REOPEN");
						pstmt2.setInt(2, tripId);
						pstmt2.executeUpdate();
						
						pstmt2 = con.prepareStatement(CreateTripStatement.UPDATE_DES_TRIP_DETAILS_ON_REOPEN);
						pstmt2.setInt(1, tripId);
						pstmt2.executeUpdate();
						
						remarks = "Reopening trip " + lrNo;
						action = "Reopening Trip";
						message = "Trip Reopened successfully";
						
						cf.updateVehicleStatus(con, vehicleNo, 8, 0,logWriter);
					}
					pstmt1 = con.prepareStatement(CreateTripStatement.GET_ROUTE_ID_AND_VEHICLE_NUMBER_BY_TRIP_ID);
					pstmt1.setInt(1, tripId);
					pstmt1.setInt(2, systemId);
					pstmt1.setInt(3, clientId);
					rs = pstmt1.executeQuery();
					if (rs.next()) {
						String endLoc = rs.getString("NAME").contains(",") ? rs.getString("NAME").substring(0, rs.getString("NAME").indexOf(",")): rs.getString("NAME");
						if(systemId == 268 && !rs.getString("ORDER_ID").contains("DHL")){
							try{
								SAPAPICall(rs.getString("ORDER_ID"), "REOPEN", endLoc, 0, logWriter,APIConfig.get(0),APIConfig.get(1));
							}catch(final Exception e){
								logWriter.log("Exception while pushing trip details to SAP :"+tripId+". Exception is "+e.getMessage(), LogWriter.ERROR);
							}
						}
					}
				} else {
					pstmt1 = con.prepareStatement(CreateTripStatement.GET_ROUTE_ID_AND_VEHICLE_NUMBER_BY_TRIP_ID);
					pstmt1.setInt(1, tripId);
					pstmt1.setInt(2, systemId);
					pstmt1.setInt(3, clientId);
					rs1 = pstmt1.executeQuery();
					if (rs1.next()) {
						if ("REOPEN".equalsIgnoreCase(rs1.getString("TRIP_STATUS"))) {
							pstmt2 = con.prepareStatement(CreateTripStatement.UPDATE_TRACK_TRIP_DETAILS);
							pstmt2.setInt(1, userId);
							pstmt2.setString(2, remarksData);
							pstmt2.setString(3, "CLOSED");
							pstmt2.setInt(4, tripId);
							update = pstmt2.executeUpdate();
							message = "Trip closed successfully";
							remarks = "Closing Reopened trip " + lrNo;
							action = "Closing Reopened Trip";
						} else {
							if (ata != null && !"".equals(ata)) {
								ata = yyyymmdd.format(sfddMMYYYY.parse(ata + ":00"));
								pstmt = con.prepareStatement(CreateTripStatement.UPDATE_MAIN_TRIP.replace("#","ACTUAL_TRIP_END_TIME=dateadd(mi,-"+ offset+ ",'"+ ata
																+ "'),ACTUAL_DURATION=datediff(minute, ACTUAL_TRIP_START_TIME, dateadd(mi,-"+ offset + ",'"+ ata + "'))"));

								pstmt1 = con.prepareStatement(CreateTripStatement.UPDATE_TRIP_LEG_DETAILS_WHILE_CLOSING.replace("#","ACTUAL_ARRIVAL=dateadd(mi,-"+ offset + ",'"+ ata + "')"));
								pstmt1.setInt(1, tripId);
								pstmt1.setInt(2, tripId);
								pstmt1.executeUpdate();
							} else {
								pstmt = con.prepareStatement(CreateTripStatement.UPDATE_MAIN_TRIP.replace("#","ACTUAL_TRIP_END_TIME=getutcdate(),ACTUAL_DURATION=datediff(minute, ACTUAL_TRIP_START_TIME, getutcdate())"));
								if(!destinationArrived){
									pstmt1 = con.prepareStatement(CreateTripStatement.UPDATE_TRIP_LEG_DETAILS_WHILE_CLOSING.replace("#","ACTUAL_ARRIVAL=getutcdate()"));
									pstmt1.setInt(1, tripId);
									pstmt1.setInt(2, tripId);
									pstmt1.executeUpdate();
								}
							}
							pstmt.setString(1, "CLOSED");
							pstmt.setString(2, "N");
							pstmt.setInt(3, userId);
							pstmt.setString(4, remarksData);
							pstmt.setString(5, endLocation);
							pstmt.setInt(6, tripId);
							update = pstmt.executeUpdate();

							message = "Trip closed successfully";
							remarks = "Closing trip " + lrNo + " for the veicle No "+ vehicleNo;
							action = "Closing Trip";
							if (!destinationArrived) {// If destination arrival happened don't override
								if (ata != null && !ata.equals("")) {
									pstmt1 = con.prepareStatement(CreateTripStatement.UPDATE_DES_ATA.replace("#","ACT_ARR_DATETIME=dateadd(mi,-?,?)"));
									pstmt1.setInt(1, offset);
									pstmt1.setString(2, ata);
									pstmt1.setInt(3, tripId);
									pstmt1.executeUpdate();
								}
							}
						}
						try {
							ctf.disassociateVehicles(con, systemId, clientId, vehicleNo, tripId, logWriter);
						} catch (Exception e) {
							e.printStackTrace();
						}
						pstmt2 = con.prepareStatement(CreateTripStatement.UPDATE_SUB_TRIP_DETAILS);
						pstmt2.setString(1, "CLOSED");
						pstmt2.setInt(2, tripId);
						pstmt2.executeUpdate();
						
						boolean isExist = isVehicleOnTrip(con, offset, vehicleNo, systemId, clientId, tripId);
						if(!isExist){
							cf.updateVehicleStatus(con, vehicleNo, 16, 0, logWriter);
						}
						String endLoc = rs1.getString("NAME").contains(",") ? rs1.getString("NAME").substring(0, rs1.getString("NAME").indexOf(",")): rs1.getString("NAME");
						if(systemId == 268 && !rs1.getString("ORDER_ID").contains("DHL")){
							String eventCode =  "Empty Trip".equalsIgnoreCase(rs1.getString("tripCustType")) ? "ARRIV_DEST" : "UNLOAD_END";
							SAPAPICall(rs1.getString("ORDER_ID"), eventCode, endLoc, 0, logWriter,APIConfig.get(0),APIConfig.get(1));
						}
						
						/*Vinay H
						 * updating the coming trips status to 'OPEN'
						 
						try{
							cf.updateUpcomingTripStatusToOpen(con,vehicleNo,tripId,clientId,logWriter);
						}catch(final Exception e){
							logWriter.log("Exception occurred while updating the upcoming trip :"+tripId, LogWriter.ERROR);
						}
						
						pstmt2 = con.prepareStatement("UPDATE dbo.gpsdata_history_latest set DRIVER_NAME = '', DRIVER_MOBILE='' " +
						"where REGISTRATION_NO = ? and  System_id=?");
						pstmt2.setString(1, vehicleNo);
						pstmt2.setInt(2, systemId);
						pstmt2.executeUpdate();
					}
				}
			}
			if (update > 0) {
				try {
					cf.insertDataIntoAuditLogReport(sessionId, tableName,"Trip Solution", action, userId,serverName, systemId, clientId, remarks);
				} catch (final Exception e) {
					logWriter.log("Exception in audit log report : "+e.getMessage()+". Vehicle No : "+vehicleNo+". Trip Id : "+tripId, LogWriter.ERROR);
					e.printStackTrace();
				}
			}
		} catch (final Exception e) {
			logWriter.log("Error in CreateTripFunction.closeRunningTrip"+ sessionId + e.getMessage(), LogWriter.ERROR);
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, null);
			DBConnection.releaseConnectionToDB(null, pstmt1, rs1);
		}
		logWriter.log("End of CreateTripFunction.closeRunningTrip" + sessionId,LogWriter.INFO);
		return message;
	}*/
	
	private String closingOrReopeningTripUsingThread(int userId, int tripId, int systemId, int clientId, int offset, String sessionId,
			String serverName, String vehicleNo, String remarksData, String ata, boolean destinationArrived, LogWriter logWriter,
			String shipmentId, String status, String lrNo, String atp, String atd,boolean atpChanged,boolean atdChanged, boolean ataChanged) {
		logWriter.log("Start of CreateTripFunction.closeRunningTrip" + sessionId + "::tripId:" + tripId
				+ "::vehicleNo:" + vehicleNo + "::ata:" + ata + "::destinationArrived:" + destinationArrived,LogWriter.INFO);
		Connection con = null;
		PreparedStatement pstmt = null, pstmt1 = null, pstmt2 = null;
		ResultSet rs, rs1 = null;
		String message = "";
		ArrayList<String> tableName = new ArrayList<String>();
		String remarks = "";
		String action = "";
		StringBuilder auditLogActionForUpdateActuals = new StringBuilder();
		try {
			con = DBConnection.getConnectionToDB("AMS");
			tableName.add("Update" + "##" + "TRACK_TRIP_DETAILS");
			ArrayList<String> APIConfig = getAPIConfiguration(con, "Trip_Exec");
			if (status.equalsIgnoreCase("CLOSED")) {
				pstmt = con.prepareStatement(CreateTripStatement.GET_VEHICLE_NO_AND_ACT_ARR_DATETIME_FOR_TRIP_CREATION_VALIDATION.replace("#", ""));
				pstmt.setInt(1, offset);
				pstmt.setString(2, vehicleNo);
				pstmt.setInt(3, systemId);
				pstmt.setInt(4, clientId);
				rs1 = pstmt.executeQuery();
				if (rs1.next()) {
					String orderId = rs1.getString("ORDER_ID");
					message = "Vehicle already assigned to " + orderId
							+ " . Please close other trip before proceeding.";
					return message;
				} else {
					remarks = "Reopening trip " + lrNo;
					action = "Reopening Trip";
					message = "Trip Reopened successfully";

					/*@Author : Vinay H
					 * Calling thread while updating the trip related table for reopen.
					*/
					TripCloseOrReopenThread tripCloseOrReopenThread = new TripCloseOrReopenThread("REOPEN", userId,
							remarksData, tripId, vehicleNo, logWriter, "", "", ata, offset, systemId, clientId, status,
							"", atp, atd, atpChanged, atdChanged, ataChanged,true);
					Thread thread = new Thread(tripCloseOrReopenThread);
					thread.start();

					pstmt1 = con.prepareStatement(CreateTripStatement.GET_ROUTE_ID_AND_VEHICLE_NUMBER_BY_TRIP_ID);
					pstmt1.setInt(1, tripId);
					pstmt1.setInt(2, systemId);
					pstmt1.setInt(3, clientId);
					rs = pstmt1.executeQuery();
					if (rs.next()) {
						String endLoc = rs.getString("DEST_NAME").contains(",") ? rs.getString("DEST_NAME").substring(
								0, rs.getString("DEST_NAME").indexOf(",")) : rs.getString("DEST_NAME");
						if (systemId == 268 && !rs.getString("ORDER_ID").contains("DHL")) {
							logWriter.log("SAP API is called for the trip while Reopening the Trip : "
									+ rs.getString("ORDER_ID"), LogWriter.INFO);
							cf.SAPAPICall(rs.getString("ORDER_ID"), "", "REOPEN", endLoc, 0, logWriter, APIConfig
									.get(0), APIConfig.get(1), "");
						}
					}
				}
			} else if (status.equalsIgnoreCase("OPEN")) {
				message = "Trip closed successfully";
				pstmt1 = con.prepareStatement(CreateTripStatement.GET_ROUTE_ID_AND_VEHICLE_NUMBER_BY_TRIP_ID);
				pstmt1.setInt(1, tripId);
				pstmt1.setInt(2, systemId);
				pstmt1.setInt(3, clientId);
				rs1 = pstmt1.executeQuery();
				if (rs1.next()) {
					if ("REOPEN".equals(rs1.getString("TRIP_STATUS"))) {
						remarks = "Closing Reopened trip " + lrNo;
						action = "Closing Reopened Trip";
					} else {
						remarks = "Closing trip " + lrNo + " for the veicle No " + vehicleNo;
						action = "Closing Trip";
					}
					String startLoc = rs1.getString("SOURCE_NAME").contains(",") ? rs1.getString("SOURCE_NAME")
							.substring(0, rs1.getString("SOURCE_NAME").indexOf(",")) : rs1.getString("SOURCE_NAME");
					String endLoc = rs1.getString("DEST_NAME").contains(",") ? rs1.getString("DEST_NAME").substring(0,
							rs1.getString("DEST_NAME").indexOf(",")) : rs1.getString("DEST_NAME");
					/* Vinay H
					 * Calling Thread while updating the trip relating tables.
					*/
					TripCloseOrReopenThread tripCloseOrReopenThread = new TripCloseOrReopenThread("CLOSE", userId,
							remarksData, tripId, vehicleNo, logWriter, rs1.getString("TRIP_STATUS"), endLoc, ata,
							offset, systemId, clientId, status, "", atp, atd, atpChanged, atdChanged,ataChanged,true);
					Thread thread = new Thread(tripCloseOrReopenThread);
					thread.start();

					String eventCode = "Empty Trip".equalsIgnoreCase(rs1.getString("tripCustType")) ? "ARRIV_DEST": "UNLOAD_END";

					if (systemId == 268 && !rs1.getString("ORDER_ID").contains("DHL")) {
						if (atpChanged) {
							cf.SAPAPICall(rs1.getString("ORDER_ID"), rs1.getString("srcSuccessor"), "ATP", startLoc, 0,
									logWriter, APIConfig.get(0), APIConfig.get(1), atp + ":00");

							cf.SAPAPICall(rs1.getString("ORDER_ID"), rs1.getString("srcSuccessor"), "ARRIV_DEST",
									startLoc, 0, logWriter, APIConfig.get(0), APIConfig.get(1), atp + ":00");

							auditLogActionForUpdateActuals.append("ATP,");
						}
						if (atdChanged) {
							cf.SAPAPICall(rs1.getString("ORDER_ID"), rs1.getString("srcSuccessor"), "DEPARTURE",
									startLoc, 0, logWriter, APIConfig.get(0), APIConfig.get(1), atd + ":00");

							auditLogActionForUpdateActuals.append("ATD,");
						}
						if (ataChanged) {
							if (!"Empty Trip".equalsIgnoreCase(rs1.getString("tripCustType"))) {
								logWriter.log("SAP API is called while closing the Trip with ATA : "
										+ rs1.getString("ORDER_ID"), LogWriter.INFO);
								cf.SAPAPICall(rs1.getString("ORDER_ID"), rs1.getString("destSuccessor"), "ARRIV_DEST",
										endLoc, 0, logWriter, APIConfig.get(0), APIConfig.get(1), ata + ":00");
							}
							auditLogActionForUpdateActuals.append("ATA,");
						}
						if(auditLogActionForUpdateActuals.toString().length() > 0){
							auditLogActionForUpdateActuals.deleteCharAt(auditLogActionForUpdateActuals.length()-1);
							auditLogActionForUpdateActuals.append(" updated,");
						}else{
							auditLogActionForUpdateActuals.append(",");
						}
						logWriter.log("SAP API is called while closing the Trip : " + rs1.getString("ORDER_ID"),LogWriter.INFO);
						cf.SAPAPICall(rs1.getString("ORDER_ID"), "", eventCode, endLoc, 0, logWriter, APIConfig.get(0),	APIConfig.get(1), "");
					}
				}
				pstmt2 = con.prepareStatement("UPDATE dbo.gpsdata_history_latest set DRIVER_NAME = '', DRIVER_MOBILE='' "
								+ "where REGISTRATION_NO = ? and  System_id=?");
				pstmt2.setString(1, vehicleNo);
				pstmt2.setInt(2, systemId);
				pstmt2.executeUpdate();

				cf.insertDataIntoAuditLogReport("Trip Solution :- Closing Trip", auditLogActionForUpdateActuals,
						userId, systemId, clientId, serverName, tripId, remarksData);
			}
			try {
				cf.insertDataIntoAuditLogReport(sessionId, tableName, "Trip Solution", action, userId, serverName,
						systemId, clientId, remarks);
			} catch (final Exception e) {
				logWriter.log("Exception in audit log report : " + e.getMessage() + ". Vehicle No : " + vehicleNo
						+ ". Trip Id : " + tripId, LogWriter.ERROR);
				e.printStackTrace();
			}
		} catch (final Exception e) {
			logWriter.log("Error in CreateTripFunction.closeRunningTrip" + tripId + e.getMessage(), LogWriter.ERROR);
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, null);
			DBConnection.releaseConnectionToDB(null, pstmt1, rs1);
		}
		logWriter.log("End of CreateTripFunction.closeRunningTrip" + sessionId, LogWriter.INFO);
		return message;
	}

	private ArrayList<String> getAPIConfiguration(Connection con, String apiType) throws SQLException {
		ArrayList<String> APIConfig = new ArrayList<String>();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		pstmt = con.prepareStatement(CreateTripStatement.GET_API_DETAILS);
		pstmt.setString(1, apiType);
		rs = pstmt.executeQuery();
		if(rs.next()){
			APIConfig.add(rs.getString("URL"));
			APIConfig.add(rs.getString("AUTH"));
		}
		return APIConfig;
	}
	public boolean isVehicleOnTrip(Connection con, int offset, String vehicleNo,int systemId,int clientId,int tripId) throws SQLException{
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		boolean exist = false;
		
		pstmt = con.prepareStatement(CreateTripStatement.GET_VEHICLE_NO_AND_ACT_ARR_DATETIME_FOR_TRIP_CREATION_VALIDATION.replace("#", "AND td.TRIP_ID != ?"));
		pstmt.setInt(1, offset);
		pstmt.setString(2, vehicleNo);
		pstmt.setInt(3, systemId);
		pstmt.setInt(4, clientId);
		pstmt.setInt(5, tripId);
		rs = pstmt.executeQuery();
		if(rs.next()){
			exist = true;
		}
		pstmt.close();
		rs.close();
		
		return exist;
	}
	public JSONArray getAvailableRoutes(int systemId, int clientId, String tripId, String routeId, String tripCustId) {
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject = null;
		Connection con=null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		try{
			con = DBConnection.getConnectionToDB("AMS");
			// get the routes which has all completed legs from previous route
			ArrayList<Integer> legList = new ArrayList<Integer>();
			pstmt = con.prepareStatement(CreateTripStatement.GET_COMPLETED_LEGS);
			pstmt.setInt(1, Integer.parseInt(tripId));
			rs = pstmt.executeQuery();
			while(rs.next()){
				legList.add(rs.getInt("LEG_ID"));
			}
			
			HashMap<Integer, ArrayList<Integer>> routeHash = new HashMap<Integer, ArrayList<Integer>>();
 			ArrayList<Integer> legArray = new ArrayList<Integer>(); 
 			int prevRecord = 0;
 			int currRecord = 0;
			pstmt = con.prepareStatement(CreateTripStatement.GET_AVAILABLE_ROUTES);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, clientId);
			pstmt.setString(3, tripCustId);
			pstmt.setString(4, routeId);
			rs = pstmt.executeQuery();
			while(rs.next()){
				if(rs.getRow()==1){
					prevRecord = rs.getInt("ROUTE_ID");
					currRecord = rs.getInt("ROUTE_ID");
				} else {
					prevRecord = currRecord; 
					currRecord = rs.getInt("ROUTE_ID");
				}
				if(prevRecord != currRecord){
					routeHash.put(prevRecord, legArray);
					legArray = new ArrayList<Integer>();
				}
				legArray.add(rs.getInt("LEG_ID"));
			}
			String routeIds = "";
			boolean routesAvailable = false;
			routeHash.put(prevRecord, legArray);
			Set<Map.Entry<Integer, ArrayList<Integer>>> routeKey = routeHash.entrySet();
			Iterator<Map.Entry<Integer, ArrayList<Integer>>> iterator = routeKey.iterator();
			while(iterator.hasNext()){
				Map.Entry<Integer, ArrayList<Integer>> me = (Map.Entry<Integer, ArrayList<Integer>>)iterator.next();
				ArrayList<Integer> allLegList = me.getValue();
				for(int i = 0; i < legList.size(); i++){
					for(int k=0; k<allLegList.size(); k++){
						if(legList.get(i) == allLegList.get(k)){
							routeIds = routeIds+","+me.getKey();
							routesAvailable = true;
						}
					}
				}
			}
			if(routesAvailable){
				pstmt = con.prepareStatement(CreateTripStatement.GET_CHANGEOVER_ROUTE.replace("#", " and a.ID in ("+routeIds.substring(1, routeIds.length())+")"));
				pstmt.setInt(1, systemId);
				pstmt.setInt(2, clientId);
				pstmt.setString(3, tripCustId);
				rs=pstmt.executeQuery();
				
				jsonObject = new JSONObject();
				jsonObject.put("routeId", "");
				jsonObject.put("routeName", "-- select route name --");
				jsonObject.put("legCount", 0);
				jsonArray.put(jsonObject);
				
				while(rs.next()){
					jsonObject = new JSONObject();
					jsonObject.put("routeId", rs.getString("routeId"));
					jsonObject.put("routeName", rs.getString("routeName"));
					jsonObject.put("legCount", rs.getInt("legCount"));
					jsonArray.put(jsonObject);				
				}
			}
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}	
		return jsonArray;
	
	}
	public String checkLegEndedOrNot(String tripId) {
		Connection con=null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		String message = "N";
		try{
			con = DBConnection.getConnectionToDB("AMS");
			// To check the current point of the Vehicle, so that route change will be possible
			pstmt = con.prepareStatement(CreateTripStatement.CHECK_LEG__COMPLETED);
			pstmt.setInt(1, Integer.parseInt(tripId));
			rs = pstmt.executeQuery();
			if(rs.next()){
				message = "Y";
			}
		}catch(Exception e){
			System.out.println("Error in getCustomer "+e.toString());
			e.printStackTrace();
		}finally{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}	
		return message;
	}
	public String changeRoute(int systemId, int clientId, String tripId, String tripCustId, String oldRouteId, String newRouteId, int userId,
			String routeName) {
		Connection con=null;
		PreparedStatement pstmt=null, pstmt1 = null, pstmt2 = null, pstmt3 = null;
		ResultSet rs=null, rs1 = null, rs2 = null, rs3 = null;
		String message = "";
		String driver1 = "";
		String driver2 = "";
		String std = "";
		String prevStd = "";
		int update = 0;
		String tripEndTime = "";
		double plannedDistance = 0;
		double plannedDuration = 0;
		try{
			con = DBConnection.getConnectionToDB("AMS");
			// get the completed leg
			pstmt = con.prepareStatement(CreateTripStatement.GET_COMPLETED_LEG);
			pstmt.setInt(1, Integer.parseInt(newRouteId));
			pstmt.setInt(2, Integer.parseInt(tripId));
			rs = pstmt.executeQuery();
			if(rs.next()){
				plannedDuration = rs.getDouble("dur");
				plannedDistance = rs.getDouble("distance");
				// delete other legs
				pstmt1 = con.prepareStatement(CreateTripStatement.DELETE_OLD_LEGS);
				pstmt1.setInt(1, Integer.parseInt(tripId));
				pstmt1.setInt(2, rs.getInt("uniqueId"));
				pstmt1.executeUpdate();
				
				pstmt1 = con.prepareStatement(CreateTripStatement.GET_REMAINING_LEG_DETAILS);
				pstmt1.setInt(1, Integer.parseInt(newRouteId));
				pstmt1.setInt(2, rs.getInt("ID"));
				rs1 = pstmt1.executeQuery();
				while(rs1.next()){
					int detention = rs1.getInt("detTime");
					int tat = rs1.getInt("tat");
					if(rs1.getRow() == 1){
						std = cf.AddOffsetToGmt(sdfmmddyyyyhhmmss.format(yyyymmdd.parse(rs.getString("ACTUAL_ARRIVAL"))), detention);
					}else{
						std = cf.AddOffsetToGmt(prevStd, detention);
					}
					String sta = cf.AddOffsetToGmt(std, tat);
					pstmt2 = con.prepareStatement(CreateTripStatement.INSERT_TRIP_LEG_FOR_NEW_ROUTE);
					pstmt2.setInt(1, Integer.parseInt(tripId));
					pstmt2.setString(2, rs1.getString("legId"));
					pstmt2.setString(3,yyyymmdd.format(sdfmmddyyyyhhmmss.parse(std)));
					pstmt2.setString(4,yyyymmdd.format(sdfmmddyyyyhhmmss.parse(sta)));
					pstmt2.setString(5,driver1);
					pstmt2.setString(6,driver2);
					pstmt2.setInt(7,userId);
					update = pstmt2.executeUpdate();
					
					prevStd = std;
				}
				if(update > 0){
					pstmt1 = con.prepareStatement(CreateTripStatement.GET_RUNNING_SEQUENCE);
					pstmt1.setInt(1, Integer.parseInt(tripId));
					pstmt1.setInt(2, rs.getInt("LEG_ID"));
					rs1 = pstmt1.executeQuery();
					if(rs1.next()){
						pstmt2 = con.prepareStatement(CreateTripStatement.DELETE_OLD_POINTS);
						pstmt2.setInt(1, Integer.parseInt(tripId));
						pstmt2.setInt(2, rs1.getInt("SEQUENCE"));
						pstmt2.executeUpdate();
						
						ArrayList<Integer> legArray = new ArrayList<Integer>();
						int sequence = rs1.getInt("SEQUENCE");
						String exparrival = "";
						String expDep= "";
						int inserted = 0;

						pstmt2 = con.prepareStatement(CreateTripStatement.GET_NOT_COMPLETED_LEGS);
						pstmt2.setInt(1, Integer.parseInt(tripId));
						rs2 = pstmt2.executeQuery();
						while(rs2.next()){
							legArray.add(rs2.getInt("LEG_ID"));
						}
						for(int i = 0; i < legArray.size(); i++){
	                    	pstmt2 = con.prepareStatement(CreateTripStatement.GET_ROUTE_TRASIT_POINTS);
	                        pstmt2.setInt(1, legArray.get(i));
	                        rs2 = pstmt2.executeQuery();
	                        while (rs2.next()) {
	                        	if(!(i == (legArray.size() - 1) && rs2.getString("TYPE").equals("DESTINATION"))){
	                        		sequence++;
	                        		String type= "";
	                        		String startTime = rs1.getString("PLANNED_DEP_DATETIME");
	                        		if(rs2.getString("TYPE").equals("DESTINATION")){
	                        			type = "LEG";
	                        		}
	                        		double dur = ((rs2.getDouble("SEQUENCE_DISTANCE")/rs2.getDouble("AVG_SPEED"))*60);
	                        		String duration = rs2.getString("DURATION");
	                        		if(dur > 0){
	                        			duration = String.valueOf(dur);
	                        		}
	                                int detention = rs2.getInt("detention");
	                                exparrival = getExpectedDatetime(startTime, duration);
	                               
	                                Calendar cal = Calendar.getInstance();
	                                cal.setTime(yyyymmdd.parse(exparrival));
	                                cal.add(Calendar.MINUTE, detention);
	                                expDep = yyyymmdd.format(cal.getTime());
	                                 
	                                pstmt3 = con.prepareStatement(CreateTripStatement.INSERT_TRIP_POINTS_CHECK_POINTS);
	                 				pstmt3.setString(1, tripId);
	                                pstmt3.setString(2, rs2.getString("hubId"));
	                                pstmt3.setString(3, duration);
	                                pstmt3.setInt(4, sequence); 
	                                pstmt3.setString(5, "");
	                                pstmt3.setString(6, exparrival);
	                                pstmt3.setString(7, expDep);
	                                pstmt3.setString(8, rs2.getString("LATITUDE"));
	                                pstmt3.setString(9, rs2.getString("LONGITUDE"));
	                                pstmt3.setString(10, rs2.getString("RADIUS"));
	                                pstmt3.setString(11, newRouteId);
	                                pstmt3.setString(12, rs2.getString("name"));
	                                pstmt3.setInt(13, detention);
	                                pstmt3.setInt(14, legArray.get(i));
	            	                pstmt3.setString(15, type);
	                                inserted = pstmt3.executeUpdate();
	                                if(inserted > 0){
	                                	startTime = expDep;
	                                }
	                            }
	                        }
	        			}
	                    
	                	// To insert Destination
	        			String expDestarrival = "";
	                    pstmt2 = con.prepareStatement(CreateTripStatement.GET_SOURCE_DESTINATION_LEG.concat(" order by ID desc"));
	        			pstmt2.setString(1, tripId);
	        			rs2 = pstmt2.executeQuery();
	        			if(rs2.next()){
	        				pstmt3 = con.prepareStatement(CreateTripStatement.GET_SOURCE_DESTINATION_POINT);
	        				pstmt3.setInt(1, rs2.getInt("LEG_ID"));
	        				pstmt3.setString(2, "DESTINATION");
	        				rs3 = pstmt3.executeQuery();
	        				if(rs3.next()){
	        					double dur = ((rs3.getDouble("SEQUENCE_DISTANCE")/rs3.getDouble("AVG_SPEED"))*60);
	                    		String duration = rs3.getString("DURATION");
	                    		if(dur > 0){
	                    			duration = String.valueOf(dur);
	                    		}
	        					expDestarrival = getExpectedDatetime(expDep, String.valueOf(duration));
	        					pstmt3 = con.prepareStatement(CreateTripStatement.INSERT_TRIP_POINTS_DESTINATION);
	        					pstmt3.setString(1, tripId);
	        	                pstmt3.setString(2, rs3.getString("hubId"));
	        	                pstmt3.setString(3, duration);
	        	                pstmt3.setInt(4, 100); // destination
	        	                pstmt3.setString(5, "");
	        	                pstmt3.setString(6, expDestarrival);
	        	                pstmt3.setInt(7, rs3.getInt("detention"));
	        	                pstmt3.setString(8, expDestarrival);
	        	                pstmt3.setString(9, rs3.getString("LATITUDE"));
	        	                pstmt3.setString(10, rs3.getString("LONGITUDE"));
	        	                pstmt3.setString(11, rs3.getString("RADIUS"));
	        	                pstmt3.setString(12, newRouteId);
	        	                pstmt3.setString(13, rs3.getString("name"));
	        	                pstmt3.setInt(14, rs3.getInt("detention"));
	        	                pstmt3.setInt(15, rs2.getInt("LEG_ID"));
	        	                pstmt3.setString(16, "LEG");
	        	                pstmt3.executeUpdate();
	        	                
	        	                tripEndTime = getExpectedDatetime(expDestarrival, String.valueOf(rs3.getInt("detention")));
	        				}
	        			}
					}
				}
				pstmt = con.prepareStatement(CreateTripStatement.UPDATE_ROUTE_IN_TRIP);
				pstmt.setInt(1, Integer.parseInt(newRouteId));
				pstmt.setString(2, routeName);
				pstmt.setString(3, tripEndTime);
				pstmt.setDouble(4, plannedDistance);
				pstmt.setDouble(5, plannedDuration);
				pstmt.setInt(6, Integer.parseInt(tripId));
				pstmt.executeUpdate();
				
				message = "Route Changed Successfully";
			}
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}	
		return message;
	}
	private String getExpectedDatetime(String dd, String min) {
		Date startDate = null;
		String expdate = "";
		SimpleDateFormat sdfSSyy = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		Calendar cal = Calendar.getInstance();
		try {
			int hour = (int) (Float.parseFloat(min)/60);
			int minute = (int) (Float.parseFloat(min)%60);
			cal.setTime(sdfSSyy.parse(dd));
			cal.add(Calendar.HOUR, hour);
			cal.add(Calendar.MINUTE, minute);
			startDate = cal.getTime();

			expdate = sdfSSyy.format(startDate);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return expdate;
	}
	
	public ArrayList<String> getTripSheetSettingData(int systemId, int customerId) {

		ArrayList<String> settingData = new ArrayList<String>();
		Connection con=null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		PreparedStatement pstmt1=null;
		ResultSet rs1=null;
		String avgSpeed = "1";
		String checkBox="N";
		String vehicleReporting="N";
		String extraFields="N";
		String hubAssociatedRoutes="N";
		String vehicleSwap = "N";
		String rowData = "";
		String materialClient = "N";
		String category= "N";
		String humidity= "N";
		String temperature= "N";
		String events= "N";
		String canOverrideActualTimeUsers = "";
		int count=0;
		try{
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(CreateTripStatement.GET_TRIP_SHEET_SETTING_DETAILS);
			pstmt.setInt(1,customerId);
			pstmt.setInt(2,systemId);
			rs=pstmt.executeQuery();
			
			if(rs.next()){
				settingData.add(rs.getString("AVERAGE_SPEED"));
				settingData.add(rs.getString("ALL_EVENTS"));
				settingData.add(rs.getString("EXTRA_DATA_FIELDS"));
				settingData.add(rs.getString("VEHICLE_REPORTING"));
				settingData.add(rs.getString("HUB_ASSOCIATED_ROUTES"));
				settingData.add(rs.getString("VEHICLE_SWAP"));
				if(rs.getString("EXTRA_DATA_FIELDS").equalsIgnoreCase("Y")){
					pstmt1 = con.prepareStatement(CreateTripStatement.GET_TRIP_SHEET_DATA_FIELDS_SETTING_DETAILS);
					pstmt1.setInt(1,systemId);
					pstmt1.setInt(2,customerId);
					rs1=pstmt1.executeQuery();
					while(rs1.next()){
						if(count==3){
							rowData = rowData + "</tr><tr>" ;
							count=0;
						}
						rowData = rowData + rs1.getString("FIELD_NAME") + rs1.getString("FIELD_VALUE");
						count++;
					}
					rowData="<tr>" + rowData + "</tr>" ;
					settingData.add(rowData);
				}else{
					settingData.add(rowData);
				}
				settingData.add(rs.getString("MATERIAL_CLIENT"));//7
				settingData.add(rs.getString("OVERRIDE_ACTUAL_TIME_USERS"));//8
				settingData.add(rs.getString("CATEGORY"));//9
				settingData.add(rs.getString("HUMIDITY"));//10
				settingData.add(rs.getString("TEMPERATURE"));//11
				settingData.add(rs.getString("EVENTS"));//12
			}
			else{
				settingData.add(avgSpeed);
				settingData.add(checkBox);
				settingData.add(extraFields);
				settingData.add(vehicleReporting);
				settingData.add(hubAssociatedRoutes);
				settingData.add(vehicleSwap);
				settingData.add(rowData);
				settingData.add(materialClient);
				settingData.add(canOverrideActualTimeUsers);
				settingData.add(category);
				settingData.add(humidity);
				settingData.add(temperature);
				settingData.add(events);
			}
		}catch(Exception e){
			e.printStackTrace();
		}	
		finally{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
			DBConnection.releaseConnectionToDB(null, pstmt1, rs1);
		}	
		return settingData;
	
	}
	
	public String saveSwappedVehicleDetails(int userId,String tripId,String oldVehicleNo,String newVehicleNo,String vehicleSwapRemarks,LogWriter logWriter,String sessionId) {
		logWriter.log("Start of CreateTripFunction.saveSwappedVehicleDetails method "+sessionId+"::oldVehicleNo:"+oldVehicleNo+"::newVehicleNo"+newVehicleNo, LogWriter.INFO);
		Connection con=null;
		PreparedStatement pstmt=null;
		int updated = 0;
		String message = "";
		try{
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(CreateTripStatement.UPDATED_SWAPPED_VEHICLE_NUMBER_FOR_TRIP);
			pstmt.setString(1,newVehicleNo);
			pstmt.setString(2,oldVehicleNo);
			pstmt.setString(3,vehicleSwapRemarks);
			pstmt.setInt(4,userId);
			pstmt.setString(5,tripId);
			updated=pstmt.executeUpdate();
			if (updated > 0) {
		        message = "Updated Successfully";
		    }else{
		    	message = "Error While Updating";
		    }
		}catch(Exception e){
			logWriter.log("Error in CreateTripFunction.saveSwappedVehicleDetails method "+sessionId+message,LogWriter.ERROR);
			e.printStackTrace();
		}	
		finally{
			DBConnection.releaseConnectionToDB(con, pstmt, null);
		}	
		logWriter.log("End of CreateTripFunction.saveSwappedVehicleDetails method "+sessionId+message,LogWriter.INFO);
		return message;
	
	}
	
	
	public void getDriverAndUpdate(int tripId,String legId,String driver1, String driver2,Connection con,String vehicleNo, int  systemId,int custId) {
		String legDriver1,legDriver2 = "";
		String legDriver1No,legDriver2No = "";
		PreparedStatement pstmt=null,pstmt1=null,pstmt2=null;
		ResultSet rs1=null,rs2=null,rs3=null;
		try{
			pstmt1 = con.prepareStatement(CreateTripStatement.GET_TRIP_DRIVER_DETAILS);
			pstmt1.setInt(1, tripId);
			pstmt1.setString(2, legId);
			rs1= pstmt1.executeQuery();
			String driver = "";
			while(rs1.next()){
				if(rs1.getRow() == 1){
					driver = driver1;
				}else{
					driver = driver2;
				}
				pstmt = con.prepareStatement(CreateTripStatement.UPDTAE_TRIP_DRIVER_DETAILS);
				pstmt.setString(1, driver);
				pstmt.setString(2, rs1.getString("ID"));
				pstmt.setInt(3, tripId);
				pstmt.setString(4, legId);
				
				pstmt.executeUpdate();
			}
			
			ArrayList<String> legDrivers = new ArrayList<String>();
			legDrivers.add(driver1);
			legDrivers.add(driver2);
			
			
			pstmt1 = con.prepareStatement(CreateTripStatement.GET_RUNNING_LEG);
			pstmt1.setInt(1, tripId);
			rs3 = pstmt1.executeQuery();
			if (rs3.next()){
				 legDriver1="NA";legDriver2 = "NA";
				 legDriver1No="NA";legDriver2No = "NA";
				int currentLeg = rs3.getInt("LEG_ID");
				if (Integer.parseInt(legId) == currentLeg){
					for (String dr : legDrivers){
						if (dr.equals("")){
							dr = "0";
						}
						if (Integer.parseInt(dr) > 0){
							pstmt2  = con.prepareStatement(CreateTripStatement.GET_DRIVER_NAME);
							pstmt2.setString(1, dr);
							pstmt2.setInt(2, systemId);
							pstmt2.executeQuery();
							rs2 = pstmt2.executeQuery();
							while(rs2.next()){
								if (legDrivers.indexOf(dr) == 0){
									legDriver1 = rs2.getString("DRIVER_NAME");
									legDriver1No = rs2.getString("Mobile");
								}
								else{
									legDriver2 = rs2.getString("DRIVER_NAME");
									legDriver2No = rs2.getString("Mobile");
								}
							}
						}
					}
					updateDriversToLiveVision(legDriver1,legDriver1No,legDriver2,legDriver2No,con,vehicleNo,systemId,custId);
				}
			}
				
		}catch(Exception e){
			e.printStackTrace();
		}	
		finally{
			
		}	
		//return message;
	
	}
	
	public String checkIsATAValid(int tripId,String ata,int offset){
		Connection con=null;
		PreparedStatement pstmt=null;
		SimpleDateFormat sdfFormatDate = new SimpleDateFormat("dd/MM/yyyy HH:mm");
		String date = "";
		try {
			ata = yyyymmdd.format(sdfFormatDate.parse(ata));
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(CreateTripStatement.CHECK_IS_VALID_ATA);
			pstmt.setInt(1,offset);
			pstmt.setString(2,ata);
			pstmt.setInt(3,offset);
			pstmt.setInt(4,tripId);
			ResultSet rs = pstmt.executeQuery();
			if(rs.next()){
				if(!rs.getBoolean("IS_VALID")){
					date = sdfFormatDate.format(yyyymmdd.parse(rs.getString("maxDate")));
				}
			}
		}catch (Exception e) {
			e.printStackTrace();
			date = "invalid";
		}finally{
			DBConnection.releaseConnectionToDB(con, pstmt, null);
		}
		return date;
	}
	
	public String updateTripActualTime(String atp, String atd, String std, int offset, int systemId,int clientId,String vehicleNo, 
			int tripId,String remarks,int userId,LogWriter logWriter,String sessionId, String serverName, String ata, boolean atpChanged, 
			boolean atdChanged, boolean ataChanged){
		if(logWriter != null){
			logWriter.log("Start of CreateTripFunction.updateTripActualTime method "+sessionId+":::atp:"+atp+"::atd:"+atd+"::tripId:"+tripId, LogWriter.INFO);
		}
		Connection con=null;
		ResultSet rs = null;
		PreparedStatement pstmt1 = null;
		PreparedStatement pstmt=null;
		String lrNo = "";
		StringBuilder auditAction = new StringBuilder();
		try {
			con = DBConnection.getConnectionToDB("AMS");
			if(!atp.equals("") && !atp.contains("1900")){
				atp = yyyymmdd.format(sfddMMYYYY.parse(atp+":00"));
			}
			if(!atd.equals("") && !atd.contains("1900")){
				atd = yyyymmdd.format(sfddMMYYYY.parse(atd+":00"));
			}
			if(!ata.equals("") && !ata.contains("1900")){
				ata = yyyymmdd.format(sfddMMYYYY.parse(ata+":00"));
			}
			std = yyyymmdd.format(sfddMMYYYY.parse(std+":00"));
			
			UpdateTrip updatedTrip = new UpdateTrip(offset,atp,atd,tripId,remarks,userId,ataChanged,atdChanged,ata,atpChanged);
			Thread thread = new Thread(updatedTrip);
			thread.start();
			
			// SAP API CALL
			pstmt1 = con.prepareStatement(CreateTripStatement.GET_ROUTE_ID_AND_VEHICLE_NUMBER_BY_TRIP_ID);
			pstmt1.setInt(1, tripId);
			pstmt1.setInt(2, systemId);
			pstmt1.setInt(3, clientId);
			rs = pstmt1.executeQuery();
			if (rs.next()) {
				lrNo = rs.getString("ORDER_ID");
				String startLoc = rs.getString("SOURCE_NAME").contains(",") ? rs.getString("SOURCE_NAME").substring(0,
						rs.getString("SOURCE_NAME").indexOf(",")) : rs.getString("SOURCE_NAME");
				String endLoc = rs.getString("DEST_NAME").contains(",") ? rs.getString("DEST_NAME").substring(0,
						rs.getString("DEST_NAME").indexOf(",")) : rs.getString("DEST_NAME");
				
				auditAction.append("UpdatedEvent :- ");
				if (systemId == 268 && !lrNo.contains("DHL")) {
					ArrayList<String> apiDetails = getAPIConfiguration(con, "Trip_Exec");
					if (!atp.contains("1900") && !atp.equals("") && atpChanged) {
						atp = sfddMMYYYY.format(yyyymmdd.parse(atp));
						try {
							logWriter.log("Separate ATP event is calling SAP for ATP override : " + lrNo,
									LogWriter.INFO);
							cf.SAPAPICall(lrNo, rs.getString("srcSuccessor"), "ATP", startLoc, 0, logWriter, apiDetails.get(0),
									apiDetails.get(1), atp);

							logWriter.log("SAP API is calling for ATP override : " + lrNo, LogWriter.INFO);
							cf.SAPAPICall(lrNo, rs.getString("srcSuccessor"), "ARRIV_DEST", startLoc, 0, logWriter, apiDetails.get(0),
									apiDetails.get(1), atp);
							auditAction.append("ATP,");
						} catch (final Exception e) {
							e.printStackTrace();
						}
					}
					if (!atd.contains("1900") && !atd.equals("") && atdChanged) {
						atd = sfddMMYYYY.format(yyyymmdd.parse(atd));
						try {
							logWriter.log("SAP API is calling for ATD override : " + lrNo, LogWriter.INFO);
							cf.SAPAPICall(lrNo, rs.getString("srcSuccessor"), "DEPARTURE", startLoc, 0, logWriter, apiDetails.get(0),
									apiDetails.get(1), atd);
							auditAction.append("ATD,");
						} catch (final Exception e) {
							e.printStackTrace();
						}
					}
					
					if(!ata.contains("1900") && !ata.equals("") && ataChanged){
						ata = sfddMMYYYY.format(yyyymmdd.parse(ata));
						try{
							logWriter.log("SAP API is calling for ATA override : " + lrNo, LogWriter.INFO);
							cf.SAPAPICall(lrNo, rs.getString("destSuccessor"), "ARRIV_DEST", endLoc, 0, logWriter, apiDetails.get(0),
									apiDetails.get(1), ata);
							auditAction.append("ATA,");
						}catch(final Exception e){
							e.printStackTrace();
						}
					}
				}
				try{
					cf.insertDataIntoAuditLogReport("Trip Solution :- Override Actuals", auditAction, userId, 
							systemId, clientId, serverName,tripId,remarks);
				}catch(final Exception e){
					e.printStackTrace();
				}
			}
			return "Successfully updated!";
		} catch (Exception e) {
			e.printStackTrace();
			if(logWriter != null){
				logWriter.log("Error of CreateTripFunction.updateTripActualTime method "+sessionId + e.getMessage(), LogWriter.INFO);
			}
			return "Failed to update";
		}finally{
			DBConnection.releaseConnectionToDB(con, pstmt, null);
		}
	}
	// unused method as generating LR no automatically
	public String validateTripLRNo(String lrNo,int systemId,int customerId,String tripCustomerId) {
		Connection con=null;
		PreparedStatement pstmt=null;
		ResultSet rs = null;
		String message = "NO RECORDS FOUND";
		try{
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(CreateTripStatement.VALIDATE_TRIP_LR_NO);
			pstmt.setInt(1,systemId);
			pstmt.setInt(2,customerId);
			pstmt.setString(3,lrNo);
		//	pstmt.setString(4,tripCustomerId);
			rs = pstmt.executeQuery();
			if (rs.next()){
				int count = rs.getInt("LR_NO_COUNT");
				if (count > 0){
					message = "RECORDS FOUND";
				}
			}
			
		}catch(Exception e){
			e.printStackTrace();
		}	
		finally{
			DBConnection.releaseConnectionToDB(con, pstmt, null);
		}	
		return message;
	
		
	}
	
	
	public JSONArray getTempConfigurationsByVehicleNo(int systemId, int custId1, String regNo) {
		JSONArray jsonArray = new JSONArray();
		JSONObject object = null;
		Connection con=null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		try{
			List<TemperatureConfigurationBean> tempConfigDetails = TemperatureConfiguration.getTemperatureConfigurationDetails(systemId,custId1,regNo);
			for (TemperatureConfigurationBean aTempConfigDetails : tempConfigDetails) {
			    object = new JSONObject();
				object.put("name", aTempConfigDetails.getName());
				object.put("minPositiveTemp", aTempConfigDetails.getMinPositiveTemp() == null ? 0 : aTempConfigDetails.getMinPositiveTemp());
				object.put("minNegativeTemp", aTempConfigDetails.getMinNegativeTemp() == null ? 0 : aTempConfigDetails.getMinNegativeTemp());
				object.put("maxPositiveTemp", aTempConfigDetails.getMaxPositiveTemp() == null ? 0 : aTempConfigDetails.getMaxPositiveTemp());
				object.put("maxNegativeTemp", aTempConfigDetails.getMaxNegativeTemp() == null ? 0 : aTempConfigDetails.getMaxNegativeTemp());
				object.put("sensorName", aTempConfigDetails.getSensorName());
				jsonArray.put(object);
			}
		}catch(Exception e){
			e.printStackTrace();
		}	
		finally{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}	
		return jsonArray;
	}
	
	public  String getUniqueLRNo(int systemId,int customerId,Connection con,String customerName) throws SQLException {
		PreparedStatement pstmt=null,pstmt1=null;
		ResultSet rs = null;
		String lrNo = "";
		DecimalFormat df = new DecimalFormat("000000");
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
					 
					 pstmt1.close();
				}/*else{   commenting as trip count is taking from trip sheet setting page
					count = 1;
					pstmt1 = con.prepareStatement(CreateTripStatement.INSERT_NEW_RECORD_FOR_TRIP_LOOKUP_DETAILS);
					pstmt1.setInt(1, count);
					pstmt1.setInt(2, systemId);
					pstmt1.setInt(3, customerId);
					pstmt1.executeUpdate();
					
				}*/
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
			rs.close();
		}	
		return lrNo;
	
		
	}
	
	public JSONArray getTripCancellationRemarks(int systemId) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject = null;
		int count = 0;
		try{
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(CreateTripStatement.GET_TRIP_CANCELLATION_REMARKS);
			rs = pstmt.executeQuery();
			jsonObject = new JSONObject();
			jsonObject.put("id", count);
			jsonObject.put("value", "--Select Remarks--");
			jsonArray.put(jsonObject);	
			while(rs.next()){
				jsonObject = new JSONObject();
				jsonObject.put("id", ++count);
				jsonObject.put("value", rs.getString("VALUE"));
				jsonArray.put(jsonObject);	
			}
		}catch(Exception e){
			e.printStackTrace();
		}	
		finally{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}	
		return jsonArray;
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
	
	public void updateDriversToLiveVision(String legDriver1,String legDriver1No,String legDriver2, String legDriver2No,Connection con,String vehicleNo,int systemId, int custId) throws SQLException {
		PreparedStatement pstmt=null;
		try{
			
				pstmt = con.prepareStatement(CreateTripStatement.UPDTAE_DRIVERS_TO_LIVE_VISION);
				pstmt.setString(1, legDriver1+" / "+legDriver2);
				pstmt.setString(2, legDriver1No+" / "+ legDriver2No);
				pstmt.setString(3, vehicleNo);
				pstmt.setInt(4, systemId);
				pstmt.setInt(5, custId);
				
				pstmt.executeUpdate();
				
		}catch(Exception e){
			e.printStackTrace();
		}	
		finally{
			pstmt.close();
			
		}	
	
	}
	
	public JSONArray getExistingTempConfigurationsForVehicleNo(int systemId, int custId1,String tripId,String vehicleNo) {
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject = null;
		Connection con=null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		try{
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(CreateTripStatement.GET_TEMPERATURE_CONFIGURATIONS);
			pstmt.setString(1, tripId);
			pstmt.setString(2, vehicleNo);
			
			rs = pstmt.executeQuery();
			while(rs.next()){
				jsonObject = new JSONObject();
				jsonObject.put("minNegativeTemp", rs.getString("MIN_NEGATIVE_TEMP"));
				jsonObject.put("maxNegativeTemp", rs.getString("MAX_NEGATIVE_TEMP"));
				jsonObject.put("minPositiveTemp", rs.getString("MIN_POSITIVE_TEMP"));
				jsonObject.put("maxPositiveTemp", rs.getString("MAX_POSITIVE_TEMP"));
				jsonObject.put("name", rs.getString("DISPLAY_NAME"));
				jsonObject.put("sensorName", rs.getString("SENSOR_NAME"));
				jsonObject.put("triggerAlert",rs.getString("TRIGGER_ALERT"));
				jsonArray.put(jsonObject);	
			}
			
			if (jsonArray.length() <=0){
				List<TemperatureConfigurationBean> tempConfigDetails = TemperatureConfiguration.getTemperatureConfigurationDetails(systemId,custId1,vehicleNo);
				for (TemperatureConfigurationBean aTempConfigDetails : tempConfigDetails) {
					jsonObject = new JSONObject();
					jsonObject.put("name", aTempConfigDetails.getName());
					jsonObject.put("minPositiveTemp", aTempConfigDetails.getMinPositiveTemp() == null ? 0 : aTempConfigDetails.getMinPositiveTemp());
					jsonObject.put("minNegativeTemp", aTempConfigDetails.getMinNegativeTemp() == null ? 0 : aTempConfigDetails.getMinNegativeTemp());
					jsonObject.put("maxPositiveTemp", aTempConfigDetails.getMaxPositiveTemp() == null ? 0 : aTempConfigDetails.getMaxPositiveTemp());
					jsonObject.put("maxNegativeTemp", aTempConfigDetails.getMaxNegativeTemp() == null ? 0 : aTempConfigDetails.getMaxNegativeTemp());
					jsonObject.put("sensorName", aTempConfigDetails.getSensorName());
					jsonArray.put(jsonObject);
				}
			}
		}catch(Exception e){
			e.printStackTrace();
		}	
		finally{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}	
		return jsonArray;
	}//
	
	
	public void updateTemperature(String tempData,String productLine,Connection con,int tripId,String vehicleNo,String vehicleNoOld,int systemId,int custId,String selSensorsToAlertTrigger) {
		PreparedStatement pstmt=null,pstmt1 = null;
		try{
			
    			pstmt1 = con.prepareStatement(CreateTripStatement.DELETE_TRIP_VEHICLE_TEMPERATURE_DETAILS);
				pstmt1.setInt(1, tripId);
			    pstmt1.executeUpdate();
				
				if (productLine.equalsIgnoreCase("TCL") || productLine.equalsIgnoreCase("Chiller") || productLine.equalsIgnoreCase("Freezer")){
				JSONArray array = new JSONArray(tempData);
				List<TemperatureConfigurationBean> tempConfigDetails = TemperatureConfiguration.getTemperatureConfigurationDetails(systemId,custId,vehicleNo);
	        	 for (int i = 0 ; i < tempConfigDetails.size(); i++) {
	        		 JSONObject obj = array.getJSONObject(0);
	        		 TemperatureConfigurationBean tempObj = tempConfigDetails.get(i);
	        		String minNeg = obj.getString("minNegMod");
	        		String maxNeg = obj.getString("maxNegMod");
	        		String minPos = obj.getString("minPosMod");
	        		String maxPos = obj.getString("maxPosMod");
    					pstmt = con.prepareStatement(CreateTripStatement.INSERT_TRIP_VEHICLE_TEMPERATURE_DETAILS);
	        			pstmt.setInt(1,tripId);
		        		pstmt.setString(2,vehicleNo);
		        		pstmt.setString(3,tempObj.getName());
		        		pstmt.setString(4,tempObj.getSensorName());
		        		pstmt.setString(5,minNeg);
		        		pstmt.setString(6,minPos);
		        		pstmt.setString(7,maxNeg);
		        		pstmt.setString(8,maxPos);
		        		if(selSensorsToAlertTrigger != null && tempObj.getSensorName() != null)
		        			pstmt.setString(9, selSensorsToAlertTrigger.contains(tempObj.getSensorName()) ? "Y" : "N");
		        		else
		        			pstmt.setString(9,"N");
		        		pstmt.executeUpdate();
	        				
	        	}
			  }
			
		}catch (Exception e) {
			e.printStackTrace();
		}finally{
			
		}
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
		
			if(productLine.equalsIgnoreCase("TCL")|| productLine.equalsIgnoreCase("Chiller") || productLine.equalsIgnoreCase("Freezer"))//|| productLine.equalsIgnoreCase("Freezer"))
			{
				pstmt = con.prepareStatement(CreateTripStatement.GET_AVAILABLE_VEHICLES);
				pstmt.setInt(1, systemId);
				pstmt.setInt(2, clientId);
				pstmt.setInt(3, userId);
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
	 public JSONArray getColumnSetting(int systemId,String customerId, int userId, String pageName,int custId){
		 JSONArray array = new JSONArray();
		 JSONArray finarray = new JSONArray();
		 JSONObject jsonObject;
		 Connection con = null;
		 PreparedStatement pstmt = null;
	 	 ResultSet rs = null;
	 	 PreparedStatement pstmt1 = null;
	 	 ResultSet rs1 = null;
	 	 List<JSONObject>expList =null;
	 	 String message  = null;
	 	 Date date = new Date();
	 	 String custList=""; 
	 	 String [] cArray = null;
	 	 if (customerId!="")
	 	 {
	 		 cArray=customerId.split(",");
			for (int i = 0; i < cArray.length; i++) {
				custList=custList+"'"+cArray[i]+"',";
			}
			custList=custList.substring(0,custList.length()-1); 
	 	 }
	 	 try{
	 		con = DBConnection.getConnectionToDB("AMS");
	 			for(int i=0;i<cArray.length;i++)
	 			{
		 		 	pstmt=con.prepareStatement(CommonStatements.GET_COLUMN_SETTING.replace("#", cArray[i]));
		 		 	pstmt.setInt(1, systemId);
		 		 	pstmt.setInt(2, 5560);
					pstmt.setInt(3, userId);
					pstmt.setString(4, pageName);
					rs = pstmt.executeQuery();
					array=new JSONArray();
						while(rs.next()){
					    	jsonObject = new JSONObject();
					    	jsonObject.put("id", rs.getString("ID"));
					    	jsonObject.put("columnName", rs.getString("COLUMN_NAME"));
					    	jsonObject.put("visibility", (Integer.parseInt(rs.getString("VISIBILITY"))==1)? "true":"false");
					    	jsonObject.put("cusName", rs.getInt("TRIPCUSTOMER_ID"));
					    	array.put(jsonObject);
					    }
					    finarray.put(array);	
					}
				    
	 		
 	 	}catch (Exception e) {
			e.printStackTrace();
		}finally{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return finarray;
	 }
	 public JSONArray updateColumnSetting(int systemId, String customerList, int userId,List settingsList,String pageName,int custId){
		 JSONArray array = new JSONArray();
		 JSONObject jsonObject;
		 Connection con = null;
		 PreparedStatement pstmt = null;
	 	 ResultSet rs = null;
	 	 List<JSONObject>expList =null;
	 	 String message  = null;
	 	 Date date = new Date();
	 	 try{
	 		 con = DBConnection.getConnectionToDB("AMS");
	 		//pstmt=con.prepareStatement(CommonStatements.UPDATE_COLUMN_SETTING);
	 		pstmt=con.prepareStatement(CommonStatements.UPDATE_COLUMN_SETTING);
	 		 for(int i=0; i <settingsList.size(); i++){ 
	 			LinkedTreeMap map = (LinkedTreeMap)settingsList.get(i);
	 		 	pstmt.setInt(1, (map.get("visibility").toString().equals("true"))?1 :0);
	 			pstmt.setInt(2, Integer.parseInt(map.get("id").toString().split(",")[0]));
	 		 	pstmt.setInt(3, systemId);
				pstmt.setInt(4, Integer.parseInt(map.get("id").toString().split(",")[1]));
				pstmt.setInt(5, userId);
				pstmt.setString(6, pageName);
				pstmt.setInt(7, 5560);
				pstmt.executeUpdate();
				pstmt.addBatch();
	 		 }
	 		pstmt.executeBatch(); 
	 		//insertColumnSetting(systemId,customerList,userId,settingsList,pageName);
 	 	}catch (Exception e) {
			e.printStackTrace();
		}finally{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return array;
	 } 
	 public JSONArray insertColumnSetting(int systemId, String customerList, int userId,List settingsList,String pageName,int custId){
		 JSONArray array = new JSONArray();
		 JSONObject jsonObject;
		 Connection con = null;
		 PreparedStatement pstmt = null;
	 	 ResultSet rs = null;
	 	 List<JSONObject>expList =null;
	 	 String message  = null;
	 	 Date date = new Date();
	 	 int count=1;
	 	 try{
	 		 con = DBConnection.getConnectionToDB("AMS");
	 		pstmt=con.prepareStatement(CommonStatements.INSERT_LIST_VIEW_COLUMN_SETTING);
	 		 for(int i=0; i <settingsList.size(); i++){ //Implement batch update
	 			LinkedTreeMap map = (LinkedTreeMap)settingsList.get(i);
	 		 	pstmt.setString(1, pageName);
	 			pstmt.setString(2, map.get("columnName").toString().split(",")[0]);
	 			pstmt.setInt(3, (map.get("visibility").toString().equals("true"))?1 :0);
	 		 	pstmt.setInt(4, systemId);
				pstmt.setInt(5, Integer.parseInt(map.get("columnName").toString().split(",")[1]));
				pstmt.setInt(6, userId);
				pstmt.setInt(7, count++);
				pstmt.setInt(8, 5560);
				pstmt.addBatch();
	 		 }
	 		pstmt.executeBatch();  
	 		
 	 	}catch (Exception e) {
			e.printStackTrace();
		}finally{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return array;
	 }
	 
	public JSONArray getCustomerNames(int cutomerId, int systemId) {

		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject = new JSONObject();
		Connection con=null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		PreparedStatement pstmt1=null;
		ResultSet rs1=null;
		try{
			con = DBConnection.getConnectionToDB("AMS");
			jsonArray = new JSONArray();
			jsonObject = new JSONObject();
			pstmt = con.prepareStatement(CreateTripStatement.GET_CUSTOMER_NAMES);
			pstmt.setInt(1,cutomerId);
			pstmt.setInt(2,systemId);
			rs=pstmt.executeQuery();
			jsonObject = new JSONObject();
			jsonObject.put("CustId", 0);
			jsonObject.put("CustName", "None");
			jsonArray.put(jsonObject);	
			while(rs.next()){
				jsonObject = new JSONObject();
				jsonObject.put("CustId", rs.getString("ID"));
				jsonObject.put("CustName", rs.getString("NAME"));
				jsonArray.put(jsonObject);				
			}
		}catch(Exception e){
			System.out.println("Error in getCustomer "+e.toString());
		}	
		finally{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
			DBConnection.releaseConnectionToDB(null, pstmt1, rs1);
		}	
		return jsonArray;
	
	}
	public JSONArray getTripCustomerNames(int cutomerId, int systemId) {

		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject = new JSONObject();
		Connection con=null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		PreparedStatement pstmt1=null;
		ResultSet rs1=null;
		try{
			con = DBConnection.getConnectionToDB("AMS");
			jsonArray = new JSONArray();
			jsonObject = new JSONObject();
			pstmt = con.prepareStatement(CreateTripStatement.GET_CUSTOMER_NAMESCE);
			pstmt.setInt(1,cutomerId);
			pstmt.setInt(2,systemId);
			rs=pstmt.executeQuery();
			jsonObject = new JSONObject();
			jsonObject.put("CustId", 0);
			jsonObject.put("CustName", "None");
			jsonArray.put(jsonObject);	
			while(rs.next()){
				jsonObject = new JSONObject();
				jsonObject.put("CustId", rs.getString("ID"));
				jsonObject.put("CustName", rs.getString("NAME"));
				jsonArray.put(jsonObject);				
			}
		}catch(Exception e){
			System.out.println("Error in getCustomer "+e.toString());
		}	
		finally{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
			DBConnection.releaseConnectionToDB(null, pstmt1, rs1);
		}	
		return jsonArray;
	
	}
	public JSONArray getTripsWithoutActuals(int systemId, int customerId, int offset, String userAuthority, String startDate, String endDate) {
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		SimpleDateFormat sfddMMYYYY = new SimpleDateFormat("dd/MM/yyyy HH:mm");
		try {
			con = DBConnection.getConnectionToDB("AMS");
			//if("ProdOwn".equalsIgnoreCase(userAuthority) || "T4u Users".equalsIgnoreCase(userAuthority)){
			if(userAuthority.equalsIgnoreCase("true")){
				pstmt = con.prepareStatement(CreateTripStatement.GET_TRIPS_WITHOUT_ACTUALS.replace("#", 
						" and td.ACTUAL_TRIP_END_TIME between dateadd(mi,-"+offset+",'"+startDate+"') and dateadd(mi,-"+offset+",'"+endDate+"')")); 
			}else{
				pstmt = con.prepareStatement(CreateTripStatement.GET_TRIPS_WITHOUT_ACTUALS.replace("#", " and (td.ACT_SRC_ARR_DATETIME is null " +
						" or td.ACTUAL_TRIP_START_TIME is null or td.ACTUAL_TRIP_END_TIME is null or de100.ACT_ARR_DATETIME is null)"));
			}
			pstmt.setInt(1, offset);
			pstmt.setInt(2, offset);
			pstmt.setInt(3, offset);
			pstmt.setInt(4, offset);
			pstmt.setInt(5, systemId);
			pstmt.setInt(6, customerId);
			rs = pstmt.executeQuery();
			int count = 0;
			while (rs.next()) {
				jsonObject = new JSONObject();
				jsonObject.put("slNo", ++count);
				jsonObject.put("tripId", rs.getString("TRIP_ID"));
				jsonObject.put("orderId", rs.getString("ORDER_ID"));
				jsonObject.put("vehicleNumber", rs.getString("ASSET_NUMBER"));
				jsonObject.put("ATP", rs.getString("ATP").contains("1900") ? "" : sfddMMYYYY.format(yyyymmdd.parse(rs.getString("ATP"))).replace(" ", "#"));
				jsonObject.put("ATD", rs.getString("ATD").contains("1900") ? "" : sfddMMYYYY.format(yyyymmdd.parse(rs.getString("ATD"))).replace(" ", "#"));
				jsonObject.put("ATA", rs.getString("ATA").contains("1900") ? "" : sfddMMYYYY.format(yyyymmdd.parse(rs.getString("ATA"))).replace(" ", "#"));
				jsonObject.put("TripEndTime", rs.getString("TripEndTime").contains("1900") ? "" : sfddMMYYYY.format(yyyymmdd.parse(rs.getString("TripEndTime"))).replace(" ", "#"));
				jsonObject.put("atpOrAtdOverridden", rs.getString("atpAtdOverridden"));
				jsonObject.put("ataOverridden", rs.getString("ataOverridden"));
				jsonObject.put("shipmentId", rs.getString("SHIPMENT_ID"));
				jsonObject.put("button", "<button onclick=loadActualDetailsOfClosedTrip(" + jsonObject + "); class='btn btn-warning'>Update Actuals</button>");
				jsonArray.put(jsonObject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jsonArray;
	}
	public String updateActuals(int userId, int tripId, int systemId, int clientId, int offset, String vehicleNo, String ata,
			LogWriter logWriter, String atp, String atd, String tripEndTime, boolean atpChanged, boolean atdChanged, 
			boolean ataChanged, boolean tripEndTimeChanged,String serverName) {
		Connection con = null;
		PreparedStatement pstmt = null, pstmt1 = null;
		ResultSet rs1 = null;
		String message = "";
		StringBuilder auditLogActionForUpdateActuals = new StringBuilder();
		try {
			con = DBConnection.getConnectionToDB("AMS");
			ArrayList<String> APIConfig = getAPIConfiguration(con, "Trip_Exec");
			/*@Author : Vinay H
			 * Calling thread while updating the trip related table for reopen.
			*/
			pstmt1 = con.prepareStatement(CreateTripStatement.GET_ROUTE_ID_AND_VEHICLE_NUMBER_BY_TRIP_ID);
			pstmt1.setInt(1, tripId);
			pstmt1.setInt(2, systemId);
			pstmt1.setInt(3, clientId);
			rs1 = pstmt1.executeQuery();
			if (rs1.next()) {
				/* Vinay H
				 * Calling Thread while updating the trip relating tables.
				*/
				String startLoc = rs1.getString("SOURCE_NAME").contains(",") ? rs1.getString("SOURCE_NAME").substring(0,rs1.getString("SOURCE_NAME").indexOf(",")) : rs1.getString("SOURCE_NAME");
				String endLoc = rs1.getString("DEST_NAME").contains(",") ? rs1.getString("DEST_NAME").substring(0,rs1.getString("DEST_NAME").indexOf(",")) : rs1.getString("DEST_NAME");
				
				TripCloseOrReopenThread tripCloseOrReopenThread = new TripCloseOrReopenThread("ACTUALSUPDATE", userId,
						"", tripId, vehicleNo, logWriter,rs1.getString("TRIP_STATUS"), endLoc, ata, offset,
						systemId, clientId, "", tripEndTime, atp, atd,atpChanged,atdChanged,ataChanged,tripEndTimeChanged);
				Thread thread = new Thread(tripCloseOrReopenThread);
				thread.start();
				
				auditLogActionForUpdateActuals.append("Updated evnts :- ");
				if (systemId == 268 && !rs1.getString("ORDER_ID").contains("DHL")) {
					if (atpChanged) {
						cf.SAPAPICall(rs1.getString("ORDER_ID"), rs1.getString("srcSuccessor"), "ATP", startLoc, 0,
								logWriter, APIConfig.get(0), APIConfig.get(1), atp + ":00");
						cf.SAPAPICall(rs1.getString("ORDER_ID"), rs1.getString("srcSuccessor"), "ARRIV_DEST", startLoc,
								0, logWriter, APIConfig.get(0), APIConfig.get(1), atp + ":00");
						
						auditLogActionForUpdateActuals.append("ATP,");
					}
					if (atdChanged) {
						cf.SAPAPICall(rs1.getString("ORDER_ID"), rs1.getString("srcSuccessor"), "DEPARTURE", startLoc,
								0, logWriter, APIConfig.get(0), APIConfig.get(1), atd + ":00");
						
						auditLogActionForUpdateActuals.append("ATD,");
					}
					if (ataChanged || tripEndTimeChanged) {
						String eventCode = "Empty Trip".equalsIgnoreCase(rs1.getString("tripCustType")) ? "ARRIV_DEST": "UNLOAD_END";
						if (!"Empty Trip".equalsIgnoreCase(rs1.getString("tripCustType"))) {
							cf.SAPAPICall(rs1.getString("ORDER_ID"), "", "ARRIV_DEST", endLoc, 0, logWriter, APIConfig
									.get(0), APIConfig.get(1), ata + ":00");
						}
						cf.SAPAPICall(rs1.getString("ORDER_ID"), "", eventCode, endLoc, 0, logWriter, APIConfig.get(0),
								APIConfig.get(1), tripEndTime + ":00");
						
						auditLogActionForUpdateActuals.append("ATA,");
						auditLogActionForUpdateActuals.append("TRIP End,");
					}
				}
				cf.insertDataIntoAuditLogReport("Trip Solution :- Update Actuals", auditLogActionForUpdateActuals, userId,systemId,clientId,serverName,tripId,"");
				message = "Actuals are updated successfully";
			}
		} catch (final Exception e) {
			message = "Error while updating actuals";
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, null);
			DBConnection.releaseConnectionToDB(null, pstmt1, rs1);
		}
		return message;
	}
	public ArrayList<Object> getTripDetails(int systemId, int customerId, String startDate, String endDate, int offset,
			int userId, String sessionId, String serverName, String statusType) {
		JSONArray JsonArray = new JSONArray();
	    JSONObject JsonObject = null;
	    Connection con = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
	    PreparedStatement pstmt1 = null;
	    ResultSet rs1 = null;
	    ArrayList<String> tableNames = new ArrayList<String>();
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
	        List<String> tripSheeSetting = getTripSheetSettingData(systemId,customerId);
	        boolean isMaterialClient = (tripSheeSetting.get(7)!= null && tripSheeSetting.get(7).equals("Y"))? true:false;
	        if(isMaterialClient){
	        	pstmt = con.prepareStatement(CreateTripStatement.GET_TRIP_DETAILS_MATERIAL_CLIENT.replace("#", condition));
	        }else{
	        	pstmt = con.prepareStatement(CreateTripStatement.GET_TRIP_DETAILS.replace("#", condition));
	        }
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
	            
	            JsonObject.put("plannedDateTimeIndex",rs.getTimestamp("TRIP_START_TIME") == null ? "" : sdf.format(rs.getTimestamp("TRIP_START_TIME"))); 
	            
	            JsonObject.put("customerNameIndex",rs.getString("CUSTOMER_NAME"));
	            
	            JsonObject.put("orderIdIndex",rs.getString("ORDER_ID"));
	            
	            JsonObject.put("custRefIdIndex",rs.getString("CUSTOMER_REF_ID"));
	            
	            JsonObject.put("statusDataIndex", rs.getString("STATUS"));
	            
	            JsonObject.put("avgSpeedIndex", rs.getDouble("avgSpeed"));
            
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
	            		//tblData = tblData + "<tr><td>"+rs1.getString("DISPLAY_NAME") +":"+rs1.getString("MIN_NEGATIVE_TEMP")+","+rs1.getString("MAX_NEGATIVE_TEMP")+","+rs1.getString("MIN_POSITIVE_TEMP")+","+rs1.getString("MAX_POSITIVE_TEMP")+"</td></tr>";
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
	            		JsonObject.put("changeRouteIndex", "<button  data-toggle='modal' class='btn btn-warning' disabled style='background-color:#337ab7; border-color:#337ab7;'>Change Route</button> " );
	            		JsonObject.put("swapVehicleIndex", "<button  data-toggle='modal' class='btn btn-warning' disabled style='background-color:#337ab7; border-color:#337ab7;'>Swap Vehicle</button> " );
	            	}else{
	            		atd = rs.getString("ACTUAL_TRIP_START_TIME");
	            		JsonObject.put("actionIndex", "<button data-toggle='modal' onclick='loadTripDetails();'  class='btn btn-warning'  id='close"+rs.getInt("ID")+"'style='background-color:#da2618; border-color:#da2618;'>Close</button> " );
	            		JsonObject.put("modifyIndex", "<button data-toggle='modal'  class='btn btn-warning' style='background-color:#158e1a; border-color:#158e1a;'>Modify</button> " );
	            		JsonObject.put("changeRouteIndex", "<button  data-toggle='modal' class='btn btn-warning' style='background-color:#337ab7; border-color:#337ab7;'>Change Route</button> " );
	            		JsonObject.put("swapVehicleIndex", "<button  data-toggle='modal' class='btn btn-warning' style='background-color:#337ab7; border-color:#337ab7;'>Swap Vehicle</button> " );
	            	}
	            }else if(rs.getString("STATUS").equals("CLOSED")){
	            	JsonObject.put("actionIndex", "<button data-toggle='modal' onclick='loadTripDetails();' class='btn btn-warning'  id='close"+rs.getInt("ID")+"'style='background-color:#da2618; border-color:#da2618;'>Re open</button> " );
	            	JsonObject.put("modifyIndex", "<button data-toggle='modal'  class='btn btn-warning' style='background-color:#158e1a; border-color:#158e1a;'>View</button> " );
	            	JsonObject.put("changeRouteIndex", "<button  data-toggle='modal' class='btn btn-warning' disabled style='background-color:#337ab7; border-color:#337ab7;'>Change Route</button> " );
	            	JsonObject.put("swapVehicleIndex", "<button  data-toggle='modal' class='btn btn-warning' disabled style='background-color:#337ab7; border-color:#337ab7;'>Swap Vehicle</button> " );
	            }else if(rs.getString("STATUS").equals("UPCOMING")){
	            	JsonObject.put("actionIndex", "<button data-toggle='modal'  onclick='getTripCancellationRemarks();' class='btn btn-warning' style='background-color:#da2618; border-color:#da2618;'>Cancel</button> " );
            		JsonObject.put("modifyIndex", "<button data-toggle='modal'  class='btn btn-warning' style='background-color:#158e1a; border-color:#158e1a;'>Modify</button> " );
            		JsonObject.put("changeRouteIndex", "<button  data-toggle='modal' class='btn btn-warning' disabled style='background-color:#337ab7; border-color:#337ab7;'>Change Route</button> " );
            		JsonObject.put("swapVehicleIndex", "<button  data-toggle='modal' class='btn btn-warning' disabled style='background-color:#337ab7; border-color:#337ab7;'>Swap Vehicle</button> " );
	            } else {
	            	JsonObject.put("actionIndex", "<button onclick='cancleTrip()' class='btn btn-warning' disabled style='background-color:#da2618; border-color:#da2618;'>Cancelled</button> " );
	            	JsonObject.put("modifyIndex", "<button  data-toggle='modal'  class='btn btn-warning' style='background-color:#158e1a; border-color:#158e1a;'>View</button> " );
	            	JsonObject.put("changeRouteIndex", "<button  data-toggle='modal' class='btn btn-warning' disabled style='background-color:#337ab7; border-color:#337ab7;'>Change Route</button> " );
	            	JsonObject.put("swapVehicleIndex", "<button  data-toggle='modal' class='btn btn-warning' disabled style='background-color:#337ab7; border-color:#337ab7;'>Swap Vehicle</button> " );
	            }
	            JsonObject.put("preLoadTempIndex", rs.getString("preLoadTemp"));
	            JsonObject.put("routeIdIndex", rs.getInt("routeId"));
	            JsonObject.put("productLineIndex", rs.getString("productLine"));
	            JsonObject.put("atdIndex", atd);
	            JsonObject.put("tripCustId", rs.getString("tripCustId"));
	            JsonObject.put("sealNoIndex",rs.getString("SEAL_NO"));
	            JsonObject.put("noOfBagsIndex", rs.getInt("NO_OF_BAGS"));
	            JsonObject.put("tripTypeIndex", rs.getString("TRIP_TYPE"));
	            JsonObject.put("noOfFluidBagsIndex", rs.getInt("NO_OF_FLUID_BAGS"));
	            JsonObject.put("openingKmsIndex", doubleformat.format(rs.getFloat("OPENING_KMS")));
	            JsonObject.put("tripRemarksIndex", rs.getString("TRIP_REMARKS"));
	            JsonObject.put("cancelledRemarks", rs.getString("CANCELLED_REMARKS"));
	            JsonObject.put("category", rs.getString("CATEGORY").length() > 0 ? rs.getString("CATEGORY") : "--select category--");
	            JsonObject.put("STA", sdf.format(rs.getTimestamp("STA")));
	            if(rs.getTimestamp("ATA") != null){
	            	JsonObject.put("ATA", sdf.format(rs.getTimestamp("ATA")));
	            }else{
	            	JsonObject.put("ATA","");
	            }
	            JsonObject.put("overriddenBy", rs.getString("OVERRIDDEN_BY"));
	            if(rs.getTimestamp("OVERRIDDEN_DATETIME") != null){
	            	JsonObject.put("overriddenDate", sdf.format(rs.getTimestamp("OVERRIDDEN_DATETIME")));
	            }else{
	            	JsonObject.put("overriddenDate", "");
	            }
	            JsonObject.put("overriddenRemarks", rs.getString("OVERRIDDEN_REMARKS"));
	            if (rs.getTimestamp("ACTUAL_TRIP_END_TIME") != null){
	            	
	            }
	            JsonObject.put("actualTripEndTime", rs.getTimestamp("ACTUAL_TRIP_END_TIME") != null ? sdf.format(rs.getTimestamp("ACTUAL_TRIP_END_TIME")): "");
	            JsonObject.put("actionByDate", rs.getTimestamp("CANCELLED_DATE") != null ? rs.getString("CANCELLED_BY") + "-"+  sdf.format(rs.getTimestamp("CANCELLED_DATE")): "");
	            if(isMaterialClient){
	            	JsonObject.put("routeTemplateName", rs.getString("TEMPLATE_NAME"));
	            	JsonObject.put("materialName", rs.getString("MATERIAL_NAME"));
	            	JsonObject.put("totalTAT", cf.formattedDaysHoursMinutes(rs.getLong("TotalTAT")*60000));
	            	JsonObject.put("totalRunTime", cf.formattedDaysHoursMinutes(rs.getLong("TotalRunTime")*60000));
	            }else{
	            	JsonObject.put("routeTemplateName", "");
	            	JsonObject.put("materialName", "");
	            	JsonObject.put("totalTAT", "");
	            	JsonObject.put("totalRunTime", "");
	            }
	            
	            JsonArray.put(JsonObject);
	        }
	        tableNames.add("Select"+"##"+"dbo.TRACK_TRIP_DETAILS");
	        try{ // commented as multiple records insert in audit logs
	        	//cf.insertDataIntoAuditLogReport(sessionId, tableNames, "Trip Solution", "View Trips", userId, serverName, systemId, customerId, remarks);
	        }catch(Exception e){
	        	e.printStackTrace();
	        }
	        finlist.add(JsonArray);
	    	} catch (Exception e) {
	        e.printStackTrace();
	    	} finally {
	        DBConnection.releaseConnectionToDB(con, pstmt, rs);
	        DBConnection.releaseConnectionToDB(null, pstmt1, rs1);
	    }
	    return finlist;
	}

	public JSONArray getVehicleType(int systemId, String custId, String vehicleCatgy) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject = null;
		try {
			con = DBConnection.getConnectionToDB("AMS");
			if(vehicleCatgy.equals("ALL")){
			pstmt = con.prepareStatement(CreateTripStatement.GET_VEHICLE_TYPE);
			}else if(vehicleCatgy.equals("'Dry'")){
			pstmt = con.prepareStatement(CreateTripStatement.GET_DC_VEHICLE_TYPE);	
			}else{
			pstmt = con.prepareStatement(CreateTripStatement.GET_TCL_VEHICLE_TYPE);		
			}
			pstmt.setInt(1, Integer.parseInt(custId));
			rs = pstmt.executeQuery();
			while (rs.next()) {
				jsonObject = new JSONObject();
				jsonObject.put("vehicleType", rs.getString("VehicleType"));
				jsonArray.put(jsonObject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jsonArray;
	}
		
	
}
