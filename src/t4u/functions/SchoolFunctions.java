package t4u.functions;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;

import org.json.JSONArray;
import org.json.JSONObject;

import t4u.beans.ReportHelper;
import t4u.beans.SendSchoolStudentDetailsBean;
import t4u.common.DBConnection;
import t4u.statements.SchoolStatments;

public class SchoolFunctions {
	String message="";
	CommonFunctions cf=new CommonFunctions();
	public  ArrayList < Object > getSchoolType(int systemId,int customerId) {
		PreparedStatement pstmt = null;
		JSONArray JsonArray = new JSONArray();
		JSONObject JsonObject = null;
		Connection con = null;
		ResultSet rs = null;
		ArrayList < Object > aslist = new ArrayList < Object > ();
		try {
			int count=0;
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(SchoolStatments.GET_SCHOOLTYPE);
			pstmt.setInt(1,systemId);
			pstmt.setInt(2, customerId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				JsonObject = new JSONObject();
				ArrayList < Object > getList = new ArrayList < Object > ();
				count++;
				getList.add(count);
				JsonObject.put("slnoIndex", count);
				JsonObject.put("schooltype", rs.getString("SCHOOL_TYPE").toUpperCase());
				getList.add(rs.getString("SCHOOL_TYPE").toUpperCase());
				JsonArray.put(JsonObject);
			}
			aslist.add(JsonArray);
		}catch (Exception e) {
		}finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return aslist;
	}
	public  ArrayList < Object > getRouteDetails(int systemId,int customerId) {
		PreparedStatement pstmt = null;
		JSONArray JsonArray = new JSONArray();
		JSONObject JsonObject = null;
		Connection con = null;
		ResultSet rs = null;
		ArrayList < Object > alist = new ArrayList < Object > ();
		try {
			int count=0;
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(SchoolStatments.GET_ROUTE);
			pstmt.setInt(1,systemId);
			pstmt.setInt(2, customerId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				JsonObject = new JSONObject();
				ArrayList < Object > getRoutrList = new ArrayList < Object > ();
				count++;
				getRoutrList.add(count);
				JsonObject.put("slnoIndex", count);
				JsonObject.put("route", rs.getString("ROUTE"));
				getRoutrList.add(rs.getString("ROUTE"));
				JsonArray.put(JsonObject);
			}
			alist.add(JsonArray);
		}catch (Exception e) {
		}finally {

			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return alist;
	}

	public synchronized String submitDetails(JSONArray firstGridData,JSONArray secondGridData,String textmessage,String[] ManualPhoneNO,int systemId,int custid,String isdCodes) {
		JSONArray jsonArray;
		JSONObject jsonObject;
		String status="N";
		//System.out.println("------------------>"+ManualPhoneNO.length);

		SendSchoolStudentDetailsBean sd=null;
		try {
			jsonArray = new JSONArray();
			jsonObject = new JSONObject();
			String schoolType = "";
			String route="";
			for (int i = 0; i < firstGridData.length(); i++) {
				JSONObject obj = firstGridData.getJSONObject(i);
				schoolType = schoolType+",'"+obj.getString("schooltype")+"'";
			}
			for (int i = 0; i < secondGridData.length(); i++) {
				JSONObject obj = secondGridData.getJSONObject(i);
				route=route+",'"+obj.getString("route")+"'";
			}
			if (schoolType.length()>0) {
				schoolType = schoolType.substring(1,schoolType.length());
				//System.out.println(schoolType);
			}
			if (route.length()>0) {
				route = route.substring(1,route.length());
				//System.out.println(route);
			}
			int SMSVolume = 0;
			int SMSUsed = 0;

			ArrayList<SendSchoolStudentDetailsBean> studentList =getStudentDetails(schoolType,route,systemId,custid);
			ArrayList<Integer> smsvolume=getSmsVolume(custid);
			if(smsvolume.size() > 0)
			{
				SMSVolume=smsvolume.get(0);
				SMSUsed=smsvolume.get(1);
			}

			int TotalSms = SMSVolume;
			String MobileNumberManual = null;
			if (TotalSms>=studentList.size()) {
				for (int i = 0; i < studentList.size(); i++) {
					sd=studentList.get(i);
					String Message=textmessage;
					String mobileNo=sd.getMobile();
					//System.out.println(" mobileNo;"+mobileNo);
					sendSchoolSmsDetailsInsert(mobileNo,Message,status,systemId,custid);
				}
				for (int i = 0; i < ManualPhoneNO.length; i++) {
					MobileNumberManual=isdCodes+ManualPhoneNO[i];
					String Message=textmessage;
					//System.out.println("mobileNo;"+mobileNo);
					if(!MobileNumberManual.equals("")){
						sendSchoolSmsDetailsInsert(MobileNumberManual,Message,status,systemId,custid);
						//System.out.println("mobileNo;"+MobileNumberManual);
					}
				}

			}else {
				message="SMS Not Available , Volume Available : "+TotalSms+ ".";
				//System.out.println(message);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return message;
	}

	public ArrayList<SendSchoolStudentDetailsBean> getStudentDetails(String schoolType, String route, int systemId, int custid) {
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		ArrayList<SendSchoolStudentDetailsBean> list = new ArrayList<SendSchoolStudentDetailsBean>();
		Connection con=null;
		try {
			con = DBConnection.getConnectionToDB("AMS");
			String stmt = SchoolStatments.GET_SCHOOL_STUDENT_DETAILS;
			stmt =stmt.replace("#", schoolType.toLowerCase());
			stmt = stmt.replace("$", route);
			pstmt = con.prepareStatement(stmt);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, custid);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				SendSchoolStudentDetailsBean vd = new SendSchoolStudentDetailsBean();
				vd.setMobile(rs.getString("MOBILE"));
				list.add(vd);
			}
		}catch (Exception e) {
			e.printStackTrace();
		}
		finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		//System.out.println(list.size());
		return list;
	}

	public synchronized String 	sendSchoolSmsDetailsInsert(String mobileNo, String Message, String status, int systemId, int custid){
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		try {
			int Insertcount = 0;
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(SchoolStatments.SCHOOL_SUBMIT_DETAILS_INSERT_INTO_SEND_SMS);
			pstmt.setString(1,mobileNo);
			pstmt.setString(2,Message);
			pstmt.setString(3, status);
			pstmt.setInt(4, custid);
			pstmt.setInt(5, systemId);
			Insertcount = pstmt.executeUpdate();
			if (Insertcount == 1) {
				message = "<p>SMS Sent successfully....</p>";
				//System.out.println(message);
			}else {
				message = "<p>There is no Mobile no for this route.</p>";
			}
		}catch (Exception e) {
			message = "<p  >Error While Adding School Details and the Error is "
				+ e.toString() + "</p>";
			System.out.println("Error in Submit DetailsInsert method..." + e);
			e.printStackTrace();
		}finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return message;
	}

	public ArrayList<Integer> getSmsVolume(int custid){
		int smsVolume;
		int smsUsed;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Connection con=null;
		ArrayList<Integer>smslist=new ArrayList<Integer>();
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(SchoolStatments.CHECK_MESSAGE_VOLUME);
			pstmt.setInt(1,custid);
			rs=pstmt.executeQuery();
			while (rs.next()) {
				smsVolume=rs.getInt("SMS_VOLUME");
				smsUsed=rs.getInt("SMS_USED");
				smslist.add(smsVolume);
				smslist.add(smsUsed);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}finally{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return smslist;
	}
	public JSONArray getCountryList() {
		Connection conAdmin = null;
		PreparedStatement pstmt = null;
		Connection con = null;
		ResultSet rs = null;
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject = new JSONObject();
		try {
			conAdmin = DBConnection.getConnectionToDB("ADMINISTRATOR");
			pstmt = conAdmin.prepareStatement(SchoolStatments.Get_COUNTRY_LIST);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				jsonObject = new JSONObject();
				jsonObject.put("ISD_CODE", rs.getString("ISD_CODE"));
				jsonObject.put("CountryName", rs.getString("COUNTRY_NAME"));
				jsonArray.put(jsonObject);
			}

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(conAdmin, pstmt, rs);
		}
		return jsonArray;
	}

	public JSONArray getSmsSizeCount(int systemId, int customerId) {
		JSONArray jsonArray = null;
		JSONObject jsonObject = null;
		Connection connection = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		try {
			int totalSmsCount = 0;
			jsonArray = new JSONArray();
			connection = DBConnection.getConnectionToDB("AMS");
			try {
				pstmt = connection.prepareStatement(SchoolStatments.GET_TOTAL_SMS_COUNT);
				pstmt.setInt(1, customerId);
				rs = pstmt.executeQuery();
				if (rs.next()) {
					totalSmsCount = rs.getInt("TOTAL_SMS_SIZE");
					System.out.println("totalSmsCount"+totalSmsCount);

				}
				rs.close();
			} catch (Exception e) {
				e.printStackTrace();
			}
			jsonObject = new JSONObject();
			jsonObject.put("totalSmsCount", totalSmsCount);
			jsonArray.put(jsonObject);

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(connection, pstmt, rs);
		}
		return jsonArray;

	}	
	public JSONArray getStudentSizeCount(JSONArray firstGridData,JSONArray secondGridData,String[] mobileManual,int systemId, int customerId,String isdCodes) {
		JSONArray jsonArray = null;
		JSONObject jsonObject = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String MobileNoManual=null;
		try {
			int ManualMobCount=0;
			int totalStudentCount = 0;
			jsonArray = new JSONArray();
			jsonObject = new JSONObject();
			String schoolType = "";
			String route="";
			for (int i = 0; i < firstGridData.length(); i++) {
				JSONObject obj = firstGridData.getJSONObject(i);
				schoolType = schoolType+",'"+obj.getString("schooltype")+"'";
			}
			for (int i = 0; i < secondGridData.length(); i++) {
				JSONObject obj = secondGridData.getJSONObject(i);
				route=route+",'"+obj.getString("route")+"'";
			}
			if (schoolType.length()>0) {
				schoolType = schoolType.substring(1,schoolType.length());				
				//System.out.println(schoolType);
			}
			if (route.length()>0) {
				route = route.substring(1,route.length());
				//System.out.println(route);
			}
			for (int i = 0; i < mobileManual.length; i++) {
				MobileNoManual=mobileManual[i];
				if(!MobileNoManual.equals("")&&MobileNoManual!=null)
					ManualMobCount=mobileManual.length;
			}
			con = DBConnection.getConnectionToDB("AMS");
			try {
				String stmt = SchoolStatments.GET_TOTAL_STUDENTS;
				stmt =stmt.replace("@", schoolType.toLowerCase());
				stmt = stmt.replace("%", route);
				pstmt = con.prepareStatement(stmt);
				pstmt.setInt(1, systemId);
				pstmt.setInt(2, customerId);
				rs = pstmt.executeQuery();
				if (rs.next()) {
					totalStudentCount=(rs.getInt("STUDENT_COUNT") + ManualMobCount);
					System.out.println("totalStudentCount"+totalStudentCount);
				}
				rs.close();
			} catch (Exception e) {
				e.printStackTrace();
			}

			schoolType = schoolType.replace("'", "");
			route=route.replace("'","");
			jsonObject = new JSONObject();
			jsonObject.put("totalStudentCount", totalStudentCount);
			jsonObject.put("schoolType", schoolType);
			jsonObject.put("route", route);
			jsonArray.put(jsonObject);

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jsonArray;

	}

	/******************************************************************SchoolRouteAllocationDetails***********************************************/	
	public ArrayList < Object > getRouteAllocationDetails(int systemId,int customerId,String language) {
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject = null;
		Connection con = null;
		PreparedStatement pstmt2 = null;
		ResultSet rs2 = null;

		ArrayList < ReportHelper > reportsList = new ArrayList < ReportHelper > ();
		ArrayList < String > headersList = new ArrayList < String > ();
		ReportHelper finalreporthelper = new ReportHelper();
		ArrayList < Object > aslist = new ArrayList < Object > ();

		headersList.add(cf.getLabelFromDB("SLNO", language));
		headersList.add(cf.getLabelFromDB("Route_Code", language));
		headersList.add(cf.getLabelFromDB("Start_Time", language));
		headersList.add(cf.getLabelFromDB("Asset_Number", language));
		headersList.add(cf.getLabelFromDB("Type", language));

		try {
			int countNO = 0;
			con = DBConnection.getConnectionToDB("AMS");
			pstmt2 = con.prepareStatement(SchoolStatments.GET_ALL_ROUTE_ALLOCATION_DETAILS);
			pstmt2.setInt(1, systemId);
			pstmt2.setInt(2, customerId);
			rs2 = pstmt2.executeQuery();
			while (rs2.next()) {
				jsonObject = new JSONObject();
				ArrayList < Object > informationList = new ArrayList < Object > ();
				countNO++;
				ReportHelper reporthelper = new ReportHelper();
				String route=rs2.getString("ROUTE");
				String startTime=rs2.getString("START_TIME");
				String assetNumber=rs2.getString("ASSET_NUMBER");
				String type= rs2.getString("TYPE");
				int Id=rs2.getInt("ID");

				jsonObject.put("slnoDataIndex",countNO);
				informationList.add(countNO);

				jsonObject.put("routeDataIndex",route);
				informationList.add(route);

				jsonObject.put("startTimeDataIndex",startTime );
				informationList.add(startTime);

				jsonObject.put("assetNumberDataIndex", assetNumber);
				informationList.add(assetNumber);

				jsonObject.put("DropTypeDataIndex",type);
				informationList.add(type);

				jsonObject.put("IdDataIndex",Id);

				jsonArray.put(jsonObject);
				reporthelper.setInformationList(informationList);
				reportsList.add(reporthelper);
			}
			aslist.add(jsonArray);
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

	public JSONArray getAssetNumberList(int systemId,int customerId) {
		PreparedStatement pstmt = null;
		Connection con = null;
		ResultSet rs = null;
		JSONArray jsonArray = new JSONArray();
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(SchoolStatments.Get_ASSET_NUMBER_LIST);
			pstmt.setInt(1,systemId);
			pstmt.setInt(2,customerId);
			rs = pstmt.executeQuery();
			JSONObject jsonObject = new JSONObject();
			jsonObject.put("AssetNumber", "NONE");
			jsonArray.put(jsonObject);
			while (rs.next()) {
				jsonObject = new JSONObject();
				jsonObject.put("AssetNumber", rs.getString("ASSET_NUMBER"));
				jsonArray.put(jsonObject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jsonArray;
	}

	public String RouteAllocationDetailsInsert(String Route, String StartTime, String assetNumber, String DropType,int systemId,int customerId,String UniqueId){
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs3 = null;
		DateFormat df = new SimpleDateFormat("HH:mm");
		Date startTime;
		Date beforeTime;
		Date afterTime;
		String startTimeBefore;
		boolean alereadyExists = false;
		String startTimeAfter;
		try {
			startTime = df.parse(StartTime);
			Long Btime = startTime.getTime();
			Btime -=(2*60*60*1000);

			beforeTime = new Date(Btime);
			Long Atime=startTime.getTime();
			Atime +=(2*60*60*1000);
			afterTime = new Date(Atime);

			startTimeBefore=df.format(beforeTime);
			startTimeAfter=df.format(afterTime);
			String StartedTime=df.format(startTime);

			System.out.println(startTimeBefore);
			System.out.println(startTimeAfter);
			int Insertcount = 0;
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(SchoolStatments.SELECT_START_TIME_VALIDATE);
			//pstmt.setString(1,Route);
			pstmt.setString(1,startTimeBefore);
			pstmt.setString(2,startTimeAfter);
			pstmt.setString(3,assetNumber);
			pstmt.setInt(4, systemId);
			pstmt.setInt(5, customerId);
			rs3 = pstmt.executeQuery();
			if (rs3.next()) {
				alereadyExists = true;	
			}
			if(!alereadyExists)
			{
				String startTimes=df.format(startTime);
				pstmt = con.prepareStatement(SchoolStatments.ROUTE_ALLOCATION_INSERT);
				pstmt.setString(1, Route);
				pstmt.setString(2, startTimes);
				pstmt.setString(3, assetNumber);
				pstmt.setInt(4, systemId);
				pstmt.setInt(5,customerId);
				pstmt.setString(6, DropType);
				Insertcount = pstmt.executeUpdate();
				if (Insertcount > 0) {
					message = "<p>Route " + Route+ " added successfully..</p>";
				}
			}else{
				message = "<p>Vehicle  " + assetNumber + "  Already Allocated for Selected Start Time "+ StartedTime + ".</p>";
			}

		} catch (Exception e) {
			message = "<p  >Error While Adding Route and the Error is "
				+ e.toString() + "</p>";
			System.out.println("Error in RoueAllocationDetailsInsert method..." + e);
			e.printStackTrace();
		}finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs3);
		}
		return message;
	}

	public String RouteAllocationDetailsUpdate(String Route, String gridRoute,String gridAssetNumber,String DropTypeGrid,String StartTime, String assetNumber, String DropType,int systemId,int customerId,String UniqueId) {
		int updatecount = 0;
		Connection con = null;
		PreparedStatement pstmt4 = null;
		boolean alreadyExists = false;
		ResultSet rs4 = null;
		DateFormat df = new SimpleDateFormat("HH:mm");
		Date startTime;
		Date beforeTime;
		Date afterTime;
		String startTimeBefore;
		String startTimeAfter;
		String prevRouteId = "";

		try {
			startTime = df.parse(StartTime);

			Long Btime = startTime.getTime();
			Btime -=(2*60*60*1000);
			beforeTime = new Date(Btime);

			Long Atime=startTime.getTime();
			Atime +=(2*60*60*1000);
			afterTime = new Date(Atime);


			startTimeBefore=df.format(beforeTime);
			startTimeAfter=df.format(afterTime);
			String StartedTime=df.format(startTime);

			System.out.println(startTimeBefore);
			System.out.println(startTimeAfter);

			con = DBConnection.getConnectionToDB("AMS");
			pstmt4 = con.prepareStatement(SchoolStatments.SELECT_START_TIME_VALIDATE_IN_UPDATE);
			//	pstmt4.setString(1,Route);
			pstmt4.setString(1,startTimeBefore);
			pstmt4.setString(2,startTimeAfter);
			pstmt4.setString(3,assetNumber);
			pstmt4.setInt(4, systemId);
			pstmt4.setInt(5, customerId);
			pstmt4.setInt(6, Integer.parseInt(UniqueId));
			rs4 = pstmt4.executeQuery();
			if (rs4.next()) {				
				alreadyExists = true;
			}
			if (!Route.equals(gridRoute)) {
				prevRouteId = gridRoute;
			}
			if(!alreadyExists){
				//System.out.println("------------"+Route);
				//System.out.println("------------->"+gridRoute+"assetNumber"+assetNumber);
				String startTimes=df.format(startTime);
				pstmt4 = con.prepareStatement(SchoolStatments.UPDATE_ROUTE_ALLOCATION_DETAILS);
				pstmt4.setString(1, Route);
				pstmt4.setString(2, startTimes);
				pstmt4.setString(3, assetNumber);
				pstmt4.setString(4, DropType);
				pstmt4.setInt(5,systemId);
				pstmt4.setInt(6, customerId);
				pstmt4.setInt(7, Integer.parseInt(UniqueId));
				updatecount = pstmt4.executeUpdate();
				con.commit();
				if (updatecount == 1) {
					//System.out.println("-----upcount1-------"+Route);
					//System.out.println("-----upcount1-------->"+gridRoute);
					if (!Route.equals(gridRoute)) {
						pstmt4 = con.prepareStatement(SchoolStatments.UPDATE_ROUTE_STUDENT_DETAILS_FOR_ROUTE);
						pstmt4.setString(1, Route);
						pstmt4.setString(2, prevRouteId);
						pstmt4.setString(3, DropType);
						pstmt4.setInt(4,systemId);
						pstmt4.setInt(5, customerId);
						updatecount = pstmt4.executeUpdate();
					}
					message = "<p>Route " + Route + " updated successfully.</p>";
				}
			}else{
				message = "<p>Vehicle  " + assetNumber + "  Already Allocated for Selected Start Time "+ StartedTime + ".</p>";
			}
		} catch (Exception e) {
			message = "<p  >Error While Updating Route and the Error is "
				+ e.toString() + "</p>";
			System.out.println("Error in RoueAllocationDetailsUpdate method..  " + e);
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt4, rs4);
		}
		return message;
	}	
	public String deleteRoueAllocationDetails(String Route,String type,int uniqueId,int customerId,int systemId){
		Connection con=null;
		PreparedStatement pstmt=null;
		int deleted=0;
		try{
			con=DBConnection.getConnectionToDB("AMS");
			pstmt=con.prepareStatement(SchoolStatments.DELETE_ROUTE_ALLOCATION_DETAILS);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, customerId);
			pstmt.setInt(3, uniqueId);
			deleted=pstmt.executeUpdate();
			if(deleted>0)
			{ 
				try { 
					pstmt=con.prepareStatement(SchoolStatments.UPDATE_ROUTE_STUDENT_DETAILS);
					pstmt.setString(1,Route);
					//pstmt.setString(2,type);
					pstmt.setInt(2, systemId);
					pstmt.setInt(3, customerId);
					deleted=pstmt.executeUpdate();
				} catch (Exception e) {
					e.printStackTrace();
				}
				message="Route Allocation Information "+ Route +" Deleted Successfully";
			}else{
				message="Error";
			}

		}catch(Exception e){
			System.out.println("Error In deleteRoueAllocationDetails --- "+e.toString());
			e.printStackTrace();
		}finally {
			DBConnection.releaseConnectionToDB(con, pstmt, null);
		}
		return message;
	}

	/*******************************************Route student Details**************************************************/
	/**
	 * @author Santhosh.
	 */
	/****************************************************************************************************************/
	//--------------------Added for RoutestudentDetails 1.GRID-----------------------------//
	public ArrayList < Object > getRouteStudentDetails(int systemId,int customerId,String language,int branchId) {
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject = null;
		Connection con = null;
		PreparedStatement pstmt2 = null;
		ResultSet rs2 = null;
		PreparedStatement pstmt5 = null;
		ResultSet rs5 = null;

		ArrayList < ReportHelper > reportsList = new ArrayList < ReportHelper > ();
		ArrayList < String > headersList = new ArrayList < String > ();
		ReportHelper finalreporthelper = new ReportHelper();
		ArrayList < Object > finlist = new ArrayList < Object > ();

		headersList.add(cf.getLabelFromDB("SLNO", language));
		headersList.add(cf.getLabelFromDB("Student_Name", language));
		headersList.add(cf.getLabelFromDB("Standard", language));
		headersList.add(cf.getLabelFromDB("Section", language));
		headersList.add(cf.getLabelFromDB("Parent_Name", language));
		headersList.add(cf.getLabelFromDB("Parent_Mobile", language));
		headersList.add(cf.getLabelFromDB("Country_Code", language));
		headersList.add(cf.getLabelFromDB("Email_ID", language));
		headersList.add(cf.getLabelFromDB("Latitude", language));
		headersList.add(cf.getLabelFromDB("Longitude", language));
		headersList.add(cf.getLabelFromDB("Radius", language));
		headersList.add(cf.getLabelFromDB("PickUp_Route_No", language));
		headersList.add(cf.getLabelFromDB("Drop_Route_No", language));
		headersList.add(cf.getLabelFromDB("Branch_Name", language));
		try {
			int countNO = 0;
			con = DBConnection.getConnectionToDB("AMS");
			if (branchId==0) {
				pstmt2 = con.prepareStatement(SchoolStatments.GET_ALL_ROUTE_STUDENT_DETAILS);
				pstmt2.setInt(1, systemId);
				pstmt2.setInt(2, customerId);
			} else {
				pstmt2 = con.prepareStatement(SchoolStatments.GET_ALL_ROUTE_STUDENT_DETAILS1);
				pstmt2.setInt(1, systemId);
				pstmt2.setInt(2, customerId);
				pstmt2.setInt(3, branchId);
			}
			rs2 = pstmt2.executeQuery();
			while (rs2.next()) {
				jsonObject = new JSONObject();
				ArrayList < Object > informationList = new ArrayList < Object > ();
				countNO++;
				ReportHelper reporthelper = new ReportHelper();
				String studentName=rs2.getString("STUDENT_NAME");
				String standard=rs2.getString("STANDARD");
				String Section=rs2.getString("SECTION");
				String parentName=rs2.getString("PARENT_NAME");
				String parentMobile=rs2.getString("PARENT_MOBILE");
				int countryCode =rs2.getInt("COUNTRY_CODE");
				String emailId=rs2.getString("EMAIL_ID");
				double latitude=rs2.getDouble("LATITUDE");
				double longitude=rs2.getDouble("LONGITUDE");;
				String radius=rs2.getString("RADIUS");
				String branchName=rs2.getString("BRANCH_NAME");
				String BranchId=rs2.getString("BRANCH_ID");

				//System.out.println("-------------------------------------------------->"+branchName+"---"+BranchId);
				String Id = "";
				String Id2 = "";

				jsonObject.put("slnoDataIndex",countNO);
				informationList.add(countNO);

				jsonObject.put("StudentNameDataIndex",studentName);
				informationList.add(studentName);

				jsonObject.put("StandardDataIndex",standard.toUpperCase());
				informationList.add(standard.toUpperCase());

				jsonObject.put("SectionDataIndex", Section.toUpperCase());
				informationList.add(Section.toUpperCase());

				jsonObject.put("ParentNameDataIndex", parentName);
				informationList.add(parentName);

				jsonObject.put("ParentMobileDataIndex",parentMobile);
				informationList.add(parentMobile);

				jsonObject.put("CountryCodeDataIndex",countryCode);
				informationList.add(countryCode);

				jsonObject.put("EmailIdDataIndex",emailId);
				informationList.add(emailId); 

				jsonObject.put("LatitudeDataIndex",latitude);
				informationList.add(latitude);

				jsonObject.put("LongitudeDataIndex",longitude);
				informationList.add(longitude);

				jsonObject.put("RadiusDataIndex",radius);
				informationList.add(radius);

				jsonObject.put("branchDataIndex",branchName);

				jsonObject.put("branchIdDataIndex",BranchId);

				String PickUp="";
				String Drop="";
				pstmt5 = con.prepareStatement(SchoolStatments.GET_STUDENTS_ROUTE_AND_TYPE_GRID);
				pstmt5.setString(1, studentName);
				pstmt5.setString(2, parentMobile);
				//pstmt5.setString(3, standard);
				pstmt5.setInt(3, systemId);
				pstmt5.setInt(4, customerId);
				rs5 = pstmt5.executeQuery();
				while(rs5.next()) {
					String Route=rs5.getString("ROUTE_NO");
					String Type=rs5.getString("TYPE");
					if (Type.equals("pickup")) {
						PickUp=Route;
						Id=rs5.getString("ID");
						jsonObject.put("pickupIdDataIndex",Id);
						jsonObject.put("PickupCodeDataIndex",PickUp);
					}	
					if (Type.equals("drop")) {
						Drop=Route;
						Id2=rs5.getString("ID");
						jsonObject.put("dropIdDataIndex",Id2);
						jsonObject.put("DropTypeDataIndex",Drop);
					}

				} 
				informationList.add(PickUp);
				informationList.add(Drop);
				informationList.add(branchName);
				jsonArray.put(jsonObject);
				reporthelper.setInformationList(informationList);
				reportsList.add(reporthelper);
			}
			finlist.add(jsonArray);
			finalreporthelper.setReportsList(reportsList);
			finalreporthelper.setHeadersList(headersList);
			finlist.add(finalreporthelper);
		} catch (Exception e) {
			e.printStackTrace();
		}finally {
			DBConnection.releaseConnectionToDB(con, pstmt2, rs2);
			DBConnection.releaseConnectionToDB(null, pstmt5, rs5);
		}
		return finlist;
	}
	//------------------------------------get Pick UpCode-----------------------------------//
	public JSONArray getPickUpCode(int systemId,int customerId) {
		PreparedStatement pstmt = null;
		Connection con = null;
		ResultSet rs = null;
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject = new JSONObject();
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(SchoolStatments.GET_PICKUP_CODE);
			pstmt.setInt(1,systemId);
			pstmt.setInt(2,customerId);
			rs = pstmt.executeQuery();	
			while (rs.next()) {
				jsonObject = new JSONObject();
				jsonObject.put("ROUTE_NO", rs.getString("ROUTE_NO"));
				jsonArray.put(jsonObject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jsonArray;
	}

	public JSONArray getDropcode(int systemId,int customerId) {
		PreparedStatement pstmt = null;
		Connection con = null;
		ResultSet rs = null;
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject = new JSONObject();
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(SchoolStatments.GET_DROP_CODE);
			pstmt.setInt(1,systemId);
			pstmt.setInt(2,customerId);
			rs = pstmt.executeQuery();	
			while (rs.next()) {
				jsonObject = new JSONObject();
				jsonObject.put("ROUTE_NO", rs.getString("ROUTE_NO"));
				jsonArray.put(jsonObject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jsonArray;
	}
	public JSONArray getStandardList(int systemId,int customerId) {
		PreparedStatement pstmt = null;
		Connection con = null;
		ResultSet rs = null;
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject = new JSONObject();
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(SchoolStatments.GET_STANDARD_LIST_FROM_CLASS_MASTER);
			pstmt.setInt(1,systemId);
			pstmt.setInt(2,customerId);
			rs = pstmt.executeQuery();	
			while (rs.next()) {
				jsonObject = new JSONObject();
				jsonObject.put("STANDARD", rs.getString("STANDARD").toUpperCase());
				jsonArray.put(jsonObject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jsonArray;
	}
	//--------------------Added for RoutestudentDetails 1.BRANCHLIST COMBO FOR MAIN-----------------------------//
	public JSONArray getBranchList(int systemId,int customerId) {
		PreparedStatement pstmt = null;
		Connection con = null;
		ResultSet rs = null;
		JSONArray jsonArray = new JSONArray();
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(SchoolStatments.GET_BRANCH_LIST);
			pstmt.setInt(1,systemId);
			pstmt.setInt(2,customerId);
			rs = pstmt.executeQuery();	
			JSONObject jsonObject = new JSONObject();
			jsonObject.put("BRANCH_ID","0");
			jsonObject.put("BRANCH_NAME","ALL");
			jsonArray.put(jsonObject);
			while (rs.next()) {
				jsonObject = new JSONObject();
				jsonObject.put("BRANCH_ID", rs.getString("BRANCH_ID"));
				jsonObject.put("BRANCH_NAME", rs.getString("BRANCH_NAME"));
				jsonArray.put(jsonObject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jsonArray;
	}	
	//--------------------Added for RoutestudentDetails 1.BRANCHLIST POPUP-----------------------------//
	public JSONArray getBranchListForPopUp(int systemId,int customerId) {
		PreparedStatement pstmt = null;
		Connection con = null;
		ResultSet rs = null;
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject = new JSONObject();
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(SchoolStatments.GET_BRANCH_LIST_POPUP);
			pstmt.setInt(1,systemId);
			pstmt.setInt(2,customerId);
			rs = pstmt.executeQuery();	
			while (rs.next()) {
				jsonObject = new JSONObject();
				jsonObject.put("Branch_Id", rs.getInt("BRANCH_ID"));
				jsonObject.put("Branch_Name", rs.getString("BRANCH_NAME"));
				jsonArray.put(jsonObject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jsonArray;
	}		
	//--------------------Added for RoutestudentDetails 1.ADD-----------------------------//

	public String RotueStudentDetailsInsert(String StudentName, String Standard,String Section, String Parentname, String ParentMobileNo,int countryCode,String emailId,String latitude,String longitude,String radius,String pickupCode,String dropType,int systemId,int customerId,int Branch){
		String studentRoute="";
		String studentTypes="";

		if(pickupCode.equals("") && dropType.equals("")){
			message="Please Select Type Should not be Empty.";
			return message;
		}else {
			if (pickupCode!=null && !pickupCode.equals("")) {
				studentTypes="pickup";
				studentRoute=pickupCode;
				typeAndRouteInsert(StudentName,Standard,Section,Parentname,ParentMobileNo,countryCode,emailId,latitude,longitude,radius,studentRoute,studentTypes,systemId,customerId,Branch);
			}
			if (dropType!=null && !dropType.equals("")) {
				studentTypes="drop";
				studentRoute=dropType;
				typeAndRouteInsert(StudentName,Standard,Section,Parentname,ParentMobileNo,countryCode,emailId,latitude,longitude,radius,studentRoute,studentTypes,systemId,customerId,Branch);
			}
		}
		return message;
	}

	public String typeAndRouteInsert(String studentName, String standard, String Section,String parentname, String parentMobileNo, int countryCode, String emailId, String latitude, String longitude, String radius, String studentRoute, String studentTypes, int systemId, int customerId,int Branch){
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs3 = null;
		try{
			int Insertcount = 0;
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(SchoolStatments.ROUTE_STUDENT_DETAILS_INSERT);
			pstmt.setString(1,studentName);
			pstmt.setString(2,standard);
			pstmt.setString(3, Section);
			pstmt.setString(4,parentname);
			pstmt.setString(5,parentMobileNo);
			pstmt.setInt(6, countryCode);
			pstmt.setString(7,emailId);
			pstmt.setDouble(8,Double.parseDouble(latitude));
			pstmt.setDouble(9,Double.parseDouble(longitude));
			pstmt.setString(10,radius);
			pstmt.setString(11,studentRoute);
			pstmt.setString(12,studentTypes);
			pstmt.setInt(13,Branch);
			pstmt.setInt(14, systemId);
			pstmt.setInt(15,customerId);
			Insertcount = pstmt.executeUpdate();
			if (Insertcount > 0) {
				message = "<p>Route "+ "'" +studentName+ "'" +" Student Details added successfully..</p>";
			}
		} catch (Exception e) {
			message = "<p  >Error While Adding Student Details and the Error is "
				+ e.toString() + "</p>";
			System.out.println("Error in RouteStudentDetailsInsert method..." + e);
			e.printStackTrace();
		}finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs3);
		}

		return message;
	}

	public String RotueStudentDetailsUpdate(String StudentName,String Standard,String Section, String Parentname, String ParentMobileNo,int countryCode,String emailId,String latitude,String longitude,String radius,String pickupCode,String dropType,int systemId,
			int customerId,String pickupUniqueId,String dropUniqueId,String pickupGrid,String dropGrid,int Branch){
		String studentRoute="";
		String studentTypes="";

		if (!pickupCode.equals(pickupGrid)&& pickupUniqueId.equals("")) {
			studentTypes="pickup";
			studentRoute=pickupCode;
			typeAndRouteInsert(StudentName,Standard,Section,Parentname,ParentMobileNo,countryCode,emailId,latitude,longitude,radius,studentRoute,studentTypes,systemId,customerId,Branch);
		}
		if (!dropType.equals(dropGrid)&& dropUniqueId.equals("")) {
			studentTypes="drop";
			studentRoute=dropType;
			typeAndRouteInsert(StudentName,Standard,Section ,Parentname,ParentMobileNo,countryCode,emailId,latitude,longitude,radius,studentRoute,studentTypes,systemId,customerId,Branch);
		}

		ArrayList <String>al = new ArrayList<String>();
		if (!pickupUniqueId.equals("")) {
			al.add(pickupUniqueId);
		}
		if (!dropUniqueId.equals("")) {
			al.add(dropUniqueId);
		}
		for(int i = 0 ; i < al.size(); i++)
		{  
			if (pickupUniqueId!=null && !pickupUniqueId.equals("")) {
				studentTypes="pickup";				
				if(pickupCode!=null && !pickupCode.equals("")){
					studentRoute=pickupCode;
				}else{
					studentRoute = null;
				}				
				typeAndRouteUpdate(StudentName,Standard,Section,Parentname,ParentMobileNo,countryCode,emailId,latitude,longitude,radius,studentRoute,studentTypes,systemId,customerId,pickupUniqueId,Branch);
			}
			if(dropUniqueId!=null&&!dropUniqueId.equals("")){
				studentTypes="drop";
				if(dropType!=null&&!dropType.equals("")){
					studentRoute=dropType;	
				}else{
					studentRoute = null;
				}

				typeAndRouteUpdate(StudentName,Standard,Section,Parentname,ParentMobileNo,countryCode,emailId,latitude,longitude,radius,studentRoute,studentTypes,systemId,customerId,dropUniqueId,Branch);
			}
		}
		return message;
	}  
	public String typeAndRouteUpdate(String studentName, String standard,String section, String parentname, String parentMobileNo, int countryCode, String emailId, String latitude, String longitude, String radius, String studentRoute, String studentTypes, int systemId, int customerId, String uniqueId,int Branch){
		Connection con = null;
		PreparedStatement pstmt2 = null;
		ResultSet rs3 = null;
		try {
			int updateCount = 0;
			con = DBConnection.getConnectionToDB("AMS");
			pstmt2 = con.prepareStatement(SchoolStatments.ROUTE_STUDENT_DETAILS_UPDATE);
			pstmt2.setString(1,studentName);
			pstmt2.setString(2,standard);
			pstmt2.setString(3,section);
			pstmt2.setString(4,parentname);
			pstmt2.setString(5,parentMobileNo);
			pstmt2.setInt(6, countryCode);
			pstmt2.setString(7,emailId);
			pstmt2.setDouble(8,Double.parseDouble(latitude));
			pstmt2.setDouble(9,Double.parseDouble(longitude));
			pstmt2.setString(10,radius);
			pstmt2.setString(11,studentRoute);
			pstmt2.setString(12,studentTypes);
			pstmt2.setInt(13, Branch);
			pstmt2.setInt(14, systemId);
			pstmt2.setInt(15,customerId);
			pstmt2.setString(16,uniqueId);
			updateCount = pstmt2.executeUpdate();
			if (updateCount > 0) {
				message = "<p>Route "+ "'" +studentName+ "'" +" Student Details updated successfully..</p>";
			}
		} catch (Exception e) {
			message = "<p  >Error While Adding Student Details Update and the Error is "
				+ e.toString() + "</p>";
			System.out.println("Error in RouteStudentDetailsInsert method..." + e);
			e.printStackTrace();
		}finally {
			DBConnection.releaseConnectionToDB(con, pstmt2, rs3);
		}
		return message;
	}

	public String deleteRoueStudentDetails(String studentName,String pickupuniqueId,String dropUniqueId,int customerId,int systemId){
		ArrayList <String>al = new ArrayList<String>();
		if (!pickupuniqueId.equals("")) {
			al.add(pickupuniqueId);
		} if(!dropUniqueId.equals("")) {
			al.add(dropUniqueId);
		}
		for(int i = 0 ; i < al.size(); i++)
		{ 
			if (!pickupuniqueId.equals("")) {
				deleteStudentDetailsBasebOnUniqueid(studentName,pickupuniqueId,customerId,systemId);
			}
			if (!dropUniqueId.equals("")) {
				deleteStudentDetailsBasebOnUniqueid(studentName,dropUniqueId,customerId,systemId);
			}
		}
		return message;
	} 

	public String deleteStudentDetailsBasebOnUniqueid(String StudentName,String uniqueId, int customerId, int systemId){
		Connection con=null;
		PreparedStatement pstmt=null;
		int deleted=0;
		try{
			con=DBConnection.getConnectionToDB("AMS");
			pstmt=con.prepareStatement(SchoolStatments.DELETE_ROUTE_STUDENT_DETAILS);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, customerId);
			pstmt.setString(3, uniqueId);
			deleted=pstmt.executeUpdate();
			if(deleted>0)
			{
				message="Route "+ "'" +StudentName+ "'"+" Student Details Information Deleted Successfully.";
			}
		}catch(Exception e){
			System.out.println("Error In deleteRoueAllocationDetails --- "+e.toString());
			e.printStackTrace();
		}finally {
			DBConnection.releaseConnectionToDB(con, pstmt, null);
		}
		return message;
	}
/***********************************************************end Student Details********************************/
	public ArrayList < Object > getClassInfoReport(int offset,int systemId, int customerId) {
		JSONArray JsonArray = new JSONArray();
		JSONObject JsonObject = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		ArrayList < Object > finlist = new ArrayList < Object > ();
		try {
			int count = 0;
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(SchoolStatments.GET_CLASS_INFORMATION_REPORT);
			pstmt.setInt(1,offset);
			pstmt.setInt(2, systemId);
			pstmt.setInt(3, customerId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				JsonObject = new JSONObject();
				count++;
				JsonObject.put("slnoIndex", count);
				JsonObject.put("classIndex", rs.getString("CLASS").toUpperCase());
				JsonObject.put("supervisorIDIndex", rs.getString("SUPERVISOR_ID"));
				JsonObject.put("supervisorNameIndex", rs.getString("SUPERVISOR_NAME"));
				JsonObject.put("createdByIndex", rs.getString("CREATED_NAME"));
				JsonObject.put("createdTimeIndex", rs.getString("CREATED_TIME"));
				JsonObject.put("IDIndex", rs.getString("ID"));
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


	public String insertClassInfo(int custId, String classname, String supervisorName,int systemId, int userId) {
		Connection con = null;
		PreparedStatement pstmt = null;
		PreparedStatement pstmt1 = null;
		ResultSet rs = null;
		String message = "";
		int count = 0;
		try{
			con=DBConnection.getConnectionToDB("AMS");
			pstmt=con.prepareStatement(SchoolStatments.CHECK_EXISTING_CLASSNAME_INSERT);
			pstmt.setInt(1, custId);
			pstmt.setInt(2, systemId);
			pstmt.setString(3, classname.toLowerCase());
			rs = pstmt.executeQuery();
			if (rs.next()) {
				count = rs.getInt("COUNT");
			}

			if(count == 0)
			{
				//con = DBConnection.getConnectionToDB("AMS");
				pstmt1 = con.prepareStatement(SchoolStatments.INSERT_CLASS_INFORMATION);
				pstmt1.setString(1, classname.toLowerCase());
				pstmt1.setString(2, supervisorName);
				pstmt1.setInt(3, systemId);
				pstmt1.setInt(4, custId);
				pstmt1.setInt(5, userId);
				int inserted = pstmt1.executeUpdate();
				if (inserted > 0) {
					message = "Saved Successfully";
				}
				con.commit();
			}
			else{
				message = "Class Name Already Exists.";
			}
		}	
		catch (Exception e) {
			e.printStackTrace();
		} 

		finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
			DBConnection.releaseConnectionToDB(null, pstmt1, null);
		}
		return message;
	}

	public String modifyClassInfo(int offset,int custId, String className, String supervisorID, int systemId,int userId,int ID,String gridclass) {
		Connection con = null;
		PreparedStatement pstmt = null;
		PreparedStatement pstmt1 = null;
		PreparedStatement pstmt2 = null;
		PreparedStatement pstmt3 = null;
		ResultSet rs = null;
		String message = "";
		int count = 0;
		try{
			con=DBConnection.getConnectionToDB("AMS");
			pstmt=con.prepareStatement(SchoolStatments.CHECK_EXISTING_CLASSNAME_MODIFY);
			pstmt.setInt(1, custId );
			pstmt.setInt(2, systemId);
			pstmt.setString(3, className.toLowerCase());
			pstmt.setInt(4, ID);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				count = rs.getInt("COUNT");
			}
			if(count == 0)
			{
				pstmt2 = con.prepareStatement(SchoolStatments.UPDATE_CLASS_INFO);
				pstmt2.setString(1, className.toLowerCase());
				pstmt2.setString(2, supervisorID);
				pstmt2.setInt(3, userId);	      
				pstmt2.setInt(4, custId);
				pstmt2.setInt(5, systemId);
				pstmt2.setInt(6, ID);

				int updated = pstmt2.executeUpdate();
				if (updated > 0) {
					if(!className.equalsIgnoreCase(gridclass))
					{
						pstmt3 = con.prepareStatement(SchoolStatments.UPDATE_ROUTE_STUDENT_CLASS);
						pstmt3.setString(1, className.toLowerCase());
						pstmt3.setString(2, gridclass.toLowerCase());
						pstmt3.setInt(3, custId);
						pstmt3.setInt(4, systemId);
						pstmt3.executeUpdate();
						pstmt3 = con.prepareStatement(SchoolStatments.UPDATE_SCHOOL_HOLIDAY_LIST);
						pstmt3.setString(1, className.toLowerCase());
						pstmt3.setString(2, gridclass.toLowerCase());
						pstmt3.setInt(3, systemId);
						pstmt3.setInt(4, custId);
						pstmt3.executeUpdate();
						message = "Updated Successfully";
					}
				}
				message = "Updated Successfully..";
			}else
				message = "Class Name Already Exists..";
		} 
		catch (Exception e) {
			e.printStackTrace();

		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, null);
			DBConnection.releaseConnectionToDB(null, pstmt1, null);
			DBConnection.releaseConnectionToDB(null, pstmt2, null);
			DBConnection.releaseConnectionToDB(null, pstmt3, null);
		}
		return message;
	}


	public String deleteRecord(int custId, int systemId,int ID,String gridclass) {
		Connection con = null;
		PreparedStatement pstmt = null;
		PreparedStatement pstmt1 = null;
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(SchoolStatments.DELETE_CLASS_INFORMATION);
			pstmt.setInt(1, custId);
			pstmt.setInt(2, systemId);
			pstmt.setInt(3, ID);

			int deleted = pstmt.executeUpdate();
			if (deleted > 0) {
				try{
					pstmt1 = con.prepareStatement(SchoolStatments.UPDATE_ROUTE_STUDENT);
					pstmt1.setString(1, gridclass.toLowerCase());
					pstmt1.setInt(2, custId);
					pstmt1.setInt(3, systemId);
					pstmt1.executeUpdate();
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
			message = "Deleted Successfully";
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, null);
			DBConnection.releaseConnectionToDB(null, pstmt1, null);
		}
		return message;
	}

	public JSONArray getUserNames(String custID,int systemId) {
		JSONArray JsonArray = new JSONArray();
		JSONObject JsonObject = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			JsonArray = new JSONArray();
			JsonObject = new JSONObject();
			con = DBConnection.getConnectionToDB("ADMINISTRATOR");
			pstmt = con.prepareStatement(SchoolStatments.GET_USER_NAMES);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, Integer.parseInt(custID));
			rs = pstmt.executeQuery();
			while (rs.next()) {
				JsonObject = new JSONObject();
				int snId = rs.getInt("ID");
				String snName = rs.getString("NAME");
				JsonObject.put("snId", snId);
				JsonObject.put("snName", snName);
				JsonArray.put(JsonObject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}

		return JsonArray;
	}

	/**
	 * @author shivadarshan
	 * *****************************************************Branch Master Functions
	 * @param offset *****************************************
	 */
	//TODO
	public ArrayList < Object > getBranchMasterDetails(int systemId,int customerId,String language,String Zone, int offset) {
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject = null;
		Connection con = null;
		PreparedStatement pstmt2 = null;
		ResultSet rs2 = null;

		ArrayList < ReportHelper > reportsList = new ArrayList < ReportHelper > ();
		ArrayList < String > headersList = new ArrayList < String > ();
		ReportHelper finalreporthelper = new ReportHelper();
		ArrayList < Object > finlist = new ArrayList < Object > ();
		try {
			int countNO = 0;
			con = DBConnection.getConnectionToDB("AMS");
			pstmt2 = con.prepareStatement(cf.getLocationQuery(SchoolStatments.GET_ALL_BRANCH_MASTER_DETAILS, Zone));
			pstmt2.setInt(1, offset);
			pstmt2.setInt(2, systemId);
			pstmt2.setInt(3, customerId);
			rs2 = pstmt2.executeQuery();
			while (rs2.next()) {
				jsonObject = new JSONObject();
				ArrayList < Object > informationList = new ArrayList < Object > ();
				countNO++;
				ReportHelper reporthelper = new ReportHelper();

				int branchID=rs2.getInt("BRANCH_ID");
				String branchName = rs2.getString("CUST_BRANCH_ID");
				String groupID = rs2.getString("GROUP_ID");
				String groupName = rs2.getString("GROUP_NAME");
				String countryName = rs2.getString("COUNTRY_NAME");
				String countryID = rs2.getString("COUNTRY_ID");
				String stateName= rs2.getString("STATE_NAME");
				String stateID = rs2.getString("STATE_ID");
				String city = rs2.getString("CITY");
				String contactNumber = rs2.getString("CONTACT_NO");
				String emailId = rs2.getString("EMAIL_ID");
				String mobile = rs2.getString("MOBILE_NO");
				String hubName = rs2.getString("HUBNAME");
				String hubID = rs2.getString("HUB_ID");
				String createdByName = rs2.getString("CREATED_USERNAME");
				String createdTime = rs2.getString("CREATED_TIME");

				jsonObject.put("slnoDataIndex",countNO);
				informationList.add(countNO);

				jsonObject.put("BranchNameDataIndex",branchName);
				informationList.add(branchName);

				jsonObject.put("ModifyGroupIDDataIndex",groupID);
				jsonObject.put("GroupIDDataIndex",groupName);
				informationList.add(groupName);

				jsonObject.put("ModifyCountryIDDataIndex",countryID);
				jsonObject.put("CountryDataIndex",countryName);
				informationList.add(countryName);

				jsonObject.put("ModifyStateIDDataIndex",stateID);
				jsonObject.put("StateDataIndex", stateName);
				informationList.add(stateName);

				jsonObject.put("CityDataIndex",city);
				informationList.add(city);

				jsonObject.put("ContactNumberDataIndex",contactNumber);
				informationList.add(contactNumber);

				jsonObject.put("EmailIdDataIndex",emailId);
				informationList.add(emailId); 

				jsonObject.put("MobileDataIndex",mobile);
				informationList.add(mobile); 

				jsonObject.put("ModifyHubIDDataIndex",hubID);
				jsonObject.put("HubIDDataIndex",hubName);
				informationList.add(hubName); 

				jsonObject.put("createdNameDataIndex",createdByName);
				informationList.add(createdByName);

				jsonObject.put("createdTimeDataIndex",createdTime);
				informationList.add(createdTime);

				jsonObject.put("IdDataIndex", branchID);

				jsonArray.put(jsonObject);
				reporthelper.setInformationList(informationList);
				reportsList.add(reporthelper);

			}
			finlist.add(jsonArray);
			finalreporthelper.setReportsList(reportsList);
			finalreporthelper.setHeadersList(headersList);
			finlist.add(finalreporthelper);
		} catch (Exception e) {
			e.printStackTrace();
		}finally {
			DBConnection.releaseConnectionToDB(con, pstmt2, rs2);
		}
		return finlist;
	}

	/**
	 * getting country list from db
	 * @return
	 */
	public JSONArray getCountryNameList() {
		Connection conAdmin=null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject = new JSONObject();
		try {
			conAdmin=DBConnection.getConnectionToDB("ADMINISTRATOR");
			pstmt=conAdmin.prepareStatement(SchoolStatments.GET_COUNTRY_LIST);
			rs=pstmt.executeQuery();
			while(rs.next()){
				jsonObject = new JSONObject();
				jsonObject.put("CountryID", rs.getString("COUNTRY_CODE"));
				jsonObject.put("CountryName", rs.getString("COUNTRY_NAME"));
				jsonArray.put(jsonObject);
			}

		} catch (Exception e) {
			System.out.println("Error in School Functions:-getCountryList "+e.toString());
		}finally{
			DBConnection.releaseConnectionToDB(conAdmin, pstmt, rs);
		}
		return jsonArray;
	}
	/***
	 * function for getting State Name List from db
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
			pstmt=conAdmin.prepareStatement(SchoolStatments.GET_STATE_LIST);
			pstmt.setInt(1, countrycode);
			rs=pstmt.executeQuery();
			while(rs.next()){
				jsonObject=new JSONObject();
				jsonObject.put("StateID", rs.getString("STATE_CODE"));
				jsonObject.put("StateName", rs.getString("STATE_NAME"));
				jsonArray.put(jsonObject);
			}

		} catch (Exception e) {
			System.out.println("Error in School Functions:-getStateList "+e.toString());
		}finally{
			DBConnection.releaseConnectionToDB(conAdmin, pstmt, rs);
		}
		return jsonArray;
	}

	public String deleteBranchMasterDetails(int uniqueId,int customerId,int systemId){
		Connection con=null;
		PreparedStatement pstmt=null,pstmt1=null;
		int deleted=0;
		try{
			con=DBConnection.getConnectionToDB("AMS");
			pstmt=con.prepareStatement(SchoolStatments.DELETE_BRANCH_MASTER_DETAILS);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, customerId);
			pstmt.setInt(3, uniqueId);
			deleted=pstmt.executeUpdate();
			if(deleted>0)
			{
				pstmt1=con.prepareStatement(SchoolStatments.UPDATE_ROUTE_STUDENT_DETAILS_BRANCHID);
				pstmt1.setInt(1, systemId);
				pstmt1.setInt(2, customerId);
				pstmt1.setInt(3, uniqueId);
				pstmt1.executeUpdate();
				pstmt1.close();
				message="Branch Information Deleted Successfully";
			}else{
				message="Error";
			}

		}catch(Exception e){
			System.out.println("Error In deleteBranchMasterDetails --- "+e.toString());
			e.printStackTrace();
		}finally {
			DBConnection.releaseConnectionToDB(con, pstmt, null);
			DBConnection.releaseConnectionToDB(null, pstmt1, null);
		}
		return message;
	}

	public String BranchMasterDetailsInsert(int GroupID, String branchName, int country, int state, String city, 
			String contactNumber, String emailId, String mobile, int hubId, int systemId, int custId, int userId) {

		Connection con = null;
		PreparedStatement pstmt = null, pstmt3 = null;
		ResultSet rs3 = null;
		int count = 0;
		try{
			int Insertcount = 0;
			con = DBConnection.getConnectionToDB("AMS");
			pstmt3 = con.prepareStatement(SchoolStatments.CHECKING_GROUP_ID);
			pstmt3.setInt(1, GroupID);
			rs3= pstmt3.executeQuery();
			while(rs3.next()){
				count = rs3.getInt("COUNT");
			}
			if (count == 0) {
				pstmt = con
				.prepareStatement(SchoolStatments.BRANCH_MASTER_DETAILS_INSERT);
				pstmt.setString(1, branchName);
				pstmt.setInt(2, GroupID);
				pstmt.setInt(3, country);
				pstmt.setInt(4, state);
				pstmt.setString(5, city);
				pstmt.setString(6, contactNumber);
				pstmt.setString(7, emailId);
				pstmt.setString(8, mobile);
				pstmt.setInt(9, hubId);
				pstmt.setInt(10, custId);
				pstmt.setInt(11, systemId);
				pstmt.setInt(12, userId);
				Insertcount = pstmt.executeUpdate();
				if (Insertcount > 0) {
					message = "<p>Branch Information added successfully..</p>";
				}
			}else
				message = "<p>Branch Name already exist......</p>";
		} catch (Exception e) {
			message = "<p  >Error While Branch Master Details and the Error is "
				+ e.toString() + "</p>";
			System.out.println("Error in BranchMasterInsert method..." + e);
			e.printStackTrace();
		}finally {
			DBConnection.releaseConnectionToDB(con, pstmt, null);
			DBConnection.releaseConnectionToDB(null, pstmt3, rs3);
		}

		return message;
	}

	public String BranchMasterDetailsUpdate(int GroupID, String branchName, int country, int state, String city, String contactNumber, 
			String emailId, String mobile, int hubId, int systemId, int custId, String uniqueId) {

		Connection con = null;
		PreparedStatement pstmt2 = null, pstmt3 = null;
		ResultSet rs3 = null;
		int count = 0;
		try {
			int updateCount = 0;
			con = DBConnection.getConnectionToDB("AMS");
			pstmt3 = con.prepareStatement(SchoolStatments.CHECKING_GROUP_ID_MODIFY);
			pstmt3.setInt(1, GroupID);
			pstmt3.setInt(2, Integer.parseInt(uniqueId));
			rs3= pstmt3.executeQuery();
			while(rs3.next()){
				count = rs3.getInt("COUNT");
			}

			if (count == 0) {
				pstmt2 = con
				.prepareStatement(SchoolStatments.BRANCH_MASTER_DETAILS_UPDATE);
				pstmt2.setString(1, branchName);
				pstmt2.setInt(2, GroupID);
				pstmt2.setInt(3, country);
				pstmt2.setInt(4, state);
				pstmt2.setString(5, city);
				pstmt2.setString(6, contactNumber);
				pstmt2.setString(7, emailId);
				pstmt2.setString(8, mobile);
				pstmt2.setInt(9, hubId);
				pstmt2.setInt(10, systemId);
				pstmt2.setInt(11, custId);
				pstmt2.setInt(12, Integer.parseInt(uniqueId));
				updateCount = pstmt2.executeUpdate();
				if (updateCount > 0) {
					message = "<p>Branch Information updated successfully..</p>";
				}
			}else
				message = "<p>Branch Name already exist...</p>";
		} catch (Exception e) {
			message = "<p  >Error While Adding Branch Master Details Update and the Error is "
				+ e.toString() + "</p>";
			System.out.println("Error in BranchMasterDetailsUpdate method..." + e);
			e.printStackTrace();
		}finally {
			DBConnection.releaseConnectionToDB(con, pstmt2, rs3);
			DBConnection.releaseConnectionToDB(null, pstmt3, null);
		}
		return message;
	}

	public JSONArray getHubIDforBranchMaster(String customerid,String systemId,String Zone){

		JSONArray JsonArray = new JSONArray();
		JSONObject JsonObject = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;		
		ResultSet rs = null;

		try{
			JsonArray = new JSONArray();
			JsonObject = new JSONObject();

			con = DBConnection.getConnectionToDB("AMS");		

			pstmt=con.prepareStatement(cf.getLocationQuery(SchoolStatments.GET_START_END_LOCATION_BASED_ON_OPERATIONAL_ID, Zone));
			pstmt.setString(1, systemId);
			pstmt.setString(2, customerid);

			rs=pstmt.executeQuery();

			while(rs.next())
			{
				JsonObject = new JSONObject();
				JsonObject.put("NAME", rs.getString("NAME"));
				JsonObject.put("VALUE", rs.getString("HUBID"));
				JsonArray.put(JsonObject);
			}

		}catch(Exception e){
			e.printStackTrace();
		}finally{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return JsonArray;

	}

	/**
	 * *****************************************************Branch Master Functions End*****************************************
	 */
	/**********************************************************************Holiday_List*************************************************************/
	/**
	 * @author Santhosh.
	 */
	public JSONArray getStandardListForHoliday(int systemId,int customerId) {
		PreparedStatement pstmt = null;
		Connection con = null;
		ResultSet rs = null;
		JSONArray jsonArray = new JSONArray();
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(SchoolStatments.GET_STANDARD_LIST_FROM_CLASS);
			pstmt.setInt(1,systemId);
			pstmt.setInt(2,customerId);
			rs = pstmt.executeQuery();
			JSONObject jsonObject = new JSONObject();
			jsonObject.put("STANDARD","All");
			jsonArray.put(jsonObject);
			while (rs.next()) {
				jsonObject = new JSONObject();
				jsonObject.put("STANDARD", rs.getString("STANDARD").toUpperCase());
				jsonArray.put(jsonObject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jsonArray;
	}
//----------------------------------------get Holiday details for Grid-------------------------------//
	public ArrayList < Object > getHolidayDetails(int systemId,int customerId,String language) {
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject = null;
		Connection con = null;
		PreparedStatement pstmt2 = null;
		ResultSet rs2 = null;

		ArrayList < ReportHelper > reportsList = new ArrayList < ReportHelper > ();
		ArrayList < String > headersList = new ArrayList < String > ();
		ReportHelper finalreporthelper = new ReportHelper();
		ArrayList < Object > aslist = new ArrayList < Object > ();

		try {
			int countNO = 0;
			//SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
			con = DBConnection.getConnectionToDB("AMS");
			pstmt2 = con.prepareStatement(SchoolStatments.GET_HOLIDAY_LIST_DETAILS);
			pstmt2.setInt(1, systemId);
			pstmt2.setInt(2, customerId);
			rs2 = pstmt2.executeQuery();

			while (rs2.next()) {
				jsonObject = new JSONObject();
				ArrayList < Object > informationList = new ArrayList < Object > ();
				countNO++;
				ReportHelper reporthelper = new ReportHelper();
				String Standard=rs2.getString("STANDARD");
				Date fromDate=rs2.getDate("FROM_DATE");
				Date toDate=rs2.getDate("TO_DATE");
				int Days= rs2.getInt("DAYS")+1;
				int Id=rs2.getInt("ID");

				jsonObject.put("slnoDataIndex",countNO);
				informationList.add(countNO);

				jsonObject.put("StandardDataIndex",Standard.toUpperCase());
				informationList.add(Standard.toUpperCase());

				if (fromDate !=null && !fromDate.equals("")) {

					jsonObject.put("FromDateDataIndex",fromDate);
					informationList.add(fromDate);
				}
				if (toDate!=null && !toDate.equals("")) {
					jsonObject.put("TodateDataIndex",toDate);
					informationList.add(toDate);
				}
				jsonObject.put("DaysDataIndex",Days);
				informationList.add(Days);

				jsonObject.put("IdDataIndex",Id);

				jsonArray.put(jsonObject);
				reporthelper.setInformationList(informationList);
				reportsList.add(reporthelper);
			}
			aslist.add(jsonArray);
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
	//-----------------------------------------------Holiday Details Insert------------------------------------------------//
	public String HolidayDetailsInsert(String Standard, String fromDate, String toDate,int systemId, int customerId){
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs3 = null;
		System.out.println(Standard);
		String standard=Standard.toLowerCase();
		if(standard.equals("all")){
			standard="All";
		}
		try{
			int Insertcount = 0;
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(SchoolStatments.HOLIDAY_INFORMATION_INSERT);
			pstmt.setString(1,standard);
			pstmt.setString(2,fromDate);
			pstmt.setString(3,toDate);
			pstmt.setInt(4, systemId);
			pstmt.setInt(5,customerId);
			Insertcount = pstmt.executeUpdate();
			if (Insertcount > 0) {
				message = "<p>Route "+ "'" +Standard+ "'" +" Student Details added successfully..</p>";
			}
		} catch (Exception e) {
			message = "<p  >Error While Adding Student Details and the Error is "
				+ e.toString() + "</p>";
			System.out.println("Error in RouteStudentDetailsInsert method..." + e);
			e.printStackTrace();
		}finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs3);
		}

		return message;
	}
	//------------------------------------------------------Holiday Details Update-------------------------------------------------//
	public String HolidayDetailsUpdate(String Standard, String fromDate, String toDate,int systemId, int customerId, String uniqueId){
		Connection con = null;
		PreparedStatement pstmt2 = null;
		ResultSet rs3 = null;
		String standard=Standard.toLowerCase();
		if(standard.equals("all")){
			standard="All";
		}
		try {
			int updateCount = 0;
			con = DBConnection.getConnectionToDB("AMS");
			pstmt2 = con.prepareStatement(SchoolStatments.HOLIDAY_INFORMATION_UPDATE);
			pstmt2.setString(1,standard);
			pstmt2.setString(2,fromDate);
			pstmt2.setString(3,toDate);
			pstmt2.setInt(4, systemId);
			pstmt2.setInt(5,customerId);	
			pstmt2.setString(6,uniqueId);
			updateCount = pstmt2.executeUpdate();
			if (updateCount > 0) {
				message = "<p>Route "+ "'" +Standard+ "'" +" Student Details updated successfully..</p>";
			}
		} catch (Exception e) {
			message = "<p  >Error While Adding Student Details Update and the Error is "
				+ e.toString() + "</p>";
			System.out.println("Error in RouteStudentDetailsInsert method..." + e);
			e.printStackTrace();
		}finally {
			DBConnection.releaseConnectionToDB(con, pstmt2, rs3);
		}
		return message;
	}
	
//---------------------------------------------Holiday Details Delete------------------------------------//	
	public String deleteHolidayDetails(String standard,int uniqueId,int customerId,int systemId){
		Connection con=null;
		PreparedStatement pstmt3=null;
		int deleted=0;
		try{
			con=DBConnection.getConnectionToDB("AMS");
			pstmt3=con.prepareStatement(SchoolStatments.DELETE_HOLIDAY_DETAILS);
			pstmt3.setInt(1, systemId);
			pstmt3.setInt(2, customerId);
			pstmt3.setInt(3, uniqueId);
			deleted=pstmt3.executeUpdate();
			if(deleted>0)
			{ 
				message="Holiday Information "+ standard +" Deleted Successfully";
			}else{
				message="Error";
			}

		}catch(Exception e){
			System.out.println("Error In deleteHolidayDetails --- "+e.toString());
			e.printStackTrace();
		}finally {
			DBConnection.releaseConnectionToDB(con, pstmt3, null);
		}
		return message;
	}
	//------------------------------------------------holiday Calendar------------------------------------//
	public String getList(int systemId, int customerId) {
		PreparedStatement pstmt = null;
		Connection con = null;
		ResultSet rs = null;
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject = new JSONObject();
		JSONObject start = new JSONObject();
		JSONObject end = new JSONObject();
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(SchoolStatments.Get_LIST);
			//System.out.println(SchoolStatments.Get_LIST);
			pstmt.setInt(1,systemId);
			pstmt.setInt(2,customerId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				jsonObject = new JSONObject();
				String title=rs.getString("TITLE");
				jsonObject.put("title",title.toUpperCase());
				String sdate=rs.getString("START");
				start = new JSONObject();
				start.put("date",sdate);
				start.put("time",".");
				jsonObject.put("start",start);
				end = new JSONObject();
				String edate= rs.getString("Ends");
				end.put("date", edate);
				end.put("time",".");
				jsonObject.put("end",end);
				jsonObject.put("location","Holiday");
				jsonObject.put("color","green");
				jsonArray.put(jsonObject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jsonArray.toString().replaceAll("\"", "").replace("[", "").replace("]", "");
	}
	
	public ArrayList<Object> getSMSReport(int systemId,int clientId,String startDate,String endDate,String language,int offset){
		
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject = null;
		
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		int count = 0;
		
		ArrayList<ReportHelper> reportsList = new ArrayList<ReportHelper>();
		ArrayList<String> headersList = new ArrayList<String>();
		ReportHelper finalreporthelper = new ReportHelper();
		ArrayList<Object> SMSReportFinalList = new ArrayList<Object>();

		
		headersList.add(cf.getLabelFromDB("SLNO",language));
		headersList.add(cf.getLabelFromDB("Vehicle_No",language));
		headersList.add(cf.getLabelFromDB("Route_and_Type",language));
		headersList.add(cf.getLabelFromDB("Parent_Name",language));
		headersList.add(cf.getLabelFromDB("Contact_No",language));
		headersList.add(cf.getLabelFromDB("Message",language));
		headersList.add(cf.getLabelFromDB("SMS_Trigger_Time",language));
		headersList.add(cf.getLabelFromDB("Driver_Name",language));
		
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(SchoolStatments.GET_SMS_TO_PARENT_DETAILS);
			pstmt.setInt(1,offset);
			pstmt.setInt(2,systemId);
			pstmt.setInt(3,clientId);
			pstmt.setString(4,startDate);
			pstmt.setString(5,endDate);
			pstmt.setInt(6,offset);
			pstmt.setInt(7,systemId);
			pstmt.setInt(8,clientId);
			pstmt.setString(9,startDate);
			pstmt.setString(10,endDate);
			rs = pstmt.executeQuery();
			while(rs.next()){
				jsonObject = new JSONObject();
				ReportHelper reporthelper = new ReportHelper();
				ArrayList<Object> informationList = new ArrayList<Object>();
				
				count++;

				jsonObject.put("slnoDataIndex", count);
				informationList.add(count);
				
				jsonObject.put("vehicleNoDataIndex", rs.getString("VehicleNo"));
				informationList.add(rs.getString("VehicleNo"));
				
				jsonObject.put("routeandTypeDataIndex", rs.getString("SchoolId"));
				informationList.add(rs.getString("SchoolId"));
				
				jsonObject.put("parentNameDataIndex", rs.getString("ParentName"));
				informationList.add(rs.getString("ParentName"));
				
				jsonObject.put("contactNoDataIndex", rs.getString("PhoneNo"));
				informationList.add(rs.getString("PhoneNo"));
				
				jsonObject.put("messageDataIndex", rs.getString("Message"));
				informationList.add(rs.getString("Message"));
				
				jsonObject.put("smsTriggerTimeDataIndex", rs.getString("InsertedTime"));
				informationList.add(rs.getString("InsertedTime"));
				
				jsonObject.put("driverNameDataIndex", rs.getString("SchoolDriverName"));
				informationList.add(rs.getString("SchoolDriverName"));
				

				jsonArray.put(jsonObject);
				reporthelper.setInformationList(informationList);
				reportsList.add(reporthelper);
			}
				SMSReportFinalList.add(jsonArray);
				finalreporthelper.setReportsList(reportsList);
				finalreporthelper.setHeadersList(headersList);
				SMSReportFinalList.add(finalreporthelper);
				
		} catch (Exception e) {
			e.printStackTrace();
		}
		finally{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return SMSReportFinalList;
	}  
}


