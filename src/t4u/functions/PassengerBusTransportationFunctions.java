package t4u.functions;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.MalformedURLException;
import java.net.ProtocolException;
import java.net.URL;
import java.security.MessageDigest;
import java.security.SecureRandom;
import java.security.Security;
import java.security.cert.CertificateException;
import java.security.cert.X509Certificate;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Random;
import java.util.Set;
import java.util.StringTokenizer;
import java.util.TreeMap;

import javax.net.ssl.HttpsURLConnection;
import javax.net.ssl.SSLContext;
import javax.net.ssl.TrustManager;
import javax.net.ssl.X509TrustManager;

import org.json.JSONArray;
import org.json.JSONObject;

import t4u.beans.ReportHelper;
import t4u.common.DBConnection;
import t4u.passengerbustransportation.ProftAndLossBean;
import t4u.statements.PassengerBusTransportationStatements;

public class PassengerBusTransportationFunctions {

	CommonFunctions cf=new CommonFunctions();
	
	public String insertTerminalMasterDetails(int custId, String terminalId, String terminalName, String location, String status, 
			int systemId,int userId) {
	    Connection con = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
	    PreparedStatement pstmt1 = null;
	    
	    int inserted=0;
	    String message = "";
	    try {
	    
	    	con = DBConnection.getConnectionToDB("AMS");
	    	pstmt = con.prepareStatement(PassengerBusTransportationStatements.CHECK_TERMINAL_MASTER_INFORMATION);
	    	pstmt.setString(1,terminalId.toUpperCase());
	    	pstmt.setInt(2,custId);
	    	pstmt.setInt(3,systemId);
	    	rs=pstmt.executeQuery();
	    	if(rs.next())
			{
	    		message = "Terminal ID   Already Exists";
	    		return message;
			}
	    	pstmt = con.prepareStatement(PassengerBusTransportationStatements.CHECK_TERMINAL_NAME);
	    	pstmt.setString(1,terminalName.toUpperCase());
	    	pstmt.setInt(2,custId);
	    	pstmt.setInt(3,systemId);
	    	rs=pstmt.executeQuery();
	    	if(rs.next()){
	    		message = "Terminal Name  Already Exists";
	    		return message;
	    	}
	    	
	    	if(!rs.next())
	    	{
	        pstmt1 = con.prepareStatement(PassengerBusTransportationStatements.INSERT_TERMINAL_MASTER_INFORMATION);
	        pstmt1.setString(1, terminalId.toUpperCase());
	        pstmt1.setString(2, terminalName.toUpperCase());
	        pstmt1.setString(3, location.toUpperCase());
	        pstmt1.setString(4, status);
	        pstmt1.setFloat(5, systemId);
	        pstmt1.setInt(6, custId);
	        pstmt1.setInt(7, userId);
	        inserted = pstmt1.executeUpdate();
	      
	        if (inserted > 0) {
	            message = "Saved Successfully";
	        }
	    	}
	        } catch (Exception e) {
	        	
	        e.printStackTrace();
	        } finally {
	        DBConnection.releaseConnectionToDB(con, pstmt, rs);
	        DBConnection.releaseConnectionToDB(null, pstmt1, null);
	       
	    }
	    return message;
	}

	public String modifyTerminalMasterDetails(int custId, String terminalId, int id ,String terminalName, String location, String status, 
			int systemId,int userId,String gridStatus) {
	    Connection con = null;
	   
	    PreparedStatement pstmt1 = null;
	    String message = "";
	    int updated=0;
	    try {
	        con = DBConnection.getConnectionToDB("AMS");
	        pstmt1 = con.prepareStatement(PassengerBusTransportationStatements.UPDATE_TERMINAL_MASTER_INFORMATION);
	        pstmt1.setString(1, terminalName.toUpperCase());
	        pstmt1.setString(2, location.toUpperCase());
	        pstmt1.setString(3, status);
	        pstmt1.setInt(4, userId);
	        pstmt1.setInt(5,id);
	        pstmt1.setString(6, terminalId.toUpperCase());
	        pstmt1.setInt(7, systemId);
	        pstmt1.setInt(8, custId);
	        updated=pstmt1.executeUpdate();
	         if (updated > 0) {
	        	message = "Updated Successfully";
	         }
	         else {
	        	 message = "Updated not Successfully";
	         }
	    }
	    catch (Exception e) {
	    	
	        e.printStackTrace();
	        }
	    finally {
	    	DBConnection.releaseConnectionToDB(con, pstmt1, null);
	        
	    }
	    return message;
	}
	
	
	public ArrayList < Object >  getTerminalMasterDetails(int customerId,int systemId,String language) {
		JSONArray jsonArray=null;
		JSONObject jsonObject=null;
		Connection conAms=null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		ArrayList < ReportHelper > reportsList = new ArrayList < ReportHelper > ();
		ArrayList < String > headersList = new ArrayList < String > ();
		ReportHelper finalreporthelper = new ReportHelper();
		ArrayList < Object > alist = new ArrayList < Object > ();
		int count=0;
		try {
			
			
		headersList.add(cf.getLabelFromDB("SLNO", language));
		headersList.add(cf.getLabelFromDB("Id", language));
		headersList.add(cf.getLabelFromDB("Terminal_ID", language));
		headersList.add(cf.getLabelFromDB("Terminal_Name", language));
		headersList.add(cf.getLabelFromDB("Location", language));
		headersList.add(cf.getLabelFromDB("Status", language));
		
			jsonArray=new JSONArray();
			jsonObject=new JSONObject();
			conAms=DBConnection.getConnectionToDB("AMS");
			pstmt=conAms.prepareStatement(PassengerBusTransportationStatements.GET_TERMINAL_MASTER_DETAILS);
	        pstmt.setInt(1, systemId);
	        pstmt.setInt(2, customerId);
	        rs=pstmt.executeQuery();
			while(rs.next()){
				ReportHelper reporthelper = new ReportHelper();
				count++;
				jsonObject = new JSONObject();
				ArrayList < Object > informationList = new ArrayList < Object > ();
			
				informationList.add(count);
				jsonObject.put("slnoIndex", count);
				
				jsonObject.put("idIndex", rs.getInt("ID"));
				informationList.add(rs.getInt("ID"));
			
				jsonObject.put("terminalIdDataIndex", rs.getString("TERMINAL_ID"));
				informationList.add(rs.getString("TERMINAL_ID"));
					
				jsonObject.put("terminalNameDataIndex",rs.getString("TERMINAL_NAME"));
				informationList.add(rs.getString("TERMINAL_NAME"));
				
				jsonObject.put("locationDataIndex",rs.getString("LOCATION"));
				informationList.add(rs.getString("LOCATION"));
				
				
				jsonObject.put("StatusDataIndex",rs.getString("STATUS"));
				informationList.add(rs.getString("STATUS"));
				
				
				
				jsonArray.put(jsonObject);
				reporthelper.setInformationList(informationList);
				
				reportsList.add(reporthelper);
			}
			
			finalreporthelper.setReportsList(reportsList);
			finalreporthelper.setHeadersList(headersList);
			alist.add(jsonArray);
			alist.add(finalreporthelper);
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			DBConnection.releaseConnectionToDB(conAms, pstmt, rs);
		}
		return alist;

	}
	//--------------------------------------------Terminal Route Master function -------------------------------------- //	
	public JSONArray getTerminalName(int systemId ,int CustId) {
		JSONArray JsonArray = null;
		JSONObject JsonObject = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			JsonArray = new JSONArray();
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(PassengerBusTransportationStatements.GET_TERMINAL_NAMES);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, CustId);

			rs = pstmt.executeQuery();
			while (rs.next()) {
				JsonObject = new JSONObject();
				JsonObject.put("TERMINAL_ID", rs.getString("TERMINAL_ID"));
				JsonObject.put("TERMINAL_NAME",rs.getString("TERMINAL_NAME"));
				JsonArray.put(JsonObject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return JsonArray;
	}

	public ArrayList < Object > getTerminalRouteMasterDetails( int CustId,int systemid,String language) {
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
			int count = 0;
			headersList.add(cf.getLabelFromDB("SLNO", language));
			headersList.add(cf.getLabelFromDB("Terminal_Name", language));
			headersList.add(cf.getLabelFromDB("Route_Name", language));  
			headersList.add(cf.getLabelFromDB("Origin", language));  
			headersList.add(cf.getLabelFromDB("Destination", language));   
			headersList.add(cf.getLabelFromDB("Distance(KMs)", language)); 
			headersList.add(cf.getLabelFromDB("Duration(HH:MM)", language)); 
			headersList.add(cf.getLabelFromDB("Status", language));
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(PassengerBusTransportationStatements.GET_TERMINAL_ROUTE_MASTER_DETAILS);
			pstmt.setInt(1, systemid);
			pstmt.setInt(2, CustId);
			rs = pstmt.executeQuery();
			DecimalFormat df = new DecimalFormat("##.##");

			while (rs.next()) {
				JsonObject = new JSONObject();
				count++;
				ArrayList<Object> informationList = new ArrayList<Object>();
				ReportHelper reporthelper = new ReportHelper();
				JsonObject.put("slnoIndex", count);
				informationList.add(count);
				
				JsonObject.put("terminalNameDataIndex", rs.getString("TERMINAL_NAME")); 
				informationList.add(rs.getString("TERMINAL_NAME"));
				
				JsonObject.put("routeNameDataIndex", rs.getString("ROUTE_NAME"));
				informationList.add(rs.getString("ROUTE_NAME"));
				
				JsonObject.put("originDataIndex", rs.getString("Origin"));
				informationList.add(rs.getString("Origin"));
				
				JsonObject.put("destinationDataIndex",rs.getString("DESTINATION"));
				informationList.add(rs.getString("DESTINATION"));
				
				
				float KMS = rs.getFloat("KMS");
				if (rs.getString("KMS") == null || rs.getString("KMS").equals("")) {
					JsonObject.put("kmsDataIndex", "");
				} else {
					JsonObject.put("kmsDataIndex", df.format(KMS));
					informationList.add(KMS);
				}
				String duration = String.valueOf(df.format(rs.getDouble("DURATION")));	
				
				if(duration.length()<3) {
					duration = duration+".00";
				}
				if(duration.charAt(2)!='.'){
					duration = "0"+duration;
				}
				if(duration.length()<5) {
					duration=duration + "0";
				}
					
				JsonObject.put("duratoinDataIndex", duration.replace('.', ':')); 
				informationList.add(duration.replace('.', ':'));       
		
				JsonObject.put("statusDataIndex", rs.getString("STATUS"));
				informationList.add(rs.getString("STATUS"));
				
				JsonObject.put("routeIdDataIndex", rs.getString("ROUTE_ID"));   
				JsonObject.put("terminalIdDataIndex", rs.getString("TERMINAL_ID")); 

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

	public String insertTerminalRouteMasterDetails(int terminalId,String terminalName,String origin,String destination,
			String routeName,float kms,float duration,String status,int systemId,int CustID,int userId ) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		int inserted=0;
		String message = "";
		try {
			con = DBConnection.getConnectionToDB("AMS");
			
			pstmt = con.prepareStatement(PassengerBusTransportationStatements.CHECK_IF_PRESENT);
			
			pstmt.setInt(1, terminalId);
			pstmt.setString(2, routeName);
			pstmt.setInt(3, systemId);
			pstmt.setInt(4, CustID);
			

			rs = pstmt.executeQuery();
			if(rs.next())
			{
				message ="Route : " +routeName+" Alraedy Exist For  Terminal : " +terminalName;
			   return message;
			}
			pstmt = con.prepareStatement(PassengerBusTransportationStatements.INSERT_INTO_TERMINAL_ROUTE_MASTER);
			pstmt.setInt(1, terminalId);
			pstmt.setString(2, origin);
			pstmt.setString(3, destination);
			pstmt.setString(4, routeName);
			pstmt.setFloat(5, kms);
			pstmt.setFloat(6, duration);
			pstmt.setString(7, status);
			pstmt.setInt(8, systemId);
			pstmt.setInt(9, CustID);
			pstmt.setInt(10, userId);
			inserted = pstmt.executeUpdate();
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

	public String modifyTerminalRouteMasterDetails(int id,int terminalId,String terminalName,String origin,String destination,
			String routeName,float kms,float duration,String status,int systemId,int CustID,int userId) {
		Connection con = null;
		PreparedStatement pstmt = null;
		String message = "";
		int updated=0;
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(PassengerBusTransportationStatements.UPDATE_TERMINAL_ROUTE_MASTER);
			
			pstmt.setInt(1, terminalId);
			pstmt.setString(2, origin);
			pstmt.setString(3, destination);
			pstmt.setString(4, routeName);
			pstmt.setFloat(5, kms);
			pstmt.setFloat(6, duration);
			pstmt.setString(7, status);
			pstmt.setInt(8, userId);
			pstmt.setInt(9, systemId);
			pstmt.setInt(10, CustID);
			pstmt.setInt(11, id);
			updated=pstmt.executeUpdate();
			if (updated > 0) {
				message = "Updated Successfully";
			}
		}
		catch (Exception e) {

			e.printStackTrace();
		}
		finally {
			DBConnection.releaseConnectionToDB(con, pstmt, null);
		}
		return message;
	}
	public ArrayList<Object> getprepaidCardMasterList(int systemId,int customerId,int userId,String language) {
		JSONArray cardDetailsArray = new JSONArray();
		JSONObject cardDetailsObject = null;
		ArrayList < ReportHelper > reportsList = new ArrayList < ReportHelper > ();
		ArrayList < String > headersList = new ArrayList < String > ();		
		ReportHelper finalreporthelper = new ReportHelper();
		ArrayList < Object > finlist = new ArrayList < Object > ();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int count=0;
		try{
			headersList.add(cf.getLabelFromDB("SLNO", language));
			headersList.add(cf.getLabelFromDB("Unique_Id",language));
			headersList.add(cf.getLabelFromDB("Issued_To",language));
			headersList.add(cf.getLabelFromDB("Phone_No",language));
			headersList.add(cf.getLabelFromDB("Email_ID",language));
			headersList.add(cf.getLabelFromDB("Amount", language));
			headersList.add(cf.getLabelFromDB("Pending_Amount",language));
			
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(PassengerBusTransportationStatements.GET_PREPAID_CARD_DETAILS);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, customerId);
		//	pstmt.setInt(3, userId);
			rs = pstmt.executeQuery();
			while(rs.next()){
				
				count++;
				ReportHelper reporthelper = new ReportHelper();
				cardDetailsObject = new JSONObject();
				ArrayList < Object > informationList = new ArrayList < Object > ();
				
				informationList.add(count);
				cardDetailsObject.put("SNOIndex",count);
				
				informationList.add(rs.getString("CARD_ID"));
				cardDetailsObject.put("UniqueNoIndex",rs.getString("CARD_ID"));
				
				informationList.add(rs.getString("CARD_HOLDER_NAME"));
				cardDetailsObject.put("issuedIndex",rs.getString("CARD_HOLDER_NAME"));
				
				informationList.add(rs.getString("MOBILE_NUMBER"));
				cardDetailsObject.put("phoneNoIndex",rs.getString("MOBILE_NUMBER"));
				
				informationList.add(rs.getString("EMAIL_ID"));
				cardDetailsObject.put("emailIdIndex",rs.getString("EMAIL_ID"));
				
				informationList.add(rs.getString("AMOUNT"));
				cardDetailsObject.put("amountIndex",rs.getString("AMOUNT"));
				
				informationList.add(rs.getString("PENDING_AMOUNT"));
				cardDetailsObject.put("pendingamountIndex",rs.getString("PENDING_AMOUNT"));
				
				cardDetailsArray.put(cardDetailsObject);
				reporthelper.setInformationList(informationList);
				reportsList.add(reporthelper);
			}
			finalreporthelper.setReportsList(reportsList);
			finalreporthelper.setHeadersList(headersList);
			finlist.add(cardDetailsArray);
			finlist.add(finalreporthelper);
			
			}catch(Exception e){
			e.printStackTrace();
		}finally {
	        DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return finlist;
	}
	public String insertCardDetails(String name,String phoneNo,String emailId,double amount,int systemId,int customerId,int insertedBy){
	    Connection con = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
	    PreparedStatement pst = null;	    
	    int inserted=0;
	    String message = "";
	    String referenceCode="";
	    String cuponCode="";
	    try {	
	    	con = DBConnection.getConnectionToDB("AMS");
	    	
	    	referenceCode=getReferenceCode();
	    	pstmt = con.prepareStatement(PassengerBusTransportationStatements.CHECK_PREPAID_CARD_REFERENCE_NUMBER);	
	    	pstmt.setString(1, referenceCode);
	    	rs=pstmt.executeQuery();
	    	if(rs.next()){
		    	referenceCode=getReferenceCode();
	    	}
	    	cuponCode=getCuponCode();
	    	pstmt = con.prepareStatement(PassengerBusTransportationStatements.CHECK_PREPAID_CARD_COUPON_CODE);	
	    	pstmt.setString(1, cuponCode);
	    	rs=pstmt.executeQuery();
	    	if(rs.next()){
		    	cuponCode=getCuponCode();
	    	}
	    	
    			pst = con.prepareStatement(PassengerBusTransportationStatements.INSERT_PREPAID_CARD_DETAILS);
    			pst.setString(1, referenceCode);
    			pst.setString(2, cuponCode);
		        pst.setString(3, name);
		        pst.setString(4, phoneNo);
		        pst.setString(5, emailId);
		        pst.setDouble(6, amount);
		        pst.setDouble(7, amount);
		        pst.setInt(8, systemId);
		        pst.setInt(9, customerId);
		        pst.setInt(10, insertedBy);
		       
		        inserted = pst.executeUpdate();
		        if (inserted > 0) {
		            message = "Saved Successfully";
		        }
		        
		       String emailIdList =emailId ;
				String subject = "";
				StringBuilder body = new StringBuilder();
				
					subject = "Prepaid Card No and Reference Code";
					body.append("<html><body>" +
						//Body for vehicle registration and cancellation
						"<table border = 0 width=60% height=50>" +
						"<tr><td align=left><font size=2>Dear "+name+",</font></td></tr>"+
						"<br>"+
						"<tr><td align=left><font size=2> Your Reference Code and Prepaid Card No has been successfully generated"+
						"<tr><td align=left><font size=2><b>Reference Code :</b>"+referenceCode +"</font></td></tr>" +
						"<tr><td align=left><font size=2><b> Prepaid Card No:</b>"+ cuponCode+"</font></td></tr>" +
						"<tr><td align=left><font size=2><b> Amount:</b>"+ amount+"</font></td></tr>"+
						"</table>");
				
				//End of the message for mail
					body.append("</body></html>");
				
				pstmt = con.prepareStatement(PassengerBusTransportationStatements.INSERT_INTO_EMAIL_QUEUE_FOR_REFERENCE_AND_COUPON_CODE_GENERATION);
				pstmt.setString(1, subject);
				pstmt.setString(2, body.toString());
				pstmt.setString(3, emailIdList);
				pstmt.setInt(4, systemId);
				pstmt.setInt(5, customerId);
			    pstmt.executeUpdate();
				
		        String Sms="Referece Code:"+referenceCode+"\n"+"Prepaid Card No: "+cuponCode+"\n"+"Amount:"+amount;
		        pstmt = con.prepareStatement(PassengerBusTransportationStatements.INSERT_SMS);
		        pstmt.setString(1, "234"+phoneNo);
		        pstmt.setString(2, Sms);
		        pstmt.setString(3, "N");
		        pstmt.setInt(4, customerId);
		        pstmt.setInt(5, systemId);
		        pstmt.executeUpdate(); 

		        
		        
	    		    	
	        } catch (Exception e) {	        	
	        	e.printStackTrace();
	        } finally {
	        DBConnection.releaseConnectionToDB(con, pstmt, rs);
	        DBConnection.releaseConnectionToDB(null, pst, null);	       
	    }
	    return message;
	}
	public String modifyCardDetails(String name,String phoneNo,String emailId,double amount,int updatedBy,int systemId,int customerId,int uniqueId) {
	    Connection con = null;	   
	    PreparedStatement pstmt = null;	    
	    String message = "";
	    int updated=0;
	    ResultSet rs = null;
	    String referenceCode="";
	    String couponCode="";
	    
	    try {
	        con = DBConnection.getConnectionToDB("AMS");	       
	        pstmt = con.prepareStatement(PassengerBusTransportationStatements.UPDATE_PREPAID_CARD_DETAILS);	 
	      
	        pstmt.setString(1, name);
	        pstmt.setString(2, phoneNo);
	        pstmt.setString(3, emailId);
	        pstmt.setDouble(4, amount);
	        pstmt.setInt(5, updatedBy);
	        pstmt.setInt(6, systemId);
	        pstmt.setInt(7, customerId);
	        pstmt.setInt(8, uniqueId);
	        updated=pstmt.executeUpdate();
	         if (updated > 0) {
	        	pstmt = con.prepareStatement(PassengerBusTransportationStatements.SELECT_PREPAID_CARD_DETAILS);	
		        pstmt.setInt(1, uniqueId);
		        rs=pstmt.executeQuery();
		        if(rs.next())
		        {
		        	referenceCode=rs.getString("REFERENCE_NUMBER");
		        	couponCode=rs.getString("COUPON_CODE");
		        }
	        	message = "Updated Successfully";
	        	 String emailIdList =emailId ;
					String subject = "";
					StringBuilder body = new StringBuilder();
					
						subject = "Prepaid Card No and Reference Code";
						body.append("<html><body>" +
							//Body for vehicle registration and cancellation
							"<table border = 0 width=60% height=50>" +
							"<tr><td align=left><font size=2>Dear "+name+",</font></td></tr>"+
							"<br>"+
							"<tr><td align=left><font size=2> Your Reference Code and Prepaid Card No has been successfully generated"+
							"<tr><td align=left><font size=2><b>Reference Code :</b>"+referenceCode +"</font></td></tr>" +
							"<tr><td align=left><font size=2><b> Prepaid Card No:</b>"+ couponCode+"</font></td></tr>" +
							"<tr><td align=left><font size=2><b> Amount:</b>"+ amount+"</font></td></tr>"+
							"</table>");
					
					//End of the message for mail
						body.append("</body></html>");
					
					pstmt = con.prepareStatement(PassengerBusTransportationStatements.INSERT_INTO_EMAIL_QUEUE_FOR_REFERENCE_AND_COUPON_CODE_GENERATION);
					pstmt.setString(1, subject);
					pstmt.setString(2, body.toString());
					pstmt.setString(3, emailIdList);
					pstmt.setInt(4, systemId);
					pstmt.setInt(5, customerId);
				    pstmt.executeUpdate();
					
			        String Sms="Referece Code:"+referenceCode+"\n"+"Prepaid Card No: "+couponCode+"\n"+"Amount:"+amount;
			        pstmt = con.prepareStatement(PassengerBusTransportationStatements.INSERT_SMS);
			        pstmt.setString(1, "234"+phoneNo);
			        pstmt.setString(2, Sms);
			        pstmt.setString(3, "N");
			        pstmt.setInt(4, customerId);
			        pstmt.setInt(5, systemId);
			        pstmt.executeUpdate(); 
	        } else {
	        	message = "Error while updation";
	        }
	    }catch (Exception e) {	    	
	        e.printStackTrace();
	        }
	    finally {
	    	DBConnection.releaseConnectionToDB(con, pstmt, rs);        
	    }
	    return message;
	}
	
public JSONArray getRouteName(int systemId,int clientId,int terminalId){
		
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Connection con = null;
		DecimalFormat df = new DecimalFormat("##.##");
		
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject = null;
	    try {
			con =  DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(PassengerBusTransportationStatements.GET_ROUTE_NAME);
			pstmt.setInt(1,systemId);
			pstmt.setInt(2,clientId);
			pstmt.setInt(3,terminalId);
			rs = pstmt.executeQuery();
			while(rs.next()){
				jsonObject = new JSONObject();
				jsonObject.put("RouteId", rs.getInt("ROUTE_ID"));
				jsonObject.put("RouteName", rs.getString("ROUTE_NAME"));
				jsonObject.put("DistanceId", rs.getDouble("DISTANCE"));
				String duration = String.valueOf( df.format(rs.getDouble("DURATION")));
				if(duration.length()<3){
					 duration = duration+".00";
				}
				if(duration.charAt(2)!='.'){
					duration = "0"+duration;
				}
				if(duration.length()<5){
					 duration = duration+"0";
				}
				jsonObject.put("DurationId",duration.replace('.', ':'));
				jsonArray.put(jsonObject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}	
		finally{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jsonArray;
	}

	public JSONArray getVehicleModel(int systemId,int clientId){
		
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Connection con = null;
		
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject = null;
	    try {
			con =  DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(PassengerBusTransportationStatements.GET_VEHICLE_MODEL);
			pstmt.setInt(1,systemId);
			pstmt.setInt(2,clientId);
			rs = pstmt.executeQuery();
			while(rs.next()){
				jsonObject = new JSONObject();
				jsonObject.put("VehicleModelId", rs.getInt("ModelTypeId"));
				jsonObject.put("VehicleModelName", rs.getString("ModelName"));
				jsonArray.put(jsonObject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}	
		finally{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jsonArray;
	}
	
	public JSONArray getSeatingCapacity(int systemId,int clientId){
		
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Connection con = null;
		
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject = null;
	    try {
			con =  DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(PassengerBusTransportationStatements.GET_SEATING_STRUCTURE);
			pstmt.setInt(1,systemId);
			pstmt.setInt(2,clientId);
			rs = pstmt.executeQuery();
			while(rs.next()){
				jsonObject = new JSONObject();
				jsonObject.put("SeatingCapacityId", rs.getInt("STRUCTURE_ID"));
				jsonObject.put("SeatingCapacityType", rs.getString("STRUCTURE_NAME"));
				jsonArray.put(jsonObject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}	
		finally{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jsonArray;
	}
	
	public String saveRateMasterDetails(double amount,int terminalId,int routeId,double distance,double duration,double departureTime,double arrivalTime,int vehicleModelId,int seatingStructureId,String dayType,String status,int systemId,int clientId,int userId){
		
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Connection con = null;
		String message = "";
	    
		try {
			if(!checkRateMasterDetails(systemId, clientId, terminalId, routeId, vehicleModelId, seatingStructureId, dayType,distance,duration,departureTime,arrivalTime,amount,status))
	    	{
				con =  DBConnection.getConnectionToDB("AMS");
				pstmt = con.prepareStatement(PassengerBusTransportationStatements.SAVE_RATE_MASTER_DETAILS);
				pstmt.setDouble(1,amount);
				pstmt.setInt(2,terminalId);
				pstmt.setInt(3,routeId);
				pstmt.setDouble(4, distance);
				pstmt.setDouble(5, duration);
				pstmt.setDouble(6, departureTime);
				pstmt.setDouble(7, arrivalTime);
				pstmt.setInt(8, vehicleModelId);
				pstmt.setInt(9, seatingStructureId);
				pstmt.setString(10, dayType);
				pstmt.setString(11, status);
				pstmt.setInt(12, systemId);
				pstmt.setInt(13, clientId);
				pstmt.setInt(14, userId);
				int inserted = pstmt.executeUpdate();
				if(inserted>0){
					message = "Saved Successfully";
				}else{
					message = "Error while Saveing";
				}
	    	}else{
	    		message = "Rate Master Details Already Exist";
	    	}
		} catch (Exception e) {
			e.printStackTrace();
		}	
		finally{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return message;
	}
	
	public ArrayList<Object> getRateMasterDetails(int systemId,int clientId,String language){
		
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Connection con = null;
		
		int count = 0;
		
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject = null;
		
		ArrayList<ReportHelper> reportsList = new ArrayList<ReportHelper>();
		ArrayList<String> headersList = new ArrayList<String>();
		ReportHelper finalreporthelper = new ReportHelper();
		ArrayList<Object> RateMasterDetailsFinalList = new ArrayList<Object>();

		
		headersList.add(cf.getLabelFromDB("SLNO",language));
		headersList.add(cf.getLabelFromDB("Rate_Id",language));
		headersList.add(cf.getLabelFromDB("Weekday_Holiday",language));
		headersList.add(cf.getLabelFromDB("Terminal_ID",language));
		headersList.add(cf.getLabelFromDB("Terminal_Name",language));
		headersList.add(cf.getLabelFromDB("Route_Id",language));
		headersList.add(cf.getLabelFromDB("Route_Name",language));
		headersList.add(cf.getLabelFromDB("Distance(KMs)",language));
		headersList.add(cf.getLabelFromDB("Duration(HH:MM)",language));
		headersList.add(cf.getLabelFromDB("Departure(HH:MM)",language));
		headersList.add(cf.getLabelFromDB("Arrival(HH:MM)",language));
		headersList.add(cf.getLabelFromDB("Vehicle_Model_Id",language));
		headersList.add(cf.getLabelFromDB("Vehicle_Model",language));
		headersList.add(cf.getLabelFromDB("Seating_Structure_Id",language));
		headersList.add(cf.getLabelFromDB("Seating_Structure",language));
		headersList.add(cf.getLabelFromDB("Rate",language));
		headersList.add(cf.getLabelFromDB("Status",language));
		
	    try {
			con =  DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(PassengerBusTransportationStatements.GET_RATE_MASTER_DETAILS);
			pstmt.setInt(1,systemId);
			pstmt.setInt(2,clientId);
			rs = pstmt.executeQuery();
			while(rs.next()){
				count++;
				jsonObject = new JSONObject();
				ReportHelper reporthelper = new ReportHelper();
				ArrayList<Object> informationList = new ArrayList<Object>();
				
				jsonObject.put("slnoIndex", count);
				informationList.add(count);
				jsonObject.put("RateIdDataIndex",rs.getInt("RATE_ID"));
				informationList.add(rs.getInt("RATE_ID"));
				jsonObject.put("DayTypeDataIndex", rs.getString("DAY_TYPE"));
				informationList.add(rs.getString("DAY_TYPE"));
				jsonObject.put("TerminalIdDataIndex", rs.getInt("TERMINAL_ID"));
				informationList.add( rs.getInt("TERMINAL_ID"));
				jsonObject.put("TerminalDataIndex", rs.getString("TERMINAL_NAME"));
				informationList.add( rs.getString("TERMINAL_NAME"));
				jsonObject.put("RouteIdDataIndex", rs.getInt("ROUTE_ID"));
				informationList.add(rs.getInt("ROUTE_ID"));
				jsonObject.put("RouteNameDataIndex", rs.getString("ROUTE_NAME"));
				informationList.add(rs.getString("ROUTE_NAME"));
				jsonObject.put("DistanceDataIndex", rs.getDouble("DISTANCE"));
				informationList.add(rs.getDouble("DISTANCE"));
				String duration = String.valueOf(rs.getDouble("DURATION"));
				if(duration.charAt(2)!='.'){
					duration = "0"+duration;
				}
				if(duration.length()<5){
					 duration = duration+"0";
				}
				jsonObject.put("DurationDataIndex",duration.replace('.', ':'));
				informationList.add(duration.replace('.', ':'));
				String departureTime = String.valueOf(rs.getDouble("DEPARTURE_TIME"));
				if(departureTime.charAt(2)!='.'){
					departureTime = "0"+departureTime;
				}
				if(departureTime.length()<5){
					departureTime = departureTime+"0";
				}
				jsonObject.put("DepartureDataIndex", departureTime.replace('.', ':'));
				informationList.add( departureTime.replace('.', ':'));
				String arrivalTime = String.valueOf(rs.getDouble("ARRIVAL_TIME"));
				if(arrivalTime.charAt(2)!='.'){
					arrivalTime = "0"+arrivalTime;
				}
				if(arrivalTime.length()<5){
					arrivalTime = arrivalTime+"0";
				}
				jsonObject.put("ArrivalDataIndex",arrivalTime.replace('.', ':'));
				informationList.add(arrivalTime.replace('.', ':'));
				jsonObject.put("VehicleModelIdDataIndex", rs.getInt("VEHICLE_MODEL_ID"));
				informationList.add(rs.getInt("VEHICLE_MODEL_ID"));
				jsonObject.put("VehicleModelDataIndex", rs.getString("ModelName"));
				informationList.add(rs.getString("ModelName"));
				jsonObject.put("SeatingStructureIdDataIndex", rs.getInt("SEATING_STRUCTURE_ID"));
				informationList.add(rs.getInt("SEATING_STRUCTURE_ID"));
				jsonObject.put("SeatingStructureDataIndex", rs.getString("STRUCTURE_NAME"));
				informationList.add(rs.getString("STRUCTURE_NAME"));
				jsonObject.put("RateDataIndex", rs.getString("AMOUNT"));
				informationList.add(rs.getString("AMOUNT"));
				jsonObject.put("StatusDataIndex", rs.getString("STATUS"));
				informationList.add(rs.getString("STATUS"));
				
				jsonArray.put(jsonObject);
				reporthelper.setInformationList(informationList);
				reportsList.add(reporthelper);
			}
			RateMasterDetailsFinalList.add(jsonArray);
			finalreporthelper.setReportsList(reportsList);
			finalreporthelper.setHeadersList(headersList);
			RateMasterDetailsFinalList.add(finalreporthelper);
			
		} catch (Exception e) {
			e.printStackTrace();
		}	
		finally{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return RateMasterDetailsFinalList;
	}
	
	public String updateRateMasterDetails(int id,double amount,int terminalId,int routeId,double distance,double duration,double departureTime,double arrivalTime,int vehicleModelId,int seatingStructureId,String dayType,String status,int systemId,int clientId,int userId){
		PreparedStatement pstmt = null;
		Connection con = null;
		
		String message = "";
	    try {
	    	if(!checkRateMasterDetails(systemId, clientId, terminalId, routeId, vehicleModelId, seatingStructureId, dayType,distance,duration,departureTime,arrivalTime,amount,status))
	    	{
	    	   con =  DBConnection.getConnectionToDB("AMS");
	    	   pstmt = con.prepareStatement(PassengerBusTransportationStatements.UPDATE_RATE_MASTER_DETAILS);
	    	   pstmt.setString(1, dayType);
	    	   pstmt.setInt(2,terminalId);
	    	   pstmt.setInt(3,routeId);
	    	   pstmt.setDouble(4, distance);
	    	   pstmt.setDouble(5,duration);
	    	   pstmt.setDouble(6,departureTime);
	    	   pstmt.setDouble(7, arrivalTime);
	    	   pstmt.setInt(8, vehicleModelId);
	    	   pstmt.setInt(9, seatingStructureId);
	    	   pstmt.setDouble(10,amount);
	    	   pstmt.setString(11, status);
	    	   pstmt.setInt(12, userId);
	    	   pstmt.setInt(13, systemId);
	    	   pstmt.setInt(14, clientId);
	    	   pstmt.setInt(15, id);
	    	   int update = pstmt.executeUpdate();
	    	   if(update>0){
	    		   message = "Updated Successfully";
	    	   }else{
	    		   message = "Updation Fail";
	    	   }
	    	}else{
	    		message = "Rate Master Details Already Exist";
	    	}
	    } catch (Exception e) {
			e.printStackTrace();
		}	
		finally{
			DBConnection.releaseConnectionToDB(con, pstmt, null);
		}
		return message;
	}
	
	private boolean checkRateMasterDetails(int systemId,int clientId,int terminalId,int routeId,int vehicleModelId,int seatingCapacity,String dayType,double distance,double duration,double departureTime,double arrivalTime,double amount,String status){
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Connection con = null;
		boolean present = false;
	    
		try {
			con =  DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(PassengerBusTransportationStatements.CHECK_RATE_MASTER_DETAILS);
			pstmt.setInt(1,systemId);
			pstmt.setInt(2,clientId);
			pstmt.setInt(3,terminalId);
			pstmt.setInt(4, routeId);
			pstmt.setInt(5, seatingCapacity);
			pstmt.setInt(6, vehicleModelId);
			pstmt.setString(7, dayType);
			pstmt.setDouble(8,distance);
			pstmt.setDouble(9,duration);
			pstmt.setDouble(10,departureTime);
			pstmt.setDouble(11,arrivalTime);
			pstmt.setDouble(12,amount);
			pstmt.setString(13, status);
			rs = pstmt.executeQuery();
			if(rs.next()){
				present = true;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}	
		finally{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return present;
	}
	
//---------------------------------------- Trip Planner Function-----------------------------------------------------
	
	public JSONArray getRouteNames(int systemId,int custId,int terminalId,String daytype ) {
		JSONArray JsonArray = null;
		JSONObject JsonObject = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			JsonArray = new JSONArray();
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(PassengerBusTransportationStatements.GET_ROUTES_NAMES);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, custId);
			pstmt.setInt(3, terminalId);
			pstmt.setString(4, daytype);

			rs = pstmt.executeQuery();
			while (rs.next()) {
				JsonObject = new JSONObject();
				JsonObject.put("RATE_ID",rs.getString("RATE_ID"));
				JsonObject.put("ROUTE_ID", rs.getString("ROUTE_ID"));
				JsonObject.put("ROUTE_NAME",rs.getString("ROUTE_NAME"));
				JsonArray.put(JsonObject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return JsonArray;
	}
	
	
   public JSONArray getRateDetails(int systemId,int custId,int terminalId,String dayType,int rateId ){
	JSONArray JsonArray = null;
	JSONObject JsonObject = null;
	Connection con = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	DecimalFormat df = new DecimalFormat("##.##");

	try {
		JsonArray = new JSONArray();
		con = DBConnection.getConnectionToDB("AMS");
		pstmt = con.prepareStatement(PassengerBusTransportationStatements.GET_ROUTES_DETAILS);
		pstmt.setInt(1, systemId);
		pstmt.setInt(2, custId);
		pstmt.setInt(3, terminalId);
		//pstmt.setInt(4, routeId);
		pstmt.setString(4, dayType);
		pstmt.setInt(5,rateId);

		rs = pstmt.executeQuery();
		while (rs.next()) {
			JsonObject = new JSONObject();
			JsonObject.put("RATE_ID", rs.getString("RATE_ID"));
			JsonObject.put("ROUTE_ID", rs.getString("ROUTE_ID"));
			JsonObject.put("ORIGIN_DESTINATION",rs.getString("ORIGIN_DESTINATION"));
			
			String duration = String.valueOf(df.format(rs.getDouble("DURATION")));
			duration = duration.replace('.', ':');
			JsonObject.put("DURATION",duration);
			
			String distance  = String.valueOf(df.format(rs.getDouble("DISTANCE")));
			JsonObject.put("DISTANCE",distance);
			
			String departureTime = String.valueOf(rs.getDouble("DEPARTURE_TIME"));
			if(departureTime.charAt(2)!='.'){
				departureTime = "0"+departureTime;
			}
			if(departureTime.length()<5){
				departureTime = departureTime+"0";
			}
			departureTime = departureTime.replace('.', ':');
			
			String arrivalTime = String.valueOf(rs.getDouble("ARRIVAL_TIME"));
			if(arrivalTime.charAt(2)!='.'){
				arrivalTime = "0"+arrivalTime;
			}
			if(arrivalTime.length()<5){
				arrivalTime = arrivalTime+"0";
			}
			arrivalTime = arrivalTime.replace('.', ':');
			String dep_arr = departureTime+" - "+arrivalTime;
			
			
			JsonObject.put("ARRIVAL_DEPARTURE",dep_arr);
			JsonObject.put("AMOUNT",rs.getString("AMOUNT"));
			JsonObject.put("MODEL_NAME",rs.getString("MODEL_NAME"));
			JsonObject.put("SEATING_STRUCTURE",rs.getString("SEATING_STRUCTURE"));
			
			JsonArray.put(JsonObject);
		}
	} catch (Exception e) {
		e.printStackTrace();
	} finally {
		DBConnection.releaseConnectionToDB(con, pstmt, rs);
	}
	return JsonArray;

	}

  public String tripPlannerDetailsAddFunction (int systemId,int custId,int terminalId,int routeId,String dayType,String buttonValue,String serviceName,int rateId,String status,int userId,int serviceId){
	String message = "";  
	Connection con = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	int insert = 0;
	try {
		
		con = DBConnection.getConnectionToDB("AMS");
		
		pstmt = con.prepareStatement(PassengerBusTransportationStatements.CHECK_DUPLICATE);
		
		pstmt.setString(1, serviceName);
		pstmt.setInt(2, systemId);
		pstmt.setInt(3, custId);
		
		rs = pstmt.executeQuery();
		if(rs.next())
		{
			message ="Service : " +serviceName+" Alraedy Exist ";
		   return message;
		}
		
		pstmt = con.prepareStatement(PassengerBusTransportationStatements.INSERT_INTO_SERVICE_MASTER);
		pstmt.setString(1, serviceName);
		pstmt.setString(2, dayType);
		pstmt.setInt(3, terminalId);
		pstmt.setInt(4, routeId);
		pstmt.setInt(5, rateId);
		pstmt.setString(6, status);
		pstmt.setInt(7, systemId);		
		pstmt.setInt(8, custId);
		pstmt.setInt(9, userId);
		
		insert = pstmt.executeUpdate();
		if(insert>0){
			message = "Added Successfully";	
		}else{
			message = "Error while saving";	
		}
	} catch (Exception e) {
		e.printStackTrace();
	} finally {
		DBConnection.releaseConnectionToDB(con, pstmt, rs);
	}
	return message;
  }
	
  public String tripPlannerDetailsModifyFunction (int systemId,int custId,int terminalId,int routeId,String dayType,String buttonValue,String serviceName,int rateId,String status,int userId,int serviceId){
		String message = "";  
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int insert = 0;
		try {
			con = DBConnection.getConnectionToDB("AMS");
			
			pstmt = con.prepareStatement(PassengerBusTransportationStatements.UPDATE_SERVICE_MASTER);
			pstmt.setString(1, dayType);
			pstmt.setInt(2, terminalId);
			pstmt.setInt(3, routeId);
			pstmt.setInt(4, rateId);
			pstmt.setString(5, status);
			pstmt.setInt(6, userId);
			pstmt.setInt(7, systemId);				
			pstmt.setInt(8, custId);
			pstmt.setString(9, serviceName);
			pstmt.setInt(10, serviceId);

			insert = pstmt.executeUpdate();
			if(insert>0){
				message = "Updated Successfully";	
			}else{
				message = "Error while saving";	
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return message;
	  }
	public ArrayList < Object > getServiceMasterDetails( int CustId,int systemid,String language) {
		JSONArray JsonArray = new JSONArray();
		JSONObject JsonObject = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		CommonFunctions cf=new CommonFunctions();
		ArrayList < ReportHelper > reportsList = new ArrayList < ReportHelper > ();
		ArrayList < String > headersList = new ArrayList < String > ();
		ReportHelper finalreporthelper = new ReportHelper();    
		ArrayList < Object > finlist = new ArrayList < Object > ();

		try {
			
			int count = 0;	
			headersList.add(cf.getLabelFromDB("SLNO",language));
			headersList.add(cf.getLabelFromDB("Service_Id",language));
			headersList.add(cf.getLabelFromDB("Service_Name",language));
			headersList.add(cf.getLabelFromDB("Weekday_Holiday",language));
			headersList.add(cf.getLabelFromDB("Terminal_Name",language));
			headersList.add(cf.getLabelFromDB("Route_Name",language));  
			headersList.add(cf.getLabelFromDB("Origin_Destination",language));  
			headersList.add(cf.getLabelFromDB("Distance(KMs)",language)); 
			headersList.add(cf.getLabelFromDB("Duration(HH:MM)",language)); 
			headersList.add(cf.getLabelFromDB("Departure_Arrival",language)); 
			headersList.add(cf.getLabelFromDB("Vehicle_Model",language)); 
			headersList.add(cf.getLabelFromDB("Seating_Structure",language)); 
			headersList.add(cf.getLabelFromDB("Rate",language));
			headersList.add(cf.getLabelFromDB("Status",language));
			
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(PassengerBusTransportationStatements.GET_SERVICE_DETAILS);
			pstmt.setInt(1, systemid);
			pstmt.setInt(2, CustId);
			rs = pstmt.executeQuery();
			DecimalFormat df = new DecimalFormat("##.##");
			
			    while (rs.next()) {
				JsonObject = new JSONObject();
				count++;
				ArrayList<Object> informationList = new ArrayList<Object>();
				ReportHelper reporthelper = new ReportHelper();
				JsonObject.put("slnoIndex", count);
				informationList.add(count);
				
				JsonObject.put("idIndex", rs.getString("SERVICE_ID")); 				
				informationList.add(rs.getString("SERVICE_ID"));
				
				JsonObject.put("ServiceDataIndex", rs.getString("SERVICE_NAME")); 
				informationList.add(rs.getString("SERVICE_NAME"));
				
				JsonObject.put("weekdayHolidayDataIndex", rs.getString("DAY_TYPE")); 
				informationList.add(rs.getString("DAY_TYPE"));
				
				JsonObject.put("terminalNameDataIndex", rs.getString("TERMINAL_NAME")); 
				informationList.add(rs.getString("TERMINAL_NAME"));
				
				JsonObject.put("routeNameDataIndex", rs.getString("ROUTE_NAME")); 
				informationList.add(rs.getString("ROUTE_NAME"));
				
				JsonObject.put("originDestinationDataIndex", rs.getString("ORIGIN_DESTINATION")); 
				informationList.add(rs.getString("ORIGIN_DESTINATION"));
				
				String distance  = df.format(rs.getDouble("DISTANCE"));
				
				JsonObject.put("distanceDataIndex",distance ); 
				informationList.add(distance);
								
				String duration = df.format(rs.getFloat("DURATION"));
				
				if(duration.length()<3) {
					duration = duration+".00";
				}
				if(duration.charAt(2)!='.'){
					duration = "0"+duration;
				}
				if(duration.length()<5) {
					duration=duration + "0";
				}
				duration = duration.replace('.', ':');

				JsonObject.put("durationDataIndex", duration); 
				informationList.add(duration);
								
				String departureTime = String.valueOf(rs.getDouble("DEPARTURE_TIME"));
				if(departureTime.charAt(2)!='.'){
					departureTime = "0"+departureTime;
				}
				if(departureTime.length()<5){
					departureTime = departureTime+"0";
				}
				departureTime = departureTime.replace('.', ':');
				
				String arrivalTime = String.valueOf(rs.getDouble("ARRIVAL_TIME"));
				if(arrivalTime.charAt(2)!='.'){
					arrivalTime = "0"+arrivalTime;
				}
				if(arrivalTime.length()<5){
					arrivalTime = arrivalTime+"0";
				}
				arrivalTime = arrivalTime.replace('.', ':');
				String dep_arr = departureTime+" - "+arrivalTime;
				
				JsonObject.put("departurearrivalDataIndex", dep_arr); 
				informationList.add(dep_arr);
				
				JsonObject.put("vehicleModelDataIndex", rs.getString("MODEL_NAME")); 
				informationList.add(rs.getString("MODEL_NAME"));
				
				JsonObject.put("SeatingStructureDataIndex", rs.getString("SEATING_STRUCTURE")); 
				informationList.add(rs.getString("SEATING_STRUCTURE"));
					
				JsonObject.put("rateDataIndex", rs.getString("AMOUNT")); 
				informationList.add(rs.getString("AMOUNT"));
				
				JsonObject.put("StatusDataIndex", rs.getString("STATUS"));
				informationList.add(rs.getString("STATUS"));

				JsonObject.put("weekdayHolidayIDDataIndex", rs.getString("DAY_TYPE"));

				JsonObject.put("terminalNameIDDataIndex", rs.getString("TERMINAL_ID"));

				JsonObject.put("routeNameIDDataIndex", rs.getString("ROUTE_ID"));

				JsonObject.put("rateNameIDDataIndex", rs.getString("RATE_ID"));

				JsonObject.put("StatusIDDataIndex", rs.getString("STATUS"));


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
	
	public  ArrayList<Object> getSeatingStructureDetials(int systemID,String customerID,String language){
		ArrayList < Object > finlist = new ArrayList < Object > ();
		JSONArray seatingStructureDetailsArray = null;
		JSONObject seatingStructureDetailsObject = null;
		Connection con=null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;	
		try{
			int count=0;			
			seatingStructureDetailsArray=new JSONArray();
			con=DBConnection.getConnectionToDB("AMS");
			pstmt=con.prepareStatement(PassengerBusTransportationStatements.GET_SEATING_STRUCTURE_DETAILS);
	        pstmt.setInt(1, systemID);
	        pstmt.setInt(2, Integer.parseInt(customerID));
	        rs=pstmt.executeQuery();
	        while(rs.next()){	        	
				count++;			
				seatingStructureDetailsObject = new JSONObject();						
				seatingStructureDetailsObject.put("slnoIndex",count);
				seatingStructureDetailsObject.put("structureidIndex", rs.getInt("STRUCTURE_ID"));
				seatingStructureDetailsObject.put("structurenameIndex",rs.getString("STRUCTURE_NAME"));			
				seatingStructureDetailsObject.put("status",rs.getString("STATUS"));
				seatingStructureDetailsArray.put(seatingStructureDetailsObject);
	        }	     
	        finlist.add(seatingStructureDetailsArray);	
		}catch (Exception e) {
			e.printStackTrace();
		}finally{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		
		return finlist;
	}
	
	
	public String getSeatingStructure(int systemID,int customerID,String structureName){
		Connection con=null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		String seatingStructure=null;
		try{
			con=DBConnection.getConnectionToDB("AMS");
			pstmt=con.prepareStatement(PassengerBusTransportationStatements.CHECK_STRUCTURE_NAME_EXISTS);
	        pstmt.setInt(1, systemID);
	        pstmt.setInt(2, customerID);
	        pstmt.setString(3, structureName);
	        rs=pstmt.executeQuery();
	        if(rs.next()){
	        	seatingStructure=rs.getString("STRUCTURE_DESIGN");
	        }
		}catch (Exception e) {
			e.printStackTrace();
		}finally{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		
		return seatingStructure;
	}	
	
	public String modifyBusSeatingStructure(int systemID,int customerID,String status,int userID,int structureID){
		Connection con=null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		String message=null;
		int count=0;		
		try{
			con=DBConnection.getConnectionToDB("AMS");			
			pstmt=con.prepareStatement(PassengerBusTransportationStatements.UPDATE_STRUCTURE_DETAILS);			
			pstmt.setString(1, status);		
			pstmt.setInt(2, structureID);
			pstmt.setInt(3, systemID);
			pstmt.setInt(4, customerID);
		     count=pstmt.executeUpdate();
		     if(count>0){
		    	 message="Updated Successfully";
		     }else{
		    	 message="Error In Updating";
		     }
			
		    
		}catch (Exception e) {
			e.printStackTrace();
		}finally{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return message;
		
	}
	public ArrayList<Object> getServiceVehicleAssociationList(int systemId,int customerId,String language) {
		JSONArray vehicleAssociationArray = new JSONArray();
		JSONObject vehicleAssociationObject = null;
		ArrayList < ReportHelper > reportsList = new ArrayList < ReportHelper > ();
		ArrayList < String > headersList = new ArrayList < String > ();		
		ReportHelper finalreporthelper = new ReportHelper();
		ArrayList < Object > finlist = new ArrayList < Object > ();
		CommonFunctions cf=new CommonFunctions();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int count=0;
		DecimalFormat decformat = new DecimalFormat("##.###");

		SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
		try{
			headersList.add(cf.getLabelFromDB("SLNO", language));
			headersList.add(cf.getLabelFromDB("Id", language));
			headersList.add(cf.getLabelFromDB("Service_Id", language));
			headersList.add(cf.getLabelFromDB("Service_Name", language));
			headersList.add(cf.getLabelFromDB("Vehicle_No",language));
			headersList.add(cf.getLabelFromDB("Date",language));
			headersList.add(cf.getLabelFromDB("Day_Type",language));
			headersList.add(cf.getLabelFromDB("Terminal_Name", language));
			headersList.add(cf.getLabelFromDB("Route_Name", language));
			headersList.add(cf.getLabelFromDB("Origin_Destination", language));
			headersList.add(cf.getLabelFromDB("Distance", language));
			headersList.add(cf.getLabelFromDB("Departure_Arrival", language));
			headersList.add(cf.getLabelFromDB("Duration", language));
			headersList.add(cf.getLabelFromDB("Vehicle_Model", language));
			headersList.add(cf.getLabelFromDB("Seating_Structure", language));
			headersList.add(cf.getLabelFromDB("Rate", language));
			headersList.add(cf.getLabelFromDB("Status", language));
			headersList.add(cf.getLabelFromDB("Driver_Expense", language));
			headersList.add(cf.getLabelFromDB("Worker_Fee", language));
			headersList.add(cf.getLabelFromDB("Miscellaneous_Fee", language));
			headersList.add(cf.getLabelFromDB("Dispatch_Amount", language));
			headersList.add(cf.getLabelFromDB("Insurance", language));
			headersList.add(cf.getLabelFromDB("Tax", language));
			headersList.add(cf.getLabelFromDB("Total", language));

			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(PassengerBusTransportationStatements.GET_SERVICE_VEHICLE_ASSOCIATION);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, customerId);			
			rs = pstmt.executeQuery();
			while(rs.next()){
				
				count++;
				ReportHelper reporthelper = new ReportHelper();
				vehicleAssociationObject = new JSONObject();
				ArrayList < Object > informationList = new ArrayList < Object > ();
				
				informationList.add(count);
				vehicleAssociationObject.put("SNOIndex",count);
				
				informationList.add(rs.getString("Id"));
				vehicleAssociationObject.put("IdIndex",rs.getString("Id"));
				
				informationList.add(rs.getString("SERVICE_ID"));
				vehicleAssociationObject.put("serviceIdIndex",rs.getString("SERVICE_ID"));
				
				informationList.add(rs.getString("SERVICE_NAME"));
				vehicleAssociationObject.put("serviceNameIndex",rs.getString("SERVICE_NAME"));
				
				informationList.add(rs.getString("REGISTRATION_NO"));
				vehicleAssociationObject.put("vehicleNumberIndex",rs.getString("REGISTRATION_NO"));
				
				informationList.add(rs.getString("DATE_TIME"));
				vehicleAssociationObject.put("DateIndex", sdf.format(rs.getTimestamp("DATE_TIME")));

				informationList.add(rs.getString("DAY_TYPE"));
				vehicleAssociationObject.put("dayTypeIndex",rs.getString("DAY_TYPE"));
				
				informationList.add(rs.getString("TERMINAL_NAME"));
				vehicleAssociationObject.put("terminalIndex",rs.getString("TERMINAL_NAME"));
				
				informationList.add(rs.getString("ROUTE_NAME"));
				vehicleAssociationObject.put("routeNameIndex",rs.getString("ROUTE_NAME"));
				
				informationList.add(rs.getString("ORIGIN_DESTINATION"));
				vehicleAssociationObject.put("originDestinationIndex",rs.getString("ORIGIN_DESTINATION"));
				
				informationList.add(rs.getString("DISTANCE"));
				vehicleAssociationObject.put("distanceIndex",rs.getString("DISTANCE"));
				
				String departure = rs.getString("DEPARTURE_TIME");
				if(departure.charAt(2)!='.'){
					departure = "0"+departure;
				}
				if(departure.length()<5){
					departure = departure+"0";
				}
				departure = departure.replace('.', ':');
				
				String arrival = rs.getString("ARRIVAL_TIME");				
				if(arrival.charAt(2)!='.'){
					arrival = "0"+arrival;
				}
				if(arrival.length()<5){
					arrival = arrival+"0";
				}
				arrival = arrival.replace('.', ':');
				
				informationList.add(departure+" - "+arrival);
				vehicleAssociationObject.put("departureArrivalIndex",(departure+" - "+arrival));
				
				String duration =rs.getString("DURATION"); 

					if(duration.length()<3) {
						duration = duration+".00";
					}
					if(duration.charAt(2)!='.'){
						duration = "0"+duration;
					}
					if(duration.length()<5) {
						duration=duration + "0";
					}
					duration = duration.replace('.', ':');
					
				informationList.add(duration);
				vehicleAssociationObject.put("durationIndex",duration);
				
				informationList.add(rs.getString("VEHICLE_MODEL"));
				vehicleAssociationObject.put("vehicleModelIndex",rs.getString("VEHICLE_MODEL"));
				
				informationList.add(rs.getString("SEATING_STRUCTURE"));
				vehicleAssociationObject.put("seatingStructIndex",rs.getString("SEATING_STRUCTURE"));
				
				informationList.add(rs.getString("Rate"));
				vehicleAssociationObject.put("rateIndex",rs.getString("Rate"));
				
				informationList.add(rs.getString("STATUS"));
				vehicleAssociationObject.put("statusIndex",rs.getString("STATUS"));
				
				informationList.add(decformat.format(rs.getFloat("DRIVER_EXPENSE")));
				vehicleAssociationObject.put("driverExpenseIndex",decformat.format(rs.getFloat("DRIVER_EXPENSE")));
				
				informationList.add(decformat.format(rs.getFloat("WORKER_FEE")));
				vehicleAssociationObject.put("workerFeeIndex",decformat.format(rs.getFloat("WORKER_FEE")));
				
				informationList.add(decformat.format(rs.getFloat("MISCELLANEOUS_EXPENSE")));
				vehicleAssociationObject.put("misExpenseIndex",decformat.format(rs.getFloat("MISCELLANEOUS_EXPENSE")));
				
				informationList.add(decformat.format(rs.getFloat("DISPATCH_AMOUNT")));
				vehicleAssociationObject.put("dispatchIndex",decformat.format(rs.getFloat("DISPATCH_AMOUNT")));
				
				informationList.add(decformat.format(rs.getFloat("INSURANCE")));
				vehicleAssociationObject.put("insuranceIndex",decformat.format(rs.getFloat("INSURANCE")));
				
				informationList.add(decformat.format(rs.getFloat("TAX")));
				vehicleAssociationObject.put("taxIndex",decformat.format(rs.getFloat("TAX")));
				
				informationList.add(decformat.format(rs.getFloat("TOTAL")));
				vehicleAssociationObject.put("totalIndex",decformat.format(rs.getFloat("TOTAL")));
				
				vehicleAssociationArray.put(vehicleAssociationObject);
				reporthelper.setInformationList(informationList);
				reportsList.add(reporthelper);
			}
			finalreporthelper.setReportsList(reportsList);
			finalreporthelper.setHeadersList(headersList);
			finlist.add(vehicleAssociationArray);
			finlist.add(finalreporthelper);
			
			}catch(Exception e){
			e.printStackTrace();
		}
		return finlist;
	}
	
	
	public JSONArray getVehicleRegistrationList(int CustId,int userId,int systemId,String date) {
		JSONArray JsonArray = null;
		JSONObject JsonObject = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			JsonArray = new JSONArray();
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(PassengerBusTransportationStatements.GET_SERVICE_VEHICLE_NUMBER_LIST);
			pstmt.setInt(1, CustId);
			pstmt.setInt(2, systemId);
			pstmt.setInt(3, userId);
			pstmt.setString(4, date);
			pstmt.setInt(5, systemId);
			pstmt.setInt(6, CustId);
			
			rs = pstmt.executeQuery();
			while (rs.next()) {
				JsonObject = new JSONObject();
				JsonObject.put("vehicleNo", rs.getString("REGISTRATION_NO"));
				JsonArray.put(JsonObject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return JsonArray;
	}
	
	public JSONArray getServiceNameList(String terminalId,int systemId,int customerId) {
		JSONArray JsonArray = null;
		JSONObject JsonObject = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			JsonArray = new JSONArray();
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(PassengerBusTransportationStatements.GET_SERVICE_NAME_LIST);
			pstmt.setString(1,terminalId);
			pstmt.setInt(2,systemId);
			pstmt.setInt(3,customerId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				JsonObject = new JSONObject();
				JsonObject.put("serviceId", rs.getString("SERVICE_ID"));
				JsonObject.put("serviceName", rs.getString("SERVICE_NAME"));
				JsonArray.put(JsonObject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return JsonArray;
	}
	public String insertServiceVehicleAssoc(String checkValue,String regNo,int serviceId, String date, int systemId,int customerId,int insertedBy,String status){
		Connection con = null;
	    PreparedStatement pstmt = null;
	    //PreparedStatement pstmt1 = null;
	    ResultSet rs = null;
	    PreparedStatement pst = null;	    
	    int inserted=0;
	    String message = "";
	 
	  SimpleDateFormat formatterYYYYMMdd = new SimpleDateFormat("yyyy-MM-dd");
	  
	    try {
	    	if(checkValue.equalsIgnoreCase("true")){
	    		
	    	for(int i = 0 ; i< 10 ; i++){
	    		Calendar currentDate = Calendar.getInstance();
	    		currentDate.add(Calendar.DATE, i);
	    		date = formatterYYYYMMdd.format(currentDate.getTime());
	    		con = DBConnection.getConnectionToDB("AMS");
		        pstmt = con.prepareStatement(PassengerBusTransportationStatements.CHECK_SERVICE_VEHICLE_NO_ASSOC);	
		    	pstmt.setInt(1, systemId);
		    	pstmt.setInt(2, customerId);
		    	pstmt.setString(3, date);
		    	pstmt.setInt(4, serviceId);
		  
		    	rs=pstmt.executeQuery();
		    	if(!rs.next()){
		    	

		    			pst = con.prepareStatement(PassengerBusTransportationStatements.INSERT_SERVICE_VEHICLE_NO_ASSOC);
				  
				        pst.setString(1,date);
				        pst.setInt(2, serviceId);		       
				        pst.setInt(3, systemId);
				        pst.setInt(4, customerId);
				        pst.setInt(5, insertedBy);
				        pst.setString(6, status);
				        inserted = pst.executeUpdate();
				        if (inserted > 0) {
				            message = "Added Successfully";
				           
				        }
		    	
		    }else{
	        	message = " Service Already Associated With Same Date";	
	        }	
		    	if(i==10){
		    		 return message;	
		    	}
	    	}
	    		
	    	}else{
	    	con = DBConnection.getConnectionToDB("AMS");
	        pstmt = con.prepareStatement(PassengerBusTransportationStatements.CHECK_SERVICE_VEHICLE_NO_ASSOC);	
	    	pstmt.setInt(1, systemId);
	    	pstmt.setInt(2, customerId);
	    	pstmt.setString(3, date);
	    	pstmt.setInt(4, serviceId);
	    //	pstmt.setString(5, status);
	    	rs=pstmt.executeQuery();
	    	if(rs.next())
	    	{
	    		message = " Service Already Associated With Same Date";
		    	return message;
	    	}
	    	else{
//	    			    pstmt1 = con.prepareStatement(PassengerBusTransportationStatements.CHECK_SERVICE_VEHICLE_NO_ASSOC_WITH_VEHICLE);	
//	    		    	pstmt1.setInt(1, systemId);
//	    		    	pstmt1.setInt(2, customerId);
//	    		    	pstmt1.setString(3, date);
//	    		    	pstmt1.setString(4, regNo);
//	    		    	rs=pstmt1.executeQuery();
//	    		    	if(rs.next())
//	    		    	{
//	    		    		message = "vehicle already associated";
//	    		    		return message;
//	    		    	}   	
//	        	    else{
	    			pst = con.prepareStatement(PassengerBusTransportationStatements.INSERT_SERVICE_VEHICLE_NO_ASSOC);
			     //   pst.setString(1, regNo);
			        pst.setString(1,date);
			        pst.setInt(2, serviceId);		       
			        pst.setInt(3, systemId);
			        pst.setInt(4, customerId);
			        pst.setInt(5, insertedBy);
			        pst.setString(6, status);
			        inserted = pst.executeUpdate();
			        if (inserted > 0) {
			            message = "Added Successfully";
			            return message;
			        }
	    	//}
	    }
	    	
	    	}
	    }
	         catch (Exception e) {	        	
	        	e.printStackTrace();
	        } finally {
	        DBConnection.releaseConnectionToDB(con, pstmt, rs);
	        DBConnection.releaseConnectionToDB(null, pst, null);	       
	    }
	  return message;
	}
	public String modifyServiceVehicleAssoc(String regNo,int serviceId, int systemId,int customerId,int updatedBy,int Id,String status,String date) {

	    Connection con = null;	   
	    PreparedStatement pstmt = null;
		ResultSet rs = null;
	    String message = "";
	    int updated=0;
	    boolean flag = true;
	    try {
	        con = DBConnection.getConnectionToDB("AMS");
	        
//	        pstmt = con.prepareStatement(PassengerBusTransportationStatements.CHECK_SERVICE_VEHICLE_NO_ASSOC_WITH_DATE_MODIFIED);	
//	    	pstmt.setInt(1, systemId);
//	    	pstmt.setInt(2, customerId);
//	    	pstmt.setString(3, regNo);	
//	    	pstmt.setString(4, date);
//	    	pstmt.setInt(5, serviceId);
//	    	pstmt.setString(6, status);
//	    	rs=pstmt.executeQuery();
//	    	if(rs.next())
//	    	{
//	    	flag = false;
//		    }
//	    	else{
//	        pstmt = con.prepareStatement(PassengerBusTransportationStatements.CHECK_SERVICE_VEHICLE_NO_ASSOC_WITH_DATE);	
//	    	pstmt.setInt(1, systemId);
//	    	pstmt.setInt(2, customerId);
//	    	pstmt.setString(3, regNo);	
//	    	pstmt.setString(4, date);
//	    	rs=pstmt.executeQuery();
//	    	if(rs.next())
//	    	{
//	    		flag = false;
//	    		String existStatus = rs.getString("STATUS");
//	    		//String existServiceId = rs.getString("SERVICE_ID");
//	    		String existedDate = rs.getString("DATE_TIME");
//	    		existedDate = existedDate.substring(0,existedDate.lastIndexOf("."));
//	    		if( !existStatus.equals(status) ){
//	    			if(existedDate.equals(date)){
//	    			flag = true;
//	    			}
//	    		}
//	    		
//	    	}
//	      
//	    }
	//    	if(flag == true){ 
	    		pstmt = con.prepareStatement(PassengerBusTransportationStatements.UPDATE_SERVICE_VEHICLE_NO_ASSOC);		        
	 	      //  pstmt.setString(1, regNo);
	 	      //  pstmt.setInt(2, serviceId);
	 	        pstmt.setInt(1, updatedBy);
	 	        pstmt.setString(2, status);
	 	      //  pstmt.setString(5, date);
	 	        pstmt.setInt(3, systemId);	       
	 	        pstmt.setInt(4, customerId);	        
	 	        pstmt.setInt(5, Id);
	 	        updated=pstmt.executeUpdate();
	 	         if (updated > 0) {
	 	        	message = "Updated Successfully";
	 	        }
	 	         else {
	 		        	message = "Not Updated Successfully";
	 		        }
	    		
	       // }else{
	       // 	message = "Already Exists";
	      //  }
	    }catch (Exception e) {	    	
	        e.printStackTrace();
	        }
	    finally {
	    	DBConnection.releaseConnectionToDB(con, pstmt, null);        
	    }
	    return message;
	}
	public JSONArray getStoreBasedOnServiceId(int serviceId,int systemId,int customerId) {
		JSONArray JsonArray = null;
		JSONObject JsonObject = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			JsonArray = new JSONArray();
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(PassengerBusTransportationStatements.GET_SERVICE_VEHICLE_ASSOC_BASED_ON_SERVICEID);
			pstmt.setInt(1,serviceId);
			pstmt.setInt(2,systemId);
			pstmt.setInt(3,customerId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				JsonObject = new JSONObject();
				JsonObject.put("dayType", rs.getString("DAY_TYPE"));
				JsonObject.put("routeName", rs.getString("ROUTE_NAME"));
				JsonObject.put("originDestination", rs.getString("ORIGIN_DESTINATION"));
				JsonObject.put("distance", rs.getString("DISTANCE"));
				
				String departure = rs.getString("DEPARTURE_TIME");
				String arrival = rs.getString("ARRIVAL_TIME");
				
				JsonObject.put("departureArrival",(departure+" - "+arrival));
				JsonObject.put("duration", rs.getString("DURATION"));
				JsonObject.put("vehicleModel", rs.getString("VEHICLE_MODEL"));
				JsonObject.put("seatingStructure", rs.getString("SEATING_STRUCTURE"));
				JsonObject.put("rate", rs.getString("RATE"));
				JsonObject.put("status", rs.getString("STATUS"));
				JsonArray.put(JsonObject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return JsonArray;
	}
	
	
	public String getReferenceCode() {
	    
	    String referenceCode="YSG";
	    final Random RANDOM = new SecureRandom();
	    final int PASSWORD_LENGTH = 5;
	    String letters = "123456789";
	    String pw="";
	    try {
	    	for (int i=0; i<PASSWORD_LENGTH; i++)
	         {
	             int index = (int)(RANDOM.nextDouble()*letters.length());
	             pw += letters.substring(index, index+1);
	         }
	    	referenceCode=referenceCode+pw;
	    }catch (Exception e) {	    	
	        e.printStackTrace();
	        }
	    return referenceCode;
	}
	
public String getCuponCode() {
	    
	    String cuponCode="YSGT";
	    final Random RANDOM = new SecureRandom();
	    final int PASSWORD_LENGTH = 12;
	    String letters = "abcdefghijkmnpqrstuvwxyzABCDEFGHIGKLMNPQRSTUVWXYZ123456789";
	    String pw="";
	    try {
	    	for (int i=0; i<PASSWORD_LENGTH; i++)
	         {
	             int index = (int)(RANDOM.nextDouble()*letters.length());
	             pw += letters.substring(index, index+1);
	         }
	    	cuponCode=(cuponCode+pw).toUpperCase();
	    }catch (Exception e) {	    	
	        e.printStackTrace();
	        }
	    return cuponCode;
	}


public ArrayList<Object> getprepaidCardMasterRefundList(int systemId,int customerId,String referenceCode,String emailId) {
	JSONArray cardDetailsArray = new JSONArray();
	JSONObject cardDetailsObject = null;
	ArrayList < Object > finlist = new ArrayList < Object > ();
	Connection con = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	int count=0;
	try{
			
		con = DBConnection.getConnectionToDB("AMS");
		pstmt = con.prepareStatement(PassengerBusTransportationStatements.GET_PREPAID_CARD_REFUND_DETAILS);
		pstmt.setInt(1, systemId);
		pstmt.setInt(2, customerId);
		pstmt.setString(3, referenceCode);
		pstmt.setString(4, emailId);
		rs = pstmt.executeQuery();
		while(rs.next()){
			
			count++;
			cardDetailsObject = new JSONObject();
			
			cardDetailsObject.put("SNODataIndex",count);
			
			cardDetailsObject.put("custNameDataIndex",rs.getString("CARD_HOLDER_NAME"));
			
			cardDetailsObject.put("phoneNoDataIndex",rs.getString("MOBILE_NUMBER"));
			
			cardDetailsObject.put("emailIdDataIndex",rs.getString("EMAIL_ID"));
			
			cardDetailsObject.put("amountDataIndex",rs.getString("AMOUNT"));
			
			cardDetailsObject.put("statusDataIndex", rs.getString("STATUS"));
			
			cardDetailsObject.put("pendingAmountDataIndex",rs.getString("PENDING_AMOUNT"));
			
			cardDetailsArray.put(cardDetailsObject);
			
		}
		finlist.add(cardDetailsArray);
		
		}catch(Exception e){
		e.printStackTrace();
	}
		finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
	return finlist;
}

public String checkReferencecodeAndEmailId(String referenceCode,String emailId,int systemId,int customerId) {
	Connection con = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	String message="";
	try{
	con = DBConnection.getConnectionToDB("AMS");
	pstmt = con.prepareStatement(PassengerBusTransportationStatements.CHECK_EMAIL_REFERENCE_CODE);
	pstmt.setInt(1, systemId);
	pstmt.setInt(2, customerId);
	pstmt.setString(3, referenceCode);
	rs = pstmt.executeQuery();
	if(rs.next()){
	String email=rs.getString("EMAIL_ID");
	if(!email.equals(emailId)){
		return message="Invalid Email Id";
	}
	}else{
		return message="Invalid Reference Code";
	}
	
	
	pstmt = con.prepareStatement(PassengerBusTransportationStatements.CHECK_PREPAID_CARD_REFUND_DETAILS);
	pstmt.setInt(1, systemId);
	pstmt.setInt(2, customerId);
	pstmt.setString(3, referenceCode);
	pstmt.setString(4, emailId);
	rs = pstmt.executeQuery();
	if(rs.next()){
		message="Reference Code Exists";
		int pendingAmount=rs.getInt("PENDING_AMOUNT");
		if(pendingAmount==0.00)
		{
			return message="Amount has been already refunded";
		}
	}
	}catch(Exception e){
		e.printStackTrace();
	}
	finally {
		DBConnection.releaseConnectionToDB(con, pstmt, rs);
	}
return message;
}
public String refundPrepaidCarddetails(String referenceCode,String emailId,int systemId,int customerId,int userId) {
	Connection con = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	String message="";
	try{
	con = DBConnection.getConnectionToDB("AMS");
	

	pstmt = con.prepareStatement(PassengerBusTransportationStatements.UPDATE_PREPAID_CARD_REFUND_DETAILS);
	pstmt.setInt(1, userId);
	pstmt.setInt(2, systemId);
	pstmt.setInt(3, customerId);
	pstmt.setString(4, referenceCode);
	pstmt.setString(5, emailId);
	int i=pstmt.executeUpdate();
	if(i>0){
		message="Refunded Successfully";
	}
	}catch(Exception e){
		e.printStackTrace();
	}
	finally {
		DBConnection.releaseConnectionToDB(con, pstmt, rs);
	}
return message;
}

public String getTerminalNames(int systemID,int customerID,String source,String destination){
	Connection con = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	String terminalNames="";
	int count=0;
	try{
		con = DBConnection.getConnectionToDB("AMS");		
		pstmt = con.prepareStatement(PassengerBusTransportationStatements.GET_TERMINAL);
		pstmt.setInt(1,systemID);
		pstmt.setInt(2,customerID);
		pstmt.setInt(3,systemID);
		pstmt.setInt(4,customerID);
		pstmt.setString(5, source);
		pstmt.setString(6, destination);		
		rs = pstmt.executeQuery();
		while(rs.next()){
			if(count==0){
				terminalNames=rs.getString("TERMINAL_NAME");
        		count=1;
        	}else{
        		terminalNames=terminalNames+"$"+rs.getString("TERMINAL_NAME");
        	}
			
		}		
	}catch (Exception e) {
		e.printStackTrace();
	}finally{
		DBConnection.releaseConnectionToDB(con, pstmt, rs);
		
	}
	return  terminalNames;
}

public String getOrigin(int systemID,int customerID)
{
	Connection con = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	String routeSource="";	
	int count=0;
	try{
		con = DBConnection.getConnectionToDB("AMS");		
			pstmt = con.prepareStatement(PassengerBusTransportationStatements.GET_ROUTE_NAME_BASED_ON_TERMINAL);
			pstmt.setInt(1, systemID);
			pstmt.setInt(2,customerID);			
			rs = pstmt.executeQuery();
			while(rs.next()){
				if(count==0){
					routeSource=rs.getString("SOURCE");
	        		count=1;
	        	}else{
	        		routeSource=routeSource+"@"+rs.getString("SOURCE");
	        	}
				
			}		
	}catch (Exception e) {
		e.printStackTrace();
	}finally{
		DBConnection.releaseConnectionToDB(con, pstmt, rs);
		
	}
	
	return routeSource;
}

public String getDestination(int systemID,int customerID,String source)
{
	Connection con = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	String routeDestination="";	
	int count=0;
	try{
		con = DBConnection.getConnectionToDB("AMS");		
		pstmt = con.prepareStatement(PassengerBusTransportationStatements.GET_DESTINATION);
		pstmt.setInt(1, systemID);
		pstmt.setInt(2,customerID);		
		pstmt.setString(3,source);	
		rs = pstmt.executeQuery();
		while(rs.next()){
				if(count==0){
					routeDestination=rs.getString("DESTINATION");
	        		count=1;
	        	}else{
	        		routeDestination=routeDestination+"@"+rs.getString("DESTINATION");
	        	}
				
		}		
	}catch (Exception e) {
		e.printStackTrace();
	}finally{
		DBConnection.releaseConnectionToDB(con, pstmt, rs);
		
	}
	
	return routeDestination;
}



public JSONArray getServiceNameBasedOnTerminalSearch(int systemID,int customerID,String terminalName,String origin,String destination,String searchDate){
	Connection con = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null,rs1=null;
	int terminalID=0;
	SimpleDateFormat ddmmyyy = new SimpleDateFormat("dd-MM-yyyy");
	SimpleDateFormat yyyymmdd = new SimpleDateFormat("yyyy-MM-dd");
	String formatedSearchDate=null;
	JSONArray JsonArray = null;
	JSONObject JsonObject = null;
	DecimalFormat df = new DecimalFormat("##.##");
	String departureTime=null;
	String arrivalTime=null;
	String duration=null;
	try{
		JsonArray = new JSONArray();
		Date date=(Date) ddmmyyy.parse(searchDate);
		formatedSearchDate=yyyymmdd.format(date);
		con = DBConnection.getConnectionToDB("AMS");
		pstmt = con.prepareStatement(PassengerBusTransportationStatements.CHECK_TERMINAL_NAME);
		pstmt.setString(1, terminalName);
		pstmt.setInt(2,customerID);
		pstmt.setInt(3,systemID);
		rs = pstmt.executeQuery();
		if(rs.next()){
			terminalID=rs.getInt("ID");
			pstmt = con.prepareStatement(PassengerBusTransportationStatements.GET_SERVICE_NAME_BASED_ON_SEARCH);
			pstmt.setInt(1, systemID);
			pstmt.setInt(2,customerID);
			pstmt.setInt(3,terminalID);
			pstmt.setString(4, origin);
			pstmt.setString(5, destination);
			pstmt.setString(6, formatedSearchDate);
			pstmt.setString(7, formatedSearchDate);
			rs1=pstmt.executeQuery();
			while(rs1.next()){
				int avaliableSeats=calculateAvaliableSeats(rs1.getInt("ID"),rs1.getInt("RATE_ID"),rs1.getString("SERVICE_NAME"),rs1.getString("TERMINAL_NAME"),rs1.getInt("SERVICE_ID"),
				rs1.getString("ROUTE_NAME"),formatedSearchDate,con,rs1.getInt("SEATING_CAPACITY"));
				JsonObject = new JSONObject();
				JsonObject.put("servicenameindex", rs1.getString("SERVICE_NAME"));
				JsonObject.put("vehiclemodelindex", rs1.getString("ModelName"));
				departureTime = String.valueOf(rs1.getDouble("DEPARTURE_TIME"));
				if(departureTime!=null){
					if(departureTime.charAt(2)!='.'){
						departureTime = "0"+departureTime;
					}
					if(departureTime.length()<5){
						departureTime = departureTime+"0";
					}
					departureTime=departureTime.replace('.', ':');
					String departuretimeFormat1 = departureTime.substring(0,departureTime.indexOf(":"));
					departureTime = getTimeFormat(Integer.parseInt(departuretimeFormat1),departureTime);
					JsonObject.put("departureindex", departureTime);
				}else{
					JsonObject.put("departureindex", "");
				}				
				 arrivalTime = String.valueOf(rs1.getDouble("ARRIVAL_TIME"));
				if(arrivalTime!=null){
					if(arrivalTime.charAt(2)!='.'){
						arrivalTime = "0"+arrivalTime;
					}
					if(arrivalTime.length()<5){
						arrivalTime = arrivalTime+"0";
					}
					arrivalTime = arrivalTime.replace('.', ':');
					String arrivalFormat = arrivalTime.substring(0,arrivalTime.indexOf(":"));
					arrivalTime = getTimeFormat(Integer.parseInt(arrivalFormat),arrivalTime);					
					
					JsonObject.put("arivalindex", arrivalTime);
				}else{
					JsonObject.put("arivalindex", "");
				}
				 duration = df.format(rs1.getFloat("DURATION"));
					if(duration!=null){
						if(duration.length()<3) {
							duration = duration+".00";
						}
						if(duration.charAt(2)!='.'){
						duration = "0"+duration;
						}
						if(duration.length()<5) {
						duration=duration + "0";
						}
						duration = duration.replace('.', ':');
						JsonObject.put("durationindex", duration);
					}else{
						JsonObject.put("durationindex", "");
					}				
				
				JsonObject.put("avaliableindex", avaliableSeats);
				JsonObject.put("priceindex", rs1.getString("AMOUNT"));
				JsonObject.put("structurenameindex", rs1.getString("STRUCTURE_NAME"));				
				JsonObject.put("serviceidindex", rs1.getInt("SERVICE_ID"));
				JsonObject.put("terminalnameindex", rs1.getString("TERMINAL_NAME"));
				JsonObject.put("terminalidindex", rs1.getInt("ID"));
				JsonObject.put("rateidindex", rs1.getInt("RATE_ID"));
				JsonObject.put("routenameindex", rs1.getString("ROUTE_NAME"));
				JsonArray.put(JsonObject);
			}
		}
	}catch (Exception e) {
		e.printStackTrace();
	}finally{
		DBConnection.releaseConnectionToDB(con, pstmt, rs);
		DBConnection.releaseConnectionToDB(null, null, rs1);
	}
	return JsonArray;
	
}

public int calculateAvaliableSeats(int terminalID,int rateID,String serviceName,String terminalName,int serviceID,String routeName,
		String searchDate,Connection con,int seatingCapacity){	  		   
	   PreparedStatement pstmt = null;
	   ResultSet rs = null;
	   int returnAvaliableSeats=0;
	   
	   try {
		pstmt = con.prepareStatement(PassengerBusTransportationStatements.FIND_TOTAL_BOOKED_SEATS_AVALIABLE_FOR_SERVICE);
		pstmt.setString(1, serviceName);
		pstmt.setString(2, routeName);
		pstmt.setString(3, terminalName);
		pstmt.setString(4, searchDate);
		rs=pstmt.executeQuery();
		if(rs.next()){
			int seatBooked=rs.getInt("BOOKED_SEATS");
			int seatPending=rs.getInt("PENDING");
			if(seatBooked>seatingCapacity){
				returnAvaliableSeats=0;
			}else{				
				returnAvaliableSeats=seatingCapacity-(Math.abs(seatBooked-seatPending));
			}
			
		}else{
			returnAvaliableSeats=seatingCapacity;
		}
		rs.close();
		
		pstmt = con.prepareStatement(PassengerBusTransportationStatements.GET_BOOKED_SEATS_FROM_TEMP_TRANSACTION);
		pstmt.setInt(1,serviceID);
		pstmt.setInt(2,terminalID);
		pstmt.setInt(3,rateID);
		pstmt.setString(4, searchDate);
		rs=pstmt.executeQuery();
		if(rs.next()){
			int tempSeatBooked=rs.getInt("TOTAL_SEAT_SELECTED");
			if(tempSeatBooked>returnAvaliableSeats){
				returnAvaliableSeats=0;
			}else{
				returnAvaliableSeats=returnAvaliableSeats-tempSeatBooked;
			}
			
		}
		
	} catch (Exception e) {
		
		e.printStackTrace();
	}finally{
		DBConnection.releaseConnectionToDB(null, pstmt, rs);
	}
	
	return returnAvaliableSeats;
}


public String getBookedSeatNumbers(int terminalID,int rateID,String serviceName,String terminalName,int serviceID,String routeName,String searchDate){
	Connection con = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;		
	SimpleDateFormat ddmmyyy = new SimpleDateFormat("dd-MM-yyyy");
	SimpleDateFormat yyyymmdd = new SimpleDateFormat("yyyy-MM-dd");
	String formatedSearchDate=null;
	Set<String> seatNumbers = new HashSet<String>();
	ArrayList<String > seatPending= new ArrayList<String>();
	String returningSeatNumbers=null;
	int count=0;
	try{
		Date date=(Date) ddmmyyy.parse(searchDate);
		formatedSearchDate=yyyymmdd.format(date);
		con = DBConnection.getConnectionToDB("AMS");
		pstmt = con.prepareStatement(PassengerBusTransportationStatements.GET_BOOKED_SEAT_NO_FROM_TRANSACTION);
		pstmt.setString(1, serviceName);
		pstmt.setString(2, routeName);
		pstmt.setString(3, terminalName);
		pstmt.setString(4, formatedSearchDate);
		rs=pstmt.executeQuery();
		while(rs.next()){
			seatNumbers.add(rs.getString("SEAT_NUMBER"));
		}
		rs.close();
		
		pstmt = con.prepareStatement(PassengerBusTransportationStatements.GET_PENDING_SEAT_NO_GREATER_THEN_SEAT_LOCK_TIME);
		pstmt.setString(1, serviceName);
		pstmt.setString(2, routeName);
		pstmt.setString(3, terminalName);
		pstmt.setString(4, formatedSearchDate);
		rs=pstmt.executeQuery();
		while (rs.next()){
			seatPending.add(rs.getString("SEAT_NUMBER"));
		}
		rs.close();
		
		for(String seat:seatPending){
			seatNumbers.remove(seat);
		}
		
		pstmt = con.prepareStatement(PassengerBusTransportationStatements.GET_BOOKED_SEAT_NO_FROM_TEM_TRANSACTION);
		pstmt.setInt(1,serviceID);
		pstmt.setInt(2,terminalID);
		pstmt.setInt(3,rateID);
		pstmt.setString(4, formatedSearchDate);			
		rs=pstmt.executeQuery();
		while(rs.next()){
			String seatNO=rs.getString("SELECTED_SEATS");
			String[] seatNumberArray =seatNO.split(",");
			for(int i=0;i<seatNumberArray.length; i++){
				seatNumbers.add(seatNumberArray[i]);
			}
			
		}
		
		for(String numbers:seatNumbers){
			if(count==0){
				returningSeatNumbers=numbers;
				count=1;
			}else{
				returningSeatNumbers=returningSeatNumbers+","+numbers;
			}
		}
		
	}catch (Exception e) {
		e.printStackTrace();
	}finally{
		DBConnection.releaseConnectionToDB(con, pstmt, rs);	
	}
	
	return returningSeatNumbers;
}

public String insertIntoRoundTripTemepTransaction(String trip,int totalSeatSelected,int serviceID,int returnServiceID,int terminalID,int returnterminalID,
		int rateID,int returnRateID,String journeyDate,String returnJourneyDate,String seatNumberSelected,String returnSeatNumberSelected){
	Connection con = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null,rs1=null;		
	SimpleDateFormat ddmmyyy = new SimpleDateFormat("dd-MM-yyyy");
	SimpleDateFormat yyyymmdd = new SimpleDateFormat("yyyy-MM-dd");	
	String startJourneyDate=null;
	String returnJournyDate=null;
	int count=0;
	String tempID=null;
	String tempID1=null;
	String returnTempID=null;
	
	try{		
		Date date=(Date) ddmmyyy.parse(journeyDate);
		startJourneyDate=yyyymmdd.format(date);
		if(trip.equals("round")){
		date=(Date) ddmmyyy.parse(returnJourneyDate);	
		returnJournyDate=yyyymmdd.format(date);	
		}
		con = DBConnection.getConnectionToDB("AMS");
		pstmt = con.prepareStatement(PassengerBusTransportationStatements.INSERT_INTO_TEMP_TRANSACTION,Statement.RETURN_GENERATED_KEYS);
		pstmt.setInt(1, totalSeatSelected);
		pstmt.setInt(2, serviceID);
		pstmt.setInt(3, terminalID);
		pstmt.setInt(4, rateID);
		pstmt.setString(5, startJourneyDate);
		pstmt.setString(6, seatNumberSelected);		
		count=pstmt.executeUpdate();
		
		if(count>0){
			rs=pstmt.getGeneratedKeys();
			if(rs!=null && rs.next()){
				tempID=rs.getString(1);
			}			
		}
		count=0;
		if(trip.equals("round")){
			pstmt = con.prepareStatement(PassengerBusTransportationStatements.INSERT_INTO_TEMP_TRANSACTION,Statement.RETURN_GENERATED_KEYS);
			pstmt.setInt(1, totalSeatSelected);
			pstmt.setInt(2, returnServiceID);
			pstmt.setInt(3, returnterminalID);
			pstmt.setInt(4, returnRateID);
			pstmt.setString(5, returnJournyDate);
			pstmt.setString(6, returnSeatNumberSelected);			
			count=pstmt.executeUpdate();
			if(count>0){
				rs1=pstmt.getGeneratedKeys();
				if(rs1!=null && rs1.next()){
					tempID1=rs1.getString(1);
				}				
			}
		
		}
		
		if(trip.equals("round")){
			returnTempID=tempID+","+tempID1;
		}else{
			returnTempID=tempID;
		}
	}catch (Exception e) {
		e.printStackTrace();
	}finally{
		DBConnection.releaseConnectionToDB(con, pstmt, rs);
		DBConnection.releaseConnectionToDB(null, null, rs1);
	}
	return returnTempID;
}

public String insertIntoTempTransaction(int totalSeatSelected,int serviceID,int terminalID,int rateID,String journeyDate,String seatNumberSelected){
	Connection con = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;		
	SimpleDateFormat ddmmyyy = new SimpleDateFormat("dd-MM-yyyy");
	SimpleDateFormat yyyymmdd = new SimpleDateFormat("yyyy-MM-dd");	
	String startJourneyDate=null;		
	int count=0;
	String tempID=null;
	try{
		
	    Date date=(Date) ddmmyyy.parse(journeyDate);
	    startJourneyDate=yyyymmdd.format(date);
		con = DBConnection.getConnectionToDB("AMS");
		pstmt = con.prepareStatement(PassengerBusTransportationStatements.INSERT_INTO_TEMP_TRANSACTION,Statement.RETURN_GENERATED_KEYS);
		pstmt.setInt(1, totalSeatSelected);
		pstmt.setInt(2, serviceID);
		pstmt.setInt(3, terminalID);
		pstmt.setInt(4, rateID);
		pstmt.setString(5, startJourneyDate);
		pstmt.setString(6, seatNumberSelected);	
		count=pstmt.executeUpdate();
		
		if(count>0){
			rs = pstmt.getGeneratedKeys();
			if(rs!=null && rs.next()){
				tempID=rs.getString(1);
			}			
		}
	}catch (Exception e) {
		e.printStackTrace();
	}finally{
		DBConnection.releaseConnectionToDB(con, pstmt, rs);
	}
	return tempID;
}
public String getMailNotification(String transaction,int customerID,int systemID)
{
	 
	PreparedStatement pstmt = null;
	Connection con = null;		   
    String phoneNo="";
    String seatNO="";
    String passangerNames = "";
    String emailId="";
    String name = "";
    String name1 = "";
    String ticketNo="";    
    ResultSet rs = null;
    String roundtrip = "";
    String body = "";
    int  count = 0;
	String subject ="Ticket Confirmation";
    try {
    con = DBConnection.getConnectionToDB("AMS");
    
    pstmt = con.prepareStatement(PassengerBusTransportationStatements.GET_TRANSACTION_TYPE);
    pstmt.setString(1, transaction);
    rs=pstmt.executeQuery();
	if(rs.next())
	{
		roundtrip=rs.getString("IS_ROUND_TRIP");	
	}
	if(roundtrip.equals("false")){
		String journeyDate="";
	    String departureTime="";
	    String seatingStructure="";
	    String source="";
	    double totalAmount=0.0;
	    int grandtotal=0;
	    String boardingOn="";
	    String destination="";
	    String terminalname="";
	    String vehicelModel = "";
	    String reportingtime = "";
	    String totalSeats = "";
	    String weekday = "";
	pstmt = con.prepareStatement(PassengerBusTransportationStatements.GET_MailDetails);
	pstmt.setString(1, transaction);	
	rs=pstmt.executeQuery();
		if(rs.next())
		{
			phoneNo=rs.getString("PHONE_NUMBER");
			emailId=rs.getString("EMAIL_ID");
			journeyDate=rs.getString("JOURNEY_DATE");
			departureTime=rs.getString("DEPARTURE_TIME");
			String departuretimeFormat1 = departureTime.substring(0,departureTime.indexOf(":"));
			departureTime = getTimeFormat(Integer.parseInt(departuretimeFormat1),departureTime);
			seatingStructure=rs.getString("SEATING_STRUCTURE");
			source=rs.getString("SOURCE");
			totalAmount=rs.getDouble("TOTAL_AMOUNT");
			Long L = Math.round(totalAmount);
			grandtotal = Integer.valueOf(L.intValue());
			boardingOn=rs.getString("INSERTED_DATETIME");
			name1=rs.getString("PASSANGER_NAME");
			name=name1.toUpperCase();
			ticketNo=rs.getString("TICKET_NUMBER");
			destination=rs.getString("DESTINATION");
			terminalname=rs.getString("TERMINAL_NAME");
			vehicelModel = rs.getString("VEHICLE_MODEL");
			reportingtime = rs.getString("REPORTING_TIME");
			String departuretimeFormat = reportingtime.substring(0,reportingtime.indexOf(":"));
			reportingtime = getTimeFormat(Integer.parseInt(departuretimeFormat),reportingtime);
			totalSeats = rs.getString("NUMBER_OF_SEATS");
			weekday = rs.getString("WEEKDAY");
		    }
		 pstmt = con.prepareStatement(PassengerBusTransportationStatements.GET_BOOKED_SEATS);
    	 pstmt.setString(1, transaction);	
    	 rs=pstmt.executeQuery();
		 while(rs.next()){	    		 
		 String seatNo = rs.getString("SEAT_NUMBER");
		 String passangerName = rs.getString("PASSANGER_NAME");
		 String mrMs = rs.getString("GENDER");
		 if(mrMs.equals("F")){
			 mrMs = "Mis/Mrs." ;
		 }else{
			 mrMs = "Mr." ;
		 }
		 passangerName = mrMs+passangerName.toUpperCase();
	     seatNO = seatNO+", "+seatNo;
	     passangerNames = passangerNames+", "+passangerName;
	     }
		 seatNO = seatNO.substring(1);
		 passangerNames = passangerNames.substring(1);
		 body=getEmailTemplate(weekday,passangerNames,totalSeats,vehicelModel,reportingtime,transaction,name,destination,ticketNo,seatNO,phoneNo,emailId,journeyDate,departureTime,seatingStructure,source,grandtotal,boardingOn,terminalname,customerID,systemID);
		 }
	else if(roundtrip.equals("true")){
	    	   String journeyDate1="";
	    	   String departureTime1="";
    	       String seatingStructure1="";
	    	   String source1="";
	    	   double totalAmount1=0.0;
	    	   int grandtot1 = 0;
	    	   double totalAmount2=0.0;
	    	   int grandtot2 = 0;
	    	   String boardingOn1="";
	    	   String destination1="";
	    	   String terminalname1="";
	    	   String journeyDate2="";
	    	   String departureTime2="";
	    	   String seatingStructure2="";
	    	   String source2="";
	    	   String boardingOn2="";
	    	   String destination2="";
	    	   String terminalname2="";
	    	   String seatNo1 = "";
	    	   String seatNo2 = "";
	    	   String Ticketno="";
	    	   String serviceId1="";
	    	   String serviceId2="";
	    	   String weekday1="";
	    	   String weekday2="";
	    	   String totalSeats="";
	    	   String vehiclemodel1="";
	    	   String vehiclemodel2="";
	    	   String reportingtime1="";
	    	   String reportingtime2="";
	    	   pstmt = con.prepareStatement(PassengerBusTransportationStatements.GET_TRANS_DETAILLS_FOR_ROUNDTRIP);
	    		pstmt.setString(1, transaction);	
	    		rs=pstmt.executeQuery();
	    		while (rs.next()){
	    		count=count+1;
	    		if(count == 1){
				journeyDate1=rs.getString("JOURNEY_DATE");
				departureTime1=rs.getString("DEPARTURE_TIME");
				String departuretimeFormat1 = departureTime1.substring(0,departureTime1.indexOf(":"));
				departureTime1 = getTimeFormat(Integer.parseInt(departuretimeFormat1),departureTime1);
			    seatingStructure1=rs.getString("SEATING_STRUCTURE");
				source1=rs.getString("SOURCE");
				totalAmount1=rs.getDouble("AMOUNT");
				Long L = Math.round(totalAmount1);
				grandtot1 = Integer.valueOf(L.intValue());
				boardingOn1=rs.getString("INSERTED_DATETIME");	
				destination1=rs.getString("DESTINATION");
				terminalname1=rs.getString("TERMINAL_NAME");	
				Ticketno=rs.getString("TICKET_NUMBER");
				serviceId1=rs.getString("SERVICE_ID");
				vehiclemodel1 = rs.getString("VEHICLE_MODEL");
				reportingtime1 = rs.getString("REPORTING_TIME");
				String departuretimeFormat = reportingtime1.substring(0,reportingtime1.indexOf(":"));
				reportingtime1 = getTimeFormat(Integer.parseInt(departuretimeFormat),reportingtime1);
				totalSeats = rs.getString("NUMBER_OF_SEATS");
				weekday1 = rs.getString("WEEKDAY");
	    		}
	    		if(count == 2){
	    			journeyDate2=rs.getString("JOURNEY_DATE");
					departureTime2=rs.getString("DEPARTURE_TIME");
					String departuretimeFormat = departureTime2.substring(0,departureTime2.indexOf(":"));
					departureTime2 = getTimeFormat(Integer.parseInt(departuretimeFormat),departureTime2);
					seatingStructure2=rs.getString("SEATING_STRUCTURE");
					source2=rs.getString("SOURCE");
					totalAmount2=rs.getDouble("AMOUNT");
					Long L = Math.round(totalAmount2);
					grandtot2 = Integer.valueOf(L.intValue());
					boardingOn2=rs.getString("INSERTED_DATETIME");	
					destination2=rs.getString("DESTINATION");
					terminalname2=rs.getString("TERMINAL_NAME");
					Ticketno=rs.getString("TICKET_NUMBER");
					serviceId2=rs.getString("SERVICE_ID");
					vehiclemodel2 = rs.getString("VEHICLE_MODEL");
					reportingtime2 = rs.getString("REPORTING_TIME");
					String departuretimeFormat1 = reportingtime2.substring(0,reportingtime2.indexOf(":"));
					reportingtime2 = getTimeFormat(Integer.parseInt(departuretimeFormat1),reportingtime2);
					totalSeats = rs.getString("NUMBER_OF_SEATS");
					weekday2 = rs.getString("WEEKDAY");
	    		}
	    	
        }
	    		
	    		 pstmt = con.prepareStatement(PassengerBusTransportationStatements.GET_PASSANGER_DETAIL_FOR_MAIL);
		    	 pstmt.setString(1, transaction);	
		    	 rs=pstmt.executeQuery();
	    		 if(rs.next()){
	    			 phoneNo=rs.getString("PHONE_NUMBER");
	    		     emailId=rs.getString("EMAIL_ID");
	    		     name1 = rs.getString("PASSANGER_NAME"); 
	    		     name = name1.toUpperCase();
	    		     String mrMs = rs.getString("GENDER");
		    		 if(mrMs.equals("F")){
		    			 mrMs = "Mis/Mrs." ;
		    		 }else{
		    			 mrMs = "Mr." ;
		    		 }
		    		 name = mrMs+name;
	    		}
	    		 
	    		 pstmt = con.prepareStatement(PassengerBusTransportationStatements.GET_BOOKED_SEATS_ROUNDTRIP);
		    	 pstmt.setString(1, transaction);	
		    	 pstmt.setString(2, serviceId1);
		    	// pstmt.setString(3,journeyDate1);
		    	 rs=pstmt.executeQuery();
	    		 while(rs.next()){	    		 
	    		  String seatNO1 =rs.getString("SEAT_NUMBER");
	    		  seatNo1 = seatNo1 +", "+seatNO1;
	    		  String passangerName = rs.getString("PASSANGER_NAME");
		    		 String mrMs = rs.getString("GENDER");
		    		 if(mrMs.equals("F")){
		    			 mrMs = "Mis/Mrs." ;
		    		 }else{
		    			 mrMs = "Mr." ;
		    		 }
		    		 passangerName = mrMs+passangerName.toUpperCase();
		    		 passangerNames = passangerNames+", "+passangerName;
	    		  }	    		
	    		 passangerNames = passangerNames.substring(1);
	    		 
	    		 pstmt = con.prepareStatement(PassengerBusTransportationStatements.GET_BOOKED_SEATS_ROUNDTRIP);
		    	 pstmt.setString(1, transaction);	
		    	 pstmt.setString(2, serviceId2);
		    	// pstmt.setString(3,journeyDate2);
		    	 rs=pstmt.executeQuery();
	    		 while(rs.next()){	    		 
	    		   String seatNO2=rs.getString("SEAT_NUMBER");
	    		   seatNo2=seatNo2 + ", " + seatNO2;
	    		}
	    		 seatNo2 = seatNo2.substring(1);
		body=getEmailTemplate1(weekday1,weekday2,passangerNames,totalSeats,vehiclemodel1,vehiclemodel2,reportingtime1,reportingtime2,name,phoneNo,emailId,Ticketno,seatNo1,seatNo2,journeyDate1,departureTime1,seatingStructure1,source1,grandtot1,boardingOn1,destination1,terminalname1,journeyDate2,departureTime2,seatingStructure2,source2,grandtot2,boardingOn2,destination2,terminalname2,transaction,customerID,systemID);
	     }
	
		pstmt=con.prepareStatement(PassengerBusTransportationStatements.INSERT_INTO_EMAIL_QUEUE);
		pstmt.setString(1, subject);
		pstmt.setString(2, body.toString());
		pstmt.setString(3, emailId);
		pstmt.setInt(4, systemID);
		pstmt.setInt(5, customerID);
		
		pstmt.executeUpdate();
		pstmt=null;

		 String Sms="Dear " + name + " ,your payment was successfully processed"+"\n"+"Please make a note of the Transaction ID for the future reference"+"\n"+"Transaction ID :"+transaction+"\n";
	        pstmt = con.prepareStatement(PassengerBusTransportationStatements.INSERT_SMS);
	        pstmt.setString(1, phoneNo);
	        pstmt.setString(2, Sms);
	        pstmt.setString(3, "N");
	        pstmt.setInt(4,customerID);
	        pstmt.setInt(5, systemID);
	        pstmt.executeUpdate();
		
    
	}
	   catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt,rs);
		}
	return name;
}

public String getEmailTemplate(String weekday,String passangerNames,String totalSeats,String vehiclemodel,String reportingtime,String transaction,String name,String destination,String ticketNo,String seatNO,String phoneNo,String emailId,String journeyDate,String departureTime,String seatingStructure,String source,int totalAmount,String boardingOn,String terminalname,int customerID,int systemID ){
	
	StringBuilder body = new StringBuilder();
    
	try{	
		body.append( "<html>"+"<head>"+"<style>"+"body {font-family: arial, Arial, Helvetica, sans-serif; font-size: 12px}"+
				"body {"+"height: 297mm;"+"width: 210mm;"+"}"+
				"dt { float: left; clear: left; text-align: left; font-weight: bold; margin-right: 10px }"+ 
				"dd {  padding: 0 0 0.5em 0; }"+
				"</style> "+"<style type='text/css' media='print'> "+"</style>"+   
				"</head>"+"<body>"+"<table cellspacing='0' >"+"<tr>"+"<td>"+"<table cellspacing='0'>"+"<tr>"+
				"<td style='width:300px';><strong style='font-size:30px';><img src='http://www.telematics4u.in/ApplicationImages/CustomerLogos/custlogo_"+systemID+"_"+customerID+".gif' alt='ysg' style='width:50%'></td>"+		
				"<td>eTICKET</td>"+"</tr>"+"</table>"+"</td>"+		
				"<td style='text-align:right;padding-left:250px'>Need help with your trip?<br /><br />"+"01-4531091, 08170765674<br />"+
				"info@ysgtransport.com<br />customercare@ysgtransport.com<br />"+"</td>"+
				"</tr>"+"</table>"+"<hr/>"+
				"<table  cellspacing='0' >"+
				"<tr>" +
				"<td style= 'width:400px' ></td>" +
				"<td style='width:150px' ></td>"+
				"<td style='width:150px' ></td>"+
				"<td style='width:200px' ></td>"+
				"</tr>"+
				"<tr>" +				
				"<td  style= 'width:400px'><strong>"+ source + " TO " + destination+ " </strong></td>"+
			    "<td style= 'width:150px' ><strong>"+weekday+"</strong></td> "+
				"<td style='width:150px'><strong>" + journeyDate + "</strong></td>"+
										
				"<td style='text-align:right;width:200px' ><strong> Ticket No: " + ticketNo +"</strong><br />"+
				" Transaction No: "+ transaction +"<br />"+
				"</td>"+"</tr>"+
				
				"<tr><td><hr/></td><td><hr/></td><td><hr/></td><td><hr/></td></tr>"+
				"<tr>"+"<td style='width:400px'>"+"Vehicle Model<br />"+"<strong>"+ vehiclemodel +" - "+ seatingStructure +"</strong>"+"</td>"+
				"<td style='width:150px'>"+"Reporting Time<br/>"+"<strong>"+ reportingtime +"</strong>"+"</td>"+"<td style='width:150px'>"+"Departure Time<br/>"+
				"<strong>"+ departureTime +"</strong>"+"</td>"+"<td style='width:200px;text-align:right'>"+"No. Of Seats Booked<br />"+"<strong>"+totalSeats+"</strong>"+
				"</td>"+"</tr>"+
				"<tr>"+"<td>"+"<hr/>"+"</td>"+"<td>"+"<hr/>"+"</td>"+"<td>"+"<hr/>"+"</td>"+"<td>"+"<hr/>"+"</td>"+"</tr>"+
				"<tr>"+
				
				"<td style='width:400px'>Passengers Details:<br /><strong>"+passangerNames+"</strong></td>"+	
				"<td style='width:150px'> Booked Seats:<br /><strong>"+seatNO+"</strong></td>"+
				"<td style='width:150px' >"+"Terminal Name:<br /> <strong>"+ terminalname +"</strong>"+"</td>"+					
				"<td style='width:200px;text-align:right'>"+"Contact Details:<br /> Phone: "+phoneNo+"<br/>Email: "+emailId+"<br />"+"</td>"+				
                "</tr>"+
                
				"<tr>"+"<td>"+"<hr/>"+"</td>"+"<td>"+"<hr/>"+"</td>"+"<td>"+"<hr/>"+"</td>"+"<td>"+"<hr/>"+"</td>"+"</tr>"+
				
			
				"<tr> <td ><strong style='font-size:16px;text-align:leftt'> Total Fare: NGN "+ totalAmount +"</strong></td> </tr> </table>"+"<hr/>"+
				"<p><font color=blue>Ticket cancellation Policies</font></p>" +
				"<li>Within 24hrs from the station departure time:40% deduction.</li>" +
				"<li>Between 1 to 3 days before station departure time:30% deduction.</li>" +
				"<li>Between 3 to 7 days before station departure time:20% deduction.</li>" +
				"<li>Between 7 to 30 days before station departure time:10% deduction.</li>" +
				"</body>"+"</html>" );
	}
	catch(Exception e){
		System.out.println("Error in PassengerBusTransformationFunctions:-getEmailTemplate method"+e.toString());
	}
	return body.toString();
}

public String getEmailTemplate1( String weekday1,String weekday2,String passangerNames,String totalSeats,String vehiclemodel1,String vehiclemodel2,String reportingtime1,String reportingtime2,String name,String phoneNo,String emailId,String Ticketno,String seatNo1,String seatNo2,String journeyDate1,String departureTime1,String seatingStructure1,String source1,int totalAmount1,String boardingOn1,String destination1,String terminalname1,String journeyDate2,String departureTime2,String seatingStructure2,String source2,int totalAmount2,String boardingOn2,String destination2,String terminalname2,String transaction,int customerID,int systemID){
	
	StringBuilder body = new StringBuilder();
    String seat=seatNo1.replaceFirst(",", "");
    String seat1=seatNo2.replaceFirst(",", "");
    int totalAmount = totalAmount1+totalAmount2;
	try{
		body.append( "<html>"+"<head>"+"<style>"+"body {font-family: arial, Arial, Helvetica, sans-serif; font-size: 12px}"+
				"body {"+"height: 297mm;"+"width: 210mm;"+"}"+
				"dt { float: left; clear: left; text-align: left; font-weight: bold; margin-right: 10px }"+ 
				"dd {  padding: 0 0 0.5em 0; }"+
				"</style> "+"<style type='text/css' media='print'> "+"</style>"+   
				"</head>"+"<body>"+"<table cellspacing='0' >"+"<tr>"+"<td>"+"<table  cellspacing='0'>"+"<tr>"+
				"<td style='width:300px';><strong style='font-size:30px';><img src='http://www.telematics4u.in/ApplicationImages/CustomerLogos/custlogo_"+systemID+"_"+customerID+".gif' alt='ysg' style='width:50%'></td>"+		
				"<td>eTICKET</td>"+"</tr>"+"</table>"+"</td>"+		
				"<td style='text-align:right;padding-left:240px';>Need help with your trip?<br></br>"+"01-4531091, 08170765674<br />"+
				"info@ysgtransport.com <br/> customercare@ysgtransport.com<br />"+"</td>"+
				"</tr>"+"</table>"+"<hr/>"+
				
				"<table  cellspacing='0' >"+
				"<tr>" +
				"<td style= 'width:400px' >Onward Journey:<br /></td>" +
				"<td style='width:150px' ></td>"+
				"<td style='width:150px' ></td>"+
				"<td style='width:200px' ></td>"+
				"</tr>"+
				"<tr>" +				
				"<td  style= 'width:400px'><strong>"+ source1 + " TO " + destination1+ " </strong></td>"+
			    "<td style= 'width:150px;text-align:center'><strong>"+weekday1+"</strong></td> "+
				"<td style='width:150px'><strong>" + journeyDate1 + "</strong></td>"+
										
				"<td style='text-align:right;width:200px' ><strong> Ticket No: " + Ticketno +"</strong><br />"+
				" Transaction No: "+ transaction +"<br />"+
				"</td>"+"</tr>"+
				
				"<tr><td><hr/></td><td><hr/></td><td><hr/></td><td><hr/></td></tr>"+
				
				"<tr>"+"<td style='width:400px'>"+"Vehicle Model<br />"+"<strong>"+ vehiclemodel1 +" - "+ seatingStructure1 +"</strong>"+"</td>"+
				"<td style='width:150px'>"+"Reporting Time<br />"+"<strong>"+ reportingtime1 +"</strong>"+"</td>"+"<td style='width:150px'>"+"Departure Time<br />"+
				"<strong>"+ departureTime1 +"</strong>"+"</td>"+"<td style='width:200px;text-align:right'>"+"No. Of Seats Booked<br />"+"<strong>"+totalSeats+"</strong>"+
				"</td>"+"</tr>"+
				
				"<tr><td><hr/></td><td><hr/></td><td><hr/></td><td><hr/></td></tr>"+	
				
				"<tr>"+
				"<td style='width:400px' >"+"Terminal Name:<br />"+
				"<strong>"+ terminalname1 +"</strong>"+"</td>"+	
				"<td style='width:150px' ></td>"+
				"<td style='width:150px' ></td>"+
				"<td style='width:200px;text-align:right'>"+
				"Booked Seats:<br/><strong>"+seat+"</strong></td>"+"</tr>"+
				
				"<tr><td><hr/></td><td><hr/></td><td><hr/></td><td><hr/></td></tr>"+	
				
				"<tr>" +
				"<td style= 'width:400px' >Return Journey:<br /></td>" +
				"<td style='width:150px' ></td>"+
				"<td style='width:150px' ></td>"+
				"<td style='width:200px' ></td>"+
				"</tr>"+
				"<tr>" +
				"<td style= 'width:400px' ><br /></td>" +
				"<td style='width:150px' ></td>"+
				"<td style='width:150px' ></td>"+
				"<td style='width:200px' ></td>"+
				"</tr>"+
				"<tr>" +
				"<td  style= 'width:400px'><strong>"+ source2 + " TO " + destination2+ " </strong></td>"+
			    "<td style= 'width:150px;text-align:center' ><strong>"+weekday2+"</strong></td> "+
				"<td style='width:150px'><strong>" + journeyDate2 + "</strong></td>"+
										
				"<td style='text-align:right;width:200px' ></td>"+"</tr>"+
				
				"<tr><td><hr/></td><td><hr/></td><td><hr/></td><td><hr/></td></tr>"+
				
				"<tr>"+"<td style='width:400px'>"+"Vehicle Model<br />"+"<strong>"+ vehiclemodel2 +" - "+ seatingStructure2 +"</strong>"+"</td>"+
				"<td style='width:150px'>"+"Reporting Time<br />"+"<strong>"+ reportingtime2 +"</strong>"+"</td>"+"<td style='width:150px'>"+"Departure Time<br />"+
				"<strong>"+ departureTime2 +"</strong>"+"</td>"+"<td style='width:200px;text-align:right'>"+"No. Of Seats Booked<br />"+"<strong>"+totalSeats+"</strong>"+
				"</td>"+"</tr> "+
				
				"<tr><td><hr/></td><td><hr/></td><td><hr/></td><td><hr/></td></tr>"+
				
				"<tr><td style='width:400px' >Terminal Name:<br />"+
				"<strong>"+ terminalname2 +"</strong>"+"</td>"+	
				"<td  style='width:150px' ></td>"+
				"<td  style='width:150px' ></td>"+
				"<td style='width:200px;text-align:right'>Booked Seats:<br /><strong>"+seat1+"</strong></td>"+"</tr>"+
				
				"<tr><td><hr/></td><td><hr/></td><td><hr/></td><td><hr/></td></tr>"+
			
				
				"<tr>"+"<td style='width:250px'>"+
				"Passengers Details:</td>"+			
				"<td style='width:250px'>"+passangerNames+"</td>"+
				"<td style='width:250px'>"+"Contact Details:<br><br>"+"</td>"+"<td style='width:250px;text-align:right'>"+
				"Phone:"+" "+phoneNo+"<br></br>"+
				"Email:"+" "+emailId+"<br></br>"+"</td>"+"</tr>"+
				"<tr><td><hr/></td><td><hr/></td><td><hr/></td><td><hr/></td></tr>"+
				
				"<tr >" +						
				"<td style='width:250px;text-align:left'>Onward Fare: NGN "+ totalAmount1 +"  <br/>"+
				"Return Fare: NGN "+ totalAmount2 +"<br/><strong> Total Fare: NGN "+ totalAmount +"</strong></td> " +
				"<td  style='width:250px' ></td>"+
				"<td  style='width:250px' ></td>"+
				"<td  style='width:250px' ></td>"+	
				"</tr> </table>"+"<hr/>"+
				
				"<p><font color=blue>Ticket cancellation Policies</font></p>" +
				"<li>Within 24hrs from the station departure time:40% deduction.</li>" +
				" <li>Between 1 to 3 days before station departure time:30% deduction.</li>" +
				" <li>Between 3 to 7 days before station departure time:20% deduction.</li>" +
				"<li>Between 7 to 30 days before station departure time:10% deduction.</li>" +
				"</body>"+"</html>" );

	}
	catch(Exception e){
		System.out.println("Error in PassengerBusTransformationFunctions:-getEmailTemplate method"+e.toString());
	}
	return body.toString();
}

public String UpdateTransactionStatus(String status,String transaction){
	PreparedStatement pstmt = null;
	Connection con = null;
	ResultSet rs = null;
	String response="";
	String responseCode="";
	try {
    	con = DBConnection.getConnectionToDB("AMS");
	    pstmt = con.prepareStatement(PassengerBusTransportationStatements.UPDATE_TRANSACTION_STATUS);
	    pstmt.setString(1, status);
	    pstmt.setString(2,transaction);
	    pstmt.executeUpdate();
	    pstmt = con.prepareStatement(PassengerBusTransportationStatements.GET_RESPONSE_DESCRIPTION);
		pstmt.setString(1, transaction);
		rs=pstmt.executeQuery();
		if(rs.next())
		{
			response=rs.getString("RESPONSE_DESCRIPTION");
			responseCode=rs.getString("RESPONSE_CODE");
		}
	}
	   catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt,rs);
		}
		return response+"|"+responseCode;
}




//************************************************* payment pass ******************************************************** 

public HashMap<String,String> gettempdetails(String tempid1,String tempid2,String roundtrip)
{
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	Connection connection = null;
	HashMap<String,String> tempCompMap = new HashMap<String,String>();
	String seatNo = "";	    
	String rateId1 = "";
	String serviceId1 = "";
	String journeydate1 = "";
	String dedicatedSeatnumbers1 = "";
	String terminalid1 = "";
	String rateId2 = "";
	String serviceId2 = "";
	String journeydate2 = "";
	String dedicatedSeatnumbers2 = "";
	String terminalid2 = "";
	try
	{
		
		//journeydate2 = "15/07/2015";
		//dedicatedSeatnumbers2 = "20" + ":" + "21" +":"+ "22"+ ":" + "23";
		connection = DBConnection.getConnectionToDB("AMS");
	
		pstmt = connection.prepareStatement(PassengerBusTransportationStatements.GET_DETAILS_FROM_TEMP_TABLE);
		pstmt.setString(1, tempid1);							
		rs = pstmt.executeQuery();
		if(rs.next()){
			 seatNo = rs.getString("TOTAL_SEAT_SELECTED");	    
			 rateId1 = rs.getString("RATE_ID");	
			 serviceId1 =rs.getString("SERVICE_ID");	
			 journeydate1 = rs.getString("JOURNEY_DATE");	
			 dedicatedSeatnumbers1 = rs.getString("SELECTED_SEATS");
			 dedicatedSeatnumbers1 = dedicatedSeatnumbers1.replace(",", ":");
			 terminalid1 = rs.getString("TERMINAL_ID");			
		}
	if(Integer.parseInt(roundtrip) == 1){
		pstmt = connection.prepareStatement(PassengerBusTransportationStatements.GET_DETAILS_FROM_TEMP_TABLE);
		pstmt.setString(1, tempid2);							
		rs = pstmt.executeQuery();
		if(rs.next()){
	    
			 rateId2 = rs.getString("RATE_ID");	
			 serviceId2= rs.getString("SERVICE_ID");	
			 journeydate2 = rs.getString("JOURNEY_DATE");	
			 dedicatedSeatnumbers2 = rs.getString("SELECTED_SEATS");	
			 dedicatedSeatnumbers2 = dedicatedSeatnumbers2.replace(",", ":");
			 terminalid2 =rs.getString("TERMINAL_ID");				
		}	
		
	}
		tempCompMap.put("seatNo",seatNo);
		tempCompMap.put("rateId1",rateId1);
		tempCompMap.put("serviceId1",serviceId1);
		tempCompMap.put("journeydate1",journeydate1);
		tempCompMap.put("dedicatedSeatnumbers1",dedicatedSeatnumbers1);
		tempCompMap.put("terminalid1",terminalid1);
		tempCompMap.put("rateId2",rateId2);
		tempCompMap.put("serviceId2",serviceId2);
		tempCompMap.put("journeydate2",journeydate2);
		tempCompMap.put("dedicatedSeatnumbers2",dedicatedSeatnumbers2);
		tempCompMap.put("terminalid2",terminalid2);
		
	}
	catch(Exception e)
	{
	e.printStackTrace();	
	} finally {
		DBConnection.releaseConnectionToDB(connection, pstmt, rs);
	}
	return (HashMap<String,String>) tempCompMap;
}


public HashMap<String,String> getPassengerComponents(int seatNo)
{
	StringBuilder verticalComponents=new StringBuilder();	
	
	HashMap<String,String> verticalCompMap = new HashMap<String,String>();
	try
	{
			verticalComponents.append(
				"<div >"+ 
				"<label for='usr' class= 'textcolor' ><span class = 'required' >*</span>Name:</label>"+ 
				"<input id = 'passangername0' type='text' onchange='Call(this)' onkeypress='return onlyAlphabets(event,this)' class ='nameboxsize' value = '' placeholder = 'Enter Passanger Name' ></input>"+
				"<label for='usr' class= 'textcolor'><span class = 'required' >*</span>Gender:</label>"+ 						
				"<input type='radio' id='mradio0' name='gender0' value='male0' checked='checked' width:15px;height:15px ><label class = 'genderadiosize' >M </label> </input>" +
				"<input type='radio'  id='fradio0' name='gender0' value='female0' width:15px;height:15px ><label class = 'genderadiosize' >F </label> </input>"+			
				"<label for='usr' class= 'textcolor'><span class = 'required' >*</span>Age:</label>"+ 
				"<input id = 'age0' type='text' onchange='Call(this)' onkeypress='return isNumber(event)' class= 'ageboxsize' placeholder = 'Enter Age' ></input>"+ 
					
				"</div>"
				);
		
		
		
		for(int i = 1 ; i<seatNo ;i++){
			verticalComponents.append("<div >"+ 
					"<label for='usr' class= 'textcolor'><span class = 'required' >*</span>Name:</label>"+ 
					"<input id = 'passangername"+i+"'  type='text' onchange='Call(this)' onkeypress='return onlyAlphabets(event,this)' class ='nameboxsize' value = '' placeholder = 'Enter Passanger Name'></input>"+
					"<label for='usr' class= 'textcolor'><span class = 'required' >*</span>Gender:</label>"+
					"<input type='radio' id='mradio"+i+"' name='gender"+i+"' value='male"+i+"' checked='checked' width:15px;height:15px ><label class = 'genderadiosize' >M </label> </input>" +
					"<input type='radio'  id='fradio"+i+"' name='gender"+i+"' value='female"+i+"' width:15px;height:15px ><label class = 'genderadiosize' >F </label> </input>"+									
					"<label for='usr' class= 'textcolor'><span class = 'required' >*</span>Age:</label>"+ 
					"<input id = 'age"+i+"' type='text' onchange='Call(this)' onkeypress='return isNumber(event)' class= 'ageboxsize' placeholder = 'Enter Age' ></input>"+ 
					
					"</div>"
					);
		}
		
		verticalComponents.append("<div>"+ 
		"<label for='usr' class= 'phonecolor'><span class = 'required' >*</span>Phone:</label> "+
		"<select id='countrycode' class = 'countrycodesize'>"+
		"<option value='234'>+234</option>"+
		"</select>"+
		"<input id = 'Phone' type='text' onchange='Call(this)' onkeypress='return isNumber(event)' class ='phoneboxsize' value = '' placeholder='Enter Phone Number' ></input>"+
		"<label for='usr' class= 'textcolor' ><span class = 'required' >*</span>Email Id:</label> "+
		" <input id = 'Email' type='text' onchange='Call(this)' class ='emailboxsize'  placeholder='Enter Valid Email' ></input> "+
		"</div>"
		);
		
			verticalCompMap.put("verticalComponents",verticalComponents.toString());
		
	}
	catch(Exception e)
	{
	e.printStackTrace();	
	} finally {
		DBConnection.releaseConnectionToDB(null, null, null);
	}
	return (HashMap<String,String>) verticalCompMap;
}
public HashMap<String,String> getJourneyComponents(int serviceId,int rateId,int seatNo,String dedicatedSeatnumbers,String journeydate,int terminalid1,int systemId,int customerId)
{
	StringBuilder journeyDetailsCompnt=new StringBuilder();
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	Connection connection = null;
	HashMap<String,String> journeyCompMap = new HashMap<String,String>();	
	String terminalName = "";
	String vehicleModel = "";
	String serviceNo = "";
	String from="";
	String to="";
	String routeName = "";
	String departuretime = "";
	String arrivalTime = "";
	String duration = "";
	String distance = "";
	double amount = 0.0;
	DecimalFormat df = new DecimalFormat("##.##");
	dedicatedSeatnumbers = dedicatedSeatnumbers.replace(":", ",");
	try
	{
		connection = DBConnection.getConnectionToDB("AMS");
		pstmt = connection.prepareStatement(PassengerBusTransportationStatements.GET_DETAILS_FOR_PAYMENTS);
		pstmt.setInt(1, rateId);
		pstmt.setInt(2, serviceId);
		pstmt.setInt(3, terminalid1);
		pstmt.setInt(4, systemId);
		pstmt.setInt(5, customerId);
			
		rs = pstmt.executeQuery();
		if(rs.next()){
			from = rs.getString("SOURCE");
			to =  rs.getString("DESTINATION");
			routeName = rs.getString("ROUTE_NAME");
			distance = df.format(rs.getDouble("DISTANCE"));
			departuretime = rs.getString("DEPARTURE_TIME");
			if(departuretime.charAt(2)!='.'){
				departuretime = "0"+departuretime;
			}
			if(departuretime.length()<5){
				departuretime = departuretime+"0";
			}
			departuretime = departuretime.replace('.', ':');
			String departuretimeFormat = departuretime.substring(0,departuretime.indexOf(":"));
			departuretime = getTimeFormat(Integer.parseInt(departuretimeFormat),departuretime);
			arrivalTime = rs.getString("ARRIVAL_TIME");
			if(arrivalTime.charAt(2)!='.'){
				arrivalTime = "0"+arrivalTime;
			}
			if(arrivalTime.length()<5){
				arrivalTime = arrivalTime+"0";
			}
			arrivalTime = arrivalTime.replace('.', ':');
			String departuretimeFormat1 = arrivalTime.substring(0,arrivalTime.indexOf(":"));
			arrivalTime = getTimeFormat(Integer.parseInt(departuretimeFormat1),arrivalTime);
			duration = df.format(rs.getDouble("DURATION"));
			if(duration.length()<3) {
				duration = duration+".00";
			}
			if(duration.charAt(2)!='.'){
				duration = "0"+duration;
			}
			if(duration.length()<5) {
				duration=duration + "0";
			}			
			vehicleModel =  rs.getString("MODEL_NAME");				
			serviceNo = rs.getString("SERVICE_NAME");
			terminalName = rs.getString("TERMINAL_NAME");
			amount = rs.getDouble("AMOUNT");
		}
		
		double totalamount = amount*seatNo;
		
		Long L = Math.round(totalamount);
		int grandtot = Integer.valueOf(L.intValue());
		
		journeyDetailsCompnt.append(
                "<ul ><li id = 'from' class= 'textcolors' for='usr'>From : "+from+" </li>");
		journeyDetailsCompnt.append(
                "<li id = 'to' class= 'textcolors' for='usr'>To : "+to+" </li>");
		journeyDetailsCompnt.append(
                "<li id = 'routeName' class= 'textcolors' for='usr'>Route Name : "+routeName+" </li>");			
		journeyDetailsCompnt.append(
                "<li id = 'journey_date' class= 'textcolors' for='usr'>Journey Date : "+journeydate+" </li>");			
		journeyDetailsCompnt.append(
                "<li id = 'diatance' class= 'textcolors' for='usr'>Distance : "+distance+" </li>");
		
		journeyDetailsCompnt.append(
                "<li id = 'departuretime' class= 'textcolors' for='usr'>Departure Time : "+departuretime+" </li>");
		journeyDetailsCompnt.append(
                "<li id = 'arrivalTime' class= 'textcolors' for='usr'>Arrival Time : "+arrivalTime+" </li>");
		journeyDetailsCompnt.append(
                "<li id = 'duration' class= 'textcolors' for='usr'>Duration : "+duration+" </li>");			
		journeyDetailsCompnt.append(
                "<li id = 'service_no' for='usr' class= 'textcolors'>Service No : "+serviceNo+" </li>");
		journeyDetailsCompnt.append(
                "<li id = 'vehicle_model' for='usr' class= 'textcolors'>Vehicle Model : "+vehicleModel+" </li>");
		journeyDetailsCompnt.append(
				                   "<li id = 'terminal_name' for='usr' class= 'textcolors'>Terminal Name : "+terminalName+" </li>");
	
		journeyDetailsCompnt.append(
                "<li id = 'dedicatedSeatNos' for='usr' class= 'textcolors'>Seat Numbers : "+dedicatedSeatnumbers+" </li></ul>");
     
		journeyDetailsCompnt.append("<br></br>");
	
		journeyCompMap.put("journeyDetailsCompnts",journeyDetailsCompnt.toString());
		journeyCompMap.put("totalamount",String.valueOf(grandtot));
	}
	catch(Exception e)
	{
	e.printStackTrace();	
	} finally {
		DBConnection.releaseConnectionToDB(connection, pstmt, rs);
	}
	return (HashMap<String,String>) journeyCompMap;
}

public HashMap<String,String> getJourneyComponentsForRoundTrip(int seatNo,int serviceId1,int rateId1,String dedicatedSeatnumbers1,String journeydate1,int serviceId2,int rateId2,String dedicatedSeatnumbers2,String journeydate2,int terminalid1, int terminalid2,int systemId,int customerId)
{
	StringBuilder journeyDetailsCompnt=new StringBuilder();
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	Connection connection = null;
	HashMap<String,String> journeyCompMap = new HashMap<String,String>();
	String terminalName = "";
	String vehicleModel = "";
	String serviceNo = "";
	String from="";
	String to="";
	String routeName = "";
	String departuretime = "";
	String arrivalTime = "";
	String duration = "";
	String distance = "";
	double amount = 0.0;	
	double grandtotalamount = 0.0;
	String from2 = "";
	String to2 =  "";
	String routeName2 = "";
	String distance2 = "";
	String departuretime2 = "";
	String arrivalTime2 = "";
	String duration2 = "";
	String vehicleModel2 = "";				
	String serviceNo2 = "";
	String terminalName2 ="";
	double amount2 = 0.0;
	DecimalFormat df = new DecimalFormat("##.##");
	dedicatedSeatnumbers1 = dedicatedSeatnumbers1.replace(":", ",");
	dedicatedSeatnumbers2 = dedicatedSeatnumbers2.replace(":", ",");
	try
	{
		connection = DBConnection.getConnectionToDB("AMS");
		pstmt = connection.prepareStatement(PassengerBusTransportationStatements.GET_DETAILS_FOR_PAYMENTS);
		pstmt.setInt(1, rateId1);
		pstmt.setInt(2, serviceId1);
		pstmt.setInt(3, terminalid1);
		pstmt.setInt(4, systemId);
		pstmt.setInt(5, customerId);
			
		rs = pstmt.executeQuery();
		if(rs.next()){
			from = rs.getString("SOURCE");
			to =  rs.getString("DESTINATION");
			routeName = rs.getString("ROUTE_NAME");
			distance = df.format(rs.getDouble("DISTANCE"));
			departuretime = rs.getString("DEPARTURE_TIME");
			if(departuretime.charAt(2)!='.'){
				departuretime = "0"+departuretime;
			}
			if(departuretime.length()<5){
				departuretime = departuretime+"0";
			}
			departuretime = departuretime.replace('.', ':');
			String departuretimeFormat = departuretime.substring(0,departuretime.indexOf(":"));
			departuretime = getTimeFormat(Integer.parseInt(departuretimeFormat),departuretime);
			arrivalTime = rs.getString("ARRIVAL_TIME");
			if(arrivalTime.charAt(2)!='.'){
				arrivalTime = "0"+arrivalTime;
			}
			if(arrivalTime.length()<5){
				arrivalTime = arrivalTime+"0";
			}
			arrivalTime = arrivalTime.replace('.', ':');
			String departuretimeFormat1 = arrivalTime.substring(0,arrivalTime.indexOf(":"));
			arrivalTime = getTimeFormat(Integer.parseInt(departuretimeFormat1),arrivalTime);
			duration = df.format(rs.getDouble("DURATION"));
			if(duration.length()<3) {
				duration = duration+".00";
			}
			if(duration.charAt(2)!='.'){
				duration = "0"+duration;
			}
			if(duration.length()<5) {
				duration=duration + "0";
			}			
			vehicleModel =  rs.getString("MODEL_NAME");				
			serviceNo = rs.getString("SERVICE_NAME");
			terminalName = rs.getString("TERMINAL_NAME");
			amount = rs.getDouble("AMOUNT");
		}
		
		double totalamount1 = amount*seatNo;
		
		Long L = Math.round(totalamount1);
		int grandtot1 = Integer.valueOf(L.intValue());
		
		journeyDetailsCompnt.append(
                "<label id = 'onwardjourney' class= 'onwardAndBackwardJoudetails' for='usr'>Onward Joureney Details </label><br></br>");
		journeyDetailsCompnt.append(
                "<ul ><li id = 'from' class= 'textcolors' for='usr'>From : "+from+" </li>");
		journeyDetailsCompnt.append(
                "<li id = 'to' class= 'textcolors' for='usr'>To : "+to+" </li>");
		journeyDetailsCompnt.append(
                "<li id = 'routeName' class= 'textcolors' for='usr'>Route Name : "+routeName+" </li>");			
		journeyDetailsCompnt.append(
                "<li id = 'journey_date' class= 'textcolors' for='usr'>Journey Date : "+journeydate1+" </li>");			
		journeyDetailsCompnt.append(
                "<li id = 'diatance' class= 'textcolors' for='usr'>Distance : "+distance+" </li>");
		
		journeyDetailsCompnt.append(
                "<li id = 'departuretime' class= 'textcolors' for='usr'>Departure Time : "+departuretime+" </li>");
		journeyDetailsCompnt.append(
                "<li id = 'arrivalTime' class= 'textcolors' for='usr'>Arrival Time : "+arrivalTime+" </li>");
		journeyDetailsCompnt.append(
                "<li id = 'duration' class= 'textcolors' for='usr'>Duration : "+duration+" </li>");			
		journeyDetailsCompnt.append(
                "<li id = 'service_no' for='usr' class= 'textcolors'>Service No : "+serviceNo+" </li>");
		journeyDetailsCompnt.append(
                "<li id = 'vehicle_model' for='usr' class= 'textcolors'>Vehicle Model : "+vehicleModel+" </li>");
		journeyDetailsCompnt.append(
				                   "<li id = 'terminal_name' for='usr' class= 'textcolors'>Terminal Name : "+terminalName+" </li>");
	
		journeyDetailsCompnt.append(
                "<li id = 'dedicatedSeatNos' for='usr' class= 'textcolors'>Seat Numbers : "+dedicatedSeatnumbers1+" </li>");
     
		journeyDetailsCompnt.append(
                "<li id = 'dedicatedSeatNos' for='usr' class= 'textcolors'>Onward Fare : "+grandtot1+" </li></ul>");
  

		pstmt = connection.prepareStatement(PassengerBusTransportationStatements.GET_DETAILS_FOR_PAYMENTS);
		pstmt.setInt(1, rateId2);
		pstmt.setInt(2, serviceId2);
		pstmt.setInt(3, terminalid2);
		pstmt.setInt(4, systemId);
		pstmt.setInt(5, customerId);
			
		rs = pstmt.executeQuery();
		if(rs.next()){
			from2 = rs.getString("SOURCE");
			to2 =  rs.getString("DESTINATION");
			routeName2 = rs.getString("ROUTE_NAME");
			distance2 = df.format(rs.getDouble("DISTANCE"));
			departuretime2 = rs.getString("DEPARTURE_TIME");
			if(departuretime2.charAt(2)!='.'){
				departuretime2 = "0"+departuretime2;
			}
			if(departuretime2.length()<5){
				departuretime2 = departuretime2+"0";
			}
			departuretime2 = departuretime2.replace('.', ':');
			String departuretimeFormat = departuretime2.substring(0,departuretime2.indexOf(":"));
			departuretime2 = getTimeFormat(Integer.parseInt(departuretimeFormat),departuretime2);
			arrivalTime2 = rs.getString("ARRIVAL_TIME");
			if(arrivalTime2.charAt(2)!='.'){
				arrivalTime2 = "0"+arrivalTime2;
			}
			if(arrivalTime2.length()<5){
				arrivalTime2 = arrivalTime2+"0";
			}
			arrivalTime2 = arrivalTime2.replace('.', ':');
			String departuretimeFormat1 = arrivalTime2.substring(0,arrivalTime2.indexOf(":"));
			arrivalTime2 = getTimeFormat(Integer.parseInt(departuretimeFormat1),arrivalTime2);
			duration2 = df.format(rs.getDouble("DURATION"));
			if(duration2.length()<3) {
				duration2 = duration2+".00";
			}
			if(duration2.charAt(2)!='.'){
				duration2 = "0"+duration2;
			}
			if(duration2.length()<5) {
				duration2=duration2 + "0";
			}
			duration = duration.replace('.', ':');
			vehicleModel2 =  rs.getString("MODEL_NAME");				
			serviceNo2 = rs.getString("SERVICE_NAME");
			terminalName2 = rs.getString("TERMINAL_NAME");
			amount2 = rs.getDouble("AMOUNT");
		}
		
		double totalamount2 = amount2*seatNo;
		
		Long L2 = Math.round(totalamount2);
		int grandtot2 = Integer.valueOf(L2.intValue());
		
		journeyDetailsCompnt.append("<br></br>"+
                "<label id = 'backwardjourney' class= 'onwardAndBackwardJoudetails' for='usr'>Onward Joureney Details </label><br></br>");
		journeyDetailsCompnt.append(
                "<ul ><li id = 'from' class= 'textcolors' for='usr'>From : "+from2+" </li>");
		journeyDetailsCompnt.append(
                "<li id = 'to' class= 'textcolors' for='usr'>To : "+to2+" </li>");
		journeyDetailsCompnt.append(
                "<li id = 'routeName' class= 'textcolors' for='usr'>Route Name : "+routeName2+" </li>");			
		journeyDetailsCompnt.append(
                "<li id = 'journey_date' class= 'textcolors' for='usr'>Journey Date : "+journeydate2+" </li>");			
		journeyDetailsCompnt.append(
                "<li id = 'diatance' class= 'textcolors' for='usr'>Distance : "+distance2+" </li>");
		
		journeyDetailsCompnt.append(
                "<li id = 'departuretime' class= 'textcolors' for='usr'>Departure Time : "+departuretime2+" </li>");
		journeyDetailsCompnt.append(
                "<li id = 'arrivalTime' class= 'textcolors' for='usr'>Arrival Time : "+arrivalTime2+" </li>");
		journeyDetailsCompnt.append(
                "<li id = 'duration' class= 'textcolors' for='usr'>Duration : "+duration2+" </li>");			
		journeyDetailsCompnt.append(
                "<li id = 'service_no' for='usr' class= 'textcolors'>Service No : "+serviceNo2+" </li>");
		journeyDetailsCompnt.append(
                "<li id = 'vehicle_model' for='usr' class= 'textcolors'>Vehicle Model : "+vehicleModel2+" </li>");
		journeyDetailsCompnt.append(
				                   "<li id = 'terminal_name' for='usr' class= 'textcolors'>Terminal Name : "+terminalName2+" </li>");
	
		journeyDetailsCompnt.append(
                "<li id = 'dedicatedSeatNos' for='usr' class= 'textcolors'>Seat Numbers : "+dedicatedSeatnumbers2+" </li>");
     
		journeyDetailsCompnt.append(
                "<li id = 'dedicatedSeatNos' for='usr' class= 'textcolors'>Return Fare : "+grandtot2+" </li></ul><br></br>");
  

		grandtotalamount = totalamount1+totalamount2;
		
		Long L3 = Math.round(grandtotalamount);
		int grandtot = Integer.valueOf(L3.intValue());
		
		journeyCompMap.put("journeyDetailsCompnts",journeyDetailsCompnt.toString());
		journeyCompMap.put("totalamount",String.valueOf(grandtot));
	}
	catch(Exception e)
	{
	e.printStackTrace();	
	} finally {
		DBConnection.releaseConnectionToDB(connection, pstmt, rs);
	}
	return (HashMap<String,String>) journeyCompMap;
}
	

public String checkCouponCodeValidity(String couponcode,String couponferid,int totalAmount,String coupongenmode){
String message = "";
Connection con = null;	   
PreparedStatement pstmt = null;
ResultSet rs = null;
try {
con = DBConnection.getConnectionToDB("AMS");	
if(coupongenmode.equals("prepaidcard")){
pstmt = con.prepareStatement(PassengerBusTransportationStatements.CHECK_COUPON_CODE_FOR_PRE_PAID_CARD);		            
pstmt.setString(1, couponferid); 
pstmt.setString(2, couponcode);
}else if(coupongenmode.equals("canceloropenticket")){
	pstmt = con.prepareStatement(PassengerBusTransportationStatements.CHECK_COUPON_CODE);		            
	pstmt.setString(1, couponferid); 
	pstmt.setString(2, couponcode);
}
rs = pstmt.executeQuery();
if(rs.next()){
	double totalamountInCoupon = rs.getDouble("PENDING_AMOUNT");
	Long L = Math.round(totalamountInCoupon);
	int totalamountinCoupon = Integer.valueOf(L.intValue());
	
	if(totalamountInCoupon >= totalAmount ){    		
	message = "Valid";
	}else if(totalamountInCoupon < totalAmount){
	int	remainingamountneedtopay = totalAmount-totalamountinCoupon; 
	int deductedamount = totalAmount - remainingamountneedtopay;
	message = "Valid #"+remainingamountneedtopay+"#"+deductedamount;
	}
}else{
	message = "Not Valid";
}

}catch (Exception e) {	    	
e.printStackTrace();
}
finally {
DBConnection.releaseConnectionToDB(con, pstmt, rs);        
}
return message;
} 



public synchronized String BookingTheTicketFunction(int tempid1, String  isCouponAmountSufficient,String couponcode, String couponferid, int  systemId, int  customerId, String  serviceId, String  rateId, int  seatNo, String  dedicatedSeatnumbers, String  paymentmode, String  phoneEmailDetails, String  PassangerDetails, double  totalAmount,String journeydate, String roundtrip ,int terminalId,int userId ){
String message = "";
Connection con = null;	   
PreparedStatement pstmt = null;
ResultSet rs = null;
String inserted = "";
String transaction_id = "";
String ticketNo = "";
transaction_id = getTransactionId();
transaction_id = checktransactionid(transaction_id);
ticketNo = getTicketNo();
String phoneEmailDetail [] = phoneEmailDetails.split(",");
String primaryPh = phoneEmailDetail[0];
String primaryemail = phoneEmailDetail[1];
primaryemail = primaryemail.toLowerCase();
int inserted1 = 0;
if(paymentmode.equals("cashcoupon")){
	paymentmode = "prepaidcard";
}
else if(paymentmode.equals("couponcode")){
	paymentmode = "couponcode";
}
if(isCouponAmountSufficient.equalsIgnoreCase("true") ){
try {
 con = DBConnection.getConnectionToDB("AMS");	       
 String valid = checkseatNo(dedicatedSeatnumbers,con,pstmt,rs,Integer.parseInt(serviceId),journeydate);
 if(valid.equals("yes")){
 	pstmt = con.prepareStatement(PassengerBusTransportationStatements.INSERT_INTO_TRANSACTION_MASTER);
 	pstmt.setString(1, transaction_id);
 	pstmt.setString(2, ticketNo);
 	pstmt.setString(3, paymentmode);
 	pstmt.setString(4, roundtrip);
 	pstmt.setDouble(5, totalAmount);
 	pstmt.setString(6, couponcode);
 	pstmt.setInt(7, systemId);
	pstmt.setInt(8, customerId);
	pstmt.setInt(9, userId);
	pstmt.setString(10,primaryPh);
	pstmt.setString(11,primaryemail);
 	inserted1 = pstmt.executeUpdate();
 	if(inserted1>0){
 	    inserted = insertTransactionDetailsAndBookingDetails(transaction_id,ticketNo,con,pstmt,rs,Integer.parseInt(serviceId),Integer.parseInt(rateId),seatNo,paymentmode,dedicatedSeatnumbers, phoneEmailDetails,PassangerDetails, totalAmount,journeydate,systemId,customerId,roundtrip,terminalId);
 	    if(inserted.equals("yes")){
 	    	if(paymentmode.equalsIgnoreCase("prepaidcard")){
 	    	pstmt = con.prepareStatement(PassengerBusTransportationStatements.DEDUCT_THE_AMOUNT_FROM_PREPAID_CARD_MASTER);		            
 		    pstmt.setDouble(1,totalAmount);
 		    pstmt.setString(2,couponferid);
 		    pstmt.setString(3,couponcode);
 		    pstmt.executeUpdate();
 	    	}else if(paymentmode.equalsIgnoreCase("couponcode")){
 	    	pstmt = con.prepareStatement(PassengerBusTransportationStatements.DEDUCT_THE_AMOUNT_FROM_PREPAID_CARD_MASTER_FOR_COUPON_CODE);		            
 	 		pstmt.setDouble(1,totalAmount);
 	 		pstmt.setString(2,couponferid);
 	 		pstmt.setString(3,couponcode);	
 	 		pstmt.executeUpdate();
 	    	}
 			pstmt = con.prepareStatement(PassengerBusTransportationStatements.DELETE_DETAILS_FROM_TEMP_TABLE_AFTER_TRANSACTION);		            
   		    pstmt.setInt(1,tempid1);		    		   
   		    pstmt.executeUpdate();	 
 	    	    		    
 	    message = "success";	
 	     }else {
 	    	 message = "failed";
 	     }	
 	}
 }else{
		message = "booked";
	}   	     
}catch (Exception e) {	    	
 e.printStackTrace();
 }
finally {
	DBConnection.releaseConnectionToDB(con, pstmt, rs);        
}

}

message = message+"#"+transaction_id;
return message;
}


public synchronized  String BookingTheTicketFunctionFOrRoundTrip( int tempid1,int tempid2,String  isCouponAmountSufficient,String couponcode, String couponferid, int  systemId, int  customerId,  int  seatNo, String  paymentmode, String  phoneEmailDetails, String  PassangerDetails, double  totalAmount, String roundtrip, int serviceId1,int rateId1,String journeydate1, String dedicatedSeatnumbers1,int terminalId1,int serviceId2,int rateId2,String journeydate2,String dedicatedSeatnumbers2,int terminalId2, int  userId ){

String message = "";
Connection con = null;	   
PreparedStatement pstmt = null;
ResultSet rs = null;
String inserted = "";
String transaction_id = "";
String ticketNo = "";
transaction_id = getTransactionId();
transaction_id = checktransactionid(transaction_id);
ticketNo = getTicketNo();
String phoneEmailDetail [] = phoneEmailDetails.split(",");
String primaryPh = phoneEmailDetail[0];
String primaryemail = phoneEmailDetail[1];
primaryemail = primaryemail.toLowerCase();
int inserted1 = 0;
String inserteds = "";
if(paymentmode.equals("cashcoupon")){
	paymentmode = "prepaidcard";
}
else if(paymentmode.equals("couponcode")){
	paymentmode = "couponcode";
}
if(isCouponAmountSufficient.equalsIgnoreCase("true") ){
	try {
	    con = DBConnection.getConnectionToDB("AMS");	       
	    String valid = checkseatNoForRoundTrip(dedicatedSeatnumbers1,dedicatedSeatnumbers2,con,pstmt,rs,serviceId1,journeydate1,serviceId2,journeydate2);
	    if(valid.equals("yes")){
	    	pstmt = con.prepareStatement(PassengerBusTransportationStatements.INSERT_INTO_TRANSACTION_MASTER);
	    	pstmt.setString(1, transaction_id);
	    	pstmt.setString(2, ticketNo);
	    	pstmt.setString(3, paymentmode);
	    	pstmt.setString(4, roundtrip);
	    	pstmt.setDouble(5, totalAmount);
	    	pstmt.setString(6, couponcode);
	    	pstmt.setInt(7, systemId);
	    	pstmt.setInt(8, customerId);
	    	pstmt.setInt(9, userId);
	    	pstmt.setString(10,primaryPh);
	    	pstmt.setString(11,primaryemail);
	    	inserted1 = pstmt.executeUpdate();
	    	if(inserted1>0){
	    	    inserteds = insertTransactionDetailsAndBookingDetails(transaction_id,ticketNo,con,pstmt,rs,serviceId1,rateId1,seatNo,paymentmode,dedicatedSeatnumbers1, phoneEmailDetails,PassangerDetails, totalAmount,journeydate1,systemId,customerId,roundtrip,terminalId1);
	    	    if(inserteds.equals("yes")){
	    	    inserted = insertTransactionDetailsAndBookingDetails(transaction_id,ticketNo,con,pstmt,rs,serviceId2,rateId2,seatNo,paymentmode,dedicatedSeatnumbers2, phoneEmailDetails,PassangerDetails, totalAmount,journeydate2,systemId,customerId,roundtrip,terminalId2);
	    	    }
	    	    if(inserted.equals("yes")){
	    	    
	    	    	if(paymentmode.equalsIgnoreCase("prepaidcard")){
	    	 	    	pstmt = con.prepareStatement(PassengerBusTransportationStatements.DEDUCT_THE_AMOUNT_FROM_PREPAID_CARD_MASTER);		            
	    	 		    pstmt.setDouble(1,totalAmount);
	    	 		    pstmt.setString(2,couponferid);
	    	 		    pstmt.setString(3,couponcode);
	    	 		    pstmt.executeUpdate();
	    	 	    	}else if(paymentmode.equalsIgnoreCase("couponcode")){
	    	 	    	pstmt = con.prepareStatement(PassengerBusTransportationStatements.DEDUCT_THE_AMOUNT_FROM_PREPAID_CARD_MASTER_FOR_COUPON_CODE);		            
	    	 	 		pstmt.setDouble(1,totalAmount);
	    	 	 		pstmt.setString(2,couponferid);
	    	 	 		pstmt.setString(3,couponcode);	
	    	 	 		pstmt.executeUpdate();
	    	 	    	}
	    		   
	    		    pstmt = con.prepareStatement(PassengerBusTransportationStatements.DELETE_DETAILS_FROM_TEMP_TABLE_AFTER_TRANSACTION_FOR_ROUND_TRIP);		            
	    		    pstmt.setInt(1,tempid1);	
	    		    pstmt.setInt(2,tempid2);
	    		    pstmt.executeUpdate();	 
	    		    
			    	message = "success";		
	    		   
	    	     }else {
	    	    message = "failed";
	    	     }	
	    	   
	    	}
	}else{
		message = "booked";
	}
	}catch (Exception e) {	    	
	    e.printStackTrace();
	    }
	finally {
		DBConnection.releaseConnectionToDB(con, pstmt, rs);        
	}

}
	
message = message+"#"+transaction_id;
	return message;
}

public String insertTransactionDetailsAndBookingDetails(String transaction_id, String ticketNo,Connection con, PreparedStatement pstmt,ResultSet rs,int serviceId,int rateId ,int seatNo,String paymentmode,String dedicatedSeatnumbers, String phoneEmailDetails,String PassangerDetails,double totalAmount,String journeydate , int systemId, int customerId ,String roundtrip,int terminalId){

String insert = "";	
int inserted = 0;
String journeydateformat = "";
String[] journeydates = journeydate.split("-");
journeydateformat = journeydates[2]+"-"+journeydates[1]+"-"+journeydates[0];
String terminalName = "";
String routeName = "";
String source = "";
String destination = "";
String distance = "";
String duration = "";
String departureTime = "";
String arrivalTime = "";
String vehiclemodel = "";
String seatingStructure = "";
String daytype = "";
String servicename = "";
String registrationNo = "";
DecimalFormat df = new DecimalFormat("##.##");

double distancef =0.0f;
double amount = 0.0;
double ticketrate = 0.0;
try{

pstmt = con.prepareStatement(PassengerBusTransportationStatements.GET_DETAILS_FOR_PAYMENTS);
pstmt.setInt(1, rateId);
pstmt.setInt(2, serviceId);
pstmt.setInt(3, terminalId);
pstmt.setInt(4, systemId);
pstmt.setInt(5, customerId);
	
rs = pstmt.executeQuery();
if(rs.next()){
	terminalName = rs.getString("TERMINAL_NAME");
	routeName = rs.getString("ROUTE_NAME");
	source = rs.getString("SOURCE");
	destination =  rs.getString("DESTINATION");
	distance = df.format(rs.getDouble("DISTANCE"));	
	distancef=Double.parseDouble(distance);

	departureTime = rs.getString("DEPARTURE_TIME");
	if(departureTime.charAt(2)!='.'){
		departureTime = "0"+departureTime;
	}
	if(departureTime.length()<5){
		departureTime = departureTime+"0";
	}
	departureTime = departureTime.replace('.', ':');
	arrivalTime= rs.getString("ARRIVAL_TIME");
	if(arrivalTime.charAt(2)!='.'){
		arrivalTime = "0"+arrivalTime;
	}
	if(arrivalTime.length()<5){
		arrivalTime = arrivalTime+"0";
	}
	arrivalTime = arrivalTime.replace('.', ':');
	duration = df.format(rs.getFloat("DURATION"));
	if(duration.length()<3) {
		duration = duration+".00";
	}
	if(duration.charAt(2)!='.'){
		duration = "0"+duration;
	}
	if(duration.length()<5) {
		duration=duration + "0";
	}
	duration = duration.replace('.', ':');
	vehiclemodel =  rs.getString("MODEL_NAME");		
	seatingStructure = rs.getString("STRUCTURE_NAME");	
	daytype = rs.getString("DAY_TYPE");	
	servicename = rs.getString("SERVICE_NAME");
	registrationNo = "";
	amount = rs.getDouble("AMOUNT");
	ticketrate = amount;
	amount =  amount*seatNo;
}




int index = 1;
pstmt = con.prepareStatement(PassengerBusTransportationStatements.INSERT_INTO_TRANSACTION_DETAILS_TABEL );

pstmt.setString(index++, transaction_id);
pstmt.setString(index++, journeydateformat);
pstmt.setString(index++, terminalName);
pstmt.setString(index++, routeName);
pstmt.setString(index++, source);
pstmt.setString(index++, destination);
pstmt.setDouble(index++, distancef);
pstmt.setString(index++, duration);
pstmt.setString(index++, departureTime);
pstmt.setString(index++, arrivalTime);
pstmt.setString(index++, vehiclemodel);
pstmt.setString(index++, seatingStructure);
pstmt.setString(index++, daytype);
pstmt.setString(index++, servicename);
pstmt.setString(index++, registrationNo);
pstmt.setInt(index++, seatNo);
pstmt.setDouble(index++, amount);
pstmt.setInt(index++,serviceId);
pstmt.setDouble(index++, ticketrate);

inserted = pstmt.executeUpdate();
if( inserted>0 ){

String phoneEmailDetail [] = phoneEmailDetails.split(",");
String primaryPh = phoneEmailDetail[0];
String primaryemail = phoneEmailDetail[1];

String dedicatedSeatnumber [] = dedicatedSeatnumbers.split(":");

StringTokenizer st = new StringTokenizer(PassangerDetails,"|");
ArrayList<ArrayList<String>> pssd = new ArrayList<ArrayList<String>>();
while(st.hasMoreElements())
{
ArrayList<String> pss = new ArrayList<String>();	
pss.add(st.nextToken());
pssd.add(pss);

}

for(int i=0;i<pssd.size();i++){
ArrayList<String> innerlist = new ArrayList<String>();
String dedseat = dedicatedSeatnumber[i];
if ( i==0 ){	
innerlist =pssd.get(i);
innerlist.add(dedseat);
innerlist.add(primaryPh);
innerlist.add(primaryemail);
}else{
	primaryPh = "";
	primaryemail = "";
	innerlist =pssd.get(i);
	innerlist.add(dedseat);
	innerlist.add(primaryPh);
	innerlist.add(primaryemail);	
}	
insert = savePassangerDetails(transaction_id,con,pstmt,rs,innerlist,serviceId);
if(insert.equals("success")){	
insert = "yes";
}else{		
	insert = "no";	
}
}

}
}catch(Exception e){
e.printStackTrace();
}
return insert;
}


public String  savePassangerDetails(String transaction_id,Connection con, PreparedStatement pstmt,ResultSet rs,ArrayList<String> innerlist,int serviceId){
int insert = 0;
String message = "";
String passname = "";
String passAge = "";
String passgender = "M";
String priEmail = "";
String priphone = "";
String seatNo = "";


String passDetails	= innerlist.get(0);
String pass [] = passDetails.split(",");
passname =pass[0];
passAge = pass[1];
passgender = pass[2];
seatNo = innerlist.get(1);
priphone = innerlist.get(2);
priEmail = innerlist.get(3);
priEmail = priEmail.toLowerCase();

passgender = passgender.substring(0,passgender.length());
if(passgender.contains("f")){
passgender = "F";	
}else if(passgender.contains("m")){
passgender = "M";	
}


try{
pstmt = con.prepareStatement(PassengerBusTransportationStatements.INSERT_INTO_PASSANGER_DETAILS );
pstmt.setString(1,transaction_id);
pstmt.setString(2, seatNo);
pstmt.setString(3, passname);
pstmt.setString(4, passAge);
pstmt.setString(5, passgender);
pstmt.setString(6, priphone);
pstmt.setString(7, priEmail);
pstmt.setInt(8,serviceId);
insert = pstmt.executeUpdate();
if(insert > 0 ){
message = "success"	;
}
else{
message = "failed";
}
}catch(Exception e){
e.printStackTrace();

}
return message;
  }


public synchronized String BookingTheTicketFunctionUsingPaymetGateWay(int tempid,int systemId,int customerId,String  serviceId,String rateId,int seatnos,String dedicatedSeatnumbers,String paymentmode,String phoneEmailDetails,String PassangerDetails,double totalAmount,String journeydate,String roundtrip ,int terminalId,int userId,String basepath) throws Exception{
String message = "";

Connection con = null;	   
PreparedStatement pstmt = null;
ResultSet rs = null;
String inserted = "";
String transaction_id = "";
String ticketNo = "";
transaction_id = getTransactionId();
transaction_id = checktransactionid(transaction_id);
ticketNo = getTicketNo();
String phoneEmailDetail [] = phoneEmailDetails.split(",");
String primaryPh = phoneEmailDetail[0];
String primaryemail = phoneEmailDetail[1];
primaryemail = primaryemail.toLowerCase();
int inserted1 = 0;
String couponcode = "";
String hash ="";
try{
con = DBConnection.getConnectionToDB("AMS");
String valid = checkseatNo(dedicatedSeatnumbers,con,pstmt,rs,Integer.parseInt(serviceId),journeydate);
if(valid.equals("yes")){
pstmt = con.prepareStatement(PassengerBusTransportationStatements.INSERT_INTO_TRANSACTION_MASTER);
pstmt.setString(1, transaction_id);
pstmt.setString(2, ticketNo);
pstmt.setString(3, paymentmode);
pstmt.setString(4, roundtrip);
pstmt.setDouble(5, totalAmount);
pstmt.setString(6, couponcode);
pstmt.setInt(7, systemId);
pstmt.setInt(8, customerId);
pstmt.setInt(9, userId);
pstmt.setString(10,primaryPh);
pstmt.setString(11,primaryemail);
inserted1 = pstmt.executeUpdate();
if(inserted1>0){
inserted = insertTransactionDetailsAndBookingDetails(transaction_id,ticketNo,con,pstmt,rs,Integer.parseInt(serviceId),Integer.parseInt(rateId),seatnos,paymentmode,dedicatedSeatnumbers, phoneEmailDetails,PassangerDetails, totalAmount,journeydate,systemId,customerId,roundtrip,terminalId);
if(inserted.equals("yes")){	    			
message = "success";
hash = gethashvalue(transaction_id,totalAmount,basepath);
}else {
	 message = "failed";
}	
}
pstmt = con.prepareStatement(PassengerBusTransportationStatements.DELETE_DETAILS_FROM_TEMP_TABLE_AFTER_TRANSACTION);		            
pstmt.setInt(1,tempid);		    		   
pstmt.executeUpdate();
}else{
	message = "booked";
}
}catch (Exception e) {	    	
e.printStackTrace();
}
finally {
DBConnection.releaseConnectionToDB(con, pstmt, rs);        
}
message = message+"#"+transaction_id+"#"+hash;	
return message;

}


public synchronized String BookingTheTicketFunctionUsingPaymetGateWayForRoundTrip( int tempid1, int tempid2,int  systemId, int  customerId,  int  seatNo, String  paymentmode, String  phoneEmailDetails, String  PassangerDetails, double  totalAmount, String roundtrip, int serviceId1,int rateId1,String journeydate1, String dedicatedSeatnumbers1,int terminalId1,int serviceId2,int rateId2,String journeydate2,String dedicatedSeatnumbers2,int terminalId2, int userId, String basepath ) throws Exception{

String message = "";

Connection con = null;	   
PreparedStatement pstmt = null;
ResultSet rs = null;
String inserted = "";
String inserteds = "";
String transaction_id = "";
String ticketNo = "";
transaction_id = getTransactionId();
transaction_id = checktransactionid(transaction_id);
ticketNo = getTicketNo();
String phoneEmailDetail [] = phoneEmailDetails.split(",");
String primaryPh = phoneEmailDetail[0];
String primaryemail = phoneEmailDetail[1];
primaryemail = primaryemail.toLowerCase();
int inserted1 = 0;
String couponcode = "";
String hash = "";
try{

con = DBConnection.getConnectionToDB("AMS");	       
String valid = checkseatNoForRoundTrip(dedicatedSeatnumbers1,dedicatedSeatnumbers2,con,pstmt,rs,serviceId1,journeydate1,serviceId2,journeydate2);
if(valid.equals("yes")){
pstmt = con.prepareStatement(PassengerBusTransportationStatements.INSERT_INTO_TRANSACTION_MASTER);
pstmt.setString(1, transaction_id);
pstmt.setString(2, ticketNo);
pstmt.setString(3, paymentmode);
pstmt.setString(4, roundtrip);
pstmt.setDouble(5, totalAmount);
pstmt.setString(6, couponcode);
pstmt.setInt(7, systemId);
pstmt.setInt(8, customerId);
pstmt.setInt(9, userId);
pstmt.setString(10,primaryPh);
pstmt.setString(11,primaryemail);
inserted1 = pstmt.executeUpdate();
if(inserted1>0){
	inserteds = insertTransactionDetailsAndBookingDetails(transaction_id,ticketNo,con,pstmt,rs,serviceId1,rateId1,seatNo,paymentmode,dedicatedSeatnumbers1, phoneEmailDetails,PassangerDetails, totalAmount,journeydate1,systemId,customerId,roundtrip,terminalId1);
	if(inserteds.equals("yes")){	    
	inserted = insertTransactionDetailsAndBookingDetails(transaction_id,ticketNo,con,pstmt,rs,serviceId2,rateId2,seatNo,paymentmode,dedicatedSeatnumbers2, phoneEmailDetails,PassangerDetails, totalAmount,journeydate2,systemId,customerId,roundtrip,terminalId2);
	}
	if(inserted.equals("yes")){	    			
 message = "success";	
 hash = gethashvalue(transaction_id,totalAmount,basepath);
  }else {
 	 message = "failed";
  }	
}
pstmt = con.prepareStatement(PassengerBusTransportationStatements.DELETE_DETAILS_FROM_TEMP_TABLE_AFTER_TRANSACTION_FOR_ROUND_TRIP);		            
pstmt.setInt(1,tempid1);
pstmt.setInt(2,tempid2);
pstmt.executeUpdate();
}else{
	 message = "booked";	
}
}catch (Exception e) {	    	
 e.printStackTrace();
 }
finally {
	DBConnection.releaseConnectionToDB(con, pstmt, rs);        
}
message = message+"#"+transaction_id+"#"+hash;
return message;


}


public String getTransactionId() {
 
 String referenceCode="TRANYSG";
 final Random RANDOM = new SecureRandom();
 final int PASSWORD_LENGTH = 9;
 String letters = "123456789";
 String pw="";
 try {
 	for (int i=0; i<PASSWORD_LENGTH; i++)
      {
          int index = (int)(RANDOM.nextDouble()*letters.length());
          pw += letters.substring(index, index+1);
      }
 	referenceCode=referenceCode+pw;
 }catch (Exception e) {	    	
     e.printStackTrace();
     }
 return referenceCode;
}

public String getTicketNo() {
 
 String referenceCode="YSG";
 final Random RANDOM = new SecureRandom();
 final int PASSWORD_LENGTH =10;
 String letters = "123456789";
 String pw="";
 try {
 	for (int i=0; i<PASSWORD_LENGTH; i++)
      {
          int index = (int)(RANDOM.nextDouble()*letters.length());
          pw += letters.substring(index, index+1);
      }
 	referenceCode=referenceCode+pw;
 }catch (Exception e) {	    	
     e.printStackTrace();
     }
 return referenceCode;
}


public String checkseatNoForRoundTrip(String dedicatedSeatnumbers1,String dedicatedSeatnumbers2,Connection con,PreparedStatement pstmt,ResultSet rs,int serviceId1, String journeydate1,int serviceId2, String journeydate2){
	String valid = "no";
	String journeydateformat1 = "";
	String[] journeydates1 = journeydate1.split("-");
	journeydateformat1 = journeydates1[2]+"-"+journeydates1[1]+"-"+journeydates1[0];
	String journeydateformat2 = "";
	String[] journeydates2 = journeydate1.split("-");
	journeydateformat2 = journeydates2[2]+"-"+journeydates2[1]+"-"+journeydates2[0];
	dedicatedSeatnumbers1 = dedicatedSeatnumbers1.replace(":", ",");
	dedicatedSeatnumbers2 = dedicatedSeatnumbers2.replace(":", ",");
	try{
		String stmt1 = PassengerBusTransportationStatements.CHECK_SEAT_NUMBER;
     
	pstmt = con.prepareStatement(stmt1.replaceAll("#", dedicatedSeatnumbers1));		            
	pstmt.setInt(1,serviceId1);	
	pstmt.setString(2,journeydateformat1);	
	rs=pstmt.executeQuery();
	if(rs.next()){
		valid = "no";	
	}else{
		String stmt2 = PassengerBusTransportationStatements.CHECK_SEAT_NUMBER;
		
		pstmt = con.prepareStatement(stmt2.replaceAll("#", dedicatedSeatnumbers2));		            
		pstmt.setInt(1,serviceId2);	
		pstmt.setString(2,journeydateformat2);
		rs=pstmt.executeQuery();
		if(rs.next()){
			valid = "no";	
		}else{
			valid = "yes";	
		}
	}
	}catch (Exception e) {
		e.printStackTrace();
	}
	
	return valid;
}


public String checkseatNo(String dedicatedSeatnumbers1,Connection con,PreparedStatement pstmt,ResultSet rs,int serviceId1, String journeydate1){
	String valid = "no";
	String journeydateformat = "";
	String[] journeydates = journeydate1.split("-");
	journeydateformat = journeydates[2]+"-"+journeydates[1]+"-"+journeydates[0];
	dedicatedSeatnumbers1 = dedicatedSeatnumbers1.replace(":", ",");
	try{
	 String stmt = PassengerBusTransportationStatements.CHECK_SEAT_NUMBER;
	
	pstmt = con.prepareStatement(stmt.replaceAll("#", dedicatedSeatnumbers1));		            
	pstmt.setInt(1,serviceId1);	
	pstmt.setString(2,journeydateformat);
	rs=pstmt.executeQuery();
	if(rs.next()){
		valid = "no";	
	}else{		
		valid = "yes";		
	}	
	}catch (Exception e) {
		e.printStackTrace();
	}
	
	return valid;
}

public void deletetempdata(int temp1,int temp2){
	Connection con = null;	   
	PreparedStatement pstmt = null;
	try{
	con = DBConnection.getConnectionToDB("AMS");
	pstmt = con.prepareStatement(PassengerBusTransportationStatements.DELETE_DETAILS_FROM_TEMP_TABLE_AFTER_TRANSACTION_FOR_ROUND_TRIP);		            
	pstmt.setInt(1,temp1);
	pstmt.setInt(2,temp2);
	pstmt.executeUpdate();	
	}catch(Exception e){
	e.printStackTrace();	
	}finally{
	DBConnection.releaseConnectionToDB(con, pstmt, null);	
	}
}
public JSONArray getPassangerTripInfo(String tripID,String mobileNum,String emailID,int systemID,int customerID){
	Connection con = null;
	PreparedStatement pst = null;
	ResultSet rs = null;
	SimpleDateFormat ddmmyyy = new SimpleDateFormat("dd-MM-yyyy");
	SimpleDateFormat yyyymmdd = new SimpleDateFormat("yyyy-MM-dd");
	JSONArray passengerDetailsArray = new JSONArray();
	JSONObject passengerDetailsObject = new JSONObject();
	int previousServiceID=0;
	int currentServiceID=0;
	int firstLine=0;
	try{
		con = DBConnection.getConnectionToDB("AMS");			
		pst = con.prepareStatement(PassengerBusTransportationStatements.GET_TRANSACTION_DETAILS);
		pst.setString(1,tripID);
		pst.setString(2,mobileNum);
		pst.setString(3,emailID);
		pst.setInt(4, systemID);
		pst.setInt(5, customerID);
		rs = pst.executeQuery();
		while(rs.next()){	
			currentServiceID=rs.getInt("SERVICE_ID");
			if(firstLine==0){
				passengerDetailsObject = new JSONObject();
				passengerDetailsObject.put("journeydate", ddmmyyy.format(yyyymmdd.parse(rs.getString("JOURNEY_DATE"))));
				passengerDetailsObject.put("terminalname", rs.getString("TERMINAL_NAME"));
				passengerDetailsObject.put("vehiclemodel", rs.getString("VEHICLE_MODEL"));
				passengerDetailsObject.put("destination", rs.getString("DESTINATION"));
				passengerDetailsObject.put("source", rs.getString("SOURCE"));
				passengerDetailsArray.put(passengerDetailsObject);
				firstLine=1;
				previousServiceID=currentServiceID;
			}
			if(currentServiceID!=previousServiceID){
				passengerDetailsObject = new JSONObject();
				passengerDetailsObject.put("journeydate", ddmmyyy.format(yyyymmdd.parse(rs.getString("JOURNEY_DATE"))));
				passengerDetailsObject.put("terminalname", rs.getString("TERMINAL_NAME"));
				passengerDetailsObject.put("vehiclemodel", rs.getString("VEHICLE_MODEL"));
				passengerDetailsObject.put("destination", rs.getString("DESTINATION"));
				passengerDetailsObject.put("source", rs.getString("SOURCE"));
				passengerDetailsArray.put(passengerDetailsObject);
			}
			previousServiceID=currentServiceID;
		}
		
	}catch (Exception e) {
		e.printStackTrace();
	}finally{
		DBConnection.releaseConnectionToDB(con, pst, rs);
	}
	return  passengerDetailsArray;
}
public JSONObject getPassengerDetails(String transactionID){
	Connection con = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;	
	StringBuilder onwordpassengerList = new StringBuilder();
	StringBuilder returnpassengerList = new StringBuilder();
	int currentServiceID=0;
	int previousServicID=0;
	int onwordCount=0;
	int returnCount=0;
	int onwardServiceID=0;
	int returnServiceID=0;
	int isRoundTrip=0;
	JSONObject ticketObject = new JSONObject();
	try{
		con = DBConnection.getConnectionToDB("AMS");
		pstmt = con.prepareStatement(PassengerBusTransportationStatements.GET_SEATS_FROM_TRANSACTION_DETAILS);
		pstmt.setString(1,transactionID);
		rs = pstmt.executeQuery();		
		int count=1;
		int onwordFirstLine=0;
		int returnFirstLine=0;
		while(rs.next()){
			currentServiceID=rs.getInt("SERVICE_ID");
			if(rs.getString("IS_ROUND_TRIP").equals("true")){
				isRoundTrip=1;
			if(onwordFirstLine==0){
				onwordpassengerList.append("<div class='col-md-12 divBackgroundColor'><div class='col-md-2 divBackgroundColor'>" +
						"<input type='text' class='form-control' id='passenger-"+count+"' value='"+rs.getString("PASSANGER_NAME")+"' disabled/></div><div class='col-md-2 divBackgroundColor'>" +
						"<input type='text' class='form-control' id='seat-"+count+"' value='"+rs.getString("SEAT_NUMBER")+"' disabled/></div><div class='col-md-8 divBackgroundColor'>" +
						"<input type='checkbox'id='"+count+"' name='check' /><label for='"+count+"'><span></span></label><input type='hidden' class='form-control' id='service-"+count+"' value='"+currentServiceID+"'/></div></div>");
				onwordFirstLine=1;
				onwordCount++;
				onwardServiceID=currentServiceID;
			}else{
				if(currentServiceID==previousServicID){
					if(returnFirstLine!=0){
						returnpassengerList.append("<div class='col-md-12 divBackgroundColor'><div class='col-md-2 divBackgroundColor'>" +
								"<input type='text' class='form-control' id='passenger-"+count+"' value='"+rs.getString("PASSANGER_NAME")+"' disabled/></div><div class='col-md-2 divBackgroundColor'>" +
								"<input type='text' class='form-control' id='seat-"+count+"' value='"+rs.getString("SEAT_NUMBER")+"' disabled/></div><div class='col-md-8 divBackgroundColor'>" +
								"<input type='checkbox'id='"+count+"' name='check' /><label for='"+count+"'><span></span></label><input type='hidden' class='form-control' id='service-"+count+"' value='"+currentServiceID+"'/></div></div>");
						returnCount++;
					}else{
						onwordpassengerList.append("<div class='col-md-12 divBackgroundColor'><div class='col-md-2 divBackgroundColor'>" +
								"<input type='text' class='form-control' id='passenger-"+count+"' value='"+rs.getString("PASSANGER_NAME")+"' disabled/></div><div class='col-md-2 divBackgroundColor'>" +
								"<input type='text' class='form-control' id='seat-"+count+"' value='"+rs.getString("SEAT_NUMBER")+"' disabled/></div><div class='col-md-8 divBackgroundColor'>" +
								"<input type='checkbox'id='"+count+"' name='check' /><label for='"+count+"'><span></span></label><input type='hidden' class='form-control' id='service-"+count+"' value='"+currentServiceID+"'/></div></div>");
						onwordCount++;
					}
				
				}else{
					if(returnFirstLine==0){
						returnServiceID=currentServiceID;
						returnpassengerList.append("<div class='col-md-12 divBackgroundColor'><div class='col-md-2 divBackgroundColor'>" +
							"<input type='text' class='form-control' id='passenger-"+count+"' value='"+rs.getString("PASSANGER_NAME")+"' disabled/></div><div class='col-md-2 divBackgroundColor'>" +
							"<input type='text' class='form-control' id='seat-"+count+"' value='"+rs.getString("SEAT_NUMBER")+"' disabled/></div><div class='col-md-8 divBackgroundColor'>" +
							"<input type='checkbox'id='"+count+"' name='check' /><label for='"+count+"'><span></span></label><input type='hidden' class='form-control' id='service-"+count+"' value='"+currentServiceID+"'/></div></div>");
					returnFirstLine=1;
					returnCount++;
					}
				}
			}
				
			}else{
				
				if(onwordFirstLine==0){
					onwordpassengerList.append("<div class='col-md-12 divBackgroundColor'><div class='col-md-2 divBackgroundColor'>" +
							"<input type='text' class='form-control' id='passenger-"+count+"' value='"+rs.getString("PASSANGER_NAME")+"' disabled/></div><div class='col-md-2 divBackgroundColor'>" +
							"<input type='text' class='form-control' id='seat-"+count+"' value='"+rs.getString("SEAT_NUMBER")+"' disabled/></div><div class='col-md-8 divBackgroundColor'>" +
							"<input type='checkbox'id='"+count+"' name='check' /><label for='"+count+"'><span></span></label><input type='hidden' class='form-control' id='service-"+count+"' value='"+currentServiceID+"'/></div></div>");
					onwordFirstLine=1;
					onwardServiceID=currentServiceID;
				}else{
					if(currentServiceID==previousServicID){
						onwordpassengerList.append("<div class='col-md-12 divBackgroundColor'><div class='col-md-2 divBackgroundColor'>" +
							"<input type='text' class='form-control' id='passenger-"+count+"' value='"+rs.getString("PASSANGER_NAME")+"' disabled/></div><div class='col-md-2 divBackgroundColor'>" +
							"<input type='text' class='form-control' id='seat-"+count+"' value='"+rs.getString("SEAT_NUMBER")+"' disabled/></div><div class='col-md-8 divBackgroundColor'>" +
							"<input type='checkbox'id='"+count+"' name='check' /><label for='"+count+"'><span></span></label><input type='hidden' class='form-control' id='service-"+count+"' value='"+currentServiceID+"'/></div></div>");
					}else{
						if(returnFirstLine==0){
							onwordpassengerList.append("<div class='col-md-12 divBackgroundColor'><div class='col-md-2 divBackgroundColor'>" +
								"<input type='text' class='form-control' id='passenger-"+count+"' value='"+rs.getString("PASSANGER_NAME")+"' disabled/></div><div class='col-md-2 divBackgroundColor'>" +
								"<input type='text' class='form-control' id='seat-"+count+"' value='"+rs.getString("SEAT_NUMBER")+"' disabled/></div><div class='col-md-8 divBackgroundColor'>" +
								"<input type='checkbox'id='"+count+"' name='check' /><label for='"+count+"'><span></span></label><input type='hidden' class='form-control' id='service-"+count+"' value='"+currentServiceID+"'/></div></div>");
						returnFirstLine=1;
						}
					}
				}
				onwordCount++;
			}
			previousServicID=currentServiceID;
			count++;
		}
		ticketObject.put("isRoundTrip", isRoundTrip);
		ticketObject.put("onwordStructure", onwordpassengerList.toString());
		ticketObject.put("returnStructure", returnpassengerList.toString());
		ticketObject.put("count", count-1);
		ticketObject.put("onwordCount", onwordCount);
		ticketObject.put("returnCount", returnCount);
		ticketObject.put("onwordService", onwardServiceID);
		ticketObject.put("returnService", returnServiceID);
		
	}catch (Exception e) {
		e.printStackTrace();
	}finally{
		DBConnection.releaseConnectionToDB(con, pstmt, rs);
	}
	return ticketObject;
}
public String partailCanelationWithMultipleSelected(String transactionID,String emailId,String tripType,String onwordSeats,String returnSeats,
		int onwordSelectedCount,int returnSelectedCount,String onwordDate,String returnDate,int onwordServiceId,int returnServiceId,int totalCancellation,int systemId,int customerId,int insertedBy){
	Connection con = null;
    PreparedStatement pstmt = null;   
    ResultSet rs = null;
    PreparedStatement pst = null; 
    String response = null;
    String name=null; 
    int onwordTotalSeats=0;
    int returnTotalSeats=0;
    int onwordUpdate=0;
    int returnUpdate=0;
    int onwordDeleted=0;
    int returnDeleted=0;
    int onwordHistoryInserted=0;
    int returnHistoryInserted=0;
    double onwordAmount=0;
    double returnAmount=0;
	 SimpleDateFormat yyyymmdd = new SimpleDateFormat("yyyy-MM-dd");
	 SimpleDateFormat ddmmyyyy = new SimpleDateFormat("dd-MM-yyyy");
    try {	
    	con = DBConnection.getConnectionToDB("AMS");    		
    	if(onwordSelectedCount!=0 && onwordSeats!=null){
    	pstmt = con.prepareStatement(PassengerBusTransportationStatements.GET_PARTIAL_CANCEL_TRIP_DETAILS);
    	pstmt.setString(1, transactionID);
    	pstmt.setString(2, yyyymmdd.format(ddmmyyyy.parse(onwordDate)));
    	pstmt.setInt(3, onwordServiceId);
    	rs=pstmt.executeQuery();
    	if(rs.next()){
    		name=rs.getString("PASSANGER_NAME");    		
    		if(onwordSelectedCount>=rs.getInt("NUMBER_OF_SEATS")){    			
    			onwordTotalSeats=0;    		
    			onwordAmount=Math.round(rs.getDouble("TICKET_RATE")*onwordSelectedCount);
    		}else{
    			onwordTotalSeats=rs.getInt("NUMBER_OF_SEATS")-onwordSelectedCount;    	
    			onwordAmount=Math.round(rs.getDouble("TICKET_RATE")*onwordSelectedCount);
    		}
    	}
    	pstmt = con.prepareStatement(PassengerBusTransportationStatements.UPDATE_TRANSACTION_DETAILS_WITH_NO_AMOUNT);
    	pstmt.setInt(1, onwordTotalSeats);    
    	pstmt.setString(2, transactionID);
    	pstmt.setInt(3, onwordServiceId);
    	pstmt.setString(4, yyyymmdd.format(ddmmyyyy.parse(onwordDate)));
    	onwordUpdate=pstmt.executeUpdate();
    	if(onwordUpdate>0){
    		pstmt=con.prepareStatement(PassengerBusTransportationStatements.INSERT_INTO_TRANSACTION_HISTORY_WITH_NO_AMOUNT);
    		pstmt.setString(1, transactionID);
    		pstmt.setString(2, yyyymmdd.format(ddmmyyyy.parse(onwordDate)));
    		pstmt.setInt(3, onwordSelectedCount);  
    		pstmt.setDouble(4, onwordAmount);
    		pstmt.setInt(5, onwordServiceId);
    		pstmt.setString(6, onwordSeats);
    		onwordHistoryInserted=pstmt.executeUpdate();
    		
    		if(onwordHistoryInserted>0){
    			String stmt="delete from AMS.dbo.PASSANGER_DETAILS where TRANSACTION_ID=? and SERVICE_ID=? and SEAT_NUMBER in ("+onwordSeats+")";
        		pstmt = con.prepareStatement(stmt);
        		pstmt.setString(1, transactionID);
            	pstmt.setInt(2, onwordServiceId);
            	onwordDeleted=pstmt.executeUpdate();   
    		}    		     	
    	}    	
    	}
    	
    	if(rs!=null){
    		rs.close();
    	}    	
    	
    	if(returnSelectedCount!=0 && returnSeats!=null){
    	pstmt = con.prepareStatement(PassengerBusTransportationStatements.GET_PARTIAL_CANCEL_TRIP_DETAILS);
    	pstmt.setString(1, transactionID);
    	pstmt.setString(2, yyyymmdd.format(ddmmyyyy.parse(returnDate)));
    	pstmt.setInt(3, returnServiceId);
    	rs=pstmt.executeQuery();
    	if(rs.next()){
    		name=rs.getString("PASSANGER_NAME");    		
    		if(returnSelectedCount>=rs.getInt("NUMBER_OF_SEATS")){    			
    			returnTotalSeats=0;    			
    			returnAmount=Math.round(rs.getDouble("TICKET_RATE")*returnSelectedCount);
    		}else{
    			returnTotalSeats=rs.getInt("NUMBER_OF_SEATS")-returnSelectedCount;
    			returnAmount=Math.round(rs.getDouble("TICKET_RATE")*returnSelectedCount);
    		}
    	}
    	pstmt = con.prepareStatement(PassengerBusTransportationStatements.UPDATE_TRANSACTION_DETAILS_WITH_NO_AMOUNT);
    	pstmt.setInt(1, returnTotalSeats);    
    	pstmt.setString(2, transactionID);
    	pstmt.setInt(3, returnServiceId);
    	pstmt.setString(4, yyyymmdd.format(ddmmyyyy.parse(returnDate)));
    	returnUpdate=pstmt.executeUpdate();
    	if(returnUpdate>0){
    		pstmt=con.prepareStatement(PassengerBusTransportationStatements.INSERT_INTO_TRANSACTION_HISTORY_WITH_NO_AMOUNT);
    		pstmt.setString(1, transactionID);
    		pstmt.setString(2, yyyymmdd.format(ddmmyyyy.parse(returnDate)));
    		pstmt.setInt(3, returnSelectedCount);   
    		pstmt.setDouble(4, returnAmount);
    		pstmt.setInt(5, returnServiceId);
    		pstmt.setString(6, returnSeats);
    		returnHistoryInserted=pstmt.executeUpdate();    		
    		if(returnHistoryInserted>0){
    			String stmt="delete from AMS.dbo.PASSANGER_DETAILS where TRANSACTION_ID=? and SERVICE_ID=? and SEAT_NUMBER in ("+returnSeats+")";
        		pstmt = con.prepareStatement(stmt);
        		pstmt.setString(1, transactionID);
            	pstmt.setInt(2, returnServiceId);
            	returnDeleted=pstmt.executeUpdate();  	
    		}    		      	
    	}    	
    	}
    	
    	if(onwordDeleted!=0 || returnDeleted!=0){
    		if(totalCancellation==1){
    			pstmt = con.prepareStatement(PassengerBusTransportationStatements.UPDATE_TRANSCATION_MASTER_FOR_ROUND_TRIP_WITH_CANCEL); 
    		}else{
    			pstmt = con.prepareStatement(PassengerBusTransportationStatements.UPDATE_TRANSACTION_MASTER_FOR_ROUND_TRIP_CANCEL); 	
    		}    		       	
        	pstmt.setString(1, tripType);        	
        	pstmt.setString(2, transactionID);
        	pstmt.execute();
    		response=name+"$"+"true";
    	}
    	
        } catch (Exception e) {	        	
        	e.printStackTrace();
        } finally {
        DBConnection.releaseConnectionToDB(con, pstmt, rs);
        DBConnection.releaseConnectionToDB(null, pst, null);	       
    }
    return response;
}
public String partailCanelationWithMultipleSelectedForOpenTrip(String transactionID,String emailId,String phoneNo,String tripType,String onwordSeats,String returnSeats,
		int onwordSelectedCount,int returnSelectedCount,String onwordDate,String returnDate,int onwordServiceId,int returnServiceId,int totalCancellation,int systemId,int customerId,int insertedBy){
	Connection con = null;
    PreparedStatement pstmt = null;   
    ResultSet rs = null;    
    String response = null;
    String name=null;  
    double onwordAmount=0;
    double returnAmount=0;
    String cuponCode="";
    int onwordTotalSeats=0;
    int returnTotalSeats=0;
    int onwordUpdate=0;
    int returnUpdate=0;
    int onwordDeleted=0;
    int returnDeleted=0;
    int onwordHistoryInserted=0;
    int returnHistoryInserted=0;
    double amount = 0;
    boolean flag=false;
    boolean smsSent=false;
	 SimpleDateFormat yyyymmdd = new SimpleDateFormat("yyyy-MM-dd");
	 SimpleDateFormat ddmmyyyy = new SimpleDateFormat("dd-MM-yyyy");
    try {	
    	con = DBConnection.getConnectionToDB("AMS");
    	
    	cuponCode=getCuponCode();
    	pstmt = con.prepareStatement(PassengerBusTransportationStatements.CHECK_PREPAID_CARD_COUPON_CODE);	
    	pstmt.setString(1, cuponCode);
    	rs=pstmt.executeQuery();
    	if(rs.next()){
	    	cuponCode=getCuponCode();
    	}    	
    	rs.close();   
    		
    		flag=checkTicketBookedWithOpenCoupon(con, transactionID, systemId, customerId);
    	if(onwordSelectedCount!=0 && onwordSeats!=null){
    		
    		if(flag==true){
    			pstmt = con.prepareStatement(PassengerBusTransportationStatements.GET_PARTIAL_CANCEL_TRIP_DETAILS);
    	    	pstmt.setString(1, transactionID);
    	    	pstmt.setString(2, yyyymmdd.format(ddmmyyyy.parse(onwordDate)));
    	    	pstmt.setInt(3, onwordServiceId);
    	    	rs=pstmt.executeQuery();
    	    	if(rs.next()){
    	    		name=rs.getString("PASSANGER_NAME");    	    	
    	    		if(onwordSelectedCount>=rs.getInt("NUMBER_OF_SEATS")){    			
    	    			onwordTotalSeats=0;    			
    	    		}else{
    	    			onwordTotalSeats=rs.getInt("NUMBER_OF_SEATS")-onwordSelectedCount;    		
    	    		}
    	    	}
    	    	pstmt = con.prepareStatement(PassengerBusTransportationStatements.UPDATE_TRANSACTION_DETAILS_WITH_NO_AMOUNT);
    	    	pstmt.setInt(1, onwordTotalSeats);    
    	    	pstmt.setString(2, transactionID);
    	    	pstmt.setInt(3, onwordServiceId);
    	    	pstmt.setString(4, yyyymmdd.format(ddmmyyyy.parse(onwordDate)));
    	    	onwordUpdate=pstmt.executeUpdate();
    	    	if(onwordUpdate>0){
    	    		pstmt=con.prepareStatement(PassengerBusTransportationStatements.INSERT_INTO_TRANSACTION_HISTORY_WITH_NO_AMOUNT);
    	    		pstmt.setString(1, transactionID);
    	    		pstmt.setString(2, yyyymmdd.format(ddmmyyyy.parse(onwordDate)));
    	    		pstmt.setInt(3, onwordSelectedCount);   
    	    		pstmt.setInt(4, onwordServiceId);
    	    		pstmt.setString(5, onwordSeats);
    	    		onwordHistoryInserted=pstmt.executeUpdate();
    	    		
    	    		if(onwordHistoryInserted>0){
    	    			String stmt="delete from AMS.dbo.PASSANGER_DETAILS where TRANSACTION_ID=? and SERVICE_ID=? and SEAT_NUMBER in ("+onwordSeats+")";
    	        		pstmt = con.prepareStatement(stmt);
    	        		pstmt.setString(1, transactionID);
    	            	pstmt.setInt(2, onwordServiceId);
    	            	onwordDeleted=pstmt.executeUpdate();   
    	    		}    		     	
    	    	}   
    			
    		}else{    			
    			pstmt = con.prepareStatement(PassengerBusTransportationStatements.GET_PARTIAL_CANCEL_TRIP_DETAILS);
    	    	pstmt.setString(1, transactionID);
    	    	pstmt.setString(2, yyyymmdd.format(ddmmyyyy.parse(onwordDate)));
    	    	pstmt.setInt(3, onwordServiceId);
    	    	rs=pstmt.executeQuery();
    	    	if(rs.next()){
    	    		name=rs.getString("PASSANGER_NAME");    	    		
    	    		if(onwordSelectedCount>=rs.getInt("NUMBER_OF_SEATS")){    			   
    	    			onwordTotalSeats=0;
    	    			onwordAmount=Math.round(rs.getDouble("TICKET_RATE")*onwordSelectedCount);
    	    		}else{
    	    			onwordTotalSeats=rs.getInt("NUMBER_OF_SEATS")-onwordSelectedCount;
    	    			onwordAmount=Math.round(rs.getDouble("TICKET_RATE")*onwordSelectedCount);    			
    	    		}
    	    	}
    	    	pstmt = con.prepareStatement(PassengerBusTransportationStatements.UPDATE_TRANSACTION_DETAILS);
    	    	pstmt.setInt(1, onwordTotalSeats);
    	    	pstmt.setDouble(2, onwordAmount);
    	    	pstmt.setString(3, transactionID);
    	    	pstmt.setInt(4, onwordServiceId);
    	    	pstmt.setString(5, yyyymmdd.format(ddmmyyyy.parse(onwordDate)));
    	    	onwordUpdate=pstmt.executeUpdate();
    	    	if(onwordUpdate>0){
    	    		pstmt=con.prepareStatement(PassengerBusTransportationStatements.INSERT_INTO_TRANSACTION_HISTORY_FOR_OPEN_TICKET);
    	    		pstmt.setString(1, transactionID);
    	    		pstmt.setString(2, yyyymmdd.format(ddmmyyyy.parse(onwordDate)));
    	    		pstmt.setInt(3, onwordSelectedCount);
    	    		pstmt.setDouble(4, onwordAmount);
    	    		pstmt.setDouble(5, onwordAmount);
    	    		pstmt.setInt(6, onwordServiceId);
    	    		pstmt.setString(7, onwordSeats);
    	    		pstmt.setString(8, cuponCode);
    	    		onwordHistoryInserted=pstmt.executeUpdate();
    	    		if(onwordHistoryInserted>0){
    	    			String stmt="delete from AMS.dbo.PASSANGER_DETAILS where TRANSACTION_ID=? and SERVICE_ID=? and SEAT_NUMBER in ("+onwordSeats+")";
        	    		pstmt = con.prepareStatement(stmt);
        	    		pstmt.setString(1, transactionID);
        	        	pstmt.setInt(2, onwordServiceId);
        	        	onwordDeleted=pstmt.executeUpdate();  
    	    		}
    	    		      	
    	    	}
    			
    		}
    	
    	
    	}
    	
    	if(rs!=null){
    		rs.close();
    	}    
    	
    	if(returnSelectedCount!=0 && returnSeats!=null){
    		
    		if(flag==true){
    			pstmt = con.prepareStatement(PassengerBusTransportationStatements.GET_PARTIAL_CANCEL_TRIP_DETAILS);
    	    	pstmt.setString(1, transactionID);
    	    	pstmt.setString(2, yyyymmdd.format(ddmmyyyy.parse(returnDate)));
    	    	pstmt.setInt(3, returnServiceId);
    	    	rs=pstmt.executeQuery();
    	    	if(rs.next()){
    	    		name=rs.getString("PASSANGER_NAME");    	    	
    	    		if(returnSelectedCount>=rs.getInt("NUMBER_OF_SEATS")){    			
    	    			returnTotalSeats=0;    			
    	    		}else{
    	    			returnTotalSeats=rs.getInt("NUMBER_OF_SEATS")-returnSelectedCount;    			
    	    		}
    	    	}
    	    	pstmt = con.prepareStatement(PassengerBusTransportationStatements.UPDATE_TRANSACTION_DETAILS_WITH_NO_AMOUNT);
    	    	pstmt.setInt(1, returnTotalSeats);    
    	    	pstmt.setString(2, transactionID);
    	    	pstmt.setInt(3, returnServiceId);
    	    	pstmt.setString(4, yyyymmdd.format(ddmmyyyy.parse(returnDate)));
    	    	returnUpdate=pstmt.executeUpdate();
    	    	if(returnUpdate>0){
    	    		pstmt=con.prepareStatement(PassengerBusTransportationStatements.INSERT_INTO_TRANSACTION_HISTORY_WITH_NO_AMOUNT);
    	    		pstmt.setString(1, transactionID);
    	    		pstmt.setString(2, yyyymmdd.format(ddmmyyyy.parse(returnDate)));
    	    		pstmt.setInt(3, returnSelectedCount);   
    	    		pstmt.setInt(4, returnServiceId);
    	    		pstmt.setString(5, returnSeats);
    	    		returnHistoryInserted=pstmt.executeUpdate();    		
    	    		if(returnHistoryInserted>0){
    	    			String stmt="delete from AMS.dbo.PASSANGER_DETAILS where TRANSACTION_ID=? and SERVICE_ID=? and SEAT_NUMBER in ("+returnSeats+")";
    	        		pstmt = con.prepareStatement(stmt);
    	        		pstmt.setString(1, transactionID);
    	            	pstmt.setInt(2, returnServiceId);
    	            	returnDeleted=pstmt.executeUpdate();  	
    	    		}    		      	
    	    	}    	
    		}else{
    			pstmt = con.prepareStatement(PassengerBusTransportationStatements.GET_PARTIAL_CANCEL_TRIP_DETAILS);
    	    	pstmt.setString(1, transactionID);
    	    	pstmt.setString(2, yyyymmdd.format(ddmmyyyy.parse(returnDate)));
    	    	pstmt.setInt(3, returnServiceId);
    	    	rs=pstmt.executeQuery();
    	    	if(rs.next()){
    	    		name=rs.getString("PASSANGER_NAME");    	    		
    	    		if(returnSelectedCount>=rs.getInt("NUMBER_OF_SEATS")){    		
    	    			returnTotalSeats=0;    			
    	    			returnAmount=Math.round(rs.getDouble("TICKET_RATE")*returnSelectedCount);
    	    		}else{
    	    			returnTotalSeats=rs.getInt("NUMBER_OF_SEATS")-returnSelectedCount;   		
    	    			returnAmount=Math.round(rs.getDouble("TICKET_RATE")*returnSelectedCount);
    	    		}
    	    	}
    	    	pstmt = con.prepareStatement(PassengerBusTransportationStatements.UPDATE_TRANSACTION_DETAILS);
    	    	pstmt.setInt(1, returnTotalSeats);
    	    	pstmt.setDouble(2, returnAmount);
    	    	pstmt.setString(3, transactionID);
    	    	pstmt.setInt(4, returnServiceId);
    	    	pstmt.setString(5, yyyymmdd.format(ddmmyyyy.parse(returnDate)));
    	    	returnUpdate=pstmt.executeUpdate();
    	    	if(returnUpdate>0){
    	    		pstmt=con.prepareStatement(PassengerBusTransportationStatements.INSERT_INTO_TRANSACTION_HISTORY_FOR_OPEN_TICKET);
    	    		pstmt.setString(1, transactionID);
    	    		pstmt.setString(2, yyyymmdd.format(ddmmyyyy.parse(returnDate)));
    	    		pstmt.setInt(3, returnSelectedCount);
    	    		pstmt.setDouble(4, returnAmount);
    	    		pstmt.setDouble(5, returnAmount);
    	    		pstmt.setInt(6, returnServiceId);
    	    		pstmt.setString(7, returnSeats);
    	    		pstmt.setString(8, cuponCode);
    	    		returnHistoryInserted=pstmt.executeUpdate();
    	    		if(returnHistoryInserted>0){
    	    			String stmt="delete from AMS.dbo.PASSANGER_DETAILS where TRANSACTION_ID=? and SERVICE_ID=? and SEAT_NUMBER in ("+returnSeats+")";
        	    		pstmt = con.prepareStatement(stmt);
        	    		pstmt.setString(1, transactionID);
        	        	pstmt.setInt(2, returnServiceId);
        	        	returnDeleted=pstmt.executeUpdate(); 
    	    		}
    	    		       	
    	    	}
    		}    	
    	
    	}
    	
    	if(onwordDeleted!=0 || returnDeleted!=0){  
    		if(flag==true){
    			
    			if(totalCancellation==1){    				
    				pstmt = con.prepareStatement(PassengerBusTransportationStatements.UPDATE_TRANSACTION_MASTER_FOR_USED_COUPON_CODE);      
    		    }else{
    		    	pstmt = con.prepareStatement(PassengerBusTransportationStatements.UPDATE_TRANSACTION_MASTER_FOR_ROUND_TRIP_CANCEL); 
    		    }        		       	
            	pstmt.setString(1, tripType);            
            	pstmt.setString(2, transactionID);
            	pstmt.execute();            	            	
            	response=name;
            	
    		}else{
    			
    			amount=returnAmount+onwordAmount;
    			if(totalCancellation==1){    				
    				pstmt = con.prepareStatement(PassengerBusTransportationStatements.UPDATE_TRANSACTION_MASTER_TO_OPEN);      
    		    }else{
    		    	pstmt = con.prepareStatement(PassengerBusTransportationStatements.UPDATE_TRANSACTION_MASTER);        	
    		    }        	
            	pstmt.setString(1, tripType);
            	pstmt.setDouble(2, amount);
            	pstmt.setString(3, transactionID);
            	pstmt.execute();
            	smsSent=sendSMSAndEmailForOpenTicket(con,amount, transactionID, cuponCode, name, phoneNo, emailId, systemId,
    					customerId, insertedBy);
            	if(smsSent){
            		response=name+"$"+"amount";
            	}
    		}
    	}
        } catch (Exception e) {	        	
        	e.printStackTrace();
        } finally {
        DBConnection.releaseConnectionToDB(con, pstmt, rs);        	       
    }
    return response;
}
public String partailCanelationWithMultipleSelectedForSingle(String transactionID,String emailId,String phoneNo,String onwordSeats,
		int onwordSelectedCount,String onwordDate,int onwordServiceId,int totalCancellation,int systemId,int customerId,int insertedBy){
	Connection con = null;
    PreparedStatement pstmt = null;  
    ResultSet rs = null;   
    String response = null;
    String name=null;   
    double onwordAmount=0; 
    String cuponCode="";     
    int onwordTotalSeats=0;   
    int onwordUpdate=0;   
    int onwordDeleted=0;    
	 SimpleDateFormat yyyymmdd = new SimpleDateFormat("yyyy-MM-dd");
	 SimpleDateFormat ddmmyyyy = new SimpleDateFormat("dd-MM-yyyy");
	 List<Object> deductionAmount=new ArrayList<Object>();
	 int onwordHistoryInserted=0;
    try {	
    	con = DBConnection.getConnectionToDB("AMS");
    	
    	cuponCode=getCuponCode();
    	pstmt = con.prepareStatement(PassengerBusTransportationStatements.CHECK_PREPAID_CARD_COUPON_CODE);	
    	pstmt.setString(1, cuponCode);
    	rs=pstmt.executeQuery();
    	if(rs.next()){
	    	cuponCode=getCuponCode();
    	}    	
    	rs.close();
    		
    	if(onwordSelectedCount!=0 && onwordSeats!=null){
    	pstmt = con.prepareStatement(PassengerBusTransportationStatements.GET_PARTIAL_CANCEL_TRIP_DETAILS);
    	pstmt.setString(1, transactionID);
    	pstmt.setString(2, yyyymmdd.format(ddmmyyyy.parse(onwordDate)));
    	pstmt.setInt(3, onwordServiceId);
    	rs=pstmt.executeQuery();
    	if(rs.next()){
    		name=rs.getString("PASSANGER_NAME");    		
    		if(onwordSelectedCount>=rs.getInt("NUMBER_OF_SEATS")){    			
    			onwordTotalSeats=0;
    			onwordAmount=Math.round(rs.getDouble("TICKET_RATE")*onwordSelectedCount);
    			deductionAmount=getAmountBasedOnDateDifference(yyyymmdd.format(ddmmyyyy.parse(onwordDate)),onwordAmount);
    		}else{
    			onwordTotalSeats=rs.getInt("NUMBER_OF_SEATS")-onwordSelectedCount;    		
    			onwordAmount=Math.round(rs.getDouble("TICKET_RATE")*onwordSelectedCount);
    			deductionAmount=getAmountBasedOnDateDifference(yyyymmdd.format(ddmmyyyy.parse(onwordDate)),onwordAmount);
    			
    		}
    	}
    	pstmt = con.prepareStatement(PassengerBusTransportationStatements.UPDATE_TRANSACTION_DETAILS);
    	pstmt.setInt(1, onwordTotalSeats);
    	pstmt.setDouble(2, (Double) deductionAmount.get(0));
    	pstmt.setString(3, transactionID);
    	pstmt.setInt(4, onwordServiceId);
    	pstmt.setString(5, yyyymmdd.format(ddmmyyyy.parse(onwordDate)));
    	onwordUpdate=pstmt.executeUpdate();
    	if(onwordUpdate>0){    		
    		pstmt=con.prepareStatement(PassengerBusTransportationStatements.INSERT_INTO_TRANSACTION_HISTORY_FOR_SINGLE_TRIP_CANCEL);
    		pstmt.setString(1, transactionID);
    		pstmt.setString(2, yyyymmdd.format(ddmmyyyy.parse(onwordDate)));
    		pstmt.setInt(3,(Integer) deductionAmount.get(1));
    		pstmt.setInt(4, onwordSelectedCount);
    		pstmt.setDouble(5, (Double) deductionAmount.get(0));
    		pstmt.setDouble(6, onwordAmount);
    		pstmt.setInt(7, onwordServiceId);
    		pstmt.setString(8, onwordSeats);
    		pstmt.setString(9, cuponCode);
    		onwordHistoryInserted=pstmt.executeUpdate();
    		if(onwordHistoryInserted>0){
    			String stmt="delete from AMS.dbo.PASSANGER_DETAILS where TRANSACTION_ID=? and SERVICE_ID=? and SEAT_NUMBER in ("+onwordSeats+")";
        		pstmt = con.prepareStatement(stmt);
        		pstmt.setString(1, transactionID);
            	pstmt.setInt(2, onwordServiceId);
            	onwordDeleted=pstmt.executeUpdate(); 
    		}    		
        	if(onwordDeleted>0){
        		response=sendSMSAndEmailForCancelTicket(con,(Double) deductionAmount.get(0), transactionID, yyyymmdd.format(ddmmyyyy.parse(onwordDate)), cuponCode, name, phoneNo, emailId, systemId,
    					customerId, insertedBy);
        		if(response!=null){
        			if(onwordDeleted!=0 ){
        				if(totalCancellation==1){        					
        					pstmt = con.prepareStatement(PassengerBusTransportationStatements.UPDATE_TRANSACTION_MASTER_FOR_CANCEL_TICKET);
        				}else{
        					pstmt = con.prepareStatement(PassengerBusTransportationStatements.UPDATE_TRANSACTION_MASTER); 	
        				}        	    		       	
        	        	pstmt.setString(1, "false");
        	        	pstmt.setDouble(2,(Double) deductionAmount.get(0));
        	        	pstmt.setString(3, transactionID);
        	        	pstmt.execute();
        	    		response=name+"$"+"false";
        	    	}
        		}
        	}
    	}
    	
    	}    	
    	
        } catch (Exception e) {	        	
        	e.printStackTrace();
        } finally {
        DBConnection.releaseConnectionToDB(con, pstmt, rs);             
    }
    return response;
}

public String partailOpenTripWithMultipleSelectedForSingle(String transactionID,String emailId,String phoneNo,String onwordSeats,
		int onwordSelectedCount,String onwordDate,int onwordServiceId,int totalCancellation,int systemId,int customerId,int insertedBy){
	Connection con = null;
    PreparedStatement pstmt = null;  
    ResultSet rs = null;   
    String response = null;
    String name=null;   
    double onwordAmount=0;   
    String cuponCode="";  
    int onwordTotalSeats=0;   
    int onwordUpdate=0;   
    int onwordDeleted=0;   
    boolean flag=false;
    int onwordHistoryInserted=0;
	 SimpleDateFormat yyyymmdd = new SimpleDateFormat("yyyy-MM-dd");
	 SimpleDateFormat ddmmyyyy = new SimpleDateFormat("dd-MM-yyyy");
    try {	
    	con = DBConnection.getConnectionToDB("AMS");
    	
    	cuponCode=getCuponCode();
    	pstmt = con.prepareStatement(PassengerBusTransportationStatements.CHECK_PREPAID_CARD_COUPON_CODE);	
    	pstmt.setString(1, cuponCode);
    	rs=pstmt.executeQuery();
    	if(rs.next()){
	    	cuponCode=getCuponCode();
    	}    	
    	rs.close();    	
   
    	flag=checkTicketBookedWithOpenCoupon(con, transactionID, systemId, customerId);
    	
    		if(onwordSelectedCount!=0 && onwordSeats!=null){
    			
    			if(flag==true){    	    		
    	    		pstmt = con.prepareStatement(PassengerBusTransportationStatements.GET_PARTIAL_CANCEL_TRIP_DETAILS);
    		    	pstmt.setString(1, transactionID);
    		    	pstmt.setString(2, yyyymmdd.format(ddmmyyyy.parse(onwordDate)));
    		    	pstmt.setInt(3, onwordServiceId);
    		    	rs=pstmt.executeQuery();
    		    	if(rs.next()){
    		    		name=rs.getString("PASSANGER_NAME");    		    	
    		    		if(onwordSelectedCount>=rs.getInt("NUMBER_OF_SEATS")){    			
    		    			onwordTotalSeats=0;    
    		    			onwordAmount=Math.round(rs.getDouble("TICKET_RATE")*onwordSelectedCount);
    		    		}else{
    		    			onwordAmount=Math.round(rs.getDouble("TICKET_RATE")*onwordSelectedCount);
    		    			onwordTotalSeats=rs.getInt("NUMBER_OF_SEATS")-onwordSelectedCount;    		
    		    		}
    		    	}
    		    	pstmt = con.prepareStatement(PassengerBusTransportationStatements.UPDATE_TRANSACTION_DETAILS_WITH_NO_AMOUNT);
    		    	pstmt.setInt(1, onwordTotalSeats);    
    		    	pstmt.setString(2, transactionID);
    		    	pstmt.setInt(3, onwordServiceId);
    		    	pstmt.setString(4, yyyymmdd.format(ddmmyyyy.parse(onwordDate)));
    		    	onwordUpdate=pstmt.executeUpdate();
    		    	if(onwordUpdate>0){
    		    		pstmt=con.prepareStatement(PassengerBusTransportationStatements.INSERT_INTO_TRANSACTION_HISTORY_WITH_NO_AMOUNT);
    		    		pstmt.setString(1, transactionID);
    		    		pstmt.setString(2, yyyymmdd.format(ddmmyyyy.parse(onwordDate)));
    		    		pstmt.setInt(3, onwordSelectedCount);   
    		    		pstmt.setDouble(4, onwordAmount);
    		    		pstmt.setInt(5, onwordServiceId);
    		    		pstmt.setString(6, onwordSeats);
    		    		onwordHistoryInserted=pstmt.executeUpdate();
    		    		
    		    		if(onwordHistoryInserted>0){
    		    			String stmt="delete from AMS.dbo.PASSANGER_DETAILS where TRANSACTION_ID=? and SERVICE_ID=? and SEAT_NUMBER in ("+onwordSeats+")";
    		        		pstmt = con.prepareStatement(stmt);
    		        		pstmt.setString(1, transactionID);
    		            	pstmt.setInt(2, onwordServiceId);
    		            	onwordDeleted=pstmt.executeUpdate();   
    		            	if(onwordDeleted>0){	            		
    	    					if(totalCancellation==1){    				
    	    	    				pstmt = con.prepareStatement(PassengerBusTransportationStatements.UPDATE_TRANSACTION_MASTER_FOR_USED_COUPON_CODE);      
    	    	    		    }else{
    	    	    		    	pstmt = con.prepareStatement(PassengerBusTransportationStatements.UPDATE_TRANSACTION_MASTER_FOR_ROUND_TRIP_CANCEL); 
    	    	    		    }    	    	        		       	
    	    	            	pstmt.setString(1, "false");            
    	    	            	pstmt.setString(2, transactionID);
    	    	            	pstmt.execute();            	            	
    	    	            	response=name;
    		            	}
    		    		}    		     	
    		    	}   
    	    		
    	    	}else{
    	    		pstmt = con.prepareStatement(PassengerBusTransportationStatements.GET_PARTIAL_CANCEL_TRIP_DETAILS);
        	    	pstmt.setString(1, transactionID);
        	    	pstmt.setString(2, yyyymmdd.format(ddmmyyyy.parse(onwordDate)));
        	    	pstmt.setInt(3, onwordServiceId);
        	    	rs=pstmt.executeQuery();
        	    	if(rs.next()){
        	    		name=rs.getString("PASSANGER_NAME");        	    		
        	    		if(onwordSelectedCount>=rs.getInt("NUMBER_OF_SEATS")){    	    			
        	    			onwordTotalSeats=0;    	    			
        	    			onwordAmount=Math.round(rs.getDouble("TICKET_RATE")*onwordSelectedCount);
        	    		}else{
        	    			onwordTotalSeats=rs.getInt("NUMBER_OF_SEATS")-onwordSelectedCount;
        	    			onwordAmount=Math.round(rs.getDouble("TICKET_RATE")*onwordSelectedCount);    	    			
        	    		}
        	    	}
        	    	
        	    	pstmt = con.prepareStatement(PassengerBusTransportationStatements.UPDATE_TRANSACTION_DETAILS);
        	    	pstmt.setInt(1, onwordTotalSeats);
        	    	pstmt.setDouble(2, onwordAmount);
        	    	pstmt.setString(3, transactionID);
        	    	pstmt.setInt(4, onwordServiceId);
        	    	pstmt.setString(5, yyyymmdd.format(ddmmyyyy.parse(onwordDate)));
        	    	onwordUpdate=pstmt.executeUpdate();
        	    	if(onwordUpdate>0){
        	    		
        	    		pstmt=con.prepareStatement(PassengerBusTransportationStatements.INSERT_INTO_TRANSACTION_HISTORY_FOR_OPEN_TICKET);
        	    		pstmt.setString(1, transactionID);
        	    		pstmt.setString(2, yyyymmdd.format(ddmmyyyy.parse(onwordDate)));
        	    		pstmt.setInt(3, onwordSelectedCount);
        	    		pstmt.setDouble(4, onwordAmount);
        	    		pstmt.setDouble(5, onwordAmount);
        	    		pstmt.setInt(6, onwordServiceId);
        	    		pstmt.setString(7, onwordSeats);
        	    		pstmt.setString(8, cuponCode);
        	    		onwordHistoryInserted=pstmt.executeUpdate();
        	    		
        	    		if(onwordHistoryInserted>0){
        	    			String stmt="delete from AMS.dbo.PASSANGER_DETAILS where TRANSACTION_ID=? and SERVICE_ID=? and SEAT_NUMBER in ("+onwordSeats+")";
            	    		pstmt = con.prepareStatement(stmt);
            	    		pstmt.setString(1, transactionID);
            	        	pstmt.setInt(2, onwordServiceId);
            	        	onwordDeleted=pstmt.executeUpdate(); 
            	        	if(onwordDeleted>0){
            	        		sendSMSAndEmailForOpenTicket(con,onwordAmount, transactionID, cuponCode, name, phoneNo, emailId, systemId,
            	    					customerId, insertedBy);            	        		
            	        			if(onwordDeleted!=0 ){	            	        				
            	        				if(totalCancellation==1){    				
            	            				pstmt = con.prepareStatement(PassengerBusTransportationStatements.UPDATE_TRANSACTION_MASTER_TO_OPEN);      
            	            		    }else{
            	            		    	pstmt = con.prepareStatement(PassengerBusTransportationStatements.UPDATE_TRANSACTION_MASTER);
            	            		    }            	                	
            	                    	pstmt.setString(1, "false");
            	                    	pstmt.setDouble(2, onwordAmount);
            	                    	pstmt.setString(3, transactionID);
            	                    	pstmt.execute();
            	                    	response=name+"$"+"amount";
            	        	    	}
            	        	}
        	    		}
        	    		
        	    	}
        	    	
    	    	}    			
    	    	
    	    	}   
    	
    	
        } catch (Exception e) {	        	
        	e.printStackTrace();
        } finally {
        DBConnection.releaseConnectionToDB(con, pstmt, rs);        	       
    }
    return response;
}
public String sendSMSAndEmailForCancelTicket(Connection con,double amount,String transactionID,String onwordDate,String cuponCode,String name,String phoneNo,
		String emailId,int systemId,int customerId,int insertedBy){	
    PreparedStatement pstmt = null;
    PreparedStatement pst = null;	
	int inserted=0;
	String response=null;
	try{	
		pst = con.prepareStatement(PassengerBusTransportationStatements.INSERT_CANCEL_PREPAID_CARD_DETAILS);
		pst.setString(1, cuponCode);
        pst.setString(2, name);
        pst.setString(3, phoneNo);
        pst.setString(4, emailId);
        pst.setDouble(5, amount);
        pst.setDouble(6, amount);
        pst.setInt(7, systemId);
        pst.setInt(8, customerId);
        pst.setInt(9, insertedBy);
       
        inserted = pst.executeUpdate();
        if (inserted > 0) {           
            String emailIdList =emailId ;
			String subject = "";
			StringBuilder body = new StringBuilder();
			
			subject = "Generated Coupon Code for Cancel Ticket";
			body.append("<html><body>" +						
			"<table border = 0 width=60% height=50>" +
			"<tr><td align=left><font size=2>Dear "+name+",</font></td></tr>"+
			"<br>"+
			"<tr><td align=left><font size=2> Your Coupon Code has been successfully generated"+
			"<tr><td align=left><font size=2><b> Coupon Code:</b>"+ cuponCode+"</font></td></tr>" +
			"<tr><td align=left><font size=2><b> Amount:</b>"+ amount+"</font></td></tr>"+
			"</table>");	
		
			body.append("</body></html>");
			
			pstmt = con.prepareStatement(PassengerBusTransportationStatements.INSERT_INTO_EMAIL_QUEUE_FOR_REFERENCE_AND_COUPON_CODE_GENERATION);
			pstmt.setString(1, subject);
			pstmt.setString(2, body.toString());
			pstmt.setString(3, emailIdList);
			pstmt.setInt(4, systemId);
			pstmt.setInt(5, customerId);
		    pstmt.executeUpdate();
			
	        String Sms="Cancel Ticket Coupon Code: "+cuponCode+"\n"+"Amount: "+amount+"\n";
	        pstmt = con.prepareStatement(PassengerBusTransportationStatements.INSERT_SMS);
	        pstmt.setString(1, phoneNo);
	        pstmt.setString(2, Sms);
	        pstmt.setString(3, "N");
	        pstmt.setInt(4, customerId);
	        pstmt.setInt(5, systemId); 

	        int sentSms = pstmt.executeUpdate();
		    if (sentSms > 0) {
	            response = name;
	        }
	        
        }
	}catch (Exception e) {
		e.printStackTrace();
	}finally{
		DBConnection.releaseConnectionToDB(null, pstmt, null);
        DBConnection.releaseConnectionToDB(null, pst, null);
	}
	return response;
	
}

public boolean checkTicketBookedWithOpenCoupon(Connection con,String transactionID,int systemId,int customerId) {
	boolean flag=false;
	PreparedStatement pst = null;	
	 ResultSet rs = null,rs1=null,rs2=null;
	 try{
		 pst=con.prepareStatement(PassengerBusTransportationStatements.CHECK_TRANSACTION_WITH_OPEN_COUPON_CODE);
			pst.setString(1, transactionID);
			rs=pst.executeQuery();
			if(rs.next()){
				if(rs.getString("PRI_PAYMENT_AMOUNT")==null)
				{
					if(rs.getString("PAYMENT_MODE").equals("couponcode")){
						pst=con.prepareStatement(PassengerBusTransportationStatements.CHECK_COUPON_CODE_WITH_OPEN);
						pst.setString(1, rs.getString("COUPON_CODE"));
						pst.setInt(2, systemId);
						pst.setInt(3, customerId);
						rs1=pst.executeQuery();
						if(rs1.next()){						
							flag=true;						
						}
					}
				}else if(rs.getString("PAYMENT_MODE").equals("couponcode") || rs.getString("SEC_PAYMENT_MODE").equals("couponcode")){
					pst=con.prepareStatement(PassengerBusTransportationStatements.CHECK_COUPON_CODE_WITH_OPEN);
					pst.setString(1, rs.getString("COUPON_CODE"));
					pst.setInt(2, systemId);
					pst.setInt(3, customerId);
					rs1=pst.executeQuery();
					if(rs1.next()){					
						flag=true;					
						
					}else{
						pst=con.prepareStatement(PassengerBusTransportationStatements.CHECK_COUPON_CODE_WITH_OPEN);
						pst.setString(1, rs.getString("SEC_COUPON_CODE"));
						pst.setInt(2, systemId);
						pst.setInt(3, customerId);
						rs2=pst.executeQuery();
						if(rs2.next()){					
							flag=true;						
						}
					}
					
				}
				
			}
	 }catch (Exception e) {
		e.printStackTrace();
	}finally{
		DBConnection.releaseConnectionToDB(null, null, rs);    
		  DBConnection.releaseConnectionToDB(null, pst, rs1);      
	        DBConnection.releaseConnectionToDB(null, null, rs2);
	}
	 
	
	return flag;
}

public boolean sendSMSAndEmailForOpenTicket(Connection con,double amount,String transactionID,String cuponCode,String name,String phoneNo,
		String emailId,int systemId,int customerId,int insertedBy){	
    PreparedStatement pstmt = null;    
    PreparedStatement pst = null;	
	int inserted=0;	
	boolean flag=false;
	try{			
			pst = con.prepareStatement(PassengerBusTransportationStatements.INSERT_OPEN_PREPAID_CARD_DETAILS);
			pst.setString(1, cuponCode);
	        pst.setString(2, name);
	        pst.setString(3, phoneNo);
	        pst.setString(4, emailId);
	        pst.setDouble(5, amount);
	        pst.setDouble(6, amount);
	        pst.setInt(7, systemId);
	        pst.setInt(8, customerId);
	        pst.setInt(9, insertedBy);
	       
	        inserted = pst.executeUpdate();
	        if (inserted > 0) {         
	            
	            String emailIdList =emailId ;
				String subject = "";
				StringBuilder body = new StringBuilder();
				
				subject = "Generated Coupon Code For Open Trip";
				body.append("<html><body>" +						
				"<table border = 0 width=60% height=50>" +
				"<tr><td align=left><font size=2>Dear "+name+",</font></td></tr>"+
				"<br>"+
				"<tr><td align=left><font size=2> Your Coupon Code has been successfully generated"+
				"<tr><td align=left><font size=2><b> Coupon Code:</b>"+ cuponCode+"</font></td></tr>" +
				"<tr><td align=left><font size=2><b> Amount:</b>"+ amount+"</font></td></tr>" +
				"</table>");	
			
				body.append("</body></html>");
				
				pstmt = con.prepareStatement(PassengerBusTransportationStatements.INSERT_INTO_EMAIL_QUEUE_FOR_REFERENCE_AND_COUPON_CODE_GENERATION);
				pstmt.setString(1, subject);
				pstmt.setString(2, body.toString());
				pstmt.setString(3, emailIdList);
				pstmt.setInt(4, systemId);
				pstmt.setInt(5, customerId);
			    pstmt.executeUpdate();
				
		        String Sms="Open Trip Coupon Code: "+cuponCode+"\n"+"Amount: "+amount+"\n";
		        pstmt = con.prepareStatement(PassengerBusTransportationStatements.INSERT_SMS);
		        pstmt.setString(1, phoneNo);
		        pstmt.setString(2, Sms);
		        pstmt.setString(3, "N");
		        pstmt.setInt(4, customerId);
		        pstmt.setInt(5, systemId); 

		        int sentSms = pstmt.executeUpdate();
			    if (sentSms > 0) {
			    	flag=true;
		            
		        }
		        
	        }
		
		
	}catch (Exception e) {
		e.printStackTrace();
	}finally{
		DBConnection.releaseConnectionToDB(null, pstmt, null);
        DBConnection.releaseConnectionToDB(null, pst, null);      
	}
	return flag;
	
}

public List<Object> getAmountBasedOnDateDifference(String startDate,double amount){
	  int diffDays=11;
	  List<Object> returnArrayList =new ArrayList<Object>();
    try {
    	    SimpleDateFormat yyyymmdd = new SimpleDateFormat("yyyy-MM-dd");
    	    SimpleDateFormat yyymmddhhmmss = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
    	    Calendar cal=Calendar.getInstance();
    		Date dateGMT=cal.getTime();
    	    String endDate=yyymmddhhmmss.format(dateGMT);
    	    String dateStart = yyyymmdd.format(yyyymmdd.parse(startDate));
    	    String dateStop = yyyymmdd.format(yyyymmdd.parse(endDate));       
    	  
    	    Date date1 = null;
    	    Date date2 = null;
    	    
           date1 = yyyymmdd.parse(dateStart);
           date2 = yyyymmdd.parse(dateStop);
          
           if(date1.compareTo(date2)>0){
        	   long diff = date1.getTime() - date2.getTime();
               diffDays =(int) diff / (24 * 60 * 60 * 1000);
           }else{
        	   long diff = date2.getTime() - date1.getTime();
               diffDays =(int) diff / (24 * 60 * 60 * 1000);
           }
         
        	   
        	   if(diffDays<=1){
           		amount = amount - (int)((amount*40.0f)/100.0f);
           		returnArrayList.add(amount);
           		returnArrayList.add(40);
           	}else if(diffDays>1 && diffDays<=3){
           		amount = amount - (int)((amount*30.0f)/100.0f);
           		returnArrayList.add(amount);
           		returnArrayList.add(30);
           	}else if(diffDays>3 && diffDays<=7){
           		amount = amount - (int)((amount*20.0f)/100.0f);
           		returnArrayList.add(amount);
           		returnArrayList.add(20);
           	}else if(diffDays>7 && diffDays<=10){
           		amount = amount - (int)((amount*10.0f)/100.0f);
           		returnArrayList.add(amount);
           		returnArrayList.add(10);
           	}
                  
           
       	
          
    } catch (Exception e) {
           e.printStackTrace();
    }
    return returnArrayList;
}

public String checkTripId(String tripId,String emailId,String mobileNo,int systemId,int customerId) {
	Connection con = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	String message="";
	try{
	    con = DBConnection.getConnectionToDB("AMS");
		pstmt = con.prepareStatement(PassengerBusTransportationStatements.CHECK_TRIP_NO);
		pstmt.setString(1, emailId);
		pstmt.setString(2,mobileNo);
		pstmt.setString(3, tripId);
		pstmt.setInt(4, systemId);
		pstmt.setInt(5, customerId);
		rs = pstmt.executeQuery();
		if(rs.next()){
			message="Trip Exists";
		}else{
			message="Invalid Trip Id";
		}	
	}catch(Exception e){
		e.printStackTrace();
	}
	finally {
		DBConnection.releaseConnectionToDB(con, pstmt, rs);
	}
return message;
}

public String updateDetails(String tripId,String emailId,String mobileNo,String validEmailId,String validMobileNo,int systemId,int customerId) {
	Connection con = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	String message="";	
	int count=0;
	try{
	con = DBConnection.getConnectionToDB("AMS");	
		pstmt = con.prepareStatement(PassengerBusTransportationStatements.UPDATE_TRIP_DETAILS);
		pstmt.setString(1, validMobileNo);
		pstmt.setString(2,validEmailId);
		pstmt.setString(3, tripId);
		count=pstmt.executeUpdate();	
	if(count>0){
		message = getMailNotification(tripId,customerId,systemId);
	}	
	}catch(Exception e){
		e.printStackTrace();
	}
	finally {
		DBConnection.releaseConnectionToDB(con, pstmt, rs);
	}
return message;
}
public synchronized String TicketBookingFunctionUsingSplitPaymentmodeForRoundTrip( int tempid1, int tempid2,int  systemId, int  customerId,  int  seatNo, String  phoneEmailDetails, String  PassangerDetails, double  totalAmount, String roundtrip, int serviceId1,int rateId1,String journeydate1, String dedicatedSeatnumbers1,int terminalId1,int serviceId2,int rateId2,String journeydate2,String dedicatedSeatnumbers2,int terminalId2,String primarypaymentmode,String primarycouponcode,String primarytotal,String secondaryoaymentmode,String secondaycouponcode,String secondarytotal,int userId ,String basepath ) throws Exception{

	String message = "";

	Connection con = null;	   
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	String inserted = "";
	String transaction_id = "";
	String ticketNo = "";
	transaction_id = getTransactionId();
	transaction_id = checktransactionid(transaction_id);
	ticketNo = getTicketNo();
	String phoneEmailDetail [] = phoneEmailDetails.split(",");
	String primaryPh = phoneEmailDetail[0];
	String primaryemail = phoneEmailDetail[1];
	primaryemail = primaryemail.toLowerCase();
	int inserted1 = 0;
	String inserteds = "";
	String hash = "";
	try{

	con = DBConnection.getConnectionToDB("AMS");	       
	String valid = checkseatNoForRoundTrip(dedicatedSeatnumbers1,dedicatedSeatnumbers2,con,pstmt,rs,serviceId1,journeydate1,serviceId2,journeydate2);
	if(valid.equals("yes")){
	pstmt = con.prepareStatement(PassengerBusTransportationStatements.INSERT_INTO_TRANSACTION_MASTER_FOR_SPLIT_PAYMENT);
	pstmt.setString(1, transaction_id);
	pstmt.setString(2, ticketNo);
	pstmt.setString(3, primarypaymentmode);
	pstmt.setString(4, roundtrip);
	pstmt.setDouble(5, totalAmount);
	pstmt.setString(6, primarycouponcode);
	pstmt.setDouble(7, Double.parseDouble(primarytotal));
	pstmt.setString(8, secondaryoaymentmode);
	pstmt.setString(9, secondaycouponcode);
	pstmt.setDouble(10, Double.parseDouble(secondarytotal));
	pstmt.setInt(11, systemId);
	pstmt.setInt(12, customerId);
	pstmt.setInt(13, userId);
	pstmt.setString(14,primaryPh);
	pstmt.setString(15,primaryemail);
	inserted1 = pstmt.executeUpdate();
	if(inserted1>0){
		inserteds = insertTransactionDetailsAndBookingDetails(transaction_id,ticketNo,con,pstmt,rs,serviceId1,rateId1,seatNo,primarypaymentmode,dedicatedSeatnumbers1, phoneEmailDetails,PassangerDetails, totalAmount,journeydate1,systemId,customerId,roundtrip,terminalId1);
		if(inserteds.equals("yes")){	
		inserted = insertTransactionDetailsAndBookingDetails(transaction_id,ticketNo,con,pstmt,rs,serviceId2,rateId2,seatNo,primarypaymentmode,dedicatedSeatnumbers2, phoneEmailDetails,PassangerDetails, totalAmount,journeydate2,systemId,customerId,roundtrip,terminalId2);		
		}if(inserted.equals("yes")){	    			
	 message = "success";
	hash = gethashvalue(transaction_id,Double.parseDouble(secondarytotal),basepath);
	  }else {
	 	 message = "failed";
	  }	
	}
	pstmt = con.prepareStatement(PassengerBusTransportationStatements.DELETE_DETAILS_FROM_TEMP_TABLE_AFTER_TRANSACTION_FOR_ROUND_TRIP);		            
	pstmt.setInt(1,tempid1);
	pstmt.setInt(2,tempid2);
	pstmt.executeUpdate();
	}else{
		 message = "booked";	
	}
	}catch (Exception e) {	    	
	 e.printStackTrace();
	 }
	finally {
		DBConnection.releaseConnectionToDB(con, pstmt, rs);        
	}
	message = message+"#"+transaction_id+"#"+hash;
	return message;


	}

public synchronized String TicketBookingFunctionUsingSplitPaymentmode(int tempid,int systemId,int customerId,String  serviceId,String rateId,int seatnos,String dedicatedSeatnumbers,String phoneEmailDetails,String PassangerDetails,double totalAmount,String journeydate,String roundtrip ,int terminalId,String primarypaymentmode,String primarycouponcode,String primarytotal,String secondaryoaymentmode,String secondaycouponcode,String secondarytotal, int userId,String basepath) throws Exception{
	String message = "";

	Connection con = null;	   
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	String inserted = "";
	String transaction_id = "";
	String ticketNo = "";
	transaction_id = getTransactionId();
	transaction_id = checktransactionid(transaction_id);
	ticketNo = getTicketNo();
	String phoneEmailDetail [] = phoneEmailDetails.split(",");
	String primaryPh = phoneEmailDetail[0];
	String primaryemail = phoneEmailDetail[1];
	primaryemail = primaryemail.toLowerCase();
	int inserted1 = 0;
    String hash = "";
	try{
	con = DBConnection.getConnectionToDB("AMS");
	String valid = checkseatNo(dedicatedSeatnumbers,con,pstmt,rs,Integer.parseInt(serviceId),journeydate);
	if(valid.equals("yes")){
		pstmt = con.prepareStatement(PassengerBusTransportationStatements.INSERT_INTO_TRANSACTION_MASTER_FOR_SPLIT_PAYMENT);
		pstmt.setString(1, transaction_id);
		pstmt.setString(2, ticketNo);
		pstmt.setString(3, primarypaymentmode);
		pstmt.setString(4, roundtrip);
		pstmt.setDouble(5, totalAmount);
		pstmt.setString(6, primarycouponcode);
		pstmt.setDouble(7, Double.parseDouble(primarytotal));
		pstmt.setString(8, secondaryoaymentmode);
		pstmt.setString(9, secondaycouponcode);
		pstmt.setDouble(10, Double.parseDouble(secondarytotal));
		pstmt.setInt(11, systemId);
		pstmt.setInt(12, customerId);
		pstmt.setInt(13, userId);
		pstmt.setString(14,primaryPh);
		pstmt.setString(15,primaryemail);
		
	inserted1 = pstmt.executeUpdate();
	if(inserted1>0){
	inserted = insertTransactionDetailsAndBookingDetails(transaction_id,ticketNo,con,pstmt,rs,Integer.parseInt(serviceId),Integer.parseInt(rateId),seatnos,primarypaymentmode,dedicatedSeatnumbers, phoneEmailDetails,PassangerDetails, totalAmount,journeydate,systemId,customerId,roundtrip,terminalId);
	if(inserted.equals("yes")){	    			
	message = "success";	
	hash = gethashvalue(transaction_id,Double.parseDouble(secondarytotal),basepath);
	}else {
		 message = "failed";
	}	
	}
	pstmt = con.prepareStatement(PassengerBusTransportationStatements.DELETE_DETAILS_FROM_TEMP_TABLE_AFTER_TRANSACTION);		            
	pstmt.setInt(1,tempid);		    		   
	pstmt.executeUpdate();
	}else{
		message = "booked";
	}
	}catch (Exception e) {	    	
	e.printStackTrace();
	}
	finally {
	DBConnection.releaseConnectionToDB(con, pstmt, rs);        
	}
	message = message+"#"+transaction_id+"#"+hash;
	return message;

	}

public synchronized String deductAmountFromPrepaidAndCoupon(String paymentmode,String couponcode,double totalAmount,String transactionId){
	String message = "";
	Connection con = null;	   
	PreparedStatement pstmt = null;
	int update = 0;
	try {
	con = DBConnection.getConnectionToDB("AMS");	
	if(paymentmode.equals("cashcoupon")){
	pstmt = con.prepareStatement(PassengerBusTransportationStatements.DEDUCT_THE_AMOUNT_FROM_PREPAID_CARD_MASTER_SPLIT_PAYMENT);		            
    pstmt.setDouble(1,totalAmount);
	pstmt.setString(2,couponcode);
	update = pstmt.executeUpdate();
	}else if(paymentmode.equals("couponcode")){
		pstmt = con.prepareStatement(PassengerBusTransportationStatements.DEDUCT_THE_AMOUNT_FROM_PREPAID_CARD_MASTER_FOR_COUPON_CODE_SPLIT_PAYMENT);		            
	    pstmt.setDouble(1,totalAmount);
 	 	pstmt.setString(2,couponcode);	
 	 	update = pstmt.executeUpdate();
	}else if(paymentmode.equals("cash")){
		update = 1;	
	}
	if(update > 0){
		message = "success";		
	}else{
		message = "failed";	
	}
	}catch (Exception e) {	    	
	e.printStackTrace();
	}
	finally {
	DBConnection.releaseConnectionToDB(con, pstmt, null);        
	}
	return message;
	} 


public String checktransactionid(String transaction_id){
	String newTransId = transaction_id;
	Connection con = null;	   
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	try {
		con = DBConnection.getConnectionToDB("AMS");	
		pstmt = con.prepareStatement(PassengerBusTransportationStatements.CHECK_TRANSACTION_ID_TO_AVOID_DUPLICATE);		            
		pstmt.setString(1,transaction_id);
		rs = pstmt.executeQuery();
		if(rs.next()){
			newTransId = getTransactionId();	
		}
	}catch(Exception e ){
	e.printStackTrace();	
	}finally{
		DBConnection.releaseConnectionToDB(con, pstmt, rs); 	
	}	
	return newTransId;
}

public String getTimeFormat(int time,String timeString){
	String timeformat = "";	
	
	if(time >= 1 && time <= 11 ){
		timeformat = timeString+" AM";  	
	}else if(time == 0 ){
		timeformat = "12:"+timeString.substring(3,5)+" AM"; 
	}else if(time == 12) {
		timeformat = timeString+" PM";  
	}else{
		time = time%12;
	    if(time>=1 && time<=9){
	    	timeformat = "0"+time+":"+timeString.substring(3,5)+" PM";
	    }else{
	    	timeformat = +time+":"+timeString.substring(3,5)+" PM";  	
	    }				
	}
	return timeformat;
}


public JSONArray getDashboardCharts3(int systemId,int customerId) {
	JSONArray JsonArray = null;
	JSONObject JsonObject = null;
	Connection con = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	try {
		JsonArray = new JSONArray();
		con = DBConnection.getConnectionToDB("AMS");
		pstmt = con.prepareStatement(PassengerBusTransportationStatements.GET_TICKETS_COUNT_BY_WEB_AND_MOBILE);
		pstmt.setInt(1, systemId);
		pstmt.setInt(2, customerId);
		pstmt.setInt(3, systemId);
		pstmt.setInt(4, customerId);

		rs = pstmt.executeQuery();
		Map<String,String> map = new HashMap<String, String>();
		
		JsonObject = new JSONObject();
		map.put("Sun", "0,0");
		map.put("Mon", "0,0");
		map.put("Tue", "0,0");
		map.put("Wed", "0,0");
		map.put("Thu", "0,0");
		map.put("Fri", "0,0");
		map.put("Sat", "0,0");
		while (rs.next()) {
			map.put(rs.getString("JOURNEY_DATE"), rs.getString("web")+","+rs.getString("mobile"));
		}

		Set set = map.entrySet();	
		Iterator itr = set.iterator();
		while(itr.hasNext()){
			Map.Entry hm = (Map.Entry) itr.next(); 
			if(((String) hm.getKey()).equalsIgnoreCase("Sun")){
				String  SunArray[] = hm.getValue().toString().split(",");
				JsonObject.put("Sunweb", SunArray[0]);
				JsonObject.put("Sunmob", SunArray[1]);
			}else if(((String) hm.getKey()).equalsIgnoreCase("Mon")){
				String  MonArray[] = hm.getValue().toString().split(",");
				JsonObject.put("Monweb", MonArray[0]);
				JsonObject.put("Monmob", MonArray[1]);
			}else if(((String) hm.getKey()).equalsIgnoreCase("Tue")){
				String  TueArray[] = hm.getValue().toString().split(",");
				JsonObject.put("Tueweb", TueArray[0]);
				JsonObject.put("Tuemob", TueArray[1]);
			}else if(((String) hm.getKey()).equalsIgnoreCase("Wed")){
				String  WedArray[] = hm.getValue().toString().split(",");
				JsonObject.put("Wedweb", WedArray[0]);
				JsonObject.put("Wedmob", WedArray[1]);
			}else if(((String) hm.getKey()).equalsIgnoreCase("Thu")){
				String  ThuArray[] = hm.getValue().toString().split(",");
				JsonObject.put("Thuweb", ThuArray[0]);
				JsonObject.put("Thumob", ThuArray[1]);
			}else if(((String) hm.getKey()).equalsIgnoreCase("Fri")){
				String  FriArray[] = hm.getValue().toString().split(",");
				JsonObject.put("Friweb", FriArray[0]);
				JsonObject.put("Frimob", FriArray[1]);
			}else if(((String) hm.getKey()).equalsIgnoreCase("Sat")){
				String  SatArray[] = hm.getValue().toString().split(",");
				JsonObject.put("Satweb", SatArray[0]);
				JsonObject.put("Satmob", SatArray[1]);
			}
		}
		JsonArray.put(JsonObject);
		
	} catch (Exception e) {
		e.printStackTrace();
	} finally {
		DBConnection.releaseConnectionToDB(con, pstmt, rs);
	}
	return JsonArray;
}

public JSONArray getDashboardCharts4(int systemId,int customerId) {
	JSONArray JsonArray = null;
	JSONObject JsonObject = null;
	Connection con = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	try {
		JsonArray = new JSONArray();
		con = DBConnection.getConnectionToDB("AMS");
		pstmt = con.prepareStatement(PassengerBusTransportationStatements.GET_TICKETS_COUNT_BY_ROUTE);
		pstmt.setInt(1, systemId);
		pstmt.setInt(2, customerId);

		rs = pstmt.executeQuery();
		
		JsonObject = new JSONObject();

		int count=0;
		while (rs.next()) {
			count++;

			if(count==1){
				JsonObject.put("R1", rs.getString("ROUTE_NAME"));
				JsonObject.put("T1", rs.getString("TICKET_COUNT"));
			}
			if(count==2){
				JsonObject.put("R2", rs.getString("ROUTE_NAME"));
				JsonObject.put("T2", rs.getString("TICKET_COUNT"));
			}	
			if(count==3){
				JsonObject.put("R3", rs.getString("ROUTE_NAME"));
				JsonObject.put("T3", rs.getString("TICKET_COUNT"));
			}
			if(count==4){
				JsonObject.put("R4", rs.getString("ROUTE_NAME"));
				JsonObject.put("T4", rs.getString("TICKET_COUNT"));
			}
			if(count==5){
				JsonObject.put("R5", rs.getString("ROUTE_NAME"));
				JsonObject.put("T5", rs.getString("TICKET_COUNT"));
			}
		}

		JsonArray.put(JsonObject);
		
	} catch (Exception e) {
		e.printStackTrace();
	} finally {
		DBConnection.releaseConnectionToDB(con, pstmt, rs);
	}
	return JsonArray;
}


public JSONArray getDashboardCharts2(int systemId,int customerId) {
	JSONArray JsonArray = null;
	JSONObject JsonObject = null;
	Connection con = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	try {
		JsonArray = new JSONArray();
		con = DBConnection.getConnectionToDB("AMS");
		pstmt = con.prepareStatement(PassengerBusTransportationStatements.GET_TICKETS_COUNT_BY_MONTHS);
		pstmt.setInt(1, systemId);
		pstmt.setInt(2, customerId);

		rs = pstmt.executeQuery();
		Map<String,String> map = new HashMap<String, String>();
		
		JsonObject = new JSONObject();
		map.put("Jan", "0");
		map.put("Feb", "0");
		map.put("Mar", "0");
		map.put("Apr", "0");
		map.put("May", "0");
		map.put("Jun", "0");
		map.put("Jul", "0");
		map.put("Aug", "0");
		map.put("Sep", "0");
		map.put("Oct", "0");
		map.put("Nov", "0");
		map.put("Dec", "0");
		while (rs.next()) {
			map.put(rs.getString("MONTHNAME"), rs.getString("TICKET_COUNT"));
		}

		Set set = map.entrySet();	
		Iterator itr = set.iterator();
		while(itr.hasNext()){
			Map.Entry hm = (Map.Entry) itr.next(); 
			if(((String) hm.getKey()).equalsIgnoreCase("Jan")){
				JsonObject.put("Jan", hm.getValue());
			}else if(((String) hm.getKey()).equalsIgnoreCase("Feb")){
				JsonObject.put("Feb", hm.getValue());
			}else if(((String) hm.getKey()).equalsIgnoreCase("Mar")){
				JsonObject.put("Mar", hm.getValue());
			}else if(((String) hm.getKey()).equalsIgnoreCase("Apr")){
				JsonObject.put("Apr", hm.getValue());
			}else if(((String) hm.getKey()).equalsIgnoreCase("May")){
				JsonObject.put("May", hm.getValue());
			}else if(((String) hm.getKey()).equalsIgnoreCase("Jun")){
				JsonObject.put("Jun", hm.getValue());
			}else if(((String) hm.getKey()).equalsIgnoreCase("Jul")){
				JsonObject.put("Jul", hm.getValue());
			}else if(((String) hm.getKey()).equalsIgnoreCase("Aug")){
				JsonObject.put("Aug", hm.getValue());
			}else if(((String) hm.getKey()).equalsIgnoreCase("Sep")){
				JsonObject.put("Sep", hm.getValue());
			}else if(((String) hm.getKey()).equalsIgnoreCase("Oct")){
				JsonObject.put("Oct", hm.getValue());
			}else if(((String) hm.getKey()).equalsIgnoreCase("Nov")){
				JsonObject.put("Nov", hm.getValue());
			}else if(((String) hm.getKey()).equalsIgnoreCase("Dec")){
				JsonObject.put("Dec", hm.getValue());
			}
		}
		JsonArray.put(JsonObject);
		
	} catch (Exception e) {
		e.printStackTrace();
	} finally {
		DBConnection.releaseConnectionToDB(con, pstmt, rs);
	}
	return JsonArray;
}

public JSONArray getDashboardCharts1(int systemId,int customerId) {
	JSONArray JsonArray = null;
	JSONObject JsonObject = null;
	JSONObject JsonObject1 = null;
	Connection con = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	try {
		JsonArray = new JSONArray();
		con = DBConnection.getConnectionToDB("AMS");
		pstmt = con.prepareStatement(PassengerBusTransportationStatements.GET_TICKETS_COUNT_BY_DAYS);
		pstmt.setInt(1, systemId);
		pstmt.setInt(2, customerId);

		rs = pstmt.executeQuery();
		Map<String,String> map = new HashMap<String, String>();
		
		JsonObject = new JSONObject();
		map.put("Sun", "0");
		map.put("Mon", "0");
		map.put("Tue", "0");
		map.put("Wed", "0");
		map.put("Thu", "0");
		map.put("Fri", "0");
		map.put("Sat", "0");
		while (rs.next()) {
			map.put(rs.getString("WEEKDAY"), rs.getString("TICKET_COUNT"));
		}

		Set set = map.entrySet();	
		Iterator itr = set.iterator();
		while(itr.hasNext()){
			Map.Entry hm = (Map.Entry) itr.next(); 
			if(((String) hm.getKey()).equalsIgnoreCase("Sun")){
				JsonObject.put("Sun", hm.getValue());
			}else if(((String) hm.getKey()).equalsIgnoreCase("Mon")){
				JsonObject.put("Mon", hm.getValue());
			}else if(((String) hm.getKey()).equalsIgnoreCase("Tue")){
				JsonObject.put("Tue", hm.getValue());
			}else if(((String) hm.getKey()).equalsIgnoreCase("Wed")){
				JsonObject.put("Wed", hm.getValue());
			}else if(((String) hm.getKey()).equalsIgnoreCase("Thu")){
				JsonObject.put("Thu", hm.getValue());
			}else if(((String) hm.getKey()).equalsIgnoreCase("Fri")){
				JsonObject.put("Fri", hm.getValue());
			}else if(((String) hm.getKey()).equalsIgnoreCase("Sat")){
				JsonObject.put("Sat", hm.getValue());
			}
		}
		JsonArray.put(JsonObject);
		
	} catch (Exception e) {
		e.printStackTrace();
	} finally {
		DBConnection.releaseConnectionToDB(con, pstmt, rs);
	}
	return JsonArray;
}

public ArrayList<Object> getTicketSummaryReport( int systemId, int CustId, String custName, String startDate, String endDate,String jspName,int type,String language  ){
	JSONArray JsonArray = null;
	JSONObject JsonObject = null;
	Connection con = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	
	 ArrayList < ReportHelper > reportsList = new ArrayList < ReportHelper > ();
	 ArrayList < String > headersList = new ArrayList < String > ();
	 ReportHelper finalreporthelper = new ReportHelper();
	 ArrayList < Object > finlist = new ArrayList < Object > ();
	int count = 0;
	int consumerweb = 0;
	int consumermob = 0;
	int userweb = 0;
	int usermob = 0 ;
	int totalcount = 0;
	String scheduledDate = "";
	int noofbus = 0;
	String routeName = "";
	String terminalName = "";

	try {

	  headersList.add(cf.getLabelFromDB("SLNO", language));
      headersList.add(cf.getLabelFromDB("Scheduled_Date", language));
      headersList.add(cf.getLabelFromDB("No_Of_Bus", language));
      headersList.add(cf.getLabelFromDB("Terminal_Name", language));
      headersList.add(cf.getLabelFromDB("Route_Name", language));
      headersList.add(cf.getLabelFromDB("Consumer_Booking _By_Web", language));
      headersList.add(cf.getLabelFromDB("Consumer_Booking_By_Mobile", language));
      headersList.add(cf.getLabelFromDB("User_Booking_By_Web", language));
      headersList.add(cf.getLabelFromDB("User_Booking_By_Mobile", language));
      headersList.add(cf.getLabelFromDB("Total_Tickets_Booked", language));
		
		JsonArray = new JSONArray();
		con = DBConnection.getConnectionToDB("AMS");
		if(type == 1 ){
		pstmt = con.prepareStatement(PassengerBusTransportationStatements.GET_ROUTE_WISE_TICKET_SUMMARY);
		pstmt.setInt(1, systemId);
		pstmt.setInt(2, CustId);
		pstmt.setString(3, startDate);
		pstmt.setString(4, endDate);		
		rs = pstmt.executeQuery();
		}else if(type == 2 || type == 3 ){
			if(type == 2 ){
			pstmt = con.prepareStatement(PassengerBusTransportationStatements.GET_DAILY_TICKET_SOLD_BY_WEB_MOBILE);			
		}else if(type == 3 ){
			pstmt = con.prepareStatement(PassengerBusTransportationStatements.GET_MONTHLY_TICKET_SOLD_BY_WEB_MOBILE);
		}
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, CustId);
			pstmt.setString(3, startDate);
			pstmt.setString(4, endDate);
			pstmt.setInt(5, systemId);
			pstmt.setInt(6, CustId);
			pstmt.setString(7, startDate);
			pstmt.setString(8, endDate);
			pstmt.setInt(9, systemId);
			pstmt.setInt(10, CustId);
			pstmt.setString(11, startDate);
			pstmt.setString(12, endDate);
			pstmt.setInt(13, systemId);
			pstmt.setInt(14, CustId);
			pstmt.setString(15, startDate);
			pstmt.setString(16, endDate);
			rs = pstmt.executeQuery();			
		}
		while (rs.next()) {
			count++;
			JsonObject = new JSONObject();
			ArrayList < Object > informationList = new ArrayList < Object > ();
	        ReportHelper reporthelper = new ReportHelper();
	        if(type == 1){
	        scheduledDate = rs.getString("SCHEDULED_DATE");
	        noofbus = rs.getInt("NO_OF_BUS");
	        terminalName = rs.getString("TERMINAL_NAME");
	        routeName =rs.getString("ROUTE_NAME");
	        totalcount = rs.getInt("TICKET_COUNT");
	        }else if(type == 2){
	        	scheduledDate = rs.getString("JOURNEY_DATE");
	        	consumerweb = rs.getInt("WEB_CONSUMER");
	        	consumermob = rs.getInt("MOBILE_CONSUMER");
	        	userweb = rs.getInt("WEB_USER");
	        	usermob = rs.getInt("MOBILE_USER");
	        	totalcount = consumerweb+consumermob+userweb+usermob;
	        }else if(type == 3){
	        	scheduledDate = rs.getString("MONTH_YEAR");
	        	consumerweb = rs.getInt("WEB_CONSUMER");
	        	consumermob = rs.getInt("MOBILE_CONSUMER");
	        	userweb = rs.getInt("WEB_USER");
	        	usermob = rs.getInt("MOBILE_USER");
	        	totalcount = consumerweb+consumermob+userweb+usermob;
	        }
			informationList.add(count);
			JsonObject.put("slnoIndex", count);
			
			JsonObject.put("scheduledDateIndex", scheduledDate);
			informationList.add(scheduledDate);
			
			JsonObject.put("noOfBusIndex",noofbus);
			informationList.add(noofbus);			
			
			JsonObject.put("terminalNameIndex",terminalName);
			informationList.add(terminalName);			
			
			JsonObject.put("routeNameIndex",routeName);
			informationList.add(routeName);			
			
			JsonObject.put("consumerBookingByWebIndex",consumerweb);
			informationList.add(consumerweb);
			
			JsonObject.put("consumerBookingByMobileIndex",consumermob);
			informationList.add(consumermob);
			
			JsonObject.put("UserBookingBywebIndex",userweb);
			informationList.add(userweb);
			
			JsonObject.put("UserBookingByMobileIndex",usermob);
			informationList.add(usermob);
			
			JsonObject.put("totalTicketsBookedIndex",totalcount);
			informationList.add(totalcount);
			
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

public String addVehicle(String regNo,String date, int systemId,int customerId,int uniqueId,float driverExpense,float workerFee,float misfee,float dispatchFee,float insurance,float tax,float total,String vehicleNumber,String addFlag,int serviceId){
    Connection con = null;   
    PreparedStatement pstmt1 = null;
    ResultSet rs = null;
    PreparedStatement pst = null;	    
    int inserted=0;
    String message = "";
  
    try {
    	con = DBConnection.getConnectionToDB("AMS");
        			if(addFlag=="1"){
    			    pstmt1 = con.prepareStatement(PassengerBusTransportationStatements.CHECK_SERVICE_VEHICLE_NO_ASSOC_WITH_VEHICLE);	
    		    	pstmt1.setInt(1, systemId);
    		    	pstmt1.setInt(2, customerId);
    		    	pstmt1.setString(3, date);
    		    	pstmt1.setString(4, regNo);
    		    	rs=pstmt1.executeQuery();
    		    	if(rs.next())
    		    	{
    		    		message = "Vehicle Already Associated";
    		    		return message;
    		    	}   	
        	    else{
    			pst = con.prepareStatement(PassengerBusTransportationStatements.ADD_VEHICLE);
		        pst.setString(1, regNo);
		        pst.setFloat(2, driverExpense);
		        pst.setFloat(3,workerFee);
		        pst.setFloat(4, misfee);
		        pst.setFloat(5, dispatchFee);
		        pst.setFloat(6, insurance);
		        pst.setFloat(7, tax);
		        pst.setFloat(8, total);
		        pst.setInt(9, systemId);
		        pst.setInt(10, customerId);
		        pst.setInt(11,uniqueId);
		        inserted = pst.executeUpdate();
		        
		        pst = con.prepareStatement(PassengerBusTransportationStatements.UPDATE_TRANSACTION_DETAILS_REGI);
		        pst.setString(1, regNo);
		        pst.setInt(2, serviceId);
		        pst.setString(3, date);
		        pst.executeUpdate();
		        if (inserted > 0) {
		            message = "Vehicle Associated Successfully";
		            return message;
		        }
    	}
    
    	
        			}else{
        				if(regNo.equals(vehicleNumber)){
        					pst = con.prepareStatement(PassengerBusTransportationStatements.ADD_VEHICLE);
        			        pst.setString(1, regNo);
        			        pst.setFloat(2, driverExpense);
        			        pst.setFloat(3,workerFee);
        			        pst.setFloat(4, misfee);
        			        pst.setFloat(5, dispatchFee);
        			        pst.setFloat(6, insurance);
        			        pst.setFloat(7, tax);
        			        pst.setFloat(8, total);
        			        pst.setInt(9, systemId);
        			        pst.setInt(10, customerId);
        			        pst.setInt(11,uniqueId);
        			        inserted = pst.executeUpdate();
        			        
        			        pst = con.prepareStatement(PassengerBusTransportationStatements.UPDATE_TRANSACTION_DETAILS_REGI);
        			        pst.setString(1, regNo);
        			        pst.setInt(2, serviceId);
        			        pst.setString(3, date);
        			        pst.executeUpdate();
        			        if (inserted > 0) {
        			            message = "Vehicle Associated Successfully";
        			            return message;
        			        }
        				
        				}else{
        					pstmt1 = con.prepareStatement(PassengerBusTransportationStatements.CHECK_SERVICE_VEHICLE_NO_ASSOC_WITH_VEHICLE);	
            		    	pstmt1.setInt(1, systemId);
            		    	pstmt1.setInt(2, customerId);
            		    	pstmt1.setString(3, date);
            		    	pstmt1.setString(4, regNo);
            		    	rs=pstmt1.executeQuery();
            		    	if(rs.next())
            		    	{
            		    		message = "vehicle already associated";
            		    		return message;
            		    	}   	else{
        					pst = con.prepareStatement(PassengerBusTransportationStatements.ADD_VEHICLE);
        			        pst.setString(1, regNo);
        			        pst.setFloat(2, driverExpense);
        			        pst.setFloat(3,workerFee);
        			        pst.setFloat(4, misfee);
        			        pst.setFloat(5, dispatchFee);
        			        pst.setFloat(6, insurance);
        			        pst.setFloat(7, tax);
        			        pst.setFloat(8, total);
        			        pst.setInt(9, systemId);
        			        pst.setInt(10, customerId);
        			        pst.setInt(11,uniqueId);
        			        inserted = pst.executeUpdate();
        			        pst = con.prepareStatement(PassengerBusTransportationStatements.UPDATE_TRANSACTION_DETAILS_REGI);
        			        pst.setString(1, regNo);
        			        pst.setInt(2, serviceId);
        			        pst.setString(3, date);
        			        pst.executeUpdate();
        			        if (inserted > 0) {
        			            message = "Vehicle Associated Successfully";
        			            return message;
        			        }
        				}
        				}
        			}
    }
         catch (Exception e) {	        	
        	e.printStackTrace();
        } finally {     
        DBConnection.releaseConnectionToDB(con, pst, rs);	       
        DBConnection.releaseConnectionToDB(null, pstmt1, null);	 
    }
  return message;
}

public JSONArray getVehicles(int systemId,int customerId,int userId){
	JSONArray jsonArray = new JSONArray();
	Connection con = null;
	PreparedStatement pstmt1 = null;
	ResultSet rs = null;
	try {
		con = DBConnection.getConnectionToDB("AMS");
		pstmt1 = con.prepareStatement(PassengerBusTransportationStatements.GET_VEHICLES_TICKET_DETAIS);
		pstmt1.setInt(1, customerId);
		pstmt1.setInt(2, systemId);
		pstmt1.setInt(3, userId);
		rs = pstmt1.executeQuery();
		JSONObject vehicleDetailsObject = new JSONObject();
		while (rs.next()) {
			vehicleDetailsObject = new JSONObject();
			vehicleDetailsObject.put("TypeName", rs.getString("REGISTRATION_NO"));
			jsonArray.put(vehicleDetailsObject);
		}
	} catch (Exception e) {
		e.printStackTrace();
	} finally {
        DBConnection.releaseConnectionToDB(con, pstmt1, rs);	 
	}
	return jsonArray;
}

public static String gethashvalue(String transId,double amount,String basepath) throws Exception{
	String productid ="6205";
	String payitemid = "101";
	Long L = Math.round(amount);
	int totalamountinCoupon = Integer.valueOf(L.intValue());
	String tot = totalamountinCoupon+"00";
	String mackey = "D3D1D05AFE42AD50818167EAC73C109168A0F108F32645C8B59E897FA930DA44F9230910DAC9E20641823799A107A02068F7BC0F4CC41D2952E249552255710F";
    String hashinput = transId+productid+payitemid+tot+basepath+"Jsps/PassengerBusTransportation/Response.jsp"+mackey;
    String hash = hashText(hashinput).toUpperCase();
	return hash;
}

public static String hashText(String textToHash) throws Exception
{
    final MessageDigest sha512 = MessageDigest.getInstance("SHA-512");
    sha512.update(textToHash.getBytes());   
    return convertByteToHex(sha512.digest());
}
public static String convertByteToHex(byte data[])
{
    StringBuffer hexData = new StringBuffer();
    for (int byteIndex = 0; byteIndex < data.length; byteIndex++)
        hexData.append(Integer.toString((data[byteIndex] & 0xff) + 0x100, 16).substring(1));   
    return hexData.toString();
}

public  String getTransactionDetails(String transaction) throws Exception{
	Connection dbcon = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	dbcon = DBConnection.getConnectionToDB("AMS");
	String status = "";
	String productid = "6205";
	String mackey = "D3D1D05AFE42AD50818167EAC73C109168A0F108F32645C8B59E897FA930DA44F9230910DAC9E20641823799A107A02068F7BC0F4CC41D2952E249552255710F";
	String amount = getAmountOfTransactionUsingDebitcaard(transaction,dbcon,pstmt,rs);
	String hashinput = productid+transaction+mackey;
    String hash = hashText(hashinput).toUpperCase();
	
    try {
		try {
			doTrustToCertificates();
		} catch (Exception e) {
			e.printStackTrace();
		}
		URL url = new URL("https://stageserv.interswitchng.com/test_paydirect/api/v1/gettransaction.json?productid=6205&transactionreference="+transaction+"&amount="+amount+"");
		HttpsURLConnection conn = (HttpsURLConnection)url.openConnection();
		conn.setRequestMethod("GET");			
		conn.addRequestProperty("Hash", hash);			
		BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream()));
		String apiOutput = br.readLine();
		JSONObject obj = new JSONObject(apiOutput);
		String responseCode = obj.getString("ResponseCode");
		status = responseCode;
		String responseDescription = obj.getString("ResponseDescription");
		String transactiondate = obj.getString("TransactionDate");
		transactiondate = transactiondate.replace("T", " ");
		String paymentref = obj.getString("PaymentReference");
		conn.disconnect();
		if(status.equalsIgnoreCase("00")){
		primaryPaymentDeduction(transaction,dbcon,pstmt,rs);		
		}
		pstmt = dbcon.prepareStatement(PassengerBusTransportationStatements.CHECK_TRANSACTION_ID_ALREADY_EXIST);
		pstmt.setString(1, transaction);
		rs = pstmt.executeQuery();
		if(rs.next())
		{
			updateTransactionDetailsToDB(transaction,amount,responseCode,responseDescription,dbcon,pstmt,rs,transactiondate,paymentref);
		}
		else
		{
		insertTransactionDetailsToDB(transaction,amount,responseCode,responseDescription,dbcon,pstmt,rs,transactiondate,paymentref);
		}
		
	} catch (MalformedURLException e) {			
		e.printStackTrace();
	} catch (ProtocolException e) {			
		e.printStackTrace();
	} catch (IOException e) {			
		e.printStackTrace();
	}
	finally{
		DBConnection.releaseConnectionToDB(dbcon, pstmt, rs);
	}
	return status;
}

public	static  void doTrustToCertificates() throws Exception {
    Security.addProvider(new com.sun.net.ssl.internal.ssl.Provider());
    TrustManager[] trustAllCerts = new TrustManager[]{
            new X509TrustManager() {
                public void checkServerTrusted(X509Certificate[] certs, String authType) throws CertificateException {
                    return;
                }
                public void checkClientTrusted(X509Certificate[] certs, String authType) throws CertificateException {
                    return;
                }
				public X509Certificate[] getAcceptedIssuers() {
					return null;
				}
            }
    };

    SSLContext sc = SSLContext.getInstance("SSL");
    sc.init(null, trustAllCerts, new SecureRandom());
    HttpsURLConnection.setDefaultSSLSocketFactory(sc.getSocketFactory());
}

public static String getAmountOfTransactionUsingDebitcaard(String transaction,Connection con, PreparedStatement pstmt,ResultSet rs){
	String totalAmount = "";
	double amount = 0.0;
	try {
		pstmt = con.prepareStatement(PassengerBusTransportationStatements.GET_AMOUNT_OF_TRANSACTION);
		pstmt.setString(1, transaction);
		rs = pstmt.executeQuery();
		if(rs.next()){
			if( rs.getString("PAYMENT_MODE").equalsIgnoreCase("debitcard") &&  rs.getString("PRI_PAYMENT_AMOUNT") == null ){
				amount = rs.getDouble("TOTAL_AMOUNT");	
			}else if( rs.getString("SEC_PAYMENT_MODE").equalsIgnoreCase("debitcard") && rs.getString("SEC_PAYMENT_AMOUNT") != null ){
				amount = rs.getDouble("SEC_PAYMENT_AMOUNT");	
			}
		}
		Long L = Math.round(amount);
		int totalamountinCoupon = Integer.valueOf(L.intValue());
		totalAmount = totalamountinCoupon+"00";
		
	} catch (Exception e) {
		e.printStackTrace();
	}
	return totalAmount;
}

private void insertTransactionDetailsToDB(String transaction,String amount,String responseCode,String responseDescription,Connection dbcon,PreparedStatement pstmt,ResultSet rs,String transactiondate,String paymentref){
	String  amount2 =amount.substring(0,amount.length()-2) ;
	if(transactiondate.charAt(0) == '0'){
	transactiondate = "";	
	}
	try {
		pstmt = dbcon.prepareStatement(PassengerBusTransportationStatements.INSERT_INTO_GATEWAY_DETAILS);
		pstmt.setString(1, transaction);
		pstmt.setDouble(2, Double.parseDouble(amount2));
		pstmt.setString(3, responseCode);
		pstmt.setString(4,responseDescription);
		pstmt.setString(5,transactiondate);
		pstmt.setString(6, paymentref);
		pstmt.executeUpdate();
	} catch (Exception e) {
		e.printStackTrace();
	}	
}
private void updateTransactionDetailsToDB(String transaction,String amount,String responseCode,String responseDescription,Connection dbcon,PreparedStatement pstmt,ResultSet rs,String transactiondate,String paymentref){
	String  amount2 =amount.substring(0,amount.length()-2) ;
	if(transactiondate.charAt(0) == '0'){
	transactiondate = "";	
	}
	try {
		pstmt = dbcon.prepareStatement(PassengerBusTransportationStatements.UPDATE_INTO_GATEWAY_DETAILS);
		pstmt.setDouble(1, Double.parseDouble(amount2));
		pstmt.setString(2, responseCode);
		pstmt.setString(3,responseDescription);
		pstmt.setString(4,transactiondate);
		pstmt.setString(5, paymentref);
		pstmt.setString(6, transaction);
		pstmt.executeUpdate();
	} catch (Exception e) {
		e.printStackTrace();
	}	
}



private void primaryPaymentDeduction(String transaction,Connection con, PreparedStatement pstmt,ResultSet rs){
	double amount = 0.0;
	String cardNumber = "";
	try {
		pstmt = con.prepareStatement(PassengerBusTransportationStatements.GET_AMOUNT_OF_TRANSACTION);
		pstmt.setString(1, transaction);
		rs = pstmt.executeQuery();
		if(rs.next()){
			if( rs.getString("PAYMENT_MODE").equalsIgnoreCase("prepaidcard") ||  rs.getString("PAYMENT_MODE").equalsIgnoreCase("couponcode") ){
				amount = rs.getDouble("PRI_PAYMENT_AMOUNT");
				cardNumber = rs.getString("COUPON_CODE");
			}
		pstmt = con.prepareStatement(PassengerBusTransportationStatements.DEDUCT_CARD_AMOUNT);
		pstmt.setDouble(1,amount);
	 	pstmt.setString(2,cardNumber);	
		pstmt.executeUpdate();
		}				
	} catch (Exception e) {
		e.printStackTrace();
	}
}

public JSONArray getRouteNameTicketDetails(int systemId,int customerId){
	JSONArray jsonArray = new JSONArray();
	Connection con = null;
	PreparedStatement pstmt1 = null;
	ResultSet rs = null;
	try {
		con = DBConnection.getConnectionToDB("AMS");
		pstmt1 = con.prepareStatement(PassengerBusTransportationStatements.GET_ROUTE_NAME_TICKET_DETAIS);
		pstmt1.setInt(1, customerId);
		pstmt1.setInt(2, systemId);
		rs = pstmt1.executeQuery();
		JSONObject vehicleDetailsObject = new JSONObject();
		while (rs.next()) {
			vehicleDetailsObject = new JSONObject();
			vehicleDetailsObject.put("TypeName", rs.getString("ROUTE_NAME"));
			jsonArray.put(vehicleDetailsObject);
		}
	} catch (Exception e) {
		e.printStackTrace();
	} finally {
        DBConnection.releaseConnectionToDB(con, pstmt1, rs);	 
	}
	return jsonArray;
}


public JSONArray getTerminalNameTicketDetails(int systemId,int customerId){
	JSONArray jsonArray = new JSONArray();
	Connection con = null;
	PreparedStatement pstmt1 = null;
	ResultSet rs = null;
	try {
		con = DBConnection.getConnectionToDB("AMS");
		pstmt1 = con.prepareStatement(PassengerBusTransportationStatements.GET_TERMINAL_NAME_TICKET_DETAIS);
		pstmt1.setInt(1, customerId);
		pstmt1.setInt(2, systemId);
		rs = pstmt1.executeQuery();
		JSONObject vehicleDetailsObject = new JSONObject();
		while (rs.next()) {
			vehicleDetailsObject = new JSONObject();
			vehicleDetailsObject.put("TypeName", rs.getString("TERMINAL_NAME"));
			jsonArray.put(vehicleDetailsObject);
		}
	} catch (Exception e) {
		e.printStackTrace();
	} finally {
        DBConnection.releaseConnectionToDB(con, pstmt1, rs);	 
	}
	return jsonArray;
}

public ArrayList<Object> getTicketDetailsDayWise(int systemId,int customerId,String Type,String fromDate,String toDate,String names){
	JSONArray jsonArray = new JSONArray();
	Connection con = null;
	PreparedStatement pstmt1 = null;
	ResultSet rs = null;
	ArrayList < ReportHelper > reportsList = new ArrayList < ReportHelper > ();
	ArrayList < String > headersList = new ArrayList < String > ();
	ReportHelper finalreporthelper = new ReportHelper();
	ArrayList < Object > finlist = new ArrayList < Object > ();
	SimpleDateFormat diffddMMyyyyHHmmss = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
	String departuretime="";
	try {
		headersList.add("SLNO");
	    headersList.add("Scheduled_Date");
	    headersList.add("Month");
	    headersList.add("Time");
	    headersList.add("Vehicle No");
	    headersList.add("Route Name");
	    headersList.add("Vehicle Type");
	    headersList.add("Total Sold");
	    headersList.add("Terminal");
	    headersList.add("Origin");
	    headersList.add("Destination");
	    headersList.add("Duration");
		con = DBConnection.getConnectionToDB("AMS");
		int count=0;
		String[] typeNames=null;
		typeNames=names.split(",");
		String type="";
		for(String s:typeNames)
		{
			type=type+"'"+s+"'"+",";
		}
		type = type.substring(0, type.length() - 1);
		if(Type.equals("01")){
			pstmt1 = con.prepareStatement(PassengerBusTransportationStatements.GET_TICKET_DETAIS_ROUTE_WISE.replace("#", type));
			
		}else if(Type.equals("02")){
			pstmt1 = con.prepareStatement(PassengerBusTransportationStatements.GET_TICKET_DETAIS_VEHICLE_WISE.replace("#", type));
			
		}else if(Type.equals("03")){
			pstmt1 = con.prepareStatement(PassengerBusTransportationStatements.GET_TICKET_DETAIS_TERMINAL_WISE.replace("#", type));
			
		}
		pstmt1.setString(1, fromDate);
		pstmt1.setString(2, toDate);
		pstmt1.setInt(3, customerId);
		pstmt1.setInt(4, systemId);
		rs = pstmt1.executeQuery();
		JSONObject vehicleDetailsObject = new JSONObject();
		

		while (rs.next()) {
			ArrayList < Object > informationList = new ArrayList < Object > ();
			ReportHelper reporthelper = new ReportHelper();
			vehicleDetailsObject = new JSONObject();
			count++;
			informationList.add(count);
			vehicleDetailsObject.put("slnoIndex", count);
			
			informationList.add(diffddMMyyyyHHmmss.format(rs.getTimestamp("JOURNEY_DATE")));
			vehicleDetailsObject.put("scheduleDateDataIndex", rs.getString("JOURNEY_DATE"));
			
			informationList.add(rs.getString("MONTHNAME"));
			vehicleDetailsObject.put("monthDataIndex", rs.getString("MONTHNAME"));
			
			
			departuretime = rs.getString("DEPARTURE_TIME");

			String departuretimeFormat = departuretime.substring(0,departuretime.indexOf(":"));
			departuretime = getTimeFormat(Integer.parseInt(departuretimeFormat),departuretime);
			informationList.add(departuretime);
			vehicleDetailsObject.put("timeDataIndex", departuretime);
			
			informationList.add(rs.getString("REGISTRATION_NO"));
			vehicleDetailsObject.put("vehicleNoDataIndex", rs.getString("REGISTRATION_NO"));
			
			informationList.add(rs.getString("ROUTE_NAME"));
			vehicleDetailsObject.put("routeNameDataIndex", rs.getString("ROUTE_NAME"));
			
			informationList.add(rs.getString("VEHICLE_MODEL"));
			vehicleDetailsObject.put("vehicleTypeDataIndex", rs.getString("VEHICLE_MODEL"));
			
			informationList.add(rs.getString("TOTAL_TICKET_SOLD"));
			vehicleDetailsObject.put("totalSoldDataIndex", rs.getString("TOTAL_TICKET_SOLD"));
			
			informationList.add(rs.getString("TERMINAL_NAME"));
			vehicleDetailsObject.put("terminalDataIndex", rs.getString("TERMINAL_NAME"));
			
			informationList.add(rs.getString("SOURCE"));
			vehicleDetailsObject.put("originDataIndex", rs.getString("SOURCE"));
			
			informationList.add(rs.getString("DESTINATION"));
			vehicleDetailsObject.put("destinationDataIndex", rs.getString("DESTINATION"));
			
			informationList.add(rs.getString("DURATION"));
			vehicleDetailsObject.put("durationDataIndex", rs.getString("DURATION"));
		
			jsonArray.put(vehicleDetailsObject);
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
        DBConnection.releaseConnectionToDB(con, pstmt1, rs);	 
	}
	return finlist;
}

public JSONArray getTicketDetailsMonthWise(int systemId,int customerId){
	JSONArray jsonArray = new JSONArray();
	Connection con = null;
	PreparedStatement pstmt1 = null;
	ResultSet rs = null;
	try {
		con = DBConnection.getConnectionToDB("AMS");
		pstmt1 = con.prepareStatement(PassengerBusTransportationStatements.GET_TERMINAL_NAME_TICKET_DETAIS);
		pstmt1.setInt(1, customerId);
		pstmt1.setInt(2, systemId);
		rs = pstmt1.executeQuery();
		JSONObject vehicleDetailsObject = new JSONObject();
		while (rs.next()) {
			vehicleDetailsObject = new JSONObject();
			vehicleDetailsObject.put("TypeName", rs.getString("TERMINAL_NAME"));
			jsonArray.put(vehicleDetailsObject);
		}
	} catch (Exception e) {
		e.printStackTrace();
	} finally {
        DBConnection.releaseConnectionToDB(con, pstmt1, rs);	 
	}
	return jsonArray;
}



public ArrayList<Object> getProfitAndLossData(int systemId,int customerId,String Type,String fromDate,String toDate,String names,int offset){
	JSONArray jsonArray = new JSONArray();
	Connection con = null;
	PreparedStatement pstmt1 = null;
	ResultSet rs = null,rs1=null;
	ArrayList < ReportHelper > reportsList = new ArrayList < ReportHelper > ();
	ArrayList < String > headersList = new ArrayList < String > ();
	ReportHelper finalreporthelper = new ReportHelper();
	ArrayList < Object > finlist = new ArrayList < Object > ();		
	SimpleDateFormat yyyymmdd = new SimpleDateFormat("yyyy-MM-dd");	
	SimpleDateFormat ddmmyyyyhhmmss = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");	
	float maintanenceExpence=0;
	float netProfit=0;
	float totalIncom=0;
	float tripExpense=0;
	String vehicleNoList="";	
	float totalIncome=0;
	float totalTripExpense=0;
	float totalMaintanenceExpense=0;
	float totalNetProfit=0;
	TreeMap<String, Object> plData = new TreeMap<String, Object>();
	TreeMap<String, Object> plDataJobCardData = new TreeMap<String, Object>();
	HashSet<String> set = new HashSet<String>();	
	try {
		headersList.add("SLNO");
	    headersList.add("Service Name");
	    headersList.add("No Of Days Operated");
	    headersList.add("Route Name");
	    headersList.add("Terminal Name");
	    headersList.add("No Of Seats Booked");
	    headersList.add("Vehicle No");
	    headersList.add("Date");
	    headersList.add("Month");
	    headersList.add("Total Income On Ticket");
	    headersList.add("Trip Expense");
	    headersList.add("Maintainence Expense");
	    headersList.add("Net Profit");
		con = DBConnection.getConnectionToDB("AMS");
		int count=0;
		String[] typeNames=null;
		typeNames=names.split(",");
		String type="";
		for(String s:typeNames)
		{
			type=type+"'"+s+"'"+",";
		}
		type = type.substring(0, type.length() - 1);		
		
		if(Type.equals("01")){
			pstmt1 = con.prepareStatement(PassengerBusTransportationStatements.GET_PROFIT_AND_LOSS_DATA_ROUTE_WISE.replace("#", type));
			
		}else if(Type.equals("02")){
			pstmt1 = con.prepareStatement(PassengerBusTransportationStatements.GET_PROFIT_AND_LOSS_DATA_VEHICLE_WISE.replace("#", type));
			
		}else if(Type.equals("03")){
			pstmt1 = con.prepareStatement(PassengerBusTransportationStatements.GET_PROFIT_AND_LOSS_DATA_TERMINAL_WISE.replace("#", type));
			
		}
		pstmt1.setInt(1, systemId);
		pstmt1.setInt(2, customerId);
		pstmt1.setInt(3, offset);
		pstmt1.setInt(4, offset);
		pstmt1.setInt(5, systemId);
		pstmt1.setInt(6, customerId);
		pstmt1.setInt(7, offset);
		pstmt1.setInt(8, offset);
		pstmt1.setString(9, fromDate);
		pstmt1.setString(10, toDate);
		pstmt1.setInt(11, systemId);
		pstmt1.setInt(12, customerId);
		rs = pstmt1.executeQuery();
		JSONObject vehicleDetailsObject = new JSONObject();
		

		while (rs.next()) {
			set.add(rs.getString("REGISTRATION_NUMBER"));			
			ProftAndLossBean pl = new ProftAndLossBean();		
			pl.setServiceName(rs.getString("SERVICE_NAME"));
			pl.setJourneyDate(rs.getString("JOURNEY_DATE"));
			pl.setMaintanenceExpense(Float.parseFloat(rs.getString("MAINTANENCE_EXPENSE")));
			pl.setRegistrationNo(rs.getString("REGISTRATION_NUMBER"));
			pl.setRouteName(rs.getString("ROUTE_NAME"));
			pl.setTerminalName(rs.getString("TERMINAL_NAME"));
			pl.setTotalAmount(Float.parseFloat(rs.getString("TOTAL_AMOUNT")));
			pl.setTotalSeats(rs.getInt("TOTAL_SEATS"));
			pl.setTripExpense(Float.parseFloat(rs.getString("TRIP_EXPENSE")));			
			plData.put(rs.getString("REGISTRATION_NUMBER")+"-"+rs.getString("JOURNEY_DATE"), pl);
			
		}
		if(set.size()!=0){
			for(String s :set){
				vehicleNoList=vehicleNoList+"'"+s+"'"+",";
			}
			vehicleNoList = vehicleNoList.substring(0, vehicleNoList.length() - 1);
			pstmt1 = con.prepareStatement(PassengerBusTransportationStatements.GET_ACTUAL_AMOUNT.replace("#", vehicleNoList));
			pstmt1.setInt(1, offset);
			pstmt1.setInt(2, offset);
			pstmt1.setString(3, fromDate);
			pstmt1.setInt(4, offset);
			pstmt1.setString(5, toDate);
			pstmt1.setInt(6, systemId);
			pstmt1.setInt(7, customerId);
			pstmt1.setInt(8, offset);
			pstmt1.setInt(9, offset);
			pstmt1.setString(10, fromDate);
			pstmt1.setInt(11, offset);
			pstmt1.setString(12, toDate);
			pstmt1.setInt(13, systemId);
			pstmt1.setInt(14, customerId);
			rs1 = pstmt1.executeQuery();
			while(rs1.next()){
				if(plDataJobCardData.containsKey(rs1.getString("RegistrationNo")+"-"+rs1.getString("CLOSED_DATE"))){
					ProftAndLossBean pl1=(ProftAndLossBean) plDataJobCardData.get(rs1.getString("RegistrationNo")+"-"+rs1.getString("CLOSED_DATE"));
					float result=pl1.getMaintanenceExpense()+rs1.getFloat("ActualCost");
					pl1.setMaintanenceExpense(result);
					plDataJobCardData.put(rs1.getString("RegistrationNo")+"-"+rs1.getString("CLOSED_DATE"), pl1);
				}else{
					ProftAndLossBean pl2 = new ProftAndLossBean();
					pl2.setMaintanenceExpense(rs1.getFloat("ActualCost"));
					plDataJobCardData.put(rs1.getString("RegistrationNo")+"-"+rs1.getString("CLOSED_DATE"), pl2);
				}
			}
		}
		
		
		for(Map.Entry<String, Object> entry : plDataJobCardData.entrySet()){
			if(!plData.containsKey(entry.getKey())){
				String searchResultCeiling=plData.ceilingKey(entry.getKey());
				if(searchResultCeiling!=null){
					ProftAndLossBean pl3=(ProftAndLossBean) entry.getValue();
					ProftAndLossBean pl4=(ProftAndLossBean)plData.get(searchResultCeiling);
					float tempResult=pl3.getMaintanenceExpense()+pl4.getMaintanenceExpense();
					pl4.setMaintanenceExpense(tempResult);
					plData.put(searchResultCeiling, pl4);
				}else{
					String searchResultFloor=plData.floorKey(entry.getKey());
					ProftAndLossBean pl3=(ProftAndLossBean) entry.getValue();
					ProftAndLossBean pl4=(ProftAndLossBean)plData.get(searchResultFloor);
					float tempResult=pl3.getMaintanenceExpense()+pl4.getMaintanenceExpense();
					pl4.setMaintanenceExpense(tempResult);
					plData.put(searchResultFloor, pl4);
				}
			}
			
		}
		
		
		int mapCount=0;
		for(Map.Entry<String, Object> entry : plData.entrySet()){
			mapCount++;
			tripExpense=0;
			totalIncom=0;
			maintanenceExpence=0;
			netProfit=0;
			ProftAndLossBean pl=(ProftAndLossBean) entry.getValue();
			tripExpense=pl.getTripExpense();
			totalIncom=pl.getTotalAmount();		
			maintanenceExpence=pl.getMaintanenceExpense();
			netProfit=totalIncom-(tripExpense+maintanenceExpence);
			pl.setNetProfit(netProfit);
			
			totalIncome=totalIncome+ pl.getTotalAmount();
			totalTripExpense=totalTripExpense+pl.getTripExpense();
			totalMaintanenceExpense=totalMaintanenceExpense+pl.getMaintanenceExpense();
			totalNetProfit=totalNetProfit+pl.getNetProfit();
			ArrayList < Object > informationList = new ArrayList < Object > ();
			ReportHelper reporthelper = new ReportHelper();
			vehicleDetailsObject = new JSONObject();
			count++;
			informationList.add(count);
			vehicleDetailsObject.put("slnoIndex", count);
			
			informationList.add(pl.getServiceName());
			vehicleDetailsObject.put("serviceNoDataIndex", pl.getServiceName());			
			
			informationList.add("");
			vehicleDetailsObject.put("noOfdaysIndex", "");
			
			informationList.add(pl.getRouteName());
			vehicleDetailsObject.put("routeNameDataIndex", pl.getRouteName());
			
			informationList.add(pl.getTerminalName());
			vehicleDetailsObject.put("terminalNameDataIndex", pl.getTerminalName());
			
			informationList.add(pl.getTotalSeats());
			vehicleDetailsObject.put("noOfSeatsDataIndex", pl.getTotalSeats());
			
			informationList.add(pl.getRegistrationNo());
			vehicleDetailsObject.put("vehicleNoDataIndex",pl.getRegistrationNo());
			
			informationList.add(pl.getJourneyDate());		
			vehicleDetailsObject.put("dateindex",ddmmyyyyhhmmss.format(yyyymmdd.parse(pl.getJourneyDate())));			
			
			informationList.add("");		
			vehicleDetailsObject.put("monthindex","");
			
			informationList.add(pl.getTotalAmount());
			vehicleDetailsObject.put("totalIncomeDataIndex", Float.valueOf(pl.getTotalAmount()).toString());			
			informationList.add(pl.getTripExpense());			
			vehicleDetailsObject.put("tripExpenseDataIndex",Float.valueOf(pl.getTripExpense()));
			informationList.add(pl.getMaintanenceExpense());		
			vehicleDetailsObject.put("mainExpenseDataIndex",Float.valueOf( pl.getMaintanenceExpense()));			
			informationList.add(pl.getNetProfit());
			vehicleDetailsObject.put("netProfitDataIndex", Float.valueOf(pl.getNetProfit()));
			jsonArray.put(vehicleDetailsObject);
			reporthelper.setInformationList(informationList);
	        reportsList.add(reporthelper);
			if(plData.size()==mapCount){		
				informationList = new ArrayList < Object > ();
				vehicleDetailsObject = new JSONObject();
				reporthelper = new ReportHelper();
				count++;
				informationList.add(count);
				vehicleDetailsObject.put("slnoIndex", count);
				
				informationList.add("");
				vehicleDetailsObject.put("serviceNoDataIndex","<b>Total</b>");
				
				informationList.add("");
				vehicleDetailsObject.put("noOfdaysIndex","");
				
				informationList.add("");
				vehicleDetailsObject.put("routeNameDataIndex", "");
				
				informationList.add("");
				vehicleDetailsObject.put("terminalNameDataIndex", "");
				
				informationList.add("");
				vehicleDetailsObject.put("noOfSeatsDataIndex", "");
				
				informationList.add("");
				vehicleDetailsObject.put("vehicleNoDataIndex","");
				
				informationList.add("");		
				vehicleDetailsObject.put("dateindex","");			
				
				informationList.add("");		
				vehicleDetailsObject.put("monthindex","");	
				
				informationList.add(totalIncome);
				vehicleDetailsObject.put("totalIncomeDataIndex", "<b>"+totalIncome+"</b>");			
				informationList.add(totalTripExpense);			
				vehicleDetailsObject.put("tripExpenseDataIndex","<b>"+totalTripExpense+"</b>");
				informationList.add(totalMaintanenceExpense);		
				vehicleDetailsObject.put("mainExpenseDataIndex", "<b>"+totalMaintanenceExpense+"</b>");			
				informationList.add(totalNetProfit);
				vehicleDetailsObject.put("netProfitDataIndex", "<b>"+totalNetProfit+"</b>");
				
				jsonArray.put(vehicleDetailsObject);
				reporthelper.setInformationList(informationList);
		        reportsList.add(reporthelper);
			}
		
			
			
		}			
		
		finalreporthelper.setReportsList(reportsList);
        finalreporthelper.setHeadersList(headersList);
        finlist.add(jsonArray);
        finlist.add(finalreporthelper);
	} catch (Exception e) {
		e.printStackTrace();
	} finally {
        DBConnection.releaseConnectionToDB(con, pstmt1, rs);	 
        DBConnection.releaseConnectionToDB(null, null, rs1);
	}
	return finlist;
}

public ArrayList<Object> getMonthlyProfitAndLossData(int systemId,int customerId,String Type,String fromMonth,String toMonth,String fromYear,String toYear, String names,int offset){
	JSONArray jsonArray = new JSONArray();
	Connection con = null;
	PreparedStatement pstmt1 = null;
	ResultSet rs = null,rs1=null;
	ArrayList < ReportHelper > reportsList = new ArrayList < ReportHelper > ();
	ArrayList < String > headersList = new ArrayList < String > ();
	ReportHelper finalreporthelper = new ReportHelper();
	ArrayList < Object > finlist = new ArrayList < Object > ();	
	float maintanenceExpence=0;
	float netProfit=0;
	float totalIncom=0;
	float tripExpense=0;
	String vehicleNoList="";	
	float totalIncome=0;
	float totalTripExpense=0;
	float totalMaintanenceExpense=0;
	float totalNetProfit=0;
	TreeMap<String, Object> plData = new TreeMap<String, Object>();
	TreeMap<String, Object> plDataJobCardData = new TreeMap<String, Object>();
	HashSet<String> set = new HashSet<String>();

	try {
		headersList.add("SLNO");
	    headersList.add("Service Name");
	    headersList.add("No Of Days Operated");
	    headersList.add("Route Name");
	    headersList.add("Terminal Name");
	    headersList.add("No Of Seats Booked");
	    headersList.add("Vehicle No");
	    headersList.add("Date");
	    headersList.add("Month");
	    headersList.add("Total Income On Ticket");
	    headersList.add("Trip Expense");
	    headersList.add("Maintainence Expense");
	    headersList.add("Net Profit");
		con = DBConnection.getConnectionToDB("AMS");
		int count=0;
		String[] typeNames=null;
		typeNames=names.split(",");
		String type="";
		for(String s:typeNames)
		{
			type=type+"'"+s+"'"+",";
		}
		type = type.substring(0, type.length() - 1);
				
		if(Type.equals("01")){
			pstmt1 = con.prepareStatement(PassengerBusTransportationStatements.GET_MONTHLY_PROFIT_AND_LOSS_DATA_ROUTE_WISE.replace("#", type));
			
		}else if(Type.equals("02")){
			pstmt1 = con.prepareStatement(PassengerBusTransportationStatements.GET_MONTHLY_PROFIT_AND_LOSS_DATA_VEHICLE_WISE.replace("#", type));
			
		}else if(Type.equals("03")){
			pstmt1 = con.prepareStatement(PassengerBusTransportationStatements.GET_MONTHLY_PROFIT_AND_LOSS_DATA_TERMINAL_WISE.replace("#", type));
			
		}
		
		pstmt1.setInt(1, Integer.parseInt(fromMonth));
		pstmt1.setString(2, fromYear);
		pstmt1.setInt(3, Integer.parseInt(toMonth));
		pstmt1.setString(4, toYear);
		pstmt1.setInt(5, systemId);
		pstmt1.setInt(6, customerId);		
		rs = pstmt1.executeQuery();
		JSONObject vehicleDetailsObject = new JSONObject();
		

		while (rs.next()) {
			set.add(rs.getString("REGISTRATION_NUMBER"));			
			ProftAndLossBean pl = new ProftAndLossBean();			
			pl.setServiceName(rs.getString("DAYS_OPERATED"));
			pl.setJourneyDate(rs.getString("MONTHNAME"));			
			pl.setRegistrationNo(rs.getString("REGISTRATION_NUMBER"));		
			pl.setTerminalName(rs.getString("TERMINAL_NAME"));
			pl.setTotalAmount(Float.parseFloat(rs.getString("TOTAL_AMOUNT")));
			pl.setTotalSeats(rs.getInt("TOTAL_SEATS"));
			pl.setTripExpense(Float.parseFloat(rs.getString("TRIP_EXPENSE")));			
			plData.put(rs.getString("REGISTRATION_NUMBER")+"-"+rs.getString("MONTH_NUMBER"), pl);
			
		}
		if(set.size()!=0){
			for(String s :set){
				vehicleNoList=vehicleNoList+"'"+s+"'"+",";
			}
			vehicleNoList = vehicleNoList.substring(0, vehicleNoList.length() - 1);
			pstmt1 = con.prepareStatement(PassengerBusTransportationStatements.GET_MONTHLY_ACTUAL_AMOUNT.replace("#", vehicleNoList));
			pstmt1.setInt(1, offset);
			pstmt1.setInt(2, offset);
			pstmt1.setInt(3, Integer.parseInt(fromMonth));
			pstmt1.setString(4, fromYear);
			pstmt1.setInt(5, offset);
			pstmt1.setInt(6, Integer.parseInt(toMonth));
			pstmt1.setString(7, toYear);
			pstmt1.setInt(8, systemId);
			pstmt1.setInt(9, customerId);
			pstmt1.setInt(10, offset);
			pstmt1.setInt(11, offset);
			pstmt1.setInt(12, Integer.parseInt(fromMonth));
			pstmt1.setString(13, fromYear);
			pstmt1.setInt(14, offset);
			pstmt1.setInt(15, Integer.parseInt(toMonth));
			pstmt1.setString(16, toYear);
			pstmt1.setInt(17, systemId);
			pstmt1.setInt(18, customerId);			
			rs1 = pstmt1.executeQuery();
			while(rs1.next()){
				if(plDataJobCardData.containsKey(rs1.getString("RegistrationNo")+"-"+rs1.getString("CLOSED_DATE"))){
					ProftAndLossBean pl1=(ProftAndLossBean) plDataJobCardData.get(rs1.getString("RegistrationNo")+"-"+rs1.getString("CLOSED_DATE"));
					float result=pl1.getMaintanenceExpense()+rs1.getFloat("ActualCost");
					pl1.setMaintanenceExpense(result);
					plDataJobCardData.put(rs1.getString("RegistrationNo")+"-"+rs1.getString("CLOSED_DATE"), pl1);
				}else{
					ProftAndLossBean pl2 = new ProftAndLossBean();
					pl2.setMaintanenceExpense(rs1.getFloat("ActualCost"));
					plDataJobCardData.put(rs1.getString("RegistrationNo")+"-"+rs1.getString("CLOSED_DATE"), pl2);
				}
			}
		}
	
		
		for(Map.Entry<String, Object> entry : plDataJobCardData.entrySet()){
			if(!plData.containsKey(entry.getKey())){
				String searchResultCeiling=plData.ceilingKey(entry.getKey());
				if(searchResultCeiling!=null){
					ProftAndLossBean pl3=(ProftAndLossBean) entry.getValue();
					ProftAndLossBean pl4=(ProftAndLossBean)plData.get(searchResultCeiling);
					float tempResult=pl3.getMaintanenceExpense()+pl4.getMaintanenceExpense();
					pl4.setMaintanenceExpense(tempResult);
					plData.put(searchResultCeiling, pl4);
				}else{
					String searchResultFloor=plData.floorKey(entry.getKey());
					ProftAndLossBean pl3=(ProftAndLossBean) entry.getValue();
					ProftAndLossBean pl4=(ProftAndLossBean)plData.get(searchResultFloor);
					float tempResult=pl3.getMaintanenceExpense()+pl4.getMaintanenceExpense();
					pl4.setMaintanenceExpense(tempResult);
					plData.put(searchResultFloor, pl4);
				}
			}else if(plData.containsKey(entry.getKey())){
				ProftAndLossBean pl5=(ProftAndLossBean)plData.get(entry.getKey());
				ProftAndLossBean pl6=(ProftAndLossBean) entry.getValue();
				pl5.setMaintanenceExpense(pl6.getMaintanenceExpense());
				plData.put(entry.getKey(), pl5);
			}
			
		}
		
		
		int mapCount=0;
		for(Map.Entry<String, Object> entry : plData.entrySet()){
			mapCount++;
			tripExpense=0;
			totalIncom=0;
			maintanenceExpence=0;
			netProfit=0;
			ProftAndLossBean pl=(ProftAndLossBean) entry.getValue();
			tripExpense=pl.getTripExpense();
			totalIncom=pl.getTotalAmount();		
			maintanenceExpence=pl.getMaintanenceExpense();
			netProfit=totalIncom-(tripExpense+maintanenceExpence);
			pl.setNetProfit(netProfit);
			
			totalIncome=totalIncome+ pl.getTotalAmount();
			totalTripExpense=totalTripExpense+pl.getTripExpense();
			totalMaintanenceExpense=totalMaintanenceExpense+pl.getMaintanenceExpense();
			totalNetProfit=totalNetProfit+pl.getNetProfit();
			ArrayList < Object > informationList = new ArrayList < Object > ();
			ReportHelper reporthelper = new ReportHelper();
			vehicleDetailsObject = new JSONObject();
			count++;
			informationList.add(count);
			vehicleDetailsObject.put("slnoIndex", count);
			
			informationList.add("");
			vehicleDetailsObject.put("serviceNoDataIndex", "");			
			
			informationList.add(pl.getServiceName());
			vehicleDetailsObject.put("noOfdaysIndex", pl.getServiceName());
			
			informationList.add("");
			vehicleDetailsObject.put("routeNameDataIndex", "");
			
			informationList.add(pl.getTerminalName());
			vehicleDetailsObject.put("terminalNameDataIndex", pl.getTerminalName());
			
			
			informationList.add(pl.getTotalSeats());
			vehicleDetailsObject.put("noOfSeatsDataIndex", pl.getTotalSeats());
			
			informationList.add(pl.getRegistrationNo());
			vehicleDetailsObject.put("vehicleNoDataIndex",pl.getRegistrationNo());
			
			informationList.add("");		
			vehicleDetailsObject.put("dateindex","");
			
			informationList.add(pl.getJourneyDate());		
			vehicleDetailsObject.put("monthindex",pl.getJourneyDate());
			
			informationList.add(pl.getTotalAmount());
			vehicleDetailsObject.put("totalIncomeDataIndex", Float.valueOf(pl.getTotalAmount()));			
			informationList.add(pl.getTripExpense());			
			vehicleDetailsObject.put("tripExpenseDataIndex",Float.valueOf(pl.getTripExpense()));
			informationList.add(pl.getMaintanenceExpense());		
			vehicleDetailsObject.put("mainExpenseDataIndex", Float.valueOf(pl.getMaintanenceExpense()));			
			informationList.add(pl.getNetProfit());
			vehicleDetailsObject.put("netProfitDataIndex", Float.valueOf(pl.getNetProfit()));
			jsonArray.put(vehicleDetailsObject);
			reporthelper.setInformationList(informationList);
	        reportsList.add(reporthelper);
			if(plData.size()==mapCount){		
				informationList = new ArrayList < Object > ();
				vehicleDetailsObject = new JSONObject();
				reporthelper = new ReportHelper();
				count++;
				informationList.add(count);
				vehicleDetailsObject.put("slnoIndex", count);
				
				informationList.add("");
				vehicleDetailsObject.put("serviceNoDataIndex","");
				
				informationList.add("");
				vehicleDetailsObject.put("noOfdaysIndex","<b>Total</b>");
				
				informationList.add("");
				vehicleDetailsObject.put("routeNameDataIndex", "");
				
				informationList.add("");
				vehicleDetailsObject.put("terminalNameDataIndex", "");
				
				
				informationList.add("");
				vehicleDetailsObject.put("noOfSeatsDataIndex", "");
				
				informationList.add("");
				vehicleDetailsObject.put("vehicleNoDataIndex","");
				
				informationList.add("");		
				vehicleDetailsObject.put("dateindex","");		
				
				informationList.add("");		
				vehicleDetailsObject.put("monthindex","");	
				
				informationList.add(totalIncome);
				vehicleDetailsObject.put("totalIncomeDataIndex", "<b>"+totalIncome+"</b>");			
				informationList.add(totalTripExpense);			
				vehicleDetailsObject.put("tripExpenseDataIndex","<b>"+totalTripExpense+"</b>");
				informationList.add(totalMaintanenceExpense);		
				vehicleDetailsObject.put("mainExpenseDataIndex", "<b>"+totalMaintanenceExpense+"</b>");			
				informationList.add(totalNetProfit);
				vehicleDetailsObject.put("netProfitDataIndex", "<b>"+totalNetProfit+"</b>");
				
				jsonArray.put(vehicleDetailsObject);
				reporthelper.setInformationList(informationList);
		        reportsList.add(reporthelper);
			}
		
			
			
		}			
		
		finalreporthelper.setReportsList(reportsList);
        finalreporthelper.setHeadersList(headersList);
        finlist.add(jsonArray);
        finlist.add(finalreporthelper);
	} catch (Exception e) {
		e.printStackTrace();
	} finally {
        DBConnection.releaseConnectionToDB(con, pstmt1, rs);
        DBConnection.releaseConnectionToDB(null, null, rs1);
	}
	return finlist;
}
//**************************************function for InterswitchTransactionDetails****************

public ArrayList<Object> getTransactionDetails(int customerId,int systemId,String fromdate,String todate) {
	JSONArray JsonArray = new JSONArray();
    JSONObject JsonObject =  null;
	Connection con = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    ResultSet rs1 = null;
	int count = 0;
	ArrayList < Object > finlist = new ArrayList < Object > ();
	ArrayList<ReportHelper> reportsList = new ArrayList<ReportHelper>();
	ArrayList<String> headersList = new ArrayList<String>();
	ReportHelper finalreporthelper = new ReportHelper();
	SimpleDateFormat ddmmyyy = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
	SimpleDateFormat yyyymmdd = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
	
	headersList.add("Sl No");
	headersList.add("Transaction Id");
	headersList.add("Phone No");
	headersList.add("Email ID");
	headersList.add("Transaction Status");
	headersList.add("Amount");
	headersList.add("Response Code");
	headersList.add("Response Description");
	headersList.add("Transaction Date");
	headersList.add("Inserted Time");
    try {
        JsonArray = new JSONArray();
        con = DBConnection.getConnectionToDB("AMS");
        pstmt = con.prepareStatement(PassengerBusTransportationStatements.GET_INTERSWITCH_TRANSACTION_DETAILS);
        pstmt.setInt(1, systemId);
        pstmt.setInt(2,customerId);
        pstmt.setString(3,fromdate+" 00:00:00");
        pstmt.setString(4,todate+" 23:59:59");
        rs = pstmt.executeQuery();
        while (rs.next()) {
         	JsonObject = new JSONObject();
			ArrayList<Object> informationList = new ArrayList<Object>();
			ReportHelper reporthelper = new ReportHelper();
			count++;
			JsonObject.put("slnoIndex", count);
			informationList.add(count);
			
            JsonObject.put("transactionIdIndex", rs.getString("TRANSACTION_REF_ID"));
            informationList.add(rs.getString("TRANSACTION_REF_ID"));
            
            JsonObject.put("phoneNoIndex", rs.getString("PHONE_NUMBER"));
            informationList.add(rs.getString("PHONE_NUMBER"));
            
            JsonObject.put("emailIndex", rs.getString("EMAIL_ID"));
            informationList.add(rs.getString("EMAIL_ID"));
            
            JsonObject.put("transactionStatusIndex", rs.getString("TRANSACTION_STATUS"));
            informationList.add(rs.getString("TRANSACTION_STATUS"));
            
            String amount = getAmountOfTransactionUsingDebitcaard(rs.getString("TRANSACTION_REF_ID"),con,pstmt,rs1);
            amount = amount.substring(0, amount.length() - 2);
            
            JsonObject.put("amountIndex", amount);
            informationList.add(amount);
            
            JsonObject.put("responseCodeIndex", rs.getString("RESPONSE_CODE"));
            informationList.add(rs.getString("RESPONSE_CODE"));
            
            JsonObject.put("responseDescriptionIndex", rs.getString("RESPONSE_DESCRIPTION"));
            informationList.add(rs.getString("RESPONSE_DESCRIPTION"));

            if(rs.getString("TRANSACTION_DATE").contains("1900"))
			{           	
            	JsonObject.put("transactionDateIndex","");
            	informationList.add("");
			}else{				
				JsonObject.put("transactionDateIndex", sdf.format(rs.getTimestamp("TRANSACTION_DATE")));
            	informationList.add(ddmmyyy.format(yyyymmdd.parse(rs.getString("TRANSACTION_DATE"))));
				
			}
           
        	JsonObject.put("insertedDateIndex", sdf.format(rs.getTimestamp("INSERTED_DATETIME")));
            informationList.add(ddmmyyy.format(yyyymmdd.parse(rs.getString("INSERTED_DATETIME"))));
            
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
        DBConnection.releaseConnectionToDB(null, null, rs1);
    }
    return finlist;

}


//**************************************function for Transaction ReQuery****************
public JSONArray getRequeryDetails(int customerId,int systemId,String fromdate,String todate) {
    JSONArray JsonArray = null;
    JSONObject JsonObject = null;
    Connection con = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    ResultSet rs1= null;
    try {
        JsonArray = new JSONArray();
        con = DBConnection.getConnectionToDB("AMS");
        pstmt = con.prepareStatement(PassengerBusTransportationStatements.GET_TRANSACTION_REQUERY_DETAILS);
        pstmt.setInt(1, systemId);
        pstmt.setInt(2,customerId);
        pstmt.setString(3,fromdate);
        pstmt.setString(4,todate);
        rs = pstmt.executeQuery();
        while (rs.next()) {
            JsonObject = new JSONObject();
            JsonObject.put("transactionIdIndex", rs.getString("TRANSACTION_REF_ID"));
            JsonObject.put("phoneNoIndex", rs.getString("PHONE_NUMBER"));
            JsonObject.put("emailIndex", rs.getString("EMAIL_ID"));
            String amount = getAmountOfTransactionUsingDebitcaard(rs.getString("TRANSACTION_REF_ID"),con,pstmt,rs1);
            amount = amount.substring(0, amount.length() - 2);
            JsonObject.put("amountIndex", amount);
            JsonObject.put("transactionStatusIndex", rs.getString("TRANSACTION_STATUS"));
            JsonArray.put(JsonObject);
        }
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        DBConnection.releaseConnectionToDB(con, pstmt, rs);
        DBConnection.releaseConnectionToDB(null, null, rs1);
    }
    return JsonArray;
}

}