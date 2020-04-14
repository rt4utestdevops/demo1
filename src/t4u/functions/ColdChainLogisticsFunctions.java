package t4u.functions;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.text.SimpleDateFormat;
import java.util.ArrayList;

import org.json.JSONArray;
import org.json.JSONObject;

import t4u.beans.ReportHelper;
import t4u.common.DBConnection;
import t4u.statements.ColdChainLogisticsStatements;

public class ColdChainLogisticsFunctions {
	
	public JSONArray getZoneNames(int CustId,int systemId ) {
		JSONArray JsonArray = null;
		JSONObject JsonObject = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			JsonArray = new JSONArray();
			con = DBConnection.getConnectionToDB("ADMINISTRATOR");
			pstmt = con.prepareStatement(ColdChainLogisticsStatements.GET_ZONE_DETAILES);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, CustId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				JsonObject = new JSONObject();
				JsonObject.put("Zone_ID", rs.getString("Zone_ID"));
				JsonObject.put("Zone_Name",rs.getString("Zone_Name"));
				JsonArray.put(JsonObject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return JsonArray;
	}
	//-------------------------------------Retail Master  Details --------------------------------------//
	public ArrayList < Object > getRetailMasterDetails( int CustId,int systemid,String language) {
		JSONArray JsonArray = new JSONArray();
		JSONObject JsonObject = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		ReportHelper finalreporthelper = new ReportHelper();
		ArrayList < Object > finlist = new ArrayList < Object > ();
		try {
			int count = 0;
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(ColdChainLogisticsStatements.GET_RETAILER_MASTER_DETAILS);
			pstmt.setInt(1, systemid);
			pstmt.setInt(2, CustId);

			rs = pstmt.executeQuery();
			while (rs.next()) {
				JsonObject = new JSONObject();
				count++;
				JsonObject.put("slnoIndex", count);
				JsonObject.put("retailerNameDataIndex", rs.getString("RETAILER_NAME"));
				JsonObject.put("addressDataIndex", rs.getString("ADDRESS"));
				JsonObject.put("zoneNameDataIndex", rs.getString("ZONE"));
				JsonObject.put("stateNameDataIndex", rs.getString("STATE"));
				JsonObject.put("cityDataIndex", rs.getString("CITY"));
				JsonObject.put("IdDataIndex", rs.getString("RETAILER_ID"));
				JsonObject.put("latitudeDataIndex", rs.getString("LATITUDE"));
				JsonObject.put("longitudeDataIndex", rs.getString("LONGITUDE"));
				JsonObject.put("contactDataIndex", rs.getString("CONTACTNUMBER"));
				JsonObject.put("zoneDataIndex", rs.getString("ZONE_ID"));
				JsonObject.put("stateDataIndex", rs.getString("STATE_ID"));

				JsonArray.put(JsonObject);
			}
			finlist.add(JsonArray);
			finlist.add(finalreporthelper);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}

		return finlist;
	}

	public String insertRetailerMasterInformation(String retailerName,String Address,int zone,int state, String city,String latitude,
			String longitude,int systemId ,int userId,int CustId,String contact) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String message = "";
		String msg="";
		double lat=0;
		double Long = 0;
		try {
			con = DBConnection.getConnectionToDB("AMS");
			lat=Double.parseDouble(latitude);
			Long=Double.parseDouble(longitude);
			pstmt = con.prepareStatement(ColdChainLogisticsStatements.INSERT_INTO_RETAILER_MASTER);
			pstmt.setString(1,retailerName);
			pstmt.setString(2, Address);
			pstmt.setInt(3, zone);
			pstmt.setInt(4, state);
			pstmt.setString(5, city);
			pstmt.setDouble(6, lat);
			pstmt.setDouble(7,Long);
			pstmt.setInt(8, userId);
			pstmt.setInt(9, systemId);
			pstmt.setInt(10,CustId);
			pstmt.setString(11, contact);

			int inserted = pstmt.executeUpdate();
			if (inserted > 0) {
				message = "Saved Successfully";
			}
		} catch(NumberFormatException ex){ 
			if(Long!= Float.NaN){
				msg=" Latitude";
			}
			if(Long!= Float.NaN){
				msg=" Longitude";
			}
			message="Please Enter Valid  "+msg;
		}catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return message;
	}

	public String modifyRetilerMasterInformation(int id ,String retailerName,String Address,int zone,int state, String city,String latitude,
			String longitude,int systemId ,int userId,int CustId,String contact)
	{
		Connection con = null;
		PreparedStatement pstmt = null;
		String message = "";
		String msg="";
		double lat=0;
		double Long = 0;
		try {
			lat=Double.parseDouble(latitude);
			Long=Double.parseDouble(longitude);
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(ColdChainLogisticsStatements.UPDATE_RETAILER_MASTER_INFORMATION);
			pstmt.setString(1,retailerName);
			pstmt.setString(2, Address);
			pstmt.setInt(3, zone);
			pstmt.setInt(4, state);
			pstmt.setString(5, city);
			pstmt.setDouble(6, lat);
			pstmt.setDouble(7,Long);
			pstmt.setInt(8, userId);
			pstmt.setString(9, contact);
			pstmt.setInt(10, systemId);
			pstmt.setInt(11, CustId);
			pstmt.setInt(12,id);
			int updated=pstmt.executeUpdate();
			if (updated > 0) {
				message = "Updated Successfully";
			}
		}
		catch(NumberFormatException ex){ 
			if(Long!= Float.NaN){
				msg=" Latitude";
			}
			if(Long!= Float.NaN){
				msg=" Longitude";
			}
			message="Please Enter Valid  "+msg;
		}
		catch (Exception e) {
			e.printStackTrace();
		} finally {

			DBConnection.releaseConnectionToDB(con, pstmt, null);
		}
		return message;
	}

	public String deleteRecord(int custId, int systemId, int id) {
		Connection con = null;
		PreparedStatement pstmt = null;
		String message = "";
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(ColdChainLogisticsStatements.DELETE_CUSTOMER_DETAILES);
			pstmt.setInt(2, custId);
			pstmt.setInt(1, systemId);
			pstmt.setInt(3, id);
			int Updated = pstmt.executeUpdate();
			if(Updated>0){
				message = "Deleted";
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, null);
		}
		return message;
	}
	//******************* Asset Association Functions start **********************//
	
	public JSONArray getRetailerDetails(int systemId,int clientId){
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject = new JSONObject();
		Connection conAdmin=null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		try{
			jsonArray = new JSONArray();
			conAdmin=DBConnection.getConnectionToDB("AMS");
			if(clientId>0)
				pstmt=conAdmin.prepareStatement(ColdChainLogisticsStatements.GET_ACTIVE_RETAILER_DETAILS);
				pstmt.setInt(1, systemId);
				pstmt.setInt(2,clientId );
			    rs=pstmt.executeQuery();
			while(rs.next())
			{
				    jsonObject = new JSONObject();
		    		jsonObject.put("retailerId",rs.getInt("RETAILER_ID"));
		    		jsonObject.put("retailerName",rs.getString("RETAILER_NAME"));
		    		jsonObject.put("groupid",rs.getInt("GROUP_ID"));
		    		jsonArray.put(jsonObject);
		    		}
		
		}catch(Exception e){
		}	
		finally{
			DBConnection.releaseConnectionToDB(conAdmin, pstmt, rs);
		}	
		return jsonArray;
	}
	
	 public ArrayList < Object > getNonAssociatedAssetDetails(int userId,int systemId, int customerId , int retailerId,int groupId) {
	     JSONArray JsonArray = new JSONArray();
	     JSONObject JsonObject = null;
	     Connection con = null;
	     PreparedStatement pstmt = null;
	     ResultSet rs = null;
	     ArrayList < Object > finlist = new ArrayList < Object > ();
	     try {
	         int count = 0;
	         con = DBConnection.getConnectionToDB("AMS");
	         if (customerId != 0) {
	             pstmt = con.prepareStatement(ColdChainLogisticsStatements.GET_NON_ASSOCIATED_ASSET_DETAILS);
	             pstmt.setInt(1, systemId);
	             pstmt.setInt(2, customerId);
	             pstmt.setInt(3, userId);
	             pstmt.setInt(4, groupId);
	             pstmt.setInt(5, systemId);
	             pstmt.setInt(6, customerId);
	             rs = pstmt.executeQuery();
	         } 
             
	         while (rs.next()) {
	             JsonObject = new JSONObject();
	             count++;
	             JsonObject.put("slnoIndex", count);
	             JsonObject.put("assetDataIndex", rs.getString("Asset"));
	             JsonObject.put("assettypeDataIndex", rs.getString("AssetType"));	           
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
	 
	 public ArrayList < Object > getAssociatedAssetDetails(int userId,int customerId, int systemId, int retailerId,int groupId) {
	     JSONArray JsonArray = new JSONArray();
	     JSONObject JsonObject = null;
	     Connection con = null;
	     PreparedStatement pstmt = null;
	     ResultSet rs = null;
	     ArrayList < Object > finlist = new ArrayList < Object > ();
	     try {
	         int count = 0;
	         con = DBConnection.getConnectionToDB("AMS");
	             pstmt = con.prepareStatement(ColdChainLogisticsStatements.GET_ASSOCIATED_ASSET_DETAILS);
	             pstmt.setInt(1, systemId);
		             pstmt.setInt(2, retailerId);
		             pstmt.setInt(3, systemId);
		             pstmt.setInt(4, customerId);
		             rs = pstmt.executeQuery();
	      
	         while (rs.next()) {
	             JsonObject = new JSONObject();
	             count++;
	             JsonObject.put("slnoIndex1", count);
	             JsonObject.put("assetDataIndex1", rs.getString("Asset"));
	             JsonObject.put("assettypeDataIndex1", rs.getString("AssetType"));
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
	 
		public String associateAsset(int customerId, int systemId, int retailerId, JSONArray js,int userid) {
		    Connection con = null;
		    PreparedStatement pstmt = null;
		    ResultSet rs = null ;
		    String message = "";
		    try {
		        con = DBConnection.getConnectionToDB("AMS");
		        for (int i = 0; i < js.length(); i++) {
		            JSONObject obj = js.getJSONObject(i);
		            String assetNo= obj.getString("assetDataIndex");
		            pstmt = con.prepareStatement(ColdChainLogisticsStatements.INSERT_INTO_RETAILER_ASSET_ASSOCIATION); 
		            pstmt.setInt(1, systemId);
		            pstmt.setInt(2, customerId);  
		            pstmt.setInt(3, retailerId);
		            pstmt.setString(4, assetNo);
		            pstmt.setInt(5, userid);
		            pstmt.executeUpdate();
		        }
		        
		        message = "Associated Successfully.";
		    } catch (Exception e) {
		        e.printStackTrace();
		    } finally {
		        DBConnection.releaseConnectionToDB(con, pstmt, rs);
		      
		    }
		    return message;
		}
		public String dissociateAsset(int customerId, int systemId, int retailerId, JSONArray js,int userid) {
		    Connection con = null;
		    PreparedStatement pstmt2 = null;
		    PreparedStatement pstmt1 = null;
		    PreparedStatement pstmt = null;
		    String message = "";
		    try {
		        con = DBConnection.getConnectionToDB("AMS");
		        con.setAutoCommit(false);
		        for (int i = 0; i < js.length(); i++) {
		            JSONObject obj = js.getJSONObject(i);
		            String assetNo = obj.getString("assetDataIndex1");
		            pstmt = con.prepareStatement(ColdChainLogisticsStatements.INSERT_INTO_RETAILER_ASSET_ASSOCIATION_HISTORY);
		            pstmt.setString(1, assetNo);
		            pstmt.setInt(2, retailerId);
		            pstmt.setInt(3, systemId);
		            int inserted1 = pstmt.executeUpdate();
		            if(inserted1 > 0)
		            {
		            pstmt1=con.prepareStatement(ColdChainLogisticsStatements.UPDATE_RETAILER_ASSET_ASSOC_HISTORY);	
		            pstmt1.setInt(1,userid);
		            pstmt1.setString(2, assetNo);
		            pstmt1.setInt(3, retailerId);
		            pstmt1.setInt(4, systemId);
		           int inserted = pstmt1.executeUpdate();
		            
		            if(inserted > 0)
		            {
		            pstmt2 = con.prepareStatement(ColdChainLogisticsStatements.DELETE_FROM_RETAILER_ASSET_ASSOCIATION);
		            pstmt2.setString(1, assetNo);
		            pstmt2.setInt(2, retailerId);
		            pstmt2.setInt(3, systemId);
		            pstmt2.executeUpdate();
		            }
		            }
		        }
		        con.commit();
		        message = "Disassociated Successfully.";
		    } catch (Exception e) {
		        e.printStackTrace();
		        try {
		            if (con != null)
		                con.rollback();
		        } catch (Exception ex) {
		            ex.printStackTrace();
		        }
		    } finally {
		        DBConnection.releaseConnectionToDB(con, pstmt2, null);
		        DBConnection.releaseConnectionToDB(null, pstmt, null);
		        DBConnection.releaseConnectionToDB(null, pstmt1, null);

		    }
		    return message;
		}
		public ArrayList < Object > getDastboardCount(int userId,int custId,int systemId, int offset) {
			JSONArray JsonArray = new JSONArray();
			JSONObject JsonObject = null;
			Connection con = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			int count = 0;
			ArrayList < Object > finlist = new ArrayList < Object > ();
			try {
				con = DBConnection.getConnectionToDB("AMS");
				pstmt = con.prepareStatement(ColdChainLogisticsStatements.getDashboardCounts);
				pstmt.setInt(1, userId);
				pstmt.setInt(2, userId);
				pstmt.setInt(3, userId);
				pstmt.setInt(4, offset);
				pstmt.setInt(5, userId);
				pstmt.setInt(6, offset);
				pstmt.setInt(7, systemId);
				pstmt.setInt(8, custId);
				pstmt.setInt(9, systemId);
				pstmt.setInt(10, userId);
				rs = pstmt.executeQuery();
				while (rs.next()) {
					JsonObject = new JSONObject();
					count++;
					JsonObject.put("SLNOIndex",count);
					JsonObject.put("groupIndex",rs.getString("GROUP_ID"));
					JsonObject.put("groupNameIndex", rs.getString("GROUP_NAME"));
					JsonObject.put("assetOnIndex", rs.getString("COMMUNICATING"));
				    JsonObject.put("assetOffIndex", rs.getString("NON_COMMUNICATING"));
				    JsonObject.put("movingAssetIndex", rs.getString("MOVING_ASSET"));
				    JsonObject.put("alertIndex", rs.getString("ALERT"));
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
		public ArrayList < Object > getAllVehiclesBasedOnGroupId(int groupId,int userId,int custId,int systemId) {
			JSONArray JsonArray = new JSONArray();
			JSONObject JsonObject = null;
			Connection con = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			ArrayList < Object > finlist = new ArrayList < Object > ();
			try {
				con = DBConnection.getConnectionToDB("AMS");
				pstmt = con.prepareStatement(ColdChainLogisticsStatements.getAllVehiclesBasedOnGroupId);
				pstmt.setInt(1, groupId);
				pstmt.setInt(2, userId);
				pstmt.setInt(3, custId);
				pstmt.setInt(4, systemId);	
				pstmt.setInt(5, groupId);
				pstmt.setInt(6, userId);
				pstmt.setInt(7, custId);
				pstmt.setInt(8, systemId);
				rs = pstmt.executeQuery();
				while (rs.next()) {
					JsonObject = new JSONObject();					
					JsonObject.put("allVehicleNo", rs.getString("REGISTRATION_NO"));
				    JsonObject.put("allLatitude", rs.getString("LATITUDE"));
				    JsonObject.put("allLongitude", rs.getString("LONGITUDE"));
				    JsonObject.put("allLocation", rs.getString("LOCATION"));
				    JsonObject.put("allGps", rs.getString("GPS_DATETIME"));				    
				    JsonObject.put("allStatus", rs.getString("STATUS"));
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
		public JSONArray getCommVehiclesCount(int userId,int custId,int systemId) {
			JSONArray JsonArray = new JSONArray();
			JSONObject JsonObject = null;
			Connection con = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			try {
				con = DBConnection.getConnectionToDB("AMS");
				pstmt = con.prepareStatement(ColdChainLogisticsStatements.getCommVehiclesCount);
				pstmt.setInt(1, userId);
				pstmt.setInt(2, custId);
				pstmt.setInt(3, systemId);				
				rs = pstmt.executeQuery();
				while (rs.next()) {
					JsonObject = new JSONObject();					
					JsonObject.put("commcount", rs.getString("COUNTS"));				    
					JsonArray.put(JsonObject);
				}
				
			} catch (Exception e) {
				e.printStackTrace();
			} finally {
				DBConnection.releaseConnectionToDB(con, pstmt, rs);
			}

			return JsonArray;
		}
		public JSONArray getNonCommVehiclesCount(int userId,int custId,int systemId) {
			JSONArray JsonArray = new JSONArray();
			JSONObject JsonObject = null;
			Connection con = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			try {
				con = DBConnection.getConnectionToDB("AMS");
				pstmt = con.prepareStatement(ColdChainLogisticsStatements.getNonCommVehiclesCount);
				pstmt.setInt(1, userId);
				pstmt.setInt(2, custId);
				pstmt.setInt(3, systemId);			
				rs = pstmt.executeQuery();
				while (rs.next()) {
					JsonObject = new JSONObject();					
					JsonObject.put("noncommcount", rs.getString("COUNTS"));				    
					JsonArray.put(JsonObject);
				}				
			} catch (Exception e) {
				e.printStackTrace();
			} finally {
				DBConnection.releaseConnectionToDB(con, pstmt, rs);
			}

			return JsonArray;
		}
		public JSONArray getMovingVehiclesCount(int userId,int custId,int systemId, int offset) {
			JSONArray JsonArray = new JSONArray();
			JSONObject JsonObject = null;
			Connection con = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			try {
				con = DBConnection.getConnectionToDB("AMS");
				pstmt = con.prepareStatement(ColdChainLogisticsStatements.getMovingVehiclesCount);
				pstmt.setInt(1, systemId);
				pstmt.setInt(2, custId);
				pstmt.setInt(3, userId);
				pstmt.setInt(4, systemId);
				pstmt.setInt(5, offset);	
				rs = pstmt.executeQuery();
				while (rs.next()) {
					JsonObject = new JSONObject();					
					JsonObject.put("movingassetcount",rs.getString("COUNTS"));
					JsonArray.put(JsonObject);
				}
			} catch (Exception e) {
				e.printStackTrace();
			} finally {
				DBConnection.releaseConnectionToDB(con, pstmt, rs);
			}

			return JsonArray;
		}
		public JSONArray getAlertVehiclesCount(int userId,int custId,int systemId, int offset) {
			JSONArray JsonArray = new JSONArray();
			JSONObject JsonObject = null;
			Connection con = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			ArrayList < Object > finlist = new ArrayList < Object > ();
			try {
				con = DBConnection.getConnectionToDB("AMS");
				pstmt = con.prepareStatement(ColdChainLogisticsStatements.getAlertVehiclesCount);
				pstmt.setInt(1, systemId);
				pstmt.setInt(2, userId);
				pstmt.setInt(3, custId);
				pstmt.setInt(4, systemId);
				pstmt.setInt(5, offset);
				rs = pstmt.executeQuery();
				while (rs.next()) {
					JsonObject = new JSONObject();					
					JsonObject.put("alertcount", rs.getString("COUNTS"));
					JsonArray.put(JsonObject);
				}
				finlist.add(JsonArray);
			} catch (Exception e) {
				e.printStackTrace();
			} finally {
				DBConnection.releaseConnectionToDB(con, pstmt, rs);
			}

			return JsonArray;
		}
		
		public JSONArray getPeakOrNonPeakReportSummary(int systemId, String custId, String startDate, String endDate, int offset, int userId) {
		    Connection con = null;
		    PreparedStatement pstmt = null;
		    ResultSet rs = null ;
		    JSONArray jsonArr = new JSONArray();
		    int count = 0;
		    
		    try {
		    	con = DBConnection.getConnectionToDB("AMS");
		    	JSONObject obj = new JSONObject();
		    	
		    	String query = ColdChainLogisticsStatements.GET_PEAK_OR_NON_PEAK_REPORT_SUMMARY.replaceAll("offset", String.valueOf(offset));
		    	pstmt = con.prepareStatement(query);
		    	pstmt.setInt(1, systemId);
		    	pstmt.setString(2, custId);
		    	pstmt.setString(3, startDate);
		    	pstmt.setString(4, endDate);
		    	pstmt.setInt(5, userId);
		    	  
		    	rs = pstmt.executeQuery();
		    	 
		    	while(rs.next()){
		    		obj = new JSONObject();
		    		obj.put("slnoIndex", ++count);
		    		obj.put("dateIndex", rs.getString("Date"));
		    		obj.put("TimeZoneIndex", rs.getString("START_TIME")+"-"+rs.getString("END_TIME") );
		    		obj.put("CountDataIndex", rs.getString("CountPOrNP"));
		    		jsonArr.put(obj);
		    	}

		    } catch (Exception e) {
		        e.printStackTrace();
		    } finally {
		        DBConnection.releaseConnectionToDB(con, pstmt, rs);
		      
		    }
		    return jsonArr;
		}
		public ArrayList<Object> getPeakOrNonPeakReportDetails(int systemId,String custId,String startTime,String endTime,int offset,int userId, String language){
			Connection con = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			JSONArray jsonArray = new JSONArray();
			int count = 0;
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
			ArrayList<String> headersList = new ArrayList<String>();
			ArrayList<ReportHelper> reportList = new ArrayList<ReportHelper>();
			ArrayList<Object> finalist = new ArrayList<Object>();
			ReportHelper finalreportHelper = new ReportHelper();
			CommonFunctions cf = new CommonFunctions();
			try{
				headersList.add(cf.getLabelFromDB("SLNO",language));
				headersList.add(cf.getLabelFromDB("Retailer_Name",language));
				headersList.add(cf.getLabelFromDB("Asset_No", language));
				headersList.add(cf.getLabelFromDB("Asset_Type", language));
				headersList.add(cf.getLabelFromDB("Start_Time",language));
				headersList.add(cf.getLabelFromDB("End_Time",language));
				headersList.add(cf.getLabelFromDB("Time_Zone",language));
				headersList.add(cf.getLabelFromDB("Address",language));
				
				con = DBConnection.getConnectionToDB("AMS");
				pstmt = con.prepareStatement(ColdChainLogisticsStatements.GET_PEAK_OR_NON_PEAK_REPORT_DETAILS);
				pstmt.setInt(1, offset);
				pstmt.setInt(2, offset);
				pstmt.setInt(3, offset);
				pstmt.setInt(4, offset);
				pstmt.setInt(5,systemId);
				pstmt.setString(6, custId);
				pstmt.setInt(7, userId);
				pstmt.setInt(8, offset);
				pstmt.setString(9, startTime);
				pstmt.setInt(10, offset);
				pstmt.setString(11, endTime);
				
				rs = pstmt.executeQuery();
				while(rs.next()){
					
					JSONObject obj = new JSONObject();
					ArrayList<Object> informationList = new ArrayList<Object>();
					ReportHelper reportHelper = new ReportHelper();
					obj.put("SLNODataIndex", ++count);
					informationList.add(count);
					
					obj .put("retailorNameDataIndex",rs.getString("RetailerName"));
					informationList.add(rs.getString("RetailerName"));
					
					obj.put("assetNoDataIndex", rs.getString("AssetNo"));
					informationList.add(rs.getString("AssetNo"));
					
					obj.put("assetTypeDataIndex", rs.getString("AssetType"));
					informationList.add(rs.getString("AssetType"));
					
					obj.put("startTimeDataIndex", sdf.format(rs.getTimestamp("StartTime")));
					informationList.add(sdf.format(rs.getTimestamp("StartTime")));
					
					obj.put("endTimeDataIndex", sdf.format(rs.getTimestamp("EndTime")));
					informationList.add(sdf.format(rs.getTimestamp("EndTime")));
					
					obj.put("timeZoneDataIndex", rs.getString("TimeZone"));
					informationList.add(rs.getString("TimeZone"));
					
					obj.put("addressDataIndex", rs.getString("Address"));
					informationList.add(rs.getString("Address"));
					
					jsonArray.put(obj);
					reportHelper.setInformationList(informationList);
					reportList.add(reportHelper);
				}
				finalreportHelper.setReportsList(reportList);
				finalreportHelper.setHeadersList(headersList);
				finalist.add(jsonArray);
				finalist.add(finalreportHelper);
			}catch (Exception e){
				e.printStackTrace();
			}finally{
				DBConnection.releaseConnectionToDB(con, pstmt, rs);
			}
			return finalist;
		}

}
