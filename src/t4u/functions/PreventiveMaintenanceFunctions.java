package t4u.functions;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import org.json.JSONArray;
import org.json.JSONObject;

import t4u.beans.ReportHelper;
import t4u.cashvanmanagement.FuelMileageData;
import t4u.common.DBConnection;
import t4u.statements.PreventiveMaintenanceStatements;

public class PreventiveMaintenanceFunctions {
	SimpleDateFormat ddMMyyyyHHmmss = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
	SimpleDateFormat sdfyyyymmdd=new SimpleDateFormat("dd-MM-yyyy");
	
	SimpleDateFormat sdfyyyymmddhhmmss=new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
	SimpleDateFormat sdfmmddyyyyhhmmss=new SimpleDateFormat("MM/dd/yyyy HH:mm:ss");
	SimpleDateFormat sdfddmmyyyy = new SimpleDateFormat("dd/MM/yyyy");
	SimpleDateFormat sdfmmddyyyy = new SimpleDateFormat("MM/dd/yyyy");
	SimpleDateFormat sfddMMYYYY = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
	
	
	
	
	
	
	
	
	CommonFunctions cf = new CommonFunctions();

/***********************************************FUNCTIONS FOR TASK MASTER***************************************************************************************************************************************************************************************************************************************************************************/	

	public String insertTaskMasterInformation(String taskName, String type, String defaultDays, String defaultDistance, String status, int customerId, int systemId, int thersholdDays, int thersholdDistance,String autoUpdate,int detentionTime) {
	    Connection con = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
	    String message = "";

	    try {
	        con = DBConnection.getConnectionToDB("AMS");
	        pstmt = con.prepareStatement(PreventiveMaintenanceStatements.CHECK_FOR_EXISTING_TASK);
	        pstmt.setString(1, taskName.toUpperCase());
	        pstmt.setInt(2, systemId);
	        pstmt.setInt(3, customerId);
	        rs = pstmt.executeQuery();
	        if (rs.next()) {
	            message = "Task Name Already Exist";
	        } else {
	            int maxMaintenanceId = 0;
	            pstmt = con.prepareStatement(PreventiveMaintenanceStatements.GET_MAX_TASKS);
	            pstmt.setInt(1, systemId);
	            pstmt.setInt(2, customerId);
	            rs = pstmt.executeQuery();
	            if (rs.next()) {
	                maxMaintenanceId = rs.getInt(1);
	            }
	            maxMaintenanceId++;
	            pstmt = con.prepareStatement(PreventiveMaintenanceStatements.INSERT_TASK_MASTER_DETAILS);
	            pstmt.setInt(1, maxMaintenanceId);
	            pstmt.setString(2, taskName.toUpperCase());
	            pstmt.setString(3, type);
	            pstmt.setString(4, defaultDays);
	            pstmt.setString(5, defaultDistance);
	            pstmt.setString(6, status);
	            pstmt.setInt(7, thersholdDays);
	            pstmt.setInt(8, thersholdDistance);
	            pstmt.setString(9, autoUpdate);
	            pstmt.setInt(10, detentionTime);
	            pstmt.setInt(11, customerId);
	            pstmt.setInt(12, systemId);
	            int inserted = pstmt.executeUpdate();
	            if (inserted > 0) {
	                message = "Task Name " + taskName.toUpperCase() + " Saved Successfully";
	            }
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	        DBConnection.releaseConnectionToDB(con, pstmt, rs);
	    }
	    return message;
	}

	public String modifyTaskMasterInformation(int id, String taskName, String type, String defaultDays, String defaultDistance, String status, int customerId, int systemId, int thersholdDays, int thersholdDistance,String autoUpdate,int detentionTime) {
	    Connection con = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
	    String message = "";
	    try {
	        con = DBConnection.getConnectionToDB("AMS");
	        pstmt = con.prepareStatement(PreventiveMaintenanceStatements.UPDATE_TASK_MASTER_DETAILS);
	        pstmt.setString(1, taskName.toUpperCase());
	        pstmt.setString(2, type);
	        pstmt.setString(3, defaultDays);
	        pstmt.setString(4, defaultDistance);
	        pstmt.setString(5, status);
	        pstmt.setInt(6, thersholdDays);
	        pstmt.setInt(7, thersholdDistance);
	        pstmt.setString(8, autoUpdate);
	        pstmt.setInt(9, detentionTime);
	        pstmt.setInt(10, systemId);
	        pstmt.setInt(11, customerId);
	        pstmt.setInt(12, id);
	        int updated = pstmt.executeUpdate();
	        if (updated > 0) {
	            message = "Task Name " + taskName.toUpperCase() + " Updated Successfully";
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	        message = "Unable To Update Task Details";
	    } finally {
	        DBConnection.releaseConnectionToDB(con, pstmt, rs);
	    }
	    return message;
	}

	public ArrayList < Object > getTaskMasterDetails(int clientId, int systemid, String language) {

	    JSONArray JsonArray = new JSONArray();
	    JSONObject JsonObject = null;

	    Connection con = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
	    ArrayList < ReportHelper > reportsList = new ArrayList < ReportHelper > ();
	    ArrayList < String > headersList = new ArrayList < String > ();
	    ReportHelper finalreporthelper = new ReportHelper();
	    ArrayList < Object > finlist = new ArrayList < Object > ();

	    try {

	        headersList.add(cf.getLabelFromDB("SLNO", language));
	        headersList.add(cf.getLabelFromDB("Service_Name", language));
	        headersList.add(cf.getLabelFromDB("Service_Type", language));
	        headersList.add(cf.getLabelFromDB("Days_Of_Service", language));
	        headersList.add(cf.getLabelFromDB("KMS_Of_Service", language));
	        headersList.add(cf.getLabelFromDB("Status", language));
	        headersList.add(cf.getLabelFromDB("Auto_Update", language));
	        headersList.add(cf.getLabelFromDB("Detention_Time", language));
	        
	        int count = 0;
	        con = DBConnection.getConnectionToDB("AMS");
	        pstmt = con.prepareStatement(PreventiveMaintenanceStatements.GET_TASK_MASTER_DETAILS);
	        pstmt.setInt(1, systemid);
	        pstmt.setInt(2, clientId);

	        rs = pstmt.executeQuery();
	        while (rs.next()) {
	            JsonObject = new JSONObject();
	            ArrayList < Object > informationList = new ArrayList < Object > ();
	            ReportHelper reporthelper = new ReportHelper();
	            count++;

	            informationList.add(count);
	            JsonObject.put("slnoIndex", count);

	            JsonObject.put("taskNameDataIndex", rs.getString("Maintenance"));
	            informationList.add(rs.getString("Maintenance"));

	            JsonObject.put("typeDataIndex", rs.getString("TYPE"));
	            informationList.add(rs.getString("TYPE"));

	            JsonObject.put("defaultDaysIndex", rs.getInt("DEFAULT_DAYS"));
	            informationList.add(rs.getInt("DEFAULT_DAYS"));

	            JsonObject.put("defaultDistanceDataIndex", rs.getInt("DEFAULT_DISTANCE"));
	            informationList.add(rs.getInt("DEFAULT_DISTANCE"));

	            JsonObject.put("statusDataIndex", rs.getString("STATUS"));
	            informationList.add(rs.getString("STATUS"));

	            JsonObject.put("id", rs.getInt("MaintenanceId"));
	            
	            JsonObject.put("autoUpdateIndex", rs.getString("AUTO_UPDATE"));
	            informationList.add(rs.getString("AUTO_UPDATE"));
	            
	            JsonObject.put("detentionTimeIndex", rs.getString("DETENTION_TIME"));
	            informationList.add(rs.getString("DETENTION_TIME"));
	            
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

	/********************************************************FUNCTIONS FOR MANAGE TASKS**************************************************************************************************************************************************************************/

	public JSONArray getAssetNumberDetails(int systemId, int customerId, int userId,String alert) {
	    JSONArray JsonArray = null;
	    JSONObject JsonObject = null;

	    Connection con = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
        String a="";
	    int count = 0;
	    int alertType = 0;
	    try {
	        JsonArray = new JSONArray();
	        if (!alert.equals(null)) {
				alertType = Integer.parseInt(alert);
			}
	        con = DBConnection.getConnectionToDB("AMS");
            if(alertType!=0){
		        pstmt = con.prepareStatement(PreventiveMaintenanceStatements.GET_ASSET_NUMBER_FOR_ALERTTYPE);
		        pstmt.setInt(1, customerId);
		        pstmt.setInt(2, systemId);
		        pstmt.setInt(3, userId);
		        pstmt.setInt(4, alertType);
            }else {
            	pstmt = con.prepareStatement(PreventiveMaintenanceStatements.GET_ASSET_NUMBER_FOR_ALL);
		        pstmt.setInt(1, customerId);
		        pstmt.setInt(2, systemId);
		        pstmt.setInt(3, userId);
            }
	        rs = pstmt.executeQuery();
	        while (rs.next()) {
	            count++;

	            JsonObject = new JSONObject();

	            JsonObject.put("slnoIndex", count);
	            JsonObject.put("assetModel", rs.getString("ModelName"));
	            JsonObject.put("assetnumber", rs.getString("REGISTRATION_NUMBER"));

	            JsonArray.put(JsonObject);
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	        DBConnection.releaseConnectionToDB(con, pstmt, rs);
	    }
	    return JsonArray;
	}


	public String insertManageTaskDetails(String taskName, String distance, String days, String threshouldDistance, String threshouldDays, String lastServiceDate, int systemId, int customerId, String assetNumber, int userId , int offset) {
	    Connection con = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
	    String message = "";
	  //  SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
	    try {
	        con = DBConnection.getConnectionToDB("AMS");
	        pstmt = con.prepareStatement(PreventiveMaintenanceStatements.CHECK_EXISTING_TASK_FOR_MANAGE_DETAILS);
	        pstmt.setString(1, taskName.toUpperCase());
	        pstmt.setInt(2, systemId);
	        pstmt.setInt(3, customerId);
	        pstmt.setString(4, assetNumber);
	        rs = pstmt.executeQuery();
	        if (rs.next()) {
	            message = "Task Name Already Exist";
	        } else {
	        	
	        	//String curdate =  sdf.format(lastServiceDate);
				pstmt = con.prepareStatement(PreventiveMaintenanceStatements.GET_UTC_FOR_LAST_SERVICE_DATE);
				pstmt.setInt(1, offset);
				pstmt.setString(2, lastServiceDate);
				rs = pstmt.executeQuery();
				if (rs.next()) {
					lastServiceDate = rs.getString("UTCDATETIME");
				}
	            pstmt = con.prepareStatement(PreventiveMaintenanceStatements.GET_MAX_TASKS1);
	            pstmt.setInt(1, systemId);
	            pstmt.setInt(2, customerId);
	            pstmt.setString(3, assetNumber);
	            rs = pstmt.executeQuery();
	            pstmt = con.prepareStatement(PreventiveMaintenanceStatements.INSERT_MANAGE_TASK_DETAILS);
	            pstmt.setString(1, taskName.toUpperCase());
	            pstmt.setString(2, distance);
	            pstmt.setString(3, days);
	            pstmt.setString(4, threshouldDistance);
	            pstmt.setString(5, threshouldDays);
	            pstmt.setString(6, lastServiceDate);
	            pstmt.setInt(7, userId);
	            pstmt.setInt(8, systemId);
	            pstmt.setInt(9, customerId);
	            pstmt.setString(10, assetNumber);
	            int inserted = pstmt.executeUpdate();
	            if (inserted > 0) {
	                message = "Task Name Saved Successfully";
	            }
	        }

	    } catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	        DBConnection.releaseConnectionToDB(con, pstmt, rs);
	    }
	    return message;
	}


	public String modifyManageTaskDetails(int id, String assetNumber, String taskName, String distance, String days, String threshouldDistance, String threshouldDays, String lastServiceDate, int systemId, int customerId, int userId) {
	    Connection con = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
	    String message = "";
	    try {
	        con = DBConnection.getConnectionToDB("AMS");
	        pstmt = con.prepareStatement(PreventiveMaintenanceStatements.MODIFY_MANAGE_TASK_DETAILS_NEW);
	        pstmt.setString(1, distance);
	        pstmt.setString(2, days);
	        pstmt.setString(3, threshouldDistance);
	        pstmt.setString(4, threshouldDays);
	       // pstmt.setString(5, lastServiceDate);
	        pstmt.setInt(5, userId);
	        pstmt.setInt(6, systemId);
	        pstmt.setString(7, assetNumber);
	        pstmt.setInt(8, customerId);
	        pstmt.setInt(9, id);
	        int updated = pstmt.executeUpdate();
	        if (updated > 0) {
	            message = "Task Name Updated Successfully";
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	        message = "Unable To Update Task Details";
	    } finally {
	        DBConnection.releaseConnectionToDB(con, pstmt, rs);
	    }
	    return message;
	}


	public JSONArray getTaskNameList(int systemId, int customerid,String taskId,String assetNumber) {
	    JSONArray jsonArray = null;
	    JSONObject jsonObject = null;
	    Connection con = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
	    try {
	        jsonArray = new JSONArray();
	        jsonObject = new JSONObject();
	        con = DBConnection.getConnectionToDB("AMS");
	        pstmt = con.prepareStatement(PreventiveMaintenanceStatements.GET_TASK_NAME_LIST);
	        pstmt.setInt(1, systemId);
	        pstmt.setInt(2, customerid);
	        pstmt.setInt(3, systemId);
	        pstmt.setInt(4, customerid);
	        pstmt.setString(5, assetNumber);
	        rs = pstmt.executeQuery();
	       while (rs.next()) {
	            jsonObject = new JSONObject();
	           jsonObject.put("TaskId", rs.getString("TaskId"));
	            jsonObject.put("TaskName", rs.getString("TaskName"));
	            jsonObject.put("Distance", rs.getString("DEFAULT_DISTANCE"));
	            jsonObject.put("Days", rs.getString("DEFAULT_DAYS"));
	            jsonObject.put("ThreshouldDistance", rs.getString("THRESHOLD_DISTANCE"));
	            jsonObject.put("ThreshouldDays", rs.getString("THRESHOLD_DAYS"));
	            jsonArray.put(jsonObject);
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	        DBConnection.releaseConnectionToDB(con, pstmt, rs);
	    }
	    return jsonArray;
	}

	public ArrayList < Object > getManageTasksDetails(int clientId, int systemid, String assetNumber, String language ,int offset) {
	    JSONArray JsonArray = new JSONArray();
	    JSONObject JsonObject = null;

	    Connection con = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
	    ArrayList < ReportHelper > reportsList = new ArrayList < ReportHelper > ();
	    ArrayList < String > headersList = new ArrayList < String > ();
	    ReportHelper finalreporthelper = new ReportHelper();
	    ArrayList < Object > finlist = new ArrayList < Object > ();

	    try {

	        headersList.add(cf.getLabelFromDB("SLNO", language));
	        headersList.add(cf.getLabelFromDB("Asset_Number", language));
	        headersList.add(cf.getLabelFromDB("Service_Name", language));
	        headersList.add(cf.getLabelFromDB("Mileage_Of_Service", language));
	        headersList.add(cf.getLabelFromDB("Days_Of_Service", language));
	        headersList.add(cf.getLabelFromDB("Renewal_Days_Of_Service", language));
	        headersList.add(cf.getLabelFromDB("Renewal_Mileage_Of_Service", language));

	        int count = 0;
	        con = DBConnection.getConnectionToDB("AMS");
	        pstmt = con.prepareStatement(PreventiveMaintenanceStatements.GET_MANAGE_TASK_DETAILS);
	        pstmt.setInt(1, offset);
	        pstmt.setInt(2, systemid);
	        pstmt.setInt(3, clientId);
	        pstmt.setString(4, assetNumber);
	        rs = pstmt.executeQuery();
	        while (rs.next()) {
	            JsonObject = new JSONObject();
	            ArrayList < Object > informationList = new ArrayList < Object > ();
	            ReportHelper reporthelper = new ReportHelper();
	            count++;

	            informationList.add(count);
	            JsonObject.put("slnoIndex", count);

	            JsonObject.put("assetDataIndex", rs.getString("ASSET_NUMBER"));
	            informationList.add(rs.getString("ASSET_NUMBER"));

	            JsonObject.put("taskNameIndex", rs.getString("TASK_NAME"));
	            informationList.add(rs.getString("TASK_NAME"));

	            JsonObject.put("distanceDataIndex", rs.getInt("DISTANCE"));
	            informationList.add(rs.getInt("DISTANCE"));

	            JsonObject.put("daysDataIndex", rs.getInt("DAYS"));
	            informationList.add(rs.getInt("DAYS"));

	            JsonObject.put("threshouldDistanceDataIndex", rs.getString("THRESHOULD_DISTANCE"));
	            informationList.add(rs.getString("THRESHOULD_DISTANCE"));

	            JsonObject.put("threshouldDaysDataIndex", rs.getString("THRESHOULD_DAYS"));
	            informationList.add(rs.getString("THRESHOULD_DAYS"));
	             
	            JsonObject.put("lastServiceDateDataIndex", sdfyyyymmdd.format(rs.getTimestamp("LAST_SERVICE_DATE")));
	            
	            JsonObject.put("taskIdDataIndex", rs.getString("TASK_ID"));

	            JsonObject.put("id", rs.getInt("TASK_ID"));
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

	public JSONArray getAssetNumberAndModelToCopyDetails(int customerId, int systemId, int userId, String assetNumber) {
	    JSONArray JsonArray = null;
	    JSONObject JsonObject = null;

	    Connection con = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;

	    int count = 0;


	    try {
	        JsonArray = new JSONArray();

	        con = DBConnection.getConnectionToDB("AMS");

	        pstmt = con.prepareStatement(PreventiveMaintenanceStatements.GET_ASSET_NUMBER_AND_MODEL_TO_COPY_DETAILS);
	        pstmt.setInt(1, customerId);
	        pstmt.setInt(2, systemId);
	        pstmt.setInt(3, userId);
	        pstmt.setString(4, assetNumber);


	        rs = pstmt.executeQuery();
	        while (rs.next()) {
	            count++;

	            JsonObject = new JSONObject();

	            JsonObject.put("slnoIndex", count);
	            JsonObject.put("assetModelIndex", rs.getString("ModelName"));
	            JsonObject.put("assetNumberDataIndex", rs.getString("REGISTRATION_NUMBER"));

	            JsonArray.put(JsonObject);
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	        DBConnection.releaseConnectionToDB(con, pstmt, rs);
	    }
	    return JsonArray;
	}


	public String saveCopyDetails(int customerId, int systemId, int userId, JSONArray js, JSONArray manageGridData,int offset) {
	    List < FuelMileageData > list = new ArrayList < FuelMileageData > ();
	    Connection con = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
	    String message = "";
	    
	    try {
	        con = DBConnection.getConnectionToDB("AMS");
	        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
			for (int j = 0; j < manageGridData.length(); j++) {
				JSONObject obj1 = manageGridData.getJSONObject(j);
				String taskId = obj1.getString("taskIdDataIndex");
				String distance = obj1.getString("distanceDataIndex");
				String days = obj1.getString("daysDataIndex");
				String threshouldDistance = obj1.getString("threshouldDistanceDataIndex");
				String threshouldDays = obj1.getString("threshouldDaysDataIndex");
				String taskName = obj1.getString("taskNameIndex");

				for (int i = 0; i < js.length(); i++) {
					boolean checkFlag = false;
					JSONObject obj = js.getJSONObject(i);

					String assetNumber = obj.getString("assetNumberDataIndex");
					pstmt = con.prepareStatement(PreventiveMaintenanceStatements.CHECK_EXISTING_TASK_FOR_MANAGE_DETAILS);
					pstmt.setString(1, taskId);
					pstmt.setInt(2, systemId);
					pstmt.setInt(3, customerId);
					pstmt.setString(4, assetNumber);
					rs = pstmt.executeQuery();
					if (rs.next()) {
						checkFlag = true;
						message = "Task Name " + taskName.toUpperCase()+ " Already Exist";
					}
					pstmt = null;
					rs = null;
					if (!checkFlag) {
						Date date = new Date();
						String curdate =  sdf.format(date);
						pstmt = con.prepareStatement(PreventiveMaintenanceStatements.GET_UTC_FOR_LAST_SERVICE_DATE);
						pstmt.setInt(1, offset);
						pstmt.setString(2, curdate);
						rs = pstmt.executeQuery();
						if (rs.next()) {
							curdate = rs.getString("UTCDATETIME");
						}						
						
						pstmt = con.prepareStatement(PreventiveMaintenanceStatements.INSERT_MANAGE_COPY_DETAILS);
						pstmt.setString(1, taskId);
						pstmt.setString(2, distance);
						pstmt.setString(3, days);
						pstmt.setString(4, threshouldDistance);
						pstmt.setString(5, threshouldDays);
						pstmt.setString(6, curdate);
						pstmt.setInt(7, userId);
						pstmt.setInt(8, systemId);
						pstmt.setInt(9, customerId);
						pstmt.setString(10, assetNumber);
						int inserted = pstmt.executeUpdate();
						if (inserted > 0) {
							message = "Task Copied Successfully Please Refer Respective Asset Number For Details";
						}
					}
				}
			}	              
	    } catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	        DBConnection.releaseConnectionToDB(con, pstmt, rs);
	    }
	    return message;
	}


	/*********************************************************FUNCTIONS FOR EXPIRING SOON****************************************************************************************************************************************************************************************************************/

	public String modifyExpiringSoonDetails(String assetNumber,String lastServiceDate,int systemId, int customerId,int userId,int taskId,String Remarks,int typeOfAlert) {
	    Connection con = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
	    String message = "";
	   
	    try {
	    	con = DBConnection.getConnectionToDB("AMS");
	        pstmt = con.prepareStatement(PreventiveMaintenanceStatements.MODIFY_EXPIRING_SOON_DETAILS);
	        pstmt.setString(1, lastServiceDate);
	        pstmt.setInt(2, userId);
	        pstmt.setInt(3, systemId);
	        pstmt.setString(4, assetNumber);
	        pstmt.setInt(5, customerId);
	        pstmt.setInt(6, taskId);
	        int update = pstmt.executeUpdate();
	        if (update > 0) {
	        		       
	        	pstmt = con.prepareStatement("insert into FMS.dbo.PREVENTIVE_EVENTS_HISTORY (ID,ASSET_NUMBER,TASK_ID,ALERT_TYPE,EVENT_DATE,EVENT_PARAM,LAST_SERVICE_DATE,SYSTEM_ID,CUSTOMER_ID,CREATED_TIME,DUE_DAYS,DUE_MILEAGE,REMARKS,UPDATED_TIME,UPDATED_BY,POSTPONE_BY,POSTPONE_DATE,POSTPONE_REMARKS) select ID,ASSET_NUMBER,TASK_ID,ALERT_TYPE,EVENT_DATE,EVENT_PARAM,LAST_SERVICE_DATE,SYSTEM_ID,CUSTOMER_ID,CREATED_TIME,DUE_DAYS,DUE_MILEAGE,?,getDate(),?,POSTPONE_BY,POSTPONE_DATE,POSTPONE_REMARKS from FMS.dbo.PREVENTIVE_EVENTS where ASSET_NUMBER =? and TASK_ID = ? and ALERT_TYPE = ? and SYSTEM_ID=? and CUSTOMER_ID=?");
 	            pstmt.setString(1, Remarks);
		        pstmt.setInt(2, userId);
		        pstmt.setString(3, assetNumber);
		        pstmt.setInt(4, taskId);
		        pstmt.setInt(5, typeOfAlert);
		        pstmt.setInt(6, systemId);
		        pstmt.setInt(7, customerId);
		        int inserted = pstmt.executeUpdate();
		         if (inserted > 0) {
	       	     pstmt = con.prepareStatement("delete from FMS.dbo.PREVENTIVE_EVENTS where ASSET_NUMBER=? and TASK_ID=? and ALERT_TYPE=? and SYSTEM_ID=? and CUSTOMER_ID=?");
					pstmt.setString(1, assetNumber);
					pstmt.setInt(2, taskId);
					pstmt.setInt(3, typeOfAlert);
					pstmt.setInt(4, systemId);
					pstmt.setInt(5, customerId);
					pstmt.executeUpdate();
			   } 
	        } 
	        message="Updated Successfully";
	    } catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	        DBConnection.releaseConnectionToDB(con, pstmt, rs);
	    }
	    return message;
	}
	
	
	

	public ArrayList < Object > getExpiringSoonDetails(int clientId, int systemid, String language,String assetNumber, int offset) {

	    JSONArray JsonArray = new JSONArray();
	    JSONObject JsonObject = null;

	    Connection con = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
	    ArrayList < ReportHelper > reportsList = new ArrayList < ReportHelper > ();
	    ArrayList < String > headersList = new ArrayList < String > ();
	    ReportHelper finalreporthelper = new ReportHelper();
	    ArrayList < Object > finlist = new ArrayList < Object > ();

	    try {

	        headersList.add(cf.getLabelFromDB("SLNO", language));
	        headersList.add(cf.getLabelFromDB("Asset_Number", language));
	        headersList.add(cf.getLabelFromDB("Service_Name", language));
	        headersList.add(cf.getLabelFromDB("Mileage_Of_Service", language));
	        headersList.add(cf.getLabelFromDB("Last_Service_Date", language));
	      
	        int count = 0;
	        con = DBConnection.getConnectionToDB("AMS");
	        pstmt = con.prepareStatement(PreventiveMaintenanceStatements.GET_EXPIRING_SOON_DETAILS_NEW);
	        pstmt.setInt(1, offset);
	        pstmt.setInt(2, offset);
	        pstmt.setInt(3, systemid);
	        pstmt.setInt(4, clientId);
	        pstmt.setString(5, assetNumber);

	        rs = pstmt.executeQuery();
	        while (rs.next()) {
	            JsonObject = new JSONObject();
	            ArrayList < Object > informationList = new ArrayList < Object > ();
	            ReportHelper reporthelper = new ReportHelper();
	            count++;

	            informationList.add(count);
	            JsonObject.put("slnoIndex", count);

	            JsonObject.put("assetDataIndex", rs.getString("ASSET_NUMBER"));
	            informationList.add(rs.getString("ASSET_NUMBER"));

	            JsonObject.put("taskNameIndex", rs.getString("TASK_NAME"));
	            informationList.add(rs.getString("TASK_NAME"));

	            JsonObject.put("lastServiceDateDataIndex", sdfyyyymmdd.format(rs.getTimestamp("LAST_SERVICE_DATE")));
		        String serviceDate = "";
		        if(rs.getString("SERVICE_DATE") !=null && !rs.getString("SERVICE_DATE").equals("")){
		        	serviceDate = sdfyyyymmdd.format(rs.getTimestamp("SERVICE_DATE"));
		        }
	            JsonObject.put("ServiceDateDataIndex", serviceDate);
	            
	            JsonObject.put("eventParamDataIndex", rs.getString("EVENT_PARAM"));
	            informationList.add(rs.getString("EVENT_PARAM"));
	            
                JsonObject.put("taskIdDataIndex", rs.getString("TASK_ID"));
                
                JsonObject.put("eventDateDataIndex", sdfyyyymmdd.format(rs.getTimestamp("EVENT_DATE")));
                
                JsonObject.put("dueDaysDataIndex", rs.getInt("DUE_DAYS"));
	            informationList.add(rs.getInt("DUE_DAYS"));
	            float duemileage = rs.getFloat("DUE_MILEAGE");
	            JsonObject.put("dueMileageDataIndex",((int)Math.round(duemileage)));
	            informationList.add((int)Math.round(duemileage));
                
	             
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
	
	
	
	public JSONArray getTaskNameListforexpiringSoonDetails(int systemId, int customerid,String taskId,String assetNumber) {
		JSONArray jsonArray = null;
	    JSONObject jsonObject = null;
	    Connection con = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
	    try {
	        jsonArray = new JSONArray();
	        jsonObject = new JSONObject();
	        con = DBConnection.getConnectionToDB("AMS");
	        pstmt = con.prepareStatement(PreventiveMaintenanceStatements.GET_TASK_NAME_LIST_FOR_EXPIRING_SOON);
	        pstmt.setString(1, assetNumber);
	        rs = pstmt.executeQuery();
	       while (rs.next()) {
	            jsonObject = new JSONObject();
	           jsonObject.put("TaskId", rs.getString("TASK_ID"));
	           jsonObject.put("TaskName", rs.getString("Maintenance"));
	           jsonObject.put("LastServiceDate", sdfyyyymmdd.format(rs.getTimestamp("LAST_SERVICE_DATE")));
	           jsonArray.put(jsonObject);
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	        DBConnection.releaseConnectionToDB(con, pstmt, rs);
	    }
	    return jsonArray;
	}
	
	
	

	/*********************************************************FUNCTIONS FOR ALREADY EXPIRED*******************************************************************************************************************************************************************************************************************************************************/

	public String modifyAlreadyExpiredDetails(String assetNumber,String lastServiceDate,int systemId, int customerId,int userId,int taskId,String Remarks) {
	    Connection con = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
	    String message = "";
	    int alertType=1;
	    	 try {
	 	    	con = DBConnection.getConnectionToDB("AMS");
	 	    	
	 	        pstmt = con.prepareStatement(PreventiveMaintenanceStatements.MODIFY_EXPIRING_SOON_DETAILS);
	 	        pstmt.setString(1, lastServiceDate);
	 	        pstmt.setInt(2, userId);
	 	        pstmt.setInt(3, systemId);
	 	        pstmt.setString(4, assetNumber);
	 	        pstmt.setInt(5, customerId);
	 	        pstmt.setInt(6, taskId);
	 	        int update = pstmt.executeUpdate();
	 	        
	 	        if (update > 0) {
	 	        	pstmt = con.prepareStatement("update FMS.dbo.PREVENTIVE_EVENTS set REMARKS=? where ASSET_NUMBER=? and TASK_ID=? and ALERT_TYPE=? and SYSTEM_ID=? and CUSTOMER_ID=?");
	 	            pstmt.setString(1,Remarks);
			        pstmt.setString(2, assetNumber);
				    pstmt.setInt(3, taskId);
				    pstmt.setInt(4, alertType);
				    pstmt.setInt(5, systemId);
				    pstmt.setInt(6, customerId);
				    int updateRemarks = pstmt.executeUpdate();
	 	        	
				    if (updateRemarks > 0) {
				    	message="Updated Successfully"; 
			            pstmt = con.prepareStatement(PreventiveMaintenanceStatements.INSERT_INTO_HISTORY_FOR_ALREADY_EXPIRED);	    	    
				        pstmt.setString(1, assetNumber);
				        pstmt.setInt(2, taskId);
				        pstmt.setInt(3, alertType);
				        pstmt.setInt(4, systemId);
				        pstmt.setInt(5, customerId);
				        int inserted = pstmt.executeUpdate();
	 	        	
				     if (inserted > 0) {
					     pstmt = con.prepareStatement("update FMS.dbo.PREVENTIVE_EVENTS_HISTORY set UPDATED_TIME=getDate(),UPDATED_BY=? where ASSET_NUMBER=? and TASK_ID=? and ALERT_TYPE=? and SYSTEM_ID=? and CUSTOMER_ID=?");
						 pstmt.setInt(1,userId);
					     pstmt.setString(2, assetNumber);
					     pstmt.setInt(3, taskId);
						 pstmt.setInt(4, alertType);
						 pstmt.setInt(5, systemId);
						 pstmt.setInt(6, customerId);
						 int inserted1 = pstmt.executeUpdate();
	 	        	
	 	        	if(inserted1 > 0)
							 {
					       	pstmt = con.prepareStatement("delete from FMS.dbo.PREVENTIVE_EVENTS where ASSET_NUMBER=? and TASK_ID=? and ALERT_TYPE=1 and SYSTEM_ID=? and CUSTOMER_ID=?");
							pstmt.setString(1, assetNumber);
							pstmt.setInt(2, taskId);
							pstmt.setInt(3, systemId);
							pstmt.setInt(4, customerId);
							pstmt.executeUpdate();
						   } 
				        } 
				     }
				        }
	 	    } catch (Exception e) {
	 	        e.printStackTrace();
	 	    } finally {
	 	        DBConnection.releaseConnectionToDB(con, pstmt, rs);
	 	    }
	 	    return message;
	 	}
	public ArrayList < Object > getAlreadyExpiredDetails(int clientId, int systemid, String language,String assetNumber, int offset) {

	    JSONArray JsonArray = new JSONArray();
	    JSONObject JsonObject = null;

	    Connection con = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
	    ArrayList < ReportHelper > reportsList = new ArrayList < ReportHelper > ();
	    ArrayList < String > headersList = new ArrayList < String > ();
	    ReportHelper finalreporthelper = new ReportHelper();
	    ArrayList < Object > finlist = new ArrayList < Object > ();

	    try {

	        headersList.add(cf.getLabelFromDB("SLNO", language));
	        headersList.add(cf.getLabelFromDB("Asset_Number", language));
	        headersList.add(cf.getLabelFromDB("Service_Name", language));
	        headersList.add(cf.getLabelFromDB("Last_Service_Date", language));
	      
	        int count = 0;
	        con = DBConnection.getConnectionToDB("AMS");
	        pstmt = con.prepareStatement(PreventiveMaintenanceStatements.GET_ALREADY_EXPIRED_DETAILS_NEW);
	        pstmt.setInt(1, offset);
	        pstmt.setInt(2, offset);
	        pstmt.setInt(3, systemid);
	        pstmt.setInt(4, clientId);
	        pstmt.setString(5, assetNumber);

	        rs = pstmt.executeQuery();
	        while (rs.next()) {
	            JsonObject = new JSONObject();
	            ArrayList < Object > informationList = new ArrayList < Object > ();
	            ReportHelper reporthelper = new ReportHelper();
	            count++;

	            informationList.add(count);
	            JsonObject.put("slnoIndex", count);

	            JsonObject.put("assetDataIndex", rs.getString("ASSET_NUMBER"));
	            informationList.add(rs.getString("ASSET_NUMBER"));

	            JsonObject.put("taskNameIndex", rs.getString("TASK_NAME"));
	            informationList.add(rs.getString("TASK_NAME"));

	            JsonObject.put("daysRemainingDataIndex", sdfyyyymmdd.format(rs.getTimestamp("EVENT_DATE")));
	                 
	            JsonObject.put("lastServiceDateDataIndex", sdfyyyymmdd.format(rs.getTimestamp("LAST_SERVICE_DATE")));
		        
	            String serviceDate = "";
		        if(rs.getString("SERVICE_DATE") !=null && !rs.getString("SERVICE_DATE").equals("")){
		        	serviceDate = sdfyyyymmdd.format(rs.getTimestamp("SERVICE_DATE"));
		        }
	            JsonObject.put("ServiceDateDataIndex", serviceDate);
	            
	            JsonObject.put("taskIdDataIndex", rs.getString("TASK_ID"));
	            
	            JsonObject.put("eventParamDataIndex", rs.getString("EVENT_PARAM"));
	            informationList.add(rs.getString("EVENT_PARAM"));
	             
	            JsonObject.put("dueDaysDataIndex", rs.getString("DUE_DAYS"));
	            informationList.add(rs.getString("DUE_DAYS"));
	            
	            JsonObject.put("dueMileageDataIndex", rs.getString("DUE_MILEAGE"));
	            informationList.add(rs.getString("DUE_MILEAGE"));
	            
	            JsonObject.put("reasonDataIndex", rs.getString("POSTPONE_REMARKS"));
	            informationList.add(rs.getString("POSTPONE_REMARKS"));

	            
	            if (rs.getString("POSTPONE_DATE") == null || rs.getString("POSTPONE_DATE").equals("") || rs.getString("POSTPONE_DATE").contains("1900")) {
                    JsonObject.put("postponeDateDataIndex", "");

                } else {
                    JsonObject.put("postponeDateDataIndex", sdfyyyymmdd.format(rs.getTimestamp("POSTPONE_DATE")));
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
	
	
	/*******************************************************FUNCTIONS FOR TASKS HISTORY**********************************************************************************************************************************************************************************************************************************************/

	public ArrayList < Object > getTasksHistoryDetails(int clientId, int systemid, String language,String assetNumber, int offset) {

	    JSONArray JsonArray = new JSONArray();
	    JSONObject JsonObject = null;

	    Connection con = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
	    ArrayList < ReportHelper > reportsList = new ArrayList < ReportHelper > ();
	    ArrayList < String > headersList = new ArrayList < String > ();
	    ReportHelper finalreporthelper = new ReportHelper();
	    ArrayList < Object > finlist = new ArrayList < Object > ();
	    String alertType = "";
	    try {

	        headersList.add(cf.getLabelFromDB("SLNO", language));
	        headersList.add(cf.getLabelFromDB("Asset_Number", language));
	        headersList.add(cf.getLabelFromDB("Service_Name", language));
	        headersList.add(cf.getLabelFromDB("Last_Service_Date", language));
	      
	        int count = 0;
	        con = DBConnection.getConnectionToDB("AMS");
	        pstmt = con.prepareStatement(PreventiveMaintenanceStatements.GET_TASKS_HISTORY_DETAILS_NEW);
	        pstmt.setInt(1, offset);
	        pstmt.setInt(2, offset);
	        pstmt.setInt(3, systemid);
	        pstmt.setInt(4, clientId);
	        pstmt.setString(5, assetNumber);

	        rs = pstmt.executeQuery();
	        while (rs.next()) {
	            JsonObject = new JSONObject();
	            ArrayList < Object > informationList = new ArrayList < Object > ();
	            ReportHelper reporthelper = new ReportHelper();
	            count++;

	            informationList.add(count);
	            JsonObject.put("slnoIndex", count);

	            JsonObject.put("assetDataIndex", rs.getString("ASSET_NUMBER"));
	            informationList.add(rs.getString("ASSET_NUMBER"));

	            JsonObject.put("taskNameIndex", rs.getString("TASK_NAME"));
	            informationList.add(rs.getString("TASK_NAME"));

	            JsonObject.put("lastServiceDateDataIndex", sdfyyyymmdd.format(rs.getTimestamp("LAST_SERVICE_DATE")));
		        
	            String serviceDate = "";
		        if(rs.getString("SERVICE_DATE") !=null && !rs.getString("SERVICE_DATE").equals("")){
		        	serviceDate = sdfyyyymmdd.format(rs.getTimestamp("SERVICE_DATE"));
		        }
	            JsonObject.put("ServiceDateDataIndex", serviceDate);
	            
	            JsonObject.put("eventParamDataIndex", rs.getString("EVENT_PARAM"));
	            informationList.add(rs.getString("EVENT_PARAM"));
	           
	            if(rs.getInt("ALERT_TYPE") == 1)
	            {
	            	alertType = "Service Over Due";
	            }
	            else if(rs.getInt("ALERT_TYPE") == 2)
	            {
	            	alertType = "Due For Renewal";
	            } 
	            else {
	            	alertType = "";
	            }
	            JsonObject.put("alertTypeDataIndex", alertType);
	            informationList.add(alertType);
	            
	            JsonObject.put("remarksDataIndex", rs.getString("REMARKS"));
	            informationList.add(rs.getString("REMARKS"));
	            
	             
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
	
	
	public ArrayList < Object > getPreventiveMaintenanceReport(int clientId, int systemid, String language, int type, int offset, String startDate, String endDate,int userId) {
	    JSONArray JsonArray = new JSONArray();
	    JSONObject JsonObject = null;
	    Connection con = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
	    ArrayList < ReportHelper > reportsList = new ArrayList < ReportHelper > ();
	    ArrayList < String > headersList = new ArrayList < String > ();
	    ReportHelper finalreporthelper = new ReportHelper();
	    ArrayList < Object > finlist = new ArrayList < Object > ();
	    String alertType = "";
	    try {
	        headersList.add(cf.getLabelFromDB("SLNO", language));
	        headersList.add(cf.getLabelFromDB("Asset_Number", language));
	        headersList.add(cf.getLabelFromDB("Vehicle_Id", language));
	        headersList.add(cf.getLabelFromDB("Group_Name", language));
	        headersList.add(cf.getLabelFromDB("Service_Name", language));
	        headersList.add(cf.getLabelFromDB("Last_Service_Date", language));
	        headersList.add(cf.getLabelFromDB("Renewal_By", language));
	        headersList.add(cf.getLabelFromDB("Due_Days", language));
	        headersList.add(cf.getLabelFromDB("Due_Mileage", language));
	        headersList.add(cf.getLabelFromDB("Expiry_Date", language));
	        headersList.add(cf.getLabelFromDB("Odometer", language));
	        headersList.add(cf.getLabelFromDB("Alert_Type", language));
	        headersList.add(cf.getLabelFromDB("Remarks", language));
	        headersList.add("Service_Date");
	        int count = 0;
	        con = DBConnection.getConnectionToDB("AMS");
	        
	        if (type == 1) {
	            pstmt = con.prepareStatement(PreventiveMaintenanceStatements.GET_AND_EXPIRING_SOON_DETAILS_REPORT);
	            pstmt.setInt(1, systemid);
	            pstmt.setInt(2, clientId);
	            pstmt.setInt(3, type);
	            pstmt.setString(4, startDate);
	            pstmt.setString(5, endDate);
	            pstmt.setInt(6, userId);
	            rs = pstmt.executeQuery();
	        } 
	        if (type == 2) {
	            pstmt = con.prepareStatement(PreventiveMaintenanceStatements.GET_ALREADY_EXPIRED_DETAILS_REPORT);
	            pstmt.setInt(1, systemid);
	            pstmt.setInt(2, clientId);
	            pstmt.setInt(3, type);
	            pstmt.setInt(4, userId);
	            rs = pstmt.executeQuery();
	        }
	        if (type == 3){
	            pstmt = con.prepareStatement(PreventiveMaintenanceStatements.GET_HISTORY_DETAILS);
	            pstmt.setInt(1, systemid);
	            pstmt.setInt(2, clientId);
	            pstmt.setInt(3, offset);
	            pstmt.setString(4, startDate);
	            pstmt.setInt(5, offset);
	            pstmt.setString(6, endDate);
	            pstmt.setInt(7, userId);
	            rs = pstmt.executeQuery();
	        }
	        while (rs.next()) {
	            JsonObject = new JSONObject();
	            ArrayList < Object > informationList = new ArrayList < Object > ();
	            ReportHelper reporthelper = new ReportHelper();
	            count++;
	            informationList.add(count);
	            JsonObject.put("slnoIndex", count);
	            
	            JsonObject.put("assetNumberDataIndex", rs.getString("ASSET_NUMBER"));
	            informationList.add(rs.getString("ASSET_NUMBER"));
	            
	            JsonObject.put("vehicleIdDataIndex", rs.getString("VEHICLE_ID")); 
	            informationList.add(rs.getString("VEHICLE_ID"));
	            
	            JsonObject.put("vehicleGroupDataIndex", rs.getString("VEHICLE_GROUP"));	
	            informationList.add(rs.getString("VEHICLE_GROUP"));
	            
	            JsonObject.put("serviceNameDataIndex", rs.getString("TASK_NAME"));
	            informationList.add(rs.getString("TASK_NAME"));
	            
	            if (rs.getString("LAST_SERVICE_DATE") == null || rs.getString("LAST_SERVICE_DATE").equals("") || rs.getString("LAST_SERVICE_DATE").contains("1900")) {
                    JsonObject.put("lastServiceDateDataIndex", "");
                    informationList.add("");

                } else {
                    JsonObject.put("lastServiceDateDataIndex", sdfyyyymmdd.format(rs.getTimestamp("LAST_SERVICE_DATE")));
                    informationList.add(sdfyyyymmdd.format(rs.getTimestamp("LAST_SERVICE_DATE")));
                }
	            
	            JsonObject.put("renewalByDataIndex", rs.getString("RENEWAL_BY"));
	            informationList.add(rs.getString("RENEWAL_BY"));
	            
	            JsonObject.put("dueDaysDataIndex", rs.getString("DUE_DAYS"));
	            informationList.add(rs.getString("DUE_DAYS"));
	            
	            float dueMileage = rs.getFloat("DUE_MILEAGE");
	            JsonObject.put("dueMileageDataIndex", ((int) Math.round(dueMileage)));
	            informationList.add(((int) Math.round(dueMileage)));
	            

	            if (rs.getString("EXPIRY_DATE") == null || rs.getString("EXPIRY_DATE").equals("") || rs.getString("EXPIRY_DATE").contains("1900")) {
                    JsonObject.put("expiryDateDataIndex", "");
                    informationList.add("");

                } else {
                    JsonObject.put("expiryDateDataIndex", sdfyyyymmdd.format(rs.getTimestamp("EXPIRY_DATE")));
                    informationList.add(sdfyyyymmdd.format(rs.getTimestamp("EXPIRY_DATE")));
                }
	            
	            JsonObject.put("odometerReadingDataIndex", rs.getString("ODOMETER")); // odometer reading	
	            informationList.add(rs.getString("ODOMETER"));
	            
	            if (rs.getInt("ALERT_TYPE") == 1) {
	                alertType = "Service Over Due";
	            } else if (rs.getInt("ALERT_TYPE") == 2) {
	                alertType = "Due For Renewal";
	            } else {
	                alertType = "";
	            }
	            JsonObject.put("alertTypeDataIndex", alertType);
	            informationList.add(alertType);
	            
	            JsonObject.put("remarksDataIndex", rs.getString("REMARKS"));
	            informationList.add(rs.getString("REMARKS"));
	            
	            if (rs.getString("SERVICE_DATE") == null || rs.getString("SERVICE_DATE").equals("") || rs.getString("SERVICE_DATE").contains("1900")) {
                    JsonObject.put("ServiceDateDataIndex", "");
                    informationList.add("");

                } else {
                    JsonObject.put("ServiceDateDataIndex", sdfyyyymmdd.format(rs.getTimestamp("SERVICE_DATE")));
                    informationList.add(sdfyyyymmdd.format(rs.getTimestamp("SERVICE_DATE")));
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
	
	
	public String updatePostponeDetails(String assetNumber,String postponeDate,int systemId, int customerId,int userId,int taskId,String reason,int typeOfAlert) {
	    Connection con = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
	    String message = "";
	   
	    try {
	    	con = DBConnection.getConnectionToDB("AMS");
	        pstmt = con.prepareStatement(PreventiveMaintenanceStatements.UPDATE_POSTPONE_DETAILS);
	        pstmt.setInt(1, userId);
	        pstmt.setString(2, postponeDate);
	        pstmt.setString(3, reason);
	        pstmt.setString(4, assetNumber);
	        pstmt.setInt(5, taskId);
	        pstmt.setInt(6, typeOfAlert);
	        pstmt.setInt(7, systemId);
	        pstmt.setInt(8, customerId);
	        int update = pstmt.executeUpdate();
	        if (update > 0) {
	        	message="Task Postponed Successfully"; 
	        } 
	    } catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	        DBConnection.releaseConnectionToDB(con, pstmt, rs);
	    }
	    return message;
	}
	
}










