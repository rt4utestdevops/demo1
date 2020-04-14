
package t4u.functions;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

import org.json.JSONArray;
import org.json.JSONObject;

import t4u.common.DBConnection;
import t4u.statements.CarRentalStatements;


/**
 * @author prasanna.k
 *
 */
public class serviceStnMakeAssocFunctions {
	
	public JSONArray getDataForNonAssociation(int groupId,int customerId, int systemId,String zone) {
	     JSONArray JsonArray = new JSONArray();
	     JSONObject JsonObject = null;
	     Connection con = null;
	     PreparedStatement pstmt = null;
	     ResultSet rs = null;
	    
	     try {
	         int count = 0;
	         con = DBConnection.getConnectionToDB("AMS");
	         
	        	 pstmt = con.prepareStatement(CarRentalStatements.GET_NONASSOCIATED_STATIONS.replaceAll("#", zone));
	             pstmt.setInt(1, systemId);
	             pstmt.setInt(2, customerId);
	             pstmt.setInt(3, systemId);
	             pstmt.setInt(4, customerId);
	             pstmt.setInt(5, groupId);
	             rs = pstmt.executeQuery();
	             
	         while (rs.next()) {
	             JsonObject = new JSONObject();
	             count++;
	             JsonObject.put("slnoIndex", count);
	             JsonObject.put("serNameDataIndex", rs.getString("NAME"));
	             JsonObject.put("hubIdDataIndex", rs.getInt("HUBID"));
	             JsonArray.put(JsonObject);
	         }
	         
	     } catch (Exception e) {
	         e.printStackTrace();
	     } finally {
	         DBConnection.releaseConnectionToDB(con, pstmt, rs);
	     }
	     return JsonArray;
	 }
	 
	 
	 public JSONArray getDataForAssociation(int customerId, int systemId,String zone,int groupId,String assetMake) {
	     JSONArray JsonArray = new JSONArray();
	     JSONObject JsonObject = null;
	     Connection con = null;
	     PreparedStatement pstmt = null;
	     ResultSet rs = null;
	   
	     try {
	         int count = 0;
	         con = DBConnection.getConnectionToDB("AMS");
	     
	             pstmt = con.prepareStatement(CarRentalStatements.GET_ASSOCIATED_STATIONS.replaceAll("#", zone));	             
	             pstmt.setInt(1, groupId);
	             pstmt.setString(2,assetMake);
	             pstmt.setInt(3, systemId);
	             pstmt.setInt(4, customerId);
	             rs = pstmt.executeQuery();
	        
	         while (rs.next()) {
	             JsonObject = new JSONObject();
	             count++;
	             JsonObject.put("slnoIndex2", count);
	             JsonObject.put("serNameDataIndex2", rs.getString("NAME"));
	             JsonObject.put("hubIdDataIndex2", rs.getInt("HUB_ID"));
	             JsonArray.put(JsonObject);
	         }
	        
	     } catch (Exception e) {
	         e.printStackTrace();
	     } finally {
	         DBConnection.releaseConnectionToDB(con, pstmt, rs);
	     }
	     return JsonArray;
	 }	 
	 
	 public String associateGroup(int customerId, int systemId, int groupId,String assetMake,JSONArray js,int userId) {
		    Connection con = null;
		    PreparedStatement pstmt = null;
		    PreparedStatement pstmtp = null;
		    ResultSet rs = null;
		    String message = "";
		    ArrayList < String > vehicleList = new ArrayList < String > ();
		    try {
		        con = DBConnection.getConnectionToDB("AMS");
		        for (int i = 0; i < js.length(); i++) {
		            vehicleList.clear();
		            JSONObject obj = js.getJSONObject(i);
		            String hubID = obj.getString("hubIdDataIndex");		      
		            
		            pstmt = con.prepareStatement(CarRentalStatements.CHECK_FOR_EXISTENCE);
		            pstmt.setString(1, hubID);
		            pstmt.setInt(2, groupId);
		            pstmt.setString(3, assetMake);
		            pstmt.setInt(4, systemId);
		            pstmt.setInt(5,customerId);
		            rs = pstmt.executeQuery();
		            if (!rs.next()) {
		                pstmtp = con.prepareStatement(CarRentalStatements.INSERT_INTO_STATION_ASSOC);
		                pstmtp.setInt(1, groupId);
		                pstmtp.setString(2, assetMake);
		                pstmtp.setString(3, hubID);
		                pstmtp.setInt(4, systemId);
			            pstmtp.setInt(5,customerId);
			            pstmtp.setInt(6,userId);
		                pstmtp.executeUpdate();
		                message= "Associated Successfully.";
		            }else{
		            	message = "Already Exists";
		            }		          
		        }
		        
		    } catch (Exception e) {
		        e.printStackTrace();		        
		    } finally {
		        DBConnection.releaseConnectionToDB(con, pstmt,rs);
		        DBConnection.releaseConnectionToDB(null, pstmtp,null);
		    }
		    return message;
		}
	 
	 
	 public String dissociateGroup(int customerId, int systemId, int groupId,String assetMake,JSONArray js,int userId) {
		    Connection con = null;
		    PreparedStatement pstmt = null;
		    String message = "";
		    PreparedStatement pstmtm = null;
		    try {
		        con = DBConnection.getConnectionToDB("AMS");
		        for (int i = 0; i < js.length(); i++) {
		            JSONObject obj = js.getJSONObject(i);
		            String hubID = obj.getString("hubIdDataIndex2");		          
		            pstmtm = con.prepareStatement(CarRentalStatements.INSERT_INTO_STATION_DISASSOC);
		            pstmtm.setInt(1,userId);
	                pstmtm.setInt(2, groupId);
	                pstmtm.setString(3, assetMake);
	                pstmtm.setString(4, hubID);
	                pstmtm.setInt(5, systemId);
		            pstmtm.setInt(6,customerId);		           
	                int moved=pstmtm.executeUpdate();
	                if(moved>0){
		            pstmt = con.prepareStatement(CarRentalStatements.DELETE_FROM_ASSOC);
		            pstmt.setString(1,hubID);
		            pstmt.setInt(2,groupId);
		            pstmt.setString(3,assetMake);
		            pstmt.setInt(4,systemId);
		            pstmt.setInt(5,customerId);
		            int removed =pstmt.executeUpdate();
		            if(removed >0){
		            message = "Disassociated Successfully.";
		              }
		            }
		        }
		        message = "Disassociated Successfully.";
		    } catch (Exception e) {
		        e.printStackTrace();
		    } finally {
		        DBConnection.releaseConnectionToDB(con, pstmt, null);
		    }
		    return message;
		}
	 
	 public JSONArray getVehicleDocumentTypeList(int systemId,int clientId,int groupId) {
		    Connection con = null;
		    PreparedStatement pstmt = null;		    
		    JSONArray JsonArray = new JSONArray();
		    ResultSet rs=null;
		    JSONObject JsonObject = null;
			try {
				con = DBConnection.getConnectionToDB("AMS");
				pstmt = con.prepareStatement(CarRentalStatements.GET_VEHICLE_DOCUMENT_TYPE_LIST);				
				pstmt.setInt(1, systemId);
				pstmt.setInt(2, clientId);
				pstmt.setInt(3, groupId);
				pstmt.setInt(4, systemId);
				rs = pstmt.executeQuery();
				while (rs.next()) {
					if(rs.getString("Name")!=""){
						JsonObject = new JSONObject();
						JsonObject.put("name", rs.getString("Name"));	
						JsonArray.put(JsonObject);	
					}
			   }
			} catch (Exception e) {
				e.printStackTrace();
			} finally {
				DBConnection.releaseConnectionToDB(con, pstmt, rs);
			}
			return JsonArray;
		}
	 public JSONArray getAssetGroupdetails(String customerid, int systemId,String zone) {
			JSONArray AssetGroupJsonArray = new JSONArray();
			JSONObject AssetGroupJsonObject = new JSONObject();
			Connection conAdmin = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			int count=0;
			try {
				AssetGroupJsonArray = new JSONArray();
				AssetGroupJsonObject = new JSONObject();
				conAdmin = DBConnection.getConnectionToDB("ADMINISTRATOR");
				pstmt = conAdmin.prepareStatement(CarRentalStatements.GET_ASSET_GROUP);
				pstmt.setInt(1, Integer.parseInt(customerid));
				pstmt.setInt(2, systemId);
				rs = pstmt.executeQuery();
				while (rs.next()) {	
					count++;
					AssetGroupJsonObject = new JSONObject();
					AssetGroupJsonObject.put("assetgroupidIndex", rs.getString("GROUP_ID"));
					AssetGroupJsonObject.put("assetgroupnameIndex",  rs.getString("GROUP_NAME"));
					AssetGroupJsonArray.put(AssetGroupJsonObject);
				}
			} catch (Exception e) {
				System.out.println("Error in Service Make Association:- getAssetGroupDetails "+e.toString());
			} finally {
				DBConnection.releaseConnectionToDB(conAdmin, pstmt, rs);
			}
			return AssetGroupJsonArray;	
		}
}
