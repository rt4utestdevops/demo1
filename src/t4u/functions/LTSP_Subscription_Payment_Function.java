package t4u.functions;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.DateFormat;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;

import org.json.JSONArray;
import org.json.JSONObject;

import t4u.beans.ReportHelper;
import t4u.common.DBConnection;
import t4u.statements.AdminStatements;
import t4u.statements.SandMiningStatements;

public class LTSP_Subscription_Payment_Function {
	
	CommonFunctions cf = new CommonFunctions();	
	SimpleDateFormat simpleDateFormatYYYY = new SimpleDateFormat(
	"MM/dd/yyyy HH:mm:ss");
	SimpleDateFormat simpleDateFormatddMMYYYYDB = new SimpleDateFormat(
	"yyyy-MM-dd HH:mm:ss");
	SimpleDateFormat simpleDateFormatddMMYYYYDB1 = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");

	SimpleDateFormat simpleDateFormatddMMYY = new SimpleDateFormat(
	"dd/MM/yyyy HH:mm:ss");
	SimpleDateFormat simpleDateFormatddMMYYAMPM = new SimpleDateFormat(
	"dd/MM/yyyy hh:mm aa");
	SimpleDateFormat simpleDateFormatddMMYY1 = new SimpleDateFormat(
	"dd/MM/yyyy");
	SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
	SimpleDateFormat simpleDateFormatdd_MM_YY = new SimpleDateFormat(
	"dd-MM-yyyy");
	DecimalFormat df = new DecimalFormat("#.##");

LogWriter logWriter=null;
	
	public JSONArray getLTSP() {
		JSONArray JsonArray = null;
		JSONObject JsonObject = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;		   
		try {
			JsonArray = new JSONArray();
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(AdminStatements.GET_ALL_LTSP);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				JsonObject = new JSONObject();
				JsonObject.put("Systemid", rs.getString("SystemId"));
				JsonObject.put("SystemName", rs.getString("SystemName"));
				JsonObject.put("paymentMode", rs.getString("PRE_PAYMENT_MODE"));
				JsonArray.put(JsonObject);
			}		       
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return JsonArray;
	}

	public JSONArray getClientList(String systemid){
		Connection con=null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		JSONArray JsonArray = null;

		try{	 
			JsonArray = new JSONArray();
			con = DBConnection.getConnectionToDB("AMS");			   		 
			pstmt=con.prepareStatement(AdminStatements.SELECT_CLIENT_LIST);
			pstmt.setString(1, systemid);	  				
			rs=pstmt.executeQuery();		   		  
			while(rs.next()){ 
				JSONObject obj1 = new JSONObject(); 		   		
				obj1.put("clientid",rs.getString("CustomerId")); 
				obj1.put("clientname",rs.getString("CustomerName")); 
				JsonArray.put(obj1);
			}
		}catch(Exception e){
			System.out.println("Error when getClientList.."+e);
		}
		finally{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return JsonArray;  			
	}
	public JSONArray getDistrictNames(String ltsp) {
		Connection con=null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		JSONArray JsonArray = null;
		JSONObject obj1 = null; 
		try {
			JsonArray = new JSONArray();
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement("select * from dbo.General_Settings where System_Id=? and name='District'");
			pstmt.setString(1, ltsp);
			rs = pstmt.executeQuery();

			while (rs.next()) {
				obj1 = new JSONObject();
				obj1.put("districtid", rs.getString("value"));
				obj1.put("districtname", rs.getString("value"));

				JsonArray.put(obj1);
			} // end of while rs
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return JsonArray;
	}
	
public ArrayList < Object > getSubscriptionPaymentDetails()
	{ 
	JSONArray JsonArray = null;
	JSONObject obj = null;
	Connection con = null;
	PreparedStatement pstmt = null;
	int count=0;
	ResultSet rs = null;
	
	ArrayList < Object > finlist = new ArrayList < Object > ();
    ArrayList headersList = new ArrayList();
    ArrayList reportsList = new ArrayList();
	ReportHelper finalreporthelper = new ReportHelper();

	try {
		headersList.add("SLNO");
	    headersList.add("LTSP Name");
        headersList.add("Client Name");
        headersList.add("District Name");
        headersList.add("Work Order Issued");
        headersList.add("Validity Start Date");
        headersList.add("Validity End Date");
        headersList.add("Subscription Duration");
        headersList.add("Amount Per Month");
        headersList.add("Total Amount");
        headersList.add("Inserted Date");
        headersList.add("Sunscripition Status");
        headersList.add("LTSP Share Amount");
		
	JsonArray=new JSONArray();	
	con = DBConnection.getConnectionToDB("AMS");
	pstmt=con.prepareStatement(AdminStatements.GET_LTSP_SUBSCRIPTION_DETAILS);
	rs=pstmt.executeQuery();
	while(rs.next())
	{
	count++;
	obj=new JSONObject();
	ArrayList informationList = new ArrayList();
	ReportHelper reporthelper = new ReportHelper();

	obj.put("slnoIndex", count);
	informationList.add(count);
	
	obj.put("ltspNameindex", rs.getString("LTSP_NAME"));
	informationList.add(rs.getString("LTSP_NAME"));
	
	obj.put("clientindex", rs.getString("CUSTOMER_NAME"));
	informationList.add(rs.getString("CUSTOMER_NAME"));
	
	obj.put("districtindex", rs.getString("DISTRICT_NAME"));
	informationList.add(rs.getString("DISTRICT_NAME"));
	
	obj.put("workOrderindex", rs.getString("WORK_ORDER_ISSUED"));
	informationList.add(rs.getString("WORK_ORDER_ISSUED"));
	
	if (rs.getString("START_DATE").contains("1900") || rs.getString("START_DATE")== null || rs.getString("START_DATE").equals("")) {
		obj.put("startDateindex", "");
		informationList.add("");
	}else{
		obj.put("startDateindex", simpleDateFormatdd_MM_YY.format(rs.getTimestamp("START_DATE")));
		informationList.add(simpleDateFormatdd_MM_YY.format(rs.getTimestamp("START_DATE")));
	}
	if (rs.getString("END_DATE").contains("1900") || rs.getString("END_DATE")== null || rs.getString("END_DATE").equals("")) {
		obj.put("endDateindex", "");
		informationList.add("");
	}else{
		obj.put("endDateindex", simpleDateFormatdd_MM_YY.format(rs.getTimestamp("END_DATE")));
		informationList.add(simpleDateFormatdd_MM_YY.format(rs.getTimestamp("END_DATE")));
	}
	obj.put("subscriptionindex", rs.getString("SUBSCRIPTION_DURATION"));
	informationList.add(rs.getString("SUBSCRIPTION_DURATION"));
	
	obj.put("amountPerMonthindex", rs.getString("AMOUNT_PER_MONTH"));
	informationList.add(rs.getString("AMOUNT_PER_MONTH"));
	
	obj.put("totalAmountindex", rs.getString("TOTAL_AMOUNT"));
	informationList.add(rs.getString("TOTAL_AMOUNT"));
	
	if (rs.getString("INSERTED_DATETIME").contains("1900") || rs.getString("INSERTED_DATETIME")== null || rs.getString("INSERTED_DATETIME").equals("")) {
		obj.put("insertedDateindex", "");
		informationList.add("");
	}else{
		obj.put("insertedDateindex", simpleDateFormatddMMYYYYDB1.format(rs.getTimestamp("INSERTED_DATETIME")));
		informationList.add(simpleDateFormatddMMYYYYDB1.format(rs.getTimestamp("INSERTED_DATETIME")));
	}
	
	obj.put("SubscriptionStatusindex", rs.getString("SUBSCRIPTION_STATUS"));
	informationList.add(rs.getString("SUBSCRIPTION_STATUS"));
	
	obj.put("LTSPShareindex", rs.getString("MOPER_AMOUNT"));
	informationList.add(rs.getString("MOPER_AMOUNT"));
	

	JsonArray.put(obj);
	reporthelper.setInformationList(informationList);
	reportsList.add(reporthelper);
	}
	finalreporthelper.setReportsList(reportsList);
    finalreporthelper.setHeadersList(headersList);
    finlist.add(JsonArray);
    finlist.add(finalreporthelper);
    
	}
	catch (Exception e) {
	e.printStackTrace();
	} finally {
	    DBConnection.releaseConnectionToDB(con, pstmt, rs);
	}
	return finlist;
	}
	
	public String addLTSPSubscriptionDetails(int systemId,int customerId,String districtName,String workOrder,String startDate,String endDate,
			int subscription,Double amount, Double totalAmount ,Double MoperAmount, String RadioCheck){
		Connection con=null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		JSONArray JsonArray = null;
		String message = "";

		try{	 
			JsonArray = new JSONArray();
			con = DBConnection.getConnectionToDB("AMS");	
			
			pstmt=con.prepareStatement(AdminStatements.CHECK_LTSP_SUBSCRIPTION_DETAILS_EXIST);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, customerId);
			rs = pstmt.executeQuery();
			if(rs.next()){
				return " Record already exists for this LTSP and Customer ";
			}
			
			pstmt=con.prepareStatement(AdminStatements.INSERT_LTSP_SUBSCRIPTION_DETAILS);
			pstmt.setString(1, workOrder);
			pstmt.setString(2, startDate);	
			pstmt.setString(3, endDate);	
			pstmt.setInt(4, subscription);	
			pstmt.setDouble(5, amount);
			pstmt.setDouble(6, totalAmount);	
			pstmt.setInt(7, systemId);	
			pstmt.setInt(8, customerId);	
			pstmt.setString(9, districtName);
			pstmt.setDouble(10, MoperAmount);	
			pstmt.setString(11, RadioCheck);
			
			int inserted = pstmt.executeUpdate();   		  
			if(inserted > 0){
				message = "Saved Successfully";
			}
		}catch(Exception e){
			System.out.println("Error when addLTSPSubscriptionDetails.."+e);
		}
		finally{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return message;  			
	}
	
	public JSONArray getVehicleNo(int systemId,int clientId,int userId,int offset) {
		Connection con=null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		JSONArray JsonArray = null;
		JSONObject obj1 = null; 
		try {
			JsonArray = new JSONArray();
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(SandMiningStatements.GET_VEHICLE_NO);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, clientId);
			rs = pstmt.executeQuery();

			while (rs.next()) {
				obj1 = new JSONObject();
				obj1.put("PermitNoNew", rs.getString("REGISTRATION_NO"));

				JsonArray.put(obj1);
			} // end of while rs
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return JsonArray;
	}
	
	public JSONArray getLTSPSubscriptionDetails(int systemId,int clientId,int userId) {
		Connection con=null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		JSONArray JsonArray = null;
		JSONObject obj1 = null; 
		try {
			JsonArray = new JSONArray();
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(SandMiningStatements.GET_LTSP_SUBSCRIPTION_DETAILS);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, clientId);
			rs = pstmt.executeQuery();

			while (rs.next()) {
				obj1 = new JSONObject();
				obj1.put("customerId", rs.getString("CUSTOMER_ID"));
				obj1.put("subscriptionDuration", rs.getString("SUBSCRIPTION_DURATION"));
				obj1.put("amountPerMonth", rs.getString("AMOUNT_PER_MONTH"));
				obj1.put("totalAmount", rs.getString("TOTAL_AMOUNT"));
				obj1.put("subscriptionType", rs.getString("SUBSCRIPTION_STATUS"));
				JsonArray.put(obj1);
			} // end of while rs
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return JsonArray;
	}
	public String addVehicleSubscriptionDetails(int systemId,int customerId,int userId, String vehicleNo,String startDate,String endDate,String reminderDate,
			String modeOfPayment,String ddNo,String ddDate,String bankName, int totalAmount,int subscriptionDuration){
		Connection con=null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		JSONArray JsonArray = null;
		String message = "";
		
		try{	 
			JsonArray = new JSONArray();
			con = DBConnection.getConnectionToDB("AMS");	
			pstmt=con.prepareStatement(SandMiningStatements.CHECK_DUPLICATE_VEHICLE_NO);
	        pstmt.setInt(1,systemId);
	        pstmt.setInt(2,customerId);
	        pstmt.setString(3,vehicleNo.replace(" ", ""));
	        pstmt.setString(4,startDate);
	        rs=pstmt.executeQuery();
	        if(rs.next())
	        {
	        	message="Vehicle No is Already Exist Of The Specified Start Date";
	        	return message;
	        }
	        pstmt=null;
			
			pstmt=con.prepareStatement(SandMiningStatements.CHECK_DUPLICATE_SUBSCRIPTION_DD_NO);
	        pstmt.setInt(1,systemId);
	        pstmt.setInt(2,customerId);
	        pstmt.setString(3,ddNo);
	        rs=pstmt.executeQuery();
	        if(rs.next())
	        {
	        	message="DD No is Already Exist. Please Enter Unique DD No";
	        	return message;
	        }
	        pstmt=null;
	        
			pstmt=con.prepareStatement(SandMiningStatements.INSERT_VEHICLE_SUBSCRIPTION_DETAILS);
			pstmt.setInt(1,systemId);
	        pstmt.setInt(2,customerId);
	        pstmt.setInt(3,userId);
	        pstmt.setString(4,vehicleNo.toUpperCase());
	        pstmt.setString(5, startDate);	
			pstmt.setString(6, endDate);
			pstmt.setString(7, modeOfPayment);	
			pstmt.setString(8, ddNo);
			pstmt.setString(9, ddDate);
			pstmt.setString(10, bankName);
			pstmt.setInt(11,totalAmount);
			pstmt.setString(12, reminderDate);
			pstmt.setInt(13,subscriptionDuration);
			pstmt.setInt(14,userId);
			
			int inserted = pstmt.executeUpdate();   		  
			if(inserted > 0){
				message = "Saved Successfully";
			}
		}catch(Exception e){
			System.out.println("Error when addVehicleSubscriptionDetails.."+e);
		}
		finally{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return message;  			
	}
	public ArrayList < Object > getVehicleSubscriptionDetails(int systemId,int customerId)
	{ 
	JSONArray JsonArray = null;
	JSONObject obj = null;
	Connection con = null;
	PreparedStatement pstmt = null;
	int count=0;
	ResultSet rs = null;
	
	ArrayList < Object > finlist = new ArrayList < Object > ();
    ArrayList headersList = new ArrayList();
    ArrayList reportsList = new ArrayList();
	ReportHelper finalreporthelper = new ReportHelper();

	try {
		headersList.add("SLNO");
		headersList.add("ID");
	    headersList.add("Vehicle No");
        headersList.add("Validity Start Date");
        headersList.add("Validity End Date");
        headersList.add("Mode Of Payment");
        headersList.add("DD/Recipt No");
        headersList.add("DD Date");
        headersList.add("Bank Name");
        headersList.add("Total Amount");
        headersList.add("Remainder Date");
        headersList.add("Vehicle Status");
        headersList.add("Inserted Date");
		
	JsonArray=new JSONArray();	
	con = DBConnection.getConnectionToDB("AMS");
	pstmt=con.prepareStatement(SandMiningStatements.GET_VEHICLE_SUBSCRIPTION_DETAILS);
	pstmt.setInt(1,systemId);
    pstmt.setInt(2,customerId);
	rs=pstmt.executeQuery();
	while(rs.next())
	{
	count++;
	obj=new JSONObject();
	ArrayList informationList = new ArrayList();
	ReportHelper reporthelper = new ReportHelper();

	obj.put("slnoIndex", count);
	informationList.add(count);
	
	obj.put("idIndex", rs.getString("ID"));
	informationList.add(rs.getString("ID"));
	
	obj.put("VehicleNoindex", rs.getString("VEHICLE_NO"));
	informationList.add(rs.getString("VEHICLE_NO"));
	
	if (rs.getString("START_DATE").contains("1900") || rs.getString("START_DATE")== null || rs.getString("START_DATE").equals("")) {
		obj.put("startDateindex", "");
		informationList.add("");
	}else{
		obj.put("startDateindex", simpleDateFormatdd_MM_YY.format(rs.getTimestamp("START_DATE")));
		informationList.add(simpleDateFormatdd_MM_YY.format(rs.getTimestamp("START_DATE")));
	}
	if (rs.getString("END_DATE").contains("1900") || rs.getString("END_DATE")== null || rs.getString("END_DATE").equals("")) {
		obj.put("endDateindex", "");
		informationList.add("");
	}else{
		obj.put("endDateindex", simpleDateFormatdd_MM_YY.format(rs.getTimestamp("END_DATE")));
		obj.put("hideEndDateIndex",sdf.format(rs.getTimestamp("END_DATE")));
		informationList.add(simpleDateFormatdd_MM_YY.format(rs.getTimestamp("END_DATE")));
	}
	
	obj.put("modeOfPaymentindex", rs.getString("MODE_OF_PAYMENT"));
	informationList.add(rs.getString("MODE_OF_PAYMENT"));
	
	obj.put("ddNoindex", rs.getString("DD_NO"));
	informationList.add(rs.getString("DD_NO"));
	
	if (rs.getString("DD_DATE").contains("1900") || rs.getString("DD_DATE")== null || rs.getString("DD_DATE").equals("")) {
		obj.put("ddDateindex", "");
		informationList.add("");
	}else{
		obj.put("ddDateindex", simpleDateFormatdd_MM_YY.format(rs.getTimestamp("DD_DATE")));
		informationList.add(simpleDateFormatdd_MM_YY.format(rs.getTimestamp("DD_DATE")));
	}
	obj.put("bankNameindex", rs.getString("BANK_NAME"));
	informationList.add(rs.getString("BANK_NAME"));
	
	obj.put("totalAmountindex", rs.getString("TOTAL_AMOUNT"));
	informationList.add(rs.getString("TOTAL_AMOUNT"));
	
	if (rs.getString("REMAINDER_DATE").contains("1900") || rs.getString("REMAINDER_DATE")== null || rs.getString("REMAINDER_DATE").equals("")) {
		obj.put("remainderDateindex", "");
		informationList.add("");
	}else{
		obj.put("remainderDateindex", simpleDateFormatdd_MM_YY.format(rs.getTimestamp("REMAINDER_DATE")));
		informationList.add(simpleDateFormatdd_MM_YY.format(rs.getTimestamp("REMAINDER_DATE")));
	}
	
	obj.put("vehicleStatusindex", rs.getString("VEHICLE_STATUS"));
	informationList.add(rs.getString("VEHICLE_STATUS"));
	
	if (rs.getString("INSERTED_DATETIME").contains("1900") || rs.getString("INSERTED_DATETIME")== null || rs.getString("INSERTED_DATETIME").equals("")) {
		obj.put("insertedDateindex", "");
		informationList.add("");
	}else{
		obj.put("insertedDateindex", simpleDateFormatddMMYYYYDB1.format(rs.getTimestamp("INSERTED_DATETIME")));
		informationList.add(simpleDateFormatddMMYYYYDB1.format(rs.getTimestamp("INSERTED_DATETIME")));
	}

	JsonArray.put(obj);
	reporthelper.setInformationList(informationList);
	reportsList.add(reporthelper);
	}
	finalreporthelper.setReportsList(reportsList);
    finalreporthelper.setHeadersList(headersList);
    finlist.add(JsonArray);
    finlist.add(finalreporthelper);
    
	}
	catch (Exception e) {
	e.printStackTrace();
	} finally {
	    DBConnection.releaseConnectionToDB(con, pstmt, rs);
	}
	return finlist;
	}
	public String modifyVehicleSubscriptionDetails(int systemId,int customerId,int userId, String vehicleNo,String startDate,String endDate,String reminderDate,
			String modeOfPayment,String ddNo,String ddDate,String bankName, int totalAmount,int subscriptionDuration,int id,String  billing){
		Connection con=null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		String message = "";

		try{
			con = DBConnection.getConnectionToDB("AMS");
			
			pstmt=con.prepareStatement(SandMiningStatements.CHECK_DUPLICATE_SUBSCRIPTION_DD_NO.concat(" and ID not in (select ID from AMS.dbo.VEHICLE_SUBSCRIPTION_DETAILS where ID=? and SYSTEM_ID=? and CUSTOMER_ID=?)"));
	        pstmt.setInt(1,systemId);
	        pstmt.setInt(2,customerId);
	        pstmt.setString(3,ddNo);
	        pstmt.setInt(4,id);
	        pstmt.setInt(5,systemId);
	        pstmt.setInt(6,customerId);
	        
	        rs=pstmt.executeQuery();
	        if(rs.next())
	        {
	        	message="DD No is Already Exist. Please Enter Unique DD No";
	        	return message;
	        }
	        pstmt=null;
	        Date date = new Date();  
	        DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");	  
	        Date date1=new SimpleDateFormat("dd-MM-yyyy").parse(startDate);
	        Calendar cal = Calendar.getInstance();
	        cal.setTime(date1);
	        System.out.println(date1);
	        cal.set(Calendar.MONTH, (cal.get(Calendar.MONTH)+subscriptionDuration));
	        date1 = cal.getTime();	             
	        //to convert Date to String, use format method of SimpleDateFormat class.
	        String endDates = dateFormat.format(date1);
			pstmt=con.prepareStatement(SandMiningStatements.UPDATE_VEHICLE_SUBSCRIPTION_DETAILS);
			pstmt.setString(1, modeOfPayment);	
			pstmt.setString(2, ddNo);
			pstmt.setString(3, ddDate);
			pstmt.setString(4, bankName);
			pstmt.setInt(5,totalAmount);
			pstmt.setInt(6,subscriptionDuration);
			pstmt.setInt(7,userId);
	        pstmt.setString(8, billing);
	        if(billing.equalsIgnoreCase("Non Billable"))
			{
	        	pstmt.setString(9,dateFormat.format(date));
			}else{
				pstmt.setString(9, endDates);
			}
			pstmt.setInt(10,systemId);
	        pstmt.setInt(11,customerId);
	        pstmt.setInt(12,id);
			int inserted = pstmt.executeUpdate();   		  
			if(inserted > 0){
				message = "Updated Successfully";
			}
		}catch(Exception e){
			e.printStackTrace();
			System.out.println("Error when modifyVehicleSubscriptionDetails.."+e);
		}
		finally{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return message;  			
	}

	public String RenwalOfVehicleSubscriptionDetails(int systemId,int CustID, int userId, String vechNumber, String startDate,String endDate,String id,int offset) {
		// TODO Auto-generated method stub
		Date strtDate = null;
		Date endsDate = null;
		Date todaysDate = new Date();
		PreparedStatement pstmt=null;
		PreparedStatement pstmt1=null;
		PreparedStatement pstmt2=null;
		PreparedStatement pstmt3=null;
		ResultSet rs=null;
		ResultSet rs1=null;
		ResultSet rs2=null;
		ResultSet rs3=null;
		String Msg="Failed";
		Connection con=null;
		try {
			con = DBConnection.getConnectionToDB("AMS");

			boolean prePaymentMode = new AdminFunctions().IsPrePaymentMode(systemId);
			if (prePaymentMode) {
				Msg = sendRenewalPaymentLink(con,systemId,CustID,userId,vechNumber,startDate,endDate,Integer.parseInt(id),offset);
			} else {

				strtDate = new SimpleDateFormat("dd-MM-yyyy").parse(startDate);
				endsDate = new SimpleDateFormat("dd-MM-yyyy").parse(endDate);
				pstmt = con.prepareStatement(SandMiningStatements.CHECK_IF_LTSP_SUBSCRIPTION_DETAILS_FOR_SUBSCRIPTION_VALIDATION);
				pstmt.setInt(1, systemId);
				pstmt.setInt(2, CustID);
				rs2 = pstmt.executeQuery();
				if (rs2.next()) {
					pstmt = con.prepareStatement("select VEHICLE_STATUS,END_DATE,SUBSCRIPTION_DURATION,* " + " from AMS.dbo.VEHICLE_SUBSCRIPTION_DETAILS Where VEHICLE_NO=? "
							+ " and  SYSTEM_ID=? and CUSTOMER_ID=? " + " and END_DATE=(select MAX(END_DATE) from AMS.dbo.VEHICLE_SUBSCRIPTION_DETAILS "
							+ " where VEHICLE_NO=? and  SYSTEM_ID=? and CUSTOMER_ID=?) and ID=?");
					pstmt.setString(1, vechNumber);
					pstmt.setInt(2, systemId);
					pstmt.setInt(3, CustID);
					pstmt.setString(4, vechNumber);
					pstmt.setInt(5, systemId);
					pstmt.setInt(6, CustID);
					pstmt.setString(7, id);
					rs = pstmt.executeQuery();
					if (rs.next()) {
						pstmt = con
								.prepareStatement("insert into AMS.dbo.VEHICLE_SUBSCRIPTION_DETAILS_HISTORY (SYSTEM_ID,CUSTOMER_ID,USER_ID,VEHICLE_NO,START_DATE,END_DATE,MODE_OF_PAYMENT,DD_NO,DD_DATE,BANK_NAME,TOTAL_AMOUNT,REMAINDER_DATE,SUBSCRIPTION_DURATION,VEHICLE_STATUS,INSERTED_BY,INSERTED_DATETIME,UPDATED_BY,UPDATED_DATETIME,SUBSCRIPTION_STATUS,BILLING_STATUS) values  (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,getutcdate(),?,?,?,?)");
						pstmt.setString(1, rs.getString("SYSTEM_ID"));
						pstmt.setString(2, rs.getString("CUSTOMER_ID"));
						pstmt.setString(3, rs.getString("USER_ID"));
						pstmt.setString(4, rs.getString("VEHICLE_NO"));
						pstmt.setString(5, rs.getString("START_DATE"));
						pstmt.setString(6, rs.getString("END_DATE"));
						pstmt.setString(7, rs.getString("MODE_OF_PAYMENT"));
						pstmt.setString(8, rs.getString("DD_NO"));
						pstmt.setString(9, rs.getString("DD_DATE"));
						pstmt.setString(10, rs.getString("BANK_NAME"));
						pstmt.setString(11, rs.getString("TOTAL_AMOUNT"));
						pstmt.setString(12, rs.getString("REMAINDER_DATE"));
						pstmt.setString(13, rs.getString("SUBSCRIPTION_DURATION"));
						pstmt.setString(14, rs.getString("VEHICLE_STATUS"));
						pstmt.setString(15, rs.getString("INSERTED_BY"));
						// pstmt.setString(16,rs.getString("INSERTED_DATETIME"));
						pstmt.setString(16, rs.getString("UPDATED_BY"));
						pstmt.setString(17, rs.getString("UPDATED_DATETIME"));
						pstmt.setString(18, rs.getString("SUBSCRIPTION_STATUS"));
						pstmt.setString(19, rs.getString("BILLING_STATUS"));
						pstmt.executeUpdate();
						SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd "); // 23:59:59
						Calendar cal = Calendar.getInstance();
						Calendar endcal = Calendar.getInstance();
						endcal.setTime(endsDate);
						pstmt = con
								.prepareStatement("update AMS.dbo.VEHICLE_SUBSCRIPTION_DETAILS set DD_NO='',DD_DATE='',BANK_NAME='',MODE_OF_PAYMENT='DD/Recipt',"
										+ " SUBSCRIPTION_STATUS='Subscription',VEHICLE_STATUS ='Active',SUBSCRIPTION_DURATION=?,TOTAL_AMOUNT=?,START_DATE=?,END_DATE=?,REMAINDER_DATE=?,INSERTED_BY=?,INSERTED_DATETIME=getutcdate()"
										+ " where SYSTEM_ID=? and CUSTOMER_ID=? and VEHICLE_NO=? and ID=?");

						pstmt.setString(1, rs2.getString("SUBSCRIPTION_DURATION"));
						pstmt.setInt(2, rs2.getInt("AMOUNT_PER_MONTH") * rs2.getInt("SUBSCRIPTION_DURATION"));
						if (endsDate.after(todaysDate)) {
							pstmt.setString(3, formatter.format(endsDate));
							endcal.add(Calendar.MONTH, rs2.getInt("SUBSCRIPTION_DURATION"));
							pstmt.setString(4, formatter.format(endcal.getTime()));
							endcal.add(Calendar.DATE, -10);
							pstmt.setString(5, formatter.format(endcal.getTime()));

						} else {
							pstmt.setString(3, formatter.format(cal.getTime()));
							cal.add(Calendar.MONTH, rs2.getInt("SUBSCRIPTION_DURATION"));
							pstmt.setString(4, formatter.format(cal.getTime()));
							cal.add(Calendar.DATE, -10);
							pstmt.setString(5, formatter.format(cal.getTime()));
						}

						pstmt.setInt(6, userId);
						pstmt.setString(7, rs.getString("SYSTEM_ID"));
						pstmt.setString(8, rs.getString("CUSTOMER_ID"));
						pstmt.setString(9, rs.getString("VEHICLE_NO"));
						pstmt.setString(10, id);
						int i = pstmt.executeUpdate();

						if (i > 0) {
							Msg = " Succesfully Completed";
						}
						if (rs.getString("VEHICLE_STATUS").equalsIgnoreCase("InActive")) {
							pstmt1 = con.prepareStatement(SandMiningStatements.CHECK_USER_IN_VEHICLE_USER);
							pstmt2 = con.prepareStatement(SandMiningStatements.INSERT_VEHICLE_USER);
							pstmt3 = con.prepareStatement(SandMiningStatements.CHECK_RECORD_IN_INACTIVEVEHICLEUSERASSOCIATION_HIST);
							pstmt3.setInt(1, systemId);
							pstmt3.setString(2, rs.getString("VEHICLE_NO"));
							rs3 = pstmt3.executeQuery();
							if (rs3.next()) {
								String userids = rs3.getString("User_id");
								if (userids.equals("")) {
									pstmt = con.prepareStatement(SandMiningStatements.GET_USER_FOR_INACTIVE_VEHICLE.replace("#", ""));
								} else {
									pstmt = con.prepareStatement(SandMiningStatements.GET_USER_FOR_INACTIVE_VEHICLE.replace("#", " and User_id in (" + userids + ") "));
								}
								pstmt.setInt(1, systemId);
								pstmt.setString(2, rs.getString("VEHICLE_NO"));
								pstmt.setInt(3, systemId);
								pstmt.setInt(4, systemId);
							} else {
								pstmt = con.prepareStatement(SandMiningStatements.GET_USER_FOR_INACTIVE_VEHICLE.replace("#", ""));
								pstmt.setInt(1, systemId);
								pstmt.setString(2, rs.getString("VEHICLE_NO"));
								pstmt.setInt(3, systemId);
								pstmt.setInt(4, systemId);
							}
							rs3 = pstmt.executeQuery();
							while (rs3.next()) {
								pstmt1.setInt(1, systemId);
								pstmt1.setString(2, rs.getString("VEHICLE_NO"));
								pstmt1.setString(3, rs3.getString("User_id"));
								rs1 = pstmt1.executeQuery();
								if (!rs1.next()) {
									pstmt2.setString(1, rs.getString("VEHICLE_NO"));
									pstmt2.setString(2, rs3.getString("User_id"));
									pstmt2.setInt(3, systemId);
									try {
										pstmt2.executeUpdate();
									} catch (SQLException e) {
										System.out.println("primary key voilation=" + e);
									}
								}
							}
							pstmt = con.prepareStatement(SandMiningStatements.DELETE_RECORD_IN_INACTIVEVEHICLEUSERASSOCIATION_HIST);
							pstmt.setInt(1, systemId);
							pstmt.setString(2, rs.getString("VEHICLE_NO"));
							pstmt.executeUpdate();

						}
					}
				}
			}

		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}finally{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
			DBConnection.releaseConnectionToDB(null, pstmt1, rs1);
			DBConnection.releaseConnectionToDB(null, pstmt2, rs2);
			DBConnection.releaseConnectionToDB(null, pstmt3, rs3);
		}
	
		
		return Msg;
	}

	private String sendRenewalPaymentLink(Connection con,int systemId,int customerId, int userId, String vechNumber, String startDate,String endDate,Integer id,int offset) {
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String totalAmount = "";
		String msg = "";
		try{
			
			pstmt = con.prepareStatement(AdminStatements.GET_VEHICLE_SUBSCRIPTION_DETAILS_BY_SYSTEM_ID_CUSTOMER_ID);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, customerId);
			rs = pstmt.executeQuery();
			if (rs.next()){
				totalAmount = rs.getString("TOTAL_AMOUNT");
			}
			DBConnection.releaseConnectionToDB(null, pstmt, rs);
			
			pstmt = con.prepareStatement(AdminStatements.GET_TBL_VEHICLE_MASTER);
			pstmt.setString(1, vechNumber);
			pstmt.setInt(2, systemId);
			rs = pstmt.executeQuery();
		 
			if (rs.next()){
			msg = 	new AdminFunctions().registerNewVehiclePrePaymentMode("", vechNumber, 0, "", "", systemId, userId, offset, customerId, "", "", "", "", rs.getString("OwnerName"), rs.getString("OwnerAddress"), rs.getString("OwnerContactNo"), "", "", rs.getInt("OWNER_ID"), "", "", "", "", 0, rs.getString("OwnerEmailId"), totalAmount,"Renewal",startDate,endDate,id);
						
			}else{
			msg = 	"Couldn't send payment link, as failed to get owner info. Possible reason is no record found for given vehicle in asset master";
			}
			 return msg;
				
		}catch (Exception e) {
			e.printStackTrace();
			return "";
		}
	}

	public ArrayList<Object> getVehicleSubscriptionReportDetails(int systemId,int customerId, String startDate, String endDate,int offset) {
		JSONArray JsonArray = null;
		JSONObject obj = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		int count = 0;
		ResultSet rs = null;

		ArrayList<Object> finlist = new ArrayList<Object>();
		ArrayList<String> headersList = new ArrayList<String>();
		ArrayList<ReportHelper> reportsList = new ArrayList<ReportHelper>();
		ReportHelper finalreporthelper = new ReportHelper();

		try {

			headersList.add("SL No");
			headersList.add("Id ");
			headersList.add("Vehicle No");
			headersList.add("Validity Start Date");
			headersList.add("Validity End Date");
			headersList.add("Mode Of Payment");
	        headersList.add("Total Amount");
	        headersList.add("Payment Due Date Reminder");
	        headersList.add("Inserted Date");

			JsonArray = new JSONArray();
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con
					.prepareStatement(SandMiningStatements.GET_VEHICLE_SUBSCRIPTION_DETAILS_REPORT);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, customerId);
			pstmt.setInt(3, offset);
			pstmt.setString(4, startDate);
			pstmt.setInt(5, offset);
			pstmt.setString(6, endDate);
			
			rs = pstmt.executeQuery();
			while (rs.next()) {
				count++;
				obj = new JSONObject();
				ArrayList<Object> informationList = new ArrayList<Object>();
				ReportHelper reporthelper = new ReportHelper();

				obj.put("slnoIndex", count);
				informationList.add(count);

				obj.put("idIndex", rs.getString("ID"));
				informationList.add(rs.getString("ID"));

				obj.put("VehicleNoindex", rs.getString("VEHICLE_NO"));
				informationList.add(rs.getString("VEHICLE_NO"));

				if (rs.getString("START_DATE").contains("1900")|| rs.getString("START_DATE") == null|| rs.getString("START_DATE").equals("")) {
					obj.put("startDateindex", "");
					informationList.add("");
				} else {
					obj.put("startDateindex", rs.getTimestamp("START_DATE"));
					informationList.add(simpleDateFormatdd_MM_YY.format(rs.getTimestamp("START_DATE")));
				}
				if (rs.getString("END_DATE").contains("1900")|| rs.getString("END_DATE") == null|| rs.getString("END_DATE").equals("")) {
					obj.put("endDateindex", "");
					informationList.add("");
				} else {
					obj.put("endDateindex", rs.getTimestamp("END_DATE"));
					informationList.add(simpleDateFormatdd_MM_YY.format(rs.getTimestamp("END_DATE")));
				}
				obj.put("modeOfPaymentindex", rs.getString("MODE_OF_PAYMENT"));
				informationList.add(rs.getString("MODE_OF_PAYMENT"));
											
				obj.put("totalAmountindex", rs.getString("TOTAL_AMOUNT"));
				informationList.add(rs.getString("TOTAL_AMOUNT"));
				
				if (rs.getString("REMAINDER_DATE").contains("1900") || rs.getString("REMAINDER_DATE")== null || rs.getString("REMAINDER_DATE").equals("")) {
					obj.put("remainderDateindex", "");
					informationList.add("");
				}else{
					obj.put("remainderDateindex", simpleDateFormatdd_MM_YY.format(rs.getTimestamp("REMAINDER_DATE")));
					informationList.add(simpleDateFormatdd_MM_YY.format(rs.getTimestamp("REMAINDER_DATE")));
				}
								
				if (rs.getString("INSERTED_DATETIME").contains("1900") || rs.getString("INSERTED_DATETIME")== null || rs.getString("INSERTED_DATETIME").equals("")) {
					obj.put("insertedDateindex", "");
					informationList.add("");
				}else{
					obj.put("insertedDateindex", simpleDateFormatddMMYYYYDB1.format(rs.getTimestamp("INSERTED_DATETIME")));
					informationList.add(simpleDateFormatddMMYYYYDB1.format(rs.getTimestamp("INSERTED_DATETIME")));
				}

				JsonArray.put(obj);
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

					
	public JSONArray getCustomer(int SystemId,String ltsp,int customerIdlogin,String page){
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject = new JSONObject();
		Connection conAdmin=null;
		PreparedStatement pstmt=null;
		
		ResultSet rs=null;
		try{
			jsonArray = new JSONArray();
			jsonObject = new JSONObject();
			
			conAdmin=DBConnection.getConnectionToDB("ADMINISTRATOR");
			if(customerIdlogin == 9999 ){
				pstmt=conAdmin.prepareStatement(SandMiningStatements.GET_CUSTOMER);
				pstmt.setInt(1, SystemId);
			}
			else if(customerIdlogin>0 ){
				pstmt=conAdmin.prepareStatement(SandMiningStatements.GET_CUSTOMER_FOR_LOGGED_IN_CUST);
				pstmt.setInt(1, SystemId);
				pstmt.setInt(2,customerIdlogin );
			}else{
				pstmt=conAdmin.prepareStatement(SandMiningStatements.GET_CUSTOMER);
				pstmt.setInt(1, SystemId);
			}
			rs=pstmt.executeQuery();
			//if we want to give option to select whole ltsp
			if(ltsp.equals("yes") && customerIdlogin==0){
				jsonObject = new JSONObject();
				jsonObject.put("CustId", 0);
				jsonObject.put("CustName", "LTSP");
				jsonArray.put(jsonObject);
			}
			while(rs.next()){
				jsonObject = new JSONObject();
				int custId=rs.getInt("CUSTOMER_ID");
				String custName=rs.getString("NAME");
				String status=rs.getString("STATUS");
				String activationstatus=rs.getString("ACTIVATION_STATUS");
				jsonObject.put("CustId", custId);
				jsonObject.put("CustName", custName);
				jsonObject.put("Status", status);
				jsonObject.put("ActivationStatus", activationstatus);
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

	public ArrayList<Object> getReconcelationReportDetails(int systemId,int customerId, int month, int year, int offset) {
		JSONArray JsonArray = null;
		JSONObject obj = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		int count = 0;
		ResultSet rs = null;
		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
		ArrayList<Object> finlist = new ArrayList<Object>();
		ArrayList<String> headersList = new ArrayList<String>();
		ArrayList<ReportHelper> reportsList = new ArrayList<ReportHelper>();
		ReportHelper finalreporthelper = new ReportHelper();
		Calendar aCalendar = Calendar.getInstance();
		// add -1 month to current month
		aCalendar.set(aCalendar.DATE,1);
		aCalendar.set(aCalendar.YEAR, year);
		aCalendar.set(aCalendar.MONTH, month);
		int daysQty = aCalendar.getActualMaximum(Calendar.DAY_OF_MONTH); 
		Date firstDateOfPreviousMonth = aCalendar.getTime();
		aCalendar.set(aCalendar.DATE, aCalendar.getActualMaximum(aCalendar.DAY_OF_MONTH));
		Date lastDateOfPreviousMonth = aCalendar.getTime();
		String startDate = formatter.format(firstDateOfPreviousMonth) + " 00:00:00";
		String endDate =  formatter.format(lastDateOfPreviousMonth) + " 23:59:59";
		try {

			headersList.add("SL No");
			headersList.add("Id ");
			headersList.add("Vehicle Number");
			headersList.add("Start Date");
			headersList.add("End Date");
			headersList.add("Number of Days");
	        headersList.add("Price Per Day");
	        headersList.add("Total Amount");
	        headersList.add("Inserted Date");

			JsonArray = new JSONArray();
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con
					.prepareStatement(SandMiningStatements.GET_RECONCILIATION_REPORT);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, customerId);
			pstmt.setString(3, startDate);
			pstmt.setString(4, endDate);
			pstmt.setInt(5, systemId);
			pstmt.setInt(6, customerId);
			pstmt.setString(7, startDate);
			pstmt.setString(8, endDate);
			
			rs = pstmt.executeQuery();
			while (rs.next()) {
				count++;
				obj = new JSONObject();
				ArrayList<Object> informationList = new ArrayList<Object>();
				ReportHelper reporthelper = new ReportHelper();

				obj.put("slnoIndex", count);
				informationList.add(count);

				obj.put("idIndex", rs.getString("ID"));
				informationList.add(rs.getString("ID"));

				obj.put("VehicleNoindex", rs.getString("VEHICLE_NO"));
				informationList.add(rs.getString("VEHICLE_NO"));

				if (rs.getString("START_DATE").contains("1900")|| rs.getString("START_DATE") == null|| rs.getString("START_DATE").equals("")) {
					obj.put("startDateindex", "");
					informationList.add("");
				} else {
					obj.put("startDateindex", rs.getTimestamp("START_DATE"));
					informationList.add(simpleDateFormatdd_MM_YY.format(rs.getTimestamp("START_DATE")));
				}
				if (rs.getString("END_DATE").contains("1900")|| rs.getString("END_DATE") == null|| rs.getString("END_DATE").equals("")) {
					obj.put("endDateindex", "");
					informationList.add("");
				} else {
					obj.put("endDateindex", rs.getTimestamp("END_DATE"));
					informationList.add(simpleDateFormatdd_MM_YY.format(rs.getTimestamp("END_DATE")));
				}
				
				obj.put("noOfDaysIndex", ""); //rs.getString("NO_OF_DAYS")
				informationList.add("");//rs.getString("NO_OF_DAYS")											
				
				obj.put("pricePerDayIndex", ""); //rs.getString("AMOUNT_PER_DAY")
				informationList.add("");//rs.getString("AMOUNT_PER_DAY")
				
				obj.put("totalAmountindex", rs.getString("TOTAL_AMOUNT")); //rs.getString("TOTAL_PRICE")
				informationList.add(rs.getString("TOTAL_AMOUNT"));//rs.getString("TOTAL_PRICE")
				
				if (rs.getString("START_DATE").contains("1900") || rs.getString("START_DATE")== null || rs.getString("START_DATE").equals("")) {
					obj.put("insertedDateindex", "");
					informationList.add("");
				}else{
					//obj.put("insertedDateindex", simpleDateFormatddMMYYYYDB1.format(rs.getTimestamp("INSERTED_DATE")));
					//informationList.add(simpleDateFormatddMMYYYYDB1.format(rs.getTimestamp("INSERTED_DATE")));
					obj.put("insertedDateindex", simpleDateFormatddMMYYYYDB1.format(rs.getTimestamp("START_DATE")));
					informationList.add(simpleDateFormatddMMYYYYDB1.format(rs.getTimestamp("START_DATE")));
				}

				JsonArray.put(obj);
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
	
	//***************************** sand mining general settings **********************************************//
	
	public JSONArray getSandMiningGeneralSettingsDetails(int systemId) {
		Connection con=null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		JSONArray JsonArray = null;
		JSONObject obj1 = null;
		int count=0;
		try {
			JsonArray = new JSONArray();
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(SandMiningStatements.GET_SAND_MINING_GENERAL_SETTING_DETAILS);
			pstmt.setInt(1, systemId);
			rs = pstmt.executeQuery();

			while (rs.next()) {
				count++;
				obj1 = new JSONObject();
				obj1.put("slnoIndex", count);
				obj1.put("ltspNameindex", rs.getString("SystemName"));
				obj1.put("clientindex", rs.getString("CustomerName"));
				obj1.put("nameindex", rs.getString("name"));
				obj1.put("valueindex", rs.getString("value"));
				JsonArray.put(obj1);
			} // end of while rs
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return JsonArray;
	}
	
	public String addSandMiningGeneralSettingsDetails(int systemId,String name,String value){
		Connection con=null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		JSONArray JsonArray = null;
		String message = "";

		try{	 
			JsonArray = new JSONArray();
			con = DBConnection.getConnectionToDB("AMS");	
			
			pstmt=con.prepareStatement(SandMiningStatements.CHECK_NAME_EXIST_IN_GENERAL_SETTING_DETAILS);
			pstmt.setInt(1, systemId);
			pstmt.setString(2, name);
			rs = pstmt.executeQuery();
			if(rs.next()){
				return " Name already exists for this LTSP";
			}
			
			pstmt=con.prepareStatement(SandMiningStatements.INSERT_SAND_MINING_GENERAL_SETTING_DETAILS);
			pstmt.setInt(1, systemId);
			pstmt.setString(2, name);	
			pstmt.setString(3, value);	
			int inserted = pstmt.executeUpdate();   		  
			if(inserted > 0){
				message = "Saved Successfully";
			}
		}catch(Exception e){
			System.out.println("Error when addSandMiningGeneralSettingsDetails.."+e);
		}
		finally{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return message;  			
	}
	
	public String modifySandMiningGeneralSettingsDetails(String buttonValue,int systemId,String name,String value,String gridNameIndex,String gridValueIndex){
		Connection con=null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		JSONArray JsonArray = null;
		String message = "";

		try{	 
			JsonArray = new JSONArray();
			con = DBConnection.getConnectionToDB("AMS");	
		
			if(buttonValue.equals("Modify")){
			pstmt=con.prepareStatement(SandMiningStatements.MODIFY_SAND_MINING_GENERAL_SETTING_DETAILS);
			pstmt.setString(1, name);	
			pstmt.setString(2, value);
			pstmt.setInt(3, systemId);
			pstmt.setString(4, gridNameIndex);
			pstmt.setString(5, gridValueIndex);
			int update = pstmt.executeUpdate();   		  
			if(update > 0){
				message = "Updated Successfully";
			}
		  }else if(buttonValue.equals("Delete")){
			  	pstmt=con.prepareStatement(SandMiningStatements.DELETE_SAND_MINING_GENERAL_SETTING_DETAILS);
				pstmt.setInt(1, systemId);
				pstmt.setString(2, gridNameIndex);
				pstmt.setString(3, gridValueIndex);
				int update = pstmt.executeUpdate();   		  
				if(update > 0){
					message = "Deleted Successfully";
				}
			  
		  }
		}catch(Exception e){
			System.out.println("Error when modifySandMiningGeneralSettingsDetails.."+e);
		}
		finally{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return message;  			
	}
	
	public ArrayList<Object> getVehicleSubscriptionReport(int systemId,int customerId, String startDate, String endDate,int offset) {
		JSONArray JsonArray = null;
		JSONObject obj = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		int count = 0;
		ResultSet rs = null;

		ArrayList<Object> finlist = new ArrayList<Object>();
		ArrayList<String> headersList = new ArrayList<String>();
		ArrayList<ReportHelper> reportsList = new ArrayList<ReportHelper>();
		ReportHelper finalreporthelper = new ReportHelper();

		try {

			headersList.add("SL No");
			headersList.add("Id ");
			headersList.add("Vehicle No");
			headersList.add("Start Date");
			headersList.add("End Date");
			headersList.add("Mode Of Payment");
	        headersList.add("DD NO");
	        headersList.add("DD Date");
	        headersList.add("Bank Name");
	        headersList.add("Total Amount");
	        headersList.add("Remainder Date");
	        headersList.add("Subscription Duration");
	        headersList.add("Vehicle Status");
	        headersList.add("Inserted By");
	        headersList.add("Inserted Date");
	        headersList.add("Updated By");
	        headersList.add("Updated Date");
	        headersList.add("Subscription Status");
	        headersList.add("Billing Status");
	        
			JsonArray = new JSONArray();
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con
					.prepareStatement(SandMiningStatements.GET_INACTIVE_VEHICLE_SUBSCRIPTION_DETAILS_REPORT);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, customerId);
			/*pstmt.setInt(3, offset);
			pstmt.setString(4, startDate);
			pstmt.setInt(5, offset);
			pstmt.setString(6, endDate);  */
			
			rs = pstmt.executeQuery();
			while (rs.next()) {
				count++;
				obj = new JSONObject();
				ArrayList<Object> informationList = new ArrayList<Object>();
				ReportHelper reporthelper = new ReportHelper();

				obj.put("slNoIndex", count);
				informationList.add(count);

				obj.put("idIndex", rs.getString("ID"));
				informationList.add(rs.getString("ID"));

				obj.put("vehicleNoIndex", rs.getString("VEHICLE_NO"));
				informationList.add(rs.getString("VEHICLE_NO"));

				if (rs.getString("START_DATE").contains("1900")|| rs.getString("START_DATE") == null|| rs.getString("START_DATE").equals("")) {
					obj.put("startDateIndex", "");
					informationList.add("");
				} else {
					obj.put("startDateIndex", rs.getTimestamp("START_DATE"));
					informationList.add(simpleDateFormatdd_MM_YY.format(rs.getTimestamp("START_DATE")));
				}
				if (rs.getString("END_DATE").contains("1900")|| rs.getString("END_DATE") == null|| rs.getString("END_DATE").equals("")) {
					obj.put("endDateIndex", "");
					informationList.add("");
				} else {
					obj.put("endDateIndex", rs.getTimestamp("END_DATE"));
					informationList.add(simpleDateFormatdd_MM_YY.format(rs.getTimestamp("END_DATE")));
				}
				obj.put("modeOfPaymentIndex", rs.getString("MODE_OF_PAYMENT"));
				informationList.add(rs.getString("MODE_OF_PAYMENT"));
				
				obj.put("ddNoIndex", rs.getString("DD_NO"));
				informationList.add(rs.getString("DD_NO"));
				
				obj.put("ddDateIndex", rs.getString("DD_DATE"));
				informationList.add(rs.getString("DD_DATE"));
				
				obj.put("bankNameIndex", rs.getString("BANK_NAME"));
				informationList.add(rs.getString("BANK_NAME"));
											
				obj.put("totalAmountIndex", rs.getString("TOTAL_AMOUNT"));
				informationList.add(rs.getString("TOTAL_AMOUNT"));
				
				if (rs.getString("REMAINDER_DATE").contains("1900") || rs.getString("REMAINDER_DATE")== null || rs.getString("REMAINDER_DATE").equals("")) {
					obj.put("remainderDateIndex", "");
					informationList.add("");
				}else{
					obj.put("remainderDateIndex", simpleDateFormatdd_MM_YY.format(rs.getTimestamp("REMAINDER_DATE")));
					informationList.add(simpleDateFormatdd_MM_YY.format(rs.getTimestamp("REMAINDER_DATE")));
				}
				
				obj.put("subscriptionDurIndex", rs.getString("SUBSCRIPTION_DURATION"));
				informationList.add(rs.getString("SUBSCRIPTION_DURATION"));
				
				obj.put("vehicleStatusIndex", rs.getString("VEHICLE_STATUS"));
				informationList.add(rs.getString("VEHICLE_STATUS"));
				
				obj.put("insertedByIndex", rs.getString("INSERTED_BY"));
				informationList.add(rs.getString("INSERTED_BY"));
				
				if (rs.getString("INSERTED_DATETIME").contains("1900")|| rs.getString("INSERTED_DATETIME") == null|| rs.getString("INSERTED_DATETIME").equals("")) {
					obj.put("insertedDateTimeIndex", "");
					informationList.add("");
				} else {
					obj.put("insertedDateTimeIndex", rs.getTimestamp("INSERTED_DATETIME"));
					informationList.add(simpleDateFormatdd_MM_YY.format(rs.getTimestamp("INSERTED_DATETIME")));
				}
				
				obj.put("updatedByIndex", rs.getString("UPDATED_BY"));
				informationList.add(rs.getString("UPDATED_BY"));
				
				if (rs.getString("UPDATED_DATETIME").contains("1900")|| rs.getString("UPDATED_DATETIME") == null|| rs.getString("UPDATED_DATETIME").equals("")) {
					obj.put("updatedDateIndex", "");
					informationList.add("");
				} else {
					obj.put("updatedDateIndex", rs.getTimestamp("UPDATED_DATETIME"));
					informationList.add(simpleDateFormatdd_MM_YY.format(rs.getTimestamp("UPDATED_DATETIME")));
				}
				
				obj.put("subscriptionStatusIndex", rs.getString("SUBSCRIPTION_STATUS"));
				informationList.add(rs.getString("SUBSCRIPTION_STATUS"));
				
				obj.put("billingStatusIndex", rs.getString("BILLING_STATUS"));
				informationList.add(rs.getString("BILLING_STATUS"));
								
				JsonArray.put(obj);
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


	public String getVehicleSubscriptionDelete(String startdate, String enddate, String vehicleNo) {
		Connection con = null;
		PreparedStatement pstmt = null;
		String message = "";
		String startDate = "";
		String endDate = "";
		SimpleDateFormat sdfDB = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
		
		try {
			startDate =  sdfDB.format(sdf.parse(startdate));
			endDate  =  sdfDB.format(sdf.parse(enddate));
			con = DBConnection.getConnectionToDB("AMS");
			
			pstmt = con.prepareStatement(" delete  AMS.dbo.VEHICLE_SUBSCRIPTION_DETAILS where START_DATE LIKE ? AND END_DATE LIKE ?  AND VEHICLE_NO= ? ");
			pstmt.setString(1, startdate);
			pstmt.setString(2, enddate);
			pstmt.setString(3, vehicleNo);
		
			int i = pstmt.executeUpdate();
			if (i > 0) {
				 message =" Deleted Succesfully ";
			}
		} catch (Exception e) {
			e.printStackTrace();
			
			message = "Error the deleting the record";
					
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, null);
		}
		return message;
	}

		
}
