package t4u.functions;

import java.io.File;
import java.io.StringReader;
import java.net.UnknownHostException;
import java.security.SecureRandom;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.text.DecimalFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Properties;
import java.util.Random;
import java.util.Set;
import java.util.StringTokenizer;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.mail.Message;
import javax.mail.Multipart;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeBodyPart;
import javax.mail.internet.MimeMessage;
import javax.mail.internet.MimeMultipart;
import javax.servlet.http.HttpServletRequest;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;

import net.sf.json.JSON;

import org.json.JSONArray;
import org.json.JSONObject;
import org.w3c.dom.CharacterData;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.InputSource;

import t4u.admin.UnitDetailsData;
import t4u.beans.ReportHelper;
import t4u.common.ApplicationListener;
import t4u.common.DBConnection;
import t4u.common.DESEncryptionDecryption;
import t4u.statements.AdminStatements;
import t4u.statements.CommonStatements;
import t4u.statements.SandMiningStatements;
import t4u.util.CommonUtility;

import com.microsoft.sqlserver.jdbc.SQLServerException;
import com.t4u.activity.VehicleActivity;
import com.t4u.activity.VehicleSummaryBean;



/**
 * 
 * This class is used to write the admin module functions that are related to sql database
 *
 */
public class AdminFunctions {
	
	//final static Logger logger = Logger.getLogger("PasswordRecoveryDetails");
	
	SimpleDateFormat sdfyyyymmdd=new SimpleDateFormat("yyyy-MM-dd");
	SimpleDateFormat sdfddmmyyyy=new SimpleDateFormat("dd-MM-yyyy");
	SimpleDateFormat sdfddmmyy = new SimpleDateFormat("dd-MM-yyyy");
	SimpleDateFormat ddMMyyyyHHmmss = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
	SimpleDateFormat sdfFormatDate = new SimpleDateFormat("MM/dd/yyyy HH:mm:ss");
  	SimpleDateFormat parseFormat = new SimpleDateFormat("EEE MMM dd HH:mm:ss z yyyy");
  	SimpleDateFormat format = new SimpleDateFormat("MM/dd/yyyy HH:mm:ss");
	SimpleDateFormat sdfyyyymmddhhmmss = new SimpleDateFormat(
	"dd-MM-yyyy HH:mm:ss");
	SimpleDateFormat ddmmyy = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
	SimpleDateFormat ddmmyyhhmmss = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	CommonFunctions cf=new CommonFunctions();
	 
	/**
	 * Saves or updates customer details in database based on button value
	 * @param buttonValue
	 * @param custName
	 * @param custAddress
	 * @param custCity
	 * @param custPhone
	 * @param custMobile
	 * @param custFax
	 * @param custStatus
	 * @param checkedServices
	 * @param newcustName
	 * @param custStatus2 
	 * @return message
	 */
	public String saveCustomerDetails(int systemId,int createdUser,String buttonValue,String custName,String custNewName,String custId,String custAddress,
			String custCity,String custState,String custCountry, String custZipcode,String custPhone,String custMobile,String custFax,String custEmail,
			String website,String status,String paymentduedate,String paymentnotificationperiod,String userName,String systemName,String categoryType,
			int speedLimit,String snoozeTime,String serverName,String sessionId,String pageName,int userId){
		String message="";
		Connection conAdmin=null;
		PreparedStatement pstmt=null;
 	    ResultSet rs=null;
 	    ArrayList<String> tableArray=new ArrayList<String>();
		try{
			conAdmin=DBConnection.getConnectionToDB("ADMINISTRATOR");
			conAdmin.setAutoCommit(false);
			pstmt=conAdmin.prepareStatement(AdminStatements.GET_CUST_WITH_SAME_NAME);
			pstmt.setInt(1, systemId);
			if(buttonValue.equals("add")){
				pstmt.setString(2, custName.toUpperCase());
			}else if(buttonValue.equals("modify")){
				pstmt.setString(2, custNewName.toUpperCase());
			}
			rs=pstmt.executeQuery();
			int flag=0;
			String existCustId="0";
			int defaultGroupId = 0;
			while(rs.next()){
				 existCustId=rs.getString("CUSTOMER_ID");
				if(buttonValue.equals("add")){
					flag=1;
					break;
				}else if(buttonValue.equals("modify")){
					if(!existCustId.equals(custId)){
						flag=1;
						break;
					}
				}
			}
			pstmt=null;
			rs=null;
			if(flag==0){
			if(buttonValue.equals("add")){
//			pstmt=conAdmin.prepareStatement(AdminStatements.SaveCustomerDetails,Statement.RETURN_GENERATED_KEYS);
//			pstmt.setString(1, custName);
//			pstmt.setString(2, custAddress);
//			pstmt.setString(3, custCountry);
//			pstmt.setString(4, custState);
//			pstmt.setString(5, custCity);
//			pstmt.setString(6, custZipcode);
//			pstmt.setString(7, custPhone);
//			pstmt.setString(8, custMobile);
//			pstmt.setString(9, custFax);
//			pstmt.setString(10, custEmail);
//			pstmt.setString(11, website);
//			pstmt.setInt(12, systemId);
//			pstmt.setString(13, status);
//			pstmt.setInt(14, createdUser);
//			int i=pstmt.executeUpdate();
//			if(i>0){
//				 message="save"+","+CustomerId;
//			}else{
//				 message="error";
//			}
//			ResultSet rs1 = pstmt.getGeneratedKeys();
			// getting incremented customer id for saving feature
//			int CustomerId = 0;
//			if (rs1.next()) {
//				CustomerId = rs1.getInt(1);
//			}
//			pstmt=null;	
			/******************************block of statement has to delete after full impl************************************************/
//			pstmt=conAdmin.prepareStatement(AdminStatements.SaveCustomerDetails_tblCustomerMaster);
//			pstmt.setInt(1,CustomerId);
//			pstmt.setString(2, custName);
//			pstmt.setString(3, custAddress);
//			pstmt.setString(4, custCity);
//			pstmt.setString(5, custFax);
//			pstmt.setString(6, custPhone);
//			pstmt.setString(7, custMobile);	
//			pstmt.setString(8, custEmail);
//			pstmt.setString(9, website);
//			pstmt.setInt(10, systemId);
//			pstmt.executeUpdate();
			pstmt=conAdmin.prepareStatement(AdminStatements.SaveCustomerDetails_tblCustomerMaster_Without_ID,Statement.RETURN_GENERATED_KEYS);
			pstmt.setString(1, custName);
			pstmt.setString(2, custAddress);
			pstmt.setString(3, custCity);
			pstmt.setString(4, custFax);
			pstmt.setString(5, custPhone);
			pstmt.setString(6, custMobile);	
			pstmt.setString(7, custEmail);
			pstmt.setString(8, website);
			pstmt.setInt(9, systemId);
		    if(paymentduedate!=null && !paymentduedate.equals("")){
				pstmt.setString(10, paymentduedate);
			}else{
				pstmt.setNull(10, java.sql.Types.DATE);
			}
			pstmt.setString(11, paymentnotificationperiod);
			pstmt.setInt(12, speedLimit);
			pstmt.executeUpdate();
			ResultSet rs1 = pstmt.getGeneratedKeys();
			// getting incremented customer id for saving feature
			int CustomerId = 0;
			if (rs1.next()) {
				CustomerId = rs1.getInt(1);
				tableArray.add("Insert"+"##"+"AMS.dbo.tblCustomerMaster");
			}
			pstmt=null;
			pstmt=conAdmin.prepareStatement(AdminStatements.SaveCustomerDetails_With_ID);
			pstmt.setInt(1, CustomerId);
			pstmt.setString(2, custName);
			pstmt.setString(3, custAddress);
			pstmt.setString(4, custCountry);
			pstmt.setString(5, custState);
			pstmt.setString(6, custCity);
			pstmt.setString(7, custZipcode);
			pstmt.setString(8, custPhone);
			pstmt.setString(9, custMobile);
			pstmt.setString(10, custFax);
			pstmt.setString(11, custEmail);
			pstmt.setString(12, website);
			pstmt.setInt(13, systemId);
			pstmt.setString(14, status);
			pstmt.setInt(15, createdUser);
			if(paymentduedate!=null && !paymentduedate.equals("")){
				pstmt.setString(16, paymentduedate);
			}else{
				pstmt.setNull(16, java.sql.Types.DATE);
			}
			pstmt.setString(17, paymentnotificationperiod);
			pstmt.setInt(18, speedLimit);
			pstmt.setString(19, snoozeTime);
			int inserted=pstmt.executeUpdate();
			pstmt=null;
			
			pstmt = conAdmin.prepareStatement("update AMS.dbo.gpsdata_history_latest set SPEED_LIMIT=? where CLIENTID=? and System_id=?");
			pstmt.setInt(1, speedLimit);
			pstmt.setInt(2, CustomerId);
			pstmt.setInt(3, systemId);
			pstmt.executeUpdate();
			pstmt=null;
			
			if(inserted>0){
				 message="Saved Successfully"+","+CustomerId;
				 tableArray.add("Insert"+"##"+"ADMINISTRATOR.dbo.CUSTOMER_MASTER");
				 tableArray.add("Update"+"##"+"AMS.dbo.gpsdata_history_latest");
				 
			}else{
				 message="error";
			}
			/************************************************************************************************************************/
			
			
			/*******************************************************************************************************************
			 *                 There will be default group created for each client whose group name will be same as client name
			 ******************************************************************************************************************/
//			pstmt=null;
//			pstmt=conAdmin.prepareStatement(AdminStatements.INSERT_DEFAULT_GROUP_IN_ASSETGROUP_TABLE);
//			pstmt.setString(1, custName);
//			pstmt.setInt(2, CustomerId);
//			pstmt.setInt(3, systemId);
//			pstmt.setInt(4, createdUser);
//			i=pstmt.executeUpdate();
			/******************************block of statement has to delete after full impl************************************************/
			// code for inserting default groupid into AMS.Vehicle_Group
			pstmt = null;
			pstmt = conAdmin.prepareStatement(AdminStatements.INSERT_INTO_AMS_VEHICLE_GROUP_WITHOUT_ID);
			pstmt.setString(1, custName);
			pstmt.setInt(2, CustomerId);
			pstmt.setInt(3, systemId);
			pstmt.setInt(4, createdUser);
			pstmt.executeUpdate();
			tableArray.add("Insert"+"##"+"AMS.dbo.VEHICLE_GROUP");
			// code for getting default ID for created default Group
			// Name as client name so that Feature can be associated for
			// that client
			pstmt = null;
			rs = null;
			pstmt = conAdmin.prepareStatement(AdminStatements.GetCreatedDefaultGroupID_From_VehicleGroup);
			pstmt.setString(1, custName);
			pstmt.setInt(2, CustomerId);
			pstmt.setInt(3, systemId);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				defaultGroupId = rs.getInt("GROUP_ID");
			}
			// code for getting default id ends
			pstmt=null;
			pstmt=conAdmin.prepareStatement(AdminStatements.INSERT_DEFAULT_GROUP_IN_ASSETGROUP_TABLE_WITH_ID);
			pstmt.setInt(1, defaultGroupId);
			pstmt.setString(2, custName);
			pstmt.setInt(3, CustomerId);
			pstmt.setInt(4, systemId);
			pstmt.setInt(5, createdUser);
			pstmt.executeUpdate();
			tableArray.add("Insert"+"##"+"ADMINISTRATOR.dbo.ASSET_GROUP");
		/*************************************************************************************************************************************/
			
			// code for getting default ID for created default Group
			// Name as client name so that Feature can be associated for
			// that client
//			pstmt = null;
//			rs = null;
//			pstmt = conAdmin
//					.prepareStatement(AdminStatements.GetCreatedDefaultGroupID);
//			pstmt.setString(1, custName);
//			pstmt.setInt(2, CustomerId);
//			pstmt.setInt(3, systemId);
//			rs = pstmt.executeQuery();
//			if (rs.next()) {
//				defaultGroupId = rs.getInt("GROUP_ID");
//			}
			// code for getting default id ends

			/******************************block of statement has to delete after full impl************************************************/
			// code for inserting default groupid into AMS.Vehicle_Group
//			pstmt = null;
//			pstmt = conAdmin
//					.prepareStatement(AdminStatements.INSERT_INTO_AMS_VEHICLE_GROUP);
//			pstmt.setInt(1, defaultGroupId);
//			pstmt.setString(2, custName);
//			pstmt.setInt(3, CustomerId);
//			pstmt.setInt(4, systemId);
//			pstmt.setInt(5, createdUser);
//			pstmt.executeUpdate();
		
			/*********************************************** block to generate email  *****************************************************/
			
			pstmt=null;
			rs=null;
			String subject="Customer Information Notification for "+custName+" - "+systemName+" LTSP.";
			String body=getEmailTemplateForCustomerInformation(custName,"add",userName,systemName);
			StringBuilder mailListBuilder = new StringBuilder();
			ArrayList<String> mailList = new ArrayList<String>();
			pstmt=conAdmin.prepareStatement(AdminStatements.GET_MAIL_IDS);
			pstmt.setString(1, categoryType);
			rs=pstmt.executeQuery();
			
			while(rs.next()){
				mailList.add(rs.getString("EMAIL_ID"));
			}
			for (int j = 0; j < mailList.size(); j++) {
				if (j == mailList.size() - 1) {
						mailListBuilder.append(mailList.get(j).toString());
					} else {
						mailListBuilder.append(mailList.get(j).toString() + ",");
					}
			}
			pstmt=null;
			rs=null;
			
			if(CustomerId > 0 && inserted > 0)
			{
				pstmt=conAdmin.prepareStatement(AdminStatements.INSERT_INTO_EMAIL_QUEUE);
				pstmt.setString(1, subject);
				pstmt.setString(2, body);
				pstmt.setString(3, mailListBuilder.toString());
				pstmt.setInt(4, systemId);
				pstmt.executeUpdate();
				pstmt=null;
				mailListBuilder=null;
				tableArray.add("Insert"+"##"+"AMS.dbo.EmailQueue");
			}
			try {
				cf.insertDataIntoAuditLogReport(sessionId, tableArray, pageName, "ADD", userId, serverName, systemId,0,"Added Customer Details");
			} catch (Exception e) {
				e.printStackTrace();
			}
			
			}
			/********************************************************************************************************************/
			else if(buttonValue.equals("modify")){
				pstmt=conAdmin.prepareStatement(AdminStatements.GET_DEFAULT_GROUPID);
				pstmt.setString(1, custName.trim());
				pstmt.setString(2, custId);
				pstmt.setInt(3, systemId);
				ResultSet rs1=pstmt.executeQuery();
				 defaultGroupId=0;
				if(rs1.next()){
					defaultGroupId=rs1.getInt("GROUP_ID");
				}
				pstmt=conAdmin.prepareStatement(AdminStatements.UpdateCustomerDetails);
				pstmt.setString(1, custNewName);
				pstmt.setString(2, custAddress);
				pstmt.setString(3, custCountry);
				pstmt.setString(4, custState);
				pstmt.setString(5, custCity);
				pstmt.setString(6, custZipcode);
				pstmt.setString(7, custPhone);
				pstmt.setString(8, custMobile);
				pstmt.setString(9, custFax);
				pstmt.setString(10, custEmail);
				pstmt.setString(11, website);
				pstmt.setString(12, status);
			    if(paymentduedate!=null && !paymentduedate.equals("")){
					pstmt.setString(13, paymentduedate);
				}else{
					pstmt.setNull(13, java.sql.Types.DATE);
				}
				pstmt.setString(14, paymentnotificationperiod);
				pstmt.setInt(15, speedLimit);
				pstmt.setString(16, snoozeTime);
				pstmt.setInt(17, systemId);
				pstmt.setString(18, custId);
				int i=pstmt.executeUpdate();
				pstmt=null;
				if(i>0)
				{
					tableArray.add("Update"+"##"+"ADMINISTRATOR.dbo.CUSTOMER_MASTER");
				    pstmt = null;
				/******************************block of statement has to delete after full impl************************************************/
				pstmt = conAdmin.prepareStatement(AdminStatements.UpdateCustomerDetailsIntoAMSdb);
				pstmt.setString(1, custNewName);
				pstmt.setString(2, custAddress);
				pstmt.setString(3, custPhone);
				pstmt.setString(4, custMobile);
				pstmt.setString(5, website);
				pstmt.setString(6, custEmail);
			    if(paymentduedate!=null && !paymentduedate.equals("")){
					pstmt.setString(7, paymentduedate);
				}else{
					pstmt.setNull(7, java.sql.Types.DATE);
				}
				pstmt.setString(8, paymentnotificationperiod);
				pstmt.setInt(9, speedLimit);
				pstmt.setInt(10, systemId);
				pstmt.setString(11, custId);
				int u=pstmt.executeUpdate();
				if(u>0){
					tableArray.add("Update"+"##"+"AMS.dbo.tblCustomerMaster");
				}
				pstmt=null;
				pstmt=conAdmin.prepareStatement(AdminStatements.UPDATE_DEFAULT_GROUP_IN_VEHICLE_GROUP);
				pstmt.setString(1, custNewName);
				pstmt.setInt(2, Integer.parseInt(custId));
				pstmt.setInt(3, defaultGroupId);
				pstmt.setInt(4, systemId);
			    int up=pstmt.executeUpdate();
			    if(up>0){
			    	tableArray.add("Update"+"##"+"AMS.dbo.VEHICLE_GROUP");
			    }
				/*****************************************************************************************************************************/
				pstmt=null;
				pstmt=conAdmin.prepareStatement(AdminStatements.UPDATE_DEFAULT_GROUP_IN_ASSETGROUP_TABLE);
				pstmt.setString(1, custNewName);
				pstmt.setInt(2, Integer.parseInt(custId));
				pstmt.setInt(3, defaultGroupId);
				pstmt.setInt(4, systemId);
			    int up2=pstmt.executeUpdate();
			    if(up2>0){
			    	tableArray.add("Update"+"##"+"ADMINISTRATOR.dbo.ASSET_GROUP");
			    }
			    
			    pstmt=null;
				pstmt=conAdmin.prepareStatement(AdminStatements.UPDATE_LIVE_VISION_CLIENT_NAME);
				pstmt.setString(1, custNewName);
				pstmt.setInt(2, Integer.parseInt(custId));
				pstmt.setInt(3, systemId);
			    int up3=pstmt.executeUpdate();
			    if(up3>0){
			    	tableArray.add("Update"+"##"+"AMS.dbo.Live_Vision_Support");
			    }
			    pstmt=null;
			    pstmt=conAdmin.prepareStatement(AdminStatements.UPDATE_LIVE_VISION_GROUP_NAME);
				pstmt.setString(1, custNewName.trim());
				pstmt.setString(2, custName.trim());
				pstmt.setInt(3, Integer.parseInt(custId));
				pstmt.setInt(4, systemId);
			    int up4=pstmt.executeUpdate();
			    if(up4>0){
			    	tableArray.add("Update"+"##"+"AMS.dbo.Live_Vision_Support");
			    }
			    pstmt=null;
			    
			    pstmt = conAdmin.prepareStatement("update AMS.dbo.gpsdata_history_latest set SPEED_LIMIT=? where CLIENTID=? and System_id=? ");
				pstmt.setInt(1, speedLimit);
				pstmt.setInt(2, Integer.parseInt(custId));
				pstmt.setInt(3, systemId);
				pstmt.executeUpdate();
				pstmt=null;
			}
			if(i>0){
				 message="Saved Successfully"+","+custId;
				 tableArray.add("Update"+"##"+"AMS.dbo.gpsdata_history_latest");
				 try {
					 cf.insertDataIntoAuditLogReport(sessionId, tableArray, pageName, "MODIFY", userId, serverName, systemId,0,"Updated Customer Details");
				} catch (Exception e) {
					e.printStackTrace();
				}
				
			}else{
				 message="error";
			}
			}
			}else{
				message="Duplicate Customer Name";
			}
			conAdmin.commit();
			
		}catch(Exception e){
			//e.printStackTrace();
			System.out.println("error in AdminFunction:-save customer details "+e.toString());
			message="error";
			if (conAdmin!=null) {
				try {
					conAdmin.rollback();
				} catch (SQLException e1) {
					e1.printStackTrace();
				}
			}
		}
		finally{
			DBConnection.releaseConnectionToDB(conAdmin, pstmt, rs);
		}		
		return message;
	}
	/**
	 * Saves asset User details in database based on button value
	 * @param custName
	 * @param userName
	 * @param password
	 * @param firstName
	 * @param middleName
	 * @param lastName
	 * @param userPhone
	 * @param userEmail
	 * @param userFeatureGroup
	 * @param userType
	 * @param branch
	 * @param userAuth
	 * @param userStatus
	 * @return message
	 */
	
	public boolean isEmailModified(int systemId,String userEmail,String userId){
		boolean ismod = false;
		
		Connection conAdmin=null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		try {
			conAdmin=DBConnection.getConnectionToDB("ADMINISTRATOR");
			pstmt=conAdmin.prepareStatement(AdminStatements.getUserEmail);
			pstmt.setInt(1, systemId);
			pstmt.setString(2, userId);
			rs=pstmt.executeQuery();
			if(rs.next()){
			String preemail = rs.getString("Emailed");
			String pass =  rs.getString("User_password");
				if(pass.trim().equals("") || pass == null ){
				if(!preemail.equalsIgnoreCase(userEmail)){
					ismod = true;
				}
				}else{
				ismod = false;
			}
			}else{
				ismod = true;
			}
			
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			DBConnection.releaseConnectionToDB(conAdmin, pstmt, rs);
		}
		return ismod;
	}
	public String saveUserDetails(int systemId, int createdUser,String buttonValue,String userId, String custName,
			String userName,String newusername,String password, String firstName, String middleName, 
			String lastName, String userPhone, String userEmail, String userMobile,String userFax,
			String branch, String userAuth, String userStatus,String emVisionId,String sessionId,boolean locset,String pageName,String sessionId1,String serverName,String roleId) {
		
		String message="";
		Connection conAdmin=null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		PreparedStatement pstmt1=null;
		ResultSet rs1=null;
		ArrayList<String> tableList=new ArrayList<String>();
		try {
			conAdmin=DBConnection.getConnectionToDB("ADMINISTRATOR");
			pstmt=conAdmin.prepareStatement(AdminStatements.CheckUserName);
			if(buttonValue.equals("add")){
				pstmt.setString(1, userName);
			}else if(buttonValue.equals("modify")){
				pstmt.setString(1, newusername);
			}
			rs=pstmt.executeQuery();
			int flag=0;
			String existUserId="0";
			while(rs.next()){
				
				existUserId=rs.getString("USER_ID");
				if(buttonValue.equals("add")){
					flag=1;
					break;
				}else if(buttonValue.equals("modify")){
					if(!existUserId.equals(userId)){
						flag=1;
						break;
					}
				}
			}
			if(flag==0){
				if(buttonValue.equals("add")){
					
//			pstmt=null;
//			pstmt=conAdmin.prepareStatement(AdminStatements.SaveUserDetails,Statement.RETURN_GENERATED_KEYS);
//			pstmt.setInt(1, Integer.parseInt(custName));
//			pstmt.setInt(2, systemId);
//			pstmt.setString(3, userName);
//			pstmt.setString(4, password);
//			pstmt.setString(5, firstName.toUpperCase());
//			pstmt.setString(6, middleName.toUpperCase());
//			pstmt.setString(7, lastName.toUpperCase());
//			pstmt.setString(8, userPhone);
//			pstmt.setString(9, userEmail);
//			pstmt.setInt(10, Integer.parseInt(branch));
//			pstmt.setString(11, userAuth);
//			pstmt.setString(12, userStatus);
//			pstmt.setInt(13, createdUser);
//			pstmt.setString(14,userMobile);
//			pstmt.setString(15, userFax);
//			int i=pstmt.executeUpdate();
//			ResultSet rs1 = pstmt.getGeneratedKeys();
			// getting incremented customer id for saving feature
//			int newuserId = 0;
//			if (rs1.next()) {
//				newuserId = rs1.getInt(1);
//			}
		   /******************************block of statement has to delete after full impl************************************************/
//			pstmt=conAdmin.prepareStatement(AdminStatements.SAVE_USER_AMS);
//	
//			pstmt.setString(1, password);
//			pstmt.setString(2, firstName);
//			pstmt.setString(3, lastName);
//			pstmt.setString(4, userPhone);
//			pstmt.setString(5, userEmail);
//			pstmt.setString(6, userName);
//			pstmt.setInt(7, Integer.parseInt(custName));
//			pstmt.setInt(8, systemId);
//			pstmt.setInt(9, Integer.parseInt(branch));
//			pstmt.setString(10, userStatus);
//			pstmt.setInt(11, newuserId);
//			pstmt.executeUpdate();
			
			pstmt=null;
			rs=null;
			pstmt=conAdmin.prepareStatement(AdminStatements.SELECT_MAX_USER_ID);
			pstmt.setInt(1, systemId);
			rs=pstmt.executeQuery();
			int newuserId = 0;
			if(rs.next()){
				newuserId=rs.getInt("uid");
			}
			newuserId++;
			pstmt=null;
			pstmt=conAdmin.prepareStatement(AdminStatements.SAVE_USER_AMS_NEW);			
			pstmt.setString(1, password);
			pstmt.setString(2, firstName);
			pstmt.setString(3, lastName);
			pstmt.setString(4, userPhone);
			pstmt.setString(5, userEmail);
			pstmt.setString(6, userName);
			pstmt.setInt(7, Integer.parseInt(custName));
			pstmt.setInt(8, systemId);
			pstmt.setInt(9, Integer.parseInt(branch));
			pstmt.setString(10, userStatus);
			pstmt.setInt(11, newuserId);
			pstmt.setString(12, userAuth);
			pstmt.setString(13, sessionId);
			pstmt.setBoolean(14, locset);
			pstmt.setString(15, roleId);
			int up=pstmt.executeUpdate();
			if(up>0){tableList.add("Insert"+"##"+"AMS.dbo.Users");}

			
			pstmt=null;
			pstmt=conAdmin.prepareStatement(AdminStatements.SaveUserDetails_WithId);
			pstmt.setInt(1, newuserId);
			pstmt.setInt(2, Integer.parseInt(custName));
			pstmt.setInt(3, systemId);
			pstmt.setString(4, userName);
			pstmt.setString(5, password);
			pstmt.setString(6, firstName.toUpperCase());
			pstmt.setString(7, middleName.toUpperCase());
			pstmt.setString(8, lastName.toUpperCase());
			pstmt.setString(9, userPhone);
			pstmt.setString(10, userEmail);
			pstmt.setInt(11, Integer.parseInt(branch));
			pstmt.setString(12, userAuth);
			pstmt.setString(13, userStatus);
			pstmt.setInt(14, createdUser);
			pstmt.setString(15,userMobile);
			pstmt.setString(16, userFax);
			pstmt.setString(17,emVisionId);
			pstmt.setBoolean(18, locset);
			pstmt.setString(19, roleId);
			int i=pstmt.executeUpdate();
			if(i>0){tableList.add("Insert"+"##"+"dbo.USERS");}
			
			pstmt=conAdmin.prepareStatement(AdminStatements.SAVE_USER_GROUP_AMS);
			pstmt.setInt(1, newuserId);
			pstmt.setInt(2, 1);
			pstmt.setInt(3, systemId);
			int up1=pstmt.executeUpdate();
			if(up1>0){tableList.add("Insert"+"##"+"AMS.dbo.User_Group");}

			/******************************************************************************/
			try {
				cf.insertDataIntoAuditLogReport(sessionId, tableList, pageName, "ADD", createdUser, serverName, systemId,Integer.parseInt(custName),"Added User Details");
			} catch (Exception e) {e.printStackTrace();
			}
			
			if(i>0){
				 message="Saved Successfully"+","+newuserId;
			}else{
				 message="error";
			}
			}
				else if(buttonValue.equals("modify")){
					pstmt=conAdmin.prepareStatement(AdminStatements.ModifyUserDetailsNew1);
					pstmt.setString(1, newusername);
					//pstmt.setString(2, password);
					pstmt.setString(2, firstName);
					pstmt.setString(3, middleName);
					pstmt.setString(4, lastName);
					pstmt.setString(5, userPhone);
					pstmt.setString(6, userEmail);
					pstmt.setInt(7, Integer.parseInt(branch));
					pstmt.setString(8, userAuth);
					pstmt.setString(9, userStatus);
					pstmt.setString(10, userMobile);
					pstmt.setString(11, userFax);
					pstmt.setString(12,emVisionId);
					pstmt.setBoolean(13, locset);
					pstmt.setInt(14, Integer.parseInt(roleId));
					pstmt.setInt(15, Integer.parseInt(userId));
					pstmt.setInt(16, Integer.parseInt(custName));
					pstmt.setInt(17, systemId);
					int i=pstmt.executeUpdate();
					if(i>0){tableList.add("Update"+"##"+"dbo.USERS");}
					pstmt=null;
					/******************************block of statement has to delete after full impl************************************************/
					pstmt=conAdmin.prepareStatement(AdminStatements.MODIFY_USER_IN_AMS_NEW_new1);
					pstmt.setString(1, newusername);
					//pstmt.setString(2, password);
					pstmt.setString(2, firstName);
					pstmt.setString(3, lastName);
					pstmt.setString(4, userPhone);
					pstmt.setString(5, userEmail);
					pstmt.setInt(6, Integer.parseInt(branch));
					pstmt.setString(7, userStatus);
					pstmt.setString(8, userAuth);
					pstmt.setString(9, sessionId);
					pstmt.setBoolean(10, locset);
					pstmt.setInt(11, Integer.parseInt(roleId));
					pstmt.setInt(12, Integer.parseInt(userId));
					pstmt.setInt(13, Integer.parseInt(custName));
					pstmt.setInt(14, systemId);
					int up3=pstmt.executeUpdate();
					if(up3>0){tableList.add("Update"+"##"+"AMS.dbo.Users");}

					/***********************************************************************************************************************************/
					if(i>0){
						 message="Saved Successfully"+","+userId;
					}else{
						 message="error";
					}
					try {
						cf.insertDataIntoAuditLogReport(sessionId, tableList, pageName, "Modify", createdUser, serverName,
								systemId,Integer.parseInt(custName),"Updated User Details");
					} catch (Exception e) {
						e.printStackTrace();
					}
				}
			}else{
				message="duplicate username";
			}
		} catch (Exception e) {
			System.out.println("Error in AdminFunction:-saveUserDetails method "+e.toString());
			message="error";
		}finally{
			
			DBConnection.releaseConnectionToDB(conAdmin, pstmt, rs);
		}
		return message;
	}

	public String updateUserDetails(int systemId, int customerId,int createdUser,String password, String firstName, String middleName, String lastName, String userPhone, String userEmail, String userMobile,String userFax,int mapType) {
		String message="";
		Connection conAdmin=null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		PreparedStatement pstmt1=null;
		ResultSet rs1=null;
		try {
			conAdmin=DBConnection.getConnectionToDB("ADMINISTRATOR");
			
			pstmt=conAdmin.prepareStatement(AdminStatements.MOVE_PASSWORD_HIST);
		    pstmt.setInt(1,systemId);
		    pstmt.setInt(2,customerId);
		    pstmt.setInt(3,createdUser);
		    pstmt.executeUpdate();
		    
			pstmt=conAdmin.prepareStatement(AdminStatements.UpdateUserDetails);
			pstmt.setString(1, password);
			pstmt.setString(2, firstName);
			pstmt.setString(3, middleName);
			pstmt.setString(4, lastName);
			pstmt.setString(5, userPhone);
			pstmt.setString(6, userEmail);
			pstmt.setString(7, userMobile);
			pstmt.setString(8, userFax);
			pstmt.setInt(9, mapType);
			pstmt.setInt(10, createdUser);
			pstmt.setInt(11,customerId);
			pstmt.setInt(12, systemId);
			int i=pstmt.executeUpdate();
			pstmt=null;
			/******************************block of statement has to delete after full impl************************************************/
			pstmt=conAdmin.prepareStatement(AdminStatements.UPDATE_USER_IN_AMS);
			
			pstmt.setString(1, password);
			pstmt.setString(2, firstName);
			pstmt.setString(3, lastName);
			pstmt.setString(4, userPhone);
			pstmt.setString(5, userEmail);
			pstmt.setInt(6, createdUser);
			pstmt.setInt(7, customerId);
			pstmt.setInt(8, systemId);
			pstmt.executeUpdate();
			/***********************************************************************************************************************************/
			
			if(i>0){
				 message="Saved Successfully";
			}else{
				 message="error";
			}
		}
		catch (Exception e) {
			System.out.println("Error in AdminFunction:-saveUserDetails method "+e.toString());
			message="error";
		}finally{
			
			DBConnection.releaseConnectionToDB(conAdmin, pstmt, rs);
		}
		return message;
	}
	
	
	
	/**
	 * Getting supervisor details 
	 * @param SystemId
	 * @param CustId
	 * @return
	 */
	
	
	
	
	
	public JSONArray getSupervisorDetails(int systemId, int custId) {
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject = null;
		Connection conAdmin=null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		try {
			conAdmin=DBConnection.getConnectionToDB("ADMINISTRATOR");
			pstmt=conAdmin.prepareStatement(AdminStatements.GetSupervisorDetails);
			pstmt.setInt(1, custId);
			pstmt.setInt(2, systemId);
			rs=pstmt.executeQuery();
			while(rs.next()){
				jsonObject=new JSONObject();
				String	fname=rs.getString("NAME");
											
				String phone=rs.getString("PHONE");
				
				String email=rs.getString("EMAIL");
				
				String userId=rs.getString("USER_ID");
				if(!fname.equals(""))
				{
				jsonObject.put("SupervisorName", fname);
				jsonObject.put("SupervisorPhone", phone);
				jsonObject.put("SupervisorEmail", email);
				jsonObject.put("UserId",userId);
				jsonArray.put(jsonObject);
				}
			}
		} catch (Exception e) {
			System.out.println("error in AdminFunction:- getSupervisordetails()"+e);
		}
		finally{
			DBConnection.releaseConnectionToDB(conAdmin, pstmt, rs);
		}
		return jsonArray;
	}
	
	/**
	 * Getting customer details of Customer
	 * @param SystemId
	 * @param 
	 * @return
	 */
	public JSONArray getCustomerDetails(int SystemId,int CustomerIdLogged){
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject = new JSONObject();
		Connection conAdmin=null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		
		int count=0;
		try{
			jsonArray = new JSONArray();
			jsonObject = new JSONObject();
			double convertFactor=getUnitOfMeasureConvertionsfactor(SystemId);
			conAdmin=DBConnection.getConnectionToDB("ADMINISTRATOR");
			if(CustomerIdLogged>0){
				pstmt=conAdmin.prepareStatement(AdminStatements.GetCustomerDetailForLoggedClientLTSP);
				pstmt.setInt(1, SystemId);
				pstmt.setInt(2, CustomerIdLogged);
			
			}else{
				pstmt=conAdmin.prepareStatement(AdminStatements.GetCustomerDetailForLTSP);
				pstmt.setInt(1, SystemId);
			}
			rs=pstmt.executeQuery();
			
			int speedLimit=0;
			while(rs.next()){
				count++;
				String payMentDueDAte="";
                if(rs.getString("PAYMENT_DUE_DATE")!=null){
                	Date dd1=rs.getTimestamp("PAYMENT_DUE_DATE");
                	payMentDueDAte=sdfddmmyyyy.format(dd1);
                }
    			String paymentNotiPeriod="";
    			if(rs.getString("PAYMENT_NOTIFICATION_PERIOD")!=null){
    				paymentNotiPeriod=rs.getString("PAYMENT_NOTIFICATION_PERIOD");
    			}
				jsonObject = new JSONObject();
				jsonObject.put("slnoIndex", Integer.toString(count));
				jsonObject.put("customeridIndex", rs.getString("CUSTOMER_ID"));
				jsonObject.put("nameIndex", rs.getString("NAME"));
				jsonObject.put("addressIndex", rs.getString("ADDRESS"));
				jsonObject.put("cityIndex", rs.getString("CITY").toUpperCase());
				jsonObject.put("stateIndex", rs.getString("STATE_NAME"));
				jsonObject.put("countryIndex", rs.getString("COUNTRY_NAME"));
				jsonObject.put("zipcodeIndex", rs.getString("ZIP_CODE"));
				jsonObject.put("phonenoIndex", rs.getString("PHONE_NO"));
				jsonObject.put("mobilenoIndex", rs.getString("MOBILE_NO"));
				jsonObject.put("faxIndex", rs.getString("FAX"));
				jsonObject.put("emailidIndex", rs.getString("EMAIL"));
				jsonObject.put("websiteIndex", rs.getString("WEBSITE"));
				jsonObject.put("paymentduedateIndex", payMentDueDAte);
				jsonObject.put("paymentnotificationIndex", paymentNotiPeriod);
				jsonObject.put("statusIndex", rs.getString("STATUS"));
				jsonObject.put("countryidIndex", rs.getString("COUNTRY_CODE"));
				jsonObject.put("stateidIndex", rs.getString("STATE_CODE"));
				jsonObject.put("activationstatusIndex", rs.getString("ACTIVATION_STATUS"));
				
				speedLimit=(int)Math.floor(convertFactor*rs.getInt("SPEED_LIMIT"));
				
				jsonObject.put("speedLimitIndex",speedLimit);
				jsonObject.put("snoozeTimeIndex", rs.getString("SNOOZE_TIME"));
				jsonObject.put("paymentDueIndex", rs.getString("PAYMENT_DUE_NOTIFICATION"));
				jsonArray.put(jsonObject);				
			}
		}catch(Exception e){
			System.out.println("Error in AdminFunction:-getCustomerDetails "+e.toString());
		}	
		finally{
			DBConnection.releaseConnectionToDB(conAdmin, pstmt, rs);
		}	
		return jsonArray;
	}
	
	/**
	 * Deleting user details of User
	 * @param custName
	 * @param userName
	 * @param newUsername
	 * @param password
	 * @param firstName
	 * @param middleName
	 * @param lastName
	 * @return
	 */
	public String deleteUserDetails(int systemId, String custName, String userId,String pageName,String sessionId,String serverName,int createdUser)
	{
		
		String message="";
		Connection conAdmin=null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		ArrayList<String> tableList=new ArrayList<String>();
		try {
			
			conAdmin=DBConnection.getConnectionToDB("ADMINISTRATOR");
			
			pstmt=conAdmin.prepareStatement(AdminStatements.DeleteUserDetails);
			pstmt.setInt(1,Integer.parseInt(custName));
			pstmt.setInt(2, Integer.parseInt(userId));
			pstmt.setInt(3, systemId);
			int i = pstmt.executeUpdate();
			if(i>0){tableList.add("Delete"+"##"+"dbo.USERS");}
			pstmt=null;
			/******************************block of statement has to delete after full impl************************************************/
			pstmt=conAdmin.prepareStatement(AdminStatements.DELETE_USER_FROM_AMS);
			pstmt.setInt(1,Integer.parseInt(custName));
			pstmt.setInt(2, Integer.parseInt(userId));
			pstmt.setInt(3, systemId);
			i = pstmt.executeUpdate();
			if(i>0){tableList.add("Delete"+"##"+"AMS.dbo.Users");}
			
			pstmt=conAdmin.prepareStatement(AdminStatements.Delete_Group_id_From_AMS);
			pstmt.setInt(1,Integer.parseInt(userId));
			pstmt.setInt(2, systemId);
			int up=pstmt.executeUpdate();
			if(up>0){tableList.add("Delete"+"##"+"AMS.dbo.User_Group");}
			/*******************************************************************/
			if(i>0){
				
				pstmt=conAdmin.prepareStatement(AdminStatements.Delete_USER_PROCESS_DETACHMENT);
				pstmt.setInt(1, Integer.parseInt(userId));
				pstmt.setInt(2, systemId);
				int up1=pstmt.executeUpdate();
				if(up1>0){tableList.add("Delete"+"##"+"dbo.USER_PROCESS_DETACHMENT");}
				pstmt=null;
				
				pstmt=conAdmin.prepareStatement(AdminStatements.Delete_USER_GROUP);
				pstmt.setInt(1, Integer.parseInt(userId));
				pstmt.setInt(2, systemId);
				int up2=pstmt.executeUpdate();
				if(up2>0){tableList.add("Delete"+"##"+"AMS.dbo.User_Group");}
				pstmt=null;
				
				pstmt=conAdmin.prepareStatement(AdminStatements.Delete_VEHICLE_USER);
				pstmt.setInt(1, Integer.parseInt(userId));
				pstmt.setInt(2, systemId);
				int up3=pstmt.executeUpdate();
				if(up3>0){tableList.add("Delete"+"##"+"AMS.dbo.Vehicle_User");}
				pstmt=null;
				
				pstmt=conAdmin.prepareStatement(AdminStatements.DELETE_USER_ASSET_GROUP_ASSOCIATION);
				pstmt.setInt(1, Integer.parseInt(userId));
				pstmt.setInt(2, systemId);
				int up4=pstmt.executeUpdate();
				if(up4>0){tableList.add("Delete"+"##"+"ADMINISTRATOR.dbo.USER_ASSET_GROUP_ASSOCIATION");}
				
				/***************Delete Alert Details***************/
				pstmt=null;
				pstmt = conAdmin.prepareStatement(AdminStatements.DELETE_ALERT_USER_ASSOC);
				pstmt.setInt(1, Integer.parseInt(userId));
				pstmt.setInt(2, systemId);
				int up5=pstmt.executeUpdate();
				if(up5>0){tableList.add("Delete"+"##"+"AMS.dbo.Alert_User_Assoc");}
				/**************************************************/
				
				/*************************Delete UserReportSchedularAssociate Details************************/
				pstmt=null;
				pstmt = conAdmin.prepareStatement(AdminStatements.USER_REPORT_SCHEDULAR_ASSOC);
				pstmt.setInt(1, Integer.parseInt(userId));
				pstmt.setInt(2, systemId);
				pstmt.setInt(3,Integer.parseInt(custName));
				int up6=pstmt.executeUpdate();
				if(up6>0){tableList.add("Delete"+"##"+"AMS.dbo.UserReportSchedularAssoc");}
				/*******************************************************************************************/
				
				/***********************Delete CLIENTALERT_SMS_NUMBERS******************************/
				pstmt=null;
				pstmt=conAdmin.prepareStatement(AdminStatements.DELETE_CLIENT_SMS_NUMBER);
				pstmt.setInt(1, Integer.parseInt(userId));
				pstmt.setInt(2, systemId);
				int up7=pstmt.executeUpdate();
				if(up7>0){tableList.add("Delete"+"##"+"dbo.USER_PROCESS_DETACHMENT");}
				
				/************************************************************************************/
				
				/***********************Delete USER_AUTHORITY******************************/
				pstmt=null;
				pstmt=conAdmin.prepareStatement(AdminStatements.DELETE_USER_AUTHORITY);
				pstmt.setInt(1, Integer.parseInt(userId));
				pstmt.setInt(2, systemId);
				pstmt.setInt(3,Integer.parseInt(custName));
				int up8=pstmt.executeUpdate();
				if(up8>0){tableList.add("Delete"+"##"+"LMS.dbo.USER_AUTHORITY");}
				
				/************************************************************************************/
				
				 message="User Deleted";
				 try {
					 cf.insertDataIntoAuditLogReport(sessionId, tableList, pageName, "DELETE", createdUser, serverName, systemId,Integer.parseInt(custName),"Deleted User Details");
				} catch (Exception e) {
					e.printStackTrace();
				}
				
			} else{
		
				 message="error";
			}
		} catch (Exception e) {
			System.out.println("error in AdminFunctions:-delete user details "+e.toString());
			message="error";
		}finally{
			DBConnection.releaseConnectionToDB(conAdmin, pstmt, rs);
		}
		return message;
	}

	/**
	 * Deleting the asset group details of customer
	 * @param CustName
	 * @param groupName
	 * @return
	 */


	public String deleteAssetGroupDetails(int systemId ,String custName, String groupid,String defaultgroupname,int userId,String pageName,String sessionId,String serverName) {
		
		String message="";
		Connection conAdmin=null;
		PreparedStatement pstmt=null;
		PreparedStatement pstmt1=null;
		ResultSet rs = null;
		ArrayList<String> tableList=new ArrayList<String>();
		try {
				conAdmin=DBConnection.getConnectionToDB("ADMINISTRATOR");
				conAdmin.setAutoCommit(false);
				pstmt=conAdmin.prepareStatement(AdminStatements.DELETE_ASSET_GROUP_PROCESS);
				pstmt.setInt(1, Integer.parseInt(groupid));
				pstmt.setInt(2, systemId);
				int up=pstmt.executeUpdate();
				if(up>0){tableList.add("Delete"+"##"+"ADMINISTRATOR.dbo.ASSET_GROUP_PROCESS");}
				pstmt=null;
				
				//get users associated to deleting group and users not present in default group of the client
				pstmt=conAdmin.prepareStatement(AdminStatements.GET_USER_GROUP_ASSOCIATION_DETAILS);
				pstmt.setInt(1, systemId);
				pstmt.setInt(2, Integer.parseInt(groupid));
				pstmt.setInt(3, systemId);
				pstmt.setString(4, defaultgroupname.toUpperCase().trim());
				pstmt.setInt(5, systemId);
				pstmt.setString(6, custName);
				rs = pstmt.executeQuery();
				while (rs.next()) {
					//delete records for users from Vehicle_users table
					pstmt1=conAdmin.prepareStatement(AdminStatements.DELETE_VEHICLE_USER_DETAILS);
					pstmt1.setInt(1, systemId);			
					pstmt1.setInt(2, rs.getInt("USER_ID"));
					pstmt1.setInt(3, systemId);			
					pstmt1.setInt(4, Integer.parseInt(custName));			
					pstmt1.setInt(5, Integer.parseInt(groupid));
					int up1=pstmt1.executeUpdate();
					if(up1>0){tableList.add("Delete"+"##"+"AMS.dbo.Vehicle_User");}
				}
				pstmt = null;
				pstmt1 = null;
				
				//move users associated to deleting group from USER_ASSET_GROUP_ASSOCIATION to USER_ASSET_GROUP_ASSOCIATION_HISTORY table
				pstmt1=conAdmin.prepareStatement(AdminStatements.MOVE_USER_GROUP_ASSOCIATION_DETAILS_TO_HISTOTRY);
				pstmt1.setInt(1, userId);
				pstmt1.setInt(2, systemId);			
				pstmt1.setInt(3, Integer.parseInt(groupid));
				int up2=pstmt1.executeUpdate();
				if(up2>0){tableList.add("Insert"+"##"+"ADMINISTRATOR.dbo.USER_ASSET_GROUP_ASSOCIATION_HISTORY");}
				pstmt1 = null;
				
				//delete users associated to deleting group from USER_ASSET_GROUP_ASSOCIATION
				pstmt1=conAdmin.prepareStatement(AdminStatements.DELETE_USER_GROUP_ASSOCIATION_DETAILS);
				pstmt1.setInt(1, systemId);			
				pstmt1.setInt(2, Integer.parseInt(groupid));
				int up3=pstmt1.executeUpdate();
				if(up3>0){tableList.add("Delete"+"##"+"ADMINISTRATOR.dbo.USER_ASSET_GROUP_ASSOCIATION");}
				
				pstmt=conAdmin.prepareStatement(AdminStatements.UPDATE_VEHICLE_CLIENT);
				pstmt.setString(1,defaultgroupname.toUpperCase().trim());
				pstmt.setInt(2, Integer.parseInt(groupid));
				pstmt.setInt(3, Integer.parseInt(custName));
				pstmt.setInt(4, systemId);			
				int up4=pstmt.executeUpdate();
				if(up4>0){tableList.add("Modify"+"##"+"AMS.dbo.VEHICLE_CLIENT");}
		        pstmt=null;
		        
				pstmt=conAdmin.prepareStatement(AdminStatements.UPDATE_LIVE_VISION_DEFAULT);
				pstmt.setString(1, defaultgroupname.toUpperCase().trim());
				pstmt.setInt(2, Integer.parseInt(groupid));
				pstmt.setString(3, custName);
				pstmt.setInt(4, systemId);
				pstmt.setString(5, custName);
				pstmt.setInt(6, systemId);
				int up5=pstmt.executeUpdate();
				if(up5>0){tableList.add("Modify"+"##"+"AMS.dbo.Live_Vision_Support");}
				pstmt=null;
				
				pstmt=conAdmin.prepareStatement(AdminStatements.UPDATE_DRIVERMASTER_GROUP);
				pstmt.setInt(1, Integer.parseInt(groupid));
				pstmt.setInt(2, Integer.parseInt(custName));
				pstmt.setInt(3, systemId);			
				int up6=pstmt.executeUpdate();
				if(up6>0){tableList.add("Modify"+"##"+"AMS.dbo.Driver_Master");}
				pstmt=null;
				/******************************block of statement has to delete after full impl************************************************/
				pstmt=conAdmin.prepareStatement(AdminStatements.DELETE_VEHICLE_GROUP);
				pstmt.setInt(1, Integer.parseInt(groupid));
				pstmt.setInt(2, Integer.parseInt(custName));
				pstmt.setInt(3, systemId);			
				int up7=pstmt.executeUpdate();
				if(up7>0){tableList.add("Delete"+"##"+"AMS.dbo.VEHICLE_GROUP");}
				
				/***************************************************************************************************************************/
				pstmt=null;
				pstmt=conAdmin.prepareStatement(AdminStatements.DeleteAssetGroupDetails);
				pstmt.setInt(1, Integer.parseInt(groupid));
				pstmt.setInt(2, Integer.parseInt(custName));
				pstmt.setInt(3, systemId);			
				int up8=pstmt.executeUpdate();
				if(up8>0){tableList.add("Delete"+"##"+"ADMINISTRATOR.dbo.ASSET_GROUP");}
				conAdmin.commit();
				try {
					cf.insertDataIntoAuditLogReport(sessionId, tableList, pageName, "DELETE", userId, serverName, systemId,Integer.parseInt(custName),"Deleted Aseet Group Details");
				} catch (Exception e) {
					e.printStackTrace();
				}
				message="Asset Group Deleted";
			
		} catch (Exception e) {
			if (conAdmin != null) {
				try {
					conAdmin.rollback();
				} catch (SQLException e1) {
					e1.toString();
				}
			}
			System.out.println("error in AdminFunction:-delete asset group details "+e.toString());
			message="Error";
		}finally{
			DBConnection.releaseConnectionToDB(conAdmin, pstmt, rs);
			DBConnection.releaseConnectionToDB(null, pstmt1, null);
		}
		return message;
	}


	/**
	 * Getting details of User
	 * @param SystemId
	 * @param CustId
	 * @param userName
	 * @param gpName
	 * @return
	 */
	
	public JSONArray getUserDetails(int systemId, String custId) {
		
		Connection conAdmin=null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject = null;
		try {
			conAdmin=DBConnection.getConnectionToDB("ADMINISTRATOR");
			
			pstmt=conAdmin.prepareStatement(AdminStatements.getUserDetails);
			pstmt.setInt(1, Integer.parseInt(custId));
			pstmt.setInt(2, systemId);
			rs=pstmt.executeQuery();
			
			while(rs.next()){
				jsonObject=new JSONObject();
				
				String userid=rs.getString("USER_ID");
				jsonObject.put("useridIndex", userid);
				
				String username=rs.getString("USER_NAME");
				jsonObject.put("usernameIndex", username);
				
				String password=rs.getString("PASSWORD");
				if(!password.trim().equals("") && password !=null){
				DESEncryptionDecryption DES=new DESEncryptionDecryption();
	  			password = DES.decrypt(password.trim());
			     }
				jsonObject.put("passwordIndex", password);
				
				String fname=rs.getString("FIRST_NAME");
				jsonObject.put("firstnameIndex", fname);
				
				String mname=rs.getString("MIDDLE_NAME");
				jsonObject.put("middlenameIndex", mname);
				
				String lname=rs.getString("LAST_NAME");
				jsonObject.put("lastnameIndex", lname);
				
				String phoneno=rs.getString("PHONE");
				jsonObject.put("phonenoIndex", phoneno);
				
				String mobileno=rs.getString("MOBILE_NUMBER");
				jsonObject.put("mobilenoIndex", mobileno);
				
				String fax=rs.getString("FAX");
				jsonObject.put("faxIndex", fax);
				
				String email=rs.getString("EMAIL");
				jsonObject.put("emailIndex", email);
				
				String branch=rs.getString("BRANCH_ID");
				jsonObject.put("branchidIndex", branch);
				
				String userAuth=rs.getString("USERAUTHORITY");
				jsonObject.put("userauthorityIndex", userAuth);
				
				String roleId=rs.getString("ROLE_ID");  
				jsonObject.put("roleIdIndex", roleId);
				
				String status=rs.getString("STATUS");
				jsonObject.put("statusIndex", status);
				
				if(rs.getString("LOCATION_SETTING").equals("1")){				
					jsonObject.put("locationSettingIndex", "Imprecise");
					}else{
					jsonObject.put("locationSettingIndex", "Precise");	
					}
			
				String branchName="";
				if(rs.getString("BranchName")!=null){
					branchName=rs.getString("BranchName");
				}
				jsonObject.put("branchnameIndex", branchName);
				
				String emvision="";
				if(rs.getString("EMVISION")!=null){
					emvision=rs.getString("EMVISION");
				}
				if (emvision.equals("0")) {
					jsonObject.put("processIdIndex", "");
				} else {
					jsonObject.put("processIdIndex", emvision);
				}
				
				
				jsonArray.put(jsonObject);
			}
			
		} catch (Exception e) {
			System.out.println("error in AdminFunctions:-get user details "+e.toString());
			
		}finally{
			DBConnection.releaseConnectionToDB(conAdmin, pstmt, rs);
		}
		return jsonArray;
	}
	
	
public JSONArray getUserProfileDetails(int systemId, int userId,int customerId) {
		
		Connection conAdmin=null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject = null;
		try {
			conAdmin=DBConnection.getConnectionToDB("ADMINISTRATOR");
			
			pstmt=conAdmin.prepareStatement(AdminStatements.getUserProfileDetails);
			pstmt.setInt(1, userId);
			pstmt.setInt(2, systemId);
			pstmt.setInt(3, customerId);
			rs=pstmt.executeQuery();
			
			while(rs.next()){
				jsonObject=new JSONObject();
				String username=rs.getString("USER_NAME");
				jsonObject.put("userName", username);
				String password=rs.getString("PASSWORD");
				if(!password.trim().equals("") && password !=null){
				DESEncryptionDecryption DES=new DESEncryptionDecryption();
	  			password = DES.decrypt(password.trim());
				}
				jsonObject.put("password", password);
				
				String fname=rs.getString("FIRST_NAME");
				jsonObject.put("firstName", fname);
				
				String mname=rs.getString("MIDDLE_NAME");
				jsonObject.put("middelName", mname);
				
				String lname=rs.getString("LAST_NAME");
				jsonObject.put("lastName", lname);
				
				String phoneno=rs.getString("PHONE");
				jsonObject.put("phoneNo", phoneno);
				
				String mobileno=rs.getString("MOBILE_NUMBER");
				jsonObject.put("mobileNo", mobileno);
				
				String fax=rs.getString("FAX");
				jsonObject.put("fax", fax);
				
				String email=rs.getString("EMAIL");
				jsonObject.put("email", email);
				
				int mapType=rs.getInt("Map_Type");
				jsonObject.put("mapType", mapType);
				
				jsonArray.put(jsonObject);
			}
			
		} catch (Exception e) {
			System.out.println("error in AdminFunctions:-get user details "+e.toString());
			
		}finally{
			DBConnection.releaseConnectionToDB(conAdmin, pstmt, rs);
		}
		return jsonArray;
	}
	
	/**
	 * Deleting the customer details of customer
	 * @param CustId
	 * @return
	 */
	public String deleteCustomerDetails(String custName,int systemId,String CustId,String deletedUser,String systemName,String categoryType,
			String pageName,String sessionId,String serverName,int userId){
		String message="";
		Connection conAdmin=null;
		Connection conAMS=null;
		PreparedStatement pstmt=null;
		CallableStatement cstmt=null;
		ResultSet rs=null;
		int deleted=0;
		ArrayList<String> tableList=new ArrayList<String>();
		try {
			conAMS=DBConnection.getConnectionToDB("AMS");
			pstmt=conAMS.prepareStatement(AdminStatements.getVehicleDetails);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2,Integer.parseInt(CustId) );
			rs=pstmt.executeQuery();
			if(rs.next())
			{
				message="Disassociate the vehicles associated to this customer";
			}
			else
			{
			
			conAdmin=DBConnection.getConnectionToDB("ADMINISTRATOR");
			pstmt=conAdmin.prepareStatement(AdminStatements.CUSTOMER_MOVING_TO_HISTORY);
			pstmt.setString(1, deletedUser);
			pstmt.setInt(2, systemId);
			pstmt.setInt(3, Integer.parseInt(CustId.trim()));
			deleted = pstmt.executeUpdate();
			if(deleted>0){tableList.add("Insert"+"##"+"ADMINISTRATOR.dbo.CUSTOMER_MASTER_HISTORY");}
			
			cstmt=conAdmin.prepareCall(AdminStatements.DELETE_CUSTOMER_STORED_PROCEDURE);
			cstmt.setInt(1,Integer.parseInt(CustId));
			cstmt.setInt(2,systemId);
			cstmt.executeUpdate();
			tableList.add("Delete"+"##"+"ADMINISTRATOR.dbo.CUSTOMER_MASTER");
			message="Deleted";	
			
			
			/*********************************************** block to generate email  *****************************************************/
				pstmt=null;
				rs=null;
				String subject="Customer Information Notification";
				String body=getEmailTemplateForCustomerInformation(custName,"delete",deletedUser,systemName);
				StringBuilder mailListBuilder = new StringBuilder();
				ArrayList<String> mailList = new ArrayList<String>();
				pstmt=conAdmin.prepareStatement(AdminStatements.GET_MAIL_IDS);
				pstmt.setString(1, categoryType);
				rs=pstmt.executeQuery();
				while(rs.next()){
					mailList.add(rs.getString("EMAIL_ID"));
				}
					for (int j = 0; j < mailList.size(); j++) {
						if (j == mailList.size() - 1) {
								mailListBuilder.append(mailList.get(j).toString());
							} else {
								mailListBuilder.append(mailList.get(j).toString() + ",");
							}
					}
				pstmt=null;
				rs=null;
				
				if(deleted > 0)
				{
					
					pstmt=conAdmin.prepareStatement(AdminStatements.INSERT_INTO_EMAIL_QUEUE);
					pstmt.setString(1, subject);
					pstmt.setString(2, body);
					pstmt.setString(3, mailListBuilder.toString());
					pstmt.setInt(4, systemId);
					pstmt.executeUpdate();
					tableList.add("Insert"+"##"+"AMS.dbo.EmailQueue");
					pstmt=null;
					mailListBuilder=null;
				}
			}
			
			try {
				cf.insertDataIntoAuditLogReport(sessionId, tableList, pageName, "DELETE", userId, serverName, systemId, 0,"Delete Customer Details");
			} catch (Exception e) {
				e.printStackTrace();
			}
		 /**************************************************************************************************************************/
		
		} catch (Exception e) {
			System.out.println("Exception in AdminFunctions:-deleteCustomerDetails "+e.toString());
			message="error";
		}
		finally{
			DBConnection.releaseConnectionToDB(conAdmin, pstmt, null);
			DBConnection.releaseConnectionToDB(conAMS, pstmt, rs);
		}
		return message;		
	}
	
	/**
	 * saving the applicationdownloaderdetails
	 * @param custName
	 * @param mobNo
	 * @param email
	 * @param designation
	 * @return
	 */
		public String saveAppsDownloaderDetails(int systemId, int customerId, int createdby, String custName, String mobNo,
				String email, String designation) {
			
			Connection conAdmin=null;
			PreparedStatement pstmt=null;
			String message="save";
			try {
				conAdmin=DBConnection.getConnectionToDB("ADMINISTRATOR");
				pstmt=conAdmin.prepareStatement(AdminStatements.SAVE_DOWNLOADER_DETAILS);
				pstmt.setInt(1, systemId);
				pstmt.setInt(2, customerId);
				pstmt.setString(3, custName);
				pstmt.setString(4, mobNo);
				pstmt.setString(5, email);
				pstmt.setString(6, designation);
				pstmt.setInt(7, createdby);
				int i=pstmt.executeUpdate();
				
				if(i>0){
					message="save";
				}else{
					message="error";
				}
			} catch (Exception e) {
				System.out.println("Exception in Adminfunction:-savedownloaderdetails"+e);
			}finally{
				DBConnection.releaseConnectionToDB(conAdmin, pstmt, null);
			}
			
			
			return message;
		}
	
	/**
	 * getting group feature structure
	 * @param userId
	 * @param clientId
	 * @return
	 */
			public JSONArray getFeatureGroupTree(String language, String userId, String clientId,int systemId, int createdUser) {
                JSONArray jsonArray=new JSONArray();
				
        
				
							Connection conAdmin=null;
							PreparedStatement pstmt=null;
							ResultSet rs=null;
					try {
							conAdmin=DBConnection.getConnectionToDB("ADMINISTRATOR");
							pstmt=conAdmin.prepareStatement(AdminStatements.GET_CHECKED_MENU);
							pstmt.setInt(1, systemId);
							pstmt.setInt(2, Integer.parseInt(userId));
							rs=pstmt.executeQuery();
							
							ArrayList<String> al=new ArrayList<String>();
							while(rs.next()){
								al.add(rs.getString("MENU_ID").trim());
							}
							
							pstmt=null;
							rs=null;
							if(clientId.equals("0") && !userId.equals("0")){
								pstmt=conAdmin.prepareStatement(AdminStatements.GETFEATUREGROUPTREE_LTSP);
								pstmt.setInt(1, systemId);
								pstmt.setInt(2, Integer.parseInt(userId));
								pstmt.setInt(3, systemId);
								pstmt.setInt(4, systemId);
								pstmt.setInt(5, systemId);
							}else{
							pstmt=conAdmin.prepareStatement(AdminStatements.GETFEATUREGROUPTREE);
							pstmt.setInt(1, systemId);
							pstmt.setInt(2, Integer.parseInt(userId));
							pstmt.setInt(3, Integer.parseInt(clientId));
							pstmt.setInt(4, systemId);
							pstmt.setInt(5, systemId);
							pstmt.setInt(6, systemId);
							}
					
							rs=pstmt.executeQuery();
							String previousFeatureName="";
							String featurename="";
							String prevSubfeature="";
							String subfeaturename="";
							String menu="";
							String menuid="";
							boolean checkedmenu=false;
							
							//getting hashmap with language specific words
							
						

							JSONObject jsonObjectfeature=new JSONObject();
							JSONArray jsonArraySubFeature=new JSONArray();
							JSONObject jsonObjectsubfeaturetemp=new JSONObject();
							//int is used to stop first time entry of feature in array
							int j=0;
							boolean flagmenu=false;
							JSONArray jsonArrayMenutemp=new JSONArray();
						boolean checkFlagSub=false;
						boolean checkFlagFeature=false;
														//looping for getting featurename, sub feature name , menu and id
						while(rs.next()){
							
							String featurenamelangconverted = "";
							
							featurename=rs.getString("PROCESS_LABEL_ID").trim();
							if(rs.getString("PROCESS_LABEL_ID").trim()!="" || rs.getString("PROCESS_LABEL_ID").trim()!=null){
							featurenamelangconverted=cf.getLabelFromDB(featurename, language);//featurename;
							}
							subfeaturename=rs.getString("Sub_Feature").trim();
							String subfeaturenamelangconverted = subfeaturename;
							
							//if(rs.getString("Sub_Feature")!=null) {
							//subfeaturenamelangconverted=cf.getLabelFromDB(subfeaturename, language);
							
							//}
							String menulangcoverted="";
							 menu=rs.getString("MENU_LABEL_ID").trim();
							 if(rs.getString("MENU_LABEL_ID").trim()!=null){
							 menulangcoverted=cf.getLabelFromDB(menu, language);
							 }
							
							menuid=rs.getString("MENU_ID").trim();
							
							//int menuidflag=Integer.parseInt(menuid);
							
							for (int i = 0; i < al.size(); i++) {
								
								if(al.contains(menuid)){
									checkedmenu=true;
								}else{
									checkedmenu=false;
									
								}
							}
							
							
							//this if block is for adding feature name 
							if(previousFeatureName=="" || !previousFeatureName.equals(featurename)){
							
							if(j>0){
								
							if(flagmenu==true){	
								jsonObjectfeature.put("checked", checkFlagFeature);
								jsonObjectfeature.put("children", jsonArrayMenutemp);
								jsonArray.put(jsonObjectfeature) ;
							}
							
							else if(flagmenu==false){
								
							if(!previousFeatureName.equals(featurename)){
								jsonObjectsubfeaturetemp.put("checked", checkFlagSub);
								jsonObjectsubfeaturetemp.put("children", jsonArrayMenutemp);
								jsonArraySubFeature.put(jsonObjectsubfeaturetemp);
								
							}
								jsonObjectfeature.put("checked", checkFlagFeature);
								jsonObjectfeature.put("children", jsonArraySubFeature);
								jsonArray.put(jsonObjectfeature) ;
							}	
							checkFlagSub=false;
							checkFlagFeature=false;
							}
							if(checkedmenu){
								checkFlagSub=true;
								checkFlagFeature=true;
							}
							flagmenu=false;
							j++;
																				
							jsonObjectfeature=new JSONObject();
							jsonObjectfeature.put("text", featurenamelangconverted);
							jsonObjectfeature.put("data", 0);
							jsonObjectfeature.put("leaf", false);							
							
							jsonObjectsubfeaturetemp=new JSONObject();
							jsonArraySubFeature=new JSONArray();
							jsonObjectsubfeaturetemp.put("text", subfeaturenamelangconverted);
							jsonObjectsubfeaturetemp.put("data", 0);
							jsonObjectsubfeaturetemp.put("leaf", false);							
							
							JSONObject jsonObjectMenutemp=new JSONObject();
							jsonArrayMenutemp=new JSONArray();
							jsonObjectMenutemp.put("text", menulangcoverted);
							jsonObjectMenutemp.put("data", menuid);
							jsonObjectMenutemp.put("leaf", true);
							jsonObjectMenutemp.put("checked", checkedmenu);
							if(checkedmenu){
								jsonObjectMenutemp.put("cls", "treecomplete");
							}
							
							jsonArrayMenutemp.put(jsonObjectMenutemp);
							
							previousFeatureName=featurename;
							prevSubfeature=subfeaturename;
							
							}else if(previousFeatureName.equals(featurename)){
							//this block is for adding menu until new subfeature hasnt come	
							if(!subfeaturename.equals("")){
							if(previousFeatureName.equals(featurename) && prevSubfeature.equals(subfeaturename) ){
								if(!checkedmenu){
									checkFlagSub=false;
									checkFlagFeature=false;
								}
							JSONObject jsonObjectMenutemp=new JSONObject();
							jsonObjectMenutemp.put("text", menulangcoverted);
							jsonObjectMenutemp.put("data", menuid);
							jsonObjectMenutemp.put("leaf", true);
							jsonObjectMenutemp.put("checked", checkedmenu);
							if(checkedmenu){
								jsonObjectMenutemp.put("cls", "treecomplete");
							}
							jsonArrayMenutemp.put(jsonObjectMenutemp);
							
							previousFeatureName=featurename;
							prevSubfeature=subfeaturename;
							
							}
						else if(previousFeatureName.equals(featurename) && !prevSubfeature.equals(subfeaturename)){
							// adding subfeature in tree aray i.e. json Array
							jsonObjectsubfeaturetemp.put("checked", checkFlagSub);
							jsonObjectsubfeaturetemp.put("children", jsonArrayMenutemp);
							jsonArraySubFeature.put(jsonObjectsubfeaturetemp);
							checkFlagSub=false;
							if(checkedmenu){
								checkFlagSub=true;
							}else{
								checkFlagFeature=false;
							}
							jsonObjectsubfeaturetemp=new JSONObject();
							jsonObjectsubfeaturetemp.put("text", subfeaturenamelangconverted);
							jsonObjectsubfeaturetemp.put("data", 0);
							jsonObjectsubfeaturetemp.put("leaf", false);
							
							
							JSONObject jsonObjectMenutemp=new JSONObject();
						    jsonArrayMenutemp=new JSONArray();
							jsonObjectMenutemp.put("text", menulangcoverted);
							jsonObjectMenutemp.put("data", menuid);
							jsonObjectMenutemp.put("leaf", true);
							jsonObjectMenutemp.put("checked", checkedmenu);
							if(checkedmenu){
								jsonObjectMenutemp.put("cls", "treecomplete");
							}
							jsonArrayMenutemp.put(jsonObjectMenutemp);
							
							previousFeatureName=featurename;
							prevSubfeature=subfeaturename;
							
						}
						
						}else{
							if(!checkedmenu){
								checkFlagSub=false;
								checkFlagFeature=false;
							}
							JSONObject jsonObjectMenutemp=new JSONObject();
							jsonObjectMenutemp.put("text", menulangcoverted);
							jsonObjectMenutemp.put("data", menuid);
							jsonObjectMenutemp.put("leaf", true);
							jsonObjectMenutemp.put("checked", checkedmenu);
							if(checkedmenu){
								jsonObjectMenutemp.put("cls", "treecomplete");
							}
							jsonArrayMenutemp.put(jsonObjectMenutemp);
							previousFeatureName=featurename;
							prevSubfeature=subfeaturename;
							flagmenu=true;
						}
						
							}
						}
						
						//at the last final feature is added in array
						if(flagmenu==true){	
							jsonObjectfeature.put("checked", checkFlagFeature);
							jsonObjectfeature.put("children", jsonArrayMenutemp);
							jsonArray.put(jsonObjectfeature) ;
						}
						else if(flagmenu==false){
						jsonObjectsubfeaturetemp.put("checked", checkFlagSub);
						jsonObjectsubfeaturetemp.put("children", jsonArrayMenutemp);
						jsonArraySubFeature.put(jsonObjectsubfeaturetemp);
						jsonObjectfeature.put("checked", checkFlagFeature);
						jsonObjectfeature.put("children", jsonArraySubFeature);
						jsonArray.put(jsonObjectfeature) ;
						}	
						
						
					} catch (Exception e) {
						System.out.println("Error in Admin Function:-getFeaturegrouptree"+e);
					}finally{
						DBConnection.releaseConnectionToDB(conAdmin, pstmt, rs);
					}
				
				return jsonArray;
			}

			/**
			 * save User Feature Detaichment Info
			 * @param systemId
			 * @param custoId
			 * @param selectedfeatures
			 * @param useId
			 * @param createdUser
			 * @return
			 */
	public String saveUserFeatureDetaichmentInfo(int systemId, String custoId,
			String selectedfeatures, String useId, int createdUser,String pageName,String sessionId,String serverName) {
		int userId=Integer.parseInt(useId);
		boolean newoldflag=true;
		Connection conAdmin=null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		String message="";
		ArrayList<String> tableList=new ArrayList<String>();
		try {
			//checking whether the user future detachment is old or new
			conAdmin=DBConnection.getConnectionToDB("ADMINISTRATOR");
			pstmt=conAdmin.prepareStatement(AdminStatements.CHECK_USER_FEATURE_DETACHMENT);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, userId);
			rs=pstmt.executeQuery();
			if(rs.next()){
				newoldflag=false;
			}else{
				newoldflag=true;
			}
			
			pstmt=null;
			
			int j=0;
			//saving in case of new user else modifying in case of existing userfeature detachment
			
			if(newoldflag==true){
				if(selectedfeatures.contains(",")){
				String str[]=selectedfeatures.split(",");
				for (int i = 0; i < str.length; i++) {
			pstmt=conAdmin.prepareStatement(AdminStatements.SAVE_USER_FEATURE_DETACHMENT_INFO);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, userId);
			pstmt.setString(3, str[i]);
			pstmt.setInt(4, createdUser);
			j=pstmt.executeUpdate();
				}
				}
			}else{
				pstmt=conAdmin.prepareStatement(AdminStatements.DELETE_USER_FEATURE_DETACHMENT_INFO);
				pstmt.setInt(1, userId);
				pstmt.setInt(2, systemId);
				j=pstmt.executeUpdate();
				if(selectedfeatures.contains(",")){
				String str[]=selectedfeatures.split(",");
				for (int i = 0; i < str.length; i++) {
					pstmt=conAdmin.prepareStatement(AdminStatements.SAVE_USER_FEATURE_DETACHMENT_INFO);
					pstmt.setInt(1, systemId);
					pstmt.setInt(2, userId);
					pstmt.setString(3, str[i]);
					pstmt.setInt(4, createdUser);
					j=pstmt.executeUpdate();
						}
				}
			}
			if(j>0){tableList.add("Insert"+"##"+"dbo.USER_PROCESS_DETACHMENT");}
			try {
				cf.insertDataIntoAuditLogReport(sessionId, tableList, pageName, "Detachment", createdUser, serverName, systemId,Integer.parseInt(custoId),"Added User Feature Detachment Details");
			} catch (Exception e) {
				e.printStackTrace();
			}
			message="Saved Successfully";
			
		} catch (Exception e) {
			System.out.println("Error in Admin Function:-saveUserFeatureDetaichmentInfo-"+e);
			message="error";
		}finally{
			DBConnection.releaseConnectionToDB(conAdmin, pstmt, null);
		}
		return message;
	}
/**
 * getting country list from db
 * @return
 */
	public JSONArray getCountryList() {
		Connection conAdmin=null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject = new JSONObject();
		try {
			conAdmin=DBConnection.getConnectionToDB("ADMINISTRATOR");
			pstmt=conAdmin.prepareStatement(AdminStatements.Get_COUNTRY_LIST);
			rs=pstmt.executeQuery();
			while(rs.next()){
				jsonObject = new JSONObject();
				jsonObject.put("CountryID", rs.getString("COUNTRY_CODE"));
				jsonObject.put("CountryName", rs.getString("COUNTRY_NAME"));
				jsonObject.put("Offset", rs.getString("OFFSET"));
				jsonArray.put(jsonObject);
			}
			
		} catch (Exception e) {
			System.out.println("Error in Admin Functions:-getCountryList "+e.toString());
		}finally{
			DBConnection.releaseConnectionToDB(conAdmin, pstmt, rs);
		}
		return jsonArray;
	}
/***
 * function for getting State Name List from db
 * @return
 */
	public JSONArray getStateList(String countryid) {
		Connection conAdmin=null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject = new JSONObject();
		
		int countrycode=Integer.parseInt(countryid);
		try {
			conAdmin=DBConnection.getConnectionToDB("ADMINISTRATOR");
			pstmt=conAdmin.prepareStatement(AdminStatements.Get_STATE_LIST);
			pstmt.setInt(1, countrycode);
			rs=pstmt.executeQuery();
			while(rs.next()){
				jsonObject=new JSONObject();
				jsonObject.put("StateID", rs.getString("STATE_CODE"));
				jsonObject.put("StateName", rs.getString("STATE_NAME"));
				jsonObject.put("Region",rs.getString("REGION"));
				jsonArray.put(jsonObject);
			}
			
		} catch (Exception e) {
			System.out.println("Error in Admin Functions:-getStateList "+e.toString());
		}finally{
			DBConnection.releaseConnectionToDB(conAdmin, pstmt, rs);
		}
		return jsonArray;
	}
/**
 * get Process LabelId List
 * @param custId
 * @param language
 * @return
 */
	public JSONArray getProcessLabelIdList(String custId, String language) {
		Connection conAdmin=null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject = new JSONObject();
		try {
			conAdmin=DBConnection.getConnectionToDB("ADMINISTRATOR");
			pstmt=conAdmin.prepareStatement(AdminStatements.Get_PROCESS_LABELID_LIST);
			pstmt.setInt(1, Integer.parseInt(custId));
			rs=pstmt.executeQuery();
			while(rs.next()){
				jsonObject=new JSONObject();
				jsonObject.put("ProcessId", rs.getString("PROCESS_ID"));
				jsonObject.put("ProcessLabelId", rs.getString("PROCESS_LABEL_ID"));
				jsonArray.put(jsonObject);
			}
			
		} catch (Exception e) {
			System.out.println("error in Admin function:-getProcessLabelIdList"+e);
		}finally{
			DBConnection.releaseConnectionToDB(conAdmin, pstmt, rs);
		}
		return jsonArray;
	}

		/** Gets Asset group Details
	 * @param customerid
	 * @param systemId
	 * @return
	 */
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
			pstmt = conAdmin.prepareStatement(AdminStatements.GET_ASSET_GROUP_DETAILS.replace("LOCATION", "LOCATION_ZONE_"+zone));
			pstmt.setInt(1, Integer.parseInt(customerid));
			pstmt.setInt(2, systemId);
			rs = pstmt.executeQuery();
			while (rs.next()) {	
				count++;
				AssetGroupJsonObject = new JSONObject();
				String groupId=rs.getString("GROUP_ID");
				String assetgroupName = rs.getString("GROUP_NAME");
				String supervisorID=rs.getString("SUPERVISOR_ID");
				String supervisorName = rs.getString("NAME");
				String supervisorEmail = rs.getString("EMAIL");
				String supervisorNo=rs.getString("PHONE");
				String status=rs.getString("ACTIVATION_STATUS");
				String statecode=rs.getString("STATE_CODE");
				String statename=rs.getString("STATE_NAME");
				String cityId=rs.getString("CITY_ID");
				String cityName=rs.getString("CITY_NAME");
				String hubId=rs.getString("HubId");
				String hubName=rs.getString("hubName");
				
				AssetGroupJsonObject.put("slnoIndex", count);
				AssetGroupJsonObject.put("assetgroupidIndex", groupId);
				AssetGroupJsonObject.put("assetgroupnameIndex", assetgroupName);
				AssetGroupJsonObject.put("hubIdIndex", hubId);
				AssetGroupJsonObject.put("hubNameIndex", hubName);
				
				
				if(!supervisorName.equals(""))
				{
				AssetGroupJsonObject.put("supervisoridIndex", supervisorID);
				AssetGroupJsonObject.put("supervisornameIndex", supervisorName);
				AssetGroupJsonObject.put("supervisoremailIndex", supervisorEmail);
				AssetGroupJsonObject.put("supervisornoIndex", supervisorNo);
				}
				else
				{
				AssetGroupJsonObject.put("supervisoridIndex","");
				AssetGroupJsonObject.put("supervisornameIndex","");
				AssetGroupJsonObject.put("supervisoremailIndex","");
				AssetGroupJsonObject.put("supervisornoIndex","");
				}
				AssetGroupJsonObject.put("status", status);
				AssetGroupJsonObject.put("statecode", statecode);
				AssetGroupJsonObject.put("statename", statename);
				AssetGroupJsonObject.put("cityId", cityId);
				AssetGroupJsonObject.put("cityName", cityName);
				AssetGroupJsonArray.put(AssetGroupJsonObject);
			}
		} catch (Exception e) {
			System.out.println("Error in Admin Functions:- getAssetGroupDetails "+e.toString());
		} finally {
			DBConnection.releaseConnectionToDB(conAdmin, pstmt, rs);
		}

		return AssetGroupJsonArray;
	
	}

	/** Checking for same Group Name
	 * @param custId
	 * @param systemId
	 * @param groupName
	 * @return
	 */
	public boolean assetGroupExist(String custId, int systemId, String groupName) {
		Connection conAdmin = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		boolean assetGroupFlag = false;
		try {
			conAdmin = DBConnection.getConnectionToDB("ADMINISTRATOR");
			pstmt = conAdmin.prepareStatement(AdminStatements.CheckGroupName);
			pstmt.setInt(1, Integer.parseInt(custId));
			pstmt.setInt(2, systemId);
			pstmt.setString(3, groupName.toUpperCase().trim());
			rs = pstmt.executeQuery();
			if (rs.next()) {
				assetGroupFlag = true;
			}
		} catch (Exception e) {
			assetGroupFlag = false;
			System.out.println("Error in Admin Functions:- assetGroupExist "+e.toString());
		}
		 finally {
				DBConnection.releaseConnectionToDB(conAdmin, pstmt, rs);
			}
		return assetGroupFlag;
	}

	/** Inserting Asset Group
	 * @param assetGroupName
	 * @param assetSuperiorName
	 * @param systemId
	 * @param createdUser
	 * @param cutomerId
	 * @return
	 */
	public String saveAssetGroupDetails(String assetGroupName,
			String assetSuperiorName,String assetgroupstate, int systemId, int createdUser,
			String cutomerId,int hubId,int cityId,String pageName,String sessionId,String serverName) {
		Connection conAdmin = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String message="";
		ArrayList<String> tableList=new ArrayList<String>();

		int groupID=0;
		try {
			conAdmin = DBConnection.getConnectionToDB("ADMINISTRATOR");					
//			pstmt = conAdmin.prepareStatement(AdminStatements.SaveAssetGroupDetails,Statement.RETURN_GENERATED_KEYS);
//			pstmt.setString(1, assetGroupName.toUpperCase().trim());
//			pstmt.setInt(2, Integer.parseInt(cutomerId));
//			pstmt.setInt(3, systemId);
//			pstmt.setInt(4, Integer.parseInt(assetSuperiorName));
//			pstmt.setInt(5, createdUser);
//			pstmt.executeUpdate();
//			rs=pstmt.getGeneratedKeys();
//			if(rs.next())
//			{
//				groupID=rs.getInt(1);
				/******************************block of statement has to delete after full impl************************************************/
//				pstmt=null;
//				pstmt = conAdmin.prepareStatement(AdminStatements.SAVE_IN_VEHICLE_GROUP);
//				pstmt.setInt(1,groupID);
//				pstmt.setString(2, assetGroupName.toUpperCase().trim());
//				pstmt.setInt(3, Integer.parseInt(cutomerId));
//				pstmt.setInt(4, systemId);
//				pstmt.setInt(5, createdUser);
//				pstmt.setInt(6, Integer.parseInt(assetSuperiorName));
//				pstmt.executeUpdate();
				pstmt=null;
				pstmt = conAdmin.prepareStatement(AdminStatements.SAVE_IN_VEHICLE_GROUP_Without_ID,Statement.RETURN_GENERATED_KEYS);
				pstmt.setString(1, assetGroupName.toUpperCase().trim());
				pstmt.setInt(2, Integer.parseInt(cutomerId));
				pstmt.setInt(3, systemId);
				pstmt.setInt(4, createdUser);
				pstmt.setInt(5, Integer.parseInt(assetSuperiorName));
				pstmt.executeUpdate();
				rs=pstmt.getGeneratedKeys();
				if(rs.next())
				{
					tableList.add("Insert"+"##"+"AMS.dbo.VEHICLE_GROUP");
					groupID=rs.getInt(1);
					pstmt=null;
					pstmt = conAdmin.prepareStatement(AdminStatements.SaveAssetGroupDetails_WithID);
					pstmt.setInt(1,groupID);
					pstmt.setString(2, assetGroupName.toUpperCase().trim());
					pstmt.setInt(3, Integer.parseInt(cutomerId));
					pstmt.setInt(4, systemId);
					pstmt.setInt(5, Integer.parseInt(assetSuperiorName));
					pstmt.setInt(6, createdUser);
					pstmt.setInt(7, Integer.parseInt(assetgroupstate));
					pstmt.setInt(8, cityId);
					pstmt.setInt(9, hubId);
					int up=pstmt.executeUpdate();
					if(up>0){
						tableList.add("Insert"+"##"+"ADMINISTRATOR.dbo.ASSET_GROUP");
					}
					try {
						cf.insertDataIntoAuditLogReport(sessionId, tableList, pageName, "ADD", createdUser, serverName, systemId,Integer.parseInt(cutomerId),
								"Added Asset Group Details");
					} catch (Exception e) {
						e.printStackTrace();
					}
					
					message="Asset Group Added,"+groupID;
				}
				/***************************************************************************************************************************/
//				message="Asset Group Added,"+groupID;	
//			}
			else
			{
				message="Error is Adding Asset Group";	
			}
		} catch (Exception e) {
				message="Error";	
			System.out.println("Error in Admin Functions:-saveAssetGroupDetails "+e.toString());
		} finally {
			DBConnection.releaseConnectionToDB(conAdmin, pstmt, rs);
		}
		return message;
	}

	/** Modifying Asset Group
	 * @param newGroupName
	 * @param assetGroupID
	 * @param assetSuperiorName
	 * @param systemId
	 * @param createdUser
	 * @param cutomerId
	 * @return
	 */
	public String modifyAssetGroupDetails(String newGroupName,String assetGroupName,String assetgroupstate,String assetGroupID,
			String assetSuperiorName, int systemId, int createdUser,
			String customerId,int hubId,int cityId,String pageName,String sessionId,String serverName) {

		Connection conAdmin = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int result = 0;
		String message="";
		ArrayList<String> tableList=new ArrayList<String>();
		try {
			conAdmin = DBConnection.getConnectionToDB("ADMINISTRATOR");
			pstmt=conAdmin.prepareStatement(AdminStatements.ModifyAssetGroupDetails);
			pstmt.setString(1, newGroupName.toUpperCase().trim());
			pstmt.setString(2, assetSuperiorName);
			pstmt.setString(3, assetgroupstate);
			pstmt.setInt(4, cityId);
			pstmt.setInt(5, hubId);
			pstmt.setInt(6, Integer.parseInt(customerId));
			pstmt.setInt(7, systemId);
			pstmt.setString(8, assetGroupID);
			result = pstmt.executeUpdate();
			if(result>0){
				tableList.add("Update"+"##"+"ADMINISTRATOR.dbo.ASSET_GROUP");
			}
			pstmt=null;
			/******************************block of statement has to delete after full impl************************************************/
			pstmt=conAdmin.prepareStatement(AdminStatements.ModifyVehicleGroupDetails);
			pstmt.setString(1, newGroupName.toUpperCase().trim());
			pstmt.setString(2, assetSuperiorName);
			pstmt.setInt(3, Integer.parseInt(customerId));
			pstmt.setInt(4, systemId);
			pstmt.setString(5, assetGroupID);
			result = pstmt.executeUpdate();
			if(result>0){
				tableList.add("Update"+"##"+"AMS.dbo.VEHICLE_GROUP");
			}
			pstmt=null;
			/****************************************************************************************************************************/
			if(result>0)
			{
				if(!newGroupName.toUpperCase().trim().equals(assetGroupName.toUpperCase().trim()))
				{
					pstmt=conAdmin.prepareStatement(AdminStatements.UPDATE_LIVE_VISION);
					pstmt.setString(1, newGroupName.toUpperCase().trim());
					pstmt.setString(2, assetGroupName.toUpperCase().trim());
					pstmt.setString(3, customerId);
					pstmt.setInt(4, systemId);
					int up=pstmt.executeUpdate();
					if(up>0){
						tableList.add("Update"+"##"+"AMS.dbo.Live_Vision_Support");
					}
				}
				try {
					cf.insertDataIntoAuditLogReport(sessionId, tableList, pageName, "MODIFY", createdUser, serverName, systemId,Integer.parseInt(customerId),
							"Updated Asset Group Details");
				} catch (Exception e) {
					e.printStackTrace();
				}
				
				message="Asset Group Modified";	
			}
		} catch (Exception e) {
			message="Error";
			System.out.println("Error in Admin Functions:-modifyAssetGroupDetails "+e.toString());
		} finally {
			DBConnection.releaseConnectionToDB(conAdmin, pstmt, rs);
		}
		return message;
	
	}
	
	/**
	 * Getting Product Mandatory Process 
	 * @param systemId
	 * @param language
	 * @param CustId
	 * @param Group
	 * @return
	 */
	
	public JSONArray getProductMandatoryProcess(int systemId,String language,String CustId,boolean Group) {
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject = null;
		Connection conAdmin=null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		try {
			conAdmin=DBConnection.getConnectionToDB("ADMINISTRATOR");
			if(!Group){
			pstmt=conAdmin.prepareStatement(AdminStatements.GET_PRODUCT_MANDATORY_PROCESS);
			pstmt.setInt(1, systemId);
			}else{
				pstmt=conAdmin.prepareStatement(AdminStatements.GET_PRODUCT_MANDATORY_PROCESS_FOR_CUSTOMER);
				pstmt.setString(1, CustId);
				pstmt.setInt(2, systemId);
				pstmt.setInt(3, systemId);
			}
			rs=pstmt.executeQuery();
			while(rs.next()){
				jsonObject=new JSONObject();
				jsonObject.put("ProcessNameDataIndex", cf.getLabelFromDB(rs.getString("PROCESS_LABEL_ID"),language));
				jsonObject.put("ProcessIdDataIndex", rs.getString("PROCESS_ID"));
				jsonObject.put("ProcessLabelDataIndex", rs.getString("PROCESS_LABEL_ID"));
				jsonArray.put(jsonObject);
			}
		} catch (Exception e) {
			System.out.println("error in AdminFunction:- getProductMandatoryProcess()"+e);
		}
		finally{
			DBConnection.releaseConnectionToDB(conAdmin, pstmt, rs);
		}
		return jsonArray;
	}
	
	/**
	 * Getting Product Vertical Process 
	 * @param systemId
	 * @param language
	 * @param CustId
	 * @param Group
	 * @return
	 */
	
	public JSONArray getProductVerticalProcess(int systemId,String language,String CustId,boolean Group) {
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject = null;
		Connection conAdmin=null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		try {
			conAdmin=DBConnection.getConnectionToDB("ADMINISTRATOR");
			if(!Group){
			pstmt=conAdmin.prepareStatement(AdminStatements.GET_PRODUCT_VERTICAL_PROCESS);
			pstmt.setInt(1, systemId);
			}else{
				pstmt=conAdmin.prepareStatement(AdminStatements.GET_PRODUCT_VERTICAL_PROCESS_FOR_CUSTOMER);
				pstmt.setString(1, CustId);
				pstmt.setInt(2, systemId);
				pstmt.setInt(3, systemId);
			}
			rs=pstmt.executeQuery();
			while(rs.next()){
				jsonObject=new JSONObject();
				jsonObject.put("ProcessNameDataIndex", cf.getLabelFromDB(rs.getString("PROCESS_LABEL_ID"),language));
				jsonObject.put("ProcessIdDataIndex", rs.getString("PROCESS_ID"));
				jsonObject.put("ProcessLabelDataIndex", rs.getString("PROCESS_LABEL_ID"));
				jsonArray.put(jsonObject);
			}
		} catch (Exception e) {
			System.out.println("error in AdminFunction:- getProductVerticalProcess()"+e);
		}
		finally{
			DBConnection.releaseConnectionToDB(conAdmin, pstmt, rs);
		}
		return jsonArray;
	}
	
	/**
	 *  Getting Product AddOn Process 
	 * @param systemId
	 * @param language
	 * @param CustId
	 * @param Group
	 * @return
	 */
	 
	
	public JSONArray getProductAddOnProcess(int systemId,String language,String CustId,boolean Group) {
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject = null;
		Connection conAdmin=null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		try {
			conAdmin=DBConnection.getConnectionToDB("ADMINISTRATOR");
			if(!Group){
			pstmt=conAdmin.prepareStatement(AdminStatements.GET_PRODUCT_ADD_ON_PROCESS);
			pstmt.setInt(1, systemId);
			}else{
				pstmt=conAdmin.prepareStatement(AdminStatements.GET_PRODUCT_ADDON_PROCESS_FOR_CUSTOMER);
				pstmt.setString(1, CustId);
				pstmt.setInt(2, systemId);
				pstmt.setInt(3, systemId);
			}
			rs=pstmt.executeQuery();
			while(rs.next()){
				jsonObject=new JSONObject();
				jsonObject.put("ProcessNameDataIndex", cf.getLabelFromDB(rs.getString("PROCESS_LABEL_ID"),language));
				jsonObject.put("ProcessIdDataIndex", rs.getString("PROCESS_ID"));
				jsonObject.put("ProcessLabelDataIndex", rs.getString("PROCESS_LABEL_ID"));
				jsonArray.put(jsonObject);
			}
		} catch (Exception e) {
			System.out.println("error in AdminFunction:- getProductAddOnProcess()"+e);
		}
		finally{
			DBConnection.releaseConnectionToDB(conAdmin, pstmt, rs);
		}
		return jsonArray;
	}
	
	
	/**
	 * Getting Product Process Details
	 * @param systemId
	 * @param language
	 * @param processId
	 * @return
	 */
	
	public JSONArray getProductProcessDetails(int systemId,String language,String processId) {
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject = null;
		Connection conAdmin=null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		try {
			conAdmin=DBConnection.getConnectionToDB("ADMINISTRATOR");
			pstmt=conAdmin.prepareStatement(AdminStatements.GET_PRODUCT_PROCESS_DETAILS);
			pstmt.setString(1,processId);
			rs=pstmt.executeQuery();
			String productdetails="";
			String prevsubprocess="";
			int count=0;
			while(rs.next()){
				String subprocess=rs.getString("SUB_PROCESS_LABEL_ID");
				String menu=rs.getString("MENU_LABEL_ID");
				if(prevsubprocess.equals("") && subprocess.equals("") && count==0){
					count=1;
					productdetails=productdetails+"<ul><li>"+cf.getLabelFromDB(menu,language)+"</li>";
				}
				else if(prevsubprocess.equals("") && subprocess.equals("") && count==1){
					productdetails=productdetails+"<li>"+cf.getLabelFromDB(menu,language)+"</li>";
				}
				else if(!prevsubprocess.equals("") && subprocess.equals("")){
					productdetails=productdetails+"</ul><li>"+cf.getLabelFromDB(menu,language)+"</li>";
				}
				else if(prevsubprocess.equals("") && !subprocess.equals("")){
					productdetails=productdetails+"<ul><u><b>"+cf.getLabelFromDB(subprocess,language)+"</b></u><li>"+cf.getLabelFromDB(menu,language)+"</li>";
				}
				else if(!prevsubprocess.equals("") && !subprocess.equals("") && subprocess.equals(prevsubprocess)){
					productdetails=productdetails+"<li>"+cf.getLabelFromDB(menu,language)+"</li>";
				}
				else if(!prevsubprocess.equals("") && !subprocess.equals("") && !subprocess.equals(prevsubprocess)){
					productdetails=productdetails+"</ul><ul><u><b>"+cf.getLabelFromDB(subprocess,language)+"</b></u><li>"+cf.getLabelFromDB(menu,language)+"</li>";
				}
				prevsubprocess=subprocess;
			}
			if(count==1){
				productdetails=productdetails+"</ul>";
			}
			jsonObject=new JSONObject();
			jsonObject.put("ProductDetails", productdetails);
			jsonArray.put(jsonObject);
		} catch (Exception e) {
			System.out.println("error in AdminFunction:- getProductProcessDetails()"+e);
		}
		finally{
			DBConnection.releaseConnectionToDB(conAdmin, pstmt, rs);
		}
		return jsonArray;
	}
	
	/**
	 * Getting Customer Group Process Details
	 * @param systemId
	 * @param CustId
	 * @param GroupId
	 * @return
	 */
	
	public JSONArray getCustomerGrpProcessDetails(int systemId,String CustId,String GroupId) {
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject = null;
		Connection conAdmin=null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		try {
			conAdmin=DBConnection.getConnectionToDB("ADMINISTRATOR");
			if(GroupId.equals("0")){
			pstmt=conAdmin.prepareStatement(AdminStatements.GET_CUSTOMER_PROCESS_ASSOCIATION);
			pstmt.setString(1,CustId);
			pstmt.setInt(2,systemId);
			}else{
				pstmt=conAdmin.prepareStatement(AdminStatements.GET_GROUP_PROCESS_ASSOCIATION);
				pstmt.setString(1,GroupId);
				pstmt.setInt(2,systemId);
			}
			rs=pstmt.executeQuery();
			String processes="";
			while(rs.next()){	
				if(processes.equals("")){
					processes=processes+rs.getString("PROCESS_ID");
				}else{
					processes=processes+","+rs.getString("PROCESS_ID");
				}
			}
			jsonObject=new JSONObject();
			jsonObject.put("CustomerGrpProcessDetails", processes);
			jsonArray.put(jsonObject);
		} catch (Exception e) {
			System.out.println("error in AdminFunction:- getCustomerGrpProcessDetails()"+e);
		}
		finally{
			DBConnection.releaseConnectionToDB(conAdmin, pstmt, rs);
		}
		return jsonArray;
	}
		
	/**
	 * save Customer Or Group Mandatory Process Association
	 * @param systemId
	 * @param userId
	 * @param showGrp
	 * @param customerId
	 * @param groupId
	 * @param checkedServices
	 * @param uncheckedServices
	 * @param ProcessTypeLabel
	 * @param custActivation
	 * @param grpActivation
	 * @param custName
	 * @param categoryType
	 * @param category
	 * @param userName
	 * @return
	 */
 public String saveCustomerOrGroupMandatoryProcessAssociation(int systemId,int userId,String showGrp,String customerId,String groupId,String checkedServices,
		 String uncheckedServices,String ProcessTypeLabel,String custActivation,String grpActivation,String custName,String categoryType,String category,
		 String userName,String systemName,String pageName,String sessionId,String serverName){
	 String mesg="";
		Connection conAdmin=null;
		PreparedStatement pstmt=null;
		PreparedStatement pstmt1=null;
		PreparedStatement pstmt2=null;
		PreparedStatement pstmt3=null;
		ResultSet rs=null;
		ResultSet rs1=null;
		ArrayList<String> tableList=new ArrayList<String>();
		try {
			conAdmin=DBConnection.getConnectionToDB("ADMINISTRATOR");			
				pstmt=conAdmin.prepareStatement(AdminStatements.GET_ESS_ADV_PROCESS_ID);
				rs=pstmt.executeQuery();
				int essProcessID=0;
				int advProcessId=0;
				int count=0;
				while(rs.next()){
					if(count==0){
						essProcessID=rs.getInt("PROCESS_ID");
					}else{
						advProcessId=rs.getInt("PROCESS_ID");
					}
					count=count+1;
				}
				pstmt=null;
				rs=null;
				if(showGrp.equals("false")){
				if(!uncheckedServices.equals("")){
					String[] str=uncheckedServices.split(",");
					for(int i=0;i<str.length;i++){
						if(essProcessID!=Integer.parseInt(str[i].trim())){
							pstmt=conAdmin.prepareStatement(AdminStatements.DELETE_UNCHECKED_PROCESS_FOR_GROUP);
							pstmt.setString(1, str[i]);
							pstmt.setString(2, customerId);
							pstmt.setInt(3, systemId);
							pstmt.setInt(4, systemId);
							pstmt.executeUpdate();
							pstmt=null;
							pstmt=conAdmin.prepareStatement(AdminStatements.DELETE_UNCHECKED_PROCESS_FOR_CUSTOMER);
							pstmt.setString(1, str[i]);
							pstmt.setString(2, customerId);
							pstmt.setInt(3, systemId);
							pstmt.executeUpdate();
							pstmt=null;			
						}
					if(Integer.parseInt(str[i].trim())==21){
						pstmt=conAdmin.prepareStatement(AdminStatements.UPDATE_UNCHECKED_PROCESS_DATA_FOR_CLIENT);
						pstmt.setInt(1, Integer.parseInt(customerId));
						pstmt.setInt(2, systemId);
						pstmt.executeUpdate();
						
						pstmt=conAdmin.prepareStatement(AdminStatements.UPDATE_UNCHECKED_PROCESS_DATA_FOR_AMS_CLIENT);
						pstmt.setInt(1, Integer.parseInt(customerId));
						pstmt.setInt(2, systemId);
						pstmt.executeUpdate();
						
					}
					}
				}
				tableList.add("Delete"+"##"+"ADMINISTRATOR.dbo.CUSTOMER_PROCESS_ASSOC");
				tableList.add("Delete"+"##"+"ADMINISTRATOR.dbo.ASSET_GROUP_PROCESS");
				tableList.add("Update"+"##"+"ADMINISTRATOR.dbo.CUSTOMER_MASTER");
				tableList.add("Update"+"##"+"AMS.dbo.tblCustomerMaster");
				int groupID=0;
				pstmt=conAdmin.prepareStatement(AdminStatements.GET_DEFAULT_GROUP);
				pstmt.setString(1,customerId);
				pstmt.setInt(2,systemId);
				rs=pstmt.executeQuery();
				if(rs.next()){
					groupID=rs.getInt("GROUP_ID");
				}
				pstmt=null;
				rs=null;
				if(!checkedServices.equals("")){
				String[] str=checkedServices.split(",");
				for(int i=0;i<str.length;i++){
					pstmt=conAdmin.prepareStatement(AdminStatements.CHECK_CUST_PROCESS_ASS_EXIST);
					pstmt.setString(1,str[i]);
					pstmt.setString(2, customerId);
					pstmt.setInt(3, systemId);
					rs=pstmt.executeQuery();
					if(rs.next()){
						
					}else{
						pstmt1=conAdmin.prepareStatement(AdminStatements.SAVE_CUSTOMER_PROCESS_ASSOCIATION);
						pstmt1.setString(1,customerId);
						pstmt1.setString(2, str[i]);
						pstmt1.setInt(3, systemId);
						pstmt1.setInt(4, userId);
						int result=pstmt1.executeUpdate();
						pstmt1=null;
						if(result>0)
						{						
							/**
							 * For saving essential when advance process is saved
							 */
							if(advProcessId==Integer.parseInt(str[i].trim())){
								pstmt2=conAdmin.prepareStatement(AdminStatements.CHECK_CUST_PROCESS_ASS_EXIST);
								pstmt2.setInt(1,essProcessID);
								pstmt2.setString(2, customerId);
								pstmt2.setInt(3, systemId);
								rs1=pstmt2.executeQuery();
								if(rs1.next()){
									
								}else{
								pstmt1=conAdmin.prepareStatement(AdminStatements.SAVE_CUSTOMER_PROCESS_ASSOCIATION);
								pstmt1.setString(1,customerId);
								pstmt1.setInt(2, essProcessID);
								pstmt1.setInt(3, systemId);
								pstmt1.setInt(4, userId);
								pstmt1.executeUpdate();
								}
								pstmt1=null;
								pstmt2=null;
								rs1=null;
							}
							pstmt2=conAdmin.prepareStatement(AdminStatements.INSERT_DEFAULT_ASSET_PROCESS);
							pstmt2.setInt(1,groupID);
							pstmt2.setInt(2, systemId);
							pstmt2.setString(3, str[i]);
							pstmt2.setInt(4, userId);
							pstmt2.executeUpdate();
							pstmt2=null;
							pstmt2=conAdmin.prepareStatement(AdminStatements.UPDATE_ASSET_GROUP_STATUS);
							pstmt2.setInt(1,groupID);
							pstmt2.setString(2,customerId);
							pstmt2.setInt(3, systemId);
							pstmt2.executeUpdate();
							pstmt2=null;
							if(advProcessId==Integer.parseInt(str[i].trim())){
								pstmt1=conAdmin.prepareStatement(AdminStatements.CHECK_GROUP_PROCESS_ASS_EXIST);
								pstmt1.setInt(1,essProcessID);
								pstmt1.setInt(2, groupID);
								pstmt1.setInt(3, systemId);
								rs1=pstmt1.executeQuery();
								if(rs1.next()){
									
								}else{
									pstmt2=conAdmin.prepareStatement(AdminStatements.INSERT_DEFAULT_ASSET_PROCESS);
									pstmt2.setInt(1,groupID);
									pstmt2.setInt(2, systemId);
									pstmt2.setInt(3, essProcessID);
									pstmt2.setInt(4, userId);
									pstmt2.executeUpdate();
								}
								pstmt1=null;
								pstmt2=null;
								rs1=null;
							}
							if(custActivation.equals("Incomplete")){
							pstmt3=conAdmin.prepareStatement(AdminStatements.UPDATE_CUSTOMER_ACTIVATION_STATUS);
							pstmt3.setString(1,customerId);
							pstmt3.setInt(2, systemId);
							pstmt3.executeUpdate();
							}
							
						}
					}
				}
				tableList.add("Insert"+"##"+"ADMINISTRATOR.dbo.CUSTOMER_PROCESS_ASSOC");
				tableList.add("Insert"+"##"+"ADMINISTRATOR.dbo.CUSTOMER_MASTER");
				tableList.add("Insert"+"##"+"ADMINISTRATOR.dbo.ASSET_GROUP_PROCESS");
				tableList.add("Update"+"##"+"ADMINISTRATOR.dbo.ASSET_GROUP");
				}
				mesg="Saved Successfully";
				try {
					cf.insertDataIntoAuditLogReport(sessionId, tableList, pageName, "ADD", userId, serverName, systemId,Integer.parseInt(customerId),"Added Customer Mandatory Process Association");
				} catch (Exception e) {
					e.printStackTrace();
				}
			}else{
				pstmt=conAdmin.prepareStatement(AdminStatements.DELETE_GROUP_PROCESS_ASS_EXIST);
				pstmt.setString(1, groupId);
				pstmt.setInt(2, systemId);
				pstmt.setString(3, ProcessTypeLabel.trim());
				int u=pstmt.executeUpdate();
				if(u>0){tableList.add("Delete"+"##"+"ADMINISTRATOR.dbo.ASSET_GROUP_PROCESS");}
				pstmt=null;
				if(!checkedServices.equals("")){
				String[] str=checkedServices.split(",");
				for(int i=0;i<str.length;i++){
					pstmt=conAdmin.prepareStatement(AdminStatements.CHECK_GROUP_PROCESS_ASS_EXIST);
					pstmt.setString(1,str[i]);
					pstmt.setString(2, groupId);
					pstmt.setInt(3, systemId);
					rs=pstmt.executeQuery();
					if(rs.next()){
						
					}else{
						pstmt1=conAdmin.prepareStatement(AdminStatements.SAVE_GROUP_PROCESS_ASSOCIATION);
						pstmt1.setString(1,groupId);
						pstmt1.setInt(2, systemId);
						pstmt1.setString(3, str[i]);						
						pstmt1.setInt(4, userId);
						int result=pstmt1.executeUpdate();
						pstmt1=null;
						if(result>0)
						{
							if(advProcessId==Integer.parseInt(str[i].trim())){
								pstmt1=conAdmin.prepareStatement(AdminStatements.CHECK_GROUP_PROCESS_ASS_EXIST);
								pstmt1.setInt(1,essProcessID);
								pstmt1.setString(2, groupId);
								pstmt1.setInt(3, systemId);
								rs1=pstmt1.executeQuery();
								if(rs1.next()){
									
								}else{
								pstmt2=conAdmin.prepareStatement(AdminStatements.SAVE_GROUP_PROCESS_ASSOCIATION);
								pstmt2.setString(1,groupId);
								pstmt2.setInt(2, systemId);
								pstmt2.setInt(3, essProcessID);
								pstmt2.setInt(4, userId);
								pstmt2.executeUpdate();
								}
								pstmt1=null;
								pstmt2=null;
								rs1=null;
							}
							if(grpActivation.equals("Incomplete") || grpActivation.equals("")){
							pstmt2=conAdmin.prepareStatement(AdminStatements.UPDATE_ASSET_GROUP_STATUS);
							pstmt2.setString(1,groupId);
							pstmt2.setString(2,customerId);
							pstmt2.setInt(3, systemId);
							result=pstmt2.executeUpdate();	
							}
						}
					}
				}
				tableList.add("Update"+"##"+"ADMINISTRATOR.dbo.ASSET_GROUP");
				tableList.add("Insert"+"##"+"ADMINISTRATOR.dbo.ASSET_GROUP_PROCESS");
				}
				try {
					cf.insertDataIntoAuditLogReport(sessionId, tableList, pageName, "ADD", userId, serverName, systemId,Integer.parseInt(customerId),"Added Asset Group Mandatory Process Association");
				} catch (Exception e) {
					e.printStackTrace();
				}
				
				mesg="Saved Successfully";
			}
		} catch (Exception e) {
			System.out.println("Error in Admin Functions :-saveCustomerOrGroupMandatoryProcessAssociation method "+e.toString());
			mesg="error";
		}finally{
			DBConnection.releaseConnectionToDB(conAdmin, pstmt, rs);
			DBConnection.releaseConnectionToDB(null, pstmt1, rs1);
			DBConnection.releaseConnectionToDB(null, pstmt2, null);
			DBConnection.releaseConnectionToDB(null, pstmt3, null);
		}
	 return mesg;
 }
 /**
  * save Customer Or Group Vertical Process Association
  * @param systemId
  * @param userId
  * @param showGrp
  * @param customerId
  * @param groupId
  * @param checkedServices
  * @param uncheckedServices
  * @param ProcessTypeLabel
  * @param custActivation
  * @param grpActivation
  * @param custName
  * @param categoryType
  * @param category
  * @param userName
  * @return
  */
public String saveCustomerOrGroupVerticalizedProcessAssociation(int systemId,int userId,String showGrp,String customerId,String groupId,
		String checkedServices,String uncheckedServices, String ProcessTypeLabel,String custActivation,String grpActivation,String custName,
		String categoryType,String category,String userName,String systemName,String pageName,String sessionId,String serverName){

	 String mesg="";
		Connection conAdmin=null;
		PreparedStatement pstmt=null;
		PreparedStatement pstmt1=null;
		PreparedStatement pstmt2=null;
		PreparedStatement pstmt3=null;
		ResultSet rs=null;
		ResultSet rs1=null;
		ArrayList<String> tableList=new ArrayList<String>();
		try {
			conAdmin=DBConnection.getConnectionToDB("ADMINISTRATOR");
			
				pstmt=conAdmin.prepareStatement(AdminStatements.GET_ESS_ADV_PROCESS_ID);
				rs=pstmt.executeQuery();
				int essProcessID=0;
				int advProcessId=0;
				int count=0;
				while(rs.next()){
					if(count==0){
						essProcessID=rs.getInt("PROCESS_ID");
					}else{
						advProcessId=rs.getInt("PROCESS_ID");
					}
					count=count+1;
				}
				pstmt=null;
				rs=null;
			if(showGrp.equals("false")){
				if(!uncheckedServices.equals("")){
					String[] str=uncheckedServices.split(",");
					
					for(int i=0;i<str.length;i++){
						if(essProcessID!=Integer.parseInt(str[i].trim())){
							pstmt=conAdmin.prepareStatement(AdminStatements.DELETE_UNCHECKED_PROCESS_FOR_GROUP);
							pstmt.setString(1, str[i]);
							pstmt.setString(2, customerId);
							pstmt.setInt(3, systemId);
							pstmt.setInt(4, systemId);
							pstmt.executeUpdate();
							pstmt=null;
							pstmt=conAdmin.prepareStatement(AdminStatements.DELETE_UNCHECKED_PROCESS_FOR_CUSTOMER);
							pstmt.setString(1, str[i]);
							pstmt.setString(2, customerId);
							pstmt.setInt(3, systemId);
							pstmt.executeUpdate();
							pstmt=null;					
						}
						if(Integer.parseInt(str[i].trim())==30){
						pstmt=conAdmin.prepareStatement(AdminStatements.UPDATE_UNCHECKED_PROCESS_DATA_FOR_CLIENT_MILK_DIS);
						pstmt.setInt(1, Integer.parseInt(customerId));
						pstmt.setInt(2, systemId);
						pstmt.executeUpdate();
						
						pstmt=conAdmin.prepareStatement(AdminStatements.UPDATE_UNCHECKED_PROCESS_DATA_FOR_AMS_CLIENT_MILK);
						pstmt.setInt(1, Integer.parseInt(customerId));
						pstmt.setInt(2, systemId);
						pstmt.executeUpdate();
						}						
					}
				}
				tableList.add("Delete"+"##"+"ADMINISTRATOR.dbo.CUSTOMER_PROCESS_ASSOC");
				tableList.add("Delete"+"##"+"ADMINISTRATOR.dbo.ASSET_GROUP_PROCESS");
				tableList.add("Update"+"##"+"ADMINISTRATOR.dbo.CUSTOMER_MASTER");
				tableList.add("Update"+"##"+"AMS.dbo.tblCustomerMaster");
				int groupID=0;
				pstmt=conAdmin.prepareStatement(AdminStatements.GET_DEFAULT_GROUP);
				pstmt.setString(1,customerId);
				pstmt.setInt(2,systemId);
				rs=pstmt.executeQuery();
				if(rs.next()){
					groupID=rs.getInt("GROUP_ID");
				}
				pstmt=null;
				rs=null;
				if(!checkedServices.equals("")){
				String[] str=checkedServices.split(",");
				for(int i=0;i<str.length;i++){
					pstmt=conAdmin.prepareStatement(AdminStatements.CHECK_CUST_PROCESS_ASS_EXIST);
					pstmt.setString(1,str[i]);
					pstmt.setString(2, customerId);
					pstmt.setInt(3, systemId);
					rs=pstmt.executeQuery();
					if(rs.next()){
						
					}else{
						pstmt1=conAdmin.prepareStatement(AdminStatements.SAVE_CUSTOMER_PROCESS_ASSOCIATION);
						pstmt1.setString(1,customerId);
						pstmt1.setString(2, str[i]);
						pstmt1.setInt(3, systemId);
						pstmt1.setInt(4, userId);
						int result=pstmt1.executeUpdate();
						if(result>0)
						{										
							/***
							 * If vertical solution is selected then essential and advance will also be given
							 */
							if(i==0){
								pstmt2=conAdmin.prepareStatement(AdminStatements.CHECK_CUST_PROCESS_ASS_EXIST);
								pstmt2.setInt(1,essProcessID);
								pstmt2.setString(2, customerId);
								pstmt2.setInt(3, systemId);
								rs1=pstmt2.executeQuery();
								if(rs1.next()){
									
								}else{
									pstmt3=conAdmin.prepareStatement(AdminStatements.SAVE_CUSTOMER_PROCESS_ASSOCIATION);
									pstmt3.setString(1,customerId);
									pstmt3.setInt(2, essProcessID);
									pstmt3.setInt(3, systemId);
									pstmt3.setInt(4, userId);
									pstmt3.executeUpdate();
								}
								pstmt3=null;
								pstmt2=null;
								rs1=null;
								pstmt2=conAdmin.prepareStatement(AdminStatements.CHECK_CUST_PROCESS_ASS_EXIST);
								pstmt2.setInt(1,advProcessId);
								pstmt2.setString(2, customerId);
								pstmt2.setInt(3, systemId);
								rs1=pstmt2.executeQuery();
								if(rs1.next()){
									
								}else{
									pstmt3=conAdmin.prepareStatement(AdminStatements.SAVE_CUSTOMER_PROCESS_ASSOCIATION);
									pstmt3.setString(1,customerId);
									pstmt3.setInt(2, advProcessId);
									pstmt3.setInt(3, systemId);
									pstmt3.setInt(4, userId);
									pstmt3.executeUpdate();
								}
								pstmt3=null;
								pstmt2=null;
								rs1=null;
							}
							if(groupID>0){
								pstmt3=conAdmin.prepareStatement(AdminStatements.CHECK_GROUP_PROCESS_ASS_EXIST);
								pstmt3.setString(1,str[i]);
								pstmt3.setInt(2, groupID);
								pstmt3.setInt(3, systemId);
								rs1=pstmt3.executeQuery();
								if(rs1.next()){
									
								}else{
								pstmt2=conAdmin.prepareStatement(AdminStatements.INSERT_DEFAULT_ASSET_PROCESS);
								pstmt2.setInt(1,groupID);
								pstmt2.setInt(2, systemId);
								pstmt2.setString(3, str[i]);
								pstmt2.setInt(4, userId);
								pstmt2.executeUpdate();
								pstmt2=null;
								pstmt2=conAdmin.prepareStatement(AdminStatements.UPDATE_ASSET_GROUP_STATUS);
								pstmt2.setInt(1,groupID);
								pstmt2.setString(2,customerId);
								pstmt2.setInt(3, systemId);
								pstmt2.executeUpdate();
								}
								pstmt3=null;
								pstmt2=null;
								rs1=null;
								if(i==0){
									pstmt3=conAdmin.prepareStatement(AdminStatements.CHECK_GROUP_PROCESS_ASS_EXIST);
									pstmt3.setInt(1,essProcessID);
									pstmt3.setInt(2, groupID);
									pstmt3.setInt(3, systemId);
									rs1=pstmt3.executeQuery();
									if(rs1.next()){
										
									}else{
									pstmt2=conAdmin.prepareStatement(AdminStatements.INSERT_DEFAULT_ASSET_PROCESS);
									pstmt2.setInt(1,groupID);
									pstmt2.setInt(2, systemId);
									pstmt2.setInt(3, essProcessID);
									pstmt2.setInt(4, userId);
									pstmt2.executeUpdate();
									}
									pstmt3=null;
									pstmt2=null;
									rs1=null;
									pstmt3=conAdmin.prepareStatement(AdminStatements.CHECK_GROUP_PROCESS_ASS_EXIST);
									pstmt3.setInt(1,advProcessId);
									pstmt3.setInt(2, groupID);
									pstmt3.setInt(3, systemId);
									rs1=pstmt3.executeQuery();
									if(rs1.next()){
										
									}else{
									pstmt2=conAdmin.prepareStatement(AdminStatements.INSERT_DEFAULT_ASSET_PROCESS);
									pstmt2.setInt(1,groupID);
									pstmt2.setInt(2, systemId);
									pstmt2.setInt(3, advProcessId);
									pstmt2.setInt(4, userId);
									pstmt2.executeUpdate();
									}
									pstmt3=null;
									pstmt2=null;
									rs1=null;
								}
							}
							if(custActivation.equals("Incomplete")){
							pstmt3=conAdmin.prepareStatement(AdminStatements.UPDATE_CUSTOMER_ACTIVATION_STATUS);
							pstmt3.setString(1,customerId);
							pstmt3.setInt(2, systemId);
							pstmt3.executeUpdate();		
							}
						}
					}
				}
				tableList.add("Insert"+"##"+"ADMINISTRATOR.dbo.CUSTOMER_PROCESS_ASSOC");
				tableList.add("Update"+"##"+"ADMINISTRATOR.dbo.CUSTOMER_MASTER");
				tableList.add("Insert"+"##"+"ADMINISTRATOR.dbo.ASSET_GROUP_PROCESS");
				tableList.add("Update"+"##"+"ADMINISTRATOR.dbo.ASSET_GROUP");
				}
				try {
					cf.insertDataIntoAuditLogReport(sessionId, tableList, pageName, "ADD", userId, serverName, systemId, Integer.parseInt(customerId),"Added Customer Verticalized Process Association");
				} catch (Exception e) {
					e.printStackTrace();
				}
				
				mesg="Saved Successfully";
			}else{
				pstmt=conAdmin.prepareStatement(AdminStatements.DELETE_GROUP_PROCESS_ASS_EXIST);
				pstmt.setString(1, groupId);
				pstmt.setInt(2, systemId);
				pstmt.setString(3, ProcessTypeLabel.trim());
				pstmt.executeUpdate();				
				pstmt=null;
				if(!checkedServices.equals("")){
				String[] str=checkedServices.split(",");
				for(int i=0;i<str.length;i++){
					pstmt=conAdmin.prepareStatement(AdminStatements.CHECK_GROUP_PROCESS_ASS_EXIST);
					pstmt.setString(1,str[i]);
					pstmt.setString(2, groupId);
					pstmt.setInt(3, systemId);
					rs=pstmt.executeQuery();
					if(rs.next()){
						
					}else{
						pstmt1=conAdmin.prepareStatement(AdminStatements.SAVE_GROUP_PROCESS_ASSOCIATION);
						pstmt1.setString(1,groupId);
						pstmt1.setInt(2, systemId);
						pstmt1.setString(3, str[i]);						
						pstmt1.setInt(4, userId);
						int result=pstmt1.executeUpdate();
						if(result>0)
						{
							if(grpActivation.equals("Incomplete") || grpActivation.equals("")){
							pstmt2=conAdmin.prepareStatement(AdminStatements.UPDATE_ASSET_GROUP_STATUS);
							pstmt2.setString(1,groupId);
							pstmt2.setString(2,customerId);
							pstmt2.setInt(3, systemId);
							result=pstmt2.executeUpdate();	
							pstmt2=null;
							}
							if(i==0){
								pstmt3=conAdmin.prepareStatement(AdminStatements.CHECK_GROUP_PROCESS_ASS_EXIST);
								pstmt3.setInt(1,essProcessID);
								pstmt3.setString(2, groupId);
								pstmt3.setInt(3, systemId);
								rs1=pstmt3.executeQuery();
								if(rs1.next()){
									
								}else{
								pstmt2=conAdmin.prepareStatement(AdminStatements.SAVE_GROUP_PROCESS_ASSOCIATION);
								pstmt2.setString(1,groupId);
								pstmt2.setInt(2, systemId);
								pstmt2.setInt(3, essProcessID);
								pstmt2.setInt(4, userId);
								pstmt2.executeUpdate();
								}
								pstmt3=null;
								pstmt2=null;
								rs1=null;
								pstmt3=conAdmin.prepareStatement(AdminStatements.CHECK_GROUP_PROCESS_ASS_EXIST);
								pstmt3.setInt(1,advProcessId);
								pstmt3.setString(2, groupId);
								pstmt3.setInt(3, systemId);
								rs1=pstmt3.executeQuery();
								if(rs1.next()){
									
								}else{
								pstmt2=conAdmin.prepareStatement(AdminStatements.SAVE_GROUP_PROCESS_ASSOCIATION);
								pstmt2.setString(1,groupId);
								pstmt2.setInt(2, systemId);
								pstmt2.setInt(3, advProcessId);
								pstmt2.setInt(4, userId);
								pstmt2.executeUpdate();
								}
								pstmt3=null;
								pstmt2=null;
								rs1=null;
							}
						}
					}
				}
				tableList.add("Update"+"##"+"ADMINISTRATOR.dbo.ASSET_GROUP");
				tableList.add("Insert"+"##"+"ADMINISTRATOR.dbo.ASSET_GROUP_PROCESS");
				}
				mesg="Saved Successfully";
				try {
					cf.insertDataIntoAuditLogReport(sessionId, tableList, pageName, "ADD", userId, serverName, systemId,Integer.parseInt(customerId),"Added Asset Group Verticalized Process Association");
				} catch (Exception e) {
					e.printStackTrace();
				}
				
			}
		} catch (Exception e) {
			mesg="error";
			System.out.println("Error in Admin Functions:-saveCustomerOrGroupVerticalizedProcessAssociation method "+e.toString());
		}finally{
			DBConnection.releaseConnectionToDB(conAdmin, pstmt, rs);
			DBConnection.releaseConnectionToDB(null, pstmt1, rs1);
			DBConnection.releaseConnectionToDB(null, pstmt2, null);
			DBConnection.releaseConnectionToDB(null, pstmt3, null);
		}
	 return mesg;

 }
/**
 * save Customer Or Group add-on Process Association
 * @param systemId
 * @param userId
 * @param showGrp
 * @param customerId
 * @param groupId
 * @param checkedServices
 * @param uncheckedServices
 * @param ProcessTypeLabel
 * @param custActivation
 * @param grpActivation
 * @param custName
 * @param categoryType
 * @param category
 * @return
 */
public String saveCustomerOrGroupaddonProcessAssociation(int systemId,int userId,String showGrp,String customerId,String groupId,String checkedServices,
		String uncheckedServices, String ProcessTypeLabel,String custActivation,String grpActivation,String custName,String categoryType,
		String category,String userName,String systemName,String pageName,String sessionId,String serverName){

	 String mesg="";
		Connection conAdmin=null;
		PreparedStatement pstmt=null;
		PreparedStatement pstmt1=null;
		PreparedStatement pstmt2=null;
		PreparedStatement pstmt3=null;
		ResultSet rs=null;
		ResultSet rs1=null;
		ArrayList<String> tableList=new ArrayList<String>();
		try {
			conAdmin=DBConnection.getConnectionToDB("ADMINISTRATOR");
			if(showGrp.equals("false")){
				pstmt=conAdmin.prepareStatement(AdminStatements.GET_ESS_PROCESS_ID);
				rs=pstmt.executeQuery();
				int essProcessID=0;
				if(rs.next()){
					essProcessID=rs.getInt("PROCESS_ID");					
				}
				pstmt=null;
				rs=null;
				if(!uncheckedServices.equals("")){
					String[] str=uncheckedServices.split(",");
					for(int i=0;i<str.length;i++){
						if(essProcessID!=Integer.parseInt(str[i].trim())){
							pstmt=conAdmin.prepareStatement(AdminStatements.DELETE_UNCHECKED_PROCESS_FOR_GROUP);
							pstmt.setString(1, str[i]);
							pstmt.setString(2, customerId);
							pstmt.setInt(3, systemId);
							pstmt.setInt(4, systemId);
							pstmt.executeUpdate();
							pstmt=null;
							pstmt=conAdmin.prepareStatement(AdminStatements.DELETE_UNCHECKED_PROCESS_FOR_CUSTOMER);
							pstmt.setString(1, str[i]);
							pstmt.setString(2, customerId);
							pstmt.setInt(3, systemId);
							pstmt.executeUpdate();
							pstmt=null;
						}
						if(Integer.parseInt(str[i].trim())==38){
						pstmt=conAdmin.prepareStatement(AdminStatements.UPDATE_UNCHECKED_PROCESS_DATA_FOR_CLIENT_HEALTH_SAFETY);
						pstmt.setInt(1, Integer.parseInt(customerId));
						pstmt.setInt(2, systemId);
						pstmt.executeUpdate();
						
						pstmt=conAdmin.prepareStatement(AdminStatements.UPDATE_UNCHECKED_PROCESS_DATA_FOR_AMS_CLIENT_HEALTH_SAFETY);
						pstmt.setInt(1, Integer.parseInt(customerId));
						pstmt.setInt(2, systemId);
						pstmt.executeUpdate();
						}
					}
				}
				tableList.add("Delete"+"##"+"ADMINISTRATOR.dbo.CUSTOMER_PROCESS_ASSOC");
				tableList.add("Delete"+"##"+"ADMINISTRATOR.dbo.ASSET_GROUP_PROCESS");
				tableList.add("Update"+"##"+"ADMINISTRATOR.dbo.CUSTOMER_MASTER");
				tableList.add("Update"+"##"+"AMS.dbo.tblCustomerMaster");
				int groupID=0;
				pstmt=conAdmin.prepareStatement(AdminStatements.GET_DEFAULT_GROUP);
				pstmt.setString(1,customerId);
				pstmt.setInt(2,systemId);
				rs=pstmt.executeQuery();
				if(rs.next()){
					groupID=rs.getInt("GROUP_ID");
				}
				pstmt=null;
				rs=null;
				if(!checkedServices.equals("")){
				String[] str=checkedServices.split(",");
				for(int i=0;i<str.length;i++){
					pstmt=conAdmin.prepareStatement(AdminStatements.CHECK_CUST_PROCESS_ASS_EXIST);
					pstmt.setString(1,str[i]);
					pstmt.setString(2, customerId);
					pstmt.setInt(3, systemId);
					rs=pstmt.executeQuery();
					if(rs.next()){
						
					}else{
						pstmt1=conAdmin.prepareStatement(AdminStatements.SAVE_CUSTOMER_PROCESS_ASSOCIATION);
						pstmt1.setString(1,customerId);
						pstmt1.setString(2, str[i]);
						pstmt1.setInt(3, systemId);
						pstmt1.setInt(4, userId);
						int result=pstmt1.executeUpdate();
						if(result>0)
						{
							if(groupID>0){
								pstmt3=conAdmin.prepareStatement(AdminStatements.CHECK_GROUP_PROCESS_ASS_EXIST);
								pstmt3.setString(1,str[i]);
								pstmt3.setInt(2, groupID);
								pstmt3.setInt(3, systemId);
								rs1=pstmt3.executeQuery();
								if(rs1.next()){
									
								}else{
								pstmt2=conAdmin.prepareStatement(AdminStatements.INSERT_DEFAULT_ASSET_PROCESS);
								pstmt2.setInt(1,groupID);
								pstmt2.setInt(2, systemId);
								pstmt2.setString(3, str[i]);
								pstmt2.setInt(4, userId);
								pstmt2.executeUpdate();
								pstmt2=null;
								pstmt2=conAdmin.prepareStatement(AdminStatements.UPDATE_ASSET_GROUP_STATUS);
								pstmt2.setInt(1,groupID);
								pstmt2.setString(2,customerId);
								pstmt2.setInt(3, systemId);
								pstmt2.executeUpdate();
								}
								pstmt3=null;
								pstmt2=null;
								rs1=null;
							}
							if(custActivation.equals("Incomplete")){
							pstmt3=conAdmin.prepareStatement(AdminStatements.UPDATE_CUSTOMER_ACTIVATION_STATUS);
							pstmt3.setString(1,customerId);
							pstmt3.setInt(2, systemId);
							pstmt3.executeUpdate();
							}
						}
					}
				}
				tableList.add("Insert"+"##"+"ADMINISTRATOR.dbo.CUSTOMER_PROCESS_ASSOC");
				tableList.add("Update"+"##"+"ADMINISTRATOR.dbo.CUSTOMER_MASTER");
				tableList.add("Insert"+"##"+"ADMINISTRATOR.dbo.ASSET_GROUP_PROCESS");
				tableList.add("Update"+"##"+"ADMINISTRATOR.dbo.ASSET_GROUP");
				}
				try {
					cf.insertDataIntoAuditLogReport(sessionId, tableList, pageName, "ADD", userId, serverName, systemId, Integer.parseInt(customerId),"Added Customer Addon Process Association");
				} catch (Exception e) {
					e.printStackTrace();
				}
				
				mesg="Saved Successfully";
			}else{				
				pstmt=conAdmin.prepareStatement(AdminStatements.DELETE_GROUP_PROCESS_ASS_EXIST);
				pstmt.setString(1, groupId);
				pstmt.setInt(2, systemId);
				pstmt.setString(3, ProcessTypeLabel.trim());
				pstmt.executeUpdate();
				pstmt=null;
				if(!checkedServices.equals("")){
				String[] str=checkedServices.split(",");
				for(int i=0;i<str.length;i++){
					pstmt=conAdmin.prepareStatement(AdminStatements.CHECK_GROUP_PROCESS_ASS_EXIST);
					pstmt.setString(1,str[i]);
					pstmt.setString(2, groupId);
					pstmt.setInt(3, systemId);
					rs=pstmt.executeQuery();
					if(rs.next()){
						
					}else{
						pstmt1=conAdmin.prepareStatement(AdminStatements.SAVE_GROUP_PROCESS_ASSOCIATION);
						pstmt1.setString(1,groupId);
						pstmt1.setInt(2, systemId);
						pstmt1.setString(3, str[i]);						
						pstmt1.setInt(4, userId);
						int result=pstmt1.executeUpdate();
						if(result>0)
						{
							if(grpActivation.equals("Incomplete") || grpActivation.equals("")){
							pstmt2=conAdmin.prepareStatement(AdminStatements.UPDATE_ASSET_GROUP_STATUS);
							pstmt2.setString(1,groupId);
							pstmt2.setString(2,customerId);
							pstmt2.setInt(3, systemId);
							result=pstmt2.executeUpdate();
							}
						}
					}
				}
				tableList.add("Update"+"##"+"ADMINISTRATOR.dbo.ASSET_GROUP");
				tableList.add("Insert"+"##"+"ADMINISTRATOR.dbo.ASSET_GROUP_PROCESS");
				}
				mesg="Saved Successfully";
				try {
					cf.insertDataIntoAuditLogReport(sessionId, tableList, pageName, "ADD", userId, serverName, systemId,Integer.parseInt(customerId),"Added Asset Group Addon Process Association");
				} catch (Exception e) {
					e.printStackTrace();
				}
				
			}
		} catch (Exception e) {
			mesg="error";
			System.out.println("Error in Admin Function:-saveCustomerOrGroupaddonProcessAssociation method "+e.toString());
		}finally{
			DBConnection.releaseConnectionToDB(conAdmin, pstmt, rs);
			DBConnection.releaseConnectionToDB(null, pstmt1, rs1);
			DBConnection.releaseConnectionToDB(null, pstmt2, null);
			DBConnection.releaseConnectionToDB(null, pstmt3, null);
		}
	 return mesg;

 };
 /**
  * save Essential Monitoring Setting Details
  * @param custId
  * @param stoptime
  * @param idletime
  * @param noncommtime
  * @param liveposititime
  * @param subsequentRemainder
  * @param subsequentNotification
  * @param systemid
  * @return
  */
	public String saveEssentialMonitoringDetails(String custId, int stoptime,
			int idletime, int noncommtime, int liveposititime, int subsequentRemainder,int subsequentNotification ,int systemid,String stoppageAlertInsideHub
			,String pageName,String sessionId,String serverName,int userId) {
		Connection conAdmin=null;
		PreparedStatement pstmt=null;
		PreparedStatement pstmt1=null;
		String message="";
		ArrayList<String> tableList=new ArrayList<String>();
		try {
			conAdmin=DBConnection.getConnectionToDB("ADMINISTRATOR");
			pstmt=conAdmin.prepareStatement(AdminStatements.SAVE_ESSENTIAL_MONITORING_DETAILS);
			pstmt.setInt(1, stoptime);
			pstmt.setInt(2, idletime);
			pstmt.setInt(3, noncommtime);
			pstmt.setInt(4, liveposititime);
			pstmt.setInt(5, subsequentRemainder);
			pstmt.setInt(6, subsequentNotification);
			pstmt.setString(7, stoppageAlertInsideHub);
			pstmt.setInt(8, Integer.parseInt(custId));
			pstmt.setInt(9, systemid);
	
			int i=pstmt.executeUpdate();
			if(i>0){
				tableList.add("Update"+"##"+"ADMINISTRATOR.dbo.CUSTOMER_MASTER");
			/******************************block of statement has to delete after full impl************************************************/
				pstmt1=conAdmin.prepareStatement(AdminStatements.SAVE_ESSENTIAL_tblCustomerMaster);
				pstmt1.setInt(1, stoptime);
				pstmt1.setInt(2, idletime);
				pstmt1.setInt(3, noncommtime);
				pstmt1.setInt(4, liveposititime);
				pstmt1.setInt(5, Integer.parseInt(custId));
				pstmt1.setInt(6, systemid);
				pstmt1.executeUpdate();
				pstmt1=null;
				tableList.add("Update"+"##"+"AMS.dbo.tblCustomerMaster");
				try {
					cf.insertDataIntoAuditLogReport(sessionId, tableList, pageName, "ADD", userId, serverName, systemid,Integer.parseInt(custId),"Added Essential Monitoring Details");
				} catch (Exception e) {
					e.printStackTrace();
				}
				
				/*******************************************************************************************************************************/
				message="Saved Successfully";
			}else{
				message="error";
			}
		} catch (Exception e) {
			message="error";
			System.out.println("Error in Admin Function:-save essentialmonitoringdetails"+e);
		}finally{
			DBConnection.releaseConnectionToDB(conAdmin, pstmt, null);
			DBConnection.releaseConnectionToDB(null, pstmt1, null);
		}
		
		
		return message;
	}

	/**
	 * save Advance Monitoring Setting Details
	 * @param custId
	 * @param resmomstartime
	 * @param resmomendtime
	 * @param resnonmomstartime
	 * @param resnonmomeendtime
	 * @param acidletime
	 * @param nearborder
	 * @param seatbeltinterval
	 * @param restrictivedistance
	 * @param nonrestrictivedis
	 * @param custId2
	 * @param systemId
	 * @param seatBeltDistane
	 * @param paymentduedate
	 * @param paymentnotificationperiod
	 * @return
	 */
	public String saveAdvanceMonitoringDetails(String custId,
			float resmomstartime, float resmomendtime, int resnonmomstartime,
			int resnonmomeendtime, int acidletime, int nearborder,
			int seatbeltinterval,int doorsensorintervaltime,String doorsensoralertinsidehub,int restrictivedistance,
			int nonrestrictivedis, String custId2, int systemId,int seatBeltDistane,int userId,String pageName,String sessionId,String serverName) {
		Connection conAdmin=null;
		PreparedStatement pstmt=null;
		PreparedStatement pstmt1=null;
		PreparedStatement pstmt2=null;
		PreparedStatement pstmt3=null;
		DecimalFormat decformat = new DecimalFormat("#0.00");
		String message="";
		ResultSet rs=null;
		ResultSet rs1=null;
		int id=0;
		ArrayList<String> tableList=new ArrayList<String>();
		try {
			conAdmin=DBConnection.getConnectionToDB("ADMINISTRATOR");
			pstmt=conAdmin.prepareStatement(AdminStatements.SAVE_ADVANCE_MONITORING_DETAILS);
			pstmt.setString(1, (decformat.format(resmomstartime)));
			pstmt.setString(2, (decformat.format(resmomendtime)));
			pstmt.setInt(3, resnonmomstartime);
			pstmt.setInt(4, resnonmomeendtime);
			pstmt.setInt(5, acidletime);
			pstmt.setInt(6, nearborder);
			pstmt.setInt(7, seatbeltinterval);
			pstmt.setInt(8, restrictivedistance);
			pstmt.setInt(9, nonrestrictivedis);
			pstmt.setInt(10, seatBeltDistane);
			pstmt.setInt(11, doorsensorintervaltime);
			pstmt.setString(12, doorsensoralertinsidehub);
			pstmt.setInt(13, Integer.parseInt(custId));
			pstmt.setInt(14, systemId);
			
			int i=pstmt.executeUpdate();
			if(i>0){
				tableList.add("Update"+"##"+"ADMINISTRATOR.dbo.CUSTOMER_MASTER");
				/******************************block of statement has to delete after full impl************************************************/
				pstmt1=conAdmin.prepareStatement(AdminStatements.SAVE_ADVANCE_MONITORING_tblCustomerMaster);
				pstmt1.setInt(1, acidletime);
				pstmt1.setInt(2, nearborder);
				pstmt1.setInt(3, seatbeltinterval);
				pstmt1.setString(4, (decformat.format(resmomstartime)));
				pstmt1.setString(5, (decformat.format(resmomendtime)));
				pstmt1.setInt(6, restrictivedistance);
				pstmt1.setInt(7, Integer.parseInt(custId));
				pstmt1.setInt(8, systemId);
				pstmt1.executeUpdate();
				tableList.add("Update"+"##"+"AMS.dbo.tblCustomerMaster");
				try {
					cf.insertDataIntoAuditLogReport(sessionId, tableList, pageName, "ADD", userId, serverName, systemId,Integer.parseInt(custId),"Added Advance Monitoring Details");
				} catch (Exception e) {
					e.printStackTrace();
				}
				
				/*******************************************************************************************************************************/
				message="Saved Successfully";
			}else{
				message="error";
			}
			
		} catch (Exception e) {
			e.printStackTrace();
			message="error in saving data";
			System.out.println("Error in Admin Function:-save saveAdvanceMonitoringDetails"+e);
		}finally{
			DBConnection.releaseConnectionToDB(conAdmin, pstmt, null);
			DBConnection.releaseConnectionToDB(null, pstmt1, null);
		}
		
		return message;
	}	

	
	
	public String saveCustomerWorkDetails(String monday,String tuesday,String wednesday,String thursday,
            String friday,String saturday,String sunday,int firstday,float starttime,
            float endtime,int custId,int systemId,int userId,int type,String pageName,String sessionId,String serverName) {
	  Connection conAdmin=null;
	  PreparedStatement pstmt=null;
	  PreparedStatement pstmt1=null;
	  PreparedStatement pstmt2=null;
	  PreparedStatement pstmt3=null;
	  String message="";
	  ResultSet rs=null;
	  ResultSet rs1=null;
	  int id=0;
	  ArrayList<String> tableList=new ArrayList<String>();
	  try {
		  conAdmin=DBConnection.getConnectionToDB("ADMINISTRATOR");
		  pstmt=conAdmin.prepareStatement(AdminStatements.GET_CUSTOMER_WORK_DETAILS);
		  pstmt.setInt(1, systemId);
		  pstmt.setInt(2, custId);
		  pstmt.setInt(3, type);
		  rs=pstmt.executeQuery();
		  if(rs.next())
		  {
			  pstmt1=conAdmin.prepareStatement(AdminStatements.UPDATE_CUSTOMER_WORK_DETAILS);
			  pstmt1.setString(1, monday);
			  pstmt1.setString(2, tuesday);
			  pstmt1.setString(3, wednesday);
			  pstmt1.setString(4, thursday);
			  pstmt1.setString(5, friday);
			  pstmt1.setString(6, saturday);
			  pstmt1.setString(7, sunday);
			  pstmt1.setInt(8, firstday);
			  pstmt1.setFloat(9, starttime);
			  pstmt1.setFloat(10, endtime);
			  pstmt1.setFloat(11, userId);
			  pstmt1.setInt(12, systemId);
			  pstmt1.setInt(13, custId);
			  pstmt1.setInt(14, type);
			  pstmt1.executeUpdate();
			  id=rs.getInt("ID");
			  tableList.add("Update"+"##"+"dbo.CUSTOMER_WORK_WEEK");
		  }
		  else
		  {
			  pstmt2=conAdmin.prepareStatement(AdminStatements.INSERT_CUSTOMER_WORK_DETAILS,Statement.RETURN_GENERATED_KEYS);
			  pstmt2.setString(1, monday);
			  pstmt2.setString(2, tuesday);
			  pstmt2.setString(3, wednesday);
			  pstmt2.setString(4, thursday);
			  pstmt2.setString(5, friday);
			  pstmt2.setString(6, saturday);
			  pstmt2.setString(7, sunday);
			  pstmt2.setInt(8, firstday);
			  pstmt2.setFloat(9, starttime);
			  pstmt2.setFloat(10, endtime);
			  pstmt2.setInt(11, custId);
			  pstmt2.setInt(12, systemId);
			  pstmt2.setInt(13,userId);
			  pstmt2.setInt(14, userId);
			  pstmt2.setInt(15, type);
			  pstmt2.executeUpdate();
			  rs1=pstmt2.getGeneratedKeys();
			  tableList.add("Insert"+"##"+"dbo.CUSTOMER_WORK_WEEK");
			  if(rs1.next())
			  {
				  id=rs1.getInt(1);
			  }

		  }

		  pstmt3=conAdmin.prepareStatement(AdminStatements.INSERT_CUSTOMER_WORK_DETAILS_HISTORY);
		  pstmt3.setInt(1,id);
		  pstmt3.setString(2, monday);
		  pstmt3.setString(3, tuesday);
		  pstmt3.setString(4, wednesday);
		  pstmt3.setString(5, thursday);
		  pstmt3.setString(6, friday);
		  pstmt3.setString(7, saturday);
		  pstmt3.setString(8, sunday);
		  pstmt3.setInt(9, firstday);
		  pstmt3.setFloat(10, starttime);
		  pstmt3.setFloat(11, endtime);
		  pstmt3.setInt(12, custId);
		  pstmt3.setInt(13, systemId);
		  pstmt3.setInt(14,userId);
		  pstmt3.setInt(15, userId);
		  pstmt3.setInt(16, type);
		  int up=pstmt3.executeUpdate();
		  if(up>0){
			  tableList.add("Insert"+"##"+"dbo.CUSTOMER_WORK_WEEK_HISTORY");
		  }
		  try {
			  cf.insertDataIntoAuditLogReport(sessionId, tableList, pageName, "ADD", userId, serverName, systemId,custId,"Added Customer Work Details in Advanced Monitoring");
		  } catch (Exception e) {
			  e.printStackTrace();
		  }
		  

	  }
	  catch (Exception e) {
		  message="error in saving data";
		  e.printStackTrace();
		  System.out.println("Error in Admin Function:-save saveAdvanceMonitoringDetails"+e);
	  }finally{
		  DBConnection.releaseConnectionToDB(conAdmin, pstmt, null);
		  DBConnection.releaseConnectionToDB(null, pstmt1, null);
		  DBConnection.releaseConnectionToDB(null, pstmt2, rs1);
		  DBConnection.releaseConnectionToDB(null, pstmt3, null);
	  }

	  return message;
  }

	
	/**
	 * save Milk Distribution Logistics Details
	 * @param mintemp
	 * @param maxtemp
	 * @param custId
	 * @param systemId
	 * @return
	 */
	public String saveMilkDistributionLogisticsDetails(double mintemp,
			double maxtemp, String custId, int systemId,String pageName,String sessionId,String serverName,int userId) {
		Connection conAdmin=null;
		PreparedStatement pstmt=null;
		PreparedStatement pstmt1=null;
		String message="";
		ArrayList<String> tableList=new ArrayList<String>();
		try {
			conAdmin=DBConnection.getConnectionToDB("ADMINISTRATOR");
			pstmt=conAdmin.prepareStatement(AdminStatements.SAVE_MILKDISTRIBUTION_LOGISTICS_DETAILS);
			pstmt.setDouble(1, maxtemp);
			pstmt.setDouble(2, mintemp);
			pstmt.setInt(3, Integer.parseInt(custId));
			pstmt.setInt(4, systemId);
			int i=pstmt.executeUpdate();
			if(i>0){
				tableList.add("Update"+"##"+"ADMINISTRATOR.dbo.CUSTOMER_MASTER");
				/******************************block of statement has to delete after full impl************************************************/
				pstmt1=conAdmin.prepareStatement(AdminStatements.SAVE_MILKDISTRIBUTION_tblCustomerMaster);
				pstmt1.setDouble(1, maxtemp);
				pstmt1.setDouble(2, mintemp);
				pstmt1.setInt(3, Integer.parseInt(custId));
				pstmt1.setInt(4, systemId);
				pstmt1.executeUpdate();
				tableList.add("Update"+"##"+"AMS.dbo.tblCustomerMaster");
				try {
					cf.insertDataIntoAuditLogReport(sessionId, tableList, pageName, "ADD", userId, serverName, systemId,Integer.parseInt(custId),"Added Milk Distribution Logistics Details for Customization");
				} catch (Exception e) {
					e.printStackTrace();
				}
				
				/*******************************************************************************************************************************/
				message="Saved Successfully";
			}else{
				message="error";
			}
		} catch (Exception e) {
			System.out.println("Error in Admin Function:-save milkdistributionlogistics"+e);
		}finally{
			DBConnection.releaseConnectionToDB(conAdmin, pstmt, null);
			DBConnection.releaseConnectionToDB(null, pstmt1, null);
		}
	
		return message;
		
	}

	/**
	 * save Health Safety Assurance Details
	 * @param overspeedlimit
	 * @param overspeedgraded
	 * @param custId
	 * @param systemId
	 * @return
	 */
	public String saveHealthSafetyAssuranceDetails(int overspeedlimit,
			int overspeedgraded, String custId, int systemId,String pageName,String sessionId,String serverName,int userId) {
		Connection conAdmin=null;
		PreparedStatement pstmt=null;
		PreparedStatement pstmt1=null;
		String message="";
		ArrayList<String> tableList=new ArrayList<String>();
		try {
			conAdmin=DBConnection.getConnectionToDB("ADMINISTRATOR");
			pstmt=conAdmin.prepareStatement(AdminStatements.SAVE_HEALTHSAFETY_ASSURANCE_DETAILS);
			pstmt.setDouble(1, overspeedlimit);
			pstmt.setDouble(2, overspeedgraded);
			pstmt.setInt(3, Integer.parseInt(custId));
			pstmt.setInt(4, systemId);
			int i=pstmt.executeUpdate();
			if(i>0){
				tableList.add("Update"+"##"+"ADMINISTRATOR.dbo.CUSTOMER_MASTER");
				/******************************block of statement has to delete after full impl************************************************/
				pstmt1=conAdmin.prepareStatement(AdminStatements.SAVE_HEALTHSAFETY_ASSURANCE_tblCustomerMaster);
				pstmt1.setDouble(1, overspeedlimit);
				pstmt1.setDouble(2, overspeedgraded);
				pstmt1.setInt(3, Integer.parseInt(custId));
				pstmt1.setInt(4, systemId);
				pstmt1.executeUpdate();
				/*********************************************************************************************************************************/
				tableList.add("Update"+"##"+"AMS.dbo.tblCustomerMaster");
				try {
					cf.insertDataIntoAuditLogReport(sessionId, tableList, pageName, "ADD", userId, serverName, systemId,Integer.parseInt(custId),"Added Health and Safety Details for Customization");
				} catch (Exception e) {
					e.printStackTrace();
				}
				
				message="Saved Successfully";
			}else{
				message="error";
			}
			
		} catch (Exception e) {
			e.printStackTrace();
			System.out.println("Error in Admin Function:-save healthsafetyassurance"+e);
		}finally{
			DBConnection.releaseConnectionToDB(conAdmin, pstmt, null);
			DBConnection.releaseConnectionToDB(null, pstmt1, null);
		}
	
		return message;
	}
	
	/**
	 * formating minutes into DD:HH:MM(day:hour:min)
	 * @param minutesdata
	 * @return
	 */
	public String getTimeFormat(int minutesdata) {
		String timeFormat = "";

		int day = (minutesdata / (24 * 60));
		int hours = ((minutesdata - (day * 24 * 60)) / 60);
		int min = (minutesdata - (day * 24 * 60) - (hours * 60));

		String days = String.valueOf(day);
		String hr = String.valueOf(hours);
		String minut = String.valueOf(min);
		if (days.length() < 2) {
			days = "0" + days;
		} 
		if (minut.length() < 2) {
			minut = "0" + minut;
		} 
		if (hr.length() < 2) {
			hr = "0" + hr;
		}
		timeFormat = days + ":" + hr + ":" + minut;
		return timeFormat;
	}
	
	/**
	 * Getting Customer Setting Details
	 * @param custId
	 * @param systemId
	 * @return
	 */
	public JSONArray CustomerSettingDetails(String custId, int systemId) {
		Connection conAdmin = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		JSONObject jsonObject = new JSONObject();
		JSONArray jsonArray = new JSONArray();
		DecimalFormat df = new DecimalFormat("##.##");
		double convertionFactor=getUnitOfMeasureConvertionsfactor(systemId);
		try {
			conAdmin = DBConnection.getConnectionToDB("ADMINISTRATOR");
			pstmt = conAdmin
					.prepareStatement(AdminStatements.CUSTOMER_SETTING_DETAILS);
			pstmt.setInt(1, Integer.parseInt(custId));
			pstmt.setInt(2, systemId);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				String vehicleImage = rs.getString("VEHICLE_IMAGE");
				int stoppTime = rs.getInt("STOPPAGE_TIME_ALERT");
				String stoppageTime = String.valueOf(stoppTime);
				int idleTi = rs.getInt("IDLETIME_ALERT");
				String idleTime = String.valueOf(idleTi);
				int nonCommTi = rs.getInt("NON_COMMUNICATING_ALERT");
				String nonCommTime = String.valueOf(nonCommTi);
				int livePosition = rs.getInt("LIVE_POSITION_ALERT");
                String stoppageAlertIH=rs.getString("STOPPAGE_INSIDE_HUB");
				//int resMomStart = rs.getInt("RESTRICTIVE_MOMENT_START");
                
				double resMomStart1 = rs.getFloat("RESTRICTIVE_MOMENT_START");
				resMomStart1=Double.parseDouble(df.format(resMomStart1));
				String resMomStart=Double.toString(resMomStart1).replace('.', ':');
				if (resMomStart.substring(0, resMomStart.indexOf(":")).length()<2) {
					resMomStart="0"+resMomStart;
				}
				if (resMomStart.substring(resMomStart.indexOf(":")+1).length()<2) {
					resMomStart=resMomStart+"0";
				}
				

				int resNonMomStart = 0;//rs.getInt("RESTRICTIVE_NON_MOMENT_START");
				
				//int resMomEnd = rs.getInt("RESTRICTIVE_MOMENT_END");
				double resMomEnd1 =  rs.getFloat("RESTRICTIVE_MOMENT_END");
				resMomEnd1=Double.parseDouble(df.format(resMomEnd1));
				String resMomEnd=Double.toString(resMomEnd1).replace('.', ':');
				if (resMomEnd.substring(0, resMomEnd.indexOf(":")).length()<2) {
					resMomEnd="0"+resMomEnd;
				}
				if (resMomEnd.substring(resMomEnd.indexOf(":")+1).length()<2) {
					resMomEnd=resMomEnd+"0";
				}

				int resNonMomEnd = 0;//rs.getInt("RESTRICTIVE_NON_MOMENT_END");

				int acidleTimes = rs.getInt("AC_IDLE_TIME_ALERT");
				String acidleTime =String.valueOf(acidleTimes);

				int nearBorderDis = rs.getInt("NEARTO_BOARDER_DISTANCE");
				 
				nearBorderDis = (int) Math.floor(convertionFactor* nearBorderDis);
				
				int seatBeltInterval = rs.getInt("SEAT_BELT_INTERVAL");
				
				int resMomDis = rs.getInt("RESTRICTIVE_MOMENT_DISTANCE");
				
				resMomDis = (int)Math.floor(resMomDis * convertionFactor);
				
				int resNonMomDis =0;// rs.getInt("RESTRICTIVE_NON_MOMENT_DISTANCE");
				double minTemp = rs.getInt("MIN_TEMPERATURE");
				double maxTemp = rs.getInt("MAX_TEMPERATURE");
				int osLimitBlackTop = rs.getInt("OS_LIMIT_BLACKTOP");
				int osLimitGraded = rs.getInt("OS_LIMIT_GRADED");
				 String seatBeltDis="";
				 if(rs.getString("SEAT_BELT_DISTANCE")!=null){
					 seatBeltDis=rs.getString("SEAT_BELT_DISTANCE");
				 }
				 int seatBeltDistance = (int)Math.floor(Float.parseFloat(seatBeltDis)*convertionFactor);
				 
				 int subsequentRemainder = rs.getInt("IDLE_SUBSEQUENT_REMAINDER");
				 String idleSubsequentRemainder = String.valueOf(subsequentRemainder);
				 int subsequentNotification = rs.getInt("IDLE_SUBSEQUENT_NOTIFICATION");
				 String monday=rs.getString("MONDAY");
				 String tuesday=rs.getString("TUESDAY");
				 String wednesday=rs.getString("WEDNESDAY");
				 String thursday=rs.getString("THURSDAY");
				 String friday=rs.getString("FRIDAY");
				 String saturday=rs.getString("SATURDAY");
				 String sunday=rs.getString("SUNDAY");
				 int firstday=rs.getInt("START_DAY_OF_WEEK");
				 String stime=df.format(rs.getFloat("START_TIME"));
				 String etime=df.format(rs.getFloat("END_TIME"));
				 
				 String monday1=rs.getString("MONDAY1");
				 String tuesday1=rs.getString("TUESDAY1");
				 String wednesday1=rs.getString("WEDNESDAY1");
				 String thursday1=rs.getString("THURSDAY1");
				 String friday1=rs.getString("FRIDAY1");
				 String saturday1=rs.getString("SATURDAY1");
				 String sunday1=rs.getString("SUNDAY1");
				 int dooralertinterval=rs.getInt("DOOR_ALERT_INTERVAL");
				 String dooralertintervalhub=rs.getString("DOOR_ALERT_INSIDE_HUB");

				jsonObject.put("CustomerId", custId);
				jsonObject.put("Image", vehicleImage);
				jsonObject.put("StoppageTime", stoppageTime);
				jsonObject.put("IdleTime", idleTime);
				jsonObject.put("NonCommTime", nonCommTime);
				jsonObject.put("LivePositionTime", livePosition);
				jsonObject.put("RestMomStartTime", resMomStart);
				jsonObject.put("ResNonMomStartTime", resNonMomStart);
				jsonObject.put("ResMomEndTime", resMomEnd);
				jsonObject.put("ResNonMomEndTime", resNonMomEnd);
				jsonObject.put("ACIdleTime", acidleTime);
				jsonObject.put("NearBoarder", nearBorderDis);
				jsonObject.put("SeatBeltInt", seatBeltInterval);
				jsonObject.put("ResDistance", resMomDis);
				jsonObject.put("NonResDis", resNonMomDis);
				jsonObject.put("MinTemp", minTemp);
				jsonObject.put("MaxTemp", maxTemp);
				jsonObject.put("OverSpeedBlackTop", osLimitBlackTop);
				jsonObject.put("OverSpeedGraded", osLimitGraded);
				jsonObject.put("SeatBeltDistance", seatBeltDistance);
				jsonObject.put("OverSpeedGraded", osLimitGraded);
				jsonObject.put("SeatBeltDistance", seatBeltDistance);
				jsonObject.put("SubRemainder", idleSubsequentRemainder);
				jsonObject.put("SubNotification", subsequentNotification);
				jsonObject.put("Monday", monday);
				jsonObject.put("Tuesday", tuesday);
				jsonObject.put("Wednesday", wednesday);
				jsonObject.put("Thursday", thursday);
				jsonObject.put("Friday", friday);
				jsonObject.put("Saturday", saturday);
				jsonObject.put("Sunday", sunday);
				jsonObject.put("FirstDayWeek", firstday);
				jsonObject.put("STime", stime);
				jsonObject.put("ETime", etime);
				jsonObject.put("SAlertInsideHub", stoppageAlertIH);
				
				jsonObject.put("Monday1", monday1);
				jsonObject.put("Tuesday1", tuesday1);
				jsonObject.put("Wednesday1", wednesday1);
				jsonObject.put("Thursday1", thursday1);
				jsonObject.put("Friday1", friday1);
				jsonObject.put("Saturday1", saturday1);
				jsonObject.put("Sunday1", sunday1);
				jsonObject.put("DoorSensorInt", dooralertinterval);
				jsonObject.put("Doorsensoralertinsidehub", dooralertintervalhub);
				
				jsonArray.put(jsonObject);

			}

		} catch (Exception e) {
			System.out.println("Error in Admin Function:--getCustomerSettingDetails "+ e);
		}finally{
			DBConnection.releaseConnectionToDB(conAdmin, pstmt, null);
		}
		return jsonArray;
	}
/**
 * getting vehicle images from ApplicationImages Folder 
 * @param request
 * @return
 */
	public JSONArray getVehicleImages(HttpServletRequest request,String imagePath,String ImageFolderPath) {
		JSONObject jsonObject = new JSONObject();
		JSONArray jsonArray = new JSONArray();
		try {
			File[] files = new File(ImageFolderPath+imagePath).listFiles();
			for (File file : files) {
				if (file.isFile() && (file.getName().toLowerCase().endsWith(".png"))) {
					jsonObject = new JSONObject();
					jsonObject.put("name", file.getName());
					jsonObject.put("url", imagePath+"/"+file.getName());
					jsonArray.put(jsonObject);
			    }
			}
		} catch (Exception e) {
			System.out.println("Error in Admin Function:--getVehicleImages "+ e);
		}
		return jsonArray;
	}
	
/**
 * save Image
 * @param custId
 * @param systemId
 * @param imageName
 * @return
 */
	public String saveImage(String custId, int systemId, String imageName,String saveImagePath,String pageName,String sessionId,String serverName,int userId) {
		Connection conAdmin = null;
		PreparedStatement pstmt = null;
		PreparedStatement pstmt1 = null;
		String img="";
		String message = "";
		ResultSet rs = null;
		ArrayList<String> tableList=new ArrayList<String>();
		try {
			conAdmin = DBConnection.getConnectionToDB("ADMINISTRATOR");
			pstmt = conAdmin.prepareStatement(AdminStatements.SAVE_IMAGE);
			pstmt.setString(1, imageName);
			pstmt.setInt(2, Integer.parseInt(custId));
			pstmt.setInt(3, systemId);
			int i=pstmt.executeUpdate();
			if(i>0){
				tableList.add("Update"+"##"+"ADMINISTRATOR.dbo.CUSTOMER_MASTER");
				pstmt=null;
				/******************************block of statement has to delete after full impl************************************************/
				pstmt = conAdmin.prepareStatement(AdminStatements.SAVE_IMAGE_AMS);
				pstmt.setString(1, imageName);
				pstmt.setInt(2, Integer.parseInt(custId));
				pstmt.setInt(3, systemId);
				int up=pstmt.executeUpdate();
				if(up>0){
					tableList.add("Update"+"##"+"AMS.dbo.tblCustomerMaster");
				}
				pstmt=null;
				/********************************************************************************************************************************/
				if (!imageName.equals("") && imageName != null) {
					img = saveImagePath + imageName;
				}
				
	           	pstmt=conAdmin.prepareStatement("select VehicleNo from AMS.dbo.tblVehicleMaster where System_id=? and ImageName is null or ImageName='' ");
	       		pstmt.setInt(1,systemId);
				rs = pstmt.executeQuery();
				pstmt = null;
				StringBuffer sb = new StringBuffer();
				int a = 0;

				while (rs.next()) {
					String vehicleNo = rs.getString("VehicleNo");
					if (a == 0) {
						sb.append("'" + vehicleNo + "'");
						a = 1;
					} else {
						sb.append(",'" + vehicleNo + "'");
					}
				}
				String regList = sb.toString();
				if (regList.equals("")) {
					regList = "''";
				}
				pstmt1 = conAdmin.prepareStatement("update AMS.dbo.Live_Vision_Support set IMAGE_NAME=? where SYSTEM_ID=? and CLIENT_ID=? and REGISTRATION_NO in ("+regList+")");
				pstmt1.setString(1, img);
				pstmt1.setInt(2, systemId);
				pstmt1.setInt(3, Integer.parseInt(custId));
				int up1=pstmt1.executeUpdate();
				if(up1>0){
					tableList.add("Update"+"##"+"AMS.dbo.Live_Vision_Support");
				}
				pstmt1=null;
				message="save";
				try {
					cf.insertDataIntoAuditLogReport(sessionId, tableList, pageName, "ADD", userId, serverName, systemId,Integer.parseInt(custId),"Added Image for Customer Vehicle");
				} catch (Exception e) {
					e.printStackTrace();
				}
			}else{
				message="error";
			}
		}catch (Exception e) {
			System.out.println("Error in Admin Functions:-saveImage"+e);
		}finally{
			DBConnection.releaseConnectionToDB(conAdmin, pstmt, rs);
			DBConnection.releaseConnectionToDB(null, pstmt1, null);
		}
		return message;
	}
 /**
  * get Setting Label Column List
  * @return
  */
	 public ArrayList<String> getSettingLabelColumnList(){
		 Connection conAdmin = null;
			PreparedStatement pstmt = null;
			ResultSet rs=null;
			ArrayList<String> settingcol=new ArrayList<String>();
			
			try {
				conAdmin = DBConnection.getConnectionToDB("ADMINISTRATOR");
				pstmt = conAdmin.prepareStatement(AdminStatements.GET_SETTING_TYPE_LABEL);
				rs=pstmt.executeQuery();
				while(rs.next()){
					settingcol.add(rs.getString("SETTING_LABEL_ID").trim());
				}
								
			} catch (Exception e) {
				System.out.println("Error in adminfunction:getSettingColumnList"+e);
			}finally{
				DBConnection.releaseConnectionToDB(conAdmin, pstmt, rs);
			}
		 return settingcol;
	 }
	
	 
	 /***
	  * getting branchname depends on clientid and systemid
	  * @param SystemId
	  * @param ClientId
	  * @return
	  */

	 public JSONArray getBranches(int SystemId, String ClientId) 
	 	{
	 		Connection conAdmin = null;
			PreparedStatement pstmt = null;
			ResultSet rs=null;
			JSONArray list2 = new JSONArray();

	 		try 
	 		{
	 			conAdmin = DBConnection.getConnectionToDB("ADMINISTRATOR");
				
	 			String stmt = "";

	 			stmt = AdminStatements.GET_BRANCH_LIST;

	 			if (Integer.parseInt(ClientId)> 0) 
	 			{
	 				stmt = stmt + " and a.ClientId=" + ClientId;

	 			}
	 			stmt = stmt + " ORDER BY BranchName";
	 			pstmt = conAdmin.prepareStatement(stmt);
	 			
	 			pstmt.setInt(1, SystemId);
	 			rs = pstmt.executeQuery();
	 			JSONObject obj1 = new JSONObject();
	 			obj1.put("branchid", "0");
	 			obj1.put("branchname", "Select Branch");
	 			list2.put(obj1);
	 			while (rs.next()) 
	 			{
	 				obj1 = new JSONObject();
	 				obj1.put("branchid", rs.getInt(1));
	 				obj1.put("branchname", rs.getString(2));
	 				list2.put(obj1);
	 			}
	 		} 
	 		catch (Exception e) 
	 		{
	 			System.out.println("Error in Admin Functions:-getBranches "+e.toString());
	 		} 
	 		finally 
	 		{
	 			DBConnection.releaseConnectionToDB(conAdmin, pstmt, rs);
	 		}
	 		return list2;
	 	}
	 
	 public JSONArray getEmVisionList() 
	 	{
	 		Connection conAdmin = null;
			PreparedStatement pstmt = null;
			ResultSet rs=null;
			JSONArray jsonlist = new JSONArray();

	 		try 
	 		{
	 			conAdmin = DBConnection.getConnectionToDB("ADMINISTRATOR");
				
	 			String stmt = AdminStatements.GET_EM_VISION_LIST;
	 			pstmt = conAdmin.prepareStatement(stmt);
	 			rs = pstmt.executeQuery();
	 			JSONObject obj1 = new JSONObject();
	 			while (rs.next()) 
	 			{
	 				obj1 = new JSONObject();
	 				obj1.put("emVisionId", rs.getInt("ID"));
	 				obj1.put("emVisionName", rs.getString("NAME"));
	 				jsonlist.put(obj1);
	 			}
	 		} 
	 		catch (Exception e) 
	 		{
	 			System.out.println("Error in Admin Functions:-getEmVision "+e.toString());
	 		} 
	 		finally 
	 		{
	 			DBConnection.releaseConnectionToDB(conAdmin, pstmt, rs);
	 		}
	 		return jsonlist;
	 	}
	
	public String getEmailTemplateForCustomerInformation(String custName,String buttonValue,String userName,String systemName){
		String body="";
		try{
			if(buttonValue.equalsIgnoreCase("add"))
			{
			body="<html><body>" +
			"<p>Dear LTSP,</p>" +
			"<table>" +
			"<tr>" +
			"<td>Customer "+custName+ " successfully created by <b>"+userName+"</b> for the LTSP-"+systemName+". </td></tr></td></tr></table><br/>" +
			"<tr><br><td align=left><br>Thanks & Regards</td></tr>"+
			"<table><tr><br><br><td align=left><font style=font-style:italic size=2 bgcolor=#4447A6<b>Please do not reply to this mail. This is an auto generated mail and replies to this email id are not attended too.</b></font></td></tr>"+
			"</table></body></html>";
			}else
			{
				body="<html><body>" +
				"<p>Dear LTSP,</p>" +
				"<table>" +
				"<tr>" +
				"<td>Customer "+custName+ " successfully deleted by <b>"+userName+"</b> for the LTSP-"+systemName+". </td></tr></td></tr></table><br/>" +
				"<tr><br><td align=left><br>Thanks & Regards</td></tr>"+
				"<table><tr><br><br><td align=left><font style=font-style:italic size=2 bgcolor=#4447A6<b>Please do not reply to this mail. This is an auto generated mail and replies to this email id are not attended too.</b></font></td></tr>"+
				"</table></body></html>";
			}
		}catch(Exception e){
			System.out.println("Error in AdminFunctions:-getEmailTemplateForCustomerInformation method"+e.toString());
		}
		return body;
	}
	public JSONArray getStatedetails(String customerid, int systemId) {
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject = null;
		Connection conAdmin=null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		try {
			conAdmin=DBConnection.getConnectionToDB("ADMINISTRATOR");
			pstmt=conAdmin.prepareStatement(AdminStatements.GET_STATE_DETAILS);
			pstmt.setInt(1, Integer.parseInt(customerid));
			pstmt.setInt(2, systemId);
			rs=pstmt.executeQuery();
			while(rs.next()){
				jsonObject=new JSONObject();
				String	statecode=rs.getString("STATE_CODE");											
				String  statename=rs.getString("STATE_NAME");
				if(!statecode.equals(""))
				{
				jsonObject.put("StateId", statecode);
				jsonObject.put("StateName", statename);
				jsonArray.put(jsonObject);
				}
			}
		} catch (Exception e) {
			System.out.println("error in AdminFunction:- getSupervisordetails()"+e);
		}
		finally{
			DBConnection.releaseConnectionToDB(conAdmin, pstmt, rs);
		}
		return jsonArray;
	}
	public JSONArray getCityDetails(int stateId) {
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject = null;
		Connection conAdmin=null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		try {
			conAdmin=DBConnection.getConnectionToDB("ADMINISTRATOR");
			pstmt=conAdmin.prepareStatement(AdminStatements.GET_CITY_DETAILS);
			pstmt.setInt(1, stateId);
			rs=pstmt.executeQuery();
			while(rs.next()){
				jsonObject=new JSONObject();
				
				jsonObject.put("cityId", rs.getString("CITY_ID"));
				jsonObject.put("cityName", rs.getString("CITY_NAME"));
				jsonArray.put(jsonObject);
			}
		} catch (Exception e) {
			System.out.println("error in AdminFunction:- getCityDetails()");
			e.printStackTrace();
		}
		finally{
			DBConnection.releaseConnectionToDB(conAdmin, pstmt, rs);
		}
		return jsonArray;
	}
	public JSONArray getVehicle(int systemid, int clientid,int userid)
	{
		JSONArray jsonArray = new JSONArray();
		JSONObject obj1 = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try 
		{
			con = DBConnection.getConnectionToDB("AMS");

			pstmt = con.prepareStatement(AdminStatements.GET_VEHICLE_LIST);
			pstmt.setInt(1, clientid);
			pstmt.setInt(2, systemid);
			pstmt.setInt(3, userid);
			rs = pstmt.executeQuery();
			while (rs.next()) 
			{
				obj1 = new JSONObject();
				obj1.put("VehiName", rs.getString("REGISTRATION_NUMBER"));
				jsonArray.put(obj1);
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
		return jsonArray;
	}

public String reprocessDataForVehicle(int systemid, int clientid,String vehicleNo,String date,int offset,int userId)
{
	Connection con = null;
	String message="";
	try {
		con = DBConnection.getConnectionToDB("AMS");
		PreparedStatement pstmt1 = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		ResultSet rs1 = null;
		ArrayList<Object> list = new ArrayList<Object>();
	    boolean FCIS=false;
	    int groupId=0;
	    double lastCumulativeDistance=0; 
	    SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd");
	    SimpleDateFormat sdfYYMMDD = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	    if (date.contains("T")) {
			date = date.replace("T", " ");
	    }
	    try {
			pstmt = con.prepareStatement(AdminStatements.GET_VEHICLE_DETAILS);
			pstmt.setString(1, vehicleNo);
			pstmt.setInt(2, systemid);
			pstmt.setInt(3, clientid);
			
			rs = pstmt.executeQuery();
			while(rs.next())
			{
			 groupId=rs.getInt("GROUP_ID");
						
				 if (rs.getInt("FCIS") == 0) {
						FCIS=false;
				} else {
						FCIS=true;
				}
			}
				 date = simpleDateFormat.format(simpleDateFormat.parse(date));
				 date = date +" 00:00:00";
				 Date startDate = simpleDateFormat.parse(date);
				 
				 Date endDate = null;
					Calendar cal = Calendar.getInstance();
					cal.setTime(startDate);
					cal.add(Calendar.MINUTE, -offset);
					startDate=cal.getTime();
					cal.add(Calendar.DATE, +1);
					endDate = cal.getTime();
					
					 pstmt1=con.prepareStatement(AdminStatements.GET_CUMULATIVE_DISTANCE);
						pstmt1.setString(1, vehicleNo);
						pstmt1.setString(2, sdfYYMMDD.format(startDate));
						pstmt1.setInt(3, systemid);
						pstmt1.setInt(4, clientid);
						rs1= pstmt1.executeQuery();
						if(rs1.next())
						{
							if(rs1.getString("CUMULATIVE_DISTANCE")!=null && !(rs1.getString("CUMULATIVE_DISTANCE").equals(""))){
								lastCumulativeDistance=rs1.getDouble("CUMULATIVE_DISTANCE");
							}
						}else {
							lastCumulativeDistance = 0;
						}
					message=reprossingData(startDate,endDate,systemid,clientid,con,vehicleNo,FCIS,groupId,offset,lastCumulativeDistance,userId);
				   
	    } catch (Exception e) {
		e.printStackTrace();
		message="error in reprocessing data";
		System.out.println("Error in Admin Function:-Reprocessing"+e);
	} finally {
		DBConnection.releaseConnectionToDB(con, pstmt, rs);
		DBConnection.releaseConnectionToDB(null, pstmt1, rs1);
	}
	}
	catch (Exception e) {
		e.printStackTrace();
		message="error in reprocessing data";
		System.out.println("Error in Admin Function:-Reprocessing"+e);
	}
	
	

	return message;
}

public String reprossingData(Date startdate,Date enddate,int systemid,int clientid,Connection con,String vehicleNo,boolean FCIS,int groupId,int offset,double lastCumulativeDistance,int userId ) {
	String msg="";
	DecimalFormat Dformatter = new DecimalFormat("#.##");
	try {
		
			        VehicleActivity va = new VehicleActivity(con,vehicleNo, startdate, enddate, offset, systemid, clientid, 0);
			        VehicleSummaryBean vsb = va.getVehicleSummaryBean();
			        double ConversionFactor=cf.initializedistanceConversionFactor(systemid,con,vehicleNo);
					double odometer = 0;
					
					ArrayList<Double> list=GetTankCapacityAndApproxMileage(vehicleNo,con);
					double capacity =list.get(0);
					double mileageWithLoad = list.get(1);
					
					ArrayList fuelInfo = getTotalrefuel(vehicleNo, startdate, enddate,capacity, FCIS,con);
					double refuel = 0;
					int refuelCount = 0;
					if (fuelInfo.size()>1) {
						refuel = (Double) fuelInfo.get(0);
						refuelCount = (Integer) fuelInfo.get(1);
					}
					lastCumulativeDistance=Double.parseDouble(Dformatter.format(lastCumulativeDistance+(vsb.getTotalDistanceTravelled()*ConversionFactor)));
					msg=saveSummaryData(vsb, startdate, vehicleNo, enddate, odometer, refuel, capacity, mileageWithLoad,groupId,ConversionFactor, refuelCount, FCIS,lastCumulativeDistance,con,systemid,clientid,userId);
					
		}
	 catch (Exception e) {
		e.printStackTrace();
	}
	 return msg;
}


public ArrayList<Double> GetTankCapacityAndApproxMileage(String vehicleNo,Connection con) {
	
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	ArrayList<Double> list=new ArrayList<Double>();
	double TankCapacity = 0;
	double ApproxMileage = 0;
	try {
		pstmt = con.prepareStatement(AdminStatements.GET_TANK_CAPACITY_AND_MILEAGE_WITH_LOAD);
		pstmt.setString(1, vehicleNo);
		rs = pstmt.executeQuery();
		if (rs.next()) {
			TankCapacity = rs.getDouble("TankCapacity");
			ApproxMileage = rs.getDouble("Approx_Mileage_With_Load");					
		}
		list.add(TankCapacity);
		list.add(ApproxMileage);
	} catch (Exception e) {
		e.printStackTrace();
	} finally {
		DBConnection.releaseConnectionToDB(null, pstmt, rs);
	}
	return list;
}

public ArrayList<Double> getTotalrefuel(String vehicleNo, Date startDate, Date enddate,double capacity, boolean isFCIS,Connection con) {
	
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	double totalrefuel = 0;
	int refuelCount = 0;
	SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	ArrayList fuelInfo = new ArrayList<Double>();
	try {
		pstmt = con.prepareStatement(AdminStatements.GET_TOTAL_REFUEL);
		pstmt.setString(1, vehicleNo);
		pstmt.setString(2, sdf.format(startDate));
		pstmt.setString(3, sdf.format(enddate));
		rs = pstmt.executeQuery();
		if (rs.next()) {
			totalrefuel = rs.getDouble("totalfuel");
			refuelCount = rs.getInt("RefuelCount");
		}
	} catch (Exception e) {
		e.printStackTrace();
	} finally {
		DBConnection.releaseConnectionToDB(null, pstmt, rs);
		fuelInfo.add(totalrefuel);
		fuelInfo.add(refuelCount);
	}
	return fuelInfo;
}

public String saveSummaryData(VehicleSummaryBean vsb, Date startDate, String vehicleNo, Date endDate, double odometer, double refuel, 
		double capacity, double mileageWithLoad,int groupId,double ConversionFactor, double refuelCount, boolean isFCIS,double lastCumulativeDist,Connection con,int systemid,int clientid,int userId) {
	PreparedStatement pstmt = null;
	PreparedStatement pstmt1 = null;
	PreparedStatement pstmt2 = null;
	double firstFuelLevel=0;
	double lastFuelLevel=0;
	ResultSet rs=null;
	String msg=null;
	SimpleDateFormat sdfYY = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	int ineserted=0;
	try {

		double idlehrs = cf.getHrsFromDaysHrsMins(vsb.getTotalIdleDurationFormated());
		double runninghrs = cf.getHrsFromDaysHrsMins(vsb.getTravelTimeFormated());
		String IdelCountAndStoppageCount = getIdelCountAndStoppageCount(sdfYY.format(startDate),sdfYY.format(endDate),vsb.getSystemId(),vsb.getClientId(),vehicleNo,con);
		int overspeed = getOverSpeedCount(vehicleNo,sdfYY.format(startDate),sdfYY.format(endDate),con);
		String[] a1 = IdelCountAndStoppageCount.split(",");
		int idel = Integer.parseInt(a1[0]);
		int stoppage = Integer.parseInt(a1[1]);
		int seatbelt = Integer.parseInt(a1[2]);

		double enginehrs = idlehrs + runninghrs;
		double fuelconsume = ((vsb.getFirstFuel() + refuel) - vsb.getLastFuel());
		
		fuelconsume = ((fuelconsume / 100) * capacity);
		String drivername = getDriverName(sdfYY.format(endDate), vsb.getSystemId(), vehicleNo, con);
		
		double fuelUsed = 0.0;
		if (vsb.getTotalDistanceTravelled() > 0 && mileageWithLoad > 0) 
		{
			fuelUsed = (vsb.getTotalDistanceTravelled() / mileageWithLoad);
		}
		
		double mileage = 0;

		if (vsb.getTotalDistanceTravelled() > 0 && fuelconsume > 0) {
			mileage = (vsb.getTotalDistanceTravelled() / fuelconsume);
		}
		/**
		 * If the vehicle is associated with the new FCIS, put new fuel consumed and mileage.
		 */
		refuel = (refuel / 100) * capacity;
		firstFuelLevel = (vsb.getFirstFuel() / 100) * capacity;
		lastFuelLevel = (vsb.getLastFuel() / 100) * capacity;
		/**
		 * End
		 */
		String comm="YES";
		if(vsb.getStartLocation()==null){
			comm="NO";
		}else{
			comm="YES";
		}
		pstmt1 = con.prepareStatement(AdminStatements.GET_VEHICLE_SUMMARY);
		pstmt1.setInt(1, systemid);
		pstmt1.setInt(2, clientid);
		pstmt1.setString(3, vehicleNo);
		pstmt1.setString(4, sdfYY.format(startDate));
		rs=pstmt1.executeQuery();;
		if(rs.next())
		{
		pstmt = con.prepareStatement(AdminStatements.UPDATE_INTO_VEHICLE_SUMMARY);
		pstmt.setInt(1, vsb.getTotalNumberOfStops());
		pstmt.setDouble(2, cf.getHrsFromDaysHrsMins(vsb.getTotalStopDurationFormated()));
		pstmt.setInt(3, vsb.getTotalNumberOfIdles());
		pstmt.setDouble(4, idlehrs);
		pstmt.setInt(5, overspeed);
		pstmt.setDouble(6, vsb.getDistanceTravelledWithOverSpeeds()*ConversionFactor);
		pstmt.setDouble(7, vsb.getMaxSpeedInKMPH()*ConversionFactor);
		pstmt.setDouble(8, runninghrs);
		pstmt.setDouble(9, enginehrs); // / engine hours
		pstmt.setDouble(10, vsb.getTotalDistanceTravelled()*ConversionFactor);
		pstmt.setString(11, vsb.getStartLocation());
		pstmt.setString(12, vsb.getEndLocation());
		if (vsb.getLastRecordProcessed() == null) {
			pstmt.setString(13, null);
		} else {
			pstmt.setString(13, sdfYY.format(vsb.getLastRecordProcessed()));
		}
		pstmt.setTimestamp(14, (Timestamp) vsb.getStartTime());
		pstmt.setTimestamp(15, (Timestamp) vsb.getEndTime());
		pstmt.setDouble(16, odometer);
		pstmt.setTimestamp(17, (Timestamp) vsb.getFirstRunning());
		pstmt.setTimestamp(18, (Timestamp) vsb.getLastRunning());
		pstmt.setDouble(19, firstFuelLevel);
		pstmt.setDouble(20, lastFuelLevel);
		pstmt.setDouble(21, refuel);
		pstmt.setDouble(22, fuelconsume);
		pstmt.setDouble(23, mileage);
		pstmt.setString(24, drivername);
		pstmt.setDouble(25, fuelUsed);
		pstmt.setInt(26, idel);
		pstmt.setInt(27, stoppage);
		pstmt.setString(28, comm);
		pstmt.setInt(29, seatbelt);
		pstmt.setDouble(30, fuelUsed);
		pstmt.setDouble(31, refuelCount);
		pstmt.setDouble(32, lastCumulativeDist);
		pstmt.setString(33, vsb.getUnitNumber());
		pstmt.setString(34, vehicleNo);
		pstmt.setInt(35, systemid);
		pstmt.setInt(36, clientid);
		pstmt.setString(37, sdfYY.format(startDate));
		ineserted=pstmt.executeUpdate();
		
		}
		else
		{
			pstmt = con.prepareStatement(AdminStatements.INSERT_INTO_VEHICLE_SUMMARY);
			pstmt.setString(1, sdfYY.format(startDate));
			pstmt.setString(2, vehicleNo);
			pstmt.setString(3, vsb.getUnitNumber());
			pstmt.setInt(4, systemid);
			pstmt.setInt(5, clientid);
			pstmt.setInt(6, vsb.getTotalNumberOfStops());
			pstmt.setDouble(7, cf.getHrsFromDaysHrsMins(vsb.getTotalStopDurationFormated()));
			pstmt.setInt(8, vsb.getTotalNumberOfIdles());
			pstmt.setDouble(9, idlehrs);
			pstmt.setInt(10, overspeed);
			pstmt.setDouble(11, vsb.getDistanceTravelledWithOverSpeeds()*ConversionFactor);
			pstmt.setDouble(12, vsb.getMaxSpeedInKMPH()*ConversionFactor);
			pstmt.setDouble(13, runninghrs);
			pstmt.setDouble(14, enginehrs); // / engine hours
			pstmt.setDouble(15, vsb.getTotalDistanceTravelled()*ConversionFactor);
			pstmt.setString(16, vsb.getStartLocation());
			pstmt.setString(17, vsb.getEndLocation());
			pstmt.setString(18, sdfYY.format(startDate));
			pstmt.setString(19, sdfYY.format(endDate));
			
			if (vsb.getLastRecordProcessed() == null) {
				pstmt.setString(20, null);
			} else {
				pstmt.setString(20, sdfYY.format(vsb.getLastRecordProcessed()));
			}
			pstmt.setTimestamp(21, (Timestamp) vsb.getStartTime());
			pstmt.setTimestamp(22, (Timestamp) vsb.getEndTime());
			pstmt.setDouble(23, odometer);
			pstmt.setTimestamp(24, (Timestamp) vsb.getFirstRunning());
			pstmt.setTimestamp(25, (Timestamp) vsb.getLastRunning());
			pstmt.setDouble(26, firstFuelLevel);
			pstmt.setDouble(27, lastFuelLevel);
			pstmt.setDouble(28, refuel);
			pstmt.setDouble(29, fuelconsume);
			pstmt.setDouble(30, mileage);
			pstmt.setString(31, drivername);
			pstmt.setDouble(32, fuelUsed);
			pstmt.setInt(33, idel);
			pstmt.setInt(34, stoppage);
			pstmt.setInt(35, groupId);
			pstmt.setString(36, comm);
			pstmt.setInt(37, seatbelt);
			pstmt.setDouble(38, fuelUsed);
			pstmt.setDouble(39, refuelCount);
			pstmt.setDouble(40, lastCumulativeDist);
			ineserted=pstmt.executeUpdate();
		}
		pstmt=null;
		if(ineserted>0)
		{
			pstmt=con.prepareStatement(AdminStatements.INSERT_INTO_REPORT_REPROCESS);
			pstmt.setString(1, vehicleNo);
			pstmt.setString(2, sdfYY.format(startDate));
			pstmt.setInt(3, systemid);
			pstmt.setInt(4, clientid);
			pstmt.setInt(5, userId);
			int updated=pstmt.executeUpdate();
			if (updated>0) {
				msg="Reprocessed Successfully";
			}else {
				msg="error";
			}
		}
		else
		{
			msg="error";
		}
	
	} catch (Exception e) {
		e.printStackTrace();
	}
	finally{
		DBConnection.releaseConnectionToDB(null, pstmt, rs);
		DBConnection.releaseConnectionToDB(null, pstmt1, null);
	}
	return msg;
}

private String getIdelCountAndStoppageCount(String startDate, String endDate,int systemId2, int clientId2,String vehicleNo,Connection con) 
{
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	String idle = "0";
	String stoppage = "0";
	int seatbelt=0;
	try 
	{
		pstmt = con.prepareStatement(AdminStatements.GET_IDLE_STOP_OVERSPEED_COUNT);
		pstmt.setString(1, vehicleNo);
		pstmt.setString(2, startDate);
		pstmt.setString(3, endDate);
        rs = pstmt.executeQuery();
		while(rs.next()) 
		{
			if(rs.getString("TypeOfAlert").equals("39"))
			{
				idle = rs.getString("AlertCount");
			}
			/*else if(rs.getString("TypeOfAlert").equals("2"))
			{
				overSpeed = rs.getString("AlertCount");
			}*/
			else if(rs.getString("TypeOfAlert").equals("1"))
			{
				stoppage = rs.getString("AlertCount");
			}
			else
			{
			    seatbelt = rs.getInt("AlertCount");
			}
		}
	} 
	catch (Exception e) 
	{
		e.printStackTrace();
	} 
	finally 
	{
		DBConnection.releaseConnectionToDB(null, pstmt, rs);
	}
	
	return idle+","+stoppage+","+seatbelt;
}

private int getOverSpeedCount(String vehicleNo,String startDate, String endDate,Connection con) 
{
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	int overSpeedCount = 0;
	try 
	{
		pstmt = con.prepareStatement(AdminStatements.GET_OVERSPEED_COUNT);
		pstmt.setString(1, vehicleNo);
		pstmt.setString(2, startDate);
		pstmt.setString(3, endDate);
		rs = pstmt.executeQuery();			
		while(rs.next()){
				overSpeedCount = rs.getInt("AlertCount");
		}
	}
	catch (Exception e) 
	{
		e.printStackTrace();
	} 
	finally 
	{
		DBConnection.releaseConnectionToDB(null, pstmt, rs);
	}
	
	return overSpeedCount;
}

public String getDriverName(String meterOnEndDate, int systemId, String regNumber, Connection con) {
	String drivername = "";
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	try {
		pstmt = con.prepareStatement(AdminStatements.SELECT_DRIVER_NAME_FOR_TAXI_METER);
		pstmt.setString(1, meterOnEndDate);
		pstmt.setInt(2, systemId);
		pstmt.setString(3, regNumber);
		pstmt.setInt(4, systemId);
		pstmt.setString(5, regNumber);
		pstmt.setString(6, meterOnEndDate);
		rs = pstmt.executeQuery();
		if (rs.next()) {
			drivername = rs.getString(1);
		}

	} catch (Exception e) {
		e.printStackTrace();
	}
	finally{
		DBConnection.releaseConnectionToDB(null, pstmt, rs);
	}
	return drivername;
}


/************************************************Unit Details*************************************************************/

public JSONArray getManufacturerDetails(int systemId){
	PreparedStatement pstmt = null;
	Connection con = null;
	ResultSet rs = null;
	JSONArray jsonArray = new JSONArray();
	try {
		con = DBConnection.getConnectionToDB("AMS");
		pstmt = con.prepareStatement(AdminStatements.SELECT_MANUFACTURE_CODE);
		rs = pstmt.executeQuery();
		JSONObject jsonObject = new JSONObject();
		//jsonObject.put("id", 0);
		//jsonObject.put("name", "Select Manufacturer");
		jsonArray.put(jsonObject);
		while (rs.next()) {
			jsonObject = new JSONObject();
			jsonObject.put("id", rs.getString("MANUFACTURE_ID"));
			jsonObject.put("name", rs.getString("MANUFACTURE_NAME"));
			jsonArray.put(jsonObject);
		}

	} catch (Exception e) {
		e.printStackTrace();
	} finally {
		DBConnection.releaseConnectionToDB(con, pstmt, rs);
	}
	return jsonArray;
}		
public JSONArray getUnitTypes(String manufacturerCode, int systemId){
	PreparedStatement pstmt = null;
	Connection conAdmin=null;
	ResultSet rs = null;
	JSONArray jsonArray = new JSONArray();
	JSONObject jsonObject = new JSONObject();
	int manufacturercode = Integer.parseInt(manufacturerCode);
	try {
		conAdmin = DBConnection.getConnectionToDB("AMS");
		if(manufacturercode==32){
			pstmt = conAdmin.prepareStatement(AdminStatements.SELECT_UNIT_TYPE_CODE_ALL);
		}else{
			pstmt = conAdmin.prepareStatement(AdminStatements.SELECT_UNIT_TYPE_CODE_FROM_MANUFACTURE);
			pstmt.setInt(1, manufacturercode);
		}
		rs = pstmt.executeQuery();
		while (rs.next()) {
			jsonObject = new JSONObject();
			jsonObject.put("UnitTypeCode", rs.getString("UNIT_TYPE_CODE"));
			jsonObject.put("UnitTypeDesc", rs.getString("UNIT_NAME"));
			jsonArray.put(jsonObject);
		}
	} catch (Exception e) {
		e.printStackTrace();
	} finally {
		DBConnection.releaseConnectionToDB(conAdmin, pstmt, rs);
	}
	return jsonArray;

}

SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
public ArrayList < Object > getUnitDetails(int offset,int systemId, String language) {

	JSONArray JsonArray = new JSONArray();
	JSONObject JsonObject = null;
	Connection con = null;
	PreparedStatement pstmt2 = null;
	ResultSet rs2 = null;
	int count = 0;
	ArrayList<ReportHelper> reportsList = new ArrayList<ReportHelper>();
	ArrayList<String> headersList = new ArrayList<String>();
	ReportHelper finalreporthelper = new ReportHelper();
	ArrayList < Object > aslist = new ArrayList < Object > ();
	headersList.add(cf.getLabelFromDB("SLNO", language));
	headersList.add(cf.getLabelFromDB("Unit_Number", language));
	headersList.add(cf.getLabelFromDB("Manufaturer", language));
	headersList.add(cf.getLabelFromDB("Unit_Type", language));
	headersList.add(cf.getLabelFromDB("Unit_Reference_Id", language));
	headersList.add(cf.getLabelFromDB("Created_Date_And_Time", language));
	headersList.add(cf.getLabelFromDB("Status", language));
	try {
		con = DBConnection.getConnectionToDB("AMS");
		pstmt2 = con.prepareStatement(AdminStatements.GET_ALL_UNITS_DETAILS);
		pstmt2.setInt(1,offset);
		pstmt2.setInt(2, systemId);
		rs2 = pstmt2.executeQuery();
		while (rs2.next()) {
			JsonObject = new JSONObject();
			ArrayList<Object> informationList = new ArrayList<Object>();
			ReportHelper reporthelper = new ReportHelper();
			count++;
			
			JsonObject.put("slnoIndex", count);
			informationList.add(count);
			
			JsonObject.put("unitNo", rs2.getString("UNIT_NO").toUpperCase());
			informationList.add(rs2.getString("UNIT_NO").toUpperCase());
			
			JsonObject.put("manufacturerid", rs2.getString("manufactureId").toUpperCase());
			informationList.add(rs2.getString("Manufacturer").toUpperCase());
			
			JsonObject.put("unitTypeId", rs2.getString("unitTypeid").toUpperCase());
			informationList.add(rs2.getString("Unit_Type").toUpperCase());
			
			JsonObject.put("unitIMEI", rs2.getString("Unit_Reference_Id"));
			informationList.add(rs2.getString("Unit_Reference_Id"));
			
            if (sdf.format(rs2.getTimestamp("last_Created_date_and_Time")) != null) {
            	JsonObject.put("DateAndTime", sdf.format(rs2.getTimestamp("last_Created_date_and_Time")));
            	informationList.add(sdf.format(rs2.getTimestamp("last_Created_date_and_Time")));
			}else{
				JsonObject.put("DateAndTime", "");
				informationList.add("");
			}
			JsonObject.put("manufacturer", rs2.getString("Manufacturer").toUpperCase());
			//informationList.add(rs2.getString("Manufacturer").toUpperCase());
			
			JsonObject.put("unitType", rs2.getString("Unit_Type").toUpperCase());
			//informationList.add(rs2.getString("Unit_Type").toUpperCase());
			
			JsonObject.put("Status", rs2.getString("STATUS").toUpperCase());
			informationList.add(rs2.getString("STATUS").toUpperCase());
			
			JsonObject.put("transparentMode", (rs2.getInt("TRANSPARENT_MODE")==1)?"ACTIVE":"INACTIVE");
			
			JsonObject.put("imsi", rs2.getString("IMSI"));
			
			JsonObject.put("predefinedMobileNum", rs2.getString("PREDEFINED_MOBILE_NO").toUpperCase());
			
			JsonArray.put(JsonObject);
			reporthelper.setInformationList(informationList);
			reportsList.add(reporthelper);
		}
		aslist.add(JsonArray);
		finalreporthelper.setReportsList(reportsList);
		finalreporthelper.setHeadersList(headersList);
		aslist.add(finalreporthelper);
	} catch (Exception e) {
		e.printStackTrace();
	}finally {

		DBConnection.releaseConnectionToDB(con, pstmt2, rs2);
	}
	return aslist;

}		
String message="";
public synchronized String 	unitDetailsInsert(String unitNumber, String manufactureCode, String unitTypeCode, String unitReferenceId,
		String lastDownloadedDateAndTime,int offset,int userId,String STATUS, int systemId,String predefinedMobileNum,String pageName,String sessionId,String serverName,int transMode){
	Connection con = null;
	PreparedStatement pstmt = null;
	ResultSet rs3 = null;
	ArrayList<String> tableList=new ArrayList<String>();
	try {
		int Insertcount = 0;
		if(predefinedMobileNum.isEmpty()||predefinedMobileNum.equalsIgnoreCase("None")){
			predefinedMobileNum="";
		}
		con = DBConnection.getConnectionToDB("AMS");
		pstmt = con.prepareStatement(AdminStatements.SELECT_UNIT_NUMBER_VALIDATE);
		pstmt.setString(1,unitNumber.toUpperCase());
		rs3 = pstmt.executeQuery();
		if (rs3.next()) {
			message = "<p  >Unit Number already exists. Try some other Unit Number.</p>";
			return (message);
		}
		if(rs3!=null)
		rs3.close();
		
		if(!(unitReferenceId.isEmpty())){
			pstmt = con.prepareStatement(AdminStatements.SELECT_UNIT_REFERENCE_ID_VALIDATE);
			pstmt.setString(1,unitReferenceId);
			rs3 = pstmt.executeQuery();
			if (rs3.next()) {
				message = "<p  >Unit Reference Number already exists. Try some other Unit Reference Number.</p>";
				return (message);
			}
		}
		
		con.setAutoCommit(false);
		pstmt = con.prepareStatement(AdminStatements.UNIT_INSERT);
		pstmt.setString(1, unitNumber.toUpperCase());
		pstmt.setInt(2, Integer.parseInt(manufactureCode));
		pstmt.setInt(3, Integer.parseInt(unitTypeCode));
		pstmt.setString(4, unitReferenceId);
		pstmt.setInt(5,systemId);
		Insertcount = pstmt.executeUpdate();
		if(Insertcount>0){tableList.add("Insert"+"##"+"AMS.dbo.Unit_Master");}
		
		pstmt = con.prepareStatement(AdminStatements.UNIT_INSERT_INTO_ADMIN_UNIT);
		pstmt.setString(1, unitNumber.toUpperCase());
		pstmt.setInt(2, Integer.parseInt(manufactureCode));
		pstmt.setInt(3, Integer.parseInt(unitTypeCode));
		pstmt.setString(4, unitReferenceId);
		pstmt.setInt(5, userId);
		pstmt.setString(6,STATUS);
		pstmt.setInt(7, systemId);
		pstmt.setString(8, predefinedMobileNum);
		pstmt.setInt(9, transMode);
		Insertcount = pstmt.executeUpdate();
		if(Insertcount>0){tableList.add("Insert"+"##"+"ADMINISTRATOR.dbo.UNIT_MASTER");}
		con.commit();
		if (Insertcount == 1) {
			message = "<p  >Unit Number " + unitNumber.toUpperCase()
			+ " added successfully.</p>";
		}
		try {
			cf.insertDataIntoAuditLogReport(sessionId, tableList, pageName, "ADD", userId, serverName, systemId, 0,"Added Unit Details");
		} catch (Exception e) {
			e.printStackTrace();
		}

	} catch (Exception e) {
		if (con!=null) {
			try {
				con.rollback();
			} catch (SQLException e1) {
				e1.printStackTrace();
			}
		}
		message = "<p  >Error While Adding Unit and the Error is "
			+ e.toString() + "</p>";
		System.out.println("Error in unitInsert method..." + e);
		e.printStackTrace();
	}finally {
		DBConnection.releaseConnectionToDB(con, pstmt, rs3);
	}
	return message;

}

public String saveUnitDetails(int systemId,int userId,List<UnitDetailsData> list){
	Connection con = null;
	PreparedStatement pstmt = null;
	int Insertcount=0;
	String message="";
	String mobileNo=null;
	try{
		con = DBConnection.getConnectionToDB("AMS");
		con.setAutoCommit(false);
		for(UnitDetailsData unitDetails:list){
			
			pstmt = con.prepareStatement(AdminStatements.UNIT_INSERT);
			pstmt.setString(1, unitDetails.unitNumber.toUpperCase());
			pstmt.setInt(2, Integer.parseInt(unitDetails.manufacturer));
			pstmt.setInt(3, Integer.parseInt(unitDetails.unitType));
			pstmt.setString(4,unitDetails.unitReferenceId);
			pstmt.setInt(5,systemId);
			Insertcount = pstmt.executeUpdate();
		
			pstmt = con.prepareStatement(AdminStatements.UNIT_INSERT_INTO_ADMIN_UNIT);
			pstmt.setString(1, unitDetails.unitNumber.toUpperCase());
			pstmt.setInt(2, Integer.parseInt(unitDetails.manufacturer));
			pstmt.setInt(3, Integer.parseInt(unitDetails.unitType));
			pstmt.setString(4, unitDetails.unitReferenceId);
			pstmt.setInt(5, userId);
			pstmt.setString(6,"ACTIVE");
			pstmt.setInt(7, systemId);
			pstmt.setString(8, mobileNo);
			pstmt.setString(9, "0");
			Insertcount = pstmt.executeUpdate();
		}
		con.commit();
		if (Insertcount == 1) {
			message = "<p  >Unit Numbers added successfully.</p>";
		}
	}catch (Exception e) {
		e.printStackTrace();
	}finally {
		DBConnection.releaseConnectionToDB(con, pstmt, null);
	}
	return message;
}
	
	
	
	

public String unitDetailsUpdate(String unitNumber, String manufactureCode,String unitTypeCode,String unitReferenceId, String lastDownloadedDateAndTime, 
		int offset,int userId,String STATUS, int systemId, String id,String predefinedMobileNum,String pageName,String sessionId,String serverName,int transMode) {
  
	int updatecount = 0;
	Connection con = null;
	PreparedStatement pstmt4 = null;
	PreparedStatement pstmt5 = null;
	PreparedStatement pstmt2 = null;
	ResultSet rs2 = null;
	//System.out.println(unitTypeCode);
	//System.out.println(unitNumber);
	ArrayList<String> tableList=new ArrayList<String>();
	try {
		con = DBConnection.getConnectionToDB("AMS");
		con.setAutoCommit(false);
		STATUS=STATUS.trim();
		if(STATUS.equals("INACTIVE"))
		{
			pstmt2 = con.prepareStatement(AdminStatements.SELECT_UNIT_NUMBER_IN_UNIT_MASTER);
			pstmt2.setString(1,unitNumber);
			pstmt2.setInt(2, systemId);
			rs2 = pstmt2.executeQuery();
			if(rs2.next())
			{
	        	   message = "<p  >Unit Number "
	      				+ unitNumber.toUpperCase()
	      				+ " Is Associated To Mobile. Make It Active To Modify.</p>";
	      		  return message;

			}
			if(rs2!=null)
			rs2.close();
		}
		
		if(predefinedMobileNum.isEmpty()||predefinedMobileNum.equalsIgnoreCase("None")){
			predefinedMobileNum="";
		}
		
		if(!(unitReferenceId.isEmpty())){
			pstmt2 = con.prepareStatement(AdminStatements.UNIT_REFERENCE_ID_VALIDATE_UPDATE);
			pstmt2.setString(1,unitReferenceId);
			pstmt2.setString(2,unitNumber.toUpperCase());
			rs2 = pstmt2.executeQuery();
			if (rs2.next()) {
				message = "<p  >Unit Reference Number already exists. Try some other Unit Reference Number.</p>";
				return (message);
			}
			if(rs2!=null)
				rs2.close();
		}
		
		pstmt4 = con.prepareStatement(AdminStatements.UPDATE_UNIT_DETAILS_AMS);
		pstmt4.setInt(1,Integer.parseInt(manufactureCode));
		pstmt4.setInt(2, Integer.parseInt(unitTypeCode));
		pstmt4.setString(3, unitReferenceId);
		pstmt4.setString(4, unitNumber.toUpperCase());
		pstmt4.setInt(5,systemId);
		updatecount = pstmt4.executeUpdate();
		if(updatecount>0){tableList.add("Update"+"##"+"AMS.dbo.Unit_Master");}
		
		pstmt4 = con.prepareStatement(AdminStatements.UPDATE_UNIT_DETAILS_ADMINSTRATOR);
		pstmt4.setInt(1,Integer.parseInt(manufactureCode));
		pstmt4.setInt(2, Integer.parseInt(unitTypeCode));
		pstmt4.setString(3, unitReferenceId);
		pstmt4.setString(4, STATUS);
		pstmt4.setString(5,predefinedMobileNum);
		pstmt4.setInt(6,transMode);
		pstmt4.setString(7, unitNumber.toUpperCase());
		pstmt4.setInt(8,systemId);
		updatecount = pstmt4.executeUpdate();
		if(updatecount>0){tableList.add("Update"+"##"+"ADMINISTRATOR.dbo.UNIT_MASTER");}
		if (updatecount == 1) {
			message = "<p  >Unit " + unitNumber	+ " updated successfully.</p>";
			try {
				pstmt5 = con.prepareStatement(AdminStatements.UPDATE_UNIT_TYPE_TO_VEHICLE_ASSOCIATION);
				pstmt5.setString(1, unitTypeCode);
				pstmt5.setString(2, unitNumber);
				pstmt5.setInt(3, systemId);
				int update = pstmt5.executeUpdate();
				con.commit();
				if (update > 0) {
					if(updatecount>0){tableList.add("Update"+"##"+"AMS.dbo.Vehicle_association");}
				System.out.println(" Success");
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		if(manufactureCode.equalsIgnoreCase("32") && (!predefinedMobileNum.isEmpty())){
			//pstmt2 = con.prepareStatement(AdminStatements.IS_UNIT_REGISTERED);
			//pstmt2.setString(1,unitNumber);
			//pstmt2.setInt(2, systemId);
			//rs2 = pstmt2.executeQuery();
		//	if(rs2.next())
			//{
				  pstmt5 = con.prepareStatement(AdminStatements.UPDATE_SIM_NUMBER_BASED_ON_UNIT_IN_ADMINISTRATOR);
				  pstmt5.setString(1, predefinedMobileNum);
				  pstmt5.setString(2, unitNumber.toUpperCase());
				  pstmt5.setInt(3, systemId);
				  pstmt5.executeUpdate();
				  
                pstmt5 = con.prepareStatement(AdminStatements.UPDATE_SIM_NUMBER_BASED_ON_UNIT_IN_AMS);
                pstmt5.setString(1, predefinedMobileNum);
                pstmt5.setString(2, unitNumber.toUpperCase());
                pstmt5.setInt(3, systemId);
                pstmt5.executeUpdate();
                con.commit();
                tableList.add("Update"+"##"+"ADMINISTRATOR.dbo.UNIT_MASTER");
                tableList.add("Update"+"##"+"AMS.dbo.Unit_Master");
			//}
			//if(rs2!=null)
			//rs2.close();
		}
		try {
			cf.insertDataIntoAuditLogReport(sessionId, tableList, pageName, "MODIFY", userId, serverName, systemId, 0,"Updated Unit Details");
		} catch (Exception e) {
			e.printStackTrace();
		}
	} catch (Exception e) {
		if (con!=null) {
			try {
				con.rollback();
			} catch (SQLException e1) {
				e1.printStackTrace();
			}
		}
		e.printStackTrace();
		message = "<p  >Error While Updating Unit and the Error is "
			+ e.toString() + "</p>";
		System.out.println("Error in unitDetailsUpdate method..  " + e);

	} finally {
		DBConnection.releaseConnectionToDB(con, pstmt4, null);
		DBConnection.releaseConnectionToDB(null, pstmt2, rs2);
		DBConnection.releaseConnectionToDB(null, pstmt5, null);
	}

	return message;
}

public String unitDetailsDelete(String unitNumber, int systemId,String STATUS,String pageName,String sessionId,String serverName,int userId) {
	int deleteunit = 0;
	Connection con = null;
	PreparedStatement pstmt7 = null;
	ResultSet rs7 = null;
	ArrayList<String> tableList=new ArrayList<String>();
	try{
		con=DBConnection.getConnectionToDB("AMS");
		con.setAutoCommit(false);
		
		pstmt7 = con.prepareStatement(AdminStatements.CKECK_UNIT_VEHICLE_ASSOC);
		pstmt7.setString(1, unitNumber.toUpperCase());
		pstmt7.setInt(2, systemId);
		rs7 = pstmt7.executeQuery();
		if (rs7.next()) {
			message = "<p  >Unit Number " + unitNumber
			+ " is associated to a vehicle. Can't be deleted.</p>";
			 return(message);
		} else {
			pstmt7 = con.prepareStatement(AdminStatements.DELETE_UNIT);
			pstmt7.setString(1, unitNumber);
			//pstmt7.setInt(2,systemId);
			deleteunit = pstmt7.executeUpdate();
			pstmt7 = con.prepareStatement(AdminStatements.DELETE_UNIT_FROM_ADMINSDB);
			pstmt7.setString(1, unitNumber);
			//pstmt7.setInt(2,systemId);
			deleteunit = pstmt7.executeUpdate();
			con.commit();
			if (deleteunit == 1) {
				message = "<p  >Unit Number " + unitNumber
				+ " deleted successfully.</p>";
				tableList.add("Delete"+"##"+"ADMINISTRATOR.dbo.UNIT_MASTER");
			}
		}
		try {
			cf.insertDataIntoAuditLogReport(sessionId, tableList, pageName, "DELETE", userId, serverName, systemId, 0,"Deleted Unit Details");
		} catch (Exception e) {
			e.printStackTrace();
		}
	} catch (Exception e) {
		if (con!=null) {
			try {
				con.rollback();
			} catch (SQLException e1) {
				e1.printStackTrace();
			}
		message = "<p  >Error While Deleting Unit and the Error is "
			+ e.toString() + "</p>";
		}
	} finally {
		DBConnection.releaseConnectionToDB(con, pstmt7, rs7);
	}
	return message;
}


/*****************************************************************simDetails***************************************************/	
public ArrayList<Object> getSimDetails(int systemId,int offset) {
	JSONArray JsonArray = new JSONArray();
	JSONObject JsonObject = null;
	Connection con = null;
	PreparedStatement pstmt1 = null;
	ResultSet rs1 = null;
	ArrayList < Object > arlist = new ArrayList < Object > ();
	try {
		int count = 0;
		con = DBConnection.getConnectionToDB("AMS");
		pstmt1= con.prepareStatement(AdminStatements.GET_ALL_SIM_DETAILS);
		pstmt1.setInt(1, offset);
		pstmt1.setInt(2, offset);
		pstmt1.setInt(3, systemId);
		rs1 = pstmt1.executeQuery();
		while (rs1.next()) {
			JsonObject = new JSONObject();
			ArrayList < Object > getSimList = new ArrayList < Object > ();
			count++;

			getSimList.add(count);
			JsonObject.put("slnoIndex", count);

			JsonObject.put("simNo", rs1.getString("mobile_no").toUpperCase());
			getSimList.add(rs1.getString("mobile_no").toUpperCase());

			JsonObject.put("serviceProvider", rs1.getString("service_provider").toUpperCase());
			getSimList.add(rs1.getString("service_provider").toUpperCase());


			if (rs1.getString("created_date") == null || rs1.getString("created_date").equals("") || rs1.getString("created_date").contains("1900")) {
				JsonObject.put("validateStartDate", "");
				getSimList.add("");
			} else {
				JsonObject.put("validateStartDate", sdfddmmyyyy.format(rs1.getTimestamp("created_date")));
				getSimList.add(sdfddmmyyyy.format(rs1.getTimestamp("created_date")));
			}

			JsonObject.put("simNumberDataIndex", rs1.getString("Sim_Number").toUpperCase());
			getSimList.add(rs1.getString("Sim_Number").toUpperCase());
            
			
			if (rs1.getString("STATUS") == null || rs1.getString("STATUS").equals("") || rs1.getString("STATUS").contains("1900")) {
				JsonObject.put("Status", "");
				getSimList.add("");
			} else {
				JsonObject.put("Status",rs1.getString("STATUS"));
				getSimList.add(rs1.getString("STATUS").toUpperCase());
			}
			
            if (rs1.getString("VALIDITY_START") == null || rs1.getString("VALIDITY_START").equals("") || rs1.getString("VALIDITY_START").contains("1900")) {
                JsonObject.put("validityStartDate", "");
                getSimList.add("");
            } else {
                JsonObject.put("validityStartDate", sdfyyyymmddhhmmss.format(rs1.getTimestamp("VALIDITY_START")));
                getSimList.add(sdfyyyymmddhhmmss.format(rs1.getTimestamp("VALIDITY_START")));
            }

            if (rs1.getString("VALIDITY_END") == null || rs1.getString("VALIDITY_END").equals("") || rs1.getString("VALIDITY_END").contains("1900")) {
                JsonObject.put("validityEndDate", "");
                getSimList.add("");
            } else {
                JsonObject.put("validityEndDate", sdfyyyymmddhhmmss.format(rs1.getTimestamp("VALIDITY_END")));
                getSimList.add(sdfyyyymmddhhmmss.format(rs1.getTimestamp("VALIDITY_END")));
            }
			JsonArray.put(JsonObject);

		}
		arlist.add(JsonArray);
	} catch (Exception e) {
		e.printStackTrace();
	}finally {

		DBConnection.releaseConnectionToDB(con, pstmt1, rs1);
	}

	return arlist;
}
public String simDetailsInsert(String mobileNumber, String serviceProvider,String simNumber,String STATUS,int userId,int systemId,String validityStartDate,
		String validityEndDate,int offset,String pageName,String sessionId,String serverName) {
	Connection con = null;
	PreparedStatement pstmt4 = null;
	ResultSet rs4 = null;
	ArrayList<String> tableList=new ArrayList<String>();
	 
	try {
		int simInsertcount = 0;
		con = DBConnection.getConnectionToDB("AMS");
		pstmt4 = con.prepareStatement(AdminStatements.SELECT_MOBILE_NO_VALIDATE);
		pstmt4.setString(1,mobileNumber.toUpperCase());
		rs4 = pstmt4.executeQuery();
		if (rs4.next()) {
			message = "<p>Mobile Number already exists.Try some other Mobile Number.</p>";
			return (message);
		}
		
	/*	pstmt4 = con.prepareStatement(AdminStatements.INSERT_SIM);
		pstmt4.setString(1, mobileNumber.toUpperCase());
		pstmt4.setString(2, serviceProvider.toUpperCase());
		pstmt4.setInt(3, systemId);
		pstmt4.setString(4, simNumber);
		pstmt4.setInt(5, offset);
		pstmt4.setString(6, validityStartDate);
	    pstmt4.setInt(7, offset);
		pstmt4.setString(8, validityEndDate);
		simInsertcount = pstmt4.executeUpdate();*/
		
		pstmt4 = con.prepareStatement(AdminStatements.INSERT_SIM_ADMINSTRATOR);
		pstmt4.setString(1, mobileNumber.toUpperCase());
		pstmt4.setString(2, serviceProvider.toUpperCase());
		pstmt4.setInt(3, userId);
		pstmt4.setInt(4, systemId);
		pstmt4.setString(5, simNumber);
		pstmt4.setString(6, STATUS.trim());
		pstmt4.setInt(7, offset);
		pstmt4.setString(8, validityStartDate);
		pstmt4.setInt(9, offset);
		pstmt4.setString(10, validityEndDate);
		simInsertcount = pstmt4.executeUpdate();
		if (simInsertcount == 1) {
			message = "<p  >Mobile Number " + mobileNumber.toUpperCase()
			+ " Added Successfully</p>";
			tableList.add("Insert"+"##"+"ADMINISTRATOR.dbo.SIM_MASTER");
		}
		try {
			cf.insertDataIntoAuditLogReport(sessionId, tableList, pageName, "ADD", userId, serverName, systemId, 0,"Added Sim Details");
		} catch (Exception e) {
			e.printStackTrace();
		}
	} catch (Exception e) {
		message = "<p>Error While Adding Sim and the Error is "
			+ e.toString() + "</p>";
	System.out.println("Error in  simInsert() method " + e);
	e.printStackTrace();
		e.printStackTrace();
	}finally {
		DBConnection.releaseConnectionToDB(con, pstmt4, rs4);
	}
	return message;
}

public String saveSimDetails(int systemId,int userId,JSONArray simJs,int offset){
	Connection con = null;
	PreparedStatement pstmt = null;
	int simInsertcount=0;
	String message="";
	try{
		SimpleDateFormat dateFormat1 = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		SimpleDateFormat dateFormat2 = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss"); 
		
		con = DBConnection.getConnectionToDB("AMS");
		for(int i=0;i<simJs.length();i++){
			JSONObject obj = simJs.getJSONObject(i);
			if(obj.getString("importsimstatusindex").equalsIgnoreCase("Valid")){
			pstmt = con.prepareStatement(AdminStatements.INSERT_SIM_ADMINSTRATOR);
			pstmt.setString(1, obj.getString("importmobilenumberindex").toUpperCase());
			pstmt.setString(2, obj.getString("importserviceproviderindex").toUpperCase());
			pstmt.setInt(3, userId);
			pstmt.setInt(4, systemId);
			pstmt.setString(5, obj.getString("importsimnumberindex"));
			pstmt.setString(6, "ACTIVE");
			pstmt.setInt(7, offset);
			if(!obj.getString("importsimvaliditystartdateindex").equals(""))
				pstmt.setString(8,dateFormat1.format(dateFormat2.parse(obj.getString("importsimvaliditystartdateindex"))));
			else
				pstmt.setString(8,"");
			pstmt.setInt(9, offset);
			if(!obj.getString("importsimvalidityenddateindex").equals(""))
				pstmt.setString(10, dateFormat1.format(dateFormat2.parse(obj.getString("importsimvalidityenddateindex"))));
			else
				pstmt.setString(10,"");
			simInsertcount = pstmt.executeUpdate();
		  }
		}
		if (simInsertcount == 1) {
			message = "<p  >All Valid Mobile Number  Added Successfully</p>";
		}
	}catch (Exception e) {
		e.printStackTrace();
	}
	finally {
		DBConnection.releaseConnectionToDB(con, pstmt, null);
	}
	return message;
}

public String simDetailsUpdate(String mobileNumber, String serviceProvider,String simNumber,String STATUS,int userId, int systemId,String validityStartDate,
		String validityEndDate,int offset,String pageName,String sessionId,String serverName) {
	
	int simupdatecount = 0;
	Connection con = null;
	PreparedStatement pstmt11 = null;
	PreparedStatement pstmt12 = null;
	ResultSet rs11 = null;
	ResultSet rs12 = null;
	ArrayList<String> tableList=new ArrayList<String>();
	try {
		con = DBConnection.getConnectionToDB("AMS");
		STATUS=STATUS.trim();
		if(STATUS.equals("INACTIVE"))
		{
			pstmt12 = con.prepareStatement(AdminStatements.SELECT_MOBILE_NO_VALIDATE_IN_UNIT);
			pstmt12.setString(1, mobileNumber.toUpperCase());
			pstmt12.setInt(2, systemId);
			rs12 = pstmt12.executeQuery();
			if(rs12.next())
			{
	        	   message = "<p  >Mobile Number "
	      				+ mobileNumber.toUpperCase()
	      				+ " Is Associated To Unit. Make It Active To Modify.</p>";
	      		  return message;

			}
		}
			/*	pstmt11 = con.prepareStatement(AdminStatements.UPDATE_SIM_DETAILS);
				pstmt11.setString(1, serviceProvider.toUpperCase());
				pstmt11.setString(2, simNumber);
				pstmt11.setInt(3, offset);
				pstmt11.setString(4, validityStartDate);
				pstmt11.setInt(5, offset);
				pstmt11.setString(6, validityEndDate);
				pstmt11.setString(7, mobileNumber);
				pstmt11.setInt(8,systemId);
				simupdatecount = pstmt11.executeUpdate();*/
				
				pstmt11 = con.prepareStatement(AdminStatements.UPDATE_SIM_DETAILS_ADMINSTRATOR);
				pstmt11.setString(1, serviceProvider.toUpperCase());
				pstmt11.setString(2, simNumber);
				pstmt11.setString(3,STATUS);
				pstmt11.setInt(4, offset);
				pstmt11.setString(5, validityStartDate);
				pstmt11.setInt(6, offset);
				pstmt11.setString(7, validityEndDate);
				pstmt11.setString(8, mobileNumber);
				pstmt11.setInt(9,systemId);
				simupdatecount = pstmt11.executeUpdate();
		         if (simupdatecount == 1) {
			         message = "<p>Mobile Number " + mobileNumber + " Updated Successfully.</p>";
			         tableList.add("Update"+"##"+"ADMINISTRATOR.dbo.SIM_MASTER");
		        }
		         try {
					cf.insertDataIntoAuditLogReport(sessionId, tableList, pageName, "MODIFY", userId, serverName, systemId, 0,"Updated Sim Details");
				} catch (Exception e) {
					// TODO: handle exception
				}
		
	} catch (Exception e) {
		e.printStackTrace();
		message = "<p  >Error While Updating Sim and the Error is "
			+ e.toString() + "</p>";
	System.out.println("Exception " + e);
	} finally {
		DBConnection.releaseConnectionToDB(con, pstmt11, rs11);
		DBConnection.releaseConnectionToDB(null, pstmt12, rs12);
	}

	return message;
 }
public String simDetailsDelete(String mobileNumber, int systemId,String pageName,String sessionId,String serverName,int userId) {
	int deletesim = 0;
	Connection con = null;
	PreparedStatement pstmt9 = null;
	ResultSet rs9 = null;
	ArrayList<String> tableList=new ArrayList<String>();
	try {
		con=DBConnection.getConnectionToDB("AMS");
		pstmt9 = con.prepareStatement(AdminStatements.SELECT_MOBILE_NO_VALIDATE_IN_UNIT);
		pstmt9.setString(1, mobileNumber.toUpperCase());
		pstmt9.setInt(2, systemId);
		rs9 = pstmt9.executeQuery();
		if (rs9.next()) {
			message = "<p  >Mobile Number "
				+ mobileNumber.toUpperCase()
				+ " has unit associated to it.Try after unassociating unit.</p>";
		return (message);
		} else {

		/*	pstmt9 = con.prepareStatement(AdminStatements.DELETE_MOBILENO_IN_AMS);
			pstmt9.setString(1, mobileNumber.toUpperCase());
			//pstmt9.setInt(2,systemId);
			deletesim = pstmt9.executeUpdate(); */
			pstmt9 = con.prepareStatement(AdminStatements.DELETE_MOBILENO_IN_ADMINSTRATOR);
			pstmt9.setString(1, mobileNumber.toUpperCase());
			//pstmt9.setInt(2,systemId);
			deletesim = pstmt9.executeUpdate();
			if (deletesim == 1) {
				message = "<p  >Mobile Number " + mobileNumber
				+ " deleted successfully.</p>";
				tableList.add("Delete"+"##"+"ADMINISTRATOR.dbo.SIM_MASTER");
			}
		}
		try {
			cf.insertDataIntoAuditLogReport(sessionId, tableList, pageName, "DELETE", userId, serverName, systemId, 0,"Deleted Sim Details");
		} catch (Exception e) {
			// TODO: handle exception
		}
	} catch (Exception e) {
		message = "<p  >Error While Deleting Sim and the Error is "
			+ e.toString() + "</p>";
	System.out.println("Error in simDelete() method" + e);
	e.printStackTrace();
	} finally {
		DBConnection.releaseConnectionToDB(con, pstmt9, rs9);
	}
	return message;
}

//******************************************************************USER ASSET GROUP ASSOCIATION*************************************************************//		 

public JSONArray getUsersBasedOnCustomer(int systemId, int custId) {
    JSONArray JsonArray = null;
    JSONObject JsonObject = null;
    Connection con = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    try {
        JsonArray = new JSONArray();
        con = DBConnection.getConnectionToDB("ADMINISTRATOR");
        pstmt = con.prepareStatement(AdminStatements.GET_USERS);
        pstmt.setInt(1, custId);
        pstmt.setInt(2, systemId);
        rs = pstmt.executeQuery();
        while (rs.next()) {
            JsonObject = new JSONObject();
            JsonObject.put("userId", rs.getInt("User_id"));
            JsonObject.put("userName", rs.getString("User_Name"));
            JsonArray.put(JsonObject);
        }
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        DBConnection.releaseConnectionToDB(con, pstmt, rs);
    }
    return JsonArray;
}		 
	 
 public ArrayList < Object > getDataForNonAssociation(int customerId, int systemId, int userId) {
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
             pstmt = con.prepareStatement(AdminStatements.GET_NON_ASSOCIATION_DATA);
             pstmt.setInt(1, customerId);
             pstmt.setInt(2, systemId);
             pstmt.setInt(3, userId);
             pstmt.setInt(4, systemId);
             rs = pstmt.executeQuery();
         } else {
             pstmt = con.prepareStatement(AdminStatements.GET_NON_ASSOCIATION_DATA_FOR_LTSP_USERS);
             pstmt.setInt(1, systemId);
             pstmt.setInt(2, userId);
             pstmt.setInt(3, systemId);
             rs = pstmt.executeQuery();
         }
         while (rs.next()) {
             JsonObject = new JSONObject();
             count++;
             JsonObject.put("slnoIndex", count);
             JsonObject.put("groupNameDataIndex", rs.getString("GROUP_NAME"));
             JsonObject.put("custNameDataIndex", rs.getString("CUSTOMER_NAME"));
             JsonObject.put("groupIdDataIndex", rs.getString("GROUP_ID"));
             JsonObject.put("custIdDataIndex", rs.getString("CUSTOMER_ID"));
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
 
 
 public ArrayList < Object > getDataForAssociation(int customerId, int systemId, int userId) {
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
             pstmt = con.prepareStatement(AdminStatements.GET_ASSOCIATION_DATA);
             pstmt.setInt(1, userId);
             pstmt.setInt(2, systemId);
             pstmt.setInt(3, customerId);
             rs = pstmt.executeQuery();
         } else {
             pstmt = con.prepareStatement(AdminStatements.GET_ASSOCIATION_DATA_FOR_LTSP_USERS);
             pstmt.setInt(1, userId);
             pstmt.setInt(2, systemId);
             rs = pstmt.executeQuery();
         }
         while (rs.next()) {
             JsonObject = new JSONObject();
             count++;
             JsonObject.put("slnoIndex2", count);
             JsonObject.put("groupNameDataIndex2", rs.getString("GROUP_NAME"));
             JsonObject.put("groupIdDataIndex2", rs.getInt("GROUP_ID"));
             JsonObject.put("custNameDataIndex2", rs.getString("CUSTOMER_NAME"));
             JsonObject.put("custIdDataIndex2", rs.getString("CUSTOMER_ID"));
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
 
	 
	public String associateGroup(int customerId, int systemId, int userIdFromJsp, JSONArray js,int userId,String pageName,String sessionId,String serverName) {
	    Connection con = null;
	    PreparedStatement pstmt = null;
	    PreparedStatement pstmt2 = null;
	    PreparedStatement pstmt3 = null;
	    ResultSet rs = null;
	    ResultSet rs1 = null;
	    String message = "";
	    ArrayList < String > vehicleList = new ArrayList < String > ();
	    ArrayList<String> tableList=new ArrayList<String>();
	    try {
	        con = DBConnection.getConnectionToDB("AMS");
	        con.setAutoCommit(false);
	        for (int i = 0; i < js.length(); i++) {
	            vehicleList.clear();
	            JSONObject obj = js.getJSONObject(i);
	            String groupId = obj.getString("groupIdDataIndex");
	            String custId = obj.getString("custIdDataIndex");
	            
	            pstmt2 = con.prepareStatement(AdminStatements.CHECK_IF_PRESENT);
	            pstmt2.setInt(1, userIdFromJsp);
	            pstmt2.setString(2, groupId);
	            pstmt2.setInt(3, systemId);
	            rs1 = pstmt2.executeQuery();
	            if (!rs1.next()) {
	                pstmt3 = con.prepareStatement(AdminStatements.INSERT_INTO_USER_ASSET_GROUP_ASSOCIATION);
	                pstmt3.setInt(1, userIdFromJsp);
	                pstmt3.setString(2, groupId);
	                pstmt3.setInt(3, systemId);
	                pstmt3.setInt(4, userId);
	                int up=pstmt3.executeUpdate();
	            }
	            if(customerId !=0)
	            {
			        pstmt = con.prepareStatement(AdminStatements.INSERT_VEHICLES_TO_INTO_VEHICLE_USER_FOR_CLIENT_USERS.replace("#", userIdFromJsp+","+systemId)); 
		            pstmt.setInt(1, systemId);
		            pstmt.setInt(2, Integer.parseInt(custId));
		            pstmt.setString(3, groupId);
		            pstmt.setInt(4, userIdFromJsp);
		            pstmt.setInt(5, systemId);
		            int up1=pstmt.executeUpdate();
		           
	            }else
	            {
	            	pstmt = con.prepareStatement(AdminStatements.INSERT_VEHICLES_TO_INTO_VEHICLE_USER_FOR_LTSP.replace("#", userIdFromJsp+","+systemId)); 
		            pstmt.setInt(1, systemId);
		            pstmt.setInt(2, Integer.parseInt(custId));
		            pstmt.setString(3, groupId);
		            pstmt.setInt(4, userIdFromJsp);
		            pstmt.setInt(5, systemId);
		            int up1=pstmt.executeUpdate();
	            }
	        }
	        tableList.add("Insert"+"##"+"ADMINISTRATOR.dbo.USER_ASSET_GROUP_ASSOCIATION");
	        tableList.add("Insert"+"##"+"AMS.dbo.Vehicle_User");
	        try {
	        	cf.insertDataIntoAuditLogReport(sessionId, tableList, pageName, "Associate", userId, serverName, systemId,customerId,"Associated Asset Group to User");
			} catch (Exception e) {
				e.printStackTrace();
			}
	        
	        con.commit();
	        message = "Associated Successfully.";
	    } catch (Exception e) {
	        e.printStackTrace();
	        try {
	            if (con != null)
	                con.rollback();
	        } catch (Exception ex) {
	            ex.printStackTrace();
	        }
	    } finally {
	        DBConnection.releaseConnectionToDB(con, pstmt, rs);
	        DBConnection.releaseConnectionToDB(null, pstmt2, rs1);
	        DBConnection.releaseConnectionToDB(null, pstmt3, null);
	    }
	    return message;
	}
	
	public String dissociateGroup(int customerId, int systemId, int userIdFromJsp, JSONArray js,int userId,String pageName,String sessionId,String serverName) {
	    Connection con = null;
	    PreparedStatement pstmt1 = null;
	    PreparedStatement pstmt2 = null;
	    PreparedStatement pstmt3 = null;
	    PreparedStatement pstmt = null;
	    String message = "";
	    ArrayList<String> tableList=new ArrayList<String>();
	    try {
	        con = DBConnection.getConnectionToDB("AMS");
	        con.setAutoCommit(false);
	        for (int i = 0; i < js.length(); i++) {
	            JSONObject obj = js.getJSONObject(i);
	            String groupId = obj.getString("groupIdDataIndex2");
	            String custId = obj.getString("custIdDataIndex2");
	            
	            pstmt = con.prepareStatement(AdminStatements.MOVE_DATA_TO_USER_ASSET_GROUP_ASSOCIATION_HISTORY);
	            pstmt.setInt(1, userId);
	            pstmt.setInt(2, userIdFromJsp);
	            pstmt.setString(3, groupId);
	            pstmt.setInt(4, systemId);
	            int inserted1 =pstmt.executeUpdate();
	            if(inserted1 > 0)
	            {
	            	tableList.add("Insert"+"##"+"ADMINISTRATOR.dbo.USER_ASSET_GROUP_ASSOCIATION_HISTORY");
		            pstmt2 = con.prepareStatement(AdminStatements.DELETE_FROM_USER_ASSET_GROUP_ASSOCIATION);
		            pstmt2.setInt(1, userIdFromJsp);
		            pstmt2.setString(2, groupId);
		            pstmt2.setInt(3, systemId);
		            int up1=pstmt2.executeUpdate();
		            if(up1>0){tableList.add("Delete"+"##"+"ADMINISTRATOR.dbo.USER_ASSET_GROUP_ASSOCIATION");}
	            }
	            
	            pstmt1 = con.prepareStatement(AdminStatements.MOVE_DATA_FROM_VEHICLE_USER_TO_VEHICLE_USER_HISTORY);
	            pstmt1.setString(1, groupId);
	            pstmt1.setInt(2, Integer.parseInt(custId));
	            pstmt1.setInt(3, systemId);
	            pstmt1.setInt(4, userIdFromJsp);
	            pstmt1.setInt(5, systemId);
	            int inserted = pstmt1.executeUpdate();
	            
	            if (inserted > 0) {
	            	tableList.add("Insert"+"##"+"AMS.dbo.Vehicle_User_Hist");
                    pstmt3 = con.prepareStatement(AdminStatements.DELETE_DATA_FROM_VEHICLE_USERS);
                    pstmt3.setString(1, groupId);
	                pstmt3.setInt(2, Integer.parseInt(custId));
	                pstmt3.setInt(3, systemId);
	                pstmt3.setInt(4, userIdFromJsp);
                    pstmt3.setInt(5, systemId);
                    int up2=pstmt3.executeUpdate();
                    if(up2>0){tableList.add("Delete"+"##"+"AMS.dbo.Vehicle_User");}
                }
	        }
	        con.commit();
	        try {
	        	cf.insertDataIntoAuditLogReport(sessionId, tableList, pageName, "Disassociate", userId, serverName, systemId,customerId,"Disassociated Asset Group");
			} catch (Exception e) {
				e.printStackTrace();
			}
	        
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
	        DBConnection.releaseConnectionToDB(con, pstmt1, null);
	        DBConnection.releaseConnectionToDB(null, pstmt3, null);
	        DBConnection.releaseConnectionToDB(null, pstmt2, null);
	        DBConnection.releaseConnectionToDB(null, pstmt, null);
	    }
	    return message;
	}
	
	
		
//******************************************************OWNER MASTER FUNCTIONS*******************************************************************************************************************//		
		public ArrayList < Object > getOwnerMasterReport(int systemId, int customerId) {
		    JSONArray JsonArray = new JSONArray();
		    JSONObject JsonObject = null;
		    Connection con = null;
		    PreparedStatement pstmt = null;
		    ResultSet rs = null;
		    ArrayList < Object > finlist = new ArrayList < Object > ();
		    try {
		        int count = 0;
		        con = DBConnection.getConnectionToDB("ADMINISTRATOR");
		        pstmt = con.prepareStatement(AdminStatements.GET_OWNER_MASTER_REPORT);
		        pstmt.setInt(1, systemId);
		        pstmt.setInt(2, customerId);
		        rs = pstmt.executeQuery();
		        while (rs.next()) {
		            JsonObject = new JSONObject();
		            count++;
		            JsonObject.put("slnoIndex", count);
		            JsonObject.put("firstNameAndLastNameDataIndex", rs.getString("OWNERNAME").toUpperCase());
		            JsonObject.put("firstNameDataIndex", rs.getString("FirstName").toUpperCase());
		            JsonObject.put("lastNameDataIndex", rs.getString("LASTNAME").toUpperCase());
		            JsonObject.put("addressDataIndex", rs.getString("ADDRESS"));
		            JsonObject.put("emailIdDataIndex", rs.getString("EMAILID"));
		            JsonObject.put("phoneNoDataIndex", rs.getString("PHONENO"));
		            JsonObject.put("landLineNoDataIndex", rs.getString("LANDLINENO"));
		            JsonObject.put("idDataIndex", rs.getInt("ID"));
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
		
		public String insertOwnerInformation(int custId, String firstName, String lastName, String address, String emailId, String phoneNo, String landlineNo, int systemId, int userId) {
		    Connection con = null;
		    PreparedStatement pstmt = null;
		    ResultSet rs = null;
		    String message = "";
		    try {
		        con = DBConnection.getConnectionToDB("ADMINISTRATOR");
		        pstmt = con.prepareStatement(AdminStatements.INSERT_OWNER_INFORMATION);
		        pstmt.setString(1, firstName.toUpperCase());
		        pstmt.setString(2, lastName.toUpperCase());
		        pstmt.setString(3, address);
		        pstmt.setString(4, emailId);
		        pstmt.setString(5, phoneNo);
		        pstmt.setString(6, landlineNo);
		        pstmt.setInt(7, systemId);
		        pstmt.setInt(8, custId);
		        pstmt.setInt(9, userId);
		        int inserted = pstmt.executeUpdate();
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
		
		public String modifyOwnerInformation(int custId, String firstName, String lastName, String address, String emailId, String phoneNo, String landlineNo, int systemId, int id) {
		    Connection con = null;
		    PreparedStatement pstmt = null;
		    PreparedStatement pstmt1 = null;
		    PreparedStatement pstmt2 = null;
		    PreparedStatement pstmt3 = null;
		    String message = "";
		    try {
		        con = DBConnection.getConnectionToDB("ADMINISTRATOR");
		        con.setAutoCommit(false);
		        pstmt = con.prepareStatement(AdminStatements.UPDATE_OWNER_INFORMATION);
		        pstmt.setString(1, firstName.toUpperCase());
		        pstmt.setString(2, lastName.toUpperCase());
		        pstmt.setString(3, address);
		        pstmt.setString(4, emailId);
		        pstmt.setString(5, phoneNo);
		        pstmt.setString(6, landlineNo);
		        pstmt.setInt(7, custId);
		        pstmt.setInt(8, systemId);
		        pstmt.setInt(9, id);
		        int updated = pstmt.executeUpdate();
		        if (updated > 0) {
		        	pstmt2 = con.prepareStatement(AdminStatements.UPDATE_DETAILS_IN_VEHICLE_MASTER);
		        	pstmt2.setString(1,firstName.toUpperCase()+" "+lastName.toUpperCase());
		        	pstmt2.setString(2,address );
		        	pstmt2.setString(3, phoneNo);
		        	pstmt2.setInt(4, id);
 		        	pstmt2.setInt(5, systemId);
		        	pstmt2.executeUpdate();
		        	
 		        	pstmt3 = con.prepareStatement(AdminStatements.UPDATE_DETAILS_IN_LIVE_VISION);
 					pstmt3.setString(1,firstName.toUpperCase()+" "+lastName.toUpperCase());
 				    pstmt3.setInt(2, systemId);
 				    pstmt3.setInt(3, systemId);
 				    pstmt3.setInt(4, id);
  				    pstmt3.executeUpdate();

		        }
		        message = "Updated Successfully";
		        con.commit();
		    } catch (Exception e) {
		        e.printStackTrace();
		        try {
		            if (con != null)
		                con.rollback();
		        } catch (Exception ex) {
		            ex.printStackTrace();
		        }
		    } finally {
		    	DBConnection.releaseConnectionToDB(null, pstmt1, null);
		        DBConnection.releaseConnectionToDB(null, pstmt2, null);
		        DBConnection.releaseConnectionToDB(con, pstmt, null);
		    }
		    return message;
		}
		
		public String deleteRecord(int custId, int systemId, int id) {
		    Connection con = null;
		    PreparedStatement pstmt = null;
		    PreparedStatement pstmt2 = null;
		    PreparedStatement pstmt3 = null;
		    String message = "";
		    try {
		        con = DBConnection.getConnectionToDB("ADMINISTRATOR");
		        con.setAutoCommit(false);
		        pstmt = con.prepareStatement(AdminStatements.DELETE_OWNER_INFORMATION);
		        pstmt.setInt(1, custId);
		        pstmt.setInt(2, systemId);
		        pstmt.setInt(3, id);
		        int inserted = pstmt.executeUpdate();
		        if (inserted > 0) {
 		        	pstmt3 = con.prepareStatement(AdminStatements.UPDATE_DETAILS_IN_LIVE_VISION);
 		        	pstmt3.setString(1, "");
 				    pstmt3.setInt(2, systemId);
 				    pstmt3.setInt(3, systemId);
 				    pstmt3.setInt(4, id);
  				    pstmt3.executeUpdate();

		        	pstmt2 = con.prepareStatement(AdminStatements.UPDATE_IN_VEHICLE_MASTER);
		        	pstmt2.setInt(1, id);
		        	pstmt2.setInt(2, systemId);
		        	pstmt2.executeUpdate();

		        }
		        message = "Deleted Successfully";
		        con.commit();
		    } catch (Exception e) {
		        e.printStackTrace();
		        try {
		            if (con != null)
		                con.rollback();
		        } catch (Exception ex) {
		            ex.printStackTrace();
		        }
		    } finally {
		        DBConnection.releaseConnectionToDB(null, pstmt, null);
		        DBConnection.releaseConnectionToDB(con, pstmt2, null);
		        DBConnection.releaseConnectionToDB(null, pstmt3, null);
		    }
		    return message;
		}
		
		/** Gets Asset document Details
		 * @param customerid
		 * @param systemId
		 * @return
		 */
		public JSONArray getAssetDocumentdetails(int customerid, int systemId,int userid) {
			JSONArray AssetGroupJsonArray = new JSONArray();
			JSONObject AssetGroupJsonObject = new JSONObject();
			Connection conAdmin = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			int count=0;
			try {
				AssetGroupJsonArray = new JSONArray();
				AssetGroupJsonObject = new JSONObject();
				conAdmin = DBConnection.getConnectionToDB("AMS");
				pstmt = conAdmin.prepareStatement(AdminStatements.GET_ALL_VEHICLES_DETAILS);
				pstmt.setInt(1,systemId);
				pstmt.setInt(2,customerid);
				pstmt.setInt(3,userid);
				
				rs = pstmt.executeQuery();
				while (rs.next()) {	
					//count++;
					AssetGroupJsonObject = new JSONObject();
					if(rs.getString("REGISTRATION_NO")!=null)
						
					{
					count++; 
					AssetGroupJsonObject.put("slnoIndex", count);
					AssetGroupJsonObject.put("assetNumber", rs.getString("REGISTRATION_NO"));
					AssetGroupJsonObject.put("assetModel", rs.getString("Asset_Model"));
					AssetGroupJsonObject.put("assetType", rs.getString("Asset_Type"));
					
					}
					AssetGroupJsonArray.put(AssetGroupJsonObject);
				}
			} catch (Exception e) {
				System.out.println("Error in Admin Functions:- getAssetGroupDetails "+e.toString());
			} finally {
				DBConnection.releaseConnectionToDB(conAdmin, pstmt, rs);
			}
			return AssetGroupJsonArray;
			
		
		}
		
		
		

		//******************************************************************DELETE ASSET DOCUMENT*************************************************************
		public String assetDocumentDelete(int customerId, String regNo,int systemId, String delImgFile, String category, String delImageId) {
			int deleteAsset = 0;
			Connection con = null;
			PreparedStatement pstmt = null;
			try {
				con=DBConnection.getConnectionToDB("AMS");
				pstmt = con.prepareStatement(AdminStatements.DELETE_UPLOADED_FILE);
				pstmt.setString(1, regNo);
				pstmt.setInt(2, systemId);
				pstmt.setInt(3, customerId);
				pstmt.setString(4, delImgFile);
				pstmt.setString(5, category);
				pstmt.setString(6, delImageId);
			    deleteAsset = pstmt.executeUpdate();
					if (deleteAsset == 1) {
						message = "Document "+ delImgFile +" has been deleted successfully.";
					}
			} catch (Exception e) {
				message = "<p  >Error while deleting document and the Error is "+ e.toString() + "</p>";
				System.out.println("Error in AssetDelete() method" + e);
				e.printStackTrace();
			} finally {
				DBConnection.releaseConnectionToDB(con, pstmt, null);
			}
			return message;
		}
		
		//*******************************************************MANAGE ASSET FUNCTIONS***************************************************************************************************************//		
		
		public JSONArray getAssetTypeDetails(int systemId, int userId) {
		    JSONArray JsonArray = null;
		    JSONObject JsonObject = null;
		    Connection con = null;
		    PreparedStatement pstmt = null;
		    ResultSet rs = null;
		    int count = 0;
		    try {
		        JsonArray = new JSONArray();
		        con = DBConnection.getConnectionToDB("AMS");
		        pstmt = con.prepareStatement(AdminStatements.GET_ASSET_TYPE_FOR_MANAGE_ASSET);
		        rs = pstmt.executeQuery();
		        while (rs.next()) {
		            count++;
		            JsonObject = new JSONObject();
		            JsonObject.put("AssetType", rs.getString("Category_name"));
		            JsonArray.put(JsonObject);
		        }
		    } catch (Exception e) {
		        e.printStackTrace();
		    } finally {
		        DBConnection.releaseConnectionToDB(con, pstmt, rs);
		    }
		    return JsonArray;
		}
		
		public JSONArray getAssetModelDetails(int systemId, int userId, int CustId) {
		    JSONArray JsonArray = null;
		    JSONObject JsonObject = null;
		    Connection con = null;
		    PreparedStatement pstmt = null;
		    ResultSet rs = null;
		    try {
		        JsonArray = new JSONArray();
		        con = DBConnection.getConnectionToDB("AMS");
		        pstmt = con.prepareStatement(AdminStatements.GET_ASSET_MODEL_NAMES);
		        pstmt.setInt(1, systemId);
		        rs = pstmt.executeQuery();
		        while (rs.next()) {
		            JsonObject = new JSONObject();
		            JsonObject.put("ModelName", rs.getString("ModelName"));
		            JsonObject.put("ModelTypeId", rs.getString("ModelTypeId"));
		            JsonArray.put(JsonObject);
		        }
		    } catch (Exception e) {
		        e.printStackTrace();
		    } finally {
		        DBConnection.releaseConnectionToDB(con, pstmt, rs);
		    }
		    return JsonArray;
		}
		
		public JSONArray getUnitNumber(int systemId, int userId, int customerId) {
		    JSONArray JsonArray = new JSONArray();
		    Connection con = null;
		    PreparedStatement pstmt = null;
		    ResultSet rs = null;
		    JSONObject obj1 = new JSONObject();
		    try {
		        con = DBConnection.getConnectionToDB("AMS");
		        pstmt = con.prepareStatement(AdminStatements.GET_UNIT_NUMBERS_FOR_MANAGE_ASSET);
		        pstmt.setInt(1, systemId);
		        pstmt.setInt(2, systemId);
		        rs = pstmt.executeQuery();
		        obj1.put("UnitNumber", "0");
		        obj1.put("UnitNumber", "None");
		        obj1.put("UnitNumberRef", "None");
		        JsonArray.put(obj1);
		        while (rs.next()) {
		            obj1 = new JSONObject();
		            if(rs.getString("UNIT_REFERENCE_ID")!=null && !rs.getString("UNIT_REFERENCE_ID").isEmpty()){
		            	obj1.put("UnitNumberRef", rs.getString("UNIT_NUMBER")+" - ("+rs.getString("UNIT_REFERENCE_ID")+")");
		            }else{
		            	obj1.put("UnitNumberRef", rs.getString("UNIT_NUMBER"));
		            }
		            obj1.put("UnitNumber", rs.getString("UNIT_NUMBER"));
		            obj1.put("UnitType", rs.getString("Unit_type_desc"));
		            obj1.put("Manufacturer", rs.getString("Manufacture_name"));
		            obj1.put("DeviceReferenceId", rs.getString("UNIT_REFERENCE_ID"));
		            obj1.put("ManufactureId",rs.getString("MANUFACTURE_ID"));
		            JsonArray.put(obj1);
		        }
		    } catch (Exception e) {
		        e.printStackTrace();
		    } finally {
		        DBConnection.releaseConnectionToDB(con, pstmt, rs);
		    }
		    return JsonArray;
		}
		
		public JSONArray getMobileNumber(int systemId, int userId) {
		    JSONArray JsonArray = null;
		    Connection con = null;
		    PreparedStatement pstmt = null;
		    ResultSet rs = null;
		    JSONObject obj1 = new JSONObject();
		    try {
		    	 JsonArray = new JSONArray();
		        con = DBConnection.getConnectionToDB("AMS");
		        pstmt = con.prepareStatement(AdminStatements.GET_MOBILE_NUMBERS_FOR_MANAGE_ASSET);
		        pstmt.setInt(1, systemId);
		        pstmt.setInt(2, systemId);
		        pstmt.setInt(3, systemId);
		        rs = pstmt.executeQuery();
		        obj1.put("MobileNumber", "0");
		        obj1.put("MobileNumber", "None");
		        JsonArray.put(obj1);
		        while (rs.next()) {
		            obj1 = new JSONObject();
		            obj1.put("MobileNumber", rs.getString("MOBILE_NUMBER"));
		            obj1.put("SimNumber", rs.getString("SIM_NUMBER"));
		            obj1.put("ServiceProvider", rs.getString("SERVICE_PROVIDER_NAME"));
		            obj1.put("IsPredefined", rs.getString("IS_PREDEFINED"));
		            JsonArray.put(obj1);
		        }
		       } catch (Exception e) {
		        e.printStackTrace();
		    } finally {
		        DBConnection.releaseConnectionToDB(con, pstmt, rs);
		    }
		    return JsonArray;
		}
		
		public JSONArray getGroupNameList(int systemId, int clientId, int userId) {
		    JSONArray JsonArray = null;
		    JSONObject JsonObject = null;
		    Connection con = null;
		    PreparedStatement pstmt = null;
		    ResultSet rs = null;
		    try {
		        JsonArray = new JSONArray();
		        con = DBConnection.getConnectionToDB("AMS");
		        pstmt = con.prepareStatement(AdminStatements.SELECT_GROUP_LIST_FOR_MANAGE_ASSET);
		        pstmt.setInt(1, systemId);
		        pstmt.setInt(2, clientId);
		        pstmt.setInt(3, userId);
		        rs = pstmt.executeQuery();
		        while (rs.next()) {
		            JsonObject = new JSONObject();
		            JsonObject.put("groupId", rs.getString("GROUP_ID"));
		            JsonObject.put("groupName", rs.getString("GROUP_NAME"));
		            JsonArray.put(JsonObject);
		        }
		    } catch (Exception e) {
		        e.printStackTrace();
		    } finally {
		        DBConnection.releaseConnectionToDB(con, pstmt, rs);
		    }
		    return JsonArray;
		}
		
		 public ArrayList < Object > getManageRegistrationReport(int systemId, int customerId, int userId, String language,int offset,String vehicleNo) {
	            JSONArray JsonArray = new JSONArray();
	            JSONObject JsonObject = null;
	            Connection con = null;
	            PreparedStatement pstmt = null;
	            ResultSet rs = null;
	            SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
	            ArrayList < Object > finlist = new ArrayList < Object > ();
	            try {
	                int count = 0;
	                con = DBConnection.getConnectionToDB("AMS");
	              
	                if(vehicleNo.equalsIgnoreCase(null) || vehicleNo==null ){
	                pstmt = con.prepareStatement(AdminStatements.GET_MANAGE_ASSET_REPORT+" order by a.RegistrationNo");
	                pstmt.setInt(1, offset);
	                pstmt.setInt(2, systemId);
	                pstmt.setInt(3, customerId);
	                pstmt.setInt(4, userId);
	                }
	                else{
	                pstmt = con.prepareStatement(AdminStatements.GET_MANAGE_ASSET_REPORT+" and a.RegistrationNo =? order by a.RegistrationNo ");
	               
	                pstmt.setInt(1, offset);
	                pstmt.setInt(2, systemId);
	                pstmt.setInt(3, customerId);
	                pstmt.setInt(4, userId);
	                pstmt.setString(5,vehicleNo.toUpperCase());
	                }
	                rs = pstmt.executeQuery();
		        while (rs.next()) {
		            JsonObject = new JSONObject();
		            count++;
		            if (rs.getString("MobileNo").equals("") || rs.getString("MobileNo").equals("None")) {
		                JsonObject.put("phoneNoDataIndex", "None");
		            } else {
		                JsonObject.put("phoneNoDataIndex", rs.getString("MobileNo"));
		            }
		            if (rs.getString("UnitNo").equals("") || rs.getString("UnitNo").equals("None")) {
		                JsonObject.put("unitNoDataIndex", "None");
		            } else {
		                JsonObject.put("unitNoDataIndex", rs.getString("UnitNo"));
		            }
		            JsonObject.put("slnoIndex", count);
		            JsonObject.put("registrationNumberDataIndex", rs.getString("VehicleNo").toUpperCase());
		            JsonObject.put("assetTypeDataIndex", rs.getString("AssetType"));
		            JsonObject.put("groupNameDataIndex", rs.getString("GroupName"));
		            JsonObject.put("assetModelDataIndex", rs.getString("Model"));
		            JsonObject.put("groupIdDataIndex", rs.getInt("GROUP_ID"));
		            JsonObject.put("ownerNameDataIndex", rs.getString("OWNER_NAME"));
		            JsonObject.put("ownerAddressDataIndex", rs.getString("OWNER_ADDRESS"));
		            JsonObject.put("ownerPhoneNoDataIndex", rs.getString("OWNER_PHONE_NO"));
		            JsonObject.put("assetIdDataIndex", rs.getString("VehicleAlias"));
		            JsonObject.put("modelTypeIdDataIndex", rs.getInt("ModelTypeId"));
		            JsonObject.put("manufactureIdDataIndex", rs.getString("MANUFACTURE_ID"));
		            
		            if (rs.getString("RegistrationDateTime") == null || rs.getString("RegistrationDateTime").equals("") || rs.getString("RegistrationDateTime").contains("1900")) {
		                JsonObject.put("registeredDateDataIndex", "");
		            } else {
		                JsonObject.put("registeredDateDataIndex", sdf.format(rs.getTimestamp("RegistrationDateTime")));
		            }
		            
		            if (rs.getString("Date") == null || rs.getString("Date").equals("") || rs.getString("Date").contains("1900")) {
		                JsonObject.put("associatedDateDataIndex", "");
		            } else {
		                JsonObject.put("associatedDateDataIndex", sdf.format(rs.getTimestamp("Date")));
		            }
		            
		            JsonObject.put("registeredByDataIndex", rs.getString("RegisteredBy"));
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
		
		public String registerNewVehicle(String assetType, String registrationNo, int groupId, String unitNo, String mobileNo, int systemId, int userId, 
				int offset, int CustID, String ltspName, String groupName, String custName, String assetModel, String ownerName, String ownerAddress,
				String ownerPhoneNo, String assetId, String zone, int ownerId, String SelectedCheckBox,String pageName,String sessionId,String serverName,int flag,String ownerEmailId) {
		    Connection con = null;
		    String message = "";
		    PreparedStatement pstmt = null;
		    ResultSet rs = null;
		    ResultSet rs2 = null;
		    PreparedStatement pstmt1 = null;
		    PreparedStatement pstmt2 = null;
		    PreparedStatement pstmt5 = null;
		    PreparedStatement pstmt6 = null;
		    SimpleDateFormat ddmmyyyy = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
		    ResultSet rs6 = null;
		    int i = 0;
		    String check="";
		    String date="";
		    ArrayList<String> tableList=new ArrayList<String>();
		    try {
		        /***********************************************************FOR REGISTRATION************************/
		        con = DBConnection.getConnectionToDB("AMS");
		        con.setAutoCommit(false);
		        /*Checks if the Vehicle status is active.If status is active,gives message vehicle already exists.*/
		        pstmt = con.prepareStatement(AdminStatements.CHECK_IF_VEHICLE_REGISTERED_AND_STATUS_IS_ACTIVE);
		        pstmt.setString(1, "Active");
		        pstmt.setString(2, registrationNo.replace(" ", ""));
//		        pstmt.setString(3, registrationNo.replace(" ", ""));
//		        pstmt.setString(4, registrationNo.replace(" ", ""));
		        rs = pstmt.executeQuery();
		        if (rs.next()) {
		            message = "Asset Already Exists";
		        } else {
		        	/* Checks if Subscription Details is Available ,If Available can checks for the validity of the Details
		        	 * 
		        	 */
		        	pstmt = con.prepareStatement(AdminStatements.CHECK_IF_LTSP_SUBSCRIPTION_DETAILS_FOR_SUBSCRIPTION_VALIDATION);
                    pstmt.setInt(1, systemId);
                    pstmt.setInt(2, CustID);
                    rs2 = pstmt.executeQuery();
	    		        if (rs2.next()){
	    		        	pstmt = con.prepareStatement(AdminStatements.SELECT_DETAILS_FROM_VEHICLE_SUBSCRIPTION_DETAILS);
	    		        	 pstmt.setString(1, registrationNo);
	    		        	 pstmt.setInt(2, systemId);
	    	                 pstmt.setInt(3, CustID);
	    	                 pstmt.setString(4, registrationNo);
	    		        	 pstmt.setInt(5, systemId);
	    	                 pstmt.setInt(6, CustID);
	    	                 rs = pstmt.executeQuery();
	    	 		        	if (rs.next()) {
	    	                	  if((rs.getString("validity")).equalsIgnoreCase("Invalid")){
	    	                		  message = "Subscription Renewal should be done for this Vehicle to manipulate data";
	    	                		  return message;
	    	                	  			}
	    	                	  
		    	 		        		} else {
		
								pstmt = con.prepareStatement(AdminStatements.INSERT_INTO_VEHICLE_SUBSCRIPTION_DETAILS);
								pstmt.setInt(1, systemId);
								pstmt.setInt(2, CustID);
								pstmt.setInt(3, userId);
								pstmt.setString(4, registrationNo);
								pstmt.setInt(5, offset);
								pstmt.setInt(6, rs2.getInt("SUBSCRIPTION_DURATION"));
								pstmt.setInt(7, offset);
								pstmt.setDouble(8, rs2.getDouble("AMOUNT_PER_MONTH")* rs2.getDouble("SUBSCRIPTION_DURATION"));
								pstmt.setString(9, rs2.getString("SUBSCRIPTION_DURATION"));
								pstmt.setInt(10, userId);
								pstmt.setInt(11, offset);
								pstmt.setInt(12, rs2.getInt("SUBSCRIPTION_DURATION"));
								pstmt.setInt(13, offset);
								pstmt.executeUpdate();
		
							}
	    		    }
		        	
		        	/*Checks if Vehicle present and status is Inactive.If inactive updates the status to active*/
		            pstmt2 = con.prepareStatement(AdminStatements.CHECK_IF_VEHICLE_REGISTERED_AND_STATUS_IS_INACTIVE);
		            pstmt2.setString(1, "Inactive");
		          //  pstmt2.setInt(2, systemId);
		            pstmt2.setString(2, registrationNo.replace(" ", ""));
//		            pstmt2.setString(3, registrationNo.replace(" ", ""));
//		            pstmt2.setString(4, registrationNo.replace(" ", ""));
		            rs = pstmt2.executeQuery();
		            if (rs.next()) {
		                pstmt2 = con.prepareStatement(AdminStatements.UPDATE_VEHICLE_STATUS_TO_ACTIVE);
		                pstmt2.setString(1, "Active");
		                pstmt2.setInt(2, offset);
		                pstmt2.setString(3, null);
		                pstmt2.setInt(4, userId);
		                pstmt2.setString(5, null);
		                pstmt2.setInt(6, systemId);
		                pstmt2.setString(7, registrationNo);
		                pstmt2.setString(8, null);
		                pstmt2.setString(9, rs.getString("registrationNo"));
		                i = pstmt2.executeUpdate();
		                if(i>0){tableList.add("Update"+"##"+"AMS.dbo.VehicleRegistration");}
		            } else {
		                pstmt = con.prepareStatement(AdminStatements.REGISTER_NEW_VEHICLE_IN_VEHICLE_REGISTRATION);
		                pstmt.setString(1, registrationNo);
		                pstmt.setInt(2, offset);
		                pstmt.setInt(3, systemId);
		                pstmt.setString(4, "Active");
		                pstmt.setInt(5, userId);
		                i = pstmt.executeUpdate();
		                if(i>0){tableList.add("Insert"+"##"+"AMS.dbo.VehicleRegistration");}
		            }
		            if (i == 1) {
		                /***********************************INSERT VEHICLE IN TBLVEHICLEMASTER**********************************/
		            	/* For time being we are checking vehicle Present or not in the below tables.later ll remove it*/ 
		            	pstmt6 = con.prepareStatement(AdminStatements.SELECT_REGISTRATION_DATE);
		            	pstmt6.setString(1, registrationNo);
		            	pstmt6.setInt(2, systemId);
		            	rs6=pstmt6.executeQuery();
		            	if(rs6.next())
		            	{
		            		if(rs6.getString("RegistrationDateTime")==null ||  rs6.getString("RegistrationDateTime").equals("") || rs6.getString("RegistrationDateTime").contains("1900"))
		            		{
		            		date="";
		            		}else
		            		{
		            			date=ddmmyyyy.format(rs6.getTimestamp("RegistrationDateTime"));
		            		}
		            	}
		            	
		            	if(SelectedCheckBox.equals("true"))
		            	{
		            	    check="1";
		            	}else
		            	{
		            		check="0";
		            	}
		            	
		            	
		                pstmt = con.prepareStatement(AdminStatements.CHECK_IF_VEHICLE_PRESENT_IN_tblVehicleMaster);
		                pstmt.setString(1, registrationNo);
		                rs = pstmt.executeQuery();
		                if (!rs.next()) {
		                    pstmt = con.prepareStatement(AdminStatements.INSERT_REGISTERED_VEHICLE_DETAILS_IN_tblVehicleMaster_IF_VEHICLE_IS_NOT_PRESENT);
		                    pstmt.setString(1, registrationNo.toUpperCase());
		                    pstmt.setString(2, assetType);
		                    pstmt.setString(3, assetModel);
		                    pstmt.setString(4, ownerName);
		                    pstmt.setString(5, ownerAddress);
		                    pstmt.setString(6, ownerPhoneNo);
		                    pstmt.setString(7, assetId);
		                    pstmt.setInt(8, systemId);
		                    pstmt.setInt(9, ownerId);
		                    pstmt.setInt(10, userId);
		                    pstmt.setString(11, check);
		                    pstmt.setString(12, ownerEmailId);
		                    int u=pstmt.executeUpdate();
		                    if(u>0){tableList.add("Insert"+"##"+"AMS.dbo.tblVehicleMaster");}
		                }
		                /***************************************FOR VEHICLE ASSOCIATION****************************************/
		                if (!unitNo.equals("")) {
		                    pstmt = con.prepareStatement(AdminStatements.INSERT_INTO_VEHICLE_ASSOCIATION);
		                    pstmt.setString(1, registrationNo);
		                    pstmt.setString(2, unitNo);
		                    pstmt.setString(3, getUnitTypeCode(unitNo, systemId, con));
		                    pstmt.setInt(4, systemId);
		                    pstmt.setInt(5, CustID);
		                    int associate = pstmt.executeUpdate();
		                    if (associate > 0) {
		                    	tableList.add("Insert"+"##"+"AMS.dbo.Vehicle_association");
		                        pstmt = con.prepareStatement(AdminStatements.UPDATE_SIM_NUMBER_BASED_ON_UNIT_IN_ADMINISTRATOR);
		                        pstmt.setString(1, mobileNo);
		                        pstmt.setString(2, unitNo);
		                        pstmt.setInt(3, systemId);
		                        pstmt.executeUpdate();
		                        pstmt5 = con.prepareStatement(AdminStatements.UPDATE_SIM_NUMBER_BASED_ON_UNIT_IN_AMS);
		                        pstmt5.setString(1, mobileNo);
		                        pstmt5.setString(2, unitNo);
		                        pstmt5.setInt(3, systemId);
		                        pstmt5.executeUpdate();
		                        tableList.add("Update"+"##"+"ADMINISTRATOR.dbo.UNIT_MASTER");
		                        tableList.add("Update"+"##"+"AMS.dbo.Unit_Master");
		                    }
		                }
		                /********************************FOR CLIENT_ASSOCIATION*************************************************/
		                pstmt = con.prepareStatement(AdminStatements.INSERT_INTO_VEHICLE_CLIENT);
		                pstmt.setString(1, registrationNo);
		                pstmt.setInt(2, CustID);
		                pstmt.setInt(3, systemId);
		                pstmt.setInt(4, groupId);
		                int inserted = pstmt.executeUpdate();
		                pstmt1 = con.prepareStatement(AdminStatements.INSERT_USER_IN_VEHICLEUSERS);
		                if (SelectedCheckBox.equals("true")) {
		                	/* selects all the associated group users from User Asset Group Association Table,
		                	  and then associates Registration Number all that users in Vehicle users table */
		                    pstmt = con.prepareStatement(AdminStatements.GET_ASSOCIATED_GROUP_USER_FROM_USER_ASSET_GROUP_ASSOCIATION);
		                    pstmt.setInt(1, systemId);
		                    pstmt.setInt(2, groupId);
		                    rs = pstmt.executeQuery();
		                    while (rs.next()) {
		                        pstmt1.setString(1, registrationNo);
		                        pstmt1.setInt(2, rs.getInt("USER_ID"));
		                        pstmt1.setInt(3, systemId);
		                        try {
		                            pstmt1.executeUpdate();
		                        } catch (SQLServerException e) {}
		                    }
		                } else {
		                    pstmt1.setString(1, registrationNo);
		                    pstmt1.setInt(2, userId);
		                    pstmt1.setInt(3, systemId);
		                    try {
		                        pstmt1.executeUpdate();
		                    } catch (SQLServerException e) {}
		                }
		                String img = null;
		                String StopIdleSpeed = "0";
		                String stopIdleSpeedForClient = "0";
		                String stopIdleSpeedForLTSP = "0";
		                pstmt1 = con.prepareStatement(AdminStatements.SELECT_IMAGE_NAME_AND_CUST_NAME_SPEED_FROM_CUSTOMER_MASTER);
		                pstmt1.setInt(1, systemId);
		                pstmt1.setInt(2, CustID);
		                ResultSet rs1 = pstmt1.executeQuery();
		                if (rs1.next()) {
		                	if(!rs1.getString("VehicleImageName").trim().equals(""))
		                	{
		                		img = "jsps/images/VehicleImages/" + rs1.getString("VehicleImageName").trim();
		                	} else {
		                		img = "";
		                	}
	                    	stopIdleSpeedForClient = rs1.getString("StopIdleSpeed");
		                }
		                pstmt1.close();
		                rs1.close();
		                
		                pstmt1 = con.prepareStatement(AdminStatements.SELECT_STOP_IDLE_SPEED_FROM_SYSTEM_MASTER);
		                pstmt1.setInt(1, systemId);
		                ResultSet result = pstmt1.executeQuery();
		                if (result.next()) {
		                    if (result.getString("StopIdleSpeed") != null && !result.getString("StopIdleSpeed").equals("")) 
		                    	stopIdleSpeedForLTSP = result.getString("StopIdleSpeed");
		                }
		                pstmt1.close();
		                result.close();
		                
		                if(!stopIdleSpeedForClient.equals("0")){
		                	StopIdleSpeed = stopIdleSpeedForClient;
		                }else if(!stopIdleSpeedForLTSP.equals("0")){
		                	StopIdleSpeed = stopIdleSpeedForLTSP;
		                }else{
		                	StopIdleSpeed = "10";
		                }
		                /*For time being we are inserting to Live vision.ll remove it later*/
		                pstmt = con.prepareStatement(AdminStatements.CHECK_REGISTRATION_NO_IN_LIVE_SUPPORT);
		                pstmt.setString(1, registrationNo);
		                rs = pstmt.executeQuery();
		                if (!rs.next()) {
		                    pstmt = con.prepareStatement(AdminStatements.INSERT_VEHICLE_LIVE_SUPPORT);
		                    pstmt.setString(1, registrationNo);
		                    pstmt.setInt(2, systemId);
		                    pstmt.setString(3, groupName);
		                    pstmt.setInt(4, CustID);
		                    pstmt.setString(5, custName);
		                    pstmt.setString(6, ownerName);
		                    pstmt.setString(7, img);
		                    pstmt.setString(8, assetId);
		                    int up1=pstmt.executeUpdate();
		                    if(up1>0){tableList.add("Insert"+"##"+"AMS.dbo.Live_Vision_Support");}
		                }
		                int categoryId = 0;
		                String offsetstr = "";
		                pstmt = con.prepareStatement("select CategoryTypeForBill,Offset from AMS.dbo.System_Master where System_id=?");
				        pstmt.setInt(1, systemId);
				        rs = pstmt.executeQuery();
				        if (rs.next()) {
				            categoryId = rs.getInt("CategoryTypeForBill");
				            offsetstr = rs.getString("Offset");
				        }
		                pstmt = con.prepareStatement(AdminStatements.CHECK_VEHICLE_IN_gpsdata_history_latest);
		                pstmt.setString(1, registrationNo);
		                rs = pstmt.executeQuery();
		                /* SLNO=9999.Because we want to know which all vehicles registered.(for time being)*/
		                int SLNO = 9999;
		                if(rs.next()==true && flag==1)
		                {
		                	int up3=getUnitType(SLNO,con,registrationNo,unitNo,systemId,CustID,offsetstr);
		                	if(up3>0){tableList.add("Insert"+"##"+"AMS.dbo.GPSDATA_LIVE_CANIQ");}
		                }
		                else if(rs.next() == false) {
		                    pstmt = con.prepareStatement(AdminStatements.INSERT_VEHICLE_IN_gpsdata_history_latest);
		                    pstmt.setInt(1, SLNO);
		                    pstmt.setString(2, registrationNo);
		                    pstmt.setString(3, unitNo);
		                    pstmt.setInt(4, CustID);
		                    pstmt.setInt(5, offset);
		                    pstmt.setInt(6, systemId);
		                    pstmt.setString(7, offsetstr);
		                    pstmt.setString(8, zone);
		                    pstmt.setString(9, StopIdleSpeed);
		                    int up2=pstmt.executeUpdate();
		                    if(up2>0){tableList.add("Insert"+"##"+"AMS.dbo.gpsdata_history_latest");}
		                    int up3=getUnitType(SLNO,con,registrationNo,unitNo,systemId,CustID,offsetstr);
		                	if(up3>0){tableList.add("Insert"+"##"+"AMS.dbo.GPSDATA_LIVE_CANIQ");}
		                    
		                }
		                raiseVehicleRegistrationCancellationAlert(con, registrationNo, userId, systemId, ltspName, "Registration", offset, CustID, custName,"",date,categoryId);
		                tableList.add("Insert"+"##"+"AMS.dbo.EmailQueue");
		                if (inserted > 0) {
		                    message = "Asset Registered Successfully.";
		                } else {}
		                try {
							cf.insertDataIntoAuditLogReport(sessionId, tableList, pageName, "ADD", userId, serverName, systemId, CustID,"Registered Asset Details");
						} catch (Exception e) {
							e.printStackTrace();
						}
		                con.commit();
		            }
		        }
		    } catch (Exception e) {
		        e.printStackTrace();
		        try {
		            if (con != null) con.rollback();
		        } catch (Exception ex) {
		            ex.printStackTrace();
		        }
		    } finally {
		        DBConnection.releaseConnectionToDB(con, pstmt, null);
		        DBConnection.releaseConnectionToDB(null, pstmt2, null);
		        DBConnection.releaseConnectionToDB(null, pstmt1, null);
		        DBConnection.releaseConnectionToDB(null, pstmt5, null);
		        DBConnection.releaseConnectionToDB(null, pstmt6, null);
		    }
		    return message;
		}
		
		public String modifyRegisteredVehicle(String assetType, String registrationNo, int groupId, String unitNo, String mobileNo, int systemId, int userId,
				int offset, int CustID, String ltspName, String groupName, String custName, String assetModel, String ownerName, String ownerAddress,
				String ownerPhoneNo, String assetId, int custIdFormodify, int ownerId, String SelectedCheckBox,String pageName,String sessionId,String serverName,String ownerEmailId) {
		    Connection con = null;
		    String message = "";
		    int deleted = 0;
		    String check="";
		    PreparedStatement pstmt = null;
		    PreparedStatement pstmt1 = null;
		    PreparedStatement pstmt5 = null;
		    PreparedStatement pstmt2 = null;
		    PreparedStatement pstmt8 = null;
		    PreparedStatement pstmt6 = null;
		    ResultSet rs = null;
		    ResultSet rs2 = null;
		    ResultSet rs3 = null;
		    ResultSet rs6 = null;
		    ArrayList < Integer > groupuserlist = new ArrayList < Integer > ();
		    ArrayList < Integer > defaultuserlist = new ArrayList < Integer > ();
		    ArrayList<String> tableList=new ArrayList<String>();
		    try {
		        con = DBConnection.getConnectionToDB("AMS");
		        con.setAutoCommit(false);
		     	/* Checks if Subscription Details is Available ,If Available can checks for the validity of the Details
	        	 * 
	        	 */
	        	pstmt = con.prepareStatement(AdminStatements.CHECK_IF_LTSP_SUBSCRIPTION_DETAILS_FOR_SUBSCRIPTION_VALIDATION);
                pstmt.setInt(1, systemId);
                pstmt.setInt(2, CustID);
                rs2 = pstmt.executeQuery();
    		        if (rs2.next()){
    		        	pstmt = con.prepareStatement(AdminStatements.SELECT_DETAILS_FROM_VEHICLE_SUBSCRIPTION_DETAILS);
    		        	 pstmt.setString(1, registrationNo);
    		        	 pstmt.setInt(2, systemId);
    	                 pstmt.setInt(3, CustID);
    	                 pstmt.setString(4, registrationNo);
    		        	 pstmt.setInt(5, systemId);
    	                 pstmt.setInt(6, CustID);
    	                 rs = pstmt.executeQuery();
    	 		        	if (rs.next()) {
    	                	  if((rs.getString("validity")).equalsIgnoreCase("Invalid")){
    	                		  message = "Subscription Renewal should be done for this Vehicle to manipulate data";
    	                		  return message;
    	                	  }
					} else {

						pstmt = con
								.prepareStatement(AdminStatements.INSERT_INTO_VEHICLE_SUBSCRIPTION_DETAILS);
						pstmt.setInt(1, systemId);
						pstmt.setInt(2, CustID);
						pstmt.setInt(3, userId);
						pstmt.setString(4, registrationNo);
						pstmt.setInt(5, offset);
						pstmt.setInt(6, rs2.getInt("SUBSCRIPTION_DURATION"));
						pstmt.setInt(7, offset);
						pstmt.setDouble(8, rs2.getDouble("AMOUNT_PER_MONTH")* rs2.getDouble("SUBSCRIPTION_DURATION"));
						pstmt.setInt(9, rs2.getInt("SUBSCRIPTION_DURATION"));
						pstmt.setInt(10, userId);
						pstmt.setInt(11, offset);
						pstmt.setInt(12, rs2.getInt("SUBSCRIPTION_DURATION"));
						pstmt.setInt(13, offset);
						pstmt.executeUpdate();

					}
    		    }
    		        
    		        
		        pstmt = con.prepareStatement(AdminStatements.CHECK_VEHICLE_IS_PRESENT_IN_VEHICLE_ASSOCIATION);
		        pstmt.setString(1, registrationNo);
		        rs = pstmt.executeQuery();
		        if (rs.next()) {
		            /**********************************if unitNumber same and MobileNo is different updates Mobileno in Unit_Master *******************************/
		            if (unitNo.equals(rs.getString("Unit_Number"))) {
		                if (!(mobileNo.equals(rs.getString("Sim_Number")))) {
		                    pstmt = con.prepareStatement(AdminStatements.UPDATE_SIM_NUMBER_BASED_ON_UNIT_IN_ADMINISTRATOR);
		                    pstmt.setString(1, mobileNo);
		                    pstmt.setString(2, unitNo);
		                    pstmt.setInt(3, systemId);
		                    pstmt.executeUpdate();
		                    pstmt5 = con.prepareStatement(AdminStatements.UPDATE_SIM_NUMBER_BASED_ON_UNIT_IN_AMS);
		                    pstmt5.setString(1, mobileNo);
		                    pstmt5.setString(2, unitNo);
		                    pstmt5.setInt(3, systemId);
		                    pstmt5.executeUpdate();
		                    tableList.add("Update"+"##"+"ADMINISTRATOR.dbo.UNIT_MASTER");
		                    tableList.add("Update"+"##"+"AMS.dbo.Unit_Master");
		                }
		                /****************************checks clientid with the modified client if different, updates the clientid in Vehicle_association***************/
		                if (custIdFormodify != (rs.getInt("Client_id"))) {
		                	pstmt1 = con.prepareStatement(AdminStatements.INSERT_DATA_SELECTED_FROM_VEH_ASSO_INTO_VEHICLE_ASSOCIATION_HISTORY);
			                pstmt1.setString(1, rs.getString("Registration_no"));
			                pstmt1.setString(2, rs.getString("Date"));
			                pstmt1.setString(3, rs.getString("Unit_Number"));
			                pstmt1.setString(4, rs.getString("Unit_Type_Code"));
			                pstmt1.setString(5, rs.getString("System_id"));
			                pstmt1.setInt(6, userId);
			                pstmt1.setString(7, rs.getString("Client_id"));
			                pstmt1.setString(8, rs.getString("SIM_NUMBER"));
			                int i = pstmt1.executeUpdate();
			                pstmt1.close();
			                if (i > 0) {
			                	tableList.add("Insert"+"##"+"AMS.dbo.Vehicle_association_Hist");
		                    pstmt1 = con.prepareStatement(AdminStatements.UPDATE_CLIENT_FROM_VEHICLE_ASSOC);
		                    pstmt1.setInt(1, custIdFormodify);
		                    pstmt1.setString(2, registrationNo);
		                    pstmt1.setInt(3, systemId);
		                    deleted = pstmt1.executeUpdate();
		                    if(deleted>0){tableList.add("Update"+"##"+"AMS.dbo.Vehicle_association");}
			                }
		                    
		                }
		            }
		            /*if unitNumber and modified unitNumber is different it moves the record to vehicle association history and 
		              inserts the new unitNumber in Vehicle Association if unitNumber is not empty.If unitNumber is empty deletes the record from 
		              vehicle association and Updates the mobileNumber to empty in UnitMaster Table */
		            else {
		                pstmt1 = con.prepareStatement(AdminStatements.INSERT_DATA_SELECTED_FROM_VEH_ASSO_INTO_VEHICLE_ASSOCIATION_HISTORY);
		                pstmt1.setString(1, rs.getString("Registration_no"));
		                pstmt1.setString(2, rs.getString("Date"));
		                pstmt1.setString(3, rs.getString("Unit_Number"));
		                pstmt1.setString(4, rs.getString("Unit_Type_Code"));
		                pstmt1.setString(5, rs.getString("System_id"));
		                pstmt1.setInt(6, userId);
		                pstmt1.setString(7, rs.getString("Client_id"));
		                pstmt1.setString(8, rs.getString("SIM_NUMBER"));
		                int i = pstmt1.executeUpdate();
		                pstmt1.close();
		                if (i > 0) {
		                	tableList.add("Insert"+"##"+"AMS.dbo.Vehicle_association_Hist");
		                    if (!unitNo.equals("")) {
		                        pstmt1 = con.prepareStatement(AdminStatements.UPDATE_REGNO_FROM_VEHICLE_ASSOC);
		                        pstmt1.setString(1, unitNo);
		                        pstmt1.setString(2, getUnitTypeCode(unitNo, systemId, con));
		                        pstmt1.setInt(3, custIdFormodify);
		                        pstmt1.setString(4, registrationNo);
		                        pstmt1.setInt(5, systemId);
		                        deleted = pstmt1.executeUpdate();
		                        if(deleted>0){
		                        	pstmt1 = con.prepareStatement(AdminStatements.UPDATE_UNIT_NO_IN_MOBILEYE_LIVE);
		                        	pstmt1.setString(1, unitNo);
		                        	pstmt1.setString(2,registrationNo);
		                        	pstmt1.setInt(3, systemId);
		                        	deleted = pstmt1.executeUpdate();
		                        	tableList.add("Update"+"##"+"AMS.dbo.Vehicle_association");
		                        	tableList.add("Update"+"##"+"AMS.dbo.MOBILEYE_LIVE");
		                        }
		                    } else {
		                        pstmt1 = con.prepareStatement(AdminStatements.DELETE_VEHICLE_FROM_Vehicle_association);
		                        pstmt1.setString(1, registrationNo);
		                        pstmt1.setInt(2, systemId);
		                        deleted = pstmt1.executeUpdate();
		                        
		                        if(deleted>0){tableList.add("Update"+"##"+"AMS.dbo.Vehicle_association");}
		                        
		                        pstmt1 = con.prepareStatement(AdminStatements.UPDATE_LOCATION_IN_GPS_LATEST_HISTORY);
		                        pstmt1.setString(1, registrationNo);
		                        pstmt1.setInt(2, systemId);
		                        int up1=pstmt1.executeUpdate();
		                        
		                        if(up1>0){tableList.add("Update"+"##"+"AMS.dbo.gpsdata_history_latest");}
		                        
		                        pstmt1 = con.prepareStatement(AdminStatements.UPDATE_LOCATION_GPSDATA_LIVE_CANIQ);
		                        pstmt1.setString(1, registrationNo);
		                        pstmt1.setInt(2, systemId);
		                        int up2=pstmt1.executeUpdate();
		                        if(up2>0){tableList.add("Update"+"##"+"AMS.dbo.GPSDATA_LIVE_CANIQ");}
		                    }
		                    if (deleted > 0) {
		                        updateSimNumberInUnitMaster(con, rs.getString("Unit_Number"), systemId, "");
		                        if (!unitNo.equalsIgnoreCase("")) {
		                            updateSimNumberInUnitMaster(con, unitNo, systemId, mobileNo);
		                        }
		                        tableList.add("Update"+"##"+"ADMINISTRATOR.dbo.UNIT_MASTER");
		                        tableList.add("Update"+"##"+"AMS.dbo.Unit_Master");
		                    }
		                }
		            }
		            String existingUnitNo=null;
		            pstmt = con.prepareStatement(AdminStatements.GET_UNIT_NO);
		            pstmt.setString(1,mobileNo);
		            pstmt.setInt(2, systemId);
		            rs = pstmt.executeQuery();
			        if (rs.next()) {
		                 existingUnitNo = rs.getString("unitNumber");
		             
		                 pstmt = con.prepareStatement(AdminStatements.CHECK_IF_MOB_NO_IS_ASSOCIATED_TO_UNIT_NO_IN_AMS);
		                 pstmt.setString(1, existingUnitNo);
		                 pstmt.setInt(2, systemId);
		                 rs6 = pstmt.executeQuery();
		                 if(rs6.next()) {
		                	 pstmt6 = con.prepareStatement(AdminStatements.UPDATE_MOBILE_NUMBER_EMPTY_AMS);
		                	 pstmt6.setString(1,existingUnitNo);
		                	 pstmt6.setInt(2, systemId);
		                	 pstmt6.executeUpdate();
		                	 pstmt6.close();
		                 }
		           
		                 pstmt = con.prepareStatement(AdminStatements.CHECK_IF_MOB_NO_IS_ASSOCIATED_TO_UNIT_NO_IN_ADMIN);
		                 pstmt.setString(1, existingUnitNo);
		                 pstmt.setInt(2, systemId);
		                 rs6 = pstmt.executeQuery();
		                 if(rs6.next()) {
		                	 pstmt6 = con.prepareStatement(AdminStatements.UPDATE_MOBILE_NUMBER_EMPTY_ADMIN);
		                	 pstmt6.setString(1,existingUnitNo);
		                	 pstmt6.setInt(2, systemId);
		                	 pstmt6.executeUpdate();
		                	 pstmt6.close();
		                 }
		                 rs6.close();
			        }
		            pstmt6 = con.prepareStatement(AdminStatements.UPDATE_MOBILE_NUMBER_IN_AMS);
	            	pstmt6.setString(1, mobileNo);
	            	pstmt6.setString(2,unitNo);
	            	pstmt6.setInt(3, systemId);
	            	pstmt6.executeUpdate();
	            	pstmt6.close();
			        
			        pstmt6 = con.prepareStatement(AdminStatements.UPDATE_MOBILE_NUMBER_IN_ADMIN);
		        	pstmt6.setString(1, mobileNo);
		        	pstmt6.setString(2,unitNo);
		        	pstmt6.setInt(3, systemId);
		        	pstmt6.executeUpdate();
		        	pstmt6.close();
		        	
		            
		        } else {
		        	/* if that registration number is not present in vehicle Association it inserts and then updates the mobileNumber in UnitMaster*/
		            if (!unitNo.equals("")) {
		                pstmt = con.prepareStatement(AdminStatements.INSERT_INTO_VEHICLE_ASSOCIATION);
		                pstmt.setString(1, registrationNo);
		                pstmt.setString(2, unitNo);
		                pstmt.setString(3, getUnitTypeCode(unitNo, systemId, con));
		                pstmt.setInt(4, systemId);
		                pstmt.setInt(5, custIdFormodify);
		                int associate = pstmt.executeUpdate();
		                if (associate > 0) {
		                	tableList.add("Insert"+"##"+"AMS.dbo.Vehicle_association");
	                        
		                    pstmt = con.prepareStatement(AdminStatements.UPDATE_SIM_NUMBER_BASED_ON_UNIT_IN_ADMINISTRATOR);
		                    pstmt.setString(1, mobileNo);
		                    pstmt.setString(2, unitNo);
		                    pstmt.setInt(3, systemId);
		                    pstmt.executeUpdate();
		                    pstmt5 = con.prepareStatement(AdminStatements.UPDATE_SIM_NUMBER_BASED_ON_UNIT_IN_AMS);
		                    pstmt5.setString(1, mobileNo);
		                    pstmt5.setString(2, unitNo);
		                    pstmt5.setInt(3, systemId);
		                    pstmt5.executeUpdate();
		                    tableList.add("Update"+"##"+"ADMINISTRATOR.dbo.UNIT_MASTER");
		                    tableList.add("Update"+"##"+"AMS.dbo.Unit_Master");
		                }
		            }
		        }
		        /**********************************************************FOR NEW MODIFIED CLIENT ASSOCIATION*******************************************************/
		        pstmt = con.prepareStatement(AdminStatements.CHECK_VEHICLE_IS_PRESENT_IN_VEHICLE_CLIENT);
		        pstmt.setString(1, registrationNo);
		        pstmt.setInt(2, systemId);
		        rs = pstmt.executeQuery();
		        if (rs.next()) {
		        	/* if vehicle Present in vehicle Client*/
		            int oldcustid = rs.getInt("CLIENT_ID");
		            int oldgroupid = rs.getInt("GROUP_ID");
		            if (oldcustid == custIdFormodify) {
		            	/*if custId and Modified CustId are same and GroupId is not equal to modified groupid then updates the GroupId in vehicle Client*/
		                if (oldgroupid != groupId) {
		                    pstmt = con.prepareStatement(AdminStatements.UPDATE_GROUP_ID_IN_VEHICLE_CLIENT);
		                    pstmt.setInt(1, groupId);
		                    pstmt.setString(2, registrationNo);
		                    pstmt.setInt(3, systemId);
		                    pstmt.setInt(4, custIdFormodify);
		                    int u1=pstmt.executeUpdate();
		                    
		                    if(u1>0){tableList.add("Update"+"##"+"AMS.dbo.VEHICLE_CLIENT");}
		                    
		                    pstmt = con.prepareStatement(AdminStatements.MOVE_TO_VEHICLE_USER_HISTORY);
			                pstmt.setString(1, registrationNo);
			                pstmt.setInt(2, systemId);
			                int update = pstmt.executeUpdate();
			                if (update > 0) {
			                	tableList.add("Insert"+"##"+"AMS.dbo.Vehicle_User_Hist");
			                    pstmt = con.prepareStatement(AdminStatements.DELETE_FROM_VEHICLE_USERS);
			                    pstmt.setString(1, registrationNo);
			                    pstmt.setInt(2, systemId);
			                    int d=pstmt.executeUpdate();
			                    if(d>0){tableList.add("Delete"+"##"+"AMS.dbo.Vehicle_User");}
			                }
			                pstmt1 = con.prepareStatement(AdminStatements.INSERT_USER_IN_VEHICLEUSERS);
		                    if (SelectedCheckBox.equals("true")) {
		                    	 pstmt = con.prepareStatement(AdminStatements.GET_ASSOCIATED_GROUP_USER_FROM_USER_ASSET_GROUP_ASSOCIATION);
				                    pstmt.setInt(1, systemId);
				                    pstmt.setInt(2, groupId);
				                    rs = pstmt.executeQuery();
				                    while (rs.next()) {
				                        pstmt1.setString(1, registrationNo);
				                        pstmt1.setInt(2, rs.getInt("USER_ID"));
				                        pstmt1.setInt(3, systemId);
				                        try {
				                            pstmt1.executeUpdate();
				                        } catch (SQLServerException e) {}
				                    }
		                    }else {
		                    	
			                    pstmt1.setString(1, registrationNo);
			                    pstmt1.setInt(2, userId);
			                    pstmt1.setInt(3, systemId);
			                    pstmt1.executeUpdate();
			                }
		                    
		                    if(SelectedCheckBox.equals("true"))
		                	{
		                	    check="1";
		                	}else
		                	{
		                		check="0";
		                	}
		                    tableList.add("Insert"+"##"+"AMS.dbo.Vehicle_User");
		                    pstmt8 = con.prepareStatement(AdminStatements.UPDATE_CHECK_AND_USER_ID_IN_TBL_VEHICLE_MASTER);
		                    pstmt8.setString(1, check);
		                    pstmt8.setInt(2, userId);
		                    pstmt8.setString(3, registrationNo);
		                    pstmt8.setInt(4, systemId);
		                    int u2=pstmt8.executeUpdate();
		                    if(u2>0){tableList.add("Update"+"##"+"AMS.dbo.tblVehicleMaster");}
			                }
		            }
		            /*******************************If custId and modified custid is different *******************************************/
		            else {
		                pstmt = con.prepareStatement(AdminStatements.MOVE_TO_VEHICLE_USER_HISTORY);
		                pstmt.setString(1, registrationNo);
		                pstmt.setInt(2, systemId);
		                int update = pstmt.executeUpdate();
		                if (update > 0) {
		                	tableList.add("Insert"+"##"+"AMS.dbo.Vehicle_User_Hist");
		                    pstmt = con.prepareStatement(AdminStatements.DELETE_FROM_VEHICLE_USERS);
		                    pstmt.setString(1, registrationNo);
		                    pstmt.setInt(2, systemId);
		                    int u4=pstmt.executeUpdate();
		                    if(u4>0){tableList.add("Delete"+"##"+"AMS.dbo.Vehicle_User");}
		                }
		                
		                pstmt2 = con.prepareStatement(AdminStatements.CHECK_IF_VEHICLE_PRESENT_IN_PREVENTIVE_EVENTS);
	                    pstmt2.setString(1, registrationNo);
			            pstmt2.setInt(2, systemId);
			            pstmt2.setInt(3, CustID);
			            rs3 = pstmt2.executeQuery();
			            if (rs3.next()) {
			                pstmt2 = con.prepareStatement(AdminStatements.DELETE_VEHICLE_FROM_PREVENTIVE_EVENTS);
			                pstmt2.setString(1, registrationNo);
			                pstmt2.setInt(2, systemId);
			                pstmt2.setInt(3, CustID);
			                int preventiveDeleted = pstmt2.executeUpdate();
			                if(preventiveDeleted>0){tableList.add("Delete"+"##"+"FMS.dbo.PREVENTIVE_TASK_ASSOCIATION");}
			            }
			            
			            
		                pstmt = con.prepareStatement(AdminStatements.MOVE_RECORD_TO_VEHICLE_CLIENT_HISTORY);
		                pstmt.setString(1, registrationNo);
		                pstmt.setInt(2, oldcustid);
		                pstmt.setInt(3, systemId);
		                int u5=pstmt.executeUpdate();
		                if(u5>0){tableList.add("Insert"+"##"+"AMS.dbo.VEHICLE_CLIENT_HISTORY");}
		                pstmt = con.prepareStatement(AdminStatements.UPDATE_CLIENT_VEHICLE_ASSOCIATION);
		                pstmt.setInt(1, custIdFormodify);
		                pstmt.setInt(2, groupId);
		                pstmt.setString(3, registrationNo);
		                pstmt.setInt(4, systemId);
		                int u6=pstmt.executeUpdate();
		                if(u6>0){tableList.add("Insert"+"##"+"AMS.dbo.VEHICLE_CLIENT");}
		                pstmt1 = con.prepareStatement(AdminStatements.INSERT_USER_IN_VEHICLEUSERS);
		                if (SelectedCheckBox.equals("true")) {
		                    pstmt = con.prepareStatement(AdminStatements.GET_ASSOCIATED_GROUP_USER_FROM_USER_ASSET_GROUP_ASSOCIATION);
		                    pstmt.setInt(1, systemId);
		                    pstmt.setInt(2, groupId);
		                    rs = pstmt.executeQuery();
		                    while (rs.next()) {
		                        pstmt1.setString(1, registrationNo);
		                        pstmt1.setInt(2, rs.getInt("USER_ID"));
		                        pstmt1.setInt(3, systemId);
		                        try {
		                            pstmt1.executeUpdate();
		                        } catch (SQLServerException e) {}
		                    }
		                } else {
		                    pstmt1.setString(1, registrationNo);
		                    pstmt1.setInt(2, userId);
		                    pstmt1.setInt(3, systemId);
		                    pstmt1.executeUpdate();
		                }
		                tableList.add("Insert"+"##"+"AMS.dbo.Vehicle_User");
		                if(SelectedCheckBox.equals("true"))
	                	{
	                	    check="1";
	                	}else
	                	{
	                		check="0";
	                	}
	                    
	                    pstmt8 = con.prepareStatement(AdminStatements.UPDATE_CHECK_AND_USER_ID_IN_TBL_VEHICLE_MASTER);
	                    pstmt8.setString(1, check);
	                    pstmt8.setInt(2, userId);
	                    pstmt8.setString(3, registrationNo);
	                    pstmt8.setInt(4, systemId);
	                    int u8=pstmt8.executeUpdate();
	                    if(u8>0){tableList.add("Update"+"##"+"AMS.dbo.tblVehicleMaster");}
		            }
		        }
		        /*************************************************FIELDS TO MODIFY IN Tblvehicle_Master**************************************/
			    pstmt = con.prepareStatement(AdminStatements.UPDATE_REGISTER_INFORMATION_IN_tblVehicleMaster);
		        pstmt.setString(1, assetType);
		        pstmt.setString(2, assetModel);
		        pstmt.setString(3, ownerName);
		        pstmt.setString(4, ownerAddress);
		        pstmt.setString(5, ownerPhoneNo);
		        pstmt.setString(6, assetId);
		        pstmt.setInt(7, ownerId);
		        pstmt.setString(8, ownerEmailId);
		        pstmt.setString(9, registrationNo);
		        pstmt.setInt(10, systemId);
			    int update = pstmt.executeUpdate();
			    if(update>0){tableList.add("Update"+"##"+"AMS.dbo.tblVehicleMaster");}
		        String img = null;
		        String StopIdleSpeed = "0";
		        String stopIdleSpeedForClient = "0";
		        String stopIdleSpeedForLTSP = "0";
		        String CName = null;
		        pstmt1 = con.prepareStatement(AdminStatements.SELECT_IMAGE_NAME_AND_CUST_NAME_SPEED_FROM_CUSTOMER_MASTER);
		        pstmt1.setInt(1, systemId);
		        pstmt1.setInt(2, custIdFormodify);
		        ResultSet rs1 = pstmt1.executeQuery();
		        if (rs1.next()) {
		        	if(!rs1.getString("VehicleImageName").trim().equals(""))
                	{
                		img = "jsps/images/VehicleImages/" + rs1.getString("VehicleImageName").trim();
                	} else {
                		img = "";
                	}
		            CName = rs1.getString("CustomerName");
		            StopIdleSpeed = rs1.getString("StopIdleSpeed");
		        }
		        pstmt1.close();
		        rs1.close();
		        
		        pstmt1 = con.prepareStatement(AdminStatements.SELECT_STOP_IDLE_SPEED_FROM_SYSTEM_MASTER);
                pstmt1.setInt(1, systemId);
                ResultSet result = pstmt1.executeQuery();
                if (result.next()) {
                    if (result.getString("StopIdleSpeed") != null && !result.getString("StopIdleSpeed").equals("")) 
                    	stopIdleSpeedForLTSP = result.getString("StopIdleSpeed");
                }
                pstmt1.close();
                rs1.close();
                
		        if(!stopIdleSpeedForClient.equals("0")){
                	StopIdleSpeed = stopIdleSpeedForClient;
                }else if(!stopIdleSpeedForLTSP.equals("0")){
                	StopIdleSpeed = stopIdleSpeedForLTSP;
                }else{
                	StopIdleSpeed = "10";
                }
		        pstmt1 = con.prepareStatement(AdminStatements.UPDATE_CLIENT_ID_NAME_IN_LIVE_VISION_SUPPORT_WITHOUT_IMG);
		        pstmt1.setInt(1, custIdFormodify);
		        pstmt1.setString(2, CName);
		        pstmt1.setString(3, groupName);
		        pstmt1.setString(4, ownerName);
		        pstmt1.setString(5, assetId);
		        pstmt1.setString(6, registrationNo);
		        int i4 = pstmt1.executeUpdate();
		        if(i4>0){tableList.add("Update"+"##"+"AMS.dbo.Live_Vision_Support");}
		        pstmt1.close();
		        
		        pstmt1 = con.prepareStatement(AdminStatements.UPDATE_IMG_NAME_IN_LIVE_VISION_SUPPORT);
		        pstmt1.setString(1, img);
		        pstmt1.setInt(2, systemId);
		        pstmt1.setInt(3, custIdFormodify);
		        pstmt1.setInt(4, systemId);
		        pstmt1.setString(5, registrationNo);
		        int i3 = pstmt1.executeUpdate();
		        if(i3>0){tableList.add("Update"+"##"+"AMS.dbo.Live_Vision_Support");}
		        pstmt1.close();
		        
		        pstmt1 = con.prepareStatement(AdminStatements.UPDATE_SPEED_IN_GPS_HISTORY_LATEST);
		        pstmt1.setString(1, StopIdleSpeed);
		        pstmt1.setString(2, unitNo);
		        pstmt1.setInt(3, custIdFormodify);
		        pstmt1.setString(4, registrationNo);
		        pstmt1.setInt(5, systemId);
		        int i1 = pstmt1.executeUpdate();
		        if(i1>0){tableList.add("Update"+"##"+"AMS.dbo.gpsdata_history_latest");}
		        
		        pstmt1 = con.prepareStatement(AdminStatements.UPDATE_CLIENT_GPSDATA_LIVE_CANIQ);
		        pstmt1.setString(1, unitNo);
		        pstmt1.setInt(2, custIdFormodify);
		        pstmt1.setString(3, registrationNo);
		        pstmt1.setInt(4, systemId);
		        int i2 = pstmt1.executeUpdate();
		        if(i2>0){tableList.add("Update"+"##"+"AMS.dbo.GPSDATA_LIVE_CANIQ");}
                
		        message = "Updated Successfully";
		        con.commit();
		        try {
					cf.insertDataIntoAuditLogReport(sessionId, tableList, pageName, "MODIFY", userId, serverName, systemId, custIdFormodify,"Updated Vehicle Details");
				} catch (Exception e) {
					e.printStackTrace();
				}
		    } catch (Exception e) {
		        e.printStackTrace();
		        try {
		            if (con != null) con.rollback();
		        } catch (Exception ex) {
		            ex.printStackTrace();
		        }
		    } finally {
		        DBConnection.releaseConnectionToDB(con, pstmt, rs);
		        DBConnection.releaseConnectionToDB(null, pstmt1, null);
		        DBConnection.releaseConnectionToDB(null, pstmt2, rs3);
		        DBConnection.releaseConnectionToDB(null, pstmt5, null);
		        DBConnection.releaseConnectionToDB(null, pstmt8, null);
		    }
		    return message;
		}
		
		public String functionToDeleteVehicle(String vehicleRegistrationNo, int systemId, int userId, String ltspName, int offset, String reason,
				int customerId, String userName, String custName, String unit_number, String assetType,String pageName,String sessionId,String serverName,int flag,String newVehicleRegistrationNo) {
		    Connection con = null;
		    String message = "";
		    PreparedStatement pstmt = null;
		    PreparedStatement pstmt1 = null;
		    PreparedStatement pstmt2 = null;
		    CallableStatement cstmt = null;
		    PreparedStatement pstmt6 = null;
		    ResultSet rs6 = null;
		    SimpleDateFormat ddmmyyyy = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
		    ResultSet rs = null;
		    String date="";
		    ArrayList<String> tableList=new ArrayList<String>();
		    try {
		        con = DBConnection.getConnectionToDB("ADMINISTRATOR");
		        con.setAutoCommit(false);
		        if (!unit_number.equals("")) {
		            pstmt = con.prepareStatement(AdminStatements.CHECK_VEHICLE_IS_PRESENT_IN_VEHICLE_ASSOCIATION);
		            pstmt.setString(1, vehicleRegistrationNo);
		            rs = pstmt.executeQuery();
		            if (rs.next()) {
		                pstmt1 = con.prepareStatement(AdminStatements.INSERT_DATA_SELECTED_FROM_VEH_ASSO_INTO_VEHICLE_ASSOCIATION_HISTORY);
		                pstmt1.setString(1, rs.getString("Registration_no"));
		                pstmt1.setString(2, rs.getString("Date"));
		                pstmt1.setString(3, rs.getString("Unit_Number"));
		                pstmt1.setString(4, rs.getString("Unit_Type_Code"));
		                pstmt1.setString(5, rs.getString("System_id"));
		                pstmt1.setInt(6, userId);
		                pstmt1.setString(7, rs.getString("Client_id"));
		                pstmt1.setString(8, rs.getString("SIM_NUMBER"));
		                int i =pstmt1.executeUpdate();
		                pstmt1.close();
		                if (i > 0) {
		                	tableList.add("Insert"+"##"+"AMS.dbo.Vehicle_association_Hist");
		                    pstmt = con.prepareStatement(AdminStatements.UPDATE_SIM_NUMBER_BASED_ON_UNIT_IN_ADMINISTRATOR);
		                    pstmt.setString(1, "");
		                    pstmt.setString(2, rs.getString("Unit_Number"));
		                    pstmt.setInt(3, systemId);
		                    pstmt.executeUpdate();
		                    pstmt = con.prepareStatement(AdminStatements.UPDATE_SIM_NUMBER_BASED_ON_UNIT_IN_AMS);
		                    pstmt.setString(1, "");
		                    pstmt.setString(2, rs.getString("Unit_Number"));
		                    pstmt.setInt(3, systemId);
		                    pstmt.executeUpdate();
		                    tableList.add("Update"+"##"+"ADMINISTRATOR.dbo.UNIT_MASTER");
		                    tableList.add("Update"+"##"+"AMS.dbo.Unit_Master");
		                }
		            }
		        }
		        pstmt = con.prepareStatement(AdminStatements.UPDATE_REGISTERED_VEHICLE_STATUS_TO_INACTIVE);
		        pstmt.setString(1, "Inactive");
		        pstmt.setInt(2, offset);
		        pstmt.setInt(3, userId);
		        pstmt.setString(4, reason);
		        pstmt.setString(5, vehicleRegistrationNo);
		        pstmt.setInt(6, systemId);
		        int i = pstmt.executeUpdate();
		        if(i>0){tableList.add("Update"+"##"+"AMS.dbo.VehicleRegistration");}
		        pstmt6 = con.prepareStatement(AdminStatements.SELECT_CANCELLATION_DATE);
            	pstmt6.setString(1, vehicleRegistrationNo);
            	pstmt6.setInt(2, systemId);
            	rs6=pstmt6.executeQuery();
            	if(rs6.next())
            	{
            		if(rs6.getString("CancellationDateTime")==null ||  rs6.getString("CancellationDateTime").equals("") || rs6.getString("CancellationDateTime").contains("1900"))
            		{
            	     	date="";
            		}else
            		{
            			date=ddmmyyyy.format(rs6.getTimestamp("CancellationDateTime"));
            		}
             			
            	}
			        
		        pstmt2 = con.prepareStatement(AdminStatements.MOVE_DATA_FROM_VEHICLEREGISTRATION_TO_ASSET_REGISTRATION_HISTORY);
		        pstmt2.setInt(1, customerId);
		        pstmt2.setString(2, assetType);
		        pstmt2.setString(3,vehicleRegistrationNo);
		        pstmt2.setInt(4, systemId);
		        int up=pstmt2.executeUpdate();
		        if(up>0){tableList.add("Insert"+"##"+"ADMINISTRATOR.dbo.ASSET_REGISTRATION_HISTORY");}
		        if (i > 0) {
		            /**
		             * Put AlertType 124(Vehicle Reg And UnReg) directly in EmailQueue table
		             */
		            /***********************************************STORED PROCEDURE TO DELETE DETAILS FROM ALL TABLES**************************************************************************/
		        	cstmt = con.prepareCall(AdminStatements.DELETE_ASSET_STORED_PROCEDURE);
		            cstmt.setInt(1, customerId);
		            cstmt.setInt(2, systemId);
		            cstmt.setString(3, vehicleRegistrationNo);
		            cstmt.executeUpdate();
		        	if(flag==1)
		            {
		        		pstmt = con.prepareStatement("update AMS.dbo.gpsdata_history_latest set REGISTRATION_NO =? where REGISTRATION_NO =? and System_id =? and CLIENTID =?");
		        		pstmt.setString(1, newVehicleRegistrationNo);
		        		pstmt.setString(2, vehicleRegistrationNo);
		        		pstmt.setInt(3, systemId);
		        		pstmt.setInt(4, customerId);
		        		pstmt.executeUpdate();
		            }
		           else
		            {
		            	pstmt = con.prepareStatement("delete from AMS.dbo.gpsdata_history_latest where REGISTRATION_NO =? and System_id =? and CLIENTID = ?");
		        		pstmt.setString(1, vehicleRegistrationNo);
		        		pstmt.setInt(2, systemId);
		        		pstmt.setInt(3, customerId);
		        		pstmt.executeUpdate();
		            }
					int categoryId = 0;
					pstmt = con.prepareStatement("select CategoryTypeForBill,Offset from AMS.dbo.System_Master where System_id=?");
					pstmt.setInt(1, systemId);
					rs = pstmt.executeQuery();
					if (rs.next()) {
						categoryId = rs.getInt("CategoryTypeForBill");
					}
		            raiseVehicleRegistrationCancellationAlert(con, vehicleRegistrationNo, userId, systemId, ltspName, "Cancellation", offset, customerId, custName,reason,date,categoryId);
		            tableList.add("Insert"+"##"+"AMS.dbo.EmailQueue");
		            message = "Asset " + vehicleRegistrationNo + " Un-Registered Successfully.";
		            try {
						cf.insertDataIntoAuditLogReport(sessionId, tableList, pageName, "DELETE", userId, serverName, systemId, customerId,"Un-Registered Vehicles");
					} catch (Exception e) {
						e.printStackTrace();
					}
		        }
		        //} 
		        con.commit();
		    } catch (Exception e) {
		        e.printStackTrace();
		        try {
		            if (con != null) con.rollback();
		        } catch (Exception ex) {
		            ex.printStackTrace();
		        }
		    } finally {
		        DBConnection.releaseConnectionToDB(con, pstmt, rs);
		        DBConnection.releaseConnectionToDB(null, pstmt1, null);
		        DBConnection.releaseConnectionToDB(null, pstmt2, null);
		        DBConnection.releaseConnectionToDB(null, pstmt6, rs6);
		    }
		    return message;
		}
		
		public int raiseVehicleRegistrationCancellationAlert(Connection con, String registrationNo, int UserId, int SystemId, String ltspName, String mailType, int offset, int client_id, String custName,String reason,String date,int categoryId) {
		    int inserted = 0;
		    PreparedStatement pstmt = null;
		    ResultSet rs = null;
		    final int alertType = 124;
		    //int categoryId = 0;
		    StringBuilder emailList = new StringBuilder();
		    String emailIdList = "";
		    SimpleDateFormat mmddyyyy = new SimpleDateFormat("MM/dd/yyyy HH:mm:ss");
		    SimpleDateFormat ddmmyyyy = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
		    String ltspAdminEmail = null;
		    try {
		        /*pstmt = con.prepareStatement("select CategoryTypeForBill from AMS.dbo.System_Master where System_id=?");
		        pstmt.setInt(1, SystemId);
		        rs = pstmt.executeQuery();
		        if (rs.next()) {
		            categoryId = rs.getInt("CategoryTypeForBill");
		        }
		        rs.close();
		        pstmt.close();*/
		        pstmt = con.prepareStatement("select EMAIL from CRC.dbo.BUSINESS_GROUP_MASTER Where ID=?");
		        pstmt.setInt(1, categoryId);
		        rs = pstmt.executeQuery();
		        while (rs.next()) {
		            String emailid = rs.getString("EMAIL");
		            Pattern p = Pattern.compile((".+@.+\\.[a-z]+"));
		            Matcher m = p.matcher(emailid);
		            boolean b = m.matches();
		            if (b == true) {
		                emailList.append(emailid + ",");
		            }
		        }
		        rs.close();
		        pstmt.close();
		        pstmt = con.prepareStatement(AdminStatements.GET_ASSOCIATED_EMAILID);
		        pstmt.setInt(1, SystemId);
		        pstmt.setInt(2, alertType);
		        pstmt.setInt(3, SystemId);
		        pstmt.setString(4, registrationNo);
		        rs = pstmt.executeQuery();
		        while (rs.next()) {
		           String emailid = rs.getString("EmailId");
		           Pattern p = Pattern.compile((".+@.+\\.[a-z]+"));
		            Matcher m = p.matcher(emailid);
		            boolean b = m.matches();
		            if (b == true) {
		                emailList.append(emailid + ",");
		            }
		        }
		        rs.close();
		        pstmt.close();
		       // String date = ddmmyyyy.format(mmddyyyy.parse(getLocalDateTime(mmddyyyy.format(new Date()), offset)));
		        emailIdList = emailList.substring(0, emailList.length() - 1);
		        String subject = "";
		        StringBuilder body = new StringBuilder();
		        if (mailType.equals("Registration")) {
		            subject = "Vehicle Registration Notification for " + registrationNo;
		            body.append("<html><body>" +
		                //Body for vehicle registration and cancellation
		                "<table border = 0 align=center width=100% height=50 bgcolor=#FFBF00>" + "<tr><td align=left><font style=font-family:arial size=5 bgcolor=#000000<b>Vehicle Registration Notification</b></font></td></tr>" + "</table>" + "<p><b>Greetings,</b></p>" + "<table>" + "<tr>" + "<td>We are pleased to inform you that vehicle number <b>" + registrationNo + "</b> has been registered successfully on " + date + " for the LTSP<b> " + ltspName + "</b> and Customer<b> " + custName + "</b>.</td>" + "<tr>" + "<td>Thank you for registering the vehicle.</td> " + "<tr><br><br><br></table>");
		        } else {
		            subject = "Vehicle Unregistration Notification for " + registrationNo;
		            body.append("<html><body>" +
		                //Body for vehicle registration and cancellation
		                "<table border = 0 align=center width=100% height=50 bgcolor=#FFBF00>" + "<tr><td align=left><font style=font-family:arial size=5 bgcolor=#000000<b>Vehicle Unregistration Notification</b></font></td></tr>" + "</table>" + "<p><b>Greetings,</b></p>" + "<table>" + "<tr>" + "<td>Vehicle number <b>" + registrationNo + "</b> has been unregistered successfully on  " + date + "  for the LTSP<b> " + ltspName + "</b> and Customer<b> " + custName + "</b>.<br>Reason for unregistration : <b>" +reason+ " </b>.</td>" + "<tr><br><br><br></table>");
		        }
		        //End of the message for mail
		        body.append("<tr><br><br><br><br><br><br><br><br><br><td align=left><font style=font-style:italic size=2 bgcolor=#4447A6<b>For any queries please write to <a href='mailto:t4uhelpdesk@telematics4u.com'>t4uhelpdesk@telematics4u.com</a></b></font></td>");
		        body.append("<tr><br><td align=left><font style=font-style:italic size=2 bgcolor=#4447A6<b>Please do not reply to this mail. This is an auto generated mail and replies to this email id are not attended too.</b></font></td>");
		        body.append("</body></html>");
		        pstmt = con.prepareStatement(AdminStatements.INSERT_INTO_EMAIL_QUEUE_VEHICLE_REG_AND_UNREG);
		        pstmt.setString(1, subject);
		        pstmt.setString(2, body.toString());
		        pstmt.setString(3, emailIdList);
		        pstmt.setInt(4, alertType);
		        pstmt.setInt(5, SystemId);
		        pstmt.setString(6, registrationNo.toUpperCase());
		        inserted = pstmt.executeUpdate();
		    } catch (Exception e) {
		        e.printStackTrace();
		    } finally {
		         //DBConnection.releaseConnectionToDB(con, pstmt, rs);
		    }
		    return inserted;
		}
		
		public String getUnitTypeCode(String unitNo, int systemId, Connection con) {
		    String unitTypeCode = null;
		    PreparedStatement pstmt = null;
		    ResultSet rs = null;
		    try {
		        pstmt = con.prepareStatement(AdminStatements.GET_UNIT_TYPE_CODE_FOR_MANAGE_ASSET);
		        pstmt.setString(1, unitNo);
		        pstmt.setInt(2, systemId);
		        rs = pstmt.executeQuery();
		        if (rs.next()) {
		            unitTypeCode = rs.getString("Unit_type_code");
		        }
		    } catch (Exception e) {
		        e.printStackTrace();
		    }
		    return unitTypeCode;
		}
		public int getUnitType(int SLNO, Connection con,String registrationNo, String unitNo,int systemId,int CustID,String offsetstr) {
		    int up3=0;
		    if(getUnitTypeCode(unitNo, systemId, con).equals("68")){
				try {
					PreparedStatement statement1 = con.prepareStatement(AdminStatements.INSERT_VEHICLE_IN_GPSDATA_LIVE_CANIQ);
					statement1.setInt(1, SLNO);
					statement1.setString(2, registrationNo);
					statement1.setString(3, unitNo);
					statement1.setInt(4, systemId);
					statement1.setInt(5, CustID);
					statement1.setString(6, offsetstr);
					up3 = statement1.executeUpdate();
					statement1.close();
				} catch (SQLException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
        	}	
		    return up3;
		}
		public String updateSimNumberInUnitMaster(Connection con, String unitNo, int systemId, String simNo) {
		    PreparedStatement pstmt = null;
		    PreparedStatement pstmt5 = null;
		    String message = "";
		    try {
		        pstmt = con.prepareStatement(AdminStatements.UPDATE_SIM_NUMBER_BASED_ON_UNIT_IN_ADMINISTRATOR);
		        pstmt.setString(1, simNo);
		        pstmt.setString(2, unitNo);
		        pstmt.setInt(3, systemId);
		        pstmt.executeUpdate();
		        pstmt5 = con.prepareStatement(AdminStatements.UPDATE_SIM_NUMBER_BASED_ON_UNIT_IN_AMS);
		        pstmt5.setString(1, simNo);
		        pstmt5.setString(2, unitNo);
		        pstmt5.setInt(3, systemId);
		        pstmt5.executeUpdate();
		    } catch (Exception e) {
		        e.printStackTrace();
		        try {
		            if (con != null) con.rollback();
		        } catch (Exception ex) {
		            ex.printStackTrace();
		        }
		    } finally {
		        DBConnection.releaseConnectionToDB(null, pstmt, null);
		        DBConnection.releaseConnectionToDB(null, pstmt5, null);
		    }
		    return message;
		}
		
		public boolean isUnitIsAssociatedToVehicle(Connection con, String vehicleNo, int systemId) {
		    boolean isAssociated = false;
		    PreparedStatement pstmt = null;
		    ResultSet rs = null;
		    try {
		        pstmt = con.prepareStatement("select Registration_no from AMS.dbo.Vehicle_association where Registration_no='" + vehicleNo + "' and System_id=" + systemId);
		        rs = pstmt.executeQuery();
		        if (rs.next()) {
		            isAssociated = true;
		        }
		    } catch (Exception e) {
		        e.printStackTrace();
		    } finally {
		        DBConnection.releaseConnectionToDB(null, pstmt, rs);
		    }
		    return isAssociated;
		}
		
		public String getLocalDateTime(String inputDate, int offSet) {
		    String retValue = inputDate;
		    Date convDate = null;
		    convDate = convertStringToDate(inputDate);
		    if (convDate != null) {
		        Calendar cal = Calendar.getInstance();
		        cal.setTime(convDate);
		        cal.add(Calendar.MINUTE, -offSet);
		        int day = cal.get(Calendar.DATE);
		        int y = cal.get(Calendar.YEAR);
		        int m = cal.get(Calendar.MONTH) + 1;
		        int h = cal.get(Calendar.HOUR_OF_DAY);
		        int mi = cal.get(Calendar.MINUTE);
		        int s = cal.get(Calendar.SECOND);
		        String yyyy = String.valueOf(y);
		        String month = String.valueOf(m > 9 ? String.valueOf(m) : "0" + String.valueOf(m));
		        String date = String.valueOf(day > 9 ? String.valueOf(day) : "0" + String.valueOf(day));
		        String hour = String.valueOf(h > 9 ? String.valueOf(h) : "0" + String.valueOf(h));
		        String minute = String.valueOf(mi > 9 ? String.valueOf(mi) : "0" + String.valueOf(mi));
		        String second = String.valueOf(s > 9 ? String.valueOf(s) : "0" + String.valueOf(s));
		        retValue = month + "/" + date + "/" + yyyy + " " + hour + ":" + minute + ":" + second;
		    }
		    return retValue;
		}
		
		public Date convertStringToDate(String inputDate) {
		    Date dDateTime = null;
		    SimpleDateFormat sdfFormatDate = new SimpleDateFormat("MM/dd/yyyy HH:mm:ss");
		    try {
		        if (inputDate != null && !inputDate.equals("")) {
		            dDateTime = sdfFormatDate.parse(inputDate);
		            java.sql.Timestamp timest = new java.sql.Timestamp(dDateTime.getTime());
		            dDateTime = timest;
		        }
		    } catch (Exception e) {
		        e.printStackTrace();
		    }
		    return dDateTime;
		}
		
		public JSONArray getOwnerNames(int systemid, int clientid, int userId) {
		    JSONArray jsonArray = new JSONArray();
		    JSONObject obj1 = new JSONObject();
		    Connection con = null;
		    PreparedStatement pstmt = null;
		    ResultSet rs = null;
		    try {
		        con = DBConnection.getConnectionToDB("AMS");
		        pstmt = con.prepareStatement(AdminStatements.GET_OWNER_NAMES);
		        pstmt.setInt(1, systemid);
		        pstmt.setInt(2, clientid);
		        rs = pstmt.executeQuery();
		        obj1.put("id", "0");
		        obj1.put("name", "NA");
		        jsonArray.put(obj1);
		        while (rs.next()) {
		            obj1 = new JSONObject();
		            obj1.put("name", rs.getString("OWNERNAME"));
		            obj1.put("id", rs.getString("OWNER_ID"));
		            obj1.put("ownerAddress", rs.getString("ADDRESS"));
		            obj1.put("ownerPhoneNo", rs.getString("MOBILE_NO"));
		            obj1.put("ownerEmailId", rs.getString("EMAIL_ID"));
		            jsonArray.put(obj1);
		        }
		    } catch (Exception e) {
		        e.printStackTrace();
		    } finally {
		        DBConnection.releaseConnectionToDB(con, pstmt, rs);
		    }
		    return jsonArray;
		}
		
		
		
		public JSONArray getServiceType(int SystemId,int customerIdlogin){
			JSONArray jsonArray = new JSONArray();
			JSONObject jsonObject = new JSONObject();
			Connection conAdmin=null;
			PreparedStatement pstmt=null;
			ResultSet rs=null;
			try{
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				
				conAdmin=DBConnection.getConnectionToDB("AMS");
				pstmt=conAdmin.prepareStatement(CommonStatements.GET_SERVICE_TYPE);
				pstmt.setInt(1, SystemId);
				//pstmt.setInt(2, customerIdlogin);
				rs=pstmt.executeQuery();
				while(rs.next()){
					jsonObject = new JSONObject();
					String type = rs.getString("DATA");
					int id      = rs.getInt("ID");
					jsonObject.put("Id", id);
					jsonObject.put("Type", type);
					jsonArray.put(jsonObject);				
				}
			}catch(Exception e){
				System.out.println("Error in getCustomer "+e.toString());
			}	
			finally{
				DBConnection.releaseConnectionToDB(conAdmin, pstmt, rs);
			}	
			return jsonArray;
		}
		
		
		
		public ArrayList<Object> getServiceTypeDetails(String servicetype,int customerid, int systemId,String startDate,String endDate,int offSet) {
			JSONArray ServiceTypeJsonArray = new JSONArray();
			JSONObject ServiceTypeJsonObject = new JSONObject();
			Connection conAdmin = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			int count=0;
			
			ArrayList < ReportHelper > reportsList = new ArrayList < ReportHelper > ();
			ArrayList < String > headersList = new ArrayList < String > ();
			ReportHelper finalreporthelper = new ReportHelper();
			ArrayList < Object > aslist = new ArrayList < Object > ();
			
			
			try {
				ServiceTypeJsonArray = new JSONArray();
				ServiceTypeJsonObject = new JSONObject();
				conAdmin = DBConnection.getConnectionToDB("AMS");
			 if(servicetype.equals("TAT"))
				{
				 headersList.add("SLNO");
				 headersList.add("Asset Number");
				 headersList.add("Park Name");
				 headersList.add("Plant Name");
				 headersList.add("Park In");
				 headersList.add("Plant In");
				 headersList.add("Plant Out");
				 headersList.add("Plant Out");
				 headersList.add("Shipment");
				 headersList.add("XML Data");
				 headersList.add("Status");
				 headersList.add("Date & Time");
				 headersList.add("Transport Vendor");
				 headersList.add("Trailer Type");
				 headersList.add("Total TAT");
				 headersList.add("Plant TAT");
				 headersList.add("Incoming Park TAT");
				 headersList.add("Outgoing Park TAT");
				 headersList.add("Trip Id");
				 headersList.add("Source Plant");
				 headersList.add("Source Plant Gate Out");
				 headersList.add("Destination Plant");
				 headersList.add("Destination Park In");
				 headersList.add("Destination Plant Gate In");
				 headersList.add("Enroute Distance");
				 headersList.add("Enroute Transit Time");
				 headersList.add("Enroute Stoppage Time");
				 headersList.add("Destination Plant Outside Wait Time");
				 headersList.add("Group Name");
				 headersList.add("Source");
				 headersList.add("Destination");
				 headersList.add("Shipment Received Date Time");
				 headersList.add("Asset Status");
				 headersList.add("% of WaitingTime");
				 headersList.add("% of RunningTime");
				 headersList.add("Shipment Actual Start Date & Time");
				 headersList.add("Shipment Start Date & Time");
				 headersList.add("Data Transfer Status");
				 headersList.add(" Shipment Status");
				 headersList.add("Schedule Trip Start Date Time");
				 headersList.add("Shipment Repushed");
				 headersList.add("Shipment Close Date Time");
				 headersList.add("Service Provider");
				 headersList.add("Unit Number");
				 headersList.add("Source ETA");
				 headersList.add("Destination ETA");
				 headersList.add("Closed Type");
				 headersList.add("Closed Time");
					headersList.add("TripStartTime");
					headersList.add("ReceivedTime");
					headersList.add("Sequence");
					headersList.add("LocationId");
					headersList.add("Latitude");
					headersList.add("Longitude");
					headersList.add("PushStatus");
					headersList.add("InTime");
					headersList.add("OutTime");
			        headersList.add("RePushed");
				 
				    pstmt = conAdmin.prepareStatement(AdminStatements.GET_MLL_TAT_REPORT_DETAILS1);
				    //pstmt.setInt(1,offSet);
				    //pstmt.setInt(2,offSet);
				    //pstmt.setInt(3,offSet);
				    //pstmt.setInt(4,offSet);
				    pstmt.setString(1,startDate);
				    pstmt.setString(2,endDate);
				    pstmt.setInt(3,systemId);
				    pstmt.setInt(4,customerid);
				    
				    rs = pstmt.executeQuery();
				    
				    while (rs.next()) {	
						count++;
						String vehicleNumber    = rs.getString("REGISTRATION_NO");
						String parkName         = rs.getString("PARK_Name");
						String plantName        = rs.getString("PLANT_Name");
						String parkIn           = rs.getString("PARK_IN");
						String plantIn          = rs.getString("PLANT_IN");
						String plantOut         = rs.getString("PLANT_OUT");
						String parkOut          = rs.getString("PARK_OUT");
						
						String transporter      = rs.getString("OWNER_NAME");
						String trailerType      = rs.getString("TRAILER_TYPE");
						String tripTat          = rs.getString("TRIP_TAT");
						String plantTat         = rs.getString("PLANT_TAT");
						String waitingInTat     = rs.getString("WAITING_IN_TAT");
						String waitingOutTat    = rs.getString("WAITING_OUT_TAT");
						String groupName    = rs.getString("GROUP_NAME");
						
						if(parkName==null)
						{
							parkName="";
						}
						if(plantName==null)
						{
							plantName="";
						}
						if(parkIn==null)
						{
							parkIn="";
						}   
						if(plantIn==null)
						{
							plantIn="";
						} 
						if(plantOut==null)
						{
							plantOut="";
						} 
						if(parkOut==null)
						{
							parkOut="";
						} 
						ServiceTypeJsonObject = new JSONObject();
						ArrayList < Object > informationList = new ArrayList < Object > ();
						ReportHelper reporthelper = new ReportHelper();
						ServiceTypeJsonObject.put("slnoIndex", count);
						informationList.add(count);
						ServiceTypeJsonObject.put("assetNumber", vehicleNumber);
						informationList.add(vehicleNumber);
						ServiceTypeJsonObject.put("parkName", parkName);
						informationList.add(parkName);
						ServiceTypeJsonObject.put("plantName", plantName);
						informationList.add(plantName);
						ServiceTypeJsonObject.put("parkIn", parkIn);
						informationList.add(parkIn);
						ServiceTypeJsonObject.put("plantIn", plantIn);
						informationList.add(plantIn);
						ServiceTypeJsonObject.put("plantOut",plantOut);
						informationList.add(plantOut);
						ServiceTypeJsonObject.put("parkOut", parkOut);
						informationList.add(parkOut);
						
						ServiceTypeJsonObject.put("shipment", "");
						informationList.add("");
						ServiceTypeJsonObject.put("data", "");
						informationList.add("");
						ServiceTypeJsonObject.put("status", "");
						informationList.add("");
						ServiceTypeJsonObject.put("triggeredTime", "");
						informationList.add("");
						
						
						tripTat=Integer.parseInt(tripTat)/60%24 + ":" + Integer.parseInt(tripTat)%60+ ":" + (Integer.parseInt(tripTat) / 1000) % 60;
						plantTat=Integer.parseInt(plantTat)/60%24 + ":" + Integer.parseInt(plantTat)%60+ ":" + (Integer.parseInt(plantTat) / 1000) % 60;
						waitingInTat=Integer.parseInt(waitingInTat)/60%24 + ":" + Integer.parseInt(waitingInTat)%60+ ":" + (Integer.parseInt(waitingInTat) / 1000) % 60;
						waitingOutTat=Integer.parseInt(waitingOutTat)/60%24 + ":" + Integer.parseInt(waitingOutTat)%60+ ":" + (Integer.parseInt(waitingOutTat) / 1000) % 60;
						
						
						ServiceTypeJsonObject.put("transporter", transporter);
						informationList.add(transporter);
						ServiceTypeJsonObject.put("trailerType", trailerType);
						informationList.add(trailerType);
						ServiceTypeJsonObject.put("totalTat", tripTat);
						informationList.add(tripTat);
						ServiceTypeJsonObject.put("plantTat", plantTat);
						informationList.add(plantTat);
						ServiceTypeJsonObject.put("incomingParkTAT", waitingInTat);
						informationList.add(waitingInTat);
						ServiceTypeJsonObject.put("outgoingParkTAT", waitingOutTat);
						informationList.add(waitingOutTat);
						
						ServiceTypeJsonObject.put("tripId", "");
						informationList.add("");
						ServiceTypeJsonObject.put("sourceplantName", "");
						informationList.add("");
						ServiceTypeJsonObject.put("sourcePlantOut", "");
						informationList.add("");
						ServiceTypeJsonObject.put("destinationPlant", "");
						informationList.add("");
						ServiceTypeJsonObject.put("destinationParkIn", "");
						informationList.add("");
						ServiceTypeJsonObject.put("destinationPlantIn", "");
						informationList.add("");
						ServiceTypeJsonObject.put("enrouteDistance", "");
						informationList.add("");
						ServiceTypeJsonObject.put("enrouteTransitTime", "");
						informationList.add("");
						ServiceTypeJsonObject.put("enrouteStoppageTime", "");
						informationList.add("");
						ServiceTypeJsonObject.put("destinationWaitingOutTat", "");
						informationList.add("");
						ServiceTypeJsonObject.put("groupName", groupName);
						informationList.add(groupName);
						ServiceTypeJsonObject.put("source", "");
						informationList.add("");
						ServiceTypeJsonObject.put("destination", "");
						informationList.add("");
						ServiceTypeJsonObject.put("ShipmentReceivedDateTime", "");
						informationList.add("");
						ServiceTypeJsonObject.put("AssetStatus","");
						informationList.add("");
						ServiceTypeJsonObject.put("waitingTime","");
						informationList.add("");
						ServiceTypeJsonObject.put("runningTime","");
						informationList.add("");
						ServiceTypeJsonObject.put("ShipmentActualStartDateTime", "");
						informationList.add("");
						ServiceTypeJsonObject.put("ShipmentStartDateTime", "");
						informationList.add("");
						ServiceTypeJsonObject.put("DataTransferStatus", "");
						informationList.add("");
						ServiceTypeJsonObject.put("ShipmentStatus", "");
						informationList.add("");
						ServiceTypeJsonObject.put("ScheduleTripStartDateTime", "");
						informationList.add("");
						ServiceTypeJsonObject.put("ShipmentRepushed", "");
						informationList.add("");
						ServiceTypeJsonObject.put("ShipmentCloseDateTime", "");
						informationList.add("");
						ServiceTypeJsonObject.put("ServiceProvider","");
						informationList.add("");
						ServiceTypeJsonObject.put("UnitNo","");
						informationList.add("");
						ServiceTypeJsonObject.put("SourceETA", "");
						informationList.add("");
						ServiceTypeJsonObject.put("DestinationETA", "");
						informationList.add("");
						ServiceTypeJsonObject.put("ClosedType", "");
						informationList.add("");
						ServiceTypeJsonObject.put("ClosedTime", "");
						informationList.add("");
						ServiceTypeJsonObject.put("tripStartTime", "");
						informationList.add("");
						ServiceTypeJsonObject.put("receivedTime", "");
						informationList.add("");
						ServiceTypeJsonObject.put("sequence", "");
						informationList.add("");
						ServiceTypeJsonObject.put("locationId", "");
						informationList.add("");
						ServiceTypeJsonObject.put("lat", "");
						informationList.add("");
						ServiceTypeJsonObject.put("longi", "");
						informationList.add("");
						ServiceTypeJsonObject.put("pushStatus", "");
						informationList.add("");
						ServiceTypeJsonObject.put("inTime", "");
						informationList.add("");
						ServiceTypeJsonObject.put("outTime", "");
						informationList.add("");
						ServiceTypeJsonObject.put("rePushed", "");
						informationList.add("");
						ServiceTypeJsonArray.put(ServiceTypeJsonObject);
						reporthelper.setInformationList(informationList);
						reportsList.add(reporthelper);
					}
				    
				    
				}
			 else if(servicetype.equals("ENROUTE_TAT"))
				{
				 DecimalFormat df = new DecimalFormat("0.##");
				 headersList.add("SLNO");
				 headersList.add("Asset Number");
				 headersList.add("Park Name");
				 headersList.add("Plant Name");
				 headersList.add("Park In");
				 headersList.add("Plant In");
				 headersList.add("Plant Out");
				 headersList.add("Plant Out");
				 headersList.add("Shipment");
				 headersList.add("XML Data");
				 headersList.add("Status");
				 headersList.add("Date & Time");
				 headersList.add("Transport Vendor");
				 headersList.add("Trailer Type");
				 headersList.add("Total TAT");
				 headersList.add("Plant TAT");
				 headersList.add("Incoming Park TAT");
				 headersList.add("Outgoing Park TAT");
				 headersList.add("Trip Id");
				 headersList.add("Source Plant");
				 headersList.add("Source Plant Gate Out");
				 headersList.add("Destination Plant");
				 headersList.add("Destination Park In");
				 headersList.add("Destination Plant Gate In");
				 headersList.add("Enroute Distance");
				 headersList.add("Enroute Transit Time");
				 headersList.add("Enroute Stoppage Time");
				 headersList.add("Destination Plant Outside Wait Time");
				 headersList.add("Group Name");
				 headersList.add("Source");
				 headersList.add("Destination");
				 headersList.add("Shipment Received Date Time");
				 headersList.add("Asset Status");
				 headersList.add("% of WaitingTime");
				 headersList.add("% of RunningTime");
				 headersList.add("Shipment Actual Start Date & Time");
				 headersList.add("Shipment Start Date & Time");
				 headersList.add("Data Transfer Status");
				 headersList.add(" Shipment Status");
				 headersList.add("Schedule Trip Start Date Time");
				 headersList.add("Shipment Repushed");
				 headersList.add("Shipment Close Date Time");
				 headersList.add("Service Provider");
				 headersList.add("Unit Number");
				 headersList.add("Source ETA");
				 headersList.add("Destination ETA");					
				 headersList.add("Closed Type");
				 headersList.add("Closed Time");
					headersList.add("TripStartTime");
					headersList.add("ReceivedTime");
					headersList.add("Sequence");
					headersList.add("LocationId");
					headersList.add("Latitude");
					headersList.add("Longitude");
					headersList.add("PushStatus");
					headersList.add("InTime");
					headersList.add("OutTime");
			        headersList.add("RePushed");
				 
				 if(systemId==214){
					 pstmt = conAdmin.prepareStatement(AdminStatements.GET_ENROUTE_TAT_REPORT_DETAILS_SHIPX);
				 }
				 else {
				    pstmt = conAdmin.prepareStatement(AdminStatements.GET_ENROUTE_TAT_REPORT_DETAILS);
				 }
				    pstmt.setString(1,startDate);
					pstmt.setString(2,endDate);
					pstmt.setInt(3,systemId);
				    pstmt.setInt(4,customerid);
				    rs = pstmt.executeQuery();
				    
				    while (rs.next()) {	
						count++;
						String vehicleNumber               = rs.getString("REGISTRATION_NO");
						String tripId                      = rs.getString("TRIP_ID");
						String transporter                 = rs.getString("OWNER_NAME");
						String shipment                    = rs.getString("SHIPMENNT_ID");
						String sourceplantName             = rs.getString("SOURCE_PLANT");
						String sourcePlantOut              = rs.getString("SOURCE_PLANT_OUT");
						String destinationPlant            = rs.getString("DESTINATION_PLANT");
						String destinationParkIn           = rs.getString("DESTINATION_PLANT_PARK_IN");
						String destinationPlantIn          = rs.getString("DESTINATION_PLANT_GATE_IN");
						double enrouteDistance             = rs.getDouble("ENROUTE_DISTANCE");
						String enrouteTransitTime          = rs.getString("ENROUTE_TRANIT_TIME");
						String enrouteStoppageTime         = rs.getString("ENROUTE_STOPPAGE_TIME");
						String destinationWaitingOutTat    = rs.getString("DESTINATION_PLANT_OUTSIDE_WAITING_TIME");
						String trailerType                 = rs.getString("TRAILER_TYPE");
						
				      
						
						double runningTime;
						double waitingTime;
							
							if((!enrouteTransitTime.equals("") && !(enrouteTransitTime=="0")) && (!enrouteStoppageTime.equals("") && !(enrouteStoppageTime=="0"))){
							float stopageTime                 = Integer.parseInt(enrouteStoppageTime);
							float transistTime                 = Integer.parseInt(enrouteTransitTime);
							float totalTransitTime             =stopageTime+transistTime;
					        
							   waitingTime = Math.round(((stopageTime/totalTransitTime)*100)*100.0)/100.0;
							   runningTime = Math.round(((transistTime/totalTransitTime)*100)*100.0)/100.0;
							}
							else{
								
								waitingTime=0;
								runningTime=0;
							}
						
						ServiceTypeJsonObject = new JSONObject();
						ArrayList < Object > informationList = new ArrayList < Object > ();
						ReportHelper reporthelper = new ReportHelper();
						ServiceTypeJsonObject.put("slnoIndex", count);
						informationList.add(count);
						ServiceTypeJsonObject.put("assetNumber", vehicleNumber);
						informationList.add(vehicleNumber);
						ServiceTypeJsonObject.put("parkName", "");
						informationList.add("");
						ServiceTypeJsonObject.put("plantName", "");
						informationList.add("");
						ServiceTypeJsonObject.put("parkIn", "");
						informationList.add("");
						ServiceTypeJsonObject.put("plantIn", "");
						informationList.add("");
						ServiceTypeJsonObject.put("plantOut","");
						informationList.add("");
						ServiceTypeJsonObject.put("parkOut", "");
						informationList.add("");
						ServiceTypeJsonObject.put("shipment", shipment);
						informationList.add(shipment);
						ServiceTypeJsonObject.put("data", "");
						informationList.add("");
						ServiceTypeJsonObject.put("status", "");
						informationList.add("");
						ServiceTypeJsonObject.put("triggeredTime", "");
						informationList.add("");
						ServiceTypeJsonObject.put("transporter", transporter);
						informationList.add(transporter);
						ServiceTypeJsonObject.put("trailerType", trailerType);
						informationList.add(trailerType);
						ServiceTypeJsonObject.put("tripTat", "");
						informationList.add("");
						ServiceTypeJsonObject.put("plantTat", "");
						informationList.add("");
						ServiceTypeJsonObject.put("incomingParkTAT","");
						informationList.add("");
						ServiceTypeJsonObject.put("outgoingParkTAT","");
						informationList.add("");
						
						
						if(!enrouteTransitTime.equals(""))
						{
						enrouteTransitTime=Integer.parseInt(enrouteTransitTime)/60 + ":" + Integer.parseInt(enrouteTransitTime)%60;
				         }
				        if(!enrouteStoppageTime.equals(""))
				        {
						enrouteStoppageTime=Integer.parseInt(enrouteStoppageTime)/60 + ":" + Integer.parseInt(enrouteStoppageTime)%60;
				         }
			            if(!destinationWaitingOutTat.equals(""))
			            {
						destinationWaitingOutTat=Integer.parseInt(destinationWaitingOutTat)/60 + ":" + Integer.parseInt(destinationWaitingOutTat)%60;
			             }
						
						ServiceTypeJsonObject.put("tripId", tripId);
						informationList.add(tripId);
						ServiceTypeJsonObject.put("sourceplantName", sourceplantName);
						informationList.add(sourceplantName);
						ServiceTypeJsonObject.put("sourcePlantOut", sourcePlantOut);
						informationList.add(sourcePlantOut);
						ServiceTypeJsonObject.put("destinationPlant", destinationPlant);
						informationList.add(destinationPlant);
						ServiceTypeJsonObject.put("destinationParkIn", destinationParkIn);
						informationList.add(destinationParkIn);
						ServiceTypeJsonObject.put("destinationPlantIn", destinationPlantIn);
						informationList.add(destinationPlantIn);
						ServiceTypeJsonObject.put("enrouteDistance", df.format(enrouteDistance));
						informationList.add(df.format(enrouteDistance));
						ServiceTypeJsonObject.put("enrouteTransitTime", enrouteTransitTime);
						informationList.add(enrouteTransitTime);
						ServiceTypeJsonObject.put("enrouteStoppageTime", enrouteStoppageTime);
						informationList.add(enrouteStoppageTime);
						ServiceTypeJsonObject.put("destinationWaitingOutTat", destinationWaitingOutTat);
						informationList.add(destinationWaitingOutTat);
						ServiceTypeJsonObject.put("groupName", "");
						informationList.add("");
						ServiceTypeJsonObject.put("source", "");
						informationList.add("");
						ServiceTypeJsonObject.put("destination", "");
						informationList.add("");
						ServiceTypeJsonObject.put("ShipmentReceivedDateTime", "");
						informationList.add("");
						ServiceTypeJsonObject.put("AssetStatus","");
						informationList.add("");
						ServiceTypeJsonObject.put("waitingTime",waitingTime);
						informationList.add(waitingTime);
						ServiceTypeJsonObject.put("runningTime",runningTime);
						informationList.add(runningTime);
						ServiceTypeJsonObject.put("ShipmentActualStartDateTime", "");
						informationList.add("");
						ServiceTypeJsonObject.put("ShipmentStartDateTime", "");
						informationList.add("");
						ServiceTypeJsonObject.put("DataTransferStatus", "");
						informationList.add("");
						ServiceTypeJsonObject.put("ShipmentStatus", "");
						informationList.add("");
						ServiceTypeJsonObject.put("ScheduleTripStartDateTime", "");
						informationList.add("");
						ServiceTypeJsonObject.put("ShipmentRepushed", "");
						informationList.add("");
						ServiceTypeJsonObject.put("ShipmentCloseDateTime", "");
						informationList.add("");
						ServiceTypeJsonObject.put("ServiceProvider","");
						informationList.add("");
						ServiceTypeJsonObject.put("UnitNo","");
						informationList.add("");
						ServiceTypeJsonObject.put("SourceETA", "");
						informationList.add("");
						ServiceTypeJsonObject.put("DestinationETA", "");
						informationList.add("");
						ServiceTypeJsonObject.put("ClosedType", "");
						informationList.add("");
						ServiceTypeJsonObject.put("ClosedTime", "");
						informationList.add("");
						ServiceTypeJsonObject.put("tripStartTime", "");
						informationList.add("");
						ServiceTypeJsonObject.put("receivedTime", "");
						informationList.add("");
						ServiceTypeJsonObject.put("sequence", "");
						informationList.add("");
						ServiceTypeJsonObject.put("locationId", "");
						informationList.add("");
						ServiceTypeJsonObject.put("lat", "");
						informationList.add("");
						ServiceTypeJsonObject.put("longi", "");
						informationList.add("");
						ServiceTypeJsonObject.put("pushStatus", "");
						informationList.add("");
						ServiceTypeJsonObject.put("inTime", "");
						informationList.add("");
						ServiceTypeJsonObject.put("outTime", "");
						informationList.add("");
						ServiceTypeJsonObject.put("rePushed", "");
						informationList.add("");
						
						ServiceTypeJsonArray.put(ServiceTypeJsonObject);
						reporthelper.setInformationList(informationList);
						reportsList.add(reporthelper);
					}
				    
				    
				}
			 else if(servicetype.equals("X7") || servicetype.equals("TDBAC"))
				{
				 headersList.add("SLNO");
				 headersList.add("Asset Number");
				 headersList.add("Park Name");
				 headersList.add("Plant Name");
				 headersList.add("Park In");
				 headersList.add("Plant In");
				 headersList.add("Plant Out");
				 headersList.add("Plant Out");
				 headersList.add("Shipment");
				 headersList.add("XML Data");
				 headersList.add("Status");
				 headersList.add("Date & Time");
				 headersList.add("Transport Vendor");
				 headersList.add("Trailer Type");
				 headersList.add("Total TAT");
				 headersList.add("Plant TAT");
				 headersList.add("Incoming Park TAT");
				 headersList.add("Outgoing Park TAT");
				 headersList.add("Trip Id");
				 headersList.add("Source Plant");
				 headersList.add("Source Plant Gate Out");
				 headersList.add("Destination Plant");
				 headersList.add("Destination Park In");
				 headersList.add("Destination Plant Gate In");
				 headersList.add("Enroute Distance");
				 headersList.add("Enroute Transit Time");
				 headersList.add("Enroute Stoppage Time");
				 headersList.add("Destination Plant Outside Wait Time");
				 headersList.add("Group Name");
				 headersList.add("Source");
				 headersList.add("Destination");
				 headersList.add("Shipment Received Date Time");
				 headersList.add("Asset Status");
				 headersList.add("% of WaitingTime");
				 headersList.add("% of RunningTime");
				 headersList.add("Shipment Actual Start Date & Time");
				 headersList.add("Shipment Start Date & Time");
				 headersList.add("Data Transfer Status");
				 headersList.add(" Shipment Status");
				 headersList.add("Schedule Trip Start Date Time");
				 headersList.add("Shipment Repushed");
				 headersList.add("Shipment Close Date & Time");
				 headersList.add("Service Provider");
				 headersList.add("Unit Number");
				 headersList.add("Source ETA");
				 headersList.add("Destination ETA");
				 headersList.add("Closed Type");
				 headersList.add("Pushed Time");
				 headersList.add("Closed Time");
					headersList.add("TripStartTime");
					headersList.add("ReceivedTime");
					headersList.add("Sequence");
					headersList.add("LocationId");
					headersList.add("Latitude");
					headersList.add("Longitude");
					headersList.add("PushStatus");
					headersList.add("InTime");
					headersList.add("OutTime");
			        headersList.add("RePushed");
				 
					
					if(servicetype.equals("TDBAC"))
					{
				    pstmt = conAdmin.prepareStatement(AdminStatements.GET_SERVICE_TYPE_DETAILS_FOR_TDBAC);
					}
					else
					{
						pstmt = conAdmin.prepareStatement(AdminStatements.GET_SERVICE_TYPE_DETAILS_FOR_X7);
					}
				    pstmt.setInt(1, offSet);
				    pstmt.setInt(2,systemId);
				    pstmt.setInt(3,customerid);
				    pstmt.setString(4,servicetype);
				    pstmt.setString(5,startDate);
				    pstmt.setString(6,endDate);
				    
				    rs = pstmt.executeQuery();
				    
				    while (rs.next()) {	
						count++;
						 String shipment;
						ServiceTypeJsonObject = new JSONObject();
						shipment=getShipmentId(rs.getString("DATA"));
						ArrayList < Object > informationList = new ArrayList < Object > ();
						ReportHelper reporthelper = new ReportHelper();
						
						ServiceTypeJsonObject.put("slnoIndex", count);
						informationList.add(count);
						ServiceTypeJsonObject.put("assetNumber", rs.getString("REGISTRATION_NO"));
						informationList.add(rs.getString("REGISTRATION_NO"));
						ServiceTypeJsonObject.put("parkName", "");
						informationList.add("");
						ServiceTypeJsonObject.put("plantName", "");
						informationList.add("");
						ServiceTypeJsonObject.put("parkIn", "");
						informationList.add("");
						ServiceTypeJsonObject.put("plantIn", "");
						informationList.add("");
						ServiceTypeJsonObject.put("plantOut", "");
						informationList.add("");
						ServiceTypeJsonObject.put("parkOut", "");
						informationList.add("");
						ServiceTypeJsonObject.put("shipment", shipment);
						informationList.add(shipment);
						ServiceTypeJsonObject.put("data", rs.getString("DATA"));
						informationList.add(rs.getString("DATA"));
						ServiceTypeJsonObject.put("status", "");
						informationList.add("");
						if(servicetype.equals("TDBAC"))
						{
						ServiceTypeJsonObject.put("triggeredTime", "");
						informationList.add("");
						}
						else{
						ServiceTypeJsonObject.put("triggeredTime", rs.getString("EventTime"));
						informationList.add(rs.getString("EventTime"));
						}
						ServiceTypeJsonObject.put("transporter", "");
						informationList.add("");
						ServiceTypeJsonObject.put("trailerType", "");
						informationList.add("");
						ServiceTypeJsonObject.put("tripTat", "");
						informationList.add("");
						ServiceTypeJsonObject.put("plantTat", "");
						informationList.add("");
						ServiceTypeJsonObject.put("incomingParkTAT","");
						informationList.add("");
						ServiceTypeJsonObject.put("outgoingParkTAT","");
						informationList.add("");
				
						ServiceTypeJsonObject.put("tripId", "");
						informationList.add("");
						ServiceTypeJsonObject.put("sourceplantName", "");
						informationList.add("");
						ServiceTypeJsonObject.put("sourcePlantOut", "");
						informationList.add("");
						ServiceTypeJsonObject.put("destinationPlant", "");
						informationList.add("");
						ServiceTypeJsonObject.put("destinationParkIn", "");
						informationList.add("");
						ServiceTypeJsonObject.put("destinationPlantIn", "");
						informationList.add("");
						ServiceTypeJsonObject.put("enrouteDistance", "");
						informationList.add("");
						ServiceTypeJsonObject.put("enrouteTransitTime", "");
						informationList.add("");
						ServiceTypeJsonObject.put("enrouteStoppageTime", "");
						informationList.add("");
						ServiceTypeJsonObject.put("destinationWaitingOutTat", "");
						informationList.add("");
						ServiceTypeJsonObject.put("groupName", "");
						informationList.add("");
						ServiceTypeJsonObject.put("source", "");
						informationList.add("");
						ServiceTypeJsonObject.put("destination", "");
						informationList.add("");
						ServiceTypeJsonObject.put("ShipmentReceivedDateTime", "");
						informationList.add("");
						ServiceTypeJsonObject.put("AssetStatus","");
						informationList.add("");
						ServiceTypeJsonObject.put("waitingTime","");
						informationList.add("");
						ServiceTypeJsonObject.put("runningTime","");
						informationList.add("");
						ServiceTypeJsonObject.put("ShipmentActualStartDateTime", "");
						informationList.add("");
						ServiceTypeJsonObject.put("ShipmentStartDateTime", "");
						informationList.add("");
						ServiceTypeJsonObject.put("DataTransferStatus", rs.getString("RESPONSE"));
						informationList.add(rs.getString("RESPONSE"));
						ServiceTypeJsonObject.put("ShipmentStatus", "");
						informationList.add("");
						ServiceTypeJsonObject.put("ScheduleTripStartDateTime", "");
						informationList.add("");
						ServiceTypeJsonObject.put("ShipmentRepushed", "");
						informationList.add("");
						if(servicetype.equals("TDBAC"))
						{
							ServiceTypeJsonObject.put("ShipmentCloseDateTime", rs.getString("EventTime"));
							informationList.add(rs.getString("EventTime"));
						}
						else{
							ServiceTypeJsonObject.put("ShipmentCloseDateTime", "");
							informationList.add("");
						}
						ServiceTypeJsonObject.put("ServiceProvider","");
						informationList.add("");
						ServiceTypeJsonObject.put("UnitNo","");
						informationList.add("");
						ServiceTypeJsonObject.put("SourceETA", "");
						informationList.add("");
						ServiceTypeJsonObject.put("DestinationETA", "");
						informationList.add("");
						ServiceTypeJsonObject.put("ClosedType", "");
						informationList.add("");
						if(servicetype.equals("TDBAC"))
						{	if(rs.getString("TDBAC_PUSH_TIME")!=null){
								ServiceTypeJsonObject.put("ClosedTime", rs.getString("TDBAC_PUSH_TIME"));
								informationList.add(rs.getString("TDBAC_PUSH_TIME"));
							}else{
								ServiceTypeJsonObject.put("ClosedTime", "");
								informationList.add("");	
							}
						}else{
							ServiceTypeJsonObject.put("ClosedTime", "");
							informationList.add("");
						}
						ServiceTypeJsonObject.put("tripStartTime", "");
						informationList.add("");
						ServiceTypeJsonObject.put("receivedTime", "");
						informationList.add("");
						ServiceTypeJsonObject.put("sequence", "");
						informationList.add("");
						ServiceTypeJsonObject.put("locationId", "");
						informationList.add("");
						ServiceTypeJsonObject.put("lat", "");
						informationList.add("");
						ServiceTypeJsonObject.put("longi", "");
						informationList.add("");
						ServiceTypeJsonObject.put("pushStatus", "");
						informationList.add("");
						ServiceTypeJsonObject.put("inTime", "");
						informationList.add("");
						ServiceTypeJsonObject.put("outTime", "");
						informationList.add("");
						ServiceTypeJsonObject.put("rePushed", "");
						informationList.add("");
						ServiceTypeJsonArray.put(ServiceTypeJsonObject);
						reporthelper.setInformationList(informationList);
						reportsList.add(reporthelper);
					}
				    
				    
				}
				
				else if(servicetype.equals("SHIPMENT/X6"))
				{	
					headersList.add("SLNO");
					 headersList.add("Asset Number");
					 headersList.add("Park Name");
					 headersList.add("Plant Name");
					 headersList.add("Park In");
					 headersList.add("Plant In");
					 headersList.add("Plant Out");
					 headersList.add("Plant Out");
					 headersList.add("Shipment");
					 headersList.add("XML Data");
					 headersList.add("Status");
					 headersList.add("Date & Time");
					 headersList.add("Transport Vendor");
					 headersList.add("Trailer Type");
					 headersList.add("Total TAT");
					 headersList.add("Plant TAT");
					 headersList.add("Incoming Park TAT");
					 headersList.add("Outgoing Park TAT");
					 headersList.add("Trip Id");
					 headersList.add("Source Plant");
					 headersList.add("Source Plant Gate Out");
					 headersList.add("Destination Plant");
					 headersList.add("Destination Park In");
					 headersList.add("Destination Plant Gate In");
					 headersList.add("Enroute Distance");
					 headersList.add("Enroute Transit Time");
					 headersList.add("Enroute Stoppage Time");
					 headersList.add("Destination Plant Outside Wait Time");
					 headersList.add("Group Name");
					 headersList.add("Source");
					 headersList.add("Destination");
					 headersList.add("Shipment Received Date Time");
					 headersList.add("Asset Status");
					 headersList.add("% of WaitingTime");
					 headersList.add("% of RunningTime");
					 headersList.add("Shipment Actual Start Date & Time");
					 headersList.add("Shipment Start Date & Time");
					 headersList.add("Data Transfer Status");
					 headersList.add(" Shipment Status");
					 headersList.add("Schedule Trip Start Date Time");
					 headersList.add("Shipment Repushed");
					 headersList.add("Shipment Close Date Time");
					 headersList.add("Service Provider");
					 headersList.add("Unit Number");
					 headersList.add("Source ETA");
					 headersList.add("Destination ETA");					
					 headersList.add("Closed Type");
					 headersList.add("Closed Time");
						headersList.add("TripStartTime");
						headersList.add("ReceivedTime");
						headersList.add("Sequence");
						headersList.add("LocationId");
						headersList.add("Latitude");
						headersList.add("Longitude");
						headersList.add("PushStatus");
						headersList.add("InTime");
						headersList.add("OutTime");
				        headersList.add("RePushed");
					
					pstmt = conAdmin.prepareStatement(AdminStatements.GET_SHIPMENT_X6_DETAILS);
					pstmt.setInt(1,offSet);
					pstmt.setInt(2,systemId);
					pstmt.setInt(3,customerid);
					pstmt.setString(4,startDate);
					pstmt.setString(5,endDate);
					
					 rs = pstmt.executeQuery();
					    
					    while (rs.next()) {	
							count++;
							ServiceTypeJsonObject = new JSONObject();
							String vehicleNumber  = rs.getString("ASSET_NUMBER");
							String shipment       = rs.getString("SHIPMENNT_ID");
							String tripId         = rs.getString("TRIP_ID");
							String locationId     = rs.getString("LOCATION_ID");
							String sequence       = rs.getString("SEQUENCE");
							double lat            = rs.getDouble("LATITUDE");
							double longi          = rs.getDouble("LONGITUDE");
							String pushStatus     = rs.getString("PUSH_STATUS");
							String inTime         = rs.getString("STOP_IN_TIME");
							String outTime        = rs.getString("STOP_OUT_TIME");
							String tripStartTime  = rs.getString("TRIP_START_TIME");
							String receivedTime   = rs.getString("RECEIVED_TIME");
							String status         = rs.getString("STATUS");
							String closedTime     = rs.getString("TRIP_END_TIME");
							String rePushed       = rs.getString("RE_PUSHED");
							ArrayList < Object > informationList = new ArrayList < Object > ();
							ReportHelper reporthelper = new ReportHelper();
							
							if(inTime==null)
							{
								inTime="";
							}
							if(outTime==null)
							{
								outTime="";
							}
							if(closedTime==null)
							{
								closedTime="";
							}   
							ServiceTypeJsonObject.put("slnoIndex", count);
							informationList.add(count);
							ServiceTypeJsonObject.put("assetNumber", vehicleNumber);
							informationList.add(vehicleNumber);
							ServiceTypeJsonObject.put("parkName", "");
							informationList.add("");
							ServiceTypeJsonObject.put("plantName", "");
							informationList.add("");
							ServiceTypeJsonObject.put("parkIn", "");
							informationList.add("");
							ServiceTypeJsonObject.put("plantIn", "");
							informationList.add("");
							ServiceTypeJsonObject.put("plantOut","");
							informationList.add("");
							ServiceTypeJsonObject.put("parkOut", "");
							informationList.add("");
							ServiceTypeJsonObject.put("shipment", shipment);
							informationList.add(shipment);
							ServiceTypeJsonObject.put("data", "");
							informationList.add("");
							ServiceTypeJsonObject.put("status", status);
							informationList.add(status);
							ServiceTypeJsonObject.put("triggeredTime", "");
							informationList.add("");
							ServiceTypeJsonObject.put("transporter", "");
							informationList.add("");
							ServiceTypeJsonObject.put("trailerType", "");
							informationList.add("");
							ServiceTypeJsonObject.put("tripTat", "");
							informationList.add("");
							ServiceTypeJsonObject.put("plantTat", "");
							informationList.add("");
							ServiceTypeJsonObject.put("incomingParkTAT","");
							informationList.add("");
							ServiceTypeJsonObject.put("outgoingParkTAT","");
							informationList.add("");
							ServiceTypeJsonObject.put("tripId", tripId);
							informationList.add(tripId);
							ServiceTypeJsonObject.put("sourceplantName", "");
							informationList.add("");
							ServiceTypeJsonObject.put("sourcePlantOut", "");
							informationList.add("");
							ServiceTypeJsonObject.put("destinationPlant", "");
							informationList.add("");
							ServiceTypeJsonObject.put("destinationParkIn", "");
							informationList.add("");
							ServiceTypeJsonObject.put("destinationPlantIn", "");
							informationList.add("");
							ServiceTypeJsonObject.put("enrouteDistance","");
							informationList.add("");
							ServiceTypeJsonObject.put("enrouteTransitTime", "");
							informationList.add("");
							ServiceTypeJsonObject.put("enrouteStoppageTime", "");
							informationList.add("");
							ServiceTypeJsonObject.put("destinationWaitingOutTat", "");
							informationList.add("");
							ServiceTypeJsonObject.put("groupName", "");
							informationList.add("");
							ServiceTypeJsonObject.put("source", "");
							informationList.add("");
							ServiceTypeJsonObject.put("destination", "");
							informationList.add("");
							ServiceTypeJsonObject.put("ShipmentReceivedDateTime", "");
							informationList.add("");
							ServiceTypeJsonObject.put("AssetStatus","");
							informationList.add("");
							ServiceTypeJsonObject.put("waitingTime","");
							informationList.add("");
							ServiceTypeJsonObject.put("runningTime","");
							informationList.add("");
							ServiceTypeJsonObject.put("ShipmentActualStartDateTime", "");
							informationList.add("");
							ServiceTypeJsonObject.put("ShipmentStartDateTime", "");
							informationList.add("");
							ServiceTypeJsonObject.put("DataTransferStatus", "");
							informationList.add("");
							ServiceTypeJsonObject.put("ShipmentStatus", "");
							informationList.add("");
							ServiceTypeJsonObject.put("ScheduleTripStartDateTime", "");
							informationList.add("");
							ServiceTypeJsonObject.put("ShipmentRepushed", "");
							informationList.add("");
							ServiceTypeJsonObject.put("ShipmentCloseDateTime", "");
							informationList.add("");
							ServiceTypeJsonObject.put("ServiceProvider","");
							informationList.add("");
							ServiceTypeJsonObject.put("UnitNo","");
							informationList.add("");
							ServiceTypeJsonObject.put("SourceETA", "");
							informationList.add("");
							ServiceTypeJsonObject.put("DestinationETA", "");
							informationList.add("");
							ServiceTypeJsonObject.put("ClosedType", "");
							informationList.add("");
							ServiceTypeJsonObject.put("ClosedTime","");
							informationList.add("");
							ServiceTypeJsonObject.put("tripStartTime", tripStartTime);
							informationList.add(tripStartTime);
							ServiceTypeJsonObject.put("receivedTime", receivedTime);
							informationList.add(receivedTime);
							ServiceTypeJsonObject.put("sequence", sequence);
							informationList.add(sequence);
							ServiceTypeJsonObject.put("locationId", locationId);
							informationList.add(locationId);
							ServiceTypeJsonObject.put("lat", lat);
							informationList.add(lat);
							ServiceTypeJsonObject.put("longi", longi);
							informationList.add(longi);
							ServiceTypeJsonObject.put("pushStatus", pushStatus);
							informationList.add(pushStatus);
							ServiceTypeJsonObject.put("inTime", inTime);
							informationList.add(inTime);
							ServiceTypeJsonObject.put("outTime", outTime);
							informationList.add(outTime);
							ServiceTypeJsonObject.put("rePushed", rePushed);
							informationList.add(rePushed);
							ServiceTypeJsonArray.put(ServiceTypeJsonObject);
							reporthelper.setInformationList(informationList);
							reportsList.add(reporthelper);
						}
				}
				else if(servicetype.equals("SHIPMENT"))
				{
					
					 headersList.add("SLNO");
					 headersList.add("Asset Number");
					 headersList.add("Park Name");
					 headersList.add("Plant Name");
					 headersList.add("Park In");
					 headersList.add("Plant In");
					 headersList.add("Plant Out");
					 headersList.add("Plant Out");
					 headersList.add("Shipment");
					 headersList.add("XML Data");
					 headersList.add("Status");
					 headersList.add("Date & Time");
					 headersList.add("Transport Vendor");
					 headersList.add("Trailer Type");
					 headersList.add("Total TAT");
					 headersList.add("Plant TAT");
					 headersList.add("Incoming Park TAT");
					 headersList.add("Outgoing Park TAT");
					 headersList.add("Trip Id");
					 headersList.add("Source Plant");
					 headersList.add("Source Plant Gate Out");
					 headersList.add("Destination Plant");
					 headersList.add("Destination Park In");
					 headersList.add("Destination Plant Gate In");
					 headersList.add("Enroute Distance");
					 headersList.add("Enroute Transit Time");
					 headersList.add("Enroute Stoppage Time");
					 headersList.add("Destination Plant Outside Wait Time");
					 headersList.add("Group Name");
					 headersList.add("Source");
					 headersList.add("Destination");
					 headersList.add("Shipment Received Date Time");
					 headersList.add("Asset Status");
					 headersList.add("% of WaitingTime");
					 headersList.add("% of RunningTime");
					 headersList.add("Shipment Actual Start Date & Time");
					 headersList.add("Shipment Start Date & Time");
					 headersList.add("Data Transfer Status");
					 headersList.add(" Shipment Status");
					 headersList.add("Schedule Trip Start Date Time");
					 headersList.add("Shipment Repushed");
					 headersList.add("Shipment Close Date Time");
					 headersList.add("Service Provider");
					 headersList.add("Unit Number");
					 headersList.add("Source ETA");
					 headersList.add("Destination ETA");
					 headersList.add("Closed Type");
					 headersList.add("Closed Time");
					headersList.add("TripStartTime");
						headersList.add("ReceivedTime");
						headersList.add("Sequence");
						headersList.add("LocationId");
						headersList.add("Latitude");
						headersList.add("Longitude");
						headersList.add("PushStatus");
						headersList.add("InTime");
						headersList.add("OutTime");
				        headersList.add("RePushed");
					 
					 String ShipmentType = "";
					 if(customerid==4774 && systemId==200)
					 {
						 ShipmentType="SFU";
					 }
					 else if(customerid==3376 && systemId==200){
						 ShipmentType="SAU";
					 }
						 pstmt = conAdmin.prepareStatement(AdminStatements.GET_SHIPMENT_DETAILS);
							pstmt.setInt(1,offSet);
							pstmt.setInt(2,systemId);
							pstmt.setInt(3,customerid);
							pstmt.setString(4,startDate);
							pstmt.setString(5,endDate);
							pstmt.setString(6,ShipmentType+"%");
							
					 rs = pstmt.executeQuery();
					    
					    while (rs.next()) {	
							count++;
							ServiceTypeJsonObject = new JSONObject();
							String shipment=rs.getString("SHIPMENNT_ID");
							ArrayList < Object > informationList = new ArrayList < Object > ();
							ReportHelper reporthelper = new ReportHelper();
							
							ServiceTypeJsonObject.put("slnoIndex", count);
							informationList.add(count);
							ServiceTypeJsonObject.put("assetNumber", rs.getString("ASSET_NUMBER"));
							informationList.add(rs.getString("ASSET_NUMBER"));
							ServiceTypeJsonObject.put("parkName", "");
							informationList.add("");
							ServiceTypeJsonObject.put("plantName", "");
							informationList.add("");
							ServiceTypeJsonObject.put("parkIn", "");
							informationList.add("");
							ServiceTypeJsonObject.put("plantIn", "");
							informationList.add("");
							ServiceTypeJsonObject.put("plantOut", "");
							informationList.add("");
							ServiceTypeJsonObject.put("parkOut", "");
							informationList.add("");
							ServiceTypeJsonObject.put("shipment", shipment);
							informationList.add(shipment);
							ServiceTypeJsonObject.put("status", "");
							informationList.add("");
							ServiceTypeJsonObject.put("status", "");
							informationList.add("");
							ServiceTypeJsonObject.put("triggeredTime", "");
							informationList.add("");
							
							ServiceTypeJsonObject.put("transporter", "");
							informationList.add("");
							ServiceTypeJsonObject.put("trailerType", "");
							informationList.add("");
							ServiceTypeJsonObject.put("tripTat", "");
							informationList.add("");
							ServiceTypeJsonObject.put("plantTat", "");
							informationList.add("");
							ServiceTypeJsonObject.put("incomingParkTAT","");
							informationList.add("");
							ServiceTypeJsonObject.put("outgoingParkTAT","");
							informationList.add("");
					
							ServiceTypeJsonObject.put("tripId", "");
							informationList.add("");
							ServiceTypeJsonObject.put("sourceplantName", "");
							informationList.add("");
							ServiceTypeJsonObject.put("sourcePlantOut", "");
							informationList.add("");
							ServiceTypeJsonObject.put("destinationPlant", "");
							informationList.add("");
							ServiceTypeJsonObject.put("destinationParkIn", "");
							informationList.add("");
							ServiceTypeJsonObject.put("destinationPlantIn", "");
							informationList.add("");
							ServiceTypeJsonObject.put("enrouteDistance", "");
							informationList.add("");
							ServiceTypeJsonObject.put("enrouteTransitTime", "");
							informationList.add("");
							ServiceTypeJsonObject.put("enrouteStoppageTime", "");
							informationList.add("");
							ServiceTypeJsonObject.put("destinationWaitingOutTat", "");
							informationList.add("");
							ServiceTypeJsonObject.put("groupName", "");
							informationList.add("");
							ServiceTypeJsonObject.put("source", rs.getString("SOURCE"));
							informationList.add(rs.getString("SOURCE"));
							ServiceTypeJsonObject.put("destination", rs.getString("DESTINATION"));
							informationList.add(rs.getString("DESTINATION"));
							ServiceTypeJsonObject.put("ShipmentReceivedDateTime", rs.getString("TRIP_SHEET_RECIEVED_TIME"));
							informationList.add(rs.getString("TRIP_SHEET_RECIEVED_TIME"));
							ServiceTypeJsonObject.put("AssetStatus", rs.getString("SHIPMENT_CLOSER_STATUS"));
							informationList.add(rs.getString("SHIPMENT_CLOSER_STATUS"));
							ServiceTypeJsonObject.put("waitingTime","");
							informationList.add("");
							ServiceTypeJsonObject.put("runningTime","");
							informationList.add("");
							ServiceTypeJsonObject.put("ShipmentActualStartDateTime", "");
							informationList.add("");
							ServiceTypeJsonObject.put("ShipmentStartDateTime", "");
							informationList.add("");
							ServiceTypeJsonObject.put("DataTransferStatus", "");
							informationList.add("");
							ServiceTypeJsonObject.put("ShipmentStatus", rs.getString("STATUS"));
							informationList.add(rs.getString("STATUS"));
							ServiceTypeJsonObject.put("ScheduleTripStartDateTime",rs.getString("TRIP_START_TIME"));
							informationList.add(rs.getString("TRIP_START_TIME"));
							ServiceTypeJsonObject.put("ShipmentRepushed", rs.getString("RE_PUSHED"));
							informationList.add(rs.getString("RE_PUSHED"));
							ServiceTypeJsonObject.put("ShipmentCloseDateTime", "");
							informationList.add("");
							ServiceTypeJsonObject.put("ServiceProvider",rs.getString("SERVICE_PROVIDER"));
							informationList.add(rs.getString("SERVICE_PROVIDER"));
							ServiceTypeJsonObject.put("UnitNo",rs.getString("UNIT_NO"));
							informationList.add(rs.getString("UNIT_NO"));
							ServiceTypeJsonObject.put("SourceETA",rs.getString("SOURCE_ETA") );
							informationList.add(rs.getString("SOURCE_ETA"));
							ServiceTypeJsonObject.put("DestinationETA", rs.getString("DESTINATION_ETA"));
							informationList.add(rs.getString("DESTINATION_ETA"));
							if(systemId==4){
							ServiceTypeJsonObject.put("ClosedType", "");
							informationList.add("");
							ServiceTypeJsonObject.put("ClosedTime", "");
							informationList.add("");
							}else{
							ServiceTypeJsonObject.put("ClosedType", rs.getString("SHIPMENT_CLOSER_TYPE"));
							informationList.add(rs.getString("SHIPMENT_CLOSER_TYPE"));
							if(rs.getString("CLOSED_TIME")!=null){
								ServiceTypeJsonObject.put("ClosedTime", rs.getString("CLOSED_TIME"));
								informationList.add(rs.getString("CLOSED_TIME"));
							}else{
								ServiceTypeJsonObject.put("ClosedTime", "");
								informationList.add("");
							}
							}
							ServiceTypeJsonObject.put("tripStartTime", "");
							informationList.add("");
							ServiceTypeJsonObject.put("receivedTime", "");
							informationList.add("");
							ServiceTypeJsonObject.put("sequence", "");
							informationList.add("");
							ServiceTypeJsonObject.put("locationId", "");
							informationList.add("");
							ServiceTypeJsonObject.put("lat", "");
							informationList.add("");
							ServiceTypeJsonObject.put("longi", "");
							informationList.add("");
							ServiceTypeJsonObject.put("pushStatus", "");
							informationList.add("");
							ServiceTypeJsonObject.put("inTime", "");
							informationList.add("");
							ServiceTypeJsonObject.put("outTime", "");
							informationList.add("");
							ServiceTypeJsonObject.put("rePushed", "");
							informationList.add("");
							ServiceTypeJsonArray.put(ServiceTypeJsonObject);
							reporthelper.setInformationList(informationList);
							reportsList.add(reporthelper);
						}
				}
				finalreporthelper.setReportsList(reportsList);
				finalreporthelper.setHeadersList(headersList);
				aslist.add(ServiceTypeJsonArray);
				aslist.add(finalreporthelper);
				
			} 			
			catch (Exception e) {
				System.out.println("Error in Admin Functions:- getAssetGroupDetails "+e.toString());
			} finally {
				DBConnection.releaseConnectionToDB(conAdmin, pstmt, rs);
			}
			return aslist;
			
		
		}
		
		
		public String getShipmentId(String data)
		   {
			   String shipment="";
			    try {
			        DocumentBuilderFactory dbf =
			            DocumentBuilderFactory.newInstance();
			        DocumentBuilder db = dbf.newDocumentBuilder();
			        InputSource is = new InputSource();
			        is.setCharacterStream(new StringReader(data));

			        Document doc = db.parse(is);
			        NodeList shipmentId = doc.getElementsByTagName("ShipmentRefnumValue");
			        Element line = (Element) shipmentId.item(0);
			        shipment=getCharacterDataFromElement(line);
			    }
			    catch (Exception e) {
			        e.printStackTrace();
			    }
				return shipment;
		   }
		   
		   public static String getCharacterDataFromElement(Element e) {
			    Node child = e.getFirstChild();
			    if (child instanceof CharacterData) {
			       CharacterData cd = (CharacterData) child;
			       return cd.getData();
			    }
			    return "";
			  }
		   
		   
			public JSONArray getReason() {
			    JSONArray JsonArray = null;
			    Connection con = null;
			    PreparedStatement pstmt = null;
			    ResultSet rs = null;
			    JSONObject obj1 = new JSONObject();
			    try {
			    	 JsonArray = new JSONArray();
			        con = DBConnection.getConnectionToDB("AMS");
			        pstmt = con.prepareStatement(AdminStatements.GET_REASONS);
			        rs = pstmt.executeQuery();
			        while (rs.next()) {
			            obj1 = new JSONObject();
			            obj1.put("Name", rs.getString("Reason"));
			            JsonArray.put(obj1);
			        }
			       } catch (Exception e) {
			        e.printStackTrace();
			    } finally {
			        DBConnection.releaseConnectionToDB(con, pstmt, rs);
			    }
			    return JsonArray;
			    
			}   
			
/******************************************************ADD NEW FEATURE ACTION**********************************************************************************/			
	     public JSONArray getLTSP() {
			    JSONArray JsonArray = null;
			    JSONObject JsonObject = null;
			    Connection con = null;
			    PreparedStatement pstmt = null;
			    ResultSet rs = null;
			    int count = 0;
			    try {
			        JsonArray = new JSONArray();
			        con = DBConnection.getConnectionToDB("AMS");
			        pstmt = con.prepareStatement(AdminStatements.GET_ALL_LTSP);
			        rs = pstmt.executeQuery();
			        while (rs.next()) {
			            JsonObject = new JSONObject();
			            JsonObject.put("ltspId", rs.getString("SystemId"));
			            JsonObject.put("ltspName", rs.getString("SystemName"));
			            JsonArray.put(JsonObject);
			        }
			        JsonObject = new JSONObject();
			        JsonObject.put("ltspId", "0");
			        JsonObject.put("ltspName", "All");
			        JsonArray.put(JsonObject);
			    } catch (Exception e) {
			        e.printStackTrace();
			    } finally {
			        DBConnection.releaseConnectionToDB(con, pstmt, rs);
			    }
			    return JsonArray;
			}
				

	     public JSONArray getProcessType() {
			    JSONArray JsonArray = null;
			    JSONObject JsonObject = null;
			    Connection con = null;
			    PreparedStatement pstmt = null;
			    ResultSet rs = null;
			    int count = 0;
			    try {
			        JsonArray = new JSONArray();
			        con = DBConnection.getConnectionToDB("AMS");
			        pstmt = con.prepareStatement(AdminStatements.GET_PRODUCT_TYPE);
			        rs = pstmt.executeQuery();
			        while (rs.next()) {
			            JsonObject = new JSONObject();
			             JsonObject.put("ProcessId", rs.getString("ProcessId"));
			            JsonObject.put("processType", rs.getString("ProcessType"));
			            JsonArray.put(JsonObject);
			        }
			} catch (Exception e) {
			        e.printStackTrace();
			    } finally {
			        DBConnection.releaseConnectionToDB(con, pstmt, rs);
			    }
			    return JsonArray;
			}
			
	     public JSONArray getProcessName(String processType) {
			    JSONArray JsonArray = null;
			    JSONObject JsonObject = null;
			    Connection con = null;
			    PreparedStatement pstmt = null;
			    ResultSet rs = null;
			    int count = 0;
			    try {
			        JsonArray = new JSONArray();
			        con = DBConnection.getConnectionToDB("AMS");
			        String processtype=processType.trim();
			        pstmt = con.prepareStatement(AdminStatements.GET_PROCESS_NAME);
			        pstmt.setString(1, processtype);
			        rs = pstmt.executeQuery();
			        while (rs.next()) {
			            JsonObject = new JSONObject();
			            JsonObject.put("processId", rs.getString("processId"));
			            JsonObject.put("processName", rs.getString("ProcessName"));
			            JsonArray.put(JsonObject);
			        }
			} catch (Exception e) {
			        e.printStackTrace();
			    } finally {
			        DBConnection.releaseConnectionToDB(con, pstmt, rs);
			    }
			    return JsonArray;
			}
	     
	     public JSONArray getSubProcessName(String processId) {
			    JSONArray JsonArray = null;
			    JSONObject JsonObject = null;
			    Connection con = null;
			    PreparedStatement pstmt = null;
			    ResultSet rs = null;
			    JsonObject = new JSONObject();
			    try {
			        JsonArray = new JSONArray();
			        con = DBConnection.getConnectionToDB("AMS");
			        if (processId.equals("24")) {
			        	pstmt = con.prepareStatement(AdminStatements.GET_SUB_PROCESS_NAME+" and SUB_PROCESS_ID<46 ");
					}else {
						pstmt = con.prepareStatement(AdminStatements.GET_SUB_PROCESS_NAME);
					}
			        pstmt.setString(1, processId);
			        rs = pstmt.executeQuery();
			        JsonObject.put("SubProcessId", "0");
			        JsonObject.put("SubProcessName", "None");
			        JsonArray.put(JsonObject);
			        while (rs.next()) {
			            JsonObject = new JSONObject();
			            JsonObject.put("SubProcessId", rs.getString("SubProcessId"));
			            JsonObject.put("SubProcessName", rs.getString("SubProcessName"));
			            JsonArray.put(JsonObject);
			        }
			} catch (Exception e) {
			        e.printStackTrace();
			    } finally {
			        DBConnection.releaseConnectionToDB(con, pstmt, rs);
			    }
			    return JsonArray;
			}
	     
	     public JSONArray getSecondSubProcessName(String processId) {
			    JSONArray JsonArray = null;
			    JSONObject JsonObject = null;
			    Connection con = null;
			    PreparedStatement pstmt = null;
			    ResultSet rs = null;
			    JsonObject = new JSONObject();
			    try {
			        JsonArray = new JSONArray();
			        con = DBConnection.getConnectionToDB("AMS");
			        pstmt = con.prepareStatement(AdminStatements.GET_SUB_PROCESS_NAME2);
			        pstmt.setString(1, processId);
			        rs = pstmt.executeQuery();
			        JsonObject.put("secondSubProcessId", "0");
			        JsonObject.put("secondSubProcessName", "None");
			        JsonArray.put(JsonObject);
			        while (rs.next()) {
			            JsonObject = new JSONObject();
			            JsonObject.put("secondSubProcessId", rs.getString("SubProcessId"));
			            JsonObject.put("secondSubProcessName", rs.getString("SubProcessName"));
			            JsonArray.put(JsonObject);
			        }
			} catch (Exception e) {
			        e.printStackTrace();
			    } finally {
			        DBConnection.releaseConnectionToDB(con, pstmt, rs);
			    }
			    return JsonArray;
			}

	     public JSONArray getmenuGroupName(String subprocessId) {
			    JSONArray JsonArray = null;
			    JSONObject JsonObject = null;
			    Connection con = null;
			    PreparedStatement pstmt = null;
			    ResultSet rs = null;
			    JsonObject = new JSONObject();
			    try {
			        JsonArray = new JSONArray();
			        con = DBConnection.getConnectionToDB("AMS");
			        pstmt = con.prepareStatement(AdminStatements.GET_MENU_GROUP_NAME);
			        pstmt.setString(1, subprocessId);
			        rs = pstmt.executeQuery();
			        JsonObject.put("MenuGroupNameId", "0");
			        JsonObject.put("MenuGroupName", "None");
			        JsonArray.put(JsonObject);
			        while (rs.next()) {
			            JsonObject = new JSONObject();
			            JsonObject.put("MenuGroupNameId", rs.getString("menuGroupId"));
			            JsonObject.put("MenuGroupName", rs.getString("menuGroupName"));
			            JsonArray.put(JsonObject);
			        }
			} catch (Exception e) {
			        e.printStackTrace();
			    } finally {
			        DBConnection.releaseConnectionToDB(con, pstmt, rs);
			    }
			    return JsonArray;
			}
	     
	    
	     public JSONArray getPageLink() {
			    JSONArray JsonArray = null;
			    JSONObject JsonObject = null;
			    Connection con = null;
			    PreparedStatement pstmt = null;
			    ResultSet rs = null;
			    try {
			        JsonArray = new JSONArray();
			        con = DBConnection.getConnectionToDB("AMS");
			        pstmt = con.prepareStatement(AdminStatements.GET_PAGE_LINK_NAMES);
			        rs = pstmt.executeQuery();
			        while (rs.next()) {
			            JsonObject = new JSONObject();
			            JsonObject.put("pageLinkId", rs.getString("ElementId"));
			            JsonObject.put("pageLinkName", rs.getString("ElementName"));
			            JsonArray.put(JsonObject);
			        }
			} catch (Exception e) {
			        e.printStackTrace();
			    } finally {
			        DBConnection.releaseConnectionToDB(con, pstmt, rs);
			    }
			    return JsonArray;
			}

	     public JSONArray getMenuGroupNameForAddOnPackage(String processNameFromFirstPanel,String subProcessRawNameFromSecondPanel) {
			    JSONArray JsonArray = null;
			    JSONObject JsonObject = null;
			    Connection con = null;
			    PreparedStatement pstmt = null;
			    ResultSet rs = null;
			    try {
			        JsonArray = new JSONArray();
			        con = DBConnection.getConnectionToDB("AMS");
			        pstmt = con.prepareStatement(AdminStatements.GET_MENU_GROUP_NAME_FOR_ADD_ON_PACKAGES);
			        String pnm=processNameFromFirstPanel;
			        if (pnm.contains(" ")) {
			        	processNameFromFirstPanel=pnm.substring(0, pnm.indexOf(" "));
					} else {
						processNameFromFirstPanel=pnm;
					}
			        pstmt.setString(1,"%"+processNameFromFirstPanel+"%"+subProcessRawNameFromSecondPanel+"%");
			        rs = pstmt.executeQuery();
			        while (rs.next()) {
			            JsonObject = new JSONObject();
			            JsonObject.put("menuGroupNameComboForAddOnPackageId", rs.getString("LABEL_ID"));
			            JsonObject.put("menuGroupNameComboForAddOnPackageName", rs.getString("LANG_ENGLISH"));
			            JsonArray.put(JsonObject);
			        }
			} catch (Exception e) {
			        e.printStackTrace();
			    } finally {
			        DBConnection.releaseConnectionToDB(con, pstmt, rs);
			    }
			    return JsonArray;
			}
	     
	     
			public ArrayList < Object > getAddNewFeatureReport(int systemIdFromJsp) {
			    JSONArray JsonArray = new JSONArray();
			    JSONObject JsonObject = null;
			    Connection con = null;
			    PreparedStatement pstmt = null;
			    ResultSet rs = null;
			    ArrayList < Object > finlist = new ArrayList < Object > ();
			    try {
			        int count = 0;
			        con = DBConnection.getConnectionToDB("AMS");
			        if(systemIdFromJsp !=0)
			        {
			          pstmt = con.prepareStatement(AdminStatements.GET_ADD_FEATURE_REPORT);
			          pstmt.setInt(1, systemIdFromJsp);
			        }else
			        {
			          pstmt = con.prepareStatement(AdminStatements.GET_ADD_FEATURE_REPORT1);
			        }
			       
			        rs = pstmt.executeQuery();
			        while (rs.next()) {
			            JsonObject = new JSONObject();
			            count++;
			            JsonObject.put("slnoIndex", count);
			            JsonObject.put("processTypeIndex", rs.getString("ProcessType"));
			            JsonObject.put("processNameDataIndex", rs.getString("ProcessName"));
			            JsonObject.put("subProcessNameDataIndex", rs.getString("SubProcessName"));
			            JsonObject.put("menuGroupNameDataIndex", rs.getString("MenuGroupName"));
			            JsonObject.put("pageTitleDataIndex", rs.getString("PageTitle"));
			            JsonObject.put("pageLinkDataIndex", rs.getString("program_name"));
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
	     
	     
			public String insertAddFeatureInformation(int systemIdFromJsp, String processType, String processName, String subProcessName, String menuGroupName, String pageTitle, String pageLink,String secondSubProcessId,String secondMenuGroupId,String pageLinkName,String subProcessRawName,String secondSubProcessIdForAddOnPackage,String secondMenuGroupIdForAddOnPackage) {
				Connection con = null;
				PreparedStatement pstmt = null;
				PreparedStatement pstmt1 = null;
				PreparedStatement pstmt2 = null;
				PreparedStatement pstmt4 = null;
				PreparedStatement pstmt10 = null;
				PreparedStatement pstmt11 = null;
				ResultSet rs = null;
				ResultSet rs1 = null;
				ResultSet rs2 = null;
				ResultSet rs4 = null;
				ResultSet rs5 = null;
				ResultSet rs10 = null;
				ResultSet rs11 = null;
				String message = "";
				String predessor="";
				int size=0;
				try {
					int maxMenuId = 0;
					int maxOrderId = 0;
					int orderOfDisplay = 0;
					int menuIdFromMenuMaster=0;
					String subProcessName1 =""; 
					String subProcessName2 ="";
					String css;
					con = DBConnection.getConnectionToDB("ADMINISTRATOR");
					con.setAutoCommit(false);

					pstmt4 = con.prepareStatement(AdminStatements.CHECK_PAGE_TITLE_PRESENT_IN_LANG_LOCALIZATION);
					pstmt4.setString(1, pageTitle.toUpperCase());
					rs4 = pstmt4.executeQuery();
					if(!rs4.next())
					{
						message = "Page Title Does Not Exist In LANG LOCALIZATION.";
						return message;
					}

					pstmt = con.prepareStatement(AdminStatements.CHECK_MENU_NAME_PRESENT_MENU_ITEM_MASTER);
					pstmt.setString(1, pageTitle.toUpperCase());
					rs = pstmt.executeQuery();
					if (rs.next()) {
						message = "Menu/Item Name Already exists.Try different Menu/Item Name";
						return message;
					}

					pstmt = con.prepareStatement(AdminStatements.SELECT_MAX_MENU_ID_AND_MAX_ORDERID_FROM_MENU_ITEM_MASTER);
					rs = pstmt.executeQuery();
					if (rs.next()) {
						maxMenuId = rs.getInt("maxMenuId");
						maxOrderId = rs.getInt("maxOrderId");
					}
					maxMenuId++;
					maxOrderId++;

					//to get CSS
					pstmt = con.prepareStatement(AdminStatements.SELECT_CSS_FROM_MENU_MASTER);
					pstmt.setString(1, processName);
					if(subProcessName.equals("0"))
					{
						pstmt.setObject(2, null);
					}else
					pstmt.setString(2, subProcessName);
					rs = pstmt.executeQuery();
					if(rs.next())
					{
						css=rs.getString("CSS");
					}else
					{
						css="";
					}

					pstmt = con.prepareStatement(AdminStatements.SELECT_MENU_ITEM_ID_FROM_MENT_ITEM_MASTER);
					pstmt.setString(1,processName);
					pstmt.setString(2,subProcessName);
					rs = pstmt.executeQuery();
					if(rs.next())
					{
						predessor = rs.getString("menu_item_parent_id");
					}

					if (predessor == "" || predessor == null || predessor.equals(""))
					{
						predessor="-1";
					}


					if (systemIdFromJsp == 0) {
						pstmt1 = con.prepareStatement(AdminStatements.SELECT_ALL_SYSTEM_ID_FROM_SYSTEM_MASTER);
						rs1 = pstmt1.executeQuery();
						while (rs1.next()) {
							pstmt2 = con.prepareStatement(AdminStatements.INSERT_INTO_MENU_ITEM_MASTER);
							pstmt2.setInt(1, maxMenuId);
							pstmt2.setString(2, pageTitle);
							pstmt2.setString(3, pageLinkName);
							pstmt2.setString(4, rs1.getString("System_Id"));
							pstmt2.setString(5, css);
							pstmt2.setString(6, "0");
							pstmt2.setInt(7, maxOrderId);
							int inserted = pstmt2.executeUpdate();
							if (inserted > 0) {
								pstmt2 = con.prepareStatement(AdminStatements.INSERT_INTO_MENU_ITEM_TREE_STRUCTURE);
								pstmt2.setInt(1, maxMenuId);
								pstmt2.setString(2, predessor);
								pstmt2.setString(3, rs1.getString("System_Id"));
								pstmt2.executeUpdate();

								pstmt2 = con.prepareStatement(AdminStatements.INSERT_GROUP_FEATURE_T4U);
								pstmt2.setString(1, "1");
								pstmt2.setInt(2, maxMenuId);
								pstmt2.setString(3, rs1.getString("System_Id"));
								pstmt2.executeUpdate();
							}
						}
					} 
					else {
						pstmt2 = con.prepareStatement(AdminStatements.INSERT_INTO_MENU_ITEM_MASTER);
						pstmt2.setInt(1, maxMenuId);
						pstmt2.setString(2, pageTitle);
						pstmt2.setString(3, pageLinkName);
						pstmt2.setInt(4, systemIdFromJsp);
						pstmt2.setString(5, css);
						pstmt2.setString(6, "0");
						pstmt2.setInt(7, maxOrderId);
						int inserted = pstmt2.executeUpdate();
						if (inserted > 0) {
							pstmt2 = con.prepareStatement(AdminStatements.INSERT_INTO_MENU_ITEM_TREE_STRUCTURE);
							pstmt2.setInt(1, maxMenuId);
							pstmt2.setString(2, predessor);
							pstmt2.setInt(3, systemIdFromJsp);
							pstmt2.executeUpdate();

							pstmt2 = con.prepareStatement(AdminStatements.INSERT_GROUP_FEATURE_T4U);
							pstmt2.setString(1, "1");
							pstmt2.setInt(2, maxMenuId);
							pstmt2.setInt(3, systemIdFromJsp);
							pstmt2.executeUpdate();
						}
					}
					//insert -1 for all system id
					pstmt2 = con.prepareStatement(AdminStatements.INSERT_INTO_MENU_ITEM_MASTER);
					pstmt2.setInt(1, maxMenuId);
					pstmt2.setString(2, pageTitle);
					pstmt2.setString(3, pageLinkName);
					pstmt2.setString(4, "-1");
					pstmt2.setString(5, css);
					pstmt2.setString(6, "0");
					pstmt2.setInt(7, maxOrderId);
					pstmt2.executeUpdate();

					pstmt2 = con.prepareStatement(AdminStatements.INSERT_INTO_MENU_ITEM_TREE_STRUCTURE);
					pstmt2.setInt(1, maxMenuId);
					pstmt2.setString(2, predessor);
					pstmt2.setString(3, "-1");
					pstmt2.executeUpdate();


					pstmt = con.prepareStatement(AdminStatements.TO_GET_ORDER_OF_DISPLAY_FROM_MENU_MASTER);
					pstmt.setString(1, processName);
					pstmt.setString(2, subProcessName);
					pstmt.setString(3, processName);
					pstmt.setString(4, subProcessName);
					rs = pstmt.executeQuery();
					if(rs.next())
					{
						size = rs.getFetchSize();
						if(size > 1)
						{
							orderOfDisplay=rs.getInt("OrderOfDisplay");
							orderOfDisplay++;
						}
						else
						{
							orderOfDisplay=rs.getInt("OrderOfDisplay");
						}
					}
					
					//insert sub process id  in menu master  only for process Id's 24,21,20,35.
					if(processType.equals("Verticalized Solutions") && (!processName.equals("24")) && (subProcessRawName.equals("Vertical_Dashboard") || subProcessRawName.equals("Mapview")
							|| subProcessRawName.equals("Alerts") || subProcessRawName.equals("Actions")
							|| subProcessRawName.equals("Reports") || subProcessRawName.equals("Preferences") || subProcessRawName.equals("Administration")))
					{
						subProcessName1 =null; 
					}
					
					if(processType.equals("Add-on Packages"))
					{
						if(processType.equals("Add-on Packages") && processName.equals("35"))
						{
						subProcessName2=subProcessName;
						}else
						{
						subProcessName2=null;
					   }
					}	
						
					
					pstmt = con.prepareStatement(AdminStatements.INSERT_INTO_MENU_MASTER,Statement.RETURN_GENERATED_KEYS);
					pstmt.setString(1, processName);
					if(processType.equals("Add-on Packages"))
					{
					if(subProcessName2==null)
						pstmt.setObject(2, subProcessName2);
						else if(subProcessName.equals("0"))
						{
						pstmt.setObject(2, null);
						}else
						pstmt.setString(2, subProcessName2);
					}
					else if(processType.equals("Verticalized Solutions"))
					{
						if(subProcessName1==null)
						pstmt.setObject(2, subProcessName1);
						else if(subProcessName.equals("0"))
						{
						pstmt.setObject(2, null);
						}
					  else
	                    pstmt.setString(2, subProcessName);
					}	
					
					else
					pstmt.setString(2, subProcessName);	
						
					pstmt.setString(3, rs4.getString("LABEL_ID"));
					pstmt.setString(4, pageLink);
					pstmt.setInt(5, orderOfDisplay);
					pstmt.setString(6, css);
					pstmt.executeUpdate();
					rs5=pstmt.getGeneratedKeys();
					if(rs5.next())
					{
						menuIdFromMenuMaster=rs5.getInt(1);
					}
					
					
					if(processType.equals("Verticalized Solutions"))
					{
						if((secondSubProcessId !=null && secondSubProcessId !=("")) && (secondMenuGroupId !=null && secondMenuGroupId !=("")))
						{
							pstmt = con.prepareStatement(AdminStatements.INSERT_INTO_VERTICAL_MENU_DISPLAY);	
							pstmt.setString(1, processName);
							pstmt.setString(2, secondSubProcessId);
							pstmt.setString(3, secondMenuGroupId);
							pstmt.setInt(4, menuIdFromMenuMaster);
							pstmt.setString(5, pageLink);
							pstmt.setInt(6, orderOfDisplay);
							pstmt.executeUpdate();
						}else
						{
							pstmt = con.prepareStatement(AdminStatements.INSERT_INTO_VERTICAL_MENU_DISPLAY);	
							pstmt.setString(1, processName);
							if(subProcessName.equals("0"))
							{
								pstmt.setObject(2, null);
							}else
							pstmt.setString(2, subProcessName);
							if(menuGroupName.equals("0"))
							{
								pstmt.setObject(3, null);
							}else
								pstmt.setString(3, menuGroupName);
							pstmt.setInt(4, menuIdFromMenuMaster);
							pstmt.setString(5, pageLink);
							pstmt.setInt(6, orderOfDisplay);
							pstmt.executeUpdate();
						}
					}

					if(processType.equals("Mandatory Packages"))
					{
						pstmt = con.prepareStatement(AdminStatements.SELECT_ALL_PROCESS_ID_FOR_VERTICAL_SOL_IN_PRODUCT_PROCESS);	
						rs = pstmt.executeQuery();
						while(rs.next())
						{
							if(subProcessRawName.equals("Admin") || subProcessRawName.equals("Events") || subProcessRawName.equals("SMS") )
							{
								pstmt = con.prepareStatement(AdminStatements.SELECT_SUB_PROCESS_ID_FROM_SUB_PROCESS_FOR_ABOVE_PROCESS_ID);
								pstmt.setString(1, rs.getString("PROCESS_ID"));
								rs1 = pstmt.executeQuery();
								if(rs1.next())
								{
									pstmt = con.prepareStatement(AdminStatements.INSERT_INTO_VERTICAL_MENU_DISPLAY);
									pstmt.setString(1, rs1.getString("PROCESS_ID"));
									pstmt.setString(2, rs1.getString("SUB_PROCESS_ID"));
									if(menuGroupName.equals("0"))
									{
										pstmt.setObject(3, null);
									}else
										pstmt.setString(3, menuGroupName);
									pstmt.setInt(4, menuIdFromMenuMaster);
									pstmt.setString(5, pageLink);
									pstmt.setInt(6, orderOfDisplay);
									pstmt.executeUpdate();
								}
							}

							if(subProcessRawName.equals("Reports") || subProcessRawName.equals("Alerts"))
							{
								String str = null;
								if (subProcessRawName.equalsIgnoreCase("Reports")) {
									str = "Operational_Reports";
								}else {
									str = "Alerts";
								}
								pstmt = con.prepareStatement(AdminStatements.SELECT_SUB_PROCESS_ID_FROM_SUB_PROCESS_REPORTS);
								pstmt.setString(1, rs.getString("PROCESS_ID"));
								pstmt.setString(2, subProcessRawName);
								rs1 = pstmt.executeQuery();
								while(rs1.next())
								{
									if(subProcessRawName.equals("Reports"))
									{
										pstmt = con.prepareStatement(AdminStatements.SELECT_ALL_MENU_FROM_MENU_GROUP_PROCESS_AND_SUB_PROCESS_ID);
										pstmt.setString(1, rs1.getString("PROCESS_ID"));
										pstmt.setString(2, rs1.getString("SUB_PROCESS_ID"));
										pstmt.setString(3, str);
										rs2 = pstmt.executeQuery();
										if(rs2.next())
										{
											pstmt = con.prepareStatement(AdminStatements.INSERT_INTO_VERTICAL_MENU_DISPLAY);
											pstmt.setString(1, rs1.getString("PROCESS_ID"));
											pstmt.setString(2, rs1.getString("SUB_PROCESS_ID"));
											pstmt.setString(3, rs2.getString("MENU_GROUP_ID"));
											pstmt.setInt(4, menuIdFromMenuMaster);
											pstmt.setString(5, pageLink);
											pstmt.setInt(6, orderOfDisplay);
											pstmt.executeUpdate();
										}
									}else
									{
										pstmt = con.prepareStatement(AdminStatements.INSERT_INTO_VERTICAL_MENU_DISPLAY);
										pstmt.setString(1, rs.getString("PROCESS_ID"));
										pstmt.setString(2, rs1.getString("SUB_PROCESS_ID"));
										if(menuGroupName.equals("0"))
										{
											pstmt.setObject(3, null);
										}else
											pstmt.setString(3, menuGroupName);
										pstmt.setInt(4, menuIdFromMenuMaster);
										pstmt.setString(5, pageLink);
										pstmt.setInt(6, orderOfDisplay);
										pstmt.executeUpdate();
									}
								}

							}
						}
					}
					if(processType.equals("Add-on Packages")) 
					{

						pstmt = con.prepareStatement(AdminStatements.SELECT_ALL_PROCESS_ID_FOR_VERTICAL_SOL_IN_PRODUCT_PROCESS);	
						rs = pstmt.executeQuery();
						while(rs.next())
						{
							pstmt10 = con.prepareStatement(AdminStatements.SELECT_SUB_PROCESS_ID_FROM_SUB_PROCESS);
							pstmt10.setString(1, rs.getString("PROCESS_ID"));
							pstmt10.setString(2, secondSubProcessIdForAddOnPackage);
							rs10 = pstmt10.executeQuery();
							if(rs10.next())
							{
								pstmt11 = con.prepareStatement(AdminStatements.SELECT_MENU_GROUP_ID_FROM_MENU_GROUP);
								pstmt11.setString(1, rs.getString("PROCESS_ID"));
								pstmt11.setString(2, rs10.getString("SUB_PROCESS_ID"));
								pstmt11.setString(3, secondMenuGroupIdForAddOnPackage);
								rs11 = pstmt11.executeQuery();
								if(rs11.next())
								{
										pstmt = con.prepareStatement(AdminStatements.INSERT_INTO_VERTICAL_MENU_DISPLAY);
										pstmt.setString(1, rs.getString("PROCESS_ID"));
										pstmt.setString(2, rs10.getString("SUB_PROCESS_ID"));
										pstmt.setString(3, rs11.getString("MENU_GROUP_ID"));
										pstmt.setInt(4, menuIdFromMenuMaster);
										pstmt.setString(5, pageLink);
										pstmt.setInt(6, orderOfDisplay);
										pstmt.executeUpdate();
								}
					       }
							
						}
					
	              }
					con.commit();
					message = "Inserted Successfully";
				} catch (Exception e) {
					e.printStackTrace();
					try {
						if (con != null) con.rollback();
					} catch (Exception ex) {
						ex.printStackTrace();
					}
				} finally {
					DBConnection.releaseConnectionToDB(con, pstmt, rs);
					DBConnection.releaseConnectionToDB(null, pstmt1, rs1);
					DBConnection.releaseConnectionToDB(null, pstmt2, rs2);
					DBConnection.releaseConnectionToDB(null, pstmt4, rs4);
					DBConnection.releaseConnectionToDB(null, pstmt10, rs10);
					DBConnection.releaseConnectionToDB(null, pstmt11, rs11);
				}
				return message;
			}			

			public String deleteAddFeatureDetails(int systemId,int processId,String PageLink) {
			    Connection con = null;
			    PreparedStatement pstmt = null;
			    PreparedStatement pstmt1 = null;
			    PreparedStatement pstmt2 = null;
			    ResultSet rs= null;
			    ResultSet rs1= null;
			    ResultSet rs2= null;
			    String message = "";
			    try {
			        con = DBConnection.getConnectionToDB("ADMINISTRATOR");
			        con.setAutoCommit(false);
			        pstmt = con.prepareStatement(AdminStatements.SELECT_MENU_ID_FROM_MENU_ITEM_MASTER);
			        pstmt.setString(1,PageLink);
			        rs = pstmt.executeQuery();
			        if(rs.next())
			        {
			        	 pstmt = con.prepareStatement(AdminStatements.DELETE_FROM_MENU_ITEM_TREE_STRUCTURE);
			        	 pstmt.setString(1,rs.getString("menu_item_id"));
			        	 pstmt.executeUpdate();
			         
			        	 pstmt1 = con.prepareStatement(AdminStatements.DELETE_FROM_T4U_GROUP_FEATURES);
					     pstmt1.setString(1,rs.getString("menu_item_id"));
				         pstmt1.executeUpdate();
					    
			        	 pstmt = con.prepareStatement(AdminStatements.DELETE_FROM_MENU_ITEM_MASTER);
			        	 pstmt.setString(1,PageLink);
					     pstmt.executeUpdate();
			        }
			        pstmt1 = con.prepareStatement(AdminStatements.SELECT_ELEMENT_ID_FROM_PRODUCT_ELEMENT);
			        pstmt1.setString(1,PageLink);
		        	rs1 = pstmt1.executeQuery();
			        if(rs1.next())
			        {
			        	
			        	pstmt2 = con.prepareStatement(AdminStatements.SELECT_MENU_ID_FROM_MENU_MASTER);
			        	pstmt2.setString(1,rs1.getString("ELEMENT_ID"));
			        	rs2 = pstmt2.executeQuery();
                        if(rs2.next())
                        {
                        	
   			        	     pstmt1 = con.prepareStatement(AdminStatements.DELETE_FROM_USER_PROCESS_DETACHMENT);
    			        	 pstmt1.setString(1,rs2.getString("MENU_ID"));
    			        	 pstmt1.executeUpdate();
    			        	 
    			        	    pstmt1 = con.prepareStatement(AdminStatements.DELETE_FROM_VERTICLE_MENU_DISPLAY);
    				        	pstmt1.setString(1,rs1.getString("ELEMENT_ID"));
    				        	pstmt1.setString(2,rs2.getString("MENU_ID"));
    				        	pstmt1.executeUpdate();
    	                       
    				        	pstmt1 = con.prepareStatement(AdminStatements.INSERT_INTO_MENU_HISTORY);
    				        	pstmt1.setString(1,rs1.getString("ELEMENT_ID"));
    				        	pstmt1.executeUpdate();
    			        }
			        	pstmt1 = con.prepareStatement(AdminStatements.DELETE_FROM_MENU_MASTER);
			        	pstmt1.setString(1,rs1.getString("ELEMENT_ID"));
			        	pstmt1.executeUpdate();
			        }
			         con.commit();
			        message = "Deleted Successfully";
			    } catch (Exception e) {
			        e.printStackTrace();
			        try {
			            if (con != null)
			                con.rollback();
			        } catch (Exception ex) {
			            ex.printStackTrace();
			        }
			    } finally {
			        DBConnection.releaseConnectionToDB(con, pstmt, rs);
			        DBConnection.releaseConnectionToDB(null, pstmt, rs1);
			        DBConnection.releaseConnectionToDB(null, pstmt, rs2);
			    }
			    return message;
			}
//************************************************************CREATE LTSP************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************//			
			public String CreateLtspAddAndModify(String company,String address,String city,String country,String postalCode,String latitude,String longitude,String category,String subcategory,String bccOil,String platformTitle,String companyLogo,String emailId,String phoneNo,String mobileNo,String currencyType,String panNo,String tinNo,String faxNo,String invoiceNo,String groupWiseBilling,String userName,String loginName,String password,String confirmPassword,String contactPerson) {
			    Connection con = null;
			    PreparedStatement pstmt = null;
			    PreparedStatement pstmt1 = null;
			    ResultSet rs = null;
			    ResultSet rs1 = null;
			    String message = "";
			    int maxSystemId=0;
			    String offset= "";
			    int OffsetMin = 0;
			    String zone ="";
			    String applicationUrl="";
			    String servicetax = null;
			    try {
			        con = DBConnection.getConnectionToDB("AMS");
			        con.setAutoCommit(false);
			        
			         //getting Max SystemId from System_Master
			        pstmt = con.prepareStatement(AdminStatements.SELECT_MAX_SYSTEM_ID_FROM_SYSTEM_MASTER);
			        rs = pstmt.executeQuery();
			        if(rs.next())
			        {
			        	maxSystemId=rs.getInt("SystemId");
			        }
			        maxSystemId++;
			        
			        //select offset and Zone from Country_Gmt table Based on Country selected from jsp.
			        pstmt = con.prepareStatement(AdminStatements.SELECT_OFFSET_FROM_COUNTRY_GMT);
			        pstmt.setString(1, country);
			        rs1 = pstmt.executeQuery();
			        if (rs1.next()) {
						offset = rs1.getString("GMT");
						zone = rs1.getString("ZONE");
						
						//Calculating for OffsetMin
						ArrayList<String> TList = new ArrayList<String>();
						StringTokenizer strToken1 = new StringTokenizer(offset,":");
						String Hr = "";
						String Min = "";
						while(strToken1.hasMoreTokens())
						{
							String TOff = strToken1.nextToken(); 
							TList.add(TOff);
						}
						Hr = TList.get(0);
						Min = TList.get(1);
						OffsetMin = (Integer.parseInt(Hr)*60)+Integer.parseInt(Min);
					}
			        
			        if(!category.equals("LTSPOverseas"))
					{   
						servicetax = "12%,2%,1%";
					}
			        
			       DESEncryptionDecryption DES = new DESEncryptionDecryption();
				   password= DES.encrypt(password);
				
			        //inserting all Details into System_Master Table.
			        pstmt = con.prepareStatement(AdminStatements.INSERT_CREATE_LTSP_INFORMATION);
				    pstmt.setInt(1, maxSystemId);
			        pstmt.setString(2, company);
			        pstmt.setString(3, address +"." + city + "-" +postalCode);
			        pstmt.setString(4, country);
			        pstmt.setString(5, latitude);
			        pstmt.setString(6, longitude);
			        pstmt.setString(7, category);
			        pstmt.setString(8, subcategory);
			        pstmt.setString(9, bccOil);
			        pstmt.setString(10, platformTitle);
			        pstmt.setString(11, companyLogo);
			        pstmt.setString(12, contactPerson);
			        pstmt.setString(13, emailId);
			        pstmt.setString(14, phoneNo);
			        pstmt.setString(15, currencyType);
			        pstmt.setString(16, panNo);
			        pstmt.setString(17, tinNo);
			        pstmt.setString(18, invoiceNo);
			        pstmt.setString(19, groupWiseBilling);
			        pstmt.setString(20, offset);
			        pstmt.setString(21, zone);
			        pstmt.setString(22, "THREAD_" + zone);
			        pstmt.setInt(23, OffsetMin);
			        pstmt.setString(24, servicetax);
			        int inserted = pstmt.executeUpdate();
			        if (inserted > 0) {
			        	//insert into AMS Users
			        	pstmt = con.prepareStatement(AdminStatements.INSERT_USER_DETAILS_INTO_AMS_USER_TABLE);
			        	pstmt.setString(1, userName);
			        	pstmt.setString(2, loginName);
			        	pstmt.setString(3, password);
			        	pstmt.setInt(4, maxSystemId);
			        	pstmt.setString(5, phoneNo);
			        	pstmt.setString(6, emailId);
			        	pstmt.executeUpdate();
			        	
			        	//insert into ADMINISTRATOR Users
			        	pstmt = con.prepareStatement(AdminStatements.INSERT_USER_DETAILS_INTO_ADMINISTRATOR_USER_TABLE);
			        	pstmt.setString(1, userName);
			        	pstmt.setString(2, loginName);
			        	pstmt.setString(3, password);
			        	pstmt.setInt(4, maxSystemId);
			        	pstmt.setString(5, phoneNo);
			        	pstmt.setString(6, emailId);
						pstmt.executeUpdate();
						
						pstmt1 = con.prepareStatement(AdminStatements.SELECT_APPLICATION_URL_FROM_SYSTEM_MASTER);
						pstmt1.setInt(1, maxSystemId);
						rs1 = pstmt1.executeQuery();
						if(rs1.next())
						{
							applicationUrl=rs.getString("ApplicationServer");
						}
						
						
						//insert into ADMINISTRATOR TSP MASTER
						pstmt = con.prepareStatement(AdminStatements.INSERT_DETAILS_TO_TSP_MASTER);
						pstmt.setInt(1, maxSystemId);
						pstmt.setString(2, company);
						pstmt.setString(3, address);
						pstmt.setString(4, city);
						pstmt.setString(5, country);
						pstmt.setString(6, postalCode);
						pstmt.setString(7, latitude);
						pstmt.setString(8, longitude);
						pstmt.setString(9, category);
						pstmt.setString(10, subcategory);
						pstmt.setString(11, platformTitle);
						pstmt.setString(12, companyLogo);
						pstmt.setString(13, zone);
						pstmt.setString(14, offset);
						pstmt.setString(15, bccOil);
						pstmt.setString(16, applicationUrl);
						pstmt.setInt(17, '1');
						pstmt.executeUpdate();
						

			         }
			        message = "Saved Successfully";
			        con.commit();
			    } catch (Exception e) {
			        e.printStackTrace();
			        try {
			            if (con != null)
			                con.rollback();
			        } catch (Exception ex) {
			            ex.printStackTrace();
			        }
			    } finally {
			        DBConnection.releaseConnectionToDB(con, pstmt, rs);
			        DBConnection.releaseConnectionToDB(null, pstmt1, rs1);
			    }
			    return message;
			}

		     public JSONArray getSubCategory(String categoryId) {
				    JSONArray JsonArray = null;
				    JSONObject JsonObject = null;
				    Connection con = null;
				    PreparedStatement pstmt = null;
				    ResultSet rs = null;
				    JsonObject = new JSONObject();
				    try {
				        JsonArray = new JSONArray();
				        con = DBConnection.getConnectionToDB("AMS");
				        pstmt = con.prepareStatement(AdminStatements.GET_SUB_CATEGORY_NAME);
				        pstmt.setString(1, categoryId);
				        rs = pstmt.executeQuery();
				        JsonObject.put("subCategoryID", "0");
				        JsonObject.put("subCategoryName", "None");
				        JsonArray.put(JsonObject);
				        while (rs.next()) {
				            JsonObject = new JSONObject();
				            JsonObject.put("subCategoryID", rs.getString("ID"));
				            JsonObject.put("subCategoryName", rs.getString("BUSINESS_GROUP"));
				            JsonArray.put(JsonObject);
				        }
				} catch (Exception e) {
				        e.printStackTrace();
				    } finally {
				        DBConnection.releaseConnectionToDB(con, pstmt, rs);
				    }
				    return JsonArray;
				}
		     
		     public JSONArray getCountryListForCreateLtsp() {
				    JSONArray JsonArray = null;
				    JSONObject JsonObject = null;
				    Connection con = null;
				    PreparedStatement pstmt = null;
				    ResultSet rs = null;
				    JsonObject = new JSONObject();
				    try {
				        JsonArray = new JSONArray();
				        con = DBConnection.getConnectionToDB("AMS");
				        pstmt = con.prepareStatement(AdminStatements.GET_COUNTRY_LIST_FOR_CREATE_LTSP);
				        rs = pstmt.executeQuery();
				        while (rs.next()) {
				            JsonObject = new JSONObject();
				            JsonObject.put("countryID", rs.getString("COUNTRY"));
				            JsonObject.put("countryName", rs.getString("COUNTRY"));
				            JsonArray.put(JsonObject);
				        }
				} catch (Exception e) {
				        e.printStackTrace();
				    } finally {
				        DBConnection.releaseConnectionToDB(con, pstmt, rs);
				    }
				    return JsonArray;
				}
		     
		     public ArrayList < Object > getCreateLtspReport() {
		    	 JSONArray JsonArray = new JSONArray();
		    	 JSONObject JsonObject = null;
		    	 Connection con = null;
		    	 PreparedStatement pstmt = null;
		    	 ResultSet rs = null;
		    	 ArrayList < Object > finlist = new ArrayList < Object > ();
		    	 try {
		    		 int count = 0;
		    		 con = DBConnection.getConnectionToDB("AMS");
		    		 pstmt = con.prepareStatement(AdminStatements.GET_CREATE_LTSP_REPORT);
		    		 rs = pstmt.executeQuery();
		    		 while (rs.next()) {
		    			 JsonObject = new JSONObject();
		    			 count++;
		    			 JsonObject.put("slnoIndex", count);

		    			 JsonObject.put("systemIdDataIndex", rs.getString("SystemId"));
		    			 JsonObject.put("ltspNameDataIndex", rs.getString("LtspName"));
		    			 JsonObject.put("addressDataIndex", rs.getString("address"));
		    			// String address=rs.getString("address");
		    			// String[] City = address.split(".");
		    			// String part1 = City[0];
		    			// String part2 = City[1];
		    			// System.out.println("part1================"  +part1);
		    			// System.out.println("part2================"  +part2);
		    			 
		    			 JsonObject.put("countryDataIndex", rs.getString("country"));
		    			 JsonObject.put("latitudeDataIndex", rs.getString("latitude"));
		    			 JsonObject.put("longitudeDataIndex", rs.getString("Longitude"));
		    			 JsonObject.put("categoryDataIndex", rs.getString("Category"));


		    			 JsonObject.put("categoryTypeDataIndex", rs.getString("CategoryType"));
		    			 JsonObject.put("bbcOilDataIndex", rs.getString("bbcOil"));
		    			 JsonObject.put("titleDataIndex", rs.getString("Title"));
		    			 JsonObject.put("logoDataIndex", rs.getString("logo"));
		    			 JsonObject.put("contactPersonDataIndex", rs.getString("ContactPerson"));
		    			 JsonObject.put("emailIdDataIndex", rs.getString("emailId"));
		    			 JsonObject.put("telephoneNoDataIndex", rs.getString("TelephoneNo"));

		    			 JsonObject.put("unitOfMeasureDataIndex", rs.getString("UnitOfMeasure"));
		    			 if(rs.getString("PanNo").equals(null) || rs.getString("PanNo").equals("na") || rs.getString("PanNo").equals("") || rs.getString("PanNo").equals("NA"))
		    			 {
		    				 JsonObject.put("panNoDataIndex", ""); 
		    			 }else
		    			 {
		    			 JsonObject.put("panNoDataIndex", rs.getString("PanNo"));
		    			 }
		    			 
		    			 if(rs.getString("tinNo").equals(null) || rs.getString("tinNo").equals("na") || rs.getString("tinNo").equals("") || rs.getString("tinNo").equals("NA"))
		    			 {
		    				 JsonObject.put("tinNoDataIndex", ""); 
		    			 }else
		    			 {
		    			 JsonObject.put("tinNoDataIndex", rs.getString("tinNo"));
		    			 }
		    			 
		    			 if(rs.getString("InvoiceNo").equals(null) || rs.getString("InvoiceNo").equals("na") || rs.getString("InvoiceNo").equals("") || rs.getString("InvoiceNo").equals("NA"))
		    			 {
		    				 JsonObject.put("invoiceNoDataIndex", ""); 
		    			 }else
		    			 {
		    			 JsonObject.put("invoiceNoDataIndex", rs.getString("InvoiceNo"));
		    			 }
		    			 
		    			 JsonObject.put("groupWiseDataIndex", rs.getString("GroupWiseBilling"));
		    			 JsonObject.put("categoryTypeIdDataIndex", rs.getString("CateId"));
		    			 

		    			 JsonObject.put("statusDataIndex", "");

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
		     
		 	public String CreateLtspModify(String company,String address,String city,String country,String postalCode,String latitude,String longitude,String category,String subcategory,String bccOil,
		 			String platformTitle,String companyLogo,String emailId,String phoneNo,String mobileNo,String currencyType,String panNo,String tinNo,String faxNo,String invoiceNo,String groupWiseBilling,String contactPerson,int systemId,String categoryId1) {
				    Connection con = null;
				    PreparedStatement pstmt = null;
				    PreparedStatement pstmt1 = null;
				    PreparedStatement pstmt2 = null;
				    String message = "";
				    try {
				        con = DBConnection.getConnectionToDB("ADMINISTRATOR");
				        pstmt = con.prepareStatement(AdminStatements.UPDATE_CREATE_LTSP_DETAILS);
				        pstmt.setString(1, company);
				        pstmt.setString(2, address +"." + city + "-" +postalCode);
				        pstmt.setString(3, country);
				        pstmt.setString(4, latitude);
				        pstmt.setString(5, longitude);
				        pstmt.setString(6, category);
				        pstmt.setString(7, categoryId1);
				        pstmt.setString(8, bccOil);
				        pstmt.setString(9, platformTitle);
				        pstmt.setString(10, companyLogo);
				        pstmt.setString(11, contactPerson);
				        pstmt.setString(12, emailId);
				        pstmt.setString(13, phoneNo);
				        pstmt.setString(14, currencyType);
				        pstmt.setString(15, panNo);
				        pstmt.setString(16, tinNo);
				        pstmt.setString(17, invoiceNo);
				        pstmt.setString(18, groupWiseBilling);
				        pstmt.setInt(19, systemId);
				        int updated = pstmt.executeUpdate();
				        if (updated > 0) {
				             message = "Updated Successfully";
				        }
				    } catch (Exception e) {
				        e.printStackTrace();
				    } finally {
				    	DBConnection.releaseConnectionToDB(null, pstmt1, null);
				        DBConnection.releaseConnectionToDB(null, pstmt2, null);
				        DBConnection.releaseConnectionToDB(con, pstmt, null);
				    }
				    return message;
				}
		 	
		 //****************************************************vertical summary report  *****************************//
  
		 	public ArrayList < Object > getVerticalSummryReport( int systemid, int type1,String language) {
		 		JSONArray JsonArray = new JSONArray();
		 		JSONObject JsonObject = null;
		 		Connection con = null;
		 		PreparedStatement pstmt = null;
		 		ResultSet rs = null;
		 		ArrayList < ReportHelper > reportsList = new ArrayList < ReportHelper > ();
		 		ArrayList < String > headersList = new ArrayList < String > ();
		 		ReportHelper finalreporthelper = new ReportHelper();
		 		ArrayList < Object > finlist = new ArrayList < Object > ();
		 		int  type =  type1;
		 		try {
		 			int count = 0;
		 			headersList.add(cf.getLabelFromDB("SLNO", language));
		 			headersList.add(cf.getLabelFromDB("Region_Name", language));
		 			headersList.add(cf.getLabelFromDB("Ltsp_Name", language));
		 			headersList.add(cf.getLabelFromDB("Customer_Name", language));
		 			headersList.add(cf.getLabelFromDB("Vertical_Name", language));
		 			headersList.add(cf.getLabelFromDB("Vehicle_Count", language));

		 			con = DBConnection.getConnectionToDB("ADMINISTRATOR");

		 			if (type == 1) {
		 				pstmt = con.prepareStatement(AdminStatements.GET_VERTICAL_REPORT);
		 			} 
		 			if (type == 2) {
		 				pstmt = con.prepareStatement(AdminStatements.GET_LTSP_REPORT);
		 			}
		 			if (type == 3){
		 				pstmt = con.prepareStatement(AdminStatements.GET_REGION_REPORT);
		 			}
		 			rs = pstmt.executeQuery();
		 			
		 			while (rs.next()) {
		 				JsonObject = new JSONObject();
		 				count++;
		 				ArrayList<Object> informationList = new ArrayList<Object>();
		 				ReportHelper reporthelper = new ReportHelper();

		 				informationList.add(count);
		 				JsonObject.put("slnoIndex", count);
		 				if(type == 1)
		 				{
		 					JsonObject.put("verticalNameDataIndex", rs.getString("VERTICAL_NAME"));
		 					JsonObject.put("vehicleCountDataIndex", rs.getString("VEHICLE_COUNT"));


		 					informationList.add("");
		 					informationList.add("");
		 					informationList.add("");
		 					informationList.add(rs.getString("VERTICAL_NAME"));
		 					informationList.add(rs.getString("VEHICLE_COUNT"));

		 				}
		 				if (type == 2) {
		 					JsonObject.put("LTSPNameDataIndex", rs.getString("LTSP_NAME"));
		 					JsonObject.put("customerNameDataIndex", rs.getString("CUSTOMER_NAME"));
		 					JsonObject.put("verticalNameDataIndex", rs.getString("VERTICAL_NAME"));
		 					JsonObject.put("vehicleCountDataIndex", rs.getString("VEHICLE_COUNT"));

		 					informationList.add("");
		 					informationList.add(rs.getString("LTSP_NAME"));
		 					informationList.add(rs.getString("CUSTOMER_NAME"));
		 					informationList.add(rs.getString("VERTICAL_NAME"));
		 					informationList.add(rs.getString("VEHICLE_COUNT"));

		 				}
		 				if (type == 3) {
		 					JsonObject.put("RegionNameDataIndex", rs.getString("REGION_NAME"));
		 					JsonObject.put("LTSPNameDataIndex", rs.getString("LTSP_NAME"));
		 					JsonObject.put("customerNameDataIndex", rs.getString("CUSTOMER_NAME"));
		 					JsonObject.put("verticalNameDataIndex", rs.getString("VERTICAL_NAME"));
		 					JsonObject.put("vehicleCountDataIndex", rs.getString("VEHICLE_COUNT"));

		 					informationList.add(rs.getString("REGION_NAME"));
		 					informationList.add(rs.getString("LTSP_NAME"));
		 					informationList.add(rs.getString("CUSTOMER_NAME"));
		 					informationList.add(rs.getString("VERTICAL_NAME"));
		 					informationList.add(rs.getString("VEHICLE_COUNT"));

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
		 	
		 	
		 	
		 	
			//*********************************************************************************************************************8//
				 	
				 	public JSONArray getRegion(int systemId) {
					    JSONArray JsonArray = null;
					    JSONObject JsonObject = null;
					    Connection con = null;
					    PreparedStatement pstmt = null;
					    ResultSet rs = null;
					    try {
					        JsonArray = new JSONArray();
					        con = DBConnection.getConnectionToDB("ADMINISTRATOR");
					        pstmt = con.prepareStatement(AdminStatements.GET_REGION);
					        rs = pstmt.executeQuery();
					        while (rs.next()) {
					            JsonObject = new JSONObject();
					            JsonObject.put("Region", rs.getString("Region"));
					            JsonObject.put("Value",rs.getString("id"));
					            JsonArray.put(JsonObject);
					        }
					    } catch (Exception e) {
					        e.printStackTrace();
					    } finally {
					        DBConnection.releaseConnectionToDB(con, pstmt, rs);
					    }
					    return JsonArray;
					}
				 	
				 	
//**************************************************Customer Master Report *******************************************************//
		 	public ArrayList < Object > getCustomerMasterReport( int systemid,String language,int RegionId) {
		 		JSONArray JsonArray = new JSONArray();
		 		JSONObject JsonObject = null;
		 		Connection con = null;
		 		PreparedStatement pstmt = null;
		 		ResultSet rs = null;
		 		ArrayList < ReportHelper > reportsList = new ArrayList < ReportHelper > ();
		 		ArrayList < String > headersList = new ArrayList < String > ();
		 		ReportHelper finalreporthelper = new ReportHelper();    
		 		ArrayList < Object > finlist = new ArrayList < Object > ();
		 		SimpleDateFormat sdf1 = new SimpleDateFormat("yyyy/MM/dd");
		 		SimpleDateFormat sdf2 = new SimpleDateFormat("dd-MM-yyyy");
		 		try {
		 			int count = 0;
		 			headersList.add(cf.getLabelFromDB("SLNO", language));
		 			headersList.add(cf.getLabelFromDB("Ltsp_Name", language));
		 			headersList.add(cf.getLabelFromDB("Place", language));
		 			headersList.add(cf.getLabelFromDB("Customer_Name", language));
		 			headersList.add(cf.getLabelFromDB("Business_Vertical", language));
		 			headersList.add(cf.getLabelFromDB("Vertical_Stream", language));
		 			headersList.add(cf.getLabelFromDB("No_Of_Vehicles", language));
		 			headersList.add(cf.getLabelFromDB("More_Potential", language));
		 			headersList.add(cf.getLabelFromDB("Date_Of_Acquisition", language));
		 			headersList.add(cf.getLabelFromDB("Reason_For_Not_Closing_The_pending_The_Potential", language));
		 			headersList.add(cf.getLabelFromDB("CRC_Last_CallDate", language));
		 			headersList.add(cf.getLabelFromDB("CRC_LastCall_Description", language));
		 			headersList.add(cf.getLabelFromDB("Issues_If_Any", language));
		 			headersList.add(cf.getLabelFromDB("Contact_Person", language));
		 			headersList.add(cf.getLabelFromDB("Contact_No", language));
			 		 headersList.add("");
			 		 headersList.add("");
			 		 headersList.add("");
			 		 headersList.add("");
		 			 
		 			 con = DBConnection.getConnectionToDB("ADMINISTRATOR");
		 			 pstmt = con.prepareStatement(AdminStatements.GET_CUSTOMER_REPORT);
		 			 pstmt.setInt(1, RegionId);
		 			 pstmt.setInt(2,RegionId);
		 			 rs = pstmt.executeQuery();

		 			 while (rs.next()) {
		 				 JsonObject = new JSONObject();
		 				 count++;
		 				 ArrayList<Object> informationList = new ArrayList<Object>();
		 				 ReportHelper reporthelper = new ReportHelper();
		 				 
		 				
		 				 JsonObject.put("slnoIndex", count);
		 				 informationList.add(count);
		 				 
		 				//JsonObject.put("systemDataIndex",rs.getString("System_id"));
		 			//	JsonObject.put("customerDataIndex", rs.getString("CUSTOMER_ID"));
		 				
		 				
		 				
		 				
		 				 if(rs.getString("System_Name").equals("") || rs.getString("System_Name").equals(null))
		 				 {
		 					JsonObject.put("ltspDataIndex", "");
			 				informationList.add("");
		 				 }else
		 				 {
		 					 JsonObject.put("ltspDataIndex", rs.getString("System_Name"));
			 				 informationList.add(rs.getString("System_Name"));
		 				 }
		 				
		 				 if(rs.getString("COUNTRY") == null || rs.getString("COUNTRY").equals(""))
		 				 {
		 					JsonObject.put("placeDataIndex", "");
			 				informationList.add("");
		 				 }else
		 				 {
		 					JsonObject.put("placeDataIndex", rs.getString("COUNTRY").toUpperCase());
			 				informationList.add(rs.getString("COUNTRY").toUpperCase());
		 				 }
		 				 
		 				 
		 				 if(rs.getString("NAME") == null || rs.getString("NAME").equals(""))
		 				 {
		 					JsonObject.put("clientNameDataIndex", "");
			 				informationList.add("");
		 				 }else
		 				 {
		 					JsonObject.put("clientNameDataIndex", rs.getString("NAME"));
			 				informationList.add(rs.getString("NAME"));
		 				 }
		 				 
		 				 
		 				// JsonObject.put("clientNameDataIndex", rs.getString("NAME"));
		 				//.add(rs.getString("NAME"));
		 				 
		 				 if(rs.getString("PROCESS_LABEL_ID") == null || rs.getString("PROCESS_LABEL_ID").equals(""))
		 				 {
		 					JsonObject.put("businessVerticalDataIndex", "");
			 				informationList.add("");
		 				 }else
		 				 {
		 					JsonObject.put("businessVerticalDataIndex", rs.getString("PROCESS_LABEL_ID"));
			 				informationList.add(rs.getString("PROCESS_LABEL_ID"));
		 				 }
		 				 
		 				// JsonObject.put("businessVerticalDataIndex", rs.getString("PROCESS_LABEL_ID"));
		 				// informationList.add(rs.getString("PROCESS_LABEL_ID"));
		 				 
		 				if(rs.getString("VERTICAL_STREAM")==null || rs.getString("VERTICAL_STREAM").equals(""))
		 				 {
		 					JsonObject.put("verticalStreamDataIndex", "");
			 				informationList.add("");
		 				 }else
		 				 {
		 					JsonObject.put("verticalStreamDataIndex", rs.getString("VERTICAL_STREAM"));
			 				informationList.add(rs.getString("VERTICAL_STREAM"));
		 				 }
		 				
		 				// JsonObject.put("verticalStreamDataIndex", rs.getString("VERTICAL_STREAM"));
		 				// informationList.add(rs.getString("VERTICAL_STREAM"));
		 				
		 				if(rs.getString("VEHICLE_COUNT")==null || rs.getString("VEHICLE_COUNT").equals(""))
		 				 {
		 					JsonObject.put("noOfVehiclesDataIndex", "");
			 				informationList.add("");
		 				 }else
		 				 {
		 					JsonObject.put("noOfVehiclesDataIndex", rs.getString("VEHICLE_COUNT"));
			 				informationList.add(rs.getString("VEHICLE_COUNT"));
		 				 }
		 				 
		 			//	 JsonObject.put("noOfVehiclesDataIndex", rs.getString("VEHICLE_COUNT"));
		 			//	 informationList.add(rs.getString("VEHICLE_COUNT"));
		 				
		 				if(rs.getString("MORE_POTENTIAL")==null || rs.getString("MORE_POTENTIAL").equals(""))
		 				 {
		 					JsonObject.put("morePotentialDataIndex", "");
			 				informationList.add("");
		 				 }else
		 				 {
		 					JsonObject.put("morePotentialDataIndex", rs.getString("MORE_POTENTIAL"));
			 				informationList.add(rs.getString("MORE_POTENTIAL"));
		 				 }
		 				
		 				// JsonObject.put("morePotentialDataIndex", rs.getString("MORE_POTENTIAL"));
		 				// informationList.add(rs.getString("MORE_POTENTIAL"));

		 				
		 		    	//JsonObject.put("pendingPotentialDataIndex", rs.getString("REASON_FOR_POTENTIAL_OPEN"));
		 				// informationList.add(rs.getString("REASON_FOR_POTENTIAL_OPEN"));
		 				
		 				 if (rs.getString("CREATED_TIME") == null || rs.getString("CREATED_TIME").equals("") || rs.getString("CREATED_TIME").contains("1900")) {
		 					 JsonObject.put("acquisitionDateDataIndex", "");
		 					 informationList.add("");
		 				 } else {
		 					 JsonObject.put("acquisitionDateDataIndex", sdf1.format(rs.getTimestamp("CREATED_TIME")));
		 					 informationList.add(sdf2.format(rs.getTimestamp("CREATED_TIME")));
		 				 }
		 				 
		 				 if(rs.getString("REASON_FOR_POTENTIAL_OPEN")==null|| rs.getString("REASON_FOR_POTENTIAL_OPEN").equals(""))
		 				 {
		 					JsonObject.put("pendingPotentialDataIndex", "");
			 				informationList.add("");
		 				 }else
		 				 {
		 					JsonObject.put("pendingPotentialDataIndex", rs.getString("REASON_FOR_POTENTIAL_OPEN"));
			 				informationList.add(rs.getString("REASON_FOR_POTENTIAL_OPEN"));
		 				 }
		 				
		 				 
		 				 if (rs.getString("CRC_LAST_CALL_DATE") == null || rs.getString("CRC_LAST_CALL_DATE").equals("") || rs.getString("CRC_LAST_CALL_DATE").contains("1900")) {
		 					 JsonObject.put("lastCallDateDataIndex", "");
		 					 informationList.add("");
		 				 } else {
		 					 JsonObject.put("lastCallDateDataIndex", sdf1.format(rs.getTimestamp("CRC_LAST_CALL_DATE")));
		 					 informationList.add(sdf2.format(rs.getTimestamp("CRC_LAST_CALL_DATE")));
		 				 }
		 				 
		 			    // JsonObject.put("lastCallDataIndex", rs.getString("CRC_LAST_CALL_DESC"));
		 				// informationList.add(rs.getString("CRC_LAST_CALL_DESC"));
		 				 
		 				if(rs.getString("CRC_LAST_CALL_DESC")==null|| rs.getString("CRC_LAST_CALL_DESC").equals(""))
		 				 {
		 					JsonObject.put("lastCallDataIndex", "");
			 				informationList.add("");
		 				 }else
		 				 {
		 					JsonObject.put("lastCallDataIndex", rs.getString("CRC_LAST_CALL_DESC"));
			 				informationList.add(rs.getString("CRC_LAST_CALL_DESC"));
		 				 }
		 				
		 				if(rs.getString("ISSUES")==null || rs.getString("ISSUES").equals(""))
		 				 {
		 					JsonObject.put("IsssueDataIndex", "");
			 				informationList.add("");
		 				 }else
		 				 {
		 					JsonObject.put("IsssueDataIndex", rs.getString("ISSUES"));
			 				informationList.add(rs.getString("ISSUES"));
		 				 }
		 				
		 				// JsonObject.put("IsssueDataIndex", rs.getString("ISSUES"));
		 				// informationList.add(rs.getString("ISSUES"));
		 				
		 				if(rs.getString("CONTACT_PERSON")==null|| rs.getString("CONTACT_PERSON").equals(""))
		 				 {
		 					JsonObject.put("contactPersonDataIndex", "");
			 				informationList.add("");
		 				 }else
		 				 {
		 					JsonObject.put("contactPersonDataIndex", rs.getString("CONTACT_PERSON"));
			 				informationList.add(rs.getString("CONTACT_PERSON"));
		 				 }
		 				 
		 				
		 				if(rs.getString("CONTACT_NO")==null || rs.getString("CONTACT_NO").equals(""))
		 				 {
		 					JsonObject.put("contactNumberDataIndex", "");
			 				informationList.add("");
		 				 }else
		 				 {
		 					JsonObject.put("contactNumberDataIndex", rs.getString("CONTACT_NO"));
			 				informationList.add(rs.getString("CONTACT_NO"));
		 				 }
		 				
		 				if(rs.getString("PROCESS_ID")==null || rs.getString("PROCESS_ID").equals(""))
		 				 {
		 					JsonObject.put("verticaIdDataIndex", "");
			 				informationList.add("");
		 				 }else
		 				 {
		 					JsonObject.put("verticaIdDataIndex", rs.getString("PROCESS_ID"));
			 				informationList.add("");
		 				 }
		 				
		 				
		 				if(rs.getString("ID")==null || rs.getString("ID").equals(""))
		 				 {
		 					JsonObject.put("IdDataIndex", "");
			 				informationList.add("");
		 				 }else
		 				 {
		 					JsonObject.put("IdDataIndex", rs.getString("ID"));
			 				informationList.add("");
		 				 }
		 				
		 				 if(rs.getString("CUSTOMER_ID").equals("") || rs.getString("CUSTOMER_ID").equals(null))
		 				 {
		 					JsonObject.put("customerDataIndex", "");
			 				informationList.add("");
		 				 }else
		 				 {
		 					 JsonObject.put("customerDataIndex", rs.getString("CUSTOMER_ID"));
		 					informationList.add("");
		 				 }
		 				 
		 				if(rs.getString("System_id").equals("") || rs.getString("System_id").equals(null))
		 				 {
		 					JsonObject.put("systemDataIndex", "");
			 				informationList.add("");
		 				 }else
		 				 {
		 					 JsonObject.put("systemDataIndex", rs.getString("System_id"));
		 					informationList.add("");
		 				 }
		 				
		 				
		 				 
		 			//	JsonObject.put("verticaIdDataIndex", rs.getString("PROCESS_ID"));
		 				//informationList.add("");
		 			//	JsonObject.put("IdDataIndex", rs.getString("ID"));
		 			//	informationList.add("");
		 				//informationList.add("");
		 				//informationList.add("");
		 				// informationList.add(rs.getString("CONTACT_NO"));

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
	//-----------------------------------------------------------------------------------------------------------------------------//
			public String modifyCustomerInformation(int regionId,String place,String verticalStream,String pendingPotentialReason,String lastCallDate,String lastCall,String issueDate,String contactPerson,String contactNumber,String ltspName,String custName,String businessVertical,int noOfVehicles,String acqDate,int systemIdFromJsp,int custId,int verticalId,String morePotential,int IdFromCustomerMaster) {
				Connection con = null;
			    PreparedStatement pstmt = null;
			    String message = "";
			    ResultSet rs = null;
			    try {
			        con = DBConnection.getConnectionToDB("ADMINISTRATOR");
			        con.setAutoCommit(false);
			        
			        if(IdFromCustomerMaster !=0)
			        {
			        	 pstmt = con.prepareStatement(AdminStatements.MOVE_RECORD_TO_CUSTOMER_MASTER_HISTORY);
					     pstmt.setInt(1, systemIdFromJsp);
					     pstmt.setInt(2, custId);
					     pstmt.executeUpdate();
					     
					     pstmt = con.prepareStatement(AdminStatements.UPDATE_CUSTOMER_MASTER_REPORT);
					     pstmt.setInt(1, verticalId);
					     pstmt.setString(2, verticalStream);
					     pstmt.setInt(3, noOfVehicles);
					     pstmt.setString(4, morePotential);
					     pstmt.setString(5, acqDate);
					     pstmt.setString(6, pendingPotentialReason);
					     pstmt.setString(7, lastCallDate);
					     pstmt.setString(8, lastCall);
					     pstmt.setString(9 ,issueDate);
					     pstmt.setString(10, contactPerson);
					     pstmt.setString(11, contactNumber);
					     pstmt.setInt(12, systemIdFromJsp);
					     pstmt.setInt(13, custId);
					     pstmt.executeUpdate();
			        }else
			        {
			        pstmt = con.prepareStatement(AdminStatements.INSERT_CUSTOMER_INFORMATION);
			        pstmt.setInt(1, systemIdFromJsp);
			        pstmt.setInt(2, custId);
			        pstmt.setInt(3, verticalId);
			        pstmt.setString(4, verticalStream);
			        pstmt.setInt(5, noOfVehicles);
			        pstmt.setString(6, morePotential);
			        pstmt.setString(7, acqDate);
			        pstmt.setString(8, pendingPotentialReason);
			        pstmt.setString(9, lastCallDate);
			        pstmt.setString(10, lastCall);
			        pstmt.setString(11 ,issueDate);
			        pstmt.setString(12, contactPerson);
			        pstmt.setString(13, contactNumber);
			        pstmt.executeUpdate();
			        }
			        message = "Updated Successfully";
			        con.commit();
			    } catch (Exception e) {
			        e.printStackTrace();
			        try {
			            if (con != null)
			                con.rollback();
			        } catch (Exception ex) {
			            ex.printStackTrace();
			        }
			    } finally {
			    	
			        DBConnection.releaseConnectionToDB(con, pstmt, null);
			    }
			    return message;
			}
			
			
			//******************************************************************************************************************
			public JSONArray getgroupnamesForAlert(int systemId, int clientId, int userId) {
			    JSONArray JsonArray = null;
			    JSONObject JsonObject = null;
			    Connection con = null;
			    PreparedStatement pstmt = null;
			    ResultSet rs = null;
			    try {
			    	JsonObject = new JSONObject();
			        JsonArray = new JSONArray();
			        con = DBConnection.getConnectionToDB("AMS");
			        pstmt = con.prepareStatement(AdminStatements.SELECT_GROUP_LIST_FOR_MANAGE_ASSET);
			        pstmt.setInt(1, systemId);
			        pstmt.setInt(2, clientId);
			        pstmt.setInt(3, userId);
			        rs = pstmt.executeQuery();
			        JsonObject.put("groupId", "0");
			        JsonObject.put("groupName", "ALL");
			        JsonArray.put(JsonObject);
			        while (rs.next()) {
			        	JsonObject = new JSONObject();
			            JsonObject.put("groupId", rs.getString("GROUP_ID"));
			            JsonObject.put("groupName", rs.getString("GROUP_NAME"));
			            JsonArray.put(JsonObject);
			        }
			    } catch (Exception e) {
			        e.printStackTrace();
			    } finally {
			        DBConnection.releaseConnectionToDB(con, pstmt, rs);
			    }
			    return JsonArray;
			}
			
			public JSONArray getDriverList(int sysid, String clientId, String groupId) {
				JSONArray jsonArray = new JSONArray();
				JSONObject jsonObject = null;
		   	 	Connection con=null;
		   	 	PreparedStatement pstmt=null;
		   	 	ResultSet rs=null;
		   	 	try
				{
		   	 	con = DBConnection.getConnectionToDB("AMS");
		   	 	if(Integer.parseInt(groupId.trim())>0){
		   	 	pstmt = con.prepareStatement(AdminStatements.GET_DRIVERS_ASSOCIATE_TO_GROUP);
			    pstmt.setInt(1,sysid);
		   	 	pstmt.setString(2,clientId);
		   	 	pstmt.setString(3,groupId);
		   	 	}
		   	 	else{
		   	 	pstmt = con.prepareStatement(AdminStatements.GET_DRIVERS_FOR_CLIENT);
			    pstmt.setInt(1,sysid);
		   	 	pstmt.setString(2,clientId);
		   	 	}
		   	 	rs=pstmt.executeQuery();
		   	 		
		        while(rs.next())
		   	 	{
		   	 	jsonObject = new JSONObject();
		   	 	jsonObject.put("driverName", rs.getString("Fullname"));
		   	    jsonObject.put("driverId", rs.getString("Driver_id"));
		   	 	jsonArray.put(jsonObject);
		   	 	}
				}
		   	 	catch(Exception e)
				{
				e.printStackTrace();
				}
				finally
				{
					DBConnection.releaseConnectionToDB(con,pstmt,rs);
				}
				
			  	return jsonArray;
			}
			
			public ArrayList<Object> generateReport(String selectedDriverIds,
					String startdate, String enddate, int offset, String language,
						int systemId,int custid,String groId ) {
					
				
				ArrayList<Object> finlist = new ArrayList<Object>();
				DecimalFormat df = new DecimalFormat("0.##");
				SimpleDateFormat sdf= new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
				 SimpleDateFormat sdf1 = new SimpleDateFormat("MM/dd/yyyy HH:mm:ss");
					
				if (startdate.contains("T")) {
					startdate = startdate.substring(0,startdate.indexOf("T"));
					startdate = startdate+" 00:00:00";
				}else{
					startdate = startdate.substring(0,startdate.indexOf(" "));
					startdate = startdate+" 00:00:00";
				}
				
				if (enddate.contains("T")) {
					enddate = enddate.substring(0,enddate.indexOf("T"));
					enddate = enddate+" 00:00:00";
				}else{
					enddate = enddate.substring(0,enddate.indexOf(" "));
					enddate = enddate+" 00:00:00";
				}
				
				try{
				java.util.Date strtdat=sdf.parse(startdate); 
				java.util.Date endDate=sdf.parse(enddate);
				startdate=cf.getGMTDateTime(sdf1.format(strtdat), offset);
				enddate=cf.getGMTDateTime(sdf1.format(endDate), offset);
				}
				catch(Exception e){
					
				}
				
				
				ArrayList<String> driverArrayList = new ArrayList<String>();
				String driverIdStr = "(";
				String tempDriver="";
				if(selectedDriverIds != null){
					StringTokenizer st = new StringTokenizer(selectedDriverIds,"||");
					while(st.hasMoreElements()){
						tempDriver = (String) st.nextElement();
						driverIdStr = driverIdStr + tempDriver+"," ;
						driverArrayList.add(tempDriver.trim());
					}
					if(driverIdStr.contains(",")){
						driverIdStr = driverIdStr.substring(0,driverIdStr.lastIndexOf(","));
					}
				}
				driverIdStr = driverIdStr + ")";
			 
				DriverEvaluation de = new DriverEvaluation(systemId,custid,driverIdStr,groId,startdate,enddate,driverArrayList);
				HashMap driverScore = de.getDriverScorePDO();
				
				JSONArray list = new JSONArray(); 
				JSONObject rslt = new JSONObject(); 
				
				Set set = driverScore.entrySet();
				Iterator it = set.iterator();
				int count = 0;
				
				ArrayList<ReportHelper> positionList = new ArrayList<ReportHelper>();
			//	ArrayList positionList=new ArrayList();
				
				try{
					while(it.hasNext()){
						count++;
						Map.Entry me = (Map.Entry)it.next();
					    int driverId = Integer.parseInt(me.getKey().toString());
					    DriverEvaluationDTO deDTO = (DriverEvaluationDTO)me.getValue();
					    
					    ReportHelper reporthelper=new ReportHelper();
					    ArrayList<String> tempList = new ArrayList<String>();
					    
					    JSONObject obj = new JSONObject();
					    obj.put("slnoIndex1",count);
						tempList.add(String.valueOf(count));
					    
						obj.put("rowid",count);
						tempList.add(String.valueOf(count));
						
						String temp = deDTO.getDriverName();
						obj.put("driverName",temp);
						tempList.add(temp);
						
						obj.put("startDate","");
						tempList.add("");
						
						temp = df.format(deDTO.getDistanceDrived());
						obj.put("distanceTravelled",temp);
						tempList.add(temp);
						
						temp = df.format(deDTO.getOverspeeddurationgraded());
						obj.put("durationingr",temp);
						tempList.add(temp);
						
						temp = df.format(deDTO.getOverspeeddurationblacktop());
						obj.put("durationinbt",temp);
						tempList.add(temp);
						
						temp = String.valueOf((int)deDTO.getOverspeedCount());
						obj.put("totaloverspeed",temp);
						tempList.add(temp);
						
						temp = df.format(deDTO.getOverspeedCountScore());
						obj.put("overspeedscore",temp);
						tempList.add(temp);
						
						temp =  df.format(deDTO.getMaxSpeed());
						obj.put("maxspeed",temp);
						tempList.add(temp);
						
						temp = String.valueOf((int)deDTO.getAcclCount()); 
						obj.put("acclcount",temp);
						tempList.add(temp);
						
						temp = df.format(deDTO.getAcclCountScore());
						obj.put("acclcountscore",temp);
						tempList.add(temp);
						
						temp = String.valueOf((int)deDTO.getDeclCount()); 
						obj.put("declcount",temp);
						tempList.add(temp);
						
						temp = df.format(deDTO.getDeclCountScore());
						obj.put("declcountscore",temp);
						tempList.add(temp);
						
						temp =  df.format(deDTO.getTotalScore());
						obj.put("totalscore",temp);
						tempList.add(temp);
						
						list.put(obj);
						
					    reporthelper.setInformationList(tempList);
				    	positionList.add(reporthelper);
					}
					rslt.put("driverdatapdo", list);
					finlist.add(list);
					
					ArrayList headerList = getHeaderList();
					ReportHelper finalreporthelper = new ReportHelper();
					finalreporthelper.setReportsList(positionList);
					finalreporthelper.setHeadersList(headerList);
					finlist.add(finalreporthelper);
					
							
						}catch(Exception e){
						 e.printStackTrace();
						}
						return finlist;
						
					}
			public ArrayList getHeaderList(){
				ArrayList headerList = new ArrayList();
				headerList.add("SL NO");
				headerList.add("ROW NO");
				headerList.add("DRIVER NAME");
				headerList.add("START DATE");
				headerList.add("DISTANCE DRIVEN(kms)");
				headerList.add("OVERSPEED DURATION IN GRADED ROADS(secs)");
				headerList.add("OVERSPEED DURATION IN BLACKTOP ROADS(secs)");
				headerList.add("TOTAL OVERSPEED DURATION(secs)");
				headerList.add("OVERSPEED SCORE(/100kms)");
				headerList.add("MAX SPEED(kms/hr)");
				headerList.add("HARSH ACCL COUNT");
				headerList.add("HARSH ACCL SCORE(/100kms)");
				headerList.add("HARSH BRAKING COUNT");
				headerList.add("HARSH BRAKING SCORE(/100kms))");
				headerList.add("RAG");
				
				return headerList;
			}
			
			
			public ArrayList<Object> generateDailyReport(String selectedDriverIds,
					String startdate, String enddate, int offset, String language,
						int systemId,int custid,String groId ) {
					
				
				ArrayList<Object> finlist = new ArrayList<Object>();
				DecimalFormat df = new DecimalFormat("0.##");
				SimpleDateFormat sdf= new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
				 SimpleDateFormat sdf1 = new SimpleDateFormat("MM/dd/yyyy HH:mm:ss");
					
				if (startdate.contains("T")) {
					startdate = startdate.substring(0,startdate.indexOf("T"));
					startdate = startdate+" 00:00:00";
				}else{
					startdate = startdate.substring(0,startdate.indexOf(" "));
					startdate = startdate+" 00:00:00";
				}
				
				if (enddate.contains("T")) {
					enddate = enddate.substring(0,enddate.indexOf("T"));
					enddate = enddate+" 00:00:00";
				}else{
					enddate = enddate.substring(0,enddate.indexOf(" "));
					enddate = enddate+" 00:00:00";
				}
				
				try{
				java.util.Date strtdat=sdf.parse(startdate); 
				java.util.Date endDate=sdf.parse(enddate);
				startdate=cf.getGMTDateTime(sdf1.format(strtdat), offset);
				enddate=cf.getGMTDateTime(sdf1.format(endDate), offset);
				}
				catch(Exception e){
					
				}
				
				
				ArrayList<String> driverArrayList = new ArrayList<String>();
				String driverIdStr = "(";
				String tempDriver="";
				if(selectedDriverIds != null){
					StringTokenizer st = new StringTokenizer(selectedDriverIds,"||");
					while(st.hasMoreElements()){
						tempDriver = (String) st.nextElement();
						driverIdStr = driverIdStr + tempDriver+"," ;
						driverArrayList.add(tempDriver.trim());
					}
					if(driverIdStr.contains(",")){
						driverIdStr = driverIdStr.substring(0,driverIdStr.lastIndexOf(","));
					}
				}
				driverIdStr = driverIdStr + ")";
				ArrayList<String> datelist=datesBetweenTwoDates(startdate,enddate);
				HashMap driverScore=new HashMap();
				String startDate=startdate;
				String endDate="";
				JSONArray list = new JSONArray(); 
				JSONObject rslt = new JSONObject(); 
				ArrayList<ReportHelper> positionList = new ArrayList<ReportHelper>();
				int count = 0;
				for(int i=1;i<datelist.size();i++){
					 endDate=datelist.get(i);
					 
				DriverEvaluation de = new DriverEvaluation(systemId,custid,driverIdStr,groId,startDate,endDate,driverArrayList);
				driverScore = de.getDriverScorePDO();
				
				Set set = driverScore.entrySet();
				Iterator it = set.iterator();
				
				try{
					while(it.hasNext()){
						count++;
						Map.Entry me = (Map.Entry)it.next();
					    int driverId = Integer.parseInt(me.getKey().toString());
					    DriverEvaluationDTO deDTO = (DriverEvaluationDTO)me.getValue();
					    
					    ReportHelper reporthelper=new ReportHelper();
					    ArrayList<String> tempList = new ArrayList<String>();
					    JSONObject obj = new JSONObject();
					    
					    obj.put("slnoIndex1",count);
						tempList.add(String.valueOf(count));
					    
						obj.put("rowid",count);
						tempList.add(String.valueOf(count));
						
						String temp = deDTO.getDriverName();
						obj.put("driverName",temp);
						tempList.add(temp);
						
						obj.put("startDate", cf.AddOffsetToGmt(startDate,offset));
						tempList.add(sdfddmmyyyy.format(format.parse(cf.AddOffsetToGmt(startDate,offset))));
						
						temp = df.format(deDTO.getDistanceDrived());
						obj.put("distanceTravelled",temp);
						tempList.add(temp);
						
						temp = df.format(deDTO.getOverspeeddurationgraded());
						obj.put("durationingr",temp);
						tempList.add(temp);
						
						temp = df.format(deDTO.getOverspeeddurationblacktop());
						obj.put("durationinbt",temp);
						tempList.add(temp);
						
						temp = String.valueOf((int)deDTO.getOverspeedCount());
						obj.put("totaloverspeed",temp);
						tempList.add(temp);
						
						temp = df.format(deDTO.getOverspeedCountScore());
						obj.put("overspeedscore",temp);
						tempList.add(temp);
						
						temp =  df.format(deDTO.getMaxSpeed());
						obj.put("maxspeed",temp);
						tempList.add(temp);
						
						temp = String.valueOf((int)deDTO.getAcclCount()); 
						obj.put("acclcount",temp);
						tempList.add(temp);
						
						temp = df.format(deDTO.getAcclCountScore());
						obj.put("acclcountscore",temp);
						tempList.add(temp);
						
						temp = String.valueOf((int)deDTO.getDeclCount()); 
						obj.put("declcount",temp);
						tempList.add(temp);
						
						temp = df.format(deDTO.getDeclCountScore());
						obj.put("declcountscore",temp);
						tempList.add(temp);
						
						temp =  df.format(deDTO.getTotalScore());
						obj.put("totalscore",temp);
						tempList.add(temp);
						
						list.put(obj);
						
					    reporthelper.setInformationList(tempList);
				    	positionList.add(reporthelper);
					}
					startDate=endDate;
				}catch(Exception e){
					 e.printStackTrace();
					}
				}
					try {
						rslt.put("driverdatapdo", list);
						finlist.add(list);
						
						ArrayList headerList = getHeaderList();
						ReportHelper finalreporthelper = new ReportHelper();
						finalreporthelper.setReportsList(positionList);
						finalreporthelper.setHeadersList(headerList);
						finlist.add(finalreporthelper);
					} catch (Exception e) {
						e.printStackTrace();
					}
						return finlist;
						
					}
			
			public  ArrayList<String> datesBetweenTwoDates(String  initial, String finall){
			    Date dDateTime=null;
			    Date dDateTime1=null;
			  	ArrayList<String> dates = new ArrayList<String>();
	  			try {
					dDateTime=sdfFormatDate.parse(initial);
					dDateTime1=sdfFormatDate.parse(finall);
		  			java.sql.Timestamp timest = new java.sql.Timestamp(dDateTime.getTime()); 
		  			dDateTime=timest;
		  			java.sql.Timestamp timest1 = new java.sql.Timestamp(dDateTime1.getTime()); 
		  			dDateTime1=timest1;
				    Calendar calendar = Calendar.getInstance();
				    calendar.setTime(dDateTime);
				    while (calendar.getTime().before(dDateTime1)) {
				         String result = format.format(parseFormat.parse(calendar.getTime().toString()));
				         dates.add(result);
				         calendar.add(Calendar.DATE, 1);
				}
				    dates.add(finall);
			    }catch (ParseException e) {
					e.printStackTrace();
				}
			return dates;
			}

			public JSONArray getHubNames(int custId,int systemId,String zone) {
		        Connection conAdmin = null;
		        PreparedStatement pstmt = null;
		        ResultSet rs = null;
		        JSONArray jsonArray = new JSONArray();
		        JSONObject jsonObject = new JSONObject();
		        try {
		            conAdmin = DBConnection.getConnectionToDB("ADMINISTRATOR");
		            pstmt = conAdmin.prepareStatement(AdminStatements.GET_HUB_NAMES.replace("LOCATION", "LOCATION_ZONE_"+zone));
		            pstmt.setInt(1, custId);
		            pstmt.setInt(2, systemId);
		            pstmt.setInt(3, custId);
		            pstmt.setInt(4, systemId);
		            rs = pstmt.executeQuery();
		            while (rs.next()) {
		                jsonObject = new JSONObject();
		                jsonObject.put("hubId", rs.getString("HUBID"));
		                jsonObject.put("hubName", rs.getString("NAME"));
		                jsonArray.put(jsonObject);
		            }

		        } catch (Exception e) {
		        	 e.printStackTrace();
		        } finally {
		            DBConnection.releaseConnectionToDB(conAdmin, pstmt, rs);
		        }
		        return jsonArray;
		    }
			/**
			 * Deleting the customer details of customer
			 * @param CustId
			 * @return
			 */
			public String blockUnblockCustomer(int systemId,int custId,String paymentDue,String pageName,String sessionId,String serverName,int userId){
				String message="";
				Connection conAdmin=null;
				PreparedStatement pstmt=null;
				ArrayList<String> BlockTables=new ArrayList<String>();
				try {
					
					conAdmin=DBConnection.getConnectionToDB("ADMINISTRATOR");
					pstmt=conAdmin.prepareStatement(AdminStatements.UPDATE_PAYMENT_DUE_NOTIFICATION_FOR_CUSTOMER);
					pstmt.setString(1, paymentDue.equalsIgnoreCase("Y")? "N":"Y");
					pstmt.setInt(2, systemId);
					pstmt.setInt(3, custId);
					int updated = pstmt.executeUpdate();
					if(updated>0){
						message = "Login "+(paymentDue.equalsIgnoreCase("Y")?"Unblocked":"Blocked");
						BlockTables.add("Update"+"##"+"ADMINISTRATOR.dbo.CUSTOMER_MASTER");
						try {
							cf.insertDataIntoAuditLogReport(sessionId, BlockTables, pageName,
									(paymentDue.equalsIgnoreCase("Y")?"Unblocked":"Blocked"), userId, serverName, systemId,custId,(paymentDue.equalsIgnoreCase("Y")?"Unblocked":"Blocked")+" Customer Details");
						} catch (Exception e) {
							e.printStackTrace();
						}
						
					}else{
						message = "Error";
					}
						
				} catch (Exception e) {
					System.out.println("Exception in AdminFunctions:-deleteCustomerDetails "+e.toString());
					message="error";
				}
				finally{
					DBConnection.releaseConnectionToDB(conAdmin, pstmt, null);
				}
				return message;		
			}	
			
			public JSONArray getBlockedVehicleDetails(int systemId,int customerId) {
			    JSONArray JsonArray = null;
			    Connection con = null;
			    PreparedStatement pstmt = null;
			    ResultSet rs = null;
			    JSONObject obj1 = new JSONObject();
			    try {
			    	 JsonArray = new JSONArray();
			        con = DBConnection.getConnectionToDB("AMS");
			        pstmt = con.prepareStatement(AdminStatements.CHECK_BLOCKED_VEHICLE_DETAILS);
			        rs = pstmt.executeQuery();
			        JsonArray.put(obj1);
			        while (rs.next()) {
			            obj1 = new JSONObject();
			            obj1.put("RegistrationNo", rs.getString("REGISTRATION_NO"));
			            JsonArray.put(obj1);
			        }
			       } catch (Exception e) {
			        e.printStackTrace();
			    } finally {
			        DBConnection.releaseConnectionToDB(con, pstmt, rs);
			    }
			    return JsonArray;
			}
			
			public JSONArray getMobileNumberCLA(int systemId, int userId,String unitNumber) {
			    JSONArray JsonArray = null;
			    Connection con = null;
			    PreparedStatement pstmt = null;
			    ResultSet rs = null;
			    JSONObject obj1 = new JSONObject();
			    try {
			    	 JsonArray = new JSONArray();
			        con = DBConnection.getConnectionToDB("AMS");
			        pstmt = con.prepareStatement(AdminStatements.GET_MOBILE_NUMBERS_FOR_MANAGE_ASSET_CLA);
			        pstmt.setInt(1, systemId);
			        pstmt.setInt(2, systemId);
			        pstmt.setString(3, unitNumber);
			        pstmt.setInt(4, systemId);
			        rs = pstmt.executeQuery();
			        if (rs.next()) {
			            obj1 = new JSONObject();
			            obj1.put("MobileNumber", rs.getString("MOBILE_NUMBER"));
			            obj1.put("SimNumber", rs.getString("SIM_NUMBER"));
			            obj1.put("ServiceProvider", rs.getString("SERVICE_PROVIDER_NAME"));
			            JsonArray.put(obj1);
			        }
			       } catch (Exception e) {
			        e.printStackTrace();
			    } finally {
			        DBConnection.releaseConnectionToDB(con, pstmt, rs);
			    }
			    return JsonArray;
			}
			
			public JSONArray getMobileNumberForUnitDetailsCLA(int systemId, int userId) {
			    JSONArray JsonArray = null;
			    Connection con = null;
			    PreparedStatement pstmt = null;
			    ResultSet rs = null;
			    JSONObject obj1 = new JSONObject();
			    try {
			    	 JsonArray = new JSONArray();
			        con = DBConnection.getConnectionToDB("AMS");
			        pstmt = con.prepareStatement(AdminStatements.GET_MOBILE_NUMBERS_FOR_UNIT_DETAILS);
			        pstmt.setInt(1, systemId);
			        pstmt.setInt(2, systemId);
			        pstmt.setInt(3, systemId);
			        rs = pstmt.executeQuery();
			        while (rs.next()) {
			            obj1 = new JSONObject();
			            obj1.put("MobileNumber", rs.getString("MOBILE_NUMBER"));
			            obj1.put("SimNumber", rs.getString("SIM_NUMBER"));
			            obj1.put("ServiceProvider", rs.getString("SERVICE_PROVIDER_NAME"));
			            JsonArray.put(obj1);
			        }
			       } catch (Exception e) {
			        e.printStackTrace();
			    } finally {
			        DBConnection.releaseConnectionToDB(con, pstmt, rs);
			    }
			    return JsonArray;
			}
	
			public String sendmailToUser(String username, String contextPath,String sessionId,String buttonValue)
			{
				
				    Connection con = null;
				    PreparedStatement pstmt = null,pstmtForMailConfig = null;
				    ResultSet rs = null;
				    ResultSet rsForMailConfig=null;
			        String contextPathaWS = contextPath;
			   
			    int systemId = 0;
			    int clientId = 0;
			    int userId = 0;
			    String message="";
			    String status = "";
			    String subject = "Profile Updated Successfully";
	           	String emailTemplate = "";

			    try
			    {
			    	 con = DBConnection.getConnectionToDB("AMS");
			        String fullname = "";
					 String usermailId = "";
			        String supportEmail = "support@telematics4u.com" ; 			        
			        pstmt = con.prepareStatement(AdminStatements.GET_USER_SYSTEM_CUST_IDS_AND_DETAILS);
					pstmt.setString(1, username.toUpperCase());
					rs = pstmt.executeQuery();
					if(rs.next())
					{
						systemId = rs.getInt("System_Id");
					    clientId = rs.getInt("Client_id");
					    userId = rs.getInt("UserId");
						fullname =rs.getString("Full_Name");
					    usermailId = rs.getString("User_MailId");	
					    status = rs.getString("Status");
					}
					if(status.equalsIgnoreCase("Active")){
			           	subject = "Password Reset Link";
			            emailTemplate = "";
			           	if(contextPath.contains("telematics4u.in")){
			           		contextPathaWS = "http://api.telematics4u.com";
			           	}
			           	String buttonName = "CHANGE YOUR PASSWORD";
			           	String phrase = "Your profile is updated successfully.";
			        	subject = "Password Reset Link";
			           	if(buttonValue.equalsIgnoreCase("add")){
			           		buttonName = "CREATE YOUR PASSWORD";
			           		phrase = "Your login name is created successfully.";
			           		subject = "Password Create Link";
			           	}
			           	String link =  "<a href='"+contextPathaWS+"/TelematicsRESTService/services/ServiceProcess/getPasswordRecovery?SystemId="+systemId+"&ClientId="+clientId+"&UserId="+userId+"&SessionId="+sessionId+"&ContextPath="+contextPath+"' style='color:blue;' >"+"<b>"+buttonName+"</b>"+"</a>";   
			           	emailTemplate = " <!DOCTYPE html> "+" <html> "+" <head><style>body {font-family: arial, Arial, Helvetica, sans-serif; font-size: 12px} "+
						     " body {height: 297mm;width: 210mm;} "+
						     " dt { float: left; clear: left; text-align: left; font-weight: bold; margin-right: 10px } "+
						     " dd {  padding: 0 0 0.5em 0; } "+
						     " </style> <style type='text/css' media='print'> </style> "+"<style>"+
						     " table {"+" border-collapse: collapse;"+"}"+"table, td, th {"+" border: 1px solid black;"+
						     " }"+"</style>"+" </head><body> "+ " <article>"+" <header>"+
						     " Dear "+fullname+" ,  <p> "+phrase+"</p> <p>Please find the login name and click on the below link to create new password.</p> <h4> Login Name : "+username+"</h4> "+
						     " </header>"+link+"<br><br/>"+
			
			" <p><i>For any queries please write to  <a href= mailto:"+supportEmail+ "> " +supportEmail+ " </a> "+
			" Please do not reply to this mail. This is an auto generated mail and replies to this email id are not attended.</i></p><br><br/> "+
			"</article>"+
			" </body></html> ";
			    }else{
			    	subject = "Profile Updated Successfully";
		           	if(contextPath.contains("telematics4u.in")){
		           		contextPathaWS = "http://api.telematics4u.com";
		           	}
		           	String phrase = "Your account is deactivated by the administrator. ";	           	
		           	emailTemplate = " <!DOCTYPE html> "+" <html> "+" <head><style>body {font-family: arial, Arial, Helvetica, sans-serif; font-size: 12px} "+
					     " body {height: 297mm;width: 210mm;} "+
					     " dt { float: left; clear: left; text-align: left; font-weight: bold; margin-right: 10px } "+
					     " dd {  padding: 0 0 0.5em 0; } "+
					     " </style> <style type='text/css' media='print'> </style> "+"<style>"+
					     " table {"+" border-collapse: collapse;"+"}"+"table, td, th {"+" border: 1px solid black;"+
					     " }"+"</style>"+" </head><body> "+ " <article>"+" <header>"+
					     " Dear "+fullname+" ,  <p> "+phrase+"</p> "+
					     " </header>"+
		
		
		" <p><i>For any queries please write to  <a href= mailto:"+supportEmail+ "> " +supportEmail+ " </a> "+
		" Please do not reply to this mail. This is an auto generated mail and replies to this email id are not attended.</i></p><br><br/> "+
		"</article>"+
		" </body></html> ";
			    }
			               if(!usermailId.equals("")&&!usermailId.equalsIgnoreCase(null)){
			           		/*pstmt=con.prepareStatement(AdminStatements.INSERT_INTO_EMAIL_QUEUE);
			           		pstmt.setString(1, subject);
			           		pstmt.setString(2, emailTemplate);
			           		pstmt.setString(3, usermailId);
			           		pstmt.setInt(4, systemId);               		
			           		pstmt.executeUpdate();*/

			               	String host = "";
			               	String from = "";
			               	String pwd = "";
			               	String from_address = "";
			               	String port = "";
			               	String BCCRCC = "";
			               	
			               	pstmtForMailConfig=con.prepareStatement("select SERVICE_PROVIDER,USER_ID,PASSWORD,FROM_ADDRESS,PORT from AMS.dbo.Mail_Properties where NAME='t4upasswordrecovery'");
			               	rsForMailConfig=pstmtForMailConfig.executeQuery();
			               	
			               	if(rsForMailConfig.next()){
			               		
			               		host=rsForMailConfig.getString("SERVICE_PROVIDER");
			               		from=rsForMailConfig.getString("USER_ID");
			               		pwd=rsForMailConfig.getString("PASSWORD");
			               		from_address=rsForMailConfig.getString("FROM_ADDRESS");
			               		port=rsForMailConfig.getString("PORT");
			               	}
			               	
			               	final String finalFrom =from;
			               	final String finalPwd = pwd;
			                   
			               	String email[] = usermailId.split(",");
			                    
			                    ArrayList<String> to = new ArrayList<String>();
			                    for (String anEmailArray : email) {
			                      to.add(anEmailArray);
			                    }
			               	 try {
			               	      Properties props = new Properties();

			               	      String protocol = "smtp";
			               	      String smtpauth = "true";
			               	      String debug = "false";
			               	      String startTls = "";

			               	      if (subject != null && (subject.toLowerCase().contains("password") || "Profile Updated Successfully".equalsIgnoreCase(subject.trim())
			               	          || "Password Reset Link".equalsIgnoreCase(subject.trim()) || "Application Login Link".equalsIgnoreCase(subject.trim()))) {
			               	        startTls = "true";
			               	      } else {
			               	        startTls = "false";
			               	      }
			               	      String fallback = "false";

			               	      props.put("mail.smtp.host", host);
			               	      props.put("mail.smtp.auth", smtpauth);
			               	      props.put("mail.smtp.port", port);
			               	      props.put("mail.smtp.starttls.enable", startTls);
			               	      props.put("mail.transport.protocol", protocol);
			               	      props.put("mail.smtp.socketFactory.port", port);
			               	      props.put("mail.smtp.socketFactory.fallback", fallback);
			               	      props.put("mail.debug", debug);
			               	
			               	      if (systemId == 247) {
			               	        props.put("mail.smtp.socketFactory.class", "javax.net.ssl.SSLSocketFactory"); //SSL Factory Class
			               	      }
			               	      
			              		  Session session = Session.getDefaultInstance(props,
			            				new javax.mail.Authenticator() {
			            					protected PasswordAuthentication getPasswordAuthentication() {
			            						return new PasswordAuthentication(finalFrom, finalPwd);
			            					}
			            				});
			               	      MimeMessage simpleMessage = new MimeMessage(session);

			               	      simpleMessage.setFrom(new InternetAddress(from_address));

			               	      InternetAddress[] mainAddress = new InternetAddress[to.size()];

			               	      for (int ii = 0; ii < to.size(); ii++) {
			               	        mainAddress[ii] = new InternetAddress(to.get(ii));
			               	      }

			               	      String to1 = to.get(0);

			               	      simpleMessage.setRecipients(Message.RecipientType.TO, to1);
			               	      if ("BCC".equalsIgnoreCase(BCCRCC)) {
			               	        simpleMessage.setRecipients(Message.RecipientType.BCC, mainAddress);
			               	      } else if ("CC".equalsIgnoreCase(BCCRCC)) {
			               	        simpleMessage.setRecipients(Message.RecipientType.CC, mainAddress);
			               	      }
			               	      simpleMessage.setSubject(subject);
			               	      simpleMessage.setSentDate(new java.util.Date());

			               	      MimeBodyPart messageBodyPart = new MimeBodyPart();
			               	      messageBodyPart.setContent(emailTemplate, "text/html");

			               	      Multipart multipart = new MimeMultipart();
			               	      multipart.addBodyPart(messageBodyPart);

			               	      simpleMessage.setContent(multipart);

			               	      Transport.send(simpleMessage); 

			               	      //message = "Sent";
			               	      message = "Email Has Been Sent To Your Registered Email Id" ;
			               	      //logger.info(" Mail of "+subject+" Sent Successfully.");
			               	      System.out.println(" Mail of "+subject+" Sent Successfully.");
			               	      logDetails(con,subject,emailTemplate,usermailId,systemId);
			               	    
			               	    } catch (Exception e) {
			               	      e.printStackTrace();
			               	      logFailDetails(con,subject,emailTemplate,usermailId,systemId);
			               	      //logger.info(e.getMessage(), e);
			               	    }
			           		}
			               //message = "Email Has Been Sent To Your Registered Email Id" ;
			             
			          
			  }catch(Exception e)
			    {
			        message=e.toString();
			       
			        System.out.println("Error in external closed method "+e);
			    }
			    finally
			    {
			    	 DBConnection.releaseConnectionToDB(con, pstmt, rs);
			    	
			    }
			    return message;
			 } 
			public String getRandomNumbers() {
			    
			    String referenceCode="";
			    final Random RANDOM = new SecureRandom();
			    final int PASSWORD_LENGTH = 15;
			    String letters = "abcdefghijkmnpqrstuvwxyzABCDEFGHIGKLMNPQRSTUVWXYZ123456789";
			    String pw="";
			    try {
			    	for (int i=0; i<PASSWORD_LENGTH; i++)
			         {
			             int index = (int)(RANDOM.nextDouble()*letters.length());
			             pw += letters.substring(index, index+1);
			         }
			    	referenceCode=pw.toUpperCase();
			    }catch (Exception e) {	    	
			        e.printStackTrace();
			        }
			    return referenceCode;
			}	

			public String getUnitOfMeasure(int SystemId) {
				PreparedStatement pstmt = null;
				ResultSet rs = null;
				String distanceUnitName;
				double distanceConversionFactor;
				distanceConversionFactor = 1.0;
				distanceUnitName = "kms";
				Connection con=null;
				try {
					con = DBConnection.getDashboardConnection("AMS");	
					pstmt = con.prepareStatement("select UnitName,ConversionFactor from tblDistanceUnitMaster where UnitId = (select DistanceUnitId from System_Master where System_id=?)");
					pstmt.setInt(1, SystemId);
					rs = pstmt.executeQuery();
					while (rs.next()) {
						distanceUnitName = rs.getString("UnitName");
						distanceConversionFactor = rs.getDouble("ConversionFactor");
					}
					DBConnection.releaseConnectionToDB(con, pstmt, rs);
				} catch (Exception e) {
					DBConnection.releaseConnectionToDB(con, pstmt, rs);
					e.printStackTrace();
				}
				return distanceUnitName;
			}
			
			public double getUnitOfMeasureConvertionsfactor(int SystemId) {
				PreparedStatement pstmt = null;
				ResultSet rs = null;
				String distanceUnitName;
				double distanceConversionFactor;
				distanceConversionFactor = 1.0;
				distanceUnitName = "kms";
				Connection con=null;
				try {
					con = DBConnection.getDashboardConnection("AMS");	
					pstmt = con.prepareStatement("select UnitName,ConversionFactor from tblDistanceUnitMaster where UnitId = (select DistanceUnitId from System_Master where System_id=?)");
					pstmt.setInt(1, SystemId);
					rs = pstmt.executeQuery();
					while (rs.next()) {
						distanceUnitName = rs.getString("UnitName");
						distanceConversionFactor = rs.getDouble("ConversionFactor");
					}
					DBConnection.releaseConnectionToDB(con, pstmt, rs);
				} catch (Exception e) {
					DBConnection.releaseConnectionToDB(con, pstmt, rs);
					e.printStackTrace();
				}
				return distanceConversionFactor;
			}
			
			public JSONArray getPasswordList(int SystemId, int CustomerId, int UserId ) 
				{

					JSONArray jsonArray = new JSONArray();
					Connection con = null;
					PreparedStatement pstmt = null;
					ResultSet rs = null;
	
			 String username = "";
			 String firstname = "";
			 String lastname = "";
			 String passwords[] ={"","","",""};
			 String encryptedPass = "";
			 int i = 0;
					try 
					{
						con = DBConnection.getConnectionToDB("AMS");
						DESEncryptionDecryption DES = new DESEncryptionDecryption();
				pstmt=con.prepareStatement(AdminStatements.GET_NAME_AND_PASSWORD);
			    pstmt.setInt(1,SystemId);
			   // pstmt.setInt(2,CustomerId);
			    pstmt.setInt(2,UserId);
			    rs = pstmt.executeQuery();
			    if(rs.next())
			    {
			    	encryptedPass=rs.getString("User_password"); 
			    	firstname=rs.getString("Firstname");
			    	lastname=rs.getString("Lastname");
			    	username=rs.getString("Login_name");
			    	if(encryptedPass.equals("")&& encryptedPass !=null){
			    	passwords[i] = DES.decrypt(encryptedPass);
			    }else{
			    	passwords[i] = "";
			    }
			    	i++;
			    }
			  
			    pstmt=con.prepareStatement(AdminStatements.GET_PASSWORD_HIST);
			    pstmt.setInt(1,SystemId);
			  //  pstmt.setInt(2,CustomerId);
			    pstmt.setInt(2,UserId);
			    rs = pstmt.executeQuery();
			    while(rs.next())
			    {
			    	
			    	encryptedPass=rs.getString("Password"); 
			    	if(encryptedPass.equals("")&& encryptedPass !=null){
			    	passwords[i] = DES.decrypt(encryptedPass);
			    	}else{
			    		passwords[i] = "";	
			    	}
			    	if(i==3){
			    		break;
			    	}
			    	i++; 
			    	
			    }						
			                JSONObject obj1 = new JSONObject();
							obj1.put("Password1", passwords[0]);
							obj1.put("Password2", passwords[1]);
							obj1.put("Password3", passwords[2]);
						    obj1.put("Password4", passwords[3]);
							obj1.put("UserName", username );
							obj1.put("FirstName", firstname.toLowerCase());
							obj1.put("LastName", lastname.toLowerCase());				
							jsonArray.put(obj1);
						
					} 			
					catch (Exception e) 
					{
						e.printStackTrace();
					} 
					finally 
					{
				    	 DBConnection.releaseConnectionToDB(con, pstmt, rs);
					}
					return jsonArray;
				}
			public JSONArray getAuditLogReport(int systemId, int CustomerId, String userId,String timeband,int offset,String serverName) {
					//t4u506 added two parameters for req and res time
				PreparedStatement pstmt = null;
				ResultSet rs = null;
				Connection connection = null;
				JSONArray jsonArray = new JSONArray();
				JSONObject jsonObject = new JSONObject();
				connection = DBConnection.getConnectionToDB("AMS");
				SimpleDateFormat ddMMyyyyHHmmss = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
				//userId="520";
				int count=0;
				if(timeband.equals("1")){timeband="1";}else if(timeband.equals("2")){timeband="7";}else if(timeband.equals("3")){timeband="15";}else{timeband="30";}
					try {
						if(userId.equals("ALL")){
							if(timeband.equals("1")){
								pstmt = connection.prepareStatement(AdminStatements.GET_AUDIT_LOG_REPORT_FOR_ALL.replace("##", " and INSERTED_DATETIME between dateadd(mi,-(?),CONVERT(VARCHAR(10),GETDATE(),120)+' '+'00:00:00') and dateadd(mi,-(?),CONVERT(VARCHAR(10),GETDATE(),120)+' '+'23:59:59')"));
								pstmt.setInt(1, offset);
								pstmt.setInt(2, offset); //added offset t4u506
								pstmt.setInt(3, offset); //added offset t4u506
								pstmt.setInt(4, systemId);
								pstmt.setInt(5, systemId);
								pstmt.setInt(6, CustomerId);
								pstmt.setString(7, serverName);
								pstmt.setInt(8, offset);
								pstmt.setInt(9, offset);
							}else{
								pstmt = connection.prepareStatement(AdminStatements.GET_AUDIT_LOG_REPORT_FOR_ALL.replace("##", " and INSERTED_DATETIME between dateadd(mi,?,dateadd(dd,-(?),CONVERT(VARCHAR(10),GETDATE(),120))) and dateadd(mi,-(?),CONVERT(VARCHAR(10),GETDATE(),120)+' '+'23:59:59')"));
								pstmt.setInt(1, offset);
								pstmt.setInt(2, offset); //added offset t4u506
								pstmt.setInt(3, offset); //added offset t4u506
								pstmt.setInt(4, systemId);
								pstmt.setInt(5, systemId);
								pstmt.setInt(6, CustomerId);
								pstmt.setString(7, serverName);
								pstmt.setInt(8, offset);
								pstmt.setInt(9, Integer.parseInt(timeband));
								pstmt.setInt(10, offset);
								
							}
						}else{
							if(timeband.equals("1")){
								pstmt = connection.prepareStatement(AdminStatements.GET_AUDIT_LOG_REPORT.replace("##", " and INSERTED_DATETIME between dateadd(mi,-(?),CONVERT(VARCHAR(10),GETDATE(),120)+' '+'00:00:00') and dateadd(mi,-(?),CONVERT(VARCHAR(10),GETDATE(),120)+' '+'23:59:59') "));
								pstmt.setInt(1, offset);
								pstmt.setInt(2, offset); //added offset t4u506
								pstmt.setInt(3, offset); //added offset t4u506
								pstmt.setInt(4, systemId);
								pstmt.setString(5, userId);
								pstmt.setString(6, serverName);
								pstmt.setInt(7, offset);
								pstmt.setInt(8, offset);
							}else{
								pstmt = connection.prepareStatement(AdminStatements.GET_AUDIT_LOG_REPORT.replace("##", " and INSERTED_DATETIME between dateadd(mi,-(?),dateadd(dd,-?,CONVERT(VARCHAR(10),GETDATE(),120))) and dateadd(mi,-(?),CONVERT(VARCHAR(10),GETDATE(),120)+' '+'23:59:59')"));
								pstmt.setInt(1, offset);
								pstmt.setInt(2, offset); //added offset t4u506
								pstmt.setInt(3, offset); //added offset t4u506
								pstmt.setInt(4, systemId);
								pstmt.setString(5, userId);
								pstmt.setString(6, serverName);
								pstmt.setInt(7, offset);
								pstmt.setInt(8, Integer.parseInt(timeband));
								pstmt.setInt(9, offset);
							}
						}
						rs = pstmt.executeQuery();
						while (rs.next()) {
							count++;
							jsonObject=new JSONObject();
							jsonObject.put("id", count);
							jsonObject.put("userNameId", rs.getString("USER_NAME"));
							jsonObject.put("pageNameId", rs.getString("PAGE_NAME"));
							jsonObject.put("actionId", rs.getString("ACTION"));
							jsonObject.put("remarksId", rs.getString("REMARKS"));
							jsonObject.put("dateTimeId", ddMMyyyyHHmmss.format(rs.getTimestamp("INSERTED_DATETIME")));
							//t4u506 start
							//System.out.println("REquest and Response Date : "+rs.getTimestamp("REQUEST_TIME")+",,,"+rs.getTimestamp("RESPONSE_TIME"));
							
							if (rs.getTimestamp("REQUEST_TIME")!=null ){
								jsonObject.put("reqTimeId", ddMMyyyyHHmmss.format(rs.getTimestamp("REQUEST_TIME")));
							}
							else
							{
								jsonObject.put("reqTimeId", "");
							}
							if (rs.getTimestamp("RESPONSE_TIME")!=null ){
								jsonObject.put("resTimeId", ddMMyyyyHHmmss.format(rs.getTimestamp("RESPONSE_TIME")));
							}
							else
							{
								jsonObject.put("resTimeId", "");	
							}
							
							//t4u506 end
							jsonArray.put(jsonObject);
						}
					
				} catch (Exception e) {
					e.printStackTrace();
				} finally {
					DBConnection.releaseConnectionToDB(connection, pstmt, rs);
				}
				//System.out.println(jsonArray);
				return jsonArray;
		}
			public JSONArray getUsers(int systemId,int custId) {

				JSONArray jsonArray = new JSONArray();
				JSONObject jsonObject = new JSONObject();
				Connection con=null;
				PreparedStatement pstmt=null;
				ResultSet rs=null;
				try{
					jsonArray = new JSONArray();
					jsonObject = new JSONObject();
					
					con=DBConnection.getConnectionToDB("AMS");
					pstmt=con.prepareStatement("SELECT USER_ID,(Isnull(u.FIRST_NAME,'')+' '+isnull(u.LAST_NAME,'')) AS USER_NAME FROM ADMINISTRATOR.dbo.USERS u where SYSTEM_ID=? and CUSTOMER_ID=?");
					pstmt.setInt(1, systemId);
					pstmt.setInt(2, custId);
					rs=pstmt.executeQuery();
					while(rs.next()){
						jsonObject = new JSONObject();
						jsonObject.put("userId", rs.getString("USER_ID"));
						jsonObject.put("userName", rs.getString("USER_NAME"));
						jsonArray.put(jsonObject);				
					}
				}catch(Exception e){
					System.out.println("Error in getUsers "+e.toString());
				}	
				finally{
					DBConnection.releaseConnectionToDB(con, pstmt, rs);
				}	
				return jsonArray;

			}
			
			public JSONArray getUsers1(int systemId,int userId,int custId) {

				JSONArray jsonArray = new JSONArray();
				JSONObject jsonObject = new JSONObject();
				Connection con=null;
				PreparedStatement pstmt=null;
				ResultSet rs=null;
				try{
					jsonArray = new JSONArray();
					jsonObject = new JSONObject();
					
					con=DBConnection.getConnectionToDB("AMS");
					pstmt=con.prepareStatement("SELECT USER_ID,(u.FIRST_NAME+' '+u.LAST_NAME) AS USER_NAME FROM ADMINISTRATOR.dbo.USERS u where SYSTEM_ID=? and USER_ID=?");
					pstmt.setInt(1, systemId);
					pstmt.setInt(2, userId);
					rs=pstmt.executeQuery();
					while(rs.next()){
						jsonObject = new JSONObject();
						jsonObject.put("userId", rs.getString("USER_ID"));
						jsonObject.put("userName", rs.getString("USER_NAME"));
						jsonArray.put(jsonObject);				
					}
				}catch(Exception e){
					System.out.println("Error in getUsers "+e.toString());
					e.printStackTrace();
				}	
				finally{
					DBConnection.releaseConnectionToDB(con, pstmt, rs);
				}	
				return jsonArray;

			}
			public JSONArray getGroupsForTreeView(int systemId,int userId,int custId,String language) {

				JSONArray jsonArray = new JSONArray();
				JSONObject jsonObject = new JSONObject();
				
				JSONArray jsonArray1 = new JSONArray();
				JSONObject jsonObject1 = new JSONObject();
				
				JSONArray jsonArray2 = new JSONArray();
				JSONObject jsonObject2 = new JSONObject();
				
				JSONArray jsonArray3 = new JSONArray();
				JSONObject jsonObject3 = new JSONObject();
				
				JSONArray jsonArray4 = new JSONArray();
				JSONObject jsonObject4 = new JSONObject();
				
				JSONArray jsonArray5 = new JSONArray();
				JSONObject jsonObject5 = new JSONObject();
				
				JSONArray jsonArray6 = new JSONArray();
				JSONObject jsonObject6 = new JSONObject();
				
				Connection con=null;
				PreparedStatement pstmt=null,pstmtFeature=null;
				ResultSet rs=null,rsFeature=null;
				ResultSet rs1=null;
				try{
					jsonArray = new JSONArray();
					jsonObject = new JSONObject();
					
					jsonArray1 = new JSONArray();
					jsonObject1 = new JSONObject();
					
					jsonArray2 = new JSONArray();
					jsonObject2 = new JSONObject();
					
					jsonArray3 = new JSONArray();
					jsonObject3 = new JSONObject();
					
					jsonArray4 = new JSONArray();
					jsonObject4 = new JSONObject();
					
					jsonArray5 = new JSONArray();
					jsonObject5 = new JSONObject();
					
					ArrayList<String> al= new ArrayList<String>();
					ArrayList<ArrayList<String>> finalList= new ArrayList<ArrayList<String>>();
					ArrayList<String> sub_Feature= new ArrayList<String>();
					con=DBConnection.getConnectionToDB("AMS");
					
					pstmtFeature=con.prepareStatement(AdminStatements.GETFEATUREGROUPTREE);
					pstmtFeature.setInt(1, systemId);
					pstmtFeature.setInt(2, userId);
					pstmtFeature.setInt(3, custId);
					pstmtFeature.setInt(4, systemId);
					pstmtFeature.setInt(5, systemId);
					pstmtFeature.setInt(6, systemId);
					rsFeature=pstmtFeature.executeQuery();
					
					String [] subFeature={"Admin","Reports","Alert","SMS"};
					String [] monitoringPackages={"Essential Monitoring","Advanced Monitoring"};
					
					//******************* Get All Menu Fetures******************************//
					while(rsFeature.next()){
						al= new ArrayList<String>();
						al.add(rsFeature.getString("PROCESS_LABEL_ID"));
						al.add(rsFeature.getString("Sub_Feature"));
						al.add(rsFeature.getString("MENU_LABEL_ID"));
						finalList.add(al);
					}
					//******************* Get All pages ******************************//
						for(int k=0;k<finalList.size();k++){
							String featurenamelangconverted="";
							if(finalList.get(k).get(0).equals("Ess_Montr")){
								if(finalList.get(k).get(2).trim()!="" || finalList.get(k).get(2).trim()!=null){
									featurenamelangconverted=cf.getLabelFromDB(finalList.get(k).get(2), language);
								}
								jsonObject5 = new JSONObject();
								jsonObject5.put("text",featurenamelangconverted);
								jsonObject5.put("tags", "['0']");
								jsonObject5.put("nodes", "");
								jsonArray5.put(jsonObject5);	
							}
							if(finalList.get(k).get(0).equals("Adv_Montr")){
								if(finalList.get(k).get(2).trim()!="" || finalList.get(k).get(2).trim()!=null){
									featurenamelangconverted=cf.getLabelFromDB(finalList.get(k).get(2), language);
								}
								jsonObject6 = new JSONObject();
								jsonObject6.put("text", featurenamelangconverted);
								jsonObject6.put("tags", "['0']");
								jsonObject6.put("nodes", "");
								jsonArray6.put(jsonObject6);
							}
						}
					jsonObject4 = new JSONObject();
					jsonObject4.put("text", monitoringPackages[0]);
					jsonObject4.put("tags", "['2']");
					jsonObject4.put("nodes", jsonArray5);
					jsonArray4.put(jsonObject4);	
					
					jsonObject4 = new JSONObject();
					jsonObject4.put("text", monitoringPackages[1]);
					jsonObject4.put("tags", "['2']");
					jsonObject4.put("nodes", jsonArray6);
					jsonArray4.put(jsonObject4);	
					
					pstmt=con.prepareStatement(" select c.GROUP_NAME,c.GROUP_ID from ADMINISTRATOR.dbo.USER_ASSET_GROUP_ASSOCIATION a " +
							" inner join ADMINISTRATOR.dbo.ASSET_GROUP c (NOLOCK) on c.SYSTEM_ID=a.SYSTEM_ID and a.GROUP_ID=c.GROUP_ID " +
							" inner join ADMINISTRATOR.dbo.CUSTOMER_MASTER e (NOLOCK) on e.CUSTOMER_ID=c.CUSTOMER_ID and e.SYSTEM_ID=a.SYSTEM_ID " +
							" where a.USER_ID=? and a.SYSTEM_ID=? and c.ACTIVATION_STATUS='Complete' order by e.NAME,c.GROUP_NAME " );
					pstmt.setInt(1, userId);
					pstmt.setInt(2, systemId);
					rs1=pstmt.executeQuery();
					while(rs1.next()){
						//jsonArray1 = new JSONArray();
						jsonArray2 = new JSONArray();
						pstmt=con.prepareStatement(" select vu.Registration_no,isnull(ag.GROUP_NAME,'') as GROUP_NAME from AMS.dbo.Vehicle_User (NOLOCK) vu " +
								   " left outer join AMS.dbo.VEHICLE_CLIENT vc (NOLOCK) on vu.Registration_no=vc.REGISTRATION_NUMBER and vu.System_id=vc.SYSTEM_ID " + 
								   " left outer join ADMINISTRATOR.dbo.ASSET_GROUP ag (NOLOCK) on  vc.SYSTEM_ID=ag.SYSTEM_ID and vc.CLIENT_ID=ag.CUSTOMER_ID " +
								   " and vc.GROUP_ID=ag.GROUP_ID " +
								   " where vu.System_id=? and vu.User_id=?  and vc.GROUP_ID=?" );
							pstmt.setInt(1, systemId);
							pstmt.setInt(2, userId);
							pstmt.setInt(3, rs1.getInt("GROUP_ID"));
							rs=pstmt.executeQuery();
							while(rs.next()){
								jsonObject2 = new JSONObject();
								jsonObject2.put("text", rs.getString("Registration_no"));
								jsonObject2.put("tags", "['0']");
								jsonObject2.put("nodes", "");
								jsonArray2.put(jsonObject2);	
							}
						jsonObject1 = new JSONObject();
						jsonObject1.put("text", rs1.getString("GROUP_NAME"));
						jsonObject1.put("tags", "['2']");
						jsonObject1.put("nodes", jsonArray2);
						jsonArray1.put(jsonObject1);	
					}
						jsonObject3 = new JSONObject();
						jsonObject3.put("text", "Group Name");
						jsonObject3.put("tags", "['4']");
						jsonObject3.put("nodes", jsonArray1);
						jsonArray3.put(jsonObject3);	
						
						jsonObject3 = new JSONObject();
						jsonObject3.put("text", "User Features");
						jsonObject3.put("tags", "['4']");
						jsonObject3.put("nodes", jsonArray4);
						jsonArray3.put(jsonObject3);
						
					pstmt=con.prepareStatement("SELECT USER_ID,(u.FIRST_NAME+' '+u.LAST_NAME) AS USER_NAME FROM ADMINISTRATOR.dbo.USERS u where SYSTEM_ID=? and USER_ID=?");
					pstmt.setInt(1, systemId);
					pstmt.setInt(2, userId);
					
					rs=pstmt.executeQuery();
					if(rs.next()){
						jsonObject = new JSONObject();
						jsonObject.put("text", rs.getString("USER_NAME"));
						jsonObject.put("tags", "['4']");
						jsonObject.put("nodes", jsonArray3);
						jsonArray.put(jsonObject);			
					}
				}catch(Exception e){
					e.printStackTrace();
					System.out.println("Error in getGroupsForTreeView "+e.toString());
				}	
				finally{
					DBConnection.releaseConnectionToDB(con, pstmt, rs);
					DBConnection.releaseConnectionToDB(null, pstmtFeature, rsFeature);
				}	
				return jsonArray;
			}
			
			public JSONArray getVehiclesForTreeView(int systemId,int userId,String groupId) {

				JSONArray jsonArray = new JSONArray();
				JSONObject jsonObject = new JSONObject();
				
				JSONArray jsonArray1 = new JSONArray();
				JSONObject jsonObject1 = new JSONObject();
				Connection con=null;
				PreparedStatement pstmt=null;
				ResultSet rs=null;
				try{
					jsonArray = new JSONArray();
					jsonObject = new JSONObject();
					
					jsonArray1 = new JSONArray();
					jsonObject1 = new JSONObject();
					con=DBConnection.getConnectionToDB("AMS");
					
					jsonObject = new JSONObject();
					jsonObject.put("text", "AK");
					jsonObject.put("tags", "['4']");
					jsonObject.put("nodes", jsonArray1);
					jsonArray.put(jsonObject);			
					
				}catch(Exception e){
					e.printStackTrace();
					System.out.println("Error in getVehiclesForTreeView "+e.toString());
				}	
				finally{
					DBConnection.releaseConnectionToDB(con, pstmt, rs);
				}	
				return jsonArray;
			}
			
			public JSONArray getUserDetails(int systemId, int CustomerId, int userId) {

				PreparedStatement pstmt = null;
				ResultSet rs = null;
				Connection connection = null;
				JSONArray jsonArray = new JSONArray();
				JSONObject jsonObject = new JSONObject();
				DecimalFormat df = new DecimalFormat("##0.000");
				String value="********";
				try {
					connection = DBConnection.getConnectionToDB("ADMINISTRATOR");
					pstmt = connection.prepareStatement(AdminStatements.GET_USER_DETAILS);
					pstmt.setInt(1, userId);
					pstmt.setInt(2, systemId);
					rs = pstmt.executeQuery();
					if (rs.next()) {
						String phoneNo=rs.getString("PHONE");
						String phoneNoNew=value+phoneNo.substring((phoneNo.length()-2),(phoneNo.length()));
						String email=rs.getString("EMAIL");
						String[] email1=email.split("@");
						String emailStr=email1[0];
						String emailI=emailStr.substring(2,(emailStr.length()));
						String emailNew="";
						for(int i=0;i<emailI.length();i++){
							emailNew=emailNew+"*";
						}
						String emailFinal=emailStr.substring(0,2)+emailNew+"@"+email1[1];
						jsonObject.put("userNameId", rs.getString("USER_NAME"));
						jsonObject.put("phoneId", phoneNoNew);
						jsonObject.put("emailId", emailFinal);
						jsonObject.put("userAuthId", rs.getString("USERAUTHORITY"));
						jsonObject.put("createdTimeId", rs.getString("CREATED_TIME"));
						jsonObject.put("createdById", rs.getString("CREATED_BY"));
						jsonArray.put(jsonObject);
					}
					
				} catch (Exception e) {
					e.printStackTrace();
				} finally {
					DBConnection.releaseConnectionToDB(connection, pstmt, rs);
				}
				return jsonArray;
		}
			
			public JSONArray getCountryListCreateLandmark(String countryId) {
				Connection conAdmin=null;
				PreparedStatement pstmt=null;
				ResultSet rs=null;
				JSONArray jsonArray = new JSONArray();
				JSONObject jsonObject = new JSONObject();
				try {
					conAdmin=DBConnection.getConnectionToDB("ADMINISTRATOR");
					pstmt=conAdmin.prepareStatement("select COUNTRY_CODE,COUNTRY_NAME,isNull(OFFSET,'') as OFFSET from dbo.COUNTRY_DETAILS where COUNTRY_CODE=?");
					pstmt.setString(1, countryId);
					rs=pstmt.executeQuery();
					while(rs.next()){
						jsonObject = new JSONObject();
						jsonObject.put("CountryID", rs.getString("COUNTRY_CODE"));
						jsonObject.put("CountryName", rs.getString("COUNTRY_NAME"));
						jsonObject.put("Offset", rs.getString("OFFSET"));
						jsonArray.put(jsonObject);
					}
					
				} catch (Exception e) {
					System.out.println("Error in Admin Functions:-getCountryList "+e.toString());
				}finally{
					DBConnection.releaseConnectionToDB(conAdmin, pstmt, rs);
				}
				return jsonArray;
			}
			public int getPasswordModifiedDate(int offset,int userId,int systemId)
			{
				Connection con=null;
				ResultSet rs=null;
				PreparedStatement pstmt=null;
				int dayDifference=0;
				try{
						con=DBConnection.getConnectionToDB("AMS");
						pstmt=con.prepareStatement("select isnull(datediff(dd,PasswordModifiedTime,getutcdate()),0) as Password_Modified from Users where User_id=? and System_id=?");
						pstmt.setInt(1, userId);
						pstmt.setInt(2, systemId);
						rs=pstmt.executeQuery();
							if(rs.next())
							{
								dayDifference=Integer.parseInt(rs.getString("Password_Modified"));
							}
					}
					catch(Exception e){
						e.printStackTrace();
					}
					finally {
						DBConnection.releaseConnectionToDB(con, pstmt, rs);
					}
				return dayDifference;
			}
			public JSONArray viewAssetDetails(int systemid, int userId,String CustID) {
                JSONArray jsonArray = new JSONArray();
                JSONObject jsonObject = new JSONObject();
                Connection con = null;
                PreparedStatement pstmt = null;
                ResultSet rs = null;
                try {
                     con=DBConnection.getConnectionToDB("AMS");
                     if (CustID != null){
                     pstmt=con.prepareStatement(AdminStatements.SELECT_REGISTRATION_NO_FROM_USER_VEHICLE +" and e.CLIENT_ID=?   order by a.RegistrationNo");
                     pstmt.setInt(1,userId);
                     pstmt.setInt(2,systemid);
                     pstmt.setInt(3,Integer.parseInt(CustID));
                     }else{
                     pstmt=con.prepareStatement(AdminStatements.SELECT_REGISTRATION_NO_FROM_USER_VEHICLE);
                     pstmt.setInt(1,userId);
                     pstmt.setInt(2,systemid);
                     }
                     rs=pstmt.executeQuery();
                    while (rs.next()) {
                        jsonObject = new JSONObject();
                        jsonObject.put("assetNoIndex", rs.getString("VehicleNo"));
                        jsonArray.put(jsonObject);
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                } finally {
                    DBConnection.releaseConnectionToDB(con, pstmt, rs);
                }
                return jsonArray;
            }
			public JSONArray getCountryId(String countryName) {
				Connection conAdmin=null;
				PreparedStatement pstmt=null;
				ResultSet rs=null;
				JSONArray jsonArray = new JSONArray();
				JSONObject jsonObject = new JSONObject();
				try {
					conAdmin=DBConnection.getConnectionToDB("ADMINISTRATOR");
					pstmt=conAdmin.prepareStatement("select COUNTRY_CODE,COUNTRY_NAME from dbo.COUNTRY_DETAILS where COUNTRY_NAME=?");
					pstmt.setString(1, countryName.toUpperCase().trim());
					rs=pstmt.executeQuery();
					if(rs.next()){
						jsonObject = new JSONObject();
						jsonObject.put("CountryID", rs.getString("COUNTRY_CODE"));
						jsonObject.put("CountryName", rs.getString("COUNTRY_NAME"));
						jsonArray.put(jsonObject);
					}
					
				} catch (Exception e) {
					System.out.println("Error in Admin Functions:-getCountryId "+e.toString());
				}finally{
					DBConnection.releaseConnectionToDB(conAdmin, pstmt, rs);
				}
				return jsonArray;
			}
			public JSONArray getRegion(String countryId, String stateName) {
				Connection conAdmin=null;
				PreparedStatement pstmt=null;
				ResultSet rs=null;
				JSONArray jsonArray = new JSONArray();
				JSONObject jsonObject = new JSONObject();
				
				int countrycode=Integer.parseInt(countryId);
				try {
					conAdmin=DBConnection.getConnectionToDB("ADMINISTRATOR");
					pstmt=conAdmin.prepareStatement(AdminStatements.GET_STATE_LIST);
					pstmt.setInt(1, countrycode);
					pstmt.setString(2, stateName.trim());
					rs=pstmt.executeQuery();
					if(rs.next()){
						jsonObject=new JSONObject();
						jsonObject.put("StateID", rs.getString("STATE_CODE"));
						jsonObject.put("StateName", rs.getString("STATE_NAME"));
						jsonObject.put("Region",rs.getString("REGION"));
						jsonArray.put(jsonObject);
					}
					
				} catch (Exception e) {
					System.out.println("Error in Admin Functions:-getRegion "+e.toString());
				}finally{
					DBConnection.releaseConnectionToDB(conAdmin, pstmt, rs);
				}
				return jsonArray;
			}
			
			public boolean checkUserProcessPermission(int systemId, int userId, String pageName){
				
				Connection conAdmin=null;
				PreparedStatement pstmt=null;
				ResultSet rs=null;
				boolean hasPermissoin = false;
				try {
						conAdmin=DBConnection.getConnectionToDB("ADMINISTRATOR");
						pstmt=conAdmin.prepareStatement(AdminStatements.CHECK_USER_PROCESS_PERMISSION);
						pstmt.setInt(1, userId);
						pstmt.setInt(2, systemId);
						pstmt.setString(3, pageName);
						rs=pstmt.executeQuery();
						if(!rs.next()){
							hasPermissoin = true;
						}
				} catch (Exception e) {
					System.out.println("Error in Admin Functions:-checkIfUserHasTripCreationPermission "+e.toString());
				}finally{
					DBConnection.releaseConnectionToDB(conAdmin, pstmt, rs);
				}
				return hasPermissoin;
			}
			public static void logDetails(Connection con,String subject,String emailTemplate,String usermailId,int systemId){
				PreparedStatement pstmt=null,pstmt2=null;
				SimpleDateFormat sdf = new SimpleDateFormat("MM/dd/yyyy HH:mm:ss");
				ResultSet rs=null;
				long serialNo=0;
				try
				{
					pstmt=con.prepareStatement("select max(Slno) as MaxSerial from AMS.dbo.EmailQueueHistory ");
					
					rs=pstmt.executeQuery();
					if(rs.next())
					{
						serialNo=rs.getLong("MaxSerial");
					}
					serialNo++;
					
					pstmt2=con.prepareStatement(AdminStatements.INSERT_INTO_EMAIL_QUEUE_HISTORY);
					pstmt2.setLong(1, serialNo);
					pstmt2.setString(2, subject);
					pstmt2.setString(3, emailTemplate);
					pstmt2.setString(4, usermailId);
					pstmt2.setString(5, sdf.format(new Date()));
					pstmt2.setInt(6,systemId);
					int x=pstmt2.executeUpdate();
					if(x>0)
					{
						//logger.info("Email Queue History Inserted "+serialNo);
					}
				}
				catch(Exception e)
				{
					e.printStackTrace();
					//logger.info(e.getMessage(), e);
				}
				finally
				{
					try{
						pstmt.close();
						pstmt2.close();
						rs.close();
					}
					catch(Exception e){
						e.printStackTrace();
						//logger.info(e.getMessage(),e);
					}
				}
			  }

			public static void logFailDetails(Connection con,String subject,String emailTemplate,String usermailId,int systemId){
				PreparedStatement pstmt=null,pstmt2=null;
				SimpleDateFormat sdf = new SimpleDateFormat("MM/dd/yyyy HH:mm:ss");
				ResultSet rs=null;
				long serialNo=0;
				try
				{
					pstmt=con.prepareStatement("select max(Slno) as MaxSerial from AMS.dbo.EmailFailureHistory ");
					
					rs=pstmt.executeQuery();
					if(rs.next())
					{
						serialNo=rs.getLong("MaxSerial");
					}
					serialNo++;
					
					pstmt2=con.prepareStatement(AdminStatements.INSERT_INTO_EMAIL_FAILURE_HISTORY);
					pstmt2.setLong(1, serialNo);
					pstmt2.setString(2, subject);
					pstmt2.setString(3, emailTemplate);
					pstmt2.setString(4, usermailId);
					pstmt2.setString(5, sdf.format(new Date()));
					pstmt2.setInt(6,systemId);
					int x=pstmt2.executeUpdate();
					if(x>0)
					{
						//logger.info("Email Failure History Inserted "+serialNo);
					}
				}
				catch(Exception e)
				{
					e.printStackTrace();
					//logger.info(e.getMessage(), e);
				}
				finally
				{
					try
					{
						pstmt.close();
						pstmt2.close();
						rs.close();
					}
					catch(Exception e){
						e.printStackTrace();
						//logger.info(e.getMessage(),e);
					}
				}
			  }

	public String registerNewVehiclePrePaymentMode(String assetType, String registrationNo, int groupId, String unitNo, String mobileNo, int systemId, int userId, int offset, int customerId,
		String ltspName, String groupName, String custName, String assetModel, String ownerName, String ownerAddress, String ownerPhoneNo, String assetId, String zone, int ownerId,
		String selectedCheckBox, String pageName, String sessionId, String serverName, int flag,String emailId,String amount,String requestType,String startDate,String endDate,Integer vehicleSubscriptionId) throws Exception {
		ArrayList<String> tableList = new ArrayList<String>();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Connection con = null;
		String message = "";
		JSONObject jsonObject = new JSONObject();
		JSONObject customerObject = new JSONObject();
		String uniquePaymentKey = "";
		JSONObject responseJSON = null;
		serverName = "https://telematics4u.in/TelematicsRESTService/services/ServiceProcess/RazorPayResponse";
		LogWriter logWriter = null;
		String returnURL = "";
		Integer durationInMins = 0;
		
			
		try {
			logWriter = CommonUtility.getLog(logWriter, "PaymentLogs", "RAZOR_PAY_PaymentLog");
			logWriter.log("-------------------", LogWriter.INFO);
			con = DBConnection.getConnectionToDB("AMS");
			
			pstmt = con.prepareStatement(SandMiningStatements.GET_MDP_TIMENGS);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, customerId);
			rs = pstmt.executeQuery();
			if (rs.next()){
				durationInMins = rs.getInt("PAYMENT_DURATION");
			}
			durationInMins  = durationInMins > 0 ? durationInMins : 1440 ;
			Calendar cal = Calendar.getInstance();
			cal.set(Calendar.MINUTE, cal.get(Calendar.MINUTE) + durationInMins);
			long expireBy = cal.getTimeInMillis() / 1000L;
			
			if (requestType.equalsIgnoreCase("Registration")){
				 pstmt = con.prepareStatement(AdminStatements.CHECK_IF_VEHICLE_REGISTERED_AND_STATUS_IS_ACTIVE);
			        pstmt.setString(1, "Active");
			        pstmt.setString(2, registrationNo.replace(" ", ""));
			        rs = pstmt.executeQuery();
			        if (rs.next()) {
			            message = "Asset Already Exists";
			            return message;
			        }
			}
	       
			try{
				returnURL = CommonUtility.getPropertyValues(con, "RAZOR_PAY_RETURN_URL").getString("VALUE");
			}catch (Exception e) {
				returnURL = serverName;
			}
			emailId = emailId.length() > 0 ? emailId:"t4uhelpdesk@telematics4u.com";
			uniquePaymentKey = registrationNo + Calendar.getInstance().getTimeInMillis();
			customerObject.put("name", ownerName);
			customerObject.put("email", emailId);
			customerObject.put("contact", ownerPhoneNo);
			jsonObject.put("customer", customerObject);
			jsonObject.put("type", "link");
			jsonObject.put("view_less", 1);
			jsonObject.put("amount", amount.replace(".", ""));
			String type = requestType.equalsIgnoreCase("Renewal")? "Subscription Renewal": requestType;
			jsonObject.put("currency", "INR");
			jsonObject.put("description", "Payment Link for Vehicle "+ type + " for  - "+ registrationNo);
			jsonObject.put("receipt", uniquePaymentKey);
			jsonObject.put("reminder_enable", true);
			jsonObject.put("sms_notify", 1);
			jsonObject.put("email_notify", 1);
			jsonObject.put("expire_by", expireBy);
			jsonObject.put("callback_url", returnURL);
			jsonObject.put("callback_method", "get");
			logWriter.log(" JSON to be pushed --"+jsonObject, LogWriter.INFO);
			responseJSON = requestPayment(con, jsonObject,logWriter);
		 	logWriter.log("Transaction Status --", LogWriter.INFO);
			logWriter.log(responseJSON.toString(), LogWriter.INFO);
				if (responseJSON != null && responseJSON.length() > 0){
					if (Integer.parseInt(responseJSON.getString("razor_pay_reponse_code"))== 200){
						pstmt = con.prepareStatement(AdminStatements.INSERT_TO_VEHICLE_REGISTRATION_TRANSACTION);
						pstmt.setString(1, assetType);
						pstmt.setString(2, registrationNo);
						pstmt.setInt(3, groupId);
						pstmt.setString(4, unitNo);
						pstmt.setString(5, mobileNo);
						pstmt.setInt(6, systemId);

						pstmt.setInt(7, userId);
						pstmt.setInt(8, offset);
						pstmt.setInt(9, customerId);
						pstmt.setString(10, ltspName);
						pstmt.setString(11, groupName);
						pstmt.setString(12, custName);

						pstmt.setString(13, assetModel);
						pstmt.setString(14, ownerName);
						pstmt.setString(15, ownerAddress);
						pstmt.setString(16, ownerPhoneNo);
						pstmt.setString(17, assetId);
						pstmt.setString(18, zone);

						pstmt.setInt(19, ownerId);
						pstmt.setString(20, selectedCheckBox);
						pstmt.setString(21, pageName);
						pstmt.setString(22, sessionId);
						pstmt.setString(23, serverName);
						pstmt.setInt(24, flag);
						pstmt.setString(25, uniquePaymentKey);
						pstmt.setString(26, emailId);
						pstmt.setString(27, amount);
							
						pstmt.setString(28, responseJSON.getString("id"));
						pstmt.setString(29, "Payment Requested");
						pstmt.setString(30, responseJSON.getString("razor_pay_reponse_code"));
						pstmt.setString(31, requestType);
						pstmt.setString(32, startDate);
						pstmt.setString(33, endDate);
						pstmt.setInt(34, vehicleSubscriptionId);
						int i = pstmt.executeUpdate();
							if (i>0){
								message = "Payment link Successfully sent to owner mobile number and to mail (if given)";
							}else{
								message = "Payment link sent , Error while saving transaction.....";
							}
						}else{
							message = "Failed to initaiate payment , kindly retry";
						}
					}
			try {
				cf.insertDataIntoAuditLogReport(sessionId, tableList, pageName, "ADD", userId, serverName.substring(0, 45), systemId, customerId, "Registered Asset Details");
			} catch (Exception e) {
				e.printStackTrace();
			}
			return message;

		} catch (Exception e) {
			e.getMessage();
			return message;
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
	}

	private JSONObject requestPayment(Connection con,JSONObject jsonObject,LogWriter logWriter) {
		JSONObject response = null;
		CommonUtility commonUtility = new CommonUtility();
		try {
			response = commonUtility.requestPayment(con, 0, logWriter, "KA_SAND_RAZOR_PAY", jsonObject);
			return response;
		} catch (Exception e) {
			logWriter.log(e.getMessage(),LogWriter.INFO);
			return response;
		}
	}
	
	public JSONArray getPaymentTransaction(int systemId, int userId,Integer customerId,String startDate,String endDate,Integer offset) {
        JSONArray jsonArray = new JSONArray();
        JSONObject jsonObject = new JSONObject();
        Connection con = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        Integer counter = 0;
        try {
            con=DBConnection.getConnectionToDB("AMS");
              
            pstmt=con.prepareStatement(AdminStatements.GET_PAYMENT_TRANSACTIONS);
            pstmt.setInt(1,offset);
            pstmt.setInt(2,offset);
            pstmt.setInt(3,offset);
            pstmt.setInt(4,systemId);
            pstmt.setInt(5,customerId);
            pstmt.setInt(6,offset);
            pstmt.setString(7,ddmmyyhhmmss.format(ddmmyy.parse(startDate)));
            pstmt.setInt(8,offset);
            pstmt.setString(9,ddmmyyhhmmss.format(ddmmyy.parse(endDate)));
           
            rs=pstmt.executeQuery();
            while (rs.next()) {
                jsonObject = new JSONObject();
                jsonObject.put("slno", ++counter);
                jsonObject.put("assetType", rs.getString("ASSET_TYPE"));
                jsonObject.put("assetNumber", rs.getString("REGISTRATION_NO"));
                jsonObject.put("unitNo", rs.getString("UNIT_NO"));
                jsonObject.put("ltspName", rs.getString("LTSP_NAME"));
                jsonObject.put("groupName", rs.getString("GROUP_NAME"));
                jsonObject.put("customerName", rs.getString("CUSTOMER_NAME"));
                jsonObject.put("assetModel", rs.getString("ASSET_MODEL"));
                jsonObject.put("ownerName", rs.getString("OWNER_NAME"));
                jsonObject.put("ownerPhoneNo", rs.getString("OWNER_PHONE_NUMBER"));
                jsonObject.put("ownerEmailId", rs.getString("EMAIL_ID"));
                jsonObject.put("paymentStatus", rs.getString("PAYMENT_STATUS"));
                jsonObject.put("registrationStatus", rs.getString("REGISTRATION_STATUS"));
                jsonObject.put("amount", rs.getString("AMOUNT"));
                jsonObject.put("subscriptionType", rs.getString("REQUEST_TYPE"));
                jsonObject.put("requestedDate",  ddmmyy.format(ddmmyyhhmmss.parse(rs.getString("INSERTED_DATE"))));
                jsonObject.put("registredDate",  rs.getString("REGISTRATION_DATE").contains("1900")? "": ddmmyy.format(ddmmyyhhmmss.parse(rs.getString("REGISTRATION_DATE"))));
                jsonObject.put("paymentDate",  rs.getString("PAYMENT_RESPONSE_DATE").contains("1900")? "":ddmmyy.format(ddmmyyhhmmss.parse(rs.getString("PAYMENT_RESPONSE_DATE"))));
                if ((rs.getString("PAYMENT_STATUS").equalsIgnoreCase("cancelled")) || (rs.getString("PAYMENT_STATUS").equalsIgnoreCase("expired"))){
                	jsonObject.put("button", "<button onclick=resendLink(" + rs.getInt("ID") + "); class='btn btn-warning'>Resend Link</button> ");
                }else{
                	jsonObject.put("button", "");
                }
				
			
                jsonArray.put(jsonObject);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            DBConnection.releaseConnectionToDB(con, pstmt, rs);
        }
        return jsonArray;
    }
	
	
	public boolean IsPrePaymentMode(Integer systemId){
		boolean found = false;
		JSONArray arr = null;
		JSONObject obj = null;
		LTSP_Subscription_Payment_Function ltspFunction = new LTSP_Subscription_Payment_Function();
		try{
			arr = ltspFunction.getLTSP();
			if (arr.length() >0){
				for (int i = 0; i < arr.length(); i++) {
					obj = arr.getJSONObject(i);
					if ((Integer.parseInt(obj.getString("Systemid")) == systemId) && (obj.getString("paymentMode").equalsIgnoreCase("Y"))) {
						found = true;
						break;
					}
				}
			}
		}catch (Exception e) {
			found = false;
		}
		return found;
		
	}
	public String resendPaymentLink(int systemId, int userId, int parseInt,	Integer transactionId, int offset) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null ;
		String message = "Error, can't resend link....";
		String paymentStatus = "";
		try{
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(AdminStatements.GET_PAYMENT_TRANSACTION_BY_ID);
			pstmt.setInt(1, transactionId);
			rs = pstmt.executeQuery();
			if (rs.next()){
				paymentStatus = rs.getString("PAYMENT_STATUS");
				message = registerNewVehiclePrePaymentMode(rs.getString("ASSET_TYPE"), rs.getString("REGISTRATION_NO"), rs.getInt("GROUP_ID"), 
						rs.getString("UNIT_NO"), rs.getString("MOBILE_NUMBER"), rs.getInt("SYSTEM_ID"), rs.getInt("USER_ID"), 
						rs.getInt("OFFSET"), rs.getInt("CUSTOMER_ID"), rs.getString("LTSP_NAME"), rs.getString("GROUP_NAME"), 
						rs.getString("CUSTOMER_NAME"), rs.getString("ASSET_MODEL"), rs.getString("OWNER_NAME"), rs.getString("OWNER_ADDRESS"), 
						rs.getString("OWNER_PHONE_NUMBER"), rs.getString("ASSET_ID"), rs.getString("ZONE"), Integer.parseInt(rs.getString("OWNER_ID")),
						rs.getString("SELECTED_CHECK_BOX"), rs.getString("PAGE_NAME"), rs.getString("SESSION_ID"), rs.getString("SERVER_NAME"), 
						rs.getInt("FLAG"), rs.getString("EMAIL_ID"), rs.getString("AMOUNT"), rs.getString("REQUEST_TYPE"), 
						rs.getString("START_DATE"), rs.getString("END_DATE"), rs.getInt("VEHICLE_SUB_ID"));
				
				
			}
			if (message.contains("Payment link Successfully")){
				pstmt = con.prepareStatement(AdminStatements.UPDATE_TRANSACTION_TABLE);
				pstmt.setString(1,paymentStatus + " - Link resent" );
				pstmt.setInt(2, transactionId);
				pstmt.executeUpdate();
			}
			return message;
		}catch (Exception e) {
			e.printStackTrace();
			return message;
		}finally{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
}
}

